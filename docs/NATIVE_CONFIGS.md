# Native configuration documents

`dc2data gameplay <iso-or-directory> port/gameplay` uses `tools/kazarov/src/rust/configs.rs` to refresh standalone CFG scripts as `.cfg.json` and MAP scripts as `.map.json` in the tracked gameplay folder (for example `menu/cfg7/wepdat.cfg.json`, `map/s/s01/s01.map.json`). PACK names stay directory components; distinct suffixes keep scripts that share a stem with each other or with a texture document apart, and an output collision fails conversion before anything is overwritten. The build packages compact copies under `gameplay/` in a seed `data.zip` beside the executable; only document paths and hashes are compiled. Normal extraction validates and copies those documents into the same `gameplay/` paths in the completed `data.zip` and omits substituted CFG/MAP payloads. Tracked gameplay JSON remains pretty-printed. No runtime catalog is published.

After extraction completes, `dc2data gameplay-audit <iso-or-directory> port/gameplay` compares the tracked documents with their retail sources. Character profiles and audio gameplay settings use separate documents in the same archive namespace, described in [PORT_CONFIG_FORMAT.md](PORT_CONFIG_FORMAT.md).

Each document is a **native semantic document**: a JSON object with `"schema_version": 2`, a `"kind"` naming its family, and typed, named fields. It never contains a command list. The port parses each kind into typed C++ structures and fills the game's structures with the effects the retail tag callbacks had; the configuration command replay (`RunNativeConfig`, typed `SPI_STACK` sessions inside `CScriptInterpreter`) no longer exists.

## How the converter builds a document

`configs.rs` tokenizes a script exactly as the retail text interpreter does (comment removal, quotes, Shift-JIS lead bytes, escaped quotes, numeric prefixes, invalid tokens, an incomplete final argument dropped) and migrates resource-bearing operands to their native file names (`.mds`→`.gltf`, `.img`→`.json`, `.pss`→`.mp4`, `CHARA` profile names). `configs_native.rs` then:

1. **Selects the family** from the script's path (`select`); a script no family claims fails conversion.
2. **Reduces the script to the values the retail callbacks read** (`effective`), once per tag table that reads it (a family has one `Pass` per table: `scene_map` is read by `mapinfo_tag` and `map_tag`, `scene_config` by `cfg_tag` and, on georama maps, `emap_tag`, `villager_schedule` by `gi_tag` and `ni_tag`). Each command declares the slots its callback reads, their types and the argument counts that guard them. Values are coerced as `spiGetStackInt/Float/String` do. Commands the table does not name are skipped without touching the stack, as the interpreter skips them. A callback that reads past its own arguments sees the slot the previous command left, as retail's stack does; such stale reads are reported (`gyop.cfg GRP`, `racefish*.cfg DAT`, `wmap.cfg`/`wdmap.cfg` `POS`, `item.cfg NUMBER1`, `GET_N_ITEM`, `npc_place.cfg`), and a stale *string* is refused because retail reuses its storage. Commands present in retail files that no consumer reads (typos such as `FORM_PUXY`, `CURSOR_ONFF`, `ET_N_ITEM`; `PCP_NAME`; the dungeon presets and villager rows left in some map configurations) are listed per family and dropped; an unlisted unknown command fails conversion.
3. **Builds the document** from those values (`build`). A value is stored as the callback reads it; what the callback computes from it (degrees to radians, colour scaling, the PAL 1.15 stretch, `ConvertFontCode`, flag lookups, random picks, defaults for missing operands) stays in the C++ loader. An operand the script left out is an absent key. Floats are written with the shortest decimal that reads back as the same `f32`. Strings are readable UTF-8 decoded from CP932; a string CP932 cannot reproduce is `{"text": ..., "game_bytes": "<hex>"}`; a missing or non-string operand the callback reads as a string is `null`. Builders assert the shapes the retail corpus has (block nesting, order inside blocks) and fail on anything else rather than inventing semantics.
4. **Proves the document** (`flatten`): the document is turned back into the values of step 2, and conversion fails unless they are identical. Families whose tables do not interact (shops, skies, dungeon floor details, villager places) compare the rows of each command in order; `scene_map` and `scene_config` first sort independent tables apart (texture packs before model packs, directional before point lights, water before event points, ...). Every published document therefore carries all the semantics of the script it replaces. `retail_cfg_family_report` (ignored test; `KZ_CFG_RAW=<raw tree>`, optionally `KZ_CFG_CACHE`, `KZ_CFG_FILTER`) runs this over the whole PAL corpus: 1,058 scripts, 1,052 documents of 37 kinds plus 6 unused scripts, zero failures.

BIN (`"BIN"`-prefixed) configuration scripts have no named commands; none survive in PAL, and the converter refuses one. Character profiles, cloth and effect scripts inside characters go to the character's `.game.json` (see below); sound CFG/VOL files belong to the audio converter; IMG texture-animation scripts belong to the texture converter.

`UNUSED_RETAIL` lists scripts no game code reads; they are removed from `/data` and nothing is published: `edit.cfg`, `sg/omake0.cfg`, `sg/omake1.cfg`, `sg/fish/fish.cfg`, `menu/cfg5|6|7/commentmes.cfg`, `map/map.cfg`. Unread duplicates that do have a family (`menu/cfg5`, `menu/cfg6`, `npc_place{,2,3}.cfg`, `sg/gyo/racefish*.cfg`, the `menu/<n>/dmap?.pac/dmap?.cfg`, `wmap?.pac/wmap.cfg` and `trushsel.pac/trush.cfg` copies, `menu/<n>/scoop.cfg`) are converted with that family.

## How the port reads a document

`port/src/platform/native_config.hpp` reads documents through datapack priority: `Read<T>(relative, kind, parse)`, `ReadGame<T>(game_path, ...)` (current-directory rules and `host:` save-directory files) and `ReadBuffer<T>(buffer, ...)` (the file a retail `LoadFile2`/`GetPackFile` buffer was read from). Each candidate, highest priority first, must have `schema_version` 2 and the requested `kind`, and its typed parse must succeed; otherwise one `config: <path>: <reason>` diagnostic is printed and the next candidate is tried. A command-list document from an older converter is refused this way. Parsed JSON is cached per datapack entry. Paths cannot leave the converted-data root.

Each family's loader replaces the retail loader with `PORT_OVERRIDE` in the `port/src` file mirroring its unit, or, where the retail loader does other work around its script run, `scripts/port/unit_copy.py`'s `CONFIG_SEAMS` replaces only the interpreter run in the unit's native copy with a call to the port (`CMapSky`'s `LoadSkyPack`, `CEditMap::LoadEditInfo`, `CDynamicAnime::Load`). File statics the loaders need are given link names by `port/include/stubs/<unit>.hpp`; record types local to a unit are reached from `port/src/<unit>_config_bridge.inc`, which `unit_copy.py` appends to the unit's copy. The loaders reproduce retail's allocations (same memory, same block counts), cursors, "current entry" state and quirks, and skip entries where retail would write out of range.

Text scripts that are not configurations keep the retail interpreter: inventory `.lst` tables, `neta2.lst`, `map/map.lst`, georama `.gpi` files, dungeon `flrtitle<n>.txt`, `.em` map effects, `event/view_pal.txt` and event `.stb` scripts.

