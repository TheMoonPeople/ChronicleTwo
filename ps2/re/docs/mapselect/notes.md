# mapselect notes

No class is owned by this unit (`class_units.tsv` has none). All functions and
data in the unit are native C++ and the complete object matches retail.

## Mangling
- `P1` in `LoadMapName__FiP1` and `LoadEventViewData__FP1P9mgCMemory` is `u_long128 *` (as in
  `LanguageChange__FiP1`, mainloop notes). Callers pass `read_buffer`.

## Linkage (from `build/re/local_symbols.tsv`)
- Local (static, belong in the .cpp): `mlMAP_NAME_NUM`, `mlMAP_NAME`, `GetMapNameInfo`,
  `MapTypeSelect`, `MapSelect`, `GetLine__FPPcPcPc__3` (local name `GetLine__FPPcPcPc`); data
  `map_sel_type`, `SelectMapName`, `tag` (`tag__7`), `select__1049`, `top__1050`, `SedSelData`,
  `config_str`, `MapNameNum`, `map_name`, `pMapNameBuff`, `pCharBuff`, `CharBuff`, `now_no`,
  `MenuStack`, `SelectMode`, `SelectMapType`, `select_1009`, `init_1010`, `SedSel`,
  `EventInfoNum`, `BossEventTop`, `sel_event`, `top_event`, `MapNameBuff`, `SelectMapList`,
  `SelectMapNum`.
- Global: all other functions (in the header); data `EventInfo` (0x37E49C) and
  `BossBattleSelFlag` (0x37E4B0, set to 1 by `mainloop` `EventSelect` case 6).

## Static prototypes for the .cpp
- `static int mlMAP_NAME_NUM(SPI_STACK *stack, int argument_count)` / `mlMAP_NAME(...)`: script
  tag handlers (match `SPI_TAG_FUNCTION`), both return 1. Args are `stack[i]` (SPI_STACK is 8 bytes).
- `static MAP_NAME_INFO *GetMapNameInfo(int map_no)`: null when `map_no < 0 || >= MapNameNum`.
- `static int MapTypeSelect()`, `static int MapSelect()`: both return 0 (`$v0 = 0`, 64-bit in Ghidra).
- `static char *GetLine(char **columns, char *p, char *end)`: splits one line on tabs into
  `columns[i]` (spaces dropped), stops at "\r\n", "\r" or "\n" (`at_1377` = `"\r\n"` as a local
  `char[2]` copy); returns the start of the next line.

## Static data types
- `static int MapNameNum; static MAP_NAME_INFO *map_name; static int pMapNameBuff` (offset in
  quadwords into MapNameBuff); `static int pCharBuff` (byte offset into CharBuff);
  `static char *CharBuff; static int now_no` (next MAP_NAME row).
- `static char MapNameBuff[0x8000]` (the mixed record/string arena; indexed in bytes as `MapNameBuff + p*16`). It has file-local linkage.
  `mlMAP_NAME_NUM` puts `(n+1)` MAP_NAME_INFO rows at quadword `pMapNameBuff`, advances by
  `(n+1)*0x1C/16 + 1`, and CharBuff follows; LoadMapName then advances by `pCharBuff/16 + 1`.
- `static SPI_TAG_PARAM tag[3]` (the LoadMapName command dispatch table): `{"MAP_NAME_NUM",
  mlMAP_NAME_NUM}, {"MAP_NAME", mlMAP_NAME}, {0,0}`. Symbol size 0x18, file holds 0x20 (padding).
- `static char *map_sel_type[8]`: "New", "Georama", "PalmBlinks", "Submap", "Future", "Dungeon",
  "Event", "Special" (-> `MapSelType`).
- `static char SelectMapName[0x100]`: name chosen by MapSelect (strcpy); returned by GetMapName
  for an out-of-range map number.
- `static char **SelectMapList[8]; static int SelectMapNum[8]`: per category, `new (Alloc(0x22))
  char*[0x80]` (placement `__nwa__FUiP1`, 0x200 bytes, zeroed), filled with `mgCopyString` names.
- `select__1049[16]` and `top__1050[16]` are 0x40-byte cursor and first-visible-row
  arrays indexed by `SelectMapType` (eight rows shown). They remain file-scope
  statics: moving them into `MapSelect` makes MWCC emit
  `select__1049_479` and `top__1050_480`, leaving their retail data pieces
  unresolved and changing the function's object. Their suffixes are a
  documented matching exception pending a natural local source form.
- `select_1009`/`init_1010` (u8 guard): function-local static `select` of MapTypeSelect.
- `static int SedSelData[6]` (0x18; file holds 0x20): indexed like `SaveDataEditItem`:
  [0] progress (mirrors CSaveData+0x1A08), [1] unused, [2] flag number, [3] geo comp town,
  [4] play time count flag, [5] config value (incremented on RIGHT, reset to 0 every frame).
- `static char *config_str[1]` = {"Caption off"} (.sdata size 4; next word 0).
- `static int SedSel` (`SaveDataEditItem`), `static int SelectMode` (`MapSelectMode`),
  `static int SelectMapType` (`MapSelType`), `static mgCMemory *MenuStack`.
- `static int EventInfoNum, BossEventTop, sel_event, top_event` (event viewer; 10 rows shown).
- `at_1125`/`at_1270` = `{"  ", ">>"}` (cursor markers, indexed by `selected`), `at_1128` =
  `{"OFF", "ON"}`: local `char *[2]` initialisers copied to the stack.

