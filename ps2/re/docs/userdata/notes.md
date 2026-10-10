# userdata: reverse-engineering notes

`BattleParamater` is a native `CBattleCharaInfo` global; its inline constructor calls
`Initialize` and produces the 12-byte retail `__sinit_userdata_cpp`. `CheckVoiceUnit` and
`AddYarikomiMedal` return `int` even though they read narrower stored fields. Their definitions
and the callers' return-value handling match retail with the wider declarations.

Header: `ps2/include/userdata.hpp`. Owns `COMMON_GAGE`, `CGameDataUsed`, `ROBO_DATA`, `MOS_CHANGE_PARAM`,
`CMonsterBox`, `CFishAquarium`, `CFishingRecord`, `CFishingTournament`, `CUserDataManager`,
`CBattleCharaInfo` (all retail names from mangled symbols). It also declares these plain structs:
`ATTACH_USED`, `BREEDFISH_USED`, `CHARA_DATA` (retail names, from `SetItemSpectolPoint__FiP11ATTACH_USEDi`,
`CalcBreedFishParam__FP14BREEDFISH_USED`, `MenuItemCharaViewCheck__FP10CHARA_DATAii`), and
`ITEM_USED`, `WEAPON_USED`, `ROBOPART_USED`, `GIFTBOX_USED`, `BOILED_USED`, `MOS_HENGE_PARAM`,
`FISH_RECORD`, `FISH_TOURNAMENT_ENTRY`, `PARTY_CHARA_INFO`, `BATTLE_WEAPON_PARAM` (our names). The enums
`USER_CHARA`, `BATTLE_CHARA_TYPE`, `CHARA_STATUS_ATTR` and `SPECTOL_TYPE` are ours too. The first game has
no counterpart of any of these classes.

No class in the unit has virtual functions (no `__vt__` symbol, no vtable stores).

## Header dependencies
- `gamedata.hpp`: `USED_ITEM_TYPE` (the values of `CGameDataUsed::used_type`), `CDataWeapon`.
- `CInventUserData` and the records it holds (`USER_PICTURE_INFO`, `INVENT_CREATED_ITEM`, `SCOOP_INFO`,
  `CScoopDataManager`) are declared in userdata.hpp although their functions are in inventmn: CUserDataManager
  holds a `CInventUserData` by value, while inventmn.hpp needs userdata.hpp (CGameDataUsed), menusys.hpp and
  memcard.hpp (which reaches savedata.hpp and so CUserDataManager). Declaring them here makes the header graph
  acyclic. Header order (acyclic, each includes only what it needs by value): gamedata < userdata < menusys < savedata < memcard < inventmn.
  userdata.hpp includes only gamedata.hpp.
- `CInventUserData` is 0x3CE60 (ends with `unk_3cd60[0x100]`), which fills 0x7F30..0x44D90.
  Its `Initialize` only touches up to 0x3CD60, so the last 0x100 bytes could equally belong to
  `CUserDataManager`. Nothing in the game accesses them.
- `CInventUserData` has the inline constructor `{ Initialize(); }` that the `CUserDataManager` constructor
  needs (see below).

## Constructors and static initialisation
- `CUserDataManager::CUserDataManager()` (0x1957C0, emitted in mainloop) is the IMPLICIT constructor and
  is not declared in the header. Its body is exactly the member constructors in order: 150 x
  `CGameDataUsed()`, `CHARA_DATA` x2 (inner loops 0x2C..0x170 and 0x170..0x38C), `ROBO_DATA::parts`
  (0x4690..0x4840), `esa` (0x4880..0x4958), the three aquarium tanks then `CFishAquarium::Initialize`,
  `CInventUserData::Initialize`, `CFishingTournament::Initialize`, `CFishingRecord()`. So
  `CFishAquarium`, `CInventUserData` and `CFishingTournament` have inline constructors that call
  `Initialize()`. `CFishingRecord()` is out of line (0x19C330, memset 0x340). `CMonsterBox`,
  `MOS_CHANGE_PARAM`, `PARTY_CHARA_INFO`, `COMMON_GAGE` have no constructor (no calls emitted).
- `__sinit_userdata_cpp` (0x379C90) calls `CBattleCharaInfo::Initialize(&BattleParamater)`. That is the
  inline constructor `CBattleCharaInfo() { Initialize(); }` on the global `CBattleCharaInfo BattleParamater`.
