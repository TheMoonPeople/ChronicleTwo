# fishing data migration (2026-10-08)

Baseline `e1471bff`: **104 INCLUDE_RODATA / 106 INCLUDE_BSS**, with
**4 / 5145 matched_data** after the normal objdiff/progress refresh.
The unit retains 57 native functions and three guarded allocation functions.
The guarded drafts and `GetUkiWaitTime`'s SF-selected body remain unchanged.

## Typed fishing state

The 104 named reservations use documented native definitions with their
established pointer, integer, float, vector and header aggregate types. All
are file-local except the public `stack_size`. Retail symbol names remain
reachable, including every state object accessed by assembly fallbacks.
`RodData`, `FishData` and `BgmStatus` own 0x18, 0x24 and 0x1C bytes; their
0x20, 0x30 and 0x20 pieces include alignment supplied by the postprocessor.
The casting points are genuine four-float `Vec4` objects.

Primitive ripple/action/sound counters and their signed-byte initialization
flags use the accepted file-local counter form from menucapt, preserving all
existing initialization branches. `font_h_2216` is cleared once by `FalseLoop`
and never read or advanced; the native definition preserves that retail state
without adding a local or helper. Its guard is still a one-byte object.

The six memory managers and two camera-control objects retain their existing
constructor order, with documented file-local binding. Their native static
initializer is unchanged. After this group: **104 / 2 markers**,
**404 / 5145 matched_data**. PAL and 149/149 objects pass; unowned object file
hashes equal the warm baseline. Receipts:
`.private/dataD-r1/fishing-{state,storage}-{build,objects}.log` and
`fishing-state-{progress,metrics}.log`.

## Matched-function resource strings

Twenty-six resource, animation and effect strings are inlined at their native
call sites. Shift-JIS literals preserve their bytes with hexadecimal escapes.
The cursor's native `{"NG", "OK"}` initializer also supplies its pointer
table, so `at_1444__3__DATA` is removed in the same step. Removing only the two
string markers leaves the assembly table's relocations unresolved; the combined
natural initializer passes. Strings consumed by guarded functions remain under
their original symbols.

Each function's string group passes PAL and 149/149 objects. After this group:
**77 / 2 markers**, **412 / 5145 matched_data**. The refresh is recorded in
`.private/dataD-r1/fishing-strings-{progress,metrics}.log`; final string validation
is in `fishing-fish-model-{build,objects}.log`, with preceding function groups
recorded separately. Protected bodies and unowned object hashes are unchanged.

## Fish parameter table

`FishParam` is a file-local `FISH_PARAM[19]`, with declared extent
0x63C = 19 * 0x54. Each row has two strings, an item ID, seven binary32
parameters, 18 bait affinities and four time-band affinities. Decimal float
literals reproduce the exact retail values. All 38 name/model strings are
inlined in their rows; Shift-JIS names retain their original bytes.
`unk_18` remains unnamed beyond its offset because existing analysis establishes
no consumer. No additional field semantics are inferred.

The new `FISH_ITEM_ID` names transliterate the names attached to those rows:
310 is Haguhagu, 320 through 336 are Boubou, Gabura, Nonkii, Kajii, Bakubaku,
Maadangarayan, Gumii, Niiraa, Umadakara, Taaton, Pikkorii, Bon, Hamahama,
Nejii, Den, Hiira and Danshaku Garayan. Row zero has no caught item. Affinity
entries use the existing `FISH_AFFINITY` enum. The integer field layout and
all consumers, including SF-selected `GetUkiWaitTime`, remain unchanged.

After this group: **38 / 2 markers**, **412 / 5145 matched_data**. Native
section credit and executable matching are separate checks; no increase is
reported where the refreshed report grants none. The table and header pass
PAL, 149/149 objects, protected-body comparison and unowned object hashes.
Receipts: `.private/dataD-r1/fishing-param-{build,objects}.log`,
`fishing-param-enums-{build,objects}.log`, and
`fishing-param-{progress,metrics}.log`.

## Script dispatch and existing native templates

The file-local `tag__8[6]` contains five fishing-place tag/handler pairs and
the null terminator. Its strings are inline ASCII literals, and the handler
prototypes and definitions now carry their documented retail local binding.
The existing native hook offset supplies `at_1430__4`; the two switches in
`sgLoopFishing` supply `at_1399__3` and `at_1398__4`. Their markers are removed
without changing those function bodies.

After this group: **29 / 2 markers**,
**412 / 5145 matched_data**. PAL and 149/149 objects pass; protected
bodies and unowned object hashes remain unchanged. Receipts:
`.private/dataD-r1/fishing-tags-{build,objects,progress,metrics}.log` and
`fishing-generated-{build,objects}.log`.

## Local vector initializers

