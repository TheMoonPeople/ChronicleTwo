# editriver data migration (2026-10-08)

Baseline: `d56248a7`; 10 `INCLUDE_RODATA` / 2
`INCLUDE_BSS` markers; matched_data 0/256.

The existing matched C++ supplies all twelve data pieces as automatic
aggregate initializer templates:

- `DrawRiver`: four homogeneous corner vectors, receipts `editriver-draw-vectors`.
- `DrawRiverMask`: center plus four corner vectors, receipts `editriver-mask-vectors`.
- `CEditGrid::UpdateRiver`: two zeroed four-int shape/rotation arrays, receipts `editriver-shape-arrays`.
- `CEditGrid::GetRiverPoly`: five homogeneous corner vectors with the grid pitches applied at runtime, receipts `editriver-poly-corners`.

The last template is 0x50 bytes, including its closing corner at the
origin; the dated notes' description as four vectors omits that fifth
row. The initializer copies and their relocations match without explicit
anonymous declarations or retained assembly reservations. Each function's
markers were removed and validated separately. No function body changes.

Final: 0 rodata / 0 BSS markers; matched_data
256/256 after the standard objdiff/progress refresh.
Every accepted step passes the full PAL build (`SCES_511.90: OK`) and
all 149 complete objects, including resolved relocations. The 148 other
object hashes are unchanged at each step. Function coverage stays
6,770 matched / 93 guarded / nine assembly-only / zero fuzzy.

Validation receipts are under `.private/dataE/`, with the step prefixes
listed above and `-build.log`, `-objects.log`, and `-hashes.log` suffixes.
Final refresh: `editriver-final-progress.log`, `editriver-final-coverage.log`,
and `editriver-final-metrics.json`.
