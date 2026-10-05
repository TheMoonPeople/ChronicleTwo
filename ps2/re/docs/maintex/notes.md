# maintex notes

No class or struct is owned by this unit (`class_units.tsv` has no `maintex` rows). The header
holds 13 texture globals and 7 non-member prototypes, all global in retail (none of
0x1E9580-0x1EA340 or 0x37D4F0-0x37D520 is in `local_symbols.tsv`). All functions return `void`
(no caller uses `v0`/`f0`; m2c and Ghidra agree). No first-game counterpart header exists.

## Globals (.sbss, 4 bytes each, `mgCTexture *`)
Filled by `GetTextureInfo` via `mgTexManager.GetTexture(name, -1)`; name in parentheses.
| Symbol | Name | Users |
|---|---|---|
| TEX_ShadowTexture | "work" | dng_main DngMainDraw (mgBegin/EndDrawShadow, DepthOfField) |
| TEX_SystenFrame | "frame" | dng_status, dng_hud, automap (HUD frames, numbers) |
| TEX_SystenFrame2 | "frame2" | dng_event CStartupEpisodeTitle::DrawEpisode |
| TEX_StatusIcon | "status_icon" | dng_status DrawMainUnitStatusBord |
| TEX_DummyIcon1 | "icon_dmy1" | DrawMainUnitStatusBord |
| TEX_DummyIcon2 | "icon_dmy2" | DrawMain/RoboUnitStatusBord |
| TEX_SystemEffect1 | "effect00" | dng_effect, dng_hud effects; gyorace also writes it |
| TEX_SystemEffect2 | "effect01" | CFlushEffect::Draw |
| TEX_SystemEffect3 | "effect02" | no reader found |
| TEX_SystemEffectSw | "sweff" | SetSwordBlurEffect, monster LoadReferMonsterFile |
| TEX_ExFx_FIRE/ICE/THUN | "bteffe_fla/chi/lig" | CFireAfterHit, CChillAfterHit, CThunder |
"Systen" is retail's spelling.

## Rodata
`at_792..804`: texture names above. `at_819` "img/esystem%d.img", `at_820`
"dungeon/articles/tex01_%d.chr" (both sprintf'd with `LanguageCode`), `at_821..827` pack member
names (frame_basic, effect00, beffect_00, potbeam, water_ref, fire, bteffe_4ex .img), `at_828`
"TEXBLK_LAST = %d\n" (printf'd with 0xAE), `at_829..832` work texture names "work2",
"fire_work", "capture", "water_work". `at_936__3` is the jump table of AddExpWeaponParam's switch.

## Functions
- `MainTextureInterface(mgCMemory *stack, CScene *scene)`: EnterIMGFile of the gaiji and font2
  images (block 0x58), ReLoadFontTexture(0x58); loads esystem img (block 0x67), LoadTakePhoto;
  loads tex01 pack and enters its members into blocks 0x48,0x49,0x4A,0x4A,0x59,0x4B,0x6B;
  EnterTexture of work (100), work2 (100, screen/3), fire_work (0x4B), capture (0x65),
  water_work (0x59); `CFadeInOut::SetCrossTexture(scene+0x2C70, capture, BuffReadData+0x200000)`;
  then GetTextureInfo. Called from InitDungeonMain. Texture block numbers could become an enum
  shared with mg_texture.
- `calcWeaponParamWhp(monster, col_prim)`: only when `*(u8*)(col_prim->[+8] + 0x18)` is 0, 4,
  0xB or 0xC. wear = h*0.5 - h*0.5*stat*0.005 where h = `(u16)monster+0x1324`, stat =
  `(s16)battle_info+0x36`; x1.3 if `col_prim+0xA0 & 0x20`, x0.8 if `& 0x40`;
  `AddWhp(0, -wear)`; if the result <= 0 and the previous WHP (GetWhpNowVol(0)) was > 0,
  `AddAbsRate(0, -0.1, NULL)`.
- `calcWeaponParam2(type, divisor)`: only for type 1 or 5. wear = 1 - stat*0.002 with stat
  `(s16)battle_info+0x52` (= 0x36 + 0x1C, i.e. weapon slot 1), flags from GetSpecialStatus(1),
  `AddWhp(1, -wear/divisor)`, same break rule on slot 1. Callers in actscript pass 1 and
  `(s16)(col_prim->[+8])+0x46`.
- `SetDamageParam(col_prim, chara_no)`: `CBattleCharaInfo` per-character block stride 0x1C
  starting near 0x34: s16 at 0x34 (attack) -> `col_prim+0x88` (int, forced 0 if GetNowWhp <= 0);
  eight s16 at 0x38..0x46 -> `col_prim+0x90..0x9E`; GetSpecialStatus flags -> `col_prim+0xA0`
  with bit 4 kept 1/10 and bit 8 kept 1/20 (iRand). When `battle_info->[0] (s16) == 3` only
  0x88 is written. Always `col_prim+0x2C = battle_info->[0]`.
- `AddExpWeaponParam(exp, chara_no, type)`: if `battle_info->[0] == chara_no`, switch(type):
  1 -> AddAbs(0), 2 -> AddAbs(1), 3 -> half to each, 4 -> AddAbs(0) without level-up flag,
  8 -> AddAbs(0). Otherwise by `battle_info->[0]`: 3 -> slot 0, 2 -> slot 0 without flag,
  0/1 -> half to each. If the level-up flag is set: `LevelupInfo.SetLevelUpInfo(0x100,
  mgScreenHeight/2, slot, 0)` and `sndSePlay(SystemSND_ID, 0x1E, 0)`. Caller: CPullItem::Step
  with its fields +0x64 (float), +0x6A, +0x6C (s16).
- `SetSwordBlurEffect(chara, stack, blur_type)`: `new (stack->Alloc(0xC)) CSWordAfterEffect`
  (size 0xA0; inline ctor sets eight ints 0x20..0x3C to 0x80), stored at `CCharacter2+0x570`;
  `Initialize(stack, 0xC, 8)`; `SetTexture(0x4A, TEX_SystemEffectSw, u, v, 0x40, 0x20)` with
  (u,v) = (0x40,0) for 0, (0,0) for 1, (0,0x20) otherwise. SetupMainUnit passes 0, 1, 2.

## Unresolved
- Meaning of `battle_info->[0]` values 0..3 (active character / mode), of `type` in
  calcWeaponParam2 and AddExpWeaponParam, and of the col_prim byte at `[+8]+0x18`; enums left for
  the body pass once userdata/colprim headers name them.

## C++ draft pass

All seven remaining functions have typed C++ drafts under `NONMATCHING`. The
texture loader follows the m2c call order and uses the existing `mgCMemory`,
`mgCTextureManager`, `CScene`, and `CFadeInOut` interfaces. The wear and damage
functions use the typed `CBattleCharaInfo`, `CActiveMonster`, and `CColPrim`
fields. `AddExpWeaponParam` required assembly inspection because m2c could not
resolve its nine-entry switch table; table entries 1, 2, 3, 4, and 8 are the
only non-default entries. The sword trail object is stored in
`CCharacter2::sword_effect[0]`.

`GetTextureInfo` matched byte for byte and passed isolated whole-image
promotion. The other six drafts compiled but differed on their first
promotion attempts and remain behind `NONMATCHING`. The default linked image
remained byte-identical after the promotion.
