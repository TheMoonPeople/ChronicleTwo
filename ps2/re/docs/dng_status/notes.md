# dng_status notes

Dungeon status board (the HUD panels at the top/bottom of the screen). Seven functions, no classes
owned (`class_units.tsv` lists none for this unit). No first-game counterpart (Dark Cloud has no
`dng_status`; its HUD code is elsewhere).

## Types
- `SP_RGBA` (declared here; used by no other unit, no owner in `class_units.tsv`): four `int`s
  r, g, b, a, size 0x10. Evidence: `PrintV` reads `color+0/4/8/0xC` with `lw` and passes them to
  `mgCDrawPrim::Color(int,int,int,int)`; callers build it as four consecutive stack ints
  (e.g. `iStack_3a0..iStack_394` in `DrawMainUnitStatusBord`, `uStack_60..54` in the monster
  board). NULL means 0x80,0x80,0x80,0x80.
- `mgRect<int>` (from `mg_tanime.hpp`) is passed by value to `PrintV` as the glyph of digit 0:
  `left,top` = texture u,v; `right` = glyph width; `bottom` = glyph height (drawn `bottom + 1`
  high). Digit n is at u = `left + right * n`. Every caller uses `Set(0, 0xE8, 0xC, 0xC)`.
  The `mg_tanime` field names (`right`/`bottom`, "inclusive") do not fit this use; not changed here.

## Functions
- `PrintV(x, y, value, texture, glyph, digits, align_right, pitch, color)`: splits `value` into
  `digits` decimal digits (local `int[8]`, first six set to -1), drops leading zeros (at least one
  digit kept). `pitch < 0` -> glyph width. If `align_right != 0`, x += pitch * (digits - shown).
  Draws with `mgCDrawPrim` + `CPreSprite::SetIRect`, Begin(6). Callers pass 1 for "current" values
  and 0 for "max" values, pitch 10, digits 2 or 5.
- `DrawDrumCounter(x, y, value)`: five digits always (10000s..1s, leading zeros kept), 12x12
  glyphs at v=0xE8 of `TEX_SystenFrame`, 15 px apart. Only caller: robot board, value is
  `CBattleCharaInfo::GetNowAbs(0, &out)` first int.
- `DrawActiveItemCursor(int, int, float)` is LOCAL in retail (`local_symbols.tsv`, 0x1BD360), so it
  is not in the header; it must be `static` in the `.cpp`. Draws a rotating cursor (Begin(3),
  alpha blend 2, bilinear) around the active item slot; float = fade 0..1 (alpha = f*128).
  Uses function statics `cur_ang_1005` (float, starts -PI, +1 deg/frame, wraps by -8PI when > PI)
  and guard `init_1006`.
- `DrawMainUnitStatusBord(rate)` / `DrawRoboUnitStatusBord(rate)` / `DrawMonsterUnitStatusBord(rate)`:
  `rate` is `*(float*)(BattleAreaScene + 0x4C)` (passed by `DrawStatusBord`); boards are offset by
  `rate*80` vertically, main bottom panel x by `0x244 - rate*300`; main also uses `rate*128` as alpha
  for the magic sword / status icon rows; monster board draws nothing unless `rate >= 1`.
  Main board: `SubGameRunning()` forces the fully-shown position. Function statics `palanim_1023`
  / `palanim_1222` (float phase, += PI/16 per frame, -PI when > 0; sinf drives the red flash of low
  gauges) with guards `init_1024` / `init_1223`.
  Data: `at_1048__2` (0x38 = 7 x {int x, int y}, magic-sword pip positions), `at_1049` (0x20 =
  4 x {int u, int v}, pip glyph per magic-sword element), `at_1058__2` (0x1C = 7 x u32 attribute
  bit masks tested against `CBattleCharaInfo::GetAttr()`), `at_1059__2` (0x1C = 7 x {s16 u, s16 v}
  icon coordinates in `TEX_StatusIcon`). All are compiler-generated local-array initialisers, so no
  extern declarations.
- `DrawStatusBord()`: called from `DngMainDraw` (dng_main). Clears `WarningGage2` (dng_main,
  0x1ECEF60, 0x20 bytes) words +0x0, +0x4, +0x8 and `LockOnModel + 0xAC` (Ghidra `DAT_01ecef5c`;
  `LockOnModel` is 0x1ECEEB0, size 0xB0), then switches on `*(s16*)(DngUserData + 0x44D96)` =
  active character number (`CUserDataManager::SetActiveChrNo`, userdata unit): 0 or 1 -> main
  board, 2 -> robot, 3 -> monster. An enum for these values belongs in the userdata header (not
  declared here). The same values are tested in dng_main (`LoopDungeonMain`, `DngStep`) and
  dng_hud (`CLockOnModel::Draw`).
- The boards write `WarningGage2` (when shown fully): +0x0/+0x4/+0x8 low-gauge flags (hp < 0.3,
  weapon 0/1 whp < 0.2), +0x10/+0x14/+0x18 the three ratios (float), +0x1C = 1 for robot, 0
  otherwise. `DngStatus` (dng_main, 0x1ECE1E0, 0x1C): +0xC (Ghidra `DAT_01ece1ec`, int active item
  slot index; cursor x = idx*42 + 0x44) and +0x10 (`DAT_01ece1f0`, float cursor fade, +1/6 per
  frame while `CheckRunEvent` of character 0 is set, -1/3 otherwise, clamped 0..1).

## Externals used
`TEX_SystenFrame`, `TEX_DummyIcon1`, `TEX_DummyIcon2`, `TEX_StatusIcon` (maintex, `mgCTexture*`),
`DngMainScene`, `DngUserData`, `BattleAreaScene`, `DngStatus`, `WarningGage2`, `LockOnModel`
(dng_main), `GetBattleCharaInfo()`, `CBattleCharaInfo` getters, `CGameDataUsed::GetNum` (stride
0x6C between the three active item entries), `SubGameRunning()`, `CScene::GetCharacter`,
`CActionChara::CheckRunEvent`.

## C++ draft pass

All seven remaining functions have typed C++ drafts under `NONMATCHING`.
`PrintV` uses a stack digit array, `CPreSprite`, and the glyph rectangle by
value. Both durability and absorption getters write a pair of current and
maximum values into adjacent integers. The board drafts use typed
`CBattleCharaInfo`, `DNG_STATUS`, `CWarningGage2`, and `CUserDataManager`
fields. The main board's magic sword and ailment icon tables have been
transcribed as typed local arrays in the draft, with the exact values shown
by the retail data declarations.

`DrawStatusBord` matched byte for byte and passed isolated whole-image
promotion. All six other drafts compile with `NONMATCHING` but differ from
retail. The first isolated attempts for the three large board functions were
stopped at compilation because their shared draft-only gauge macro was not
visible when only one draft was enabled; the macro is now visible outside the
draft guards. `PrintV` was stopped by `mwccgap` source lookup of the mangled
template argument `mgRect<int>`. The other two first attempts reached the
whole-image comparison and differed. The default linked image remains
byte-identical.
