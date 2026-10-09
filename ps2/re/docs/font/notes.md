# font: reverse-engineering notes

The short CFont setters write the named size, clearance, position, RGBA and outline fields.
`Init` clears only the 0x80-byte string, then assigns the default outline, opaque grey colour,
alpha, position, spacing and glyph dimensions individually. `Preset` selects one of three
colour/outline combinations; preset pairs 0/1 and 2/3 share settings.

Unit range `0x2D8AA0`-`0x2DAE90`, 45 functions. Owns `CFont` (only class in `class_units.tsv`
for this unit). No first-game equivalent (`/home/adubbz/development/chronicle` has `RECT` in
`rect.hpp` with the same layout, but no `CFont` or `RGBAQ_TYPE`).

## CFont (size 0xB8, no vtable)
Size: retail symbols `Font` (0x3FAF50, mainloop) and `MovieCCFont` (0x3F0510, nd_meswin) are both
`size:0xb8`. `ClsMes` (nd_meswin) derives from `CFont`; its ctor runs `CFont::Init` twice (inline
`CFont()` ctor then an explicit `Init()`), and its own fields start at 0xB8.

| Off | Field | Evidence |
|---|---|---|
| 0x00 | `char str[0x80]` | `SetStr`/`Init`: `memset(this,0,0x80)`, `strlen >= 0x80` -> printf `at_936`, else `strcpy(this, s)` |
| 0x80 | `s32 fuchi` | `SetFuchi`; `DrawChar` passes it to `set2DSprite_Fuchi`; `Init` sets 3 |
| 0x84 | `unk_84` | never accessed in font or nd_meswin |
| 0x88 | `RGBAQ_TYPE color` | `SetColor(iiii)` byte stores 0x88-0x8B; `DrawChar(prim,char*,..)` passes the 8-byte value with `ld 0x88` |
| 0x90 | `s32 alpha` | `Init` = 0x80; `DrawChar(char*)` passes its low byte as the `unsigned char alpha` arg; `DrawChar` scales `color.a` by `alpha >> 7` |
| 0x94/0x98 | `pos_x/pos_y` | `SetPos`; `DrawDirect` calls `SetPos(x,y)` |
| 0x9C/0xA0 | `clearance_w/h` | `SetClearance`; `Init` 15/24; `DrawGaiji` passes 0xA0 as line height |
| 0xA4/0xA8 | `draw_w/h` | `SetDrawSize`; `Init` 16/20; `DrawChar` uses them as the screen rect size, halving w for half-width |
| 0xAC | `s32 mini` | `DrawChar`: non-zero -> `GetRectFontTexMini` + `MySetTexMini` |
| 0xB0/0xB4 | `float offset_x/offset_y` | `Init` zeroes; `DrawDirect` does `fptosi` on both and shifts << 4 (used as a 12.4 offset); meaning not established |

Verified by a trial compile (reverted): `Init`, `DrawChar(mgCDrawPrim*,char*,int,int)`,
`SetColor(RGBAQ_TYPE)` and `GetRectFontTexMini` MATCH with this layout.

Inline ctor `CFont() { Init(); }` is declared because `__sinit_mainloop_cpp` and `ClsMes::ClsMes`
call `Init` directly where a ctor would be.

## RGBAQ_TYPE (0x8, aligned 8) / RECT (0x10)
Declared here (nd_meswin includes font.hpp for them; gameutil forward-declares RECT).
`RGBAQ_TYPE` = r,g,b,a bytes + float q. It is passed by value in a single GPR (`sd $5` in
`SetColor(RGBAQ_TYPE)`, `ld $5` in `SetColor(unsigned)`), which needs the `aligned(8)` attribute;
`SetColor(RGBAQ_TYPE)` matches with it. `RECT` is returned by hidden pointer from
`GetRectFontTex`/`GetRectFontTexMini` and passed by value (pointer to copy) to `set2DSprite_Fuchi`.
`SetColor(unsigned)` = `SetColor(RgbqToUint(c))` (RgbqToUint in nd_meswin) but the trivial form
DIFFs: retail copies the returned value through a second stack temp (0x28 -> 0x20) before `ld`.

## Functions
- All 45 are global (none in `local_symbols.tsv`). `FontTblBinBuff` (0x1F455C0, 0x1000) IS local:
  `static FONT_TBL_BIN FontTblBinBuff` belongs in font.cpp, not the header.
  Declaring the current assembly-backed symbol as `FONT_TBL_BIN` makes MWCC
  emit field-offset relocations in `GetYoyakuTblTop`, `GetYoyakuTblNum`,
  `GetKanjiTopNo`, and `GetHalfFontNum` (scores 75%, 72.5%, 72.5%, 72.5%).
  Retail instead forms the symbol base first, then adds or loads the field
  offset. The assembly-backed `char[]` declaration and local typed view retain
  exact code until a typed declaration can reproduce those relocations.
- `GetRectFontTex(font_no, &tex_no)`: if font_no is a font gaiji code (0xFDE0..0xFDF7) and
  LanguageCode is French/German/Italian/Spanish (2..5), converts via
  `GetFontNoFromFontGaijiCode`. Negative or >= 0x980 -> returns `at_784__2` (static zero RECT in
  .bss). Pages: <0x260 page 0 (n unchanged); <0x4C0 page 1, n -= 0x98; <0x720 page 2,
  n -= 0x130; <0x980 page 3, n -= 0x1C8 (the adjusted n keeps growing; the texture pages are
  addressed by row, which `MySetTex` only accepts for pages 0/1). u = (n & 31) * 16, v = (n >> 5) * 20, w 16, h 20.
