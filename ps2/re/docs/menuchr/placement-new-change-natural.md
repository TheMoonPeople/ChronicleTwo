# Party-change initializer construction constraints

`MenuCharaChangeInit__FP9mgCMemoryPii` remains assembly-backed. The zero-word candidate
adds an unexplained overwritten constructor store and is rejected.

## Constructor and type evidence

Retail calls placement new for `CMenuChrCngMenu` at `0x2B9220`, requesting `0x1F80`
bytes from a `0x1FA`-quadword stack allocation. The existing user-declared constructor
is source-owned and explicitly inline; no standalone retail constructor symbol exists.
Its original expression has inline class 6. An exact semantic control row, naming this
caller, `__nw__FUiP1`, `__ct__15CMenuChrCngMenuFv`, and `after_constructor_inline`,
verified `expected_matches: 1`, actual 1. That row is a control, not a
production-profile proposal.

The second allocation at `0x2B93DC` requests `0x1EC` bytes for `CRepairManager` from
`0x21` quadwords. This type has no user-declared constructor: its eight real `mgCMemory`
array elements occupy `0x24..0x1A4` at stride `0x30`, followed by the scalar model stack
at `0x1B4`. Its implicit construction is class 3 and is uniformly ineligible. The
private exact repair-row expected-1 diagnostic failed with actual 0; no repair
conversion row is eligible. Compiler-generated construction was not handwritten.

The existing header asserts `CMenuChrCngMenu == 0x1F80`, `CBaseMenuClass == 0x110`,
`mgCMemory == 0x30` and repair-manager size `0x1EC`. The member arrays and retail stores
agree: `chara_pos[5]` at `0x15C`, `npc_cmd_mes[4]` at `0x22C`, `cmd_part[4]` at `0x180`,
and three gauge parts/pointers at `0x144`/`0x150`. The actual palette aggregate at
`0x1A80` consists of `u32 clut[256]` and the adjacent reserved `0x100` bytes;
`memset(&palette, 0, sizeof(palette))` expresses the retail `0x500` clear without
accessing the alternate byte overlay. No header correction is required or proposed.

## Source controls

| Candidate | Words | Native size | Relocation offset/type map | Purpose |
| --- | ---: | ---: | --- | --- |
| Original constructor | 236 | `0x4F0` | Different | Ordinary lowering |
| Exact class6 after-inline row | 258 | `0x4E8` | Different | Positive-count semantic control |
| Typed array-only cleanup | 258 | `0x4E8` | Different | Hygienic source without added cursor default |
| Array plus body `set_cursor = 1` | 0 | `0x4F0` | Equal | Rejected machine-zero diagnostic |
| Array plus `: set_cursor(1)` | 26 | `0x4F0` | Different | Single legitimate initializer-list control |

## Cursor sequence and source acceptability

`set_cursor` is an existing `u8` at offset `0x11E`. Its documented purpose is to request
immediate placement of the cursor. `MenuLocalLoop` consumes the flag by calling
`MenuSetPos` and clearing it; menu opening and return from the monster box request this
behavior. These consumers explain the field, but do not explain its transient
constructor value.

Retail stores 1 at target `+0x144`, then 0 at `+0x19C`. Only independent POD
pointer/scalar and array-zero stores intervene. The base constructor and both
memory-member `Init` calls precede the first write; `InitStarInfo` follows the reset and
only clears star state. `ChrChangMenuPt` is published after the constructor has
finished. No intervening observable call, alias of offset `0x11E`, callback, non-POD
member construction, or separate declared `Initialize` method for this class was found.
The old owner note already records the first 1, but does not provide a source-level
boundary or purpose for the subsequent overwrite.

Adding the first store in the body of the genuine existing constructor recovers the
complete retail machine sequence. It nevertheless remains a dead store with no
established source/default-initialization explanation. This form violates the source
rule against stores that merely steer code generation. Exact retail assembly is evidence
of the operation, not automatic permission to reconstruct an arbitrary redundant source
assignment.

The one requested initializer-list alternative, `: set_cursor(1)`, follows declaration
order: base construction, `set_cursor`, then the two memory members. Native MWCC stores
1 at `+0x100` in the first `mgCMemory::Init` call's delay slot, before that call
executes; the second Init follows. The existing body reset remains at `+0x19C`. Thus
member calls genuinely separate initialization from the reset, but retail places the
first 1 after both calls. The documented memory Init only clears its own fields and
invokes no observer of the outer cursor flag. No invented initialization boundary or
helper resolves that difference.

This initializer-list control is 26/316 words from retail. Its exact residual is
constructor scheduling at `+0xE8..+0x144` (22 differing words) and the `-1` register
used by four later stores at `+0x1D0/+0x1D4/+0x1D8/+0x1DC`. Every other instruction
agrees under relocation masking. No float argument or expression exists in this
residual; the actual fade/script/scene calls already match and offer no semantic float
selector that could repair constructor ordering.

There is no accepted natural zero and no production source/profile/header activation
proposal. Further work requires evidence for the original initialization/default
boundary, rather than another steering store.

Construction selector semantics are documented in [the compiler
design](../satansfiddle/placement-new.md).
