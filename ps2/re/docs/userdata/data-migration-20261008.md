# userdata data migration

## Baseline

The 63f7a9e5 unit contains 114 `INCLUDE_RODATA` markers and seven
`INCLUDE_BSS` markers. The refreshed progress report credits 4 / 4,264
data bytes. All functions already match.

## Native BSS

`FishGamePreEquip` is a file-local `CGameDataUsed *`.
`BattleParamater_Time` and `BattleParamater_TimeBand` are file-local
`float` and `int` caches. Their native zero-initialized definitions
replace the three four-byte assembly reservations.

`word_1327` is the 0x61-byte item-name buffer used by `GetName`; the
0x70-byte section piece includes the following 15-byte alignment gap.
`temp_1510` is the 0x40-byte spectrum description buffer used by
`GetMsgAddInfo`. Both are native file-local character arrays. The
postprocessor retains the name buffer's declared extent and its zero
alignment gap, following `docs/MWCC.md`.

Validation: `.private/dataC/userdata-bss-build.log` records
`SCES_511.90: OK`; `.private/dataC/userdata-bss-objects.log` records
149 / 149 passing objects. All other game object file hashes equal
the warm baseline. The marker counts are 114 / 2 after this step.

## Numeric tables and aggregate templates

Native signed-byte, halfword, word, and float tables replace
`htbl_1662`, `fish_record_dataindex_convert`, `weptbl_4503`,
`lifetbl_2854`, `use_limmit_table_2558`, `tbl1_5167`, `tbl2_5168`,
`equip_type_tbl_5456`, `at_table_5400`, and the public
`aquarium_fish_maxtbl`. Each step has a separate full build and object
receipt under `.private/dataC/userdata-<symbol>-*.log`, except the
equipment and ability tables use `userdata-equip-types` and
`userdata-attributes-data-only`.

The equipment table is 3 x 5 signed bytes; `SearchEquipType` uses
ordinary two-dimensional indexing with identical instructions.
`tbl1_5167` has four bytes `{1, 2, 3, 4}`, although the selection
function reads only its first three choices. `at_table_5400` is 14
words (0x38 bytes); the combination loop checks the first 12. Its
last two zero entries are part of the declared object, not alignment
padding.

The existing local ridepod item-number and weapon-rate initializers
emit `at_4196` and `at_4695` without assembly. The local party-bit
initializer emits `at_3192` directly; its final entry shares Monica's
party bit because monster form belongs to her.

`CheckWeaponAttribute` indexes the table through a local const word
reference, `const unsigned int &pair = at_table_5400[bit]`. This keeps
the retail induction-offset and pair registers and removes the byte
offset, pointer arithmetic, and cast. Copying the indexed word into a
value local swaps `$9` / `$10` and differs by seven words; the
reference form has zero differences. Exact-function and complete-object
evidence is in `.private/dataC/attribute-analysis/pair_reference/`.

The completed group has 101 data markers and two BSS markers.
`userdata-attributes-data-only-build.log` records PAL OK, its
object receipt records 149 / 149, and every unowned object file hash
is unchanged. The refreshed data measure remains 4 / 4,264 bytes:
partial migrations do not necessarily increase that measure.

## Language and monster script tables

The native `basefish_1288`, `symbol_tbl_1338`, `magic_str_1462`,
`strtbl_1505`, `f_2005`, and `robo_nametable_3330` pointer arrays
contain their literal strings at the definitions. Shared strings
remain pooled by MWCC. No named literal objects or casts are needed.
Every table has a full-build receipt named `userdata-<symbol>` in
`.private/dataC/`.

`mos_henge_param` is a native 57-entry `MOS_HENGE_PARAM` array.
Each 0x1C-byte entry contains three signed halfwords, two unknown
zero bytes, the monster script basename at +8, and four effect
basenames at +0xC. All basename literals are inline in the table.
The 0x63C-byte object has a four-byte alignment tail.

`GetMonsterModelFile` uses the +8 pointer to form a `%s.stb` path;
it is not padding. The header names it `script_name`, reduces
`unk_6` to two bytes, and leaves `effect_name` at its existing
offset. Existing callers' declarations and record layout remain
compatible. Detailed m2c/disassembly evidence is in
`.private/dataC/type-analysis/findings.md`.

`userdata-monster-table-build.log` and
`userdata-monster-table-objects.log` prove PAL OK and 149 / 149
objects after rebuilding all header consumers. Every unowned object
file hash equals the warm baseline. There are 19 data markers and
two BSS markers after this group.

## Inline format strings and switch data

