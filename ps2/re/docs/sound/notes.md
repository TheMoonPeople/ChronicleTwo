# sound: reverse-engineering notes

## CSound
- Empty class, `sizeof == 1`: no function reads `this`. The single instance `CSnd` (0x37D168, symbol
  size 0x1) is owned by **mainloop** (`INCLUDE_BSS(CSnd, 0x4)` in `mainloop.cpp`), so it is not
  declared in `sound.hpp`.
- 37 members: 36 in `sound`, plus `StreamOpenState()` in `ezbgm` (`j sceSifCheckStatRpc(&gCd2)`;
  callers use the result, so `int`).
- First-game counterpart: `CSound` in `chronicle/ps2/include/sound.hpp` (also empty). Different
  interface here: no SE/SQ description tables, no `Fade`, no per-bank `LoadHdBd_X`; banks are loaded
  generically per port (`LoadHdBd`/`LoadHdBd2`/`LoadHdBdAdd`), plus EZBGM stream functions.
- Return types: `Init` (0 ok, -1 IOP alloc failed, 1 `sceMSIn_Init` failed), `Exit` (always 0),
  `LoadSeq` (0 / -1), `TransHdBd` (0 / -1), `StreamGetState` (`ezBgm(ch|0x80B0,0) & ~0xFFF`),
  `StreamGetLevel` (tail call; `_STREAM_SILENT_CHECK` uses result as two shorts),
  `TransBdState` (tail call; `sndWaitTransBd` loops on `sndTransBdState()` result).
  `LoadHdBdAdd` returns 0 on the "too many banks" path (`daddu $2,$0,$0`); on success $v0 is left
  holding the last `ezMidi` result (no explicit return in that path) -> declared `int`.
  `LoadHdBd` (0x10) is `j LoadHdBd2` -> `void`; `LoadHdBd2` sets no $v0 -> `void`.
  Other tail-call wrappers (`StopVoice`, `SetReverb`, `SetMasterVol`, `Stop`, `SetStereoMode`)
  have no caller using a result -> `void`.

## Parameters
- `Init(mode0, mode1, depth0, depth1)` -> `set_spu`: per core c: `SD_A_EEA|c = 0x1FFFFF - c*0x20000`,
  effect attr mode = `mode_c | 0x100` (clear WA), `SD_C_EFFECT_ENABLE|c = 1`, EVOL L/R = `(depth_c & 0xFF) << 8`,
  MVOL L/R = 0x3FFF. `sndInitMngr` calls `Init(4, 0, 0x28, 0)`. `SetReverb(core, mode, depth)` same per core.
- `SndInReverb(bool)`: `rSdSetParam` 0x800/0x801 (param 0x08 per core) = 0xFFFC (on) / 0xFFCC (off).
- SE functions: names from `snd_seseq` callers via `snd_mngr::sndSe*PBPrKr`. `sndSePlayPBPrKr(port, bank,
  program, key, velocity, volume, pan, pitch, id)` calls `SE_Play(port, bank, program, key, pan,
  velocity, volume, pitch, id)`. Messages: CC0 (bank select) = bank, program change = program, then
  HS messages: `F9 00 00 volume 00`, `F9 01 00 pan 00`, `FD 10 00 key id velocity 00` (note on).
  `pitch` (param 8) is unused by `SE_Play`. `SE_SetVol`: `FD 00 00 key id volume`. `SE_SetPan`:
  `FD 01 00 key id pan`. `SE_Stop`: `FD 10 00 key id 0` (velocity 0). `SE_SetPitch`:
  `FD 02 00 key id pitch&0x7F (pitch>>7)&0x7F`. All reject `id >= 0x7F` with "SE_ID ERR"; all but
  `SE_SetPitch` require `port.bank_count > 0`. MSIn port = `port - 7`.
- `LoadHdBd*(port, hd, hd_size, bd, bd_size)`: EE address/size of bank header and body
  (`sndLoadSound` passes them). `LoadSeq(port, address, size)`: EE address and size of a sequence.
