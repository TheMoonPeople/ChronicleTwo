# editloop: reverse-engineering notes

## C++ draft status
35 of 36 functions have C++ in `ps2/src/editloop.cpp`; 1 has no draft. 3 are
exact and compiled by the matching build. 16 more compile to retail's bytes in
isolation but stay under `NONMATCHING`. 16 differ from retail and keep the
`INCLUDE_ASM` fallback. Each function tried has its one promotion attempt
recorded in `scripts/re/promotion_attempts.tsv`.

The town main-loop mode (walking and Georama editing). `LoopInit/LoopMain/LoopExit` in mainloop
hold `EditInit`, `EditLoop`, `EditExit`. No class is owned by this unit (`class_units.tsv`).
`gp = 0x3846F0` (e.g. `LockChara` 0x37D314 is `-0x73DC($gp)`).

## Classes emitted here but owned elsewhere
- `CameraCtrlParam::operator=` (0x1ACEE0): owned by cameracontrol; caller `CCameraControl::CCameraControl`.
- `CActionChara::CActionChara()` (0x1ACF40): owned by actionchara; caller `InitDungeonMain` (dng_main).
  `CameraCtrlParam` uses its implicit copy assignment; the `CActionChara` constructor is defined in
  `actionchara.hpp`.

## INIT_LOOP_ARG (declared in mainloop.hpp)
- Used by mainloop (`NextLoop(int, INIT_LOOP_ARG)`), title, dng_main, the viewers. The complete
  definition is in `mainloop.hpp`.
- Size 0x50: `EditInit` copies it as 10 doublewords; `EditLoop` `memset`s a 0x50 local before `NextLoop`.
- Offsets used by `EditInit`: `0x00` int map number (passed to `GetMapName`; `< 0` loads sound set 0);
  `0x48` int event number (`< 1` replaced by 100, then `RunEvent`).
- `EditLoop` (menu result 6, leaving to another loop) writes `0x00 = MenuInfo+0x44`,
  `0x44 = MenuInfo+0x48`, `0x48 = 0x3F2`.

## Functions: visibility and returns
Local (static, keep in .cpp): `GetUserData` (retail `GetUserData__Fv`, `__2` suffix in our
symbols; returns `GetSaveData() + 0x1D2A0`, i.e. the `CUserDataManager` inside the save data, or 0),
`InitLockCharaCtrl`, `LockCharaCtrl`, `UnLockCharaCtrl` (counter `LockChara`, clamped at 0),
`InitEditModeChg`, `NowEditModeChg` (int), `EditModeChg(int event)` (sets `EditModeChgEvent`,
`EditModeChgCnt = 30`, locks), `EditModeChgStep(CScene*)` (counts down; then runs event
`EditModeChgEvent` if scene+0x2E88 == 0 and event > 0), `PreExitLoop(CScene*)`, `InitSubMapLoadStep`,
`SubMapLoadStep` (int: 1 while loading), `InitEditEvent`, `ResetEditEvent`, `RestartEditEvent`,
`UpdateTrBoxFlag(int map)`, `editLoadSound(int map)`, `LoadComVillaager` (empty), `LoadMap`.

Global (in header): `IsEditMode` int, `SetDataPacket(int mode)` void (global in retail, no outside callers), `EditInit` void, `EditExit` void, `EditLoop` int (true when
leaving through `NextLoop` or `TimeLimitCheck`), `EditStep` int (0 = event start waiting on camera,
else 1), `EditDraw` int (always 0, asm ends `daddu $2,$0,$0`), `BurnEditParts` int (0 if bit flag
0x208 set, main map != 3 or no map; else 1; `CEditMap::RemoveInfo` local 0x494 bytes),
`EditMapJump(int map_no)` int (maps 11..14 load as map 10 with sub map; 0 on unknown map/load info),
`EditGotoInterior(int map_no, int delete_villager)` int 1, `EditExitInterior(int)` int 1 (argument
never read), `EditDataSave`/`EditDataLoad` void, `KeepEditAnalyze` void, `EditAnalyzeChanged` int.

**SetDataPacket(int)** modes: 0 = initial packet buffers (`init_dbuf`),
1 = normal map (0x11170 qwords per half), 2 = map type 1 (0x1C138 qwords). `DataPktMode` holds the
last mode.

## Enums (header)
- `EditLoopMode` (`LoopMode`, local .sbss 0x37D2F4): 1 walk; 2 Georama edit (`StartEditMode`,
  `CheckWalkToEdit`); 3 menu opened from walk (exit -> 1); 4 edit, waiting up to 0x18 frames
  (`PreEditMenuCnt`) for `EditPreMenuAnime` before opening the menu (-> 5); 5 menu opened from edit
  (exit -> 2 via `StartEditModeFromMenu`); 6 wait for `ReadBGSync() == 0` then 1.
  `IsEditMode` returns 1 for 2 and 4.
- `EditControlMode` (`ControlMode`, 0x37D2F8): 1 player; 2 event running (`RunEvent > 0`,
  `CheckEventSkip`); 3 debug event editor (`ChkEventEditStart`, `EventEdit(&WorkBuffer)`);
  4 debug edit (`EditDebugStart`, `EditDebugLoop`; previous mode kept in `old_cm_1772`).

## Globals
Global (header): `read_buffer_end` u_long128* (= `read_buffer + 200000` qwords, +0x30D400 bytes;
used by `CScene::PreLoadVillager`), `EventMes1` ClsMes (0x2958, constructed in `__sinit`), and
`ScriptBuffer` mgCMemory (0x30; our symbol `ScriptBuffer__2`; also used by event's `EventLoop`;
mapjump has a different, LOCAL `ScriptBuffer` pointer at 0x37E568 -- do not include both names in
one TU).
All other named data is local (static in .cpp): .sbss ints/pointers 0x37D2C0..0x37D38C
(`MainScene` = CScene*, `Camera`/`EventCamera`/`FixCamera`/`EditCamera`, `MapNo`, `WalkChara`,
`LockChara`, `EditModeChg*`, function-local statics `*_14xx`..`init_2409`), `MenuInfo`
(pointer to a MENU_INIT_ARG; fields +0x18 scene, +0x28, +0x2C..+0x38, +0x3C menu result,
+0x40/+0x44/+0x48, +0x58), `DataPktMode`; .bss: `WaveTable` (0x1208), `CharaOldPos` (0x10),
`buf0`/`buf1` and the many 0x30 `mgCMemory` buffers (`WorkBuffer`, `MenuBuffer`, `ChrEffBuffer`,
`TotalDataBuff`, `ControlCharaBuff`, `MainDataBuff`, `MainCharaBuff`, `SubDataBuff`, `SubCharaBuff`,
`FishingBuff`, `SkyBuff`), `data_buf`/`init_dbuf` (2 x mgCMemory), `EventBuff` (4), `CharaBufs` (8),
`EditEvent` (CEditEvent, 0x150; +0x4 state, 1 = running; +0x148 door SE id), `EdDebugInfo`
(EditDebugInfo, 0x3C), `TestVisual` (0x50), `TestFrame` (0x110), `beforeAnalyze` (int[16]).
