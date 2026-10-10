# Native quest-view drawing and initializer analysis

The October 8 Satan's Fiddle row for `menushop.cpp` uses GPR helper mask `0x30`
and FPR mask `0`. No floating-point expression override or header change is
needed for the drawing function.

The retained initializer analysis below describes the implicit-constructor draft.
The current initializer is native: an empty explicit inline `CMenuQuestView`
constructor gives the placement mechanism a witnessed root. The exact source
form and complete-object evidence are in [notes.md](notes.md#quest-view-placement-construction).

## MenuNPCQuestViewDraw

`MenuNPCQuestViewDraw__Fv` draws the quest/scoop memo backing, list fonts,
completion and photograph marks, cursor and scrollbar, optional comments,
and debug record overlay. Its existing natural C++ draft matches all 924
instruction words under the pinned profile, with the retail `0xE70` extent.
Plain-wibo draft checking reports four differences; the canonical wrapper's
compiler state is authoritative.

Removing only this function's guard and retaining both initializer fallbacks
passes canonical compilation, section fixup, and the complete object checker:
`0x5A68` allocated bytes, 1,304 relocations, zero byte or resolved-relocation
differences. The drawing function is supplied by native C++.

## Remaining initializer at c79e57c

MenuShopInit is already native and matched: the genuine arrow_flash array loop
documented in notes.md supplies its required constructor statement shape.
Coverage now lists 29 matched functions and only one guarded draft in the
30-function unit, with no asm-only functions.

MenuNPCQuestViewInit__FP9mgCMemoryPii remains 46/76 differing masked words,
with a 0x128-byte native body and a 0x130-byte retail extent. Its first
placement-new branch/copy difference remains at +0x70. m2c confirms the
menu's base-constructor call and derived vtable initialization, followed by
a separate eight-byte quest-manager allocation and Initialize call.

CMenuQuestView has an uninitialized photo_no array, rather than a homogeneous
array initialization in its constructor. No constructor clear is supported
by retail. Adding a loop over that array would add stores; moving initialization
from InitEnd into the constructor would change the observed call/store order.
Neither is a counterpart of the accepted CShopMenu change. The manual-menu
constructor likewise has no supported member-array initialization to replace.
The established [constructor park](../funcpoint/placement-new.md#constructor-inline-classification)
therefore remains applicable without another spelling-only experiment.

The complete matching-build menushop object passes: 0x5A5C allocated bytes,
1,327 resolved relocations, zero byte or resolved-relocation problems. No
source, header, or SF profile row is changed in this lane. Private receipts:
`.private/menuui/native-before/menushop.o`, its comparison and quest diff,
and `.private/menuui/quest.m2c.txt`.
