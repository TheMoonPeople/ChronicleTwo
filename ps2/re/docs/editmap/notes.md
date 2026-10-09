# editmap: reverse-engineering notes

The river, mask, and water part-name callbacks are accepted native C++ callers,
with one scoped `CMapPiece` placement row each. No `NONMATCHING` guards or
assembly fallbacks remain in this unit. See
[placement conversion](../satansfiddle/placement-new.md).

Header: `ps2/include/editmap.hpp`. Owns `CEditMap` (93 members across editmap, editmap2,
editriver, editdata, editmapeffect, editinfo), its nested `CEditMap::RemoveInfo`, and the
non-class types `EP_PLACE_INFO`, `EditPlaceLog`, `EditBuildResult` and the capacity enum.

## Header status
- All 93 `CEditMap` members in `manifest.tsv` are declared. A scratch compile of empty
  definitions of every declared member produced exactly the 93 retail symbols (plus
  `__vt__8CEditMap`), so every signature mangles correctly.
- The header depends on `editinfo.hpp` for the by-value 0x18-byte
  `CEditInfoMngr`, and `sceneload.hpp` for the by-value 0x14-byte
  `mgCObjectStack<T>`. The message specialization only zeroes +0x8.
  Both headers now exist. Earlier layout probing used stubs of those sizes
  and checked every offset below with static asserts. `EMAP_MESSAGE` is only
  forward-declared; no code in this game reads it (its definition belongs with sceneload).
- `ps2/src/editmap.cpp` includes `editmap.hpp` and uses the real dependent types.

## Non-member functions and data (all file-local, so none in the header)
`local_symbols.tsv` lists these as LOCAL in retail. The script callbacks,
including the three native part-name callbacks, are still defined with
external linkage; see "Part-name callback binding" below.
The retail-local callback and data set is:
- Script callbacks `emapEDIT_RIVER`, `emapRIVER_PARTS_NAME`, `emapMASK_PARTS_NAME`,
  `emapWATER_PARTS_NAME`, `emapEDIT_RIVER_END`, `emapFIX_EPARTS_START/_/_END`,
  `emapINIT_EPARTS_START/_/_END` (all `(SPI_STACK *, int)`), run by `LoadEditInfo` through the
  `emap_tag` table.
- BSS: `emapMap emapInfo emapStack emapIdx emapNowInfo emapRect emapRectNum emapRectIdx
  emapFixNum emapInitNum emapFixIdx emapInitIdx emapFix emapInit` (4 bytes each): script state.
  `CEditMapName` (rodata): string returned by `Iam`.
- Also emitted in this unit but owned elsewhere: `CEditParts::CEditParts()`,
  `CEditPartsInfo::CEditPartsInfo()` (editparts), `__vt__14CEditCollision` (editcoll).

## CEditMap layout (size 0x10F0)
Size: `operator new(0x10F0)` in `CScene::LoadMapFromMemory` (sceneload), which also inlines the
constructor: `CMap::CMap()`, store `__vt__8CEditMap` at +0xD00, `mgCMemory::Init(+0xD10)`,
memset 0x10 each of 0xD48..0xF48 (houses), `message.Initialize()`, `CEditInfoMngr::Initialize(+0xF94)`,
then the virtual `Initialize` (vtable slot +0x50). No out-of-line ctor/dtor exists in retail.
Base `CMap` is 0xD10 (map.hpp).

