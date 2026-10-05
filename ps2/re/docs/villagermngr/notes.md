# villagermngr: reverse-engineering notes

Unit holds `CVillagerMngr` (13 methods), `CVillagerData::Initialize`, `CVillagerPlaceInfo::Add` and
`CVillagerPlace::ProgressInfo::Init`. No global data: the only data symbol, `at_513` (0x1C), is the
jump table of the `ex_step` switch in `Step` (7 words, cases 0..6). None of these classes exist in the
first game.

## Header ownership
`CVillagerPlace` is owned by `vlgr_info` (its constructor lives there), but `ProgressInfo` is nested in
it and owned here, so `villagermngr.hpp` declares the whole of `CVillagerPlace` (it is 8 bytes) along
with the constructors `CVillagerPlace()` and `CVillagerPlaceInfo()` (both vlgr_info). `vlgr_info.hpp`
should include `villagermngr.hpp` rather than declare these again.
Functions the bodies need from vlgr_info, not declared here: `GetVlgrPlaceTable(int*)` (returns
`CVillagerPlace VlgrPlace[0x200]`, count 0x200, symbol size 0x1000), `GetGameProgressInfo(int)`
(returns a vlgr_info struct whose +4 is the progress order compared in `GetAppearVlgr`),
`GetVlgrPlaceInfo(int)`.

## CVillagerMngr (0xE10)
Embedded in `CScene` at +0x3050 (scenevillager passes `this + 0x3050`); CScene+0x3054 is read as
`data_num`; the next CScene member is at +0x3E60, so 0x3050 + 0xE10 = 0x3E60.
- +0x00 `stop`: zeroed by `Initialize`; `CheckStay` returns 1 when set; `Step` only walks routes when 0;
  `CScene::StayNearVillager` only runs when 0. No writer found other than Initialize.
- +0x04 `data_num`: `Initialize` sets 0x20; loop bound everywhere.
- +0x08, +0x0C: never touched (padding up to the 16-aligned array).
- +0x10 `data[32]`: stride 0x70 (`GetData`: `this + no*0x70 + 0x10`).
Constructors are inline: `__sinit_mainloop_cpp` and `MenuItemCharaDataLoadEndCheckAfter` construct a
CScene in place with an inline loop of 32 `CVillagerData::Initialize` calls then
`CVillagerMngr::Initialize`, i.e. `CVillagerData() { Initialize(); }` and
`CVillagerMngr() { Initialize(); }`. No `__ct` symbols exist.

## CVillagerData (0x70)
Size from the 0x70 stride and the array end (0x3E60). 16-aligned by its vectors.
| Off | Field | Evidence |
|---|---|---|
| 0x00 | chara_id | Init -1; `Register` arg 2; `SearchDataIDatCharaID`/`DeleteCharaID` compare; scenevillager `GetCharacter(this, data[0])` |
| 0x04 | vlgr_id | Init -1; `Register` arg 1; `NewData` takes first entry with < 0; scenevillager treats >= 0 as live |
| 0x08 | unk_8 | Init -1 only |
| 0x0C, 0x10 | unk_c, unk_10 | Init 0 only |
| 0x14 | place | `Register` arg 3; `GetTalkRect`, `Step` read through it |
| 0x18 | route | `Step`: loaded from place->route, advanced via node->next |
| 0x1C | route_time | `Step`: zeroed on node change, incremented on wait nodes |
| 0x20 | ex_mode | `ExMode` sets 1; `Step` case 6 clears; `CheckStay` returns 0 when set |
| 0x24 | ex_step | `ExMode` sets 1 when entering; `Step` switch 1..6 (VLGR_EX_STEP) |
| 0x28 | ex_time | `ExMode` zeroes each call; `Step` increments; step 3 ends when > 3; turns to camera while 0 |
| 0x2C | stay | `Stay` ++, `CancelStay` -- clamped at 0; `CheckStay` returns it |
| 0x30 | req_motion | `Step` writes motion ids (-1 = none); scenevillager `SetCharaMotion(chr, [0x30], [0x38])` then resets to -1 |
| 0x34 | now_motion | scenevillager: `GetMotionID(chr->GetNowMotionName())` (vtable +0x8C) |
| 0x38 | motion_flag | `Step` writes 2 / 4; scenevillager passes it as SetMotion's flags and zeroes it |
| 0x3C | motion_end | scenevillager: chr vtable +0x90 (CheckMotionEnd) |
| 0x40 | parts_mode | `Step` sets 1 at ex start, 2 at pose out/restore, 0 at end; scenevillager, only for vlgr_id 0xE, toggles four mesh frames' +0x18 by it |
| 0x44..0x4C | unk | never touched in this unit or scenevillager |
| 0x50 | pos | `Initialize`: mgZeroVectorW; `Register`: lq/sq copy of place->pos then w = 1.0f |
| 0x60 | rot | `Initialize`/`Register`: mgZeroVector; [1] (0x64) = facing angle; passed to chr SetRotation (vtable +0x1C) |
`Register` copies place->pos with a 16-byte `lq`/`sq` (and `Step` copies node->pos and data->pos the
same way), so the source used an aggregate copy of a 16-byte vector type; bodies will need a struct
copy (or equivalent) to match.

