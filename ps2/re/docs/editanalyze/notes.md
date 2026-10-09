# editanalyze notes

## Ownership
No class or struct is owned by this unit (`class_units.tsv` has no row for it). The header holds
only free-function prototypes and the `EditAnalyzeMap` enum. No first-game counterpart unit.

## Linkage
Local in retail (`local_symbols.tsv`), so `static` in the `.cpp`, not in the header:
`CheckSaku(CEditMap*, int)`, `GetTreeNum(CEditMap*)`, `CheckInfoID(CEditMap*, int, int)`,
`AnalyzeSharlot/Stera/Benietio/Heim/MoonFlower(CEditData*, CEditMap*)`,
`GetColorType(CEditParts*, int)`.
Global (in header): `AnalyzeEditMap`, `CountPartsType`, `CountPartsInfoID`, `GetHouseParts`,
`GetPartsPos`, `CheckLiveChara`, `EditMapInitEvent`.

External callers: `AnalyzeEditMap` <- `EditDataSave`, `EditDataLoad` (editloop, passes `MapNo`);
`EditMapInitEvent` <- `SubMapLoadStep`, `EditMapJump`, `EditExitInterior`;
`CheckLiveChara` <- `CRemovalMenu::KeyStep` (args: `MenuMainScene+0x2e60` map no,
`MenuMainMapInfo`, `this+0x418` house slot, a villager value from `this+0x144[this+0x14f8]`).

## Functions
- `AnalyzeEditMap(map_no, map)`: null-checks map, `GetSaveData()->GetEditData(map_no)`, dispatches
  0..4 to Sharlot/Stera/Benietio/Heim/MoonFlower. Enum `EditAnalyzeMap` comes from this; each
  `AnalyzeX` calls `CEditData::Analize(<same index>, cond[64], ...)` (Stera passes 1), so the
  index matches `EDIT_ANALYZE_MAP_MAX` (editdata.hpp) numbering.
- `AnalyzeX`: two 64-int stack arrays (first zeroed = condition results, second filled with -1),
  filled from `CEditMap::BalanceCheck`, `CheckLiveNPC`, `GetePlacePartsAtInfoID`, culture points
  (`CEditData+4` = `culture_point`) thresholds, save bit flags; then `CEditData::Analize`.
- `CountPartsType/CountPartsInfoID(value, map, list, num)`: count slots in `list[num]` whose
  `GetePlaceParts(slot)` is non-null and `GetPartsType()`/`GetInfoID()` == value. Return int.
- `GetHouseParts(map, list, max)`: loops over the four house info IDs in a local
  `int ids[4] = {1, 9, 0x16, 0x1F}` (MWCC emits a 16-byte .data template and copies it) calling
  `GetePlacePartsAtInfoID(id, list, max)`, advancing list and reducing max; returns total.
- `GetPartsPos(map, no, pos)`: returns `CEditParts*` (NULL if map or slot empty) after calling the
  part's virtual at vtable offset 0x18 with `pos` (position getter; slot not yet named in
  editparts/mapparts headers -- verify).
- `GetColorType(parts, which)`: `CMapParts::GetColor(which, col)`, compares against
  `CEditPartsInfo::GetDefColor` of the info pointer at `CEditParts+0x324`; if it differs, scales by
  128 and finds the nearest of 8 `GetPenkiColor(i)` colours within distance 2.0. Returns 0..7 or -1.
- `CheckLiveChara(map_no, map, no, chara)`: switch on `chara` 0..0x19 (26-entry jump table,
  .rodata 0x68). Uses `GetTerritoryParts(no, buf[0x200], 0x200)` then
  CountPartsType(2/6/7/8)/CountPartsInfoID(7/0x11/0x12), `GetRiverNum(no, 300.0f)`, position y
  (>= 134 for map 2, else >= 84), `CultureAnalyzeParts(no, 0) > 0x13`, `GetInfoID` == 1/0x4b/0x16,
  `GetColorType` == 5/6, and `info+0x1c == 1`. Returns 0/1 as int (m2c: s32). The part's info
  pointer at +0x324 null -> 0. Meaning of `chara` values not established beyond being villager
  kinds from the removal menu; no enum made.
- `EditMapInitEvent(map_no, map)`: only for map_no == 14: `CFuncPointMngr::Search` at
  `CEditMap+0xcb0` for `"dun07"`, sets found point `+0x10` = `GetBitFlag(800)`;
  `CMap::GetPlaceParts("p02_e05a02-0")` then virtual at vtable 0x54 with
  `flag == 0` (likely a show/hide). Map 14 is not named; no map-number enum exists yet.

## Data and source status
Every function is native; the unit has no `NONMATCHING` guards, `INCLUDE_ASM` gaps, or data
markers. All data is compiler-generated from the source (no externs): the `GetHouseParts` id
template, the `CheckLiveChara` jump table, the two `EditMapInitEvent` strings, and two vector
templates:
- `AnalyzeSharlot` initializes a `sceVu0FVECTOR` with `{0, 0, 0, -1}` at the river-query point
  (.data template). The working arrays that follow it (river, tree positions, the three
  difference/closest vectors) are declared there in that order so they keep their stack
  positions; declaring the vector late changes stack offsets, and initializing it at an earlier
  declaration moves the copy ahead of the condition/target clearing loop.
- `AnalyzeMoonFlower` has a zero center vector whose 16-byte zero template is in .bss.

## Unresolved
- Names of the five towns behind the retail function names (enum uses the retail spellings).
- `chara` value meanings in CheckLiveChara; CEditParts vtable slots 0x18 and 0x54.
