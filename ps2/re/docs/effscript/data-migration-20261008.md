# effscript native data migration (2026-10-08)

## Round-5 local callback comparison identities

The general data comparison path now retains canonical local callback
suffixes through undefined data-only aliases. Each alias requires a complete
native function match and exact initialized-table extent, real relocation
kind/site, zero addend and retail callback address. Original function names,
code bytes and serialized code relocations remain unchanged. This resolves
the duplicate callback identities in the native command definition table,
allowing the complete 22,968-byte `.data` run to compare exactly.

Matched data rises **1,052 → 24,020 / 25,232**. The 14 initialized markers
for guarded assembly consumers remain; no source or guarded function changes.
Every linked object hash is unchanged. PAL is `SCES_511.90: OK`, all
**149/149** objects pass, and code metrics remain
**6,780 functions / 1,854,796 bytes**. Receipts:
`.private/dtool-r5/callback-{build,objects,tests,metrics,coverage}.log`.
The pre-fix identity regression is `callback-tests-before.log` in that directory.

The refreshed starting unit contains 33 initialized-data markers and five BSS markers. Strict objdiff measures are `matched_data = 0`, `total_data = 25232`; 181 of 185 functions match. The four guarded drafts and assembly functions remain unchanged. Existing type sizes, resource paths, linked-list ownership and command signatures are documented in `notes.md`.

## Migrate effect script resource catalog

`eff_spt_base_def` is a mutable global array of 219 `EFF_SPT_BASE_DEF` rows, each 0x64 bytes: 32-byte name, `EffSptBaseType`, 32-byte resource filename and 32-byte script filename. Its declared extent is 0x558C; the retail data piece has four additional zero padding bytes. The first 173 rows select character resources, the next 45 select image resources, and the final empty-name row uses `EFF_SPT_BASE_END`. Fixed arrays preserve duplicate names and Shift-JIS bytes with hexadecimal escapes. The actual retail data bytes establish these strings; apparent pointer expressions in generated assembly are not relocations within these arrays.

Accepted steps: `base-definitions`. Each has full PAL, 149-object and unowned raw-object hash receipts under `.private/dataA-r3/eff-<topic>-{build,objects,hashes}.log`.

## Define typed effect script command storage

`now_scene` and `EffScriptMan` are global pointers to the active scene and effect manager. `now_script` is a file-local pointer to the script executing external commands. `ext_func__4` is a mutable file-local array of 256 correctly typed `int (RS_STACKDATA *, int)` callbacks (0x400 bytes). Its retail spelling remains available to the guarded `CreateEffSpt` assembly and its unchanged draft. Definitions preserve existing header declarations and global linkage.

Accepted steps: `storage`. Each has full PAL, 149-object and unowned raw-object hash receipts under `.private/dataA-r3/eff-<topic>-{build,objects,hashes}.log`.

## Initialize effect direction vectors naturally

`_GET_DIR_VECTOR` and `_CHR_GET_DIR_VECTOR` each initialize a four-float local direction as `{0.0f, 0.0f, 1.0f, 1.0f}` before transforming it. These initializers reproduce the two mutable 16-byte compiler templates (`at_2311` and `at_2498__2`) without the former quadword casts.

Accepted steps: `vector:at_2311`, `vector:at_2498__2`. Each has full PAL, 149-object and unowned raw-object hash receipts under `.private/dataA-r3/eff-<topic>-{build,objects,hashes}.log`.

## Initialize effect sprite size locally

`DrawEffSptSprite` initializes its four-component size vector to zero before assigning sprite width and height. A native `sceVu0FVECTOR` initializer replaces the anonymous 16-byte BSS vector `at_2067`. Removing its marker and the two direction templates eliminates the `EffectVector` union scaffolding.

Accepted steps: `vector:at_2067`. Each has full PAL, 149-object and unowned raw-object hash receipts under `.private/dataA-r3/eff-<topic>-{build,objects,hashes}.log`.

## Inline effect resource loading literals

Resource loading uses native `%s.chr`, `%s.img`, `%s.stb` pack suffixes and `dungeon/eff_script/` paths. `ClearBaseFromLevel` owns its texture-bank exhaustion diagnostic. Each literal is inline at its actual native use.

Accepted steps: `strings:at_943__3`, `strings:at_1127__2`, `strings:at_1128__3`, `strings:at_1129__2`, `strings:at_1143`, `strings:at_1144`, `strings:at_1145`. Each has full PAL, 149-object and unowned raw-object hash receipts under `.private/dataA-r3/eff-<topic>-{build,objects,hashes}.log`.

## Inline effect script command diagnostics

Native diagnostics report sprite-work exhaustion, collision polygon limits, unavailable collision primitives, command coordinates, effect creation failures, duplicate command numbers and dispatch capacity exhaustion. Their byte content and null termination are preserved, including hexadecimal Shift-JIS escapes.

Accepted steps: `strings:at_1655__5`, `strings:at_3303__2`, `strings:at_3398`, `strings:at_3495`, `strings:at_3536`, `strings:at_3644`, `strings:at_3645`. Each has full PAL, 149-object and unowned raw-object hash receipts under `.private/dataA-r3/eff-<topic>-{build,objects,hashes}.log`.