**Character resources.** The cloth (`dynmc_tag`) and effect (`effm_tag`) scripts that a character's `.game.json` embeds stay ordered typed command lists, run by `port/src/command_replay.cpp` through those scripts' retail tag tables (with retail's slot inheritance and the script guards). They are part of the character model format, produced by the model converter, not configuration documents; making them semantic is a separate change to the model format.

## Families

| kind | retail files | consumer (port override) | converter |
|---|---|---|---|
| `scene_map` | `map/**/<map>.map` | `CMapInfo::LoadMapInfo`, `AddMapInfo` (`port/src/mapinfo.cpp`), `CMap::LoadMapFile` (`port/src/mapload.cpp`) | `map.rs` |
| `model_list` | `**/*.pcp/info.cfg` | `CMdsList::LoadPCPFile` (`port/src/mdslist.cpp`) | `map.rs` |
| `sky` | `**/*.sky/info.cfg`, `*.skyb/info.cfg`, `map/s/s55/s55/info.cfg` | `LoadSkyPack` seam (`port/src/mapsky.cpp`) | `map.rs` |
| `scene_config` | `map/**/<map>.cfg` | `CMap::LoadCfgFile` (`port/src/mapload.cpp`), `CEditMap::LoadEditInfo` seam (`port/src/editmap.cpp`) | `scene.rs` |
| `dungeon_rooms`, `monster_floors`, `treasure_boxes`, `monster_names`, `dungeon_map`, `dungeon_floors` | `dungeon/cfg_file/*`, `menu/dngmap/*` | `automap.cpp`, `dng_event.cpp`, `monster.cpp`, `dngfloor.cpp` | `dungeon.rs` |
| `party_characters`, `villager_places`, `villager_schedule` | `npc?.cfg`, `place.cfg`, `npc_place*.cfg` | `npccfg.cpp`, `vlgr_info.cpp` | `villagers.rs` |
| `game_setup`, `map_names`, `movie_list` | `game.cfg`, `dbg/*`, `map/map?.cfg`, `mv.cfg` | `config_loaders.cpp`, `mapselect.cpp`, `movieviewlp.cpp` | `game.rs` |
| `item_common`, `weapons`, `items`, `attachments`, `ridepod_parts`, `fish`, `guards`, `item_messages` | `menu/cfg5|6|7/*` | `gamedata.cpp` | `items.rs` |
| `menu_layout`, `menu_commands` | `menu/<n>/*.pac/*.cfg` | `MenuDataAnalyze`, `MenuCommandAnalyze` (`menucommon.cpp`) | `menu.rs` |
| `shop_lists`, `quests`, `world_map`, `scoop_texts`, `fish_prizes`, `fishing_places`, `race_fish`, `debug_race_fish`, `georama_analysis` | see below | `menushop.cpp`, `quest.cpp`, `menumap.cpp`, `inventmn.cpp`, `menuaqua.cpp`, `fishing.cpp`, `editdebug.cpp`, `editdata.cpp` | `records.rs` |
| `movie_subtitles` | `menu/<1..5>/help.cfg` | `platform/subtitle_config.cpp` | `configs.rs` |

## Scene maps (`scene_map`)

`{"schema_version":2,"kind":"scene_map","info":{...},"parts":[...],"placements":[...],"cameras":{...}?,"func_points":[...]?}`. The retail map script is read twice from the same bytes: `CMapInfo::LoadMapInfo` (and `AddMapInfo` for an add-map) runs `mapinfo_tag` over it, and `CMap::LoadMapFile` later runs `map_tag` over the copy the map info keeps; both loaders read their sections of the same document. All 210 PAL maps have the order info, part definitions, placements, cameras, map function points, which the loader follows.

`info`: `texture_packs` and `model_packs` (IMG and PCP names in order; an add-map puts each in the first free of 16 entries), `active_light_set`, `light_sets` (`index`; `fov: true` when FOV appears, setting the 52-degree projection from the screen width; `bg_color`, `bg_color2` (black takes `bg_color`), `ambient`; `lights` `{index, direction?, color?}` (a light without a direction is ignored, as with fewer than four operands; directions are normalised at load); `point_lights` `{index, power, position, color}`; `fog_enable`; `fog` `{near, far, color?, far_value?, near_value?}` (white, 0 and 255 when absent)), `floor`, `chara_pos`, `def_foot`, `time` `{enable, blend, fixed_time?, fixed_time_enable?}`, `time_light_num`, `time_cfade`, `sky` `{info, height, sun_angle_degrees?}` (radians at load), `lens_flare`, `all_scissor`, `chara_light_adjust` `{mode, value}`.

`parts[]` (PARTS blocks, the part definitions): `name`, `far_clip` `{distance, fade}`, `light_flag` `{no_light, no_plight}`, `move_flag` `[4]` (wall bits), `pieces[]`, `func_points[]`. A piece: `model` (the model file, also its first name), `show`, `name` (PIECE_NAME), `position`, `rotation`, `scale`, `materials` `{count, entries:[{frame, material_no, color[4], color_no}]}`, `collision` `{type, param?}`, `time` `[start, end]`. Level-of-detail commands do not occur in PAL and are refused.

`placements[]` (MAP_PARTS blocks): `name`, `show`, `far_clip` (applied when the distance is positive), `definition` (PARTS_NAME), `group` (PARTS_GROUP), `position`, `rotation`, `scale` (scale 1 when absent).

`cameras` (CAMERA_INFO; ignored for an add-map): `count` (table size), `cameras[]` `{position?, positions:[{index, position}], draw_groups:[{index, group, unk_4}], rects:[{shape, min, max, position?, rotation?, scale?}]}`; only a `"box"` rectangle gets a collision.

A function point (`func_points[]` of a part or of the map): `type` (`effect`, `fire`, `flare`, `plight`, `anime`, `invent`, `event`, `sound`, `pos`; another word creates nothing), `enable`, `name`, `flag` `{flag_no, unk_8, start, end}`, and the data rows as the script gives them: `fire` `{red, green, blue, effect, heat_haze?, cast_light?}` (black takes the default fire colour, otherwise ×128; `effect` 0 sets `effect_off`), `plight` `{power, red, green, blue, light_type, light_chara?, unk_40?, unk_44?, no_map_light?, flicker_type?, flicker_depth?, flicker_period?}` (colour halved, range from power and colour at load), `anime` `{parts_name, piece_name, frame_name, kind, mode, param_x.., speed_x.., end_x.., uniform?, piece_space?}`, `invent` `{neta_no, min_x.., max_x.., unk_24, range, angle_degrees}`, `event` `{kind, event_no, point_no, arg1, arg2, arg3, target?, action?, item?, unk_100?}` (the kind word sets the door, ladder, box and book flags and forces `event_no` 1 for ladders and boxes), `sound` `{se_no, near_dist, far_dist, unk_2c, shape, start_x.., end_x..}`, `effect` `{name}` (an unknown effect makes the point `FUNC_POINT_NONE`), and `transform` `{position, rotation, scale}` (FUNC_POS: angles limited; event points get the ladder, box and default trigger scales and the door offset).

## Scene configurations (`scene_config`)

`{"draw_off_rects":[{box:{min,max}, box2:{min,max}}], "occlusion_planes":[[4 corners]], "water":{surface_count?, surfaces:[{vertex:{count_x, count_z, corner0, corner1}?, position?, param[4]?}], draw_count?, draws:[{surface, target, position?}]}, "event_points":[{type, name?, event:{point_no, mode?}?, transform?}], "georama":{...}?}`. Event points reserve 64 map function points on first use; only `type` `"event"` creates one, and the following rows of any other type change the previous point, as retail's stale current point does. `mode` (`every`, `action`, `check`, `item`, `invent`) sets the event flag and number; absent leaves them. A water draw `target` is a placed part name or `#followNNN`. `WATER_SHAKE` and `WATER_SURFACE_START` have no effect and are not stored.

`georama` (georama maps, `CEditMap::LoadEditInfo`): `fixed_parts` and `initial_parts` `{count, parts:[{id, position, angle}]}`, `river_parts` `[{index, parts, model}]`, `water_parts_models` `[model]`, `mask_parts` `[{index, model}]`.

## Model lists (`model_list`) and skies (`sky`)

`model_list`: `{"models":[{model, type?, far_clip:{distance, fade}?}]}`; `type` keeps the script value (0 model, 1 collision, 2 camera collision, 3 and 4 character). A model past the pack's model count or naming a model already listed is skipped. The second MDS operand and `PCP_NAME` are read by no consumer.

`sky`: tables `images`, `suns` `[{band, file}]`, `models`, `back_models` `[{band, file, rotation_degrees}]`, `animations`, `back_animations` `[{band, frame, speed_degrees}]` (at most 16 each) and `backgrounds` `[{file}]`. Bands outside 0-3 are ignored; names hold 31 bytes; degrees become radians at load as retail computes them.

## Small record tables

| kind | files | body | loader rules |
|---|---|---|---|
| `shop_lists` | `menu/shoplst?.cfg`, `menu/shopusa?.cfg` (and the unread `shop.pac/shoplst.cfg`) | `shops:[{id, items[]}]`, `prices:[{item, buy, sell}]` | the shop being opened takes the last entry with its id (0x17/0x1C pay in ABS, 0x20 medals, 0x21 Donny); at most 64 goods; prices outside 0..0x1FF are skipped |
| `quests` | `menu/<n>/quest.pac/quest?.cfg` | `count`, `quests:[{id, name, comment?, reactions[]}]` | `count` records allocated; texts must fit the record |
| `world_map` | `menu/<n>/wldmap.cfg` (and unread `wmap.cfg`, `wdmap.cfg`) | `positions_capacity`, `positions:[{index, map, loop, area, dungeon, floor, flag, type}]`, `areas_capacity`, `areas:[{area, map, x, y, name_x, name_y, name_side, title}]` | names from the map title and `ConvertFontCode`; flags open places; `y` and `name_y` ×1.15 |
| `scoop_texts` | `scoop.pac/scoop.cfg` (and unread `menu/<n>/scoop.cfg`) | `entries:[{id, text}]` | |
| `fish_prizes` | `gyop.cfg`, `uofp.cfg` | `count`, `groups:[{prize_count, rates[8], prizes:[{rate, ranks:[[item, num]×3]}]}]` | `gyop.cfg`'s `GRP` rows have four rates and retail reads the other four from the previous `PRIZE` row; the document stores the values read |
| `fishing_places` | `sg/fish/fishing.cfg` | `count`, `maps:[{map, exclusive?, place:{area_type, name, params[5]}?, fish:[{fish, rate, wait_bias}]}]` | at most 8 fish per place |
| `race_fish` | `sg/gyo/rfd?.cfg` (and unread `racefish*.cfg`) | `classes:[{class, count, fish:[{id, name, kind, battle, boost, endurance, tenacity, stamina, size}]}]` | |
| `debug_race_fish` | `host:gyorace.cfg` (data copy `gyorace.cfg`) | `fish:[{name, item, color, kind, tactics, battle, stamina, boost, endurance, tenacity}]` | |
| `georama_analysis` | `geo?.cfg` | `sources:[{id, conditions:[{index, name, geo_floor?}], entries:[{index, unk_10, message, geo_floor?, condition_numbers?, on_parts?, off_parts?, percent?}]}]` | a list of 8 or more condition numbers is ignored |

## Movie subtitles (`movie_subtitles`)

The five `menu/<1..5>/help.cfg` files are caption scripts, not tag scripts. Their documents keep the `movie_subtitles` shape: `chapters` with an `id` and ordered `entries` of `start_seconds`, `clear_seconds` (doubles), `text` and optional `game_bytes`. Timing-only final slots become empty captions; literal `\n` becomes a line feed and trailing carriage returns stay, as `MyStrCpyLineFeed` does. `platform/subtitle_config.cpp` reads them and converts seconds to frames.

## Dungeon configuration families

Converter module: `tools/kazarov/src/rust/configs_native/dungeon.rs`. Every document is
`{"schema_version": 2, "kind": "<kind>", ...}`. Values are stored as the retail callbacks read them
(after int/float/string coercion); runtime transformations stay in the C++ loaders.

### `dungeon_rooms`

- Files: `dungeon/cfg_file/d??f??.cfg.json`, `dungeon/cfg_file/_d??f??.cfg.json`, `dungeon/cfg_file/mstage?.cfg.json` (24).
- Consumer: `PORT_OVERRIDE CAutoMapGen::SetupRoomInfo(char*,int,mgCMemory*)` in `port/src/automap.cpp`
  (retail tag table `tag`, automap.cpp; called from dng_event.cpp with the buffer `LoadFile` filled).
- Fields:
  - `cell_w`, `cell_d` (float, optional, together): `GRID_SIZE`; set `CAutoMapGen::cell_w/cell_d`. Absent (e.g. d02f01) leaves them unchanged.
  - `rooms[]`, in script order, one per `ROOM_ID … ROOM_END` block:
    - `id` (int): `ROOM_ID` → `AUTOMAP_ROOM_INFO::id`.
    - `w`, `h` (int): `ROOM_SIZE` → `w`, `h`; the loader allocates the cell table as retail does
      (`bytes = w*h*4`, `operator new[](bytes, mem->Alloc(blocks + 2))`).
    - `rate` (int): `ROOM_RATE`; `fixed` (int): `ROOM_FIXED`.
    - `table`: `h` rows (`RD`) of `w` cells, each `[part, attribute]` (stored as s16).
- Converter rules: the block order `ROOM_ID ROOM_SIZE ROOM_RATE ROOM_FIXED RD* ROOM_END` is required;
  `ROOM_SIZE` must have exactly 2 operands (retail ignores it otherwise), each `RD` row exactly `w*2`
  operands (retail ignores it otherwise), and the row count must equal `h`. Flattening restores the same
  command sequence (`ordered`).
- Loader rules: the preset table is allocated with `(sizeof(AUTOMAP_ROOM_INFO) * 64 + 15) / 16 + 2`
  blocks (retail's 0x62; larger on PC because of the pointer); all 64 entries start with `id = -1`,
  `fixed = 0`, `table = nullptr`; `room_info_num` counts the rooms. Bounds: rooms past 64 are dropped,
  a row of the wrong width is ignored (as `RD` ignores it), rows past `h` are dropped; `w`/`h` must be
  non-negative with `w*h <= 0x10000` or the document is rejected.
- Ignored commands: `VER` (no consumer). No stale reads.

### `monster_floors`

- Files: `dungeon/cfg_file/mos_place?.cfg.json` (7).
- Consumer: `PORT_OVERRIDE CreatMonsterFloorInfo(char*,int)` in `port/src/dng_event.cpp` (retail `tag2`;
  called from the port's `LoadMonsterFile()` with the `BuffReadData` buffer).
- Fields: `floors[]`, one per `FLS … FLE` block: `floor` (int, `FLS` operand 0) and `monsters[]` of
  `{monster_id, param}` (int; the `FL` pairs of the block, concatenated).
- Converter rules: `FLS`'s second operand (the floor's monster count) is read and discarded by retail and
  is not stored. `FL` rows must have an even operand count; the retail files write 8 pairs per row,
  so flattening re-splits the list into rows of 8 pairs (a file with another split fails conversion).
- Loader rules: only blocks whose `floor` equals `DngSaveDataDungeon->floor_id[stage_id]` apply; each
  such block resets `ActiveMonster->locate.num` to 0 (a later block for the same floor replaces an
  earlier one) and appends its monsters (stored as s16). Bound: at most `MONSTER_LOCATE_MAX` (32)
  entries; retail writes past the list.

### `treasure_boxes`

- Files: `dungeon/cfg_file/tbox_d0?.cfg.json` (8).
- Consumer: `PORT_OVERRIDE CreatTresuarBoxInfo(TRESURE_BOX_FLOOR_INFO*,char*,int)` in
  `port/src/dng_event.cpp` (retail `tag__5`; called from dng_event.cpp and dngmenu.cpp with a
  `LoadFile`/`LoadFile2` buffer). Replaces the former port overrides of `_GROUP`, `_ITEM`, `_FLOOR`.
- Fields:
  - `groups[]`: `{group_id, item_num, items[]}`; `item_num` is the count the script states (stored as
    given, independent of `items`); `items[]` are `{item_no, rank, num}` (`ITEM` triples, concatenated).
  - `floor_start` (int): `FLOOR_START` operand 0 (operand 1 is never read).
  - `floors[]`: `{floor, group_id[]}`; the `FLOOR` count operand is the length of `group_id`.
- Converter rules: required shape `GROUP_START (GROUP ITEM*)* FLOOR_START FLOOR*`. `GROUP_START`'s
  operands are read and discarded (it only begins the group list). `ITEM` rows must hold whole triples;
  flattening re-splits items into rows of 5 triples (the retail line width). A `FLOOR` count that
  differs from its operand count fails conversion.
- Loader rules: resets `group_num = 0, floor_start = 0, rank_max = 0, rank_min = 100`; on a valid
  document sets `group_num = -1` (GROUP_START) and fills the groups, then `group_num += 1` as retail.
  Bounds (retail has none): at most 64 groups, `item_num` clamped to [0, 96], at most 96 items per group,
  floors outside [0, 128) skipped, at most 64 group ids per floor. Floors not listed keep their values.

### `monster_names`

- Files: `dungeon/cfg_file/mosdata?.cfg.json` (7).
- Consumer: `PORT_OVERRIDE LoadMonsterLanguage(int)` in `port/src/monster.cpp` (reads
  `dungeon/cfg_file/mosdata<language>.cfg.json` by name; retail `mos_data_anlyze_tag`).
- Fields: `names[]` of `{id, name}`; `name` is game text (null for an unreadable operand).
- Loader rules: `GetMonsterTable(id)` must exist; the name is run through `ConvertFontCode` when
  `LanguageCode` is French..Spanish (2..5), else copied; it is stored only when it fits
  `BASE_MONSTER_TBL::name` (31 characters). A name of 0x80 bytes or more rejects the document (retail's
  conversion buffer); a null name is skipped (retail would dereference it).

### `dungeon_map`

- Files: `menu/dngmap/dmap?.cfg.json` (7), read by `CDngFloorManager::LoadDataTable`;
  `menu/<lang>/dmap?.pac/dmap?.cfg.json` (42), byte-identical copies inside the tree-map menu packs that
  no game code reads (dngmenu only takes `dtmap_com.cfg`, `dmap?.img`, `systree.mes` from the pack).
- Consumer: `PORT_OVERRIDE CDngFloorManager::LoadDataTable(int,mgCMemory*)` and `AnalyzeFile(char*,int,mgCMemory*)`
  in `port/src/dngfloor.cpp` (retail `tree_map_tag`).
- Fields:
  - `glid_w`, `glid_h` (int): `TREE_INFO` operands 0-1 → `glid_w`, `glid_h`; operand 2 (cell count) is
    the length of `cells` (a mismatch fails conversion).
  - `cells[]` (`GI`): `type`, `x`, `y`, `unk_6`, `unk_8` (int → `GLID_INFO`), and at most one of
    - `root` (`RT`): `{type, shape, show_mark}` → `DNGMAP_ROOT_INFO`;
    - `room` (`RI` and the room tags after it): `floor_id`, `order` (`RI` 0-1); `unused` (`RI` operand
      2, read and discarded by retail; present only when non-zero); `name` (`RI` operand 3, when given;
      copied with `mgCopyString` into `DNGMAP_ROOM_INFO::unk_0`); `link` (`RI_LINK`, all operands);
      `tex_no` (`RI_TEX`); `key_room` (`RI_KEYROOM`, 4 ints); `options` (one string per `RI_OP`).
- Converter rules: tags must follow `TREE_INFO (GI [RT | RI [RI_LINK] [RI_TEX] [RI_KEYROOM] RI_OP*])*`;
  `RI_OP` must have exactly one operand (with more, retail reads the room offset from stale slots past
  its operands; the corpus never does). `RF_INFO*`/`RI_TITLE` in a map file fail conversion.
- Loader rules (per cell, in order): `GI` resets `link_glid`, `blink`, and zeroes `room`/`root`; `RI`
  sets `selectable = visited = 0`, `flag = DNGMAP_ROOM_FLAG_ROOM`, offsets 0, `practice_type = -1`,
  `mark_phase = 0`, `unk_4c = 0`. `link` keeps at most the four `DNGMAP_ROOM_INFO::link` entries (the
  `_ROOM_LINK` port guard). A negative `tex_no` picks `GetRandI(4) + offsetTable_911[-tex_no - 1]` at
  load (groups above 5 use the last group). Each option ORs `ROOM | flag(name)` into `flag`, where an
  unknown or null name gives -1 (all bits, as retail's lookup returns); after each option a sub or boss
  room gets offset (0, -0x1A). The grid is allocated as retail (`count * sizeof(GLID_INFO)` bytes,
  `Alloc(blocks + 2)`), inside `Align64` … `Align64`, `RelationGlid()` as `AnalyzeFile` wraps it.
  At most 0x10000 cells.

### `dungeon_floors`

- Files: `menu/dngmap/dflr?.cfg.json` (7).
- Consumer: same as `dungeon_map` (applied after the map, so floor lookups find the rooms).
- Fields: `floors[]` of `{floor, info?, practice?}`:
  - `info` (`RF_INFO` operands 1-12): `geostone`, `fast_destroy_time`, `fishing`, `fishing_record`,
    `seal`, `spheda`, `spheda_prize_item[3]`, `spheda_prize_num[3]` (retail interleaves item/num).
  - `practice` (`RF_INFO2` operands 1-2): `{type, param}` → `practice_type`, `practice_param`.
- Converter rules: `RF_INFO` and `RF_INFO2` of one floor merge into one entry; a floor with two rows of
  the same tag fails conversion; rows are compared grouped by tag (`ordered: false`; the two tags write
  disjoint fields).
- Loader rules: a floor that `GetDngMapFloorInfo` does not find is skipped (as retail returns 0). Values
  are stored with the field types' truncation.

### `flrtitle<n>.txt`

Not a CFG and not converted: `LoadDataTable` still reads it into a 0xA000 scratch with `LoadFileMenu`
and `AnalyzeFile` runs it through `CScriptInterpreter` with retail's `tree_map_tag` (only `RI_TITLE`
occurs), exposed with `tree_dngmap`, `tree_spi_stack` and `offsetTable_911` by
`port/include/stubs/dngfloor.hpp`. `AnalyzeFile` takes the native path only for a buffer whose source
is a `.json` `dmap*`/`dflr*` file.

### Corpus results

All aliases convert with zero failures and no stale reads: dungeon_rooms 24, monster_floors 7,
treasure_boxes 8, monster_names 7, dungeon_map 49 (7 + 42 pack copies), dungeon_floors 7; dropped
`VER` ×24.

## Party characters and villagers

Converter module: `tools/kazarov/src/rust/configs_native/villagers.rs`. Runtime: `port/src/npccfg.cpp`
(`LoadNPCCfg` override) and `port/src/vlgr_info.cpp` (`LoadGameInfo` override), with the unit statics exposed by
`port/include/stubs/npccfg.hpp` and `port/include/stubs/vlgr_info.hpp`. The `npccfg_config_bridge.inc` and
`vlgr_info_config_bridge.inc` bridges are no longer used.

All three families claim top-level scripts only (an alias without a directory).

### `party_characters`

Files: `npc.cfg.json` (no reader) and `npc0.cfg.json` … `npc6.cfg.json`. `LoadNPCCfg` reads
`npc<LanguageCode>.cfg.json` (retail `npc_spitag`, `ps2/src/npccfg.cpp`).

```json
{"schema_version": 2, "kind": "party_characters",
 "characters": [{"id": 7, "name": "First", "model": "p01_03a", "unk_31": 3, "ability_num": 2,
                 "max_npc_point": 25, "ability_cost": [1, 2, 3, 4], "debug_flag": 1}]}
```

| Field | Type | Meaning |
|---|---|---|
| `characters[]` | array | One `NPC_INFO` row each, in script order; the n-th record fills table entry n. |
| `id` | int | `NPC_BASE_DATA::chara_no` (stored as `s16`). |
| `name` | text or null | Display name. Null leaves the entry's name unchanged. |
| `model` | text or null | Model base name. Null leaves the entry's model unchanged. |
| `unk_31`, `ability_num`, `max_npc_point`, `debug_flag` | int | Stored as `s8`. |
| `ability_cost` | 4 ints | Stored as `u8`. |

Rules:
- `NPC_NUM` has no effect (retail sets `NpcBaseDataTotalNum`, which `LoadNPCCfg` then overwrites with the number of
  records read), so it is not in the document.
- `NpcBaseDataTotalNum` becomes the number of records stored, 0 when no document can be read.
- The table holds 180 entries; retail writes past it for a longer list, the port stores the first 180.
- A name of 0x1C bytes or more, or a model of 0x10 bytes or more (after CP932 encoding), rejects the document:
  retail would overflow the field. Only `npc6.cfg` (Korean placeholder names written as `[Uxxxx]` text, a language
  the PAL game does not load) has such names; that document is rejected at runtime.
- No ignored commands, no stale reads.

### `villager_places`

File: `place.cfg.json`, read by `LoadGameInfo` (retail `LoadPlaceInfo`, tag table `tag`, `ps2/src/vlgr_info.cpp`).

```json
{"schema_version": 2, "kind": "villager_places", "place_count": 160,
 "places": [{"index": 0, "map": 101, "position": [1.25, 2.5, -3.0], "angle": 0.75,
             "talk_offset": [4.0, 5.0, 6.0], "motion": "sit", "move_motion": "run", "move_speed": 1.5,
             "shadow": 0,
             "route": [{"type": "move", "position": [7.0, 8.0, 9.0], "angle": 1.0},
                       {"type": "wait", "posture": "mtn", "time": 45, "motion": "stand"}]}]}
```

| Field | Type | Meaning |
|---|---|---|
| `place_count` | int | `NPC_PLACE_NUM`. When above zero, a new `CVillagerPlaceInfo[place_count]` table is allocated (`Alloc(blocks + 2)`) and becomes `PlaceInfo`/`PlaceInfoNum`; otherwise the previous table stays. |
| `places[]` | array | One `NPC_PLACE … NPC_PLACE_END` block each, in script order. A repeated `index` is another block applied to the same place (the corpus repeats place 73). |
| `index` | int | Place number. |
| `map` | int | `map_no`. Each block also resets `move_motion` to walk (1). |
| `position`, `angle` | 3 floats, float | `PLACE_POS`: `pos[0..2]` and `pos[3]`. Absent when the block has no `PLACE_POS`. |
| `talk_offset` | 3 floats | `TALK_OFFSET`. |
| `motion` | text or null | `MOTION`: only `"sit"` changes the place (`VLGR_MOTION_SIT`); other values and null have no effect. |
| `move_motion` | text or null | `MOVE_MOTION`: `vpiGetMotionID(name)`; null has no effect. |
| `move_speed` | float | `MOVE_SPEED`. |
| `shadow` | int | `SHADOW`: `no_shadow = shadow == 0`. |
| `route[]` | array | `MOVE_TO`/`WAIT` steps in order; each allocates a node (`CVillagerPlaceInfo::Add`, `Alloc(4)`) appended to the place's route. |
| `route[].type` | `"move"` / `"wait"` | Step kind (`VLGR_ROUTE_MOVE` / `VLGR_ROUTE_WAIT`). |
| move `position`, `angle` | 3 floats, float | Node `pos[0..2]`, `pos[3]`. |
| wait `posture` | text or null | `motion_end = posture == "mtn"`. |
| wait `time` | int | Frames to wait. |
| wait `motion` | text or null, optional | Present only when the `WAIT` row had a third argument; `vpiGetMotionID` (absent or null gives -1). |

Rules:
- The converter refuses settings outside a place block (retail ignores them), a block setting repeated within one
  block, a block without `NPC_PLACE_END`, and a missing or misplaced `NPC_PLACE_NUM`; the corpus has none.
- A block whose index is outside the current table is ignored by the port (retail writes out of range).
- The document is compared unordered by command (settings of one place are order-independent; the route keeps its order).
- No ignored commands, no stale reads.

### `villager_schedule`

Files: `npc_place4.cfg.json`, read by `LoadGameInfo`; `npc_place.cfg.json`, `npc_place2.cfg.json` and
`npc_place3.cfg.json` (no reader) use the same kind. Retail runs two passes over the same script: `gi_tag`
(`PROG_INFO`) then `LoadNPCInfo`'s `ni_tag`.

```json
{"schema_version": 2, "kind": "villager_schedule",
 "progress_info": [{"progress": 5, "chapter": 2, "section": 3, "order": 100, "name": "1章"}],
 "villagers": [{"id": 7, "progress": [{"progress": 5, "duplicate_id": 0, "condition": "以後",
                                       "noon_place": 0, "night_place": 1}]}],
 "villager_info": {"count": 177,
                   "villagers": [{"id": 7, "model": "p01_03a", "house_type": 1, "show_frames": "hat",
                                  "hide_frames": "", "unk_14": -1, "unk_18": -1}]}}
```

| Field | Type | Meaning |
|---|---|---|
| `progress_info[]` | array | `PROG_INFO` rows in order. A `progress` outside `0..GAME_PROGRESS_MAX-1` is skipped by the loader (kept in the document). |
| `progress`, `chapter`, `section`, `order` | int | `ProgressInfo[progress]` fields (`chapter`/`section` as `s16`). |
| `name` | text or null, optional | Copied with `mgCopyString` when non-null. Absent when the row had four arguments (only `npc_place.cfg`). |
| `villagers[]` | array | One `NPC … NPC_END` block each. |
| `id` | int | Villager number; inside `0..VLGR_PLACE_MAX-1` it clears `VlgrPlace[id]` and starts a new list of entries. An out-of-range villager stores nothing and keeps collecting into the previous list (retail returns before resetting it). |
| `progress[]` | array | One `PROGRESS … PROGRESS_END` block each. |
| `progress` | int | Progress number; a number already collected for this villager reuses its entry, otherwise a new entry is created (`Init`) unless 256 are collected. |
| `duplicate_id` | int | Alternative (0..3) the places are stored under. |
| `condition` | text, optional | `after = condition == "以後"` (compared after CP932 encoding). Absent when the row had two arguments (only `npc_place.cfg`, where the slot was never written). |
| `noon_place`, `night_place` | int, optional | `place[duplicate_id][VLGR_TIME_NOON/NIGHT] = &PlaceInfo[n]` when `n` is a valid place number. |
| `villager_info` | object, optional | `NPC_INFO_NUM` and its `NPC_INFO` rows, read after every villager block. |
| `count` | int | Allocates `CVillagerInfo[count]` (`Alloc(blocks + 2)`) as `VlgrInfo`/`VlgrInfoNum`. Negative counts reject the document. |
| `villager_info.villagers[]` | array | Entries filled in order; rows past `count` are dropped. |
| `id` | int | `vlgr_id`. |
| `model` | text or null | `model_name` (`mgCopyString`) when non-null. |
| `house_type` | int, optional | Present when the row had at least 3 arguments. |
| `show_frames`, `hide_frames` | text or null, optional | Present when the row had at least 4 / 5 arguments; copied when non-null (the corpus uses empty strings, which are copied). |
| `unk_14`, `unk_18` | int, optional | Present when the row had at least 7 arguments; otherwise -1. |

Rules:
- Each `PROGRESS_END` allocates a fresh `ProgressInfo[n]` table holding every entry collected so far for the villager
  and copies them, exactly as retail (so a villager with k entries allocates k tables).
- `PLACE` (only in `npc_place.cfg`) has no effect and is not in the document.
- `NOON_PLACE`/`NIGHT_PLACE` with no current entry, or an alternative outside 0..3, are ignored by the port (retail
  dereferences null / indexes past the table).
- The converter requires the corpus shapes: `NPC` blocks of `PROGRESS [NOON_PLACE] [NIGHT_PLACE] PROGRESS_END` entries,
  then an optional `NPC_INFO_NUM` with its `NPC_INFO` rows. A short `PROGRESS`/`PROG_INFO` row following one that wrote
  the condition/name slot is refused (it would read a stale string).
- `LoadGameInfo` order: read `place.cfg.json` (missing: return), apply places, clear `ProgressInfo`, read
  `npc_place4.cfg.json` (missing: return), set `ProgressNum = GAME_PROGRESS_MAX`, apply `progress_info`, then the
  villagers and `villager_info`. Retail's debug `printf("rm %d")` is not reproduced.
- No ignored commands, no stale reads.

## Item tables (`menu/cfg5|cfg6|cfg7/*.cfg.json`)

Converter: `configs_native/items.rs`. Consumers: `LoadGameDataAnalyze(char *name)` (reads `menu/cfg7/<name>`, called by
retail `CGameData::LoadData` for comdat, wepdat, itemdat, atdat, robodat, fishdat, grddat in that order) and
`CGameData::LoadItemSystemMes(int language)` (`menu/cfg7/comdatmes<language>.cfg.json`). Overrides: `port/src/gamedata.cpp`.
cfg5/cfg6 are unread duplicates converted with the same kinds. `commentmes.cfg` (MES_COM) is in `UNUSED_RETAIL`.

Retail runs every table through one tag table (`gamedata_tag`); the converter gives each file one kind by name and fails
on any command of another table. `LoadGameDataAnalyze` accepts any item table kind (it dispatches on `kind`), so the
retail file name does not fix the kind. Every `count` is the operand of the table's init command, which retail stores
as the table's loaded count independently of the rows. `CGameData::LoadData` stays retail: it resets the common
cursor/lookup itself and recomputes `common_num`/`max_item_no` from the lookup the loader fills (the statics are
reached through `port/include/stubs/gamedata.hpp`).

| kind | files | body |
|---|---|---|
| `item_common` | `comdat.cfg`, `_comdat.cfg` | `count?` (COMINIT; when present also restarts the cursor and clears the lookup to -1), `records[]`: `item_no, type, list_no, active_set, stack_num, max_num, icon_texture_no, icon_no, message_no, file_name (string or null), attribute` |
| `weapons` | `wepdat.cfg` | `count` (WEPNUM), `weapons[]` (one per WEP, WEP_ST, WEP_ST_L, WEP_ST2, WEP_ST2_L, WEP_SPE, WEP_BUILD group, strictly in that order): `durability, levelup_exp, status[2], status_max[2], attribute[8], attribute_max[8], special{initial_fusion_point (float), pallet_color, unk_47, fusion_point, special, attack_type?, model_no?}, buildup_weapon[3], buildup_monster[3]?` |
| `items` | `itemdat.cfg` | `count` (ITEMINIT), `items[]`: `item_no, use_flags, action_flags, target_flags, value[3]` |
| `attachments` | `atdat.cfg` | `count` (AT_INIT), `attachments[]` (one per AT_ST, AT_ST2, AT_ST_SP group): `status[2], attribute[8], special` |
| `ridepod_parts` | `robodat.cfg` | `count` (ROBOINIT), `parts[]`: `item_no, type, use_capacity, offset_no` + by type: 0 `defence, label?`; 1 `durability, attack, durable, attribute[8], attack_type, label?`; 2 `unk_4, move_type`; 3 `energy`; other types nothing. `label` is the trailing string retail reads and discards. A row with operands its type does not read is a conversion error |
| `fish` | `fishdat.cfg` | `count` (FISHINIT), `fish[]`: `item_no, size (float), unk_4, battle, boost, endurance, tenacity, stamina, unk_10?` |
| `guards` | `grddat.cfg` | `count` (GRDNUM), `guards[]`: `item_no, value` (the five further integers GRD reads and discards are dropped) |
| `item_messages` | `comdatmes<n>.cfg` | `messages[]`: `item_no, name (string or null)`; `MES_SYSSPE` rows (read and discarded) are dropped |

Loader rules (C++): `COM` limits `max_num` to 0x90 for a weapon type asking for more than 100; `ITEM` expands
`ITEM_USE_FLAG_CURE_ALL` into the six individual cure bits; `initial_fusion_point` goes through `fptoui`; missing
`attack_type`/`model_no` store 0, missing `buildup_monster`/`unk_10` leave the field; ITEM, RB_PARTS, FISH and GRD find
their record by item number through the `CGameData` getters (so `comdat` must load first); WEP and AT rows fill
consecutive records through `SpiWeaponPt`/`SpiAttach`. Names: languages 2..5 run `ConvertFontCode` (scratch sized to
the text, no 0x100 limit), others copy as is; a null name stores null (languages 2..5: an empty string, as the port's
`ConvertFontCode` leaves the zeroed scratch); items without common data are skipped. Port guards (same as
`port/src/gamedata_tables.cpp`): COM rows past the 432-entry table are dropped, item numbers outside the 0x200 lookup
are not indexed, the weapon/attachment cursors become null at their tables' ends; `file_name` must fit 16 bytes (the
document is refused otherwise). Documents of any size load.

## `game_setup` (`game.cfg.json`, `dbg/*.cfg.json`, `host:` files)

Converter: `configs_native/game.rs`. Consumer: `LoadGameConfig(char *path)` (`port/src/config_loaders.cpp`). `path ==
nullptr` clears the current directory, reads the optional root `game.cfg.json` (silently skipped when absent), and clears
the directory again; a named path is read through `native_config::ReadGame` (current directory and `host:` save files).

`actions[]`, in script order, each `{"action": ...}`:
`map` (`map`: int, string, `{"float":x}` or null; string → `SearchMapNo`, float → truncated, null → 0; sets
`SelectArg[LOOP_EDIT]`), `progress {value}`, `bit_flags_on {flags[]}`, `bit_flags_off {flags[]}`, `start_event {event}`,
`georama_complete {towns[]}`, `georama_debug`, `item_set {set}`, `get_items {items[]}`,
`get_items_counted {items[{item,count}]}`, `equip {chara,item}`, `defense {chara,value}` (DEFENSE),
`defence {chara,value}` (DEFENCE; same effect), `hp {chara,value}`, `all_georama_parts {mode?}` (absent → 0),
`param_draw {show}` (param_off = !show), `option {name (string or null), value}` (MonsterName/Map/EnemyHP/AngerCounter;
others and null ignored), `monica`, `steve {core?}`, `monsters {ids[]}`, `party {chara}` (1..0x1A only),
`active_chara {chara}` (clamped as retail).

Retail quirks kept: `GET_N_ITEM` loops once per operand but reads two slots per loop, so a row of n operands gives n
pairs, the second half read from stale stack slots of earlier commands (all 15 corpus rows; 114 stale reads reported).
`STEVE` swaps the core only with exactly two operands (it then reads the first); `core` is present exactly then; three
or more operands are a conversion error. Ignored: `ET_N_ITEM` (misspelt GET_N_ITEM, `dbg/` corpus).

## `map_names` (`map/map<language>.cfg.json`)

Converter: `configs_native/game.rs`. Consumer: `LoadMapName(int language, u_long128 *)` (`port/src/mapselect.cpp`,
statics through `port/include/stubs/mapselect.hpp`). Body: `count` (MAP_NAME_NUM), `maps[]`: `name, title, add_path`
(strings as written, `""` kept; empty or null stores NULL), `type, sel_type, snd_data_id?` (absent → -1),
`area_no?` (absent → 0). The loader lays the table (count + 1 cleared entries) and the strings out in `MapNameBuff`
exactly as retail, including the final `pMapNameBuff` advance. Refused (next candidate / nothing loaded): a negative
count, more rows than count + 1, or a table plus strings exceeding `MapNameBuff`. `map/map.cfg` has no reader
(LoadMapName only reads `map%d.cfg`) and is not claimed.

## `movie_list` (`mv.cfg.json`)

Converter: `configs_native/game.rs`. Consumer: `MovieViewInit` via `PortInitializeMovieViewer`
(`port/src/movieviewlp_config_bridge.inc`), which takes the typed movies from `PortReadMovieList`
(`port/src/movieviewlp.cpp`, declared with `PortMovieEntry` in `port/src/config_bridges.hpp`). Body: `movies[]`:
`title, file` (string or null), `bgm?` (absent → -1). Each movie is copied into the 64-entry list with `mgCopyString`
from the viewer's stack; entries past 64 are dropped (retail would write past the list).

## Menu screens: `menu_layout` and `menu_commands`

Converter: `tools/kazarov/src/rust/configs_native/menu.rs`. Runtime: `port/src/menucommon.cpp`
(`PORT_OVERRIDE MenuDataAnalyze`, `PORT_OVERRIDE MenuCommandAnalyze`). The layout script's cursors and
"current" pointers are the retail file statics of menucommon.cpp, exposed by `port/include/stubs/menucommon.hpp`.
That way state carries from one script to the next as it does in retail (for example `menu0.cfg` then `geo.cfg`).

Routing applies to `menu/<digits>/<pack>.pac/<leaf>`:
- `menu_commands`: a leaf ending in `_com.cfg` (chr_com, dtmap_com, geo_com, inv_com, item_com, manual_com,
  mosbox_com, npcmove_com, opt_com, save_com, shop_com, trush_com), plus `omake_gyo.cfg`.
- `menu_layout`: `menu<digits>.cfg`, `chrchg`, `geo`, `invent`, `item`, `manual`, `mosbox`, `npcmove`, `option`, `save`, `shop`,
  `trush` and `wmap.cfg`.
- Not claimed: `dmap?.pac/dmap?.cfg`. It holds GI/RT/RI dungeon-map commands, so it is not a layout and belongs
  to `dungeon_map`. The language-level `wldmap.cfg`, `wmap.cfg` and `wdmap.cfg` are POS/AREA world-map scripts and belong to `world_map`.
  Other files not claimed: `shop.pac/shoplst.cfg` (`shop_lists`), `quest`, `scoop` and `help.cfg`.
- `wmap?.pac/wmap.cfg`, `wdmap?.pac/wmap.cfg` and `trushsel.pac/trush.cfg` are written in layout syntax, but no
  retail code reads them (no `GetPackFile` names them). They are converted as `menu_layout` so that every published
  script stays claimed.

Readers (callers of MenuDataAnalyze): menumain (menu0.cfg through GetMenuMainPosCfgBuffer, copied with memcpy first),
editmenu (menu0.cfg, geo.cfg, npcmove.cfg), inventmn (invent.cfg), menuchr (chrchg.cfg, mosbox.cfg), menuop (manual.cfg,
option.cfg, save.cfg), menushop (shop.cfg, menu0.cfg) and menusys (item.cfg).
Callers of MenuCommandAnalyze: CBaseMenuClass::ExeScript, SubGameCFGAnalyze (save_com) and GyoraceCFGAnalyze (omake_gyo).
The loader finds its document through `native_config::BufferPath(script)`. When the buffer has no registered
source, as with menumain's memcpy copy, the loader parses the JSON bytes in the buffer.

### `menu_layout`
`{"schema_version":2,"kind":"menu_layout","operations":[op...]}`. Operations are applied in order. Every
allocation is made from the `mgCMemory` passed to MenuDataAnalyze, with retail's block counts and in retail's order.

| op | fields | retail |
|---|---|---|
| `allocate_etc_info` / `allocate_etc_info2` | `count`? (default 96) | ETCINFO_MALLOC / ETCINFO2_MALLOC: allocate the table, then clear it |
| `allocate_textures` | `count`? (default 256) | TEXDATA_MALLOC |
| `allocate_forms` | `count` | FORM_MALLOC: `Alloc(blocks+2)`, then FormInfoClear |
| `clear_etc_info` / `clear_etc_info2` / `clear_textures` | `from`, `to`? | `to` is clamped to the table size; when absent, the table size is used |
| `clear_forms` | `from`+`to`, or neither (0..100) | FORM_CLEAR, then InitDrawList |
| `etc_info_offset` / `etc_info2_offset` | `index` | set **one shared** cursor (Menu_Target_No) and reset its local count |
| `texture_offset` / `form_offset` | `index` | TEXDATA_OFFSET / FORM_OFFSET_NO |
| `etc_info` | `entries:[{name, values:[a,b]}]` | stored at the cursor; an already named slot is skipped and the cursor stays |
| `etc_info2` | `entries:[{name, values:[f…]}]` | at most 4 values are stored (port guard). A slot past index 0 that already has the same name is kept; any other slot is renamed and overwritten |
| `texture_sheet` | `sheet` (string or null), `block_slot`, `textures` | TEXNAME then TD/TEXDATA rows. `sheet` must be < 0x20 bytes; `block_slot` indexes `MenuCommonInfo->tex_block[16]` |
| `textures` | `textures:[{name, rect:[x,y,w,h], spelling?}]` | rows not preceded by a TEXNAME. Skipped (cursor stays) when the slot is missing or the name already exists |
| `init_drawlist`, `reset_texinfo` | — | |
| `form` | `name`, `slot`?, `settings:[…]`, `parts:[…]` | FORM_SET and everything up to the next table operation |

Form: the index is `form_offset + slot` when `slot` is present, otherwise `form_offset + running count`. `slot` is
FORM_SET's *second* operand, which retail reads only when the command has three or more operands. If a form with
this name already exists, there is no current form: the settings and parts are not applied and the running count
does not advance. The current part stays the earlier one.
Settings (`set` key, in script order; each needs a current form):
`parts_capacity{count}` allocates the parts and initializes each one;
`draw_type{type, ambient?[4], list?}` (FORM_DTYPE): poly gets ambient 64,64,64,128 unless `ambient` is given; itembrd
gets 150 parts plus icon effects; geolist sets sub_no = `list`; msgform sets sub_no = digit at name[3]; unknown → 0xFF;
`move_type{type}` ("n","d","l","i","ir" → -1..3);
`draw_flag{draw}`; `other_form_draw_flag{form, draw}` (FORM_DRAWFLG with two operands names another form);
`vibe_count{counts}`; `move_rate{rate}`; `position{xy}`;
`rgba{rgba:[3|4]}` (alpha defaults to 0x80, all calc params are reset);
`rgba_bits{channels}` (letters r, g, b, a);
`actions{capacity, actions:[{name<16, move_type, xy, rate}]}` (FORM_ACTTBL plus the FORM_ACTDEF rows after it);
`action{name}` (FORM_SETACT); `clip{size?}` (default mgScreenWidth−1, mgScreenHeight−1).
Parts (`part` key): `normal`/`normal2` {texture, name, xy, size?} (with no size, the texture rectangle's size is used);
`cursor`/`funcinfo` {name, xy}; `number1`/`number2` {texture, name, value, xy, size?};
`frame_image` {kind bg|beta, texture, name, xy, size}; `form` {form (tex_info_no), name, xy};
`item` {kind trs|neta, name, xy, size?} (default 32×40); `item_checkmark` {name, xy, size?};
`fillbox` {kind sq_beta, name, xy, size, style}: allocates {1,2,2,4}[style] effect records;
`waku_rect`/`waku_circle` {texture, name, xy, size};
`dtype` {kind, name, etc_info? (clut_reload), xy+size (ごちゃ線 random line)}.
`spelling` records the written tag when it is not the usual one: `NORMAL` for `normal` (the usual tag is `NRL`),
`TEXDATA` for textures (the usual tag is `TD`). It has no effect.
Each part has an optional `modifiers` list (in script order) with a `mod` key:
`shadow{on?, offset?}` (default on, offset 4); `alpha{alpha}` (rgb 0x80); `rgba{rgba:[3|4]}`; `alpha_blend{mode}`;
`etc_info{entries:[{index,value}]}`; `bilinear`; `vibe_count{counts}`; `viber{ranges}`;
`effect_capacity{count}` (PARTS_EFF_NUM: when count > 0, allocates records and sets effect_num);
`effect{type, params}` (PARTS_EFFECT; at most 8 params);
`fill{rgba}` (FILLBOXINFO). `effect` and `fill` write to the record pointer last set by FILLBOX/PARTS_EFF_NUM, not to the part itself.

Converter shape assertions (the retail corpus satisfies all of them):
- Every setting comes before the form's first part.
- Modifiers only follow a part of the same form.
- FORM_ACTDEF only follows FORM_ACTTBL.
- No part, setting or modifier appears outside a form.
- FORM_DTYPE geolist has its operand, and poly has none or 4 floats.
- FORM_RGBA and PARTRGBA have 3 or 4 operands (PARTRGBA may also have 1).
- CLIP has 0 or 2 operands, and FORM_CLEAR has 0 or 2.
- PART_DTYPE random line has 4 values. Other non-clut kinds have no values.

Port bounds (retail writes out of range or dereferences null):
- Parts are skipped when there is no current form or no free slot.
- Modifiers are skipped when there is no current part.
- `effect`/`fill` records beyond the allocated count are dropped.
- A fill style outside 0..3 allocates no records.
- Action definitions beyond the table capacity are dropped.
- `etc_info` indexes outside 0..3 are dropped.
- etc_info slots with negative indexes are skipped.

Stale reads: NUMBER1 slot 6 (h) in every `item.cfg` (8 files; a 6-operand NUMBER1 reads h from the previous
command). The stale value is stored as `size[1]`.
Ignored (typos, never run): `FORM_PUXY`, `FORM_ACTSET`.

### `menu_commands`
`{"schema_version":2,"kind":"menu_commands","blocks":[{"name", "commands":[…]}]}`. Blocks are kept in script order,
and several blocks may share a name. MenuCommandAnalyze copies the requested name into
`MenuCommandAnalyzeInfo.command_name` (bounded) and runs **every** block whose name equals it, in order. When no
block has the name, nothing runs. `SpiMenuExeCommandFlag` ends equal to the last block's comparison.
Statements before the first EXE_NAME would run only if the previous call ended on a matching block; the converter
refuses them (none occur). Typed documents are cached by source path and are parsed again only when that path's
datapack candidates change.
Commands (`op`):
- Form commands: `form_draw_flag{draw, forms[]}` (prints "<name> not found"); `form_rgba{form, rgba?[4]}` (with no
  rgba, all channels become 0x80; calc params are reset); `form_calc_rgba{form, channel, step, target}`;
  `form_fade{form, mode 0 in|1 out, frames}`; `form_set_pos{form, xy, language?}` (moves the form only when the
  language matches LanguageCode); `form_set_action{form, action}`; `part_draw_flag{form, part, draw}` (FRM_PARTSONOFF;
  `spelling: "FRM_PTSONOFF"`); `parts_draw_flag{form, draw, parts[]}` (FRM_PTSONOFFG; `spelling: "FRM_PARTSONOFFG"`);
  `form_swap{forms[2]}`; `form_group_swap{forms[4]}`; `init_drawlist`; `reset_texinfo`.
- Message-window commands: `message_env{window, preset}` (MsgPreset(keyword → id or −1, LanguageCode));
  `make_message{window, message}`; `message_abs_pos{window, value}`; `message_system_buffer{window, buffer}`
  (a null buffer gives GetSystemMesBuffer()); `message_buffer{window, buffer}`; `message_outline{window, style}`
  (default/none/ol2 → fuchi, −1 when unknown); `message_cursor{window, cursor}`; `message_question_row{window, row}`;
  `message_speed{window, speed}`.
- Other commands: `input_key{enable}`; `cursor_on_off{show}`; `cursor_fade{fade_in, speed?, steps?}`: when `steps`
  is present, retail uses speed 10 and ignores the script's speed operand; `speed` alone is used; the default is
  10 with 1 step; `frame_type{type}`; `scene_fade{fade_in, frames?}` (default 40, followed by FadeStep);
  `play_se{name}` (OK/CANCEL; anything else plays nothing); `print{text}` (printed as text, not used as a format string).

Port bounds:
- A window index outside MenuDCMsg[9], or a null window, skips the command.
- A buffer index outside 0..3 skips `message_buffer` and gives the system buffer for `message_system_buffer`.

Stale reads: none in the corpus. FRM_RGBA with 2–4 operands would read stale slots, and the values are stored as read.
Ignored (typos): `FRM_DRAFLG`, `FMR_DRAWFLG`, `CURSOR_ONFF`, `SE_OK`, and the tag `FRM_CALCRGBA<U+3000>"msg7",3,8,128`
(no operands; the full-width space makes the operands part of the name).
