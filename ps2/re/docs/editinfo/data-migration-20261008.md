# Edit information data migration (2026-10-08)

All eleven script-state objects are typed file-local definitions. Their
pointer and integer types follow the accesses documented in `notes.md`;
each retail object occupies four bytes. `EditMapRect` remains the documented
0x30-byte record with a type and two four-component endpoints.

The command table is a native `SPI_TAG_PARAM[30]`, containing the 29 commands
in retail order and a null terminator. Tag names are inline string literals.
Handlers have file-local linkage as in retail. The four part attribute masks
use the existing `EditPartsAtr` enumerators rather than duplicate constants.

Three small steps (state, table/strings, attribute enums) pass the PAL
verifier and all 149 object checks. Marker counts decrease from 30
`INCLUDE_RODATA` and 11 `INCLUDE_BSS` to 0 and 0. No anonymous-data externs
remain. Receipts are `.private/dataB-r1/editinfo-{state,tags,enums}-{build,objects}.log`.
