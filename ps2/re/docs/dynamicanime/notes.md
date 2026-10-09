# dynamicanime: reverse-engineering notes

## Native source status

`dynCOLLISION` is native C++ with an after-inline placement-conversion row for
one `CDAColPipe` construction. No `NONMATCHING` guards or assembly fallbacks
remain in this unit. Complete-object and PAL verification accept the native
caller; see [placement conversion](../satansfiddle/placement-new.md).

Before that conversion, the guarded-source object passed the canonical
comparison at 0x2C70 bytes and 366 relocations with retail assembly supplying
`dynCOLLISION`. `scripts/re/promotion_attempts.tsv` records older isolated
trials and is not the current match inventory.

Cloth/hair simulation ("dynamic anime") driven by a tag script. Owned by `CCharacter2` as an array
of `CDynamicAnime` (character `+0x130`, count at `+0x12C`, stride 0x90), loaded by `_CLOTH` in
character.cpp, stepped by `CCharacter2::StepDA`, drawn by `CCharacter2::Draw` via `DrawSub(0)` and
`DrawDirect` via `DrawSub(1)`. No counterpart in the first game.

## File-local symbols
Every non-member function (`BindPosition`, all `dyn*` tag handlers, `dynFixVertex`,
`FRAME_POSE_Sub`) and every global (`dynmc_tag`, `dynNowDA`, `dynStack`, `dynTopFrame`,
`dynFrameCount`, `dynVertexCount`, `dynFixVertexCount`, `dynBindVertexCount`, `dynBBoxCount`,
`dynColCount`) is LOCAL in retail (`build/re/local_symbols.tsv`), so none is in the header; declare
them `static` in the .cpp. Types for the .cpp:
- `static SPI_TAG_PARAM dynmc_tag[28]` (0xE0 bytes; 27 tags + null terminator; in `.data`):
  FRAME_START, FRAME, FRAME_END, VERTEX_START, VERTEX, VERTEX_L, VERTEX_END, FIX_VERTEX_START,
  FIX_VERTEX, FIX_VERTEX_C, FIX_VERTEX_S, FIX_VERTEX_END, FRAME_POSE, FRAME_POSE_L, DRAW_FRAME,
  BIND_VERTEX_START, BIND_VERTEX, BIND_VERTEX_END, BOUNDING_BOX_START, BOUNDING_BOX,
  BOUNDING_BOX_END, COLLISION_START, COLLISION, COLLISION_END, GRAVITY, K, WIND.
- `dynNowDA` `CDynamicAnime *`, `dynStack` `mgCMemory *`, `dynTopFrame` `mgCFrame *`, the six
  counters `int` (next index for the SetX/pGetX calls of each tag).
- `BindPosition(float *a, float *b, float length, float rate)`: moves a and b along their
  difference so their distance becomes `length`; a takes `(1-rate)` of the error, b `rate`.
- `dynFixVertex` returns `DA_FIX_VERTEX *` (or null); `FRAME_POSE_Sub` returns `DA_FRAME_POSE *`.
- Strings: at_855 "not found %s\n", at_976 "bone", at_977 "bone_yx", at_978 "b_cdlr",
  at_979 "error vertex no %d!!\n", at_1025 "error vertex no %d-%d!!!\n", at_1074 "pipe".

## CDynamicAnime (0x90)
Size: CCharacter2 stride 0x90 (StepDA/Draw/_CLOTH) and `Alloc(count*9)` in CCharacter2::Copy;
Initialize/Copy touch exactly 0x00..0x8F. Constructor `__ct__13CDynamicAnimeFv` (inline, emitted
in character at 0x178300) only calls Initialize.

