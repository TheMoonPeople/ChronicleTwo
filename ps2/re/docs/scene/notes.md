# scene: reverse-engineering notes

`CScene::Initialize` resets each slot array (`chara`, `camera`, `message`, `map`, `sky`, `gameobj`, and `effect`) through its declared element type. PAL uses a separate element counter and byte-stride induction value for each loop; typed indexing currently differs only in assignment of the two saved registers.

`CScene::ClearStack` resets each assigned stack at or above an index and detaches every stack after the first. The slot is `CScene::stack[i]`; typed member indexing removes the old offset from the start of `CScene` but currently changes MWCC's loop induction code.

Header: `ps2/include/scene.hpp`. No first-game counterpart exists for any class here
(`/home/adubbz/development/chronicle` has no rain or scene-slot classes).

`CScene` itself is owned by `scenesnd` (class_units.tsv) and is NOT declared here; 59 of its
members live in `scene.cpp`. Its header must include `scene.hpp` for the by-value slot arrays
below. `__vt__6CScene` is emitted in this unit (`{0, 0, Initialize__6CSceneFv, 0}`), so
`CScene::Initialize()` is CScene's first (only) non-inline virtual.

## Free functions (all global, none in local_symbols.tsv)
- `float f_rand(float min, float max)`: `min + (max - min) * rand() / 2147483647.0f`.
- `int i_rand(int min, int max)`: `(int)f_rand((float)min, (float)max)`.
- `void InitVector(float*)`: (0,0,0,1). Also called by `pot` (CPot/CBPot/CFragment::Init).
- `float RandXYinViewArea(min_dist, max_dist, angle, float *x, float *z)`: main scene camera
  (`GetCamera(scene->+0x2e54)`), heading `atan2f(dir.x, dir.z)` + `f_rand(-angle/2, angle/2)`,
  distance `f_rand(min,max)`; x/z = cam pos + d*sin/cos; returns `d * atanf(-angleV + PI/4) + cam.y`.
- `void DrawScreenRain()`: 50 screen-space lines, length `f_rand(h/8, h/4)`, slant
  `f_rand(+-0.049087387)`, alpha 0 -> 0x20.