## CVillagerPlaceInfo (0x40)
Size: `vpiNPC_PLACE_NUM` does `__construct_new_array(..., ct, 0, 0x40, n)`; ctor `memset(this,0,0x40)`;
`CScene::RegisterVillager(int,int,mgCMemory*)` news 0x40 (Alloc(6) = 4 quadwords + 2 header).
| Off | Field | Evidence |
|---|---|---|
| 0x00 | pos (w = facing angle) | `vpiPLACE_POS`: vector + float into [3]; Register copies 16 bytes; Step's target angle is +0x0C |
| 0x10 | talk_offset | `vpiTALK_OFFSET` (spiGetStackVector); `GetTalkRect` copies all 4 floats out |
| 0x20 | map_no | ctor -1; `vpiNPC_PLACE` 2nd arg; `GetAppearVlgr` compares to its map argument, which comes from `LoadVillager(MapNo, ...)` |
| 0x24 | motion | `vpiMOTION` ("sit" -> 4); Step uses as standing motion |
| 0x28 | move_motion | `vpiNPC_PLACE` sets 1 (walk); `vpiMOVE_MOTION`; Step uses while walking |
| 0x2C | move_speed | `vpiMOVE_SPEED` float; Step: <= 0 -> 0.8f |
| 0x30 | no_shadow | `vpiSHADOW`: `arg == 0`; scenevillager calls `SetStatus(1, chara, 8)` when set |
| 0x34 | route | `Add` appends to this list; Step: 0 means stand and turn to pos.w |
| 0x38, 0x3C | unk | never touched |

### CVillagerPlaceInfo::Node (0x20) -- retail name unknown
Allocated by `Add` with `new(Alloc(4)) [0x20]`; Add sets only +0 and +4 to 0. Neutral name `Node`.
- +0x00 next, +0x04 type (1 = MOVE_TO, 2 = WAIT; vpiMOVE_TO / vpiWAIT).
- +0x08, +0x0C untouched (vector alignment).
- MOVE: +0x10 vector (spiGetStackVector) and +0x1C float (2nd script arg; copied with the vector, not
  read separately by Step).
- WAIT: +0x10 motion_end (1 if 1st arg string is "mtn"), +0x14 time (frames), +0x18 motion
  (vpiGetMotionID of 3rd arg, -1 if absent). Step: ends when `route_time > time`, or when motion_end
  and data->motion_end.
Add's return type is the node pointer (callers write type/args into it).

## CVillagerPlace (8) and ProgressInfo (0x28)
- `CVillagerPlace`: ctor `memset(this,0,8)`; `niPROGRESS_END` writes [0] = count, [1] = `new[] (n*0x28)`;
  `GetAppearVlgr` walks the 0x200-entry table with stride 8.
