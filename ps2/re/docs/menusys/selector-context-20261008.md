# Debug-panel context and ordinary-walk selectors

Historical probe record. Current exact matches and guarded remainders are
listed in [notes.md](notes.md); later promotions are documented in
[night-20261008.md](night-20261008.md).

`MenuItemDebugDraw__Fv` at `0x002494E0` draws the debug item grid and the
selected character/weapon information page. The established menu/font/item
types remain unchanged. `decompile.sh` again encounters the documented
jump-table limitation; the source and retail case labels provide the
already analyzed page identities. Base: `24d3d21`, proto image, canonical
flags and existing GPR/FPR `0x30`/`0` history.

The isolated baseline is 32/1260 words, body `0x13A4` in extent `0x13B0`.
Seven private binary32 rows for `DrawMenuFillBox__Fffffiiii` reproduce every
floating argument schedule:

| Value / bits | Source identity | Policy |
| --- | --- | --- |
| 200 / `0x43480000` | Switch `[2]`, sibling argument 1 = 330 (`0x43a50000`) | `evaluate_first: false`, `evaluate_before: 2` |
| 60 / `0x42700000` | Switch `[4]` | Evaluate first |
| 60 / `0x42700000` | Switch `[6]` | Evaluate first |
| 230 / `0x43660000` | Switch `[6]` | Evaluate first |
| 260 / `0x43820000` | Switch `[6]` | Evaluate first |
| 230 / `0x43660000` | Switch `[7]` | Evaluate first |
| 260 / `0x43820000` | Switch `[7]` | Evaluate first |

The 330-Y sibling separates page 2's lower panel from its other fill calls.
Height 200 must precede width argument 2 in the ordinary walk while leaving
20-X and 330-Y first. Boolean early evaluation moves height ahead of those
coordinates and leaves seven new setup differences. The ordinary policy
removes them. Pages 4, 6 and 7 need different combinations despite sharing
their 236-X, 60-Y and 230-width literals. All rows have unambiguous real
source identities.

The best result is **8/1260 words**, with unchanged body size and matching
relocation offsets. One word at `+0x190` reverses the operands of the
commutative item-index addition. Seven at `+0xD4C..+0xD74` exchange the
three-name loop's s1/s2 counter and four-byte stride. No floating argument
is consumed in either residual region. The prior source-form trials are
not repeated under this promotion-only assignment.

The function then remained guarded and none of the partial rows was committed.
The night run commits all seven rows with the native promotion; the two
source residuals are resolved in [night-20261008.md](night-20261008.md).
The complete-wrapper probe checks `0x1B0D0` bytes and 5,905 relocations,
with only target bytes failing at `0x00249672`. All other unit bytes and
resolved relocations pass.
The source and all other menu functions remain unchanged. This is additional
evidence for all three prototype features: `control`, `argument`, and
`evaluate_before`, rather than a native promotion.

Receipts: `.private/ctxrows/menusys/m2c.c`,
`.private/ctxrows/menusys/baseline/`, `menusys-context/`,
`menusys-ordinary/`, and `menusys-best-full/`.
Exact candidates: `.private/ctxrows/menusys-ordinary-rows.json`.
Final guarded validation: `.private/ctxrows/receipts/final/`.

The final `CLEAN=1 JOBS=4` proto build passes `SCES_511.90: OK` and
149/149 complete objects. The production menusys object passes `0x1B0DC`
bytes and 5,872 relocations; its linked and source-only SHA-256 hashes
equal the baseline. The sole promotion in this lane is FishModifyParam.

## Proto2 round-1 cardinality audit

Base `202d02d`, image `chronicletwo_dev:sf-d8bf13c-proto2`. Every one of
the seven private fill-box rows above now asserts `expected_matches: 1`.
Both mwccgap passes accept the assertions, including the page-2 lower-panel
height scheduled before width in the ordinary walk. The selectors still
need `control`, `argument`, and `evaluate_before`.

The best complete-wrapper result remains **8/1260 words**, body `0x13A4`
in extent `0x13B0`, with matching relocation offsets. The single error is
target bytes at `0x00249672`; `0x1B0D0` bytes and 5,905 relocations are
checked. The residual addition at `+0x190` and name-loop register choices
at `+0xD4C..+0xD74` contain no eligible floating constant argument. The
prior arithmetic and loop-form trials are not repeated.

The source and guard remain unchanged, and no partial row is accepted into
the production profile. Receipt:
`.private/ctxrows-r1/menusys/cardinal-best/`; exact candidate:
`.private/ctxrows-r1/menusys-best-rows.json`.

## Proto2 round-1 final acceptance

The `CLEAN=1 JOBS=4` build passes all ten initialized PAL sections, the
`0x01F64A00` memory end, and `SCES_511.90: OK`. The complete checker passes
**149/149 units**. All **149 linked game-object hashes**, all **149
source-only object hashes**, and the complete linked ELF hash equal the
`202d02d` baseline. Game source and headers are unchanged.

Freshly regenerated `progress/report.json` and coverage retain **6,746
matched / 116 guarded / 10 assembly-only / zero fuzzy**. No function is
promoted in round 1; the only profile edits add count assertions to the
two already accepted FishModifyParam rows. Receipts:
`.private/ctxrows-r1/final/clean-build.log`, `check-objects.log`,
`coverage.txt`, `hashes.json`, `report.json`, and `comparison.json`.
