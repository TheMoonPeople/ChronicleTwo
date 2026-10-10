# editloop: reverse-engineering notes

## Source status

Every game function in the unit is native (plain C++ definitions), including
`EditInit` (0x1AB320, symbol size 0x1BB8 inside a 0x1BC0 extent),
`EditLoop` (0x1AD120, symbol size 0x22CC inside a 0x22D0 extent), `EditDraw`
(0xD6C body in a 0xD70 extent) and `EditStep` (0x33C); each extent ends in
alignment nops.

`EditInit` also makes the object emit two compiler-generated members that
follow it in retail order, both with retail's processor-specific symbol
binding 13:
- `CameraCtrlParam::operator=` (0x1ACEE0, 0x60), the implicit copy
  assignment, outlined from `CCameraControl::SetDefaultParam`. It copies ten
  float limits and the integer `no_check`.
- `CActionChara::CActionChara()` (0x1ACF40, 0xC0), the header constructor,
  emitted as the array-constructor callback of `EditInit`'s character array.

Data markers still in the source: `INCLUDE_RODATA` for `at_1528` (camera
vector) and `at_2125`..`at_2136` (loop diagnostics and object names). All
other data is typed or emitted by `EditInit` itself: `MenuInfo` is a
`MENU_INIT_ARG *` initialised to `&MenuArg`, `DataPktMode` starts at -1 (no
packet mode allocated), `MenuDataSize` is the loaded menu file's byte count,
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

## EditInit

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
| `mgCFrameAttr` | billboard RGB components are set before the alpha |

Forms the source keeps because they reproduce retail instruction sequences:
- Billboard RGB stores before the 128.0f alpha store (reproduces
  +0x6D8..+0x70C around `SetAttrParam`).
- The water image quadword count is rounded with an explicit branch on the
  low four file-size bits (retail shifts the unsigned byte size in the delay
  slot and recomputes the shift in the rounding branch); a precomputed count
  with an increment loses the second shift.
- The first active-BGM lookup is held in a `CScene::BGM_INFO *const` whose
  `master_volf` is set to one; the second lookup is independent and supplies
  `volf` to `SetVolfBGM`.

- `CMapTreasureBox() { Initialize(); }` is defined in `mapparts.hpp` (map.cpp
  no longer defines it out of line), so its five-level constructor chain
  expands inline at the placement-new site (+0x774 onwards) as in retail.
- All eight placement-new sizes use the early-return `align16_blocks` helper
  (chest 0x6A quadwords, effect manager 0x11B, eight action characters 0x81A,
  each camera 0x21), which recovers the allocator-result null tests.
- `Camera->SetDefaultParam()` (`default_param = *GetActiveParam()` inside
  `CCameraControl`). MWCC inlines the implicit `CameraCtrlParam` assignment
  only when it appears directly in the function being compiled; inside an
  inline wrapper it is called out of line, which emits the member and gives
  retail's call at +0x12B0. A plain assignment in `EditInit` stays inlined.
  `#pragma inline_depth(smart)` behaves like the default depth; an explicit
  `inline_depth(N)` inlines the assignment through N levels.
- `SetVillagerTexb(78, 56)` and `SetEventTexb(160, 2)` for the scene texture
  blocks, and a `CScene *scene = MainScene` local supplying both
  `GetActiveBgmInfo` calls (`master_volf` set to 1.0f, then `volf` passed to
  `SetVolfBGM`).
- Both stack splits compute the remaining count first, then set and reset
  the buffer: `data_size = X.stGetRest(); Y.stSetBuffer(X.stGetTop(),
  data_size); Y.stReset();`. `ControlCharaBuff.lock = 1` precedes the
  `FixCharaBuffSize` read.
- `sceVu0FVECTOR position = {0.0f, 0.0f, 0.0f, 0.0f};`: the compiler emits the
  zero template itself, so `at_1077` is not separate data.
- The `EdDebugInfo` epilogue builds a local `SubGameInfo`, sets `scene`,
  `texb`, `texb_num` and `unk_c`, copies it over the base part of
  `EdDebugInfo`, then sets `jump_map_no` to -1. The constructor leaves
  `rod_no` and `esa_no` unset; their scalar-replaced temporaries colour `s4`,
  which retail stores to both fields. A named uninitialised `int` instead
  takes `s2`/`s3` for the whole function and moves the character-loop
  registers (retail: `characters` in `s2`, `i` in `s3`, the offset in `s0`).
- The constructor's chained `load_buff = menu_buff = 0` leaves the two
  pointer zeros in registers (`daddu $2/$3,$0,$0`) through the scalar-replaced
  copy, while separate `= 0` statements fold to `sw $zero`; with the register
  zeros the scheduler gives retail's interleaved store order. Separate
  statements, casts, `0L`, locals, setters, constructed temporaries and
  `memcpy` all fold. Keeping the constructor's statement order otherwise
  unchanged keeps `__sinit_subgame_cpp`, `__sinit_editloop_cpp` and the
  `EditLoop` fishing local exact; moving `record_check`/`no_map_event` first
  changes the latter two.
