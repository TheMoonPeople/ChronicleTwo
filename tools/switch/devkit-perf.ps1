# Measures one scene of the libnx build and preserves its validation evidence in the area ledger.
#
#   tools/switch/devkit-perf.ps1 -Scene town -Target <serial> [-SdkRoot <NintendoSDK>] [-RunRoot <dir with data.zip>]
#
# The scene's --jump starts it directly with --fast-load. --perf-seconds waits for player control (or for the
# jumped mode when it has none), lets one second pass, logs one window a second and exits. KZ_PERF_LOG adds
# the renderer's canonical/display CPU and GPU samples to each window. Saves and the pipeline cache persist
# under SaveRoot, so only the first run on a unit compiles pipelines.
param(
    [string]$Scene = '',
    [switch]$Next,
    [string]$Ledger = (Join-Path $PSScriptRoot '..\..\docs\SWITCH-PERF.json'),
    # Records an independently decoded, inspected capture instead of launching another run.
    [string]$RecordCapture = '',
    [string]$Target = '',
    [string]$SdkRoot = $env:NINTENDO_SDK_ROOT,
    [string]$Build = (Join-Path $PSScriptRoot '..\..\port\build\switch'),
    [string]$Elf = '',
    # An NSO with a matching <path>.json conversion record avoids launching WSL.
    [string]$PreparedNso = '',
    [string]$RunRoot = (Join-Path $PSScriptRoot '..\..\port\run'),
    [string]$Image = 'kazarov-switch:chronicletwo-validation',
    [string]$OutputRoot = $env:TEMP,
    [ValidateSet('handheld', 'console')] [string]$Mode = 'handheld',
    [ValidateSet('normal', 'auto')] [string]$Performance = 'normal',
    [string]$SaveRoot = 'sdmc:/switch/chronicletwo/perf-saves',
    # Reserve warmup and scheduler slack inside the ten-second scene budget.
    [ValidateRange(1, 8)] [int]$Seconds = 8,
    [string]$Extra = '',
    [string]$Label = '',
    # Captures the screen while the scene is still running instead of after it exits.
    [switch]$Screenshot,
    # With -Screenshot: the log text that triggers the capture instead of the first perf window.
    [string]$ScreenshotPattern = 'perf window '
    ,
    # Captures a live scene without ending its measurement.
    [string]$CapturePattern = '',
    # Starts SDK video capture during the frozen hold and retains the completed timing sample.
    [string]$MovieCapturePattern = '',
    [string]$FailurePattern = '',
    [string]$CompletionPattern = 'perf total ',
    [string]$TargetManagerRecordPattern = '',
    [ValidateRange(1, 10)] [int]$TargetManagerRecordSeconds = 10,
    [switch]$TargetManagerScreenshot,
    [switch]$ExternalCapture,
    # Drives the run from this input script instead of the scene's own input.
    [string]$Replay = '',
    [string]$AttachmentAlphaAllowlist = '',
    [scriptblock]$GeneratedInputRetention = $null
)
$ErrorActionPreference = 'Stop'
if ($ExternalCapture -and ($Screenshot -or $CapturePattern -or $MovieCapturePattern)) {
    throw '-ExternalCapture cannot be combined with automatic capture options'
}

