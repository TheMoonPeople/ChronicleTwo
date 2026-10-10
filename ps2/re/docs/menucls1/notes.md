# menucls1 notes

Menu helper classes: `CMenuFont`, `CDC2Mes`, `CMenuMoveItem`, `CMenuItemUse`, plus digit helpers
and the item-use checker. No first-game (`chronicle`) counterpart exists for any of them.

## Dependencies
- `CDC2Mes : ClsMes` (nd_meswin.hpp, sizeof 0x2958), `CMenuFont : CFont` (font.hpp, 0xB8).
- `MENU_ITEM_MOVE_INFO` holds a `CGameDataUsed` by value. `CGameDataUsed` belongs to `userdata`,
  so the header includes `userdata.hpp`.
  `CGameDataUsed` size 0x6C: `CGameDataUsed::Init` memsets 0x6C; `CopyGameData` memcpys 0x6C;
  `CommonSetMoveItemClass` (menusys) copies 0x6C.
- `CItemUseTarget` from gamedata.hpp. `__sinit_menucls1_cpp` stores -1 into `MenuUsedTarget.type`,
  and `CheckItemUseEnable` stores -1 into a stack target before `SetPtr`: `CItemUseTarget` has an
  inline default ctor `type = -1` (`ITEM_USE_TARGET_NONE`), declared in gamedata.hpp.
- `CMenuPosDataForm` (forward-declared; byte +1 = visible flag, floats +0xC/+0x10 = position,
  `GetPartInfo` returns a part whose +0x30/+0x34/+0x38 are written).

## CMenuFont (0xB8)
- `new(0xB8)` before `__ct__9CMenuFontFv` in `MakeDownLoadAnaunce` (editmenu).
- ctor: inline `CFont()` calls `Init()`, then body calls `Init()` again, `SetClearance(16, 20)`,
  `SetFuchi(5)`, `SetColor(0x80686A6B)`, `unk_b0 = unk_b4 = 0` (CFont fields; stored as `sw $0`).

## CDC2Mes (0x2A50)
Size: `new(0x2A50)` before every `__ct__7CDC2MesFv` call (17 sites).
| Off | Field | Evidence |
|---|---|---|
| 0x2958 | `u8 msg_change` | set to 1 by SetMsgItemNo/SetMsgVolumeNo when a value differs; StepMsg then sets `mes_no`(ClsMes 0x1E3C) = -1 and clears it. MenuItemKey (menusys) sets it too. |
| 0x2959 | `s8 cursor` | `lb`; SetMsgCursor/AddMsgCursor; StepMsg copies to ClsMes `select` (0x225C); ctor 0xFF |
| 0x295A/0x295C | `s16 text_off_x/y` | ctor -1; SetPutPos(int*) copies to `abs_text_off_x/y` (0x1AC/0x1B0) when `abs_win.w` (0x1A4) > 0; MsgPreset 3/8 set 0x10 |
| 0x295E | `s16 mes_no` | MakeMsg(int) stores; MakeMsg(char*) stores -1; StepMsg calls `MakeMesWin(int)` with it when `str[0]==0`; menuop compares with 0xBEB/0xC5C |
| 0x2960 | `u8 cursor_on` | ctor 1; DrawMsg when 0 saves `cursor_x/y` (0x2268/0x226C), sets them to -1000 around `DrawMesWin`, restores |
| 0x2961 | `u8 put_centering` | SetPutPos: `abs_win.x = (mgScreenWidth - text_w) >> 1` |
| 0x2962 | `u8 scissor_on` | DrawMsg: `SetMenuScissor(scissor)` / `ResetMenuScissor()` around draw |
| 0x2963..0x296F | `unk_2963[0xD]` | never accessed |
| 0x2970 | `mgRect<int> scissor` | ctor `Set(0,0,0,0)` then `Set(0,0,0x200,0x19F)`; MsgPreset `Set(0,0,mgScreenWidth-1,mgScreenHeight-1)`; passed by value to `SetMenuScissor(mgRect<int>)` |
| 0x2980 | `char str[0xC1]` | ctor `memset(0x2980, 0, 0xC1)`; MakeMsg(char*) strcpy; StepMsg `MakeMesWin(str,1,1)` |
| 0x2A41..0x2A4F | `unk_2a41[0xF]` | never accessed |

