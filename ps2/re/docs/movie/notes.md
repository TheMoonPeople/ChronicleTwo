# movie: reverse-engineering notes

The unit is Sony's EE MPEG streaming sample (PSS -> IPU video + PCM audio to SPU) wrapped in a
`CMovie` class. Struct names come from the mangled symbols; field names inside the Sony-derived
structs follow the sample's conventions (snake_cased) where the code's use matches them.
No first-game counterpart (Dark Cloud 1 headers have no movie player).

`vblankHandler` sends the two frame DMA chains on alternating vblanks and marks
the frame free after the second transfer. If no frame is ready it increments
`frd`. `handler_endimage` decrements the queued frame count when `isFrameEnd`
was set by that second transfer. Both handlers reenable interrupts before
returning zero. Guarded drafts compile with the current SDK declarations. The pinned compiler
measurements and remaining blockers are in
[matching-20261008.md](matching-20261008.md).

## Linkage
- Every non-member function (`defMain` ... `isAudioOK`, 0x29D0C0-0x29FDC0) is LOCAL in retail
  (`build/re/local_symbols.tsv`) -> `static` in `movie.cpp`, not in the header.
- Every data symbol of the unit is LOCAL too -> no `extern`s in the header. Only `CMovie` members
  are called from other units (title, event_func, menuop, movieviewlp).
- `u_long128` mangles as `1` (`P1` = `u_long128 *`).

## File-local data (types for the .cpp)
| symbol | addr | size | type / meaning |
|---|---|---|---|
| frd | 0x37DF7C | 4 | int, vblank counter since display start (startDisplay/vblankHandler) |
| TexName | 0x37DF80 | 4 | char *, texture name given to Play, used by setImageTag |
| readBuf | 0x37DF84 | 4 | ReadBuf * (allocated in Load) |
| writerest / readrest | 0x37DF88/8C | 4 | int, bytes left to demux / to read (reset to infile.size) |
| isWithAudio, isStarted, isStrFileInit, Loop | 0x37DF90-9C | 1 used | bool (lbu/sb) |
| MpegW, MpegH | 0x37DFA0/A4 | 4 | int picture size |
| isCountVblank, isFrameEnd | 0x37DFA8/AC | 1 used | bool |
| Cb | 0x37DFB0 | 4 | int, vblank parity (0 = send v[0], 1 = send v[1]); toggled with `^= 1` |
| stepMainStatus / stepMainExitFlag | 0x37DFB4/B8 | 4 | int, stepMain handshake with Term |
| cnt_513 / init_514 | | | function-local static in stepMain (`static int cnt = 0;`) |
| videoDec | 0x1F351C0 | 0xB8 | VideoDec (INCLUDE_BSS says 0xC0: padding to next object) |
| audioDec | 0x1F35280 | 0x5C | AudioDec |
| voBuf | 0x1F352E0 | 0x18 | VoBuf |
| infile | 0x1F35300 | 0x34 | StrFile |
| _0_buf | 0x1F35340 | 0x800 | u_char[0x800], zero block sent to `AudioDec::iop_zero`; referenced only by audioDecCreate |
| at_344 / at_349 | 0x1F35B40/60 | 0x18 | compiler-generated, referenced by Load |
| at_468 | .sdata | 4 | the 4-byte MPEG end code 0x000001B7 used by videoDecFlush (ghidra shows it as a float) |
| at_1276 / at_1287 | .data | 0x10 each | GIF tags (u_long128) copied in setImageTag |
Only `videoDec` and the sbss objects appear in `movie.cpp`'s INCLUDE_BSS list; audioDec, voBuf,
infile, _0_buf lie after videoDec in .bss but are not listed in the .cpp.
External data used: `DmaCH2` (mglib.hpp, `sceDmaChan *`), `iop_bd_addr` (sound.hpp, `void *`),
`mgTexManager`.

## CMovie (size 0x23940)
Size from `__nw__FUiP1(0x23940, ...)` in TitleBootInit, MenuManualInit, MovieViewInit.
No vtable, no constructor emitted. Offsets (Load/Play/Term):
- 0x0 unused. 0x4 vo_data (stAlloc64 from memory[0], GetVoBufDataSize 0x1C0000 = 2 frames).
- 0x8 vi_buf_data (memory[1], 0x80000 = 0x100 blocks * 0x800), 0xC vi_buf_tag (memory[2], 0x1010
  = 0x101 tags), 0x10 mpeg_work (memory[3]); readBuf from memory[4]; tags from memory[5].
