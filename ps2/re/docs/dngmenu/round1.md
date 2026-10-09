# dngmenu: MsgInit and DngTreeMapInit rejected forms

Durable status and the matching forms are in [notes.md](notes.md). The counts
below mask relocated operands and include each retail manifest reservation.

## MsgInit

The first line's setup differs at +0x140..+0x15C in every form below: retail
reads height, then width, then the line width, and subtracts fifty before its
two shifts, while these forms read the line width first and delay the height
subtraction.

Writing the first line's Y coordinate before X restores the height load at
+0x140 but also moves the Y store before the X computation (eight words).
Moving the enable store before or between the coordinates gives nine words.
Caching the first line width, reversing the subtraction into a negated add,
using a comma expression for the three stores, and spelling the height offset
as addition all leave seven. A short Y introduces truncation and grows to
0x1D8; retail keeps Y as a word until the final halfword save-label store.

Optimizer controls do not isolate the issue: disabling loop-invariant motion
leaves seven; disabling common subexpressions or propagation grows the
function; disabling strength reduction changes the message array loop and
leaves forty. The integer load/store schedule cannot be selected by SF's
floating-argument identities.

## DngTreeMapInit

With the natural constructor the first 0x214 bytes are exact. Boolean forms of
the opening-mode condition normalize comparisons with xor/sltiu instead of the
retail branch chain, and the cursor file argument is forwarded across the
global pointer store instead of being reloaded; the suffix from +0x30C is
exact.

A ternary boolean, explicit if/else boolean or integer flag, short and byte
flags, an inverted boolean, a default-first switch, independent mode blocks, a
single-iteration do/break block, earlier flag evaluation and a retained
common-menu pointer all leave at least fifty-five words. The default-first
switch changes the block order; the explicit flag forms retain additional
condition operations. Reversing comparison operands changes the native branch
layout without restoring the retail jumps.

`void *` and `u8 *` cursor-buffer globals require an explicit aligned-pointer
cast at `LoadFileMenu`, whose argument is `u_long128 *`. Both corrected pointer
forms and an ordinary pointer reference reproduce the file-load block at
+0x248..+0x2B8, including the reload. Combined with a boolean condition they
give 71/256; with the two-case `switch` they are exact.

Disabling propagation for the boolean, direct or ternary conditions grows the
body to 0x414, 0x408 or 0x418. Disabling common subexpressions gives 0x418.
Explicit shared-branch labels also give 112/256: MWCC folds the branch
sequence into the same compact direct condition, so a `goto` form is not
justified.

## Diagnostic ledger

| Probe | Result |
|---|---|
| `msg-common_subs-off` | 0x1D4 bytes, retail 0x1D0 |
| `msg-first-comma-xy` | 7 of 116 words differ |
| `msg-first-enable` | 9 of 116 words differ |
| `msg-first-enable-between` | 9 of 116 words differ |
| `msg-first-reverse-add` | 7 of 116 words differ |
| `msg-first-width-cache` | 7 of 116 words differ |
| `msg-first-y-store` | 8 of 116 words differ |
| `msg-height-positive-offset` | 7 of 116 words differ |
| `msg-loop_invariants-off` | 7 of 116 words differ |
| `msg-propagation-off` | 0x1D8 bytes, retail 0x1D0 |
| `msg-strength_reduction-off` | 40 of 116 words differ, 0x1CC bytes against retail's 0x1D0 |
| `msg-y-expression-store` | 8 of 116 words differ |
| `msg-y-short` | 0x1D8 bytes, retail 0x1D0 |
| `tree-bool-common-subs-off` | 0x418 bytes, retail 0x400 |
| `tree-bool-if-else-mode` | 117 of 256 words differ |
| `tree-bool-inverted-mode` | 115 of 256 words differ, 0x3F4 bytes against retail's 0x400 |
| `tree-bool-mode-before-reset` | 84 of 256 words differ, 0x3FC bytes against retail's 0x400 |
| `tree-byte-mode` | 55 of 256 words differ, 0x3F8 bytes against retail's 0x400 |
| `tree-call-zero-address` | 55 of 256 words differ, 0x3F8 bytes against retail's 0x400 |
| `tree-common-menu-pointer` | 112 of 256 words differ, 0x3E8 bytes against retail's 0x400 |
| `tree-cursor-bytes` | 71 of 256 words differ, 0x3FC bytes against retail's 0x400 |
| `tree-cursor-bytes-direct` | 112 of 256 words differ, 0x3F4 bytes against retail's 0x400 |
| `tree-cursor-bytes-ternary` | 117 of 256 words differ |
| `tree-cursor-reference` | 71 of 256 words differ, 0x3FC bytes against retail's 0x400 |
| `tree-cursor-void` | 71 of 256 words differ, 0x3FC bytes against retail's 0x400 |
| `tree-cursor-void-direct` | 112 of 256 words differ, 0x3F4 bytes against retail's 0x400 |
| `tree-cursor-void-ternary` | 117 of 256 words differ |
| `tree-direct-propagation-off` | 0x408 bytes, retail 0x400 |
| `tree-dowhile-break-mode` | 110 of 256 words differ, 0x3F0 bytes against retail's 0x400 |
| `tree-independent-modes` | 112 of 256 words differ, 0x3FC bytes against retail's 0x400 |
| `tree-int-if-else-mode` | 117 of 256 words differ |
| `tree-mode-positive-comparison` | 110 of 256 words differ, 0x3F0 bytes against retail's 0x400 |
| `tree-propagation-off` | 0x414 bytes, retail 0x400 |
| `tree-separate-bool-independent` | 86 of 256 words differ, 0x3FC bytes against retail's 0x400 |
| `tree-short-mode` | 85 of 256 words differ, 0x3FC bytes against retail's 0x400 |
| `tree-switch-default-first` | 80 of 256 words differ, 0x3F8 bytes against retail's 0x400 |
| `tree-ternary-mode` | 80 of 256 words differ, 0x3FC bytes against retail's 0x400 |
| `tree-ternary-propagation-off` | 0x418 bytes, retail 0x400 |
| `tree-ref-boolean-recheck` | 71 of 256 words differ, 0x3FC bytes against retail's 0x400 |
| `tree-ref-common-guard-break` | 114 of 256 words differ, 0x3F4 bytes against retail's 0x400 |
| `tree-ref-explicit-shared-branch` | 112 of 256 words differ, 0x3F4 bytes against retail's 0x400 |
| `tree-ref-negated-and-condition` | 112 of 256 words differ, 0x3F4 bytes against retail's 0x400 |
| `tree-ref-ternary-condition` | 117 of 256 words differ |
| `tree-ref-ternary-int-condition` | 117 of 256 words differ |
| `tree-ref-zero-negation` | 112 of 256 words differ, 0x3F4 bytes against retail's 0x400 |
