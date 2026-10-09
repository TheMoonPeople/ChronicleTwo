# nameregi: reverse-engineering notes

Name entry screen of the menus. No first-game counterpart (Dark Cloud has no `nameregi` unit);
first-game `nd_meswin` `NameRegistTbl` is unrelated.

## Status

All 30 functions are native; the unit has no `INCLUDE_ASM` and no guarded drafts. All read-only,
initialized and BSS data is native source; no assembly-supplied markers remain.

## CNameRegiMenu (size 0xBC8)
- Size: `NameRegistInit` does `new (NameRegiStack.Alloc(0xBF)) CNameRegiMenu` with `__nw__FUiP1(0xBC8, ...)`.
- Base `CBaseMenuClass` (0x110, vptr at 0x10C): ctor `__ct__14CBaseMenuClassFv` then
  `__vt__13CNameRegiMenu` stored at 0x10C.
- Vtable `__vt__13CNameRegiMenu` (0x37C6D0, 0x20): only the six `CBaseMenuClass` inlines
  (IsCreateObject, IsMakeObject, IsAskExtend, ItemCmdAfter, InitEnd, ExitEnd). No overrides,
  no new virtuals. The compiler emits the complete 32-byte vtable from the class definition.
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
| 0x3C8 | jis_table char[0x800] | built from jis_ptr_table strings skipping '\n'; CopyAsciiToJis indexes `[ascii_code_table index * 2]`. jis_ptr_table is {NULL, NULL} in PAL so the table is empty here |

`CBaseMenuClass` fields this unit uses: `mode` (0 input, 1 opening, 2 closing, 13 message:
`NAMEREGI_MODE`), `unk_6` as the message sub-step (10, 0x14, 0x1E, 0x28 seen in KeyStep), and
`key_arg_no` (0x14) as 1 = cursor on the grid, 0 = cursor on the button row. Those base field
names belong to menusys.hpp.

## MENU_SELECT_PARAM
Only offset 0 (int) is ever touched (nameregist_local_key). Declared with one field and no size
assert; whether 0x118 (kanji_line) belongs to it is unknown.

## NAMEREGI_TARGET_INFO (Nameregi_Target, 0x48, global)
- +0 s16 target: written with `sh` by menuaqua (0 fish of aquarium as item, 3 gyorace), menumain
  MenuMainInit (2), menusys ItemCmdAfter (0 item / 1 ridepod when item type is 0xB), menumap
  SphidaMenuKey (4). Read with `lh` in KeyStep.
- +4 CGameDataUsed *item: NameRegistInit target 0 takes GetName(0) when used_type is 3/5/6.
- +8 char keyword[0x40]: SetEventKeyword strcpy; NameRegistInit memsets 0x40 for target 4;
  KeyStep strcmp for target 2 (also accepts keyword "SIRUS" with input "Sirus"; both literals
  are inline strings in KeyStep); SphidaMenuKey reads it back.
- The 0x48-byte record occupies a 0x50-byte retail piece; the eight trailing bytes are padding.
- Enum `NAMEREGI_TARGET` values from NameRegistInit message numbers (4000 + 0/1/0x6E/0x78) and
  KeyStep branches. Type name and enum names are not retail.

## Kanji tables
`NameRegiSearchKanjiIndexTable` is 46 native 16-byte `NAMEREGI_KANJI_INDEX` records
{code[2] at 0, s16 num at 4 (written as short), list pointer at 8}: 45 code boundaries and an
all-zero last row. The loops process 44 readings (0x2C) and use the next row as a code
boundary. CheckChronicleKanjiFont walks Shift-JIS codes from row i to row i+1 (max 0x200),
and for each code GetFontNo finds, allocates a 16-byte block (`Alloc(1)`) as
`NAMEREGI_KANJI_NODE` {code[2], next at 4}. Returns the total.
GetNameRegistFontKanjiList(cell): returns 1 and the reading char from `testchar[row*2]` at a
row start, 0 and the kanji for a list entry, 2 and 0x8140 (full-width space) for the cell after
a row, -1 past row 0x2B.

`testchar` (0x5D bytes: 46 Shift-JIS pairs plus the NUL) and `txt_table2` (0x75 bytes: 58
pairs plus the NUL) are NUL-terminated `s8[]` string arrays indexed `[i * 2]`/`[i * 2 + 1]`.
Their retail extents are odd, so an `[N][2]` declaration cannot match them. `txt_table` is a
59-byte ASCII string (the password alphabet without `l`, `o`, `I`, `O`).

## Character set (NAMEREGI_FONT_MODE)
`NameRegistFont_Table` (0x3C as 5 x 3 pointers, `FontTables[NAMEREGI_FONT_MODE_NUM]`):
mode 0 ALPHA_TABLE1/2, STR_NUM_TABLE; 1 HIRA_TABLE1..3; 2 KATA_TABLE1..3; 3 none (kanji);
4 KIGOU_TABLE1/2 (replaced with KIGOU_TABLE_ASCII1/2 when LanguageCode>0). The catalog
relocates directly to writable character arrays: `ALPHA_TABLE1[28]`, `ALPHA_TABLE2[28]`,
`STR_NUM_TABLE[14]`, six `HIRA_TABLE*`/`KATA_TABLE*` arrays each holding `" "`,
`KIGOU_TABLE1[1] = ""`, `KIGOU_TABLE2[2] = " "`. The small kana/symbol objects are character
arrays, not pointers. `KIGOU_TABLE_ASCII1[31]` is a fixed string; `KIGOU_TABLE_ASCII2[128]`
starts as one space with the rest zero and is rewritten by NameRegistInit in Europe from a
local `int ranges[17]` code-range list (pairs terminated by -1), 15 characters per line.
`ascii_code_table[95]` holds the ASCII order used to index jis_table.
`NameRegistGyouLimmitTable` = columns per row {13, 15, 15, 19, 15}. `NameStrSelectModeTable`
rows of 6 signed chars: JP {2,1,0,4,3,-1}, others {-1,-1,0,4,-1,-1}.
ConvertNameRegiBaseBoardTable(font_mode) maps mode to its button through `convtbl_1792`
(`BoardTable {{2, 1, 0, 4, 3}}`) or, for non-JP, a local `BoardTable alternate = {{0, 0, 0, 0, 4}}`.

