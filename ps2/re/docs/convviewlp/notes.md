# convviewlp: reverse-engineering notes

Main-loop mode `LOOP_SV_CONV_VIEW` (9) in `mainloop.hpp`: a "SaveData Convert" screen that
renames North American (`BASCUS-97213...`) memory card save directories to this release's
`BESCES-51190...` names. No first-game counterpart. The unit owns no classes
(`class_units.tsv` has none for it).

## Functions
| Function | Linkage | Notes |
|---|---|---|
| `SVConvViewInit(INIT_LOOP_ARG)` | global | `LoopInit[9]`. Header. |
| `SVConvViewExit()` | global | `LoopExit[9]`. `sceMcEnd`, `GamePad.AutoRepeatOff/MenuModeOff`, `sndSeAllStop(-1)`, `mgCloseFont`. Header. |
| `SVConvViewLoop()` | global | `LoopMain[9]`, returns `int` (1 = leave mode). Header. |
| `InitSaveFileInfoTablePtr()` | LOCAL (`local_symbols.tsv`) | `static void` in the .cpp, not in the header. Called from Init and Loop. |
| `SaveDataConvertLoop()` | global | Returns `int` (1 = finished/failed, 0 = continue). Header. |
| `__sinit_convviewlp_cpp` | compiler | Runs `mgCMemory::Init` on `DataBuffer` and `Stack_ReadBuff` (so both are by-value `mgCMemory` statics with a constructor). |

## Globals (all file-local; none go in the header)
Every data symbol of the unit is LOCAL in retail (`local_symbols.tsv`), so they are `static` in
the .cpp, except `SaveFileInfoTableSizeConvert`, which keeps external linkage because the
`Vu_progmain` assembly references it. The unit has no data markers: screen text, directory masks,
suffixes and diagnostic formats are inline strings.
| Symbol | Addr | Size | Type / meaning |
|---|---|---|---|
| `MovieScene` | 0x37EA70 | 4 | `CScene*` from `GetMainScene()`; Init calls its object at +0x10548's vtable slot +8 (same pattern as movieviewlp). |
| `ConvMode` | 0x37EA74 | 4 | `int`, `SV_CONV_MODE` (0 select, 2 convert, 3 result; 1 never used). |
| `SlotSelect` | 0x37EA78 | 4 | `int`, memory card port passed to every `sceMc*` call (0/1, set by Left/Right). |
| `FileListNum` | 0x37EA7C | 4 | `int`, number of entries copied into `SaveFileInfoTablePtr`. |
| `ConvertPhase` | 0x37EA80 | 4 | `int`, `SAVEDATA_CONVERT_PHASE`. |
| `ConvertFileNum` | 0x37EA84 | 4 | `int`, directories renamed. |
| `ConvertResult` | 0x37EA88 | 4 | `int`, `SAVEDATA_CONVERT_RESULT` (0, 1, 100, 101). |
| `ConvertResultDispTime` | 0x37EA8C | 4 (piece 0x34) | `int` (only 4-byte accesses; set to 0x1E in convert mode, 0 on reset; only written in this unit). Its .sbss piece runs to the next piece at 0x37EAC0; the 0x30 zero tail is linker alignment, not part of the object. |
| `SaveFileInfoTablePtr` | 0x37EAC0 | 4 | `sceMcTblGetDir*` (0x40-byte entries): `new[]` of 0x800 bytes (32 entries) from the main stack; `memcpy` of 0x40 per entry; `EntryName` at +0x20 is cleared/compared/printed. NB: the copy loop allows up to 0x40 entries although only 32 fit. `sceMcTblGetDir` is not declared in `ps2/include/sce/libmc.h` yet (`sceMcGetDir` takes `void*`). |
| `SAVEDATA_BUFFER` | 0x37EAC4 | 4 | Pointer to a 0x659C0-byte object (`operator new(0x659c0, Alloc(0x659e))`); constructs 5 x `CEditData` (stride 0x5510) at +0x1CA4..+0x1C5F4, `CUserDataManager` at +0x1D320, `CQuestData::Initialize` at +0x62AC0, `CMenuSystemData` at +0x64140. Identical allocation is in `CMemoryCardManager::Initialize` (memcard, stored at +0x8EC). `CSaveData::GetEditData` uses edit data at +0x1C24, so this object likely holds a `CSaveData` at +0x80 -- type unresolved; owned by memcard/savedata. Only written here. |
| (guards) | 0x37EAC8.. | 1 each | compiler-generated guard flags for the function-local statics `buf0`, `buf1`, `dbuf0`, `dbuf1` (the first three own four-byte pieces, the last one byte). |
| `DataBuffer` | 0x1F646B0 | 0x30 | `mgCMemory`, 100000-byte texture/data buffer, passed to `SetTextureTable(100, 0x14, ...)`. |
| `Stack_ReadBuff` | 0x1F646E0 | 0x30 | `mgCMemory`, set to the main stack's free space after Init; fields +0x14/+0x1C zeroed directly (`DAT_01f646fc`, `DAT_01f64704`). |
| `SaveFileInfoTableSizeConvert` | 0x1F64710 | 0x200 | `int[128]`. Only the first 32 ints are zeroed by `InitSaveFileInfoTablePtr`. Never read in this unit; retail binds it LOCAL but the source gives it external linkage for the `Vu_progmain` assembly reference. |
| `buf0/buf1` | 0x1F64910/40 | 0x30 | function-local static `mgCMemory` packet buffers (30000 bytes each) in `SVConvViewInit`; their constructors and guards replace manual `Init` blocks. |
| `dbuf0/dbuf1` | 0x1F64970/A0 | 0x30 | function-local static `mgCMemory` data buffers (60000 bytes each) in `SVConvViewInit`. |