| off | field | evidence |
|---|---|---|
| 0xD10 | `mgCMemory parts_heap` | `CreateTable`: `SetHeapMem(+0xD10, Alloc(stack, heap_size))`; `Initialize`: `Init` |
| 0xD40 | `s32 edit_parts_max` | `CreateTable` stores `parts_max`; loop bound in `eNewPlaceParts`, `DrawSub` |
| 0xD44 | `CEditParts *edit_parts` | `CreateTable`: `__construct_new_array(..., CEditParts ctor, 0x330, n)` |
| 0xD48 | `CEditHouse house[32]` | ctor memsets 0x10-byte entries up to 0xF48; `eNewHouseInfo`, `ClearHouse` |
| 0xF48 | `s32 place_log_max` | `CreateTable`: `parts_max * 4` |
| 0xF4C | `EditPlaceLog *place_log` | `CreateTable`: `new[place_log_max * 4]`; `CreatePlaceLog` writes s16 pairs |
| 0xF50 | `s32 grid_max` | `Initialize` sets 4 and clears that many pointers at 0xF54 |
| 0xF54 | `CEditGrid *grid[4]` | editriver functions |
| 0xF64 | `s32 focus_parts` | `Initialize` -1; `DrawSub` flashes that slot |
| 0xF68 | `s32 frame` | `Initialize` 0; `Step` increments; `DrawSub` uses for flash |
| 0xF6C | `mgCObjectStack<CList<EMAP_MESSAGE>> message` | sceneload calls `Initialize` on +0xF6C |
| 0xF80 | `s32 area_no` | `Initialize` -1; `GroundBalance` reads it |
| 0xF84 | `s32 balance_weight[4]` | `BalanceCheck` compares 0xF84/0xF88 and 0xF8C/0xF90 (diff <= 3) |
| 0xF94 | `CEditInfoMngr info_mngr` | `GetePartsInfo*` forward to `CEditInfoMngr` methods on +0xF94; 0xFA8 is one of its fields (read in `InitialPlaceParts`) |
| 0xFAC | `CMapParts *river_parts[8]` | zeroed in `Initialize`; `LoadEditInfo`, editriver |
| 0xFCC | `CEditPartsInfo *river_info` | zeroed; set in `LoadEditInfo` |
| 0xFD0 | `CMapPiece *river_piece[8]` | zeroed; `DrawRiver` |
| 0xFF0 | `CMapPiece *water_piece` | `DrawRiver` |
| 0xFF4 | `CMapPiece *mask_piece[1]` | `DrawRiverMask` |
| 0xFF8 | `float river_poly_margin` | `GetPoly` float arg; `EditMapJump` (editloop) sets 15.0f |
| 0xFFC | `s32 fence_num` | `PaintFence` (both) |
| 0x1000 | `CEditParts **fence_list` | `PaintFence(int,...)` points it at a stack array |
| 0x1004 | `CEditParts *fence_now` | `PaintFence(CEditParts*)` |
| 0x1008 | (alignment padding) | never accessed |
| 0x1010 | `sceVu0FVECTOR fence_color` | `SetColor(0, this+0x1010)` |
| 0x1020 | `s32 paint_num` | decremented per fence painted |
| 0x1024 | `unk_1024[0x2C]` | never accessed in any unit |
| 0x1050 | `s32 balance_moved` | `Initialize` 0; `DrawSub`, `GroundBalance` |
| 0x1054 | `CMapParts *balance_parts[4]` | `GroundBalance` |
| 0x1070 | `sceVu0FVECTOR balance_pos[4]` | `GroundBalance` |
| 0x10B0 | `sceVu0FVECTOR balance_base_pos[4]` | `GroundBalance`; ends at 0x10F0 |

## Vtable
`__vt__8CEditMap` (0x37BC80, 0x54 bytes, emitted in editmap) is the same size as `__vt__4CMap`:
CEditMap adds no virtual functions, it only overrides CMap's (`Iam`, `Initialize`, `DrawSub`,
`PreDraw(float*)`, `DrawEffect`, `DrawFireEffect`, `DrawFireRaster`, `GetPoly`, `GetEvent`,
`InScreenFunc`, `DrawScreenFunc`, `GetSeSrcVolPan`, `AnimeStep`, `Step`). Slot order is CMap's.

## Other types
- `ClearHouse` clears all 32 `CEditHouse` entries individually. `AngleLimit` wraps signed edit
  angles into 24 steps. `CmpEditAlt` compares the altitude difference with +/-0.5, returning
  -1 above, 1 below, and 0 inside; its ordered comparisons also preserve the retail NaN case.
- `PlaceRiverParts` places the river only when `CheckRiverParts` succeeds and reports that result.
- `CEditMap::RemoveInfo` (0x494): `memset(.., 0x494)` in editmode `RemoveEditParts` and editloop
  `BurnEditParts`. +0 force, +4 color_num, +8 color (float[4] array), +0xC paint_num array,
  +0x10 `parts_num[256]` (indexed by definition ID, bound-checked `< 0x100`), +0x410 house_num,
  +0x414 `house_npc[32]`.
