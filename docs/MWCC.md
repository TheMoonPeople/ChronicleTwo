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

**Placement construction.** `new (buffer) T` with an inline constructor is
lowered as an expression when the constructor's inline class is 6 and as a
statement when it is 3 (retained control statements, nonfinal returns or
cleanup metadata). The two forms test the allocation differently: the
statement form allows `beqz v0` with the saved-pointer copy in the delay slot,
the expression form copies first and tests the copy. A
`placement_new.statement_conversions` row names the caller, the placement
allocator and the exact direct constructor and asks for the statement path for
that one construction. `after_constructor_inline` leaves expression inlining
intact and sets the frontend's own statement-conversion request;
`before_constructor_inline` reclassifies the root constructor read as class 3,
so MWCC statement-inlines the body and sets the request itself. Rows apply
only on the hash-verified compiler, must match exactly `expected_matches`
constructions, and an empty table installs no hooks. The mechanism, census
and timing evidence are in
[the design note](../ps2/re/docs/satansfiddle/placement-new.md).

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

- Named locals are coloured in reverse declaration order ahead of the loop
  optimizer's induction and invariant temporaries; a variable reused in a
  second web is coloured after both. Direct indexing (`table[i].x`) can make
  the row address a CSE temporary instead of a named local, which colours it
  differently from a pointer local to the row (gyorace, gyoracesim).
- A loop's own index, and a variable's first use, are coloured before the loop
  optimizer's derived offsets; a later use is coloured after them, wherever the
  variable is declared. Assigning to a loop index after its loop changes the
  index's web (menusys, dngmenu).
- An expression repeated in full (`top + heights[row]`) is one CSE temporary
  that shares its left-associated prefix and is coloured after the named
  locals (menudraw, mglib).
- Equivalent spellings colour differently: a no-op cast, `c ? 4 : 3` versus
  the `if`, `> 2` versus `>= 3`, a two-element local array versus two scalars,
  and a block-local versus a spilled temporary. A `u8` snapshot of a wider
  value is coloured where it is used (editloop, title, mg_tanime).

## Scheduling and delay slots

- Before allocation the list scheduler issues the first ready instruction in
  source order and moves one earlier only when it lowers register pressure (a
  store that ends a live range, before a zero store, before a new constant), so
  constants materialize in source order and their stores follow them; splitting
  a statement or reusing a variable reorders them (sound, gyorace).
- After allocation it orders by critical path, then successors unblocked, then
  height, then source order (`CMenuTreeMap::MsgInit`, dngmenu). With an
  identical schedule, the assignment order inside a branch still decides what
  is live at the join and so the interference (`CDngFreeMap::DrawRoot`).
- A block's first instruction fills only the first delay slot that claims it,
  a jump's included (`b exit; move v0,zero`): a `switch` default's jump can take
  a shared `return 0` and leave a later `nop` (`CMenuItemInfo::LRCheck`,
  menusys). Sparse case labels sharing one body are compared in reverse
  written order.
- A single-case `switch` and the equivalent `if`, or `x = x < 0.0f ? -x : x`
  and `if (x < 0.0f) x = -x;`, fill delay slots differently (menuchr,
  mg_tanime).

## Source forms

- An explicitly cast call argument is set up first, even when the cast is to
  its own type: `f(a, (u8 *) b)` loads `a1` before `a0` (nameregi, actscript).
- `p + i` and `i + p` both put the pointer first in the `addu` (mg_dataset).
- A same-type local copy propagates into its uses unless the source is
  redefined or `const` differs; a local assigned once and used once is
  substituted. A call result used before the next call stays in `v0`, so a
  `v0` test beside a spill store needs the looked-up value in a separate
  `const` local (dng_event).
- Binding a computed scalar to a used `const T &` can stop one-use forward
  substitution into call arguments without adding storage or instructions.
  EditLoop's remaining fishing capacity uses this form; ordinary value snapshots
  move the capacity calculation into the pointer-first argument walk. The exact
  source and six-word value-local residual are in
  [the unit note](../ps2/re/docs/editloop/notes.md).
- `T *const p = array;` keeps the base in a register; `x = load; x &= mask;`
  gives the AND result the load's register (`mgEndFrame`, mglib).
- `*write++ = q;` reuses the dead argument register; a separate cursor local
  does not (mg_drawprim).
- Placement new can test the copied register rather than `v0` (`CMapSky`),
  and typed array new recomputes `n * sizeof(T)` rather than keeping a
  precomputed byte count; where retail kept the byte count, the explicit
  `operator new` or `operator new[]` call is the matching form (sceneload,
  mg_dataset, menucommon).
- Named locals, block-scoped ones included, take frame slots in declaration
  order; argument temporaries, built right to left, and spills follow. A
  `sceVu0FVECTOR` parameter's spill keeps 16-byte alignment (gyorace,
  dng_event).
- A whole-register store through a cast, `*(u_long *) &env.field = value;`
  for a `sceGsDispEnv` register or `*(u_long *) &frame` for a `sceGsFrame`,
  materializes the address and reloads the array index before the next store;
  a plain member store or a `.value` access keeps the index and address in
  registers (`mgEndFrame`, `mgSetPkFrameBuffer`, mglib).
- Two `case` labels with identical bodies (`SCE_GS_PSMCT16` and
  `SCE_GS_PSMCT16S` both setting `bpp = 16`) schedule differently from one
  shared fallthrough body (mglib).
- Clearing a loop's shift counter before an earlier loop, rather than beside
  the loop that uses it, changes the surrounding schedule
  (`mgSetPkFrameBuffer`, mglib).
- `#pragma optimization_level 2` is global CSE without strength reduction or
  loop rotation; level 4 runs the IR optimizer twice and CSE renumbers
  recreated constants lowest (movie).
- MWCC generates a function that uses a template when it reaches the next
  top-level declaration, under the pragmas in force there. A scoped
  `optimization_level 2` / `optimization_level reset` pair around such a
  function therefore does not apply to it, and the reset lands on the
  functions that follow instead; mg_tanime sets `#pragma optimization_level 2`
  for the whole unit.

## Data extents and alignment

Retail symbol sizes describe objects, while the split section pieces include
the alignment gap before the next symbol or referenced address. Once data
sections are assigned alignment one for linking, their bytes must retain that
gap. The postprocessor extends a correctly sized native object by fewer than
16 bytes to its piece boundary; initialized padding must be zero in retail.
An object with a size different from its declared retail size is not padded.
Referenced interior addresses remain separate piece boundaries.

A terminal function may end before the next unit's address when the generated
linker script supplies the intervening alignment. The canonical checker permits
this only at the exact `contents_end` established by the script and only for an
all-zero retail tail. Objdiff target symbol metadata records declared retail
function sizes so the same linker padding is excluded from function scores.

MWCC gives native data objects their own extents and alignment; retail symbols
exclude the gaps between objects. Keep natural definitions exactly sized and
retain their original compiler alignment as evidence. The split, padding,
naming and comparison rules are in [Data layout](../scripts/build/DATA_LAYOUT.md).

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
The PAL executable verifier checks the final linked layout afterward. Word
scores mask relocations and so hide a call to a WEAK constructor emitted past
the inline depth (`MenuItemCharaDataLoadEndCheckAfter`, menuchr). An inline
function that takes a class by value in a widely included header renumbers
MWCC's generated locals, and so the `at_NNN` symbols, in every includer
(gyorace).
