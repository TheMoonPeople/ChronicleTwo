# fishingobj notes

Fishing tackle physics (Verlet-style point masses + distance constraints). No first-game
counterpart (DC1 has no fishingobj/CFishObj).

## Status

Every function in `ps2/src/fishingobj.cpp` is native, including `GetTriPose`, `RodStep`,
`FishBattle` and the static initializer `__sinit_fishingobj_cpp`. The unit carries no
`INCLUDE_ASM`, `NONMATCHING`, `INCLUDE_RODATA` or `INCLUDE_BSS` markers.

`GetTriPose` copies the triangle points before constructing three orthogonal
axes. Absolute values in `axes[0..2]` choose destination rows (after `fptosi`);
their signs reverse the corresponding normalized rows. The first direction is
point 1 minus point 0, the third is the triangle normal, and the second is their
outer product.

## FISH_POINT (0x30, invented name)
pos 0x00 / old_pos 0x10 / velo 0x20, all sceVu0FVECTOR (copied with lq/sq).
MovePoint: old_pos = pos; pos += velo; pos.y -= 0.6. Correct: velo = (pos - old_pos) * k.
Same layout used by static arrays: LinePoint[64] (0xC00), RodPoint[5] (0xF0), LurePoint[3]
(0x90), FlyingPoint, FishPoint (0x30 each). Line index 0x3F = line end (hook pos, read by
GetHariPos: LinePoint+0xBD0/0xBE0 = [0x3F].pos/.velo), 0x3C = float attach (GetUkiPos,
+0xB40/0xB50). PullUki subtracts from LinePoint[0x3F].velo.y (+0xBF4).

## CFishObj (0x3D0)
Size: LureObj/UkiObj/HariObj .bss extents and `memset(.., 0, 0x3d0)` in __sinit / InitLureObj.
- 0x000 s32 point_num (MovePoint/FloatPoint/Correct loop bound; 5 lure, 4 uki, 3 hari)
- 0x010 FISH_POINT point[8] (stride 0x30; 0x10..0x190; 0x4..0xC is alignment padding)
- 0x190 s32 bind_num (BindStep loop; 6 lure, 6 uki, 3 hari)
- 0x194 FISH_BIND bind[18] (stride 0x10): +0 point0, +4 point1, +8 rate (0.5), +0xC length
  (mgDistVector of the two points). BindStep calls BindPosition(point0, point1, length, rate);
  BindPosition moves point0 by (1-rate) of the error and point1 by rate.
- 0x2B4..0x2C0 unk_2b4: never touched. Bind count 18 is inferred only from the space; the
  real array length (and what fills 0x2B4) is unknown.
- 0x2C0 s32 float_num (2 lure, 3 uki, 0 hari)
- 0x2C4 FISH_FLOAT float_info[16] (stride 0x10; 16 fills to 0x3C4, rest is tail padding to
  16-byte alignment): +0 point0 (velo.x/z *= 0.3, velo.y += buoyancy*t), +4 point1,
  +8 unk_8 (written 0 by InitLureObj/InitUkiObj, never read), +0xC buoyancy (2.5 lure,
  1.6 uki). Both pointers are dereferenced as points (point0+0x20 = velo).
No vtable. The inline default constructor is `memset(this, 0, sizeof(*this))`; the three
static instances emit retail's 80-byte `__sinit_fishingobj_cpp`.

