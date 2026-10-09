# Event function data migration — 2026-10-08

## Baseline

Checkpoint `3221b488`: 116 `INCLUDE_RODATA` and 22 `INCLUDE_BSS` markers;
823/827 native functions; refreshed data comparison 4/235,364 bytes.
The warm PAL build and canonical checker pass, including all 149 objects.

## Event storage

All 22 zero-storage reservations have typed native definitions. The existing
header describes the event state, flags/counters, mouth-animation names,
particle buffers and camera/object sequence entries. Their exact extents are
unchanged. The two event sound buffers hold 0x801 and 0x141 quadwords;
the external-command dispatch array contains 0x5DC typed function pointers.
The script-argument pointer, effect manager, sword trail, sound buffers and
dispatch array have file-local linkage. `EventEffectScript` keeps its retail
symbol reachable for the guarded `_ESM_INITIALIZE` assembly body.
No guarded function or draft is edited.

Receipts: `.private/dataA-r3/event-storage-{global,local}-{build,objects,hashes}.log`.
Both stages pass PAL and 149/149 objects; every unowned object hash is unchanged.

## Local language extensions

`FileNameConvLanguage` initializes its four typed extension pointers at their use and inlines the two formatting strings. The extensions are `txt`, `img`, `stb`, and the empty string. Its complete native pointer template matches.

An initial partial probe left other empty-string consumers external, so the mapper could not identify the newly anonymous fourth initializer target. Migrating all native empty-string consumers together supplies enough real code references to establish that identity; the final source needs neither the `at_1083` marker nor its external declaration. No guarded draft uses this datum.

Initial receipts: `.private/dataA-r3/event-extensions-empty-symbol-{build,objects,hashes}.log`; the partial fully inline form is recorded in `event-extensions-failure.log`. Final receipts: `.private/dataA-r3/event-empty-all-native-{build,objects,hashes}.log`.

## NPC and voice-pack initializer templates

The three local aggregates now use direct initializers: twelve NPC positions
and facing angles, 25 three-column NPC training rows, and 164 voice-pack
lookup rows. `_GET_TRAIN_NPC_POS` selects x/y/z/yaw by zero-based row, with y
forced to zero in map 120. `_GET_NPC_TRAIN_ETC` selects the requested column
and the one-based NPC row. `VpkFileNameFromVoiceNo` matches group/kind and
formats the selected resource id/subresource pair.
The native templates preserve their .data contents and local-copy instructions;
the integer training template's four-byte trailing alignment is supplied by
the existing bounded padding policy.

Receipts: `.private/dataA-r3/event-{train-pos,train-etc,voice-pack}-{build,objects,hashes}.log`.
Each topic passes PAL, all 149 objects and every unowned object hash.

## Hit-effect direction

`_HIT_EFFECT` initializes its default upward vector at the existing copy site,
after reading the position. The `{0, 1, 0, 1}` local array replaces the external
template and quadword type-pun. Its bytes and all caller instructions match.
Receipt: `.private/dataA-r3/event-hit-direction-corrected-{build,objects,hashes}.log`.

## Argument script dispatch definitions

The argument interpreter's three records are native mutable `EventScriptFunc`
rows, with typed `_DATA` and `_ID_OFFSET` function pointers and the null sentinel.
`EventArgumentCommand` names the two command numbers. The shared row type has
its documented eight-byte layout in `event_func.hpp`; both handlers receive
file-local declarations. Native padding retains the original .data piece.
Receipt: `.private/dataA-r3/event-arg-dispatch-{build,objects,hashes}.log`.

## External callback result types

`CRunScript::ext` tests each callback's integer result and diagnoses zero.
Twenty-two callbacks now explicitly return their final dependency call's
existing integer status; their previous void declarations hid that result:

`_FINISH`, `_IMG_SET_DRAW`, `_IMG_SET_GET`, `_IMG_SET_PUT`, `_IMG_SET_MOVE`, `_IMG_SET_FADE`, `_IMG_SET_COLOR`, `_GEORAMA_FUNC`, `_EOH_SET_STEP`, `_EOH_SET_SHOW`, `_EOH_SET_FRAME_SHOW`, `_EOH_SET_SHADOW`, `_EOH_SET_FOOT_SOUND_ID`, `_EOH_SET_FRAME_STATUS`, `_EOH_SET_SOUND_ID`, `_EOH_SET_FADE_FLAG`, `_EOH_RESET_DA_POSITION`, `_EOH_SET_SHADOW_FRAME_STATUS`, `_EOH_SYNC_GEOSTONE`, `_EOH_NORMAL_DRIVE`, `_EOH_SET_FOOT_SE_ID`, `_MT_TEST`.