function ReadLedger {
    return Get-Content -LiteralPath $Ledger -Raw | ConvertFrom-Json -AsHashtable
}
function WriteLedger($state) {
    $path = [IO.Path]::GetFullPath($Ledger)
    $temporary = "$path.$([guid]::NewGuid().ToString('N')).tmp"
    [IO.File]::WriteAllText($temporary, ($state | ConvertTo-Json -Depth 40) + "`n")
    [IO.File]::Move($temporary, $path, $true)
}
function IsPassed($area) {
    return $area.status -in @('historical_submit_pacing_pass', 'capture_pass', 'native_presentation_pass')
}
function IsRequired($area) {
    return !$area.Contains('validation_required') -or [bool]$area.validation_required
}
function LedgerArea($state, $key) {
    $areas = @($state.areas | Where-Object { $_.scene -eq $key })
    if ($areas.Count -ne 1) { throw "The ledger must contain exactly one entry for $key" }
    return $areas[0]
}
function ActiveArea($state) {
    if ($state.Contains('workflow') -and $state.workflow.active_scene) {
        $active = LedgerArea $state $state.workflow.active_scene
        if ((IsRequired $active) -and !(IsPassed $active)) { return $active.scene }
    }
    $first = $state.areas | Where-Object { (IsRequired $_) -and !(IsPassed $_) -and $_.status -ne 'unsupported-direct-jump' } | Select-Object -First 1
    return $first.scene
}
function ReadStressValidation([string]$text, [string]$total) {
    $issues = [Collections.Generic.List[string]]::new()
    $records = @{}
    foreach ($kind in @('setup', 'summary')) {
        $matches = [regex]::Matches($text, "perf stress ${kind}:([^\r\n]+)")
        if ($matches.Count -ne 1) {
            $issues.Add("Stress evidence needs exactly one $kind record")
            continue
        }
        $fields = @{}
        foreach ($entry in [regex]::Matches($matches[0].Groups[1].Value, '(\w+)=([^\s]+)')) {
            $key = $entry.Groups[1].Value
            if ($fields.ContainsKey($key)) { $issues.Add("Duplicate stress $kind field: $key") }
            $fields[$key] = $entry.Groups[2].Value
        }
        $records[$kind] = $fields
        foreach ($pair in @{schema='1';dungeon='0';floor='3';seed='1';expected_enemies='10';expected_chests='10';scope='canonical30Hz';ai_enabled='1';animation_enabled='1'}.GetEnumerator()) {
            if ($fields[$pair.Key] -cne $pair.Value) { $issues.Add("Invalid stress $kind field: $($pair.Key)") }
        }
        [ulong]$generation = 0
        if (![ulong]::TryParse($fields.generation, [ref]$generation) -or $generation -eq 0) {
            $issues.Add("Invalid stress $kind generation")
        }
    }
    if ($records.setup -and $records.summary) {
        if ($records.setup.generation -cne $records.summary.generation) { $issues.Add('Stress generations differ') }
        [ulong]$priority = 0
        if ($records.setup.fixed_camera -cne '1' -or
            ![ulong]::TryParse($records.setup.priority_limit, [ref]$priority) -or $priority -lt 10 -or
            !$records.setup.room_id -or !$records.setup.layout_id) {
            $issues.Add('Stress camera, room, layout or monster priority evidence is missing')
        }
        [ulong]$ticks = 0
        $tickMatch = [regex]::Match($total, 'perf total [^\r\n]*? ticks (\d+)')
        if (![ulong]::TryParse($records.summary.canonical_ticks, [ref]$ticks) -or $ticks -eq 0 -or
            !$tickMatch.Success -or [Math]::Abs([double]$ticks - [double]$tickMatch.Groups[1].Value) -gt 1) {
            $issues.Add('Stress observations do not cover the measured canonical ticks')
        }
        if ($records.summary.failures -cne '0') { $issues.Add('Stress visibility or live-state checks failed') }
        foreach ($kind in @('enemies', 'chests')) {
            foreach ($metric in @('live', 'submitted', 'projected_ray')) {
                foreach ($bound in @('min', 'max')) {
                    $key = "${kind}_${metric}_${bound}"
                    if ($records.summary[$key] -cne '10') { $issues.Add("Stress count is not exactly ten: $key") }
                }
            }
        }
    }
    return [ordered]@{
        accepted = $issues.Count -eq 0
        errors = @($issues.ToArray())
        setup = $records.setup
        summary = $records.summary
        scope = 'Canonical 30 Hz body witnesses and map rays; inspected video supplies visual distinction, not a final-pixel or every-interpolated-frame certificate.'
    }
}
function ReadPreparedNso($path, $elfHash) {
    $resolved = (Resolve-Path -LiteralPath $path).Path
    $conversion = Get-Content -LiteralPath "$resolved.json" -Raw | ConvertFrom-Json -AsHashtable
    $nsoHash = (Get-FileHash -LiteralPath $resolved -Algorithm SHA256).Hash
    if ($conversion.elf_sha256 -ne $elfHash -or $conversion.nso_sha256 -ne $nsoHash -or
        $conversion.image_id -notmatch '^sha256:[0-9a-f]{64}$') {
        throw 'Prepared NSO conversion record does not match the exact ELF, NSO and toolchain image'
    }
    $stream = [IO.File]::OpenRead($resolved)
    try {
        $magic = [byte[]]::new(4)
        if ($stream.Read($magic, 0, 4) -ne 4 -or [Text.Encoding]::ASCII.GetString($magic) -ne 'NSO0') {
            throw 'Prepared NSO does not have an NSO0 header'
        }
    } finally { $stream.Dispose() }
    return @{ path = $resolved; hash = $nsoHash; image_id = $conversion.image_id }
}
function ReadNativeHistory($text, [double]$requiredSeconds) {
    $issues = [Collections.Generic.List[string]]::new()
    $report = [ordered]@{
        scope = 'Native BufferQueue Presented timestamps through the SDK VI frame-history protocol'
        accepted = $false; errors = @(); measured_seconds = 0.0; frames = 0; intervals = 0
        nominal_interval_ns = 1000000000.0 / 60; interval_tolerance_ns = 500000
    }
    $starts = [regex]::Matches($text, 'perf native history begin: ([^\r\n]+)')
    $ends = [regex]::Matches($text, 'perf native history end: ([^\r\n]+)')
    if ($starts.Count -ne 1 -or $ends.Count -ne 1) {
        $report.errors = @('Exactly one complete native history report is required')
        return $report
    }
    $numbers = { param($line)
        $values = @{}
        foreach ($item in [regex]::Matches($line, '([a-z_]+)=(\d+)')) {
            $values[$item.Groups[1].Value] = [ulong]$item.Groups[2].Value
        }
        return $values
    }
    $start = & $numbers $starts[0].Groups[1].Value
    $end = & $numbers $ends[0].Groups[1].Value
    $integrityFields = @('query_errors', 'missing_ids', 'conflicts', 'overflow', 'invalid_clock', 'stale_history', 'invalid_mode', 'unresolved')
    foreach ($field in @('instance', 'begin_ns', 'end_ns', 'clock_hz', 'records')) {
        if (!$start.ContainsKey($field)) { $issues.Add("Missing native boundary field: $field") }
    }
    foreach ($field in @('records', 'queries', 'query_total_ns', 'query_max_ns') + $integrityFields) {
        if (!$end.ContainsKey($field)) { $issues.Add("Missing native integrity field: $field") }
    }
    if ($issues.Count) { $report.errors = @($issues.ToArray()); return $report }
    $report.boundaries = $start
    $report.integrity = $end
    foreach ($field in $integrityFields) {
        if ($end[$field] -ne 0) { $issues.Add("Native history $field is nonzero") }
    }
    if (!$start.instance -or $start.clock_hz -ne 19200000 -or !$end.queries -or $start.end_ns -le $start.begin_ns) {
        $issues.Add('Invalid native clock, lifetime or collection boundaries')
    }
    $duration = ([decimal]$start.end_ns - [decimal]$start.begin_ns) / 1000000000
    $report.measured_seconds = [double]$duration
    if ($requiredSeconds -lt 1 -or $requiredSeconds -gt 8 -or $duration -lt $requiredSeconds - 0.001 -or $duration -gt $requiredSeconds + 0.05) {
        $issues.Add('Native boundaries do not cover the complete requested measurement')
    }
    $rows = @([regex]::Matches($text, 'perf native frame: frame=(\d+) enqueue_ns=(\d+) presentation_ns=(\d+) state=(\d+)') | ForEach-Object {
        [ordered]@{ frame = [ulong]$_.Groups[1].Value; enqueue_ns = [ulong]$_.Groups[2].Value
            presentation_ns = [ulong]$_.Groups[3].Value; state = [int]$_.Groups[4].Value }
    })
    if (!$rows.Count -or $rows.Count -ne $start.records -or $rows.Count -ne $end.records) {
        $issues.Add('Native frame rows are missing or truncated')
    }
    for ($index = 0; $index -lt $rows.Count; ++$index) {
        $row = $rows[$index]
        if (!$row.frame -or !$row.enqueue_ns -or $row.state -notin @(2, 3) -or
            ($row.presentation_ns -ne 0 -and $row.presentation_ns -lt $row.enqueue_ns)) {
            $issues.Add('Invalid native frame state or timestamp')
        }
        if ($index -gt 0 -and ($row.frame -ne $rows[$index - 1].frame + 1 -or $row.enqueue_ns -lt $rows[$index - 1].enqueue_ns)) {
            $issues.Add('Native frame identifiers or enqueue order are incomplete')
        }
        if ($row.enqueue_ns -le $start.end_ns -and ($row.state -ne 3 -or !$row.presentation_ns)) {
            $issues.Add('A measured queued frame lacks a Presented timestamp')
        }
    }
    $presented = @($rows | Where-Object { $_.state -eq 3 -and $_.presentation_ns -gt 0 })
    $anchor = $presented | Where-Object { $_.presentation_ns -le $start.begin_ns } | Select-Object -Last 1
    $edgeLimit = [Math]::Ceiling($report.nominal_interval_ns)
    if (!$anchor -or ([decimal]$start.begin_ns - [decimal]$anchor.presentation_ns) -gt $edgeLimit) {
        $issues.Add('Native history lacks the complete start boundary anchor')
    }
    $postEnd = $presented | Where-Object { $_.presentation_ns -ge $start.end_ns } | Select-Object -First 1
    $selected = @($presented | Where-Object {
        $anchor -and $_.frame -ge $anchor.frame -and
        (($postEnd -and $_.frame -le $postEnd.frame) -or (!$postEnd -and $_.presentation_ns -lt $start.end_ns))
    })
    $report.frames = $selected.Count
    $report.intervals = [Math]::Max(0, $selected.Count - 1)
    if (!$selected.Count -or $report.intervals -lt [Math]::Floor([double]$duration * 60) - 1 -or
        ([decimal]$start.end_ns - [decimal]$selected[-1].presentation_ns) -ge $edgeLimit) {
        $issues.Add('Native history does not cover the complete end boundary')
    }
    $intervals = [Collections.Generic.List[double]]::new()
    for ($index = 1; $index -lt $selected.Count; ++$index) {
        $delta = [double]([decimal]$selected[$index].presentation_ns - [decimal]$selected[$index - 1].presentation_ns)
        $intervals.Add($delta)
        if ($selected[$index].frame -ne $selected[$index - 1].frame + 1 -or [Math]::Abs($delta - $report.nominal_interval_ns) -gt $report.interval_tolerance_ns) {
            $issues.Add('Native history contains a repeated, skipped or uneven presentation')
        }
    }
    if ($selected.Count) { $report.first_frame = $selected[0]; $report.last_frame = $selected[-1] }
    if ($intervals.Count) {
        $statistics = $intervals | Measure-Object -Minimum -Maximum -Average
        $report.interval_min_ns = $statistics.Minimum
        $report.interval_max_ns = $statistics.Maximum
        $report.interval_mean_ns = $statistics.Average
    }
    $report.errors = @($issues.ToArray() | Select-Object -Unique)
    $report.accepted = $issues.Count -eq 0
    return $report
}
function OutputChildPath($path) {
    $directory = [IO.Path]::GetFullPath($OutputRoot).TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
    $prefix = $directory + [IO.Path]::DirectorySeparatorChar
    $resolved = [IO.Path]::GetFullPath($path)
    if ($resolved.Length -le $prefix.Length -or !$resolved.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) {
        throw 'Generated run cleanup resolved outside its output directory'
    }
    return $resolved
}

