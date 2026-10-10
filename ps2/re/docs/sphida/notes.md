# sphida: reverse-engineering notes

Sphida is the golf-like minigame on dungeon floors. Event scripts (`_SPHIDA_*` in `event_func`)
create and drive it; `dng_main` steps/draws it; `actionchara`/`editctrl` collide against its pin.
No corresponding class in the first game.

All twenty unit functions now match as native C++, including status-sprite drawing. The
current selector and whole-PAL acceptance evidence is in [the October 8 night
assessment](matching-constraints.md). Dated guarded results below retain their
historical compiler and source baselines. All initialized data and BSS storage are
native; the unit has no data reservation markers. The seven-entry `GolfClubDef` table
occupies 0x54 bytes within a 0x60-byte aligned piece, whose tail is supplied by object
preparation.

## CPowGage (size 0x24, asserted)
Size: it is the first member of CSphida, and CSphida's next field (`tex_bank`) is at 0x24.
No vtable. `CSphida::CSphida` calls `CPowGage::Initialize` on `this`, so the gauge's
constructor is modelled as an inline `CPowGage() { Initialize(); }`.

| Off | Field | Evidence |
|---|---|---|
| 0x00/0x04 | `pos_x`/`pos_y` float | `InitStatusSprite` stores 256.0/406.4; `_SPHIDA_GET_PG_CURSOR_POS` returns `pos_x + 104 - count*6.5`, `pos_y - 32` |
| 0x08 | `texture` mgCTexture* | `InitStatusSprite` stores `mgTexManager.GetTexture(at_1221__5, -1)` |
| 0x0C | `power` float | `Step` state 1: `count / 40.0`; `_SPHIDA_GET_SHOT_POW` |
| 0x10 | `safe_level` s32 | `Initialize` = 2; `_SPHIDA_SET_POWGAGE_SAFE_LEVEL` clamps 1..6; `Step` state 4 compares count to `safe_level*0.5` / `*1.5` |
| 0x14 | `code` s32 | `Initialize`/reset = -10; `_SPHIDA_GET_POWGAGE_CODE` |
| 0x18 | `count` s32 | cursor step counter, 0..40 (0x27 cap), down to -7 |
| 0x1C | `state` s32 | switch in `Step`; `Initialize` = -1; `_SPHIDA_START_POWGAGE` = 0; `_SPHIDA_TRIGGER_POWGAGE` 1->2, 3->4 |
| 0x20 | `reverse` s32 | set to 1 when count reaches 40 |

`PowGageState`: -1 idle, 0 start (resets then falls into 1), 1 charge, 2 charge set (runs to
40 then becomes 3), 3 impact (count-- ; below -7 -> code 4, idle), 4 judge (-> idle).
`PowGageCode`: -10 none, 0 just (count == 0), 4 late (passed impact point), 5 no power (charge
went back to <1 without trigger). Judge codes: count > 1.5*safe -> -3; 0.5*safe < count <= 1.5*safe
-> -2; 0 < count <= 0.5*safe -> -1; mirrored 1/2/3 for negative counts.

## CSphida (size 0x240, asserted)
Size: `_SPHIDA_SET_UP` does `new(Alloc(0x26)) CSphida` with `__nw__FUiP1(0x240, ...)`.
No vtable of its own.

| Off | Field | Evidence |
|---|---|---|
| 0x00 | `pow_gage` CPowGage | see above |
| 0x24 | `tex_bank` | `_SPHIDA_GET_TEXB`; SetUp argument |
| 0x28 | `play_flag` | `_SPHIDA_SET_PLAY_FLAG`; gate in Step/Draw/PickupCollision/DrawMiniMapSymbol |
| 0x2C | `minimap_flag` | `_SPHIDA_SET_MINIMAP_FLAG`; Draw scrolls `map_view_pos` |
| 0x30 | `mm_line_flag` | `_SPHIDA_SET_MM_LINE_FLAG`; DrawMiniMapSymbol draws the 5 line points when == 1 |
| 0x34 | `status_flag` | `_SPHIDA_SET_STATUS_FLAG` |
| 0x38 | unk (8 bytes) | never accessed; ends at the 16-byte-aligned vector array |
| 0x40 | `mm_line_pos[5]` sceVu0FVECTOR | Initialize zeroes 5 vectors stride 0x10; `_SPHIDA_SET_MM_LINE_POS` (index < 5) |
| 0x90 | `pin_pos` | `_SPHIDA_GET/SET_PIN_POS`; PickupCollision distance < 80 |
| 0xA0 | `ball_pos` | `_SPHIDA_GET/SET_BALL_POS`; Step distance <= 40 (shot) / <= 160 (menu) |
| 0xB0/0xB4 | `pin_col`/`ball_col` | `_SPHIDA_*_PIN_COL`/`_BALL_COL`; minimap symbols 4/5 and 6/7 |
| 0xB8 | `par_count` | `_SPHIDA_GET/SET_PAR_COUNT` (+1 / ignored under DebugFlag); Step: < 2 -> event 3002 |
| 0xBC | unk (4) | never accessed; padding before the aligned CRedMarkModel |
| 0xC0 | `red_mark` CRedMarkModel (0x90, `dng_event.hpp`) | ctor stores mgCObject/CObject/CObjectFrame/CRedMarkModel vtables at 0xC0; `+0x140` = `red_mark.draw_request` |
| 0x150 | unk (0x48) | never accessed |
| 0x198 | unk (6) | ctor `memset(this+0x198, 0x80, 6)`; no other use found |
| 0x19E | unk (0x42) | never accessed |
| 0x1E0 | `map_view_pos` vector | Step copies ball_pos in on the shot event; Draw scrolls x/z by 120 and passes it to CMiniMapSymbol |
| 0x1F0 | `mini_level` | `_SPHIDA_GET_MINI_LEVEL`; Step loads it from `DngSaveData+0x1c588` when nonzero |
| 0x1F4/0x1F8 | `spin_mark_pos_x/y` float | `_SPHIDA_SET_SPIN_MARK_POS`; Step zeroes them |
| 0x1FC | `club_no` | `_SPHIDA_SET_CULB_NO`; DrawStatusSprite passes it to GetSphidaClubDef |
| 0x200 | `carry` float | `_SPHIDA_CALC_CARRY`; DrawStatusSprite: `(power - power*carry) * cos/sin(carry)` |
| 0x204 | `last_challenge` | `_SPHIDA_GET/SET_LAST_CHALLENGE`; Step |
| 0x208 | `col_model` CColFrame* | SetCollisionModel = `LoadCollisionFile(...)`; PickupCollision calls vfunc +0x10 (position) then `PickUpNearPoly` |
| 0x20C | `omake_mode` | `_SPHIDA_GET_OMAKE_MODE`; Step: == 1 -> event 3003 |
| 0x210 | unk s32[9] | Initialize zeroes 9 words (unrolled-by-8 loop + remainder); not read anywhere found |
| 0x234 | unk (0xC) | never accessed; up to the 0x240 size |

