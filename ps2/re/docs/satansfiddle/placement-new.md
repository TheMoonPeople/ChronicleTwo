# Scalar placement-new statement conversion

The placement-new capability requests MWCC's own statement-conversion path for
selected scalar constructions. It is an intentional frontend decision override,
not an established repair of uninitialized compiler state. The accepted source
and profile produce 34 additional native callers in 21 units, with PAL bytes
matching retail and 149/149 complete game objects passing. The caller rows are
an activation list for those promotions; they do not recover one original global
compiler policy.

## Compiler mechanism and boundary

The supported compiler is MWCC 3.0-011126, executable SHA-256
`0e16a5d6205101f840f85c02664f21cd63b39a0dec2dff417b3a61b4477f0e00`.
The full [lowering and constructor study](../funcpoint/placement-new.md) establishes
that inline metadata and the conversion-request flag are initialized. An
eligible constructor's classifier at `0x465030` starts at class 6 for expression
inlining. Retained control statements, nonfinal returns, or cleanup metadata
select class 3 for statement inlining; some signatures instead return class 0
and cannot be inlined. A class-3 inline callee can also request conversion inside
an outer class-6 constructor. Ordinary calls, locals and final returns alone do
not force class 3.

Early construction conversion at `0x463bf0` puts the allocator assignment inside
the null condition. Late IroLinearForm at `0x4c2d8a` emits an assignment followed
by a test of the saved object temporary. These are distinct value dependencies
before coloring or delay-slot scheduling. In the common near miss, early form
allows `beqz v0` followed by the saved-pointer copy in the delay slot; late form
copies first and tests the saved register. The texture-animation caller has a
separate success-only result lifetime and disables scheduling.

`after_constructor_inline` leaves normal expression inlining intact, then writes
one byte to the frontend's statement-conversion request at `0x54d6f8`. MWCC
natively sets that byte on its class-3 path at `0x462fd3`, clears it per statement
at `0x464b70`, and tests it at `0x464b8d` before ordinary re-lowering through
`0x463ef0`. `before_constructor_inline` instead changes only the current root
constructor read's low EAX byte from 6 to 3. Neither changes stored constructor
metadata, emitted instructions, allocator values, or optimizer operands. All
MIPS, symbols and relocations are emitted by MWCC's normal passes.

The [placement patch](../../../../scripts/build/patches/satansfiddle-placement-new.patch)
checks eleven guest opcode signatures before installing its hooks. Those
addresses identify operations in the hash-pinned compiler; none is a profile
selector.

## Retail census and limits

The [dated census](placement-new-census-20261008.md) covers all direct scalar
`__nw__FUiP1` calls in top-level PAL game-unit assembly: 216 sites in 116 callers.
This is `operator new(size_t, u_long128 *)`; its retail body returns the supplied
buffer. Arrays, ordinary heap allocation and SDK/runtime units are excluded.
Of these calls, 178 construct nontrivial objects, 21 explicitly call the
allocator and initialize afterwards, and 17 construct trivial scalars. Those
last 38 do not establish implicit constructor-null-check behavior.

| Nontrivial scalar construction | Guard tests allocator result v0 (A) | Guard tests copied register (B) |
| --- | ---: | ---: |
| Inline constructor | 108 | 0 |
| Out-of-line constructor | 68 | 2 |

The two B sites are matched `mapFIX_CAMERA_RECT` allocations of `CColFrame` and
`CCollision` under `inline_depth(0)`. They are not inline-class-6 counterexamples.
Runtime classification is observed for 91 of the 108 inline sites: 74 class 6,
17 class 3. The other 17 are unmeasured. The raw instruction-pattern scan's
196 A/2 B/16 no-branch/2 other count includes explicit checks and trivial objects
and must not replace the constructor-specific table. Assembly shapes, measured
classifier reads, and current source status are separate observations.

Natural matched class-6/A examples exist. Pointer lifetime and register pressure
can produce A without forcing early conversion. The census therefore establishes
a widespread retail pattern, not a proof of a missing compiler option, identical
original source, or an affected state defect. Its original source-status labels
are a dated snapshot and do not override later manual promotions.

## Semantic rows and safety

`placement_new.statement_conversions` rows require logical translation unit,
exact mangled caller, exact scalar allocator, direct constructor, conversion
timing, and positive `expected_matches`. The constructor identifies the allocated
type. The adapter retains the logical source name across mwccgap's temporary
second-pass input and source-only objdiff builds. An empty table installs no
placement hooks.

