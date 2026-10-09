# dngmenu: reverse-engineering notes

Unit: dungeon floor map (`CDngFreeMap`) and the dungeon menu's tree map
(`CMenuTreeMap`). Dark Cloud 1 has no class of either name.

## Status

All 48 functions in `dngmenu.cpp` are native C++ and byte-identical to retail,
including `mgRect<float>::Set` (an explicit specialization emitted by this unit)
and `ClsMes::Init`, which MWCC emits from the unchanged `nd_meswin.hpp` inline
because the `CMenuTreeMap` constructor is inlined into `DngTreeMapInit`. The
unit has no `INCLUDE_ASM`, `NONMATCHING` guard or data marker: every literal,
table, static and vtable comes from its C++ definition. The `__sinit_dngmenu_cpp`
initializer (144 bytes) is produced by the global constructors described under
"Static initialization".

Non-member functions `CheckGeoramaMateria`, `DrawDngRoomInfo` and
`DrawGeoramaMateria` are LOCAL in retail and are declared `static`;
`DrawGeoramaMateria` keeps its retail 0x400-byte size only with internal linkage.
`DrawDngRoomInfo` is LOCAL at `0x1EE0F0`, size `0xB18`.

Header `@size` tags give each symbol's declared size in
`ps2/config/pal/main.symbols.txt`, excluding padding before the next function
(`DngTreeMapInit` is 0x3F8 in a 0x400 reservation; `Step` is 0x1828 in 0x1830;
`DrawRoomOne` is 0x914; `DrawDngRoomInfo` is 0xB18 in 0xB20).

## Header dependencies

- `CMenuTreeMap : CBaseMenuClass` (`menusys.hpp`); the base is 0x110 bytes with
  its vptr at 0x10C and its constructor zero-fills all 0x110 bytes.
- `CDC2Mes mes[8]` by value (`menucls1.hpp`, `sizeof(CDC2Mes) == 0x2A50`).
- `TRESURE_BOX_FLOOR_INFO tresure` by value (`dng_event.hpp`), size 0x1A40C
  (`AutoSetTreasureBox` allocates one with `__nw(0x1A40C)`).
- Forward-declared only: `GLID_INFO`, `DNGMAP_ROOM_INFO`, `DNGMAP_ROOT_INFO`
  (owned by dngfloor), `CDngFloorManager`, `CSaveDataDungeon`, `mgCMemory`,
  `mgCTexture`.

## CDngFreeMap (size 0x110)

Size: `DngTreeMapInit` `__nw(0x110)`; symbol `EventDngMap` (event_func) is 0x110.
The constructor is inline (emitted in `DngTreeMapInit` and
`__sinit_event_func_cpp`): it calls `mgRect<float>::Set(0,0,0,0)` on the rect at
0x20 and on each of the eight rects at 0x40, then `Initialize()`. `mgRect<T>`
therefore has a default constructor `{ Set(0,0,0,0); }` and a four-argument
constructor calling `Set`; both live in `mg_tanime.hpp`. Not a virtual class.

| Off | Type | Name | Evidence |
|---|---|---|---|
| 0x00 | CSaveDataDungeon* | save_dungeon | DngTreeMapInit stores MenuSaveDataDungeonPtr; LoadDngInfo `GetSaveData()+0x1C5B4` |
| 0x04 | CDngFloorManager* | floor_manager | `menu_GetBattleAreaScene()+0x14`; GetRoomGlid/GetNextGlid call through it |
| 0x08 | u8 | active | Initialize =1; Step/Draw return when 0 |
| 0x09 | u8 | unk_9 | only zeroed in Initialize |
| 0x0A | s16 | dng_no | LoadDngInfo param 3; compared 1..6 in LoadDngInfo, 6 in DrawRoot |
| 0x0C | s16 | mode | 0 menu (Initialize), 1 event (LoadDngInfo); indexes `stepCntTbl_1501[2]` |
| 0x10 | float | back_scroll | DrawBackPattern tile offset, +0.5 per frame |
| 0x14-0x1F | | unk_14 | never accessed |
| 0x20 | mgRect<float> | view_rect | Initialize Set(120,138,420,286); LoadDngInfo Set(60,40,W-40,H-40); CheckIsViewMove |
| 0x30 | s32 | mark_num | DrawRoomOne appends to 0x40[], Step zeroes, Draw iterates |
| 0x34-0x3F | | unk_34 | never accessed |
| 0x40 | mgRect<float>[8] | mark_rect | DrawRoomOne writes `this+0x40+n*0x10`; Draw draws each with name_tex sprite (0xC0,0xD2,0x40,0x2E) |
| 0xC0 | s16 | user_room_no | LoadDngInfo param 4; Initialize -1 |
| 0xC2 | s16 | next_room_no | LoadDngInfo param 5; Initialize -1; adjusted per dungeon in LoadDngInfo |
| 0xC4 | GLID_INFO* | user_glid | SetUserGlid; DrawPlayer |
| 0xC8 | s16 | blink_cnt | Step ++ wrap at 100; DrawTreeMap `%25 < 14` blink |
| 0xCC | GLID_INFO* | select_glid | CMenuTreeMap::Step copies its select_glid here; Draw debug readout |
| 0xD0 | s16 | tex_block | InitTexture -1; LoadDngInfo param 2; DeleteTexBlock |
| 0xD4 | mgCTexture* | name_tex | "dtname" / "dtname_dn" |
| 0xD8 | mgCTexture* | map_tex | "dt" / "dt_dn"; Draw reloads its block |
| 0xDC | mgCTexture* | last_tex | "dtbg"; DrawLast full screen |
| 0xE0 | mgCTexture* | koma_tex | "dngop" / "dngop_dn"; DrawPlayer |
| 0xE4 | DNGMAP_KOMA_POS* | koma_path | LoadDngInfo builds the list |
| 0xE8 | DNGMAP_KOMA_POS* | koma_now | SetKomaMove sets `koma_path->next`; DrawPlayer advances |
| 0xEC | s16 | koma_move | SetKomaMove param |
| 0xF0 | float | alpha | Initialize 128.0; Step clamps 0..128 |
| 0xF4 | s32 | fade_time | FadeIn/FadeOut param; Initialize -1 |
| 0xF8 | float | fade_step | +-128/time |
| 0xFC | s32 | fade_mode | -1 Initialize, 0 FadeIn, 1 FadeOut |
| 0x100/0x104 | float | pos_x/pos_y | scroll; eased towards 0x108/0x10C by 1/5 in Step |
| 0x108/0x10C | float | next_pos_x/y | Initialize 200.0; ResetDngMapPos `256-x`, `208-y` |

