# title: reverse-engineering notes

`TitleBootInit` retains a C++ draft under `NONMATCHING`; the matching build
uses its retail `INCLUDE_ASM` gap. `TitleModeKey` matches with five
`CalcMenuAdd__FPfff` control selectors (see [night-20261008.md](night-20261008.md)).
`TitleHDDInstallDraw` is source-supplied and matches retail, including the
complete title object and linked PAL image. The unit has 36 matched functions
and one guarded draft. Later sections that describe `TitleModeKey` as guarded
are dated investigation records.

The title main-loop mode (`LOOP_TITLE`). No class is owned by this unit (`class_units.tsv`
has none); the header declares the unit's own structs and enums, the 8 global functions and
the 3 global data. No first-game counterpart: the first game's `title`/`titleloop` overlay is
a different, cinematic title (DrawProcA..I, CProcess), and nothing in it maps to this one.

gp for this unit's `.sdata/.sbss` accesses is `0x3846F0` (e.g. `TitleMCCheckBootMode`
0x37E0D0 = `-0x6620($28)`).

## Linkage
Global (not in `local_symbols.tsv`): `CheckOmakeFlag`, `InitOmakeEnv`, `TitleInit`,
`TitleExit`, `TitleLoop`, `TitleLangSelInit`, `TitleLangSelKey`, `TitleLangSelDraw`,
`__sinit_title_cpp`; data `TitleSelectInit`, `MasterDebugModeOn`, `CostumeOptionEnv`.
Everything else (29 functions, all other data) is LOCAL -> `static` in `title.cpp`.
External callers: mainloop `LoopInit/LoopMain/LoopExit` tables (TitleInit/Loop/Exit),
mainloop `EventSelect` and menuaqua `GyoraceMenuKey` (InitOmakeEnv), nowload
`SCElogoFade` (TitleLangSel*), menuchr `MenuCostumeInit` (reads CostumeOptionEnv).

## Header dependencies
`TITLE_INFO` holds `SV_CONFIG_OPTION` by value (+0x48, 0x40 bytes; declared in
`savedata.hpp`) and `CScene::BGM_STATUS` (+0x178, 0x1C bytes; declared in
`scenesnd.hpp`). Both headers exist and are included by `title.hpp`, which is
included by `title.cpp`. The `TITLE_INFO` size assertion is 0x194.

## Function return types (static ones go in the .cpp)
- `title_init_rand()` void: srand(mgGetVSyncCount()).
- `SetSoundMode()` void: CSnd.SetStereoMode(config +0xC of save +0x1C574 == 0).
- `InitTitleOmakeFlag()` / `TitleOmakeOn()` void; `CheckOmakeFlag()` returns `TitleOmakeFlag`
  (s16, `lh`); declared `int` (return width not visible).
- `InitOmakeEnv(type, arg, loop_no)` void. type 1: map `SearchMapNo("i03h04")`, event_no 100,
  item set 0x10, loop 1 (LOOP_EDIT). type 0: map 0, event_no 6000, item set 0xF, loop 2
  (LOOP_DUNGEON). other: map -1, event 0, loop 0. Writes arg->map_no (+0), +0x44 = 0
  (floor_no), +0x48 (event_no). Sets OmakeFlag=1, calls DebugGetItem(save+0x1D2A0, set).
  Type 1 is the Gyorace (fish race) extra: GyoraceMenuKey calls InitOmakeEnv(1, 0, 0).
- `TitleInit(INIT_LOOP_ARG)` void; `TitleBootInit()` void; `TitleExit()` void;
  `TitleLoop()` int (1 = leave mode); `TitleDraw()` void.
- `InitRushMovie(int movie_no)` void (arg unused beyond the call); `RushMovieKey()` int
  (0, 1 -> title screen, 2 -> end title as attract complete (boot event 1), 11 -> demo
  time-out); `RushMovieDraw()` void.
- `TitleModeInit()` void; `TitleModeKey()` int (TitleKeyResult: 0,2,3,4,5,6,1000; TitleLoop
  also handles 1, 10, 11 but TitleModeKey never returns them because `DCTitleStep` is a stub
  returning 0); `TitleModeDraw()`, `TitleMapDraw()` void.
