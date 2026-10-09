# editeff: reverse-engineering notes

## Source status

Every function is native C++ with no `NONMATCHING` guards, `INCLUDE_ASM`
fallbacks or data markers; all data (1711 bytes) is typed native definitions,
and both effect vtables are emitted natively. `EditSetPlaceAnime`
(`EditSetPlaceAnime__FiP9CMapParts`, 0x300C40, GLOBAL, symbol size 0x264
inside the 0x270 extent) depends on the placement-new row for
`__nw__FUiP1` / `__ct__9CMapPartsFv`, `after_constructor_inline`,
`expected_matches: 1`, which reproduces the allocation-result branch/copy
schedule at +0xC0/+0xC4 of its `new (CurPartsBuff) CMapParts`; see
[placement conversion](../satansfiddle/placement-new.md).

Edit-mode (Georama) effects: star burst on placing a part, paint-drop splash on painting
(and on placing a river), and the hop/sway/squash/remove animations of placed parts.
No first-game counterpart (the first game has no `editeff` unit). The header is `ps2/include/editeff.hpp`.

## Globals (all in `ps2/src/editeff.cpp`)
| Symbol | Addr | Size | Binding | Type / meaning |
|---|---|---|---|---|
| `EffectFlag` | 0x37E610 sbss | 4 | LOCAL | `int`; set to 1 by EditPlaceEffect/EditPaintEffect, cleared by EditInitPlaceEffect; gates EditPEffectStep/Draw. |
| `EffectState` | 0x37E614 sbss | 4 | LOCAL | `int`; only written (0) in EditInitPlaceEffect. |
| `PaintEffect` | 0x37E618 sbss | 4 | LOCAL | `CPaintEffect *`; `__construct_new_array(mem, CPaintEffect ctor, 0, 0x400, 1)` in EditSetEffectBuffer (`new CPaintEffect[1]`, 0x410 bytes with array header, Alloc 0x42 qw). |
| `_StarEffect` | 0x1F588C0 bss | 0x300 | LOCAL | `CStarEffect[3]`; constructed in `__sinit_editeff_cpp` by `__construct_array(.., ctor, 0, 0x100, 3)`. |
| `CurPartsBuff` | 0x1F58BC0 bss | 0x30 | LOCAL | `mgCMemory`; `Init()` in sinit (inline ctor), `stSetBuffer(Alloc(0x5DC), ..)` in EditSetEffectBuffer; removal copies of CMapParts are `new (CurPartsBuff)`. |
| (anonymous) | 0x1F58BF0 | 0x20 | LOCAL | compiler-generated zero template in CStarEffect::Draw (two float[4] size rows; [3] and [7] read). |
| (anonymous) | 0x1F58C10 | 0x10 | LOCAL | compiler-generated zero template in CPaintEffect::Draw (float[4]; [2],[3] used as size z/w); the four-float vector is initialised at its copy point inside the particle loop. |
| `PlaceAnime` | 0x1F58C20 bss | 0x1B0 | GLOBAL | `CPlaceAnime[3]` (stride 0x90). Only global datum -> the only `extern` in the header. |

The LOCAL ones must be `static` in the .cpp (cannot be `extern`ed in the header).
`.data` literals: the star uv0/uv1 rows (2 x float[4]), the star colour {128,128,128,_}, the paint
uv0/uv1 rows, and the `"haichi_eff"` texture name (rodata, an inline literal at the lookup). All
function-local initialised arrays are copied onto the stack.

All 26 non-member functions are GLOBAL (none in local_symbols.tsv).

