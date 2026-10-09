# October 8 data migration

Baseline: `7c7edc2f`, MWCC 3.0/Satan's Fiddle through
`chronicletwo_dev:sf-63f7a9e`. Warm build verifies `SCES_511.90: OK`;
the canonical checker passes 149/149 objects.

The initial source contains 99 `INCLUDE_RODATA` and 42 `INCLUDE_BSS`
markers. Refreshed objdiff data coverage is 4 / 3159 bytes.

## Menu state

The named menu pointers, drawing flags, counters, save-prompt state, and
eight message-window pointers now use their existing documented native
types. The declarations retain byte and halfword widths and retail linkage:
only `TreeMapSaveFlag`, `TreeMapSaveNum`, `TreeMapCallDungeonSubMap`, and
`TreeMapCalledWorldMap` are externally visible. Other definitions are static.

`DngInfoDrawAlpha` is four bytes despite its eight-byte reservation.
Byte and halfword reservations similarly include alignment owned by the
postprocessor; definitions do not represent that padding as extra fields.
Guarded function bodies and declarations are unchanged.

This step removes 29 BSS markers (99 / 13 remain). Data coverage remains
4 / 3159 because anonymous seeds still make the aggregate sections incomplete.

Receipts: `.private/nminv-r2/warm-build.log`, `warm-objects.log`,
`dng-state-build.log`, and `dng-state-objects.log`.

The seal pulse phase and the tree-step direction, previous cell, destination
cell, and four signed-byte initialization flags also have typed static
storage. They retain their retail symbol spellings because guarded assembly
refers to those symbols directly. This removes eight more BSS markers;
99 / 5 remain. `dng-local-state-build.log` and
`dng-local-state-objects.log` confirm the full PAL and 149/149 objects.

## Naturally emitted literals and vtable

The four texture names in `SetTextureInfo`, fourteen debug strings in
`CDngFreeMap::Draw`, four special map destinations, two tree-opening
filenames, the tree cursor name, and the tree-menu vtable now come solely
from their existing C++ definitions. No function body changes are needed.
Each function's marker group and the vtable were built and checked
separately; all six receipts report PAL OK and 149/149 objects.

Markers are now 73 / 5, with
matched data 36 / 3159 bytes. Receipts use
`dng-textures`, `dng-debug-literals`, `dng-jump-literals`,
`dng-opening-literals`, `dng-cursor-literal`, and `dng-vtable` prefixes
under `.private/nminv-r2/`.

## Drawing tables

The passage mark offsets, passage icon coordinates, flat visited-room glyph
rectangles and their destination offsets, special dungeon-six mark offset,
mark animation speeds, dungeon number, player position, floor limits, and
two floor-frame texture tables now have typed native definitions.
Their declared extents match retail, including the five icon coordinate
rows, sixteen glyph halfwords, and seven floor-limit bytes. The flat glyph
layout preserves the matched shared induction in `DrawRoomOne`.

Each of these eleven definitions passes a separate full build and 149/149
object check; receipts use `dng-table-<symbol>` prefixes. The first private
mark-offset trial placed its definition before its source-local row type;
placing definitions at their existing declaration sites resolves that
compile-only issue. No unmatched candidate is retained.

Markers: 62 / 5; matched data: 36 / 3159 bytes.

## Event movement tables

The ten passage paths contain 21 signed-halfword coordinate pairs each,
and the four room paths contain 11 pairs each. The last pair is `{-1,-1}`;
the loader consumes only the first twenty or ten points. Pointer lists
contain ten or four paths followed by a real null terminator. Their declared
extents are 44 and 20 bytes, rather than their 48- and 32-byte pieces.
The passage direction table is 11 by 4 signed bytes; the room selector and
room traversal tables are eight signed bytes each. `DngRoutePointOrder`
describes unavailable, forward, and reverse traversal in the direction data.

All nineteen data definitions and the direction-enum cleanup pass separate
full builds and canonical checks. The bare native names retain retail
symbols used by the then-guarded `LoadDngInfo` assembly. Its later promotion
uses the native definitions and removes the obsolete `__DATA` declarations,
as described in the October 9 section below. Receipts use
`dng-route-<symbol>` and `dng-route-orders` prefixes.

Markers: 43 / 5; matched data: 36 / 3159 bytes.

## Names and remaining native initializers

The page format, loader filenames, four passage names, eight fixed-width
debug labels, eight debug flag masks, and seven first-floor map names now
use literal initializers at their actual uses or typed table definitions.
Shift-JIS bytes use hexadecimal escapes. Pointer-table data retains each
retail literal target, including the separate `d07f01` literal used by the
map-name table. The tree-opening filename pair uses a real null aggregate
initializer, replacing its eight-byte BSS seed. Five medal-icon X
coordinates now have a signed-halfword definition used by guarded assembly.

