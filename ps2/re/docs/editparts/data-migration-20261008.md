# Native edit part position and vtable data

The existing unit notes establish the homogeneous position initializer and
`CEditParts` vtable. `SetPosition(x, y, z)` now initializes a local float array
as `{0, 0, 0, 1}` before setting its three coordinates, removing the external
template, float/quadword union and reinterpret-copy. The existing virtual
methods emit the vtable naturally. No manual vtable writes or new helpers.
The initializer and vtable removals pass independently.


Markers: ROData **2 → 0**, BSS **0 → 0**.
Objdiff after the required refresh: matched_data **0 → 148** / total_data **148 → 148**.

Validation: `SCES_511.90: OK`, **149/149** complete objects including resolved relocations. No functions promoted. Receipts: `.private/dataB-r3/editparts-final-build.log`, `editparts-final-objects.log`, `editparts-progress.log`.
