# dngmenu drawing functions: match forms and rejected variants

Durable status is in [notes.md](notes.md). This file keeps the per-function
form findings and the rejected variants for the two `Draw` functions and the
larger drawing routines.

## CMenuTreeMap::Draw

`Draw__12CMenuTreeMapFv` at `0x1F2D10` draws the floor map, animated save
prompt, selected-floor information and medal count, cursor, money board, and
jump question. Its retail extent is 0x730 bytes, including eight bytes of
alignment padding; the native body matches all 460 words with no profile row.

The numeral alpha is observable: after constructing `CMenuFont`, the function
assigns `font.alpha`. Its default is zero; when the information texture exists,
twice the current backdrop alpha is reloaded after `GetNumberKeta`. The money
digits also receive a second white color setup after their source rectangle.

The texture-manager pointer remains live across the drawing calls. Numeral
position and alpha defaults precede the medal lookup. The animated prompt uses
the `SetMovePosGyou` inline, retaining its X copy as well as its Y and enable
stores. Writing the wrap comparison as `3.1415927f <= TreeMapSaveHopCount`
preserves retail's ordered comparison, store, self move, and branch sequence;
the opposite operand spelling produces a shorter inverted comparison. Cursor
opacity uses separate mode-1 and mode-2 branches. The help state is set in a
short-circuit branch, avoiding boolean materialization.

Retail's 0x1B0-byte frame has the following addressable locals:

| Offset | Purpose |
|---|---|
| 0x80 | Menu font, including numeral alpha at 0x110 |
| 0x140 | 32-byte numeral string |
| 0x160 | Named money-digit source rectangle |
| 0x170 | Medal-board shadow argument temporary |
| 0x180 | Medal-board foreground argument temporary |
| 0x190 | Money-board argument temporary |
| 0x1A8 / 0x1AC | Selected-cell cursor coordinates |

The font and numeral buffer precede a named digit rectangle; the three board
rectangles are separate value temporaries. A 64-byte numeral buffer adds 0x20
to the frame. Named medal-board rectangles occupy early slots and move the
font; making the digit rectangle another argument temporary changes both its
slot and the order of its Set and Color calls. A two-float coordinate array
supplies the final pair of slots. `DngAskMessageDrawFlag` is a signed byte:
retail's final equality check uses `lb`.

Diagnostic progression: 446/460 words with the missing rendering behavior,
355 after restoring it, 37 after the wrap comparison, 25 after the cursor
branches and signed flag, 17 with the 32-byte numeral buffer, and zero with
the named digit rectangle.

## CDngFreeMap::Draw

`Draw__11CDngFreeMapFv` at `0x1EF730` draws the background, room map, player,
queued room marks, and optional debug readout. The native body matches all 388
words of its 0x610-byte retail extent, including eight bytes of padding.

The texture manager and map texture are retained before converting opacity;
the missing texture shares the function exit. Drawing is enclosed in the
positive active/alpha/texture condition, using `!(alpha <= 0)` to preserve
unordered-float behavior. Each queued mark constructs its source rectangle as
an argument temporary. Debug drawing retains a `CFont` pointer to the local
menu font, while the first print uses the local object directly: that first
print reads positions from stack offsets 0x114 and 0x118; subsequent prints use
offsets 0x94 and 0x98 from the saved font pointer. Selected-room and floor-save
work uses positive nested conditions, preserving retail's direct branches to
the common exit.

The debug panel has a starting Y of 110, retained in `s1`. Room description,
next-floor IDs, root list, and visit count are positioned at Y + 2, +22, +102,
and +122. The flag list advances that Y by 142, then by 20 per row. Replacing
this live base with unrelated absolute positions frees a register too early
and shrinks the frame from retail's 0x280 to 0x270. The coordinate
relationship reproduces the saved registers and all addressable local slots:
font at 0x80, 256-byte detail text at 0x140, 32-byte line text at 0x240, mark
rectangle temporary at 0x260, and texture-block cache at 0x27C.

The four next-floor queries execute in normal/sun/moon/star order. The first
three have named results; the fourth remains the final sprintf argument. The
locals are declared moon, sun, normal before constructing the font and assigned
in call order, which assigns normal to `s2`, sun to `s4`, and moon to `s6`.
Declaring them in call order or at function entry leaves normal and moon
exchanged. These are passage-type queries (dngfloor), not grid direction
queries; the `DNGMAP_ROOT_TYPE` constants follow the retail debug labels and
keep the numeric query values 0 through 3.

ON and OFF use separate strcat calls. A conditional string argument factors
those calls and removes four instructions, shifting the final flag loop and
epilogue. The heading and root-prefix literals preserve their exact retail
Shift-JIS bytes. The final `strcat(detail, "NONE")` is retained because retail
executes it after the flag loop.

Progression with the live Y coordinate: 63/388 differing words, then 7 with
separate ON/OFF branches, 4 with direct first-font access, and zero with the
query-result declaration order.

## DrawRoot

The retail shape predicate at +0x1F4..+0x248 subtracts five pixels only for
shapes 1, 2, 3, 6 and 7. Passage shape dispatch is an ordered comparison
chain, not a dense switch jump table. The default `RootMarkOffset` pointer
precedes the event tint branch. `RootMarkOffset` has two signed halfword
coordinates, size four.

