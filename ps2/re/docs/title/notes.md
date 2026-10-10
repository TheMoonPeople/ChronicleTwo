# title: reverse-engineering notes

`TitleBootInit` is native and exact. `TitleModeKey` matches with five
`CalcMenuAdd__FPfff` control selectors (see [matching constraints](matching-constraints.md)). `TitleHDDInstallDraw`
is source-supplied and matches retail, including the complete title object and linked
PAL image. The unit has 37 matched functions.

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

## Matching constraints

TitleModeKey and TitleBootInit are native and exact.
[The matching note](matching-constraints.md) records the array snapshots, boot source requirements and rejected alternatives.

## Title drawing floating argument calibration

`TitleModeDraw__Fv` uses stable binary32 selectors `0x41c00000` (24.0f) and
`0x00000000` (0.0f), both evaluated first. This preserves the retained title
coordinates and prepares them before alpha conversion. With the artificial
division primer removed and helper masks GPR `0x30` / FPR `0`, the complete
unit passes canonical bytes and resolved relocations: `0x68B8` checked bytes
and 2,055 relocations.

## Title input source cleanup

Retail `TitleModeKey__Fv` is a LOCAL function at `0x2A5150`, with declared
size `0x9BC` (2492 bytes), rather than its padded `0x9C0` section extent.
Static linkage, the existing memory-card function and menu/button enums,
and binary32 literals for the former `float(N.0)` arguments preserve the
complete unit's bytes and resolved relocations. The `338.0f` argument in
TitleModeDraw is also identical. The `0x10` START mask remains numeric until
the shared START/SELECT enum names are corrected by the header owner.

## Native title data

The 22 initialized-data and 27 BSS markers retain the exact icon, boot string,
projection, HDD-check and boot-state symbols. TitleBootInit uses inline literals
for its exclusive strings and the retained declarations for shared boot strings.
Other state and data are native. Byte/halfword flags retain actual access widths; RushInfo owns 0x18 bytes with a tail to 0x20. Installer
texture/alpha arrays have ten elements (0x28) with eight alignment bytes. The language
phase owns four bytes although its reservation is eight.

Function-local tables are seven MENU_SHORT_RECT start-button rows (0x38), five short
texture-origin pairs (0x14), three-by-twelve short installer rectangle entries (0x48),
seven caption pointers (0x1C) and two signed-byte pulse speeds {2,4}. Five caption rows
share Installing.... TitleRushWaitCount starts at 750; inserted-card/file-count arrays
own two/four bytes. Native camera initializers are {1.2,2.3,550,1} and
{-70.1,280.8,-493,1}; installer cursor is {160,180}. Native switches generate the
title/installer jump tables with real function-offset relocations.

TitleHDDInstallDraw owns static count and its compiler guard within the controls branch.
Constructor definition order remains unchanged. Shared boot strings keep their retail
assembly-owned declarations even where another function uses them.

## Input constants

TitleModeKey uses SYSTEM_SE_CANCEL for rejected HDD installation,
unavailable menu entries, menu and extras cancellation, and dismissing the
memory-card message. DCTitleStep results 1/2, TitleMainMCCheckPhase 0/1,
TitleMCCheckInit(0), CalcPushAlpha's mode 0 and event-bank sound 0 have no
established wider enum domain. Fade values express frame counts.

## Boot initialization

TitleBootInit constructs the movie player, card manager, two cameras, water table
and action character in DataBuffer. It loads map s19, title textures, save icons,
menu resources and the title event sound bank, then assigns the remaining buffer
to scene reads. Boot event 1 selects attract playback; event 0 either initializes
the first-boot card check and optional HDD check or restores the title menu.

`Align16Blocks(sizeof(CMovie)) + 2` gives 0x2396 quadwords, and the same
expression for CActionChara gives 0x105. The helper's early-return form makes
MWCC statement-inline the action-character allocation size; the constructor
null test uses v0 with the saved-pointer copy in the delay slot. No placement
conversion row is needed.

The map-top pointer is captured for the scene, while stSetBuffer takes
DataBuffer.stGetTop() directly. Separate logo file-size storage, map_no declared
before map_buffer, and read capacity acquired before read top preserve the
retail frame and register lifetimes. The explicit void-pointer icon destination
cast preserves its load before the size load.

The camera-follow constructor has one callee-scoped binary32 zero
(`0x00000000`) evaluate-first row for `__ct__15mgCCameraFollowFffff`, asserting
one match. The native body is 0xA84 bytes in the 0xA90 retail extent, with zero
alignment padding. Its instruction score is 0/676; the complete object verifies
bytes and resolved relocations with the existing data and BSS ownership.
