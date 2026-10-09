# Primitive vertex initializer

`mgCDrawPrim::Vertex(float, float, float)` initializes its four-lane position array with `{0.0f, 0.0f, 0.0f, 0.0f}` before assigning the three supplied coordinates. This natural aggregate initializer replaces the external byte array and quadword type-punned copy, emits the same sixteen zero bytes, and preserves the zero fourth lane passed to `Vertex(float *)`.

The existing VU conversion routines and optimizer pragmas are unchanged; this step introduces no assembly or compiler-profile changes.


Markers: ROData **0 → 0**, BSS **1 → 0**.
Objdiff after the required refresh: matched_data **0 → 16** / total_data **16 → 16**.

Validation: `SCES_511.90: OK`, **149/149** complete objects including resolved relocations. No functions promoted. Receipts: `.private/dataB-r3/mg_drawprim-final-build.log`, `mg_drawprim-final-objects.log`, `mg_drawprim-progress.log`.
