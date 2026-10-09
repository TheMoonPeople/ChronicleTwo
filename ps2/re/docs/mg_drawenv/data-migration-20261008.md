# Native draw-environment alpha switch table

The existing unit notes establish `SetAlpha`'s blend-mode switch and its six-word
branch-target table. The already matched C++ switch now emits the table without
an assembly marker. No function body, header or fog parameter representation
changes; the SF profile remains unchanged.


Markers: ROData **1 → 0**, BSS **0 → 0**.
Objdiff after the required refresh: matched_data **0 → 24** / total_data **24 → 24**.

Validation: `SCES_511.90: OK`, **149/149** complete objects including resolved relocations. No functions promoted. Receipts: `.private/dataB-r3/mg_drawenv-final-build.log`, `mg_drawenv-final-objects.log`, `mg_drawenv-progress.log`.
