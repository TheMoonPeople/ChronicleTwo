# Native data migration — 2026-10-08

## Result

The unit changes from 39 initialized-data markers and 10 BSS markers to 0 and 6.
Refreshed objdiff reports `matched_data` 1040/2416 before and after; anonymous
initializer data is not credited as a named matched object by this report.
All 95 functions remain matched. No Satan’s Fiddle profile rows change.

## Definitions and literals

`nowScene__2` and `action_info` use their documented header types.
The local collision-window pointer is `static ACTION_DAMAGE *LastCInfo2` and the
script dispatch slots are `static int (*ext_func[256])(RS_STACKDATA *, int)`.
The local dispatch description is a typed `RS_EXTFUNC_INFO[83]`: 82 handlers in
retail table order followed by `{NULL, ACTION_EXT_END}`. `ACTION_EXT_NUMBER`
documents each existing script external number. Static prototypes establish the
retail local linkage of the handlers before their addresses are initialized.
The table is 0x298 bytes; its former assembly piece carried another eight zero
alignment bytes, now supplied by the linker. Canonical comparison accepts this
zero tail and checks the same resolved function addresses.

Direct strings use their exact retail bytes, including Shift-JIS strings and
escaped adjacent literals where a hexadecimal escape would otherwise consume
an ASCII hex digit. The existing Ridepod movement switch emits its own jump table.
`_SET_BLOW_MOVE` initializes its forward vector at the original copy site and
places the matrix declaration after that vector. `_RELEASE_OBJ` initializes the
throw offset only in the throwing branch. `_SET_SPECIAL_SHOT` initializes four
typed effect-name pointers at their use, removing the integer pointer table and
quadword-copy cast. `_GET_RING_COLOR` initializes the four RGB rows directly.

`_SHOT` initializes `CanonObjectNames` inside its cannon branch. Its later target
buffers, weapon-health array and beam offset remain in their original declaration
order after that branch. This retains the exact frame layout, instructions,
relocations and float selector identities while emitting the eight frame names
and their pointer table naturally. The constant-copy-only `ScriptVector` union
is no longer needed.

## Remaining reservations

`sw_1617`, `init_1618`, `canon_slot_1620`, `init_1621`, `cnt_1661` and `init_1662`
reserve the native `_SHOT` statics and their compiler-generated guards. Source
already expresses these as `static int sw = 1`, `static int canon_slot = 0` and
`static int cnt = 0`. Removing the six markers preserves instructions but leaves
MWCC’s generated names (`sw_861`, `init_862`, `canon_slot_864`, `init_865`,
`cnt_905`, `init_906`) unmapped. The focused check reports missing/unexpected
`.sbss` pieces and unresolved relocations; it does not report instruction-byte
differences. The markers remain until the tooling lane supports native local
static/guard identity mapping. No synthetic locals or names are used to alter
MWCC’s generated counters.

## Verification receipts

- `.private/dataA-r2/actscript-native-dispatch.log`
- `.private/dataA-r2/actscript-native-vectors.log`
- `.private/dataA-r2/actscript-native-effects.log`
- `.private/dataA-r2/actscript-native-cannon.log`: whole unit passes,
  0x47F4 compared bytes and 1111 relocations.
- `.private/dataA-r2/actscript-unmarked-locals.log`: retained-reservation blocker.
- `.private/dataA-r2/actscript-build.log`: `SCES_511.90: OK`, 6763 perfect,
  zero fuzzy, 109 assembly, zero unmatched.
- `.private/dataA-r2/actscript-objects.log`: 149/149 units pass.

## Native identity proposal validation

The remaining six BSS markers can be removed without changing any function
instructions. The exact source cleanup is
`.private/proposals/actscript-remove-native-data-markers.patch`; it requires
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
passes 0x47F4 bytes and 1,111 resolved relocations. Combining the four private
replacement objects with the unchanged stock objects passes 149/149 checks,
and the resulting linked PAL passes every section and memory-extent check.
This staged validation does not install the proposal or claim a fresh whole-tree
build with modified tooling.

Receipts: `.private/dataA-r2/resume-proposal/actscript-final-check.log`,
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
audit changes only `actscript.cpp.o`; code metrics remain 6,775 matched functions
and 1,841,188 matched bytes. No function is promoted.

Markers change from 0 initialized-data / 6 BSS to 0 / 0.
Refreshed `matched_data` changes from 1584 to
1613 / 2405 bytes. Receipts are
`.private/dtool-r3/actscript-{build,objects,tests,all-tests}.log`,
`actscript-object-hash-audit.json`, and `actscript-report.json`; the independent
existing-tooling probe is `probe/actscript-check.log` in the same directory.
