# Placement-new natural-cause controls, 2026-10-08

No tested natural setting converts the unchanged funcpoint Add allocation guard to retail's A shape. The successful prefix, PCH, and header-order controls reproduce the entire native funcpoint object, including metadata, byte-for-byte. These observations do not establish any uninitialized compiler state or justify an SF state-repair claim.

## Scope and controls

All files created by this subtask are under `.private/pntc/natural/`. No tracked source/header, profile, adapter, image, commit or shared build output was changed by this subtask. The parent owns the whole-tree hook experiment and validation. No network, git fetch/push, promotion, full build, or image operation was run here. Every container entry used the mandated container.sh and image `chronicletwo_dev:sf-63f7a9e`.

The compiler SHA-256 is `0e16a5d6205101f840f85c02664f21cd63b39a0dec2dff417b3a61b4477f0e00`. The input is an unchanged private copy of `ps2/src/funcpoint.cpp`, with `-DUNMATCHING -DNONMATCHING`. Source, all include files and the initial SF profile were snapshotted to avoid interference from subsequent parent edits. Experiments retain the canonical options; their include search path points at the equivalent private snapshot. `exact-canonical-control` separately uses the exact original `-i ps2/include` and `MWCIncludes=ps2/include/std;ps2/include/sce` options and produces the same whole object.

The baseline has 33/34 matching native functions. Add is 0xA0 bytes, differs by two masked words at +0x34/+0x38, and has matching relocation kinds. Its guard is `move s0,v0; beqz s0`, rather than retail's `beqz v0; move s0,v0`. The baseline whole-object SHA-256 is:

`89c2be66e62b3be71a97a250d74fc5907f724bdb0b752635d19d12545c92448e`

The plain-wibo control, SF control and exact canonical-path control all have that exact hash. Full function inventories retain raw section bytes and relocation identities; target scores use the repository's relocation masks and retail image. These are native draft comparisons, not complete linked-unit acceptance checks.

## Inliner settings

Every successful control retains Add's B allocation guard, including those with additional body changes.

| Setting | Add result | Existing baseline matches lost |
| --- | --- | --- |
| `-inline on`, `smart`, `noauto`, `level=0,2,3,4,8` | Same 2/40 and same whole object | 0 |
| `#pragma inline_depth(4)` / `(8)`; `#pragma auto_inline off` | Same 2/40 and same whole object | 0 |
| `-inline deferred` | Same 2/40; three other inventory entries differ | 0 |
| `-inline level=1`; `#pragma inline_depth(1)` | 3/40; outlines CFuncPoint member construction | 2 |
| `-inline off`; `#pragma inline_depth(0)` | 27/40, 0x8C body; outlines list construction | 5 |
| `-inline auto`, `all`; `#pragma auto_inline on` | B guard remains; body grows to 0xEC | 12 |
| `-inline deferred,auto` | B guard remains; body grows to 0xEC | 14 |

The negative controls that outline construction or auto-inline other helpers prove the switches are active. No source condition, buffer spelling, constructor-loop substitution, helper, or previous E01-E37 source form was replayed. The explicitly requested compiler-option controls are measured on the current source snapshot.

## Prefix and precompiled headers

The text prefix contains all original funcpoint includes. Both the full unchanged source and a body-only source compile to the baseline whole-object hash with `-prefix`.

A real 375,600-byte PCH, built with `-precompile`, loaded through `-prefix`, has the same outcome for both the full unchanged source and the body-only source. Body-only successful compilation verifies that the declarations were actually supplied by the prefix.

`#pragma precompile_target` also works when compiling a `.pch` input in the private directory with a bare output basename. This produced a 375,912-byte PCH, and its loaded funcpoint object has the same baseline whole-object hash. `pragma-final-result.json` records the actual builder command, working directory, file size and successful object comparison.

PCHs independently built with `-inline deferred`, `-inline auto`, `-g`, `#pragma inline_depth(0)`, exceptions on, or ISO templates on, then consumed by the canonical source compilation, each reproduce that exact whole-object hash. These controls show no inherited setting that changes allocation binding for this prefix and current types.

