# automap: reverse-engineering notes

No counterpart exists in the first game (no AutoMap / MiniMap / HealingPoint classes).
Everything below comes from this game's code.

All 43 functions in `ps2/src/automap.cpp` are native C++ definitions and match retail; the unit
has no `INCLUDE_ASM` or `NONMATCHING` guards and no data markers.

## Instances
- The only instance is the global `AutoMapGen` (dng_main, `0x01ECEF80`, size `0x2A0` in
  main.symbols.txt), so `sizeof(CAutoMapGen) == 0x2A0`. Ghidra shows its fields as
  `DAT_01ecefXX`/`DAT_01ecfXXX` in dng_main, dng_event, sphida (subtract `0x01ECEF80`).
- `CMiniMapSymbol` is embedded at `AutoMapGen+0x40` (`DAT_01ecefc0`: Draw/DrawSymbol* are
  called on it from DngMainDraw, CSphida::Draw; `__sinit_dng_main_cpp` constructs an
  `mgCDrawPrim` at `0x01ECEFD0` = +0x40+0x10). Its size `0x180` comes from the next member,
  `CHealingPoint` at +0x1C0.
- `CHealingPoint` at +0x1C0: `CAutoMapGen::Step` is `addiu a0,a0,0x1C0; j CHealingPoint::Step`;
  IsEventRun calls `CheckHealingTime` on `DAT_01ecf140`. Two s32 fields, size 8.
- No class here has a virtual function, a vtable or an out-of-line constructor.

## CAutoMapGen (0x2A0)
| off | field | evidence |
|---|---|---|
| 0x000 | `CMapParts *gio_parts` | IndexToPartsPlace: PlaceParts("p01_gio") result |
| 0x004 | `CMapParts *random_stone[12]` | PlaceParts("obj01") x12; SearchRandomStone (vt+0x18 GetPos), ClearRandomStone (vt+0x14 with 0,-99999,0); AutoSetTreasureBox |
| 0x034 | `CMapParts *pot_parts` | PlaceParts("obj02"); passed to `CBPot::SetObject2` in DngMainKey |
| 0x038 | `s16 random_map` | set 1 in RandomMapMainProc, 0 in LoadDungeonMapFile |
| 0x03A | `s16 minimap_enable` | set 1 in Build; MinimapVisTest requires it |
| 0x03C | `u32 gen_flag` | LoadDungeonMapFile ORs param_3; bits below |
| 0x040 | `CMiniMapSymbol mini_map` | see above |
| 0x1C0 | `CHealingPoint healing_point` | SearchHealingPoint sets +0x1C0 = 1 |
| 0x1C8/0x1CA | `s16 grid_w, grid_h` | loops `w*h`; Build sets 14x14 or 20x16; InitDungeonMain 30x30 |
| 0x1CC/0x1D0 | `float cell_w, cell_d` | `_GRID_SIZE` script tag; X and Z divisors; InitDungeonMain 320.0 |
| 0x1D4 | `AUTOMAP_ROOM_INFO *room_info` | SetupRoomInfo allocs 0x600 = 64 x 0x18 |
| 0x1D8 | `s32 room_info_num` | = nowPrisetNum after script run |
| 0x1DC | `CAutoMapParts *grid` | InitDungeonMain allocates 0x6270 = 900 x 0x1C |
| 0x1E0 | `s32 place_parts_num` | Build counts GetPlacPartsTable entries |
| 0x1E4 | `AUTOMAP_ROOM room[8]` | stride 0x14 up to 0x284; CreatRoom writes x,y,w,h at +4..+0x10 |
| 0x284 | `s32 room_num` | RandomMapMainProc |
| 0x288 | `s32 door_room` | CreatDoorRoom (-1 then room index); AutoSetTreasureBox reads room[door_room] |
| 0x28C | `s32 navi_valid` | UpdateNaviMap sets 1; GetNaviDistance requires |
| 0x290 | `s32 navi_depth` | UpdateNaviMap param_2 (4 from DngStep) |
| 0x294 | `s32 navi_enable` | Build sets 1 |
| 0x298 | `unk_298[2]` | never accessed; probably tail padding to 16-byte alignment (sceVu0FVECTOR inside CMiniMapSymbol) |

`AUTOMAP_ROOM.unk_0` (+0x1E4 + 0x14n) is only ever cleared and tested `== 0` (CreatDoorRoom).

### gen_flag bits (AUTOMAP_GEN_FLAG)
0x1 SetDummyTree (IndexToPartsPlace); 0x2 Build picks preset `iRand` by dungeon floor
(`DngSaveDataDungeon`), MinimapVisTest skips whole-room reveal; 0x4 SetDummyMountain; 0x8 Build
uses 20x16 and RandomMapMainProc uses CreatFixedMap(0) as room 0 (also forces RoomLink direction 4
for room 0, excludes room 0 from door choice); 0x10 skips SetInOutPartsIndex(4); 0x20 skips
SetHealingPointIndex; 0x40 Build uses preset 0 as whole floor. Names are mine.