`DNGMAP_KOMA_POS` is an invented name (no retail symbol): `{float x, y; next}`
nodes allocated with `mgCMemory::Alloc(1)` (one 16-byte unit; only 0xC used).

## CMenuTreeMap (size 0x2FBE0)

Size: `DngTreeMapInit` `__nw(0x2FBE0)` (after `Alloc(0x2FC0)` units). The
constructor is inline in `DngTreeMapInit`: base ctor, vptr = `__vt__12CMenuTreeMap`,
eight `CDC2Mes` ctors, then `draw_hidden = 0`, `select_glid = NULL`,
`mes_data = NULL`, base 0x14 = 0, `help_view = 1`, `cursor_reset = 0`,
`money_view = 0`, `tresure_loaded = 0`, then for each of the eight windows
`MenuDngMes[i] = &mes[i]; ClsMes::Init(); SetBuff_system(GetSystemMesBuffer())`,
and finally `MenuDngMes[1]->value_space = 16` (offset 0x224C is numeric value
spacing, not `digit_font` at 0x2250). `MenuDngMes` is a file-local static, so
the constructor body is defined in dngmenu.cpp and only declared in the header.

| Off | Type | Name | Evidence |
|---|---|---|---|
| 0x110 | float[2] | cursor_pos | passed as `float*` to MenuCursorDraw; eased in Draw |
| 0x118 | s16 | dng_no | DngTreeMapInit param 4 (clamped 0..6) |
| 0x11A | s16 | draw_hidden | zeroed by the constructor; tested in FadeInOutMenu and Draw |
| 0x11C | s16 | jump_pay | set when the battle area is uncleared and `MenuCommonInfo->open_type == 1`, cleared by a sub-map request; a jump then `AddMoney(-money/2)` |
| 0x120 | GLID_INFO* | select_glid | InitEnd/Step |
| 0x124-0x12F | | unk_124 | never accessed |
| 0x130 | CDC2Mes[8] | mes | stride 0x2A50 to 0x153B0 |
| 0x153B0 | short* | mes_data | "systree.mes" pack file; SetMessData |
| 0x153B4 | s32 | cursor_view | Draw draws cursor when set |
| 0x153B8 | s32 | cursor_reset | Draw snaps cursor_pos and clears |
| 0x153BC | s32 | money_view | Draw: PrimDrawNumber of user money (`UserDataMan+0x44D9C`) |
| 0x153C0 | s32 | help_view | ctor 1; Draw gates the shared help window |
| 0x153C4 | u8 | tresure_loaded | InitEnd sets 1 after CreatTresuarBoxInfo |
| 0x153C8 | TRESURE_BOX_FLOOR_INFO | tresure | CreatTresuarBoxInfo / CheckGeoramaMateria |
| 0x2F7D4 | s32[0x103] | georama_materia | CheckGeoramaMateria output; DrawGeoramaMateria input. 0x103 is the remaining bytes (0x40C) to the class size; no bound is visible in code |

Vtable `__vt__12CMenuTreeMap` (0x37BF70, 0x20): `0, 0, IsCreateObject,
IsMakeObject, IsAskExtend, ItemCmdAfter, InitEnd (CMenuTreeMap), ExitEnd`; all
but InitEnd are `CBaseMenuClass`'s, emitted here as weak inline copies
(IsCreateObject returns 1, the other three return 0, ExitEnd is empty). Step
calls InitEnd through the vtable at +0x18.

`*(s16*)this` (base) is the menu state: 0 running, 1 opening (calls InitEnd when
the fade and BG read finish), 2 closing, 0xC returning from the save menu. Base
0x14 is the sub-screen (0 map, 1 floor info, 2 georama list); base 0x2 is a
sub-state used with 0xC.

## Enums

- `DNGMAP_MODE` (CDngFreeMap::mode): 0 menu, 1 event.
- `DNGMAP_FADE`: -1/0/1 (Initialize, FadeIn, FadeOut).
- `DNG_TREE_MAP_RESULT`: Step returns 2 when the jump is chosen, 1 otherwise on
  close, 0 while open; DngTreeMapKey passes it through; menumap's WorldMoveKey
  tests 1 and 2.
- `DNG_TREE_MODE`: `DngTreeMode` static, 0 tree map, 1 save menu.
- `DNG_TREE_MAP_FUNC` names `CheckDngTreeMapFuncType` results: SAVE_POINT for
  `MENU_OPEN_DNG_TREE_MAP`, DUNGEON for `MENU_OPEN_MAIN_DUNGEON` or a requested
  dungeon sub map, OTHER for the remaining opening modes.
- `DNG_TREE_MAP_SCREEN` (`key_arg_no`): 0 moves the cursor between floors, 1 the
  jump question or floor information, 2 the georama material list. Step sets 1
  after opening the question/information and when the list closes, 2 for the
  list, 0 on cancel; InitEnd and the constructor set 0; Draw shows the help line
  only at 0 and tests 1 together with `DngAskMessageDrawFlag == 1`.
- `DNG_TREE_MAP_MATERIA_PAGE = 14`: DrawGeoramaMateria draws `page * 14 .. + 14`,
  prints `GeoramaMateriaNum / 14 + 1` pages, and Step turns to the second page
  only when `GeoramaMateriaNum > 14`.
- `DNGMAP_PATH_ORDER` (`dngmenu.hpp`): `DNGMAP_PATH_NONE = -1`, `FORWARD = 0`,
  `REVERSE = 1`; used by LoadDngInfo's direction tables and its candidate-room
  search.
- `DNG_TREE_MAP_MES_MAX` (8) bounds the message-window arrays and alpha loops.
- Step's local message enum: `TREE_MAP_MES_JUMP` (0x3C), `TREE_MAP_MES_JUMP_NAMED`
  (0x3D, inserts the start/sub/exit/boss floor name `floor_id + (dng_no + 1) * 1000`),
  `TREE_MAP_MES_PAY` (+2, paid jump), `TREE_MAP_MES_FLOOR_INFO` (0x40) and
  `TREE_MAP_MES_FLOOR_INFO_MATERIALS` (0x41). Step's `TreeMapAction` enum names
  its action dispatch values (100, 110, 130, 131, 120, 200).
