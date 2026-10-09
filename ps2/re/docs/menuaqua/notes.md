# menuaqua: reverse-engineering notes

`CAquarium::Draw` draws the fish, aquarium frames, bubbles, water reflection,
and menu overlays in retail order. Its native body is exact.
`CAquarium::SettingAqua` still uses a retail assembly gap.
`GyoraceMenuDraw` is native and exact.
The `SettingAqua` draft constructs its `love_chara` member as a `CCharacter2`.

`CAquarium::Step`, `DrawFishParam` and `CAquarium::ColCheck` are native and
exact; see [night-20261008.md](night-20261008.md). `GyoraceMenuKey` is native
and exact.

`CAquaFish::SetAdjustScale` (0x20F0E0, size 0x8C) is native and exact. It
computes a size-dependent scale, applies it to all three axes, and derives the
collision radius from body height. The Satan's Fiddle selector for binary32
0.95 (`0x3f733333`) evaluates that argument first, preserving retail's
0.95-before-0.6 load order. The canonical object comparison has no findings
for this method. The later sprite-call calibration below resolves the
previous `DrawEsaDropRoot` findings.

Aquarium menu (fish swim, eat food, fight, pair/breed), the gyorace (fish race) fish-select and
saved-race menus, fish race/fishing tournament prize scripts, and shared sub-game panel drawing.
No first-game counterpart (Dark Cloud has no aquarium); layouts below come from this game only.

## Saved fish-race menu

`GyoraceMenuKey` drives the saved-racer menu and returns 2 when the user exits
or a fade finishes. Mode 0 waits for the background read, enters two packed
images and a configuration buffer, then initializes the menu textures. Mode 1
dispatches main-menu cursors 0..6 to name registration, save/load, racer
assignment, racer deletion, entrant withdrawal, tactics viewing and race start.
Modes 0xA-0xC select a stored fish and its tactics; modes 0x14-0x16 ask before
deleting a stored fish; 0x1E asks before withdrawing the entrants; 0x28 displays a
racer's tactics; and 0x32 asks before starting a race. Modes
0x3C-0x42 run the save and fish-load flow, including confirmation before
replacing saved data or assigning the selected inventory fish. After a mode
change, the function updates visibility flags, list contents, selection
state, and cursor position before stepping the message windows.
`GyoraceMenuMode` names the analyzed prompt and sub-screen values; the
native mode storage remains a 16-bit integer.

`GyoraceMenuDraw` delegates name registration and save-mode drawing to their
own routines. Its normal path draws the full-screen frame and title, race
message panels, a scissored saved-fish list, tactics and selected-fish data,
and the inventory board in the load flow. It moves the animated list and
inventory cursors with `CalcMenu1` and advances the shared animation counter.
The packed archive returned by `GetPackFile` is word-addressed; the key
function views its image payload as bytes when passing it to `EnterIMGFile`
and its configuration payload as characters.

Both functions have retail-sized native bodies (`0x12AC` and `0x9B4`). The
promotion checkpoint compared `0x11C44` allocated bytes and 3,218
relocations with both functions native. The current review build compares
`0x11C10` allocated bytes and 3,340 resolved relocations with zero findings.

## Aquarium drawing

`CAquarium::Draw` restores the water ambient light while drawing the fish and
tank, then draws food, bubbles, water, the reflection walls, the menu windows,
and optional debug fish parameters. Its wall pass selects one of four vertical
quads from the camera position, offsets the vertices toward the camera, clips
them against the screen, and draws only visible quads. The water pass captures
the frame buffer before and after the surface and reflection work.

The debug panel's `DrawMenuFillBox` call receives width 120.0f and height
242.0f after top 80.0f. Retail prepares width and height before top. The pinned
MWCC floating-argument consumer has an unstable evaluate-first byte for these
constants; two callee-scoped binary32 rows in the JSON profile restore their
retail load order. With this function promoted, the whole native `menuaqua`
object checks all `0x11C3C` allocated bytes and 3,244 relocations without a
finding; standard objdiff scores its `0xE80` body at 100%.

## Class sizes (all asserted except CGyoraceFishData)
- CBubble 0x40: `__nw(0x40)` after `Alloc(6)` in `CAquarium::Initialize`/`SettingAqua`; battle
  bubbles indexed `AquaBattleBubble + n*0x40` in `CAquarium::Step`.
