# menusys midday matching status — October 8, 2026

Historical probe record. Current exact matches and guarded remainders are
listed in [notes.md](notes.md); later promotions are documented in
[night-20261008.md](night-20261008.md).

Lane base: `c79e57c`, the validated `73fa582` integration plus the wrapper
dependency fix. Compiler: MWCC 3.0-011126, canonical `-O3,p` flags and the
production mwccgap/Satan's Fiddle wrapper in `chronicletwo_dev:sf-d8bf13c`.
No upstream merge, generated-assembly edit, shared-header edit, or new SF row
is part of this lane. `MenuWeaponBuildUpDraw` was already native in this base.

`CMenuItemInfo::PushKey` is promoted with a zero-difference whole-unit object.
Three other guarded drafts improve their constructor fidelity and fit their
retail extents. All eleven remaining guards stay in place.

## Final functions and blockers

Word counts mask relocations and include zero padding to the manifest extent.
They are isolated canonical compiles with other guarded functions still using
assembly, except where a historical whole-draft score is explicitly identified.
A nonzero count does not qualify as a promotion.

| Function | Best retained isolated score | Raw size / retail extent | Remaining blocker |
|---|---|---|---|
| `PushKey__13CMenuItemInfoFii` | **0/1768, promoted** | `0x1B94 / 0x1BA0` | None; whole object passes. |
| `LRCheck__13CMenuItemInfoFi` | 2/220 | `0x370 / 0x370` | Zero-return assignment moves into a rejection branch's delay slot. |
| `CalcTex__13CMenuItemInfoFv` | 7/832 | `0xCF8 / 0xD00` | Equipment counter and held type receive opposite saved registers. |
| `CheckEnableHaveItemNum__Fv` | 13/212 | `0x34C / 0x350` | Active-slot counter/pointer and final flag-loop offsets exchange registers. |
| `MenuPosFormValueSetCharaRobo__FP9ROBO_DATAi` | 19/296 | `0x498 / 0x4A0` | Red and green exchange saved registers. |
| `MenuItemDebugDraw__Fv` | 32/1260 | `0x13A4 / 0x13B0` | Float argument order, commutative item-index addition, and name-loop registers. |
| `MenuDataSwap__FP13CGameDataUsedP13CGameDataUsedi` | 36/228 | `0x390 / 0x390` | Presence flags and two-byte result-table copy/lookup scheduling. |
| `CommonSetMoveItemClass__FPA4_i` | 42/248 | `0x3D8 / 0x3E0` | Typed short row copy and equipment comparison add two sign-extension shifts. |
| `MenuModeMalloc__13CMenuItemInfoFP9mgCMemory` | **127/240**, previously 208 | `0x3BC / 0x3C0` | Allocation null-test scheduling, subsequent alignment, and float setup. |
| `IsAskExtend__13CMenuItemInfoFii` | **528/668**, previously 625 | `0xA68 / 0xA70` | Dispatch/register allocation and constructor null-test scheduling. |
| `MenuItemDebugKey__Fv` | 1208/1460 | `0x16D0 / 0x16D0` | Float setup and constructor allocation shifts. |
| `MenuItemSelectInit__FP9mgCMemoryPii` | **146/164**, previously oversize | `0x28C / 0x290` | Stack-buffer evaluation, constructor null test, rectangle float setup. |

The prior all-drafts report gives debug key 1207/1460; its current isolated
context gives 1208/1460. These are different compiler contexts. The selector's
private float profile reaches 145/164 but is not retained. Its 107/164 trial
uses a caller tail that disagrees with retail and is not retained either.

## Decompiler and comparison method

Every remaining target and `PushKey` was passed through `decompile.sh`, which
drives m2c. The current entry point rejects jump tables with existing `at_*`
labels in `CalcTex`, `PushKey`, `MenuItemDebugKey`, `IsAskExtend`, and
`MenuItemDebugDraw`. The successful small-function decompilations, existing
unit/type documentation, and retail disassembly were used for the comparisons.
No tooling or generated assembly was altered to bypass those errors.

