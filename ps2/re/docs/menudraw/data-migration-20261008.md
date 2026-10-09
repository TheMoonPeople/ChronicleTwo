# Menu drawing data migration

The lane starts at `73f8129d` (checkpoint m22), with the canonical
`chronicletwo_dev:sf-63f7a9e` image. Its warm PAL build is byte-identical,
all 149 complete objects pass, and menudraw has 197 matched native
functions plus the unchanged guarded `CRepairManager::GeneratePoly`.
The refreshed baseline has 79 `INCLUDE_RODATA` markers, 93 `INCLUDE_BSS`
markers, and 4 / 5,741 `matched_data` bytes.

## State objects and extents

The existing header and [unit notes](notes.md) establish the exported
message forms, item pointers, gift-box state, creation-board coordinates,
menu layout manager and captured background texture. Their definitions
use the declared element counts: nine forms, 150 item pointers, three
pairs of gift-box item coordinates, five creation-board floats and 156
display-limit bytes. Local animation counters, texture pointers, colours,
positions and particle arrays have the widths used by their retail
consumers and LOCAL retail binding.

Retail symbol extents are distinct from marker reservations. In
particular, byte flags retain one byte, `use_trans_rect` and the boiled
fish counters retain two bytes, `MenuMainFrame_MoveRate_Cnt` and
`MenuWakuRotCnt` retain one float, `MenuPosData` retains one pointer,
`MakeBoardDrawInfo` retains five floats, and `CommonBoardDrawInfo`
retains its documented 0x2C-byte layout. Native BSS reservation handling
supplies the gap through the next canonical piece; no filler members,
enlarged arrays or fake objects are needed.

Each candidate is checked with a complete PAL build and
`check_objects.py`. SHA-256 comparison against the warm-build object
set additionally requires all 148 other units to stay unchanged.
Only successful candidates are retained.

## Existing compiler templates

The source already provides natural owners for the following markers.
A read-only comparison of the baseline source-only object confirms the
exact declared extents, initialized bytes where applicable, and every
incoming code reference's relocation kind and instruction operands.

| Marker | Native owner | Declared extent |
| --- | --- | --- |
| `at_2265` | `DrawMenuWakuStep`: `float move[6]` | 0x18 |
| `at_4494__2`, `at_4495` | `Func_MenuItemIconSetEffectOne`: `short first[10]`, `second[10]` | 0x14 each |
| `at_4442__2` | `Func_MenuItemBrdPosStep`: `int pos[2] = {0, 24}` | 0x8 |
| `at_2596__2` | Integer `GetPutPosXY` overload: `float pos[2]` | 0x8 |
| `at_3325` | `GetNextMovePos`: `int now[2]` | 0x8 |
| `at_3384` | `Menu3DivideTextureDraw`: `int size[2][4]` | 0x20 |
| `at_4496` | `Func_MenuItemIconSetEffectOne`: `short sparkle[10] = {0}` | 0x14 |
| `at_4727` through `at_4730` | `MenuFrameImageDraw`: four corner RGBA arrays | 0x4 each |

The four corner arrays hold actual `gray` and `alpha` components. The
last element of each `size` row is an implicit zero used for the final
step. Marker sizes of 0x20 for the six-float and ten-short templates
include alignment beyond the declared objects.

## Validation receipts

All receipts are under `.private/dataC-r3/` in the assigned worktree.
`warm-build.log`, `baseline-objects.log`, `baseline-progress.log`,
`baseline-coverage.txt`, `baseline-object-hashes.json` and
`before-metrics.json` establish the initial state. Per-candidate build
and object logs and the migration ledgers record accepted and rejected
steps. The source comparison's `matched_data` metric credits complete
aggregate sections, so it can remain unchanged while individual objects
are migrated.

## State migration checkpoint

All 71 named state reservations are replaced by native typed definitions.
`fish_boiled_effect_tex` is a `mgCTexture *`; `InitFishBoiledEffect` assigns
the texture directly and `DrawFishBoiledEffect` passes it without an
integer-to-pointer cast. Their instructions and relocations remain exact.
The 22 remaining BSS markers belong to compiler templates and the
source-compatibility exception discussed below. RODATA remains at 79
markers, and matched data remains 4 / 5,741 bytes because the aggregate
sections are still incomplete. Native function coverage stays 197 / 198.

