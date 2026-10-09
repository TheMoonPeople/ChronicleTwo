# cameracontrol: reverse-engineering notes

Header: `ps2/include/cameracontrol.hpp`. No first-game counterpart (Dark Cloud has no
`CCameraControl`/`CameraCtrlParam`; its nearest relative is `CCameraFollow` in
`camerafollow.hpp`, here `mgCCameraFollow` in `mg_camera.hpp`).

## CCameraControl : mgCCameraFollow (size 0x1F0)
Size: `MainCamera` (0x01ED4340) and `EventCamera__2` (0x01ED4530) are `size:0x1f0` in
`main.symbols.txt`. Last field ends at 0x1E4; the rest is 16-byte alignment padding.

Base layout (from `mg_camera.hpp`): mgCCamera fields 0x00-0x5C, vptr at 0x60 (ctor stores
`__vt__14CCameraControl` there), mgCCameraFollow fields 0x70-0xBF.

| Off | Field | Evidence |
|---|---|---|
| 0xC0 | `control_on` s32 | ctor/ControlOff = 0, ControlOn = 1; Step/Stay/SetHeight/MoveCamera branch on it |
| 0xC4 | `rot_cancel` s32 | Set/BitSet/BitResetRotCameraCancel; InitStatus = 0; MoveCamera tests bits 1,2,0x40,0x80; CopyParam copies |
| 0xC8 | `rot_back` s32 | RotBack = 1, CancelRotBack/InitStatus = 0; MoveCamera clears it when `mgAngleCmp(angle, rot_back_angle, 0.1)` == 0 |
| 0xCC | `rot_back_angle` float | RotBack arg; Step(<0) calls SetRotate(it) |
| 0xD0 | `rot_reverse` s32 | ctor = 0; MoveCamera(pad) negates the turn when set; DngMainKey sets `MainCamera.0xD0 = !savedata[0x1C5AB]` (option byte) |
| 0xD4-0xDF | padding | never accessed; InitDungeonMain copies 0xD0 then 0xE0-0xEC, skipping these |
| 0xE0 | `dir_offset` vec4 | InitStatus mgZeroVector; GetCameraMatrix adds it to (ref - pos) |
| 0xF0 | `active_param` s32 | GetActiveParam: `this + 0xF4 + active_param*0x2C`; ctor = 0. Nothing in this unit sets other values |
| 0xF4 | `param[4]` CameraCtrlParam | ctor loop 0xF4..0x1A4 step 0x2C (= 4 entries) storing +0x28 = 0 (inline ctor) |
| 0x1A4 | `default_param` | ctor `sw $0,0x1CC` (its inline ctor) and `operator=(GetActiveParam())` at the end |
| 0x1D0 | `check_ref` vec4 | SetCheckRef(float*) copies 4 words |
| 0x1E0 | `check_ref_on` s32 | ctor = 0, SetCheckRef = 1; CheckCollision/AutoMove/CheckGround use check_ref (y + follow_offset.y at 0x84) instead of next_ref when set. Nothing here clears it |

Vtable `__vt__14CCameraControl` (0x37C5A0, 0x24): 2 header words, then Step (own),
Suspend (mgCCamera), Resume (mgCCamera), Stay (own), GetCameraMatrix (own), Iam (own),
SetFollow (mgCCameraFollow). No new virtuals; same slot order as mgCCameraFollow.

Iam returns 1000 (`CAMERA_KIND_CONTROL`); declared inline in the class body like the mg
cameras' Iam (it sits at the end of the unit's .text, where inline functions emitted with the
vtable go). If it fails to emit/match there, move it out of line.

Constructor oddity: after the param loop it constructs a second `mgCCameraFollow(40,30,0,8)`
at `sp+0x20` (0xC0-byte stack object) and never uses it; the source likely had a discarded
temporary (e.g. `mgCCameraFollow(40.0f, 30.0f, 0.0f, 8.0f);`). The default limits written
through GetActiveParam are the same values `_RESET_CAMERA_CTRL_PARAM` (runscript_opcodes)
writes: 100,160,18,10,-15(height),40,-15,20,-15,25; then `no_check = 0`.

The constructor is now compiled C++ and matches all 0x120 retail bytes and its
relocations. `decompile.sh __ct__14CCameraControlFv` confirms the base constructor,
four `CameraCtrlParam::no_check` initializations, discarded temporary, active
parameter defaults, `InitStatus`, and copy to `default_param`. m2c's offset
labels for the vtable and field stores are inaccurate because it loses the
class layout; the header layout and retail disassembly resolve those stores.
Both `mgCCameraFollow` calls use plain float literals. The Satan's Fiddle
profile evaluates binary32 positive zero first within
`__ct__14CCameraControlFv`, producing retail's argument load order without
source-level double-to-float casts. The complete unit matches all 0x150C
bytes and 128 relocations with this policy.

