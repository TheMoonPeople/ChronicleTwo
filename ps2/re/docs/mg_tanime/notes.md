# mg_tanime: reverse-engineering notes

Every function of the unit is native C++ and byte-identical; there are no
`NONMATCHING` guards, `INCLUDE_ASM` entries or data markers, and the unit emits
its own `CList<mgCTexAnimeData>` vtable. `mgCTextureAnime::NewTexAnimeData`
(retail symbol 0x13DA40, size 0x7C in a 0x80 extent) uses one before-inline
placement conversion row for its `CList<mgCTexAnimeData>` construction; without
the row MWCC branches on `v0`, then moves the node into `s0` and uses `v1` for
the vtable, while retail moves the allocated node into `s0` before the branch
(six words). The before-inline timing is the measured exception to the other
accepted rows. See [placement conversion](../satansfiddle/placement-new.md).

## Data

`tex_tag` is a `static SPI_TAG_PARAM[14]` table of the thirteen tag names and
handlers plus its null terminator, with inline name literals; the handlers are
file-local. Both texture-block mismatch diagnostics inline
`"%s block is not match!!!\n"`. The ten loader-state globals are `static`
definitions and `mgCTextureAnime::stop_anime` keeps its header declaration.

## Current TexAnime and optimizer state

`TexAnime` is native and exact at retail's 0x1458-byte symbol size. The
unit uses `#pragma optimization_level 2`, preserving global common-
subexpression elimination without the level-3 loop strength reduction.
Template-using functions receive the pragma state in force when their
code generation is triggered by the next top-level declaration. The
unit-wide setting preserves the already matched sibling functions.
The zero-constructed rectangle objects correspond to six real retail
`Set(0,0,0,0)` calls on distinct slots.

### Optimization level

Retail `TexAnime` performs global common-subexpression elimination without
strength reduction: `group * 4` is computed once per main-loop iteration and
spilled (`sw/lw 0xF0(sp)`), `&frame[group]` is materialized before the
comparison that stores through it, and the first loop still shifts its index
every iteration. `#pragma optimization_level 2` applied once to the whole code
section produces exactly that mixture and reproduces every other function;
`opt_strength_reduction off` alone breaks `Initialize` and
`NewTexAnimeGroupData`, and level 2 with `opt_propagation off` breaks
`texSCROLL`. `TexAnime` and `NewTexAnimeData` use class templates
(`mgRect<int>`, `CList<mgCTexAnimeData>`), and MWCC defers their code
generation until the next top-level declaration begins, so a pragma pair
around either function alone has no effect; a trailing `optimization_level 1`
reset is unnecessary. Under level 2 `group_num`, `list[i]` and `name[i]`
reproduce `GetEmptyGroup` and `SearchGroupName`, and `node->pGetData() == NULL`
reproduces `NewTexAnimeGroupData`'s record test.

### TexAnime source forms

- The first loop's `node` and `data` are block-scoped; sharing them with the
  main loop spills `node` (1204 words).
- Six scroll rectangles are constructed with `mgRect<int>(0, 0, 0, 0)`: two
  after the indexed path's end values, two after the true-colour path's, two at
  the start of the VRAM draw (only the first drawn with). The palette and copy
  rectangles are argument temporaries and follow them on the stack.
- Period magnitudes are `p = p < 0.0f ? -p : p;` in both paths; the `if` form
  misplaces one nop at each of the four joins.
- `now[group]` is stored directly (its address CSE is the last spill slot); a
  `current` slot pointer costs 48 words. The expiry test reads `now[group]`
  before loading `node` from it, which gives retail's spill-slot order, and the
  advanced record is held in a block-local `next` before it is stored: a
  declared local is numbered low and coloured after the base and `wait`,
  landing in `a0` as retail does.
- `wait <= frame[group]` restores `slt at` in the patched branch; clearing the
  counter after advancing costs 77–105 words.