The tension gauge uses local four-float endpoint colors
`{21, 41, 255, 128}` and `{255, 20, 10, 128}`. Initializing them at the
original battle-branch copy points retains both their execution timing and
their stack slots. Walking initializes its cast direction as
`{0, 0, 160, 1}` after camera control; the later event position is declared
where its map-event branch first needs it. Casting-point selection starts with
`{0, 0, 0, 1}`, then sets its Z distance. The associated camera/vector scratch
arrays retain their relative declaration order. No dummy locals are added.

The ripple and splash effects each use a natural zero-filled `Vec4` scale
initializer. Their four-component extents and retail load/store references
establish the two distinct anonymous BSS templates; zero contents alone are
not used to identify them. The corresponding two BSS and four RODATA markers
and their external declarations are removed. Existing unrelated vector copies
remain unchanged.

Each group passes PAL, 149/149 objects, protected bodies and unowned object
hashes. After this group: **25 / 0 markers**,
**1868 / 5145 matched_data**. Receipts under `.private/dataD-r1/`:
`fishing-{tension,walk-vector,select-vector,ripple-template,splash-template}-{build,objects}.log`
and `fishing-aggregates-{progress,metrics}.log`.

## Retained markers

These markers retain exact retail symbols needed by the active assembly
fallbacks, or the strings referenced by their retained pointer table. No
allocation draft or guarded body is changed.

| Marker | Reason |
| --- | --- |
| `lure_file__DATA` | Four lure-model pointers indexed by guarded `sgRestartFishing`. |
| `EsaInfo__DATA` | Eighteen bait item IDs scanned by that guarded function; its eight-byte piece tail is alignment. |
| `at_993__4__DATA` | Its 0x40-byte local lure-path template starts with `sg/fish/`; the guarded function copies this exact symbol. |
| `at_832__6__DATA` | `supina.chr`, referenced by the retained lure table. |
| `at_833__4__DATA` | `kaeru.chr`, referenced by the retained lure table. |
| `at_834__4__DATA` | `lure01.chr`, referenced by the retained lure table. |
| `at_835__4__DATA` | `fork.chr`, referenced by the retained lure table. |
| `at_917__6__DATA` | External-motion resource used by guarded `StepDataLoading` as well as native loading. |
| `at_932__4__DATA` | Shared character-pack name used by all three guarded functions and native loading. |
| `at_1058__3__DATA` | Sound resource used by guarded restart/loading functions. |
| `at_1304__8__DATA` | Resource name used by guarded `StepDataLoading`. |
| `at_1305__5__DATA` | Resource name used by guarded `StepDataLoading`. |
| `at_1306__6__DATA` | Resource name used by guarded `StepDataLoading`. |
| `at_1307__6__DATA` | Lure rod pack name used by guarded `StepDataLoading`. |
| `at_1308__6__DATA` | Float rod pack name used by guarded `StepDataLoading`. |
| `at_1309__5__DATA` | Cursor pack name used by guarded `StepDataLoading`. |
| `at_1310__5__DATA` | System pack name used by guarded `StepDataLoading`. |
| `at_1311__4__DATA` | Resource name used by guarded `StepDataLoading`. |
| `at_1312__2__DATA` | Float pack name used by guarded `StepDataLoading`. |
| `at_1313__2__DATA` | Hook pack name used by guarded `StepDataLoading`. |
| `at_1314__2__DATA` | Resource name used by guarded `StepDataLoading`. |
| `at_1315__4__DATA` | Resource name used by guarded `StepDataLoading`. |
| `at_1316__2__DATA` | Resource name used by guarded `StepDataLoading`. |
| `at_2197__3__DATA` | Caught-fish animation used by guarded `InitSuccess`. |
| `at_2198__3__DATA` | Player success animation used by guarded `InitSuccess`. |

## Storage definition order

The eight constructor-bearing resource objects now precede their first use,
removing the old external declarations that preceded file-local definitions.
Their definition and constructor order remains EsaStack, SndStack, CameraInfo,
UkiCameraInfo, MotionBuff, ReadStack, FishingBuff and FishStack. The complete
initializer and every caller remain byte-identical. No storage or runtime
initialization branch is added. Receipt:
`.private/dataD-r1/fishing-storage-order-{build,objects}.log`.

## Final acceptance

Final state: **25 INCLUDE_RODATA / 0 INCLUDE_BSS**, from **104 / 106**;
**1868 / 5145 matched_data**, from **4 / 5145**. All 57 native functions
remain exact, no function is promoted, and all three guarded drafts and the
SF-selected function are unchanged. Every retained marker is listed above.
No shared-header or toolchain proposal is needed for these accepted changes.

The final full build reports `SCES_511.90: OK`; canonical object checks pass
149/149. Only the three owned object file hashes differ from the warm baseline,
with their allocated bytes and resolved relocations still exact. Final refresh,
coverage and measures use the required objdiff/progress pipeline. Receipts:
`.private/dataD-r1/dataD-final-{build,objects,progress,coverage,metrics}.log`.
The ownership, author and retained-marker audit passes. The expected dirty
`tools/mwccgap` gitlink is unstaged and is not part of any lane commit.
