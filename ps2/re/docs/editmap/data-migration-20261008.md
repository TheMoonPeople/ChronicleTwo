# editmap data migration

Checkpoint `830e48ed` has **26 RODATA / 15 BSS** markers and
**0/744 matched data bytes** after the warm
progress refresh.

Part identifiers and the placement diagnostic are inlined; `CEditMapName` is a native file-private pointer to `"CEditMap"`. The river-position and part-bound margin vectors use natural float aggregates.

Fourteen documented file-private parser-state words/pointers preserve the retail order and fixed GP slots used by guarded river/water/mask callbacks. The fixed and initial placement tables use `ePlaceData *`, including typed allocation and indexing. Five state words that retail only resets remain real named storage, with purpose comments limited to that observed operation.

The twelve-entry writable `SPI_TAG_PARAM emap_tag` table includes eleven tag literals/callbacks and a null terminator. Ordinary declarations expose the three existing assembly-backed callbacks without changing any draft. Both editor-map vtables are emitted natively.

`BurnEditParts` must initialize its removal sentinel at the original declaration, before its other locals. Moving the declaration to the old cast-copy point changes 0x14 text bytes; keeping declaration order produces an exact match.

Retained markers: `at_1837__2__DATA` supplies the wall-up vector in `CheckWallEditParts`; ordinary and aligned VU-vector initialization at the existing copy point each change 0x20 text bytes beginning at function+0xac. `at_426` supplies the zero rotation reset in each `ClearAllParts` placement iteration; both ordinary and aligned vector initialization change the linked image. All rejected forms are reverted and the full PAL image/all149 objects pass. The inherited `EditVector` wrapper remains only for these retained consumers; no new union or cast is added.

Each accepted step passes the complete PAL build (`SCES_511.90: OK`) and
all 149 canonical object comparisons, including resolved relocations.
The final hash inventory changes only migrated owned units; every unowned
object remains equal to the warm baseline. No guarded function, assembly
entry or existing compiler-profile row changes. No function is promoted.

Accepted receipt prefixes under `.private/dataF/`:
- `editmap-part-names` (`-build.log`, `-objects.log`).
- `editmap-placement-error` (`-build.log`, `-objects.log`).
- `editmap-class-name` (`-build.log`, `-objects.log`).
- `editmap-river-position` (`-build.log`, `-objects.log`).
- `editmap-part-bound-margins` (`-build.log`, `-objects.log`).
- `editmap-parser-state` (`-build.log`, `-objects.log`).
- `editmap-tag-table` (`-build.log`, `-objects.log`).
- `editmap-__vt__14CEditCollision` (`-build.log`, `-objects.log`).
- `editmap-__vt__8CEditMap` (`-build.log`, `-objects.log`).
- `editmap-removed-position-at-declaration` (`-build.log`, `-objects.log`).

Final refresh, coverage and hash receipts are
`editmap-vectors-final-{refresh,coverage,metrics}.log` in that directory.
Final markers are **1 RODATA / 1 BSS**; refreshed
matched data is **552/744**.
