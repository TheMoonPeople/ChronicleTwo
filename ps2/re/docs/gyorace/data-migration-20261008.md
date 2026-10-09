# Fish-race data migration, October 8 night

The current source has **13 RODATA / 2 BSS** markers. Only
`sgLoopGyoRace` remains guarded. Its thirteen constants and the two
`DivSpriteScreen` vector templates (`at_1775`, `at_1776`) remain supplied
by assembly. The round-4 and round-6 tables below describe earlier
checkpoints; the final three completion sections supersede their BSS lists.

Baseline: `9eb8f660`, pinned SF image, canonical flags and unchanged profile.
The existing race, camera, effect and fish layouts supply the types. Neither
sgInitGyoRace nor sgLoopGyoRace, including their guarded drafts, is changed.

## Native tables and state

`fish_name` is the exported 18-entry character-model pointer table with
inline filenames. The compiler emits its 18 string objects; verified piece
padding supplies the eight bytes before `cam_pos`. No extra entries are
introduced. `cam_pos` is five SDK float vectors, each with homogeneous
component 1.0. The previous-camera sentinel is `static int old_cam_no = -1`.
Each table is migrated and checked independently.

The race counters, commentary state, sound handle, textures, effect pointers,
camera identifier, race selection and entrant arrays become documented typed
definitions under their retail symbols. File-local state remains static;
the published symbols retain their header declarations. In particular,
`battle_EffectPara` points to arrays of 32 BattleEffectPrim objects.

Retail `game_data` is a six-pointer array: readelf gives its declared
symbol size as 0x18 at 0x01F59740. The 0x20-byte reservation includes eight
alignment bytes. The inactive draft's eight-entry declaration is not its
retail type; the native definition follows the six-entry layout already
recorded in notes.md. The result, simulation and fish-display arrays retain
their established element types and six-entry counts. Alignment gaps do not
become source fields.

The initial migration used the draft's eight-entry declaration and still
passed PAL/object checks, so those checks alone do not validate this source
extent. The final declaration is corrected to the ELF size and validated
again. This supersedes the initial migration's eight-entry note.

## Round-4 assembly-owned constants (historical)

The following markers remain because the guarded assembly functions access
their retail symbols directly. Compiler-generated anonymous identities from
inactive draft bodies cannot replace these live references. No literal is
renamed, exported artificially or moved into a dummy object.

| Consumer | Retained markers |
|---|---|
| sgInitGyoRace vector templates | `at_1027__4`, `at_1028__9` |
| sgInitGyoRace filenames, formats and names | `at_1373__3`, `at_1374__2`, `at_1375__2`, `at_1376__2`, `at_1377__4`, `at_1378__3`, `at_1379__3`, `at_1380__2`, `at_1381`, `at_1382__2`, `at_1383__3`, `at_1384__2` |
| sgLoopGyoRace vector and rectangle templates | `at_1481__4`, `at_1524__2`, `at_1547`, `at_1548` |
| sgLoopGyoRace names and diagnostics | `at_1696__2`, `at_1697__3`, `at_1698__3`, `at_1699__3`, `at_1700__2`, `at_1701`, `at_1702`, `at_1703` |

`at_1380__2` is shared by Init and Loop; `at_1384__2` also shares text with
the native commentary path. Their assembly consumers still require the
retail symbols even where a native caller already uses an inline literal.

## Round-4 drawing data and retained BSS markers (historical)

The existing `float step[4] = {0, 0, 0, 1}` supplies `at_1766__3` without
its marker. The existing `lap_inf[2][5]` supplies its BSS template and verified
piece padding. The raster phase and its initialization flag become typed
file-local float and signed-char definitions under their existing symbols;
the active helper's initialization and arithmetic remain unchanged.

A natural function-static `float ras_off = 0.0f` reproduces the complete PAL
image, but check_objects rejects its two anonymous small-BSS identities
(missing ras_off_1762/init_1763, two unexpected unnamed pieces). The exact
symbol definitions pass both checks. This is a naming/tooling limitation,
not a reason to change flags, the profile or the retail function.

