# colprim: reverse-engineering notes

Header: `ps2/include/colprim.hpp`. No first-game counterpart (the first game has no `CColPrim`).
No virtual functions, no vtable symbols, no static members. No non-member functions.

## CColPrim (0x110)
Size from the manager's stride: every `CColPrimMan` loop steps by 0x110 over 64 entries
(`GetPrim`, `ActivePrimNum`, `CheckHit`, `Delete`, `Step`, `Initialize`), and from the
`ColPrimMan` BSS extent 0x4410 = 0x10 + 64 * 0x110.

| Off | Field | Evidence |
|---|---|---|
| 0x00 | `id` s32 | `CColPrimMan::Initialize`, `GetPrim`, `GetID2Prim` store the index; `CColPrimMan::IsReversVec` skips `prim->id == i`; `_SHOT_ROCKET_LAUNCHER` keeps it for `GetID2Prim` |
| 0x04 | `param_no` s32 | `SetDamage` stores the row index |
| 0x08 | `param` DAMAGE_PARAM* | `SetDamage` stores row pointer; read everywhere (`+0x10`, `+0x18`, `+0x46` ...) |
| 0x0C | `active` s32 | `SetDamage` = 1, `Delete`/`Initialize`/`Step` = 0; tested by `GetPrim`, `ActivePrimNum` (manager +0x1C) |
| 0x10 | `owner` s32 | `SetDamage` 2nd arg; `Delete(owner)` compares; `Initialize` = -1. Callers pass 0 (player side), 2 (rocket launcher), monster `+0x670` (chara id), effect script `+0xA8` |
| 0x14 | `unk_14` | never seen |
| 0x18 | `hit_mask` u64 | `ld`/`sd` in `IsHit`; `Initialize` `sd $0`. Bit `1 << (chara_id & 31)` (32-bit `sllv`) |
| 0x20 | `step_count` s32 | `Step` increments; `SetCoord` branches on == 0 (first placement) |
| 0x24 | `life` s32 | `Step`: if != -1 and `life <= step_count`, deactivates. `Initialize` = -1 |
| 0x28 | `hit_num` s32 | `IsHit` increments on hit; `_COLPRIM_GET_HITCNT` reads |
| 0x2C | `attacker` s32 | `SetDamage` = -1; `SetDamageParam` (maintex) = `*(s16*)BattleCharaInfo` (current battle chara); `IsReversVec` requires the other prim's value == 0; monster CheckDamage compares to `0/1` and to BattleCharaInfo |
| 0x30 | `coord_type` u32 | `SetCoord(float*..)` = 1, `SetCoord(mgCFrame*..)` = 2, `Step` tests `& 2` -> `ColPrimCoordType` |
| 0x34 | `unk_34` s32 | `Initialize` = 0 only |
| 0x38 | `frame[2]` mgCFrame* | `SetCoord(mgCFrame*...)`, `Step` loop stride 4 |
| 0x40 | `pos[2]` FVECTOR | `SetCoord`, `Step` (stride 0x10), `IsHit` |
| 0x60 | `old_pos[2]` FVECTOR | `SetCoord`/`Step` copy pos -> old_pos; `GetReversVec` = old_pos[0] - pos[0] |
| 0x80 | `target` u32 | `SetDamage` from row +0x14 (bit 0 resolved by owner: 0 -> 4, else 2); `IsHit`: scene type 1 needs `& 2`, type 3 needs `& 4` |
| 0x84 | `radius` float | `Initialize` clears it; `SetCoord` last arg; `IsHit` threshold `(radius + chara_r) * 2` |
| 0x88 | `damage` s32 | `SetDamage` from row +0x1C; overwritten by `SetDamageParam`, `_COLPRIM_SET_DAMAGE`, monster ThinkHost, rocket launcher |
| 0x8C | `unk_8c` s32 | `Initialize` = -1 only |
| 0x90 | `element[8]` s16 | `SetDamage` memcpy 0x10 from row +0x2C; `SetDamageParam` copies 8 shorts; monster CheckDamage loops 8 shorts, picks max of first 4 for colour |
| 0xA0 | `status` u32 | row +0x40; `SetDamageParam` = `GetSpecialStatus`; monster CheckDamage tests 4, 8, 0x10, 0x80, 0x200, 0x400, 0x1000, 0x8000, 0x10000, 0x40000, 0x80000; calcWeaponParamWhp 0x20, 0x40 |
| 0xA4 | `range` float | `SetDamage` = 10000.0; gun shots set 300/500; monster CheckDamage: damage falls off from range/2 to range by `mgDistVector(pos, origin)` |
| 0xA8 | `unk_a8[8]` | never seen |
| 0xB0 | `origin` FVECTOR | `SetCoord` on first placement (step_count == 0) |
| 0xC0 | `reversed` s8 | `Initialize` = 0; actionchara RunScript sets 1 after `CColPrimMan::IsReversVec`; `_COLPRIM_GET_REVCNT` reads (`lb`) |
| 0xC1 | `unk_c1[15]` | never seen |
| 0xD0 | `revers_vec` FVECTOR | RunScript `GetReversVec(prim + 0xD0)`; `_COLPRIM_GET_REVCNT` reads x/y/z |
| 0xE0 | `gift[3]` s16 | `_COLPRIM_GET_GIFT` writes; `CheckGiftPack` compares to `gift_item_tbl` |
| 0xE6 | `has_gift` s8 | `_COLPRIM_GET_GIFT` = 1, `Initialize` = 0; monster CheckDamage branch |
| 0xE7 | `unk_e7[9]` | never seen |
| 0xF0 | `hit_vec` FVECTOR | `IsHit` writes direction (w = 0, normalised for the sphere case) |
| 0x100 | `hit_pos` FVECTOR | `IsHit` writes; `_COLPRIM_GET_HIT_POS`, `HitEffectSet`, monster knockback read |

