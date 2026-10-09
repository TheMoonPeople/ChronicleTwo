# Matched function-point allocation with the isolated conversion proposal

`CFuncPointMngr::Add(int, mgCMemory*)` obtains a list node from the given
quadword allocator, initializes its point, and appends it to the selected
point-kind list. Its natural `CList<CFuncPoint>` construction and the
existing documented point/list types remain unchanged; the assembly guard
is removed by hand.

The exact row selects `funcpoint.cpp`,
`Add__14CFuncPointMngrFiP9mgCMemory`, scalar allocator `__nw__FUiP1`,
and constructor `__ct__19CList<10CFuncPoint>Fv`, with
`after_constructor_inline` and one eligible class-6 construction. The
canonical draft's two-word branch/copy difference becomes zero. The
constructor's expression inline read is preserved; MWCC's normal enclosing
statement-conversion request produces retail's allocator-result null guard.
No source helper, artificial control flow or stored inline metadata is used.

The row is part of the lane's [design note](../satansfiddle/placement-new.md).
The older placement study's absence of a demonstrated state defect remains
valid: this is an intentional lowering policy proposal, not a state repair.

On `chronicletwo_dev:sf-63f7a9e-pn13`, the complete resolved object passes,
the PAL verifier reports `SCES_511.90: OK`, and all 149 game units pass.
Every recursive object outside funcpoint and the simultaneously promoted
mg_tanime unit retains its exact baseline hash. The linked main/game bytes
remain identical; ELF symbol metadata changes with native function ownership.
Retail symbol 0x002A11C0 is GLOBAL/FUNC, size 0xA0, matching the documented
native body. Complete-object acceptance includes the surrounding unit data,
zero alignment bytes and resolved relocation targets.

Receipts: `.private/pntc/receipts/promote-first-two-build.log` and `.exit`,
`promote-first-two-objects.log`, `promote-first-two-artifacts.json`, and
`semantic12-score-comparison.json`. Source review covers the complete short
caller, including its failure return and dispatch to the node overload.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
