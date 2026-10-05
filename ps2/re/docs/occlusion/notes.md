# occlusion: reverse-engineering notes

Unit holds one class, `COcclusion` (no first-game counterpart; Dark Cloud 1 has no occlusion
unit). Two functions: `Setup` (0x2DAE90) and `CheckSphere` (0x2DB080). No data, no constructor,
no vtable.

## Size: 0xC0, 16-byte aligned
- `CMap::CreateOcclusion` (map) and `CMap::PreDraw` index `CMap + 0x680 + i * 0xC0`;
  `CMapParts::InsideScreen` steps `param_1 + 0xC0`. `CMap` holds `COcclusion occlusion[8]` at
  0x680 with `occlusion_num` at 0x670 (padding 0x674..0x67F => 16-byte alignment, from the
  `sceVu0FVECTOR` members).

## Layout
| Offset | Field | Evidence |
|---|---|---|
| 0x00 | `int enable` | Set to 1 by `CMap::CreateOcclusion`; `Setup` and `CheckSphere` bail when 0; `PreDraw` only calls `Setup` when non-zero. |
| 0x04 | `unk_4[0xC]` | Never touched (alignment gap). |
| 0x10 | `sceVu0FVECTOR vertex[4]` | `CreateOcclusion` copies its `float(*)[4]` argument (4 rows) here; `Setup` passes `this+0x10` as the input of `mgApplyMatrixN(out, view, this+0x10, 4)`. |
| 0x50 | `int setup` | `Setup` sets 1; `CheckSphere` returns 0 when it is 0. Never cleared in any ghidra output (only `enable`/`occlusion_num` are reset). |
| 0x54 | `unk_54[0xC]` | Never touched. |
| 0x60 | `sceVu0FVECTOR plane` | `mgPlaneNormal` + `sceVu0Normalize` into xyz, w = `-dot(n, v0)`. |
| 0x70..0xA0 | `sceVu0FVECTOR side_plane[4]` | `mgPlaneNormal(side, zero, va, vb)` (plane through the eye at origin and an edge), normalized, w stored 0. |
| 0xB0 | `sceVu0FVECTOR view_min` | `mgVectorMin(this+0xB0, v0..v3)` (lqc2/vmini/sqc2: full 16 bytes written). `CheckSphere` reads `+0xB8` (z). |

## Behaviour
- `Setup(view)`: `view` is `&mgRenderInfo.view` (0x3971E0 = mgRenderInfo 0x397040 + 0x1A0,
  the world->view matrix in `mg_drawenv.hpp`). Transforms the 4 corners to view space (stack
  array of 4 vectors), view_min = min of them, plane through (v2, v1, v0); if its w (`-dot`) > 0
  the plane is rebuilt with winding (v0, v1, v2) and side planes use
  (0,v1,v2) (0,v3,v0) (0,v0,v1) (0,v2,v3); else (0,v2,v1) (0,v0,v3) (0,v1,v0) (0,v3,v2).
  Comparison is `0.0 < -dot` (m2c: `!(temp_f0 <= 0.0f)`).
- `CheckSphere(sphere)`: sphere is view-space centre xyz + radius w (caller
  `CMapParts::InsideScreen` builds it via `sceVu0ApplyMatrix` with `mgRenderInfo.view` * LW
  matrix, w = the part's bounding radius at CMapParts+0x26C). Returns 0 if !enable or !setup,
  0 if `sphere.z - sphere.w < view_min.z`, 0 if `dot(plane, s) + plane.w < r`, 0 if any
  `dot(side_plane[i], s) < r`; else 1 (hidden). Order of the checks: plane, side 0,1,2,3.
  Last one compiles to `c.lt.s; bc1t; li 1 / li 0; xori 1` i.e. `return !(dot < r)` (or `r <= dot`).

## Ambiguities
- Return type of `CheckSphere`: declared `int`; no `andi 0xFF` at the caller so `bool` vs `int`
  cannot be told from the caller alone. Try `bool` if `int` does not match.
- Names `enable`, `setup`, `vertex`, `plane`, `side_plane`, `view_min` are descriptive, not retail.
- Retail symbol sizes are 0x1E8 / 0x12C; header uses the padded index sizes 0x1F0 / 0x130 like
  other headers.
- `map.hpp` (which includes `occlusion.hpp`) did not compile at the time of writing only because
  `funcpoint.hpp` does not exist yet.

## C++ draft status

Both `Setup` and `CheckSphere` now have named, typed C++ drafts in `occlusion.cpp`.
Their single grouped promotion attempt compiled but did not match the retail
object: objdiff reported 85.62% for `Setup` and 60.49% for `CheckSphere`. Both
drafts remain behind `NONMATCHING`, with the assembly definitions used by the
normal build. The normal full build remains byte-identical.
