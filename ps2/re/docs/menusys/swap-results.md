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
The plain initializer replaces the earlier wrapper while preserving the
retail halfword copy. Result codes use the documented enum constants.
