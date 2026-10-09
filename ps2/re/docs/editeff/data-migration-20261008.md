# editeff data migration

Checkpoint `830e48ed` has **8 RODATA / 6 BSS** markers and
**4/1711 matched data bytes** after the warm
progress refresh.

Texture lookup uses the literal `"haichi_eff"` directly. Five initialized star/paint templates and the two-vector zero template already exist in native source. Paint-drop size now initializes its four-float vector at the original copy point within the particle loop.

`EffectFlag` and `EffectState` are file-private 32-bit state words; `PaintEffect` is the file-private particle-effect pointer. `PlaceAnime` is the documented public three-element `CPlaceAnime` array (0x1b0 bytes), in the original BSS order after `_StarEffect` and `CurPartsBuff`. Existing constructors and their initialization order are unchanged. Both effect vtables are emitted natively. No markers remain.

Each accepted step passes the complete PAL build (`SCES_511.90: OK`) and
all 149 canonical object comparisons, including resolved relocations.
The final hash inventory changes only migrated owned units; every unowned
object remains equal to the warm baseline. No guarded function, assembly
entry or existing compiler-profile row changes. No function is promoted.

Accepted receipt prefixes under `.private/dataF/`:
- `editeff-texture-name` (`-build.log`, `-objects.log`).
- `editeff-native-initializers` (`-build.log`, `-objects.log`).
- `editeff-drop-size` (`-build.log`, `-objects.log`).
- `editeff-effect-state` (`-build.log`, `-objects.log`).
- `editeff-placement-slots` (`-build.log`, `-objects.log`).
- `editeff-native-vtables` (`-build.log`, `-objects.log`).

Final refresh, coverage and hash receipts are
`editeff-final-{refresh,coverage,metrics}.log` in that directory.
Final markers are **0 RODATA / 0 BSS**; refreshed
matched data is **1711/1711**.
