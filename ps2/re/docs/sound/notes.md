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
  sequence, 0xA0 (value `unk_98`), 0xB0 volume (`vol==256 ? 256 : (int)(vol*2.015748f)`),
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
| 0x98 | s32 | unk_98 | Sent with EZMIDI 0xA0 after LoadHdBd2. Init: 0x3040 (0,3), 0x3032 (1), 0x3039 (2,14), 0x3010 (7), 0x3035 (8), 0x3038 (9), 0x3037 (10), 0x3033 (11), 0x3034 (12), 0x3036 (13), 0x3031 (15). |
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

## CSound::Init guarded draft — scheduling blocker

Superseded by [night-20261008.md](night-20261008.md): the function matches with
the configuration assignments in the common port order.

`Init__6CSoundFiiii` (0x18A410, retail extent 0x780) remains guarded. The
natural draft has 12/480 relocated-field-masked instruction differences, down
from 190/480 at 0abce37. Its body is 0x77C bytes; retail's final four bytes are
alignment padding. The other 36 sound functions match in the draft check.

The common success return reproduces retail's final zero return and register
allocation. Chained SPU assignments write next address before current address.
The CSL null statements appear as extmod, callBack, conf in source, reproducing
retail's stores to context offsets 0x10, 0x0C, 0x08. The port setup is grouped
by field; its shared configuration IDs precede its singleton IDs in source.

The remaining instruction differences occupy function offsets 0x518..0x548
(0x18A928..0x18A958). Retail stores the configuration values for ports 10, 8,
1 and 15 at 0x518, 0x524, 0x530 and 0x53C, then writes port11.unk_00 = 0
at 0x548, in the load-immediate scheduling slot for port13's 0x3036. The draft
writes port11.unk_00 at 0x518, shifting those four configuration stores to
0x520, 0x52C, 0x538 and 0x544. Both streams realign at 0x54C. The remaining
MIDI_STATE stores have the retail widths, source registers and field addends;
the masked score alone does not check those addends.

Useful exclusions:

- Moving just port11's zero past the first four configuration statements makes
  an allocation-direction byte store advance into the early slot. Moving the
  entire direction group later makes a linked-port store advance instead.
  Splitting directions between the two configuration subgroups also fails.
- Moving the first singleton configuration group before the final kinds,
  directions, relationships or addresses disrupts constant allocation or
  scheduling. Separate SPU-address statements also disrupt allocation.
- Chained equal configuration IDs and a four-field chain for the shared
  0x5210 base have no effect. A twelve-field 0x7D210 chain worsens the schedule.
- A fixed-index local const configuration array survives as stack initialization
  and loads. Retail uses immediates here. A named port reference likewise adds
  pointers and saved registers.
- Retail uses word stores for kinds/configuration IDs and byte stores for
  directions; narrowing the word fields contradicts those stores. Direction is
  unsigned: changing it to s8 leaves Init unchanged but changes two loads each
  in LoadHdBd2/Add from retail's lbu to lb.

Reconsider when there is evidence for the original special-port assignment
ordering/grouping, or a documented MWCC scheduling rule that explains delaying
port11's zero without advancing a direction or relationship store. No runtime
helper, volatile qualifier or artificial dependency is justified by this code.

`CSound::LoadHdBd2` uses the native body. Its port and bank-data values must retain
the retail saved-register allocation; an earlier guarded draft exchanged those
registers.

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

## Init compiler-policy exclusion

`Init__6CSoundFiiii` contains no floating-point instructions or floating call
arguments. Its remaining +0x518..+0x548 discrepancy is integer global-store
scheduling: the zero store to port 11's `unk_00` occupies the configuration
store slot, and the streams realign at +0x54C. There is no IEEE-valued argument
consumer for an evaluate-first selector to identify.

The canonical Satan's Fiddle build with GPR helper mask `0x30` / FPR `0`
retains 12/480 differing instruction words and eight resolved-relocation
errors in Init. GPR `0x10` / FPR `0` leaves those Init differences unchanged
and additionally breaks `SQ_Play__6CSoundFiii` and `Step__6CSoundFv`. This mask
is unsuitable for the complete sound unit; no new profile row is accepted.

Blocker category: integer store scheduling, rather than floating argument
order or the measured helper-history alternatives. The guard remains.
Reconsider with a natural special-port assignment grouping that delays the
port-11 zero without advancing another direction/relationship store.

## Guarded sweep: per-port initialization groups (October 8)

The refreshed `6be9e34` sweep confirms `Init__6CSoundFiiii` at 12/480
relocation-masked words, with a 0x77C body in the 0x780 retail extent.
Fresh `decompile.sh` output and the complete zero-word-preserving instruction
comparison retain the same +0x518..+0x548 discrepancy. The decompiler flattens
the composite MIDI state into guessed fields; the existing 0x124-byte
`MIDI_PORT` layout and retail load/store widths remain the type authority.

The new hypothesis groups each port's existing kind, direction, dependency,
address and configuration assignments together, instead of grouping by field.
No assignment value or destination changes. Three port traversals test the
retail setup order, numeric index order and common-memory grouping. Each is
also measured with configuration immediately after kind within a port.

| New source grouping | Differing words / 480 | Native bytes |
| --- | ---: | ---: |
| Existing field groups | 12 | 0x77C |
| Port groups in retail setup order | 121 | 0x77C |
| Same, configuration after kind | 120 | 0x77C |
| Port groups in numeric index order | 121 | 0x77C |
| Same, configuration after kind | 119 | 0x77C |
| Port groups by common memory region | 120 | 0x77C |
| Same, configuration after kind | 123 | 0x77C |

These forms do not recover the special zero-store schedule and disrupt other
already matching initialization instructions. All candidates remain private;
the source, header and compiler profile are unchanged. The retained blocker
is still integer global-store scheduling, with no admissible floating-argument
selector or helper-policy improvement.

Receipts are `.private/sweep-midday/sound-init-m2c.cpp`,
`sound-init-baseline-diff.txt`, `sound-port-probes.log` and the per-candidate
sources, compile logs and metrics under `sound-port-probes/`. The lane-wide
baseline is recorded in `baseline-build.log` and `baseline-objects.log` in
that same private root.
