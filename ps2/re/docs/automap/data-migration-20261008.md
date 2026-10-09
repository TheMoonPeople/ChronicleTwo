# Automap data migration (2026-10-08)

## Baseline and verification

Baseline `63f7a9e5` has 307 `INCLUDE_RODATA` markers, seven `INCLUDE_BSS`
reservations, and 43 matching functions. The refreshed objdiff report attributes
28 of 21,300 data bytes to matching source.

Each accepted step passes the full build (`SCES_511.90: OK`) and all 149 units
in `check_objects.py`, which compares bytes and resolved relocations. SHA-256
comparison against the warm-build baseline also checks that every other compiled
object is unchanged. Private receipts are under `.private/dataA/`.

## Room-script and navigation storage

The seven four-byte `.sbss` objects are file-local typed storage, in retail order:
`auto_map` (`CAutoMapGen*`), `nowPrisetStack` (`mgCMemory*`), `nowPriset`
(`AUTOMAP_ROOM_INFO*`), `nowPrisetNum` (`int`), `nowPrisetTable` (`s16*`),
`cax` and `cay` (`int`). Their uses and layouts are established in `notes.md`.
Replacing the extern declarations and reservations with documented `static`
definitions preserves every instruction, data extent, and resolved relocation.

Receipts: `01-bss-build.log`, `01-bss-objects.log`. All 148 other object hashes
are unchanged. Marker counts become 307/0; matched data remains 28/21,300,
because the source-only object already inferred storage from the BSS markers.

## Mini map symbol appearance

`symbol_table` at `0x341C60` is a file-local writable array of ten
`MINIMAP_SYMBOL_INFO` rows. Nine rows specify existing `MINIMAP_SYMBOL`
values; the final row uses `MINIMAP_SYMBOL_END` and zero appearance fields.
The native aggregate retains every colour, dimension, blink flag and visibility
flag, and preserves the retail-local binding.

Receipts: `02-symbols-build.log`, `02-symbols-objects.log`. All 149 units pass;
PAL is OK; all 148 other object hashes remain unchanged. Marker counts become
306/0; refreshed matched data remains 28/21,300.

## Dungeon map tile tables

`MiniMapInfoData` at `0x33EE40` contains 18 writable `MINIMAP_INFO`
aggregates, each with its 16-byte map name and 320 signed tile indices.
All 18 names and all 5,760 tile indices are represented directly by the native
initializer. The definition retains the public name, 0x2E20-byte declared
extent, and existing header layout. The trailing 43 tile slots of each map
are zero; tile values include the retail negative entries unchanged.

Receipts: `03-tiles-build.log`, `03-tiles-objects.log`, `03-tiles-metrics.log`.
All 149 units pass; PAL is OK; all 148 other object hashes remain unchanged.
Marker counts become 305/0; matched data remains 28/21,300 while other pieces
of the source-only `.data` section are incomplete.

## Generated part catalog

`PartsInfoData` at `0x33D440` is 277 native `AUTOMAP_PARTS_INFO`
aggregates. Its names and documented kind/link flags are inline; the eight
auxiliary shorts of each row retain their existing unknown field name and exact
retail values. Those shorts range from -1 to 85 and are not uniformly repeated;
no consumer establishes their meaning. Bits 0x40 and 0x80 have neutral enum
names recording which stair and door variants carry them, without claiming a
behavior. All 276 nonempty part-name literals are emitted by the compiler.

The final row at `0x33EE20` points to the empty string at `0x36CFA8`.
Its name pointer is not NULL. Retail `SetMapInfo` advances the row offset by
0x18 at `0x1D5EE8`, then tests the name pointer at `0x1D5EFC`/`0x1D5F00`;
after the empty-name row it reads zero from `0x33EE38`, the eight alignment
bytes before the next table. The native 0x19F8-byte object receives that exact
zero tail through the documented data-padding postprocessor.

The empty-name literal retains `at_1054` and its marker. A fully inline `""`
initializer emits one unnamed byte of zero: `name_literal_data` finds several
matching zero-filled pieces, and currently distinguishes candidates only through
code relocations. This literal has only a pointer relocation in the catalog.
The probe leaves `at_1054` missing and an unexpected unnamed `.rodata` piece,
so it cannot pass the canonical checker. Keeping just that literal marker and
reference preserves exact source for the rest of the catalog. Negative receipts:
`04-parts-build.log`, `04-parts-probe-objects.log`.

Proposed shared-tool change, outside this lane's ownership:
`.private/proposals/automap-empty-literal-data-relocation.patch`. It extends
ambiguous-literal identification to existing R_MIPS_32 relocations in known
named native data objects; it does not modify data or instruction bytes. The
shared tool is unchanged; the proposal is validated on a private copy of the
all-native automap object and in a private PAL link (see below). After accepting
that tool change, the
last row can use `""` and the `at_1054` declaration/marker can be removed.

