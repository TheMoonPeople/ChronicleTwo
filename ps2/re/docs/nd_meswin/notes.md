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

## C++ draft status
The current unit draft check reports 97 matches and one difference,
`ClsMes::DrawMesWin`. It retains retail assembly in the game build.
Promotion attempts are recorded in `scripts/re/promotion_attempts.tsv`.

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

## Canonical native-promotion checks

Under the deterministic Satan's Fiddle profile, the baseline has no native
code failures, including `Preset`; its two canonical failures are the
`MovieCCFont` BSS symbol size (`0xB8` versus retail `0xC0`) and the resulting
padding gap before `MovieCCStart`.

The existing drafts for `SetGoalCursorXY`, `DrawDigit`, `DrawEquipment`,
`DrawCross`, and `DrawRightDelta` retain assembly fallbacks. Isolated canonical
checks identify source scheduling differences rather than floating-constant
selectors: the icon drafts first differ at their texture-rectangle argument
loads (`0x0015B324`, `0x0015B4E4`, `0x0015B69C`). Explicit dimensions can recover
the saved width/height registers for Equipment and Cross, but their x/y load
order still differs. `SetGoalCursorXY` differs in initial integer allocation
and line-count loop scheduling; `DrawDigit` differs in saved integer allocation.
These trial native promotions were restored. No profile rows were accepted.

## Compiler helper history

The unused `PrimeDoubleToFloat` definition is removed. The translation-unit profile uses GPR helper mask `0x10` and FPR mask `0`; private baseline and candidate checks preserve all allocated bytes and resolved relocation identities. The existing `DrawMesWin` finding is unchanged. Its two `0.5f` calls require opposite retail schedules and share the current stable selector identity.

## DrawMesWin call-site scheduling residual

The `f0a4ce9` baseline has one native byte-comparison failure in DrawMesWin;
its function objdiff score is 99.365486%. This supersedes the earlier baseline
statement above that this unit has no native code failures. Running the current
m2c wrapper for DrawMesWin stops at its indirect switch jump (`jr`, input line
112), so the documented function and emitted switch body remain necessary for
this scheduling analysis.

A private profile selecting both binary32 0.5f and 0.95f with
`evaluate_first: true`, scoped to CalcAutoPosSet, still fails the whole-unit
check and lowers the function score to 99.09239%. The unit's other code is
unchanged. The calls sharing a ratio and callee need different schedules:

- The DQ horizontal call through CentrePos, bottom vertical call through
  BottomPos, and centre calls through CentrePosX/CentrePos need early ratio
  preparation. CentrePosX also has a different integer temporary allocation.
- The direct DQ vertical and bottom horizontal CalcAutoPosSet expressions
  already match the default order; the broad selectors change their order.

The matching direct expressions and differing inlined-helper expressions share
one post-inline selector identity. A stable inline-origin or expression-shape
selector may distinguish them, but no such behavior has been validated. No
source or profile change from this unsuccessful trial is accepted.

## DrawMesWin deterministic scheduling regression

The current game source supplies `DrawMesWin` natively. Its body has the correct
`0xB80` size, but the deterministic default-false profile leaves 17 instruction
words different. All six placement calls target `CalcAutoPosSet__Fffff`: four
use the binary32 half ratio and two use the binary32 `0.95` ratio. Retail has
three half-materialization forms: half reaches `$f15` before the screen limit
at `+0x6FC` and `+0xA38`; the screen and half GPR constants are loaded in that
order at `+0x99C`; the order reverses at `+0xA08`. The two `0.95` calls also need
opposite scheduling. Thus a value-and-callee selector cannot select each
required call separately.

The following natural source changes leave the complete fixed-up object
byte-identical to this baseline: replacing the existing local inline placement
helpers with direct calls; using float extent parameters for those helpers;
unsuffixed double ratio literals; integer screen-limit literals; function-local
or branch-local named ratios; converting each text extent to a float local
immediately before its call; and storing each placement result in a float
local before narrowing it into the corresponding text coordinate. Constant
folding removes the proposed type and statement-boundary distinctions.
Converting both dimensions at branch entry instead preserves the height across
the first call and grows the body to `0xB94`; it does not match retail.

