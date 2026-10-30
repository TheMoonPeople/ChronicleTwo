#requires -Version 7.0
# Checks bundle invalidation without Docker or a native toolchain.
$ErrorActionPreference = 'Stop'
. "$PSScriptRoot/common.ps1"
$tokens = $null
$errors = $null
$ast = [Management.Automation.Language.Parser]::ParseFile((Join-Path $PSScriptRoot 'kazarov.ps1'), [ref]$tokens, [ref]$errors)
if ($errors.Count) { throw ($errors -join "`n") }
$function = $ast.Find({ param($node) $node -is [Management.Automation.Language.FunctionDefinitionAst] -and $node.Name -eq 'Get-DependencyId' }, $true)
. ([scriptblock]::Create($function.Extent.Text))
$fixture = Join-Path ([IO.Path]::GetTempPath()) "chronicle deps test $([Guid]::NewGuid())"
try {
    foreach ($directory in 'tools/ci', 'port/cmake', 'port/src/tests', 'tools/kazarov/cmake', 'tools/kazarov/tools/ffmpeg') {
        New-Item -ItemType Directory -Path (Join-Path $fixture $directory) -Force | Out-Null
    }
    foreach ($file in 'tools/ci/Dockerfile', 'tools/ci/Dockerfile.dockerignore', 'tools/kazarov/tools/ffmpeg/kz-ffmpeg', 'port/src/tests/CMakeLists.txt') {
        Set-Content -LiteralPath (Join-Path $fixture $file) -Value '# fixture'
    }
    $ffmpeg = Join-Path $fixture 'tools/kazarov/tools/ffmpeg/kz-ffmpeg'
    @'
VERSION = '1'
SHA256 = 'fixture'
LICENSE_LINE = 'LGPL'
CONFIGURE_FLAGS = [
    '--disable-static',
]
'@ | Set-Content -LiteralPath $ffmpeg
    $declaration = 'FetchContent_Declare(example URL https://example.com/one URL_HASH SHA256=' + ('a' * 64) + ')'
    $cmake = Join-Path $fixture 'port/CMakeLists.txt'
    Set-Content -LiteralPath $cmake -Value $declaration
    $original = Get-DependencyId $fixture
    Add-Content -LiteralPath $cmake -Value "`n# unrelated build change`nset(EXAMPLE ON)"
    if ((Get-DependencyId $fixture) -ne $original) { throw 'Unrelated CMake change invalidates dependencies' }
    Add-Content -LiteralPath $ffmpeg -Value '# unrelated host helper change'
    if ((Get-DependencyId $fixture) -ne $original) { throw 'Unrelated FFmpeg helper change invalidates dependencies' }
    $ffmpeg_text = [IO.File]::ReadAllText($ffmpeg)
    Set-Content -LiteralPath $ffmpeg -Value $ffmpeg_text.Replace('--disable-static', '--enable-static')
    if ((Get-DependencyId $fixture) -eq $original) { throw 'FFmpeg configuration change was missed' }
    Set-Content -LiteralPath $ffmpeg -Value $ffmpeg_text
    Set-Content -LiteralPath $cmake -Value $declaration.Replace('/one', '/two')
    if ((Get-DependencyId $fixture) -eq $original) { throw 'Dependency URL change was missed' }
    Set-Content -LiteralPath $cmake -Value $declaration.Replace(('a' * 64), ('b' * 64))
    if ((Get-DependencyId $fixture) -eq $original) { throw 'Dependency checksum change was missed' }
    Set-Content -LiteralPath $cmake -Value $declaration
    $vendor = Join-Path $fixture 'tools/kazarov/cmake/vendor.cmake'
    $vendor_declaration = '_kz_port_vendor(headers example.hpp https://example.com/header ' + ('c' * 64) + ')'
    Set-Content -LiteralPath $vendor -Value $vendor_declaration
    $with_vendor = Get-DependencyId $fixture
    if ($with_vendor -eq $original) { throw 'New vendor dependency was missed' }
    Set-Content -LiteralPath $vendor -Value $vendor_declaration.Replace(('c' * 64), ('d' * 64))
    if ((Get-DependencyId $fixture) -eq $with_vendor) { throw 'Vendor checksum change was missed' }
    Remove-Item -LiteralPath $vendor
    Add-Content -LiteralPath (Join-Path $fixture 'tools/ci/Dockerfile') -Value '# recipe change'
    if ((Get-DependencyId $fixture) -eq $original) { throw 'Acquisition recipe change was missed' }
    $archive = Join-Path $fixture 'data.zip'
    $marker = Join-Path $fixture 'data.json'
    $extractor = Join-Path $fixture 'dc2data.exe'
    foreach ($file in $archive, $marker, $extractor) { Set-Content -LiteralPath $file -Value 'fixture' }
    $audit_id = Get-WindowsDataAuditId $archive $marker $extractor
    if ((Get-WindowsDataAuditId $archive $marker $extractor) -ne $audit_id) { throw 'Unchanged data invalidates its audit' }
    foreach ($file in $archive, $marker, $extractor) {
        Add-Content -LiteralPath $file -Value 'changed'
        $changed = Get-WindowsDataAuditId $archive $marker $extractor
        if ($changed -eq $audit_id) { throw "Changed $file did not invalidate the audit" }
        $audit_id = $changed
    }
    $shared = Open-WindowsDataLock (Join-Path $fixture 'data.lock') -Shared
    try {
        $second = Open-WindowsDataLock (Join-Path $fixture 'data.lock') -Shared
        $second.Dispose()
    } finally { $shared.Dispose() }
    # Exercise routing before any lock, dependency acquisition or compilation is entered.
    New-Item -ItemType Directory -Path (Join-Path $fixture 'tools/windows'), (Join-Path $fixture 'tools/kazarov/scripts') -Force | Out-Null
    Copy-Item -LiteralPath (Join-Path $PSScriptRoot 'common.ps1') -Destination (Join-Path $fixture 'tools/windows/common.ps1')
    $launcher = [IO.File]::ReadAllText((Join-Path $PSScriptRoot 'kazarov.ps1')).Split('switch ($config.ToLower())')[0]
    $launcher += "`nWrite-Output (`"native {0} {1}`" -f `$config, (`$rest -join '|'))"
    Set-Content -LiteralPath (Join-Path $fixture 'tools/windows/kazarov.ps1') -Value $launcher
    @'
param($Root, $Command, [Parameter(ValueFromRemainingArguments)]$Rest)
Write-Output ("container {0} {1}" -f $Command, ($Rest -join '|'))
exit 0
'@ | Set-Content -LiteralPath (Join-Path $fixture 'tools/kazarov/scripts/kazarov.ps1')
    @'
KZ_DEFAULT_RUN_WINDOWS=windows-x64-release
KZ_CONTAINER_CONFIGS="ps2-pal custom-platform"
'@ | Set-Content -LiteralPath (Join-Path $fixture 'kazarov.conf')
    $shell = (Get-Process -Id $PID).Path
    $route = & $shell -NoProfile -File (Join-Path $fixture 'tools/windows/kazarov.ps1') run custom-platform --option 'two words'
    if ($LASTEXITCODE -or $route -ne 'container run custom-platform|--option|two words') { throw "Container routing failed: $route" }
    $route = & $shell -NoProfile -File (Join-Path $fixture 'tools/windows/kazarov.ps1') run windows-x64 --option 'two words'
    if ($LASTEXITCODE -or $route -ne 'native windows-x64 --option|two words') { throw "Native routing failed: $route" }
    Write-Host 'Windows dependency invalidation checks passed'
} finally {
    # The unique absolute fixture directory is the only cleanup target.
    if (Test-Path -LiteralPath $fixture) { Remove-Item -LiteralPath $fixture -Recurse -Force }
}