`GamePad` (0x3FA5A0, size 0x478) is the global `CGamePad` object referenced by Exit/Loop; it is
a different symbol from mainloop's 4-byte `GamePad` (0x37CF44).

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
- Three `char[128]` locals with ordinary aggregate initializers ("BESCES-51190dkcl%d",
  "BESCES-51190dc2album", "BESCES-51190dc2omake"); MWCC emits each template in rodata and copies
  it as 4x0x20-byte blocks.
- A 0x1000-byte `sceMcTblGetDir[64]` buffer, a `char[64][128]` name table, an `int[64]` number
  table filled with -1 (0x20 when the suffix is empty), `char[128]` path buffers.
- Rename: `sceMcChdir(entry)`, `sceMcGetDir(entry, 0x10 entries)`, `sceMcRename(file -> new)`,
  `sceMcChdir("/")`, `sceMcRename(dir -> new)`. Type 0's new name is `sprintf(buf, dkcl_fmt, number)`; the number argument is
  confirmed in the native match.
- The screen's English text, the search masks, suffixes, "/" and debug printf formats are
  inline string literals.

## Source status
All six game functions are native, including the conversion loop; the unit has no `NONMATCHING`
guards, `INCLUDE_ASM` gaps, or data markers. The source uses `MC_DIR_ENTRY` (a 0x40-byte
directory entry with the name at +0x20) and `SAVE_CONVERT_WORK` (the save image at +0x80 of the
conversion allocation). `sceMcEnd` and `sceMcRename` are declared in the SDK memory-card header.

The file-scope `DataBuffer` and `Stack_ReadBuff` `mgCMemory` objects emit the retail 44-byte
static initializer (`__sinit_convviewlp_cpp`, two `mgCMemory::Init` calls in that order) and
its constructor-table pointer; no other constructor registration exists in the unit.

The conversion loop keeps the four-phase progression, a maximum of 64 directory entries from
each search, the North American to PAL directory rename, and the duplicate search for numbered
game saves and the two special saves. The retail allocation holds 32 source directory records
while the copy loop accepts up to 64. `InitSaveFileInfoTablePtr` resets the counters and only
the first 32 records of the size table.

`SaveDataConvertLoop` (0x7E0 bytes): both directory arrays require 64-byte alignment; the inner
array has 32 entries even though each read requests only 16. With these declarations MWCC
produces the 0x3CE0 stack frame: directory buffers at 0xA0 and 0x10A0, path at 0x18C0, then the
three 128-byte format/name arrays. Existing save numbers use the `listed` index, which advances
independently from the directory scan counter. The function ends after the return delay slot at
0x325C60; the following 0x20 zero bytes before `Vu_prog_3dsp` (0x325C80) are linker-script
alignment, not part of the function.