## CStarEffect (size 0x100) : CObject (0x70)
Size: `_StarEffect` 0x300 / 3, loop stride 0x100, `__construct_array` 0x100.
Vtable `__vt__11CStarEffect` (0x74, same as CObject): overrides only slot 0x34 `Draw` (returns int,
the result of `mgDrawDirect(mgCVisual*, mat)`). Step/ParamInit are non-virtual (direct jal).
Ctor 0x301550 (emitted after all functions = inline/implicit): stores mgCObject vt, Initialize via vt,
CObject vt, Initialize via vt (CObject ctor inlined here despite map.hpp declaring it out-of-line at 0x1631B0),
own vt, then mgCVisual/mgC3DSprite vt at +0xBC (= sprite at 0xA0, vptr at sprite+0x1C) with Initialize via vt 0x30.
| Off | Field | Evidence |
|---|---|---|
| 0x10/0x20/0x30 | mgCObject position/rotation/scale | Draw: `mgCreateMatrixPY(m, this+0x10, this[0x24])`; Step writes 0x30..0x38 (scale ease to 10), 0x24 yaw, 0x14 pos.y |
| 0x70 | state (EditEffectState) | ParamInit=1, Step sets 3 when alpha<0; Draw skips 0/3 |
| 0x74 | spin_speed f | Step: +=0.008 for frames 11..29; yaw += it |
| 0x78 | rise_speed f | Step: +=0.21; pos.y += it |
| 0x7C | alpha f | ParamInit 1; Step -=0.05 after frame 10; Draw colour w = alpha*128 |
| 0x80 | star_angle f | Step `+= mgAngleLimit(yaw+0.2)`; Draw size z (sprite mode 1 = ROTATE) |
| 0x84 | size f | EditPlaceEffect: `dist/300+1`; Draw size rows = size*25, size*15 |
| 0x88 | frame s32 | Step ++ ; EditPlaceEffect reuses star with greatest frame |
| 0x8C | particle_max s32 | EditSetEffectBuffer = 0x40 |
| 0x90 | particle_num s32 | ParamInit = min(num, max); Draw loop count |
| 0x94 | EditStarParticle* | `__nwa(max<<5, Alloc(max*2+2))`, no ctor (POD) |
| 0xA0 | mgC3DSprite (0x50) | ctor, Draw calls on this+0xA0 |
| 0xF0 | mgCTexture* | EditSetEffectBuffer stores GetTexture("haichi_eff"); Draw CPSetTexture |
0x98, 0x9C, 0xF4..0xFC never touched.

