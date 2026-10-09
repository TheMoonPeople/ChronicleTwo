# event: reverse-engineering notes

No class is owned by `event` (`class_units.tsv`). The unit is a set of free functions driving the
scene event script. No first-game counterpart (`chronicle` has no `event.cpp`).

## Data
| Symbol | Addr | Binding | Type | Notes |
|---|---|---|---|---|
| `EventScene` | 0x37DE74 .sbss 4 | global | `CScene *` | Set by `InitEvent`/`RunEvent`; read by event_func too. Declared `extern` in the header. |
| `EventScript` | 0x1EFD400 .bss 0x54 (slot 0x60) | **local** | `static CRunScript` | Defined in the .cpp after the includes; constructed by the compiler-generated `__sinit_event_cpp` (`CRunScript::CRunScript()`); `load`/`run`/`resume`/`skip`/`DeleteProgram` called on it. |
| `cnt$1056` | 0x37DE78 .sbss 4 | local | `static int cnt` in `EventLoop` | Function-local static; door-sequence frame counter passed to `EventDoorLoop`. |
| `vv$984` | 0x356080 .data 0x30 | local | `static float vv[3][4]` in `EventDoorLoop` | Function-local static with 16-byte alignment; three camera-offset rows (negative half-unit values, homogeneous W). Only `vv[1]` is read, as the vector for `sceVu0ApplyMatrix` (camera offset rotated by the character's yaw). |
| `at_819__4` | .rodata | literal | `"event/talk/npc_talk_c%d_%d.txt"` (chapter, LanguageCode); inline at its use in `LoadNpcTalkMes` |
| `at_820__4` | .rodata | literal | `"event/talk/npc_talk_c2_%d.txt"` fallback; inline at its use |
| `at_1002__4` | 0x371A30 .rodata 9 | literal | SJIS "ドア開け" (door open), written inline as the eight exact Shift-JIS bytes `83 68 83 41 8A 4A 82 AF`: motion name passed to character vtable slot 0xB0 (likely `SetMotion(char*, int)`) with flags 2. |

The unit has no data markers; every object and literal comes from the source definitions above.


## EdEventInfo (owned by event_func, 0x1EFD460, size 0x12A0)
Fields this unit touches (offsets from EdEventInfo):
- 0x20: written by `InitEvent` with `mgGetProjection()` (float projection).
- 0x88 (0x1EFD4E8): scene event number requested by `_LOAD_SCRIPT`, -1 = none (`StartEventSyori`).
- 0x8C (0x1EFD4EC): script file path string (from `_LOAD_SCRIPT`; `EventLoop` copies chars up to `/`, max 0x20, then `GetMapPath`/`DivPathName`).
- 0xCC (0x1EFD52C): request code -> `EVENT_REQUEST`. Writers: 3 `_GOTO_EDIT`/`_GOTO_DNG`, 4 `_GOTO_INTERIOR`/`_MOVE_INTERIOR`/`_FUNCTION_MAP_JUMP`, 7 `_GOTO_OUTSIDE`/`_FUNCTION_MAP_JUMP`, 8 `_MAP_JUMP`, 0xF `_LOAD_SCRIPT`, 0x11 `_GOTO_EDITMODE`, 0x12/0x13 `_SET_FUNC_ETC`. Readers: EditLoop (4 EditGotoInterior, 7 EditExitInterior, 8 EditMapJump, 0x12 ResetEditEvent, 0x13 RestartEditEvent), RunMainEvent (3 -> DngStatus 5, 2 -> 4, 1 -> 0). EventLoop handles 0xF itself (reloads script, returns 0xF). Value 2 is never stored here: EventLoop returns 2 when command mode == 3. Value 1 is returned when the word at 0x1EFD43C (before EdEventInfo, i.e. a separate global) is non-zero and `EdEventEnd()` ran, or when the 0xF reload finds no usable loop.
- 0xD0 (0x1EFD530): command mode -> `EVENT_COMMAND_MODE`. 3 set by `_GOTO_MENU`, `_GOTO_SELECT_PARTY`, `_GOTO_USE_ITEM(2)`, `_GOTO_DRAW_CHAPTER`, `_GOTO_DNG_MAP`, `_MENU_CHARA_CHENGE`; 4 by `_FUNCTION_DOOR_MODE`. 1 and 2 (script not resumed) have no direct writer found; names left `UNK`.
- 0xD4 (0x1EFD534): skip state -> `EVENT_SKIP_STATE`. 1 by `InitDramaScene`, 2 by `SkipEventStart`, 3/0 in `EventLoop`; 0 by `CancelDramaScene`/`EdEventFinish`. `CheckEventSkip` = `state != 0` (sltu -> `bool`).
- 0xD8: skip button (pad button index for `CPadControl::Btn`), default 0xF from `InitDramaScene`, set by `_SET_SKIP_BOTTON`; EventLoop only skips when it equals 0x14.
- 0xE0..0xE8: fade colour (floats) for skip fade-out.
- 0x13C: door character number; 0x144: door SE id; 0x17C..0x194 door position/yaw/camera pos; 0x198..0x1A0 camera ref offset; 0x1C8: door type mapped to SE 0xD/8/6/4/2/0 (values 5/4/3/2/1/other).
- 0x1FC (0x1EFD65C): cleared by `SkipEvent`.
- 0x126C/0x1270: NPC talk text pointer / size (`LoadNpcTalkMes`, `ResetNpcTalkMes`).

0x1EFD480 = EdEventInfo+0x20; 0x1EFD43C precedes EdEventInfo (another global; checked in EventLoop before `EdEventStep()`).

## Functions
- All 15 functions are global (none in `local_symbols.tsv`), so all are prototyped in the header.
- `GetSquareEvent`: returns `CSaveData::CheckNowTourType()` unchanged (callee does `lb`, so a signed byte); header uses `int`, which mangles the same and needs no extension. Switch to `char`/`s8` if savedata declares it so and matching needs it.
- `SetEventScript(char *program, char *unused, mgCMemory *memory)`: second parameter never read; callers pass null. Allocs 0x40 qwords stack (0x80 entries) and 0x180 qwords call data (0x200 entries) then `CRunScript::load` and `SetEventFunc`.
- `EventDoorLoop(frame, use_scene_se)`: frame <= 0 positions character (vtable +0x10, +0x1C) and plays door motion; frame 25 plays SE (scene SE `EventScene+0xA498`); frame 30 fades out (`EventScene+0x2C70` is a `CFadeInOut`); returns 1 once frame >= 61.
- `GetEventMessage`/`GetActiveCamera`/`GetCharacter` wrap `CScene::GetMessage`/`GetCamera(EventScene+0x2E54 = active camera no.)`/`GetCharacter`; return types from callers (ClsMes fields in SkipEvent, mgCCamera methods, CCharacter2 cast in event_func).
- `EventLoop` uses `EventScene+0x2E88` (cleared before re-running) and `GetNowLoopNo()` 1/2 to choose `ScriptBuffer`/`BuffScriptData` memory.

## CScene offsets used (CScene owned by scenesnd)
0x2C70 CFadeInOut (by value), 0x2E54 active camera number, 0x2E88 int, 0xA498 SE handle (passed to sndSePlay).

## Status
All 15 explicit functions are native C++ definitions and match retail; the unit
has no `INCLUDE_ASM` or `NONMATCHING` guards. `__sinit_event_cpp` is emitted by
the static `CRunScript` object's construction and has no standalone source
function. The script reload path uses the town script memory or dungeon script
memory according to the active loop.

## Typed stack-buffer access

The NPC message loader and event script loader take their file destination
from `mgCMemory::stGetTop()`. Casting that quadword pointer to the API's byte
pointer type avoids hand-written stack pointer arithmetic.
