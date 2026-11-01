# Nintendo Switch

The native port builds as a libnx homebrew application with Mesa NVK Vulkan. Kazarov owns the shared Switch runtime, Mesa/SDL toolchain, dependency patches and development-unit test harness. Chronicle and ChronicleTwo use the same implementation.

## Build and install

Run `./build.sh switch` with Docker available from Linux or WSL. The first build creates the pinned toolchain image; later builds reuse it. Game compilation defaults to four workers; `JOBS` overrides that limit, including the host bytecode compiler. `KZ_SWITCH_IMAGE` can select an existing compatible development image. The output is `port/build/switch/darkchronicle.nro`.

Extract current game data with the desktop `dc2data` tool. Copy these files to `sdmc:/switch/chronicletwo/`:

- `darkchronicle.nro` from `port/build/switch/`
- `scripts/`, `glyphs/` and `fonts/` from the same build directory
- `data.zip` and `data.json` from the current extraction

Keep disc-derived data outside Git. The runtime accepts the current ZIP64/Zstandard data archive directly; an extracted `data/` tree also works. `data.json` must match the data version expected by the executable. The Switch does not extract disc images itself.

Launch with Homebrew Menu title override to give the game application memory. Put whitespace-separated game arguments in `args.txt` beside the NRO. Embedded `romfs:/args.txt` takes precedence during SDK testing. `--env NAME=VALUE` entries set diagnostics before startup. Runtime logs, `saves/`, settings and the Vulkan pipeline cache live beside the application. Existing `--run-dir`, `--data` and `--save` arguments can override those paths.

`tools/kazarov/tools/switch/run.sh` sends an existing NRO with nxlink; set `SWITCH_NRO`, `SWITCH_INSTALL_PATH` and, if needed, `SWITCH_ADDRESS`.

The `Switch` workflow (`.github/workflows/switch.yml`) runs this build on pushes to `master`, pull requests and manual dispatches, and uploads `darkchronicle.nro` and its ELF.

## Runtime

Mesa NVK is built from the same pinned Mesa 26.2.4 Switch backend used by Chronicle. SDL creates a Vulkan surface and the statically linked driver presents its scanout images without a CPU framebuffer copy. Shaders are compiled to SPIR-V on the build host; NVK creates device pipelines at startup and compatible later launches reuse `saves/pipeline_cache.bin`.

Handheld output targets 1280 × 720 and docked output targets 1920 × 1080. The main raster matches the output: handheld renders 1280 × 720 and docked renders 1920 × 1080 color and depth images, and the FPS counter is drawn on whole output pixels. Shared-depth outline targets follow that raster; independent auxiliary targets use a render scale of output height over 480. `--env KZ_MAIN_HEIGHT_LIMIT=<lines>` caps the main raster for comparisons (480 gives 848 × 477), with the presentation blit scaling the result to the output. Output fills the display and has a 60 FPS presentation cap. Game modes retain their authored simulation cadence: town frames span two 60 Hz fields, while title frames span one. Interpolation smooths the intervening display frames without speeding up gameplay. The settings page omits these fixed display controls. Actual presentation rates depend on the scene and GPU budget.

Modes already producing one game frame per field present their canonical image directly. Eligible two-field frames present at most one interpolated sample followed by the authored canonical endpoint. Renderer lifetime, allocation generation and render-commit tokens identify that endpoint; stale images are discarded before a newer canonical render overwrites them. Mouse-camera changes, pointer replacement, pause captures, cuts and incompatible transitions retain the replay fallback. `--env DC2_SWITCH_CANONICAL_ENDPOINTS=0` disables this policy for matched measurements. Host overlays use output-pixel mapping so their physical size is independent of the internal raster. Game readbacks report the actual internal dimensions.

V-Sync is always on: the swapchain presents in FIFO order and the settings page has no V-Sync row. The 60 FPS cap keeps a display that starts within half a period of its slot on that slot, so wake-up lateness never builds up into a skipped tick. An authored frame's intermediate image interpolates exactly halfway between its endpoints, the field it is shown on, however long its render waited for the GPU. The canonical render of a tick is queued for the render thread after the tick's lease, and runs while the game thread starts the next tick; work that render thread queues opens no frame for the game thread, so the next tick always records. Mesh batches first drawn in a tick reach the GPU under that tick's lease, where the uploads run without waiting for the render thread.

Luau scripts are precompiled on the build host and interpreted on the console. Guarded game memory, cooperative fibers, process-core affinity, arguments, logging and missing-data instructions use Kazarov's shared libnx platform layer. Texture decoding retains the existing stamp-aware cache and prefetch behavior, with a 64 MiB decoded-pixel cache and at most two prefetch workers on Switch.

