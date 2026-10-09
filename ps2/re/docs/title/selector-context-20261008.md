# Title phase selectors

On `24d3d21` with `chronicletwo_dev:sf-d8bf13c-proto`, the isolated native
`TitleModeKey__Fv` baseline has 379/624 positional word differences because
of the previously documented four-byte contraction. The old private
zero/128 rows give 15/624. The existing m2c analysis and documented menu,
phase, card-manager and fade types are retained; the fresh m2c receipt is
`.private/ctxrows/title/m2c.c`.

Five disjoint binary32 rows for `CalcMenuAdd__FPfff` fix every fade call:

| Value / bits | Switch values | Policy |
| --- | --- | --- |
| 0 / `0x00000000` | `[0]` (push-start) | Evaluate first |
| 0 / `0x00000000` | `[1]` (menu) | Evaluate first |
| 128 / `0x43000000` | `[1]` | Evaluate first |
| 128 / `0x43000000` | `[10]` (extras menu) | Evaluate first |
| -8 / `0xc1000000` | `[10]` | Evaluate first |

Phase 0's 8/128 title-alpha call retains the default schedule, while phase
10's -8/zero menu-alpha call evaluates -8 first. The selectors reproduce
their differing real phase contexts without overriding one broad row with
a conflicting narrower row. No sibling-argument selector or ordinary-walk
priority is needed.

The best result is **5/624 words**, body `0x9BC` in extent `0x9C0`, with
all relocation offsets restored. The only remaining words are
`+0xC8`, `+0xCC`, `+0x188`, `+0x198`, and `+0x1AC`: the two captured card
bytes exchange s1/s2, including the second narrowing's reused register.
These are integer loads, masks and comparisons; there is no floating call
argument at those sites for the selectors to choose. Source lifetime/type
experiments already recorded in notes are not repeated.

The complete-wrapper probe has one problem, target bytes at `0x002A521A`;
all other unit bytes and relocations pass (`0x68B4` bytes, 2,200 relocations).
The function then remained guarded and none of these partial rows was committed.
The night run commits all five rows with the native promotion; the card-byte
residual is resolved in [night-20261008.md](night-20261008.md).
The source is unchanged. `TitleBootInit` is not attempted.

Exact candidate rows: `.private/ctxrows/title-context-rows.json`.
Source-only receipt: `.private/ctxrows/title/title-context/`.
Complete-unit receipt: `.private/ctxrows/title/title-best-full/`.
Final clean guarded validation: `.private/ctxrows/receipts/final/`.

The final `CLEAN=1 JOBS=4` proto build passes `SCES_511.90: OK` and
149/149 complete objects. The production title object passes `0x68B8`
bytes and 2,081 relocations; its linked and source-only SHA-256 hashes
equal the baseline. The sole promotion in this lane is FishModifyParam.

## Proto2 round-1 cardinality audit

Base `202d02d`, image `chronicletwo_dev:sf-d8bf13c-proto2`, canonical
MWCC flags and unchanged helper history. The existing fade candidate is
checked with `expected_matches` counts **3, 1, 2, 1, 1**, in the order of
the five-row table above. Phase 0 has three zero endpoints; phase 1 has
one zero and two 128 endpoints; phase 10 has one endpoint of each selected
value. Both mwccgap passes accept these exact source-argument counts.

The complete-wrapper result remains **5/624 words**, body `0x9BC` in
extent `0x9C0`, with matching relocation offsets. The only canonical error
is target bytes at `0x002A521A`; `0x68B4` bytes and 2,200 relocations are
checked. The five residual integer snapshot words are unchanged. No
floating call argument is consumed in their load/mask/comparison region,
so narrowing a float selector does not address that register permutation.
The recorded source lifetime/type trials are not repeated.

The function remains guarded and its source is unchanged. The five partial
rows, including their count assertions, remain private. Receipt:
`.private/ctxrows-r1/title/cardinal-best/`; exact candidate:
`.private/ctxrows-r1/title-best-rows.json`.

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