- AQUA_BUBBLE 0x30 (name invented): `Initialize` allocs `num*3` quadwords; stride 0x30 in
  Generate/Step/Draw.
- CAquaFishActionParam 0x40: `Initialize` is `memset(this,0,0x40)`; next field of CAquaFish at 0x700.
- CAquaFish 0x940: `__nw(0x940)` in `LoadFish` (Alloc 0x96 quadwords).
- CAquaFishEff 0x10: `__nw(0x10)` in `CAquarium::Initialize`.
- CFishFood 0x6A0: `__nw(0x6a0)` in `CAquarium::Step` (Alloc 0x6c).
- CAquaMes 0x64: member of CAquarium at 0xFC, next member (mgCMemory) at 0x160.
- CAquarium 0x3D0: `Aquarium` bss symbol extent; 16-aligned by `drop_pos`.
- NEXT_THINK_PARAM 0x20: stack copy `aNStack_80` in SettingAqua / `uStack_110` in Thinking; fields
  at 0x00 (vec), 0x10 (CAquaFishEff*), 0x14 (target CAquaFish*), 0x18 (s16 target no); 16-aligned.
- CGyoraceFishData: LoadData clears only 0x00..0x17 (s16[4] + ptr[4]); gyorace keeps it in a
  0x20 stack slot. Size 0x18 likely, not asserted.

## Vtables
`__vt__9CAquaFish` / `__vt__9CFishFood` (0xF8, in `.vtables` of this unit) equal
`__vt__11CCharacter2` except: CAquaFish slot 0x3C = `Initialize__9CAquaFishFv`; CFishFood slot
0xD4 = `Step__9CFishFoodFv`. No new virtuals. Both ctors are the inline CCharacter2 ctor chain
(mgCObject -> CObject -> CObjectFrame -> CCharacter2, shadow_link fields at 0x35C..0x364).
- CAquaFish ctor: after its vtable store, `action.Initialize()` three times, `data = NULL`, then
  virtual `Initialize()`. LoadFish also calls `action.Initialize()` three times in a row (some
  inline helper repeats it; unresolved).
- CFishFood ctor calls `CCharacter2::Initialize` non-virtually, then zeroes its own fields (pos.w=1).
- `love_chara` (CAquarium 0x390) is a plain `new CCharacter2` (inline ctor, Alloc 0x68, size 0x660)
  loaded from `menu/eff/haigou_love.chr`.

## CAquaFish (0x660..0x940)
- 0x660 target_pos, 0x670 move (added to position by ColCheck), 0x680 target_rot (x pitch,
  y yaw; LoadFish sets it from the initial rotation), 0x690 `turn`: zeroed as a vector by
  `mgZeroVector`; x = pitch step (passed to `mgAngleInterpolate` in ColCheck), y = yaw divisor
  (`PI / y`). z/w never used.
