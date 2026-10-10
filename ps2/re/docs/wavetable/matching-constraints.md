# Wave-grid matching constraints

Fresh `decompile.sh`/m2c output agrees with [notes.md](notes.md): `CWaveTable` has
`float height[2][24][24]`, a signed `current` plane index and size `0x1208`. The
interior wave update writes the other plane, and the following loop averages its
horizontal seam. The existing 27-word draft has eighteen coefficient-register exchanges
and nine seam-addition operand reversals. It still flattens the array with raw pointers
and is not eligible for promotion.

## New experiments

These probes complement the earlier typed row-array experiments without crossing a row's
array bounds. Every horizontal neighbour uses typed `now[row][column - 1]` /
`now[row][column + 1]` indexing; all interior row and column bounds remain 1 through 22.
The seam also uses typed plane/row indexing.

| New variant | Differing words / 324 | Body |
| --- | ---: | ---: |
| Named pointers to actual above, below, current and previous cells | 320 | `0x238` |
| References to the actual above/below cells, same other operands | 320 | `0x238` |

Both variants lose retail's eight-column unroll and compile a scalar interior loop. All
four existing native functions remain exact. Neither variant is retained. The function
has no floating-argument call site, so there is no admissible callee-scoped selector for
its arithmetic coefficients and no profile proposal.

## Round 1

`Effect__10CWaveTableFv` remains guarded at **27/324** with the existing flat-pointer
draft. Two compliant indexing forms were tried. Both compile a scalar interior loop,
without retail's eight-column unroll:

| Variant | Words / 324 | Body |
| --- | ---: | ---: |
| Plane pointers `float (*)[24]`, `now[row ± 1][column]`, statement form | 321 | `0x208` |
| Same, seam operands `before[row][1] + before[row][22]` | 321 | `0x208` |
| Same, the whole update as one expression | 321 | `0x200` |
| Typed row pointers (`up`, `line`, `down`, `old`) indexed by column | 321 | `0x330` |

## Round 1: coefficient and seam order

These probes keep the existing flat draft (27/324, `0x510`) and change one statement at
a time. In retail's unrolled interior, 1.9216 takes `$f0`, 0.0196 `$f1` and 0.0015
`$f2`, although all three are materialised at the row-loop head in source order (0.0196
first). The draft colours them in materialisation order (0.0196 `$f0`, 1.9216 `$f1`).
The six-column remainder loop colours them identically in both (`$f3`, `$f2`, `$f1`). In
retail's seam, `line[22]` is loaded first into `$f2`, then `line[1]` into `$f1`, and the
sum is `line[1] + line[22]`. MWCC loads the left operand first for every seam form
below.

| Variant | Words / 324 |
| --- | ---: |
| Seam `(line[1] + line[22]) * 0.5f` or `0.5f * (line[1] + line[22])` | 45 |
| Seam via a named `average`, then two stores | 74 |
| Named `average` of `(line[22] + line[1])`, or `line[1] = ...; line[22] = line[1];` | 27 |
| Seam `line[1] += line[22]; line[1] *= 0.5f; ...` | body `0x538` |
| Seam divided by `2.0f` | body `0x518` |
| Seam `line[1] = line[22] = ...` (store order reversed) | 63 |
| Seam with `line[22]` first copied to a local (`edge`, or `left`/`right`) | 45 |
| Seam through a pointer to column 1 (`line[0]`/`*line` and `line[21]`) | body `0x5E0` |
| Seam through separate `left`/`right` element pointers | body `0x650` |
| Whole update as one expression (two operand orders) | 321, body `0x1F8` |
| `float wave = 1.9216f * *center - *old;` first, then one expression or the two compound statements | 321, body `0x1F8` |
| 0.0196 folded into the neighbour sum (`0.0196f * (...)` or `(...) * 0.0196f`) | 63 |
| `sum = 0.0196f * sum;` | 63 |
| `*center * 1.9216f` operand order | 27 |
| `sum = sum * 0.0196f + (1.9216f * *center - *old);` and two reorderings | 77 (1.9216 then materialised first) |
| `sum += -*old + 1.9216f * *center;` | body `0x530` |
| `sum -= *old - 1.9216f * *center;` | 45 |
| Named `float` or `const float` coefficients, all six declaration orders | 27 (propagated) |
| `sum` at function scope (before or after the pointers) | 27 |
| Block-scoped `center`/`old` | 106 |
| `old` assigned before `center` | 113 |
| Pointer declaration orders `center, before, old, now` or `before, now, row, column, old, center` | 96, 130 |
| Diagnostic wavetable helper masks: GPR `0x30`, FPR `1`-`0x10`, `0x100`, `0x1000`, `0xF000`, `0xFFFF` | 27 each |

