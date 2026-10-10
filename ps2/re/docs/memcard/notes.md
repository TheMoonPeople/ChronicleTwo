# memcard notes

Unit `memcard`: `CMemoryCardManager` (40 members, all in this unit; no vtable, no virtuals) plus
free functions. Retail strings decoded below. First game counterpart: `CMemoryCardAccess`
(`/home/adubbz/development/chronicle/ps2/include/memorycardaccess.hpp`), same idea (step machine
driven by `func_no`/`step`, `MC_ERROR_INFO`, `MC_CARD_INFO`, `SAVEDATA_INFO`) but every layout
differs; nothing was copied unverified.

## Includes
`memcard.hpp` includes `savedata.hpp`: `SAVEDATA_FORMAT::save_data` is a `CSaveData` at +0x80
(0x80 + 0x65930 + 0x10 = 0x659C0). The former cycle through inventmn.hpp is gone (CInventUserData is
declared in userdata.hpp). Header order (acyclic, each includes only what it needs by value): gamedata < userdata < menusys < savedata < memcard < inventmn. This matters for
matching `Initialize`, which placement-news a `SAVEDATA_FORMAT` and so runs `CSaveData`'s inline
constructor (CEditData x5 ctors at +0x1CA4 stride 0x5510, CUserDataManager ctor at +0x1D320,
CQuestData::Initialize at +0x62AC0, CMenuSystemData ctor at +0x64140; all = format + 0x80 +
the CSaveData offsets).

## CMemoryCardManager (0x1100)
Size: `__nw(0x1100)` in title (TitleMCCheck) and menuop (MemoryCardPtr); `Initialize` memsets 0x1100.
Ctor just calls `Initialize(NULL)`.

| off | field | evidence |
|---|---|---|
| 0x000 | char version[0x10] | Initialize strcpy "dc2Ver4" (at_924); GetVersion returns `this`; compared with save +0 |
| 0x010 | char file_name[0x20] | strcpy "BESCES-51190dkcl%d" (at_922) |
| 0x030 | char game_name[0x20] | strcpy "darkclonicle" (at_923; sic) |
| 0x050 | s32 func_no | Step switch; SetFuncNo/GetFuncNo; Initialize = 1 |
| 0x054 | unk 4 | never touched |
| 0x058 | s32 step | every operation's switch |
| 0x05C | s32 fd | sceMcSync result after sceMcOpen; Initialize = -1 |
| 0x060 | unk 0x20 | never touched |
| 0x080 | MC_DIR_ENTRY dir_table[17] | sceMcGetDir(..., 0x11 or 0xD, this+0x80); InitSaveFileInfoTable/GetOpenAttribute loop 17 x 0x40, name at +0x20 |
| 0x4C0 | s32 dir_entries | GetDir sync result (count, or -4) |
| 0x4C4 | s32 album_buffer_set | SetBuff_Album sets 1; MakeDir skips retitling icon.sys when set |
| 0x4C8 | s32 port | every sceMc call; inventmn/title/menuop write it |
| 0x4CC | s32 file_no | Step passes it to MakeDir/SaveToMc/LoadFromMc/DeleteFile; menuop EnvSetSave writes it |
| 0x4D0 | MC_ERROR_INFO error (0x14) | InitError memset 0x14; McError writes +0 code, +4 func_no, +8 file_no, +0xC step; DeleteFile counts +0x10 (gives up > 0x78) |
| 0x4E4 | char *write_buffer | write steps: sceMcWrite(fd, write_buffer + transferred, ...) |
| 0x4E8 | char *read_buffer | read steps |
| 0x4EC | char work_buffer[0x400] | Initialize memset 0x400; CheckOmakeFile reads 0x100 bytes into it and copies into a CSubGameData |
| 0x8EC | SAVEDATA_FORMAT *save_buffer | Initialize: new(0x659C0) on the given mgCMemory (Alloc(0x659E)) |
| 0x8F0 | CSubGameData *sub_game_data | only written, by menuop SubGameSaveInit |
| 0x8F4 | char *album_buffer | SetBuff_Album; album data is a CDC2AlbumData (inventmn, 0x64CB0) |
| 0x8F8..0x908 | s32 load_map_no, load_program_loop_no, load_dungeon_no, load_floor_id, load_dng_tree_flag | LoadFromMc copies format +0x30,+0x34,+0x38,+0x3C,+0x44(s8); menuop KeyStep reads them; Initialize 8F8/8FC = -1 |
| 0x90C | s32 search_wait | Initialize 0x3D; SetFuncNo(1) sets 0xB; Step case 1 counts to 10 then SearchMcType |
| 0x910 | s32 transferred | per read/write |
| 0x914 | s32 total_transferred | menuop progress bar (StepMenuDl2) |
| 0x918 | s32 transfer_size | |
| 0x91C | s32 transfer_result | sceMcSync result pointer for read/write |
| 0x920 | MC_ICON_DATA icon[3] | SetIconData memcpy 3 x 0x28; data ptr +0x20, size +0x24 used by MakeDir/GetIconDataSize |
| 0x998 | sceMcIconSys icon_sys | memset 0x3C4, "PS2D" at +0, nl_offset +6 (0x99E), trans_rate +0xC = 0x60, bg/light/ambient memcpys, title +0xC0 (0xA58), fname_view/copy/del 0xA9C/0xADC/0xB1C |
| 0xD5C | MC_CARD_INFO card[2] | `port*0x20 + 0xD5C` everywhere; title memsets 0x20 each |
| 0xD9C | unk 4 | never touched |
| 0xDA0 | SAVEDATA_INFO file_info[13] | loops of 13 x 0x40; menuop 13 save slots |
| 0x10E0 | s32 file_exists | CheckAlbum/CheckOmakeFile set 0/1 (2 when bonus dir is incomplete); inventmn IsAccessAlbum, title read |
| 0x10E4 | u32 omake_flag | CheckOmakeFile: word +8 of the CSubGameData read; title tests bits 1 and 2 |
| 0x10E8 | unk 0x18 | never touched |