- 0x6A0 aqua_no (slot; indexes AquaFishEff/AquaFishBubble), 0x6A4 radius (`base scale*adj/0.6`
  in SetAdjustScale; *0.29/*0.26 in ColCheck), 0x6A8 think_timer, 0x6AC pair_no, 0x6AE
  think_mode (switch in Thinking, written by NextThink), 0x6B0 swim_mode, 0x6B2..0x6BF unused.
- 0x6C0 action: +0 phase (battle: 0 approach,1 start,2 swing; battle-rest: 3 go, 4 rest),
  +4 timer, +8 target_no, +0xC target (vtable call 0x18 = GetPosition), +0x10 speed / +0x14
  max_speed (round), +0x30 decel (0.8 rest, 0.7 food look), +0x34 hit_count (ColCheck adds 1, or
  6 at 8%; Thinking triggers pairing when > 0xA0 in mode 8; ParamStep raises a param when > 0xB4
  in mode 5).
- 0x700 union: round {s16 dir (0x700), float 0x704, 0x708, 0x70C} vs battle float 0x700
  (MoveActionBattle swing angle). Proven by short and float accesses at 0x700.
- 0x710 route[32] (0x710 + 32*0x10 = 0x910), 0x910 route_num (16..25), 0x912 route_no, 0x914
  route_time (>0x14 skips a point).
- 0x920 eat_item (food item no copied from food+0x680; 0x13B and 0x168 are special in
  ParamStep/ColCheck), 0x922 s8 (random 0..7 at init, reset to 0 when >7; meaning unknown),
  0x924 col_flags (cleared each ColCheck), 0x928 wall_time (round: >200 forces a turn),
  0x92C fatigue, 0x930 fatigue_max = `(data[+0x3C]/10 + rand(20) + 26) * 20`, 0x934 flash_count,
  0x938 data (CGameDataUsed*; BREEDFISH_USED is `data + 0x10`).
- ParamStep return bits: 2 = fish died (HP <= 0; 0x88 bubbles emitted),
  8 = food eaten after feeding benefits were exhausted (flag 0x80),
  0x10/0x20 = special food 0x13B toggled sex byte (+0x15 of the breed data). ColCheck return:
  bit 1 = ate food 0x168, bit 4 = battle hit.
- Think modes (enum AQUA_FISH_THINK): seen in NextThink switch and Thinking switch. Mode 2 has no
  NextThink case and does nothing in Thinking. NextThink(1) always ends with swim_mode 2 (it
  writes 0 then 2), so the swim_mode 0 and 1 branches are reached only via route/think code.
- Motion name addresses used with SetMotion (vtable 0xB0): 0x36F140, 0x36F150; SetStep is 0xB8.

## CAquaFishEff
0 fish (vtable 0x18 GetPosition in Draw), 4 texture (`Tex_FishEffect`), 8 s16 type 1..5 (texture
rows in Draw; `max_tbl_1484` gives each type's time), 0xC timer (-1 = forever).

## CFishFood (0x660..0x6A0)
0x660 spin (x,z used), 0x670 pos, 0x680 item_no (s16), 0x684 fall_time, 0x688 sway, 0x68C
sway_phase, 0x690 state (FISH_FOOD_STATE: Thinking reads it via `piVar2[0x1a4]` byte; 2 makes
fish decide 3 vs 4, 3 lets ColCheck feed). 48.0 is the water surface; 19.6 the floor.

## CAquaMes
Field order from Initialize (clears) and the seven `new ClsMes` (0x2958 bytes, Alloc 0x298):
4 title, 0x10 menu, 0x38 guide, 0x2C question, 0x44 help, 0x4C info, 0x54 fish window.
0x38/0x3C: `CAquarium::Step` writes `mes.guide_id` (offset 0x138) then `MakeMesWin(guide_mes,
guide_id)`. 0x5C/0x60 set to -1 in Initialize, never read. Cursor: Step eases 0x24 toward 0x1C by
1/3 unless 0x19 set. ClsMes offsets used: 0x19C/0x1A0 position, 0x1E3C, 0x1E59 (name string
buffer, 0x32 per line), 0x225C/0x2278/0x228C (cursor), 0x258C/0x2590 widths.

## CAquarium
- 0x00 mode (Step switch); 0x04 load buffer (`stack + used*16` of the Initialize memory).
- 0x08/0x70/0xC8/0x160/0x194+n*0x30/0x394 are mgCMemory (ctor calls `Init` on each; Clear and
  others write their `lock` (+0x1C) and `stack_used` (+0x24) directly).
- 0x38 tex_block[13]: copied from the `int*` argument (12 entries) and terminated with -1;
  `MenuDeleteTextureBlock(tex_block)`. Slots handed out: [0]->0xB4, [1]->0xB0/0xB2/0xBC,
  [2]->0x190, [3]->0x324, [4]->0x386, [5..10]->0x2CC..0x2D6. `Aquarium_NameregistBlock =
  &tex_block[5]`.
- 0x6C user_data = `GetSaveData()+0x1D2A0` (passed as CUserDataManager* in Step);
  `m_aquarium_para` = that + 0x4958 (a CFishAquarium*; first s16 is the aquarium number 0..2).
- Pack files (`menu/aqua/pack/aqua%d.pak`): aqua.img->0xB4, aqua.mds->0xA8, ground.img->0xB0,
  ground.mds->0xA0, aqua_glass.img->0xB2, aqua_glass.mds->0xA4, water.img/water_ref.img->0xBC,
  aqua_mizu.mds->0xAC, suimen.mds->0xC0; `CreateWaterFrame` -> 0xB8; aqua_naka.mds -> 0xF8 (only
  aquarium 0, into 0xC8 memory).
- 0xC4 ripple: reset to 0.1, Draw counts it down by 0.01 and passes it to the water frame; Step
  sets 0.18 when food state is 2.
- 0x2D8 sel_fish, 0x2DA/0x2FA names (strcpy targets, 0x20 apart), 0x31A/0x31C fish slots for
  pairing/special food/messages, 0x31E draw flag for the selected fish's data.
- 0x320 food, 0x330 drop_pos (initialised (0,61,0,1)), 0x340 food_time (0xFA when dropped),
  0x384 drop-line draw flag (DrawEsaDropRoot).
- 0x388 love_phase (AQUA_EVENT_PHASE: breeding uses 5 then 1..4; electric food uses 10..13), 0x38A
  counter, 0x38C tex block (= tex_block slot 0x2D0 copy), 0x390 love_chara.
- Never accessed: 0x326 (only cleared), 0x328..0x32F (padding before drop_pos), 0x344..0x383,
  0x386 (only assigned), 0x3C4..0x3CF.

## Globals
- Header externs (global in retail): `Mitouroku` char*[7] (indexed by LanguageCode),
  `AquaDeadCheck` int, `GyoraceFish` CGameDataUsed* (aquarium fish top + n*0x6C), `GyoraceData`
  CGyoRaceData* (`CSubGameData::GetGyoRaceData(SubSaveData)`), `MenuDCMsg` CDC2Mes*[9] (0x24
  extent; inventmn indexes it; `MenuDCMsg[1]` is `DAT_01efba44`).
- Everything else in the unit is LOCAL in retail -> `static` in the .cpp. Notable types:
  `Aquarium` CAquarium; `AquaBubble` CBubble*[3]; `AquaFishBubble` CBubble*[6]; `AquaFishEff`
  CAquaFishEff*[6]; `AquaBattleBubble` CBubble* (array of battle emitters, stride 0x40);
  `AquaBattleBubble_Pos` float[4]; `aquarium_xz_table`/`aquarium_y_table` new float[0x3C][4];
  `aquarium_paul_table` new {float* xz; float* y}[0x3C] (60 grid points, 10 x 6);
  `Camera__2` mgCCameraFollow* (0xC0, Alloc 0xE); `aqua_old_env` float[4][4]* (12 quadwords:
  light matrices + point light + enable); `Tex_Aqualium`/`Tex_FishEffect` mgCTexture*;
  `m_aquarium_para` CFishAquarium*; `AquaScene` CScene*.
- Data tables (all local): `esa_info` rows of 10 bytes {s16 item; s8 +2 -> breed+0x3B counter;
  s8 +3 -> +0x2C; +4 -> +0x26; +5 -> +0x28; +6 -> +0x2A; s8 +7 unused; s16 +8 -> +0x30}
  (offsets relative to BREEDFISH_USED; ParamStep adds them), terminated by item <= 0; 10 rows.
  `aquafish_info` rows of 0xC {s16 item; char* name at +4; s8 colour at +8 and +9}, 19 rows.
  `aquafish_mixTable` fish_breed_pair[171] (parent1-0x136, parent2-0x136, child-0x136).
  `ColChkPoint`/`ColChkPoint2` 9 rows, `ColChkPoint3` 6 rows of 0x20 {float pos[4]; float
  radius; 12 bytes}; `ColChkPointNum` s8[3], read with `lb` as the active tank's
  collision-point count. `aqua_bubble_generate_pos` float[3][3][4].
  `GyoracerIndexNo`/`GyoracerTacticsNo` s16[6]. `fish_save_present` FISH_PRIZE_INFO[4][3].
  Prize script data: `FishTournamentGoods` groups of 0x44 {int num; int [8] from script; 7 unused
  ints; ptr at 0x40 to num entries of 0x1C = {int; FISH_PRIZE_INFO[3]}}.
- The source defines and documents the row types beside their data: aqua_food_info,
  aqua_fish_info, fish_breed_pair, aqua_col_point, fish_prize_group and fish_prize_record.

## Functions
- File-scope `Aquarium_NameregistStack`, `Aquarium`, `GyoraceFishSelStack`, and
  `GyoraceStack` construct in that order. Native C++ definitions generate the retail
  `__sinit_menuaqua_cpp` instruction stream exactly; `CAquarium::CAquarium` also matches.
- `CAquaFish::Initialize` and `CFishFood::CFishFood` invoke the base
  `CCharacter2::Initialize` directly; qualified C++ calls match their retail bodies.
- Local (static, in .cpp): Get_aquarium_paul_table, Get_aquarium_paul_table_xz,
  local_aquarium_limmit_check (returns wall bits: 1/2 x, 4/8 y, 0x20/1 z), GetEsaInfo,
  GetChildFishNo, GetFishPath, CombineParam, _GYORACE_LISTNUM, _GYORACE_DATA, _PRIZE_LISTNUM,
  _PRIZE_GROUP, _PRIZE, GyoraceCFGAnalyze, SearchOmakeGyoracer, GyoracerListUpdate,
  OmakeGyoraceSelect, ForceSetGyoList.
- `P1` in `FishIMGReplace__FP1P...` and `LoadData__16CGyoraceFishDataFP9mgCMemoryP1` is
  `u_long128 *` (as in mg_memory). Ghidra treats LoadData as a free function; it is a member.
- GetOmakeGyoracer2 returns `CGyoRaceData::GetData(i)` (0xA0-byte entries) when its s16 at 0 is 6;
  typed `CGameDataUsed *` because callers use it as fish data (name at +0x10). Verify when savedata
  is done.
- Getters of char globals (GetGyoRace*) use `lb`; declared `int`.
- MenuAquaInit/MenuGyoraceFishSelInit/GyoraceMenuInit third parameter: meaning not established.

## AquaMode
AQUA_MENU_MODE names the enclosing MenuAquaKey flow: initialization/opening
(0/1), active input (2), closing/clear (3/4), tank fade-in/out (5/6), and
name-entry fade-out/menu/fade-in (7/8/9). Closing, clear, tank fade-out
and name-entry fade-out suppress battles and breeding in ColCheck and
Thinking. AQUARIUM_MODE names Step's independent command and prompt states;
AQUA_EVENT_PHASE names its breeding and electric-food transitions.

## Unresolved
- BREEDFISH_USED is fully defined in userdata.hpp; CalcFishParam sums its
  five racing parameters at +0x26..+0x2E. Remaining unknown fields keep
  their established widths and offsets.
- FISH_PRIZE_INFO field meanings (event_func pushes both to the script stack).
- AQUA_BUBBLE byte 0 doubles as wobble-table row (0..4) while rising and countdown (10..19) while
  popping.

## Stable fish-food call argument order

The `menuaqua.cpp` profile row for `Step__9CFishFoodFv` selects `binary32`
`0x00000000` (0.0f) with `evaluate_first: true`. It applies to every
identical literal in that function, without an occurrence counter or callee
restriction. At `local_aquarium_limmit_check`, this prepares the zero final
argument before the 1.3f collision margin, preserving retail's float
argument registers. The function still integrates food movement, limits it
to the aquarium, updates its drop/entry/sink state, and submits its position
and rotation to the character.

The native 1,044-byte body has zero differing instruction words or relocation
fields after the canonical wrapper build and `fixup_sections.sh` pass. The
current consumer-hook validation checks `0x11C80` allocated unit bytes and
2,927 relocations; the unrelated existing `SetAdjustScale` and `MenuAquaInit`
differences were present in that earlier validation; the current zero selector
for `MenuAquaInit` is verified below.

## Aquarium camera constructor floating argument calibration

`MenuAquaInit__FP9mgCMemoryPii` uses stable binary32 `0x00000000` (0.0f)
`evaluate_first: true` to restore camera constructor argument materialization
in the order 40.0f, zero, 30.0f, 8.0f. The function now matches canonical bytes
and resolved relocations. With the division primer removed and helper masks
GPR `0x30` / FPR `0`, validation checks `0x11C50` bytes and 2,970 relocations.
Before the float-order selector below, `DrawEsaDropRoot` had seven issues;
their masked instruction bytes and resolved relocation targets/addends were
unchanged by the camera constructor selector.

## DrawEsaDropRoot sprite-call float order

The retail call to `mgTransWorldPrim3DSprite` prepares the `1.0f` width before
the `0.3f` height. The default MWCC argument scheduling evaluates the `0.3f`
argument first, moving its constant setup and float-register transfer ahead of
the width. A private profile row selecting binary32 `0x3f800000`
(`1.0f`) with `evaluate_first: true`, scoped to
`mgTransWorldPrim3DSprite__FPiPiPfffi`, restores the retail instruction order.
The tracked profile also has three existing menuaqua selectors; the candidate
was tested with all three preserved and the new row appended. The full wrapper
build and canonical checker then pass the whole unit (`0x11C54` bytes and
2,970 relocations). A direct source-only MWCC object also scores 100% for this
function after mapping compiler-local `count$978` and `init$979` to the retail
`count_1612` and `init_1613` symbols in a temporary objdiff project. Without
those diagnostic aliases, objdiff reports only those three relocation names;
the canonical checker confirms their resolved values. The shared compiler profile preserves the existing selectors and adds this
callee-scoped row.

Canonical normal and objdiff-base targets also pass after integration: the
whole-unit checker reports 0x11C54 bytes and 2,970 relocations, and the standard
project objdiff reports 100% for the native 316-byte DrawEsaDropRoot.

## Historical ColCheck lifetime probes (superseded by promotion)

`ColCheck`'s private baseline compiles to 0x6F8 bytes and scores 99.31615%: 386 instructions
match and 60 have argument mismatches, with no instruction insertions or deletions. The first
mismatch swaps the saved-register roles of the selected fish pointer and loop index. Moving the
fish-pointer initialization to the first local worsens the score to 98.86996% (353 matches, 93
argument mismatches); it still emits no structural instruction differences. The native AquaMode
range predicate is already reproduced by the existing source condition.
Swapping only the declaration positions of `me` and `i`, while keeping `me = fish[no]` in its
original statement, yields 98.99327% (361 matching instructions, 85 argument mismatches). This is
closer than first-local initialization but below the unchanged baseline.
Giving the fish, obstacle, and effect-clear loops distinct local indices scores 99.06054% for
ColCheck (366 matching instructions, 80 argument mismatches); the whole unit still has the single
ColCheck byte mismatch. This improves on the declaration-position swap but remains below baseline.

## Current status and historical measurements

- `SettingAqua__9CAquariumFv`: **2/752 words**, compiled **0xBB4**, retail extent
  **0xBC0**. At **+0xA00/+0xA04**, placement new for `CCharacter2` branches on
  `v0` and copies it to `s3` in the retail delay slot. MWCC instead copies first
  and branches on `s3`. Parked under the placement-new stop rule; reconsider
  when the dedicated constructor/null-branch lane supplies a natural solution.

- `ColCheck__9CAquariumFi` is native and exact: its declared retail and
  native symbol sizes are **0x6F8** in a **0x700** aligned reservation. The
  slot null check before binding the selected fish resolves the old `s2`/`s3`
  exchange; the typed collision-point element walk preserves the exact body.
  See [night-20261008.md](night-20261008.md) for promotion and complete-object
  verification. Earlier guarded probes gave **60/448** words, **76** with
  separate loop indices, and **89** with early pointer initialization; these
  historical negative results do not describe the current implementation.

- `DrawFishParam__FiiP10mgCTextureP13CGameDataUsed` (now exact; the forms that
  match are in [night-20261008.md](night-20261008.md)). Earlier state: **652/704 words**, compiled
  **0xAA4**, retail extent **0xB00**. Retail uses a **0x450** stack frame;
  draft uses **0x430**. Fresh rectangle temporaries for the three unknown-weight
  glyphs restore the frame size but still leave **651** differing words and
  the same body length. Retail also preloads six dimension-table bytes before
  copying the width/height initializer templates; draft interleaves template
  copies and loads. Separate zero initialization and entry assignments leave
  **669** differing words with **0xAD4** compiled bytes. Reconsider with the
  original initializer/lifetime structure established from the retail loads,
  stores, and rectangle stack slots. Both probes are reverted.

- `Step__9CAquariumFv` is native and exact: its declared symbol is 0x1B04
  bytes in a 0x1B10 aligned reservation. A separate function-scope fish
  counter declared before menu/result and an ordinary cursor assignment
  before the menu switch resolve the old 39/1732 remainder. Its switch
  tables, local statics and initialization guard are now emitted entirely
  by C++. The state/result enums and signed field types preserve every
  byte and resolved relocation; see [night-20261008.md](night-20261008.md)
  and [review-fixes-20261008.md](review-fixes-20261008.md).
