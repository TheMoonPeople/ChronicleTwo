# convviewlp: reverse-engineering notes

Main-loop mode `LOOP_SV_CONV_VIEW` (9) in `mainloop.hpp`: a "SaveData Convert" screen that
renames North American (`BASCUS-97213...`) memory card save directories to this release's
`BESCES-51190...` names. No first-game counterpart. The unit owns no classes
(`class_units.tsv` has none for it).

## Functions
| Function | Linkage | Notes |
|---|---|---|
| `SVConvViewInit(INIT_LOOP_ARG)` | global | `LoopInit[9]`. Header. |
| `SVConvViewExit()` | global | `LoopExit[9]`. `sceMcEnd`, `GamePad__2.AutoRepeatOff/MenuModeOff`, `sndSeAllStop(-1)`, `mgCloseFont`. Header. |
| `SVConvViewLoop()` | global | `LoopMain[9]`, returns `int` (1 = leave mode). Header. |
| `InitSaveFileInfoTablePtr()` | LOCAL (`local_symbols.tsv`) | `static void` in the .cpp, not in the header. Called from Init and Loop. |
| `SaveDataConvertLoop()` | global | Returns `int` (1 = finished/failed, 0 = continue). Header. |
| `__sinit_convviewlp_cpp` | compiler | Runs `mgCMemory::Init` on `DataBuffer` and `Stack_ReadBuff` (so both are by-value `mgCMemory` statics with a constructor). |

## Globals (all file-local; none go in the header)
Every data symbol of the unit is LOCAL in retail (`local_symbols.tsv`), so they are `static` in
the .cpp. Retail names (main.symbols.txt adds `__2`/`__3` to disambiguate same-named locals of
other units):
| Symbol | Addr | Size | Type / meaning |
|---|---|---|---|
| `MovieScene` (`MovieScene__2`) | 0x37EA70 | 4 | `CScene*` from `GetMainScene()`; Init calls its object at +0x10548's vtable slot +8 (same pattern as movieviewlp). |
| `ConvMode` | 0x37EA74 | 4 | `int`, `SV_CONV_MODE` (0 select, 2 convert, 3 result; 1 never used). |
| `SlotSelect` | 0x37EA78 | 4 | `int`, memory card port passed to every `sceMc*` call (0/1, set by Left/Right). |
| `FileListNum` | 0x37EA7C | 4 | `int`, number of entries copied into `SaveFileInfoTablePtr`. |
| `ConvertPhase` | 0x37EA80 | 4 | `int`, `SAVEDATA_CONVERT_PHASE`. |
| `ConvertFileNum` | 0x37EA84 | 4 | `int`, directories renamed. |
| `ConvertResult` | 0x37EA88 | 4 | `int`, `SAVEDATA_CONVERT_RESULT` (0, 1, 100, 101). |
| `ConvertResultDispTime` | 0x37EA8C | 0x34 extent | `int` (only 4-byte accesses; set to 0x1E in convert mode, 0 on reset). Extent runs to the next symbol; the rest is probably alignment/unnamed padding -- unresolved. |
| `SaveFileInfoTablePtr` | 0x37EAC0 | 4 | `sceMcTblGetDir*` (0x40-byte entries): `new[]` of 0x800 bytes (32 entries) from the main stack; `memcpy` of 0x40 per entry; `EntryName` at +0x20 is cleared/compared/printed. NB: the copy loop allows up to 0x40 entries although only 32 fit. `sceMcTblGetDir` is not declared in `ps2/include/sce/libmc.h` yet (`sceMcGetDir` takes `void*`). |
| `SAVEDATA_BUFFER` | 0x37EAC4 | 4 | Pointer to a 0x659C0-byte object (`operator new(0x659c0, Alloc(0x659e))`); constructs 5 x `CEditData` (stride 0x5510) at +0x1CA4..+0x1C5F4, `CUserDataManager` at +0x1D320, `CQuestData::Initialize` at +0x62AC0, `CMenuSystemData` at +0x64140. Identical allocation is in `CMemoryCardManager::Initialize` (memcard, stored at +0x8EC). `CSaveData::GetEditData` uses edit data at +0x1C24, so this object likely holds a `CSaveData` at +0x80 -- type unresolved; owned by memcard/savedata. Only written here. |
| `init_817/820/823/826` | 0x37EAC8.. | 1 each | function-local static guard flags (compiler-generated) for `buf0`, `buf1`, `dbuf0`, `dbuf1`. |
| `DataBuffer` (`__3`) | 0x1F646B0 | 0x30 | `mgCMemory`, 100000-byte texture/data buffer, passed to `SetTextureTable(100, 0x14, ...)`. |
| `Stack_ReadBuff` (`__3`) | 0x1F646E0 | 0x30 | `mgCMemory`, set to the main stack's free space after Init; fields +0x14/+0x1C zeroed directly (`DAT_01f646fc`, `DAT_01f64704`). |
| `SaveFileInfoTableSizeConvert` | 0x1F64710 | 0x200 | `int[0x80]`? Only the first 0x20 ints (0x80 bytes) are zeroed by `InitSaveFileInfoTablePtr`; extent is 0x200 -> `int[0x80]` fits. Never read in this unit. |
| `buf0/buf1` (816/819) | 0x1F64910/40 | 0x30 | function-local static `mgCMemory` packet buffers (30000 bytes each) in Init. |
| `dbuf0/dbuf1` (822/825) | 0x1F64970/A0 | 0x30 | function-local static `mgCMemory` data buffers (60000 bytes each) in Init. |

