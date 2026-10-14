# PC port

`PLATFORM=PC` builds the PAL game's code (`SCES_511.90`) as a native x64 program, compiled by clang as C++26, on SDL3 and Vulkan 1.4. ChronicleTwo ships only the PAL release, so PAL is the only region the port builds for.

The port runs the retail main loop on the shared renderer and mixer, reading extracted PAL disc files. Supported checkpoints include the boot movies, title, costume selection, opening event, Palm Brinks exploration and the first Underground Channel floor. Town and dungeon movement, inventory item use, chapter resources, menus, photos and save/continue have native implementations and bounded replay fixtures. These checkpoints do not establish a complete campaign or every sub-game; the fish race still aborts at its unimplemented loop.

The PC controls include keyboard menu navigation, mouse menus and item drag/drop, town and dungeon mouse camera control, optional wheel zoom, a PC settings page and flat save files. Sharp ASCII font rendering is an opt-in prototype, off by default. Presentation can interpolate between logic frames independently of the display rate. Ordinary boots leave debug controls disabled; `game.debug_mode=true` or `--jump` enables them explicitly.

## Building and running

### Linux

```sh
./build.sh linux-x64
tools/kazarov/scripts/kazarov shell ctest --test-dir port/build/pc --output-on-failure -j4
```

`./build.sh linux-x64` builds in the Kazarov container, from the image in `tools/kazarov/image` (built locally the first time), with the Debug preset into `port/build/pc`. `linux-x64-release` builds Release into `port/build/pc-release`. `CLEAN=1` discards the build directory first; `JOBS=N` sets the parallel job count.

Without the container, `cmake --preset linux-x64`, `cmake --build --preset linux-x64` and `ctest --preset linux-x64` do the same work. The host needs what the image provides: clang 20 or newer with lld, CMake 3.25 or newer (the presets need it), Ninja, `glslangValidator`, SDL3 3.4, the Vulkan 1.4 headers and loader, Python 3, and Rust 1.99 (provided by the container and Windows toolchain setup).

The renderer's cases need a Vulkan device with the features `tools/kazarov/src/cpp/gfx/README.md` lists under "Device". The container's Mesa lavapipe provides them, so no GPU is needed there.

`./run.sh linux-x64` builds, then runs `port/build/pc/darkchronicle` on a Linux host. It extracts the PAL source into the ignored `port/run/` root with `dc2data`, under `.kazarov/locks/port-data.lock`. The game holds the lock shared while it runs. The extractor verifies source and output hashes on each launch and skips publication when both already match.

### Windows

```bat
.\build.bat windows-x64
.\run.bat windows-x64
```

`build.bat` and `run.bat` pass the configuration through Kazarov's host launcher to `tools/windows/kazarov.ps1`. That script builds into `port/build/<configuration>`. The first run fetches the toolchain into `.kazarov/windows`, through `tools/windows/acquire.ps1`: llvm-mingw 20260922 (clang and lld), Ninja 1.13.2, SDL3 3.4.18 (MinGW), FFmpeg n9.0.2 (the LGPL shared build), glslang 16.6.0, the Vulkan 1.4.363.0 headers, and Rust 1.99.0 for the llvm-mingw UCRT target. `acquire-rust.ps1` verifies the official Rust and rustfmt archives, caches the locked crates, and installs `cxxbridge-cmd` 1.0.205; Corrosion 0.6.1 integrates Rust with CMake. Each downloaded archive is checked against its SHA-256 before extraction. `windows-x64` is a Debug build; `windows-x64-release` (and `windows`) is RelWithDebInfo.

The Windows launcher prints elapsed stages for dependency checks, configuration and the build, and announces any lock wait. Compiler and Cargo output appears live, with the complete latest build output retained in `port/build/<configuration>/build.log`; failures preserve the native exit code. First-run downloads, archive verification and extraction announce their stages and log paths. `JOBS=N` sets the compile job count (12 by default). See [build measurements](port/buildperf.md) for the measured incremental costs. `pwsh -NoProfile -File tools/windows/test-build.ps1` checks live stdout/stderr, full logging and successful/failing exit codes without requiring a toolchain.

`run.bat` uses the same ignored `port/run/` extraction and version checks before launching, under the `port-data.lock` lock. The game holds the lock shared while it runs.

The scripts need PowerShell 7, 7-Zip, CMake and Python 3. Python 3 is found through the `py` launcher or on `PATH`. 7-Zip and CMake are also looked for at their default install locations under `Program Files`.

The test build is separate. After a `build.bat` run has fetched the toolchain:

```powershell
./tools/windows/configure-tests.ps1 -Root .kazarov/windows -BuildDirectory port/build/windows-x64-tests
./tools/windows/build.ps1 -Root .kazarov/windows -BuildDirectory port/build/windows-x64-tests -Tests
ctest --test-dir port/build/windows-x64-tests --output-on-failure -j4
```

Windows builds include the SDL, FFmpeg, C++/Rust runtime DLLs and the pinned redistributable Vulkan loader beside the executables. Acquisition includes the loader by default. CMake restores the runtime files on every build, including direct `cmake --build` calls; `cmake --install` also installs them. Running the built game requires no separate application runtime installation. A compatible graphics driver is still required.

`tools/windows/package.ps1 -BuildDirectory port/build/windows-x64-tests -Destination chronicletwo-windows-x64.zip` packages only CMake's explicit list of executables and runtime DLLs. It audits each binary's imports and fails if a non-Windows dependency is missing. Neither the build packaging nor installation includes retail assets, `data`, `port_data`, saves or disc images. First-run setup extracts the user's disc data after launch.

### macOS

```sh
./build.sh macos-arm64
ctest --preset macos-arm64
```

`macos-arm64` is a Debug build with the Homebrew preset in `CMakePresets.json`, into `port/build/macos-arm64`. `macos-arm64-release` is the Release build. The preset expects Homebrew's LLVM under `/opt/homebrew/opt/llvm`, and its `CMAKE_PREFIX_PATH` also names `sdl3`, `vulkan-headers`, `vulkan-loader` and `glslang`. CI additionally installs `molten-vk`, `googletest` and `nlohmann-json`. To run the game, SDL needs the loader by its full path, and the loader needs the MoltenVK driver:

```sh
export SDL_VULKAN_LIBRARY="$(brew --prefix vulkan-loader)/lib/libvulkan.1.dylib"
export VK_DRIVER_FILES="$(brew --prefix)/etc/vulkan/icd.d/MoltenVK_icd.json"
```

### The PS2 build

```sh
./build.sh ps2-pal
BUILD_DIR=build/pal python3 scripts/build/verify.py -c
```

`./build.sh ps2-pal` builds `build/pal` in the container. `verify.py -c` checks the rebuilt executable against retail. Every change to `ps2/` must leave that check passing (see "Keeping the PS2 build matching").

### Continuous integration

`.github/workflows/pc.yml` runs on pushes to `master` and on pull requests, in four jobs:

