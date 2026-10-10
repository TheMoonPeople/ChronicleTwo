# Menu construction boundaries

`MenuModeMalloc`, `MenuItemDebugKey`, `MenuItemSelectInit` and
`CMenuItemInfo::IsAskExtend` are native and exact. The first three use the
documented [placement policy](../satansfiddle/placement-new.md); `IsAskExtend`
uses `Alloc(align16_blocks(sizeof(CActionChara)) + 2)` with the file-local
early-return block-count helper and needs no placement row.
The extended prompt's retained source lifetimes are described in
[unit notes](notes.md).

## Action-character chain

`IsAskExtend` creates a weapon build-up preview character from its local
stack. `MenuModeMalloc` creates seven menu action characters and the
spectrumisation frame from MenuItemMemory2. Action-character allocations
request 0x105 quadwords for the existing 0x1030-byte CActionChara.

The chain is mgCObject, CObject, CObjectFrame, CCharacter2, then CActionChara.
It performs base/derived initialization, shadow-link clears, CRunScript
construction at +0x6BC, and movement-check initialization at +0x910.
Inline depth eight exposes that actual chain. Direct placement construction
uses the existing constructor; no artificial array or loop changes its
inline class. The statement policy selects the compiler's own allocation
null-test/copy path.

Before the policy, a natural MenuModeMalloc candidate fits 0x3BC but still
differs in the allocator-result branch/delay slot, second construction and
effect argument setup. An earlier IsAskExtend form additionally differs in prompt dispatch
and register assignment. Applying depth eight alone to an earlier
MenuItemDebugKey candidate does not improve its 1208-word residual. These
controls distinguish inlining depth from the construction policy.

## Item-selector boundary

MenuItemSelectInit allocates CItemSelect in 0x47 quadwords for its 0x450-byte
class. Retail default-constructs both mgRect<float> members, whose constructors
already call Set(0,0,0,0); explicit duplicate setters do not belong in source.
The constructor then clears animation, count, coordinates and texture state.

It sets the list rectangle to (120, mgScreenHeight-0x10A, 0, 200), the item
rectangle to (list.left+20, list.top+370, 44, 55), clears top line and cursor,
sets one row, refreshes item-limit flags and builds the item pointer list.
All occur inside allocation success, before the caller's SetTexBlock.

The caller attaches textures, captures the background, attaches common
texture information, aligns its stack and starts background reading.
Mode 9 loads the first menu file; mode 0x16 loads the second. Retail uses
separate tests and leaves size unspecified for other modes. Byte count is
rounded to quadwords with the unsigned remainder rule.

A rejected source initializes size to zero, uses else-if and signed
(size+15)>>4. It improves an earlier masked score but changes the actual
caller tail. A fitting older natural draft still differs at buffer setup,
placement lowering and float arguments. Argument policies keyed to sanitized
retail template names or a standalone constructor are unconsumed: the
verified enclosing source identity is the allocating caller. The accepted
source and scoped construction/floating rows match the complete object and
PAL image.
