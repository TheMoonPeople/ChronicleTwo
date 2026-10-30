#requires -Version 7.0
# Exercises the build wrapper with a delayed native fixture; no toolchain is required.
$ErrorActionPreference = 'Stop'
$fixture = Join-Path ([IO.Path]::GetTempPath()) "chronicle build test $([Guid]::NewGuid())"
New-Item -ItemType Directory $fixture | Out-Null
$process = $null
try {
    @'
@echo off
echo stdout early
echo stderr early 1>&2
for /L %%i in (1,1,70) do echo diagnostic %%i
ping -n 6 127.0.0.1 >nul
echo stdout late
exit /b %CT_TEST_BUILD_EXIT%
'@ | Set-Content -LiteralPath (Join-Path $fixture 'cmake.cmd')
    $runner = Join-Path $fixture 'run.ps1'
    @'
param([string]$BuildScript, [int]$Code)
$env:PATH = "$PSScriptRoot;$env:PATH"
$env:CT_TEST_BUILD_EXIT = "$Code"
$PSNativeCommandUseErrorActionPreference = $true
& $BuildScript -Root $PSScriptRoot -BuildDirectory $PSScriptRoot
$code = $LASTEXITCODE
# The launcher remains alive while the game runs, so the build lock must already be released.
$lock = [IO.File]::Open((Join-Path $PSScriptRoot '.kazarov-build.lock'), 'OpenOrCreate', 'ReadWrite', 'None')
$lock.Dispose()
exit $code
'@ | Set-Content -LiteralPath $runner
    $shell = (Get-Process -Id $PID).Path
    $buildScript = Join-Path $PSScriptRoot 'build.ps1'
    foreach ($code in 23, 0) {
        $log = Join-Path $fixture 'build.log'
        Remove-Item -LiteralPath $log -ErrorAction SilentlyContinue
        $stdout = Join-Path $fixture "stdout-$code.log"
        $stderr = Join-Path $fixture "stderr-$code.log"
        $process = Start-Process -FilePath $shell -ArgumentList @(
            '-NoProfile', '-File', "`"$runner`"", '-BuildScript', "`"$buildScript`"", '-Code', $code
        ) -WindowStyle Hidden -PassThru -RedirectStandardOutput $stdout -RedirectStandardError $stderr
        $deadline = [DateTime]::UtcNow.AddSeconds(15)
        do {
            Start-Sleep -Milliseconds 100
            $visible = (Test-Path -LiteralPath $stdout) -and
                ((Get-Content -LiteralPath $stdout -Raw) -match 'stderr early')
        } while (-not $visible -and -not $process.HasExited -and [DateTime]::UtcNow -lt $deadline)
        if (-not $visible -or $process.HasExited) { throw 'Native output did not stream before completion' }
        if ((Get-Content -LiteralPath $log -Raw) -notmatch 'stderr early') { throw 'Live log omitted stderr' }
        if (-not $process.WaitForExit(15000)) { throw 'Build fixture did not finish' }
        if ($process.ExitCode -ne $code) { throw "Expected exit $code, got $($process.ExitCode)" }
        $contents = Get-Content -LiteralPath $log -Raw
        foreach ($message in 'stdout early', 'stderr early', 'diagnostic 1', 'diagnostic 70', 'stdout late') {
            if (-not $contents.Contains($message)) { throw "Full log omitted $message" }
        }
        $process.Dispose()
        $process = $null
    }
    Write-Host "Windows build output checks passed (PowerShell $($PSVersionTable.PSVersion))"
} finally {
    if ($process) {
        if (-not $process.HasExited) { $process.Kill($true) }
        $process.Dispose()
    }
    # The unique absolute fixture directory is the only cleanup target.
    Remove-Item -LiteralPath $fixture -Recurse -Force
}
