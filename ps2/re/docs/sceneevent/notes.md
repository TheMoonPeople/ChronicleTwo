# sceneevent: header notes

## What the unit owns
- All 14 functions are `CScene` members. `CScene` is owned by `scenesnd` (class_units.tsv), so it
  is declared in `scenesnd.hpp`, not here.
- No non-member functions, no global data with plain names. `col$1003` (.data, used by
  `DrawLensFlare`) is a function-local static; `at_*` are literals. Nothing to `extern`.
- `sceneevent.hpp` declares only `CSceneEventData`, which no class owns (it has no member
  functions) and which first appears in this unit's `RunEvent` / `GetMapEvent`. `scenesnd.hpp`
  needs it by value (see below) and should `#include "sceneevent.hpp"`.

## CSceneEventData (size 0xD0)
Size: `CScene::GetTalkEvent` (scenevillager) `memset`s a local of 0xD0; `RunEvent` copies
exactly 0x00..0xCF into `CScene+0x2E90`, and the next CScene field is at `+0x2F60`;
`CEditEvent::StartEvent` (editevent) copies 0x00..0xCF into `CEditEvent+0x20`.

| Off | Field | Evidence |
|---|---|---|
| 0x00 | `CFuncPoint::EventData event` (0x28, from mapload.hpp) | `GetMapEvent` copies `CFuncPoint+0x20..0x47` (6 words, then 16 bytes from `+0x38` by a 2-bytes-per-step loop). `StartEvent` tests flag bits 0x8/0x10/0x80/0x200/0x400 at +0 (= `FUNC_EVENT_FLAG` DOOR/ED_DOOR/CLOSE_DOOR/TREASURE_BOX/BOOK). |
| 0x08 | (`event.unk_28`) | Event number for non-map events: `GetMapEvent` writes 300 (game object returning slot 0x78) or 400 (slot 0x7A) when `check_type == 1`; `GetTalkEvent` writes `slot - 8`; `StartEvent` overwrites with 0xF9 for close doors. mapload.hpp names it `unk_28`; a better name belongs in mapload.hpp. |
| 0x0C, 0x10, 0x14 | (`event.unk_2c/30/34`) | `InitLadder` (editctrl): +0xC ladder height (int, added to a float), +0x10 `LdrSound`, +0x14 foot value. |
| 0x28 | implicit padding | Not copied by `RunEvent`/`StartEvent`; produced by the 16-byte alignment of `sceVu0FVECTOR`. |
| 0x30 | `sceVu0FVECTOR position` | From `CFuncPoint::position` (+0x180); `GetGameObjectEvent` stores the object position with w=1; `_GET_EVENT_DATA` case 10 reads floats. |
| 0x40 | `sceVu0FVECTOR rotation` | From `CFuncPoint::rotation` (+0x190); zeroed by `GetGameObjectEvent`; `_GET_EVENT_DATA` case 11. |
| 0x50 | `sceVu0FVECTOR scale` | From `CFuncPoint::scale` (+0x1A0); `_GET_EVENT_DATA` case 12. |
| 0x60 | `MapEventInfo map_event` (0x60, map.hpp) | `GetMapEvent` fills it from the local `MapEventInfo` passed to `CMap::GetEvent` (vtable +0x34 of the object at `CMap+0xD00`). `InitLadder` uses +0x70/+0x80/+0x90 as axes and +0xA0 as position (matrix rows). `_GET_EVENT_DATA`: case 6/7 = +0x60/+0x64 ints, case 8 = matrix translation (+0xA0) and `atan2f(+0x90, +0x98)` (third row x, z), case 9 = +0xB0 (`parts_no`). |
| 0xC0 | `s32 chara_no` | `GetTalkEvent`: `GetCharaNo(slot)`. `_GET_EVENT_DATA` case 14. |
| 0xC4 | `s32 chara_slot` | `GetTalkEvent`: scene character slot (8..63). `_GET_EVENT_DATA` case 13. |
| 0xC8 | `s32 gameobj_no` | `GetGameObjectEvent`: index of the position within the `GameObjInfo` entry (for slot 0x7A objects). `_GET_EVENT_DATA` case 15. |
| 0xCC | `s32 unk_cc` | Only copied (and `LoadIntNPC` touches `CScene+0x2F5C`; not analysed). |