- Linux (`ubuntu-26.04`): configures `linux-x64` with `-DCT_TEST_TIMEOUT=60` (lavapipe renders on the CPU), builds it in the Kazarov container, checks that the clang Python bindings import, runs the full `ctest`, runs `scripts/port/native_gate.py` on the binary, and checks that `darkchronicle` is position-independent. Without the bindings, `Truncations.Check` and `Records.Check` skip, and a skip counts as a pass.
- macOS (`macos-26`, Homebrew libraries): builds `macos-arm64`, runs `ctest --preset macos-arm64`, and uploads the packaged binary and a `vulkaninfo` summary. The pinned shared code carries the executable bit for `tools/kazarov/scripts/build/kz-ffmpeg`.
- Windows (`windows-2025`): fetches the toolchain and the Vulkan runtime with `acquire.ps1 -VulkanLoader`, configures the test build with `configure.ps1 -Tests -VulkanLibrary`, builds it, runs `ctest -LE gpu`, and uploads the zipped build.
- Flatpak (Flathub's `freedesktop-26.08` image): checks that `port/flatpak/cargo-sources.json` matches Kazarov's `Cargo.lock`, builds `chronicletwo.flatpak` from the commit under test (`docs/FLATPAK.md`), uploads it, and checks that the packaged `darkchronicle` reaches its data check.

Cases default to a 5-second timeout. Slow GPU cases use the larger of 30 seconds and `CT_TEST_TIMEOUT`, so the Linux job gives them 60 seconds. Cases that need a Vulkan device carry the CTest label `gpu`. The hosted Windows runner has no device, so its job excludes them with `-LE gpu`. `ctest -L gpu -N` lists them. Local runs run every case.

### Game data and first run

The port reads the game's files from an extraction made by `dc2data`:

```sh
dc2data extract <iso-or-directory> <data-directory>
dc2data list <iso-or-directory>
dc2data sound <iso-or-directory>
dc2data check <data-directory>
dc2data current <iso-or-directory> <data-directory>
```

`extract` uses up to 32 workers by default; `--jobs N` accepts 1 through 64.
`current` compares the source's path and file metadata with the versioned marker and verifies both manifests exist; it returns 0 only when extraction can be skipped. `check` performs the full hash and payload audit.

The source of `extract` is a Dark Chronicle disc image or a folder holding `DATA.HD4`, `DATA.DAT`, `SOUND.HD3`, `SOUND.DAT` and `MOVIE`. Give it `<game-root>/data` as the output. The C++ command-line program calls the Rust extractor through a `cxx` bridge for `extract`, `list`, `sound`, and `check`; the conversion runs in process without Python. It writes non-texture files under `data/`, converted PNGs and their catalog under sibling `port_data/`, and a version marker at `<game-root>/data.json`. Each retail texture group has an `.img` bundle folder preserving the hierarchy above it; all PNGs are direct children of that folder, and its versioned JSON maps their filenames to logical items, pictures, mips and colour variants. Proprietary texture payloads are excluded, including those embedded in mixed PACK files and other retail wrappers; catalog keys retain their original filenames and embedded offsets. Comment-free JSON manifests in `data/` and `port_data/` record SHA-256 hashes; `dc2data check <game-root>/data` verifies both trees and the version marker. Extraction stages both trees before publication and restores the previous output on failure. Exit status: 0 on success, 1 on an error or failed check, 2 on usage error.

Each texture variant is a full-colour RGBA PNG. When retail animation scripts copy colours between textures, extraction bakes the finite source-colour variants into separate destination PNGs and records their selection in the catalog. Source palettes are used only during extraction; runtime textures and generated render targets use RGBA pixels without palette files or palette uploads. `data.json` carries the current `data_version`, and the game rejects an older extraction so the launcher can rebuild it.

`run.sh` and `run.bat` pass `--run-dir <checkout>/port/run`, giving them `port/run/data`, `port/run/port_data` and `port/run/saves`. A direct executable launch defaults to the per-user `chronicletwo` application data root with the same three subdirectories. Explicit `--run-dir DIR` selects a different root.

### Datapacks and replacement textures

Put texture packs in a `datapacks/` directory beside the selected `port_data/`
directory. The launch scripts therefore use `port/run/datapacks/`; `--data DIR`
uses `DIR/../datapacks/`. Each pack is a folder with any single folder name,
including spaces or Unicode characters. Copy the paths inside `port_data/`
directly into that folder, replacing the PNGs you want to change:

```text
<game-root>/
  data/
  port_data/
    menu/example.img/texture.png
  datapacks/
    datapacks.json
    My texture pack/
      menu/example.img/texture.png
    Menu tweaks/
      menu/example.img/texture.png
```

Activate packs and set their priority in `datapacks/datapacks.json`:

```json
{
  "schema_version": 1,
  "load_order": ["My texture pack", "Menu tweaks"]
}
```

Later entries win when multiple packs replace the same PNG. Packs may contain
just one file: missing files fall through to earlier packs, then to `port_data/`.
Unlisted folders are inactive. Packs use the existing catalog and do not need
their own catalog, bundle JSON or manifest. Folder names must stay within the
`datapacks/` directory; paths and `..` are rejected. Missing configuration leaves
the retail textures active; invalid configuration disables the packs and prints
a diagnostic. Restart the game after changing configuration or pack files.

Replacement PNGs may use the original dimensions or enlarge both dimensions by
the same power of two, such as 2×, 4× or 8×. The texture keeps its original size
and UV layout in the game while the renderer uses the larger image. A corrupt
PNG, unsupported scale or invalid mip level prints a diagnostic and falls back
to the next available image. A pack can replace only the base PNG of a mipmapped
texture: missing enlarged mip levels are generated from the replacement image.
Explicit replacement mip levels must match the enlarged mip chain. Colour
variants are separate PNGs, so copy each variant you want to replace.
PNG inputs are limited to 256 MiB each, padded canvases to 16,384 pixels per
dimension, and decoded mip chains to 256 MiB. GPU texture dimensions must also
fit the active device's limits.

Packs can also replace ordinary files read by the game's file loader. Put these
at the path relative to `data/`, directly inside the same pack folder; for
example, `data/edit.cfg` is replaced by `datapacks/My texture pack/edit.cfg`.
These file paths follow the loader's case-insensitive matching, and replacement
file sizes are used when loading. Only existing indexed game files are replaced;
the separate movie and sound readers and extraction metadata are not overlaid.

The data root is the first of these that applies:

1. `--data DIR`
2. `--run-dir DIR` plus `/data`
3. `DC2_DATA`
4. the per-user data directory: `%LOCALAPPDATA%\chronicletwo\data` on Windows, `$XDG_DATA_HOME/chronicletwo/data` or `~/.local/share/chronicletwo/data` elsewhere

The save root is the first of these that applies. It is created when first resolved.

1. `--save DIR`
2. `--run-dir DIR` plus `/saves`
3. `DC2_SAVE`
4. the per-user save directory: `%LOCALAPPDATA%\chronicletwo\saves` on Windows, `$XDG_DATA_HOME/chronicletwo/saves` or `~/.local/share/chronicletwo/saves` elsewhere

A data root is missing when it is not a directory, lacks either the data or converted-assets manifest, or has no current parent `data.json` marker. A windowed run opens Kazarov's Rust setup window before creating the game window. The editable path accepts a disc image or a disc folder; **Choose folder** opens the operating system's folder picker. **Okay** starts extraction on a worker thread. The progress bar tracks completed raw files and texture conversions, reserving 100% for successful publication. The setup window then closes automatically and normal game startup continues. Existing current data skips setup on subsequent launches. Extraction errors remain visible for correction and retry; closing setup before extraction exits with status 3. During extraction the window stays open until the worker finishes. Headless runs still print the `dc2data extract` command and exit with status 3.

The setup uses an eframe desktop window and an rfd native folder dialog on Windows, Linux and macOS. Linux folder selection requires an XDG desktop portal and its desktop backend. Extraction uses the same staged publication and manifests as `dc2data`; the output must be outside the selected source folder. A typed ISO path is supported without mounting the image.

`run.sh` with no configuration boots the PS2 build in PCSX2 on Linux, and runs `macos-arm64-release` on macOS. `run.bat` with no configuration runs `windows-x64-release`. A PC configuration name extracts the data first, as described above, and then runs the port.

### Saves

Continue and Save Adventure open the file list directly. There is no memory-card
selection or formatting step. The save screen lists every existing save and one
last unused file entry for a new save; the load screen lists only existing saves. Up/Down moves
one row and the shoulder buttons move two, as in the retail list. Cancel returns
to the screen that opened the menu. Replacing a save retains the retail yes/no
confirmation, with No selected initially. Unusable saves also require this
confirmation before replacement.

Each save is one file under `<save root>/saves/`, named
`BESCES-51190dkcl<N>` (File N+1). The list has no 13-file limit. New Save uses the
first unused number, rechecks it when writing, and never replaces an occupied
name. Files with unsupported versions, incomplete writes or wrong sizes remain
visible with their status. Unreadable entries are skipped; occupied disk names
on both legacy cards and in the flat folder still reserve their numbers. Listing
caches the header, story progress
and play time by file size and modification time, and successful game writes
invalidate the affected cache entry immediately. The unused-file number is
computed on each catalog scan, including the scan before publication; drawing
the row does not query the disk. Loading always rereads the
complete image and checks the retail digits before changing game state. Files
are never removed automatically; unrelated names and temporary files are not rows.

On discovery, old `mc0/BESCES-51190dkcl<N>/BESCES-51190dkcl<N>` payloads are
copied byte for byte into new flat files in `saves/`, using exclusive creation.
The equivalent files from `mc1` get a `.card2` suffix and an `(import 2)` label,
keeping different saves at equal slot numbers distinct. Existing flat files
are never overwritten during import. If any flat save has identical complete
bytes, no new copy is needed; a different legacy save at an occupied number is
imported under the first unused number. If a possible matching flat file cannot
be compared because its metadata or contents are unavailable, copying that
legacy entry is deferred until a later scan; existing copies are kept.

After copying or finding identical bytes, the whole original card entry,
including icons and payload, is moved atomically into `imported/mc0/<name>` or
`imported/mc1/<name>`. An occupied archive name gets a numbered suffix; nothing
is overwritten or deleted. Archived entries are never scanned for import.
If copying fails, the original entry stays loadable if readable. If the archive
move fails, its original row stays listed alongside the flat copy; this identical
duplicate is temporary. While that copy still has identical bytes, a later
readable scan finds it and retries the move without creating another copy.
No import markers are read or written; any existing `.save-imports/` directory is left untouched.

Replacing a still-listed legacy row writes a new flat save with exclusive
creation and then attempts the same archive move. If the move fails, the new
save is kept and the original row stays listed. Ordinary flat saves retain
atomic replacement. While archiving keeps failing, replacing or deleting the
last matching flat copy can cause the unarchived legacy save to be published
again, including when the legacy payload becomes readable again after failed
reads. Newer saved progress is preserved; the old save can reappear as another
row. Once an identical copy is readable, later scans do not publish more copies.
Card payloads and archived originals are never modified.
When moving or backing up a save root, include `saves/`, both card directories
and `imported/`.

The payload is the existing port save image and its retail header and checksums;
no PC metadata is added. As before, it uses the host layout of `CSaveData`,
including its photo records, so this does not add PS2-console save compatibility.
Older `dc2Ver2` images of the supported port layout are accepted and converted
with the retail invention-card routine; retail does not check this version's
digits. Unconverted Ver2 headers do not grant costume/bonus unlocks or debug
codes and do not participate in newest-save selection. Photo album and separate
bonus-data storage keep their existing paths.

Save rows, the unused-file row, new-save/overwrite/load prompts, operation failure
notices and Finny Frenzy confirmations use the disc's retail localized messages.
The flat-folder notices "No saves found." and "Could not read the save folder.
Return and try again.", the second-card suffix "(import 2)", and the detailed
statuses "Cannot read save", "Unusable save (size)", "Unsupported save version",
"Incomplete save", "Corrupt save" and the fallback "Unusable save" have no
corresponding retail flat-file diagnostics and remain in English. Retail's
no-data notice names a memory card and slot, so it is not used for an empty PC
save folder.

Saving uses Kazarov's `FilesWrite`: an exclusive temporary file beside the target,
a complete write, flush and close, then a write-through rename on Windows or a
rename and directory sync on POSIX. Failed writes report an error and leave the
menu available for retry. A process interrupted before publication leaves the
previous save and may leave a `<filename>.<hex>.tmp` file; these temporary files
can be removed while the game is closed. A load reads and validates the complete
image before changing the live game state. The retail checksum format is retained;
it is not a cryptographic integrity check.

### darkchronicle

```
darkchronicle [options]
```

| Option | Meaning |
|---|---|
| `--data DIR` | the extracted game data; `--data=DIR` also works. Resolved as in "Game data and first run" |
| `--save DIR` | saves, `config.json` and the pipeline cache; `--save=DIR` also works. Resolved as in "Game data and first run" |
| `--window WxH` | window size in pixels, `x` or `X` between the sides. Default: `video.width` and `video.height` in `config.json`, then the monitor's. Headless: the offscreen image's size |
| `--headless` | on Linux and macOS, SDL's offscreen video driver with a Vulkan headless surface (`VK_EXT_headless_surface`); on Windows, SDL's `windows` driver with a hidden window. Without a headless surface it behaves as `--offscreen` |
| `--offscreen` | `--headless` without a Vulkan surface: frames are rendered to an image only |
| `--frames N` | exit with status 0 after frame N of the main loop. N is a positive integer |
| `--screenshot PATH` | with `--frames`: write the last frame to PATH as a PNG on exit. A failed write exits with status 1 |
| `--screenshot-display N` | with `--screenshot`: also write N interpolated display frames of that frame, as `<stem>-display-<k>.png` for k = 0 to N-1 |
| `--screenshot-fps` | with `--screenshot`: draw the FPS counter into the image, from a presented frame at window size. With `--offscreen`, nothing is presented: the image is read back from the display image instead |
| `--input SCRIPT` | drive the pads from an input script at start-up. A bad script exits with status 2 |
| `--display-per-tick N` | also render N interpolated display frames per clock tick, discarded. N is a positive integer |
| `--show-fps` | draw the FPS counter on presented frames, headless too |
| `--log-fps` | print the FPS counter's text on stderr once a second |

There is no `--help`. An unknown argument, an option without its value (other than `--data` and `--save`), or a bad value prints the usage on stderr and exits with status 2. `--data` and `--save` without a directory print `--data needs a directory` (or `--save needs a directory`) and exit with status 2, without the usage.

Environment, with the `DC2` prefix that `GameSetIdentity` sets:

- `DC2_DATA`, `DC2_SAVE`: the data and save roots, as above.
- `DC2_AUDIO=off`: no audio device. `DC2_AUDIO_WAV` outranks it.
- `DC2_AUDIO_WAV=PATH`: write the mix to a WAV file in place of the device.
- `DC2_AUDIO_TRACE`: any value other than empty or `0` traces the audio calls on stderr.
- `DC2_VULKAN_VALIDATION`: has no effect. `main` ORs its presence into `gfx::RendererConfig::validation`, which is already on in a Debug build, and a Release build never requests the layer.

Debug builds request the validation layer (`gfx::RendererConfig::validation`, on unless `NDEBUG` is defined). Release builds never request it. Without the layer installed, the renderer prints `gfx: validation requested but VK_LAYER_KHRONOS_validation is not installed` and goes on.

Exit statuses (`port/src/exitcodes.hpp`, and `port/src/mglib.cpp` for the screenshot write):

- 0: a normal exit, with the window closed or `--frames` reached. Retail's `LoadFile` on a missing file also exits 0, after printing `File open error "<name>"`, as retail does.
- 1: an SDL, window or renderer fatal error, or a screenshot write failure.
- 2: a usage error: an unknown or malformed option, or a bad `--input` script.
- 3: no extracted data at the data root (see "Game data and first run").
- 4: a game assertion (retail's `__assert`).

A `PS2_UNIMPLEMENTED` stub aborts instead of exiting, so a debugger or a core dump stops at it: SIGABRT on Linux (status 134 from a shell) and `0xC0000409` on Windows. Other internal aborts stop the same way.

The test `Smoke.HeadlessFramesScreenshot` (`port/src/tests/CMakeLists.txt`) runs `darkchronicle --headless --offscreen --frames 3 --screenshot` on a data directory with a versioned empty `manifest.json` and parent `data.json`. It passes when the run exits 0, prints `dataread: indexed` and `mglib: frame 3 written to`, and writes a PNG. It is labelled `gpu`. It runs under a generated CMake script, because ctest counts a process killed by `abort()` as failed even when `PASS_REGULAR_EXPRESSION` matches its output; the script checks the exit status and the file.

### Test hooks

These options prepare a fresh debug state for testing. Command-line values take
priority over their `DC2_` environment variables. Malformed values, unknown
items, and targets absent from the loaded map or event tables exit with status 2.

- `--jump MODE[:ARG]` (`DC2_JUMP`) skips the boot logos, starts in English, and
  enables debug controls for that run. `town:<map>` (also `edit:<map>`) uses the
  Palm Brinks debug preset and entry event 100; the default map is 10.
  `dungeon:<n>[:<floor>]` uses the chapter-one preset and the retail floor list;
  dungeon numbers are 0-6 and the default floor is 1. A supplied floor selects
  it in that list. `event:<id>` resolves the first matching row of
  `event/view_pal.txt` and uses its town or dungeon, floor and event number.
  `title`, `opening`, and `menu` start the title scene, Monica's playable opening,
  and the retail developer menu respectively. An event jump uses the retail
  debug item set; it does not reproduce campaign progress from a save.
- `--fast-load` (`DC2_FAST_LOAD=1`) completes the loading progress bar in one
  step after loading finishes. This game's loading screen has no separate
  fixed holds or fades to shorten; scene and event timing stays unchanged.
- `--give ITEM,...` (`DC2_GIVE`) gives missing items and weapons by their numeric
  IDs through `CUserDataManager::GetItem` each time a town or dungeon starts.
  Items already held are skipped. See `ITEM_ID` in `ps2/include/gamedata.hpp`.

For example, `darkchronicle --jump dungeon:0:1 --fast-load --headless --offscreen
--input tools/input/jump-dungeon-floor1.input --frames 2300 --screenshot floor.png`
reaches the first Underground Channel floor with movement and the HUD. See
[Debug mode](DEBUG.md#jump-replays) for other rendered checkpoints and controls.

To replay a milestone save without changing its source, use:

```sh
python scripts/port/run_from_save.py --exe path/to/darkchronicle --data path/to/data \
  --save-fixture path/to/fixture --input tools/input/pc-continue.input \
  --frames 5000 --screenshot loaded.png
```

The runner accepts a fixture with `saves/`, `mc0/` or `mc1/`, copies it to a temporary
save root, starts at ordinary boot, and removes only that temporary copy after
the process ends. The screenshot remains at the requested path. Ambient
`DC2_JUMP`, `DC2_GIVE` and `DC2_FAST_LOAD` are removed from the child environment.
Fixtures and extracted game data stay outside the repository.

## Startup

`main` (`port/src/main.cpp`, `Run`) does these steps in order:

1. `GameSetIdentity` (`port/src/identity.cpp`) sets the `DC2` environment prefix, the game's directory names and the window title. `PathsConsumeArgs` takes `--data` and `--save` out of the arguments.
2. `ParseOptions` reads the other options. A usage error exits with status 2. `--input` loads its script here, and a bad script exits with status 2.
3. `ConfigLoad` reads `config.json` from the save root (see "config.json").
4. `FirstRunRequireData` checks the data root and opens setup when extraction is needed, or exits with status 3 in headless mode (see "Game data and first run").
5. The window opens, or the offscreen surface with `--headless`. Input initialises, and the input script is installed.
6. The renderer starts (`gfx::RendererInit`) with a logical size of 512x480 at a 4:3 display aspect. It builds every pipeline, uses `<save root>/pipeline_cache.bin` as its pipeline cache, and prints `compiling shaders n/total` as it goes.
7. `AudioInit(options.headless)` selects device-driven or tick-driven mixer ownership (see "Audio"). `AudioShutdown` is registered with `atexit`.
8. The clock starts at `game.tick_rate`; headless runs use an unbounded clock. A pump hook runs once per clock pump, after the tick callback has run for each elapsed tick, and polls the window, the input and the input script. The config change hook is installed.
9. The main thread takes priority 10, and `InitCDFile` (`port/src/dataread.cpp`) indexes the data root, printing `dataread: indexed N files under <dir>`. The PAL disc's `DATA.DAT` holds 8751 files.
10. The `--frames` limit and screenshot, if any, are set, and `MainLoop()` (`port/src/mainloop.cpp`) runs the retail sequence (see "MainLoop").

Before `main`, the game's static constructors run. The three VU0 helpers they need, `mgUnitMatrix`, `mgZeroMatrix` and `mgZeroVectorW` (`port/src/mg_math.cpp`), are real C++. On the PS2 the constructors run after the IOP set-up inside `mwInit`; on the host `mwInit` is empty (`port/src/runtime.cpp`). An SIF RPC client that no game code has bound yet gets an answer from `sceSifCheckStatRpc` and `sceSifCallRpc` instead of an abort, because the constructors reach the RPC layer before the game binds its clients (`tools/kazarov/src/cpp/sce/sifrpc.cpp`).

### Memory

`mgCMemory` is replaced whole (`port/src/mg_memory.cpp`). Its pointers are host pointers, and the `mgMEMORY_BLOCK` header is two quadwords on the host. Blocks are 64-byte aligned through `uintptr_t`. The arenas themselves are described in "Arenas" below.

Each arena's high-water mark is tracked, and `MainLoop` logs `mg_memory: <name> peak P of C quadwords (F free)` after every loop exit. C includes the headroom, so `main_buffer`'s is four times retail's 0x1A0000 quadwords. This line is how the headroom for 8-byte pointers is measured.

### MainLoop

`port/src/mainloop.cpp` retains the retail boot and mode-dispatch order. Native changes include pointer-width alignment; mapped arenas and native-sized sub-game storage; retained static helpers through link-name bridges; writable file paths; and arena high-water reporting. `InitCDFile` runs from `main` after main-thread priority is set.

Launch hooks prepare an explicit scene jump and give requested items on arrival. Jumps skip the ordinary boot logo and select English. Configured debug mode or a jump unlocks debug controls; the one-controller modifier, developer-menu chord and capture/resume handling are native additions. Mode changes cut interpolation, and the final frame border follows the live visible extent rather than fixed retail screen edges. Ordinary launches preserve the retail scene route and default debug gate.

## config.json

The configuration is `<save root>/config.json`, with the sections `game`, `video`, `audio` and `input`. They fill Kazarov's `HostSettings` (`tools/kazarov/include/platform/settings.hpp`) and the port's `Config` (`port/src/platform/config.hpp`). Comments (`//` and `/* */`) are accepted. Enum and choice values are case-insensitive strings.

- Missing: the file is written with the defaults.
- Unreadable (it exists but cannot be read, or is not a regular file): the defaults are used, `config: could not read <path>; using defaults and leaving it untouched` goes to stderr, and the file is not written in that session.
- Malformed JSON, or a root that is not an object: the defaults are used, `config.json: not valid JSON; using the defaults` (or `expected an object`) goes to stderr, and the next settings change that alters a value preserves the original bytes as `config.json.bad` before writing a fresh valid configuration. Existing backups are kept; later repairs use `.bad.1`, `.bad.2`, and so on. If the backup cannot be written, the original stays untouched and the settings change reports a save failure.
- Empty, or only whitespace: the defaults are used, silently. The next settings change uses the same backup and replacement behavior as malformed JSON.
- Invalid value, unknown key, or a section that is not an object: that key keeps its default, and `config.json: ignoring <name> = <value>` goes to stderr.

Writes are atomic: the file is written as `config.json.tmp` and renamed over `config.json`. It is written with 4-space indentation.

| Key | Type | Default | Values | Meaning |
|---|---|---|---|---|
| `game.tick_rate` | number | 50 | 25 to 240 | logic ticks per second |
| `game.debug_mode` | bool | false | | the boot debug unlock, and the pad-1 chord; see [DEBUG.md](DEBUG.md) |
| `video.present_mode` | string | fifo | fifo, mailbox, immediate | Vulkan present mode |
| `video.interpolation` | bool | true | | interpolate display frames between ticks |
| `video.max_fps` | number | 0 | 0 or more | display frame cap; 0 is unlimited |
| `video.width` | int | 0 | 0 or more | window width; 0 is the monitor's |
| `video.height` | int | 0 | 0 or more | window height; 0 is the monitor's |
| `video.fullscreen` | bool | false | | fullscreen |
| `video.aspect` | string | auto | auto, 4:3 | `auto` fills the window; `4:3` letterboxes |
| `video.ui_scale` | number | 1 | 0.25 to 4 | 2D UI scale |
| `video.show_fps` | bool | true | | FPS counter (windowed runs; `--show-fps` forces it headless) |
| `video.fps_detail` | string | all | fps, ticks, all | FPS counter text |
| `audio.master_volume` | number | 1 | 0 to 1 | final mixer gain, independent of the game's fades and core volumes; applies live |
| `audio.sound` | string | stereo | stereo, surround | output layout; read and saved, not yet applied (the output is stereo) |
| `audio.soundtrack` | string | ps2 | ps2, custom | `custom` plays recordings from `soundtrack/` beside the save root, as named by its `soundtrack.json` |
| `input.mouse_sensitivity` | number | 0.1 | above 0 | mouse look speed |
| `input.stick_sensitivity` | number | 1.33 | above 0 | stick look speed |
| `input.stick_invert_x` | bool | false | | invert the stick's X axis |
| `input.stick_invert_y` | bool | false | | invert the stick's Y axis |
| `input.gyro` | string | held | off, always, first_person, held | gyro aiming mode |
| `input.gyro_sensitivity` | number | 0.5 | above 0 | gyro aiming speed |
| `input.gyro_invert_x` | bool | false | | invert gyro's X axis |
| `input.gyro_invert_y` | bool | false | | invert gyro's Y axis |
| `input.mouse_invert_y` | bool | false | | invert the mouse's Y axis |
| `input.mouse_capture` | bool | true | | capture the mouse |
| `input.mouse_zoom` | bool | false | | mouse wheel zoom |
| `input.mouse_fixed_look` | bool | true | | gentle mouse look in fixed-camera town rooms |
| `input.touchpad` | bool | true | | a DualSense touchpad as the menus' mouse |
| `input.touchpad_sensitivity` | number | 1.0 | above 0 | touchpad speed |
| `input.lightbar` | bool | true | | lets the game colour the lightbar; read and saved, nothing sets a colour yet |
| `input.rumble_strength` | number | 1.0 | 0 to 1 | scales the rumble motors |
| `input.glyphs` | string | new | original, new | button symbols: `new` from `glyphs/`, `original` from the game |
| `input.glyph_device` | string | auto | auto, ps3, ps4, ps5, ps5color, xbox, switch, steamdeck, steamcontroller, keyboard | whose button symbols are drawn |
| `input.mouse_release` | string or array of strings | empty | key names | keys that release the captured mouse |
| `input.bindings` | object: action to string or array of strings | empty | key names | rebinds actions; action names are lowercased |

Opening PC SETTINGS does not write `config.json`. `ConfigChange` stores changed
settings and merges only those edits into the current file, preserving unknown
keys and unrelated values edited externally. Binding action names are merged
case-insensitively, so editing or restoring `cross` also replaces or removes a
hand-written `Cross` override without leaving a duplicate. It calls `DisplayChanged` and a
change hook. `SettingsChange` changes the shared host fields while retaining interpolation, aspect and UI scale. Through the hook, `main` applies the tick rate, present mode, input bindings and controls, master volume, and presentation settings. Aspect and UI scale are applied between frame recordings.

### PC SETTINGS

Open **Options**, then press **SELECT** (Backspace with the default keyboard bindings), or click **PC SETTINGS** above the list. The original Options page still edits the retail save's options. Its confirm, cancel, reset, and L1/R1 page scrolling are unchanged; returning from PC SETTINGS keeps its cursor and choices.

The PC page uses the game's font and Options artwork. L1/R1 changes tabs, Up/Down selects a row, Left/Right changes a value, and confirm advances a choice or opens binding capture. Cancel returns to Options; Japanese retains its reversed confirm/cancel layout. The mouse can click tabs and value arrows, scroll rows, restore a binding, and return to Options. Hit targets follow aspect ratio, UI scale and window DPI.

| Page | Settings |
|---|---|
| Display | Windowed/fullscreen, resolution, FIFO/mailbox/immediate, frame cap, interpolation, auto/4:3 aspect, UI scale, FPS counter |
| Audio | Master volume and PS2/custom soundtrack |
| Controls | Mouse sensitivity, Y inversion and capture; stick sensitivity and X/Y inversion; button symbols and glyph style |
| Bindings | Keyboard and mouse bindings for pad buttons, movement, look, FPS and debug menu |

Edits apply immediately and save to `config.json`. These settings do not require restarting the game. Soundtrack selection takes effect the next time a song starts, including one whose data is already loaded. Custom recordings use the original `.sq` filename in `soundtrack/soundtrack.json`; an absent or invalid recording falls back to the PS2 sequence. Current music is not restarted by moving the setting.

Resolution changes the windowed size; fullscreen uses the desktop. A command-line `--window` takes precedence. A refused window change is read back and reported on screen. Hand-edited resolutions and numeric values are shown as stored and stay unchanged until that row is edited. The PC UI offers a bounded set of scale presets; the configuration file still accepts the full documented range.

Confirm on a binding shows **Press a key...**. Press a key or mouse button; Escape cancels and cannot be bound. The opening press is ignored, and the new input must be released before navigation resumes. Square or **Restore binding** removes that action's override and restores its defaults. Controller buttons retain their retail assignments. Glyph style changes the PC page's device-specific button prompts; keyboard prompts use current bindings. Other retail screens keep their original button artwork.

A failed write leaves the change working in the current session and shows a warning. Check the save folder and change a setting to retry. A configuration file that could not be read remains protected against replacement.

`tools/input/pc-settings.input` replays all four tabs, a key rebind, Escape cancellation, and return to retail Options from `--jump town:10 --fast-load`. Its comments give capture frames. `tools/input/pc-settings-mouse.input` exercises clicking and mouse-button capture at `--window 1280x960`. Use fresh save roots and `--screenshot-display 2` for both.

`tools/input/pc-settings-display.input` checks fullscreen, return to windowed, and resizing in a real window. Start with a fresh config containing a nonzero window size, omit `--window`, and stop at frame 940. The optional `PcSettingsReplay` CTests run the headless pad and mouse flows and assert the saved configuration when `DC2_DATA` is available.

### Keyboard menu controls

With the default bindings, Tab sends Triangle, Enter sends Start, E sends Square,
and Space or Mouse1 sends Cross. Escape sends Triangle outside the game's menu
navigation mode and Circle while that mode is enabled. The game's
`CGamePad::MenuModeOn/Off` entry points select that host mode as well as the
retail stick threshold. In English, Cross confirms and Circle cancels; Japanese
reverses those two logical buttons.

Triangle opens the field or dungeon main menu. Inside a menu its meaning belongs
to that screen: the main menu accepts it as OK, while some submenus treat it as
Cancel. Enter retains the retail pause/resume action. WASD (or rebound left-stick
keys) and a controller's left stick navigate menus through the same retail stick
threshold, including Item and Character pages. In the field, stick movement does
not change active-item slots. Arrow keys send the D-pad and can select those slots.

### Mouse menus

Menu pointer input is shared by the inventory, other game menus and PC SETTINGS.
The Controls page includes **Mouse wheel zoom** (off by default); menu scrolling
never queues camera zoom. Save/load pointer selection uses the complete flat list,
with one unused file row for a new save only when saving.

Move the mouse to show the pointer and hover an option. Left click presses Cross,
right click presses Circle, and the wheel moves through a list. A controller or
keyboard movement hides the pointer; a stationary pointer does not undo that
selection. Clicks held while opening or closing a menu do not confirm the next
screen.

The pointer uses the game's gold hand artwork and follows mouse motion at the
display rate. The hand is a display overlay and stays out of canonical screenshots
and game captures. The menu hand shares cursor ownership with the operating-system cursor.
`input.mouse_capture` configures capture, and `input.mouse_release` selects the
keys that release it.

Mouse selection covers the town and dungeon root menus, title menu, dungeon
floor map and Save Adventure action, the flat save/load file lists,
and the field Use Item popup. Yes/No boxes and dialogue choices use the message
system's drawn choice positions and feed its normal directional input before
confirming. The pointer follows the renderer's UI mapping, including widescreen
anchoring and display scaling.

The root and file lists pass their selection through the retail cursor helper,
so scrolling, help text and background loading follow the same path as a D-pad
move. The floor map similarly uses its normal next-room transition. The shared
pointer implementation is `port/src/menu_mouse.cpp`; menu adapters, cursor
transitions, floor selection and message choices live in separate
`menu_mouse_*.cpp` files.

Deterministic mouse replays are `tools/input/town-mouse-menu.input` and
`title-mouse-menu.input` at `--window 1280x960`, and
`dungeon-mouse-floor.input` and `dungeon-mouse-save.input` at
`--window 1280x720`. Their comments give jump arguments and capture points.
`MenuMouse.*` and `MenuMouseInput.*` cover hit testing, display scaling,
controller handoff, scrolling and confirmation timing.

`town-mouse-menu-wide.input` checks opening and cancelling at 16:9.
`dungeon-mouse-play.input` enters a floor with the mouse and opens its root menu.
`dungeon-mouse-item-popup.input` follows the normal dungeon replay to the locked
gate and selects the Gate Key with the mouse. `title-mouse-load.input` exercises
Continue, a file-row click and its confirmation using a copied flat-save fixture.
`title-mouse-newgame.input` clicks New Game and reaches costume selection.
File-list clicks wait through the retail cursor-settling delay before confirming.

Shops support hovering and clicking the goods list and bag grid. The wheel moves
through goods or bag rows; in a buy/sell quantity prompt it changes the quantity
within the game's limits. The quantity arrows, number panel, and localized Quit
button accept clicks, and right click cancels. Item popups, stat grids, the ITEM
page and PC SETTINGS use the shared pointer adapters described below. Some
secondary destination screens still retain only their existing controls.
Visible hit regions confirm on click; retail Options buttons select their row
and choice before confirming, and background clicks do not confirm.
Informational popups without selectable regions accept a click on the current
choice. Fractional wheel input accumulates across ticks. The displayed gold hand
replaces only its own retail cursor, and releasing capture restores the native
pointer immediately. Ordinary dialogue choices share the message adapter;
the rendered confirmation replays and drawn-message unit tests cover that input
path, but campaign dialogue choices still need a dedicated replay.

### Mouse follow camera

Mouse motion directly turns the active walking camera around the character. It
does not deflect the right stick or inherit its dead zone and easing. Vertical
motion changes follow-camera height within the active retail limits, keeping the
view aimed at the character. `input.mouse_sensitivity` is degrees per mouse
count; `input.mouse_invert_y` reverses vertical motion. Mouse1 and Mouse2 retain
their Cross and Circle bindings. Mouse3 retains R3 unless wheel zoom is enabled.

`CPadControl::Update` latches one independent mouse sample per logical pad update.
The `CCameraControl::MoveCamera` port override consumes that sample once, only in
town walking mode or dungeon follow/follow-low mode with the active main camera,
unlocked input and no scene event or subgame. Dungeon carrying, guarding, aiming,
falling and lock-on keep follow-camera mouse control, just as they keep right-stick
control; lock-on target framing still runs first. The character's menu-eligibility
flag does not gate the follow camera. Paused player or field control and
pending/running event scripts retain camera ownership. Town water movement uses
the walking camera; ladders keep their authored camera for both inputs.
Boss and arena views, menus and Georama retain their existing controls. Fixed
town rooms use the separate fixed-camera look option below; photo view uses
the direct aiming controls described below. A camera-reset request owns
its frame; a later mouse yaw cancels an unfinished reset.

Direct motion turns both current and pending camera poses. A fresh bounded
polygon collection covers the orbit and follow corridor; conservative continuous
geometry checks reject an invalid starting corridor and clip an obstructed turn.
Retail wall and ground correction runs on both resulting eyes. A full polygon
collector or exhausted validation budget drops unproved motion rather than
queuing it. The conservative corridor may refuse motion that retail's endpoint
checks would permit. Explicit MouseX/MouseY stick bindings retain ownership of
their axes and suppress the independent mouse look on those axes.

`tools/input/town-mouse-camera.input`, with `--jump town:10 --fast-load`, exercises
yaw, vertical motion and a menu interruption. `tools/input/dungeon-mouse-camera.input`,
with `--jump dungeon:0:1 --fast-load`, enters the first floor and exercises the
same follow controls.
`tools/input/dungeon-mouse-carry.input`, with `--jump dungeon:4:1 --fast-load`,
lifts a rock in Mt. Gundor using R1 and Cross, then turns the mouse camera while
carrying it (capture at frame 2374).

In towns and dungeons, R2 first-person view also accepts direct mouse yaw and pitch. Max's photo view in towns and dungeons uses the same mouse aiming and retail pitch limits. Photo aiming has the retail constant turn scale at every zoom level; the right stick retains photo zoom. The
eye stays at the retail character position, pitch stays within the retail
`-1.0` to `0.65` radian limits, and controller look retains its existing behavior.
The port camera step applies a sample only after the retail eye pose is placed;
entry, exit, menus, events, photo mode and other input owners cannot queue mouse
motion into it. The town caller preserves its retail movement and ladder helpers,
then applies mouse look only to the established eye-view owner.
`tools/input/dungeon-mouse-eye.input` and `tools/input/town-mouse-eye.input` enter
R2 view and exercise mouse look.

### First-person walking

Keyboard movement in normal first-person view (R by default) is always enabled:
W/S move forward/back and A/D strafe relative to the view, including remapped
movement keys and normalized diagonals. Movement uses the normal character
collision and speed rules. Arrow keys turn the eye view; controller sticks retain
retail first-person look. Leaving the view restores the follow camera relative to
the player's current position. Dungeon trap circles, touch events and GeoStones
end eye view so the normal field-event path can handle them.
Photo aiming, fishing, Ridepod, menus and scripted control keep their own controls.

### Item menu mouse

The town and dungeon main menu's Item page accepts the mouse. Move over a grid
cell, an active-item slot, an equipped weapon or the character model to move the
retail selection there. Mouse1 opens the selected item's command list; move over
a command and click to confirm it. Mouse2 backs out like Circle. The command
window stays attached to the item, using the game's own placement and disabled
commands.

Quantity prompts accept the wheel or clicks on their arrows; click the number
to continue. Yes/No choices and build-up choices can be selected and confirmed
with the mouse. Weapon and fishing-rod stat rows and Ridepod equipment cells accept
pointer selection. Informational item popups retain their retail confirm/cancel
flow.

Press Mouse1 on a bag item or an active item, move at least four logical units,
then release over a cell or active slot to move or swap it. The held icon rides
the mouse. A short click opens commands on release. Swapped items return to the
original slot through the retail return animation. Dropping outside a target or
pressing Mouse2 returns the held item; it does not discard it. Equipment, use,
stack limits and refusal checks remain the game's own. Wheel notches over the
grid scroll rows, stopping at the bag's ends.

The pointer starts at the retail selection when the mouse takes over. Controller
or keyboard button input returns control to the retail cursor. Mouse counts are
mapped through the window size, UI scale and visible widescreen extent; camera
sensitivity and inversion do not affect the pointer. Buttons held when entering
the page must be released before clicking, and a held button cannot become a
gameplay press when leaving it. Losing window focus cancels the mouse gesture
without dropping an item. Other inventory submenus retain their existing controls.

`tools/input/item-menu-mouse.input` replays grid hover and commands at 1280x720
with `--jump town:10 --fast-load`. Capture frame 700 with
`--screenshot-display 1` to inspect the opened command list.
The same replay clicks Status by frame 800 and backs out with Mouse2.
`item-menu-mouse-drag.input` covers held-item rendering (660), grid swaps (800),
active-slot placement (1100), active-slot moves (1300), and return after a drop
outside the menu (1550). `item-menu-mouse-dungeon.input` reaches the dungeon's
Item page and opens Bread's commands by frame 2850. These two scripts also use
1280x720; scale `mouse:dx,dy` counts with the window dimensions for other sizes.

### Fixed camera mouse look

`input.mouse_fixed_look` defaults to `true` and appears as **Fixed camera mouse look**
in PC SETTINGS > Controls. In town rooms whose map supplies a fixed point/path
camera, mouse motion adds a gentle view rotation, limited to 15 degrees horizontally
and 10 degrees vertically. The view eases back exponentially when the mouse rests;
motion and decay advance on every displayed frame, including with interpolation disabled.
Motion across several logic ticks is retained without applying a sample twice.
The camera stays at its retail position, and character movement uses the unchanged
retail camera. Events, dialogue, menus, pause, ladders, Georama, debug cameras and
user-controllable cameras keep their own view. Turning the option off drops the offset.

An untouched mouse takes the original rendering path. The offset changes only display
renders; scene culling conservatively includes the permitted view rotation, while
gameplay, canonical captures and depth queries retain retail's
view. `tools/input/town-mouse-fixed.input`, with `--jump town:31 --fast-load`, reaches
Morton's Sundries directly. Use `--display-per-tick 4 --screenshot-display 2` and inspect
the `-display-*.png` captures at frame 609 for motion and 900 for return. The companion
canonical PNG remains the retail view even during mouse motion.

### Mouse wheel zoom

Set `input.mouse_zoom` to `true` in `config.json` to enable wheel zoom in town
walking and dungeon follow views. The default is `false`, as in Dark Cloud 1.
Wheel up moves closer; wheel down moves farther, eight world units per notch,
with a requested range of 30-600 units. The normal camera easing makes the
transition smooth. The distance stays selected while walking, and collision
shortens it where walls, floors or ceilings intervene, returning toward the
requested distance when the path clears.
Close zoom scales eye height with distance so the view keeps its normal slope;
mouse pitch uses the same scale and floor/ceiling clearance still takes priority.

`input.bindings.zoom_reset` defaults to `Mouse3` (middle click). It restores the
active camera's retail follow control immediately. Retail easing then returns
to its normal distance range, as far as geometry permits. The Bindings page
includes **Zoom reset**. The existing L2/cancel camera reset and turning the
option off also release zoom immediately. When enabled, the reset binding owns its
keyboard/mouse source ahead of conflicting actions; physical controller buttons
retain their retail actions, including R3's dungeon unit switch.

Zoom only starts after a wheel request. Pad-only play keeps the retail camera
path even when the option is enabled. Menus, events, lock-on, first-person,
fixed cameras, photo mode and Georama retain ownership and do not queue wheel
or reset input. A map or camera-parameter change clears the selected zoom.

Each zoom update collects the generated follow destination and ground query,
runs the retail floor/wall correction, then validates the entire eased corridor
with four-unit clearance. Eye and target may ease at different rates; both are
covered. Uncertain geometry, a full collection or a blocked path falls back to
retail camera movement for that frame, keeping the target following the player.
The caller's retail collision polygons and automatic obstacle avoidance remain
active while zooming. No retail parameter set is retained by zoom. This conservative check may shorten motion sooner than
the retail endpoint checks.

`tools/input/town-mouse-zoom.input` and `tools/input/dungeon-mouse-zoom.input`
exercise both limits, walking, reset and menu interruptions with the respective
`--jump town:10 --fast-load` and `--jump dungeon:0:1 --fast-load` hooks. Their
comments list capture frames; `--screenshot-display` also captures eased
presentation frames. Enable the option in each replay's save-root config.
`tools/input/dungeon-mouse-zoom-wall.input` adds a sideways wall approach,
distance clamping, an inward reversal and reset in the same corridor.

## Decision 1: long64 is kept

The PS2's `long` is 64-bit, and on Windows (LLP64) it is not. `scripts/port/long64.py` rewrites the build-tree copies of `ps2/src` and the `ps2/include` mirror, on every host, so the port keeps the PS2's width:

- `long` becomes `long long`, `L` and `UL` integer suffixes become `LL` and `ULL`, and `%l` integer conversions become `%ll`.
- It tokenizes, so comments, string and character literals (other than printf conversions), `long double`, `long long`, identifiers containing `long`, and the MIPS `%lo(` relocation operator are untouched. Line numbers are preserved.
- Over the real sources it changes 87 tokens in 21 files: 80 keywords, 6 hex `UL` suffixes, and 1 format (`password.cpp`'s `"err %lu\n"`). It changes no line count and no string otherwise.

Proof is by test. `scripts/port/test_long64.py` has 91 cases. The `Long64` GoogleTest suite (`port/src/tests/long64_test.cpp`) runs retail `mgSetPkTEX0`, where both forms write full 64-bit TEX1, TEX0 and TEXA words, and retail `password.cpp`, where `ConvertBinToTxt` and `ConvertTxtToBin` round-trip 64-bit groups up to `0xFFFFFFFFFFFFFFFF`, and `EncodePassword` and `DecodePassword` round-trip, and a one-character change to a password is rejected or decodes to different bytes. Both run on Linux and Windows.

The rewrite covers `u_long`, `mgSetPkTEX0` and `password.cpp`. No per-function `u64` overrides are needed.

## Decision 2: threads

PS2 kernel threads run as cooperative fibers on one OS thread, so the retail thread loops run unchanged and host state stays on the main thread. A switch happens only in `StartThread`, `RotateThreadReadyQueue`, a blocking `WaitSema`, `SignalSema` preemption, and thread exit. See [Threads and timing](#threads-and-timing).

## Arenas

The blocks come from `ArenaBlock` in Kazarov's `tools/kazarov/include/platform/arena.hpp`, the same code Dark Cloud 1 uses. Each block is zeroed, 64-byte aligned and followed by a guard page, and holds `kArenaHeadroom` (4) times the quadwords retail asked for. A debug build checks that a block lies above 4 GiB, so a mapping that drifted low cannot hide a pointer the game truncates (see "Pointers and 32-bit integers"). `port/src/tests/arena_test.cpp` covers roots, children, the guard page and placement growth.

Retail buffers that lie inside no mapped block become blocks. `MainLoop` maps `main_buffer` (`MainBuffer`), `InfoBuff` (`InfoStack`) and `SystemSeBuff` (`SystemSeStack`) explicitly through `ArenaRoot` (`port/src/arena_root.cpp`). `mgCMemory::stSetBuffer` and `SetHeapMem` treat any other buffer that lies outside every block the same way: retail statics, function-local arrays and member arrays (`editdata.cpp`, `gamedata.cpp`, `inventmn.cpp`, `character.cpp`, `mg_visual.cpp`, `menuaqua.cpp`, `scenesnd.cpp`, `event_func.cpp` and others) are roots. A root is keyed by the retail buffer's address, takes a copy of the retail bytes (`gamedata.cpp` memsets its buffer before handing it over), and gets four times the quadwords. Each mapping is logged once, as `arena: <name> <bytes> bytes at <address>`, followed by ` (above 4 GiB)` or ` (below 4 GiB)` according to the address.

A buffer inside a block is a child view, and it stays exactly where retail carves it. Dark Chronicle carves sub-arenas from a parent's top (`stGetTop`, `stGetRest`), often through local `mgCMemory` objects whose allocations outlive them, and re-carves overlapping regions by design (`menuchr`, `menusys`, `inventmn`, `dng_main`, `editloop`). Per-object blocks, as in Dark Cloud 1, would break that. An audit of every `stSetBuffer` and `SetHeapMem` site found more than 20 that depend on it. Headroom reaches a child through its parent, since most children take the parent's rest.

`stAlloc` and `Alloc` past an arena's end abort, naming `mgCMemory::name` or, when it has none, the arena's address, where retail printed and returned NULL. `stAllocTest` keeps retail's probe.

Retail places objects in runs with hand-written quadword counts. The placement operators in `port/src/mg_memory.cpp` grow the run to the host object's size while it is still its arena's last, as Dark Cloud 1 does. `arena_placement_test.cpp` lists the 51 literal-count sites whose host object outgrows its run, such as `CCharacter2` (2496 bytes in 0x68 quadwords), and the 8 cast-not-placed runs that nothing can grow: the script stacks `RS_STACKDATA` and `RS_CALLDATA` (`actscript.cpp`, `effscript.cpp`, `event.cpp`, `runscript_opcodes.cpp`) and `mgSORT_PACKET` (`mg_drawprim.cpp`). Each of those overruns its run on the host until `ps2/src` sizes it with `sizeof`.

On Windows the executable is linked with `--dynamicbase` and `--high-entropy-va`, lld's MinGW defaults pinned in `port/cmake/arena.cmake`. The image base is 0x140000000, relocated by high-entropy ASLR, and the image is `LARGE_ADDRESS_AWARE`, so the image and the `VirtualAlloc` mappings lie above 4 GiB, and a truncated pointer faults at once. Linux stays `-pie -z separate-code`. Dark Cloud 1 links Windows with the same defaults.

## Threads and timing

PS2 kernel threads run as cooperative fibers on the one OS thread: ucontext on Linux, Win32 fibers on Windows. `CreateThread`, `StartThread`, `RotateThreadReadyQueue` and the semaphores are real.

Switches happen only in `StartThread`, `RotateThreadReadyQueue`, a blocking `WaitSema`, `SignalSema` preemption, and thread exit. A switch attempted inside `ClockPump` (its callback or hooks) aborts; death tests on both OSes cover this. An uncontended semaphore pair never yields. A `WaitSema` with nothing else ready aborts as a deadlock.

`WaitVSync` loops until `frames` ticks have passed since `start`. Each pass rotates the ready queue when a rotate priority is set (`mgSetRotateThread`), waits for the next tick, then pumps the clock. `sceGsSyncV` goes through `ClockSyncV`. `mgNowFrameRate` comes from the wall clock via `mgTimeFrameFields()`, as seconds times `ClockTickRate`, the same unit as retail's `T0/262`.

The reason for this design: the retail thread loops (`GamePadStep`, `NowLoadingLoop`, fishing's `StepDataLoading`, the movie threads) run unchanged, and host state stays on the main thread.

## Rendering

`port/src/mglib.cpp` and `port/src/mglib_time.cpp` replace retail's `mglib`. Their `PORT_OVERRIDE` definitions replace the retail bodies of the same names. The rest of retail's `ps2/src/mglib.cpp` is compiled from the stripped copy, `mgSetLight`, `mgSetFogParam` and `mgGetCameraPos` among them. `port/src/mglib_port.hpp` is the seam between the `mglib` replacement and the units that call it. Its groups:

- Frame: renderer state, the frame count, and `--frames` exit.
- Projection: the eye, clip and view-to-clip mapping.
- GS state: the context-1 registers (TEST, ZBUF, ALPHA, TEXA, CLAMP, TEX1), scissor and fog colour.
- Textures: the lookups from `mgCTexture` and TEX0 to gfx textures, and the bindings.
- Render targets: the main target, the render targets and the current target.
- Submission: 2D and mesh draws, and the VU program id.
- Readback: colour of a target and the depth queries.
- Visible extent: the logical rect of the current target, in screen units (`mgPortVisibleExtent`).
- Display lists: interpolation scopes and cuts (`mgPortInterpScope`, `mgPortCutInterpolation`, `mgPortCutCameraInterpolation`).

### Frame

`mgBeginFrame` opens a display-list recording (`gfx::BeginRecording`), not an immediate frame. It sets the main target, CLAMP repeat and the default frame buffer, and clears the colour to `mgBackColor` and the depth to far. The game's draws between `mgBeginFrame` and `mgEndFrame` are recorded into the tick's list. Draws keep going through `mgPortDraw2D`, `mgPortDrawMesh` and `mgPortDrawMeshImmediate`.

`mgEndFrame` queues the four `mgPickZBuff` 8x8 reads. A pick within 4 pixels of the screen edge gets `z` of -1, as retail does. It seals the list and renders it once, canonically. That render ends the gfx frame and fills `mgPickZBuff[].z` in GS units. `--screenshot`, `mgStoreImage`, `mgPortCanonicalReadColor`, `StoreImage`, `mgPickZBuff` and the depth queries (`mgPortQueueDepthRead`) all read that canonical render. Two exceptions: `--screenshot-fps` reads a presented frame (`PresentScreenshotFps`), and `ReadNow` falls back to the presented frame when the main target's canonical readback fails. It then waits for the next game frame (see "Ticks and display frames"). It sets `mgNowFrameRate` from `mgTimeFrameFields()`, with retail's upper clamp of `1 + mgFrameRate`. When the frame count reaches the `--frames` limit, it writes the screenshot and exits before the wait.

### Ticks and display frames

- One game frame is one pass of the game's loop, and one recorded list. It spans `mgFrameRate` clock ticks: 2 on the 50 Hz tick, so 25 game frames a second. `mgFrameRate` keeps its meaning.
- After the canonical render, `mgEndFrame` calls `PresentWaitFrame`. It waits the same tick count `WaitVSync` waited for; the rotating-thread and pump behaviour is unchanged. Meanwhile `present.cpp` renders display frames from the newest list and the one before it. Each display frame's alpha is the elapsed fraction of the game frame: the ticks since the frame began plus the fraction of the current tick, over `mgFrameRate`. An alpha from the clock tick alone would run 0 to 1 twice per game frame at `mgFrameRate` 2. Display frames are presented as fast as `video.present_mode` and `video.max_fps` allow (`max_fps` 0 is unlimited). A game frame whose wait presented nothing presents its canonical image afterwards (`PresentTickEnd`).
- Interpolated: the models of tagged mesh draws, and the camera (`tools/kazarov/src/cpp/gfx/README.md`, "Display lists"). A draw is tagged with `mgPortInterpScope(object, teleport_distance, blend_vertices, no_interpolation)`, keyed by the `mgCFrame` or, outside a frame, the visual's record. `kMgPortFrameTeleportDistance` is 200 units. Skinned prog0 draws blend their 32-bone model-space palette (`gfx::Prog0Constants::bones`) per bone: translation lerped, rotation slerped from the Gram-Schmidt rotation, scale and shear lerped in its frame. A bone that moved further than the draw's teleport distance keeps the newest pose. The rest of the per-draw block follows the interpolated model and camera: `model_world` is the interpolated model, `clip_or_view` and the object-space eye are re-based through the tick's and the interpolated object-to-eye transforms, and point lights shift with the object's origin. Dark Cloud 1's port, which shares the renderer, records no prog0 block, so it takes no such path.
- Depth-tested screen effects set `gfx::DrawState::screen_space` so the depth-of-field layers stay screen-aligned while sampling the display camera's refreshed grabs. World sprites retain camera reprojection.
- Dungeon pickup sprites (`CPullItem`, including coins, ABS and floating items) opt into keyed world-corner interpolation. `SetItem` starts a new emission generation; matched corners blend in world space under the display camera, including bobbing, glow size and opacity. Atlas animation stays newest. Reused slots, unmatched/incompatible draws, motion beyond 200 units, near-plane crossings and multi-camera lists keep newest own motion. Canonical and alpha-1 rendering remain exact.
- Enemy anger-counter marks (`CEnemyGekirin`) have independent screen-space keys, so their movement and break-away bounce interpolate even when HP changes or neighbouring marks disappear. `ResetGekirin` starts a new generation for refills and reused monsters. Game steps, rage counts and canonical rendering are unchanged.
- Not interpolated: ordinary HUD/text without depth; untagged 3D sprites' own motion; objects and cameras past their teleport thresholds; the first tick after `mgInit` and after `mgPortCutInterpolation()`, which `mainloop.cpp` calls on every loop change. Damage scores, lock-on markers, HP bars, anger-counter marks and target names have separate opt-in screen-space presentation paths.
- `video.interpolation = false` presents each canonical image once.
- Headless, the clock is unbounded: one canonical render and one present per game frame. `--display-per-tick N` also renders N display frames at k/N and discards them. Screenshots are byte-identical with it (`PresentIdentity.DisplayPerTickScreenshot`).
- Frame grabs: `mgPortRenderTarget(..., frame_target = true)` makes a gfx frame target, which a display render grabs again from its own image.
- The FPS counter: `video.show_fps` turns it on (F3 and the `fps_toggle` host action flip it; headless only with `--show-fps`). It is drawn through `OverlayRecord`, as a display render's overlay, in the overlay's own font (the Dark Cloud Compendium Community Font baked into `overlay_font.inc`), so no canonical image holds it. The game's message font is not used: its texture lives only in the current mode's texture block (`ReLoadFontTexture` per mode) and `FontTex[0]` dangles across mode changes, so a badge in it would come and go with the modes. Its text is set by `video.fps_detail`; with all fields it reads `FPS 143.9  TICK 50.0/50  DRAWS 412`. TICK counts clock ticks per second, so it reads the tick rate whatever `mgFrameRate` is. DRAWS is the newest list's mesh plus 2D draws. `--log-fps` prints the same text on stderr once a second.
- Interpolation diagnostic: set `KZ_INTERPOLATION_TINT=1` to tint draws on the main presentation image (default off). Green is a matched transformed mesh; cyan is an unmatched or pose-excluded mesh carried by the display camera; red is newest-only geometry; blue is flat 2D or a screen effect; yellow is a depth-tested sprite with reprojected corners. Unchanged matched meshes remain green. This classifies geometry, not all its inputs: texture contents, lighting, fog parameters and sprite motion can still be tick-exact. Alpha tests, coverage, depth and blending are retained, so translucent passes can mix tints. Reusable intermediate render targets keep their original colours; their final composites are tinted on the main image. Canonical renders and ordinary screenshots never receive the tint. Use `--screenshot-display 8` to inspect the diagnostic at eight interpolation phases. Optional `KZ_INTERPOLATION_TRACE=<file>` appends per-draw CSV sections at alpha zero, including matching/cut reasons, texture IDs, camera IDs, target IDs, whether a draw is tinted on the main image, and changed fog/material/projection/local inputs. It writes only while tint is enabled; remove both environment variables after diagnosis.
- Outlined models render into a shared transparent image. Canonical clears and copies retain the retail draw rectangle; presentation scratch clears and replacement vertices cover the full visible extent so the interpolated model/bone pose remains complete under the display camera, including fixed-camera mouse look. Each copy preserves its texture-to-screen offset. Fixed-look current and previous lists preserve presentation vertices and clear rectangles while leaving resource retirement ownership with their source lists. Transparent texels in a depth-writing presentation composite do not write depth. GPU regressions compare a rotating thin part at alpha 0.5 against an independently recorded horizontal pose and complete fixed-look outline pixels at alpha 1 and 0.5 against a direct full-extent reference render; translation, scratch-target reuse and transparent-depth regressions remain covered. `tools/input/area-dungeon-chest-turn.input` with `--jump dungeon:0:1 --fast-load --frames 2518 --screenshot chest.png --screenshot-display 8` exercises the unopened chest during a camera turn. For multi-part NPCs, use `--input tools/input/repro-town-npc-outline.input --jump town:10 --fast-load --frames 278 --window 1280x720 --screenshot woman.png --screenshot-display 8`; the woman's face must remain visible throughout the turn. `--input tools/input/repro-clown-outline.input --frames 27230 --window 1280x720 --screenshot clown.png --screenshot-display 8` checks the clown's face during the prologue camera move.
- `--screenshot-display N` writes N display frames of the screenshot's frame, at alpha k/N from the previous list to the last, as `<stem>-display-<k>.png`. `--screenshot-fps` writes the screenshot with the FPS counter drawn into it, at window size, from a presented frame. With `--offscreen`, nothing is presented, and the image is read back from the display image instead. The counter reaches no other written image.
- `video.max_fps=0` leaves presentation uncapped; a positive cap paces display starts without catching up in bursts. A due logic tick takes priority. FIFO follows the display's synchronization, while mailbox and immediate depend on device support. Interpolation off presents canonical frames at their game cadence; a high display cap does not increase the logic tick rate.

### Packets

No packet is built or sent, so there are no packet buffers. `mgInitVif1Packet` and `mgSetPacketBuffer` ignore their buffers. `mgVif1Packet` points at one empty sentinel, because `mgCDrawPrim` disables itself when it is null. `mgDrawDirect` passes every draw the same non-null scratch tag, which selects the immediate path and is never written, and returns the sizes the draws report (0 on PC). The data buffers (`mgSetDataBuffer`, `mgGetDataBuffer`) stay: the draw manager's sort lists and the visuals' per-draw records are allocated from them. `SendDMA` is empty. `mgSendVuProg` only records the program id, which `mgPortVuProg` returns. VU programs are never uploaded: the `linknames.cpp` symbols are placeholders.

### Sprites and window backings

- The GS evaluates a sprite's UV at integer pixel positions and a nearest filter takes `floor(u)`; the GPU samples at pixel centres of an upscaled window. For nearest-filtered UV sprites, `AssembleSprite` (`port/src/mg_drawprim.cpp`) therefore maps the quad onto exactly the texels the GS reads (`mgPortSpriteTexelSpan`) and adds `kMgPortNearestTexelBias` (1/64 texel) so a sample exactly on a texel boundary takes the texel after it, as the GS does. This keeps the font's one-texel-wider UV rects (`set2DSpriteEasyFont`) from bleeding the next glyph, and 1:1 background tiles from showing a black seam at 2.5x. Linear-filtered UV sprites subtract half a destination pixel times the UV slope from both corners, so their samples also correspond to the GS integer pixel locations rather than Vulkan pixel centres. This handles stretched and flipped sprites without identifying textures or changing atlas rectangles. TME/FST-off draws keep their UVs. `MgDrawPrim.*` checks the slopes; `MgDrawPrimRender.LinearAtlasCellsKeepTopOutlinesWithoutSamplingTheNextCell` checks RGBA and indexed atlas cells at 2.5x. The bilinear sampler's half-texel footprint is separate from this pixel-location correction.
- Deliberate deviation from retail: every `DrawVersatileWin` variant (`ps2/src/drawwin.cpp`) puts its translucent backing at +13/+16 from the window origin in `DrawVersatileWin_yesno`, `_1` and `_3`, and at +13/+12 in `_4`. The gaiji frame's opening lies one pixel up and left of the backing, which leaves an undarkened line along the opening's top and left edges on the PS2 too. `port/src/nd_meswin.cpp` overrides `FillRect`, whose only callers are those windows, to draw one pixel up and left. To restore retail's output, delete that file and `port/src/tests/nd_meswin_test.cpp`.
- The menu background tile grid (`DrawMenuTilePattern`, `port/src/menudraw.cpp`) starts at or left of x = -256 and runs to 256 past the right edge, with rows reaching 256 past the bottom, so 16:9 and 9:16 windows show no uncovered flank. The 4:3 letterbox clips the extra tiles, so the canonical image is unchanged; `port/src/tests/menudraw_tile_test.cpp` covers the column range.

### Initial GS state

`mgPortResetGs` sets the state `My_dma_start0` leaves the GS in (`docs/vu1/dma_start0.md`, 8.1): ALPHA `0x44`, TEXA `0x0000008000008080`, TEX1 `0x61`, fog colour 200 on each channel, and SCISSOR 0..639 by 0..223. It also sets TEST `0x5000B`, which that chain does not write (8.3). `mgSetPkFrameBuffer` then resets the scissor to the target's size. `mgInit`'s C-side caches keep retail's values (for example `mgTEXA_1` is `0x100400000`), because only CPU readers see them.

### Projection

`mgRENDER_INFO::SetRenderInfo` still fills the 2048-centred matrices, for CPU readers. `mgPortEyeToClip` maps view space to Vulkan clip, so a point lands on the same logical pixel that retail's screen matrix gives it. It uses `eye`, `aspect_y` and the target's logical mapping. The output is reverse-Z, with near at 1 and far at 0. `mgPortWorldToClip` and `mgPortMeshTransform` are built on it.

GS Z is `depth * 1.67e7`, or `depth * 65000` for 16-bit Z (`mgPortDepth` and `mgPortGsDepth`).

Menu tile patterns derive phase-preserving coverage from `mgPortVisibleExtent()` on both axes, including 32:9 and narrow portrait Fill windows. Integer sprite rounding is retained. Icon draws sample immutable RGBA atlas cells; effect descriptors select their baked colour variants independently, so restoring another icon cannot recolor an effect during display replay.

### Render targets

`mgSetPkFrameBuffer` on the draw buffer's FBP selects the main target. Any other FBP selects the frame grab at its TBP0 if one is registered, or else a gfx render target keyed by TBP0. A texture passed by pointer selects by its kind: a render-target texture selects itself; an RGBA8 texture selects the frame grab registered at its TBP0, otherwise a render target keyed by its TBP0, seeded from the texture; any other texture takes the FBP path by its TBP0. A texture's pointer is also recorded against its TBP0. The target is created on first use and recreated on a size or format change. Because it is keyed by TBP0, a texture never holds a destroyed handle.

`mgPortFindTexture(tex0)` resolves the draw buffer's TBP0 to the main target and the display buffer's to the previous frame. Other TBP0 values are looked up as render targets, then by the registry. The texture registry installs its lookups with `mgPortSetTextureLookup`.

### Images

`mgSetPkMoveImage` with a destination offset copies with `gfx::CopyTexture`, except when the source is the main target or the previous display frame: it then grabs that buffer into a frame target with `gfx::BlitTexture` (nearest). This lets the retail pause loop capture the completed scene once and retain its wide sides and presentation resolution while paused. With a destination rect it stretches with `gfx::BlitTexture` (linear).

`mgStoreImage` reads the source back and writes the texture's PSM layout linearly, sampling the source at the texture's size. Inside a frame it uses an on-demand copy cached after a canonical render; it cannot synchronously read the current recording. 16-bit formats keep one alpha bit.

`CFadeInOut::CaptureScreen` records a nearest blit of `gfx::kPreviousFrame` into a frame target registered at the crossfade texture's TBP0. Every request captures the last completed scene, including the wide window's sides, and later fade draws retain that capture. It bypasses the CPU readback cache and the texture registry's pointer-only upload checks, which cannot refresh a capture buffer changed in place. Fade timing, dissolve strength and wipe geometry remain the retail code's.

`mgStoreZBuffImage` fills the rect, rounded down to 8x8, with one depth value. That value is the answer to the previous call's query for the same rect, or 0 when there is none. It is an approximation.

### Shadows

`mgBeginDrawShadow` clears the main target's stencil (when a frame is open) and enters shadow mode. While in shadow, `mgPortShadowTarget()` returns the main target. `mgEndDrawShadow` composites a quad over the visible extent onto the main target: vertex alpha 48, blend `(0 - Cd) * As / 128 + Cd` with FIX `0x80` (128), alpha test off, and stencil test NotEqual 0, which zeroes the count. It then sets TEXA to TA0 0, TA1 128, AEM 1.

### Font and headless

#### Optional sharp text

`video.text_font` in the save folder's `config.json` is `"original"` by default. Set it to `"sharp"`
and put a trusted TrueType font at `<save>/lang/font.ttf` to try sharp ASCII dialogue and menu text.
`lang/font.ttf` beside the executable is the fallback location. Restart after changing the font file.
No font file is bundled by this feature. A missing or unusable font keeps the original text and reports
the fallback once on stderr.

This is an experimental painter for the existing text cells: glyph advances, line and page breaks,
message reveal timing and controller behavior are unchanged. It does not use the font's kerning or
advances to reposition text. Accented characters, Japanese, symbols, button icons, small-font mode,
stylized sprite digits and pictures of text retain their original rendering. A different font can
change the weight and appearance of letters even though their layout stays the same.

Glyphs are rasterized through Kazarov at the target's UI scale, rounded up to eight-pixel em buckets.
The prototype keeps immutable glyph images for the renderer's lifetime, so recorded frames never
sample overwritten atlas cells. Its 16 MiB pixel-cache budget and 2048-entry limit fall back to retail
for new glyph sizes when exhausted; restarting clears the cache. Very large sizes above a 512-pixel
em also retain the original glyph. Font files are opt-in local inputs, not validated downloads.

`FontPortGpu.SharpDrawingKeepsRetailLayoutAndLineBreaks` exercises the original layout functions and
the sharp painter with a font named by `DC2_TEST_FONT`. Without that fixture the raster/layout test
is skipped; mapping, config and native submission tests do not require a font file.

For a repeatable visual comparison, use `--jump dungeon:0:1 --fast-load --input tools/input/font-dialogue.input
--frames 1050 --screenshot caption.png --screenshot-display 1` with a fresh save folder for each setting.
The floor menu is visible at frame 400 of the same script. Add `--window 1920x1080` or `--window 3840x2160`
to compare presentation captures (`caption-display-0.png`) at those resolutions.

`mgInitFont` returns 0 and `mgCloseFont` does nothing. The port keeps no console, because retail never draws it: `font_draw_flag` is never set.

`--frames N` exits after frame N. `--screenshot PATH` writes that frame as a PNG first; a failed write exits with status 1. `--screenshot` without `--frames` is a usage error. `--input SCRIPT` loads the script at start-up. The pump applies it on each tick with `mgPortFrameCount()`, so pad input follows the game's frame count.

Draws are recorded into display lists (see "Ticks and display frames").

### Window aspect

- Logical space stays 512x480 (`mgScreenWidth`/`mgScreenHeight`); `mgScreenOffx`/`mgScreenOffy` are the 2048-centred offsets. Nothing in `port/src` outside `platform/` and `mglib.cpp` reads the window's pixel size. The check `grep -rnE "SDL_GetWindowSize|SDL_GetWindowSizeInPixels|\bWindowSize\(|WindowCurrentMode|DisplayShownMode|SDL_GetCurrentDisplayMode" port/src --include=*.cpp --include=*.hpp | grep -vE "^port/src/(platform/|mglib\.cpp)"` prints nothing.
- `video.aspect` `auto` is `gfx::AspectMode::Fill`. `mgPortEyeToClip` maps retail's projection through the target's logical mapping, so the frame's 480 rows fill the window's height at retail's vertical field of view. A wider window shows more at the sides; a narrower one keeps the width and shows more above and below. `4:3` is `gfx::AspectMode::Letterbox`: it clips every main-target draw and clear to the frame, so the bars stay black. `video.ui_scale` (0.25 to 4) scales depthless 2D about the centre and reaches `gfx::SetFrameLayout`.
- HUD anchoring: `gfx::UiAnchor::Side(x, y, true)` anchors a piece to a frame side, and its third argument moves the piece's scissor with it. The human dungeon status board (`port/src/dng_status.cpp`, `DrawStatusBord`) anchors HP/items top-left and both weapons top-right, including numbers, bars, charge icons and warnings. The mini map (`port/src/automap.cpp`, `CMiniMapSymbol::Draw`, `DrawSymbolOpen`..`DrawSymbolClose`, `DrawSymbol_Chara`) is anchored top-right and clips to its own rect. DC2 has no town clock HUD. Menus, message windows and help bars stay in the frame.
- The full-frame rule that fills the flanks samples with clamped wrap, so a repeating texture shows no seam line at the frame's edges.
- Copies of the frame (`mgSetPkMoveImage`: the heat haze in `sceneevent.cpp`, `map.cpp`'s screen, menu grabs) go to frame targets as 1:1 logical copies, so a grab is as wide as the window.
- Culls: `mgPortVisibleExtent()` (`gfx::VisibleLogicalRect` of the current target, in screen units, with centred half extents and GS coordinates) replaces retail's 256/240 half extents in `mgCFrame::GetDrawRect` (`mg_frame_asm.cpp`). It also replaces them in `mgRENDER_INFO::screen_box_min`/`max`, which retail's `SetRenderInfo` sets from the screen size. `mgSetRenderInfo` is overridden to widen them, and `mgBeginFrame` refreshes them every game frame, since the window can change shape between scenes. `mgCFrame::Draw`'s `mgClipBoxW` reads them. A mesh at logical x = -40 is drawn at 16:9 and culled at 4:3 (`MglibAspect.*`). The GS guard band (2048) is unchanged.
- A layout change (`video.aspect`, `video.ui_scale`) is applied from the pump outside a recording.
- `--window WxH` sets the window size (headless: the offscreen image's).
- Config keys: `video.interpolation` (`true`), `video.max_fps` (`0`), `video.present_mode` (`fifo`, `mailbox` or `immediate`), `video.aspect` (`auto` or `4:3`), `video.ui_scale` (`1`), `video.show_fps`, `video.fps_detail`.

## Audio

The sound driver runs on Kazarov's shared audio stack. `CSound` in `port/src/sound.cpp`, with `snd_mngr.cpp`, `ezmidi.cpp` and `ezbgm.cpp`, plays through `audio::DefaultMixer()` (`tools/kazarov/include/audio/mixer.hpp`). The port has no IOP, no SIF RPC and no SPU2 path. The mixer's 48-voice synth stands in for the SPU2.

`AudioInit(bool headless)` and `AudioShutdown()` (`port/src/audio_init.cpp`) own mixer advancement and output. Interactive runs use the playback device callback. Headless runs without WAV capture register a logic-clock pump hook that renders the full mixer using cumulative sample budgets, including fractional samples and tick-rate changes. Voice levels, synth state and stream completion therefore follow game ticks. `DC2_AUDIO=off` suppresses playback but retains headless audio state.

With `DC2_AUDIO_WAV`, the existing platform WAV capture owns tick-driven mixer rendering; the headless hook is not installed, so samples are not advanced twice. Shutdown removes the hook and stops the output. See [Headless replay timing](port/headless-replays.md).

### Banks and sequences

`sndLoadSound` (`port/src/snd_mngr.cpp`) passes each pack's `hd` and `bd` to `SoundLoadHdBd` and `SoundLoadHdBdAdd`, and each `sq` to `SoundLoadSeq`. They take pointers (`port/src/sound_port.hpp`).

The retail `CSound::LoadHdBd`, `LoadHdBd2`, `LoadHdBdAdd`, `LoadSeq` and `TransHdBd` take addresses in `int`. The port overrides them to refuse and print a line to stderr. The port does not round-trip 32-bit pointers.

Banks are parsed and decoded once, by `audio::Bank::Create`. A port holds up to 16 banks (`MIDI_PORT_BANK_MAX`). Bank 0 is bound with `Mixer::BindBank(port, bank)`. Added banks are bound with `BindBank(port, n, bank)`, and a channel selects one with the bank-select controller that the SE calls send. The port layout (linked ports, dependent ports and `ezmidi_param` attributes) is the table that retail `CSound::Init` loads, kept in `sound.cpp` as `kLayout`. `TransBdState` always reports the transfer complete.

### Sound effects

`SE_Play`, `SE_SetVol`, `SE_SetPan`, `SE_Stop` and `SE_SetPitch` queue the same short and HS messages that retail queued for `libmodmsin`. `CSound::Step` delivers them through `Mixer::ShortMessage` and `Mixer::HsMessage`. The HS pitch message (`FD 02`, 14-bit, centre `0x2000`) bends the effect voice over its split's bend range.

Retail `SE_Play` builds a pitch message and overwrites it before sending. The port sends no pitch message at all.

### Master volume and reverb

`SetMasterVol(core, volume)` clamps `volume` to 0 to `0x3FFF` and sets the core's gain through `Mixer::SetCoreVolume`. `SetReverb` and `set_spu` go through `Mixer::SetReverb`. Retail also resets the core's master volume to full there, and the port does the same. `SndInReverb` has nothing to switch, because stream channels do not enter the effect units.

`sndWaitSema` and `sndSignalSema` are empty. The game's threads are fibers on one OS thread, and nothing in those sections yields (see "Threads and timing").

### Streams

`ezBgm` drives 16 `audio::StreamChannel`s, attached to the mixer on first use. An open reads the SOUND.DAT entry extracted to `data/sound/<name>` (see [SOUND_DAT.md](SOUND_DAT.md)). Names with a device prefix, such as `cdrom0:\VOICE\...WV;1`, go through the data index and fail. Voice packs (`StreamOpenFromFPLFast`) fail too, because those files are not on the PAL disc. Opens are synchronous, so `StreamOpenState` is always 0.

| Command | Effect |
|---|---|
| `0x10` | quit: nothing |
| `0x30` | close the channel |
| `0x40` | preload: nothing |
| `0x50` | play |
| `0x60` | stop, keeping the position (used for pause) |
| `0x70` | seek to the start |
| `0x80` | volume, `(left << 16) \| right` |
| `0x8000` | init: nothing |
| `0x80B0` | state |
| `0x80C0` | mode |
| `0x80D0` | info: bit 0 is stereo |
| `0x80E0` | level |
| `0x8020`, `0x80F0`, `0x8A00` | opens, only through `EzBgmOpen` and `EzBgmOpenFromPack`, because their argument is an address |

The state word holds the mode in its low byte, `0x1000` while playing, and `0x8000` when the data runs out. The driver clears `0x8000` once its buffers drain. The port holds `0x8000` for one second of output and then reads 0. A failed open leaves the channel unopened, with state 0, as on retail.

A non-zero low nibble in the mode turns looping on. A looping stream restarts at the start of the data, as described in [SOUND_DAT.md](SOUND_DAT.md).

The level is the raw 16-bit sample pair at the play position, left in the low half and right in the high half. `_STREAM_SILENT_CHECK` (`ps2/src/event_func.cpp`) reads it and treats both halves within 10 of zero as silent.

When neither a device nor the headless tick mixer owns playback, `CSound::Step` advances stream state through `EzBgmStep`. With tick-driven headless mixing active, that fallback does not advance channels again.

### ezMidi

The retail `CSound::Stop`, `SetVol`, `SetStereoMode` and the stream methods other than the open calls stay as they are. `StreamOpenFast`, `StreamOpenFromFPLFast` (`port/src/sound.cpp`) and `StreamOpenState` (`port/src/ezbgm.cpp`) are replaced. `ezMidi` serves the scalar commands: `0x00` play, `0x20` stop, `0x30` rewind, `0xA0` attribute, `0xB0` volume, `0xC0` stereo (1) or mono (0), `0x8090` is playing and `0x80E0` volume. The commands that carry addresses have no host equivalent. `ezMidi` traces them and returns 0.

### Open

The title is reached headless. `DC2_AUDIO_WAV=title.wav darkchronicle --headless --input <script> --frames 2500` writes 60 s of 48 kHz stereo: silent through the language select, then the logo and title music (RMS about 750 at the title, peaks near 24,000). The capture is closed cleanly on a `--frames` exit: `main` registers `AudioShutdown` with `atexit`, so the output stops before the mixer's statics are destroyed. The real-data tests `SoundRealData.*` (`port/src/tests/sound_test.cpp`) load `snd2/SY_000.snd`, every `snd2/bgm` pack and a SOUND.DAT entry through the driver.

`sndCSeSeqData::LoadSMF` (`ps2/src/snd_seseq.cpp`) adds the SMF header size to a `uptr`.

## Movies

`port/src/movie.cpp` overrides `CMovie::Load` (the seven-argument overload; the other two forward to it), `Play`, `SwitchThread`, `Term`, `EndCheck` and `IsStarted`. Nothing else reaches the retail player, so its three threads, the VBlank and DMAC channel 2 handlers, the IPU and DMAC channel 3/4 register writes, `setImageTag`'s GIF chains and the IOP transfers have no caller and are dropped by `--gc-sections`, and so are the `libmpeg` stubs. One movie plays at a time, as the retail file-scope statics did.

`MoviePortPath` maps the game's name to `data/movie/<name>` lower-cased, with a device prefix, a leading separator and a `;1` version removed (`L5LOGO.PSS` -> `data/movie/l5logo.pss`). `movie/` is outside the DATA index, so it does not go through `DataReadFind`. A missing or non-MPEG-2 file logs `movie: <name> not found or not an MPEG-2 PSS (<path>)`, `IsStarted` still returns 1 so the callers' busy-waits end, and `EndCheck` returns 1 at once (the PAL disc has no `TUTO`/`TUTO2` manual movies).

The pipeline is in `port/src/video/`. `pss.*` demuxes packs into video (stream 0xE0) and PCM (private stream 1, substream 0xA0) chunks with their PTS. `mpeg2_decoder.*` wraps libavcodec's `mpegvideo` parser and `mpeg2video` decoder, single-threaded, YUV 4:2:0, pictures in display order with 90 kHz PTS (extrapolated by the frame duration where a picture has none), and rejects a stream whose sequence header has no MPEG-2 sequence extension. `yuv.*` converts BT.601 limited range to RGBA with nearest chroma per 2x2 block, as the IPU's colour space conversion did, alpha 0xFF (the renderer's opaque, GS 0x80). `pcm.*` reads the soundtrack. `player.*` ties them together.

There are no threads. The game calls `SwitchThread` once per game frame and `EndCheck` beside it; both advance the player to the movie time elapsed since `Play`, `(ClockTickCount() - tick at Play) * 90000 / ClockTickRate()`. The newest picture whose PTS is due is shown; pictures overtaken after a stall are decoded but not converted. On the default 50 Hz tick with `mgFrameRate` 2 a 25 fps movie shows one picture per game frame; headless runs on the unbounded clock are deterministic.

The picture is uploaded into the texture the game names in `Play` (`"moviework"`), found with `mgTexManager.GetTexture(name, -1)` and `mgPortFindTexture`, with `gfx::UpdateTexture` (recorded into the tick's display list when one is open). That is what the PS2 did: `setImageTag` uploaded into the same texture and the game draws it itself as a 2D quad (the copyright screen's `L5LOGO.PSS`, `RUSH.PSS`, the movie viewer, the event script's `_LOAD_MOVIE`, the manual), so its fades, stretch and letterbox stay the game's, tick-exact.

There is no deinterlacing; fields are woven, as the IPU output them. `L5LOGO.PSS` codes all 150 pictures with `progressive_frame = 0`, every other disc movie with 1. Measured on the luma of the first 1,500 pictures of each of the nine movies, the mean difference between adjacent lines (opposite fields) is at most 0.83 of that between lines two apart (the same field) on `L5LOGO.PSS` and at most 1.008 anywhere: there is no comb, so a blend would only blur.

The soundtrack is 16-bit PCM in private stream 1, substream 0xA0, behind a 4-byte sub-header: `SShd` (type 1, 48,000 Hz, 2 channels, 0x200 bytes per channel block, interleaved left block then right block) then `SSbd` and the body. `Load` reads the whole track before the first picture (`L5LOGO.PSS`: 1,154,048 bytes, 6.01 s), aligns it by the first PCM PTS against the first video PTS, and `Play` hands it to the shared mixer as an `audio::PcmTrack` with `Mixer::SetStream` on port 5 at full port volume (`kMoviePortAudioPort`: `GetCSndPortNo` never maps a game port there). `Term` stops and clears it. The track is read whole because the mixer's existing API plays complete tracks; a streaming channel would replace that. `init_sound` (which reset the PS2 sound driver), the memory pools and the width and height arguments are ignored: the host allocates and the picture size comes from the stream.

The game links only libavcodec and libavutil (`port/cmake/movies.cmake`); no libavformat, libswscale or libswresample symbol is referenced. On Windows `darkchronicle.exe` imports `avcodec-63.dll` and `avutil-61.dll` only; `swresample-7.dll` ships beside them because the FFmpeg build's `avcodec-63.dll` depends on it.

Tests:

- `video_mpeg2_test`: MPEG-1 and header-less streams are rejected; `L5LOGO.PSS`'s first picture is a 512x416 I-picture at PTS 4758, the black frame the logo fades in from; all 150 pictures decode in increasing PTS order.
- `video_yuv_test`: hand-computed pixels, limited range, chroma siting, strides.
- `movie_test`: PCM layout, the player against the clock, `CMovie` through the glue, and a 30-frame play of `L5LOGO.PSS` through the `"moviework"` texture to a PNG compared with the decoded picture.

The `L5LOGO.PSS` cases in `video_mpeg2_test` and in `MoviePcm`, `MoviePlayer` (`movie_test`) search upward from the test executable, six directory levels at most, for `data/movie/l5logo.pss`, and skip when it is not found. The `MovieGlue` cases first look for `movie/l5logo.pss` under the game data root (`PathsDataRoot()`: `--data`, then `DC2_DATA`, then the default `data` directory), then fall back to the same upward search and skip when neither finds it.

## Layout

The root `CMakeLists.txt` selects the platform: `PS2` builds `ps2/`, and `PC` enables testing and builds `port/`.

- `ps2/src` and `ps2/include` hold the game as the PS2 build compiles it. `ps2/CMakeLists.txt` and `ps2/cmake/` are that build. Port code does not live there, except the `#ifndef PORT` guards, the `#ifdef PORT` `uptr`/`sptr` selection in `ps2/include/types.h`, the `PORT_RECORD_ASSERT` hook in `ps2/include/common.h` (compiled out on the PS2, a `static_assert` on PC via `port/include/port.h`), and the edits listed in "Keeping the PS2 build matching".
- `port/src` holds code only the port compiles. `main.cpp` starts the game. `identity.cpp` sets the game's name and directories. `<unit>.cpp` replaces functions of `ps2/src/<unit>.cpp`. `*_asm.cpp` defines the functions `ps2/src` writes in MWCC assembly. `linknames.cpp` supplies link-time names (below). `tests/` holds the GoogleTest cases, one process per case.
- `port/include` holds `port.h`, included ahead of every unit the port compiles, and `stubs/`, the per-unit headers (below).
- `tools/kazarov` is the shared-code submodule. `tools/kazarov/port` holds the code both games share: `gfx`, `audio`, `platform`, `sce` (the SDK replacements) and `tests`. `cmake/KazarovPort.cmake` gives the port its targets:
  - `kz_port_host_library(ct_host)` builds `gfx`, `audio` and `platform`.
  - `kz_port_sce_sources(... LIBS libvu0 libpad libmc sifdev sifrpc eekernel libcdvd libgraph libdma libpkt eekernel_threads libdev libmpeg libsdr modmsin sifdma)` selects the SDK families.
  - `kz_port_tests(darkchronicle_tests)` adds the shared test cases.
- `tools/windows` holds the Windows scripts. `scripts/port/header_fixups.py` builds the header mirror (below). `scripts/build/verify.py` checks the PS2 build.

### The shared-code pin

The `tools/kazarov` gitlink records the shared renderer, platform, input and mixer dependency. Read its exact revision with `git ls-tree HEAD tools/kazarov`; the checkout must use that revision. Changes to the shared code land in the submodule first, on the shared code's main line. Both games that use it must build and test green on that commit before either one pins it. A game never edits a submodule checkout in place. To move the pin: land the change in `tools/kazarov`, check both games on that commit, then commit the new submodule pointer in this repository.

## How `port/src` takes precedence

A definition in `port/src` that replaces one of `ps2/src`'s is tagged `PORT_OVERRIDE`, which `tools/kazarov/include/kazarov/port.h` defines as nothing:

```cpp
PORT_OVERRIDE void mgInit(int screen_mode, int video_mode) {
```

`port/CMakeLists.txt` builds the two halves on every platform, with `PORT` and `PAL` defined:

1. `tools/kazarov/scripts/build/port_override.py list` reads the tags in `port/src` and writes the name each tagged definition links under to `port/build/pc/port_overrides.txt`.
2. `scripts/port/unit_copy.py`, run once per unit, writes a copy of each `ps2/src` unit under `<build dir>/ps2_src` (for example `port/build/windows-x64/ps2_src`) without the overridden definitions (`port_override`'s `strip_unit`), plus the preserved retail bridges described below, then with the unit fixups and long64 applied. Each copy opens with a `#line 1` marker naming its `ps2/src` source, so lines keep their numbers and diagnostics point into `ps2/src`.
3. `port_override.py check` stops the build if a tagged name is defined by no unit of `ps2/src`, since its replacement would be unused wherever the signatures differ.
4. The copies are compiled with `PORT` defined, and the units in `port/src` are linked with them.

`unit_copy.py` also preserves the routines listed in `RETAIL_BRIDGES` under new definition names in the generated unit. It reads each body from the unstripped retail source, changes only the definition name, and appends it before the unit fixups and long64 rewrites. Calls in the original unit keep the public name, so they reach the native `PORT_OVERRIDE`; that override can add native behavior and delegate to the preserved routine. Each appended body has its own `#line` marker naming the original retail source and definition line, keeping diagnostics and debugger locations valid.

Use this mechanism when a native seam needs to wrap retail behavior rather than replace it, as with the camera-cut seams around `ResetViewMode` and `ResetEyeView`. Add the unit, exact signature, original name and bridge name to `RETAIL_BRIDGES`, declare the bridge's asm link name in both `port/include/stubs/<unit>.hpp` and the native caller, and call it from the public override. The bridge body is generated from retail rather than transcribed into native source; `ps2/` stays unchanged. `NativeRetailBridges` runs `scripts/port/test_unit_copy.py` through CTest, alongside the other native unit-copy Python tests.

Each name then has one definition. A replacement without the tag leaves `ps2/src`'s definition in, and the link fails on the duplicate symbol. A replacement takes the signature `ps2/src` gives the function: parameter types as spelled; names and default arguments may differ. By convention a replacement goes in the file that mirrors its unit.

A `static` function cannot be replaced, so its non-static callers are replaced instead. A `static` function guarded `#ifndef PORT` in `ps2/src` is the one exception, whether it is written in assembly (`collision.cpp`'s `pre_trance_normal`) or in C (`editmap2.cpp`'s `PlaneNormalXZ`). The port defines a non-static function of the same name, declared to the unit by `port/include/stubs/<unit>.hpp`.

The 22 `#ifndef PORT` guards are 21 in the eight `.cpp` files that hold assembly (`collision.cpp`, `editcoll.cpp`, `editmap2.cpp`, `gameutil.cpp`, `mg_drawprim.cpp`, `mg_frame.cpp`, `mg_math.cpp` and `mg_visual.cpp`), and one in `ps2/include/sce/eekernel.h` around `ExitHandler`, which expands to `asm volatile("sync.l; ei")`. The port defines each guarded function untagged: in `port/src/*_asm.cpp`, `port/src/mg_math.cpp`, `port/src/editcoll.cpp` (`ClipBoxXZ`) or `port/src/editmap2.cpp` (`PlaneNormalXZ`).

## Per-unit adjustments

`port/include/stubs/<unit>.hpp`, when it exists, is included ahead of `ps2/src/<unit>.cpp`, after `port.h` and nothing else. It declares what the port defines in place of code `PORT` leaves out, and it renames or supplies what the unit takes from MWCC or from the PS2 link alone. Only the port's build sees `port/include`.

The 22 native unit headers are `collision`, `dataread`, `dng_main`, `dngmenu`, `editctrl`, `editmap2`, `event`, `event_func`, `gamepad`, `gameutil`, `inventmn`, `mainloop`, `menudraw`, `menumain`, `menuop`, `menusys`, `mg_frame`, `mg_math`, `mglib`, `nowload`, `photo`, `title`. Their link-name bridges and native caller declarations remain outside retail source.

## Header fixups

`scripts/port/header_fixups.py` mirrors `ps2/include` into `port/build/pc/ps2_include` before the units compile, with these textual fixups. The game's headers include each other with quotes, so the port compiles against the mirror.

- `dng_event.hpp`: `CRedMarkModel::Draw` is declared `int`, not `void`.
- `dng_hud.hpp`: `CLockOnModel::Draw` is declared `int`, not `void`.

MWCC accepts a `void Draw()` that hides the base's `int Draw()` and gives it a new vtable slot. clang rejects that, and no standard spelling keeps the PS2 vtables. The `int` declarations make the two draws overrides instead. This is an accepted difference. The port's definitions (`port/src/dng_event.cpp`, `port/src/dng_hud.cpp`) are real bodies that return 0; the `int` return type is the whole fixup.

- `nd_meswin.hpp`: `#ifndef MES_WINDOW_OUT_OF_LINE_INIT` becomes `#if 1`, so `ClsMes::Init` is inline in every unit. `dngmenu.cpp`'s out-of-line copy was a strong definition and collided with the COMDAT copies on COFF.
- `collision.hpp`: `memset` takes `static_cast<void *>`, because `mgVu0FBOX` is not trivially copyable and `-Wnontrivial-memcall` rejects it.
- `mapload.hpp`: `CFuncPoint` gets a memberwise copy assignment on its constructor's line. `InventData`'s `mgVu0FBOX` makes the union's implicit copy deleted under clang; MWCC generated it, and `CFuncPointMngr::GetLight` and `CMap::GetCharaLight` assign points with it. Retail's bodies then compile unchanged.
- `sce/eekernel.h`: `CreateThread`, `TerminateThread` and `GetThreadId` get the asm link names `Ps2CreateThread`, `Ps2TerminateThread` and `Ps2GetThreadId`, because kernel32 exports the unprefixed names.
- MWCC-only `#pragma cpp_extensions ...`, `#pragma push` and `#pragma pop` lines are blanked, keeping the line count. `port/src` builds with `-Wall` and without `-Wno-unknown-pragmas`, so they cannot stay.

Headers then go through the long64 rewrite (see "Decision 1: long64 is kept").

Each fixup's text must occur exactly once in its file, or the script stops before it writes anything.

### Unit fixups

`unit_copy.py` applies the unit fixups (`header_fixups.fixup_unit_text`) to each `ps2_src` copy after the override strip and before long64:

- `editeff.cpp` and `editmap.cpp`: the identical inline `CMapParts::CMapParts()` copies are blanked, so `map.cpp`'s out-of-line definition is the only one. COFF has no inline-versus-strong resolution.
- `dng_debug.cpp`: `CTreasureBox::Initialize()` becomes `inline`. `CTreasureBox`'s vtable becomes COMDAT with it.

- `inventmn.cpp`: the native copy removes `inline` from `CMenuInvent::CMenuInvent()` so callers in other units have one emitted constructor. Retail source retains its original spelling.

Each unit fixup's text must also occur exactly once; missing, duplicate and already-transformed constructor text is rejected by `NativeUnitFixups`.

## Names the PS2 build renames

The PS2 link binds some names through the object fixups and the linker script, not through the source. The port reproduces each one:

- `stubs/dng_main.hpp` renames `MainBuffer`, `BuffWorkData` and `EventCamera` to their `__2` retail names.
- `stubs/event_func.hpp` renames `VectMatMul` to `VectMatMul__2`.
- `stubs/dataread.hpp` and `stubs/mglib.hpp` rename `Exit__2` to `Exit`. Retail's `Exit__2` is a separate symbol; the port terminates through the SDK's `Exit`.
- `port/src/linknames.cpp` defines the VU microprogram placeholders `My_dma_start0`, `Vu_progmain`, `Vu_prog0`, `Vu_prog_sdw`, `Vu_prog_3dsp` and `Vu_prog_wtr`, and `_gp`. The retail microcode lives only in the retail ELF's `.vutext` and `.vudata`. The placeholders keep the addresses the game stores resolvable.
- `port/src/cameracontrol.cpp` defines `CameraCtrlParam::operator=`, which retail has only as assembly.
- `port/src/menudraw_primquad.cpp` forwards `PrimQuad<float>` and `PrimQuad<int>` to retail's `PrimQuad_f_` and `PrimQuad_i_`, since the template has no definition.

## Windows link

- `-Wl,--allow-multiple-definition` stays only as a guard. The eekernel.h fixup gives the PS2 kernel's three thread calls their own link names, so they no longer shadow KERNEL32's import thunk. The Windows link now reports no duplicate symbols.
- `-Xclang -mno-constructor-aliases`: a constructor alias points C1 into a COMDAT section that lld discards under `--allow-multiple-definition`.
- `-municode` and a `wmain` forwarder: the arguments arrive as UTF-16 and are converted to UTF-8.
- `port.h` supplies `index()` for mingw, whose `<strings.h>` has none; the PS2 libc's `index()` is `strchr()`.
- `u_long` is 64-bit on the host (`port.h` defines it as `u64`). The long64 rewrite makes the retail `unsigned long` 64-bit on Windows too (see "Decision 1: long64 is kept").

## The stub list

`PS2_UNIMPLEMENTED()` prints the function and source location and aborts. The generated [stub inventory](port/stubs.md) counts **2 game bodies** and **89 SDK bodies** at the current shared-code pin, including unreachable source. Disassembly of the Windows release executable has **one direct call or tail-call caller**, `sgLoopGyoRace(SubGameInfo*)`. The other game stub, `GetScrPad`, is unreachable and removed by section collection. Native rendering does not use scratchpad storage.

Chapter setup, `CMenuItemUse::UseItem`, pad capture/play/save/load, `sceCdSearchFile`, advisory `sceCdSeek`, `sceMcRename`, `scePadEnd` and `scePadPortClose` are implemented. Disc lookup uses extracted files rather than a disc device; seek accepts an advisory preload hint and does not perform disc I/O. The SDK source inventory still includes interrupt/DMAC handlers, unsupported SIF/IOP operations, device control and unused disc reads. These are distinct from the successful host substitutes.

Assembly replacements in `collision_asm.cpp`, `editcoll.cpp`, `editmap2.cpp`, `gameutil_asm.cpp`, `mg_drawprim_asm.cpp`, `mg_frame_asm.cpp`, `mg_math.cpp` and `mg_visual_asm.cpp` contain no abort-stub bodies. `SendDMA` is empty because native draws submit through Vulkan. `mgCVisualMDT::SetMaterialRef` returns 0 for replaced packet-builder callers, and `mgSendPacket` flips bookkeeping buffers. The retail movie player is replaced by the native video pipeline.

Regenerate source counts with `python scripts/port/stub_inventory.py`. Add `--binary <executable> --objdump <objdump>` to include linked caller names. A source count alone does not establish reachability.

## Hardware audit

Grep for hardware addresses and registers in the unit copies:

```sh
grep -nE "0x1[0-2][0-9A-F]{6}\b|0x7000[0-9A-F]{4}|0x20000000|0x0FFFFFFF|DmaCH[0-9]|D_STAT|D_CTRL|IPU_|T0_(COUNT|MODE)" port/build/pc/ps2_src/*.cpp
```

It gives 137 hits:

- 105 are constants or names that only look like hardware.
- 1 is a comment.
- 21 are packet-tag writes.
- 10 are real hardware accesses, none of them linked. `mg_visual.cpp`'s `SendDMA` body is under `#ifndef PORT`, and its replacement is empty. In `movie.cpp`, none of the retail player survives the link (see "Movies").

`GetScrPad` (`port/src/mg_visual.cpp`) has a `PS2_UNIMPLEMENTED` body, but it is not in the linked binary: nothing reachable calls it. The retail scratchpad paths of the five `CreateRenderInfoPacket` functions (`mgC3DSprite`, `mgCShadowMDT`, `mgCVisualMDT`, `mgCVisualPrim`, `CWater`) call it; nothing in `port/src` does.

`nm` of the executable shows no unresolved hardware symbol. The hardware-named definitions are Kazarov `sce` replacements or game code that is not `PS2_UNIMPLEMENTED`.

## Pointers and 32-bit integers

Pointers are 64-bit on PC, and the arenas lie above 4 GiB (see "Arenas"). An address the game keeps in a 32-bit integer is truncated. `docs/port/truncations.md` is the per-site table of every cast of a pointer to a narrower integer in `ps2/src`, `port/src` and their headers. `scripts/port/truncations.py` writes it.

### The types

`ps2/include/types.h` defines `uptr` and `sptr` as `__UINTPTR_TYPE__` and `__INTPTR_TYPE__` under `PORT`, and as `unsigned int` and `int` on the PS2. Every operation compiles to the same instructions on the PS2 except the signed-sensitive ones.

### The policy

`uptr` replaces every cast of a pointer to `int`, `u_int`, `s32`, `u32` or `long`, and every local, global, non-record field and return type that carries an address.

`sptr` is used only where the integer is compared with `<`, `>`, `<=` or `>=`, shifted right, divided or reduced modulo, converted to `float` or `double`, widened into a 64-bit `long` or `u_long`, or stored in a signed field and so used. It is used only where the original type was signed. An original unsigned type becomes `uptr` everywhere.

Parameter types never change, because they are part of mangled names. Declarations that are already pointers are not touched. Pointer arithmetic is not rewritten as integer arithmetic.

### Records

Structs read from a file in place keep their 32-bit offsets and never take `uptr`. The inventory is `docs/port/records.md`: 598 structs with a `STATIC_ASSERT`, of which 65 are records and 533 are runtime. 57 records keep the disc layout and carry `PORT_RECORD_ASSERT`; `DATA_HEADER` is PS2 only (the host index replaces DATA.HD4); the seven save-image structs that hold `USER_PICTURE_INFO::image` are host layout on PC, sized by sizeof in memcard.cpp. `scripts/port/records.py` checks the table, the asserts, the host sizes and that no asserted record has a pointer member (ctest `Records.Check`).

`funcdata::name` (`ps2/include/runscript.hpp`) is the one pointer-typed declaration changed, a documented exception to the uptr rule that a declaration already typed as a pointer never changes: retail declares it `char *`, but in the `.stb` record it is a 32-bit field the script compiler writes as 0 in every disc script and retail never resolves, so it is `u32`, which keeps `local` and `arg` at their disc offsets 8 and 12 on PC. The error messages in `runscript.cpp` print it through `(char *) (uptr)`.

`PORT_RECORD_ASSERT(expr)` in `port/include/port.h` is a `static_assert` on PC. `ps2/include/common.h` defines it empty for the PS2.

### Strides and hand-counted sizes

A hand-written stride is rewritten as indexing only where `verify.py` stays identical.

| Function | Unit | State |
|---|---|---|
| `mgCTextureManager::SearchHash` (`hash_table[bucket]`) | - | indexed, landed |
| `CEditGrid::GetFast` (`&data[x + y * num_x]`) | - | indexed, landed; correct on PC as it stands |
| `mgCTextureManager::Initialize` (blocks `<< 4`, `hash_table` `<< 2`) | `port/src/mg_texture.cpp` | native override uses typed pointer tables and block slots |
| `mgCTextureManager::SetTableBuffer` | `port/src/mg_texture.cpp` | stride fix; the port override keeps the indexing |
| `mgCTextureAnime::NewTexAnimeGroupData` (`(group << 2) + this + 0x64`) | `port/src/mg_tanime.cpp` | native override appends to `list[group]` while retaining the retail stride source |
| `CScene::ClearStack` (`(u8 *) this + 8 + i * 4`) | `port/src/scene.cpp` | native override walks `stack[i]` while retaining the retail stride source |
| `mgCDrawManager::BeginDraw`, `ClearTable`, `PreEndDraw` (pointer tables sized `n / 4 + 1` quadwords and cleared as `int`s) | `port/src/mg_drawprim.cpp` | stride fix: the overrides size the tables by `sizeof` and clear them as pointers |
| `mgRENDER_INFO::GetPlight` (`index * 0x30 + ... + 0x90`) | - | retail stride remains valid because `mgLIGHT_INFO` contains floats only |
| `CRepairManager::Generate` (`slot * sizeof(mgCMemory)`) | - | retail sizeof-based runtime stride remains valid |
| `CAutoMapGen::CreatTermParts` | - | correct on PC as it stands |
| `_SWE_SET_COLOR`, `_SWE_SET_TEXTURE`, `_SWE_START_EFFECT` (`(slot << 2) + chara + offsetof(sword_effect)`) | `event_func.cpp` | scene event bindings in `port/src/event.cpp` use the native pointer array; the byte-matched PS2 handlers remain intact |
| `CVillagerMngr::GetAppearVlgr` (`time * sizeof(void *) + schedule + offset + 8`) | `port/src/villagermngr.cpp` | stride fix |
| `mgCMemory::SetHeapMem`, `mgCMemory::StartStackMode` | `port/src/mg_memory.cpp` | stride fix; kept |

Hand-counted allocation sizes are rewritten with `sizeof` and are byte-identical: the script stacks in `SetActionScript`, `SetEffectScript` (stack), `SetEventScript` and `SetMonsterScript` (`(sizeof(RS_STACKDATA) * N + 15) / 16` and `(sizeof(RS_CALLDATA) * N + 15) / 16`), `mgCDrawManager::AddPacket` (`(sizeof(mgSORT_PACKET) + 15) / 16`), and `mgCVisualMDT::CopyMDTDataPointer` (`material_num * (int) sizeof(mgMaterial) / 16`).

### Override pairs

An address passed through an `int` parameter is fixed by replacing the callee and its callers on PC.

| Callee#param | Callers |
|---|---|
| `ezMidi(int, int)`, arg 2 | `CSound` |
| `ezBgm(int, int)`, arg 2 | `CSound` |
| `CSound::LoadHdBd`, `CSound::LoadHdBdAdd`, args 2 and 4 | `sndLoadSound` |
| `CSound::LoadHdBd2`, args 2 and 4 | `CSound::LoadHdBd` |
| `CSound::LoadSeq`, arg 2 | `sndLoadSound` |
| `align_size(u_int, u_int)` | `InitFileCache`, `LoadFileCacheBG` (both already replaced in `port/src/dataread.cpp`) |

### Other corrections

`SPI_STACK::operator=` copies `value.string`, the widest member, instead of `value.integer`. String arguments of every cfg script lost their upper half.

`CScriptInterpreter::GetArg` is replaced in `port/src/scriptinterpreter.cpp`. It accumulates arguments in native strings, preserves quoted empty strings and escape handling, and checks emptiness before inspecting a closing quote. A missing argument no longer indexes before its buffer or wraps through a 32-bit offset.

### What is left

- The generated [truncation table](port/truncations.md) records 14 counted narrowing sites in compiled `ps2/` code, in three units:
  - `menusys.cpp`, 1: the save record `CMenuSystemData::item_cursor`.
  - `mg_visual.cpp`, 1: packet and DMA tag words. The port builds and sends no packets (see "Packets").
  - `movie.cpp`, 12: DMA, IPU and IOP addresses. The sites are compiled but unreachable: `viBufRestartDMA`, `viBufGetTs` and the `AudioDec` functions (`audioDecCreate`, `audioDecPause`, `audioDecResume`, `audioDecSendToIOP`, `iopGetArea`) are called only through `CMovie::Load`, `Play` and the threads and callbacks they start, which the port replaces (see "Movies").
- 18 more are benign: low bits (`& K`), residues (`% K`) and differences of two addresses.
- 38 counted sites sit in replaced functions.
- 65 literal placement-new runs stay as they are; the placement operators in `mg_memory.cpp` grow them at run time.
- Native `SetEffectScript` reserves call storage with rounded-up native sizes and 64-byte alignment in `port/src/effscript.cpp`. `CreateEffSpt` and `AssignCharacter` reserve native character/copy storage and alignment before entering an arena gap. Disc records remain fixed-width.
- Open round trips in linked code: 0. All eight that were open are closed by the conversion, and so is `MenuCalcBufAlignment`'s, which crashed `LoadGameDataAnalyze`.

### The check

```sh
tools/kazarov/scripts/kazarov shell python3 scripts/port/truncations.py --build port/build/pc --check
tools/kazarov/scripts/kazarov shell python3 -m unittest scripts/port/test_truncations.py
```

`truncations.py` runs libclang over `compile_commands.json` and parses each `ps2/src` unit as compiled. Header fixups and long64 are applied in memory, so replaced functions are seen too.

`--check` fails on:

- a stale `docs/port/truncations.md`;
- an open round trip in linked code;
- a narrowing site in compiled code with no `NARROWING_OWNER` entry;
- a stale `PHASE_OF` entry.

The ctest case is `Truncations.Check` (Linux; it skips when `clang.cindex` is missing). `scripts/port/test_truncations.py` covers the classifier. `--worklist FILE` writes the per-site TSV used for the conversion. `--verbose` prints libclang diagnostics; all of them are in replaced bodies.

The checker sees casts and implicit conversions. It does not see an address copied through an int member of a union; `SPI_STACK` was found at run time.

The tests are `port/src/tests/uptr_test.cpp` (`Uptr.*`). They cover pointer width, an address above 4 GiB through `(u_char *) ((uptr) p + ofs)`, through `MenuCalcBufAlignment`, through a `uptr` field and through a `uptr` return.

## Keeping the PS2 build matching

Every retail source edit requires the complete PAL byte-identity check. Native-only code shaping belongs in the header/unit mirror, and host replacements belong in `port/src` through `PORT_OVERRIDE`. The current source changes relative to the native-port baseline cover these ten files:

| File | Individual exception and PS2 constraint |
|---|---|
| `ps2/src/actscript.cpp` | `_CHECK_PAUSE` reads/postincrements the mask before writing the result; `_GET_BTN` does the same for the button argument. Defined C++ sequencing retains the intended retail instruction order. |
| `ps2/src/event_func.cpp` | `_STREAM_OPEN` reads the name and base strings in a defined order before `CommandStreamOpenFromFPL`. Event-handle position/rotation, treasure position, random-circle position and minimap-door callbacks reserve four floats for full-vector writers. |
| `ps2/src/effscript.cpp` | `_DIST_VECTOR`, `_DIST_VECTOR2`, scene character position/rotation, entry-object position and event-handle position callbacks use four-lane scratch arrays. Script argument counts and disc vectors remain unchanged. |
| `ps2/src/map.cpp` | Overlay-water pointer stride uses `sizeof(CMapParts *)`, retaining four bytes on PS2 and using eight on native x64. |
| `ps2/src/menuop.cpp` | Minimap option-row pointer stride uses `sizeof(MENUFORMPARTS_TYPE *)`, retaining four bytes on PS2. |
| `ps2/src/mg_dataset.cpp` | `mgCopyFrame` allocates its pointer table with `sizeof(mgCFrame *)` and frame storage with `sizeof(mgCFrame)`. Retail keeps four-byte pointers and 0x110-byte frames. |
| `ps2/src/character.cpp` | Character-effect manager allocation uses `sizeof(CHARA_EFFECT_MANAGER) / 16 + 1`, retaining 32 retail quadwords. The local outline copy uses aligned `sceVu0FVECTOR` members matching `COutLineDraw` offsets and full extent. |
| `ps2/src/menusys.cpp` | Item-command target storage is aligned and sized for `CItemUseTarget`, retaining one retail `u_long` while accommodating the native target. |
| `ps2/src/nowload.cpp` | The memory-manager copy view uses `sizeof(mgCMemory)`, preserving the native stack state and original retail extent. |
| `ps2/include/scenesnd.hpp` | Motion-blur alias padding uses `offsetof(CFadeInOut, blur_alpha)` with `<cstddef>`, preserving the retail offset while following the native texture pointer's growth. |

`ps2/src/inventmn.cpp` retains the original `inline CMenuInvent::CMenuInvent()` spelling. Only the native build copy removes `inline` through the exactly-once unit fixup. Constructor restoration and every subsequent retail source edit require a fresh check of the integrated PS2 tree; native tests do not qualify that tree.

Existing base-build accommodations also remain: declaration order in `mg_tanime.hpp`; split initializations and switch scopes in menu/edit/title/message units; the named fishing union; enum casts in inventory and texture-animation arithmetic; `u_long` spelling in memory-card and TEX0 calls; target-width address types; and assembly guards. SDK prototypes under `ps2/include/sce` retain the game's transcriptions, with shared implementations adapting to the included prototypes. Disc records keep their 32-bit layout.

Retail's own mistakes stay in `ps2/src`, because the match reproduces them. The port gives them defined behaviour instead, through flags `ct_ps2` sets in `port/CMakeLists.txt`: `-ftrivial-auto-var-init=zero`, `-fno-strict-return`, and `-fno-strict-aliasing` with `-fwrapv`.

### Checking the PS2 build

After any edit to `ps2/`, run `./build.sh ps2-pal`, then `BUILD_DIR=build/pal python3 scripts/build/verify.py -c`. The check must pass. The 22 `#ifndef PORT` guards are part of the same tree and are checked the same way.

## Presentation matrix

`scripts/port/matrix.py` compares logical-frame PSNR across resolutions, plain and `--display-per-tick 4` identity, and letterbox geometry. Below-35 dB PSNR is advisory unless `--psnr-gate` is supplied; run failures, display-per-tick pixel differences and letterbox failures are hard failures. There are no HUD probe claims.

Each fresh run explicitly disables debug in its config and removes `DC2_JUMP`, `DC2_GIVE` and `DC2_FAST_LOAD` from the launch environment. It records the exact process exit status, duration, binary/input hashes, launch config hash, saved config hash, frame count, window, aspect, data path and display-per-tick mode in `result.json`. `--no-run` requires matching identities and retains a failed or timed-out status even when a PNG exists. Changing extracted data in place is outside this provenance check; use the same verified extraction for comparisons. `Matrix.Title` and `Matrix.Costume` carry `matrix;gpu` labels. `Matrix.Runner` checks the runner synthetically without game data or a device.
