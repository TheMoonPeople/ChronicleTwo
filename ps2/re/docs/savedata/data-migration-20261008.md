# Native save configuration size diagnostic

The existing unit notes identify the configuration-size format. Its ordinary
`size : %d\n` literal at use now supplies the string without an external
declaration or assembly marker. The save layouts, configuration initializer,
copy operations and tournament code are unchanged.


Markers: ROData **1 → 0**, BSS **0 → 0**.
Objdiff after the required refresh: matched_data **0 → 11** / total_data **11 → 11**.

Validation: `SCES_511.90: OK`, **149/149** complete objects including resolved relocations. No functions promoted. Receipts: `.private/dataB-r3/savedata-final-build.log`, `savedata-final-objects.log`, `savedata-progress.log`.
