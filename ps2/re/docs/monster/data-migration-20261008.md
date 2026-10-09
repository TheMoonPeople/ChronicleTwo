# Native data migration — 2026-10-08

## Monster definitions

`base_monster_define` is native mutable `BASE_MONSTER_TBL[344]` storage, matching
its documented 0xB8-byte layout and global binding. Every record is initialized
by its typed fields in retail order. All three fixed-size string arrays in each
record have zero tails, and all nine implicit padding bytes per record are zero.
The weapon-wear floats are finite and reproduced exactly as binary32 literals.
The final record is `{-1}`: every byte after its ID is zero and its empty name
terminates lookups. Mutation by the language loader requires mutable storage.

MWCC initializes an anonymous-union member directly with the member array’s
braces; another enclosing union brace rejects subsequent initializers. The
drop-item arrays use the accepted natural aggregate form. The header layout
and public declarations remain unchanged.

This step removes the main table marker, reducing initialized-data markers from
43 to 42. Refreshed objdiff still reports matched data 0/64936 (the field is absent
when zero). Native source coverage and objdiff’s data-symbol credit differ here;
resolved object comparison and the PAL verifier remain the acceptance checks.

Receipts:

- `.private/dataA-r2/monster-base-table.log`: whole unit passes, 0x167F8 bytes
  and 587 relocations.
- `.private/dataA-r2/monster-base-build.log`: `SCES_511.90: OK`, 6763 perfect,
  zero fuzzy, 109 assembly, zero unmatched.
- `.private/dataA-r2/monster-base-objects.log`: 149/149 units pass.

## Language and combat tables

The seven language pointers inline the six exact retail messages; the seventh
reuses the English literal. Both UV tables are `static int[7][4]`. The attack-kind
lookup is `static s16[26]`. The fourteen `MONSTER_REACT` records use existing
`DamageKind` enumerators wherever that shared enum defines the recorded kind.
Kinds 14 and 21 remain numeric because the shared header does not define them.
The two-entry `SPI_TAG_PARAM` table contains `"NAME"` and `_MONSTER_NAME`, then
null pointers; the callback has its documented retail local linkage.

The gift table’s actual symbol is 88 bytes, not an integral number of six-byte
rows. It contains fourteen triples followed by two negative halfwords. A flat
`static s16[44]` preserves that real extent. `MONSTER_GIFT_ENTRY_FIELDS` names
the three-halfword stride used by `CheckGiftPack`; ordinary element indexing
preserves all of that function’s instructions without an array-type cast or
reading a synthetic final third field. The third field of complete rows remains
unknown. Piece padding is zero: four bytes for the language-pointer table,
twelve for the attack-index table and eight for the gift table.

## Literals, vectors and native static state

All initialized-data markers are removed: the final count is 0 initialized-data
markers and 3 BSS reservations. The existing element-rate and launch-vector
initializers and compiler-generated virtual table emit their own data. Strings
at direct use sites retain their retail bytes, including the guard effect name.
Hit/guard directions are native `float[4]` initializers at the original copy
sites. The hit texture rectangle is declared after the hit direction, retaining
its stack position. Shadow normal/position vectors are initialized in their
actual use scopes, and the dropped-item velocity is a native vector initializer.
No float selectors or Satan’s Fiddle rows are changed.

`HitScoreSet` uses `static int dmg_sc_cnt = 0` instead of explicit external
counter/guard tests. Its counter and guard markers, plus the zero-initializer
marker for `DrawShadowActMonster`, remain because the postprocessor cannot name
the corresponding native BSS objects. Removing them leaves `dmg_sc_cnt_1152`,
`init_1153` and `at_1783` unmapped, with no instruction-byte differences. The
native guard occupies one byte while its retail piece reserves four; a tooling
change must preserve the zero padding while establishing identity.

An incidental existing rectangle-copy cast was tested with `hit->tex_rect = rect`
and with `mgRect<int> copy = rect` plus the existing field stores. Both reduce
`HitEffectSet` from 0x334 to 0x324 bytes: MWCC eliminates the retail intermediate
quadword copy. Explicit field aggregate initialization instead grows the
function to 0x364 and introduces another zero initializer. These rejected forms
are restored; the pre-existing rectangle-copy cast remains outside the migrated
data initializers. No new type-puns are introduced. The existing matrix-copy
casts are likewise unchanged.

Final focused and whole-project receipts:

- `.private/dataA-r2/monster-small-tables.log`: all typed tables pass.
- `.private/dataA-r2/monster-native-literals.log`: literals and native counter pass.
- `.private/dataA-r2/monster-native-vectors.log`: whole unit passes, 0x167EC
  compared bytes and 587 relocations; trailing zero alignment comes from linking.
- `.private/dataA-r2/monster-unmarked-locals.log`: retained BSS mapping blocker.
- `.private/dataA-r2/monster-native-rectangle.log`,
  `monster-typed-rectangle-copy.log`, `monster-rectangle-fields.log`: rejected
  incidental cast cleanup attempts.
- `.private/dataA-r2/monster-build.log`: `SCES_511.90: OK`, 6763 perfect,
  zero fuzzy, 109 assembly, zero unmatched.
- `.private/dataA-r2/monster-objects.log`: 149/149 units pass.

The final refreshed data measure remains 0/64936.

## Native identity proposal validation

The remaining three BSS markers can be removed without changing any function
instructions. The exact source cleanup is
`.private/proposals/monster-remove-native-data-markers.patch`; it requires
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
passes 0x167EC bytes and 587 resolved relocations. Combining the four private
replacement objects with the unchanged stock objects passes 149/149 checks,
and the resulting linked PAL passes every section and memory-extent check.
This staged validation does not install the proposal or claim a fresh whole-tree
build with modified tooling.

Receipts: `.private/dataA-r2/resume-proposal/monster-final-check.log`,
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
audit changes only `monster.cpp.o`; code metrics remain 6,775 matched functions
and 1,841,188 matched bytes. No function is promoted.

Markers change from 0 initialized-data / 3 BSS to 0 / 0.
Refreshed `matched_data` changes from 64899 to
64920 / 64920 bytes. Receipts are
`.private/dtool-r3/monster-{build,objects,tests,all-tests}.log`,
`monster-object-hash-audit.json`, and `monster-report.json`; the independent
existing-tooling probe is `probe/monster-check.log` in the same directory.
