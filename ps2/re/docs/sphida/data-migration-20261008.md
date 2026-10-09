# sphida data migration (2026-10-08)

Baseline: `d56248a7`; 6 `INCLUDE_RODATA` / 1
`INCLUDE_BSS` markers; matched_data 0/267.

## Native tables, state and literals

`GolfClubDef` is a native seven-element `GOLF_CLUB_DEF` array. Its six club
rows retain the retail power, floating parameter and integer parameter in
club-number order, followed by the zero row. The declared 0x54-byte object
occupies a 0x60-byte piece, and existing preparation supplies its twelve-byte
alignment tail without a source padding wrapper. The observed uses establish
`power` but do not establish the meaning of the other two script-facing
parameters, so their existing unknown field names remain.

The public `Sphida` pointer is native zero-initialized storage. The existing
switches in `CPowGage::Step`, `CSphida::SetUp`, and `CSphida::Omake_SetUp`
generate the three jump tables. The setup diagnostics are inline strings.
All six initialized-data markers and the one BSS marker are removed.

The 42 existing SF selector rows, all function bodies, and public declarations
remain source-compatible. All object code and resolved relocations match.

Accepted steps: `sphida-switches-and-literals`,
`sphida-current-game-storage`, `sphida-club-properties`.

Final: 0 rodata / 0 BSS markers; matched_data
267/267 after the standard objdiff/progress refresh.
Every accepted step passes the full PAL build (`SCES_511.90: OK`) and
all 149 complete objects, including resolved relocations. The 148 other
object hashes are unchanged at each step. Function coverage stays
6,770 matched / 93 guarded / nine assembly-only / zero fuzzy.

Validation receipts are under `.private/dataE/`, with the step prefixes
listed above and `-build.log`, `-objects.log`, and `-hashes.log` suffixes.
Final refresh: `sphida-final-progress.log`, `sphida-final-coverage.log`,
and `sphida-final-metrics.json`.
