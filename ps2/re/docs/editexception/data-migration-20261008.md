# editexception data migration

Checkpoint `830e48ed` has **20 RODATA / 19 BSS** markers and
**0/515 matched data bytes** after the warm
progress refresh.

Animated Georama-part identifiers, thunder-part identifiers, fire-texture and geyser-name strings are inlined at their native consumers. Five fire-sprite aggregate templates already exist in source. `CGeyserEffect::CreatePacket` now initializes its real `mgVec4` size, UV and colour aggregates directly, including the zero UV initializer.

Eighteen documented file-private words/pointers preserve the retail order of camera-reaction, thunder, fire-powder and geyser state. The assembly-backed fire initializer's GP slots remain present. No guarded draft is changed.

Retained RODATA marker: `at_1143__2__DATA`, the `"effect/firerain.img"` resource path directly referenced by assembly-backed `InitFirePowder`.

Each accepted step passes the complete PAL build (`SCES_511.90: OK`) and
all 149 canonical object comparisons, including resolved relocations.
The final hash inventory changes only migrated owned units; every unowned
object remains equal to the warm baseline. No guarded function, assembly
entry or existing compiler-profile row changes. No function is promoted.

Accepted receipt prefixes under `.private/dataF/`:
- `editexception-train-parts` (`-build.log`, `-objects.log`).
- `editexception-thunder-parts` (`-build.log`, `-objects.log`).
- `editexception-fire-texture` (`-build.log`, `-objects.log`).
- `editexception-geyser-names` (`-build.log`, `-objects.log`).
- `editexception-fire-sprite-templates` (`-build.log`, `-objects.log`).
- `editexception-geyser-sprite-vectors` (`-build.log`, `-objects.log`).
- `editexception-effect-state` (`-build.log`, `-objects.log`).

Final refresh, coverage and hash receipts are
`editexception-final-{refresh,coverage,metrics}.log` in that directory.
Final markers are **1 RODATA / 0 BSS**; refreshed
matched data is **312/515**.
