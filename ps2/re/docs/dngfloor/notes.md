# dngfloor: reverse-engineering notes

Unit: `CDngFloorManager`, the tree map grid of one dungeon (rooms = floors, passage cells
between them), built by running map scripts through `CScriptInterpreter` with the tag table
`tree_map_tag`. No first-game counterpart found in `/home/adubbz/development/chronicle`.

Instances: `CScene + 0x2FA4` (CScene::Initialize calls Initialize there); `BattleAreaScene + 0x14`
(DNG_BATTLE_AREA; BattleAreaScene = scene + 0x2F90, so the same object). `CDngFreeMap::floor_manager`
points at it.

## Header / .cpp split
- All 11 script tag handlers (`_TREE_MAPINFO` .. `_ROOM_TITLE`, `(SPI_STACK*, int)`) are LOCAL in
  retail -> `static` in the .cpp, not in the header. Signature `int f(SPI_STACK *stack, int argc)`
  (SPI_TAG_FUNCTION in scriptinterpreter.hpp). All return 1 except `_ROOM_INFO` (no meaningful
  return; ghidra says void) and the floor-info ones, which return 0 when the floor is unknown.
- Every data symbol of the unit is LOCAL (`tree_dngmap` CDngFloorManager*, `tree_glid_info`
  GLID_INFO* cursor, `tree_spi_stack` mgCMemory*, `tree_spi_rootinfo` DNGMAP_ROOT_INFO*,
  `tree_spi_roominfo` DNGMAP_ROOM_INFO*, `menu_dng_debug_glidcnt` s16 (sh/lh; symbol extent 4),
  `tree_map_tag` SPI_TAG_PARAM[12] (11 + null), function-local statics). So no externs in the header.
- Global functions: all members + `GetCountSphedaClear`, `CheckFishingRecord`.

## CDngFloorManager (0x10)
| Off | Type | Name | Evidence |
|---|---|---|---|
| 0x0 | s8 | dng_no | LoadDataTable stores clamped arg (0..6); used `(char)*this` as GetFloorInfoPtr stage; GetNextGlid picks search table on 2 / 3 |
| 0x4 | GLID_INFO* | glid_info | _TREE_MAPINFO: `__nwa(n*0x70, Alloc(stack, ceil(n*0x70/16)+2))` |
| 0x8 | s32 | glid_num | _TREE_MAPINFO 3rd arg; loop bound everywhere |
| 0xC/0xE | s16 | glid_w / glid_h | _TREE_MAPINFO args 1,2 (dngmenu notes call them grid width/height) |
Size 0x10: Initialize writes through 0xE; CScene has a byte at 0x2FB4 = 0x2FA4 + 0x10.

## GLID_INFO (0x70) - stride 0x70 in every loop
- 0x0 s16 type: 1 room, 0 passage (GLID_TYPE). 0x2 x, 0x4 y (RelationGlid; CalcGlidPutPos:
  screen x = x*52 - y*16, screen y = y*20, so y grows downward). 0x6, 0x8 s16 from _GLID_INFO args
  4,5, no reader found.
- 0xC GLID_INFO* link_glid[4]: RelationGlid: [0] same x, y-1; [1] y+1; [2] same y, x-1; [3] x+1.
  Hence GLID_DIR up/down/left/right. Note RelationGlid `break`s after finding [1].
- 0x1C u8 blink: cleared by CheckDrawGlidInfo, set by LoadDngInfo, DrawTreeMap blinks it.
- 0x20 union { DNGMAP_ROOM_INFO room; DNGMAP_ROOT_INFO root; } (anonymous): _GLID_INFO sets both
  tree_spi_rootinfo and tree_spi_roominfo to glid+0x20, memsets 0x50 then 5.
- _GLID_INFO zeroes 0xC..0x18 as words and 0x1C as a byte.

## DNGMAP_ROOT_INFO (5, memset size)
[0] type (u8: GetDngMapNextFloorID `lbu 0x20`; GetDngMapNextRoot `1 << type`; DrawRoot texture
index), [1] shape (DrawRoot switch), [2] show_mark (DrawRoot draws the type mark when [0], [2] and
[4] are all non-zero), [3] open / [4] opened: CheckDrawGlidInfo sets [3] = both end rooms have
DNG_FLOOR_FLAG_OPEN, [4] |= same. [0..2] from _ROOT_INFO args. Signedness of [1],[2] unverified.

