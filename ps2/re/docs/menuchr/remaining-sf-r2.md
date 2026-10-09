# Remaining menuchr guards on the merged Satan's Fiddle base

Historical probe record. Current exact matches and guarded remainders are
listed in [notes.md](notes.md); later promotions are documented in
[night-20261008.md](night-20261008.md).

Lane `menuchr-r2`, October 8, 2026. Worktree
`/home/dylan/projects/chronicletwo-menuchr-20261008`, branch
`work/dc2-menuchr-r2-20261008`, base
`2f71f10c530becb9ed222253646514480b9c087d` (integration i15).
Image `chronicletwo_dev:sf-24490d0`, `JOBS=3`.
This assessment supersedes the pre-merge scores in [round2.md](round2.md).

## Current measurements

The initial clean build and object check reproduce i15: PAL `.text` has
`0x26` differing bytes, first at `0x0015C5AD` in
`nd_meswin/DrawMesWin__6ClsMesFv+0x6FD`. All other file-backed sections and
BSS end `0x01F64A00` pass. The object check accepts 147/149 units, failing
only `nd_meswin/DrawMesWin__6ClsMesFv` and
`actscript/_SHOT__FP12RS_STACKDATAi`, with one problem in each.
Coverage starts at 6,681 matched /174 guarded /15 asm-only /2 fuzzy;
menuchr has 74 matched /14 guarded.

All scores below were remeasured with the repository Satan's Fiddle adapter
and canonical compiler flags, compiling all drafts with `NONMATCHING` and
`UNMATCHING`. Plain `draft.sh` uses wibo and is a separate diagnostic.
Scores count differing 32-bit words across the retail extent, including
zero padding. They do not alone prove resolved relocation or unit acceptance.

| Target | Before | Retained after | Best private probe |
| --- | ---: | ---: | ---: |
| `KeyStep__12CMosBookMenuFv` | 2/340 | 2/340 | same; placement-new |
| `LoadBGNPCModel__15CMenuChrCngMenuFi` | 2/120 | 2/120 | same; placement-new |
| `LoadMenuData__15CMenuCostumeSelFP9mgCMemoryPi` | 2/228 | 2/228 | same; placement-new |
| `MenuItemCharaDataLoadEndCheckAfter__FPP17MENU_BGREAD_INFO2i` | 2/220 | 2/220 | same; constructor scheduling |
| `MenuMemoryDivide__FP9mgCMemoryPP9mgCMemoryi` | 18/116 | 18/116 | same |
| `Draw__15CMenuCostumeSelFv` | 71/568 | 71/568 | 18/568; complete unit fails |
| `Draw__12CMosBookMenuFv` | 905/948 | 905/948 | same |
| `KeyStep__14CMenuMosSelectFv` | 1154/1660 | 1154/1660 | same |
| `KeyChangeMain__15CMenuChrCngMenuFv` | 1998/2152 | 1998/2152 | same |
| `MenuMonsterLoadBG__FP9mgCMemoryPP17MENU_BGREAD_INFO2ii` | 118/124 | **0, promoted** | **complete unit passes** |
| `EnterDataMenu__15CMenuChrCngMenuFPUc` | 331/388 | 331/388 | same |
| `MenuCharaChangeStarDraw__Fv` | 361/368 | 361/368 | same |

`MenuCharaChangeInit` and `MenuCostumeInit` retain their guards and were
excluded from experiments as requested. No VU0 implementation was changed.
No shared header, profile row, promotion ledger, or other unit was changed.

## Accepted loader source

Retail retains the model filename pointer in s3 and the script filename
pointer in s4. The first explicit pointer lifetime reduces 118 to 101
words. Giving the script pointer its lifetime after the successful model
lookup reduces that to 62 and restores the entire prologue and all
instructions through `+0xE4`, including the `0x150` stack frame.

m2c shows the nonzero `LoadFileBG` path enclosing allocation and optional
script loading, before a common return. Restoring this positive branch
reduces 62 to 6 words. The last six differences are initial read argument
setup at `+0xE8`, `+0xF0`, `+0xF4`, `+0xF8`, `+0xFC`, and `+0x104`.
Computing `u_long128 *model_data = stack->stGetTop()` before the outer call
restores all six words. The emitted body is `0x1E4`, with zero tail padding
inside retail's `0x1F0` extent.

The guard and assembly marker were removed manually. Canonical wrapper
compilation, `fixup_sections.sh`, and `check_objects.py menuchr -v` pass
`0x11CDC` allocated bytes and 3,734 resolved relocations. Private experiment
sequence: R2-E15 through R2-E19. No selector is needed.

## Parked cases and reconsideration triggers

### Three placement-new branches

The full SF draft diff confirms precisely the two-word saved-pointer
copy/null-branch reversal in each case:

- `LoadBGNPCModel`: `+0x50/+0x54`, saved pointer s1.
- `LoadMenuData`: `+0x54/+0x58`, saved pointer s4.
- `CMosBookMenu::KeyStep`: `+0x368/+0x36C`, saved pointer s0.

Retail branches on v0 and copies it in the delay slot; the compiler copies
first and branches on the saved pointer. All three were parked immediately,
without local source changes. Reconsider after `placenew-sf` supplies a
validated general fix, and recheck each complete unit independently.

### Temporary scene construction

