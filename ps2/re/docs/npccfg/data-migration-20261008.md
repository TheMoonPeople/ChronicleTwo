# npccfg data migration (2026-10-08)

Baseline: `d56248a7`; 11 `INCLUDE_RODATA` / 4
`INCLUDE_BSS` markers; matched_data 0/9983.

`NpcBaseDataTotalNum`, `NpcBaseData[180]`, and `npc_spi_count_num` are
native, typed file-local storage (`npccfg-resume-storage`). `NPC_BASE_DATA` retains its 0x36-byte
stride; the table has the retail 0x25F8-byte extent and the existing tool
retains its eight-byte piece tail.

`npc_spitag[3]` is a native `SPI_TAG_PARAM` array containing NPC_NUM,
NPC_INFO, and a null row (`npccfg-command-table`). Both callback definitions
have the documented retail internal linkage. The table's 0x18-byte extent
and eight-byte tail preserve all callback and keyword relocations.

The message-category suffix table is a documented `static signed char[16]`
(`npccfg-message-table-named`). A function-local table with the source name
`typetbl` passes the PAL byte verifier but fails canonical piece identity:
missing `typetbl_853`, unexpected unnamed piece. Retaining the retail name
on the file-local native definition resolves the complete object without a
shared-tool change.

The model-path buffer `static char path[0x40]` and the nine-byte writable
`static char infocfg[] = "info.cfg"` are function statics of
`GetPartyCharaModelName` (retail `path$885`, `infocfg$886`;
`npccfg-model-path-storage`, `.private/fixes-r3c/b1-*.log`). Diagnostic,
configuration, directory and format strings are inline at their uses
(`npccfg-script-diagnostics`, `npccfg-model-path-literals`). The existing
NpcModelPathType enum names the four model-path branches. No instructions
or resolved addresses change.

Final: 0 rodata / 0 BSS markers; matched_data
9983/9983 after the standard objdiff/progress refresh.
Every accepted step passes the full PAL build (`SCES_511.90: OK`) and
all 149 complete objects, including resolved relocations. The 148 other
object hashes are unchanged at each step. Function coverage stays
6,770 matched / 93 guarded / nine assembly-only / zero fuzzy.

Validation receipts are under `.private/dataE/`, with the step prefixes
listed above and `-build.log`, `-objects.log`, and `-hashes.log` suffixes.
Final refresh: `npccfg-final-progress.log`, `npccfg-final-coverage.log`,
and `npccfg-final-metrics.json`.
