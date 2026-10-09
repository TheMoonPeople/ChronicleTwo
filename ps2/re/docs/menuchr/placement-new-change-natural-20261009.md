# Party-change menu constructor and source boundary

The exact retail symbol is `MenuCharaChangeInit__FP9mgCMemoryPii`, global
function at `0x2B9150`, with symbol size and manifest extent `0x4F0`.
There is no `MenuChangeInit__FP9mgCMemoryPii` retail symbol. The function
carves the party-change work stacks, constructs the party-change menu and
repair manager, sets up character/model loading, then chooses its initial
fade/script and disables menu input.

The extra body-store machine zero below is **not approved for promotion**. No tracked file, shared header, active
profile, image, or PAL object was changed during these probes.

## Inputs and analysis

The control snapshots use head `36e47caeb07f74d8346478c78ab4c924706a41ba`,
PN15 `chronicletwo_dev:sf-63f7a9e-pn15`, the current production profile with
29 placement rows, and canonical compiler flags under genuine logical
`menuchr.cpp`. Source SHA256 is
`c8dde1b8097429c466880d877864e8defb0678a84c73d4b445b35d6dab16a076`;
profile SHA256 is
`23148768f9e8e96d8525a4e5f75c5255417200c4789840c8eb3d4a24f87ea3e5`.
`inputs.json` records the exact dependency-header and reused-context hashes.
Fresh analysis was obtained through `decompile.sh`; `m2c.c` and its empty
stderr receipt are retained. The decompiler's pseudo stack fields and raw
unknown-base operations were checked against the existing declared types
and complete retail assembly, rather than copied into source.

All eleven owning menuchr notes were read in the preceding Costume task and
the relevant constructor/party-change passages were revisited. Current
definitions and documentation were checked for the menu base, menu and
repair manager, memory stacks, common-menu state, user active-character
field, scene character/fade fields, palette, actual menu-open/file-load
enums and message methods. This work does not repeat the old named global
constructor/compiler negatives.

## Constructor and type evidence

Retail calls placement new for `CMenuChrCngMenu` at `0x2B9220`, requesting
`0x1F80` bytes from a `0x1FA`-quadword stack allocation. The existing
user-declared constructor is source-owned and explicitly inline; no
standalone retail constructor symbol exists. Its original expression has
inline class 6. An exact private semantic row, naming this caller,
`__nw__FUiP1`, `__ct__15CMenuChrCngMenuFv`, and
`after_constructor_inline`, verified `expected_matches: 1`, actual 1.
That row is a control, not a production-profile proposal.

The second allocation at `0x2B93DC` requests `0x1EC` bytes for
`CRepairManager` from `0x21` quadwords. This type has no user-declared
constructor: its eight real `mgCMemory` array elements occupy
`0x24..0x1A4` at stride `0x30`, followed by the scalar model stack at
`0x1B4`. Its implicit construction is class 3 and is uniformly ineligible.
The private exact repair-row expected-1 diagnostic failed with actual 0;
the real failure log is retained and no repair row may be promoted.
Compiler-generated construction was not handwritten.

The existing header asserts `CMenuChrCngMenu == 0x1F80`,
`CBaseMenuClass == 0x110`, `mgCMemory == 0x30` and repair-manager size
`0x1EC`. The member arrays and retail stores agree: `chara_pos[5]` at
`0x15C`, `npc_cmd_mes[4]` at `0x22C`, `cmd_part[4]` at `0x180`, and
three gauge parts/pointers at `0x144`/`0x150`. The actual palette aggregate
at `0x1A80` consists of `u32 clut[256]` and the adjacent reserved
`0x100` bytes; `memset(&palette, 0, sizeof(palette))` expresses the retail
`0x500` clear without accessing the alternate byte overlay. No header
correction is required or proposed.

## Bounded source controls

| Candidate | Words | Native size | Relocation offset/type map | Purpose |
| --- | ---: | ---: | --- | --- |
| Current production29 source | 236 | `0x4F0` | Different | Fresh control |
| Exact class6 after-inline row | 258 | `0x4E8` | Different | Positive-count semantic control |
| Typed array-only cleanup | 258 | `0x4E8` | Different | Hygienic source without added cursor default |
| Array plus body `set_cursor = 1` | 0 | `0x4F0` | Equal | Rejected machine-zero diagnostic |
| Array plus `: set_cursor(1)` | 26 | `0x4F0` | Different | Single legitimate initializer-list control |

The array source replaces the five actual `chara_pos` scalar clears with a
bounded loop over the declared array. MWCC then classifies the existing
constructor as class 3; ordinary native lowering is used. The three array
variants use a byte-identical copy of production29, with no added
placement or float policy. Exact source patches and source/profile hashes
are retained per candidate.

