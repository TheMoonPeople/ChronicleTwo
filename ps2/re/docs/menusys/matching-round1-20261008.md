# menusys round-one matching status — October 8, 2026

Historical probe record. Current exact matches and guarded remainders are
listed in [notes.md](notes.md); later promotions are in
[night-20261008.md](night-20261008.md).

Lane base: `55e7ed3`, the midday integration containing upstream `d8bf13c`
and the round-zero `PushKey` promotion. At that checkpoint this superseded
the round-zero matching status in [matching-midday-20261008.md](matching-midday-20261008.md); that file
remains the historical round-zero experiment ledger. A fresh build was made
before experimenting because the inherited build directory was stale.

Compiler: MWCC 3.0-011126, canonical production flags, mwccgap/Satan's Fiddle,
`chronicletwo_dev:sf-d8bf13c`, `JOBS=4`. No profile row or header change is
retained. No generated assembly or replacement inline assembly was written.

No function is promoted in this round. Two result-table data objects have
matching C++ definitions, and the guarded `MenuDataSwap` draft improves from
36 to 34 differing words. All eleven function guards remain in place.

## Retained scores and blockers

Scores are isolated production-wrapper compiles with only the measured
function's guard removed in a private source copy. They mask relocations and
include zero padding to the retail manifest extent. Whole-object byte and
resolved-relocation checks are the acceptance test; every nonzero function
below remains guarded.

| Function | Entry → retained differing words | Raw size / retail extent | Remaining blocker |
|---|---|---|---|
| `LRCheck__13CMenuItemInfoFi` | 2/220 → 2/220 | `0x370 / 0x370` | Zero return moves into the final rejection branch's delay slot. |
| `CalcTex__13CMenuItemInfoFv` | 7/832 → 7/832 | `0xCF8 / 0xD00` | Held type and equipment-search counter exchange saved registers. |
| `CheckEnableHaveItemNum__Fv` | 13/212 → 13/212 | `0x34C / 0x350` | Active-slot counter/pointer and final flag-loop offsets exchange registers. |
| `MenuPosFormValueSetCharaRobo__FP9ROBO_DATAi` | 19/296 → 19/296 | `0x498 / 0x4A0` | Red and green exchange saved registers. |
| `MenuItemDebugDraw__Fv` | 32/1260 → 32/1260 | `0x13A4 / 0x13B0` | Float argument setup, item-index addition, and build-up-name loop registers. |
| `MenuDataSwap__FP13CGameDataUsedP13CGameDataUsedi` | 36/228 → **34/228** | `0x388 / 0x390` | Source/destination presence registers, result-array setup, and tail scheduling. |
| `CommonSetMoveItemClass__FPA4_i` | 42/248 → 42/248 | `0x3D8 / 0x3E0` | Input-row copy scheduling and two extra sign-extension shifts before equipment comparison. |

The four other guards, `MenuModeMalloc`, `IsAskExtend`, `MenuItemDebugKey`, and
`MenuItemSelectInit`, retain the round-zero drafts and were not reanalyzed.
Already matched functions were used only as documented source references.

## Evidence and type dependencies

All seven targets were passed through `decompile.sh`, driving m2c. The current
entry point cannot identify the existing jump table in `CalcTex` at assembly
line 707 or `MenuItemDebugDraw` at line 36. Their existing analysis and actual
retail disassembly supply the missing control flow; no assembly was changed
to bypass the errors. `LRCheck`, `CheckEnableHaveItemNum`, the ridepod form
function, and `CommonSetMoveItemClass` were also decompiled again after
refreshing ctx/objdiff, using fresh context and `--no-cache --no-switches`.
Context-parser warnings and guessed m2c fields are not layout evidence.

Existing type documentation in [notes.md](notes.md), `userdata.hpp`, and the
menucls1 notes establishes the dependent layouts. `CMenuItemInfo` is `0x370`,
`CGameDataUsed` is `0x6C`, and `CHARA_DATA` is `0x38C`. Character active items
are a typed three-element array. `MENU_ITEM_MOVE_INFO` is `0x7C` and its
`from[4]` at `0x74` contains signed halfwords. No shared type change is needed.

The item-limit calculation counts ordinary inventory items, gift-box entries,
and active-slot items, then sets per-item and per-active-slot limit flags. Its
two-pass accumulated `chara = chara + i` behavior is retained. The move-record
function narrows the four input integers into `from[]`; equipment decisions
use these narrowed values, while active-slot decisions use the original
input row. Removing the sign extension by widening the record would change
that behavior and contradict the established layout.

The swap tables and observed result values are documented in
[swap-results.md](swap-results.md). `MENU_SWAP_RESULT` is a descriptive local
enum, not a recovered retail type name. Its values replace result-code
literals in the guarded draft. The two data definitions replace only their
`INCLUDE_RODATA` markers and retain both declared sizes and alignment bytes.