## Globals
Global: `Nameregi_Target` only (in header). Everything else is LOCAL in retail
(local_symbols.tsv) and is `static` in the .cpp: Sfida_default_Name (`char*[7]`: the Japanese
Shift-JIS default followed by six `"Max"`, with four zero padding bytes after the piece),
ALPHA_TABLE1/2, STR_NUM_TABLE, KIGOU_TABLE_ASCII1/2, ascii_code_table, NameRegistFont_Table,
NameStrSelectModeTable, NameRegiSearchKanjiIndexTable, testchar, txt_table/txt_table2 (ASCII
<-> Shift-JIS pairs), nameregist_baseboard_upper_table (`BoardPoint[6][12]`, s16 x,y pairs of
the buttons), NameRegistMax (s16: 10, 20 non-JP, 0x16 for passwords), HIRA/KATA/KIGOU_TABLE*,
jis_ptr_table (`char*[2]`, both NULL), NameRegistGyouLimmitTable, NameRegiCode (s8,
SetEventKeyword's code; one byte in a four-byte piece), NameRegiMenuPtr (CNameRegiMenu*),
OldReloadTexNumber (int, MenuReloadTexture cache, reset to -1 by NameRegistDraw),
NameRegiTex1/NameRegiBGTile/NameRegiCursor/NameRegiWaku/NameregiGaiji (mgCTexture*; the last
pointer has four trailing alignment bytes), NameRegiTopic (char[0x40], event topic shown for
target 2), NameRegiStack (mgCMemory, `__sinit` calls mgCMemory::Init on it).

Other named local tables: `LimmitTable_1360[5]` (s16 cells per mode), `Convtable2_1382[2][5][8]`
(s8), `addTable_1510[5][4]` (s16), `colt_1808[2]` (BoardColor), `table_1819[7][5]` and
`tex_commtbl_1822[7][6]` (BoardRect), `gettbl0_2012[12]` (s16), `convTbl_1579[5]` (s8),
`get_Htable_1806[4]` (slice heights `{100, 16, 32, 0}`).

Compiler-generated data: `AdjustWaku` initializes `{0, 36}` locally; the position, Japanese and
localized navigation, and alternate board tables are local aggregate initializers; `DrawMessage`
initializes a typed `RGBAQ_TYPE` with four 0x80 channels and Q bits 0x3F800000. `NameRegistInit`
initializes its three name pointers with `{{NULL, NULL, NULL}}` (`NameRegiItemNames`), five
`KeyStep` message argument pairs initialize `{{NULL, NULL}}` (`NameMessageArguments`), and the
33-byte password key initializes `{{0}}` (`PasswordKey`). These zero aggregates are the
compiler's anonymous BSS templates (8, 12 and 33 bytes); their retail pieces are larger with
zero tails. Ten function strings are inline: eight resource names in `NameRegistInit` and
`"SIRUS"`/`"Sirus"` in `KeyStep`.

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
  through `out` also avoids an unnecessary signed-byte pointer cast.
- `CNameRegiMenu::DrawMessage` constructs its `mgCDrawPrim` local immediately
  after reloading the message texture. A typed local at that point reproduces
  the retail stack layout and constructor call without a raw byte buffer or
  placement-new cast.
- `CNameRegiMenu::DrawActiveFont`'s `DrawMenuFillBox` call needs the binary32 height 21
  (`0x41A80000`) evaluated first; the build profile's argument scheduling handles this without
  a source change.
- `StepMarkCursor` is wrapped in `#pragma divbyzerocheck on` / `reset`; the directives are
  redundant with the compiler-wide flag.
- `KeyStep`'s twelve confirmation/cancellation pairs are a plain local
  `s16 command_table[12][2]`; `command_events` indexes it directly with no wrapper type or
  halfword cast.
- `DrawSelectedWord` reads the texture block as `NameRegiTex1->block`; `search_txt_asci` takes
  `s8 *character = text` without a cast; `NameRegistInit`'s `cursor_img` takes
  `GetMenuMainIMGPtr`'s `u_char *` directly.

## Password confirmation in KeyStep

The fish-password branch converts the Shift-JIS input to ASCII, terminates the input at 22
characters, copies the fish name into a 20-byte decoding key, decodes up to 16 bytes, and
interprets the first 14 decoded bytes as the fish record. Failed decoding or a first packed
item identifier below 0x136 opens message 0x1011; success installs the decoded fish and opens
message 0x1012.

`decoded` is a `u8[0x20]` array and `key_text` is already a `u8*`. The call keeps two explicit
casts, `DecodePassword(password, (u8 *) decoded, 0x10, (u8 *) key_text, 0x14)`, which preserve
the types and only set MWCC operand evaluation rank: retail prepares the output address, then
the key pointer, then the input address and size (`a1`, `a3`, then `a0`, `a2`). Without the
casts the argument registers are set up in source order.
