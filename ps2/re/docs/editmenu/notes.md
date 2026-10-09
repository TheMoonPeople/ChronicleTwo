# editmenu: reverse-engineering notes

## Status
All 61 functions in `ps2/src/editmenu.cpp` are native C++ definitions and match retail (including
`MakeDownLoadAnaunce`, `MenuGeoramaMessageMake`, `CMenuGeorama::GetNowSelectEditPartsInfo`,
`MenuGeoramaAnalyzeSelect`, `CMenuGeorama::CalcCursorPosition` and `MenuRemovalInit`); the unit
has no `INCLUDE_ASM` or `NONMATCHING` guards. `editmenu.hpp` includes `menusys.hpp`
(`CBaseMenuClass`) and `menudraw.hpp` (`MENUFORM_MAKEBRD_INFO`, 0x2C from
`Init_MENUFORM_MAKEBRD_INFO`'s memset); every field offset is asserted.

Unit: the town's Georama menu (`CMenuGeorama`, `MenuGeorama*`), the villager removal menu
(`CRemovalMenu`, `MenuRemoval*`), and the Geostone download announcement (`*DownLoadAnaunce`,
`*MenuDl3`). No first-game class corresponds: Dark Cloud 1's `editmenu.hpp` (`EditMenuInit`,
`EDIT_MENU_STATUS`) is a different, non-class menu.

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
cursor forms, and reads the common menu data.
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
Every data symbol of the unit is LOCAL in retail, so none is declared in the header. All 119 data
objects are native C++ definitions in `editmenu.cpp`, ordered by retail address (the
constructor-bearing `MenuGeoramaStack`, `potti0` and `potti1` keep their relative order so the
compiler emits the exact 0x58-byte `__sinit_editmenu_cpp`; the rectangle initializers use their
four retail edge values). Every string is inline at its use, with bytes above ASCII written as
three-digit octal escapes so Shift-JIS text is independent of the editor encoding. The unit has
no `divbyzerocheck` pragma: the global flag covers it.

Linkage: definitions are `static` except `HouseChildPartInfo` (`char *[22]`, 0x58) and
`PartsMakeOkTable` (`int[256]`, 0x400), which keep external linkage because the generated VU
program data object (`Vu_progmain`) contains cross-unit relocations naming them; making either
`static` fails the link with `Symbol not found`.

Named state (`.bss`/`.sbss`, types from their accesses): `CMenuGeoPt` CMenuGeorama*,
`RemovalMenuPtr` CRemovalMenu*, `MenuMainMapInfo` CEditMap*, `MenuMapPart` CMapParts*,
`MenuPartsDrawStack` mgCMemory*, `MenuGeoramaStack` mgCMemory (0x30), `Tex_Georama`
mgCTexture*, `GeoramaMes` CDC2Mes*[5], `GeoramaMesMakeLine` s16[5], `GeoramaMesMakeManner`
s8[5], `HouseChildPartInfo` char*[22] (house, resident, up to twenty children), `DownLoadMes`
CDC2Mes*[6], `GeoBoardListTitlePutOffset` int[5][2], `GeoBoardListTitleTexRect` float[5][4],
`GeoRequestBoardCheckPoint` float[4], `GeoRequestBoardCheckPoint_P` int[2],
`MenuEditAnalyzeDataSrc` EditAnalyzeDataSrc*[32], `MenuEditAnalyzeDataSrcListHTable` float[16],
`GeoramaReqMsgFont` CFont*[48], `GeoramaReqMsgFontGyouNum` s8[48], `GeoramaReqMsgTexH` s16[48],
`GeoramaReqMsgFontDrawFlag` s8[48], `GeoramaPenkiNum` s16[16] (only the first eight are read as
paint quantities), `PartsMakeOkTable` s32[0x100] with `PartsMakeOkTableNum`, the placed-house
panel state (`HouseDrawInfo` CEditHouse*, `HouseInfoFormGrobal` CMenuPosDataForm*, `HousePartsID`,
`HouseInfoSelectLine`/`HouseInfoSelectSelect` s16, `HouseInfoSelectMoveInit` s8,
`HouseInfoSelectY`, `HouseInfoCursorAlphaOnOff`, `HouseInfoCursorAlpha`, `HouseInfoCursorY`), the
Geostone download announcement state (`DownLoadInfo`/`DownLoadInfoNext` DownLoadEntry*,
`DownLoadInfoEndFlag`/`DownLoadInfoDrawFlag`/`DownLoadMesMakeProgress`/`DownLoadMesMakeNo` s8,
`DownLoadWinRect` DownLoadRect, `DownLoadDispNum`/`DownLoadProgress`/`DownLoadMesUpY` s16,
`DownLoadMesAlpha` int, `DownLoadActiveMes` ClsMes*, `MenuGeoStoneDonwLoadFlag` s8,
`MenuGeoStoneDownLoad_PartsNum`/`_Request` u16, `MenuGeoStoneDownLoadTime` u32,
`MenuGeoStoneDmyCnt`/`_Now` GeoStoneDmyCnt*), the georama menu state (`MenuGeoramaSystemData`
MenuGeoramaSystemInfo*, `MenuGeoramaCursorForceSetFlag`/`GeoramaMesPosForceSetFlag`/
`GeoramaMesForceMakeFlag`/`GeoramaMesForceMakeFlag_PaintVer`/`old_menuparts_pos_flag`/
`NowPolyGonFormMoveFlag` u8, `GeoRequestFlag` GeoRequestCheck*, `MenuGeoramaViewNowPicNo` s16,
`MenuGeoramaViewWallPic` mgCTexture*, `MenuEditAnalyzeSrc` EditAnalyzeSrc*,
`MenuEditAnalyzeDataSrcNum`/`MenuEditAnalyzeDataSrcListLimmitNum` s16,
`MenuEditAnalyzeDataSrcListH`/`_Move`/`GeoAnalyzeCheckPointScrlBarY` float, `MenuAnalyzeData`
EditDataAnalyze*, `GeoramaParts_DrawWaitCnt`/`GeoramaReqMakeLine`/`GeoramaReqMakeManner` s16,
`menu_georama_title_pos` float[2]).