Accepted receipts: `04b-parts-build.log`, `04b-parts-objects.log`,
`04b-parts-metrics.log`. All 149 units pass; PAL is OK; all 148 other object
hashes remain unchanged. Marker counts become 28/0.

## Room script command table

`tag` is a file-local, writable eight-row `SPI_TAG_PARAM` array at
`0x341D00` (the split disambiguates its name as `tag__4`). Each of its seven
command names is inline with its callback; the last row is `{NULL, NULL}`.
The callbacks use `static` linkage, consistent with their retail LOCAL
binding. The existing documented callback signatures and script behavior are
unchanged. The split-name suffix is handled by the existing postprocessor.

Receipts: `05-tags-build.log`, `05-tags-objects.log`, `05-tags-metrics.log`.
All 149 units pass; PAL is OK; all 148 other object hashes remain unchanged.
Marker counts become 20/0.

## Part placement vectors

`SetDummyMountain` initializes its position/rotation and scale as native
four-float local aggregates (`{0, 0, 0, 1}` and `{1, 1, 1, 1}`), removing
the anonymous extern declarations and 128-bit type-punned copies. The existing
corresponding aggregate initializers in `SetDummyTree` and `IndexToPartsPlace`
now supply their own data as well. These are six separate 16-byte `.data`
objects at `0x341D40` through `0x341D90`; the existing postprocessor maps
each compiler object by its contents and the consuming code relocations.

Each function's pair was removed and verified separately. Receipts:
`06-mountain-vectors-*`, `07-tree-vectors-*`, `08-placement-vectors-*`.
Every step passes all 149 objects and PAL; all 148 other object hashes are
unchanged. Marker counts become 14/0.

## Function strings

Thirteen strings are inline at their uses, with their exact spelling, format
arguments and terminating newlines preserved:

| Function | Strings | Receipt prefix |
|---|---|---|
| `CMiniMapSymbol::SetMapInfo` | `minimap1` | `09-minimap-string` |
| `CAutoMapGen::RoomLink` | `ERR:NotFound StartLinkPoint\n` | `10-room-link-string` |
| `CAutoMapGen::SetPartsIndex` | `%d,%d [%d][%d]\n` | `11-parts-index-string` |
| `SetDummyMountain`, `SetDummyTree` | `o00`, `o01` | `12-dummy-parts-strings` |
| `SearchHealingPoint` | `room5%d`, `kaifuku` | `13-healing-strings` |
| `IndexToPartsPlace` | `p01_gio`, `obj01`, `obj02` | `14-placement-strings` |
| `SetInOutPartsIndex` | `EXIT INDEX = %d\n` | `15-exit-index-string` |
| `RandomMapMainProc` | `rand = %d\n` | `16-random-seed-string` |
| `Build` | `%d\n` | `17-floor-number-string` |

The shared `o00` literal retains one pooled object across the two consumers.
The room-script command table definition follows the tag callbacks and precedes
`SetupRoomInfo`, so the table definitions and literal uses follow retail data
order naturally. No command or code behavior changes.

Each row above has a separate full build, all-object check and baseline hash
receipt with `-build.log`, `-objects.log`, and `-metrics.log` suffixes. Every
step passes all 149 units, PAL, and the unchanged-other-object check. Marker
counts become 1/0. The sole remaining marker is the catalog's empty name.

## Empty-literal proposal validation

The proposed postprocessor extension identifies the literal through the real
R_MIPS_32 pointer in `PartsInfoData`, subtracting the compiled addend and
symbol offset from retail's relocated word. It accepts a target only when it
already belongs to the exact-byte candidate set and all references select one
address. This supplies identity for `""` without changing its bytes, creating
data, or changing code.

The fully inline source probe is saved as
`.private/proposals/automap-empty-literal-source.patch`. Its compiled object
receives the proposed processing only in `.private/dataA/proposal-obj/`; the
shared postprocessor and generated linked-object tree are not patched. The
private automap object passes the canonical comparison: 0xA3E0 bytes and 650
resolved relocations, zero problems. A private object response file substitutes
only that automap object into the normal linker inputs. The resulting private
PAL image passes every section and its memory extent. Receipts:
`20b-empty-proposal-objects.log`, `20b-empty-proposal-link.log`,
`20b-empty-proposal-pal.log`. Thus accepting the tool and source proposals can
remove the last marker; the committed lane retains the exact one-marker form.

## Objdiff data-metric limitations

The final official `matched_data` remains 28 of 21,300. It counts the fully
matching `.sbss` section; the source-only `.data` and `.rodata` comparisons
contain independent preparation defects. Canonical `check_objects` compares
the prepared linked object against actual retail bytes and relocation metadata,
and remains exact. The report's reference uses whole-unit splat assembly, while
the linked objects use the stricter per-piece assembly from `disassemble.py`.

