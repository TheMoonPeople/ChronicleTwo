# vlgr_info: reverse-engineering notes

`VlgrPlace` is a native `CVillagerPlace[VLGR_PLACE_MAX]` global. Its array constructor generates
the 32-byte retail `__sinit_vlgr_info_cpp`, including the runtime array-construction call.

Loads the town villager tables from three configuration scripts (run through `CScriptInterpreter`
with tag tables) and answers lookups on them. No first-game counterpart.

## Header ownership
- `CVillagerPlace` (owned here per class_units) and `CVillagerPlaceInfo` (villagermngr) are both
  declared whole in `villagermngr.hpp`, including the constructors that live in this unit
  (`__ct__14CVillagerPlaceFv` 0x31FBA0, `__ct__18CVillagerPlaceInfoFv` 0x31F3B0). `vlgr_info.hpp`
  includes `villagermngr.hpp` and does not redeclare them.
- `vlgr_info.hpp` declares `CVillagerInfo`, `GAME_PROGRESS_INFO`, `VLGR_HOUSE_TYPE`, the table-size
  enum and the 11 global non-member functions.

## Local (static) symbols: go in the .cpp, not the header
Every `ni*`, `vpi*`, `gi*` tag function and `vpiGetMotionID` is LOCAL. All data of the unit is
LOCAL too, so the header has no `extern`s:
| Symbol | Type | Notes |
|---|---|---|
| `PlaceInfoNum` / `PlaceInfo` | `int` / `CVillagerPlaceInfo *` | array built by `vpiNPC_PLACE_NUM` (`new (stack) CVillagerPlaceInfo[n]`) |
| `VlgrInfoNum` / `VlgrInfo` | `int` / `CVillagerInfo *` | built by `niNPC_INFO_NUM`; sorted by `vlgr_id` (binary search in `GetVillagerInfo`) |
| `ProgressNum` | `int` | set 0x100 by `LoadGameInfo` |
| `niStack`, `vpiStack`, `giStack` | `mgCMemory *` | allocation stack for each script |
| `niVlgr` | `CVillagerPlace *` | entry of `VlgrPlace` being filled (`niNPC`) |
| `niProgNum`, `niProgTime`(unused but cleared), `niProgDupliID`, `niProgCon` | `int` | `niProgDupliID` = PROGRESS arg 2 (alternative index into `place[4][2]`), `niProgCon` = 1 when arg 3 is "以後" (`at_250`) |
| `niProgInfo` | `CVillagerPlace::ProgressInfo *` | points at a 10240-byte (0x100 x 0x28) stack buffer in `LoadNPCInfo`; copied out in `niPROGRESS_END` |
| `niNowProgInfo` | `CVillagerPlace::ProgressInfo *` | entry being filled |
| `niPlaceInfo` / `niPlaceInfoNum` | `CVillagerPlaceInfo *` / `int` | copies of PlaceInfo/PlaceInfoNum |
| `niVlgrInfoIdx` | `int` | next CVillagerInfo slot |
| `vpiInfo` | `CVillagerPlaceInfo *` | place being filled |
| `giGamePI` | `GAME_PROGRESS_INFO *` | = `ProgressInfo` |
| `VlgrPlace` | `CVillagerPlace[0x200]` | .bss 0x1000; constructed by `__sinit` (`__construct_array(.., ct, 0, 8, 0x200)`) |
| `ProgressInfo` | `GAME_PROGRESS_INFO[0x100]` | .bss 0xC00; zeroed field-by-field in `LoadGameInfo` (unrolled by 8) |
| `ni_tag` (0x50), `tag` (`tag__9`, 0x60), `gi_tag` (0x10) | `SPI_TAG_PARAM[]` | NULL-terminated name/function tables; `tag` is used only by `LoadPlaceInfo`; the `__9` suffix suggests a function-local static there (unconfirmed) |

Tag tables: `ni_tag` = NPC, NPC_END, PROGRESS, PROGRESS_END, PLACE, NOON_PLACE, NIGHT_PLACE,
NPC_INFO_NUM, NPC_INFO. `tag` = NPC_PLACE_NUM, NPC_PLACE, NPC_PLACE_END, PLACE_POS, MOTION,
MOVE_TO, WAIT, TALK_OFFSET, MOVE_MOTION, MOVE_SPEED, SHADOW. `gi_tag` = PROG_INFO.

Strings: `at_214` "chara/%s.chr"; `at_250` "以後"; `at_439` "mtn" (WAIT arg 1 -> wait.motion_end);
`at_450` "sit"; `at_495` "stand"; `at_496` "special"; `at_497` "walk"; `at_498` "run";
`at_555` "place.cfg"; `at_556` "npc_place4.cfg"; `at_557` "rm %d\n" (mgCMemory +0x28 - +0x24).
`vpiGetMotionID`: NULL/"" -> -1, sit 4, stand 0, special 8, walk 1, run 2, else -1
(= `VLGR_MOTION` in villagermngr.hpp). `vpiMOTION` only recognises "sit" (motion = 4).
Testing `*name == '\0'` for the empty name matches the PAL object without casting the
`char *` to a signed-byte pointer.

