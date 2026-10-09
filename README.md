# Chronicle Two

[![PAL Progress]](https://decomp.dev/TheMoonPeople/ChronicleTwo/pal)

[PAL Progress]: https://decomp.dev/TheMoonPeople/ChronicleTwo/pal.svg?mode=shield&label=PAL&measure=matched_code_percent
[progress_link]: https://decomp.dev/TheMoonPeople/ChronicleTwo/

[<img src="https://decomp.dev/TheMoonPeople/ChronicleTwo/pal.svg?w=512&h=256" width="512" height="256" alt="PAL decompilation progress">][progress_link]

Chronicle Two is a decompilation project (and eventual port) of Dark
Chronicle/Dark Cloud 2 for the PlayStation 2.

# Building and running

1. Clone the repository with `git clone --recurse-submodules https://github.com/TheMoonPeople/ChronicleTwo.git`
2. Place the PAL retail build named `Dark Chronicle (PAL).iso` in the `rom/pal/` folder at the root of the project.
3. Build [Satan's Fiddle](https://github.com/Adubbz/SatansFiddle) with its documented LLDB and unstripped `wibo` prerequisites. Set `SATANSFIDDLE` to the resulting executable, or place `satansfiddle` on `PATH`.
4. Run `build.sh`.

`build.sh` builds the game.
`run.sh` builds the disc image and boots it in PCSX2.

MWCC 3.0 compilation runs through Satan's Fiddle using
[the JSON profile](scripts/build/satansfiddle.json). `SATANSFIDDLE_CONFIG` selects
a different profile. CMake also accepts `-DSATANSFIDDLE=/absolute/path/satansfiddle`
and `-DSATANSFIDDLE_CONFIG=/absolute/path/profile.json`; these cached settings
take precedence over later environment changes. MWLD still runs under plain `wibo`.
See [the compiler integration notes](scripts/build/SATANSFIDDLE.md) for the wrapper,
selectors, and validation commands.

# Formatting

Run `python3 scripts/lint/format.py` to format tracked C/C++ files with the
project's `.clang-format`. Use `--check` to check without writing. Set
`CLANG_FORMAT` to select a formatter executable; the current pass uses version
19.1.7. The script preserves Metrowerks assembly blocks, which clang-format
cannot parse safely.

Run `scripts/lint/tidy.sh` for diagnostics or `scripts/lint/tidy.sh --fix` to
apply available fixes and format through the assembly-preserving formatter.
This requires clang-tidy, the matching LLVM development headers, and clang-format.
Clang cannot parse every Metrowerks construct; check renamed variables used in
assembly and verify the retail match after applying fixes.
