# Native sub-game state and voice format

The existing unit notes establish the running-game number, menu permission,
inventory-overflow flag and retained parameters. The three flags are typed,
documented file-static integer definitions; `GameInfo` retains its existing
natural constructor and has a purpose comment. The streamed-voice filename
format is the ordinary `%d.wav` literal at use. The state and literal steps
pass independently, including the compiler-generated initializer.


Markers: ROData **1 → 0**, BSS **3 → 0**.
Objdiff after the required refresh: matched_data **52 → 71** / total_data **71 → 71**.

Validation: `SCES_511.90: OK`, **149/149** complete objects including resolved relocations. No functions promoted. Receipts: `.private/dataB-r3/subgame-final-build.log`, `subgame-final-objects.log`, `subgame-progress.log`.