Return types: `SetDamage` returns 1 / 0 (row not found); `IsHit`, `IsReversVec`, `Step` return 0/1
ints; the rest void. `IsHit(scene, chara_id)` with `chara_id == -1` skips the hit mask.
`CColPrim::IsReversVec(attack)`: sets w = 1 on both pos[0]; hit when
`dist <= (this.radius + attack.radius * 2) * 2`; only when `attack->attacker == 0`.

## CColPrimMan (0x4410)
`scene` at 0 (`Initialize` stores; `CheckHit` passes `*(CScene**)this`). `prim[64]` at 0x10;
0x4..0xF is implicit alignment padding from the 16-byte aligned `sceVu0FVECTOR` members (the
STATIC_ASSERT confirms the compiler places `prim` at 0x10). The single instance `ColPrimMan`
(0x01ECF220, size 0x4410) is BSS of **dng_main** (`INCLUDE_BSS(ColPrimMan, 0x4410)` in
`dng_main.cpp`), so its `extern` belongs in `dng_main.hpp`, not here.

## DAMAGE_PARAM (0x48) and Damage_Param_Table
Struct name is not retail (no symbol); named after the table. Row stride 0x48 from `SetDamage`
(`left += 0x48`). The table symbol extent 0x2058 = 115 rows exactly; `SetDamage` stops at a row
whose first name byte is 0, which is the 8 bytes of zero padding after the table in `.data`
(0x33CF68). Table is in `.data` (writable), so not `const`.

