# dng_event: reverse-engineering notes

Header: `ps2/include/dng_event.hpp`. All STATIC_ASSERTs compile.

## Source status

Every function is native C++ (no `NONMATCHING` guards or `INCLUDE_ASM`). The
complete object is 0x5440 bytes. Compiler-profile dependencies in
`scripts/build/satansfiddle.json`: the per-unit GPR helper mask 0x30 / FPR
helper mask 0 (replacing an unused dead-section long-division primer), and a
row for `AutoSetTreasureBox__Fv` evaluating the binary32 zero first at callee
`PutTreasureBox__19CTreasureBoxManagerFiPffiiiii` (the key-box rotation zero is
evaluated before the nested `GetKeyDoorIndex` call and kept in `f20`).

The unit's data is still largely assembly-backed: `INCLUDE_RODATA` markers for
the strings listed under "Globals", `gatekey_index`, `keydoor_key_index`,
`xchg_rot_list`, `tag__5`, `tag2`, the compiler templates `at_1082__2`,
`at_1248`, `at_1466__5`..`at_1468__5`, `at_1825__2`..`at_1829__3`,
`at_2198__2`..`at_2200__2`, `at_2446`..`at_2456`, `at_2529`, and the vtables
`__vt__9CGeoStone` / `__vt__13CRedMarkModel`; `INCLUDE_BSS` for `counter_1489`
(the `StatusWarningSnd` function-local static `counter`), `nowTbFloor`,
`nowTboxGroup`, `nowTboxItemCnt`, `FLS_FLOOR_ID` and `at_1348`. The native
functions reference these through `extern` declarations.

## Globals
Every data symbol of the unit is LOCAL in retail (`build/re/local_symbols.tsv`), so the header has
no `extern`s; they belong in the `.cpp` as `static`:
- `gatekey_index` (.data, 0x1C) `int[7]`: gate key item per dungeon (GetGateKeyIndex; dungeon 4
  floor > 16 gives 0x159 instead).
- `keydoor_key_index` (.data, 0x1C) `int[7]`: key door item per dungeon (dungeon 4 floor > 16 gives
  0x15B).
- `xchg_rot_list` (.data, 0x10) `float[4]`: loaded with `lwc1`; XChgMapRotation returns float.
- `tag__5` (.data, 0x30) / `tag2` (.data, 0x20): `SPI_TAG_PARAM` tables for the treasure box script
  (GROUP_START, GROUP, ITEM, FLOOR_START, FLOOR) and the monster script (FLS, FL, FLE).
- `counter` (.sbss, retail symbol `counter_1489`): function-local static of StatusWarningSnd.
- `nowTbFloor` (`TRESURE_BOX_FLOOR_INFO *`), `nowTboxGroup` (s32), `nowTboxItemCnt` (s32),
  `FLS_FLOOR_ID` (s32, -1 outside FLS..FLE): script parser state.
- `MainMapInfo` (.bss, 0x18) `MapJumpMapInfo` (class owned by mapjump), constructed in
  `__sinit_dng_event_cpp`. `at_1348` (.bss, 0x10) is a compiler static (DrawShadow).
- Strings: `at_1274__2` "tbox1", `at_1279__2` "tbox_a.mds", `at_1645` "way%d",
  `at_1466__5` "parts01", `at_1467__5` "w15a", `at_1468__5` "w15b",
  `at_1732__2` the SearchMapFlatPosition failure message,
  `at_1905__2` "ERR:GROUP_ID OVER!! %d\n", `at_2159` "dungeon/cfg_file/tbox_d0%d.cfg",
  `at_2447` "dungeon/minimap/%s.img", `at_2456` "dungeon/cfg_file/%s.".
- `at_1082__2` (qword) {0, -99999, 0, 1}: position that SetFlag gives the automap's gio part to hide it.

## Local (static) functions, not in the header
StatusWarningSnd, BattleAreaBGMCtrl, _GROUP_START, _GROUP, _ITEM, _FLOOR_START, _FLOOR,
PickupRandomItemCheckMax, PickupRandomItem, CheckObjectPutArea, _FLS, _FL, _FLE,
CreatMonsterFloorInfo. Script tag handlers are `int f(SPI_STACK *, int)` returning 1.
PickupRandomItem returns a `TRESURE_BOX_ITEM *` (callers read [0] item, [2] num) although m2c shows void;
it loops forever after printing at_1905__2 when a floor names an unknown group.

