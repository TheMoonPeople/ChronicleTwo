# Mapselect data migration (2026-10-08)

## Baseline and verification

Checkpoint `c9694e24` contains 52 `INCLUDE_RODATA` markers and 21
`INCLUDE_BSS` reservations. All 23 functions already match; refreshed
objdiff reports 32,832/33,980 matching data bytes.

Every accepted step uses the pinned image, a full PAL build, the canonical
149-object checker and hashes of all 148 other objects against the preceding
accepted checkpoint. Private receipts are under `.private/dataA-r1/`.

## Native map and viewer state

Nineteen named BSS reservations now have documented native definitions.
The counters, selections and buffer positions use `int`; `map_name` points
to the existing 0x1C-byte `MAP_NAME_INFO` records; `CharBuff` points to their
following strings; `MenuStack` is an `mgCMemory` pointer. The per-category
lists are `char **SelectMapList[MAP_SEL_TYPE_NUM]` with parallel integer counts.
`EventInfo` and `BossBattleSelFlag` retain their public header declarations.
The dead `NONMATCHING` state block and reservation guards are removed.

`MapNameBuff` is a 0x8000-byte arena containing a dynamic number of map
records followed by variable-length strings. It is a native character array,
not a fixed record array or a table of padded records. The existing serialized
arena offsets remain valid. Earlier notes' `u_long128[0x800]` description does
not match the byte-oriented source traversal.

The arena retains baseline global linkage because generated `Vu_progmain`
data references `MapNameBuff` by name at multiple interior offsets. A
file-local definition passes the isolated object comparison but makes the
full linker reject these references. The rejected source is preserved as
`.private/dataA-r1/failed-mapselect-storage.cpp`; generated data is unchanged.

`MapTypeSelect` now declares its natural function-local `static int select = 0`.
The compiler supplies the initialization guard and assignments formerly
written explicitly. The `select_1009` and `init_1010` externs are removed;
the two reservations remain pending native BSS identity support.

Receipts: `mapselect-storage` and `mapselect-guard`, each with
`-{build,objects,hashes}.log`. Both accepted steps pass PAL, all 149 objects
and all 148 other object hashes. Markers are now 52/2.

## Named menu data

All seven named initialized objects now have documented native definitions.
`map_sel_type[MAP_SEL_TYPE_NUM]` contains the eight exact category labels;
its eight string markers are removed with the table. `SelectMapName[0x100]`
is the initialized empty writable name buffer. `SPI_TAG_PARAM tag[3]`
contains the two map script commands and its null terminator, with the two
command string markers removed together.

`select__1049[16]` and `top__1050[16]` are each 0x40 bytes, correcting the
preceding extern declarations of only eight integers. Only the eight current
categories index them; the retail object extents still contain sixteen rows.
`SedSelData[SED_ITEM_NUM]` holds six zero-initialized integers, and
`config_str[1]` contains the caption label. The extra eight bytes after the
save editor values, eight after the tag table, and four after the config
pointer are piece padding, not extra source elements. Native definitions use
the declared extents and existing verified postprocessing supplies padding.

Each object has a separate `mapselect-<name>-{build,objects,hashes}.log`
receipt. All seven accepted steps pass PAL, all 149 objects and all 148 other
object hashes. Markers are now 34/2.

## Local selection and line-break templates

`SaveDataEditLoop` now initializes its two `SaveEditLabels` pairs locally:
`{"  ",">>"}` and `{"OFF","ON"}`. `EventViewLoop` uses the same typed
pointer pair for its cursor markers. Its preceding `EventListColors` type
was incorrect: retail's two words are string addresses passed to `%s`, not
color values. The obsolete type, extern and assignment are removed; the
native initializer remains at the original copy point.

The first cursor template must be migrated with both shared cursor literals.
Migrating the template alone leaves two extra read-only pieces (43 versus
41); PAL grows by 0x80 bytes and the checker rejects the layout. The
accepted grouped step inlines the two labels in `MapTypeSelect` and removes
their markers with `at_1125`. Both local marker pairs share the original
pooled strings. The OFF/ON strings similarly migrate with `at_1128__2`.

