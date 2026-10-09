# Native action character data

All 47 initialized-data markers are replaced by source-emitted data. Strings
are inlined at their uses with exact retail bytes, including the Shift-JIS
motion and effect names. Existing movement-vector initializers, the
`CheckDamage` switch, and the compiler-generated `CActionChara` virtual table
emit their corresponding sections without the duplicate markers.

`EntryThrowItem` contains its nineteen-item aggregate initializer. The eighteen
item numbers select the corresponding item model slots, followed by the -1
terminator. The object is 76 bytes with a four-byte alignment gap.

`HitEffectSet` and `GuardEffectSet` initialize their four-float directions at
the former constant-copy sites. `StepParam` initializes its two forward vectors
in the branches where they are used. The associated matrices and knockback
buffers are declared in their use scopes, preserving the retail stack layout.
Every focused step passes all 0x8F80 checked bytes and 1,035 resolved relocations;
the Satan's Fiddle profile is unchanged.

The previous stick direction is a documented static `float old_angle` definition.
`Step` uses a native `static float ang = 0.0f` instead of an explicit external
angle and initialization guard. Its generated initialization instructions match
retail while the two corresponding BSS reservations remain.

## Remaining BSS reservations

Three markers remain: `ang_3371`, `init_3372`, and `at_3107`. The first pair
belongs to the native arm-angle local static; the final sixteen bytes are the
compiler-generated zero initializer for `RunScript`'s `adjusted_velocity`.
Removing the markers preserves instruction bytes but the current postprocessor
does not bind their generated BSS names to retail symbols. The canonical
checker rejects the anonymous BSS pieces and their unresolved relocation targets.
No compiler-generated names, manual guards, or substitute storage definitions
are invented to conceal this mapping limitation.

Receipts are under `.private/dataA-r2/`: `actionchara-rodata-strings.log`,
`actionchara-emitted-data.log`, `actionchara-stick-state.log`,
`actionchara-throw-items.log`, `actionchara-hit-direction.log`,
`actionchara-guard-direction.log`, `actionchara-forward-scopes.log`,
`actionchara-arm-static.log`, and `actionchara-native-bss.log` (rejected).

The full build retains `SCES_511.90: OK`, and all 149 objects pass. Refreshed
`matched_data / total_data` is 288 / 1124 (baseline 288 / 1124).
Whole-project receipts: `.private/dataA-r2/actionchara-build.log` and
`actionchara-objects.log`. No header or Satan's Fiddle row changes are needed.

## Native identity proposal validation

The remaining three BSS markers can be removed without changing any function
instructions. The exact source cleanup is
`.private/proposals/actionchara-remove-native-data-markers.patch`; it requires
`.private/proposals/native-local-data-identities.patch` for the object
postprocessor. The retained source keeps its markers until that tooling change
is integrated. No build script or Satan's Fiddle profile is changed in this lane.

The proposal requires every live incoming BSS reference to belong to a complete,
byte-identical retail function with matching declared extent. It resolves the
other relocation destinations, validates HI16/LO16 pairs in emitted record
order, and requires one agreed destination, the same source base name, exact
retail object size, the correct section, and a sole zero-offset object definition.
For initialized named locals, exact symbol and section sizes and the retail
section kind are checked before naming; existing bounded alignment padding is
applied afterward. Pointer-table literals are named before their tables.

The exact marker-free source was freshly compiled privately through both
mwccgap passes with the pinned image and unchanged profile. Its final object
passes 0x8F80 bytes and 1,035 resolved relocations. Combining the four private
replacement objects with the unchanged stock objects passes 149/149 checks,
and the resulting linked PAL passes every section and memory-extent check.
This staged validation does not install the proposal or claim a fresh whole-tree
build with modified tooling.

Receipts: `.private/dataA-r2/resume-proposal/actionchara-final-check.log`,
`final-objects.log`, and `final-verify.log`. The private safety harness receipt
`.private/dataA-r2/proposal-safety-v2.log` contains 25 successful checks,
including rejection of changed instructions, truncated functions, changed calls,
non-code consumers, duplicate relocation sites, orphan lows, wrong base names,
object aliases, wrong sizes and sections, nonlocal bindings, and changed table
pointers. The untouched canonical control passes; both initialized-local
metadata counterexamples are rejected by the canonical checker.

## Marker-free storage validation, tooling round 3

The existing all-consumer BSS matcher names the native local statics, guards and zero initializer objects without any shared-tool changes.

A fresh marker-free private compile passes the complete unit with the checkpoint
tooling. The accepted source passes `SCES_511.90: OK`, all 149 object checks,
and all 17 build regression scripts (116 discovered tests). The object hash
audit changes only `actionchara.cpp.o`; code metrics remain 6,775 matched functions
and 1,841,188 matched bytes. No function is promoted.

Markers change from 0 initialized-data / 3 BSS to 0 / 0.
Refreshed `matched_data` changes from 1094 to
1119 / 1119 bytes. Receipts are
`.private/dtool-r3/actionchara-{build,objects,tests,all-tests}.log`,
`actionchara-object-hash-audit.json`, and `actionchara-report.json`; the independent
existing-tooling probe is `probe/actionchara-check.log` in the same directory.