| Off | Field | Evidence |
|---|---|---|
| 0x00 | `mgCFrame *top_frame` | Load sets from param; ResetPosition/Step GetLWMatrix on it; Copy replaces it |
| 0x04 | `int frame_num` | NewFrameTable count; GetFrame/SetFrame/pGetFramePose bound |
| 0x08 | `mgCFrame **frame` | NewFrameTable `Alloc(ceil(n/4))`, zeroed; GetFrame |
| 0x0C | `DA_FRAME_POSE *frame_pose` | NewFrameTable `Alloc(n)` (16 B each), memset 0x10; Step passes `&frame_pose[i]` to FramePose |
| 0x10 | `int vertex_num` | NewVertexTable; CheckVertexID |
| 0x14 | `sceVu0FVECTOR *init_vertex` | Set/GetInitVertex |
| 0x18 | `sceVu0FVECTOR *now_vertex` | SetNowVertex; Step integrates into it |
| 0x1C | `sceVu0FVECTOR *old_vertex` | SetOldVertex; Step `velocity = now - old; old = now` |
| 0x20 | `sceVu0FVECTOR *velocity` | Step adds gravity, then `now += velocity`; ResetPosition zeroes |
| 0x24 | `sceVu0FVECTOR *world_init_vertex` | Step: `mgApplyMatrixN(0x24, topLW, init, n)` only when `k > 0`; never read in this unit (Copy copies it) |
| 0x28 | `int fix_vertex_num` | NewFixVertexTable (dynFIX_VERTEX_START passes vertex_num, not the script value) |
| 0x2C | `DA_FIX_VERTEX *fix_vertex` | `Alloc(n*2)`, stride 0x20; Step indexes it by vertex index |
| 0x30 | `int draw_frame_num` | NewDrawFrameTable; DrawSub loop |
| 0x34 | `int *draw_frame` | filled with -1; GetDrawFrame -> GetFrame(draw_frame[i]) |
| 0x38 | `int bind_vertex_num` | NewBindVertexTable |
| 0x3C | `DA_BIND_VERTEX *bind_vertex` | stride 0x10; Step calls BindPosition 6 iterations |
| 0x40 | `int bbox_num` | NewBoundingBoxTable |
| 0x44 | `DA_BOUNDING_BOX *bbox` | `Alloc(n*3)`, stride 0x30 |
| 0x48 | `int collision_num` | NewCollisionTable |
| 0x4C | `CDACollision **collision` | zeroed; PreCollision / Step virtual CheckHit |
| 0x50 | `sceVu0FVECTOR gravity` | Initialize: zero then y = -0.6 (0xBF19999A); GRAVITY tag (w forced 0) |
| 0x60 | `float k` | K tag; Initialize 0; Step: positive -> world_init_vertex built |
| 0x64 | `float wind_scale` | WIND tag; Initialize 1.0 |
| 0x68 | `float wind_power` | SetWind/ResetWind; Step adds wind only when nonzero |
| 0x6C | (padding before vector) | |
| 0x70 | `sceVu0FVECTOR wind_dir` | SetWind normalizes into it |
| 0x80 | `int wind_seed` | Initialize 0x1E69D; Step `seed = seed*0x10DCD + 1` |
| 0x84 | `float wind_gust` | Step random walk `+= (seed/-2^31 - 0.5)*0.5`, clamped [0,1]; wind = dir * scale * power * gust |
| 0x88 | `int floor_enable` | SetFloor 1 / ResetFloor 0 |
| 0x8C | `float floor_y` | SetFloor; Initialize -100000.0 (0xC7C35000); Step clamps now.y and scales velocity by 0.3 |

Step outline: integrate (vel += gravity, vel.w = 0, now += vel); 6 iterations of
{bind constraints; for each vertex with fix weight >= 1, snap now to frame-space point};
PreCollision; per vertex: vel = now - old, old = now; soft fix (0 < weight < 1): pull by weight,
`vel -= pull*velocity_rate`; collisions only for weight < 1: OR of CheckHit results, min of
`friction` (starting 1.0) scales velocity; floor; wind; bbox min/max accumulated into stack locals
(result unused); finally FramePose for every frame entry.

Copy(dest, top_frame, stack): copies all fields into `dest`, then sets `dest.top_frame`; if
non-null, re-allocates `frame` (frames looked up by name in the new model via
`SearchFrameID`/`GetFrame`, `frame[i]->name` at mgCFrame+0x50) and the five vertex arrays with
`operator new[](size, ptr)` placement (`__nwa__FUiP1`) on `stack->Alloc(n+2)`; other tables shared.

Load: Initialize; reset counters; set globals; save top frame position/rotation/scale (vtable
0x18/0x24/0x30 getters), set to 0/0/1 (0x14/0x20/0x2C setters), run `CScriptInterpreter` on
`dynmc_tag`, restore (0x10/0x1C/0x28).