### Control (nested struct, size 0xC)
MoveCamera(CPadControl*) builds it on the stack: +0 `rot` (analog 6 * -0.05, or +/-0.05
from buttons 3/2, negated by rot_reverse), +4 `height` (analog 7 * -2.0), +8 `rot_back`
(button 4 or 1). With pad == NULL all zero.

### Behaviour notes for MoveCamera(Control*)
- next_ref = follow + follow_offset; horizontal delta to next_pos is pushed in/out to
  [min_dist, max_dist]; turn angle scaled by `min_dist / min(dist, min_dist)`.
- `height += control->height`, clamped to [min_height, max_height]; with no height input it
  drifts 1/20 per step back into [rest_min_height, rest_max_height].
- delta.y = lerp(near_height, far_height) by (dist - min_dist)/(max_dist - min_dist);
  next_pos.y = next_ref.y + height, then next_pos += delta.
- rot_back request (unless bit 0x40) -> RotBack(rot[1] - PI) (`rot` is the player's rotation
  vector; [1] is the Y angle).
- Unless `no_check`: CheckGround, then CheckCollision, and AutoMove only when no turn input
  and bit 0x80 clear.

## CameraCtrlParam (size 0x2C)
Size from the param array stride and the 11-word copy in `__as__` (editloop 0x1ACEE0) and
CopyParam. All fields float except +0x28.

| Off | Field | Evidence |
|---|---|---|
| 0x00 | `min_dist` | SetFixDist; MoveCamera lower distance clamp |
| 0x04 | `max_dist` | SetFixDist; upper clamp |
| 0x08 | `near_height` | SetFixHeight; lerp start |
| 0x0C | `far_height` | SetFixHeight; lerp end |
| 0x10 | `height` | ControlOn/SetHeight/MoveCamera write; *not* written by SetFixHeight |
| 0x14 | `max_height` | SetFixHeight; clamp; CheckGround upper probe `ref.y + max_height + 20` |
| 0x18 | `min_height` | SetFixHeight; clamp; CheckGround lower probe `ref.y + min_height - ground_space` |
| 0x1C | `rest_max_height` | SetFixHeight; drift target |
| 0x20 | `rest_min_height` | SetFixHeight; drift target |
| 0x24 | `ground_space` | CheckGround: eye kept this far above floor hit; default 25 |
| 0x28 | `no_check` s32 | inline ctor = 0; fishing UkiWaitLoop sets 1 after SetFixHeight(100)/SetFixDist(80); MoveCamera skips ground/wall checks when non-zero |

`CameraCtrlParam::operator=` has an optional retail declaration under
`CAMERA_CONTROL_USE_RETAIL_ASSIGNMENT` in `cameracontrol.hpp`;
`cameracontrol.cpp` enables it for its assignment callers. Other includers
use the implicit operation. The retail out-of-line body at 0x1ACEE0 is
currently an `INCLUDE_ASM` gap in `editloop.cpp`, with no explicit C++ body.
It copies the ten scalar float limits and the integer `no_check` field.

## Enums
- `CameraRotCancel`: bits seen in MoveCamera (1 buttons, 2 analog, 0x40 rot-back, 0x80
  auto-move). Callers elsewhere pass 0, 1, 0x80 and variables (event_func `_CTRLC_SET_ROT_CANCEL`,
  dng_main, fishing, editctrl); no other bit seen tested in this unit.
- `CameraControlKind`: 1000 from Iam.

## Data
- `at_396__3` (.data, 0x3613A0): {0,0,0,1.0f} vec4 literal (used as SetCheckRef(fff)'s w).
  Compiler-generated, not declared.
- `at_373__3` (.bss, 0x10): function-local static vec4 used in SetRotate as the base of the
  offset vector (x/w read from it); compiler-generated, not declared.
- No named globals in this unit. `MainCamera`/`EventCamera__2` are dng_main's.

## Other details
- CheckGround reads CCPoly entries with stride 0x50 and the normal at +0x30
  (`sceVu0Normalize(polys[hit].+0x30)`); floor accepted when normal.y > 0.5, ceiling when
  normal.y < -0.5; up to 0x20 hits via CheckHits(sort=1).
- AutoMove rotates the eye offset by +/-0.016362462 rad per try, up to 32 tries each way,
  using CheckHitsPipe (radius 4.0 in w); returns 1 if clear (or already clear), else 0.
- CheckCollision pulls next_pos to 5 units in front of the wall hit; snaps pos too when the
  pull exceeds 5 units.
