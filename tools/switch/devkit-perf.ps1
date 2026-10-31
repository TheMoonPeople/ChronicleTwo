# Measures one scene of the libnx build on an SDK development unit and summarizes its ten one-second windows.
#
#   tools/switch/devkit-perf.ps1 -Scene town -Target <serial> [-SdkRoot <NintendoSDK>] [-RunRoot <dir with data.zip>]
#
# The scene's --jump starts it directly with --fast-load. --perf-seconds waits for player control (or for the
# jumped mode when it has none), lets one second pass, logs one window a second and exits. KZ_PERF_LOG adds
# the renderer's canonical/display CPU and GPU samples to each window. Saves and the pipeline cache persist
# under SaveRoot, so only the first run on a unit compiles pipelines.
param(
    [Parameter(Mandatory)] [string]$Scene,
    [string]$Target = '',
    [string]$SdkRoot = $env:NINTENDO_SDK_ROOT,
    [string]$Build = (Join-Path $PSScriptRoot '..\..\port\build\switch'),
    [string]$Elf = '',
    [string]$RunRoot = (Join-Path $PSScriptRoot '..\..\port\run'),
    [string]$Image = 'kazarov-switch:chronicletwo-validation',
    [string]$OutputRoot = $env:TEMP,
    [ValidateSet('handheld', 'console')] [string]$Mode = 'handheld',
    [ValidateSet('normal', 'auto')] [string]$Performance = 'normal',
    [string]$SaveRoot = 'sdmc:/switch/chronicletwo/perf-saves',
    [int]$Seconds = 10,
    [string]$Extra = '',
    [string]$Label = '',
    # Captures the screen while the scene is still running instead of after it exits.
    [switch]$Screenshot,
    # With -Screenshot: the log text that triggers the capture instead of the first perf window.
    [string]$ScreenshotPattern = 'perf window '
    ,
    # Drives the run from this input script instead of the scene's own input.
    [string]$Replay = ''
)
$ErrorActionPreference = 'Stop'

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
    'dungeon-ocean' = @{ Args = '--jump dungeon:1:2 --fast-load --skip-events --invincible --seed 1'; Input = $turn }
    'dungeon-forest' = @{ Args = '--jump dungeon:2:3 --fast-load --skip-events --invincible --seed 1'; Input = $turn }
    'dungeon-mine' = @{ Args = '--jump dungeon:3:3 --fast-load --skip-events --invincible --seed 1'; Input = $turn }
    'dungeon-moon' = @{ Args = '--jump dungeon:4:3 --fast-load --skip-events --invincible --seed 1'; Input = $turn }
    'dungeon-zelmite' = @{ Args = '--jump dungeon:5:3 --fast-load --skip-events --invincible --seed 1'; Input = $turn }
    'dungeon-ruins' = @{ Args = '--jump dungeon:6:3 --fast-load --skip-events --invincible --seed 1'; Input = $turn }
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
$arguments = "--data romfs:/data --save $SaveRoot --env KZ_PERF_LOG=1 $($info.Args) " +
    "--input romfs:/scene.input --perf-seconds $Seconds $Extra"
$romfs = @{
    'data.zip'    = Join-Path $RunRoot 'data.zip'
    'data.json'   = Join-Path $RunRoot 'data.json'
    'scripts'     = Join-Path $Build 'scripts'
    'glyphs'      = Join-Path $Build 'glyphs'
    'scene.input' = $inputFile
}
$name = "ChronicleTwo-$($Scene -replace '[^A-Za-z0-9]', '-')"
# elf2nso runs in the toolchain image through WSL's Docker, which also serves hosts without a Windows Docker CLI.
$stage = Join-Path $OutputRoot ("ct2-perf-nso-{0}" -f [guid]::NewGuid().ToString('N').Substring(0, 8))
New-Item -ItemType Directory -Path $stage | Out-Null
Copy-Item -LiteralPath $Elf -Destination (Join-Path $stage 'application.elf')
$wslStage = '/mnt/' + $stage.Substring(0, 1).ToLowerInvariant() + $stage.Substring(2).Replace('\', '/')
# The WSL service occasionally refuses a connection while it is busy.
foreach ($attempt in 1..8) {
    wsl -e docker run --rm -v "${wslStage}:/stage" $Image elf2nso /stage/application.elf /stage/main.nso
    if ($LASTEXITCODE -eq 0) { break }
    Start-Sleep -Seconds 10
}
if ($LASTEXITCODE -ne 0) { throw 'elf2nso failed' }
$runner = Join-Path $PSScriptRoot '..\kazarov\tools\switch\devkit-run.ps1'
try {
    # Another run holding the development unit's lock makes the runner fail at once, so retry until it is free.
    while ($true) {
        try {
            $root = & $runner -Nso (Join-Path $stage 'main.nso') -SdkRoot $SdkRoot -Target $Target -ProgramId '0x01004b9000490030' `
                -Application $name -Arguments $arguments -RomfsFiles $romfs -OutputRoot $OutputRoot -Image $Image `
                -Mode $Mode -Performance $Performance -Seconds (240 + 2 * $Seconds) -CompletePattern $(if ($Screenshot) { $ScreenshotPattern } else { 'perf total ' }) |
                Select-Object -Last 1
            break
        } catch {
            if ($_.Exception.Message -notmatch 'chronicle-edev\.lock') { throw }
            Start-Sleep -Seconds 15
        }
    }
} finally {
    Remove-Item -LiteralPath $inputFile -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $stage -Recurse -ErrorAction SilentlyContinue
}

# The package holds a copy of the data archive; only the logs, manifest and screenshot are kept.
Get-ChildItem -LiteralPath $root -Filter '*.nsp' -File | Remove-Item -Force
foreach ($staged in 'romfs', 'code') {
    $path = Join-Path $root $staged
    if (Test-Path -LiteralPath $path) { Remove-Item -LiteralPath $path -Recurse -Force }
}
if ($Screenshot) { "$Scene $Label screenshot -> $root"; return }
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
    arguments             = $arguments
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
    gpu_scopes            = $topScopes
    zones                 = @($lines | Where-Object { $_ -match 'perf zone ' } | ForEach-Object { $_ -replace '^.*perf zone ', '' })
    switch                = @($lines | Where-Object { $_ -match '^switch: (mode|output|operation|perf)' } | Select-Object -Last 3)
}
$summary | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath (Join-Path $root 'perf-summary.json') -Encoding utf8
if (!$total) { throw "The scene did not finish its measurement; see $log" }
"$Scene $Label -> $root"
$total
'canonical cpu {0}/{1} gpu {2}/{3} | display cpu {4}/{5} gpu {6}/{7} prepare {8} | acquire {9} present {10} fence {11}' -f `
    $summary.canonical_cpu_ms, $summary.canonical_cpu_max_ms, $summary.canonical_gpu_ms, $summary.canonical_gpu_max_ms,
    $summary.display_cpu_ms, $summary.display_cpu_max_ms, $summary.display_gpu_ms, $summary.display_gpu_max_ms,
    $summary.display_prepare_ms, $summary.acquire_ms, $summary.present_ms, $summary.fence_ms
$topScopes
$summary.zones | Select-Object -First 45
