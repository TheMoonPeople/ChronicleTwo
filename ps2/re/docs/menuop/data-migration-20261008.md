# menuop data migration — 2026-10-08

## Baseline and preservation

Checkpoint `1695f2eb`: 153 `INCLUDE_RODATA` and 59 `INCLUDE_BSS` markers;
34 native functions and two guarded drafts. Refreshed data comparison is
4/3,027 bytes. The warm PAL build prints `SCES_511.90: OK`, and all 149
canonical objects pass. Receipts are under `.private/menuop-data-r4/`.

`MenuManualInit` and `CSaveMenuClass::KeyStep` remain byte-for-byte unchanged
as source, including their guards. Their external data identities are retained.
The existing `MenuMapInfoSave` byte-array header declaration remains compatible.
No build scripts, SF rows, unowned units, or generated files are edited.

## Named storage

The first step replaces 34 BSS markers with their exact declared types and
extents. The retail ELF gives one-byte movie/menu flags, two-byte dungeon and
phase values, four-byte pointers and volumes, a six-byte texture-block array,
32-byte picture storage, 52-byte save-row pointers, a 12-byte map snapshot,
and a 28-byte BGM snapshot. Their larger marker extents include alignment gaps;
no source filler or fake object accounts for these gaps. Existing build tooling
supplies verified reservation padding. All unit-local objects use `static`.
The globally visible map snapshot keeps its existing name and type.

`MnOnePictTex` is a real eight-entry `mgCTexture *` array. Its matched consumers
now use pointers directly rather than storing textures as integer addresses.
The pointer and integer representations occupy the same retail storage, and
every changed consumer retains its exact instructions and relocation targets.

After this step: 153 RODATA / 25 BSS markers.
`named-storage-build.log` prints `SCES_511.90: OK`;
`named-storage-objects.log` records 149/149 matching objects.

The refreshed metric after named storage is 288/3,027 matched data bytes
(`named-storage-metrics.json`). Only `menuop.cpp.o` changes its raw file hash.

## Native initializer storage

The manual-movie fade counter is a genuine function-local `static short`
initialized to zero, so MWCC emits its variable and one-time guard naturally.
The manual cursor and option cursor/size pairs use `{0, 0}` initializers, and
the option cursor velocity uses `{-48, 0}`. Their anonymous native templates
replace the assembly reservations without adding source globals.

The existing first-page, turned-page, and mini-game message-value arrays
already generate their own zero templates. The existing `streams[6]` initializer
generates the global/local pointer template at `at_1315__2`; its runtime local
pointers retain the original stores. The save time formatter's existing
function-local `space` pointer generates its own BSS storage and guard.
The native option/save constructors generate their virtual tables directly.
Only their corresponding markers are removed; the guarded manual constructor's
virtual table remains.

This step removes 11 BSS and four RODATA markers: 149 RODATA / 14 BSS remain.
`native-initializers-{build,objects}.log` proves PAL OK and 149/149 exact
objects. No guarded draft is edited.

## Menu lookup tables

The manual unlock table is 47 signed 16-bit event IDs, including its terminal
-1. The boss-area table is 21 map names followed by NULL; it remains exported
locally under `submap_table_1022`, the name used by the guarded manual init.
The seven-entry `dngmap_2627` table contains each dungeon's entrance map name.
Its exact declared size is 28 bytes, with the following zero word belonging
to alignment rather than an eighth entry. The scrollbar-name table contains
three pointers, with its following zero word likewise outside the object.
All table strings are literals in their initializers, including the scrollbar
strings shared with native manual/option layout calls. Named table definitions
appear in retail address order.

The picture-page help width table contains eight language widths. The five
manual list message-class IDs retain their signed-byte representation. Both
option row counters have retail initial value 16.0f; initialization later
selects 14.0f or 16.0f according to language. These are mutable variables,
not folded constants.

Each table step passes the complete build and all 149 canonical objects:
`scalar-tables`, `boss-maps`, `dungeon-maps`, and `scrollbar-names` receipts.
After these steps: 110 RODATA / 14 BSS markers.

## Save resources and guarded consumers

