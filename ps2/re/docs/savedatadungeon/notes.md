# savedatadungeon notes

`GetFloorInfoPtr` adds the limits of the preceding dungeons to the requested floor number, then returns the corresponding `floor_info` entry. Native array indexing produces the exact PAL address calculation without a byte-offset cast.

No counterpart in the first game's headers. No vtable (no `__vt__16CSaveDataDungeon`).

## CSaveDataDungeon (0xCE4, embedded in CSaveData at +0x1C5B4)
- Located via `CSaveData::Initialize` (calls `Initialize` on this+0x1C5B4), `menu_GetSaveDataDungeon`,
  `InitDungeonMain` (`DngSaveDataDungeon`), `MenuMainInit` (`MenuSaveDataDungeonPtr`).
- 0x00 `stage_id` s32: `_DNG_SET/GET_STAGE_ID` read/write `*this`; SaveMapInfo/ResetMapInfo
  (menuop) too. Initialize sets 0.
- 0x04 `floor_id[7]` s32: `this[stage_id + 1]` (`_DNG_GET_FLOOR_ID`, IsSealFloor, GetActiveFloorInfo).
  Initialize sets each to 1.
- 0x20 `prev_floor_id[7]` s32: `this[stage_id + 8]` (`_DNG_SET/GET_PREV_FLOOR`). Initialize sets -1.
- 0x3C `floor_info[162]` DNG_FLOOR_SAVE: Initialize `memset(this+0x3C, 0, 0xCA8)`; 0xCA8 = 162*0x14.
  162 = sum of `limmit_table`.
- Size: 0x3C + 0xCA8 = 0xCE4. The next CSaveData member (CUserDataManager) is at +0x1D2A0, leaving
  8 bytes (0x1D298..0x1D2A0) that no code touches; taken as CSaveData padding (16-byte alignment of
  the following member), not part of this class. Unverified; revisit if CSaveData's layout shows
  otherwise.

## Functions
- All three functions are native C++ and the complete object matches retail.
- `GetFloorInfoPtr(stage, floor)`: null if stage outside 0..6 or floor outside 0..limmit_table[stage]-1;
  otherwise `&floor_info[sum(limmit_table[0..stage-1]) + floor]`. The unrolled-by-8 loop in the asm
  is MWCC's unrolling of a simple summing loop.
- `Initialize()`: memset floors; for each stage: floor 0 -> visit_count=1, flag=3; floor 1 -> flag=1;
  then prev_floor_id[] = -1, floor_id[] = 1, stage_id = 0. Note order in asm: prev (0x20..0x38) first,
  then floor_id, then stage_id.
- `SetFloorID(floor)`: `prev_floor_id[stage_id] = floor_id[stage_id]; floor_id[stage_id] = floor;
  printf("[%d] FLOOR :::    %d ----->> %d \n", stage_id, prev_floor_id[stage_id], floor)` as a tail call (`j printf`). Return type
  void (no caller uses a result).

## Globals
- `limmit_table` (0x361670, .data, 0xE bytes) is LOCAL in retail -> `static s16 limmit_table[7] =
  {9, 16, 25, 21, 23, 29, 39};` in the .cpp, not in the header. Floors per dungeon.
- The floor-transition diagnostic is an inline string literal.

## DNG_FLOOR_SAVE (0x14) -- name is ours
Retail name unknown. `DNG_FLOOR_SAVE` was already forward-declared by dng_main.hpp for
`NowFloorInfoPtr`; the same name is used here so it resolves. Field access comes from
`_SET_FLOOR_INFO`/`_GET_FLOOR_INFO` (event_func; script "info" indices 0..7 map to the fields in
order) and the callers listed below.
- 0x00 s32 unk_0: script index 0 only (set from float via fptosi).
- 0x04 s32 fast_destroy_time: IsClearMostFastDestroy stores `(now-start)*6/5` (frames->1/60 s) when
  under the map's target (`GetDngMapFloorInfo`+0x10); CMenuTreeMap::Step shows it as /60 -> min:sec.
- 0x08 u16 unk_8 (index 2), 0x0A u8 unk_a (index 3, byte load), 0x0B unk_b (never accessed).
- 0x0C u16 spheda_clear: script index 4; GetCountSphedaClear counts floors where it is non-zero.
- 0x0E u16 flag: script index 5 ORs bits in. Bits (DNG_FLOOR_FLAG):
  - 0x1 OPEN: Initialize floors 0/1; CheckDrawGlidInfo draws routes between rooms with bit 1.
  - 0x2 unknown: set on floor 0 by Initialize; CheckDrawGlidInfo marks a room (+0x66) when 1 set and 2 clear.
  - 0x8 PRACTICE_CLEAR: IsClearPractice.
  - 0x10 FAST_DESTROY_CLEAR: IsClearMostFastDestroy (also AddYarikomiMedal).
  - 0x20 FISHING_CLEAR: CheckFishingRecord.
  - 0x80 SPHEDA_CLEAR: DrawDngRoomInfo/CMenuTreeMap::Step show it beside the spheda check
    (`CheckBitFlagMenu(0x13D)` = DngInfoSphidaOkFlag). Inferred from context.
  - 0x100 GEOSTONE_FOUND, 0x200 GEOSTONE_READ: MakeDownLoadAnaunce (editmenu) lists parts for floors
    with 0x100 and sets 0x200 once announced; AutoSetTreasureBox skips the geostone when 0x100 set;
    debug (MenuGeoDebugKey, gcALL_GEO_PARTS) sets 0x300.
  - 0x400 SEAL_CLEAR: IsSealFloor returns 0 when set.
  - Debug in CMenuTreeMap::Step writes 0x1FB. Bits 0x4 and 0x40 never seen individually.
- 0x10 u16 kill_count: CMonsterMan::ThinkHost increments `NowFloorInfoPtr->kill_count` on a kill
  (next to KillMonsterCount); shown by CMenuTreeMap::Step.
- 0x12 u16 visit_count: Initialize sets 1 on floor 0; debug increments it capped at 30000;
  UpdateTrBoxFlag deletes treasure boxes of floors where it is 0; CheckDrawGlidInfo uses non-zero.

## Unresolved
- Meaning of unk_0, unk_8, unk_a, flag bit 0x2.
- Whether the trailing 8 bytes before CUserDataManager belong to this class.
