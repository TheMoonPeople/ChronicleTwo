# nowload: reverse-engineering notes

Unit at 0x30E5C0-0x30F890 plus `__sinit_nowload_cpp` (0x37ADF0). Three features: the threaded
loading screen (progress bar), the pause screen, and `SCElogoFade` (boot logo/text fade and title
language select). No first-game counterpart: the first game's `nowload.hpp`
(`/home/adubbz/development/chronicle/ps2/include/nowload.hpp`) is an unrelated VSync-callback loading
screen; nothing was carried over.

## NowLoadingInfo (0x3C)
Size: `nowload` in dng_main is `size:0x3c` in main.symbols.txt, `LoadInfo` here is 0x3C too
(the BSS slot is 0x40 for alignment). Constructor `__ct__14NowLoadingInfoFv` (0x30ECB0): calls
`mgCMemory::Init` on `this+8`, then `+0x0 = -1`, `+0x4 = 0`, `+0x38 = 0`. Body order is Init first,
so the mgCMemory member's inline ctor (`mgCMemory() { Init(); }`) runs, then the body stores.

| Off | Field | Evidence |
|---|---|---|
| 0x00 | `int tex_block` | passed to `ReloadTexture(int)`, `GetTexture("loading", int)`, `EnterIMGFile(..., int, ...)`, `DeleteBlock(int)`. Callers set 0xCE (EditInit), 0x51 (InitDungeonMain). |
| 0x04 | `int unk_4` | set to 1 by both callers, 0 by ctor; never read in nowload (only copied). |
| 0x08 | `mgCMemory memory` | ctor Init; callers `stSetBuffer` on it; CreateNowLoading obtains the next loading buffer through `stGetTop()` and calls `Alloc(&memory, qwords)`. mgCMemory is 0x30 (mg_memory.hpp). |
| 0x38 | `int step_count` | divisor in `ProgBarWidthStep = 0.2f / step_count` and `NextProgBarWidth = (ProgBarCnt+1)/step_count`; clamp for ProgBarCnt. Callers set 15 (EditInit) and 10 (dungeon). |

CreateNowLoading copies the whole struct to `LoadInfo` word by word (struct assignment `LoadInfo = *info;`).

## PAUSE_INFO (0x8)
`PauseInfo` sbss is 8 bytes; PauseStart copies two words. Callers (EditLoop, LoopDungeonMain) build
`{0 or 1, MainScene__2 / DngMainScene}` on the stack.
- 0x0 `int event_skip`: set to 1 when `CheckEventSkip()` is true (event running in EditLoop
  ControlMode 2, or DngStatus 2). PauseLoop: if 1, the "skip" texture is drawn 0x2E tall instead of
  0x16 and pad button 0x16 calls `SkipEventStart()` and ends the pause.
- 0x4 `CScene *scene`: passed to `CScene::RePlayBGM` in PauseEnd.

