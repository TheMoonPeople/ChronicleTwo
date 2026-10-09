# Item-menu work-memory construction

`CMenuItemInfo::MenuModeMalloc` partitions the menu stack, creates its action
characters and movement/repair objects, initializes effects, then exposes the
remaining work memory. The existing complete type analysis remains applicable;
the guard is removed by hand.

The exact `menusys.cpp` row selects `MenuModeMalloc__13CMenuItemInfoFP9mgCMemory`,
`__nw__FUiP1`, `__ct__12CActionCharaFv`, `after_constructor_inline` and
`expected_matches: 2`. These are the one action-character loop expression
and the separate `SpectolFrame` expression. The loop's seven executions do
not increase the static count. The move-item/repair constructors and two
explicit effect allocations are outside the class-6 constructor identity.

Retail is GLOBAL/FUNC at 0x00245EC0, size 0x3B8 in extent 0x3C0. Its selected
clean draft reaches zero with the correct relocation map. The real constructor
chain retains its existing depth-8 pragma. The stack additions walk actual
`u_long128` elements; they are typed buffer boundaries rather than byte
access to object fields. The texture name `menueff0` is inline; its shared
alias/data remains for another user. The whole body contains no scalar
type-pun, identity helper or dummy lifetime variable. The shared-header exact
size correction is saved privately. Private receipts are the
`natural-menu-clean-literals/menusys.o` object, compiler log and `scores.json`,
plus `.private/pntc/receipts/menusys-literal-recovery.json`.

The canonical baseline has 127 differing words; the semantic policy also
restores constructor expansion scheduling where the residual is larger than
the allocator branch pair. All 164 other diagnostic rows equal the selected
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

## Natural inventory selector candidate

`MenuItemSelectInit__FP9mgCMemoryPii` is at 0x002528e0 with actual retail
GLOBAL/FUNC (info 0x12) size 0x288; its next-address layout extent is 0x290.
The eight bytes at 0x00252b68..0x00252b70 are zero and have no relocations.
The inherited header's extent-based @size has a private exact correction.
Existing `notes.md`, `guarded-constructors.md` and the owning headers establish
all dependent layouts and APIs before this source change.

The 0x450-byte `CItemSelect` owns the base menu, 150 item pointers/flags,
alpha state, two float rectangles, eased cursor/scroll, texture, grid cursor
and row count. Its existing base/default rectangle constructors supply their
initialization. The explicit constructor clears its state, sets the list
rectangle (120, screen-height-266, 0, 200) and item rectangle
(20+list.left, 370+list.top, 44, 55), refreshes item limits and builds the list.
The compiler supplies its vtable and implicit member work.

The caller snapshots the real remaining quadwords and typed top pointer,
attaches that buffer to `MenuItemMainMemory`, and allocates
`QuadwordsFor(sizeof(CItemSelect)) + 2` using the existing utility. It attaches
the texture blocks, captures the first background block, attaches common
textures, aligns the stack and starts background reading. Existing
`MENU_OPEN_USE_ITEM` / `MENU_OPEN_USE_ITEM_B` modes select `itemsel.pac` /
`fishsel.pac` and the latter's mode flag. The two file tests and existing
unsigned size-rounding behavior are retained; no default size is added.
The first message window uses preset 2, border 5 and message 0.

Fresh pn15 canonical/scoped-after controls give 146/15 words. Real rest/top
locals remove the initial stack evaluation difference. The exact class-6
placement row uses `__nw__FUiP1`, `__ct__11CItemSelectFv`, after-inline
conversion and expected count one. Two existing-capability float rows target
`Set__9mgRect<f>Fffff`: binary32 200 (`0x43480000`) evaluate-first and binary32
55 (`0x425c0000`) evaluate-before formal slot 3. Each asserts exactly one
argument. Slot zero is the receiver and slot three is the 44-width sibling.
The rows reproduce retail's 200-before-120 and 55-before-44 materialization.
They select source identities and values, not addresses or ordinals.

Each single float row leaves four words on the rest-first source; their
combination is zero with the exact relocation map. Using sizeof plus the two
reserve blocks, the existing load-mode enums, ordinary path literals, and
removing the unconsumed declarations/markers preserves zero. All 164 other
manifest rows preserve code and exact raw relocation references; all 166
emitted nonselected native functions preserve code, size and binding.
The existing `MenuModeMalloc` promotion remains unchanged.

The 58 relocation entries and 43 resolved call/global/literal checks agree
with retail. Each recovered path literal is twelve bytes plus four retail
alignment bytes. The native weak float setter (info 0x22) reproduces its
0x14-byte retail body at 0x001f3d50. The private data receipt separates exact
ELF-symbol span, current/frozen manifest extent, next-address extent and
independently measured padding; it preserves an earlier mislabeled span
receipt as a historical input instead of treating it as padding evidence.

Receipts, complete type/API evidence, isolated source/profile patches,
compiler traces and nonselected audits are in
`.private/pntc/menusys-residual/`; the final candidate is
`sources/select-sized-literals/menusys.cpp` with `select-only-profile.json`.
This diagnostic result requires full-wrapper, complete-object, PAL and
unrelated-artifact acceptance before the guard or rows are committed.

## MenuItemSelectInit complete acceptance

The selector's manually removed guard is accepted in the final 27-caller
pn15 group: PAL matches retail, all 149 complete object checks pass, and all
306 assembled objects plus 149 source-only objects outside the eighteen
promoted units retain baseline hashes. The selector's complete menusys
object covers 0x1b0cc bytes and 5,885 resolved relocations. Linked main bytes
and memory end equal baseline. Explicit context/objdiff refresh reports
6,776 matched, 86 guarded drafts, ten assembly-only and zero fuzzy. Receipts
are `.private/pntc/receipts/promote-twenty-seven-{final-build,objects,artifacts,progress,coverage}`
with explicit zero statuses. No shared header change is needed for this
promotion; the actual 0x288 symbol-size comment remains a separate proposal.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
