# PC port plan

This is the working plan for the native PC port of Dark Chronicle (PAL,
`SCES_511.90`). It follows the shape of Chronicle's `docs/PC_PORT_PLAN.md`
and shares Chronicle's host code through the Kazarov submodule wherever the
two games agree. Keep it current: when a work package lands, record its
status here and move the architectural facts into `docs/PC.md` (created by
WP1.11).

The plan is executed by orchestrators that delegate reading and writing to
smaller agents. Every work package (WP) therefore names its files, its inputs,
its acceptance commands and whether it may run beside other packages. A WP
tagged **[mechanical]** is meant to be completed from its brief alone; one
tagged **[decision]** needs architectural judgement and is written by the
orchestrator or reviewed by it before and after.

## 1. Goals and hard rules

- **C++26, SDL3, Vulkan 1.4, clang 20 or newer, lld.** The port lives in
  `port/src` and `port/include`. `ps2/src` and `ps2/include` stay the PAL game
  as the PS2 build compiles it. The only edits allowed there are the ones
  Chronicle allows (`docs/PC.md` "Keeping the PS2 build matching"): standard
  C++ corrections that leave the PS2 build byte-identical, and `#ifndef PORT`
  around definitions written in MWCC assembly. `./build.sh ps2-pal` in the
  container plus `scripts/build/verify.py -c` must pass after every phase.
- **Shared with Chronicle through Kazarov.** The renderer, the audio stack,
  the game-agnostic platform layer and the game-agnostic SDK replacements
  live in the Kazarov submodule (`tools/kazarov/src/cpp/`) and are consumed by
  both games. ChronicleTwo never copies code that Chronicle already has; it
  consumes it, and extends it in Kazarov where the extension is generic
  (section 3.5). Chronicle's build and tests stay green throughout.