`MenuItemCharaDataLoadEndCheckAfter` is not a placement-new case. Retail has
a nop at `+0xF4` and `addiu a0,sp,9280` in the `CMdsListSet::Initialize`
call delay slot at `+0xFC`; the draft swaps these two words. Positive mode
scoping of the temporary scene leaves both differences unchanged (R2-E12).
Earlier explicit member initialization and an out-of-class inline model-list
constructor also failed, as recorded in round2. Reconsider after a compiler
scheduling discovery or a natural constructor change with all other 148
objects proven byte-identical. No shared-header probe was retained.

### Costume drawing

One private stable selector suffices to reproduce the sweep's best 18-word
score: `menuchr.cpp`, `Draw__15CMenuCostumeSelFv`, binary32 `0x42100000`
(36.0f), callee `DrawMenuFillBox__Fffffiiii`, `evaluate_first: true`.
It corrects the help-box argument schedule and final restore sequence.
The remaining 18 words are entirely at `+0x2AC..+0x2F8`: wave merge,
left/right arrow coordinates, integer-to-float conversions, and shared
4.0f shadow offsets. The emitted body becomes `0x8D4` in extent `0x8E0`.

Manual guard removal with this private row fails the complete unit only in
costume Draw, first at `0x002C1C7C` (`+0x2AC`). There are no unit data or
resolved relocation problems. The guard was restored and the row discarded.
Naming shadow Y, the right floating/integer origin, the sine result with
original amplitude operand order, or narrowing the 55.0 origin leaves 18
words. Splitting the sine into a compound multiplication gives 40 words;
initializing coordinate declarations gives 22; a conditional-expression
absolute value gives 390. A callee-scoped 4.0f arithmetic-operand selector is
rejected as unconsumed; an unscoped 4.0f row compiles but does not improve
18. These are R2-E01..E10, E14, and E20, all restored.

Reconsider with a natural coordinate-lifetime formulation that removes the
extra merged-block nop, converts the right origin through f1, and computes
right X before materializing the shadow offset. The 36.0f row may accompany
that source only once the complete unit passes. Repeating the rejected
local naming/casting forms or adding unsupported arithmetic selectors is
not supported by this evidence.

### Memory partitioning

The original `18/116`, body `0x1C4` in extent `0x1D0`, remains. Expressing the
initial top as typed array indexing through manager fields worsens to 31
words (R2-E11); it was restored. Earlier declaration scope, rounding operand
order, and buffer declaration moves did not help. Reconsider when a natural
form coalesces the incoming manager and loop buffer in s1 while retaining
size in s4 and table/list induction in s2/s3.

### Larger guarded drafts

These remain at their newly confirmed SF scores and existing source:

- Monster-book Draw needs the explicit retail panel/heading/drop sequence,
  first under-panel index, and padded eighth icon slot. Folded draft loops
  and repeated font setup require a behavioral reconstruction before
  compiler-state rows can establish a match.
- Monster-select KeyStep needs region-by-region state dispatch and induction
  correspondence; its `0x19E8` body in `0x19F0` extent still shifts most
  instructions after the matching prologue.
- Party-change KeyChangeMain needs corresponding action/NPC ability branches;
  its `0x2178` body in `0x21A0` extent remains a control-flow problem.
- EnterDataMenu retains corrected field/texture context from the first lane,
  with `331/388`, body `0x5F4` in `0x610` extent. Reconsider with typed palette
  rows, retail's band bound `<33`, and independent ability/filler loops,
  without repeating the earlier rejected control-flow rewrites.
- Star Draw retains `361/368`, body `0x580` in `0x5C0` extent. Reconsider with
  the retail texture-manager lifetime, float operation order, and texture
  coordinate lifetime; the existing behavioral draft has a different
  prologue and drawing schedule.

## Receipts and final acceptance

Private experiment ledger: `.private/experiments-menuchr-r2.md`.
Baseline receipts: `.private/receipts/r2-baseline/`.
The loader's focused complete-unit receipt is
`.private/receipts/r2-e19-game/objects.log`.
Final receipts are under `.private/receipts/r2-final/` and are not committed.
Final integrated verification reproduces every i15 verifier line, including
`.text FAILED 0x26 bytes differ` and the same first differing address. The
object failure set and both one-problem lists are identical to baseline.
The other 148 complete object files are byte-identical by SHA-256; only
`menuchr.cpp.o` changes. The promoted symbol matches in both SF and plain
wibo draft checks and in the canonical complete-unit check.

Final coverage is 6,682 matched /173 guarded /15 asm-only /2 fuzzy;
menuchr is 75 matched /13 guarded. The SF final draft has 75 MATCH /13 DIFF,
with no score change except the promoted loader. No whole-image retail pass
is claimed: the two independent baseline text failures remain.

Receipt files:

- `build.log`: final integrated build and section verifier.
- `objects.log`: all 149 complete-unit checks and unchanged problem lists.
- `menuchr-unit.log`: accepted focused canonical loader promotion.
- `sf-drafts.log`: final deterministic all-draft scores and loader instructions.
- `plain-draft.log`: common plain-wibo draft diagnostic.
- `coverage-build.log`, `coverage.log`: regenerated objdiff and source coverage.
- `object-hashes.json`: final raw object SHA-256 map, compared with baseline.
- `acceptance.json`: assertions for verifier, failures, all target scores,
  unchanged profile, unchanged other-object hashes, and coverage.
