# editevent: reverse-engineering notes

Header: `ps2/include/editevent.hpp`. No first-game counterpart class (the first game's
`editloop` handled doors with loose globals such as `EdInteriorPartsNo`/`EdInteriorDoorSound`).

## CEditEvent (size 0x150, no vtable)
Size from the single instance `EditEvent` (0x01ECD8D0, size 0x150, owned by `editloop`).
No constructor: `__sinit_editloop_cpp` calls `Reset`. No virtual functions.

| Off | Field | Evidence |
|---|---|---|
| 0x00 | `count` s32 | Step: `++count` each frame; steps compare it (>200, 0xF, 0x14, 0x3C, 300) or set countdowns (0x14, 0x1E, 0xE, 5). Reset/StartEvent zero it. |
| 0x04 | `state` s32 | Step returns -1 unless ==1; set to 3 when the result is non-zero and not 5. StartEvent refuses (prints "now running!!!") when 1 or 2, then sets 1. editloop `ResetEditEvent`/`RestartEditEvent` test `EditEvent.state == 1` (DAT_01ecd8d4). Value 2 never set here. |
| 0x08 | `step` s32 | Sub-step switch per type in Step. |
| 0x0C | `unk_c` s32 | Only zeroed by Reset. |
| 0x10 | `type` s32 | StartEvent: -1, then flag&8 (door): flag&0x10 ? 0 : 1; flag&0x200 -> 2; flag&0x400 -> 3. Returns 0 if still -1. |
| 0x14-0x1F | unk_14/18/1c | Never touched; likely alignment padding before `data` (16-aligned). |
| 0x20 | `data` CSceneEventData | StartEvent copies the 0xD0 argument (quad copies of 0x60..0xBF); Reset `memset(this+0x20, 0, 0xD0)`; editloop copies EditEvent+0x20 to a stack CSceneEventData for `RunEvent(100, ...)` on results 2/3/4. |
| 0xF0 | `projection` float | StartEvent `= mgGetProjection()`; house door step 1 `mgSetProjection(projection)`. |
| 0xF4-0xFF | unk | Untouched; padding before the vector. |
| 0x100 | `return_pos` | Door step 0: character vfunc +0x18 (get pos) into it; step 4 interpolates back to it. |
| 0x110 | `return_rot` | Door step 0: character vfunc +0x24 (get rot) into it. |
| 0x120 | `reload_geo_npc` s32 | House door step 1: 1 when menu end_code 0xD and the part's info id is 0x49 (also fades out); step 2 then FadeIn(0x14) + `LoadGeoNPC(&param, 0)`. |
| 0x124 | unk | Untouched. |
| 0x128 | `map_name` char[0x20] | Door step 0 `strcpy(map_name, data.event.unk_38)` (unless it is "exit"); for flag 0x10 a suffix from a local `char *suffix[4] = {"ia", "ib", "ic", "id"}` (indexed by `GetVillagerInfo(npc)->+8 & 3`) or the literal "ia" when no info and strlen<=3. editloop passes EditEvent+0x128 (0x01ECD9F8) to `SearchMapNo`. Reset clears byte 0. 0x20 is the gap to 0x148. |
| 0x148 | `door_se` s32 | Reset/door step 0 set -1; door step 2 at count 0x14: `SePlayOpenDoor(data.event.unk_30, &matrix[3])` then stores unk_30. |
| 0x14C | unk | Untouched. |

Offsets inside `data` as Step uses them (EditEvent offset = data offset + 0x20):
- 0x20 `event.flag` (FUNC_EVENT_FLAG: 0x8 door, 0x10 ed_door, 0x80 close_door, 0x100 fade on open, 0x200 t_box, 0x400 book).
- 0x28 `event.unk_28`: event number. Door step 3 runs `RunEvent(unk_28, &data)` when >= 1. StartEvent sets it to 0xF9 for a door with FUNC_EVENT_CLOSE_DOOR. (mapload.hpp calls offset +4 `event_no`; the field at +8 is the one used as an event number here.) StartEvent reads `data.event.flag` and writes `data.event.point_no` through the event-data type and uses the `FUNC_EVENT_FLAG`, `EditEventState` and `EditEventType` enums.
- 0x2C `event.unk_2c`: door: < 0 means no open motion (count = 0xE); book: arg 2 of `BookshelfMessageMake`.
- 0x30 `event.unk_30`: door: open-door sound kind for `SePlayOpenDoor`; book: arg 3.
- 0x34 `event.unk_34`: book: arg 4.
- 0x38 `event.unk_38[16]`: destination map name, "exit" = leave interior.
- 0x90/0xA0/0xB0/0xC0 `map_event.matrix` rows: `mgDistVector` of rows 0-2 (largest scale, compared with 20.0); heading `atan2(row2.x, row2.z)`; row 3 (0xC0) = door position.
- 0xD0 `map_event.parts_no`: placed part slot (`GetePlaceParts`, MenuInfo param[0]).
- 0xD4 `map_event.point_no`: treasure box index (`GetTrBox`, `DeleteTrBox`).
- 0xEC `unk_cc`: written with the villager (`GetLiveNPC`) for an ed_door.