- `CalcPushAlpha(int speed_idx, float *alpha)` void: pulses alpha 0..128 using
  `cnttbl_2026[speed_idx]` (s8[2]), direction in `TitlePushStart_AlphaPlus`.
- `TitleMCCheckInit(int boot_mode)` void; `TitleMCCheckKey()` int (1 = done);
  `TitleMCCheckDraw()` void.
- `DCTitleStep(int)` int, always 0 (demo-disc runner hook).
- `TitleCopyRightInit()` void; `TitleCopyRightStep()` int (1 when phase 6);
  `TitleCopyRightDraw()` void.
- `TitleHDDInstallInit()` void; `TitleHDDInstallKey()` int (1 = leave);
  `DrawMenuDl(int x, int y, int w, int alpha, float rate)` void (progress bar);
  `TitleHDDInstallDraw()` void.
- `CheckAppInstallForTitle()` int: 1 when `GetMainFileDev()==3`, else `CheckAppInstall()`.
  `CheckHDDInstall()` int: HddConectCheck(0)>0 && CheckAppInstallForTitle()>0.
- `TitleLangSelKey()` int: returns `title_lang_select+1` after fade-out, else 0.
  `GetSelectLanguageNo()` int: `title_lang_select + 1` (5 rows -> LanguageCode 1..5).

## TITLE_INFO (TitleInfo, 0x194, type name not retail)
Size: TitleInit `Alloc(DataBuffer, 0x1C)` + `__nw(0x194, ...)`, `memset(p, 0, 0x194)`.
Inline constructor: loop constructing mgCMemory at +0x88..+0x178 (5 x 0x30, `mgCMemory()`
calls Init), then `memset(this,0,0x194)`, then `InitSV_CONFIG_OPTION(&config)` -- declare
it inline once `InitSV_CONFIG_OPTION` is declared.
Access widths from asm (register tracking from `lw -0x66E0($28)`):
- +0x00 mode int, +0x04 next_mode int (lw/sw; -1 = none). Values: TitleDraw/TitleLoop
  switch 0..8 (TitleMode). 6 only as next_mode (restore cursor, phase 1, alphas 128).
- +0x08 select s16 (lh/sh; clamp 0..3, or 0..4 with TitleHDDCheckFlag).
- +0x0A omake_select s16, +0x0C/+0x0E s16 written 1 when OmakePlayEnableAttr &2 / &1,
  +0x10 omake_num s16 (TitleLoop reads it as `(short)TitleInfo[4]`).
- +0x12 never accessed.
- +0x14 push_alpha float (CalcPushAlpha(0, &+0x14), fptosi in draw).
- +0x18 wait_count int, set 200 by TitleModeInit, counted down in phase -2.
- +0x1C title_alpha, +0x20 menu_alpha, +0x24 omake_alpha, +0x28 cursor_alpha: floats
  (lwc1, CalcMenuAdd(float*)).
- +0x2C cursor_count int (incremented, wraps at 10,000,000, `* 0.0523` -> wobble).
- +0x30 cursor_x / +0x34 cursor_y float (CalcMenu1).
- +0x38 idle_count int (== TitleRushWaitCount triggers fade to attract).
- +0x3C..+0x47 never accessed.
- +0x48 config SV_CONFIG_OPTION (memcpy 0x40 to/from save +0x1C574).
- +0x88 chara_stack mgCMemory[5]: passed as MENU_INIT_ARG::base_chara_stack (MenuArg+8).
- +0x178 bgm_status; +0x17C (= BGM_STATUS+4) read as the BGM number to reload.

## RUSH_INFO (RushInfo, symbol extent 0x18 in a 0x20 slot)
+0 phase int (lw/sw; RushPhase), +4 count s16 (lh/sh; >0x2EE starts the PUSH START pulse),
+6 movie_no s16 (passed to InitRushMovie, set 0 by TitleLoop), +8 push_alpha float
(CalcPushAlpha(1, &+8)), +0xC int written 0 only, +0x10 int written 0x3FFF only,
+0x14 skipped s8 (lb/sb; 1 when START/circle/cross pressed; selects demoAttractInterrupted vs
demoAttractComplete).

