# password: reverse-engineering notes

Item passwords: a 16-byte block (14 data bytes + 2 checksum bytes) is scrambled with a key
(the item's name) and written as 22 base-58 characters. No classes, structs or enums are owned
by this unit (`class_units.tsv` has none).

## Binding (retail ELF `rom/pal/extracted/iso/SCES_511.90`, `readelf -s`)
- GLOBAL (declared in `ps2/include/password.hpp`): `ConvertBinToTxt__FPUciPc`,
  `ConvertTxtToBin__FPcPUc`, `EncodePassword__FPUciPUciPci`, `DecodePassword__FPcPUciPUci`.
- LOCAL (must be `static` in `password.cpp`, not in the header): `search_txt__Fc`,
  `ConvLongToTxt__FUlPc`, `ConvTxtToLong__FPcPUl`, `GetCRC__FPUci`, `random__Fv`,
  `EncodeBinData__FPUciPUci`, `DecodeBinData__FPUciPUci`.
- Data, all LOCAL, so no `extern` in the header:
  - `txt_table` (retail name; splat calls it `txt_table__2` because nameregi has its own local
    `txt_table` at 0x362780), 0x363080, 59 bytes: `static char txt_table[] =
    "0123456789abcdefghijkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ";` (58 chars + NUL; no l, o, I, O).
    In `.data`, so it is non-const.
  - `random_seed`, 0x37CD20, 4 bytes, `.sdata`, initial value 1. Accessed as a 32-bit word
    (`lw`/`sw` gp-relative); 32-bit unsigned/int.
  - `@211` (0x379330, 9 bytes): string literal `"err %lu\n"`, printf format in ConvertBinToTxt.

## Signatures (from mangled names; `unsigned long` is 64-bit in MWCC)
- `int search_txt(char c)`: index of `c` in `txt_table` (0..57), -1 if absent.
- `void ConvLongToTxt(unsigned long value, char* text)`: fills text[0..10] with `txt_table[0]`,
  then writes base-58 digits least significant first (`__umoddi3`/`__udivdi3` by 58). Does not
  terminate the string.
- `int ConvTxtToLong(char* text, unsigned long* value)`: reads 11 digits LSD first
  (`__muldi3`), returns 1 and stores value, or 0 on an invalid character.
- `int ConvertBinToTxt(u8* data, int size, char* text)`: text[0]=0; per <=8-byte group copies
  bytes into a zeroed `unsigned long`, ConvLongToTxt into a 12-byte stack buffer, terminates at
  [11], round-trips with ConvTxtToLong; on failure `printf("err %lu\n", value)` and returns -1;
  else strcat. Returns `strlen(text)`.
- `int ConvertTxtToBin(char* text, u8* data)`: strlen % 11 must be 0 else -1; per group
  ConvTxtToLong (fail -> -1), copies its 8 bytes out; returns total bytes (8 per group).
- `GetCRC(u8* data, int size)`, result fits 16 bits: CRC-16/CCITT (init 0xFFFF, poly 0x1021, MSB first),
  returns `~crc & 0xFFFF`. Loop counters compare unsigned. Return type in mangled name is not
  encoded; int/unsigned int is consistent with use.
- `random()`: `random_seed = random_seed * 0x21FC436 + 1; return random_seed;` (reloads seed after
  the store). Callers use `random() >> 24` (`srl 24`) as an 8-bit XOR mask.
- `void EncodeBinData(u8* data, int size, u8* key, int key_size)`:
  crc = GetCRC(data, size-2) ^ 0x62D3 ^ GetCRC(key, key_size); data[size-2] = crc low,
  data[size-1] = crc high; seed = crc + 0x5888F27; XOR data[0..size-3] with random()>>24;
  then seed = 0x14A76E0, swap data[size-2] with data[random() % (size-2)].
- `int DecodeBinData(...)`: exact inverse (swap first, then reseed from the stored 16-bit
  checksum + 0x5888F27, XOR), returns `(stored ^ GetCRC(key) ^ 0x62D3) == GetCRC(data, size-2)`.
- `int EncodePassword(u8* data, int size, u8* key, int key_size, char* text, int text_size)`:
  0 unless `size % 8 == 0` and `text_size >= size/8*11 + 1`; EncodeBinData, then
  ConvertBinToTxt; returns 1 if its result > 0, else 0.
- `int DecodePassword(char* text, u8* data, int size, u8* key, int key_size)`: 0 unless
  `strlen % 11 == 0` and `size >= strlen/11*8`; ConvertTxtToBin (<= 0 -> 0); returns 1 if
  DecodeBinData is nonzero, else 0.
- Return type `int` (not `bool`) for Encode/DecodePassword: results returned in `$2` as 0/1 via
  `daddu $2,$0,$0` / `addiu $2,$0,1`, and callers use the full register without masking.

## Callers outside the unit
- `CMenuItemInfo::ItemCmdAfter` (menusys) and `SphidaMenuKey` (menumap): data from
  `CGameDataUsed::TransToPassword(buf, 0xE)`, `EncodePassword(buf, 0x10, GetName(0), 0x14,
  text, 0x46 / 0x48)`.
- `CNameRegiMenu::KeyStep` / `NameRegistKey` (nameregi): `DecodePassword(text, buf, 0x10,
  name, 0x14)`, then copies 0xE bytes and checks `(u16 at 0) & 0x1FF >= 0x136`.

## First game
No corresponding `password` unit was found in Dark Cloud 1.

## Unresolved
- Exact signedness of `random_seed` and the return type of `GetCRC`/`random` (unsigned vs int);
  decide when matching (`random() % (size-2)` uses a signed `div`, suggesting `random` returns
  `int`; check the disassembly).

## Drafts (job password.1)
- All 11 functions drafted in `ps2/src/password.cpp` under `#ifdef UNMATCHING`; all report
  `DIFF`, none promoted. `txt_table` and `random_seed` are given typed `static` definitions in an
  `UNMATCHING` block at the top of the `.cpp`.
- Retail's code for every function except `random` spills its arguments to the stack and
  re-reads them, and keeps loop temporaries in memory: the unit looks compiled with little or no
  optimisation (e.g. a per-file `#pragma optimization_level`), which accounts for most of the
  size differences (retail functions are 1.3-2x the size of the `-opt all` drafts).
- `random() % (size - 2)` is a `divu` in both Encode/DecodeBinData, so `random` returns an
  unsigned 32-bit value (`unsigned int`); `random_seed` is drafted as `unsigned int`.
- `random` alone is optimised-looking (load, mult, addiu, store, reload): 0x20 bytes of code plus
  0x10 of alignment padding in retail's 0x30. Its 2-word diff is the gp-relative access to
  `random_seed` against the draft's static.
- ConvertBin/TxtToBin copy bytes between the `unsigned long` and the byte buffer through the
  value's address (`((u8*)&value)[i]`), little-endian.

## Compiler flag cleanup

The two local `divbyzerocheck on`/`reset` pairs around `EncodeBinData` and
`DecodeBinData` are redundant now that the PS2 compiler command enables the
check for the whole unit. Removing both pairs leaves every section and symbol
in the unit's object diff unchanged; both functions remain exact matches.