$ledgerState = ReadLedger
if ($Next) {
    if ($Scene) { throw 'Use either -Next or -Scene' }
    $Scene = ActiveArea $ledgerState
    if (!$Scene) { 'Every required ledger destination has passed.'; return }
}
if (!$Scene) { throw 'Choose -Next or -Scene <destination>' }

if ($RecordCapture) {
    $proof = Get-Content -LiteralPath $RecordCapture -Raw | ConvertFrom-Json -AsHashtable
    if ($proof.scene -ne $Scene) { throw 'Capture evidence names a different destination' }
    $area = LedgerArea $ledgerState $Scene
    if (IsPassed $area) { throw "Already passed: $Scene; its evidence is preserved without another test" }
    if ((ActiveArea $ledgerState) -ne $Scene) { throw "Finish $(ActiveArea $ledgerState) before accepting $Scene" }
    $summaryPath = Join-Path $proof.run 'perf-summary.json'
    $run = Get-Content -LiteralPath $summaryPath -Raw | ConvertFrom-Json -AsHashtable
    $logPath = Join-Path $proof.run 'run.log'
    $runLog = Get-Content -LiteralPath $logPath -Raw
    if ($run.scene_key -ne $Scene -or $run.elf_sha256 -ne $proof.elf_sha256 -or $run.nso_sha256 -ne $proof.nso_sha256) {
        throw 'Capture provenance does not match this exact scene and executable'
    }
    if (!$run.total -or $runLog -notmatch 'perf scene start ' -or $runLog -match 'perf invalid:') {
        throw 'A completed sample with native scene verification is required'
    }
    $nativeEvidence = $proof.pacing_source -eq 'native_frame_history'
    $stressEvidence = $null
    $fixedStress = $proof.coverage_kind -eq 'fixed_stress'
    if ($area.Contains('stress_fixture') -or $fixedStress) {
        if (!$area.Contains('stress_fixture') -or $Scene -ne 'dungeon:0:3' -or !$nativeEvidence -or
            !$fixedStress -or $proof.fixed_view_verified -isnot [bool] -or !$proof.fixed_view_verified -or
            $proof.all20_distinguishable_verified -isnot [bool] -or !$proof.all20_distinguishable_verified) {
            throw 'Stress acceptance requires inspected fixed-view native evidence of all ten enemies and ten chests'
        }
        $stressEvidence = ReadStressValidation $runLog $run.total
        if (!$stressEvidence.accepted) { throw ('Stress evidence rejected: ' + ($stressEvidence.errors -join '; ')) }
    }
    if (!$proof.scene_verified -or (!$proof.camera_sweep_verified -and !$fixedStress) -or !$proof.measurement_interval_verified -or
        !$proof.scene_evidence_path -or (!$nativeEvidence -and (!$proof.calibrated -or !$proof.calibration_evidence_paths))) {
        throw 'Inspected scene, measured-video interval and detector calibration evidence are required'
    }
    $evidenceFiles = [ordered]@{}
    $paths = @($proof.scene_evidence_path)
    if (!$nativeEvidence) { $paths += @($proof.calibration_evidence_paths) }
    foreach ($evidencePath in $paths) {
        if (!(Test-Path -LiteralPath $evidencePath -PathType Leaf)) { throw "Missing evidence: $evidencePath" }
        $evidenceFiles[$evidencePath] = (Get-FileHash -LiteralPath $evidencePath -Algorithm SHA256).Hash
    }
    if ($nativeEvidence) {
        $history = ReadNativeHistory $runLog ([double]$run.measurement_seconds)
        if (!$history.accepted) { throw ('Native presentation evidence rejected: ' + ($history.errors -join '; ')) }
        $capturePath = (Resolve-Path -LiteralPath $proof.capture_path).Path
        if ((Get-FileHash -LiteralPath $capturePath -Algorithm SHA256).Hash -ne $proof.capture_sha256) {
            throw 'The captured video hash differs from its evidence record'
        }
        $recordingPath = Join-Path $proof.run 'target-manager-recording.jsonl'
        $manifestPath = Join-Path $proof.run 'run-manifest.json'
        $manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json -AsHashtable
        $recording = @(Get-Content -LiteralPath $recordingPath | Where-Object { $_.Trim() } | ForEach-Object { $_ | ConvertFrom-Json -AsHashtable } |
            Where-Object { $_.kind -eq 'recording_completed' })
        if ($manifest.result -ne 'completed' -or $manifest.nso_sha256 -ne $proof.nso_sha256 -or
            $manifest.target_manager_recording_result -ne 0 -or !$manifest.target -or
            $recording.Count -ne 1 -or $recording[0].target -ne $manifest.target -or
            $recording[0].exit_reason -ne 'TimeCompleted' -or !$recording[0].exists -or $recording[0].bytes -le 0 -or
            [IO.Path]::GetFullPath($recording[0].path) -ne $capturePath -or
            $recording[0].bytes -ne (Get-Item -LiteralPath $capturePath).Length) {
            throw 'Target Manager did not report a completed recording of this exact capture'
        }
        $evidenceFiles[$recordingPath] = (Get-FileHash -LiteralPath $recordingPath -Algorithm SHA256).Hash
        $evidenceFiles[$manifestPath] = (Get-FileHash -LiteralPath $manifestPath -Algorithm SHA256).Hash
        $area.status = 'native_presentation_pass'
        $proof.scope = $history.scope
        $proof.native_history = $history
    } else {
    $marker = Get-Content -LiteralPath $proof.marker_report -Raw | ConvertFrom-Json -AsHashtable
    $videoHash = (Get-FileHash -LiteralPath $marker.video -Algorithm SHA256).Hash
    if ($videoHash -ne $proof.capture_sha256) { throw 'The captured video hash differs from its evidence record' }
    $frames = @($marker.frames | Where-Object { $_.pts -ge $marker.selected_start -and $_.pts -le $marker.selected_end })
    $markerPattern = 'perf marker (start|end): instance (\d+) sequence (\d+) accepted (\d+) failed (\d+) boundary_ns (\d+) present_ns (\d+)'
    $boundaries = @{}
    foreach ($match in [regex]::Matches($runLog, $markerPattern)) {
        $boundaries[$match.Groups[1].Value] = @{
            instance = [ulong]$match.Groups[2].Value
            sequence = [ulong]$match.Groups[3].Value
            accepted = [ulong]$match.Groups[4].Value
            failed = [ulong]$match.Groups[5].Value
        }
    }
    if (!$boundaries.start -or !$boundaries.end -or $boundaries.start.instance -ne $boundaries.end.instance -or
        $boundaries.start.failed -ne $boundaries.end.failed -or
        $boundaries.end.accepted -le $boundaries.start.accepted -or
        $boundaries.end.sequence - $boundaries.start.sequence -ne $boundaries.end.accepted - $boundaries.start.accepted) {
        throw 'The run lacks successful presentation-marker boundaries from one renderer lifetime'
    }
    # The start sequence anchors the first measured interval; omitting it could hide an initial repeat.
    $expectedFrames = $boundaries.end.accepted - $boundaries.start.accepted + 1
    if ($frames.Count -ne $expectedFrames -or $frames[0].sequence -ne ($boundaries.start.sequence -band 65535) -or
        $frames[-1].sequence -ne ($boundaries.end.sequence -band 65535)) {
        throw 'The decoded interval does not match the complete native marker boundaries'
    }
    $requiredSeconds = [double]$run.measurement_seconds
    if ($requiredSeconds -lt 1 -or $frames.Count -lt [Math]::Floor($requiredSeconds * 60) - 1) {
        throw 'The decoded capture does not cover the complete measured interval'
    }
    $span = [double]$frames[-1].pts - [double]$frames[0].pts
    if ($span -lt $requiredSeconds - 0.025 -or $span -gt $requiredSeconds + 0.025) {
        throw 'The selected capture interval differs from the complete measurement'
    }
    for ($index = 0; $index -lt $frames.Count; ++$index) {
        if ($null -eq $frames[$index].sequence -or $frames[$index].sequence -lt 0 -or
            $frames[$index].sequence -gt 65535 -or $frames[$index].confidence_margin -lt 20) {
            throw 'A marker frame is unreadable or ambiguous'
        }
        if ($index -gt 0) {
            $step = ([int]$frames[$index].sequence - [int]$frames[$index - 1].sequence) -band 65535
            $interval = [double]$frames[$index].pts - [double]$frames[$index - 1].pts
            if ($step -ne 1 -or [Math]::Abs($interval - 1.0 / 60) -gt 0.001) {
                throw 'The measured capture contains a repeated, skipped or uneven presentation'
            }
        }
    }
    $area.status = 'capture_pass'
    $proof.scope = $marker.scope
    $proof.presentation_boundaries = $boundaries
    $proof.marker_report_sha256 = (Get-FileHash -LiteralPath $proof.marker_report -Algorithm SHA256).Hash
    }
    $area.capture_evidence = $proof
    if ($null -ne $stressEvidence) { $area.capture_evidence.stress_validation = $stressEvidence }
    $area.capture_evidence.evidence_files_sha256 = $evidenceFiles
    $area.capture_evidence.run_log_sha256 = (Get-FileHash -LiteralPath $logPath -Algorithm SHA256).Hash
    $area.capture_evidence.run_summary_sha256 = (Get-FileHash -LiteralPath $summaryPath -Algorithm SHA256).Hash
    $area.capture_evidence.accepted_utc = (Get-Date).ToUniversalTime().ToString('o')
    if (!$ledgerState.Contains('workflow')) { $ledgerState.workflow = [ordered]@{} }
    $ledgerState.workflow.active_scene = $null
    $ledgerState.workflow.active_scene = ActiveArea $ledgerState
    WriteLedger $ledgerState
    "$Scene capture accepted; next destination: $($ledgerState.workflow.active_scene)"
    return
}

