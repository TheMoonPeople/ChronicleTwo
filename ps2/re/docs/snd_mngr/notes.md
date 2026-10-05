# snd_mngr: reverse-engineering notes

## C++ draft status
All 104 functions have C++ in `ps2/src/snd_mngr.cpp`. 31 are exact and compiled
by the matching build. 24 more compile to retail's bytes in isolation but stay
under `NONMATCHING`. 49 differ from retail and keep the `INCLUDE_ASM` fallback.
Each function tried has its one promotion attempt recorded in
`scripts/re/promotion_attempts.tsv`.

Sound manager layered over `CSound` (unit `sound`, global `CSnd`, gp-0x7588). No first-game
counterpart: the first game's sound wrapper (`snd.hpp`, `SndInitialize`/`SndBgm*`) is a different
design. All driver calls are bracketed by `sndWaitSema()`/`sndSignalSema()`.

## File-local symbols (all of the unit's data is LOCAL)
Every data symbol of the unit is local in retail (`build/re/local_symbols.tsv`), so the header
declares no `extern`s. Define them `static` in the `.cpp`:

| Symbol | Section | Type | Notes |
|---|---|---|---|
| `EnableSndMngr` | .sdata | `int` = 1 | sndLoadSound returns -1 when 0 |
| `snd_sema_id` | .sdata | `int` = -1 | semaphore id; Wait/Signal skip when < 0 |
| `MasterVol` | .sdata | `float[2]` = {1,1} | per core, set by sndSetMasterVol / fade target |
| `MasterVolFade` | .sdata | `int[2]` = {0,0} | fade active flag |
| `snd_old_vsync` | .sdata | `int` = -1 | last vsync CSndStep stepped the driver on |
| `ReverbType`, `ReverbDepthe` | .sbss | `int[2]` | per core (retail spelling "Depthe") |
| `init_snd` | .sbss | `int` | driver initialised |
| `feMasterVol`, `fnowMasterVol`, `fstpMasterVol` | .sbss | `float[2]` | fade end / current / step |
| `PortInfo` | .bss | `sndPortInfo[16]` | 0x29C0 = 16 * 0x29C |
| `SeSequencer` | .bss | `sndCSeSeq[32]` | 0x1600 = 32 * 0xB0 (snd_seseq.hpp) |
| `PortVolf` | .bss | `float[16]` | |
| `MicPos`, `MicDir` | .bss | `float[4]` each | 16-byte aligned (copied with lq/sq) |
| `at_1555` (0x24), `at_1648` (0x10) | .bss | compiler statics | the initialiser arrays of the `char *col[]` locals in LoadSeInfoTxt (9 entries, last NULL) and LoadVolInfoTxt (4) |

`__sinit_snd_mngr_cpp` constructs PortInfo (ctor 0x191C30, 0x29C, 16) and SeSequencer
(ctor 0x191BB0, 0xB0, 32).