`GamePad__2` (0x3FA5A0, size 0x478) is the global `CGamePad` object referenced by Exit/Loop; it is
a different symbol from mainloop's `GamePad` (0x37CF44, a 4-byte pointer?) -- check which header
declares the object before writing bodies.

## Enums (declared in convviewlp.hpp; names are descriptive, not retail)
- `SV_CONV_MODE`: transitions in `SVConvViewLoop`: 0 -(Cross 0x40)-> 2 (calls
  `InitSaveFileInfoTablePtr`); 2 -(SaveDataConvertLoop()!=0)-> 3; 3 -(Circle 0x20)-> 0, clearing
  result/time. In mode 0, Start (0x800) or Triangle (0x10) returns 1. Left 0x8000 -> slot 0,
  Right 0x2000 -> slot 1. (On-screen text says "Check & Convert:(O)" / "Return to SlotSelect :(X)",
  i.e. labels are swapped relative to the raw bits.) Use `PadButton` from gamepad.hpp.
- `SAVEDATA_CONVERT_PHASE`: 0 `sceMcGetInfo`: requires type==2 (PS2 card) and format==1, and
  sync result >= -1, else result 100; 1 `sceMcGetDir("BASCUS-97213*")`, result 101 if none;
  2 per entry convert, then phase 3 / result 1.
- `SAVEDATA_CONVERT_RESULT`: 100 "Failed Access memory card(PS2)", 101 "Not Exist Convert Files".
- `SAVEDATA_CONVERT_TYPE`: from `strncmp(EntryName + 0xC, ...)`: "dkcl" (4) -> 0, "dc2album" (8)
  -> 1, "dc2omake" (8) -> 2, else -1 (prints "not convert type"). For type 0, the number at
  `EntryName + 0x10` (`atoi`) is compared against existing `BESCES-51190*` dkcl numbers to skip
  duplicates ("error already exist ... convert no").

## SaveDataConvertLoop locals / rodata
- Three 0x80-byte `char[128]` locals initialised from rodata arrays `at_1072` ("BESCES-51190dkcl%d"),
  `at_1073` ("BESCES-51190dc2album"), `at_1074` ("BESCES-51190dc2omake"; extent 0xC0) -- copied
  as 4x0x20-byte blocks, i.e. `char name[128] = "..."` local arrays.
- A 0x1000-byte `sceMcTblGetDir[64]` buffer, a `char[64][128]` name table, an `int[64]` number
  table filled with -1 (0x20 when the suffix is empty), `char[128]` path buffers.
- Rename: `sceMcChdir(entry)`, `sceMcGetDir(entry, 0x10 entries)`, `sceMcRename(file -> new)`,
  `sceMcChdir("/")`, `sceMcRename(dir -> new)`. Type 0's new name is `sprintf(buf, dkcl_fmt)` with
  no number argument (retail bug/quirk; keep).
- String literals at_1016..at_1031 are the screen's English text, at_1159..at_1169 the search
  masks, suffixes, "/" and debug printf formats.

## Verification
- `scripts/re/draft.sh --header ps2/include/convviewlp.hpp`: compiles.
- `ps2/src/convviewlp.cpp` with `#include "convviewlp.hpp"` compiles (6 NO DRAFT, as expected).

## Draft coverage
All six game functions have named, typed C++ bodies. The C++ drafts use `SAVE_CONVERT_FILE_INFO` (a 0x40-byte directory entry with the name at +0x20) and `SAVE_CONVERT_WORK` (the save image at +0x80 of the conversion allocation). `sceMcEnd` and `sceMcRename` are declared in the SDK memory-card header.

The conversion loop preserves the four-phase progression, a maximum of 64 directory entries from each search, the North American to PAL directory rename, and the duplicate search for numbered game saves and the two special saves. The retail allocation holds 32 source directory records while the copy loop accepts up to 64; the draft keeps this bound exactly. `InitSaveFileInfoTablePtr` resets the counters and only the first 32 records of the size table, as the retail stores show.

## Isolated promotion results
`SVConvViewExit`, `InitSaveFileInfoTablePtr`, and `__sinit_convviewlp_cpp` passed exact linked-image checks and are active C++ source. `SVConvViewInit`, `SVConvViewLoop`, and `SaveDataConvertLoop` compiled as C++ but produced different linked images in their one isolated trial. They remain behind `NONMATCHING` with retail assembly in normal builds. The three differences include source text and object-layout changes; no matching claim is made for them.
