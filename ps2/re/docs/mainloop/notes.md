# mainloop: reverse-engineering notes

## C++ draft status
All 62 functions have C++ in `ps2/src/mainloop.cpp`. 12 are exact and compiled
by the matching build. 27 more compile to retail's bytes in isolation but stay
under `NONMATCHING`. 23 differ from retail and keep the `INCLUDE_ASM` fallback.
Each function tried has its one promotion attempt recorded in
`scripts/re/promotion_attempts.tsv`.

No class in `build/re/class_units.tsv` is owned by mainloop. The unit emits the out-of-line
constructors `CUserDataManager::CUserDataManager()` (owner userdata) and `CEditData::CEditData()`
(owner editdata); they are declared in those units' headers, not here. The first game has no
counterpart of this unit's loop table or INIT_LOOP_ARG.

## Local (static) symbols in retail
Functions: InitPadTable, VSyncCallBack (`VSyncCallBack__Fi__3`), MenuInit, MenuLoop, MenuExit,
InitEventSelect, EventSelect and every `gc*` tag function. These go in the .cpp as `static`.
Data: pad_table, analog_table, SelectArg, LoopNo, NextLoopNo, PrevLoopNo, CaptureMode,
CaptureScreen, ActiveSaveData, SubGameSaveData, PlayTimeCountFlag, menu_mode, event_view,
future_sel, hdd_sel, FontTex, FontDataAdr, BlackFade, BlackFade2, exit_start, PauseSel,
PauseMenuMode, Font, InitArg, NextInitArg, PrevInitArg, main_buffer, MainBuffer, MainScene,
SystemSeBuff, SystemSeStack, InfoBuff, InfoStack, SaveData, MenuBuffer, font_buff, PauseMes;
the `name_NNN` symbols are function-local statics; `tag__3` is LoadGameConfig's local static
`tag` (SPI_TAG_PARAM[23], last row null).
Global (extern'd in the header): LoopInit/LoopMain/LoopExit, MainThreadPriority (.sdata, =1,
main() writes 10), read_buffer, SystemSND_ID, DebugFlag, DefStartEventNo, LanguageCode,
OmakeFlag, MasterDebugCode, GamePad (`GamePad__2` in main.symbols.txt; the other `GamePad` at
0x37CF44 is a local of another unit), PadCtrl, DebugInfo.

## Local data types (for the .cpp)
- Font: CFont (0xB8). PauseMes: ClsMes (0x2958). MainScene: CScene (0x10550; __sinit stores
  `__vt__6CScene` and initialises sub-objects). SaveData: CSaveData (0x65930; CUserDataManager
  at +0x1D2A0, CSaveDataDungeon at +0x1C5B4). MainBuffer/SystemSeStack/InfoStack/MenuBuffer/
  buf0_1224/buf1_1227/dbuf0_1230/dbuf1_1233: mgCMemory (0x30). PadCtrl: CPadControl (0x510).
  GamePad: CGamePad (0x478).
