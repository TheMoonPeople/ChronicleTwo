# Natural inventory debug construction

`MenuItemDebugKey` has a complete natural pn15 diagnostic zero with the
original headers. Its actual retail LOCAL/FUNC symbol is 0x16cc bytes at
0x00247e10, within extent 0x16d0. The source declaration and definition are
static, matching retail binding. The final four bytes of the extent are
measured zero padding, not part of the body.

Existing menusys constructor/unit notes and owner layouts establish the menu,
camera, memory, character, weapon, ridepod and user-data dependencies. Fresh
mandated m2c retains its known jump-table limitation. Actual instruction and
data audits supplement those existing types; no header overlay is required.

The caller's one native CActionChara placement expression is selected by
logical menusys.cpp, caller MenuItemDebugKey__Fv, __nw__FUiP1,
__ct__12CActionCharaFv, after_constructor_inline and count one. Its ordinary
constructor chain supplies every base/derived initialization. The follow
camera remains out of line and excluded. Its actual binary32 positive-zero
argument is selected by __ct__15mgCCameraFollowFffff, evaluate_first true and
count one. No register, instruction offset or incidental literal ordinal
selects either policy. The new rows sit beside existing menusys rows.

The inherited source differs by 1,208 words; exact placement conversion
leaves fourteen, and the camera row removes six setup differences. Real
stGetTop buffers and six branch-local two-float zero arrays replace byte
addressing and aliased qword copies. Ordinary weapon/rod member accesses and
a typed ridepod attribute view preserve retail address formation and remove
the remaining operand differences. Redundant allocation casts are removed.
There are no puns, invented helpers, dummy values or handwritten special
members in the activated body.

CHARA_DATA::defence remains s16 at +0xa. A genuine u16 value local loads its
unsigned bits, increments with sixteen-bit wrap, stores them back, then caps
the actual stored unsigned value at 128. Thus 128 is capped after increment,
and 65535 wraps to zero first. A direct widened assignment has the same
value behavior but MWCC selects a signed load; the meaningful narrowed local
reproduces retail lhu without a reference pun. Existing defence readers also
use lhu. Those observations justify this operation's value type without
changing the shared storage declaration.

ROBOPART_USED retains its real status[10]. Entries zero/one are status values;
entries two through nine are eight attributes. A typed pointer to status[2]
and a real cursor-minus-two index select that subrange. The original status
cap deliberately retains status[status_index + 1], including entry two for
cursor one. A split two-element status declaration would break that existing
producer and cross-component access. The superseded private split/unsigned
header overlays are not required proposals for this promotion.

The fallback path is the genuine mutable local static char array
"item/d_box.chr", fifteen bytes at 0x003556a8. A readonly literal also gave
instruction zero but fails the actual .data storage-class requirement and is
rejected. Shared "num" and "info.cfg" remain readonly literals. All six input
seeds are eight-byte positive-zero .sbss objects. The twelve-entry switch
table at 0x00370830 retains ordinary C++ switch construction and exact case
addresses. The unchanged 28-byte status-flag table remains in its owner data.

The seven original path/seed storage markers remain, while their source
aliases and declarations are gone. The existing binder validates and binds
the genuine native initializer copies to these retail pieces. Removing the
markers leaves unnamed .data/.sbss pieces and consequently unresolved run
maps. Retaining proven storage fixes the private complete wrapper, without
padding arrays or substitute types: zero problems, 0x1b0c8 checked bytes and
6,006 resolved relocations. The genuine corresponding wrapper control also
passes independently.

All 164 nonselected scored functions and 166 emitted nonselected functions
retain sizes, bindings, masked bodies and normalized references. Eleven raw
anonymous names change with equal data identity. The selected audit checks
344 text relocation entries, 284 resolved references, all twelve switch-table
entries and ten data constraints, including actual section classes and symbol
sizes versus padding. SelectInit and MenuModeMalloc remain zero.

Exact final source/profile patches, positive-count traces, native/wrapped
objects, data audits and input hashes are under
`.private/pntc/menusys-residual/`, with `debugkey-handoff.json` as entry point.
This diagnostic/private-wrapper result requires full game PAL, all-object
and unrelated-artifact acceptance before a production promotion is claimed.

## Complete promotion acceptance

The pn15 clean 29-caller build passes PAL verification and all 149 complete
objects. Menusys checks 0x1b0c8 bytes and 6,006 resolved relocations. Every
assembled object outside nineteen promoted units retains its exact baseline
hash in the recursive 306-object census; the same holds for all 149
source-only objects outside those units. Linked main bytes and the loaded
memory end remain equal to baseline. Explicit context/objdiff refresh gives
6,778 matched / 84 guarded / ten assembly-only / zero fuzzy.

The two file-read mode arguments use the owning `LOAD_FILE_READ` enum. A
separate genuine current-profile control proves the entire native object
byte-identical to the reviewed zero, SHA-256
`27eeb70d13b4742bb7c0ff85f0c77d89fb8e5843b56cc098d2f588af1586b3c8`.
Its complete nonselected/data/relocation audit also passes. The final game
build, 149-object check and unrelated-artifact comparison are repeated after
that cleanup and pass. No header proposal is needed for the promotion.

Receipts are `.private/pntc/receipts/promote-twenty-nine-clean-build.log`,
`promote-twenty-nine-{objects,artifacts,progress,coverage}` and
`promote-twenty-nine-final-{build,objects,artifacts}`, with explicit zero
statuses and artifact JSONs. The enum control's exact inputs and audit are
identified by `.private/pntc/menusys-residual/debug-read-mode-handoff.json`.
Manual guard removal is accepted after those complete checks.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
