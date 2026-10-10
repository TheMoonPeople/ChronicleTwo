# nd_meswin: reverse-engineering notes

`ClsMes::Preset` builds from C++ and passes full-image verification. Its fade
reset uses a typed floating-point assignment with the same retail code.

`ClsMes::GetMesWidth_system` scans the system message's 16-bit codes and
returns the widest line. It expands registered names and display controls,
uses the half-font width for narrow glyphs, and returns -1 for an invalid
message or missing system text. Its C++ implementation matches retail.

`ClsMes::SetGoalCursorXY` targets a yes/no choice coordinate in
`MES_WIN_YESNO`. In other modes it places the selection marker beside the
selected text line, adjusts for centered text, and shifts it by half the
difference between the text width and the widest visible line. Its C++
implementation matches retail.

## Matching status

All functions are native; no assembly function fallback remains.

## Header dependencies
- `ClsMes : public CFont`; `font.hpp` owns the base and is included by
  `nd_meswin.hpp`. The base occupies 0xB8 bytes.
- `sizeof(CFont) == 0xB8`: `MovieCCFont` and `dbFont` symbols are 0xB8; `CFont::Init` writes
  0x00..0xB7 (memset 0x80 text, 0x80 fuchi, 0x88 rgba bytes, 0x90..0xB4 ints).
  `ClsMes()` also zeroes CFont's 0xB0/0xB4 after `Init` (same pattern as `CMenuFont()` in
  menucls1); CFont's own constructor is inline and calls `Init()` (Init is called twice in a row
  at the start of `ClsMes()`).
- `RECT` and `RGBAQ_TYPE` are shared font types declared in `font.hpp`.
  `RECT` contains x, y, width and height. `RGBAQ_TYPE` contains four one-byte
  channels and a float q, occupies eight bytes and has eight-byte alignment.
  RgbqToUint and GetFontColor return it by value using a hidden return pointer.
- `mgRect<int>` from `mg_tanime.hpp` (by-value params of the set2DSprite functions).
  `mgCDrawPrim`, `CCharacter2` forward-declared.

## ClsMes size and layout
`sizeof(ClsMes) == 0x2958`: `__nw__FUiP1(0x2958, ...)` in InitDungeonMain, sgInitGyoRace,
CAquaMes::Initialize; globals PauseMes, SystemMessage{,2,3}, EventMes1, HelpMes are 0x2958.
`CDC2Mes` (menucls1) derives from it and starts its own fields at 0x2958. No vtable.

Offset -> evidence (ctor = `__ct__6ClsMesFv`; "Init block" = the reset shared by Preset,
dngmenu `Init__6ClsMesFv` and menucls1 `MenuMesInit`):
- 0xB8 fuchi: passed to `CFont::SetFuchi` at top of DrawMesWin; Preset/SetWindowMode set 0,1,2,4,5,8.
- 0xBC npc_name_mode: Step calls StepNpcName when ==1; Preset(3) sets 1.
- 0xC0/0xC4 text_x/y: DrawFont adds to each char's x/y. 0xC8 font_w (15), 0xCC font_h (24,
  line height: `y / font_h` = line index everywhere). 0xD0 float half-width ratio
  (SetHalfFontWPercent, default 0.55). 0xD4 columns (70), 0xD8 rows (5); ctor sets
  fukidashi_w = font_w*columns, fukidashi_h = font_h*rows.
- 0xDC char_num (= tbl_num after layout, MakeMesWin). 0xE0/0xE4 text_w/h (NeedMesWinWH output,
  used as inner RECT w/h in DrawMesWin). 0xE8 page, 0xEC page_num. 0xF0 s32[16] page_chars
  (AddPage).
- 0x130/0x134 last drawn char screen x/y (DrawFont).
- 0x138 window_mode (MesWindowMode; DrawMesWin switch). 0x13C bg_opaque.
- 0x140/0x144 bubble centre (AutoSet: fukidashi_x + w/2); -1 = unplaced (StepNormal skips mode 1
  until placed). 0x148..0x154 bubble x,y,w,h. 0x158 forced slot (CalcFukidashiXY uses slot-1;
  SetOuterRectXYFromFukidashiPos when >0). 0x15C tail_on. 0x160/164 tail target, 0x168/16C tail
  root, 0x170 half width (8), 0x174 length (0x30), 0x178..0x18C two root corners and tip
  (computed in StepNormal with RollPos/atan2).
