# editriver: header notes

Unit holds the river functions of `CEditMap` (declared in `editmap.hpp`, owned by editmap) and
all of `CEditGrid` and `CGridData` (declared in `ps2/include/editriver.hpp`). No first-game
counterpart: neither class exists in chronicle.

Every function is native; the unit has no `NONMATCHING` guards, `INCLUDE_ASM` gaps, or data
markers. No global data with plain names, so the header has no `extern`s: the twelve data
pieces are automatic aggregate initializer templates in the matched C++:
- `DrawRiver`: four homogeneous corner vectors (.data).
- `DrawRiverMask`: center plus four corner vectors (.data).
- `CEditGrid::UpdateRiver`: two zero-initialized four-int shape/rotation arrays (.bss, 0x10 each).
- `CEditGrid::GetRiverPoly`: five homogeneous corner vectors (0x50 bytes, .data; the fifth row
  is the closing corner at the origin) with the grid pitches applied at runtime.

## CGridData (0x14)
Size: `__ct__9CGridDataFv` memsets 0x14; `Create` uses `__construct_new_array(.., ctor, 0, 0x14, n)`;
`GetFast` stride `* 0x14`; `Clear` memsets `num_x*num_z*0x14`.

| Off | Field | Evidence |
|---|---|---|
| 0x00 | `s32 river` | `SetRiver(ii)` stores 1, `ResetRiver(ii)` stores 0, `River()` returns it; LoadData calls SetRiver per saved cell |
| 0x04 | `s16 piece[4]` | `UpdateRiver` stores `pattern + (hash<0 ? 4 : 0)` per quarter (stride 2); DrawRiver/DrawRiverMask index `CEditMap+0xFAC` / `+0xFD0` pointer tables with it |
| 0x0C | `s16 rot[4]` | `UpdateRiver` stores rotation 0..3; DrawRiver passes `grid + rot*0x40 + 0x30` (a matrix of `CEditGrid::rot`) to `mgCFrame::SetTransMatrix`; CheckEditPartsOnRiver (editmap2) does the same |

## CEditGrid (0x130)
Size: `CEditMap::CreateGrid` does `new(mgCMemory::Alloc(0x15)) CEditGrid` via `__nw__FUiP1(0x130, ..)`
then calls `Initialize()` (no constructor). Field ranges sum to 0x130.

| Off | Field | Evidence |
|---|---|---|
| 0x00 | `s32 num_x` | `Create` arg1; `Check` bound for x; row stride in `GetFast` (`x + z*num_x`) |
| 0x04 | `s32 num_z` | `Create` arg2; `Check` bound for z |
| 0x08 | `CGridData *data` | result of `__construct_new_array` in `Create` |
| 0x0C | `float step_x` | CreateGrid sets 160.0 (0x43200000); `GetLPos` divides x by it; `GetWPos` multiplies |
| 0x10 | `float step_z` | as above for z |
| 0x14 | `unk_14[0xC]` | never accessed; probably only the 16-byte alignment padding before `origin` |
| 0x20 | `sceVu0FVECTOR origin` | `Initialize` -> `mgZeroVector(this+0x20)`; CreateGrid stores x/y/z; `.y` (0x24) used as the river draw height in DrawRiver/DrawRiverMask |
| 0x30 | `sceVu0FMATRIX rot[4]` | CreateGrid loop of 4 `sceVu0CopyMatrix(this+0x30+i*0x40, m)`, m = unit matrix turned by i quarter turns about Y |

No vtable, no base class, no static members.

## Behaviour (for the body writer)
- The float-coordinate `SetRiver` and `ResetRiver` overloads resolve a two-int grid position
  with `GetLPos` and call the integer overload only on success. The integer overloads update
  the changed cell and all eight neighbours in retail order; `ResetRiver` skips updates when
  the cell is already dry. `River` returns zero for an absent cell.