## CStartupEpisodeTitle (0x18; global StartupEpisodeTitle size 0x18)
0x0 s16 state (Switch stores its argument; Step: 1 fade in, 2 hold, 3 fade out, 0 off) ->
EpisodeTitleState. 0x2 s16 wait (set 0x3C, decremented in state 2). 0x4 alpha, 0x8 reveal, 0xC
slide (floats; usage in DrawEpisode/Step). 0x10 s16 width (string width - 2, min 0x9A). 0x12 pad.
0x14 ClsMes* (InitDungeonMain stores DngMess2). DrawEpisode(0x58, 0x48) from DngMainDraw: texture
blocks reloaded before DrawMesWin and before the frame sprite. Step/Switch/Clear repeat an inlined
ClsMes "close" sequence (GetDrawSpeedDef -> 0x1D0, 0x1E3C=-1, 0x1E40=0, 0x198=0, 0x194=0,
0x140/0x144=-1); probably a ClsMes inline method: check nd_meswin.hpp before writing bodies.

## MessageTaskManager (0x36C; global MsgTaskMan size 0x36C exact)
0x0 u32 flag (Step skips while bit 0; only Initialize/Clear write it). 0x4 ClsMes* (DngMess).
0x8 MESSAGE_TASK[6] stride 0x90 (Print loop). 0x368 top (head of priority list).
MESSAGE_TASK (name not retail): 0x0 char* message (points to own text; 0 = free), 0x4 char[0x80],
0x84 s8 priority (sorted ascending, ties append), 0x86 s16 time, 0x88 s16 count, 0x8A s16 slot
(-> ClsMes+0x158, the forced window slot; callers pass 8; Initialize sets 8), 0x8C next.
Initialize writes the six slots unrolled (message, priority, time, slot, next); Clear stores 0 to
0x8 six times (an unrolled loop clearing task[i].message through a non-advancing pointer?).

## CRedMarkModel : CObjectFrame (0x90 from `__nw(0x90)` in InitDungeonMain)
0x80 s32 draw_request (cleared after drawing), 0x84 float angle (+pi/16 per step, wraps by -pi
when > 0). 0x88..0x8F alignment padding (class 16-aligned). Vtable `__vt__13CRedMarkModel`
(dng_event): CObjectFrame layout with slot Initialize overridden, then two NEW slots Draw, Step
after Copy(CObjectFrame&). CObjectFrame::Draw returns int, so `virtual void Draw()` does not
override it (same as CLockOnModel in dng_hud). Initialize is inline (emitted in dng_main
0x1CF560): stores 0x80, 0x84, 0x70 (frame) in that order, no base call. Global RedMarkModel
(pointer) is in dng_main; frame set from "mgLoadMDSFile" there.

## CGeoStone : CCharacter2 (0x670 = global GeoStone size; CCharacter2 0x660)
0x660 s32 flag (SetFlag; AutoSetTreasureBox sets 1), 0x664 float angle (+pi/60 per GeoStep, wrap
at pi), 0x668 s32 anime (AutoSetTreasureBox 1, _GEOSTONE_ANIME_OFF 0; when 0 the stone is drawn at
any distance and does not bob). 0x66C padding. Vtable `__vt__9CGeoStone` (dng_event) = CCharacter2's
with Initialize replaced; no new slots. Constructed by implicit ctor in `__sinit_dng_main_cpp`.
SetFlag(0) calls `AutoMapGen.gio_parts->SetPosition(at_1082__2)` (vtable +0x10) when non-NULL.
Mini map symbol 3 = MINIMAP_SYMBOL_GEOSTONE (automap.hpp), 1 = TREASURE_BOX, 2 = RANDOM_CIRCLE.

## CRandomCircle (0x6A0 = global RandomCircle size)
0x00 sceVu0FVECTOR pos[3] (stride 0x10), 0x30 s32 active[3], 0x3C s32 hit (-1), 0x40 CCharacter2
model by value (__sinit_dng_main constructs it at RandomCircle+0x40; calls go through its vtable:
0x3C Initialize, 0x10 SetPosition(float*), 0x20 SetRotation(fff), 0x38 DrawDirect, 0xD4 Step).
SetCircle writes pos[i].w = 1.0.