- read_buffer: `u_long128 *` (MenuInit stores stAlloc64's result).
- FontTex: `mgCTexture *FontTex[1]` (GetFontTexture range-checks 0 <= i < 1; ReLoadFontTexture
  stores EnterTexture's result). FontDataAdr: one-element array of pointers to font_buff
  (passed to EnterTexture as `TM2_head *`). font_buff 0xD000 bytes.
- SelectArg: `int[32]` (0x80); debug-menu row values, row index = loop number for rows 1..8;
  [9] language, [10] item set (index into {0,1,2,6}), [12] cfg number; gcMAP_NO writes [1].
- menu_sel_1452: `int[11]` EventSelect row values. at_1529: 64-byte char initializer (cfg name
  buffer local of EventSelect, sits right after the INIT_LOOP_ARG local, NOT inside it).
- ActiveSaveData: `CSaveData *`; SubGameSaveData: `CSubGameData *` (set to main_buffer when the
  title or an omake mode starts).
- `VSyncCallBack` increments the 64-bit play time at CSaveData+0x1A00 when PlayTimeCountFlag.

## INIT_LOOP_ARG (0x50)
- Size: every caller memsets 0x50; NextInitArg/InitArg/PrevInitArg are 0x50 each.
- 0x00 int map_no: EditInit passes it to GetMapName (<0 = none); InitDungeonMain stores it as the
  dungeon number into CSaveDataDungeon; MenuLoop's map-select path passes -1.
- 0x04 u8[0x40]: struct assignment (MainLoop, NextLoop) copies it two bytes per iteration, so it is
  a byte array (memberwise copy: int, bytes, three ints). No reader found.
- 0x44 int floor_no: InitDungeonMain calls SetFloorID with it when >= 0; _GOTO_DNG sets it.
- 0x48 int event_no: EditInit runs RunEvent(event_no) (defaults to 100 when < 1); MenuLoop passes
  DefStartEventNo; InitOmakeEnv, _GOTO_EDIT, _GOTO_DNG set it.
- 0x4C int: only ever copied.
- MainLoop calls `LoopInit[LoopNo]` passing &InitArg directly (by-value argument is passed as a
  pointer; no temporary copy is made in retail).

## Loop tables (.data, 0x28 each = 10 entries, then 8 bytes padding)
LoopInit/LoopMain/LoopExit index (enum MainLoopMode):
0 Menu{Init,Loop,Exit}, 1 Edit{Init,Loop,Exit}, 2 InitDungeonMain/LoopDungeonMain/FinishDungeonMain,
3 Title{Init,Loop,Exit}, 4 CharaViewer, 5 TextuerViewer, 6 MapView, 7 SoundViewer, 8 MovieView,
9 SVConvView. MainLoop ends (closes the pad, stops sound, returns) when LoopNo is outside 0..9.
Loop main functions return non-zero to leave. MainLoop forces LoopNo 3 when DebugFlag==0 and
LoopNo==0. Debug menu row names (menu_1281): game start, map, dungeon, title, chrview, texview,
mapview, sound view, movie view, Language, Item, Save Data, Load cfg, Convert Save Data.

## DEBUG_INFO (DebugInfo, 0x14 = symbol size)
Name of the struct type is not retail (retail only names the variable). Field names come from
editdebug's menu: SelData points at DebugInfo+0 "Debug Camera", +8 "Georama Debug",
+4 "CharaMove", +0xC "ParamOff", +0x10 "InventDebug". EditDebugLoop clamps +4 to 0..2 and +0x10
to 0..1. gcGEO_COMPLETE/gcGEO_DEBUG/SaveDataEditLoop set +8 = 1; gcPARAM_DRAW sets +0xC = !arg;
MainLoop zeroes +4. Note editdebug's `EditDebugInfo` is a different, larger type (EdDebugInfo).

## Pad tables
pad_table: 46 rows of PAD_TABLE_ENTRY {no, trigger, button} (0x228), ended by {-1,-1,-1}.
InitPadTable calls `RegisterBtn(no, button, trigger)`; CPadControl::Update reads the stored
`button|trigger`: trigger 0 -> CGamePad::On, 0x10000 -> Down, 0x20000 -> Up. For rows whose no is
0x34, 0x11 or 1 the button is overwritten with at_974[lang != 0] = {0x40,0x20}; for rows
0x79,0x78,0x68,0x67,0x66,0x38,0x32,0x14,0x10,0 with at_973[lang != 0] = {0x20,0x40} (circle/cross
swap for non-Japanese). The trigger/axis enums belong to padcontrol; not declared here.
analog_table: ANALOG_TABLE_ENTRY {no, axis} rows {0,1},{1,2},{2,3},{3,4},{4,2},{5,1},{6,3},{7,4},
{-1,-1} (0x48). CPadControl::Update maps axis 4 -> RY, 3 -> RX, 2 -> LY (1 presumably LX).

## Enums and values
- LanguageCode (enum LanguageCodeNo): names from MenuLoop's table at_1305 (Japanese, English,
  French, German, Italian, Spanish, Chinese, Korean); MenuLoop clamps to 0..5; MainLoop starts at
  2. sysmes loads system.mes for 0, system_N.mes for 2..5, system_1.mes otherwise. Fonts:
  0 FontTex_%d.tm2, 1 FontTex_1_0.tm2, else FontTex_2_0.tm2 (meswin/). The first game's
  Language enum (US/UK split) does NOT apply.
- CaptureMode (MainCaptureMode): 0 off, 1 "Capture Input Key" (CaptureStart), 2 "Play Input Key",
  3 "Play Input Key and Capture Screen" (2/3 call LoadCapture+CapturePlay); cycles mod 4. Differs
  from gamepad's PadCaptureMode (no mode 3), hence a separate enum.
- menu_mode (DebugMenuMode): 0 top, 1 MapSelectLoop, 2 EventSelect (forced when !DebugFlag),
  3 SaveDataEditLoop.
- PauseMenuMode (PauseMenuStep): 0 -> 1 next frame; 1 select (PadCtrl Btn 9 -> PauseSel 1,
  Btn 10 -> 0, analog 0 > 0.8 / < -0.8, Btn 0 confirm, GamePad Down(0x800) resumes); 2 fade
  (BlackFade += 0.03 up to 1.0); 3 -> returns 2. PauseSel 1 = continue, 0 = quit.
  PauseMenu results (EditLoop): 1 clears PauseFlag, 2 leaves the mode.
- MasterDebugCode 0x5D44 when pad buttons 8,2,4,1 (L1,R2,R1,L2) are held at boot; title checks it.
- InitPauseMenu(value): value is stored into PauseMes.unk_22a4 (ClsMes); EditInit passes 0x9A,
  InitDungeonMain 0x6C. Meaning unknown, hence the neutral parameter name.
- EventSelect rows (menu_1457): beginning, chapter(normal) cap%d.cfg, chapter(debug) db_cap%d.cfg,
  sub game sg%d.cfg (Spheda/GyoRace/Fishing), PalmBrink's pb.cfg, event, boss battle, future map,
  diorama map geo.cfg, HDD, extra (InitOmakeEnv). Configs are loaded from dbg/.

## Function signatures / return types
- LanguageChange__FiP1: `P1` is `u_long128 *` (same as mgCMemory::stSetBuffer).
- SetTextureTable(a, b, mem) calls SetTableBuffer(b, a, mem) (asm: $4 -> $6); with mg_texture's
  parameter names that is (block_max, texture_max). MenuInit passes (100, 20); mg_texture's
  names for SetTableBuffer may be worth double-checking.
- LoadFontTexture: Ghidra shows a returned pointer, callers ignore it; declared void.
- PauseMenu, TimeLimitCheck, GetCaptureMode, GetVramTopAddress return int.
- gc* tag functions: `int (SPI_STACK *, int argc)`, return 1 (or 0 for PROGRESS/START_EVENT).
  tag table has both "DEFENSE" and "DEFENCE" -> gcDEFENSE.
- Save data offsets seen: +0x1A00 s64 play time, +0x1A08 progress (2 = forces time 22.0),
  +0x1A10 float time of day, +0x1A14 copied to CScene+0x2F68, +0x1C578 vibration off,
  +0x1C59C.. option values (MonsterName/Map/EnemyHP/AngerCounter).
