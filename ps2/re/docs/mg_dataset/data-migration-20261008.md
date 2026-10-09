# mg_dataset data migration

Checkpoint `830e48ed` has **6 RODATA / 6 BSS** markers and
**0/237 matched data bytes** after the warm
progress refresh.

`mgSetFrameAttr` uses an ordinary initialized local static `char *name_def = ""`; `mgLoadMDSFile` uses `static int flag = 0`. Each emits its retail storage and one-byte initialization guard. The empty string is also inlined at `SearchVisualType`, and the address diagnostic retains its space before the newline.

The sphere-center and scalar `SetData` overload now initialize real four-float vectors directly. Normal data writes zero to the homogeneous component using `MG_MDT_DATA_NORMAL`; the former float/word union and quadword-copy scaffolding are removed. The already-native `"MDT"` literal and `mgCVisual` vtable no longer need markers.

Retained RODATA markers: `at_550__DATA` is the `"mgLoadMDSFile"` diagnostic directly referenced by assembly-backed `CreateFrameVisual`; `__vt__15mgCShadowFixMDT__DATA` supplies its shadow-visual vtable because active native source does not emit that table. Every guarded draft remains unchanged.

Each accepted step passes the complete PAL build (`SCES_511.90: OK`) and
all 149 canonical object comparisons, including resolved relocations.
The final hash inventory changes only migrated owned units; every unowned
object remains equal to the warm baseline. No guarded function, assembly
entry or existing compiler-profile row changes. No function is promoted.

Accepted receipt prefixes under `.private/dataF/`:
- `mg_dataset-default-name` (`-build.log`, `-objects.log`).
- `mg_dataset-file-flag` (`-build.log`, `-objects.log`).
- `mg_dataset-center` (`-build.log`, `-objects.log`).
- `mg_dataset-vector` (`-build.log`, `-objects.log`).
- `mg_dataset-address-diagnostic` (`-build.log`, `-objects.log`).
- `mg_dataset-native-literal-vtable` (`-build.log`, `-objects.log`).

Final refresh, coverage and hash receipts are
`mg_dataset-final-{refresh,coverage,metrics}.log` in that directory.
Final markers are **2 RODATA / 0 BSS**; refreshed
matched data is **45/237**.
