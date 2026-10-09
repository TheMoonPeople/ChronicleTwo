# editdata: reverse-engineering notes

Saved Georama town layout (`CEditData`, five of them in `CSaveData` at +0x1C24, stride
0x5510) and the town analysis (requests/conditions) read from `geo%d.cfg`.
No first-game counterpart (the first game's `edit.hpp` has no CEditData / analysis classes).

## Classes

### EditAnalyzeDataSrc (0x1C)
Size: `EditAnalyzeSrc::Init` steps 0x1C over 16 entries from +0x180; `GetAnalyzeDataSrc` stride 0x1C.
| Off | Type | Evidence |
|---|---|---|
| 0x00 | `char *message` | eaANALYZE arg 3 via mgCopyString; menu `CFont::SetStr(*p)`; FutureMapSelect prints it; 0 = unused (GetAnalyzeDataSrc stops at first 0) |
| 0x04 | `s16 percent` | eaPERCENT; summed by GetAnalyzePercent (lh) |
| 0x06 | `s16 geo_floor` | eaANALYZE optional arg 4; editmenu `MakeDownLoadAnaunce` does `GetFloorInfoPtr(v/100, v%100)` and tests floor flag 0x100 (geostone found) |
| 0x08 | `s8 con_no[8]` | eaCON_NO, terminated by 0xFF; Init fills 0xFF; read with lb |
| 0x10 | `s32 unk_10` | eaANALYZE arg 2; Init sets -1; never read anywhere |
| 0x14 | `char *on_parts` | eaON_PARTS; PartsOnOff passes to GetOnOffParts, vfunc 0x54 called with flag |
| 0x18 | `char *off_parts` | eaOFF_PARTS; same with `!flag` |

### EditAnalyzeSrc (0x340)
Size: `__sinit_editdata_cpp` = `__construct_array(AnalyzeSrc, ctor, 0, 0x340, 5)`.
0x000 `char *condition[64]` (eaCONDITION arg 2; dbgGetContintionFlag strcpy), 0x100 `s16 geo_floor[64]`
(eaCONDITION optional arg 3; menu uses like the request's geo_floor), 0x180 `EditAnalyzeDataSrc data[16]`.
Ctor `__ct__14EditAnalyzeSrcFv` sits after GetMaxDrawMem (end of unit) => inline in class body, `{ Init(); }`.

### CEditData (0x5510)
Size: `memset(this,0,0x5510)` in Initialize; stride 0x5510 in CSaveData::GetEditData,
`__sinit_mainloop_cpp`, memcard/convviewlp ctor loops.
| Off | Field | Evidence |
|---|---|---|
| 0x0000 | `s32 save_count` | EditDataSave: `++*(int*)data`; InitialPlaceParts places the map's start parts only when 0 |
| 0x0004 | `s32 culture_point` | EditDataSave stores `CultureAnalyze(0)`; editanalyze compares with thresholds (30/50/60/80/100) |
| 0x0008 | `s32 parts_max` | InitPlaceData sets 300; loop bound in GetPartsNumID, LoadData; SaveData overflow check |
| 0x000C | `EditDataParts parts[300]` | stride 0x24, ctor loop ends at 0x2A3C |
| 0x2A3C | `s32 house_max` | InitPlaceData sets 0x20 |
| 0x2A40 | `EditDataHouse house[32]` | stride 0x10, ctor loop ends 0x2C40 |
| 0x2C40 | `EditPlaceLog place_log[0x800]` | {s16,s16}; Save/Load copy CEditMap::place_log, fill 0xFFFF; indices remapped to parts[] index |
| 0x4C40 | `u8 grid[0x400]` | byte stream of river grids, see below; "grid data over!!!" when >= 0x400 |
| 0x5040 | `EditDataAnalyze analyze` | memset 0xD0 in ctor and Initialize |
| 0x5110 | `u8 unk_5110[0x400]` | only cleared by the 0x5510 memset; no other access found in any unit |

The mainloop ctor (0x195960) does: pointer loop memset 0x24 over parts, pointer loop memset
0x10 over house, memset 0xD0 at 0x5040, then `Initialize()`. Modelled as inline element ctors
`memset(this,0,sizeof)` for EditDataParts / EditDataHouse / EditDataAnalyze plus
`CEditData() { Initialize(); }`. InitPlaceData also memsets each parts/house entry in a loop
bounded by parts_max/house_max (maybe an inline clear method; unverified).

#### EditDataParts (0x24), written by CEditMap::SaveData, read by LoadData
0x00 `s32 id` (= `CEditParts::info->id`), 0x04 `s8 state` (CEditParts::state, lb; GetPartsNumID
counts id match && state != 0; LoadData maps 1 -> 0 then restores rested parts), 0x05 `s8 angle`
(ConvEditAngle / GetEditAngle, lb), 0x06 `s16 pos[3]` (GetEditPos -> fptosi), 0x0C `u8 color[4][3]`
(GetColor * 128 clamped 0..255; load divides by 128, lbu), 0x18 `s16 house_no` ((house - &map->house[0]) / 0x10 + 1,
0 = none), 0x1A..0x24 never accessed.

#### EditDataHouse (0x10)
Only +0 (s16) is used: Save copies `CEditMap::house[i].npc_no[0]` (CEditMap+0xD4C + i*0x10) into it,
Load copies back (sign-extended). Rest unaccessed.

#### EditDataAnalyze (0xD0)
0x00 `s8 data_open[16]` (editmenu `MenuAnalyzeData[i] = 1` when request revealed; gcALL_GEO_PARTS sets all 16),
0x10 `s8 condition[64]` (CEditData+0x5050: Analyze/Analize/dbg*; lb), 0x50 `s8 condition_open[64]`
(editmenu `MenuAnalyzeData[con+0x50]`; gcALL_GEO_PARTS sets 64; `MenuAnalyzeData[0x55]` checked for map 0 -> SetBitFlag(0x21)),
0x90..0xD0 unaccessed. `MenuAnalyzeData` (editmenu global) = `&data->analyze`.

#### grid byte stream (0x4C40)
Per non-NULL CEditMap::grid[i]: u8 width (grid+0), u8 height (grid+4), s16 x,y,z (GetEditPos of grid+0x20),
header is 0x18 bytes (8 written, rest zero); then width*height bytes, bit0 = river cell (GetFast / SetRiver);
padded to even. LoadData printf("%d %d %d") of the position.

## Globals (all LOCAL in retail -> `static` in the .cpp, not in the header)
- `AnalyzeSrc` (.bss 0x1040) `EditAnalyzeSrc AnalyzeSrc[5]`.
- `eaAnaSrc` `EditAnalyzeSrc *`, `eaAnaData` `EditAnalyzeDataSrc *`, `eaStack` `mgCMemory *` (.sbss): parser state of the tag handlers.
- `tag` (.data 0x50): file-local `static SPI_TAG_PARAM tag[10]` = GEO_ANALYZE, CONDITION, ANALYZE, CON_NO,
  ON_PARTS, OFF_PARTS, PERCENT, END_ANALYZE, END_GEO_ANALYZE (names inlined in each row), {0,0}. The
  handlers and the script-running overload have retail-local binding (`static`).
- `buff` (`static u_long128 buff[0x300]`, 0x3000 bytes), `Stack` (`static mgCMemory Stack`, 0x30) and the
  compiler-generated one-byte constructor guard are function-local statics of
  LoadEditAnalyzeData(int,u_long128*); the manager's inline constructor calls `Init`, and MWCC emits
  the retail guard test. The guard's piece is four bytes (three alignment bytes before `eaAnaSrc`).
  The function prints the remaining stack (`(Stack.+0x28 - Stack.+0x24) * 16 / 1024` kB).
- The unit has no data markers. The diagnostic strings of `SaveData`, `LoadData`, `Analyze` and
  `LoadEditAnalyzeData` are inline literals with the exact retail text (`infinty loop!!!`, the
  extra exclamation marks on the parts limit, no newline on the grid message,
  `GeoData Remain = %dkbyte`, filename `geo%d.cfg`).

## Functions
- `EditAnalyzeDataSrc::Init` clears the message, percentage, floor and part-name pointers,
  marks all eight `con_no` entries as -1, and leaves `unk_10` at -1. `CEditData::Initialize`
  clears the whole 0x5510-byte layout, calls `InitPlaceData`, then clears the 0xD0-byte
  `analyze` state again.
- The two-argument `GetAnalyzeFlag` passes two eight-element local arrays to its four-argument
  overload. `dbgSetAnalyzeFlag` visits the request's condition numbers until the first -1 and
  sets each flag. `dbgSetAllContintionFlag` writes all 64 condition values in groups of eight;
  its map argument is unused.
- Local (static, in .cpp): GetAnalyzeDataSrc(int map,int data) -> EditAnalyzeDataSrc* (NULL if map>4, data>15, or any
  entry 0..data has message==NULL); GetCulturePoint(CEditParts*,int) -> `info+0xC` (2nd arg unused);
  LoadEditAnalyzeData(char*,int,mgCMemory*) runs CScriptInterpreter with `tag`; all `ea*` tag handlers
  (`int f(SPI_STACK*, int argc)`, return 1/0).
- Global, in header: LoadEditAnalyzeData(int language, u_long128*) (mangled `FiP1`, P1 = u_long128*; called with
  LanguageCode from MainLoop/LanguageChange; return void assumed, Ghidra's int is printf's), GetMaxPolyn(map)
  (0:4000 1-3:6000 4:4000 else 0), GetMaxDrawMem(map) (0:48000 1:50000 2,3:54000 4:48000 else 0).
- Analyze(data_no, map_no, con_src, depth): recursion guard prints "infinty loop!!!" when depth > 64.
  For each con_no c of the request: if con_src[c] >= 0, condition[c] = Analyze(con_src[c], ...) and con_src[c] = -1;
  fails when condition[c] == 0.
- dbgGetContintionFlag bound-checks map against 6 (array has 5) — retail bug, keep.
- CEditMap members in this unit (SaveData, LoadData, CultureAnalyzeParts, CultureAnalyze, GetOnOffParts,
  PartsOnOff) are declared in editmap.hpp.

## Unresolved / for other headers
- editparts.hpp declares `CEditPartsInfo::cpoint[2]` at +0x8; CultureAnalyzeParts uses info+0x8 as a category
  (1 = main, 2 = territory, 3/4 = child, 6 = standalone) and GetCulturePoint reads info+0xC as the points. The
  cpoint naming in editparts.hpp may need revisiting.
- Meaning of EditAnalyzeDataSrc::unk_10, EditDataParts 0x1A..0x23, EditDataHouse 0x2..0xF, EditDataAnalyze 0x90..0xCF,
  CEditData 0x5110..0x550F: no reads found.
- Names EditDataParts / EditDataHouse / EditDataAnalyze are neutral (no retail names); retail may have used
  unnamed or differently named structs.

## Source status and forms

Every function is native; the unit has no `NONMATCHING` guards, `INCLUDE_ASM` gaps, or data
markers.

- `buff` is 0x300 aligned quadwords used as the backing buffer of `Stack`. `LoadEditAnalyzeData`
  constructs a `CScriptInterpreter` after setting the active analyzer globals, then runs the loaded
  script, through typed `mgCMemory::stSetBuffer` and local `CScriptInterpreter` calls.
- `SaveData` computes the saved house number through the inline `EditHouseIndex(base, target)`
  wrapper. The direct `part->house - house + 1` expression (or a `house_index` local) swaps the
  division result's v0/v1 registers in six words; a `static_cast<int>` spills and grows the
  function from 0x5D0 to 0x5D8 bytes.
- `data_open` and `condition_open` are `s8` arrays: editmenu reads them signed and every store
  writes 1 with `sb`.
- Header `@size` annotations use the retail ELF's declared `STT_FUNC` extents, not the gap up to
  the next function.
