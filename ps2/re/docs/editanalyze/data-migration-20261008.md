# editanalyze data migration (2026-10-08)

Baseline: `d56248a7`; 5 `INCLUDE_RODATA` / 1
`INCLUDE_BSS` markers; matched_data 0/173.

The existing CheckLiveChara switch emits its 26-entry native jump table;
EditMapInitEvent emits both inline map/part names; AnalyzeMoonFlower emits
its zero center-vector BSS template (`editanalyze-native-pieces`). Their
markers and the unused zero-template extern are removed independently.

GetHouseParts initializes a plain `int ids[4] = {1, 9, 0x16, 0x1F};`
(`editanalyze-house-identifiers`); the former `HouseInfoIds` wrapper union is
removed, and the plain array keeps the exact 16-byte template and copy
(`.private/fixes-r3c/b1-*.log`).

AnalyzeSharlot initializes a native sceVu0FVECTOR with `{0, 0, 0, -1}` at the
river-query point (`editanalyze-river-center-local-order`). The following
actual working arrays are declared there in their original order so river,
tree positions, and the three difference/closest vectors retain their stack
positions. This removes the extern and quadword type-pun initializer. The
first late-declaration probe changes stack offsets (`editanalyze-river-center`);
initializing at the earlier original declaration instead moves the copy ahead
of the condition/target clearing loop (`editanalyze-river-center-declaration`).
Both are rejected; the accepted local-order form preserves all instructions
and resolved relocation targets.

Final: 0 rodata / 0 BSS markers; matched_data
173/173 after the standard objdiff/progress refresh.
Every accepted step passes the full PAL build (`SCES_511.90: OK`) and
all 149 complete objects, including resolved relocations. The 148 other
object hashes are unchanged at each step. Function coverage stays
6,770 matched / 93 guarded / nine assembly-only / zero fuzzy.

Validation receipts are under `.private/dataE/`, with the step prefixes
listed above and `-build.log`, `-objects.log`, and `-hashes.log` suffixes.
Final refresh: `editanalyze-final-progress.log`, `editanalyze-final-coverage.log`,
and `editanalyze-final-metrics.json`.