## Functions
- `Step()` returns int: 1 when an event (3000..3003, `SphidaEvent`) was started, else 0;
  `DngMainKey` uses the result.
- `SetCollisionModel` returns `col_model != 0`; Ghidra types it bool, declared `int`. If the body
  does not match, try `bool`.
- `PickupCollision` takes `mgVu0FBOX` by value (copied to the stack, passed as `const&` to
  `CColFrame::PickUpNearPoly`).
- `_SPHIDA_SET_UP` mode 0 -> `SetUp(tex_bank)`, 1 -> `s17_SetUp(tex_bank)`, 2 -> `Omake_SetUp(course, tex_bank)`.

## Globals
- `GolfClubDef` (.data, 0x54 = 7 x GOLF_CLUB_DEF, retail LOCAL): clubs 9..14 then a zero row.
  It is `static` in sphida.cpp and not declared in the header.
  power = 38, 40, 42, 46, 44, 50; unk_4 = 0.2, 1.6, 2.6, 2.6, 4.0, 1.2; unk_8 = 6, 4, 5, 3, 2, 1.
  `_SPHIDA_GET_CULB_DEF` returns all three to scripts; only `power` is used in this unit.
- `Sphida` (.sbss, 4): `CSphida*`; `InitSphida` clears it, `GetSphidaPtr` returns it.

## Unresolved
- Meaning of `GOLF_CLUB_DEF::unk_4` (float) and `unk_8` (int).
- 0x150..0x1E0 (apart from the 6 bytes set to 0x80) and 0x210..0x240 have no observed readers.
## Compiler flag cleanup

The local `divbyzerocheck on`/`reset` pair is redundant with the PS2
compiler flag. Removing it leaves every section and symbol in the unit's
object diff unchanged.

## Full-section verification of SetUp

`CSphida::SetUp` already reproduces the complete 0x480-byte PAL function,
including all relocation targets, in the pre-merge isolated object. The progress
report previously showed a 59.51% function row because exported switch labels
split the cases into additional symbols. Localizing those labels in the
objdiff target restores the complete 0x480-byte function and its 100% row
with the project's relocation comparison setting. This is a reporting
correction, not a new native match.
After the required `fixup_sections.sh` object preparation,
`check_objects.py` passes the entire unit: 0x313C bytes and 438
relocations. Upstream also reports an isolated whole-image match. These checks
precede the merge; the merged unit still requires canonical revalidation.
Intermediate `.dead` sections are compiler data copies
supplied by placeholders; the normal preparation stage removes them.

`decompile.sh SetUp__7CSphidaFi` cannot resolve the named switch jump
table at its indirect jump. Existing type analysis plus the full retail
disassembly establishes the setup behavior. The function chooses pin
and ball positions outside treasure-box/random-circle exclusion areas,
settles the ball against collision polygons, chooses their colors,
computes par from navigation distance on stages 0/3/4/5/6 or direct
distance otherwise, clamps par to 99, copies the red-mark model and
initializes status sprites. The second exclusion loop tests the pin
against RandomCircle in retail, even though it is choosing the ball.

## CPowGage::Draw floating argument order

Merged source had one canonical mismatch at 0x002EE3A8. Retail prepares the sprite height 28.0f before the width 18.0f on the side caps. A stable Satan’s Fiddle selector for Draw__8CPowGageFv, binary32 bits 0x41e00000, evaluate_first true reproduces the argument order across all matching sprite calls without source changes, ordinals or compiler register tricks. The prepared isolated unit passes all 0x3134 allocated bytes and 438 resolved relocations.

## DrawStatusSprite selector limits

DrawStatusSprite is native and exact; [the matching constraints](matching-constraints.md)
record its 41-row profile and source identities. Callee-only floating policies left
134 of 1,096 words different because calls sharing constants need different schedules.
Individual extra-literal policies did not improve that score. Source condition and
sibling argument identities distinguish the required schedules without call ordinals.

## Status-sprite argument types

CSphida::DrawStatusSprite uses (sceVif1Packet *) NULL to select the
ReloadTexture overload. Its float(...) literals perform double-to-float
conversion and participate in the documented floating scheduling rows;
cos/sin and division casts likewise change type. The retail body is 0x111C
at 0x2EF390.