### Indexing and colour-priority probes (round 1)

Only the `center`/`old` pointer form unrolls. Indexing `now` and `before` directly,
through a named index `i = row * 24 + column` (either operand order), inline `row * 24 +
column` expressions or `(row ± 1) * 24 + column`, gives 319-321/324 with a scalar loop
(`probes/wv9-*`). That pointer form walks across the declared `[24][24]` rows, so a
compliant draft needs a flat height array. A one-dimensional `float height[2 * 24 * 24]`
would make `CreateTexture`'s `height[0][row] + current * 576` row pointer an in-bounds
element address too. That layout was not probed; the earlier `[2][576]` probe unmatches
the other three functions.

## Round 2: one flat storage array

At checkpoint `830e48ed`, the production profile still gives `Effect` **27/324** words
and a `0x510` body. Fresh m2c output confirms the existing wave and seam analysis. No
wave source, header, or profile change is retained.

The new private layout uses `float height[2 * 24 * 24]`, retaining the `0x1200` storage
extent, `current` offset, vptr offset and total `0x1208` class size. Every cell pointer
then addresses an actual element of that array. Unlike the earlier fully linear
texture-index trial, constructing `line` as `&height[row * 24] + current * 576` and
`next_line` with the corresponding wrapped row preserves **CreateTexture exactly**. This
is an expression-shape result, not evidence that the retail declaration was flat.

| New flat-storage source | Constructor / 36 | GetEffect / 84 | Effect / 324 |
| --- | ---: | ---: | ---: |
| Constructor row pointer declared inside row loop | 9 | 56, body `0x144` | 27 |
| GetEffect names the plane pointer | 9 | 82, body `0x148` | 27 |
| GetEffect names the selected row pointer | 9 | 61, body `0x144` | 27 |
| Constructor row pointer declared before both indices | 3 | 56 | 27 |
| Constructor row pointer declared between indices | 7 | 56 | 27 |
| Constructor row pointer declared after indices | 9 | 56 | 27 |
| GetEffect factors `(current * 24 + row) * 24 + col` | 9 | 56 | 27 |

Destructor and CreateTexture match in every successful flat-storage trial. The
three-word constructor residual is the placement of its row-base calculation before the
column/offset zero initializations. GetEffect's flat index collapses address arithmetic
that retail computes separately in bytes; its saved-register and floating schedule also
differ. No byte arithmetic or overlay is introduced to compensate for that difference.

On the first flat-storage source, explicit `float(1.9216)` and `float(0.0196)` constant
conversions each leave Effect at 27 words. Writing the seam with a no-op float cast on
either operand and left-edge first leaves 45 words; those conversions do not preserve
retail's load order while reversing its arithmetic operands. These casts and all layout
variants remain private. Arithmetic coefficients still have no eligible floating
call-argument identity for a profile row.

## Round 3 (regsim-r1): coefficient numbering traced in MWCC

### What decides the coefficient registers

