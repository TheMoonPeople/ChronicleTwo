# Natural costume initializer and constructor proposal

`MenuCostumeInit__FP9mgCMemoryPii` reaches a private natural pn15 zero with
a corrected `CMenuCostumeSel` constructor and one existing floating argument
policy. It remains guarded in the production source: the owning header is
outside this lane's edit scope. Exact header/source/profile proposals are
saved for the coordinator; no complete object or PAL promotion is claimed.

All eleven existing menuchr notes, relevant memory/camera/menu/user-data
declarations, MWCC guidance and earlier placement controls were consulted
before the fresh mandated m2c analysis. The three previously accepted
menuchr callers remain exact. This analysis does not reopen their behavior
or repeat the old global placement and unrelated drawing controls.

## Constructor behavior and source boundary

`CMenuCostumeSel` is 0x2d0, comprising the 0x110 base menu, 0xc0 follow
camera, real selection/list arrays, 0x30 memory manager and character status
pointer. Its allocation reserves 0x2f manager quadwords. No field layout,
array dimension, vtable or generated special member is changed.

Retail resets the source-owned `MenuCosutumeLoadPhase` and obtains Max's
character data inside the successful constructor guard. The inherited caller
performs both operations after construction, outside that guard. The actual
constructor clears three costume selections and three line-wave values,
then clears the real `costume_list[3][8]` by column: rows zero, one and two
for each of eight columns. The ordinary typed loop unrolls to the observed
24 halfword stores. Retail does not contain the inherited constructor's
extra costume-count or cursor-coordinate/wave initialization.

The exact proposal moves this existing user-declared constructor from its
guarded header body to an out-of-class inline definition immediately before
its sole allocation caller, following the unit's existing constructor style.
The owning header receives a documented declaration. This lets the real
source-owned phase operation remain in its source unit; no steering helper
or manual compiler special member is introduced. No standalone constructor
symbol is emitted, matching the retail symbol inventory.

The constructor retains actual camera setup, position/rotation constants,
list pointers and loading/help state. The caller binds the real remaining
stack capacity before passing the stack top into `stSetBuffer`. Its
`buffer_quadwords` value is consumed as that argument. Binding the top first
leaves seven differences, while capacity first restores retail's load and
subtraction order. The mode parameter remains unused, as in retail.

Default costume flags are the genuine 64-bit value `0x1274521cb`;
`CostumeAttr`, `CostumeOptionEnv` and the relevant API use that width. A
32-bit substitute would discard the high bit. The source includes the
owning `title.hpp` declaration instead of repeating an extern. No target
string alias, reference pun or raw field-address calculation remains.

## Compiler measurements

| Private control | Differing words | Native body |
| --- | ---: | ---: |
| Current source and production profile | 161 | 0x2bc |
| Original constructor, exact after-inline row | 158 | 0x2b8 |
| Correct typed constructor, ordinary lowering | 17 | 0x2d8 |
| Actual camera zero evaluated first | 7 | 0x2d8 |
| Capacity bound before stack-top argument | 0 | 0x2d8 |
| Owning-header include and final hygiene | 0 | 0x2d8 |

The original constructor has one normally witnessed class-6 root, and its
exact placement row verifies expected/actual count one. The corrected real
column loop changes ordinary inline lowering: the corresponding diagnostic
reports class 3, and the stale class-6 row rejects expected one / actual zero.
The rejection is retained. The final zero has **no Costume placement row**;
neither eligibility nor the positive-count assertion is weakened.

The sole profile delta selects logical `menuchr.cpp`, exact
`MenuCostumeInit__FP9mgCMemoryPii`, actual callee
`__ct__15mgCCameraFollowFffff`, binary32 positive zero, `evaluate_first: true`
and expected count one. It selects the real camera's third float argument.
Other camera-zero and menu-fade calls remain unselected. The frozen proposal
retains the captured 27-row profile; its append-only delta must be merged
into the newer production profile, preserving all unrelated rows.

## Native evidence and limits

The retail GLOBAL/FUNC symbol is 0x2d8 bytes, within extent 0x2e0. The zero
has that exact size/binding and relocation offset/type map. All 44 target
relocation values, including addends and GP references, resolve to retail.
The native Costume vtable is OBJECT with binding 13, size 0x20 and alignment
16; its bytes and six resolved relocation values agree with retail. No
manual vtable write or invented constructor symbol occurs.

All 87 nonselected score rows and 93 emitted nonselected function bodies
retain sizes, bindings, instruction bytes and content-normalized targets.
All 121 allocated noncode data sections retain their bytes, symbol shapes
and normalized references. Including the owning title header renumbers some
anonymous data symbols; the audit checks content, type, binding, size,
alignment and targets instead of treating raw name changes as data changes.

An initial adjacent private header was not selected by MWCC's normal include
configuration, so the old constructor was redefined and compilation failed.
The successful diagnostic explicitly includes its exact private header;
the installable source proposal uses the normal owning include. Original
failure inputs and logs, the class-6 count rejection and earlier nonzero
controls remain intact. Neither shared source nor shared header was changed.

Receipts and 154 input/output hashes are under
`.private/pntc/menuchr-costume-natural/`, with `README.md`, `final.json`,
`comparisons.json`, `receipt-hashes.json` and `hygiene-final/data-symbol-audit.json`
as entry points. The concrete coordinator proposals are
`.private/proposals/menuchr-costume-constructor.patch`,
`menuchr-costume-source.patch` and `menuchr-costume-profile-delta.json`.
Shared-header review and complete postprocessed-object/PAL acceptance are
still required before guard removal.

