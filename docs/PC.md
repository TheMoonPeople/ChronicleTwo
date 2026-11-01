# PC port

`PLATFORM=PC` builds the PAL game's code (`SCES_511.90`) as a native x64 program, compiled by clang as C++26, on SDL3 and Vulkan 1.4. ChronicleTwo ships only the PAL release, so the port builds from PAL source and data while native gameplay uses NTSC timing at 60 Hz.

The port runs the retail main loop on the shared renderer and mixer, reading extracted PAL disc files. Supported checkpoints include the boot movies, title, costume selection, opening event, Palm Brinks exploration and the first Underground Channel floor. Town and dungeon movement, inventory item use, chapter resources, menus, photos and save/continue have native implementations and bounded replay fixtures. These checkpoints do not establish a complete campaign or every sub-game; the fish race still aborts at its unimplemented loop.

The PC controls include keyboard menu navigation, mouse menus and item drag/drop, town, dungeon and Georama mouse camera control, optional wheel zoom, a PC settings page, JSON save files and Georama towns without a part limit. The message font draws the game's own letters as outlines at any resolution. Presentation can interpolate between logic frames independently of the display rate. Ordinary boots leave debug controls disabled; `game.debug_mode=true` or `--jump` enables them explicitly.

## Building and running

### Linux

```sh
./build.sh linux-x64
tools/kazarov/scripts/kazarov shell ctest --test-dir port/build/pc --output-on-failure -j4
```

`./build.sh linux-x64` builds in the Kazarov container, from the image in `tools/kazarov/image` (built locally the first time), with the Debug preset into `port/build/pc`. `linux-x64-release` builds Release into `port/build/pc-release`. `CLEAN=1` discards the build directory first; `JOBS=N` sets the parallel job count.

Without the container, `cmake --preset linux-x64`, `cmake --build --preset linux-x64` and `ctest --preset linux-x64` do the same work. The host needs what the image provides: clang 20 or newer with lld, CMake 3.25 or newer (the presets need it), Ninja, `glslangValidator`, SDL3 3.4, the Vulkan 1.4 headers and loader, Python 3, and Rust 1.99 (provided by the container and Windows toolchain setup).

The renderer's cases need a Vulkan device with the features `tools/kazarov/src/cpp/gfx/README.md` lists under "Device". The container's Mesa lavapipe provides them, so no GPU is needed there.

`./run.sh linux-x64` builds, then runs `port/build/pc/darkchronicle` on a Linux host. It extracts the PAL source (`rom/pal/Dark Chronicle (PAL).iso`, else the first `.iso` in `rom/pal/` by name, else `rom/pal/extracted/iso`) into the ignored `port/run/` root with `dc2data`, under `.kazarov/locks/port-data.lock`. The game holds the lock shared while it runs. The launcher checks source metadata and the current extraction marker, skipping conversion when they match; `dc2data check` performs the full content audit.

### Windows

GitHub Actions cross-compiles Windows releases and test executables on Ubuntu with the `windows` target in `tools/ci/Dockerfile`. Linux host tools build the C++26 and Rust code for `x86_64-pc-windows-gnullvm`; a separate Windows job runs the resulting CPU and Rust tests with an official Python installation. Cross builds use `port/build/windows-cross-x64-release`, keeping their CMake cache separate from native Windows builds.

The Windows and macOS workflows each compile, test and package one build per push or pull request. The Tests workflow covers Linux and the iOS simulator; it does not repeat the desktop release builds. Manual desktop runs can disable tests with the `tests` input.

For a local cross build, run `docker build --target windows -f tools/ci/Dockerfile -t chronicletwo-ci:windows .`, then `docker run --rm -v "${PWD}:/work" chronicletwo-ci:windows bash tools/ci/windows.sh build` from Bash. Use `tests` to compile the test executables as well. Run `python3 tools/ci/windows-package.py build` inside that container to validate the bundled DLL imports and symbol lookup and write the runtime and symbol ZIPs under `artifacts/`.

CI images pin their base-image digests and Ubuntu package snapshot. Rust comes from its official image, target libraries from rustup, and bridge generators from Cargo with locked dependencies. The Docker source bundle verifies upstream archive checksums, rejects conflicting pins, and keeps its download layer cached across unrelated CMake edits. CMake consumes only those verified sources, and Linux and Windows compilation use the Cargo dependencies fetched into the image without network access. BuildKit, compiler, Rust and ThinLTO caches are reused across runs. GPU tests share a CTest resource lock so renderer startup cannot exhaust hosted-runner resources while CPU tests remain parallel.

```bat
.\build.bat windows-x64
.\run.bat windows-x64
```

`build.bat` and `run.bat` start `tools/windows/kazarov.ps1` directly in one PowerShell process. That script builds into `port/build/<configuration>` and delegates PS2/Linux/macOS configurations to Kazarov. The first Windows run uses Docker Desktop's Linux engine to export the `windows-bundle` target in `tools/ci/Dockerfile` into `.kazarov/windows`. The bundle includes llvm-mingw 20260922, Ninja 1.13.2, CMake 4.4.5, Python 3.14, ccache 4.14.2, SDL3 3.4.18, glslang 16.6.0, the Vulkan 1.4.363.0 headers and redistributable loader, Rust 1.99.0 for the llvm-mingw UCRT target, cxxbridge-cmd 1.0.205, Corrosion 0.6.1, and the pinned CMake dependency sources. Docker cross-compiles FFmpeg 9.0.2 from Kazarov's pinned LGPL configuration instead of using expiring third-party autobuild assets. Every downloaded archive is verified against its SHA-256 before extraction. `windows-x64` is a Debug build; `windows-x64-release` (and `windows`) is Release.

Once installed, dependencies are reused without invoking Docker. Bundle invalidation tracks dependency names, URLs and checksums, the Docker recipe/context filter and FFmpeg's version, checksum, licence and configure flags; unrelated CMake target, option, source-list and host FFmpeg helper edits do not invalidate it. Missing required tools trigger repair. `REBUILD_DEPS=1` explicitly refreshes the bundle; a verified archive already recorded as installed is not unpacked again unless required files are missing. The semantic fingerprint replaces the previous whole-file fingerprint, requiring one refresh when upgrading an existing checkout.

A verified export records its input identity before extraction, so interrupted setup can resume from the local archive without another Docker build or download. Installation stamps are cleared before extraction and published only after success. Native Windows `tar.exe` is preferred to avoid MSYS path conversion when the launcher is invoked from Git Bash.

The Windows launcher prints elapsed stages for dependency checks, configuration and the build, and announces any lock wait. Compiler and Cargo output appears live, with the complete latest build output retained in `port/build/<configuration>/build.log`; failures preserve the native exit code. The first dependency export shows Docker's layer progress and reuses its build cache. `JOBS=N` sets the compile job count (the logical processor count by default). See [build measurements](port/buildperf.md) for the measured incremental costs. `pwsh -NoProfile -File tools/windows/test-build.ps1` checks live stdout/stderr, full logging and successful/failing exit codes without requiring a toolchain.

`run.bat` uses the same ignored `port/run/` extraction and version checks before launching, under the `port-data.lock` lock. The game holds the lock shared while it runs.

The launcher needs PowerShell 7. Docker Desktop with its Linux engine is needed for dependency acquisition or refresh; a current installed bundle works without Docker running. The exported bundle supplies the native compiler, build tools and Python; compilation runs directly on Windows. `REPAIR_NINJA=1` requests explicit dependency-log repair; normal runs preserve Ninja's database. Shared current-data checks allow launching against an archive another game already uses; only extraction requires exclusive access. Without a disc, an existing archive receives a full audit once per archive, data marker or extractor revision, cached by path, size and modification time. An explicit `dc2data check port/run/data` always performs the full audit.

The test build is separate. After a `build.bat` run has fetched the toolchain:

```powershell
./tools/windows/configure-tests.ps1 -Root .kazarov/windows -BuildDirectory port/build/windows-x64-tests
./tools/windows/build.ps1 -Root .kazarov/windows -BuildDirectory port/build/windows-x64-tests -Tests
ctest --test-dir port/build/windows-x64-tests --output-on-failure -j4
```

Windows builds include the SDL, FFmpeg, C++/Rust runtime DLLs and the pinned redistributable Vulkan loader beside the executables. Acquisition includes the loader by default. CMake restores the runtime files on every build, including direct `cmake --build` calls; `cmake --install` also installs them. Running the built game requires no separate application runtime installation. A compatible graphics driver is still required.

`tools/windows/package.ps1 -BuildDirectory port/build/windows-x64-tests -Destination chronicletwo-windows-x64.zip` packages CMake's explicit list of executables and runtime DLLs together with a gameplay-only `data.zip`. It audits each binary's imports and fails if a non-Windows dependency is missing. Packaging and installation exclude extracted disc assets, saves and disc images. First-run setup combines the shipped gameplay JSON with the user's disc data after launch.

### macOS

```sh
./build.sh macos-arm64
ctest --preset macos-arm64
```

Apple builds use Xcode and Homebrew on macOS; Apple's SDKs cannot execute in the Linux dependency container. Docker's `apple-deps` target supplies verified portable sources, FFmpeg source, iOS SDL/MoltenVK inputs and the native cxxbridge generator. `tools/ci/apple-deps.sh` installs the native tools and builds the Apple libraries with Xcode.

`macos-arm64` is a Debug build with the Homebrew preset in `CMakePresets.json`, into `port/build/macos-arm64`. `macos-arm64-release` is the Release build. The preset expects Homebrew's LLVM under `/opt/homebrew/opt/llvm`, and its `CMAKE_PREFIX_PATH` also names `sdl3`, `vulkan-headers`, `vulkan-loader` and `glslang`. CI additionally installs `molten-vk`; GoogleTest and JSON come from the Docker source bundle. To run the game, SDL needs the loader by its full path, and the loader needs the MoltenVK driver:

```sh
export SDL_VULKAN_LIBRARY="$(brew --prefix vulkan-loader)/lib/libvulkan.1.dylib"
export VK_DRIVER_FILES="$(brew --prefix)/etc/vulkan/icd.d/MoltenVK_icd.json"
```

### iOS

The iOS arm64 build requires macOS and Xcode with the iOS 27 SDK or newer. The
[build workflow](../.github/workflows/ios.yml) builds SDL3 and FFmpeg, supplies the iOS MoltenVK library,
and packages an unsigned IPA with its scripts, glyphs and gameplay seed. It targets iOS 27 and later;
install the IPA through a sideloading tool that signs it for your device.

For a local build, export Docker's `apple-deps` target into `.kazarov`, then run
`bash tools/ci/apple-deps.sh ios-arm64` on macOS. Outside Actions it records the environment in
`.kazarov/apple.env` and the cxxbridge path in `.kazarov/apple.path`. Configure `ios-arm64-release` with `SDL3_DIR`, `Vulkan_INCLUDE_DIR`
and `Vulkan_LIBRARY` pointing to the iOS libraries. Build with
`cmake --build port/build/ios-arm64-release --target darkchronicle`.

The launcher extracts the player's ISO on the device, using at most two workers. Touch controls appear
when no physical controller, keyboard or mouse is active. The launcher and in-game APP SETTINGS share
the same option rows. Display interpolation defaults off; Luau uses precompiled bytecode and keeps JIT
compilation disabled. An edited source or incompatible bytecode falls back to source compilation.

### Profiling

Native builds include [Tracy 0.14.1](https://github.com/wolfpld/tracy/releases/tag/v0.14.1) from a pinned source archive. Tracy records game zones, frame marks and plots only while `game.debug_mode=true` or a `--jump` debug session is active. Start the matching Tracy profiler and connect to localhost while the game runs; recording begins on connection. Normal sessions leave the local listener idle, and sampling and system tracing are disabled. `-DCT_ENABLE_TRACY=OFF` removes the dependency and instrumentation from a build entirely.

The default and `Game` frame tracks mark completed game frames; `Display` marks frames actually presented. CPU zones separate canonical scene rendering, display rendering, pacing and readbacks. Loading zones cover archive indexing and reads, script checks, model documents and instances, and texture decoding and uploads. Plots show scene draw counts, visual face table size, retained CPU geometry, resident GPU face batches, failed mesh uploads and immediate face draws. The last two plots describe work since the preceding visual-face sweep. These zones do not cross the game's cooperative thread switches. The renderer adds `Kazarov` CPU zones (RenderList, Interpolated, Replay, frame open/close, acquire, submit, present, fence wait), per-frame plots (mesh and 2D draws, descriptor binds, grab copies and pre-copies, transient bytes) and Vulkan GPU zones for dynamic-rendering spans, grab copies, uploads, depth queries and the swapchain blit. A capture's per-event GPU times export with `tracy-csvexport -g`. The Flatpak grants network access so a local Tracy profiler outside its sandbox can connect during a debug session. Distributed builds include Tracy's license notice.

### Optimisation

Release, RelWithDebInfo and MinSizeRel link the game with ThinLTO (`port/cmake/optimise.cmake`), so the native `port/src` tree and host code inline across units; the PC build does not compile PS2 sources. Release compiles and links at `-O3`. `-DCT_LTO=full` uses monolithic LTO instead, and `-DCT_LTO=off` disables it. x86-64 builds target `x86-64-v2` (SSE4.2 and POPCNT) in every configuration; `-DCT_X86_64_LEVEL` changes the baseline. lld keeps a ThinLTO cache in `lto-cache/` of the build directory. On macOS, ld64 keeps the LTO objects in `lto/`, where `dsymutil` reads their DWARF. CI ships the macOS and Windows Release builds and the Release Flatpak; the Linux job stays Debug for the Vulkan validation layer and assertions.

### Debug information

Every configuration keeps DWARF line tables in `darkchronicle`, so crash reports name `file:line`: Release and MinSizeRel build with `-gline-tables-only`, and Debug and RelWithDebInfo keep `-g`. Linux and Windows links write a build id, and Mach-O has its `LC_UUID`. On macOS, non-Debug builds run `dsymutil` after the link, and `darkchronicle.dSYM` must travel with the binary. `-DCT_SYMBOLS=split` also writes `darkchronicle.pdb` (Windows) or `darkchronicle.debug` (Linux), and a Debug dSYM on macOS. `-DCT_SYMBOLS=off` adds nothing. [SYMBOLS.md](SYMBOLS.md) describes the symbol artifacts CI uploads and `tools/crash/symbolize.py`, which re-resolves a report's raw frames.

### AddressSanitizer

The `linux-x64-asan` preset builds Debug with AddressSanitizer into `port/build/pc-asan`. In that build an arena reset (`stClearUsed`, `stReset`) poisons everything the arena had handed out, and allocating, growing the last allocation or taking `RemainingBytes` unpoisons only what is handed out again; binding an arena to a buffer unpoisons the buffer. A pointer the game still holds into a reset arena is then reported where it is read or written, with the reset that freed it, instead of corrupting whatever is allocated there next.

`tools/crash/asan-replays.ps1 [-Data <data dir>] [replays...]` builds the `windows-x64-asan` configuration (`build.bat windows-x64-asan`) and runs the replays that reload characters, weapons and menus (by default the dungeon weapon swap, the town and dungeon Items and Character menus and the equipped-weapon views) offscreen on the host GPU with game data. A replay's first line names its launch arguments; a run fails on any AddressSanitizer report, and its log stays in `port/build/windows-x64-asan/replays`. `tools/crash/asan-replays.sh` does the same in the Linux preset where a GPU driver is available; under the container's software Vulkan the game's pipeline set does not fit in memory, so there the preset serves the unit tests (`ctest --preset linux-x64-asan`).

### The PS2 build

```sh
./build.sh ps2-pal
BUILD_DIR=build/pal python3 scripts/build/verify.py -c
```

`./build.sh ps2-pal` builds `build/pal` in the container. `verify.py -c` checks the rebuilt executable against retail. Every change to `ps2/` must leave that check passing (see "Keeping the PS2 build matching").

### Continuous integration

Five independent workflows publish Windows, macOS, iOS, Linux and Nintendo Switch builds on pushes to `master`, pull requests and manual dispatches. Builds configure `CT_BUILD_TESTS=OFF`; neither the game suite nor the data bridge test executable is compiled. Linux remains the Flatpak in `linux.yml`, without a duplicate native Release build. `switch.yml` builds Kazarov's Switch toolchain image (cached between runs) and uploads the NRO with its ELF. Platform packages retain their separate symbol artifacts.

`tests.yml` runs separately and calls the same Windows, macOS and Linux configurations with tests enabled. Linux uses the Docker toolchain, Debug assertions and lavapipe; it preserves the PAL timing baseline check, Python clang-binding checks, Rust publisher tests, crash-symboliser tests, native runtime gate, PIE check and split-symbol checks. Windows runs the desktop suite excluding GPU cases, Rust tests and symbol resolution. macOS runs its desktop and Rust suites and checks dSYM resolution; the documented virtual-GPU exceptions remain report-only. iOS runs the existing floating-point formatting compatibility regressions on an available arm64 iPhone simulator. The desktop suite's subprocess/death-test assumptions are not supported by iOS. Each platform uploads CTest XML and diagnostics on failure.

`dependencies.yml` exports the Windows and Apple bundles from `tools/ci/Dockerfile` on a Linux runner. Dependency archives, CMake sources and single-header libraries are verified before export; the complete bundle is hashed again before extraction. Dependency cache keys include the Dockerfile, build declarations and pinned Kazarov revision. BuildKit layers, compiler results, Cargo registries and Cargo outputs are cached independently. Apple SDK and Homebrew setup stays native, with cached downloads and built iOS libraries. Failed dependency builds do not publish a partial bundle.

Builds use the available CPU cores, including the nested Luau host-tool build. Native Luau precompilation shares the game's compiler library; cross builds use a separate host compiler with the same source revision. A single Luau publisher copies changed or missing sources with up to 16 worker threads, preserving unchanged timestamps and edited obsolete files. Ninja skips the publisher entirely when its declared outputs are current. Bytecode generation remains a separate Ninja job per script. Windows, macOS and iOS also retain their ThinLTO caches across runs; Apple links enable the cache while preserving the objects needed for dSYM generation. New commits cancel obsolete runs for the same platform/ref; platform failures do not cancel other platforms.

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

Progress uses fixed stage budgets and weighted conversion work. The ETA waits for a stable sample,
limits corrections across stage changes, and displays “estimating time left” while work provides
insufficient progress samples. The ZIP writer reports completed producer work as entries are written.

`dc2data gameplay <iso-or-directory> port/gameplay` explicitly refreshes the repository gameplay JSON from the disc; `configs` remains an alias. The build compacts and compresses this corpus into a gameplay-only `assets/data.zip` beside the build executables; packages and installations ship that seed as `data.zip` beside the executable. Only document paths and content hashes are compiled into the executable. Normal extraction validates the seed against those hashes and copies its documents into `gameplay/` in the completed archive without reading or regenerating repository JSON. Build seeds stay separate from completed archives, so rebuilding does not overwrite extracted disc assets. The extractor searches beside its executable before checking the output root, supporting a separate `--run-dir`.
`current` compares the source path and file metadata with the versioned marker and checks the archive size; it returns 0 only when extraction can be skipped. `check` performs the full hash and payload audit.

The source of `extract` is a Dark Chronicle disc image or a folder holding `DATA.HD4`, `DATA.DAT`, `SOUND.HD3`, `SOUND.DAT` and `MOVIE`. Give it `<game-root>/data` as the output. The C++ command-line program calls the Rust extractor through a `cxx` bridge; conversion runs in process. The archive holds every retained and converted asset plus compact gameplay documents under `gameplay/` in `<game-root>/data.zip` ([format](PORT_ARCHIVE_FORMAT.md)), with a version marker at `<game-root>/data.json`. Textures use compact JSON and PNG; sound uses compact semantic JSON and PCM WAV; models and complete characters use glTF, external buffers and compact asset sidecars. Configuration, map, character and audio gameplay settings remain pretty-printed native JSON in the tracked `port/gameplay/` corpus for review. Movies are self-contained MP4 with copied MPEG-2 video and embedded lossless ALAC audio. Ordinary PACK archives become directories marked by `pack.json`, which records physical paths for relocated texture members. Native game code references physical asset paths directly, without catalogs or manifests. See the [migration](PORT_ASSET_MIGRATION.md), [texture](PORT_TEXTURE_FORMAT.md), [audio](PORT_AUDIO_FORMAT.md), [model](PORT_MODEL_FORMAT.md), and [configuration](PORT_CONFIG_FORMAT.md) documents. `dc2data check <game-root>/data` validates native payloads and the whole-output SHA-256 digest. Normal extraction reads the ISO once into shared memory and converts all asset categories on one worker pool into a bounded ZIP stream. It creates no staged asset files; verification reads the complete ZIP before transactional publication. Exit status: 0 on success, 1 on an error or failed check, 2 on usage error.

Each texture variant is a full-colour RGBA PNG. When retail animation scripts copy colours between textures, extraction bakes the finite source-colour variants into separate destination PNGs and records their selectors in the texture document. Source palettes are used only during extraction; runtime textures and generated render targets use RGBA pixels without palette files or palette uploads. `data.json` carries the current `data_version`, and the game rejects an older extraction so the launcher can rebuild it.

To upgrade an existing extraction after updating `tools/kazarov`:

1. Reconfigure and rebuild, so `darkchronicle` and `dc2data` share the pinned data version. A build directory re-runs CMake when `tools/kazarov/data_version.json` changes; `tools/windows/configure.ps1` also reconfigures it.
2. Extract again with `dc2data extract <iso-or-directory> <game-root>/data`, or start the game in a window and let setup re-extract when it rejects the older data version.

Help movie extraction first appears in Kazarov `2e6ef96` (data version 14). The fix did not bump the version, so if a version-14 extraction predates that commit, rerun `dc2data extract` explicitly; setup may already consider it current.

Never edit `data.json` to claim the new version: the marker would pass, but the older `data.zip` still lacks the newly extracted assets.

On iOS a launcher (`port/src/ios/Launcher.swift`; the iOS code is Swift under `port/src/ios`, calling the game through the C-compatible interface in `ios/bridge.hpp`) comes up on every start, before the game's window. It shows whether the data is current and offers **Play** only then. Without data it finds a disc image (`.iso`) in the app's Documents folder or its Inbox, where the Files app and Open In put it, or lets the player choose one in Files, opened in place rather than copied; it then extracts into the data root on a worker thread and draws the progress. **Extract Again…** re-extracts over current data, saves and settings untouched. **Settings** lists the APP SETTINGS rows, apart from the bindings, and **Help** explains where the disc image goes, LiveContainer included. The on-screen gamepad starts after the launcher.

`run.sh` and `run.bat` pass `--run-dir <checkout>/port/run`, giving them the data root `port/run/data`, whose parent holds `data.zip`, and `port/run/saves`. A direct executable launch defaults to the per-user `chronicletwo` application data root with the same layout. They also set `DC2_LOG=debug` when it is unset, so the console shows debug lines ([logging](LOGGING.md)).

The game reads its data through a read-only file system of mounts (`platform/vfs.hpp`). The base asset mount is `<game-root>/data.zip` when it exists; otherwise the unified `data/` directory is mounted, so directory fixtures and hand-edited data keep working. Gameplay documents live under `gameplay/` in either mount; directory fixtures supply their own documents. All names match ignoring ASCII case. The archive's central directory is read once at startup and its entries are read in place: Zstandard entries are decompressed on demand, and stored PNG and MP4 entries are copied from, or for movies streamed from, their offsets in the archive through FFmpeg custom I/O. Reads are thread-safe. Explicit `--run-dir DIR` selects a different root.

### Datapacks and replacement textures

Put datapacks in a `datapacks/` directory beside `data.zip`. The launch scripts
therefore use `port/run/datapacks/`; `--data DIR` uses `DIR/../datapacks/`. A
pack is a ZIP archive, `datapacks/<name>.zip`, holding files at their entry
names in `data.zip`, such as `textures/menu/example_0.png` for a texture or
`event/view_pal.txt` for a retained retail file. Build one from a folder with
`dc2data pack <folder> <name>.zip`; PNG and MP4 entries are stored and other
entries use Zstandard. A plain folder `datapacks/<name>/` with the same layout
is accepted as well, which is convenient while authoring a pack. When both
exist, the archive is used. Names may contain spaces or Unicode characters:

```text
<game-root>/
  data.zip
    textures/menu/example.json
    textures/menu/example_0.png
  datapacks/
    datapacks.json
    My texture pack.zip
      textures/menu/example_0.png
    Menu tweaks/
      textures/menu/example_0.png
```

Activate packs and set their priority in `datapacks/datapacks.json`. Each
`load_order` entry names a pack, with or without its `.zip` suffix:

```json
{
  "schema_version": 1,
  "load_order": ["My texture pack", "Menu tweaks"]
}
```

Later entries win when multiple packs replace the same file. Packs may contain
just one file: missing files fall through to earlier packs, then to `data.zip`.
Unlisted packs are inactive. Packs use the physical asset paths and do not need
a catalog, bundle JSON or manifest. `load_order` entries are single names; paths
and `..` are rejected. At startup the packs' file lists, from each archive's
central directory or a walk of each folder, are merged into one override index
keyed by lower-cased path, with each path's replacements resolved in
`load_order` priority once. A lookup is then a single hash lookup: a hit names
the winning pack file and any lower-priority replacements behind it, and a miss
goes to `data.zip`. A pack's `pack.json` does not limit this inventory; files
and child directories present in the pack are found even when it is absent or
lists no members. A replacement texture JSON can reference a PNG present only
in the same pack, using a path relative to the JSON under `textures/`. Pack
files are trusted as found: symlinks in folder packs
are followed and pack files are neither hashed nor checked against the pack. A
pack holding paths that differ only by ASCII case disables the packs. Missing
configuration leaves the retail assets active; invalid configuration disables
the packs and prints a diagnostic. Restart the game after changing
configuration or pack files.

Texture packs made for the earlier `.img` bundle layout can be migrated with
`tools/kazarov/scripts/migrate_texture_datapacks.py`. Pass the old v1
`port_data/catalog.json`, the new unified `data/` root containing direct v3
documents, and the `datapacks/` directory.
The command previews all moves and reports conflicts without changing packs;
add `--migrate` to apply the checked plan. Use `--save-map FILE` during the
preview to preserve the path mapping before replacing the old extraction, then
`--mapping-file FILE --datapacks DIR --migrate` after publication. The utility
preserves PNG bytes, keeps unrelated files, and removes empty legacy `.img`
directories. It rejects unmapped legacy PNGs, changed semantic identities,
different bytes at a destination, and paths that escape a pack.

```sh
python tools/kazarov/scripts/migrate_texture_datapacks.py \
  --old-catalog port/run/port_data/catalog.json \
  --new-root PATH/TO/NEW/data \
  --datapacks port/run/datapacks \
  --save-map port/run/.datapack-v1-v3-map.json
python tools/kazarov/scripts/migrate_texture_datapacks.py \
  --mapping-file port/run/.datapack-v1-v3-map.json \
  --datapacks port/run/datapacks --migrate
```

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

Data version 18 moves PNGs and standalone texture JSON below `textures/`,
retaining ordinary directories and removing extension-bearing container
directories. Character PNGs use the character basename and sequential suffixes,
such as `textures/chara/hero_0.png`. Re-extract after upgrading, and update older
datapack paths to match the new archive entries. The same pack folders
can replace PCM WAV files, bank or sequence JSON, converted
configuration JSON, self-contained movie MP4 files, glTF models, and model
metadata at their entry names in `data.zip`.
External glTF buffer and image URIs, such as `../textures/x_0.png`, resolve
against the glTF's directory within the data namespace and through the same
pack priority, so a pack replacing a PNG replaces it for every model that
references it; each external PNG is decoded once and shared. Invalid
model or metadata overlays can fall back to lower-priority candidates. See the
[audio](PORT_AUDIO_FORMAT.md), [model](PORT_MODEL_FORMAT.md), and
[configuration](PORT_CONFIG_FORMAT.md) formats for the physical paths and
replacement constraints. A replacement movie is best 1, 2 or 4 times the retail
512x416 picture; see [Movies](#movies).

Packs can also replace ordinary, unconverted files read by the game's file
loader. Put each file at its entry name in `data.zip`, directly inside the
same pack. These file paths follow the loader's case-insensitive
matching, and replacement file sizes are used when loading. Direct native files can also be supplied by active datapacks. Game configuration
commands, audio controls and movies use their actual JSON and MP4 paths. The
user's `config.json` beside the save root remains the port's settings file.

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

A data root is missing when its parent has no current `data.json` marker, or has neither `data.zip` nor the unified `data/` directory. A windowed run opens Kazarov's Rust setup window before creating the game window. The editable path accepts a disc image or a disc folder; **Choose image** and **Choose folder** open the operating system's file and folder pickers. A folder with no `DATA.DAT` and a single `.iso` file stands for that image. **Okay** starts extraction on a worker thread. The progress bar weights the ISO read, planning, concurrent asset categories, ZIP stream and final archive verification by planned work; model publication receives the largest share because it determines the conversion tail. The displayed ETA is withheld while critical model work makes no measurable progress, and 100% is reserved for successful publication. The setup window then closes automatically and normal game startup continues. Existing current data skips setup on subsequent launches. Extraction errors remain visible for correction and retry; closing setup before extraction exits with status 3. During extraction the window stays open until the worker finishes. Headless runs still print the `dc2data extract` command and exit with status 3.

The setup uses an eframe desktop window and rfd native dialogs on Windows, Linux and macOS. Linux file and folder selection requires an XDG desktop portal and its desktop backend. Extraction uses the same bounded ZIP stream, final archive checks and transactional publication as `dc2data`; the output must be outside the selected source folder. A typed ISO path is supported without mounting the image.

`run.sh` with no configuration runs `linux-x64-release` on Linux and `macos-arm64-release` on macOS; `./run.sh ps2-pal` boots the PS2 build in PCSX2. `run.bat` with no configuration runs `windows-x64-release`. A PC configuration name extracts the data first, as described above, and then runs the port.

### Saves

Continue and Save Adventure open the file list directly. There is no memory-card
selection or formatting step. The save screen lists every existing save and one
last unused file entry for a new save; the load screen lists only existing saves. Up/Down moves
one row and the shoulder buttons move two, as in the retail list. Cancel returns
to the screen that opened the menu. Replacing a save retains the retail yes/no
confirmation, with No selected initially. Unusable saves also require this
confirmation before replacement.

Each save is one JSON file under `<save root>/saves/`, named
`BESCES-51190dkcl<N>.json` (File N+1). The list has no 13-file limit. New Save uses the
first unused number, rechecks it when writing, and never replaces an occupied
name. Files with unsupported versions, unusable contents or wrong sizes remain
visible with their status. Unreadable entries are skipped; occupied names of saves,
of legacy images in the folder and of legacy card entries all reserve their numbers.
Listing reads each file's header (format, version, map, story progress, play time,
counter and unlocks) and caches it by file size and modification time; successful
game writes invalidate the affected cache entry immediately. The unused-file number
is computed on each catalog scan, including the scan before publication; drawing
the row does not query the disk. Loading always rereads and checks the complete
file before changing game state. Files over 64 MiB are refused before they are
parsed. Files are never removed automatically; unrelated names and temporary files
are not rows.

The autosave is `<save root>/saves/autosave.json`, the same document as a numbered
save, and never written by the save screen. It is written as a town save
once on each town map, the first frame the player walks it outside an interior
(however the town was entered, including leaving a dungeon by paying half the
money or with an escape item), and as a dungeon save
(`LOOP_DUNGEON`, `dng_tree_flag` 0) once on each floor, the first frame the
player has control there. Menus, events, locked input and paused field or player
updates defer the save. A town autosave is the game as it stands when written,
and turning autosave off leaves the map's arrival eligible when it is enabled
again. Loading the dungeon one takes retail's path for a
save made on a floor: the title enters the saved dungeon and floor with
`mc_load` set, and the floor load event (1010) builds the floor and runs its
arrival events again. The dungeon autosave therefore holds the game as that
event reached `DNG_FLOOR_INIT` (`DungeonFloorInit`, empty in retail), before any
of the floor's own events: the save data, every town's Georama layout and the
header as they stood then, with only the counter taken when it is written. An
arrival scene can set a flag whose effect lives only on the running floor: in
the Channel Pump Room, Underground Channel's floor 4, the scene before Linda
sets flag 103 and then sets the boss loose, and a save made after it loaded with
no boss. Nothing that happened on the floor after `DNG_FLOOR_INIT` is in the
save, the player's position and whatever the floor's events did before control
returned included; on loading those events run again from the entry state, as
entering the floor from the floor list does, and anything they do not redo is
lost. A floor reached without that call is not autosaved. The entry state is
dropped on the floor's first controllable frame, written or not, so a floor
whose first controllable frame passes with autosave off is not autosaved, even
if autosave is turned on there later: writing the entry state then would undo
what the player had done on the floor since.
A town autosave also records, in its `pc.spawn` object, the
player's position, rotation and camera. Retail saves hold only the map, and a
loaded town save starts at that map's save point (or its entrance on a map
without one); after loading the autosave, the first frame the player has control
on its map moves them back to the recorded spot. A spot whose map differs from the
save's, or whose coordinates are missing or not finite, is dropped while the save
still loads. Spawn data is consumed once, after the player regains control. New
games and manual or failed loads clear pending spawn data. The autosave's counter
is the newest, so the load screen, which lists it first as "Autosave", starts on
it until a later save; choosing it loads at once, as it has no file number for the
confirmation to name. `game.autosave` (PC Settings, Game page) turns it off;
headless, `--jump`, input-script and replay runs never write it. Spot files
`autosave.spawn.<counter>.json` from earlier builds are ignored and can be deleted.

