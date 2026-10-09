# editmenu: reverse-engineering notes

`MenuGeoramaStack`, `potti0`, and `potti1` are native C++ globals. Their constructors produce the retail 0x58-byte static initializer (`__sinit_editmenu_cpp`) exactly; no hand-written C-linkage initializer is needed. The rectangle initializers use their four retail edge values.

`CMenuGeorama::InitEnd` passes the memory stack's current top to `MenuCharaLoadStack::stSetBuffer`. Calling `stGetTop()` replaces the explicit stack-pointer addition and leaves the retail function byte-identical.

`MenuGeoramaAnalyzeSelect` moves the analysis cursor with two pairs of key
bits, clamps it to the page's last line, and scrolls the analysis list toward
the selected line. It caps the scroll distance, eases the list's Y coordinate
by one quarter of its remaining distance, and records scroll direction for
the request display when the top line changes. A guarded C++ draft compiles
but differs from retail.

`CMenuGeorama::CalcCursorPosition` chooses a form from the current cursor
layout, positions the cursor on a list row or named colour cell, and forces an
immediate move when `MenuGeoramaCursorForceSetFlag` is set. The build question
uses `MakeBoardDrawInfo` positions. Its guarded draft compiles but differs
from retail.

Unit: the town's Georama menu (`CMenuGeorama`, `MenuGeorama*`), the villager removal menu
(`CRemovalMenu`, `MenuRemoval*`), and the Geostone download announcement (`*DownLoadAnaunce`,
`*MenuDl3`). No first-game class corresponds: Dark Cloud 1's `editmenu.hpp` (`EditMenuInit`,
`EDIT_MENU_STATUS`) is a different, non-class menu.

