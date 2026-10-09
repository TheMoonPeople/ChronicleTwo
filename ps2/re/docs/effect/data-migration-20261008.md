# Effect data migration

## Baseline

At lane checkpoint `ab376093`, all 75 functions match. The unit has 51
`INCLUDE_RODATA` markers and four `INCLUDE_BSS` markers. Refreshed objdiff
credits 44/1,124 data bytes. The warm build reports `SCES_511.90: OK` and
all 149 objects pass the canonical comparison.

## Script-loader storage

The existing matched code and type notes establish `g_tmp_effm` as a
`CEffectManager *`, `g_tmp_effc` as a `CEffectCtrl *`, `g_eff_entry_flag`
as an `int`, and `g_tmp_eff_name` as a 32-byte emitter-name buffer. Native
file-static definitions replace their reservations in retail address order.
No class layouts or public declarations change.

Acceptance receipts are `.private/dataC-r1/effect-storage-build.log`,
`effect-storage-objects.log`, and `effect-storage-metrics.log`: PAL OK,
149/149 objects, and no unowned object hash changes. Markers become 51/0.

## Script tag table

`effm_tag` is a native file-local array of 48 `SPI_TAG_PARAM` records: 47
name/callback pairs and one null terminator. The existing interpreter header
owns the documented eight-byte record type. The definition follows the
callbacks, with each exact tag spelling inline, including `__REP_RAND`.
This removes the table marker and 47 pooled-string markers without changing
callbacks or consumer declarations. The existing table and string associations
are checked against their retail pointer words.

`effect-tags-{build,objects,metrics}.log` accepts this group: PAL OK,
149/149 objects, and no unowned object changes. Markers become 3/0.

## Particle switches

The existing `CEffect::Step` switches emit `at_383` (seven entries) and
`at_382__3` (six entries) themselves. Removing their redundant markers
requires no function edits. `effect-switches-{build,objects,metrics}.log`
records PAL OK, all 149 objects passing, and unowned hashes unchanged.
Markers become 1/0.

## Empty names and final state

`CEffectManager::Initialize` passes `""` directly when clearing the emitter
and image names. The native pooled literal is identified by its unchanged
code references; the table-pointer ambiguity previously found in automap
does not apply here. Its extern and final marker are removed.

`effect-empty-name-{build,objects,metrics}.log` records PAL OK, 149/149
objects passing, and every unowned object unchanged. Final markers are
**0 RODATA / 0 BSS**, versus **51 / 4**. All 75 functions remain matched;
none is newly promoted. Refreshed source-only matched data stays **44/1,124**.
That comparison omits the linked object's naming, ordering and piece-padding
normalization; the canonical complete object verifies every byte and resolved
relocation of the migrated data.
