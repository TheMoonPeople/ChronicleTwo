# runscript_opcodes data migration (2026-10-08)

The fresh round-2 baseline has 14 rodata markers, 4 BSS markers, and
`matched_data` 0 / `total_data` 2700. All functions in this unit already
match; the existing notes own their type and behavior analysis.

## Diagnostic and model literals

Nine string markers are removed. `_SET_BODY`, `_SET_DMG`, `_GET_MAPOBJ_POS`,
and `SetMonsterExtendTable` now use the exact diagnostic strings directly.
The range/monster-index diagnostics and the ridepod weapon name already
occur as literals in native functions, so their unused extern declarations
and markers are removed without changing those bodies. The Shift-JIS weapon
name already uses hexadecimal escapes.

The assembly words establish exact text, including the spelling
`mscript same ext_func_no!!!` and the lack of a newline in `ext func over!!`.
Validation: `.private/dataC-r2/opcodes-strings-{build,objects}.log` and
`opcodes-strings-metrics.json`; the image and all 149 objects pass and all
unowned objects retain their baseline hashes.

## Active script state

`nowScene`, `nowMonster`, `LastCInfo2`, and `ext_func` become typed definitions.
The scene and damage pointers and the 256-entry callback array have local
retail binding and are `static`; `nowMonster` retains its header-declared
global binding. `ACTION_DAMAGE` is the established return type of
`CActionChara::EntryDamage2`, resolving the older note's pointee question.
Their extents are 4, 4, 4, and 0x400 bytes, respectively.

Validation: `.private/dataC-r2/opcodes-state-{build,objects}.log` and
`opcodes-state-metrics.json`. All BSS markers are removed; all code bytes and
relocations remain exact, the complete image passes, and unowned objects
are unchanged.

## Horizontal vector initializers

`at_1480__2`, `at_1481__2`, `at_1864`, and `at_2160` each hold
`{0.0f, 0.0f, 1.0f, 0.0f}`. The three callers now initialize SDK
`sceVu0FVECTOR` locals directly; the quadword-view union and its four extern
objects are removed.

A first trial declared these locals after the scratch arrays. Its copy
instructions and template data were correct, but MWCC assigned the vectors
later stack slots: `_GET_ANGLE_INNER` used 0xB0/0xC0 instead of 0x30/0x40.
Using the SDK alignment alone did not fix those offsets. Declaring the
vectors before their scratch matrices/position arrays restores the retail
stack slots without changing the time the initializers execute. Evidence:
`opcodes-vector-m2c.txt`, `opcodes-vectors-native.txt`, and the two failed
trial build logs under `.private/dataC-r2/`.

Acceptance: `opcodes-ordered-vectors-{build,objects}.log`; the whole image,
all 149 objects, and all unowned hashes pass. Only the named callback
metadata table remains marker-backed.

## Callback return types required by the typed table

The metadata row's callback type is `int (RS_STACKDATA *, int)`. Three
callbacks were declared `void`, preventing a natural initializer without
incompatible function-pointer casts. `_ESM_FINISH` and `_ESM_DELETE` leave
the integer status of `SetScriptProgNo` and `DeleteEffSpt` in v0.
`_ESM_GET_TARGET_ID` leaves `GetScriptTargetId`'s status in v0 while its
subsequent file-local integer `SetStack` call uses only a0/a1/a2/v1.

All three now return those existing manager results explicitly. Their
native instructions, sizes, and relocations remain identical. The m2c
receipts for each callback are under `.private/dataC-r2/*-m2c.txt`; the
acceptance receipts are `opcodes-callback-returns-{build,objects}.log`.
This corrects the callback types before defining the table and introduces
neither casts nor adapter callbacks.

## Callback metadata

`ext_func_info` is a file-local `RS_EXTFUNC_INFO[174]`: 173 callback/number
pairs followed by `{NULL, -1}`. Its native definition preserves assembly
order, its 0x570-byte extent, and every function-pointer relocation.
`RS_MONSTER_EXTFUNC` names the exact assigned numbers and dispatch limit in
the owned header; the existing row and public function declarations remain
source-compatible. Callback purposes reuse the established native-function
analysis, including the two effect vectors and target/user identifiers.
`_SET_DEAD_OFF` emits death effects and weapon-experience pickups rather than
the item/money drop behavior of `_SET_DEAD_START`.

Final acceptance: `.private/dataC-r2/opcodes-native-table-{build,objects}.log`
and `opcodes-native-table-metrics.json`. There are no rodata or BSS markers,
and native data coverage is 2700 / 2700. The full image and all 149 objects
pass, including units that include the owned header; every unowned object
hash remains unchanged. No data marker or tooling proposal is parked.

## Tagged stack-value accesses

The numeric/string helpers and both output-reference overloads now use
`RS_STACKDATA::val.f`, `val.s`, and `val.p` directly, replacing integer-field
pointer views. `_GET_MONSTER_LIFE`, `_V_POP`, and `_V_POP2` likewise obtain
their output slot from `val.p` after checking `RS_PTR`. Their tag tests use
the established `RS_STACK_TYPE` enum; conversions and dispatch semantics
are unchanged.

Each helper/reference group was validated independently. Acceptance:
`.private/dataC-r2/opcodes-{typed-stack-values,int-stack-type,life-stack-reference,variable-stack-reference,variable2-stack-reference}-{build,objects}.log`.
Every instruction and resolved relocation stays exact, and the complete
image, all 149 objects, and all unowned hashes pass. Native data remains
2700 / 2700 with no markers.

## Declared function extents

The header function-size annotations use the retail ELF's declared
`STT_FUNC` extents. 2 annotations previously included the alignment
gap up to the next function and are corrected without changing declarations
or layouts. The symbol names and addresses remain exact.

Header validation: `.private/dataC-r2/header-extents-final-{build,objects}.log`.
The complete PAL image, all 149 objects, and every unowned object hash pass.
The evidence audit is `header-metadata-corrections.json` in the same directory.
