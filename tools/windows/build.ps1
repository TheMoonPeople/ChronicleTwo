#requires -Version 7.0
param([string]$Root, [string]$BuildDirectory, [switch]$Tests,
      [ValidateRange(1, 65536)][int]$Jobs = 12)
$ErrorActionPreference = 'Stop'
. "$PSScriptRoot/common.ps1"
$root = Resolve-WindowsRoot $Root
$build = Resolve-WindowsBuild $root $BuildDirectory
$cmake = Find-WindowsTool cmake 'C:/Program Files/CMake/bin/cmake.exe'
$rust = "$root/deps/rust/1.99.0-gnullvm/bin"
$llvm = "$root/deps/llvm/llvm-mingw-20260922-ucrt-x86_64/bin"
$env:CARGO_HOME = "$root/deps/rust/cargo-home"
$env:PATH = "$rust;$llvm;$env:PATH"
$targets = @('darkchronicle', 'dc2data')
if ($Tests) { $targets += @('darkchronicle_tests', 'dc2data_bridge_test') }
$log = Join-Path $build 'build.log'
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
}
Write-Host ("kazarov: build finished in {0:N1}s (exit {1})" -f $timer.Elapsed.TotalSeconds, $code)
if ($code) { exit $code }
# CMake's runtime dependency targets populate the output for both scripted and direct builds.
exit 0
