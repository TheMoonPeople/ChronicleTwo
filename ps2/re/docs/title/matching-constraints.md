# Title input and boot matching constraints

TitleModeKey is native and exact: body `0x9BC` in extent `0x9C0`, with five CalcMenuAdd
control rows described in [the selector note](selector-context-20261008.md).
TitleBootInit is native and exact: body `0xA84` in extent `0xA90`; its allocation
and camera argument requirements are recorded in [notes.md](notes.md#boot-initialization).

## Memory-card snapshots

The memory-card snapshot keeps the card pointers and the inserted-port bytes in
two-element arrays, as the matched `TitleMCCheckKey` in this unit does (`MC_CARD_INFO
*cards[2]`, `u8 inserted[2]`):

```cpp
MC_CARD_INFO       *cards[2];
u8                  inport[2];
cards[0] = &card_manager->card[0];
cards[1] = &card_manager->card[1];
inport[0] = TitleMCCheckInport[0];
inport[1] = TitleMCCheckInport[1];
```

MWCC keeps the constant-indexed elements in registers, but colours them differently from
separate scalars: `inport[1]` takes `s1`, `inport[0]` `s2`, `cards[0]` `s3` and
`cards[1]` `s0`, with both narrowing `andi`s in place, as in retail. The card pointers
are assigned before the port bytes; all six declaration orders of `card_manager`,
`cards` and `inport` give 0 with that assignment order and 6 with the ports assigned
first (`tk-b*`). A port array alone with scalar card pointers gives 13 (`tk-a3`: the
ports flip but the card pointers move to `s2`/`s3`).

The four two-argument fade calls pass their zero limit explicitly
(`CalcMenuAdd(&TitleInfo->menu_alpha, float(-12.0), 0.0f)`); the former file-local
redeclaration with a default argument is removed, and the function uses the
`menucommon.hpp` declaration. The explicit and default forms compile identically and
satisfy the same row counts.

Scalar card/port snapshots leave at least five words after the fade rows. Changing port
capture order can hide the wrong relocation addends under masked comparison. Both
pointer and byte arrays are needed; a port array alone leaves thirteen words. Assigning
ports before the pointers leaves six.

## Boot source constraints

TitleBootInit has LOCAL linkage. Separate signed logo file-size storage uses stack
`+0x2DC`, with subsequent loads at `+0x2D8`. `map_no` is declared before `map_buffer`,
while buffer acquisition precedes SearchMapNo. Remaining read-buffer capacity is bound
before the top pointer for stSetBuffer.

The original draft differed by 56 words. Linkage, size storage and buffer setup reduce
that to 37; map declarations give 30; map-option order gives 27. A scoped zero argument
policy gives 21 on that source. These measurements describe rejected source
alternatives; the native function has zero instruction and resolved-relocation differences.

| Natural source hypothesis | Differing words / 676 |
| --- | ---: |
| Separate map-top initialization; const map-top pointer | 27 each |
| MenuArg reference; capture scene before setup; capture pack before setup; scoped menu setup | 27 each |
| Initialize through the new-character assignment expression | 27 |
| CCharacter2 pointer with explicit CActionChara downcast for Initialize | 27 |
| Unsigned icon-loop counter | 28 |
| Capture size pointer before GetPackFile | 337, shorter `0xA7C` body |
| Declare file pointer before icon pointer | 27 |
| Copy icon size into a scalar after GetPackFile | 336, shorter `0xA7C` body |
| Const icon pointer; allocate directly in memcpy argument | 27 each |
| Prefix increment; while; do-while icon loop | 27 each |
| Separate scene assignment; named texture-block top | 27 each |
| void, const u_int, const void, or byte pointer for icon file | 27 each |
| const int pointee or const size pointer | 27 each |
| Named menu-file pointer | 27 |
| Capture menu pack as a quadword pointer before setup | 36 |

A CCharacter2 pointer cannot call Initialize(NULL): the base Initialize takes no
argument. The explicit derived call is valid but did not improve the score. Construction
conversion details are in [the compiler design](../satansfiddle/placement-new.md).
