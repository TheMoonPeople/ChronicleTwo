# editparts: reverse-engineering notes

## C++ draft status
All 28 functions have C++ in `ps2/src/editparts.cpp`. 21 are exact and compiled
by the matching build. 2 more compile to retail's bytes in isolation but stay
under `NONMATCHING`. 5 differ from retail and keep the `INCLUDE_ASM` fallback.
Each function tried has its one promotion attempt recorded in
`scripts/re/promotion_attempts.tsv`.

Header: `ps2/include/editparts.hpp` (included by `ps2/src/editparts.cpp`). Classes owned: `CEditPartsInfo`,
`CEditHouse`, `CEditParts` (+ nested `CEditParts::WallInfo`). Extra types: `EditPartsMaterial`,
enums `EditPartsAtr`, `EditPartsType`, `EditPartsState`. No first-game counterpart: the first game's
editor (`editpartsinfo.hpp`, `editpartsdata.hpp`) is a different, grid-based design.

Build state: `mapparts.hpp` (base of `CEditParts`) includes `funcpoint.hpp`, which does not exist yet, so
`draft.sh --header ps2/include/editparts.hpp` and `draft.sh editparts` currently fail inside mapparts.hpp.
With a stub `funcpoint.hpp` (`CFuncPointMngr` 0x40 bytes, `CFuncPointCheck` 8 bytes) the header compiles and
every size/offset assert below holds (checked with offsetof asserts).

## CEditPartsInfo (size 0x280, no vtable)
- `GetPartsType` checks the 0x40 attribute first (returning type 1), then the river attribute
  (returning type 11), and otherwise returns the stored `parts_type`.
- Size: `CEditMap::LoadEditInfo` and `emapEDIT_PARTS_NUM` use `__construct_new_array(..., __ct__14CEditPartsInfoFv,
  0, 0x280, n)` (no destructor). Ctor `__ct__14CEditPartsInfoFv` (0x1B6790, emitted in editmap) constructs five
  `CEditCollision` inline then calls `Initialize()` directly (non-virtual).
- Field evidence (setters are the `emap*` script commands in editinfo, LoadEditInfo in editmap):
  - 0x00 `id` (`emapID`; Initialize -999; `GetInfoID`; RemoveInfo indexes < 0x100)
  - 0x04 `attr` (`emapPARTS_ATR` ORs; `GROUND_PARTS` |7, `BLOCK_PARTS` |0x30, `FENCE_PARTS` |0x130,
    `RIVER_PARTS` |0x80). Other bits seen: 0x1 (RemoveEditParts refuses removal in one mode), 0x2 (LoadData
    skips BuildEditParts), 0x40 (GetPartsType -> 1), 0x100 (LoadEditInfo flattens area3_box to a line, place_anime 0),
    0x200 (place_anime 0), 0x1000 (IsBurn), 0x10000 (bury_depth computed), 0x80000 (RemoveEditParts re-checks
    river placement), mask 0xAC2 (CheckTerritory ignores the other part). IsFence = `(attr & 0x130) == 0x130`.
  - 0x08/0x0C `cpoint[2]` (`emapCPOINT`; editdata `CultureAnalyzeParts` reads [0], `GetCulturePoint` reads [1])
  - 0x10 `weight` (`emapWEIGHT`; `GroundBalance` sums it per ground part)
  - 0x14 `max_num` (`emapMAX_NUM`), 0x18 `geo_stone` (`emapGEO_STONE`, init -1), 0x1C `paint_num`
    (`emapPAINT_NUM`; RemoveEditParts loops `GetColor` over it), 0x20 `paint_used`, 0x24 `parts_type`
    (`emapPARTS_TYPE`), 0x28 `place_eps` (float; editmap2 CheckEditParts compares a ratio against it, 0.98 if <= 1e-5),
    0x2C `map_no` (init -1), 0x30..0x38 `polyn[3]` (`emapPOLYN`, 1-3 args; meaning unknown)
  - 0x3C `edit_name` (`emapEDIT_PARTS` string, font-converted; `PlaceEditParts(char*)` by name), 0x40 `parts_name`
    (`emapPARTS_NAME`; `CMap::GetParts(name)`), 0x44 `parts` (CMapParts*, result of GetParts; GetDefColor), 0x48
    `comment` (`emapPARTS_COMMENT`). 0x4C unknown.
  - 0x50 `box` mgVu0FBOX (max 0x50, min 0x60; GetPartsHeight = max.y - min.y; set in LoadEditInfo via operator=)
  - 0x70 `material[4]` {item_no, num} (GetMaterial stride 8, range 0..3; `emapPARTS_MATERIAL`; editmenu
    `GetItemMessage(item_no)`, `DeleteItem(item_no, num * n)`)
  - 0x90 `place_anime` (LoadEditInfo sets 2, 1 when height^2/area > 2, 0 for attr 0x100/0x200;
    `EditStartPlaceEffect` passes it to `EditSetPlaceAnime(int, CMapParts*)`, which treats 0 as none, 3 special)
  - 0x94..0x9C unknown
  - 0xA0 `area3_box` mgVu0FBOX = col_area3.bbox; for attr 0x100 the box is collapsed onto the long axis
    (GetFenceSide transforms its max/min, W=1, as the two fence ends).
  - 0xC0, 0x110, 0x160, 0x1B0, 0x200: `CEditCollision` (0x50 each, vtable at +0x30). LoadEditInfo fills them with
    `CEditCollision::Copy(temp, dest, area_kind)`: 0xC0 kind 1 (AreaXZ used for place_anime ratio), 0x110 kind 2 then
    `DeleteVerticalPoly` (floors), 0x160 kind 2 then `PickupVerticalPoly` (walls; result -> 0x254), 0x1B0 kind 3, 0x200
    kind 5. Initialize re-initialises only the first four (virtual slot 0x20 = Initialize). Area-kind meanings not
    established, hence names `col_area1/3/5`.
  - 0x250 `bury_depth` float (|bound min y| when < -2 and attr 0x10000; CheckEditParts passes it to `CmpEditAlt`)
  - 0x254 `wall_group_num` (PickupVerticalPoly result; GetWallGroupNum)
  - 0x258, 0x25C unknown
  - 0x260 `territory_center` (centre of bound box, W=1), 0x270 `territory_radius` (max |dx|,|dz| of half-extent),
    0x274 `territory_height` (|dy|/2); CheckTerritory compares XZ distance with summed radii and |dy| with summed
    heights. 0x278 is a float copy of 0x270 (no reader found) -> `unk_278`. 0x27C unknown.
