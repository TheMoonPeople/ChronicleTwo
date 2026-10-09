# sceneload data migration

Checkpoint `830e48ed` has **11 RODATA / 0 BSS** markers and
**32/128 matched data bytes** after the warm
progress refresh.

Map loading inlines the six pack/file suffixes, including both uses of the sky suffix. Memory-map loading inlines the texture suffix and two exact timer/memory diagnostic formats.

Retained RODATA markers: `at_958__2__DATA` is the character-assignment string used by both guarded character-load/copy paths; `at_959__2__DATA` is the pack extension directly used by the guarded loader. Their retail symbols remain reachable, and the guarded source drafts are unchanged.

Each accepted step passes the complete PAL build (`SCES_511.90: OK`) and
all 149 canonical object comparisons, including resolved relocations.
The final hash inventory changes only migrated owned units; every unowned
object remains equal to the warm baseline. No guarded function, assembly
entry or existing compiler-profile row changes. No function is promoted.

Accepted receipt prefixes under `.private/dataF/`:
- `sceneload-map-suffixes` (`-build.log`, `-objects.log`).
- `sceneload-memory-diagnostics` (`-build.log`, `-objects.log`).

Final refresh, coverage and hash receipts are
`sceneload-final-{refresh,coverage,metrics}.log` in that directory.
Final markers are **2 RODATA / 0 BSS**; refreshed
matched data is **32/128**.
