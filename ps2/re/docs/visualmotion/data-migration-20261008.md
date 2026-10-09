# visualmotion data migration

Checkpoint `830e48ed` has **7 RODATA / 0 BSS** markers and
**0/223 matched data bytes** after the warm
progress refresh.

Vertex-weight diagnostics use their exact literals directly. The source already emits the eight-callback `set_data_func` table, the aligned `MG_VIF_FLUSHA` finish template and the 80-byte `mgCVisualMotionMDT` vtable. Their markers are removed; the native vtable retains the retail symbol referenced by assembly-backed `Copy`.

Retained RODATA markers: `prog_vif_532__DATA` and `progf_vif_533__DATA`, the existing aligned four-word `MSCAL(2)` and `MSCNT` local statics. Their paired removal is tested and restored if canonical naming cannot resolve the compiler-local identities. The current naming pass excludes numeric initialized locals without pointer relocations; the same consumer-based identity proposal as `water` applies. No new casts, type-puns or unsupported 128-bit arithmetic initializers are introduced.

Each accepted step passes the complete PAL build (`SCES_511.90: OK`) and
all 149 canonical object comparisons, including resolved relocations.
The final hash inventory changes only migrated owned units; every unowned
object remains equal to the warm baseline. No guarded function, assembly
entry or existing compiler-profile row changes. No function is promoted.

Accepted receipt prefixes under `.private/dataF/`:
- `visualmotion-weight-diagnostics` (`-build.log`, `-objects.log`).
- `visualmotion-callback-table` (`-build.log`, `-objects.log`).
- `visualmotion-finish-template` (`-build.log`, `-objects.log`).
- `visualmotion-native-vtable` (`-build.log`, `-objects.log`).

Final refresh, coverage and hash receipts are
`visualmotion-final-{refresh,coverage,metrics}.log` in that directory.
Final markers are **2 RODATA / 0 BSS**; refreshed
matched data is **143/223**.


## Round-5 initialized-local identities

The existing aligned `prog_vif` and `progf_vif` arrays now supply both VIF
command templates without markers. The shared initialized-local mapper uses
the source base names, exact declared extents and bytes, and complete retail
consumers; compiler-generated numeric suffixes do not establish identity.
No function body, guarded draft, type, or compiler profile changes.

Markers: RODATA **2 → 0**, BSS **0 → 0**. Refreshed native data credit:
**143 → 223 / 223**. Full PAL verification is `SCES_511.90: OK`, and
all **149/149** canonical objects pass. Other game objects retain their warm
baseline hashes, and code metrics remain **6,780 functions / 1,854,796 bytes**.
Receipts: `.private/dtool-r5/vif-{build,objects,tests,metrics}.log`.
