# dng_event: reverse-engineering notes

Header: `ps2/include/dng_event.hpp`. All STATIC_ASSERTs compile.

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
- `counter_1489` (.sbss): function-local static of StatusWarningSnd.
- `nowTbFloor` (`TRESURE_BOX_FLOOR_INFO *`), `nowTboxGroup` (s32), `nowTboxItemCnt` (s32),
  `FLS_FLOOR_ID` (s32, -1 outside FLS..FLE): script parser state.
- `MainMapInfo` (.bss, 0x18) `MapJumpMapInfo` (class owned by mapjump), constructed in
  `__sinit_dng_event_cpp`. `at_1348` (.bss, 0x10) is a compiler static (DrawShadow).
- Strings: `at_1274__2` "tbox1", `at_1279__2` "tbox_a.mds", `at_1645` "way%d",
  `at_1466__5` "parts01", `at_1467__5` "w15a", `at_1468__5` "w15b",
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

## DrawEpisode native match

`DrawEpisode__20CStartupEpisodeTitleFii` (0x0028ED90, 0x2C0 bytes) draws
the message before constructing the frame sprite. Its alpha controls the frame
width, and its reveal clips the language-specific title glyphs. Language 3 uses
left edge `width / 2 - 8`; other languages use `width / 2 - 0x31` and two glyph
pieces. Each branch calculates its own reveal width and retains its left edge
through scissor and glyph drawing.

Native integer casts for alpha, fill width and reveal use the calibrated
conversion-helper history. Explicit `fptosi` calls leave two height-temporary
register differences after the branch calculations are corrected. With casts,
no new float selector is needed; the existing TU masks are GPR 0x30/FPR zero.
The baseline draft differed in 83/176 words (0x294 vs 0x2C0); the promoted body
has zero byte or resolved-relocation differences. Canonical wrapper/fixup checks
pass the complete unit: 0x5440 bytes and 876 relocations.

## SearchMapFlatPosition guarded checkpoint

Superseded by [night-20261008.md](night-20261008.md): the function matches.

`SearchMapFlatPosition__FPfP11CAutoMapGen` selects a placed map part that the
automap has not hidden, samples vertical segments around its center, and accepts
a floor polygon only when a short follow-up collision succeeds. It tries sixteen
segments per part and reports failure after the retry count expires.

Under the checked-in Satan's Fiddle profile its existing guarded draft differs
in seven of 260 words, all spilled-pointer stack offsets: +0x2C/+0x374/+0x380
use sp+0xEC instead of retail sp+0xE0; +0x34/+0xFC use sp+0xE8 instead of
sp+0xDC; +0x44/+0x1E8 use sp+0xE0 instead of sp+0xD8. Frame size is 0x2BE0.
The draft still contains artificial `ActiveDngMap`/`Ident` wrappers and scalar
alignment attributes, so this near-match is not promotable natural source.

Direct scene/map method calls with a combined assignment/null test give eight
word differences: the same seven stack offsets plus a reload before the placed
parts query. Removing the scalar alignment attributes gives 53/260 differences
and a 0x2BD0 frame. SDK vector aliases and a named scene receiver do not recover
the missing frame space. These less accurate drafts are not retained. This is a
stack-layout/register-lifetime blocker, with no demonstrated float-order row.
Reconsider when a natural collision-buffer and pointer-lifetime layout produces
retail's sp+0xD8/sp+0xDC/sp+0xE0 spills and 0x2BE0 frame without the artificial
wrappers or scalar alignment attributes.

## AutoSetTreasureBox

The no-argument native body reads the stage treasure table into scratch memory,
places eight random boxes beyond 320 units from the event point, converts mimic
monster entries into boxes, rolls up to three random circles, and places the
geostone, random stones and key box where permitted. Its earlier rotation
scheduling difference is resolved by the stable compiler selector below.

## Typed event slots

`MessageTaskManager::Print` scans the six `task` slots for a free `message` pointer. `CRandomCircle` stores three vector positions and three active flags before its shared model; its drawing, hit checks, position access, and setup can use these typed fields directly. `CTreasureBoxManager` stores 24 `CTreasureBox` entries in `box`; placement, area checks, drawing, collision, mimic counting, and nearest-box checks index this array. `MimicCount` counts entries with `state == 1` and flag bit `0x100`. These typed accesses reproduce the retail code without byte offsets.

