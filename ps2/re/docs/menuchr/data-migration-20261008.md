# menuchr data migration (2026-10-08)

Baseline `860067a4`, image `chronicletwo_dev:sf-63f7a9e`:
**355 INCLUDE_RODATA / 79 INCLUDE_BSS**, **4 / 9726 matched_data**.
The seven guarded drafts and all Satan's Fiddle rows are unchanged by this migration.

Current state (October 9): `CMenuMosSelect::KeyStep` is no longer guarded.
It was promoted after this migration, and all of its data is now native
source; see the last two sections and
[the round-three review fixes](review-fixes-r3-20261009.md). Where the
sections below call it "frozen" or "guarded", they describe its state at
that step.
Header declarations remain source-compatible; menudraw is outside this lane.

## Exported character-menu state

Nine reservations use the existing documented header types: `MorattaStack`,
`MenuLoadInfo`, the three party-ring texture pointers, `CharaSndBuffer`,
`MenuCharaBuild2`, `MenuActionChara`, and `MenuLoadItemNo`. The last three
arrays contain seven pointers, seven pointers, and twelve signed halfwords.
Their declared sizes are 28, 28, and 24 bytes. Alignment after the latter
two arrays belongs to the reservation extent, without filler fields.
`D_01F3C7FC` remains the distinct four-byte boundary after `MenuCharaBuild2`.

After this step: **355 / 70 markers**, **4 / 9726 matched_data**.
The full build passes PAL verification and all 149 objects pass with resolved
relocations. Only owned-unit raw object hashes change from the warm baseline.
Receipts: `.private/nmchr-r3/menuchr-exported-{build,objects,progress,metrics}.log`.

## File-local menu state

Thirty-nine named reservations are documented file-local definitions with
their existing consumer types. These hold party-menu palettes and selection
state, monster-menu resources, background character load/slide state, costume
state, book textures and pointers, and the four transformation-effect buffer
arrays. One-byte and two-byte flags retain their exact retail declared sizes;
the existing postprocessor supplies the larger reservation padding.
`MenuMonsterBGInfo` has seven request pointers, matching its 28-byte retail
symbol and the seven-slot initialization loop, rather than the old eight-entry
declaration. Its four-byte piece tail is alignment.

After this step: **355 / 31 markers**, **4 / 9726 matched_data**.
PAL verification and all 149 object checks pass, with all unowned hashes
unchanged. The guarded drafts still reference the same retail symbols.
Receipts: `.private/nmchr-r3/menuchr-local-state-{build,objects,progress,metrics}.log`.

## Monster progression table

`monster_progress_tbl` is a native nineteen-by-five signed-halfword array:
each row contains its badge number followed by four monster forms. Its
190-byte declared extent matches the documented searches and header, and its
two-byte piece tail remains alignment. The existing consumers are unchanged.
After this step: **354 / 31 markers**, **4 / 9726 matched_data**.
PAL and 149/149 objects pass with unchanged unowned hashes; receipts are
`.private/nmchr-r3/menuchr-progress-table-{build,objects,progress,metrics}.log`.

## Party-menu resource and layout strings

The ten resource, form, palette-part, and message-file strings in
`CMenuChrCngMenu::EnterDataMenu` are inline at their uses. Their external
literal declarations and data markers are absent. Every string retains its
retail bytes and references, including shared uses in other native functions.
After this step: **344 / 31 markers**, **4 / 9726 matched_data**.
PAL and all 149 objects pass; receipts are
`.private/nmchr-r3/menuchr-enter-strings-{build,objects,progress,metrics}.log`.

## Party-menu zero aggregate templates

The two party-key integer pairs supply `at_2232` and `at_2289__2` naturally.
Their earlier `SmallPair` wrappers used `{{0, 0}}`; the October 9 cleanup uses
plain arrays with `{0, 0}`, retaining both retail templates. See
[review-fixes-r2-20261009.md](review-fixes-r2-20261009.md).
The star draw's existing center and UV aggregate initializers also supply
`at_2371__4` and `at_2372__4`, so those two fallbacks are removed.
After this step: **344 / 27 markers**, **4 / 9726 matched_data**.
PAL and 149/149 objects pass with unchanged unowned hashes; receipts are
`.private/nmchr-r3/menuchr-party-zero-{build,objects,progress,metrics}.log`.

