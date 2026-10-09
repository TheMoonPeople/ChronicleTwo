# mg_drawenv: reverse-engineering notes

Header: `ps2/include/mg_drawenv.hpp`. Owned classes (class_units.tsv): `mgCDrawEnv` (0x40),
`mgRENDER_INFO` (0x1020), `mgVu0FBOX` (0x20). Unowned structs declared here: `mgPOINT_LIGHT`
(0x30), `mgLIGHT_INFO` (0x150), `mgFOG_PARAM` (0x30). Enums: `mgAlphaMacroID`, `mgZBufMode`.
No first-game counterpart: the first game has no mgRENDER_INFO/mgCDrawEnv/mgVu0FBOX.
No virtual functions, no vtables. No unit globals: the only data symbol is `at_184` (0x18 bytes,
.rodata) = the jump table of SetAlpha's `switch` (cases 1..5).

The one global instance is `mgRenderInfo` (mglib, 0x00397040, symbol size 0x1020, cleared with
`memset(&mgRenderInfo, 0, 0x1020)` in `mgInit__Fii`). Many offsets below come from mglib/mg_frame
code that addresses it as `DAT_<0x397040 + off>`.

## mgCDrawEnv (0x40) -- GIF A+D packet of three GS registers
`operator=` copies four qwords (lq/sq): size 0x40. `__sinit_mglib_cpp` constructs the
`draw_env[2]` array with stride 0x40. Initialize(int context):
| Off | Field | Evidence |
|---|---|---|
| 0x00 | `sceGifTag giftag` | u64 zeroed, NLOOP(15 bits)=3, EOP(bit 15)=1, NREG(byte 7 high nibble)=1, REGS0(byte 8 low nibble)=0xE (A+D) |
| 0x10 | `sceGsTest test` | = 0x5000B: ATE=1, ATST=5 (GEQUAL), ZTE=1, ZTST=2 (GEQUAL). mg_visual SetDrawEnv(GifTag) edits AREF (u16 at 0x10 bits 4..11), ATE/ATST (byte 0x10), AFAIL bits 1..2 of byte 0x12, DATE/DATM bits 6/7 of byte 0x11 |
| 0x18 | `u_long test_addr` | 0x47 (TEST_1) for context 0, else 0x48 (TEST_2) |
| 0x20 | `sceGsZbuf zbuf` | Initialize leaves it 0 (not written); SetZBuf edits bit 0 of byte 0x24 = ZMSK |
| 0x28 | `u_long zbuf_addr` | 0x4E (ZBUF_1) / 0x4F (ZBUF_2) |
| 0x30 | `sceGsAlpha alpha` | = 0x44; SetAlpha rewrites the whole u64; GetAlphaMacroID compares it |
| 0x38 | `u_long alpha_addr` | 0x42 (ALPHA_1) / 0x43 (ALPHA_2) |

Note: Initialize writes 0x00 as a u64 0 then bitfields; it does not write 0x20 (zbuf). mglib's
`mgInit` copies `mgZBUF_1`/`mgZBUF_2` into mgRenderInfo+0xF40 / +0xF80 (draw_env[0/1].zbuf).
The constructor is `mgCDrawEnv() { Initialize(0); }` but is NOT inline (symbol in this unit).
`operator=(mgCDrawEnv&)` takes a non-const reference, so it is user-declared (not generated); its
body copies four 128-bit quadwords with lq/sq.