- `CGameDataUsed()` (0x1985A0) is out of line and only calls `Init()` (memset 0x6C).

## CGameDataUsed (0x6C)
Size from `Init` memset 0x6C, every array stride, `memcpy(...,0x6C)` in `CopyGameData`.
`GetUseCapacity` reads `CDataRoboPart::use_capacity` at offset zero; accessing the named field
instead of casting the record to `short *` produces byte-identical code for the whole unit.
- 0x0 s16 `used_type`: `ConvertUsedItemType` result (`CopyDataItem(int)`), 1 item, 2 attach, 3 weapon,
  4 item family 4, 5 ridepod part, 6 fish, 7 gift box, 8 boiled (`Boiled`). 0x2 s16 `item_no`.
  0x4 s8 `item_type` (common data type; `IsWhoEquip` compares as `(char)`). 0x5 s8 `rename_flag`
  (`SetName`: 1 when strcmp with `GetItemMessage` differs; `GetName(2)` indexes `symbol_tbl_1338` by it).
  0x6..0x10 never seen.
- 0x10: union by `used_type` (0x5C bytes). Evidence that the union starts at 0x10: `ToSpectolTrans` passes
  `(ATTACH_USED *)(dst+0x10)`; `CheckParamLimmit`, menuaqua and gyorace pass `(BREEDFISH_USED *)(x+0x10)`.
- ITEM_USED (types 1, 4): +0 s16 `num` (`GetNum`/`AddNum`; capped by `CDataCommon::max_num` at +0xA);
  +2 zeroed by `CopyDataItem`.
- ATTACH_USED (offsets relative to 0x10): +0 `spectol_type` (`ToSpectolTrans`: 4 fish/item, 2 attach,
  3 weapon < level 5, 1 weapon >= 5), +1 `spectol_value` (count; weapon level capped at 20; rand 1-4;
  `GetMsgAddInfo` shows it), +2 status[2] and +6 attribute[8] (`CopyDataAttach` copies the 10 s16 of
  `CDataAttach`; `SetItemSpectolPoint` writes index<8 at +6+2i and index 10/11 at +2/+4), +0x16
  `spectol_item_no` (`GetSpectolNo` when item_no 0xB9), +0x18 `level`, +0x1C `special` (OR'd from
  `CDataAttach::special`), +0x20 name (`SetName`/`GetName` for item 0xB9), +0x3A `num`. The name lies at
  0x30..0x4A of the item, so it is at most 0x1A bytes, but `SetName` accepts up to 31 characters.
- WEAPON_USED: +0 COMMON_GAGE `whp` (max = now = `CDataWeapon::durability`; capped at 255),
  +8 COMMON_GAGE `abs` (max = `levelup_exp` grown by half of itself per level, now reset on level-up;
  `IsLevelUp`: max <= now), +0x10 `level` (<= 99), +0x12 status[2], +0x16 attribute[8] (copied from
  CDataWeapon status/attribute; limited by status_max/attribute_max in `CheckParamLimmit`), +0x28 `special`,
  +0x2C `fusion_point` (initial value = CDataWeapon byte 0x38, + byte 0x39 per level; limit 999 or 9999 for
  rods 0x12E/0x12F), +0x2E and +0x30 zeroed, +0x33 name. `GetActiveElem` = index of the largest of
  attribute[0..3]; `GetEffectReadType` uses `magic_str_1462[elem]`. `GetStatusParam` weapon 0x38 halves or
  raises status[0] by time band (`GetTimeBand`).
- ROBOPART_USED: +0 gauge (max = now = CDataRoboPart+2), +8 gauge (CDataRoboPart+6), +0x10 status[10]
  (CDataRoboPart +8..+0x1A), +0x24 `defence` (CDataRoboPart+0x1C; `ROBO_DATA::GetDefenceVol` reads
  parts[1]+0x34), +0x26 (CDataRoboPart+4), +0x2C name. `GetWHp`/`Repair` use +8 for item type 0xD and
  +0 for 0xF.