`tbl_2023` is a two-pointer slot cursor action table in small initialized data.
`tp_2083` is a three-pointer visible-row action table in initialized data.
Its former four-entry source declaration included the alignment word, whereas
retail declares only 12 bytes. The native definitions retain both exact
normalized retail names so the guarded save-menu draft and retail fallback
resolve them without source changes. Their five action strings are now
initializer literals.

The nine-byte dungeon-location map conversion table keeps its seven mapped
IDs and two implicit zero entries under `conv_2316`; the larger 24-byte marker
was its declared extent plus alignment. No padding array is introduced.
The icon metadata is a local `SaveIconSet` aggregate initialized by the three
resource filenames. Each existing 0x28-byte `MC_ICON_DATA` entry contains a
32-byte filename, loaded-data pointer and size; omitted members initialize
the pointer and size to zero before the resource lookup fills them. The
retail anonymous 0x78-byte template is emitted by that initializer.

`save-map-conversion`, `slot-actions`, `row-actions`, and `save-icons`
receipts each show PAL OK and 149/149 exact objects. All nine initialized-data
markers are now removed. RODATA / BSS markers are 101 / 14, and the refreshed
data comparison is 732/3,027 bytes (`tables-complete-metrics.json`).

## Manual and option literals

Native manual drawing/playback/layout/cursor functions and option key/layout/
initialization functions now pass their archive filenames, texture names,
form names, action names, format strings and debug labels as literal arguments.
Repeated strings pool at their original retail addresses. Shift-JIS text uses
hexadecimal escapes, with no generated named literal stand-ins. The integer
component pair's fields are `x` and `y`, identifying their horizontal/vertical
purposes without changing its layout.

Shared manual-initialization strings retain their assembly markers and extern
declarations for the untouched guarded draft; native consumers use literals.
The compiler's native copies do not replace those guarded identities.
Each individual function step passes PAL and all 149 objects. Receipts are
`literal-manual-draw`, `literal-CManualMenu-{KeyStep,CalcTex,CalcCursorPosition}`,
`literal-CMenuOption-{KeyStep,CalcTex}`, `literal-MenuOptionInit`, and the
combined `manual-option-literals` check. RODATA / BSS markers are 65 / 14.

## Save and mini-game literals

The save-file time formatter, save initialization/debug drawing and mini-game
save initialization/key handler now use their literal filenames, texture/form
names, formatter strings and script actions directly. Each function is changed
and validated separately. The existing `space` static pointer's initializer
is the literal space, preserving its compiler-generated variable and guard.
Its one-byte character payload and colon share their exact original extents.

Receipts are `literal-{SaveFileListDraw,MenuSaveInit,MenuSaveDraw,SubGameSaveInit,
SubGameSaveKey}-{build,objects}.log`. Every step passes PAL verification and all
149 objects.

## Retained markers

All retained markers belong to the two untouched guarded drafts. No native-only
marker remains. A guarded anonymous literal/template cannot be replaced by its
natural local initializer while its owning function is excluded from native
compilation. Named anonymous stand-ins, hand-authored vtables, and fabricated
initialization guards are not introduced.

The following 26 literal markers remain under their exact retail identities,
with their declarations still available to the owning draft and `INCLUDE_ASM`
fallback. Shared native consumers use literal arguments.