`GetName`, `GetRoboJointName`, `GetRoboSoundFileName`, and
`GetMainCharaModelName` use their string literals directly. Their
external anonymous-string declarations and seven data markers are
removed. `CUserDataManager::CopyGameData` already has a native
switch; it emits `at_4442` and its eight function-relative
relocations without the marker.

Each function's change has a full receipt (`userdata-name-level`,
`userdata-weapon-model`, `userdata-weapon-sound`,
`userdata-character-model`, and `userdata-item-copy-switch`) in
`.private/dataC/`. PAL remains OK, all 149 objects pass, and
unowned object hashes are unchanged. Eleven data markers and two
BSS markers remain.

## Debug presets and retained BSS templates

All ten debug item tables have exact declared sizes `4 * count + 2`: a
sequence of signed halfword item/quantity pairs followed by one `-1`
item-number halfword. A `DEBUG_ITEM` record array would add a quantity
for the sentinel and misstate the object extent. The native tables
therefore use `short[]`; `DEBUG_ITEM_FIELD` names the two columns and
the pair width. The two loops read the quantity only after a positive
item-number test. Mode 7 starts the extra list at the second pair.
`init_partytbl_5752` is a separate signed-byte list of townspeople
1 through 25 followed by -1, with declared size 0x1A.

Private m2c and exact-object evidence for the encoding is in
`.private/dataC/type-analysis/debug/`. Full acceptance receipts are
`userdata-debug-flat-tables` and `userdata-ordered-data` under
`.private/dataC/`. Named storage definitions follow retail address
order; the functions' local aggregate initializers remain at their
uses. Empty data-section headings and unused anonymous declarations
are removed. The completed unit has zero `INCLUDE_RODATA` markers.

Two `INCLUDE_BSS` markers remain because the current postprocessor
cannot name native anonymous NOBITS templates after their markers
are removed:

- `at_2061` is the zero template for the local `u16 *param[5]` in
  `CheckParamLimmit`. Its declared size is 0x14, with a 12-byte
  alignment tail.
- `at_5773` is the local `short equip_no[4]` template in
  `DebugGetItem`, exactly eight bytes.

The natural local aggregates already exist. A private removal trial
fails only the missing anonymous identities and resulting relocation
resolution. `.private/proposals/dataC-anonymous-bss.patch` proposes
naming anonymous NOBITS objects using exact declared extent and
unambiguous opcode-matched HI16/LO16 or GPREL16 reference evidence.
It changes no instructions or relocation fields. The private complete
userdata check and 15 positive/rejection cases pass. The shared tool
is outside this lane's ownership, so the proposal is not applied here.
Details and receipts are in `.private/dataC/type-analysis/findings.md`.

After the explicit objdiff/progress refresh, `matched_data` remains
4 / 4,264 bytes. Objdiff compares source-only objects before the
linking postprocessor's native literal naming, piece padding, and
retail section ordering; the exact linked-object checks prove the
migration despite that source-side metric.

`userdata-indexed-attributes-build.log` and its object receipt accept
the final indexed ability-table consumer: PAL OK, 149 / 149 objects,
and every unowned object hash unchanged.

## Combined tool-proposal validation

A private integration copy applies `dataC-anonymous-bss.patch`,
`dataC-vtable-padding.patch`, and `dataC-vu-raw-words.patch`, then removes all
eight retained markers across this lane. Its userdata object passes every
byte and relocation: 0xBC1C allocated bytes and 1081 relocations, with final
zero section tails supplied by the linker. The private full PAL link reports
`SCES_511.90: OK` and the exact retail loaded-memory extent. All 306 existing
input objects, actual tools, and generated VU input remain unchanged.

This validates the two native local templates without invented globals.
Actual userdata retains their markers until the tooling owner integrates the
general fixes and validates a clean canonical build. Reproducible snapshots,
patch hashes, unit checks, program-image SHA-256 equality, and linker/verifier
receipts are in `.private/dataC/proposal-integration/`. The compiler-access
techniques also have a proposed shared documentation update in
`.private/proposals/dataC-MWCC-data-access.patch`; `docs/MWCC.md` is unchanged.

## Native zero templates

The final two BSS markers are removed. The existing local pointer array
and equipment array generate the zero templates naturally. The postprocessor
identifies them by their exact declared sizes and consistent opcode-matched
retail address relocations; the 0x14-byte pointer template retains its
12-byte piece alignment. No local initializer or instruction changes.
PAL and all 149 object checks pass; all unowned game objects retain their
baseline hashes. Receipts: `.private/dtool/08-userdata-{build,objects,metrics,tests}.log`.

## Corrected data comparison

The repaired objdiff preparation credits **4,252/4,252 native data
bytes (100%)**, versus 4/4,264 in the checkpoint report.
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