The window icon uses the native `title/dc2_ic.gltf` model. Datapack
models take priority, with malformed replacements falling back to the next
valid candidate. The bundled two-moons icon remains available before extraction
or when no model is valid; headless runs skip icon rendering. On Windows the
native model also supplies `chronicletwo.ico` and the game shortcut.

#### Save file format

A save is a pretty-printed (two-space) JSON object written by `port/src/save_json.cpp`:

```json
{
  "format": "chronicletwo-save",
  "schema_version": 1,
  "header": { "version": "dc2Ver4", "map_no": 10, "unique_counter": 3, "play_time": 123456, ... },
  "save": { "bit_flag": [...], "play_time": 123456, "user_data": { ... }, ... },
  "towns": [ { "parts": [...], "houses": [...], "place_log": [...], "grids": [...] }, ... ],
  "pc": { "spawn": { "map_no": 10, "position": [...], ... } },
  "checksum": "crc32:1A2B3C4D"
}
```

- `header` holds `SAVEDATA_FORMAT`'s header fields by name except its version
  check digits and incomplete flag, plus copies of `play_time` and `game_progress`,
  so the list reads one object. `version` is always `dc2Ver4`.
- `save` holds every member of `CSaveData` in declaration order, under its C++ name.
  Numbers keep their exact integer values (enum fields stay integers, named by
  their enum in the headers); `s8` fields are written signed on every host. Nested
  records are objects and arrays are arrays. Floats are finite numbers; an infinity
  or NaN is kept as `{"float_bits": <u32>}`. Unknown byte runs (`unk_*` arrays) and
  the photo pixels (`photo_work`, 16-bit little-endian colours) are base64 strings.
  The item, weapon, ridepod, attachment, fish and boiled-fish names are UTF-8 text
  converted from CP932; a name that would not come back byte for byte (invalid
  CP932, no terminator, bytes after the terminator) is `{"base64": ...}`. On read,
  text too long for its field is cut without splitting a character. An item's
  `data` is the union member its `used_type` names (`item`, `attach`, `weapon`,
  `robopart`, `fish`, `giftbox`, `boiled`), or the union's base64 bytes for any other
  type. Photo image pointers are not saved; the album binds them when it opens.
- Each town record in `save.edit_data` keeps `save_count`, `culture_point`,
  `analyze` and `unk_5110`. The town's layout is the matching `towns` entry, with no
  limit: `parts` (`id`, `state`, `angle`, `pos`, four `color` triples and `house`,
  the house number plus one), `houses` (`npc_no`), `place_log` (`[parts_no, base_no]`
  pairs indexing `parts`) and `grids` (`num_x`, `num_z`, `pos` and base64 `cells`, a
  byte per cell, X major, bit 0 set for river).
- `pc` holds data of the PC only; it is empty except in a town autosave.
- `checksum` is the CRC-32 (IEEE) of the document without it, dumped with sorted keys
  and no indentation. A file whose checksum does not match is "Corrupt save". The
  key may be removed to edit a save by hand; a file without it is not checked. It is
  not a cryptographic integrity check.

`format`, `schema_version`, `header` and `save` are required; `towns`, `pc` and
`checksum` are optional. Unknown keys are ignored, a missing required key or one of
the wrong type makes the save "Unusable save (contents)", and so does a number out
of its field's range. A `schema_version` newer than the build reads is "Unsupported
save version". Each schema change adds a migration from the previous version, applied
in order when an older file is read; version 1 has none.

#### Legacy saves

Images in the port's earlier layout (exactly the host `sizeof(SAVEDATA_FORMAT)`) are
converted into JSON saves once, then moved into `<save root>/imported/`:

- a flat image `saves/BESCES-51190dkcl<N>` or `<N>.card2` becomes
  `BESCES-51190dkcl<N>.json` (or `.card2.json`), the original moving to
  `imported/flat/<name>`;
- a legacy `saves/autosave` becomes `autosave.json` unless one exists, and moves to
  `imported/flat/autosave`;
- a card entry `mc0/BESCES-51190dkcl<N>/BESCES-51190dkcl<N>` becomes
  `BESCES-51190dkcl<N>.json`, and one from `mc1` `BESCES-51190dkcl<N>.card2.json`
  with an `(import 2)` label; the whole entry, icons included, moves to
  `imported/mc0/<name>` or `imported/mc1/<name>`.

A legacy save takes its own number when no JSON save has it, and the first unused
number otherwise. Conversion validates the image as loading did (version, incomplete
flag, retail check digits), converts a `dc2Ver2` image's invention cards with the
retail routine, and decodes each town record's layout. A converted Ver2 save grants
no costume or bonus unlocks or debug code and has counter 0, so it is not the newest
save, until it is saved again. New files are created exclusively; existing JSON saves
are never overwritten. An occupied archive name gets a numbered suffix; nothing is
overwritten or deleted, and archived entries are never scanned again.

A legacy save is already converted when a JSON save lists the same header (counter,
play time, story progress, map, loop, dungeon, floor and fish count); it is then only
moved. Payloads are not compared beyond that header, so two legacy saves that differ
only in their contents share one converted copy. If conversion fails, the legacy save
stays listed with its status and, if valid, loads through the same conversion in
memory. If the move fails, its original row stays listed beside the converted copy
and a later scan retries only the move. While moving keeps failing, replacing or
deleting the converted copy lets the next scan convert the legacy save again under a
new number; newer progress is never overwritten. Replacing a still-listed legacy row
writes a new JSON save with exclusive creation and then moves the original. Card
payloads and archived originals are never modified. No import markers are read or
written; any existing `.save-imports/` directory is left untouched. When moving or
backing up a save root, include `saves/`, both card directories and `imported/`.

The save data uses the host layout of `CSaveData`; PS2-console save images (0x659C0
bytes) are not converted and stay listed as "Unusable save (size)". Photo album and
separate bonus-data storage keep their raw files and existing paths.

Save rows, the unused-file row, new-save/overwrite/load prompts, operation failure
notices and Finny Frenzy confirmations use the disc's retail localized messages.
The flat-folder notices "No saves found." and "Could not read the save folder.
Return and try again.", the second-card suffix "(import 2)", and the detailed
statuses "Cannot read save", "Unusable save (size)", "Unusable save (contents)",
"Unsupported save version", "Incomplete save", "Corrupt save" and the fallback
"Unusable save" have no corresponding retail flat-file diagnostics and remain in
English. Retail's no-data notice names a memory card and slot, so it is not used for
an empty PC save folder.

The photo album and Extras data keep libmc's two cards, `<save root>/mc0` and
`mc1`; `mc1` is created when a memory card manager starts, so both album slots work.
The boot notice "Reading memory card (PS2)." is not drawn. The PAL menu and system
messages that mention memory cards, slots or the console are replaced in all five
languages by `port/src/message_text.cpp` (album slots read "Album 1" and "Album 2").
It recognises the disc's `allmenu.mes` and `sysmes_<n>.mes` by their header words;
other message files are shown unchanged.

Saving uses Kazarov's `FilesWrite`: an exclusive temporary file beside the target,
a complete write, flush and close, then a write-through rename on Windows or a
rename and directory sync on POSIX. Failed writes report an error and leave the
menu available for retry. A process interrupted before publication leaves the
previous save and may leave a `<filename>.<hex>.tmp` file; these temporary files
can be removed while the game is closed. A load reads and validates the complete
file before changing the live game state.

### Retail data fixes

Retail gives two of Starlight Temple's (`f02`) chests the same opened flag 7: the
Fruit of Eden by the weapon platform (`item19`) and the one by Starlight Items
(`item11`), so opening either hid the other for good. The `UpdateTrBoxFlag`
override (`port/src/object/world/editloop.cpp`) records `item11` under flag 9, which no other
chest of the town uses; the save layout is unchanged. A save whose flag 7 is
already set offers `item11` again, which restores it to saves that lost it.

Closing the item page while the bag holds more of an item than its limit shows
menu message 153 and keeps the menu open. The Japanese text names the item and
the limit; the PAL translations leave both out, so the player cannot tell what
to move or throw away. `port/src/message_text.cpp` replaces the message in all
five PAL languages with the translation's wording plus both, for example
`You can only carry 999 "Thick Hide".`

The PAL disc's Spanish script for the map where Max learns Spheda
(`map/s/s17/s17_5.stb`) is a byte-for-byte copy of the Italian one, so its
Spheda tutorial, prompts and dialogue read in Italian. `port/src/script_text.cpp`
gives those 19 strings Spanish text when the script is translated to Luau
(`tools/luau/script_text.json`). Each line is anchored on its push instruction and
the Italian text it must find there; the transpiler refuses a script that does not
show every line. The wording keeps the PAL Spanish names (Esfera, Esfeda, Bastón Multiusos, Ayuda).

The Spanish text of the Spheda lesson that follows (`event/e300/e314/e314_5.txt`)
says there is nothing more to remember right before the colour rules, and has a
Sphere turn black, a colour it never takes. The same file corrects those three
lines by their exact text: "Tienes que acordarte de otra cosa más.", "De azul a
rojo, de rojo a azul." and "...y cambiará el color.".

The Spanish jump gate menus in Gundorada (`map/f/f04/f04_5.stb` and
`map/s/s30/s30_5.stb`) put East and West on one line, "Puerta de salto Este --
Oeste", so they show one destination fewer than the script offers: the last
choice is blank and the ones after North lead one destination further than they
say. The transpiler gives the three menus the English menu's lines, with East and
West apart and the time gate named "Puerta del tiempo".

### darkchronicle

```
darkchronicle [options]
```

| Option | Meaning |
|---|---|
| `--data DIR` | the extracted game data; `--data=DIR` also works. Resolved as in "Game data and first run" |
| `--save DIR` | saves and the pipeline cache; `config.json` and `logs/` go in its parent directory. `--save=DIR` also works. Resolved as in "Game data and first run" |
| `--window WxH` | window size in pixels, `x` or `X` between the sides. Default: `video.width` and `video.height` in `config.json`, then the monitor's. Headless: the offscreen image's size |
| `--headless` | on Linux and macOS, SDL's offscreen video driver with a Vulkan headless surface (`VK_EXT_headless_surface`); on Windows, SDL's `windows` driver with a hidden window. Without a headless surface it behaves as `--offscreen` |
| `--offscreen` | `--headless` without a Vulkan surface: frames are rendered to an image only |
| `--frames N` | exit with status 0 after frame N of the main loop. N is a positive integer |
| `--screenshot PATH` | with `--frames`: write the last frame to PATH as a PNG on exit. A failed write exits with status 1 |
| `--screenshot-display N` | with `--screenshot`: also write N interpolated display frames of that frame, as `<stem>-display-<k>.png` for k = 0 to N-1 |
| `--screenshot-fps` | with `--screenshot`: draw the FPS counter and any menu pointer into the image, from a presented frame at window size. With `--offscreen`, nothing is presented: the image is read back from the display image instead |
| `--input SCRIPT` | drive the pads from an input script at start-up. A bad script exits with status 2. Live input is ignored for the whole run: no gamepads open, the window's keyboard and mouse events are not read and the mouse is not captured |
| `--display-per-tick N` | also render N interpolated display frames per clock tick, discarded. N is a positive integer |
| `--show-fps` | draw the FPS counter on presented frames, headless too |
| `--log-fps` | print the FPS counter's text on stderr once a second |
| `--perf-seconds N` | measure a scene: once it has player control (or, without control, once its mode runs) and one more second has passed, log N one-second windows (`perf window`: ticks, presented images, canonical endpoints, superseded authored pairs, replayed ticks, presented FPS and update/busy milliseconds), then a `perf total` and exit 0. With `DC2_PERF_ZONES=1` it also lists each profiling zone's game-thread milliseconds per tick, its largest single tick and its time on other threads |
| `--log-level SPEC` | the log level: `trace`, `debug`, `info`, `warning`, `error`, `critical` or `off`, and/or `CATEGORY=LEVEL` pairs, comma-separated (for example `info,gfx=trace`). Outranks `DC2_LOG` and `log.level`; see [LOGGING.md](LOGGING.md) |

There is no `--help`. An unknown argument, an option without its value (other than `--data` and `--save`), or a bad value prints the usage on stderr and exits with status 2. `--data` and `--save` without a directory print `--data needs a directory` (or `--save needs a directory`) and exit with status 2, without the usage.

