# sceneevent: header notes

## What the unit owns
- All 14 functions are `CScene` members. `CScene` is owned by `scenesnd` (class_units.tsv), so it
  is declared in `scenesnd.hpp`, not here.
- No non-member functions, no global data with plain names. `col_1003` (.data, used by
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

### Copy codegen (for the body-writing agent)
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

## Draft and matching status (2026-10-06)

All 14 functions have named, typed C++ bodies. One isolated promotion attempt was made for each.
The following six were promoted into the default game build after a byte-identical linked
comparison: `RunEvent`, `FixCameraPartsOnOff`, `EyeViewDrawOnOff`, `GetSunPosition`,
`GetMoonPosition`, and `EffectStep`.

`UpDateMapInfo`, `GetColPoly`, `GetCameraPoly`, `GetMapEvent`, `GetFixCameraPos`,
`DrawSky`, `DrawLensFlare`, and `DrawEffect` remain guarded with their retail assembly
fallbacks. The two polygon gatherers differ by 0xE bytes each near their final
capacity test. The drafts of `UpDateMapInfo`, `GetMapEvent`, `DrawSky`, and
`DrawLensFlare` still differ in ordering or logic. `DrawLensFlare` also creates a
local datum that differs from retail. The `DrawEffect` trial did not link because
the currently declared `mgSetPkMoveImage` overload resolves to a different
symbol spelling from the retail object. These are matching gaps; the default
build retains assembly for all eight functions.

The guarded draft compiles, and the full default PAL build verifies every section
byte-identical with 0 unmatched functions.
