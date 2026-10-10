# menumap: reverse-engineering notes

Unit: world map ("world move") menu `CWorldMapMenu` plus the Spheda (sfida) extras menu and
score view. No first-game counterpart (DC1 has no world map menu or Spheda).

## Dependencies
- `CWorldMapMenu : CBaseMenuClass` -> `menusys.hpp` (owned by menusys). When this header was
  written, menusys.hpp existed but did not compile (it includes the missing `memcard.hpp`), so
  `menumap.hpp` and `menumap.cpp` fail only through it. Verified separately against a stub
  `CBaseMenuClass` (0x10C bytes of data + vptr at 0x10C, size 0x110, the six base virtuals):
  header compiles, `sizeof(CWorldMapMenu) == 0xBA4` and every offset in the table below asserted.
- Forward-declared: `CDC2Mes` (menucls1), `mgCMemory`, `mgCTexture`, `SPI_STACK` (scriptinterpreter).
- `CSphidaData`, `CSubGameData` are owned by savedata; only the file-local globals use them.

## CWorldMapMenu (size 0xBA4)
Size: `WorldMoveInit` `__nw(0xBA4)` after `Alloc(WorldMapStack, 0xBD)`.
Vtable `__vt__13CWorldMapMenu` (0x20) holds only CBaseMenuClass's entries (IsCreateObject,
IsMakeObject, IsAskExtend, ItemCmdAfter, InitEnd, ExitEnd): no overrides, no own virtuals.
Constructor is inline (no `__ct__13CWorldMapMenu` symbol), emitted in `WorldMoveInit` inside the
`if (p != 0)` after `__nw`: base ctor, vptr store, `memset(this+0x118, 0, 0x50)`, field inits,
the wave_x/wave_y fill loop, then it ALSO zeroes the file-local statics `spi_wmaparea_tblnum`,
`spi_wmaparea_tbl`, `spi_wmappos_tblnum`, `spi_wmappos_tbl` and sets `WorldMap_MapNo`,
`WorldMap_NextLoopNo`, `WorldMap_DngFloor` to -1. Because those are static, the constructor is
only declared in the header; define it `inline` in menumap.cpp before WorldMoveInit.
Ctor init order (Ghidra): 0x118 memset, 0x110=0, 0x184=0, 0xB90=0, 0xB91=0, 0x18C=0, 0x18D=0,
0xB92=0, 0xA80=0, 0xA88=0, 0x174=-1, 0x178=0, 0x16C=0, 0x180=128.0f, 0xA74=0, 0x188=0,
wave_x[0]=0, wave_y[0]=0, loop i<0x117: wave_x[i+1]=mgAngleLimit(wave_x[i]+0.1308997),
wave_y[i+1]=mgAngleLimit(wave_y[i]+0.10471976); 0xA70,0xA68,0xA6C,0x17C,0x198..0x1A4=0,
0x170=1, 0xA78=0, 0xA7C=0, pos_icon[0..7]=0.

