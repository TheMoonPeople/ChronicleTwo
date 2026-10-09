# Fishing tackle simulation

`fishingobj` owns the fishing rod, the paid-out line, the cast endpoint, and three deformable tackle objects. Its point masses store the current position, prior position, and velocity as four-float vectors. The line has 64 points; `LineTop` is the first paid-out point, with 59 the shortest usable index. Point 63 is the hook or lure attachment, and point 60 carries the float. The top segment has length `LineTopDist`; all following segments have length 5.0.

## Types and state

- `FISH_POINT` is 0x30 bytes: `pos`, `old_pos`, then `velo`. `CFishObj::MovePoint` copies current to old, adds velocity, then subtracts 0.6 from height. The old position is later used to rebuild velocity.
- `FISH_BIND` is 0x10 bytes: two point pointers, a correction share, and a rest length. `BindPosition` subtracts `(1-rate)` of the length error from the first point and adds `rate` to the second.
- `FISH_FLOAT` is 0x10 bytes: two point pointers, an unused stored word, and buoyancy. The first point gets horizontal damping and upward acceleration according to the pair's depth in water.
- `FISH_ROD_SEGMENT` is 0x10 bytes: rest length, stiffness, damping, and an untouched final word. Five entries correspond to the rod's five point masses.
- `CFishObj` is 0x3D0 bytes. It holds at most eight points, eighteen constraints, and sixteen float pairs in the currently mapped storage. Observed object counts are 5/6/2 for the lure, 4/6/3 for the float, and 3/3/0 for the hook. The maximum array counts are storage extents rather than proven gameplay limits.
- `RodPoint[5]`, `LurePoint[3]`, `FlyingPoint`, `FishPoint`, and `LinePoint[64]` share the `FISH_POINT` layout. `SaoFrame[8]` points at the rod joints named `sao`, `sao2` through `sao7`, and `ito`. `SaoDist` records each joint's distance from the first joint.

## Line and casting

| Function | Observed behavior |
| --- | --- |
| `SetFishingMode`, `GetFishingMode` | Set and read bait mode 1 or lure mode 2. |
| `SetWaterLevel`, `GetWaterLevel` | Set and read the water height. |
| `GetActiveHariObj`, `GetActiveUkiObj` | Choose lure versus hook and suppress the float in lure mode. |
| `ExtendLine` | Changes paid-out length; returns 1 at full length, -1 at minimum, otherwise 0. In battle, a length under 20 ends the battle. |
| `GetNowLineLength`, `GetMinLineLength` | Return the current line length and the constant minimum of 25. |
| `InitRodPoint` | Clears the point arrays, finds the eight rod joints, spaces five rod points between the first joint and tip, and resets line and mode state. Its first frame argument is unused in the retail body. |
| `GetTriPose` | Builds three orientation axes from a triangle of points, with signed axis indices selecting and flipping the results. |
| `GetHariPos`, `GetUkiPos`, `GetFishPosVelo` | Copy out the position and velocity of line point 63, line point 60, or `FishPoint`. |
| `PullUki`, `SetShowHari`, `GetShowHari` | Tug the line endpoint downward and control hook visibility. The hook is hidden more than 3 units below the water. |
| `SetLurePose`, `SetUkiPose` | Put models at the line attachments and build orientation axes from the simulated lure, float, or hook triangles. |
| `CastingLure`, `EndCastingLure` | Set a ballistic flight from line point 63, or clear its active flag, duration, and line speed. |
| `CatchLine` | Move the endpoint toward a target by at most a given distance and reset its velocity and attached tackle point. |
| `SlowLineVelo`, `ResetLineVelo`, `ResetLine` | Dampen, gather, or vertically lay out the paid-out line and attached tackle. |

## Battle, constraints, and drawing

| Function | Observed behavior |
| --- | --- |
| `GetNextChanceCnt` | Return a random wait in the range 60 through 139. |
| `InitFishBattle`, `EndFishBattle` | Start the fish at the hook and initialize line length and chance counters, or clear battle and chance flags. |
| `CheckRodActionChance` | Compare rod direction to the active prompt; return 1 for matching, -1 for opposing, or 0. `just` is true at counter 28 for a neutral direction. |
| `FishBattle` | Choose a swim heading around the player's facing direction, maintain directional chance prompts, move the fish at speed 8 near water height minus 10, and query scenery collisions. |
| `BindFishObj` | Repeat four constraint passes across the paid-out line and active tackle, pinning its first point to the rod tip on each pass. |
| `RodStep` | Advance the rod, paid-out line, cast, and tackle, then resolve water, line, ground, and fish interactions in one frame. |
| `BindPosition`, `CFishObj::BindStep` | Enforce one distance constraint or all constraints of an object. |
| `CFishObj::FloatPoint` | Add buoyancy to partially submerged pairs and damp submerged points. |
| `CFishObj::Correct` | Sweep vertically between old and current heights, lift a point above hit ground, and rebuild damped velocity. |
| `DrawFishingLine` | Draw the line as separate screen-space segments, fading submerged endpoints; in battle draw one segment to the fish. |
| `DrawFishingActionChance` | Project the fish-to-rod span onto the water and draw a directional `fish_juji` sprite there. |
| `InitLureObj`, `InitUkiObj` | Build point shapes, rest-length constraints, and buoyant pairs for lure, float, and hook. |
| `ParaBlend` | Interpolate four adjacent samples with a cubic basis matrix, clamping sample indices at both ends. |
| `__sinit_fishingobj_cpp` | Zero the three `CFishObj` instances during static initialization. |

The assembly reference uses hard-coded signed orientation axes `{0,1,2}` for the lure, `{-1,2,0}` for the float, and `{-1,0,2}` for the hook. The `fish_juji` sprite has left and right UV spans selected by `ActionChanceDir`. The interpolation basis is the four-row matrix `[-1,3,-3,1]`, `[2,-5,4,-1]`, `[-1,0,1,0]`, `[0,2,0,0]`, scaled by one half after multiplication.

The guarded C++ drafts now cover every game function in the unit and the static initializer. A function remains supplied by `INCLUDE_ASM` until its retail object comparison reaches zero. The battle and rod step drafts use the named `CScene`, `MoveCheckInfo`, `mgCFrame`, `FISH_POINT`, and `FISH_ROD_SEGMENT` members. Their detailed disassembly and m2c listings are retained in the per-function records under `ps2/re/functions/fishingobj`.

## Rod step sequence

`RodStep` pins the rod’s first two masses to model joints, advances the cast endpoint, integrates the remaining rod, line and tackle points, solves the rod twice, then enforces either the battle attachment or the line and tackle constraints. It next builds seven flexible rod joint transforms from the five point curve, queries nearby collision triangles, corrects the line against ground, applies cast end velocity, resolves tackle collision, and applies water lift and buoyancy. The line query bounds enclose all paid-out line points and expand by 20 in each spatial axis. Collision triangles whose `area_kind` is 7 receive ignore-mask bit 8 before correction.

`FishBattle` reads the player’s position and rotation, chooses a random heading around their facing direction, and changes that heading during a directional action chance. It constrains the fish to water height minus 10, moves at speed 8 through `MoveCheck`, and queries polygons within 100 units of its position. `NowFishRot` is a float; it is interpolated as an angle and passed to `sinf` and `cosf`.