- `GetRectFontTexMini` returns the static `at_817__4` RECT unchanged (stub; tex_no unused).
- `MySetTex(int)`: tex 0/1 only -> `GetFontTexture(tex)` (another unit). `MySetTexMini`:
  0 -> "FontTex_s_0", else "FontTex_s_1" via `mgTexManager.GetTexture(name,-1)`.
- `DrawGaiji` sets texture "gaiji" (`at_1543`) and draws with colour 0x80808080, line h = clearance_h.
- `LoadFontTblBin`: LanguageCode == LANG_ENGLISH -> "meswin/fonttbl_1.bin", else
  "meswin/fonttbl_2.bin"; returns 0 and prints "FontTblBinBuff OVER" if size > 0x1000.
- `GetFontNo`: '\n' -> -2; font gaiji tag -> its code; otherwise binary search of the big-endian
  Shift-JIS pair in `yoyaku_tbl` (count `yoyaku_num`) -> index or -1.
- `GetHalfFontNo(c)`: accented char -> font no; else `GetFontNo` of {c, 0x20}.
- `CheckKanjiFont`: false for LANG_CHINESE (6); else kanji_top_no != 0 && kanji_top_no <= n < yoyaku_num.
- `CheckHalfFont`: 0xFF02 -> true; non-English: 0x5E..0x9C true, 0x9D..0xB4 false; else 0 <= n < half_font_num.
- `GetFontNoFromFontGaijiCode`: not in English; searches the 24-entry u16 table `at_1137__2`
  (copied to stack) for the code, returns 0x9D + index.
- `GetFontGaijiHankaku`: true for 0xFDF3..0xFDF7.
- `GetGaijiW/H`: `GaijiDataTbl[code - 0xFD00].w/h` (offsets 6/8) for 0xFD00 <= code < 0xFD32.
- `My_strncpy`: copies n characters, a '[' tag copied whole up to ']'; returns dst.

## Enums / constants (header anonymous enum, FontFuchi, FontPreset)
- `FontFuchi` 0..8 from `set2DSprite_Fuchi` switch; `Init` default 3 (outline).
- `FontPreset` from `Preset`: 0/1 -> 0x80202020 + fuchi 2; 2/3 -> 0x80686A6B + fuchi 8; 4 -> 0x80686A6B + fuchi 5.
- `FONT_NO_HALF_SPACE` (0xFF02) is a neutral-ish name: only `CheckHalfFont` shows it is always half-width.
- Language checks use `LanguageCode`/`LanguageCodeNo` from mainloop.hpp (not included here).

## Data
| Symbol | Addr | Size | Type |
|---|---|---|---|
| GaijiDataTbl | 0x35AC80 | 0x2CA | `GAIJI_DATA[51]` (0xE stride; w at +6, h at +8) |
| FconvCodeTbl | 0x35AF50 | 0x228 | `FCONV_CODE[46]` (0xC stride) |
| FontGaijiConvTbl | 0x35B180 | 0x120 | `FCONV_CODE[24]` |
| alphabetical_chara_tbl | 0x35B2A0 | 0x13B | `char[63][5]` |
| FontTblBinBuff (static) | 0x1F455C0 | 0x1000 | `FONT_TBL_BIN` |
| at_784__2 / at_817__4 / at_1466__6 | .bss | 0x10 each | function-local static RECTs (compiler-named) |
| at_1137__2 | 0x35B4A0 | 0x30 | u16[24] font gaiji codes (local aggregate initialiser) |

## Unresolved
- `unk_84` meaning; the float fields at `0xB0` and `0xB4` are the drawing offsets `offset_x` and `offset_y`.
- `FONT_TBL_BIN::unk_6` never read.

## Typed access matching

`GetGaijiW` and `GetGaijiH` can index `GaijiDataTbl` directly. Keeping the
two code-point subtractions in separate statements preserves retail's two
`addiu` instructions; collapsing them into one indexed expression makes MWCC
fold the base address instead. Both functions match fully without byte-offset
pointer arithmetic. `CFont::DrawDirect` reads its known float fields
`offset_x` and `offset_y` directly, also matching fully without raw field casts.
The unused C-linkage constructor declaration was removed, and the genuine
runtime `fptosi` declaration now comes from `mw_runtime.h`.
The text walkers in `CalcDrawWH` and `DrawDirect` also use `char *` with
`&text[pos]` and `&cursor[2]`, removing signed-byte casts and pointer
arithmetic while preserving both complete function matches.

## Native reserved-font lookup

`GetFontNo` now compiles natively with zero canonical byte and relocation
differences across the entire font object (`0x2F84` bytes, 367 relocations).
The binary-search endpoint and midpoint decode their high and low bytes into
named byte locals before forming the big-endian code. This preserves the
retail high-byte load before the low-byte load; a single combined expression
reverses those loads and changes the pointer register. The newline, gaiji,
endpoint shortcuts and adjacent-bound termination retain the documented
behavior. No compiler-profile override is required.
