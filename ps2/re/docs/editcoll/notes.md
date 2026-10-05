# editcoll: reverse-engineering notes

## Draft status
All ten functions have named, typed C++ drafts that compile with MWCC. Each had
one isolated promotion attempt; every candidate differed from retail and remains
behind `NONMATCHING`, with `INCLUDE_ASM` selected by the matching build. Of the
six later drafts, `Copy` retained the retail section layout but differed by 0x114
bytes in `.text`. The other five changed the linked layout, so their whole-image
checks reported widespread differences; the per-function draft comparison also
reports differences for each of them.

Header: `ps2/include/editcoll.hpp`. No first-game counterpart (`CEditCollision` does not exist in
`/home/adubbz/development/chronicle`); the base classes `CCollision`/`CCollisionMDT`/`CCPoly` are in
`ps2/include/collision.hpp`.

## CEditCollision : CCollisionMDT (size 0x50, no fields of its own)
- Base: every member function reads `this+0x40` as the `CCPoly *` array (stride 0x50) and
  `this+0x44` as its count, exactly `CCollisionMDT::poly` / `poly_count`. `this+0x10`/`+0x20` are
  used as the bounds max/min (`CCollision::bbox`) in both `OverlapPoly3XZ` overloads. Vtable pointer
  at 0x30; `(*(this+0x30))[+8]` = first slot = `CreateBBox`.
- Size 0x50: `CEditPartsInfo::CEditPartsInfo` (editmap) constructs five of them inline at
  0xC0, 0x110, 0x160, 0x1B0, 0x200 (stride 0x50), each via the inlined CCollision ->
  CCollisionMDT -> CEditCollision constructor chain (no extra field stores after the
  CCollisionMDT ones). The constructor is implicit/inline.
- Vtable `__vt__14CEditCollision` (0x37BC50, size 0x28, emitted in `editmap.data.s` because the
  class defines no non-inline virtual): identical to CCollisionMDT's:
  CreateBBox(MDT), InsidePoint(CCollision), GetMaxY(MDT), Intersection(CCollision),
  PickUpNearPoly(MDT), Copy(CCollision&,...)(CCollision), Initialize(MDT),
  Copy(CCollisionMDT&,...)(MDT). So no virtual is declared/overridden in CEditCollision.
- All eight members are non-virtual, non-const (mangled `Fv` etc.).

## Functions
- `ClipBoxXZ(max_a, min_a, max_b, min_b)`: VU0 inline asm; clears status, `vsub.xz max_a-min_b`,
  `vsub.xz max_b-min_a`, returns `(status & 0x80 /*sticky sign*/) == 0` -> nonzero when the boxes
  overlap in X and Z. Callers pass outputs of `mgVectorMaxMin(max, min, ...)` and `bbox.max/min`.
  Global (not in local_symbols.tsv); called only from editcoll.
- `OverlapPoly3AreaXZ(clipped, clipper, box)`: Sutherland-Hodgman clip of triangle `clipped` (Y
  zeroed) against the 3 edges of `clipper` in XZ, two ping-pong buffers of 7 float4 each
  (0x70 stride); returns shoelace area * 0.5 (signed; callers take fabs), 0 if < 3 vertices. If
  `box` is non-null, each output vertex gets Y from the plane of `clipper` (normal =
  (v1-v0)x(v2-v1), d = -n.v0) and box max/min are accumulated (first vertex assigns both). Global
  (not in local_symbols.tsv); called only from the two `OverlapPoly3XZ` overloads.
- `Copy(dest, area_kind, memory)`: counts polys with `CCPoly+0x44` (`area_kind` in collision.hpp)
  == `area_kind`; if none or `memory == NULL`, `dest.poly = 0; dest.poly_count = 0`. Else
  `dest.poly_count = n; dest.poly = new (memory->Alloc(n * 5 + 2)) CCPoly[n]`-like
  (`__nwa__FUiP1(n*0x50, Alloc(n*5+2))`; Alloc's unit is presumably 16 bytes, +2 unexplained),
  copies matching polys (0x50-byte struct copy), then calls `this->CreateBBox()` on the SOURCE
  (`$18 = this`), not on dest. Caller `CEditMap::LoadEditInfo` copies from a temporary into the
  five CEditPartsInfo members with kinds 1 (0xC0), 2 (0x110), 2 (0x160), 3 (0x1B0), 5 (0x200).
  The meaning of these kinds was not established; parameter left `int` (an enum may belong with
  CCPoly in collision.hpp).
- `AreaXZ()`: sum of |shoelace XZ area| of each poly. Returns float.
- `OverlapPoly3XZ(triangle, area, box)`: returns 0 if `poly == NULL`. Zeroes `*area`; if `box`,
  `mgZeroVectorW(box->max)`, `mgZeroVectorW(box->min)`. Rejects via ClipBoxXZ(triangle bounds,
  bbox). For each poly whose bounds meet the triangle's, adds |OverlapPoly3AreaXZ(triangle, poly,
  &tmp)| and, when that area > 0 (double compare `_dpfgt`), merges tmp into `box` (first: `=`,
  then `mgBoxMaxMin`). Writes `*area`, returns `total > 0`.
- `OverlapXZ(other, matrix, box)`: for each of `other`'s polys, `mgApplyMatrixN(tmp, matrix,
  poly, 3)` then `this->OverlapPoly3XZ(tmp, &area, &tmpbox)`; sums areas, merges boxes. Returns
  float total.
- `OverlapPoly3XZ(triangle, matrix, area)`: transforms bbox with
  `mgApplyMatrix(max, min, matrix, bbox.max, bbox.min)`, ClipBoxXZ against the triangle bounds;
  then for each poly transformed by matrix, only if every vertex Y <= 0.1 (code computes
  `fabs((float)(0.1 < y)) == 0`), adds |OverlapPoly3AreaXZ(triangle, transformed, NULL)|.
  Returns `total > 0`.
- `ApplyMatrix(matrix)`: if poly: per poly `mgApplyMatrixN(poly, matrix, poly, 3)`, rounds each
  vertex Y to nearest integer (`(int)(y +/- 0.5)`), `mgPlaneNormal(normal, v0, v1, v2)`,
  `sceVu0Normalize(normal, normal)`; then `CreateBBox()`.
- `DeleteVerticalPoly()`: if poly: removes polys whose normalised normal has |y| < 0.01
  (overwrite with last, `--poly_count`, `--i`; break if count already 0); then `CreateBBox()`.
- `PickupVerticalPoly()`: returns 0 if poly NULL. Removes polys with |ny| > 0.01 (same swap-remove),
  `CreateBBox()`, then for each poly i searches j < i with `mgDistVector(n_i, n_j) <= 0.01` and
  `|n_i.v0_i - n_j.v0_j| <= 0.01` (same plane); writes the wall number into `CCPoly+0x46`
  (`ignore_mask` in collision.hpp) -- copied from j if found, else a new number. Returns the
  number of walls. So in edit geometry offsets 0x44/0x46 carry area kind / wall number; the
  collision.hpp names were not changed (not this unit's header).

## Globals
None: the unit has no data symbols (no INCLUDE_RODATA/INCLUDE_BSS). Float literals (0.5, 0.01,
0.1) are in .rodata/.sdata of the functions themselves.
