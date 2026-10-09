# dataread: reverse-engineering notes

File access layer: device-prefixed paths, the DATA.DAT index, background read queue, file
cache, pack-file lookup. First-game counterpart: `chronicle/ps2/include/dataread.hpp` +
`ps2/src/dataread.cpp` (PAL branch is closest: linear `SearchFile`, no name tree). This game adds
devices (host/net/HDD), the file cache, current/top directories and the I/O error callback.

No classes are owned by this unit (`class_units.tsv` has none).

## Linkage (from the retail ELF, `readelf -s rom/pal/extracted/iso/SCES_511.90`)
- LOCAL functions (go in the `.cpp` as `static`, not in the header): `SearchFile(char*)`,
  `GetDevType(char*, char*)`, `ConvStr(char*)`, `GetFullPath(char*, char*)`,
  `CDRead(char*, u_int*, int*)`, `align_size(u_int, u_int)`, `GetNewFileCache()`,
  `EntryFileCache(char*, u_long128*, int)`, `SearchFileCache(char*)`.
- ALL data symbols are LOCAL (`static`): `TopDir`, `CurrentDir`,
  `DefaultFileDev`, `header_num`,
  `packfile_buff`, `data_sector`, `error_cb`, `old_vsync`, `start_vsync`, `CacheAddress`,
  `NowCacheAddress`, `FileCacheType`, `header_buff`, `bg_read_info`, `FileCache`.
  Hence the header has no `extern` data. Definitions:
  - `static char TopDir[256] = "";` `static char CurrentDir[256] = "";` (.data, all zero).
  - `static int DefaultFileDev = FILE_DEV_CDROM;` (.sdata, value 1).
  - `static int header_num; static u_int *packfile_buff; static int data_sector;`
    `static int (*error_cb)(int); static int old_vsync; static int start_vsync;`
    `static u_long128 *CacheAddress; static u_long128 *NowCacheAddress; static int FileCacheType;`
    (.sbss, in this order).
  - `u_char header_buff[0x50000]` (code indexes it as 12-byte records and reads word 0 as an
    int). It is retail-LOCAL but the source keeps external binding: the split library assembly
    (`intr`, `libgraph`, `libdev`, `e_rem_pio2`) references it by name for words that have no
    relocation in the retail ELF, so a `static` definition leaves those references unresolved.
  - `static BG_READ_INFO bg_read_info[32]`, `static FILE_CACHE FileCache[16]`.
- Four `.bss` zero templates are local array initializers: `char path[256] = ""` in `LoadFileBG`
  (after the argument checks), `LoadFile2` (after the cache-hit return) and `WriteFile` (at its
  start), and `char dev[16] = ""` in `GetFullPath` (after device selection); MWCC copies each with
  an 8 x 32-byte loop. MWCC assigns stack arrays in declaration order: the initialized path must
  be declared before the function's scratch path (`LoadFileBG`) and before the `sce_stat` local
  (`LoadFile2`), or their stack slots swap. `WriteFile`'s template is the unit's last BSS object
  (0x100 bytes at 0x3EC290); the 0x30 bytes up to the next unit's BSS start are a linker
  alignment tail, not part of the object.
- The unit has no data markers; file and device names (with their leading backslash and `;1`
  suffix), current-directory reset strings and diagnostics are inline literals. The empty string
  and "/" are distinct retail objects emitted by the two default-device transitions.

## Mangling
`P1` = `u_long128 *` (`unsigned __int128`), same as first game's `LoadFileBG__FPcP1Pi`.
`InitFileCache__FP1i` = (u_long128*, int); `EntryFileCache__FPcP1i` = (char*, u_long128*, int)
(asm: a0 name -> strcpy src, a1 -> +0 address, a2 -> +4 size). Ghidra/m2c mis-read both.

## Strings (.rodata, inline literals)
"/", "", "error at %s\n", "LoadBG %s\n", "\DATA.DAT;1", "cdrom0:\DATA.HD4;1",
"File open error \"\"\n \n \n" (as in the first game), "head size = %d/%d\n", "host:", "host0:",
"cdrom:", "net:", "psf0:" (sic; GetDevType's HDD prefix), "pfs0:" (GetFullPath's HDD prefix),
"File open error \"%s\"\n \n \n", "file cache %s\n", "load %s\n", "Load %s\n", "%s %d %d\n".