## Round-one source hypotheses

These trials extend the earlier ledgers. Receipts are relative to
`.private/menusys-r1/`. Each named trial directory contains its source copy,
compile log, full object check, masked scores, and disassembly comparison.
Rejected source forms are not retained.

- **LRCheck:** `lr-return-code` gives 2 with a meaningful zero result local;
  `lr-outer-shared-return` gives 208 and raw size `0x350` when the outer
  rejection paths share a nested body and final return. `lr-return-direction`
  gives 3 when the zero-direction path returns its known-zero direction.
  `lr-robo-exclusion` gives 2 with an inverted ridepod eligibility scope;
  `lr-robo-type-first` gives 6 after reversing that condition's operands.
  `lr-single-character-condition` gives 13 with the held-type rejection
  outside the character-view condition. `lr-switch-shared-exclusion` exceeds
  the extent at `0x374`; `lr-held-short` exceeds it at `0x388`. Alignment of
  the switch trial shows a changed case-test order as well as the unresolved
  return scheduling, so it is not a closer source form. Retail's branch at
  `+0x264` targets the zero assignment at `+0x348` with a nop delay slot; the
  draft targets `+0x34C` and assigns zero in the delay slot at `+0x268`.
  Rejection tests the current view rather than the proposed view, and every
  return is zero. Aggregate logs: `lr-return-shapes.log`,
  `lr-eligibility-shapes.log`, `lr-switch-alignment.log`.

- **CalcTex:** `calc-preview-scope`, `calc-held-unsigned`,
  `calc-search-while`, `calc-search-continue`, `calc-search-break-loop`, and
  `calc-register-held-type` all retain 7. Reusing the held-item-number local
  for its converted type (`calc-transform-held-item`) gives 24; a separate
  matched-slot result (`calc-local-search-result`) gives 9. Retail assigns
  `s3` to the held type and `s0` to the equipment counter; the draft reverses
  them at seven words in `+0x394..+0x3BC`. The `register` qualifier does not
  change MWCC's allocation. Aggregate logs: `calc-source-shapes.log`,
  `second-source-derivation.log`.

- **CheckEnableHaveItemNum:** reusing the earlier inventory-item pointer
  (`have-reuse-owned-pointer`) retains 13. A signed-halfword active item
  number (`have-active-number-short`) gives 40; final-loop scoped counters
  (`have-final-for-scope`) give 22. `have-final-item-number`,
  `have-final-index-order`, and `have-register-slot-counter` retain 13.
  A typed active-item reference (`have-active-reference`) gives 24; a final
  limit-flag reference (`have-final-flag-reference`) gives 35. Explicit
  active/gift counts (`have-explicit-active-counts`) give 17. Seven words
  exchange the first active loop's `s1` counter and `s3` pointer; six words
  exchange `t0` and `a3` in the final flag loop. Aggregate logs:
  `have-source-shapes.log`, `have-reference-robo-shapes.log`,
  `second-source-derivation.log`.

- **Ridepod form colours:** a separate blue local (`robo-three-channels`),
  independent RGB initialization (`robo-three-independent-init`),
  `robo-register-red`, `robo-register-green`, `robo-warning-unsigned`, and
  a warning branch shaped like the existing weapon indicator
  (`robo-weapon-warning-shape`) all retain 19. A typed RGB array
  (`robo-rgb-array`) exceeds the extent at `0x4C0`. Retail uses `s3` for red
  and `s1` for green; the draft reverses them. The mismatch is the zero-WHP
  update at `+0x238` and eighteen stores for six RGB triples. Aggregate logs:
  `have-reference-robo-shapes.log`, `second-source-derivation.log`.

- **MenuItemDebugDraw:** a fresh `debug-base` confirms 32.
  `debug-build-arrays-function`, `debug-name-while`, and `debug-name-do-while`
  retain 32. `debug-build-name-array-first` gives 36; a shared page/row
  origin (`debug-row-origin`) gives 1,175 with raw size `0x13AC`.
  The name loop exchanges its counter and offset registers, independently
  of the commutative item-index addition and float-call argument setup.
  Earlier SF literal selectors are not repeated. The conflicting constants
  are direct arguments of the same fill-box callee; neither nested selector
  has a real distinguishing source identity here. Aggregate logs:
  `debug-base-swap-shapes.log`, `debug-source-shapes.log`.