Only direct scalar roots with original expression-inline class 6 are eligible.
Class 0/3 sites, arrays, ordinary same-type constructor calls and base/member
inline reads are outside the operation. Raw names can provisionally nominate a
row, but cached names or the compiler's ordinary mangler return must supply exact
caller, allocator and constructor witnesses before publication. Wrong overloads,
ambiguous raw associations and unwitnessed implicit constructors fail closed.
The captured call node and live constructor object must agree at the actual
inline-info read.

Conversion affects its enclosing expression. Initial support permits exactly one
construction in that verified statement region, rejects hidden/nested/sibling
constructions and shared construction-bearing subtrees, audits retained inline
callee bodies for deferred constructions and cleanup metadata, and observes
exactly one ordinary lowering visit to the selected node. Unsupported indirect
calls, graphs, body forms and bounds reject conservatively. A metadata-free empty
void return has a verified supported path. Arena epochs prevent reused compiler
pointers from inheriting records; resets and teardown require completed work and
saved exact witnesses. Failures preserve an existing destination and remove
unpublished temporary objects.

`expected_matches` counts distinct eligible constructions, deduplicating callbacks.
It never selects the first or numbered occurrence. All same-identity sites get
one policy; zero or excess sites fail. A row for an assembly-guarded caller has
zero eligible sites and rejects compilation. Rows and guard removal must therefore
be considered together when constructing a buildable upstream series.

The adapter validates every helper, float and placement row against the C/C++
source basenames under `ps2/src` before filtering for the current unit. Unknown
or misspelled translation units reject the whole profile, including rows for
other units. This closes the earlier silent-discard gap that compiler-side count
checks could not observe. The regression covers all four row families and
checks that the compiler is not started and an existing output is preserved.

## Accepted placement rows

All 34 rows below use allocator `__nw__FUiP1` and exact direct constructors.
The caller spelling is the profile identity. `after/either` means the checked-in
policy is after-inline, but both timings reproduce that caller. Only the three
`after/required` and one `before/required` rows have measured timing necessity.
The table totals 44 sites across 21 units; multiple sites have the same semantic
identity and do not use occurrence selectors.