The eleven party form/part strings in `SetFormPointInfo` are also inline,
including the health gauges, model panels, and formatted command/name parts.
After this step: **333 / 27 markers**, **4 / 9726 matched_data**.
Validation remains PAL OK and 149/149; receipts are
`.private/nmchr-r3/menuchr-party-parts-{build,objects,progress,metrics}.log`.

## Native switch tables and virtual tables

The existing native switches supply `at_3970` (equipment pack loading) and
`at_5197` (costume key handling). The existing monster-selection and
monster-book constructors supply their virtual tables. The native frame
lookup already contains the inline `"light"` string, supplying `at_4517__2`.
All five markers and the unused light-string declaration are removed.
The two virtual tables referenced by guarded initializers remain fallbacks.
After this step: **328 / 27 markers**, **4 / 9726 matched_data**.
PAL and 149/149 objects pass; receipts are
`.private/nmchr-r3/menuchr-generated-{build,objects,progress,metrics}.log`.

## Work-stack adjustment data

`MenuMemoryAdjust` initializes its seven real memory pointers with a null
aggregate and uses the inline `"LOAD STACK"` name. These source forms supply
`at_1083__2` and `at_1104__4` without external template/string declarations.
After this step: **327 / 26 markers**, **4 / 9726 matched_data**.
PAL and 149/149 objects pass; receipts are
`.private/nmchr-r3/menuchr-adjust-{build,objects,progress,metrics}.log`.

## Character equipment load phases

`tbl_992` is a documented native signed-halfword array with twenty entries:
five equipment phases for each `USER_CHARA`. Its exact forty-byte declared
extent includes the observed unused zero entries for monster mode, without
appended filler. `ConvertCharaLoadDataPhase` retains its existing typed indexing.
After this step: **326 / 26 markers**, **4 / 9726 matched_data**.
PAL and 149/149 objects pass; receipts are
`.private/nmchr-r3/menuchr-phase-table-{build,objects,progress,metrics}.log`.

`CMenuMosSelect::CheckLoadBGMonster` now initializes its seven-pointer local
character-target array directly with null pointers, supplying `at_3054__2`.
After this step: **326 / 25 markers**, **4 / 9726 matched_data**.
PAL and 149/149 objects pass; receipts are
`.private/nmchr-r3/menuchr-monster-target-{build,objects,progress,metrics}.log`.

## Localized monster-book page formats

`monstere_file_template` is a native seven-pointer table with inline space,
English, French, German, and Spanish strings. Japanese uses one space;
Italian and Chinese reuse English. The declared 28-byte extent excludes its
four-byte alignment tail. The current named-pointer-table literal binding
accepts the table and all five child strings, unlike the earlier rejected
probe recorded in `midday-book.md`. All seven resolved pointers match retail.
After this step: **320 / 25 markers**, **4 / 9726 matched_data**.
PAL and 149/149 objects pass; receipts are
`.private/nmchr-r3/menuchr-book-format-{build,objects,progress,metrics}.log`.

`monster_type_name` is a native seven-by-twelve pointer table of monster
family labels, with every string inline in its initializer. Japanese has
twelve empty labels; English, French, German, Italian, and Spanish have their retail
labels, including a distinct Italian row; only Chinese repeats English.
The 336-byte declared extent,
all 84 pointers, and all 47 former child-string pieces match. Shared native
empty-string consumers now use the inline empty literal as well.
After this step: **272 / 25 markers**, **4 / 9726 matched_data**.
PAL and 149/149 objects pass; receipts are
`.private/nmchr-r3/menuchr-book-types-{build,objects,progress,metrics}.log`.

`monster_jyakuten` is a native seven-by-eight pointer table of weakness
labels. Its 224 bytes and all 56 pointers match retail, and thirty additional
child-string markers are absent. Accented labels use the retail ASCII
`[UNI00xx]` markup. Japanese has empty labels, Italian has its own abbreviated
labels, and only Chinese repeats the English row.
After this step: **241 / 25 markers**, **4 / 9726 matched_data**.
PAL and 149/149 objects pass; receipts are
`.private/nmchr-r3/menuchr-book-weakness-{build,objects,progress,metrics}.log`.