The shared caller cleanup in these three variants inlines the real
`"chrchg0.pac"` and `"JOININIT"` literals, uses documented menu/file mode
enums, calls existing `stGetRest`/`stGetTop` methods, directly writes the
real common-menu cursor field and clears the typed palette aggregate.
The sole remaining C-style pointer cast in the selected source is the
legitimate `u8*` file-buffer view passed to `EnterDataMenu`; the existing
`static_cast<CActionChara*>` follows the declared inheritance. No invented
helper, dummy local, assembly, manual vtable, field-byte arithmetic, type
pun, literal alias or generated-special-member body was introduced.

## Cursor sequence and source acceptability

`set_cursor` is an existing `u8` at offset `0x11E`. Its documented purpose
is to request immediate placement of the cursor. `MenuLocalLoop` consumes
the flag by calling `MenuSetPos` and clearing it; menu opening and return
from the monster box request this behavior. These consumers explain the
field, but do not explain its transient constructor value.

Retail stores 1 at target `+0x144`, then 0 at `+0x19C`. Only independent
POD pointer/scalar and array-zero stores intervene. The base constructor
and both memory-member `Init` calls precede the first write; `InitStarInfo`
follows the reset and only clears star state. `ChrChangMenuPt` is published
after the constructor has finished. No intervening observable call, alias
of offset `0x11E`, callback, non-POD member construction, or separate
declared `Initialize` method for this class was found. The old owner note
already records the first 1, but does not provide a source-level boundary
or purpose for the subsequent overwrite.

Adding the first store in the body of the genuine existing constructor
recovers the complete retail machine sequence. It nevertheless remains a
dead store with no established source/default-initialization explanation.
The coordinator explicitly rejected its promotion under the rule against
stores that merely steer code generation. Exact retail assembly is
evidence of the operation, not automatic permission to reconstruct an
arbitrary redundant source assignment.

The one requested initializer-list alternative, `: set_cursor(1)`, follows
declaration order: base construction, `set_cursor`, then the two memory
members. Native MWCC stores 1 at `+0x100` in the first `mgCMemory::Init`
call's delay slot, before that call executes; the second Init follows.
The existing body reset remains at `+0x19C`. Thus member calls genuinely
separate initialization from the reset, but retail places the first 1
after both calls. The documented memory Init only clears its own fields
and invokes no observer of the outer cursor flag. No invented initialization
boundary or helper resolves that difference.

This initializer-list control is 26/316 words from retail. Its exact
residual is constructor scheduling at `+0xE8..+0x144` (22 differing words)
and the `-1` register used by four later stores at
`+0x1D0/+0x1D4/+0x1D8/+0x1DC`. Every other instruction agrees under
relocation masking. No float argument or expression exists in this
residual; the actual fade/script/scene calls already match and offer no
semantic float selector that could repair constructor ordering.

The initializer26 source and array-only258 hygienic source are frozen.
There is no accepted natural zero and no production source/profile/header
activation proposal. Further work requires evidence for the original
initialization/default boundary, rather than another steering store.

## Complete diagnostic audits and limits

For every successful probe all 87 nonselected score rows and all 93
nonselected normalized function bodies, sizes, bindings and relocation
targets match the fresh control. Some compiler-generated `@` names
renumber; normalization checks their actual data bytes, alignment, size,
type and binding. Native nonselected function symbols also match in the
three audited array variants. The three already accepted menuchr callers
remain at zero.

The rejected machine-zero diagnostic has global FUNC binding/type and
symbol/section/retail size `0x4F0`. Its 114 relocation targets all resolve
to the correct actual retail values, its offset/type map equals retail,
and its masked bytes are identical. The native
`__vt__15CMenuChrCngMenu` is OBJECT binding 13, size `0x20`, section
alignment 16, with all six relocated base virtual entries exact and all
remaining bytes exact. Neither a menu nor repair standalone constructor
is emitted.

All 121 allocated non-code data sections from the control survive
unchanged after normalization. The only additions are two local OBJECT
literals, alignment 8: `chrchg0.pac\0` (12 bytes, retail `0x374478`) and
`JOININIT\0` (9 bytes, retail `0x374488`). Their NUL termination, bytes,
size, binding/type, native alignment and actual target references are
audited; no unexplained data or target is added. Old assembly-provided
literal definitions remain in source because this is an isolated
source-only probe.

These are native source-only receipts, not postprocessed complete-object
or PAL acceptance. The coordinator owns any future source promotion,
literal migration/layout processing and complete PAL validation. The
unaccepted extra-store diagnostic must not be mistaken for an approved
zero merely because its machine audits pass.

## Receipts

Use `inputs.json`, `retail-witnesses.json`, `m2c.c`, `comparisons.json`,
the per-candidate `source.patch`, `scores.json`, `menuchr.o`, assembly and
diff logs, and each array candidate's `data-symbol-audit.json`.
`initial-commands.sh`, `run-variants.sh`, `initializer-command.sh` and
`audit-command.sh` preserve the exact pinned-image commands.
`final.json` and `receipt-hashes.json` index the frozen result.

An inspection/scratch-path incident is recorded separately in
`inspection-ledger.md`; no reserved dungeon file was inspected in this
task and no existing or tracked file was altered by that incident.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
