# Floor-entry save flags and tournament unlocks

Research baseline: `162b3ca7`, branch `work/dc2-night-flags-r0`, pinned image
`chronicletwo_dev:sf-63f7a9e`. Retail executable:
`rom/pal/extracted/iso/SCES_511.90`, SHA-256
`41dec16868ec5ccc74f8927dad347a810828ae87ecd021ef7cc8a9568abb856c`.
Addresses below are retail virtual addresses unless explicitly called file offsets.

## Result and evidence limits

Two flags have provable feature purposes from the retail executable:
`0x158` unlocks Fishing Contest tournaments, and `0x1A8` unlocks Finny Frenzy
tournaments and the fish-race bonus. Their descriptive names are
`SAVE_FLAG_FISHING_CONTEST_UNLOCKED` and `SAVE_FLAG_FINNY_FRENZY_UNLOCKED`.
These names do not identify the story scenes that set them. The previous
`TOURNAMENT_STARTED` name confuses availability with `tour.now_event`, and
`TOURNAMENT_CYCLE` obscures the independently identified second tournament.
The ten-day schedule applies before either bit is read.

The other five flags remain raw: their particular story-event identities are
unproven. The individual setting/testing scripts for **all seven** flags also
remain unproven. This checkout's `rom/` supplies only the executable and
checksum files: no ISO, DATA.HD4, DATA.DAT, STB, TXT, MES, or dungeon CFG assets
are present. The repository's main checkout likewise supplies only the ELF.
Consequently there is no honest script filename/offset/opcode occurrence or
localized floor/event title to cite. No script data was inferred from numbers
or from remembered game story.

## Floor-entry consumers

`CMenuTreeMap::Step` starts at `0x001F14E0`, size `0x1828`. The seven calls
below test the destination floor only within the indicated zero-based dungeon.
A clear bit sets `jump_event = 1`; that path sets `skip_load_bgm = 1` and selects
the floor-entry event behavior. It does not establish which scene sets the bit.

| Save bit | Decimal | Dungeon | Floor ID | `CheckBitFlagMenu` call | Status |
|---|---:|---:|---:|---|---|
| `0x66` | 102 | 0 | 3 | `0x001F23B0` | Story identity unproven; kept raw. |
| `0xC9` | 201 | 0 | 8 | `0x001F23D8` | Story identity unproven; kept raw. |
| `0xD4` | 212 | 1 | 2 | `0x001F2428` | Story identity unproven; kept raw. |
| `0x133` | 307 | 2 | 2 | `0x001F2474` | Story identity unproven; kept raw. |
| `0x158` | 344 | 2 | 21 | `0x001F249C` | Fishing Contest availability proven. |
| `0x196` | 406 | 3 | 2 | `0x001F24EC` | Story identity unproven; kept raw. |
| `0x1A8` | 424 | 3 | 17 | `0x001F2514` | Finny Frenzy availability proven. |

Source: `ps2/src/dngmenu.cpp`, plain Step, around lines 3071–3104.
Assembly: `ps2/asm/pal/nonmatchings/dngmenu/Step__12CMenuTreeMapFv.s`.
The generated directory name is not the current source's guard status.
This lane cannot edit `dng_*`; the two now-supported substitutions are in
`.private/proposals/flags-r0-dngmenu.patch` for the owning lane.

## Tournament identity from retail text and code

Existing [savedata notes](notes.md) describe `CheckTourBoot`'s scheduler.
The following additional text linkage establishes the names of its types:

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

The ELF load segment maps file offset `0x80` to virtual `0x00100000`;
file offsets are not virtual addresses. The private standard-library helper
`.private/flags-r0/prove_topic_names.py` follows the ELF program headers and
table pointers, prints the raw strings and executable SHA-256, and produces
`.private/flags-r0/topic-names.json`:

