# Native villager pose switch table

The existing unit notes identify the seven-word `ex_step` switch table in
`CVillagerMngr::Step`. Its already matched C++ switch now emits the table
without an assembly marker. No route, motion, pose or schedule logic changes,
and no virtual declarations or shared layouts change.


Markers: ROData **1 → 0**, BSS **0 → 0**.
Objdiff after the required refresh: matched_data **0 → 28** / total_data **28 → 28**.

Validation: `SCES_511.90: OK`, **149/149** complete objects including resolved relocations. No functions promoted. Receipts: `.private/dataB-r3/villagermngr-final-build.log`, `villagermngr-final-objects.log`, `villagermngr-progress.log`.
