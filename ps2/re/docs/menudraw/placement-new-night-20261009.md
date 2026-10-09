# Repair-model construction

`CRepairManager::GeneratePoly` loads the repair effect's character pack,
constructs its action character in the model stack and initializes its motion,
position, scale, visibility and depth-test attribute. Existing unit/type notes
and the real `CActionChara` constructor chain supply its complete types.
The guard is removed by hand after whole-function source review.

The exact `menudraw.cpp` row selects `GeneratePoly__14CRepairManagerFPfi`,
`__nw__FUiP1`, `__ct__12CActionCharaFv`, `after_constructor_inline` and one
static class-6 construction. Retail is GLOBAL/FUNC at 0x0022FE30, exact body
and extent 0x240. The selected clean draft is zero words with the correct
relocation map.

The three resource strings are inline: `repair_powder.chr`, `info.cfg` and
Shift-JIS `発動`, bytes 94 AD 93 AE, represented by fixed-width octal escapes.
Aliases/data used by other functions remain. `MG_DEPTH_TEST_ALWAYS` names the
actual Z-test sentinel and `MG_FRAME_ATTR_Z_TEST` names its attribute mask.
The complete function retains typed frames, attributes and real model-stack
state; it introduces no identity helper, type-pun or byte-field traversal.
Private draft receipts are `natural-menu-clean-literals/menudraw.o`, its
compiler log and `scores.json`, with literal bytes recorded in
`.private/pntc/receipts/menudraw-literal-recovery.json`.

The canonical baseline has 117 differing words; the semantic policy also
restores constructor expansion scheduling where the residual is larger than
the allocator branch pair. All 197 other diagnostic rows equal the selected
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
