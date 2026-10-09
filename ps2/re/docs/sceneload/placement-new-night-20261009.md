# Scene character loading and copying

`CScene::LoadChara` constructs and assigns a character, loads its model and
optional configuration, and initializes the scene slot's transform/status.
`CopyChara(index, source_index, memory)` constructs the destination character
and copies the source's data, transform and texture block. Their documented
types and natural bodies remain, with assembly guards removed by hand.

Each exact row uses `sceneload.cpp`, `__nw__FUiP1`, `__ct__11CCharacter2Fv`,
`after_constructor_inline` and one eligible class-6 construction. The full
caller identities are
`LoadChara__6CSceneFiPUiPcP9mgCMemoryP9mgCMemoryP9mgCMemoryii` and
`CopyChara__6CSceneFiiP9mgCMemory`. Both canonical two-word allocator-result
branch/copy differences become zero.

The recovered `chara` and `cfg` names are inline literals; their unused
aliases/data fragments are removed. Complete review retains the authentic
allocation/failure ordering, typed one-element file arrays and named scene
entry fields. The scene status bit remains numeric because no owning status
enum is established in the available scene documentation. No new helper,
raw byte object arithmetic or synthetic lifetime variable is introduced.

Retail LoadChara at 0x00288F30 is GLOBAL/FUNC, size 0x244 in extent 0x250.
CopyChara at 0x002891B0 is GLOBAL/FUNC, size 0x284 in extent 0x290. The existing
`scenesnd.hpp` declarations already document both exact symbol sizes. pn14 checks complete resolved
sceneload bytes, all 149 units and `SCES_511.90: OK`, including alignment
padding. Every assembled/source-only object outside the twelve promoted
units retains its baseline hash; main/game bytes and loaded memory end agree.

Receipts: `.private/pntc/receipts/natural-resource-callers.log`,
`sceneload-literal-recovery.json`, `promote-eighteen-pn14-clean-build.log`
and `.exit`, `promote-eighteen-pn14-clean-objects.log`, and
`promote-eighteen-pn14-clean-artifacts.json`.
The [design note](../satansfiddle/placement-new.md) records the
intentional conversion policy; no global compiler-state repair is asserted.

Final marker-order validation also passes `promote-eighteen-final-build.log`,
`promote-eighteen-final-objects.log` (149/149), and
`promote-eighteen-final-artifacts.json`. Resolved game bytes and all objects outside the accepted units still agree.
Refreshed native coverage is 6,767 matched / 95 guarded / 10 assembly-only /
0 fuzzy, recorded in `promote-eighteen-coverage.log`.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