- `EP_PLACE_INFO` (0x48): +0 num, +4 `base[16]`, +0x44 `unk_44`. `CheckEditParts` (6-arg)
  clears +0x44 and sets it to 1 when the placement is refused for overlapping a placed part
  whose definition's first word (ID) is 0x46, 0x47 or 0x48. What those IDs are was not
  established, so the field stays `unk_44`.
- `EditPlaceLog` (4): two s16 (part slot, base slot); `parts_no < 0` marks a free entry.
- `EditBuildResult`: -1 / -2 / -3 returns of `BuildEditParts(char*)` (no info / `eNewPlaceParts`
  found no slot / no free house); `eNewPlaceParts` returns -2.
- Angle enum: `AngleLimit` is `% 24` wrapped positive; `GetEditAngle90` rounds down to a
  multiple of 6.

## First-game correspondence
None. The first game's Georama editor (`editground`, `editarea`, `editpartsinfo` in
`/home/adubbz/development/chronicle`) has no `CEditMap`; layouts were derived from this game only.

## Native map and function-point calls

`CEditMap` calls qualified `CMap` base methods for initialization, stepping,
polygon collection, drawing and view setup. Its function-point check is the
eight-byte `CFuncPointCheck` declared in `funcpoint.hpp`; the constructor clears
the time before `CMap::CreateFuncCheck` fills the check. Placed parts then step
or copy the check through `CMapParts` methods. These native calls produce the
retail `PreDraw` and `DrawSub` functions without C-linkage aliases.

`CEditMap::Initialize` clears the four grid pointers through the declared `grid[]` member; replacing the raw offset with `grid[i] = NULL` preserves the retail function. `ClearGrid` also uses `grid[i]` exactly after removing its local `global_optimizer off/reset` pair; with the pragma present, typed indexing scored 89.81%.

A placed part's `CMapParts::name` begins at offset 0x70. Eight edit-map loops
test its first byte to skip unused slots. Reading `part->name[0]`,
`slot->name[0]`, or `edit_parts[i].name[0]` removes those byte-offset casts;
the whole editmap unit remains exact in objdiff.

Both `GetNearParts` overloads read `CEditPartsInfo::box` at offset 0x50.
`GetNearParts(info, ...)` also sets the W components of the box's maximum and
minimum corners before transforming them. Named field access replaces those
byte offsets and preserves both retail functions. The output-array byte
offset in the first overload remains: `out[count - 1]` and
`out[out_offset / sizeof(*out)]` change MWCC scheduling (95.51% and 95.73%).

## Indexed map storage

`ClearAllParts` initializes each `edit_parts[i]` directly; `InitialPlaceParts` reads `info_mngr.init_parts[i]`; `GetePlaceParts(char*)` searches `edit_parts[i]`; and `GetGridPos` checks `grid[i]`. These typed accesses each produce a 100% function match. `ClearAllParts` still uses offset counters for `place_log` and fixed placements: replacing both with typed indexing scored 99.22%; only the log replacement scored 99.69%. `GetSameParts` typed indexing scored 99.09% and was reverted.

## Constructor-backed allocations

`emapRIVER_PARTS_NAME`, `emapMASK_PARTS_NAME`, and `emapWATER_PARTS_NAME`
each allocate a `CMapPiece` through their active typed placement expressions.
The scoped compiler conversion preserves retail's null-result schedule.

## October 8 merged-base allocation audit

Before scoped placement conversion, the October 8 MWCC 3.0-011126/profile
baseline differed in exactly two words per callback: water 2/72, mask 2/96,
river 2/104. Retail branched on `v0` before copying to the saved pointer in
the delay slot; that candidate copied first and tested the saved pointer.
Water and mask otherwise omitted only zero alignment tails. The allocation
stop rule kept those baseline forms guarded. All three callers are now native;
[the earlier investigation](../funcpoint/placement-new.md) preserves the
constructor and null-result evidence.

## Part-name callback binding

Retail gives `emapRIVER_PARTS_NAME`, `emapMASK_PARTS_NAME`, and
`emapWATER_PARTS_NAME` LOCAL function binding. With `emap_tag` defined in this
unit's C++ source, declaring them `static` gives LOCAL FUNC symbols with no
extra alias and an unchanged object check. They keep external linkage, like
the unit's other script callbacks, until the callbacks' retail binding is
restored together.
