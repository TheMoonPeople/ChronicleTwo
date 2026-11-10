# SOUND.DAT and SOUND.HD3

SOUND.HD3 is the index and SOUND.DAT is the stream pack for the game's streamed voice clips. The PAL disc holds both in its root. This document covers the formats, the lookup path in the IOP driver, and how `tools/dc2data` handles them on PC.

## 1. Files

| File | Size | Role |
|---|---|---|
| `SOUND.HD3` | 86,848 bytes | Index: name, size and sector of each entry |
| `SOUND.DAT` | 969,644,032 bytes (473,459 sectors of 2,048 bytes) | Stream pack: the entries, back to back |

The pack holds 3,101 entries (3,100 distinct names). Every entry is a RIFF/WAVE file with PCM format tag 1, one channel, 48,000 Hz and 16 bits per sample. Durations run from 0.31 s to 17.16 s, about 10,031 s (2.8 h) in total.

The entries are not VAG. The plan expected interleaved VAG. WP5.4's stream channel therefore plays 16-bit PCM, mono or stereo as the `fmt ` chunk states, not VAG.

`DATA.HD3` (354,912 bytes) is a different file, the index for `DATA.DAT`. It is not covered here.

## 2. SOUND.HD3 layout

The file is a table of 16-byte records from offset 0, followed by a pool of NUL-terminated names. All fields are little-endian.

| Offset in record | Type | Field |
|---|---|---|
| 0x0 | u32 | `name_offset`: absolute offset of the name in SOUND.HD3 |
| 0x4 | u32 | `size`: bytes of the entry |
| 0x8 | u32 | `sector`: start of the entry, in 2,048-byte sectors from the start of SOUND.DAT |
| 0xC | u32 | `sectors`: `ceil(size / 2048)` |

The record count is the first record's `name_offset` divided by 16. On retail that is `0xC1E0 / 16 = 3,102`: 3,101 entries and a final terminator record. On retail the terminator's `name_offset` is `0x1533C`, which points at an empty string at the end of the name pool, and its `size`, `sector` and `sectors` are 0. The parser accepts as terminator a last record with `size`, `sector` and `sectors` 0 whose `name_offset` is 0 or points at an empty string; anything else is "no terminator".

Names are flat, seven digits plus `.wav`, for example `0010010.wav` and `8640040.wav`. Names contain no directory part. The driver rewrites `\` to `/` in the loaded table's names only; the requested name is compared as sent. Retail table names contain neither character, so the rewrite has no effect on retail.

Entries are contiguous in sector order from sector 0. The last entry ends exactly at the end of SOUND.DAT. The byte sizes sum to 966,486,464. The remaining 3,157,568 bytes are padding to sector boundaries.

One name is duplicated. `8640040.wav` appears twice, at sectors 473,291 and 473,375, 170,322 bytes each. Section 3 explains which copy is reachable.

## 3. Lookup (EzBGM driver behaviour)

The IOP driver `EZBGM.IRX` (version 1.2.1) loads SOUND.HD3 once, on the first open of a name without a device prefix. It relocates the name offsets when it loads the table.

| Open form | Behaviour |
|---|---|
| Name without `:` | Exact, case-sensitive search of the table. First match wins, so the second `8640040.wav` cannot be reached. |
| `cdrom0:` name | Opened as an ordinary disc file. The PAL disc has no `VOICE\` or `V\` directories, so the game's voice opens fail as they do on retail. |

The two failing paths are `CommandStreamOpen`'s `cdrom0:\VOICE\<name>.WV;1` and `CommandStreamOpenFromFPL`'s `cdrom0:\V\...\V<name>.VPK;1` (`event_func.cpp`, lines 13711-13734).

Names reaching the table are built in these places:

| Source | Format |
|---|---|
| `event_func.cpp`, `_STREAM_OPEN3` (about line 14613) | `%07d.wav` |
| `dng_object.cpp` (about lines 1971-1975) | `85200%d.wav`, `8520%d.wav` (robot voices) |
| `inventmn.cpp` (about line 3521) | `8500%s.wav` |
| `subgame.cpp` (about line 381) | `%d.wav` |
| `menucapt.cpp` (about lines 90-97) | literal table |

`CSound::StreamOpenFast` (`sound.cpp`, lines 927-933) sends these names to the driver with `EZBGM_OPEN` (0x8020).

## 4. Stream header

Each entry is parsed as RIFF: the `RIFF` tag, a size, the `WAVE` tag, then chunks walked by their size fields. The driver does not apply RIFF's odd-size padding. No retail chunk before `data` has an odd size.

The driver requires `fmt ` before `data`. It reads the channel count from `fmt `: 2 selects stereo, anything else selects mono. It then plays the `data` chunk.

Only PCM is supported. The sample rate field is not used. The SPU2 runs at 48 kHz, which every entry holds.

Chunk orders on retail:

| Entries | Layout |
|---|---|
| 3,025 | `bext`, `fmt `, `minf`, `elmo`, `data`, `regn`, `ovwf`, `umid` (Broadcast WAV from the authoring tool). `data` starts at offset 1,024. |
| 67 | `fmt `, `data`, `LIST` |
| 6 | `fmt `, `data` |
| 3 | Other, with `fmt ` and `data` first. `data` starts at offset 44. |

No `smpl` or `cue ` chunk exists, so the files carry no loop points.

## 5. Looping and state

Looping is a driver mode, not file data. When the channel's mode word has a loop bit set (`mode & 0xFFFF000F`), the driver seeks the entry back to its first byte at end of data and keeps streaming. Otherwise it stops the channel and sets state bit `0x8000` (`SND_STREAM_STATE_END` in `snd_mngr.hpp`). Bit `0x1000` means playing.

Whether the restart re-reads the header bytes as samples is not established. The PC player loops from the start of the `data` chunk.

`StreamStandBy` (`sound.cpp`, lines 984-998) reads the stereo flag from command `0x80D0` bit 0. It then configures:

| Mode | Commands |
|---|---|
| Mono | `0x8000` with argument `0x3000`; `0x80C0` with argument `0x10` |
| Stereo | `0x8000` with argument `0x4000`; `0x80C0` with argument `0` |

No game path sets a loop bit for SOUND.DAT voice clips. None was found in `sound.cpp`.

## 6. PC handling

`tools/dc2data` extracts each first-match entry to `data/sound/<name>`. Names are folded the same way as the rest of `data/`.

It also keeps whole copies, `data/sound/sound.dat` and `data/sound/sound.hd3`, until Wave 3 confirms playback. It records the shadowed duplicate without writing it.

`dc2data sound <iso-or-directory>` lists every entry with its name, size, sector and sector count, then the shadowed duplicate, then a total line. On retail the total line reads:

```
sound: 3100 entries, 1 shadowed, 966486464 bytes, 969644032 bytes in sectors, SOUND.DAT 969644032 bytes
```

A malformed SOUND.HD3 makes both `dc2data sound` and `extract` fail, and `extract` writes nothing.

The parser rejects a SOUND.HD3 when any of these hold:

- The first name offset is zero, is not a multiple of 16, or is past the end of the file.
- The table has no terminator, as defined in section 2.
- An empty record appears before the terminator.
- A name offset lies outside the name pool, or a name is unterminated.
- A name is empty or contains `/` or `\`.
- `sectors` is not `ceil(size / 2048)`.
- An entry extends past the end of SOUND.DAT.

## 7. Open questions

- Whether a looped restart is audible as header noise on hardware.
- The meaning of the `0x8000` and `0x80C0` argument values beyond mono and stereo.
- Command `0x8A00`.