EditStarParticle (0x20, name invented): +0 FVECTOR offset (ParamInit: r*sin, size[1]*rnd, r*cos, 1),
+0x14 s32 shape = i%2 (Draw `lw` 0x14 -> row index of size/uv tables). +0x10,+0x18,+0x1C unused.
Draw: `sceVu0MulVector(out, p->position, this->scale)`, w=1; mode 1, alpha 2 (SetAlpha), ZBuf -1.
ParamInit(area, num): `sceVu0ScaleVector(area, area, 0.12)` (modifies caller's vector).

## CPaintEffect (size 0x400) : CObject
Size: new-array stride 0x400. Vtable same shape, overrides only `Draw` (0x34). Ctor 0x2FFC20 identical
in shape to CStarEffect's. EditPEffectDraw calls PaintEffect->Draw virtually (vt 0x34); stars directly.
| Off | Field | Evidence |
|---|---|---|
| 0x70 | state | ParamInit 1; Step: wait-- and when <1 -> 2, alpha<0 -> 0; Draw skips 0,1,3 |
| 0x74 | shape s32 | EditPaintEffect sets 1 when `river`; Draw uv row index |
| 0x80 | color FVECTOR | copied from param, `ScaleVector(1.2)`, rgb clamped to 255; Draw colour xyz |
| 0x90 | mgCTexture* | GetTexture("haichi_eff") in EditPaintEffect |
| 0xA0 | mgC3DSprite | Draw; mode 0, SetAlpha 1 |
| 0xF0 | alpha f | ParamInit 1; Step -0.05; Draw w = alpha*128 |
| 0xF4 | wait s32 | ParamInit 10; river sets 0 |
| 0x100 | drop[24] FVECTOR | ParamInit zero, y=10, w = scale*(rnd*0.5+0.5); Draw pos, size = w*10 |
| 0x280 | drop_speed[24] FVECTOR | ParamInit x,z = (rnd-0.5)*8, y=2, w=0; Step y-=0.3, `mgAddVector(drop, speed)` |
0x78, 0x7C, 0x94..0x9C, 0xF8, 0xFC unused. ParamInit(scale): 1.0, or 2.0 for river.
Note Step only advances drops once wait<1 (state 1 counts down, then every frame state is reset to 2).

## CPlaceAnime (size 0x90), no base, no vtable, POD (not constructed in sinit)
Stride 0x90 in every loop; PlaceAnime 0x1B0 = 3*0x90.
| Off | Field | Evidence |
|---|---|---|
| 0x00 | state | Set 1 by EditSetPlaceAnime; Step sets 0 when done; state funcs test 0/3 |
| 0x04 | type (EditPlaceAnimeType) | param of EditSetPlaceAnime; from `CEditParts+0x324 -> +0x90` (parts data `place_anime`) in EditStartPlaceEffect, or 3 from RemoveMtnStep |
| 0x08 | CMapParts* | vt calls 0x18 GetPosition, 0x24 GetRotation, 0x30 GetScale, 0x10/0x1C/0x28 Set*, 0x34 Draw |
| 0x10/0x20/0x30 | rotation/scale/position (applied) | EditSetPlaceAnime Get*(+0x10/+0x20/+0x30); Step Set* from them |
| 0x40/0x50/0x60 | base_rotation/scale/position | Step Get* into them each frame; Step2 Set* from them |
| 0x70 | frame s32 | init 0; type1 ends >60, type2 >15, type3 >10; slot reuse picks greatest frame |
| 0x74 | phase s32 | init 0; type2: 0 hop, ++ on landing |
| 0x78 | power f | init 1.0; type1 *0.92, type2 *0.97 |
| 0x7C | height f | init 0; pos.y = base_pos.y + height; type3 +=20 |
| 0x80 | height_speed f | init 6.0; -=1.2 per frame, height += it, stop at height<0 |
0x0C, 0x84..0x8C unused.
Step type 1: rot.x = power*0.4*sin(frame/30*2pi), rot.z = power*0.4*cos(power*pi/2 + frame/30*2pi).
Type 2 after landing: scale.x = scale.z = power*0.2*sin(..)+1, scale.y = 2 - that. Type 3: scale.x,z -= 0.1 (clamped 0).
Unknown type -> slot freed. Step's type-2 branch has a forward jump to the common tail (write as nested ifs, no goto).
Draw: parts->Draw() only when type == 3 (the copy is not in the map).

EditSetPlaceAnime type 3: picks a free slot, preferring (break) a free slot whose old type is 3, else the
last free one; clears it, resets CurPartsBuff (`lock` 0x1C and `stack_used` 0x24 = 0), `new (CurPartsBuff) CMapParts`
(0x310, inline CMapParts ctor inlined: mgCFrame ctor at +0xC0, CFuncPointMngr vt at +0x2E0 / Initialize at +0x2B0,
+0x2FC = 0), then `src->Copy(*copy, &CurPartsBuff)` (vt 0x80), and animates the copy.
Other types: first free slot, else greatest frame.

## Enums
- EditEffectState: 0 FREE, 1 PLAY, 2 SCATTER (paint only), 3 END. Return values of EditGetPEffectState /
  EditGetPlaceAnimeState (1 if any playing, else 3 if any ended, else 0). *EndCheck: if 3 -> Init*, return 3;
  else return `GetState() != 0`.
- EditPlaceAnimeType: 0 NONE, 1 SWAY, 2 SQUASH, 3 REMOVE (names from observed behaviour).

## Other
- EditPEffectDraw(int): argument unused (EditDraw passes 0xA3).
- EditPlaceEffect: `GetBBox`, half extent via `sceVu0SubVector(max-min)*0.5`, `d = min(mgDistVectorXZ, 300)`,
  num = `(int)(d/5.5555553+10)`, ParamInit({d, h, d}), SetPosition(pos) via vt 0x10, size = d/300+1.
  EditPlaceEffect's CEditParts is passed to CMapParts::GetBBox (CEditParts : CMapParts).
- Return types: int for every state/bool-returning function (`EditPEffectEndCheck` returns 3 or 0/1).

## Source forms the matches depend on

- `EditSetEffectBuffer` and `EditPlaceEffect` index `_StarEffect[i]` at each
  use (the optimizer forms retail's 0x100 induction). A `CStarEffect *`
  element local is coloured before the offset induction value and swaps their
  registers.
- Each star effect's particles are
  `new (memory->Alloc(blocks + 2)) EditStarParticle[*count]` (POD array,
  no constructor); `PaintEffect` is `new (memory->Alloc(0x42)) CPaintEffect[1]`.
- `CStarEffect::ParamInit` copies the local position into
  `particle[i].position` as a plain quadword; the `*(u_long128 *)` vector
  copies are the accepted quadword-copy convention.
- `EditSetPlaceAnime`: the two slot searches index the real `PlaceAnime`
  array with their own `for (int i = 0; ...)` counters, read
  `PlaceAnime[i].state` directly (a `candidate->state` read leaves 12 words),
  keep each candidate pointer local to its iteration and the greatest-frame
  accumulator local to the second branch. The temporary `CMapParts` is built
  by natural placement new; the real inline `CMapParts` constructor
  constructs its `mgCFrame` member at +0xC0 and the retail call uses the
  `CMapParts` vtable store as the constructor call's delay slot. A placement
  `operator new(size_t, mgCFrame&)` overload makes MWCC emit an extra `beqz`
  before `__ct__8mgCFrameFv`, and `target->frame.mgCFrame()` constructs a
  temporary at `sp+0x50` instead of the member.
- `effect_idle` (0) is the free state of an effect or animation slot;
  `place_anime_count` (3) is the `PlaceAnime` array length.
- The native `_StarEffect[3]` and `CurPartsBuff` definitions emit the retail
  array-construction and memory-initialisation calls in `__sinit_editeff_cpp`
  (64-byte initialiser).
