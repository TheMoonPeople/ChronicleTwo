# October 9 round-three aquarium review fixes

## S6: existing data cleanup and signed-byte accesses

At m72, `7edc2e04` already defines `dirtbl_1242` as `float[2][4]` and reads
`dirtbl_1242[round.dir]`; it removes `AquaFishItemNo` in favor of fishing's
`FISH_ITEM_ID`, and removes the unused `aqua_wall_quad`. Those accepted
changes are preserved. Four redundant `(s8)` casts on `BREEDFISH_USED::sex`
are removed because the field is already signed byte; all native accesses
retain the same load width. The current rename-flag reads need no cast edit.

## Plain float arrays at the seed-copy sites

The earlier declaration-site aggregate and aligned SDK-vector trials are
already documented and are not repeated. This new private probe puts plain
`float[4]` initializers at the original `forward = at_1346` and four
`dir`/`steer` assignment sites, removing the associated externs, marker
copies and `aqua_vector` wrapper in the candidate. It uses `{0,0,1,1}` for
forward/direction and `{0,0,0,1}` for steering, exactly as the retail seeds.

The canonical whole-unit check rejects exactly two native function bodies:

| Function | Word differences including retail padding | Native / padded retail extent | First byte mismatch |
| --- | --- | --- | --- |
| `CAquaFish::NextThink` | 5 / 428 | `0x6AC` / `0x6B0` | `0x2101A0` |
| `CAquarium::Thinking` | 13 / 836 | `0xD0C` / `0xD10` | `0x21691C` |

The matching source keeps `aqua_vector` and its five seed copies. No candidate
marker removal or array substitution is applied. Source and diff:
`.private/fixes-r3b/probes/aqua-plain-use/`; canonical checker and word scores:
`.private/fixes-r3b/receipts/aqua-plain-use-{probe,score}.log`.

## S8/S9: current formatting and guarded status

`2e7523b6` already removes the repeated blank lines and orphan headings,
and corrects the stale descriptions that called native Step frozen. The
remaining retained marker consumers are guarded SettingAqua; the migration
note now uses that precise term. Its guarded block remains unchanged.

Full pinned-image build: `SCES_511.90: OK`; canonical object comparison:
149/149. Receipts: `.private/fixes-r3b/receipts/aqua-cleanup-{build,objects}.log`.

## S7/S8: shared cancel sound and race-mode documentation

`snd_mngr.hpp` adds `SYSTEM_SE_CANCEL = 5`, the value already named
`MENU_SCRIPT_SOUND_CANCEL` by the menu script interface. Aquarium and
saved-race callers use it for cancel buttons, declined confirmations and
unavailable selections. All direct sound-five calls and `se = 5` assignments
in this owned unit now use the shared sound ID. The later integration also
sets `MENU_SCRIPT_SOUND_CANCEL = SYSTEM_SE_CANCEL` in `menucommon.hpp`.

All 24 currently declared `GyoraceMenuMode` values have purpose comments.
The review's count of 23 omits the draw-only `LOAD_BOARD` value 0x43, whose
comment describes the board rendering without claiming an input transition.
The command enum and the four recently added aquarium header enums follow
the neighboring trailing-comment alignment. No enum number changes.

The full pinned-image build verifies `SCES_511.90: OK`; all 149 canonical
objects pass. Receipts: `.private/fixes-r3b/receipts/aqua-enums-{build,objects}.log`.