## Header dependencies (unresolved at time of writing)
- `CBaseMenuClass` (owner `menusys`) is the base of both menu classes, and
  `MENUFORM_MAKEBRD_INFO` (owner `menudraw`, size 0x2C from `Init_MENUFORM_MAKEBRD_INFO`'s memset)
  is a by-value member of `CMenuGeorama`. Neither `menusys.hpp` nor `menudraw.hpp` existed, so
  `editmenu.hpp` includes them and does not compile until they do. Layout was verified by compiling
  against stubs (CBaseMenuClass = 0x10C bytes of fields + vptr at 0x10C, sizeof 0x110, virtuals
  IsCreateObject, IsMakeObject, IsAskExtend, ItemCmdAfter, InitEnd, ExitEnd; MENUFORM_MAKEBRD_INFO =
  0x2C bytes) with every field offset asserted.
- `ps2/src/editmenu.cpp` does not yet `#include "editmenu.hpp"` for the same reason; add it once
  the two headers exist.

## CBaseMenuClass (menusys) as seen from here
- ctor `__ct__14CBaseMenuClassFv` stores vptr at 0x10C, memsets 0x110 bytes. Fields used here:
  0x0 s16 state (0 keys active, 1 fading in, 2 closing, 6 materials board), 0x2 s16 step,
  0x4 u8 (InitEnd done), 0x8 pack file ptr / 0xC its size, 0x10 s32 fade value (0x80), 0x14 s16
  sub state (= open page + 1; indexes `MenuGeoramaPushFunc`), 0xFC s32 part id being built,
  0x100 s32 build count, 0x108 s8 board cursor, 0x10A s16 max buildable.
- Vtable (`__vt__14CBaseMenuClass`, 0x20): 2 header words, IsCreateObject(int,int),
  IsMakeObject(int,int), IsAskExtend(int,int), ItemCmdAfter(int,ITEMCMD_RET_PARA*), InitEnd(),
  ExitEnd(). Called as vptr+0x18 (InitEnd) and +0x1C (ExitEnd) in MenuGeoramaKey.
- `InitEnd__14CBaseMenuClassFv` (empty, 0x1FF8D0) is emitted in this unit but belongs to menusys's
  header.

## CMenuGeorama (size 0x1B900)
Size from `__nw(0x1B900)` in MenuGeoramaInit. Vtable `__vt__12CMenuGeorama` (0x37BFB0): base slots
with IsMakeObject, InitEnd, ExitEnd overridden. Constructor is inlined in MenuGeoramaInit.
- 0x110 CEditPartsInfo* / 0x114 CEditParts* / 0x118 CMapParts*: LoadGeoramaPart (kind 0/1 via
  GetePartsInfoAtID/GetePartsInfo, kind 2 via GetePlaceParts; view_parts = info->parts (+0x44) or
  the placed part). Virtual calls on view_parts: +0x10/+0x14 set position, +0x18 get position,
  +0x1C/+0x20/+0x24 rotation, +0x2C scale, +0x34 draw (MenuMapPartsDraw).
- 0x11C..0x12F: never accessed. 0x130 sceVu0FVECTOR paint colour (PaintSelect writes
  GeoramaColorList/128, alpha 1.0; UpdateGeoramaPartColor reads *127.5). The 16-byte alignment
  of this member is what rounds sizeof to 0x1B900 (last field ends at 0x1B8F8).
- 0x140 town_no from `MenuMainScene+0x2E60`, 0..9 else menu aborts. 0x144 frame counter in state 1.
  0x148 view_mode (GeoramaViewMode). 0x14C u8 set once a part is first shown (BasePush).
  0x150/0x154 top/select of open list. 0x158 GetMaxPolyn(town) - GetTotalPolyn.
  0x15C/0x160 paint select/top (MenuKeySelectCheck max 9, 8 lines). 0x164 read only by
  CalcCursorPosition sub state 8 (`sprintf("num%d")`), never written here: unk. 0x168 set when
  MenuPrevEndCode == 8 (opened to pick a paint colour; PaintSelect then exits with code 8).
  0x16C never accessed.
- 0x170 mgCMemory (Init in ctor, stSetBuffer; MenuPartsDrawStack points at it).
- 0x1A0/0x1A4/0x1A8 sort modes for ArrangePartsList list 0/1/2 (stock/make/house); 0x1AC zeroed
  only. Sort: 0 by `no` ascending, 1 name strcmp<0, 2 and 3 name strcmp>0 (wraps at >2, so 3 is
  unreachable).
- 0x1B0 count from `CEditMap::GetePlaceIDList` (editmap.hpp declares it void, but its return value
  is stored here; fix in editmap's header). 0x1B4 s32[0x180] place ids, 0x7B4 char[0x180][0x40]
  names (memset 0x600 / 0x6000).
- Four lists, each `s32 num` + `GEORAMA_PARTS_LIST_ITEM[0x180]` (0x38 stride, memset 0x5400):
  placed 0x67B4 (mode 6, GetPartsIDListNum gives num+1), stock 0xBBB8 (mode 1; no = part def id,
  num = CSaveData::GetBuildPartsNum), make 0x10FBC (mode 0; no = definition index, num =
  info->polyn[0], skipped when in PartsMakeOkTable or attr & 0x8000), house 0x163C0 (mode 4;
  placed parts with state 1 and GetPartsType()==1). Item names are not retail.
- 0x1B7C4 MENUFORM_MAKEBRD_INFO (CalcMakeBrd/MakeMsgPartsItemInfo): 4 x {u8 used, u8 enough,
  s16 need, s16 lack} at 0x0..0x18, s32 material count 0x18, s32 build count 0x1C, s32 cursor
  0x20, s32 0x24/0x28 (CalcMenuAdd animations, set 6/0 by IsMakeObject).
- 0x1B7F0 CEditPartsInfo* being built (MakePush). 0x1B7F4 GEORAMA_LIST_INFO[7] (SetGeoListInfo;
  ExitEnd copies all 14 words as s16 to MenuGeoramaSystemData+0x50..0x6A, MenuGeoramaInit restores
  pages 0-2).
- Forms (CPosDataManage::GetFormInfo names): 0x1B82C "makebrd", 0x1B830 "free_color",
  0x1B834 "field_title", 0x1B838 "CPVIEW", 0x1B8CC[7] "list_data%d", 0x1B8E8 "analyze0",
  0x1B8EC "analyze1", 0x1B8F0 SJIS name (also HouseInfoFormGrobal). 0x1B83C zeroed only.
- Per page arrays [7]: 0x1B840 target y (form.y + 45 - top*24, MenuGeoramaMessageMake),
  0x1B85C scroll bar offset and 0x1B878 scroll bar length (CalcTex, 186-px track),
  0x1B894 x/y pairs (x = form.x + 40, y eased by CalcMenu1; [5].x/.y used by the analysis page).
- 0x1B8F4 sub step of PlacePush (0..3) and CheckPointPush (0/1).

## CRemovalMenu (size 0x1500)
Size from `__nw(0x1500)` in MenuRemovalInit (ctor inlined there). Vtable `__vt__12CRemovalMenu`
overrides nothing.
`MenuRemovalInit` attaches the caller's remaining stack to `MenuGeoramaStack`, captures both menu
textures, resets the drawing camera to `(0, 0, 500)`, and constructs this menu in 0x152 quadwords
of stack storage. It then reserves 0x1180 quadwords for form data, selects the placed house from
`MenuArg.param[0]`, records its part definition and residents, hides the time, area, message and
cursor forms, and reads the common menu data. The draft differs by 14 words, principally in the
inlined constructor and stack-buffer setup; the retail assembly remains active for normal builds.
- 0x110 mgCMemory (form data), 0x140 close counter (state 2, >9 ends), 0x144 s32[0xB4] villagers
  (memset 0x2D0; MakeNPCList: party ids 1.. with status non-zero and bit 4 clear; ids 2 and 13 need
  chapter >= 5), 0x414 count, 0x418 placed house id (from global DAT_01efc668), 0x41C mgCMemory
  (model; KeyStep zeroes its +0x1C/+0x24), 0x44C = (info->id == 0x49), 0x450 = house->npc_no[0] at
  open, 0x454 CEditParts*, 0x458 its info (+0x324), 0x45C its house (+0x328), 0x460 model state
  0..3, 0x464 wait (16 frames), 0x468 villager chosen, 0x46C unused (alignment before CActionChara).
- 0x470 CActionChara (0x1030; ctor sequence CObjectFrame ctor, CCharacter2 vptr,
  CCharaFrameMatching::Initialize at +0x35C, CActionChara vptr, CRunScript at +0x6BC, memset +0x910).
- 0x14A0 form (SJIS, = HouseInfoFormGrobal), 0x14A4 u8 passed to CalcMenu1 then cleared, 0x14A8
  scroll direction, 0x14AC/0x14B0 list x/y, 0x14B4 list form (SJIS name), 0x14B8[3] parts
  "bar0","bar1","bar2" (passed as MENUFORMPARTS_TYPE** to LocalFunc_AdjustScrlBar), 0x14C4[10]
  "ULine%d" (KeyStep fills 9, ctor zeroes 10), 0x14EC "polywin", 0x14F0 "polychr", 0x14F4
  "ClipList", 0x14F8/0x14FC select/top.

## CCharaFrameMatching (size 0xC)
Only `Initialize` exists (inline, out-of-line copy at 0x1FF8A0, called from MenuRemovalInit and
menuchr's MenuMonsterBoxInit at CCharacter2+0x35C). Fields per character's `_SHADOW_MODEL` and
`_CLOTH`: count, model-frame indices, shadow-frame indices. character.hpp currently spells this
member as `shadow_link_num/shadow_link_model/shadow_link_shadow` at 0x35C; it should become a
`CCharaFrameMatching` member there (character unit's header, not edited here).

## Functions
- Static in retail (keep in the .cpp): SetEditMenuEnv, MenuGeoDebugKey, MenuPlacedHouseMessMake,
  MenuPlacedHousePosLinkMes, MenuGeoramaMessageMake, MenuGeorama{Base,Place,Make,CheckPoint}Push,
  MenuGeorama{Analyze,Paint}Select, georama_menu_local_key, MenuGeoramaPushKey. All push/select
  functions are `int (CMenuGeorama*, int key, int push)`; `MenuGeoramaPushFunc` is a 9-entry
  table (symbol size 0x24) of them indexed by sub state (entries 4, 7 and 8 NULL).
- Return types: Key functions return int (called through menumain's `menu_keyfunctbl`, result
  tested), Draw functions void (`menu_drawfunctbl`). MenuRemovalKey/Draw are tail calls to
  KeyStep / CPosDataManage::FormDraw. GetPenkiItemNo/ConvGeoramaDataNo load with `lh`: declared
  `short` (int would also fit). MenuGeoramaInit's int and MenuRemovalInit's int* parameter are
  unused.
- Push values compared: 1, 2 (cancel), 4, 8, 0x20; key bits 1/2 (left/right or up/down), 4/8,
  0x10/0x20 (page).

## Globals
Every data symbol of the unit is LOCAL in retail, so none is declared in the header; declare them
`static` in the .cpp. Types seen: `CMenuGeoPt` CMenuGeorama*, `RemovalMenuPtr` CRemovalMenu*,
`MenuMainMapInfo` CEditMap*, `MenuMapPart` CMapParts*, `MenuPartsDrawStack` mgCMemory*,
`MenuGeoramaStack` mgCMemory (0x30), `Tex_Georama` mgCTexture*, `GeoramaMes` CDC2Mes*[5],
`GeoramaMesMakeLine` s16[5], `GeoramaMesMakeManner` s8[5], `penki_item_no` s16[8],
`GeoramaColorList` float[9][3] (8 colours + {-1,-1,-1}), `tbl_957` s16[7] = {0,1,2,-1,4,-1,3},
`georama_parts_adjust_scaletable` / `_z_table` float[0x5D], `PartsMakeOkTable` s32[0x100],
`GeoramaPenkiNum` s16[8] (symbol spans 0x20), `old_menuparts_pos/rot`, `now_menu_pos_mapparts`,
`georama_adjust_position` float[4], `MenuGeoramaPushFunc` int(*[9])(CMenuGeorama*,int,int).

## Compiler flag cleanup

The local `divbyzerocheck on`/`reset` pair is redundant with the PS2 compiler
flag. Removing it leaves every section and symbol in this unit's object diff
unchanged.

## Stable floating-point evaluation flags

The `editmenu.cpp` rows in `scripts/build/satansfiddle.json` use `binary32`
IEEE bits and set `evaluate_first` to `true` for every identical constant in
the named function. They have no occurrence counter or callee restriction.

| Function | IEEE bits | Value | Purpose |
| --- | --- | --- | --- |
| `MenuGeoramaTitleDraw__FRiPfi` | `0x3f333333` | 0.7f | Materializes the cursor scale before its negative rotation angle. |
| `CalcTex__12CMenuGeoramaFv` | `0x00000000` | 0.0f | Materializes the zero minimum movement argument before the 4.0f interpolation divisor. |

The title helper draws the active georama tab and its cursor. `CalcTex`
positions the analysis progress indicator and list scroll bars before
updating the selected map part. These flags preserve the retail argument
register order without changing either function's calculations. With the
current annotation and direct-literal consumer hooks, both native functions
have zero differing instruction words and relocation fields. The canonical
wrapper build followed by `fixup_sections.sh` and `check_objects.py` passes
the whole unit: `0xC818` allocated bytes and 2,379 relocations.

## Earlier guarded draft findings

`MenuGeoramaMessageMake` populates ten lines of the georama message window, positions two footer lines, and refreshes the window. Its current C++ draft differs in thirteen register uses in the second line loop: retail assigns the loop index to `s0` and the selected name to `s4`, while MWCC makes the opposite allocation. Separating the loop index, moving the name declaration, and changing declaration order did not reproduce retail's allocation.

`CMenuGeorama::GetNowSelectEditPartsInfo` returns an edit-part description from the stock, make, or checkpoint list. Its C++ draft differs at the stock branch's epilogue: retail branches to the shared `ld ra` with `nop` in the delay slot, while the draft branches past that load and places it in the delay slot. Shared-result and sequential-condition forms did not produce the retail schedule. Both functions keep their assembly fallbacks.

## MakeDownLoadAnaunce on the 73f8e75 merged base

`MakeDownLoadAnaunce__FiP9mgCMemoryPiPiPi` is the unit's only guarded function.
The entry draft differs by 25 of 900 words with either plain wibo or the pinned
profile. The control-flow skeleton, placement constructors, integer arithmetic,
string wrapping and floating arguments already reproduce retail. The native
body is 0xE08 bytes against the 0xE10 retail extent; the tail is zero padding.

Declaring the condition iterator at function scope and narrowing the analysis
source pointer to its request loop reduces the difference to 23 words. Both
loop-local variables instead differ by 34 words; declaring the iterator before
the aggregate condition count differs by 31. The 32-byte alignment annotation
on the scalar font index can be removed without changing the 23-word result.
No new alignment annotation or compiler profile row is introduced.

All remaining differing words are stack operands at function offsets 0x480,
0x484, 0x498, 0x49C, 0x4B4, 0x540, 0x604, 0x638, 0x68C, 0x6A4, 0x6F0,
0x79C, 0x7B4, 0x7BC, 0x9B8, 0x9CC, 0x9E0, 0x9E8, 0x9EC, 0x9F4,
0x9F8, 0xA10 and 0xA1C. They are the request-source/index and condition-loop
spill slots. Branches, calls and register operands otherwise match. Existing
placement-new null branches are already exact here; the lane did not modify
them. There is no float-order remainder to propose.

**Park category:** local lifetimes/spill assignment. **Reconsider when:** retail
or type evidence establishes the original request-source/condition-iterator
scope and restores the remaining slots through natural declarations, without
new alignment attributes or codegen wrappers. Keep the assembly guard until
zero difference and a complete-unit pass.

Evidence is in `.private/receipts/bigfn-drafts/editmenu-scoped-src.log`,
`editmenu-scalar-font-index.log`, and the per-unit private experiment log. The
final guarded build comparison is `.private/receipts/bigfn-final/`.

Final guarded validation is identical to i9 in verifier, complete object-check
output and coverage. All three lane units pass; the inherited failing set stays
mg_texture, nd_meswin, actionchara and actscript (145/149 pass). Coverage stays
6,666 matched / 184 guarded / 15 assembly-only / 7 fuzzy. No target is promoted.
Comparison receipt: `.private/receipts/bigfn-final/comparison.json`.

## Nearmiss continuation order and source cleanup

The retained guarded `MakeDownLoadAnaunce` draft now differs by 19/900 words,
down from 23/900, with the same 0xE08 body in the retail 0xE10 extent. Retail
increments the aggregate condition count at +0x9E0/+0x9E8 before incrementing
the condition iterator at +0x9EC/+0x9F4. Updating `condition_num` before `con`
in the shared loop continuation reproduces these four words; their original
slots were already correct. This is independent update order, not a spill
layout difference. Every remaining scalar alignment attribute is removed;
removing them does not change the draft's code. The quadword load buffer
retains its real type and alignment.

The 19 remaining differences are the prior list excluding those four
continuation words. A separate request index, request-pass source scope,
checked source reference, shared font-height pointer and a function-scope
source after the scalar declarations all retain 19. Sharing the font pointer
changes saved-register allocation (44/900); merging the source assignment/null
test changes scheduling/body size (605/900); declaring the source first moves
earlier spills too (76/900). All are reverted. The guard remains until the
request-source and three reduced array-index spill slots match naturally.

Receipts: `.private/receipts/nearmiss-probes/editmenu/n1` through `n10`; retained
candidate `n2`. The canonical guarded complete-object check is under
`.private/receipts/nearmiss-canonical/editmenu/n2/`. No profile row is added.

## Mid-day request-pointer lifetime match (October 8)

`MakeDownLoadAnaunce__FiP9mgCMemoryPiPiPi` is now native and exact. The request
loop first checks `MenuEditAnalyzeDataSrc[no]` for NULL and skips the empty
entry, then declares `EditAnalyzeDataSrc *src` from that same table entry.
There is no call or write between the test and the declaration. MWCC shares
the table load while delaying the local pointer's lifetime until after the
empty-entry branch.

This changes only the four spill assignments that accounted for the retained
19/900-word checkpoint. The reduced condition-array indices occupy sp+0x140
and sp+0x150, the reduced request-table index occupies sp+0x160, and `src`
occupies sp+0x170, as in retail. The previous draft placed `src` at sp+0x140
and the other three spills at sp+0x150/+0x160/+0x170. Instruction order,
register operands, calls and branch layout are otherwise unchanged. No new
compiler selector, type change, alignment annotation or helper is needed.

The native body is 0xE08 bytes followed by the retail extent's eight zero
padding bytes. Canonical wrapper/fixup comparison reports zero of 900 differing
words and passes the whole unit: 0xC7E8 allocated bytes, 2,581 relocations.
Removing the assembly guard also passes the integrated unit check. All 148
other game objects retain their baseline file hashes. The full check remains
147/149, with only the inherited nd_meswin and actscript failures, and PAL
remains 0x26 differing .text bytes with every other file-backed section exact.
Coverage increases from 6,686 to 6,687 matched functions.

Natural scope trials retained 19 words for a const source pointer, a separately
named signed request index, a source object reference, and a scoped font index;
scoping the condition index instead gives 32. An unsigned request index adds a
signedness difference (20), and a reference to the global pointer slot gives
539/900 with a 0xE18 body. Those variants are not retained.

Receipts: `.private/midday/probes/editmenu/source-after-test/` contains the
source snapshot, word comparison, disassembly and complete-object check;
`.private/midday-editmenu-build.log`, `.private/midday-editmenu-objects.log`,
`.private/midday/editmenu-hash-comparison.json`, and
`.private/midday-coverage-editmenu.txt` record integrated validation.

## Initialized removal-state markers

DestroyNum_3583 and DestroyPartsName_3587 each occupy four zero bytes in
retail .sdata at 0x37C890 and 0x37C894. Their meanings remain the selected
removal quantity and part-name pointer. The earlier scalar-initializer probe
records that ordinary zero/null initialization emits .sbss; it is not
repeated. A new natural scalar brace-initializer probe (`= {0}` / `= {NULL}`)
also emits .sbss: canonical postprocessing rejects section 36 with
`cannot become .sdata`. Its receipt is
.private/fixes-r0/probes/editmenu-braced/compile.log. A different nonzero value or runtime initializer would alter the
retail state or initializer, and a wrapper/one-element array solely to change
section placement would not express these scalar variables naturally.

A zero-initialized function-local static does not avoid this difference:
MWCC emits `.sbss` storage and an initialization guard. Retail's own
`wavetable` pair `cnt$302` / `init$303` and `menuop` pair
`ManualMovieFadeCount$1253` / `init$1254` show that pattern. The former
has a four-byte counter and one-byte guard at 0x37D208 / 0x37D20C;
the latter has a two-byte counter and one-byte guard at
0x37E32C / 0x37E330. In contrast, `DestroyNum$3583` and
`DestroyPartsName$3587` are guard-less four-byte zero objects in
`.sdata` at 0x37C890 / 0x37C894. A local-static rewrite would therefore
change both the section and generated initialization behavior. The only
verified scalar spelling for that initialized section uses
`explicit_zero_data`, which is not an accepted source accommodation.

The unaccepted explicit_zero_data pragma is removed. The unit-owned extern
declarations and original initialized-data markers preserve the scalar
accesses and exact retail .sdata. These two values remain assembly-supplied
data until a natural scalar declaration reproduces that section placement.
No function guard changes.

Receipts: .private/fixes-r0/editmenu-final-{build,objects}.log:
SCES_511.90: OK and 149/149 objects.
