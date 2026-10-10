# editexception: reverse-engineering notes

## Source status

Every function is native C++ with no `NONMATCHING` guards, `INCLUDE_ASM`
fallbacks or data markers; all data is typed native definitions. The complete
object is 0x19FC bytes with 271 relocations. `InitFirePowder`
(`InitFirePowder__FiP6CSceneiP9mgCMemory`, 0x2FCA30, GLOBAL, symbol size
0x358 inside the 0x360 extent) depends on the placement-new row for
`__nw__FUiP1` / `__ct__11mgC3DSpriteFv`, `after_constructor_inline`,
`expected_matches: 1`: at its `SpriteVis = new (memory->Alloc(7)) mgC3DSprite`
retail tests the allocation result in `v0` and copies it to `s0` in the branch
delay slot, whereas MWCC otherwise copies first and tests `s0`. The particle
array-new and the out-of-line frame/attribute constructors are not selected.
See [placement conversion](../satansfiddle/placement-new.md).

Special-case effects for edit (Georama) maps and the S51 dungeon floor. No first-game
counterpart exists in Dark Cloud 1.

## Globals
Every named global in this unit is LOCAL in retail (`build/re/local_symbols.tsv`), so none is
declared in the header; they are `static` definitions in the `.cpp`.
All are 4-byte `.sbss`, in the retail order of camera-reaction, thunder, fire-powder and geyser state.

| Symbol | Type | Meaning / evidence |
|---|---|---|
| `rea_chara_id` | `int` | Set to -1 by `InitNpcCameraReaction`. Character reacting to the camera. |
| `rea_mtn_step` | `int` | Set to 0 by `InitNpcCameraReaction`. |
| `thunder_count` | `int` | `S51Thunder`: set to 4 on a flash, decremented every frame. |
| `start_thunder` | `int` | Only cleared by `InitS51Thunder`. |
| `next_thunder_cnt` | `int` | Frames to next flash; init 0x3C; on 0 reset to `rand()%150+10`. |
| `fade_cnt` | `int` | Flash fade, 0x28 on flash, decremented, clamped to 0; ratio `fade_cnt/40.0`. |
| `sound_flag` | `int` | Thunder sound pending. |
| `sound_cnt` | `int` | Frames until sound: `rand()%20` (1 if > next_thunder_cnt); plays `sndSePlay(?, rand()%4 + 0x15, 0)`. |
| `FirePowderFlag` | `int` | Nonzero once fire rain loaded. |
| `FirePowderTexb` | `int` | Texture block (callers pass 0xD0). |
| `SpriteVis` | `mgC3DSprite *` | `new(0x50)` with inlined mgCVisual/mgC3DSprite ctors. |
| `FirePowFrame` | `mgCFrame *` | `new(0x110)` mgCFrame; attr `new(0x90)` mgCFrameAttr stored at frame+0xF4, attr+0x30 = 2, attr+0x08 = -1; visual = SpriteVis (vtbl+0x48). |
| `fire_powder` | `FirePowder *` | `new[](0x2000)` = 0x100 x 0x20, no ctor. |
| `GeyserEffectFlag` | `int` | Nonzero once geysers loaded. |
| `GeyserEffectTexb` | `int` | Texture block (callers pass 0xD1). |
| `GeyserFrame` | `mgCFrame *` | Same setup as FirePowFrame. |
| `GeyserRndSeed` | `int` | `rand()` at end of `InitGeyserEffect`; not read in this unit. |
| `GeyserEffect` | `CGeyserEffect *` | `new[](0x210)` via `__construct_new_array(..., ctor, 0, 0x80, 4)`. |

The `.bss` 0x10 zero template and the `.data` blocks are compiler-generated local array
initialisers (colour/size/uv vectors for `CPSetSprite`; `CGeyserEffect::CreatePacket` initialises
its real `mgVec4` size, UV and colour aggregates directly, including the zero UV initialiser);
`DrawFirePowder` has two 4 x float[4] uv tables indexed by `i & 3`.
Strings, all inline literals at their uses: "p07_g0301", "g0301_07-m", "g0301_08-m", "na",
"g0301_21", "s51", "p05_s5102-0", "p11_s5102-0", "effect/firerain.img", "firerain",
"effect/geyser.img", "geyser_eff".

## FirePowder (0x20, name neutral: no retail type name)
Init/Step/Draw FirePowder. 0x00 pos[4] (x,y,z random in +-200/+-300/+-200; w = phase, init 0),
0x10 phase_speed (rnd*0.1+0.1), 0x14 sway_x, 0x18 sway_z (both (rnd-0.5)*4), 0x1C fall_speed
(-(rnd*0.5+0.1)). Step: y += 0x1C, if y < -300 then y = 300; phase += speed, wrap at pi by -2pi.
Draw uses 0x14 for both X and Z sway; 0x18 never read.

## CGeyserEffectPoint (0x30)
Size: `__construct_new_array` stride 0x30, `new[](0x910)` = 0x30*0x30 + 0x10. Ctor stores 0 at
0x28 only. CreatePoint: 0x28 = 1 (int), 0x20 = 1.0, 0x1C = rnd*0.4+2.6, 0x24 = 1.0,
0x14/0x18 = (rnd-0.5)*4, 0x10 = rnd*0.1+0.1, then `mgZeroVectorW(point)` (pos = 0,0,0 and
w/phase = 1.0). Step: 0x20 -= 0.02, y += 0x1C, 0x24 += 0.1, phase += 0x10 (wrap pi), 0x28 = 0
when 0x20 < 0. CreatePacket: x = pos.x + scale*sway_x*sin(phase), z likewise with sway_z,
colour alpha = 0x20*64, size = 0x24*15 (both axes); 0x28 tested with `lw` (int). 0x2C unused.