Asynchronous rendering gives the game and render threads a core each. With three application cores they both leave the main thread's starting core, which the audio, decoding and loader threads share; with two, the game thread keeps it. Use `--env KZ_SWITCH_CORE_AFFINITY=auto` in `args.txt` to compare libnx's normal scheduling. The log records the selected policy and verified core masks.

## Performance and validation

The comparison against Chronicle separates existing facilities from transferred changes:

| Area | ChronicleTwo action |
| --- | --- |
| Source-file lookup | Retain its existing folded-name hash index; Chronicle's catalog-scan replacement would duplicate it. |
| Parsed models and textures | Retain parsed glTF documents, texture-set/candidate caches and stamp-aware decoded textures; an additional raw-PNG cache would retain redundant data. |
| Archive prefixes and directories | Retain the persistent prefix stream and cached directory listings. |
| Pose and mesh submission | Retain existing camera/pose rebasing, separate bone palettes, storage-buffer records, strip/display-list rewrites, upload reuse and descriptor-binding reuse. |
| Display-list and mesh optimizations | Integrate shared commit `4db28dd`: owned recording arenas, conservative opaque-alpha and near-fog specialization, combined depth planes, reciprocal near-fog calculation and inline dispatch. Enable accepted Switch paths; keep their fallback behavior. |
| Pipeline startup | Integrate shared commit `e7ebfc0`: reuse compatible untextured pipelines and avoid rewriting an unchanged warm pipeline cache. |
| Console diagnostics | Transfer the bounded 4 MiB asynchronous file writer and SDK system logging to Kazarov. |
| Native archive runtime | Add one bulk central-directory index with lazy local-header checks, ZIP64 counts, stored/deflate/Zstandard decoding and decompressed-size/CRC verification. |
| Arena lifetime lookup | Find exact monotonic lease/resource identities with binary search; validate only the requested metadata on acquisition. Reset/free/shrink still prune retired metadata, preserving allocation, generation and dependency checks. |
| Outline presentation | Omit only unobserved intermediate edge-alpha writes when the following full-area body restores them. Kazarov can then discard exact zero-alpha RGB-only source-over fragments; tiny positive alpha, depth/stencil effects and unsupported masks retain their original behavior. |
| Switch texture retention | Bound decoded pixels to 64 MiB and prefetch workers to two; desktop defaults remain unchanged. |
| Chronicle game-specific changes | Exclude its shadow clipping, MDT construction and haze adjustments from ChronicleTwo's different native game implementation. |
| Rejected experiments | Keep fused 2D and approximate shader variants disabled. |

Opaque-alpha and near-fog shortcuts retain their plain-mesh eligibility checks. ChronicleTwo's Prog0 lighting and alpha semantics use the general path; enabling these shared flags does not establish a performance gain for ordinary Prog0 visuals. Its blur strips also differ from the shared depth-plane API and retain their existing implementation.

Native host validation covers stored/deflate/Zstandard streams, empty compressed files, UTF-8 names, 65,536-entry ZIP64 fixtures and malformed/CRC failures. A current 89,750-entry, 3.78 GB data archive was indexed and 21 selected assets matched independent decoding; the largest 179 MB asset also passed native CRC validation. Through the Windows/WSL bind mount, bulk indexing took 66–141 ms, compared with 130,840 ms for the initial seek-per-entry implementation. These are host/storage measurements and do not establish console loading times or frame rates.

SDK development-unit checks on 2026-10-31 confirmed Mesa NVK on Tegra X1 at the stock handheld configuration, with 1280 × 720 output. Before enabling interpolated presentation, the title sustained approximately 59.9–60.3 presented frames per second; Palm Brinks presented approximately 30, matching its two-field cadence, while a dungeon with its tutorial overlay presented approximately 24–25. Enabling the existing interpolation path alone reduced Palm Brinks presentation to approximately 18 FPS: a 60 FPS cap does not establish sustained 60 FPS. The overlay's `TICK` value measures the base field clock rather than separate game updates. A 180-frame bounded run wrote its screenshot and completed normal process shutdown successfully. With matching FFmpeg 9 headers and libraries, the RUSH attract movie decoded and displayed correctly at approximately 54–59 presented frames per second.

Subsequent host checks passed 91 memory/native-record tests, including 768 retained metadata identities with an interior heap-block retirement. The outline optimization passed seven focused RTX checks, including full RGBA and later destination-alpha comparisons, sub-GS-unit bilinear alpha, depth/stencil side effects, pipeline caching and presentation replacements. The capped-raster/token batch passed 18 separate pacing, image-lifetime and native presentation checks. These are distinct checkpoints, not a full-suite result. Final shared archive and dynamic-exit regression runs also passed; the Chronicle consumer linked against the same shared runtime and renderer.

