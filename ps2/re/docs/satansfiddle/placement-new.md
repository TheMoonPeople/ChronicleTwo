# Scalar placement-new statement conversion

The placement-new capability requests MWCC's own statement-conversion path for
selected scalar constructions. It is an explicit frontend policy override, not
a repair of uninitialized compiler state. The checked-in profile activates 37
callers in 24 units; each is native, byte-identical to retail, and its unit
passes the complete object check. The caller rows are an activation list for
those matches; they do not recover one original global compiler policy.

## Compiler mechanism and boundary

The supported compiler is MWCC 3.0-011126. Satan's Fiddle verifies the
executable's SHA-256 before installing any hook; the placement patch
additionally requires the profile's `compiler_version` to be `3.0-011126` and
checks eleven guest opcode signatures at the addresses it hooks. Those
addresses identify operations in the hash-pinned compiler; none is a profile
selector.

Inline metadata and the conversion-request flag are initialized by the
compiler. An eligible constructor's classifier at `0x465030` starts at class 6
for expression inlining. Retained control statements, nonfinal returns, or
cleanup metadata select class 3 for statement inlining; some signatures return
class 0 and cannot be inlined. A class-3 inline callee can also request
conversion inside an outer class-6 constructor. Ordinary calls, locals and
final returns alone do not force class 3.

Early construction conversion at `0x463bf0` puts the allocator assignment
inside the null condition. Late IroLinearForm at `0x4c2d8a` emits an
assignment followed by a test of the saved object temporary. These are
distinct value dependencies before coloring or delay-slot scheduling. In the
common near miss, early form allows `beqz v0` followed by the saved-pointer
copy in the delay slot; late form copies first and tests the saved register.
The texture-animation caller has a separate success-only result lifetime and
compiles with scheduling disabled.

`after_constructor_inline` leaves normal expression inlining intact, then
writes one byte to the frontend's statement-conversion request at `0x54d6f8`.
MWCC natively sets that byte on its class-3 path at `0x462fd3`, clears it per
statement at `0x464b70`, and tests it at `0x464b8d` before ordinary
re-lowering through `0x463ef0`. `before_constructor_inline` instead
reclassifies the current root constructor read as class 3 by changing the
inline classifier's returned low EAX byte from 6 to 3 at `0x462fa3`; MWCC then
statement-inlines the constructor body and sets the request itself. Neither
mode changes stored constructor metadata, emitted instructions, allocator
values, or optimizer operands. All MIPS, symbols and relocations are emitted
by MWCC's normal passes. The
[placement patch](../../../../scripts/build/patches/satansfiddle-placement-new.patch)
writes no instruction bytes.

## Retail census

All direct scalar `__nw__FUiP1` calls in the top-level PAL game units number
216 sites in 116 callers. This is `operator new(size_t, u_long128 *)`; its
retail body at `0x00139F50` returns the supplied buffer. Arrays
(`__nwa__FUiP1`), ordinary heap allocation and SDK/runtime units are excluded.
Of these calls, 178 construct nontrivial objects, 21 explicitly call the
allocator and initialize afterwards, and 17 construct trivial scalars. Those
last 38 do not establish implicit constructor-null-check behavior.

| Nontrivial scalar construction | Guard tests allocator result v0 (A) | Guard tests copied register (B) |
| --- | ---: | ---: |
| Inline constructor | 108 | 0 |
| Out-of-line constructor | 68 | 2 |

The two B sites are the matched `mapFIX_CAMERA_RECT` allocations of
`CColFrame` and `CCollision` under scoped `inline_depth(0)`. They are not
inline-class-6 counterexamples. Runtime classification is observed for 91 of
the 108 inline sites: 74 class 6 and 17 class 3. The other 17 are unmeasured;
most are implicit or synthesized constructors (for example
`SAVE_CONVERT_WORK`, `CRedMarkModel`, `CTreasureBoxManager`, `CMonsterMan`,
`CRepairManager` and `mgCShadowMDT`), which expose no named root constructor
read. The raw instruction-pattern scan's
196 A / 2 B / 16 no-branch / 2 other count includes explicit checks and trivial
objects and must not replace the constructor-specific table.

