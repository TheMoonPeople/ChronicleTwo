# menusys: header notes

`MenuModeMalloc`, `MenuItemSelectInit` and `MenuItemDebugKey` are native C++
with after-inline placement rows asserting two, one and one constructions.
SelectInit additionally uses two float rows, and DebugKey one. Complete-object
and PAL verification pass; see
[placement conversion](../satansfiddle/placement-new.md). The three functions
emit their own path literals, analog-input zero templates, the `dbox_path`
local static and the `CItemSelect` vtable, so no data markers remain for them.

Only `CMenuItemInfo::IsAskExtend` retains a `NONMATCHING` assembly fallback.

Header: `ps2/include/menusys.hpp`. All offsets and sizes below were checked by compiling a test
against the header (offsets of the key fields and every `sizeof`).

## Includes
`userdata.hpp` at the top (CGameDataUsed by value in `CMenuKeyFunc`, `CMenuItemInfo`). userdata.hpp
no longer reaches inventmn.hpp (CInventUserData moved into userdata.hpp), so there is no cycle.
Header order (acyclic, each includes only what it needs by value): gamedata < userdata < menusys < savedata < memcard < inventmn.

## Classes and sizes
| Type | Size | Evidence |
|---|---|---|
| `CBaseMenuClass` | 0x110 | ctor `memset(this, 0, 0x110)`; derived classes' fields start at 0x110; vptr stored at 0x10C |
| `MENU_ASKMODE_PARA` | 0x94 | `Initialize` = `memset(this,0,0x94)`; symbol `MenuAskParam` size 0x94; base 0x58 + 0x94 = 0xEC (swap_info) |
| `MENU_SWAPITEM_INFO` | 8 | `Set` writes 0..6; followed by 0xF4 in base |
| `ITEMCMD_RET_PARA` | 0x14 | symbol `MenuItemCmdRet` size 0x14; accesses at 0,2(sb),3(sb),4,6,8,A(sh),C,10(sw) |
| `CMENU_USERPARAM` | 0x18 | `Initialize` clears 6 words; `MenuUserParam` size 0x18 |
| `CMenuKeyFunc` | 0x160 | `new(0x160)` in `MenuMainInit`; `Initialize` = `memset(this,0,0x160)` |
| `CMenuItemInfo` | 0x370 | `class_menu_item_info` size 0x370; `__sinit` builds base, stores vptr at +0x10C, `CGameDataUsed` ctor at +0x304 |
| `CItemSelect` | 0x450 | `new(0x450)` in `MenuItemSelectInit`; last used field 0x448, so `unk_44C` pads to the size |
| `MENU_INPUTKEY_ARG` | 0x24 | `item_menu_argtbl` (0x1B0 = 12 rows) indexed `key_arg_no * 0x24` |
| `MENU_ITEM_CURSOR_INFO` | 0xC | `MenuItemCursorInfo` size 0xC: bytes 0..6, int at 8 |
| `BUILDUP_WEAPON_INFO` | 0x44 | `BuildUpWeaponInfo` size 0x44 |

`MENU_INPUTKEY_ARG`, `MENU_ITEM_CURSOR_INFO` and `BUILDUP_WEAPON_INFO` are **not retail names**.
No symbol names these types, so the names are neutral ones taken from the tables and globals that use them.
`MENU_ASK_MODE`, `MENU_SELECT_KEY`, `MENU_PUSH_BUTTON` and `MENU_INPUTKEY_TYPE` are likewise our names.

## CBaseMenuClass
- vtable (`__vt__14CBaseMenuClass`, 0x20 = 2 header words + 6): IsCreateObject, IsMakeObject,
  IsAskExtend, ItemCmdAfter, InitEnd, ExitEnd. All six are inline (bodies `return 1` / `return 0` /
  empty) and are emitted in dngmenu (0x1F3D00..) and editmenu (InitEnd 0x1FF8D0). The vtable itself is in menusys.
  `CItemSelect` keeps all six. `CMenuItemInfo` overrides IsAskExtend, ItemCmdAfter and ExitEnd.
- ExtendCommand dispatches on `mode`. Mode 4 calls vt+0x14 (ItemCmdAfter) with `&MenuItemCmdRet`; mode 5
  calls vt+8, mode 6 vt+0xC and mode 12 vt+0x10. These give the `MENU_ASK_MODE` values 3..12.
  The ctor sets mode 1, `IsAskEnd` sets 0, and `CItemSelect::KeyStep` uses 1 (waiting for its background) and
  2 (closing).
