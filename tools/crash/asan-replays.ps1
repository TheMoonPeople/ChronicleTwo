#requires -Version 7.0
# Windows counterpart of asan-replays.sh: builds windows-x64-asan and replays the scenes that reload characters,
# weapons and menus on the host GPU, failing on any AddressSanitizer report.
#
#   tools/crash/asan-replays.ps1 [-Data <data dir>] [replay names...]
param([string]$Data = '', [Parameter(ValueFromRemainingArguments)] [string[]]$Replays)
$ErrorActionPreference = 'Stop'

$root = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '../..'))
if (!$Data) { $Data = Join-Path $root 'port/run/data' }
if (!$Replays) {
    $Replays = @('dungeon-weapon-swap', 'jump-dungeon-menu-item', 'jump-dungeon-menu-character', 'jump-dungeon-item-gun',
                 'jump-town-menu-item', 'jump-town-menu-character', 'jump-town-item-weapon', 'area-town-character')
}

& (Join-Path $root 'build.bat') windows-x64-asan
if ($LASTEXITCODE) { exit $LASTEXITCODE }
$build = Join-Path $root 'port/build/windows-x64-asan'
# The sanitizer runtime DLL ships with the compiler rather than beside the game.
$llvm = Get-ChildItem -LiteralPath (Join-Path $root '.kazarov/windows/deps/llvm') -Directory | Select-Object -First 1
$env:PATH = "$(Join-Path $llvm.FullName 'bin');$env:PATH"
if (!$env:ASAN_OPTIONS) { $env:ASAN_OPTIONS = 'detect_leaks=0:halt_on_error=1' }
$out = Join-Path $build 'replays'
New-Item -ItemType Directory -Force $out | Out-Null

$failed = $false
foreach ($name in $Replays) {
    $replay = Join-Path $root "tools/input/$name.input"
    $header = (Get-Content -LiteralPath $replay -TotalCount 1)
    if (!$header.StartsWith('# --')) {
        Write-Host "asan-replays: $name has no launch arguments on its first line"
        $failed = $true
        continue
    }
    $arguments = ($header.Substring(2) -split '[;:]')[0].Trim() -split '\s+'
    $last = (Get-Content -LiteralPath $replay | Where-Object { $_ -match '^\d+' } | ForEach-Object { [int]($_ -split '\s+')[0] } |
             Measure-Object -Maximum).Maximum
    $save = Join-Path $out "$name-save"
    Remove-Item -LiteralPath $save -Recurse -Force -ErrorAction SilentlyContinue
    New-Item -ItemType Directory $save | Out-Null
    $log = Join-Path $out "$name.log"
    & (Join-Path $build 'darkchronicle.exe') --data $Data --save $save --offscreen @arguments --input $replay --frames ($last + 120) *> $log
    $code = $LASTEXITCODE
    if ($code -eq 0 -and !(Select-String -LiteralPath $log -Pattern 'AddressSanitizer' -Quiet)) {
        Write-Host "asan-replays: $name passed"
    } else {
        Write-Host "asan-replays: $name FAILED (exit $code); see $log"
        $report = Select-String -LiteralPath $log -Pattern 'ERROR: AddressSanitizer' -Context 0, 14 | Select-Object -First 1
        if ($report) { $report.Line; $report.Context.PostContext } else { Get-Content -LiteralPath $log -Tail 5 }
        $failed = $true
    }
}
exit [int]$failed