| Retained BSS marker | Reason |
|---|---|
| `at_1765__2` | The existing origin-array initialization alone does not preserve the unit initializer's reference: removing the marker changes `__sinit_gyorace_cpp+0x10`. Retained pending template identity handling. |
| `at_1775`, `at_1776` | SDK integer-vector zero initializers with memcpy of the origin change the strip helper and linked initializer layout. A typed aggregate containing an SDK integer vector, with ordinary value assignment, also changes linked code. Keeping these markers restores its startup initializer but leaves a text mismatch. The exact original body is restored; no new pun or copy helper is retained. |
| `D_01F5971C` | This four-byte explicit boundary follows the fish-rank reservation. Removing it changes the linked unit initializer reference at +0x10. No filler object is introduced to preserve the boundary. |
| `lap_inf2_1799` | The natural five-int local has a 0x14-byte payload and a 0x50-byte terminal reservation. The PAL image matches without its marker, but check_objects rejects the BSS run ending at 0x01F599C4 instead of 0x01F59A00. The 0x3C-byte terminal gap requires tooling support. |

All failed variants and their receipts remain in `.private/dataB-r4/gyorace-*`.
The retained source uses neither a new alignment filler nor an artificial
initializer/vtable helper. No header or other unit is changed.


## Measurement and validation

Markers (RODATA / BSS): **48 / 40 → 26 / 5**.
Fresh objdiff `matched_data / total_data`: **4 / 2729 → 125 / 2729**.

`gyorace-final-build.log` prints `SCES_511.90: OK`; `gyorace-final-objects.log`
passes 149/149 objects. These receipts, the incremental checks, baseline
measurements and object-hash audit are under `.private/dataB-r4/`.
All objects outside the seven owned units retain their baseline file hashes.
No function is promoted and no assembly fallback or guarded function body changes.

## Round 6: native initialization vectors

Baseline `c935aa16` has native `sgInitGyoRace`, with documented SDK
`sceVu0FVECTOR` local initializers for position `{0, -15, 0, 1}` and
rotation `{0, 3.1415927f, 0, 1}`. They supply the two 0x10-byte templates
at `0x3621F0` (`at_1027__4`) and `0x362200` (`at_1028__9`). Neither has
an assembly or guarded-draft consumer now, so both markers are removed.
The initializers and every function body remain unchanged.

With a marker present, `postprocess_object.py::bind_local_data` redirects
native relocations to that marker's retail address, checks the redundant
native payload against retail and marks the unused copy `.dead`.
`fixup_sections.sh` removes it. This explains the matching baseline despite
the source containing both native literals and their markers. Without a
marker, `name_literal_data` names the native template through its payload
and real consumers; verified piece padding preserves the retail extent.
No replacement named template, filler or artificial initializer is needed.

The warm build passes PAL and 149/149 complete objects; gyorace checks
0x4FF8 bytes and 1,114 resolved relocations. Removing these two markers
also passes PAL and 149/149 objects. Marker counts become **24 RODATA /
5 BSS**, from **26 / 5**. Fresh objdiff `matched_data / total_data` remains
**125 / 2729**; marker removal does not change the existing native source
forms measured by objdiff. All other 148 object hashes equal the warm
baseline, and all function source is identical.

Receipts are in `.private/dataB-r6/`: `warm-build.log`, `warm-objects.log`,
`warm-gyorace-object.log`, `before-progress.log`, `before-snapshot.json`,
`vectors-build.log`, `vectors-objects.log`, `vectors-progress.log` and
`vectors-snapshot.json`.

## Round 6: native initialization strings

The eleven freed string markers have these existing inline source forms:

| Retail symbol | Address | Declared size | Purpose or literal |
|---|---:|---:|---|
| `at_1373__3` | 0x3785B0 | 0x14 | `snd2/mon/EN_902.snd` sound bank |
| `at_1374__2` | 0x3785C8 | 0x9 | `/sg/gyo/` resource directory |
| `at_1375__2` | 0x3785D8 | 0xC | `gyore%d.mes` localized commentary filename |
| `at_1376__2` | 0x3785F0 | 0x37 | Simulation-seed diagnostic |
| `at_1377__4` | 0x378630 | 0x35 | Player-fish fatigue diagnostic |
| `at_1378__3` | 0x378670 | 0x4B | Entrant-name and tactics diagnostic |
| `at_1379__3` | 0x3786C0 | 0x9 | `info.cfg` character configuration |
| `at_1381` | 0x3786E0 | 0x13 | `grttex_new6_%d.img` localized atlas filename |
| `at_1382__2` | 0x378700 | 0x10 | `grttex_new6.img` fallback atlas filename |
| `at_1383__3` | 0x378710 | 0x9 | `grt_moji` time-digit texture |
| `at_1384__2` | 0x378720 | 0x5 | `grt1` window texture, shared with native SysDraw |