File-local functions (static; not in the header), prototypes:
`sndPortInfo *GetPortInfo(int)` (bounds `0..16` -- off by one vs 16 entries, retail bug),
`sndCSeSeq *GetSeSeq(int)` (0..31), `sndCSeSeq *GetEmptySeSeq(int *index)` (free = `data == NULL`),
`int GetPortNo(unsigned)` (`>>24`), `int GetBankNo(unsigned)` (`>>16 & 0xFF`),
`sndBankInfo *GetBankInfo(unsigned)`, `sndSeInfo *GetSeInfo(unsigned, int)`,
`void SetMasterVol(int core, float)` (clamp, `*16383`), `void FadeMasterVol()`,
`int CSndStep()` (steps driver once per vsync), `void CSndStepWait()` (busy loop then Step),
`void SeAllStop_Sub(int port_no)`, `int IsBgmPort(int)` (0 or 11),
`int GetCSndPortNo(int port_no, int *port, int *sq_port, int *vol)`,
`int GetPortBankNo(unsigned id, int *port, int *bank)`, `char *GetLine(char **col, char *p, char *end)`,
`int PlaySeSeq(unsigned id, sndCSeSeqData *, int vol)`, `void StopSeSeq(int)`, `void SetVolSeSeq(int, int)`.
Because these are static, MWCC knows their register usage: callers rely on `$a0..$a3` surviving
calls to GetPortNo/GetBankNo/GetPortInfo (Ghidra's `extraout_*`). E.g. sndSetPortVol indexes
`PortVolf[port_no]` through the preserved `$a0`.
GetBankInfo/GetSeInfo bodies are also visibly inlined into many callers (sndSePause, sndSeStop,
LoadSeInfoTxt, ...): bounds check `bank < bank_num` then `&bank[i]`; `se < se_num` then `&se[i]`.
Inline members on sndPortInfo/sndBankInfo with these bodies are likely; their names are unknown.

## Sound ID
`port_no << 24 | bank << 16` from sndLoadSound; sndCreateID ORs in `se_no & 0xFFFF`.

## Classes
### SND_LOOP_SE_SEQ (0x14)
Stride 0x14 and `__construct_new_array(..., 0x14, n)` in CLoopSeMngr::Create.
0x0 int se_id (-1 free; `< 0` tests), 0x4 s16 keep_time, 0x6 s16 count, 0x8 s16 voice (compared
sign-extended to the int voice arg), 0xA unused, 0xC float vol (-1 default), 0x10 float pan.
Ctor/Clear/Step/AllSeStop all do the same 3 stores (`se_id=-1, vol=-1, pan=0`) -- likely an
unnamed inline reset.
Step: count==0 -> play (sndSePlayVPf if vol>=0 else sndSePlay); else if vol>=0 update Volf/Panf;
then if `keep_time <= count` stop + free; count++. SeLoopPlayStop sets count = found ? 1 : 0.

### CLoopSeMngr (8)
0x0 int loop_se_num, 0x4 SND_LOOP_SE_SEQ *loop_se. Size: menuchr's stack object is 8 bytes
before the next local; in CScene at 0x10540 (mgCMemory at 0x10510). Inline ctor calls Initialize
(seen in `__sinit_mainloop_cpp` and MenuItemCharaDataLoadEndCheckAfter). Create(n, mem):
`mem->Alloc(...)` + `operator new[](size, ptr)` + construct_new_array; returns 1 when loop_se != NULL,
0 when mem is NULL. The 4-arg SeLoopPlayStop tail-jumps to the 6-arg one with vol -1, pan 0.

### sndSeInfo (0xC)
Stride 0xC, memset 0xC, construct_new_array 0xC in LoadSeInfoTxt. Ctor stores word 0 and byte 4.
0x0 int unk_0 (never read), 0x4 s8 type (sndSE_TYPE, lb), 0x5 s8 prog (number by type),
0x6 s8 key, 0x7 u8 unk_7 (= 8th text column non-empty; never read here), 0x8 s8 def_vol
(lb; 0x40 default, overwritten by the volume table).

### sndBankInfo (0x1C)
Stride 0x1C inside sndPortInfo (0xC..0x1CC, 16 entries). Ctor zeroes all 7 words.
0x0 unk_0 (never read), 0x4 se_num, 0x8 sndSeInfo *se, 0xC sq_num (GetPackFileExt "sq", max 32),
0x10 char **sq_name (mgCopyString), 0x14 seseq_num ("mid", max 48), 0x18 sndCSeSeqData *seseq
(`new[]` 0x10 each, LoadSMF; name copied into sndCSeSeqData::name).
SearchSeq return: "KeyOn" -> 1; name matches sq_name -> 2 (index); matches seseq name -> 3;
otherwise 0 when the name contains '.', else 1. Uses strcmp for "KeyOn" and strcasecmp for names.

### sndPortSeSeq (8, neutral name)
16 entries at sndPortInfo+0x21C. Ctor (inline, in sndPortInfo ctor loop) stores 0xFFFF to 0x0.
0x0 s16 seseq_no, 0x2 s16 se_no, 0x4 s8 bank, 0x5 s8 voice, 0x6 s8 set to 1 when started (never
read), 0x7 unused. sndSeStop/sndSetSeVol match on bank, se_no and voice.

### sndPortInfo (0x29C)
16 * 0x29C = 0x29C0 = PortInfo; `__construct_array(..., 0x29C, 16)`.
0x0 port, 0x4 sq_port (from GetCSndPortNo), 0x8 bank_num (max 16, sndLoadSound rejects > 15),
0xC bank[16], **0x1CC..0x20B: 0x40 bytes never touched by any code found** (not by ctor,
sndInitPort or any accessor), 0x20C sq_no, 0x210 sq_state, 0x214 sq_vol, 0x218 sq_se_no,
0x21C seseq[16].
Ctor order: bank ctors, seseq ctors, then the same body as sndInitPort's reset (port/sq_port -1,
bank_num 0, sq_no -1, sq_state 0, sq_vol 0, sq_se_no -1, seseq[i].seseq_no = -1 unrolled x8,
bank words zeroed unrolled x8). That reset is very likely a shared inline member (name unknown);
the header ctor body writes it out and will need adjusting to match.
LoadSeInfoTxt/LoadVolInfoTxt: reverb applies to core 0 when `port == 0`, core 1 when `port == 7`.
LoadVolInfoTxt also stores ReverbType/ReverbDepthe and printf("REVERB %d %d\n").
Text tokens: "END" stops, "REVERBE" (SeInfo) / "REVERB" (VolInfo) lines, lines starting with a
digit are entries. Columns (SeInfo): 0 se no, 4 file name (SearchSeq), 5 prog, 6 key, 7 flag.