Environment, with the `DC2` prefix that `GameSetIdentity` sets:

- `DC2_DATA`, `DC2_SAVE`: the data and save roots, as above.
- `DC2_AUDIO=off`: no audio device. `DC2_AUDIO_WAV` outranks it.
- `DC2_AUDIO_WAV=PATH`: write the mix to a WAV file in place of the device.
- `DC2_AUDIO_TRACE`: any value other than empty or `0` traces the audio calls on stderr.
- `DC2_LOG=SPEC`: the log level, as `--log-level` takes it; `--log-level` outranks it, and it outranks `config.json`. An invalid value is logged and ignored.
- `DC2_LOG_FILE=0`: no session log file, whatever `log.file` says.
- `DC2_CRASH_TEST=MODE[:early]`: as `--crash-test` (see "Test hooks"); the option outranks it.
- `DC2_VULKAN_VALIDATION`: has no effect. `main` ORs its presence into `gfx::RendererConfig::validation`, which is already on in a Debug build, and a Release build never requests the layer.
- `DC2_RENDER_SCALE`: pixels per PS2 line of the render targets (`gfx::RendererConfig::render_scale`), up to 8; `0`, the default, derives it from the window height over 480.

Debug builds request the validation layer (`gfx::RendererConfig::validation`, on unless `NDEBUG` is defined). Release builds never request it. Without the layer installed, the renderer prints `gfx: validation requested but VK_LAYER_KHRONOS_validation is not installed` and goes on.

Exit statuses (`port/src/exitcodes.hpp`, and `port/src/render/mglib.cpp` for the screenshot write):