## HDD_INFO (HDDINFO, extent 0x24 in a 0x30 slot)
+0 connect = HddConectCheck(&+4); +4 hdd_state (compared with 1 and 3); +8 app_install
(CheckAppInstallForTitle; -1000/-1001 select message 0x6B); +0xC install_space
(CheckInstallSpace); +0x10 written 0 only; +0x14 written 1 when CreateInstallThread
succeeds; +0x18 result (StepInstallThread value <= 0 at end); +0x1C progress int
(fptosi(GetInstallProgress()), displayed /100); +0x20 work buffer for CreateInstallThread.
`__sinit_title_cpp` stores 0 to +0, +8 and +0xC; how the source expresses this is not
established.

## Enum evidence
- TitlePhase (s16): set values -2,-1,0,1,2,3,4,5,10,11 in TitleModeKey/TitleModeInit/TitleLoop;
  6 and 20 are only compared (never set). Menu row -> phase: 0->2 (returns 5),
  1->3 (returns 3), 3->4 (returns 4), 4->5 (returns 6, needs HDDINFO.connect>0),
  2->10 (needs OmakePlayEnableAttr). Phase 11 returns 1000.
- TitleLoop on TitleModeKey: 5 -> InitSaveData, equip chr 1 with 0x7F,0x85,0x10A,0x6E,0x5B,
  MenuArg.open_type 20 (MENU_OPEN_COSTUME), costume bits if attr&0x80; 3 -> open_type 8
  (TITLE_SAVE); 4 -> 18 (OPTION); all three next_mode 2. 6 -> next 5. 1000 -> next 7,
  open_type 27 (TITLE_SUBGAME_SAVE). MENU_INIT_ARG is `MenuArg` (0x1EFC610):
  +0x28 open_type (0x1EFC638), +0x3C end_code (0x1EFC64C), +0x40.. result[].
- Menu end_code: 10 -> continue a saved game (NextLoop with saved map), 12 -> start a new
  game (NextLoop(2,...), event 0x3F2), 19 -> start an extra (InitOmakeEnv), other -> back to
  the title with the config copied (next 6). Local exit codes cVar11: 1 new game,
  2 continue, 3 attract end, 4 demQuit, 5 demoQuitTimeOut, 11 extra -- left local.
- Extras row index: with both enabled, row 0 is the dungeon extra (attr&2), row 1 Gyorace
  (attr&1); TitleLoop picks type 1 when `omake_num==2 && omake_select==1`, else attr&1.
- OmakePlayEnableAttr bits: from `CMemoryCardManager::CheckOmake` and card data +0x10E4
  (bit 0 -> 2, bit 1 -> 1) when +0x10E0 != 0. Bit 0x80 tested in TitleLoop.
- RushInfo.phase 0..3; TitleCopyRightDispPhase s8 -10,-3..6 (TitleCopyRightInit sets 2
  directly, so -10..1 are unused in retail); HDDPhase s16 0..10 (TitleHDDInstallKey,
  the second switch at jump table `at_2607` sets up the message for each new phase);
  HDDConfirmType 0/1; TitleMCCheckPhase s16 0..6; TitleMainMCCheckPhase s16 0/1;
  TitleCameraPhase int 0..2 (TitleMapDraw); title_lang_phase int 0..2.
- LanguageCode: TitleHDDCheckFlag = (LanguageCode < 1), i.e. Japanese only; RushMovieKey
  compares with 1 (English) for the DC runner time-out.

## Globals (all static except the three noted)
- TitleSelectInit int (global): sw 1 in TitleMCCheckKey when either card has save files;
  read with lh into TITLE_INFO::select.
- MasterDebugModeOn u8 (global, lbu/sb): CMemoryCardManager::CheckDebugCode() != 0 during
  the boot card check; with MasterDebugCode == 0x5D44 unlocks GamePad debug keys.
- CostumeOptionEnv u_long (global, ld/sd, 8 bytes): OR of CheckOmake's `unsigned long*`
  output; passed to SetCostumeBit(unsigned long); ORed into CostumeAttr by menuchr.