## Enums (values from Step / McError / GetSaveDataSize)
- `MC_FUNC_NO` (Step switch): 0 search, 1 idle (search every 10 frames), 2 none (done), 3 MakeDir(file_no),
  5 GetAllSaveFileInfo, 6 SaveToMc, 7 LoadFromMc, 8 DeleteFile(error.code ? error.file_no : file_no),
  10 Format, 11 UnFormat, 13 Write (test), 16/17/18 Save/Load/CheckAlbum, 19 MakeDir(-1),
  20/21/22 Save/Load/CheckOmake, 23 MakeDir(-2), 24 Convert. 4, 9, 12, 14, 15 unused (step result 0).
- `MC_STEP_RESULT`: operations return 0 busy, 1 done, -1 failed. Step: 1 -> SetFuncNo(1); other
  non-zero -> McError(result). Step returns `old func_no != new func_no`.
- `MC_ERROR_CODE` (error.code): 2 load failed (read error, version or checksum mismatch);
  3 short/broken (short read in GetSaveFileInfoFromMc, album short or checksum, too-small album/bonus
  file); 4 sceMcResFullDevice(-3); 6 bonus file missing/size mismatch, bonus dir with <7 entries, and
  McError with result < -10 during func 6; 7 sceMcResNoFormat(-2) or -12; 8 any result < -10;
  11 a library command could not be issued. Names other than FULL/UNFORMATTED/NO_CARD are descriptive,
  not retail. First game used different values (1 version, 3 short read, 4 full, 6 unformatted, 7 no card).
- `MC_DATA_SIZE_TYPE` (GetSaveDataSize): 0 (icons+0x19A) KB*1024; 1 0x659C0; 2 0x64CB0; 3 icons*1024;
  4 icons*1024+0x654B0; 5 icons+0x199 (KB); 6 0x20800 (unknown use); 7 0x5470 (CSubGameData);
  8 icons*1024+0x5C70; 9 icons+0x1B (KB). GetIconDataSize = sum of ceil(size/1024) of the 3 icons + 1.

## Matched functions

- `InitSaveFileInfoTable` clears all 17 `MC_DIR_ENTRY` records, then explicitly clears the first
  byte of each name. Its two loop variables are a record count and a byte offset; keeping both
  preserves the retail loop and register allocation. The latter is used only while clearing this
  contiguous table, where the same `sizeof(MC_DIR_ENTRY)` governs the stride and `memset` size.