### Copy code generation
- `RunEvent` copies the struct with `lwc1/swc1` for 0x00..0x27 and 0x30..0x5F, `lq/sq` for
  0x60..0xBF, `lw/sw` for 0xC0..0xCF: a per-member copy (assignment of the whole struct,
  `this->event_data = *data`, is the first thing to try).
- `GetMapEvent` copies differently: `lw` for event +0x00..0x14, a byte loop for the 16-byte
  array, `ld/lw` for the three vectors, and for `MapEventInfo` only +0x60, +0x64, the matrix
  (8-step loop of word pairs) and +0xB0, +0xB4 -- it skips +0x68/+0x6C. That suggests
  `MapEventInfo`'s `unk_8`/`unk_c` may really be alignment padding before the matrix, or that the
  source assigns members individually. Unresolved.

## CScene fields used by this unit (for scenesnd.hpp)
`+0x24F0` CFireRaster (EffectStep/DrawEffect), `+0x2E50` player character slot (InitLadder),
`+0x2E54` current camera slot, `+0x2E5C` current main map slot, `+0x2E88` event running flag,
`+0x2E8C` running event number (100 is special: a running event 100 cannot be replaced),
`+0x2E90` `CSceneEventData` of the running event, `+0x2F60` int set by `GetMapEvent`
(last event number passed through, or 1 for a game object), `+0x2F6C` int copied to
`CMap+0xC88` by `UpDateMapInfo`, `+0x3050` CVillagerMngr (scenevillager).

## Other observations
- `CSceneEventData` has an alternate bulk-copy view: `head`, `group_1`, and
  `group_2` cover the ten words of `CFuncPoint::EventData`; `group_3`,
  `group_4`, and `group_5` cover position, rotation, and scale; and
  `vectors_a`/`vectors_b` cover the six quadwords of `MapEventInfo`.
- `CScene::RunEvent` copies these blocks into its `event_data` member. Direct
  member access produces the same PAL instructions as the former 0x2E90 offset view.
- `UpDateMapInfo` / `DrawSky` use `CMapLightingInfo` (mapload.hpp) on the stack with
  `memset(…, 0, 0x1D0)`.
- `EyeViewDrawOnOff` toggles `+4` of the two parts groups named by `at_958__3`/`at_959__3`.
- First game: no `CSceneEventData` there.

## Function behavior
- `GetColPoly` and `GetCameraPoly` collect collision polygons from up to four active maps. Each map receives the remaining capacity and the next free `CCPoly` slot; iteration stops when the remaining capacity becomes negative.
- `GetFixCameraPos` copies the query vector, raises its Y component by one, and asks each active map for the first fixed camera position.
- `FixCameraPartsOnOff` forwards the supplied position to every active map.
- `GetMoonPosition` gets the sun position and negates its Y component.
- `EffectStep` steps every active map and then the scene's fire raster.
- `RunEvent` refuses to replace running event 100. Other requests set the running event number, copy the optional event description, and mark the event active; a request made during another running event prints `start event running!!`.

## Matching status

All functions are native; no assembly function fallback remains.

## Native data and matching constraints

The flare palette is DrawLensFlare's aligned `static float col[4][4]`; script and
resource strings are inline. The `{0,0,0,78}` base flare initializer remains
`at_1013__4` because natural aggregate copies change register allocation: MWCC retains
ratio[0] across the copy where retail reloads it.

Float-array, aligned-vector and union aggregate initializers do not match. Copying a
static union adds an implicit assignment helper. memcpy variants outline the copy; the
best differs by 29/156 masked words at 0x26C bytes within the 0x270 piece. CopyVector
with inline_depth(8) removes the extra helper but gives 0x268 bytes and 106/155
differences over retail's declared extent. Moving sun/screen buffers into the
conditional restores stack order only. A scoped O2 variant grows to 0x280 and differs by
143/160 words. These forms and their pragmas remain rejected.