- TitleRushWaitCount int (.sdata 750, set 1250, first boot 750); TitleProjection float
  (.sdata 480.0, set 800.0 / 480.0); TitleHDDCheckFlag u8; TitleMCCheckFileFind s16[2];
  TitleMCCheckInport u8[2]; cnttbl_2026 s8[2] (CalcPushAlpha local static);
  at_2646 8-byte float pair (HDD install cursor position, TitleHDDInstallDraw).
- .sbss widths: TitleRushWaitCountBoot/GameBootInit/MasterDebugModeOn/TitleMCFuncFlag/
  TitleMCCheckNow/TitleHDDCheckFlag/HDDDlBarDrawFlag/HDDMesDrawFlag/TitleMCCheckBootMode u8
  (lbu); TitleBootEventNo/DCRuncherMode/DCSelectedMovie/TitleCopyRightDispPhase/
  TitleSkipLogoFlag/debug_start_drawflag/init_2648 s8 (lb); TitleMCActivePort/
  TitleMainMCCheckPhase/TitlePhase/TitlePushStart_AlphaPlus/TitleCopyRightDispCounter/
  HDDPhase/HDDConfirmType/HDDnowDisplayImageNo/HDDModeSelect/TitleOmakeFlag/
  TitleMCCheckPort/TitleMCCheckPhase s16; TitleCameraAddAngle float; count_2647 int
  (converted via float); title_lang_curxy float[2]; others int or pointers.
- Pointers: TitleMap CMap*, TitleCamera mgCCameraFollow* (new 0xC0, ctor(40,30,0,8)),
  TitleCamera2 mgCCamera* (new 0x70, ctor(8)), WaveTable CWaveTable* (new 0x1208),
  TitleInfo TITLE_INFO*, TitleMCCheck CMemoryCardManager* (new 0x1100), TitleMCCheckMes
  ClsMes* (GetSystemMessage(0)), Tex_* / RushWork / RushStart / HDDBGTex / HDDSysImage /
  lang_tex / HDDDlBar mgCTexture*, RushMovie CMovie* (new 0x23940), TitleScene CScene*,
  TitleEventSound sound handle (sndLoadSound result), HDDMes/HDDMes2 CDC2Mes* (new 0x2A50),
  HDDMesDataBuff s16*, HDDImage mgCTexture*[10], HDDImageAlpha int[10].
- E3Select, E3ModeBoardDrawFlag/Alpha, E3_Title_SpriteY (34.0), E3_Trial_SpriteY (236.0),
  Trial_TitleBlackFadeAlpha, DCRuncherCounter, TitleMCFuncFlag, Tex_TitleBG/Plate/TitleLight/
  TitleCursor/TitleBG2, RushStart are written only.
- mgCMemory .bss: DataBuffer, TitleMapBuffer, TitleWorkBuffer, Stack_ReadBuff,
  Stack_MenuCharaBuff_Fix, lang_stack (each 0x30; constructed in __sinit).
- MC_ICON_Data: MC_ICON_DATA[3], stride 0x28 (+0x20 data pointer, +0x24 size filled from
  save.pac), handed to CMemoryCardManager::SetIconData. MC_ICON_DATA belongs to memcard.
- Function-local statics: start_button_tbl_1826 (s16 rects, 8 bytes per LanguageCode,
  7 languages), btn_tblxy_1830 (s16 x,y per menu row, 5 rows), table_2611 (3 rows x 0x18,
  s16 Menu3DivideTextureDraw rect data, +6 row height), infomsg_2664 (char*[7] per language),
  at_1594/at_1595 camera pos/ref vec4, at_1924 vec4, at_2606/at_2607 jump tables.

## Other observations
- `TitleBootEventNo` = low byte of INIT_LOOP_ARG::event_no (+0x48). 1 = play only the
  attract movie then end the title; 0 = normal boot.
- TitleScene offsets used: +0x2C70 CFadeInOut, +0x23D0 CMdsListSet, +0x2E54 active camera,
  +0x2E5C map slot, +0x38/+0x3C stacks, +0x906C, +0x10548 object with vtable call.
