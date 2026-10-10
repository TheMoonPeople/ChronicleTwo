# wavetable: reverse-engineering notes

The earlier near-misses and bounded-cell probes are documented in
[the matching constraints](matching-constraints.md).

## Matching status

All five functions are native and exact. `Effect__10CWaveTableFv` matched last; see
[Effect match](#effect-match) below.

## CWaveTable (size 0x1208)
No counterpart in the first game's headers.

Size: `operator new(0x1208, ...)` in `TitleBootInit__Fv` (title); the globals `WaveTable`
(editloop, 0x1EC97B0) and `WaveTable__2` (dng_main, 0x1EE5260) are 0x1208 bytes each and are
constructed in `__sinit_*` with `__register_global_object(..., __dt__10CWaveTableFv, ...)`.
`WaveTable__3` (title, 0x37DFE8) is a `CWaveTable *`. These globals belong to those units.

| Offset | Field | Evidence |
|---|---|---|
| 0x0000 | `float height[2][24][24]`, unioned with `float cells[2][576]` | ctor zeroes 24 rows x 24 cols at `+0` and `+0x900` (row stride 0x60, buffer stride 0x900); every other function indexes `this + current*0x900 + row*0x60 + col*4` with `lwc1` |
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
  `h[prev][r][c] = (h[cur][r-1][c] + (h[cur][r+1][c] + (h[cur][r][c-1] + h[cur][r][c+1]))) * 0.0196f
  + (h[cur][r][c] * 1.9216f - h[prev][r][c]) - (h[cur][r][c] - h[prev][r][c]) * 0.0015f`.
  Then for rows 1..22, `h[prev][r][22] = h[prev][r][1] =
  (h[prev][r][1] + h[prev][r][22]) * 0.5f` (horizontal seam).
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

## Effect matching constraints

The guarded draft already reproduces the integer register allocation, 0x900
buffer stride, 0x60 row stride, instruction scheduling, eight-cell wave
unroll, eight-row seam unroll, and scalar wave remainder. There is no modulus
operation in `Effect`; signed `rand() % 22` belongs to the matched `GetEffect`.

The remaining instruction differences, relative to the start of `Effect`,
are:

- At 0x68 and 0x6C, the unrolled wave coefficients are transferred to swapped
  registers. Retail uses f0 for 1.9216f and f1 for 0.0196f; the draft uses f1
  and f0 respectively. The corresponding multiplication operands differ at
  0xDC/0x100 and 0x180/0x184 through 0x300/0x304 in 0x40-byte steps. These
  account for 18 differences; the damping coefficient and scalar remainder
  already match.
- The seam addition reverses its two source registers at 0x3E8, 0x400, 0x418,
  0x430, 0x448, 0x460, 0x478, 0x490, and 0x4D8. Retail loads the right edge
  first, then adds the left edge to it using the left edge as the first
  arithmetic operand. The draft's loads and stores match, but its arithmetic
  operands are reversed. These account for nine differences.

Simply reversing the seam expression also reverses its two loads, increasing
that loop's differences. Plain scalar sample temporaries fold away. Applying
`WaveSample` to the right edge preserves retail operand order and matches the
seam remainder, but rotates the unrolled seam's f0/f1/f2 allocation. A separate
inline averaging helper likewise changes register allocation. Memory compound
assignments retain intermediate stores; division by two emits `div.s` rather
than the retail multiplication by 0.5f.

The wave loop is sensitive to statement structure: combining the entire
update, adding a scalar self term (even only its multiplication), moving the
step into an inline helper, using direct two-dimensional array indexing, or
using a shared linear sample index prevents its automatic eight-cell unroll.
Combining just the neighbor scaling and self addition retains unrolling but
changes arithmetic temporaries and coefficient materialization order. Plain
coefficient locals, an inline coefficient initializer, accumulator scope,
`register`, and a descriptive local rename leave the original coefficient
allocation unchanged. Splitting damping into a compound accumulator update
loses the retail fused accumulator sequence.

The existing guarded draft flattens a row pointer across the full grid. A
promotable implementation must also express those accesses through bounded
typed storage/indexing, preserving the documented 24-by-24 layout. Direct
two-dimensional indexing currently loses the wave unroll. No layout change
or new overlay has been retained without a matching candidate.

Reconsider this guard when either a bounded typed indexing form reproduces
retail's 0x510-byte unrolled addressing, or an MWCC optimization/register
allocation trace explains the different coefficient coloring between the
unrolled and scalar wave loops. The next candidate must retain the already
matching scalar remainder and materialization order while resolving the
18 coefficient differences, then the nine seam differences. A zero function
diff still requires the complete-unit linked check, full PAL verifier, and
149-object check before promotion.

## Effect compiler-policy exclusion

`Effect__10CWaveTableFv` has no calls. The values 1.9216f (`0x3ff5f6fd`),
0.0196f (`0x3ca0902e`), 0.0015f (`0x3ac49ba6`) and 0.5f (`0x3f000000`)
feed arithmetic in the wave/seam loops, rather than a floating argument
consumer. The evaluate-first argument policy therefore supplies no evidenced
callee/argument correction for these differences.

Canonical mwccgap builds with the default GPR `0` / FPR `0` history and with
the measured GPR `0x30` / FPR `0` history both retain 27/324 differing words:
18 coefficient-register differences and nine seam-addition operand reversals.
Both check the same `0xB88` allocated bytes and 47 relocations, with Effect
as the sole problem. There is no helper-mask improvement, and no new profile
row is accepted.

Blocker category: arithmetic expression/register allocation and bounded grid
indexing. The guard and draft remain unchanged. Reconsider with a natural,
bounded representation that retains retail's eight-cell/eight-row unrolling
and explains the coefficient coloring and seam operand order together.

## Unroll size gate and tie-statement constraints (2026-10-10)

`Effect` stays guarded at 27/324. These results are new.

**Unroll gate.** MWCC's inner-loop unroll is gated by `opt_unroll_instr_count`, measured before dead-code removal and forward substitution. The draft unrolls at 100 (the default behaves the same) but not at 64. A single-use or dead float local in the cell (a named self term, a dummy `1.9216f * *center`) is still substituted or removed before CSE. It only enlarges the pre-optimisation size, so the loop stays scalar. At `opt_unroll_instr_count 127` those forms unroll again and collapse to the draft's 27 words. Constant-valued locals are propagated without counting.

**Materialisation versus numbering.** Coefficients are materialised in IR evaluation order and numbered in CSE scan order. Retail needs 0.0196 materialised first but 1.9216 numbered first, so both must sit in one statement with equal-cost operands. In every such form the neighbour sum `n` dies at its multiply before `1.9216f * *center` is formed. Its bias then moves it to U's register (`$f3`), where retail keeps it in `$f4`. Retail's `n` stays live across that product, which only an in-place `sum *= k` gives. A 140-case screen found that every in-place multiply (`(sum *= 0.0196f)`, `(sum *= k)`, `(sum *= c * c)`, `(sum = sum * k)`, `(sum = k * sum)`), placed in the same statement as any of five spellings of the self term, evaluates the self term first. 1.9216 is then materialised first. Best result 71.

| Form | Words |
| --- | ---: |
| Function-scope `sum` reused by the seam; `sum = U + (D + (L + R)); *old = sum * k + Y - Z;` (`float k = 0.0196f` or `c * c`): coefficient materialisation, colours, `U + n` and `n * k` all match; only `n`'s register differs | 97 |
| The same with the left-associated sum `center[-1] + center[1] + center[24] + center[-24]` (canonicalised to retail's tree) | 97 |
| `float sum = D + (L + R); sum += U; *old = sum * k + Y - Z;` (block scope) | 33 |
| `*old = (sum += U) * k + Y - Z;` (`k * n` operand order) | 41 |
| `*old = (U + sum) * k + Y - Z;` with function-scope partial `sum` | 97 |
| `sum = N * (c * c) + Y; *old = sum - Z;` with seam reuse (the neighbour product is heavier, so 0.0196 is numbered first) | 106 |
| `sum = (sum *= 0.0196f) + (self = Y);` (colours and in-place `n` correct, self term evaluated first) | 60 |
| Comma expressions joining the scale and the self term (linearised as separate statements; scalar at default, 27 or 36 at 127) | 27-321 |
| 368-case screen over neighbour, multiply, Y/Z spelling, scope and direct/split store | best 33 |

**Other exclusions.** Scoped pragmas `opt_lifetimes`, `opt_propagation`, `opt_common_subs`, `opt_dead_assignments`, `opt_loop_invariants`, `opt_strength_reduction(_strict)`, `opt_pointer_analysis`, `opt_vectorize_loops`, `peephole`, `schedule`, `usefloatacc`, `stdc_fp_contract`, `irocseglobaladdresses`, `float_constants`, `optimize_for_size` and `opt_unroll_loops` give no result below 27. A private Satan's Fiddle profile with `evaluate_first` on any one coefficient or 0.5 leaves the object unchanged in both the draft and the tie forms, so that flag does not order arithmetic here. Do-while, while, `<=`, `!=` and pre-increment loop forms all give 27 or a scalar loop. So do unused functions or types placed before `Effect`, and coefficient variables with two reaching definitions (which stop propagation but move materialisation out of the row loop). Seam spellings that make the right edge heavier (`before[row * 24 + 22]`, `* 1.0f`, `-(-x)`, unary `+`, `(&line[22])[0]`) are folded or CSE'd back to the 45-word order.

## Effect match

`Effect` matches with three source forms. Each one was needed:

- **Flat plane view.** `CWaveTable` unions `height[2][24][24]` with `cells[2][576]`.
  `Effect` takes `now = cells[current]`, `before = cells[1 - current]` and the cell
  pointers `center = &now[row * 24 + column]` / `old = &before[row * 24 + column]`,
  and reads neighbours as `center[±24]` and `center[±1]`, which always stay inside one
  plane. This is retail's per-cell address shape `((column + k) + row * 24) << 2`, and
  its pre-optimisation size (95) is under MWCC's unroll limit (100–104), so the column
  loop unrolls by eight. Typed `[row][column]` indexing is strength-reduced to a
  byte-offset counter instead, and direct `now[index ± k]` indexing measures 105–118,
  so the loop stays scalar.
- **One statement per cell.**
  `*old = (scaled = (sum = U + (D + (L + R))) *= 0.0196f) + (1.9216f * *center - *old) - 0.0015f * (*center - *old);`
  - Assigning the whole neighbour sum with `=` gives retail's `U + rest` add order.
  - Multiplying it in place keeps the sum alive in `$f4` across the 1.9216 product.
  - Assigning the product to a second local, `scaled`, gives it the same weight as
    the self term. 0.0196 is then materialised first while 1.9216 is CSE-numbered
    first and takes `$f0`.
  - The first-occurrence neighbour loads in the left operand make it heavier than the
    damping term, so 0.0015 is numbered last.
  - A no-op `(float)` cast in place of `scaled` also matches. Without either one the
    function scores 63/324.
- **Seam.** `line[22] = line[1] = (line[1] + WaveAt(line, 22)) * 0.5f;`, where
  `WaveAt` reads through a `const float *` parameter. That makes the right operand
  heavier, so column 22 is loaded first and the add is `line[1] + line[22]`. It adds
  no float temporary.

Ruled out along the way: every compiler setting for the whole file or the whole game
(a game-wide unroll limit above 101 breaks 3–7 matched functions), state carried
between files in a single MWCC invocation (all 49 units up to `wavetable` compiled in
one run give the same code), and uncalled functions placed before `Effect`.