```bash
readelf -sW rom/pal/extracted/iso/SCES_511.90 | rg 'topic_tbl|CheckEventDay__FPi|MakeMenuTopic__Fv|CheckTourBoot'
python3 .private/flags-r0/prove_topic_names.py > .private/flags-r0/topic-names.json
export CHRONICLETWO_IMAGE=chronicletwo_dev:sf-63f7a9e
H=/home/dylan/.t3/worktrees/dark-cloud-3/t3-cc986570/scripts/chronicle-two/container.sh
bash "$H" ./decompile.sh CheckEventDay__FPi
bash "$H" ./decompile.sh MakeMenuTopic__Fv
```

The m2c receipts are `m2c-CheckEventDay.txt` and `m2c-MakeMenuTopic.txt` in
`.private/flags-r0/`. Already documented/matched bodies were not redrafted.

## Other game-code uses

All listed bodies are plain unless explicitly marked guarded. Assembly paths
are under `ps2/asm/pal/`; each file is named for the function's mangled symbol.

| Flag | Function and source | Retail start / API call | Observed purpose |
|---|---|---|---|
| `0x66` | **Guarded** `MenuMainInit`, `menumain.cpp:1024` | `0x00235060` / `0x002354E4` | Shows midnight while `0x68` and flag 4 are clear; flag `0x67` subsequently overrides the display to 01:00. |
| `0x158` | `CSaveData::CheckTourBoot`, `savedata.cpp:261` | `0x002FB960` / `0x002FBAF0` | Selects Fishing Contest before Finny Frenzy is unlocked. |
| `0x1A8` | Same, `savedata.cpp:254` | `0x002FB960` / `0x002FBAC4` | Enables the type-1/type-2 tournament alternation. |
| `0x158` | `CMemoryCardManager::LoadFromMc`, `memcard.cpp:1316` | `0x002F82D0` / `0x002F86D8` | Repairs a nonpositive tournament base day to 7 on load. |
| `0x1A8` | `CMemoryCardManager::SaveToMc`, `memcard.cpp:1019` | `0x002F7C50` / `0x002F7DC8` | Sets the fish-race bonus enable bit in the save header. |
| `0x1A8` | `GetItemCommandMsg`, `menusys.cpp:4288` | `0x0023EF60` / `0x0023F720` | Removes message/command `0x13B5` while clear (`:4615`); its localized command text is unavailable. |
| `0x158`, `0x1A8` | `MenuInternSelectKey`, `menumain.cpp:2362–2363` | `0x002386A0` / `0x00238B6C`, `0x00238B7C` | Debug Triangle sets both bits, then forces a type-1 tournament; this is not their normal story activation. |

The MenuMainInit assembly is under `nonmatchings/menumain`; the other bodies
in this table are under `matchings/<unit>`. Their source guard statuses were
checked separately. The existing debug names were the only source users of
the old `SAVE_FLAG_TOURNAMENT_STARTED` and `SAVE_FLAG_TOURNAMENT_CYCLE` names.

### Indirect table users

`manual_boot_event_no` (`menuop.cpp`, LOCAL `.data` `0x003597D0`) is an array
of 47 signed 16-bit flags including its sentinel. Index 34 uses `0x158` at
`+0x44` (`0x00359814`); indices 43/44/45 use `0x1A8` at `+0x56/+0x58/+0x5A`
(`0x00359826/28/2A`). These are manual-page availability flags. The page titles
and movies require external `manual1.pac`/message resources and cannot be
identified here. Its indirect callers are:

- Guarded `MenuManualInit`: start `0x002C4480`, flag check `0x002C4820`.
- Plain `CManualMenu::KeyStep`: start `0x002C5020`, check `0x002C51F0`,
  debug all-unlock setter `0x002C52E0`.

The table initializer is plain and uses the new flag names; the guarded body
is unchanged.

