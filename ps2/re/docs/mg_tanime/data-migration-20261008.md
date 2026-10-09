# Texture-animation data migration, October 8 night, round 4

Baseline: `9eb8f660`, pinned SF image and unchanged flags/profile.
Existing record, script and list layouts are documented in notes.md.

`tex_tag` is now a static SPI_TAG_PARAM[14] table containing thirteen
retail tag names/handlers and its null terminator. The tag names are inline
literals. File-local handler declarations give the table natural typed
function pointers and retain the handler bodies and retail symbol identities.
The table and thirteen name markers are removed together after the complete
object passes. Both texture-block mismatch diagnostics inline the shared
`"%s block is not match!!!\n"` literal; the duplicate marker and extern go.

The ten loader-state globals and mgCTextureAnime::stop_anime now have
purpose-documented native definitions. File-local data has static linkage;
the class static keeps its existing header declaration. The implementation
uses its own definitions instead of including the legacy C ABI declaration
header. That header and mg_tanime.hpp remain unchanged for other consumers.

## Retained marker

`__vt__24CList_15mgCTexAnimeData_` is referenced by the assembly-backed
NewTexAnimeData. The source-only object emits the list Initialize method,
but no native list vtable: its actual construction remains in the guarded
caller. The retail-named marker preserves the assembly reference. No manual
vtable or artificial construction site is introduced. At this data-migration
checkpoint both drafts were unchanged; the later TexAnime promotion is
recorded in [nmmisc-20261008.md](nmmisc-20261008.md). Only NewTexAnimeData
now remains guarded.

## Measurement and validation

Markers (RODATA / BSS): **16 / 11 → 1 / 0**.
Fresh objdiff `matched_data / total_data`: **56 / 450 → 438 / 450**.

`mg_tanime-final-build.log` prints `SCES_511.90: OK`; `mg_tanime-final-objects.log`
passes 149/149 objects. These receipts, the incremental checks, baseline
measurements and object-hash audit are under `.private/dataB-r4/`.
All objects outside the seven owned units retain their baseline file hashes.
No function is promoted and no assembly fallback or guarded function body changes.
