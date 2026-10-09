# editctrl: reverse-engineering notes

This unit is the player control of the Georama edit mode. It covers walking with collision, the follow,
eye-view and photo cameras, ladders, and stepping and drawing the characters. It owns no class in
`class_units.tsv`. It has no counterpart in the first game, which has no `editctrl` unit.

## Header status
- `ps2/include/editctrl.hpp` includes `dng_main.hpp` for `MoveCheckInfo`, because
  `EditMoveCharaInfo` holds one by value. `MoveCheckInfo` is 0x110 bytes and 16-byte aligned;
  `STATIC_ASSERT(sizeof(EditMoveCharaInfo) == 0x130)` passes in the PS2 build.

## EditMoveCharaInfo (0x130)
Evidence:
- `fishing` (its local `CharaControl`): `memset(&info,0,0x130)`, and before that `memset(&info+0x10,0,0x110)`,
  which is the inlined `MoveCheckInfo` constructor.
- `pbuggy` (its local `CharaControl`): the same two memsets.
- `editctrl` `CharaControl`: the same two memsets.

| Off | Field | Evidence |
|---|---|---|
| 0x0 | `int poly_num` | EditMoveChara loops `i < *(int*)info`. pbuggy stores the `CreateCharaCPoly` count here. |
| 0x4 | `CCPoly *polys` | Copied 0x50 bytes at a time into the polygon list. pbuggy sets it to its stack `CCPoly[16]`. |
| 0x8 | `unk_8[8]` | Never accessed. It is padding to the 16-byte alignment of `MoveCheckInfo`. |
| 0x10 | `MoveCheckInfo move_info` | EditMoveChara copies the global `MoveInfo` (0x110 bytes) here after `MoveCheck`. |
| 0x120 | `int hard_landing` | Set to `velocity.y < -5.0` when `MoveInfo+0x8` (landed) is set. CharaControl reads it (`iStack_100`) to start the landing motion. |
| 0x124 | `unk_124[0xC]` | Tail padding. |

## MoveCheckInfo (owned by dng_main, 0x110 here vs 0xD0 in the first game)
These offsets were seen in EditMoveChara and CharaControl, for whoever writes `dng_main.hpp`:
- +0x0: float, set to 13.0 before each `MoveCheck` call.
- +0x8: int, the landed/ground flag (`DAT_01ec9538`).
- +0x10: `CCPoly` ground polygon. Its +0x40 is `ground_kind` (`MoveInfo+0x50`) and its +0x42 is
  `foot_sound` (`MoveInfo+0x52`). When that foot sound is not 0 it is stored to character
  `+0x580`; otherwise the map's +0xD4 value is used.
- +0xD4: int, the in-water flag. It triggers the ripple effect `足波紋` and halves the walk speed
  when the water is more than 10 deep.
- +0xE0: vector, the water-surface point. It is passed to `SetScriptVect1`, and its y (+0xE4) is
  compared with the character's y.
- +0xF0: int, and +0xF4: float. When the int is set and the float is below -2.0, the splash
  effect `足水パシャ` plays.
- +0x60, +0x70 (`CCPoly`?), +0xC0 and +0x100 are copied as blocks only.

## Functions
- Global (in the header): EditOnGround, IsWalkMode, EditControlInit, EditControlStatusInit,
  EditControl, GetFootEffName, EditMoveChara, EditCameraControl, CancelEyeViewMode,
  ResetViewMode, EditStepChara, EditDrawShadowChara, EditDrawChara, EditDrawEffectChara.
- GetFootEffName has no caller outside the unit but is not local, so it is global.
- LOCAL in retail (`static` in the .cpp): GetUserData, CharaControl, CameraControl,
  InitEyeCamera, EyeCamera, InitLadder, EndLadder, LadderControl.
- GetUserData returns `GetSaveData() + 0x1D2A0`, or null when there is no save data.
  CameraControl adds 0x7F30 to the result and passes it to `LoopTakePhoto` as a
  `CInventUserData*`, so the result is probably the save's `CUserDataManager` (unverified).
- Return types: EditOnGround returns 0/1 (`sltu`/`xori`), declared `int`. EditControl always
  returns 0 (`int`). GetFootEffName returns `name[name_id[kind]]` (its two function-local
  static tables), or 0 when kind is outside 0..29 (`char*`).
- EditCameraControl's third parameter `float (*)[4]` is a single point to look at, or null.
  The code reads `(*p)[0..2]`, and pbuggy passes the address of a `float[4]`.
- EditStepChara/EditDrawShadowChara/EditDrawChara/EditDrawEffectChara run over the player
  (`scene+0x2E50`) and characters 8..63. EditStepChara also steps 0x78..0x7B. The draw passes
  split on `CScene::GetType(1,i) == 4`: types other than 4 use draw mode 1 and type 4 uses
  draw mode 2.