- **MenuDataSwap:** `swap-bool-presence` exceeds the extent at `0x398` and
  adds unwanted literal data. Chained presence initialization
  (`swap-chained-presence`) gives 38. A split constant initialization and
  assignment (`swap-result-array-scope`) retains 36; the byte return type
  (`swap-return-byte`) also retains 36. A reordered flag declaration with
  the split initializer (`swap-index-order-split-array`) gives 38.
  Function-local static source tables at entry or tail
  (`swap-local-static-table-entry`, `swap-local-static-table-tail`) retain
  36. A result array declared with the function's other locals and filled
  in the general exchange tail (`swap-result-array-entry`) gives **34**
  and avoids the extra compiler literal piece. The C++ data definitions
  preserve this score in `swap-array-entry-native-data`; their constant
  table copied with `memcpy` (`swap-native-data-copy`) still gives 36 and
  emits a real call. A named selected-source result of byte or int type
  (`swap-source-result-byte`, `swap-source-result-int`) gives 36; declaring
  the destination flag first in that form (`swap-source-result-dst-first`)
  gives 38. The retained enum-based source is independently measured in
  `retained-swap` at 34/228, raw `0x388`. Its private unguarded whole object
  fails with two reported problems: target code bytes and the shifted
  `CheckEnableHaveItemNum` call relocation. Retail copies both initial bytes
  with `lh`/`sh`, then overwrites entry zero; the retained draft stores each
  final entry separately. Both select the same observed result, but the
  draft does not match the retail instruction schedule. Aggregate logs:
  `debug-base-swap-shapes.log`, `swap-rederived-tables.log`,
  `swap-data-check.log`, `swap-selected-result-context.log`,
  `retained-swap.log`.

- **CommonSetMoveItemClass:** `move-explicit-short-copy`,
  `move-const-input-row`, `move-list-int-cast`, `move-list-unsigned-cast`,
  `move-copy-unsigned`, and a typed pointer to the complete input row
  (`move-source-array-pointer`) all retain 42. An inner list-type switch
  (`move-list-switch`) gives 218; `move-copy-do-while` exceeds the extent
  at `0x3F0`. The draft lacks retail's early row-address copy and emits
  `dsll32`/`dsra32` before comparing the narrowed equipment type with one.
  Aggregate logs: `move-source-shapes.log`, `second-source-derivation.log`.

The post-data-definition rechecks in `post-data-LRCheck__13CMenuItemInfoFi`,
`post-data-CalcTex__13CMenuItemInfoFv`, `post-data-CheckEnableHaveItemNum__Fv`,
and `post-data-MenuPosFormValueSetCharaRobo__FP9ROBO_DATAi` remain 2, 7, 13,
and 19 respectively. Changing the native data definitions does not solve
these compiler-context blockers.

## Final validation and integration

Fresh baseline and final coverage are identical: **6,739 matched / 121
guarded / 10 asm-only / 2 fuzzy**, out of 6,872 game functions. Menusys
remains **154 matched / 11 guarded**. No new function is claimed as matched.

The complete menusys object passes with **`0x1B0DC` allocated bytes and 5,872
resolved relocations**. All-object acceptance remains **147/149**. The two
existing failures are `nd_meswin::DrawMesWin` and `actscript::_SHOT`.

The full build retains exactly the fresh baseline PAL result: `.text`
differs by `0x26` bytes, first at `0x0015C5AD` in
`nd_meswin::DrawMesWin+0x6FD`; the other nine file-backed sections pass,
and `.bss` ends at `0x01F64A00`. Only `menusys.cpp.o` has a changed file hash
from the base, while all 148 other game object hashes are identical. The
guarded draft and comment edits leave all 149 object hashes identical to
the validated data-only commit.

Private receipts under `.private/menusys-r1/`:

- Entry: `baseline-build.log`, `baseline-objects.log`, `baseline-hashes.json`,
  `baseline-refresh.log`, `baseline-progress.log`, `baseline-coverage.log`.
- Decompilation: each `<mangled-symbol>.m2c.log`; the four refreshed small
  targets also have `<mangled-symbol>.fresh.m2c.log`.
- Native data: `swap-data-only/check.log`, `swap-data-build.log`,
  `swap-data-objects.log`, `swap-data-hashes.json`, `swap-data-hash-compare.json`.
- Guarded improvement: `retained-swap/{compile,check,scores}.log`,
  `retained-swap/diff.txt`, `retained-swap.log`.
- Final: `final-build.log`, `final-objects.log`, `final-hashes.json`,
  `final-hash-compare.json`, `final-refresh.log`, `final-progress.log`,
  `final-coverage.log`, `final-coverage-summary.log`.

The full build exits one at the unchanged PAL verifier failure before its
progress stage. ctx/objdiff and progress were therefore refreshed separately
before reading coverage. No nonowned patch is proposed. The existing dirty
`tools/mwccgap` worktree is not staged, and no SF row needs integration.