## CRipple (0x30)
Size: stride 0x30 in CRain loops and `__sinit_event_func_cpp`. Layout from Init/Birth/Draw:
0x0 active, 0x10 pos (sceVu0FVECTOR, aligned 16 so 0x4..0xF unused), 0x20 size (float,
f_rand(8,12)), 0x24 count (int, frames), 0x28 life (int, i_rand(20,40)), 0x2c unused.
Birth sets pos.y = 5.0 (0x14) and w = 1.0 (0x1c) after copying pos.
`Birth` returns int: early path returns 0; success path has no explicit return in the asm (it
falls out with i_rand's result still in $v0) -- write it as an int function whose success path
falls off the end without `return`. Step: 0 inactive, 1 alive, -1 on expiry (also clears active).
Draw: quad side `size*count/life`, alpha `(life-count)*40/life`; texture is a font glyph:
`GetFontNo("\x81\x9b")` (Shift-JIS circle, at_853__3) when `LanguageCode` is 0 or 1, else
`GetHalfFontNo('O')`; `GetRectFontTex`, `MySetTex`.
The draw primitive is a local `mgCDrawPrim` constructed after size and alpha
are calculated. Declaring the corner, vertex and rectangle locals after that
primitive gives the retail stack layout and a 100% PAL object match; the former
raw quadword storage and placement construction produced an oversized body.

## CParticle (0x50)
Size: stride 0x50. 0x0 active, 0x10 pos, 0x20 speed, 0x30 accel (Birth: (0,-0.5,0,1)),
0x40 base_y (= birth pos.y), 0x44..0x4F unused. Birth returns `active == 0` (int).
Step: ends (-1) when `pos.y < base_y`; else speed += accel, pos += speed, returns 1.
Draw: point, alpha `128 - dist_xz * 0.42666668` (skipped if <= 0).

## CRainDrop (0xB0)
Size: stride 0xB0, and Init's own field extent. 0x0 active, 0x4 type (RAIN_DROP_TYPE),
0x8..0xF unused, 0x10 pos[8] (trail, pos[0] = head), 0x90 speed (f_rand(-2,2), -15, f_rand(-2,2)),
0xA0 color s32[4] (Init: 0x80 x4; Birth: 0x80,0x80,0x80,0x20 for both types).
Birth(type): RandXYinViewArea(600,800,PI/4) for type 1, (110,600,PI/4) for type 0; copies head to
all trail entries. Step returns 0 inactive, -2 when y < -100, -1 when -100 <= y < 0, 1 otherwise.
Draw: lines between pos[i] and pos[i-1] for i = 7,5,3,1, alpha 8 then 16.

## CRain (0xABF0)
Size: `EventRain` (event_func) symbol size 0xABF0; array extents from Init/Draw/Start/Step.
0x0 active, 0x4 chara_no, 0x8..0xF unused, 0x10 drop[100] (type 0), 0x44D0 far_drop[50] (type 1),
0x6730 particle[100], 0x8670 ripple[200].
The constructors of all four classes are inline and just call Init(): `__sinit_event_func_cpp`
inline-loops CRainDrop::Init / CParticle::Init / CRipple::Init over EventRain's arrays, then calls
CRain::Init.
Quirks to reproduce: Draw draws only 100 of the 200 ripples. Step's near-drop loop calls
`Step()` once, on -1 copies drop pos into a local and sets its y/w (dead store), otherwise calls
`Step()` a SECOND time and on -2 clears active and re-Births(0). Far drops re-Birth(1) on -1.
Particles: on -1, looks up `GetMainScene()->GetCharacter(chara_no)`, its frame at +0x70
(`mgCFrame*`), `SearchFrame("hat")` (at_1117); breaks out of the loop if any is missing, else
spawns `ParticleBirth(pos, 1)` around the hat world position (radius 4, random angles).
Ripples: on -1 clear active, new position via RandXYinViewArea(110,600,PI/4), y = 5, Birth,
and three ParticleBirth(pos, 0). Start: ripples get y = 1.
ParticleBirth(pos, from_chara): speed (0, f_rand(0,1), 0) if from_chara == 1, else
(f_rand(-1,1), f_rand(0,2), f_rand(-1,1)); first CParticle whose Birth succeeds.
SetCharNo(-1) re-Inits every particle.

## CSceneData (0x34) and slot classes
Layout from Initialize__10CSceneDataFv and the AssignData functions:
0x0 status (u32 flags), 0x4 type (s32; CScene::SetType/GetType), 0x8 name[32] (strcpy target;
CScene::GetMapName returns &name), 0x28 tex_block (-1 initial), 0x2C tex_block_num, 0x30 stack
(mgCMemory*). The 0x28/0x2C/0x30 meanings come from sceneload `LoadMapFromMemory` step 6
(`puVar5[10..12] = info->[0], info->[0x198], memory`) and `DeleteMap` (deletes texture blocks
tex_block..+num, resets stack's +0x1C/+0x24).
Derived slots add a data pointer at 0x34 (size 0x38): CSceneMap (CMap*), CSceneMessage (ClsMes*),
CSceneCamera (mgCCamera*), CSceneSky (CMapSky*), CSceneEffect (CEffectScriptMan*).
CSceneCharacter (0x40): 0x34 chara, 0x38 texb (CScene::GetCharaTexb/SetCharaTexb; <0 means use
the scene default at CScene+0x2E70 / +0x2E74), 0x3C chara_no (SetCharaNo/GetCharaNo;
scenevillager passes it to GetVillagerInfo).
CSceneGameObj: its Initialize is a bare tail jump to `CSceneCharacter::Initialize`, so it derives
from CSceneCharacter with no fields of its own (Ghidra shows an inlined view; trust the asm).
Each derived Initialize stores 0x34 (and 0x38/0x3C for character) then tail-calls
`CSceneData::Initialize()`; AssignData calls the class's own Initialize first (except
CSceneCharacter, which does not), sets status = 0, stores the pointer, strcpy's the name (or
name[0] = 0 when name is NULL for message/camera/sky/effect), then `status |= 4`, returns 1.
Map and Character require both pointer and name; the rest only the pointer.
CScene arrays (for the scenesnd header): +0x40 count/+0x44 CSceneCharacter[128];
+0x2044/+0x2048 CSceneCamera[8]; +0x2208/+0x220C CSceneMessage[8]; +0x27E0/+0x27E4 CSceneMap[4];
+0x28C4/+0x28C8 CSceneSky[4]; +0x29A8/+0x29AC CSceneGameObj[4]; +0x2AAC/+0x2AB0 CSceneEffect[8].

## Enums
- SCENE_DATA_KIND: from CScene::GetData's jump table at_1171 (8 entries): 1 GetSceneCharacter,
  2 GetSceneMap, 3 GetSceneMessage, 4 GetSceneCamera, 5 -> NULL (default), 6 GetSceneGameObj,
  7 GetSceneGameObj. Values follow the GetScene* function order (Character, Map, Message, Camera,
  Sky, GameObj, Effect), hence names SKY = 5 and EFFECT = 7; the retail table has no Sky case and
  sends 7 to GetSceneGameObj. Callers seen: kind 1 (characters) and 2 (maps) only.
