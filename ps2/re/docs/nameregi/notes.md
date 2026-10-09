# nameregi: reverse-engineering notes

Name entry screen of the menus. No first-game counterpart (Dark Cloud has no `nameregi` unit);
first-game `nd_meswin` `NameRegistTbl` is unrelated.

## CNameRegiMenu (size 0xBC8)
- Size: `NameRegistInit` does `new (NameRegiStack.Alloc(0xBF)) CNameRegiMenu` with `__nw__FUiP1(0xBC8, ...)`.
- Base `CBaseMenuClass` (0x110, vptr at 0x10C): ctor `__ct__14CBaseMenuClassFv` then
  `__vt__13CNameRegiMenu` stored at 0x10C.
- Vtable `__vt__13CNameRegiMenu` (0x37C6D0, 0x20): only the six `CBaseMenuClass` inlines
  (IsCreateObject, IsMakeObject, IsAskExtend, ItemCmdAfter, InitEnd, ExitEnd). No overrides,
  no new virtuals.
- There is no out-of-line ctor. The construction in `NameRegistInit` is: base ctor, vptr,
  `CFont::Init` at 0x180 (member `CFont() { Init(); }`), a pointer loop calling `CFont::Init`
  from 0x308 while `< 0x3C0` stepping 0xB8 (an array `CFont[1]`, hence `grid_font[1]`).
  The implicit ctor reproduces exactly this. Everything after (field clears, second
  `CFont::Init(0x180)`, SetClearance(0x18,0x14)/SetFuchi(5)/SetColor(0x80686A6B), clearing
  name_font.unk_b0/unk_b4 at 0x230/0x234, building jis_table, ChangeFontSelectMode) is inline
  code in `NameRegistInit` (either written there or an inline helper).

| Off | Field | Evidence |
|---|---|---|
| 0x110 | select_mode int | init 0, or 2 if LanguageCode>0; GetActiveFontMode `NameStrSelectModeTable[select_mode + lang*6]`; KeyStep copies command_pos into it on a set button |
| 0x114 | select (MENU_SELECT_PARAM) | `&this->0x114` passed to nameregist_local_key; int pos (GetSelectedActiveFont reads it with `lh`, i.e. `(short)pos`) |
| 0x118 | kanji_line int | KeyStep +/-6 on L/R in kanji mode, clamped to 0..kanji_line_max; GetNameRegistFontKanjiList(pos + kanji_line*19) |
| 0x11C | command_pos int | init 0/2; ConvertPositionNameRegi sets 5..11 from grid column, and grid pos from it; StepMarkCursor; values 0..4 are character set buttons |
| 0x120 | unk_120 | only cleared in init |
| 0x124 | kanji_cell_num | `CheckChronicleKanjiFont(...) + 0x58` |
| 0x128 | kanji_page_num | kanji_cell_num / 0x72 (114 = 19*6) |
| 0x12C | kanji_line_max | kanji_page_num * 6 |
| 0x130 | cursor_snap u8 | init 1; passed as last arg of CalcMenu1 in StepMarkCursor, then cleared |
| 0x134/0x138 | cursor_x/y float | CalcMenu1(target, &0x134 / &0x138); DrawMarkCursor |
| 0x13C | cursor_cnt int | ++ each StepMarkCursor unless mode==13; DrawMarkCursor cos/sin of it |
| 0x140 | waku RECT | AdjustWaku(.., this+0x140); DrawMessage passes it by value to DrawVersatileWin_1 |
| 0x150 | password_input int | set 1 after a fish (target 3) gets item_no 0x140/used_type 6, with NameRegistMax=0x16; then input goes through ConvertShitJiss2Ascii + DecodePassword; while set the character set buttons give error SE |
| 0x154 | unk_154 | never seen |
| 0x158 | button_flash s16[16] | init loop 16 shorts; KeyStep sets [5]..[9] (0x162..0x16A) to 8; DrawBaseBoard decrements while >0 |
| 0x178/0x17C | select_box_x/y float | StepMarkCursor stores grid cell position; DrawActiveFont DrawMenuFillBox(x, y, 14, 21, ...) |
| 0x180 | name_font CFont | DrawSelectedWord SetPos/SetStr(name)/DrawDirect |
| 0x238 | caret_cnt int | DrawSelectedWord `caret_cnt % 0x50 < 0x28`; KeyStep sets 0x28 on edits |
| 0x23C | wave_angle float | KeyStep += 0.0698 wrapping at 2pi; DrawBaseBoard sinf |
| 0x240 | old_name char[0x61] | memset 0x61; strcpy of the starting name; strcmp to detect a change |
| 0x2A1 | name char[0x61] | memset 0x61; the name being typed (Shift-JIS, ASCII in Europe) |
| 0x304 | name_pos int | caret index; clamped to NameRegistMax-1 |
| 0x308 | grid_font CFont[1] | ChangeFontSelectMode re-inits it; clearance 0x18/0x16/0x30 by mode |
| 0x3C0 | message_open int | DrawMessage dims screen and draws MenuDCMsg[7] when set |
| 0x3C4 | tile_scroll float | DrawBaseBoard DrawMenuTilePattern offset, += 0.5 wrapping |
| 0x3C8 | jis_table char[0x800] | built from jis_ptr_table strings skipping '\n'; CopyAsciiToJis indexes `[ascii_code_table index * 2]`. jis_ptr_table is {0,0} in PAL so the table is empty here |