- 0x04 u8 `opened`: `CMenuItemInfo::KeyStep` sets it once it has run the opening script (`ExeScript`).
- 0x08/0x0C: script pointer and size, from `GetPackFile(..., &size)` in `MenuItemInit` and passed to
  `MenuCommandAnalyze(char*, int, char*)`.
- 0x10 is set to 0x80 by the ctor and never read in menusys (`unk_10`). 0x06, 0xF8, 0xFC and 0x104 are
  never read here either.
- 0x14 s16 `key_arg_no`: index into `item_menu_argtbl` (`CMenuItemInfo`).
- 0x18 `int tex_block[16]`: SetTexBlock/DeleteTexBlock loop to 16 and stop at a value <= 0 or < 0.
- 0x58 `ask_para`; 0xEC `swap_info`; 0xF4 `cmd_arg_pos` (MenuItemCommnadSelectPrepare stores its arg).
- 0x100/0x108/0x10A: the make question of SelectMakeObject (count, cursor row byte, max s16).
- Ctor order in retail: vptr store, `ask_para` ctor, `swap_info.Set(-1,0,-1,0)`, `memset(this,0,0x110)`
  (this clears the vptr too; derived classes store theirs afterwards), field inits, 16x `tex_block=-1`,
  `cmd_arg_pos=-1`, `unk_F8=0`, `step=0`, `SetAskParam(NULL)`, `memset(&unk_FC,0,0x10)`.
  MENU_SWAPITEM_INFO has **no** constructor. Locals in EquipDirect and ItemCmdAfter are only `Set` once
  with other values, so the Set call belongs in the ctor body.

## MENU_ASKMODE_PARA
- 0x02 `mes_no` indexes `MenuDCMsg` / `MenuMesForm`, and 0x04 holds the command count.
- `GetItemCommandMsg(item, para, ...)` passes the arrays at 0x08 (int[8]), 0x28 (u32[8] colours;
  0x80202020 / 0x80303030 grey), 0x48 (s16[8]) and 0x58 (s16[8]; set to 1 in one case).
- `SetAskParam` copies 0x00..0x04, then a loop of **16** iterations over the three arrays at 0x08, 0x28 and
  0x48. With 8-entry arrays this overlaps the next array, so the retail loop overran its arrays. Reproduce it
  with a bound of 16 (unrolled by 8 → 2 iterations). Then it copies 0x68..0x70 (s16) and 0x74..0x88 (words).
  0x06, 0x8C and 0x90 are not copied.
- 0x68/0x6A: mode-dependent values (MoveItemCommand: chara number; SpectolBreak: `GetSameAdrressUserData`
  of both items). 0x78 form, 0x7C item, 0x80 second item (these come from stack copies in SetPreCmd*).
- The ctor sets 0x8C = -1 **before** calling Initialize (which zeroes it). Retail does this.

## CMenuKeyFunc (the object at `MenuCommonInfo`, owned by menumain)
- Construction (`MenuMainInit`): `mgRect<int>::Set(0,0,0,0)` on +0x90, `CGameDataUsed` ctor on +0xC0,
  `MENU_SWAPITEM_INFO::Set(-1,0,-1,0)` on +0x12C, then `Initialize()`. The rect Set comes before the member
  ctor of +0xC0. `mgRect` has the default ctor calling `Set(0,0,0,0)` in `mg_tanime.hpp`. The same Set pair appears first thing in the inline `CItemSelect` construction. The header declares
  `CMenuKeyFunc() { have_swap.Set(-1,0,-1,0); Initialize(); }`. Check this against MenuMainInit when matching.
- 0x01 `key_enable` (gates every key read), 0x02 `key_input`, 0x04 select-key bits, 0x08 push-button bits.
- 0x0C `tex_block[16]` = `MENU_INIT_ARG::tex_block_top + i` (MenuMainInit). 0x4C set to -1 there.
- 0x50 s16 = `MENU_INIT_ARG::open_type`; 0x54 = running MenuModeID (`menu_keyfunctbl[...]`); 0x58 = next mode
  (-1 none); 0x60/0x64 = `MENU_INIT_ARG::pack/pack_size`; 0xA0 = `MenuUserDataManPtr`.