- `GetSaveDataSize` independently checks each `MC_DATA_SIZE_TYPE` value and returns zero for any
  unrecognized value. The save image and bonus data file sizes are `sizeof(SAVEDATA_FORMAT)` and
  `sizeof(CSubGameData)`. The album file size is the documented `CDC2AlbumData` size, 0x64CB0.
- `SetFuncNo` stores the requested operation, restarts its step at zero, and primes the idle
  search counter to 11 only for `MC_FUNC_IDLE`.
- `Convert` immediately reports completion. It has no state changes.

## SAVEDATA_FORMAT (0x659C0)
Written by SaveToMc, read by LoadFromMc / GetSaveFileInfoFromMc (first 0x2800 bytes only).
+0x00 version (strcpy manager version; "dc2Ver2" is the older version accepted by LoadFromMc, which then
calls TranslateInventUserData on format+0x25250 -> CSaveData+0x251D0); +0x10 u64 costume bits
(CUserDataManager::GetCostumeBit when flag 799); +0x18 s16 debug code, +0x1A s16, +0x1C s32 (zeroed);
+0x20/+0x24 s32 zeroed; +0x28 checksum of first 0x32C98 bytes, +0x2C of all 0x65930 (MakeCheckDigit);
+0x30 map (CSaveData+0x1A18 s16), +0x34 NowProgramLoopNo, +0x38 CSaveDataDungeon+0 (current dungeon),
+0x3C CSaveDataDungeon[+4 + dng*4] (floor id; SetFloorID writes it), +0x40 CSaveData+0x1A08 (progress);
+0x44 s8 DngTreeSaveFlag; +0x45 u8 "incomplete" (1 while writing, step 0x66 seeks to 0x45 and writes 0;
GetSaveFileInfoFromMc accepts only 0); +0x46 u8 omake bits (bit0 flag 0x1A8, bits 1|7 flag 799);
+0x47 u8 zeroed; +0x48 CountFish(); +0x4C s32[11] zeroed; +0x78 u64 unique counter
(CheckMaxUniqueCounter()+1); +0x80 CSaveData (memcpy 0x65930; GetSaveData()); +0x659B0 0x10 unused.
Note sceMcSeek is used (SaveToMc, SaveOamkeFile) but is not declared in `sce/libmc.h`.

## SAVEDATA_INFO (0x40)
Filled by UpDateViewInfo: +0 state (1 valid), +4 file_no, +8 s16 map (fmt+0x30), +0xA s16 dungeon
(read from `save_buffer`+0x38, not the format argument), +0xC s16 floor (fmt+0x3C), +0xE s16 progress
(fmt+0x1A88 = CSaveData+0x1A08), +0x12 s16 loop no (fmt+0x34), +0x14 u32 omake (fmt+0x46 lbu),
+0x18 s16 debug code (fmt+0x18; CheckDebugCode), +0x20 u64 costume (fmt+0x10; CheckOmake),
+0x28 u64 play time (fmt+0x1A80 = CSaveData+0x1A00; menuop draws /50/60/60), +0x30 u64 counter
(fmt+0x78; CheckMaxUniqueCounter), +0x38 s32 fish (fmt+0x48). Unwritten: 0x10, 0x1A..0x1F, 0x3C.
menuop: loop no 2 (dungeon) maps dungeon_no through a table to a map title; progress -> message 0xC7F+.

## MC_CARD_INFO (0x20)
+0 present, +4 type (2 = PS2), +8 formatted, +0xC format change (1 / -1 / 0, SearchMcType),
+0x14 free (KB, menuop compares with save KB), +0x1C last sync result. +0x10, +0x18 never used.
sceMcGetInfo(port, 1, &type, &free, &formatted). McCheckMCPs2Boot: PS2 card and (unformatted or free > size).

## MC_DIR_ENTRY (0x40)
sceMcTblGetDir layout: +0x10 u32 file size (CheckAlbum reads dir_table[0].file_size; CheckOmakeFile
reads dir_table[6].file_size, i.e. this+0x210), +0x20 name. Rest unused.

## MC_ICON_DATA (0x28)
name[0x20] (icon resource name, also the file name written in the directory), +0x20 data, +0x24 size.
The menu's three descriptors occupy `CMenuInvent+0x1D4..0x24B`; filled from `save.pac` (title notes).

