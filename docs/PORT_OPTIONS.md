# Port host settings (PC SETTINGS)

**Agents:** follow [`openspec/config.yaml`](../openspec/config.yaml) and [PORT_DATA.md](PORT_DATA.md) for game-data layout.

Host-only game settings live in **PC SETTINGS** (Backspace overlay, or Select/View from retail Options). They persist in `<save-root>/config.json` under `game.*`.

## PC SETTINGS → Game

| Key | Label | Default |
|-----|-------|---------|
| `game.autosave` | Autosave | **Off** |
| `game.debug_mode` | Debug mode | **Off** |
| `game.skip_intro` | Skip intro | **Off** |
| `game.expanded_dungeon_monsters` | Expanded dungeon monsters | **Off** |
| `game.georama_poly_multiplier` | Georama budget | **1×** (retail caps) |

Georama budget **1×** through **6×** multiplies the per-town limit shown in the Georama build menu and enforced when placing parts. Draw-memory limits (`GetMaxDrawMem`) are **not** scaled.

Registry: `port/src/options/registry.cpp` (`port_settings::Descriptors`, `Surface::PcOverlay` only). Rows: `port/src/options/rows.cpp`.

**Debug mode** calls `DebugModeBoot` when toggled in the overlay; **restart** the game for full boot-time unlock. See [DEBUG.md](DEBUG.md) for controller chords, the title-screen developer menu (**Start + Select**), and what `DebugFlag` unlocks in play. **Skip intro** affects boot/title logos (`nowload.cpp`, `title_intro.cpp`).

## Retail Options (deferred)

In-game pause → Options is **stock** for now (16 PAL rows, no port row 16, no registry labels on row 9). Retail wiring (`Surface::Retail`, `option.pac` patch, `config_option_num + 1`) is documented for a later pass in [OPTION_PAC.md](OPTION_PAC.md). The patch asset is `port/assets/patches/menu/0/option.pac` (listed in `manifest.json`); `apply_patches` copies it even while in-game Options UI stays stock.

## Local workflow

```bash
./run.sh linux-x64
# PC SETTINGS → Game, toggle settings; then:
cat port/run/save/config.json
# expect "debug_mode", "skip_intro", and "georama_poly_multiplier" under "game"
```

## Files when adding a host bool (PC overlay)

1. `port/src/platform/config.hpp` / `config.cpp` — `game.*` key
2. `port/src/options/config_bool.cpp` — read/write + any runtime hook
3. `port/src/options/registry.cpp` — descriptor with `Surface::PcOverlay`
4. `port/src/options/rows.cpp` — Game page row (`{"Off", "On"}` for bools)
5. Tests: `port_settings_registry_test.cpp`, `pc_options_test.cpp`
