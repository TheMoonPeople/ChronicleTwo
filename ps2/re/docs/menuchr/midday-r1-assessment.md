# menuchr mid-day round-one assessment

Historical probe record. Current exact matches and guarded remainders are
listed in [notes.md](notes.md); later promotions are documented in
[night-20261008.md](night-20261008.md).

October 8, 2026. Worktree `/home/dylan/projects/chronicletwo-menuchr-midday`,
branch `work/dc2-menuchr-midday`, required base `a741e2e`.
Image `chronicletwo_dev:sf-d8bf13c`, `JOBS=4`.
The [round-zero assessment](midday-assessment.md) supplies the previous
function reconstruction and rejected trials; this document records new
round-one hypotheses and supersedes its retained star-draw score.

## Result

No function is promoted. The only retained source edit changes the guarded
`MenuCharaChangeStarDraw` from 300/368 differing words to **285/368**.
All 77 previously matching menuchr functions stay matched; all eleven
existing guards remain. The header and checked-in compiler profile are
byte-identical to the round-one base. No assembly, shared header, toolchain,
promotion ledger, or another unit's profile row is edited.

Scores use the existing relocation-masked draft checker and the complete
retail manifest extent, including zero padding. They are diagnostic;
none of the nonzero results below qualifies as a matching decompilation.

| Focus function | Base / retained | Best private | Remaining blocker |
| --- | ---: | ---: | --- |
| `MenuItemCharaDataLoadEndCheckAfter` | 2/220 | 2/220 | Temporary-scene model-list constructor argument scheduling |
| `CMenuChrCngMenu::EnterDataMenu` | 11/388 | 9/388 | NPC command index/stride allocation; named array view adds an address setup |
| `CMenuCostumeSel::Draw` | 71/568 | 18/568 | Absolute-pulse merge, integer conversion, and arrow-shadow argument schedule |
| `MenuCharaChangeStarDraw` | 300/368 → **285/368** | 285/368 | Center/rectangle storage, manager and float register roles, drawing schedule |

## Evidence and dependencies

All four targets are inspected through `decompile.sh` using m2c; outputs
are `.private/menuchr-r1/m2c-{scene,enter,costume,star}.c`, with stderr saved
alongside them. Existing [menuchr notes](notes.md),
[scene type notes](../scenesnd/notes.md),
[scene-slot notes](../scene/notes.md),
[model-list notes](../mdslist/notes.md), and
[NPC configuration notes](../npccfg/notes.md) supply the already analyzed
types and callees. No previously decompiled callee is reconstructed again.

`mgAbs(float)` is the existing inline absolute-value helper in
`mapload.hpp`; it returns the negation only when its argument is less than
zero. Its declaration identifies `mgAbs__Ff`, address `0x00163050`, extent
`0x30`. It is available through an existing menuchr include, so testing it
requires neither a new helper nor an unowned-file edit.

## Temporary-scene construction

`CScene` has size `0x10550`; its documented model-list member is at
`0x23D0`. The local scene starts at stack offset `0x70`, making the
`CMdsListSet::Initialize` argument `sp + 0x2440` (9280).
The preceding eight-element message-constructor loop ends at `sp + 0x243C`.
The retained draft prepares the list address in that loop's branch delay
slot at function offset `+0xF4`; retail prepares it in the following call's
delay slot at `+0xFC`. Those two words remain the entire base difference.

New caller-local probes S01–S05 narrow the character-pointer lifetime,
reorder its initialization, name the selected conversion-table row, move
its declaration before the scene, and move the slot counter outside the
`for` initializer. Their scores are respectively 11, 18, 2, 2, and 11 of
220 words. None resolves the constructor schedule.

S06/S07 use scoped inline depths 8/3 and preserve 2/220. Depth 2 (S08)
changes deeper construction and produces 145/220, body `0x360` versus
retail extent `0x370`. Scoped optimization level 2 (S09) grows the body to
`0x414` and is rejected. All these probes remain private; no pragma or
caller-local rewrite is retained. Earlier temporary-copy, reference,
explicit-member-initializer, and out-of-class-constructor trials are not
repeated.

## NPC command indexing

The four command messages occupy consecutive four-byte slots beginning at
menu offset `0x22C`. The existing signed ability count at
`NPC_BASE_DATA + 0x30` supplies the bound; costs begin at `+0x32`.
The proven palette, party, message-reset, and independent cost loops are
preserved in every NPC probe.

N01/N02 test four-byte command records with signed/unsigned message IDs.
N03 tests a typed record-array view alongside the existing integer API
view. N04/N05 test unsigned message arithmetic and an unsigned flat array.
All leave 11/388. The temporary `NPC_COMMAND_MESSAGE` record has one
message field at offset zero and an asserted size of four; this trial
type and all header changes are discarded.

N06–N08 bind an indexed message or command record by reference/pointer
before computing its value; all retain 11. N09 uses an unsigned slot with
explicit signed ability-count comparisons and produces 13. N10 names a
typed command-array pointer and reaches nine, reproducing the earlier
array-view limitation: it emits `addiu a1,s1,556`, shifts the first loop,
and uses `a3` for its stride. It does not recover retail's direct
menu-relative store with stride `a1` and command index `a2`.

N11–N14 distinguish the ability ordinal from the command display slot,
including declaration-order and typed-record variants. They produce
71/72/71/71 words and bodies equal to the `0x610` extent. Scoped level 2
(N15) grows the body to `0x704`. None is retained; the source stays at
11/388, body `0x608` in extent `0x610`. A useful future hypothesis must
recover the index/stride allocation without a separate array-base setup.

## Costume arrows and nested selectors

