# menushop: reverse-engineering notes

Unit: town shop menu (`CShop`, `CShopMenu`) and the NPC quest / scoop memo viewer
(`CMenuQuestView`). No first-game counterpart: Dark Cloud 1's `shop.hpp` (`ShopMenuWork`,
`SHOP_ITEMLIST`) is a different design; nothing carries over.

## Header dependencies
- `CShopMenu`, `CMenuQuestView : CBaseMenuClass` -> `menusys.hpp`.
  Base is 0x110 with its vptr at 0x10C (see dngmenu notes).
- `CScene::BGM_STATUS bgm_status` by value -> `scenesnd.hpp`. BGM_STATUS is 0x1C
  (`CScene::GetActiveBgmStatus` writes +0x0..+0x18).
- `CGameDataUsed shop_item` by value -> `userdata.hpp` (size 0x6C).
- Forward-declared: `CMenuPosDataForm`, `mgCMemory`, `MENUFORMPARTS_TYPE` (menudraw).

## CShop (size 0x120C, no vtable, no constructor)
Size: `MenuShopInit` `__nw(0x120C)` then `memset(p, 0, 0x120C)`; then `shop_id` =
`DAT_01efc668` (clamped to >= 0; a MenuArg/menu-system field, not resolved).
| Off | Type | Name | Evidence |
|---|---|---|---|
| 0x0 | s16 | shop_id | AnalyzeShopList -> Now_Shop_ID; InitEnd passes it to SetMsgItemNo (shop name message) |
| 0x4 | s32 | item_num | AnalyzeShopList stores Now_ShopListNum; loops everywhere |
| 0x8 | s32[0x40] | item_no | Now_ShopDataReadPtr = this+8; `_SHOP_ANALYZE` writes; stride 4 |
| 0x108 | s32[0x40] | have_num | CheckSyojiHin: `GetNumSameItem(item_no[i])`; ShopSellListDraw draws it |
| 0x208 | s32 | once_item_chosen | KeyStep sets 1 when buying item 0x1A7 starts; CheckEventItem drops 0x1A7 when ==1 or `SaveData+0x62060 > 0x14` |
| 0x20C | SHOP_PRICE_INFO[0x200] | price | Spi_PriceList = this+0x20C; `_PRICE(item, buy, sell)` writes `[item*8]`, `[item*8+4]`; GetPrice reads |
The 0x40 / 0x200 counts come only from the layout (0x108-0x8, 0x120C-0x20C); no bound check.
`SHOP_PRICE_INFO` and `DONY_SHOP_ITEM` are not retail names.

GetPrice: price for 0x1A7 is multiplied by 1.1 per `UserDataMan+0x44DC0` (count bought,
incremented by KeyStep on purchase). Sell price adds gift-box contents (item 0x130, 3 slots via
GetGiftBoxItemNo), `+ *(s16*)(item+0x28)` for type 8, `level*20 + RemainFusion()*5` for type 3
(weapon). Donny mode zeroes the buy price.

CheckEventItem item numbers (removed via `local_sort1`): 0x173 (bit flag 0x1B), 0xAC, 0x163,
0x12F, 0x166 (when already held), 0x1A6 (voice unit owned), 0x1A7 (see above), type 0xB robot
core items (replaced by `CheckRobotCore()+1` if 0xF6..0xFB, else removed), 0x1A8 (monster badge
4 held), 0xC9/0xCA (quest 2 status == 2). An item-number enum would belong to gamedata.

## CShopMenu (size 0x210)
Size: `MenuShopInit` `__nw(0x210)` (Alloc 0x23 units). The constructor is inline (no symbol);
in MenuShopInit: base ctor, vptr = `__vt__9CShopMenu`, `CGameDataUsed` ctor at 0x148, then in
order: 0x1BC=0, 0x1C0=0, 0x1B4=0, 0x1B8=0, base 0x14(s16)=0, 0x1C8=0, 0x1C4=0, 0x20C(u8)=1,
0x208=-1, 0x1CA=0, 0x1CC=0, 0x1D0=0, 0x1D4=0, 0x1D8=0, 0x1DC=0, 0x1E0..0x1EA (s16) = 0,
0x12C=0, 0x130=0, 0x134=0, 0x13C=0, 0x140=0, 0x144=0, 0x110..0x124=0, 0x138=0. The header
declares `CShopMenu();`; define it inline (before MenuShopInit) so no out-of-line ctor is emitted.

