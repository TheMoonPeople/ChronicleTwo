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

## Current C++ status

All seven functions are matched C++. The four main-board tables are local
array initialisers in `DrawMainUnitStatusBord`, so the unit's `.data` comes
from the compiler and no `INCLUDE_RODATA` remains. The `.sbss` statics stay
as `INCLUDE_BSS` entries with extern function-scope declarations, as in the
other boards.

## Number glyph calls

All status-board callers pass `mgRect<int>` glyph bounds to `PrintV` by value. The MWCC ABI passes the aggregate through its address, so native `PrintV(..., rect, ...)` calls reproduce the same code as the former linker-name aliases.

## Division-check pragma

The unit-level `divbyzerocheck` pragma was redundant with the global MWCC flag; removing it left the full compiled object identical in objdiff.

## Native primitive constructors

The former `MG_DRAWPRIM_MANUAL_CTOR` macro suppressed normal `mgCDrawPrim` construction throughout this unit. Removing it and the explicit constructor aliases makes `PrintV`, `DrawDrumCounter`, the active-item cursor, and the status boards construct their `CPreSprite` locals through C++. `DrawRoboUnitStatusBord` declares its two sprites immediately before first use, after calculating gauge colours, so the calls retain retail order.

## Main board matching constraints

- The tail is `if (rate < 1.0f || SubGameRunning() != 0) { return; }`
  followed by the unconditional `WarningGage2` writes. An `||` condition
  ending in `return` makes MWCC emit `beqz v0, body; b exit; ld ra` and
  changes delay-slot filling for the whole function: conditional branches
  are not filled from the fall-through block, a slot filled from the branch
  target leaves the original instruction in place, and target blocks that
  start with `lui $at` are not used as fills. A nested
  `if (rate >= 1.0f) { if (SubGameRunning() != 0) return; ... }` produces
  `bnez v0, exit`, fills those slots, and is 0x38 bytes short.
- Named locals take frame slots in declaration order. `weapon_x` and
  `second_weapon_x` precede `hp_max`/`hp_now`, then the four separate
  durability and absorption output pairs (sp+0x480..0x49C). `int x[2]`
  arrays go after other aggregates; `int x[2][2]` keeps declaration order.
- The seven number glyphs are `mgRect<int>(0, 0xE8, 12, 12)` temporaries
  passed straight to `PrintV`; retail calls `Set` on the argument slot.
  These temporaries change how the next function compiles: with them in
  place, `DrawRoboUnitStatusBord` must pass its named glyph rectangles,
  because temporaries there add a second `Set` call per glyph.
- The charge-pip and status-icon loops use block-scoped `int i` counters.
  The shared `index` stays for the item loop; giving that loop its own
  counter moves the position registers.
- The magic-sword and status-icon rows pass `(int) (128.0f * rate)`
  directly to `Color`; MWCC keeps the single conversion in `v0`, spills it,
  and reloads it for the second row. A named alpha local reloads it for the
  first row as well.
- Each gauge computes its width first, `width = (int) (95.0f * ratio);`,
  then `gauge_left = x + offset; gauge_right = gauge_left + width;`. This
  places the `weapon_x` reload after the `fptosi` call.
- `element` is declared before `charge_now`, `weapon_no` is loaded before
  `second_weapon_no`, and both weapon numbers are `int`. The colour blocks
  set `color.a = 0x80` inside each branch.
- `x > 211` and `GetNum() > 1` give retail's `slti at` branches; `>= 212`
  and `>= 2` build the comparison in `v0`.
