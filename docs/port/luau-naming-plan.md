# Luau naming plan

Goal: every Luau file the game ships (`port/src/luau`) reads like hand-written Luau. Readable names for:

- the engine commands;
- the shared library modules and their functions;
- local helpers, handlers and module state;
- parameters and locals;
- the magic numbers.

The script modules become the source of truth from here on. `tools/luau/stb2luau` stays as the record of how they were made, but it is not re-run over them.

Decisions (2026-10-30):

1. The engine API is renamed to snake_case readable names.
2. Script modules keep their retail data paths; the shared `lib/` modules get readable names.
3. Names come from curated tables that agents propose from the code, applied by a rename tool, and every pass is proven by a bytecode gate.

## Scope

| Category | Count | Today | Target |
|---|---|---|---|
| Engine commands (`event`, `action`, `effect`, `monster`) | 978 used, ~2,500 declared with arity variants | `event.CharaActive`, `event.LoadMotion`, `monster.GetPos_3` | `event.set_character_active`, `event.load_motion`, `monster.get_position` |
| Shared helper modules (`lib/<kind>/helper_<hash>.luau`) | 2,927 (2,867 required; 309 by 10+ modules), 14 named | `helper_0226fccb` | `lib/event/scene/show_town_guards.luau` |
| Local helpers | ~7,600 | `local function helper_3f33c()` | `local function load_party()` |
| Numbered handlers | ~2,000 map/event handlers, ~350 local `event_<n>` | `script.event_99`, `script.event_<hex>` | `talk_to_mayor`, registered as `script[99]` |
| Module state | 21,581 uses of `global<n>` | `global0`, `global1` | `max_slot`, `monica_slot` |
| Parameters | 25,378 uses of `arg<n>` | `arg0: f32` | `speed: f32` |
| Locals | 283,405 uses of `var<n>` | `var12`, `var15` | `yaw`, `turn_radius` |
| Magic numbers | not counted | `event.CharaActive(1, 8)` | `event.set_character_active(true, Character.TOWN_GUARD_1)` |

Program-named handlers (`on_start`, `on_damage`, `init`, `loop`, …) already come from `tools/luau/programs.json` and stay as they are.

## Conventions

- **Case.**
  - Functions, locals, parameters, module state and table fields use `snake_case`.
  - Constants are `UPPER_SNAKE` inside a `PascalCase` table, for example `Character.MAX`.
  - Type aliases are `PascalCase`.
- **Functions** are verb phrases: `load_party`, `wait_for_message`, `turn_toward_player`.
  - Predicates start with `is_`, `has_` or `can_`.
  - Getters start with `get_` only when they call the engine; otherwise they take the noun.
- **Map and event handlers** are named for what triggers them: `talk_to_<who>`, `enter_from_<where>`, `on_<event>`, `cutscene_<what>`.
  - The handler's number stays visible at its registration: `script[99] = talk_to_mayor`.
- **Values** are named for what they hold, not their type. No `tmp`, `val` or `data` unless nothing else fits.
  - Loop counters are `i` or `index`.
  - Positions are `x`, `y`, `z` or a `pos_` prefix.
  - Angles carry their unit in the name when it is not radians: `yaw_degrees`.
- **Several engine outputs** are destructured at the call: `local x, y, z = monster.get_position()`.
  - This replaces the `do local out1, out2 … end` blocks. It is a readability rewrite that the gate checks, not a rename.
- **Abbreviations** are spelled out:
  - `character`, not `chara`;
  - `position`, not `pos`, in API names;
  - `message`, not `mes`;
  - `object`, not `obj`.
  - Retail spellings stay only in the `commands.json` aliases.
- **Unknown meaning.** When the meaning cannot be established, keep a neutral descriptive name, such as `state_flag_3` or `unknown_timer`, rather than a guess. Record it in the table as `unresolved`.
- **Comments.** A function gets one `---` line saying what it does, replacing `--- Helper function.`. No comment narrates a line.

## Engine API

Status: done. Phase 1 named all 1,081 commands; 32 handlers that are stubs or whose meaning the code does not establish are marked unresolved in the agents' tables. The names are in `tools/luau/curation.json`. Variant and arity suffixes stay for now as `_int`/`_float` and `_<argc>`; collapsing them into the base names is still to do.

- `tools/luau/commands.json` gains a `luau` name per command. Retail names stay as `name` for docs, logs and `commands.json` lookups.
  - `tools/luau/bindings.py` generates `luau_bindings.hpp` from it.
  - `tools/luau/stb2luau/api.py` generates `port/src/luau/api/*.d.luau` from it.
  - Those two generators are the only tool changes. The transpiler's emitter is not updated.
- Parameters in the declarations take readable names from the same table: `arg1` becomes `enable`, `chara_no` becomes `character`.
- Arity variants (`GetPos_3`, `CharaActive_2`, `_1v`):
  - Scripts call the overloaded base name wherever the runtime's dispatch by argument count and type gives the same signature.
  - A variant survives only where the types alone cannot pick the signature. It gets a descriptive name, such as `get_pad_held` and `wait_pad_held`, not an arity suffix.
  - Before any call site changes, a test checks that the base name and each variant resolve to the same `Signature`.
- Naming source: the retail meaning from `port/src/object/event/event_func.cpp`, the action, monster and effect command tables, `docs/re`, and the existing one-line docs in `commands.json`. Examples:

| Retail | Luau |
|---|---|
| `CharaActive` | `set_character_active` |
| `EohSyncChara` | `bind_object_to_character` |
| `ObjsInit` / `ObjsSyncObj` | `init_object_sequence` / `bind_object_sequence` |
| `LoadMes` | `load_messages` |
| `MesMake` | `make_message` |
| `GetActiveChrNo` | `get_active_character` |
| `GotoUseItem` | `open_use_item_menu` |
| `GetPadon` / `GetPaddown` / `GetPadup` | `get_pad_held` / `get_pad_pressed` / `get_pad_released` |
| `GetApad` | `get_analog_stick` |

