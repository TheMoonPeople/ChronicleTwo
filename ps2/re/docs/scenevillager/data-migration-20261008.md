# scenevillager data migration

Checkpoint `830e48ed` has **31 RODATA / 1 BSS** markers and
**0/3456 matched data bytes** after the warm
progress refresh.

Pack/configuration/effect paths, diagnostics and hand-frame names are inlined at native consumers. Three existing aggregate initializer pieces and the motion switch table are emitted natively. Character-lighting limits initialize an actual `sceVu0FVECTOR` at the original execution point, removing the float/quadword union.

The writable ten-pointer motion-name table contains the nine exact Shift-JIS names, spelled with hex escapes, and a null terminator. It is 40 declared bytes with eight alignment bytes; no fictitious entries are added.

`GameObjInfo` is a documented writable 36-element `GAMEOBJ_INFO` table, each 0x50 bytes. Entries use the existing goal-marker/save-point enum and typed `GAMEOBJ_PLACE` aggregates. The terminal record is `{-1, GAMEOBJ_TYPE_NONE, 0, 0}`. Unused placements are verified zero and omitted from initializers; all four negative-zero Y components are preserved. The guarded character visibility function and the existing `GetNowVillagerTime` compiler-profile row remain unchanged. No markers remain.

Each accepted step passes the complete PAL build (`SCES_511.90: OK`) and
all 149 canonical object comparisons, including resolved relocations.
The final hash inventory changes only migrated owned units; every unowned
object remains equal to the warm baseline. No guarded function, assembly
entry or existing compiler-profile row changes. No function is promoted.

Accepted receipt prefixes under `.private/dataF/`:
- `scenevillager-pack-extension` (`-build.log`, `-objects.log`).
- `scenevillager-villager-load-diagnostics` (`-build.log`, `-objects.log`).
- `scenevillager-hand-frame-names` (`-build.log`, `-objects.log`).
- `scenevillager-game-object-paths` (`-build.log`, `-objects.log`).
- `scenevillager-existing-initializers-switch` (`-build.log`, `-objects.log`).
- `scenevillager-lighting-limit` (`-build.log`, `-objects.log`).
- `scenevillager-motion-name-table` (`-build.log`, `-objects.log`).
- `scenevillager-map-object-placements` (`-build.log`, `-objects.log`).

Final refresh, coverage and hash receipts are
`scenevillager-final-{refresh,coverage,metrics}.log` in that directory.
Final markers are **0 RODATA / 0 BSS**; refreshed
matched data is **3456/3456**.