Private source copies remove only the target guard and use logical source
basename `menusys.cpp`. They compile through `scripts/build/mwccgap.sh` with
canonical flags, run `fixup_sections.sh`, then run whole-unit `check_objects.py`
and the relocation-masked function comparison. The disassembly display helper
is adapted privately to keep interior switch labels inside their containing
function. The old display otherwise stops at the first label. This affects
only diagnostic output; the whole-object checker remains the acceptance test.

## Recorded negative and intermediate trials

These extend the historical morning ledger without repeating its already
recorded scope/order experiments. Receipts below are relative to
`.private/menusys-midday/` in the exclusive implementation worktree.

- **LRCheck** (`lr-single-pass.log`, `lr-probes.log`, `lr-probes2.log`,
  `lr-probes3.log`): a single-pass rejection scope, equality inside that scope,
  separately negated character/ridepod eligibility, function-entry held-type
  scope, typed used-item enum, and a surrounding held-type scope all retain
  two words different. Early return grows to `0x388` and 97 differing
  instructions; an eligibility boolean grows to `0x380` and 85; a switch
  eligibility form grows to `0x38C` and 91. At `+0x264/+0x268`, retail branches
  to the shared zero assignment at `+0x348` with a nop delay slot; the draft
  branches to `+0x34C` with the zero assignment in the delay slot. Every return
  is zero. Held-item rejection tests the current view, including current
  ridepod view 3, rather than the proposed next view. The header purpose now
  describes that return correctly.

- **CalcTex** (`calc-probes.log`, `calc-probes2.log`): a do-while equipment
  search, unsigned search index, typed item-data enum, meaningful held-type
  name, reversed equality operands, and a named returned slot type all retain
  seven differences. A signed-halfword held type grows differences to 597;
  conditional-expression reference assignment gives 13. Retail's search
  counter is `s0` and held type `s3`; the draft reverses them. The canonical
  post-`PushKey` compiler context also retains seven.

- **CheckEnableHaveItemNum** (`have-probes.log`, `have-probes2.log`): delayed
  active-pointer declaration plus pointer calls gives 35; a named final flag
  row gives 16; both give 38. Streaming the typed active pointer through its
  loop gives 204 and a shorter section. Declaring the pointer before the loop
  but assigning each iteration, and using an unsigned counter, retain 13.
  The existing accumulated `chara = chara + i` behavior is preserved. The
  function counts bag items, three gift-box entries, and three active slots
  for each of two characters, compares totals against `CDataCommon::max_num`,
  and sets per-bag and per-active-slot limit flags. It does not calculate bag
  capacity. The active flags are read by `MenuItemCharaActWepInfoDraw` and are
  not unused data; both header descriptions are corrected.

- **CommonSetMoveItemClass** (`move-probes.log`, `move-probes2.log`): a genuine
  four-field copy from the input row, a row reference, a destination-record
  reference, and reversed equipment equality retain 42. Switch dispatch gives
  218, and keeping the copied list type as int gives 214. The four input ints
  are copied into signed halfwords; equipment uses those narrowed values,
  while the active-item branch uses original input-slot values. The draft's
  extra `dsll32`/`dsra32` pair must not be removed by changing that data width.

- **Ridepod form colours** (`robo-probes.log`, `robo-name-probes.log`): byte
  colour locals give 160, signed-short colour locals exceed the extent at
  `0x4A4`, and separate green decrement/copy forms give 161. Meaningful colour
  names do not change the best 19. The mismatch is the zero-WHP red update
  and six RGB triples; retail uses `s3` for red and `s1` for green. The
  canonical post-`PushKey` context retains this result.

- **MenuDataSwap** (`swap-probes.log`): a genuine `memcpy` of the two-byte
  `{0,2}` result table retains 36. Byte-sized result locals and a byte table
  create an oversize `0x394` section and unwanted data changes. An explicit
  if/else tail-flag form causes a literal-symbol fixup conflict and is rejected.
  Retail copies `{0,2}`, replaces entry zero from the `{1,3}` table using source
  presence, then indexes the two-entry result using destination presence.
  No experimental extern or new data object is retained.