| Literal marker | Owning guarded function | Declared bytes | Reason retained |
| --- | --- | ---: | --- |
| `at_1102` | `MenuManualInit` | 10 | Required retail literal symbol in the guarded body. |
| `at_1103__3` | `MenuManualInit` | 16 | Required retail literal symbol in the guarded body. |
| `at_1104__5` | `MenuManualInit` | 14 | Required retail literal symbol in the guarded body. |
| `at_1105__2` | `MenuManualInit` | 11 | Required retail literal symbol in the guarded body. |
| `at_1106__2` | `MenuManualInit` | 6 | Required retail literal symbol in the guarded body. |
| `at_1107__3` | `MenuManualInit` | 6 | Required retail literal symbol in the guarded body. |
| `at_1108` | `MenuManualInit` | 15 | Required retail literal symbol in the guarded body. |
| `at_1109__2` | `MenuManualInit` | 10 | Required retail literal symbol in the guarded body. |
| `at_2498` | `CSaveMenuClass::KeyStep` | 15 | Required retail literal symbol in the guarded body. |
| `at_2499` | `CSaveMenuClass::KeyStep` | 14 | Required retail literal symbol in the guarded body. |
| `at_2500` | `CSaveMenuClass::KeyStep` | 15 | Required retail literal symbol in the guarded body. |
| `at_2501` | `CSaveMenuClass::KeyStep` | 9 | Required retail literal symbol in the guarded body. |
| `at_2502` | `CSaveMenuClass::KeyStep` | 11 | Required retail literal symbol in the guarded body. |
| `at_2503` | `CSaveMenuClass::KeyStep` | 9 | Required retail literal symbol in the guarded body. |
| `at_2504__2` | `CSaveMenuClass::KeyStep` | 24 | Required retail literal symbol in the guarded body. |
| `at_2505__2` | `CSaveMenuClass::KeyStep` | 8 | Required retail literal symbol in the guarded body. |
| `at_2506__2` | `CSaveMenuClass::KeyStep` | 10 | Required retail literal symbol in the guarded body. |
| `at_2507__2` | `CSaveMenuClass::KeyStep` | 8 | Required retail literal symbol in the guarded body. |
| `at_2508__2` | `CSaveMenuClass::KeyStep` | 9 | Required retail literal symbol in the guarded body. |
| `at_2509__2` | `CSaveMenuClass::KeyStep` | 10 | Required retail literal symbol in the guarded body. |
| `at_2510__2` | `CSaveMenuClass::KeyStep` | 13 | Required retail literal symbol in the guarded body. |
| `at_2511` | `CSaveMenuClass::KeyStep` | 5 | Required retail literal symbol in the guarded body. |
| `at_2512__2` | `CSaveMenuClass::KeyStep` | 7 | Required retail literal symbol in the guarded body. |
| `at_2513` | `CSaveMenuClass::KeyStep` | 7 | Required retail literal symbol in the guarded body. |
| `at_2514` | `CSaveMenuClass::KeyStep` | 12 | Required retail literal symbol in the guarded body. |
| `at_2515` | `CSaveMenuClass::KeyStep` | 6 | Required retail literal symbol in the guarded body. |

Five additional initialized markers remain:

| Marker | Type or role | Reason retained |
| --- | --- | --- |
| `at_2518__2` | Seven-entry next-page switch table. | Destinations belong to the guarded retail `CSaveMenuClass::KeyStep` body; a native switch is unavailable without editing/promoting that draft. |
| `at_2517__2` | Seven-entry current-page switch table. | Destinations belong to the same guarded retail body; hand-written address tables are not natural C++. |
| `__vt__11CManualMenu` | 0x20-byte derived-class virtual table. | Its constructor is only used by guarded `MenuManualInit`; no active native construction emits it, and manual vtable definitions/writes are prohibited. |
| `at_2335__3` | `float[2]` initialized to `{76.0f, 164.0f}`. | Anonymous list-origin template owned by guarded `CSaveMenuClass::KeyStep`; its natural initializer remains inside that unchanged draft. |
| `at_2342` | `int[2]` initialized to `{6, 250}`. | Anonymous scrollbar-range template owned by the same guarded draft. |

All fourteen BSS markers belong to `CSaveMenuClass::KeyStep`:

| BSS marker | Declared bytes | Type or role | Reason retained |
| --- | ---: | --- | --- |
| `FormatCase_1968` | 4 | Function-local format-confirmation counter. | Its natural local static is inside the guarded draft. |
| `init_1969` | 1 | One-time initialization guard for the format counter. | Only the excluded local static can generate this guard naturally. |
| `DarkClonicleFileMax_2004` | 4 | Function-local save-file count. | Its natural local static is inside the guarded draft. |
| `init_2005` | 1 | One-time initialization guard for the file count. | Only the excluded local static can generate this guard naturally. |
| `input_wait_counter_2067` | 1 | Signed-byte input debounce counter. | Its natural local static is inside the guarded draft. |
| `init_2068` | 1 | One-time initialization guard for input debounce. | Only the excluded local static can generate this guard naturally. |
| `at_2115__3` | 8 | Two-integer quest-confirmation value template. | The zero initializer is inside the excluded guarded body. |
| `at_2276` | 8 | Two-integer card-space message value template. | The zero initializer is inside the excluded guarded body. |
| `at_2319` | 4 | Single-pointer map-title template. | The NULL initializer is inside the excluded guarded body. |
| `at_2326__2` | 4 | Chapter message-number initializer. | The zero initializer is inside the excluded guarded body. |
| `at_2327` | 4 | Occupied-row number initializer. | The zero initializer is inside the excluded guarded body. |
| `at_2328__2` | 4 | Occupied-row digit-width initializer. | The zero initializer is inside the excluded guarded body. |
| `at_2330__2` | 4 | Empty-row number initializer. | The zero initializer is inside the excluded guarded body. |
| `at_2331__2` | 4 | Empty-row digit-width initializer. | The zero initializer is inside the excluded guarded body. |

## Final validation and accounting

| Measure | Checkpoint `1695f2eb` | Final |
| --- | ---: | ---: |
| `INCLUDE_RODATA` | 153 | 31 |
| `INCLUDE_BSS` | 59 | 14 |
| `matched_data` | 4 | 732 |
| `total_data` | 3,027 | 3,027 |
| Native menuop functions | 34 | 34 |
| Guarded menuop drafts | 2 | 2 |

167 assembly-backed data markers are removed. The data metric credits complete
aggregate sections; remaining guarded pieces prevent full credit for native
pieces in the same section. Canonical object checks independently prove every
allocated byte and resolved relocation, including all migrated data.

Final receipts: `.private/menuop-data-r4/final-{build,objects,progress}.log`,
`final-coverage.txt`, `final-metrics.json`,
`final-preservation.json`, and `guard-data-symbols.json`. The full PAL build
prints `SCES_511.90: OK`; all 149 canonical objects pass. Guarded source and
the public header are unchanged. No function is attempted or promoted, and no
unowned-file proposal or build-tooling change is needed.

## October 9 follow-up: native KeyStep storage

The accepted nine-pair coordinate-array decision and promotion are documented
in [the menuop lane notes](menuop-r0-20261009.md). KeyStep now compiles natively;
`MenuManualInit` remains guarded and untouched. The preceding retained-marker
tables describe the pre-promotion checkpoint, rather than the current source.

Four initialized markers are replaced by data already emitted from KeyStep:

| Removed marker | Native owner |
| --- | --- |
| `at_2517__2` | Current-page `switch (page)`, seven destinations. |
| `at_2518__2` | Transition `switch (next)`, seven destinations. |
| `at_2335__3` | Local `float list_pos[2] = {76.0f, 164.0f}`. |
| `at_2342` | Local `int scroll_range[2] = {6, 250}`. |

The fourteen BSS markers are replaced by native function-local storage:

| Removed marker(s) | Native owner |
| --- | --- |
| `FormatCase_1968`, `init_1969` | `static int FormatCase = 0` and its compiler-generated one-time guard. |
| `DarkClonicleFileMax_2004`, `init_2005` | `static int DarkClonicleFileMax = 0` and its one-time guard. |
| `input_wait_counter_2067`, `init_2068` | `static signed char input_wait_counter = 0` and its one-time guard. |
| `at_2115__3` | Zero-initialized quest-confirmation `values[2]` template. |
| `at_2276` | Zero-initialized space-error `values[2]` template. |
| `at_2319` | NULL-initialized `title[1]` template. |
| `at_2326__2` | Zero-initialized chapter `item_no[1]` template. |
| `at_2327`, `at_2328__2` | Occupied-row `slot_number[1]` and `slot_width[1]` templates. |
| `at_2330__2`, `at_2331__2` | Empty-row `slot_number[1]` and `slot_width[1]` templates. |

The statics retain their actual four/four/one-byte declarations and one-byte
guards. The existing canonical padding supplies each reservation's alignment
gap. No named template copies, fabricated guards or source padding are added.
The unused file-count value retains its observed one-time initialization.