- `NewTexAnimeGroupData`'s list-slot pointer stays
  `(CList<mgCTexAnimeData> **) ((group << 2) + (int) this + 0x64)`: retail adds
  the scaled group to `this` with the index first (`addu v1,v0,s2`).
  `&list[group]`, `list + group`, `group + list` and `&this->list[group]` all put
  `this` first (one word at 0x13DB66); indexing `list[group]` directly swaps the
  slot and head registers (11/72).
- The `(int)` casts on `TBP0`/`TBW` convert `u_long` bitfields; the TEXA value
  has no libgraph macro; `wait < 0` is an ordering test, not the
  `MG_TEX_ANIME_WAIT_FOREVER` equality.
- The texture animation colour is copied as one `mgTexAnimeColor` record.

Engine texture animation (`mg_tanime.cpp`). First-game counterpart: `textureanime.hpp`
(`CTexAnimeData` / `CTextureAnime`). The design is the same in spirit, but every layout differs:
records are now heap-allocated `CList<mgCTexAnimeData>` nodes in per-group linked lists, groups have
names, and records carry drawing state (bilinear, alpha blend/test, colour). Nothing was copied across.

## Symbol binding (retail ELF, `rom/pal/extracted/iso/SCES_511.90`)
- GLOBAL: every `mgCTextureAnime`/`mgCTexAnimeData` member, `mgCTextureManager::LoadCFGFile`,
  `stop_anime__15mgCTextureAnime`.
- WEAK: `Set__9mgRect<i>Fiiii` (inline template member emitted out of line; also `mgRect<s>` at
  0x2C4240 and `mgRect<f>` at 0x1F3D50 elsewhere).
- Multidef/comdat (st_other 13): `Initialize__24CList<15mgCTexAnimeData>Fv`, `__vt__24CList<...>`.
- LOCAL (so `static` in the .cpp, not in the header): all thirteen `tex*__FP9SPI_STACKi` script
  handlers, `tex_tag`, `mgBugPatch`, `pTexAnime`, `pLoadTexAnime`, `now_group`, `TexManager`,
  `TexAnimeStack`, `group_name`, `ta_enable`, `now_texb`, `texBugPatch`, `nowTexData` (0x34 bytes),
  `__sinit_mg_tanime.cpp`. Hence the header has no `extern` globals and no free-function prototypes.

## mgCTexAnimeData (0x34)
Size: `nowTexData` ELF size 0x34; `CList` data spans 0x08..0x3C with vptr at 0x3C.
Evidence: `Initialize` (stores), `EnterTexAnime` (copy, by width: 4 bytes, 2 ptrs, 20 halves at
0x0C..0x32 as s16, 8 bytes), script handlers (which write `nowTexData` fields), `TexAnime` (reads).