Native placement construction emits the expected base constructor calls and
vtable stores without source-level byte offsets. `CShopMenu` clears its two
`arrow_flash` entries in a constructor loop; that statement-shaped body takes
MWCC's early inline conversion and gives an exact native `MenuShopInit`.
`MenuNPCQuestViewInit` remains guarded. It branches on `v0` immediately
after `__nw__FUiP1` and copies `v0` to `s1` in the delay slot. MWCC branches on `s1` after the
copy and emits a nop in the delay slot for the native placement-new expression. Explicit
value initialization and a named placement buffer produce the same instructions.

`CShop::AnalyzeShopList` constructs its `CScriptInterpreter` local after assigning the four
shop globals. Declaring that local at the start of the function moves its constructor before
those assignments. Keeping the declaration at the retail call site gives an exact function.

The retail shop callers treat `CUserDataManager::CheckVoiceUnit` and
`CUserDataManager::AddYarikomiMedal` results as `int`. Declaring those methods with narrow
return types causes MWCC to add sign extensions after the calls, despite their stored fields
being narrow; `int` declarations preserve the retail callers and methods.

| Off | Type | Name | Evidence |
|---|---|---|---|
| 0x110 | CMenuPosDataForm* | trade_brd | AttachForm "売買ボード"; SetNumber "合計"/"単品"/"数" |
| 0x114 | CMenuPosDataForm* | item_list | "品物リスト"; AttachForm reads its put pos into 0x1D8/0x1DC (+48 on y) |
| 0x118 | CMenuPosDataForm* | shop_name_brd | "店名ボード"; CalcTex "中心" pos |
| 0x11C | CMenuPosDataForm* | money_brd | "moneybrd"; SetNumber("num", UserDataMan+0x44D9C) |
| 0x120 | CMenuPosDataForm* | exp_brd | "EXPBRD"; SetNumber("corep", GetRoboAbs) |
| 0x124 | CMenuPosDataForm* | medal_brd | "MEDALBRD"; SetNumber("num", CheckMoney) |
| 0x128 | float | scrl_bar_step | UpdataScrlBar `(270 - len)/(n-6)` |
| 0x12C/0x130/0x134 | MENUFORMPARTS_TYPE* | scrl_bar_top/body/bottom | GetPartInfo of item_brd "b0","b1","b2"; +0x20 y, +0x28 h |
| 0x138 | CMenuPosDataForm* | item_brd | "品物ボード" |
| 0x13C | u_int* | pack | MenuShopInit LoadFileMenu("shop.pac"); InitEnd GetPackFile from it |
| 0x140 | s32 | pack_size | LoadFileMenu result |
| 0x144 | u_int | se_handle | sndLoadSound("snd2/sp/SP_042.snd"); `MenuSePlay(u_int,int)` on a sale |
| 0x148 | CGameDataUsed | shop_item | SearchNowPosItemExist: `CopyGameData(&shop_item, item_no[list_pos])`; 0x184 (=+0x3C) cleared for type 3 |
| 0x1B4 | s32 | bag_pos | MenuItemBrdKey/MenuItemBrdSetInfo; GetUsedDataPtr(bag_pos) |
| 0x1B8 | s32 | bag_top | same |
| 0x1BC | s32 | list_pos | MenuListKeyCheck(…, &list_pos, &list_top, n, 6, …) |
| 0x1C0 | s32 | list_top | same |
| 0x1C4 | s32 | total | price * num |
| 0x1C8 | s16 | num_cursor | 0/1 clamp; cursortbl "0","1" |
| 0x1CA | s16 | num | quantity, ±1/±10 |
| 0x1CC | s16 | num_max | clamp of num |
| 0x1D0 | s32[2] | arrow_flash | set 8 on change, decremented in CalcTex; lights "矢印上"/"矢印下" |
| 0x1D8/0x1DC | float | list_x/list_y | CalcCursorPosition list cursor |
| 0x1E0 | s16 | shop_name_ofs_x | InitEnd `GetMesWidth_system(shop_id) >> 1` |
| 0x1E2 | s16 | shop_name_ofs_y | InitEnd = 2 |
| 0x1E4 | s16 | price_mes_width | MenuShopInit width of message 1000 (min 0x3C) |
| 0x1E6 | s16 | unk_1e6 | ctor 0 only |
| 0x1E8 | s16 | no_price_mes_width | message 0x3EA width; CalcTex uses `this+0x1E4`/`+0x1E8` through one pointer |
| 0x1EA | s16 | unk_1ea | ctor 0 only |
| 0x1EC | CScene::BGM_STATUS | bgm_status | Get/SetActiveBgmStatus; KeyStep reads +0x1F0 (BGM_STATUS+4, bgm number) for LoadBGM |
| 0x208 | s32 | error | SHOP_MENU_ERROR; -1 in ctor and on returning |
| 0x20C | u8 | cursor_reset | CalcCursorPosition snaps cursor then clears; set in InitEnd and mode 6/7 |

