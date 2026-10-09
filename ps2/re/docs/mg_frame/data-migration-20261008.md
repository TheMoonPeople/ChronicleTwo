# mg_frame data migration

Checkpoint `830e48ed` has **4 RODATA / 5 BSS** markers and
**4/452 matched data bytes** after the warm
progress refresh.

The position, rotation and scale scalar overloads initialize their actual four-float vectors directly, replacing anonymous-data quadword casts. Position retains homogeneous 1; both rotation overloads and scale retain homogeneous zero. The compiler emits all three exact vtables (`mgCFrame`, `mgCFrameBase`, `mgCObject`), so their markers are removed.

Retained BSS markers: `at_1118` and `at_1119`, the two zero-vector templates in `GetDrawRect`. Moving ordinary zero-vector initializers to the existing copy point and removing the copy-only register locals changes 0x3e text bytes, beginning at `GetDrawRect+0x3c`, through register allocation. This experiment is reverted and full validation passes again. The function's existing VU0 assembly and data-copy implementation remain unchanged; no replacement assembly or dummy register locals are introduced.

Each accepted step passes the complete PAL build (`SCES_511.90: OK`) and
all 149 canonical object comparisons, including resolved relocations.
The final hash inventory changes only migrated owned units; every unowned
object remains equal to the warm baseline. No guarded function, assembly
entry or existing compiler-profile row changes. No function is promoted.

Accepted receipt prefixes under `.private/dataF/`:
- `mg_frame-at_307__DATA` (`-build.log`, `-objects.log`).
- `mg_frame-at_324` (`-build.log`, `-objects.log`).
- `mg_frame-at_341` (`-build.log`, `-objects.log`).
- `mg_frame-at_844` (`-build.log`, `-objects.log`).
- `mg_frame-native-vtables` (`-build.log`, `-objects.log`).

Final refresh, coverage and hash receipts are
`mg_frame-final-{refresh,coverage,metrics}.log` in that directory.
Final markers are **0 RODATA / 2 BSS**; refreshed
matched data is **228/452**.
