# Current-data checks and games share the lock; extraction takes exclusive ownership.
function Open-WindowsDataLock([string]$Path, [switch]$Shared) {
    $announced = $false
    while ($true) {
        try {
            if ($Shared) { return [IO.File]::Open($Path, 'OpenOrCreate', 'Read', 'Read') }
            return [IO.File]::Open($Path, 'OpenOrCreate', 'ReadWrite', 'None')
        } catch [IO.IOException], [UnauthorizedAccessException] {
            if (-not $announced) { Write-Host "kazarov: waiting for $Path"; $announced = $true }
            Start-Sleep -Milliseconds 500
        }
    }
}

# A successful audit remains current while the archive, marker and extractor metadata agree.
function Get-WindowsDataAuditId([string]$Archive, [string]$Marker, [string]$Extractor) {
    return (@(Get-Item -LiteralPath $Archive, $Marker, $Extractor |
        ForEach-Object { '{0}|{1}|{2}' -f $_.FullName, $_.Length, $_.LastWriteTimeUtc.Ticks }) -join "`n")
}

# .NET's working directory is not PowerShell's location, so relative paths anchor to the checkout.
function Resolve-CheckoutPath([string]$Path) {
    if (![IO.Path]::IsPathRooted($Path)) { $Path = Join-Path (Join-Path $PSScriptRoot '../..') $Path }
    return [IO.Path]::GetFullPath($Path)
}

function Resolve-WindowsRoot([string]$Root) {
    if (!$Root) { $Root = Join-Path $PSScriptRoot '../../..' }
    return Resolve-CheckoutPath $Root
}

function Resolve-WindowsBuild([string]$Root, [string]$BuildDirectory) {
    if (!$BuildDirectory) { $BuildDirectory = Join-Path $Root 'build' }
    return Resolve-CheckoutPath $BuildDirectory
}

function Find-WindowsTool([string]$Name, [string]$Fallback) {
    $command = Get-Command $Name -ErrorAction SilentlyContinue
    if ($command) { return $command.Source }
    if (Test-Path -LiteralPath $Fallback) { return $Fallback }
    throw "Install $Name or add it to PATH."
}

function Find-WindowsPython {
    $command = Get-Command py -ErrorAction SilentlyContinue
    if ($command) {
        $python = & $command.Source -3 -c 'import sys; print(sys.executable)' 2>$null
    }
    if (!$python -or $LASTEXITCODE) {
        $python = & (Find-WindowsTool python '') -c 'import sys; print(sys.executable)'
    }
    if ($LASTEXITCODE) { throw 'Cannot locate Python 3' }
    return $python
}