A minimal ordinary-class specimen provides a positive distinction independent of templates: PNClass6 has two straight-line link clears; PNClass3 clears the same links in a real two-element loop. Both construct an out-of-line PNData member, install a vptr, invoke virtual initialization, and retain the original object across a subsequent call. New6 gives B (`move s0,v0; beqz s0`); New3 gives A (`beqz v0; move s0,v0`). Text-prefix and PCH-prefix builds preserve every function's bytes and relocation identities. The classifier values follow the independently recovered rule in placement-new.md; no new debugger classification trace was claimed for this subtask.

Initial long absolute `-prefix` names were truncated by MWCC; initial absolute `-precompile` output names failed with OSErr -43. wibo can report exit zero for some of these compiler errors, so the probes also require the expected output file. Successful tests use short relative prefix names and an existing private output directory. Empty `-precompile` argument and header-extension experiments failed before the final supported `.pch`/bare-name pragma control. An attempted PCH containing initialized global fixture objects is rejected as "illegal use of precompiled header"; it is not a code-generation result. All these failed attempts remain logged.

Receipts: `prefix-short-run.log`, `prefix-pch-short/precompile-result.json`, `prefix-pch-short-{full,body}/`, `prefix-pragma-final/`, `pragma-final-{run.log,result.json}`, `pch-states-run.log`, `pch-{defer,auto,debug,depth0,except,iso}/`, `pch-state-*/`, `specimen-results.json`, and `specimen-ordinary/{text,pch}-objdump.txt`.

## Header order and other flags

Reversing or alphabetizing the game-header include list, or adding mg_tanime.hpp or mapload.hpp before funcpoint.hpp, leaves the entire object at the baseline hash.

`-g` and `-sym on` change object debugging metadata but leave every function's bytes/relocations and Add's B guard unchanged. `-iso_templates on` leaves the entire object unchanged. RTTI on leaves Add and all existing function text unchanged but adds RTTI data and changes the whole object.

## Retail build-state side evidence

Exceptions on, both with ordinary and deferred inlining, leave Add at 2/40 and B. They add allocated `.exceptix`/`.exception` sections and lose the existing match for `Step__14CFuncPointMngrFiP15CFuncPointCheck`. Retail's actual ELF has:

- `__exception_table_start__ = 0x0037C6F0`
- `__exception_table_end__ = 0x0037C6F0`

The linked exception table is empty despite the runtime exception support functions existing in the binary. This supports the current disabled-exceptions setting; merely finding runtime support would not establish enabled game-unit exceptions. A hypothetical linker that deliberately omits tables cannot be excluded by table symbols alone, but the identical-source exceptions-on controls still fail to repair the target and break an existing text match.

Retail has five RTTI symbol entries, all for standard-library exception/bad_alloc/bad_exception types. RTTI-on funcpoint emits two additional game-type descriptors. This supports the current RTTI-off game setting and gives no allocation-binding explanation.

Receipts: `exceptions-{on,on-deferred}/`, `exceptions-side-evidence.json`, `rtti-side-evidence.json`, `extra-run.log`, and `final-controls.log`.

## What remains open

These controls rule out the tested PCH/prefix configurations, inliner options, header orderings, debug settings, ISO template setting, exceptions and RTTI switches as a remedy for unchanged funcpoint Add. They do not rule out a different original constructor/source structure, an untested compiler option, a different compiler image, a different prefix containing additional real declarations/definitions, or a presently unobserved compiler-state defect. The PCH specimen's unchanged A/B distinction supports the existing statement-vs-expression inline explanation rather than a PCH serialization defect.

No symbol was promoted, no own image tag was built, and no full-tree acceptance claim is made here. `results.json` is the complete structured experiment inventory with commands, exit/output receipts, per-function scores, changed function identities, and lost baseline matches. `run.py` and the small companion drivers reproduce the controls within this private directory.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
