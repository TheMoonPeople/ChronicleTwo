# MotionMDT Copy natural derived assignment and paired FixMDT follow-up, pn15

Complete-unit validation establishes natural C++ zeros for
`Copy__18mgCVisualMotionMDTFP9mgCMemory` (0x28E930, actual body and extent
0x210) and `Copy__15mgCVisualFixMDTFP9mgCMemory` (0x141260, actual body and
extent 0x190). Both callers invoke their actual implicitly generated derived
assignment with `*copy = *this`. Their shared MDT assignment is naturally
generated, has retail's exact raw 0x98 bytes and processor-coalesced binding
13, and survives the complete wrapper in its actual `mg_visual` owning unit.
The shared header change, both callers and their rows are applied; the final
impact section records the whole-game checks.

## Existing notes and actual dependency semantics

All owning visualmotion, mg_visual and mg_dataset notes were read first,
including the prior FixMDT study, and relevant mg_frame, mg_memory,
mg_drawenv, mg_math and mg_shadow dependency notes/types were reviewed.
Fresh mandatory `./decompile.sh Copy__18mgCVisualMotionMDTFP9mgCMemory`
used the existing current31 context under pn15; `copy-m2c.txt/.log` preserve
that output. No context/full build was generated in this lane.

The old visualmotion note's material-loop 100% statement does not establish a
natural compiled Copy body: the caller was then assembly-only. Its real
constructor chain is Visual -> MDT -> FixMDT -> MotionMDT, with each existing
inline constructor calling its own Initialize. The 0x110 Motion object has
the documented 0x50 MDT/Fix base, frame pointer at 0x50, frame id at 0x54,
base matrix at 0x58, real aligned `mgVu0FBOX` at 0x60, actual `bone[32]`
at 0x80, weight count at 0x100 and weight pointer at 0x104. Padding at
0x5C and 0x108..0x10F is not a game member to copy explicitly.

The retail member sequence calls MDT assignment, copies frame/id/matrix,
calls the real nonconst `mgVu0FBOX::operator=`, copies the actual bone array,
then shares the weight count/pointer. This supports naturally invoking the
derived generated assignment. No special member is implemented manually.
The genuine user-declared FBOX assignment is a separate dependency, not a
compiler-generated member; its actual 0x18 body lies in a 0x20 layout extent.

Copy reserves `sizeof(mgCVisualMotionMDT) / 16 + 2` memory blocks for the
object. For a positive live material count, its unsigned byte count is
rounded upward to 16-byte blocks in the actual two branches, then two
reserved blocks are added. Indexed assignment of each real `mgMaterial`
copies its eight float components and texture pointer; padding is not
copied manually. Geometry, primitive/frame/matrix pointers and weight data
remain shared, while materials have separate storage. The material count
and both real array pointers remain live. No float selector, argument-order
change, raw walk, invented aggregate view, helper or dummy lifetime is used.

The unused MotionColor and MotionWeightSlots declarations adjacent to the
former assembly gap are removed. Each name occurred only in its
own declaration. Cleaned and uncleared native objects are proven whole-file
identical for both the inherited-header and implicit-MDT controls.

## Actual scalar-root identities and private controls

Read-only normal compiler observation proves exactly one scalar class-6
root per caller. Actual cached normal identities and actual normal mangler
returns supply these tuples:

| Logical TU | Caller | Constructor | Allocator | Exact count |
| --- | --- | --- | --- | --- |
| visualmotion.cpp | Copy__18mgCVisualMotionMDTFP9mgCMemory | __ct__18mgCVisualMotionMDTFv | __nw__FUiP1 | 1 |
| mg_visual.cpp | Copy__15mgCVisualFixMDTFP9mgCMemory | __ct__15mgCVisualFixMDTFv | __nw__FUiP1 | 1 |

The original and cleaned implicit Motion observations, and a fresh normal
Fix observation of the derived-assignment source, all calibrate selected
bytes, sizes, binding, value and named relocations to their corresponding
row-absent native controls. No guest memory write, guessed identity or
manual mangler call occurs. Three hook visits to each actual POD material
array expression describe one nondirect array constructor shape; they are
preserved separately and do not count as scalar roots. Exact semantic rows
use `after_constructor_inline` and `expected_matches: 1`; every selected
compile reports actual 1, including both production-wrapper passes.

