# Packages CMake's program/runtime list and the gameplay archive seed.
param([Parameter(Mandatory)][string]$BuildDirectory,
      [Parameter(Mandatory)][string]$Destination)
$ErrorActionPreference = 'Stop'
. "$PSScriptRoot/common.ps1"
$build = Resolve-CheckoutPath $BuildDirectory
$archive = Resolve-CheckoutPath $Destination
& "$PSScriptRoot/check-runtime.ps1" -BuildDirectory $build
$manifest = Join-Path $build 'windows-runtime-files.txt'
$names = @(Get-Content -LiteralPath $manifest | Where-Object { $_.Trim() })
if ('darkchronicle.exe' -notin $names -or 'dc2data.exe' -notin $names -or 'vulkan-1.dll' -notin $names) {
    throw 'The runtime manifest is incomplete. Reconfigure and build first.'
}
$paths = foreach ($name in $names) {
    if ($name -ne [IO.Path]::GetFileName($name) -or $name -notmatch '\.(exe|dll)$') {
        throw "Unexpected runtime manifest entry: $name"
    }
    $path = Join-Path $build $name
    if (!(Test-Path -LiteralPath $path -PathType Leaf)) { throw "Missing runtime file: $path" }
    $path
}
$gameplay = Join-Path $build 'assets/data.zip'
if (!(Test-Path -LiteralPath $gameplay -PathType Leaf)) { throw "Missing gameplay archive: $gameplay" }
$packageFiles = @($paths) + @($gameplay)
# The scripts' Luau sources ship loose beside the executable; without them every script runs on the interpreter.
$scripts = Join-Path $build 'scripts'
if (!(Test-Path -LiteralPath (Join-Path $scripts 'mainchr/c01.luau') -PathType Leaf)) { throw "Missing Luau scripts: $scripts" }
$luauLicense = Join-Path $build 'Luau-LICENSE.txt'
if (!(Test-Path -LiteralPath $luauLicense -PathType Leaf)) { throw "Missing Luau license: $luauLicense" }
$packageFiles += @($scripts, $luauLicense)
# The message font ships beside the executable with Kosugi's licence and the notice of what was changed.
$fonts = Join-Path $build 'fonts'
if (!(Test-Path -LiteralPath (Join-Path $fonts 'ChronicleTwoMessage-Regular.ttf') -PathType Leaf)) { throw "Missing message font: $fonts" }
$packageFiles += $fonts
$cmakeCache = Join-Path $build 'CMakeCache.txt'
$tracyEnabled = @(Get-Content -LiteralPath $cmakeCache | Where-Object { $_ -eq 'CT_ENABLE_TRACY:BOOL=ON' }).Count -ne 0
if ($tracyEnabled) {
    $tracyLicense = Join-Path $build 'Tracy-LICENSE.txt'
    if (!(Test-Path -LiteralPath $tracyLicense -PathType Leaf)) { throw "Missing Tracy license: $tracyLicense" }
    $packageFiles += $tracyLicense
}
Compress-Archive -LiteralPath $packageFiles -DestinationPath $archive -Force
Write-Output "Packaged $($paths.Count) program/runtime files, data.zip, scripts/ and fonts/ in $archive."
