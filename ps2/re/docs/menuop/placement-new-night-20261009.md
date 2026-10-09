# Manual-menu construction

`MenuManualInit` allocates the manual's movie buffer and menu, enters its
textures/configuration, populates the unlocked-entry message lists and records
the dungeon/boss movie state. Its established memory, menu, window and movie
types are fully defined in the existing headers and notes. The complete
assembly guard is removed by hand.

The exact `menuop.cpp` row selects `MenuManualInit__FP9mgCMemoryPii`,
`__nw__FUiP1`, `__ct__11CManualMenuFv`, `after_constructor_inline` and one
eligible original class-6 construction. The explicit movie allocation has
no direct constructor and is outside this row. Retail is GLOBAL/FUNC at
0x002C4480, body and extent 0x510; the cleaned selected draft is zero words
with the correct relocation map.

Eight strings are compiler literals, including the exact Shift-JIS bytes of
`MSG初期化`. Only three aliases/data fragments become unused; the remaining
shared names stay for other callers. `MES_VALUE_MAX` names actual message
value-array bounds, and `LOOP_DUNGEON` names the owning loop kind. The message
preset remains 0x10: the same-valued array-bound enum does not describe a
preset identifier. Undocumented manual entry/frame-mode numbers remain
numeric. All access is through established fields and file-data API casts.
No dummy local, steering helper or object-byte arithmetic is introduced.
Private draft receipts are `natural-menu-clean-literals/menuop.o`, its log
and `scores.json`; exact literal bytes are in
`.private/pntc/receipts/menuop-literal-recovery.json`.

The canonical baseline has 285 differing words; the semantic policy also
restores constructor expansion scheduling where the residual is larger than
the allocator branch pair. All 35 other diagnostic rows equal the selected
control. Full pn14 integration passes `SCES_511.90: OK`, 149/149 complete
objects, and baseline hashes outside the 16 promoted units in both the full
306 assembled-object census and 149 source-only base objects. The linked
main/game bytes and loaded memory end match. Refreshed coverage is 6,773
matched / 89 guarded / 10 assembly-only / 0 fuzzy. Full receipts are
`.private/pntc/receipts/promote-twenty-four-build.log` and `.exit`,
`promote-twenty-four-objects.log`, `promote-twenty-four-artifacts.json`,
`promote-twenty-four-progress.log`, and `promote-twenty-four-coverage.log`.
The [design note](../satansfiddle/placement-new.md)
states the intentional policy and its evidence limits.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