## Enums (names are neutral, not retail)
- `FILE_DEV`: GetDevType returns -1 (no prefix / path[1]==':' single-letter drive), 0 host:/host0:,
  1 cdrom:, 2 net:, 3 psf0:. `DefaultFileDev` is 1 initially, 3 after ChangeHddFile.
  LoadFile2/LoadFileBG/WriteFile branch on these (2 -> LoadFileSocket/WriteFileSocket,
  1 -> DATA.DAT via SearchFile/CDRead, 3 -> sce* calls with error_cb, else sceOpen/sceRead).
  GetFullPath: prefix "" by default, "host:" for 0, "pfs0:" for 3; appends CurrentDir only when
  no prefix was given; lower-cases (ConvStr) for HDD.
- `LOAD_FILE_MODE` (LoadFile2 arg 4): 0 read whole file (113 callers pass 0); 1 size/existence
  only (LoadFileCacheBG); 2 open and return the descriptor (LoadFileBG, then ReadBG uses
  sceRead/sceIoctl/sceClose). Mode-2 open uses flags 0x8001 (SCE_RDONLY|SCE_NOWAIT).
- `FILE_CACHE_TYPE` (InitFileCache arg 2): 0 disabled (MainLoop, DeleteFileCache),
  1 downward (CScene::PreLoadVillager passes 1; NowCacheAddress starts at aligned address - 0x40
  and is decremented by align_size(size,0x800)/16 quads before each load), 2 upward.
  CacheAddress = align_size(address, 0x40) only when type is 1 or 2, else left 0 (disabled).

## Struct layouts
### DATA_HEADER (0xC) - DATA.HD4 record
SearchFile walks `header_buff` with stride 12, `strcasecmp(*(char**)rec, name)`. InitCDFile:
`header_num = *(int*)header_buff / 12` (first name offset = table size), then each word 0 is
rebased `+= header_buff` and '\\' -> '/'. +4 size (LoadFileBG/CDRead/LoadFile2 mode 1),
+8 sector relative to DATA.DAT (`+ data_sector`, which is the lsn of `\DATA.DAT;1`).
First game PAL record was 0x20 (name, 3 unused, offset, size, sector, sectors); this game's is 12.

### BG_READ_INFO (0x120) - bg_read_info[32] = 0x2400
Stride 0x48 words in all loops. +0 busy; +4 dev (LoadFileBG stores 1 for CD or the device;
ReadBG/BreakReadBG test `== 1`); +8 issued (CD: sceCdRead result; other: set 1 when sceRead is
issued; LoadFileBG sets 1 for cache hits); +0xC done; +0x10 name[256] (strcpy of
CurrentDir+name, strcasecmp in GetReadBGFile(char*)); +0x110 buffer; +0x114 size;
+0x118 sector (CD: header sector + data_sector) or fd (LoadFile2 mode-2 result; sceClose/sceIoctl
in ReadBG/BreakReadBG) - declared as an anonymous union; +0x11C sectors (size_to_sector(size)).
InitReadBG unrolled clear touches only +0 per slot. First game slot was name[128] with no dev/fd.
Note LoadFileBG copies the path into a 256-byte local, but `name` ends at +0x110, so 256 is right.

### FILE_CACHE (0x40) - FileCache[16] = 0x400
GetNewFileCache/SearchFileCache stride 0x40 (16 words). +0 address (free when 0);
+4 size; +8 ref_count (EntryFileCache sets 1, LoadFileCacheBG ++ on re-request, LoadFile2 -- on
read from cache); +0xC never touched (unk_0c); +0x10 name (strcpy/strcasecmp), 48 bytes to end.

### PACK_ENTRY (no size asserted; variable chain)
GetPackFile*: name at +0 (strcasecmp, first byte 0 ends), +0x40 data offset from entry,
+0x44 size, +0x48 next-entry offset from entry. Same as the first game's PACK_ENTRY.
GetPackFile(char*) strips everything up to the last '/'. GetPackFileExt matches the text after
the first '.' of each entry name.

## Return types
- `ChangeHddFile`: 0 if already HDD; else MountHDDFileSystem() result if <= 0, else 1.
  Caller stores as error code. `ChangeDefaultFile`: whether the device was HDD (bool as int).