- **MenuItemDebugDraw** (`debug-baseline2.log`, `debug-probes.log`,
  `debug-probes2.log`, `debug-profile-probes.log`, `debug-f64-probes.log`):
  page/row or column addition order and an unsigned name-loop index retain 32.
  Streaming item/name pointers gives 42; reusing a function-scope index gives
  41; hoisting the first item number gives 49. Removing redundant double-to-
  float casts retains 32. Private evaluate-first rows for the real
  `DrawMenuFillBox__Fffffiiii` callee give 43 for 200 first, 34 for 60 first,
  32 for 236 first, and 41 for the 200/60 combination. Binary64 selectors are
  unconsumed because the cast constants have already folded to binary32.
  The conflicting fill-box literals are direct arguments of the same callee,
  with no nested sibling call or named initializer around them. The upstream
  `nested_call`/`nested_variable` selectors therefore provide no real source
  identity to distinguish these occurrences. No helper or temporary is
  introduced to manufacture one, and no profile row is retained. The
  remaining three-name loop exchanges its counter and offset registers.

- **Constructor targets** (`mode-probes.log`, `ask-probes.log`,
  `key-probes.log`, `select-probes.log`, `select-native-profile.log`,
  `base-ctor-scores.log`, `retained-ctor-scores.log`, `retained-key.log`): retained and rejected
  construction boundaries, natural inline depth, and selector profile trials
  are detailed in [guarded-constructors.md](guarded-constructors.md). The
  selector's genuine default rectangle construction supplies the initial
  zero setters. No class/member layout was changed to invent a loop.

- **PushKey** (`push-baseline.log`, `push-probes3.log` through
  `push-probes5.log`, `push-direct-attribute/{check,scores}.log`): the original
  `0x1BB4` section was too large. Normal branch-local item construction fits
  at `0x1B9C` with 583 differences; branch-local reload paths give 576. Typed
  bases shared across tuning and confirmation remove the two excess loads,
  reducing to 11; available-step-before-selection order reduces to one.
  Direct typed attribute access produces zero and a whole-object pass at
  `0x1B94`. An extra attribute-array pointer also matches, but the simpler
  direct form is retained. Replacing the existing early jump with a return
  increases the section to `0x1BA4`; changing only the final loop form does
  not solve the original issue. Details and full promotion receipts are in
  [pushkey.md](pushkey.md).

No unsupported shared-header change is proposed. The completed post-promotion
rechecks in `post-push-scores.log` leave LRCheck, CalcTex, ridepod colours and
debug drawing at 2, 7, 19 and 32 respectively. The remaining small-function
source experiments are not retained because none improves their best result.

## Validation and integration

Baseline repository coverage was 6,686 matched / 169 guarded / 15 asm-only /
2 fuzzy, out of 6,872. Final coverage is **6,687 matched / 168 guarded /
15 asm-only / 2 fuzzy**. Unit coverage changes from 153 matched / 12 guarded
to **154 matched / 11 guarded**.

The final full build has exactly the baseline PAL result: `.text` differs by
`0x26` bytes, first at `0x0015C5AD` in `nd_meswin::DrawMesWin`; the other nine
file-backed sections pass and `.bss` ends at `0x01F64A00`. The object checker
remains **147/149**, with `menusys` passing. The two failures are the existing
`nd_meswin::DrawMesWin` and `actscript::_SHOT` differences. Comparison of all
149 SHA-256 game-object hashes changes only `menusys.cpp.o` from the lane base;
all 148 other objects are identical. The final guarded-draft/header edits
also leave all 149 objects identical to the validated `PushKey` promotion.

Private receipts:

- `baseline-build.log`, `baseline-objects.log`, `baseline-hashes.json`,
  `baseline-coverage.log`, `baseline-progress.log` — lane entry.
- `push-build.log`, `push-objects.log`, `push-hash-compare.json`,
  `push-progress.log` — manual guard removal and promotion acceptance.
- `final-build.log`, `final-objects.log`, `final-hash-compare.json`,
  `final-coverage-summary.log`, `final-coverage.log`, `final-progress.log` —
  retained source/header and final repository validation.

The full build exits one at the pre-existing PAL verifier failure, before the
progress stage. The separate ctx/objdiff/progress refresh is required before
reading coverage. Treat the complete object and PAL receipts as acceptance;
private function scores alone are insufficient. No SF merge is needed, no
nonowned patch is proposed, and the dirty `tools/mwccgap` worktree is not staged.
