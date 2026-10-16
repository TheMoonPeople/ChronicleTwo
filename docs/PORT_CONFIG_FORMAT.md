# Native configuration assets

The PC port executes converted configuration commands directly from pretty-printed JSON. Rust extraction decodes text CFG and `BIN` CFG inputs offline and removes their original files and PACK members from `/data`. Standalone files use their actual new paths, such as `menu/cfg7/common.cfg.json`, relative to `port_data`. Standalone CFG files retain their suffix as `.cfg.json`, and MAP configuration files use `.map.json`, so a same-stem texture document can keep its `.json` filename. There is no configuration catalog or asset manifest. The game reads actual JSON bytes, including ordinary copies into game arenas.

Character configuration lives in the glTF's adjacent `.game.json` companion as named profiles with typed resource bindings. A companion contains only the extra data consumed by the retail game; glTF standard fields hold geometry, materials, textures, skeletons and supported animation tracks. Rust rewrites resource-bearing configuration arguments and compiled-script filename operands to their actual new paths. Text labels and unrelated gameplay strings remain intact.

A command document uses schema version 1 and an ordered `commands` array. Text commands use a readable `command` name. Converted binary commands use `tag_index`, preserving the original callback-table index.

```json
{
  "schema_version": 1,
  "commands": [
    {
      "command": "EXAMPLE",
      "args": [
        {"type": "int", "value": 42},
        {"type": "float", "value": 1.5},
        {"type": "string", "value": "Readable text"},
        {"type": "invalid"}
      ]
    },
    {"tag_index": 0, "args": []}
  ]
}
```

Argument types match the game's callback ABI. Integers remain signed 32-bit values; floating-point values become finite native floats; invalid arguments retain the original invalid stack type. Empty strings remain string arguments. Strings are readable UTF-8 in JSON and are encoded as CP932 for existing game fonts and file identifiers. Exceptional original byte strings that cannot be represented as Unicode may carry a `game_bytes` hexadecimal field. These are decoded directly into string bytes.

`CScriptInterpreter::SetScript` decodes the actual JSON buffer. For filesystem reads, its actual filename allows invalid datapack replacements to fall back through lower-priority documents. `GetNextTAG` fills `SPI_STACK` with typed values and mutable string storage, then invokes the selected callback. `Run` continues to dispatch commands through this native override. Unknown named commands are skipped; indexed commands preserve the binary interpreter's index behavior. `GetNextTAG(0)` advances and exposes the typed stack without invoking a callback. No CFG text is reconstructed or reparsed.

Datapacks replace JSON files using their actual relative paths. Later configured packs take precedence. Unreadable or invalid replacements fall back to valid lower-priority documents. Paths cannot escape the converted-data root. A command may have at most 64 arguments and 0x2800 bytes of encoded string storage, matching the game's callback capacities. Invalid integer ranges, nonfinite floats, unsupported argument types, embedded null bytes, or unencodable Unicode produce a diagnostic rather than executing a damaged command.

The five `menu/<language>/help.cfg` sources publish as `menu/<language>/help.cfg.json` and use a separate movie-subtitle consumer. Their documents have `kind: "movie_subtitles"` and `chapters`, each containing an `id` and ordered `entries`. Entries carry `start_seconds`, `clear_seconds`, `text`, and optional `game_bytes`. The movie subtitle adapter reads these fields directly; the command interpreter rejects this specialized kind. Literal line-feed escapes are decoded offline while original trailing carriage returns remain intact.

Scripts with other file types retain their existing script reader. Sound bundle JSON references its WAV samples, sequences and controls directly. Tests cover typed execution, binary tag indices, unknown tags, Unicode and exceptional game bytes, JSON overrides and fallback, non-calling command reads, unregistered JSON buffer copies, and capacity/path validation. Optional corpus tests compare gameplay arguments with the original interpreter and account separately for authorized native resource references. Movie subtitles have dedicated consumer tests.