| Off | Field | Evidence |
|---|---|---|
| 0x00 | `name[16]` | `strcmp` in `SetDamage`; Shift-JIS names, longest 14 bytes + NUL |
| 0x10 | `shape` u32 | `IsHit` tests byte `& 1`, `& 2`, `& 4`. Values 0,1,2,5,6 |
| 0x14 | `target` u32 | -> prim 0x80. Values 1 (by owner) or 6 (both sides: bombs, explosions) |
| 0x18 | `kind` s8 | `lb`/char reads in monster CheckDamage (react_tbl, vs_attk_index, sound), calcWeaponParamWhp (0,4,0xB,0xC = weapon wear) |
| 0x1C | `damage` s32 | -> prim 0x88; also percent for status 0x1000 in monster CheckDamage |
| 0x20 | `multi_hit` s8 | `IsHit` `lb`; when 0 the hit sets the target bit. Only ドリルアーム has 1 |
| 0x21 | `unk_21` | always 0 |
| 0x22 | `stagger` s8 | added to target `+0xBF4` (monster and actionchara CheckDamage). Values 0..3 |
| 0x23 | `unk_23` | always 0 |
| 0x24 | `critical_rate` s16 | damage *= value * 0.01 on a critical (both CheckDamage). Values 0..0x64 |
| 0x26 | `hit_flags` u16 | `HitEffectSet` 3rd arg; `& 8` disables the critical; `& 1` monster state 500/600 |
| 0x28 | `unk_28` s32 | always -1 |
| 0x2C | `element[8]` s16 | memcpy to prim 0x90; actionchara CheckDamage reads shorts. Order seen: fire, ice, thunder, wind, holy (rows 火弾/氷弾/雷弾/風弾/魔石聖) |
| 0x3C | `source_type` s32 | stored to monster `+0x1210`. Values 0,1 (player melee),2 (player shots),3 (items),4 (ridepod),8 (monsters) - meaning inferred from row names only |
| 0x40 | `status` u32 | -> prim 0xA0 |
| 0x44 | `stun_time` s16 | -> target `+0xBE8` (x1, x2, x3, x7 in actionchara) |
| 0x46 | `hit_count` s16 | damage divisor in monster CheckDamage; `calcWeaponParam2` arg |

## Enums
- `DamageShape` (row 0x10): from `IsHit` bit tests.
- `DamageTarget` (row 0x14 / prim 0x80): `SetDamage` and `IsHit`. Scene types come from
  `CScene::GetType(1, chara_id)`; 1 = player side (player attacks use owner 0 -> flag 4 and
  `CActionChara::CheckDamage` calls `CheckHit(0)`), 3 = monsters (`CMonsterMan::CheckDamage` calls
  `CheckHit(slot + 0x18)`).
- `DamageKind` (row 0x18): names inferred from the table's row names (ユリス = Max, モニカ =
  Monica, ロボ = ridepod, サムライソード/ドリルアーム = ridepod arms). Monster CheckDamage also
  tests 0x0E and 0x15, which no row in this table uses.
- `ColPrimCoordType` (prim 0x30).
- `status` bits are left as plain u32 (owned by CBattleCharaInfo's special-status flags).

## Unresolved
`unk_14`, `unk_34`, `unk_8c`, `unk_a8`, `unk_c1`, `unk_e7`, row `unk_21`, `unk_23`, `unk_28`.

## Debug drawing
`CColPrim::DebugDraw` returns immediately without drawing. Its empty C++ body
matches the retail code and links into a byte-identical game image.

## C++ draft pass
All 18 previously ASM-only game functions received typed C++ drafts, initially
guarded by `NONMATCHING`.
The existing matching `DebugDraw` and `Initialize` implementations remain
unguarded. `IsHit` builds sphere sample points and line segments from the current
and previous positions according to `DamageShape`, then checks enabled character
entry objects; on a hit it records hit position and direction, marks the character
unless the parameter allows multiple hits, and increments `hit_num`.

Each of the 18 drafts received one isolated promotion attempt. Thirteen matched
the linked retail image and are now compiled by default: the four `SetCoord`
overloads, `GetReversVec`, and all eight `CColPrimMan` methods. `SetDamage`,
`IsHit`, `IsReversVec`, `Step`, and `Delete` remain under `NONMATCHING` with
their original `INCLUDE_ASM` fallbacks. The default full build verifies every
section as byte-identical to SCES_511.90.
