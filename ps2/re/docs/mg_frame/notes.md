# mg_frame notes

Classes: `mgCObject`, `mgCFrameBase`, `mgCFrame` (+ nested `mgCFrame::BoundInfo`), `mgCFrameAttr`.
Hierarchy `mgCObject -> mgCFrameBase -> mgCFrame` (mgCFrame ctor stores the three vtables in that
order, calling `Initialize` through the vtable after each). `mgCFrameAttr : mgCVisualAttr`
(mg_visual; ctor calls `__ct__13mgCVisualAttrFv`).

Header depends on `mg_visual.hpp` for the `mgCVisualAttr` base (by value). It did not exist when
this header was written; with a stand-in `class mgCVisualAttr { int a[6]; }` (0x18 bytes, no
vtable) the header compiled and every offset below was checked with temporary offsetof asserts.

## vptr placement (MWCC)
Probe: a class whose virtual functions are declared before its data gets the vptr at 0; one
whose data comes first gets it after the data. mgCObject's vptr is at 0 and its data at 0x10, so
its virtuals are declared before its fields.

## mgCObject (0x50)
| off | field | evidence |
|---|---|---|
| 0x00 | vptr | ctors store `__vt__9mgCObject` |
| 0x10 | position (vec4) | SetPosition/GetPosition; SetPosition writes w=1.0 |
| 0x20 | rotation (vec4) | SetRotation/GetRotation; w=0 |
| 0x30 | scale (vec4) | SetScale/GetScale; w=0 |
| 0x40 | changed (int) | set by every setter, ChangeParam, UseParam; GetLWMatrix rebuilds when set |
| 0x44 | use_srt (int) | set when any part changes; operator= sets it when pos!=0, rot!=0 or scale!=1; GetLocalMatrix copies trans_matrix when clear |
Size 0x50: CObject (object unit, derives from mgCObject) starts its fields at 0x50; mgCFrame's
first field is at 0x50.

## mgCFrameBase (0x50)
No fields (mgCFrame data begins at 0x50). `Initialize` is `j Initialize__9mgCObjectFv`.
Placed directly after `mgCFrame::mgCFrame` -- consistent with an inline virtual emitted after its
first user (the inlined mgCFrameBase ctor stores the vtable). Declared inline; unverified.
mgCFrameBase ctor has no symbol (fully inlined).

## mgCFrame (0x110)
Size: `operator=` memcpy 0x110; mgLoadMDSFile array stride 0x110 (`__construct_new_array(...,0x110,n)`).
| off | field | evidence |
|---|---|---|
| 0x50 | name (char*) | SetName; StrCmp in SearchFrame; mgSetFrameAttr parses after "--" |
| 0x54 | parent | SetParent/SetReference/DeleteParent |
| 0x58 | child | SetChild, GetFrameNum loop |
| 0x5c | brother | SetBrother, child loops (`piVar[0x17]`) |
| 0x60 | elder (prev sibling) | SetBrother sets `brother->0x60 = this`; DeleteParent |
| 0x64 | frame_num (int, signed compares) | GetFrame, SearchFrameID; set in mgLoadMDSFile/mgCopyFrame |
| 0x68 | frame_list (mgCFrame**) | same |
| 0x6c | init_matrix (float(*)[4][4]) | mgLoadMDSFile fills one GetLWMatrix result per frame |
| 0x70 | lw_matrix | GetLWMatrix cache; Initialize sets unit |
| 0xb0 | trans_matrix | SetTransMatrix(matrix), SetTransMatrix(quat) keeps row 3; Initialize unit |
| 0xf0 | bound (BoundInfo*) | SetBound (mapload), SetBBox/GetBBox/SetBSphere |
| 0xf4 | attr (mgCFrameAttr*) | SetAttrParam*, Draw |
| 0xf8 | visual (mgCVisual*) | SetVisual (mg_dataset); visual's vptr is at +0x1c |
| 0xfc | reference (int) | SetReference=1 / DeleteReference=0; GetLWMatrix forces rebuild |
| 0x100 | rot_type (int) | SetRotType; bit1 apply rotation, bit2 rotate about own origin (forces bit1) |
| 0x104-0x10f | (padding) | never accessed by mg_frame; covered by memcpy only. Left as natural padding. |