## Monster grid dimensions

`max_3170` and `viewnum_3171` are two-integer arrays, rather than scalars.
Their values are four columns and three rows for both total and visible
badge-grid size. Documented grid dimension enums name those values, and
`KeyNormalMode` passes the arrays directly to the existing pointer interface.
Both eight-byte objects match without padding or type reinterpretation.
After this step: **239 / 25 markers**, **4 / 9726 matched_data**.
PAL and 149/149 objects pass; receipts are
`.private/nmchr-r3/menuchr-grid-{build,objects,progress,metrics}.log`.

## Monster selection, model and book strings

Thirty-two additional strings are inline in their native consumers: monster
selection form/part names, box resource/configuration names, monster badge
labels, monster model/sound filename formats, book resources, and its debug
label. Every per-function group passes PAL and all 149 objects independently.
Shared strings retain their single retail identity and all original references.
After this group: **207 / 25 markers**, **4 / 9726 matched_data**.
Receipts: `.private/nmchr-r3/menuchr-monster-strings-00` through `-07`,
with `-{build,objects,progress,metrics}.log`, and `monster-string-batch.log`.

## Party menu strings

Thirty-nine party-menu form, resource, part, and debug strings are inline in
native consumers. This includes the character display resources and shared
empty-page state labels. Ten per-function groups independently pass PAL and
all 149 object checks; guarded draft bodies are unchanged by this migration.
After this group: **168 / 25 markers**, **4 / 9726 matched_data**.
Receipts: `.private/nmchr-r3/menuchr-party-strings-00` through `-09`,
with `-{build,objects,progress,metrics}.log`, and `party-string-batch.log`.

## Character loading resource strings

Seventeen resource strings are inline in twelve native consumer groups: sun
and moon frame names, the weapon frame, sound/debug labels, character and
ridepod resource names, model suffixes, outline texture formats, and background
load configuration names. Shared suffix users still resolve to one retail
literal. Each group passes PAL and all 149 object checks independently.
After this group: **151 / 25 markers**, **4 / 9726 matched_data**.
Receipts: `.private/nmchr-r3/menuchr-loading-strings-00` through `-11`,
with `-{build,objects,progress,metrics}.log`, and `loading-string-batch.log`.

## Party menu numeric tables

Five native tables replace their fallbacks: seven background-request flags,
five cursor reversal bytes, the five-by-eight command transition table, four
signed-halfword character message numbers, and three outcome sound IDs.
The transition, message and sound tables remain reachable by their exact
retail names from the frozen character-change draft. All declared extents,
payloads and resolved relocations match without source padding.
After this group: **146 / 25 markers**, **4 / 9726 matched_data**.
Each table passes PAL and 149/149 objects independently; receipts are
`.private/nmchr-r3/menuchr-party-tables-00` through `-04`, with
`-{build,objects,progress,metrics}.log`, and `party-table-batch.log`.

## Monster numeric tables

Six native definitions supply monster-selection and book background-request
flags, four badge-grid edge overrides, ten parameter display indices, ten
growth title message numbers, and fourteen resistance/weakness display masks.
The zero-valued override array retains the retail initialized section. The
mask table's fourteen entries are its declared 56-byte payload; its separate
eight-byte tail remains alignment. The monster-selection code then
resolved the parameter and title tables under their retail names; both are
now function statics of `CMenuMosSelect::KeyStep`.
After this group: **140 / 25 markers**, **4 / 9726 matched_data**.
Each table independently passes PAL and 149/149 objects; receipts are
`.private/nmchr-r3/menuchr-monster-tables-00` through `-05`, with
`-{build,objects,progress,metrics}.log`, and `monster-table-batch.log`.

## Costume numeric tables

Five native definitions supply seven costume background-request flags, three
load phases, the four-byte tile colour, three equipment slot indices, and
seven localized help-panel widths. Mutable table definitions preserve the
retail loads; the previous const equipment-table probe changes those loads
and is not repeated. Guarded costume loading still resolves its request table
by the retail name.
After this group: **135 / 25 markers**, **4 / 9726 matched_data**.
Each table passes PAL and 149/149 objects independently; receipts are
`.private/nmchr-r3/menuchr-costume-tables-00` through `-04`, with
`-{build,objects,progress,metrics}.log`, and `costume-table-batch.log`.

