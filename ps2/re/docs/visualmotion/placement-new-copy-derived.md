# Derived visual copying and generated MDT assignment

`Copy__18mgCVisualMotionMDTFP9mgCMemory` at `0x28E930` has body and extent `0x210`.
`Copy__15mgCVisualFixMDTFP9mgCMemory` at `0x141260` has body and extent `0x190`. Both
are native and exact, using `*copy = *this` through implicit derived assignment.

The constructor chain is Visual -> MDT -> FixMDT -> MotionMDT, with each existing inline
constructor calling its own Initialize. The 0x110 Motion object has the documented 0x50
MDT/Fix base, frame pointer at 0x50, frame id at 0x54, base matrix at 0x58, real aligned
`mgVu0FBOX` at 0x60, actual `bone[32]` at 0x80, weight count at 0x100 and weight pointer
at 0x104. Padding at 0x5C and 0x108..0x10F is not a game member to copy explicitly.

The retail member sequence calls MDT assignment, copies frame/id/matrix, calls the real
nonconst `mgVu0FBOX::operator=`, copies the actual bone array, then shares the weight
count/pointer. This supports naturally invoking the derived generated assignment. No
special member is implemented manually. The genuine user-declared FBOX assignment is a
separate dependency, not a compiler-generated member; its actual 0x18 body lies in a
0x20 layout extent.

Copy reserves `sizeof(mgCVisualMotionMDT) / 16 + 2` memory blocks for the object. For a
positive live material count, its unsigned byte count is rounded upward to 16-byte
blocks in the actual two branches, then two reserved blocks are added. Indexed
assignment of each real `mgMaterial` copies its eight float components and texture
pointer; padding is not copied manually. Geometry, primitive/frame/matrix pointers and
weight data remain shared, while materials have separate storage. The material count and
both real array pointers remain live. No float selector, argument-order change, raw
walk, invented aggregate view, helper or dummy lifetime is used.

## Shared assignment ownership

Implicit derived assignment causes MWCC to emit the MDT base assignment in mg_visual.
Its retail binding is 13, body `0x98`, extent `0xA0`; it copies seven Visual words and
eleven MDT words while preserving vptr and padding. The explicit-base-assignment
alternative scored 97 words with a `0x218` body and emitted no MDT assignment. The
generated derived form requires neither a handwritten special member nor a depth/outline
control.

## Construction policy

| Logical TU | Caller | Constructor | Allocator | Expected matches |
| --- | --- | --- | --- | --- |
| visualmotion.cpp | Copy__18mgCVisualMotionMDTFP9mgCMemory | __ct__18mgCVisualMotionMDTFv | __nw__FUiP1 | 1 |
| mg_visual.cpp | Copy__15mgCVisualFixMDTFP9mgCMemory | __ct__15mgCVisualFixMDTFv | __nw__FUiP1 | 1 |

Both rows use `after_constructor_inline`; ordinary lowering leaves the allocation
branch/copy pair different. Before-inline timing also matches the Motion caller, but
after-inline is the selected policy for the pair.

Construction selector semantics are documented in [the compiler
design](../satansfiddle/placement-new.md).