Initialized data: `old_menuparts_pos`, `old_menuparts_rot`, `now_menu_pos_mapparts` and
`georama_adjust_position` are four-float vectors in `.data` (zero components stay initialized
data, not BSS); `GeoramaColorList` float[9][3] (8 RGB paint colours + `{-1,-1,-1}` unpainted
sentinel); `georama_parts_adjust_scaletable` / `_z_table` float[93] (per-definition preview
scale and depth; decimal literals round-trip to the retail binary32 values); `penki_item_no`
s16[8]; `MenuGeoramaPushFunc` (9 handlers, entries 4, 7 and 8 NULL); `DownLoadMesScrlGyouNum`
s16 = 1; `analyze_percent` int = 100; `GeoramaReqMakeFlag` s8 = 1; the `GeoramaMessageList`
enum records that list slot 3 is the placed-part list and slot 4 the house list, and
`GeoramaInitialMessage` names the initial system message IDs whose base-relative offsets the
signed-byte table holds. Tables consumed by the flat short-rectangle drawing APIs keep their
flat declarations; two-dimensional tables keep their real rows. All data is writable where the
pointer-consuming APIs take mutable types.

Function-local statics (retail `name$NNNN`; the owning function holds each definition):
| Static | Owner | Meaning |
|---|---|---|
| `tbl` (`tbl$957`) | `ConvGeoramaDataNo` | s16[7] = {0,1,2,-1,4,-1,3}; -1 for views without a part list |
| `fname` (`fname$1013`) | `MenuGeoramaInit` | `char *[2] = {"georama0.pac", NULL}` |
| `GeoAlpha` / `init` (`$1199`/`$1200`) | `MenuGeoramaKey` | model-preview fade opacity while closing, and its once-only guard |
| `viewmode_to_mode_convtable` (`$1310`) | `MenuGeoramaListDraw` | s8[7] view-to-action map (one-based action numbers from the view enum) |
| `brdtbl_active` / `brdtbl_noneactive` / `ScrlBarTable` (`$1314`/`$1315`/`$1320`) | `MenuGeoramaListDraw` | s16[12] board and scrollbar texture rectangles |
| `brdtbl_noneactive` / `brdtbl` / `offsettable` / `rectboxtbl` / `maintopicbtn` (`$1547`/`$1550`/`$1551`/`$1555`/`$1568`) | `MenuGeoramaAnalyzeDraw` | s16[12] board rectangles, float[2][2] offsets, s16[12] rectangle box, s16[2][2] analysis topic-button origins |
| `postbl` / `offset` / `jyunintbl` (`$2175`/`$2176`/`$2187`) | `MenuPlacedHouseDraw` | s16[8][4] texture rectangles (eight rows, including the extra retail row), s16[7] language-specific title offsets (seven languages), s16[2][4] resident labels |
| `cnt` / `init` (`$2177`/`$2178`) | `MenuPlacedHouseDraw` | eighty-frame scroll-arrow blink counter (not a resident count) and its guard |
| `Dmy` / `init` (`$2314`/`$2315`) | `MenuPlacedHouseMessMake` | blank name for missing placed-house information and its guard |
| `constant_msg_xyoffsettbl` (`$2427`) | `MenuGeoramaMessageMake` | s16[5][4] message-column positions |
| `msgtbl` (`$2587`) | `CMenuGeorama::InitEnd` | s8[5] initial list message offsets |
| `dmychar` / `init` (`$3207`/`$3208`) | `MakeMsgPartsItemInfo` | blank display name for unused list rows and its guard |
| `edparts_info` / `init` (`$3580`/`$3581`) | `MenuGeoramaPlacePush` | definition of the placed part selected for removal and its guard |
| `DestroyNum` (`$3583`) | `MenuGeoramaPlacePush` | selected removal quantity |
| `DestroyMaxNum` / `init` (`$3584`/`$3585`) | `MenuGeoramaPlacePush` | maximum removable quantity and its guard |
| `DestroyPartsName` (`$3587`) | `MenuGeoramaPlacePush` | selected removal part-name pointer |
| `fname` (`$4292`) | `MenuRemovalInit` | `char *[2] = {"npcmove.pac", NULL}` |