- 0x14/0x18 and 0x1C/0x20: loop i=0..1 allocates `this+0x14+4i` then `this+0x1C+4i`, i.e.
  `image_tag[0][i]`, `image_tag[1][i]`. Then vo_tag[0].v = {0x14, 0x1C}, vo_tag[1].v = {0x18, 0x20}.
- 0x40 VoTag vo_tag[2] (passed to voBufCreate; stride 0x48 from voBufCreate's loop).
- 0x24-0x40, 0xD0-0x100, 0x23910-0x23940: never accessed.
- 0x100 def_stack 0x800, 0x900 video_stack 0x4000, 0x4900 step_stack 0x4000 (CreateThread params
  in Play: stack, size, priority 10, gp).
- 0x8900 audio_buf (audioDecCreate(&audioDec, this+0x8900, 0x18000, 0xC000)).
- 0x20900 time_stamp[0x200] (videoDecCreate t3 = this+0x20900, stack arg n_ts = 0x200; ghidra
  swaps these two). 0x200*0x18 = 0x3000 -> ends at 0x23900.
- 0x23900 bool is_playing (sb). 0x23904 video thread, 0x23908 def thread, 0x2390C step thread.
- videoDecCreate args: (vd, work, work_size, data, tag, n = 0x100, ts, n_ts = 0x200).
- Load(name, mgCMemory*) overloads fill a local `mgCMemory *[6]` with the same pointer and call
  the 6-array overload; the two-bool overload passes init_sound = true (sceSdRemoteInit,
  rSdInit, rSdSetCoreAttr(SPDIF)).
- Get* return constants: VoBufData 0x1C0000, ViBufData 0x80000, ViBufTag 0x1010, ReadBuf
  0x50050, MpegWork `w*h*9/2 + 0x1768`, TagProg `((w/16*h/16)*6 + 0x6E)*4` rounded up to 64,
  then *4 (`>>6<<8`).
- EndCheck returns 1 if writerest <= 4 or state == VIDEO_DEC_STATE_END; returned as int.
- IsStarted: `lbu isStarted` -> bool.

## Structs
- **TimeStamp** 0x18: pts(long,0) dts(long,8) pos(0x10) len(0x14) (viBufReset/PutTs/ModifyPts;
  -1 = unset).
- **QWORD** 0x10: only `l[0]` written (scTag2 `sd` of `addr<<32 | id<<28 | qwc`); union member
  `q` matches the 16-byte stride in viBufReset.
- **ViBuf** 0x60 (viBufCreate/Reset/StopDMA): data 0, tag 4 (stored `| 0x20000000` uncached), n 8,
  dma_start 0xC, dma_n 0x10, read_bytes 0x14, buff_size 0x18 (= n<<11), env 0x1C-0x40
  (sceIpuDmaEnv: d4madr,d4tadr,d4qwc,d4chcr,d3madr,d3qwc,d3chcr,ipubp,ipuctrl from StopDMA),
  sema 0x40, is_active 0x44, total_bytes long 0x48 (`sd`), ts 0x50, n_ts 0x54, count_ts 0x58,
  wt_ts 0x5C. videoDecBeginPut is viBufBeginPut inlined on `vd->vibuf`.
- **VideoDec** 0xB8 (symbol size): sceMpeg 0 (0x48), vibuf 0x48, state 0xA8 (volatile u_int;
  set 0 in videoDecCreate, 2 by videoDecFlush if 0, 3 by videoDecMain), 0xAC never accessed,
  0xB0 AddDmacHandler(2 = GIF, handler_endimage) id, 0xB4 AddIntcHandler(2 = VBLANK_START,
  vblankHandler) id. decBs0 reads mpeg.width/height/frameCount (+0/+4/+8).
- **VoData** 0xE0000: stride in voBufGetData (`data + write*0xE0000`), 512x448x4; passed to
  sceMpegGetPicture as sceIpuRGB32* (setImageTag walks 0x400 per macroblock).
- **VoTag** 0x48: status 0 (volatile; 2 set by voBufIncCount, 2->1 / 1->0 in vblankHandler),
  v[2] at 0x40/0x44 (sceDmaSend(DmaCH2, v[Cb])); 0x4-0x40 unused.
- **VoBuf** 0x18: data 0, tag 4 (voBufCreate clears tag[i].status), ring_tag 8 (same pointer;
  used by IncCount/GetTag), write 0xC, count 0x10 (volatile: videoDecMain spins reloading it),
  size 0x14. GetTag returns `ring_tag[(size + write - count) % size]`.
- **StrFile** 0x34: fp sceCdlFILE 0 (sceCdSearchFile(file), sceCdStStart(fp.lsn), size = fp.size),
  0x20 unused, fd 0x24, is_on_cd 0x28, size 0x2C, iop_buf 0x30 (= iop_bd_addr, rounded to 16
  for sceCdStInit(0x50, 5, ...)). strFileOpen always forces is_on_cd = 1 and builds
  `\MOVIE\<name>;1`.
- **ReadBuf**: data[0x50000], put 0x50000, count 0x50004, size 0x50008 (readBufCreate sets
  size 0x50000). Size not asserted (allocation uses GetReadBufSize 0x50050).
- **AudioDec** 0x5C (symbol size): state 0, hdr[0x28] 4 (audioDecBeginPut returns
  `this + 4 + hdr_count`, length 0x28 - hdr_count), hdr_count 0x2C, data 0x30, put 0x34,
  count 0x38, size 0x3C, total_bytes 0x40, iop_buff 0x44 (sceSifAllocIopHeap(iop_buff_size)),
  iop_buff_size 0x48, iop_last_pos 0x4C, iop_pause_pos 0x50, total_bytes_sent 0x54,
  iop_zero 0x58 (sceSifAllocIopHeap(0x800)). hdr content never read by the code; kept as bytes.

## Enums
- VideoDecState: 0 (videoDecCreate), 2 (videoDecFlush), 3 (videoDecMain, EndCheck). 1 not seen.
- AudioDecState: 0 create/reset, 1 when hdr_count reaches 0x28 (audioDecEndPut), 2 Start/Resume,
  3 Pause. audioDecSendToIOP switches on all four.
- VoTagStatus: 0/1/2 as above.
- sceMpegStrType used by Load: 0 (M2V, videoCallback), 2 (PCM, pcmCallback); sceMpegCbType
  0,1,2,3,5 registered in videoDecCreate (mpegError, mpegNodata, mpegStopDMA, mpegRestartDMA,
  mpegTS).

## SDK headers added
`ps2/include/sce/libmpeg.h` (sceMpeg, callback data types, the libmpeg functions this unit
calls) and `ps2/include/sce/libipu.h` (sceIpuDmaEnv, sceIpuRGB32), needed by value in VideoDec /
ViBuf. Not yet declared for the bodies: thread/sema/intc kernel calls (CreateThread, StartThread,
CreateSema, WaitSema, AddIntcHandler, AddDmacHandler, DIntr/EIntr, ...), sceCdSt*, sceOpen/
sceRead/sceLseek/sceClose, sceSifAllocIopHeap, sceGsSyncV, sceDmaSend, sndSetMasterVol.

## Open points
- Field name/meaning of CMovie 0x0, 0x24-0x40, 0xD0-0x100, 0x23910-0x23940; VideoDec 0xAC;
  StrFile 0x20; VoTag 0x4-0x40.
- Return types of the static helpers are mostly int 1/0; voBufIsFull/IsEmpty/audioDecIsPreset
  compute a boolean (`sltiu`/`xori`), isAudioOK returns it.

## Compiler flag cleanup

The local `divbyzerocheck on`/`reset` pairs are redundant with the PS2
compiler flag. Removing all twelve pairs leaves every section and symbol in
this unit's object diff unchanged.

## Typed buffer access

`ViBuf::data` stores 2048-byte video blocks and also has a byte view for
write positions within a block. The byte view lets `viBufBeginPut` index its
write position directly, while `viBufReset` indexes the quadword blocks.
`VoBuf::data` stores whole decoded frames, so `voBufGetData` and `decBs0`
index `VoData` records directly. `pcmCallback` treats its user pointer as a
`ReadBuf` and uses that buffer's byte array; `strFileOpen` uses a `char*` for
the colon within its path. `videoDecMain` casts its thread argument to the
decoder type. These functions remain exact in objdiff.

`viBufAddDMA` still needs its byte-address expression: typed block or byte
indexing changes its object by one or two instructions. `audioDecBeginPut`
likewise changes its object when the header offset uses array indexing.

`vblankHandler` and `handler_endimage` retain guarded C++ drafts and retail
`INCLUDE_ASM` entries. The promoted versions required inline `sync` and `ei`
instructions, so they do not count as C++ matches.

## viBufRestartDMA

`viBufRestartDMA` is the third guarded draft. It compiles at the unit's default
optimization level (`-O3`), with the two ring-position tests written as the
repeated `IsInRegion`-style expression and a `volatile int *const` IPU control
pointer for the first busy-wait. Its only blocker is the tail's `env.d3madr`
reload: the draft differs by **53/200 words** (`0x318` against `0x320`), all in
the channel-3 restoration and the code it shifts.

- Ring count and address mask. Under the interference-graph capture the ring
  count `n` (a CSE temporary of `buf->n`) has exactly 25 interferences, so it is
  only simplified early when a lower-numbered neighbour goes first. Retail's
  colouring (mask `a2`, count `a3`) needs the `0x0FFFFFFF` CSE temporary numbered
  between `n` and the `d4madr`/`data` temporaries, and one of `n`'s neighbours
  (the ring position or the wrap `mode`) numbered below `n`.
- A named `pos` is a named local and numbers above every CSE temporary. Writing
  each ring test as the repeated expression (`0 > (n - start) % n || (n - start)
  % n >= dma_n`, likewise `fifo_index + n - start` in the other branch) makes the
  position a CSE temporary created after `n`, so it numbers below it.
- The local `optimization_level 4` is what moved the mask: its second IR round
  propagates the round-1 mask temporary away and recreates it below every other
  temporary. At `-O3` the round-1 numbering survives. With level 4 and the
  expression form the residual stays at nine words; with `-O3` and a named `pos`
  the wrap branch is wrong again.
- At `-O3` a plain `ipu_ctrl` local is propagated into the first busy-wait's
  address (`lui at` inside the loop); retail keeps the address in `v1` before the
  loop, which a `volatile int *const` local reproduces. The second wait reads the
  register address directly.
- Channel-3 reload. MWCC's load CSE distinguishes the qualification of the base
  pointer type: a read through `const ViBuf *` (or `volatile ViBuf *`) is not
  merged with a read through `ViBuf *`. Retail's reload of `d3madr` (and the
  unfilled delay slot before it) therefore needs the test and the restoration
  reads to go through differently qualified `ViBuf` pointers. A `const ViBuf *`
  inline restoration helper, a `const ViBuf *` alias or a `(const ViBuf *)` cast
  on either side gives 0/200 together with the forms above; each is an invented
  access path, so none is used. Qualifiers on the environment instead
  (`const sceIpuDmaEnv &`/`*` views, or `const ViBuf *` parameters of inline
  helpers that only test) are propagated and merged, or keep a separate base.
  No existing function supplies such a path: every retail `viBuf*` symbol and
  `getFIFOindex__FP5ViBufPv` mangle a non-const `ViBuf *`, and `getFIFOindex`
  is called out of line (a `const ViBuf *` parameter renames the symbol and
  leaves the draft at 53/200). The other callees (`DmaAddr`, `setD3_CHCR`,
  `setD4_CHCR`, the semaphore calls) take no `ViBuf`.
