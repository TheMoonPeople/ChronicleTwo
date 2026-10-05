# gamedata: reverse-engineering notes

## C++ draft status
All 67 functions have C++ in `ps2/src/gamedata.cpp`. 20 are exact and compiled
by the matching build. 25 more compile to retail's bytes in isolation but stay
under `NONMATCHING`. 22 differ from retail and keep the `INCLUDE_ASM` fallback.
Each function tried has its one promotion attempt recorded in
`scripts/re/promotion_attempts.tsv`.

Master item tables, filled by running `CScriptInterpreter` over `menu/cfg7/*.cfg` with the tag
table `gamedata_tag`. No counterpart in the first game (its `itemdata` is a different system).

## Files and tags
- `LoadData` loads, via `LoadGameDataAnalyze("menu/cfg7/%s")`: `comdat.cfg`, `wepdat.cfg`,
  `itemdat.cfg`, `atdat.cfg`, `robodat.cfg`, `fishdat.cfg`, `grddat.cfg`.
- `LoadItemSystemMes(n)` loads `menu/cfg7/comdatmes%d.cfg` (n = language; called from
  `LanguageChange`) into a 0x2800-byte `mgCMemory` buffer (`gamedata_sysword_buffer_1073`);
  `_MES_SYS` copies each name there (`gamedata_build_stack`), converting via `ConvertFontCode`
  when `LanguageCode` is 2..5.
- `gamedata_tag` (0xC8 = 25 `SPI_TAG_PARAM`, last null): `_DATACOMINIT, _DATACOM, _DATAWEPNUM,
  _DATAWEP, _DATAWEP_ST, _DATAWEP_ST_L, _DATAWEP2_ST, _DATAWEP2_ST_L, _DATAWEP_SPE,
  _DATAWEP_BUILDUP, _DATAITEMINIT, _DATAITEM, _DATAATTACHINIT, _DATAATTACH_ST, _DATAATTACH_ST2,
  _DATAATTACH_ST_SP, _DATAROBOINIT, _DATAROBO_ANALYZE, _DATAFISHINIT, _DATAFISH, _DATAGAURDNUM,
  _DATAGAURD, ..., _MES_SYS, _MES_SYS_SPECTOL` (the tag-name strings are `at_1018`..`at_1041`).
- Every `*INIT`/`*NUM` tag stores the count into `GameItemDataManage.<x>_num` and resets the
  matching `Spi*` cursor to the table base. Tag routines all return 1 except the `SpiWeaponPt`/
  `SpiAttach == NULL` early outs.

## CGameData (0x30, `GameItemDataManage` .bss size 0x30)
`Initialize` stores: +4 `local_com_itemdata`, +8 `local_itemdata`, +0xC `local_weapondata`,
+0x10 `local_guarddata`, +0x14 `local_attachdata`, +0x18 `local_robodata`, +0x1C `local_fishdata`,
zeroes u16 +0x20..+0x2E, then `InitItemMes(1,1)`. Count fields pair with the pointers via the INIT
tags (+0x22 com, +0x24 item, +0x26 weapon, +0x28 guard, +0x2A attach, +0x2C robo, +0x2E fish),
read with `lhu` (u16). +0x20 = highest item number whose conversion-table slot is >= 0 (set in
`LoadData`; read by `MenuItemDebugKey`). +0 `unk_0`: never written in this unit; `LoadData`
returns it (`lw 0($this)`).

## Tables (all static; element counts from .bss sizes)
| symbol | size | element | count |
|---|---|---|---|
| local_com_itemdata | 0x4A40 | CDataCommon 0x2C | 432 (InitItemMes loops 0x1B0) |
| local_itemdata | 0xA20 | CDataItem 0x10 | 162 (`__sinit` construct_array 0xA2) |
| local_weapondata | 0x2270 | CDataWeapon 0x4C | 116 (0x74) |
| local_attachdata | 0x390 | CDataAttach 0x18 | 38 (0x26) |
| local_robodata | 0x990 | CDataRoboPart 0x24 | 68 (no ctor, no construct_array) |
| local_fishdata | 0x190 | CDataBreedFish 0x14 | 20 (0x14) |
| local_guarddata | 0x46 | s16 | 35 (stride 2 in GetGuardData) |
| local_itemdatano_converttable | 0x400 | s16 | 512: item_no -> index into com table, -1 empty |
`GetCommonData` accepts 0 < item_no < 0x200. Family getters then index the family table with
`CDataCommon::list_no` (< `<x>_num`) after checking `ConvertUsedItemType(type)`: weapon 3,
item 1/7/8, attach 2, fish 6; robo and guard do not check type.