| Unit | Mangled caller | Allocated type | Sites | Timing |
| --- | --- | --- | ---: | --- |
| dynamicanime | `dynCOLLISION__FP9SPI_STACKi` | `CDAColPipe` | 1 | after/either |
| editeff | `EditSetPlaceAnime__FiP9CMapParts` | `CMapParts` | 1 | after/either |
| editexception | `InitFirePowder__FiP6CSceneiP9mgCMemory` | `mgC3DSprite` | 1 | after/either |
| editmap | `emapMASK_PARTS_NAME__FP9SPI_STACKi` | `CMapPiece` | 1 | after/either |
| editmap | `emapRIVER_PARTS_NAME__FP9SPI_STACKi` | `CMapPiece` | 1 | after/either |
| editmap | `emapWATER_PARTS_NAME__FP9SPI_STACKi` | `CMapPiece` | 1 | after/either |
| editmode | `LoadEditCursor__FP9mgCMemoryi` | `CCharacter2` | 3 | after/either |
| effscript | `AssignCharacter__16CEffectScriptManFP11_EFF_SCRIPTi` | `CCharacter2` | 1 | after/either |
| effscript | `BuildBase__16CEffectScriptManFiP1iP1iP9mgCMemoryi` | `CCharacter2` | 1 | after/either |
| event_func | `_COPY_CHARA__FP12RS_STACKDATAi` | `CCharacter2` | 1 | after/either |
| fishing | `StepDataLoading__FPv` | `CCharacter2` | 7 | after/either |
| fishing | `sgRestartFishing__FP11SubGameInfo` | `CCharacter2` | 1 | after/either |
| funcpoint | `Add__14CFuncPointMngrFiP9mgCMemory` | `CList<CFuncPoint>` | 1 | after/either |
| inventmn | `IsCreateObject__11CMenuInventFii` | `CActionChara` | 2 | after/either |
| inventmn | `LoadCharaCheck__11CMenuInventFv` | `CActionChara` | 1 | after/required |
| map | `AddPartsGroup__4CMapFPcP9CMapPartsP9mgCMemory` | `CList<PartsGroupData>` | 1 | after/either |
| map | `CreateDrawRect__4CMapFP9mgCMemoryP9mgVu0FBOXP9mgVu0FBOXi` | `CList<CMapParts *>` | 1 | after/either |
| mapparts | `AssignFuncAnime__9CMapPartsFP9mgCMemory` | `CList<CObjAnime>` | 1 | after/either |
| mapparts | `Copy__9CMapPartsFR9CMapPartsP9mgCMemory` | `CList<CMapPiece>` | 1 | after/required |
| mdslist | `Copy__9CMapPieceFR9CMapPieceP9mgCMemory` | `CCharacter2` | 1 | after/either |
| mdslist | `CreateChara__FPUiPcP9mgCMemory` | `CCharacter2` | 1 | after/either |
| menuaqua | `SettingAqua__9CAquariumFv` | `CCharacter2` | 1 | after/either |
| menuchr | `KeyStep__12CMosBookMenuFv` | `CActionChara` | 1 | after/either |
| menuchr | `LoadBGNPCModel__15CMenuChrCngMenuFi` | `CActionChara` | 1 | after/either |
| menuchr | `LoadMenuData__15CMenuCostumeSelFP9mgCMemoryPi` | `CActionChara` | 1 | after/either |
| menudraw | `GeneratePoly__14CRepairManagerFPfi` | `CActionChara` | 1 | after/required |
| menuop | `MenuManualInit__FP9mgCMemoryPii` | `CManualMenu` | 1 | after/either |
| menusys | `MenuItemDebugKey__Fv` | `CActionChara` | 1 | after/either |
| menusys | `MenuItemSelectInit__FP9mgCMemoryPii` | `CItemSelect` | 1 | after/either |
| menusys | `MenuModeMalloc__13CMenuItemInfoFP9mgCMemory` | `CActionChara` | 2 | after/either |
| mg_tanime | `NewTexAnimeData__15mgCTextureAnimeFP9mgCMemory` | `CList<mgCTexAnimeData>` | 1 | before/required |
| pbuggy | `sgInitBuggy__FP11SubGameInfo` | `CEffectScriptMan` | 1 | after/either |
| sceneload | `CopyChara__6CSceneFiiP9mgCMemory` | `CCharacter2` | 1 | after/either |
| sceneload | `LoadChara__6CSceneFiPUiPcP9mgCMemoryP9mgCMemoryP9mgCMemoryii` | `CCharacter2` | 1 | after/either |

The exact direct constructor identities for these allocated types are:

| Type | Mangled constructor |
| --- | --- |
| `CActionChara` | `__ct__12CActionCharaFv` |
| `CCharacter2` | `__ct__11CCharacter2Fv` |
| `CDAColPipe` | `__ct__10CDAColPipeFv` |
| `CEffectScriptMan` | `__ct__16CEffectScriptManFv` |
| `CItemSelect` | `__ct__11CItemSelectFv` |
| `CList<CFuncPoint>` | `__ct__19CList<10CFuncPoint>Fv` |
| `CList<CMapParts *>` | `__ct__18CList<P9CMapParts>Fv` |
| `CList<CMapPiece>` | `__ct__17CList<9CMapPiece>Fv` |
| `CList<CObjAnime>` | `__ct__17CList<9CObjAnime>Fv` |
| `CList<PartsGroupData>` | `__ct__23CList<14PartsGroupData>Fv` |
| `CList<mgCTexAnimeData>` | `__ct__24CList<15mgCTexAnimeData>Fv` |
| `CManualMenu` | `__ct__11CManualMenuFv` |
| `CMapParts` | `__ct__9CMapPartsFv` |
| `CMapPiece` | `__ct__9CMapPieceFv` |
| `mgC3DSprite` | `__ct__11mgC3DSpriteFv` |

Changing all rows to after-inline matches 33/34 callers and fails
`NewTexAnimeData`. Changing all to before-inline matches 31/34 and fails
`CMapParts::Copy`, `CMenuInvent::LoadCharaCheck` and
`CRepairManager::GeneratePoly` (146/149 complete units pass). The other 30 are
indifferent. `CMapParts::Copy` constructs template `CList<CMapPiece>` and needs
after-inline, so “before for templates” is contradicted by the accepted source.
The observed consistent policy is after-inline with one mg_tanime exception.