- After unrolling, each coefficient becomes a CSE variable when its
  **second** occurrence is scanned (the copy in unrolled cell 2). CSE
  variables are numbered downward in creation order and coloured in number
  order, so the first-created coefficient gets `$f0`. The draft creates them
  0.0196 (59), 1.9216 (58), then cell 2's `*old`/`*center` pair (57/56), then
  0.0015 (55). Its colours are therefore `$f0`/`$f1`/`$f2`, where retail has
  1.9216 in `$f0`.
- Materialisation order is the IR order of each coefficient's first
  occurrence (cell 1), not its number. With `(sum * 0.0196f + 1.9216f *
  *center) - *old`, 0.0196 is still materialised first (the retail prologue
  exactly), while 1.9216 is numbered higher and gets `$f0`.
- Within one statement, evaluation (IR order, and so materialisation order)
  takes the heavier operand first, with ties going left. The CSE scan also
  takes the heavier operand first, but ties go right. Costs are
  Sethi-Ullman-like: a constant costs 0; a variable or an already-CSE'd load
  costs 1; a load at its first occurrence costs 2. They are evaluated after
  CSE, so a load used twice in the same statement is cheap there. Retail's
  pair (0.0196 materialised first, 1.9216 numbered first) therefore needs
  0.0196 and 1.9216 in **one statement**, in operands of **equal cost**,
  with 0.0196 on the left.
