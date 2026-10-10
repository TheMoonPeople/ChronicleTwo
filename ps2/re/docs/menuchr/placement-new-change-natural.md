# Party-change initializer construction

`MenuCharaChangeInit__FP9mgCMemoryPii` is native and exact without a placement
conversion row.

## Allocation sizes

Retail calls placement new for `CMenuChrCngMenu` at `0x2B9220`, requesting `0x1F80`
bytes from a `0x1FA`-quadword stack allocation, and for `CRepairManager` at `0x2B93DC`,
requesting `0x1EC` bytes from `0x21` quadwords. Both counts are the object's 16-byte
block count plus two: `align16_blocks(sizeof(T)) + 2`. The unit's file-local
`align16_blocks` uses the same if-and-early-return form as the identically named helper in
other matched units. Its retained return statement makes MWCC statement-inline the size
computation, so the enclosing placement expression takes the early allocation-result
test: `beqz v0` with the saved-pointer copy in its delay slot. A literal `0x1FA` keeps
the late form, which copies first and tests the saved register.

`CRepairManager` has no user-declared constructor: its eight `mgCMemory` array elements
occupy `0x24..0x1A4` at stride `0x30`, followed by the model stack at `0x1B4`. Its
implicit construction is class 3. The header asserts `CMenuChrCngMenu == 0x1F80`,
`CBaseMenuClass == 0x110`, `mgCMemory == 0x30` and repair-manager size `0x1EC`. The
palette aggregate at `0x1A80` holds `u32 clut[256]` and the adjacent reserved `0x100`
bytes; `memset(&palette, 0, sizeof(palette))` expresses the retail `0x500` clear.

## Cursor default

`set_cursor` is the `u8` at offset `0x11E` requesting immediate cursor placement;
`MenuLocalLoop` consumes it by calling `MenuSetPos` and clearing it. Retail's constructor
stores 1 immediately after `open_wait = -1` (`+0x11C`), then 0 after the four command-part
pointers. The constructor states both assignments in that order. The same unit's
`CMenuMosSelect` constructor defaults its own `set_cursor` to 1 beside its other state
fields, so the first store is the menu family's default; the later assignment clears it
before the menu opens. Only independent POD stores lie between them.

The first table below measures source forms with a literal `0x1FA` count, which leaves
the late allocation test.

## Source controls

| Candidate | Words | Native size | Relocation offset/type map | Purpose |
| --- | ---: | ---: | --- | --- |
| Original constructor | 236 | `0x4F0` | Different | Ordinary lowering |
| Exact class6 after-inline row | 258 | `0x4E8` | Different | Positive-count semantic control |
| Typed array-only cleanup | 258 | `0x4E8` | Different | Hygienic source without added cursor default |
| Array plus body `set_cursor = 1`, after-inline row | 0 | `0x4F0` | Equal | Superseded row-based zero |
| Array plus `: set_cursor(1)` | 26 | `0x4F0` | Different | Initializer-list control |
| Block-count sizes plus body default, no row | 0 | `0x4F0` | Equal | Accepted source |

## Initializer-list control

`: set_cursor(1)` follows declaration order: base construction, `set_cursor`, then the
two memory members. MWCC stores 1 in the first `mgCMemory::Init` call's delay slot,
before both calls, while retail stores it after them. That control is 26/316 words from
retail (constructor scheduling at `+0xE8..+0x144` and the `-1` register of four later
stores). The body assignment after `open_wait` reproduces retail's order.

Construction selector semantics are documented in [the compiler
design](../satansfiddle/placement-new.md).
