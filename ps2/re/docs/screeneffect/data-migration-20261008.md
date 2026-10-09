# Screen-effect aggregate initializers

The existing native `DepthOfField` and `LensFlare` bodies supply four two-element arrays: depth values, alpha values, texture pointers and radii. MWCC emits their eight-byte zero initialization templates in `.sbss`; the values subsequently assigned by the functions are unchanged. The four explicit BSS reservations are redundant and can be removed individually with zero object differences.

Both function bodies and their calibrated compiler-profile rows remain unchanged. No new helper, type-pun, assembly, or dummy variable is introduced.


Markers: ROData **0 → 0**, BSS **4 → 0**.
Objdiff after the required refresh: matched_data **0 → 32** / total_data **32 → 32**.

Validation: `SCES_511.90: OK`, **149/149** complete objects including resolved relocations. No functions promoted. Receipts: `.private/dataB-r3/screeneffect-final-build.log`, `screeneffect-final-objects.log`, `screeneffect-progress.log`.