- `ProgressInfo`: stride 0x28 in `niPROGRESS`, `niPROGRESS_END` (copies 10 words), `GetAppearVlgr`.
  +0 progress (1st arg of niPROGRESS), +4 after (3rd arg string == SJIS "以後" "from then on"),
  +8 `place[4][2]`: `niNOON_PLACE` writes `+8 + dupli*8`, `niNIGHT_PLACE` `+0xC + dupli*8`
  (dupli = niPROGRESS 2nd arg). `Init` zeroes +0 and +8..+0x24, not +4.

## Enums
- `VLGR_MOTION`: scenevillager `motion_name` table (SJIS): 0 立ち stand, 1 歩き walk, 2 走り run,
  3 会話 talk, 4 座り sit, 5 カメラ入り camera in, 6 カメラ camera, 7 カメラ戻り camera out,
  8 特別 special. `vpiGetMotionID` maps "stand"/"walk"/"run"/"sit"/"special" to 0/1/2/4/8.
- `VLGR_TIME`: place[..][0] noon, [1] night (niNOON_PLACE / niNIGHT_PLACE); `GetAppearVlgr` time arg
  from `CScene::GetNowVillagerTime`; forced to 0 when progress < 2.
- `VLGR_ROUTE_TYPE`: 1 move, 2 wait.
- `VLGR_EX_STEP` (Step switch): 1 -> step 2, req 5, flag 2, parts 1; 2 -> req -1, on motion_end req 6,
  flag 4, step 3; 3 -> req 6, when ex_time > 3 step 4, parts 2, req 7, flag 2; 4 -> on motion_end
  step 5, req place->motion; 5 -> step 6, parts 2; 6 -> ex_mode 0, parts 0. After the switch, steps
  2/4 jump to 6 unless now_motion is 5, 6 or 7.
Fields are declared `s32`, not the enum types (MWCC may size enums below int).

## Signatures
- `GetAppearVlgr(progress, time, map_no, int *vlgr_id, CVillagerPlaceInfo **place)` returns count;
  progress is `CUserDataManager`-side word at userdata+0x1A08. If `progress < 2`, uses progress 1 and
  time 0.
- `GetTalkRect(chara_id, float *rect)`: rect[3] = 0, then copy of place->talk_offset; returns
  `mgDistVector(rect) != 0`. Declared `int` (Ghidra shows bool; either mangles the same).
- `Register` returns 0/1; `CheckStay` returns 0, 1 or `stay`.

## Draft behavior
`ProgressInfo::Init` clears the progress number and eight scheduled place pointers, leaving `after` untouched. `CVillagerData::Initialize` frees the slot and zeroes movement and pose state. `CVillagerMngr::Initialize` resets 32 slots. `GetData` checks the slot number against `data_num`; `NewData` chooses the first slot without a villager ID. `CVillagerPlaceInfo::Add` allocates a 0x20-byte route node from its memory stack, clears the link and kind, and appends it.

`Stay` and `CancelStay` count hold requests, with cancellation clamped at zero. `ExMode` starts the camera pose only on entry and restarts its timer on every call. `SearchDataIDatCharaID`, `Register`, and `DeleteCharaID` manage slots by scene character number. `GetTalkRect` returns whether the selected villager has a nonzero talk offset.

`Step` takes the route branch while a villager is not in camera pose and neither its hold count nor the manager stop flag is set. A place without a route turns the villager toward the place heading. A move node turns and advances toward its point, switching to its successor within ten units. A wait node advances after its frame count or motion end. The camera pose branch runs six steps, changes motion and model part modes, and faces the camera on the first pose frame. The source draft uses typed vectors and route nodes; exact code generation still needs a promotion check.

`GetAppearVlgr` scans the 0x200-entry place table. It searches each villager's progress entries from newest to oldest, selects entries that apply to the current story order, and returns every place for the requested time and map. A progress-one entry provides the fallback when no later entry supplies a place. Progress below two forces daytime and progress one.