- Commutative operands are canonicalised lighter-first before IRO constant
  propagation. `n * 0.0196f`, `0.0196f * n` and `n * scale` all emit
  `0.0196 * n`. Only a compound `sum *= k` keeps retail's `mul.s
  $f4,$f4,$f1`. With `n * (c * c)` (`float c = 0.14f`, whose square is
  bit-identical to 0.0196f) the order stays `n * k`, because `c * c` costs
  as much as `n` until it is folded.
- Named coefficients (`float`/`const float`, including `c * c` and
  `2.0f - 4.0f * c * c`, which is bit-identical to 1.9216f) are propagated
  and folded before the CSE scan. They number exactly like literals.
- A block-local `sum` with one definition is forward-substituted into the
  store, and the wave loop then loses its unroll. A function-scope `sum`
  that the seam reuses, or a `sum` with two definitions, keeps it.

### Why no form reaches retail

Retail keeps the neighbour sum and its 0.0196 product in one register (`$f4`), and
1.9216's product (`$f3`) is live across it. That is what `sum *= 0.0196f` produces: one
web for `n` and `n * k`. A separate `*=`/`= sum * k` statement always creates 0.0196
first, though. Every single-statement form that numbers 1.9216 first keeps the product
as a temporary. The named `sum` web is then coloured after the cell temporaries. It is
dead before `1.9216f * *center` is computed, so it takes `$f3`, and the post-allocation
scheduler can no longer hoist that multiply.

| Probe (wave loop; seam unchanged unless noted) | Words |
|---|---:|
| `sum = n; sum *= 0.0196f; *old = sum + (1.9216f * *center - *old) - 0.0015f * (*center - *old);` (also unparenthesised or self term first) | 36 |
| The same with `sum *= c * c` (`float c = 0.14f`) | 36 |
| Whole update as one store `*old = n * 0.0196f + (...) - 0.0015f * (...)`; also `0.14f * 0.14f` or `const float c` squared | 138 |
| Whole store, `n * (c * c)` with `float c = 0.14f` (also with `(2 - 4cc)` for 1.9216) | 148 |
| `sum = n` (function scope, reused by the seam as `sum = line[22]`), `*old = sum * k1 + (...) - ...` with `float k1 = 0.0196f` | 97 |
| `sum = n * 0.0196f + (1.9216f * *center - *old);` with the reused `sum` (or `0.0196f * n`, or `n * scale`) | 97 |
| `sum = sum * k1 + (1.9216f * *center - *old);` (`k1` literal, `float`, or `c * c`) | 77 |
| `*old = (sum *= k1) + (...) - ...` (`k1` = `float`, or `c * c`) | 72 |
| `sum = sum * 0.0196f + 1.9216f * *center - *old;` (different rounding) | 266, `0x4E8` |
| `sum` declared once with the combined value, or block `sum` used once (forward-substituted) | 321, `0x1F8` |
| Four statements with `float`/`const` `k1`, `c * c` or `2.0f - 4.0f * 0.0196f` | 27 |
| Four statements with non-const `c` in `(2.0f - 4.0f * c)` | 321, `0x1F8` |
| Reused function-scope `sum` with the four statements | 59 |

The 36-word forms match every cell instruction and register of the unrolled and
remainder loops. Only the three coefficient colours differ (0.0196 `$f0`, 0.0015 `$f1`,
1.9216 `$f2`). In that form the scan creates 0.0015 before 1.9216 because the damping
operand is scanned first on a tie. The nine seam operand reversals are unchanged in
every form except where noted in earlier rounds.

A later probe gave one coefficient a second definition, so that the named variable would
not be forward-substituted. A function-scope `float scale` set to the coefficient, then
reassigned to `0.5f` for the seam, stays at 27 for each of 0.0196, 1.9216 and 0.0015.
Each use is reached by one constant definition, which is still propagated before CSE.
The same per-definition propagation defeats multi-definition constant locals in
`sgLoopGyoRace`.

## Bounded cursor induction

Two new cursor forms retain the declared plane/row arrays and keep all
pointers within their owning arrays. Four float cursors, initialized to column
1 of the above/current/below/previous rows and incremented through column 23,
emit a scalar `0x340` body with **321/324** differing words. Two typed row
cursors, initialized to row 1 and incremented through row 23, address vertical
neighbours as `now_row[-1][column]` and `now_row[1][column]`. They recover the
eight-cell interior unroll but emit `0x528` bytes, exceeding retail's `0x510`.
They use sequential cell-address preparation without retail's saved-register
frame and keep the plane-base calculations inside the seam loop. Moving the
center/old cell pointers to function scope leaves the same `0x528` body.
All four existing native functions remain exact; no candidate is retained.

A relative three-row window formed inside the inner loop, using constant row
subscripts 0/1/2 and bounded horizontal cell accesses, remains scalar at
`0x218` bytes and **319/324** words. References to the complete plane arrays
likewise remain scalar at `0x208` and **321/324** words. Binding the three
arithmetic coefficients to const references in the typed row-cursor candidate
loses its unroll and emits `0x2F0` bytes with **321/324** words, in either
neighbor/self declaration order. Coefficient references therefore do not
recover the required unrolled schedule. All four other functions remain exact.

## Sequenced arithmetic and normalized indices

Joining the neighbour scaling and self/previous contribution with the comma
operator preserves their evaluation order but leaves the flat diagnostic at
**27/324**. It does not change the coefficient colours.

A bounded source that derives a linear cell index and reconstructs each
actual row/column with division and remainder by 24 emits a scalar `0x368`
body with **315/324** differing words. MWCC retains division/remainder work
rather than folding the normalized indices back into retail's linear address
calculation. The other four functions remain exact. No source or profile
change is activated.

## Function-scope self term

The self/previous term `1.9216f * *center - *old` computed first into a
function-scope `float`, which the seam then reuses for the right edge,
keeps the eight-cell unroll and gives retail's coefficient registers
(1.9216 `$f0`, 0.0196 `$f1`, 0.0015 `$f2`). It also materialises 1.9216
first and moves the neighbour sum to `$f5`, so the cell schedule diverges:
**193/324** words. Retail needs 0.0196 materialised first, so a statement
that computes 1.9216 ahead of the neighbour scaling cannot match.

## Smart and deferred inline policies

Scoped `inline_depth(smart)` and deferred inlining (`-inline deferred`)
each preserve the **27/324** residual and `0x510` body, with all four other
native functions exact. The eighteen coefficient-register exchanges and nine
seam-addition operand reversals remain. `Effect` has no call for either
inline policy to expand, and these policies supply no bounded-grid or
arithmetic correction. No source or compiler-policy change is retained.

## Floating-point interference graph

A capture of the floating-point interference graph for the 27-word draft,
replayed by a simplify/select model, reproduces every `$f` colour MWCC assigns.
The three coefficients are the only high-degree nodes (106 interferences each)
and are coloured first in descending number: 0.0196 (`$f0`), 1.9216 (`$f1`),
0.0015 (`$f2`). Swapping only the numbers of the 0.0196 and 1.9216 temporaries
gives retail's colours with every other node unchanged, for any numbering in
which 1.9216 is above 0.0196 and both are above 0.0015. No interference needs to
change, so the unrolled-body residual is purely CSE creation order.

Local `optimization_level` 1 and 2 lose the unroll (323/324 words); level 4 keeps
the 27-word residual, so the second IR round does not renumber these constants.

## Coefficient reference bindings

The 27-word flat diagnostic still uses immediate coefficient materialisation.
Its captured floating-point graph has three degree-106 coefficient nodes:
0.0196 is numbered 59 and coloured `$f0`, 1.9216 is numbered 58 and coloured
`$f1`, and 0.0015 is numbered 55 and coloured `$f2`. The simplify/select
simulator reproduces all floating-point colours in every binding probe below.

Binding 1.9216 and 0.0196 to function-scope `const float &` locals, in either
declaration order, does not retain those immediate values as higher-numbered
scalar locals. MWCC pools the reference targets and emits their addresses and
`lwc1` loads in the wave loop. The eight-cell unroll survives, but the function
has a `0x540` body and a `0x80` stack frame instead of retail's `0x510` body and
`0x60` frame. Only the unreferenced damping coefficient remains a high-degree
immediate node (number 55, degree 120, `$f0`). Reversing the declarations does
not repair the graph or schedule.

| Coefficient binding | Body bytes |
| --- | ---: |
| One literal reference, function or row scope (each of the three coefficients) | `0x51C` |
| One literal reference, cell scope (each coefficient; scalar wave loop) | `0x1F8` |
| Both literals through function-scope references | `0x540` |
| Both literals through static references | `0x560` |
| References to separately named const values: local, local-static, file-static or class-static | `0x548` |
| References to separately named non-const local values | `0x558` |

The two-coefficient cases give the same extent in both neighbor/self declaration
orders. Named const targets likewise retain coefficient memory loads. Naming
ordinary function-scope `const float` or `static const float` values without
references still propagates them into literals: both declaration orders keep
all floating-point colours and the original **27/324** residual.

Canonical `draft.sh` confirms the `0x540` direct-reference and `0x548`
local-static-target failures, and the scalar cell-reference failure. All four
other native functions remain exact in those checks. Restoring the source
recovers the original 27-word draft. No reference, constant, header, layout or
compiler-policy change is retained; the bounded-indexing and seam constraints
remain unresolved. A reference binding therefore supplies no evidence for
renumbering the existing immediate-coefficient graph alone.

## Single-statement update with an in-statement neighbour add

The draft's coefficient numbering can be reproduced without names or
references. The final neighbour addition has to move into the update
statement:

```cpp
float sum = center[24] + (center[-1] + center[1]);
*old = (sum += center[-24]) * 0.0196f + (1.9216f * *center - *old)
     - 0.0015f * (*center - *old);
