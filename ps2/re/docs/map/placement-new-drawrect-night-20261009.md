# Visibility rectangle lists and natural construction

`CMap::CreateDrawRect`, retail 0x15e210, reserves a visibility rectangle and
lists named placed parts whose available world bounds lie entirely inside
the selection box. `mgClipInBox` tests containment, not mere overlap. Both
input boxes receive homogeneous W=1 even if no free slot exists. A selected
node is appended using the existing doubly linked-list behavior.

The existing types remain correct: `MapDrawOffRect` is 0x30, `CMapParts` is
0x310, `mgVu0FBOX` is 0x20 and `CList<CMapParts *>` is 0x10. The pointer-list
constructor invokes its ordinary virtual Initialize specialization; there is
no pointer-payload constructor clear. Construction skips a null placement
result, then the following payload store still dereferences the result as in
retail. No new allocation failure branch, generated special member, helper,
vtable write or replacement assembly is introduced.

Tonight's common brief authorizes real typed array element walks, superseding
the older midday lane's blanket pointer-induction restriction. The retained
source captures `parts = place_parts` once and advances `parts = &parts[1]`
with the actual loop count, while reading the live `place_parts_max` each
condition. The iterator walks the existing `CMapParts[]`. Continue paths
advance the same real element and count. The allocation uses
`sizeof(CList<CMapParts *>) / 16 + 2`, preserving the established three
requested blocks, with the redundant same-type buffer cast removed.

Fresh mandatory m2c analysis and a read-only normal compiler identity witness
establish one class-6 scalar construction with exact caller
`CreateDrawRect__4CMapFP9mgCMemoryP9mgVu0FBOXP9mgVu0FBOXi`, allocator
`__nw__FUiP1`, constructor `__ct__18CList<P9CMapParts>Fv`. The scoped
`after_constructor_inline` row requires and reports one match. Current
29-caller source controls reproduce 112 words /0x1d0, then 111 /0x1d0
with either before- or after-inline timing. Both nonzero controls are
retained. The old row-absent pointer-walk result is not repeated. The
authorized typed walk under after-inline timing reaches zero.

The actual retail and native symbol size is 0x1b8. Its padded layout extent
is 0x1c0, including eight zero bytes. Its seven native named relocation
targets resolve exactly to retail. The list vtable at 0x37b568 names the
initializer at 0x15e3d0; that initializer's symbol size is 0xc within a 0x10
extent. The existing box assignment's actual symbol size is 0x18 within its
0x20 extent, recorded separately as a comment-only header proposal.

The complete native audit preserves all 85 other function payloads, all 84
other diagnostic scores and all 99 other allocated sections, including
data/alignment, type/binding/value/size and named relocations. Four generated
LOCAL static suffixes change; their exact stable typed-object identities are
proved from unchanged referencing functions and same unique definitions.
All six vtables match exactly without aliases. Allocation cleanup and private
selected fallback removal each preserve the exact complete native zero
object. No shared-header edit is required for the source match.

Exact source/profile proposals, normal-name/class witnesses, type and
nonselected-object audits, all controls, commands and hashes are under
`.private/pntc/map-drawrect-natural/`. Tracked promotion still requires the
complete wrapper, game build, all object checks, baseline artifact comparison
and refreshed progress.

The manually unguarded source passes the pn15 clean 31-caller acceptance
group: exact PAL, 149/149 complete units, and map's entire 0x4728 bytes with
418 resolved relocations. All 306 assembled objects and 149 native base
objects outside the nineteen promoted units retain their baseline hashes.
Linked main bytes retain SHA-256
`a103b0461a88e443a3af684cf150c05b5bd355e5a97ab2dc029c4d872bed0811`; the
loaded memory end remains 0x01f64a00. Explicit context/objdiff refresh and
host coverage report 6,780 matched / 82 guarded / ten assembly-only / zero
fuzzy. Receipts are
`.private/pntc/receipts/promote-thirty-one-{clean-build,objects,artifacts,progress,coverage}`
with logs, explicit zero statuses and the artifact JSON. The map unit now
has no guarded functions.

## Current design reference

This dated evidence retains its original measurement scope.
[The consolidated placement-conversion design](../satansfiddle/placement-new.md) owns the current
capability, activation rows, safety requirements, and accepted source status.