## Background load index tables

Three native signed-byte tables supply alternate model directory selection,
six ridepod load phases, and the four-by-seven mapping from party load slots
to temporary scene character slots. The scene conversion table has a genuine
28-byte declared payload, including its negative absent-slot sentinels.
After this group: **132 / 25 markers**, **4 / 9726 matched_data**.
Each table passes PAL and 149/149 objects independently; receipts are
`.private/nmchr-r3/menuchr-loading-tables-00` through `-02`, with
`-{build,objects,progress,metrics}.log`, and `loading-table-batch.log`.

## Native local aggregate initializers

Ten accepted conversions supply nine initialized objects and nine BSS
templates from natural local initializers:

- Character load completion initializes two seven-pointer scene lists and
  one eight-pointer load-target list.
- Ridepod completion initializes its six-pointer scene and stack lists and
  seven-pointer menu list. The initialized menu stack pointers select
  `MenuActionCharaBuffer` entries 0, 1, 2, 2, 3 and 2.
- Character change initializes the genuine 64-byte filename buffer with
  `"chrchg0.pac"`; character loading initializes seven path-category bytes.
- Quick-change loading initializes its nine-integer wanted list.
- Monster completion initializes seven scene pointers, three target pointers,
  and three stack pointers. Its two non-null stack pointers both address
  `MenuActionCharaBuffer[5]`, matching retail's `+0xF0` relocations.
- Sound entry initializes a four-byte signed map `{3, 3, 1, 0}` directly,
  replacing the float copy cast without changing instructions.
- NPC positioning initializes the existing SDK `sceVu0FVECTOR` with
  `{14.0f, 0.0f, 0.0f, 1.0f}`. The SDK's vector alignment matches retail,
  and the `MenuPositionVector` copy overlay is absent.
- Costume defaults initialize four integer IDs `{0, 0, 0, -1}` directly.
  The former quadword union is absent; the fourth value is inside the real
  16-byte declared initializer, rather than appended source padding.
- Monster book information initializes its two 32-byte area names and
  eight-integer weakness list directly. Both quadword-copy overlay types
  and their casts are absent.

Named array order is preserved when a declaration moves to its initializer.
After this group: **123 / 16 markers**, **4 / 9726 matched_data**.
Every accepted conversion passes PAL and 149/149 independently; the final
restored state also passes. Receipts use `.private/nmchr-r3/menuchr-` plus
`character-targets`, `ridepod-targets`, `character-menu-file`,
`character-paths`, `load-wanted`, `monster-targets`, `sound-stacks`,
`npc-position`, `worn-costumes`, or `monster-book-info`, with
`-{build,objects,progress,metrics}.log`. The group receipt is
`aggregate-batch.log`; the final receipt is `menuchr-aggregates-final`.

The grouped debug-buffer conversion preserves native instruction words but
fails BSS data naming: an eight-byte `at_970` template stays unnamed where
`at_2232` is required. The first two-name pointer-array probe also leaves
instructions unchanged, but its first pointer is wrong: retail requires a
single-space string (`at_2286`), followed by the empty string (`at_2287`);
the probe incorrectly uses two empty strings. Both attempts are restored.
Failed source checkpoints, object snapshots, focused checks, PAL section
differences and instruction comparisons are under `menuchr-debug-templates-*`
and `menuchr-party-name-pair-*`. Instruction masking cannot validate data
pointer destinations; the resolved-relocation check rejects the wrong pair.

## Named pointer tables and their child literals

Nine native pointer tables supply the party gauge label parts, localized
monster-selection help, badge numeric and item-number label parts, character
and monster resource directories, localized costume help, and the two main
characters' model/configuration filenames. Forty-three child string markers
are also absent; their bytes and `R_MIPS_32` destinations come from the native
inline initializers. `get_stringtbl_3557` then stayed reachable under its retail
symbol from the guarded monster-selection method (it is now the function
static `get_stringtbl` of `CMenuMosSelect::KeyStep`); `tbl_3725` is consumed only
by the native `MenuMonsterBoxDraw` function.
After this group: **71 / 16 markers**, **4 / 9726 matched_data**.
Each accepted table passes PAL and 149/149 independently, and the restored
final state passes. Receipts are `.private/nmchr-r3/menuchr-pointer-tables-01`
through `-09`, with `-{build,objects,progress,metrics}.log`, plus
`menuchr-pointer-tables-final` and `pointer-table-batch.log`.