## CDataCommon (name NOT retail -- no symbol names this struct; chosen to match siblings)
Written by `_DATACOM` (stride 0x2C): +0 u8 type, +2 s16 item_no (convert-table key), +4 s16
list_no, +0x1C u8, +0x1E s16, +0xA u16 (clamped to 0x90 when weapon family and >100), +0x20 u8,
+6 s16, +8 s16, +0xC char[16] (strcpy of string arg), +0x24 u32, +0x28 zeroed (name ptr).
- +6 icon_no (`GetItemIconNo`), +8 message_no (`GetItemMessageNo` adds `msg_offsettbl_1363[k]`
  = {0, 10000, 0}), +0xC file_name (`GetItemFileName`), +0x24 attribute (`GetItemDataAttribute`;
  bit1 `IsTrush`, bit2 `IsSpectolTrans`), +0x28 name (`GetItemMessage`, `SearchItemByName`).
- +0xA max_num: `CGameDataUsed::AddNum` clamps counts to it. +0x1E stack_num:
  `CheckStackRemain` = it - GetNum. +0x1C active_set: `IsActiveSet` returns it. +0x20 unknown.

## Item type (CDataCommon::type) -> ConvertUsedItemType
1..4 -> 3 weapon; 5..10 -> 4 (unknown; path `main/chr/` like weapons); 0xB and >=0x14 -> 1 item;
0xC..0xF -> 5 robo part (`dungeon/robo/`); 0x10..0x13 and 0x22 -> 2 attach; then overrides
0x1C -> 7 (CGameDataUsed gift box, `CopyDataGiftBox` sets used type 7), 0x1E -> 6 fish,
0x23 -> 8 (`CGameDataUsed::Boiled` sets used type 8). The used-type values match
`CGameDataUsed`'s first s16. Raw item types not enumerated: meanings mostly unknown
(0xD/0xE robo parts with joints, 0x11 special count in GetNum, 0x1A dungeon key).

## CDataItem (0x10)
Ctor: sw 0, sw 4, sh 0xA/0xC/0xE (0x8 NOT cleared). `_DATAITEM` args: [1] -> +4 (if bit 0x800000
set it becomes `(v & ~0x800000) | 0x142A8000`), [2] -> +0, [3] -> +8, [4..6] -> +0xA/+0xC/+0xE.
`GetUsedItemAfterEffect` copies to USEITEM_EFFECT: +4 -> e+0, +0 -> e+4, +8 -> e+8 (u16),
+0xA/+0xC/+0xE sign-extended -> e+0xC/+0x10/+0x14. In `MenuUseItemCheckFunc` e+0 is the
"MenuUsedItemType" flag word (0x100, 0x400, 0x1000 tested), e+4 tested for 0x10 on a dead chara,
e+8 tested per target kind (6/0x10 chara, 0x20 item, 8 robo) -> names use/status/target flags are
from that usage; e+0xC.. read as an int array indexed by count of effects applied.
## USEITEM_EFFECT
`Init_USEITEM_EFFECT` (static) clears +0..+0x1B. Size not asserted: caller stack has next local at
+0x20, so 0x1C or 0x20.

## CDataWeapon (0x4C)
Ctor: memset 0x4C, +0 = +2 = 20. Loader: `_DATAWEP` +0,+2; `_DATAWEP_ST` +4,+6; `_DATAWEP_ST_L`
+8,+0xA; `_DATAWEP2_ST` +0xC..+0x1A; `_DATAWEP2_ST_L` +0x1C..+0x2A; `_DATAWEP_SPE` +0x38 (u8 from
float), +0x46, +0x47, +0x39, +0x2C (u32), +0x48 (argc>5), +0x49 (argc>6); `_DATAWEP_BUILDUP`
+0x3A..+0x3E, +0x40..+0x44 (argc>3), then advances cursor 0x4C.
- +0 -> CGameDataUsed+0x10/+0x14 (COMMON_GAGE floats, capped 255, grown in LevelUp): durability.
- +2: `LevelUp` sets used+0x18 = w[2] + (w[2]/2)*level; used+0x1C (exp) >= it triggers LevelUp.
- +4/+6 -> used+0x22/+0x24; +8/+0xA are their caps in `CheckParamLimmit`. +0xC[8] -> used
  +0x26..+0x34, capped by +0x1C[8]. `IsBuildUp` compares target weapon's +4 and +0xC[8] (x0.9)
  with used +0x22 and +0x26.. -- +4 is very likely attack, kept as `status[0]`.
