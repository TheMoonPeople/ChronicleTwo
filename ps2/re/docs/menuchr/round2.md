# menuchr lane assessment — 2026-10-08

Historical probe record. Current exact matches and guarded remainders are
listed in [notes.md](notes.md); later promotions are documented in
[night-20261008.md](night-20261008.md).

Worktree: `/home/dylan/projects/chronicletwo-menuchr-20261008`.
Branch: `work/dc2-menuchr-20261008`. Base:
`0abce376a0d178797f62ae7e0e67b407fb67bd62`.

## Promotions and coverage

- `MenuMonsterBoxDraw__Fv`: draft 0 differing words before and after. Its
  initial game object reversed the 350.0f/260.0f setup in four instructions,
  producing a linked mismatch. `float(350.0)` makes both forms match.
  Retail extent 0x230.
- `InitMainCharaBG__FiP9mgCMemoryi`: 5/308 words to 0; body 0x4C4 within
  retail extent 0x4D0. A typed user-data local before the default monster
  store gives retail's v1 halfword stores.

Function coverage changes from 6651 matched / 204 guarded / 17 asm-only to
6653 / 202 / 17. menuchr changes from 70 matched / 18 guarded to 72 / 16.
The original draft check failed compilation; the comparable before scores
below are after repairing stale field names without changing function layout.

## Guarded functions and park triggers

Scores are differing 32-bit words / retail words, followed by emitted code
size / retail manifest extent. An extent can include zero padding. `same`
means the before score and size remain unchanged.

### `MenuMemoryDivide__FP9mgCMemoryPP9mgCMemoryi`

- Before: 18/116; 0x1C4 / 0x1D0. After: same.
- Blocker: Register allocation.
- Trigger: Revisit when a natural formulation coalesces incoming memory and buffer into s1 while size stays in s4; declaration moves and rounding operand order did not do so.

### `LoadBGNPCModel__15CMenuChrCngMenuFi`

- Before: 2/120; 0x1E0 / 0x1E0. After: same.
- Blocker: Placement-new null branch.
- Trigger: Wait for the dedicated placement-new lane to reproduce the v0 branch with the saved-pointer copy in its delay slot.

### `MenuMonsterLoadBG__FP9mgCMemoryPP17MENU_BGREAD_INFO2ii`

- Before: 118/124; 0x1DC / 0x1F0. After: same.
- Blocker: Stack and saved-register allocation.
- Trigger: Revisit with evidence for retaining both model/script array addresses in s3/s4 and the 0x150 retail frame; explicit block-count locals compile identically to the existing helper.

### `MenuCostumeInit__FP9mgCMemoryPii`

- Before: 165/184; 0x2BC / 0x2E0. After: same.
- Blocker: Placement-new plus constructor lowering.
- Trigger: Wait for the placement-new result first, then reconstruct constructor field order: retail obtains chara_data and clears MenuCosutumeLoadPhase inside construction, while the draft does so afterward.

### `MenuItemCharaDataLoadEndCheckAfter__FPP17MENU_BGREAD_INFO2i`

- Before: 2/220; 0x368 / 0x370. After: same.
- Blocker: Inline-constructor scheduling.
- Trigger: Revisit when CMdsListSet construction places addiu a0,sp,9280 at +0xFC (call delay slot) instead of +0xF4 (previous loop branch delay slot). Explicit CScene member initialization and an out-of-class inline constructor do not change it.

### `LoadMenuData__15CMenuCostumeSelFP9mgCMemoryPi`

- Before: 2/228; 0x390 / 0x390. After: same.
- Blocker: Placement-new null branch.
- Trigger: Wait for the dedicated placement-new result; the CActionChara allocation loop has the same two-word move/branch reversal.

### `MenuCharaChangeInit__FP9mgCMemoryPii`

- Before: 236/316; 0x4F0 / 0x4F0. After: same.
- Blocker: Placement-new plus native constructor allocation.
- Trigger: Wait for the placement-new result; the first menu allocation differs at +0xD8/+0xDC before the remaining register differences. Do not retry the blocked native construction now.

### `KeyStep__12CMosBookMenuFv`

- Before: 2/340; 0x54C / 0x550. After: same.
- Blocker: Placement-new null branch.
- Trigger: Wait for the dedicated placement-new result before retrying its CActionChara construction.

### `MenuCharaChangeStarDraw__Fv`

- Before: 361/368; 0x580 / 0x5C0. After: same.
- Blocker: Drawing and register scheduling.
- Trigger: Revisit with a natural body retaining retail saved-register roles (manager s0, not draft s5), float operation order, and texture-coordinate lifetime. Existing behavioral draft has a different prologue and drawing schedule.

### `EnterDataMenu__15CMenuChrCngMenuFPUc`

- Before: 370/388; 0x5F4 / 0x610. After: 331/388; 0x5F4 / 0x610.
- Blocker: Palette and NPC control-flow lowering.
- Trigger: Revisit with a typed palette-row representation that keeps the color cursor live in retail s3, the observed band-search bound <33, and the two successive ability/filler loops. Field accesses are corrected; attempted control-flow rewrites grew the body to 0x62C/0x634 and were reverted.