`CBaseMenuClass` fields this unit uses: `mode` (0 input, 1 opening, 2 closing, 13 message:
`NAMEREGI_MODE`), `unk_6` as the message sub-step (10, 0x14, 0x1E, 0x28 seen in KeyStep), and
`key_arg_no` (0x14) as 1 = cursor on the grid, 0 = cursor on the button row. Those base field
names belong to menusys.hpp and were not changed.

## MENU_SELECT_PARAM
Only offset 0 (int) is ever touched (nameregist_local_key). Declared with one field and no size
assert; whether 0x118 (kanji_line) belongs to it is unknown.

## NAMEREGI_TARGET_INFO (Nameregi_Target, 0x48, global)
- +0 s16 target: written with `sh` by menuaqua (0 fish of aquarium as item, 3 gyorace), menumain
  MenuMainInit (2), menusys ItemCmdAfter (0 item / 1 ridepod when item type is 0xB), menumap
  SphidaMenuKey (4). Read with `lh` in KeyStep.
- +4 CGameDataUsed *item: NameRegistInit target 0 takes GetName(0) when used_type is 3/5/6.
- +8 char keyword[0x40]: SetEventKeyword strcpy; NameRegistInit memsets 0x40 for target 4;
  KeyStep strcmp for target 2 (also accepts keyword "SIRUS" with input "Sirus", at_1747/1748);
  SphidaMenuKey reads it back.
- Enum `NAMEREGI_TARGET` values from NameRegistInit message numbers (4000 + 0/1/0x6E/0x78) and
  KeyStep branches. Type name and enum names are not retail.

## Kanji tables
`NameRegiSearchKanjiIndexTable` (0x2E0 = 46 rows of 0x10, loops use 44 = 0x2C):
`NAMEREGI_KANJI_INDEX` {code[2] at 0, s16 num at 4 (written as short), list pointer at 8}.
CheckChronicleKanjiFont walks Shift-JIS codes from row i to row i+1 (max 0x200), and for each
code GetFontNo finds, allocates a 16-byte block (`Alloc(1)`) as `NAMEREGI_KANJI_NODE`
{code[2], next at 4}. Returns the total. GetNameRegistFontKanjiList(cell): returns 1 and the
reading char from `testchar[row*2]` at a row start, 0 and the kanji for a list entry, 2 and
0x8140 (full-width space) for the cell after a row, -1 past row 0x2B.

## Character set (NAMEREGI_FONT_MODE)
`NameRegistFont_Table` (0x3C here as 5 x 3 pointers): mode 0 ALPHA_TABLE1/2, STR_NUM_TABLE;
1 HIRA_TABLE1..3; 2 KATA_TABLE1..3; 3 none (kanji); 4 KIGOU_TABLE1/2 (replaced with
KIGOU_TABLE_ASCII1/2 when LanguageCode>0). `NameRegistGyouLimmitTable` = columns per row
{13, 15, 15, 19, 15}. `NameStrSelectModeTable` rows of 6 signed chars: JP {2,1,0,4,3,-1},
others {-1,-1,0,4,-1,-1}. ConvertNameRegiBaseBoardTable(font_mode) maps mode to its button
(convtbl_1792 / at_1795 for non-JP).

