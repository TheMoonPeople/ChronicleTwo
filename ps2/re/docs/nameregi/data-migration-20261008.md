# Nameregi data migration (2026-10-08)

## Baseline and verification

Lane checkpoint `c9694e24` contains 57 `INCLUDE_RODATA` markers and 18
`INCLUDE_BSS` reservations. Refreshed objdiff reports 36/3,648 matching data
bytes. All 30 functions already match. The warm build prints
`SCES_511.90: OK`; the canonical checker passes all 149 units.

Every accepted step uses the pinned `chronicletwo_dev:sf-63f7a9e` image,
checks the full PAL build and all objects, and compares all 148 other object
hashes against the preceding accepted checkpoint. Private receipts are under
`.private/dataA-r1/`. Objdiff data scores have the preparation limitations
recorded in `../automap/data-migration-20261008.md`; markers and canonical
bytes/relocations establish the actual migration.

## Name entry storage

Nine file-local variables now have documented native definitions:
`NameRegiCode` (`s8`), `NameRegiMenuPtr` (`CNameRegiMenu*`),
`OldReloadTexNumber` (`int`), the five texture pointers, and
`NameRegiTopic` (`char[0x40]`). `Nameregi_Target` retains its public
`NAMEREGI_TARGET_INFO` definition and header declaration.

The one-byte code occupies a four-byte piece, the final texture pointer has
four trailing alignment bytes, and the 0x48-byte target record occupies a
0x50-byte piece. Native definitions use the actual declared extents; existing
postprocessing supplies the verified zero padding. No function changes.

Receipts: `01-nameregi-storage-build.log`,
`01-nameregi-storage-objects.log`, `01-nameregi-storage-hashes.log`.
PAL is OK, all 149 objects pass, and all 148 other objects are unchanged.
Markers: 57 read-only/data markers and eight BSS reservations.

## Character conversion and board tables

`NameStrSelectModeTable` uses the documented font modes for its seven
language rows. `NameRegiSearchKanjiIndexTable` holds 46 native 16-byte
records: 45 code boundaries and an all-zero last row. The loops process
44 readings and use the next row as a code boundary.

`testchar` contains 46 Shift-JIS pairs plus its terminator (93 bytes), and
`txt_table2` contains 58 pairs plus its terminator (117 bytes). Both are
native signed-character strings, indexed as pairs without overextending the
objects. `txt_table` retains its exact 59-byte ASCII string.

The remaining named native tables are `LimmitTable_1360[5]`,
`Convtable2_1382[2][5][8]`, `addTable_1510[5][4]`,
`nameregist_baseboard_upper_table[6][12]`, `colt_1808[2]`,
`table_1819[7][5]`, `tex_commtbl_1822[7][6]`, `gettbl0_2012[12]`,
`NameRegistGyouLimmitTable[5]`, `convTbl_1579[5]`, `convtbl_1792`,
and `get_Htable_1806[4]`. Board points, colours and rectangles retain their
existing documented typed layouts. Notable declaration corrections are the
five rows of `addTable_1510`, five bytes of `convTbl_1579`, and four slice
heights `{100,16,32,0}`; the preceding externs were incorrectly sized.

Each table was built and checked separately. Receipt prefixes are
`02-nameregi-font-mode`, `nameregi-<table name>`, and
`03-nameregi-enum-modes`, each with `-build.log`, `-objects.log` and
`-hashes.log`. Every accepted step passes PAL, all 149 objects and the 148
unchanged-other-object hashes.

## Character grid storage

The native font catalog points directly to inline writable character arrays:
`ALPHA_TABLE1[28]`, `ALPHA_TABLE2[28]`, `STR_NUM_TABLE[14]`,
six `HIRA_TABLE*`/`KATA_TABLE*` arrays containing `" "`,
`KIGOU_TABLE1[1] = ""`, and `KIGOU_TABLE2[2] = " "`.
The older notes' description of the small kana/symbol objects as pointers
is incorrect: their retail bytes are characters, and the catalog relocates to
the arrays themselves. `KIGOU_TABLE_ASCII1[31]`,
`KIGOU_TABLE_ASCII2[128]`, and `ascii_code_table[95]` also have exact native
extents. The second ASCII symbol table begins with one space and zero-fills
its remaining bytes before European initialization.

`NameRegistMax` is a native signed short initialized to ten.
`jis_ptr_table[2]` is the two-null-pointer catalog in PAL.
Receipts use `nameregi-<datum>-{build,objects,hashes}.log` for each separate
step, with the font catalog and its dependent arrays checked together.
Every step passes PAL, all 149 objects and the 148 other object hashes.

## Native compiler-generated data and strings

The native initializers in `NameRegistInit` and `DrawBaseBoard` supply
`at_1153` and `at_1807`. The compiler also supplies the complete 32-byte
`CNameRegiMenu` vtable; its assembly marker is unnecessary.
`AdjustWaku` initializes `{0,36}` locally, and the position, Japanese and
localized navigation, and alternate board tables now have local aggregate
initializers. `KeyStep` uses a plain local `s16[12][2]` array of
confirmation/cancellation events, with no wrapper type or halfword cast.
`DrawMessage` initializes a typed `RGBAQ_TYPE` with four 0x80 channels and
Q bits 0x3F800000, removing its external constant and packed write.
`NameRegiStack` is documented, file-local `mgCMemory` storage.

`Sfida_default_Name` is seven pointers, not four or eight: the Japanese
Shift-JIS default followed by six `"Max"` entries. Its four trailing bytes
are zero piece padding. The table and its two string markers must be removed
together; retaining both strings while supplying native literals emits duplicate
read-only pieces. The successful native table preserves all seven pointers.