| Genuine native control | Copy words | Body size | MDT assignment |
| --- | ---: | ---: | --- |
| Motion derived assignment, captured31/no new row | 2 | 0x210 | inherited external manual dependency |
| Motion exact after row | 0 | 0x210 | inherited external manual dependency |
| Motion exact before row | 0 | 0x210 | inherited external manual dependency |
| Motion exact after, private implicit MDT header | 0 | 0x210 | naturally emitted 0x98, binding13 |
| Motion cleaned views, inherited header, exact after | 0 | 0x210 | inherited external manual dependency |
| Motion cleaned views, implicit header, exact after | 0 | 0x210 | naturally emitted 0x98, binding13 |
| Motion cleaned views, implicit header, no new row | 2 | 0x210 | naturally emitted 0x98, binding13 |
| Fix derived assignment, implicit header/body cleanup, no new row | 2 | 0x190 | naturally emitted 0x98, binding13 |
| Fix same natural derived source, exact after row | 0 | 0x190 | naturally emitted 0x98, binding13 |

Two separate unchanged assembly-only native TU controls make eleven native
cases in total. Motion before/after raw objects are identical, beyond equal
scores. For each final implicit source, the row-absent versus exact-after
objects differ and exactly two actual selected instruction words change;
normalized target identities and all other native bytes are preserved.

## Derived assignment resolves the earlier base-assignment blocker

The `mg_visual/placement-new-copy-natural-20261009.md` study keeps its
original measurements. That earlier natural explicit MDT-base
assignment cleanup scored 97 words / 0x218 and emitted no MDT assignment.
Its isolated zero relied on the inherited handwritten GLOBAL1 assignment.
The new derived invocation is a distinct, supported source boundary.
Motion's actual derived member sequence first demonstrated that default
compiler settings naturally emit the MDT base assignment. One new genuine
Fix-derived candidate then demonstrated the same behavior. No depth,
noinline, outlining, special compiler capability or redundant helper/local
was added; no documented explicit-base negative was replayed.

The shared change removes the handwritten MDT assignment declaration
from mg_visual.hpp and its eighteen-member manual definition from
mg_visual.cpp. Both Copy callers then use their implicit derived assignment.
No assignment INCLUDE_ASM fallback is needed in the final source:
the actual generated member provides the owning definition naturally.
Native body, symbol size and retail raw body are all 0x98; extent0xA0
includes eight bytes of retail zero alignment padding. It copies seven
Visual words and eleven MDT words while leaving the vptr and padding alone.

## Full native and complete-wrapper audits

The strongest native Motion case has 21 functions, 26 allocated sections
and 20 owning-unit manifest scores: the extra MDT definition belongs to
mg_visual's manifest. All 19 original Motion functions/relocations/scores
and all 24 original allocated sections, including its five data sections,
are exact. The strongest Fix case has 41 functions/scores and 47 sections;
all 39 functions other than the dependency assignment, their scores and
45 other sections, including six data sections, remain exact. The old
manual MDT body is raw-byte equal to its generated replacement; only its
binding changes from GLOBAL1 to actual processor-coalesced13. Native named
nonselected types, sizes, bindings, values and undefined states are stable.
No anonymous suffix alias mapping is required.

All 14 Motion and 11 Fix Copy relocation offset/type maps and actual named
target values match retail. Copy definitions have actual GLOBAL1 binding.
The actual Motion table at 0x37C260 has size0x50 and all18 exact targets;
the actual Fix table at 0x37B3B0 has size0x48 and all 16 exact targets. Each
consumes its Copy at slot0x18. The complete wrappers additionally prove
every target of all four present tables: 43 mg_visual targets and18 Motion
targets, with exact payload, padding, addresses and binding.

| Exact complete private wrapper | Functions | Allocated sections | Checked bytes | Checked relocations | Errors |
| --- | ---: | ---: | ---: | ---: | ---: |
| mg_visual | 42 | 63 | 12108 | 200 | 0 |
| visualmotion | 20 | 27 | 6652 | 101 | 0 |

Fresh complete-wrapper controls prove all40 other mg_visual functions and
all19 other Motion functions retain exact raw bodies, named relocations,
sizes, values, bindings and scores. All other allocated payloads, targets,
alignment, flags and owner bindings remain equal. The strict complete retail
checker verifies both entire objects. The inherited SendDMA assembly piece
has zero differing instruction words but its absolute operand differs from
the retail relocation-map annotation; that exact score/map is unchanged
between control and proposed wrappers and does not cause a retail check
error. It was not reanalyzed or changed.

