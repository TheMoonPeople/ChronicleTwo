# Native dungeon floor data

The established unit notes describe the grid, room option flags, script tags,
challenge tables, search directions and special forest title. All functions
already match at checkpoint `96cbdc31`; no functions are promoted here.

The six script-state slots are typed, documented file-static definitions.
`tree_map_tag` holds its eleven callbacks and terminator; callbacks have their
retail local linkage. Room options use a local aggregate of the established
`MENU_SPI_ANALYZE_STRUCT1` records and `DNGMAP_ROOM_FLAG` values.

`_ROOM_TITLE` initializes its four-byte fallback as `char empty[4] = "err"`,
removing the inherited float copy/type-pun. m2c evidence is saved in
`.private/dataB-r3/dngfloor-room-title-m2c.log`; the initializer preserves
retail's float load/store lowering and all object bytes. The three script paths
are literals at use.

The three practice-condition tables retain their signed-byte/unsigned-halfword
layouts. Search tables use `GLID_DIR` values. `GetNextRoom` initializes a
four-by-three integer array directly, removing the unused quadword union and
anonymous external template. The floor-count initializer and practice switch
emit their data naturally. The special forest titles preserve the Japanese
Shift-JIS bytes through hexadecimal escapes.

## Retained boundary markers

Seven `INCLUDE_RODATA` markers remain; BSS has none:

- `at_886__4` and its four keyword pieces: the natural 40-byte room option
  aggregate emits a 48-byte compiler template. Retail's piece ends at 44 bytes,
  followed by the separately referenced `D_0036178C` boundary. Removing the
  marker fails with native extent `0x30`, retail `0x2C`, and overlapping pieces.
  Removing only keyword markers then fails their retained-table relocations.
  Natural aggregate source is present; no external template declaration remains.
- `offsetTable_911` and `D_0036178C`: native source defines the five integer
  texture bases `{0, 4, 8, 12, 16}` and indexes `[texture_group - 1]`. This keeps
  retail's instruction lowering. Removing the table marker loses the table
  because the current identity preparation binds the negative-addend reference
  to the preceding `D_0036178C` marker. It needs an addend-aware native identity
  for the actual table. The preceding word is alignment padding, so it is not
  replaced with an invented source variable.

Failures are recorded in `dngfloor-options-failure-check.log` and
`dngfloor-texture-offsets-failure-check.log` under `.private/dataB-r3/`.
No build scripts are changed. The source retains natural initializers and only
these required boundary markers. No zero-valued filler fields or fake objects
are introduced.

Markers: ROData **35 → 7**, BSS **6 → 0**.
Objdiff after refresh: matched_data **0 → 38** / total_data **836 → 836**.

Every accepted incremental step passes `SCES_511.90: OK` and 149/149 full object
checks including resolved relocations. Receipts are
`.private/dataB-r3/dngfloor-*-build.log` and `dngfloor-*-objects.log`;
`dngfloor-progress.log` records the required source-only refresh.

## Round-4 retained-marker checks

Literal padding now stops at canonical reference boundaries, so the native
40-byte room-option initializer owns a 44-byte piece instead of overlapping
`D_0036178C`. Its four keyword markers and initializer marker are removed.
The negative-addend texture-table access preserves its native table identity
and original -4 addend instead of binding the table to the preceding word;
its marker is also removed.

`D_0036178C` remains a separate four-byte padding marker. The compiler emits
no object for that independently referenced boundary, and naming or padding
the neighboring objects does not supply its own section. No source padding
variable or relaxed object check is introduced.

Markers: rodata 7 → 1, BSS 0 → 0.
Native data credit: 38 → 324 / 836.

Validation: `.private/dtool-r4/dngfloor-{build,objects,tests}.log`.
PAL is byte-identical and all 149 complete objects pass. Other game objects
retain their baseline hashes, and the code metric is unchanged.

## Round-5 native alignment boundary

The native room-option template has a 40-byte declared extent at
`0x00361760`. MWCC aligns the next native five-int `offsetTable_911` to
16 bytes at `0x00361790`, requiring eight zero bytes after the template.
The canonical reference cut at `0x0036178C` divides that alignment tail
into two four-byte pieces. The verified native alignment path now supplies
the latter piece under its original address label, so its marker is removed.
Neither object changes type, initializer, size, or consumer code.

The tooling retains original compiler extents before literal padding,
requires both exact neighboring native objects and the complete zero tail,
and rejects declared, relocated, aliased or marker-held gap contents. The
padding label is not a source variable. All code relocation fields remain
unchanged, including the negative-addend table access.

Markers: RODATA **1 → 0**, BSS **0 → 0**. Refreshed matched data:
**324 → 836 / 836**. PAL is `SCES_511.90: OK` and all **149/149** objects
pass; only `dngfloor` and the simultaneously migrated `gyorace` object
change hashes. Code metrics remain **6,780 functions / 1,854,796 bytes**.
Receipts: `.private/dtool-r5/alignment-data-{build,objects,tests,metrics}.log`.
The missing-fragment regression before the tool fix is
`.private/dtool-r5/alignment-tests-before.log`.