The four-pointer townsperson command-cost table `tbl_1233` is restored.
Its natural file-scope definition leaves all native instruction words intact,
but reproduces the unnamed `at_2232` BSS template seen in the debug-buffer
attempt. Receipt `menuchr-pointer-tables-00-*` records the original source,
linked/native objects, section differences and the focused object check.


## Initialized menu state and camera defaults

Four native scalar definitions retain their signed `-1` sentinel: the current
sound character, pending monster model, pending main character, and pending
main-character monster. The monster selection camera position and reference
are native SDK vectors `{0.0f, 0.0f, 100.0f, 1.0f}` and
`{0.0f, 9.0f, 0.0f, 1.0f}`. The named information configuration buffer has
its genuine ten-byte declared capacity and inline `"info.cfg"` initializer.
All seven definitions keep the existing interfaces and retail symbol names.
After this group: **64 / 16 markers**, **4 / 9726 matched_data**.
Every definition independently passes PAL and 149/149; receipts use
`.private/nmchr-r3/menuchr-named-` plus its symbol name, with
`-{build,objects,progress,metrics}.log`, and `named-data-batch.log`.

## Item name pointer initializer

The native two-pointer array in `MenuLocalLoop` initializes with `{" ", ""}`,
matching the retail `R_MIPS_32` targets `at_2286` and `at_2287`. The first
pointer is later replaced by the item's name when the item exists. The
`NamePair` wrapper and its generic fields are absent; the existing setter
receives the real pointer array directly.
After this step: **63 / 16 markers**, **123 / 9726 matched_data**.
The complete small initialized-data section now receives progress credit.
PAL and all 149 objects pass; receipts are
`.private/nmchr-r3/menuchr-party-pair-corrected-{build,objects,progress,metrics}.log`.

## Debug text buffer initializers

The three 128-byte debug lines use nested zero initializers `{{0}}`. The
512-byte character-name block and 256-byte townsperson text block initialize
with their actual inline text and retain their full declared buffer capacities.
All five fallback templates are absent. The zero buffers were checked one at
a time, separately from the earlier grouped string-spelling probe.
After this group: **61 / 13 markers**, **123 / 9726 matched_data**.
PAL, all 149 objects, unchanged unowned hashes and frozen-source hashes pass.
Receipts: `.private/nmchr-r3/menuchr-debug-one-at_2674`, `-at_2675`,
`-at_2676`, and `-at_2691`, plus `menuchr-debug-complete`, with
`-{build,objects,progress,metrics}.log`. The last text conversion's original
checks also pass; its validation-summary command failed independently, so
`menuchr-debug-complete` supplies the complete final receipt.

## Townsperson command cost parts

The four cost-label pointers are a documented function-local static table in
`EnterDataMenu`, using the retail base name `tbl`. Its four inline child
literals generate the exact `tbl_1233` pointer destinations. This natural
scope replaces the earlier rejected file-scope probe without adding a helper
or changing the caller's instructions.
After this step: **56 / 13 markers**, **123 / 9726 matched_data**.
PAL, all 149 objects, unowned hashes and frozen-source hashes pass; receipts
are `.private/nmchr-r3/menuchr-scoped-party-table-{build,objects,progress,metrics}.log`.


## Shared native and guarded script literal

The native life-update consumer inlines the nine-byte Shift-JIS end-processing
script label. Its literal receives the retail symbol `at_2307`, so the then
frozen monster-selection method's assembly and its C++ declaration resolved
that same object. `CMenuMosSelect::KeyStep` now writes the same literal
inline; MWCC pools the two uses into the one `at_2307` object.
After this step: **55 / 13 markers**, **123 / 9726 matched_data**.
PAL, all 149 objects, unowned hashes and frozen-source hashes pass; receipts
are `.private/nmchr-r3/menuchr-shared-script-string-{build,objects,progress,metrics}.log`.

