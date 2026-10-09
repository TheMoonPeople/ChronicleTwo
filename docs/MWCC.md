# MWCC 3.0 matching notes

ChronicleTwo game source uses MWCC 3.0-011126 with `-O3,p`, readonly strings,
exceptions and RTTI disabled, and division checks enabled. The
[Satan's Fiddle integration](../scripts/build/SATANSFIDDLE.md) makes verified
compiler state explicit without changing game source. The executable hash and
hook opcode signatures must match; a version string alone cannot authorize a
memory hook.

## Verified compiler state

**Helper-call history.** Compiler helpers accumulate masks of argument registers
they read. These masks survive translation-unit boundaries during a combined
compile, changing interference and register allocation in later functions.
The profile seeds integer and floating helper masks at translation-unit entry;
normal helper calls still accumulate history afterward. These masks describe
helper arguments, not a general register reservation policy.

Direct measurements in this pinned 3.0 compiler establish GPR mask `0x30` for
unsigned 64-bit division and `0x10` for double-to-float conversion, with FPR mask
zero in both cases. The calibrated unit rows use `0x30`, except `nd_meswin.cpp`
uses `0x10`. Do not insert non-retail functions in discarded sections to seed
this history. Replacing those functions with profile rows preserves every
allocated byte and resolved relocation, including existing unmatched functions.

**Floating argument evaluation order.** A floating constant's internal
evaluate-first byte can retain compiler-arena contents. Call lowering uses
that byte to decide whether to materialize an argument in its early walk.
Initializing the annotation path alone is insufficient: lowering can create
fresh constant nodes afterward. The verified argument-consumer hook initializes
direct constants before the read and reapplies stable overrides. Verified
assignment wrappers and compiler-registered pooled literal loads are recognized
for explicit selectors; ordinary variable expressions keep normal annotation.

Expression identities comprise source basename, mangled enclosing function,
binary32/binary64 type and exact IEEE bits. An optional mangled `callee` resolves
different requirements for the same value in one function. Scoped rows apply at
consumption and take precedence over unscoped rows. No occurrence counts,
ordinals, instruction addresses or compiler-arena addresses select expressions.
Unmatched selectors are errors, so source changes cannot silently leave stale
calibration behind. Signed zero and NaN payloads remain distinct identities.

**Nested call arguments.** Some calls in one function need opposite schedules
despite sharing the outer callee and constant. At argument consumption, the
verified 3.0 call AST exposes sibling call expressions. A scoped selector may
identify a nested call by its mangled callee and either a typed constant at a
formal argument index or a nonliteral variable load at that index. The index
is a source argument position, not a call occurrence. `RoboWalkMoveIF` uses
`unitRotation`'s 16.0f argument to preserve zero across that call;
`RoboAirMoveIF` instead selects the call whose angle is a local variable.
The pinned Satan's Fiddle source patch implements and tests this generic form.

**Pooled literal aliasing.** The separate bug that treats a literal's value buffer
as variable alias metadata is verified for MWCC 2.3.3. No affected alias path is
validated for this 3.0 image. It can pool constants under other optimization
options, including `-O2`; that does not establish the alias bug. The 3.0 profile
therefore omits literal-reload policy settings.

## Retail calibration examples

| Translation unit and function | Verified scheduling policy |
|---|---|
| `mapjump.cpp`, `ExitInterior__FP6CScenePi` | binary32 zero (`0x00000000`) first restores the retail stack frame and float preservation across the angle-limit call. |
| `pbuggy.cpp`, `InitBomb__FP6CScene` | binary32 pi (`0x40490fdb`) first restores the retail instruction order. |
| `dngmenu.cpp`, `Initialize__11CDngFreeMapFv` | binary32 286 (`0x438f0000`) first restores the initial rectangle argument order; the whole unit passes after native promotions. |
| `dngmenu.cpp`, `CheckIsViewMove__11CDngFreeMapFiiRfRf` | GPR helper-history seed `0x30` preserves coordinate-copy order and the final displacement after the floating branch; the whole unit passes with the native function. |
| `menumain.cpp`, `MenuInternSelectDraw__Fv` | binary32 80 (`0x42A00000`) and 350 (`0x43AF0000`) evaluate first for `DrawMenuFillBox` only; direct arguments and inline strings pass the whole-unit check. |
| `event_func.cpp`, `_SET_CROSSFADE__FP12RS_STACKDATAi` | binary32 one (`0x3f800000`) first only for `CrossFadeOut__10CFadeInOutFiif`; sibling `CrossFadeIn` and `CrossFade` calls retain false. |
| `scenesnd.cpp`, `SePlayFoot__6CSceneFiiPf` | binary32 1200 (`0x44960000`) first emits it before 160, as retail does. |
| `gyoracesim.cpp`, `CharacterBonus__FP12grFISH_PARAMP15RACE_FISH_PARAMi` | zero and 0.01 (`0x3c23d70a`) first preserve both the earlier zero/0.01 calls and the later call's 0.01-before-one materialization. |
| `menuaqua.cpp`, `Draw__9CAquariumFv` | binary32 120 (`0x42f00000`) and 242 (`0x43720000`) evaluate first for `DrawMenuFillBox` only, preserving the retail debug-panel width/height preparation before its top coordinate. |
| `menuchr.cpp`, `Draw__15CMenuCostumeSelFv` | binary32 36 (`0x42100000`) first for `DrawMenuFillBox` only emits the help box's X before its Y subtraction, as retail does; the whole unit passes. |
| `actionchara.cpp`, `RoboWalkMoveIF__12CActionCharaFi` and `RoboAirMoveIF__12CActionCharaFii` | Nested `unitRotation` argument identity selects the zero load order for only the differing rotation calls; the complete unit passes. |

These rows were accepted through the canonical object comparison. They establish
the listed functions' bytes and resolved relocations, not whole-unit matching
when other source or data-layout failures remain.

`mg_texture.cpp` needs one shared `#pragma optimization_level 2` region around
its three hash-table methods. Direct indexing yields the retail table access;
whole-unit level 2 changes unrelated functions. The scoped region preserves
the exact 0x3674-byte object and 160 resolved relocations.
Unit-specific evidence is in the tracked mapjump and event_func RE notes and
[pbuggy calibration notes](../ps2/re/docs/pbuggy/notes.md).

## Source matching and verification

Read unit documentation first and analyze retail with `./decompile.sh SYMBOL`
using m2c. Establish dependency types and layouts before changing expressions.
An early `mtc1`, changed saved register or changed stack frame can be a compiler
state difference; test the deterministic profile before changing source to
imitate incidental allocation. Use correctly typed literals and real field
layouts rather than pointer arithmetic or instruction-shaped source.

For each calibration, copy the profile privately, compile with the repository
wrapper and canonical flags, run `scripts/build/fixup_sections.sh`, then run
`scripts/build/check_objects.py`. Accept a row only when the target has zero
byte and resolved-relocation differences and existing unit failures are
preserved or resolved. Fixup is required: mwccgap's temporary `.dead` sections
are removed by the normal build stage.

Objdiff source-only objects use the same Satan's Fiddle profile as linked
objects; native template names are mapped structurally to retail identities.
The objdiff target preparation localizes explicit switch `jlabel .LXXXXXXXX`
symbols so they do not split native functions into artificial report rows.
This changes only the comparison object's symbol metadata; the linked game
objects retain the exported labels required by separately assembled tables.
A fuzzy percentage is diagnostic, not proof of an exact match. `INCLUDE_ASM`
and inline assembly do not qualify as matched native decompilation. Internal
class initializers must be generated naturally by the compiler.

## Register allocation

- GPR simplify pushes nodes of degree below 25 in increasing virtual-register
  order, then the lowest cost/degree node; colouring pops into the first free
  of `v0 v1 a0–a3 t0–t7 t8 t9 s0–s7`; later pushes get first choice
  ([gyoracesim](../ps2/re/docs/gyoracesim/night-20261008.md)).
- Captured [gyoracesim graphs](../ps2/re/docs/gyoracesim/night-20261008.md)
  place single-web locals (reverse declaration order) above induction and
  invariant temporaries, then extra webs of reused variables. Direct indexing
  can make a row address a low-numbered CSE temporary rather than a named local
  ([gyorace](../ps2/re/docs/gyorace/night-20261008.md)).
- A loop's own index or a variable's first use is coloured before the loop
  optimizer's offsets and a later use after them, wherever the variable is
  declared ([menusys](../ps2/re/docs/menusys/night-20261008.md)); a later
  assignment to an index can change its loop web
  ([dngmenu](../ps2/re/docs/dngmenu/night-20261008.md)).
- An expression repeated in full (`top + heights[row]`) is one CSE temporary
  that shares its left-associated prefix and is coloured after the named
  locals ([menudraw](../ps2/re/docs/menudraw/night-20261008.md),
  [mglib](../ps2/re/docs/mglib/night-20261008.md)).
- Equivalent spellings colour differently: no-op casts, `c ? 4 : 3` versus
  `if`, `> 2` versus `>= 3`, two-element local arrays versus scalars, and a
  block-local versus a spill-reload temporary; `u8` snapshots follow their
  uses ([editloop](../ps2/re/docs/editloop/night-20261008.md),
  [title](../ps2/re/docs/title/night-20261008.md), mg_tanime).

## Scheduling and delay slots

- Before allocation the list scheduler takes the first ready instruction in
  emission order and switches only to one with a strictly lower pressure score
  (a store ending a live range beats a zero store, which beats a new constant),
  so constants issue in source order and stores follow them
  ([sound](../ps2/re/docs/sound/night-20261008.md)); splitting a statement or
  reusing a variable reorders them
  ([gyorace](../ps2/re/docs/gyorace/night-20261008.md)).
- After allocation it orders by critical path, successors unblocked, height,
  then source order (`MsgInit`, dngmenu). An identical schedule can still
  change interference: assignment order in a branch decides what is live at
  the join (`DrawRoot`). Evaluate-first rows cover only call arguments.
- A target block's first instruction fills only the first delay slot that
  claims it, a jump's included (`b exit; move v0,zero`), so a `switch`
  default's jump can take a shared `return 0` and leave retail's later `nop`
  (`LRCheck`, menusys). LRCheck's four sparse labels sharing one body compare
  in reverse written order.
- A single-case `switch` and the equivalent `if`, or `x = x < 0.0f ? -x : x`
  and `if (x < 0.0f) x = -x;`, fill delay slots differently
  ([menuchr](../ps2/re/docs/menuchr/night-20261008.md),
  [mg_tanime](../ps2/re/docs/mg_tanime/nmmisc-20261008.md)).

## Source forms

- Explicitly cast call arguments are set up first, even with the same type:
  `f(a, (u8 *) b)` sets `a1` before `a0`
  ([nameregi](../ps2/re/docs/nameregi/natural-20261008.md), actscript).
- `p + i` and `i + p` both put the pointer first in the `addu`
  ([mg_dataset](../ps2/re/docs/mg_dataset/natural-20261008.md)).
- A same-type local copy propagates unless the source is redefined or `const`
  differs; a local assigned once and used once is substituted. A call result used before the
  next call stays in `v0`, so a `v0` test beside a spill store needs a separate
  `const` lookup local ([dng_event](../ps2/re/docs/dng_event/night-20261008.md)).
- `T *const p = array;` keeps a base register; `x = load; x &= mask;` gives
  the AND result the load's register (`mgEndFrame`, mglib).
- `*write++ = q;` reuses the dead argument register; a separate cursor local
  does not ([mg_drawprim](../ps2/re/docs/mg_drawprim/natural-20261008.md)).
- Placement new can test the copied register (`CMapSky`), and array new
  can recompute `n * sizeof(T)` instead of retaining a precomputed byte count.
  The cited probes therefore keep their matching explicit `operator new` or
  `operator new[]` forms
  ([sceneload](../ps2/re/docs/sceneload/natural-20261008.md),
  [mg_dataset](../ps2/re/docs/mg_dataset/natural-20261008.md),
  [menucommon](../ps2/re/docs/menucommon/natural-20261008.md)).
- Named locals (block-scoped ones too) take frame slots in declaration order;
  argument temporaries, built right to left, and spills follow. A
  `sceVu0FVECTOR` parameter's spill keeps 16-byte alignment (gyorace, dng_event).
- `optimization_level 2` is global CSE without strength reduction or loop
  rotation; level 4 runs the IR optimizer twice and CSE renumbers recreated
  constants lowest ([movie](../ps2/re/docs/movie/nmmisc-20261008.md)).
  Template-using functions can compile at the next top-level declaration,
  under the pragmas before it (mg_tanime).

## Data extents and alignment

MWCC gives native data objects their own extents and alignment; retail symbols
exclude the gaps between objects. Keep natural definitions exactly sized and
retain their original compiler alignment as evidence. See the split, padding
and comparison rules in [Data layout](../scripts/build/DATA_LAYOUT.md).

## Natural C++ definitions

MWCC generates constructor vtable writes and C++ symbol names from class
definitions. Keep member functions and constructors in C++ form so the compiler
emits those symbols. A local `divbyzerocheck` pragma needs demonstrated code
generation evidence because that option is enabled by the shared flags.

Retail compiler-derived copy assignments have processor-specific symbol binding
13, unlike user-written assignments with global binding. Their outline decision
depends on inline depth: scoped `inline_depth(0)` makes the implicit
`CMapLightingInfo` assignment appear at the retail address and matches its
callers, while default depth inlines it. The same depth outlines the implicit
`sceGsTex0` and `mgCVisualMDT` assignments, but changes their callers or nested
base/constructor calls; those units still need exact source and type work.
`dont_inline` does not outline the implicit TEX0 assignment in the tested
compiler. Do not hand-write these generated assignments or compensate with
function-specific compiler hooks.

Compare complete objects as well as individual functions: emitted inline
helpers, static initializers and data sizes can change the containing unit.
The PAL executable verifier checks the final linked layout afterward.
Word scores mask relocations and so hide calls to a WEAK constructor emitted
past the inline depth (`MenuItemCharaDataLoadEndCheckAfter`, menuchr). An
inline function taking a class by value in a widely included header renumbers
MWCC's generated locals, and so the `at_NNN` symbols, in every includer (gyorace).
