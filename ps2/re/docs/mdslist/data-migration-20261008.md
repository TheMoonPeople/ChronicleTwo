# mdslist data migration

Checkpoint `830e48ed` has **12 RODATA / 8 BSS** markers and
**0/321 matched data bytes** after the warm
progress refresh.

Model-pack diagnostics, suffixes and both `"info.cfg"` uses are inlined at their consumers. The five-entry writable `SPI_TAG_PARAM pcp_tag` table contains the four retail callbacks (`MDS`, `TYPE`, `FAR_CLIP`, `MDS_END`) and a null terminator; its declared size is 40 bytes with eight retail alignment bytes supplied by the existing extent pass.

Eight documented file-private four-byte parser-state objects replace their reservations in retail order. Both `CMdsInfo` and `CMapPiece` vtables already exist natively, with exact slots and extents. The guarded character construction and map-piece copy paths reference foreign vtables and require no owned data markers. No markers remain.

Each accepted step passes the complete PAL build (`SCES_511.90: OK`) and
all 149 canonical object comparisons, including resolved relocations.
The final hash inventory changes only migrated owned units; every unowned
object remains equal to the warm baseline. No guarded function, assembly
entry or existing compiler-profile row changes. No function is promoted.

Accepted receipt prefixes under `.private/dataF/`:
- `mdslist-duplicate-name` (`-build.log`, `-objects.log`).
- `mdslist-config-name` (`-build.log`, `-objects.log`).
- `mdslist-pack-names` (`-build.log`, `-objects.log`).
- `mdslist-parser-state` (`-build.log`, `-objects.log`).
- `mdslist-tag-table` (`-build.log`, `-objects.log`).
- `mdslist-__vt__8CMdsInfo` (`-build.log`, `-objects.log`).
- `mdslist-__vt__9CMapPiece` (`-build.log`, `-objects.log`).

Final refresh, coverage and hash receipts are
`mdslist-final-{refresh,coverage,metrics}.log` in that directory.
Final markers are **0 RODATA / 0 BSS**; refreshed
matched data is **321/321**.
