# Outline data migration, October 8 night, round 4

Baseline: `9eb8f660`, pinned SF image and unchanged compiler flags/profile.
The established outline fields and sprite templates are documented in notes.md.

The body-composite colour comes from the existing local
`int body_color[4] = {128, 128, 128, 0}`. Its native template replaces
`at_338`; the unused external declaration is removed. The existing local
arrays in `COutLineDraw::Draw` supply `at_299__2`, `at_300__2` and
`at_325`. The zero-initialized vertex/texture arrays in `DrawDivSprite4`
supply `at_395`, `at_396`, `at_398` and `at_399`.

The rodata template, the Draw BSS templates and the helper BSS templates
are removed in separate exact-object steps. No function-body rewrite,
new data object or header change is needed. No data marker remains.

## Measurement and validation

Markers (RODATA / BSS): **1 / 7 → 0 / 0**.
Fresh objdiff `matched_data / total_data`: **0 / 128 → 128 / 128**.

`outline-final-build.log` prints `SCES_511.90: OK`; `outline-final-objects.log`
passes 149/149 objects. These receipts, the incremental checks, baseline
measurements and object-hash audit are under `.private/dataB-r4/`.
All objects outside the seven owned units retain their baseline file hashes.
No function is promoted and no assembly fallback or guarded function body changes.
