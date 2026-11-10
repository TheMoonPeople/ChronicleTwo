# Native configuration assets

The PC port reads retail configuration (CFG) and map (MAP) scripts as native semantic JSON documents. These documents are tracked in `port/gameplay/` as pretty-printed source files and packaged compact under `gameplay/` in a seed `data.zip` beside the executable. Ordinary extraction validates that seed against compiled document hashes and copies it without regenerating or reading repository JSON. A standalone script keeps its path below `gameplay/` with `.cfg.json` or `.map.json` in place of its suffix (`gameplay/menu/cfg7/wepdat.cfg.json`, `gameplay/map/s/s01/s01.map.json`), so a same-stem texture document keeps its `.json` name; a PACK member uses the PACK's logical asset directory below `gameplay/` (`gameplay/menu/1/shop.pac/shop_com.cfg.json`). The original scripts and PACK members are absent from `data.zip`. There is no runtime configuration catalog.

Every document is an object with the schema version, its family's kind, and that family's named fields:

```json
{
  "schema_version": 2,
  "kind": "shop_lists",
  "shops": [{"id": 1, "items": [10, 11, 12]}],
  "prices": [{"item": 10, "buy": 100, "sell": 50}]
}
```

Fields hold the values the game reads, typed as the game reads them: integers are signed 32-bit, numbers read as floats become native floats, and strings are readable UTF-8 that the port encodes as CP932 for the game's fonts and identifiers. A string that UTF-8 cannot represent is `{"text": "...", "game_bytes": "<hexadecimal CP932>"}`. `null` is a string operand the original script left missing. A key that is absent is an optional operand the original script left out; the port then does what the retail callback does without it. Values the game derives at load (radians from degrees, colour scaling, the PAL screen stretch, font conversion, defaults) are not stored. Ordered families keep their order in arrays; nothing is a list of commands. [NATIVE_CONFIGS.md](NATIVE_CONFIGS.md) gives every kind's fields and rules and how the extractor proves each document reproduces its script.

Tracked gameplay documents are pretty-printed JSON for review. Their entries in `data.zip` use compact serialization. Datapacks replace a document by its archive path, including the `gameplay/` prefix; later configured packs take precedence. The port tries candidates from the highest priority down and uses the first whose `schema_version` is 2, whose `kind` is the one its loader reads, and whose fields parse with valid types, counts and string capacities. A candidate that fails prints one `config: <path>: <reason>` diagnostic and the next is used, so a broken overlay, or a schema-1 command document from an older extractor, falls back to the archived document. Paths cannot leave the asset namespace. Loaders skip entries the game's tables cannot hold, where the retail code would have written out of range.

The five `menu/<language>/help.cfg` caption files publish as `kind: "movie_subtitles"` documents with `chapters` of `id` and ordered `entries` (`start_seconds`, `clear_seconds`, `text`, optional `game_bytes`).

Character profiles, default profile, game names and cloth commands live in archived `.character.json` gameplay companions ([model format](PORT_MODEL_FORMAT.md)); their profiles have typed resource bindings, and their cloth and effect scripts are ordered typed command lists that the port runs through those scripts' tag tables. The `.game.json` companion retains asset references and model metadata. Text scripts that are not configurations (inventory `.lst` tables, georama `.gpi` files, dungeon floor titles, map effect `.em` scripts and event scripts) keep their own readers.

`dc2data gameplay <iso-or-directory> port/gameplay` is the explicit developer refresh mode (`configs` is an alias). It reads the disc source and replaces the JSON corpus as one completed update. Normal game setup does not invoke it; the checked-in gameplay corpus is packaged in the external seed archive. Rebuild `dc2data` after refreshing or editing these sources to regenerate that archive and its compiled hash manifest, then run extraction to publish the updated gameplay under `gameplay/` in the completed `data.zip`.

After extraction completes, `dc2data gameplay-audit <iso-or-directory> port/gameplay` (`configs-audit` also works) rebuilds semantic values in memory and compares the tracked documents with the disc. `dc2data configs-parity <iso-or-directory> <data.zip> port/gameplay <fixture-directory> --texture-oracle <directory>` prepares the native-interpreter parity fixture, including character profiles, without creating a raw disc tree. Set `CT_CFG_PARITY_MANIFEST` to the generated `parity.json` for `NativeConfigParity.MatchesEveryOfflineOriginalInManifest`.