| Off | Type | Name | Evidence |
|---|---|---|---|
| 0x000 | CBaseMenuClass | base | `mode` (0x0) 1 = loading, 0 = open, 2 = closing; `step` (0x2) = WORLD_MAP_STEP; 0x4 `opened`; 0x18 tex_block[1] used for DeleteBlock/EnterIMGFile; 0x20 passed to DngTreeMapInit |
| 0x110 | s32 | area_no | index into spi_wmaparea_tbl; loaded from `GetSaveData()+0x1A20`; cursor moves it |
| 0x114 | | unk_114 | never accessed |
| 0x118 | u8[0x50] | unk_118 | only the ctor memset; never read |
| 0x168 | | unk_168 | never accessed |
| 0x16C | s32 | exit_wait | incremented while closing (mode 2); >2 ends |
| 0x170 | s16 | map_type | 1..4 from flags 600 (->2), 0x268 (->4), 0x280 (->3); `"wmap%d.pac"`, `"wmap0%d"` |
| 0x174 | s32 | here_area | -1 = mark all enabled areas; open type 13 sets `spi_wmappos_tbl[n].area_no + 1`, n = DAT_01EFC668 remapped 8->14, 9->15, 10->21, and copies it to area_no |
| 0x178 | s32 | view_only | only set 0; non-zero makes any button close |
| 0x17C | mgCTexture* | capture_tex | `"menuwork2"`; Draw `**(short**)` -> texture block for MenuReloadTexture |
| 0x180 | float | back_alpha | DrawMenuFillBox alpha; ctor 128, open type 13 -> 0, CalcMenuAdd ±8 |
| 0x184 | u8 | capture_view | Draw `== 1` draws capture_tex; only set 0 here |
| 0x188 | mgCTexture* | cursor_tex | `"mnmain"`; MenuCursorDraw; null when MapEnableNum < 1 |
| 0x18C | u8 | cursor_reset | CalcMenu1 snap arg, cleared after use |
| 0x18D | u8 | cursor_view | gates cursor draw |
| 0x190 | float[2] | cursor_pos | CalcMenu1 targets area x-50, y-15 |
| 0x198 | mgCTexture* | map_tex | `"wmap0%d"` (map_type), `"wmap01"` when map_type 4 |
| 0x19C | mgCTexture* | mark_tex | `"wname"`; area marks, name frame, place icons (u = type*0x14+0xB0) |
| 0x1A0 | mgCTexture* | anim_tex | `"wmap021"` (wobbling strips, map_type 2) / `"wmap04"` (bobbing, map_type 4) |
| 0x1A4 | mgCTexture* | pulse_tex | `"wmap022"`, drawn twice with colour from `at_1342` and alpha sin(pulse_angle)*48+196 |
| 0x1A8 | float[0x118] | wave_x | per-row x = sin*8+250, +0.034906585 per frame (255 used) |
| 0x608 | float[0x118] | wave_y | per-column y = sin*8+253, -0.05235988 per frame |
| 0xA68 | float[2] | pulse_angle | indexed in a 2-iteration loop; increments from `at_1343` (sdata, 2 floats) |
| 0xA70 | float | float_angle | map_type 4 bob, +0.02617994 |
| 0xA74 | s32 | blink_cnt | wraps at 90; marks drawn differently after 45 |
| 0xA78 | short* | mes_data | `"mapname.mes"` from the BG pack |
| 0xA7C | short* | menu_mes_data | GetMenuMainMessageBuffer() |
| 0xA80 | WMAP_AREA_DATA* | select_area | area whose place list is open |
| 0xA84 | s32 | pos_num | count of enabled places; AddMsgCursor2 max |
| 0xA88 | WMAP_POS_DATA* | select_pos | chosen place |
| 0xA8C | s32 | near_num | count in near_area |
| 0xA90 | WMAP_AREA_DATA*[64] | near_area | cleared 64 entries (8x8 unrolled); sorted by dist |
| 0xB90 | u8 | name_view | area-name window |
| 0xB91 | u8 | pos_list_view | place list window |
| 0xB92 | u8 | ask_view | travel question |
| 0xB93 | | unk_b93 | padding |
| 0xB94 | s16[8] | pos_icon | `pos->type`, 4 mapped to 3 |

Message windows: the menu uses the main menu's CDC2Mes pointers at 0x01EFBA48 (question),
0x01EFBA4C (place list), 0x01EFBA50 (area name) -- menumain globals, not this unit's.

KeyStep return: 0 open, 1 closed, 2 closed for travel (when the menumain
global DAT_01EFC64C == 6). WorldMoveKey forwards that, or 2 after a tree-map jump. Enum `WORLD_MOVE_RESULT`.
`WORLD_MAP_STEP_WAIT` (10) is only tested here, never set in this unit.