- Declaring `ViBuf::env` `volatile` reproduces the whole tail, but volatile loads
  keep source order: retail's prologue loads `d4chcr` first yet colours it as the
  last-created value, which only the non-volatile schedule gives (14 words at best,
  with a single read of `d4madr` in the wrap test).

## Data

All stream state, interrupt flags, decoder records, the output ring, the input
file and the 0x800-byte silence block are file-local typed definitions; the
twenty-two diagnostics and path literals are inline. The two `Load` overloads use
zero-initialized `MoviePools` locals (the 0x18-byte templates). `stepMain` has a
function-local `static int cnt = 0` that nothing reads (retail `cnt_513`/
`init_514`). `at_1276__2` and `at_1287__2`, the packed GIF tags of `setImageTag`,
stay `INCLUDE_RODATA` markers: the 128-bit shift initializer is rejected by MWCC
(`illegal data size`) and a typed pair of 64-bit words copied with `memcpy`
changes `setImageTag`.

## Typed access

- `StrFile::fp` ends with the SDK `sceCdlFILE` flag (formerly `unk_20`).
- `defMain`/`stepMain` are the thread entries directly; `defMain` is `void`.
- `audioDecBeginPut` keeps `(u8 *) ((int) dec->hdr + dec->hdr_count)`: retail forms
  `&dec->hdr` first (`addiu t2,a0,4`), while `dec->hdr + dec->hdr_count` adds the
  count to `dec` first. `viBufAddDMA` keeps `(u8 *) buf->data + n * 0x800`:
  quadword indexing evaluates the base load and index in the opposite order.