- `SetCurrentDir`/`GetCurrentDir`/`ChangeDir`/`DivPathName*`: Ghidra shows strcpy's return in v0;
  no caller uses it -> void. `ReadBG`: same, void.
- `LoadFile` always 1 (Exit(0) on failure). `LoadFile2`: 0/1, mode 2 -> descriptor (host path
  returns -1 on open failure in mode 2).
- `SearchFileCache(char*, int*)` returns the cache address (+0) -> `u_long128 *`.
  Static `SearchFileCache(char*)` returns the FILE_CACHE entry.
- `GetDevType` returns FILE_DEV (int); `GetFullPath` returns the device too.
- `InitCDFile`: Ghidra shows printf result; treated as void.

## Unresolved
- Retail names of the four types/enums are unknown (DATA_HEADER, BG_READ_INFO, PACK_ENTRY from
  the first game; FILE_CACHE, FILE_DEV, LOAD_FILE_MODE, FILE_CACHE_TYPE neutral).
- `FILE_CACHE::unk_0c` never accessed.
- `packfile_buff` only zeroed (InitCDFile); type `u_int *` assumed from the first game.
- `size_to_sector` = ceil(size / 2048) with signed division (`size / 0x800 + (size % 0x800 != 0)`).

## Source status and forms
Every function is native; the unit has no `NONMATCHING` guards, `INCLUDE_ASM` gaps, or data
markers. The `Exit` referenced by `LoadFile` is the SDK `Exit(int)` (eekernel.h). The unit has no
`divbyzerocheck` pragma; the global MWCC flag covers it. MWCC schedules a call differently when
the callee is defined in the same unit (it uses the defined callee's register usage), which is
why `InitFileCache` and `align_size` must both be native.

- `DATA_HEADER` word 0 is a union `name_offset` (as on disc) / `name` (after InitCDFile).
- SDK: `sce_stat`, `sceGetstat`, `sceIoctl`, `SCE_NOWAIT`, `SCE_FS_EXECUTING` live in
  `ps2/include/sce/sifdev.h`. LoadFile2 reads `stat.st_size` (+8); ReadBG polls
  `sceIoctl(fd, SCE_FS_EXECUTING, &status)` for non-disc reads.
- `InitCDFile` retries sceCdSearchFile in an inner loop before sceCdSync (the first game has a
  single loop). Its search result is a `sceCdlFILE file` (36 bytes: the SDK struct ends with
  `u_int flag`), with the start sector read as `file.lsn`. `base = (int) header_buff` relocates
  the DATA.HD4 table in place (`entry->name += base`) and `*(u32 *) base / 12` takes the entry
  count from the first name offset.
- `LoadFileCacheBG` moves `NowCacheAddress` (`u_long128 *`) by `align_size(size, 0x800) / 16`
  quads (signed) before queuing, in both directions; downward initialization subtracts four
  quadwords. `LoadFileBG` writes `BG_READ_INFO::buffer`, `size` and `sectors` directly and uses
  the device/read-mode enums; `CDRead` keeps the `DATA_HEADER *` from `SearchFile` and reads
  its `name`, `size` and `sector`.
- `GetPackFile(char*)` returns null for a null or empty name. `DivPathName` treats a slash at
  index 0 as "no directory" and copies the whole path into the name; its cursors are `char *`.
- `GetPackFileNum` probes consecutive entries with `GetPackFile(pack, index, &name, &size)` until
  the lookup fails, then returns the count; the name and size outputs are scratch values and the
  loop shape fixes the retail branch layout.
- `SearchFileCache` compares `FILE_CACHE::name` and advances typed cache entries with `&entry[1]`.
- The two `GetPackFile` overloads use `PACK_ENTRY` for the name, data offset, size and
  next-entry offset (record header 0x4C bytes). Records have a variable stride: `next` and
  `offset` count bytes from the start of the current record, so following the chain and
  locating file data requires byte-addressed addition (`(u8 *) entry + ...`). Both return the
  data address directly as `u_int *`. The scanned name bytes are `char` (`s8` is `char` in
  `types.h`); empty-name tests are `*name` / `*path`; `GetDevType` reads `path[1]`.
