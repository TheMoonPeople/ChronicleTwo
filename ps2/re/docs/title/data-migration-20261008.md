# Title data migration

Round-5 baseline: `8a85b297`, canonical MWCC 3.0-011126 flags and
`chronicletwo_dev:sf-63f7a9e`. The warm build passes `SCES_511.90: OK` and
149/149 complete objects. Fresh objdiff measures are 61 RODATA markers,
76 BSS markers and **4 / 2064 matched_data / total_data**.

## Ownership boundary

The guarded TitleBootInit block, its data declarations and its markers are
unchanged. The protected set is the union of its draft identifiers and the
retail ELF relocation targets. Both sets agree for title's retained markers.
Existing title.hpp declarations and all other units remain source-compatible.
The existing title investigation notes and the SF profile are unchanged.

## Title state storage

Typed definitions replace the reservations for the first-boot attract flag,
camera animation state, debug unlock byte, demo movie selection, extras and
costume bits, active memory card port, memory card message pointer, title
phase and prompt pulse direction, trial fade state, copyright/logo phase and
counter, logo skip flag, E3 trial state, START indicator, title extra flag,
boot card-check state and attract movie state.

The byte and halfword definitions use their documented retail access widths;
the four-byte marker slots include alignment rather than additional fields.
`RushInfo` is the existing 0x18-byte RUSH_INFO, with its complete 0x20-byte
piece supplied by verified NOBITS reservation padding. MasterDebugModeOn and
CostumeOptionEnv retain external linkage; unit-owned state has file linkage.
The existing header defines and documents all required types.

Each datum has its own incremental PAL build, all-object check and audit under
`.private/dataB-r5/bss-<name>-{build,objects,audit}.log` (audit files use `.json`).
The audit requires every object outside title to retain its baseline file hash
and verifies the protected declarations, markers and complete boot block.

## Title state validation

RODATA / BSS markers: **61 / 76 → 61 / 49**. Fresh objdiff data measures
remain **4 / 2064**. Aggregate section credit remains incomplete while the
remaining title reservations are present. No function is promoted.

Receipts: `.private/dataB-r5/state-final-{build,objects}.log`,
`state-final-audit.json`, `state-progress.log` and `state-metrics.json`.

## Installer and language storage

Fourteen typed installer definitions supply the phase, confirmation action,
slideshow selection, drawing flags, texture and message pointers, menu
selection, ten texture pointers and ten image alphas. Both arrays have the
retail 0x28-byte declared extent; the eight bytes through each 0x30-byte piece
are alignment. No extra array entries or filler objects are declared.

Six definitions supply the language selection, phase, cursor position, fade
alpha, cursor animation count and texture pointer. The language phase is an
int, even though its marker reserves eight bytes. Its exact four-byte declared
extent owns the verified gap to the next piece.

TitleHDDInstallDraw uses a natural `static int count = 0` inside the controls
branch. MWCC emits both the counter and its one-time initialization guard,
replacing count_2647/init_2648 and their manual initialization scaffolding.
All function bytes and resolved relocation targets remain exact.

RODATA / BSS markers after this group: **61 / 27**. Fresh objdiff data
measures are **468 / 2064**. The large BSS section is now fully native.
Receipts: `.private/dataB-r5/bss-hdd-steps.log`, `bss-lang-steps.log`,
`cursor-static-{build,objects}.log`, `storage-final-{build,objects}.log`
and `storage-metrics.json`.

## Native initializer and switch data

The existing natural local initializers supply these exact templates without
reservations:

| Marker removed | Native owner and payload |
|---|---|
| `at_1594__3` | TitleModeInit camera position: `{1.2f, 2.3f, 550.0f, 1.0f}`. |
| `at_1595__4` | TitleModeInit camera follow target: `{-70.1f, 280.8f, -493.0f, 1.0f}`. |
| `at_1924` | TitleMapDraw origin: `{0.0f, 0.0f, 0.0f, 1.0f}`. |
| `at_2646__2` | TitleHDDInstallDraw cursor coordinates: `{160.0f, 180.0f}`. |

The existing switches supply all seven table pieces, including every
R_MIPS_32 target and interior function addend: TitleLoop (`at_1481__3`,
`at_1480__3`), TitleDraw (`at_1495__3`), TitleMCCheckKey (`at_2182__3`),
TitleCopyRightDraw (`at_2310`) and TitleHDDInstallKey (`at_2607`, `at_2606`).
No function body changes for this group.

RODATA / BSS markers: **61 / 27 → 50 / 27**. Data measures remain
**468 / 2064** because protected pieces still make the initialized aggregate
sections incomplete. Per-piece receipts are
`.private/dataB-r5/native-<name>-{build,objects}.log` and the corresponding
`-audit.json`; the group ledger is `native-steps.log`.

## Inline strings

Seventeen literal markers and their anonymous extern declarations are replaced
by literals at their actual uses. The protected boot strings shared by other
functions remain under their original declarations and markers.

| Function | Inline literal purpose |
|---|---|
| InitOmakeEnv | Fish-race map name `i03h04`. |
| TitleExit | Extras diagnostic format `OMAKE : %d\n`. |
| TitleLoop | New-game map name `m02`. |
| InitRushMovie | Attract movie path `RUSH.PSS`. |
| TitleMapDraw | Water and reflection texture names `water` and `ref`. |
| TitleCopyRightStep | Publisher movie path `L5LOGO.PSS`. |
| TitleHDDInstallInit | Installer image paths, slideshow texture formats, progress-bar/background texture names and language message path format. |
| TitleLangSelInit | Language menu image path `title/lang_select.img` and texture name `lang_select`. |