Both unknown gaps are exactly what a 16-byte-aligned `mgRect<int>` would produce (0x2963 -> 0x2970,
0x2A41 -> 0x2A50). Every `mgRect` member seen in ghidra sits at a 16-aligned offset. Unconfirmed;
if mgRect turns out aligned(16) the unk arrays become implicit padding.

The ctor's first `scissor.Set(0,0,0,0)` comes before the byte stores, so it may be an inline
`mgRect` default ctor rather than a body statement; mg_tanime.hpp's `mgRect` has no ctor yet.

No vtable. Order of ctor stores: Set(0..), 0x2958=0, 0x2959=-1, 0x295A/C/E=-1, 0x2960=1,
0x2961=0, 0x2962=0, Set(0,0,0x200,0x19F), memset.

ClsMes offsets used (names from nd_meswin.hpp): 0xB8 fuchi, 0xCC font_h, 0xD8 rows, 0xE0 text_w,
0x158 fukidashi_pos (SetAbsPos), 0x190 fade_speed (0.1f in presets 10/11/12/18/19), 0x198 open,
0x19C abs_win, 0x1AC abs_text_off, 0x1BC/0x1C0 point_x/y, 0x1E3C mes_no, 0x1E4C push_button,
0x1E50 centering, 0x1E58 alpha (SetMsgAlpha clamps 0..0x80), 0x1E59 name[16][50], 0x217C
item_mes[16], 0x21BC values[16], 0x21FC value_width[16], 0x2240 value_sign, 0x2244 value_zero,
0x2248 value_half, 0x225C select, 0x2268/0x226C cursor_x/y, 0x2270 select_shade, 0x2278
cursor_time (StepMsg clears it when select < 0), 0x230C line_pos, 0x23AC line_pos_on, 0x258C
line_w, 0x294C buff (StepMsg/DrawMsg do nothing when NULL).

### Functions
- `MsgPreset(int preset)`: MenuMesInit, cursor -1, mes_no 0, str[0]=0, cursor_on 1, centering/scissor
  0, full-screen scissor, then a switch on preset 0..0x13 (SetWindowMode values 0,2,3,4,5,6,8 —
  `MesWindowMode`), finally `value_half = 1` if `CheckNowEurope()`. Preset 0x13 calls
  `ClsMes::Preset(0)`. Preset 9 calls `SetFontColor(6,6,6,0x80)`; preset 7 `SetDefColor(0x80141414)`.
  Preset values are not named anywhere; left as int.
- `MsgPreset(int, int)`: second parameter unused (asm never reads $a2). Sets `value_half` when
  `LanguageCode == LANG_ENGLISH`.
- `AddMsgCursor(step, min, max, loop)`: loop==1 wraps, else clamps; returns `old != new`
  (`xor`/`sltu`) -> int. `AddMsgCursor2(min,max,loop)`: pad 0x1000 (up) = -1, 0x4000 (down) = +1;
  `MenuSePlay(0)` on move; returns cursor (lb -> char). `CommandMsgCursor`: max = count of
  `item_mes[i] > 0` minus 1 (min 0), loop 1. `YesNoCursor`: pad 0x8000 (left) -1, 0x2000 (right)
  +1, range 0..1 clamp. `YesNoCursor2(int alt)`: same, then `MenuCheckPushButton()` bit 1 confirms
  (1 if cursor 0 else 2), bit 4 confirms too when alt==1, bit 2 gives 2, else 0 -> `MesYesNoResult`.
- `SetMsgItemNo(int*, n)`: up to 16; copies into item_mes; a negative entry fills the rest with -1.
  `SetMsgItemNo(char**, n)`: strcpy into name[i]; NULL entry -> empty string (`at_1328`) and fills
  the rest with empty strings.
- `SetMsgVolumeNoOne(v)`: local `int tmp[2] = at_1371__2` (8-byte .sdata initialiser), `tmp[0] = v`,
  `SetMsgVolumeNo(tmp, 1)`.
- `SetMovePosCenteringGyou(line, cx, y)`: line 0..19; `line_pos[line] = {cx - line_w[line]/2, y}`,
  `line_pos_on[line] = 1`. `SetMsgItemPos(pos, n)`: n<=16 pairs into line_pos, guard line<20.