`scoop_table` (`inventmn.cpp`, LOCAL `.data` `0x00352DE0`) has stride `0x14`;
the save flag is its signed 16-bit field at `+2`. Flag `0xC9` gates scoop IDs
1007/1011/1012/1019/1022 in rows 7/10/11/17/19. Their flag-field table offsets
are `+0x8E/+0xCA/+0xDE/+0x156/+0x17E`, addresses
`0x00352E6E/0x00352EAA/0x00352EBE/0x00352F36/0x00352F5E`.
Plain `CScoopDataManager::KnowScoop` starts at `0x00200CE0` and checks each
row's flag at `0x00200D34`. Scoop names/descriptions need the external
`scoop.cfg` and message assets; these numeric scoop IDs do not establish a
story-event name. The table stays raw.

The private `prove_indirect_flags.py` reads these signed 16-bit entries from
the pinned ELF and verifies the flag/scoop pairs; its output is
`.private/flags-r0/indirect-flag-tables.txt`.

The source/API census considered both hexadecimal and decimal flag spellings,
enumerators, guarded bodies, and these indirect tables. Direct immediate API
calls were cross-checked against the retail assembly. A read-only check of the
reserved unit's generated `dng_main` assembly found save-bit constants
`0x3B`, `0x35`, `0x32`, and `0x34`, none of the seven investigated values.
Neither reserved source/header was changed. Private inventories are
`source-flag-api-census.txt`, `flag-number-census.txt`, `reserved-unit-asm-census.txt`,
and `rom-files.txt` under `.private/flags-r0/`. Unresolved dynamic script values
are not covered by this game-code census.

## Reproducible script investigation when assets are supplied

The private helper `.private/flags-r0/script-format/inspect_assets.py` reads
DATA.HD4/DATA.DAT, nested pack chains, and reachable SB2 instructions. Its
README records the loader, language and message rules. It never writes assets
or generated directories. It was checked against a synthetic index → DAT →
pack → SB2 setter; **no retail event stream was available to validate it**.
The current `available-assets.json` has no index or decoded asset entries.

```bash
python3 .private/flags-r0/script-format/inspect_assets.py rom/pal/extracted/iso \
  --out .private/flags-r0/script-format/available-assets.json
python3 .private/flags-r0/script-format/inspect_assets.py \
  --index /path/to/DATA.HD4 --data /path/to/DATA.DAT \
  --out .private/flags-r0/script-format/assets.json
python3 .private/flags-r0/script-format/inspect_assets.py /path/to/event_1.stb \
  --out .private/flags-r0/script-format/event.json
```

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
  m2c receipts for both handlers are under the helper directory.

The helper reports raw flag-valued pushes separately from provable contiguous
EXT argument blocks. A numeric push alone is not evidence of a save-bit use.
It follows static entries/calls/jumps but does not infer arbitrary variable
values or execute the VM; unresolved argument expressions require additional
control-flow/stack analysis.

For each actual occurrence, record the DATA.HD4 member, pack member if any,
script SHA-256, script-relative and code-relative offsets, opcode and arguments,
numbered program/function, and enclosing branch/skip structure. Then resolve
its messages before naming a story scene:

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

## Source scope and validation

The two header enumerators, plain `CheckTourBoot`, save/load callers, manual
initializer, item-command test, and debug setters use the feature names.
`GetItemCommandMsg`'s local `flag_1a8` is named `finny_frenzy_unlocked`.
All numeric values and types are preserved. No functions are promoted, no
compiler profiles are changed, and all guarded bodies stay unchanged.
The two raw dngmenu tests are reported as the private proposal above.

Validation receipts are under `.private/flags-r0/`: baseline and final
`*-build.log` (`SCES_511.90: OK`) and `*-objects.log` (149/149).
`object-hashes-before.json` and `object-hashes-after.json` record the compiled
object hashes; all 149 raw object hashes are unchanged.
`guard-and-reserved-check.json` compares every guarded block in
the edited units and the reserved/dng source files against the baseline.
The private helpers and proposals are deliberately not committed.
