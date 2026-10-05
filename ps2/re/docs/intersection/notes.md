# intersection: reverse-engineering notes

Unit owns no classes (`class_units.tsv` has none). No global data except the compiler-generated
`at_161` (0x10 bytes in .bss, a vector read at the start of `IntersectionPipeYPoly3`; likely a
function-local static constant vector) -- not declared in the header. All six functions are
global (none in `local_symbols.tsv`).

External types used: `mgVu0FBOX` (mg_drawenv.hpp: `max` at 0x0, `min` at 0x10, size 0x20),
`RS_STACKDATA` (runscript.hpp). Both forward-declared.

No first-game counterpart for these functions (chronicle has only `IntersectionPoint_line_poly3`
in mathutil).

## Vector conventions
All vectors are `float[4]`. `pipe` / `sphere` = xyz centre, w = radius. `poly` = 3 vertex rows.
`normal` = triangle plane normal; callers pass `CCPoly + 0x30` (gameutil CheckHits*), w copied
along but only xyz used except in SpherePoly3 (copies all four into a temp before scaling).
Hit outputs are `float (*)[4]` arrays filled with points.

## IntersectionPipeYPoly3 (0x2E2DE0)
Infinite vertical cylinder vs triangle, worked in XZ:
1. Builds the horizontal direction perpendicular to the normal via two outer products with
   (at_161.x, normal.y, at_161.z, at_161.w), normalises, scales by radius; tests centre +/- that
   offset with `mgCheckPointPoly3_XZ`, storing each inside point.
2. Copies vertices with y = 0 and calls `mgIntersectionSphereLine` (centre with y = 0) on each
   edge, appending hits.
3. If any hits, sets each hit's y from the plane: `y = (dot(n, v0) - n.x*x - n.z*z) / n.y`.
Returns the hit count (max 2 + 3*2 = 8). Callers (CheckHitsPipeY) skip polys with |n.y| < 0.01.

## IntersectionPipePoly3 (0x2E31D0)
Normalises `dir`, builds an orthonormal basis (helper axis Y if |dir.z| < 0.9 else Z) with `dir`
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
Up to 6 candidates (local `float[8][4]` buffer also holds the box copy at rows 6-7), bubble-sorted
by w ascending, at most 2 copied to `hits`. Returns min(count, 2).

## IntersectionBox (0x2E3B00), 5 args
Transforms from/to (w = 1) by `mgInversMatrix(matrix)`, calls the 4-arg version into a local
buffer, sets w = 1 and applies `matrix` to each into `hits`. Returns the count. Note w of the
output is therefore the transformed 1, not the distance. Caller: CMapParts::InScreenFunc
(box at CMapParts-related object + 0x30).

## mt_test (0x2E3C00)
`return 1;` Script-command signature `(RS_STACKDATA *, int)`; no references found anywhere in
the asm (event_func's `_MT_TEST` is a different function).

## C++ drafts

All five intersection queries now have typed C++ drafts behind `NONMATCHING`; the default path remains retail assembly until a zero-score promotion. The pipe queries use `sceVu0FVECTOR` arrays for temporary points and transforms, sphere contact uses the `SpherePoly3Contact` values already declared in the header, and both box queries use `mgVu0FBOX::max` and `mgVu0FBOX::min` by name. The axis-aligned box query tests strict interior bounds, sorts the candidates by distance stored in each point's `w`, and returns at most two. The transformed overload replaces that `w` with 1 before applying the box matrix.
