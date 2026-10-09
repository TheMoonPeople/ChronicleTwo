# effectlist data migration (2026-10-08)

Baseline: `d56248a7`; 4 `INCLUDE_RODATA` / 7
`INCLUDE_BSS` markers; matched_data 0/147.

The already matched source supplies every retained piece naturally:

- `LoadEFPFile` emits inline `"img"` and `"em"` extensions (`effectlist-pack-extensions`).
- `CEffectManager::CreatePacket` emits its zero size and RGBA-128 aggregate templates (`effectlist-particle-vectors`).
- The whole-screen `DivSpriteScreen` emits its three zeroed coordinate templates (`effectlist-screen-tile-vectors`).
- The wipe `DivSpriteScreen` emits its three coordinate templates and alternating `{-10, 10}` edge offsets (`effectlist-wipe-vectors`).

Each function's marker group was removed and verified separately. The compiler
retains the separate BSS templates and initialized pieces using the existing
real code-relocation evidence. No new casts or packet-copy forms are added.

Final: 0 rodata / 0 BSS markers; matched_data
147/147 after the standard objdiff/progress refresh.
Every accepted step passes the full PAL build (`SCES_511.90: OK`) and
all 149 complete objects, including resolved relocations. The 148 other
object hashes are unchanged at each step. Function coverage stays
6,770 matched / 93 guarded / nine assembly-only / zero fuzzy.

Validation receipts are under `.private/dataE/`, with the step prefixes
listed above and `-build.log`, `-objects.log`, and `-hashes.log` suffixes.
Final refresh: `effectlist-final-progress.log`, `effectlist-final-coverage.log`,
and `effectlist-final-metrics.json`.