# Right stick held: the camera turns for the whole run, sweeping every direction of the scene.
$turn = "0 128 128 255 128`n"
$scenes = [ordered]@{
    title         = @{ Args = '--jump title'; Input = "0`n" }
    town          = @{ Args = '--jump town:10 --fast-load'; Input = $turn }
    'town-still'  = @{ Args = '--jump town:10 --fast-load'; Input = "0`n" }
    # Right stick up: the camera tilts until it clamps, so the view of the sky is the same each run.
    'town-sky'    = @{ Args = '--jump town:10 --fast-load'; Input = "0 128 128 128 0`n" }
    georama       = @{ Args = '--jump georama:0 --fast-load'; Input = $turn }
    dungeon       = @{ Args = '--jump dungeon:0:2 --fast-load --skip-events --invincible --seed 1'; Input = $turn }
    'dungeon-forest' = @{ Args = '--jump dungeon:1:2 --fast-load --skip-events --invincible --seed 1'; Input = $turn }
    'dungeon-canyon' = @{ Args = '--jump dungeon:2:3 --fast-load --skip-events --invincible --seed 1'; Input = $turn }
    'dungeon-ocean' = @{ Args = '--jump dungeon:3:3 --fast-load --skip-events --invincible --seed 1'; Input = $turn }
    'dungeon-workshop' = @{ Args = '--jump dungeon:4:3 --fast-load --skip-events --invincible --seed 1'; Input = $turn }
    'dungeon-moon' = @{ Args = '--jump dungeon:5:3 --fast-load --skip-events --invincible --seed 1'; Input = $turn }
    'dungeon-mine' = @{ Args = '--jump dungeon:6:3 --fast-load --skip-events --invincible --seed 1'; Input = $turn }
    'dungeon-zelmite' = @{ Args = '--jump dungeon:6:3 --fast-load --skip-events --invincible --seed 1'; Input = $turn }
}
if ($Scene -match '^town:(\d+)$') {
    $info = @{ Args = "--jump town:$($Matches[1]) --fast-load"; Input = $turn }
} elseif ($Scene -match '^georama:(\d+)$') {
    $info = @{ Args = "--jump georama:$($Matches[1]) --fast-load"; Input = $turn }
} elseif ($Scene -match '^dungeon:(\d+):(\d+)$') {
    $info = @{ Args = "--jump dungeon:$($Matches[1]):$($Matches[2]) --fast-load --skip-events --invincible --seed 1"; Input = $turn }
} elseif ($Scene -match '^boss:(\d+)$') {
    # A boss event's jump runs its skippable scenes past and fights with the camera turning.
    $info = @{ Args = "--jump event:$($Matches[1]) --fast-load --skip-events --invincible --seed 1"; Input = $turn }
} elseif ($scenes.Contains($Scene)) {
    $info = $scenes[$Scene]
} else {
    throw "Unknown scene $Scene; use town:<map> or one of: $($scenes.Keys -join ', ')"
}
$sceneKey = $Scene
if ($info.Args -match '--jump (town:\d+|georama:\d+|dungeon:\d+:\d+|event:\d+)') {
    $sceneKey = $Matches[1] -replace '^event:', 'boss:'
}
$ledgerArea = @($ledgerState.areas | Where-Object { $_.scene -eq $sceneKey }) | Select-Object -First 1
if ($ledgerArea) {
    if (IsPassed $ledgerArea) { throw "Already passed: $sceneKey; its evidence is preserved without another test" }
    if (!(IsRequired $ledgerArea)) { throw "Excluded at the user's request: $sceneKey" }
    if ($ledgerArea.Contains('stress_fixture') -and $Extra -notmatch '(?:^|\s)--env\s+DC2_PERF_DUNGEON_STRESS=1(?:\s|$)') {
        throw 'This destination requires the explicitly enabled ten-enemy/ten-chest stress fixture'
    }
    if ($ledgerArea.status -eq 'unsupported-direct-jump') { throw "The source data does not support a direct jump to $sceneKey" }
    $active = ActiveArea $ledgerState
    if ($active -ne $sceneKey) { throw "Finish $active before testing $sceneKey" }
    if (!$ledgerState.Contains('workflow')) { $ledgerState.workflow = [ordered]@{} }
    $ledgerState.workflow.active_scene = $sceneKey
    WriteLedger $ledgerState
}
if (!$Target) {
    $line = & (Join-Path $SdkRoot 'Tools\CommandLineTools\ControlTarget.exe') list-target | Select-Object -First 1
    $Target = ($line -split '\s+')[0]
    if (!$Target) { throw 'No development unit is connected' }
}
if (!$Elf) { $Elf = Join-Path $Build 'darkchronicle.elf' }
$RunRoot = (Resolve-Path -LiteralPath $RunRoot).Path
$Build = (Resolve-Path -LiteralPath $Build).Path

