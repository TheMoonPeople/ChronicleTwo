# Natural parts-group node construction

`CMap::AddPartsGroup` has a natural pn15 diagnostic zero under a single
after-inline construction row. It finds or creates a named group, constructs
a list node, assigns its placed-parts pointer and appends it. Missing group
slots still return -1. The retail allocation behavior remains unchanged,
including the unguarded node use after the constructor's allocation check.
No extra failure branch is introduced.

All three existing map notes, current MWCC/constructor notes and owner types
are read before fresh mandated m2c. CMap is 0xd10; CPartsGroup is 0x10;
PartsGroupData is one actual pointer, size four; CList<PartsGroupData> is
0x10. The node carries next/prev at zero/four, its data pointer at eight and
the compiler's vptr at twelve. The existing data constructor clears parts
before virtual Initialize. The already matched explicit list specialization
clears prev then next and leaves data alone. No array, helper, field rewrite
or manual vtable initialization is supplied.

The inherited caller repeats data.parts = 0 under a post-construction test,
although the real data constructor has already done that clear. Removing
the duplicate was previously a negative under ordinary lowering. The
changed-conversion control is the relevant new condition: direct natural
placement construction with that duplicate removed now reaches zero. Its
allocation uses sizeof(CList<PartsGroupData>)/16 + 2, the proven object plus
two reserved quadwords. That source is whole-native-object identical to the
literal-three control. The redundant same-type allocation cast is removed.

Normal compiler mangler returns independently witness the exact scalar
allocator __nw__FUiP1 and constructor __ct__23CList<14PartsGroupData>Fv.
The private row names map.cpp and the exact AddPartsGroup caller, selects
after_constructor_inline and asserts expected/actual count one. It retains
the complete 27-row production profile otherwise. No float arguments exist
in this caller, and no float selector is introduced.

The actual GLOBAL/FUNC body at 0x0015da50 is 0xfc, within extent 0x100.
The final native body, symbol size and relocation offset/type map agree.
A comment-only correction for the header's padded @size remains private.
The selected list vtable at 0x0037b578 contains the actual Initialize target
0x0015db50; its coalesced retail function is 0xc within extent 0x10. Nine
selected named relocation targets resolve independently to retail symbols.

All 85 nonselected emitted function payloads and 84 nonselected score rows
remain exact. All 99 nonselected ordered allocated sections preserve bytes,
sizes and alignments. Four explicitly verified local static aliases account
for their compiler-generated suffix changes; no generic suffix stripping
or anonymous wildcard equivalence is used. All six vtables preserve bytes
and named targets without alias mapping. Clean whitespace and manual-guard
proposal compiles reproduce the entire audited native object.

Exact source/profile/header proposals, direct mangler witnesses, native
objects, ordered-section and target audits are under
`.private/pntc/map-addparts-natural/`. Full wrapper, PAL and unrelated-artifact
acceptance are still required before this zero counts as promoted.

## Complete promotion acceptance

The manual guard removal is accepted in the pn15 clean 29-caller group.
The PAL verifier prints `SCES_511.90: OK`; all 149 complete objects pass,
including map's 0x4730 checked bytes and 418 resolved relocations. The 306
assembled objects and 149 source-only objects retain baseline whole-file
hashes outside the nineteen promoted units. Linked game bytes and the
loaded memory end remain baseline-identical. Explicit context/objdiff
refresh reports 6,778 matched / 84 guarded / 10 assembly-only / zero fuzzy.

Receipts are `.private/pntc/receipts/promote-twenty-nine-clean-build.log`,
`promote-twenty-nine-objects.log`, `promote-twenty-nine-artifacts.json`,
`promote-twenty-nine-progress.log` and `promote-twenty-nine-coverage.log`,
with explicit zero exit files. The exact owning-header size correction
remains `.private/proposals/map-addpartsgroup-symbol-size.patch`; the header
is unchanged. Incidental comment-only size corrections are also private.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
