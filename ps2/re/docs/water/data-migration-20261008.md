# water data migration

Checkpoint `830e48ed` has **4 RODATA / 1 BSS** markers and
**0/200 matched data bytes** after the warm
progress refresh.

The compiler already emits the 0x38-byte `CWater` vtable, 0x54-byte `CWaterFrame` vtable and 16-byte zero-vector initializer used by `CreateRenderInfoPacket`. Their three markers are removed without changing those functions.

The retained RODATA markers are `prog_vif_351__DATA` and `progf_vif_352__DATA`, the aligned four-word VIF templates for `MSCAL(2)` and `MSCNT`. Removing both preserves the complete PAL image, but canonical comparison cannot identify the initialized local objects `prog_vif_326` and `progf_vif_327`. Their bytes, extents and complete consumers uniquely identify the retail addresses 0x3392C0 and 0x3392D0. The current initialized-local naming pass only considers pointer tables with internal relocations; neither command template contains a pointer. Individual removals also fail canonical naming or change layout. Native 128-bit shift initializers are rejected by MWCC with `illegal data size`. The existing local word arrays remain unchanged, rather than replacing their quadword loads with additional casts or unions.

A tooling proposal records consumer-based naming for non-pointer initialized local objects. No tooling change is included in this commit.

Each accepted step passes the complete PAL build (`SCES_511.90: OK`) and
all 149 canonical object comparisons, including resolved relocations.
The final hash inventory changes only migrated owned units; every unowned
object remains equal to the warm baseline. No guarded function, assembly
entry or existing compiler-profile row changes. No function is promoted.

Accepted receipt prefixes under `.private/dataF/`:
- `water-__vt__11CWaterFrame` (`-build.log`, `-objects.log`).
- `water-__vt__6CWater` (`-build.log`, `-objects.log`).
- `water-clear-template` (`-build.log`, `-objects.log`).

Final refresh, coverage and hash receipts are
`water-final-{refresh,coverage,metrics}.log` in that directory.
Final markers are **2 RODATA / 0 BSS**; refreshed
matched data is **168/200**.


## Round-5 initialized-local identities

The existing aligned `prog_vif` and `progf_vif` arrays now supply both VIF
command templates without markers. The shared initialized-local mapper uses
the source base names, exact declared extents and bytes, and complete retail
consumers; compiler-generated numeric suffixes do not establish identity.
No function body, guarded draft, type, or compiler profile changes.

Markers: RODATA **2 → 0**, BSS **0 → 0**. Refreshed native data credit:
**168 → 200 / 200**. Full PAL verification is `SCES_511.90: OK`, and
all **149/149** canonical objects pass. Other game objects retain their warm
baseline hashes, and code metrics remain **6,780 functions / 1,854,796 bytes**.
Receipts: `.private/dtool-r5/vif-{build,objects,tests,metrics}.log`.