$inputFile = Join-Path $OutputRoot ("ct2-perf-{0}.input" -f [guid]::NewGuid().ToString('N').Substring(0, 8))
[IO.File]::WriteAllText($inputFile, $(if ($Replay) { [IO.File]::ReadAllText((Resolve-Path -LiteralPath $Replay).Path) } else { $info.Input }))
if ($GeneratedInputRetention) { & $GeneratedInputRetention $inputFile }
$arguments = "--data romfs:/data --save $SaveRoot --env KZ_PERF_LOG=1 $($info.Args) " +
    "--input romfs:/scene.input --perf-seconds $Seconds $Extra"
$romfs = @{
    'data.zip'    = Join-Path $RunRoot 'data.zip'
    'data.json'   = Join-Path $RunRoot 'data.json'
    'scripts'     = Join-Path $Build 'scripts'
    'glyphs'      = Join-Path $Build 'glyphs'
    'fonts'       = Join-Path $Build 'fonts'
    'scene.input' = $inputFile
}
if ($AttachmentAlphaAllowlist) {
    $allowlist_path = (Resolve-Path -LiteralPath $AttachmentAlphaAllowlist).Path
    $allowlist_file = Get-Item -LiteralPath $allowlist_path
    if ($allowlist_file.PSIsContainer -or $allowlist_file.Length -le 0 -or $allowlist_file.Length -gt 262144) { throw 'Invalid bounded attachment alpha allowlist' }
    $romfs['attachment-alpha.bin'] = $allowlist_path
}
$name = "ChronicleTwo-$($Scene -replace '[^A-Za-z0-9]', '-')"
# Reuse conversions of the exact ELF and toolchain image, including when a mutable image tag moves.
$elfSource = (Resolve-Path -LiteralPath $Elf).Path
$elfHash = (Get-FileHash -LiteralPath $elfSource -Algorithm SHA256).Hash
$stage = $null
if ($PreparedNso) {
    $prepared = ReadPreparedNso $PreparedNso $elfHash
    $nso = $prepared.path
    $nsoHash = $prepared.hash
    $imageId = $prepared.image_id
} else {
    $imageId = [string](& wsl -e docker image inspect --format '{{.Id}}' $Image | Select-Object -Last 1)
    $imageId = $imageId.Trim()
    if ($LASTEXITCODE -ne 0 -or $imageId -notmatch '^sha256:[0-9a-f]{64}$') {
        throw "Cannot identify toolchain image $Image"
    }
    $imageHash = $imageId.Substring(7)
    $cache = Join-Path $OutputRoot 'ct2-perf-nso-cache'
    New-Item -ItemType Directory -Path $cache -Force | Out-Null
    $nso = Join-Path $cache ("{0}-{1}.nso" -f $elfHash, $imageHash.Substring(0, 16))
    if (!(Test-Path -LiteralPath $nso)) {
        # elf2nso runs through WSL's Docker, which also serves hosts without a Windows Docker CLI.
        $stage = Join-Path $OutputRoot ("ct2-perf-nso-{0}" -f [guid]::NewGuid().ToString('N').Substring(0, 8))
        New-Item -ItemType Directory -Path $stage | Out-Null
        Copy-Item -LiteralPath $elfSource -Destination (Join-Path $stage 'application.elf')
        $wslStage = '/mnt/' + $stage.Substring(0, 1).ToLowerInvariant() + $stage.Substring(2).Replace('\', '/')
        foreach ($attempt in 1..8) {
            wsl -e docker run --rm -v "${wslStage}:/stage" $Image elf2nso /stage/application.elf /stage/main.nso
            if ($LASTEXITCODE -eq 0) { break }
            Start-Sleep -Seconds 10
        }
        if ($LASTEXITCODE -ne 0) { throw 'elf2nso failed' }
        Move-Item -LiteralPath (Join-Path $stage 'main.nso') -Destination $nso -Force
    }
    $nsoHash = (Get-FileHash -LiteralPath $nso -Algorithm SHA256).Hash
}
$runner = Join-Path $PSScriptRoot '..\kazarov\tools\switch\devkit-run.ps1'
if ($ledgerArea) {
    $ledgerState = ReadLedger
    $ledgerArea = LedgerArea $ledgerState $sceneKey
    $ledgerArea.last_attempt = [ordered]@{
        started_utc = (Get-Date).ToUniversalTime().ToString('o')
        elf_sha256 = $elfHash
        nso_sha256 = $nsoHash
        arguments = $arguments
        result = 'running'
    }
    WriteLedger $ledgerState
}
try {
    # Another run holding the development unit's lock makes the runner fail at once, so retry until it is free.
    while ($true) {
        try {
            $root = & $runner -Nso $nso -SdkRoot $SdkRoot -Target $Target -ProgramId '0x01004b9000490030' `
                -Application $name -Arguments $arguments -RomfsFiles $romfs -OutputRoot $OutputRoot -Image $Image `
                -Mode $Mode -Performance $Performance -Seconds (240 + 2 * $Seconds) -CapturePattern $CapturePattern `
                -MovieCapturePattern $MovieCapturePattern `
                -FailurePattern $FailurePattern `
                -TargetManagerRecordPattern $TargetManagerRecordPattern -TargetManagerRecordSeconds $TargetManagerRecordSeconds `
                -TargetManagerScreenshot:$TargetManagerScreenshot `
                -ExternalCapture:$ExternalCapture `
                -CompletePattern $(if ($Screenshot) { $ScreenshotPattern } elseif ($MovieCapturePattern) { $MovieCapturePattern } else { $CompletionPattern }) |
                Select-Object -Last 1
            break
        } catch {
            if ($_.Exception.Message -notmatch 'chronicle-edev\.lock') { throw }
            Start-Sleep -Seconds 15
        }
    }
} catch {
    if ($ledgerArea) {
        $ledgerState = ReadLedger
        $ledgerArea = LedgerArea $ledgerState $sceneKey
        $ledgerArea.last_attempt.result = 'failed'
        $ledgerArea.last_attempt.error = $_.Exception.Message
        $ledgerArea.last_attempt.completed_utc = (Get-Date).ToUniversalTime().ToString('o')
        WriteLedger $ledgerState
    }
    throw
} finally {
    Remove-Item -LiteralPath $inputFile -ErrorAction SilentlyContinue
    if ($stage) { Remove-Item -LiteralPath (OutputChildPath $stage) -Recurse -ErrorAction SilentlyContinue }
}

# The package holds a copy of the data archive; only the logs, manifest and screenshot are kept.
$root = OutputChildPath $root
Get-ChildItem -LiteralPath $root -Filter '*.nsp' -File | Remove-Item -Force
foreach ($staged in 'romfs', 'code') {
    $path = Join-Path $root $staged
    if (Test-Path -LiteralPath $path) { Remove-Item -LiteralPath $path -Recurse -Force }
}
if ($Screenshot) {
    if ($ledgerArea) {
        $ledgerState = ReadLedger
        $ledgerArea = LedgerArea $ledgerState $sceneKey
        $ledgerArea.last_attempt.result = 'scene_capture_only'
        $ledgerArea.last_attempt.run = $root
        $ledgerArea.last_attempt.completed_utc = (Get-Date).ToUniversalTime().ToString('o')
        WriteLedger $ledgerState
    }
    "$Scene $Label screenshot -> $root"
    return
}
$log = Join-Path $root 'run.log'
$lines = @(Get-Content -LiteralPath $log | ForEach-Object { $_ -replace '^.*?\] ', '' })
$windows = @($lines | Where-Object { $_ -match 'perf window ' })
$total = $lines | Where-Object { $_ -match 'perf total ' } | Select-Object -Last 1
$canon = @(); $display = @(); $prepare = @(); $waits = @(); $scopes = @{}
$start = [array]::FindIndex([string[]]$lines, [Predicate[string]] { param($l) $l -match 'perf start:' })
if ($start -ge 0) {
    foreach ($l in $lines[$start..($lines.Count - 1)]) {
        if ($l -match 'timing canonical count=(\d+)/(\d+) cpu=([\d.]+)/([\d.]+) gpu=([\d.]+)/([\d.]+)') { $canon += , $Matches }
        elseif ($l -match 'timing display count=(\d+)/(\d+) cpu=([\d.]+)/([\d.]+) gpu=([\d.]+)/([\d.]+)') { $display += , $Matches }
        elseif ($l -match 'timing display prepare count=(\d+) cpu=([\d.]+)/([\d.]+)') { $prepare += , $Matches }
        elseif ($l -match 'timing acquire=([\d.]+) present=([\d.]+) fence=([\d.]+) intervals=(\S+)') { $waits += , $Matches }
        elseif ($l -match '^.*timing scope (.+) count=(\d+) gpu=[\d.]+/[\d.]+ total_ms=([\d.]+) draws=(\d+)') {
            $scope = $scopes[$Matches[1]]
            if (!$scope) { $scope = $scopes[$Matches[1]] = [ordered]@{ count = 0; total_ms = 0.0; draws = 0 } }
            $scope.count += [int]$Matches[2]; $scope.total_ms += [double]$Matches[3]; $scope.draws += [int]$Matches[4]
        }
    }
}
$presented = if ($total -match 'presented (\d+)') { [int]$Matches[1] } else { 0 }
$topScopes = @($scopes.GetEnumerator() | Sort-Object { $_.Value.total_ms } -Descending | Select-Object -First 30 |
    ForEach-Object { '{0,8:N3} ms/presented {1,6} draws  {2}' -f ($_.Value.total_ms / [Math]::Max(1, $presented)), $_.Value.draws, $_.Key })
function Mean($items, $index) {
    if ($items.Count -eq 0) { return 0 }
    return [Math]::Round((($items | ForEach-Object { [double]$_[$index] }) | Measure-Object -Average).Average, 3)
}
function Peak($items, $index) {
    if ($items.Count -eq 0) { return 0 }
    return [Math]::Round((($items | ForEach-Object { [double]$_[$index] }) | Measure-Object -Maximum).Maximum, 3)
}
$summary = [ordered]@{
    label                 = $Label
    scene                 = $Scene
    scene_key             = $sceneKey
    measurement_seconds   = $Seconds
    arguments             = $arguments
    elf_source            = $elfSource
    elf_sha256            = $elfHash
    nso_sha256            = $nsoHash
    image                 = $Image
    image_id              = $imageId
    run                   = $root
    total                 = $total
    windows               = $windows
    canonical_cpu_ms      = Mean $canon 3
    canonical_cpu_max_ms  = Peak $canon 4
    canonical_gpu_ms      = Mean $canon 5
    canonical_gpu_max_ms  = Peak $canon 6
    display_cpu_ms        = Mean $display 3
    display_cpu_max_ms    = Peak $display 4
    display_gpu_ms        = Mean $display 5
    display_gpu_max_ms    = Peak $display 6
    display_prepare_ms    = Mean $prepare 2
    acquire_ms            = Mean $waits 1
    present_ms            = Mean $waits 2
    fence_ms              = Mean $waits 3
    present_return_intervals = @($waits | ForEach-Object { $_[4] })
    native_history        = $(if (($lines -join "`n") -match 'perf native history begin:') { ReadNativeHistory ($lines -join "`n") $Seconds } else { $null })
    gpu_scopes            = $topScopes
    zones                 = @($lines | Where-Object { $_ -match 'perf zone ' } | ForEach-Object { $_ -replace '^.*perf zone ', '' })
    switch                = @($lines | Where-Object { $_ -match '^switch: (mode|output|operation|perf)' } | Select-Object -Last 3)
}
$summary | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $root 'perf-summary.json') -Encoding utf8
$validationResult = if (!$total) { 'incomplete' }
    elseif ($null -ne $summary.native_history -and !$summary.native_history.accepted) { 'native_pacing_failed' }
    else { 'awaiting_capture_validation' }
