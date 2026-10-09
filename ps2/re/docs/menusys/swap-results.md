# Menu slot exchange result tables

`MenuDataSwap__FP13CGameDataUsedP13CGameDataUsedi` uses two signed-byte result
tables. `ret_tbl1_2511` is at PAL `0x0037CA74`, has declared size two bytes,
and contains `{1, 3}`. The automatic-array initializer `at_2512` is at
`0x0037CA78`, has the same declared size, and contains `{0, 2}`. Each occupies
a four-byte section piece, including two zero alignment bytes. Retail reads
the source table with `lb`, copies the defaults with `lh`/`sh`, and reads the
selected result with `lb`.

The general exchange tail records whether each slot contained an item before
`GameDataSwap`. The destination flag selects one of the two automatic result
entries. Entry zero is replaced by `ret_tbl1_2511[source_present]`; entry one
remains two. The resulting mapping is:

| Original destination | Original source | Result |
|---|---|---|
| Empty | Empty | 1 |
| Empty | Occupied | 3 |
| Occupied | Empty or occupied | 2 |

Other paths return zero when the exchange cannot run, one for ordinary
completion, four for the gift-box path, five for matching stackable items,
and seven for the aquarium path. The gift-box path returns four even when
`SetGiftBoxItem` fails. `MENU_SWAP_RESULT` is a descriptive source enum for these
observed values, not an established retail type name.

Both data objects are supplied by native C++ in `menusys.cpp`: `ret_tbl1_2511`
is a named array, and MWCC emits `at_2512` from a local `s8` array initializer.
The existing postprocessor retains their two zero alignment bytes. Their
assembly data markers are removed.

`MenuDataSwap` is matched. The general exchange tail initializes its two-byte
array after looking up `ret_tbl1_2511`, preserving retail's halfword copy.
The October 9 plain initializer replaces the earlier `MenuSwapResultTable`
wrapper; its independent and combined checks are documented in
[review-fixes-r2-20261009.md](review-fixes-r2-20261009.md). The earlier source
facts and rejected forms are in [night-20261008.md](night-20261008.md).
Result codes use the documented enum constants.

## October 8 round-one validation

Worktree base: `55e7ed3`. Compiler: MWCC 3.0-011126, canonical flags,
`chronicletwo_dev:sf-d8bf13c`, `JOBS=4`.

The complete menusys object passes: `0x1B0DC` allocated bytes and 5,872 resolved
relocations. Repository checks remain 147/149; the only failures are the
existing `nd_meswin::DrawMesWin` and `actscript::_SHOT`. All 148 other game
object file hashes are identical to the fresh base build. PAL `.text` retains
the same `0x26` differing bytes, first at `0x0015C5AD`; the other nine
file-backed sections and the `.bss` end at `0x01F64A00` pass.

Private receipts are in `.private/menusys-r1/`: `swap-data-build.log`,
`swap-data-objects.log`, and `swap-data-hash-compare.json`. The preliminary
isolated check is `swap-data-only/check.log`. No compiler profile, shared
header, generated assembly, or function promotion is part of this data change.
The final guarded draft is measured in `retained-swap/{check,scores}.log`;
its normal-build preservation is recorded by `final-objects.log` and
`final-hash-compare.json`. See
[the round-one ledger](matching-round1-20261008.md) for all rejected source
hypotheses and final repository coverage.