`GetChild` and `GetBrother` are inline accessors for `child` and `brother` with no retail
symbol. `CopyFrameSub` (mg_dataset) walks the children through them; see that unit's notes.

### BoundInfo (0xB0)
`operator new(0xb0)` in mapFUNC_EFFECT_NAME and mgCMDTBuilder::End; Alloc(0xb) qwords in
CreateFrameVisual. corner[8] 0x00 (SetBBox: bit0 picks x, bit1 y, bit2 z from max(+0x80) vs
min(+0x90), w=1.0), max 0x80, min 0x90 (mgVectorMaxMin output order: max, min), sphere centre
0xa0 (copied as a vec4 by SetBSphere, then radius written at 0xac).
`SetBBox` can use its `BoundInfo *bound` field directly for the max, min and
corner writes; removing the old casts preserves the 0xF4-byte PAL function.

### Vtable `__vt__8mgCFrame` (slot offset: function)
0x08 ChangeParam, 0x0c UseParam, 0x10 SetPosition(f*), 0x14 SetPosition(fff), 0x18 GetPosition,
0x1c SetRotation(f*) [mgCFrame], 0x20 SetRotation(fff) [mgCFrame], 0x24 GetRotation,
0x28 SetScale(f*), 0x2c SetScale(fff), 0x30 GetScale, 0x34 Draw() [mgCFrame], 0x38 DrawDirect,
0x3c Initialize [mgCFrame], 0x40 GetWorldBBox (new), 0x44 Draw(uint*) (new), 0x48 SetVisual (new).
mgCObject/mgCFrameBase vtables end at 0x3c. No destructors. Trailing zero word in mgCFrame's is padding.

### Inline vs not
- Inline, emitted at the end of mg_frame for the vtables: `mgCFrame::Draw()` (tail-jumps to slot 0x44
  with a0=0), `mgCObject::ChangeParam/UseParam/DrawDirect/Draw`.