- `MakeMsg(CGameDataUsed*)`: NULL -> MakeMsg(0). Item number <= 0: `SetMsgItemNo(at_1415, 4)`
  (16-byte .data int[4]). Else mes = `GetItemMessageNo(no, 1)`, item 0x38 at time band 2 ->
  0xA2; `GetMsgAddInfo(&s0, &s1, vals)` (vals from `at_1407__2`, 12 bytes .bss) -> name[0..1],
  values[0..1]. value_sign=1, value_zero=0; item 0xB9 -> value_sign 0; 0x137 -> value_zero 1,
  value_sign 0.
- `MakeMsg(item, weapon)`: if weapon type (s16 at +0) == 3 and not fishing rod: cost = `item`
  byte +0x11; if `weapon->RemainFusion() < cost` -> 0xBA else values {cost, remain, remain-cost}
  (from `at_1436__3`), value_zero 1, value_sign 0, mes 0xBC. Otherwise name[0] =
  `weapon->GetName(1)` (local initialised from `at_1433__2`), mes 0xBD.
- `GetStringDrawWidthDC`: `max(GetStrWidth(str), 0)`.

## MENU_ITEM_MOVE_INFO (0x7C)
Array stride 0x7C in CMenuMoveItem (loops, memset/memcpy 0x7C); CommonSetMoveItemClass (menusys)
builds two on its stack, 0x7C apart, with the CGameDataUsed ctor run at +8.
| Off | Field | Evidence |
|---|---|---|
| 0 | `u8 active` | lbu; SetMoveItemInfo looks for 0, sets 1; CheckMove clears |
| 1 | `u8 mode` | 0/2 -> `CopyGameData`, 1 -> `CopyDataItem` (stack or swap); 2 -> `DeleteNum(GetNum()-1)` on start (carries one) -> `MenuMoveItemMode` |
| 2 | `unk_2[2]` | |
| 4 | `CGameDataUsed *dest` | CheckMove copies `item` into it; then nulls it |
| 8 | `CGameDataUsed item` | Init'd in CheckMove; +0xA (item number s16) read; +0x18 (CGameDataUsed+0x10, s16) shown for item 0x1AA |
| 0x74 | `s16 from[4]` | CommonSetMoveItemClass copies the four ints of its source row (kind 0/1/2/3/5, character, list 0/1, slot) as shorts. Not read in menucls1. |

## CMenuMoveItem (0x104)
`new(0x104)` + CGameDataUsed ctor loop from +0xC+8 stride 0x7C to 0x104 (MenuInventInit,
MenuModeMalloc, MenuShopInit). 0 `s8 move_on` (lb in CheckMove/caller), 4 `CMenuPosDataForm
*form[2]` (AttachForm: `MenuPosData->GetFormInfo("moveitem0"/"moveitem1")`, hides them, sets
part "num" to 0), 0xC `MENU_ITEM_MOVE_INFO info[2]`.
- CheckMove: per active info, if `!form->CheckMoveEnd()` counts it as moving and hides the form
  once `GetPutPosXY` passes (0x11E, 0x12E); else writes it, clears it, hides the form and calls
  `CheckEnableHaveItemNum()`. move_on = 0 when nothing moving; returns move_on (lb).
- SetMoveItemInfo(info, start, goal): first free slot; memcpy; form visible if item number > 0;
  form pos = (float)start[0..1]; `SetNextMovePos(goal, 2)`; part "item" +0x34 = item number,
  +0x38 = spectol number for 0xB9 or the s16 at item+0x10 for 0x1AA; part "num" +0x30=0,
  +0x34=GetNum(), +0x38=1; move_on = 1.
- Global pointer `MenuMoveItemPtr` lives in menumain.

## CMenuItemUse (0x1C)
Global instance `MenuItemUse` (menumain .bss, symbol size 0x1C). 0 `int item_no` (UseItem stores
the item number), 4 `int target_type` (UseItem stores `target->type`), 0x8..0x17 never accessed,
0x18 `s32 unk_18` (Initialize clears 0, 4, 0x18 only).
- `UseItem(item, int, void*)` has no epilogue move of $v0, so it returns the inner UseItem's
  result: callers (MenuItemCommandSelect) use it. Declared `int`.
