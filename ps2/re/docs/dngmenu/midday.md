# October 8 midday matching

This is a historical probe record. The current native/guarded status is in
[notes.md](notes.md#current-assembly-gaps); later exact matches are documented
in [night-20261008.md](night-20261008.md).

Base: `fe60604`, with upstream `d8bf13c` already merged. The container image is
`chronicletwo_dev:sf-d8bf13c`, with canonical optimization and the existing
Satan's Fiddle profile. The starting coverage is 6,736 matched, 124 guarded,
10 asm-only, and 2 fuzzy functions. The object checker passes 147/149 units;
`nd_meswin::DrawMesWin` and `actscript::_SHOT` account for the unchanged PAL
`.text` discrepancy of 0x26 bytes. No assembly or shared header is changed.

## CMenuTreeMap::Draw

`Draw__12CMenuTreeMapFv` at `0x1F2D10` draws the floor map, animated save
prompt, selected-floor information and medal count, cursor, money board, and
jump question. Its retail extent is 0x730 bytes, including eight bytes of
alignment padding. The native body matches all 460 words with no new profile
row. The complete canonical unit passes: 0x8BC8 checked bytes and 1,182
relocations. The shorter checked-byte total excludes alignment padding that
the next function's alignment supplies; it is not missing retail instructions.

The previously unused numeral alpha is observable: after constructing
`CMenuFont`, the caller assigns `font.alpha`. Its default is zero; when the
information texture exists, the caller reloads twice the current backdrop
alpha after `GetNumberKeta`. The money digits also receive a second white
color setup after setting their source rectangle. Both behaviors are present
in the retail calls and stores and are restored in the native source.

The texture-manager pointer remains live across the drawing calls. Numeral
position and alpha defaults precede the medal lookup. The animated prompt
uses the existing `SetMovePosGyou` inline interface, retaining its X copy as
well as its Y and enable stores. Writing the wrap comparison as
`3.1415927f <= TreeMapSaveHopCount` preserves retail's ordered comparison,
store, self move, and branch sequence; the opposite operand spelling produces
a shorter inverted comparison in this compiler. Cursor opacity uses separate
mode-1 and mode-2 branches.

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
rectangles are separate value temporaries. A 64-byte numeral buffer adds
0x20 to the frame. Named medal-board rectangles occupy early slots and move
the font; making the digit rectangle another argument temporary changes both
its slot and the order of its Set and Color calls. A two-float coordinate
array supplies the final pair of slots. `DngAskMessageDrawFlag` is a signed
byte: retail's final equality check uses `lb`.

Diagnostic progression: 446/460 words initially, 355 after restoring the
missing rendering behavior, 37 after the wrap comparison correction, 25 after
the cursor branches and signed flag, 17 with the 32-byte numeral buffer, and
zero with the named digit rectangle. The guard is removed only after the
complete canonical object check. Existing documentation for `CFont`,
`CMenuFont`, `mgRect<int>`, message positioning, and floor projection supplies
the dependency types; none needs a shared type change.

Receipts are private under `.private/dnginv-midday/`: `TreeDraw.m2c.c`,
`tree-draw-number32-local/`, `tree-draw-exact-canonical.log`, and
`draw-build.log`. The actual-source complete object and baseline comparison
receipts accompany the final lane validation.

Actual-source validation: `draw-objects.log` passes dngmenu and retains the
same two failures (147/149 overall). `draw-compare.log` and `draw-compare.json`
compare allocated section bytes and relocation identities for all 149 saved
baseline objects: only dngmenu changes. All allocated sections of the linked
PAL ELF, including BSS address and size, are byte-identical to the baseline.
`draw-coverage.log`, refreshed through ctx/objdiff and the progress report,
records 6,737 matched / 123 guarded / 10 asm-only / 2 fuzzy functions.

## CDngFreeMap::Draw

`Draw__11CDngFreeMapFv` at `0x1EF730` draws the background, room map, player,
queued room marks, and optional debug readout. The native body matches all
388 words of its 0x610-byte retail extent, including eight bytes of padding.
With both drawing functions native, the canonical dngmenu object passes
0x8BC0 checked bytes and 1,187 relocations. No compiler-profile row is added.

The texture manager and map texture are retained before converting opacity;
the missing texture shares the function exit. Each queued mark constructs
its source rectangle as an argument temporary. Debug drawing retains a
`CFont` pointer to the local menu font, while the first print uses the local
object directly. That first print reads positions from stack offsets 0x114
and 0x118; subsequent prints use offsets 0x94 and 0x98 from the saved font
pointer. Selected-room and floor-save work uses positive nested conditions,
preserving retail's direct branches to the common exit.

The debug panel has a starting Y of 110, retained in `s1`. Room description,
next-floor IDs, root list, and visit count are positioned at Y + 2, +22, +102,
and +122. The flag list advances that Y by 142, then by 20 per row. Replacing
this live base with unrelated absolute positions frees a register too early
and shrinks the frame from retail's 0x280 to 0x270. Restoring the coordinate
relationship reproduces the saved registers and all addressable local slots:
font at 0x80, 256-byte detail text at 0x140, 32-byte line text at 0x240, mark
rectangle temporary at 0x260, and texture-block cache at 0x27C.

The four next-floor queries execute in normal/sun/moon/star order. The first
three have named results; the fourth remains the final sprintf argument.
The locals are declared moon, sun, normal before constructing the font and
assigned in call order. This changes four differing words to zero by
assigning normal to `s2`, sun to `s4`, and moon to `s6`. Declaring them in call
order or at function entry leaves normal and moon exchanged. The existing
dngfloor documentation establishes these as passage-type queries, not grid
direction queries; the named `DNGMAP_ROOT_TYPE` constants follow the retail
debug labels and keep the numeric query values 0 through 3.

ON and OFF use separate strcat calls. A conditional string argument factors
those calls and removes four instructions, shifting the final flag loop and
epilogue. The heading and root-prefix literals preserve their exact retail
Shift-JIS bytes. The final unused `strcat(detail, "NONE")` is retained because
retail executes it after the flag loop.

Progression after restoring the live Y coordinate: 63/388 differing words,
then 7 with separate ON/OFF branches, 4 with direct first-font access, and
zero with the query-result declaration order. Relevant private receipts are
`FreeMapDraw.m2c.c`, `free-query-decls-reversed/`,
`free-exact-canonical.log`, and `free-exact-style.log`; the latter also checks
the named passage constants and inline string bytes.

Actual-source receipts `free-build.log`, `free-objects.log`,
`free-compare.log`/`.json`, and `free-coverage.log` confirm the two drawing
promotions together. The object checker remains 147/149; dngmenu passes
0x8BC0 bytes and 1,187 relocations. Only dngmenu differs from the 149 saved
object fingerprints. Every allocated PAL section is identical to the base,
with the same 0x26 retail `.text` discrepancy and BSS end at 0x1F64A00.
Coverage is 6,738 matched / 122 guarded / 10 asm-only / 2 fuzzy functions.

## Guarded rendering corrections

`DrawRoot` remains guarded at 708/844 differing words, with a 0xCEC-byte
native body against a 0xD30 retail extent. The retail shape predicate at
+0x1F4..+0x248 subtracts five pixels only for shapes 1, 2, 3, 6 and 7.
The former draft included shapes 4 and 5. Passage shape dispatch is an
ordered comparison chain, rather than the draft's dense switch jump table.
The default `RootMarkOffset` pointer precedes the event tint branch.
`RootMarkOffset` has two signed halfword coordinates, size four; its fields
and the shape/icon tables now have purpose comments. All coordinates use
ordinary typed fields and indexed arrays.

Explicitly caching integer color conversions reduces the float lifetimes,
but explicit `fptosi(mark_color)` arguments emit three calls instead of the
single conversion shared by compiler casts. That variant is rejected.
Separate color declarations and a nested positive entry guard also fail to
reproduce retail's parameter/color register map. The retained source uses
its existing casts and guards. Frame size already agrees at 0xF0; root,
marks, opacity, global rectangle and color register assignment still differ,
as do the individual shape-loop schedules. Receipts: `DrawRoot.m2c.c`,
`root-chain-casts/`, and `render-retained/`.

`DrawRoomOne` retains its original typed picture, texture, special-overlay,
glyph and tint locals. Retail adds -42.0f to the room picture's Y coordinate;
restoring that operation changes 461/584 differing words to 459/584, still
0x8C4 versus 0x920 bytes. The frame remains 0x110 versus retail 0x120.
Both save s0 through s8; the discrepancy is local storage, not an omitted
saved GPR. Cached texture numbers, split special-height branches, default
constructed glyph destination plus Set, separate RGB locals, and an overlay
coordinate pair all worsen the result. `RoomGlyph` is four signed halfwords
(texture X/Y and width/height), size eight; `RoomGlyphOffset` is two signed
halfwords, size four. Their fields now have purpose comments. Receipts:
`DrawRoomOne.m2c.c`, `room-negative-only/`, and the `room-*` probe directories.

`DrawDngRoomInfo` remains guarded at 611/744 diagnostic words, 0xBA0 versus
retail 0xB20 bytes. This denominator is the longer body, not the retail
manifest's 712 words. The three panel pieces are separate value arguments
at sp120/sp130/sp140. The two seal rectangles exist together at sp100/sp110;
a pointer selects one and changes its top or left coordinate. The first
activity icon's Y has a retained floating row coordinate across the seal
pulse. Integer icon and message-row coordinates advance separately.
These lifetimes restore the 0x150 frame and f20 through f23 saves.

Retail directly accesses message windows 1, 3, 4, 5, 6 and 7. The added
null checks in the draft are removed; the existing checks for window 0,
window 5 while choosing panel height, and the final medal window remain.
The fishing second line is placed before its message-2 override. Spheda
prize placement checks Europe only on the cleared or bonus-unlocked paths,
and before the cleared highlight is drawn. The final challenge's Japanese
and translated layouts have distinct branches. The selected room is
reloaded for the later activities, as retail does. `DngInfoRoomInfo` is a
`DNGMAP_ROOM_INFO *`, rather than an integer address; its declarations and
stores are consistent throughout this unit. Progress flags use the existing
`DNG_FLOOR_FLAG` names. The first completion icon is the timed-clear icon,
not a geostone icon.

The ordered seal-wrap comparison, 68 + integer Y + 2 expression, region
placement calls and message accesses follow m2c and the retail instructions.
Moving the alpha calculation or changing coordinate declaration order does
not resolve the remaining width/alpha/room/primitive register map. The panel
and seal slots agree, but integer allocation and subsequent instruction
scheduling still differ. Receipts: `DrawRoomInfo.m2c.c`, `info-row-live/`,
`render-retained/`, and `render-format/`.

## LoadDngInfo

`LoadDngInfo__11CDngFreeMapFP9mgCMemoryiiii` remains guarded. The retained
source improves the current baseline from 954/1016 differing words,
0xDE0/0xFE0 bytes, to 914/1016, 0xF68/0xFE0. Its frame is 0x160. Four
candidate room numbers are full integers, not halfwords: retail addresses
sp120..sp12C with word stores, followed by candidate pointers at sp130..sp13C.
That correction places the local arena at spB0 and the filename at spE0.
The 64-byte filename occupies spE0..sp11F before those arrays. Direction and
the four projection coordinates occupy sp14C..sp15C. Their defaults precede
the first room lookup; projection can return without assigning coordinates.

The six dungeon remapping groups are independent comparisons. Capacity is
read before the arena top, file size is rounded with unsigned shifts, and
the player Y correction adds -28.0f. A byte records whether the candidate
search moves forward or backward through room order; retail masks this value
with 0xFF. Explicit zero/one comparisons preserve that behavior.

Passages contain twenty signed-halfword coordinate pairs; room curves
contain ten. Each forward and reverse traversal has its own typed-index
loop. Passage forward traversal advances through the just-stored `next`
member, while its reverse traversal retains the newly allocated node.
A negative passage direction stops traversal. An unsupported cell type
also stops traversal. No raw pointer induction is used.

The passage-pointer reservation contains ten non-null pointers followed
by two zero words (48 bytes total); the room-pointer reservation contains
four non-null pointers followed by four zero words (32 bytes total). These
trailing zeros do not establish additional usable curve entries. Direction
tables contain signed bytes. The two eight-byte room selector/order tables
contain selectors `0,1,2,3,1,0,3,2` and orders `1,0,1,0,0,1,0,1`; no
disabled order occurs in those room tables. Retail uses signed `lb` for both the room-table selector and room
point order. Their generated assembly placeholders currently expose byte
arrays. A private canonical activation reports five declaration conflicts;
these owned-unit tables must be migrated with their native types before a
future promotion. They remain assembly-supplied while the function is guarded.

The first instruction mismatch is the initial negative room test: retail
uses an `slt` followed by a branch; MWCC emits a single `bltz`. The broad
remapping branches, geometry evaluation and route-loop schedules also differ.
Changing the next-room snapshot to int or short does not change the result.
A literal m2c selector formula, a redundant target-null test and a retained
adjacent-room reference worsen the result to 938, 926 and 944 words,
respectively. The independent checks alone give 942, split point loops 916,
and the byte direction 914. Those rejected forms are not retained.
Receipts: `LoadDngInfo.m2c.c`, `load-direction-byte/`, `load-retained/`,
`load-retained.log`, and `load-retained-canonical.log`.

## DngTreeMapInit and the natural constructor

`DngTreeMapInit__FP9mgCMemoryPiii` remains guarded at 55/256 differing words,
0x3F8 native bytes against retail's 0x400. The previous draft is oversized
at 0x610. The inline `CMenuTreeMap` definition now contains its real eight
`CDC2Mes` members' initialization and the eight-window attachment loop.
The base constructor, compiler-generated vtable store and real member-array
constructor expansion are automatic C++. Both allocation sites now match
retail's branch on v0 with the saved-pointer copy in the delay slot, at
0x1F3564/0x1F3568 and 0x1F3684/0x1F3688. No allocation helper or artificial
array is introduced.

The constructor assigns `MenuDngMes[1]->value_space = 16`; offset 0x224C is
numeric value spacing, not `digit_font` at 0x2250. The caller reads remaining
arena capacity before its top and rounds unsigned file sizes to quadwords.
`DngTreeReadNames` is an eight-byte record of two filename pointers, copied
from the zeroed local BSS seed before setting its first name to the
forty-byte filename buffer. Retail's eight-byte load/store copy is retained.
`frametex.img` and `dmap%d.pac` are inline source literals.

A boolean records whether this opening mode uses a separate map rather than
the common menu's cursor. It gives 55 differing words; integer condition
variants give 84 or 85, a bitwise boolean variant 57, and a switch variant
124. The remaining mode test uses xor/slti in MWCC versus retail's two
comparisons. MWCC also forwards the loaded cursor-buffer pointer across
its store instead of reloading the global. That branch is one instruction
short; the suffix from +0x308 agrees. These source/evaluation differences
remain before promotion.

The natural constructor causes MWCC to emit the existing inline
`ClsMes::Init` as a standalone function. A private canonical unit with
only the Init assembly marker removed reports `MATCH Init__6ClsMesFv`;
all 28 reported unit problems belong to the still-mismatching
`DngTreeMapInit`. No shared-header change is needed by that experiment.
The real source retains the Init marker as assigned. Its conditional
removal is a private proposal, requiring exact native tree initialization
and complete-unit validation first. See `clsmes-init-proposal.md`.
Receipts: `DngTreeMapInit.m2c.c`, `tree-init-bool/`, `tree-retained.log`,
and `tree-retained-canonical.log`.

## CMenuTreeMap::Step

`Step__12CMenuTreeMapFv` remains guarded at 1488/1548 differing words,
0x1734 native bytes against retail's 0x1830; the current baseline is
1505/1548. The outer mode switch follows the recovered cases 1, 2, 12,
and default. Result and key-manager lifetimes precede the first initialization
flag. The question-message pointer is acquired after the first two static
initializations and before the fade result. Selection change is an integer
zero/one flag, preserving the non-byte operations. The existing signed-byte
initialization flags, typed selected-room pointer and established grid and
floor-flag enums are retained.

The frame is still 0x110 against retail's 0x130; the draft saves s0..s6,
retail s0..s7. Retail's 72-byte time-text buffer spans spC0..sp107, so
resizing it to repair the frame would change a correctly identified local.
A separately copied message-default array gives 1499 words and is rejected.
No switch conversion of the two mode-12 substate tests is retained: m2c
shows two independent conditions. The remaining saved-register and local
lifetimes require resolution before rematching the later state branches.
Receipts: `TreeStep.m2c.c`, `step-int-selection/`, `step-message-defaults/`,
and `step-retained.log`.

## Small remainders without retained changes

`MsgInit__12CMenuTreeMapFv` remains 7/116 differing words, with matching
0x1D0 extent. Screen height, width and first-line width loads differ at
+0x140..+0x15C. Moving the Y declaration, caching coordinates and expanding
the existing line-position interface leave seven differences. A private
copy of the established `SetMovePosCenteringGyou` interface gives ten,
whether passed the retained Y or its expression. A two-line loop grows to
0x1F0; assigning the save-label Y first gives 23 words. No helper definition,
shared-header patch or profile row is retained. Receipts: `MsgInit.m2c.c`,
`msg-baseline/`, `msg-existing-centering/`, `msg-centering-y-argument/`,
`msg-line-loop/`, and `msg-save-yfirst/`.

`DrawGeoramaMateria__FiPciPii` remains oversized at 0x404 against 0x400,
224/257 detailed words, with matching 0x1D0 frame. Retail spills the right
column at spA0; the draft spills the panel-left position. Width and height
scratch order at sp1C0/sp1C4 and sp1C8/sp1CC also differs. Declaration,
dimension, page, manager and even/odd column variants leave 0x404. Branch
position gives 0x40C; a halfword last-index gives 0x410. A retained font
pointer reduces size to 0x3FC but worsens the word comparison to 234/256.
Those variants are rejected. Reconsider the title/column/page live ranges
and the two dimension scratch pairs together. Receipts:
`DrawGeoramaMateria.m2c.c`, `geo-baseline/`, and the `geo-*` directories.

## Final acceptance

The final canonical build retains the baseline retail-verifier difference:
`.text` differs by 0x26 bytes beginning at 0x0015C5AD; all other sections
pass, and memory ends at 0x01F64A00. The complete checker passes 147/149
units, with the same sole failures in `nd_meswin::DrawMesWin` and
`actscript::_SHOT`. Dngmenu passes 0x8BC0 bytes and 1,187 relocations;
inventmn passes 0xFF2C bytes and 2,794 relocations.

The allocated bytes and relocation identities of all 149 baseline objects
are compared. Only `dngmenu.cpp.o` changes; no inventory or foreign object
changes. Every allocated section of the linked PAL ELF agrees with the
baseline in bytes, address and size, including BSS. Coverage is 6,738
matched / 122 guarded / 10 asm-only / 2 fuzzy, exactly two guarded-to-native
changes: the two Draw functions. Dngmenu is 39/8/1/0; inventmn is 109/7/0/0.
The promotion audit retains ordinary typed locals and indexed arrays through
each whole native function. No assembly, compiler-profile row, shared header
or foreign source edit is made. `ClsMes::Init`'s marker remains intact.

Private final receipts under `.private/dnginv-midday/` are
`final-build.log`, `final-objects.log`, `final-owned-objects.log`,
`final-compare.log`, `final-compare.json`, `final-progress.log`,
`final-coverage.log`, and `final-functions.tsv`. The expected verifier and
all-unit checker nonzero exits are the two baseline failures; they are not
new lane failures. The source-only guarded improvements and their diagnostic
receipts are recorded above and in the inventory midday record.
