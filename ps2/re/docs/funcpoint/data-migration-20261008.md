# funcpoint data migration

Checkpoint `830e48ed` has **4 RODATA / 7 BSS** markers and
**0/793 matched data bytes** after the warm
progress refresh.

Both switch tables (`at_475__2`, `at_1118__3`) and both vtables (`CFuncPointMngr`, `CList<CFuncPoint>`) are already emitted by the matched source. Removing their markers preserves their exact extents, padding and relocations, including the list-vtable reference from `Add`'s assembly fallback.

The seven BSS pieces are the existing `DrawFireEffect` statics and guards: `sp_3d_1174`, `init_1175`, `frame_1203`, `init_1204`, `Bound_1206`, `attr_1207`, and `init_1208`. The native symbols map through the current local-data naming pass with exact sizes. The function is unchanged. No markers remain.

Each accepted step passes the complete PAL build (`SCES_511.90: OK`) and
all 149 canonical object comparisons, including resolved relocations.
The final hash inventory changes only migrated owned units; every unowned
object remains equal to the warm baseline. No guarded function, assembly
entry or existing compiler-profile row changes. No function is promoted.

Accepted receipt prefixes under `.private/dataF/`:
- `funcpoint-switch-tables` (`-build.log`, `-objects.log`).
- `funcpoint-vtables` (`-build.log`, `-objects.log`).
- `funcpoint-local-storage` (`-build.log`, `-objects.log`).

Final refresh, coverage and hash receipts are
`funcpoint-final-{refresh,coverage,metrics}.log` in that directory.
Final markers are **0 RODATA / 0 BSS**; refreshed
matched data is **793/793**.