- Other named values in Step: `SAVE_FLAG_FISHING_OPEN` (0xDC, sets
  `DngInfoFishOkFlag`), `SAVE_FLAG_SPHEDA_UNLOCKED` (0x13D), `SYSTEM_SE_WINDOW`
  (0x13), `MENU_DEBUG_BIT_CTRL_BOOT_TREEMAP` (0x10), the floor-status clear mask
  `~(DNG_FLOOR_STATUS_SEAL_MONICA | DNG_FLOOR_STATUS_SEAL_MAX | DNG_FLOOR_STATUS_UNK_4)`
  (0xFFF8), and the debug flag set 0x1FB (OR of the eight `DNG_FLOOR_FLAG` bits).
  `CheckBitFlagMenu(0x66)` and the sibling floor-event flags 0xC9, 0xD4, 0x133,
  0x158, 0x196, 0x1A8 stay raw: each makes a jump to a particular floor play its
  entry event while clear, and their meanings need event-script evidence.
- `DNG_FLOOR_FLAG_CLEAR` (`savedatadungeon.hpp`, bit 0x2): the map debug display
  labels it "Clear", dngfloor marks rooms that are open but lack it, and Step
  lists a floor's georama materials only once it is set.
- `DNGMAP_ROOM_INFO::selectable` (byte 0x44) is cleared by `_ROOM_INFO`, set to
  1 for every room by `CheckDrawGlidInfo`, and read signed by Step: the cursor
  moves only onto rooms where it is 1. As an `s8` field Step reads it without a cast.

## Globals and statics

Only four data symbols are global: `TreeMapSaveFlag` (u8), `TreeMapSaveNum`
(s16; menuop increments per save), `TreeMapCallDungeonSubMap` (u8; menumain
SetCommonMenuModeID), `TreeMapCalledWorldMap` (u8; menumap). Everything else is
LOCAL in retail and `static` in the source. Statics of note: `MenuDngMap`
(CDngFreeMap*), `CMenuTreePt` (CMenuTreeMap*), `MenuDngMes` (CDC2Mes*[8]),
`MenuCursorDataBuff` (u8*), `MenuTreeMapStack` (mgCMemory, 0x30),
`treemap_root_put` (mgRect<float>), `Floor_Info`, `dng_light_circle`,
`dngfreemap_num` (mgRect<int>), `dng_player_pos` (float[2]), `Floor_InfoTex`
(mgCTexture*, "dngfibrd"), `DngTreeMode` (s16), `GeoramaMateriaNum` (s16),
`GeoramaMateriaInfoDrawPage` (s8, read with `lb`), `DngInfoStageNo` (u8),
`DngAskMessageDrawFlag` (s8, read with `lb`), `DngInfoRoomInfo`
(`DNGMAP_ROOM_INFO *`), `DngInfoDrawAlpha` (int; its eight-byte reservation is
alignment), `TreeMapSaveDispY` (s16).

Byte and halfword reservations include postprocessor-owned alignment; the
definitions do not model that padding. `DngTreeMode` is declared `short` and
read with `lh` (its four-byte reservation is padding). `CheckDngTreeMapFuncType`
reads the sub-map flag as an unsigned byte.

`dng_light_circle` and `dngfreemap_num` are `const mgRect<int>` globals: MWCC
places their zero-initialized storage in `.rodata` and still runs their
constructors from `__sinit_dngmenu_cpp`. Declaring them without `const` moves
the storage to `.bss` and breaks the section mapping.

### Static initialization

The light-circle and free-map number rectangles are zero-filled 0x10-byte
globals whose four-argument constructors call `mgRect<int>::Set`; the root
placement rectangle uses the default `mgRect<float>` constructor; the
floor-information rectangle uses four arguments; a native `mgCMemory
MenuTreeMapStack` completes the order. `MenuTreeMapStack` has one forward
declaration and its definition after the four rectangle globals, which keeps the
retail constructor order. Together they emit the 144-byte `__sinit_dngmenu_cpp`
exactly and keep the retail data/BSS section assignments.

### Data tables and function-local statics

The table records the retail storage for data used by these functions. Some definitions remain at file scope in the matched source.

| Owner | Static | Retail | Contents |
|---|---|---|---|
| `DrawRoot` | `markOffsetTable_1092[10]` (`RootMarkOffset`) | `.data` 0x352010, 0x28 | Mark offset per passage shape. |
| `DrawRoot` | `zerumaito_offset_1110` (`RootMarkOffset`) | `.sdata` 0x37C818, 4 | Mark offset for shape 0 in dungeon 6. |
| `DrawRoot` | `root_type_texturecrd_1216[5][2]` (s16) | `.data` 0x352040, 0x14 | Passage-type icon texture coordinates. |
| `DrawRoomOne` | `get_moji_tbl_1524[16]` (s16) | `.data` 0x352060, 0x20 | Four halfwords per visited-room glyph (texture x, y, width, height): `{0, 172, 62, 22}`, `{0, 194, 62, 20}`, `{0, 216, 62, 20}` for flag bits 1-3, then `{-1, 0, 0, 0}`; a negative x skips the glyph. |
| `DrawRoomOne` | `put_moji_tbl_1525[4]` (`RoomGlyphOffset`) | `.data` 0x352080, 0x10 | Glyph destination offsets within the picture: `{20, -7}`, `{20, -7}`, `{20, 0}` and an unused `{10, 10}`. |
| `DrawRoomOne` | `stepCntTbl_1501[2]` (float) | `.sdata` 0x37C820, 8 | Mark animation speed in menu and event modes. |
| `DrawDngRoomInfo` | `medal_xytbl_1736[5]` (s16) | `.data` 0x352118, 0xA | Completion-icon X positions 168, 190, 212, 234, 146; indices 0, 2, 3, 4 are the timed-clear, fishing, spheda and final medal rows, index 1 is unused. |
| `DrawDngRoomInfo` | `AlphaRate` (float) | `.sbss` 0x37D560 | Seal pulse phase, initialized to zero on first execution (MWCC emits the guard). |
| `CDngFreeMap::Draw` | `RootTable[4]` (char*), `Table[8][32]`, `bittable[8]` (u32) | `.data` 0x352130, 0x352140, 0x352240 | Debug labels for passage types and the eight `DNG_FLOOR_FLAG` bits; `bittable[1]` is paired with "Clear", mask 0x40 with "TalkMons". |
| `LoadDngInfo` | route tables | see below | |
| `MakeDngTreeMapJumpNo` | `name_tbl[7]` (char*) | `.data` 0x352760, 0x1C | First-floor map names per dungeon, with a separate `d07f01` literal. |
| `CMenuTreeMap::InitEnd` | `maxidtable[7]` (s8) | `.sdata` 0x37C848, 7 | Floor limits per dungeon. |
| `CMenuTreeMap::Step` | `old_direction` (int), `old_glid` (GLID_INFO*), `NextFloorGlid` (GLID_INFO*) | `.sbss` 0x37D5A4, 0x37D5AC, 0x37D5B4 | Each has a one-byte `init` guard that MWCC emits at the declaration. |
| `CMenuTreeMap::Step` | `bitTable[9]` (int) | `.data` 0x352780, 0x24 | `1, 1, 2, 8, 0x10, 0x20, 0x40, 0x80, 0x100`: debug selector rows 1-8 are the `DNG_FLOOR_FLAG` bits in `bittable` order; row zero edits `visit_count` and word zero is never read. |

