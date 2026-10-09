# quest data migration (2026-10-08)

Baseline: `d56248a7`; 5 `INCLUDE_RODATA` / 3
`INCLUDE_BSS` markers; matched_data 0/80.

The three parser-state pointers are typed, documented file-local definitions:
`CQuestManager *spi_questman`, `mgCMemory *spi_queststack`, and
`QUEST_INFO *spi_quest_info` (`quest-parser-storage`).

The five-row `SPI_TAG_PARAM quest_cmd_tag` array is defined after its four
handlers and before `LoadCfg` (`quest-command-table`). Its keyword spelling
is `NUM`, `NEW`, **COMENT**, `END`, followed by a null row. `COMENT` is the
actual retail text, correcting the inactive draft's `COMMENT` spelling.
All keyword strings are inline in the table. The handlers and table have
internal linkage, matching the documented retail LOCAL bindings. The table
has a declared 0x28-byte extent and an eight-byte zero piece tail. All
existing function instructions and callback targets remain exact.

Final: 0 rodata / 0 BSS markers; matched_data
80/80 after the standard objdiff/progress refresh.
Every accepted step passes the full PAL build (`SCES_511.90: OK`) and
all 149 complete objects, including resolved relocations. The 148 other
object hashes are unchanged at each step. Function coverage stays
6,770 matched / 93 guarded / nine assembly-only / zero fuzzy.

Validation receipts are under `.private/dataE/`, with the step prefixes
listed above and `-build.log`, `-objects.log`, and `-hashes.log` suffixes.
Final refresh: `quest-final-progress.log`, `quest-final-coverage.log`,
and `quest-final-metrics.json`.