`_EOH_GET_POS`, `_EOH_GET_ROT`, `_EOH_GET_SHOW`, and `_EOH_GET_FRAME_POS`
return the handle lookup's integer result. Their stack-output calls preserve
v0 in retail and in the native object. A named result expresses that live
status, with no extra instructions. The frame-position getter needs the
positive `if (result != 0)` body and one common return: the early-return form
shortens the native body by four bytes and changes branch/call placement.
Every retained result correction passes the whole-object and PAL checks.
No callback pointer cast or undefined missing return is used.

m2c receipts: `.private/dataA-r3/_EOH_GET_{POS,ROT,SHOW,FRAME_POS}-m2c.txt`
and `_FINISH-m2c.txt`. Canonical receipts are
`event-results-wrappers`, `event-results-_EOH_GET_{POS,ROT,SHOW}`, and
`event-results-frame-branch`, each with build/object/hash logs. The rejected
frame early-return form is in `event-results-_EOH_GET_FRAME_POS-failure.log`.

## Main event dispatch definitions

The main table has 696 typed handlers followed by `{NULL, EVENT_EXT_END}`.
`EventExternalCommand` names every retained retail command number, including
sparse and out-of-order identifiers. `ext_func_info[697]` is mutable file-local
.data storage; its 0x15C8 declared size and eight-byte zero tail match retail.
Three source declarations make the guarded `_COPY_CHARA`, `_ESM_INITIALIZE`,
and `_COPY_MONS2SCNCHR` assembly symbols available to these typed pointer
initializers. Their guarded bodies and drafts remain byte-for-byte unchanged.
Receipt: `.private/dataA-r3/event-dispatch-table-prototypes-{build,objects,hashes}.log`.
The source-only table retains references to assembly handlers without claiming
their code as native coverage.

## Conversation camera static offsets

`_SET_TALK_CAMERA` now owns the original mutable `float vv[3][4]` static
initializer. It transforms `vv[1]`; the other two retail rows remain in the
48-byte object. The external `vv_3333` declaration and flattened indexing
are removed. Keeping the marker passes the complete object and PAL.
Removing it also passes PAL, but the canonical checker reports an unnamed
.data piece: the compiler emits `vv_3159`, and the stock mapper cannot assign
the initialized local static's retail identity. The `vv_3333` marker therefore
remains until the queued local-storage tooling supports this data family.

Receipts: `.private/dataA-r3/event-talk-camera-{static,restored}-{build,objects,hashes}.log`;
`event-talk-camera-unmarked-failure.log` records the naming-only blocker.

## Inline event argument script diagnostics

The following literals are inline at their native uses: `at_1245`, `at_1246`, `at_1333`, `at_1346__2`, `at_1357__3`.

Each datum has a separate full PAL/object/hash receipt under
`.private/dataA-r3/event-string-<symbol>-{build,objects,hashes}.log`.
Every accepted form preserves instruction bytes, resolved addresses and all
unowned object hashes. Shift-JIS characters use hexadecimal byte escapes.

## Inline event sound buffer names

The following literals are inline at their native uses: `at_1760__3`, `at_1761__3`.

Each datum has a separate full PAL/object/hash receipt under
`.private/dataA-r3/event-string-<symbol>-{build,objects,hashes}.log`.
Every accepted form preserves instruction bytes, resolved addresses and all
unowned object hashes. Shift-JIS characters use hexadecimal byte escapes.

## Inline event time display labels

The following literals are inline at their native uses: `at_1904`, `at_1905`, `at_1906`, `at_1907`, `at_1908`.

Each datum has a separate full PAL/object/hash receipt under
`.private/dataA-r3/event-string-<symbol>-{build,objects,hashes}.log`.
Every accepted form preserves instruction bytes, resolved addresses and all
unowned object hashes. Shift-JIS characters use hexadecimal byte escapes.

## Inline event resource loading paths

The following literals are inline at their native uses: `at_2245__2`, `at_2246__2`, `at_2247__2`, `at_2248__2`, `at_2249__2`, `at_2291`, `at_2292__2`, `at_2333__4`, `at_2334__3`, `at_2393__3`, `at_2664__2`.

Each datum has a separate full PAL/object/hash receipt under
`.private/dataA-r3/event-string-<symbol>-{build,objects,hashes}.log`.
Every accepted form preserves instruction bytes, resolved addresses and all
unowned object hashes. Shift-JIS characters use hexadecimal byte escapes.

## Inline event movie texture names

The following literals are inline at their native uses: `at_2836`, `at_2837`, `at_2838`, `at_2839`.

Each datum has a separate full PAL/object/hash receipt under
`.private/dataA-r3/event-string-<symbol>-{build,objects,hashes}.log`.
Every accepted form preserves instruction bytes, resolved addresses and all
unowned object hashes. Shift-JIS characters use hexadecimal byte escapes.

## Inline event script and equipment names