- `StreamSetVol(ch, left, right)`: arg = `left << 16 | right`; `sndStreamSetVol(float,float)` passes
  `fptosi(x * 32767)` each, channel 1.
- EZBGM commands (arg `ch | cmd`): 0x10 close, 0x30 stop(Close), 0x40 standby start, 0x50 play/replay,
  0x60 pause/stop, 0x70 end(END), 0x80 set volume (and reset with 0 before open), 0x8000 set buffer
  (0x3000 mono / 0x4000 stereo), 0x8020 open, 0x80B0 state, 0x80C0 (0x10 mono / 0 stereo),
  0x80D0 standby info (bit 0 = stereo), 0x80E0 level, 0x80F0 open from FPL.
- EZMIDI commands used (arg `port + cmd`): 0x00 play, 0x20 stop, 0x30 (before play), 0x40 set
  sequence, 0xA0 (value `ezmidi_param`), 0xB0 volume (`vol==256 ? 256 : (int)(vol*2.015748f)`),
  0x9050 load bank (`&gBank`), 0x8010 (Init: returns IOP MSIn buffer address, arg 0x4000), 0x80F0 (Exit), 0xC0 stereo mode.

## MIDI_PORT (0x124) / MIDI_STATE (0x1240)
`midi_state` (0x3F5250, local, size 0x1240 = 16 * 0x124). Stride 0x124 seen everywhere (`port*0x124`,
`*0x49` on word arrays). Init's per-port loop gives the layout:

| Off | Type | Name | Evidence |
|---|---|---|---|
| 0x00 | s32 | unk_00 | Init: 0 then per-port 0/1/2 (1,2,8,14,15 = 2; 13 = 1). Never read in sound. |
| 0x04 | u8 | spu_direction | `sb`; LoadHdBd2/Add `lbu` compare 0 / 1 (SpuAllocDirection). Port 13 = 1. |
| 0x08 | s32 | linked_port | Init -1; LoadHdBd2/Add also load gBank into it, copy bank ptr / next addr, bump its bank_count; DEL_PORT deletes it. Port 2 -> 14, port 14 -> 2. |
| 0x0C | s32[16] | dependent_port | Init -1 (loop 16); loops to count at 0x4C; stopped and given this port's spu addresses. |
| 0x4C | s32 | dependent_port_count | port1: [15,2,14] n=3; port8: [1,15,2,14] n=4; port10: [8,1,15,2,14] n=5; port15: [2,14] n=2. |
| 0x50 | void*[16] | bank | IOP hd addresses (`gBank.hd_address`), freed with sceSifFreeSysMemory. |
| 0x90 | s32 | bank_count | `< 0x10` check in LoadHdBdAdd; SE_* require > 0. |
| 0x94 | s32 | spu_address | Init: ports 0,3 = 0x5210; 1,2,8,10,14,15 = 0x7D210; 7,12,13 = 0x18AE20; 9 = 0x1E0000; 11 = 0x1A82E0. Not zeroed in the generic loop. |
| 0x98 | s32 | ezmidi_param | Sent with EZMIDI 0xA0 after LoadHdBd2. Init: 0x3040 (0,3), 0x3032 (1), 0x3039 (2,14), 0x3010 (7), 0x3035 (8), 0x3038 (9), 0x3037 (10), 0x3033 (11), 0x3034 (12), 0x3036 (13), 0x3031 (15). |
| 0x9C | s32 | spu_next_address | Init = spu_address; upward: load at it then += bd_size+0x10; downward: -= bd_size+0x10 and load there. |
| 0xA0 | void*[10] | sequence | LoadSeq stores `[count]`; SQ_Play reads `[seq_no]` (seq_no < count). Init zeroes 10 (8 unrolled + 2). |
| 0xC8 | void* | resident_sequence | LoadSeq when count==0: ezMidi(port+0x40, addr), frees old, stores addr. DEL_PORT/LoadHdBd2 re-send it, free sequence[1..]. |
| 0xCC | s32[10] | unk_CC | Only zeroed by Init (10 entries). First game's `MIDI_SEQUENCE *sequence[10]` sits here. |
| 0xF4 | s32 | sequence_count | LoadSeq prints "SEQ_MAX OVER" when > 15 -- note the arrays are only 10 long. |
| 0xF8 | MIDI_FADE[2] | fade | Step: 0xF8 active (lw), 0xFC target (lwc1+cvt.s.w -> int), 0x100 volume (float), 0x104 step (float). Init zeroes 0x108 (fade[1].active). |
| 0x118 | s32 | unk_118 | Init 0; ports 13 and 15 = 1. Not read in sound. |
| 0x11C/0x120 | s32 | unk_11C/unk_120 | Init 0 only. |