Natural matched class-6/A examples exist, such as `CreateCollisionMDT`, whose
guard is `beqz v0` with a stack spill in the delay slot. Pointer lifetime and
register pressure can produce A without forcing early conversion. The census
therefore establishes a widespread retail pattern, not a proof of a missing
compiler option, identical original source, or a compiler-state defect.

## Natural-cause controls

No tested natural setting converts the unchanged `CFuncPointMngr::Add`
allocation guard from `move s0,v0; beqz s0` to retail's `beqz v0; move s0,v0`.
The controls compile the unchanged funcpoint source and compare the whole
native object:

- Inliner settings: `-inline on`, `smart`, `noauto`, `level=0,2,3,4,8`,
  `#pragma inline_depth(4)`/`(8)` and `#pragma auto_inline off` give the same
  whole object. `-inline deferred` changes three other functions and keeps the
  guard. `-inline level=1` and `inline_depth(1)` outline the member
  construction; `-inline off` and `inline_depth(0)` outline the list
  construction; `auto`, `all` and `auto_inline on` grow the body to 0xEC. Every
  variant keeps the B guard, and the negative controls prove the switches are
  active.
- Text prefixes and genuine precompiled headers, including PCHs built with
  deferred inlining, auto inlining, `-g`, `inline_depth(0)`, exceptions or ISO
  templates, reproduce the baseline object byte for byte.
- Header order (reversed, alphabetized, or with `mg_tanime.hpp` or
  `mapload.hpp` first), `-g`, `-sym on` and `-iso_templates on` leave every
  function's bytes and relocations unchanged. RTTI adds descriptors and
  changes nothing else.
- Exceptions add `.exceptix`/`.exception` sections absent from retail and
  break the existing `CFuncPointMngr::Step` match. Retail's
  `__exception_table_start__` and `__exception_table_end__` are both
  `0x0037C6F0`, so its game units compile with exceptions off. Retail's five
  RTTI entries are all standard-library exception types.

A minimal specimen separates the two classes without templates: a constructor
with two straight-line link clears is class 6 and gives B; the same clears in a
real two-element loop are class 3 and give A. These controls rule out the
tested options as a remedy, not every possible original source form or an
untested option.

## Semantic rows and safety

`placement_new.statement_conversions` rows require the logical translation
unit, exact mangled caller, exact scalar allocator, direct constructor,
conversion timing, and positive `expected_matches`. The constructor identifies
the allocated type. The adapter retains the logical source name across
mwccgap's temporary second-pass input and source-only objdiff builds. An empty
table installs no placement hooks.

Only direct scalar roots with original expression-inline class 6 are eligible.
Class 0/3 sites, arrays, ordinary same-type constructor calls and base/member
inline reads are outside the operation. Raw names can provisionally nominate a
row, but cached names or the compiler's ordinary mangler return must supply
exact caller, allocator and constructor witnesses before publication. Wrong
overloads, ambiguous raw associations and unwitnessed implicit constructors
fail closed. The captured call node and live constructor object must agree at
the actual inline-info read.

Conversion affects its enclosing expression. Exactly one construction is
permitted in that verified statement region; hidden, nested or sibling
constructions and shared construction-bearing subtrees reject. Retained inline
callee bodies are audited for deferred constructions and cleanup metadata, and
exactly one ordinary lowering visit to the selected node is observed.
Unsupported indirect calls, graphs, body forms and bounds reject
conservatively. A metadata-free empty void return has a verified supported
path. Arena epochs prevent reused compiler pointers from inheriting records;
resets and teardown require completed work and saved exact witnesses. Failures
preserve an existing destination and remove unpublished temporary objects.

`expected_matches` counts distinct eligible constructions, deduplicating
callbacks. It never selects the first or numbered occurrence. All
same-identity sites get one policy; zero or excess sites fail. A row for an
assembly-guarded caller has zero eligible sites and rejects compilation, so
rows and guard removal belong in the same buildable change.

The adapter validates every helper, float and placement row against the C/C++
source basenames under `ps2/src` before filtering for the current unit. An
unknown or misspelled translation unit rejects the whole profile, including
rows for other units, before the compiler is started.

## Accepted placement rows

