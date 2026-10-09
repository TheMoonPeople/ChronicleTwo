# Gamedata data migration

## Baseline

At `ab376093`, all 67 functions match. Baseline markers are 46 RODATA / 16
BSS, and refreshed objdiff matched data is 36/47,820 bytes. The warm build
reports PAL OK and all 149 objects pass.

## Catalog storage

Native definitions replace 15 reservations using the established item types:
common records (432), usable items (162), weapons (116), attachments (38),
ridepod parts (68), fish (20), guard values (35 signed halfwords), and the
512-halfword item-number lookup. The constructed arrays retain their retail
initialization order. Script cursors are typed pointers; the common count is
an `int`. The public `GameItemDataManage` and `Spi*` declarations remain
source-compatible. File-local scratch names retain their 32- and 128-byte
character-array types.

`local_guarddata` owns 0x46 declared bytes; its 0x50-byte piece includes
14 zero alignment bytes. The native 35-element array preserves that declared
extent, rather than treating its alignment as five additional entries.

The 0x2800-byte name buffer has a native static character-array definition,
but its marker remains. Removing it yields an unresolved public reference
from `vutext.data.s.o` to `gamedata_sysword_buffer_1073`. This is the same
unrelocated VU-word dependency documented for FontTblBinBuff in the previous
lane; the shared VU splitter correction belongs to the tooling lane. The
buffer must remain genuinely local rather than acquire invented public
linkage to satisfy a false dependency.

The failed removal receipt is `gamedata-storage-build.log`. Acceptance with
the single marker retained is `gamedata-storage-retained-buffer-{build,
objects,metrics}.log` under `.private/dataC-r1/`: PAL OK, 149/149 objects,
and every unowned object hash unchanged. Markers become 46/1.

## Spectrumising parameters

The public `etcitem_spectol_table` retains its existing signed-byte array
declaration and has a native initializer for all 425 parameter/value pairs.
Each line holds one pair in item-number order. The 0x352-byte declared object
has a 14-byte zero alignment tail; no extra pairs are introduced. Its existing
consumer interprets parameter indices below eight as attributes and indices
10 and above as status parameters.

`gamedata-spectrum-table-{build,objects,metrics}.log` accepts the table:
PAL OK, 149/149 objects, unowned hashes unchanged. Markers become 45/1.

## Script tags

The native `gamedata_tag[25]` contains 24 exact name/callback pairs and the
null terminator. It follows its callbacks and precedes the script loader,
using the existing `SPI_TAG_PARAM` type. Strings and callback associations
are copied from the actual retail relocation words; the guard callbacks
precede the fish callbacks in the table, regardless of source function order.
The declared 0xC8 bytes receive their eight-byte zero alignment tail.

`gamedata-tags-{build,objects,metrics}.log` accepts this group with PAL OK,
149/149 objects, and no unowned object changes. Markers become 20/1.

## Command, core and message tables

`ItemCmdMsgTbl` is a native 33-by-8 signed-byte table. Negative entries
terminate command lists; zeros after each terminator remain real table data.
`table_1553` holds seven signed-halfword core item numbers and the final -1
sentinel, so its native extent is eight elements rather than the former
seven-element extern. `msg_offsettbl_1363` contains the three signed-halfword
message bases `{0, 10000, 0}`; its two trailing piece bytes are alignment.
These definitions are local, mutable, and documented without changing the
public API.

Each table passes separately in `gamedata-command-table`,
`gamedata-core-table`, and `gamedata-message-offsets` build/object/metrics
receipts. PAL stays OK, all 149 objects pass, and unowned hashes remain
unchanged. Markers become 17/1.

## Inline paths and command switch

Every ordinary string is inline at its existing use. The five separately
verified functions and receipt prefixes are:

| Function | Receipt prefix |
| --- | --- |
| `LoadGameDataAnalyze` | `gamedata-loader-string` |
| `CGameData::LoadData` | `gamedata-config-strings` |
| `CGameData::LoadItemSystemMes` | `gamedata-message-path` |
| `GetItemFileName` | `gamedata-filename-strings` |
| `GetItemFilePath` | `gamedata-filepath-strings` |

The literal directory is `mainchr/`; the earlier `main/chr/` notes are
inaccurate. Shared `.chr` literals pool naturally. No filename, path or
format behavior changes.

The existing `GetItemCmdMesList` switch supplies `at_1501` itself. Removing
its marker and unused extern passes `gamedata-command-switch` separately.
Each receipt includes a full build, all-object comparison, and unowned hash
check: PAL OK, 149/149 passing, and no unowned changes. No RODATA markers
remain; the name-buffer BSS marker is the only retained reservation.

## Typed allocator objects and buffers

`LoadItemSystemMes` now constructs a real `mgCMemory` after clearing the name
buffer, then installs that buffer and publishes `&memory`. Declaring the path
array after the manager retains both objects' retail stack order. The first
manager trial left five differing stack-offset words because its later
declaration placed it after the path; no code or call-target changes were
needed. Receipts are `gamedata-memory-object-build.log` (rejected),
`gamedata-memory-object-check.log`, and the accepted
`gamedata-memory-object-order-{build,objects,metrics}.log`.

The manager's backing buffer is a native `u_long128[0x280]`, and both file
scratch buffers are `u_long128[0x780]`. Their quadword types match the allocator
and alignment APIs and remove the input-pointer casts. Redundant guard-data
casts also disappear. `gamedata-quadword-buffers-{build,objects,metrics}.log`
records PAL OK, 149/149 objects, and no unowned hash changes.

Final markers are **0 RODATA / 1 BSS**, versus **46 / 16**. All 67 functions
remain matched; none is promoted. Refreshed source-only matched data stays
**36/47,820** because objdiff omits the linked object's data naming, ordering
and verified padding normalization. Canonical object checks verify every
migrated byte and relocation. Removing the final buffer marker awaits the
shared VU-word splitter fix, with no tooling changes made in this lane.

## Marker-free storage validation, tooling round 3

The existing raw-VU-word splitter retains numeric microcode words, so removing the local name-buffer marker creates no public VU-symbol dependency.

A fresh marker-free private compile passes the complete unit with the checkpoint
tooling. The accepted source passes `SCES_511.90: OK`, all 149 object checks,
and all 17 build regression scripts (116 discovered tests). The object hash
audit changes only `gamedata.cpp.o`; code metrics remain 6,775 matched functions
and 1,841,188 matched bytes. No function is promoted.

Markers change from 0 initialized-data / 1 BSS to 0 / 0.
Refreshed `matched_data` changes from 2090 to
47818 / 47818 bytes. Receipts are
`.private/dtool-r3/gamedata-{build,objects,tests,all-tests}.log`,
`gamedata-object-hash-audit.json`, and `gamedata-report.json`; the independent
existing-tooling probe is `probe/gamedata-check.log` in the same directory.