The flat halfword indexing in `DrawRoomOne` shares the loop's `i * 4` induction with the destination table. Struct and two-dimensional array forms introduce a separate `i * 8` induction and change register allocation, so the native matched source keeps the flat storage.

Step's statics are declared where retail tests their guards: `old_direction`
and `old_glid` beside the `MenuCommonInfo` load before `MenuDCMsg[3]` and
`FadeInOutMenu`, and `NextFloorGlid` after `ReadBGSync`, next to the
`selection_changed` local. `old_direction` is only ever reset to -1 and never
read, in retail as well; `old_glid` is the room the cursor last moved away
from and is passed to `GetKeyNextRoom`.

Step's other local data is emitted from ordinary initializers: `messages[8]`
(32-byte template in `.data`), `practice_items[4]` (zero template in `.bss`),
`put_pos = {0x3C, 0x118}` and `prize_no = {41}` (`.sdata`), zero templates of
`name_id`, `challenge_values` and `time_ptr` (`.sbss`), the `ExeScript("MSG_END")`
string, the Shift-JIS and European `99:99` overflow strings, the four European
`sprintf` time formats and the full-width zero and colon (`.rodata`).

### File-scope tables

`DngInfoMedalNumMsg[6][2]` (short) holds the medal-count message position per
language as X/Y pairs: `(330, 10)` for languages 0-3 and `(330, 20)` for 4-5;
`DrawDngRoomInfo` reads `[language][0]` and `[language][1]`. `dngboardbrdtbl`
(24 shorts) holds the `(u, v, w, h)` rectangles of the upper and middle
floor-information frame; `dngboardbrdtbl_1` holds three rectangles for the
lower part when the room has a geostone row (`(58, 6, 24, 50)`, `(82, 6, 8, 50)`,
`(90, 6, 24, 50)`) and `dngboardbrdtbl_2` the shorter variant without it. All are
LOCAL; the 24-byte objects get an eight-byte alignment tail in their 0x20 pieces.