- CCharacter2/CActionChara is constructed inline in TitleBootInit (new 0x1030).

## HDD installation drawing

`TitleHDDInstallDraw` directly constructs a scoped `CMenuFont` when the progress
bar is drawn. Its five rectangles are `mgRect<int>(...)` argument temporaries,
not named stack locals. The background's source rectangle is constructed before
its destination rectangle. MWCC reserves the font at stack +0x60, the rectangle
temporaries at +0x120..+0x160, and the cursor pair at +0x178 in a 0x180-byte frame.
The emitted function is 0x408 bytes; retail's 0x410 extent includes trailing
padding. The checker reports zero differences, and promotion preserves the
production object and linked image.

An anonymous union plus the game's `u_long128*` placement-new overload adds an
allocation call and null test absent from retail. A scoped font with named
rectangles removes those calls but allocates the rectangles before the font,
shrinking the frame to 0x170 and differing at 26 instruction operands. Direct
rectangle constructor arguments reproduce retail without storage or constructor
helpers. The other matched title drawing functions use this same form.

`DrawMenuDl` draws two quads for the bar, then three textured rows with a shadow
pass. Its fill changes from grey to green at progress 1. The panel width uses
the short values at `table_2611` offsets 4 and 0x20.

## Remaining guarded differences

### TitleModeKey

The draft emits 0x9BC bytes against retail's padded 0x9C0 extent. Fifteen of
624 words differ:

- +0xC8/+0xCC: the two captured port bytes occupy s1/s2 instead of s2/s1.
- +0x188/+0x198/+0x1AC: byte narrowing and the first comparison use different
  registers; the second narrowing reuses the dead first snapshot register.
- +0x3C4/+0x3C8, +0x3DC/+0x3E0, and +0x410/+0x414: fade-down speed and zero
  endpoint materialization are reversed.
- +0x7FC..+0x808: extras cursor speed 3 and endpoint 128 materialization are
  reversed.

Retail captures port 0 before port 1. The earlier draft captured port 1 first,
which reversed the relocation addends of the loads at +0xC8/+0xCC. Relocation
masking hid those addend differences in its thirteen-word difference count.
Both orders preserve the draft's card comparison semantics; the retained guarded
draft follows retail's capture order.

Declaration order, direct initialization, paired card/snapshot declarations,
function-scope snapshots, comparison operand reversal, and an unescaped byte
array do not reproduce the retail registers. Removing the named first-card
pointer changes its caching and substantially disturbs the function. Float
literal/cast/default-expression changes and named fade parameters either leave
the mismatched schedules or disturb other matching calls; some also remove one
instruction from the menu setup and shift the tail.

Blocker category: register allocation and float constant scheduling. Reconsider
when an independently validated MWCC byte-snapshot allocation idiom and fade
parameter materialization idiom cover these exact patterns.

### TitleBootInit

The draft emits 0xA84 bytes against retail's padded 0xA90 extent, differing in
56 of 676 words. Differences include follow-camera float argument scheduling,
map-buffer/register assignments, file-size stack slots, icon-copy registers,
and memory-buffer argument scheduling.

At +0x7D8, after allocating `CActionChara`, retail branches on v0 and copies v0
to s0 in the delay slot at +0x7DC. MWCC copies first and then branches on s0.
This is the placement-new null-branch blocker assigned to the dedicated compiler
lane. Further title-local experiments on this function are deferred. Reconsider
when that lane supplies a validated natural placement-construction pattern;
then address the other scheduling and local-layout differences.

## Title drawing floating argument calibration

`TitleModeDraw__Fv` uses stable binary32 selectors `0x41c00000` (24.0f) and
`0x00000000` (0.0f), both evaluated first. This preserves the retained title
coordinates and prepares them before alpha conversion. With the artificial
division primer removed and helper masks GPR `0x30` / FPR `0`, the complete
unit passes canonical bytes and resolved relocations: `0x68B8` checked bytes
and 2,055 relocations.

## TitleModeKey stable-selector limits

