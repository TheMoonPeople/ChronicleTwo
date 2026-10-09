# Native sword-trail start diagnostic

The existing unit notes identify the `start !!\n` format. `StartEffect` now
uses the ordinary literal at use, removing the external string declaration and
assembly marker. The trail parameters, curve arithmetic, helper masks and
floating evaluation policy are unchanged; all emitted code stays exact.


Markers: ROData **1 → 0**, BSS **0 → 0**.
Objdiff after the required refresh: matched_data **0 → 10** / total_data **10 → 10**.

Validation: `SCES_511.90: OK`, **149/149** complete objects including resolved relocations. No functions promoted. Receipts: `.private/dataB-r3/swordeffect-final-build.log`, `swordeffect-final-objects.log`, `swordeffect-progress.log`.