## CGeyserEffect (0x80), no vtable
Size: `__construct_new_array` stride 0x80 x 4, `new[](0x210)`.
- 0x00 wait: ctor -1; Create: if < 1 re-arm: wait = rnd*150+100, erupt_frame = 0,
  erupt_count = rnd*32+0x30, and erupting = 1 only if wait was exactly 0 (so the first arm from -1
  does not erupt); then wait--.
- 0x04 erupting: ctor 0. While set: if erupt_frame % 12 != 0 then erupt_count--, CreatePoint();
  erupt_frame++; erupting = 0 when erupt_count < 1.
- 0x08 erupt_frame, 0x0C erupt_count.
- 0x10 point_num (Init sets 0x30), 0x14 point (CGeyserEffectPoint array). Ctor zeroes both.
- 0x18..0x1F never accessed.
- 0x20 mgC3DSprite sprite (by value, 0x50; its vtable pointer at 0x3C). Draw passes
  `&GeyserEffect[i].sprite` to `GeyserFrame` vtbl+0x48 (set visual).
- 0x70 mgCTexture *texture = GetTexture("geyser_eff", -1).
- 0x74..0x7F never accessed.
Ctor order seen: mgCVisual vt store + Initialize(), mgC3DSprite vt store + Initialize() (inlined
member ctor), then 0x10 = 0, 0x14 = 0, `sprite.Initialize()` (virtual call via vtbl+0x30) again,
then 0x00 = -1, 0x04 = 0. So the body is assignments, not member initialisers, and includes an
explicit `sprite.Initialize()`.
Both ctors sit after `InitGeyserEffect` in address order; they may be inline functions emitted
after their first use or ordinary out-of-line definitions -- the header declares them non-inline.

## Functions
- `EditExceptionStep(map_no, scene)`: only map_no 9 or 2 (callers pass `MapNo`). Pieces
  "g0301_07-m"/"g0301_08-m" of place parts "p07_g0301" -> their mgCFrame at piece+0x70.
  Texture anime of texture "g0301_21" group "na": list+0x26 (s16 length), +0x2A (s16 current).
  Writes float at frameattr+0x44 of frame "na" in piece 07 (fade in first quarter, out over the
  next half), and `SetAttrParamObjAlpha((sin(cur/len*2pi)+1)/0.5, 1)` on piece 08. Camera pos is
  fetched but unused.
- `S51Thunder`: only when map name == "s51"; when `CMap::GetTimeLightingRatio` > 1 it builds a
  0x1D0-byte CMapLightingInfo blended 2 ways, sets light/ambient, and on place parts
  "p05_s5102-0"/"p11_s5102-0" sets parts+0x64 = 1 and for each node in list at parts+0xB0 sets
  word[0x19] = 1, float word[0x1A] = fade ratio.
- `InitFirePowder`: map_no 3, 0x57 or 0x55, and `GetSaveData()->GetBitFlag(0x208) == 0`. File
  is loaded into `scene+0x3C` (scene's load buffer), copied into memory, entered as texture block.
- `InitGeyserEffect`: map_no 3 only.
- `DrawGeyserEffect`: `CEditMap::GetePlacePartsAtInfoID(0x4C, ids, 0x14)` (up to 20 placed
  geyser parts); emitter index = ((id * 0x10DE8 + 1) >> 16) % 4 (signed). Calls parts vtbl+0x18
  to get a position/matrix into a 16-byte buffer, frame vtbl+0x10 to set it, `mgDrawDirect`.
- Map numbers (2, 3, 9, 0x55, 0x57) and 0x4C (place-parts info id) have no enum yet in the tree;
  remain literals until their value domain is established.

## Unresolved
- Retail name of the fire rain particle struct (`FirePowder` is neutral).
- Meaning of `start_thunder`, `GeyserRndSeed` (written only), CGeyserEffect 0x18/0x74 gaps,
  CGeyserEffectPoint 0x2C.
- The texture-anime record offsets used by `EditExceptionStep` do not align
  cleanly with the current `CList<mgCTexAnimeData>` layout; the draft uses
  named record fields as a provisional interpretation. Its fade timing needs
  a type-layout check before matching work continues.
- `S51Thunder` writes two fields of each map-piece list node in retail; the
  current named-field interpretation for those node writes needs verification.

## Source forms the matches depend on

- `InitFirePowder`: `attr->fog = 2` selects black fog under the
  `mgCFrameAttr::fog` contract (0 off, 1 scene colour, 2 black, 3 white; an
  owning enum belongs in `mg_frame.hpp`); the Z-write sentinel is
  `MG_ZBUF_NO_WRITE`; `align16_blocks` performs the quadword rounding of the
  loaded image size. Map IDs and the story bit stay numeric (no owning enum).
- The placed-parts piece walk uses `CObject *piece = &node->data` (the list
  holds `CMapPiece`, which derives from `CObject`).
- `(EditGsTest *) &draw_env.test` is a GS register view (accepted convention).