- 0: a normal exit, with the window closed or `--frames` reached. Retail's `LoadFile` on a missing file also exits 0, after printing `File open error "<name>"`, as retail does.
- 1: an SDL, window or renderer fatal error, or a screenshot write failure.
- 2: a usage error: an unknown or malformed option, or a bad `--input` script.
- 3: no extracted data at the data root (see "Game data and first run").
- 4: a game assertion (retail's `__assert`).
- 5: startup script validation rejected the data; desktop runs also show an error dialog.

A `PS2_UNIMPLEMENTED` stub aborts instead of exiting, so a debugger or a core dump stops at it: SIGABRT on Linux (status 134 from a shell) and `0xC0000409` on Windows. Other internal aborts stop the same way. A crash ends with its exception code on Windows (`0xC0000005` for an access violation) or its signal elsewhere.

A game assertion (4), a renderer or window fatal error (1), an abort and a crash first write a crash bundle under `<save root>/crashes/` (see [CRASH_REPORTS.md](CRASH_REPORTS.md)); the status stays the same.

The test `Smoke.HeadlessFramesScreenshot` (`port/src/tests/CMakeLists.txt`) runs `darkchronicle --headless --offscreen --frames 3 --screenshot` on a unified `data/` directory with a current parent `data.json`. It passes when the run exits 0, prints `dataread: indexed` and `mglib: frame 3 written to`, and writes a PNG. It is labelled `gpu`. It runs under a generated CMake script, because ctest counts a process killed by `abort()` as failed even when `PASS_REGULAR_EXPRESSION` matches its output; the script checks the exit status and the file.

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
- `--skip-events` (`DC2_SKIP_EVENTS=1`) makes a `dungeon:` jump start the floor
  load event (1010) instead of the floor-start event, so the floor list is not
  shown, and skips each skippable dungeon drama scene (the arrival
  communication or entrance scene) as soon as it allows it. A floor of Ocean's
  Roar is controllable by frame 60.
- `--invincible` (`DC2_INVINCIBLE=1`) holds the dungeon character's
  invulnerability counter (`CActionChara::muteki_time`) open every frame, so
  no hit lands or knocks it back. Poison and scripted HP changes still apply.
- `--seed N` (`DC2_SEED`) reseeds the game's random generator with N as each
  dungeon floor is built (`CAutoMapGen::SetupRoomInfo`), fixing the layout and
  the treasure and monster placement. Without it the seed is the retail stream.

For example, `darkchronicle --jump dungeon:0:1 --fast-load --headless --offscreen
--input tools/input/jump-dungeon-floor1.input --frames 2300 --screenshot floor.png`
reaches the first Underground Channel floor with movement and the HUD. See
[Debug mode](DEBUG.md#jump-replays) for other rendered checkpoints and controls.

`tools/input/perf-ocean-walk.input` is the Ocean's Roar performance replay: run
`darkchronicle --jump dungeon:3:1 --fast-load --skip-events --invincible --seed 1234
--window 1920x1080 --input tools/input/perf-ocean-walk.input --frames 480 --log-fps`
in a real window with `video.vsync` `false`. Max walks into the open
water and the camera pans across it, at about 3,000 scene draws a tick.

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

- `--crash-test MODE[:early]` (`DC2_CRASH_TEST`), not in the usage text, fails on purpose to exercise the crash reports: `segv`, `abort`, `assert`, `unimplemented`, `terminate`, `stackoverflow` or `audio-thread`. It fires at the end of the first game frame, or with `:early` right after `config.json` is read, before the data check and the window. See [CRASH_REPORTS.md](CRASH_REPORTS.md).
Fixtures and extracted game data stay outside the repository.

## Startup

`main` (`port/src/main.cpp`, `Run`) does these steps in order:

1. `GameSetIdentity` (`port/src/identity.cpp`) sets the `DC2` environment prefix, the game's directory names and the window title. `PathsConsumeArgs` takes `--data` and `--save` out of the arguments.
2. `ParseOptions` reads the other options. A usage error exits with status 2. `--input` loads its script here, and a bad script exits with status 2.
2a. `LogInit` starts the logger with stderr only, at the level of `--log-level` or `DC2_LOG`, and routes Kazarov's diagnostics into it. `LogShutdown` is registered with `atexit` before anything else that `main` registers, so it runs last. The session header goes to the log (see [LOGGING.md](LOGGING.md)).
2b. `CrashInit` installs the crash handlers and starts the crash report writer; runs with `--headless`, `--frames` or `--input` never show a crash dialog (see [CRASH_REPORTS.md](CRASH_REPORTS.md)). `--crash-test` (or `DC2_CRASH_TEST`) is parsed here.
3. `ConfigLoad` reads `config.json` from the save root's parent directory (see "config.json"). `LogAttachFile` then applies its `log` section and opens `<save root>/../logs/darkchronicle-<session>.log`, which starts with every line logged since `LogInit`. `CrashSetBundleRoot` then puts crash bundles under `<save root>/crashes/<session>/`, and an early `--crash-test` fires.
4. `FirstRunRequireData` checks the data root and opens setup when extraction is needed, or exits with status 3 in headless mode; on iOS it shows the launcher every time (see "Game data and first run").
4a. `InitCDFile` indexes the data root, printing `dataread: indexed N files under <dir>`.
5. The window opens, or the offscreen surface with `--headless`. A windowed run then shows the notice of a crash in an earlier session, if there is one not yet shown. Input initialises, and the input script is installed.
6. The renderer starts (`gfx::RendererInit`) with a logical size of 512x480 at a 4:3 display aspect. It builds every pipeline, uses `<save root>/pipeline_cache.bin` as its pipeline cache, and prints `compiling shaders n/total` as it goes.
7. `AudioInit(options.headless)` selects device-driven or tick-driven mixer ownership (see "Audio"). `AudioShutdown` is registered with `atexit`.
8. The clock starts at a fixed 60 Hz; headless runs use an unbounded clock. In that mode, frame-field measurements use logic ticks instead of wall elapsed time, including the sound sequencer's frame budget. Interactive runs retain the measured wall cadence. A pump hook runs once per clock pump, after the tick callback has run for each elapsed tick, and polls the window, the input and the input script. The config change hook is installed.
9. The main thread takes priority 10.
10. The `--frames` limit and screenshot, if any, are set, and `MainLoop()` (`port/src/platform/mainloop.cpp`) runs the retail sequence (see "MainLoop").

Before `main`, the game's static constructors run. The three VU0 helpers they need, `mgUnitMatrix`, `mgZeroMatrix` and `mgZeroVectorW` (`port/src/render/mg_math.cpp`), are real C++. On the PS2 the constructors run after the IOP set-up inside `mwInit`; on the host `mwInit` is empty (`port/src/runtime.cpp`). An SIF RPC client that no game code has bound yet gets an answer from `sceSifCheckStatRpc` and `sceSifCallRpc` instead of an abort, because the constructors reach the RPC layer before the game binds its clients (`tools/kazarov/src/cpp/sce/sifrpc.cpp`).

### Memory

`mgCMemory` is replaced whole (`port/src/memory/mg_memory.cpp`). Its pointers are host pointers, and the `mgMEMORY_BLOCK` header is two quadwords on the host. Blocks are 64-byte aligned through `uintptr_t`. The arenas themselves are described in "Arenas" below.

Each arena's high-water mark is tracked, and `MainLoop` logs `mg_memory: <name> peak P of C quadwords (F free)` after every loop exit. C includes the headroom, so `main_buffer`'s is four times retail's 0x1A0000 quadwords. This line is how the headroom for 8-byte pointers is measured.

### MainLoop

`port/src/platform/mainloop.cpp` retains the retail boot and mode-dispatch order. Native changes include pointer-width alignment; mapped arenas and native-sized sub-game storage; retained static helpers through link-name bridges; writable file paths; and arena high-water reporting. `InitCDFile` runs from `main` before renderer startup.

Launch hooks prepare an explicit scene jump and give requested items on arrival. Jumps skip the ordinary boot logo and select English. `game.skip_intro` keeps the language select but drops the boot logo's fades, the copyright notice and the Level-5 logo movie. Configured debug mode or a jump unlocks debug controls; the one-controller modifier, developer-menu chord and capture/resume handling are native additions. Mode changes cut interpolation, and the final frame border follows the live visible extent rather than fixed retail screen edges. Ordinary launches preserve the retail scene route and default debug gate.

## config.json

The configuration is `<save root>/../config.json`, with the sections `game`, `video`, `audio`, `input` and `log`. They fill Kazarov's `HostSettings` (`tools/kazarov/include/platform/settings.hpp`) and the port's `Config` (`port/src/platform/config.hpp`). Comments (`//` and `/* */`) are accepted. Enum and choice values are case-insensitive strings.

With `run.sh` or `run.bat`, settings and logs live at `port/run/config.json` and `port/run/logs/`. Installed builds keep them directly above `saves/` in the per-user application directory. A custom `--save` or `DC2_SAVE` also places them in the save root's parent directory. Existing installations should move `config.json` and `logs/` out of the save root to that parent directory.

- Missing: the file is written with the defaults.
- Unreadable (it exists but cannot be read, or is not a regular file): the defaults are used, `config: could not read <path>; using defaults and leaving it untouched` goes to stderr, and the file is not written in that session.
- Malformed JSON, or a root that is not an object: the defaults are used, `config.json: not valid JSON; using the defaults` (or `expected an object`) goes to stderr, and the next settings change that alters a value preserves the original bytes as `config.json.bad` before writing a fresh valid configuration. Existing backups are kept; later repairs use `.bad.1`, `.bad.2`, and so on. If the backup cannot be written, the original stays untouched and the settings change reports a save failure.
- Empty, or only whitespace: the defaults are used, silently. The next settings change uses the same backup and replacement behavior as malformed JSON.
- Invalid value, unknown key, or a section that is not an object: that key keeps its default, and `config.json: ignoring <name> = <value>` goes to stderr.

Writes are atomic: the file is written as `config.json.tmp` and renamed over `config.json`. It is written with 4-space indentation.

| Key | Type | Default | Values | Meaning |
|---|---|---|---|---|
| `game.debug_mode` | bool | false | | the boot debug unlock, and the pad-1 chord; see [DEBUG.md](DEBUG.md) |
| `game.autosave` | bool | true | | write the autosave on arriving in a town or on a dungeon floor |
| `game.quick_loadout_title` | string | bar | bar, plate | the quick loadout panel's title on a bar, or on a plate like the EXP gauge's; see [QUICK_LOADOUT.md](QUICK_LOADOUT.md) |
| `game.auto_use_event_item` | bool | false | | an event that asks for one item the bag holds is handed it without the item picker; see "Auto-use event items" |
| `game.spheda_handicap` | int | 0 | 0 to 5 | extra shots added to each Spheda hole's par as it is laid out; see "Spheda handicap" |
| `game.skip_intro` | bool | false | | boot past the Sony Computer Entertainment text, the copyright notice and the Level-5 logo to the title screen |
| `game.floor_info_monsters` | bool | false | | Triangle on a dungeon floor's information lists its monsters (spoilers); see "Floor monster list" |
| `game.more_monsters` | bool | false | | a dungeon floor holds up to 60 monsters instead of 24, and every monster in range shows and acts; see "Dungeon monster limit" |
| `video.vsync` | bool | true | true, false | V-Sync: FIFO presentation when on, immediate when off. An older `video.present_mode` is read as on for `fifo` and off otherwise |
| `video.interpolation` | bool | true (false on iOS) | | interpolate display frames between ticks |
| `video.render_thread` | string | async | off, lockstep, async | `async` (default) renders and presents display frames on a separate render thread while the game ticks, and follows the mouse between ticks so the menu pointer and the fixed-camera look move at the display rate; `off` runs everything on the game thread; `lockstep` runs device work on a worker while the caller waits; `DC2_RENDER_THREAD` overrides it; headless and screenshot runs always use `off`; applies at startup |
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
| `audio.dualsense_speaker` | bool | true | | plays the Ridepod's voice lines, the treasure chests' opening and the menus' sound effects on a DualSense speaker; see "Controller speaker" |
| `audio.controller_volume` | number | 1 | 0 to 2 | controller speaker gain, applied after `audio.master_volume` |
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
| `input.keyboard_walk` | bool | false | | keyboard movement walks and the `walk` binding (Left Shift) runs; off, it runs and `walk` walks |
| `input.mouse_fixed_look` | bool | true | | gentle mouse look in fixed-camera town rooms |
| `input.menu_pointer_speed` | number | 1.5 | 0.25 to 4 | captured menu hand travel per mouse count; 1 is one window pixel |
| `input.menu_pointer_acceleration` | bool | true | | fast captured motion moves the menu hand up to twice as far per count |
| `input.touchpad` | bool | true | | a DualSense touchpad as the menus' mouse |
| `input.touchpad_sensitivity` | number | 1.0 | above 0 | touchpad speed |
| `input.lightbar` | bool | true | | lets the game colour the lightbar; read and saved, nothing sets a colour yet |
| `input.rumble_strength` | number | 1.0 | 0 to 1 | scales the rumble motors |
| `input.dualsense_haptics` | string | full | off, vibration, full | what a DualSense's HD actuators play; see "Rumble and DualSense haptics" |
| `input.haptics_strength` | number | 1.0 | 0 to 2 | gain on the DualSense actuators |
| `input.glyphs` | string | new | original, new | button symbols: `new` from `glyphs/`, `original` from the game |
| `input.glyph_device` | string | auto | auto, ps3, ps4, ps5, ps5color, xbox, switch, steamdeck, steamcontroller, keyboard | whose button symbols are drawn |
| `input.mouse_release` | string or array of strings | empty | key names | keys that release the captured mouse |
| `input.bindings` | object: action to string or array of strings | empty | key names | rebinds actions; action names are lowercased |
| `input.gamepad_bindings` | object: action to string or array of strings | empty | SDL gamepad button names, `lefttrigger`, `righttrigger` | rebinds actions on a controller, a set apart from the keyboard's; see "Controller bindings" |
| `log.level` | string | auto | auto, trace, debug, info, warning, error, critical, off | the lowest level logged; `auto` is `debug` in a Debug build and `info` otherwise. `--log-level` and `DC2_LOG` outrank it; applies live |
| `log.file` | bool | true | | write the session log under `<save root>/../logs/`; `DC2_LOG_FILE=0` turns it off; applies live |
| `log.keep` | int | 10 | 1 to 1000 | session logs kept in `logs/`, this session's included; older ones are deleted when the file opens |
| `log.console` | bool | true | | copy log lines to stderr and the game's `printf` to stdout; applies live |
| `log.categories` | object: category to level | empty | category names, levels as `log.level` without `auto` | levels for single categories, over `log.level`; see [LOGGING.md](LOGGING.md) |

Opening PC SETTINGS does not write `config.json`. `ConfigChange` stores changed
settings and merges only those edits into the current file, preserving unknown
keys and unrelated values edited externally. Binding action names are merged
case-insensitively, so editing or restoring `cross` also replaces or removes a
hand-written `Cross` override without leaving a duplicate. It calls `DisplayChanged` and a
change hook. `SettingsChange` changes the shared host fields while retaining interpolation, aspect and UI scale. Through the hook, `main` applies the log settings, V-Sync, input bindings and controls, master volume, and presentation settings. Aspect and UI scale are applied between frame recordings.

### Gameplay timing

Native gameplay always uses NTSC timing at 60 logic ticks per second, with two
logic ticks per game frame (30 game frames per second). Executable timing values
and loaded disc scripts use the NTSC constants while retaining PAL disc content,
languages and balance data. There is no timing selector. Legacy `game.timing`
and `game.tick_rate` keys are ignored and preserved like other unknown keys;
loading or saving unrelated settings does not migrate them.

Movies retain their real-time cadence: a 25 fps movie stays at 25 fps while
NTSC gameplay produces 30 game frames per second, so some game frames repeat a
movie picture. Display interpolation and the display frame cap are independent
of gameplay timing.

Saved play time remains in 1/50 second units. At 60 Hz,
six enabled ticks add five saved units. Pausing retains fractional credit; a new
game or successful save load discards its unsaved remainder (less than 20 ms).
The existing PAL save display and fast-destroy record conversion retain their
units. Existing save counters from earlier custom-rate sessions are preserved
without a guessed migration factor.

### PC SETTINGS

Open **Options**, then press **SELECT** (Backspace with the default keyboard bindings), or click **PC SETTINGS** above the list. The original Options page still edits the retail save's options. Its confirm, cancel, reset, and L1/R1 page scrolling are unchanged; returning from PC SETTINGS keeps its cursor and choices.

On iOS the page is called **APP SETTINGS** and leaves out the rows that have nothing to act on there: window mode, resolution, V-Sync, the mouse rows and the DualSense speaker. The launcher's **Settings** shows the same rows, without the bindings, before the game starts.

The PC page uses the game's font and Options artwork. L1/R1 changes tabs, Up/Down selects a row, Left/Right changes a value, and confirm advances a choice or opens binding capture. Cancel returns to Options; Japanese retains its reversed confirm/cancel layout. The mouse can click tabs and value arrows, scroll rows, restore a binding, and return to Options. Hit targets follow aspect ratio, UI scale and window DPI.

The **PC SETTINGS** entry and the page are drawn at the UI scale, or smaller when that scale would push them past the window (`options::FitView`, about 113% for the page and 124% for the entry at 16:9 and 4:3), so every offered scale leaves them whole, readable and clickable. Their hit targets use the same view. The rest of the game keeps the chosen scale.

| Page | Settings |
|---|---|
| Display | Windowed/fullscreen, resolution, FIFO/mailbox/immediate, frame cap, interpolation, auto/4:3 aspect, UI scale, original/sharp text font, FPS counter |
| Audio | Master volume and PS2/custom soundtrack |
| Controls | Mouse sensitivity, Y inversion and capture; menu pointer speed and acceleration; stick sensitivity and X/Y inversion; button symbols and glyph style |
| Game | Autosave, quick loadout title, skip intro, auto-use event items, floor monster list, more monsters, transformation stats, transformation EXP, shared badge EXP and debug mode |
| Keyboard | Keyboard and mouse bindings for pad buttons, movement, look, walking, FPS, developer and mode debug menus, and quick loadout |
| Gamepad | Controller bindings for pad buttons, FPS, developer and mode debug menus, gyro hold and quick loadout |

Edits save to `config.json` and apply immediately. Soundtrack selection takes effect the next time a song starts, including one whose data is already loaded. Custom recordings use the actual sequence JSON path in `soundtrack/soundtrack.json`; `AUDIO_TRACE` prints that path. An absent or invalid recording falls back to the converted sequence. Current music is not restarted by moving the setting.

Turning to another tab, with L1/R1 or the mouse, plays the retail menu cursor sound once; clicking the tab already shown is silent.

Resolution changes the windowed size; fullscreen uses the desktop. A command-line `--window` takes precedence. A refused window change is read back and reported on screen. Hand-edited resolutions and numeric values are shown as stored and stay unchanged until that row is edited. The PC UI offers a bounded set of scale presets; the configuration file still accepts the full documented range.

Confirm on a binding shows **Press a key...**. Press a key or mouse button; Escape cancels and cannot be bound. The opening press is ignored, and the new input must be released before navigation resumes. Square or **Restore binding** removes that action's override and restores its defaults. Controller buttons are rebound on the Gamepad page (see "Controller bindings"). Glyph style changes the PC page's device-specific button prompts; keyboard prompts use current bindings. With **Button symbols** on New, the retail menus and messages draw the symbols of `glyphs/` for that style too (see [GLYPHS.md](GLYPHS.md)); Original keeps the PlayStation art everywhere.

A failed write shows a warning. Settings still work in the current session. Check the save root's parent directory and change a setting to retry. A configuration file that could not be read remains protected against replacement.

`tools/input/pc-settings.input` visits all six tabs, a key rebind, Escape cancellation, and return to retail Options from `--jump town:10 --fast-load`. Its comments give capture frames. `tools/input/pc-settings-mouse.input` exercises clicking and mouse-button capture at `--window 1280x960`. Use fresh save roots and `--screenshot-display 2` for both.

`tools/input/pc-settings-display.input` checks fullscreen, return to windowed, and resizing in a real window. Start with a fresh config containing a nonzero window size, omit `--window`, and stop at frame 940. The optional `PcSettingsReplay` CTests run the headless pad and mouse flows and assert the saved configuration when `DC2_DATA` is available.

### Monster transformation settings

Three PC SETTINGS > Game settings retune Monica's monster transformations. Each is off by default, which keeps retail's numbers, and `port/src/platform/userdata.cpp` overrides `MOS_CHANGE_PARAM::GetAttackVol`, `GetDefenceVol` and `CBattleCharaInfo::AddAbs`.

| Setting | Key | Off (retail) | On |
|---|---|---|---|
| Transformation stats | `game.transformation_stats` | Attack is the badge's base × (1 + 2 × level / 98), three times the base at level 98; defence is the base plus 2 per 6 levels, at most 30 | Attack grows twice as fast, base × (1 + 4 × level / 98), five times the base at level 98 and still capped at 999; defence is Monica's when hers is higher than the badge's own |
| Transformation EXP | `game.transformation_exp` | The badge in use gains each kill's absorption | It gains twice that |
| Shared badge EXP | `game.shared_badge_exp` | Only the badge in use gains absorption | A quarter of every absorption Monica gains, armed or transformed, also goes to each other unlocked badge, which levels up when its gauge fills |

Monica's defence starts at 8 and rises by 4 with each Witch Parfait, up to 128. The badge that adds a quarter to a transformation's attack and defence applies after these rules. Absorption and shared absorption apply at once; stats are read when Monica transforms, so they apply from the next transformation. Turning a setting off never changes a saved badge's level.

### Controller bindings

The controller has a set of bindings apart from the keyboard's, `input.gamepad_bindings`, which the **Gamepad** page
of PC SETTINGS edits. An action left out keeps its default: the pad's own layout for the pad's buttons (on a PS4 or
PS5 pad the touchpad click is Select and Share/Create presses nothing; on others Back/View is Select), `dpdown` for
`quick_loadout`, `paddle1` for `debug_menu` (the developer menu), `paddle2` for the unused `developer_menu` host action,
and `paddle4` for `gyro_hold`. The mode-debug-menu action, `mode_debug_menu`, has no default controller button;
its keyboard default is F2. Names are
SDL's (`a`, `b`, `x`, `y` by place, the bottom button being `a`; `back`, `guide`, `start`, `leftstick`,
`rightstick`, `leftshoulder`, `rightshoulder`, `dpup`, `dpdown`, `dpleft`, `dpright`, `touchpad`, `misc1`,
`paddle1` to `paddle4`) and `lefttrigger`, `righttrigger`; an empty list leaves the action without a button. Every
controller follows the one set. The sticks stay the sticks.

```json
"input": {
    "gamepad_bindings": {"cross": ["b"], "circle": ["a"], "quick_loadout": ["leftstick"]}
}
```

On the Gamepad page, confirm on an action and press the button or trigger to give it; Escape, a right click,
**Cancel capture** or five seconds without a press cancels, since every pad button can be bound. A pad button
another pad button's action has moves over, and that action takes the buttons this one had, so the two swap. The
port's own actions (quick loadout, FPS, debug menu, gyro hold) share buttons with the pad's: the button presses both.
Square or **Restore binding** restores the action's default the same way. Button names follow the glyph style,
and with **Button symbols** on New the game's symbols follow the controller bindings: Cross moved to the right face
button shows the Circle symbol. Host actions bound in `input.bindings` with a `Gamepad:` name (the earlier way)
still work beside these.

### Auto-use event items

With **Auto-use event items** (`game.auto_use_event_item`, PC SETTINGS > Game), an event that asks for exactly one item the bag holds is handed it without opening its item picker, and uses it up when the event asks; requests for several items and the fish tournament's picker are unchanged.

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

Outside menus, holding the `walk` binding (Left Shift by default) makes keyboard
movement deflect the left stick half way, so Max walks instead of running.
**Keyboard movement** (`input.keyboard_walk`, PC SETTINGS > Controls) set to Walk
swaps them: the keys walk and the `walk` binding runs. Controller sticks are unchanged.

The name entry screen (renaming items, the robot, fish and keywords) takes typing
outside Japanese: a letter, digit or one of the symbols the grid offers replaces the
character at the caret and moves it on, as picking it on the grid does. Backspace and
Delete act as the Back and Delete buttons, Return accepts the name, the arrow keys
still move over the grid and Escape cancels. While typing, those keys do not press
their pad bindings.

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

Captured motion arrives as raw counts with the OS pointer acceleration off, so the
hand has its own **Menu pointer speed** (default 150%) and **Menu pointer
acceleration** (default On) in PC SETTINGS > Controls. Acceleration leaves up to
four counts per tick linear and smoothly doubles the gain by 28 counts. Camera
look keeps `input.mouse_sensitivity`. With capture off the hand follows the
desktop cursor 1:1.

Mouse selection covers the town and dungeon root menus, title menu, world map,
dungeon floor maps and their help actions, the flat save/load file lists,
and the field Use Item popup. Yes/No boxes and dialogue choices use the message
system's drawn choice positions and feed its normal directional input before
confirming. The pointer follows the renderer's UI mapping, including widescreen
anchoring and display scaling.

The root and file lists pass their selection through the retail cursor helper,
so scrolling, help text and background loading follow the same path as a D-pad
move. The floor map similarly uses its normal next-room transition.

On the world map, hovering an unlocked area's mark selects it; clicking the mark
or the area's name frame opens its place list. On a dungeon floor map, opened from
the world map or a dungeon, hovering a room selects it and clicking opens its
information or question. Each wheel notch moves to the next room the arrow keys
reach along the path (down onward, up back), preferring Right, Down, Up, then
Left, so at a fork it keeps to the Right key's branch. Room hit boxes follow the
drawn pictures and their cull edge. Clicking a help label presses the button its
symbol shows: Back to Map or Exit Dungeon, Save Progress, and the floor
information's Move and Cancel. A left click elsewhere on the Floor Info screen
enters the floor as Cross does, except in the first 20 ticks after it opens, so
the second click of a double click on a room does not travel; the help labels
act at once. On these maps and the screens they open (the place list, the
travel and floor questions, and Save Progress's save screen), Mouse1 confirms
and Mouse2 cancels in the language's own layout, so Japanese confirms with
Circle.

The shared pointer implementation is `port/src/menu_mouse.cpp`; menu adapters, cursor
transitions, floor selection and message choices live in separate
`menu_mouse_*.cpp` files.

Deterministic mouse replays are `tools/input/town-mouse-menu.input` and
`title-mouse-menu.input` at `--window 1280x960`, and
`dungeon-mouse-floor.input` and `dungeon-mouse-save.input` at
`--window 1280x720`. Their comments give jump arguments and capture points.
`MenuMouse.*` and `MenuMouseInput.*` cover hit testing, display scaling,
controller handoff, scrolling and confirmation timing.

`town-mouse-menu-wide.input` checks opening and cancelling at 16:9.
`world-map-mouse.input`, with `--jump town:10 --fast-load --window 1920x1080`,
hovers and clicks world map areas, walks Rainbow Butterfly Wood's floor map with
the wheel, clicks Back to Map, Cancel and Move to this floor, and enters floor 1;
its comments give capture frames. `MenuMouseMap.*` and `MenuMouseMapInput.*`
cover the area marks, room pictures and culling, wheel steps through a fork, help
labels and these clicks in English and Japanese.
`dungeon-mouse-play.input` enters a floor through its Move label and opens its root menu.
`dungeon-mouse-item-popup.input` follows the normal dungeon replay to the locked
gate and selects the Gate Key with the mouse. `title-mouse-load.input` exercises
Continue, a file-row click and its confirmation using a copied flat-save fixture.
`title-mouse-newgame.input` clicks New Game and reaches costume selection.
File-list clicks wait through the retail cursor-settling delay before confirming.

Shops support hovering and clicking the goods list and bag grid. The wheel acts
on the pane under the pointer: a goods list or bag longer than its window scrolls
one row a notch with the retail eased scroll, stopping at its ends, and the cursor
takes the entry that settles under the pointer, or stays in view; a list that
fits moves its cursor a row. An empty goods list ignores the wheel and the bag
keeps the cursor, as it does for the D-pad. Rows still sliding out of the window
cannot be hovered; `tools/input/shop-mouse-wheel.input` replays both panes at 1920x1080.
In a buy/sell quantity prompt the wheel changes the quantity within the game's
limits. The quantity arrows, number panel, and localized Quit
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

Hover and the wheel play the menu's retail cursor-move sound once for each
change of its cursor, never while the target stays the same. Where the mouse
moves a cursor through the retail key step (`MenuMouseMove`, a synthesized
D-pad press, or a cursor the step compares after the hook: the root menu, file
lists, Options rows, Help, the floor map, message choices and the ITEM page's
bag and panels), that step plays it. Adapters that set a cursor themselves call
`MenuMouseCursorSound`, which plays at most once a tick: shops, item popups,
the title menu, the world map's area marks, Make, Monster Transform, Character
portraits and Cedric's board, Options choices, the ITEM page's command and
build-up lists, and a move to the same index on another ITEM panel. A shop
wheel notch or arrow click that changes the pane or leaves Quit also presses Up
or Down. The retail step sounds that press only if it moves, so at a list end
or quantity limit the shop adapter sounds the change instead. Fishing rod stats
are the ITEM cursor, so only the retail check sounds them. PC SETTINGS rows
stay silent, as they are with keys.

### Character, Options and Help mouse

On the Character page, hovering a shown portrait (Max, Monica, the Ridepod,
Monster Transform or the travelling townsperson) moves the retail cursor there,
and clicking it confirms; a click beside the portraits does nothing. While a
character change loads, left clicks do nothing. The change question, the
townsperson's View Status/Send back question, their commands and their
questions take clicks on their drawn choices; when a question opens over a
list that still draws its cursor, the newest window takes the mouse. On
Cedric's repair board, hover and the wheel select an item and only a click on
an item confirms, so a stray click cannot spend his points. Waits that take
any button (the opening, the townsperson's speech) still take any click.

Retail mirrors the hand to point left at Max; the mouse pointer is never
mirrored, so its body stays on the same side of the hotspot on every target.

On the retail Options page, hovering a row's label moves the row cursor and keeps
its choice; hovering a choice button also moves the choice. Clicking a button
selects that setting. The PC SETTINGS label opens that page on click.

In Help, hovering an entry moves the cursor and a click opens it. On an entry's
picture pages the wheel turns pages (down for the next) through the retail
Left/Right keys; a click turns to the next page and right click returns, as Cross
and Circle do. Movies keep their retail controls. Keyboard and controller input
is unchanged on all three pages.

The wheel follows one rule on these pages: in a list longer than its window,
each notch scrolls the list one row and the cursor takes the row that comes under
the pointer, or stays in view (`MenuMouseScroll`; the ITEM page's bag scrolls the
same way, as do the shop's goods list and bag). Elsewhere it moves the cursor,
as in the root menu; the Character page's portrait map is not a list, so the
wheel does nothing there.
Options and Help rows are hit where they are drawn while the list eases to a new scroll, and
only inside the list's scissor (`clip0`): a row sliding under the footer cannot
be clicked, and a visible row above the new scroll still can.

`tools/input/character-mouse.input`, `character-mouse-cedric.input`, `options-mouse.input` (`--jump town:10`)
and `help-mouse.input` (`--jump dungeon:0:1`) replay these at `--window 1920x1080`
with `--fast-load`; their comments give capture frames. `--screenshot-fps`
captures include the menu pointer.

### Stick and mouse follow camera

Right-stick look directly rotates the town and dungeon walking cameras at a
steady angular rate for each stick deflection, without a speed ramp or queued
rotation after release. Camera following still eases normally. Vertical look
keeps the selected height within the active camera's limits instead of drifting
back toward its resting height. Stick and mouse look share the collision checks
below; shoulder-button rotation and other camera modes retain their own controls.

**Invert stick X** and **Invert stick Y** default to **Off**. Off uses the opposite
direction from the original controller mapping; On restores the original direction
for that axis. This also applies to the left stick while it controls first-person
look, without reversing normal movement. The switches apply immediately and retain
their existing configuration keys. Mouse and gyro inversion are independent.

Mouse motion directly turns the active walking camera around the character. It
does not deflect the right stick or inherit its dead zone. Vertical
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
flag does not gate the follow camera, nor does the camera's follow flag, which
door, map and world map entry events and the dungeon death event leave off until
a later event resets the camera; the mouse turns the camera whenever camera
control is on, as the right stick does. Paused player or field control and
pending/running event scripts retain camera ownership. Town water movement uses
the walking camera; ladders keep their authored camera for both inputs.
Boss and arena views and menus retain their existing controls; Georama has its
own mouse camera, below. Fixed
town rooms use the separate fixed-camera look option below; photo view uses
the direct aiming controls described below. A camera-reset request owns
its frame; a later mouse yaw cancels an unfinished reset.

Direct yaw, from the stick or the mouse, uses retail's rotate-then-correct
collision response: it rotates the pending eye around its look-at point, and
retail's ground and wall correction, run on a fresh bounded polygon collection
covering the orbit and follow corridor, brings it in front of any wall on its
view. A turn along or into a wall therefore shortens the eye and goes on, and
the next update moves it back out as retail's follow does. Retail's obstacle
avoidance waits while the camera turns, as it did for the retail stick, so it
cannot swing the eye back against the turn. Unlike retail, which left the drawn
eye to ease after the pending one at a distance-dependent rate, direct yaw also
turns the drawn eye by the same angle at once, so the view follows the input.
After the turn, the view the tick's step shows is checked against every wall
except those that already hid the drawn view, from the look-at point and, when
retail's wall correction checks from an explicit collision target, from that
target too. A view already blocked, as retail's eased view can be when a pillar
comes between the eye and the player, therefore eases on behind that pillar,
but no other wall may come between. Each placement is checked through the
step itself. Where moving the drawn eye suffices, retail's pending pose is
kept: a drawn eye the turn takes behind a wall moves on along its easing path
toward a pending eye its look-at point can see, then in toward its look-at
point. Failing both, both eyes are placed on a view from the stepped look-at
point, at least ten units long so the camera keeps a usable direction: the
stepped view itself, or the nearest in heading to it of views turned from it in
eighths of a half turn either way. Each view's search starts just beyond ten
units, so the view still measures ten once stored and stepped, and goes as far
out as it finds in sight, five units nearer where there is room. This is a
bounded search of sampled headings, not of every clear point. If none has a
usable starting point, the turn is dropped for that update and retail's camera
stays as it was. Recovery can change the heading abruptly in tight wall-end
geometry. Presentation interpolation is cut when the eye itself would pass through
a camera wall between display frames, or when any of those other walls crosses
a sightline a display frame blends between the drawn pose and the next, the
look-at point's or the explicit collision target's, such as a thin post the
view passes across. Direct pitch keeps
conservative continuous checks on the same collection and clips an obstructed
tilt. A full polygon collector drops the motion rather than queuing it.
Explicit MouseX/MouseY stick bindings retain ownership of their axes and
suppress the independent mouse look on those axes.

`tools/input/town-mouse-camera.input`, with `--jump town:10 --fast-load`, exercises
yaw, vertical motion and a menu interruption. `tools/input/dungeon-mouse-camera.input`,
with `--jump dungeon:0:1 --fast-load`, enters the first floor and exercises the
same follow controls. `tools/input/dungeon-camera-wall-turn.input`, with the same
options, turns into and along the first corridor's wall with the right stick and
then the mouse; captures at frames 2600 and 2900 show the view turned on past
the wall.
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

### Georama mouse camera

In Georama's placement view the mouse turns and moves the camera as the right
stick does there. Horizontal motion turns the camera around the cursor; moving
the mouse right turns the view as the stick pushed right does. Vertical motion
changes the camera's distance, as the stick's vertical axis does: moving the
mouse up (with `input.mouse_invert_y` off) moves it out, like the stick pulled
down. `input.mouse_sensitivity` applies as for the follow camera, and the
distance moves at the stick's ratio of 15 units for each 0.1 radian of turn,
within retail's 400 to 800. The wheel, L1/R1 and the mouse buttons keep their
existing roles; retail has no Georama zoom button, so the wheel adds none.

The `EditMode` port override (`port/src/object/world/editmode.cpp`) applies each pad read's
mouse sample to the active edit camera before the retail cursor step, which then
adds the stick, follows the cursor and pulls the camera in from walls and under
the map's height limit exactly as it does for the stick alone. The sample is
skipped while retail ignores the pad (the cursor lock after a placement or removal),
with locked input or the debug camera, and outside an edit map. The parts menu
and its other screens take the mouse as their pointer, so motion there does not
reach the camera.

`tools/input/georama-mouse-camera.input`, with `--jump edit:0 --fast-load`
(Sindain), sets the edit debug menu's CharaMove to 1, enters Georama with Select
and exercises yaw, vertical motion and a parts-menu interruption; its comments
give capture frames. `GeoramaMouse.*` covers the stick parity, the distance
limits and the ownership checks.

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
cell, an active-item slot, an equipped weapon or the model on the left to move the
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
grid scroll one row each, stopping at the bag's ends, with the board's retail
eased scroll; the cell that settles under the pointer is selected.

The panel left of the bag follows its page: the character model on Max's and
Monica's pages, the turning weapon or fishing rod on a Status page, the Ridepod,
Monica's monster form, and Max's bait slot while a rod is equipped are targets
too. Hovering one moves the retail hand there and Mouse1 sends Cross, so clicking
a Status page's weapon opens its commands. Dropping a held item on a target sends
the Cross that carrying it there with the pad would: the character, Ridepod or
monster uses or equips it; on an equipped weapon, a Status page's weapon or a
bag weapon, a synth sphere opens the retail synthesis question and other items
are used on that weapon. The game's refusals, questions and sounds apply. An
item still carried after a refusal or a declined question returns to its slot,
unless controller or keyboard input took over in the meantime.
The 3D models have no form part of their own, so each area spans from the retail
hand's part to the page's name or parameter board. `item-menu-mouse-targets.input`
(`--jump town:10 --fast-load --give 388`, 1920x1080 or 4:3 1440x1080) drags a
Potato Pie onto Max (capture 800), spectrumises a Bread and drags the sphere
onto the Drill Wrench on its Status page: the question at 1680, the raised Flame
at 2150.

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

A weapon's Build Up list takes the mouse too. Hovering a target's name board,
or the gap before it where the retail hand points, selects that target and
plays the cursor sound. Mouse1 on a target sends Cross, so retail handles it:
a target shown as "???" is refused with the retail sound, and a reachable one
opens the build-up question. Clicks beside the targets do nothing, Mouse2 backs
out like Circle, and the wheel steps the selection. A weapon has at most three
targets and all of them are shown, so nothing scrolls. The boards are drawn with the left panels, so on a
wide window the targets are hit through the same spread mapping as the retail
hand, which stays beside its target there. `MenuMouseBuildUpRows`
(`port/src/menu_mouse.cpp`) gives the targets from the drawn name positions;
the Monster Transform class-change list uses it as well.
`tools/input/item-build-up-mouse.input` (`--jump town:10 --fast-load`, 1920x1080)
opens the Battle Wrench's two targets; its comments give capture frames.

### Item page over the paused world

The town and dungeon main menus capture the exact field frame at the pause instant (`port/src/menu_world.cpp`). The renderer replays that frame's recorded draws once with the player removed, and the same frame is then drawn in full. The playerless copy leaves out the player's meshes, shadow and outline, the effects the player owns, and the town's exit markers. Subgame menus retain retail behavior.

Entering Items runs the native orb close. The orb shows the scene dissolving as it converges on the backdrop, and the retail bg16 background fades. Returning to the root menu uses the native open. The menu character is framed on the left, its feet above the name and centred on the HP bar, and fades in after the orb closes. The Item title is centred, and on the town and dungeon menus the quick-select slots sit higher.

The Item panels spread across a centred 16:9 area (`gfx::UiAnchor::max_aspect`): panels left of the bag board anchor to the left edge and the rest to the right. Only depthless 2D follows an anchor, so under any UI anchor `SetSpriteEnv` (`port/src/object/menu/menudraw.cpp`) draws retail's depth-tested colour boxes depthless; otherwise the Ridepod's fuel gauge fill stayed at its 4:3 place and showed as a dark bar past the gauge. A form with a part as wide as the screen, such as the dimmer behind Spectrumise's result (`SPEFADE`), is left unanchored (`menuworld::ScreenWideForm`), so it keeps retail's depth test and still covers both sides. The cursor follows one continuous offset across the split, stays hidden until the panels settle, and is never mirrored. Mouse hit tests map the pointer back to the retail layout. The debug item browser ignores the spread.

### Make and Monster Transform mouse

On the Make menu, hovering an invention card or a cell of the item board moves
the retail cursor there; hovering the other pane brings it forward as Left and
Right do. Where the panes overlap, the pane in front keeps the pointer. Mouse1
on a card or cell confirms it; a click that brings the other pane forward only
selects. Mouse2 backs out like Circle, and clicks on the background confirm
nothing. The wheel moves the card cursor one row per notch, or scrolls the item
board one row with its retail eased scroll. On the quantity board, hovering Yes
or No selects it, the arrows and the wheel change the count, and Mouse1 on Yes,
No or the count confirms. Result and error messages accept a click. The idea
board, notebook and album pages have no pointer targets: Mouse1 there does
nothing and Mouse2 backs out.

On the Monster Transform screen, hovering a badge selects it and updates the
preview, Mouse1 opens its commands, and the wheel moves one row of badges.
Command, form and Yes/No lists use the shared message choices; the class-change
list accepts hover and click. On a badge's status page the wheel steps through
its forms like L1 and R1, and Mouse1 does nothing. Mouse2 backs out of each
step and closes the box.

The adapters are `port/src/menu_mouse_make.cpp` and `menu_mouse_monster.cpp`;
`MenuMouseMake.*` and `MakeMouse.*` test them. `tools/input/make-menu-mouse.input`
and `monster-transform-mouse.input` replay both screens at 1280x720 with
`--jump town:10 --fast-load`; their comments give capture frames.

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
to its normal distance range, as far as geometry permits. The Keyboard page
includes **Zoom reset**. The existing L2/cancel camera reset and turning the
option off also release zoom immediately. When enabled, the reset binding owns its
keyboard/mouse source ahead of conflicting actions; physical controller buttons
retain their retail actions, including R3's dungeon unit switch.

Zoom only starts after a wheel request. Pad-only play keeps the retail camera
path even when the option is enabled. Menus, events, lock-on, first-person,
fixed cameras, photo mode and Georama retain ownership and do not queue wheel
or reset input. Dungeon attacks and carrying keep the selected distance but do
not take wheel or reset input. A map or camera-parameter change clears the
selected zoom.

Each zoom update generates the retail follow destination at an allowed
distance and runs retail's floor, ceiling and wall correction and obstacle
avoidance on it, with the geometry gathered along that view. A view through
dense geometry is gathered in shorter pieces. The look-at point always follows
the player as in retail; only the eye is shortened, and it keeps six units from
geometry so the view does not graze the wall it rests against.
When the request is beyond retail's follow range, the characters' walking
collision also blocks the view, because the camera's own collision data leaves
out some facades seen from far away; the nearest wall from either source wins.
A walking wall counts only where the view crosses it farther from the look-at
point than retail's maximum follow distance; nearer, the camera's data decides
as in retail. This is an occlusion trade-off: pulling in to the railings,
ledges and invisible bounds retail's eye looks across would put the eye at the
character, but a nearer walking-only wall that retail's shorter view clears can
still hide the player from a longer zoomed view. Decorations without any
collision, such as awnings, can also come between.

Within retail's own follow distance (or a nearer request), walls shorten the
eye on each game frame as retail's correction does and release it as soon as
retail's would. Beyond it, the allowed distance drops at once when a wall cuts
the view. The camera updates once per game frame, 30 a second. The distance
returns 10% of the remaining gap per game frame (at least two units) only
after a view 32 units farther has stayed clear for 15 game frames, half a
second, both where the camera points and where it will point over the next two
seconds if it keeps turning as it is; a cleared eye is nine tenths of the way
back within about a second and a third. Pulling in further before the eye
begins moving out, such as backing into a wall, is one pull-in, and a first
pull-in does not hold: walking away from the wall brings the eye back out to
the selected distance, as retail's returns after a wall. A wall met again while recent
pull-ins are remembered holds the distance first, for a second and a half,
doubled for each further one up to six seconds; ten quiet seconds forget one.
Walking through rocks therefore keeps a shorter distance instead of returning
toward each next rock. A pull-in of less than ten units, such as foliage
brushing a still view or a wall approached a step at a time, still shortens
the eye but neither counts nor holds. When the eased eye would be drawn behind
a wall, it is placed in front of that wall on the drawn view, on the same side
of the look-at point, and from there it eases at the camera's own speed again.
Presentation interpolation is cut to the placed eye only where a display frame
blending to it would show a wall, the characters' walls included, between the
eye and the look-at point; otherwise the display frames blend to it as to any
pull-in. Interpolation is also cut when a wall from the camera's collision
crosses any view a display frame blends between
the drawn pose and the next, with the eye and look-at point each moving
linearly, such as a post both views pass on either side. Walls only the
walking collision knows are not part of that check: they limit each tick's own
view beyond retail's maximum follow distance, so one can show only in the
display frames blending between two ticks whose views clear it, never in a
tick's own view. The same check follows direct mouse
turning. A wheel request takes the requested distance at once, still limited
by the same correction. Only a pose that cannot be gathered even in pieces
falls back to retail movement. No retail parameter set is retained by zoom.

`tools/input/town-mouse-zoom.input` and `tools/input/dungeon-mouse-zoom.input`
exercise both limits, walking, reset and menu interruptions with the respective
`--jump town:10 --fast-load` and `--jump dungeon:0:1 --fast-load` hooks. Their
comments list capture frames; `--screenshot-display` also captures eased
presentation frames. Enable the option in `config.json` beside each replay's save root.
`tools/input/dungeon-mouse-zoom-wall.input` adds a sideways wall approach,
distance clamping, an inward reversal and reset in the same corridor.
`tools/input/dungeon-mouse-zoom-walk.input` zooms fully out there and walks
along, around and toward the corridor walls; the player stays in view throughout.

### Spheda handicap

**Spheda handicap** (`game.spheda_handicap`, PC SETTINGS > Game, Off by default) adds 1 to 5 shots to each Spheda hole's par. The par is the count of shots left: the number over the ball, which the event scripts take one from each shot, and below 2 the last-shot event plays. `CSphida::SetUp`, `s17_SetUp` and `Omake_SetUp` (`port/src/object/dun/sphida.cpp`) add the shots once a hole is laid out, keeping retail's cap of 99 (`dc2::sphida::HandicapPar`); an unknown bonus course lays out no hole and gets none. A change applies from the next hole. Debug mode's own extra shot, which `_SPHIDA_GET_PAR_COUNT` adds, is unchanged.

### Floor monster list

`game.floor_info_monsters` (**Floor monster list** in PC SETTINGS > Game, off by default) adds a list of a dungeon
floor's monsters to its information on the floor map (`port/src/floor_monsters.cpp`). Off, the floor map is
unchanged. On, it shows what the game keeps hidden (mimic chests, drop chances): Triangle opens the list from the
information when the floor lists no Georama materials, or from the materials list's last page, which then no longer
returns to the information. Triangle turns the list's pages and leaves it from the last one; Cancel leaves at once.
The prompt "Triangle: See monster info" (the Monster Notes item's command) shows under the information, with retail's
Move prompt moved up a row, and under the materials list's last page; it also shows for a floor chosen from the
dungeon menu. Clicking the prompt presses Triangle. Turning the setting off while the information or the list is
open restores the original screen.

Each kind of monster is listed with its count, then its drops and their chances. The counts come from the floor's
list in its `monster_floors` document (`dungeon/cfg_file/mos_place<n>.cfg.json`, see
[NATIVE_CONFIGS.md](NATIVE_CONFIGS.md)), read as `CreatMonsterFloorInfo` and `AutoSetMonster` read it: each entry is
placed once, mimics become treasure boxes, and live monsters past `MONSTER_ACTIVE_MAX` are not placed. Monsters that
events add are not listed. The first entry's kind carries the floor's gate key and shows the key's name in gold. Drop
chances follow `_SET_DEAD_START`: with both of the first two slots set, 13% and 4%; with one, 17%; the third slot
25%, or 100% while Borneo is with the player. A monster without reward money drops nothing. Names come from the
loaded monster table and item messages in the current language.

The list is drawn on the materials list's board, opaque and up to 12 rows tall. `tools/input/floor-monsters-channel.input`
(`--jump dungeon:0 --fast-load`) shows the list for a floor without materials, and
`tools/input/floor-monsters-deathtrap.input` (`--jump dungeon:4 --fast-load`) opens every floor with the menu debug
mode and pages from Deathtrap's materials to its monsters; their comments give capture frames. Both need the setting
on in the `config.json` beside the save root.

### Dungeon monster limit

Retail keeps 24 monster slots, scene characters `DNG_CHARA_SLOT_MONSTER` (24) to 47, and only the five nearest
monsters (`CMonsterMan::priority_limit`) show and act; `CActiveMonster::CheckView` fades the rest out and `ThinkHost`
skips them. The port's mirror of `monster.hpp` raises `MONSTER_ACTIVE_MAX` to 60, so the slots run to scene character
83 of 128. `CMonsterMan::Initialize` reads `game.more_monsters` once per floor through `PortMonsterLatchLimits`
(`port/src/object/dun/monster.cpp`): off, the floor uses 24 slots and a priority limit of 5, exactly as retail; on, it uses all 60
and every monster in range shows and acts. Unit fixups hold `AutoSetMonster`'s spawn count,
`CMonsterMan::SearchActiveMonsterBlock` and the event scene's slot memory to that limit, and `PrepareMonsterMemory`
(`port/src/object/dun/dng_event.cpp`) carves script memory only for the slots in use. A floor's placement list holds at most 32
monsters (`MONSTER_LOCATE_MAX`), so the setting raises a floor's opening count to at most 32; the remaining slots take
monsters spawned later.

### Event handles across a map change

An event can replace a map before its object sequences finish. CScene::DeleteMap
(port/src/object/event/sceneload.cpp) resets object, frame and function-point handles whose targets fall inside the released
map arena, then runs the retail deletion through PortRetailDeleteMap. Sequences following those handles stop
through their existing failed-position lookup. Character and sprite handles, and pointers outside the arena,
remain intact. Maps sharing the arena share this invalidation scope.

This prevents a stale map-part access after the chapter 6 Griffon cutscenes load d06e01.

### Texture blocks across a map change

EditMapJump (port/src/object/world/editloop.cpp) deletes the old villagers and maps before it lays out the next map's
memory. Rebinding MainDataBuff retires the map slot, and a retired slot no longer knows its texture blocks, so deleting
the map afterwards would release nothing: a texture animation allocated in the map arena would stay on its block while
the next map overwrites it, and the first draw of that block would walk the overwritten records.

This prevents the crash when the opening moves from Monica's battle through op_rain to s42.

### Georama limits

Retail caps a town at 256 edit part slots, a 1024-entry placement log, 32 houses,
a per-town polygon and drawing budget, each definition's `MAX_NUM` and a save
record of 300 parts, and its save quits the game past 300. The port keeps none of
these, always:

- `GetMaxPolyn` and `GetMaxDrawMem` (`port/src/object/world/editdata.cpp`) give every town no
  budget, and a unit fixup makes every Georama menu run its `POLYOF` script, which
  hides the polygon counter as retail does for its fifth town.
- A unit fixup sets every part definition's `max_num` to 9999, the limit of a held
  part count; the build menu clamps to 99 before quadrupling a map-wide part's limit
  (a second fixup), so the lifted value cannot overflow its `s16`.
- `CEditMap::CreateTable` (`port/src/object/world/editmap.cpp`) reserves one block for the edit
  part slots and one for their placement log, each sized for 32767 slots (the log
  names slots in an `s16`), and constructs slots as the town needs them:
  `eNewPlaceParts` reuses a free slot first and constructs the next one otherwise,
  four log entries with it. Slots never move, as placed parts and their animations
  keep pointers to them, and retail walks them as an array. A slot reused from the
  previous town's block starts zeroed.
- Part models are copied into `parts_heap` and then into further heaps of the same
  size (`BuildEditParts`); `DeleteEditParts` frees from the heap that holds the model
  and `ClearAllParts` clears every heap around retail's clear, kept as a bridge.
- Houses are one block sized for every slot, so a part's house pointer never moves;
  `eNewHouseInfo` reuses an inactive house before adding one. A removal's homeless
  villagers (`RemoveInfo::house_npc`) live in a vector of the port. Header fixups
  turn both arrays into pointers.
- Collision polygons name a placed part's slot in 15 bits (`CCPOLY_PARTS_EDIT` is
  `0x8000` and the slot mask `0x7FFF`, header fixups), so walking on parts in slots
  above 4095 finds them.
- The Georama menu's placed-part, part-name, placed and house lists
  (`CMenuGeorama::place_no`, `place_name`, `placed_list`, `house_list`) are vectors
  of `port/src/object/world/editmenu.cpp`, as long as the town has slots; header fixups make them
  pointers that `UpdateGeoramaPartsList` sets. It shows the culture points once
  rather than once per part. `stubs/editmenu.hpp` exposes the menu's town, menu and
  buildable-part table to it.
- The town's frame work stack grows with its slots before each draw (`EditDraw`,
  `port/src/object/world/editloop.cpp`): 256 sorted packets and their draw-table slots per part
  slot beyond retail's 10000 packets, and twice its size for the next frame once a
  frame has used more than half of it.
- `RemoveEditParts` keeps retail's rule without its recursion: a removed part takes
  every part resting on it through the log, but only when it has a log entry of its
  own, and a removed river cell takes the river parts it carried. `PaintFence`
  gathers fences into a vector and paints the joined ones without recursing.
  `CultureAnalyze` finds each part's children through the log once; parts beyond
  0x200 in one territory count, where retail stopped. `LoadData` places the parts
  resting on placed parts pass by pass as retail does, through an index of the log.
  The analysis conditions (`editanalyze.cpp`) still count at most 0x200 parts of a
  kind, which only saturates their thresholds.
- A town's layout is saved beside its save record rather than in it: `SaveData` and
  `LoadData` (`port/src/object/world/editdata.cpp`) write and read the layout kept for the record
  (`PortTownLayout`, `port/src/save_json.cpp`), with every part, house, log entry and
  grid; the record's own arrays stay cleared. `GetPlaceEditPartsNum`
  (`port/src/platform/savedata.cpp`) counts placed parts in those layouts. Clearing a record
  (a new game) forgets its layout; loading a save replaces them (see "Save file
  format").

`port/src/tests/georama_parts_test.cpp` covers slot growth to 5000 parts, the heaps,
houses beyond 32, the slot ceiling, removal against retail's recursion, tall stacks,
culture points against `CultureAnalyzeParts`, fence painting against retail's
recursion, and a 5000-part town saved and loaded back.

## Native integer widths

The tracked native source spells 64-bit game words with fixed-width types. Native `uptr`, `sptr` and `size_t` follow Kazarov's pointer-width types. The password codec tests cover its 64-bit groups and round trips. No build-time rewrite of PS2 `long` is used.

## Decision 2: threads

PS2 kernel threads run as cooperative fibers on one OS thread, so the retail thread loops run unchanged and host state stays on the main thread. A switch happens only in `StartThread`, `RotateThreadReadyQueue`, a blocking `WaitSema`, `SignalSema` preemption, and thread exit. See [Threads and timing](#threads-and-timing).

## Arenas

`ArenaBlock` in Kazarov's `tools/kazarov/include/platform/arena.hpp` supplies zeroed, aligned storage with a guard page. Its logical extent is the requested size, excluding page-rounding padding and the guard. A debug build checks that mapped storage lies above 4 GiB so low addresses cannot hide pointer truncation. `port/src/tests/arena_test.cpp` covers roots, children, guard pages, and allocation identities.

`MainLoop` establishes named `MainBuffer`, `InfoStack`, and `SystemSeStack` roots through `ArenaRoot` (`port/src/arena_root.cpp`). Legacy external-buffer binding can copy source bytes into a separate mapped root with `kArenaHeadroom` (4) times the requested quadwords. Explicit `ArenaBlock` roots retain their exact requested extent; this compatibility expansion must not be assumed by capacity checks or fixtures. Mapping logs identify each root's size and address. A raw address alone does not establish a retained consumer's storage lifetime.

An arena view retains its actual backing allocation, logical owner, generations, and requested extent. Child workspaces reserve their parent storage before binding. Sharing a temporary view preserves its upstream owner; the temporary allocator object is not the storage owner. Reset, free, rebinding, and address reuse invalidate the relevant leases. `ArenaBuffer` also distinguishes individual heap allocations, so freeing an unrelated block does not invalidate a live view. Parent headroom does not authorize access beyond a child's explicit extent.

Title submenus borrow the remaining `Stack_ReadBuff` storage explicitly. The menu retains that read arena as its owner when it shares the temporary cursor, so costume selection and the save browser remain live after title-menu initialization returns.

The renderer shares packet-data views while retaining their backing owner. Title initialization passes borrowed views of main-arena allocations, allowing model drawing to use those allocations after its temporary cursors are destroyed. Resetting the main arena still retires the renderer's views.

`stAlloc` and `Alloc` past an arena's end abort, naming `mgCMemory::name` or, when it has none, the arena's address, where retail printed and returned NULL. `stAllocTest` keeps retail's probe.

Headroom does not reach a stack carved with an explicit size. The native `charasetup.cpp` model stacks reserve 12000 extra quadwords each: human 0 and 1, ridepod 0 to 2, edit 0 and monster 0. `GetCharaMemAllocSize` sums the table, so the parent buffers grow with it. `chara_mem_budget_test.cpp` covers the carved sizes.

Each native map-load request owns aligned read storage sized for its files and sector tails. Deferred request copies share that exact allocation; a later write acquires independent storage when the allocation is shared. Concurrent and growing requests therefore do not depend on a fixed number of retired global buffers. `sceneload_map_buffer_test.cpp` covers request growth, copies, reset, and owner destruction.

Native arena objects use checked typed allocation based on their actual host size and alignment. `NewObject` and `NewArray` begin object lifetimes and reject overflow, insufficient capacity, locked storage, and nontrivial destruction that requires an ordinary owner. Controllers with owning members use explicit heap owners and retirement hooks. The historical retail-run comparisons in `arena_placement_test.cpp` identify layout growth; they are not permission to use an undersized native allocation. The [memory safety ledger](port/memory_safety.md) records remaining raw-allocation and lifetime reviews.

On Windows the executable is linked with `--dynamicbase` and `--high-entropy-va`, lld's MinGW defaults pinned in `port/cmake/arena.cmake`. The image base is 0x140000000, relocated by high-entropy ASLR, and the image is `LARGE_ADDRESS_AWARE`, so the image and the `VirtualAlloc` mappings lie above 4 GiB, and a truncated pointer faults at once. Linux stays `-pie -z separate-code`. Dark Cloud 1 links Windows with the same defaults.

## Threads and timing

PS2 kernel threads run as cooperative fibers on the one OS thread: ucontext on Linux, Win32 fibers on Windows. `CreateThread`, `StartThread`, `RotateThreadReadyQueue` and the semaphores are real.

Switches happen only in `StartThread`, `RotateThreadReadyQueue`, a blocking `WaitSema`, `SignalSema` preemption, and thread exit. A switch attempted inside `ClockPump` (its callback or hooks) aborts; death tests on both OSes cover this. An uncontended semaphore pair never yields. A `WaitSema` with nothing else ready aborts as a deadlock.

`WaitVSync` loops until `frames` ticks have passed since `start`. Each pass rotates the ready queue when a rotate priority is set (`mgSetRotateThread`), waits for the next tick, then pumps the clock. `sceGsSyncV` goes through `ClockSyncV`. In bounded mode, `mgNowFrameRate` comes from wall elapsed seconds times `ClockTickRate`, the same unit as retail's `T0/262`. In unbounded mode, `dc2::timing::FrameFields()` instead counts the logic ticks since `dc2::timing::BeginFrame()`, so rendering time and host delays cannot change the sequencer's field budget. A clock reset reanchors an open frame.

The reason for this design: the retail thread loops (`GamePadStep`, `NowLoadingLoop`, fishing's `StepDataLoading`, the movie threads) run unchanged, and host state stays on the main thread.

### Disc scripts under the NTSC timing

The PAL scripts (`.stb`) hold the NTSC frame counts and convert them while they run. The transpiler (`tools/luau/stb2luau/timing.py`) removes those conversions before it translates a script, so the Luau modules hold the NTSC counts.

- Event and map scripts count fields: the shared event helpers scale their counts by `* 50 / 60`, and some loop bounds and cues are written as `(N * 50) / 60`. Monster scripts count game frames through a `conv(n) = ftoi(itof(n) / 30.0f * 25.0f)` helper, and a few scripts divide by 30 and multiply by 25 in integers. Each conversion becomes opcode-22 no-ops, so the value reaches its consumer unchanged; the converter keeps its `FTOI`.
- The lip-sync helper's cue assignment, which PAL derives from the already scaled timeout, is removed whole.
- A few literals PAL retuned by hand (a jump in d03, a turn in s03, an object delay and wait in m06b, the backpack scene in i01h01b, one turn in e221a) are anchored: the instruction sequence must occur once and hold the PAL value before the NTSC value is written. The same anchors cover the language copies `_1` to `_5`.
- Max's and Monica's motion-ratio windows (`mainchr/c01.stb`, `c02.stb`, 8 bounds) take their NTSC values.
- Matching only looks at decoded instructions inside the script's functions (the program table, CALL targets and unreferenced function blocks), never at raw bytes. Every recipe is validated before any is written, sizes never change, and a converted script converts to the same bytes again.
- `tools/luau/stb2luau/timing_inventory.json` lists every script that holds a conversion, with the count of each recipe it must show. The transpiler refuses a listed script that does not match and an unlisted one that holds a conversion.
- Effect scripts keep PAL's waits for the end of their motion.

[Luau scripts](PORT_LUAU.md) describes the script kinds, the command catalog and the corpus survey for the Luau replacement of the script machine.

## Rendering

The native `render/mglib.cpp` contains the renderer-facing implementation and retained game behavior. `port/include/render/renderer.hpp` exposes the rendering interface used by other units. Its groups:

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

`mgEndFrame` queues the four `mgPickZBuff` 8x8 reads. A pick within 4 pixels of the screen edge gets `z` of -1, as retail does. It seals the list and renders it once, canonically. That render ends the gfx frame and fills `mgPickZBuff[].z` in GS units. `--screenshot`, `mgStoreImage`, `mgPortCanonicalReadColor`, `StoreImage`, `mgPickZBuff` and the depth queries (`mgPortQueueDepthRead`) all read that canonical render. Two exceptions: `--screenshot-fps` reads a presented frame (`PresentScreenshotFps`), and `ReadNow` falls back to the presented frame when the main target's canonical readback fails. It then waits for the next game frame (see "Ticks and display frames"). It sets `mgNowFrameRate` from `dc2::timing::FrameFields()`, with retail's upper clamp of `1 + mgFrameRate`. When the frame count reaches the `--frames` limit, it writes the screenshot and exits before the wait.

### Ticks and display frames

- One game frame is one pass of the game's loop, and one recorded list. It spans `mgFrameRate` clock ticks: 2 at the fixed 60 Hz rate, so 30 game frames a second. `mgFrameRate` keeps its meaning.
- After the canonical render, `mgEndFrame` calls `PresentWaitFrame`. It waits the same tick count `WaitVSync` waited for; the rotating-thread and pump behaviour is unchanged. Meanwhile `present.cpp` renders display frames from the newest list and the one before it. Each display frame's alpha is the elapsed fraction of the game frame: the ticks since the frame began plus the fraction of the current tick, over `mgFrameRate`. An alpha from the clock tick alone would run 0 to 1 twice per game frame at `mgFrameRate` 2. Display frames are presented as fast as `video.vsync` and `video.max_fps` allow (`max_fps` 0 is unlimited). A game frame whose wait presented nothing presents its canonical image afterwards (`PresentTickEnd`).
- Interpolated: the models of tagged mesh draws, and the camera (`tools/kazarov/src/cpp/gfx/README.md`, "Display lists"). A draw is tagged with `mgPortInterpScope(object, teleport_distance, blend_vertices, no_interpolation)`, keyed by the `mgCFrame` or, outside a frame, the visual's record. `kMgPortFrameTeleportDistance` is 200 units. Skinned prog0 draws blend their 32-bone model-space palette (`gfx::Prog0Palette::bones`) per bone: translation lerped, rotation slerped from the Gram-Schmidt rotation, scale and shear lerped in its frame. A bone that moved further than the draw's teleport distance keeps the newest pose. The rest of the per-draw block follows the interpolated model and camera: `model_world` is the interpolated model, `clip_or_view` and the object-space eye are re-based through the tick's and the interpolated object-to-eye transforms, and point lights shift with the object's origin. Dark Cloud 1's port, which shares the renderer, records no prog0 block, so it takes no such path.
- Depth-tested screen effects set `gfx::DrawState::screen_space` so the depth-of-field layers stay screen-aligned while sampling the display camera's refreshed grabs. World sprites retain camera reprojection.
- Dungeon pickup sprites (`CPullItem`, including coins, ABS and floating items) opt into keyed world-corner interpolation. `SetItem` starts a new emission generation; matched corners blend in world space under the display camera, including bobbing, glow size and opacity. Atlas animation stays newest. Reused slots, unmatched/incompatible draws, motion beyond 200 units, near-plane crossings and multi-camera lists keep newest own motion. Canonical and alpha-1 rendering remain exact.
- The healing point's lights (`CHealingEffectMan`, `port/src/object/dun/dng_effect.cpp`) draw each glow and halo as a sprite of its own, keyed by its light and kind, with keyed world-corner interpolation, so their orbit, bob, size and fade blend between game frames. Retail batched all 32 sprites into one draw, which could not be matched sprite by sprite. A culled light leaves the others' keys unchanged, and each `Set` (a new healing point) starts a new generation. Canonical rendering is unchanged.
- The recovery effect, the blue (or, for a power-up, yellow) sparkles that rise around a character healed by the healing point, food or drink, Resurrection Powder or an item used from the menu, is the effect script `n_heal` with the `n_heal_sub` sparkles it starts. Its sprites interpolate (`CEffectScriptMan::Draw`, `port/src/script/effscript.cpp`): each visible sprite is a batch of its own (`mgPortTag3DSpriteBatch`, `port/src/render/mg_sprite.cpp`), keyed by the sprite, with keyed world-corner interpolation, so their drift, spin and fade blend between game frames while the effect follows its character. Retail batched all of an effect's sprites that share a blend into one draw. A sprite's generation is its incarnation, a serial renewed whenever the script assigns the effect's sprites (`_SPT_ASSIGN_SPRITE`) or resets the slot (`_SPT_INIT_SPRITE`), so a particle reset and shown again in place between two game frames keeps its newest corners instead of blending from the one it replaced; a new effect assigns new sprites, so it starts afresh even where the last one stood. A hidden sprite leaves the others' keys unchanged. A refused assignment (the effect already has sprites) renews nothing, and a reset's slot index converts through `fptosi` as retail's does, so a NaN index renews slot 0, the slot retail resets. Only recovery effects keep incarnations. `DeleteEffSpt`, which every stop and clear goes through, drops an effect's. A game mode can retire its arena without clearing its manager (dungeon exit leaves `FxScriptMan`'s effects in place), so a manager's reset (`Initialize`, which its construction runs) drops every effect it started; other managers' effects are kept, including those in a work memory they share. Until that reset, or a new effect at the same address replacing the entry in `CreateEffSpt`, a retired arena's entries are inspected by cleanup but never used to dereference a retired effect. The seams wrap retail's routines through `RETAIL_BRIDGES` (`PortRetailInitialize`, `PortRetailDeleteEffSpt`, `PortRetailSptAssignSprite`, `PortRetailSptInitSprite`), and `port/src/effscript_config_bridge.inc` reads the running effect. The shipped `n_heal` resets its sprites only before its main loop and shows each slot once, so its sparkles interpolate throughout. Other effect scripts keep retail's batches, so their sprites' own motion still moves at the game rate. Two places still snap: the dungeon pause frame keeps the player-effect tag that the playerless capture needs, and on the Items page the sprites draw with no 3D scene to unproject through (that page also steps the effect on every other 60 Hz frame). Canonical rendering is unchanged.
- Enemy anger-counter marks (`CEnemyGekirin`) have independent screen-space keys, so their movement and break-away bounce interpolate even when HP changes or neighbouring marks disappear. `ResetGekirin` starts a new generation for refills and reused monsters. Game steps, rage counts and canonical rendering are unchanged.
- The quick-change name banner (`PortDrawQuickChangeBanner`, `port/src/object/menu/menuchr.cpp`) tags its strip and logo with one screen-space key, so the slide in and out and the strip's fade interpolate between game frames. Each banner shown starts a new generation, so a new banner starts at the left edge instead of sliding from the last one; one reappearing after a menu hid it starts where it is. The first and last visible game frames have nothing to slide from or to, so they appear and leave as recorded. Its timing and canonical rendering are unchanged.
- Not interpolated: ordinary HUD/text without depth; untagged 3D sprites' own motion; objects and cameras past their teleport thresholds; the first tick after `mgInit` and after `mgPortCutInterpolation()`, which `mainloop.cpp` calls on every loop change. Damage scores, lock-on markers, HP bars, anger-counter marks, target names and the quick-change name banner have separate opt-in screen-space presentation paths.
- `video.interpolation = false` presents each canonical image once.
- Headless, the clock is unbounded: one canonical render and one present per game frame. `--display-per-tick N` also renders N display frames at k/N and discards them. Screenshots are byte-identical with it (`PresentIdentity.DisplayPerTickScreenshot`).
- Frame grabs: `mgPortRenderTarget(..., frame_target = true)` makes a gfx frame target, which a display render grabs again from its own image.
- The FPS counter: `video.show_fps` turns it on (F3 and the `fps_toggle` host action flip it; headless only with `--show-fps`). It is drawn through `RecordHostOverlay`, as a display render's overlay, in the overlay's own font (the Dark Cloud Compendium Community Font baked into `overlay_font.inc`), so no canonical image holds it. The game's message font is not used: its texture lives only in the current mode's texture block (`ReLoadFontTexture` per mode) and `FontTex[0]` dangles across mode changes, so a badge in it would come and go with the modes. Its text is set by `video.fps_detail`; with all fields it reads `FPS 143.9  TICK 60.0/60  DRAWS 412`. TICK counts clock ticks per second, so it reads the tick rate whatever `mgFrameRate` is. DRAWS is the newest list's mesh plus 2D draws. `--log-fps` prints the same text on stderr once a second.
- Interpolation diagnostic: set `KZ_INTERPOLATION_TINT=1` to tint draws on the main presentation image (default off). Green is a matched transformed mesh; cyan is an unmatched or pose-excluded mesh carried by the display camera; red is newest-only geometry; blue is flat 2D or a screen effect; yellow is a depth-tested sprite with reprojected corners. Unchanged matched meshes remain green. This classifies geometry, not all its inputs: texture contents, lighting, fog parameters and sprite motion can still be tick-exact. Alpha tests, coverage, depth and blending are retained, so translucent passes can mix tints. Reusable intermediate render targets keep their original colours; their final composites are tinted on the main image. Canonical renders and ordinary screenshots never receive the tint. Use `--screenshot-display 8` to inspect the diagnostic at eight interpolation phases. Optional `KZ_INTERPOLATION_TRACE=<file>` appends per-draw CSV sections at alpha zero, including matching/cut reasons, texture IDs, camera IDs, target IDs, whether a draw is tinted on the main image, and changed fog/material/projection/local inputs. It writes only while tint is enabled; remove both environment variables after diagnosis.
- Outlined models render into a shared transparent image. Canonical clears and copies retain the retail draw rectangle; presentation scratch clears and replacement vertices cover the full visible extent so the interpolated model/bone pose remains complete under the display camera, including fixed-camera mouse look. Each copy preserves its texture-to-screen offset. Fixed-look current and previous lists preserve presentation vertices and clear rectangles while leaving resource retirement ownership with their source lists. Transparent texels in a depth-writing presentation composite do not write depth. GPU regressions compare a rotating thin part at alpha 0.5 against an independently recorded horizontal pose and complete fixed-look outline pixels at alpha 1 and 0.5 against a direct full-extent reference render; translation, scratch-target reuse and transparent-depth regressions remain covered. `tools/input/area-dungeon-chest-turn.input` with `--jump dungeon:0:1 --fast-load --frames 2518 --screenshot chest.png --screenshot-display 8` exercises the unopened chest during a camera turn. For multi-part NPCs, use `--input tools/input/repro-town-npc-outline.input --jump town:10 --fast-load --frames 278 --window 1280x720 --screenshot woman.png --screenshot-display 8`; the woman's face must remain visible throughout the turn. `--input tools/input/repro-clown-outline.input --frames 27230 --window 1280x720 --screenshot clown.png --screenshot-display 8` checks the clown's face during the prologue camera move.
- `--screenshot-display N` writes N display frames of the screenshot's frame, at alpha k/N from the previous list to the last, as `<stem>-display-<k>.png`. `--screenshot-fps` writes the screenshot with the FPS counter and any visible menu pointer drawn into it, at window size, from a presented frame (`RecordHostOverlay`, shared with presentation). With `--offscreen`, nothing is presented, and the image is read back from the display image instead. Neither reaches any other written image.
- `video.max_fps=0` leaves presentation uncapped; a positive cap paces display starts without catching up in bursts. A due logic tick takes priority. With V-Sync on, FIFO follows the display's synchronization; off, immediate presentation depends on device support. Interpolation off presents canonical frames at their game cadence; a high display cap does not increase the logic tick rate.

### Packets

No packet is built or sent, so there are no packet buffers. `mgInitVif1Packet` and `mgSetPacketBuffer` ignore their buffers. `mgVif1Packet` points at one empty sentinel, because `mgCDrawPrim` disables itself when it is null. `mgDrawDirect` passes every draw the same non-null scratch tag, which selects the immediate path and is never written, and returns the sizes the draws report (0 on PC). The data buffers (`mgSetDataBuffer`, `mgGetDataBuffer`) stay: the draw manager's sort lists and the visuals' per-draw records are allocated from them. `SendDMA` is empty. `mgSendVuProg` only records the program id, which `mgPortVuProg` returns. VU programs are never uploaded: the `linknames.cpp` symbols are placeholders.

### Sprites and window backings

- The GS evaluates a sprite's UV at integer pixel positions and a nearest filter takes `floor(u)`; the GPU samples at pixel centres of an upscaled window. For nearest-filtered UV sprites, `AssembleSprite` (`port/src/render/mg_drawprim.cpp`) therefore maps the quad onto exactly the texels the GS reads (`mgPortSpriteTexelSpan`) and adds `kMgPortNearestTexelBias` (1/64 texel) so a sample exactly on a texel boundary takes the texel after it, as the GS does. This keeps the font's one-texel-wider UV rects (`set2DSpriteEasyFont`) from bleeding the next glyph, and 1:1 background tiles from showing a black seam at 2.5x. Linear-filtered UV sprites subtract half a destination pixel times the UV slope from both corners, so their samples also correspond to the GS integer pixel locations rather than Vulkan pixel centres. This handles stretched and flipped sprites without identifying textures or changing atlas rectangles. TME/FST-off draws keep their UVs. `MgDrawPrim.*` checks the slopes; `MgDrawPrimRender.LinearAtlasCellsKeepTopOutlinesWithoutSamplingTheNextCell` checks RGBA and indexed atlas cells at 2.5x. The bilinear sampler's half-texel footprint is separate from this pixel-location correction.
- The versatile dialog backing (`FillRect`, `port/src/object/menu/nd_meswin.cpp`) extends one pixel above and left of its requested rectangle while retaining its right and bottom edges, covering the gaiji frame opening with one translucent quad at fractional display scales. The selected-line dialog (`DrawVersatileWin_3`) measures its upper side from the window's top-side position rather than its height, keeping the backing continuous down to the selected band. Collapsed sections are omitted during window animation. Geometry tests cover these bounds and opacity; `MgDrawPrimRender.HelpWindowTranslucentTilesHaveContinuousCoverage` checks the tiled help background at 2.5x.
- Item-page panel anchors use their inward action destinations, so the bag, character panels and their contents retain their sides during entry and exit. Shared root-menu icons, area/time boards and area text retain their original coordinates throughout the transition back to the root menu. The paused world dissolves into the returning menu background with an eased blend synchronized to the closing frame animation; presentation interpolation also blends between its logic ticks.
- The English PAL Characters layout leaves Monica's grey slot at its original vertical position and height despite moving and stretching her portrait for PAL. `MenuAlignCharacterSlot` (`port/src/object/menu/menudraw.cpp`) corrects that specific legacy rectangle to match the other PAL layouts; the correction applies only when the original mismatched dimensions are present.
- The menu background tile grid (`DrawMenuTilePattern`, `port/src/object/menu/menudraw.cpp`) starts at or left of x = -256 and runs to 256 past the right edge, with rows reaching 256 past the bottom, so 16:9 and 9:16 windows show no uncovered flank. The 4:3 letterbox clips the extra tiles, so the canonical image is unchanged; `port/src/tests/menudraw_tile_test.cpp` covers the column range.

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

Shadow geometry uses six indexed vertices per valid prism instead of duplicating every triangle corner.
The native mesh cache welds coincident positions, records unique edge neighbours and refreshes when an
arena address is reused with different geometry. A shared side is omitted only when its biased corners
match, its quad is planar, and the two prisms lie on opposite sides; clipped neighbours, overlaps and
non-manifold edges retain their sides. Draw scratch buffers retain their capacity between submissions.

These are the applicable Chronicle shadow optimisations; ChronicleTwo already counts volumes in stencil,
uses colourless volume draws, batches compatible visual face groups and snapshots refraction at the water
draw. Water vertex and index scratch buffers also retain their capacity. The pinned shared Kazarov renderer
supplies colourless-draw fragment elision, cached display targets and the parallel asset-class scheduler.


`mgBeginDrawShadow` clears the main target's stencil (when a frame is open) and enters shadow mode. While in shadow, `mgPortShadowTarget()` returns the main target. `mgEndDrawShadow` composites a quad over the visible extent onto the main target: vertex alpha 48, blend `(0 - Cd) * As / 128 + Cd` with FIX `0x80` (128), alpha test off, and stencil test NotEqual 0, which zeroes the count. It then sets TEXA to TA0 0, TA1 128, AEM 1.

The shadow draw reads retail's `mgCShadowMDT::CreateFace` layout: triangles of three position indices. The native loader builds a shadow model's faces in the visual layout (position, normal, uv and colour indices per corner) and then compacts them into that layout (`ShadowFaces` in `port/src/platform/model_assets.cpp`), keeping only triangle lists as retail does. Shadow groups carry `MG_VU_PROG_SHADOW` and build no face meshes, including after a morph.

### Controller speaker

`audio.dualsense_speaker` sends the Ridepod's voice lines (the `8520xx.wav` streams the dungeon robot opens) the treasure chests' opening (sound effects 110 to 112 of the base bank, the wood, iron and stone chests' sequences) and the menus' sound effects (the system bank `SY_000`: cursor, decide, windows, items, equipment, inventions, Georama, message advance; its trap, level-up and lock-on effects stay on the TV) to a second playback device: the first one whose name contains "DualSense" or "Wireless Controller". Windows exposes that endpoint for a DualSense on USB, and for a Bluetooth pad through a DualSense emulation driver that creates one. The sounds are summed to mono and leave the main mix while they play; the effects play there without reverb. Without such a device they stay on the main output and stderr reports it once. Turning it off keeps every sound on the main output, as on the PS2. The choice applies from the next line or effect; `audio.controller_volume` applies live. The older `audio.robot_voice` key still loads and is no longer written.

### Rumble and DualSense haptics

The game vibrates only when the player takes a hit (the small motor for a stagger, the large one for a knockdown) and while fishing. `CGamePad::Step` sends those motors to every gamepad SDL has open, not only pad 0: DSX and Steam Input show one DualSense as two devices, and only one of them shakes. stderr logs each pad once, with its type, connection and rumble support.

When the controller speaker's device (see "Controller speaker") has four channels, as a DualSense's does, it is opened as quad: the front pair is the speaker and the rear pair drives the two actuators. With `input.dualsense_haptics` on, the motors play there instead of through SDL's emulated rumble, which turns the pad's audio haptics off while it runs: the large motor as a 60 Hz tone, heavier on the left, the small one as a 170 Hz tone, heavier on the right. `full` adds camera quakes (the dungeon's `CAMERA_QUAKE` and the scene sequences' quake commands, while their counters move) as a low rumble, and the effects of the character, battle and monster sound ports (monsters at half volume), mirrored to a third mixer and low-passed at 220 Hz. Without four channels, or with `off`, the motors use SDL rumble.

### Font and headless

#### Message font

`video.text_font` chooses how the game's text is drawn. `"sharp"`, the default, draws the letters as
outlines from ChronicleTwoMessage, rasterized at the target's own resolution. `"original"` (**Options →
PC SETTINGS → Display → Text font**) draws the retail font pages, 16x20-texel cells stretched to the
screen. The setting applies to the next drawn text.

ChronicleTwoMessage (`port/assets/fonts/ChronicleTwoMessage-Regular.ttf`, copied to `fonts/` beside
the executable with Kosugi's Apache 2.0 licence and a notice of the changes) is made from Kosugi, the
open release of a MOTOYA gothic. Measured against the retail pages, Kosugi matches their design far
better than any other open font tried; the retail font is very likely a MOTOYA gothic itself (it
draws ß as an upright β, as Japanese fonts do). The font is laid out on the retail cell grid: 64 units
a texel, 1280 an em, the pen at the cell's left edge on row 16, half-width cells 512 units wide and
full-width 1024. A cell maps onto it directly, with no fitting at run time.

Every font cell the game draws, from `CFont::DrawChar`, its outlines and shadows and the event
stopwatch, reaches `set2DSpriteEasyFont` (`port/src/object/menu/font.cpp`). The cell's texture
rectangle gives its font number; `dc2::font::Character` turns that into a character from the language's
font table:

- French, German, Italian and Spanish (`fonttbl_2.bin`): ASCII, the 63 letters of
  `alphabetical_chara_tbl` (font numbers 0x5E-0x9C) and the 24 symbols of `FontGaijiConvTbl`
  (0x9D-0xB4). Their half-width middle dot is U+FF65.
- English (`fonttbl_1.bin`): ASCII and 119 full-width symbols by Shift-JIS code. Where the European
  page draws a character half-width, the English page's full-width form takes a private code:
  “ U+E001, ” U+E002, ’ U+E004, ° U+E005.

Kana, kanji, Japanese and the small font keep their bitmaps, as does a cell the font cannot draw.

Drawn sharp, each half-width character takes its own width in the font. The original font sets every
one in the same cell, 7 pixels apart at the usual size, which leaves an i or an l standing apart from
its word; the font's letters are spaced as a type designer spaces them (see the build below), and
`dc2::font::HalfAdvance` gives a character's advance over the cell's. Retail code still breaks lines and
pages and reveals and times the text; only the pen moves:

- Message windows: `ClsMes::MakeMesWin` (both overloads, `port/src/object/menu/nd_meswin.cpp`) lays the
  message out as retail does, then kerns it. Each laid-out character moves by how much the
  half-width characters before it on its line widen or narrow: retail's half advance
  (`font_w * half_font_w_percent`, or `font_w / 2` for a space) times the font's advance over the
  cell's, less retail's. Each line's width moves by its whole shift, and the text width, the line
  indents and the bubble are sized again from those widths as retail sized them. A space whose width
  the text sets keeps it: the European text narrows its spaces with a width code at the start of a
  line (0xF805, 0xF806). While retail lays out, `GetStrWidth` and `GetMesWidth_system` measure as retail
  does, so the names and items it inserts move once.
- A window's table holds whole pixels, so each window keeps its characters' pens beside it.
  `ClsMes::DrawFont` draws each glyph at the whole pixel left of its pen and
  carries the rest to the painter (`dc2::font::SubpixelPen`); button and digit pictures take the nearer pixel.
- `GetStrWidth` and `GetMesWidth_system`, which menus measure names and items with, add each
  half-width character's change. `CFont::DrawDirect` and `CalcDrawWH`, the menus' own text and PC
  SETTINGS, advance by it; `CalcDrawWH` rounds up, so text stays inside the width it was measured at.
- Figures and symbols keep the cell, so numbers still line up in columns. Full-width characters,
  button pictures and the European page's font symbols advance as retail's do.

The original font keeps retail's layout exactly.

Retail's outlines and shadows (`set2DSprite_Fuchi`) are the glyph drawn again a pixel or two off, made
for a CRT, which blurred those copies into one soft rim; drawn sharp, they are steps. `set2DSprite_Fuchi`
hands the outline styles to `DrawSharpFuchi`, and the sharp font
draws each outline style as one round rim instead, its distance from the glyph measured in logical
pixels so it stays round where a logical pixel is not square (`port/src/text/outline.cpp`). Each rim
lays down the ink retail's copies do, measured over a sample of glyphs at 8x: `FUCHI_OUTLINE`'s four
copies a pixel out are a rim of 0.85 pixels and `FUCHI_OUTLINE_THICK`'s twelve one of 1.67, each with a
half-pixel soft edge; `FUCHI_OUTLINE_WIDE`'s four faint copies two out are a glow fading to nothing at
2.5 pixels, 0.312 of the text's alpha at the glyph. The shadows are copies of the glyph moved, already
smooth, so retail still draws them, each copy through the sharp painter; `FUCHI_SHADOW_WHITE_BLUE`'s two
blue copies a pixel and two up-left are drawn as one extrusion, with the quarter pixels between them.

`dc2::font::PageOf` holds how each page draws the font. The European pages draw it as it is. The English
page draws the same outlines 1.335 times taller and 0.955 times as wide, its pen 0.63 texels left and
its baseline at row 17.31, which is why its stems look thinner. The painter rasterizes each glyph
through Kazarov's `ttffont::RenderGlyph` at the exact horizontal and vertical em the cell lands at in
target pixels, its pen at a quarter pixel and its baseline on a whole pixel, and places the image on
whole pixels, so nothing is resampled. Glyph images are immutable; past a 32 MiB budget the least
recently drawn are destroyed, and a frame's list keeps any it still draws alive until it is done.

The font is built by `scripts/font/build_message_font.py` from Kosugi 4.002 (fetched once at a pinned
google/fonts revision and checked against its SHA-256) and the numbers in
`scripts/font/message_font.json`; no game data is read, and the build is reproducible byte for byte.
The numbers come from `scripts/font/fit_message_font.py <game-root>`, which measures Kosugi against the
pages of the user's own extraction:

- One affine maps Kosugi to the European page, and one more maps that to the English page.
- Each ASCII glyph may be scaled about its centre (its stems offset back to their weight), moved,
  slanted or weighted. A change is kept only when it improves both pages and is larger than noise, so
  the retail font's hinting on one page does not leak into the design. 51 glyphs are corrected:
  capitals a little wider, figures narrower, the apostrophe slanted, the tilde larger, among others.
- Accented letters are a corrected base letter and one of Kosugi's marks. Each mark has one shape for
  both cases and one place per case, so every acute is alike. ì í î ï use a dotless i; the diaeresis
  is two of Kosugi's full stops; the cedilla is a stroke drawn for this font, since Kosugi has none.
- ß is a stem and the bowls of Kosugi's 3, ¡ and ¿ the font's own ! and ? turned over, Æ æ Œ œ two
  letters squeezed together, and the quotes single or paired marks.
- Full-width symbols are fitted on both pages where both draw them; families (the figures, each pair
  of arrows or brackets) share their shape.
- A few letters take a change of design over the retail font (`design`): the top of the t comes down
  to 598 units, and G is a texel wider to the right.
- Letters and punctuation are spaced as HT Letterspacer spaces them (`spacing`): each side's white
  within the letter's zone (the x-height, the cap height, or a mark's own ink), counting openings no
  deeper than 48 units, is topped up to the sidebearing of a straight stem, 80 units. A space is 0.7
  of a cell. Figures and symbols keep the half-width cell.

Against the retail pages the font's mean per-texel coverage error is 0.039 for ASCII on either page,
0.037 for the European page's other letters and 0.026 for full-width symbols; Kosugi as it comes
starts at 0.053. What remains is mostly the retail hinting, which an outline font should not copy.
The tools need `scripts/font/requirements.txt`.

`FontOutline.RimsFadeOutAtTheirMeasuredReach`, `FontOutline.RimIsRoundInLogicalPixels` and
`FontOutline.RimOfAnyRadiusAndItsDistances` cover the rims and the distance field the menu lettering's shadow
fades over.
`FontPort.MapsEveryPalFontPage` and `FontPort.PageGeometryIsTheFittedOne` cover the mapping and the
English page's numbers against `message_font.json`; `FontPort.EveryMappedCharacterIsInTheShippedFont`
renders every character the painter can ask for. `FontPort.SharpLettersTakeTheirOwnWidths` covers the
advances in both modes, and `FontPort.MessageWindowsTakeTheLettersWidths` a window's characters, lines,
bubble, figures and set-width spaces. `FontPortGpu.SharpDrawingKeepsRetailTablesAndDrawsEachStyle` checks
that retail's table builder is unchanged in both modes, that the menus' measure takes the font's
widths, that every outline style draws its shadow copies or its rim on whole pixels, and that a
`dc2::font::SubpixelPen` moves the glyph. `MessageFont.Check` runs `scripts/font/test_message_font.py`: the font's
grid, its letters' widths and coverage, and, with Kosugi in `DC2_KOSUGI` or the cache, that the tools
rebuild it byte for byte.

For a repeatable visual comparison, use `--jump dungeon:0:1 --fast-load --input tools/input/font-dialogue.input
--frames 1050 --screenshot caption.png --screenshot-display 1` with a fresh save folder for each setting.
The floor menu is visible at frame 400 of the same script. Add `--window 1920x1080` or `--window 3840x2160`
to compare presentation captures (`caption-display-0.png`) at those resolutions.

#### Menu lettering

The pause menu's words (Item, Character, Make, Move, Options, Help, ???) are painted into its atlas
(`mnmain`), each in a 112x24-texel cell. With `video.text_font` sharp and English text, `dc2::text::DrawMenuLabel`
(`port/src/text/menu_label.cpp`) draws them in ChronicleTwoMenu instead: the port's `PrimQuad<float>`
(`port/src/menudraw_primquad.cpp`) asks it about every rectangle it draws, and a rectangle of the atlas that is
one of the named cells (`mi_item_ic`, `mi_chr_ic`, `mi_invent_ic`, `mi_move_ic`, `mi_op_ic`, `mi_mn_ic`,
`mi_hatena_ic`, looked up by name in the menu's layout) becomes its word. The font's em is its units over 64
texels; each word's pen starts `start` texels into its cell on a baseline `baseline` rows down, moved by the
word's own offset, all as `scripts/font/menu_font.json` has them. The word is lettered as the atlas paints it:
lit grey (217) on a dark violet rim (29, 24, 34) a texel and a third wide (`dc2::text::OutlineRimOf`), with the rimmed
letters again a texel and a half right and down as their shadow, its opacity falling to 75% as it leaves them
(`dc2::text::OutlineDistance`); all set by eye in the game over the painting's rim of about a texel and a half and its
shadow of a texel and a quarter across. It is composed into one image at the target's resolution and drawn as one quad, so the
menu's colour, fades and its own shadow pass tint it as they tinted the cell. The other languages paint their
words in faces of their own and keep their paintings for now, as does the original text font.

The time board's lettering (menu0.cfg's `timeboard`: Day, Future, AM, PM, the colon and the figures of the day
count and the clock) is drawn the same way in ChronicleTwoBoard, in the board's own style: lit grey (205) with no
rim and a hard dark shadow (10) a texel right and down. Its words are named cells (`日目`, `未来`, `AM`, `PM`,
`::`); its figures are cut one by one from the `時間数` strip by `DrawMenuNumber`, so the port's `PrimQuad<int>`
hands each to `dc2::text::DrawMenuFigure`, which recognises the strip's cell and draws that figure.

ChronicleTwoMenu (`port/assets/fonts/ChronicleTwoMenu-Regular.ttf`, with both source fonts' SIL Open Font
Licenses and a notice of the changes) is built by `scripts/font/build_menu_font.py` from Libre Franklin 3.000
and Jost 3.710 (each fetched once at a pinned google/fonts revision and checked against its SHA-256) and the
numbers in `scripts/font/menu_font.json`; no game data is read, and the build is reproducible byte for byte.
Its units are the atlas's texels at 64 each. The numbers come from `scripts/font/fit_menu_font.py <game-root>`,
which sets each word in its cell as the font would draw it and compares it texel by texel with how lit the
user's own English atlas is between its rim and its fill:

- Of 80 open fonts measured letter by letter, Libre Franklin at weight 500 came nearest. One affine takes it to
  the atlas: 18.06 texels an em, 1.265 times as wide.
- Each painted letter may be scaled across about its middle and up from the baseline (within 4%), slanted,
  moved across, reweighted with its stems kept at their weight, and given its own advance. Letters keep the
  shared baseline: the painting's per-letter steps up and down are its rasterization, which the font should not
  copy. A correction that takes less than 2% of its words' error away is dropped.
- Each word gets an offset of its own (under half a texel), since each was painted on its own; the label painter
  places it there.
- The M is Jost's, whose legs splay as the painting's do; of 26 fonts fitted for it, Jost at weight 500 came
  nearest, a ninth closer than Libre Franklin's.
- Every letter's outer corners are rounded (`rounding`, in each source's units: 40 for Libre Franklin, 70 for
  Jost, whose M's points it blunts): the corner's sides are cut back and joined by a curve through it, so inner
  corners stay sharp and no stroke loses weight.
- The question mark is drawn: a hood, an elliptical arc whose left end hangs into a round drop, a stem sweeping
  down from its right end, and a round dot, each dimension fitted to the painted ones (`QUESTION_KEYS`), then
  given a little more arch at the same height.
- Design over the fit (`warp`: the points inside a region scaled and sheared about a point): the r's hook comes
  down 0.4 texel and reaches half a texel further, the t's tail reaches most of a texel further and turns up at
  its end, and the M stands taller.
- Flared stroke ends (`flare`, off) fit the painting no better than plain ones.

The mean per-texel error against the painted words is 0.018, from 0.099 for Libre Franklin as it comes, before
the design changes.

ChronicleTwoBoard (`scripts/font/board_font.json`, same tools) is fitted the same way to the board's painted
words and to each figure in its own cell. Its words are Yanone Kaffeesatz at weight 400, the nearest of 36
condensed fonts measured; its figures, colon and y are Roboto Condensed's, but its 1 is Sawarabi Gothic's, its 4
Fjalla One's, its 5 Antonio's and its 6 M+ 1p's, each the nearest fitted for it (the painted figures are a
Japanese gothic's), drawn at its own size and width (`sources`), the 4 and 5 brought to the others' weight and
height, and all slanted a little (a shear of 0.06, about 3.5°), the 1 and the 9 more, as the clock's are
(`--keep shear`). Warps give the a a taller bowl
and a shorter top, the P a bowl reaching lower down its stem, the 1 a shorter flag, the 5 a thicker top bar and a bowl
thicker where it leaves the stem, and the 6 a straight, leaning stroke running into its bowl; a `clip` (a box the glyph is cut to) ends the y's tail short. The mean per-texel error is about 0.05, from 0.139 unfitted; the board's thin strokes leave
more of each glyph at its edge than the words' do. `fit_menu_font.py --only` refits just the letters named.

`FontPort.EveryTypefaceLoads`, `MenuLabel.GeometryIsTheFittedOne` and `MenuLabel.OnlyTheAtlasWordsAreLettered`
cover the loading, the placement against both fonts' parameters and the cells lettered; `MenuFont.Check` runs
`scripts/font/test_menu_font.py`: the fonts' characters, units, baselines, the M, the drawn question mark and the
figures' heights, and, with the source fonts in `DC2_FONT_SOURCES` or the cache, that the tools rebuild both byte
for byte. The pause menu is open
at frame 365 of `--jump town:10 --fast-load --input tools/input/jump-town-menu-pcsettings.input`.

#### Title lettering

The language menu at boot and the title menu paint their buttons whole: a bronze-framed plate with its label in
it, 208x52 texels in a 210x54 cell, in `title/lang_select.img` (the five languages, each named in itself) and in
each language's `title%d.img` atlas (`moji`: New Game, Continue, Install, Options and Extras, the Free Race and
Spheda practice buttons of the extras menu, and the Push START line). With `video.text_font` sharp,
`dc2::text::DrawTitleLettering` (`port/src/text/title_lettering.cpp`) draws them for every language: the port's
`PrimQuad(mgCDrawPrim *, float, float, mgRect<int>)` (`port/src/object/menu/menudraw.cpp`), which both menus draw
through, asks it about each cell before writing the sprite. A button becomes a blank plate with its label lettered
in ChronicleTwoTitle; Push START becomes its line lettered alone. The language menu runs inside `SCElogoFade`,
before the game's own fonts, messages and gaiji are loaded, so the lettering draws from the TrueType face
directly.

The blank plate is cut at draw time from the user's own atlas, so no art ships. Every plate of an atlas has the
same frame; the one whose label is shortest in all five languages (Extras on the title atlas, Italiano on the
language atlas) holds no lettering left of column 64, from column 140, above row 12 or from row 36, and its
middle is a flat fill. Its corners and edges are drawn as they are, and column 60 is stretched across the middle
(`TitlePlatePieces`, nine pieces that also draw a plate of any other size, corners kept and edges stretched).
The pieces cut the whole 210x54 cell, the empty texel round the plate included, so the plate's edge texels (the
knob at its foot on the right) lie inside the sprite as retail draws them and filtering does not soften them.
Outside its lettering, that blank matches every painted plate of all five languages to within 0.0003 of full
scale. The Options cell starts a texel into its plate and takes a row of the Extras plate's rim below it; the
blank plate is drawn where the painted plate lies, so its top rim is whole and the stray row is gone.

The buttons were painted in ChronicleTwoMessage's own face, a little narrower, with wider round capitals.
ChronicleTwoTitle (`scripts/font/title_font.json`) is ChronicleTwoMessage fitted to the English title atlas's
seven buttons by the same tools as the menu's (`fit_menu_font.py`, its words `centred` in the plate): an em of 30.8
texels, 0.716 as wide, and its C, O and N a quarter to a third wider, m 31% (its stems thickened back towards the n's) and w 50% wider,
their stems kept at their weight, with smaller corrections to other letters. New Game's letters were then set by
hand on the painting's own edges (w, G and m wider, the G, a and m apart as painted, each edge within a texel),
and the N made 6% taller by eye; the fit lightened the strokes by about a pixel at 1080p, which is halved by eye,
and the w's outer legs splay 40 units further out at the top, their tips 16 units thicker; the r and a set the
next letter 28 and 48 units closer, the m is 23 units wider and as tall as the n, set
apart from the a with the e after it spaced as after the u, and the n's arch peaks a little further left and
leaves its stem at a gentler angle, by eye. The
other languages' plates set the rest: their word spaces are narrower than English's, so the space is 1.25 texels
narrower than the English fit (a texel tighter than English's, a texel wider than the others'); their descenders
reach deeper, so the g, j, q and y reach two texels deeper, while the p's tail, by eye, ends a
little short of ChronicleTwoMessage's; and v, b, B and z, which no English button has,
are fitted to the French, Italian and Spanish plates. An accented letter with no corrections of its own takes its
base letter's (an é is drawn as the e is). Against their own plates, with each word placed where it is painted,
the mean per-texel error is 0.016 for English, 0.031 for French and Italian, 0.038 for Spanish and 0.061 for
German: the other atlases were painted in other cuts (French and Italian bolder, Spanish narrower, German in
another face), so one font matches English's best. The mean per-texel error over the plates' middles is 0.012, from 0.026 for
ChronicleTwoMessage at its measured size. The font holds ASCII and every
accented letter and mark ChronicleTwoMessage has; the source is the port's own font, pinned by its SHA-256, and
the Apache License carries over. The labels are set as painted: ink centred half a texel left of the plate's
middle, on the fitted baseline 33.7 texels below its top lowered by a pixel at 1080p, the language atlas's an eighth wider than the title
atlas's; a label wider than 166 texels is narrowed to fit, as the longest paintings are. They are lit grey (217, 85% white, by eye)
with a fine near-black (13) stroke half a texel wide, and, as the painting's dark lies mostly right of and below
its strokes, that shape's shadow cast a texel and a half right and three quarters of one down, shading off to 65%
as it leaves the letters. The labels' strings are in the port, in each language as its atlas
paints it. Push START is a 13-texel cap, lit grey (217) with a texel's outline cast a texel right and down as
well, centred where the painted lines are on the atlas's row 37. The draw's colour tints all of it, so the buttons' dark
shadow pass, the greyed locked buttons and the fades look as they did. The original text font keeps the
paintings.

The lettering itself (`dc2::text::DrawLettering`, `port/src/text/lettering.cpp`) is shared with the pause menu's: UTF-8 text in a
typeface and style (fill, rim, shadow), rendered at the target's resolution into one cached image and laid on
whole target pixels, from its pen or centred on its ink. `Lettering.ReadsUtf8`,
`TitleLettering.EveryLabelIsInTheTitleFont`, `TitleLettering.PlatePiecesTileThePlate` and
`TitleLettering.OnlyTheTitleCellsAreLettered` cover the decoding, the labels' characters and fit, the blank
plate's pieces and the cells lettered; `MenuFont.Check` checks ChronicleTwoTitle's characters and wider capitals
and that the tools rebuild it byte for byte. The language menu is on screen at frame 500 of a plain start; `--jump
title` with START at frame 500 shows the title menu at frame 640.

`mgInitFont` returns 0 and `mgCloseFont` does nothing. The port keeps no console, because retail never draws it: `font_draw_flag` is never set.

`--frames N` exits after frame N. `--screenshot PATH` writes that frame as a PNG first; a failed write exits with status 1. `--screenshot` without `--frames` is a usage error. `--input SCRIPT` loads the script at start-up. The pump applies it on each tick with `mgPortFrameCount()`, so pad input follows the game's frame count.

Draws are recorded into display lists (see "Ticks and display frames").

Visual faces (`port/src/render/mg_visual.cpp`) keep their triangles on the CPU. `mgCVisualMDT::Draw` batches each stretch of consecutive face groups that share a material and VU microprogram: their faces are concatenated in draw order into one mesh, and the stretch is drawn once for each run of consecutive faces with the same face flags (`MG_FACE_NO_TEXTURE`, `MG_FACE_COLOUR`, `MG_FACE_NO_NORMAL`). Native models give most faces a group of their own, so this cuts Ocean's Roar's scene from about 3,200 to 700 draws. Batches of fixed and motion visuals are uploaded as GPU meshes and released after 1,800 unused frames, keeping their CPU copy for re-upload and for immediate draws when no mesh slot is free. A plain visual's batches stay on the CPU, because its faces are rebuilt every tick. A refreshed face is a new mesh, so a batch built from the old one is rebuilt when it next draws.

### Window aspect

- Logical space stays 512x480 (`mgScreenWidth`/`mgScreenHeight`); `mgScreenOffx`/`mgScreenOffy` are the 2048-centred offsets. Nothing in `port/src` outside `platform/` and `mglib.cpp` reads the window's pixel size. The check `grep -rnE "SDL_GetWindowSize|SDL_GetWindowSizeInPixels|\bWindowSize\(|WindowCurrentMode|DisplayShownMode|SDL_GetCurrentDisplayMode" port/src --include=*.cpp --include=*.hpp | grep -vE "^port/src/(platform/|mglib\.cpp)"` prints nothing.
- `video.aspect` `auto` is `gfx::AspectMode::Fill`. `mgPortEyeToClip` maps retail's projection through the target's logical mapping, so the frame's 480 rows fill the window's height at retail's vertical field of view. A wider window shows more at the sides; a narrower one keeps the width and shows more above and below. `4:3` is `gfx::AspectMode::Letterbox`: it clips every main-target draw and clear to the frame, so the bars stay black. `video.ui_scale` (0.25 to 4) scales depthless 2D about the centre and reaches `gfx::SetFrameLayout`.
- HUD anchoring: `gfx::UiAnchor::Side(x, y, true)` anchors a piece to a frame side, and its third argument moves the piece's scissor with it. The human dungeon status board (`port/src/object/dun/dng_status.cpp`, `DrawStatusBord`) anchors HP/items top-left and both weapons top-right, including numbers, bars, charge icons and warnings. The mini map (`port/src/object/dun/automap.cpp`, `CMiniMapSymbol::Draw`, `DrawSymbolOpen`..`DrawSymbolClose`, `DrawSymbol_Chara`) is anchored top-right and clips to its own rect. DC2 has no town clock HUD. Menus, message windows and help bars stay in the frame.
- Parked menu panels: retail moves unused menu forms just past its 512x480 screen (the item description at x = 570 after the Make menu, the Make menu's invention cards at x = -262, the character page's 513-wide backdrop at x = -512), which a wider or taller window would show at its sides. `CMenuPosDataForm::MenuFormDraw` (`port/src/object/menu/menudraw.cpp`) measures part forms and the invention card list against the screen whenever the window shows past it in either the target's logical units (`mgPortVisibleExtent`, where depth-tested fills draw) or its UI units (`mgPortVisibleUiExtent`, where menu sprites draw at `video.ui_scale`), allowing 2 pixels of overlap. A part form wholly outside it is skipped; one that leaves retail's sliver inside, a part form with a full-screen part and the card list are drawn under `mgPortScreenClipScope`, which clips their 2D draws to the screen without extending the scissor. A message form's window is classified once `StepMsg` has laid it out and `SetPutPos` has put it, in `CDC2Mes::DrawMsg` (`port/src/object/menu/menucls1.cpp`, which wraps retail's draw through the `PortRetailDrawMsg` bridge): `MenuMessageParked` reads every laid-out character's pen from the window's table, so anything that moved the pen while laying out (number padding, spacing codes, indents, lines placed by themselves) is included, and adds the reach of each other draw of `DrawMesWin`: the frame, a floating window's 13-pixel tail, the choice cursor where it is easing to, and placed marks. Only plain, floating and the two other versatile windows put past the screen's right edge park; a window put at a negative position sits at its default place, and message windows never park vertically. A form that overlaps the screen draws whole, so slides still cross the sides, and the 4:3 picture is unchanged (`MglibAspect.MenuForms*`).
- The full-frame rule that fills the flanks samples with clamped wrap, so a repeating texture shows no seam line at the frame's edges.
- Copies of the frame (`mgSetPkMoveImage`: the heat haze in `sceneevent.cpp`, `map.cpp`'s screen, menu grabs) go to frame targets as 1:1 logical copies, so a grab is as wide as the window.
- Culls: `mgPortVisibleExtent()` (`gfx::VisibleLogicalRect` of the current target, in screen units, with centred half extents and GS coordinates) replaces retail's 256/240 half extents in `mgCFrame::GetDrawRect` (`mg_frame_asm.cpp`). It also replaces them in `mgRENDER_INFO::screen_box_min`/`max`, which retail's `SetRenderInfo` sets from the screen size. `mgSetRenderInfo` is overridden to widen them, and `mgBeginFrame` refreshes them every game frame, since the window can change shape between scenes. `mgCFrame::Draw`'s `mgClipBoxW` reads them. A mesh at logical x = -40 is drawn at 16:9 and culled at 4:3 (`MglibAspect.*`). The GS guard band (2048) is unchanged.
- The camera (`DrawTakePhoto`, `port/src/object/character/photo.cpp`) draws its black border, corner arcs and shutter on the edges of `mgPortVisibleUiExtent` and copies all of `mgPortVisibleExtent` from the frame grab into the 64x64 picture. A view wider than 4:3 keeps its shape inside the picture between black bars above and below (a taller one, at the sides), so the album, the idea board and the high-resolution copy show it unsquashed; the shot preview crops the bars and retains the captured crop and shape if the window or aspect setting changes. At 4:3, and with `video.aspect` `4:3`, the camera is retail's.
- The dungeon floor map (`CDngFreeMap::DrawRoot` and `DrawRoomOne`, `port/src/object/dun/dngmenu.cpp`) culls its rooms and passages at `mgPortVisibleUiExtent`, the visible extent in the UI units its 2D is drawn in, so floors in a wide window's flanks, or uncovered by `video.ui_scale` below 1, are drawn. Retail strokes each passage with three 1-pixel GS lines a pixel apart; each is filled as the pixel-wide band the GS covers, so a passage stays one solid stroke above 512x480 (`MglibAspect.FloorMap*`).
- A layout change (`video.aspect`, `video.ui_scale`) is applied from the pump outside a recording, through `mgPortSetFrameLayout`. Letterboxing never draws or clears the bars, so a switch from `auto` to `4:3` first lets two ticks clear the main target outside the frame (one per main image, each also rendering the display image so presentation and display screenshots lose the art too) and then switches; otherwise the bars keep the last Fill frame's art (`MglibPresent.LetterboxSwitchClearsWhatFillDrewBesideTheFrame`).
- `--window WxH` sets the window size (headless: the offscreen image's).
- Config keys: `video.interpolation` (`true`), `video.max_fps` (`0`), `video.vsync` (`true`), `video.aspect` (`auto` or `4:3`), `video.ui_scale` (`1`), `video.show_fps`, `video.fps_detail`.

## Character motion

Characters play their motions as named glTF actions (see [model format](PORT_MODEL_FORMAT.md#named-actions)). The loader gives each action of a character its own interval of game frames and hands the game's `KEY` records those intervals under the original motion names, so `CCharacter2::Step`, `SetMotion`, the `KEY`/`SE`/`SELP` handlers and every caller of them run unchanged. `SetMotionTime` and `ChangeMotion` (`port/src/platform/gameutil.cpp`) pose the action whose interval holds the frame through `character_motion` (`port/src/character_motion.cpp`). `CreateAnimeDataEX` reports retail motion data as unsupported; native profiles never reach it. Event and extension motions take their actions from the bundle of the model the character was built from, where the exporter published them.

A model bundle holds every action its characters play, including event and extension motions, so the main characters' bundles reach tens of megabytes. The game reads a model file into its own buffer only to hand that buffer to a model loader, which finds the glTF by the buffer's registered name and reads it from the data itself; nothing reads the glTF bytes from the game's buffer. `dataread` therefore no longer copies a `.gltf` into that buffer: the file occupies one zeroed sector there, and its reported size is that sector, so game buffers and size-based allocations stay small however large the bundle is.

A character's actions also keep their keys out of the game's arenas: each glTF channel takes one motion-list record in the arena the game sized for its retail motion, and the native evaluator samples the keys from the loaded glTF document. Copying every action's keys there, with each action's own boundary keys, overflowed Max's dungeon budget of 68,500 quadwords.

These differ from retail:

- A blend between actions of different motion sets starts from the action last posed. Retail samples the new motion set at the previous action's frame number, which belongs to another motion.
- During a blend between two different actions, auxiliary material, visibility, camera and vertex keys of the new action apply unblended. Retail blends a key list with itself.
- Frame arithmetic runs on the actions' own intervals rather than on the retail motion frames, so float rounding of the frame step can differ in the last bit; with intervals of a few hundred frames it is no coarser than retail's.
- The retail `KEY` `横飛びL` in `event/e00/e50/e50_monica.chr` ends before it starts; it plays as a still pose at its start, as retail does unless the motion is held.

A game model's frame holds its whole authored transform in its matrix with unit scale, so a scale set by gameplay or a script (`_SET_SCALE`, `_EOH_SET_SCALE`, `_OBJS_SET_SCALE`, `_CHR_SET_SCALE`, a monster's `_SET_SCALE`) keeps the retail order: after the frame's rotation, in the parent's axes. Only a frame whose node an animation scales to a value other than one composes rotation before scale, as glTF does, because its rebaked keys are in that order (see [the model format](PORT_MODEL_FORMAT.md#native-runtime)); while such a clip plays its scale keys overwrite the frame's scale, as retail's did. Replacement and third-party glTFs use glTF's order on every node. `CopyFrame` keeps a frame's convention through a retail bridge.

## Audio

The sound driver runs on Kazarov's shared audio stack. `CSound` in `port/src/audio/sound.cpp`, with `snd_mngr.cpp`, `ezmidi.cpp` and `ezbgm.cpp`, plays through `audio::DefaultMixer()` (`tools/kazarov/include/audio/mixer.hpp`). The port has no IOP, no SIF RPC and no SPU2 path. The mixer's 48-voice synth stands in for the SPU2.

`AudioInit(bool headless)` and `AudioShutdown()` (`port/src/audio_init.cpp`) own mixer advancement and output. Interactive runs use the playback device callback. Headless runs without WAV capture register a logic-clock pump hook that renders the full mixer using cumulative sample budgets, including fractional samples and tick-rate changes. Voice levels, synth state and stream completion therefore follow game ticks. `DC2_AUDIO=off` suppresses playback but retains headless audio state.

With `DC2_AUDIO_WAV`, the existing platform WAV capture owns tick-driven mixer rendering; the headless hook is not installed, so samples are not advanced twice. Shutdown removes the hook and stops the output. See [Headless replay timing](port/headless-replays.md).

### Banks and sequences

`sndLoadSound` (`port/src/audio/snd_mngr.cpp`) loads the actual `.sound.json`
bundle through `SoundLoadBundlePath` or its bounded-byte equivalent. Its bank,
sequence and control documents reference their actual native files.
`audio::Bank::CreateFromJsonCandidates` loads bank JSON and PCM WAV samples
through datapack priority; `audio::SqFile::CreateFromJson` loads normalized
musical events. Other game configurations are native semantic documents that their loaders read directly into the game's tables ([native configurations](NATIVE_CONFIGS.md)).
See [published audio resources](PORT_AUDIO_FORMAT.md) and
[native configuration assets](PORT_CONFIG_FORMAT.md).

The retail `CSound::LoadHdBd`, `LoadHdBd2`, `LoadHdBdAdd`, `LoadSeq` and `TransHdBd` take addresses in `int`. The port overrides them to refuse and print a line to stderr. The port does not round-trip 32-bit pointers.

The extractor decodes retail HD/BD samples and SQ events once. A port holds up
to 16 converted banks (`MIDI_PORT_BANK_MAX`). Bank 0 is bound with
`Mixer::BindBank(port, bank)`. Added banks use `BindBank(port, n, bank)`, and a
channel selects one with the bank-select controller that the SE calls send.
The port layout (linked ports, dependent ports and `ezmidi_param` attributes)
is the table that retail `CSound::Init` loads, kept in `sound.cpp` as `kLayout`.
`TransBdState` always reports the transfer complete.

### Sound effects

`SE_Play`, `SE_SetVol`, `SE_SetPan`, `SE_Stop` and `SE_SetPitch` queue the same short and HS messages that retail queued for `libmodmsin`. `CSound::Step` delivers them through `Mixer::ShortMessage` and `Mixer::HsMessage`. The HS pitch message (`FD 02`, 14-bit, centre `0x2000`) bends the effect voice over its split's bend range.

Retail `SE_Play` builds a pitch message and overwrites it before sending. The port sends no pitch message at all.

### Master volume and reverb

`SetMasterVol(core, volume)` clamps `volume` to 0 to `0x3FFF` and sets the core's gain through `Mixer::SetCoreVolume`. `SetReverb` and `set_spu` go through `Mixer::SetReverb`. Retail also resets the core's master volume to full there, and the port does the same. `SndInReverb` has nothing to switch, because stream channels do not enter the effect units.

`sndWaitSema` and `sndSignalSema` are empty. The game's threads are fibers on one OS thread, and nothing in those sections yields (see "Threads and timing").

### Streams

`ezBgm` drives 16 `audio::StreamChannel`s, attached to the mixer on first use.
An open reads the explicitly named PCM WAV under `sound/` through datapack
priority. Voice packs (`StreamOpenFromFPLFast`) still fail because those files
are not on the PAL disc. Opens are synchronous, so `StreamOpenState` is always
0. [Published audio resources](PORT_AUDIO_FORMAT.md) describes the WAV paths.

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

A non-zero low nibble in the mode turns looping on. A looping stream restarts
at the start of its decoded PCM track.

The level is the raw 16-bit sample pair at the play position, left in the low half and right in the high half. `_STREAM_SILENT_CHECK` (`ps2/src/event_func.cpp`) reads it and treats both halves within 10 of zero as silent.

When neither a device nor the headless tick mixer owns playback, `CSound::Step` advances stream state through `EzBgmStep`. With tick-driven headless mixing active, that fallback does not advance channels again.

### ezMidi

The retail `CSound::Stop`, `SetVol`, `SetStereoMode` and the stream methods other than the open calls stay as they are. `StreamOpenFast`, `StreamOpenFromFPLFast` (`port/src/audio/sound.cpp`) and `StreamOpenState` (`port/src/audio/ezbgm.cpp`) are replaced. `ezMidi` serves the scalar commands: `0x00` play, `0x20` stop, `0x30` rewind, `0xA0` attribute, `0xB0` volume, `0xC0` stereo (1) or mono (0), `0x8090` is playing and `0x80E0` volume. The commands that carry addresses have no host equivalent. `ezMidi` traces them and returns 0.

### Open

The title is reached headless. Earlier PAL-rate validation with `DC2_AUDIO_WAV`
captured 48 kHz stereo: silent through the language select, then the logo and
title music (RMS about 750 at the title, peaks near 24,000). The capture is
closed cleanly on a `--frames` exit: `main` registers `AudioShutdown` with
`atexit`, so the output stops before the mixer's statics are destroyed. The
real-data `SoundRealData.*` tests (`port/src/tests/sound_test.cpp`) exercise
converted banks, sequences, and stream WAVs through the driver.

`sndCSeSeqData::LoadSMF` (`ps2/src/snd_seseq.cpp`) adds the SMF header size to a `uptr`.

## Movies

`port/src/video/movie.cpp` overrides `CMovie::Load` (the seven-argument overload; the other two forward to it), `Play`, `SwitchThread`, `Term`, `EndCheck` and `IsStarted`. Nothing else reaches the retail player, so its three threads, the VBlank and DMAC channel 2 handlers, the IPU and DMAC channel 3/4 register writes, `setImageTag`'s GIF chains and the IOP transfers have no caller and are dropped by `--gc-sections`, and so are the `libmpeg` stubs. One movie plays at a time, as the retail file-scope statics did.

`MoviePortPath` normalizes the actual MP4 path by removing device prefixes,
leading separators and ISO version suffixes, and folding case. For example,
the native logo reference is `movie/l5logo.mp4`. Datapacks may replace that file.
A missing or unplayable MP4 logs a diagnostic; `IsStarted` still returns 1 so
callers' busy-waits end, and `EndCheck` returns 1 at once. The PAL disc holds
the Help menu's 44 movies in `MOVIE/TUTO` and `MOVIE/TUTO2`, published as
`movie/tuto/vtuto1.mp4` through `movie/tuto/vtuto22.mp4` and
`movie/tuto2/vtuto23.mp4` through `movie/tuto2/vtuto44.mp4`. An extraction
without them fades each Help movie entry to black and straight back to the list;
see [Game data and first run](#game-data-and-first-run) to re-extract.

The pipeline is in `port/src/video/`. Extraction copies the retail MPEG-2
video into a standard MP4 container and converts the synchronized private
movie audio to embedded ALAC. Runtime `MoviePlayer` uses FFmpeg to demux and
decode both tracks. Video frames carry 90 kHz presentation times, with frame
duration used when a picture has no timestamp. `yuv.*` converts YUV 4:2:0 to
RGBA where applicable; other decoded pixel formats use libswscale. Embedded
audio becomes a stereo PCM track for the shared mixer. The original PSS
container and a separate movie WAV are not needed at runtime.

The five `menu/1..5/help.cfg` files use a movie subtitle dialect. Extraction
publishes each as a directly named `help.json` document of kind `movie_subtitles`:
chapters have an `id` and ordered entries with `start_seconds`,
`clear_seconds` and readable `text`. `MovieCCAnalyze` decodes the actual JSON bytes, selects the chapter from its numeric argument,
converts the times to the game's 30 Hz subtitle timeline, and fills the
existing caption slots. A datapack can replace the actual JSON file;
an invalid replacement falls back to a valid lower-priority document. See
[native configuration assets](PORT_CONFIG_FORMAT.md).

The retail movie threads are not used. The game calls `SwitchThread` once per game frame and `EndCheck` beside it; both advance the player to the movie time elapsed since `Play`: host time on the real-time clock, `(ClockTickCount() - tick at Play) * 90000 / ClockTickRate()` on the unbounded one. The newest picture whose PTS is due is shown; pictures overtaken after a stall are decoded but not converted. At the fixed 60 Hz tick with `mgFrameRate` 2, a 25 fps movie keeps its cadence across 30 game frames per second; headless runs on the unbounded clock are deterministic.

The picture is uploaded into the texture the game names in `Play` (`"moviework"`), found with `mgTexManager.GetTexture(name, -1)` and `mgPortFindTexture`, with `gfx::UpdateTexture` (recorded into the tick's display list when one is open). That is what the PS2 did: `setImageTag` uploaded into the same texture and the game draws it itself as a 2D quad (the copyright screen's `L5LOGO.PSS`, `RUSH.PSS`, the movie viewer, the event script's `_LOAD_MOVIE`, the manual), so its fades, stretch and letterbox stay the game's, tick-exact.

The soundtrack and real-time movie clock start at `Play`. `Load` decodes the whole audio track before playback, so loading time does not advance the movie clock. Pictures are presented when the game's next movie pump observes that their timestamps are due.

A packet or picture the decoder rejects as invalid is skipped (`movie: skipping an undecodable picture`, once a movie) and the next good picture replaces it; more than 250 in a row with no picture decoded stop the pictures. Any other failure (reading the file, decoding, a picture's size or conversion) ends the pictures at the last one shown and logs `movie: STAGE stopped the pictures after N (error)`. If the pictures stall while the game keeps pumping the movie, `EndCheck` ends it once its clock is 2 s (`kMoviePortOverrun`) past a known container duration, logging `movie: NAME still has pictures to show ...`; a container without a duration gets no such bound.

There is no deinterlacing; fields are woven, as the IPU output them.
`L5LOGO.PSS` codes all 150 pictures with `progressive_frame = 0`, every other
disc movie with 1. Measured on the luma of the first 1,500 pictures of each
of the nine movies, the mean difference between adjacent lines (opposite
fields) is at most 0.83 of that between lines two apart (the same field) on
`L5LOGO.PSS` and at most 1.008 anywhere: there is no comb, so a blend would
only blur.

See [published audio resources](PORT_AUDIO_FORMAT.md). `Load` opens the actual
MP4 path through datapack priority. If requested, `Play` hands its decoded audio to the shared
mixer as an `audio::PcmTrack` with `Mixer::SetStream` on port 5 at full port
volume (`kMoviePortAudioPort`: `GetCSndPortNo` never maps a game port there).
`Term` stops and clears it. `init_sound` (which reset the PS2 sound driver)
and the memory pools are ignored: the host allocates.

`Load`'s width and height are the retail picture size, 512x416 for every
caller. A picture of exactly 1, 2 or 4 times that size is shown as decoded; any
other size is converted to RGBA and resampled with libswscale (area averaging
when either side shrinks, bicubic when both grow) to the largest of those it
covers, or to 512x416 when it covers none, and `Load` logs one `movie:` line
naming both sizes. A 2x or 4x picture is uploaded whole:
`MgTextureSetPhysicalScale` gives the movie texture 2 or 4 host texels per
retail texel, so the game's quad, which keeps its retail texel coordinates,
shows the whole picture over the original screen area. Changing a texture's
physical scale rebuilds its image, blank, at the new size on its next lookup.
A stream larger than the retail size decodes on FFmpeg's threads (one per core,
up to 8); conversion and upload stay on the main thread. A 4x picture is 13 MB
of RGBA and a 16 MB texture, so 2x is the size to prefer. On Linux and macOS
the minimal kz-ffmpeg build decodes only MPEG-2 and H.264 video (and ALAC, AAC
and PCM audio), so a replacement must use one of those to play everywhere.

The game links FFmpeg's libavformat, libavcodec, libavutil, libswscale and
libswresample (`port/cmake/movies.cmake`). `movie_test` covers MP4 path
mapping, the embedded-audio fixture, clocked playback, picture fitting, threaded
decoding, 2x and 4x replacements drawn through the movie texture, and the `CMovie` glue;
retail `L5LOGO` cases use the converted MP4 when available.

## Layout

The root CMake build selects the platform: PS2 builds ps2/, and PC enables testing and builds port/.

- ps2/src and ps2/include remain the matching PS2 source tree. The PC build does not compile or include files from either directory.
- port/src and port/include contain the PC game's source, declarations, host integration, UI, and tests. Domain directories sit directly below these roots, including object/dun, object/menu, render, audio, platform, script, and video. port/src/main.cpp starts the host process; port/assets contains bundled glyphs and icons.
- tools/kazarov is the shared-code submodule. Its renderer, audio, platform, SDK replacements, and tests are linked by the native port.

port/CMakeLists.txt compiles tracked native files directly. It does not generate a mirror of ps2/include, copy ps2/src into the build directory, or select function definitions by PORT_OVERRIDE tags. The active architecture guard, scripts/port/native_architecture.py, checks native source, headers, and the compilation database for PS2 inputs, override macros, and old suffixed replacement files. NativeArchitecture.Check runs it through CTest.

### The shared-code pin

The tools/kazarov gitlink records the shared renderer, platform, input and mixer dependency. Read its exact revision with git ls-tree HEAD tools/kazarov; the checkout must use that revision. Changes to shared code land in the submodule and are pinned in this repository only after both consumers have been checked.

## Native game code

Each game translation unit is owned by the port. Native implementations and retained game behavior are together in the same source file, so the linker has one definition of each function. Game declarations and PC support headers share port/include, grouped by responsibility. Decompilation matching remains confined to ps2/; native C++ can use host ownership and string types without changing retail layouts that are serialized or shared with the renderer.

Some retained game routines still call named PortRetail helpers when a PC behavior wraps the original body. Those bodies are tracked source rather than generated copies. Configuration bridges and a few retail link-name aliases remain where native code still uses file-local game state. They should be simplified as each caller is modernized.

The build still defines PORT for SDK and host selection and uses explicit native compatibility flags for retained game code. These are independent from the retired override and source-copy pipeline. The PS2 source tree is not changed by native fixes.

## Windows link

The executable is position independent and can use addresses above 4 GiB. Windows retains lld's multiple-definition tolerance for remaining retail-origin inline definitions; these should be resolved at their declaration sites. Windows arguments arrive as UTF-16 and are converted to UTF-8 by the host entry point. The native u_long compatibility spelling is 64-bit where game data requires it.

## Hardware audit

The native renderer submits through Kazarov's graphics API. Source-level PS2 packet and DMA paths are removed when call-site and linked-symbol checks show they are unused; host movie playback likewise replaces the retail MPEG and IPU reader. Inspect the tracked port/src tree for hardware register accesses rather than an obsolete generated source copy. scripts/port/stub_inventory.py reports remaining unimplemented game and SDK calls; source counts alone do not establish reachability.

## Pointers and 32-bit integers

Pointers are 64-bit on PC, and the arenas lie above 4 GiB (see "Arenas"). An address kept in a 32-bit integer is truncated. `scripts/port/truncations.py` audits the native compile inputs and writes the per-site table in `docs/port/truncations.md`.

### The types

`port/include/types.h` defines `uptr` and `sptr` from Kazarov's native pointer-width aliases, and `s8`, `u8`, `s16`, `u16`, `s32`, and `u32` from standard fixed-width types. Serialized records keep their explicit on-disc widths.

### The policy

`uptr` replaces every cast of a pointer to `int`, `u_int`, `s32`, `u32` or `long`, and every local, global, non-record field and return type that carries an address.

`sptr` is used only where the integer is compared with `<`, `>`, `<=` or `>=`, shifted right, divided or reduced modulo, converted to `float` or `double`, widened into a 64-bit `long` or `u_long`, or stored in a signed field and so used. It is used only where the original type was signed. An original unsigned type becomes `uptr` everywhere.

Native function parameters can use types that express their actual values; retained game ABI boundaries require matching declarations. Declarations that already carry pointers remain pointers. Pointer arithmetic is not rewritten as integer arithmetic.

### Records

Structs read from a file in place keep their 32-bit offsets and never take `uptr`. The inventory is `docs/port/records.md`: 598 structs with a `STATIC_ASSERT`, of which 65 are records and 533 are runtime. 57 records keep the disc layout and carry `PORT_RECORD_ASSERT`; `DATA_HEADER` is PS2 only (the host index replaces DATA.HD4); the seven save-image structs that hold `USER_PICTURE_INFO::image` are host layout on PC, sized by sizeof in memcard.cpp. `scripts/port/records.py` checks the table, the asserts, the host sizes and that no asserted record has a pointer member (ctest `Records.Check`).

`funcdata::name` in the native `runscript.hpp` is a 32-bit disc field, even though retail declared it as a pointer. The script compiler writes zero there and the game never resolves it; keeping the field at four bytes preserves the offsets of `local` and `arg`.

`PORT_RECORD_ASSERT(expr)` in the native declarations is a `static_assert` on PC. The PS2 source retains its own record declarations and assertions unchanged.

### Strides and allocations

Native source uses sizeof and typed indexing for runtime pointer arrays and arena objects. The rendering manager, texture manager, sound loaders, and script stacks have explicit native allocation sizes. Tests cover representative arena placement, character memory budgets, texture animation, password groups, and script argument storage.

### The check

Run scripts/port/truncations.py with --build pointing to a configured native build and --check to compare docs/port/truncations.md. The checker reads compile_commands.json, classifies narrowing conversions, and reports linked native inputs. Truncations.Check runs the same audit in CTest when libclang is available. Uptr tests check native width and address round trips above 4 GiB.

## Memory safety

On PC, script strings have no length cap, and datapacks can replace any script. The fixed-size fields and tables that retail fills from script, save and player data are therefore replaced or guarded. [The memory safety audit](port/memory_safety.md) lists every site: replaced, guarded and still open.

- `port/src/text/bounded.hpp` reads and writes the game's terminated text fields bounded by their size, without splitting a Shift-JIS character.
- `RunArguments` and `TagArguments` carry checked slot extents, kinds, text provenance, and writable outputs. Script and configuration dispatch reject malformed invocation data. Retained text has an explicit owning copy or a checked allocation lease.
- The native effect-script parser stages owned emitters and publishes checked host-sized objects; reset and unlink paths retire associated script state before releasing its arena storage.
- The binary script reader (`GetArgBin`, `SearchCommand`) stays inside the script and the 64-slot argument stack.
- Item names, photo and memo titles, the Sphida score name, the treasure and item tables, `MotionProc2`'s deform buffer, the effect-list names and `GetCurrentDir` are bounded native replacements.

`port/src/tests/memory_safety_test.cpp` covers these.

## Keeping the PS2 build matching

Every retail source edit requires the complete PAL byte-identity check. This migration makes no edits to `ps2/`; native changes live in tracked files under `port/`. Earlier retail source edits relative to the native-port baseline covered these ten files:

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

The PS2 tree retains its original inline constructor spelling. Native declarations can choose a separate standard C++ spelling without changing the PS2 build. Every subsequent retail source edit requires a fresh check of the integrated PS2 tree; native tests do not qualify that tree.

Existing base-build accommodations also remain: declaration order in `mg_tanime.hpp`; split initializations and switch scopes in menu/edit/title/message units; the named fishing union; enum casts in inventory and texture-animation arithmetic; `u_long` spelling in memory-card and TEX0 calls; target-width address types; and assembly guards. SDK prototypes under `ps2/include/sce` retain the game's transcriptions, with shared implementations adapting to the included prototypes. Disc records keep their 32-bit layout.

Retail's matching behavior remains in `ps2/src`. Native code expresses its own initial values and returns directly. The native game target still has `-fwrapv`, `-ftrivial-auto-var-init=zero`, and `-fno-strict-aliasing`; removing these requires the explicit arithmetic, initialization, and aliasing evidence described in the [memory safety ledger](port/memory_safety.md). These flags are open work, not proof that the modernization is complete.

Configure `-DCT_PAL_TIMING_BASE=<ref>` to register `PalTiming.Ps2Identity`.
An unavailable supplied baseline fails the test; with no supplied baseline the
test is not registered. Linux CI requires a baseline: pull requests use their
base SHA, pushes with a nonzero `before` use that SHA, and new-ref pushes or
manual dispatches use the merge-base of HEAD with the explicitly fetched default
branch. CI fails clearly if it cannot establish that baseline.

The check lexes complete base and head PS2 source files once, retaining comment
and string context and mapping executable calls to line ranges. A diff hunk is checked
only if the multiset of executable `PAL_TIMING(pal, ntsc)` call texts differs
between its old and new sides, including removed or modified wrappers. Such a
wrapper's statement must restore to the baseline tokens at that position after
selecting the PAL arms and removing the timing include; spacing between tokens
and comments are ignored. Unrelated statements may change in the same hunk.
Unchanged calls allow later variable renames and other edits. A wrapper must
wrap existing PAL tokens; newly added wrapper lines in existing files are
rejected. New PS2 code is verified by the PS2 build. New files have no baseline and
are skipped with a note. The selector header itself is excluded.
`PalTiming.IdentitySelfTest` exercises those rules without external history.
`PalTiming.Sites` checks paths, enclosing functions and ordered pairs against
the committed `scripts/port/pal_timing_sites.txt`; only an explicit
`pal_timing_sites.py --regenerate` updates it, and CTest never regenerates it.
These source checks complement `ps2-pal` and `verify.py`, which remain the
authority for PS2 byte matching.

### Checking the PS2 build

After any edit to `ps2/`, run `./build.sh ps2-pal`, then `BUILD_DIR=build/pal python3 scripts/build/verify.py -c`. The check must pass. The 22 `#ifndef PORT` guards are part of the same tree and are checked the same way.

## Presentation matrix

`scripts/port/matrix.py` compares logical-frame PSNR across resolutions, plain and `--display-per-tick 4` identity, and letterbox geometry. Below-35 dB PSNR is advisory unless `--psnr-gate` is supplied; run failures, display-per-tick pixel differences and letterbox failures are hard failures. Side bars must be exactly black. The letterbox frame may differ from Fill at the frame's size by at most two colour values on at most 0.05% of pixels. There are no HUD probe claims.

Each fresh run writes `config.json` beside its `save/` directory, where the game reads it, explicitly disables debug, and removes `DC2_JUMP`, `DC2_GIVE` and `DC2_FAST_LOAD` from the launch environment. It records the exact process exit status, duration, binary/input hashes, launch config hash, saved config hash, frame count, window, aspect, data path, explicit launch arguments and display-per-tick mode in `result.json`. `--no-run` requires matching identities and retains a failed or timed-out status even when a PNG exists. Changing extracted data in place is outside this provenance check; use the same verified extraction for comparisons. `Matrix.Title` captures the visible title before its scripted Start press; `Matrix.Costume` starts at the title, selects New Game and captures the Select Costume menu. Both carry `matrix;gpu` labels. `Matrix.Runner` checks the runner synthetically without game data or a device.
