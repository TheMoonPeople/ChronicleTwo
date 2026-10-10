# Visibility rectangle lists and natural construction

`CMap::CreateDrawRect`, retail 0x15e210, reserves a visibility rectangle and lists named
placed parts whose available world bounds lie entirely inside the selection box.
`mgClipInBox` tests containment, not mere overlap. Both input boxes receive homogeneous
W=1 even if no free slot exists. A selected node is appended using the existing doubly
linked-list behavior.

The existing types remain correct: `MapDrawOffRect` is 0x30, `CMapParts` is 0x310,
`mgVu0FBOX` is 0x20 and `CList<CMapParts *>` is 0x10. The pointer-list constructor
invokes its ordinary virtual Initialize specialization; there is no pointer-payload
constructor clear. Construction skips a null placement result, then the following
payload store still dereferences the result as in retail. No new allocation failure
branch, generated special member, helper, vtable write or replacement assembly is
introduced.

The source captures `parts = place_parts` once and advances `parts = &parts[1]` with the
actual loop count, while reading the live `place_parts_max` each condition. The iterator
walks the existing `CMapParts[]`. Continue paths advance the same real element and
count. The allocation uses `sizeof(CList<CMapParts *>) / 16 + 2`, preserving the
established three requested blocks, with the redundant same-type buffer cast removed.

The row names `map.cpp`, caller
`CreateDrawRect__4CMapFP9mgCMemoryP9mgVu0FBOXP9mgVu0FBOXi`, allocator `__nw__FUiP1` and
constructor `__ct__18CList<P9CMapParts>Fv`, with `after_constructor_inline` and
`expected_matches: 1`. The source using array indexing differs by 112 words;
before/after conversion leaves 111 on that source. The typed iterator and after-inline
policy together are exact.

The actual retail and native symbol size is 0x1b8. Its padded layout extent is 0x1c0,
including eight zero bytes. Its seven native named relocation targets resolve exactly to
retail. The list vtable at 0x37b568 names the initializer at 0x15e3d0; that
initializer's symbol size is 0xc within a 0x10 extent. The existing box assignment's
actual symbol size is 0x18 within its 0x20 extent,

Construction selector semantics are documented in [the compiler
design](../satansfiddle/placement-new.md).
