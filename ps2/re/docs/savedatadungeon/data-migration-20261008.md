# Native dungeon save limits and diagnostic

The existing unit notes establish the seven dungeon floor limits and the floor
transition diagnostic. `limmit_table` is a native file-static seven-halfword
array, preserving the retail spelling, values and extent. The diagnostic is an
ordinary string literal at use. The floor-record type and indexing remain
unchanged. Each table/literal step passes independently.


Markers: ROData **2 → 0**, BSS **0 → 0**.
Objdiff after the required refresh: matched_data **0 → 48** / total_data **48 → 48**.

Validation: `SCES_511.90: OK`, **149/149** complete objects including resolved relocations. No functions promoted. Receipts: `.private/dataB-r3/savedatadungeon-final-build.log`, `savedatadungeon-final-objects.log`, `savedatadungeon-progress.log`.