## WMAP_POS_DATA (0x14) and WMAP_AREA_DATA (0x4C)
Names invented (no retail names); retail table/tag names are `POS`/`AREA`, `spi_wmappos_tbl`.
Sizes: `_WMAP_POSNUM` allocs `num*0x14`, `_WMAP_AREANUM` `num*0x4C`; strides 0x14/0x4C in KeyStep/Draw.

WMAP_POS_DATA (store widths from `_WMAP_POS` asm; script arg order after the index:
map_no, loop_no, area_no, dng_no, floor, flag_no, type):
0x0 char* name (GetMapTitle(map_no) -> ConvertFontCode -> mgCopyString), 0x4 s32 map_no (compared
with scene `+0x2E60`), 0x8 s16 loop_no (2 = LOOP_DUNGEON), 0xA s16 area_no, 0xC s16 dng_no,
0xE s8 floor (lb; >=0 jump directly, <0 open tree map), 0xF u8 enable (CheckBitFlagMenu(flag_no),
cleared for type 4 when flag 0x2E0 set), 0x10 s16 flag_no, 0x12 s8 type (4 = Georama:
geo_table_1183[area_no] -> SearchMapNo -> CScene::SetNowMapNo), 0x13 pad.

WMAP_AREA_DATA: 0x0 s32 area_no (= tag index), 0x4 WMAP_POS_DATA*[8] (places whose area_no
matches, rest zeroed; KeyStep only scans 6), 0x24 s16 unk_24 (script arg 1, sh, never read),
0x28 x, 0x2C y (y scaled by 1.15 via fptosi), 0x30 name_x, 0x34 name_y (scaled 1.15),
0x38 name_side (0/1 in Draw), 0x3C enable (any enabled place; forced 0 for area 8 with flag 0x268,
areas 6/7 with flag 0x320), 0x40 char* name, 0x44 float dist (mgDistVector), 0x48 float dir_dot
(sceVu0InnerProduct with the pad direction; threshold walks down from 0.72 by 0.05).
MapEnableNum (static s16) counts enabled areas.

## Enums
- `SPHIDA_MENU_PHASE` (SphidaMenuPhase, s16): 0 top, 1 exit fade (Key returns 2), 99 fade before
  name entry, 100 NameRegistKey, 200 password course select, 201 password shown, 300 clear-score
  select, 301 clear ask, 400 quit ask. Top choices (Japanese): 0 play, 1 password, 2 clear,
  3 quit; other languages remap 1->2, 2->3 (no password entry).
- `WMAP_POS_TYPE`: only 4 (Georama) has a known meaning.
- Names of all enums are invented.

## Globals (all file-local in retail -> `static` in menumap.cpp, no externs in the header)
| Symbol | Type | Notes |
|---|---|---|
| spi_wmapstack | mgCMemory* | memory the SPI tags allocate from (worldmap_analyze param) |
| spi_wmaparea_tblnum | s16 | AREA_NUM |
| spi_wmaparea_tbl | WMAP_AREA_DATA* | |
| spi_wmappos_tblnum | s16 | POS_NUM |
| spi_wmappos_tbl | WMAP_POS_DATA* | |
| MapEnableNum | s16 | enabled areas (debug "Open All Area" sets tblnum-1) |
| WorldMapMenuType | u8 | 0 world map, 1 dungeon tree map opened from it |
| WorldMap_NextLoopNo / WorldMap_MapNo / WorldMap_DngFloor | s16 | travel target |
| WorldMapPtr | CWorldMapMenu* | |
| SubSaveData (`SubSaveData__2`) | CSubGameData* | |
| SubSphidaData | CSphidaData* | |
| SphidaMenuMes / SphidaMenuQus / SphidaScore | CDC2Mes* | `__nw(0x2A50)` each |
| SphidaMenuQusDrawFlag, SphidaCursorDrawFlag, SphidaInfoMsgDrawFlag, SfidaMoveInitFlag | u8 | |
| SphidaTex, SphidaTex2, SphidaTex_Sys, SphidaCursor | mgCTexture* | "omaketx", "mnbg", "omake_sfida", "mnmain" |
| SphidaCursorY | float | init 300.0 |
| SphidaCursorCount | s32 | wraps at 60000000 |
| SfidaBGXY, SphidaScoreListY, SphidaScoreListBarY | float | |
| SphidaSelect | s32[2] | [0] cursor, [1] list top (MenuKeySelectCheck) |
| SphidaMenuPhase | s16 | SPHIDA_MENU_PHASE |
| SfidaMakeLine | s16 | 1 when the list scrolled down |
| Sfida_NowPlayHorlBlink | s16 | wraps at 50 |
| WorldMapStack, SphidaStack | mgCMemory (0x30) | `__sinit_menumap_cpp` calls Init on both |