- 0x190 fade_speed (0.1; Preset 5 sets 0.2), 0x194 fade 0..1, 0x198 open flag (State).
- 0x19C RECT abs_win (SetAbsWinData; AquaMesDispAdjustPos writes x/y). 0x1AC/0x1B0 text offset
  inside fixed frame (-1 -> waku_data). 0x1B4/0x1B8 float draw offsets (all Draw*).
  0x1BC/0x1C0 pointer offset passed to MyMenuFloatingWinDraw / DrawDQFukidashi.
- 0x1C8 RGBAQ_TYPE win_color (ctor bytes 0x27,0x20,0x20,0x80; passed as RGBAQ_TYPE* to
  MyMenuFloatingWinDraw). 0x1CC is its q.
- 0x1D0 draw_speed, 0x1D4 draw_speed_def (SetDrawSpeed: 1.2 for LanguageCode 1..4,5 else 0.6).
- 0x1D8 page_wait, 0x1DC page_auto (GetPageAutoFlg), 0x1E4 scroll_wait (State==6; Step clears
  when scroll_y reaches goal), 0x1E8 float reveal, 0x1EC reveal_num, 0x1F0 page_top (GoNextPage
  sets = reveal_num; DrawFont loops page_top..reveal_num).
- 0x1F8 MES_WIN_TBL[450] (InitMesWinTbl loop 0x1C2 entries x 0x10; SetMesWinTbl bounds 0x1C2):
  +0 u16 code, +2 s16 x, +4 s16 y, +8 u32 colour (from `color`), +0xC u8 wait (0xFExx adds low
  byte to previous entry; MyTextureMake_sub loads it into `wait`).
