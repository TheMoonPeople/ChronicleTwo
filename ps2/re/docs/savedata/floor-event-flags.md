# Floor-entry save flags and tournament unlocks

Addresses are retail virtual addresses unless explicitly called file offsets. The
executable SHA-256 is
`41dec16868ec5ccc74f8927dad347a810828ae87ecd021ef7cc8a9568abb856c`.

## Result and evidence limits

Two flags have provable feature purposes from the retail executable: `0x158` unlocks
Fishing Contest tournaments, and `0x1A8` unlocks Finny Frenzy tournaments and the
fish-race bonus. Their descriptive names are `SAVE_FLAG_FISHING_CONTEST_UNLOCKED` and
`SAVE_FLAG_FINNY_FRENZY_UNLOCKED`. These names do not identify the story scenes that set
them. The previous `TOURNAMENT_STARTED` name confuses availability with
`tour.now_event`, and `TOURNAMENT_CYCLE` obscures the independently identified second
tournament. The ten-day schedule applies before either bit is read.

The other five flags remain raw: their particular story-event identities are unproven.
The individual setting/testing scripts for **all seven** flags also remain unproven.
The evidence uses executable code and data. No retail event/message assets were
available to identify script filenames, setter opcodes or localized floor titles.

## Floor-entry consumers

`CMenuTreeMap::Step` starts at `0x001F14E0`, size `0x1828`. The seven calls below test
the destination floor only within the indicated zero-based dungeon. A clear bit sets
`jump_event = 1`; that path sets `skip_load_bgm = 1` and selects the floor-entry event
behavior. It does not establish which scene sets the bit.

| Save bit | Decimal | Dungeon | Floor ID | `CheckBitFlagMenu` call | Status |
|---|---:|---:|---:|---|---|
| `0x66` | 102 | 0 | 3 | `0x001F23B0` | Story identity unproven; kept raw. |
| `0xC9` | 201 | 0 | 8 | `0x001F23D8` | Story identity unproven; kept raw. |
| `0xD4` | 212 | 1 | 2 | `0x001F2428` | Story identity unproven; kept raw. |
| `0x133` | 307 | 2 | 2 | `0x001F2474` | Story identity unproven; kept raw. |
| `0x158` | 344 | 2 | 21 | `0x001F249C` | Fishing Contest availability proven. |
| `0x196` | 406 | 3 | 2 | `0x001F24EC` | Story identity unproven; kept raw. |
| `0x1A8` | 424 | 3 | 17 | `0x001F2514` | Finny Frenzy availability proven. |

The owning source is `ps2/src/dngmenu.cpp`. Both tournament tests use the feature
enumerators; the five unresolved story flags remain numeric.

## Tournament identity from retail text and code

Existing [savedata notes](notes.md) describe `CheckTourBoot`'s scheduler. The following
additional text linkage establishes the names of its types:

1. `CheckTourBoot__9CSaveDataFi` (`0x002FB960`, size `0x220`) reads `0x1A8`
   at call `0x002FBAC4` and `0x158` at call `0x002FBAF0`.
   With `0x1A8` clear, the next type is 1 if `0x158` is set, otherwise 0.
   With `0x1A8` set, `type + 1` wraps from 3 to 1, alternating types 1 and 2.
   Type 1 resets `user_data.fish_tournament`; type 2 clears aquarium fatigue.
2. `CheckEventDay__FPi` (`0x00236F00`, size `0x138`) returns 1 for active
   tournament type 1 and 2 for active type 2. Inactive/out-of-window cases
   return 0. The remaining-hours calculation does not change the type.
3. `MakeMenuTopic__Fv` (`0x00237040`, size `0xA0`) indexes
   `topic_tbl$1777[LanguageCode][CheckEventDay(...)]` to format the ticker.
   The table is LOCAL `.data`, `0x003550E0`, size `0x54`, seven rows of three
   32-bit string pointers.
4. English row 1's type-1 pointer at `0x003550F0` points to `0x0036FD30`
   (ELF file offset `0x0026FDB0`): `Fishing Contest: %d hr(s). to go`.
   Its type-2 pointer at `0x003550F4` points to `0x0036FD60`
   (file offset `0x0026FDE0`): `Finny Frenzy: %d hr(s). to go`.
   French, German, Italian and Spanish table rows retain the same type split.
5. Independently, `CMemoryCardManager::SaveToMc` tests `0x1A8` and sets the
   save-file bonus bit `0x01`, named `OMAKE_ENABLE_GYORACE` in `title.hpp`.
   Thus its purpose includes enabling the fish-race title-menu extra.

The ELF load segment maps file offset `0x80` to virtual `0x00100000`. File offsets and
virtual addresses must remain distinct when following table pointers to the strings
above.

## Other game-code uses

All listed bodies are native unless explicitly marked assembly-backed.

