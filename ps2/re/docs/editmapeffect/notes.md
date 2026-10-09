# editmapeffect: reverse-engineering notes

## What the unit holds
Four `CEditMap` virtual overrides (`0x29FDF0`-`0x2A02B0`). The unit owns no class
(`CEditMap` is owned by `editmap`), has no non-member functions and no plain-named
globals, so `ps2/include/editmapeffect.hpp` only includes `editmap.hpp`, where all four
members are already declared (vtable slots: `DrawFireEffect` at `__vt__8CEditMap+0x1C`).

## Data
- `"fire_wrk"` and `"lightling"`: inline texture-name literals passed to
  `mgCTextureManager::GetTexture(char*, int)` in `DrawFireEffect`.
- `attr` (0x90, .bss) and its one-byte constructor guard (.sbss): function-local
  `static mgCFrameAttr attr;` in `DrawEffect`. After construction, every call sets (offsets in
  `mgCFrameAttr`, `mg_frame.hpp`): `+0x18 draw = 3` (VISIBLE|SKIP_CHILDREN),
  `+0x30 fog = 2`, `+0x48 no_cull = 1`, `+0x8C depth_bias = 1.015f` (`0x3F81EB85`).
  Ghidra shows these as `DAT_01f35bxx`.

## CEditMap offsets used (all already named in editmap.hpp / map.hpp)
- `0xD40 edit_parts_max`, `0xD44 edit_parts` (`CEditParts*`, stride 0x330 = sizeof(CEditParts)).
- `0x310 effect_list` (CMap, `CEffectList::GetEffectVisual(int)`), `0xCFC fire_raster` (CMap).
- `0x1050 balance_moved`, `0x1070 balance_pos[4]`, `0x10B0 balance_base_pos[4]`; AnimeStep touches `+0x1074`/`+0x10B4`, i.e. element [1] (Y).
- Per edit part: `+0x70 name[0]` (non-zero = slot in use), `+0x2B0 func_point_mngr`
  (first word & 2 tested in DrawFireEffect), `+0x2F0` (list head walked in AnimeStep, inside
  func_point_mngr; node+0x10 is a `CFuncPoint*`/`CObjAnime`), `+0xC0 frame`, `+0x310 state`
  (non-zero = placed).
- CFuncPoint offsets in DrawEffect: `+0x24` effect number, `+0x70` an `mgCFrame` (vcall slot
  0x48 sets the visual), `+0x164` its attribute pointer (= `&attr`).

## Function behaviour
- `DrawFireEffect(int tex_block)`: `CMap::DrawFireEffect`, build a `CFuncPointCheck` via
  `CreateFuncCheck`, reload texture block, fetch the two textures, unit matrix, then
  `mgDrawDirectStart`; for each in-use, placed part whose func_point_mngr flag bit 1 is set:
  `GetLWMatrix` then global `DrawFireEffect(mat, &func_point_mngr, &check, 1.0f, fire, light)`;
  `mgDrawDirectEnd`.
- `DrawFireRaster()`: same loop (no flag test) calling global
  `DrawFireRaster(mat, &func_point_mngr, &check, fire_raster)`.
- `DrawEffect()`: `GetNowTime`, `CMap::DrawEffect`, check; per in-use placed part,
  `GetStart(1)` / `Get()` over func_point_mngr; for each point passing `Check`, reference the
  part's frame, set the effect visual, point attr at the static, `mgDrawDirect`, drop reference.
- `AnimeStep(CObjAnimeEnv*)`: `CMap::AnimeStep`, check; step every passing function point's
  animation of every part (no in-use test); then if `balance_moved`, ease each
  `balance_base_pos[i][1]` (Y only) a quarter of the way toward `balance_pos[i][1]`, and set `balance_moved = 1` when all are within 0.1.

## Unresolved
- Meaning of func_point_mngr flag bit 1 (`&2`), and the exact field at part `+0x2F0`.

## Source status
All four functions are native; the unit has no `NONMATCHING` guards, `INCLUDE_ASM` gaps, or
data markers.