Scoped evaluate-first trials for zero and screen height reproduce the baseline.
Screen width first increases the differing-word count to 20. Half and `0.95`
first together leave 12 differing words: `+0x72C..+0x73C`,
`+0x99C/+0x9A0/+0x9A8/+0x9AC`, and `+0xA08/+0xA0C/+0xA14`.
Half and screen width first together leave 16. Screen width and `0.95` first
leave 20, while all three first leave 16; these complete all eight combinations
of the three selectors that change the failing instructions. No source or
profile candidate passes the complete unit, so none is retained. Reconsider this
function when
retail-supported source evidence identifies a meaningful expression difference
between these placement calls, or a separately verified stable expression
policy can represent that difference without occurrence selectors.

## Placement boundaries and proposed semantic identity

All six `DrawMesWin` placement calls have four float arguments: zero minimum,
screen limit 512 or 480, the integer member `text_w` or `text_h` converted to
float, and ratio `0.5` or `0.95`. No argument contains another call or an
existing header accessor. The retail code reads each extent immediately before
its placement call. Fresh integer extent locals, first at center X and then
at all six sites, distinguish member reads from the earlier float-conversion
trials without preserving a height across the preceding width call. Under
half-and-0.95-first they both reproduce the prior row-only object exactly:
SHA-256 `9cf3f22a774e7cbc3ed78b51af6d06c9bdfbab39e8c8dee7b47048aaf509d76c`,
12 differing words, `0xBF28` checked bytes, and 1364 relocations. Neither is
retained.

The source-local `BottomPos`, `CentrePos`, and `CentrePosX` helpers first appear
in `810c9f05673c55b1fbda34367d3f01e26f549aee`, replacing direct placement
expressions during draft promotion. There are no corresponding retail symbols
or assembly references. Thus an identity keyed to those inline helper names
would encode a distinction introduced by the decompilation, without evidence
that retail used it.

The complete eight-combination matrix in the existing receipts establishes
these individual site requirements:

- DQ bubble switch cases: X is `(0, 512, text_w, 0.5)` and needs half first;
  Y is `(0, 480, text_h, 0.95)` and needs the default ratio policy.
- The final bottom/DQ placement condition: X has the same arguments as DQ X
  and needs both half and width at default; Y has the same arguments as DQ Y
  and needs 0.95 first.
- The final center condition: Y is `(0, 480, text_h, 0.5)` and needs half
  first. X is `(0, 512, text_w, 0.5)` and has no exact schedule under the
  recorded existing selectors.

For the five representable schedules, the minimal proposed identity adds the
real enclosing window-mode predicate and the extent member's semantic origin
(`ClsMes::text_w` versus `ClsMes::text_h`) to the existing
TU/function/type/bits/callee key. The predicate distinguishes initial DQ layout
from the final bottom placement despite identical arguments; the member origin
distinguishes the two centered axes. These predicates and members describe
game behavior rather than call occurrence numbers. Their provenance would need
to survive optimization, inline expansion, cloned constants, and both mwccgap
passes. The current hook has no validated interface for that provenance; this
is documentation of required research, not a supported row.

Center X requires a separate lowering investigation. Retail `+0xA08/+0xA0C`
loads half into `v1` and 512 into `v0`, then `+0xA14/+0xA18` transfers them
to `f15` and `f13`. Default lowering loads the two constants in the opposite
order. Half-first completes half materialization before beginning 512 instead
of retaining both GPR values. Across all eight active selector combinations,
center X still has three or four differing words. Extending selector identity
alone cannot establish its match: the additional requirement is a verified
source-expression/dependency or ordinary argument-walk behavior that emits
that third schedule. No instruction-order patch or new Boolean row is claimed
to provide it.

The retained normal object remains byte-identical to round 2, with one finding
at `0x0015C5AD` and 17 differing words in `DrawMesWin`. Reopen with a natural
expression boundary that survives lowering, or with the separately verified
semantic provenance and center-X lowering behavior above. No shared header,
source, profile, wrapper, ordinal, source-line selector, or address selector
changes are retained. New receipts:
`.private/receipts/regress/round3/nd_meswin-*/`,
`analysis/message-call-policy-matrix.json`, and `after-mg/`.

## Historical source and individual placement expansions