`mg_tanime.cpp` uses `#pragma schedule off`; retail saves `s0` before testing
`v0` with a nop delay slot. This plausibly explains why its timings diverge
while scheduled cases can converge, but no controlled schedule-only experiment
establishes causation. A global setting would need either an explicit justified
per-unit before-inline exception or to leave this one caller guarded. No single
uniform timing is established for all 34.

## Eight additional floating-expression rows

Placement conversion alone is insufficient for five accepted callers. The
floating-expression table grows from 73 to 81 rows using the existing float
capability; no new float mechanism is introduced. Every added row is binary32,
callee-scoped, and has a positive count assertion. Formal slots include implicit
receivers. “Before slot” uses `evaluate_first: false` and `evaluate_before`;
“first” uses `evaluate_first: true`.

| Unit / caller | Mangled callee | IEEE bits / value | Additional selector | Schedule | Count |
| --- | --- | --- | --- | --- | ---: |
| inventmn / `IsCreateObject__11CMenuInventFii` | `SetPosition__11CCharacter2Ffff` | `0x41a00000` / 20.0f | none | before slot 2 | 1 |
| inventmn / `LoadCharaCheck__11CMenuInventFv` | `SetPosition__11CCharacter2Ffff` | `0x41600000` / 14.0f | none | before slot 1 | 2 |
| inventmn / `LoadCharaCheck__11CMenuInventFv` | `SetPosition__11CCharacter2Ffff` | `0xc1e80000` / -29.0f | sibling slot 1 = binary32 `0x41a00000` (20.0f) | before slot 3 | 1 |
| menuaqua / `SettingAqua__9CAquariumFv` | `Initialize__7CBubbleFP9mgCMemoryPfif` | `0x423c0000` / 47.0f | none | first | 1 |
| menuaqua / `SettingAqua__9CAquariumFv` | `SetPosition__9mgCObjectFfff` | `0x423c0000` / 47.0f | none | first | 1 |
| menusys / `MenuItemSelectInit__FP9mgCMemoryPii` | `Set__9mgRect<f>Fffff` | `0x43480000` / 200.0f | none | first | 1 |
| menusys / `MenuItemSelectInit__FP9mgCMemoryPii` | `Set__9mgRect<f>Fffff` | `0x425c0000` / 55.0f | none | before slot 3 | 1 |
| menusys / `MenuItemDebugKey__Fv` | `__ct__15mgCCameraFollowFffff` | `0x00000000` / +0.0f | none | first | 1 |

## Safety tests and artifact acceptance

The genuine pinned-compiler suite passes 13 tests, including eight placement
fixtures covering both timings, selected/unselected callers, repeated identical
objects, duplicate static constructions and excess counts, temporary physical
filenames, wrong overloads, sibling/hidden/nested constructions, indirect inline
factories, ordinary same-type constructor calls, class-0/3 exclusion and stale
eligibility, cleanup-bearing retained bodies, supported empty void returns,
unwitnessed implicit class-6 constructors and request-write failure. Failure
fixtures preserve existing object sentinels and leave no temporary objects.
The production executable ignores the fault-injection variable; the separate
fault-enabled test executable exercises failure publication. The original
acceptance also passes 30 Rust unit/config tests. The adapter suite passes six
tests, including whole-profile source validation. The
legacy integration test requiring an additional genuine MWCC 2.3.3 executable
was not run.

Independent game-source tampering confirms that the override cannot repair
wrong semantics: deleting Add's explicit null return or changing `Alloc(0x20)`
to `Alloc(0x24)` still compiles but fails complete-object comparison. Adding a
second eligible construction fails compilation. Wrong caller, allocator or
constructor, duplicate rows, excess counts, no-construction rows and a row on
still-guarded source also reject compilation. The translation-unit typo previously discarded by adapter filtering now
fails before compilation through the whole-profile check described above.

A clean build independently reproduces `SCES_511.90: OK`, 149/149 complete
resolved objects, and refreshed coverage of **6,783 matched / 82 guarded /
7 assembly-only / 0 fuzzy**, from 6,749 / 113 / 10 / 0 at upstream `63f7a9e5`.
The increase is 31 guarded callers plus three assembly-only callers. Diagnostic
zero scores alone are not counted as promotions. Guards are removed manually,
the whole owning object and resolved relocation targets pass, and PAL verification
and unrelated-object preservation are checked before acceptance.

