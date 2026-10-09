# October 9 round-three item-selection review fixes

## S6: plain item-selection colour array

`CItemSelect::Draw` directly initializes `u8 color[4]` with
`{0x80, 0x80, 0x80, 0}` and then assigns its alpha channel from the current
fade. `DrawOneItem` receives that array directly. The four-byte, byte-aligned
array has the same extent and channel types as the removed `ItemSelectColor`
wrapper; no guard, field layout, initializer value or data marker changes.

The isolated pinned-image MWCC/SF compile passes all `0x1B0B0` allocated
menusys bytes and 5,996 resolved relocations. The candidate and exact checker
receipt are `.private/fixes-r3b/probes/color-array/` and
`.private/fixes-r3b/receipts/color-array-probe.log`.

## Existing spacing and declaration decisions

`594dbe82` already removes the reviewed repeated blank lines and missing
function separators; those fixes remain in this lane. The incomplete
`MenuEffect[]` declaration is retained for the documented negative complete
bound probe in [review-fixes-r2-20261009.md](review-fixes-r2-20261009.md).
Adding `[2]` changed inventmn's object and PAL layout, so that probe is not
repeated. The defense casts mentioned in the review belong to a guarded
block and are out of scope here.

The shared `0x13D` save-flag proposal is integrated: `savedata.hpp` defines
`SAVE_FLAG_SPHEDA_UNLOCKED`, and the native menusys consumer uses it.

The normal full pinned-image build verifies `SCES_511.90: OK`, and all 149
canonical objects pass. Receipts:
`.private/fixes-r3b/receipts/menusys-color-{build,objects}.log`.