All migrated string bytes are ASCII. The function-level steps preserve every
instruction and resolved data reference. Their receipts are
`.private/dataB-r5/strings-<first-marker>-{build,objects}.log` and the
corresponding `-audit.json`; `string-steps.log` lists all eight steps.
RODATA / BSS markers after this group are **33 / 27**; data measures
remain **468 / 2064**.

## Typed initialized tables

The four initialized menu tables are defined in retail order with their actual
object extents, followed by the eligible small initialized data:

| Definition | Declared extent and purpose |
|---|---|
| `start_button_tbl_1826[7]` | Seven existing MENU_SHORT_RECT records, 0x38 bytes, indexed by LanguageCode. |
| `btn_tblxy_1830[5][2]` | Five short texture-origin pairs, 0x14 bytes, in title menu row order. |
| `table_2611[3][12]` | Three rows of three four-short rectangles, 0x48 bytes, for the installation panel. |
| `infomsg_2664[7]` | Seven caption pointers, 0x1C bytes, with three inline string payloads; five rows share `Installing...`. |
| `TitleRushWaitCount` | Four-byte idle-frame limit initialized to 750. |
| `TitleMCCheckFileFind[2]` | Two short save-file counts initialized to zero, four bytes. |
| `TitleMCCheckInport[2]` | Two inserted-card bytes initialized to zero, two bytes. |
| `cnttbl_2026[2]` | Signed-byte prompt pulse speeds `{2, 4}`, two bytes. |

The rectangular tables remain mutable, matching their existing interfaces and
the short-pointer drawing API. MENU_SHORT_RECT remains the existing shared
type; title.hpp is unchanged. Initialization uses only actual elements, with
no padding entries or filler definitions. The postprocessor supplies the
verified zero gaps to the next retail piece. The pointer table reproduces every
R_MIPS_32 field and its pooled-string target.

Per-table receipts are `.private/dataB-r5/table-<name>-{build,objects}.log`
and `-audit.json`; the pointer-caption group is `table-infomsg-*`.
`table-steps.log` records all eight successful steps. `tables-order-*` verifies
the final definition order.

## Retained markers

Every marker below is retained because the round-5 brief freezes every
TitleBootInit data declaration and marker while the nmmenu lane owns its
improvement. Its guarded draft and retail assembly reference this exact set.
No eligible marker remains; none requires a tooling change or shared-header
proposal. Shared boot strings used by other title functions keep their existing
extern declarations and references.

### Protected initialized data

| Retained RODATA marker | Retention reason |
|---|---|
| `MC_ICON_Data` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `at_1221__4` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `at_1222__4` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `at_1223__4` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `at_1224__4` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `at_1225__4` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `at_1226__4` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `at_1227__3` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `at_1228__3` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `at_1229__2` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `at_1230__2` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `at_1231__2` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `at_1232__2` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `at_1233` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `at_1234` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `at_1235` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `at_1236` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `at_1237__2` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `at_1238` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `at_1239__2` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `TitleProjection` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `TitleHDDCheckFlag` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |

### Protected uninitialized data

| Retained BSS marker | Retention reason |
|---|---|
| `TitleSelectInit` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `TitleMap` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `TitleCamera` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `TitleCamera2` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `WaveTable__3` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `GameBootInit` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `TitleBootEventNo` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `DCRuncherMode` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `DCRuncherCounter` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `TitleInfo` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `TitleMCFuncFlag` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `TitleMCCheckNow` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `TitleMainMCCheckPhase` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `TitleMCCheck` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `Tex_TitleBG` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `Tex_Chronicle` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `Tex_Logo` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `Tex_Plate` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `Tex_TitleLight` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `Tex_TitleCursor` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `Tex_TrialMsg` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `Tex_TitleBG2` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `RushMovie` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `RushStart` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `RushWork` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `TitleScene` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |
| `TitleEventSound` | Direct TitleBootInit data reference; declaration and marker frozen by the brief. |

## Final measurement and validation

- RODATA / BSS markers: **61 / 76 → 22 / 27**.
- Native markers removed: **39 RODATA and 49 BSS**.
- Fresh objdiff matched_data / total_data: **4 / 2064 → 468 / 2064**.
- PAL verifier: **SCES_511.90: OK**.
- Complete object comparison: **149/149**.
- All 148 objects outside title retain their baseline file hashes.
- TitleBootInit's complete guarded block, all 49 protected markers and their
  existing declarations are unchanged. Both SF-controlled function bodies and
  title.hpp are unchanged.
- Functions promoted or matching attempts: **none**. Shared-file proposals:
  **none**. No failed migration probe is retained or required.

Data credit is a section-level lower bound: protected pieces leave the
initialized and small-BSS aggregate sections incomplete, despite the remaining
eligible objects now having native definitions. The final large BSS section
accounts for the 464-byte increase.

Final source validation receipts are `.private/dataB-r5/tables-order-build.log`,
`tables-order-objects.log` and `tables-order-audit.json`. Fresh metric/coverage
receipts are `final-progress.log`, `final-metrics.json` and `final-coverage.log`.
The complete inventory and protection audit are `inventory.json`,
`boot-retail-references.json`, `final-marker-audit.json` and `final-audit.json`.