- BREEDFISH_USED: +0 name (copied from the item message; 0x10..0x25, so <= 0x15 bytes), +0x15 `sex`
  (rand 2; `CheckHaigouTankSex` compares it), +0x16 rand 4, +0x18 `size` (fish size/2 + rand30 - rand10;
  `GetFishInAquarium` puts size*1000), +0x1A `weight` (400 + rand500 + rand500), +0x1C rand 4,
  +0x20 `hp` int 0..100, +0x24 `fatigue` (cleared by `AquaFishFatigueClear` with +0x3D), +0x26 param[5]
  (from CDataBreedFish +0xA, +0xC, +0xE, +0x8, +0x6; `CalcBreedFishParam` sums them, `CheckParamLimmit`
  keeps each <= 100 and the sum <= 400), +0x30 `timer` (`TimeCheck` subtracts elapsed), +0x35 zeroed,
  +0x36 200 + rand 51, +0x38 `flags` (bit 2 = electric: `CheckElectricFish`, `DeleteErekiFish`; exempts
  `IsTrush`), +0x3A 5-bit field (password), +0x3C rand 256, +0x40 `tank_day` and +0x44 `tank_hour` (set by
  `FishIntoAquarium` for tank 1 from main scene +0x2F68/+0x2F6C, read by `CFishAquarium::RefreshParam`).
  Size/weight naming follows `_GET_FISHINGTOURNAMENT_ETC`, which prints entry size/10 and sums weight.