- `CreateBox` copies an uninitialised 0x20-byte local box into 0x50/0x60 and sets both W = 1.0 (the asm really
  does `lq` from an unwritten stack slot; likely an inlined empty-box helper).

## CEditHouse (size 0x10)
- `CEditParts::GetLiveNPC` returns the first `npc_no` of its house or -1 without one.
- `CEditMap` holds an array at 0xD48 with stride 0x10 (LoadData: `this + (n-1)*0x10 + 0xd48`; `memset(house, 0, 0x10)`).
- 0x0 `active` (set 1 on assignment), 0x4..0xC `npc_no[3]` (LiveChara: any > 0; GetLiveNPC returns [0];
  RemoveEditParts records [0]).

## CEditParts : CMapParts (size 0x330)
- Size: `CEditMap::CreateTable` `__construct_new_array(..., __ct__10CEditPartsFv, 0, 0x330, n)`; loops step 0x330.
- Ctor `__ct__10CEditPartsFv` (0x1B1EB0, emitted in editmap): inline CMapParts ctor, then `Initialize()` through
  the vtable (slot 0x3C).
- Vtable `__vt__10CEditParts` (0x37BCE0): same as CMapParts' except SetPosition(float*) 0x10, SetPosition(fff) 0x14,
  GetPosition 0x18, Initialize 0x3C, UpDatePosition 0x7C, Copy(CMapParts&, mgCMemory*) 0x80 are overridden.
  Emitted in editparts (first non-inline virtual defined here).
- Fields: 0x310 `state` (EditPartsState; PlaceEditParts 1, river 2, RemoveEditParts 0; DrawSub draws ==1;
  LoadData maps saved 1 -> 0 then re-promotes stacked parts to 1). 0x314 `ground` CMapParts* (ClearAllParts/
  `CMap::GetPlaceParts(name)`; GroundBalance compares with CEditMap 0x1054..0x1060; virtual GetPosition slot 0x18
  called on it). 0x318 `max_material_num` (CheckColorUpdate: max over pieces of CMapPiece::material_num, node+0x9C =
  CList data at +0x10, piece +0x8C). 0x31C, 0x320, 0x32C never accessed. 0x324 `info` CEditPartsInfo*. 0x328 `house`.
- Positions: SetPosition(float*) subtracts `StandardPos(ground.y)` from Y before mgCObject::SetPosition;
  GetPosition adds it back; UpDatePosition (runs when mgCObject 0x40 changed flag set or ground != NULL) adds the
  raw ground Y and sets frame position/rotation(0x20)/scale(0x30) through frame vtable slots 0x10/0x1C/0x28.
  SetPosition(fff) builds {x,y,z,1} (`at_418` = {0,0,0,1}) and calls the virtual SetPosition(float*).
- `WallInfo` (0x40, global `WallInfo` in editmode is 0x40): 0x00 plane (normalised normal, W = -dot(n, v0)),
  0x10 center (average of the wall's vertices; W 1.0), 0x20 box (max = {xz dist to max corner, max.y - center.y, 0, 1},
  min = {-xz dist to min corner, min.y - center.y, 0, 1}); StartEditPutWall copies it with mgVu0FBOX::operator=.
  Wall polys are those of col_wall whose CCPoly 0x46 equals the wall number.
- GetFenceSide requires CMapParts field 0x230 non-zero and info != NULL.

## Free functions
- `StandardPos(float)`: `(float)(int)(x > 0 ? x + 0.001 : x - 0.001)`; global (not in local_symbols.tsv).
- `EditPartsCmpColor(float*, float*)`: `mgDistVector(a, b) < 0.02`; global.

## Data
- `at_418` (0x33AC30, {0,0,0,1.0f}) is a compiler literal; `__vt__10CEditParts`. No named globals.
