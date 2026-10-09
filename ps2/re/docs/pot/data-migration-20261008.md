# pot data migration (2026-10-08)

Baseline: `d56248a7`; 9 `INCLUDE_RODATA` / 0
`INCLUDE_BSS` markers; matched_data 0/564.

The three writable, public fragment-offset arrays use their existing header
layouts: `box_offset[12][4]`, `iwa0_offset[10][4]`, and `iwa1_offset[9][4]`.
Their native four-float rows preserve all 192/160/144 bytes and 16-byte
placement alignment. Decimal initializers retain the actual binary32 bits,
including adjacent values such as 3.1999998 and 3.6000001 rather than rounding
them to nominal tenths. Each table was migrated separately (`pot-box-offsets`,
`pot-rock0-offsets`, `pot-rock1-offsets`; spacing check `pot-table-spacing`).

The splash effect name is inline as exact Shift-JIS hex escapes in both
collision consumers (`pot-splash-effect`). Broken-model lookup names,
fragment format, and carried-model name are inline at their existing uses
(`pot-fragment-names`, `pot-carried-model`). The shared `box`, `rock`, and
splash literals retain pooling and every consuming relocation. No type,
function behavior, or external declaration changes.

Final: 0 rodata / 0 BSS markers; matched_data
564/564 after the standard objdiff/progress refresh.
Every accepted step passes the full PAL build (`SCES_511.90: OK`) and
all 149 complete objects, including resolved relocations. The 148 other
object hashes are unchanged at each step. Function coverage stays
6,770 matched / 93 guarded / nine assembly-only / zero fuzzy.

Validation receipts are under `.private/dataE/`, with the step prefixes
listed above and `-build.log`, `-objects.log`, and `-hashes.log` suffixes.
Final refresh: `pot-final-progress.log`, `pot-final-coverage.log`,
and `pot-final-metrics.json`.
