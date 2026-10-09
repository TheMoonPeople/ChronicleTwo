# mg_tanime: reverse-engineering notes

`mgCTextureAnime::NewTexAnimeData`'s native constructor sequence is still
fuzzy, so the matching build uses retail assembly and preserves its C++ draft
under `NONMATCHING`.
The six differing instructions surround placement-new's generated null check:
retail moves the allocated node into `s0` before the branch and uses `v0` for
the list vtable address, while MWCC's current C++ expression branches on `v0`,
then moves the node into `s0` and uses `v1` for the vtable. Direct returns,
separate allocation storage, constructor parentheses, pointer qualifiers, and
local optimizer, scheduler, and inline-depth controls retain or worsen this
difference. No candidate passed isolated linked-image verification.

The [placement-new report](../funcpoint/placement-new.md) records constructor
and cross-unit evidence. Complete list specializations, including ordinary
inline constructors defined in this source unit, narrow the difference to
`beqz s0` instead of retail's `beqz v0` at +0x30 but do not match. The current
generic constructor already performs virtual list initialization; the data
constructor is independently evidenced by its retail out-of-line symbol.
Changing either to omit initialization is inconsistent with those constructors.
The saved and reproduced null-aware result-helper experiment grows the function
to 0x88 bytes, despite a handoff synopsis describing it as a match; the helper
is a semantic no-op and inadmissible in either case. The original 6/32-word
guarded draft is retained. Reconsider when a genuine matching inlined-list
caller establishes a new constructor or allocation-result lifetime distinction.