### SetAlpha(int) values (`mgAlphaMacroID`)
| mode | ALPHA value | equation |
|---|---|---|
| 1 BLEND | 0x44 | A=Cs B=Cd C=As D=Cd |
| 2 ADD | 0x48 | A=Cs B=0 C=As D=Cd |
| 3 SUB | 0x42 | A=0 B=Cs C=As D=Cd |
| 4 OPAQUE | 0x80_0000002A | A=0 B=0 C=FIX D=Cs, FIX=0x80 |
| 5 ADD_FIX | 0x80_00000068 | A=Cs B=0 C=FIX D=Cd, FIX=0x80 |
Other values: no change. GetAlphaMacroID maps 0x44->1, 0x48->2, 0x42->3, 0x800000002A->4, anything
else (including mode 5's value) -> 0. The names of the enum and its values are descriptive, not
retail.

### SetZBuf(int) (`mgZBufMode`)
-1 -> ZMSK=1 (no depth write); 1 -> ZMSK=0; anything else unchanged. Callers pass
`mgCVisualAttr+0x8` (default 1).

## mgVu0FBOX (0x20)
`operator=(mgVu0FBOX&)` copies two qwords. `mgBoxMaxMin(mgVu0FBOX*, mgVu0FBOX*)` (mg_math) stores
vmax at 0x00 and vmini at 0x10 -> `max`, `min`. Non-const-ref operator= is user-declared and
non-inline (emitted only here, called from many units).

## mgPOINT_LIGHT (0x30)
Get/SetPlight copy 10 words 0x00..0x24 to/from light_info.point_light[i] (stride 0x30).
SetPlight(int, float*, float*, float, float) builds one on the stack: pos (CopyVector) at sp+0x50,
color at sp+0x60, two floats at sp+0x70/0x74 -> two sceVu0FVECTORs + two floats, size 0x30 by
alignment.
- 0x20 `power`: SetPlight(i, NULL) writes 0 here to switch the light off; mgCFrame::Draw only
  tests lights with `power > 0`.
- 0x24 `range`: if `<= 0`, SetPlight stores `power * sqrtf(max(color.r, color.g, color.b))`.
  mgCFrame::Draw: light reaches object when `dist(light.pos, obj) < radius*scale + range`.
- SetPlight forces stored pos.w (0x0C) = 1.0f. Index must be 0..3.

## mgLIGHT_INFO (0x150) -- name not retail
Name derived from `mgRENDER_INFO::GetpLightInfo` (returns `this + 0x400 + active_light * 0x150`).
memset size 0x150 in InitActiveLighting/InitLighting (8 setups).
| Off | Field | Evidence |
|---|---|---|
| 0x00 | `light_dir` FMATRIX | SetLight(int i,dir,col) writes column i (0x00+4i, 0x10+4i, 0x20+4i; row 3 col i = 0); SetLight(m,m) copies and zeroes 0x30..0x3C |
| 0x40 | `light_color` FMATRIX | SetLight(int) writes row i (0x40+0x10i .. +0xC = 0); SetLight(m,m) zeroes 0x4C/0x5C/0x6C/0x7C |
| 0x80 | `ambient` FVECTOR | Set/GetAmbient CopyVector |
| 0x90 | `point_light[4]` | stride 0x30 |
ActiveLighting's copy copies 0x00..0x7F with 8-byte ld/sd loops (8 iterations x2), ambient with
4 lwc1/swc1, and 0x90..0x14F with lq/sq (6 iterations of 0x20): looks like a member-wise struct
copy `light_info[new] = light_info[old]`.

## mgFOG_PARAM (0x30) -- embedded in mgRENDER_INFO at 0xFD0
Layout from `mgSetFogParam(mgFOG_PARAM*)` (reads 0x0, 0x4, bytes 8/9/10, 0x10, 0x14 and calls
SetFogParam) and `mgGetFogParam(mgFOG_PARAM*)` (copies mgRenderInfo+0xFD0.. into it, skipping 0x1C
-> 0x1C is alignment padding before the 16-aligned vector at 0x20).
SetFogParam(n, f, r, g, b, A, B): 0x0=n, 0x4=f, 0x8..0xA=r,g,b, 0x10=A, 0x14=B,
0x0C = (A + B + (A-B)(f+n)/(f-n)) / 2, 0x18 = -f*n*(A-B)/(f-n), 0x20..0x2C = copy of 0x0C..0x18.
With fog(z) = c0C + c18/z, fog(n) = B and fog(f) = A, hence `far_value` = A (0x10),
`near_value` = B (0x14), `offset` (0x0C), `scale` (0x18). This reading assumes the VU computes
`offset + scale/z`; the arithmetic itself is exact. Byte 0x0B (`unk_b`) is copied by
mgGetFogParam but never written. Consumers: mgFlushRenderInfo sends 0x0C..0x18 to VU1 address
0x3B; CWater sends 0x20..0x2C (`coef`); mgC3DSprite sends 0x0C..0x18; MDT packets read
the colour as 3 bytes at 0x08.

## mgRENDER_INFO (0x1020)
Size: symbol `mgRenderInfo` size 0x1020 and `memset(&mgRenderInfo, 0, 0x1020)`.
No constructor of its own: `__sinit_mglib_cpp` runs `mgCDrawEnv()` over 0xF20..0xFA0 (the
compiler-generated constructor, inlined).
mgMulMatrix(out, a, b) argument order below is as called.
| Off | Field | Evidence |
|---|---|---|
| 0x000 | `projection` float | SetRenderInfo arg0 stored if > 0; mgGetProjection returns it; used as [0][0]/[1][1] of `screen` |
| 0x004 | (alignment padding) | |
| 0x010 | `world_screen` | SetViewMatrix: Mul(0x10, screen, world_view); mgTransWorldPrim(3DSprite), MDT packet |
| 0x050 | `view_screen` | Mul(0x50, screen, aspect); mgTransViewPrim; 3DSprite packet |
| 0x090 | `world_screen_rel` | Mul(0x90, screen with [2][0],[2][1] zeroed (no 2048 centre), world_view); mgInsideScreen, mgCFrame::Draw test1, mgConvZBuffToDist uses [2][2]/[3][2] (0xB8, 0xC8) |
| 0x0D0 | `aspect` | SetRenderInfo: unit, [1][1] (0xE4) = arg6 (= 2096/(3*width) from mgSetRenderInfo) |
| 0x110 | `screen` | SetRenderInfo: unit with [0][0]=[1][1]=projection, [2][2]/[3][2] depth terms, [2][0]=[2][1]=2048 (centre added in proportion to depth), [2][3]=1, [3][3]=0 |
| 0x150 | `world_view` | Mul(0x150, aspect, view) |
| 0x190 | `unk_190` | never accessed in any decompiled function |
| 0x1A0 | `view` | SetViewMatrix copies arg; mgSetProjection passes &0x1A0, &0x3A0 back in |
| 0x1E0 | `view_clip` | SetRenderInfo: Mul(0x1E0, proj(near/(near*0.55w/projection), ...), aspect) |
| 0x220 | `world_clip` | Mul(0x220, view_clip, view); MDT sends it when `scissor` |
| 0x260 | `clip_screen` | unit, [0][0], [1][1] scale, 0x288/0x298 z range from zdepth, 0x290/0x294 = 2048, 0x29C = 1 |
| 0x2A0 | `view_clip_full` | as 0x1E0 but with 2047 instead of 0.55*w/h; shadow pass |
| 0x2E0 | `clip_screen_full` | copy of 0x260 with [0][0]=[1][1] from 2047; shadow pass |
| 0x320 | `shadow_plane_pos` | SetDropShadowMatrix arg1 -> mgShadowMatrix arg3 (plane point) |
| 0x330 | `shadow_plane_normal` | arg2 -> mgShadowMatrix arg4 (dot-producted, plane normal) |
| 0x340 | `shadow` | mgShadowMatrix output; mgCShadowMDT packet |
| 0x380 | `unk_380` | never accessed |
| 0x390 | `shadow_light_dir` | arg0 -> mgShadowMatrix arg2 (normalised light direction); mgCShadowMDT sends xyz |
| 0x3A0 | `camera_pos` | SetViewMatrix arg1, w=1; mgGetCameraPos; GetBBoardMatrix; MDT |
| 0x3B0 | `camera_pose` | SetViewMatrix: Transpose(view), row 3 = camera_pos, column 3 = (0,0,0,1); mgGetCameraPose |
| 0x3F0 | `light_changed` int | set to 1 by every lighting setter, Initialize |
| 0x3F4 | `active_light` int | 0..7, ActiveLighting/GetpLightInfo |
| 0x3F8 | (alignment padding) | |
| 0x400 | `light_info[8]` | stride 0x150, InitLighting loops 8 |
| 0xE80 | `clip_min` | (0, 0, near, -); 0xE88 = near (mgSetProjection, mgCFrame::Draw) |
| 0xE90 | `clip_max` | (4095.9, 4095.9, far, -); 0xE98 = far |
| 0xEA0 | `guard_max` | (2048+0.55w, 2048+0.55h, 0, far); mgFlushRenderInfo sends 0xEA0/0xEB0 to VU1 0x39; DrawFirePowder temporarily sets 0xEAC=600 |
| 0xEB0 | `guard_min` | (2048-0.55w, 2048-0.55h, 0, near) |
| 0xEC0 | `full_max` | (4095, 4095, 0, far); shadow packet |
| 0xED0 | `full_min` | (1, 1, 0, near); shadow packet |
| 0xEE0 | `screen_box_max` | (w/2, h/2, 0, far); mgClipBoxW in mgCFrame::Draw / mgInsideScreen |
| 0xEF0 | `screen_box_min` | (-w/2, -h/2, 0, near) (computed as `(-w)/2` with C truncation) |
| 0xF00 | `gs_box_max` | (2047, 2047, 0, far); mgClipInBoxW in mgCFrame::Draw |
| 0xF10 | `gs_box_min` | (-2047, -2047, 0, near) |
| 0xF20 | `draw_env[2]` | Initialize: draw_env[0].Initialize(0), [1].Initialize(1); mgGetpDrawEnv(i) = &draw_env[i != 0]; MDT/sprite default env |
| 0xFA0 | `all_scissor` int | mgSetAllScissorFlag; ORed into `scissor` in mgCFrame::Draw |
| 0xFA4 | `fog_enable` | FogEnable/GetFogEnable; MDT fog bit when attr+0x30 != 0 |
| 0xFA8 | `plight_enable` | PlightEnable/Get; mgCFrame::Draw tests it before checking point lights |
| 0xFAC | `unk_fac` int | Initialize = 1; MDT: point lights only when non-zero, flag 0x20 when zero. No other writer |
| 0xFB0 | `unk_fb0[4]` | read as one quadword into mgCShadowMDT/mgC3DSprite/CWater packets; no writer found |
| 0xFC0 | `clip` int | mgCFrame::Draw: 1 when mgClipBoxW(.., screen_box) != 0 (visible) and mgClipInBoxW(.., gs_box) == 0 (not wholly inside); else 0 |
| 0xFC4 | `scissor` int | mgCFrame::Draw: when clip is set, attr+0x1C != 0 (| all_scissor unless attr+0x40 & 2), else 0; sprite/water packets clear it |
| 0xFC8 | `plight_hit` int | mgCFrame::Draw: 1 when a point light reaches the object |
| 0xFCC | `attr` mgCFrameAttr* | mgCFrame::Draw stores mgCFrame+0xF4 (mgCFrameAttr, 0x90 bytes, memset in mgCFrameAttr::Initialize; starts with an mgCVisualAttr) |
| 0xFD0 | `fog` mgFOG_PARAM | see above |
| 0x1000 | `object_color` FVECTOR | mgCFrame::Draw copies attr+0x70 (default 128,128,128,128); MDT sends it |
| 0x1010 | `motion` int | mgCVisualMotionMDT::CreateRenderInfoPacket sets 1 around the MDT call; MDT flag 0x40 |
| 0x1014 | (alignment padding to 0x1020) | |

SetRenderInfo(projection, width, height, near, far, zdepth, aspect_y): zdepth == 16 selects a
z range of 65000, otherwise 1.67e7 (24/32-bit). near/far < 0 keep 0xE88/0xE98. Ends by calling
SetViewMatrix(view, camera_pos) with its own members. The m2c output shows `mula.s`/`msub.s` --
read the Ghidra version for that arithmetic.

## Return types
ActiveLighting returns the previous `active_light` (or the current one when the index is out of
range / unchanged). GetpLightInfo returns `mgLIGHT_INFO*`. GetFogEnable/GetPlightEnable/
GetAlphaMacroID return int. Everything else is void (m2c shows no use of v0).

## Unresolved
- `unk_190`, `unk_380`, `unk_fb0`, `unk_fac`, `mgFOG_PARAM::unk_b` meanings.
- `mgLIGHT_INFO`, enum names: not retail.
- How a user-written `operator=` emits the qword copies (mgCDrawEnv, mgVu0FBOX).

## Source status
All 28 functions are native C++ and byte-identical; the unit has no guarded drafts,
`INCLUDE_ASM` entries or data markers. `SetAlpha`'s blend-mode switch emits its six-word
branch table from the C++ `switch`.
- `mgRENDER_INFO::GetPlight`: `(mgPOINT_LIGHT *) (index * 0x30 + (int) GetpLightInfo() + 0x90)`
  keeps retail's index-first `addu`; `&GetpLightInfo()->point_light[index]` adds the base first.
- `screen` matrix: the 2048 screen centre sits in [2][0]/[2][1] (SetViewMatrix zeroes those two for
  `world_screen_rel`), not [3][0]/[3][1]; `clip_screen` does have it in [3][0]/[3][1].
- `light_changed` is set by Initialize, ActiveLighting, InitActiveLighting, InitLighting and both
  SetLight overloads; NOT by SetAmbient, SetPlight or SetViewMatrix.
- MWCC does not see the anonymous-struct bitfields of the SDK GS register unions (`zbuf.ZMSK` is an
  undefined identifier): use `.bits.<lower-case>` or `.value`.
- Added to `sce/libgraph.h`: `SCE_GS_TEST_2`, `SCE_GS_ZBUF_2`, `SCE_GS_ALPHA_2`, `SCE_GS_GEQUAL`,
  `SCE_GS_ALPHA_{CS,CD,ZERO,AS,AD,FIX}`, `SCE_GS_SET_TEST`, `SCE_GS_SET_ALPHA`.
- fixlist "mgFOG_PARAM declared in both mglib.hpp and mg_drawenv.hpp": not fixed (mglib.hpp is not
  this unit's). mglib.hpp only needs a pointer to it, so its copy should become a forward
  declaration (or `#include "mg_drawenv.hpp"`); mglib's field names (near_z/far_z/fog_a/...) are
  equally non-retail.