`DestroyNum` and `DestroyPartsName` are four-byte zero objects in retail `.sdata` at 0x37C890 and
0x37C894 with no initialization guard. An ordinary `= 0` / `= {0}` / `= {NULL}` scalar
definition emits `.sbss`, which postprocessing cannot convert to `.sdata`; a runtime-initialized
local static adds a guard byte (retail's `wavetable` pair `cnt$302`/`init$303` and `menuop` pair
`ManualMovieFadeCount$1253`/`init$1254` show that pattern). A wrapper or one-element array used
only to change section placement, a nonzero value or the `explicit_zero_data` pragma are not
accepted spellings.

Anonymous `.bss`/`.sbss` templates are compiler-created zero templates for local aggregates, not
runtime variables; the natural initializers supply them:
| Retail name | Section, object / piece bytes | Local aggregate and owner |
|---|---|---|
| `at_1556` | .sbss 8 / 8 | `float list_pos[2]`, MenuGeoramaAnalyzeDraw |
| `at_1826__2` | .bss 16 / 16 | `RECT win`, DrawDownLoadAnaunce, from DownLoadWinRect |
| `at_1827__2` | .bss 16 / 16 | `RECT shadow`, DrawDownLoadAnaunce, shifted five pixels |
| `at_1829__2` | .sbss 8 / 8 | `WinColor shadow_color`, DrawDownLoadAnaunce (RGBAQ_TYPE bitfields, dynamic alpha) |
| `at_2434` | .sbss 8 / 8 | `int top_line[2]`, MenuGeoramaMessageMake |
| `at_2443` | .bss 52 / 64 | `int item_mes[13] = {0}`, MenuGeoramaMessageMake |
| `at_2444` | .bss 52 / 64 | `char *names[13] = {NULL}`, MenuGeoramaMessageMake |
| `at_3260`, `at_3268` | .sbss 4 / 4 | `char *items[1] = {make_parts->edit_name}`, IsMakeObject (two sites) |
| `at_3303` | .bss 36 / 48 | `CMenuPosDataForm *forms[9]`, CalcCursorPosition (members and one NULL) |
| `at_3304` | .bss 16 / 16 | `int pos[4] = {0,0,0,0}`, CalcCursorPosition |
| `at_4043` | .sbss 4 / 8 | `char *name[1] = {GetNPCName(...)}`, KeyStep |
| `at_4085` | .sbss 8 / 8 | `char *names[2] = {GetNPCName(select_npc), parts_info->edit_name}`, KeyStep |
| `at_4124` | .sbss 8 / 8 | `int talk[2]` of two `GetPartyCharaMessage` results, KeyStep |
| `at_4137` | .sbss 8 / 8 | `int top_line[2] = {top, top-1}`, KeyStep |
| `at_4150` | .sbss 8 / 8 | `int bar_pos[2]`, KeyStep (list-form scrollbar position) |