## DA_FRAME_POSE (0x10, retail name from FramePose's mangled symbol)
`type` (+0) DA_FRAME_POSE_TYPE, `vertex_num` (+4, always 4), `vertex_id` (+8, `Alloc(1)` = 4 ints),
`local` (+0xC): FRAME_POSE_L sets 1; FRAME_POSE sets 0 and `DeleteParent`s the frame. When set
(and frame->parent at mgCFrame+0x54 non-null) FramePose premultiplies by the parent's inverse LW.
FramePose builds a matrix with `SetTransMatrix`:
- 1 "bone": row2 = norm(v1-v0); row0 = norm(mid(v2,v3) - mid(v0,v1)); row1 = row2 x row0; row2 = row0 x row1 normalised; origin mid(v0,v1).
- 2 "bone_yx": row1 = norm(v1-v0); row0 as above; row2 = row0 x row1; row0 = row1 x row2 normalised; origin mid(v0,v1).
- 3 "b_cdlr": row0 = norm(v1-v0); row2 = norm(v2-v3); row1 = row2 x row0; origin v0.
- 0 / other: nothing. Enum values seen in FRAME_POSE_Sub and FramePose; names are invented from the strings.

## DA_FIX_VERTEX (0x20, name invented)
+0 position (frame-local, from `GetInverseMatrix` of the frame applied to the init vertex, w=1);
+0x10 int frame_id (-1 on failure; dynFixVertex writes it before the null check);
+0x14 weight (default 1.0, 3rd arg); +0x18 velocity_rate: FIX_VERTEX 0.0, FIX_VERTEX_C 1.0,
FIX_VERTEX_S -1.0; +0x1C float from 4th arg (default 1.0), never read in this unit -> `unk_1c`.

## DA_BIND_VERTEX (0x10, name invented)
+0/+4 vertex ids, +8 rate (default 0.5, 3rd arg, reset to 0.5 if outside [0,1]),
+0xC length = `mgDistVector` of the two init vertices. Step passes (length, rate) to BindPosition.

## DA_BOUNDING_BOX (0x30, name invented)
+0 vector (BOUNDING_BOX arg 2..4), +0x10 vector (args 5..7, else copy of the first), +0x20 int
frame id (arg 1; New... sets -1). Never read in this unit, so the two vectors are `unk_0`/`unk_10`.
Retail bug: NewBoundingBoxTable allocates `bbox_num` entries but its init loop runs to
`bind_vertex_num`.

## CDACollision (0xD0) / CDAColPipe (0xE0)
Created only in dynCOLLISION ("pipe"): `new (stack->Alloc(0x10)) CDAColPipe` (0xE0 bytes), inline
ctors store `__vt__12CDACollision` at +0xC0 and call Initialize through the vtable (slot +0xC),
then `__vt__10CDAColPipe` and Initialize again. Hence vptr at +0xC0 (after the data members;
MWCC puts the vptr where the first virtual is declared, so data members are declared first in the
header; offsets were checked with constant-expression asserts) and the CDACollision size of 0xD0
(16-byte alignment). Vtables (0x37BB80/0x37BB90): {0, 0, CheckHit, Initialize} for both.

CDACollision fields: +0 frame_id (COLLISION arg 2), +4 friction (Initialize 0.8, optional arg 10),
+8..+0xF padding, +0x10 center (args 3..5), +0x20 radius (args 6..8; per-axis divisor in
CheckHit), +0x30 `mgCFrame *frame` (PreCollision), +0x40 lw_matrix (GetLWMatrix), +0x80
inverse_matrix (mgInversMatrix of +0x40). CDAColPipe +0xD0 axis (arg 9; 0..2 index into the
local vector). CDAColPipe::CheckHit: local = inv * p; d = (local-center)/radius; if |d[axis]| <= 1
and the length of d with axis zeroed < 1, push out to the ellipse surface, keep the axis
coordinate, transform back with lw_matrix; returns 1/0. CDACollision::CheckHit returns 0.
Step reads the vtable at +0xC0 and calls slot +8 (CheckHit) and reads +4 (friction).
CDACollision::Initialize zeroes center/radius and sets friction 0.8; CDAColPipe's also sets axis 0
(it does not call the base).
The C++ body of `CDACollision::CheckHit` returns 0 for every position and
matches the retail function; its promotion links byte-identically.

## Constructor-backed allocations

`dynCOLLISION` allocates a `CDAColPipe`; its C++ constructor naturally initializes
the `CDACollision` base before the derived volume. The current body retains this
nested typed placement expression and uses the documented conversion policy.

Before that policy, the native draft scored 97.25%: its only byte difference
was the allocation null check, where MWCC tested the saved pointer instead of
the return register used by retail. Splitting `Alloc(16)` into a typed
`u_long128 *` local produced identical code. Retail assembly supplied the
caller at that earlier source/profile boundary.
