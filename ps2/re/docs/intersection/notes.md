# intersection: reverse-engineering notes

## Status

All six functions in `ps2/src/intersection.cpp` are native and the unit carries no
`INCLUDE_ASM`, `NONMATCHING`, `INCLUDE_RODATA` or `INCLUDE_BSS` markers. The unit owns no
classes (`class_units.tsv` has none) and no file-scope data; its only data is the
compiler-generated 16-byte BSS vector of `IntersectionPipeYPoly3`'s function-local
`static sceVu0FVECTOR at` zero seed (retail symbol `at_161`), which is not declared in the
header. All six functions are global (none in `local_symbols.tsv`).

External types used: `mgVu0FBOX` (mg_drawenv.hpp: `max` at 0x0, `min` at 0x10, size 0x20),
`RS_STACKDATA` (runscript.hpp). Both forward-declared.

No first-game counterpart for these functions (chronicle has only `IntersectionPoint_line_poly3`
in mathutil).

## Vector conventions
All vectors are `float[4]`. `pipe` / `sphere` = xyz centre, w = radius. `poly` = 3 vertex rows.
`normal` = triangle plane normal; callers pass `CCPoly + 0x30` (gameutil CheckHits*), w copied
along but only xyz used except in SpherePoly3 (copies all four into a temp before scaling).
Hit outputs are `float (*)[4]` arrays filled with points. Vector copies are quadword
`u_long128` casts, which keep retail's aggregate copies (the SDK copy routine would emit a
function call) without byte-offset arithmetic or inline assembly.

## IntersectionPipeYPoly3 (0x2E2DE0)
Infinite vertical cylinder vs triangle, worked in XZ:
1. Builds the horizontal direction perpendicular to the normal via two outer products with
   (at.x, normal.y, at.z, at.w) -- the zero seed `at` copied by quadword before replacing the
   y lane -- normalises, scales by radius; tests centre +/- that offset with
   `mgCheckPointPoly3_XZ`, storing each inside point. The side points are tested separately;
   the second side's pointer stays live through both point tests and its quadword copy.
2. Before testing the edges, each triangle vertex whose XZ distance is no greater than the
   squared pipe radius is copied to the output. Then copies vertices with y = 0 and calls
   `mgIntersectionSphereLine` (centre with y = 0) on each edge, appending hits.
3. If any hits, sets each hit's y from the plane: `y = (dot(n, v0) - n.x*x - n.z*z) / n.y`
   (triangle plane dot product and reciprocal normal.y).
Returns the hit count (max 2 + 3 + 3*2 = 11); the output can contain duplicate points.
Callers (CheckHitsPipeY) skip polys with |n.y| < 0.01.

## IntersectionPipePoly3 (0x2E31D0)
Normalises `dir`, builds an orthonormal basis (helper axis Y if |dir.y| < 0.9 else Z) with `dir`
as the second row, transposes to get world->pipe space, transforms the triangle, normal and
pipe start (5 rows via `mgApplyMatrixN`), recomputes the normal with `mgPlaneNormal`, then calls
`IntersectionPipeYPoly3`; sets each hit's w to 1 and transforms back with the basis. Returns the
count. Caller CheckHitsPipe passes `from` and normalised `to - from`.

## IntersectionSpherePoly3 (0x2E3440)
d = dot(normal, centre - v0). If |d| > radius returns 0. Otherwise `push` = normal * d (via two
scales; xyz), `push[3]` = |d|. Then the projected point (centre - normal*d) is tested with
`mgCheckPointPoly3_XYZ`. Return values, captured in `enum SpherePoly3Contact` (name not retail):
0 none, 1 projected point inside face, 2 a vertex within radius (`mgDistVector2` <= r^2),
3 an edge meets the sphere (`mgIntersectionSphereLine` > 0). Caller CheckHitsSphere tests only
non-zero. Header keeps return type `int`.

## IntersectionBox (0x2E3650), 4 args
Segment from->to vs AABB `box`. For each axis, each of the box's max (0x0) and min (0x10)
planes that lies strictly between the segment's min/max on that axis gives a point on the
segment; kept if strictly inside the box on the other two axes. w = `mgDistVector(point, from)`.
Up to 6 candidates are stored in `float[6][4]`; a separate local `mgVu0FBOX`
occupies the immediately following 0x20 stack bytes. Candidates are sorted by w
ascending, and at most 2 copied to `hits`. Returns min(count, 2).

Source forms the match depends on:
- The minimum face is tested before the maximum face separately on each axis, each face in
  a single-entry `while` condition that exits through `break` after rejection or copy.
- The second transverse axis is computed only after the first transverse-axis test passes.
- The input box is copied locally by aggregate initialization (avoids its out-of-line
  assignment operator).
- The side predicates are `point >= max || point <= min`; MWCC lowers the former through
  `c.lt.s` plus a boolean temporary, including its unordered floating-point behaviour. The
  sort swaps when the earlier distance is not `<=` the later distance, so unordered distances
  also swap; `point` is the swap vector.
- `count` and `last_candidate` precede the two index declarations; `axis` is reused for the
  geometry search, the sort's outer loop and the output copy, which preserves the retail
  register lifetimes through the sorting and output phases.
- The native size is 0x4AC; retail's extra zero word at 0x2E3AFC is alignment padding after
  the return delay slot.

## IntersectionBox (0x2E3B00), 5 args
Transforms from/to (w = 1) by `mgInversMatrix(matrix)`, calls the 4-arg version into a local
buffer, sets w = 1 and applies `matrix` to each into `hits`. Returns the count. Note w of the
output is therefore the transformed 1, not the distance. Caller: CMapParts::InScreenFunc
(box at CMapParts-related object + 0x30).

## mt_test (0x2E3C00)
`return 1;` Script-command signature `(RS_STACKDATA *, int)`; no references found anywhere in
the asm (event_func's `_MT_TEST` is a different function).