Explicit `fptosi(mark_color)` arguments emit three calls instead of the single
conversion shared by compiler casts; that variant is rejected. The frame is
0xF0. The exact event tint ordering and type-mark indexing are in
[notes.md](notes.md).

## DrawRoomOne

Retail adds -42.0f to the room picture's Y coordinate. The frame is 0x120 and
saves s0 through s8. `RoomGlyph` is four signed halfwords (texture X/Y and
width/height), size eight; `RoomGlyphOffset` is two signed halfwords, size
four. Cached texture numbers inside the visited branch, split special-height
branches, a default-constructed glyph destination plus Set, and an overlay
coordinate pair all worsen the result; the exact forms are in
[notes.md](notes.md).

## DrawDngRoomInfo

Retail's extent is 0xB20 with two padding nops; the body is 0xB18. The three
panel pieces are separate value arguments at sp+0x120/0x130/0x140. The two
seal rectangles exist together at sp+0x100/0x110; a pointer selects one and
changes its top or left coordinate. The first activity icon's Y has a retained
floating row coordinate across the seal pulse. Integer icon and message-row
coordinates advance separately. These lifetimes give the 0x150 frame and f20
through f23 saves.

Retail directly accesses message windows 1, 3, 4, 5, 6 and 7; null checks
exist only for window 0, window 5 while choosing panel height, and the final
medal window. The fishing second line is placed before its message-2 override.
Spheda prize placement checks Europe only on the cleared or bonus-unlocked
paths, and before the cleared highlight is drawn. The final challenge's
Japanese and translated layouts have distinct branches. The selected room is
reloaded for the later activities. `DngInfoRoomInfo` is a
`DNGMAP_ROOM_INFO *`. Progress flags use the `DNG_FLOOR_FLAG` names. The first
completion icon is the timed-clear icon, not a geostone icon. The seal-wrap
comparison is ordered, and the row origin is `68 + integer Y + 2`.

## LoadDngInfo

The frame is 0x160. The four candidate room numbers are full integers: retail
addresses sp+0x120..0x12C with word stores, followed by candidate pointers at
sp+0x130..0x13C. The local arena is at sp+0xB0 and the 64-byte filename at
sp+0xE0..0x11F. Direction and the four projection coordinates occupy
sp+0x14C..0x15C; their defaults precede the first room lookup, because
projection can return without assigning coordinates.

The six dungeon remapping groups are independent comparisons. Capacity is read
before the arena top, file size is rounded with unsigned shifts, and the player
Y correction adds -28.0f. A byte records whether the candidate search moves
forward or backward through room order; retail masks this value with 0xFF, so
explicit zero/one comparisons are used.

Passages contain twenty signed-halfword coordinate pairs; room curves contain
ten. Passage forward traversal advances through the just-stored `next` member,
while its reverse traversal retains the newly allocated node. A negative
passage direction stops traversal. Retail uses signed `lb` for both the
room-table selector and room point order.

A literal m2c selector formula, a redundant target-null test, and a retained
adjacent-room reference each worsen the result. Changing the next-room
snapshot to int or short changes nothing.

## DngTreeMapInit and the natural constructor

The inline `CMenuTreeMap` constructor contains its eight `CDC2Mes` members'
initialization and the eight-window attachment loop. The base constructor,
compiler-generated vtable store and member-array constructor expansion are
automatic C++. Both allocation sites match retail's branch on v0 with the
saved-pointer copy in the delay slot, at 0x1F3564/0x1F3568 and
0x1F3684/0x1F3688.

The constructor assigns `MenuDngMes[1]->value_space = 16`; offset 0x224C is
numeric value spacing, not `digit_font` at 0x2250. The caller reads remaining
arena capacity before its top and rounds unsigned file sizes to quadwords.
`DngTreeReadNames` is an eight-byte record of two filename pointers, copied
with retail's eight-byte load/store before setting its first name to the
forty-byte filename buffer. `frametex.img` and `dmap%d.pac` are inline source
literals.

A boolean for the separate-map opening modes gives 55 differing words; integer
condition variants 84 or 85, a bitwise boolean 57, and a dense switch 124. The
matching form is the two-case `switch` described in [notes.md](notes.md).

## CMenuTreeMap::Step

The outer mode switch has cases 1, 2, 12 and default. Result and key-manager
lifetimes precede the first static initialization. The question-message
pointer is acquired after the first two static initializations and before the
fade result. Selection change is an integer zero/one flag. Retail's 72-byte
time-text buffer spans sp+0xC0..0x107, so resizing it to repair the frame
would change a correctly identified local. A separately copied message-default
array is rejected; the two mode-12 substate tests are independent conditions,
not a switch.

## MsgInit and DrawGeoramaMateria

For MsgInit, moving the Y declaration, caching coordinates and expanding the
line-position interface leave the +0x140..+0x15C schedule unchanged; a copy of
the `SetMovePosCenteringGyou` interface gives ten words; a two-line loop grows
to 0x1F0; assigning the save-label Y first gives 23 words.

For DrawGeoramaMateria the frame is 0x1D0. Retail spills the right column at
sp+0xA0 and keeps the panel-left position in `s5`. Declaration, dimension,
page, manager and even/odd column variants alone leave 0x404; branch position
gives 0x40C; a halfword last-index gives 0x410; a retained font pointer gives
0x3FC but 234/256 words.