## CTreasureBox : mgCObject (0x70; array stride in the manager)
mgCObject is 0x50. 0x50 float lid_open (script _SET_TB_ANGLE; Draw rotates lid by -v*45 deg),
0x54 s8 state (lb/sb; 0 empty, 1 unopened: minimap/CheckEvent/MimicCount test ==1, Draw tests !=0;
script _SET_TB_STATUS writes other values), 0x58 s32 flags, 0x5C s16 item[0], 0x5E item[1],
0x60 num[0], 0x62 num[1] (PutTreasureBox args 4..7 go to 0x5C, 0x60, 0x5E, 0x62),
0x64 mgCFrame* lid_frame ("tbox1"), 0x68 mgCFrame* frame (model->frame), 0x6C CCharacter2* model.
Vtable `__vt__12CTreasureBox` lives in dng_main (0x40 = mgCObject's 14 slots with Initialize
replaced); Initialize is inline (dng_main ctor-inlined; out-of-line copy in dng_debug 0x1BC6F0):
sb 0x54=0, sw 0x50=0, sw 0x58=1.
Flags seen: 0x41 script/AutoSetTreasureBox(int,...) default; 1 key-door box; random boxes
1|2|4 (rolled size?) | one of 8/0x10/0x20 | one of 0x40/0x80/0x200; 0x101 mimic. Only 0x100 (mimic,
MimicCount) and 0x80 (two items rolled, ScanEyePoint angle) have established meaning; the rest
are not named.

## CTreasureBoxManager (0xAA0 from `__nw(0xAA0)` in InitDungeonMain)
0x0 s32 tex_block (SetLargeModel arg 0x57; DngMainDraw reloads it before Draw), 0x4..0xF
alignment padding, 0x10 CTreasureBox box[24], 0xA90 s32 unk (zeroed only in InitDungeonMain),
0xA94 CCharacter2* model, 0xA98 CColFrame* col_frame (LoadCollisionFile; PickupCollision uses
vtable 0x10/0x1C and PickUpNearPoly), 0xA9C s32 near_box (CheckEvent; read by event_func
_GET_TBOX_PARAM/_SET_TB_*, GetDungeonEventPoint kind 1). Scene field 0x300C holds the manager.
Return values: CheckArea 1 = clear; CheckEvent/MimicCount/PickupCollision int.

## TRESURE_BOX_FLOOR_INFO (0x1A40C from `__nw(0x1A40C)` in AutoSetTreasureBox)
0x0 s16 rank_max, 0x2 s16 rank_min (CreatTresuarBoxInfo 0/100; CheckMax recomputes for a floor).
0x4 group[64] stride 0x488 {s32 group_id, s32 item_num, item[96] of {item_no, rank, num}}.
0x12204 s32 group_num (GROUP_START -1, GROUP pre-increments, Creat +1 at end).
0x12208 floor[128] stride 0x104 {s32 group_num, s32 group_id[64]} (FLOOR tag).
0x1A408 s32 floor_start (FLOOR_START tag; never read here).
TRESURE_BOX_GROUP / TRESURE_BOX_ITEM / TRESURE_BOX_FLOOR / MESSAGE_TASK are not retail names.

## Functions
- XChgMapRotation returns float (lwc1/mtc1 $f0).
- Lamb2WolfManager returns int: -1 unless chara 1 holds weapon 0x38 or 0x58; 0x58 spins
  "parts01"; 0x38 toggles frames "w15a"/"w15b" by GetTimeBand == 2.
- SearchMapEventParts(kind 0: way32..35, kind 2: way36..51, else none); writes parts and
  XChgMapRotation(i), and NULL to out_parts[1]; returns 1/0.
- GetDungeonEventPoint kinds -> DungeonEventPointKind (0 player cell snapped to 160 grid, 1 near
  box, 2/3 SearchMapEventParts kinds 0/2; also sets scene 0x2F40 and DAT_01efd64c/650).