## CAutoMapParts (0x1C) -- retail name from the SetMapInfo mangled signature
0x0 `u32 kind` (= PartsInfoData[i].kind; tested &1, &8, &0x10, ==0 empty); 0x4 `s16 parts_no`
(-1 empty; index into PartsInfoData); 0x6 `s16 attr` (script table 2nd short; Draw skips &1;
returned by GetAttrStatus); 0x8 `s16 room_no` (CreatRoom room_no, RoomLink/CreatDummyRoot ids,
dummy roots are 0x32+i; compared in LinkConnectCheck); 0xA `u8 road_link`; 0xB `u8 link`
(SetRoadLinkMark ORs both); 0xC `s16 visible`; 0x10 `CMapParts *parts`; 0x14 `u32 wall` (copied
from `CMapParts+0x2EC` = `move_flag`; init -1); 0x18 `s8 navi`. Init pattern is in
RandomMapMainProc/CreatFixedMap/LoadDungeonMapFile/InitDungeonMain. 0x19..0x1B never touched.

Link sides (cell 0xA/0xB, LinkConnectCheck return, SetRoadLinkMark): 1 = row-1 (-Z),
2 = row+1 (+Z), 4 = x+1, 8 = x-1. Wall bits (cell 0x14): 1 = x-1, 2 = row-1, 4 = x+1, 8 = row+1
(UpdateNaviMap, MinimapVisTest; MinimapDoorOpen maps link 1->2, 2->8, 4->4, 8->1).

Kind bits (from PartsInfoData part names): 1 "way", 2 room00-27, 4 room28-55, 8 "door" (entrance:
RoomLink sets 8 when the corridor reaches a cell of kind mask 6), 0x10 door closed by CreatDoorRoom
(parts_no += 4: door00 -> door04), 0x20 "step", 0x40/0x80 seen only combined in step00-07 and
door56-63 (not named), 0x100 "part", 0x200 way32+ (SetInOutPartsIndex adds 4..0x14 to way28-31),
0x400 room56-59 (SetHealingPointIndex adds 0x18/0x1C to indices 0x6C-0x73).

