# Native sprite empty-name literal

The existing unit notes identify `at_1069__4` as the one-byte empty string used
by `CEventSprite2::Draw`. Its comparison now uses the ordinary empty literal
at use, removing the external declaration and assembly marker. The comparison
and textured/untextured control flow are unchanged.


Markers: ROData **1 → 0**, BSS **0 → 0**.
Objdiff after the required refresh: matched_data **0 → 1** / total_data **1 → 1**.

Validation: `SCES_511.90: OK`, **149/149** complete objects including resolved relocations. No functions promoted. Receipts: `.private/dataB-r3/eventsprite-final-build.log`, `eventsprite-final-objects.log`, `eventsprite-progress.log`.