| off | field | evidence |
|---|---|---|
| 0x00 | s8 type | init 0xFF; `TEX_ANIME_DATA` arg 0; TexAnime: 0 copy, 1 scroll, 2 wave; texSCROLL branches on 1/2 |
| 0x01 | s8 group | EnterTexAnime passes `(char)data[1]` to NewTexAnimeGroupData; DATA_END stores now_group |
| 0x02 | s8 link_group | init 0xFF; TexAnime enables this group (if >=0) for each enabled group's current record |
| 0x03 | s8 clut_copy | `CLUT_COPY` arg; TexAnime: if both textures 8bpp and (flag or src_w/h == texture width/height) a 256x256 MoveImage of CLUT TEX0s |
| 0x04 | mgCTexture* src_tex | `SRC_TEX` GetTexture(name,-1) |
| 0x08 | mgCTexture* dest_tex | `DEST_TEX` |
| 0x0C..0x12 | s16 src_x/y/w/h | `SRC_TEX` args 1..4, `<<4` |
| 0x14..0x1A | s16 dest_x/y/w/h | `DEST_TEX` args 1..4 `<<4` (w/h default to src w/h when <4 args) |
| 0x1C/0x1E | s16 period_x/y | texSCROLL: type1 = (dest_w-16)/(arg*16); type2 = integer part of arg. TexAnime steps phase toward it (sign = direction) |
| 0x20/0x22 | s16 phase_x/y | zeroed in Initialize; incremented/wrapped in TexAnime when `stop_anime == 0` |
| 0x24/0x26 | s16 amplitude_x/y | texSCROLL type2: frac(arg)*10000 (10000 when |frac|<0.001); TexAnime: dest_w * amp * (1+sin(2pi*phase/period))/2 / 10000 |
| 0x28 | s16 wait | `WAIT` arg0; arg1 non-zero -> 0xFFFF. TexAnime: 0 chains to next record in same frame; <0 holds |
| 0x2A | s16 bug_patch | init from `mgBugPatch`; DATA sets from `texBugPatch` (`BUG_PATCH` tag). Non-zero: advance when frame >= wait, else when frame > wait |
| 0x2C | s8 bilinear | init 1; `DEST_TEX` arg 5; TexAnime `Bilinear()` (only when dest bpp >= 24) |
| 0x2D | s8 alpha_blend | init 4; `ALPHA_BLEND`; TexAnime: 4 = AlphaBlendEnable(0) |
| 0x2E | s8 alpha_test | init 0xFF; `ALPHA_TEST` arg0; -1 = AlphaTestEnable(0), else AlphaTest(method, ref) |
| 0x2F | u8 alpha_ref | `ALPHA_TEST` arg1 |
| 0x30..0x33 | u8 r,g,b,a | init 0x80; `COLOR` args; `mgCDrawPrim::Color` |

Initialize stores 0x24 twice and never 0x26 (retail bug, keep it). Store order in Initialize:
0,1,0x28,3,8,4,0x12,0x10,0xE,0xC,0x16,0x14,0x22,0x20,0x1E,0x1C,0x24,0x24,2,0x2C,0x2D,0x2E,0x2F,0x2A,0x33..0x30.
EnterTexAnime flips Y: `src_y = src_tex->height*16 - src_y - src_h`, same for dest (mgCTexture +4 = height).

Field names are descriptive; retail names unknown.