- `setImageTag` steps its `void *` parameter as `(u8 *) data + 0x400` and passes
  `*(u_long128 *) &giftag`: retail forms the local's address and loads through it.
- `videoCallback` and `videoDecPutTs` measure byte positions in raw stream
  buffers; `iop_buff`/`iop_zero` hold IOP heap addresses as `int`; DMA tags mask
  addresses with `& 0xFFFFFFF` / `| 0x20000000`.
- `videoCallback` and `pcmCallback` take `sceMpegCbDataStr *` (part of their
  mangled names) and are cast to the SDK's `sceMpegCbData *` callback type.

## Saved-state restoration and current draft

The measurements below were taken with the earlier local optimization level
4 and a named ring position (62/200 words); see
[viBufRestartDMA](#vibufrestartdma) for the current draft.

Fresh m2c output from `decompile.sh` continues to shift the apparent `ViBuf`
field offsets and loses the caller state around the two FIFO-index calls.
The existing layout remains authoritative: `env` begins at `0x1C`, the saved
channel-3 address/count are at `0x2C`/`0x30`, and the semaphore is at `0x40`.
Retail tests the two saved channel-3 words and reloads both before restoring
MADR/QWC. The plain source lets MWCC reuse the tested address. Changing
hardware-store volatility does not make that saved-state load volatile.

The following source forms do not resolve these constraints under the
canonical MWCC 3.0-011126 profile and the local optimization level 4:

- Reference-bound capacity or tag addresses preserve the 62-word residual;
  reference-bound byte extents or shared masks worsen it. Void/const-void
  tag argument views preserve it, while signed CHCR masks and shift-based
  mask expressions worsen it.
- Volatile MMIO stores, including the individual channel-3 stores, and
  typed `sceDmaChan` register accesses preserve the residual. Hardware-store
  volatility does not require the saved environment to be reloaded.
- Signed integer, void-pointer and byte-pointer MADR restoration stores
  preserve the residual. References to the saved address/count fields do
  not match, nor does a const environment view used throughout the function.
- Negated-disjunction, boolean-cast and nested channel-3 validity tests,
  and pointer endpoint comparisons through the byte-array view, preserve
  the residual.

A const `sceIpuDmaEnv` reference used only for the channel-3 restoration
stores produces a `0x320` body with twelve differing words.
The twelve-word saved-environment-reference result consists of the same
nine count/mask register exchanges plus three restoration differences:
`+0x224` computes a separate environment base in the branch delay slot,
and `+0x234`/`+0x240` address the reloads from that base instead of the
`ViBuf` base. This form establishes a reload mechanism but does not match
retail. A pointer/reference view is therefore insufficient evidence for
promotion; neither it nor a volatile buffer cast is retained as an alias
workaround.

## SDK sample comparison

The restart is Sony's EE MPEG sample `viBufRestartDMA` (`vibuf.c` in the
mpegstr/mpegvu1 samples; the mpegvu1 form reads the saved state before
`WaitSema`, as retail does). Its exact statement structure, with separate
`fp`/`ifc` counts, the `DATA_ADDR`/`TAG_ADDR`/`WRAP_ADDR` address forms, the
`IsInRegion` macro expansion, the `else if` with both FIFO-index assignments
in its condition, plain `&&` channel-3 test and volatile register stores,
compiles to the same 62/200-word body as the retained draft. The sample
source therefore does not explain either the count/mask exchange or the
channel-3 reload.

