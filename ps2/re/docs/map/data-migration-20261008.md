# map data migration

Checkpoint `830e48ed` has **11 RODATA / 4 BSS** markers and
**0/4044 matched data bytes** after the warm
progress refresh.

Map/effect/object names and diagnostic formats are inlined. `CMapName` is a documented native pointer to `"CMap"`, preserving the existing header declaration and `Iam` pointer load. Although the retail object binds locally, public source linkage avoids changing that established interface.

Existing `SetFuncPLight` statics (`CFuncPoint points[8]` and its one-byte guard) and `DrawEffect`'s `mgCFrameAttr`/guard supply all four BSS pieces. Both functions are unchanged. The compiler emits the exact `CMap` and `CMapWater` vtables.

Retained RODATA markers: `__vt__23CList_14PartsGroupData___DATA` is directly referenced by assembly-backed `AddPartsGroup`; `__vt__18CList_P9CMapParts___DATA` is directly referenced by assembly-backed `CreateDrawRect`. Native source emits neither table because their construction paths remain guarded.

Each accepted step passes the complete PAL build (`SCES_511.90: OK`) and
all 149 canonical object comparisons, including resolved relocations.
The final hash inventory changes only migrated owned units; every unowned
object remains equal to the warm baseline. No guarded function, assembly
entry or existing compiler-profile row changes. No function is promoted.

Accepted receipt prefixes under `.private/dataF/`:
- `map-test-name` (`-build.log`, `-objects.log`).
- `map-effect-names` (`-build.log`, `-objects.log`).
- `map-object-names` (`-build.log`, `-objects.log`).
- `map-class-name` (`-build.log`, `-objects.log`).
- `map-point-light-storage` (`-build.log`, `-objects.log`).
- `map-effect-attribute-storage` (`-build.log`, `-objects.log`).
- `map-native-vtables` (`-build.log`, `-objects.log`).

Final refresh, coverage and hash receipts are
`map-final-{refresh,coverage,metrics}.log` in that directory.
Final markers are **2 RODATA / 0 BSS**; refreshed
matched data is **3800/4044**.