- Cell position: `GetLPos` returns false when either fractional coordinate is negative, otherwise
  `Check`. `GetWPos` writes `(origin.x + x*step_x, 0, origin.z + z*step_z, 1)` (y is 0.0, not origin.y).
- Quarter order c (matches `GetRiverPos(int,int,float(*)[4])` output order):
  0 = (-x,-z), 1 = (+x,-z), 2 = (+x,+z), 3 = (-x,+z). In `UpdateRiver` quarter c checks
  side neighbours a, b and diagonal d:
  c0: a=(x-1,z) b=(x,z-1) d=(x-1,z-1); c1: a=(x,z-1) b=(x+1,z) d=(x+1,z-1);
  c2: a=(x+1,z) b=(x,z+1) d=(x+1,z+1); c3: a=(x,z+1) b=(x-1,z) d=(x-1,z+1).
- Shape = `EditRiverPiece`: a+b==0 -> OUTER, rot (c+2)%4; ==1 -> EDGE, rot (c + (a?1:0))%4;
  ==2 -> d ? FULL rot 0 : INNER rot c. Shape/rot arrays are zero-initialized local `int[4]`
  arrays (copied from 16-byte .bss zero templates). Variant hash: `h = 0x10DCD`, per quarter
  `h *= (x+c)*(z+c+1)`, +4 when h < 0. The `%4` on a signed value shows as `&3` with a fix-up.
- `SetRiver(ii)` / `ResetRiver(ii)` call `UpdateRiver` on the cell then on (x-1,z),(x+1,z),(x,z+1),
  (x,z-1),(x-1,z-1),(x+1,z-1),(x+1,z+1),(x-1,z+1) in that order. `ResetRiver(ii)` returns 0 if the
  cell held no river; `SetRiver(ii)` returns `Get() != NULL`.
- `GetRiverPoly`: walks cells between `GetLPos(box.max)` and `GetLPos(box.min)` (the loops run
  from the min-cell up to the max-cell); per river cell needs `poly_max >= 8` (compared against
  the argument, never decremented inside) and writes 8 `CCPoly` (two per side, 2000.0 high,
  normal via `mgPlaneNormal`, attributes 0x40..0x4F zeroed by a quadword store of $zero). The
  side corners come from the local five-vector initializer with `step_x/z` patched in, and
  each side is pulled in by `margin` where the neighbour has no river. Returns triangles written.
  The caller `CEditMap::GetPoly` passes `CEditMap+0xFF8` (`river_poly_margin`) as margin and sets
  `CCPoly::ignore_mask` (0x46) to 0x10 on the result.
- `GetGridBox`: min = `GetWPos(GetLPos(pos))`, max = min + (step_x, 0, step_z), w = 1.
- `Clear`/`Initialize` return void (Ghidra shows memset's return only by register leftover).

## Return types
`Check`, `GetLPos`, `SetRiver`, `ResetRiver`, `UpdateRiver`, `River`, `GetRiverPoly` return `int`
(0/1 or a count). `Get`/`GetFast` return `CGridData *`. Ghidra types GetLPos/SetRiver(ii) as
`bool` because they return a `!= 0` comparison; check the final `sltu` in the asm if a body
needs `bool` to match (return type does not affect mangling).

## Open points
- `unk_14[0xC]`: unused; whether it is real fields or alignment padding is unknown.
- `editmap.hpp` declares `mask_piece[EDIT_MAP_MASK_PIECE_MAX]` (1 entry), but `DrawRiverMask`
  tests four non-null pointers at `CEditMap+0xFD0..0xFDC` and indexes `+0xFD0` with `piece`
  (0..7), reading `+0x70` (an `mgCFrame*`) from each; DrawRiver indexes `+0xFAC` with `piece`.
  The editmap header's layout around 0xFAC..0xFF4 should be re-checked by its owner.
- `EditRiverPiece` and the `EDIT_GRID_*` enum names are descriptive, not retail.