## MAP_NAME_INFO (0x1C)
Size: `memset(..., 0, 0x1C)` per row and stride 0x1C in SearchMapNo/GetMapNameInfo.
`SearchMapNo` indexes the `MAP_NAME_INFO` table by its entry number. The
typed `map_name[search.no]` access preserves its 0x90-byte PAL object without
the separate byte offset.
`MAP_NAME` tag args: 0 name, 1 title, 2 add_path (strings copied into CharBuff, null when empty),
3 -> +0xC type, 4 -> +0x10 sel_type, optional 5 -> +0x14 snd_data_id (default -1),
optional 6 -> +0x18 area_no (default 0 from memset).
Getters: +0x0 GetMapName (+0x4 to `*title`), +0x4 GetMapTitle, +0x8 GetAddMapPath, +0xC GetMapType
(-1 default), +0x10 GetMapSelType (0 default), +0x14 GetMapSndDataID (-1), +0x18 GetMapAreaNo (-1).
`type` values seen: 1 (editloop: georama map, edit data saved/loaded, CreateTable), 5 (editloop
EditMapJump: town with PartsOnOff), 2/4/6 (dngmenu CMenuTreeMap::Step). Meaning not established,
so no enum; left `int`.

## EVENT_VIEW_INFO (0x1C)
Size: `Alloc(0x382)` + `new[] 0x3800` = 0x200 rows; `memset(row, 0, 0x1C)`; stride 0x1C.
File `event/view_pal.txt`, tab-separated, read by GetLine into `char *cols[16]` over a
`char [16][0x80]` stack buffer:
- cols[0] map name -> +0x10 map_no = SearchMapNo(cols[0]); if cols[1] non-empty: map_no =
  atoi(cols[1]) - 1, +0x14 floor_no = atoi(cols[2]), +0x18 dungeon = 1.
- cols[3] -> +0xC event_no; cols[6] -> +0x0 name, cols[7] -> +0x4 detail (mgCopyString).
- cols[8] != "B" increments BossEventTop (count of non-boss rows = index of first boss row).
- +0x8 is never written or read (`unk_8`).
EventViewLoop: prints "%s%s   %s\n" (marker, name, detail); on CIRCLE with map_no >= 0 builds an
INIT_LOOP_ARG: map_no = +0x10, floor_no (0x44) = +0x14, event_no (0x48) = +0xC, and calls
`NextLoop(dungeon ? LOOP_DUNGEON : LOOP_EDIT, arg)`; returns 1. CROSS returns 2. Pad masks 0x8004
(LEFT|L1) / 0x2008 (RIGHT|R1) page by 10.

## Return values
- MapSelectLoop: SelectMode 2 -> 2, 1 -> MapSelect, 0 -> MapTypeSelect (both then 0), -1 -> 1,
  else 0. MenuLoop: 2 enters LOOP_EDIT with map_no -1 (map comes from SelectMapName via
  GetMapName), 1 returns to the top menu.
- SaveDataEditLoop: `Down(PAD_CROSS) != 0` (Ghidra shows bool; declared int).
- GetMapPath returns the final `strcat` result (path). Builds `"map/" + name[0] + "/"`, then if
  strlen > 2 `name[0..3] + "/"`, if > 5 `name[3..6] + "/"`, then name.

## SaveDataEditLoop offsets
CSaveData+0x1A08 progress (int), +0x1A10 time of day (float, wraps % 24; TRIANGLE toggles 12/0,
also CScene::SetTime), +0x1C5A8 config caption byte (toggled by CIRCLE). `DAT_003faf38` =
`DebugInfo.georama_debug` (DebugInfo at 0x3FAF30), set to 1 on SED_GEO_COMP confirm, then
`CEditData::dbgSetAllContintionFlag(town, Down(CIRCLE))`.

## AtraMiriaOnOff
`CCharacter2` +0x70 is its `mgCFrame *`; `SearchFrame` result +0xF4 is `mgCFrameAttr *attr`,
+0x18 is `attr->draw` (`mgFrameDrawFlag`). on == 0 -> 2 (SKIP_CHILDREN); on != 0 -> type 0:
"atoramiria" 5 (VISIBLE|SKIP_BY_PARENT), "himo" 1; type 1: "atoramiria" 1; type 2: "atora" 5.
Called by charasetup `SetupUnitMan(scene, user, chara_type, ...)` with chara_type when save bit 8
is set; so `type` is that chara_type.

## Current function behavior
The map script handlers populate `MAP_NAME_INFO` records in `MapNameBuff` and
copy their strings into the adjacent character buffer. The map selector builds
per-category lists from `map/map.lst`, while the save editor changes story
progress, time, flags, Georama completion, play time, and caption settings.
The event viewer reads `event/view_pal.txt` as tab-separated records and
passes a selected town or dungeon event to `NextLoop`. `AtraMiriaOnOff`
changes the draw flags of three named model frames according to character
type.


## Native data and matching constraints

All data are native. `MapNameBuff` is a file-local 0x8000-byte character arena
containing variable numbers of 0x1C-byte records followed by strings. `select__1049[16]`
and `top__1050[16]` each own 0x40 bytes, although only eight categories are indexed.
Both retain file-scope definitions: moving them to natural function-local names changes
compiler symbols, leaves retail data targets unresolved and fails complete-object
checking.

`MapTypeSelect` owns a four-byte static selection and one-byte compiler guard. The
guard's four-byte retail reservation includes alignment. `SelectMapName[0x100]`, eight
category-name pointers, `tag[3]`, six save-editor values and the one-pointer
configuration caption retain their declared sizes; extra zero tails are padding.

The cursor aggregates contain string pointers (`"  "`, `">>"`), not colors; OFF/ON uses
the same pointer-pair type. Their strings must migrate with the aggregate to preserve
pooling and layout. Migrating the cursor aggregate alone produces two extra read-only
pieces and grows PAL by 0x80. `GetLine`'s CR/LF pair owns exactly two bytes without a
terminator.