- **Replacement through `PORT_OVERRIDE` only.** A definition in `port/src`
  tagged `PORT_OVERRIDE` replaces the one in `ps2/src`; the build strips the
  original (`tools/kazarov/scripts/build/port_override.py list/strip/check`). Every
  replacement is written from scratch. A `static` function cannot be replaced,
  so its non-static callers are replaced instead. The one exception is a
  `static` function written in assembly: it is guarded `#ifndef PORT` and the
  port defines a non-static function of the same name, declared to the unit
  by `port/include/stubs/<unit>.hpp` (Chronicle's `stubs/frame.hpp` pattern).
- **No emulation.** No GS register interpreter, no VU0 or VU1 interpreter, no
  VIF/GIF packet decoder, no DMA chain walker, no SPU2 model, no IOP, no
  memory mapping of PS2 address ranges (scratchpad, uncached mirrors,
  registers). The six VU1 microprograms are replaced by shaders and CPU code
  written from a behavioural spec of the retail microcode (section 3.6). VU0
  macro-mode assembly becomes plain C++ math. PCSX2 may be read to understand
  the hardware; nothing is copied from it.
- **No PS2 memory quirks.** No 32-bit pointer-in-int round trips, no
  `mgMEMORY_BLOCK` with a 4-byte pointer, no scratchpad staging, no uncached
  writes. The specific code is replaced, not accommodated.
- **No fixed resolution or frame rate.** The game renders 512x480 for a 4:3
  display at `mgFrameRate = 2` (25 Hz on PAL). The port keeps a logical
  512x480 space for 2D, mapped aspect-correct to any window, renders 3D at
  window resolution, runs the logic tick at a runtime rate (default 50 Hz,
  the PAL field rate, with `mgFrameRate` keeping its meaning of ticks per
  game frame so gameplay scaling is untouched), and presents independently
  of the tick.
- **No overlays, no IRX.** The game has none; `sceSifLoadModule` and the IOP
  reboot succeed as no-ops.
- **Game data is a plain directory.** `tools/dc2data` extracts `DATA.DAT`
  (indexed by `DATA.HD4`), `SOUND.DAT` (indexed by `SOUND.HD3`) and
  `MOVIE/*.PSS` into `data/`; the game reads it with `std::filesystem`.
  Saves go to `save/`.
- **Asset conversion is a last resort.** Every format on the disc is consumed
  natively at load. PSS movies are demuxed by the port and their MPEG-2
  video decoded by a minimal LGPL `libavcodec` (section 3.9), the one
  third-party decoder the port links.
- **Comments** explain why a non-obvious decision, constraint or workaround
  exists. Never what the code does.

## 2. Where the port stands

Phases 0-6 are done and Phase 7 (the sweep through the game) has started.
`darkchronicle` builds with clang/lld, C++26, SDL3 and
Vulkan 1.4 on Linux (container) and Windows (llvm-mingw), indexes `data/`
(8751 files), places the game's memory above 4 GiB, and runs the retail
`MainLoop` on the shared renderer, mixer and movie decoder through the
language select, the logo movie, the title over its 3D map with its music
and its attract loop (title and opening movie), New Game, and the costume
screen up to "Confirm Max's costume?". Every game frame is a recorded display
list rendered canonically, with interpolated display frames (bone palettes
included) between ticks; HUD pieces anchor to the window's corners.
Confirming the costume loads the opening event, which stops on a loop in
the frame tree (`mgCFrame::SearchFrame`): that is where Phase 7 resumes.
The PS2 build still matches, and `docs/PC.md` describes the port;
`docs/port/HANDOFF.md` is the working state and `docs/port/process/` the
schedule and wave records.

The Kazarov submodule (pinned at `main`) has `port_override.py`,
`include/kazarov/port.h` (`PORT_INIT/RETURN/FIX`, the empty `PORT_OVERRIDE`
marker) and a container image with clang/lld 23, SDL3, Vulkan, Mesa
lavapipe, glslang and GoogleTest. Since Phase 0, Kazarov holds the shared host code in
`tools/kazarov/src/cpp/{gfx,audio,platform,sce,tests}` and
`cmake/KazarovPort.cmake`, and Chronicle consumes it from there. ChronicleTwo and Chronicle pin Kazarov
`main` (see `docs/port/HANDOFF.md` for the sha).

Facts from the four surveys that shape the plan:

- **Source.** 149 units, 261,565 lines in `ps2/src`; 78,800 lines of headers.
  No `#if` of any kind in `ps2/src`. MWCC `asm` functions and blocks in
  `mg_math.cpp` (32 whole functions), `mg_frame.cpp` (2 static asm functions
  and 6 functions with asm blocks), `gameutil.cpp` (4), `collision.cpp` (3),
  `editcoll.cpp` (1), `editmap2.cpp` (1), `mg_drawprim.cpp` (4),
  `mg_visual.cpp` (`SendDMA`): 54 definitions. `ExitHandler()` in
  `ps2/include/sce/eekernel.h` expands to `asm volatile("sync.l; ei")` and
  is used by `main.cpp`, `mglib.cpp` and `movie.cpp`.
- **Entry and frame.** `main()` (`ps2/src/main.cpp:138`) runs the static
  `init()` (GS reset, IOP reboot, ten IRX loads, `InitCDFile`) and
  `MainLoop()` (`mainloop.cpp:462`), which sets up the 26 MiB `main_buffer`
  arena, `SaveData.Initialize`, `GamePad__2.Init()` (libpad), then
  `mgInit(MG_SCREEN_MODE_512X480, 3)` and the sound managers. Per frame:
  `mgBeginFrame`, `LoopMain[LoopNo]()`, `sndStep`, pad update, `mgEndFrame`.
  `mgEndFrame` builds the VIF1 chain, spins in `WaitVSync(old_vcount,
  mgFrameRate)`, pokes PMODE/DISPFB/DISPLAY directly, and sends the chain.
- **Threads.** All at priority 10, cooperative through
  `RotateThreadReadyQueue`: the gamepad vibration thread, the now-loading
  thread (draws its own frames), the fishing data-load thread, and three
  movie threads plus a VBlank INTC handler and a GIF DMAC handler. Semaphores
  in `snd_mngr.cpp` and `movie.cpp`.
- **Rendering.** One VIF1 DMA chain per frame; GS state via PATH2 DIRECT,
  geometry via VU1 XGKICK. Draw manager buckets packets by texture block
  and time-multiplexes one VRAM window per block (`ReloadTexture`). Skinning
  runs on VU1 (`__VERTEX_BLEND`, 32 bone matrices at VU address 0x3C). Six
  microprograms: `Vu_prog0` (main: transform, light, point light, fog, env
  map, clip, scissor), `Vu_prog_sdw` (shadow volumes to the drop-shadow
  plane, add/subtract counted), `Vu_prog_3dsp` (billboards), `Vu_prog_wtr`
  (water refraction), `Vu_progmain` (sent once at init) and `My_dma_start0`
  (init chain). The binaries exist only in the retail ELF's `.vutext`
  (0x325C80-0x32A320) and `.vudata` (0x363480-0x363580) sections.
- **Depth.** PSMZ24, ZTST GEQUAL, near maps to ~1.67e7 and far to 0:
  reverse-Z, the convention Chronicle's renderer already implements.
- **Data.** `DATA.HD4` is an array of 12-byte `{name_offset, size, sector}`
  records (8,753 records: 8,751 files, one duplicate `wep_t/ws050_item.chr`
  the game never reaches, and an empty terminator), names relative to the
  index start, `\` to `/`,
  case-insensitive lookup; `DATA.DAT` is read by sector. Packs are 0x4C-byte
  `PACK_ENTRY` chains. `SOUND.DAT` (970 MB) and `SOUND.HD3` are streamed by
  `EZBGM.IRX` on the IOP; the EE never parses them, so their format is
  unknown. `MOVIE/*.PSS` are read with the CD streaming API.
- **Audio.** `CSound` drives SPU2 through `sceSdRemote` (SDRDRV), HD/BD bank
  upload, SQ sequences through MODHSYN and EZMIDI RPC, SE note messages
  through `sceMSIn_*`, and streamed BGM/voice through EZBGM RPC. Movie PCM
  goes to the IOP by SIF DMA.
- **Saves.** `CMemoryCardManager` is a libmc state machine on
  `BESCES-51190dkcl%d`, `BESCES-51190dc2album`, `BESCES-51190dc2omake`;
  `SAVEDATA_FORMAT` is 0x659C0 bytes. It uses `sceMcSeek`, which Chronicle's
  libmc may not implement.
- **Input.** Old libpad API, two ports, analog forced, two rumble motors from
  a thread; no pressure-sensitive buttons.
- **Chronicle's host side is game-agnostic** apart from names in a few files:
  `platform` (minus `config`, `firstrun`, `save_state`, and the Dark Cloud
  identity in `window`, `paths`, `discord`), `gfx` (minus
  `kLogicalWidth/Height = 640x480` and the app name), `audio` (Sony formats
  only), `sce` (`libvu0`: 45 functions of which Dark Chronicle's header
  declares 40; `libpad`, `libmc`, `sifdev`, `sifrpc`, `eekernel`,
  `libcdvd`, `libgraph`), `stubs/sce` (`libdma`, `libgraph`, `libpkt`).

## 3. Target architecture

### 3.1 Layout

```
CMakeLists.txt            PLATFORM=PS2 -> ps2/, PLATFORM=PC -> port/
CMakePresets.json         linux-x64[-release], macos-arm64[-release]
kazarov.conf              ps2-pal, linux-x64[-release], macos-arm64[-release], windows-x64[-release]
tools/windows/*.ps1       acquire, configure, build, kazarov (llvm-mingw, SDL3, glslang, Vulkan headers)
tools/dc2data/            disc extraction: DATA.HD4+DATA.DAT, SOUND.HD3+SOUND.DAT, MOVIE/*.PSS
tools/kazarov/            submodule: build driver, port_override.py, port.h, and the shared port code:
  port/gfx/               Vulkan renderer (+ shaders, README)
  port/audio/             HD/BD/SQ/VAG player, synth, sequencer, mixer, reverb, PCM decoders, streams
  port/platform/          clock, files, memory, paths, window, display, input, gamepad_map, input_script,
                          mouse, touchpad, overlay, imagefile, ttffont, glyphs, audio (SDL output), settings
  port/sce/               libvu0, libpad, libmc, sifdev, sifrpc, eekernel, libcdvd, libgraph, unimplemented
  port/sce/stubs/         libdma, libpkt, libdev, libmpeg, libsdr, modmsin, sifdma, eekernel_threads, ...
  port/tests/             the host-side GoogleTest cases, built into each consumer's test executable
  cmake/KazarovPort.cmake kz_port_host_library, kz_port_sce_sources, kz_port_tests
port/CMakeLists.txt       targets ct_options, ct_ps2, ct_host, ct_port, darkchronicle, darkchronicle_tests
port/include/port.h       force-included ahead of every game unit
port/include/stubs/<unit>.hpp   declarations and renames the stripped copy of ps2/src/<unit>.cpp needs
port/src/main.cpp         PORT_OVERRIDE main: CLI, platform init, renderer, audio, then MainLoop()
port/src/runtime.cpp      __assert, exit__2, mwInit, fptosi/fptoui (Ps2Unimplemented is Kazarov's)
port/src/platform/        game-specific host code only: config (schema), firstrun
port/src/video/           PSS demux and MPEG-2 decoder, no game headers (candidate for Kazarov later)
port/src/<unit>.cpp       replacements for ps2/src/<unit>.cpp (mglib, mg_texture, mg_visual, dataread, movie, ...)
port/src/tests/           darkchronicle_tests: game-side cases plus kz_port_tests
docs/vu1/<program>.md     behavioural specs of the six VU1 programs (the source of truth for their replacements)
scripts/port/             vu1dis.py (VU1 disassembler), truncations.py (pointer-cast audit)
```

Rules: nothing under `tools/kazarov/src/cpp/gfx`, `audio`, `platform` includes
a game header; they build as `ct_host` without `port.h`.
`tools/kazarov/src/cpp/sce` is compiled by each consumer with its own
`ps2/include/sce` headers and `port.h` (section 3.3). Replacement units in
`port/src` are the only place game types and host services meet.

### 3.2 Build

`port/CMakeLists.txt` is Chronicle's with the names changed (`dc_` to `ct_`,
`darkcloud` to `darkchronicle`, no `REGION`, no `CREDITS`, no `lang/`, no
`glyphs/` until the options work needs them) and the host side taken from
Kazarov:

- `kz_port_host_library(ct_host)` builds `tools/kazarov/src/cpp/{gfx,audio,
  platform}` as an object library: finds SDL3, Vulkan 1.4, glslang and
  nlohmann_json, fetches the pinned stb/dr_libs single-file decoders (or
  uses a directory the consumer names, for Flatpak), compiles the shaders
  to SPIR-V headers.
- `kz_port_sce_sources(out LIBS libvu0 libpad libmc ...)` returns the
  selected `tools/kazarov/src/cpp/sce` sources to add to the game-side target.
  Each file includes only its own SDK header, so a consumer selects only the
  families its `ps2/include/sce` has.
- `kz_port_tests(darkchronicle_tests)` adds the host-side test cases.

The override pipeline is unchanged: `port_override.py list`, `strip` with
`--define PORT` and `port/include/stubs/<unit>.hpp`, `check`, compile the
copies with `port.h` force-included and Chronicle's MWCC-tolerance flags,
link with `port/src` (lld, `--gc-sections`, PIE on Linux). The renderer
creates every pipeline at `RendererInit` with a `VkPipelineCache` in
`save/pipeline_cache.bin`.

Configurations: `linux-x64[-release]` in the container
(`port/build/pc[-release]`), `macos-arm64[-release]` on the host with the
Homebrew preset, `windows-x64[-release]` through `tools/windows/kazarov.ps1`
with llvm-mingw. `ps2-pal` is unchanged.

### 3.3 Override mechanism

- A hardware-dependent non-static definition in `ps2/src` is replaced by a
  `PORT_OVERRIDE` definition in `port/src/<unit>.cpp`.
- A hardware-dependent `static` function (`SetShadowData` in `mg_shadow.cpp`,
  `SetTexFlush_TagCnt`/`GetZBufVram`/`CheckCopyToZBufVram` in
  `mg_texture.cpp`, `DrawDivSprite*` in `outline.cpp`, `VSyncCallBack`/
  `ClearScreen`/`init` in `main.cpp`) is never touched: its non-static
  callers are replaced.
- A definition written in MWCC `asm` (the 32 `mg_math.cpp` functions,
  `test1`/`test2`, `pre_trance_normal`/`trance_normal`, `SendDMA`) is wrapped
  `#ifndef PORT` ... `#endif` in `ps2/src`, replacing blank lines so no line
  moves. The port defines the same name non-static (no tag, there is nothing
  to strip) and `port/include/stubs/<unit>.hpp` declares it for the unit.
- A function containing an `asm { }` block (`mgInsideScreen`,
  `mgCFrame::GetLocalMatrix/GetBBoardMatrix/GetLWMatrix/GetLWMatrixTopBottom/
  GetDrawRect`, `testVUnew` (static) and `MotionProc2`, `CheckHit`,
  `CheckHits`, `CCollisionMDT::PickUpNearPoly`, `ClipBoxXZ`, `PlaneNormalXZ`
  (static), `mgCDrawPrim::Data0/Data4/Vertex/Color`) is handled the same way:
  the whole function is guarded and the port defines it.
- `ExitHandler()` is guarded `#ifndef PORT` in `ps2/include/sce/eekernel.h`,
  expanding to `((void) 0)` under `PORT`: an assembly definition in an SDK
  header copy, the same exception, and the PS2 build does not change.
- Shared SDK replacements (`tools/kazarov/src/cpp/sce/*.cpp`) are compiled by
  each game with `port.h` force-included and that game's `ps2/include/sce`
  on the include path. Where a game's transcribed header disagrees with the
  real SDK prototype, the transcription is corrected (an SDK-true header
  edit changes nothing in the PS2 build); the Kazarov source follows the
  SDK. `PS2_UNIMPLEMENTED()` and `Ps2Unimplemented` move to
  `tools/kazarov/include/kazarov/port.h` and `port/sce/unimplemented.cpp`
  so shared stubs compile in both games.
- Phase 1 overrides every game function that reads or writes a hardware
  address directly (0x10000000-0x1FFFFFFF registers, 0x70000000 scratchpad,
  `| 0x20000000` uncached mirrors, `& 0x0FFFFFFF`, `DmaCH*` register
  structs) with `PS2_UNIMPLEMENTED()`. Packet building into ordinary memory
  is left alone: it aborts in the SDK stub that would send it.

### 3.4 Platform layer

Shared (`tools/kazarov/src/cpp/platform`): `clock` (logic tick, `ClockPump`,
`ClockSyncV`, `ClockWaitNextTick`), `files`, `memory`, `paths`, `window`,
`display`, `input` + `gamepad_map` + `input_script`, `mouse`, `touchpad`,
`overlay` (+ its font), `imagefile`, `ttffont`, `glyphs`, `audio` (SDL3
output), and a new `settings.hpp`: the plain struct of host settings
(`tick_rate`, window mode, present mode, max fps, show fps, master volume,
sound mode, every `input.*` key, env-var prefix) that `input`, `display`,
`audio`, `paths` read instead of `config.hpp`. App identity is a parameter:
`WindowConfig{title, app_id, icon_rgba}`, `PathsConfig{app_dir, env_data,
env_save}`.

Per game (`port/src/platform`): `config` (loads `config.json`, fills the
shared settings struct, owns the game's own options), `firstrun` (names the
game's disc files), `save_state`, `discord` (client id and assets are the
game's; the IPC code could be shared later, not in this plan).

ChronicleTwo's values: title "Dark Chronicle", app id `chronicletwo`, app
dir `chronicletwo`, env `DC2_DATA`/`DC2_SAVE`/`DC2_AUDIO*`/
`DC2_VULKAN_VALIDATION`.

### 3.5 Shared code in Kazarov and the commit flow

**What goes to Kazarov, and why.**

| Area | Goes | Reason |
|---|---|---|
| `gfx` | yes | No game concept inside once logical size, aspect and app name are parameters |
| `audio` | yes | Sony HD/BD/SQ/VAG formats, SPU2-style synth, IOP MIDI player: identical on both discs |
| `platform` units listed in 3.4 | yes | PS2-shaped pads and host services; only names leak, parameterised |
| `platform/config`, `firstrun`, `save_state`, `discord` | no | Schema, disc files, save layout and Discord assets are the game's |
| `sce/libvu0`, `libpad`, `libmc`, `sifdev`, `sifrpc`, `eekernel`, `libcdvd`, `libgraph` | yes | SDK semantics; `libmc` gains `sceMcSeek`; `libcdvd` gains the DC2 families as stubs |
| `stubs/sce` (`libdma`, `libpkt`) and the new DC2 families (`libdev`, `libmpeg`, `libsdr`, `modmsin`, `sifdma`, `eekernel_threads`) | yes | SDK families selected per consumer; a stub is the shared "not emulated" answer |
| `runtime.cpp` (`__assert`, `exit__2`, `mwInit`, `srand`, exit codes) | no | Exit codes, the libc generator and the MWCC helpers differ per game; `Ps2Unimplemented` alone moves |
| `port/src/video` (PSS demux, audio track, libavcodec wrapper) | not now | Written for DC2; Chronicle has no movies. The FFmpeg acquisition (`kz-ffmpeg`, `KazarovFfmpeg.cmake`) is Kazarov's since it is build machinery; the wrapper moves once a second consumer exists |
| `tools/dcdata` / `tools/dc2data` | no | Index formats differ (HD2 32-byte vs HD4 12-byte); the ISO reader could be shared later |

**DC2 extensions of the shared code** (written in Kazarov, usable by
Chronicle): `audio/stream` (a streamed-VAG channel player, once WP5.3 fixes
the format), `audio/hsmsg` (MODHSYN HS message decoding lifted from
Chronicle's `gameutil_midi.cpp` if it is generic there), `gfx` paths for
point lights, environment mapping and VU1-style skinning (specialisation
constants that Chronicle leaves off), `platform/clock` thread hooks. Game
glue (EZMIDI and EZBGM command tables, `CSound`, `movie.cpp`) stays in
`port/src`.

**Branch, PR and pins.** Kazarov work happens on branch `shared` of
`https://github.com/TheMoonPeople/Kazarov.git`, worked in the standalone
clone at `C:\Users\Adubbz\Development\PS2\Projects\Kazarov` (currently an
empty `.git` with the remote set: `git fetch origin && git checkout -b
shared origin/main` first). Every Kazarov WP ends with a push of `shared`.
Each game pins the branch commit in its submodule (`git -C tools/kazarov
checkout <sha>` plus a "Kazarov: pin shared@<sha>" commit on the game's
branch; `.gitmodules` keeps `branch = main`). A game bumps its pin only
after its own build and tests pass on that commit; Chronicle is bumped
first for any change to code it consumes. When `shared` merges to `main`
by PR, both games re-pin to the merge commit. Nothing in a submodule
checkout is edited without a branch and a push.

### 3.6 VU replacement strategy

**VU0** is used only in macro mode (no `vcallms`). Every `asm` function and
block becomes C++ over `float[4]` with the lane behaviour the retail
instruction sequence has (which components are written, whether `w` is
touched; `vdiv`/`vsqrt` rounding is not reproduced). The ~1788 `sceVu0*`
calls go to the shared C++ `libvu0`.

**VU1** programs are replaced one by one from a written spec. There is no
source for them, so the plan has a dedicated step:

- `scripts/port/vu1dis.py` disassembles a `.vutext` blob: it parses the DMA
  tag and VIF `MPG` codes to find the code words and their load address,
  then prints upper/lower instruction pairs with labels taken from
  `ps2/config/pal/main.symbols.txt` (`__VERTEX_BLEND`, `__LIGHTING`, ...).
- `docs/vu1/<program>.md` is written per program from that listing: input
  data layout (the UNPACK addresses the CPU side writes), the per-vertex
  math in order (transform, lighting model with its exact clamping and
  0x80 = 1.0 scaling, fog from 1/w with the coefficients at 0x3B,
  point-light accumulation, environment-map UVs, the 6-plane clipper and
  when it runs versus the scissor test, the XYZF2/RGBAQ/ST output
  conversion including the 12.4 fixed-point rounding and the Q divide), the
  GIF tags it emits and the flags word at 0x26.
- Each replacement WP in phase 4 names its spec as the input and encodes the
  spec's cases as test expectations.

| Program | Native replacement |
|---|---|
| `Vu_prog0` | `mesh.vert` specialisations in Kazarov gfx (lit/vertex-colour/point-light/env-map/skinned/fog) plus the GS semantics already in `draw.frag`; clipping by hardware clip planes, scissor by `DrawState` |
| `Vu_prog_sdw` | CPU extrusion of silhouette triangles to the drop-shadow plane into a mesh, drawn into a `share_main_depth` target with additive/subtractive counting, composited like Chronicle's `shadow_buf` |
| `Vu_prog_3dsp` | CPU expansion of each sprite to a quad (rotated when `__MAIN_PROG_ROT`), one batch |
| `Vu_prog_wtr` | a mesh with `kMeshScreenUv` sampling `kPreviousFrame`, UV offset from the CPU slope vectors |
| `Vu_progmain`, `My_dma_start0` | documented from the spec; expected to be the initial GS environment and a resident default. Folded into `mgInit`'s replacement; nothing is uploaded |

### 3.7 Threads and timing

The game never needs real concurrency: every thread cooperates through
`RotateThreadReadyQueue` and `WaitVSync`. The port runs single-threaded on
the shared clock: `ClockPump()` advances the VSync count, runs the installed
callback (`VSyncCallBack2`, the play-time counter), pumps window events, and
for the loading screen draws the now-loading frame. Every replaced spin
(`WaitVSync`, `sceGsSyncV`, `ReadBGSync`, `ReadBG` polling, the movie
`do..while(field == sceGsSyncV(0))`) pumps. `CreateThread`/`StartThread`
for the gamepad vibration stepper, the now-loading loop and the fishing
loader become registered pump hooks (a `clock` extension in Kazarov) that
run one step per tick; `CreateSema`/`WaitSema`/`SignalSema` are counters that
never block. Movie threads and the INTC/DMAC handlers disappear with
`movie.cpp`'s replacement.

The logic tick is `settings.tick_rate` (default 50); `mgFrameRate` keeps its
meaning of ticks per game frame (2 by default, so the game steps at 25 Hz
as retail). Presentation records each game frame as a display list rendered
as often as the display allows, with interpolation where `RenderList`
provides it. T0 HBLANK counting (`mgNowFrameRate`, the CPU meter) becomes
wall-clock measurement in the same units.

### 3.8 Audio

The shared stack (VAG, HD/BD banks, SQ, sequencer, 48-voice synth, reverb
approximation, 16-port mixer, PCM decoders, soundtrack overrides) is the
backend. The game-side seam is `CSound` (`sound.cpp`), `snd_mngr.cpp`,
`ezmidi.cpp`, `ezbgm.cpp` and the `sceMSIn_*` calls: bank upload becomes
bank registration, `LoadSeq`/EZMIDI commands become sequencer calls, SE
`PutHsMsg` note messages go through the shared HS decoder to the synth, and
the EZBGM channel commands (open, open-from-pack, preload, play, stop, pause,
close, volume, state, level, standby mono/stereo) drive a shared stream
channel. The stream player decodes `SOUND.DAT` entries after WP5.3
establishes the `SOUND.HD3` layout and the stream encoding (expected:
interleaved VAG blocks with a header giving rate, channels and loop). Voice
files under `VOICE\` and `V\` are not on the PAL disc; their open calls fail
as retail's did.

### 3.9 Movies

`movie.cpp` is the SCE PSS player: CD streaming, `sceMpegDemuxPssRing`,
libmpeg decoding on the IPU to RGB32, frames uploaded by GIF packet from a
VBlank handler, PCM pushed to the IOP. Title, promo and tutorial `.PSS`
files are played (`RUSH`, `L5LOGO`, `PROMO*`, `TUTO\VTUTO%d`, `OPEN1`,
`E54001-4`, `END1/2`).

**Decision: native decode with libavcodec for the video elementary
stream; everything else is ours.** `port/src/video` holds the PSS demuxer
(MPEG program-stream pack and system headers, PES for video stream 0 and
private stream 1), the PCM/ADPCM audio track handling into the shared
mixer, the YUV 4:2:0 to RGBA conversion and the player. Only the MPEG-2
video ES decode goes through FFmpeg's `libavcodec` (`mpeg2video` decoder
with its `mpegvideo` parser) and `libavutil`, nothing else of FFmpeg:
no `libavformat`, `libswscale`, `libswresample` or `libavfilter`.

Why this library: the decoder must be MPEG-2 (ISO 13818-2); `libmpeg2` is
GPL-2.0 and `pl_mpeg` is MPEG-1 only. FFmpeg's `mpeg2video` decoder is
LGPL-2.1+ when FFmpeg is configured without `--enable-gpl`/`--enable-
nonfree`, which is compatible with Kazarov's MIT licence and with the game
repositories, which carry no licence file (Q12). The distribution packages
are not usable: Debian's `libavcodec` and Homebrew's `ffmpeg` are built
`--enable-gpl`, so the port builds its own minimal LGPL FFmpeg:

- **Configuration** (`tools/kazarov/scripts/build/kz-ffmpeg`, a build script over a
  pinned source tarball with its SHA-256; FFmpeg 7.1.1):
  `--disable-everything --disable-programs --disable-doc --disable-network
  --disable-autodetect --disable-avformat --disable-avfilter
  --disable-swscale --disable-swresample --disable-avdevice
  --enable-decoder=mpeg2video --enable-parser=mpegvideo --enable-pic
  --disable-shared --enable-static` (x86 assembly left on where `nasm` is
  present, off otherwise). The result is `libavcodec.a` + `libavutil.a` of
  about 2 MB, installed under `.kazarov/ffmpeg/<os>-<arch>/`.
- **Linux**: built into the container image (`image/Dockerfile`, cached
  layer) by `kz-ffmpeg`; linked statically. **macOS**: `kz-ffmpeg` runs on
  the host into `.kazarov/ffmpeg/darwin-arm64` (Homebrew `ffmpeg` is not
  used); linked statically. **Windows**: `configure` needs a POSIX shell,
  so `tools/windows/acquire.ps1` downloads BtbN's `win64-lgpl-shared` build
  of the same FFmpeg release (a tagged `autobuild-*` asset, pinned
  SHA-256, the `lgpl` variant: no GPL components), and `build.ps1` copies
  `avcodec-61.dll` and `avutil-59.dll` beside `SDL3.dll`. Dynamic linking
  on Windows keeps LGPL section 6 trivially satisfied; the static links on
  Linux and macOS satisfy it because the port's sources and build are
  public and the user can relink.
- **CMake**: `cmake/KazarovFfmpeg.cmake` provides `kz_ffmpeg(target)`
  (finds the static or import libraries by `KZ_FFMPEG_DIR`, adds includes
  and link lines, and `pthread`/`m` on Linux). Chronicle does not call it.
- **Flatpak** (when ChronicleTwo gets one): the manifest builds the same
  minimal FFmpeg module from the pinned tarball, as Chronicle's does for
  its vendored single-file decoders.

Output: an RGBA frame per picture into a texture the replaced `movie.cpp`
draws as a full-screen quad, PCM into the mixer. Playback is pumped from
the main loop, no threads. Extraction-time conversion was rejected: it
needs a decoder to produce the converted assets and would re-encode them.

### 3.10 Input

Shared `sce/libpad.cpp` implements the old libpad API the game uses
(`scePadInit`, `PortOpen/Close`, `Read`, `GetState`, `InfoMode`,
`SetMainMode`, `InfoAct`, `SetActAlign`, `SetActDirect`) on
`platform/input`. The vibration thread's `Step` becomes a pump hook.
`CPadControl`'s confirm/cancel swap stays the game's.

### 3.11 Files and saves

`tools/dc2data extract <iso-or-dir> <data-dir>` writes `DATA.DAT` entries to
`data/<lowercased path>`, `SOUND.DAT` entries to `data/sound/<name>` once
WP5.3 fixes the index format (until then it copies the two files whole), and
`MOVIE/*.PSS` to `data/movie/`. `dataread.cpp`'s replacement reads `data/`
with a case-folded index; `host0:` writes go under `save/host0/`. Shared
`sce/libmc.cpp` backs memory cards with `save/mc0`, `save/mc1`; the game's
own directory and file names are kept. `password.cpp` depends on a 64-bit
`unsigned long`; on Windows its functions are replaced with `u64`.

### 3.12 Memory model fixes

- `mgCMemory` (`mg_memory.cpp`) is replaced whole: `mgMEMORY_BLOCK` with a
  host pointer, the quadword stack over a host allocation, 64-byte
  alignment through `uintptr_t`. `main_buffer` stays a static array but the
  `% 64` pointer arithmetic in `mainloop.cpp:556-563` and the heap sizes
  each mode's Init passes get measured headroom for 8-byte pointers.
- `dataread.cpp`'s `DATA_HEADER` name fixup (`entry->name += base`, a union
  of `int` and `char*`) is replaced by a host-side index.
- `scripts/port/truncations.py` (Chronicle's audit, copied: it is a script,
  not shared code) lists every pointer-to-32-bit cast; round trips are
  fixed in replacement units.
- Scratchpad, uncached mirrors and `DmaCH*` are absent from the replacements.

## 4. Phased plan

Phases are in dependency order. Inside a phase, "parallel group" lists WPs
that touch disjoint files and may be executed at once. Size is lines of
change. Every WP ends with the PS2 build still matching when it touched
`ps2/`, with `port/src` `-Wall` clean, and, for Kazarov WPs, with Chronicle
building and `darkcloud_tests` green on the pinned commit.

### Phase 0: the shared code moves into Kazarov

Goal: `tools/kazarov/src/cpp/` holds the renderer, audio, platform and sce code;
Chronicle consumes it with its tests and CI green; ChronicleTwo pins the
same commit. Done in the Chronicle checkout and the Kazarov clone; nothing
in ChronicleTwo's `port/` depends on copies.

**WP0.1 Generalise gfx [decision, Chronicle]**
- Modify `Chronicle/port/src/gfx/*`: `RendererConfig` gains `app_name`,
  `logical_width`, `logical_height`, `display_aspect` (default 4:3);
  `kLogicalWidth/Height` are removed and every use reads the config
  (`Draw2D`, scissor, copies, `kPreviousFrame`, letterbox, render scale
  `round(H / logical_height)`); README "Spaces" updated. `main.cpp`/
  `gameloop.cpp` pass 640x480, "Dark Cloud".
- Acceptance: `darkcloud_tests` green; `darkcloud --headless --frames 3
  --screenshot out.png` unchanged pixels against the previous build.
- Depends: none. Size: ~400.

**WP0.2 Parameterise platform identity and settings [decision, Chronicle]**
- Create `Chronicle/port/src/platform/settings.hpp` (the host settings
  struct of 3.4) and make `input`, `display`, `audio`, `paths`, `window`,
  `mouse`, `touchpad`, `glyphs` read it; `config.cpp` fills it from
  `config.json`. `window` takes `WindowConfig{title, app_id, icon}`
  (icon bytes passed by the game, the generated `icon/chronicle.hpp`
  include leaves `window.cpp`), `paths` takes `PathsConfig{app_dir,
  env_data, env_save}`, `audio.cpp`/`trace.cpp` take the env prefix.
  `platform/firstrun` and `platform/config` stay game-side and are not
  touched beyond the settings fill.
- Acceptance: `darkcloud_tests` green (`platform_*`, `paths_xdg` adjusted
  to pass the config); `grep -rl "Dark Cloud\|chronicle\|DC_" port/src/
  {platform,gfx,audio}` returns only `config.cpp`, `firstrun.cpp`,
  `discord.cpp`, `save_state.cpp`.
- Depends: none. Parallel with 0.1. Size: ~500.

**WP0.3 Move into Kazarov [mechanical, Kazarov branch `shared`]**
- Create in the Kazarov clone: `port/gfx` (from 0.1), `port/audio`,
  `port/platform` (the shared units of 3.4 from 0.2), `port/sce` (Chronicle's
  `sce/*.cpp` and `stubs/sce/*.cpp`, plus `unimplemented.cpp`),
  `port/tests` (`platform_arena`, `platform_clock`, `platform_gamepad_map`,
  `platform_mc`, `platform_mouse_capture`, `platform_mouse_look`,
  `platform_pad`, `paths_xdg`, `glyphs`, `ttffont`, `gfx_misc`,
  `audio_soundtrack`, `dualsense` and their fixtures),
  `cmake/KazarovPort.cmake` (`kz_port_host_library`, `kz_port_sce_sources`
  with a `LIBS` list, `kz_port_tests`, the dependency finds and pinned
  downloads with a `KZ_PORT_VENDOR_DIR` override), `include/kazarov/port.h`
  gains `PS2_UNIMPLEMENTED()` and the `Ps2Unimplemented` declaration;
  README section "Shared port code". A `tests/cmake` fixture configures
  a consumer against a stub `ps2/include/sce`.
- Acceptance: Kazarov's pytest suite passes; `cmake` of the fixture passes
  in the container. Push `shared`.
- Depends: 0.1, 0.2. Size: moved files plus ~300 new.

**WP0.4 Chronicle consumes Kazarov port [mechanical, Chronicle]**
- Delete `port/src/{gfx,audio,sce,stubs}` and the moved `platform` units
  and tests; pin the submodule to `shared@<0.3 sha>`; `port/CMakeLists.txt`
  replaces the host-side, shader, download and `dc_host` lines with
  `kz_port_host_library(dc_host)`, adds `kz_port_sce_sources(... LIBS
  libvu0 libpad libmc sifdev sifrpc eekernel libcdvd libgraph libdma
  libpkt)` to `dc_port`, `kz_port_tests(darkcloud_tests)`; include paths
  stay `"gfx/gfx.hpp"`, `"platform/clock.hpp"` (root
  `tools/kazarov/port`). `Ps2Unimplemented` removed from `runtime.cpp`,
  `PS2_UNIMPLEMENTED` from `port.h`.
- Acceptance: `./build.sh linux-x64` and `ctest` green; `pc.yml` green on
  Linux, macOS, Windows; `./build.sh ps2-pal` and `ps2-ntsc` match. Commit
  "Kazarov: consume the shared port code".
- Depends: 0.3. Size: ~150 plus deletions.

**WP0.5 ChronicleTwo pins Kazarov [mechanical]**
- `git -C tools/kazarov fetch && checkout <0.3 sha>`; commit "Kazarov: pin
  shared@<sha>".
- Acceptance: `./build.sh ps2-pal` still matches (the driver is unchanged).
- Depends: 0.3. Size: 1 commit.

Phase 0 parallel groups: {0.1, 0.2} then {0.3} then {0.4, 0.5}. ChronicleTwo's
WP1.5 (ps2/ guards) may run during phase 0.

**Phase 0 status: done.** Kazarov `main` is `0d72aa1`; Chronicle `master`
is `c67a87c1`; both games pin Kazarov `0d72aa1`.
- WP0.1 landed as Chronicle `588519a4`.
  `RendererConfig{app_name, logical_width, logical_height, display_aspect}`
  plus `gfx::LogicalWidth/Height/Frame()`. The game's own 640x480 constants
  are `kScreenWidth/Height` in `port/src/screen.hpp`. The default
  `DrawState::scissor_rect` is infinite, meaning the whole frame, because
  `DrawState`s are built before `RendererInit`. `kUiAnchorThirds` was
  unused and is gone.
- WP0.2 landed as Chronicle `3faa756d` and `38717527`.
  - `platform/settings.hpp` holds `HostSettings`, and Chronicle's `Config`
    derives from it.
  - The game defines `SettingsGet()` and `SettingsChange()`.
  - `DisplayApply` takes the game's change as a callable.
  - Identity is set by the game's `GameSetIdentity()`, through three calls:
    `SettingsSetEnvPrefix` (`SettingsEnv("AUDIO")` reads `DC_AUDIO`),
    `PathsConfigure{app_dir, env_data, env_save}` and
    `WindowSetIdentity{title, app_id, icon}`.
  - Deviation: the plan's `WindowConfig{title, app_id, icon}` became a
    separate `WindowIdentity`, because `WindowConfig` already describes a
    window mode. The env prefix is not a field of the settings struct,
    because identity does not belong in config.json.
- WP0.3 is Kazarov `0d72aa1`, fast-forwarded onto `main` (no PR, no
  `shared` branch upstream).
  - New: `port/{gfx,audio,platform,sce,sce/stubs,tests}`,
    `cmake/KazarovPort.cmake`, `PS2_UNIMPLEMENTED` in `kazarov/port.h`,
    and the `tests/cmake/test_port.py` fixture. Its host library builds in
    the container.
  - pytest: 76 passed, 14 skipped.
  - Deviation: these tests stay in Chronicle because they need game code:
    `platform_arena`, `platform_mouse_look`, `platform_pad`, `dualsense`,
    the config and shipped-asset cases of `glyphs`, and the
    `darkcloud`-binary case of `paths_xdg`.
  - Shared tests read their env vars through `SettingsEnv`, so
    Chronicle's `DC_GFX_OFFSCREEN` and `DC_TEST_FONT` keep working.
    Chronicle's ctest sets `DC_TEST_FONT`.
  - Open: the overlay's bitmap font (`port/platform/overlay_font.inc`,
    the Dark Cloud Compendium Community Font) is now in MIT Kazarov, and
    its licence has to be confirmed.
- WP0.4 landed as Chronicle `c67a87c1` "Kazarov: consume the shared port
  code".
  - The work was done in a separate worktree and branch, `phase0`. The
    other session's uncommitted lighting work (bloom, motion, ray tracing,
    Streamline) on Chronicle's `shared-port` still has `port/src/gfx`. It
    must be rebased onto the Kazarov layout: its renderer changes go into
    Kazarov `port/gfx`.
  - The four game-side platform units now compile in `dc_port`, with
    `port.h` force-included.
  - The game's remaining paths case moved to the `PathsXdgDarkcloud`
    fixture, so its name does not collide with Kazarov's `PathsXdg`.
  - Verified:
    - `linux-x64` ctest: 281/281 (2 skips, as before).
    - Headless screenshots: 9/9 byte-identical to the pre-Phase-0 build.
    - `windows-x64` built; its tests passed 287/287 (1 skip).
    - `ps2-pal`: 100% matching.
  - Not run: `ps2-ntsc` (no NTSC image on this machine), macOS, and
    `pc.yml` CI.
- WP0.5: ChronicleTwo pins Kazarov `0d72aa1`. `ps2-pal` still matches.

### Phase 1: compile, link, launch, abort loudly

Goal: `darkchronicle` builds on Windows (llvm-mingw) and in the Linux
container with clang + SDL3 + C++26, opens a window through the shared
platform layer, initialises the shared renderer (every pipeline built,
cache written), enters `MainLoop()` and aborts at the first hardware
dependent call with a `PS2_UNIMPLEMENTED` message naming the function. With
shared `libpad` real, that call is `sceDmaReset` inside `mgInit`. No game
behaviour is implemented; nothing from Chronicle is copied.

**WP1.1 Port build skeleton [decision]**
- Create: `port/CMakeLists.txt` (from Chronicle's post-0.4 file, renamed:
  `ct_options`, `ct_ps2`, `ct_host` via `kz_port_host_library`, `ct_port`
  with `kz_port_sce_sources(LIBS libvu0 libpad libmc sifdev sifrpc eekernel
  eekernel_threads libcdvd libgraph libdma libpkt libdev libmpeg libsdr
  modmsin sifdma)`, `ct_link_game`, `darkchronicle`, `CT_BUILD_TESTS`,
  `PORT_DEFINITIONS PORT`; no CREDITS, lang, glyphs, icon, dcdata),
  `port/src/tests/CMakeLists.txt` (GoogleTest, `kz_port_tests`, one game
  `smoke` case), `.gitignore` additions (`port/build/`, `data/`, `save/`,
  `.kazarov/`).
- Modify: `CMakeLists.txt` (accept `PC`: `enable_testing()`,
  `add_subdirectory(port)`).
- Inputs: `Chronicle/port/CMakeLists.txt` and `CMakeLists.txt` after WP0.4,
  `tools/kazarov/cmake/KazarovPort.cmake`.
- Acceptance: in the container, `cmake -S . -B port/build/pc -G Ninja
  -DPLATFORM=PC -DCMAKE_CXX_COMPILER=clang++` configures;
  `ninja -C port/build/pc ct_host` builds the shared host library;
  `ninja port_overrides.txt` runs `port_override.py list`. The game link
  passes after WP1.10.
- Depends: 0.5. Parallel-safe. Size: ~350.

**WP1.2 Kazarov configurations [mechanical]**
- Modify `kazarov.conf` (the six PC configs and aliases as Chronicle's;
  `KZ_WINDOWS_HOST_SCRIPT=tools/windows/kazarov.ps1`, `KZ_WINDOWS_CONFIGS`,
  `KZ_CONTAINER_CONFIGS`; defaults stay `ps2-pal` until phase 7;
  `KZ_RUN_EXE=.../darkchronicle`; existing hooks gated on `ps2-*`). Create
  `CMakePresets.json` (Chronicle's, display names only). Touch
  `build.sh`/`run.sh`/`*.bat` only where a comment names `ps2-pal` as the
  sole configuration.
- Inputs: `Chronicle/kazarov.conf`, `Chronicle/CMakePresets.json`,
  `tools/kazarov/README.md`.
- Acceptance: `./build.sh configs` lists seven; `./build.sh ps2-pal` matches;
  `bash -n kazarov.conf`; `cmake --list-presets` shows four.
- Depends: 1.1. Parallel-safe. Size: ~200.

**WP1.3 Windows host scripts [mechanical]**
- Create `tools/windows/acquire.ps1`, `common.ps1`, `configure.ps1`,
  `configure-tests.ps1`, `build.ps1`, `kazarov.ps1` from Chronicle's with
  `darkcloud` to `darkchronicle`, `DC_BUILD_TESTS` to `CT_BUILD_TESTS`,
  without the `dcdata` target (WP2.3 adds `dc2data`). These are build
  scripts, not port code, so a copy is right; a later Kazarov WP may host
  them with the project name as a parameter (noted in Q9).
- Acceptance: `pwsh -NoProfile -File tools/windows/acquire.ps1 -Root
  .kazarov/windows` populates `deps`; `.\build.bat windows-x64` reaches
  configure (links after WP1.10).
- Depends: 1.1. Parallel-safe. Size: ~300.

**WP1.4 port.h and runtime [mechanical]**
- Create `port/include/port.h` (Chronicle's post-0.4 file: `size_t`,
  `NULL`, Windows `u_long`, `STATIC_ASSERT` handling; `PS2_UNIMPLEMENTED`
  comes from `kazarov/port.h`), `port/src/runtime.cpp` (`__assert`,
  `exit__2`, `extern "C" void mwInit() {}`, `fptosi`/`fptoui` with MWCC
  saturation), `port/src/exitcodes.hpp`.
- Inputs: `Chronicle/port/include/port.h`, `Chronicle/port/src/runtime.cpp`
  (first 60 lines), `ps2/include/mw_runtime.h`, `types.h`, `common.h`.
- Acceptance: `clang++ -std=c++26 -fsyntax-only -include port/include/port.h
  -Iport/include -Itools/kazarov/include -Ips2/include -Ips2/include/sce
  -x c++ /dev/null` passes.
- Depends: 0.5. Parallel-safe. Size: ~120.

**WP1.5 Assembly guards in ps2/ [mechanical, PS2 gate]**
- Modify `ps2/src`: wrap each of the 54 definitions in `#ifndef PORT` /
  `#endif` on existing blank lines (or the doc comment's opening line and
  the blank line after the closing brace) so no other line moves: all 32
  `asm` functions in `mg_math.cpp` (including `static asm MulMatrix3`);
  `mg_frame.cpp` `test1`, `test2`, `mgInsideScreen`,
  `mgCFrame::GetLocalMatrix`, `GetBBoardMatrix`, `GetLWMatrix`,
  `GetLWMatrixTopBottom`, `GetDrawRect`; `gameutil.cpp` `testVUnew`,
  `MotionProc2`, `CheckHit`, `CheckHits`; `collision.cpp`
  `CCollisionMDT::PickUpNearPoly`, `pre_trance_normal`, `trance_normal`;
  `editcoll.cpp` `ClipBoxXZ`; `editmap2.cpp` `PlaneNormalXZ`;
  `mg_drawprim.cpp` `mgCDrawPrim::Data0`, `Data4`, `Vertex(float*)`,
  `Color(float*)`; `mg_visual.cpp` `SendDMA`.
- Modify `ps2/include/sce/eekernel.h`: `#ifndef PORT` around `ExitHandler`
  with `#else` `#define ExitHandler() ((void) 0)`.
- Inputs: Chronicle's `ps2/src/gameutil.cpp:400` and `:896` for placement.
- Acceptance: `./build.sh ps2-pal` then `python3 scripts/build/verify.py -c`
  byte-identical; `grep -c "#ifndef PORT" ps2/src/*.cpp` sums to 54.
- Depends: none (may run during phase 0). Not parallel with 1.10. Size:
  ~120 lines of directives.
- Status: done. 22 guards, not 54: each run of adjacent asm definitions
  shares one guard because consecutive definitions have no blank line
  between them to hold an `#endif` and an `#ifndef`. The guards cover all
  54 definitions and the `static MulMatrix3` forward declaration (with
  `Check_Point_Poly3`'s, mg_math.cpp:10-47, so `stubs/mg_math.hpp` must
  declare both). `ExitHandler`'s doc comment became one line to hold the
  `#else` branch. `./build.sh ps2-pal` matches (verify.py -c OK, 6872/6872
  functions).

**WP1.6 Stubs headers and asm-function stubs [mechanical]**
- Create `port/include/stubs/mg_math.hpp` (declares `MulMatrix3`),
  `stubs/mg_frame.hpp` (`test1`, `test2`), `stubs/gameutil.hpp`
  (`testVUnew`), `stubs/collision.hpp` (`pre_trance_normal`,
  `trance_normal`), `stubs/editmap2.hpp` (`PlaneNormalXZ`),
  `stubs/mglib.hpp` (`int VSyncCallBack(int)`, `void WaitVSync(int, int)`);
  `port/src/mg_math.cpp`, `mg_frame_asm.cpp`, `gameutil_asm.cpp`,
  `collision_asm.cpp`, `editcoll.cpp`, `editmap2.cpp`,
  `mg_drawprim_asm.cpp`, `mg_visual_asm.cpp`: one `PS2_UNIMPLEMENTED()`
  definition per guarded function, no tag.
- Inputs: the guarded signatures; the matching `ps2/include/*.hpp`;
  Chronicle's `port/include/stubs/frame.hpp` for the format.
- Acceptance: the units compile; WP1.10's link has no undefined reference
  to any of the 54 names.
- Depends: 1.4, 1.5. Parallel-safe. Size: ~500.

**WP1.7 SDK stubs Chronicle lacks [mechanical, Kazarov branch `shared`]**
- Create in `tools/kazarov/src/cpp/sce/stubs/`: `libdev.cpp` (`sceDevCons*`),
  `libmpeg.cpp` (every `sceMpeg*` referenced), `libsdr.cpp`
  (`sceSdRemote`, `sceSdRemoteInit`), `modmsin.cpp` (`sceMSIn_Init`,
  `PutMsg`, `PutHsMsg`), `sifdma.cpp` (`sceSifSetDma`, `sceSifDmaStat`,
  IOP heap), `eekernel_threads.cpp` (`CreateThread`, `StartThread`,
  `TerminateThread`, `DeleteThread`, `RotateThreadReadyQueue`,
  `CreateSema`, `WaitSema`, `SignalSema`, `DeleteSema`, `AddIntcHandler`,
  `EnableIntc`, `RemoveIntcHandler`, `AddDmacHandler`, `EnableDmac`,
  `DisableDmac`, `RemoveDmacHandler`, `EIntr`). Extend `port/sce/
  libcdvd.cpp` with aborting `sceCdSearchFile`, `Read`, `Sync`, `GetError`,
  `Break`, `Seek`, `St*`; `sifrpc.cpp` with `sceSifExitCmd` (succeeds) and
  aborting `BindRpc`/`CallRpc`/`CheckStatRpc`; `eekernel.cpp` with
  `ChangeThreadPriority`/`GetThreadId` (return 0); `libmc.cpp` with
  `sceMcSeek` if absent. All bodies `PS2_UNIMPLEMENTED();` unless stated.
  Register the new families in `KazarovPort.cmake`.
- Inputs: `ps2/include/sce/*.h`; `grep -rhoE "sce(Gs|Dma|Vif1Pk|GifPk|
  DevCons|Sif|Cd|Pad|Mc|Sd|MSIn_|Mpeg)[A-Za-z0-9_]*" ps2/src | sort -u`
  and the kernel names above.
- Acceptance: Chronicle still builds and tests green on the new `shared`
  commit (it does not select the new families); ChronicleTwo re-pins. The
  link in WP1.10 has no undefined SDK symbol.
- Depends: 0.3. Parallel-safe (Kazarov files only). Size: ~500.

**WP1.8 Game-side hardware stubs [mechanical]**
- Method: `grep -nE "0x1[0-2][0-9A-F]{6}\b|0x7000[0-9A-F]{4}|0x20000000|
  0x0FFFFFFF|DmaCH[0-9]|D_STAT|D_CTRL|IPU_|T0_(COUNT|MODE)" ps2/src/*.cpp`,
  map each hit to its enclosing non-static function (or the non-static
  caller of a static one), write `PORT_OVERRIDE` definitions calling
  `PS2_UNIMPLEMENTED()` in `port/src/<unit>.cpp`. Known set: `mglib.cpp`
  `VSyncCallBack`, `WaitVSync`, `mgInit`, `mgBeginFrame`, `mgEndFrame`,
  `mgSendPacket`, `mgGetNowFrameRate` if it reads T0; `mg_visual.cpp`
  `GetScrPad`, `mgCVisualMDT::CreateFacePacket`; `mg_shadow.cpp`
  `mgCShadowMDT::CreateRenderInfoPacket`; `movie.cpp` every function
  touching D_CTRL/D_STAT, D_ENABLE*, channel 3/4 CHCR, D4 MADR/QWC/TADR,
  IPU_CTRL/BP/CMD or uncached pointers (survey lines 190, 226-227,
  766-781, 790, 826-828, 903, 923-1027, 1036, 1151); `sceneload.cpp` if
  `T0_COUNT` is read. Packet tag constants (`0x30000000` REF) are not hits.
- Create: `port/src/mglib.cpp`, `mg_visual.cpp`, `mg_shadow.cpp`,
  `movie.cpp`, `sceneload.cpp` as needed.
- Acceptance: the grep over `port/build/pc/ps2_src/*.cpp` returns only
  constant definitions, comments or packet-tag writes; `port_override.py
  check` passes.
- Depends: 1.1, 1.4. Parallel-safe. Size: ~300.

**WP1.9 Main entry [mechanical]**
- Create `port/src/main.cpp`: `PORT_OVERRIDE int main(...)` (signature as
  `strip`/`check` accept against `ps2/src/main.cpp`'s `int main()`; `wmain`
  forwarder on Windows): `PathsInit(PathsConfig{"chronicletwo", "DC2_DATA",
  "DC2_SAVE"})`, `--data/--save/--headless/--frames/--offscreen` parsing
  (Chronicle's `Run` lines 120-150 as the model), `WindowInit(WindowConfig{
  "Dark Chronicle", "chronicletwo", no icon})`, `InputInit`,
  `gfx::RendererInit` (app name, logical 512x480, aspect 4:3, pipeline
  cache `save/pipeline_cache.bin`, progress callback), then
  `MainThreadPriority = 10` and `MainLoop()`. `InitCDFile()` is not called
  (WP2.4). After `MainLoop` returns: renderer, input, window shutdown.
- Inputs: `ps2/src/main.cpp`, `Chronicle/port/src/main.cpp` (`Run`,
  `wmain`), `tools/kazarov/include/gfx/gfx.hpp`, `platform/window.hpp`,
  `platform/paths.hpp`.
- Acceptance: with WP1.10, `darkchronicle --headless` prints the pipeline
  progress, then the `PS2_UNIMPLEMENTED` line naming `sceDmaReset` (reached
  from `mgInit`) and exits non-zero; on Windows a window appears first.
- Depends: 1.1, 1.4. Parallel-safe. Size: ~200.

**WP1.10 Clang compile fixes and first link [mechanical, PS2 gate]**
- Iterate `ninja -C port/build/pc darkchronicle`; for each error in a
  `ps2_src/` copy apply only Chronicle-sanctioned corrections in `ps2/`
  (split an initialisation a `switch` jumps over; `extern "C"`/`throw()`
  where linkage demands; `sizeof` for spelled-out sizes; SDK-true prototype
  corrections in `ps2/include/sce` where a shared `sce` source disagrees,
  `libvu0.h` first); where a correction is not standard C++ either way,
  override the function instead and list it. Missing SDK symbols go to
  WP1.7's files (Kazarov commit + re-pin); missing game names mean a stubs
  header is incomplete. `-Wno-*` on `ct_ps2` only for warnings Chronicle
  also disables.
- Acceptance: `ninja -C port/build/pc darkchronicle` links on Linux;
  `.\build.bat windows-x64` links; `./build.sh ps2-pal` byte-identical;
  Chronicle green on any Kazarov commit this WP produced; `git diff --stat
  ps2/` listed with justifications in the report.
- Depends: 1.1-1.9. Not parallel. Size: ≤ 1,000, mostly one-liners.

**WP1.11 Phase gate and docs [mechanical]**
- Create `docs/PC.md` (build instructions for three OSes, the override
  mechanism, the shared-code layout and pin flow of 3.5, the stub list by
  file), `.github/workflows/pc.yml` (Linux container build + `ctest`,
  Windows with the acquire script, macOS), a `smoke` ctest running
  `darkchronicle --headless --offscreen` expecting the abort exit code and
  `sceDmaReset` on stderr.
- Acceptance: `ctest --test-dir port/build/pc --output-on-failure` passes
  (host-side cases from `kz_port_tests` included, on lavapipe); CI green;
  `./build.sh ps2-pal` matches.
- Depends: 1.10. Size: ~300.

**Phase 1 status: done.**
- Kazarov `ce459c1` (main):
  - Aborting stub families: `eekernel_threads`, `libdev`, `libmpeg`,
    `libsdr`, `modmsin`, `sifdma`.
  - Additions to `libcdvd`, `sifdev`, `libmc` (`sceMcSeek`, `sceMcEnd`,
    `sceMcRename`), `libpad`, `libpkt`, `sifrpc` (`sceSifExitCmd` succeeds;
    an unbound client answers instead of aborting, because static
    constructors run before `main` on the host but inside `mwInit` after the
    IOP set-up on the PS2), `eekernel` (`ChangeThreadPriority`,
    `GetThreadId` return 0).
  - `sifdev.cpp` includes `<sifdev.h>` before host headers (glibc's
    `st_ctime` macros).
  - `sceMcOpen/Chdir/Mkdir/GetDir` and `scePadPortOpen` take their parameter
    types from each game's own header (`sce/sdk_params.hpp`): the two
    transcriptions differ, and correcting either changes MWCC's code for the
    callers (an experiment broke the match).
  - Chronicle's pin commit `706ce00e` declares `sceOpen` variadic in its
    `sifdev.h` (SDK-true; `ps2-pal` still matches). Chronicle linux-x64
    ctest: 281/281.
- WP1.1-1.4: `port/CMakeLists.txt` (`ct_options`, `ct_ps2`, `ct_host`,
  `ct_port`, `ct_link_game`, `darkchronicle`, `darkchronicle_tests`),
  `kazarov.conf` with the six PC configurations, `CMakePresets.json`,
  `tools/windows/*.ps1`, `port/include/port.h`, `port/src/runtime.cpp`
  (`mwInit`, `__assert`, `exit__2`, `rand`/`srand`, `fptosi`/`fptoui`,
  `__construct_new_array`), `exitcodes.hpp`, a minimal
  `platform/settings.cpp` and `identity.cpp` (no `config.json` yet).
- WP1.6: 55 guarded definitions (`mg_math` has 33, not 32) defined in
  `port/src/mg_math.cpp` and `*_asm.cpp`; five stubs headers.
  `mgUnitMatrix`, `mgZeroMatrix` and `mgZeroVectorW` are real C++ already,
  because static constructors call them before `main`.
- WP1.8: 46 `PORT_OVERRIDE` stubs in 19 files: `mglib` 6 (incl.
  `StoreImage`, dev-kit address 0x2100000), `movie` 14, `mg_visual` 5,
  `gamepad` 4 (`PAD_CAPTURE_BUFFER`, dev-kit address 0x3000000), `mg_shadow`
  2, `mg_sprite` 2, and one each in `mg_drawprim`, `visualmotion`, `water`,
  `sceneload`, `dng_event`, `dng_hud`, `dbg_font`, `funcpoint`, `map`,
  `sceneevent`, `menucls1`, `menucapt`, `gyorace`, plus `main`.
  Some are not hardware: functions clang cannot compile (MWCC varargs
  builtins, anonymous unions holding non-trivial members, 128-bit literals,
  `CFuncPoint`'s deleted assignment) are stubbed until their phase rewrites
  them.
- Deviation: the gate aborts in `mgInit` itself, not in `sceDmaReset`:
  `mgInit` writes DMAC channel and T0 registers directly, so it is a stub.
- Deviation: `scripts/port/header_fixups.py` builds a mirror of `ps2/include`
  in the build tree with two textual fixups: `CRedMarkModel::Draw` and
  `CLockOnModel::Draw` are declared `int`. MWCC let a `void Draw()` add a
  vtable slot beside the base's `int Draw()`; clang rejects that, and every
  standard spelling changes the PS2 vtables. On the port they override; their
  bodies are stubs.
- Link names: `stubs/dng_main.hpp` (`MainBuffer`, `BuffWorkData`,
  `EventCamera` to their `__2` names), `stubs/event_func.hpp`
  (`VectMatMul__2`), `Exit__2` to `Exit`; `linknames.cpp` (VU microprogram
  placeholders and `_gp`); `cameracontrol.cpp` (`CameraCtrlParam::operator=`,
  assembly-only in retail); `menudraw_primquad.cpp` (`PrimQuad<float>/<int>`).
- WP1.10 `ps2/` edits, all byte-identical: split initialisations a `switch`
  jumps over (`editmenu`, `effect`, `inventmn`, `mainloop`, `menuaqua`,
  `menuop`, `menusys`, `nd_meswin`, `title`); case-scope braces with hoisted
  declarations (`menusys` `MenuItemDebugDraw`, `menuop` `SubGameSaveKey`); a
  named union with an empty constructor (`fishing` `CharaControl`); enum
  casts in C++26 arithmetic (`inventmn`, `menusys`, `mg_tanime`); `u_long`
  spelled as declared (`memcard`, `mg_visual`); `mg_tanime.hpp` declaration
  order.
- Windows: `--allow-multiple-definition` (header functions inline everywhere
  but one unit), `-mno-constructor-aliases`, `index()` in `port.h`. Both
  open items closed in Phase 2: `eekernel.h`'s `CreateThread`,
  `TerminateThread` and `GetThreadId` get `Ps2*` link names
  (`header_fixups.py`), and `long64.py` makes `mgSetPkTEX0`'s `unsigned long`
  64-bit on every host.
- Verified: linux-x64 ctest 38/38 (5 skipped), including
  `Smoke.LaunchAbortsAtFirstHardwareCall`; windows-x64 builds, and the
  windowed run builds 504 pipelines and aborts in `mgInit`; its tests 45/45;
  `ps2-pal` matches (6872/6872).
- Not run: macOS, `pc.yml` CI.

Phase 1 parallel groups: G1 = {1.5} (during phase 0); G2 = {1.1, 1.4, 1.7}
(after 0.5); G3 = {1.2, 1.3, 1.6, 1.8, 1.9}; G4 = {1.10}; G5 = {1.11}.

### Phase 2: native foundations before the first draw

Goal: everything before the first draw is native: data, memory, timing,
input glue, saves, VU0 math. The abort stays in `mgInit` itself (its stub),
reached through the real sequence through `InitCDFile`, the arena,
`SaveData`, pads; the unit tests exercise each replacement.

**WP2.1 VU0 math: mg_math [mechanical]** Replace the 32 guarded functions in
`port/src/mg_math.cpp` with C++ reproducing the retail lane behaviour
(`mgDistVector*` `vsqrt` of 2/3-component sums; `mgClipBox*` sign tests
from `vsub`/`vmul` status flags; `mgInversMatrix` cofactor inverse with the
retail ordering; `mgApplyMatrixN_MaxMin`, `mgVectorMinMaxN` track bounds).
Tests in `port/src/tests/mg_math.cpp` including degenerate inputs. Inputs:
`ps2/src/mg_math.cpp`, Chronicle's `port/src/mathutil.cpp`, `vu0_ops.hpp`
(if `vu0_ops.hpp` proves generic, move it to Kazarov `port/sce/vu0_ops.hpp`
in this WP). Depends: 1.6. Parallel-safe. Size: ~900.

**WP2.2 VU0 math: asm blocks [mechanical]** Replace the guarded functions in
`mg_frame_asm.cpp`, `gameutil_asm.cpp`, `collision_asm.cpp`, `editcoll.cpp`,
`editmap2.cpp`, `mg_drawprim_asm.cpp` (`vftoi0`/`vftoi4` as truncation
toward zero after scaling), keeping the surrounding C++ unchanged. Tests for
`test1`/`test2`, `CheckHit`, `PlaneNormalXZ`. Depends: 1.6. Parallel-safe.
Size: ~1,200 (split 2.2a `mg_frame`+`mg_drawprim`, 2.2b the rest).

**WP2.3 Data extraction tool [decision]** `tools/dc2data/` from Chronicle's
`dcdata.hpp` (a tool, not port code): keep the ISO 9660 reader, replace
`ParseIndex` with the 12-byte `DATA_HD4` record, drop release fingerprints,
NTSC detection, `languages.json`, pack normalisation, floor plates. Extract
`MOVIE/*.PSS` to `data/movie/`, copy `SOUND.DAT`/`SOUND.HD3` whole to
`data/sound/` until WP5.3. Manifest, size checks, idempotent. Wire
`kz_before_launch` and the `dc2data` target in `build.ps1`. Tests: synthetic
HD4+DAT; `dc2data list` of the real ISO when present (8,753 entries,
`edit.cfg` 1133 bytes). Depends: 1.11. Parallel-safe. Size: ~800.

**WP2.4 dataread replacement [mechanical]** `port/src/dataread.cpp`
overriding `InitCDFile`, `SearchFile`, `LoadFile`, `LoadFile2`, `CDRead`,
`LoadFileBG`, `ReadBG`, `ReadBGSync`, `BreakReadBG`, `InitFileCache`,
`LoadFileCacheBG`, `GetDevType`, `WriteFile`: a case-folded index of
`data/`, device prefixes stripped, reads of exactly `size` bytes zero-filled
to 2048, background reads completed synchronously, `host0:` writes to
`save/host0/` through shared `sifdev`. `main.cpp` calls `InitCDFile`.
Tests: synthetic `data/` tree, pack lookup, missing file returns 0.
Depends: 1.11. Parallel-safe. Size: ~900.

**WP2.5 Config and host wiring [mechanical]** `port/src/platform/config.
{hpp,cpp}` (ChronicleTwo's `config.json`: `game.tick_rate`, `video.*`,
`audio.*`, `input.*`, filling the shared settings struct; no gameplay
options yet), `main.cpp` adds `ConfigLoad`, `ClockSetTickRate`, the pump
hook and `DisplayInit`. Tests: `platform_config` for this schema. Depends:
1.11. Parallel-safe. Size: ~500.

**WP2.6 Timing and threads [decision]** Kazarov `platform/clock` gains
thread hooks (`ClockAddTickHook(fn, arg)`, stepped once per tick inside
`ClockPump`) on branch `shared` with a test; Chronicle re-pins (unaffected).
Game side: `port/src/mglib_time.cpp` overriding `VSyncCallBack`,
`WaitVSync`, `mgGetVSyncCount`, `mgInitVSyncCallBack`, `mgSetRotateThread`
on the clock; `port/src/sce_threads.cpp` overriding nothing but providing
the real `CreateThread`/`StartThread`/`RotateThreadReadyQueue`/semaphores
as a Kazarov `sce/eekernel_threads_hooks.cpp` alternative family (selected
instead of the stub family): threads register as tick hooks, semaphores
are non-blocking counters. The now-loading hook's draw calls are gated by a
"renderer ready" flag until phase 4. Tests: a scripted spin on `sceGsSyncV`
advances the count; a registered thread runs once per tick. Inputs:
`ps2/src/mglib.cpp:300-400`, `nowload.cpp:180-300`, `gamepad.cpp:790-840`,
`fishing.cpp:1300-1380`, `tools/kazarov/include/platform/clock.hpp`. Depends:
2.5. Size: ~600.

**WP2.7 Pads and cards glue [mechanical]** `port/src/gamepad.cpp` overrides
`CreateGamePadThread` (a tick hook); the libmc round-trip test is
instantiated with DC2's 0x659C0-byte image and `sceMcSeek` to offset 0x45;
`platform_pad` reads a scripted press through `CGamePad`. Depends: 2.6.
Parallel-safe. Size: ~250.

**WP2.8 Memory model [decision]** `port/src/mg_memory.cpp` replacing
`mgCMemory` whole, `mgMEMORY_BLOCK` redefined in `port/src/mg_memory_port.
hpp` with a host pointer; `scripts/port/truncations.py` copied from
Chronicle, `docs/port/truncations.md` committed. Tests: stack and heap
modes with arenas above 4 GiB (`platform/memory` high path). Depends: 2.5.
Parallel-safe. Size: ~700.

**WP2.9 MainLoop replacement and boot gate [decision]** `port/src/mainloop.
cpp` overriding `MainLoop` with the retail sequence minus hardware: arena
setup with `uintptr_t`, `SaveData.Initialize`, `GamePad__2.Init()`, then
`mgInit` (still aborts), the per-frame loop with `ClockSyncV` for the debug
pause spin. Acceptance: `darkchronicle --headless --data data` aborts in
`mgInit` after `InitCDFile` has indexed `data/` (log line); all phase 2
tests pass; PS2 build matches. Depends: 2.1-2.8. Size: ~400.

**Phase 2 status: done.** Kazarov `main` is `a7674f4`; Chronicle `master`
and ChronicleTwo `master` both pin it.
- Kazarov `c5b74bc` (on `0b81463`, `c937490`): the fiber scheduler is the
  only `eekernel_threads` family (`sce/stubs/eekernel_threads.cpp` removed;
  `DIntr`/`EIntr` and the interrupt/DMAC handler stubs moved to the real
  family); `ClockPumping()`; a thread switch inside `ClockPump` aborts;
  `PathsReset` fixes `PathsXdg` in one process; `sceMcSeek`/`sceMcEnd`
  declared C-linked for every game. Chronicle does not select the family.
- Kazarov `a7674f4` (WP4.4a, early): `shaders/mesh_prog0.vert` implements
  `Vu_prog0` from its spec (four directional lights in model space, unlit,
  Phong under 0x008, four point lights under 0x010, vertex-colour
  multiply/add, `__REF_SPHERE` matcap under 0x100, 32-slot skinning with
  four weights, six-plane clip under the scissor flag, fog). Two mesh
  families (static, skinned) are precompiled only under
  `RendererConfig::prog0_meshes`; without it the 504 pipelines, their
  indices and `mesh.vert`'s SPIR-V are unchanged. Deviation: a new shader
  file instead of edits to `mesh.vert`, to keep Chronicle's SPIR-V
  byte-identical. `MeshConstants` grows past its old end by `Prog0Constants`
  (2,016 bytes).
- WP2.1/2.2 (`vu0`): every guarded function in `mg_math`, `mg_frame`,
  `gameutil`, `collision`, `editcoll`, `editmap2`, `mg_drawprim` audited
  against the retail asm; shared lane rules in `port/src/vu0_lanes.hpp`
  (game-side; a Kazarov lift is a later decision). Fixes: `mgCDrawPrim`
  `vftoi` overflow saturates to `INT_MAX`; perspective divides in `test2`,
  `mgInsideScreen`, `GetDrawRect` and `MotionProc2` stay finite at w = 0;
  singular `mgInversMatrix` stays finite. No `PS2_UNIMPLEMENTED` remains in
  these files.
- WP2.3/2.4 (`data`): `dc2data list` gives 8,753 records = 8,751 files +
  one duplicate + the terminator; `extract` is idempotent and
  manifest-checked, `check` verifies `data/` (8,762 files incl. movies and
  sound); Shift-JIS names are percent-encoded on disk. `dataread` indexes
  only the `DATA.DAT` files and reads `host0:` back from the save tree.
  `run.bat` now extracts like `run.sh` (`tools/windows/kazarov.ps1`).
- WP2.5/2.8/2.9 and Phase 1 open issues (`boot`): config change hook and
  unreadable-file guard; `mgCMemory` arenas record and log their high-water
  marks, tested above 4 GiB; `MainLoop` -Wall clean with the retail priority
  order. Decision: `long64.py` kept (line numbers preserved, literals and
  `%ld` untouched, retail `mgSetPkTEX0` and `password.cpp` proven 64-bit by
  test). `header_fixups.py` makes the COFF-duplicate functions inline,
  blanks MWCC-only pragmas and renames the kernel32 thread names.
  `docs/port/truncations.md` assigns every open round trip to a phase.
- WP2.6/2.7 (`time`): Decision: the fiber scheduler is kept (one OS thread;
  switches only in `RotateThreadReadyQueue`/`WaitSema`/`WaitVSync`-class
  calls, never inside `ClockPump`); `mgNowFrameRate` reads a wall-clock
  frame-load clock in T0 units.
- Verified: linux-x64 ctest 338/338 (5 skipped: mouse capture and TTF font
  cases), including `DataRead.RealDataIndexesTheDiscFiles` and
  `Dc2Data.RealDisc*`; windows-x64 tests 345/345 (5 skipped); `ps2-pal`
  matches; `darkchronicle --headless --offscreen --data data` logs
  `dataread: indexed 8751 files under .../data` then
  `mgInit: PlayStation 2 code is not implemented on PC` on Linux (lavapipe)
  and Windows (RTX 4090); 74 functions call `Ps2Unimplemented` (34 game, 40
  SDK), as `docs/PC.md` lists. Chronicle on `a7674f4`: linux-x64 ctest
  303/303, `ps2-pal` 100% matched, its 3-frame headless screenshot
  byte-identical to the `ce459c1` baseline, windows-x64 builds. Kazarov
  pytest 76 passed, 14 skipped.
- Open: `MeshConstants` is now 2,416 bytes for every mesh draw, Chronicle's
  included (W3 `prog0` moves the prog0/bone constants to a DC2-only
  buffer); GPU-skinned meshes are not pose-interpolated between ticks;
  `main.cpp` does not set `prog0_meshes` yet (W3); no Vulkan validation
  layer is installed on either host, so the gfx tests' "no validation
  messages" is vacuous; the p2-wip commits keep their `WIP:` subjects
  (`5db69a0`, Kazarov `0b81463`) because later pins reference them.

Phase 2 parallel groups: {2.1, 2.2, 2.3, 2.4, 2.5} then {2.6, 2.8} then
{2.7} then {2.9}. Phase 2 runs concurrently with phase 3.

### Phase 3: the VU1 specs

**WP3.1 VU1 disassembler [mechanical]** `scripts/port/vu1dis.py`: reads
the retail ELF (`rom/pal/extracted/iso/SCES_511.90`, via
`tools/kazarov/scripts/kazarov_elf`), slices `.vutext`/`.vudata` by the
symbol table (`ps2/config/pal/main.symbols.txt:7910-8059, 8971`), walks the
DMA tags and VIF codes (`MPG` gives load address and word count;
`UNPACK`/`DIRECT` in `My_dma_start0` printed as data), prints each 64-bit
pair as `upper | lower` from the full VU instruction tables (upper
including `[E]/[D]/[T]` and dest masks; lower including branches, `xgkick`,
`lq/sq/ilw/isw`, `iaddiu`, `fcand/fcset/fmand`, `clip`, `div/rsqrt/sqrt`,
`mfir/mtir`, `eleng/erleng/esum/esqrt/ersqrt`, `waitq/waitp`), labels from
the symbols file. Tests: known encodings round-trip. Output:
`port/build/vu1/<program>.txt`. Depends: none. Size: ~900.

Status: done. `scripts/port/vu1dis.py` (+ `test_vu1dis.py`, 31 unittest cases
incl. two on the retail ELF) reads the ELF through `kazarov_elf`, walks
DMA/VIF, decodes every pair (0 unknown words across the six programs; words
cross-checked against the split's `vutext.data.s`/`vudata.data.s`) and
writes `port/build/vu1/{prog0,prog_sdw,prog_3dsp,prog_wtr,progmain,dma_start0}.txt`.
Branch targets are checked against all MPG blocks of a program, since
Vu_prog0 (six MPGs) and Vu_prog_sdw (two) branch across them.

**WP3.2 VU1 behavioural specs [decision]** `docs/vu1/prog0.md`,
`prog_sdw.md`, `prog_3dsp.md`, `prog_wtr.md`, `progmain.md`,
`dma_start0.md` from the listings and the CPU-side packet builders
(`mg_visual.cpp:600-1400`, `visualmotion.cpp:400-700`, `mg_shadow.cpp`,
`mg_sprite.cpp:84-432`, `water.cpp:480-840`). Each: data memory map, entry
points (`MSCAL 0`, `MSCAL 2`, `MSCNT`) and persistent state, the per-vertex
pipeline with exact arithmetic (0x80 colour scaling, clamps, `vftoi4`
rounding, fog from 1/w, point-light falloff, env-map UVs, the clipper's
tests and interpolation, the scissor test, strip re-emission), the GIF tag
and registers emitted, open points, and hand-derived test vectors.
Depends: 3.1. Size: ~1,200 of prose.

Status: done (~3,000 lines). Findings that change the plan: `Vu_progmain` is
resident at micro 0x0000; `MSCAL 0` runs its setup (model-space light matrix,
handedness at 0x1E, guard band at 0x15/0x16) for every program, `MSCAL 2`
jumps to the swappable program at 0x0064. Vu_prog0 has four directional
lights (not three), Phong "real" lighting, four point lights, a normal-based
matcap (`__REF_SPHERE`), 4-bone skinning, back-face culling only under flag
0x04, and its 6-plane clipper only under the scissor flag 0x02. Fog
`F = offset + scale/w` clamped to [6th, 7th argument of `mgSetFogParam`].
Each spec lists suspected retail bugs and open points; the pipeline rulings
used (VF hazards interlocked, MAC flags of unwritten fields cleared,
same-pair `waitq` reads the new Q) are stated in each, and the few results
that depend on them are the first things to confirm with a PCSX2 trace.

### Phase 4: rendering

Goal: the game draws through the shared renderer; no VIF/GIF/GS code is
reached from the title, town and dungeon paths. Shader and renderer
extensions are Kazarov commits (branch `shared`, Chronicle re-pinned and
green each time); the game-side replacements are ChronicleTwo commits.

**WP4.1 mglib core [decision]** `port/src/mglib.cpp` (absorbing the 1.8
stubs): `mgInit` (screen size, `mgScreenOffx/y`, render info defaults; the
`My_dma_start0`/`Vu_progmain` facts from the spec as initial `DrawState`:
TEST, ALPHA 0x44, TEXA), `mgInitVif1Packet`/`mgSetPacketBuffer`/
`mgSetDataBuffer` (host arenas for per-object data), `mgBeginFrame` (clear
colour and depth, main target), `mgEndFrame` (`ClockWaitNextTick`, present,
`mgPickZBuff` from `ReadDepth`), packet begin/end/send/wait (bookkeeping),
`mgSetRenderInfo`/`SetRenderInfo`/`SetViewMatrix` (real projection from
fov/near/far/window aspect; the 2048-centred matrices still filled for CPU
readers), `mgFlushRenderInfo`, `mgSetPkTextureRepeat`, `mgSetPkFrameBuffer`
(render target on a texture), `mgSetPkMoveImage` (copy/blit),
`mgSetPkClearScreen`, `mgStoreImage`/`mgStoreZBuffImage` (readback),
`mgDrawDirect`, `mgBeginDrawShadow`/`mgEndDrawShadow` (share_main_depth
target, composite), `mgSendVuProg` (pipeline family), `mgInitFont`/
`mgCloseFont` (`sceDevCons` replaced by the shared overlay font). Tests: a
headless frame with a clear and a readback. Inputs: `ps2/src/mglib.cpp`,
`docs/vu1/progmain.md`, `dma_start0.md`, Chronicle's `port/src/mglib.cpp`,
`mglib_port.hpp`. Depends: 2.9, 3.2. Size: ~1,500 (split 4.1a frame/state,
4.1b images/shadows).

**WP4.2 Textures [mechanical]** `port/src/mg_texture.cpp` overriding the
VRAM-touching members of `mgCTextureManager`/`mgCTextureBlock`/
`mgCTexture`: `EnterTexture(raw)`, `EnterTexture(TM2_head*)`, `EnterIMGFile`,
`mgLoadImage`, `ReloadTexture` (registry, no-op upload), `ReloadCLUT`
(palette update), `Bilinear` (sampler), `GetRemainVRAM` (infinite). TIM2:
8-bit to R8 + palette, 4-bit to R8, 16/24/32 to RGBA8, up to 4 mips, CLUT
after pixels, TEXA for 24-bit; IM2 swizzle undone on upload; the PSMT8H
Z-buffer trick dropped. Render-to-texture on first `mgSetPkFrameBuffer`.
Tests: synthetic TIM2 of each type (Chronicle's `tex_decode` as the model;
if the TIM2 decoder in Chronicle's `texture.cpp` is generic, lift it to
Kazarov `gfx/tim2.cpp` here). Depends: 4.1. Parallel-safe. Size: ~1,200.

**WP4.3 Immediate primitives and 2D [mechanical]** `port/src/mg_drawprim.
cpp` (`mgCDrawPrim` packet-writing members into `Draw2D`/`DrawMesh` batches
with GS `DrawState`; FST means 12.4 texel UVs; `Coord(1)` is raw GS space,
logical = (gs - mgScreenOff) / 16), `mgCDrawManager` (`BeginDraw`,
`AddPacket`, `PreEndDraw`, `ReloadTexture`, `Draw`), `prespr.cpp`,
`mg_sprite.cpp` `mgCSprite`, `dbg_font.cpp`'s `sceDevCons` use,
`menudraw.cpp:5951-6044` frame grab (`SnapshotFrame`, CPU box filter,
re-upload). Tests: a textured sprite's pixels. Depends: 4.1, 4.2.
Parallel-safe with 4.4-4.7. Size: ~1,400 (split 4.3a DrawPrim, 4.3b
manager/sprite/grabs).

**WP4.4 Vu_prog0: models and skinning [decision]** Kazarov: `mesh.vert`
gains Dark Chronicle paths (point lights with the spec's falloff, env map
`__REF_SPHERE`, `__LIGHTINGC_MUL/ADD`, real lighting `0x100`, 32-bone
skinning with 4 weights) behind specialisation constants; `MeshConstants`
gains the fields; Chronicle unaffected (constants off), re-pinned green.
Game side: `port/src/mg_visual.cpp`, `visualmotion.cpp`: `DataAssignMDT`/
`DataAssignMotionMDT` build GPU meshes once, per-frame `CreatePacket`/
`CreateFacePacket` rebuild transient meshes, `CreateRenderInfoPacket`/
`CreateExtRenderInfoPacket` fill constants (matrices, 3 lights + colours,
ambient x obj_alpha, object colour, material, point lights, eye position,
flags 0x26 as specialisation choices, bones), `SetMaterialRef`/`SetPModeRef`
set `DrawState`, `Draw` submits; clipping via clip planes and guard-band
scissor. Tests: the spec's test vectors on a tiny mesh headless. Depends:
4.1, 4.2, 3.2. Size: ~1,800 (split 4.4a shader paths [Kazarov], 4.4b static
MDT, 4.4c motion/skinning).

**WP4.5 Vu_prog_sdw: shadows [decision]** `port/src/mg_shadow.cpp`:
`mgCShadowMDT::CreateFace`/`CreatePacket`/`CreateRenderInfoPacket`/`Draw`
absorbing `SetShadowData`: project the shadow mesh toward the drop-shadow
plane per the spec, draw the volume into the `share_main_depth` shadow
target with ALPHA 0x68/0x62 counting (FIX 0x80), Z GEQUAL, no Z write;
`mgEndDrawShadow` composites with TEXA AEM. Tests: a quad over a plane
produces a darkened footprint. Inputs: `docs/vu1/prog_sdw.md`,
`ps2/src/mg_shadow.cpp`, `mglib.cpp:1001-1072`, Chronicle's
`visualshadow.cpp`/`shadowclip.cpp`. Depends: 4.1, 3.2. Size: ~700.

**WP4.6 Vu_prog_3dsp: billboards [mechanical]** `port/src/mg_sprite.cpp`
`mgC3DSprite` packet members: per sprite {pos, w/h, sin/cos, colour, uv0,
uv1} expanded into a camera-facing quad per `docs/vu1/prog_3dsp.md`, one
batch with fog. Tests: a sprite at the origin lands at the centre. Depends:
4.1, 3.2. Size: ~500.

**WP4.7 Vu_prog_wtr: water [mechanical]** `port/src/water.cpp`
`CWater::CreateRenderInfoPacket`/`CreatePacket`/`Draw` (`Hamon`/`Shake`
stay): strips into a `kMeshScreenUv` mesh with the slope-to-UV formula from
`docs/vu1/prog_wtr.md`, PSMCT24 with TEXA 0x80 as `DrawState`;
`CFireRaster::Draw` through `mgCDrawPrim`. Depends: 4.1, 4.2, 3.2. Size:
~500.

**WP4.8 Texture animation [mechanical]** `port/src/mg_tanime.cpp`
`TexAnime`: COPY/SCROLL/WAVE as `CopyTexture` with palette updates;
true-colour records as draws into the texture's target. Tests: a COPY
record moves pixels. Depends: 4.2, 4.3. Size: ~500.

**WP4.9 Screen effects, outline, photo, loading [mechanical]**
`outline.cpp` (`COutLineDraw::Draw` with the two static helpers'
behaviour), `screeneffect.cpp` (`DepthOfField` ping-pong downsample then
depth-tested strips; `LensFlare`), `photo.cpp:296-346` readbacks,
`nowload.cpp` drawing (its frames through the 2.6 hook). Tests: DOF on a
two-depth scene. Depends: 4.1-4.3. Size: ~900 (split outline+screeneffect
/ photo+nowload).

**WP4.10 Frame culling and sky [mechanical]** `mg_frame.cpp`
`mgCFrame::Draw(u_int*)` and `mapsky.cpp`: run, override only what fails.
Depends: 4.4. Size: ~300.

**WP4.11 Phase gate [mechanical]** `darkchronicle --headless --frames 300
--screenshot out.png --data data` reaches the title; `--input` reaches the
opening and the first town; the `objdump`/`addr2line` check from
Chronicle's `docs/PC.md` shows no `Ps2Unimplemented` caller in `mg*`,
`water`, `outline`, `screeneffect`, `font`, `menudraw`; PS2 build matches;
CI green; Chronicle green on the final Kazarov pin. Size: ~100.

**Phase 4 status: done (W3, pushed with Phases 5 and 6).** ChronicleTwo
`master` on Kazarov `main` `f1b8e80`.
- WP4.1/4.2 (W2): the `mglib_port.hpp` seam, the texture registry, TIM2.
- Ticks as display lists (`present-core`, rule 14): every game frame is
  recorded and rendered once canonically; display frames between ticks are
  interpolated at the elapsed fraction; `--display-per-tick N`, `--window WxH`,
  `--show-fps`, the `video.*` keys; culls from the visible extent; the 3D
  field of view follows the window (`AspectMode::Fill`), `aspect = 4:3`
  letterboxes.
- WP4.3/4.6/4.8 (`draw2d`): `mgCDrawPrim` as a host primitive builder (no GIF
  register-list decoding), the draw manager replayed from a host table,
  sprites and 3D sprites in floats, TexAnime through copies and registered
  targets, the menu frame grab as a frame target, `PrintDirect`.
- WP4.4b/c, 4.10 (`prog0`): MDT visuals as GPU meshes through Vu_prog0's
  pipelines, with its constants in a DC2-only set 2 block (`MeshConstants`
  back to 400 bytes for Chronicle) and a 32-matrix model-space bone palette
  per draw; `renderer.prog0_meshes` is on.
- WP4.5/4.7/4.9 (`fx-shadow`): z-fail stencil shadow volumes, water as a
  screen-UV mesh over a frame grab, outline, depth of field and lens flare;
  the VU1 packing maths live only as test oracles (`native_gate.py` keeps
  them out of the runtime, also in CI).
- Pointers (`uptr`, W2.u): addresses kept in integers are `uptr` in
  `ps2/src`; `truncations.py --check` clean (0 open round trips in linked
  code; 15 narrowing sites in compiled `ps2/` code, each with an owner).
  Stride fixes found at integration: the draw manager's pointer tables,
  `CScene::ClearStack`, `mgCTextureAnime::NewTexAnimeGroupData`;
  `CScriptInterpreter::GetArg` indexes at pointer width; `CFuncPoint`'s copy
  comes from the header mirror.
- Verified: linux-x64 ctest 774/774 (one real-data case passed on rerun after
  a load timeout); windows-x64 tests 780/780; `ps2-pal` `SCES_511.90: OK`;
  14 `Ps2Unimplemented` callers (9 game, 5 SDK), none in `mg*`, `water`,
  `outline`, `screeneffect`, font or `menudraw`. Real data, headless, Linux
  and Windows: 300 frames show the language select; with an input script the
  title over its 3D map, byte-identical with `--display-per-tick 4`; the
  attract loop (title and the opening movie; the W3 record called it "the
  opening event with skinned characters", which was wrong). Chronicle on
  `f1b8e80` (rebased on upstream `109c6eff`): ctest 352/352, `ps2-pal` 100%,
  screenshot byte-identical, Windows builds. Kazarov pytest 93 passed,
  14 skipped.
- Not reached (Phase 7): the opening and the first town by `--input`.
  START at the title enters the next mode, then frames stop advancing.
  Not run: the 2560x1440 windowed FPS run, the aspect matrix screenshots.

Phase 4 parallel groups: {4.1} then {4.2} then {4.3, 4.4, 4.5, 4.6, 4.7}
then {4.8, 4.9, 4.10} then {4.11}. Phase 5 runs beside phase 4.

### Phase 5: audio

**WP5.1 Audio output and shared extension points [decision]** `main.cpp`
starts `AudioOutputStart(audio::DefaultMixer())` (shared, no copy). Kazarov:
`audio/hsmsg.{hpp,cpp}`, the MODHSYN HS message decoder (F9 volume/pan, FD
key-on/off, the pitch/id fields `sound.cpp:900-925` fills) lifted from
Chronicle's `gameutil_midi.cpp` if that code is format-only, else written
new; Chronicle may adopt it later. Tests: a synth sine mix; HS message
round-trip. Depends: 2.5. Size: ~400.

**WP5.2 CSound and the sequenced path [decision]** `port/src/sound.cpp`,
`snd_mngr.cpp` (semaphores gone, `.snd` pack entries into the mixer),
`ezmidi.cpp` (`ezMidi` command dispatch to the sequencer; commands
enumerated from `ps2/src/ezmidi.cpp` and `sound.cpp`), `TransHdBd` (bank
registration), `LoadSeq`, SE messages through `hsmsg`, reverb, master
volumes. Tests: a synthetic HD/BD/SQ plays a note through `CSound`.
Depends: 5.1. Size: ~1,200.

**WP5.3 SOUND.HD3 and the stream format [decision]** Establish the layout
of `SOUND.HD3` (354,912 and 86,848 bytes) and the stream encoding from the
files, the names the game sends (`sound.cpp:931-941`, `event_func.cpp:
13715-13729`), and `EZBGM.IRX` from `MODULES/` disassembled for
understanding (container MIPS objdump; nothing copied). Output:
`docs/SOUND_DAT.md` (record layout, stream header, block encoding); then
`tools/dc2data` extracts entries to `data/sound/<name>`. Depends: 2.3.
Size: ~400 plus the doc.

**WP5.4 Streams [mechanical]** Kazarov `audio/stream.{hpp,cpp}`: a channel
that decodes a streamed-VAG entry's blocks into the mixer with volume,
pause, loop and level reporting (generic Sony streaming; Chronicle
re-pinned, unaffected). Game side: `port/src/ezbgm.cpp` overriding
`ezBgm`/`ezBgmInit` with the command table (`0x10` close, `0x30`, `0x40`
preload, `0x50` play, `0x60` stop, `0x70`, `0x80` volume `(l<<16)|r`,
`0x8000` standby mode, `0x8020` open, `0x80B0` state, `0x80C0`, `0x80D0`
info, `0x80E0` level, `0x80F0` open-from-pack). Voice `.WV`/`.VPK` opens
fail as on the PAL disc. Tests: open/play/stop a synthetic stream.
Depends: 5.3, 5.1. Size: ~700.

Phase 5 parallel groups: {5.1, 5.3} then {5.2, 5.4}.

**Phase 5 status: done.**
- WP5.1/5.3 (W2): `audio_init`, `hsmsg`, SOUND.HD3/SOUND.DAT extraction.
- WP5.2/5.4 (`audio-game`): `CSound`, ezMidi, ezBgm and `sndLoadSound` on
  the shared mixer (banks selected by CC 0, HS pitch, per-core volume);
  SOUND.DAT streams on Kazarov's new stream channels (`audio/stream.*`).
- Verified: `DC2_AUDIO_WAV` at the title is non-silent (RMS about 750, peaks
  near 24,000); stream open/play/stop tests green; Chronicle's audio tests
  green on the same Kazarov.
- Open: end-of-stream state held 1 s as a stand-in for the driver drain;
  `SndInReverb` is a no-op (streams bypass reverb); movie audio stays on
  mixer port 5, not a stream channel.

### Phase 6: movies

**WP6.1 PSS demuxer [mechanical]** `port/src/video/pss.{hpp,cpp}`: pack
and system headers, PES for video stream 0 and private stream 1 PCM (ids as
`movie.cpp`'s `sceMpegAddStrCallback` registers), chunks with PTS. First
run on `L5LOGO.PSS` reports the sequence extension flags (progressive or
not). Tests: a hand-built two-packet stream. Depends: none. Size: ~400.

**WP6.2 Minimal LGPL FFmpeg acquisition [mechanical, Kazarov branch
`shared`]** Create `tools/kazarov/scripts/build/kz-ffmpeg` (downloads the FFmpeg
7.1.1 tarball from ffmpeg.org, checks its SHA-256, configures with the
flags of 3.9, builds `libavcodec.a`/`libavutil.a` into `--out DIR`, writes
a stamp with the version and flags so `kz-cached` can skip it),
`cmake/KazarovFfmpeg.cmake` (`kz_ffmpeg(target)`: `KZ_FFMPEG_DIR` default
`.kazarov/ffmpeg/<os>-<arch>`, static libraries on Linux/macOS, the BtbN
import libraries and DLLs on Windows, includes, `-lpthread -lm` on Linux),
a Dockerfile layer running `kz-ffmpeg --out /opt/kazarov/ffmpeg` with
`nasm` installed, a `kz_before_build`-style hook documented for macOS
(`kazarov.conf` calls `kz-ffmpeg` under `kz-cached`), and a pytest in
Kazarov's suite that checks the configure line contains no `--enable-gpl`
or `--enable-nonfree` and that the stamp round-trips. ChronicleTwo side:
`tools/windows/acquire.ps1` gains the BtbN `win64-lgpl-shared` asset for
the same release with its SHA-256 (the `lgpl` variant, verified by the
`LICENSE.txt` in the archive naming LGPL), `build.ps1` copies
`avcodec-61.dll` and `avutil-59.dll`, `configure.ps1` passes
`KZ_FFMPEG_DIR`; `port/CMakeLists.txt` calls `kz_ffmpeg(ct_port)`.
Acceptance: `kz-ffmpeg` builds in the container and on macOS; `ffmpeg`'s
`configure` log shows `License: LGPL version 2.1 or later`; a link test
program calls `avcodec_version()` on all three OSes; Chronicle unaffected
and green on the pin. Depends: none. Size: ~400.

**WP6.3 libavcodec wrapper and frame output [mechanical]**
`port/src/video/mpeg2_decoder.{hpp,cpp}`: owns an `AVCodecParserContext`
(`mpegvideo`) and an `AVCodecContext` (`AV_CODEC_ID_MPEG2VIDEO`,
single-threaded, `AV_PIX_FMT_YUV420P` expected), takes ES chunks from the
demuxer, returns decoded pictures in display order with PTS;
`port/src/video/yuv.{hpp,cpp}` converts 4:2:0 planes to RGBA (BT.601
limited range, the IPU's conversion); `port/src/video/pcm.{hpp,cpp}` turns
the private-stream-1 payload (PCM, or ADPCM if the stream report from
WP6.1 says so) into mixer samples. The only FFmpeg headers included are
`libavcodec/avcodec.h` and `libavutil/*`; no `libavformat`. Tests: the
wrapper rejects a non-MPEG-2 stream cleanly; with data present, the first
I-picture of `L5LOGO.PSS` decodes to the expected size and its average
luma matches a stored value; `yuv` against a hand-computed pixel.
Depends: 6.1, 6.2. Size: ~500.

**WP6.4 movie.cpp replacement [decision]** `port/src/movie.cpp`
overriding the player's interface (from `ps2/include/movie.hpp`): file from
`data/movie/`, demux+decode pumped per tick with the picture queue driven
by PTS against the clock, picture into a texture drawn full-screen, audio
into a shared mixer stream; threads, handlers and registers gone.
`movieviewlp.cpp` unchanged. Tests: scripted play of `L5LOGO.PSS` for 30
frames with a screenshot. Depends: 6.3, 4.3, 5.1. Size: ~800.

**Phase 6 status: done.**
- WP6.1/6.2 (W2): the PSS demuxer and the minimal LGPL FFmpeg (`mpeg2video`
  only, `License: LGPL version 2.1 or later`).
- WP6.3/6.4 (`movies`): `CMovie` on the host: libavcodec's MPEG-2 decoder,
  BT.601 to RGBA into the game's `moviework` texture, the PCM soundtrack into
  the mixer, pumped by the game's frames against the clock; no threads,
  handlers or registers. Only libavcodec and libavutil are linked.
- Verified: the logo sequence of a real-data headless run shows
  `L5LOGO.PSS`'s frames (Level-5 logo at frame 540 of the scripted run);
  `movie_test` plays 30 frames to a PNG.

### Phase 7: integration, decoupling, options

Status (W4, partial; details and resume steps in `docs/port/HANDOFF.md`):
WP7.1/7.2 largely done in W3-W4 (display lists, interpolated display frames
including bone palettes, window aspect, letterbox clip, HUD anchors, frame
grabs in frame targets; measured 215-404 FPS at 2560x1440 with ticks at
50/s). WP7.4 started: New Game's background read, the opening's character
arena (`BaseCharacter[7]`, script budgets) and the red-mark/lock-on draws are
fixed; the run reaches "Confirm Max's costume?" and stops in the opening
event on a frame-tree loop. Sprite sampling matches the GS at texel
boundaries (font bleed, tile seams). WP7.3, 7.5, 7.6 and the debug mode are
open.

**WP7.1 Presentation decoupling [decision]** Game frames as display lists;
`mgEndFrame` presents at the display rate with interpolation where the mesh
constants allow (`RenderList`); `mgFrameRate` honoured as ticks per game
frame; `video.max_fps`, `present_mode`; FPS overlay. Depends: 4.11. Size:
~800.

**WP7.2 Resolution and aspect [mechanical]** 3D at window resolution
(projection from the window aspect, `aspect_y = 2096/(3w)` replaced), 2D in
512x480 logical at 4:3 with letterboxing, `video.aspect`, `mgPickZBuff` and
`GetDrawRect` in logical space. Depends: 7.1. Size: ~400.

**WP7.3 Options and first run [mechanical]** `port/src/platform/firstrun`
for Dark Chronicle's files, `config.json` documented, the CLI options as
Chronicle's, `glyphs`/`ttffont` consumed if the options UI needs them.
Depends: 2.5. Size: ~600.

**WP7.4 Long-tail sweep [mechanical, repeated]** Drive TITLE, EDIT (georama,
shop, invention, photo), DUNGEON (floors, spheda, ridepod), fishing,
Gyorace, buggy, menus, saves with scripted input; replace each
`Ps2Unimplemented` hit from its unit with the pattern of its phase. Each
round ≤ 1,000 lines, named by the units it covers. Depends: 4.11, 5.4, 6.4.

**WP7.5 64-bit audit and crutches [mechanical]** `truncations.md` has no
unresolved round trip in linked code; PIE; arenas above 4 GiB in tests.
Depends: 7.4. Size: ~400.

**WP7.6 Docs, CI, Kazarov merge [mechanical]** `docs/PC.md` complete; CI
runs the headless boot with data when available; the `shared` branch is
merged to Kazarov `main` by PR and both games re-pin to the merge commit.
Depends: 7.4.

## 5. Verification gates

| Check | Command |
|---|---|
| PS2 build matches retail | `./build.sh ps2-pal` in the container, then `python3 scripts/build/verify.py -c` |
| Linux build and tests | `./build.sh linux-x64` then `(cd port/build/pc && ctest --output-on-failure -j4)` on lavapipe |
| Windows build | `.\build.bat windows-x64` |
| macOS build | `./build.sh macos-arm64` with `VK_DRIVER_FILES` for MoltenVK when running |
| Chronicle on every Kazarov pin | `Chronicle: ./build.sh linux-x64 && ctest`, `./build.sh ps2-pal`, `ps2-ntsc`, `pc.yml` green, before ChronicleTwo pins the same commit |
| Override integrity | `port_override.py check` in the build; `objdump -d darkchronicle \| grep -c Ps2Unimplemented` against the documented stub list |
| Headless run | `darkchronicle --headless --frames N --screenshot out.png --data data` reaches the phase's target (1: `mgInit` abort after pipelines built; 2: the same after `InitCDFile` indexed 8751 files; 4: title screenshot; 6: movie screenshot; 7: town and dungeon by `--input`) |
| Warnings | `port/src` and `tools/kazarov/port` build `-Wall` clean; `ps2/` diffs listed with justifications |

Tests are GoogleTest cases; host-side ones live in Kazarov and run in both
games through `kz_port_tests`; game-side ones in `port/src/tests`.
Fixtures are generated in code; tests using real `data/` skip without it.

## 6. Risks and open questions

**Risks**

- **Two consumers, one branch.** Every Kazarov change for DC2 must keep
  Chronicle green before ChronicleTwo pins it. The gate above makes that a
  step of each Kazarov WP, which slows DC2-only extensions; the mitigation
  is specialisation constants and selectable `sce` families so Chronicle's
  compiled code does not change.
- **SDK header transcriptions differ.** Shared `sce` sources compile against
  each game's `ps2/include/sce`; `libvu0.h` (40 vs 45 functions) and
  `libmc.h` (`sceMcSeek`) are the known cases; WP1.10 finds the rest and
  corrects transcriptions to the SDK.
- **VU1 spec fidelity.** Phase 4 is only as right as `docs/vu1/*.md`; the
  disassembler is tested first, each spec carries test vectors, and PCSX2
  screenshots are the review tool.
- **`Vu_progmain`'s role** is unknown until disassembled; if it is a resident
  program `Vu_prog0` calls, the prog0 spec and WP4.4 absorb it.
- **`SOUND.HD3` format** is unknown; until WP5.3 lands streams are silent and
  `StreamGetState` reports stopped.
- **FFmpeg licensing and provenance.** The port must never link a GPL
  build: the distro and Homebrew packages are out, and the Windows archive
  must be the `lgpl` variant. The configure-line check in WP6.2's test and
  the pinned SHA-256s are the guard. The BtbN autobuild tags rotate; the
  pinned tag must be one that stays published (a dated `autobuild-*`
  release, not `latest`). If BtbN stops publishing LGPL variants, the
  fallback is cross-building `kz-ffmpeg` in the container with llvm-mingw.
- **FFmpeg API drift.** The wrapper uses the send/receive packet API that
  has been stable since FFmpeg 4; the DLL names (`avcodec-61`, `avutil-59`)
  are tied to 7.1 and move with any version bump.
- **Now-loading thread** draws its own frames while the main thread loads;
  as a tick hook it draws inside the load path's spins; loads that never
  spin show no progress.
- **Arena sizes.** Host `sizeof` exceeds the PS2 `STATIC_ASSERT` sizes;
  headroom is measured per arena (WP2.8 logs peak use), not guessed.
- **PAL timing constants** (262 lines per field in the CPU meter) are replaced
  by wall-clock measurement in the same units.
- **Interlace and flicker filter** are not reproduced; visuals relying on the
  half-line offset are corrected in their unit.
- **Windows `u_long`.** `port.h` makes it `u64`; `password.cpp` and anything
  spelling `unsigned long` is caught by WP1.10 and overridden.

**Decisions taken** (from the coordinator): Q1 names as in 3.1 and 3.4;
Q2 `ExitHandler` guarded in `eekernel.h`; Q3 an existing MPEG-2 decoder:
a minimal LGPL build of FFmpeg's `libavcodec` (3.9), static on Linux and
macOS, the BtbN LGPL DLLs on Windows; Q4 renderer, audio, shared platform
and shared sce move to Kazarov (3.5); Q5 branch `shared`, both games pin
the branch commit until the PR merges; Q6 default 50 Hz tick with
`mgFrameRate` semantics preserved; Q7 `libvu0` real from Kazarov in phase 1;
Q8 `EZBGM.IRX` may be disassembled for format understanding.

**Still open for the user**

- **Q12 Repository licences.** Neither Chronicle nor ChronicleTwo has a
  `LICENSE` file; Kazarov is MIT. LGPL `libavcodec` is compatible with
  either an MIT licence or none, but the port's own licence should be
  stated before a release that ships FFmpeg (the LGPL notice and the
  FFmpeg source or offer must accompany binaries).
- **Q9 Windows build scripts in Kazarov.** `tools/windows/*.ps1` are copied
  per game in this plan (they are build scripts, not port code). They could
  live in `tools/kazarov/scripts/` with the project and executable names read
  from `kazarov.conf`; worth one WP if a third copy ever appears.
- **Q10 `port/src/video` location.** Written in ChronicleTwo; move to
  Kazarov `port/video` if a second consumer appears, or now for symmetry
  (one extra WP in phase 6).
- **Q11 Discord presence.** Chronicle's IPC code is generic but its client
  id and assets are not; sharing it needs a `PresenceConfig` parameter. Not
  in this plan unless wanted.