No remaining assembly or guarded-draft code uses these eleven objects.
Removing their markers leaves each literal inline, with verified native
identity and retail alignment padding. The `grt1` string remains shared
between both native callers. The Shift-JIS motion string `at_1380__2`
still has a Loop consumer and keeps its exact marker and draft declaration.

The thirteen retained RODATA markers are all required by Loop:

| Objects | Purpose |
|---|---|
| `at_1481__4`, `at_1524__2`, `at_1547`, `at_1548` | Direction, rotation, ambient-colour and camera-position templates |
| `at_1380__2`, `at_1700__2` | Ordinary-swim and battle motion names |
| `at_1696__2`, `at_1697__3`, `at_1698__3`, `at_1699__3` | Gate map part, piece and left/right frame names |
| `at_1701`, `at_1702` | Blank result name and result diagnostic |
| `at_1703` | Six-entry switch jump table, not a diagnostic string |

`at_1703` occupies 0x18 bytes at `0x3787C0`. Loop uses its base at
offsets +0x4C/+0x54; its targets are Loop offsets 0x68, 0x2B4, 0x4B8,
0x4B8, 0x1028 and 0x1598. Its marker remains unchanged with the other
twelve Loop markers; no function or draft declaration changes.

PAL and 149/149 objects pass. The unit now has **13 RODATA / 5 BSS**
markers; fresh objdiff `matched_data / total_data` remains **125 / 2729**.
The other 148 object hashes and all function source remain identical to
the warm baseline. Receipts under `.private/dataB-r6/` are
`strings-build.log`, `strings-objects.log`, `strings-progress.log`,
`strings-snapshot.json` and `strings-hash-audit.json`.

## Round 6: texture allocator and retained BSS

Retail `BuffTextureData` is a LOCAL object at `0x1F59770`, with declared
size 0x30 and the established `mgCMemory` layout. One documented
`static mgCMemory BuffTextureData` definition replaces its early extern;
the late global definition is removed. It holds the commentary buffer
and loaded texture resources. No header declaration is appropriate for
this file-local object. Native symbol binding and declared size now both
agree with retail.

Its relative construction order remains Texture, Work, then camera.
At this data-migration checkpoint the generated unit initializer, its
relocations and every game function remained byte-identical. Later Loop
draft edits are recorded in [night-20261008.md](night-20261008.md); its
assembly fallback and retained data markers remain active.

At the round-6 checkpoint, Init's promotion freed none of the five BSS
markers. The completion sections below subsequently remove `lap_inf2_1799`,
`D_01F5971C` and `at_1765__2`, leaving only `at_1775` and `at_1776`.
The round-4 negative
experiments are not repeated, and no tooling or function body is changed:

| Retained BSS | Current consumer and blocker |
|---|---|
| `D_01F5971C` | Explicit boundary before `old_fish_rank`; retail Jikkyou +0x4A8/+0x4B0 uses this address as `old_fish_rank - 4`. Native Jikkyou already has that correct negative addend. There is no independent retail object or Loop consumer; a filler definition would be artificial. Earlier deletion changed the initializer reference. |
| `at_1765__2` | Native DivSpriteScreen origin-array template; removing its marker previously changed the initializer reference at +0x10. Anonymous BSS identity requires tooling support. |
| `at_1775`, `at_1776` | Native DivSpriteScreen vector templates; the documented natural SDK/aggregate replacements changed helper or initializer code. Their function body remains frozen. |
| `lap_inf2_1799` | Native SysDraw total-time digit array has a real 0x14-byte payload and a 0x50-byte terminal reservation. Earlier marker removal passed PAL but failed the object extent; no fake extra digits fill the 0x3C-byte tail. |