### `MenuMonsterBoxInit__FP9mgCMemoryPii`

- Before: 0x630 / 0x620 (oversized). After: MATCH once the empty
  `CCharaFrameMatching` constructor was removed from `character.hpp`; the
  integrated build kept every other object unchanged, and the function is promoted.

### `MenuCharaChangeDraw__Fv`

- Before: 4/492; 0x7B0 / 0x7B0. After: same.
- Blocker: Float-argument register order.
- Trigger: Revisit with compiler evidence that puts 300.0f in v1/f15 and 280.0f in v0/f14 at +0x4E8..+0x4F8. Earlier literal/local/wrapper probes documented in notes already failed; no repeat of those dead ends.

### `Draw__15CMenuCostumeSelFv`

- Before: 79/568; 0x8D0 / 0x8E0. After: same.
- Blocker: Float and drawing instruction scheduling.
- Trigger: Revisit after explaining the extra nop/float conversions at +0x2AC..+0x2F8 and integer/float register reversals beginning +0x420. Current body later omits enough code to finish 0x10 short of the retail extent.

### `Draw__12CMosBookMenuFv`

- Before: 905/948; 0xBE8 / 0xED0. After: same.
- Blocker: Drawing sequence and behavioral draft.
- Trigger: Revisit by reconstructing the explicit panel/heading/drop call sequence from m2c. Current loops fold retail calls, use a different first under-panel index, and map the eighth icon to icon zero; retail reads the padded slot. Retail also has repeated SetStr calls that require an evidenced natural API explanation rather than invented no-ops.

### `KeyStep__14CMenuMosSelectFv`

- Before: 1154/1660; 0x19E8 / 0x19F0. After: same.
- Blocker: Large state-machine lowering.
- Trigger: Revisit after isolating the first divergent state-machine region and preserving its branch graph and induction variables. The prologue agrees but the current structured draft shifts most subsequent instructions.

### `KeyChangeMain__15CMenuChrCngMenuFv`

- Before: 1998/2152; 0x2178 / 0x21A0. After: same.
- Blocker: Large state-machine lowering.
- Trigger: Revisit with a region-by-region correspondence of retail action dispatch and NPC ability handling. Stale battle_clear naming is fixed and all drafts compile; the remaining issue is generated control flow, not switch syntax.

## Shared-header proposal

The only supported shared-header patch is removal of the explicit empty
`CCharaFrameMatching` constructor from `ps2/include/character.hpp`.
`CCharacter2` retains its explicit `shadow_link.Initialize()` call. With
trivial default construction, the two `CActionChara` members no longer add
empty constructor calls before their explicit initialization.

```diff
-    /**
-     *
-     * Constructs the frame-matching holder.
-     *
-     */
-    CCharaFrameMatching() {}
```

The local probe changes `MenuMonsterBoxInit` from 0x630 bytes to MATCH inside
its 0x620 retail extent. Temporarily removing its guard with that header
change also passes `draft.sh menuchr --promote` and the isolated whole PAL
image. Both edits were reverted. The shared owner must check all affected
units before applying it; this lane neither commits that header nor promotes
the dependent function. The exact uncommitted patch is saved as
`.private/receipts/proposed-character.patch`.

Two other shared-header probes are rejected: adding explicit `mds_list_set()`
to the `CScene` initializer list, and moving `CMdsListSet` construction into
an out-of-class inline definition. Both retain the two-word scheduling
difference. All shared headers are restored.

## Validation and experiment receipts

Full logs are private inputs under this worktree's `.private/receipts/`:

- `draft-before.log`: initial compilation failure.
- `draft-e01.log`: comparable original draft scores after naming repair.
- `draft-final.log`: final function scores.
- `promote-batch1.log`, `build-batch1.log`, `objects-batch1.log`,
  `coverage-batch1.log`: validated two-function promotion batch.
- `promote-final.log`, `build-final.log`, `objects-final.log`,
  `coverage-final.log`: final retained source state.
- `draft-e11-shared.log`, `promote-e15-shared.log`: proposed construction
  patch's function and isolated-image checks.
- `proposed-character.patch`: exact shared-header proposal.
- `m2c-*.log` and `diff-*.log`: decompiler and instruction evidence.

The full PAL verifier passes its ten file-backed sections and memory end
0x01F64A00. All 149 complete-unit object checks pass. The draft-only run has
71 MATCH / 17 DIFF across all 88 functions: its extra difference is active
`MonsterBookDraw__Fv` (8 words), which matches in the validated game object.
It remains active; guarded coverage is sixteen, not seventeen.

The private experiment ledger is `.private/experiments-menuchr.md`.
Retained changes are two promotions, current member names, typed quadword
indexing, and corrected guarded `EnterDataMenu` field accesses. Unsuccessful
assignment chains, declaration moves, block-count rewrites, control-flow
rewrites, and shared-header hypotheses were restored. No promotion ledger
rows were added.
