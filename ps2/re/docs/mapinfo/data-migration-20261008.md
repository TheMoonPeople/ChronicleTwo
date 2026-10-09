# Map configuration data migration (2026-10-08)

The native `SPI_TAG_PARAM[24]` and `SPI_TAG_PARAM[3]` tables retain their
retail order, null terminators, handlers and file-local linkage. Their tag
names now use inline C++ strings: `IMG`, `PCP`, and the remaining 21 names
listed in `notes.md`. The additional table reuses `IMG` and `PCP`.

`CMapInfo::OutputLightData` uses its ten format strings directly. The
formats retain all spaces, semicolons and newlines, including the fixed
`MPL_FOV 52` line and the terminal `MPL_LIGHT_SET_END` line. No data externs
or assembly data markers remain in the unit.

The compiler generates the literal objects; the existing postprocessor
assigns their retail pieces and zero alignment padding. Both migration
steps pass the whole PAL verifier and all 149 object comparisons. Marker
counts decrease from 33 `INCLUDE_RODATA` and 0 `INCLUDE_BSS` to 0 and 0.
Validation receipts are `.private/dataB-r1/mapinfo-tags-{build,objects}.log`
and `.private/dataB-r1/mapinfo-formats-{build,objects}.log`.