After this step, menuop has 27 RODATA / 0 BSS markers and 1,056/3,027 matched
data bytes. PAL verification is `SCES_511.90: OK`; complete comparison passes
149/149, with menuop at `0x7DD4` allocated bytes and 2,175 resolved
relocations. Only menuop's raw object hash changes; all other 148 are unchanged.
Receipts are `.private/menuop-r0/native-data-{build,objects}.log`,
`native-data-metrics.json`, and `native-data-object-equality.json`.

## October 9 follow-up: KeyStep literals and remaining markers

All eighteen KeyStep literal markers (`at_2498` through `at_2515`, with their
existing disambiguating suffixes) and their extern declarations are removed.
The native function passes the script actions, error format, slot action and
form-position names as inline literals. `at_2511` contains Shift-JIS bytes
`8F E3 82 D6` (the slot's upward action); the source spells those exact bytes
as hexadecimal escapes. The error format retains its trailing newline.
Repeated cancellation and slot-position strings remain repeated literal uses.

`TreeMapSaveNum` uses the existing declaration in its owning `dngmenu.hpp`;
menuop's duplicate source extern is removed. No dngmenu source/header or other
translation unit is changed.

The following nine markers remain, all required by the unchanged guarded
`MenuManualInit`. There are no remaining KeyStep or BSS markers.

| Retained marker | Payload / declared size | Concrete dependency |
| --- | --- | --- |
| `at_1102` | `op_bg.img`, 10 bytes. | The manual-init assembly's `GetPackFile` call supplies the background image to `EnterIMGFile`. |
| `at_1103__3` | `manumovieworkdm`, 16 bytes. | Its texture allocation names the 256-by-512, eight-bit movie-work texture. |
| `at_1104__5` | `manumoviework`, 14 bytes. | Its screen-sized movie texture allocation stores `ManualMovieTex`. |
| `at_1105__2` | `manual.cfg`, 11 bytes. | Its `GetPackFile` call loads the manual form data for `MenuDataAnalyze`. |
| `at_1106__2` | `op_bg`, 6 bytes. | Its `GetFormInfo` lookup sets `LocalMenuBGForm`. |
| `at_1107__3` | `clip0`, 6 bytes. | Its `GetFormInfo` lookup sets `LocalMenuClipForm`. |
| `at_1108` | `manual_com.cfg`, 15 bytes. | Its archive lookup sets the manual menu's script and script size. |
| `at_1109__2` | `MSG初期化`, 10 bytes in Shift-JIS including NUL. | Its `ExeScript` call runs the manual's initial-message action. |
| `__vt__11CManualMenu` | Derived-class vtable, 32 bytes. | Its inlined manual constructor stores this vtable; no active native construction emits it. |

The fallback requires these exact retail identities while the only native
constructor/string-owning function is excluded. Manual string globals,
hand-written vtables and artificial guard definitions are not introduced.
The excluded manual init's own source, guard and fallback remain identical to
lane entry.

Final lane accounting:

| Measure | Lane entry `dd142f10` | Final |
| --- | ---: | ---: |
| RODATA markers | 31 | 9 |
| BSS markers | 14 | 0 |
| Total markers | 45 | 9 |
| `matched_data` | 732 | 1,056 |
| `total_data` | 3,027 | 3,027 |
| menuop matched / guarded functions | 34 / 2 | 35 / 1 |
| Global matched / guarded / assembly-only / fuzzy | 6,787 / 76 / 9 / 0 | 6,788 / 75 / 9 / 0 |

Thirty-six assembly-backed data markers are removed. The remaining manual
markers prevent complete `.rodata` and `.vtables` section credit; the newly
native KeyStep strings do not increase the aggregate section metric while
those sections are incomplete. Whole-object checks independently establish
their exact bytes, extents and resolved references.

Validation receipts are under `.private/menuop-r0/`:
`literals-build.log`, `final-{build,objects,progress}.log`,
`final-coverage.txt`, `final-metrics.json`, `final-preservation.json`, and
`key-literals.json`.

The final full build prints `SCES_511.90: OK`, and all 149 complete object
checks pass. Menuop remains exact at `0x7DD4` allocated bytes and 2,175
resolved relocations; its KeyStep body is 6,756 bytes with zero differences.
The other 148 raw object hashes and the complete guarded manual-init source
block are unchanged from baseline.