## GetCSndPortNo table (game port -> driver port, sequence port, initial volume)
0 -> 0, 0, -; 1 -> 15, -1, 256; 2 -> 1, 1, -; 3 -> 10, -1, 256; 4 -> 14, 2, 256; 5 -> 13, -1, 256;
6 -> 12, -1, 256; 7 -> 9, -1, 256; 8 -> 11, -1, 256; 9 -> 8, -1, 256; 10 -> 7, -1, 256;
11 -> 3, 3, -; other -> fails. Jump table `at_816__2`.
sndLoadSound loads "sq" sequences only for game ports 0, 11, 2, 4.

## Enums
- sndPORT: names from retail globals `SndPortVol_Ob/Base/Event/Enemy` (ports 1/3/4/5 via
  sndGetPortVol in menucommon/menumain), `SystemSND_ID` (port 6, MainLoop), menu loaders (port 8),
  IsBgmPort / sndInitPort (0 and 11). Ports 2, 7, 9, 10 have no established name. `BGM2` is a
  descriptive name only.
- sndSE_TYPE: SearchSeq results (above).
- sndSQ_STATE: 1 set on play, 2 by sndSePause, 3 by sndPortSqPause, 0 by sndSeStop.
- sndREVERB_TYPE: LoadSeInfoTxt string table at_1627..at_1636 ("Room".."Max") -> 1..10.

## Parameter meaning
sndSePlaySeID(id, se_no, velocity, vol, pan, pitch, voice): callers pass velocity -1, pan 0x40,
pitch 0x2000. sndSePlayPBPrKr passes to `CSound::SE_Play(port, bank, prog, key, pan, velocity, vol,
pitch, voice)` (argument order permuted: SE_Play's 5th = our pan, 6th = velocity, 7th = vol);
velocity/vol < 0 -> 0x7F. In SE_Play, arg 5 goes to message F9 01 (pan), arg 7 to F9 00 (volume),
arg 6 to the note-on velocity, voice must be < 0x7F.
sndSqStop/sndSqRePlay ignore sq_no. sndStep's float is passed to sndCSeSeq::Step (callers pass 2.0).
sndGetSeDefVol returns s8 (lb). sndGetMasterVol/sndGetPortVol return float.
sndMasterVolFadeInOut(core, frames > 1, target, start (<0 = current MasterVol)); no fade when
|target - start| < 0.01.