`state-final-build.log`, `state-final-objects.log`, `state-progress.log`,
`state-coverage.txt`, `state-metrics.json` and
`state-final-summary.txt` record the passing PAL verifier, 149 / 149
complete objects, and unchanged hashes of all 148 other objects.
`bss-retry.log` records the successful rerun of a private-wrapper
interruption, rather than a source mismatch. `typed-fish-texture` receipts
validate the corrected texture type. The header and the complete guarded
`GeneratePoly` block are byte-for-byte unchanged as text.

`MenuCursorReverseFlag` retains its marker: retail's declared symbol is
one byte, while the shared header exposes `extern int`. Other units use
that declaration. Defining an int would lose the exact declared extent;
changing the public declaration would exceed this lane's source-
compatibility constraint. No unowned header or caller is edited.

## Named initialized tables

The numeric tables use native static definitions in retail order. The
spectrum tables retain 16 triples of short coordinate pairs and 16 rows
of six exact binary32 direction angles. The two item-icon rectangles and
the download-panel's 3-by-3 rectangles use the existing 8-byte
`MENU_SHORT_RECT`; their final two shorts are width and height. The
header's comments describe those dimensions without changing any name,
type, declaration, size or alignment.

The paint table retains nine integer RGBA rows, and the spectrum raster
retains 40 signed-byte offsets. Gift-box window texture coordinates retain
36 shorts. Material-board row rectangles retain two groups of three
four-short rectangles; the button glyph coordinates retain signed bytes,
as retail uses `lb`. The frame-mode count table retains eight floats, the
star colour table nine RGB components, and the fish-bounce rate table
three floats. Icon base offsets retain 23 pairs of shorts; language-group
movement offsets retain three groups of 18 pairs.

`MENU_ITEM_FRAME_PART` names the twelve rectangles constructed by
`MenuItemBrdFrameDraw`: the four corners and paired tiles for each edge.
The top/bottom and side index tables retain 16 and 10 short entries.
The repeated-part primitive table uses `MG_PRIM_SPRITE` and
`MG_PRIM_TRIANGLE_STRIP`, with their existing two- and four-vertex counts.
Level-up colours, gift-box/item-board icon colours, frame centre and main
icon coordinate arrays retain their documented component widths and
counts. Float literals preserve retail's actual approximations rather
than replacing them with ideal angles.

The Geostone text table contains seven pairs of string pointers. Its
native definition owns the exact download/completion literals, including
the `[UNI00e9]` notation, shared space string, and shared English strings.
Native pointer relocations identify each compiler-owned string without
manual pointer words, padding fields or separately named literal objects.

The table checkpoint removes 37 RODATA markers: 25 numeric tables and
the Geostone pointer table plus its eleven strings. Counts are now
42 RODATA / 22 BSS, with matched data still 4 / 5,741 and 197 / 198
native functions. `numeric-ledger.json` and `localization-result.json`
record every successful candidate. The final table receipts are
`tables-final-{build,objects}.log`, `tables-final-summary.txt`,
`tables-progress.log`, `tables-coverage.txt` and `tables-metrics.json`.
The rebuild after the header comment correction passes PAL and all 149
objects; all 148 other object hashes equal the baseline. The header diff
contains comments only.

## Compiler-owned template checkpoint

Nineteen markers are removed without changing their native owners:
ten initialized templates or switch tables and nine BSS templates.
Besides the twelve owner mappings above, `CommonBoardDraw` emits the
five-int row-height initializer and four-int blink-colour initializer;
`MenuItemBrdFrameDraw` emits the scroll-height and layer initializers
and the 12-pointer frame-parts template. The switches in
`SetPartEffectInfoRandFunc` and `MenuMainFrameStep` supply their own
jump tables, retaining real pointer relocations to their case bodies.
No replacement assembly, fake helper or additional state is introduced.