## Globals
Global: `Nameregi_Target` only (in header). Everything else is LOCAL in retail
(local_symbols.tsv) and belongs as `static` in the .cpp: Sfida_default_Name (char*[7], followed by four zero padding bytes,
default Spheda course names per language), ALPHA_TABLE1/2, STR_NUM_TABLE, KIGOU_TABLE_ASCII1/2
(ASCII2 is rewritten at init in Europe from at_1153 code ranges, 15 per line), ascii_code_table,
NameRegistFont_Table, NameStrSelectModeTable, NameRegiSearchKanjiIndexTable, testchar,
txt_table/txt_table2 (ASCII <-> Shift-JIS pairs, 0x3A entries), nameregist_baseboard_upper_table
(s16 x,y pairs of the buttons), NameRegistMax (s16: 10, 20 non-JP, 0x16 for passwords),
HIRA/KATA/KIGOU_TABLE* (one- or two-byte writable character arrays), jis_ptr_table, NameRegistGyouLimmitTable,
NameRegiCode (char, SetEventKeyword's code), NameRegiMenuPtr (CNameRegiMenu*),
OldReloadTexNumber (int, MenuReloadTexture cache, reset to -1 by NameRegistDraw),
NameRegiTex1/NameRegiBGTile/NameRegiCursor/NameRegiWaku/NameregiGaiji (mgCTexture*),
NameRegiTopic (char[0x40], event topic shown for target 2), NameRegiStack (mgCMemory 0x30,
`__sinit` calls mgCMemory::Init on it).

## Functions
- File-local in retail (static, not in header): search_txt_jis, search_txt_asci,
  CheckInputWord (trims trailing spaces / full-width spaces), nameregist_local_key.
- NameRegistKey is `return NameRegiMenuPtr->KeyStep();` (Ghidra shows KeyStep inlined text).
- NameRegistInit's third parameter (`open_type`, from CMenuKeyFunc::open_type in MenuMainInit,
  4 from Sphida, 0 from Gyorace) is never read.
- addTable_1510: rows of 4 s16 (`step` for nameregist_local_key: [0] row step, [1] columns,
  [2] wrap left, [3] wrap right), indexed by font mode; LimmitTable_1360 cells per mode.
- CheckDeleteNameRegisteItem: true for used_type 3/5; KeyStep then DeleteItem(0x180, 1)
  (item 0x180's meaning not established).

## Matching details
- `GetNameRegistFontKanjiList` advances both the logical character position
  and the kanji row after each row. Incrementing `position` before `row` gives
  the retail branch delay-slot schedule. Writing the fallback code directly
  through `out` also avoids an unnecessary signed-byte pointer cast; the
  complete function matches.
- `CNameRegiMenu::DrawMessage` constructs its `mgCDrawPrim` local immediately
  after reloading the message texture. A typed local at that point reproduces
  the retail stack layout and constructor call without a raw byte buffer or
  placement-new cast; the complete function matches.
- `CNameRegiMenu::DrawActiveFont` draws the active font grid and its Kanji
  marks. Its C++ body passes an isolated whole-image check with the game
  compiler flags, including the `DrawMenuFillBox` arguments.
- The unit-local `divbyzerocheck` on/reset directives are redundant with the
  compiler-wide flag: removing all three pairs leaves every section and
  symbol in the unit's object diff unchanged.

## Password confirmation in KeyStep

The fish-password branch converts the Shift-JIS input to ASCII, terminates the input at 22 characters, copies the fish name into a 20-byte decoding key, decodes up to 16 bytes, and interprets the first 14 decoded bytes as the fish record. Failed decoding or a first packed item identifier below 0x136 opens message 0x1011; success installs the decoded fish and opens message 0x1012. The two explicit pointer casts at `DecodePassword` set MWCC operand evaluation rank: retail prepares the output address, then the key pointer, then the input address and size. They preserve pointer types and array bounds and add no instructions. The complete 5228-byte native `KeyStep` body has zero differing instruction words against PAL; the final four bytes of its 5232-byte symbol extent are zero alignment padding. No calls, data definitions, or relocation targets change. After the canonical `fixup_sections.sh` pass removes compiler-generated duplicate-data intermediates, the PAL object checker verifies the whole unit's 0x4C58 allocated bytes and 792 relocations with no findings. The external Python parser override is active during this validation.

## Password-call operand rank after merge

`decoded` is a `u8[0x20]` array and `key_text` is already a `u8*`. Their two explicit `u8*` casts in `DecodePassword` preserve these types and alter only MWCC operand rank. Removing them introduced the merged `KeyStep` difference; restoring them removes that canonical finding. Together with the `DrawActiveFont` policy below, the canonical unit checks `0x4C3C` allocated bytes and 801 resolved relocations with no findings.

## Active font rectangle argument order

`DrawActiveFont__13CNameRegiMenuFv` requires the binary32 height 21
(`0x41a80000`) to evaluate first. The stable function/type/value selector
restores retail rectangle argument scheduling without changing the source
body. With the typed password-call casts, the entire nameregi unit passes
canonical byte and resolved-relocation comparison.

## Name command event array

KeyStep's twelve confirmation/cancellation pairs fit a plain local
s16 command_table[12][2]. The single-member NameCommandEvents wrapper is
unnecessary; command_events indexes the local array directly. The isolated
canonical object preserves all checked bytes and 801 resolved relocations
(0x4C34 bytes), and the production PAL build and all 149 objects pass.
No other KeyStep expression or function guard changes.

Probe: .private/fixes-r0/probes/nameregi-array/{compile,objects}.log.
Production receipts: .private/fixes-r0/nameregi-final-{build,objects}.log.