- 0x1E18 tbl_num, 0x1E1C scroll_y, 0x1E20 scroll_goal, 0x1E24 scroll_speed (Step adds to each
  entry's y). 0x1E28 def_color, 0x1E2C color (SetDefColor, SetMesWinTbl colour codes).
- 0x1E30 wait, 0x1E34 page_time (DrawMesWin ++), 0x1E38 page_auto_time (30), 0x1E3C mes_no
  (MakeMesWin: -1 none, -2 string; DrawMesWin returns when -1).
- 0x1E44 char* / 0x1E48 size: written only by event_func `_LOAD_MES_sub` (memcpy'd file).
- 0x1E4C push_button (DrawPushButton returns when 0), 0x1E50 centering (CalcCenteringXY),
  0x1E54 line_indent_on (DrawFont adds line_indent[line]).
- 0x1E58 u8 alpha (0x80). 0x1E59 char[16][50] name (memset 0x32 x 16; strcpy by
  StepNpcName, BookshelfMessageMake; GetStrWidth(int)). 3 bytes padding to 0x217C.
- 0x217C s32[16] item_mes (codes 0xFBFE,FD,FC,FB,F2..E7 -> [0..15]; -1 init; editmenu writes).
- 0x21BC s32[16] values, 0x21FC s32[16] value_width (MakeMesWinTbl_value(int,..)).
- 0x223C value, 0x2240 sign ("+%d\n" vs "%d\n"), 0x2244 print-zero, 0x2248 half-width digits
  (GetHalfFontNo), 0x224C digit spacing. 0x2250 digit_font (DrawFont -> DrawDigit).
- 0x2254 space_w (0xF8xx low byte, or CalcSpaceW result), 0x2258 justify_w ((0xF7xx low)*4);
  both -1 at line start in MakeMesWinTbl/NeedMesWinWH.
- 0x225C select line (-1), 0x2260/64 goal cursor, 0x2268/6C cursor, 0x2270 select_shade
  (GetGyouAlpha: 2 -> others FAINT, 1 -> selected BRIGHT, 0 -> others DARK, -1 none),
  0x2274 cursor_centering, 0x2278 cursor_time, 0x227C s32[2][2] yes/no positions
  (CalcSelectCursorPos output; indexed `select*8` in SetGoalCursorXY; DrawYesNo args),
  0x228C select_top, 0x2290 cursor y offset.
- 0x2294 voice_on, 0x2298 voice_type (FF04->1, FF05->0, FF06->2; SE 7/5/6 via sndSePlay every
  3rd char), 0x229C voice count (alternates pan arg). 0x22A0 close_time (Step counts down, then
  closes and SetWindowMode(10)).
- 0x22A8 scissor_on + 0x22AC RECT scissor (DrawFont: GS SCISSOR via Direct(0x40, ...)).
- Per-line arrays, 20 entries (StepNpcName/ctor loop 0x14):
  0x22BC line_indent, 0x230C line_pos[20][2], 0x23AC line_pos_on, 0x23FC line_shade (4 = not
  drawn in DrawFont; <0 automatic), 0x244C line_color (non-zero -> RgbqToUint(line_color)
  replaces char colour; DrawEquipment/Cross/RightDelta likewise), 0x249C/0x24EC/0x253C equip
  on/x/y, 0x258C line_w (AddYokoHaba/SetYokoHaba; <0 = past last line), 0x25DC line_alpha
  (-1 = use `alpha`), 0x262C/0x267C/0x26CC cross on/x/y, 0x285C/0x28AC/0x28FC delta on/x/y.
- 0x294C short* buff (SetBuff, GetTextLineDataTop), 0x2950 short* buff_system.

Unused/unknown (only initialised, or untouched): 0x1C4, 0x1E0, 0x1E40, 0x1F4, 0x22A4,
0x271C[20] (-1), 0x276C[20] (-1), 0x27BC[20], 0x280C[20], 0x2954. Grep other units with the
owning variable names (DngMess, EventMess, SystemMessage...) if they turn up.

## Member functions
- `Init()` (0x1F38E0, emitted in dngmenu) is the inline reset that Preset and menucls1
  `MenuMesInit` inline too; defined in the
  class body. It supplies the shared reset preceding Preset's mode switch.
- `GetFontColor(int index, int *fuchi)` returns RGBAQ_TYPE by value. `GetDrawSpeedDef` returns
  float (MyTextureMake compares as float). `GetCaptionOff` returns a byte from save data +0x1C5A8
  (declared u8). `MakeMesWin` both overloads are void (no v0 at return).
- `MyTextureMake_sub` returns 0 / 1 (page) / 2 (0xFF01).
- `AddPage(last, page)`: page_chars[page] = last+1 - sum(page_chars[0..page-1]).

## Enums
- MesWindowMode values from DrawMesWin switch and SetWindowMode (2 is stored as 4; 12 as 0).
  Names beyond FUKIDASHI/YESNO/HELP/FLOATING/VERSATILE_* follow the draw call used.
- MesPreset 0..6 from Preset switch. Names are descriptive, not retail.
- MesCode from SetMesWinTbl, MakeMesWinTbl, MyTextureMake_sub, CalcSpaceW, GetItemNoFromFontNo.
  Other ranges seen but not named: 0xF6xx, 0xF9xx (adds low byte to x), 0xFAEA..0xFAF9 (value
  codes), 0xFAFA..0xFAFF (NameRegistTbl rows), 0xFB00+0xF3..0xFA (value), 0xFBFF, 0xFDE0..0xFDF7,
  0xFFA0..0xFFFF.
- MesLineShade from GetGyouAlpha / GetFontColor (1 halves rgb, 2 alpha 0xFF*alpha>>7, 3 black
  at alpha*0x40>>7 and no outline, 4 rgb unchanged alpha 0 / skipped).

## Matching notes
- `DrawFukidashiShadow` constructs a local `mgCDrawPrim` in the existing
  `message_draw_prim` union. Its two stack stores at offsets 0x190/0x194 are
  `mgCDrawPrim::offset_x` and `offset_y` relative to the local primitive at
  stack offset 0x80. They hold the draw offset multiplied by 16, and replacing
  a separate scratch array with those typed fields gives a 100% match.

## Globals
- `p` (.data, 0x80): float[16][2] bubble outline ratios (DrawFukidashi_sub, DrawFukidashiShadow).
- `waku_data` (0x90): s32[9][4] frame margins per window mode (left, top, right, bottom);
  indexed `window_mode*0x10`, so modes 9..11 read past its end in retail.
- `MesAbsDrawOff` s32 (gates DrawFont/_set2DSprite). `MovieCCCnt/W/H` s32.
- `NameRegistTbl` 0xB0 = short[8][11] (row stride 0x16; SetAndGetNameRegistTbl clears rows 0..5
  to 0xFF00).
- `MovieCCFont` CFont (0xB8; constructed by `__sinit_nd_meswin_cpp` via inline CFont ctor).
- `MovieCCStart/Clear` s32[20] (frames = seconds * 25), `MovieCCStr` char[20][350].
- File-local (do not extern): `at_3748` (GetPos_AbsPosSet anchor table, 0x98),
  `data_4206` (0xA0, function-local static), `at_4057`, `at_4100`, and the `at_*` literals.
- `D_0037AFEC` is the .ctor entry.

## First game
First game's `ClsMes` (chronicle `clsmes.hpp`) is a different design (texture-based, 0x1858
bytes). Only the name and the idea of a laid-out character table carry over; no layout reused.

## Compiler flag cleanup

The two local `divbyzerocheck on`/`reset` pairs are redundant with the PS2
compiler flag. Removing them leaves every section and symbol in this unit's
object diff unchanged.

## Compiler helper and placement policy

The translation-unit profile uses GPR helper mask `0x10` and FPR mask zero.
`DrawMesWin` is native and exact, with a `0xB80` body. Its six
`CalcAutoPosSet` calls require four context rows:

| Placement | Control values | Screen limit | Ratio | Policy |
| --- | --- | --- | --- | --- |
| Initial DQ X | switch `[9, 10]` | 512 | 0.5 | Evaluate first |
| Initial DQ Y | switch `[9, 10]` | 480 | 0.95 | Default |
| Final bottom/DQ X | condition `[7, 9, 10]` | 512 | 0.5 | Default |
| Final bottom/DQ Y | condition `[7, 9, 10]` | 480 | 0.95 | Evaluate first |
| Final center X | condition `[11]` | 512 | 0.5 | Ordinary evaluation before argument 1 |
| Final center Y | condition `[11]` | 480 | 0.5 | Evaluate first |

The centered rows additionally select screen-limit argument 1 by its exact
binary32 bits: `0x44000000` for 512 and `0x43f00000` for 480. Each row asserts
one consumption per compiler invocation. Control values describe actual
`MesWindowMode` predicates; no helper name or call ordinal selects a site.
The selector mechanism and genuine-compiler tests are documented in
[the compiler integration](../../../../scripts/build/SATANSFIDDLE.md).

Center X shares an optimizer-created half-ratio assignment with center Y.
Early evaluation transfers that ratio too soon. Ordinary evaluation before
screen-limit argument 1 preserves both integer constants until their later
floating transfers, giving retail's distinct third schedule. Broad half/0.95
rows leave twelve words different; the default profile leaves seventeen.
Value-and-callee selectors alone therefore cannot distinguish these placements.

Rejected source controls include direct expansion of all or individual
placement helpers, float extents, double ratios, integer screen limits,
named ratios, integer/float extent snapshots, result snapshots and explicit
runtime fptosi calls. Constant folding preserves the same failing schedules.
Converting both extents at branch entry grows the body to `0xB94`; a final
else-if shortens it to `0xB7C` and changes 113 words. Level 2 grows the body
to `0xD1C` with 796 differing words. These controls do not replace the
accepted context policy. m2c stops at DrawMesWin's indirect switch jump;
existing analyzed source and retail switch data establish its call identities.

## Native data and matching constraints


All data are native. Public definitions retain NameRegistTbl[8][11], two twenty-element
frame arrays and MovieCCStr[20][350]; the 7000-byte caption strings have an eight-byte
alignment tail. The outline p table is float[16][2], and waku_data is s32[9][4]. The
third outline X coordinate is binary32 0x3DCCCCCC (0.099999994f), one ULP below 0.1f.

GetPos_AbsPosSet emits a 19-point 0x98-byte initializer with eight alignment bytes. The
local advance-button table contains ten RECT entries, retaining the repeated
second/fourth frame. Existing RECT initializers and switches in Preset, SetWindowMode,
MakeMesWinTbl(int), DrawPushButton and DrawMesWin supply their own native tables. Inline
Shift-JIS strings use fixed-width octal escapes.

The digit helper Ident is inherited. Removing it keeps DrawDigit at 0x150 but changes
integer scheduling: direct expressions differ by fifteen masked words, and a meaningful
row local differs by thirteen. A plain compound expression also fails.
MyStrCpyLineFeed's natural infinite for loop with an explicit newline break matches its
0x80 bytes; a while rewrite differs by twenty-one words.

## Reset fields and constants

ClsMes::Init uses the established message limits and shade enums. Its
remaining constants are -1 sentinels, booleans, 0x80 alpha and a 30-frame
page time. unk_1f4, unk_271c, unk_276c, unk_27bc and unk_280c are only
reset by the analyzed message/menu/help consumers and remain unidentified.
The shared inline reset has retail size 0x2B8 at 0x1F38E0.