## COSBIT_INFO / cosbit_table (static, 0x88 = 34 rows of 4 bytes)
Rows {s16 item, s16 bit}: items 0x6F..0x86 bits 0..0x17, items 0x102..0x10B bits 0x18..0x21. GetCosInfo
compares the s16 at +0 and returns the row; CUserDataManager::GetCostume reads `lb` at +2 (so bit_no is
s8 + one pad byte). GetCostumeList walks the 34 rows with a 64-bit mask, filters on GetItemDataType,
writes item numbers and a -1 terminator. The struct name COSBIT_INFO is not retail.

## Globals
- Global (header externs): `NowProgramLoopNo` s16 (.sdata, init -1, size 2; dngmenu/menumain write it);
  `SubGameOmakeTempBuffer` char* (.sbss; menuop Alloc 0x1900; SaveOamkeFile reads icon[2] into it).
- Local (static, belong in .cpp): `DngTreeSaveFlag` s16 (SetDngTreeFlag), `cosbit_table`,
  `MCBrowsetName` (char *[3][4]: row 0 Japanese, 1 when LanguageCode == 1, 2 when CheckNowEurope();
  entry 3 is a format with %s used by MakeDir), `MCBrowserName_Offset` (u16[3][4], icon.sys nl_offset).
  Function statics: old_format_1242, iconNo_1323/init_1324, test_write_num_1476/init_1477,
  ReadFileNo_2290/init_2291.
- Local functions (static, not in the header): MakeMemoryCardFileName(int, char*)
  ("/BESCES-51190dkcl%d" + "/" + "BESCES-51190dkcl%d"), MakeMemoryCardAlbumName(char*, int)
  ("/BESCES-51190dc2album"), MakeCheckDigit(int, char*, int) (sum of byte%255 of every 64th byte).
- Strings: bonus dir "/BESCES-51190dc2omake" (at_1454), its file "/BESCES-51190dc2omake/BESCES-51190dc2omake"
  (at_1954), getdir "/BESCES-51190dc2omake/*" (at_2083), "/icon.sys" (at_1455), delete name
  "darkcloud%d" (at_2131), save getdir "/BESCES-51190dkcl??" (at_2297).

## Return types chosen
Mangling does not carry them: Step int (bool-like), CheckMaxUniqueCounter u_long, CheckOmake u32,
CheckDebugCode s16, GetCosInfo COSBIT_INFO*, CopyMCBrowserName char* (strcpy result), FinishForMC int (1).


## Native data and matching constraints

All BSS are native; `at_1315__3` and `at_1954` remain assembly-supplied filename
literals because inlining changes call-argument scheduling. The differences are two
masked words per caller: Write +0x48/+0x4C, SaveOamkeFile +0x2A4/+0x2AC, LoadOmakeFile
+0xDC/+0xE4, CheckOmakeFile +0x144/+0x14C. Their extents stay 0xFC, 0x4F8, 0x2C0 and
0x308. Filename pointer locals, indexed literal addresses, const pointers and SDK flag
spellings do not resolve that scheduling difference.

`cosbit_table[34]` has 0x88 declared bytes with an eight-byte padding tail: items
0x6F-0x86 map to bits 0-23, and 0x102-0x10B to bits 24-33. Browser titles and offsets
are 3-by-4 region/category tables; Shift-JIS bytes use octal escapes. `DngTreeSaveFlag`
and `NowProgramLoopNo` own two bytes each, with two-byte alignment tails.

Natural filename buffers have extents 20/19 bytes in MakeMemoryCardFileName, 64 in
DeleteFile, and 128 in GetAllSaveFileInfo. Icon templates use SDK color/vector types
with extents 64/48/48/16. SetIconData copies only 16 bytes from each into the cleared
descriptor; remaining entries stay zero.

SearchMcType, MakeDir, SaveToMc and GetAllSaveFileInfo own static old_format, iconNo,
test_write_num and ReadFileNo. MWCC supplies their guards. Removing GetAllSaveFileInfo's
empty thirteen-iteration completion loop shrinks 0x244 to 0x1F4 and loses retail
instructions, so the loop remains.
