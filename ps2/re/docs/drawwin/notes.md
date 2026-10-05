# drawwin notes

Free functions that draw ClsMes's (nd_meswin) menu-style frames. No classes are owned by the
unit (none in `class_units.tsv`). No function symbol is local in retail, so all 11 are
prototyped in `ps2/include/drawwin.hpp`. `RECT` and `RGBAQ_TYPE` come from `font.hpp`;
`mgCDrawPrim` is forward-declared. Helpers called: `MySetPrim`, `set2DSprite(prim, xy, uv, color)`,
`FillRect` (nd_meswin) and `mgRect<int>::Set` (mg_tanime). Every sprite is
`Set(uv, tex x, tex y, w, h)`, `Set(xy, screen x, y, w, h)`, `set2DSprite(prim, xy, uv, color)`.
No first-game counterpart: chronicle's `MyMenuHelpWinDraw(int x, y, w, h, shade, u, v, CTexture*)`
in `clsmes.cpp` has a different signature and implementation.

## Callers and parameter meanings
All but the 4-argument wrappers are called from `ClsMes::DrawMesWin` (switch on `window_mode`,
ClsMes+0x138, a `MesWindowMode`). Each frame is drawn twice: first the shadow rect (outer rect
+5,+5) with the shadow colour (black, a = alpha*0x40>>7), then the window rect with white
(0x80,0x80,0x80,alpha).
- `alpha` = ClsMes `alpha` (u8 at +0x1E58); `opaque` = ClsMes `bg_opaque` (+0x13C).
  Fill alpha: `opaque ? 0x80 : alpha*0x36/128` (signed division by 128), passed to
  `FillRect(..., 0,0,0, a)`.
- 4-arg `DrawVersatileWin_1/_4` copy the RECT and call the 5-arg version with opaque = 0
  (`daddu $8,$0,$0`). Callers: `DrawDownLoadAnaunce` (editmenu), `CNameRegiMenu::DrawMessage`
  (nameregi), `EventTimeDraw` (event_func).
- `CalcSelectCursorPos(win, pos)`: pos[0] = x + 0x17 + (w-0x2E)*5/20 - 0x1E, pos[1] = y + h - 0x29,
  pos[2] = x + 0x17 + (w-0x2E)*15/20 - 0x1E, pos[3] = pos[1]. Two (x,y) cursor points (yes, no).
  Called by `ClsMes::SetSelectCursorPos`.
- `OffsetYesNoWin(win, shadow)`: if win->width < 0xA6, sets both widths to 0xA6. In DrawMesWin
  arg 1 is the outer rect, arg 2 the +5 shadow rect.
- `MyMenuFloatingWinDraw(prim, win, point_x, point_y, frame_color, fill_color)`: point = window
  x/y + ClsMes `point_x/point_y` (+0x1BC/+0x1C0). First 9 sprites (tex x 0xA0..0xCF) use arg 6
  (`win_color` +0x1C8 for the window pass), then the frame sprites (tex x 0x70..0x9F) use arg 5
  (white). Then
  `MySetPrim(prim,4,0)` and a 0x15x0x15 pointer on the side the point lies outside of
  (left / right / top / bottom checked in that order), drawn with arg 6 then arg 5.
- `MyMenuHelpWinDraw(prim, win, alpha)`: builds its own colour (0x80,0x80,0x80,alpha). 3x3
  sprites from tex (0xC0..0xFF, 0xA6..0xE5); does not call MySetPrim.
- `DrawVersatileWin_3(..., select_y, ...)`: band (rows 6-8, height 0xE) at select_y-7; side
  rows 3/5 above it, rows 9-11 below it to bottom-0x19, bottom rows 12-14. DrawMesWin computes
  select_y from the selected line (`window_mode` 6 = "band behind the selected line").
- `DrawDQFukidashi(prim, win, tail_x, tail_y, color, tail_on, mode)`: arg 4 ($a3) and arg 7 ($t2)
  are never read. Caller passes tail_x = x + point_x, tail_y = y + point_y (point_y set to -10),
  tail_on = ClsMes+0x15C (`tail_on`), mode = ClsMes+0x138 (`window_mode`). With tail_on the top
  edge is split around a 0x10x0x20 tail sprite (tex 0x30,0xD0) at tail_x-8, y-0x10; tail_x is
  clamped to [x+0x18, x+w-0x18]. Tiles are 16x16 from tex (0..0x2F, 0xD0..0xFF).

## Global `data` (0x35B570, size 0x150, .data)
Not in `local_symbols.tsv`, so global. 21 rows of 4 s32: texture x, y, width, height, read only
as `Set(uv, row[0..3])`. Declared `s32 data[VWIN_PART_MAX][4]` (same shape as nd_meswin's
`waku_data`); a `RECT[21]` would be equally consistent with the code. The symbol carries
`allow_duplicated` in main.symbols.txt.

| Row | Tex x,y,w,h | Used by |
|---|---|---|
| 0-2 top | D0/E7/E9, 19, 17/2/17, 19 | yesno, _1, _3 |
| 3-5 side | y 32, h 2 | 3 and 5 by all four; 4 never (inside is FillRect) |
| 6-8 band | y 34, h E | yesno, _3 |
| 9-11 lower side | y 42, h 2 | yesno, _3 (10 = centre, drawn) |
| 12-14 bottom (banded) | y 44, h 19 | yesno, _3 |
| 15-17 bottom (plain) | y 5D, h 19 | _1, _4 |
| 18-20 top (style 4) | y 0, h 19 | _4 |

Offsets read per function (from `build/re/symbols/drawwin.json`): yesno/_3 0x00-0x3C, 0x50-0xEC;
_1 0x00-0x3C, 0x50-0x5C, 0xF0-0x11C; _4 0x120-0x14C, 0x30-0x3C, 0x50-0x5C, 0xF0-0x11C.
The `VersatileWinPart` enum names the rows (names are descriptive, not retail).

## Geometry constants
Corner tiles 0x17x0x19; centre width w-0x2E; FillRect at (x+0xD, y+0x10, w-0x18, ...) with
height h-0x43 (yesno), h-0x1A (_1), select-dependent (_3), and y+0xC / h-0x16 (_4).
yesno: band at bottom-0x37, lower side at bottom-0x29 (h 0x10), bottom at bottom-0x19.

## Draft and promotion status
All 11 game functions have named, typed C++ drafts. `OffsetYesNoWin` and the four-argument
`DrawVersatileWin_1` and `DrawVersatileWin_4` wrappers passed isolated whole-image promotion
checks and are compiled by default. The other eight drafts remain guarded by `NONMATCHING`
with their original `INCLUDE_ASM` fallbacks. Each function received exactly one isolated
promotion attempt, recorded in `scripts/re/promotion_attempts.tsv`. The default build is
byte-identical to SCES_511.90.

The frame drafts call `set2DSprite` through the existing `mgRect<int>` declaration. MWCC
mangles that template type as `9mgRect<i>`, while the retail function is named with
`9mgRect_i_`. Their promotion attempts therefore failed to link before image comparison.
That declaration mismatch needs a separate type correction before any frame draft can be
promoted. The eight guarded drafts do compile together under `NONMATCHING`; instruction
comparison reports differences for all eight.

The draft object also emits the weak `mgRect<int>::Set` specialization. The ELF parser
previously counted its extra `.text` section without counting its function symbol, causing
`IndexError` in `Elf.__init__`. Recognizing weak function symbol info `0x22` lets the draft
checker associate that section with its symbol.