## Tooling evidence and unapplied proposal

Read-only object analysis identifies why the earlier debug-group and
file-scope command-table probes lose the unrelated native `at_2232` template.
The linked postprocessor initially projects raw compiler `@digits` names to
`at_digits`. An unrelated initialized literal named `@2232` therefore appears
to be a competing definition of the real eight-byte BSS template. The BSS
naming pass rejects that template before the later literal pass assigns the
string its correct retail name. In the command-table native snapshot the
string is `"dungeon/robo/"` and the real BSS template is `@944`; in the debug
snapshot the string is `"_menu"` and the BSS template is `@970`. The existing
BSS selector identifies the right template on both later processed objects.
`tbl_1233` itself has the exact four pointer destinations in the failed object.

`.private/proposals/nmchr-native-data-provenance.patch` proposes preserving
raw local `@digits` provenance before projection in linked postprocessing and
objdiff preparation. Only compiler counters receive temporary matcher keys
outside retail and explicit source names; all existing extent, byte, real
consumer, relocation and competing-definition checks remain in place. Real
source `at_N` identifiers and fallback storage retain their names. This is an
**untested, unapplied proposal** for the tooling owner. Neither build script
was changed. The companion `.txt` records evidence and scope. The final source
conversions pass with the current tooling and do not tune compiler counters.

Removing `D_01F3C7FC` was also rejected and restored. The canonical piece map
keeps its unreferenced four-byte boundary distinct from the genuine 28-byte
`MenuCharaBuild2` array. Omitting the marker shifts following BSS definitions;
the native array cannot absorb that separate piece under the current policy.
Adding an eighth pointer or a filler field would misrepresent the retail
object. Receipts: `.private/nmchr-r3/menuchr-build-array-gap-*`.

## Final retained-marker inventory

Every remaining marker is listed below. Frozen methods require their existing
compiler-generated strings, local aggregate templates, static state, guards
and virtual tables under the same retail symbols. Emitting these naturally
requires changing those bodies, which this round forbids. None has a remaining
native C++ consumer. The explicit BSS boundary has the separate tooling reason
above. No anonymous template is replaced with an invented file-global object.
Identical text in a differently sized native buffer is not the same retail
object: `at_2595__2` is a 12-byte filename literal rather than the native
64-byte filename initializer, and `at_3692` is a nine-byte literal rather than
the named ten-byte `menu_infocfgname` array.

Every row naming MosSelect::KeyStep is gone since: its literals, templates,
static and guard are native (see the last two sections).