## Globals (all LOCAL in retail -> static in the .cpp, not in the header)
.sbss: WaterLevel f, LineTop s32 (first paid-out line index, 0x3B = shortest, 0 = longest),
LineTopDist f (length of the top segment, 0..5), CastingLureFlag, CastingLureTime (frames of
flight, CastingLure return), AddLineSpeed, BattleFlag, BattleLineDist f (line length during
battle), ShowHari, LureLessFlag (InitLureObj with no lure), NowMode (FishingMode),
NowFishSpeed, NowFishRot (float: interpolated as an angle, passed to sinf/cosf),
ActionChanceNextCnt, ActionChanceCnt, ActionChanceDir.
.bss: RodPoint[5] FISH_POINT (tip is entry 4, preceding mass entry 3), RodPointDist
FISH_ROD_SEGMENT[5] (0x10 stride: +0 rest length to previous point, +4 stiffness 0.3..1.0,
+8 damping 0.2.., +0xC untouched), SaoFrame mgCFrame*[8] (frames "sao", "sao2".."sao7",
"ito" of the rod model), SaoDist float[8], LinePoint[64], LurePoint[3], FlyingPoint,
FishPoint, CastingPoint, ReleasePoint, BattleStartPos (vectors), LureObj/UkiObj/HariObj
CFishObj, ChanceBarPos. SaoFrame[7] (0x1F5D60C) world pos is the rod tip used by
InitLureObj/InitUkiObj.

The `CFishObj` statics must be declared in retail order `LureObj`, `UkiObj`, `HariObj`:
the order fixes the three relocation targets of the static initializer.

Rodata: the rod-frame strings are "sao", "sao2".."sao7", "ito" (not "sao1"/"sao8");
"obj1" is the lure model frame and "fish_juji" the action-chance texture. All are
inlined at their uses. The signed pose-axis triplets are `TriAxis` aggregate
initializers at their uses (`{0, 1, 2}` lure, `{-1, 2, 0}` float, `{-1, 0, 2}` hook);
the struct is 12 bytes and the 4-byte zero alignment gap after each is emitted by MWCC.

## Functions
Local (static, not in header): GetActiveHariObj (LureObj when NowMode==2 else HariObj),
GetActiveUkiObj (NULL when mode 2 else UkiObj), GetTriPose, GetNextChanceCnt (rand()%80+60),
BindFishObj, BindPosition (symbol BindPosition__FPfPfff, map name has __2 suffix), ParaBlend.
RodStep's retail symbol is `RodStep__FP6CSceneP1`: the second parameter mangles as `P1`,
which is u_long128* (same as `__nw__FUiP1` in mg_memory.hpp). The caller passes a stack
buffer which RodStep uses as CCPoly* for GetColPoly/CheckHit/Correct. Declared as
`RodStep(CScene*, u_long128*)`.
InitRodPoint's first frame parameter is not read (caller passes the frame the rod is
SetReference'd to); named `reference`. InitUkiObj ignores all parameters.
Return values: ExtendLine 1 full length / -1 shortest (or battle line < 20, which ends the
battle) / 0; CatchLine 1 when reached; SetLurePose/SetUkiPose 1 when posed (0 for NULL frame
or wrong mode); InitFishBattle/EndFishBattle always 1; FishBattle always 0; CastingLure
returns CastingLureTime. CheckRodActionChance: *just = (ActionChanceCnt == 0x1C).

## Enums
FishingMode: 1 bait (sgRestartFishing default, InitRodPoint; InitSuccess calls DeleteEsa),
2 lure (item 0x12F in sgRestartFishing). SetFishingMode/GetFishingMode keep `int` for mangling.

## Source forms the match depends on
- Vector copies are `*(u_long128 *) dst = *(u_long128 *) src`; MWCC emits the retail
  `lq`/`sq` pairs without any `volatile` qualifier (GetFishPosVelo, InitFishBattle).
- InitLureObj/InitUkiObj pass bind and float endpoints as `FISH_POINT *`
  (`&obj->point[n]`, `&LureObj.point[0]`) and read distances through `->pos`; `pos` is the
  first member, so the addresses equal the former float-pointer forms.
- `ParaBlend` declares its cubic basis matrix where it is first copied (declaring it at
  function entry changes the instruction order) and declares the uninitialized geometry
  matrix after the basis to keep retail stack order. The homogeneous powers vector is
  initialized where it is first used.
- `DrawFishingLine` and `DrawFishingActionChance` construct local `mgCDrawPrim` builders
  after computing the rod and fish endpoints; declaring their screen-coordinate arrays after
  the builders retains retail stack placement.