All 37 rows use allocator `__nw__FUiP1` and exact direct constructors. The
caller spelling is the profile identity. The table totals 47 sites across 24
units; multiple sites in one caller have the same semantic identity and need no
occurrence selectors. `after/either` means the checked-in policy is
after-inline and both timings reproduce the caller; `required` rows match
under only that timing.

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
| menushop | `MenuNPCQuestViewInit__FP9mgCMemoryPii` | `CMenuQuestView` | 1 | after |
| mg_tanime | `NewTexAnimeData__15mgCTextureAnimeFP9mgCMemory` | `CList<mgCTexAnimeData>` | 1 | before/required |
| mg_visual | `Copy__15mgCVisualFixMDTFP9mgCMemory` | `mgCVisualFixMDT` | 1 | after/either |
| pbuggy | `sgInitBuggy__FP11SubGameInfo` | `CEffectScriptMan` | 1 | after/either |
| sceneload | `CopyChara__6CSceneFiiP9mgCMemory` | `CCharacter2` | 1 | after/either |
| sceneload | `LoadChara__6CSceneFiPUiPcP9mgCMemoryP9mgCMemoryP9mgCMemoryii` | `CCharacter2` | 1 | after/either |
| visualmotion | `Copy__18mgCVisualMotionMDTFP9mgCMemory` | `mgCVisualMotionMDT` | 1 | after/either |

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
| `CMenuQuestView` | `__ct__14CMenuQuestViewFv` |
| `CMapParts` | `__ct__9CMapPartsFv` |
| `CMapPiece` | `__ct__9CMapPieceFv` |
| `mgC3DSprite` | `__ct__11mgC3DSpriteFv` |
| `mgCVisualFixMDT` | `__ct__15mgCVisualFixMDTFv` |
| `mgCVisualMotionMDT` | `__ct__18mgCVisualMotionMDTFv` |