C00 privately reproduces 18/568 with the known 36.0f evaluate-first row
scoped to `DrawMenuFillBox__Fffffiiii`. Its body is `0x8D4` in extent
`0x8E0`. The remaining differences are the already identified
`+0x2AC..+0x2F8` merge, right-origin conversion, and shadow-coordinate
preparation. This row is not accepted or committed for an unmatched body.

The nested-selector implementation in
`satansfiddle-nested-arguments.patch` inspects sibling call expressions of
an outer call and their formal arguments. The arrow calls currently pass
`4.0f + leftX/rightX`, `4.0f + arrowY`, and a rectangle variable. Their
four-pixel offsets are arithmetic operands, and the wave call precedes
them. Neither arrow has a sibling call identity that distinguishes its
offsets. Naming a coordinate does not create one. The earlier rejected
callee-scoped arithmetic selector is not repeated, and no artificial
call or unsupported profile row is introduced.

C01/C02 use the existing `mgAbs` helper at wave initialization or as an
assignment back to the wave; both produce 390/568, body `0x8CC`.
Applying `mgAbs` before multiplying by six (C03) produces 47/568.
Changing the branch arm, expressing negation as subtraction, or declaring
coordinates before the merge (C04–C06) leaves 18. C04 also changes
unordered comparison behavior and is rejected independently of its score.
Using `mgAbs` separately in both arrow coordinates (C07) grows the body to
`0x8EC`. Separating the signed pulse from its magnitude (C08) leaves 18.
Scoped level 2 (C09) grows the body to `0xA54`.
The source and profile stay unchanged at 71/568.

## Guarded star drawing

The retail short texture rectangle is constructed through
`Set__9mgRect<s>Fssss`, then its halfword fields are read from the stack.
The default draft instead inlines the setter and folds its coordinates
and eight-pixel dimensions into constants. Scoped inline depth 1 or 0
(T01/T02) restores the setter call and field reads but produces an
oversized `0x5D4` body; depth 3 (T03) preserves the base 300/368.
The setter's existing header definition is not changed or manually
outlined, and no shared-header patch is proposed from this incomplete
result.

T04/T05 directly index sparkle records, with or without a named alpha;
T06/T08 use a center-coordinate array, alone or with direct indexing.
All retain 300. T07 gives the ring angle its lifetime before size and
produces 294, restoring their retail `f20`/`f21` roles. T09 combines that
with direct indexing and remains 294. Adding the named manager to direct
indexing (T10) produces 363. Caching texture bounds/conversions or moving
the center copy (T11–T14) produces 300/303/300/304. Native zero-initialized
center/UV arrays or structures (T15–T18) all leave 300.

Early angle declarations with the original read location (T19–T21)
preserve 294. Giving the circle radius its lifetime before the pulse wave
alongside that angle lifetime (T22) reaches 285, body `0x584` in extent
`0x5C0`. T23 preserves the original angle read location and also reaches
285; **this source is retained**. Moving only the radius declaration,
without its initialization, leaves 294 (T24).

The retained change adds an earlier declaration for the existing angle
and moves the existing radius initialization. It introduces no extra
calculation, call, helper, pragma, or profile row. The center stack slot
and its interior address, manager/primitive registers, short-rectangle
storage, and later floating schedule still differ. The function keeps its
guard; no complete native match is claimed.

## Final validation

Private receipts are under `.private/menuchr-r1/`:

- `baseline/{build.log,objects.log,drafts.log,coverage.txt,hashes.json}`:
  fresh build of the required base, checks, and raw object hashes.
- `baseline/scene-enter.diff`, `baseline/star.diff`, and the m2c files:
  instruction and decompiler evidence.
- `s01`–`s09`, `n01`–`n15`, `c00`–`c09`, `t01`–`t24`:
  58 private probes, with sources, hypotheses, profiles when applicable,
  compiled objects, and scores; `experiments.json` is their index.
- `final/{build.log,objects.log,drafts.log,coverage.txt,hashes.json,acceptance.json}`:
  retained-state integrated validation and asserted comparisons.

Final drafts have **77 MATCH / 11 DIFF / 0 missing**. Only the star-draw
score changes; every other function retains its baseline score.
The complete menuchr object passes, with `0x11CC4` allocated bytes and
3,745 resolved relocations. All **149 raw game-unit object SHA-256 hashes
equal baseline**, because the retained source remains guarded.

The complete check accepts **147/149 units**. The same one-problem failures
remain in `nd_meswin/DrawMesWin` and `actscript/_SHOT`. PAL verifier lines
equal baseline exactly: `.text` differs by `0x26` bytes, first at
`0x0015C5AD`; the other nine file-backed sections and BSS end
`0x01F64A00` pass. The build and complete-project checker therefore retain
their expected nonzero exit status; no full-PAL retail pass is claimed.

Coverage is unchanged: **6,688 matched / 119 guarded / 63 assembly-only /
2 fuzzy**, with menuchr **77 / 11 / 0 / 0**. The upstream merge in this
round's base changes the guarded/assembly classification from the older
round-zero figures; those older global split counts must not be carried
forward. There are no unowned-file proposals, network writes, or contacts.

## Palette quantization loop in the `EnterDataMenu` draft

The guarded draft walks the copied character-change palette by index (`colors[palette_index]`) instead
of incrementing a `PaletteColor *`, because pointer induction is not an allowed source form. With the
indexed loop the draft compiles to 0x620 bytes (retail 0x610); the pointer walk gave 0x608 bytes with
15/388 differing words. Both an element pointer and an array reference per iteration give 0x620. The
remaining blocker is unchanged: the NPC index/stride allocation recorded above.
