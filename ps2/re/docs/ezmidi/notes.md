# ezmidi: reverse-engineering notes

EE client for the EZMIDI IOP sound server (SIF RPC server number `0x12346`) and a synchronous
EE->IOP SIF DMA helper. Only caller unit is `sound` (`CSound`, `TransHdBd`). No classes are owned
by this unit (`class_units.tsv` has none).

First game equivalent: the start of the first game's `gameutil.cpp`
(`ezMidiInit`, `ezMidi`, `ezTransToIOP`, statics `sbuff[16]`, `gCd`, `transData`). Here they live
in their own unit and the transfer helper is renamed `ezTransToIOP2`.

## Functions
| Symbol | Returns | Notes |
|---|---|---|
| `ezMidiInit__Fv` 0x18C770 | `int`, always 1 | `sceSifInitRpc(0)`; loop: `sceSifBindRpc(&gCd, 0x12346, 0)`, on `< 0` `printf("error: sceSifBindRpc \n")` then `for (;;) {}`; wait loop `wait = 10000; while (wait--) {}`; repeat until `gCd.server` (`gCd + 0x24`) is non-zero. Same as first game. |
| `ezMidi__Fii` 0x18C800 | `int`, `sbuff[0]` | Short 2000-count delay loop: generated assembly increments the counter by 8 per iteration and pads it with four `nop`s. `receive_size = (command & 0x8000) ? 64 : 0`. If `command & 0x1000`: send `(void*)argument`, 64 bytes; else `sbuff[0] = argument`, send `sbuff`, 16 bytes. Receive buffer is always `sbuff`. Same RPC protocol as the first game. |
| `ezTransToIOP2__FPvPvi` 0x18C8C0 | `int`, -1 if `sceSifSetDma` returns 0, else 0 | Param 1 = IOP address (stored to `transData.addr`, +4), param 2 = EE address (`transData.data`, +0), param 3 = size (+8), mode (+0xC) = 0. Store order in retail: size, data, addr, mode (first game: data, addr, size, mode). `FlushCache(0)`, `sceSifSetDma(&transData, 1)`, spin while `sceSifDmaStat(id) >= 0`. **Differs from first game**: after the wait loop it stores `transData.data = ee_address` again (`sw $17, transData`) before returning 0. |

The bursts of `nop`s inside the short wait loops are the compiler's R5900 short-loop padding, not
source-level code.

## Enum
`EzMidiCommandFlag` (name not retail): bits tested on the command word in `ezMidi`:
`0x1000` = argument is the address of a 64-byte block; `0x8000` = 64-byte response expected.
The command numbers themselves (e.g. `0x8010`, `0x80F0`, `port + 0x20/0x30/0x40/0xA0/0xB0`,
`port + 0x9050`) are built in `sound`; that unit should own an enum for them.

## Data (all LOCAL in retail -> `static` in the .cpp, no `extern` in the header)
| Symbol | Address | Size | Type |
|---|---|---|---|
| `sbuff` (symbol file `sbuff__2`) | 0x3F64C0 | 0x40 | `static s32 sbuff[16]` (RPC send/receive buffer). The `__2` suffix is only a symbol-file disambiguator: other `sbuff` locals exist at 0x3842C0 and 0x1F350C0. |
| `gCd` | 0x3F6500 | 0x30 allocation | `static EzMidiClientStorage gCd`: 0x28-byte `sceSifClientData` (`<sifrpc.h>`; `+0x24` = `server`) followed by eight bytes of alignment space. The retail symbol's declared size is 0x28, but the next object starts 0x30 bytes later. |
| `transData` | 0x3F6530 | 0x10 | `static volatile sceSifDmaData transData` (`<sifdma.h>`); volatile field stores preserve the descriptor's retail write order. `ezTransToIOP2` passes it as `sceSifSetDma((sceSifDmaData *) &transData, 1)`; the cast strips `volatile` for the SDK declaration. |
| `at_33` | 0x369320 | 0x17 | string literal `"error: sceSifBindRpc \n"`, inline at its `printf` use in `ezMidiInit` (no data marker) |

The source uses `<sifrpc.h>`, `<sifdma.h>`, `<eekernel.h>` (FlushCache), and `<cstdio>`
(printf).

## Matching details

All three functions are native and match their retail instruction streams exactly. The build's
`-O3,p` setting retains the 8-count `ezMidi` busy loop and its four short-loop padding
instructions; `-opt all` removes the empty C++ loop. The transfer function
uses the same setting and stores the EE pointer in a `u32`
local for its final descriptor write. Keeping the initial store as the pointer argument produces
retail's `sw a1`; saving both uses as a pointer causes MWCC to use `s1` for the first store.

The retail bind-error string is in `.rodata`. The build's `-strings readonly` setting places the
inline literal there; default MWCC options place this literal in `.data`. The retail
`.rodata` allocation is padded from the literal's 23 bytes to 24. All three zero-initialized
objects are defined in this translation unit. `EzMidiClientStorage` reserves the eight-byte gap
after the 0x28-byte SDK client, placing `transData` at retail's 0x3F6530. Without the gap,
`transData` lands at 0x3F6528 and the linked image differs in every section containing references
to later data.