Vtable `__vt__9CShopMenu` (0x37C460, 0x20): `0, 0, IsCreateObject, IsMakeObject, IsAskExtend,
ItemCmdAfter, InitEnd (CShopMenu), ExitEnd`. MenuShopInit calls InitEnd through +0x18.

### KeyStep
Base `*(s16*)this` state: 0 running, 1 opening (ExeScript "INIT_END", state 0), 2 closing
(restore BGM, return 1), other -> ExtendCommand. Base 0x14 is the SHOP_MENU_MODE. Mode 7 is
handled with 6 but never set. Action codes (local int): 0x32 close, 1000 start buy, 0x3F2 start
sell, 0x3E9/0x3F3 ask, 0x3ED buy, 0x3F7 sell, 0x44C back ("アイテム選択にもどる"), 0x1E/0x14/5
bag item moves. `shop_mode_prev_1326`/`init_1327` are function-local statics (mode to return to).
The ghidra `KeyStep` copy under `MenuShopKey__Fv.c` is a mis-split; MenuShopKey is a tail call.

## CMenuQuestView (size 0x190)
Size: `MenuNPCQuestViewInit` `__nw(400)` (Alloc 0x1B units). Implicit constructor: base ctor +
vptr only, so no constructor is declared.
| 0x110 | s32 | select | MenuKeySelectCheck(…, &select, &top, 0, SelectMax(), 7, 0) |
| 0x114 | s32 | top | same; scroll bar y |
| 0x118 | s32[0x1E] | photo_no | InitEnd: -1, or `*(s16*)(GetPhotoInfo(i)+10)` when `*GetPhotoInfo(i)`; never read in this unit |
Vtable `__vt__14CMenuQuestView` (0x37C440): same as CShopMenu's with InitEnd (CMenuQuestView).
Base `+2` is the sub-state (0 list, 1 comment shown); base `+0x18` the texture block.
SelectMax: `*QuestMan` (CQuestManager count, first s32) in quest mode, 0x35 in scoop mode, 1 else.

## Functions
- Local (static, in .cpp only): `CheckRobotCore()` (returns `UserDataMan->CheckRobotCore()`),
  `_SHOP_ANALYZE(SPI_STACK*, int)`, `_PRICE(SPI_STACK*, int)` (script tag handlers, return 1;
  `_SHOP_ANALYZE` returns 0 when the shop number differs). `__sinit_menushop_cpp` constructs
  `MenuLocalStack` (`mgCMemory::Init`).
- `MenuShopInit`'s third argument is unused; `MenuNPCQuestViewInit`'s is the view mode
  (`Menu_Memo_ViewMode = arg == 1`).
- `ShopSellListDraw(int&, float*)`: called from `CMenuPosDataForm::MenuFormDraw` for form part
  type 0x27 with `(tex_block, form+0xC)`.

## Data identities and storage
The tables below are native. Tables carrying a numeric retail suffix in this
list are function-local statics in the source; state objects have file-local
linkage. The shop mode restored after an error is a natural initialized
local static in `CShopMenu::KeyStep`.

