# Audit every bundled PE import without consulting PATH or developer-installed DLLs.
param([Parameter(Mandatory)][string]$BuildDirectory)
$ErrorActionPreference = 'Stop'
. "$PSScriptRoot/common.ps1"
$build = Resolve-CheckoutPath $BuildDirectory
$compiler = Select-String -LiteralPath (Join-Path $build 'CMakeCache.txt') -Pattern '^CMAKE_CXX_COMPILER:[^=]+=(.+)$' |
    Select-Object -First 1
if (!$compiler) { throw 'CMake compiler path is missing.' }
$inspector = Join-Path (Split-Path $compiler.Matches[0].Groups[1].Value) 'llvm-readobj.exe'
$names = @(Get-Content -LiteralPath (Join-Path $build 'windows-runtime-files.txt') | Where-Object { $_.Trim() })
# These are OS components on supported Windows versions, not application redistributables.
$system = @('advapi32.dll', 'avicap32.dll', 'avrt.dll', 'bcrypt.dll', 'bcryptprimitives.dll', 'cfgmgr32.dll', 'combase.dll',
    'comctl32.dll', 'comdlg32.dll', 'crypt32.dll', 'd2d1.dll', 'd3d11.dll', 'dcomp.dll',
    'dnsapi.dll', 'dwmapi.dll', 'dwrite.dll', 'dxgi.dll', 'gdi32.dll', 'imm32.dll', 'iphlpapi.dll', 'kernel32.dll',
    'msimg32.dll', 'msvcrt.dll', 'ncrypt.dll', 'ntdll.dll', 'ole32.dll', 'oleaut32.dll', 'opengl32.dll', 'propsys.dll',
    'rpcrt4.dll', 'secur32.dll', 'setupapi.dll', 'shell32.dll', 'shlwapi.dll', 'user32.dll',
    'userenv.dll', 'usp10.dll', 'uxtheme.dll', 'version.dll', 'winmm.dll', 'winspool.drv', 'ws2_32.dll')
foreach ($name in $names) {
    if ($name -ne [IO.Path]::GetFileName($name)) { throw "Invalid runtime entry: $name" }
    $path = Join-Path $build $name
    if (!(Test-Path -LiteralPath $path -PathType Leaf)) { throw "Missing runtime file: $name" }
    $imports = & $inspector --coff-imports $path
    if ($LASTEXITCODE) { throw "Could not inspect $name" }
    foreach ($line in $imports) {
        if ($line -match '^\s*Name: (.+\.(dll|drv))$') {
            $dependency = $Matches[1].ToLowerInvariant()
            if ($dependency -match '^(api-ms-|ext-ms-)' -or $dependency -in $system) { continue }
            if ($dependency -notin $names) { throw "$name requires unbundled dependency $dependency" }
        }
    }
}
Write-Output "Verified imports of all $($names.Count) bundled program/runtime files."
