# nd_meswin: reverse-engineering notes

## C++ draft status
All 98 functions have C++ in `ps2/src/nd_meswin.cpp`. 41 are exact and compiled
by the matching build. 1 more compiles to retail's bytes in isolation but stays
under `NONMATCHING`. 56 differ from retail and keep the `INCLUDE_ASM` fallback.
Each function tried has its one promotion attempt recorded in
`scripts/re/promotion_attempts.tsv`.

The migrated message setters write the window mode, background opacity, packed colours,
message buffers and line widths through `ClsMes` members. `GetNextLineTop` scans until the
next line-feed byte and leaves the pointer just after it; its loop branch layout is sensitive
to how the C++ loop is written. `CheckPosInOutForArea` tests each of the three coordinates
against the unordered pair of corresponding bounds.

Unit of the message window class `ClsMes` (68 members: 67 here, `Init` emitted in dngmenu), its
drawing/placement helpers, a few vector helpers, and the movie caption player (`MovieCC*`).

## Header dependencies
- `ClsMes : public CFont`. `CFont` is owned by unit `font`; `ps2/include/font.hpp` did not exist
  when this header was written, so `nd_meswin.hpp` does not compile until it does. Verified with
  a stub `class CFont { u8 unk_0[0xB8]; void Init(); };` substituted for the include: the header
  compiles and every ClsMes offset below was checked with STATIC_ASSERTs.
- `sizeof(CFont) == 0xB8`: `MovieCCFont` and `dbFont` symbols are 0xB8; `CFont::Init` writes
  0x00..0xB7 (memset 0x80 text, 0x80 fuchi, 0x88 rgba bytes, 0x90..0xB4 ints).
  `ClsMes()` also zeroes CFont's 0xB0/0xB4 after `Init` (same pattern as `CMenuFont()` in
  menucls1); CFont's own constructor is inline and calls `Init()` (Init is called twice in a row
  at the start of `ClsMes()`).
- `RECT` and `RGBAQ_TYPE` had no declaration anywhere in `ps2/include`, no owning class, and
  ClsMes holds both by value, so they are defined here. If another unit (drawwin, font) also
  defines them, one definition must be removed and the other header included.
  - `RGBAQ_TYPE`: 8 bytes {u8 r,g,b,a; float q}; copied with `ld`/`sd` (RgbqToUint,
    GetFontColor) so given `aligned(8)`. Returned by value from `RgbqToUint` and
    `ClsMes::GetFontColor` (hidden return pointer in a0, `this` in a1 — m2c shows it as an extra
    first arg).
  - `RECT`: {x, y, width, height}, same as the first game's `rect.hpp`.
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
  `MenuMesInit` inline too; declared without a body: the drafting agent should define it in the
  class body (Init block above). Its body = Preset up to the switch.
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