Seven cleanup steps and the medal table each pass PAL verification and
149/149 canonical object checks. Receipts use `dng-native-<step>` and
`dng-medal-coordinates` prefixes.

## Step markers

The 13 initialized and four BSS markers left after the October 9 dngmenu-r0
round were all referenced only by `CMenuTreeMap::Step`. While Step was
assembly, the small-data ones were reached through numeric `$gp` offsets
(`-0x7EA0`, `-0x7E98`, `-0x7134`, `-0x7130`, `-0x7128`). With Step native,
each comes from its natural source form and every marker is gone
(**13 / 4 -> 0 / 0**); see [stepclean-20261009.md](stepclean-20261009.md).

| Marker | Retail placement | Native form |
|---|---|---|
| `bitTable_2900__DATA` | `bitTable$2900`, `.data` 0x352780, 36 bytes | `static int bitTable[9]` in Step's debug block. |
| `at_3141__DATA` | `.data` 0x3527B0, 32 bytes | Template of the `messages[8]` initializer. |
| `at_3342__DATA` | `.rodata` 0x36DC00 | `ExeScript("MSG_END")`. |
| `at_3343__DATA`, `at_3344__DATA` | `.rodata` 0x36DC08, 0x36DC18 | Shift-JIS and European `99:99` overflow strings. |
| `at_3345__DATA` to `at_3348__DATA` | `.rodata` 0x36DC20 to 0x36DC40 | The four European `sprintf` time formats. |
| `at_3349__DATA`, `at_3350__DATA` | `.rodata` 0x36DC48, 0x36DC50 | Full-width zero and colon. |
| `at_3043__DATA`, `at_3164__DATA` | `.sdata` 0x37C850, 0x37C858 | `put_pos` `{0x3C, 0x118}` and `prize_no` `{41}` initializers. |
| `at_3040__2`, `at_3145`, `at_3199` | `.sbss` 0x37D5BC, 0x37D5C0, 0x37D5C8 | Zero templates of the `name_id`, `challenge_values` and `time_ptr` initializers. |
| `at_3142` | `.bss` 0x1EF7950, 16 bytes | Zero template of `practice_items[4]`. |

The first round ended at **99 / 42 -> 20 / 4** markers with matched data
**4 / 3159 -> 36 / 3159 bytes**. The metric requires entire aggregate
sections, so retained pieces prevent credit for the otherwise native data.
That round promoted no function and changed no profile row.

## October 9 (dngmenu-r0): data freed by promotions

Base `423524f3` (DrawDngRoomInfo and MsgInit native). `LoadDngInfo` is
promoted in the same round; see [night-20261008.md](night-20261008.md).

| Step | Markers removed | Native form |
|---|---|---|
| LoadDngInfo resource names | `at_2682`, `at_2683`, `at_2684`, `at_2685` | The draft's own `"_dn"`, `"dngop_dn"`, `"dt_dn"` and `"dtname_dn"` literals. |
| MsgInit script name | `at_2826` | `ExeScript("MSG_INIT")` in the native `MsgInit`. |
| Floor-information frame tables | `DngInfoMedalNumMsg`, `dngboardbrdtbl_1` | Static `short[12]` definitions beside `dngboardbrdtbl` and `dngboardbrdtbl_2`, in retail order; their `[16]` externs are gone. |

`DngInfoMedalNumMsg` holds the medal-count message position for each
language as X/Y pairs: `(330, 10)` for languages 0–3 and `(330, 20)` for
4–5. `DrawDngRoomInfo` reads `[language * 2]` and `[language * 2 + 1]`.
`dngboardbrdtbl_1` holds three `(u, v, w, h)` texture rectangles for the
frame's lower part when the room has a geostone row, `(58, 6, 24, 50)`,
`(82, 6, 8, 50)` and `(90, 6, 24, 50)`; `dngboardbrdtbl_2` is the shorter
variant without the row. Both retail symbols are LOCAL, 24 bytes; the native
objects are 24 bytes and the postprocessor supplies the eight-byte alignment
tail of each 0x20 piece.

The route-order enum `DngRoutePointOrder` is replaced by `DNGMAP_PATH_ORDER`
in `dngmenu.hpp` (`DNGMAP_PATH_NONE = -1`, `FORWARD = 0`, `REVERSE = 1`). It
merges the draft's forward/reverse enum with the direction data's values.

Each step passes a full build (`SCES_511.90: OK`) and 149/149 canonical
object checks (`dngmenu: 0x8B98 bytes, 1277 relocations`). Receipts:
`.private/dngmenu-r0/{lit,msginit,frame}-{build,objects}.log`.

Markers: **20 / 4 -> 13 / 4**. Refreshed matched data stays **36 / 3159
bytes**, because Step's retained pieces still hold every affected section.
