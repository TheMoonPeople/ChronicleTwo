# effectlist: reverse-engineering notes

## C++ draft status
All 23 functions have C++ in `ps2/src/effectlist.cpp`. 16 are exact and compiled
by the matching build. 2 more compile to retail's bytes in isolation but stay
under `NONMATCHING`. 5 differ from retail and keep the `INCLUDE_ASM` fallback.
Each function tried has its one promotion attempt recorded in
`scripts/re/promotion_attempts.tsv`.

Header: `ps2/include/effectlist.hpp`. Owns `CEffectList` and `CFadeInOut` (no vtables, no
constructors, no static members, no named globals). No first-game counterpart for either class
(nothing in `/home/adubbz/development/chronicle` matches).

Also in this unit but owned elsewhere (declare in their own headers, not here):
- `mgC3DSprite::mgC3DSprite()` (0x17E630), inline ctor emitted here (owned by `mg_sprite`).
- `CEffectManager::CreatePacket(mgC3DSprite*)` (0x17E850), owned by `effect`. Walks
  `CEffect` entries at `this+0x20` (stride 0x200, count `this+0x24`).
- `DivSpriteScreen(mgCDrawPrim&)` and `DivSpriteScreen(mgCDrawPrim&, int, int, int)` are LOCAL in
  retail (`build/re/local_symbols.tsv`) -> `static` in the `.cpp`, not in the header.

## CEffectList (size 0x18)
Size: `CMap` embeds it at +0x310 (`CMap::CreateEffect/EffectStep/DrawEffect`); `CMap::Initialize`
clears 0x310..0x324 inline (0x318 = -1) and the next CMap field is used at 0x328.

| Off | Field | Evidence |
|---|---|---|
| 0x00 | `char *name` | LoadEFPFile: Alloc((strlen+1+15)/16 qwords), strcpy. CMap passes `at_574`. |
| 0x04 | `u_int *pack` | LoadEFPFile param 2. |
| 0x08 | `int block` | LoadEFPFile param 3, passed as `block` to `mgCTextureManager::EnterIMGFile`; CMap inits -1. |
| 0x0C | `int effect_num` | GetPackFileExt(pack, "em", ...) result; loop bound everywhere. |
| 0x10 | `CEffectManager *managers` | new[] of 0x184-byte CEffectManager (ctor 0x184030). |
| 0x14 | `mgC3DSprite *sprites` | new[] of 0x50-byte mgC3DSprite (ctor 0x17E630). GetEffectVisual returns `sprites + i`. |

LoadEFPFile: GetPackFileExt(pack, "img"(at_260), files, 64, sizes, names) -> EnterIMGFile each into
`block`; then "em" (at_261) files -> per file: DivPathNameExt(name, dir, base, ext),
GetBufferNums -> new[] CEffect (0x200, ctor 0x180C80) and CEffectCtrl (0x310, ctor 0x1816E0 /
dtor 0x181710), EntryEffCtrls, Initialize, Load, strcpy(manager (offset 0 = name), base), Run.
Arrays use `operator new[](size, u_long128*)` with `mgCMemory::Alloc(qwords + 2)` (array cookie).
SaerchEffectIndex (retail spelling) strcmps against the manager's name at offset 0.

## CFadeInOut (size 0x30)
Size: global instance at 0x01DFDDA0 in `__sinit_mainloop_cpp` followed by SCN_LOADMAP_INFO2 at
+0x38 (upper bound); embedded in `CScene` at +0x2C70; `CScene+0x2C9C` (= +0x2C) is written by
`_SET_MOTION_BLUR`, and `CScene+0x2CA0` is an unrelated scene field (map BG load step), so
the class ends at 0x30.

| Off | Field | Evidence |
|---|---|---|
| 0x00/04/08 | `float r, g, b` | FadeIn/FadeOut params; Draw passes ftoi to Color. |
| 0x0C | `float alpha` | 0..128; FadeStep +/- speed, clamps to 128.0/0.0; Draw skips when <= 0. |
| 0x10 | `int mode` | FadeMode: FadeIn sets 1, FadeOut -1, FadeStep sets 0 when fade-in reaches 0. NowFade = mode != 0. |
| 0x14 | `int end` | FadeStep sets 1 at the end; FadeCheck returns it. |
| 0x18 | `float speed` | 128.0 / frames, or 0 when frames < 0. |
| 0x1C | `int cross_type` | CrossFadeIn/Out param 1; Draw: == 1 wipe, else dissolve. CrossFade passes 0. |
| 0x20 | `int cross` | Set 1 by CrossFadeIn/Out, 0 by FadeIn/FadeOut/ResetFade/Initialize; Draw branches on it. |
| 0x24 | `float cross_alpha_rate` | CrossFade* param 3 (scripts pass 1.0); Draw dissolve alpha = alpha * rate. |
| 0x28 | `mgCTexture *cross_texture` | SetCrossTexture; CaptureScreen does mgStoreImage(backbuffer, tex->image[0]) (mgCTexture+0x50 = image[0]); Draw reloads it via `ReloadTexture(tex->block)` after clearing bit 2 of byte 0x3C (inside tex0). |
| 0x2C | `int blur_alpha` | `_SET_MOTION_BLUR`; Draw draws the back buffer over the screen with alpha = this when non-zero. |

Enums (in header):
- `FadeMode`: -1 out, 0 none, 1 in (FadeIn/FadeOut/FadeStep).
- `CrossFadeType`: 0 dissolve, 1 wipe (Draw at 0x17F310; values come from scripts via `_SET_CROSSFADE`).

Behaviour notes:
- FadeIn(int): mode < 0 -> FadeIn(frames, r, g, b) (current colour), else FadeIn(frames, 0, 0, 0).
- CrossFadeIn/Out call FadeIn/FadeOut(frames, 128, 128, 128) then set cross=1, rate; CrossFadeOut
  also forces alpha = 0.
- FadeStep: end && cross && cross_type == 1 -> alpha = 0 (wipe finished).
- Draw wipe: mode < 1 -> DivSpriteScreen(prim, alpha/128*W, W, 1), else (prim, 0, alpha/128*W, 0).
  The 4-arg DivSpriteScreen draws 17 rows of sprites (height H/16) between x0 and x1 with
  the edge selected by arg 4 offset alternately by the two ints at `at_589` (jagged edge).
  The 1-arg DivSpriteScreen tiles the whole screen in 64x32 sprites.
- Draw uses `Direct(0x3B, ...)` (TEXA) and mgCDrawPrim on the stack (0x120 bytes).

## Return types / ambiguities
- `NowFade` returns `mode != 0` (sltu); declared `int`, could equally be `bool`.
- `FadeCheck`, `FadeStep` declared `int` (callers in menusys/event ignore or test it).
- `FadeCheck` returns the `end` field at +0x14 directly; its C++ getter matches and
  links into a byte-identical game image.
- `SetCrossTexture` retail symbol is truncated (`...FP10mgCTextureP1`); second param is
  `u_long128 *` by the same convention as `mgStoreImage__FP10mgCTextureP1` in `mglib.hpp`
  (callers pass `CrossFadeBuff` / `BuffReadData + 0x200000`). `draft.sh` will confirm when written.
- Data: `at_392/at_393` (CEffectManager::CreatePacket sprite size/colour init), `at_564__2..at_566`,
  `at_586..at_589` (DivSpriteScreen vertex templates / jag offsets) are compiler literals.
