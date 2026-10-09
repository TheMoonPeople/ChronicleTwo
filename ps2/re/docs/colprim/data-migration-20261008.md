# Native attack damage parameter table

The existing unit notes and `DAMAGE_PARAM` header establish the 0x48-byte row
layout and 115 attack records. The writable `Damage_Param_Table` now has its
natural typed definition with the existing public declaration and retail row
order. Every name preserves its Shift-JIS bytes through hexadecimal escapes.
Shape, target and attack kind use the established enums and flag combinations.
The reserved bytes are zero in all rows; unknown/status values remain numeric.

The native array has retail's declared 0x2058-byte extent. Its final eight zero
bytes belong to the section's alignment tail and are preserved by the existing
postprocessor; no synthetic sentinel row or padding variable is introduced.
All function bodies and all dependent header layouts are unchanged.


Markers: ROData **1 → 0**, BSS **0 → 0**.
Objdiff after the required refresh: matched_data **0 → 8280** / total_data **8280 → 8280**.

Validation: `SCES_511.90: OK`, **149/149** complete objects including resolved relocations. No functions promoted. Receipts: `.private/dataB-r3/colprim-final-build.log`, `colprim-final-objects.log`, `colprim-progress.log`.