- Virtual calls on the character (`CCharacter2`) are made by vtable offset: 0x10 SetPos,
  0x18 GetPos, 0x24 GetRot, 0xB0 set motion (name, mode), 0xB8 set motion speed, 0xC0 get
  motion speed, 0x8C current motion name, 0xD4 called after a motion reset. These names are
  inferred, not verified. Camera vtable at `+0x60`: slot 0x1C gives back the camera kind,
  and 1000 is the edit follow camera (`CCameraControl`). Slot 0x8 is called with -1.

## Enums (declared in the header)
- `EditViewMode` (global `ViewMode`): 0 walk, 1 eye view (pad button 6), and 2 photo
  (button 0x33, which calls `StartTakePhoto`). See CameraControl.
- `EditLadderMode` (`LadderMode`): 0 none, 1 when the map event flag 0x20 fires (got on at
  the bottom), and 2 when flag 0x40 fires (got on at the top). See CharaControl ->
  `InitLadder(mode,...)`. InitLadder sets `StdPos` to the bottom position for mode 1 and to
  the top position otherwise.
- `EditCharaMotionMode` (`CharaMotionMode`): 0 free, and 1 landing. The landing motion is
  set with mode 6 for `CharaMotionModeCnt = 20` frames when `hard_landing` is set.
- `LadderStep` is a state counter for the LadderControl switch, with values 0..4 or more.
  Its values are not yet named.

## Globals (all LOCAL in retail, so they go in the .cpp as `static` and not in the header)
- .sbss ints: LadderMode, LadderStep, CharaMotionMode, CharaMotionModeCnt, CharaFallFlag
  (frames without ground, capped at 3), CharaAngleTargetFlag, CharaAngleTarget,
  FixCameraFlag, FixCameraChgCnt, EyeViewCancelOnce, ViewMode, InitEyeViewFlag, ShutterCnt,
  move_chara, LdrSound, LdrBtmFoot, LdrTopFoot (foot-sound ids).
- .sbss floats: viewAngleH, viewAngleV (eye-view yaw/pitch), AddProj, LdrNext(?), LdrRot
  (`atan2` of the ladder direction + pi), and OldMtnRate.
- `LadderCamera`: `mgCCamera*` from `CScene::GetCamera`.
- Function-local statics (each with a compiler-generated initialization guard):
  `HamonCnt` (`static float HamonCnt = 0.0f`, the ripple timer in EditMoveChara), `reference`
  (`static float reference = 30.0f`, in EditCameraControl) and `camera_dist_mode`
  (`static int camera_dist_mode = 0`, in EditCameraControl).
- .bss: `MoveInfo` is a `MoveCheckInfo` (0x110), memset by `__sinit` and EditControlInit.
  `LadderData` is a `CSceneEventData` (0xD0), memset by `__sinit` and copied in by InitLadder.
  `OldFixCameraPos`, `OldCameraPos`, `LdrPos`, `StdPos`, `LdrBottomPos`, `LdrTopPos`,
  `LdrTopWalk` and `LdrCamPos` are `sceVu0FVECTOR`s.
- `__sinit_editctrl_cpp` only memsets `MoveInfo` and `LadderData`, so both types have inline
  constructors that zero them.
- Rodata: `GetFootEffName`'s function-local `static char *name[4]` = {null, `足砂煙` (sand),
  `足水パシャ` (water splash), `足芝生` (grass)} and `static EditFootEffect name_id[30]`, which maps
  a ground kind to an index into `name`: sand at ground kinds 7, 8, 13, 14 and 16; water at 11,
  18 and 22; grass at 1; all others none. Retail pads the 0x78-byte index table with eight bytes.
  The standing motion `立ち`, run motion `走り`, ripple effect `足波紋` and the `CEditMap` class
  name tested with `strcmp` are inline literals, as are the camera strings and ladder motion
  strings; the effect-scale and camera-distance aggregates are local initializers.

## Source status and forms

Every function is native; the unit has no `NONMATCHING` guards, `INCLUDE_ASM` gaps, or data
markers.

`MoveInfo` uses a small derived type (`InitializedMoveCheckInfo`) whose constructor clears the
`MoveCheckInfo` base. `LadderData` uses its native `CSceneEventData` constructor. Together they
emit retail's 60-byte `__sinit_editctrl_cpp` and keep the 0x110 and 0xD0 BSS sizes. In
`EditMoveChara`, binding `MoveInfo` to a `MoveCheckInfo&` before passing it to `MoveCheck` keeps
the retail argument setup order; taking the derived object's address directly schedules three
argument instructions differently.

`CameraControl` passes the `CCameraControl *camera` directly to `EyeCamera`; `EditControl` sets
`camera_pad = NULL` without a cast. The `(mgCCameraFollow *)`/`(CCameraControl *)` casts on
`CScene::GetCamera` results in `ResetViewMode` and `CameraControl` are downcasts.