- GIFTBOX_USED: +0 item_no[3] (`GetGiftBoxItemNo`, `SetGiftBoxItem`).
- BOILED_USED: +0 `base_item_no` (the fish's item_no), +2 name (`sprintf(basefish_1288[lang], name)`),
  +0x18 `value` = old fish +0x18 / 100 + (param[0..2] sum)/3 + 20. After boiling `used_type` = 8,
  `item_type` = 0x23, `item_no` = 0x1AA.

## COMMON_GAGE (8)
`max` at 0, `now` at 4: `GetRate` = now/max; `AddPoint` and `AddRate` clamp now to 0..max; `CheckFill`
max == now. The callers' fptosi of +4 is the current value, and of +0 the full value.

## CHARA_DATA (0x38C), CUserDataManager 0x3F48 + chara*0x38C
- Stride: `GetCharaDataPtr`. +0 `hp` gauge (Initialize: max = now = `lifetbl_2854[chara]`), +8 `status_attr`
  (`GetCharaStatusAttirbutePtr` 0x3F50), +0xA `defence` (Initialize 4 / 8; `GetDefenceVol`), +0xC..+0x12
  status_time[4] for attr bits 0x10, 0x2, 0x8, 0x20 (`SetCharaStatusAttirbuteVol`; counted down in
  `StatusParamStep`), +0x2B u8 (`CheckEquipChange`: when 0, Monica also gets default armour; then cleared),
  +0x2C active_item[3], +0x170 equip[5]. `equip[0]` of Max (0x40B8) is the fishing rod slot
  (`GetFishingRodNo` reads 0x40BA, `GameDataSwap`, `AddFp`, `GetRodStatus` reads 0x40DE..0x40E6, i.e. attributes
  0..4). `GetWHpGage` / `GetAbsGage` (chara 0/1) give equip[weapon]+0x10 / +0x18.
- Status bits: setting 0x10 clears 1 and 2 and blocks them while set; 0x8 or 0x20 block character change;
  bit 1 drains HP every 100 steps (`StatusParamStep`); 0x10 multiplies weapon attack by 1.5 in
  `RefreshParamater` (`at_4695` holds 1.0, 1.0). `ConvertItemAttrToCharaAttr` maps item bits 0x10000..
  0x10000000 to these bits. 0x7F = all (PlayerPartyCure, Step).
- `SetCharaStatusAttirbuteVol` writes the four character timers through `CHARA_DATA::status_time`,
  three ridepod timers through `ROBO_DATA::status_time`, and two badge timers through
  `MOS_CHANGE_PARAM::status_time_1` / `status_time_10`. All typed field stores retain the retail code.

## ROBO_DATA (0x220), CUserDataManager 0x4660
memset 0x220 in `Initialize`. +2 `name` (`SetRoboName` strcpy 0x4662; default from `robo_nametable_3330`),
+0x1C `voice_unit`, +0x1D `voice_flag`, +0x20 `hp` gauge (`GetCharaHpGage(2)` = 0x4680; `AddPoint`; energy
drained in `CBattleCharaInfo::Step`), +0x28 `abs` gauge (`GetAbsGage(2)` 0x4688; `AddRoboAbs` clamps +0x2C to
0..99999), +0x30 parts[4] (`CheckNowRoboUseCapacity`; `SetChrEquip(2)` slot by `SearchEquipType(2, i)`; when
parts[2] (0x4768) is overwritten `CGameDataUsed::CopyGameData` copies its +0x10 into the energy max),
+0x1E0 status_time[3] for bits 2, 8, 0x20, +0x1E8 `shield_kit_num` (menucls1 `CheckRoboShieldKit`,
limited by `GetShiledKitLimmit`; defence = parts[1].defence + 4*kits). `GetWHpGage(2)` = 0x46A8 =
parts[0]+0x18.

## MOS_CHANGE_PARAM (0xBC) and CMonsterBox (0x2F00), CUserDataManager 0x4EB0
- Stride 0xBC: `GetMonsterBajjiData`, `AllCure` (64 entries), menusys `MenuPosFormValueSetMonster`.
  CMonsterBox memset 0x2F00 = 64 * 0xBC; the next member (party info) starts at 0x7DB0 = 0x4EB0 + 0x2F00.
- +0 `no` = index (Initialize), +2 `level` (`LevelUp` < 98; `GetDegreeLevel` = level/6 <= 15), +4
  `class_level` (`CheckClassChange`: < 3 and < level/25), +6 `progress` (`get_default_monster_progresstbl`),
  +8 `monster_id` (`get_monster_tbl_bajjilevel`; default argument of GetAttackVol/GetDefenceVol;
  `CheckQuickChange` copies it into `CUserDataManager::monster_id`), +0xA `enable` (`EnableChange`, `IsChange`),
  +0xC `hp` gauge (Initialize 64/64; `GetWHpGage(3)`), +0x14 `abs` gauge (Initialize max 100; LevelUp max =
  level*100 + 100 + 25*(level-49) when level > 49; `GetAbsGage(3)`), +0x3C / +0x3E times for attr 1 / 0x10
  (`SetCharaStatusAttirbuteVol(3)`, `StatusParamStep`).
- `GetMonsterBajjiDataByMonsterID` = `GetMonsterBajjiData(get_gajji_id_from_monster_progress_table(id) + 1)`.
- MOS_HENGE_PARAM (0x1C): stride and count from `GetMonsterHengeParam` (57 rows; `mos_henge_param` is
  0x63C = 57*0x1C). +0 monster id, +2 attack (scaled by (level/98*2+1)), +4 defence (+2*degree). Results
  capped at 999.

## CFishAquarium (0x530), CUserDataManager 0x4958
Tanks at +4 [6], +0x28C [4], +0x43C [2] (`Initialize`, `GetAquariumFishTop`, `FishIntoAquarium` bounds);
`aquarium_fish_maxtbl` = the three counts. +0 and +2 zeroed. +0x518 u64 (`RefreshParam`: `%= 0x534`),
+0x520 s64 last save-clock (save data +0x1A00), +0x528 int / +0x52C float day/hour of the last 6-hour
step. Tank 1: with more than one fish, every 6 hours a fish with hp > 15 has
`param[4]` (battle strength, at BREEDFISH_USED +0x2E) incremented, loses 5 hp,
and has its parameters clamped. This does not increment the race fatigue
counter at +0x24. Tank 2 is the breeding tank (`CheckHaigouTankSex`). The size 0x530 is the end
of the last field Initialize touches. 0x4E88..0x4EB0 (0x28 bytes) is never accessed, so it is
`CUserDataManager::unk_4e88`. It could instead be the tail of CFishAquarium.

## CFishingRecord (0x340) at 0x45258, CFishingTournament (0x70) at 0x451E8
- Record: ctor memset 0x340; `GetFishRecord` = this + 0x40 + idx*0x20 with idx from
  `fish_record_dataindex_convert` (local, 0x26 bytes = 18 fish numbers + 0 terminator). FISH_RECORD:
  +0 size, +4 previous size, +8 weight, +0xC previous weight, +0x10 int count (wraps at 999999 -> 1).
  `CheckRecordFish` returns bit 1 for size and bit 2 for weight. 24 slots fit; only 18 are mapped.
- Tournament: Initialize memset 0x70; ResetRecord memset +0x20, 0x50; +4 `rank` (0..100); +0x20 entry[10]
  (stride 8: item_no, size (tenths), weight, pad). `SortRecord` sorts by weight; `CalcTopWeight` sums
  the top three weights.

## CUserDataManager (0x457A0)
Size: `Initialize` memset 0x457A0. Located at save data +0x1D2A0 (`GetUserDataMan`).
- 0x0 used_data[150] (`GetUsedDataPtr` 0..0x95). The first `GetItemBoardMaxNum(0)` entries (0x8A, or 0x90
  with save bit 0xFE) are the item board; the rest up to 0x96 are overflow (`GetItemBoardOverNum` 6/12).
- 0x3F48 chara_data[2], 0x4660 robo_data, 0x4880 esa[2] (`GetActiveEsa`: rod 0x12E -> 0x4880, 0x12F -> 0x48EC),
  0x4958 aquarium, 0x4EB0 monster_box, 0x7DB0 party_chara[32] (stride 0xC; Initialize sets +0 = -1 and
  +2 = 0; `JoinPartyChara` sets +4 from `GetPartyNPCData()+0x2F`; `UseNpcAbility` spends
  `GetPartyNPCData()+0x32+ability`; status bit 1 = in party, bit 2/4 other states, 0x80 = join with 2),
  0x7F30 invent_data.
- 0x44D90 `party_member` u16 bits (Join/LeavePartyMember 0..3), 0x44D92 `chara_change` u16 bits,
  0x44D94 u8 mask (`InitCharaChangeMask` 0xF), 0x44D96 `active_chr_no`, 0x44D98 `monster_id` (Initialize -1),
  0x44D9C `money` (0..999999), 0x44DA0 `yarikomi_medal` (0..999; shown for item 0x137).
- 0x44DC0 s16: menushop multiplies the price of item 0x1A7 by 1.1 per unit and increments it on purchase.
- 0x44DC8 u64 (`RefreshNPCStatus`: `%= 0x534`). 0x44DD0 s16[0x200] `photo_subject` (inventmn
  `CountNeta` counts values 1..999, `CountScoop` 1000..9999, `LevelCheck` appends
  USER_PICTURE_INFO+0xA). 0x451D0 u64 (`RefreshParam`: `%= 0x534`), 0x451D8 s64 (last save-clock, save
  data +0x1A00), 0x451E0 int / 0x451E4 float (save data +0x1A14 / +0x1A10: day / hour of the last NPC
  refresh). 0x451E8 tournament, 0x45258 record, 0x45598 `costume_bit` (unsigned long = 64-bit;
  `GetCostume` sets `1 << GetCosInfo(item)->+2`), 0x455A0..0x457A0 unknown.
- `GetEnableCharaChangeFlag` masks by party membership using the u32[4] literal `at_3192`.
- Main scene +0x2F9C bits 1/2 block Max/ridepod or Monica/monster changes. Main scene +0x2FF4 bits are
  set by item 0x131/0x132 in `GetItemNotOver`.

## CBattleCharaInfo (0x90)
Size: `Initialize` memset 0x90; global `BattleParamater` size 0x90.
- +0 `chr_no` (USER_CHARA), +2 = BASE_MONSTER_TBL +0x54 for a monster, +4 `now_npc` (`NowPartyCharaID`),
  +6 `chara_type` (0 human, 1 robo, 2 monster from `SetChrNo`), +8 data pointer (CHARA_DATA / ROBO_DATA /
  MOS_CHANGE_PARAM), +0xC float robo drain = parts capacity / core capacity * 0.006, +0x10 float monster
  drain (0.005, or 0.0025 with badge 12), +0x14 regen counter (special bit 0x100 on either weapon: +1 HP
  every 125 steps), +0x16 poison counter, +0x18 magic sword element (-1 cleared), +0x1A count, +0x1C s16[7]
  powers (`GetMagicSwordCounterMax` <= 7, from Monica weapon status[1]), +0x2C active item pointer, +0x30
  equipment pointer, +0x34 BATTLE_WEAPON_PARAM[2] (stride 0x1C: status[10], special at +0x14 (read at
  0x48/0x64), palette at +0x18 (read at 0x4C)), +0x6C defence, +0x74 COMMON_GAGE* hp (CHARA_DATA+0,
  ROBO_DATA+0x20, Monica's CHARA_DATA for monsters), +0x78 frames, +0x7C per-frame step, +0x80/+0x88 copies of
  hp max (set in SetChrNo, never read in this unit), +0x84 shown hp, +0x8C hp before the change. Initialize
  sets 0x80 and 0x84 to -1.
- `BattleParamater_Time` / `BattleParamater_TimeBand` (both local) cache the main-scene time and its band.
  `Step` refreshes when the band changes for Monica's weapon 0x38.

## Globals
- Global (in the header): `aquarium_fish_maxtbl` (.sdata 0x37C780, 3 bytes, read as signed char) and
  `BattleParamater` (bss 0x1EC94A0, 0x90, CBattleCharaInfo).
- Local (`build/re/local_symbols.tsv`), so they belong as `static` in the .cpp: `mos_henge_param`
  (MOS_HENGE_PARAM[57]), `fish_record_dataindex_convert` (s16[19]), `FishGamePreEquip` (CGameDataUsed*),
  `BattleParamater_Time` (float), `BattleParamater_TimeBand` (int, GetTimeBand result).
- Function-local statics: `basefish_1288` (format per language, Boiled), `symbol_tbl_1338` (GetName
  prefixes/suffixes, [rename_flag][lang] pairs, continues at 0x33A3D4), `word_1327` (0x70 bss, GetName
  result buffer; memset 0x61), `magic_str_1462` (char*[2] per element), `strtbl_1505` / `temp_1510` (0x40
  bss) GetMsgAddInfo, `htbl_1662` (s8[10] durability gains, LevelUp), `robo_nametable_3330`,
  `weptbl_4503` (s16 [lang 0/1][chara][5]), `at_table_5400` (u32[12], CheckWeaponAttribute),
  `equip_type_tbl_5456` (u8[3][5], SearchEquipType), `use_limmit_table_2558` (s8[7] for items 0xF6..0xFC),
  `lifetbl_2854` (s32[2] or float, starting HP; stored by word), `f_2005` (char*[2], model name prefixes),
  `tbl1_5167` / `tbl2_5168` (random-circle traps), DebugGetItem tables (`itemtbl_5745`, `start_tbl_5746`,
  `e3_town_5747`, `e3_dng_5748`, `e3_boss_5749`, `init_partytbl_5752`, `dbg_set1..3_577x`, `subgame1_5788`,
  `cureItemtable_5744`: s16 {item_no, count} pairs ending with item_no < 1).
- Local functions (static, not in the header): `GetConvertIndexFromFishNo(int)` 0x19C2E0 (index into
  fish_record_dataindex_convert or -1), `DeleteItem_Local(CGameDataUsed *, int item_no, int num)` 0x19FC80
  (deletes from one place or from a gift box's contents; returns the count removed).

## Return types and other uncertainties
- Return types are not part of the mangling. Mine follow the load width in the code: s16 for `lh`
  returns (GetNum, GetLevel, ...), u8 for `lbu` returns, and char for `GetModelNo`/`GetAttackType`, whose
  0xFF default `GetMainCharaModelName` tests with `< 0`. `CGameDataUsed::GetNum` may in fact be int.
  Check each one while matching.
- `ROBO_DATA::AddPoint` returns the gauge rate. Ghidra drops it, but menudraw `NowUseNeedItemCheck`
  uses it as a float.
- `GetMonsterBaseInfo` duplicates monster's `GetMonsterTable` (stride 0xB8 in `base_monster_define`), so
  it returns `BASE_MONSTER_TBL *` (forward-declared; the name comes from monster's
  `LoadReferMonsterFile__11CMonsterManFiP16BASE_MONSTER_TBLP9mgCMemory`).
- gamedata.hpp names CDataWeapon byte 0x39 `fusion_point` and leaves 0x38 as `unk_38`. In this unit
  0x38 is the weapon's starting synthesis points (CopyDataWeapon) and 0x39 is the gain per level (LevelUp).
  0x48 is attack type and 0x49 is model number, as gamedata.hpp has them. 0x40..0x44 hold three
  build-up monster ids (`CheckBuildUpMonsterCondition`) and 0x3A..0x3E hold three build-up weapons
  (`IsBuildUp`).
- Item numbers seen: 0xB9 spectrumised attachment, 0x17F second stack-less attachment, 0x12E / 0x12F
  fishing rods, 0x126 / 0x12A / 0x160 / 0x17D repair items, 0x134 monster badge box, 0x135 aquarium item,
  0xF6 ridepod start, 0x131 / 0x132 scene flags, 0x137 medal holder, 0x1AA boiled fish, 0x38 time-band
  weapon. No enum was made for them because the retail names are unknown.

## Matched function behavior

The following functions have source in `userdata.cpp`; each was compared with its retail object code.
The header gives their addresses, sizes, declarations and purpose comments.

| Function | Behavior and type findings |
| --- | --- |
| `GetCommonGageRate` | Returns the gauge's current fraction, or zero for a null gauge. |
| `CGameDataUsed::GetActiveSetNum`, `IsActiveSet` | The former forwards to the latter; the latter reads `CDataCommon::active_set`, returning zero when the common row is absent. |
| `CGameDataUsed::IsEnableUseRepair` | Compares the candidate item number with this item's repair item number. |
| `CGameDataUsed::IsTrush` | Tests `CDataCommon::attribute` for `ITEM_ATTRIBUTE_TRUSH`; a fish with `BREEDFISH_FLAG_ELECTRIC` is exempt. |
| `CGameDataUsed::GetModelNo` | Reads `CDataWeapon::model_no` only for a weapon with a valid weapon row; otherwise returns -1. |
| `CGameDataUsed::CopyDataGiftBox` | Checks that the item has an item row, sets the gift box family, number and common item type, and empties its three contents. |
| `ROBO_DATA::GetDefenceVol` | Adds the second fitted part's defence to four times the number of shield kits. |
| `MOS_CHANGE_PARAM::CheckClassChange`, `GetDegreeLevel` | Class change requires a class below three and level at least 25 times the next class; degree is level divided by six, capped at 15. |
| `CFishingTournament::Initialize`, `ResetRecord`, `SetRank`, `CalcTopWeight` | Clears the whole tournament or only its ten entries, clamps rank to 0–100, and sums the first three weights after sorting. |
| `CUserDataManager::SetVoiceUnit`, `CheckRoboVoiceFlag` | Stores the signed voice-unit byte and enables voice when fitted; voice is active only when both signed voice bytes are nonzero. |
| `CUserDataManager::NowFishingStyle` | Tests Max's first equipment slot for a fishing rod. |
| `CUserDataManager::SetChrEquip(int,int)` | Validates character and item number, checks existing equipment, finds the item on the board and passes it to the pointer overload. |
| `CUserDataManager::GetNumStackOverBoard` | Counts overflow entries whose `item_no` is greater than one; the code does not inspect their stack count. |
| `CUserDataManager::FishInAquarium` | Finds a free place with `SearchAqua1NotUsed(0)`, moves the supplied fish into the requested tank, then empties the supplied inventory entry. |
| `CBattleCharaInfo::GetNowNPC`, `GetDefenceVol` | Reads the stored townsperson number and defence. |
| `CBattleCharaInfo::GetMagicSwordElem`, `GetMagicSwordCounterNow` | Exposes Monica's current charged element or count; other characters get -1 or zero. |
| `CBattleCharaInfo::GetMagicSwordCounterMax` | Uses the first equipped weapon's second status parameter: below 32 gives zero; each 16 points above 32 adds a charge to the starting three, capped at seven. |
| `CBattleCharaInfo::ClearMagicSwordPow` | Resets the element, charge count and seven charge strengths. |
| `ConvertItemAttrToCharaAttr` | Maps item attribute bits to separate condition-adding and curing `CHARA_STATUS_ATTR` masks. |
| `CheckBadStatus` | Tests for any condition except `CHARA_STATUS_POWER`; it includes the two status bits whose effects remain unknown. |

## Typed access verified against retail

- `CFishAquarium::FishIntoAquarium` stores the transfer day and hour in
  `CGameDataUsed::data.fish.tank_day` and `tank_hour` (offsets 0x50 and 0x54).
- `CUserDataManager::CheckQuickChange` reads `CMonsterBox::monster[i].monster_id`.
- `CUserDataManager::SetChrEquip` addresses `ROBO_DATA::parts[part]` directly.
- `CUserDataManager::SearchActiveItemTableSpace` scans the three
  `CHARA_DATA::active_item` entries first for a stackable match, then for an empty entry.
- `CheckGetItemLimmitOver` uses `CDataCommon::type`, `max_num`, and `stack_num`
  and scans `CUserDataManager::used_data` for board capacity.
- `CheckGetItemRemainNum` subtracts the held item count from `CDataCommon::max_num`.

All six functions retain 100% PAL object matches with the typed member access.

Signed reads of the weapon palette and attack-type bytes, the attachment
spectrum source and the character equipment flag use value conversion to
`s8`. The fish `sex` and `rename_flag` fields are themselves `s8`, so their
reads need no conversion. This preserves retail's signed-byte behavior without
aliasing those fields through signed-byte pointers in `GetPalletColor`,
`GetAttackType`, `TransToPassword`, `GetMsgAddInfo`, and `CheckEquipChange`.

`GetAquariumFish0` addresses the first tank's `fish_tank[slot]` record: the
raw byte offset +4 enters the first `CGameDataUsed`, and +6 reads its item
number. Direct typed indexing changes register allocation in this function,
so the retail-matching source still uses its offset form.

`CBattleCharaInfo::GetNowAccessWHp` reads the selected human weapon's
`CGameDataUsed::data.weapon.whp` gauge. Direct typed access for this branch
retains a 100% PAL match. The ridepod branch addresses the second gauge of
its equipped part, but direct `data.robopart.gage1` access changes codegen.

`CUserDataManager::GetNumSameItem` counts a matching ridepod item once per
`ROBO_DATA::parts` slot. Direct indexing of the bag, character or ridepod
arrays changes register allocation, so its offset-based loops remain.

## Compiler flag cleanup

The local `divbyzerocheck on`/`reset` pair is redundant with the PS2
compiler flag. Removing it leaves every section and symbol in the unit's
object diff unchanged.

## Stable floating-point compiler calibration

SetRandamCircleStatus__FiRf uses binary32 evaluate-first policies for
`0x00000000` (positive zero) and `0x3F800000` (1), scoped to userdata.cpp
and that function. Selecting zero restores the kind-6 healing-parameter
call order; selecting one as well preserves the kind-2 call. Identical
values receive the same policy, using their exact IEEE bits. No source
value, argument order or pointer workaround was introduced. Canonical
wrapper plus section fixup validates the entire unit: 0xBC54 bytes and
1076 relocations pass.


## Native data and matching constraints

All data are native. GetName owns a 0x61-byte item-name buffer with fifteen alignment
bytes; GetMsgAddInfo owns a 0x40-byte spectrum buffer. FishGamePreEquip and the battle
time/time-band caches are file-local. The equipment-type table is signed char[3][5]. A
four-byte selection table contains {1,2,3,4} although the consumer reads only its first
three entries. The weapon attribute table has fourteen declared words (0x38); the final
two zeros are real elements, while the combination loop reads twelve.

CheckWeaponAttribute's const-reference pair preserves retail allocation; a value local
differs by seven words. The debug-item streams use short item/quantity pairs followed by
a single -1 halfword, giving 4n+2-byte objects. A fixed-record representation would
incorrectly add a quantity to the terminator. Consumers read quantity only after a
positive item test; mode 7 begins the extra stream at pair two. init_partytbl is
townspeople 1-25 followed by -1, declared size 0x1A.

CheckParamLimmit's five-pointer zero template owns 0x14 bytes with twelve alignment
bytes. DebugGetItem's four-short equipment template owns eight bytes. Exact extents and
consistent opcode-matched address relocations identify both; source-only data credit
excludes linker-owned terminal zero tails.

## Signed flags and attach parameters

BREEDFISH_USED::sex and CGameDataUsed::rename_flag are signed bytes, with
analyzed consumers using 0/1. GetName indexes the localized name prefix and
suffix table directly by rename_flag; TransToPassword packs sex into one
bit, and CheckHaigouTankSex compares the stored bytes. Extra signed-byte
casts are redundant.

ATTACH_USED has status[2] at +2 followed by attribute[8] at +6.
GetStatusParam reads these as ten ordered parameters, and monster
class-change rewards fill the same ten-halfword run. The arrays stay
separate because gamedata/userdata index them individually; the cross-array
run is explicitly documented on status. Merging their source interface
requires coordinated producer and consumer work.

GetActiveChrNo and GetMonsterID are inline accessors with no retail
out-of-line copy, so their purpose comments carry no mangled/address/size
tags.