The isolated canonical Satan's Fiddle build differs from the plain-wibo
all-draft diagnostic: with only TitleModeKey native and no new selector, its
body is `0x9B8` and the +0x2BC switch-branch delay slot absorbs the later
`lui` for -8.0f. The resulting four-byte contraction produces 379/624
aligned-word differences and displaced relocations through the menu tail.

A callee-scoped binary32 zero (`0x00000000`) evaluate-first selector for
`CalcMenuAdd__FPfff` restores the `0x9BC` body and leaves 23/624 differences.
Adding the binary32 128.0f endpoint (`0x43000000`) at the same callee restores
the menu/extras endpoint-first materialization and leaves 15/624 differences.
Unscoped versions have the same result. The complete-unit check still has
the target's byte problem and two displaced relocations at +0x7DC/+0x7E8;
these are partial calibrations, not accepted profile rows.

The remaining words comprise the five card-snapshot register differences,
four words at +0x3F0..+0x3FC in `CalcMenuAdd(..., 8.0f, 128.0f)`, and six
words at +0x7DC..+0x7F4 in the extras-menu -8.0f/zero call. Also selecting
8.0f (`0x41000000`) first changes address/constant scheduling and leaves
16 words; selecting -8.0f (`0xc1000000`) first instead permits the earlier
four-byte contraction again and leaves 382 words. Explicit float literals
and explicit zero endpoints do not remove the 15-word residual.

GPR helper history `0x10` / FPR `0` leaves the target's snapshot allocation
unchanged and breaks the already native `TitleModeDraw__Fv` and
`DrawMenuDl__Fiiiif`. The existing `0x30` history is retained.

Blocker category: card-snapshot register allocation plus context-dependent
fade-argument scheduling. TitleModeKey remains guarded with its original
source/profile. Reconsider with a natural lifetime/expression explanation
covering both the snapshot allocation and the differing -8/zero and 8/128
call schedules. TitleBootInit remains deferred to the placement-new lane.

## Mid-day selector applicability and snapshot types (2026-10-08)

Both TitleModeKey and TitleBootInit remain guarded. The source-only
canonical-profile baseline reproduces 379/624 aligned-word differences
for TitleModeKey (the four-byte contraction described above) and 56/676
for TitleBootInit. The documented private zero/128.0f `CalcMenuAdd` rows
restore the TitleModeKey extent and its 15-word residual.

Changing both captured port values to `int`, `u32` or `u16`, with explicit
byte narrowing at the two comparisons, leaves the same 15 words. Each
trial keeps the two capture loads in retail order, but s1/s2 remain
permuted at `+0xC8/+0xCC`, `+0x188`, `+0x198` and `+0x1AC`.
No widened snapshot type is retained.

The conflicting `CalcMenuAdd` calls take a field address and direct float
arguments. Neither the enclosing phase switch nor the selected field is
a nested call expression, so upstream's new nested selectors do not
distinguish those calls. Manufacturing an extra call would not represent
retail source behavior. No new production profile row is accepted.
TitleBootInit's placement-construction experiments remain deferred under
the existing ownership rule; this lane does not repeat them.

Receipts: `.private/floatsel/title/draft-base/`,
`.private/floatsel/title/snapshot-int/`, `snapshot-u32/` and `snapshot-u16/`;
the m2c TitleModeKey output is also in `.private/floatsel/`.

The fresh isolated production probe confirms 15/624 words, one byte problem
and the two displaced relocation sites at `+0x7DC/+0x7E8`; no sibling function
changes. Receipt: `.private/floatsel/title/key-best-production/`.

## Round-1 snapshot and fade expression probes (2026-10-08)

The round-1 base is `a9dddc6`, with its fresh canonical baseline and object
copies saved under `.private/round1/`. TitleModeKey and TitleBootInit retain
their guards. Existing m2c output, header layouts and documented negative
trials are the analysis baseline; TitleBootInit's construction work is not
repeated.

The nineteen new TitleModeKey probes use the canonical adapter and a private
profile containing the documented zero/128.0f `CalcMenuAdd__FPfff` rows.
Alpha-address and reset-order probes also test that profile plus the
previously recorded 8.0f row. No profile row is accepted or written into the
production configuration.

