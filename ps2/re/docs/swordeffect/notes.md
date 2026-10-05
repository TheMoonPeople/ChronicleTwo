# swordeffect: reverse-engineering notes

Unit owns `CSWordAfterEffect` (weapon swing trail) and the global `CreatSmoothPassSW`.
No first-game counterpart (nothing similar in `/home/adubbz/development/chronicle`). The closest
relative is `CSWordAfterImage` in `ps2/include/dng_effect.hpp` (event sword trail, same
ring-plus-smoothing design, similar field order 0x00-0x58); field naming follows it.

## CSWordAfterEffect (size 0xA0, no vtable, no constructor symbol)

Size: every creation site is `new (mgCMemory::Alloc(mem, 0xC)) ...` via `__nw__FUiP1(0xA0, ...)`
(maintex `SetSwordBlurEffect`, event_func `_SWE_INIT`, monster `LoadReferMonsterFile`,
character `CCharacter2::Copy`). Each site then stores 0x80 to 0x20..0x3C in order: an inline
constructor, declared in the class body. Last field touched is 0x98; 0x9C is tail padding
(declared `unk_9c`). Class alignment is 16 because of the `sceVu0IVECTOR` members.

Owners: `CCharacter2::sword_effect[3]` at character +0x570 (character.hpp); monster code uses
+0x580 of its own object. Initialized with `Initialize(mem, 12, 8)` and
`SetTexture(0x4A, TEX_SystemEffectSw, u, v, 0x40, 0x20)`.

| Off | Field | Evidence |
|---|---|---|
| 0x00 | `mgCFrame *frame0` | StartEffect p1; Step `GetWorldPosition0` -> AddPoint arg 1; Clear zeroes |
| 0x04 | `mgCFrame *frame1` | StartEffect p2; Step -> AddPoint arg 2 |
| 0x08 | `sceVu0FVECTOR *point0` | Alloc(point_max*16/16+1 qwords); AddPoint `sceVu0CopyVector(point0[write_index], pos0)`; src of CreatSmoothPassSW |
| 0x0C | `sceVu0FVECTOR *point1` | same for pos1 |
| 0x10 | `sceVu0FVECTOR *smooth0` | Alloc(point_max*(division+2)*16/16+1); dst of CreatSmoothPassSW; Draw `mgTransWorldPrim(prim, smooth0[i])` |
| 0x14 | `sceVu0FVECTOR *smooth1` | same |
| 0x18 | `unk_18[8]` | never touched; Copy skips it (padding before the 16-aligned colour) |
| 0x20 | `sceVu0IVECTOR color0` | ints r,g,b,a: Draw `Color(c[0],c[1],c[2],(int)(c[3]*alpha))`; Initialize 0x60,0x40,0x30,0x80; SetTexture(6) all 0x80 |
| 0x30 | `sceVu0IVECTOR color1` | Initialize 0x40,0x30,0x20,0x40; used for second edge only when untextured (textured draw uses color0 for both edges) |
| 0x40 | `float unk_40[4]` | only seen in Copy (lwc1/swc1) |
| 0x50 | `float unk_50[2]` | only seen in Copy (lwc1/swc1) |
| 0x58 | `s32 division` | Initialize p3; CreatSmoothPassSW `division` arg; buffer size factor |
| 0x5C | `s32 smooth_num` | CreatSmoothPassSW return; Draw clamps the drawn count to it |
| 0x60 | `s32 tex_block` | SetTexture(6) p1; Draw `mgTexManager.ReloadTexture(tex_block, NULL)` when texture != NULL |
| 0x64 | `mgCTexture *texture` | SetTexture(6) p2; Draw `Texture(texture)`, NULL -> TextureMapEnable(0) |
| 0x68 | `s32 tex_u` | Draw: u starts at (float)tex_u, steps tex_w/count |
| 0x6C | `s32 tex_v` | Draw: v of first edge |
| 0x70 | `s32 tex_w` | see 0x68 |
| 0x74 | `s32 tex_h` | Draw: second edge v = tex_v + tex_h |
| 0x78 | `s32 point_max` | Initialize p2; ring size |
| 0x7C | `s32 point_num` | AddPoint increments up to point_max; reset by StartEffect/Initialize |
| 0x80 | `s32 write_index` | AddPoint writes here then decrements, wrapping to point_max-1 |
| 0x84 | `s32 head_index` | AddPoint sets = write_index before decrement; `start` arg of CreatSmoothPassSW |
| 0x88 | `s32 active` | StartEffect 1; Step clears when alpha <= 0; Draw/Step/CreatPointList gate on it |
| 0x8C | `s32 length` | StartEffect p3 (Initialize 0x20); Draw count = (int)(length*alpha) |
| 0x90 | `s32 hold_time` | StartEffect p5; Step decrements while > 0 before fading |
| 0x94 | `float alpha` | StartEffect 1.0f; Step subtracts fade_speed; per-vertex alpha falls by alpha/count |
| 0x98 | `float fade_speed` | StartEffect `1.0f / fade_time` (p4) |

