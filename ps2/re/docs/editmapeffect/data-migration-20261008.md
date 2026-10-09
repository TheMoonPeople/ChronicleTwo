# Native editor effect texture names

The established unit notes identify the two fire-effect texture names and the
local frame-attribute object with its constructor guard. The existing ordinary
`fire_wrk` and `lightling` literals now supply their strings without markers.
All function bodies, including the natural `static mgCFrameAttr attr`, are
unchanged.

The attribute and guard markers are retained. Their removal cannot satisfy the
canonical local-static identity check, so native source remains present behind
the two required markers. Receipts: `.private/dataB-r3/editmapeffect-statics-build.log`
and, when linking succeeds, `editmapeffect-statics-objects.log`.


Markers: ROData **2 → 0**, BSS **2 → 2**.
Objdiff after the required refresh: matched_data **0 → 26** / total_data **171 → 171**.

Validation: `SCES_511.90: OK`, **149/149** complete objects including resolved relocations. No functions promoted. Receipts: `.private/dataB-r3/editmapeffect-final-build.log`, `editmapeffect-final-objects.log`, `editmapeffect-progress.log`.

## Round-4 retained-marker checks

The existing BSS matcher identifies the native `mgCFrameAttr` static and
its one-byte constructor guard. Both storage markers are removed; the
natural local object and all function bodies are unchanged.

Markers: rodata 0 → 0, BSS 2 → 0.
Native data credit: 26 → 171 / 171.

Validation: `.private/dtool-r4/editmapeffect-{build,objects,tests}.log`.
PAL is byte-identical and all 149 complete objects pass. Other game objects
retain their baseline hashes, and the code metric is unchanged.