## CMiniMapSymbol (0x180)
0x0 `CMap*`; 0x4 `CMapParts*` placed table (GetPlacPartsTable, stride 0x310); 0x8 count;
0xC `mgCTexture*` ("minimap1"); 0x10 `CPreSprite` (0x130); 0x140 `CAutoMapParts*`;
0x144 `MINIMAP_INFO*`; 0x148/0x14A s16 grid w/h; 0x14C/0x150 float cell size; 0x154..0x15F unknown
(alignment gap before the vector); 0x160 `sceVu0FVECTOR center` (Draw copies pos); 0x170..0x176
s16 screen x,y,w,h (DngMainDraw/CSphida::Draw set 0x1B4,0x90,0x70,0x70 or 0x150,0xD4,0x140,0x118);
0x178 blink counter (wraps after 30; symbols with `blink` hidden while > 15); 0x17C `large`
(1 with the large window, set only by DngMainDraw/CSphida::Draw, not read in automap).
SetMapInfo stores the minimap tile into `CMapParts::unk_1dc` (+0x1DC, -1 if none); Draw uses
`tile & 0xF` / `tile >> 4` as 16x16 texel cell; MinimapDoorOpen subtracts 4 from it. The field is
`unk_1dc` in mapparts.hpp (another unit's header; candidate name `minimap_tile`).

## Data
All data is native: every object below is a C++ definition in `automap.cpp` and every string is
inline at its use (`minimap1`, `ERR:NotFound StartLinkPoint\n`, `%d,%d [%d][%d]\n`, `o00`/`o01`,
`room5%d`/`kaifuku`, `p01_gio`/`obj01`/`obj02`, `EXIT INDEX = %d\n`, `rand = %d\n`, `%d\n`).
- `PartsInfoData` (.data 0x33D440, 0x19F8 = 277 x 0x18, global): 277 native `AUTOMAP_PARTS_INFO`
  aggregates; row = `char *name; s16 kind; u8 link; u8 entrance; s16 unk_8[8]`. Row 276 has the
  inline empty string `""` as its name, not NULL. `SetMapInfo` terminates by reading a zero name
  pointer from the eight alignment bytes after the declared array extent (the native 0x19F8-byte
  object is followed by that zero tail). `unk_8` is never read by automap or any other unit; its
  values range -1..85 and are not uniformly repeated. SetPartsIndex bounds its search at 0x118 rows.
- `MiniMapInfoData` (.data 0x33EE40, 0x2E20 = 18 x 0x290, global): 18 native `MINIMAP_INFO`
  aggregates, `char name[16]` (e.g. "d01f01") then 320 s16 tiles indexed by PartsInfoData row
  (the trailing 43 tile slots of each map are zero; negative entries are retail values). SetMapInfo
  matches name to `BattleAreaScene+0x24` (truncated to 6 chars if 7 long).
- Local (static in the .cpp, not the header): `symbol_table` (0x341C60, 0xA0 = 10 x
  `MINIMAP_SYMBOL_INFO`, writable; nine rows with `MINIMAP_SYMBOL` values, final row
  `MINIMAP_SYMBOL_END` with zero appearance fields), `tag` (symbol file `tag__4`, 0x341D00, 0x40:
  writable `SPI_TAG_PARAM[8]` of ROOM_FIXED, GRID_SIZE, ROOM_ID, ROOM_SIZE, ROOM_RATE, RD,
  ROOM_END, `{NULL, NULL}`, each name inline; defined after the static callbacks and before
  `SetupRoomInfo` so data order follows retail), sbss `auto_map` (CAutoMapGen*),
  `nowPrisetStack` (mgCMemory*), `nowPriset` (AUTOMAP_ROOM_INFO*), `nowPrisetNum` (int),
  `nowPrisetTable` (s16*), `cax`/`cay` (int, last navi target cell), in retail order.
- Six 16-byte `.data` vectors at 0x341D40..0x341D90 are the local aggregate initializers
  `{0, 0, 0, 1}` (position/rotation) and `{1, 1, 1, 1}` (scale) in `SetDummyMountain`,
  `SetDummyTree` and `IndexToPartsPlace`.
- The `_ROOM_*`, `_GRID_SIZE`, `_RD` script tag functions are local -> `static` in the .cpp.
  `_ROOM_SIZE` allocates `w*h*4` bytes (pairs of s16) via `mgCMemory::Alloc` + `operator new[]`.

## Source forms the match depends on
- `CAutoMapGen::SetupRoomInfo`: `room_info = new (mem->Alloc(0x62)) AUTOMAP_ROOM_INFO[64]`.
- `_ROOM_SIZE`: the cell table holds two `s16` per cell (part index and attribute), so
  `width * height * 4` bytes is `s16[width * height * 2]`, but the explicit
  `operator new[](bytes, ...)` form is required: a typed placement-new with that element count
  changes the body at 0x1D6BE9 (retail body 0xB4), and `s16[bytes / sizeof(s16)]` changes it at
  0x1D6BC8 and adds four bytes with shifted relocations.
- `CAutoMapGen::CreatTermParts`: the candidate cell and its upper and lower neighbours are
  addressed as `(u8 *) grid + y_off + x_off` with byte offsets computed once, and the room number
  is read back through the same offsets after the loop. `grid[y * row_width + x]` adds the indices
  before scaling; `grid + y * row_width + x` scales row and column separately like retail but
  evaluates the row first, so the column offset and the cell pointer exchange registers
  (`a0`/`a1`) throughout the loop.
- `CAutoMapGen::SearchHealingPoint`: the function point position is copied into the local float
  array with a 128-bit copy; `memcpy(offset, point->position, sizeof(offset))` changes 88 `.text`
  bytes starting at `SearchHealingPoint+0x12`.
- `CMiniMapSymbol::SetMapInfo`, `CMiniMapSymbol::Draw` and `CAutoMapGen::Build` test part names
  with `name[0]` (`CMapParts::name` is `char`).

## Symbols (MINIMAP_SYMBOL)
Callers: CMonsterMan 0 (8 when monster +0x1354 > 0 and `GetNowNPC() == 9`), CTreasureBoxManager 1,
CRandomCircle 2, CGeoStone 3, CSphida 4/5 (+0x90 by +0xB0), 6/7 (+0xA0 by +0xB4), 0 for 5 balls.
Sphida meanings are not established; names are neutral.

## Unresolved
- `GetAttrStatus` return: `lh` of a s16 or literal 1; declared `int` (m2c says s16). Check caller
  `_AMG_GET_ATTR_STATUS` asm if a body does not match.
- `AUTOMAP_ROOM.unk_0`, `CMiniMapSymbol.unk_154`, `CAutoMapGen.unk_298`, `AUTOMAP_PARTS_INFO.unk_8`.
- Kind bits 0x40/0x80 have no name.
- RoomLink, CreatDummyRoot, CreatTermParts, SetDummyTree were only skimmed for field offsets.

## Symbol drawing
`DrawSymbol` maps a world position to 16-pixel map cells, checks room visibility and the blink counter, and draws the matching table symbol. `DrawSymbol_Chara` projects a character and rotates four arrow vertices about its facing, clipped to the map rectangle.

## Mini-map source types
`CMiniMapSymbol::SetMapInfo` receives a `CMapParts*` directly from
`CMap::GetPlacPartsTable`. The battle area's `map_name` is a `char` array, so
its floor name is passed to `strcpy` without a signed-byte cast.
