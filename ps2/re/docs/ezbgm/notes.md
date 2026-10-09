# ezbgm: reverse-engineering notes

EE client for the EZBGM IOP stream server (SIF RPC server number `0x12345`; EZMIDI is `0x12346`).
Callers are all in `sound` (`CSound::Init` -> `ezBgmInit`; `CSound::Stream*` -> `ezBgm`). The unit
owns no class (`class_units.tsv`); it holds one `CSound` member, `CSound::StreamOpenState`, which
is declared in `ps2/include/sound.hpp` (owning unit `sound`), not in `ezbgm.hpp`. The `.cpp`
needs `sound.hpp` when that function is decompiled.

First game: no equivalent (no `ezBgm` anywhere in `/home/adubbz/development/chronicle`). The
structure mirrors this game's `ezmidi` unit (see `ps2/re/docs/ezmidi/notes.md`).

## Functions
| Symbol | Returns | Notes |
|---|---|---|
| `ezBgmInit__Fv` 0x28EB50 | `int`, always 1 | `printf("EZ_BGMINIT START \n")`; `sceSifInitRpc(0)`; loop: `sceSifBindRpc(&gCd2, 0x12345, 0)`, on `< 0` `printf("error: sceSifBindRpc \n")` then `for (;;) {}`; wait loop `wait = 10000; while (wait--) {}` (the `nop`s in the loop are R5900 short-loop padding); repeat until `gCd2.server` (`+0x24`) is non-zero. Symbol-file size 0x94; the 0xA0 extent includes alignment padding. |
| `ezBgm__Fii` 0x28EBF0 | `int`: `sbuff[0]`, or 0 when busy | `cmd = command & 0xFFF0`. Compared in this order in asm: `== 0x40` first, then `0x80F0`, `0x8A00`, `0x8020`, else default. Each branch: `if (sceSifCheckStatRpc(&gCd2)) { printf(busy string); return 0; }`. 0x40: `sbuff[0] = argument`, `sceSifCallRpc(&gCd2, command, 1, sbuff, 0x10, sbuff, 0x40, 0, 0)` (string "bussy2"). 0x80F0/0x8A00/0x8020: `sceSifCallRpc(&gCd2, command, 1, (void*)argument, 0x40, sbuff, 0x40, 0, 0)` ("bussy1"). Default: `sbuff[0] = argument`, mode 0, send `sbuff` 0x10 ("bussy3"). All then return `sbuff[0]`. Mode 1 = no-wait, so for those the returned word is whatever is in `sbuff` at return. Symbol-file size 0x188. Frame 0x40, saves `$16`/`$17` with `sq`. |
| `StreamOpenState__6CSoundFv` 0x28ED80 | `int` | `return sceSifCheckStatRpc(&gCd2);` (tail call `j`). `sound.hpp` already declares it `int StreamOpenState();`. |

`sceSifCheckStatRpc` is declared in `ps2/include/sce/sifrpc.h` with a
`sceSifClientData*` parameter and `int` return.

All three functions match the linked retail image. `ezBgmInit` and `ezBgm` compile from their
`#else` definitions; the `NONMATCHING` branches keep the earlier non-matching drafts. The
compiled `ezBgm` switch names its cases with `EzBgmCommand` values.

## Enum `EzBgmCommand` (names not retail)
Command word = command | channel (low 4 bits). Only the values `ezBgm` tests are in the header:
`0x40` preload (last request of `CSound::StreamStandBy`), `0x8020` open (`StreamOpenFast`, arg =
64-byte name buffer on caller's stack), `0x80F0` open from file pack (`StreamOpenFromFPLFast`,
arg = 64-byte buffer: name at +0, pack name at +0x34), `0x8A00` (no caller in the binary; meaning
unknown). Other command values built in `sound` (`sound` should own names for them):
`0x10` (last step of Close/END), `0x30` (Close), `0x50` (Play/RePlay), `0x60` (Stop/Pause, first
step of Close/END), `0x70` (END), `0x80` (SetVol, arg `left << 16 | right`; also sent with 0
before each open), `0x8000` (StandBy, arg 0x3000 or 0x4000), `0x80B0` (GetState, result
`& ~0xFFF`), `0x80C0` (StandBy, arg 0x10 or 0), `0x80D0` (StandBy query, bit 0 picks branch),
`0x80E0` (GetLevel).

## Data (all LOCAL in retail -> `static` in the .cpp, no `extern` in the header)
| Symbol | Address | Size | Type |
|---|---|---|---|
| `sbuff__3` (retail local `sbuff`) | 0x1F350C0 | 0x40 | `static s32 sbuff[16]`, RPC send/receive buffer. |
| `gCd2` | 0x1F35100 | 0x28 symbol, 0x30 extent (`INCLUDE_BSS` 0x30; next symbol `at_1348` at 0x1F35130) | `sceSifClientData` (`<sifrpc.h>`, `+0x24` = `server`). Like `ezmidi`'s `gCd` (`EzMidiClientStorage`, in `ezmidi.cpp`), likely needs the same 0x28 + 8-byte storage wrapper to reproduce the 0x30 extent. |
| `at_32` | 0x372CE0 | 0x13 | `"EZ_BGMINIT START \n"` |
| `at_33__2` | 0x372D00 | 0x17 | `"error: sceSifBindRpc \n"` |
| `at_52` / `at_53` / `at_54` | 0x372D20 / 40 / 60 | 0x1E each | `"########### Rpc is bussy1!! \n"` / `2` / `3` |