- 0x5C/0x5E: frame counters that light the "up"/"down" parts of the how-many board (MenuPosStep).
- 0x68 waku type (SetWakuType, parts "waku%d"). 0x70/0x74 cursor/top line, passed to MenuKeySelectCheck.
  0x78/0x7C are copies made by SelDataInit.
- 0x80 u8 set by ReturnItemMenu. 0x81..0x8F, 0x6C and 0xA4..0xBF are unused in menusys.
- 0x134 `MENU_INPUTKEY_ARG *` (assigned `item_menu_argtbl + n*0x24`). 0x138 form "cursor0", 0x13C "cur_waku0",
  0x140 "howmachbrd"; parts 0x144 "item0", 0x148 "item0sdw", 0x14C "item0num".
- 0x150..0x15A: BGM fade (saved volume, step, target s16, active s16).
- `MenuPosStop` and `MenuPosPlay` set `step_stop` on both cursor forms; the move-method
  setters write each form's `mtype`. `SelDataInit` clears key state and saves cursor and top
  line; `CheckKeyInput` discards button state when input is disabled and latches a nonzero
  direction into `key_input`. `FadeInMenuBGMVol` records a step, targets the saved volume,
  and marks the fade active.
- Return types: CheckAnalogKey returns float 1.0; CheckKeyInput returns the byte at +2; StepMenuBGM returns
  s16 +0x15A; the limmit_check functions return s16.

## MENU_INPUTKEY_ARG (item_menu_argtbl rows)
Seen in `menu_inputkey_limmit_check_line/glid`:
- 0x00: s16 step[4], the deltas for up/down/left/right.
- 0x08: int type, 0 for a line and 1 for a grid.
- 0x0C: s16 min. 0x0E: s16 max (a line). MenuItemDebugKey writes `MenuItemBoardTotalNum` into row 2's 0x0E.
- 0x10..0x13: bytes. A line uses 0x10 as its visible rows. A grid's up/down use 0x12 (max) and 0x10 (visible),
  and its left/right use 0x13 (max) and 0x11 (visible). 0x13 is also the column count used to split the
  cursor. MenuItemDebugKey writes `MenuItemBoardTotalLine` to row 2's 0x12.
- 0x14: s16 limit[4], the MenuKeySelectCheck mode. 0 clamps, 1 wraps, 2 clamps and returns 3 at an edge, 3
  returns 4 at an edge.
- 0x1C: s16 exit_no[4], returned when the edge result is 3.

## CMenuItemInfo (global `class_menu_item_info`, local; `CMenuItemInfoPt` points at it)
- No constructor symbol; `__sinit_menusys_cpp` constructs it inline (base ctor, vptr, `CGameDataUsed` ctor
  at 0x304). The implicit ctor gives exactly this.
- 0x110 `view_mode`: page. 0/1 = Max/Monica, 3 = ridepod, 4 = monster, and 2/5 are also seen.
  `GetActiveCharaIDForItemCmd` maps it.
- 0x114 `sub_view`, compared with 1 in GetActiveCharaNo. 0x116 holds a character number in CalcTex and
  ModelRead (`view_chara`). 0x118 is the load item list (CheckLoadItemNo), and 0x11A = `MenuUserDataManPtr+0x44D98`.
- 0x120 s16[8] / 0x130 u8[8] are the equipment lists (SetEquipListNo copies CHARA_DATA +0x172, +0x1DE, ... and
  ROBO_DATA +0x32...). 0x138 holds the loaded weapon number (CheckLoadInfo compares it with CHARA_DATA+0x1DE).
- 0x140/0x150: `float[4]` camera reference and position, filled by a CPosDataManage call (`at_6013/6014`,
  count 3) and used with `mgCCamera::SetRef/SetPos`. The header declares them `sceVu0FVECTOR` because 0x140 is
  16-aligned.
- 0x16E/0x16F: voices loaded / voices need loading (CheckSoundLoad, CheckLoadInfo).
- 0x17C `CGameDataUsed *` shown weapon (Save/CheckViewWeaponStatus).
- 0x180 `view_form[6]` from `ItemMenuFormNameTbl` = form_view00, form_view01, form_view1..4. 0x188 is
  form_view1 (weapon status), 0x18C form_view2, 0x190 form_view3, 0x194 form_view4.
- 0x19C "itembrd" (+0x1B4 its part "icon"), 0x1A4 "moneybrd", 0x1A8/0x1AC "poly_chr0/1", 0x1B0
  "mainform_filldmy".
