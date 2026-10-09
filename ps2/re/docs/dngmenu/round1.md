# October 8 midday round 1

This is a historical probe record. The current native/guarded status is in
[notes.md](notes.md#current-assembly-gaps); later exact matches are documented
in [night-20261008.md](night-20261008.md).

Base: `c33c821`, branch `work/dc2-dnginv-midday`. Compiler image:
`chronicletwo_dev:sf-d8bf13c`, canonical `-O3,p` options and existing SF
profile, `JOBS=4`. The round-0 records and m2c output are the prior analysis;
this round tests new source forms rather than replaying their probes.

Diagnostic counts below mask relocated operands and include each retail
manifest reservation. Oversized bodies are identified explicitly. These
measurements do not authorize promotion without the canonical object check.
All candidate sources, instruction diffs and compile logs are private under
`.private/dnginv-r1/<probe>/`; `ledger.json` and `ledger.tsv` index them.
No compiler-profile row, replacement assembly, foreign header or foreign
source change is retained.

## MsgInit

`MsgInit__12CMenuTreeMapFv` remains guarded at 7/116 words, 0x1D0 bytes.
The first line's setup still differs at +0x140..+0x15C: retail reads height,
then width, then the line width, and subtracts fifty before its two shifts.
The direct draft reads the line width first and delays the height subtraction.

Writing the first line's Y coordinate before X restores the height load at
+0x140, but also moves the Y store before the X computation. Its eight-word
remainder is worse than the retained seven. Moving the enable store before
or between the coordinates gives nine words. Caching the first line width,
reversing the subtraction into a negated add, using a comma expression for
the three stores, and spelling the height offset as addition all leave seven.
A short Y introduces truncation and grows to 0x1D8; retail keeps Y as a word
until the final halfword save-label store.

Private optimizer controls isolate the issue: disabling loop-invariant
motion leaves seven; disabling common subexpressions or propagation grows
the function; disabling strength reduction changes the established message
array loop and leaves forty. None is retained. The remaining integer
load/store schedule cannot be selected by SF's floating-argument identities.

## DngTreeMapInit and ClsMes::Init

`DngTreeMapInit__FP9mgCMemoryPiii` remains guarded at 55/256 words,
0x3F8 native bytes in a 0x400 manifest reservation. Its first 0x214 bytes
retain both exact natural allocation/constructor expansions. The remaining
opening-mode condition normalizes comparisons with xor/sltiu instead of the
retail branch chain. The cursor file argument is forwarded across the global
pointer store instead of being reloaded. The suffix from +0x30C is exact.

A ternary boolean, explicit if/else boolean or integer flag, short and byte
flags, an inverted boolean, a default-first switch, independent mode blocks,
a single-iteration do/break block, earlier flag evaluation and a retained
common-menu pointer are measured below. None beats fifty-five. The default-first
switch changes the block order; the explicit flag forms retain additional
condition operations. Merely reversing comparison operands also changes the
native branch layout without restoring the retail jumps.

The cursor consumers establish an aligned menu-file buffer supplied to
`LoadFileMenu` and byte image data supplied to `EnterIMGFile`. Private generic
`void *` and byte `u8 *` global declarations require an explicit aligned-pointer
cast at the loader: its established argument is `u_long128 *`, not `void *`.
The original no-cast generic candidate fails that type check. Both corrected
pointer forms and an ordinary pointer reference reproduce the entire file-load
block at +0x248..+0x2B8, including the missing reload. The common-menu path
then needs an extra global-pointer load at +0x30C instead of retail's delay-slot
load at +0x238, shifting the suffix by one instruction. The boolean candidate
grows to 0x3FC and yields 71/256. Direct-condition variants give 112/256; ternary variants
117/256. Typed zero-element addressing leaves the original 55-word output.
The retained global type and declarations are unchanged.

Disabling propagation for the boolean, direct or ternary conditions grows
the body to 0x414, 0x408 or 0x418. Disabling common subexpressions with the
current natural constructor and filename record gives 0x418. These broader
optimizer changes do not isolate the two remaining blocks and are rejected.

With the exact cursor-file block, a direct ternary condition still gives
117/256, and negating the opposite condition or using zero negation gives
112/256. Initializing and rechecking a boolean reproduces 71/256. A common-menu
early break gives 114/256. A private last-resort diagnostic with explicit
shared-branch labels also gives 112/256: MWCC folds the branch sequence into
the same compact direct condition. It is not retained; it establishes no
need or justification for a goto implementation.

The existing `ClsMes::Init` natural-emission proposal remains conditional.
Its round-0 canonical measurement is 0/176, including eight bytes of padding;
that exact function is not reanalyzed. Because tree initialization is not
exact, its guard and the Init marker both remain. The original patch still
passes `git apply --check`; there is no new shared-header proposal. See
[clsmes-init-proposal.md](clsmes-init-proposal.md).

## Fresh diagnostic ledger

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

## Final validation

The canonical final build has the unchanged retail `.text` difference of
0x26 bytes, first at 0x0015C5AD in `nd_meswin::DrawMesWin`. All nine other
file-backed sections pass; BSS ends at 0x01F64A00. The build's nonzero exit
is the existing verifier failure, not a compilation failure.

The complete checker remains 147/149. Its only failing functions are the
baseline `nd_meswin::DrawMesWin` and `actscript::_SHOT`. Dngmenu passes
0x8BC0 checked bytes and 1,187 relocations; inventmn passes 0xFF2C checked
bytes and 2,794 relocations. All 149 baseline object allocated sections and
relocation identities are unchanged. Every allocated PAL section also
agrees with the baseline in bytes, address, size and BSS extent.

The refreshed report is 6,743 matched / 117 guarded / 10 asm-only / 2 fuzzy.
All 6,872 per-function classifications equal the baseline. Neither unit's
coverage changes: dngmenu 39/8/1/0 and inventmn 109/7/0/0. No function is
promoted. The only game-source change is the guarded ResetAddress refinement.

Receipts under `.private/dnginv-r1/`: `baseline-build.log`,
`baseline-objects.log`, `baseline-progress.log`, `baseline-coverage.log`,
`final-build.log`, `final-objects.log`, `final-compare.log` / `.json`,
`final-progress.log`, `final-coverage.log`, and `final-functions.tsv`.
The five-line dungeon declaration comments remain untouched.