- LoadDungeonMapFile(map, cfg, gen_flag): gen_flag OR'd into AutoMapGen.gen_flag (AUTOMAP_GEN_FLAG).
- LoadMonsterFile(int monster_no, int reset), AutoSetMonster(int, float*, float*, int): last arg
  stored to monster +0x1350 (same source as mimic num[0], ActiveMonster+0x10040).
- BattleSoundManager calls the two local sound functions.

## First game
No counterpart class in Dark Cloud 1; its CDungeonMap (dungeonmap.hpp) held treasure boxes as
TREASURE_BOX structs and trap circles as MAP_TRAP_CIRCLE, a different layout.

## DrawEpisode

`DrawEpisode__20CStartupEpisodeTitleFii` (0x28ED90, 0x2C0 bytes) draws the
message before constructing the frame sprite. Its alpha controls the frame
width, and its reveal clips the language-specific title glyphs. Language 3
uses left edge `width / 2 - 8`; other languages use `width / 2 - 0x31` and two
glyph pieces. Each branch calculates its own reveal width and retains its
left edge through scissor and glyph drawing. The alpha, fill width and reveal
conversions are native integer casts (explicit `fptosi` calls leave two
height-temporary register differences).

## SearchMapFlatPosition

`SearchMapFlatPosition__FPfP11CAutoMapGen` (0x291300, 0x410 bytes, frame
0x2BE0) selects a placed map part that the automap has not hidden, samples
vertical segments around its center (sixteen per part), and accepts a floor
polygon only when a short follow-up collision succeeds, reporting failure
after the retry count expires. Source forms the match depends on:

- The output parameter is `sceVu0FVECTOR out_pos` (header declaration too;
  the mangled name stays `Pf`). Retail spills `a0` (`out_pos`) to `sp+0xE0`,
  `a1` (`map_gen`) to `sp+0xDC` and the map pointer to `sp+0xD8`. MWCC
  allocates spill slots after the named locals with a downward bump
  allocator rounded to the type's alignment, so the vector-typed parameter
  gets a 16-byte slot and the frame becomes 0x2BE0; with `float *out_pos`
  the slot is 4 bytes and the frame 0x2BD0 (scalar alignment attributes only
  pad the frame and are not natural source).
- The active map is looked up into `CMap *const scene_map`; the working
  pointer is copied in the null test (`if ((map = scene_map) == NULL)`),
  `GetPlacPartsTable` is called on `scene_map` (retail forwards `v0` as the
  receiver without a reload) and the collision loop calls `GetColPoly` on
  `map` (reloaded from `sp+0xD8`). A local assigned from a call whose uses
  all precede the next call gets no virtual register (its uses read `r2`
  directly); a plain copy between two `CMap *` locals is always
  copy-propagated, eliminating `map` and leaving one long-lived spilled
  pointer (27-73 words). Propagation stops when the two types differ by a
  top-level `const`, so retail had two pointer variables for the map.
- The placed-parts count loop is `while ((placed->name[0] == 0) == 0)`;
  `while (placed->name[0] != 0)` fails the object check.
- `attr` is an `int` local loaded from the automap cell with `lh`; a `short`
  local adds sign-extension scheduling. The attempt counter is signed.
- The placed-parts and grid-cell walks are pointer walks; fully indexed
  `CMapParts`/`CAutoMapParts` array forms exceed the 0x410 body (0x418..0x430).

## AutoSetTreasureBox

The no-argument native body (0x292320, 0xA1C) reads the stage treasure table
into scratch memory, places eight random boxes beyond 320 units from the
event point, converts mimic monster entries into boxes, rolls up to three
random circles, and places the geostone, random stones and key box where
permitted.

## Typed event slots

`MessageTaskManager::Print` scans the six `task` slots for a free `message`
pointer. `CRandomCircle` stores three vector positions and three active flags
before its shared model; its drawing, hit checks, position access, and setup
use these typed fields directly. `CTreasureBoxManager` stores 24
`CTreasureBox` entries in `box`; placement, area checks, drawing, collision,
mimic counting, and nearest-box checks index this array. `MimicCount` counts
entries with `state == 1` and flag bit `0x100`.

`CTreasureBoxManager::SetLargeModel` writes `tex_block` and the shared model,
then gives every box its lid and frame pointers through a typed
`CTreasureBox*` cursor advanced by one box; direct `box[i]` indexing changes
MWCC's unrolling (84.46%).