## Step result (EditEventResult), from editloop `EditLoop` switch
-1 not running; 0 continue; 1 end (`EditDataSave`); 2 enter interior (`EditGotoInterior(SearchMapNo(map_name), 0)` + RunEvent 100); 4 same with second arg 1 (door with flag 0x10, villager house); 3 exit interior (`EditExitInterior(0)` + RunEvent 100); 5 house-door menu (editloop sets mode 3, state stays running). Results 1-4 make editloop `Reset` + `UnLockCharaCtrl`.

Door step 3 result: "exit" -> 3 after fade; else when `PreLoadSync()==0` -> 2, or 4 with flag 0x10.

## Step enums (all from Step)
- House door (type 0): 0 sets `MenuInfo->open_type=0xC, scene, param[0]=parts_no`, CancelRotBack, KeepEditAnalyze, returns 5; 1 restore projection, end_code 9 -> type=1 (door), count/step 0; else EditDataSave, step 2; 2 when count>0x13 or fade done -> 1 (and `RunEvent(0x136, 0)` if `EditAnalyzeChanged()`).
- Door (type 1): 0..5 as in header. Close-door (flag 0x80) path: 1 -> 2 plays motion, 2 waits motion/0x3C frames -> 4, 4 walks back -> 5, 5 waits -> result 1.
- Treasure box (type 2): 0..7; box's top frame found with `SearchFrame("top")`, missing -> step 5. Box fields used: +0x70 frame, +0x64 zeroed, +0x668 item, +0x66C count (CMap tr box type, not declared here).
- Book (type 3): 0 message, count 0x1E; 1 by ClsMes::State (0 -> 2, 3 close on button, 5 next page), count-- and <0 -> 3; 2 -> 3; 3 close window, result 1.

Character vtable offsets used (not this unit's class): +0x10 set pos, +0x18 get pos, +0x1C set rot, +0x24 get rot, +0x6C, +0x90 (motion ended?), +0xB0 set motion by name. ClsMes offsets 0x158, 0x217C, 0x21C0, 0x2200, 0x225C, 0x2278, 0x1D0, 0x1E3C, 0x1E40, 0x194, 0x198, 0x140, 0x144 written directly (an inline ClsMes close sequence repeated 3 times; likely an inline member).

## GeoFuncParam (size 4)
`{ CScene *scene; }`. `_GEORAMA_FUNC` (event_func) builds one on the stack from `EventScene`; Step builds one from its `scene` argument for `LoadGeoNPC`. Only offset 0 used.

## Functions
- `GeoramaFunc` (global): `rsGetStackInt(args)` command: 1 LoadIntNPC(args+1, argc-1), 2 LoadGeoNPC(param, 0), 3 CheckPlaceBurnParts(args+1, argc-1), 999 printf warning returns 0, else 1.
- `CheckPlaceBurnParts`, `LoadIntNPC`, `LoadGeoNPC`: LOCAL in retail (local_symbols.tsv) -> `static` in the .cpp, not in the header. Signatures: `static int X(GeoFuncParam *, RS_STACKDATA *, int)` and `static int LoadGeoNPC(GeoFuncParam *, int)`.
  - LoadIntNPC: villager `scene+0x2F5C`, buffer `scene+0x3C`, stack 4 (needs 0xC800 free, else "geo int chara memory over!!"), slot from args; positions via map's CFuncPointMngr at map+0xCB0 "npc_pos".
  - LoadGeoNPC: main map 1 only; part with info id 0x49 (`GetePlacePartsAtInfoID(0x49, &no, 1)`), its live NPC into slot 8 with stack 2; position from the part's `npc_pos` point (CEditParts+0x2B0 CFuncPointMngr) through `GetLWMatrix`. Second arg non-zero skips the load (returns 1).
- `GeoUpdateNpcPos` (global, void): same placement for the already loaded villager, wrapped in StayVillager/CancelStayVillager.
- `Draw` returns int 0 (both paths return 0).

## Data
- `MenuInfo` (.sdata 0x0037CC48, LOCAL; another unit has its own `MenuInfo`): `static MENU_INIT_ARG *MenuInfo = &MenuArg;` (menumain.hpp). Used offsets 0x18 scene, 0x28 open_type, 0x3C end_code, 0x58 param[0]. Not in header.
- The house suffix table (.data, 0x10) is the function-local `char *suffix[4]` initializer in
  `Step`'s door branch, initialized at the point retail copies the template.
- No plain-named globals, so no externs in the header.

## Source status
All nine functions are native; the unit has no `NONMATCHING` guards, `INCLUDE_ASM` gaps, or
data markers. The diagnostic, motion, frame and configuration strings are inline literals (the
Shift-JIS motion names through hexadecimal escapes); the two switch tables of `CEditEvent::Step`
are emitted by its native switches. In `Step`, `camera` is a `CCameraControl *` assigned once
from `(CCameraControl *) scene->GetCamera(...)`, so `RotBack`/`CancelRotBack` need no per-call
downcast. Header `@size` annotations use the retail ELF's declared `STT_FUNC` extents.