## NowLoadingStep enum (LoopStep, .sdata, initial -1)
-1 set by CreateNowLoading on entry (and initial value) and tested by DeleteNowLoading ("nothing
created"); 0 set before the thread starts; NowLoadingLoop: 0 -> 1, 1 draws until `EndFlag && ProgBarWidth >= 1.0`
then -> 2; 2 just yields. DeleteNowLoading spins until 2. Ghidra prints -1 as `&_heap_size`.

## Globals (all LOCAL in retail -> `static` in the .cpp, no externs in the header)
Every data symbol of the unit is in local_symbols.tsv, so the header has no extern data.
- `TheadID__3` (sbss, retail name `TheadID`, sic): loading thread id from `CreateThread`.
- `ThreadStack__3` (bss 0x1000): thread stack; ThreadParam: entry NowLoadingLoop, stack size 0x1000,
  initPriority 10, gpReg `_gp`, option 0.
- `LoadInfo` (NowLoadingInfo, ctor'd in `__sinit`).
- `ProgBarWidth`, `ProgBarWidthStep`, `NextProgBarWidth` float (0..1); bar drawn x 91..91+157*w.
  `ProgBarCnt` int; `EndFlag` int (set by DeleteNowLoading). NowLoadingBarSteEnd sets step 0.05f
  (0x3D4CCCCD) and ProgBarCnt = step_count.
- `cancel_now_loading` int: set by CancelNowLoading (from event_func `_CANCEL_NOW_LOADING`), consumed
  (cleared) by the next CreateNowLoading, which then does nothing.
- `load_skip_img` int, `SkipImage` (bss 0x2800 byte buffer): skip-button IMG ("img/skip.img" for
  LanguageCode<2, else "img/%d/skip.img"); loaded into a 0x10000 stack buffer and memcpy'd if < 0x2800.
- `PauseFlag__2` (retail `PauseFlag`) int, `PauseEnableFlag` int, `PauseCancelCnt` int (set 10 at
  start, PauseCount decrements to 0), `PauseTexb` int (texture block from InitPause; callers 0xCF
  edit, 0x69 dungeon), `PauseInfo` PAUSE_INFO (zeroed in `__sinit`), `InitFlag` int (frames since
  pause start, clamped 1000; 0 = first frame captures back buffer into "pause_work" texture and
  pauses sound; 15 = pause stream; buttons accepted after 0x11).
- `SeCoreVol` float: master volume (core 1) saved at pause; -1.0f set in PauseStart; restored if >= 0.
- `play_time_count` int: `GetPlayTimeCountFlag()` saved; `wave_status` int: `sndStreamGetState()`,
  bit 0x1000 = stream playing.
- `bgm_status` (bss, symbol size 0x1C, slot 0x20): only reference is PauseEnd reading word 0 == 1.
  Never written anywhere in the game (grep of all asm): likely an int array/struct whose writers were
  compiled out. Type unresolved; `int bgm_status[7]` fits.
- `start_vcount` int: VSync count when the logo faded in; fade-out waits 65 vsyncs if fewer than 300
  have passed.
- Rodata strings: "loading", "img/%d/", "loading.img", "img/%d/skip.img", "img/skip.img",
  "pause_work", "skip", "title/title%d.img", "moji". CreateNowLoading maps LanguageCode 1..5 to 2.

## Functions
- `SwitchNowLoadingThread`, `CancelNowLoading`, `NowLoadingBarStep`, `DeleteNowLoading`,
  `NowLoadingInfo::NowLoadingInfo`, `PauseEnable`, `GetPauseFlag`, `PauseCancel`, `PauseEnd`, and
  `PauseCount` now compile as C++ and individually match the retail instructions.
- `NowLoadingBarSteEnd`, `InitPauseData`, `InitPause`, and `PauseStart` have named C++ drafts behind
  `NONMATCHING`. Their single promotion attempts differed from retail, so the normal build uses
  assembly for those functions.
- `NowLoadingLoop(void*)` is LOCAL (static, thread entry) -> not in the header.
- Return types from asm: InitPauseData int (0/1), InitPause int (always 1), PauseEnable int (old
  flag), GetPauseFlag int, PauseStart int, PauseLoop int (1 while paused). Others void.
- SCElogoFade(int fade_out, mgCMemory*): MainLoop calls (0, mem) at boot (language select via
  TitleLangSelInit/Key/Draw, sets LanguageCode, loads "title/title%d.img" into block 0) and (1, mem)
  later. Fades the "moji" texture (UV 0,0x144-0x200,0x180) over 23 frames.
- PauseLoop's two "unreachable blocks" in Ghidra are just the signed /2 rounding of constants.
- Pad buttons 0x15 (pause/start) and 0x16 (skip) are CPadControl button ids; no enum exists yet.

## Remaining draft implementations
`NowLoadingLoop` constructs a texture rectangle, draws the progress bar and
loading image each thread step, advances the bar toward its requested width,
and yields until `DeleteNowLoading` requests termination. `CreateNowLoading`
copies the memory settings, loads the language image, enters its texture, and
starts the priority-10 thread with a 0x1000-byte stack. `PauseLoop` captures
the frame on its first step, pauses sound in two phases, dims the captured
frame according to the save option, draws the skip image when permitted, and
exits on the pause or skip button. `SCElogoFade` configures packet and texture
memory, runs language selection on fade-in, then draws the logo for 23 frames.
The draft build creates `__sinit_nowload_cpp` from the typed `LoadInfo` global;
its retail initializer also clears the two words of `PauseInfo`.

## Matching trial
The complete unit compiles in draft mode with all 19 functions present: 11
instruction matches and eight differences. Four new runtime drafts received
one isolated promotion trial each; each remains guarded because its typed
dependencies are available only in the draft branch. The generated static
initializer matches in the grouped draft. Its single normal-build promotion
trial failed at mwccgap's source lookup for `__sinit_nowload_cpp`, so the
assembly initializer remains selected. The normal full build is byte-identical.


## Native data

The unit has no assembly data markers. Loading/pause state, the 0x1000-byte thread stack
and 0x2800-byte skip-image buffer are native file-local definitions. `bgm_status` has
seven words (0x1C declared bytes); PauseEnd reads only word zero. The six remaining
words have no established meanings, and the following four zero bytes are alignment.
Resource paths and texture names are inline literals.