Defining the two file-scope memory managers in WorldMapStack, SphidaStack order generates
the retail initializer automatically. The native `__sinit_menumap_cpp` instructions match
exactly and each object occupies a 0x30-byte BSS section.
| SphidaMenuTexbk | int[8] | texture blocks copied from the init arg |
| menu_wmap_analyze_tag | SPI_TAG_PARAM[5] | POS_NUM, POS, AREA_NUM, AREA, {0,0} |
| geo_table_1183 | char*[11] (function-local static in KeyStep) | "", "", g01..g04, "", g05, "", "", "" |
Compiler-generated: at_1072/1081/1095 (float[4] vectors), at_1342 (float[2][4] colours),
at_1343 (sdata float[2]), at_1383 (int[4]), at_1218, at_1393, at_1764 (8-byte stack inits).

## Function notes
- Init functions' third arg is MenuCommonInfo's open type (WorldMoveInit: 13 or 19); unused
  in the bodies. SphidaMenuInit/SphidaScoreViewInit are void (no $v0 set).
- SphidaScreListUpdate copies 9 names into the CDC2Mes item strings at `+0x1E59 + 0x32*i`
  (`Mitouroku[LanguageCode]` for empty slots), then MakeMsg(0x13EE).
- OmakeSfidaSelect: `MenuListSelectKeyCheck(key, 8)`; |move| > 2 sets SfidaMoveInitFlag.

## Stable drawing argument order

The following unscoped binary32 selectors set `evaluate_first: true`:

| Function | IEEE bits | Value |
| --- | --- | --- |
| `Draw__13CWorldMapMenuFv` | `0x42200000` | 40.0f |
| `SphidaMenuDraw__Fv` | `0x40600000` | 3.5f |
| `SphidaMenuDraw__Fv` | `0x404ccccd` | 3.2f |
| `SphidaScoreViewDraw__Fv` | `0x42280000` | 42.0f |
| `SphidaScoreViewDraw__Fv` | `0x43d70000` | 430.0f |

They preserve the debug box, movement constants, and score-label arguments. The complete unit passes canonical verification: `0x49AC` allocated bytes and 1,190 relocations, including `SphidaCursorY`. The unused long-division primer is replaced by GPR helper mask `0x30`, FPR mask `0`, preserving allocated bytes and relocation identities.


## Native data and matching constraints

All data are native. The world-map command table has five SPI_TAG_PARAM rows, including
its terminator. `KeyStep` owns `geo_table[11] = {"", "", "g01", "g02", "g03", "g04", "",
"g05", "", "", ""}`. Code consumers identify the 44-byte pointer table and its four-byte
alignment tail; real R_MIPS_32 fields identify the pooled empty string and g01-g05
literals. The names, put_pos and clear_names initializers own four, eight and eight
bytes.

Retail SphidaMenuTexbk owns 0x20 bytes (`int[8]`), but SphidaMenuInit copies sixteen
integers and writes -1 at index 15. That address is table base+0x3C in adjacent menuchr
storage after MenuCharaBuild2. The source preserves this retail overflow without
extending the table or claiming the adjacent storage.
