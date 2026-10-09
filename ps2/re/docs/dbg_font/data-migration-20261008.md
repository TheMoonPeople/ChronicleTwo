# dbg_font data migration (2026-10-08)

Baseline: `d56248a7`; 3 `INCLUDE_RODATA` / 0
`INCLUDE_BSS` markers; matched_data 2228/2498.

The native `ascii2serno` switch generates the 64-entry jump table at
`0x368800`; its assembly marker is removed independently (receipt prefix
`dbg-font-switch`). The existing `PrintDirect` comparisons generate the
six-byte `"ESC[$"` and `"ESC[#"` literals at `0x368900` and `0x368908`
(receipt prefix `dbg-font-escapes`). The section pieces retain their zero
alignment tails. No function body, font layout, or initializer changes.

Final: 0 rodata / 0 BSS markers; matched_data
2498/2498 after the standard objdiff/progress refresh.
Every accepted step passes the full PAL build (`SCES_511.90: OK`) and
all 149 complete objects, including resolved relocations. The 148 other
object hashes are unchanged at each step. Function coverage stays
6,770 matched / 93 guarded / nine assembly-only / zero fuzzy.

Validation receipts are under `.private/dataE/`, with the step prefixes
listed above and `-build.log`, `-objects.log`, and `-hashes.log` suffixes.
Final refresh: `dbg-font-final-progress.log`, `dbg-font-final-coverage.log`,
and `dbg-font-final-metrics.json`.