```

This form gives **41/324** words and a `0x510` body. Canonical `draft.sh`
confirms the score, and all four other native functions stay exact. The
row-loop head now matches retail exactly: 0.0196 is materialised first,
1.9216 takes `$f0` and 0.0196 takes `$f1`. Every floating-point register
in the unrolled cells also matches. Because `*center` and `*old` repeat
inside the statement, the self term is as cheap as `(sum += U) * k`. The
tie evaluates the left operand first and scans the right one first. That
is the order retail needs.

Two kinds of difference remain, besides the nine seam reversals:

- The neighbour add is emitted as `sum + U` (`add.s $f4,$f4,$f3`), but
  retail has `U + sum`.
- The product is emitted as `0.0196 * n` (`mul.s $f4,$f1,$f4`), but
  retail has `n * 0.0196`.

There are also small schedule differences in the address arithmetic at
`+0x140`, in the last unrolled cell, and in the remainder loop. Changing
the operand order breaks something else in every form tested:

| Variant | Words / 324 | Effect |
| --- | ---: | --- |
| Same, assigned to `sum` and then stored | 48 | same operand orders, more remainder-loop drift |
| `(sum = center[-24] + sum)` (`U + sum` order) | 65-71 | the result becomes a temporary in `$f3`; a direct store is scalar |
| `float sum = center[-24]; (sum += D + (L + R))` | 125 | add order correct, neighbour web in `$f6` |
| `(sum += U) * (c * c)`, `float c = 0.14f` | 81 | `n * k` order, but 1.9216 materialised first and 0.0196 in `$f0` |
| `((sum += U) *= 0.0196f)` in the statement | 80 | `n * k` and coefficient colours, but 1.9216 materialised first |
| Full neighbour sum, `sum * (c * c) + self - damping` | 71 | coefficients and `n * k` correct, but the sum is dead before the self term (`$f3`) |
| Named `float`/`const float k = 0.0196f` in the 41-word form | 41 | propagated like the literal |
| Self term nested as `(wave = 1.9216f * *center - *old)` beside `(sum *= 0.0196f)` | 60-82 | 1.9216 still materialised first |
| The same nested self term after a separate `sum *= 0.0196f` | 36 | 0.0196 numbered first |

A 198-case screen covered the add form, the multiply form, the self-term
order, the statement shape and the `sum` scope. It found no form below 41.
Retail's `U + sum` and in-place `n * k` together point to the
draft's separate `sum *= 0.0196f`, which numbers 0.0196 first. Double
literals do not help: `sum *= 0.0196` is identical to the float form,
while double 1.9216 or 0.0015 literals emit double arithmetic.

### Squared coefficient

0.0196 is bit-identical to `0.14f * 0.14f`, and 1.9216 to `2 - 4 * 0.14²`. If
the product is written as `sum * (c * c)` with `float c = 0.14f`, the
multiply keeps retail's `n * k` order. Combined with a separate `sum +=
center[-24]`, this gives **33/324** words and a `0x510` body. Canonical
`draft.sh` confirms the score, and all four other native functions stay
exact:

```cpp
float sum = center[24] + (center[-1] + center[1]);
sum += center[-24];
*old = sum * (c * c) + (1.9216f * *center - *old) - 0.0015f * (*center - *old);
```

The prologue, the coefficient colours, every unrolled multiply and the
`adda`/`msub` sequence all match. Differences remain in four places:

- the `sum + U` operand order of the final neighbour add, in all eight cells;
- three address instructions at `+0x140`;
- the last unrolled cell's load order;
- five remainder-loop words.

The nine seam reversals also remain. `U + sum` is not
available here: `+=` always emits the variable first, while `sum =
center[-24] + sum` starts a new value. That value takes `U`'s register
(`$f3`) instead of the partial sum's `$f4`, giving 65 words. The `U + sum`
order is reached only by `float sum = U + (D + (L + R))`. With a temporary
product, that sum dies before the self term and also takes `$f3`; that
form gives 71 words.

| `c * c` variant | Words / 324 |
| --- | ---: |
| `const float c` (folded like the literal) | 41 |
| `c` declared inside the cell | `0x1F8`, scalar |
| 1.9216 written as `2.0f - 4.0f * c * c` or `2.0f - 4.0f * (c * c)` | `0x1F8`, scalar |
| Self term evaluated first (`self + sum * (c * c)`, or the damping moved out of the statement) | 67-81, 1.9216 materialised first |
| `sum *= c * c` as its own statement (draft structure) | 27, 0.0196 numbered first |
| `(center[-24] + sum) * (c * c)` in one statement | 67-81 |

## Row cursors and reference bindings

Retail recomputes every cell address as `base + ((column + k) + row * 24)
* 4`. Typed row cursors strength-reduce the column address to a pointer
with constant offsets instead:

| Cursor form | Words / 324 | Body |
| --- | ---: | ---: |
| `float (*now)[24]` cursor advanced per row, function-scope `center`/`old` | 322 | `0x528` |
| Same with block-scope `float *const &center`/`old` | 324 | `0x300`, scalar |
| `float *const &` row bindings (`above`, `line`, `below`, `prev`) | 357 | `0x598`, bindings spilled to the frame |
| `&now[row][column]` with `center[±24]` neighbours (crosses rows) | 324 | `0x438`, pointer induction |
| Plain `now[row][column]` neighbours | 324 | `0x208`, scalar |

None reproduces retail's per-cell index arithmetic. Only a flat
`row * 24 + column` index does, and the seam forms tested here (pointer
pairs, an index base at column 1, `0.5f *`, `/ 2`, reverse row loop and
mixed `before[row * 24 + 22]` operands) leave the nine reversals or grow
the body.

## Grouped sums, value snapshots and pointer lifetimes

With the squared-coefficient update above, a complete neighbour initializer
loses the eight-cell unroll. All five binary groupings of the four neighbours,
all 24 neighbour orders, and block/function accumulator declarations produce
scalar `0x1F8` bodies. An extra outer pair of parentheses does not rescue them.
Putting the grouped sum directly in the store retains `0x510`, but the best
screened form differs in 148 words. This differs from assigning the combined
update to `sum` before storing it: that is the previously recorded 71-word
near-miss, rather than a direct-store initializer.

Separate named `up`, `down`, `left` and `right` value loads also produce scalar
bodies in every declaration order, with either plain or const values, full or
partial neighbour sums, and direct grouped stores. Naming the current/previous
heights, or the physical velocity `*center - *old`, likewise loses the unroll.
Plain/const velocity values and const-reference bindings do not retain a useful
floating-register constraint.

Representative canonical `draft.sh` checks establish these constraints; all
four other native functions remain exact:

| Change to the squared-coefficient near-miss | Words / 324 | Body |
| --- | ---: | ---: |
| Full grouped initializer, function-scope `sum` | 321 | `0x1F8` |
| Four named neighbours, partial sum followed by `+= up` | 321 | `0x1F8` |
| Current/previous height snapshots before the partial sum | 321 | `0x1F8` |
| Named velocity before the partial sum | 321 | `0x1F8` |
| Cell-scope `center`, function-scope `old` | 33 | `0x510` |
| Named seam edges, right loaded before left, `(left + right) * 0.5f` | 51 | `0x510` |
| Function-scope `old` reused as the seam row pointer | 79 | `0x510` |
| Entire grouped neighbour sum inside the store | 148 | `0x510` |

Moving only `center` into the cell body ties the 33-word near-miss without
fixing any residual. Pointer declaration-order changes, assignment reversal,
other cell-pointer scopes, and row/function accumulator scopes do not improve
it. Seam value/reference bindings in both declaration orders, row-local
averages, and separate versus chained stores give 51--80 words. Reusing either
cell pointer as the seam row pointer gives 79--122 words and leaves the wave
loop's terminal address discrepancy.

At `+0x140`, the near-miss shifts the terminal offset into `$s3`, forms the
current-cell pointer in `$s4`, and the previous-cell pointer in `$s5`. Retail
shifts into `$s4`, forms the current-cell pointer in `$s5`, then reuses `$s4`
for the previous-cell pointer. This is a coalescing difference with the same
address schedule. The captured GPR/FPR interference graphs reproduce the
near-miss's allocation exactly under the local allocator simulator; pointer
reuse and value snapshots do not supply the required natural lifetime change.
The original 27-word guarded draft and the structurally closer 33-word update
therefore remain the retained reference points.
