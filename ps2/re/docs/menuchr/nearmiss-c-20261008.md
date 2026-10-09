# Costume and temporary-scene near-miss assessment

Historical probe record. Current exact matches and guarded remainders are
listed in [notes.md](notes.md); later promotions are documented in
[night-20261008.md](night-20261008.md).

Base `3d49d02`, image `chronicletwo_dev:sf-d8bf13c`, canonical MWCC
3.0-011126 and the checked-in Satan's Fiddle configuration. Both targets
remain guarded. The only retained implementation change improves
`CMenuCostumeSel::Draw` from **71/568** to **64/568** relocation-masked
words; its body remains `0x8D0` in retail extent `0x8E0`.

The fresh `decompile.sh`/m2c outputs agree with the already documented
camera, model, costume-row, arrow, cursor, and help-box sequence and with
the temporary-scene construction sequence. The existing
[menuchr notes](notes.md), [scene type notes](../scenesnd/notes.md),
[scene-slot notes](../scene/notes.md), and
[model-list notes](../mdslist/notes.md) supply the dependent types and
callee definitions; no dependency or field declaration changes.

## Costume arrow initialization order

The three independent coordinate assignments now compute `rightX`, then
`leftX`, then `arrowY`, keeping their original declaration order. The
right origin remains `lineRect.right + 0x49`; the pulse remains the
absolute value of `6.0f * sinf(line_wave[i])`. This preserves the row's
coordinates and every draw call while improving the conversion and
shadow-argument schedule. `Begin` uses the existing `MG_PRIM_SPRITE` enum
for the unchanged retail primitive value six.

With the previously documented private 36.0f (`0x42100000`)
evaluate-first selector restricted to `DrawMenuFillBox__Fffffiiii`, the
same assignment reorder improves **18/568** to **11/568**, body `0x8D4`.
That row is not added to the checked-in profile. The private residual
lies at `+0x2AC..+0x2D8`: the absolute-pulse merge has an extra `nop`, the
right-origin load uses `a2` instead of `v1`, and coordinate setup remains
scheduled differently. The later `+0x2DC..+0x2F8` conversion/shadow
sequence now matches. This is a diagnostic control, not a promotion.

New assignment permutations, declaration permutations, and initialized
declarations establish that the retained order is the useful source
change. Moving declarations before the loop, pulse calculation,
absolute-value branch, or row-Y calculation leaves the private 11-word
residual. A named shared shadow Y likewise leaves 11. Chained X
assignments produce 21 or 30; computing Y in a call produces 547.
Reversing the right-origin addition gives 12; literal-left absolute-value
testing gives 20. Floating constructor/cast spellings of the existing
zero, pulse, origin, and shadow literals leave 11.

Unsigned row indexing gives 73 words with the production profile.
Unsigned/narrowed Y values change conversions and exceed retail's extent.
A named integer right origin after the absolute-value branch leaves the
private 11 words; moving it before the pulse produces 230. No integer
width change is retained.

Retail-local `tilergba_5203`, `putw_5262`, and
`MenuCosutumeLoadPhase` definitions made private static leave 11 in the
control context. A static const definition of `convtbl_5238` produces
120. None supplies a linkage-driven correction. The retained source has
no new helper, temporary array, pragma, profile row, or type overlay.

## Temporary-scene constructor scheduling

`MenuItemCharaDataLoadEndCheckAfter` remains **2/220** words, body `0x368`
in extent `0x370`. It constructs a local `CScene` directly; this target
is not one of the placement-new parks. The existing documented scene
size is `0x10550`, and its model-list member is at `0x23D0`. The scene
starts at stack offset `0x70`, so `CMdsListSet::Initialize` receives
`sp + 0x2440` (9280).

The native draft prepares this argument at `+0xF4`, in the preceding
message-constructor loop's branch delay slot. Retail has a `nop` there
and prepares the argument at `+0xFC`, in the initializer call's delay
slot. These remain the only two differences. Prior scene lifetime,
constructor-definition, and inline-depth probes are documented in
[round one](midday-r1-assessment.md) and are not repeated.

A new unsigned slot counter leaves those two differences and adds an
unsigned loop-comparison difference, yielding **3/220**. A private
static definition of the retail-local `convtbl_4621` leaves **2/220**.
Neither edit is retained; no shared constructor/header proposal is
supported by this wave.

## Receipts

Receipts are under `.private/nearmiss-c/`: the fresh m2c outputs,
`menuchr-before/`, `retained-menuchr/`,
`costume-assign-rightX-leftX-arrowY-original/` (private control),
`scene-unsigned-loop/`, `menuchr-static-data-convtbl_4621/`, and the
per-case source, object, profile, comparison, and instruction files.
`ledger.jsonl` records successful native compilations. The retained
all-draft comparison preserves all 77 existing native matches and the
other ten guarded scores; per-function bytes and relocation identities
change only for costume Draw. All 149 production object hashes and the
PAL ELF hash equal the baseline. Object checks remain 147/149, with only
the existing nd_meswin/actscript failures; PAL retains only the `0x26`
differing `.text` bytes. Refreshed progress remains 6,745 matched,
115 guarded, 10 assembly-only, and two fuzzy functions. Receipts are
`final-objects.log`, `final-build.log`, `final-progress.log`,
`final-hashes.json`, and `final-validation.json`.