- SCENE_DATA_STATUS: 1 set when a map finishes loading (LoadMapFromMemory step 6) and by
  CopyChara; 2 = CScene::SetActive/ResetActive, IsActive tests (status & 6) == 6; 4 set by every
  AssignData. Character slots also use 8, 0x10, 0x20, 0x40, 0x200 (event / battle code) --
  meanings not established, left unnamed.
- RAIN_DROP_TYPE: 0 near (birth distance 110..600, respawn on -2), 1 far (600..800, respawn on -1).

## Data
No global data owned by the unit. All data are compiler-generated: at_853__3 (ripple glyph
string), at_1117 ("hat"), at_1171 (GetData jump table), at_1503__3/at_1504__3 (0x10-byte .data literals, not yet traced), the
noname_* "no_name" function-local defaults of the Assign* functions, and InScreenFunc's local
statics `sun_func_1518` (0x1C0 bytes, .bss) / `init_1519` (guard byte, .sbss).
# Particle point rendering

`CParticle::Draw` renders an active particle as a single untextured point.
It calculates opacity from horizontal distance to the main scene camera:
`128 - 0.42666668 * sqrt(dx*dx + dz*dz)`. It emits a point only when the
opacity is positive and the world position transforms to a drawable GS
vertex. The merged source contains a native C++ body; earlier guarded-draft
register differences are recorded below as prior comparison evidence.

## Native comparison history

In the pre-merge canonical comparison, `Initialize` resets the scene slots and battle-area state; retail's game
object loop uses `sky_num` as its bound. All seven typed slot-array loops
had the same instructions as PAL except the exchange of the counter
and scaled array-displacement saved registers. `ClearStack` clears
stack_used and lock for each existing stack from the requested index
onwards and resets later buffers; its instruction differences likewise
come from saved-register allocation. Alternative induction-variable and
dead-expression trials are not retained.

The earlier `RandXYinViewArea` guarded body was one float-add operand order from
PAL: +0xBC is `f20 = f0 + f20` in retail, while that draft used
`f20 = f20 + f0`. Source operand reversal and a no-op float cast left the
result unchanged. Keeping the random result as a multi-definition local
produced the desired operand order but exchanged f20/f21 for heading and
distance later in the function. Upstream subsequently supplied the active
native body; the earlier guarded-draft blocker does not describe its promotion
status. Canonical comparison must be repeated for the merged source.

`CParticle::Draw`'s earlier guarded body reproduced the full 456-byte instruction
shape but differed at eight register choices around opacity calculation:
retail uses v1/f2 for -0.42666668, a2/f3 for 128 and f1 for the zero
comparison; the isolated compiler used a0/f2, v1/f1 and f0 respectively.
Splitting out the fade term did not correct that trial. Upstream now supplies
an active native body, so the merged implementation needs a fresh comparison.

## Satan's Fiddle floating-point calibration

`./decompile.sh Birth__9CRainDropFi`, `ParticleBirth__5CRainFPfi` and
`Start__5CRainFv` confirm the native rain behavior: birth chooses near/far
view distances and clones eight trail positions; particle birth randomizes
velocity then claims the first free particle; start initializes both rain
groups and ripple positions. Their argument preparation is now exact with
binary32 evaluate-first selectors for 800 (`Birth`), 2 (`ParticleBirth`)
and view angle bits `0x3F490FDB` (`Start`).

The compiler propagates local floats into fresh kind-0x33 argument nodes
whose evaluation byte was uninitialized. Initializer-only selectors left
four, two and twelve instruction differences respectively. LLDB at the
MWCC 3.0 argument reader 0x4A4AE3 confirmed each propagated node retains its
source type and IEEE value. Satan's Fiddle now initializes that consumer
and applies the same TU/function/type/IEEE-bits policy there. Canonical
wrapper plus section-fixup checks recover all three functions without
source changes or new failing functions; the pre-merge check retained the
existing Initialize and ClearStack register-allocation differences. Upstream independently reported
`CRain::Start` matching in an isolated whole-image check. These results are
pre-merge evidence, not validation of the merged unit.


## Native data and matching constraints

All data are native. Each default-name consumer owns its writable eight-byte `noname[] =
"no_name"` static. Ripple's Shift-JIS circle glyph and rain's hat frame name are inline.
GetData's native switch and CScene's vtable supply their own tables. InScreenFunc's
bounds templates are `{50,50,0,0}` and `{-50,-50,0,0}`, sixteen bytes each; its static
sun_func owns 0x1C0 bytes plus a one-byte constructor guard. All-consumer relocation
checking names these objects independently of compiler suffixes.
