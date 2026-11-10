#requires -Version 7.0
param([string]$Root, [string]$BuildDirectory, [switch]$Tests,
      [ValidateRange(1, 65536)][int]$Jobs = [Environment]::ProcessorCount)
$ErrorActionPreference = 'Stop'
. "$PSScriptRoot/common.ps1"
$root = Resolve-WindowsRoot $Root
$build = Resolve-WindowsBuild $root $BuildDirectory
$cmake = Join-Path $root 'deps/cmake/cmake-4.4.5-windows-x86_64/bin/cmake.exe'
if (!(Test-Path -LiteralPath $cmake)) { $cmake = Find-WindowsTool cmake 'C:/Program Files/CMake/bin/cmake.exe' }
$rust = "$root/deps/rust/1.99.0-gnullvm/bin"
$llvm = "$root/deps/llvm/llvm-mingw-20260922-ucrt-x86_64/bin"
$env:CARGO_HOME = "$root/deps/rust/cargo-home"
$env:PATH = "$rust;$llvm;$env:PATH"
$targets = @('darkchronicle', 'dc2data')
if ($Tests) { $targets += @('darkchronicle_tests', 'dc2data_bridge_test') }
$log = Join-Path $build 'build.log'
New-Item -ItemType Directory -Force $build | Out-Null
# Two ninjas appending to one .ninja_deps interleave its records. Ninja then discards every record after the
# damage on each load without truncating the file, so all later builds recompile everything.
$lockFile = Join-Path $build '.kazarov-build.lock'
$lock = $null
$announced = $false
while ($null -eq $lock) {
    try {
        $lock = [IO.File]::Open($lockFile, 'OpenOrCreate', 'ReadWrite', 'None')
    } catch [IO.IOException], [UnauthorizedAccessException] {
        if (-not $announced) { Write-Host "kazarov: waiting for another build of $build"; $announced = $true }
        Start-Sleep -Milliseconds 500
    }
}
# Explicit repair rewrites damaged logs; ordinary builds leave Ninja's incremental database intact.
$ninja = Join-Path $root 'deps/ninja/ninja.exe'
if ($env:REPAIR_NINJA -eq '1' -and (Test-Path -LiteralPath $ninja) -and (Test-Path -LiteralPath (Join-Path $build 'build.ninja')) -and
    (Test-Path -LiteralPath (Join-Path $build '.ninja_deps'))) {
    & $ninja -C $build -t recompact
    if ($LASTEXITCODE) { $lock.Dispose(); exit $LASTEXITCODE }
}
Write-Host "kazarov: building $build ($Jobs jobs; log: $log)"
$timer = [Diagnostics.Stopwatch]::StartNew()
# Keep the native invocation in PowerShell's foreground pipeline so Ctrl+C reaches
# CMake/Ninja. Tee-Object streams each line and preserves the complete diagnostics.
$PSNativeCommandUseErrorActionPreference = $false
try {
    # PowerShell 7.0/7.1 treat redirected native stderr as PowerShell errors.
    # Keep compiler diagnostics non-terminating while log-write failures still stop.
    $ErrorActionPreference = 'Continue'
    & $cmake --build $build --target $targets -j $Jobs 2>&1 | Tee-Object -FilePath $log -ErrorAction Stop
    $code = $LASTEXITCODE
} finally {
    $ErrorActionPreference = 'Stop'
    $lock.Dispose()
}
Write-Host ("kazarov: build finished in {0:N1}s (exit {1})" -f $timer.Elapsed.TotalSeconds, $code)
if ($code) { exit $code }
# CMake's runtime dependency targets populate the output for both scripted and direct builds.
exit 0