## DNGMAP_ROOM_INFO (0x50, memset size; 0x20 + 0x50 = 0x70)
| Off | Type | Name | Evidence |
|---|---|---|---|
| 0x0 | char* | unk_0 | _ROOM_INFO arg 4 (only when argc >= 4) via mgCopyString; no reader found |
| 0x4 | char* | title | _ROOM_TITLE (default "err"); GetFloorTitle; CStartupEpisodeTitle shows it |
| 0x8 | s8 | floor_id | _ROOM_INFO arg 1; GetDngMapFloorGlidInfo matches it (lb) |
| 0x9 | s8 | order | _ROOM_INFO arg 2; NextFloorID/NextRoot only follow links to rooms with greater value. Arg 3 is read and discarded |
| 0xC | u32 | flag | init 1; _ROOM_OPTION ORs keyword values (table at_886: start 2, exit 4, boss 8, sub 0x10; and always 1). dngmenu: 2 entrance, 4 drawn differently |
| 0x10 | s32 | fast_destroy_time | _ROOM_FLOOR_INFO arg 2; IsClearMostFastDestroy: `(SaveData+0x1A00 - battle+0x90)*6/5 < this` |
| 0x14 | s8 | seal | _ROOM_FLOOR_INFO arg 5; IsSealFloor; LoadDungeonMapFile sets save bit `1 << (seal-1)` |
| 0x15 | s8 | spheda | arg 6; IsPlaySubGame bit 1; DrawDngRoomInfo icon |
| 0x16 | s8 | geostone | arg 1; IsGeoStone (lb); AutoSetTreasureBox |
| 0x17 | s8 | fishing | arg 3; IsPlaySubGame bit 2; CheckFishingRecord sign test |
| 0x18 | s16 | fishing_record | arg 4; compared with `(s16)(size*100)` (dngmenu notes guessed "message no"; wrong) |
| 0x1A | s8 | practice_type | init -1; _ROOM_FLOOR_INFO2 arg 1; IsClearPractice |
| 0x1C | s32 | practice_param | _ROOM_FLOOR_INFO2 arg 2 |
| 0x24 | s16[3] | spheda_prize_item | _ROOM_FLOOR_INFO pairs; GetSphedaPrize out 1 |
| 0x2A | s8[3] | spheda_prize_num | GetSphedaPrize out 2. "item"/"num" is an inference from the s16/s8 pair, not proven |
| 0x2E | s16[4] | link | _ROOM_LINK (argc entries); GetNextRoom, NextFloorID, NextRoot (negative = none) |
| 0x36 | s16[4] | key_room | _ROOM_KEYROOM; GetKeyNextRoom (CMenuTreeMap::Step) |
| 0x3E/0x40 | s16 | offset_x/y | init 0/0 (ROOM_INFO), boss/sub: 0/-26 unless args given; DrawRoomOne adds them |
| 0x42 | s8 | tex_no | _ROOM_TEXNO; negative n -> `D_0036178C[abs(n)] + GetRandI(4)`; DrawRoomOne |
| 0x44 | s8 | selectable | init 0 by `_ROOM_INFO`; CheckDrawGlidInfo sets 1 for every room; CMenuTreeMap::Step moves the cursor only onto rooms where it is 1 (signed load) |
| 0x45 | u8 | visited | CheckDrawGlidInfo: save `visit_count` (0x12) != 0; dngmenu draws differently |
| 0x46 | u8 | mark | CheckDrawGlidInfo: save flag OPEN && !UNK_2; DrawRoomOne bobbing mark |
| 0x48 | float | mark_phase | init 0 (sw zero); DrawRoomOne advances it, wraps 2pi |
| 0x4C | s32 | unk_4c | init 0 only |

## Functions / return values
- LoadDataTable: dng_no clamped to 0..6; files "menu/dngmap/mapd%d.cfg", "menu/dngmap/flrd%d.cfg"
  (LoadFile2 into a 40 KiB stack buffer, MenuCalcBufAlignment), "flrtitle%d.txt" (LoadFileMenu);
  each via AnalyzeFile. AnalyzeFile sets tree_dngmap/tree_spi_stack, Align64, runs a stack
  CScriptInterpreter (0xED0 bytes) with tree_map_tag, Align64, RelationGlid.
- `__nwa__FUiP1` (placement array new, odd mangling) used by _TREE_MAPINFO.
- IsGeoStone / IsSealFloor return the s8 field (lb), so `s8` return type.
- IsSealFloor: floor < 0 -> player's floor. Seal 0 when save flag SEAL_CLEAR (0x400). Seal 1 kept
  only if party has bit 2 (USER_CHARA_MONICA), seal 2 only if bit 1 (USER_CHARA_MAX).
- IsClearMostFastDestroy: 0 none; 1 first clear under target (adds medal, sets FAST_DESTROY_CLEAR);
  2 improved best time.
- IsClearPractice(check_type): `diff_conditiontable[type + check_type*7]` must be non-zero:
  check_type 0 allows types 0-4, check_type 1 type 5. Type 0: battle+0x5C and battle+0x10 <
  practice_param. Types 1-4 test `battle+0x98` bits against check_bittable (1: row0, 3: row1,
  4: row2) and cbit (type 2, row practice_param-1); then require bit `1<<practice_param`. Type 5:
  2, or 1 when bit 0x80. Then 2 -> 3 if PRACTICE_CLEAR already set; 2/3 set PRACTICE_CLEAR; 2 adds
  a medal. Practice types are not named (meaning of the battle-area bits not established).
- GetNextGlid(glid, &dir): search_tbl_1366 (dng 2), _1370 (dng 3), _1372 (else): int[4][3] of
  candidate directions; first with link_glid non-NULL becomes *dir.
- GetNextRoom(floor, dir, glid, unused, &found_dir): params 3/4 unused. at_1395 int[4][3]; tries
  link[row[0]], link[row[1]].
- GetDngMapNextFloorID(floor, root_type): dng 2 floor 8 -> 8 (no lookup). Returns floor_id (s8) of
  the onward room whose first passage cell has root.type == root_type; else 0.
- GetDngMapNextRoot(floor): floor 100 -> 1; else OR of `1 << root.type` of onward passages.
- GetFloorTitle: dng 1 floor 100 -> `fl_t_1467[min(LanguageCode,1)]` (Japanese / "Wonder Forest").
- GetCountSphedaClear: 7 dungeons x 0x28 floors, counts `spheda_clear != 0`; stops a dungeon at
  the first NULL record.
- CheckFishingRecord(size): returns 1 (and adds a medal, sets FISHING_CLEAR) when newly beaten.
- CheckDrawGlidInfo uses `at_1259` = floors per dungeon {9,16,25,21,23,29,39}.

## Unresolved
- GLID_INFO 0x6/0x8, room 0x0 string, 0x4C meaning; root [1]/[2] signedness (0x44 is `selectable`).
- DNGMAP_FLOOR_SPECIAL (100) meaning beyond the two special cases above.