The tree-opening filename pair `DngTreeReadNames` is an eight-byte record of two
filename pointers with a real null aggregate initializer; `DngTreeMapInit`
copies it (retail's eight-byte load/store) before setting its first name to the
forty-byte filename buffer. `frametex.img` and `dmap%d.pac` are inline literals.

## LoadDngInfo route tables

Retail defines these as LoadDngInfo function statics. Point offsets are board
pixels relative to the position `CalcGlidPutPos` gives the cell. The loader
reads 20 passage points or 10 room points, so each `{-1, -1}` terminator is
never read. The pointer tables end in a real null entry; their declared extents
(44 and 20 bytes) are smaller than their 48- and 32-byte pieces.

| Table | Retail | Type | Contents |
|---|---|---|---|
| `RootHokanTable0..9` | `.data` 0x352260.., 84 bytes each | `short[21][2]` | 20 `(x, y)` points along passage shape *n*, then `{-1, -1}`. |
| `RootHokanTablePtrTable` | `.data` 0x352620, 44 | `short (*[11])[2]` | The ten passage tables, then NULL; indexed by `glid->root.shape`. |
| `RoomHokanTable0..3` | `.data` 0x352650.., 44 each | `short[11][2]` | 10 points crossing a room between two sides, then `{-1, -1}`. |
| `RoomHokanTablePtrTable` | `.data` 0x352710, 20 | `short (*[5])[2]` | The four room tables, then NULL. |
| `is_reverse_tbl` | `.data` 0x352730, 44 | `signed char[11][4]` | `DNGMAP_PATH_ORDER` per passage shape and link direction; `NONE` stops the path. Row 10 has no point table. |
| `old_hokantbl_useno` | `.sdata` 0x37C838, 8 | `signed char[8]` | Room table for the path's first room (`[direction]`) and for rooms reached while walking the links (`[direction + 4]`): `0 1 2 3 / 1 0 3 2`. |
| `is_reverse_tbl_room` | `.sdata` 0x37C840, 8 | `signed char[8]` | Point order of room table *i* for the first room (`[i]`) and later rooms (`[i + 4]`): `R F R F / F R F R`. |

The two pointer tables and the three direction tables are real function statics
in the source. The fourteen point tables are defined at file scope directly
above LoadDngInfo: MWCC numbers a native function static by its own counter,
which at this function is 708 behind retail (`$1522..` instead of `$2230..`),
and the postprocessor renames a numbered local only through identity proofs.
`name_initialized_locals` needs a complete code consumer, but the point tables
are reached only through the pointer tables; `pointer_table_names` accepts a
pointer entry only when its target already has a retail name or is an anonymous
`.rodata` literal. Once the point tables carry retail names, the pointer tables
are proved through them and the direction tables through LoadDngInfo. `const`
is not an option: it moves the tables to `.rodata`, while retail keeps them in
`.data`/`.sdata`, and the two `signed char[8]` tables must be non-const and
complete to be addressed gp-relative. `is_reverse_tbl[route][direction]` must be
2-D: a flat `[route * 4 + direction]` reassociates.

## GLID_INFO / DNGMAP_ROOM_INFO as seen from here

GLID_INFO stride 0x70 (CDngFloorManager +4 array, +8 count, +0xC/+0xE grid
width/height): +0 s16 kind (0 passage, 1 room), +2 s16 grid x, +4 s16 grid y,
+0xC GLID_INFO*[4] neighbours, +0x1C u8 blink, +0x20 DNGMAP_ROOM_INFO /
DNGMAP_ROOT_INFO. Room info (relative to +0x20): +4 char* georama list, +8 s8
floor id, +0xC u32 flags (2 entrance, 4, 8, 0x10 special floors), +0x18 s16
message no, +0x3E/+0x40 s16 draw offset, +0x42 s8 picture, +0x44 s8 selectable,
+0x45 u8 visited, +0x46 u8 mark, +0x48 float mark phase. `DNGMAP_ROOT_INFO::opened`
is `s8` because `CheckDrawGlidInfo` (dngfloor) updates it with `lb`/`or`/`sb`.

## Floor map behavior

`CalcGlidPutPos` maps a cell to board coordinates `x * 52 - y * 16` and
`y * 20`; its final argument selects whether to add the current scroll. Its
null case leaves both output references unchanged. `CheckIsViewMove` clamps the
point against the left and top edges and against `right - 10`; its bottom test
is asymmetric, clamping to `bottom - 10` only when `clipped_y - 10` exceeds the
bottom edge. It returns the integer coordinate differences as floats.
`SetNextRoomPos` applies that displacement to the scroll target. `SetTextureInfo`
looks up `dt`, `dtbg`, `dngop` and `dtname` in that order.

`ResetDngMapPos` scans the floor grid and calls `CalcGlidPutPos` for cells on
the four boundary lines (signed `glid_w`/`glid_h` of `CDngFloorManager`); the
eight resulting floats are never read but the calls are in retail. It then
centres the requested room on `(256, 208)` and uses `(-100, -100)` when that
room is absent.

`Initialize` writes the Y scroll before X, the X target before the Y target, and
the current path pointer before the path head. `SetUserGlid` clears the selected
player cell and looks up a room only when its number is nonnegative.
`DeleteTexBlock` releases a nonnegative texture block through the texture manager.

`DrawGlidCheck` inspects a passage cell's four neighbours. It marks adjoining
rooms above and left with bits `2` and `8`; visited boss or sub rooms set
directional bits `0x40`, `0x80`, `0x100` or `0x200` (`0x100` is "visited sub/boss
room to the left", tested by DrawRoot). `DrawGlid` draws the room passage
outline as a five-vertex red line loop; the lower edge is offset 20 down and 16
left.

`DrawBackPattern` draws a translucent black rectangle in event mode and returns
without drawing when event-mode opacity is negative. In menu mode it scrolls
the `dt` backdrop by half a pixel per frame and wraps its offset at the tile
width of 128. `DrawLast` covers the menu screen with the 128 by 128 `dtbg`
texture and skips event mode. `DrawDngName` draws `dtname` twice, offset by four
pixels for its shadow, at one quarter of the requested opacity.

`FadeIn` starts at alpha zero and increases by `128 / frames` per step;
`FadeOut` decreases by the same amount. For nonpositive durations the step is
128 in magnitude. `SetKomaMove` starts at the second node of the path because
`koma_path` itself is the piece's starting point.

`DrawPlayer` draws `dngop` at its room's board position, shifted four pixels
right and thirty up. In event mode it takes positions from the next path node
and retains the last position in `dng_player_pos`; in menu mode it bobs
vertically. `dng_player_blink_cnt` wraps at fifty frames and modulates the
sprite's brightness.

`CDngFreeMap::Step` advances an active fade, eases each scroll coordinate one
fifth of the remaining distance towards its target (converting the delta to
integer, taking the integer `abs`, then comparing the float result with 1.0),
snaps the value when that distance is zero, wraps the room blink counter at
100, increases `DngTreeMapActiveLightRate` by 0.05 up to 1, and clears the
queued mark count.

`DrawTreeMap` first draws a shrinking highlight around the selected cell in menu
mode, starting at `(x - 8 - 30, -42 + 11 + y)` and contracting by
`62 - 62 * rate` and `40 - 40 * rate`. It then visits every grid cell: rooms go
through `DrawRoomOne`, with a half-bright interval during their blink cycle, and
passages through `DrawRoot` twice, once per layer. Outgoing marks come from
`DrawGlidCheck`; the cell kind is loaded after that call.

`DrawRoot` draws passage shapes 0 through 9 as three parallel line strips or
pairs of strips; shapes 1, 2, 3, 6 and 7 subtract five pixels. Its first call is
the shadow layer, shifted eight pixels down and right at five percent alpha; the
second is the coloured layer. Menu mode uses a warm tint, event mode a darker
red. Opened passage types with `show_mark` draw a 22 by 22 mark from
`root_type_texturecrd_1216`, positioned with `markOffsetTable_1092` (or `zerumaito_offset_1110`
for shape 0 in dungeon 6). `RootMarkOffset` is two signed halfwords.

`DrawRoomOne` chooses a room picture from `dt` according to its visited state,
texture number and start/exit/boss/sub flags, adding -42.0f to the picture's Y.
Dungeon numbers 4-6 use a slightly larger destination rectangle. It draws a
shadow in menu mode, dims rooms other than the player's in event mode, advances
each room's mark phase by the mode-specific `stepCntTbl_1501` value, and queues the
bobbing mark rectangle. An unvisited room receives a small overlay unless it is
the player's room. Visited rooms can display up to three glyphs from `dtname`,
chosen by the room flags through `get_moji_tbl_1524` and `put_moji_tbl_1525`.

`CDngFreeMap::Draw` skips inactive or fully transparent maps and maps without a
texture. It clamps opacity to 0-128, reloads `dt`, draws the backdrop,
whole-screen overlay, cells and player piece, then composites queued room marks
with `dtname` outside event mode. With `menu_debug_flag` set it draws a
diagnostic panel for the selected room (links, visit count, eight save flags)
with a 256-byte detail buffer and a 32-byte line buffer (retail stack
0x140..0x240 and 0x240..0x260). The panel's Y base is 110; rows are at +2, +22,
+102, +122, then +142 and +20 per flag row. The four next-floor queries run in
normal/sun/moon/star order; the named `DNGMAP_ROOT_TYPE` constants follow the
retail debug labels. ON and OFF use separate `strcat` calls, and the final
`strcat(detail, "NONE")` after the flag loop is executed by retail without a
following draw.

`LoadDngInfo` uses the unused portion of its caller's stack for a temporary
arena (capacity read before the top; file sizes rounded up to quadwords with
unsigned shifts). It loads `dmap%d.img` into the assigned texture block with the
`_dn` suffix (`MENU_FILE_LOAD_DIRECT`), then positions the board at the current
room, adding -28.0f to the player Y. When an event has a next room,
dungeon-specific branch rules reduce jumps to a neighbouring room on the way to
the requested room. The function then creates a linked path of piece positions:
ten interpolation points for the destination room, twenty for each intervening
passage cell and ten for any intervening room. Direction and passage shape
select the point table and whether it is read forward or backward; a
`DNGMAP_PATH_NONE` direction stops the path, while an unrecognized cell type
skips point generation and still advances to the next cell. The first path node
is the piece's starting point. The return value is the number of quadwords
consumed from the arena. Its frame is 0x160: four candidate room numbers are
full integers at sp+0x120..0x12C, candidate pointers at sp+0x130..0x13C, the
64-byte filename at sp+0xE0, and the arena at sp+0xB0.

Retail contains two branches that cannot be taken, and the native source keeps
them: in the dungeon 1 room 8 remap, the `next_room_no < 8` arm sits inside the
`next_room_no > 8` guard (retail fills each arm's store into a `b` delay slot,
so the three-arm chain is visible); and in Step's jump question,
`DngAskMessageDrawFlag == 0 || DngAskMessageDrawFlag == 2` is tested right after
the flag is set to 1 or 2, so the zero arm never holds.

## Tree map behavior

`CheckDngTreeMapFuncType` reads the signed-halfword opening mode and the
unsigned-byte sub-map flag. `DngTreeMapDraw` reads `DngTreeMode` as a signed
halfword and dispatches modes 0 and 1 to the map or save menu.

`CheckGeoramaMateria` walks the floor's group identifiers, collects the item
numbers from matching groups, then twice removes items whose attribute word does
not contain `ITEM_ATTRIBUTE_GEORAMA_MATERIA` (`0x10`).

`MakeDngTreeMapJumpNo` maps the first floor of each dungeon through `name_tbl`.
It has special transitions from dungeon 0 floor 8 to `s01`, dungeon 1 floor 6
to `s05`, and dungeon 3 floor 20 to `d04b01`; the latter selects loop 2 when
story flag `0x1B6` is set and `0x1BC` is clear. The first floor of dungeon 6
also sets the main scene's map to `d07f01`. `MenuArg.result[0]` is the loop
number (`LOOP_EDIT`/`LOOP_DUNGEON`).

`DngTreeMapInit` reserves a work buffer from the remaining menu stack,
constructs the tree menu and floor map inside it, loads the floor grid when the
opening mode requires it, and reads the menu's data list. Opening modes
`MENU_OPEN_MAIN_TOWN` and `MENU_OPEN_DNG_TREE_MAP` share the separate-map block;
the in-dungeon main menu uses the common menu's cursor. `MenuCursorDataBuff` is
a byte image pointer: `DngTreeMapInit` stores a converted `stGetTop()` result
and passes `(u_long128 *) MenuCursorDataBuff` to `LoadFileMenu`; `InitEnd`
passes it to `EnterIMGFile(u_char *)`. The menu cursor texture is `frametex.img`.

`CMenuTreeMap::InitEnd` loads the dungeon map picture and floor information
texture, chooses a room from saved progress (or the marked boss/sub room; sub
tested first) within `maxidtable` bounds, centres the map on it, starts the
opening fade, loads `systree.mes`, then reads the dungeon treasure script into
an aligned buffer and builds the treasure tables if that read succeeds. Its
final state enables `cursor_view`, not the money board. Frame 0xA0F0.

`CMenuTreeMap::MsgInit` attaches `systree.mes` to all eight message windows,
applies `MsgPreset(MENU_SCRIPT_MES_ITEMMSG)` (15), enables zero values, sets
`fuchi = FUCHI_SHADOW_BLACK_WIDE`, and configures the command analyzer's menu
and system message buffers. Its `MSG_INIT` script sets up the shared message
window, which begins with message 300 and appends message 81 or 80 for the two
special opening modes, then places two lines near the screen bottom with
`SetMovePosGyou`. The second line moves to x=600 while the save screen is
inactive. The shared Y stays a word until the final halfword `TreeMapSaveDispY`
store.

`CMenuTreeMap::Step` handles cursor navigation (key context 0), the floor
question or information (1), the georama material list (2), confirmation of
travel to a floor, the save-menu transfer and debug controls. Its switches are
source-ordered: key mode (0, 1, 2), normal buttons (decide, cancel, square,
triangle), yes/no cursor (0, 1) and action (100, 110, 130, 131, 120, 200). The
decide case stores the entrance unconditionally, then overwrites it with the
selected cell; `GetMapType` uses `now_sub_map_no`. Action 100 has three separate
rejection sounds: no target, an unopened saved floor, and a translated
destination equal to the scene's current map (`map_no ==
MenuMainScene->GetNowMapNo()`, then `break` out of the action switch). Jump
payment starts at zero, becomes one for an uncleared battle area with open type
`MENU_OPEN_MAIN_DUNGEON`, and is cleared by a sub-map request; a real
`battle_clear` local holds the area result. The info branch requires
`dngfloor_infoview == 1`. Question setup writes YESNO window mode and wide black
shadow; info setup writes NONE mode and thick outline; the font width is 15 for
Japanese and 17 otherwise. Floor-info layouts use `SetMovePosGyou`:
no-materials sets two rows before message 64, materials makes message 65 before
three rows, Italian/Spanish override all three, and the dungeon layout overrides
the first two. The best clear time is used when nonzero and below the room
target; both are in 1/60 seconds (`total_seconds`, `time_minutes`, `seconds`);
overflow (`time_minutes > 99`) copies the Japanese `99:99` text and then
overwrites it for Europe. The geostone text starts at 71 before the saved-floor
clear flag selects 70. Debug selector zero updates visit counts; rows 1-8 edit
`bitTable` flags. The dungeon-one, floor-six SUB/BOSS exception reads the
selected room's floor field.

`CMenuTreeMap::Draw` draws the floor map and, when enabled, the shared help
message. It draws the selected floor's information and medals, eases the cursor
towards that room, and draws the cursor or money board. During the save
transition it animates the second help line and its colour. `font.alpha` is
assigned after constructing `CMenuFont` (zero by default; when the information
texture exists, twice the backdrop alpha after `GetNumberKeta`), and the money
digits receive a second white colour setup after their source rectangle. Its
0x1B0 frame has the menu font at 0x80 (numeral alpha at 0x110), a 32-byte
numeral string at 0x140, the named money-digit source rectangle at 0x160, three
board argument temporaries at 0x170/0x180/0x190 and the cursor coordinates at
0x1A8/0x1AC.

`CMenuTreeMap::FadeInOutMenu` tests `draw_hidden` (0x11A) before checking the
closing fade step.

`DrawDngRoomInfo` draws the floor detail panel only when a room and its texture
are available. Its height varies with the language (`LANG_JAPANESE` tests) and
whether the floor has a geostone, spheda challenge or fishing test. The panel
fades in six alpha units per frame and out eight. It draws the border and seal
pulse, then places four challenge rows and their message windows; the medal
message uses `DngInfoMedalNumMsg[language]`. Retail accesses message windows 1,
3, 4, 5, 6 and 7 directly; null checks exist only for window 0, window 5 while
choosing the panel height, and the final medal window. The fishing second line
is placed before its message-2 override; spheda prize placement checks Europe
only on the cleared or bonus-unlocked paths and before the cleared highlight.
The first completion icon is the timed-clear icon. The completion overlay reads
signed halfwords from `medal_xytbl_1736` and assigns only the highlight rectangle's
left field; the rectangle keeps top 0 and size 22 by 22. Its 0x150 frame has
the three panel pieces at sp+0x120/0x130/0x140 and the two seal rectangles at
sp+0x100/0x110, with a pointer selecting one.

`DrawGeoramaMateria` draws a page of up to fourteen georama item names in two
columns, using `GeoramaMateriaInfoDrawPage` for the starting item and
`GeoramaMateriaNum` for the end. It reloads the floor information texture for
the frame, reloads the message texture for the names, then displays the page
count in the lower right. Frame 0x1D0.

`DngTreeMapKey` steps the tree map in map mode. When that step opens the save
screen, it saves map information, sets loop number 2, and gives the save menu
the unused portion of `MenuTreeMapStack` plus the tree menu's fourth texture
block. When the save screen closes, it clears the save flag, resumes map mode,
starts a forty-frame fade and resets the tree menu to mode 12
(`MENU_ASK_MODE_EXTEND`), step 1 before rebuilding its messages.

`mgRect<float>::Set` stores its four arguments into left, top, right and bottom.
MWCC names the specialization `Set__9mgRect<f>Fffff`; the object postprocessor
normalizes it to retail's `Set__9mgRect_f_Fffff`.

## Source forms the matches depend on

Comparison spelling (MWCC emits `slt`/`slti` into a different register
depending on operand order and operator):
- `0 <= room_no`, `0 <= next_room_no`, `0 < frames`, `0 < room->seal`: a
  constant-left comparison emits `slt at, x, $zero` + `bnez`; variable-first
  emits `bltz`/`blez`.
- `x >= N` emits `slti v0` + `bnez v0`; `x > N - 1` and `x < N` emit `slti at`.
  In LoadDngInfo `>=` is used only for dungeon 2 `user >= 12`, dungeon 6
  `user >= 29` and the six dungeon 6 chain tests (11, 17, 22, 27, 34, 36); every
  other lower bound is `>`. `root->shape <= 3` (DrawRoot), `GeoramaMateriaNum > 14`
  and `time_minutes > 99` (Step) follow the same rule.
- `3.1415927f <= TreeMapSaveHopCount` (tree Draw) and `128.0f < seal_alpha`
  (DrawDngRoomInfo) keep retail's ordered float comparison.
- `!(alpha <= 0)` in `CDngFreeMap::Draw` preserves unordered-float behaviour.

Arithmetic and conversions:
- `x * 52 + y * -16` in CalcGlidPutPos; the subtraction form emits a different
  sequence. Conversions to float are implicit.
- DrawRoot: shape 0 adds `-16.0f` (`add.s`); shape 4 computes `put.left - 2.0f`
  and `put.bottom + 2.0f` into locals before its loops; shape 5 keeps the
  separate steps `- i - 5.0f - 1.0f` and `+ i - 10.0f + 1.0f`. DrawTreeMap keeps
  `x - 8 - 30`, `-42 + (11 + y)` and `size - size * rate` as separate operations.
- DrawRoomOne: the four overlay corners use explicit `fptosi` calls interleaved
  with the two float bases; `(int)` casts let MWCC sink the conversions into the
  primitive batch after `Begin` and shrink the body to 0x90C. The shadow alpha
  is a float local computed after `level`; `tint = 128.0f * event_brightness` is
  computed before the glyph test and converted inside the loop.
- DrawDngRoomInfo: the four board/icon coordinate conversions use ordinary
  `(int)` casts (explicit `fptosi` calls suppress conversion sharing).
- DrawDngName's shadow alpha converts a quarter of the integer opacity through
  the runtime float conversion; DrawBackPattern converts opacity to float before
  the zero test.

Control flow:
- `DngTreeMapInit`: `switch (menu_mode) { case 0: case 3: ... break; default: ... }`
  emits retail's unoptimized two-target chain; `if (mode == 3 || mode == 0)`
  and every boolean form normalize with xori/sltiu. MWCC compares the labels in
  reverse order.
- LoadDngInfo's next-room remaps are `if`/`else if`/`else` chains of separate
  assignments (ternaries merge into one store). The candidate search re-reads
  `start->room.link[dir]` after `GetRoomGlid`, tests `target != NULL &&` in each
  direction-search iteration, and breaks when `GetNextGlid` returns NULL before
  the loop condition re-tests it; the direction search exits with an explicit
  null break followed by the link test; no `break` on an unrecognized cell
  type. The order-gap test is `abs(...) > 1`; the forward test is
  `linked->room.order > start->room.order` and the direction choice
  `target->room.order > start->room.order`.
- Step: separate cancel/square cases, independent per-floor event conditions,
  room flags reloaded after message calls, the ask-flag test as written in
  retail, and the map comparison through the `CScene::GetNowMapNo()` inline
  (which yields the retail `bne v0,v1` operand order).
- DrawGlidCheck: the sub-floor and boss-floor flags are separate short-circuit
  tests; the mark mask is initialized after the null check (both zero moves).
- `CDngFreeMap::Draw`: separate `strcat` calls for ON and OFF (a conditional
  argument removes four instructions); positive nested conditions for the
  selected-room/floor-save work.
- DrawRoomOne: the sub/boss test is two `||` flag tests; the third-row texture
  height uses an `if` after the plain assignment.

Register allocation (MWCC numbers named locals downward in declaration order,
CSE/copy temporaries below them, extra webs of a reused local last; the
colourer takes the first free register of `v0 v1 a0-a3 t0-t9 s0-s7`):
- MsgInit: the first line's screen X and half line width are named values
  updated in place (`x >>= 2; width >>= 1; line_pos[0][0] = x - width`), so
  height colours `v1` and its reuse pins the retail load order (height, width,
  line width). A local assigned once and used once is substituted into its use.
- LoadDngInfo: `curve` is declared before `tail`; the passage and room branches
  reuse their own table selector as the point counter; `candidate_room[4]` is
  declared before `candidate[4]`; each `points` pointer is declared before its
  `reverse` value; the first-room table selector becomes the index of the
  selected curve and is reused by both traversal arms; only the passage and
  later-room traversals share one `curve` pointer.
- DrawDngRoomInfo: `top`, `left`, `center`, `bottom_table`, `alpha`, `shown` are
  evaluated in that order with the fill-box alpha `(alpha * 7) / 10` declared
  with them; `row_top` (`top + 68.0f`) is computed before the `CheckNowEurope`
  call; seal Y is computed before the language branch and each X inside its
  arm; the icon X is its own local `(int) (left + 20.0f)`; right edges are
  written `ix + width - ...` with no `right` local; board Y is assigned inside
  the first strip's argument (`mgRect<int>(ix, iy = (int) top, width, 0x46)`);
  `int icon_row_y = iy = (int) (2.0f + (68.0f + (float) iy));` starts both row
  counters from one conversion and the first highlight quad uses `icon_row_y`;
  `iy` continues as the text-row coordinate. Message line positions use
  `CDC2Mes::SetMovePosGyou` (manual triples reload `MenuDngMes[k]` after every
  store). The seal `init` guard is signed.
- DrawRoot: event tints are assigned mark colour, red, green, blue in both
  branches, then the mark pointer; retail sets red from the mark colour's 128
  so that register stays live and the `mode` load hoists to `lui s3`. A
  passage-type local indexes `root_type_texturecrd_1216[type][0]`/`[1]` in both
  `TextureCrd` calls. `(u8) root->opened` produces retail's `lbu` without
  changing the shared `s8` field.
- DrawRoomOne: one `i * 4` induction serves the glyph loop; `&w`/`&h` of the
  current glyph stay in `s6`/`s7` and `opacity` stays in `s8`. `int tex_no =
  room->tex_no;` before `if (room->visited == 0)` fills the branch delay slot
  and issues the `% 5` divide first; column and row are computed from it into
  locals. Colour components are separate `r`, `g`, `b` initialized to 192 and
  assigned `b = g = r = value` (`r = g = b` reverses the copies). Mark
  rectangles are stored with `mark_rect[mark_num]` then `mark_num++`.
- DrawGeoramaMateria: one `x`/`y` pair declared with `index` holds every text
  position (title, list rows, page counter), which makes MWCC spill
  `column_right` like retail; the list reads `x = item_w;` before the parity
  test and each arm computes `column_left/right - (x >> 1)`. Width/height pairs
  are declared `int item_h, item_w;` and `int text_h, text_w;`. The page-end
  index stays `int`.
- CheckGeoramaMateria: one addressable index serves the floor-group walk and
  both removal passes, declared before `count`; the group-search index is
  declared before the group ID and reused for the item loop after the search.
- InitEnd: a snapshot of the signed maximum floor count across lookups; loader
  locals declared as block, texture manager, map image; separate lower/upper
  room bounds; a two-float pair receives the X offsets before copying into the
  cursor; the loader output-size local needs no zero initialization.
- `CDngFreeMap::Draw`: the next-floor query results are declared moon, sun,
  normal before the font and assigned in call order; the debug panel keeps its
  live Y base; a `CFont` pointer is retained for the later prints while the
  first print uses the local object.
- DrawTreeMap: the mark mask is declared before the loop index; the grid pointer
  is retained and advanced by whole cells; the cell rectangle is constructed
  directly with `(0, 0, 52, 20)`.
- DrawGlid: named `top`, `right` and `bottom` stay live between vertex calls
  (`f20`-`f22`). DrawPlayer projects into separate scalar coordinates and uses a
  direct texture-rectangle constructor.
- Tree Draw: a 32-byte numeral buffer, a named money-digit rectangle, three
  board argument temporaries and a two-float cursor pair reproduce the frame.
- MakeDngTreeMapJumpNo retains the current scene in a typed local before the
  `d07f01` lookup. DngTreeMapKey evaluates `stGetRest` before `stGetTop`.
  DeleteTexBlock binds the texture manager before the sign test (delay slot).
- Step: `total_seconds` is declared before `target_time` and `best_time`;
  runtime initializers for `messages[8]` and `practice_items[4]` let MWCC store
  directly into the elements; the 72-byte time string, `selection_changed` as an
  `int`, and the three signed-byte static guards give the 0x130 frame with s0-s7.
- `CheckIsViewMove` needs the unit's GPR helper-history seed `0x30` (FPR seed
  zero); with seed zero the two initial coordinate copies exchange and the final
  X displacement moves into a delay slot. `Initialize` needs the Satan's Fiddle
  evaluate-first row for binary32 286.0 (`0x438F0000`), restoring the early f15
  load. No other profile rows are needed in this unit.
