# Collision data migration (2026-10-08)

Baseline: `d56248a7`; markers 3 `INCLUDE_RODATA` / 0 `INCLUDE_BSS`;
matched_data 0/180.

The three virtual tables at `0x37B450`, `0x37B4B0`, and `0x37B4E0` are
emitted by the existing documented `CColFrame`, `CCollisionMDT`, and
`CCollision` class definitions. Removing their assembly markers preserves
all virtual-slot targets and the zero tails supplied by piece alignment.
No manual table or virtual-pointer store is needed. Function source and
header layouts are unchanged.

Final: 0 rodata / 0 BSS markers; matched_data
180/180 after the normal objdiff/progress refresh.
The full build reports `SCES_511.90: OK`, all 149 objects pass their byte and
resolved-relocation checks, and all 148 other object hashes are unchanged.
Receipts: `.private/dataE/collision-vtables-build.log`,
`collision-vtables-objects.log`, `collision-vtables-hashes.log`, and
`collision-final-progress.log` / `collision-final-metrics.json`.
