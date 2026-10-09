# Villager configuration data migration

## Baseline

Round 2 starts at `55cdb46c` with 35 `INCLUDE_RODATA` and 21 `INCLUDE_BSS`
markers; objdiff reports 7,252 / 7,836 matched data bytes.

## Schedule and parser storage

All 21 BSS markers have native definitions using the types established in
`notes.md`. Parser pointers and counters have file-local storage.
`ProgressInfo` and `VlgrPlace` retain external linkage because the generated VU data object
`vutext.data.s.o` refers to that symbol; making it static passes the unit
object check but fails the complete link. The progress table type is
`GAME_PROGRESS_INFO[GAME_PROGRESS_MAX]` and its size remains 0xC00.

The path, progress condition, posture, motion and file-name literals are
inline strings. The progress condition uses the retail Shift-JIS bytes
`88 C8 8C E3` for 以後, represented by octal escapes to preserve source encoding.
Repeated uses of "sit" share the compiler's string object.

The complete PAL build reports `SCES_511.90: OK`; all 149 objects pass.
Receipts: `.private/dataB-r2/vlgr-strings-{build,check}.log`.

## Script tag tables

The 10-entry `ni_tag`, 12-entry `tag__9` and 2-entry `gi_tag` arrays use
`SPI_TAG_PARAM` and inline their names. Each retains its null terminator.
Handler declarations give the parser callbacks file-local linkage, consistent
with their retail symbols. `tag__9` stays at file scope: writing it as a
function-local `tag` produces a new `tag_206` symbol that the canonical checker
cannot resolve, even though the final executable matches. Its `__9` suffix
therefore does not establish function-local storage.

All assembly data markers and anonymous externs are gone: 0 `INCLUDE_RODATA`,
0 `INCLUDE_BSS`. The unit retains 36 matched functions and the complete object
matches 0x1274 bytes with 279 resolved relocations. All 149 objects pass;
`SCES_511.90: OK`. Receipts: `.private/dataB-r2/vlgr-final-{build,check,progress}.log`.

After refreshing objdiff/progress: 7252 / 7836 matched data bytes.
