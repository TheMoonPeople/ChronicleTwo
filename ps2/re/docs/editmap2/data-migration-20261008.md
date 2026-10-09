# editmap2 data migration (2026-10-08)

Baseline: `d56248a7`; 8 `INCLUDE_RODATA` / 3
`INCLUDE_BSS` markers; matched_data 0/123.

## Native initializers and literals

`GroundBalance` already declares four zero-initialized integer weights and
uses the four retail model-name literals. Removing their five markers leaves
its object unchanged (`editmap2-native-ground-pieces`). The zero template is
compiler-generated initializer storage, rather than a persistent game state.

The river branch of `GetePlacePartsAtInfoID` now initializes its actual
`sceVu0FVECTOR` as `{0, 0, 0, -1}` and passes that vector directly to
`GetRiverNum`. This removes the union view, quadword type-pun, external
initializer and marker (`editmap2-river-position`).

`UpdateHouse` uses the inline decimal suffix format and `npclive` prefix,
and includes `mainloop.hpp` for `LanguageCode` instead of redeclaring it.
The ten-byte `char live_name[10] = "npclive";` is initialized inside the
model loop, where retail copies its initializer; the former `NpcLiveName`
wrapper struct is removed and the plain array compiles to the same copy
(`.private/fixes-r3c/b1-*.log`). Declaring its actual
suffix buffer immediately afterward preserves the existing stack order.
The initializer has eight meaningful string bytes, two trailing zero bytes,
and six piece-alignment bytes (`editmap2-npc-name-literals`,
`editmap2-npc-name-template`).

## Retained compiler-generated counter identities

`CheckEditParts` already has the natural function-local `static int cnt = 0`.
Removing `cnt_482` and `init_483` markers passes the full PAL verifier but
fails canonical object comparison: MWCC emits `cnt_185` and `init_186`, and
the mapper binds those compiler suffixes only when the retail markers are
retained. The guarded initialization and counter instructions match; no
manual initialization guard is introduced. Both markers remain pending a
shared mapper change (`editmap2-native-counter-guard`,
`editmap2-counter-guard-failed-objects`).

The exact private shared-tool proposal is
`.private/proposals/dataE-named-local-bss.patch`. It extends the existing
anonymous-BSS matcher to numeric-suffixed LOCAL names, requiring matching
source bases, declared sizes, section kinds, and consistent opcode-checked
code references. The native guard is one byte, with three bytes of trailing
piece alignment. A copied marker-free object passes all bytes and 143
resolved relocations (`named-local-bss-proposal-objects.log`). Negative
checks reject absent references, a different base name, GLOBAL storage, and
a conflicting reference (`named-local-bss-proposal-check.log`). The shared
script is unchanged; full tool integration remains with the tooling lane.

The corrected graph and named-BSS proposals pass the complete comparator
on copies of all 149 objects, including marker-free mapsky/editmap2 and
the native texture-workspace copy (`combined-mapper-proposals-objects.log`).
Retail, symbol, and piece inputs are shared immutably through the existing
explicit function parameters, retaining separate default-reference and
no-reference piece contexts. The actual canonical scripts and objects are
unchanged; linked PAL acceptance of tooling integration remains with the
tooling lane.

Final: 0 rodata / 2 BSS markers; matched_data
118/123 after the standard objdiff/progress refresh.
Every accepted step passes the full PAL build (`SCES_511.90: OK`) and
all 149 complete objects, including resolved relocations. The 148 other
object hashes are unchanged at each step. Function coverage stays
6,770 matched / 93 guarded / nine assembly-only / zero fuzzy.

Validation receipts are under `.private/dataE/`, with the step prefixes
listed above and `-build.log`, `-objects.log`, and `-hashes.log` suffixes.
Final refresh: `editmap2-final-progress.log`, `editmap2-final-coverage.log`,
and `editmap2-final-metrics.json`.
