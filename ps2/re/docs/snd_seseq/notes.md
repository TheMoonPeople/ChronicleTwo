# snd_seseq: reverse-engineering notes

## C++ draft status
All 28 functions have C++ in `ps2/src/snd_seseq.cpp`. 23 are exact and compiled
by the matching build. 5 differ from retail and keep the `INCLUDE_ASM` fallback.
Each function tried has its one promotion attempt recorded in
`scripts/re/promotion_attempts.tsv`.

Sound-effect sequencer: SMF (format 0) data converted to a 6-byte event list (`sndCSeSeqData`),
played by `sndCSeSeq` (32 instances in `SeSequencer`, owned by snd_mngr), one `sndTrack` per
MIDI channel. No first-game counterpart (the first game's `snd.hpp` has no sequencer classes).
No vtables. No plain-named globals in this unit; rodata is `at_295` ("MThd"), `at_296` ("MTrk"),
`at_297` ("Unknown Message!..." printf format).

## File-local functions (static, keep in the .cpp)
`BigToLittle__FPvPvi` and `GetDeltaTime__FPcPi` are LOCAL in retail (local_symbols.tsv).
- `static void BigToLittle(void *dst, void *src, int size)`: copies `size` bytes reversed (src
  forward, dst from end); used for SMF big-endian header fields.
- `static char *GetDeltaTime(char *p, int *delta)`: reads a MIDI VLQ, returns pointer after it.

## sndCSeSeqData (0x10)
Size: snd_mngr `sndLoadSound` indexes an array of them with stride 0x10; `sndSePlaySeID` uses
`cVar1 * 0x10`.
| Off | Field | Evidence |
|---|---|---|
| 0x0 | `char *name` | `sndLoadSound` stores `mgCopyString(...)` into it before `LoadSMF` |
| 0x4 | `int tick_rate` | Initialize = 1; LoadSMF = `division * 225 / 60` (division = s16 at SMF+0xC); `Count` adds `tick_rate * frames / 60.0f` |
| 0x8 | `int event_num` | LoadSMF counts events, then recomputes `(end - event + 6) / 6` (includes terminator) |
| 0xC | `sndSeSeqEvent *event` | LoadSMF: `memory->stAllocTest(1)` gives the write address, events written in place, then `memory->Alloc(qwords)` commits `ceil(event_num*6/16)` |
Ctor (snd_mngr 0x18F4B0) only calls `Initialize()`: declared inline in the class.
LoadSMF: requires "MThd", format (s16 at +8) == 0, "MTrk" at `smf + hdrlen + 8`, track length at
`+hdrlen+0xC`; events start at `+hdrlen+0x10`. Running status supported (status byte reused when
bit 7 clear). Meta 0xFF: 0x2F ends the loop, others skipped by `p[1] + 2`. Data byte counts:
0xC0/0xD0 -> 1; 0x80/0x90/0xB0/0xE0 -> 2; others 0 per Ghidra, yet a `count < 0` branch
printing `at_297` with the status exists in the asm: check the disassembly for how the default
count is set before writing the body. The `size` parameter appears unused in
Ghidra output (verify in asm when writing the body). Terminator: `status = 0` written to the next
slot.

## sndSeSeqEvent (6, name not retail)
`s16 delta` (sh at +0, lh in Step), `u8 status` (lbu in Step), `u8 unk_3` (never touched),
`s8 data[2]` at +4/+5 (lb in Step for note/ctrl/prog; PitchBend uses lbu of +5,+4 — cast `(u8)`).

## sndSeSeqVoice (4, name not retail)
From `sndTrack::SaerchVoice/GetEmptyVoice/NoteOn` and `sndCSeSeq::Send*`/`TrackNoteOff`
(all `lb`): +0 active, +1 prog, +2 key, +3 se_id. Has an inline ctor `active = 0`: the
`sndCSeSeq` ctor clears byte 0 of each voice (loop 0x3C..0x40 per track) before calling
`sndTrack::Initialize`, i.e. the array-construction pattern of voice ctor then track ctor.

## sndTrack (0x10)
Size from sndCSeSeq stride (`trk * 0x10 + 0x30`) and the ctor loop (0x30..0xB0 step 0x10).
| Off | Field | Init | Evidence |
|---|---|---|---|
| 0x0 | `s8 vol` | 0x7F | CtrlChg ctrl 7 |
| 0x1 | `s8 expression` | 0x7F | CtrlChg ctrl 11 |
| 0x2 | `s8 prog` | 0 | ProgChg; passed as prog to SaerchVoice / sndSe* |
| 0x3 | `s8 pan` | 0x40 | CtrlChg ctrl 10; passed to sndSetSePanPBPrKr / play |
| 0x4 | `s8 bend_lsb` | 0 | PitchBend second param |
| 0x5 | `s8 bend_msb` | 0x40 | PitchBend first param |
| 0x6 | `s8 se_id` | 0 | sndCSeSeq::Initialize = 0x40+i, SetSeID = id+i; copied into voice +3 |
| 0x7 | `unk_7` | - | padding |
| 0x8 | `int voice_num` | 1 | loop bound in SaerchVoice/GetEmptyVoice/Send* |
| 0xC | `sndSeSeqVoice voice[1]` | active=0 | one slot only (fits size 0x10) |
Ctor is inline (`Initialize()`); not in manifest.
Return values (asm checked): NoteOn/NoteOff/CtrlChg/PitchBend return int 0/1 (no `andi 0xff`, so
`int`, not `bool`); ProgChg returns 0 (caller ignores it). NoteOn: existing voice -> 1; else empty
voice -> fill (active=1, prog, key, se_id) -> 1; none -> 0. Velocity params are unused.
`SaerchVoice` is retail's spelling.

## sndCSeSeq (0xB0)
Size: `SeSequencer` 0x1600 = 0x20 * 0xB0; `__construct_array(0x3f8f00, ct, 0, 0xb0, 0x20)` in
`__sinit_snd_mngr_cpp`; GetEmptySeSeq stride 0xB0.
| Off | Field | Evidence |
|---|---|---|
| 0x00 | `int port` | PlaySeSeq: `= *GetPortInfo(port)` (port info field 0); 1st arg of sndSe*PBPrKr -> CSound::SE_* ; sndStopSeSeq compares it |
| 0x04 | `int bank` | PlaySeSeq: `GetBankNo(id)`; 2nd arg of sndSe*PBPrKr |
| 0x08 | `sndCSeSeqData *data` | PlaySeSeq; NULL = free (GetEmptySeSeq, Step returns 1) |
| 0x0C | `sndSeSeqEvent *event` | Step: set to `data->event` if NULL; `+= 6` per event |
| 0x10 | `int tick` | Count adds delta; saved into loop_tick |
| 0x14 | `int wait` | Count adds delta; Step subtracts each due event's delta |
| 0x18 | `int vol` | Initialize 0x7F; PlaySeSeq / SetVolSeSeq (<0 -> 0x7F) |
| 0x1C | `int loop_tick` | Step: `= tick` on CC110 value 0 |
| 0x20 | `sndSeSeqEvent *loop_event` | Step: `= event` on CC110 value 0 (the CC event itself; pointer then advances) |
| 0x24 | `int loop` | Step: cleared each step; set on CC110 value 127; when set, end-of-data does not stop, and after the loop `event = loop_event` |
| 0x28 | `int pause` | Initialize 0; Step returns 0 without advancing when non-zero. No writer of a non-zero value found (name chosen from that read) |
| 0x2C | `int track_num` | Initialize 8; chk_trk bound |
| 0x30 | `sndTrack track[8]` | |
Ctor (snd_mngr 0x191BB0, size 0x80): constructs `track[]` (voice ctors, then `sndTrack::Initialize`)
then calls `Initialize()`; declared inline.

Step: returns 1 if `data == NULL`; returns 0 if `pause`; else `Count(frames)`, then while
`event->delta <= wait` process event (status & 0xF0: E0 PitchBend(ch, data[1], data[0]) as u8;
C0 ProgChg(ch, data[0]); B0 CtrlChg(ch, data[0], data[1]) then loop marker check on CC 110;
80 NoteOff; 90 NoteOn). End: `status == 0 && !loop` -> Stop(), return 1.
Volume sent: `expression * vol(seq) * vol(track) / 16129` (0x3F01 = 127*127). Pitch sent:
`(bend_msb & 0x7F) * 128 + (bend_lsb & 0x7F)`; NoteOn passes `bend_lsb + bend_msb * 128` unmasked.
sndSePlayPBPrKr arg order: (port, bank, prog, key, velocity, vol, pan, pitch, se_id).
sndSeStopPBPrKr: (port, bank, prog, key, se_id). NoteOff uses track se_id; TrackNoteOff uses each
voice's prog/key/se_id and clears `active`.

## Enums (header)
`sndMIDI_STATUS` (0x80, 0x90, 0xB0, 0xC0, 0xD0, 0xE0, 0xFF) from LoadSMF/Step;
`sndMIDI_META` (0x2F) from LoadSMF; `sndMIDI_CTRL` (7, 10, 11, 110) from sndTrack::CtrlChg,
sndCSeSeq::CtrlChg and Step; `sndMIDI_LOOP` (0, 127) from Step. Enum names are not retail.

## Unresolved
- Retail names of the event and voice structs (named `sndSeSeqEvent`, `sndSeSeqVoice`).
- Meaning of `pause` (0x28) beyond Step's check.
- Whether `sndTrack::voice` was declared with size 1 or via a constant.
