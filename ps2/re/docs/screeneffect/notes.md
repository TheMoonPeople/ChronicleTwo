# screeneffect: header notes

The unit owns no classes (`class_units.tsv` has none). It holds two global, non-member functions
and four compiler-generated `.sbss` literals (`at_205`, `at_206`, `at_283__2`, `at_292__2`, all
local), so the header has no `extern` data. They are the native zero
templates for the depth, alpha, texture-pointer and radius arrays in the
matched function bodies; no assembly data markers remain.

## DepthOfField(int levels, float *depths, mgCTexture *work_texture, float strength) -- 0x17F760
- Callers: `EditDraw__Fv` (editloop) passes `(1 or 2, float[1|2] literal, texture got by name from
  bank 0x9C, 1.0f)`; `DngMainDraw__Fv` (dng_main) passes `(1 or 2, ..., TEX_ShadowTexture, 1.0f)`.
- Returns at once when `work_texture` is null. Copies the `mgCTexture` descriptor at
  `work_texture` field by field into a stack `mgCTexture` (0x6C+ bytes copied: halfwords 0..6,
  32 bytes at 0x8, words 0x28..0x30, dwords 0x38..0x48, words 0x50..0x68) -- this is a struct copy
  (`mgCTexture tex = *work_texture;` after constructing it, or a copy-assignment); then
  `Bilinear(1)` and clears bit 34 of the 64-bit field at 0x38 (a TEX0/TEX1 register field).
- Frame buffer got with `mgGetFrameBuffer(&fb)`. Per level i: `mgSetPkMoveImage` from the source
  (frame buffer first, then the work texture) into a half-size rect of the work texture, then a
  strip primitive (`Begin(4)`) of 16 columns with `Direct(0x3B, 0x8000000080)` (TEXA), colour
  (0x80,0x80,0x80, alpha), Z alternating between `mgTransZPrim(depths[i])` and
  `mgTransZPrim(depths[i] + depths[i]/10)` (two-int stack array indexed by a toggled parity bit).
  Alpha = `(int)(strength * 128)` / `(int)(strength * 32)` (two-int array, only [0] used in colour).
- Rects shrink each level: width/height become 2/3 of the previous.
- A stack `mgCSprite` is constructed (vtables mgCVisual -> mgCVisualPrim -> mgCSprite visible
  inline), after construction only its fields +0x10 = 1 and +0x14 = -1 are set; it is otherwise unused (likely an unused local whose constructor was inlined).
- First game: `DepthOfField(float *focus, int level, int alpha, int blur)` in effectmacro; a
  different signature and implementation.

## LensFlare(int *screen, float *color, int bank, char *texture_a, char *texture_b) -- 0x17FEA0
- Only caller: `CScene::DrawLensFlare(int, char*, char*)` (sceneevent), which gets the sun
  position, `mgTransWorldScreen(int screen[2], float pos[3])`, puts `mgTransZPrim(10000.0f)` in
  screen[2], builds colour float[4] (RGB from the map's flare lighting ratio, A = constant), and
  forwards its bank and two texture names.
- `screen[0..1]`: screen position in 1/16 pixel (divided by 16, compared with half the screen
  size); `screen[2]`: Z buffer value used as the depth of an occlusion quad.
- Does nothing when the distance from screen centre exceeds `mgScreenWidth`. Reloads texture bank
  `bank`, gets `texture_a` and `texture_b` from it via `mgTexManager.GetTexture(name, bank)`; returns
  if either is null. Renders occlusion into texture_a, shrinks to 1/3 size into texture_b, then
  4 ping-pong additive blur passes between the two (array `mgCTexture *tex[2]`), a 24-point star
  fan (radius alternating between two values, step pi/12), and finally composites onto the frame
  buffer (`mgSetPkFrameBuffer(-1,-1,-1,-1)`) with colour `color[0..2]`, alpha
  `color[3] * f * f * 0.7`, where `f = min(1, 1 - distance / mgScreenWidth)`.
- `mgCDrawPrim` primitive types used: 4 (strip), 5 (fan), 6 (sprite). Alpha blend modes 2, 3, 5.
  No enum for these exists yet in `mg_drawprim.hpp`; worth adding when bodies are written.
- First game: `LensFlare(CTexture*, float*, u8, u8, u8)` in mglib; different signature.

## Parameter names
`levels`, `depths`, `work_texture`, `strength`, `screen`, `color`, `bank`, `texture_a`,
`texture_b` are descriptive, from usage above; no retail parameter names exist.

## Draft status
- Both functions now have named, typed C++ implementations under `NONMATCHING`, with the retail assembly retained in normal builds. The bodies follow the m2c control flow and the previously analysed rendering sequence. Both remain guarded after their one permitted isolated promotion attempt.
- `DepthOfField` uses `mgCTexture::tex0.bits.tcc` for the single cleared GS TEX0 bit, and `mgRect<int>` for all rectangles. Its per-level strip alternates the two depth values and shrinks the target rectangle to two thirds for the next level.
- `LensFlare` first draws two full-screen sprites into the first work texture to measure light visibility with the depth buffer. It then downsamples into the second texture, executes four alternating additive blur passes, draws the star fan over the first work texture, and composites the last blur into the active frame buffer.
- The star fan loop increments the angle by 0.2617994 radians until it reaches 6.2831855 radians, then explicitly closes the fan. The radii alternate between `(width/3 + height/3) * 6` and that value minus `width/3` in sixteenth-pixel coordinates.
- `LensFlare` compiled and linked in its isolated trial, but the resulting game image differed from retail, so it was not promoted. `DepthOfField` compiled with MWCC, but the `mwccgap` ELF parser failed while processing the generated object (`IndexError` in `Elf.__init__`). The draft checker encounters the same error when it compiles both functions together; the object contains additional weak and virtual text sections from the inline `mgCSprite` constructor. This is a tooling limitation, not a claim that the function matches.