The [Chronicle comparison](../funcpoint/placement-new.md#chronicle--dark-cloud-1-comparison)
records all 19 matching DC1 placement-new expressions: four scalar sites test
`v0`, six test a saved register, and nine arrays have no caller construction
guard. DC1 uses MWCC 2.3.3 build 1010 at `-O2`, so these are comparative
examples rather than a 3.0-011126 source recipe. Its class-A scalar constructors
carry the expression through the constructor return; none preserves the original
allocation pointer in DC2's copy-before-`beqz v0` sequence. Naming the placement
buffer, initializing the destination at declaration, and compiling the original
draft at `-O2` all leave this target at 6/32 words and 0x7C/0x80 bytes. A direct
return was reproduced with the same result; that form was already recorded
above. All experimental source changes were restored; the guarded unit passes
`draft.sh --promote`, the PAL image passes, and complete objects pass 149/149.
No source or shared-header patch is validated. A comparable 3.0-011126 inlined
list caller, or a compiler trace showing where the implicit allocation check
is bound to its persistent object pointer, is still needed.

## Current TexAnime and optimizer state

`TexAnime` is native and exact at retail's 0x1458-byte symbol size. The
unit uses `#pragma optimization_level 2`, preserving global common-
subexpression elimination without the level-3 loop strength reduction.
Template-using functions receive the pragma state in force when their
code generation is triggered by the next top-level declaration; this
explains the earlier unsuccessful scoped/reset experiment. The complete
unit-wide setting preserves the already matched sibling functions.
The zero-constructed rectangle objects correspond to six real retail
`Set(0,0,0,0)` calls on distinct slots. Full reconstruction and deferred
code-generation evidence are in [nmmisc-20261008.md](nmmisc-20261008.md).

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

## Remaining canonical differences

The focused wrapper build and section fixup check 0x27E0 bytes and 341 relocations.
`NewTexAnimeData` retains the typed `CList<mgCTexAnimeData>` placement construction.
Retail saves the allocation result in its retained register before the null branch
and returns that register after the branch joins. Current MWCC lowering saves it
inside the successful branch and returns the unsaved null result on failure. The
record constructor and virtual list initialization calls otherwise correspond.
Disabling the global optimizer does not change this lowering; a manual compiler
constructor call is unnecessary for the source semantics and is not a native fix.

The other two canonical failures concern `nowTexData`: its declared 0x34-byte record
occupies a retail 0x40-byte BSS piece, leaving the run twelve bytes short. The
`CList` node is already correctly sized at 0x40 and its carried record remains
0x34; enlarging that record would shift the node's vtable. These baseline failures
are preserved pending a separate analysis of the global object's trailing storage.

With the native BSS padding correction applied, the focused object has only the
`NewTexAnimeData` byte failure. The remaining allocation difference can be isolated
by disabling peephole optimization: the compiler then saves the allocation result
before the null branch, matching retail's placement of that move, but tests the
saved register rather than the original return register and loads the virtual table
through the argument alias. Default peephole optimization fixes those two aliases,
but sinks the saved-pointer move into the successful branch and skips its return on
failure. Disabling propagation or lifetime optimization does not change that result.
This is a code-generation difference, not evidence of an incorrect `CList` layout.

An additional native trial scoped `optimization_level 2` around `NewTexAnimeData`,
with `optimization_level reset` immediately after the function. Its target retained
the same six instruction differences. The fixed-up unit changed from 0x27E0 bytes
to 0x25F8 bytes and reported 223 object problems, including shortened later function
extents. Pairing the scope with `global_optimizer off` produced the same target
difference and unit-wide failure. Neither scoped pragma form was a viable
local fix at that checkpoint.
MWCC defers template-using functions until the next top-level declaration,
so the reset affected more than the intended function. The later unit-wide
level-2 reconstruction documented above supersedes this scoped experiment.

## Placement construction under Satan's Fiddle (2026-10-08)

The canonical SF wrapper retains the guarded NewTexAnimeData draft at
**6/32 differing words, 0x7c/0x80 bytes**. Current-source plain wibo emits
the same selected function. GPR helper seeds 0/0x10/0x30, default float
evaluate-first true, and the baseline policy all leave its text unchanged.
The shared-header and source-form experiments above were not repeated.

A hash- and signature-checked LLDB trace now explains the saved-copy position.
The inliner classifies `CList<mgCTexAnimeData>`'s constructor as expression
inline class 6. Original high-level IR retains a construction node (kind 0x3a)
with allocation and a constructor comma expression. Late IroLinearForm emits
an allocation-result temporary and its null guard, with the constructed-object
copy inside the successful branch. Constructor-result copies then feed the
allocation-expression result at the join. First coalescing maps that result
and the guard to ABI `v0`, while retaining the success-only object copy;
coloring maps that object to `s0`. The ordinary scheduling pass is skipped
for this function. Retail instead saves its allocation pointer before the
`v0` guard and returns the retained register at the join.

Thus this six-word case includes a null-path/result-lifetime difference beyond
the two-word saved-register guard pattern. Helper/float state did not move the
copy, and no affected uninitialized compiler input was found. No new natural
source or SF policy is validated. Reconsider when an evidenced constructor or
caller takes the early statement-conversion path while preserving the retail
construction calls and result lifetime, or when an identical-source state
probe demonstrates an affected state read. Merely forcing control flow into
the constructor would change source semantics or add a codegen no-op.

The [SF placement-new report](../funcpoint/placement-new.md#under-satans-fiddle)
records the comparison with class-A CMenuInvent/CMenuMoveItem, exact pass
boundaries and initialized inline classification. Private evidence is in
`.private/placenew-sf/trace-final-mg_tanime/` (inline classifications,
original/optimized/expanded IR, PCode and canonical text comparison) and
`.private/placenew-sf/baseline/native/mg_tanime.*`. No symbol was promoted.
The lane's canonical image retains i13's three unrelated object failures
(146/149); all sections except the known 0x2c-byte .text difference pass,
and coverage remains 6,677 matched / 175 guarded / 15 asm-only / 5 fuzzy.

## Constructor-classification follow-up (2026-10-08)

The constructor lane decodes the exact statement classifier and validates real
array-initialization loops for `CShopMenu` and `CSaveMenuClass`. An inline
callee with statement class 3 can also request conversion while its enclosing
constructor still has class 6. Ordinary locals, aggregate initialization,
void-call sequences and final `return;` remain class 6; locals requiring a
destructor use cleanup metadata and select class 3, while destructible by-value
signatures can instead be ineligible (class 0).

No corresponding array initialization exists in `CList<mgCTexAnimeData>`'s
retail construction sequence. Its data constructor and virtual list
initialization must remain; adding a destructor-bearing local or artificial
control flow supplies no original-source evidence. `NewTexAnimeData` therefore
retains its existing guard and separate result-lifetime park. Full classifier
cases, constructor-chain comparison and i15 acceptance receipts are in
[Constructor inline classification](../funcpoint/placement-new.md#constructor-inline-classification).