Expected generated-symbol metadata changes are recorded explicitly. Standard
postprocess maps native coalesced13 to ELF WEAK2, retains the generated MDT
body in mg_visual and discards Motion's foreign definition, leaving its
real weak undefined reference. Generated constructor vtable references
gain OBJECT types and actual sizes: Visual0x34, MDT0x48 and Fix0x48. Their
bindings, values, undefined states and target addresses remain unchanged.
An undefined GLOBAL1 Visual table reference is unchanged; the actual retail
Visual definition is coalesced13 in its separate owning unit. In mg_visual,
the MDT table's symbol size becomes actual0x48 rather than placeholder
extent0x50; its section is still0x50 with identical bytes and targets.
Thus whole raw objects and all symbol metadata are not claimed identical.

## Incidental actual symbol sizes and scope

The symbol receipt proves Motion Iam0x8 versus annotated/padded0x10,
CreateBBox0x2B8 versus0x2C0, CreateExtRenderInfoPacket0x1EC versus0x1F0,
and CreateFaceMotionPacket0x58C versus0x590. FBOX assignment is0x18 versus
0x20. Comment-only owning-header proposals recording these body/extent
distinctions are separate from this change. mgVertexWeight constructor's
actual size0x30 already agrees with the header. Motion Iam's inherited native GLOBAL1
versus actual coalesced13 is preserved; the Copy zero does not establish
actual binding identity for that unchanged incidental function.

All experiments use the coherent captured31 profile SHA256
f3632b6c81415c7438efe23defeafc9cd6681f789574165132ae1b88a19f1fa3,
canonical flags, real logical TU identities and pn15. Motion's thirteen
float/one argument constants and Fix's six float/one argument constants
remain unchanged; zero literal aliases are used. Root advanced to33 callers
while the lane ran. The exact two-row delta is independently mergeable;
an additional current33+pair35 profile preserves every current row.
All captured source/header hashes still match live files at final audit.

Frozen artifacts kept outside the repository include a summary, type audit,
command log, pair manifest, artifact manifest, normal witness/calibration
receipts, all eleven native controls, complete baseline and proposed unit
wrappers, full target/data/binding/size audits, and exact paired
source/header/row proposals. The initial wrapper setup omitted the read-only
ROM link; its failed logs remain and corrected wrapper directories are
explicitly named `*-rom-input`. This study made no full build, tracked header
edit, commit, profile activation, network write or reserved dungeon inspection,
and no generated member is hand-authored.

Root independently verifies all 263 native receipt-manifest files and all 16
exact frozen pair artifacts. The combined proposal was one patch for both
callers and the header plus a separate two-row delta.

## Complete wrapper and PAL impact

The separate impact stages now pass all 149 canonical wrappers and complete
object checks against accepted33, preserving all 147 outside raw objects.
Private35 links and verifies every retail section and memory extent against
the actual immutable accepted33 executable. The accepted34 compatibility
extension compiles only mapparts: its whole object remains raw-identical,
including the newly promoted Copy body. Private36 reuses the other 148 game
objects and same 157 SDK/runtime/data objects, then passes link/PAL checks
against the actual accepted34 executable.

Both linked candidates retain exact game bytes and all 98,516 named linked
relocation tuples. The generated assignment binding, actual MDT table size
and compiler attribute ownership differences remain explicitly recorded;
whole ELF identity is not claimed. Root independently verifies all 1,932
regular frozen files. A joint impact study kept outside the repository holds
the distinct baselines, composite 36-row/46-site evidence and receipts.

With the header change, both callers and their two rows applied, the full build
links `SCES_511.90` with PAL bytes matching retail and all 149 game objects
pass `check_objects.py`. Only the `mg_visual` and `visualmotion` objects differ
from the build without the change. The linked game segment keeps SHA256
`a103b0461a88e443a3af684cf150c05b5bd355e5a97ab2dc029c4d872bed0811`; the ELF
symbol tables differ only in the MDT assignment's WEAK binding, the MDT table's
0x48 symbol size and the compiler attribute section names of the two Copy
functions and the assignment.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