- `Step` only processes `fade[0]` of each port, and calls `SetVol(0, vol)` with port 0 constant.
- No unit other than sound references `midi_state` (or any of the sound globals except `iop_bd_addr`).

## Other data
- `gBank` (0x3F5200, local, symbol size 0x44, BSS slot 0x50): MIDI_BANK. 0x00 bank_no (0 for
  LoadHdBd2, old bank_count for Add), 0x04 hd IOP addr, 0x08 = iop_bd_addr, 0x0C bd_size, 0x10 SPU
  dest address; 0x14..0x43 never touched. Passed to EZMIDI 0x9050 (argument-block flag 0x1000 ->
  64-byte block). First game's MIDI_BANK (0x40) lacked bank_no.
- `iop_bd_addr` (0x37D0F8, **global**, also read by `movie::strFileOpen`): IOP staging area,
  `sceSifAllocSysMemory(1, 0x6DD00, 0)` in Init; bodies over 0x6DD00 bytes are sent in two parts.
- `iopMSINBuffAddr` (local, .sbss 0x8 slot): IOP address of the 9 MSIn buffers (`ezMidi(0x8010,0x4000)`).
- `bgm_info` (local, 8 bytes): per-stream-channel word from EZBGM open/standby (bit 0 = stereo).
- `bd_size_total` (local): zeroed in Init only.
- `load_m_flg_351`, `init_352`: function-local static (and its guard) inside Init.
- `msinCtx` (sceCslCtx, 0x14): {buffGrpNum 2, &msinBfGrp, 0, 0, 0}. `D_003F3F6C` is padding after it.
- `msinBfGrp` (sceCslBuffGrp[2]): [0] = {0, 0}, [1] = {9, msinBfCtx}.
- `msinBfCtx` (sceCslBuffCtx[9], 0x48): {0, &msinBf[i]}.
- `msinBf` (MSIN_BUFFER[9], 0x1200): size = 0x200, length = 0 at Init. Step sends each buffer with
  length 1..0x200 to `iopMSINBuffAddr + i*0x200` then clears length; DEL_PORT/LoadHdBd2 clear
  `msinBf[port-7].length`.
- All of the above except `iop_bd_addr` are LOCAL in retail, so they belong as `static` in sound.cpp.

## Unresolved / for the body writer
- IOP heap/RPC functions are declared in `ps2/include/sce/sifrpc.h`; the EZBGM
  client declarations are in `ps2/include/ezbgm.hpp`.
- TransHdBd checks "SYS AREA HAKAI?" when the destination range straddles 0x18AE20.
- Port roles (BGM, SE, ...) are not established from this unit; no port enum was declared.

## CSound::Init

Init is native and exact: body `0x77C` in a `0x780` extent. Configuration assignments
follow the common special-port order; [the scheduling note](matching-constraints.md)
explains the zero store and records alternatives. Types retain word stores for
configuration/kinds and unsigned byte accesses for allocation direction.
CSound::LoadHdBd2 is also native and exact.

## CSound::SQ_Play

`decompile.sh SQ_Play__6CSoundFiii` confirms the existing `MIDI_PORT` layout:
0x124-byte port stride, sequence table at +0xa0, sequence count at +0xf4.
The sequence index must be below the count; negative indices are not rejected.
The loaded IOP sequence address is passed to `ezMidi` command port+0x40.
Commands port+0x20, +0xb0, +0x30 and the bare port reset, set volume, position
and start playback. Volume 256 bypasses scaling; other values convert
`2.015748f * volume` to signed integer. Three diagnostic strings belong to this
function. CSound owns no per-instance state; `midi_state` provides port data.

