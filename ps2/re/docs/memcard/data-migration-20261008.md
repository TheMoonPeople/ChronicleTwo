# Memory-card data migration

## Baseline

At `ab376093`, all 49 functions match. Baseline markers are 46 RODATA / 9
BSS. Refreshed objdiff credits 0/1,792 data bytes (`matched_data` is absent
from this unit's measures, meaning zero). The warm build reports PAL OK and
all 149 objects pass.

## Named operation state

`DngTreeSaveFlag` is a native file-static signed halfword; its two declared
bytes receive two zero piece-padding bytes. `NowProgramLoopNo` is the public
signed halfword initialized to -1, also with a two-byte alignment tail.
`SubGameOmakeTempBuffer` is the existing public byte-buffer pointer. Their
header declarations stay unchanged.

`memcard-named-state-{build,objects,metrics}.log` under `.private/dataC-r1/`
records PAL OK, 149/149 objects, and unowned hashes unchanged. Markers become
45/7.

## Costume and browser tables

`cosbit_table` is a file-static array of 34 `COSBIT_INFO` rows. Item numbers
0x6f–0x86 map to bits 0–23; 0x102–0x10b map to bits 24–33. The fourth byte
of every row is zero. The 0x88-byte table receives eight piece-padding
bytes. Both costume lookups now advance typed rows directly.

`MCBrowsetName` is a native three-region, four-category pointer table. Its
Japanese, American, and European titles retain their original Shift-JIS
bytes through octal escapes. `MCBrowserName_Offset` is a matching native
3×4 halfword array, with eight alignment-tail bytes after its 24-byte
payload. Regional selection and the formatted `%s` titles are unchanged.

Receipts `memcard-costume-table`, `memcard-browser-titles-fixed`, and
`memcard-browser-offsets` under `.private/dataC-r1/` each report PAL OK,
149/149 objects, and no unowned object changes. Markers become 30/7.
The rejected first browser-title substitution interpreted octal escapes
inside a regular-expression replacement; regenerating the source with
literal backslashes resolves that script error without changing values.

## Local aggregate templates

`MakeMemoryCardFileName` now initializes its 20-byte directory buffer and
19-byte filename buffer directly with their retail formats. `DeleteFile`
initializes its 64-byte local `darkcloud%d` buffer inside the successful
synchronization branch. `GetAllSaveFileInfo` initializes its 128-byte
save-directory search pattern at the original copy point. The anonymous
aggregate objects, extern declarations, and byte-array wrapper types are
removed; native compiler templates supply identical data and relocations.

`SetIconData` uses the SDK's `sceMcColor`, `sceMcVu0FVECTOR`, and
`sceMcColorF` types for four background colours, three light directions,
three light colours, and ambient colour. Their initialized templates remain
64/48/48/16 bytes. The retail routine copies just 16 bytes from each
array into the cleared icon descriptor, leaving its remaining entries zero;
that behavior is preserved. Icon filename fields are accessed by their
real `name` members instead of structure-address casts.

Receipts `memcard-filename-templates`, `memcard-icon-templates`,
`memcard-delete-template`, and `memcard-directory-template` each report
PAL OK, 149/149 objects, and unchanged unowned hashes. Markers become 22/7.

## Inline strings and native switches

The accepted string steps preserve `darkclonicle`, `dc2Ver4`, the legacy
`dc2Ver2` comparison, and the original diagnostic misspellings. Shared path,
filename, and version strings pool at their original addresses. Each step
has PAL, 149-object, and unowned-hash receipts under `.private/dataC-r1/`:

| Function | Receipt prefix |
| --- | --- |
| `MakeMemoryCardFileName` | `memcard-literals-MakeMemoryCardFileName` |
| `MakeMemoryCardAlbumName` | `memcard-literals-MakeMemoryCardAlbumName` |
| `Initialize` | `memcard-literals-Initialize` |
| `SetIconData` | `memcard-literals-SetIconData` |
| `Step` | `memcard-literals-Step` |
| `Write` (slash only) | `memcard-literals-Write-slash` |
| `MakeDir` | `memcard-literals-MakeDir` |
| `SaveToMc` | `memcard-literals-SaveToMc` |
| `LoadFromMc` | `memcard-literals-LoadFromMc` |
| `SaveOamkeFile` (directory only) | `memcard-literals-SaveOamkeFile-path` |
| `CheckOmakeFile` (wildcard only) | `memcard-literals-CheckOmakeFile-pattern` |
| `GetSaveFileInfoFromMc` | `memcard-literals-GetSaveFileInfoFromMc` |

Two string markers remain for genuine argument-order mismatches. Inlining
`at_1315__3` as `(const unsigned char *) "test"` in `Write` preserves the
0xfc-byte function but changes two masked words at +0x48/+0x4c: the filename
low-half load precedes the slot argument instead of following it. Casting to
mutable unsigned bytes also fails. Inlining `at_1954` as the bonus-file path
in `SaveOamkeFile` preserves its 0x4f8-byte size but changes two words at
+0x2a4/+0x2ac for the same argument-order reason. Its shared marker and
references in `LoadOmakeFile` and `CheckOmakeFile` are retained. The rejected
build receipts are `memcard-literals-Write`,
`memcard-literals-Write-mutable-cast`, and
`memcard-literals-SaveOamkeFile`. No scheduling helper or new local is added.

The existing `Step` and `MakeDir` switches supply their own `at_1230__3`
and `at_1456__3` tables. Each marker removal is checked separately in
`memcard-switch-at_<number>__3` receipts. Markers become 2 RODATA / 7 BSS.

## Native function-local state

`SearchMcType` owns a zero-initialized `static int old_format` recording the
card's initial format state. `MakeDir` owns `static int iconNo = -1`,
`SaveToMc` owns `static int test_write_num = 0`, and `GetAllSaveFileInfo`
owns `static int ReadFileNo = 0`. Their explicit externs and hand-written
initialization guard blocks disappear. MWCC naturally generates the same
three guards and all four data objects. Separate accepted receipts are
`memcard-local-old-format`, `memcard-local-icon-number`,
`memcard-local-write-counter`, and `memcard-local-read-slot`;
`memcard-local-statics-final` verifies the restored final source. Every
accepted step passes PAL, all 149 objects, and the unowned hash comparison.

Seven BSS markers remain solely for local-symbol binding. Removing only
`old_format_1242` leaves `SearchMcType` at 0x260 bytes with zero masked
instruction-word differences, but the current postprocessor leaves native
`old_format_532` unnamed in the retail layout. Removing only `init_1324`
leaves `MakeDir` at 0x5cc bytes with zero masked instruction-word differences,
but native `init_613` is likewise unbound. The canonical checker reports the
missing retail BSS piece, an unexpected unnamed piece, and unresolved targets.
The explicit markers permit the existing unique-basename local-BSS binder
and relocation-based guard binder to fold these native copies correctly.
The generated numeric suffixes are unstable compiler identities, so no
source-name or line-padding workaround is introduced.

Rejected receipts `memcard-local-old-format-marker-free-{build,check}.log`
and `memcard-local-icon-guard-marker-free-{build,check}.log` capture that
boundary. Both markers are restored before acceptance. A general marker-free
local-static/guard identity mapper is needed in the shared toolchain; this
lane makes no shared-tool edits.

## Costume count and completion-loop probe

`MC_COSTUME_COUNT` names the 34-entry table extent and both costume lookup
bounds. `memcard-costume-count` preserves PAL, all objects, and unowned hashes.

Removing the empty thirteen-iteration completion loop in
`GetAllSaveFileInfo` fails: its native size shrinks from 0x244 to 0x1f4,
with 17 differing masked words in the common prefix and 20 missing trailing
words. Retail retains the counted loop's instructions; the original loop is
restored. `memcard-completion-loop-cleanup-build.log` records the rejected
trial. No new loop, local, or scheduling helper is introduced.

## Final measurements

Final markers are **2 RODATA / 7 BSS**, versus **46 / 9**. All 49 functions
remain matched; none is promoted. The explicit final objdiff/progress refresh
credits **0/1,792** data bytes, unchanged from baseline. Source-only objdiff
does not apply the linked object's data naming, ordering, and piece-padding
normalization; the canonical object checker verifies the migrated bytes and
resolved relocations.

The two read-only markers are the `sceMcOpen` filename argument-order
blockers above. All seven BSS objects and guards are generated by native
C++ but retain markers for shared-tool binding. Private source-only
reproducer `.private/proposals/memcard-marker-free-local-bss-reproducer.patch`
removes those seven markers for the tooling lane; it is deliberately not an
accepted source change. No shared tooling, unowned file, or header is edited.

Final receipts under `.private/dataC-r1/` are `final-{build,objects,metrics}.log`,
`final-refresh.log`, `final-coverage.log`, `final-data.json`, and
`final-drawmeswin-source.log`. Coverage stays 6,754 matched / 108 guarded /
10 assembly-only / 0 fuzzy; all 289 functions across the four owned units
stay matched. `DrawMesWin`'s source body remains identical to `ab376093`.

## Filename scheduling probes, tooling round 3

The checkpoint already has no BSS markers. The two initialized-data markers
`at_1315__3` and `at_1954` still supply the test filename and shared bonus-file
path. Their baseline and final source-only `matched_data` are 691 / 1,781 bytes.

Fresh m2c output through `decompile.sh` confirms the four `sceMcOpen` callers.
Inlining both strings with the required unsigned-byte pointer casts retains
each function's declared extent but moves a filename-address instruction before
the fixed slot argument. The complete object has eight canonical findings:
one instruction-byte finding and one relocated-word finding in each caller.

| Caller | Size | Best masked word differences | Offsets |
| --- | --- | --- | --- |
| `Write` | 0xFC | 2 | +0x48 / +0x4C |
| `SaveOamkeFile` | 0x4F8 | 2 | +0x2A4 / +0x2AC |
| `LoadOmakeFile` | 0x2C0 | 2 | +0xDC / +0xE4 |
| `CheckOmakeFile` | 0x308 | 2 | +0x144 / +0x14C |

Three private forms reproduce exactly the direct-inline object: a filename
pointer local, an indexed address of the literal's first character, and a
filename pointer local with top-level const. Direct strings without the casts
fail compilation because `const char[]` cannot bind to `const unsigned char *`.
The existing `SCE_WRONLY | SCE_CREAT` and `SCE_RDONLY` SDK constants also
reproduce the direct-inline object. A fixed `const int slot` shared by the
slot-taking calls in `Write`, `SaveOamkeFile` and `CheckOmakeFile` leaves every
allocated section, symbol and relocation unchanged; only the nonallocated
string table differs. `LoadOmakeFile` has only one slot-taking call, so that
probe leaves it unchanged.

The two markers remain: the demonstrated blocker is instruction scheduling,
which data identity and padding cannot repair. No function is promoted, and
no new filename storage, source helper, compiler policy or instruction rewrite
is introduced. The retained whole project passes PAL, all 149 object checks,
all 18 build test scripts and 123 discovered tests, with unchanged code metrics.

Receipts under `.private/dtool-r3/`: `probe/memcard-{compile,check}.log` and
`memcard-agent/{decompile,pointer,indexed,const-pointer,direct-string,sdk-flags,
const-slot}/`; `memcard-agent/findings.md` and the per-variant word-diff and
object-hash receipts record the comparisons. The final object hash audit leaves
`memcard.cpp.o` byte-identical to the warm baseline.
