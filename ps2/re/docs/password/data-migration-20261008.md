# Native password conversion diagnostic

The existing unit notes identify the unsigned-long round-trip error format.
`ConvertBinToTxt` now uses the ordinary `err %lu\n` literal at use, removing the
assembly-data declaration and string pointer cast. The native digit alphabet,
random seed and all conversion/checksum code remain unchanged.


Markers: ROData **1 → 0**, BSS **0 → 0**.
Objdiff after the required refresh: matched_data **63 → 72** / total_data **72 → 72**.

Validation: `SCES_511.90: OK`, **149/149** complete objects including resolved relocations. No functions promoted. Receipts: `.private/dataB-r3/password-final-build.log`, `password-final-objects.log`, `password-progress.log`.