The SQ_Play calibration passes canonical byte and resolved relocation comparison
with the pre-merge sound unit (0x2dec bytes, 681 relocations). Select the loaded sequence
in a positive `seq_no < sequence_count` branch, with the diagnostic and early
return in the alternative branch. The helper profile for `sound.cpp` seeds the
integer argument-register read mask to 0x20 ($a1); floating helper mask remains
zero. This prevents `$a1` from being prepared for `ezMidi` across `fptosi` and
restores the retail conversion branch delay slot. The three sequence diagnostic
strings are native literals; their duplicate assembly markers are removed.

## CSound::LoadSeq

`decompile.sh LoadSeq__6CSoundFiii` confirms IOP allocation of 256 bytes for
sizes at most 256, or `size + 256` otherwise. An allocation failure reports an
error and returns -1. The new sequence is inserted at sequence_count; its EE
payload is copied to the IOP allocation. For the first sequence, port+0x40
receives the address and any previous resident_sequence is freed. The count is
incremented; counts at least 16 report overflow after insertion. The sequence
and resident table fields agree with the existing MIDI_PORT layout.

The active native body accesses the sequence array and count directly through
`midi_state.port[port]`. Caching the whole MIDI_PORT or the count field changes
address scheduling; those intermediate forms do not match the retail sequence.

## CSound::Step

`decompile.sh Step__6CSoundFv` confirms updates of the first fade in each of
16 MIDI ports. Positive steps stop only after exceeding target volume (unordered
comparisons also enter that branch); negative steps stop after falling below it.
Each active fade calls SetVol with port zero. Nine MSIN_BUFFER records are then
sent when their length is nonzero and at most 512 as unsigned; oversized records
are discarded. The full 512-byte record is transferred, and length is cleared
regardless of transfer status. The active native body accesses fade members directly through the port array.
Caching a MIDI_FADE pointer changes retail's separate field-address allocation.

## Rejected Init alternatives

Init contains no floating call arguments. Changing the GPR helper seed from `0x30` to
`0x10` did not repair the old store schedule and broke SQ_Play and Step. Per-port
regrouping scored 119–123 differing words; a fixed-index local configuration array added
stack stores/loads, and named port references changed register allocation.
Configuration/kind narrowing contradicts retail word stores; signed direction bytes
change LoadHdBd2/Add loads from lbu to lb.

## Native data and matching constraints

All data are native. Only iop_bd_addr has public linkage; CSL state and bank records are
file-local with extents 0x14, 0x48 and 0x44. CSound::Init owns load_m_flg and its
compiler guard. MSIN_BUFFER[9] owns 0x1200 bytes, MIDI_STATE owns 0x1240, and the
terminal 0x30-byte MIDI gap is linker padding.

Unrelocated library byte-table words at 0x363F5C/0x363FE4 numerically resemble
msinBf+0x141/+0x40; they are not live buffer references. Likewise the unrelocated
0x3F3F6C word at 0x361600 in memcard data is not pointer evidence. Removing that phantom
boundary lets msinCtx own its full zero tail to msinBfGrp. Numeric address guesses,
unsupported expressions and conflicting relocated bytes must remain rejected.

## MIDI initialization constants

CSound::Init initializes MIDI_PORT unk_00, unk_CC, unk_118, unk_11C and
unk_120 without an established later purpose. unk_98 is sent with EZMIDI
command 0xA0, whose semantics remain unknown. 0x8010 combines
EZMIDI_RESPONSE and command 0x10; the command vocabulary is not yet named
across the unit. Driver ports 0-15 differ from sndPORT game ports.
The ezMidi result is converted from integer to pointer. The shared SDK
interface supplies no established mode constant for the sys-memory
allocation's value 1. The retail Init body is 0x77C at 0x18A410.
