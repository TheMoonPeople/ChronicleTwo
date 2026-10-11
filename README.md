# Chronicle Two

[![PAL Progress]](https://decomp.dev/TheMoonPeople/ChronicleTwo/pal)

[PAL Progress]: https://decomp.dev/TheMoonPeople/ChronicleTwo/pal.svg?mode=shield&label=PAL&measure=matched_code_percent
[progress_link]: https://decomp.dev/TheMoonPeople/ChronicleTwo/

[<img src="https://decomp.dev/TheMoonPeople/ChronicleTwo/pal.svg?w=512&h=256" width="512" height="256" alt="PAL decompilation progress">][progress_link]

Chronicle Two is a decompilation project (and eventual port) of Dark
Chronicle/Dark Cloud 2 for the PlayStation 2.

## Building and running

Clone with submodules: `git clone --recurse-submodules https://github.com/TheMoonPeople/ChronicleTwo.git`

Place the PAL disc image `Dark Chronicle (PAL).iso` in `rom/pal/`. The build
runs in a container that [Kazarov](tools/kazarov/README.md) builds on first use,
so Docker or Podman must be installed.

- `./build.sh` builds the PAL executable (`ps2-pal`) and checks it against retail.
  `./build.sh ps2-pal elf objdiff` builds only the named targets; `CLEAN=1 ./build.sh`
  rebuilds from scratch.
- `./run.sh` builds, masters a disc image and boots it in PCSX2.
- `build.bat` and `run.bat` do the same on Windows.
- `tools/kazarov/bin/kazarov shell` opens a shell in the build container, with the
  project at `/work/chronicletwo`.

## Diffing

Build with `./build.sh ps2-pal elf objdiff`, then open the project in the objdiff
GUI. It reads the `objdiff.json` that the build writes at the root.
