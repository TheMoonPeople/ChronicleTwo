# eventedit notes

Debug event editor (camera / character placement, camera and character path recording, dump to
`host0:debug.txt`). Runs only when `DebugFlag == 1`. Callers:
- `editloop`: `EditInit` -> `InitEventEdit(0xD6, &MenuBuffer)`; `EditLoop` -> `EventEdit(&WorkBuffer)`,
  `ChkEventEditStart()`, `DrawEventEdit()`.
- `dng_main`: `InitDungeonMain` -> `InitEventEdit(0x7D, &debug_event_stack)` (a 0x30 mgCMemory);
  `LoopDungeonMain` -> `EventEdit(&BuffWorkData)` / `ChkEventEditStart()`; `DngMainDraw` -> `DrawEventEdit()`.

No classes owned (`class_units.tsv` lists none). No first-game counterpart.

All 13 functions are native C++ definitions and match retail; the unit has no `INCLUDE_ASM` or
`NONMATCHING` guards and no data markers.

## Functions
| Function | Binding | Return | Notes |
|---|---|---|---|
| `OutPutFile()` | local -> static | void | `sceOpen("host0:debug.txt", ...)`, sprintf/sceWrite lines (the four direct path-command literals are passed as `const_cast<char *>("...")` because the SDK `sceWrite` declaration takes `void *` and MWCC's C++ overload check rejects the unqualified literal): character (select_chara, collision, pos/rot via vtable +0x18/+0x24 then `CalcPosWorldCoordGyaku`, offset by `EdEventInfo`+0x10..0x18), camera (`CMRS_SET_POS/REF`, angle, height, distance, projection = `EdEventInfo`+0x20), camera pas (`CMRS_*_PAS`, count `g_cmr_pas`+0x200, frame), chara pas (`OBJS_*_PAS`, count `g_chara_pas`+0x104). |
| `DrawBox(float*, float*, int, int, int)` | local | void | builds 8 corners (float[8][4]) from two opposite corners (max, min) and calls the other `DrawBox`; r,g,b. |
| `DrawBox(float(*)[4], int, int, int)` | local | void | stack `mgCDrawPrim`; wireframe (Begin(1) = lines) of 8 corners via `mgTransWorldPrim`, 24 `Vertex4`; colour r,g,b,0x80; draws only if all 8 transform OK. |
| `VectMatMul(float*, float*, float(*)[4])` | local | void | `out = in(xyz,w=1) * m` (3x3 rotation only), `sceVu0CopyVector(out, tmp)`. A same-named copy exists in event_func at 0x260A70 (`VectMatMul__FPfPfPA4_f__2`). |
| `evLoadDebugFont(int texb, mgCMemory*)` | local | void | `Align64`, `stAllocTest(1)`, `LoadFile2("img/font3.tm2", ...)`, `Alloc((size>>4)+1)`, `mgTexManager.EnterTexture(texb, "font3", (TM2_head *) buffer, 0, 0)` (the parameter type is part of the mangled name); then `JisFont.Initialize()`, `InitTexture(-1, "", -1, "", texb, "font3")`, `Clear()`, `JisFont.shadow_enable(+0x8AC) = 1`. |
| `MoveCamera(float* pos, float* ref)` | local | void | pad-driven camera translation in the view's yaw frame; R1/L1 (8/4) strafe by dist*0.04, Cross (0x40) x6, Square (0x80) without L1/R1 also moves ref. |
| `MoveCameraRef(float*, float*)` | local | void | same shape, moves the reference (not read in detail). |
| `MoveChara(CCharacter2*, mgCCamera*, mgCMemory*)` | local | void | pad moves character in camera yaw frame; R1/L1 rotate y by ∓0.12 wrapped to ±π; Cross doubles speed. If `collision`: box ±40, `CScene::GetColPoly(EventScene, CCPoly[0x100 on stack, 0x5000 bytes], box, 0x100)`, `CheckHit` down a ±39 segment, else drop 70; below -500 resets to 500; prints `"POLY_NUM = %d\n"`. Uses CCharacter2 vtable +0x10 SetPos, +0x18 GetPos (with mgCMemory* extra arg here), +0x1C SetRot, +0x24 GetRot; +0x110 float (height) * 0.7 for the camera ref on Triangle. |
| `InitEventEdit(int texb, mgCMemory*)` | global | void | `memory=m; texb=t; disp=1; active=0; mode=0; chara_no=0; collision=0`. |
| `ChkEventEditStart()` | global | int | `DebugFlag==1 && GamePad.Down(PAD_L3)`: active=1, `EdEventInfo`+0x20 = `mgGetProjection()`, `mgCCamera::StopCamera = 1`, saves camera pos/ref to `g_info.camera_pos/ref`, `evLoadDebugFont(texb, memory)`, `g_cmr_pas.Initialize(); SetFrame(200)`, `g_cp_*=0`, same for `g_chara_pas`/`g_chara_pas_*`, `GamePad.MenuModeOff()`; returns 1. Else 0. |
| `EventEdit(mgCMemory*)` | global | int | 0 if `DebugFlag!=1` or not active. PAD_L3 closes: active=0, camera pos/ref restored, StopCamera=0, `memory->stack_used=0; memory->lock=0`, MenuModeOff, `mgTexManager.DeleteBlock(texb)`. Otherwise per-mode logic below; then Select (0x100) next mode (wraps 3->0), `Down2(PAD_L3)` toggles `disp`, Start (0x800) -> `OutPutFile()`; returns 1. |
| `DrawEventEdit()` | global | void | only if `DebugFlag==1 && disp`: `EventMarker.Draw()`; if active: translucent 2D panel via stack mgCDrawPrim (`CPreSprite::Preset2D` on it), page title `%s` from mode names, per-page text, boxes. |
| `__sinit_eventedit_cpp` | local | - | constructs `g_cmr_pas` (`CCameraPas()`) and `g_chara_pas` (`CCharaPas()`). |

`ChkEventEditStart`/`EventEdit`: return value `addiu v0,zero,1` / `daddu v0,zero,zero` -> `int`
(Ghidra shows `bool` for Chk; the 0/1 is produced as a constant, not by a compare). Callers test `!= 0`.

### EventEdit per-mode pad use
- `CAMERA_MOVE` (0): L2 held -> MoveCameraRef else MoveCamera; Right/Left (0x2000/0x8000, On) +/-1
  to projection `EdEventInfo`+0x20, clamped 100..2000.
- `CHARACTER` (1): R2 held -> camera move; else Right/Left pick next/previous existing
  `GetCharacter(i)` (0..0x7F), Square toggles `collision`, Triangle sets camera ref to character
  pos + height*0.7, then `MoveChara`.
- `CAMERA_PAS` (2): camera move; cursor rows (Up/Down 0x1000/0x4000, 0..2): row 0 op 0..3,
  row 1 selno 0..15, row 2 frame (On, >=0). R2 Down: jump camera to point selno (if < count).
  Circle (0x20): apply op (`DelCameraPas(sel)`, `SetCameraPas(sel,pos,ref)`, `InsCameraPas(sel,pos,ref)`,
  `AddCameraPas(pos,ref)`). While `!CheckEnd()`: `Step(pos,ref)` drives the camera. Triangle: `Setup(); Run()`.
- `CHARA_PAS` (3): Triangle `Setup(); Run()`; while running `Step(pos, rot)` drives character;
  else R2 held -> camera move, otherwise MoveChara; same cursor rows/ops with `CCharaPas`
  (`Del/Set/Ins/AddCharaPas`, pos only); Square jumps character to point selno.

## Types (header)
- `EVENT_EDIT_MODE`: names from `at_1208` table (`.data` 0x358460) -> `at_1204..1207`:
  "CAMERA MOVE", "CHARACTER", "CAMERA PAS", "CHARA PAS" (5th entry `at_891` = "").
- `EVENT_EDIT_PAS_OP`: `at_1226`/`at_1242` tables (identical, one per path page) -> `at_1222..1225`:
  "Addition", "Insert", "OverWrite", "Delete". Matches the 0..3 dispatch in EventEdit.
- `EVENT_EDIT_PAS_ITEM`: cursor rows; `>`-prefixed strings in DrawEventEdit for row 0 "EditMode",
  1 "SelectNo", 2 "Frame".
- `EventEditInfo` (type name invented; retail name unknown), the type of `g_info` (.bss 0x01F34E80,
  size 0x40 from the symbol). Offsets:
  - 0x00 `active` int: 1 in ChkEventEditStart, 0 in Init/close; gates EventEdit/DrawEventEdit.
  - 0x04 `mode` int: compared 0..3, incremented on Select, indexes mode-name table.
  - 0x08 `disp` int: 1 in Init, toggled by Down2(PAD_L3), gates all drawing incl. the marker.
  - 0x0C `memory` mgCMemory*: from Init; on close writes +0x24 (`stack_used`) and +0x1C (`lock`).
  - 0x10 `texb` int: from Init (0xD6/0x7D); font texture bank for evLoadDebugFont / DeleteBlock.
  - 0x14 `chara_no` int: `GetCharacter(chara_no)`; "select_chara %d".
  - 0x18 `collision` int: toggled by Square; "collision %d"; MoveChara ground-follow switch.
  - 0x1C never accessed (`unk_1C`; alignment padding before the quadword vectors).
  - 0x20 `camera_pos`, 0x30 `camera_ref` float[4] (16-aligned): GetPos/GetRef on open, SetPos/SetRef on close.

## Data (LOCAL in retail; header declares no externs)
- `.sbss`: `g_cp_mode`, `g_cp_cursor`, `g_cp_selno` (camera path op / row / point), `g_chara_pas_mode`,
  `g_chara_pas_cursor`, `g_chara_pas_selno` (same for the character path); native `static int`
  objects, ranges as above.
- `.bss`: `g_cmr_pas` CCameraPas (0x950; point count int at +0x200), `g_chara_pas` CCharaPas
  (0x4B0; point count int at +0x104), `g_info` (native `static EventEditInfo`, 0x40 bytes).
- `g_cmr_pas` and `g_chara_pas` are defined with global linkage even though retail binds them
  LOCAL: the generated VU program data object (`Vu_progmain`) references both names, and the
  linker rejects the link when they are `static`. They are defined before use in retail
  constructor order.
- `CCameraPas` and `CCharaPas` are owned by `sceneseq`. Their methods used here: `Initialize, SetFrame,
  GetFrame, Setup, Run, CheckEnd, Step, Get/Set/Ins/Del/Add{Camera,Chara}Pas`.
- Compiler-generated: string literals `at_809..at_832`, `at_889..891`, `at_979`, `at_1204..1207`,
  `at_1222..1225`, `at_1382..1403` (all inline at their uses; identical strings pool at their retail
  addresses); local string-pointer tables `at_1208`, `at_1226`, `at_1242` (`.data`, 0x14 each) are
  emitted from the natural initializers of the three `char*[5]` local arrays in `DrawEventEdit`
  (four labels plus an empty fifth entry; the two operation-name arrays keep separate templates);
  `.ctor` `D_0037B040`.

## Externals referenced
`DebugFlag`, `GamePad` (`GamePad__2`), `mgCCamera::StopCamera`, `EdEventInfo` (event_func, +0x10..0x18
character offset, +0x20 projection), `EventScene` (CScene*, +0x2E54 shown as "Position %d"; +4 stack
index for `GetStack`, REMAIN_MEM = (stack+0x28 - stack+0x24)*16 bytes), `EventMarker` (CMarker),
`JisFont`, `mgTexManager`, `GetActiveCamera`, `GetCharacter`, `CalcPosWorldCoordGyaku`.

## Unresolved
- `EventEditInfo` and the enum names are descriptive, not retail.
- `MoveCameraRef` body not read in detail.