Names `frame0/1`, `point0/1`, `smooth0/1`, `color0/1` are neutral: which frame is the blade tip is
not established (callers pass frames found by name from action scripts).

### Copy layout clue
`Copy(dst, mem)` copies this -> dst. Scalars are copied interleaved lw/sw (0x00-0x14, 0x58-0x98),
but 0x20 and 0x30 are each one `lq/sq`, 0x40 is four `lwc1` then four `swc1`, and 0x50 two `lwc1`
then two `swc1`. Because `this` and `dst` may alias, grouped loads before stores mean each of
those is a single aggregate copy in the source (a struct assignment), not element-wise array
copies. So 0x20/0x30 are probably a 16-aligned 4-int struct and 0x40/0x50 float structs (16 and
8 bytes). Header uses `sceVu0IVECTOR` / float arrays; the body writer may need to replace them
with struct types (or find another construct) to match Copy. 0x18/0x1C are not copied.
After copying, if `mem` is non-NULL, Copy reallocates dst's four buffers with the same sizes as
Initialize (the sizes use point_max and division read from `this`).

### Function notes
- `StartEffect` ends with `printf("start !!\n")` (`at_356`, compiler literal). Ghidra shows it
  returning printf's result; no caller uses a result, so it is declared `void`.
- `CreatPointList` contains an empty `for (i = 0; i < point_num - 1; i++) {}` loop after the
  calls when smooth_num != 0; only the result of the first CreatSmoothPassSW call is stored.
- `Draw`: local `mgCDrawPrim` on the stack, `Begin(4)`; AlphaBlend(2), AlphaTest(1,0), ZMask(-1),
  Bilinear(1), Coord(1), Shading(1), DepthTest(1). Uses `mgTransWorldPrim` (mglib.hpp).

## CreatSmoothPassSW (global, not in local_symbols.tsv)
`int CreatSmoothPassSW(float (*dst)[4], float (*src)[4], int num, int division, int start, int ring_size)`
Returns 0 if num < 3. For each segment i in [0, num-1) picks 4 control indices (i-1,i,i+1,i+2,
clamped at the ends: first {0,0,1,2}, last {i-1,i,i+1,i+1}), adds `start` and wraps into
[0, ring_size). Builds a 4x4 of the control points (w = 0) and multiplies it by the Catmull-Rom
basis on the stack (rows -0.5,1.5,-1.5,0.5 / 1,-2.5,2,-0.5 / -0.5,0,0.5,0 / 0,1,0,0) with
`sceVu0MulMatrix`, then for t = 0 while t < 1 - 1/(division-1), step 1/(division-1), applies
(t^3,t^2,t,1) via `sceVu0ApplyMatrix` and writes xyz with w = 1.0. Returns points written.
Retail symbol size 0x384 (manifest 0x390 includes padding).

## Globals
None besides the compiler literal `at_356` ("start !!\n").

## Draft and promotion status
All ten remaining functions have named, typed C++ drafts. The draft comparison
reports four exact functions including the preexisting `Clear`, seven functions
with differences, and no missing drafts. One isolated promotion trial was made
for every guarded function. `AddPoint` and the four-integer `SetTexture`
overload linked byte-identically and now compile in the normal build. The
other functions retain their assembly fallback. `Step` matches in the grouped
draft build, but its isolated trial could not compile because `mgCFrame` is
complete only under the draft include guard. The larger curve and draw
routines still differ substantially from retail code generation.