| Object | `.data` bytes / R_MIPS_32 relocations | `.rodata` bytes / R_MIPS_32 relocations |
|---|---:|---:|
| Raw source-only base | 18,776 / 291 | 2,071 / 0 |
| Canonical linked object | 18,784 / 291 | 2,488 / 0 |
| Objdiff reference | 18,784 / 1,641 | 2,488 / 4 |

The reference invents 1,350 `.data` pointer relocations by treating packed
shorts as addresses: 376 in `PartsInfoData` and 974 in `MiniMapInfoData`.
All 291 actual retail `.data` relocations are present. The four `.rodata`
relocations are also fabricated; retail has none. These are comparison defects,
not missing C++ initializers. For example, a packed value at `.data+0x18C`
is represented as `D_80000`, and one at `.data+0x7E4` as `main_buffer`.

The source-only compiler output also lacks the eight verified alignment bytes
after `PartsInfoData` and all per-literal piece padding. It receives no linked
postprocessing. Its shifted anonymous numbers are mapped by spelling alone:
retail `at_1037__2` (`"door83"`) is incorrectly paired with native `@1037`
(`"ERR:NotFound StartLinkPoint\n"`). Therefore anonymous number-based mapping
cannot establish data identity.

A read-only in-memory audit of the existing naming and padding routines gives
18,784 `.data` bytes and 2,480 `.rodata` bytes with correct retail identities.
It leaves `at_1054` undefined, correctly excluding the eight bytes still
supplied by its marker. The relevant normalization calls are name projection,
`name_literal_data`, `pad_data`, `bind_suffixed_references`, then `pad_data`
again. A shared objdiff repair should apply this source-only data preparation
without importing fallback payloads, and should remove fabricated target
relocations while restoring the numeric bytes those relocations displaced.
Those tooling files are outside this lane's ownership and remain unchanged.

## Existing healing-point copy probe

`SearchHealingPoint` still contains its inherited 128-bit copy of the function
point position into a local float array. Replacing it with
`memcpy(offset, point->position, sizeof(offset))` changes the function's code:
the PAL comparison reports 88 differing `.text` bytes, first at
`SearchHealingPoint+0x12`. The probe is rejected and restored; no nonmatching
replacement or synthetic vector helper is committed. Receipt:
`18-healing-copy-build.log`. The data-literal casts in `SetDummyMountain`
are removed by the accepted native aggregate initialization.

## Final lane checkpoint

The committed source has one `INCLUDE_RODATA` marker and zero `INCLUDE_BSS`
reservations, versus 307 and seven at baseline. All 43 functions remain matched;
no functions are promoted. Refreshed official matched data is 28/21,300 before
and after for the comparison reasons above. The canonical object supplies every
byte and relocation correctly; only the eight-byte empty-name piece still comes
from a marker. Thus 306 data markers and all seven reservations are removed.

Final receipts: `22-final-build.log` (`SCES_511.90: OK`),
`22-final-objects.log` (149/149), `22-final-refresh.log`,
`22-final-coverage.log` (6,749 matched / 113 guarded / 10 asm-only / 0 fuzzy),
and `22-final-metrics.log` (all 148 other object hashes unchanged). The shared
tool/source proposals are kept private for the coordinator; no tooling change,
network write, or generated artifact is committed.

## Final empty-name piece

The catalog's last name is the inline empty string. Its native one-byte
literal is identified through the real `PartsInfoData` R_MIPS_32 relocation,
with the compiled addend and symbol offset subtracted. The matcher accepts
only an exact-byte candidate selected consistently by real references.
The `at_1054` declaration and final marker are removed; automap now has
zero data markers. The complete PAL build and all 149 objects pass.
Receipts: `.private/dtool/07-automap-{build,objects,metrics,tests}.log`.

## Corrected data comparison

The repaired objdiff preparation credits **21,296/21,296 native data
bytes (100%)**, versus 28/21,300 in the checkpoint report.
The denominator excludes only the unit's terminal zero alignment owned by
the linker. Reference relocations and data boundaries use retail metadata;
native identities, internal padding, and retained-marker exclusions use
the same verified piece model. Function rows and code bytes are unchanged.

Final proof: `.private/dtool/final-proof.log`; whole PAL build:
`.private/dtool/14-final-build.log`; all-object check:
`.private/dtool/final-objects.log`; unit tests: `.private/dtool/final-tests.log`.
The full 149-unit before/after table is
`.private/dtool/matched-data-before-after.csv`. Negative retained-marker,
unknown-BSS, byte, and pointer controls are recorded in
`.private/dtool/13-negative-results.log`.