The following literals are inline at their native uses: `at_3328`, `at_3329__2`, `at_3631__2`, `at_3632__2`, `at_3633`, `at_3634`, `at_3635`, `at_3636`.

Each datum has a separate full PAL/object/hash receipt under
`.private/dataA-r3/event-string-<symbol>-{build,objects,hashes}.log`.
Every accepted form preserves instruction bytes, resolved addresses and all
unowned object hashes. Shift-JIS characters use hexadecimal byte escapes.

## Inline event intersection diagnostics

The following literals are inline at their native uses: `at_3822__2`, `at_4072`.

Each datum has a separate full PAL/object/hash receipt under
`.private/dataA-r3/event-string-<symbol>-{build,objects,hashes}.log`.
Every accepted form preserves instruction bytes, resolved addresses and all
unowned object hashes. Shift-JIS characters use hexadecimal byte escapes.

## Inline event fish race time digits

The following literals are inline at their native uses: `at_4261__2`, `at_4262__2`, `at_4263__2`, `at_4264__2`, `at_4265__2`, `at_4266__2`, `at_4267__2`, `at_4268__2`, `at_4269__2`, `at_4270__2`, `at_4271__2`.

Each datum has a separate full PAL/object/hash receipt under
`.private/dataA-r3/event-string-<symbol>-{build,objects,hashes}.log`.
Every accepted form preserves instruction bytes, resolved addresses and all
unowned object hashes. Shift-JIS characters use hexadecimal byte escapes.

## Inline event fishing and menu labels

The following literals are inline at their native uses: `at_4437`, `at_5262__2`, `at_5263__2`, `at_5410`, `at_5411`, `at_5412`, `at_5413`, `at_5414`, `at_5415`, `at_5416`, `at_5417`, `at_5418`, `at_5419`, `at_5420`, `at_5421`, `at_5422`.

Each datum has a separate full PAL/object/hash receipt under
`.private/dataA-r3/event-string-<symbol>-{build,objects,hashes}.log`.
Every accepted form preserves instruction bytes, resolved addresses and all
unowned object hashes. Shift-JIS characters use hexadecimal byte escapes.

## Inline event sprite and voice stream formats

The following literals are inline at their native uses: `at_5726`, `at_5736`, `at_6773__2`, `at_6774__2`, `at_6775__2`, `at_6776__2`, `at_6781__2`, `at_6782__2`, `at_6816`, `at_6834`, `at_6839`, `at_7117`.

Each datum has a separate full PAL/object/hash receipt under
`.private/dataA-r3/event-string-<symbol>-{build,objects,hashes}.log`.
Every accepted form preserves instruction bytes, resolved addresses and all
unowned object hashes. Shift-JIS characters use hexadecimal byte escapes.

## Inline event effects and dispatch diagnostics

The following literals are inline at their native uses: `at_8230`, `at_8902`, `at_8903`, `at_8904`, `at_9148`, `at_9622`, `at_9744`, `at_9745`, `at_10100`, `at_10101`.

Each datum has a separate full PAL/object/hash receipt under
`.private/dataA-r3/event-string-<symbol>-{build,objects,hashes}.log`.
Every accepted form preserves instruction bytes, resolved addresses and all
unowned object hashes. Shift-JIS characters use hexadecimal byte escapes.

## Native event switch tables

The existing native switches supply the following compiler-generated jump tables without assembly data markers: `at_1910`, `at_1909`, `at_3823__2`, `at_3884`, `at_4274`, `at_4273`, `at_4272__2`, `at_4291`, `at_4360__2`, `at_4573`, `at_5264__2`, `at_5424`, `at_6703`, `at_8406`, `at_8458`, `at_8480`.

Each removal has independent full PAL, 149-object and unowned raw-object hash receipts under `.private/dataA-r3/event-switch-<symbol>-{build,objects,hashes}.log`.

## Shared event empty literal

All native users of the shared empty string now use `""`, including the fourth language-extension pointer. Migrating every consumer together supplies native code references that identify the formerly anonymous initializer target. The `at_1083` marker and external declaration are removed; guarded drafts remain unchanged. Receipt: `.private/dataA-r3/event-empty-all-native-{build,objects,hashes}.log`.

## Switch ownership and extents

