# Intersection zero-vector storage

`IntersectionPipeYPoly3` already declares its zero seed as a function-local `static sceVu0FVECTOR at`. The compiler emits the sixteen zero bytes used to initialize the plane-tangent axis; the explicit BSS reservation is redundant. Removing it preserves the function body and all resolved references.


Markers: ROData **0 → 0**, BSS **1 → 0**.
Objdiff after the required refresh: matched_data **0 → 16** / total_data **16 → 16**.

Validation: `SCES_511.90: OK`, **149/149** complete objects including resolved relocations. No functions promoted. Receipts: `.private/dataB-r3/intersection-final-build.log`, `intersection-final-objects.log`, `intersection-progress.log`.
