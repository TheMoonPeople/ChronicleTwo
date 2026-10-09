# World map and Spheda data migration (2026-10-08)

The world map command table is a native `SPI_TAG_PARAM[5]` with four commands
and a null terminator. Resource names and drawing/debug strings are inline
literals. Six numerical aggregate templates and the native world-map menu
vtable replace their old initialized-data markers. All 34 named BSS state
objects are now typed file-local definitions, including the texture table.
The existing two memory managers retain their constructor order. Header
layouts and declarations remain source-compatible.

## Texture table extent and initialization overflow

The retail `SphidaMenuTexbk` symbol is 0x20 bytes, so its definition is
`static int SphidaMenuTexbk[8]`. `SphidaMenuInit` nevertheless copies sixteen
integers and then stores -1 at table index 15. The old `D_01F3C7FC[0]` is
exactly this final address: table base + 0x3C. It lies in adjacent menuchr
storage, after `MenuCharaBuild2`, not in another menumap-owned object.
Typed indexing preserves the demonstrated retail overflow without enlarging
the table or claiming another unit's storage. The whole unit remains exact:
0x49AC allocated bytes and 1,190 resolved relocations.

## Retained Georama and zero-initializer pieces

`KeyStep` has the natural function-local `char *geo_table[11]` containing
`{"", "", "g01", "g02", "g03", "g04", "", "g05", "", "", ""}`.
Its seven markers (table plus six distinct strings) remain. A direct
removal probe fails because the current postprocessor cannot name the
initialized local-static table or disambiguate the empty literal from other
zero-leading data. The named-table relocation context can support a future
generic naming rule; no synthetic source object is used.

Three anonymous BSS templates also retain markers. Their natural locals
already exist in the source:

- `at_1218__2`, size 4: `KeyStep`'s one-pointer `names` initializer.
- `at_1393__2`, size 8: `Draw`'s two-integer `put_pos` initializer.
- `at_1764__3`, size 8: `SphidaMenuKey`'s two-pointer `clear_names` initializer.

The current initialized-literal naming pass excludes NOBITS sections. These
need shared-tool support rather than named zero templates in C++.

Counts decrease from 41 `INCLUDE_RODATA` and 37 `INCLUDE_BSS` to 7 and 3.
The final state passes the PAL verifier and all 149 object checks. Accepted
step receipts are `.private/dataB-r1/menumap-{native-aggregates,script-tags,world-strings,sphida-strings,state,texture-table,geo-table,final}-{build,objects}.log`.
The unsuccessful marker-removal probe and detailed checker output are
`.private/dataB-r1/menumap-geo-without-markers-{build,objects}.log`.

## Native data marker completion (round 1)

The existing eleven-pointer `geo_table` supplies its 44-byte retail object
and four-byte piece tail. Every code consumer establishes the table address;
its nonpointer bytes, real R_MIPS_32 fields and pointed-to native literal bytes
validate the identity. This table then anchors the one-byte empty literal;
`g01` through `g05` retain their inline literal definitions. All seven held
initialized pieces are native, with no synthetic source table or string.

The three remaining BSS templates are the existing `names`, `put_pos` and
`clear_names` aggregates, with declared sizes four, eight and eight bytes.
Their consumers establish identity through the shared all-consumer matcher.
The previously documented texture-table overflow and game function bodies
are unchanged.

All initialized-data and BSS markers are now absent. Refreshed objdiff
`matched_data` changes from 172 to 898/898 bytes. All existing
native functions and code bytes remain matched; no function is promoted.

Validation receipts in `.private/dtool-r1/`: `final-build.log`,
`final-objects.log`, `final-hashes.json`, `final-refresh.log`,
`resume-metrics.json`, `final-tests.log` and `all-test-scripts.log`. The PAL
verifier and all 149 canonical object comparisons pass. All 142 unowned
object file hashes match the warm baseline. The retained-fallback audit
finds no assembly-supplied piece credited as native data.