`CMenuQuestView` has a genuine empty inline constructor that emits only base
construction and the derived vtable assignment. It supplies a named eligible
root that the implicit constructor lacks; its current row and exact unit
verification are documented in [menushop notes](../menushop/notes.md#quest-view-placement-construction).
The timing studies below describe the original 36-row calibration set.

## Timing study

Setting every row to after-inline matches every caller except
`mgCTextureAnime::NewTexAnimeData`. Setting every row to before-inline fails
`CMapParts::Copy`, `CMenuInvent::LoadCharaCheck` and
`CRepairManager::GeneratePoly`. The other 32 callers match under either
timing. `CMapParts::Copy` constructs the template `CList<CMapPiece>` and needs
after-inline, so a "before for templates" rule is contradicted by the accepted
source. The consistent policy is after-inline with one mg_tanime exception.

`mg_tanime.cpp` uses `#pragma schedule off`; retail saves `s0` before testing
`v0` with a nop delay slot. This plausibly explains why its timings diverge
while scheduled cases converge, but no schedule-only experiment establishes
causation. A profile-wide after-inline default would need either an explicit
per-unit before-inline exception for this caller or to leave it guarded.

## Accompanying floating-expression rows

Placement conversion alone is insufficient for five of the callers. Eight
floating-expression rows accompany them, using the existing float capability;
no new float mechanism is introduced. Every row is binary32, callee-scoped,
and asserts a positive count. Formal slots include implicit receivers.
"Before slot" uses `evaluate_first: false` and `evaluate_before`; "first" uses
`evaluate_first: true`.

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

## Tests and acceptance

The patch's genuine-compiler placement fixtures cover both timings,
selected and unselected callers, repeated identical objects, duplicate static
constructions and excess counts, temporary physical filenames, wrong overloads,
sibling/hidden/nested constructions, indirect inline factories, ordinary
same-type constructor calls, class-0/3 exclusion and stale eligibility,
cleanup-bearing retained bodies, supported empty void returns, unwitnessed
implicit class-6 constructors and request-write failure. Failure fixtures
preserve existing object sentinels and leave no temporary objects. The
production executable ignores the fault-injection variable; a separate
fault-enabled test executable exercises failure publication. The adapter suite
covers whole-profile source validation. These fixtures run only with the
genuine compiler mounted, as described in
[the integration notes](../../../../scripts/build/SATANSFIDDLE.md).

Game-source tampering confirms that the override cannot repair wrong
semantics: deleting `Add`'s explicit null return or changing `Alloc(0x20)` to
`Alloc(0x24)` still compiles but fails the complete-object comparison. Adding a
second eligible construction fails compilation. Wrong caller, allocator or
constructor, duplicate rows, excess counts, no-construction rows, a row on
still-guarded source and a misspelled translation unit all reject compilation.

With all eight float rows retained, turning the placement rows off changes
exactly the 36 named callers, the generated `mgCVisualMDT` assignment that
`mg_visual` emits, and no other function's bytes or relocations in the 23
units. The other 126 game units are raw-identical with or without the rows. An
empty placement profile with the original guards reproduces the pre-row
baseline. An image without the patch rejects the `placement_new` key even when
the current unit has no rows, so the capability requires the image built from
the Dockerfile, including in CI.

PAL identity refers to loaded game bytes and verifier layout. Full ELF identity
against retail is not asserted: native matches change assembly markers and
symbol metadata, and inherited LOCAL/GLOBAL binding differences need separate
handling. Loaded main/game bytes retain their retail value and memory ends at
`0x01f64a00`.

## Global-policy controls

Six experimental global policies, applied to all 149 units compiled with their
drafts enabled, give the following native diagnostic results against 6,773
common scored identities, of which 6,654 are canonical diagnostic zeros:

| Experimental policy | Changed native objects | Previous-zero losses | New guarded zeros |
| --- | ---: | ---: | ---: |
| Broad before-inline during construction | 27 | 1 | 24 |
| Global direct after-inline request | 25 | 0 | 25 |
| Direct before-inline, templates only | 3 | 0 | 2 |
| All class-6 constructor inline reads, including ordinary construction | 32 | 13 | 24 |
| Observed header-defined roots, before-inline | 25 | 1 | 23 |
| Observed header-defined roots, after-inline | 23 | 0 | 24 |

A diagnostic zero requires matching masked words, equal relocation offset/type
maps and a body within its retail extent. It does not compare resolved
targets, data/helper ownership or source hygiene and is not complete-object
acceptance. The broad before-inline policy regresses the native
`InitDungeonMain`; the all-constructors policy regresses thirteen matched
functions, `InitDungeonMain` among them, because it also changes ordinary
member and base construction. The global after-inline request loses no measured zero and is
the strongest uniform alternative. Its header-only variant misses the
source-defined `CMapParts` construction. Forcing a constructor's inline class
and requesting enclosing-expression conversion are observably different
policies: in those draft comparisons, only the former zeros `NewTexAnimeData`,
and only the latter zeros `MenuInventInit` and `GeneratePoly`.

A hybrid driver that omits the placement rows, keeps the float rows, applies
global after-inline in 148 units and before-template conversion in mg_tanime
reproduces all accepted game objects and the accepted executable byte for
byte. A paired comparison of that hybrid against the scoped rows over the
current source preserves every scoped diagnostic zero and adds two guarded
zeros, `MenuInventInit` and `_ESM_INITIALIZE`. `_ESM_INITIALIZE` is native
without a row: writing its allocation size with the statement-inlined
`align16_blocks` gives retail's `beqz v0` test (see
[event_func notes](../event_func/notes.md)). The `MenuInventInit` draft used
for that census retained rejected helper and dummy scaffolding. The hybrid driver
uses provisional allocator and name filters, excludes raw `__ct` implicit
roots, and lacks production's exact ownership, bounded-region and completion
guarantees. A production global policy would need those checks, supported
allocator ABIs and defined implicit-constructor handling.

`MenuInventInit` now matches with natural source and the existing scoped
profile, without an added placement row. Its allocations use the established
`align16_blocks(sizeof(T)) + 2` form; size-first snapshots through the inline
byte-buffer member getter restore its saved registers. `IsAccessAlbum` also
uses that allocation form without a new row. See
[the inventory source forms](../inventmn/notes.md) for the member accessors and
local declaration order needed by those functions.

The design choice is therefore explicit: the conservative caller activation
rows above, or a profile-wide after-inline default with one justified
mg_tanime exception (or that caller left guarded). The evidence supports
investigating the global form; it does not identify a retail global compiler
setting or establish that `schedule off` causes the exception.