Ten function strings are inline: eight resource names in `NameRegistInit`
and `"SIRUS"`/`"Sirus"` in `KeyStep`. All spelling, argument order and
pooling remain unchanged.

Each datum has a separate receipt prefix `nameregi-<retail name>`; the
memory definition uses `nameregi-stack`. Every accepted step passes PAL,
all 149 objects and all 148 other object hashes. The vtable, local aggregates,
GS colour and inline strings leave zero `INCLUDE_RODATA` markers.

## Zero aggregates and remaining BSS identity blocker

`NameRegistInit` initializes its three name pointers with `{NULL,NULL,NULL}`.
Five `KeyStep` message argument pairs initialize `{NULL,NULL}`, and the
33-byte password key initializes `{0}`. These seven initializers preserve
retail's loads and copies while removing every anonymous extern and aggregate
assignment scaffold. Initializations occur at the original copy points.
Their separate receipt prefixes end in `-natural-zero` and all pass PAL,
149 object checks and 148 unchanged other objects.

Eight BSS markers remain: `at_1171__3`, `at_1621__3`, `at_1661__3`,
`at_1684__3`, `at_1686`, `at_1693__2`, `at_1669`, and `at_1755`.
The final one belongs to the existing three-pointer kana table initializer.
They describe the compiler's zero aggregate templates; defining named synthetic
variables for them would misrepresent the source.

Removing the `at_1171__3` marker from its now-natural initializer leaves a
native anonymous 12-byte BSS piece unidentified. The canonical checker reports
`.bss: missing ['at_1171__3'], unexpected [None]`; section ordering then
changes relocation destinations. `name_literal_data` only identifies
initialized `.rodata`, `.sdata`, `.data` and `.ctor` pieces, while
`bind_local_data` can bind these anonymous BSS objects only when their markers
supply retail identity. Thus the marker removal needs a shared metadata/naming
fix; the source initializer itself already matches.

Rejected receipt: `nameregi-zero-removal-probe-objects.log`, with the
failed source retained privately as `failed-at_1171__3.cpp`. The accepted
source retains the eight markers and has no anonymous extern declarations,
replacement assembly, pointer casts for data templates or synthetic globals.

## Final checkpoint

Markers change from 57/18 to 0/8 (`INCLUDE_RODATA`/`INCLUDE_BSS`):
67 markers removed. Refreshed `matched_data` remains 36/3,648 because of
objdiff's data preparation defects. All 30 native functions remain exact.
Final receipts: `04-nameregi-final-{build,objects,hashes}.log`,
`04-nameregi-refresh.log` and `04-nameregi-metrics.json`.
PAL is OK, all 149 objects pass, and every other object hash is unchanged.

## Private native BSS identity proposal

The shared postprocessor change is saved, without changing shared files, as
`.private/proposals/dataA-native-bss-identification.patch`. It identifies a
native LOCAL NOBITS object only when its section kind and exact declared
extent agree with one retail piece, every incoming live relocation belongs
to known code at the same offset and opcode, all relocation destinations
agree, and only one native object claims that destination. HI16/LO16 pairs
and GP-relative addends are validated; unreferenced, ambiguous or conflicting
objects remain unidentified. The pass changes symbol names only: no code,
data, relocation targets, addends or extents. Existing padding then supplies
retail's piece extents.

The private source patch `nameregi-native-bss-source.patch` removes all eight
remaining reservations. With the proposal, the compiler's native objects map
as follows (compiler IDs are for the recorded private source):

| Native identity | Retail identity | Declared bytes |
| --- | --- | ---: |
| `at_435` | `at_1171__3` | 12 |
| `at_861` | `at_1621__3` | 8 |
| `at_902` | `at_1661__3` | 8 |
| `at_910` | `at_1669` | 33 |
| `at_927` | `at_1684__3` | 8 |
| `at_929` | `at_1686` | 8 |
| `at_937` | `at_1693__2` | 8 |
| `at_988` | `at_1755` | 12 |

The two private fully native objects (nameregi and mapselect) pass canonical
comparison, and substituting both into a separate complete PAL link prints
`SCES_511.90: OK` for every section and the final BSS extent. The official
source retains its markers because shared tooling is outside this lane's
ownership. Native source templates themselves already match exactly.

Nine private safety cases validate positive identification and rejection of
held placeholders, wrong types/extents, missing consumers, opcode changes,
disagreeing destinations, already-defined destinations and duplicate claims.
They also assert that bytes, extents, symbol bindings and relocations remain
unchanged. Receipts are `native-bss-proposal-safety.log`,
`native-bss-both-proposal-check.log`, and `native-bss-proposal-pal.log` under
`.private/dataA-r1/`; private source/object/link artifacts remain there.

## Native data marker completion (round 1)

All eight remaining zero-template reservations are supplied by the existing
local pointer arrays and password-key initializer. Their declared object
sizes are 8, 12 and 33 bytes; their larger retail pieces retain canonical
zero tails. The shared BSS matcher validates every code consumer, pairing
HI16/LO16 entries in ELF relocation order, including pairs whose instruction
positions are not monotonic. No native aggregate or game instruction changes.

All initialized-data and BSS markers are now absent. Refreshed objdiff
`matched_data` changes from 3,290 to 3,626/3,626 bytes. All existing
native functions and code bytes remain matched; no function is promoted.

Validation receipts in `.private/dtool-r1/`: `final-build.log`,
`final-objects.log`, `final-hashes.json`, `final-refresh.log`,
`resume-metrics.json`, `final-tests.log` and `all-test-scripts.log`. The PAL
verifier and all 149 canonical object comparisons pass. All 142 unowned
object file hashes match the warm baseline. The retained-fallback audit
finds no assembly-supplied piece credited as native data.