## CList<mgCTexAnimeData> (0x40)
`operator new(0x40, stack->Alloc(6))` in NewTexAnimeData (inlined ctor: store vptr at 0x3C,
construct data at +8, virtual call vtable+8 = Initialize). `next` at 0 (NewTexAnimeGroupData walks
`*node` to the tail), `prev` at 4 (new node's +4 = old tail). Vtable `__vt__24CList_15mgCTexAnimeData_`
is 0xC: two zero words, then `Initialize`. vptr is placed after the data members (MWCC).
`Initialize` stores +4 then +0, written as `next = prev = 0` (verify when matching).
NewTexAnimeGroupData and EnterTexAnime null-check `node + 8`, i.e. an inline `pGetData()`
(out of line in mapload for `CList<CMapParts>`, which puts data at 0x10 for alignment).

**The `CList<T>` and `mgRect<T>` templates are defined in `mg_tanime.hpp` because
`class_units.tsv` assigns `CList<mgCTexAnimeData>` and `mgRect<int>` to this unit**, but other units
use other instantiations (`CList<CMapParts>`, `<CMapPiece>`, `<CMapParts*>`, `<PartsGroupData>`,
`<CObjAnime>`, `<CFuncPoint>`, `<EMAP_MESSAGE>`; `mgRect<float>`, `mgRect<short>`; `mgRect<int>`
by value in mglib, dngmenu etc.). MWCC rejects a template declared twice in one TU, so other headers
should include this one (or the templates should later move to a shared header).

## mgRect<int> (0x10)
`Set(a,b,c,d)` stores at 0,4,8,0xC. TexAnime uses `Set(x, y, x+w-16, y+h-16)` and tests
`right-left+1 > 0`, so the second corner is inclusive. Passed by value to `mgSetPkMoveImage`.
Field names left/top/right/bottom are descriptive.

## mgCTextureAnime (0x1E4)
Size: texTEX_ANIME_DATA_END does `new(Alloc(0x21)) mgCTextureAnime` with size 0x1E4.
| off | field | evidence |
|---|---|---|
| 0x000 | s32 group_num | Initialize sets 24; every range check uses it |
| 0x004 | s32 enable[24] | Enable/Disable; TexAnime skips disabled groups |
| 0x064 | CList* list[24] | GetAnimeList, GetEmptyGroup (empty = NULL), NewTexAnimeGroupData head |
| 0x0C4 | CList* now[24] | Disable rewinds to list[]; TexAnime advances it to `next`, wrapping to list[] |
| 0x124 | char* name[24] | SetGroupName/SearchGroupName (strcmp) |
| 0x184 | s32 frame[24] | Disable/DeleteGroup zero; TexAnime counts frames when `stop_anime == 0` |
No vtable. Static `stop_anime` at 0x37CD98 = gp-0x7958 (mgBugPatch is gp-0x795C).
TexAnime(texb, packet): only records whose src and dest textures' `*(s16*)tex` (block) == texb;
NULL packet falls back to the global at gp-0x790C (0x37CDE8, another unit's packet).

## mgCTextureManager::LoadCFGFile (defined here, owned by mg_texture)
Declared in mg_texture's header, not here. Sets the file-local state (pLoadTexAnime = anime arg,
TexManager = this, TexAnimeStack = memory, now_texb = now_group = -1, others 0), builds a
`CScriptInterpreter` on the stack (0xED0 frame), `SetTag(tex_tag)`, `SetScript`, `Run`.
The block's animation lives at `GetTextureBlock(n) + 0xC` (mgCTextureAnime*).

## Script (tex_tag, 13 entries + NULL terminator, 8 bytes each: name, handler)
TEX_ANIME(name, enable) -> group_name copied into TexAnimeStack (`Alloc((len+1>>4)+1)`), ta_enable.
TEX_ANIME_DATA(type, name) -> reset nowTexData, type, bug_patch=texBugPatch, now_texb=-1.
SRC_TEX(name,x,y,w,h); DEST_TEX(name,x,y[,w,h[,bilinear]]): both check every texture is in one
block (prints at_873 "%s block is not match!!!\n").
SCROLL(fx,fy) (type 1/2 only, else returns 0); CLUT_COPY(n); COLOR(r[,g[,b[,a]]]);
ALPHA_BLEND(m); ALPHA_TEST(m[,ref]); WAIT(n, forever[, string ignored]);
TEX_ANIME_DATA_END: finds/creates the block's mgCTextureAnime (or uses pLoadTexAnime), takes an empty
group if none, names it, enables/disables per ta_enable, EnterTexAnime(&nowTexData) if both textures set.
TEX_ANIME_END: now_group = next empty group. BUG_PATCH: texBugPatch = 1.
Handlers return int (1 ok, 0 error), signature `(SPI_STACK *stack, int argc)`; stack entries are
8 bytes (args at +8n). SPI_STACK and CScriptInterpreter belong to scriptinterpreter.

## mgCTexture fields seen (owned by mg_texture)
+0 s16 block, +2 s16 width, +4 s16 height, +6 s16 bpp (8 = paletted; >= 0x18 drawn via mgCDrawPrim
into a frame buffer), +8 name, +0x38 sceGsTex0 tex0 (TBP0/TBW/PSM/CBP fields used), +0x3E byte (CBP bits).
## Compiler flag cleanup

The local `divbyzerocheck on`/`reset` pair is redundant with the PS2
compiler flag. Removing it leaves every section and symbol in this unit's
object diff unchanged.
