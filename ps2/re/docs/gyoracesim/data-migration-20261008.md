# Fish simulation data migration, October 8 night, round 4

Baseline: `9eb8f660`, pinned SF image, canonical flags and unchanged profile.
The established grFISH_DATA fields and RNG behavior in notes.md supply the types.

`fish_data` is a documented static grFISH_DATA[18] definition. Each 0x1C
record contains its item identity, power/stamina percentages, three speed
percentages and affinity. The 0x1F8 payload is copied from the retail table;
its final eight alignment bytes are preserved without extra records.
The table remains writable, matching its retail .data placement and the
existing GetFishData pointer interface.

The existing LaneBattleStep `{-1, -1}` local array produces `at_483__2`.
The existing FishModifyParam switch produces `at_1059__3` naturally.
Both duplicate markers are removed in separately checked steps. RNG state
is now supplied by documented `static int jrand` and `static int ia[56]`
definitions; ia retains the unused index-zero slot of the one-based generator.

All five data markers are removed. No function body or header changes.

## Measurement and validation

Markers (RODATA / BSS): **3 / 2 → 0 / 0**.
Fresh objdiff `matched_data / total_data`: **0 / 764 → 764 / 764**.

`gyoracesim-final-build.log` prints `SCES_511.90: OK`; `gyoracesim-final-objects.log`
passes 149/149 objects. These receipts, the incremental checks, baseline
measurements and object-hash audit are under `.private/dataB-r4/`.
All objects outside the seven owned units retain their baseline file hashes.
No function is promoted and no assembly fallback or guarded function body changes.
