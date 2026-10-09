# October 8 night review fixes

## Retail function sizes

The header's `@size` values describe each function's declared retail symbol
size in `ps2/config/pal/main.symbols.txt`, excluding padding before the next
function. 27 padded tags are corrected. Every tagged symbol in this
header is present in that table, and the complete size audit has no mismatch.

The documentation changes preserve `SCES_511.90: OK` and 149/149 objects.
Receipts: `.private/fixes-r1b/receipts/header-sizes-{build,objects}.log`.

## Declarations and drawing parameters

`DrawRoot` names its mark mask and opacity consistently in the header and
source. `DrawRoomOne` likewise names the unused flag argument, opacity,
and brightness consistently. Their parameter types and retail ABI are
unchanged.

`MsgInit` uses the native `TreeMapSaveDispY` definition and the header's
`TreeMapSaveFlag` declaration. The duplicate `MenuTreeMapStack` declaration
before `DngTreeMapKey` is removed. One forward declaration remains in the
source file responsible for its definition: keeping the definition after
the four rectangle globals preserves their retail static-initialization
order. Data migration already removed the repeated `MenuDngMap`,
`CMenuTreePt` and `MenuCursorDataBuff` externs.

The complete build verifies `SCES_511.90: OK` and 149/149 objects.
Receipts: `.private/fixes-r1b/receipts/dungeon-declarations-{build,objects}.log`.

## DrawRoomOne overlay conversions

Replacing the four overlay `fptosi` calls with `(int)` casts in the same
source order fails matching. The native body shrinks from the retail
`0x914` symbol size to `0x90C`; the positional diagnostic has 236/584
word differences in the `0x920` aligned reservation. Cast lowering moves
conversions into the primitive batch: `Begin` is called at native `+0x61C`,
before the conversions at `+0x64C` and `+0x658`. Retail computes all four
integer corners before beginning that batch.

The complete checker reports 27 dngmenu problems and 148/149 passing
objects; the PAL verifier fails. The explicit calls are retained, with
no source-order or behavior change. Probe receipts:
`.private/fixes-r1b/receipts/room-casts-probe-{build,objects}.log` and
`room-casts-score.log` in the same directory. Restoration is verified by
`room-calls-restored-{build,objects}.log`.

## DrawGeoramaMateria linkage

The retail ELF binds `DrawGeoramaMateria__FiPciPii` at `0x1EEC10` as
LOCAL with size `0x400`. Declaring both the source prototype and definition
`static` gives the same LOCAL binding and size. The function and its caller
remain exact: the complete PAL verifies and all 149 objects pass.
The single documentation block stays on the source prototype.

Receipts: `.private/fixes-r1b/receipts/material-static-{build,objects}.log`.

## LoadDngInfo route data (round 2, finding 14)

The route-pointer tables and their local bases point to signed-halfword
coordinate pairs, read as `[index][0]` and `[index][1]`. The passage and room
point counts are 20 and 10, excluding each table's final `{-1, -1}` pair;
reverse traversal starts at the corresponding count minus one. Candidate
arrays and direction-table widths use `GLID_DIR_NUM`, as do the offsets
selecting the second half of the room selector and order tables.

The signed-byte room orders promote to `int` before subtraction, so the
explicit casts around those operands are unnecessary. Texture loading uses
`MENU_FILE_LOAD_DIRECT`. The parameter names now agree between declaration
and definition. Search and interpolation orders have distinct local names;
each route selector remains its own point counter, and `curve` still precedes
`tail`, preserving the documented register lifetimes.

The typed-pair source passes the complete dngmenu check (0x8B98 bytes,
1,277 resolved relocations). Full build: `SCES_511.90: OK`; all 149 objects
pass. The same unit check and PAL result hold for the remaining scrub edits.

## Opening contexts and message positions (round 2, findings 9 and 10)

`DNG_TREE_MAP_FUNC` names all three results of `CheckDngTreeMapFuncType`.
The save-point request (`MENU_OPEN_DNG_TREE_MAP`) returns SAVE_POINT;
`MENU_OPEN_MAIN_DUNGEON` or a requested dungeon sub map returns DUNGEON;
all other requests return OTHER. Every consumer in this unit, including the
guarded Step draft, uses those result names without changing the `int` ABI.

`MsgInit` uses the existing `SetMovePosGyou` inline for each position/enable
triplet. Its first-line screen X and line width remain separately staged and
shifted in place. The reviewed P13 direct expression fails two complete-object
checks; the staged values are meaningful positioning inputs and are retained.

The `bittable_2134` mask `0x40` is paired with the `TalkMons` debug label.
The shared `DNG_FLOOR_FLAG` enum in `savedatadungeon.hpp` has no such member,
and that header is outside this lane. The mask remains pending an enum-owner
change; the prepared proposal adds `DNG_FLOOR_FLAG_TALK_MONSTER` and substitutes
it in this table, without claiming a more specific gameplay meaning.

`MenuTreeMapStack` already has one forward declaration and one later definition
at m59. The definition's position retains the retail global constructor order,
so finding r0 #20 requires no additional source change.

The actual-source full build accepts the opening-context enum, inline message
positioning calls, table format guards and function separators:
`SCES_511.90: OK`, 149/149 objects, 6,787 perfect functions and zero fuzzy.
