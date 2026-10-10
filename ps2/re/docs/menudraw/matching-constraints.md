# Common-board frame drawing constraints

## Matching source

`CommonBoardDraw__FPfRi` matches and is unguarded. The frame loop declares `int left;
int top; int row; int pass;` at function scope, `left` before `top`. It writes each
bottom vertex as `top + heights[row]` rather than a named `row_bottom`. It has no no-op
`(int)` casts.

Three source features controlled the remaining register exchange:

- The inherited draft wrote `((int)left)` in three vertex calls. These
  no-op casts make MWCC colour `left` after the loop temporaries (`s4`).
  Without them `left` is coloured with the declared locals and takes `s1`,
  as in retail (`bd12-nocast`, 31 words, with `top` and `row_bottom`
  exchanged).
- A named `row_bottom` is coloured with the declared locals, before the
  row-UV base temporary (`&row_uv.uv[row]`). It takes `s2` or `s3`
  depending on its position relative to `top`. Written inline, the three
  uses form one common subexpression. Its temporary is created after the
  UV base and the `&uv[row][0][1]` temporary, and it shares `s4` with the
  latter, as in retail.
- `row` and `pass` are strength-reduced (their scaled offsets live in
  stack slots), so `pass` takes `s5` whatever its declaration position.

| Variant (cast-free) | Words / 888 |
| --- | ---: |
| `left`, `row_bottom`, `row`, `pass`, `top` (the draft's order) | 31 |
| Declaration permutations of `left`, `row_bottom`, `row`, `pass`, `top` (79 of 120 run) | 26 (19), 31 (19), 36 (16), 41 (25) |
| Best permutation: `left` first, `top` before `row_bottom` (`left` `s1`, `top` `s2`, `row_bottom` `s3`) | 26 |
| Typed row pointer `s8 (*uv)[4] = row_uv.uv[row]` (pass-loop or function scope) | 729-732, body `0xDA0` |
| Inline `top + heights[row]`, declared `left`, `top`, `row`, `pass` | **0** |
| Inline `top + heights[row]`, declared `left`, `row`, `pass`, `top` | **0** |
| Matching form without the material loop's `((int)line_w)`, `((int)top)` casts | **0** (either or both) |