| Retail table | Native switch owner | Declared bytes | Piece bytes |
|---|---|---:|---:|
| `at_1910` | `EventTimeDraw` | 24 | 32 |
| `at_1909` | `EventTimeDraw` | 24 | 32 |
| `at_3823__2` | `_CHK_INTERSECTION_POINT` | 32 | 32 |
| `at_3884` | `_CHK_INTERSECTION_POINT_PIPE` | 32 | 32 |
| `at_4274` | `_SET_GYORACE_ETC` | 40 | 48 |
| `at_4273` | `_SET_GYORACE_ETC` | 40 | 48 |
| `at_4272__2` | `_SET_GYORACE_ETC` | 32 | 32 |
| `at_4291` | `_GET_GYORACE_ETC` | 24 | 32 |
| `at_4360__2` | `_GET_SAVEDATA_ETC` | 28 | 32 |
| `at_4573` | `_SET_EVENT_DATA` | 60 | 64 |
| `at_5264__2` | `_SET_MES_ETC` | 44 | 48 |
| `at_5424` | `_GET_FISHINGTOURNAMENT_ETC` | 40 | 48 |
| `at_6703` | `_GET_SND_ID` | 24 | 24 |
| `at_8406` | `_GET_EVENT_DATA` | 64 | 64 |
| `at_8458` | `_SET_FLOOR_INFO` | 32 | 32 |
| `at_8480` | `_GET_FLOOR_INFO` | 32 | 32 |

The declared payload contains one relocated target per four bytes. Piece tails are verified zero alignment padding; interior branch targets remain associated with the enclosing native function.

## Retained markers

Only `vv_3333` remains. It is the 48-byte mutable local static owned by `_SET_TALK_CAMERA`, already expressed naturally as `float vv[3][4]` in source. The pinned mapper cannot establish its native initialized-local identity after marker removal; the complete PAL still matches, but canonical checking fails as documented above. The source-only cleanup and tooling handoff are in `.private/proposals/event-func-native-camera-storage.{patch,md}`. No build scripts or SF profiles are edited.

All 22 BSS markers and the other 115 initialized-data markers are removed. All guarded blocks remain text-identical to checkpoint `3221b488`. No functions are promoted; the 26 callback result corrections preserve their retail instruction words and resolved references.

## Comparison section shape

The compiler emits separate native `.data` pieces while the reference comparison object retains one monolithic `.data` section. Objdiff's current pairing associates only the first native section with that reference run; other native pieces have separate zero-score section entries. This is a comparison limitation, independent of the canonical object result. `.private/dataA-r3/final-data-pieces.log` verifies every native initialized piece in both units with identical bytes and all mapped R_MIPS_32 targets.

The seven native initialized pieces total 8,760 bytes; the retained camera static owns the other 48 bytes of the 8,808-byte retail `.data` run. The aggregate `.data` score is 98.6675%, so the entire run lacks strict matched-byte credit. The native rodata, BSS, SBSS and constructor pointer sections receive their exact credit.

## Final validated measures

| Measure | Checkpoint 3221b488 | Final native source |
|---|---:|---:|
| `INCLUDE_RODATA` | 116 | 1 |
| `INCLUDE_BSS` | 22 | 0 |
| `matched_data` | 4 | 226556 |
| `total_data` | 235364 | 235364 |

Final pinned-image receipts: `.private/dataA-r3/final-{build,objects,hashes,refresh,coverage,data-pieces}.log` and `after.json`. PAL prints `SCES_511.90: OK`; all 149 canonical units pass; no unowned raw objects change. Source guards are unchanged and build scripts, SF profiles and dng_main remain untouched.


## Round-5 native data completion

The existing mutable `float vv[3][4]` local static now supplies
`vv_3333` without its marker. The initialized-local mapper proves its source
base name, exact extent, full payload and every complete retail consumer.
The function body and all guarded blocks remain unchanged.

Markers: RODATA **1 → 0**, BSS
**0 → 0**. Refreshed matched data:
**226556 → 226556 / 235364**.
The complete PAL is `SCES_511.90: OK` and all **149/149** canonical objects
pass. Only the four migrated units change object hashes in this step; code
metrics remain **6,780 functions / 1,854,796 bytes**. No function is promoted.
Receipts: `.private/dtool-r5/data-fixed-{build,objects,tests,metrics}.log`.

## Round-5 local callback comparison identities

All eight native initialized pieces now match the complete 8,808-byte
`.data` run. The comparison previously restored each native function's
original name after mapping local duplicate suffixes; that also changed
dispatch-table targets back to names belonging to callbacks in another unit.
The general comparison path now uses canonical undefined aliases only for
verified data pointers to complete, matching file-local functions. Function
identities and every serialized code relocation retain their original form.
The declared initializer extent, real pointer site, zero addend and exact
retail callback address are all required. No table or game function changes.

Matched data rises **226,556 → 235,364 / 235,364**; markers remain **0 / 0**.
Every linked object hash is unchanged. PAL is `SCES_511.90: OK`, all
**149/149** canonical objects pass, and code metrics remain
**6,780 functions / 1,854,796 bytes**. Receipts:
`.private/dtool-r5/callback-{build,objects,tests,metrics,coverage}.log`.
The pre-fix identity regression is `callback-tests-before.log` in that
directory; `callback-alias-proof.log` records complete native callback checks.