Explicit byte masks, widening only one captured port, references to the card
or manager, and separate comparison scopes leave the original five snapshot
register differences. Local `CardSnapshot` aggregates with either field
order contain just the two captured bytes; scalar replacement changes the
card-pointer and snapshot allocations and increases the residual to 23
words. This is a source experiment, not evidence of a retail aggregate type.
Naming the detected card result, using XOR for a change test or narrowing
the loss accumulator to bool also worsens the result.

Named addresses/references to the title and extras alpha fields do not
improve fade ordering. With 8.0f evaluated first, the title-alpha call also
moves its field-address load and changes its integer temporary, leaving 16
words overall. Moving the extras pulse reset after its alpha update leaves
19 or 20 words. The existing documented `CalcMenuAdd(float*, float, float)`
changes only its cursor, clamps it at the endpoint after crossing and
returns the clamp result; these address/reset variants introduce no new
callee or nested call expression.

| Trial and private policy | Differing words / retail extent |
|---|---|
| `key-snapshot-mask-first-zero128` | 15/624 |
| `key-first-snapshot-int-zero128` | 15/624 |
| `key-second-snapshot-int-zero128` | 15/624 |
| `key-card-check-result-zero128` | 529/624 |
| `key-card-check-xor-zero128` | 0x9C8 body, oversized |
| `key-card-lost-bool-zero128` | 0x9C4 body, oversized |
| `key-card-reference-zero128` | 15/624 |
| `key-manager-reference-zero128` | 15/624 |
| `key-check-scopes-zero128` | 15/624 |
| `key-snapshot-struct-zero128` | 23/624 |
| `key-snapshot-struct-reverse-zero128` | 23/624 |
| `key-title-alpha-address-zero128` | 15/624 |
| `key-title-alpha-address-zero128-plus8` | 16/624 |
| `key-title-alpha-reference-zero128` | 15/624 |
| `key-title-alpha-reference-zero128-plus8` | 16/624 |
| `key-omake-alpha-address-zero128` | 15/624 |
| `key-omake-alpha-address-zero128-plus8` | 16/624 |
| `key-omake-reset-call-zero128` | 19/624 |
| `key-omake-reset-call-zero128-plus8` | 20/624 |

The best complete-wrapper confirmation retains the `0x9BC` body and
15/624 differing words. The title object checks `0x68B4` bytes and 2,200
relocations, with exactly three problems: target bytes at `0x002A521A` and
the two displaced relocations at `+0x7DC` (`TitleInfo`) and `+0x7E8`
(`TitlePushStart_AlphaPlus`). All other functions and relocations remain
exact. The private confirmation is
`.private/round1/title/key-best-production/`; individual sources, compiler
logs, diffs and the structured ledger are alongside it.

No new source draft, production calibration or shared-file proposal is
retained. The guarded title source and production profile are unchanged
from the round-1 base; the blocker remains snapshot allocation plus the
context-dependent fade scheduling described above.

Final guarded validation repeats the baseline exactly: all 149 game object
SHA-256 hashes and the complete PAL ELF file are unchanged, the canonical
checker remains 147/149 with only `nd_meswin` and `actscript` failing, and
coverage is unchanged. The verifier retains exactly `0x26` text bytes and
passes all other sections and the memory-end check. Receipts:
`.private/round1/final-build.log`, `final-check.log`, `final-coverage.txt`,
`final-hashes.json` and `validation-summary.json`.

## Title input source cleanup

Retail `TitleModeKey__Fv` is a LOCAL function at `0x2A5150`, with declared
size `0x9BC` (2492 bytes), rather than its padded `0x9C0` section extent.
Static linkage, the existing memory-card function and menu/button enums,
and binary32 literals for the former `float(N.0)` arguments preserve the
complete unit's bytes and resolved relocations. The `338.0f` argument in
TitleModeDraw is also identical. The `0x10` START mask remains numeric until
the shared START/SELECT enum names are corrected by the header owner.

Receipts: `.private/fixes-r0/title-probe-{build,objects}.log` and
`title-final-{build,objects}.log`: `SCES_511.90: OK`, 149/149 objects.