if ($ledgerArea) {
    # Reload before updating so independent documentation edits remain intact.
    $ledgerState = ReadLedger
    $ledgerArea = LedgerArea $ledgerState $sceneKey
    if (!$ledgerArea.Contains('validation_runs')) { $ledgerArea.validation_runs = @() }
    $ledgerArea.validation_runs += [ordered]@{
        run = $root
        elf_sha256 = $elfHash
        nso_sha256 = $nsoHash
        arguments = $arguments
        total = $total
        result = $validationResult
        summary_sha256 = (Get-FileHash -LiteralPath (Join-Path $root 'perf-summary.json') -Algorithm SHA256).Hash
    }
    $ledgerArea.last_attempt.result = $validationResult
    if ($validationResult -eq 'native_pacing_failed') { $ledgerArea.status = 'needs_optimization' }
    $ledgerArea.last_attempt.run = $root
    $ledgerArea.last_attempt.completed_utc = (Get-Date).ToUniversalTime().ToString('o')
    WriteLedger $ledgerState
}
if (!$total) { throw "The scene did not finish its measurement; see $log" }
"$Scene $Label -> $root"
$total
'canonical cpu {0}/{1} gpu {2}/{3} | display cpu {4}/{5} gpu {6}/{7} prepare {8} | acquire {9} present {10} fence {11}' -f `
    $summary.canonical_cpu_ms, $summary.canonical_cpu_max_ms, $summary.canonical_gpu_ms, $summary.canonical_gpu_max_ms,
    $summary.display_cpu_ms, $summary.display_cpu_max_ms, $summary.display_gpu_ms, $summary.display_gpu_max_ms,
    $summary.display_prepare_ms, $summary.acquire_ms, $summary.present_ms, $summary.fence_ms
$topScopes
$summary.zones | Select-Object -First 45