Under local `optimization_level 4`, adding `peephole off` gives 125 words,
`optimize_for_size on` 65, and `register_coloring off`, `opt_lifetimes`,
`opt_common_subs on`, `opt_propagation on`, `opt_loop_invariants on`,
`opt_strength_reduction(_strict) on`, `opt_dead_assignments on` and
`optimize_for_size off` all retain 62. `opt_common_subs off` grows the body
to `0x350`. Returning `int` from `getFIFOindex` (the sample's type) leaves
every function unchanged. Spelling `DmaAddr` as the sample's masking macro
gives 67 words, and `inline_depth(0)` at levels 3 or 4 grows the body to
`0x330`.

Retail keeps the first FIFO index in `a2` across the second
`getFIFOindex` call, so the allocator relies on that file-local callee's
register use; the draft reproduces this. The sample's channel-3 restoration
needs no `volatile` saved state, while retail's unfilled delay slot and
reloads are reproduced only by volatile reads of those two fields.

## Interrupt-handler exit

The sample handlers end with the SDK's `ExitHandler()`, which `eekernel.h`
defines as GCC inline assembly (`sync.l; ei`); this is the source of the
retail `sync; ei` in `handler_endimage` and both `vblankHandler` exits. The
pinned compiler's per-instruction intrinsics include `__I_c0`, `__I_mtc0`
and `__I_eret` but no `__I_sync` or `__I_ei`, and no source in the tree uses
`__I_*` intrinsics. Without an accepted non-assembly form the handlers stay
guarded.