- +0x2C -> used+0x38 special bits (OR'd like CDataAttach+0x14). +0x30..0x37 never touched here.
- +0x38 -> used+0x3C (u16). +0x39 `AddFusionPoint` in LevelUp. +0x3A[3] build-up weapon item
  numbers (`IsBuildUp`). +0x40[3] monsters, `CheckBuildUpMonsterCondition` -> `KillMonsterCount`.
- +0x46 `GetPalletColor`, +0x48 `GetAttackType`, +0x49 `GetModelNo` (retail function names).

## CDataAttach (0x18)
Ctor memset 0x18. `_DATAATTACH_ST` +0,+2; `_ST2` +4..+0x12; `_ST_SP` +0x14 u32 then cursor += 0x18.
`CopyDataAttach` copies +0..+0x12 to used+0x12..+0x24 and ORs +0x14 into used+0x2C.

## CDataRoboPart (0x24)
`_DATAROBO_ANALYZE(item_no, kind, a, b, ...)`: +0 = a, +0x22 (u8) = b, then by kind:
0: +0x1C, string ignored; 1: +6,+8,+0xA, +0xC..+0x1A, +0x1E, string ignored; 2: +4, +0x20; 3: +2.
Cursor += 0x24. `GetUseCapacity` returns +0; `GetRoboInfoType` returns +0x1E for type 0xD and
+0x20 for type 0xE (used as attack type by `GetAttackType`); `GetOffsetNo` returns +0x22 (used
for joint/sound file names). `CopyDataRoboPart`: +6 -> used+0x18/0x1C, +2 -> used+0x10/0x14,
+0x1C -> +0x34, +4 -> +0x36, +8..+0x1A -> +0x20..+0x32.

## CDataBreedFish (0x14)
Ctor memset 0x14. `_DATAFISH(item_no, float, ...)`: +0 float, +4, +6, +0xA, +0xC, +0xE, +8,
+0x10 (argc>7). +0 is the standard size (`SetFishAdjustScale`, `sgInitGyoRace` divide by it).
`CopyDataFish` copies +6,+0xA,+0xC,+0xE,+8 into BREEDFISH_USED (used+0x3E,+0x36,+0x38,+0x3A,+0x3C).

## Guard data
s16 per entry; `_DATAGAURD(item_no, v, 5 ignored ints)` writes only +0.

## CItemUseTarget (0x8)
`SetPtr`: +0 = type; +4 = ptr for type 0..3 (four separate `if`s, i.e. probably a union of four
typed pointers in retail). Callers stack-allocate 8 bytes and pre-set +0 = -1: the inline
default ctor `CItemUseTarget() { type = ITEM_USE_TARGET_NONE; }` (-1), also run by menucls1's
`__sinit` for `MenuUsedTarget`. Kinds from `MenuUseItemCheckFunc`: 0 chara status (COMMON_GAGE first),
1 CGameDataUsed*, 2 ridepod (ROBO_DATA, item 0x17D), 3 monster transform
(`GetMonsterBajjiDataPtrMosId`). Global instance `MenuUsedTarget` lives in menucls1.

## Globals
Global (in header): `etcitem_spectol_table` (0x352 = 425 x {s8 slot, s8 value}, indexed by
item_no-1; slot < 8 -> ATTACH_USED+6+2*slot, slot > 9 -> ATTACH_USED+2*slot-0x12, i.e. the
attribute[8]/status[2] shorts at CGameDataUsed+0x16/+0x12), `SpiWeaponPt`, `SpiItemPt`,
`SpiAttach`, `SpiRoboPart`, `SpiFish`, `GameItemDataManage`.
Static (local in retail; keep in the .cpp): `gamedata_tag`, `ItemCmdMsgTbl` (0x108 = 33 rows of
8 s8; `ItemCmdMsgSet` emits row[i]+5000 until < 5000, then -1), `table_1553` (s16[8]; 7 ridepod
core item numbers 0xF6..0xFC, -1), `msg_offsettbl_1363` (s16[3]), `gamedata_build_stack`
(mgCMemory*), `comdatapt` (CDataCommon*), `comdatapt_num` (int), all `local_*` tables,
`gamedata_sysword_buffer_1073`, `filename_1267` (char[0x20]), `item_file_path_1288` (char[0x80]).
Static functions: all `_DATA*`/`_MES_SYS*` tags, `LoadGameDataAnalyze`, `ItemCmdMsgSet`,
`Init_USEITEM_EFFECT`.

## Misc
- `GetItemFileName(no, ext)`: types 5 and 8 append "t" when save bit flag 799 is set; ext==1
  appends ".chr". Uses `GetSaveData`/`CSaveData::GetBitFlag`.
- `GetItemFilePath(no, alt)`: dir `dungeon/robo/` (family 5), `main/chr/` (3,4), else `item/`;
  alt==1: weapons -> `wep_t/%s_item.chr`, types 0xD/0xE -> `wep_t/%s.chr`.
- `CheckItemEquip(chara, item)`: 0x12A only chara 0, 0x160 only chara 1, 0x171 only chara 0.
- `GetItemMessageNo` second argument indexes `msg_offsettbl_1363`.
- `ATTACH_USED` is a userdata struct (CGameDataUsed+0x10); only forward-declared here.
- Return types: `GetDataType` lbu -> u8; `GetItemIconNo`/`GetDataTypeStartListNo`/
  `GetRidePodCore` lh -> s16; `GetOffsetNo` lbu -> u8.
- `CDataRoboPart::GetOffsetNo` returns `offset_no` at +0x22 directly; the C++
  getter matches and links into a byte-identical game image.
