# pbuggy: reverse-engineering notes

`sgInitBuggy` is accepted native C++ with one scoped placement row for
`CEffectScriptMan`. Its natural constructor initializes the embedded sprite
without source-level virtual-table writes. No `NONMATCHING` guards or assembly
fallbacks remain in this unit. See
[placement conversion](../satansfiddle/placement-new.md).
All BSS reservations have native definitions. Six data reservations remain:
`at_1074__4__DATA` and `at_1193__DATA` preserve the retail vector layout,
while `at_956__3__DATA`, `at_961__4__DATA`, `at_962__4__DATA`, and
`at_964__3__DATA` preserve named string symbols used by native code.
Replacing the first vector with a natural initialization changes instructions
in `CharaControl`; replacing the second changes instructions in `BuggyControl`.
Its scene character slots 0x40-0x46 are named by `BuggySceneChara`. Because
native code now uses the texture-block slots and `WorkBuff`, they are `static`
like every other data object here, matching retail's LOCAL bindings; their
earlier external definitions only kept storage emitted for the assembly body.

Buggy sub game (sub game 3 in `subgame`'s dispatchers `sgInitSubGame`, `sgLoopSubGame`,
`sgDrawSubGameChara`, `sgDrawSubGameEffect`, `sgDrawSubGameCharaShadow`, `sgDrawSubGameSystem`).
The player drives a buggy with a gun and bombs and defends a train.

`CharaControl(CScene*, CPadControl*)` is supplied by matching native C++.
`InitBomb(CScene*)` uses the verified native body with the floating-point
calibration described below. The dated validation below predates the native
construction promotion of `sgInitBuggy`.

## Types
- The unit owns no classes (`class_units.tsv` has no `pbuggy` rows) and declares no structs.
- `SubGameInfo` (owned by `subgame`) is forward-declared in `pbuggy.hpp`. Fields used here:
  `+0x0` scene, `+0x4` first texture block (`BuggyTexb` = it; Porcuss +1, Muccho +2, Bomb +3,
  Starbull +4, GunEff +5, Sys +6, Effect +7), `+0x8` number of texture blocks to delete
  (`DeleteBlock(info->unk_4 + i)` loop in sgInit/sgExit). Worth naming in `subgame.hpp`.