With all eight added float rows retained, turning placement rows off changes
exactly the 34 named native callers and no other function's bytes or relocations
in the 21 promoted units. The 128 other game units are raw-identical to baseline.
An empty placement profile with the original guards preserves the complete
baseline. The older image rejects the new `placement_new` key even when a current
unit has no rows; adopting the capability requires an image bump for all builds,
including CI.

PAL identity refers to loaded game bytes and verifier layout. Full ELF identity
against retail or upstream is not asserted: native promotions change assembly
markers and symbol metadata, and inherited LOCAL/GLOBAL binding differences
need separate handling. Loaded main/game bytes retain their retail value and memory ends at
`0x01f64a00`; metadata-only corrections can change a whole-ELF hash without
changing that acceptance.

## Alternatives and measured limits

The [natural controls](placement-new-natural-controls-20261008.md) run 44
successful unchanged-funcpoint probes: text prefixes and genuine PCHs, PCH build
state, header ordering, inliner/deferred/depth variants, debug settings, ISO
templates, exceptions and RTTI. None removes the guard difference. Successful
canonical prefix/PCH and several option controls reproduce the whole native
object; outlining and auto-inlining controls change other code and demonstrate
that the options were exercised. Exceptions add tables absent from retail and
break an existing function. These reject the tested configurations as remedies,
not every possible original source form, compiler option or state defect.
Earlier invented helpers, dummy control flow and constructor-semantic changes
remain inadmissible source solutions.

The [global controls](placement-new-global-controls-20261008.md) and
[constructor/header subsets](placement-new-global-subsets-20261008.md) compare
149 successful native draft units per policy, with 6,773 common scored identities
and 6,654 canonical diagnostic zeros:

| Experimental policy | Changed native objects | Previous-zero losses | New guarded zeros |
| --- | ---: | ---: | ---: |
| Broad before-inline during construction | 27 | 1 | 24 |
| Global direct after-inline request | 25 | 0 | 25 |
| Direct before-inline templates only | 3 | 0 | 2 |
| All class-6 constructor inline reads, including ordinary construction | 32 | 13 | 24 |
| Observed header-defined roots, before-inline | 25 | 1 | 23 |
| Observed header-defined roots, after-inline | 23 | 0 | 24 |

Those zeros require matching masked words and relocation offset/type maps and a
body within its retail extent. They do not compare resolved targets, data/helper
ownership or source hygiene and are not complete-object acceptance. The global
after experiment loses no measured zero and is the strongest uniform alternative.
Its header-only variant misses the source-defined `CMapParts` construction.
The template-before result predates native `CMapParts::Copy` and cannot justify
a template-wide timing rule for the final accepted source.

A later [historical hybrid migration](placement-new-global-migration-20261009.md)
omits all 34 placement rows while retaining 81 float rows, applies global
after-inline in 148 units and before-template in mg_tanime, and reproduces all
149 accepted raw game objects and the entire accepted ELF. Its normal wrappers
complete 281 genuine compiler passes; a separate 306-input link passes PAL.
This proves artifact preservation under that mixed diagnostic driver, not one
pure global-after policy or a strict production global engine.

The [paired current-source native comparison](placement-new-current34-native-comparison-20261009.md)
separately completes 298 direct native invocations, preserves all 6,779 scoped
diagnostic zeros among 6,867 common emitted functions, and adds two guarded zeros
with already-rejected helper/dummy scaffolding. All 34 accepted native sections,
sizes, bindings and relocation offset/type maps agree. Fifteen guarded rows
change; some worsen. These two additional zeros remain inactive and are not
included in the 34 promotions.

The historical global driver uses provisional allocator/name filters, excludes
raw `__ct` implicit roots, and lacks production's exact ownership, bounded-region
and completion guarantees. A production global policy must preserve those
structural and transactional checks and define supported allocator ABIs and
implicit-constructor handling. Live root/callee objects can establish global
ownership without demanding a mangled caller/constructor name for every unasserted
root; exact exceptions and count assertions still need unambiguous association.
No such global engine is established by the historical artifact tests.

The maintainer decision remains explicit: adopt the conservative caller activation
rows, or develop a profile-wide after-inline default with one justified mg_tanime
exception (or keep that caller guarded). The evidence supports investigating the
global form. It does not identify a retail global compiler setting or establish
that `schedule off` causes the exception. Dated studies retain their original
measurement boundaries; this note owns the current capability description.