The old-toolchain matching source at `250ac10` already has exactly the current
`DrawMesWin` body and the three inline placement helpers. The complete
`nd_meswin.cpp` / `nd_meswin.hpp` diff from that commit to the round-3 head
`accc605` contains only removal of the discarded `PrimeDoubleToFloat` definition.
`d08b13d` does not change `DrawMesWin` relative to its parent; `5b4deb3` takes
the current native body from its second parent. There is no different matching
placement expression to restore from the SF adoption. The older direct-call
body predates `810c9f0`, and its all-sites/default-policy expansion is already
recorded above.

Twelve additional source/lowering hypotheses test the remaining boundaries
without rerunning those default-policy trials:

- Expanding just DQ X, bottom Y, center X, or center Y directly in `DrawMesWin`,
  retaining each helper's exact literal types and the real extent member, is
  tested separately under the supported half-and-0.95-first rows. All four
  complete objects equal the prior row-only object
  `9cf3f22a774e7cbc3ed78b51af6d06c9bdfbab39e8c8dee7b47048aaf509d76c`.
- Expanding all helpers and removing their definitions, using unsuffixed double
  ratios, and using integer screen limits are each tested under those same
  rows. All three also produce that exact object. Their previously measured
  default-policy versions are not recompiled.
- Explicitly calling the existing runtime `fptosi` around center-X
  `CalcAutoPosSet` tests a real nested source call rather than the conversion
  introduced by an integer cast. Under the default profile its complete object
  equals the retained baseline. Under half-and-0.95-first, both center-X alone
  and all six explicit conversion calls equal the prior row-only object.
  The actual runtime conversion boundary therefore does not provide the
  missing center-X materialization order.
- An `else if` between the final bottom/DQ and center placements is semantically
  valid because `CalcAutoPosSet` is pure arithmetic. It shortens the body to
  `0xB7C`, changes 113 masked words, and produces 15 complete-unit findings.
- Local optimization level 2 changes the body to `0xD1C` with 796 masked-word
  differences and 445 canonical findings, including the resulting local-data
  binding cascade. No profile sweep or postprocessor change is made on that
  structurally different body.

The nine half-and-0.95-first source variants above all retain `0xB80` bodies,
12 differing words, `0xBF28` checked bytes, and 1364 relocations. The explicit
center conversion under default has the baseline 17 words. None passes the
complete unit, so no source, header, or profile change is retained. The final
normal object remains
`bca019021f704eb88aafb01c024c57871062bc8a6171e840637f6891fa3716c1`,
with the same single finding at `0x0015C5AD` as round 3 and integration i14.

Receipts: `.private/receipts/regress/round4/nd_meswin-*/`,
`analysis/function-history.json`, `analysis/nd_meswin-function-history.diff`,
`analysis/experiment-summary.json`, and `final/`. The semantic-provenance and
center-X lowering requirements above remain unresolved; these measurements
do not establish that all natural source forms are impossible.

## Nested-selector scope after the upstream merge

The supported `nested_call` and `nested_variable` identities require an
outer call argument containing a real sibling call. `DrawMesWin`'s six
`CalcAutoPosSet` calls instead receive scalar zero, screen limit, converted
extent, and ratio arguments. The local placement helpers inline those same
arguments; they do not introduce a sibling call inside `CalcAutoPosSet`.
The new selectors therefore do not distinguish the required window-mode
predicates or width/height origins. The predicate-provenance and center-X
third-schedule requirements above remain unresolved. No unsupported or
unconsumed profile row is added, and the recorded broad-ratio experiments
are not repeated.

A fresh `decompile.sh DrawMesWin__6ClsMesFv` still stops at the indirect
switch jump, input line 112. Existing source, documented call identities,
and retail assembly remain the evidence for the placement sites. Under the
new image, the clean merged object retains `0xBF28` checked bytes and 1,364
relocations with the same sole finding at `0x0015C5AD`. The `0xB80` body has
17 differing masked words; the previously measured broad-ratio candidate's
12-word result still lacks a complete-unit match. Whole-project verification
retains the baseline `0x26` text-byte difference and identical object failures.

## Predicate and ordinary-walk calibration, October 8 prototype