Every marker-only candidate passes the full PAL build, all 149 object
checks and the other-object hash comparison. Counts become 32 RODATA /
13 BSS, while matched data remains 4 / 5,741 and native coverage remains
197 / 198. `implicit-ledger.json` and the nineteen
`implicit-<symbol>-{build,objects}.log` receipts record those checks;
`implicit-metrics.json` captures the refreshed report after the last one.

## Inline literals and aggregate owners

Nineteen remaining strings are inlined in their matched consumers,
including message/icon format strings, menu texture names and repair
background-resource names. Casts from the old unsigned-byte string
objects are removed. Twenty explicit aggregate copies become local
initializers of the documented position, UV, colour, texture-pair,
scroll-bar and effect-preset types. Their declared extents remain exact;
the scroll-bar pointer initializer refers directly to the three typed
rectangle objects. Five unused aggregate declaration types are removed
because their owners already use natural arrays.

`icon_texture_info` contains four `mgCTexture *` entries, retaining its
16-byte PS2 extent. `GetMenuItemIconTexInfo` reads the manager's actual
`item_icon_tex[4][2]` members and returns the selected pointer directly.
The old integer-word view of the manager and integer-to-pointer return
cast are gone. The four null pointers in its local initializer emit the
retail `at_900__4` template naturally. Complete-object comparison remains
exact.

`DrawMenuWakuRect` initializes both two-by-two edge-coordinate records
locally. Merely moving the second initializer to its use preserves the
0x518-byte body but exchanges the named edge and rectangle stack slots,
producing eight differing masked instruction words. Value initialization
produces a 0x538-byte body and 118 differences over the retail body;
that trial is rejected. Passing the scissor rectangle directly to
`SetMenuScissor` makes it a call-argument temporary after the named edge
record, restoring retail's stack layout. The final 0x518-byte body has
zero differences across all 326 instruction words and all resolved
relocations. No added storage, helper, special member or compiler-profile
row is involved. `side-edge-ledger.json` and
`side-edge-direct-rectangle-result.json` record those trials; their failed
source/object copies and build logs are retained privately.

## Retained markers

Every remaining marker is retained for an explicit ownership or API
constraint:

- `at_4933__DATA`: the 18-byte `"repair_powder.chr"` literal used by the
  guarded `CRepairManager::GeneratePoly` and its assembly fallback.
- `at_4934__DATA`: the nine-byte `"info.cfg"` literal used by that same
  protected owner.
- `at_4935__DATA`: the five-byte Shift-JIS motion name
  `94 AD 93 AE 00` used by that same protected owner.
- `MenuCursorReverseFlag`: the one-byte retail flag whose public
  declaration remains `extern int`; its four-byte reservation includes
  three bytes of alignment gap.

The three literal markers and existing declarations preserve their exact
retail symbols. Their natural source form is a literal at the call in
`GeneratePoly`, which this lane is explicitly forbidden to edit. No
separate stand-in literal objects or aliases are introduced. The flag's
public type and callers stay source-compatible. No unowned-file proposal
is required, and no tooling file or image is changed.

## Final result

RODATA markers: **79 -> 3**. BSS markers: **93 -> 1**.
Matched data: **4 -> 4,596 / 5,741 bytes**. The complete native `.data`
(2,112 bytes), `.sdata` (80), `.bss` (2,400) and `.ctor` (4) receive
credit; the remaining markers keep `.rodata` and `.sbss` incomplete.
The byte-identical linked object still includes all retail data.

Native function coverage stays **197 / 198** in menudraw and
**6,776 matched / 87 guarded / 9 assembly-only / 0 fuzzy** overall.
No function is promoted, and the guarded `GeneratePoly` block is unchanged.
The header changes comments only. Every candidate not matching retail is
restored before continuing.

Final receipts: `.private/dataC-r3/final-build.log`,
`final-objects.log`, `final-progress.log`, `final-coverage.txt`,
`final-metrics.json`, `final-validation.json` and `final-summary.txt`.
They require **SCES_511.90: OK**, **149 / 149 complete objects**, and
unchanged hashes for every one of the 148 other objects. The string,
aggregate and typed-icon ledgers retain each individual validation.
