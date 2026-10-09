# Native memory diagnostics

The existing unit notes identify the three memory-error formats. Their ordinary
literals in `MG_ADDRESS_CHECK`, `Free` and stack allocation now emit the retained
retail strings without assembly markers. No function body changes. Each literal
removal independently passes the complete object and PAL checks.


Markers: ROData **3 → 0**, BSS **0 → 0**.
Objdiff after the required refresh: matched_data **0 → 88** / total_data **88 → 88**.

Validation: `SCES_511.90: OK`, **149/149** complete objects including resolved relocations. No functions promoted. Receipts: `.private/dataB-r3/mg_memory-final-build.log`, `mg_memory-final-objects.log`, `mg_memory-progress.log`.