## Script files (read from DATA.DAT plaintext)
- npc_place4.cfg comments: `PROG_INFO ID,章,節,経過時間;` + name, e.g. `PROG_INFO 3 , 1 , 1 , 2 ,"１章";`.
  `PROGRESS 進行ID,分身ID,条件;` with 条件 "中" (during) / "以後" (from then on).
  `NPC_INFO id,"model",house,"frames","frames"`, e.g. `NPC_INFO 402 ,"p03_05a",-1,"face01;hair01;supana","face02;helmet;..."`.
  No entry in the retail file passes the 6th/7th arguments.
- place.cfg: `NPC_PLACE 配置ID,マップ番号;`, `PLACE_POS x,y,z,ry`, `TALK_OFFSET 0,0,30`.

## GAME_PROGRESS_INFO (0xC) -- name not retail
Stride 0xC (`GetGameProgressInfo`: `ProgressInfo + n*0xC`), bss 0xC00 / 0x100 entries.
| Off | Field | Evidence |
|---|---|---|
| 0x0 | s16 chapter | `giPROG_INFO` arg 2 (sh); `GetGameChapter` lh; mapjump compares 8..9 / 6..7 |
| 0x2 | s16 section | arg 3 (sh); script comment 節; no reader found |
| 0x4 | s32 order | arg 4; 経過時間; villagermngr `GetAppearVlgr` compares `<=` |
| 0x8 | char *name | arg 5 via `mgCopyString`; mapselect `SaveDataEditLoop` prints it |
`giPROG_INFO` rejects index outside 0..0xFF.

## CVillagerInfo (0x1C)
Size from stride 0x1C (`GetVillagerInfo`, `niNPC_INFO`) and `__construct_new_array(.., 0x1C, n)`.
| Off | Field | Evidence |
|---|---|---|
| 0x00 | vlgr_id | ctor -1; NPC_INFO arg 1; binary-search key |
| 0x04 | model_name | arg 2 (string); `GetVillagerModelName` sprintf "chara/%s.chr"; scenevillager SearchCopyModel strcmp |
| 0x08 | house_type | ctor 0; arg 3 (if argc>2); editevent `Step` appends {"ia","ib","ic","id"}[x % 4] to the house map name; script uses -1..3 |
| 0x0C | show_frames | ctor 0; arg 4 (argc>3); scenevillager CharaObjectOnOff `GetObjectNameList` -> attr `draw = 1` |
| 0x10 | hide_frames | ctor 0; arg 5 (argc>4); same, `draw = 2` (MG_FRAME_DRAW_SKIP_CHILDREN) |
| 0x14 | unk_14 | ctor -1; arg 6 (argc>6, read with 0x18); event_func `_GET_MES_ETC` kind 3 returns it to the script |
| 0x18 | unk_18 | ctor -1; arg 7; same, second output |
Ctor store order: +0,+4,+8,+0x10,+0xC,+0x18,+0x14.

## Other observations
- `niNPC` rejects ids outside 0..0x1FF, memsets the `CVillagerPlace` (8 bytes).
- `niPROGRESS` reuses an existing entry with the same progress id, else appends (max 0x100) and
  calls `ProgressInfo::Init`; `NOON_PLACE`/`NIGHT_PLACE` write `place[dupli][VLGR_TIME_NOON/NIGHT]`.
- `niPROGRESS_END` allocates `new (stack) ProgressInfo[n]` (plain `__nwa`, no constructor, 0x28
  stride) and copies 10 words per entry.
- `vpiNPC_PLACE`: arg1 place number (unchecked), arg2 -> map_no (+0x20), sets move_motion (+0x28) = 1.
- `vpiSHADOW` stores `!arg` into no_shadow (+0x30). `vpiMOVE_TO`/`vpiWAIT` use `CVillagerPlaceInfo::Add`
  and fill Node type 1 (pos + w from 4th float) / type 2 (motion_end, time, motion).
- `LoadGameInfo` uses a 102400-byte stack buffer for both files; returns nothing on failure (void).
- `GetVillagerModelName` returns 0/1 (`int`). `GetGameChapter` returns the s16 chapter; declared `int`.
- The table-size enum names (`VLGR_PLACE_MAX`, `GAME_PROGRESS_MAX`) and `VLGR_HOUSE_TYPE` values
  are not retail names.


## Native data and linkage

All initialized data and BSS are native. Parser state is file-local; `ProgressInfo` and
`VlgrPlace` retain external linkage for generated VU-data references. The progress table
has extent 0xC00. Script tables `ni_tag`, `tag` and `gi_tag` contain 10, 12 and 2 rows
respectively, including null terminators. The progress condition's Shift-JIS bytes are
`88 C8 8C E3`, represented by octal escapes.

The file-scope parser `tag` matches the retail object. A local `tag` inside the consumer
gives an unresolved compiler-generated identity despite matching the final executable;
the linker deduplication suffix does not prove local-static storage.