`.data`: `dony_shoplist` DONY_SHOP_ITEM[8] (7 items 0xBD,0x73,0xCD,0x7A,0x105,0x1AC,0x1AB at
levels 1..7, then item -1); `menu_shop_tag` SPI_TAG_PARAM[3] {"SHOP",_SHOP_ANALYZE},
{"PRICE",_PRICE}, {0,0}; `imglist_1267` char*[4] (allitem/spectre/img.img, 0);
`extbl_1278` char*[4] per SHOP_SELL_MODE script labels (通常/スターブル/ニード/ドニー);
`exe_tbl_1509` (かう設定...), `extbl_1573` (かう？...), `extbl_1589` (お金不足/EXE不足/メダル不足)
char*[4] by sell mode; `randam_checktbl` u8[0x3C]; `tbl_2469` (0xA8) / `at_2470` (0x18)
MenuNPCQuestViewDraw tables of s16.
`.sdata`: `t_offxy_1832` CursorPoint {0,0}, `cursor_offsetxy_1836` CursorPoint {-46,18},
`cursortbl_1838` char*[2] {"0","1"}, `rgba_1897` u8[4] 0x80, `QuestMoveRate` float 1.0,
`packname_2171` char*[2] {"quest.pac","scoop.pac"}.
`.sbss`: `NowSellMode` s16 (SHOP_SELL_MODE), `CShopPtr` CShop*, `Tex_Shop`/`Tex_Mt0`
mgCTexture*, `Now_ShopListNum` s16, `Now_ShopDataReadPtr` s32*, `Now_Shop_ID` s16,
`Spi_PriceList` SHOP_PRICE_INFO*, `CShopMenuPt` CShopMenu*, `QuestMan` CQuestManager*,
`QuestDataPtr` CQuestData* (SaveData+0x62A40), `Tex_QuestMemo` mgCTexture*, `QuestMenuMes`
CDC2Mes*, `ActiveQuestInfo` pointer (GetQuestInfo result), `QuestTilePatternXY` float (sym size
4, 8 bytes reserved), `QuestCursorPos` float[2], `QuestListTopY`, `QuestCommentWinX` float,
`QuestScrlBarY`/`QuestScrlBarH` float, `QuestViewCommentFlag` u8, `QuestReactionCommentGyouNum`
s16, `ScoopMan` CScoopDataManager* (SaveData+0x25CA8), `ScmFlagCtrl` SCOOP_DATA* (GetScoopDataTableIndex),
`menu_debug_questselect` int, `Menu_Memo_ViewMode` s8 (QUEST_VIEW_MODE), `MenuQuestView`
CMenuQuestView*.
`.bss`: `MenuLocalStack` mgCMemory (0x30), `QuestCommentMes` CDC2Mes*[3].
Externals used: `GiftBoxViewForm`, `NowGiftBoxPtr` (other unit), `DAT_01efba44..50` are
`MenuDCMsg`-area CDC2Mes pointers (menumain), not resolved here.

## Quest memo draw
`MenuNPCQuestViewDraw` draws the patterned backing and 16
constructed menu fonts, then lists accepted quests or known scoops with their completion and
photo marks. The scrollbar is three quads, with its middle section resized from
`QuestScrlBarH`. When a comment is open, seven signed 16-bit heights copied from `at_2470`
form the frame; the reaction adds 24 pixels to the sixth height, while scoop mode removes
eight pixels from the fourth and zeroes the fifth and sixth. The debug overlay reads the
same quest and scoop records to label their two state bytes. In the quest row, storing both
the x constant and the `y - 2` position before calling `PrimQuad` gives MWCC the retail
register assignment. The complete function matches retail with native local
initializers for the frame heights and texture rows.

## Compiler flag
The local `divbyzerocheck on/reset` pair around `CMenuQuestView` is redundant with the
unit's global flag: removing it produces an identical complete `menushop.cpp.o`.

## Shop-list script handler

`_SHOP_ANALYZE` ignores a script row unless its first integer identifies the currently selected shop. Matching rows set the remaining argument count as `Now_ShopListNum`, select robot-ABS selling for shop 23 or 28, medal selling for shop 32, and Donny selling for shop 33, then copy each following script integer into the typed item-number array. Ordinary shops retain the existing sell mode and use the local remaining argument count. One function-scoped item index is shared by the mutually exclusive copy loops; this preserves the PAL saved-register allocation in all four branches. The native 432-byte function now passes the object checker with zero instruction or relocation differences.

## Current matching status

Twenty-nine functions and the unit's native data match retail. Only
`MenuNPCQuestViewInit` retains a guarded assembly fallback. Its placement
construction draft branches on the saved pointer after copying it; retail
branches on the allocation result and copies in the delay slot.
`CShopMenu::KeyStep` uses a natural initialized local static for the previous
list mode and local script tables for setup, confirmation and refusal.
The shop initializer keeps the explicit `CShop` placement allocation and
`memset`; a constructed `new` expression changes the allocation branch.