| Marker | Kind | Address | Declared bytes | Retention reason |
| --- | --- | --- | ---: | --- |
| `at_3481` | RODATA | `0x00359210` | 32 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_1361` | RODATA | `0x00374238` | 11 | Literal/local initializer in frozen ChrCng::LoadBGNPCModel. |
| `at_2003__2` | RODATA | `0x00374258` | 10 | Literal/local initializer in frozen ChrCng::KeyChangeMain. |
| `at_2004__3` | RODATA | `0x00374268` | 13 | Literal/local initializer in frozen ChrCng::KeyChangeMain. |
| `at_2005__2` | RODATA | `0x00374278` | 14 | Literal/local initializer in frozen ChrCng::KeyChangeMain. |
| `at_2006__2` | RODATA | `0x00374288` | 11 | Literal/local initializer in frozen ChrCng::KeyChangeMain. |
| `at_2007__2` | RODATA | `0x00374298` | 11 | Literal/local initializer in frozen ChrCng::KeyChangeMain. |
| `at_2008__2` | RODATA | `0x003742A8` | 4 | Literal/local initializer in frozen ChrCng::KeyChangeMain. |
| `at_2009` | RODATA | `0x003742B0` | 4 | Literal/local initializer in frozen ChrCng::KeyChangeMain. |
| `at_2010` | RODATA | `0x003742B8` | 8 | Literal/local initializer in frozen ChrCng::KeyChangeMain. |
| `at_2011` | RODATA | `0x003742C0` | 14 | Literal/local initializer in frozen ChrCng::KeyChangeMain. |
| `at_2012` | RODATA | `0x003742D0` | 9 | Literal/local initializer in frozen ChrCng::KeyChangeMain. |
| `at_2013` | RODATA | `0x003742E0` | 8 | Literal/local initializer in frozen ChrCng::KeyChangeMain. |
| `at_2014` | RODATA | `0x003742E8` | 10 | Literal/local initializer in frozen ChrCng::KeyChangeMain. |
| `at_2015` | RODATA | `0x003742F8` | 12 | Literal/local initializer in frozen ChrCng::KeyChangeMain. |
| `at_2016` | RODATA | `0x00374308` | 11 | Literal/local initializer in frozen ChrCng::KeyChangeMain. |
| `at_2017` | RODATA | `0x00374320` | 19 | Literal/local initializer in frozen ChrCng::KeyChangeMain. |
| `at_2018__2` | RODATA | `0x00374338` | 11 | Literal/local initializer in frozen ChrCng::KeyChangeMain. |
| `at_2019__2` | RODATA | `0x00374348` | 7 | Literal/local initializer in frozen ChrCng::KeyChangeMain. |
| `at_2020__2` | RODATA | `0x00374350` | 20 | Literal/local initializer in frozen ChrCng::KeyChangeMain. |
| `at_2021__2` | RODATA | `0x00374368` | 11 | Literal/local initializer in frozen ChrCng::KeyChangeMain. |
| `at_2022` | RODATA | `0x00374378` | 10 | Literal/local initializer in frozen ChrCng::KeyChangeMain. |
| `at_2023` | RODATA | `0x00374388` | 15 | Literal/local initializer in frozen ChrCng::KeyChangeMain. |
| `at_2595__2` | RODATA | `0x00374478` | 12 | Literal/local initializer in frozen MenuCharaChangeInit. |
| `at_2596__3` | RODATA | `0x00374488` | 9 | Literal/local initializer in frozen MenuCharaChangeInit. |
| `at_3685` | RODATA | `0x00374868` | 10 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3686` | RODATA | `0x00374880` | 17 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3687` | RODATA | `0x003748A0` | 19 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3688` | RODATA | `0x003748C0` | 17 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3689` | RODATA | `0x003748E0` | 19 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3690` | RODATA | `0x00374900` | 21 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3691` | RODATA | `0x00374920` | 19 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3692` | RODATA | `0x00374938` | 9 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3693` | RODATA | `0x00374948` | 15 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3694` | RODATA | `0x00374960` | 22 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3695` | RODATA | `0x00374980` | 17 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3696` | RODATA | `0x003749A0` | 20 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3697` | RODATA | `0x003749B8` | 9 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3698` | RODATA | `0x003749D0` | 19 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3699` | RODATA | `0x003749F0` | 17 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3700` | RODATA | `0x00374A08` | 15 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3701` | RODATA | `0x00374A18` | 9 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3702` | RODATA | `0x00374A30` | 17 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3703` | RODATA | `0x00374A50` | 16 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3704` | RODATA | `0x00374A60` | 3 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3705` | RODATA | `0x00374A68` | 5 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3706` | RODATA | `0x00374A70` | 4 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3707` | RODATA | `0x00374A78` | 5 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3708` | RODATA | `0x00374A80` | 5 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_5051` | RODATA | `0x00374D28` | 12 | Literal/local initializer in frozen Costume::LoadMenuData. |
| `at_5052` | RODATA | `0x00374D38` | 8 | Literal/local initializer in frozen Costume::LoadMenuData. |
| `at_5053` | RODATA | `0x00374D40` | 7 | Literal/local initializer in frozen Costume::LoadMenuData. |
| `at_5839` | RODATA | `0x00375248` | 5 | Literal/local initializer in frozen MosBook::KeyStep. |
| `__vt__15CMenuCostumeSel` | RODATA | `0x0037C4E0` | 32 | Compiler-owned virtual table; its constructor use is frozen in MenuCostumeInit. |
| `__vt__15CMenuChrCngMenu` | RODATA | `0x0037C520` | 32 | Compiler-owned virtual table; its constructor use is frozen in MenuCharaChangeInit. |
| `SelectedCmdNo_1415` | BSS | `0x0037E244` | 1 | Local static/initialization guard in frozen ChrCng::KeyChangeMain. |
| `init_1416` | BSS | `0x0037E248` | 1 | Local static/initialization guard in frozen ChrCng::KeyChangeMain. |
| `at_1650__2` | BSS | `0x0037E24C` | 4 | Literal/local initializer in frozen ChrCng::KeyChangeMain. |
| `at_1684__2` | BSS | `0x0037E250` | 8 | Literal/local initializer in frozen ChrCng::KeyChangeMain. |
| `select_monster_save_3371` | BSS | `0x0037E298` | 4 | Function static and its initialization guard in MosSelect::KeyStep. |
| `init_3372__2` | BSS | `0x0037E29C` | 1 | Function static and its initialization guard in MosSelect::KeyStep. |
| `at_3412` | BSS | `0x0037E2A0` | 4 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3440` | BSS | `0x0037E2A4` | 4 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `D_01F3C7FC` | BSS | `0x01F3C7FC` | 4-byte piece | Distinct four-byte BSS piece; omission shifts later objects (tooling). |
| `at_1806__2` | BSS | `0x01F3CA40` | 32 | Literal/local initializer in frozen ChrCng::KeyChangeMain. |
| `at_3511` | BSS | `0x01F3CD10` | 32 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3529` | BSS | `0x01F3CD30` | 32 | Literal/local initializer in frozen MosSelect::KeyStep. |
| `at_3554` | BSS | `0x01F3CD50` | 24 | Literal/local initializer in frozen MosSelect::KeyStep. |

Final: **55 INCLUDE_RODATA / 13 INCLUDE_BSS**, **123 / 9726 matched_data**.
This removes **300 RODATA and 66 BSS markers** from the baseline. Progress data
is a lower bound: incomplete aggregate sections containing the frozen data or
the retained boundary receive no credit for their independently exact native
objects. The complete small initialized-data section and existing literal
section account for the final 123 credited bytes. Native matched functions
remain **81 / 88**; this migration promotes no function and changes no
guarded code. Later guarded-body work is documented separately.

## KeyStep script strings and templates (regsim-r0, October 9)

With `CMenuMosSelect::KeyStep` native, its 30 KeyStep-only data objects are
native source at their uses; their extern declarations and markers are gone.

- The 24 script, file, motion and form-part strings `at_3685`–`at_3708` are
  inline literals. Shift-JIS strings use menuchr's all-hex escape spelling.
  `at_3698` (the class-change end script) is used twice and binds once.
- `at_3481` is the command template initializer
  `MenuCommandList commands = {{0x14B6, 0x14B7, 0x14B8, -1, -1, -1}};`
  (`.rodata`, eight words with two zero tails).
- `at_3412`, `at_3440` (`MonsterNameList`), `at_3511`, `at_3529`
  (`MonsterNameTable`) and `at_3554` (`BadgeInfoValues`) are zero aggregate
  initializers (`{{NULL}}` / `{{0}}`), supplied as `.bss` templates.
- The four wrapper types are since replaced by plain local arrays
  (`int commands[8]`, `char *grown[1]`, `char *names[8]`, `int values[6]`)
  with the same templates; see
  [the round-three review fixes](review-fixes-r3-20261009.md).

After this step: **38 markers** in menuchr (from 68), menuchr matched data
2,999 / 9,726 bytes. Whole build `SCES_511.90: OK` (6,788 perfect), 149/149
objects (`menuchr: 0x11C9F bytes, 3835 relocations`); coverage 6,788 matched /
75 guarded / 9 asm-only / 0 fuzzy. Receipts:
`.private/regsim-r0/ks-data-{build,objects,progress,coverage}.log`.

KeyStep's function static `select_monster_save$3371` (4 bytes) and its guard
`init$3372` (1 byte, `0x37E29C`) are the function static
`select_monster_save`, declared after `case 10:` in the step switch so that
steps 12 and 13 see it (see
[the round-three review fixes](review-fixes-r3-20261009.md)); their two BSS
markers are gone.
The unit's BSS layout is unchanged: whole build `SCES_511.90: OK`, 149/149
(`menuchr: 0x11C9F bytes, 3835 relocations`). Markers: **36**. Receipts:
`.private/regsim-r0/ks-static-{build,objects}.log`.