## Complete private unit check against the 31-caller profile

The privately unguarded source is now checked with the current production
31 placement rows and the sole additional camera float row. It uses the
normal `menuchr.hpp` include, with the proposed header's private directory
placed first in this isolated compiler invocation. The actual game header
retains SHA-256
`092b6046cc875a9c1477c474cb684bd0e50721c5ab9886144d109898b91101b8`.
No shared-header or production source/profile change is activated.

The final source expresses the existing 0x2f allocation as
`sizeof(CMenuCostumeSel) / 16 + 2` and uses `USER_CHARA_MONICA` for the actual
character-selection argument. The genuine compiler reports expected/actual
one for the camera row. The complete wrapper, postprocessing, section fixup
and resolved object check pass: 0x11cb8 bytes and 3,771 relocations. The
resulting fixed object has SHA-256
`66d1847f2e49dd35c6bd600f0859a22a8596a1f9f1a2d8ee1b7b8325da41009b`.
This validates the complete proposed unit, beyond the earlier native score.
It is not full PAL acceptance of the shared-header proposal.

The attempted absolute private header include failed lookup in the complete
wrapper. Its exact source/header/profile inputs and compiler receipt are
preserved separately; the corrected run uses the standard owning include
and explicit private search directory. No field or constructor was changed
to resolve that harness failure.

New receipts are `promotion/{inputs,header-search-inputs}.json`,
`promotion/wrapper-header-search.log` and its zero status, plus
`outputs/promotion-header-search-current31/wrapped/provenance.json` and the
four stage logs. The reviewed, applicable current-source proposals are
`.private/proposals/menuchr-costume-constructor.patch`,
`menuchr-costume-source-validated.patch` and
`menuchr-costume-profile-validated.patch`. The earlier patches remain for
provenance. Production stays at 31 accepted callers until the owning header
can be changed and the whole game revalidated.


## Private whole-game header impact against accepted34

The reviewed Costume constructor/header/source candidate now has independent whole-game impact evidence under `.private/pntc/costume-whole-impact/`. The prior current31 source controls, class-6 rejection and complete-object receipt remain preserved. The current34 private source retains the five subsequently added purpose comments; no tracked source, shared header or production profile was edited during acceptance.

The profile preserves all 34 placement rows and 44 construction sites and appends only the witnessed camera floating-expression row (expected 1 / actual 1 in both ordinary compiler passes). CMenuCostumeSel retains ordinary class-3 constructor lowering, with no Costume placement row. All 149 canonical private wrappers/postprocess/fixups and retail object checks pass, and all 148 complete raw objects outside menuchr equal frozen accepted34. Actual emitted dependency files confirm the nine menuchr.hpp consumers; only menuchr changed under the sole private header overlay.

Menuchr's candidate raw object equals the earlier successful current31 wrapper SHA `66d1847f2e49dd35c6bd600f0859a22a8596a1f9f1a2d8ee1b7b8325da41009b`. The checker covers `0x11CB8` allocated bytes and 3,771 relocations (raw file 173,440 bytes). All 87 other code sections, 86 other named bodies/bindings, and 454 allocated noncode sections retain exact layout, payload, symbol metadata and named relocations. The complete Costume vtable is unchanged (global OBJECT, size 32, alignment 1 after normal wrapper fixup, six retail targets).

The native selected body is 728 bytes within the 736-byte retail layout extent, with eight zero tail bytes supplied by layout padding. Its union-relocation-masked instructions equal the assembly control. Ten existing GP-relative global operands become explicit verified type-7 relocations, giving 44 selected targets versus 34 assembly records; this changes no loaded code or data. CostumeOptionEnv acquires the real owning-header undefined OBJECT declaration, without a new definition or data change.

One private actual MWLD 2.4 link uses all 306 frozen inputs (149 private game plus 157 accepted34 SDK/runtime/data objects), canonical order/basenames/LCF and flags, with no source recompilation or canonical build-dir writes. PAL verification passes against immutable accepted34 ELF SHA `6352338ce8ff3fef0df4d54215ab1ca9348ae4db098c1a35cb7da359ba17b82d`. Main bytes are exact against accepted34 and retail: length 2,608,512, SHA `a103b0461a88e443a3af684cf150c05b5bd355e5a97ab2dc029c4d872bed0811`, loaded memory end `0x01F64A00`.

Full raw ELF metadata differs and remains explicit: selected size 736→728, removal of its assembly `.mwcats` marker, ten added selected GP-relative relocation tuples and twelve reordered existing selected record positions. All 98,516 preexisting named tuples are preserved; the 98,482 nonselected records keep exact order and identities. Incoming selected-function/vtable consumers are exact. `link/linked-metadata-differences.json`, `link/linked-relocation-audit.json`, `SUMMARY.json`, `COMMANDS.md` and final hash manifests retain complete receipts and private audit/preflight negatives.

The exact paired current34 source/header/profile proposals remain private under `proposals/`. This establishes Costume-alone whole-game impact evidence; it does not authorize shared-header activation. Composition with other unowned header overlays requires separate acceptance evidence.

Root independently verifies all 1,909 regular files in the final whole-impact
manifest with no size/hash mismatches; the 1,046 passthrough symlinks are not
followed. `ALL-ARTIFACTS.json` has SHA-256
`c087a63df0cede8f8eed478d3b624b3cbacaa958bb5e19360a9ff296c7b334d4`.
The root receipt is
`.private/pntc/receipts/costume-whole-impact-root-verification.json`.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
