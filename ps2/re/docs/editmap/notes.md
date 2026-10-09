# editmap: reverse-engineering notes

## Source status

Every function is native C++ with no `NONMATCHING` guards or `INCLUDE_ASM`
fallbacks. The complete object is 0x53EC bytes with 541 relocations. The
three part-name script callbacks (retail LOCAL/FUNC symbols) each depend on a
placement-new row (`__nw__FUiP1` / `__ct__9CMapPieceFv`,
`after_constructor_inline`, `expected_matches: 1`) for their single
`CMapPiece` construction; retail branches on `v0` before copying the result
to the saved pointer in the delay slot, which MWCC otherwise reverses (two
words per callback). See [placement conversion](../satansfiddle/placement-new.md).

| Caller | Address | Symbol size | Extent |
| --- | ---: | ---: | ---: |
| `emapRIVER_PARTS_NAME__FP9SPI_STACKi` | 0x1B5800 | 0x1A0 | 0x1A0 |
| `emapMASK_PARTS_NAME__FP9SPI_STACKi` | 0x1B59A0 | 0x174 | 0x180 |
| `emapWATER_PARTS_NAME__FP9SPI_STACKi` | 0x1B5B20 | 0x11C | 0x120 |

Two data markers remain, both consumed through the `EditVector` union
wrapper: `INCLUDE_RODATA` `at_1837__2` (the wall-up vector copied by
`CheckWallEditParts`; an ordinary or aligned VU-vector initialiser at the
copy point changes 0x20 text bytes from function+0xAC) and `INCLUDE_BSS`
`at_426` (0x10, the zero rotation reset in each `ClearAllParts` placement
iteration; ordinary and aligned vector initialisers both change the linked
image). All other data is typed: part identifiers, the placement diagnostic
and `"CEditMap"` (`CEditMapName`, a file-private pointer) are inline; the
river-position and part-bound margin vectors are float aggregates; the
fourteen script-state words/pointers keep retail order; the fixed and initial
placement tables are `ePlaceData *`; the twelve-entry writable
`SPI_TAG_PARAM emap_tag` table holds eleven tag literals/callbacks and a null
terminator; both `__vt__8CEditMap` and `__vt__14CEditCollision` are emitted
natively.

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
  Every offset below is checked with static asserts. `EMAP_MESSAGE` is only
  forward-declared; no code in this game reads it (its definition belongs with sceneload).
- `ps2/src/editmap.cpp` includes `editmap.hpp` and uses the real dependent types.

## Non-member functions and data (all file-local, so none in the header)
`local_symbols.tsv` lists these as LOCAL in retail. The script callbacks are
defined with external linkage; declaring the three part-name callbacks
`static` gives LOCAL FUNC symbols with no extra alias and an unchanged object
check, so the whole callback set can be made static together.
The retail-local callback and data set is:
- Script callbacks `emapEDIT_RIVER`, `emapRIVER_PARTS_NAME`, `emapMASK_PARTS_NAME`,
  `emapWATER_PARTS_NAME`, `emapEDIT_RIVER_END`, `emapFIX_EPARTS_START/_/_END`,
  `emapINIT_EPARTS_START/_/_END` (all `(SPI_STACK *, int)`), run by `LoadEditInfo` through the
  `emap_tag` table.
- BSS: `emapMap emapInfo emapStack emapIdx emapNowInfo emapRect emapRectNum emapRectIdx
  emapFixNum emapInitNum emapFixIdx emapInitIdx emapFix emapInit` (4 bytes each): script state
  (`emapInfo` is the `CEditInfoMngr *` of the map being loaded). Five of these words are only
  reset by retail.
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
None. The first game's Georama editor (`editground`, `editarea`, `editpartsinfo`) has no
`CEditMap`; layouts were derived from this game only.

## Native map and function-point calls

`CEditMap` calls qualified `CMap` base methods for initialization, stepping,
polygon collection, drawing and view setup. Its function-point check is the
eight-byte `CFuncPointCheck` declared in `funcpoint.hpp`; the constructor clears
the time before `CMap::CreateFuncCheck` fills the check. Placed parts then step
or copy the check through `CMapParts` methods. These native calls produce the
retail `PreDraw` and `DrawSub` functions without C-linkage aliases.

`CEditMap::Initialize` clears the four grid pointers through the declared `grid[]` member; replacing the raw offset with `grid[i] = NULL` preserves the retail function. `ClearGrid` uses `grid[i]` without a `global_optimizer off/reset` pair; with the pragma present, typed indexing does not match (89.81%).

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

`ClearAllParts` initializes each `edit_parts[i]` directly; `InitialPlaceParts` reads
`info_mngr.init_parts[i]`; `GetePlaceParts(char*)` and `GetSameParts` index `edit_parts[i]` at
each use in a `for` loop; `GetGridPos` checks `grid[i]`. `ConvertParts` uses the pointer
difference `part - edit_parts`. `RemoveEditParts` reads `CEditHouse *house` and
`house->npc_no[0]`, and walks `remove_info->color[j]`. `PlaceEditParts` reads `place->base[0]`.
Both `GetNearParts` overloads write `out[count++] = part` (writing `out[count - 1]` after the
increment adds four words). `CEditParts *part` calls the inherited `CMapParts::GetPoly` and
`GetColor` without an upcast. `CEditParts::allocation_address` is `u_long128 *` (editparts.hpp).

Functions under `#pragma global_optimizer off` keep explicit byte offsets, which retail computes
once and advances instead of rescaling the index at each use: `ClearAllParts`
(`place_log + log_offset`, `fix_parts + initial_offset`; typed indexing of both scores 99.22%,
of the log alone 99.69%) and `GetePlaceIDList` (`(s8 *) edit_parts + offset`, `part[0x70]`,
`out + out_offset`).

`BurnEditParts` initialises its removal sentinel at its original declaration, before its other
locals; moving the declaration to the copy point changes 0x14 text bytes.

The part-name callbacks use `MG_ZBUF_NO_WRITE` for Z-buffer write suppression and
`EDIT_MAP_MASK_PIECE_MAX` for the mask bound.
