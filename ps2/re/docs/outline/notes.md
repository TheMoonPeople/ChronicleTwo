# outline: reverse-engineering notes

Unit owns one class, `COutLineDraw` (4 members, all in this unit). No first-game counterpart
(Dark Cloud has no outline unit). No vtable. No named globals: the unit's data are all
compiler-generated (`at_299__2`, `at_300__2`, `at_325`, `at_395`, `at_396`, `at_398`, `at_399`
in .bss; `at_338` in .data = `{0x80, 0x80, 0x80, 0}` int RGBA used as the composite colour in
`Draw(float, float)`). The matched local initializers supply these templates;
no assembly data markers remain. The globals `outline_flag`, `outline_start`, `outline_start_tex`,
`outline_tex_id` are LOCAL to `character` (used by `_OUTLINE`), not this unit.

## COutLineDraw (size 0x70)
Size: `__nw__FUiP1(0x70, ...)` in `_OUTLINE__FP9SPI_STACKi` and
`CCharacter2::Copy(CCharacter2&, mgCMemory*)`. 0x04-0x0F and 0x68-0x6F are alignment padding
(the box at 0x10 and the vectors are 16-aligned); `Copy`'s member-wise copy skips exactly these.

| off | field | evidence |
|-----|-------|----------|
| 0x00 | `COutLineDraw *next` | list link walked by `CCharacter2::AddOutLine`, `CopyOutLine`, `DrawDirect`; head kept at `CCharacter2+0x124` |
| 0x10 | `mgVu0FBOX unk_10` | `Initialize` zeroes 0x10 and 0x20 with `mgZeroVector`; `Copy` copies it with `mgVu0FBOX::operator=`. Never read anywhere. |
| 0x30 | `mgCTexture *texture` | `_OUTLINE` stores the `mgCTextureManager::EnterTexture` result (screen-sized, block `set_imgblock`); `Draw` reads `tex0` (u16 at +0x38) `& 0x3fff >> 5` as FBP for `mgSetPkFrameBuffer` (render target). `CopyOutLine` shares it between characters. |
| 0x34 | `mgCFrame *frame` | `SetFrame`; `Draw` passes to `mgDrawDirect`, `mgGetDrawRect`, `SetAttrParamObjAlpha`. |
| 0x38 | `float width` | `_OUTLINE` stores the script's float arg. `Draw`: `<= 0` -> plain draw; else `w = width*scale*scale`, `(int)(w*16)` is the ±offset passed to `DrawDivSprite4` (1/16-pixel units). |
| 0x3C | `int depth_from_pos` | if non-zero, `Draw` sets `pos[3]=1`, calls `mgTransWorldPrim(screen, pos)`; on success `ZMask(1)` and screen z is the composite's Z. |
| 0x40 | `sceVu0FVECTOR pos` | `Draw(float*,...)` does lq/sq copy (quad, 16-aligned). Caller passes `CCharacter2+0x10`. |
| 0x50 | `sceVu0FVECTOR color` | init 80.0, 60.0, 0.0, 128.0; `Draw` converts [0..2] with fptosi as edge RGB; [3] unused (alpha computed as `w_clamped*128*alpha`). |
| 0x60 | `int enable` | init 1; `Draw` returns 0 immediately when zero. |
| 0x64 | `int hide_edge` | init 0; the edge (`DrawDivSprite4`) is drawn only when zero (and alpha >= 1, offset > 0, clamped w >= 0.1). |

Inline constructor (not emitted): both `new` sites store `next = 0` then call `Initialize()`;
declared in the header as `COutLineDraw() { next = NULL; Initialize(); }`. `_OUTLINE` then calls
`Initialize()` again explicitly. `CCharacter2::DrawDirect` builds a stack copy (copy of 0x10..0x67,
`next = 0`, `SetFrame(lod frame)`), i.e. the implicit copy constructor.

## Functions
- `Draw(float *pos, float scale, float alpha)`: copies pos to 0x40, tail-calls `Draw(scale, alpha)`.
  Return int (sum accumulated in `DrawDirect`). `scale` = distance fade from `DrawDirect`
  (`1 - (z-10)/300`, clamped), clamped to <= 1 in `Draw`; `alpha` = character alpha.
- `Draw(float, float)`: clears a rect (screen bbox ±8px) of the off-screen texture via a
  `mgCDrawPrim` sprite with colour 0, draws the frame into it (`mgDrawDirect`), restores the frame
  buffer, then composites with `DrawDivSprite4` (edge, colour = `color`) and `DrawDivSprite`
  (body, colour `at_338`). Ends with `Direct(0x3f, 0)` (TEXFLUSH). Stack holds two `mgCDrawPrim`
  (0x120 each) and one `mgCTexture` filled by `mgGetFrameBuffer`.
- `DrawDivSprite` / `DrawDivSprite4` are LOCAL (static) in retail: belong in the .cpp, not the header.
  - `DrawDivSprite(mgCDrawPrim *prim, mgRect<int> rect, mgCTexture *tex, int *color, int dx, int dy, int z, int)`:
    sprites in 0x200-wide (32px) columns, height `mgScreenHeight*16`; UV = rect, XYZ = rect +
    screen offset*16 + (dx,dy), Z = z. Last parameter is never read (caller passes 0).
    `BeginPrim2(6, 0x43, 0, 2)`; 4 qwords per sprite via `DirectData(4)`.
  - `DrawDivSprite4(mgCDrawPrim *prim, mgRect<int> rect, mgCTexture *tex, int *color, int offset, int z)`:
    32x32px tiles (rounded to 0x200 boundaries), four sprites per tile shifted by +x, -x, +y, -y
    `offset`; constant qword halves come from `at_395/396/398/399` (bss, zero). `DirectData(0x10)`.

## Current source status

All four functions and their compiler-generated initializer data are native
C++ and the complete object matches retail. `Draw(float*, float, float)`
copies the world position before delegating. `Draw(float, float)` handles
empty or disabled cases, clears the projected rectangle in the off-screen
texture, draws the frame, then composites four edge directions and the body.
The two local helpers divide the source rectangle into sprites at tile
boundaries.