On the SDK device, samples grouped by reported 460 and 512 draw counts showed approximately 6–7% presentation improvement from the sparse outline shader. The 460-draw median changed from approximately 18.0 to 19.2 FPS; the 512-draw median changed from approximately 13.2 to 14.0. Matching draw count is not an exact scene replay, and this change alone does not reach 60 FPS. The main-raster cap and canonical-endpoint policy require their own device measurements.

The first pipeline initialization created 21,845 pipelines in 57.46 seconds; a compatible warm cache reduced initialization to 1.21 seconds. Creation remains eager across five vertex families, 52 blend equations, three alpha variants and the texture/fragment specializations. Untextured specialization reuse removes 6,240 redundant creations, but cold startup still needs substantial time. These are startup measurements rather than a comparison against an older renderer with fewer shader variants.

Run the shared archive regression fixtures with the instructions in `tools/kazarov/tools/switch/tests/README.md`. They cover empty files, UTF-8 paths, ZIP64, Zstandard, malformed data and CRC failures. A real-data comparison is optional and keeps the archive outside the test sources.

Use `--env KZ_PERF_LOG=1` for once-per-second canonical/display CPU and GPU samples, acquire/present/fence waits and presentation-interval buckets. Means and maxima are reported separately, together with total GPU milliseconds over the measured interval. Display preparation is also reported separately and is included in the overall display CPU sample; it must not be added to that sample again. `--env KZ_GPU_SCOPES=pass` adds GPU pass timings; `KZ_PERF_REPLAY_PHASES=1` and `KZ_PERF_MESH_PHASES=1` provide separate CPU breakdowns. Run diagnostic modes individually when comparing their overhead.

`tools/switch/devkit-perf.ps1 -Scene <scene> [-RunRoot <dir with data.zip>]` measures one scene on the development unit: `title`, `town`, `town-still`, `town-sky`, `town:<map>`, `georama:<n>`, the `dungeon` variants, `dungeon:<n>:<floor>` and `boss:<event id>` jump straight to it with `--fast-load` (dungeons and bosses also with `--skip-events --invincible --seed 1`), and all but the still and sky scenes turn the camera for the whole run. `--perf-seconds` waits for control and one more second, logs ten one-second windows and exits; the summary adds the renderer's CPU and GPU samples and, for dungeons, the floor's live monsters and chests. `-Seconds` changes the length, `-Extra` adds arguments such as `--env DC2_PERF_ZONES=1` (per-zone game-thread times) or `--env KZ_GPU_SCOPES=draw` (GPU time by target and pipeline), `-Replay <input>` drives the run from a replay instead of the turning stick, and `-Screenshot` captures the running scene. The FPS counter costs an extra full-frame copy per canonical endpoint; `--env DC2_SWITCH_HIDE_FPS=1` measures without it.

Development-unit runs on 2026-11-01 at stock handheld clocks (1280 × 720, FPS counter shown, ten seconds of a turning camera after one second with control) presented:

| Scene | FPS | Repeated vblanks |
| --- | --- | --- |
| Title; Palm Brinks standing; Underground Water Channel floor 2 | 60.0 | 0 |
| Palm Brinks turning | 59.3–59.5 | 0–5, all in the first two seconds |
| Starlight Canyon, Moon Flower Palace, Zelmite Mine (floor 3) | 59.9–60.1 | single dips |
| Gundorada Workshop (floor 3) | 57.5 | |
| Rainbow Butterfly Wood floor 2 | 52–55 | 56–101 |
| Georama 0, 2 and 4 | 60.0 | 0 |
| Georama 1 (Sindain) | 52–56 | 42–78 |
| Georama 3 (Veniccio) | 58.6 | 14 |
| Bosses Linda, Halloween, Trentos, Lapis Garter, Sea Dragon, Sirus, Emperor Griffon, Dream Spirals 1 and 2, Dark Element | 59.5–60.0 | 0–5 |
| Bosses Butterfly, Memo Eater, Gaspard and Fire, Puppet Shigura, Jaming and Shingala, Dream Spirals 3–5, Metal Flotsam, Dark Genie | 53–59 | 8–69 |

King Mardan, Death Ark, Gaspard 2, Monster Gaspard and Inferno wait for input in their event scripts and did not reach control under `--skip-events`. The scenes below 60 are GPU-bound in some directions: blended and alpha-tested meshes and the outline composites dominate there, and an interpolated intermediate costs nearly as much as the canonical render. Loading on the development unit runs from host-streamed romfs, where each archive read costs a round trip, so its load times overstate a console's; model documents dominate the parsing that follows.

`tools/kazarov/tools/switch/devkit-run.ps1` stages and tests a libnx ELF through the connected SDK development unit. It records hashes, logs and a screenshot, holds the hardware lock, and restores console policies. Such a run validates the SDK-converted ELF; direct Homebrew Menu NRO launch is a separate check. Establish cold/warm-cache, title, town, dungeon, movie, save/load, shutdown and dock/undock results before making gameplay or frame-rate claims.