Initialized local templates likewise come from the existing aggregates: the child-number array
(21 ints), cursor list counts (11 ints), model position (four floats), window RGBAQ (eight
bytes), scrollbar size and line counts (two ints each), `MenuGeoramaMakePush`'s aligned river
query `sceVu0FVECTOR {0,0,0,-1}` (`at_3757`), `CalcCursorPosition`'s switch jump table and both
class vtables.

## Source forms the match depends on
- `MakeDownLoadAnaunce`: the request loop first checks `MenuEditAnalyzeDataSrc[no]` for NULL
  and skips the empty entry, then declares `EditAnalyzeDataSrc *src` from that same table entry
  with no call or write between the test and the declaration; MWCC shares the table load while
  delaying the pointer's lifetime until after the branch, which places the reduced
  condition-array indices at sp+0x140/sp+0x150, the request-table index at sp+0x160 and `src` at
  sp+0x170 as in retail. The shared loop continuation updates `condition_num` before `con`
  (retail increments the aggregate count at +0x9E0/+0x9E8 before the iterator at +0x9EC/+0x9F4).
  The condition iterator is declared at function scope; no alignment attribute is needed. The
  manager is created as `(CEditInfoMngr *) operator new(...)` then `Initialize()`; the
  `new (...) CEditInfoMngr` expression tests the copied register after the `move` instead of `v0`.
  Body 0xE08 in the 0xE10 retail extent.
- `MenuGeoramaMessageMake`: retail assigns the second line loop's index to `s0` and the selected
  name to `s4`.
- `CMenuGeorama::GetNowSelectEditPartsInfo`: the stock branch's epilogue branches to the shared
  `ld ra` with `nop` in the delay slot.
- `CMenuGeorama::InitEnd` passes the memory stack's current top to
  `MenuCharaLoadStack::stSetBuffer` via `stGetTop()`.
- `LoadGeoramaPart` copies `now_menu_pos_mapparts`/`georama_adjust_position` with a quadword-view
  copy; a 16-byte typed struct assignment changes source/destination address scheduling and
  `memcpy` adds a call.
- The form/house pointer-induction loops in `MenuGeoramaInit`, `CMenuGeorama::InitEnd` and
  `MenuGeoramaListDraw` stay as pointer loops; direct array indexing changes the emitted
  instructions.
- `MenuGeoramaPlacePush` indexes `stock_list[j].name` directly and writes the base
  `msg->ClsMes::mes_no = -1` that `CDC2Mes`'s own `s16 mes_no` hides; `MenuGeoramaMakePush`
  converts `max_num` to `short` numerically.
- `MakeMsgPartsItemInfo` calls the inherited `ClsMes::SetDefColor` on a `CDC2Mes *`;
  `EditDataAnalyze::data_open`/`condition_open` are `s8` arrays read with `lb`;
  `GetFormInfo` returns `CMenuPosDataForm *`; `MenuDataAnalyze` takes
  `GetMenuMainPosCfgBuffer`'s `char *`.

## Floating-point evaluation rows (satansfiddle)
The `editmenu.cpp` rows use `binary32` IEEE bits and set `evaluate_first` to `true` for every
identical constant in the named function, with no occurrence counter or callee restriction.

| Function | IEEE bits | Value | Purpose |
| --- | --- | --- | --- |
| `MenuGeoramaTitleDraw__FRiPfi` | `0x3f333333` | 0.7f | Materializes the cursor scale before its negative rotation angle. |
| `CalcTex__12CMenuGeoramaFv` | `0x00000000` | 0.0f | Materializes the zero minimum movement argument before the 4.0f interpolation divisor. |

The title helper draws the active georama tab and its cursor. `CalcTex` positions the analysis
progress indicator and list scroll bars before updating the selected map part. The rows preserve
the retail argument register order without changing either function's calculations.

## Function behaviour
- `MenuGeoramaAnalyzeSelect` moves the analysis cursor with two pairs of key bits, clamps it to
  the page's last line, and scrolls the analysis list toward the selected line: it caps the
  scroll distance, eases the list's Y coordinate by one quarter of its remaining distance, and
  records the scroll direction for the request display when the top line changes.
- `CMenuGeorama::CalcCursorPosition` chooses a form from the current cursor layout, positions
  the cursor on a list row or named colour cell, and forces an immediate move when
  `MenuGeoramaCursorForceSetFlag` is set. The build question uses `MakeBoardDrawInfo`
  positions (declared in menudraw.hpp).