## Use native effect intersection switch data

The existing `_INTERSECTION_POINT` switch generates the nine-entry `at_3304__2` jump table from its native cases. Its 0x24-byte payload occupies a 0x30-byte aligned retail piece. Removing the marker preserves all target addresses and zero padding.

Accepted steps: `switch`. Each has full PAL, 149-object and unowned raw-object hash receipts under `.private/dataA-r3/eff-<topic>-{build,objects,hashes}.log`.

## External command definition table

The mutable file-local `RS_EXTFUNC_INFO ext_func_info[129]` contains 128 correctly typed callbacks followed by `{NULL, EFF_EXT_END}`. `EffectExternalCommand` names their retail numeric IDs. Initializer order is preserved, including commands 252/253 and 157/158 before 155/156. The declared extent is 0x408; the retail aligned piece is 0x410, with the terminal eight zero bytes excluded from comparison as linker padding. No callback casts or guarded changes are needed.

Receipt: `.private/dataA-r3/eff-dispatch-table-{build,objects,hashes}.log`; PAL matches, all 149 objects pass and every unowned raw-object hash is unchanged. Each native .data piece has identical comparison bytes and mapped relocation targets to its reference counterpart.

## Retained assembly dependencies

| Retail literal | Guarded consumer | Declared bytes | Piece bytes |
|---|---|---:|---:|
| `at_1099__2` | `BuildBase(int, ...)` | 44 | 48 |
| `at_1100` | `BuildBase(int, ...)` | 43 | 48 |
| `at_1101` | `BuildBase(int, ...)` | 37 | 48 |
| `at_1102__2` | `BuildBase(int, ...)` | 37 | 48 |
| `at_1103__5` | `BuildBase(int, ...)` | 64 | 64 |
| `at_1104__7` | `BuildBase(int, ...)` | 9 | 16 |
| `at_1336__2` | `CreateEffSpt` | 37 | 48 |
| `at_1337__2` | `CreateEffSpt` | 46 | 48 |
| `at_1338__2` | `CreateEffSpt` | 43 | 48 |
| `at_1339__3` | `CreateEffSpt` | 40 | 48 |
| `at_1340__2` | `CreateEffSpt` | 39 | 40 |
| `at_1341__2` | `CreateEffSpt` | 1 | 8 |
| `at_1705` | `AssignCharacter` | 56 | 64 |
| `at_2025__3` | `SetCharacter` | 49 | 64 |

Every listed literal is referenced by an active `INCLUDE_ASM` body under its retail symbol. The matching build needs those identities, and this lane does not change the corresponding guarded drafts. `at_1341__2` is the shared empty string used by native code and guarded `CreateEffSpt`; its external declaration and marker also remain. None is replaced by a named anonymous-literal stand-in.

All five BSS reservations and all native-only initialized markers are removed. No functions are promoted or guarded drafts edited.

## Strict data accounting

Objdiff's `matched_data` measure credits an entire data section only when its comparison reaches 100%. Partial native data coverage in a section therefore receives no matched-byte credit. Exact per-piece comparison and the canonical whole-object checker still prove the accepted native objects. For example, the padded 0x5590-byte native effect resource catalog and reference piece have identical SHA-256 `1214afea6a5798bf37d67d6489f9016f52f510de8c2d106e590e7c70f5f4fd35`; local receipt copies are `.private/dataA-r3/catalog-{source,target}.bin`.

## Comparison section shape

The compiler emits separate native `.data` pieces while the reference comparison object retains one monolithic `.data` section. Objdiff's current pairing associates only the first native section with that reference run; other native pieces have separate zero-score section entries. This is a comparison limitation, independent of the canonical object result. `.private/dataA-r3/final-data-pieces.log` verifies every native initialized piece in both units with identical bytes and all mapped R_MIPS_32 targets.

The one-shot CLI receipt `.private/dataA-r3/eff-data-diff.json` shows the reference 0x59B8-byte run paired with the native 0x5590-byte catalog, marking the remaining 0x428 bytes deleted. Those bytes are supplied exactly by the two 0x10-byte direction templates and 0x408-byte dispatch table in separate native sections. The aggregate `.data` score is 99.8254%, so none of its bytes receives `matched_data` credit despite complete native source and exact canonical matching. Build tooling is unchanged; comparison section pairing belongs to the tooling lane.

## Final validated measures

| Measure | Checkpoint 3221b488 | Final native source |
|---|---:|---:|
| `INCLUDE_RODATA` | 33 | 14 |
| `INCLUDE_BSS` | 5 | 0 |
| `matched_data` | 0 | 1052 |
| `total_data` | 25232 | 25232 |

Final pinned-image receipts: `.private/dataA-r3/final-{build,objects,hashes,refresh,coverage,data-pieces}.log` and `after.json`. PAL prints `SCES_511.90: OK`; all 149 canonical units pass; no unowned raw objects change. Source guards are unchanged and build scripts, SF profiles and dng_main remain untouched.
