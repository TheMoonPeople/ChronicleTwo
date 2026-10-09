# gameutil: reverse-engineering notes

## C++ draft status
The matching build supplies 35 of the 37 functions from source, including
the existing inline-assembly exceptions. Two remain under `NONMATCHING`
with retail assembly fallbacks. Raw draft comparisons use
the pinned deterministic compiler profile; promotion also requires complete
object bytes, resolved relocations, and the inherited linked-image baseline.

Header: `ps2/include/gameutil.hpp`. No class in `class_units.tsv` is owned by gameutil; the header
declares the plain structs and enums the unit's code uses.

## Linkage
- Local (static, keep in the .cpp, not in the header): `QuatSlerp__FPfPffPf`,
  `testVUnew__FPA4_fPfPfPfPf`, `SetKeyFrame__FP8Mot_ListP20FRAME_VECTOR_EX_DATAP9mgCMemory`
  (all in `local_symbols.tsv`). Every other function is global and declared in the header.
- All data of the unit is local (static): `OldSkinFrame` (mgCFrame*, last skinned frame; reset to 0
  by DeformMesh), `def_vrtx` (sceVu0FVECTOR[800], 0x3200: skinned-vertex accumulator, w = weight
  sum), `def_nml` (0x10 in retail although MotionProc3 writes up to 800 normals into it; it
  overruns into the tmp_* matrices), and the function-local statics `vert_845`/`vert_915`
  (sceVu0FVECTOR* into the visual's vertices), `nml_916` (normals), `tmp_*Matrix*_8xx/9xx`
  (sceVu0FMATRIX), `at_945` (16-byte vector constant), `at_966`/`at_967` (printf strings
  "MAX_VERTX OVER %d/%d" / "MAX_NORMAL OVER %d/%d", limits 400 and 800). No `extern`s in header.
- MotionProc2 / MotionProc3 / testVUnew use VU0 macro code (`lqc2`, `vmulabc`...).

## Types (offset -> evidence)
### tagMOTION_TYPE (0x14)
Size: CCharacter2 holds `tagMOTION_TYPE[8]` at 0x3C0 and another `[8]` at 0x460 (stride 0x14),
`memset(dest, 0, 0x14)` in `_MOTION`/`_SHADOW_MOTION` (character).
- 0x00 base_matrices: CreateAnimeDataEX memcpy of file 0; MotionProc2/3 index `* 0x40` by frame.
- 0x04 motion_list: built by CreateAnimeDataEX from file 1; walked by SetMotionTime/ChangeMotion.
- 0x08 skin_list: built from file 2; walked by DeformMesh, AnimeDataInit.
- 0x0C unknown (copied as a word by `_MOTION`).
- 0x10 frame_info: `_SHADOW_MOTION` stores the tagFRAME_INF* (chr+0x470); `_SKIN_MOTION` reads
  chr+0x3D0 as tagFRAME_INF*.
First game's tagMOTION_TYPE was 0x80 with an embedded MOTION_STATE; this game moved state into
CCharacter2 (0x368..0x3A0, 0x508).

### Mot_List (0x20, asserted)
Allocated by `mgCMemory::Alloc(3)` (quadwords, callers always pass `size/16 + 1`), so size is in
0x20..0x2F; 0x1C is the last used word, 0x20 matches the first game.
0x00 frame (GetFrame index), 0x04 target (vertex index+1 for type 12: `(target-1)*0x10`; material
index `*0x30` for types 40/41; bone frame for skin types), 0x08 type, 0x0C key_count (unsigned
loops in SetKeyFrame/MotionProc2/3, signed test in MotionProc's binary search), 0x10 values
(`Alloc(count+1)`, stride 0x10), 0x14 key_frames (`Alloc(count/4+1)`, stride 4, binary searched
with unsigned compares), 0x18 next. CreateAnimeDataEX / ChangeWeight build the list by prepending
and then reverse it in place.

### FRAME_VECTOR_EX_DATA (0x20) and Mot_File_List (0x20)
Motion file layout: a 0x20 header then key_count 0x20 keys, repeated while header+0x14 != 0.
Header: 0x00 frame, 0x04 target, 0x08 type, 0x10 key_count, 0x14 more. Key (retail type
FRAME_VECTOR_EX_DATA, SetKeyFrame's parameter): 0x00 frame -> key_frames[i], 0x10..0x1C value.
`Mot_File_List` is the first game's header name, not a retail symbol of this game.
In ChangeWeight the skin file is passed as `unsigned char *`; its header +0x04 is a frame index in
`skin_root`, mapped to `root` by name (`SearchFrameID(root, GetFrame(skin_root, idx)->name@0x50)`).

### tagFRAME_INF (0x20)
Stride `* 0x20` everywhere; AnimeDataInit(**) allocates `stAlloc64((frames + 10) * 2)` quadwords.
0x00 parent: `(GetFrame(i)->parent@0x54 - root) / 0x110` (so mgCFrame is 0x110 and frames are one
array). 0x04 vertex_count / 0x08 normal_count from visual (mgCVisualMDT) +0x20/+0x24.
0x0C vertex_refs: `Alloc(vcount*3+1)` quadwords = 0x30 per vertex, one `FrameLinkRecord` (`count`, then `link[11]`); filled
from visual+0x48 primitive list (prim +4 -> strip list, strip +2 stride, +6 count, +0xC index
array, +0x10 next; prim->+4 ushort flag 0x200 skips): for each vertex index idx[l] it appends
idx[l+1], the normal index associated with that indexed vertex. `mgCVisualMDT::CreateFace`
includes the normal index unless `MG_FACE_NO_NORMAL` is set; `SetData1`, `SetData2`, and `SetData3`
read `vertex[cursor[0]]` followed by `normal[cursor[1]]`. The link builders skip face groups
whose first strip has `MG_FACE_NO_NORMAL`; the resulting lists are never read in this unit. 0x10 base_vertices / 0x14 base_normals: copies of visual +0x30/+0x34. 0x18..0x1F unused.

### MOTION_FILE_INFO (0xC)
Callers build `MOTION_FILE_INFO[3]` on the stack (name, data, size) for base matrices, motion keys,
skin keys; name is nulled when the file is missing and CreateAnimeDataEX tests name (+0), then uses
data (+4) and size (+8). `data` typed `void *` (pack data; first game used `unsigned int *`).

### CollisionInfo (0x10)
The CCPoly wrappers build `{count, polys, 0, 0}` on the stack (sp+0x10..0x1C) and pass its address.
Only +0 count and +4 polys are read.

### CCPoly (not declared here; forward-declared)
Not owned by any class in class_units; probably belongs in collision.hpp (CCollision's
PickUpNearPoly). Layout seen here matches the first game: 0x50 stride; vertex[3] at 0x00/0x10/0x20,
normal 0x30, s16 attributes 0x40, 0x42, 0x44 (GetCPolyAttr tests 0x44 == 7 or 1), 0x46 ignore mask
(`attr & ignore_mask` skips the polygon), 0x48, 0x4A, s32 0x4C. GetFootPoly merges the first
nonzero 0x40/0x42/0x44 over all hits. CreateCharaCPoly zeroes 0x40..0x4F.

### MoveCheckInfo (owned by dng_main; forward-declared)
At least 0x110 here (larger than the first game's 0xD0): 0x00 float radius (<=0 -> 15),
0x04 flag (nonzero skips ground search), 0x08 landed, 0x10 CCPoly ground poly (0x50),
0x60 ground found, 0x70 CCPoly (0x50), 0xC0 ground point vec4, 0xD0 CheckWidth result,
0xD4 flag + 0xE0 vec4 (special area above), 0xF0 flag + 0xF4 float signed distance +
0x100 vec4 (special area crossed).

### RECT (forward-declared; owner probably drawwin)
{x, y, w, h} ints: CheckPosInOutForRect uses x..x+w, y..y+h; GetDisPosToRect uses x+w/2, y+h/2.

## Enums
- MotionKeyType: values from MotionProc (0,1,2,12,30,31,32,33,40,41,50,51) and MotionProc2/3 /
  AnimeDataInit (20, 21). 20 = weighted skin (weight = value.x * 0.01, MotionProc3 only handles 20);
  21 = averaged skin in MotionProc2 (accumulate, divide by w). 1 calls mgCFrame vtable+0x2C,
  2 writes frame+0xE0 and sets frame+0x40=1, 50/51 set frame+0xF4 attr +0x18 (0/3 and 2/1),
  40/41 use visual vtable+0x10 material array (+0xC alpha = 1-value), 41 also sets attr +0x28=2.
- CheckWidthSide: CheckWidth's result bits; diagonal probes OR 5/10/9/6 (= +X|+Z, -X|-Z, +X|-Z,
  -X|+Z), axis probes 1/2/4/8.

## Function notes
- Return types: CheckHit/CheckHitVertical return polygon index or -1 (0 for NULL info in CheckHit,
  -1 in CheckHitVertical); CheckHits* return hit count; sort > 0 and sort < 0 both sort ascending by
  distance (stored in hit_points[i][3]). Pipe radius is from[3]; sphere radius is sphere[3].
  `CheckHitsSphere` expands the sphere centre by its radius on xyz, rejects
  polygons outside that box, records sphere/polygon intersections, and sorts
  their distances when requested. Its 0x3E4 bytes match objdiff exactly;
  `gameutil` passes `check_objects.py` with 357 resolved relocations.
- MoveCheck always returns 0. It clips the requested movement against pipe
  hits, halves horizontal velocity for up to two retries, then updates ground
  and wall contact through polygon probes. A union overlays the returned
  `CCPoly` with the copied polygon record so `GetFootPoly` has its actual
  argument type; this also preserves the retail call setup. Its 0x608 bytes
  match objdiff, and `gameutil` passes `check_objects.py` with 357 relocations.
  CreateCharaCPoly returns 0 if max_polys < 2, else 2.
- CheckPosInOutFor*/CalcIntersection* return 0/1 (declared int; `xori` result could also be bool).
- ChangeWeight: void (v0 is memcpy leftover). AnimeDataInit(*) returns 1; CreateAnimeDataEX 1.
- MotionProc (time): `fptoui(time)` then binary search; types 12 process consecutive lists with the
  same frame in one call.
  In the vertex-key case, each consumed list advances to the next entry; a null next entry
  returns null immediately. The guarded C++ draft can express this with an ordinary null
  check and assignment, without labels or jumps.

## Division-check pragma

The unit-level `divbyzerocheck` pragma was redundant with the global MWCC flag; removing it left the full compiled object identical in objdiff.

## Assembly gaps

`testVUnew` uses the narrow inline VU0 exception: it transforms a vertex,
weights its xyz lanes, adds it to the accumulated vertex, and writes the
result to both destinations. Its 0x40 retail bytes match objdiff exactly;
the complete `gameutil` object passes `check_objects.py` with 357 resolved
relocations. `MotionProc2` and `CheckHits(CollisionInfo*, ...)` retain C++
drafts under `NONMATCHING` and use `INCLUDE_ASM` in retail builds.
`CheckHit(CollisionInfo*, ...)` now uses two
inline VU loads to retain the segment bounds in vf10/vf11 before testing
polygons. Its 0x32C bytes match objdiff exactly, and the `gameutil` object
passes `check_objects.py` with 357 resolved relocations.

## MotionProc(float) match

`MotionProc(float)` is native and matches all 596 comparison words, including
the trailing alignment word. Its body is 0x94C bytes; the complete gameutil
object passes with 357 resolved relocations. Declaration order for the
existing vertex locals and unsigned vertex-index arithmetic resolve the
camera/key allocation and permit the ordinary `count - 1` clamp.
[The October 8 follow-up](matching-r0-20261008.md) records the source form,
linkage audit, compiler observations and full validation.

Retail reads the motion type after `GetFrame`; m2c lifts this read in its
pseudocode, so moving it before the call is incorrect.

## October 8 guarded sweep: MotionProc(float), before the follow-up

The refreshed baseline is 289/596 differing words, with a 0x934 native body.
`decompile.sh MotionProc__FP8mgCFramefP8Mot_ListP9mgCCamera` recovers the
binary search and three vertex-key time regions. The existing `Mot_List`
layout, frame/visual/material fields, motion enum, SDK declarations and
camera methods already describe the dependencies; no header change is needed.

The search converts time to an unsigned frame number, finds the first key
frame greater than that number, and uses its predecessor as the current key.
The next key is clamped to the current key at the end of the key array. The
blend uses unsigned key-frame values, including their unsigned-to-float
conversion paths. Vertex keys consume consecutive list nodes for the same
model frame; each target is a one-based vertex index. A null successor
returns null, while a different frame returns that unconsumed node.

The intermediate region is `!(t <= 0.001f) && t < 0.999f`. The lower and
upper endpoint tests remain independent. This matters for unordered blends:
NaN fails the lower test and takes the `!(t < 0.999f)` upper-key path.
The retail camera-target case transforms the existing temporary vector
without first interpolating it, unlike camera-position keys; the draft
preserves that behavior. Neither observation warrants an added operation.

In all three vertex loops, retail continues through the nonnull successor
branch and returns null from its other arm. Expressing this as
`if (list != NULL) { node = list; } else { return NULL; }` restores the
loop joins and their padding, growing the body to the exact retail 0x94C
bytes and reducing the positional difference to 32/596 words. The change
uses the existing typed linked-list traversal and adds no helper, label,
array-pointer induction or inline assembly.

The remaining differences are fully localized. At +0x18/+0x1C, camera
preservation uses s4 instead of retail s3 and swaps with the s2 save. Key
uses s3 instead of retail s4, including the later key-array shifts; the
vertex frame index reuses the camera register. At +0x9C/+0xA0, retail emits
`li v0,-1` then computes next, while the draft computes next then
`subu v0,key,next`. All call-relocation positions and kinds match.

The following probes use the canonical SF adapter, flags and logical unit
identity, with both draft macros. Only the positive successor arms are
retained; the function stays guarded.

| Probe family | Best differing words / extent | Evidence |
| --- | ---: | --- |
| Positive successor arms | 32/596 | Exact body size; retained. |
| Positive successor plus explicit continue | 32/596 | Same result; simpler arms retained. |
| Direct-list loop conditions | 289/596 | Removes useful loop padding; body 0x92C. |
| Break on exhausted list | 283/596 | Body 0x91C; worse than the retained branch form. |
| Separate successor local or returning list on exhaustion | 289/596 | No improvement. |
| Both key/next indices unsigned | 32/596 | No improvement; one unsigned index alone gives 95 or 117 words. |
| Direct count-minus-one clamp, either operand order | 312/596 | Immediate addition removes an early word; later positions shift. |
| Search-local scope | 43/596 | Saved-register mapping remains different. |
| Frame declaration at its call | 55/596 | Changes allocation without resolving the mapping. |
| Reuse search lower bound as current key | Worse than 32/596 | Changes live ranges and grows the body. |
| Scoped vertex index / vertex-pointer initialization first | 38/596, 36/596 | Changes vertex allocation only. |
| Next from low, predecremented key, or search-result assignment | Worse than 32/596 | Different index lifetimes do not restore the prefix. |
| Signed/long count and long-literal clamp variants | No improvement | No accepted type change. |
| Measured GPR history 0x10 or 0x30, FPR zero | 32/596 | Same retained bytes; no profile row. |

Private receipts are under `.private/sweep-midday/`: the m2c output is
`gameutil-motion-m2c.cpp`; `gameutil-vertex-probes`, `gameutil-index-probes`
and `gameutil-lifetime-probes` hold 14, 36 and 31 candidates respectively,
with compiler logs and metrics. `gameutil-vertex-positive-diff.txt` records
the retained instruction comparison. `gameutil-retained-native.log`
preserves all 34 exact functions and the two other guarded remainders.
The native preservation receipt records unchanged code bytes for the other
36 functions; only compiler-local static-number suffixes in the guarded
`MotionProc2` relocations advance, with identical offsets and kinds.

The normal-build fingerprint comparison preserves all 149 objects' allocated
sections and relocation identities. `gameutil-retained-objects.log` retains
147/149 passes, including gameutil; the same actscript/nd_meswin failures
remain. `gameutil-retained-build.log` retains only 0x26 PAL `.text` bytes
different, first at 0x0015C5AD, with memory end 0x01F64A00 and every other
file-backed section exact. No function is promoted.

This sweep's remaining camera/key and clamp differences are resolved by the
follow-up above. The recorded negative probes remain useful evidence: changing
the search-local lifetimes, integer types or helper-history masks alone did
not close them.