## Shared library

- Modules move to `lib/<kind>/<domain>/<name>.luau`. Domains are chosen per kind from what the helpers do:
  - event: `message`, `camera`, `character`, `party`, `scene`, `flag`, `sound`, `menu`, `wait`;
  - monster: `move`, `attack`, `react`, `sense`;
  - action: by state;
  - effect: by effect family.
- The 14 curated helpers keep their names and move into domains. For example, `wait_frames` moves to `lib/event/wait/wait_frames.luau`.
- `tools/luau/names.json` is superseded by `tools/luau/rename/lib_<kind>.json`. Each row holds the hash, the new path, the function name, the parameter names, a one-line doc and a status (`named` or `unresolved`).
- Near-duplicates (the same body with different constants) are folded together only in a later pass. Renaming never merges modules.

## Per-module names

- One table per script module: `tools/luau/rename/modules/<module path>.json`. It holds:
  - local helpers and handlers;
  - module state (`global<n>`);
  - each function's parameters and locals, keyed by function and original name.
- Example (`map/s/s02/s02.luau`):
  - `global0` and `global1` become `max_slot` and `monica_slot`. When Max is active the first slot loads `mints_set` and Max's model, so the first slot is Max's.
  - `helper_3f33c` becomes `load_party`.
  - `helper_24100000` becomes `reset_party_slots`.
  - `active_chr_no` becomes `active_character`.

## Constants

- `lib/constants.luau` exports frozen tables built from the `ps2/include` enums and the data:
  - `Character` (scene slots and party members);
  - `Stack`;
  - `Window`;
  - `Flag`, for story flags whose meaning is known;
  - `Item`, from the item table;
  - `Sound`;
  - `Pad`, for button masks.
- Agents replace a literal only when its parameter's type in the API declaration is one of these enums. Other literals stay numeric.
- A constant is `inline`-friendly (`local MAX = Character.MAX` at module top), so the gate's constant folding keeps bytecode stable. Where that fails, the gate compares the folded value.

## Rename tool

`tools/luau/rename/apply.py`:

- It parses each module with Luau's own parser, through the existing `luau-harness` build exposing `Luau.Ast`, and renames by binding, never by text.
- It rewrites `require` paths, engine calls, locals, upvalues, parameters and handler registrations from the tables.
- It refuses a table whose names collide in a scope, shadow an engine global (`event`, `vm`, `vmhost`, …) or are Luau keywords.
- It is idempotent: applying a table twice changes nothing.

## Gates

Every pass must clear all of these before it is committed.

1. **Bytecode equivalence.** Compile every module before and after with debug level 0, and map renamed constants (`require` strings, engine field names, handler keys) through the tables. The instruction streams and constant pools must then be identical. Local and parameter renames leave bytecode byte-identical on their own.
2. **Strict type checks.** `luau-analyze` passes in `--!strict` mode against the regenerated `.d.luau` files.
3. **Unit tests.** ctest passes, including `luau_runtime_test` and the event-argument tests, with fixtures renamed.
4. **Event harness, on the checked-in modules.** The harness gains a mode that loads `port/src/luau` instead of fresh transpiler output: the 32-seed event run, in halves, plus action, effect and monster.
5. **Replays.** Palm Brinks at frames 25500-59300 and the 49 event and boss sweeps give the same screenshots as before the renames.

## Order of work

1. **Engine API.**
   - Add the `luau` names to `commands.json` and regenerate the bindings and declarations.
   - Run the agent naming pass over the 978 used commands. This is first because every other name reads against it.
2. **Constants.** Write `lib/constants.luau` from the headers.
3. **Shared library.**
   - Start with the 309 helpers used by 10 or more modules, then the rest.
   - Each kind is its own pass and commit: event, monster, action, effect.
4. **Script modules.**
   - Do one directory family at a time, as its own pass and commit: `map/s`, `map/d`, `map/i`, `map/f`, `map/g`, `map/m`, `event/e*`, `dungeon/monster`, `dungeon/eff_script`, `dungeon/act_script`, `mainchr`, `menu`.
   - Each module covers its handlers, module state, local helpers, then parameters and locals.
5. **Readability rewrites.** Destructured outputs, removing redundant `or value` fallbacks where the API says the output is always written, and folding `do` blocks. Each kind of rewrite is its own pass behind gate 1.
6. **Docs.** Update `PORT_LUAU.md`, the handoff and `PC.md`. Mark `tools/luau/stb2luau` as historical, and say that the modules are now edited directly.

## Agent passes

- One agent per batch of about 40 helpers or about 15 script modules. An agent:
  - reads the code, the engine command docs, the referenced data paths and strings (message text, motion and model names), and the callers of each helper;
  - writes only the rename table, never the modules;
  - marks any name it cannot support from evidence as `unresolved`.
- A second agent reviews each table against the code, without seeing the first agent's reasoning. Disagreements go back for one revision, then to `unresolved`.
- Expected size: about 75 batches for the library and about 95 for the modules, run as one workflow per phase.
- Remaining `unresolved` names are listed in `tools/luau/rename/UNRESOLVED.md` for hand review.

## Open points

- Confirm that `ProgramName` returns nothing for map and event kinds, so that `script[<n>]` registrations resolve. Otherwise teach it to fall back to the integer key.
- Debug-level-1 bytecode in iOS `.luauc` files embeds names, so precompiled files change with every pass. That is expected; the gate uses level 0.
- Retail names in logs: runtime errors should print `load_motion (LoadMotion)` so old notes and the harness stay searchable.
