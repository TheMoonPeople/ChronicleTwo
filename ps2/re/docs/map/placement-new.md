# Natural parts-group node construction

`CMap::AddPartsGroup` is native and exact under a single after-inline construction row.
It finds or creates a named group, constructs a list node, assigns its placed-parts
pointer and appends it. Missing group slots still return -1. The retail allocation
behavior remains unchanged, including the unguarded node use after the constructor's
allocation check. No extra failure branch is introduced.

CMap is 0xd10; CPartsGroup is 0x10; PartsGroupData is one actual pointer, size four;
CList<PartsGroupData> is 0x10. The node carries next/prev at zero/four, its data pointer
at eight and the compiler's vptr at twelve. The existing data constructor clears parts
before virtual Initialize. The already matched explicit list specialization clears prev
then next and leaves data alone. No array, helper, field rewrite or manual vtable
initialization is supplied.

The inherited caller repeats data.parts = 0 under a post-construction test, although the
real data constructor has already done that clear. Removing the duplicate was previously
a negative under ordinary lowering. The changed-conversion control is the relevant new
condition: direct natural placement construction with that duplicate removed now reaches
zero. Its allocation uses sizeof(CList<PartsGroupData>)/16 + 2, the proven object plus
two reserved quadwords. That source is whole-native-object identical to the
literal-three control. The redundant same-type allocation cast is removed.

Normal compiler mangler returns independently witness the exact scalar allocator
__nw__FUiP1 and constructor __ct__23CList<14PartsGroupData>Fv. The row names map.cpp and
the exact AddPartsGroup caller, selects after_constructor_inline and asserts
expected/actual count one. No float arguments exist in this caller, and no float
selector is introduced.

The retail GLOBAL/FUNC body at 0x0015da50 is 0xfc, within extent 0x100. The final native
body, symbol size and relocation offset/type map agree. The selected list vtable at
0x0037b578 contains the actual Initialize target 0x0015db50; its coalesced retail
function is 0xc within extent 0x10. Nine selected named relocation targets resolve
independently to retail symbols.

All 85 nonselected emitted function payloads and 84 nonselected score rows remain exact.
All 99 nonselected ordered allocated sections preserve bytes, sizes and alignments. Four
explicitly verified local static aliases account for their compiler-generated suffix
changes; no generic suffix stripping or anonymous wildcard equivalence is used. All six
vtables preserve bytes and named targets without alias mapping. Clean whitespace and
manual-guard proposal compiles reproduce the entire audited native object.

Construction selector semantics are documented in [the compiler
design](../satansfiddle/placement-new.md).