`CTreasureBoxManager::SetLargeModel` writes `tex_block` and the shared model, then gives every box its lid and frame pointers. Direct `box[i]` indexing changed MWCC unrolling and scored 84.46%; a typed `CTreasureBox*` cursor advanced by one box preserves the retail loop and scores 100%.

## Compiler helper history and treasure-box rotation

The unused dead-section long-division primer is replaced by the per-unit
Satan's Fiddle GPR helper mask 0x30 and FPR helper mask 0. Private normal
wrapper/fixup checks preserve every allocated-section byte and resolved
relocation from the primer baseline.

`AutoSetTreasureBox()` evaluates the key-box rotation zero before the nested
`GetKeyDoorIndex` call, retaining it in f20 for `PutTreasureBox`. The stable
binary32 zero evaluate-first selector scoped to that latter callee reproduces
the retail order. The complete unit checks exactly:0x5440 bytes,869 relocations.

## Nearmiss receiver and scratch trials

Six new source hypotheses do not improve the retained 7/260 guarded draft.
A named initial receiver with a separate assignment/null test gives 73/260;
making the persistent map pointer const also gives 73/260. A collision-scratch
aggregate follows retail's contiguous polygon/box/hit/result storage but emits
0x418 bytes (retail extent 0x410), with a 0x2BD0 frame; it is reverted.

Capturing the GetMap return separately, then using a combined assignment/null
test for the persistent map and the captured pointer for GetPlacPartsTable,
produces the retail 0x2BE0 frame without wrappers or scalar alignments. It
still differs by 33/260 words: the entry gains a pointer spill/reload pair,
map spills at sp+0xD0 instead of +0xD8, and the input pointers spill at
sp+0xE8/+0xEC instead of +0xDC/+0xE0. Limiting the captured receiver to the
initial lookup block leaves this 33-word result unchanged. Testing the fresh
call directly and only then assigning the persistent receiver falls back to
53/260 with the 0x2BD0 frame and one reload before GetPlacPartsTable.

All trials are reverted. The natural frame-size remainder is now demonstrated
as a pointer-lifetime effect, but promotion still requires retail return-value
forwarding and all three pointer slots without the inherited wrappers or
alignment attributes. Reconsider that narrower receiver-lifetime problem;
another vector typedef or scratch aggregate has negative evidence. Receipts:
`.private/receipts/nearmiss-probes/dng_event/n1/` through `n6/`, including
`n5-corrected/`; the target-scoped 33-word candidate is `n6/`. No header or
compiler-profile changes are proposed.

## Mid-day receiver lifetime bounds (October 8)

The refreshed queue contains only `SearchMapFlatPosition__FPfP11CAutoMapGen`
in this unit; the no-argument treasure-box placement body is already native.
The canonical source checkpoint remains 7/260 words and a 0x410 body, with
its inherited helper wrappers and scalar alignment annotations. It is not
promoted or changed by this lane.

Private natural receiver variants confirm the previous 33-word bound when
separate placement/collision pointers preserve the 0x2BE0 frame. Replacing the
collision receiver with a reference raises that variant to 52 words. A direct
assignment/null test, a reference to the scene or map, and scoped polygon count
and collision-loop variables give 53 words and the smaller 0x2BD0 frame.
Binding the active-map result to a const pointer reference emits 0x418 bytes
and differs by 249 words. A condition-declaration or positive-assignment scope
emits 0x40C bytes and differs by 247 words. None restores the entry result
forwarding together with the three retail pointer spills.

`attr` is loaded from the automap cell with `lh`, but making the local a short
adds sign-extension/control scheduling and gives 196 words with a 0x418 body;
the integer local is retained. An unsigned attempt counter adds one comparison
word to the natural direct-call draft (54 versus 53). SDK vector typedefs do
not change the direct-call result. These tests need no header or selector row.

Remaining blocker: a natural receiver lifetime that preserves retail's
sp+0xD8 map, sp+0xDC automap, sp+0xE0 output and 0x2BE0 frame without the
existing wrappers/attributes. All trials are private and reverted. Receipts:
`.private/midday/probes/dng_event/` and
`.private/midday/m2c/SearchMapFlatPosition__FPfP11CAutoMapGen.txt`.
