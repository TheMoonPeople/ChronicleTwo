# dbg_font: reverse-engineering notes

Header: `ps2/include/dbg_font.hpp`. One class (`dbgCJISFont`), one global (`JisFont`), three
file-local functions, two enums (`DbgFontSerno`, `DbgFontSheet`).

## Draft status
All seven remaining assembly functions, including the static initializer, now
have named, typed C++ drafts guarded by `NONMATCHING`. The three existing
promoted functions remain unchanged. The half-width glyph lookup was decoded
from all 64 entries of the retail `at_288__3` jump table. The normal build
continues to use the assembly for every draft that does not match.
The draft comparison compiles all ten functions: the existing three functions
and the constructor match individually; the other six differ. Each new draft
received one isolated promotion attempt, but none promoted. The checker had no
complete `build/pal` image to link for five attempts; the two dependent
functions failed compilation because their guarded file-local helpers lacked
forward declarations at the time of the check. Those declarations have since
been added; no second promotion attempt was made.

`PrintDirect` currently copies the format string without expanding variadic
arguments. The local MWCC headers provide neither `<cstdarg>` nor `<stdarg.h>`;
the runtime's variadic argument-list type and forwarding convention still need
typework before this draft can reproduce formatted output. The glyph drawing
draft also differs in packet details from retail and remains guarded.

## dbgCJISFont (size 0x8B0)
Size from the `JisFont` .bss symbol (0x8B0) constructed by `__sinit_dbg_font_cpp`. No vtable,
no base class. Users: `dng_main` `DebugMainDraw`, `eventedit` `evLoadDebugFont`/`DrawEventEdit`
(they also write `JisFont.color[]` (0x3F3F28..34) and `shadow_enable` (0x3F3F4C) directly).

| Off | Field | Evidence |
|---|---|---|
| 0x00 | `int texture_id[3]` | `Initialize` sets -1; `InitTexture` args 1/3/5; `__putc` passes to `mgCTextureManager::ReloadTexture` |
| 0x0C | `int loaded_texture_id` | `Initialize` -1; `__putc` compares with texture_id[n], reloads if different, then stores it; `PrintDirect` resets to -1 at the end |
| 0x10/0x30/0x50 | `char texture_name[3][0x20]` | `InitTexture` strcpy args 2/4/6; `Initialize` zeroes byte 0 of each; `__putc` passes to `GetTexture(name, -1)` |
| 0x70/0x74 | `int x, y` | cursor; `PrintDirect` sets from args; `\n` adds 0x7C to y and zeroes x |
| 0x78/0x7C | `int char_width, char_height` | default 0x10; tab adds 2*0x78 to x; quad extents |
| 0x80 | `unsigned long prev_serno` | 64-bit `ld`/`sd`; `PrintDirect` zeroes it, stores each half-width kana serno |
| 0x88 | `char buffer[0x800]` | only `Clear` (and `Initialize`) touch it: `sb $0, 0x88`. Size fills the gap to 0x888. Name is a neutral guess from `Clear`; no reader exists in this game |
| 0x888 | `int color[4]` | RGBA, default 0x80; `Color()` of the main glyph |
| 0x898 | `int back_enable` | toggled with `~` by "ESC[$"; gates the untextured box |
| 0x89C | `int back_color[4]` | RGBA of box; default 0,0,0,0x40 |
| 0x8AC | `int shadow_enable` | toggled by "ESC[#"; gates a black (0,0,0,0x80) textured quad one pixel bigger on every side |

`Initialize` writes the texture slots and names in ascending sheet order, then clears the
cursor, cell size, text buffer and RGBA colours in ascending field order. The chained
assignments retain the retail store sequence while sharing each constant load.

## Functions
- `__ct__` calls `Initialize` and returns this.
- `InitTexture` returns void (v0 is just strcpy's leftover). Retail call (evLoadDebugFont):
  `(-1, "", -1, "", slot, name)` -- only the half-width sheet is loaded there.
- `PrintDirect` returns void (v0 not set). `vsprintf` (declared with the other newlib printf
  functions in `ps2/include/std/cstdio`, taking the argument pointer as `char *`) into a 0x408-byte stack buffer
  (frame 0x4A0: buffer at sp+0x30, 5-byte compare buffer at sp+0x438).
  Byte loop: 0 ends; bit 7 set -> if 0xA1..0xDF half-width kana via `ascii2serno`, else a two-byte
  SJIS char via `SjisToSerno((b0<<8)|b1)`. Sound marks 0x2134/0x2135 with a nonzero `prev_serno`
  become `prev_serno+1`/`+2`, x moves back by `char_width-8`, `prev_serno` cleared.
  ASCII: 'E' starts a check of 5 bytes against "ESC[$" (`at_419`) / "ESC[#" (`at_420`) -- the
  literal letters E,S,C,[ , not the 0x1B control code; `\t`, `\n`; anything else is
  `__putc(c + 0x204D)`.
- `__putc(serno)`: serno >= 0x2285 draws nothing. <0x1000 sheet 0, <0x2000 sheet 1 (serno-0x1000),
  else sheet 2 (serno-0x2000, glyph width 9 instead of 16). Cell = serno&0x3F column,
  serno>>6 row, 16 px cells; edge cells clamp UV to 0x3FF. Uses a stack `mgCDrawPrim`
  (`Begin(6)` = sprite prim). x advances by `char_width - (16 - (w-1)) + 2`.

## File-local functions (static, belong in the .cpp, not the header)
Listed local in `build/re/local_symbols.tsv`. All return 64-bit values (`daddu`/`daddiu` results):
- `static unsigned long SjisToJis(unsigned long sjis)` -- standard SJIS -> JIS X 0208.
- `static unsigned long SjisToSerno(unsigned long sjis)` -- `(jis>>8)*94 + (jis&0xFF) - 0xC3F`
  (row-major index of 94-cell rows from JIS 0x2121).
- `static unsigned long ascii2serno(unsigned char c)` -- switch over 0xA0..0xDF via jump table
  `at_288__3` (.rodata 0x100 bytes); default 0x227E. Asm is marked "handwritten" because the
  first instruction is `addi` (signed add) -- MWCC switch idiom.

## Globals
- `JisFont` (.bss 0x3F36A0, 0x8B0): the single instance.
- `at_419`, `at_420` (.rodata, 6 bytes): "ESC[$" and "ESC[#" string literals.
- `at_288__3`: jump table of `ascii2serno`.

## Enums
`DbgFontSerno` values all seen in `__putc`/`PrintDirect`/`ascii2serno` as above.
`DbgFontSheet` indexes the three sheets (order from `InitTexture` args and `__putc` ranges).

## First game
No counterpart: the first game's `CDebugFont` (`debugfont.hpp`) is an unrelated buffered overlay.
