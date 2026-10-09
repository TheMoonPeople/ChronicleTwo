# charasetup: reverse-engineering notes

Unit owns no class in `build/re/class_units.tsv`. It sets up the main characters (Max, Monica,
ridepod, Monica-as-monster) in a `CScene`: memory stacks, model/weapon/skin loading, linking parts
with `CActionChara::SetRef`, action script.

## chara_type
Every `int chara_type` parameter takes `ACTION_CHARA_TYPE` values (`actionchara.hpp`):
0 Max, 1 Monica, 2 ridepod, 3 monster. Seen in `SetupUnitMan` (dispatch 3->SetupMonster,
2->SetupRobo, 1->SetupMonica, 0->SetupMints) and `GetCharaMemAllocPtr`. Kept as `int` because the
mangled names use `i`.

## Functions
- Global (in header): GetCharacterSnd, SetupMainUnit, GetCharaMemAllocSize, GetCharaMemAllocPtr,
  SetupUnitMan, GetRoboPartsInfo.
- Local in retail (`local_symbols.tsv`), so `static` in the .cpp, not in the header:
  SetupMints, SetupMonica, SetupRobo (all `(CScene*, CUserDataManager*[, ROBO_INFO_DATA*])`),
  SetupMonster.
- `SetupMainUnit`'s first parameter mangles as `P1P`, which is `u_long128 *` (same as
  `LoadFileBG__FPcP1Pi` in dataread.hpp).
- `SetupMainUnit` first requires six scene character slots and initializes each with a null
  memory pointer. Max and Monica share the same base model and skin load sequence, but equip
  different weapon joints and action scripts. The ridepod loads its six component models from
  `ROBO_INFO_DATA`; the monster loads its model, info file, and script from its monster id.
  Each branch calls `SetupUnitMan` after loading, then the function prints the seven stack
  usage counters. The character virtual calls at vtable offsets `0x118`, `0x7C`, and `0x14`
  resolve to `Initialize(mgCMemory*)`, `LoadPack`, and `SetPosition(float,float,float)`.
  The ridepod component memory indices come from `at_919__3`: `{0,1,2,2,3}` for slots 0–4;
  its hat uses stack 2. Its action script uses stack 4, and the monster script uses stack 5.
- `GetCharacterSnd`: `GetCharaDataPtr(chara_no)`; Max (0): weapon id at chara+0x1DE, 0x16..0x28 ->
  `CH_0%d` (id-0x16), else `CH_000`; Monica (1): `CH_020`; ridepod (2):
  `CGameDataUsed::GetRoboSoundFileName` on user_data+0x4690. Declared void: no caller
  (dng_main, event_func, menuchr) uses a return value; v0 merely holds sprintf's result.

## ROBO_INFO_DATA (0x24)
Filled by `GetRoboPartsInfo` into `robo_dat`:
- 0x00/0x04/0x08/0x10 model_name[0,1,2,4] = `r_robo_pname_1282` rows (16 bytes each, item file
  names via `GetItemFileName(id,0)`); parts read from user_data+0x4660+slot*0x6C+0x32 for slots
  {3,0,1,2} (`at_1281__2`, a 16-byte int[4] copied to the stack).
- 0x0C model_name[3] = `fname_1290`, sprintf of `fname_tbl_1291`/`fname_tbl2_1298` (`mints0%da.chr`,
  `mints%da.chr`, ... indexed by Max's costume (chara+0x322 minus `GetDataTypeStartListNo(5)`),
  number = body type (+10 when save bit 799 set)). Full file name with `.chr`.
- 0x14 hat_file = `GetItemFilePath(chara(0)+0x24A, 0)`.
- 0x18 arm_name = `&robo_info_body[body_type-1].arm_name` (address 0x351E2D = base+0xD), else NULL.
- 0x1C move_type = `GetRoboInfoType` on user_data+0x47D4 (legs) if legs present.
- 0x20 attack_type = `GetRoboInfoType` on user_data+0x4690 (arm) if arm present.
`robo_dat` has declared size 0x24; its piece extends to 0x30 because the next BSS symbol is 16-byte aligned.
Used by menuchr (`MenuItemRoboDataLoad`: reads [3] and +0x14).
`SetupRobo` reads the arm/leg joint names itself; the five SetRef names are `at_1216__4`
(leg, arm, body, mints, bpack) -> `ROBO_MODEL_SLOT`.

## ROBO_INFO_BODY (0x25), robo_info_body[11] (0x197 = 11*0x25)
Each row: `char[13]` body file then `char[24]` arm name. Retail contains one
`body01.chr`/`arm1` row followed by ten identical `body02.chr`/`arm2` rows. Indexed by body type - 1 (body item info +0x22).

## mem_table (local, 0x351D50, 0x70) -> `static int mem_table[4][7]`
Stack sizes per character row. `GetCharaMemAllocSize` returns max row sum + 0x10.
`GetCharaMemAllocPtr` uses row/count: monster row 0 x6, ridepod row 1 x5, Max/Monica row 0 x7
(row 2 when edit_mode). A negative entry ends early. Stacks are `mgCMemory` at stride 0x30;
`memory+0x1C`/`+0x24` are reset (mgCMemory fields).

## Other data
- `r_robo_pname_1282` (bss 0x40) = `char[4][16]`; `fname_1290` (bss 0x40) = `char[64]`;
  function-local statics of GetRoboPartsInfo.
- `fname_tbl_1291`, `fname_tbl2_1298`: local `char *[6]`; the two following zero words are piece padding.

## First game
No direct counterpart header checked in chronicle for this unit.

## Draft and promotion status
All ten game functions have typed C++ drafts. `GetCharaMemAllocSize` compiled and promoted with a
byte-identical linked image. The nine other functions compiled but differed in their isolated
promotion attempts, so their `INCLUDE_ASM` implementations remain selected by default. In
particular, `SetupRobo` caused a local read-only datum binding mismatch at `0x0036D870` during
its attempted promotion. A full default build after these attempts verified every section of
`SCES_511.90` against retail.

`GetCharaMemAllocPtr` walks `mgCMemory` slots with a 0x30-byte stride.
Replacing its byte-offset address with `&stacks[index]` changes MWCC's address
calculation (99.39%), so the original expression remains for exact matching.
