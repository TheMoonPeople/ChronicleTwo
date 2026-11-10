# Packages a build's symbols for tools/crash/symbolize.py (docs/SYMBOLS.md): darkchronicle.exe and dc2data.exe,
# whose embedded DWARF is a symbol file of its own and through which llvm-symbolizer reads a PDB, each one's PDB
# when CT_SYMBOLS=split wrote one, and build-ids.txt naming each executable's build id as crash reports print it.
# package.ps1 never ships the PDBs.
param([Parameter(Mandatory)][string]$BuildDirectory,
      [Parameter(Mandatory)][string]$Destination,
      [string]$Root)
$ErrorActionPreference = 'Stop'
. "$PSScriptRoot/common.ps1"
$build = Resolve-CheckoutPath $BuildDirectory
$archive = Resolve-CheckoutPath $Destination
$root = Resolve-WindowsRoot $Root
$readobj = Join-Path $root 'deps/llvm/llvm-mingw-20260922-ucrt-x86_64/bin/llvm-readobj.exe'
if (!(Test-Path -LiteralPath $readobj)) { $readobj = Find-WindowsTool llvm-readobj '' }
$files = @()
$ids = foreach ($name in 'darkchronicle.exe', 'dc2data.exe') {
    $exe = Join-Path $build $name
    if (!(Test-Path -LiteralPath $exe -PathType Leaf)) { throw "Missing $exe. Build first." }
    # The CodeView record's GUID and age, in the symbol-server spelling the crash report uses.
    $directory = (& $readobj --coff-debug-directory $exe) -join "`n"
    if ($LASTEXITCODE) { throw "llvm-readobj failed on $exe" }
    $id = '-'
    if ($directory -match 'PDBGUID: \{([0-9A-F-]+)\}\s+PDBAge: (\d+)') {
        $id = ($Matches[1] -replace '-', '') + ('{0:X}' -f [int]$Matches[2])
    }
    "$name $id"
    $files += $exe
    $pdb = [IO.Path]::ChangeExtension($exe, '.pdb')
    if (Test-Path -LiteralPath $pdb -PathType Leaf) { $files += $pdb }
}
$list = Join-Path $build 'build-ids.txt'
Set-Content -LiteralPath $list -Value $ids
Compress-Archive -LiteralPath @($files; $list) -DestinationPath $archive -Force
Write-Output "Packaged $($files.Count) symbol files and build-ids.txt in $archive."
