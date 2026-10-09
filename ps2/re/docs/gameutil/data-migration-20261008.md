# gameutil data migration

Checkpoint `830e48ed` has **2 RODATA / 14 BSS** markers and
**0/13596 matched data bytes** after the warm
progress refresh.

The two skinning-overflow diagnostics use their complete exact formats directly. The six scratch objects consumed by assembly-backed `MotionProc2` have documented native definitions under their exact retail symbols. External linkage preserves storage with no active C++ consumer; the guarded draft is unchanged. Vertex buffers are four-byte pointers, not artificially enlarged arrays; the existing extent pass preserves their piece padding.

Seven scratch pointers/matrices consumed by native `MotionProc3` use documented file-private definitions. Its per-key weight vector initializes four real floats directly, removing the aggregate-copy wrapper. Existing `def_vrtx[800][4]` and `def_nml[1][4]` extents remain unchanged. No markers remain.

Each accepted step passes the complete PAL build (`SCES_511.90: OK`) and
all 149 canonical object comparisons, including resolved relocations.
The final hash inventory changes only migrated owned units; every unowned
object remains equal to the warm baseline. No guarded function, assembly
entry or existing compiler-profile row changes. No function is promoted.

Accepted receipt prefixes under `.private/dataF/`:
- `gameutil-overflow-diagnostics` (`-build.log`, `-objects.log`).
- `gameutil-assembly-skinning-storage` (`-build.log`, `-objects.log`).
- `gameutil-native-skinning-storage` (`-build.log`, `-objects.log`).
- `gameutil-weight-vector` (`-build.log`, `-objects.log`).

Final refresh, coverage and hash receipts are
`gameutil-final-{refresh,coverage,metrics}.log` in that directory.
Final markers are **0 RODATA / 0 BSS**; refreshed
matched data is **13596/13596**.