`GetLine` initializes the documented two-byte `LineBreakPair` with CR and
LF. There is no trailing null byte in this object. Its extern, assignment
and marker are removed.

The four accepted receipt prefixes are `mapselect-at_1125`,
`mapselect-at_1128__2`, `mapselect-at_1270__4`, and
`mapselect-at_1377__2`, each with `-{build,objects,hashes}.log`.
Every accepted step passes PAL, all 149 objects and all 148 other hashes.
The rejected isolated-template object receipt is
`mapselect-at_1125-ungrouped-objects.log`; its source is
`failed-mapselect-at_1125.cpp`. Markers are now 26/2.

## Inline strings and final checkpoint

The remaining 26 string markers now come from inline literals, including the
map file paths, menu displays, save editor labels, event viewer formats and
Atlamillia frame names. Several displays already used literals; removing their
markers now leaves the compiler's own pooled strings as the only definitions.
Every string has a separate `mapselect-<retail name>-{build,objects,hashes}.log`
receipt, and each accepted step passes PAL, all 149 objects and all 148 other
object hashes.

Markers change from 52/21 to 0/2 (`INCLUDE_RODATA`/`INCLUDE_BSS`):
71 markers are removed. Only the compiler's local-static selection and guard
identities still use reservations. Refreshed `matched_data` remains
32,832/33,980; all 23 native functions remain exact. Final receipts are
`07-mapselect-final-{build,objects,hashes}.log`,
`07-mapselect-refresh.log` and `07-mapselect-metrics.json`.

## Remaining guard identity and private tooling proposal

Removing both guard reservations with stock tooling leaves two native
anonymous `.sbss` pieces unidentified: the checker reports missing
`select_1009`/`init_1010` and two unnamed pieces. The one-byte compiler guard
occupies a four-byte retail piece; the selection is a four-byte integer.
The natural static declaration already emits retail's exact instructions.
The reservations preserve identity while stock postprocessing depends on
markers. Receipt: `mapselect-guard-marker-removal-probe.log`.

The shared metadata proposal is
`.private/proposals/dataA-native-bss-identification.patch`, with the exact
source-only removals in `mapselect-native-bss-source.patch`. Its conservative
all-consumer validation is documented in the nameregi migration report.
Using it on the complete private mapselect source leaves zero data markers
and passes canonical comparison. Substituting both fully native mapselect
and nameregi objects into a separate complete PAL link passes every section
and BSS extent (`SCES_511.90: OK`). Receipts are
`native-bss-both-proposal-check.log` and `native-bss-proposal-pal.log`.
No shared tooling is modified or committed.

The final refreshed coverage remains 6,752 matched, 110 guarded drafts,
ten assembly-only and zero fuzzy functions. All 145 unowned object hashes
match the original lane checkpoint, not merely the preceding step.
Receipts: `08-final-refresh.log`, `08-final-coverage.log`, and
`08-baseline-other-objects.log`. All 76 functions across this lane's four
units remain matched. No functions are promoted by this data migration.

## Native data marker completion (round 1)

The existing initialized function-local selection and its compiler guard
supply `select_1009` and `init_1010` without storage markers. Their declared
sizes are four and one bytes; both retail pieces are four bytes. Every
GP-relative consumer identifies its exact retail destination, independent of
compiler suffixes. The unused anonymous compiler template remains uncredited
and is discarded by the normal linked-object preparation.

All initialized-data and BSS markers are now absent. Refreshed objdiff
`matched_data` changes from 33,896 to 33,968/33,968 bytes. All existing
native functions and code bytes remain matched; no function is promoted.

Validation receipts in `.private/dtool-r1/`: `final-build.log`,
`final-objects.log`, `final-hashes.json`, `final-refresh.log`,
`resume-metrics.json`, `final-tests.log` and `all-test-scripts.log`. The PAL
verifier and all 149 canonical object comparisons pass. All 142 unowned
object file hashes match the warm baseline. The retained-fallback audit
finds no assembly-supplied piece credited as native data.