Final markers are **13 RODATA / 5 BSS**, from **26 / 5** at `c935aa16`.
Fresh objdiff `matched_data / total_data` is **125 / 2729 → 125 / 2729**.
The full PAL build and all **149/149** complete objects pass. Only
gyorace's object file changes hash; the other 148 equal the warm baseline.
Coverage remains **6,782 matched / 81 guarded / 9 assembly-only / 0 fuzzy**.
No function is promoted or attempted and no shared-file proposal is needed.

Final receipts under `.private/dataB-r6/`: `texture-build.log`,
`texture-symbol-audit.json`, `final-objects.log`, `final-progress.log`,
`final-coverage.txt`, `final-snapshot.json` and `final-hash-audit.json`.
The original source and full marker/retail-data inventories are also saved
there for the coordinator's audit.


## Round-5 native data completion

The existing five-int `lap_inf2` local now supplies its terminal BSS
piece without a reservation marker. Its 0x14-byte declared payload is unchanged;
the existing canonical checker verifies the linker's 0x3C-byte zero tail at
the exact contents end. No drawing code, guarded draft, INCLUDE_ASM line,
array extent, or constructor changes.

Markers: RODATA **13 → 13**, BSS
**5 → 4**. Refreshed matched data:
**125 → 125 / 2729**.
The complete PAL is `SCES_511.90: OK` and all **149/149** canonical objects
pass. Only the four migrated units change object hashes in this step; code
metrics remain **6,780 functions / 1,854,796 bytes**. No function is promoted.
Receipts: `.private/dtool-r5/data-fixed-{build,objects,tests,metrics}.log`.

## Round-5 native ranking alignment boundary

The existing six-int `fish_rank` and `old_fish_rank` arrays have 24-byte
declared extents at `0x01F59700` and `0x01F59720`. Both native sections
have 16-byte alignment. The eight-byte gap is therefore required by the
compiler; its canonical reference at `0x01F5971C` separates the final four
bytes. Verified native alignment now supplies that zero fragment under
`D_01F5971C`, so the reservation marker is removed. The original
`old_fish_rank` relocation and -4 addend remain intact.

Only the data marker and its empty data guard are removed. All source
functions, guarded drafts and INCLUDE_ASM lines remain unchanged. The
remaining three BSS templates and thirteen Loop constants retain their markers.

Markers: RODATA **13 → 13**, BSS **4 → 3**. Refreshed matched data remains
**125 / 2729** because the other retained pieces leave their aggregate
sections incomplete. PAL is `SCES_511.90: OK`, all **149/149** objects pass,
and only `gyorace` and the simultaneously migrated `dngfloor` object change
hashes. Code metrics remain **6,780 functions / 1,854,796 bytes**.
Receipts: `.private/dtool-r5/alignment-data-{build,objects,tests,metrics}.log`.
The missing-fragment regression before the tool fix is
`.private/dtool-r5/alignment-tests-before.log`.

## Round-5 native origin zero template

The existing four-int origin initializer emits a native 16-byte anonymous
BSS template. Its consumer is the file-local `DivSpriteScreen`, whose retail
function name has a duplicate suffix. The native zero-template mapper now
requires that unique local identity and the consumer's complete matching
instruction bytes, extent and resolved relocations. Its second pass runs
after the step-vector literal identity is established. This supplies
`at_1765__2` naturally; its marker and unused external declaration are removed.
The function body, all drafts and all INCLUDE_ASM lines remain unchanged.

The new suffix path applies only to anonymous compiler templates. Named
statics retain their established mapper order, preserving the exact baseline
object bytes in every non-target unit. Unmatched, ambiguous, incomplete or
additional unknown consumers reject the candidate. The two remaining zero
templates still require natural vector-copy source work; no union-based
initializer or new type-pun is introduced to force their data emission.

Markers: RODATA **13 → 13**, BSS **3 → 2**. Refreshed matched data remains
**125 / 2729**. PAL is `SCES_511.90: OK`, all **149/149** objects pass,
and only `gyorace.cpp.o` changes from the preceding accepted step. Code
metrics remain **6,780 functions / 1,854,796 bytes**. Receipts:
`.private/dtool-r5/bss-anonymous-{build,objects,tests-after,metrics}.log`.
The pre-fix identity and named-static-scope regressions are
`bss-consumer-tests-before.log` and `bss-anonymous-tests-before.log` in
the same directory.
