# Charasetup data migration (2026-10-08)

## Baseline and verification

Checkpoint `c9694e24` has 65 `INCLUDE_RODATA` markers and three
`INCLUDE_BSS` reservations. All ten functions already match; refreshed
objdiff attributes 0/1,824 data bytes to matching source.

Every accepted step uses the pinned image, a full PAL build and the canonical
149-object checker. All 148 other object hashes must match the preceding
accepted checkpoint. Receipts are in `.private/dataA-r1/`.

## Native storage and named tables

The three BSS objects are native typed definitions: `ROBO_INFO_DATA robo_dat`,
`char r_robo_pname_1282[4][16]`, and `char fname_1290[64]`. The two character
buffers have file-local linkage. `robo_dat` retains its existing public header
declaration for source compatibility, although retail binds its symbol LOCAL.
Its declared size is 0x24; the next object's 16-byte alignment adds 12 piece
bytes. The header's former `@size 0x30` described that padded piece and is
corrected to the actual object size.

`mem_table[4][7]` contains the exact four rows of memory stack capacities.
`robo_info_body[11]` has the documented 37-byte row type and exact 0x197-byte
extent. Retail's first row is `{"body01.chr","arm1"}`; all ten remaining
rows are `{"body02.chr","arm2"}`. The zero tail of the 0x1A0-byte piece is
alignment padding, not another row.

Receipts: `charasetup-storage`, `charasetup-mem_table`, and
`charasetup-robo_info_body`, each with `-{build,objects,hashes}.log`.
All pass PAL, all 149 objects and 148 unchanged other objects.

## Setup stack and filename data

`SetupMainUnit` initializes its ridepod stack slots as `{0,1,2,2,3}`.
`GetRoboPartsInfo` initializes its equipment traversal order as `{3,0,1,2}`.
Both use their existing documented typed local aggregates, eliminating the
anonymous external templates.

The two costume filename catalogs are native file-local arrays of six
pointers each, with patterns `mints0%da.chr` through `mints0%df.chr`
and `mints%da.chr` through `mints%df.chr`. Each catalog's two following
zero words belong to alignment padding. The six string markers are removed
with each catalog, so the compiler emits its dependent literals directly.

Receipts: `charasetup-at_919__3`, `charasetup-at_1281__2`,
`charasetup-fname_tbl_1291`, and `charasetup-fname_tbl2_1298`, all with
`-{build,objects,hashes}.log`. Every step passes PAL, all 149 objects and
148 unchanged other objects.

## Character loading strings

The five sound-bank format strings in `GetCharacterSnd` and all 19 model,
texture, joint, action-script and diagnostic strings in `SetupMainUnit` are
inline at their uses. Shared names, including `hat` and the empty skin name,
remain pooled by MWCC. The empty literal has direct code consumers, so its
identity does not need the data-only relocation proposal parked by automap.

Each string was separately built and checked with a receipt prefix
`charasetup-<retail literal name>`, from `at_868__3` through `at_1018__4`.
Every step passes PAL, all 149 objects and the 148 other object hashes.

## Attachment tables and remaining strings

`SetupMints` initializes its four attachment names and three part names as
native pointer aggregates. `SetupMonica` does the same for its two three-name
aggregates. The repeated `{"sword","shot","hat"}` catalogs retain their
separate local templates and shared literal storage. `SetupRobo` initializes
`{"body%d","spine","joint2","joint1","hat",NULL}` naturally.
The sword/shot strings and four ridepod joint-name strings have data-only
consumers and are removed with their owning aggregate templates.

The remaining character-name, attachment diagnostic, ridepod body/arm and
monster file/name literals are inline, one separately checked step per string.
Receipt prefixes are `charasetup-at_1110`, `charasetup-at_1113`,
`charasetup-at_1161`, `charasetup-at_1162`, `charasetup-at_1216__4`,
and the twelve remaining literal names (`at_1149`, `at_1150`, `at_1268`
through `at_1277`), all with `-{build,objects,hashes}.log`.
Every step passes PAL, all 149 objects and 148 unchanged other objects.

## Final checkpoint

Markers change from 65/3 to 0/0 (`INCLUDE_RODATA`/`INCLUDE_BSS`):
all 68 markers removed. All ten functions remain native and exact.
Refreshed `matched_data` remains 0/1,824; source-only data extents and
anonymous symbol identity have the objdiff limitations recorded for automap.
No data markers or anonymous extern scaffolds remain in this unit.

Final receipts: `05-charasetup-final-{build,objects,hashes}.log`,
`05-charasetup-refresh.log`, and `05-charasetup-metrics.json`.
PAL is OK, all 149 objects pass, and every other object is unchanged.