| Flag | Function and source | Retail start / API call | Observed purpose |
|---|---|---|---|
| `0x66` | **Assembly-backed** `MenuMainInit`, `menumain.cpp:1024` | `0x00235060` / `0x002354E4` | Shows midnight while `0x68` and flag 4 are clear; flag `0x67` subsequently overrides the display to 01:00. |
| `0x158` | `CSaveData::CheckTourBoot`, `savedata.cpp:261` | `0x002FB960` / `0x002FBAF0` | Selects Fishing Contest before Finny Frenzy is unlocked. |
| `0x1A8` | Same, `savedata.cpp:254` | `0x002FB960` / `0x002FBAC4` | Enables the type-1/type-2 tournament alternation. |
| `0x158` | `CMemoryCardManager::LoadFromMc`, `memcard.cpp:1316` | `0x002F82D0` / `0x002F86D8` | Repairs a nonpositive tournament base day to 7 on load. |
| `0x1A8` | `CMemoryCardManager::SaveToMc`, `memcard.cpp:1019` | `0x002F7C50` / `0x002F7DC8` | Sets the fish-race bonus enable bit in the save header. |
| `0x1A8` | `GetItemCommandMsg`, `menusys.cpp:4288` | `0x0023EF60` / `0x0023F720` | Removes message/command `0x13B5` while clear (`:4615`); its localized command text is unavailable. |
| `0x158`, `0x1A8` | `MenuInternSelectKey`, `menumain.cpp:2362–2363` | `0x002386A0` / `0x00238B6C`, `0x00238B7C` | Debug Triangle sets both bits, then forces a type-1 tournament; this is not their normal story activation. |

### Indirect table users

`manual_boot_event_no` (`menuop.cpp`, LOCAL `.data` `0x003597D0`) is an array of 47
signed 16-bit flags including its sentinel. Index 34 uses `0x158` at `+0x44`
(`0x00359814`); indices 43/44/45 use `0x1A8` at `+0x56/+0x58/+0x5A`
(`0x00359826/28/2A`). These are manual-page availability flags. The page titles and
movies require external `manual1.pac`/message resources and cannot be identified here.
Its indirect callers are:

- `MenuManualInit`: start `0x002C4480`, flag check `0x002C4820`.
- `CManualMenu::KeyStep`: start `0x002C5020`, check `0x002C51F0`,
  debug all-unlock setter `0x002C52E0`.

The table and both callers are native; the table uses the feature flag names.

`scoop_table` (`inventmn.cpp`, LOCAL `.data` `0x00352DE0`) has stride `0x14`; the save
flag is its signed 16-bit field at `+2`. Flag `0xC9` gates scoop IDs
1007/1011/1012/1019/1022 in rows 7/10/11/17/19. Their flag-field table offsets are
`+0x8E/+0xCA/+0xDE/+0x156/+0x17E`, addresses
`0x00352E6E/0x00352EAA/0x00352EBE/0x00352F36/0x00352F5E`. Plain
`CScoopDataManager::KnowScoop` starts at `0x00200CE0` and checks each row's flag at
`0x00200D34`. Scoop names/descriptions need the external `scoop.cfg` and message assets;
these numeric scoop IDs do not establish a story-event name. The table stays raw.

## Event-script evidence requirements

The story setters and localized event identities require retail DATA.HD4, DATA.DAT and
event/message assets. Executable consumers establish feature availability but cannot
establish script filenames or event titles.

Documented disk formats, rather than byte-search guesses, control decoding:

- DATA.HD4 uses little-endian `{name_offset, size, sector}` records of 12
  bytes; first name offset / 12 gives the count. Names are HD4-relative and
  sectors are 2048-byte DATA.DAT-relative units (`dataread/notes.md`).
- Pack records have name at `+0`, data-relative offset at `+0x40`, byte size
  at `+0x44`, next-record-relative offset at `+0x48`; empty name terminates.
- SB2 header offsets `+4/+8/+0xC/+0x10/+0x18` describe main function,
  code section, program table, program count and globals. VM instructions
  are little-endian `{op,arg1,arg2}`, 12 bytes (`runscript/notes.md`).
- Opcode 3 with `arg1=1` pushes integer `arg2`. Opcode 21 (`EXT`) consumes
  `arg1` stack slots **including** the external command ID; the command ID
  is the first slot, not an instruction operand. No return value is pushed.
- Event external 13 (`_SET_FLAG`) accepts `(bit,value)` and calls the save
  setter; external 14 (`_GET_FLAG`) accepts `(bit,&destination)` and writes
  the save getter's result. These differ from event-local flags and counters.
  A direct set is `PUSH_INT 13; PUSH_INT <flag>; PUSH_INT 1; EXT 3`.

A numeric flag-valued push alone does not establish a save-bit use. Trace the EXT
command and argument stack through reachable code. Dynamic expressions need
control-flow/stack analysis rather than a byte search.

For each actual occurrence, record the DATA.HD4 member, pack member if any, script
SHA-256, script-relative and code-relative offsets, opcode and arguments, numbered
program/function, and enclosing branch/skip structure. Then resolve its messages before
naming a story scene:

- Event 228 (`_LOAD_MES`) loads a TXT filename for a window; 192 (`_MES_MAKE`)
  selects a numeric message ID or direct string. TXT lookup searches `@<id>`
  and returns text after the next LF. Language conversion replaces `_1.txt`
  and `_1.stb` for French/German/Italian/Spanish. English is language 1.
- Compiled MES files contain glyph/control indices, not UTF-16. Their text
  requires the matching `meswin/fonttbl_*.bin`; no glyph numbers are treated
  as Unicode without that table.
- `CDngFloorManager::LoadDataTable` requests `menu/dngmap/dmap%d.cfg` and
  `menu/dngmap/dflr%d.cfg` (zero-based dungeon), followed by
  `flrtitle%d.txt` via `LoadFileMenu`. Some older notes reverse `dmap`/`dflr`
  into `mapd`/`flrd`; the current loader's actual format strings are authoritative.
  English titles resolve to `menu/1/flrtitle%d.txt` through the language
  directory table. `RI_TITLE(floor_id,title)` supplies floor names. No entry-script field in
  `DNGMAP_ROOM_INFO` is proven; the optional RI string remains unknown.
