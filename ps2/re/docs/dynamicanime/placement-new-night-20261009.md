# Scripted collision-volume allocation

`dynCOLLISION` constructs a `CDAColPipe`, decodes its scripted axis, centre,
length and radius, and registers it with the active dynamic-animation
collision table. The already documented type and natural body are retained.
A purpose comment is added for this source-local function, and its assembly
guard is removed by hand.

The exact selector is `dynamicanime.cpp` /
`dynCOLLISION__FP9SPI_STACKi` / `__nw__FUiP1` /
`__ct__10CDAColPipeFv`, with `after_constructor_inline` and
`expected_matches: 1`. The original direct constructor class is 6.
The canonical two-word allocator-result branch/copy difference becomes zero.
This is the intentional statement-conversion policy described in the
[design note](../satansfiddle/placement-new.md),
without an asserted compiler-state defect.

Retail symbol 0x0017D0F0 is LOCAL/FUNC, size 0x130. Full-function review finds
typed construction and ordinary field/vector access, with no byte-offset
object walk, type-pun, steering helper, artificial local or literal alias.
On pn13, the entire resolved dynamicanime object passes, the PAL verifier
reports `SCES_511.90: OK`, and all 149 units pass. Every recursive assembled
object and source-only object outside the seven promoted units retains its
baseline hash; the linked main/game payload and loaded memory extent agree.

Receipts: `.private/pntc/receipts/promote-eleven-accepted-build.log` and `.exit`,
`promote-eleven-accepted-objects.log`, `promote-eleven-accepted-artifacts.json`,
and `semantic12-score-comparison.json`. This note supersedes the older
guarded status for this caller alone.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