- UseItem(item, target) also copies `*target` into `MenuUsedTarget` and calls
  `MenuUseItemCheckFunc(item, target, 1)`.

## Non-members
- `GetHatena`: two function-local statics with guards: `static char *MenuHatena = "？？？"`
  (`at_905__4`, 7 bytes SJIS) and `static char *MenuHatena_1byte = "???"` (`at_906__4`); returns
  the 1-byte one for `LANG_FRENCH..LANG_SPANISH` (2..5).
- `GetMenuBigNum(n)`: `MenuBigNum[n % 10]`. `SetMenuBigNum2`: 2 bytes per digit using
  GetNumberKeta + pow(10, k). `SetMenuBigNum`: same, but `CheckNowEurope()` uses the local static
  `sn_944` (char*[10], 0x28) and 1 byte per digit.
- `MenuMesInit(ClsMes*)`: resets most ClsMes fields (see m2c); returns void.
- `MenuUseItemCheckFunc(item, target, use)`: int count of effects that act; `use` != 0 applies
  them; when `use != 0` the result is replaced by the count of effects applied (`used`) for
  use == 1, or 0 for other non-zero values. Writes MenuUsedItemNo,
  MenuUsedItemType (= USEITEM_EFFECT.use_flags), MenuUsedNotErrorCode (1 when the gauge status
  bit 0x40 and use flag bit 0x10 block it). Uses `st_bittable_1654` (local static u32[7]).
  Target types 0..3 = ITEM_USE_TARGET_TYPE. Calls `CheckRoboShieldKit(user, target, use,
  &count, &used)` for item 0x1A7; at the end `used != 0` -> `DeleteNum(1)` + `MenuSePlay(se)`.
- `CheckRoboShieldKit`: target byte +4 == 0xB; limit = `GetShiledKitLimmit(no)`; compares with
  u16 at user+0x4848; returns 0xF (sound) when it raised, else -1.
- `CheckNowStateUseThisItem(item, target)`: tail call `MenuUseItemCheckFunc(item, target, 0)`.
  Ghidra mis-shows it with MenuUseItemCheckFunc's body.

## Globals
- `MenuBigNum` char*[10] (.data, 0x28): full-width digit strings; also read by
  `CGameDataUsed::GetName` (userdata).
- `MenuUsedItemNo`, `MenuUsedItemType`, `MenuUsedNotErrorCode` (.sbss, 4 each), `MenuUsedTarget`
  (CItemUseTarget, 8). Read in menusys (SetItemEffect, MenuItemCommandSelect).
- Native file-scope construction of `MenuUsedTarget` emits the exact retail
  `__sinit_menucls1_cpp` initializer; its constructor sets the target type to none.
- Skipped (local or compiler-generated): MenuHatena_894, init_895, MenuHatena_1byte_897, init_898,
  sn_944, st_bittable_1654, at_* literals.

## Guarded item-use draft
`MenuUseItemCheckFunc` has a guarded C++ draft covering all four target paths and their
item-specific branches. The ridepod item comparison is `&robo_data.parts[2]`; the character
branch reads the type of `equip[0]`; item 0x1AA uses `weapon.attribute[1]` as its recovery
amount. The status loop counts one possible effect even when multiple bits change. Retail
assembly remains the default until object-code matching is complete.

## Compiler flag
The nested local `divbyzerocheck on/reset` directives around the number-glyph
helpers are redundant with the unit's global flag: removing them produces an
identical complete `menucls1.cpp.o`.


## Native data and matching constraints

All data are native. GetHatena owns its question-mark string-pointer statics and
compiler guards. The seven-word st_bittable has declared size 0x1C with four alignment
bytes. Its native identity requires a mutable .data definition, exact declared
bytes/extent and complete consumers with resolved relocations. ASCII digit pointers and
strings identify one another through their real relocation fields; zero initializer
templates retain their declared sizes.

MenuBigNum is a forty-byte table of ten full-width digit pointers. SetMenuBigNum owns a
ten-pointer ASCII digit table; both use char pointers. The mutable seven-mask status
table uses CHARA_STATUS_ATTR in ascending bit order. A const definition emits .rodata
instead of retail .data and must be rejected rather than rewritten. Message-preset
switches, two-volume and four-unavailable-item initializers supply their own templates.
