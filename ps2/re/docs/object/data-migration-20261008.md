# Native object vtables

The existing unit notes establish the base `CObject` and derived `CObjectFrame`
virtual layouts. `object.cpp` now emits both tables from its own compile;
neither keeps an assembly marker. No function body changes.

## `CObjectFrame`

The already matched `CObjectFrame` methods emit `__vt__12CObjectFrame`
without an assembly marker. No manual vtable writes are introduced.
Receipt: `.private/dataB-r3/object-vtable-build.log`.

Markers: ROData **2 → 1**, BSS **0 → 0**.
Objdiff after the required refresh: matched_data **0 → 0** / total_data **244 → 244**.

Validation: `SCES_511.90: OK`, **149/149** complete objects including resolved relocations. No functions promoted. Receipts: `.private/dataB-r3/object-final-build.log`, `object-final-objects.log`, `object-progress.log`.

## `CObject`

MWCC emits a class's vtable in the translation unit that defines its first
non-inline virtual function. Retail binds `Draw__7CObjectFv` (0x161F60) and
`DrawDirect__7CObjectFv` (0x161F70) weak (binding 13) inside map's `.text`,
next to the other weak inline `CObject` virtuals (`Show`, `SetFarDist`,
`GetFarDist`, `SetNearDist`, `GetNearDist`, `Copy`). Both are therefore
inline in the class body in `map.hpp`, each returning 0.

`CObject`'s first non-inline virtual is then `Initialize`, defined here, so
`object.cpp` emits the 0x74-byte `__vt__7CObject` itself. Retail places the
table at 0x37B8E0, inside object's `.vtables` run (0x37B860-0x37B960).
`map.o` keeps only weak copies of the two inline bodies, as retail does.
Defining `Draw` and `DrawDirect` out of line in `map.cpp` instead makes
`Draw` the key function and `map.o` the table's emitter, which retail's
layout contradicts.

Markers: RODATA **1 → 0**, BSS **0 → 0**. Refreshed matched data:
**244 / 244**, now earned by this unit's own compile. PAL is
`SCES_511.90: OK`, all **149/149** canonical objects pass, and code metrics
are unchanged (**6,787** perfect functions). No function is promoted.
Receipts: `.private/vtable-r0/src-{build,check,tests}.log` and
`src-report.json`.
