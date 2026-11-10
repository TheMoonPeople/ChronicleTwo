# Symbols and symbolising reports

Every PC build carries DWARF line tables in `darkchronicle`, so the crash handler (cpptrace, through libdwarf, and dbghelp on Windows) prints `file:line` for each frame of `report.txt` on the player's machine. `tools/crash/symbolize.py` re-resolves a report's raw frames afterwards, against the binary or symbols a build produced.

## What each build carries

`port/cmake/symbols.cmake` sets it up for `darkchronicle` and its tests:

- Debug and RelWithDebInfo keep their full `-g`. Release and MinSizeRel add `-gline-tables-only`: line tables and function names, no types or variables.
- Linux links with `-Wl,--build-id=sha1`, giving an `NT_GNU_BUILD_ID` note. Windows links with `-Wl,--build-id`; llvm-mingw lld writes a CodeView `RSDS` record (GUID and age) whether or not a PDB is written. Mach-O links have an `LC_UUID`, and ld64 has no build id option. The report's `build id:` line prints that note, record (`GUID` then age, the symbol-server spelling) or UUID.
- macOS: ld64 leaves DWARF in the object files, so a POST_BUILD `dsymutil` writes `darkchronicle.dSYM` in RelWithDebInfo, Release and MinSizeRel. cpptrace finds the dSYM beside the binary. Ship it with the binary, or a moved binary has no line tables.

`CT_SYMBOLS` (cache string) selects the mode:

| Value | Effect |
| --- | --- |
| `embedded` (default) | The above. |
| `split` | Also writes developer symbol files beside the binary. Windows: `-gdwarf -gcodeview` and `-Wl,--pdb=` write `darkchronicle.pdb` for WinDbg, Visual Studio and symbol servers. The exe keeps its DWARF for cpptrace. Linux: POST_BUILD `objcopy --only-keep-debug` writes `darkchronicle.debug`, and `--add-gnu-debuglink` names it. The binary is not stripped, so it keeps its own line tables. macOS: the dSYM is written in Debug too. |
| `off` | No added flags or steps. |

The Windows PDB stays opt-in. With `--pdb`, lld moves the COFF symbol table into the PDB. Function names in the exe then come only from DWARF, which in split mode has no linkage names, so frames print as `LoadFileBG` rather than `LoadFileBG(char*, unsigned __int128*, int*)`. llvm-symbolizer reads a PDB only through its exe. It finds the PDB at the path the exe records, or beside the exe. [Build measurements](port/buildperf.md#debug-information-size-and-link-time) has the sizes and link times.

The Flatpak sets `no-debuginfo: true` on the `chronicletwo` module. Otherwise flatpak-builder moves every debug section, line tables included, into the `.Debug` extension. `package.ps1` takes only the runtime manifest's `.exe` and `.dll` files, so no PDB reaches the user zip.

## Symbol artifacts

CI uploads one symbol artifact per job, named with the commit (`chronicletwo-<platform>-symbols-<sha>`):

| Job | Artifact | Contents |
| --- | --- | --- |
| Windows | `chronicletwo-windows-x64-symbols-<sha>` | `tools/windows/package-symbols.ps1`: `darkchronicle.exe` and `dc2data.exe` (their DWARF), any PDBs, and `build-ids.txt` |
| macOS | `chronicletwo-macos-arm64-symbols-<sha>` | `darkchronicle` and `darkchronicle.dSYM` (`CT_SYMBOLS=split`) |
| Flatpak | `chronicletwo-flatpak-x86_64-symbols-<sha>` | The packaged Release `darkchronicle`, which keeps its line tables |

The Linux job configures `CT_SYMBOLS=split`. It checks the build id note and debuglink, and resolves a frame through `darkchronicle.debug`. It uploads nothing: its Debug binary is not distributed, and the Flatpak is the shipped Linux build. The macOS and Windows jobs build Release with ThinLTO and resolve a frame at `main`/`wmain` to `main.cpp` the same way.

`pwsh -NoProfile -File tools/windows/package-symbols.ps1 -BuildDirectory <build> -Destination symbols.zip` packages a local Windows build.

## Symbolising reports

A report's `== raw frames ==` section lists one frame per line as `#N  <module>+0x<offset>`. The offset is relative to the module's load base: a PE RVA, the ELF virtual address of a PIE, or the distance from the Mach-O header. The `build id:` line names the build. `symbolize.py` prints the report with each raw frame followed by its resolved frames, innermost inline frame first:

```
#0  darkchronicle.exe+0x64c67
    -> (anonymous namespace)::CrashTestSegv() at .../port/src/crash/crash_test_modes.cpp:38:54
```

```sh
# Against the matching binary (or its .debug, .dSYM or .pdb):
python3 tools/crash/symbolize.py report.txt --binary path/to/darkchronicle.exe
# Against an unpacked symbol artifact, looked up by module name, in <dir>/<build id>/ first:
python3 tools/crash/symbolize.py report.txt --symbols symbols/ -o symbolized.txt
```

- Each module's object comes from `--binary` (matched by file name or stem, so `darkchronicle.exe` matches `darkchronicle.pdb`) or from `--symbols DIR`. The lookup tries `<module>.debug`, `<stem>.debug`, `<module>.dSYM`, the module itself, then `<stem>.exe` (with its PDB beside it).
- llvm-symbolizer resolves ELF, Mach-O (dSYM or binary) and PE (DWARF or PDB). The tool takes it from `--llvm-symbolizer`, `LLVM_SYMBOLIZER`, `PATH`, or on Windows the toolchain under `.kazarov/windows`. On macOS without it, Xcode's `atos` is used against the dSYM.
- The image base comes from `llvm-readobj`: COFF `ImageBase`, the lowest ELF `PT_LOAD` (0 for a PIE), or the Mach-O `__TEXT` vmaddr. Without llvm-readobj, the usual bases are assumed.
- Frames in system modules print `-> ??`. Exit status: 0 when any frame resolved, 1 when none did, 2 for usage errors or a missing tool.

`python3 -m unittest discover -s tools/crash -p "test_*.py"` runs the parser tests and an end-to-end case against a clang-built probe; the Linux CI job runs them.
