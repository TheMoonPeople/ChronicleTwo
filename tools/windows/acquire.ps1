#requires -Version 7.0
param([string]$Root, [switch]$VulkanLoader = $true)
$ErrorActionPreference = 'Stop'
. "$PSScriptRoot/common.ps1"
$root = Resolve-WindowsRoot $Root
$sevenZip = Find-WindowsTool 7z 'C:/Program Files/7-Zip/7z.exe'
$archives = Join-Path $root 'archives'
$deps = Join-Path $root 'deps'
New-Item -ItemType Directory -Force $archives,$deps | Out-Null
$downloads = @(
    @('llvm', 'https://github.com/mstorsjo/llvm-mingw/releases/download/20260922/llvm-mingw-20260922-ucrt-x86_64.zip', 'E3AD77D117A4BEA19A7A3B333341824D79A5A371004A10E25B8504E7B3047666'),
    @('ninja', 'https://github.com/ninja-build/ninja/releases/download/v1.13.2/ninja-win.zip', '07FC8261B42B20E71D1720B39068C2E14FFCEE6396B76FB7A795FB460B78DC65'),
    @('sdl', 'https://github.com/libsdl-org/SDL/releases/download/release-3.4.18/SDL3-devel-3.4.18-mingw.zip', 'CD98158C8D025A816F430A600B4E9526524E6219EE884EC72BD498B80FD3BF58'),
    @('ffmpeg', 'https://github.com/BtbN/FFmpeg-Builds/releases/download/autobuild-2026-10-13-13-05/ffmpeg-n9.0.2-27-g7e93014c5b-win64-lgpl-shared-9.0.zip', '9DF4DB960F3F0CD3ED76BE0A2BE96265D00DB4C3BE2526A6D39B03C2B547100D'),
    @('glslang', 'https://github.com/KhronosGroup/glslang/releases/download/16.6.0/glslang-16.6.0-windows-x86_64-release.zip', '82BF434E69B9BB4829DE7E2B4BC2C5E7A7861E53D66CF75E5CC70F5F694A8D9B'),
    @('vulkan', 'https://github.com/KhronosGroup/Vulkan-Headers/archive/refs/tags/vulkan-sdk-1.4.363.0.zip', 'F4BE95220FF0EE0B1C620301FF4FE9AE48592D71F4C30F2D5C571351A153AE81')
)
if ($VulkanLoader) {
    $downloads += ,@('vulkan-runtime', 'https://sdk.lunarg.com/sdk/download/1.4.363.0/windows/VulkanRT-X64-1.4.363.0-Components.zip', 'A25A927AA8B9F0371048F1861CF88AC3B9BC9B1FB332C42D897C8AB32695769A')
}
$downloads | ForEach-Object -Parallel {
    $name,$url,$expected = $_
    $archive = Join-Path $using:archives "$name.zip"
    $target = Join-Path $using:deps $name
    $timer = [Diagnostics.Stopwatch]::StartNew()
    Write-Host "kazarov: verifying $name"
    $hash = if (Test-Path -LiteralPath $archive) { Get-FileHash -LiteralPath $archive -Algorithm SHA256 }
    if ($null -eq $hash -or $hash.Hash -ne $expected) {
        if ($null -ne $hash) { Write-Host "kazarov: replacing stale or corrupt cached archive: $archive" }
        Write-Host "kazarov: downloading $name (log: $(Join-Path $using:archives "$name-download.log"))"
        $partial = "$archive.partial"
        try {
            & curl.exe -fL --retry 3 -o $partial $url 2> (Join-Path $using:archives "$name-download.log")
            if ($LASTEXITCODE) { throw "Download failed: $url" }
            $hash = Get-FileHash -LiteralPath $partial -Algorithm SHA256
            if ($hash.Hash -ne $expected) { throw "SHA-256 mismatch: $archive (expected $expected, got $($hash.Hash))" }
            Move-Item -LiteralPath $partial -Destination $archive -Force
            $hash.Path = $archive
        } finally {
            if (Test-Path -LiteralPath $partial) { Remove-Item -LiteralPath $partial -Force }
        }
    }
    Write-Host "kazarov: extracting $name (log: $(Join-Path $using:archives "$name-extract.log"))"
    & $using:sevenZip x -y "-o$target" $archive > (Join-Path $using:archives "$name-extract.log")
    if ($LASTEXITCODE) { throw "Extract failed: $archive" }
    Write-Host ("kazarov: {0} ready in {1:N1}s" -f $name, $timer.Elapsed.TotalSeconds)
    $hash | Select-Object Path,Hash
} -ThrottleLimit 4
$ffmpegLicense = Join-Path $deps 'ffmpeg/ffmpeg-n9.0.2-27-g7e93014c5b-win64-lgpl-shared-9.0/LICENSE.txt'
if ((Get-Content -LiteralPath $ffmpegLicense -TotalCount 1).Trim() -ne 'GNU LESSER GENERAL PUBLIC LICENSE') {
    throw "FFmpeg archive is not the LGPL variant: $ffmpegLicense"
}
Write-Host 'kazarov: preparing Rust and locked Cargo dependencies'
& "$PSScriptRoot/acquire-rust.ps1" -Root $root
if ($LASTEXITCODE) { exit $LASTEXITCODE }