- 0x1C8 `[2][16]` part pointers, stride 0x40 per character page. Twelve are used per page: wepfrm0 whp00 slu1
  whp01 wep0 batu0 / wepfrm1 whp10 slu2 whp11 wep1 batu1. MenuItemCharaActWepInfoDraw indexes it as
  `(i+4)*4 + 0x1B8`, which is the same array (0x1B8..0x1C7 itself is unused).
- 0x2A0 robo parts (wepfrm, whp00, slu1, whp01, wep0, batu0 of form_view2). 0x2B8 hp_bar[2]. 0x2C0 [2][3]
  (item0, item1, item2 via `local_over_flow_baseposname`). 0x2D8 [2][3] (item0num..item2num). 0x2F0 "VOICE".
- 0x2F4 is used as `int *` in MenuItemDraw. 0x2FE/0x300/0x304 are used by the debug key/draw (item number,
  flag, item).
- Unused here: 0x112, 0x11C, 0x13A (only cleared and read in CalcCursorPosition), 0x160 (flag), 0x161..0x16B,
  0x172..0x178, 0x198, 0x1A0, 0x248..0x29F, 0x2F8, 0x2FC. Most of these are set or tested somewhere but their
  meaning was not established.

## CItemSelect (heap object, `ItemSelectPtr`)
- `MenuItemSelectInit` attaches the caller's remaining stack, constructs the list in 0x47
  quadwords, sets its two screen rectangles, attaches the menu texture, and starts the background
  read. Modes 9 and 0x16 read separate menu files into the stack; the size is rounded up to
  quadwords before the message window is preset. The constructor and function are active
  C++; the placement conversion and two float rows reproduce the complete caller.
- Built inline in MenuItemSelectInit: base ctor, vptr, two `mgRect<float>::Set(0,0,0,0)` (see the mgRect note),
  then the field clears, then `Set(120, mgScreenHeight-0x10A, 0, 200)` and `Set(list.x+20, list.y+370, 44, 55)`,
  then top_line/cursor = 0, line_num = 1.0, CheckEnableHaveItemNum and SetPtrList. The header declares
  the constructor; its active inline source body has no separate retail function symbol.
- 0x110 count, 0x114 `CGameDataUsed *[150]` (from `MenuUserParam.used_data`, stride 0x6C, 150 entries),
  0x36C u8[150] (`menu_limmit_displayflag`), 0x402 alpha step (0xC in, -8 out), 0x404 alpha and 0x408
  background alpha (CalcMenuAdd), 0x430..0x438 eased cursor x/y and scroll, 0x43C texture, 0x440 cursor
  (5 columns), 0x444 top line (MenuCheckLine, 2 lines), and 0x448 float rows = count/5+1.

## Globals
Only non-local symbols get externs (the rest are `static` in the .cpp per `local_symbols.tsv`). Types:
- `menu_item_swap_sndtbl` is s16[8], indexed by the MenuSwapItem result.
- `SpectolInfo` is `CGameDataUsed*[2]` (SetSpectolInfo writes gp-0x6A80 and gp-0x6A7C).
- `MenuEffect` is `CMenuEffect*[2]` (passed as `CMenuEffect**` to SetEffectSpectolFusion; +0 and +4 loaded).
- `SpectolFusionTargetChara` is `CCharacter2*`. `trans_spectol_cnt` is float (sinf(cnt*...) and +1.0).
  `trans_spectol_pos` is int.
- `MenuItemUseTarget` is `CItemUseTarget` (sinit sets the first word to -1).
- `menu_chara_activeItem_limmit_check` is `u8[6]`: three active-slot limit flags for each of two
  characters. `CheckEnableHaveItemNum` writes it and `MenuItemCharaActWepInfoDraw` reads it.
- `BuildUpNameXY` is s16[3][2] (x, y per name).
- `BUILDUP_WEAPON_INFO`: 0x00 s16 mode, 0x02 s8 select active, 0x03 s8 cursor, 0x08 int count. Its address
  +0x8, +0xC, +0x18 and +0x2C is also taken and +0x24 is read (not resolved: `unk_4`, `unk_C[0x38]`).
- `MENU_ITEM_CURSOR_INFO`: byte 0 enable, bytes 1..3 (loop of 3) and 4, 5 are arrows, byte 6 is the
  character mark, and the int at 8 is a counter that wraps above 0x18.