`satansfiddle-control-context.patch` preserves source control identity through
the verified lowered statement list. Four binary32 rows for
`DrawMesWin__6ClsMesFv` / `CalcAutoPosSet__Fffff` implement these six schedules:

| Source placement | Control values | Screen limit | Ratio | Policy |
| --- | --- | --- | --- | --- |
| Initial DQ X | switch `[9, 10]` | 512 | half | evaluate first |
| Initial DQ Y | switch `[9, 10]` | 480 | 0.95 | default |
| Final bottom/DQ X | condition `[7, 9, 10]` | 512 | half | default |
| Final bottom/DQ Y | condition `[7, 9, 10]` | 480 | 0.95 | evaluate first |
| Final center X | condition `[11]` | 512 | half | ordinary evaluation before argument 1 |
| Final center Y | condition `[11]` | 480 | half | evaluate first |

The two centered half rows additionally select screen-limit argument 1 by its
exact bits: `0x44000000` (512) versus `0x43f00000` (480). The control sets are
the real `MesWindowMode` values, and the argument positions are source parameter
positions. Neither source-helper names nor call occurrence numbers are used.

Center X's half ratio is an optimizer temporary assignment shared with center Y.
Prioritizing that argument in the early walk completes its floating transfer
too soon. A probe that changes order only after ordinary expression evaluation
has finished leaves all 17 baseline word differences. Moving the argument
before screen limit argument 1 at the verified ordinary register-argument walk
(`0x004a4bb9`) and restoring formal order at `0x004a4bdc` removes all four
center-X differences, leaving the 13 unrelated baseline words in that private
probe. The compiler retains both GPR values until their later floating transfers,
producing retail's third schedule naturally.

The accepted center-X row uses `evaluate_first: false` and `evaluate_before: 1`.
Combined with the other three rows, the focused complete object has zero byte
and resolved-relocation differences: `0xBF28` checked bytes, 1,364 relocations,
and a `0xB80` `DrawMesWin` body with zero differing masked words. Each of the
four rows is consumed once in each mwccgap pass. All source and headers,
including the existing inline placement helpers, are unchanged.

The selector semantics are documented in `scripts/build/SATANSFIDDLE.md`.
Image: `chronicletwo_dev:sf-d8bf13c-proto`. Receipts:
`.private/receipts/prototype/focused.log` and `message-word-diff.json`;
`.private/sfproto/nd_meswin-reorder2-diff.json` records the isolated ordinary-walk
probe rather than an accepted profile.

## Placement selector validation, October 8 round 1

Each of the four placement rows now requires `expected_matches: 1` per
compiler invocation. Both `evaluate_before` and that assertion precede the
final `evaluate_first` key; existing rows retain their order. The count never
selects a call. The control value set omits the compared subject and the selected
ratio's formal slot, so repeated projected identities receive the same policy
and excess selected call arguments fail the assertion.

Every switch case descriptor keeps its label, including unsupported bounds.
Context reconstruction rejects oversized or nonrepresentable case ranges,
missing targets and nonterminal defaults instead of extending another case's
region. The descriptor's default target is a boundary, not a verified join.
`DrawMesWin`'s no-op case 11 shares that terminal boundary and receives no
switch context; the DQ case-9/10 region still ends before it. The later center
condition supplies the separate `[11]` context used by the centered rows.

Center X's selected argument and screen-limit target both pass the verified
ordinary-walk checks: category 1/2, zero evaluated marker and false early flag.
Targets already evaluated first are rejected. Genuine compiler regressions
verify all six schedules and preserve the two unselected call preparations;
a volatile nested assignment exercises two simultaneous saved orders and
readback of both restored lists and heads. A separate fault-enabled test binary
rejects an inner restoration write failure without publishing a new object.
The production wrapper excludes that fault capability.

With `chronicletwo_dev:sf-d8bf13c-proto2`, all four rows log
`expected=1 actual=1` independently in each mwccgap pass. The `0xB80`
`DrawMesWin` body has zero differing masked words, and the focused complete
object passes `0xBF28` bytes and 1,364 resolved relocations. Source and headers
remain unchanged. Receipts: `.private/receipts/proto2/focused.log` and
`message-word-diff.json`; the deliberately coarse
projection is documented in `scripts/build/SATANSFIDDLE.md`.