- Inline, emitted after first use in other units: `mgCFrame::SetVisual` (mg_dataset, right after
  CreateFrameVisual; mg_frame's vtable copy apparently deduplicated), `mgCObject::mgCObject`,
  `mgCFrame::GetMaterial`, `mgCFrame::SetBound` (mapload). GetMaterial is declared without a body:
  its body (`visual ? visual->GetMaterial(i) : 0`, visual vtable slot 0x14) needs mgCVisual complete.
  Return type `mgMaterial*` is inferred (mgCVisualMDT::GetMaterial returns an element of a 0x30-stride
  array; mgMaterial is the material type in mg_visual/mg_dataset signatures) -- unverified.
- Non-inline: everything else, including operator= (0x138D50, before the inline block).

### Behaviour notes for the body writer
- GetFrame: `0 <= i && i <= frame_num` (note `<=`), then frame_list ? frame_list[i] : 0.
- SearchFrame: compares own name, then recurses into children only (via brother chain).
- SearchFrameID: linear over frame_list (skips nulls), returns index or -1.
  Direct `frame_list[index]` access matches the retail loop without byte offsets.
- StrCmp (static): returns 1 when both names are equal up to NUL or "--", 0 otherwise or if either is null.
  Its pointer locals can use `char *`, but narrowing the loaded character to `s8`
  before comparing with `'-'` remains necessary for PAL code generation.
  mgFrameNameComp is `j StrCmp` (StrCmp inlined/tail-called).
- GetLWMatrix: reference forces changed; uses cache only if neither self nor any ancestor changed;
  else ClearChildFlag, GetLocalMatrix, parent LW * local via VU0 macros, stores to lw_matrix.
- GetLWMatrixTopBottom: like GetLWMatrix but takes the parent's cached lw_matrix (checks only the
  direct parent's changed flag); reference frames defer to GetLWMatrix.
- GetBBoardMatrix(mode, m, info): scale from row lengths of LW, eye at info+0x3a0; mode&2 yaw only,
  mode&1 yaw then pitch; caches into lw_matrix, clears changed, ClearChildFlag.
- Draw(uint*): attr==0 -> skip own visual. billboard -> GetBBoardMatrix(&mgRenderInfo) else
  GetLWMatrixTopBottom. Own visual drawn if draw&1 and visual; screen test (test1/test2/mgClipBoxW/
  mgClipInBoxW with mgRenderInfo boxes) unless no_cull or no bound. Writes mgRenderInfo fields at
  0xfc0 (needs clip), 0xfc4 (clip on: clip_enable | info global, or only clip_enable when
  program_mode&2), 0xfcc (attr pointer), 0x1000 (color), 0xfc8 (point light hit: point_light &&
  info 0xfa8 && !no_light && bound; tests 4 lights, stride 0x30 at lightinfo+0x90/0xb0/0xb4).
  Visual drawn by vtable slot 0x2c of visual (+0x1c vptr). Children skipped when draw&2; child
  skipped if its attr has draw&4. Packet advanced by count*4 words (quadwords).
  The guarded behavioral draft now follows those draw, cull, clip, point-light and child rules.
  It uses `mgInsideScreen` for the VU0 screen test; the draft differs from retail and the normal
  build still uses the original assembly.
- GetDrawRect: null manager -> &mgDrawManager; info = manager+0x64; uses static `dmy_attr` when attr null.
  The guarded draft projects all eight bound corners through `world_screen_rel`, divides x/y by
  absolute w, moves the resulting rectangle to screen coordinates, and unions visible child
  rectangles. The retail code uses an inlined VU0 projection, so this behavioral draft differs
  substantially while ordinary builds retain the assembly.

## mgCFrameAttr (0x90)
Size: Initialize memsets 0x90; `dmy_attr` bss 0x90. Fields copied member-wise by SetAttrParam
(mask 0): 0x64-0x6c are not copied -> padding before the 16-aligned colour vector.
Defaults (Initialize): base Initialize, draw=1, unk_20=100.0, fog=1, unk_3c=0, obj_alpha=1.0,
unk_50=(0,1,0,0), color=(128,128,128,128), point_light=1, unk_84=0, depth_bias=0; also overwrites
base 0x0=-1 and 0x8=1.
| off | field | evidence |
|---|---|---|
| 0x00-0x17 | mgCVisualAttr | 0 alpha ref (TEST.AREF; 'A'+hex), 4 alpha blend ('APP'=2,'ANN'=3,'AOF'=4 -> mgCDrawEnv::SetAlpha), 8 z write (>0 write, <0 ZMSK; 'Z0'=-1), 0xc z test (-1 ALWAYS,1 GEQUAL,2 GREATER; 'O0'=0 else -1), 0x10 alpha test (-1 off, else ATST=v&7), 0x14 dest alpha test (-1 off,1 DATM0,2 DATM1) -- from SetDrawEnv / SetDrawEnvGifTag in mg_visual |
| 0x18 | draw | 'V' (V0 -> 2, else 1); Draw/GetDrawRect bits 1/2/4 |
| 0x1c | clip_enable | 'N'; Draw ORs it into mgRenderInfo+0xfc4 when the bound crosses the guard box |
| 0x20 | unk_20 float | default 100.0, mask 0x40, no reader found |
| 0x24 | unk_24 | mask 0x80 only |
| 0x28 | unk_28 | gameutil MotionProc* set 1/2 |
| 0x2c | program_option | 'S'; mgCVisualMDT::CreateRenderInfoPacket ORs 4 into microprogram flags |
| 0x30 | fog | 'F'+digit; nonzero enables PRIM.FGE if scene fog; 2 -> fog colour 0, 3 -> 0xffffff |
| 0x34/0x38/0x3c | unk | masks 0x800/0x1000/0x2000 only |
| 0x40 | program_mode | 'M'+digit; bit1 -> flag 8, bit2 -> flag 0x100 + extra matrix; nonzero sends eye pos in model space; Draw tests bit 2 |
| 0x44 | obj_alpha float | SetAttrParamObjAlpha; multiplies colour alphas in CreateRenderInfoPacket |
| 0x48 | no_cull | Draw: screen test only when 0; mask 0x100000 |
| 0x4c | ambient_boost | 'T'; ambient += 0.3*light0 colour |
| 0x50 | unk_50 vec4 | default (0,1,0,0), full copy only |
| 0x60 | no_light | 'C0' -> 1 (mask 0x18000 = no_light+color); renderer flag 0x20; disables point-light test |
| 0x70 | color vec4 | copied to mgRenderInfo+0x1000 in Draw; editmode writes x/z directly |
| 0x80 | point_light | Draw point-light range test |
| 0x84 | unk_84 | 'Vc'+digit; ==1 sets renderer flag 0x80 |
| 0x88 | billboard | 'BA'=1 (full), 'BY'=2 (yaw) -> GetBBoardMatrix mode |
| 0x8c | depth_bias float | 'Zp' -> 1.005 (0x3f80a3d7) or 0; >1.0 scales projection z by 1.005 |

`mgFrameAttrParam` enum = SetAttrParam mask bits (bit -> field above, see header). Order in the
code: 0x800000 is tested before 0x400000.

## Globals
- `dmy_attr` (bss 0x90, mgCFrameAttr): LOCAL in retail -> `static` in the .cpp, constructed by
  `__sinit_mg_frame_cpp`; default attributes for GetDrawRect. Not in the header.
- `at_307` (.data, {0,0,0,1}), `at_324`, `at_341`, `at_844` (bss 0x10), `at_1118`, `at_1119`:
  compiler-generated vector temporaries (initialisers for local vec4s in SetPosition/SetRotation/
  SetScale(fff), mgCFrame::SetRotation(fff), GetDrawRect).
- Local (static) functions, not in the header: QuatToMat, test1 (transforms 8 corners by two
  matrices, outputs box), test2 (perspective divide of the box), StrCmp.

## mgInsideScreen
All five return int; the chain ends in `j mgClipBoxW(max, min, info+0xee0, info+0xef0)`.
In the 4-arg forms param 3 receives vmax (max) and param 4 vmin (min). mgVu0FBOX: max at +0,
min at +0x10 (GetWorldBBox), passed to mgCreateBox8(out, box, box+0x10).

## First game
`CFrame` (frame.hpp) is the counterpart but laid out very differently: there the transform parts
live in CFrame itself, collision/bound are inline, name is a char[32]. Here the transform comes from
the mgCObject base, the bound is a separate BoundInfo, name is a pointer, frames know their
previous sibling and the model's frame list. `CFrameAttr` -> `mgCFrameAttr`: different layout
(int fields, base mgCVisualAttr holds the GS settings); name flags are mostly the same letters
but parsed after "--" instead of "__". First game `CObject` (physics) is unrelated to mgCObject;
this game's `CObject` (object unit) derives from mgCObject.

## Source notes
- Header conflict: mglib.hpp (declares `mgRenderInfo`) and mg_drawenv.hpp (defines `mgRENDER_INFO`)
  both define `mgFOG_PARAM` (fixlist item). mg_frame.cpp renames mglib's copy with a
  `#define mgFOG_PARAM mglib_mgFOG_PARAM` around its include; remove once the fixlist item is fixed.
- mgRENDER_INFO offsets checked by compile-time asserts: world_screen_rel 0x90, camera_pos 0x3A0,
  screen_box_max/min 0xEE0/0xEF0 (the box mgInsideScreen clips against).
- visual vtable slot 0x1c (RemakeBBox) is `mgCVisual::CreateBBox(max, min, matrix)`.
- GetWorldBBox: for billboards the half-extent is replaced by its largest component on all
  three axes (a cube around the centre), w=0.
- GetBBoardMatrix calls `mgDistVector(lw[0])` three times (retail passes row 0 each time), so all
  three scale factors are row 0's length. Yaw: z axis = eye-pos with y zeroed, normalised;
  x axis = (z.z, 0, -z.x). Mode bit 0 multiplies in a pitch matrix (rows 1/2: (0,h,-dy),(0,dy,h)).
  The mode-2 path contains `m[2][0]=m[2][0]; m[2][2]=m[2][2]` self-copies in retail.
  The C++ definition now computes those axes and caches the billboard matrix.
  Its inline VU0 scaling block multiplies all four rows by the derived scale,
  preserving the homogeneous component. All 123 instructions and the
  0x1ec-byte symbol match retail in objdiff (score 0).
- GetLocalMatrix scales trans_matrix component-wise by `scale` (each row times the scale vector,
  last row copied) via VU0 asm; GetLWMatrix/TopBottom multiply parent*local with one VU0 block
  that stores the product to lw_matrix and to the output. The VU0 block now
  lives in the C++ definition; its address setup uses `this+0xb0` for the
  source matrix and `this+0x30` for scale, preserving retail's register order.
  Objdiff scores all 87 instructions and the 0x15c-byte function at 100%
  (score 0).
  `GetLWMatrix` now rebuilds the cached matrix when the frame or an ancestor
  changed. Its inline VU0 block multiplies the parent world matrix by the
  local matrix and stores the product in both the cache and caller's output.
  All 94 instructions and the 0x178-byte function match retail exactly in
  objdiff (score 0). `GetLWMatrixTopBottom` uses its parent's cached matrix
  and the same VU0 multiplication sequence. Its 89 instructions and
  0x164-byte symbol also match retail exactly (score 0).
- test1/test2 are whole-asm VU0 functions. `test1` first multiplies the screen matrix by
  the supplied matrix, transforms eight corners into vf10-vf17, and writes their
  four-component bounds. `test2` reads those eight retained VU0 vectors, divides only
  their x/y components by the absolute value of w, then writes four-component bounds.
  The guarded C++ drafts preserve the intermediate vectors in a file-local array;
  they compile but differ from the hand-scheduled VU0 functions. Both functions
  are now emitted by MWCC from VU0 `asm void` source definitions. `test1` has
  81 instructions and a 0x144-byte symbol; `test2` has 49 instructions and a
  0xc4-byte symbol. Both match retail exactly in objdiff (score 0).
- mgInsideScreen(corners, matrix, max, min): hand-scheduled VU0 block (screen*matrix, transform
  8 corners, divide by |w|, max/min), then tail-calls mgClipBoxW against screen_box_max/min.
  Its inline VU0 source now matches retail exactly: keeping a local pointer to
  `mgRenderInfo` makes MWCC form `world_screen_rel` from the common base and
  reuse that base for both clip bounds. Objdiff scores all 121 instructions of
  the 0x1e4-byte function at 100% (score 0).
- The compiler emits the exact `mgCFrame`, `mgCFrameBase` and `mgCObject` vtables from the class
  definitions. The position, rotation and scale scalar overloads initialize their four-float
  vectors directly (position with homogeneous 1, rotation and scale with homogeneous 0).
- `GetWorldBBox`'s `bound` is `mgCFrame::BoundInfo *` and `GetLWMatrixTopBottom`'s `parent` is
  `mgCFrame *`; the attribute copy `*(mgVec4 *) &dst->unk_50[0] = *(mgVec4 *) &attr.unk_50[0]`
  copies a `float[4]` as one quadword.
- `at_1118` and `at_1119` are the two zero-vector templates of `GetDrawRect` and remain
  `INCLUDE_BSS` reservations: initializing ordinary zero vectors at the copy point changes 0x3E
  text bytes from `GetDrawRect+0x3c` through register allocation.

## Assembly gaps

`GetDrawRect` now compiles from C++ with an inline VU0 block. It starts with
empty bounds, transforms the visible frame's eight bound corners through the
world-to-screen matrix, divides x/y by the absolute homogeneous w, and builds
screen bounds. It rejects bounds outside the screen or behind the scissor
threshold, then merges eligible children's rectangles. Objdiff scores all
320 instructions and the 0x500-byte symbol at 100% (score 0).

`mgCFrame::Draw(u_int*)` is native C++ and byte-identical (0x3AC bytes of
code in a 0x3B0 extent). In its screen clipping path retail keeps the `test1`
output pointers in `a3`/`t0` across the call and passes them on as `test2`'s
arguments, then keeps `a0`/`a1` across `test2` for `mgClipBoxW`. MWCC does this
only when `test1` and `test2` are file-local (`static asm void`), matching their
LOCAL retail binding: it then knows their register use. With external linkage
it rematerializes both stack addresses after each call (two extra instructions).
