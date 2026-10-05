# wavetable: reverse-engineering notes

## C++ draft status
All five functions have typed C++ drafts in `ps2/src/wavetable.cpp`. Each draft
compiles with MWCC. The destructor's isolated object code matches the retail
function, but promotion cannot link while its vtable is supplied as assembly
data. The other four drafts differ from retail, so all five retain the
`INCLUDE_ASM` fallback in the matching build. Each received one promotion
attempt, recorded in `scripts/re/promotion_attempts.tsv`.

## CWaveTable (size 0x1208)
No counterpart in the first game's headers.

Size: `operator new(0x1208, ...)` in `TitleBootInit__Fv` (title); the globals `WaveTable`
(editloop, 0x1EC97B0) and `WaveTable__2` (dng_main, 0x1EE5260) are 0x1208 bytes each and are
constructed in `__sinit_*` with `__register_global_object(..., __dt__10CWaveTableFv, ...)`.
`WaveTable__3` (title, 0x37DFE8) is a `CWaveTable *`. These globals belong to those units.

| Offset | Field | Evidence |
|---|---|---|
| 0x0000 | `float height[2][24][24]` | ctor zeroes 24 rows x 24 cols at `+0` and `+0x900` (row stride 0x60, buffer stride 0x900); every other function indexes `this + current*0x900 + row*0x60 + col*4` with `lwc1` |
| 0x1200 | `int current` | ctor sets 0; `GetEffect` flips `current = 1 - current` after `Effect()` |
| 0x1204 | vtable pointer | ctor/dtor store `__vt__10CWaveTable` here (MWCC puts the vptr after the data members of the first polymorphic class) |

Vtable `__vt__10CWaveTable` (0x37BC38, size 0xC): `{0, 0, __dt__10CWaveTableFv}` -- only the
virtual destructor.

## Function behaviour
- `CWaveTable()`: zeroes both height fields, `current = 0`. Inner loop unrolled by 8.
- `~CWaveTable()`: standard MWCC dtor (`short` delete flag, `operator delete` when > 0).
- `GetEffect()`: function-local statics `cnt_302` (int) / `init_303` (1-byte guard) at 0x37D208/
  0x37D20C. When `cnt == 0`, four times: `height[current][rand()%22+1][rand()%22+1] +=
  (rand()/2147483648.0f - 0.5f) * 0.04f` (first rand gives the column, second the row). Then
  `cnt++`, reset to 0 when `> 4` (so disturbances every 5th call). Then `Effect()`, then flip
  `current`. Returns void (callers ignore any result).
- `Effect()`: `prev = 1 - current`. For rows 1..22, cols 1..22:
  `h[prev][r][c] = (h[cur][r-1][c] + h[cur][r+1][c] + h[cur][r][c-1] + h[cur][r][c+1]) * 0.0196f
  + (h[cur][r][c] * 1.9216f - h[prev][r][c]) - (h[cur][r][c] - h[prev][r][c]) * 0.0015f`.
  Then for rows 1..22, `h[prev][r][1] = h[prev][r][22] = (both) * 0.5f` (horizontal seam).
  Both loops unrolled by 8 in retail.
- `CreateTexture(mgCTexture *tex)`: returns early if `tex == NULL` or `tex->bpp <= 23` (bpp at
  +6, `short`). `mgSetPkFrameBuffer(tex)`; local `mgCDrawPrim` (0x120 bytes on stack),
  `Initialize(NULL, NULL)`, `DepthTestEnable(0)`, `ZMask(-1)`, `Shading(1)`,
  `AlphaBlendEnable(1)`. Cell size `width/23.0f`, `height/23.0f`; origin
  `(float)mgScreenOffx/Offy`. `Begin2()`; 23 rows (r = 0..22), each `BeginPrim2(4, 0x4141, 0, 4)`
  (triangle strip), 24 columns (c = 0..23, column index clamped `c > 22 -> 0`). Per column two
  vertices: intensity `I = clamp((h[cur][r][c] - h[cur][r][(c+1)%24]) * 540 + 40, 0, 200)`, colour
  `{I, I, I, 96.0}` via `Data0`, position via `Data4`; second vertex uses row `(r+1)%24` and
  y + cell height. Colour vectors come from the literals `at_251`/`at_256` (`{0,0,0,96.0f}`,
  last word read from 0x33A83C / 0x33A84C), i.e. a `float[4]` local initialised from a constant
  aggregate. `EndPrim2`, `End2`. Then `Shading(0)`, `AlphaBlend(2)`, `Begin(6)` (sprite),
  `Color(0,0,0,0x80)`, `Vertex(-1,-1,0)`, `Vertex(width+1, height+1, 0)`, `End()`, and
  `mgSetPkFrameBuffer(-1,-1,-1,-1)`.

## Callers
`GetEffect` and `CreateTexture` are called from `DngMainDraw__Fv`, `EditDraw__Fv`,
`TitleMapDraw__Fv` around `mgEndDrawReloadTexture` for the water texture.

## Global data
None with plain names: `cnt_302`/`init_303` are `GetEffect`'s function-local statics, `at_251`/
`at_256` are compiler literals. No `extern`s in the header.

## Naming
Field names `height`/`current` and the enum `WAVE_TABLE_DIM` (24) are descriptive, not retail.