## Functions
- Local (static, keep in .cpp): DrawTrushMenuMessage, MenuHowMuchNumSelect, UpdataInfoSpectolBreakItem,
  SetConditionHowMuchBoard, CheckFishCondition, InitSpectol, AfterSpectolFusion, SpectolFrameCalc,
  TransSpectolDataSave, MenuDataSwap, both GetItemCommandMsg, MenuEquipCameraSetEnv,
  MenuPosFormValueSetWeapon, MenuFormUpdataAttachInfo, MenuPosFormValueSetFishingRod, MenuItemDebugKey,
  MenuItemDebugDraw, local_item_infoview_set, MenuItemCharaActWepInfoDraw, MenuItemCharaViewCheck,
  MenuPosFormValueSetCharaRobo, MenuPosFormValueSetMonster, BuildUpWeaponNameBoardDraw,
  MenuWeaponStatusInfoFormSet, MenuItemSelectDiffer, CheckTrushWeapon.
- `MenuItemSelectDiffer` has a 0x30-byte jump table at `at_7968` whose entries
  point to interior addresses in the function. Its active C++ matches the
  retail function and the linked jump-table targets.
- Return types come from m2c and Ghidra and were checked at call sites for SearchNowPosItemExist and
  GetExistThisPosData (both `CGameDataUsed *`) and GetGameDataUsedForSWAPINFO. Parameter names of the big
  functions (ModelReadStart, WeaponBuildCheck, KeyStepLocal, CheckSpectolFusion's int) are only partly
  established.
- Mangling of a sample of the declarations (ExchangeItemInfoMake, EnterDataMenu, MenuSwapItem,
  GetDebugInputKey, FadeInMenu, IsItemUseNum, MenuItemInit, ItemCmdAfter...) was checked by compiling stub
  definitions.

## Current matching status

All functions in this unit are native C++ except `CMenuItemInfo::IsAskExtend`,
which retains its `NONMATCHING` assembly fallback. The native functions include
`MenuModeMalloc`, `MenuItemDebugKey`, `MenuItemSelectInit`,
`MenuItemSelectDiffer`, `CommonSetMoveItemClass`, `MenuDataSwap`,
`MenuPosFormValueSetCharaRobo`, `CMenuItemInfo::CalcTex`,
`CMenuItemInfo::LRCheck`, `MenuItemDebugDraw` and
`CheckEnableHaveItemNum`. The three allocation callers construct their
`CActionChara` or `CItemSelect` objects through placement construction. The
accepted placement rows and their scope are documented in
[placement-new.md](../satansfiddle/placement-new.md).

`IsAskExtend` controls the extended item-description prompt and a temporary
character preview. Its natural constructor form still differs from retail:
the current draft with the committed profile has 528 differing words out of
668 and a raw body of `0xA68` bytes. An earlier private placement/scheduling
trial reaches 170 differing words but is four bytes larger than retail.
The cancellation close
request, message/name register lifetimes and a late branch delay slot account
for the principal residual. The guard remains until a complete object match
is possible without invented state.

## Source forms needed for native matches

- `CommonSetMoveItemClass` copies four integers with a `table[i][j]` loop,
  then names the row pointer. The explicit `move->from[2] == 0` comparison
  avoids an extra sign-extension pair.
- `MenuDataSwap` looks up the source result before initializing its local
  two-byte result array. The destination presence flag is declared first;
  the array initializer produces the retail halfword copy. Its result mapping
  is detailed in [swap-results.md](swap-results.md).
- `MenuItemDebugDraw` uses `page * 64 + 1 + row * 8 + col`, reuses the
  attribute-loop index for the later build-name loop, and uses seven
  `DrawMenuFillBox` argument scheduling rows. The debug title accesses the
  same controller object throughout.
- `MenuPosFormValueSetCharaRobo` copies the initial red value to green and
  updates both from the blink value. The green and red declaration positions
  preserve the retail register pairing.
- `CalcTex` gives its equipment search a separate function-scope counter,
  declares the held item type in its branch, and retains unsigned arithmetic
  for `slot_mes[key_no - 4U]`. The rotation flag is a signed byte.
- `LRCheck` uses a shoulder-button `switch` in L1, R1, L2, R2 source order.
  The default jump claims the shared zero-return delay slot before the later
  item rejection branch, matching retail's branch slots.
- `CheckEnableHaveItemNum` keeps the active-slot counter at function scope,
  uses one named active-record pointer for all its calls, and has a separate
  gift-slot counter. The bag pass and final flag loop share their counter.
- `BuildUpWeaponTrans` preserves the absorption-gauge percentage while the
  next weapon's level-up requirement replaces the maximum. It resets the
  level, adds ten percent of the new base parameters, combines special
  ability bits and replaces a custom name only when it was the old default.
- `CBaseMenuClass::SetAskParam` copies three overlapping runs: 16 words
  from `cmd_msg`, 16 words from `cmd_color` and 16 shorts from `unk_48`.
  The header overlays keep these runs within declared bounds. It leaves
  `unk_6`, `unk_72`, `unk_8C` and `unk_90` unchanged.

## Native data and remaining assembly suppliers

The native state has retail declared extents rather than padded section
reservations: `ITEMCMD_RET_PARA` is 0x14 bytes and `MenuEffect[2]` is 8 bytes;
`MenuCharaReadBuffers`, `MENU_ITEM_CURSOR_INFO` and `BuildUpNameXY` are each
0xC; `BUILDUP_WEAPON_INFO` is 0x44; `CLevelUpEffectManager` is 0x190.
The saved fusion parameters contain twelve shorts, and both build-up part
pointer arrays contain twelve entries. The incomplete `MenuEffect[]` header
declaration is required for the current complete-object build: giving it a
`[2]` bound changes `inventmn` object layout.

The ridepod equipment table contains four signed bytes; the confirm/cancel
mapping is `int[2][2]`; the active-weapon part names are `char *[3][2]`;
and the palette-effect table is `int[2][5]` for colour, pulse count and
duration. `stchar_6508[13]` contains twelve weapon ability names and a null
terminator. The `MENU_WEAPON_ABILITY` mask names match the label order, without
asserting unverified gameplay effects. The local `CItemSelect::Draw` colour
initializer is a four-byte array whose alpha is replaced at draw time.

Most strings, aggregate zero templates, state objects and tables are native.
Four direct string aliases (`at_3895`, `at_3924`, `at_5882`, `at_5883`)
remain assembly supplied because isolated inline forms change the identity of
`at_5774` and shift resolved references. The extended-prompt guard retains
its literals and jump table; the `CMenuItemInfo` and `CBaseMenuClass`
vtables remain assembly suppliers. The `at_6424` debug dispatch table is
also still assembly supplied. No `INCLUDE_BSS` markers remain in the unit.

Twelve native persistent counters or flags use natural function-local statics, including
`cmd_counter`, `sndflag`, `count_time`, `checkmoveFlag`, `fusion_blinkcnt`,
`diffent_weapon_dispflag`, `counter`, `count`, `old_viewmode`, `old_chrid`,
and the debug `cnt` and `testcnt` states.
`MenuListKeyCheck` initializes separate two-by-two direction and wrap arrays.

Thirty-seven initialized tables and the remembered `Save_AskParamInfo`
pointer belong to their owning functions under bare retail names. The
guarded `IsAskExtend` draft also uses initialized local `Effect_Counter`
and `BuildEndFlag` states; the normal assembly path retains its four
associated state and guard suppliers.

`SameviewmodeTable_8406` retains its existing file-local identity. A natural
local declaration preserves the native instructions and linked PAL image,
but anonymous-data inference rejects its folded GPREL16 base addend of
`-15` from `table[msg_item - 15]`. The inference requires the base addend to
lie inside the declared four-byte payload; supplying the known base passes
the complete consumer proof. Retaining the existing identity keeps the
strict checker and profile unchanged.

The current complete menusys object compares `0x1B09C` allocated bytes and
6,130 resolved relocations without findings.

## Item-menu pages and fields still unnamed

`MENU_ITEM_VIEW` covers Max, Monica, the weapon preview, ridepod, monster and
fishing-rod pages in `CalcTex`; `LRCheck` uses the corresponding party pages.
The cursor layout values in `item_menu_argtbl[12]` and the move-slot kinds in
`MENU_ITEM_MOVE_INFO::from[0]` have no established retail enum names. The
ridepod weapon attributes still use a ten-halfword `status` view in the
matching debug function. Splitting the first two status parameters from the
eight attributes changes its object extent; the producer writes in
`CopyDataRoboPart` also need a consistent layout before that type can change.
