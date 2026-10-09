# movieviewlp notes

`DataBuffer__2` and `Stack_ReadBuff__2` are native `mgCMemory` globals. Their constructors
generate the 44-byte retail `__sinit_movieviewlp_cpp` in the same order.

Debug movie viewer, a main-loop mode (entry in `mainloop`'s `LoopInit` table at offset 0x20).
Reads `mv.cfg` with `CScriptInterpreter` using the one-tag table `tag_movie`, lists the movies and
plays the chosen one with `CMovie`. Owns no class in `class_units.tsv`. No first-game counterpart.

## Functions
| Function | Binding | Notes |
|---|---|---|
| `_MOVIE(SPI_STACK*, int)` | LOCAL (static, stays in .cpp) | Tag handler for `MOVIE "name" "file" [bgm]`. Arg stride in the `SPI_STACK` array is 8. Copies both strings with `mgCopyString(str, spi_MovieStack)`; bgm = `spiGetStackInt(&args[2])` if `argc > 2`, else -1. Appends to `MovieList[MovieListNum++]`. Returns 1 (0 if the entry pointer is null). |
| `MovieViewInit(INIT_LOOP_ARG)` | global, `void` | See below. |
| `MovieViewExit()` | global, `void` | `sndSeAllStop(-1); mgCloseFont(); mgPerformanceMeter(performance_meter_flag);` |
| `MovieViewLoop()` | global, returns `int` | Returns 1 (leave mode) on pad 0x800 or 0x40 in select mode; else 0. |
| `__sinit_movieviewlp_cpp` | LOCAL | `mgCMemory::Init` on `DataBuffer` and `Stack_ReadBuff` (file-scope `mgCMemory` objects with constructors). |

## Global data: all LOCAL (static) in retail
Every data symbol of the unit, including `tag_movie`, is in `local_symbols.tsv`, so the header
declares no `extern`s; they belong in the `.cpp` as `static`. gp-relative offsets confirm widths
(gp = 0x3846F0 in MovieViewInit: `MovieView` at -0x62E4).

| Symbol | Addr | Type | Evidence |
|---|---|---|---|
| `tag_movie` | 0x359990 | `SPI_TAG_PARAM[2]` | `{"MOVIE", _MOVIE}, {0, 0}` |
| `MovieScene` | 0x37E408 | `CScene*` | `GetMainScene()`; calls vfunc slot at `*(scene+0x10548)+8` on init; `StopBGM/LoadBGM/PlayBGM` |
| `MovieView` | 0x37E40C | `CMovie*` | `new(Alloc(0x2396)) CMovie`-sized 0x23940 (`__nw__FUiP1`) -> sizeof(CMovie) == 0x23940 |
| `RushWork` (`RushWork__2`) | 0x37E410 | `mgCTexture*` | `GetTexture("moviework", 10)`; drawn as the movie frame |
| `performance_meter_flag` | 0x37E414 | `int` | saved `mgGetPerformanceMeterFlag()`, restored on exit |
| `MovieListNum` | 0x37E418 | `int` | |
| `MovieList` | 0x37E41C | `MOVIE_LIST_ENTRY*` | `new[](0x300)` = 64 entries of 0xC, placed in `Alloc(0x32)` |
| `MovieLine` | 0x37E420 | `short` | `sh`; first list row shown |
| `MovieSelect` | 0x37E424 | `short` | `sh`; cursor |
| `spi_MovieStack` | 0x37E428 | `mgCMemory*` | = `GetMainStack()` |
| `MovieSpecialMode` | 0x37E42C | `short` (MOVIE_SPECIAL_MODE) | `sh`, size 2 |
| `MovieSpecialModeInfo` | 0x37E430 | `short[3]` (size 6) | all three halves zeroed in Init; only [0] used (promo part number 1..3) |
| `MovieMode` | 0x37E438 | `int` (MOVIE_VIEW_MODE) | `sw` |
| `init_792..init_801` | 0x37E43C.. | `char` guards of function-local statics `buf0`, `buf1`, `dbuf0`, `dbuf1` (each `static mgCMemory` in MovieViewInit, 0x30 bytes) | |
| `DataBuffer` (`DataBuffer__2`) | 0x1F3D040 | `mgCMemory` (0x30) | 100000-byte buffer; `SetTextureTable(100, 20, &DataBuffer)` |
| `Stack_ReadBuff` (`Stack_ReadBuff__2`) | 0x1F3D070 | `mgCMemory` (0x30) | set to the rest of the main stack after the list; fields 0x1C/0x24 zeroed directly; read buffer for `CMovie::Load`, its 0x20 + 0x24*16 passed to `LoadBGM` |

Packet buffers: buf0/buf1 30000 bytes (`mgSetPacketBuffer`), dbuf0/dbuf1 60000 (`mgSetDataBuffer(..., 1)`);
VIF1 packet 10000+10000.

## Types declared
- `MOVIE_LIST_ENTRY` (name not retail): 0xC from the `MovieSelect * 0xC` stride. 0x0 `char*` name
  (printed `"  %d:%18s  "`, compared with `"promo"`/`"promo_tv"`), 0x4 `char*` file (`CMovie::Load`),
  0x8 `int` bgm (passed to `LoadBGM` when `> 0`). List header string: `"  :%18s    %s"` with SJIS
  "映像" and "BGMID".
- `MOVIE_VIEW_MODE` (names not retail): 0 list/select, 1 playing (`MovieMode`).
- `MOVIE_SPECIAL_MODE` (names not retail): 0 none, 1 "promo" -> `PROMO1.PSS`, then `PROMO%d.PSS`;
  2 "promo_tv" -> `PROMO1TV.PSS`, then `PROMO%dTV.PSS`; up to part 3, then back to 0.

## Loop details
- Select: pad 0x1000/0x4000 = -1/+1, 4/8 = -7/+7; clamp; 8 rows from `MovieLine`, y from 0x28 step 0x14,
  stop past 200. Selected row gets `'>'` at `str[1]`. Pad 0x20 starts playback: `Load(file,
  &Stack_ReadBuff, 0x200, 0x1A0, true, false)`, `Play("moviework")`, `SwitchThread` until `IsStarted`.
- Play: draws `RushWork` full screen via `mgCDrawPrim`/`CPreSprite`; pad 8/2/4/1 toggles the performance
  meter; `EndCheck()` or pad 0x800 ends (`Term`, `StopBGM`), continuing a promo sequence if active.
- `CFont` occupies 0xB8 bytes on the stack. Its string starts at 0x0 and its draw position is at 0x94/0x98, matching `font.hpp`. The constructor calls `Init`; the loop explicitly calls `Init` again.

## Matching source and stack layout

All five game functions are native C++ and byte-identical. The unit has no
`NONMATCHING` guards, `INCLUDE_ASM` entries or data markers: the viewer state,
`DataBuffer`, `Stack_ReadBuff`, `tag_movie` (two `SPI_TAG_PARAM` entries, `"MOVIE"`
and `_MOVIE`, then the null terminator) and every string are ordinary file-local
definitions and inline literals, and the four packet/draw buffer managers are
function-local `static mgCMemory` objects of `MovieViewInit` whose constructor
guards the compiler generates.

`MovieViewInit` has 0x3B4 bytes of instructions in its 0x3C0 manifest extent;
`MovieViewLoop` has 0x758 bytes of instructions in its 0x760 extent. The
remaining bytes are zero alignment padding. The former drafts emitted 0x3C8
and 0x770 bytes because placement construction of stack byte arrays added an
allocation call and null check. The interpreter path added five instructions;
the primitive path added six. Ordinary `CScriptInterpreter` and `CPreSprite`
locals reproduce retail's direct constructor calls.

The interpreter is declared inside the successful `LoadFile2` branch, after
the 0x5000-byte script buffer. Init's frame is 0x5F30 bytes: script at sp+0x50,
interpreter at sp+0x5050, and script size at sp+0x5F2C. Keep `script_ptr` for
the shared script address; the branch-local interpreter does not move it.

Loop's 0x370-byte frame holds `CFont` at sp+0x40, row text at sp+0x100,
`CPreSprite` at sp+0x200, and the promotional part path at sp+0x330. Declaring
the row text before the branch-local font swaps their slots, producing fourteen
instruction differences. Declaring the part path before the branch-local
sprite swaps those slots, producing fifteen differences. Declare each text
buffer after the object that precedes it in retail's stack layout.

`MovieList[i].name` generates retail's incrementing 0xC row offset. The
existing `mgCMemory::stGetRest()` and `stGetTop()` inline methods generate
retail's remaining-block count and quadword stack indexing in both functions.
`new (Alloc(...)) CMovie` and `new (Alloc(...)) MOVIE_LIST_ENTRY[64]` generate
only the retail placement allocation calls; both types need no constructor
instructions. Pad buttons, viewer states, outline style, and sprite primitive
use the existing header enums without changing the code.

## Buffer-manager storage

The four function-local `static mgCMemory` managers have one-byte compiler guards
that the object postprocessor binds to retail's four-byte guard slots at
0x37E43C, 0x37E440, 0x37E444 and 0x37E448, keeping the complete `.sbss` layout.
`MovieLine`, `MovieSelect` and `MovieSpecialMode` own two bytes each and
`MovieSpecialModeInfo` three shorts; their piece tails are alignment.
