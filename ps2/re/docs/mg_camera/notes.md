# mg_camera: reverse-engineering notes

Header: `ps2/include/mg_camera.hpp`. Classes: `mgCCamera` (0x70), `mgCCameraFollow` (0xC0),
enum `mgCameraKind`. First-game counterparts: `CCamera` (`camera.hpp`) and `CCameraFollow`
(`camerafollow.hpp`) in the first game's decompilation.

## mgCCamera (size 0x70)
Size: `__nw__FUiP1(0x70, ...)` before `__ct__9mgCCameraFf` in `TitleBootInit__Fv`; derived fields
start at 0x70. The vectors are `sceVu0FVECTOR` (16-byte aligned), which pads the class to 0x70.

| Off | Field | Evidence |
|---|---|---|
| 0x00 | `pos` | SetPos writes 0x0..0xC (w=1.0), GetPos copies, Step moves it towards 0x20 |
| 0x10 | `ref` | SetRef writes 0x10..0x18, GetRef copies; GetDir = ref - pos |
| 0x20 | `next_pos` | SetNextPos/GetNextPos; SetPos also writes it (w=1.0 at 0x2C) |
| 0x30 | `next_ref` | SetNextRef/GetNextRef; SetRef also writes it |
| 0x40 | `roll` float | SetRoll; ctor zeroes. GetCameraMatrix does NOT read it (unlike the first game) |
| 0x44 | `unk_44` s32 | ctor zeroes; generated operator= copies with lw/sw. No reader found |
| 0x48 | `pos_speed` float | ctor arg (<=0 -> 1.0); Step divides pos gap by it |
| 0x4C | `ref_speed` float | ctor copies 0x48; SetSpeed 2nd arg (<0 -> pos_speed); Step divides ref gap by max(1, it) |
| 0x50 | `angle_h` | Step: atan2f(-dx, -dz) of normalised (dx,0,dz); GetAngleH |
| 0x54 | `angle_v` | Step: -atan2f(dy, sqrt(dx^2+dz^2)); GetAngleV |
| 0x58 | `snap_range` | ctor 0.1f; Step snaps a component whose |gap| < it |
| 0x5C | `suspended` s32 | Suspend=1, Resume=0, ctor 0; Step does nothing while set |
| 0x60 | vptr | ctors store `__vt__9mgCCamera` / `__vt__15mgCCameraFollow` here (MWCC puts vptr after the first polymorphic class's data) |

`__as__9mgCCameraFRC9mgCCamera` (in dng_main) copies 0x00..0x5C (vectors as 4 lwc1/swc1, 0x44 and
0x5C as lw/sw) and not the vptr: it is the compiler-generated copy assignment, so it is not
declared in the header (declaring it would suppress generation).

Step(int): `steps < 0` copies next -> current at once; otherwise per step, per axis i in 0..2:
if pos_speed > 1 or ref_speed > 1, pos += (next_pos - pos) / pos_speed, ref += (next_ref - ref) /
max(1, ref_speed), then snap when within snap_range; else copy. Then recomputes angle_h/angle_v.
Both Step functions return immediately when `suspended` or `StopCamera` is non-zero.

GetCameraMatrix: dir = GetDir; up = (dx*dy, -(dx^2+dz^2), dy*dz, 1); normalise both;
`sceVu0CameraMatrix(m, pos, dir, up)`.

## mgCCameraFollow (size 0xC0)
Size: `__nw__FUiP1(0xC0, ...)` before `__ct__15mgCCameraFollowFffff` (MenuAquaInit, TitleBootInit,
MenuItemDebugKey); CCameraControl's own fields start at 0xC0.

| Off | Field | Evidence |
|---|---|---|
| 0x70 | `follow` | SetFollow writes x,y,z; GetFollow copies 4 floats |
| 0x80 | `follow_offset` | SetFollowOffset/GetFollowOffset; ctor mgZeroVector |
| 0x90 | `distance` | ctor arg 1; Set/Get/AddDistance |
| 0x94 | `height` | ctor arg 2; Set/Get/AddHeight |
| 0x98 | `next_angle` | ctor arg 3; SetAngle/AddAngle; Step wraps it into [0, 2pi] |
| 0x9C | `angle` | ctor arg 3; GetAngle; SetAngleSoon sets both; Step interpolates towards 0x98 with mgAngleInterpolate(angle, next_angle, max(1, pos_speed/2), 1); snapped when pos_speed < 1.1 |
| 0xA0 | `follow_on` s32 | ctor 1; FollowOn=1, FollowOff=0; when 0 Step copies angle_h into both angles |
| 0xA4..0xAF | (alignment padding before the next sceVu0FVECTOR; never accessed, not declared) |
| 0xB0 | `follow_next` | ctor zeroes 0xB0..0xB8; Step = sceVu0AddVector(follow, follow_offset); Stay copies next_ref into it; used as SetNextRef target |

GetFollowNextPos: (fn.x + distance*sinf(angle), fn.y + height, fn.z + distance*cosf(angle), 1.0).
GetFollowNext: GetFollow + mgAddVector(follow_offset) (note: uses `follow`+offset, not 0xB0).
Ctor parameter order: (distance, height, angle, speed); speed goes to mgCCamera(float).

## Vtables
`__vt__9mgCCamera` (0x37B110): Step, Suspend, Resume, Stay, GetCameraMatrix, Iam.
`__vt__15mgCCameraFollow` (0x37B0E0): Step(F), Suspend, Resume, Stay(F), GetCameraMatrix,
Iam(F), SetFollow(F) -- SetFollow is a virtual introduced by mgCCameraFollow (MenuAquaInit calls
it through vtable+0x20). The three trailing zero words are alignment padding. No destructor in
either vtable (unlike the first game).

Suspend, Resume and both Iam sit at the end of .text after every other function, the placement
MWCC gives inline functions emitted for a vtable; they are therefore defined inline in the class
body. Unverified until the vtables are emitted from C.

## Iam / mgCameraKind
Iam returns 0 (mgCCamera), 1 (mgCCameraFollow), 1000 (CCameraControl, cameracontrol unit; not in
this enum). Enumerator names are neutral (no retail names known).

## Globals
`mgCCamera::StopCamera` (.sbss 0x37CD80, 4 bytes, s32): read by both Step functions; non-zero
freezes every camera.

## Differences from the first game
No CFrame member, no destructor, no `parent` frame argument on setters, separate pos/ref speeds,
Suspend/Resume/Iam added, roll unused by GetCameraMatrix, follow camera gains `follow_offset`
and `follow_next` and a virtual SetFollow.

## Source status
Every function of the unit is native C++ and byte-identical; there are no guarded drafts,
`INCLUDE_ASM` entries or data markers. `Iam` (both), `Suspend` and `Resume` are inline in the
header and are emitted with the vtables, which `Step__9mgCCameraFi` (the first non-inline
virtual) causes MWCC to emit. The static `StopCamera` freeze flag is an ordinary C++ definition
and both camera vtables are compiler generated.
- `GetCameraMatrix`: up = (dx*dy, -(dx^2+dz^2), dy*dz, 1); retail re-loads and re-stores
  dir[0..2] right after GetDir before building `up`.
- GetFollow/GetFollowOffset are a single lq/sq: `*(u_long128 *)dst = *(u_long128 *)src`.
- mg_math functions come from `mg_math.hpp`; Step(F) passes `MG_INTERPOLATE_FRACTION` to
  mgAngleInterpolate.
