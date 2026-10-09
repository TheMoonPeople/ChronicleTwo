# October 8 midday round 1

This is a historical checkpoint. MenuInventKey is now native and exact;
see [notes.md](notes.md) and [night-20261008.md](night-20261008.md).
Five guarded inventory functions remain.

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

## ResetAddress

`ResetAddress__15CInventUserDataFv` improves from 14/48 to 13/48 differing
words and retains the 0xC0 native and retail extents. Its row pointer is
declared first, the real photo index is initialized to zero, and the pointer
is then assigned the existing `photo_work` array. Each iteration uses ordinary
`photo[index].image = work[index]`; there is no pointer induction, type pun,
byte-offset indexing or dead store. This strictly better draft is retained
under the original `NONMATCHING` guard.

The first `move a3,zero` now agrees at +0x0. Three setup words at +0x4..+0xC
still differ: MWCC computes the invariant work-buffer base before initializing
its two derived offsets. The eight-assignment unrolled body at +0x10..+0x78
is exact. The remainder still reuses that base instead of recomputing it at
+0x94, moving the subsequent two-photo loop by one instruction. Its skip
branch targets +0xB4 instead of retail's +0xB8, followed by padding before the
matching return. No complete-function match is claimed.

Initializing the index before declaring the row pointer gives twenty-one
words, including a changed register map; declaring the pointer first and
assigning it after initialization gives thirteen. References to the picture,
image field or row, a picture pointer, a local pixel pointer, a whole-array
pointer and row-address conversion leave the original fourteen. The
initialized-index do loop does not receive the same eight-way unroll and
shrinks to 0x38, so its smaller body is rejected. Optimizer controls either
grow the function or disturb the correct unrolled body.

On the improved draft, comma initialization, a while loop, an increment in
the body, a picture/pixel pair, explicit first-byte addressing and a whole
array pointer all leave thirteen. Using `<= 29` changes unroll/remainder
lowering and worsens to thirty-three. The retained source uses the simplest
measured improved form. Receipt: `reset-retained-r1/` and `reset-retained.log`.

## MenuInventKey

`MenuInventKey__Fv` remains guarded at 8/524 words, 0x824 native bytes in a
0x830 manifest reservation. All established code outside the negative-card
padding loop remains unchanged. The round-0 initializer placement retains
card in a saved register across the number-X float conversion; retail loads
it into `a2` afterward. Later initialization produces a caller-saved induction
register, but assigns card/name-offset/position-offset to the wrong registers.

Explicit name and coordinate indices, either index alone, declaration at
function/key/message scopes, a local padding scope and register-qualified
integer counters all reproduce the ten-word variant. Sharing card across
both loops gives twenty-seven; sharing line across the two switch cases gives
forty-three. Delaying line initialization to the geometry block gives fifty-four.
Moving the number-X conversion after padding gives twenty-four and changes
the conversion schedule. Long card adds two words; long line or top changes
much more of the function. None beats the retained eight.

A genuine row reference and explicit postincremented coordinate index grow
past the retail extent. A separate saved-top negativity guard before the do
loop leaves twelve. Checking both nonzero and negative adds a redundant
branch and yields 146; that candidate is rejected. No source change to this
function is retained. Its already documented m2c jump-table failure remains;
these loop results use the retail instruction comparison.

## Fresh diagnostic ledger

| Probe | Result |
|---|---|
| `key-declare-card-arrays` | 10 of 524 words differ, 0x824 bytes against retail's 0x830 |
| `key-declare-card-key` | 10 of 524 words differ, 0x824 bytes against retail's 0x830 |
| `key-declare-card-message` | 10 of 524 words differ, 0x824 bytes against retail's 0x830 |
| `key-declare-card-top` | 10 of 524 words differ, 0x824 bytes against retail's 0x830 |
| `key-explicit-indices` | 10 of 524 words differ, 0x824 bytes against retail's 0x830 |
| `key-explicit-indices-pos-first` | 10 of 524 words differ, 0x824 bytes against retail's 0x830 |
| `key-explicit-pos-only` | 10 of 524 words differ, 0x824 bytes against retail's 0x830 |
| `key-explicit-slot-only` | 10 of 524 words differ, 0x824 bytes against retail's 0x830 |
| `key-geometry-array` | 24 of 524 words differ, 0x824 bytes against retail's 0x830 |
| `key-index-condition` | 146 of 524 words differ, 0x82C bytes against retail's 0x830 |
| `key-line-init-geometry` | 54 of 524 words differ, 0x824 bytes against retail's 0x830 |
| `key-local-scope-padding` | 10 of 524 words differ, 0x824 bytes against retail's 0x830 |
| `key-long-card` | 12 of 524 words differ, 0x824 bytes against retail's 0x830 |
| `key-long-line` | 340 of 524 words differ, 0x81C bytes against retail's 0x830 |
| `key-long-top` | 416 of 524 words differ, 0x820 bytes against retail's 0x830 |
| `key-nonnegative-empty-test` | 12 of 524 words differ, 0x824 bytes against retail's 0x830 |
| `key-register-card` | 10 of 524 words differ, 0x824 bytes against retail's 0x830 |
| `key-register-line` | 10 of 524 words differ, 0x824 bytes against retail's 0x830 |
| `key-row-reference` | 0x834 bytes, retail 0x830 |
| `key-shared-card-lifetime` | 27 of 524 words differ, 0x824 bytes against retail's 0x830 |
| `key-shared-line-and-card` | 43 of 524 words differ, 0x824 bytes against retail's 0x830 |
| `key-two-explicit-pos-stores` | 0x834 bytes, retail 0x830 |
| `reset-common_subs-off` | 0xF8 bytes, retail 0xC0 |
| `reset-delayed-address-element` | 13 of 48 words differ |
| `reset-delayed-base-assignment` | 13 of 48 words differ |
| `reset-delayed-base-whole` | 13 of 48 words differ |
| `reset-delayed-comma-init` | 13 of 48 words differ |
| `reset-delayed-le-bound` | 33 of 48 words differ |
| `reset-delayed-loop-increment` | 13 of 48 words differ |
| `reset-delayed-while` | 13 of 48 words differ |
| `reset-direct-row-address-cast` | 34 of 48 words differ |
| `reset-image-field-reference` | 14 of 48 words differ |
| `reset-image-row-reference` | 14 of 48 words differ |
| `reset-index-before-base-do` | 47 of 48 words differ, 0x38 bytes against retail's 0xC0 |
| `reset-index-init-before-base` | 21 of 48 words differ |
| `reset-loop_invariants-off` | 40 of 48 words differ |
| `reset-owner-pointer` | 14 of 48 words differ |
| `reset-picture-pointer` | 14 of 48 words differ |
| `reset-picture-reference` | 14 of 48 words differ |
| `reset-pixels-local` | 14 of 48 words differ |
| `reset-propagation-off` | 0xE0 bytes, retail 0xC0 |
| `reset-reversed-bound` | 14 of 48 words differ |
| `reset-row-address-cast` | 14 of 48 words differ |
| `reset-row-after-photo-index` | 13 of 48 words differ |
| `reset-strength_reduction-off` | 46 of 48 words differ, 0xB8 bytes against retail's 0xC0 |
| `reset-while-base-after-index` | 21 of 48 words differ |
| `reset-whole-array-pointer` | 14 of 48 words differ |

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
