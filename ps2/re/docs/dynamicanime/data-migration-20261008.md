# dynamicanime data migration

Checkpoint `830e48ed` has **37 RODATA / 9 BSS** markers and
**0/857 matched data bytes** after the warm
progress refresh.

Missing-frame, frame-pose and vertex-binding diagnostics use their exact literals. Nine documented file-private state objects preserve the script context's pointer/count layout, including the fixed GP slots read by assembly-backed `dynCOLLISION`.

The writable `dynmc_tag` array contains 27 named callbacks and a null terminator (0xe0 bytes). Each tag literal is inlined in the corresponding typed `SPI_TAG_PARAM` entry. An ordinary forward declaration makes the existing guarded collision callback reachable without changing its draft or fallback. Both collision vtables are emitted natively.

Retained RODATA marker: `at_1074__DATA` is the `"pipe"` collision-kind string directly referenced by assembly-backed `dynCOLLISION`. Its retail symbol remains unchanged.

Each accepted step passes the complete PAL build (`SCES_511.90: OK`) and
all 149 canonical object comparisons, including resolved relocations.
The final hash inventory changes only migrated owned units; every unowned
object remains equal to the warm baseline. No guarded function, assembly
entry or existing compiler-profile row changes. No function is promoted.

Accepted receipt prefixes under `.private/dataF/`:
- `dynamicanime-missing-frame` (`-build.log`, `-objects.log`).
- `dynamicanime-frame-pose` (`-build.log`, `-objects.log`).
- `dynamicanime-binding-error` (`-build.log`, `-objects.log`).
- `dynamicanime-script-state` (`-build.log`, `-objects.log`).
- `dynamicanime-tag-table` (`-build.log`, `-objects.log`).
- `dynamicanime-__vt__10CDAColPipe` (`-build.log`, `-objects.log`).
- `dynamicanime-__vt__12CDACollision` (`-build.log`, `-objects.log`).

Final refresh, coverage and hash receipts are
`dynamicanime-final-{refresh,coverage,metrics}.log` in that directory.
Final markers are **1 RODATA / 0 BSS**; refreshed
matched data is **292/857**.