## Header contents
Only the 7 `sg*Buggy(SubGameInfo*)` entry points are global; all return `int`
(Ghidra `undefined4`/`long`, m2c `s32`; callers store it as the dispatcher's result).
- sgInitBuggy: 0 on any load failure, 1 on success.
- sgExitBuggy: 0 if the scene's player character (`GetCharacter(scene->+0x2E50)`) is null, else 1.
  Deletes charas 0x40..0x67, effect slot 7, stops BGM 0, closes `PolVoice`.
- sgLoopBuggy: 1 after the end fade completes (`RunEvent(RunEventNo)` then `sgExitBuggy`), else 0.
- sgDraw/sgEffectDraw/sgDrawShadow/sgSystemDraw: always 1.

## File-local (static in retail; belong in the .cpp, not the header)
All other functions are LOCAL in `local_symbols.tsv`: `CharaControl(CScene*, CPadControl*)`
(retail suffix `__3`; same-named statics exist in other units), `InitBuggy`, `BuggyDamage(int)`,
`PlayBuggyLoopSe(CScene*, int)`, `BuggyControl`, `InitBomb`, `TakeBombCheck`, `TakeBomb`,
`ThrowBomb(float*)`, `BombBomb`, `NowPutBomb`, `BombControl`, `BombCheck`.
Return types: TakeBombCheck/NowPutBomb `BombStatus == 3`; TakeBomb sets 4 and returns the check;
BombBomb `BombStatus == 6` (zeroes BombVelo, BombCount=0, BombHitObj=1); ThrowBomb returns 1.
Likely `int`/`bool`; confirm from asm when writing bodies.

Every data symbol is LOCAL too, so the header has no `extern`s. Data (gp = 0x3846F0):
- `.sbss` chara pointers (`CCharacter2*`-like, vtable calls): BuggyChara 0x40, PorcussChara 0x41,
  MucchoChara 0x42, BombChara 0x43, StarbullChara 0x44, GunFireEff 0x45, GunHitEff 0x46
  (scene chara slots). `+0x70` is the chara's root `mgCFrame*`.
- Texture block ints: BuggyTexb..SysTexb, EffectTexb (`EffectTexb__2`), EffectTexbNum (=5).
- EffectMan (`EffectMan__2`): `CEffectScriptMan*` (new 0x1190, assigned as scene effect 7).
- EffectBuff (.bss 0x30): `mgCMemory` (Init in `__sinit`, SetHeapMem 20000 bytes).
- PolVoice (.bss, extent 0x20, referenced size 0x14): `sgCPlayVoice` (Close/SetVol; `__sinit`
  zeroes +0, +8, sets +0xC/+0x10 = 1.0f).
- WorkBuff (`u8 *`): `new[] 160000` buffer. BuggySndID: `sndLoadSound` id (-1 if none).
- RunEventNo (`RunEventNo__2`): -1, then 0x1F7 when BuggyHP <= 0, 0x1F6 when TrainHP <= 0.
- BuggyHP (.sdata int, init 1, set 3 in InitBuggy; decremented in BuggyDamage),
  BuggyHPf (float, init 3.0, eases toward BuggyHP by 0.05/frame in sgSystemDraw; gauge = /3),
  TrainHP (float, init 1.0; gauge width 173*TrainHP).
- BuggyVelo, BombVelo, StarbullPos (.bss 0x10 each): float[4] vectors.
- GunFireEffDraw/GunHitEffDraw: frame countdowns for sgEffectDrawBuggy.
- Function-local statics: `test_1254`, `init_1255` (BuggyControl), `reload_cnt_1350` (BombControl).

## State values seen (no names established)
- CharaStatus: 0..4 cycle in CharaControl (0->1->2->3->4->0).
- BuggyStatus: 0, 1, 2 (damage; BuggyDamage ignored while 1), 3. BuggySidePos: 0/1 toggled in state 1.
- BombStatus: 1->2->3 (InitBomb sets 3; held/placed), 4 (taken), 6 (thrown), 7 -> 1.
An enum for these, if wanted, belongs in the .cpp since all users are file-local.

## First game
No counterpart in `/home/adubbz/development/chronicle`.

## Bomb initialization calibration

`InitBomb__FP6CScene` marks the bomb available, activates its scene object,
positions the bomb and Starbull character, sets Starbull's rotation to
`(0.0f, pi, 0.0f)`, and starts its motion.

The verified MWCC 3.0 row selects `pbuggy.cpp`, `InitBomb__FP6CScene`,
`binary32`, IEEE bits `0x40490fdb` (the float pi literal), and
`evaluate_first: true`. It restores the retail order of the two differing
instructions in rotation setup. The selector uses the mangled function and
literal bits, with no occurrence indices or source edits.

Validation used the full production mwccgap wrapper, normal section fixup,
and the canonical object checker. All function bytes and resolved relocations
match. The earlier unit comparison had two `PolVoice` alignment-tail issues
(size 0x14 versus a 0x20 retail extent); the verified generic BSS padding now
handles that tail without enlarging the class. Merged surrounding promotions
need a fresh whole-unit comparison. The calibration's native body is preserved.

See [MWCC matching notes](../../../../docs/MWCC.md) for the compiler-state
rationale and verification workflow.

## Mid-day CharaControl promotion (2026-10-08)

`CharaControl__FP6CSceneP11CPadControl__3` occupies retail address
`0x00319DB0`, extent `0x9B0`; the native body is `0x9AC` followed by four
zero alignment bytes. m2c through `decompile.sh` confirms the movement,
pickup, carrying, throwing and camera logic. The function returns without
work for a missing pad, player or control camera. Pickup occurs when the
animation crosses frame 15; throwing occurs when it crosses frame 44.
The direction and throw vectors retain their SDK vector types, and the
placed bomb contributes 16 `CCPoly` entries through `CreateCharaCPoly`.

`BuggyCharaState` names the five observed character states: free movement,
pickup start, pickup animation, carrying and throwing. `BuggyBombState`
names reload start (1), reloading (2), placed (3), carried (4), thrown (6)
and exploding (7), as established by this function and the existing bomb
control analysis. Their integer storage globals retain their existing types.

The ten-word initial difference has three independent causes:

- Four words at `+0x7B8..+0x7D4` prepare collision radius 1.0f before
  height 20.0f; retail prepares height first.
- Four words at `+0x83C..+0x84C` reverse the reload-start position's
  height 134.0f and depth -340.0f. The exploding-state call needs the
  opposite schedule despite using the same coordinates.
- Two words at `+0x928/+0x930` prepare the bomb vector before the null
  pad. Passing `&bomb_position`, the declared pointer-to-vector type,
  restores their order without a cast.

The reload-start branch resets the player's world transform through an
`mgCObject` reference. `CCharacter2` inherits the object interface through
`CObjectFrame` and `CObject`; the reference preserves virtual dispatch and
uses the same vtable slots with no pointer adjustment. Both reset calls
use this reference. The exploding branch retains its character interface.
This gives the two position calls distinct real mangled callee identities.
An initialized pointer view instead swaps the player's and camera's saved
registers throughout the function (55 words); a scoped object reference
preserves their retail allocation.

Three accepted binary32 evaluate-first rows use compiler function name
`CharaControl__FP6CSceneP11CPadControl` (without the manifest's local `__3`
disambiguator):

| IEEE bits | Callee | Purpose |
|---|---|---|
| `0x41A00000` | `CreateCharaCPoly__FP6CCPolyiPfPfff` | Prepare collision height 20.0f first. |
| `0x00000000` | `SetPosition__9mgCObjectFfff` | Preserve zero's order in the reload-start transform reset. |
| `0xC3AA0000` | `SetPosition__9mgCObjectFfff` | Prepare depth -340.0f before height in that reset. |

No occurrence or address selector is used. The nested-call selectors are
unnecessary here: the source interface boundary supplies an existing
callee identity. The character-typed sibling call retains the default
policy. Function-wide coordinate policies leave at least four differing
words; named coordinate locals, assignments and double literal spelling
also leave those four under the private collision-height policy.

CharaControl is native and exact: body `0x9AC` within extent `0x9B0`.
The whole unit, including the native sgInitBuggy, passes complete-object checking.
