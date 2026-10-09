# editloop: reverse-engineering notes

## Source status

Native (plain C++ definitions): every game function in the unit except the
three below, including `EditLoop` (0x1AD120, symbol size 0x22CC inside a
0x22D0 comparison extent that holds a trailing alignment nop), `EditDraw`
(0xD6C body in a 0xD70 extent) and `EditStep` (0x33C).

Guarded draft (`#ifdef NONMATCHING` with an `INCLUDE_ASM` fallback):
`EditInit` (0x1AB320, symbol size 0x1BB8 inside a 0x1BC0 extent). The draft
differs by about 1,223/1,776 words; see "EditInit" below for why.

Assembly-only (`INCLUDE_ASM` with no draft):
- `CameraCtrlParam::operator=` (0x1ACEE0, 0x60): owned by cameracontrol;
  caller `CCameraControl::CCameraControl`. It is the compiler-generated copy
  assignment (retail gives the symbol the processor-specific binding 13 of a
  generated member, `readelf -s` on SCES_511.90), so a hand-written definition
  would be `GLOBAL` and is ruled out by `docs/MWCC.md` ("Natural C++
  definitions"). The implicit assignment from the existing class definition
  reproduces all 24 words when emitted from a real caller; its only caller in
  this unit is the guarded `EditInit`, so it stays assembly until `EditInit`
  is native. It copies ten float limits and the integer `no_check`.
  `cameracontrol.hpp` declares the retail member only under
  `CAMERA_CONTROL_USE_RETAIL_ASSIGNMENT`.
- `CActionChara::CActionChara()` (0x1ACF40, 0xC0): owned by actionchara;
  caller `InitDungeonMain` (dng_main). The header constructor emitted as the
  array-constructor callback of `EditInit`'s character array matches all 48
  words, so the `INCLUDE_ASM` is wrapped in `#ifndef NONMATCHING` and the
  `NONMATCHING` build emits it naturally from the draft `EditInit`.

Data markers still in the source: `INCLUDE_RODATA` for `at_1045`, `at_1053`
(EditInit material and image-path arrays), `at_1528` (camera vector),
`at_1395__2`..`at_1422` (EditInit diagnostics, paths and object names) and
`at_2125`..`at_2136` (loop diagnostics and object names), plus `INCLUDE_BSS`
`at_1077` (0x10, EditInit's zero-vector template). None is referenced by
native code. All other data is typed: `MenuInfo` is a `MENU_INIT_ARG *`
initialised to `&MenuArg`, `DataPktMode` starts at -1 (no packet mode
allocated), `MenuDataSize` is the loaded menu file's byte count,
`FixCharaBuffSize` is in allocator quadwords, and the blur ranges are pairs
of floats (1000/2000 and 3000/4000), not doubles.

The town main-loop mode (walking and Georama editing). `LoopInit/LoopMain/LoopExit` in mainloop
hold `EditInit`, `EditLoop`, `EditExit`. No class is owned by this unit (`class_units.tsv`).
`gp = 0x3846F0` (e.g. `LockChara` 0x37D314 is `-0x73DC($gp)`).

## INIT_LOOP_ARG (declared in mainloop.hpp)
- Used by mainloop (`NextLoop(int, INIT_LOOP_ARG)`), title, dng_main, the viewers. The complete
  definition is in `mainloop.hpp`.
- Size 0x50: `EditInit` copies it as 10 doublewords; `EditLoop` `memset`s a 0x50 local before `NextLoop`.
- Offsets used by `EditInit`: `0x00` int map number (passed to `GetMapName`; `< 0` loads sound set 0);
  `0x48` int event number (`< 1` replaced by 100, then `RunEvent`).
- `EditLoop` (menu result 6, leaving to another loop) writes `0x00 = MenuInfo+0x44`,
  `0x44 = MenuInfo+0x48`, `0x48 = 0x3F2`.

## Functions: visibility and returns
Local (static, keep in .cpp): `GetUserData` (retail `GetUserData__Fv`;
returns `GetSaveData() + 0x1D2A0`, i.e. the `CUserDataManager` inside the save data, or 0),
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

`EditStep`'s animation environment local is a `CObjAnimeEnv`: the player
position goes to `chara_pos`, the time to `time`, and `AnimeStep` takes
`&viewer`. `EditMapJump`'s two `LoadFile2` calls take `read_buffer` directly.

## Enums (header)
- `EditLoopMode` (`LoopMode`, local .sbss 0x37D2F4): 1 walk; 2 Georama edit (`StartEditMode`,
  `CheckWalkToEdit`); 3 menu opened from walk (exit -> 1); 4 edit, waiting up to 0x18 frames
  (`PreEditMenuCnt`) for `EditPreMenuAnime` before opening the menu (-> 5); 5 menu opened from edit
  (exit -> 2 via `StartEditModeFromMenu`); 6 wait for `ReadBGSync() == 0` then 1.
  `IsEditMode` returns 1 for 2 and 4.
- `EditControlMode` (`ControlMode`, 0x37D2F8): 1 player; 2 event running (`RunEvent > 0`,
  `CheckEventSkip`); 3 debug event editor (`ChkEventEditStart`, `EventEdit(&WorkBuffer)`);
  4 debug edit (`EditDebugStart`, `EditDebugLoop`; previous mode kept in `EditLoop`'s
  function-local static `old_cm`).

## Globals
Global (header): `read_buffer_end` u_long128* (= `read_buffer + 200000` qwords, +0x30D400 bytes;
used by `CScene::PreLoadVillager`), `EventMes1` ClsMes (0x2958, constructed in `__sinit`), and
`ScriptBuffer` mgCMemory (0x30; also used by event's `EventLoop`;
mapjump has a different, LOCAL `ScriptBuffer` pointer at 0x37E568 -- do not include both names in
one TU).
All other named data is local (static in .cpp): .sbss ints/pointers 0x37D2C0..0x37D38C
(`MainScene` = CScene* at 0x37D328, `Camera`/`EventCamera`/`FixCamera`/`EditCamera`, `MapNo`, `WalkChara`,
`LockChara`, `EditModeChg*`, the function-local statics listed below), `MenuInfo`
(pointer to a MENU_INIT_ARG; fields +0x18 scene, +0x28, +0x2C..+0x38, +0x3C menu result,
+0x40/+0x44/+0x48, +0x58), `DataPktMode`; .bss: `WaveTable` (0x1208), `CharaOldPos` (0x10),
`buf0`/`buf1` and the many 0x30 `mgCMemory` buffers (`WorkBuffer`, `MenuBuffer`, `ChrEffBuffer`,
`TotalDataBuff`, `ControlCharaBuff`, `MainDataBuff`, `MainCharaBuff`, `SubDataBuff`, `SubCharaBuff`,
`FishingBuff`, `SkyBuff`), `data_buf`/`init_dbuf` (2 x mgCMemory), `EventBuff` (4), `CharaBufs` (8),
`EditEvent` (CEditEvent, 0x150; +0x4 state, 1 = running; +0x148 door SE id), `EdDebugInfo`
(EditDebugInfo, 0x3C), `TestVisual` (0x50), `TestFrame` (0x110), `beforeAnalyze` (int[16]).

Function-local statics (retail ELF gives each counter four bytes and each
initialisation guard one byte): `EditLoop` owns `old_cm` (uninitialised),
`time_step = 1`, `show_time_step = 0`, `rain_flag = 0`, `start_bt_cnt = 0`,
`encount_flag = 1`, `show_encount_cnt = 0` and `next_encount = -1`; `EditDraw`
owns `flag` and the `char init` guard. MWCC emits the runtime initialisation
guards itself, including for zero-valued statics, so the statics are written
as ordinary initialised function statics and no file-local counters or guard
bytes exist.

## EditLoop: source forms the match depends on

- The time controls step scene time, compare the map's light band, and start
  a captured crossfade when `time_map->map_info.time_cfade` permits it
  (`time_cfade` lives in `CMapInfo`, not directly in `CMap`).
- The town-loading guard is `LoopCounter > 2` and the pre-menu wait is
  `PreEditMenuCnt > 24`: retail uses `slti at,v1,3` / `slti at,v0,25`, and the
  `>= 3` / `>= 25` forms clobber the compared register instead.
- Both `PAUSE_INFO` records are declared in their use regions and explicitly
  clear `scene` before assigning `MainScene` (the same pattern as the matched
  `LoopDungeonMain`); retail forms the field address, clears it, then stores
  the scene (+0xA60/+0xA68/+0xA78 and +0xF4C/+0xF60/+0xF6C). The ordinary
  pause's `event_skip` is initialised between the null clear and the scene
  store. No inferred `PAUSE_INFO` constructor is needed.
- The menu dispatch tests a real `end_code` snapshot as `21 || 1`, then 11,
  then 6, matching retail's irregular branch structure; a `switch` or an
  if-chain on the field itself gives different code. The event-result switch
  uses the `EVENT_REQUEST` names.
- `!CheckEventSkip()` gives retail's unmasked boolean branch.
- `CCharacter2 *const walk_chara` holds the character lookup through its
  global publication and sound-bank update (retail's +0x1710 result branch
  and +0x1714 store delay slot).
- At each cross-fade check, a captured scene pointer and an `int` logical
  result (`NowFade()` combined with `fade.cross`) reproduce the boolean-byte
  normalisation (`andi`) and retain the scene across `NowFade`.
- `debug_closed` is an `int` set after the nested control-mode correction.
- In the next-loop argument the floor is assigned before the map
  (+0xD34..+0xD40).
- `time_step` is toggled before its 30-frame display is requested, and
  `line_end[3]` is initialised before `line_start[3]` (+0x190..+0x19C,
  +0x340/+0x344).
- `const int &fishing_size = CharaBufs[0].stack_size - CharaBufs[0].stack_used`
  is passed to `FishingBuff.stSetBuffer`. Binding the remaining-capacity
  temporary to a reference stops MWCC's one-use propagation into the
  pointer-first argument walk, so the capacity, used-count and bait loads
  occupy v1, a3 and a1 as in retail (+0xBF8..+0xC20). Ordinary value or
  const snapshots, allocator references, accessors and casts are propagated
  back into the call; a mutable `size -= used` accumulator precolours its load
  to a2 and leaves six register differences. The reference adds no address,
  stack store or instruction.
- Saved-register roles follow the declaration order `light_check, light_band,
  finish, wait_for_map, next_sub_map, open_menu, menu_mode`.
- The `mgSetRenderInfo(30000.0f, ...)` call needs the Satan's Fiddle row
  (`scripts/build/satansfiddle.json`, `EditLoop__Fv`, binary32 `0x46EA6000`,
  callee `mgSetRenderInfo__Ffff`, `evaluate_first: true`,
  `expected_matches: 1`): retail materialises 30000 before the argument 3.
- The two `*(u_long128 *) dst = *(u_long128 *) src` vector copies
  (`CharaOldPos` and the ground position) are the upstream convention for
  `lq/sq` copies; scalar component loops or assignments emit `lwc1/swc1`
  pairs and oversize the body (0x22DC..0x2314).

## EditDraw: source forms the match depends on

- Both texture-group loops obtain their block lists through the inline
  `CScene::GetTextureBlockNo` accessor (scenesnd.hpp), not
  `mds_list_set.GetTextureBlockNo`. The accessor's return value is a
  temporary, so the loop guard tests `v0` before the count is copied to its
  saved register (+0x428, +0x6EC). Calling the member directly reverses that
  pair and swaps the forward loop's count and byte-offset registers.
- The reverse loop (map groups 0..5) names the element index
  (`count - i - 1`) and indexes `texture_blocks` with it for both the drawn
  block and the water-block test, as title.cpp does. A named element pointer
  exchanges the count and element-address registers.
- `CMdsListSet::GetTextureBlockNo` supplies a signed count and writes at most
  128 integer block numbers; groups 6..15 traverse the list forwards.
- The photo idea sound is `SYSTEM_SE_IDEA` (system bank 14, snd_mngr.hpp),
  played only when a photo subject yields an idea (`idea_no > 0`).

## EditInit (guarded draft)

The initialization partitions the main stack into packet, script, town-data,
menu/read and work buffers. Its `data_size` is the free quadword count before
the 210,128-quadword reservation; the reservation is subtracted at the three
consumption sites. The packet/menu allocation results are both stored in
their globals and passed directly to the consuming calls. A texture-manager
pointer survives from table setup through the later image registrations.
The MDT builder creates a billboard test model, then loads the treasure-box
model, cursor, effects, message images and scene data. Material and
image-path initializers belong at their use sites. The load descriptor is
0x40 bytes.

| Dependency | Layout or field |
|---|---|
| `CameraCtrlParam` | 0x2C; ten floats followed by `no_check` |
| `CActionChara` | 0x1030; array callback uses the header constructor |
| `CMapTreasureBox` | 0x680; `CCharacter2` base, reset by `Initialize` |
| `CMap` / `CMapInfo` | 0xD10 / 0x100; player placement is `map_info.chara_pos` |
| `CScene` | texture assignment uses `tex_block_base` and `tex_block_count` |
| `BGM_INFO` | master multiplier `master_volf` at +0xC, current volume `volf` at +0x14 |
| `NowLoadingInfo` | texture block, `unk_4`, then step count are assigned in that order |
| `mgFrameAttr` | billboard RGB components are set before the alpha |

Forms the draft keeps because they reproduce retail instruction sequences:
- Billboard RGB stores before the 128.0f alpha store (reproduces
  +0x6D8..+0x70C around `SetAttrParam`).
- The water image quadword count is rounded with an explicit branch on the
  low four file-size bits (retail shifts the unsigned byte size in the delay
  slot and recomputes the shift in the rounding branch); a precomputed count
  with an increment loses the second shift.
- The first active-BGM lookup is held in a `CScene::BGM_INFO *const` whose
  `master_volf` is set to one; the second lookup is independent and supplies
  `volf` to `SetVolfBGM`.

Why it does not match:
- Retail expands the complete `CMapTreasureBox` constructor chain inline at
  its placement-new call (+0x774 onwards). The shared header only declares the
  constructor and `map.cpp` defines it out of line, so the first 0x748 bytes
  compare exactly and the branch at +0x748 is the first difference. Defining
  the constructor inline in the header is a shared change that needs
  whole-object checks for every consumer.
- The retail epilogue writes the incoming, otherwise unassigned saved `s4`
  value to both debug fishing-item fields; the draft's uninitialised
  `fishing_item` local is stored from `s2`. A fabricated default would change
  the executable.
- Effect and camera construction differ in allocation-result/null branches,
  and saved-register allocation, scene-pointer lifetimes and allocation
  argument order differ later.
