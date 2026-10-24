# Luau migration handoff

Status: M0-M3 are complete. M4 (event scripts) is in progress on branch `luau/m4-events`. Its runtime side is done and tested. Its transpiler side has produced 531 of 974 event and argument modules, which have passed the 2-seed harness but no in-game replay. Read "Handoff (2026-10-25)" first.

## Handoff (2026-10-25)

### Where things stand

- **Runtime (done).** This covers:
  - the `event` and `event_arg` kinds;
  - skip mode (`vmhost.skipping` and `vmhost.skip_end`, `CRunScript::skip`);
  - argument scripts, read as data tables by a `PORT_OVERRIDE` of `CEventScriptArg::BuildArgData` (`port/src/event_func.cpp`).

  The argument path matches retail for extra `ID_OFFSET` arguments, the no-memory case and unknown commands. `LuauRuntime.*` and `EventArgData.*` pass. Details are in "M4 runtime (2026-10-24)" below.
- **Transpiler (partial).** This covers:
  - skip lowering (`stb2luau/skip.py`);
  - reference-forwarding call sites;
  - dead-statement pruning;
  - the harness's skip variants;
  - argument data modules (`stb2luau/event_args.py`);
  - event program names;
  - catalogue curation.

  The output is in `port/src/luau/{map,event}` and `lib/event` (every `dungeon/sys_script` event script is refused). The 443 refused event scripts are listed in `tools/luau/fallback.json` and stay on the interpreter. Details and measurements are in "M4 transpiler (2026-10-24)" below. The coordinator stopped before the 32-seed run and before re-running the action, effect and monster gates, so its "M4 results" section was never written.
- **Tests on this tree:**
  - Python: running `python -m unittest discover -p "test_*.py"` in `tools/luau` passes 352 tests (1 skipped).
  - C++: `port/build/windows-x64-tests` builds, and `ctest -R "LuauRuntime|EventArgData"` passes 40 of 40. The full suite has not been rerun since the last runtime changes.
  - The 443 refused scripts include 10 (`dungeon/sys_script/d01`-`d05`, `map/f/f03/i04/f03i04*`) that the transpiler refused after it had written their modules. Those stale modules were deleted. The counts under "M4 transpiler" are from before that and read 433/541.
- **Not yet run:**
  - the event gate at 32 seeds;
  - the action, effect and monster regression gates;
  - any replay comparing `DC2_SCRIPT_VM=interpreter` with Luau on event scripts.

  **Until those replays pass, the event modules on this branch are unqualified.** `DC2_SCRIPT_VM=interpreter` restores the old behaviour.

### Next steps, in order

1. **Gates.** Run `python tools/luau/stb2luau/transpile.py --data <dc2data export-scripts dir> --kind event --kind event_arg --check --harness --seeds 32`, then the same command with `--kind action --kind effect --kind monster`. Every count must match the M3 table, with no new failures. Record the results here.
2. **Tests and replays.**
   - Build `port/build/windows-x64-tests` with `pwsh` (`build.ps1` needs PowerShell 7) and run the full `ctest` (docs/PC.md "Windows").
   - Run interpreter-against-Luau replays from `tools/input` that cover the opening, Palm Brinks, a map jump and a boss event; "M3 runtime" describes how.
   - Screenshots must be byte-identical. Investigate any difference before continuing.
3. **The 443 refused event scripts.**
   - 403 are refused because skip mode enters a callee whose linear run reaches a SKIP_END before its RET, so retail resumes the caller in the middle of a structured body. Design a readable re-entry, such as a resumable continuation for each such call site. 156 of these sites are at the top level of their function, where the rest of the body can be duplicated as the continuation.
   - Do **not** revive the VM-arena emulation (see "Abandoned work").
   - The remaining 30 are smaller cases, listed under "Refused".
   - `GeoramaFunc` and `GetFishingtournamentEtc` need a per-site direction in the catalogue.
4. **The 89 M3 fallbacks.** These are the CopyVector references and similar cases in `tools/luau/fallback.json`. Under the user's decision of 2026-10-24, where a handler reads a reference slot as a value, Luau passes the referenced variable's value. This is a deliberate, accepted behaviour change.
5. **M5 readability.** Scripts must read like hand-written native Luau. Curate the names of:
   - `helper_<hash>`, `varN` and `argN`;
   - event programs that have an engine meaning.

   Then clean up the emitter output:
   - Remove the `x = cmd() or x` noise where an output is always written.
   - Drop `vm.f32(...)` around literals that are already exact in float32.
   - Use catalogue enums for constants.

   Keep `--!strict` and a clean `luau-check`, and re-run the harness after every emitter change.
6. **M6 retirement.**
   - Remove the interpreter dispatch, `script_timing` and the NTSC startup validation from the PC build. The retail VM stays only in tests, for the harness.
   - Stop publishing `.stb`. This goes through the Kazarov submodule: changes land in the Kazarov main line first, and only then does the gitlink move (docs/PC.md "The shared-code pin"). `C:/Users/Adubbz/Development/PS2/Projects/Kazarov-m6` has two unmerged Luau-only publication commits from the abandoned attempt, which are worth reviewing.
   - Add CI gates.
   - Update docs/PC.md and docs/PORT_LUAU.md.

### Abandoned work (do not resume)

An earlier attempt emulated the VM's value arena in Luau, using hash-named factory modules and pc tables. It lives in `git stash@{0}` (2026-10-23), `port/build/luau-m5-candidate` and `port/build/luau-m5-integration`. Its full-corpus run never finished and its output is unreadable. On 2026-10-24 the user chose the structured transpiler instead. The useful parts (argument data tables, catalogue fixes, the nested-helper regression test) have been carried over.

**Never run `git stash pop`, `apply` or `drop` on stash@{0}.** It also holds the user's unrelated uncommitted work (DualSense controller speaker, first-run setup, `sound.cpp`, `main.cpp`), which the user will restore. Read it only, with `git show "stash@{0}:<path>"`.

### How to work (from AGENTS.md and the user)

- **Agents.**
  - An Opus coordinator directs Sonnet agents for analysis. Haiku agents read and write code and files.
  - Writers never share files. Split the work by area: the transpiler (`tools/luau/**` and the generated `port/src/luau/**`) or the runtime (`port/src/*.cpp|hpp`, `port/cmake`, `port/src/tests`).
  - Diagnose and speed up anything slow. Use incremental Ninja builds, and `--jobs` for the transpiler.
- **ps2/ is off limits.**
  - Never edit `ps2/src` or `ps2/include`. The PS2 builds must stay byte-identical.
  - Port code lives in `port/src` and `port/include`, and replaces PS2 functions with `PORT_OVERRIDE` in a file with the same name as the PS2 source file (docs/PC.md).
  - Retail bodies an override still needs are bridged through `scripts/port/unit_copy.py` (`RETAIL_BRIDGES`) and `scripts/port/header_fixups.py`.
- **Port C++ style.**
  - C++23, with file-local functions, constants and globals in anonymous namespaces.
  - No `goto`. Use `enum class` instead of bare integers, `nullptr`, and C++ casts only (`port/.clang-tidy`).
  - Fields and locals are `snake_case`. Prefer `std::unique_ptr` or `std::shared_ptr` to fixed buffers.
  - Run clang-format and clang-tidy.
  - Comments state purpose only, with no history and no restating of the code.
  - Structs, classes and functions get `/** */` comments of three or more lines, with the brief vertically centred. Fields get `/**< */`.
- **Luau style.**
  - `--!strict`. Use the type aliases `s8 u8 s16 u16 s32 u32 f32` from `port/src/luau/api/*.d.luau` in signatures and on locals.
  - `PRINT` becomes `print`.
  - Write readable native Luau at `port/src/luau/<original path>.luau`. The files ship loose in `<game root>/scripts`.
- **Behaviour.**
  - Match retail exactly, except where the user decided otherwise ("Decisions" below).
  - Flag any gameplay change or new dependency to the user before relying on it.
  - Report results faithfully, with the failing output. A 2-seed or sampled run is never qualification.
- **Git.**
  - Commit to a branch, not `master`, unless the user asks.
  - `tools/kazarov` shows as modified because of another session's work. Leave it alone, and never commit the submodule pointer.

## What exists

- `docs/PORT_LUAU.md`: script kinds, tools and catalog, plus the **Runtime contract** shared by the transpiler and runtime, with planned event support identified separately.
- `tools/luau/stb/` (M0): decoder (`program.py`), CFG (`cfg.py`), abstract stack analysis (`analysis.py`), handler source parsing (`sources.py`), catalog (`catalog.py`), scan, report and fixture assembler.
- `tools/luau/survey.py`, `commands.json` (1,081 commands), `REPORT.md`, `curation.json` (hand corrections of the generated catalogue: names, types, directions and the `tagged`, `copies` and `inout` marks).
- `tools/luau/test_*.py`, run through CTest as `Luau.Tools`, with `Luau.Survey`, `Luau.Transpile`, `Luau.Prune` and `Luau.Mutate` (`port/src/tests/cmake/luau.cmake`).
- The plan: `docs/port/luau-plan.md`. The user's decisions below override it.

M2 added the runtime: `port/cmake/luau.cmake`, `port/src/luau_runtime.{hpp,cpp}`, `port/src/luau_bindings.hpp`, `tools/luau/bindings.py`, `port/src/luau/lib/vm.luau` and `dc2data export-scripts`. M1 writes the transpiler in `tools/luau/stb2luau/` and its output in `port/src/luau/`.

## Verified

The recorded M3 results are under "M3 runtime" below. `ps2/` is unchanged by the migration (the effect program names 100 and 200 are a port enum, `EffectScriptProgram` in `port/src/effscript_port.hpp`); the PS2 build was not run.

## Research findings (needed to resume)

### VM (`ps2/src/runscript.cpp`)

- Opcodes run 1 to 30. Opcode 22 is a no-op label. LOAD and LOAD_ADDR take the address mode in `arg2`: LOCAL 0x1, LOCAL_INDEX 0x2, POINTER_INDEX 0x4, LOCAL_FLOAT 0x8, LOCAL_INDEX_FLOAT 0x10, POINTER_INDEX_FLOAT 0x20, GLOBAL 0x40, GLOBAL_FLOAT 0x200.
- A `*_FLOAT` LOAD retags the stored slot in place: the int bits are reinterpreted as a float. LOAD_ADDR does not retag.
- Binary operators pop rhs, then lhs. INT op INT wraps at 32 bits. If either operand is FLOAT, the result is FLOAT. STR and PTR operands exit.
- DIV checks the divisor's raw bits for zero before popping lhs, so a +0.0f divisor exits and -0.0f does not.
- MOD, AND, OR and NOT accept INT operands only.
- SIN and COS take radians and use `sinf`/`cosf`.
- FTOI truncates.
- `is_true` is false only for INT 0.
- `STORE` pushes its value back.
- JMP_TRUE and JMP_FALSE pop the condition. When the jump is taken and `arg2` is set, they push 1 or 0. In skip mode they do nothing and do not pop.
- EXT: `sp -= arg1`, then it calls `ext(sp, arg1)` unless skipping. The first slot is the command. Nothing is pushed; handlers write outputs through PTR slots.
- CALL: `frame = sp - arg`. Locals above the arguments are zeroed. RET resets `sp` to the frame and pushes the return value. A top-level RET sets `result` and `end`.
- WAIT suspends with pc on the next instruction. In skip mode it falls through.
- SKIP_END increments `skip_end_count`. If skipping, it clears the flag and suspends.
- PRINT formats INT with `%d`, STR with `%s` and FLOAT with `%f`, prints nothing for PTR, and adds no separator or newline.
- `run(no)` returns -1 when the program is missing, 0 when the script ended and 1 when it suspended. `no < 0` runs main.
- `load()` takes the SB2 globals from the start of the value array and zeroes them.
- `CRunScript` is 0x54 bytes on the PS2 (layout in `ps2/include/runscript.hpp`).

### Port overrides

- `port/src/runscript.cpp` overrides only `check_program` (null-safe) and `ext` (range check, then `script_guards::AllowExternal`, then "illegal function call").
- Overrides work per function: tag the definition `PORT_OVERRIDE` in `port/src`, and `unit_copy.py` strips the retail definition (docs/PC.md "How `port/src` takes precedence"). To retire the interpreter, override every member and the free helpers, but keep `rsGetStackInt` and `rsSetStack`.
- `script_guards` is in `port/src/script_guards.{hpp,cpp}`. It is also used by `event.cpp:118` (`GuardEventExternals`), `scriptinterpreter.cpp` and `command_replay.cpp`.
- `port/src/event.cpp:100-119` copies the event table and patches handler pointers before calling `ext_func`.
- Action, effect and monster tables are registered at `actscript.cpp:2617`, `effscript.cpp:786` and `5567`, and `event_func.cpp:2002` and `21813`.

### Loading and data

- `.stb` consumers in the port:
  - `dataread.cpp:226`: `ConvertScriptTiming` for every key ending in `.stb`
  - `dataread.cpp:452`: `DataReadScriptKeys`
  - `effscript.cpp:354/377/408`: `dungeon/eff_script/<name>.stb`
  - `monster.cpp:62`: `dungeon/monster/<name>.stb`
  - `tools/kazarov/port/platform/model_assets.cpp:2440-2456`: character scripts, returned as raw bytes
  - `dataread_port.hpp:56`: startup dry run of every `.stb`
- Script loading sites (partly verified):
  - **Action.** `CActionChara::LoadActionFile` (`ps2/src/actionchara.cpp:3210`) copies the bytes and calls `SetActionScript` (`actscript.cpp:2613`, 0x80 stack slots and 0x200 calls).
    - `InitScript` (`:3219`) runs INIT, then sets MAIN.
    - Each frame, `CActionChara::RunScript` (`:3248`) runs `prog_no` when `check_program` passes, otherwise resumes; when `end` is set it returns to MAIN. Its caller is `dng_main.cpp:2402`.
    - The paths come from `charasetup.cpp:219-221` (`mainchr/c01.stb`), `289-291` (`c02.stb`), `336-338` (`robo.stb`) and `355-365` (`dungeon/act_script/%s`, the monster model name), and from `menuchr.cpp` (5432-6127, `LoadFileBG` with built names; 5693 robo).
  - **Event.**
    - `EventLoop` (`ps2/src/event.cpp:282`) builds the path from `GetMapPath` and the name the script wrote, then tries `LoadFile2(file_path)` and then the directory.
    - `EntryEventScript` (`dng_main.cpp:~940-980`) loads `map/d/d0N/d0N_<lang>.stb` and its variants.
    - `mapjump.cpp` `LoadScript` (`:~390-436`) tries `<base>_<lang>.stb`, then the plain name; when neither loads it calls `SetEventScript(NULL, ...)`.
    - `script_guards.cpp:179-196` and `event_func.cpp:5937` append `_1`.
    - The port overrides `SetEventScript` at `port/src/event.cpp:96`.
  - **Event arguments.** `CEventScriptArg::BuildArgData` (`event_func.cpp:1961`) uses a local `CRunScript` and calls `run(100)`.
  - **Monster.** The port's `LoadReferMonsterFile` (`port/src/monster.cpp:28-74`) loads `dungeon/monster/%s.stb`. `SetMonsterScript` is at `runscript_opcodes.cpp:4676`, and the run and resume are at `runscript_opcodes.cpp:91-99`.
  - **Effect.** The port overrides `EffectScript(path)` (`port/src/effscript.cpp:183`, datapacks plus `script_timing::Apply`), `BuildPack` (`:326`), `LoadBaseEffSpt` (`:358`), `BuildBase` (`:381`) and `GetNeedFilePath` (`:402`). Retail `BuildPack` is at `effscript.cpp:644`.
  - **File layer.** `LoadFile` and `LoadFile2` (`port/src/dataread.cpp:738/746`) call `ResolveFile` (`~:260`), which runs `ConvertScriptTiming` on every `.stb`. `Lookup` (`:150`) checks the index, then `pack.json`, then datapacks.
  - The port does not override the action path (`LoadActionFile`, `SetActionScript`). `SetEffectScript` (`effscript.cpp:5562`: 0x40 stack slots, 2 calls) is called from `ps2/src/effscript.cpp:787` and `port/src/effscript.cpp:128`. `SetMonsterScript` is called from `monster.cpp:1251`, and the per-frame callers are `monster.cpp:2726` and `2811`. The other action callers of `InitScript` are `menuchr.cpp:2802, 4248, 6412` and `menusys.cpp:6844`.
  - `DataReadIndex` (`port/src/dataread.cpp:358`) mounts `<root>/../data.zip`, or `{data_root, <root>/../port_data}`. It then loads datapacks and calls `BuildIndex` (`:331`). The run-dir defaults are in `port/src/main.cpp:66`. `SaveSlotsRoot()` is `PathsSaveRoot() / "saves"` (`save_slots.cpp:325`).
  - Not yet checked: where `PathsSaveRoot`/`PathsDataRoot` are defined, and how `GetPackFile` parses effect pack members.
- Publication goes through the Kazarov extract pipeline in `tools/kazarov/src/rust/core.rs:335-367`: `native_scripts::convert_tree` migrates string operands (`migrate()`, `native_scripts.rs:341-394`), and `verify_tree` checks the result.
- `.stb` files reach `data.zip` through two routes:
  - the passthrough at `textures.rs:1003-1008`, as `data/<path>`
  - `models.rs:2944-2953/3038-3043`, as `port_data/<native path>`, listed in the character's `game.json` `resources.scripts`
- Changes to stop publishing `.stb` would touch those sites, `configs.rs:830` and the `publish.rs` tests.
- `tools/kazarov` is a submodule pinned at `c4745a7`. Its checkout already has **another session's uncommitted edits**, including `native_scripts.rs`. docs/PC.md "The shared-code pin": changes land in the Kazarov main line first, both games must pass on that commit, and only then is the gitlink moved. A game never edits the submodule checkout in place.
- Existing subcommands: `extract`, `list`, `sound`, `check`, `pack` and `current`; anything else prints the usage and exits 2.
- The bridge also exposes `setup_data`, `archive_entry_name`, `archive_entry_size`, `archive_entry_crc`, `archive_entry_stored`, `archive_entry_data_offset`, `archive_read_entry` (CRC-checked) and `png_decode_rgba`. `export-scripts` can read the published scripts with these.
- Other port code that asks for `.stb` by exact path and must be redirected to Luau:
  - `dataread.cpp:452` (`DataReadScriptKeys`)
  - `effscript.cpp:354, 377, 408`
  - `monster.cpp:62`
  - `platform/model_assets.cpp:2440-2456`
  - the hard-coded paths in `script_timing_inventory.inc`
- `tools/dc2data/main.cpp:42-93` dispatches subcommands through an if-chain. It calls the cxx bridge in `tools/kazarov/src/rust/lib.rs`. `export-scripts` needs a new bridge function, or it can use the existing `open_archive`/`archive_read_entry` bridge with the migration applied at extraction.

### Build

- Windows has no CMake presets. `build.bat windows-x64` runs `tools/windows/configure.ps1` with llvm-mingw clang and Ninja from `.kazarov/windows/deps` into `port/build/windows-x64` (Debug, tests off). The test build is `port/build/windows-x64-tests` (docs/PC.md "Windows").
- `port/CMakeLists.txt` includes every `port/cmake/*.cmake` through a glob, so a new `luau.cmake` there is picked up automatically.
- Pinned dependencies use `FetchContent_Declare(... URL ... URL_HASH SHA256=... DOWNLOAD_EXTRACT_TIMESTAMP TRUE)`, as in `tools/kazarov/cmake/KazarovGltf.cmake`.
- `ninja`, `clang`, `7z`, `stylua` and `luau` are not on the shell PATH. Python 3.11.9 is.

### Action corpus

- 27 files: `dungeon/act_script/*.stb` (24) and `mainchr/c01.stb`, `c02.stb` and `c02.stb_`.
- Usage: 78 registered commands used, 6 unregistered numbers called, and 3,894 EXT sites.
- No skip mode; 277 WAITs.
- Per-command arities: `tools/luau/commands.json` (kind `action`).

## Decisions (binding, from the user)

1. Sources go in `port/src/luau/<original path>.luau`, written as readable native Luau, and ship loose in `<game root>/scripts` (dev: `port/run/scripts`), copied by the build or install.
2. Vendor luau-lang/luau as a pinned FetchContent tarball with SHA-256 in `port/cmake/luau.cmake`. Enable Luau.CodeGen (JIT) where supported.
3. Transpile the NTSC-normalized scripts: port the `script_timing` recipes to Python and assert the inventory counts.
4. Add `dc2data export-scripts <dir>`. The survey and the transpiler read its output instead of 7-Zip.
5. Auto-generated helper names are acceptable.
6. No `.stb` bytes in extraction or publication. The file layer maps `.stb` requests to Luau modules.
7. Use native Luau numbers, with helpers only where integer or float semantics differ observably.
8. Type aliases `s8 u8 s16 u16 s32 u32 f32` go in `port/src/luau/api/*.d.luau`. PRINT becomes `print`.
9. (2026-10-24) Where a script passes a reference and the handler reads that slot as a value, as with CopyVector and the other M3 fallbacks, Luau passes the referenced variable's value. This is an accepted behaviour change that lets the interpreter be retired completely.
10. (2026-10-24) Keep the structured, readable transpiler. The VM-arena emulation in stash@{0} is abandoned. The end goal is scripts that read like hand-written native Luau, with correct names.

Coordinator design choices (implemented):

- `require` aliases go in `port/src/luau/.luaurc` (`@lib/...`).
- `vm` should be a Luau library, so the harness and the game share it.
- The differential harness runs Luau through a small C++ host built against the vendored Luau. The luau CLI sandboxes each required module's globals, which makes mocking the API namespaces awkward.

## Next steps

### M1, transpiler (`tools/luau/stb2luau/`)

Done for the action kind. `docs/PORT_LUAU.md` "Transpiler" describes the pipeline.

- Built:
  - `tools/luau/stb2luau/`: `refvm.py`, `timing.py` (+ `timing_inventory.json`), `ir.py`, `lift.py`, `structure.py`, `emit.py`, `numbers.py`, `api.py`, `harness.py`, `transpile.py` (CLI), `toolchain.py`.
  - `tools/luau/programs.json` (program names), `tools/luau/toolchain.json` (Luau 0.740 and StyLua 2.5.2 binaries), `tools/luau/harness/` (`luau-check` and `luau-harness`, own CMake, Luau 0.740).
  - The tests `test_refvm`, `test_timing`, `test_lift`, `test_structure`, `test_emit`, `test_api`, `test_harness`, `test_transpile` and `test_programs`. They run in `Luau.Tools`, and CTest `Luau.Transpile` runs `transpile.py --check --harness`.
- Output: `port/src/luau/{mainchr,dungeon/act_script}/*.luau` (27 modules), `lib/action/helper_*.luau` (20 shared helpers), `api/*.d.luau` for every kind, `.luaurc` and `manifest.json`.
- Gate, run with `python tools/luau/stb2luau/transpile.py --data port/run/data.zip --harness --seeds 32`:
  - 27 of 27 scripts transpile, and `luau-check` (strict, lint as errors) reports 0 errors.
  - 13,824 of 13,824 harness scenarios are trace-equal to their end, with 86.4% mean instruction coverage of the reference runs and 86.4% of what was compared. Coverage is lowest for the player scripts: 45% for `mainchr/c01`, 38% for `c02`. Their deep state-machine states need longer, input-driven runs.
  - M2's eight replays gave screenshots identical to the interpreter's with the modules before named handlers. The rerun with the current modules is M2's.
- Known approximations (documented in the contract):
  - M1 emitted float literals as unrounded decimals. M3 rounds literals and arithmetic to float32; the current numerical limits are in `docs/PORT_LUAU.md` under "Numbers".
  - Integer arithmetic wraps where the interval analysis cannot keep it inside 32 bits. A product of two integers beyond 2^53 loses its low bits in `vm.i32`, since Luau multiplies doubles.
  - A reference passed where a handler reads a value (`ProgSet` in `c01win`/`f204a`) is refused, and those scripts stay on the interpreter (see M3 runtime).
- Open:
  - Curate the auto names (`helper_<hash>`, `varN`) in M5.
  - Direct `data.zip` input still uses 7-Zip. The transpiler also accepts a directory produced by `dc2data export-scripts`, avoiding that dependency.

### M3/M4 transpilation (effect, monster, event)

Measured with `transpile.py --data <dc2data export-scripts directory> --kind <kind> --check --harness --seeds 32` on the published corpus at the end of M3 (`docs/PORT_LUAU.md` "Transpiler" describes references, arrays and the harness). The event rows are from the start of M3 and are M4's starting point.

| Kind | Transpile | `luau-check` | Harness (32 seeds) | Mean coverage, reference / compared |
|---|---|---|---|---|
| `action` | 25 / 27 (2 on the interpreter) | 0 errors | 13,056 pass, 0 fail | 87.2% / 87.2% |
| `effect` | 252 / 254 (2 on the interpreter) | 0 errors | 62,168 pass, 232 prefix only (step budget), 0 fail | 96.0% / 96.0% |
| `monster` | 59 / 144 (85 on the interpreter) | 0 errors | 45,050 pass, 70 unsupported, 0 fail | 76.9% / 76.9% |
| `event` | 536 / 969 (433 on the interpreter, below) | 0 errors | 39,301 pass at 2 seeds, 0 fail (the 32-seed run is under "M4 transpiler") | 64.2% / 64.2% |
| `event_arg` | 5 / 5 (data modules) | 0 errors | 5 pass (checked against the reference machine's calls) | |

"Pass" means the trace matched to its end. "Prefix only" means the reference run exceeded its step budget and the trace matched up to its last event; nothing the module does after that is checked, so these 232 effect scenarios are not passes. "Unsupported" means the trace matched up to an access the translation does not model, after which it diverges from retail. An unsupported cut is accepted only where the module raises `vm.index`'s out-of-frame error (see `docs/PORT_LUAU.md` "Transpiler"). Integer arithmetic that may overflow 32 bits wraps (`vm.i32`, or `vm.wrap` for mixed types), which also changes two action counters (see "Action behaviour changes" below).

- **References and arrays** cover the action, effect and monster corpus, with known gaps. Every pointer index in the corpus is `*p` (index 0) on a parameter, so a reference parameter is copied in and back. Copying cannot express retail's retagging, where a callee's float load reads an integer's bits in its caller's variable. So emission refuses the integer values that could reach a float load that way (none in these kinds); native outputs follow the tag analysis (M3 runtime). The interval analysis does not track array elements. Computed local indices make their array a table; only `dungeon/monster/b02a1.stb` `0x1a80` (an index from a native output) needs its whole frame as one table. Its `var1[var10 - 1] = var11` takes `var10` from `VPop`. When the harness's `VPop` returns a value past the array (17, in scenario `900/s1`), retail stores into the operand stack and goes on (68 scenarios, store at `0x1ca4`). When the value is below it, retail indexes into the caller's frame (2 scenarios, `0x1c8c`). In both cases the translation's `vm.index` raises an error, so these 70 scenarios are compared only up to the access and are reported as unsupported. In the game, `VPop` returns what the script pushed; whether those values always stay inside the frame has not been established. Remaining for M4: 142 event call sites pass a reference to a parameter the callee does not dereference (it forwards the pointer as a value), which the lifter refuses, and 48 lifted event scripts emit consecutive `break`s after a `break` (the structurer keeps unreachable statements), which StyLua rejects.
- **Skip mode** (M4, done for 536 event scripts; see "M4 transpiler").
- **Program names.** Effect program 200 (`EffectScriptProgram::Start`, `on_start`) runs every effect from its creation; 100 (`EffectScriptProgram::Init`, `init`) is defined empty everywhere and never run. Both are named in the port's `EffectScriptProgram` enum. Monster programs are all named.
- **Shared code.** Event scripts embed a large common library. The shared-helper pass puts the helpers that touch no globals in `lib/event` (1,796 modules); a helper that touches globals stays a local function.
- The harness `STATE` table has the effect, monster and event entries (event: `SetFlag`/`GetFlag`, `SetLocalFlag`/`GetLocalFlag`, `SetNpcStatus`/`GetNpcStatus`, `SetEventData`/`GetEventData`, `SetOmakeFlag`/`GetOmakeFlag`, `SphidaSetParCount`/`SphidaGetParCount`).

### M4 transpiler (2026-10-24)

Contract: `docs/PORT_LUAU.md` "Runtime contract" (skip mode, argument scripts). The measurements below are from the final tree.

- **Done.**
  - SKIP_END lifts (`ir.SkipEnd`) and is lowered by `stb2luau/skip.py` to `vm.section(body, skip)`, `vm.guard(body, tail)`, `at = n` / `vm.wait(n)`, per the contract. A call in skipped code runs a synthetic twin of its callee (the callee's body with jumps, external calls and waits removed, up to its first RET).
  - The 142 call sites that pass a reference to a parameter the callee never reads pass the constant 0 instead.
  - Dead statements after a `break`, `continue`, `return` or `end` (and after an `if` whose branches all leave) are pruned in `structure.py`; no StyLua failures remain.
  - The harness exercises skip mode: event scripts get `<scenario>/k<n>` variants that skip at the first suspension at each of up to 12 distinct waits, comparing the prints, the suspension at the skip end (or the end of the script), the skip-end count and the final globals. A variant in which the reference machine would call `exit(-1)` (stack overflow, division by zero in the skipped code) has no behaviour to match and is left out; the count is in the harness result as `retail_exits`.
  - `lib/vm.luau` has `vm.wait(site)`, `vm.section`, `vm.guard` and `vm.skip_end` on `vmhost`; `tools/luau/harness/host.cpp` has the same `vmhost` table, with `set_skipping`, `skip_end_count` and `reset` for the driver.
  - Argument scripts are data modules (`stb2luau/event_args.py`), verified by running program 100 on the reference machine.
  - Event program names: `programs.json` has an `event` kind with one entry per program number in the corpus (325), `event_<n>` except 18 numbers the engine gives a meaning (`default_event` 100, `key_open` 150, `close_door` 249, ... `sphida_shot` 3000). Numbers are data, so most have no engine meaning.
  - Catalogue: `tools/luau/curation.json` marks the positions the handler reads by the slot's tag as `unknown` (MesMake, EsmLoadBase, SetLoadbgFile, EohSyncObj, SndLoadSound, MapJump, FuncPointShow, EohSyncFuncp). A command with an `unknown` input uses its suffixed names (`event.SndLoadSound_2`), since the unsuffixed overloads are ambiguous in Luau. Script strings are UTF-8 with a checked CP932 round trip.
  - Other emitter fixes found by the event corpus: a library's return value is taken into account at every call site (a script that never uses it still receives it), a discarded output (a value passed where the handler writes) still occupies its return slot, an entry with a numeric return returns on every path, and a statement with several calls that may wait notes each one.
- **Refused (433 scripts on `fallback.json`).**
  - 403 scripts: skip mode would enter a callee whose linear run reaches a skip end before its return (379 scripts name one callee, 24 reach it through another). Retail then suspends inside that callee and, afterwards, the caller carries on normally from the middle of its structured body. The structured Luau cannot enter the middle of a body. Of them, 156 have every such call at the top level of its function, where the rest of the body could be duplicated as a continuation; 279 have one in a branch or loop. This needs a user decision (below).
  - 12 scripts index an array in skipped code; 6 use the result of the call skip mode was suspended in, whose callee is not guarded; 6 pass a reference to `GeoramaFunc`'s output that is selected by a constant argument (the catalogue has one direction per position); 6 pass a string where `ObjsTexAnime` reads `on` as a number (the handler reads the string's address, a script bug).
- **Decisions for the user.**
  1. The 403 callee-skip-end scripts: leave them on the interpreter, or build a way to re-enter structured bodies (a resumable entry per call, or the VM-arena emulation of the abandoned attempt).
  2. `GeoramaFunc` and `GetFishingtournamentEtc` take a reference or a value at one position depending on a constant first argument; supporting both needs a per-site direction in the catalogue.
- **Measured.** `transpile.py --kind event --kind event_arg --check --harness --seeds 2`: 541 of 974 transpile (536 event, 5 argument), 433 stay on the interpreter, 0 fail, `luau-check` 0 errors, 39,301 scenarios pass, 0 fail, mean coverage 64.2%. The 32-seed run and the action, effect and monster re-run follow in "M4 results". Python tests: 350, OK.

### M3 runtime (done)

- Catalogue: tag-reading parameters are `tagged` (Int and Float variants), bit-copying tagged outputs (VPop, VPop2, GetValue) `copies`, the vector commands' read-and-written parameters `inout`. Every output type was audited against the `SetStack` overload clang resolves in its handler; that fixed GetNoDamageCnt (s16, was f32), GetGekirin (float, was s32), action CheckMosEnd (float) and six `unknown` outputs, and made inputs of arguments handlers read (monster CheckPause, GetEventInfo, MonsSeLoop, GetIndexPos, SetNextPos, SetStatus; action Shot, which robo passes a value).
- Numbers: float32 arithmetic (`vm.f32`), and SIN/COS through the C library's `sinf`/`cosf` (`cmath`, registered by the runtime and the harness host; refvm calls them through `ctypes`).
- Native outputs: `stb2luau/tags.py` follows slot tags and the reads each output reaches; outputs are reinterpreted (`vm.bits_float`, `vm.float_bits`) where the handler writes the other type than the variable holds, tagged variants follow the tag the handler branches on, and ambiguity is refused.
- Fallback (`tools/luau/fallback.json`, 89 scripts: 85 monster, 2 effect, 2 action): a reference whose slot a handler reads as a value, where the PC interpreter reads the low bits of an address that changes from run to run (CopyVector through a shared move helper in 73 monsters, GetEventInfo in b02a2-b02a7, SetStatus, CheckPause, SetPos in Dark Element b11a, ProgSet in c01win and f204a); GetRand outputs read both ways (e110pol1, e732_snow); and Monster Gaspard's GetMonsterLife (p00_23a), whose destination holds an integer tag on the loop's first pass and a float afterwards. These run on the interpreter, as before M3.
- Harness qualification: native inputs compare as the slots their handlers read (tag and payload where the handler reads the tag, the converted value where it reads through `GetStackInt`/`GetStackFloat`, exact float32 bits with the sign of zero and NaN payloads), and `stb2luau/mutate.py` (CTest `Luau.Mutate`) checks that every reached change of a native argument in eight sample scripts fails the harness.
- Action behaviour changes. Every action module was regenerated, and some of what they do changes to correct differences from the PC interpreter (the replays compare the PC paths; they do not establish full PS2 runtime equivalence): robo passes `Shot` the value it reads (`global0` or 0) where the module passed an output; `f114a` and `f213a` pass `EsmSetValue` 12.0 and 10.0 as floats, which the handler stores by tag; the counters in `mainchr/c01` and `robo` wrap at 32 bits; float constants and arithmetic are float32 and SIN/COS use `sinf`/`cosf`; `CheckMosEnd`'s output is read as the float its handler writes; and `c01win` and `f204a` are back on the interpreter.
- Measured with `transpile.py --kind action --kind effect --kind monster --check --harness --seeds 32`: 336 transpiled, 89 kept on the interpreter, 0 failed; `luau-check` 0 errors; harness 120,274 pass, 232 prefix only, 70 unsupported (b02a1), 0 fail (per kind in the table above). Mutation sweep: every reached mutation killed (2,794 at the last count, over eight scripts). Python tests: 329, OK.
- Replays of the M3 tree (`DC2_SCRIPT_VM=interpreter` against Luau, Release, headless, two instances at a time, 35 checkpoints): `jump-dungeon-floor1`, `area-dungeon-combat` (3000-5100), the boss-event jumps 12570 (Rainbow Butterfly), 17160 (Emperor Griffon) and 17280 (Dark Element), and the boss sweeps 04, 18 and 24. Every screenshot is byte-identical and the filtered logs match, with no Luau errors.
- Replays at `b022f3008`, before the review fixes that followed (`DC2_SCRIPT_VM=interpreter` against Luau, Release, headless, two instances at a time, 103 checkpoints): `jump-dungeon-floor1`, `area-dungeon-combat` (3000-5100), `area-dungeon-ranged`, `area-dungeon-floor2` (to 10800), `ridepod-floor1`, `monica-opening-combat`, `quick-change-monica`, `dungeon-mouse-carry`, `perf-ocean-walk`, a walk-and-attack run on each dungeon's first floor (`--skip-events --invincible --seed 1234`), boss-event jumps 12570, 15280, 17160 and 17280, and the boss sweeps 00 (Linda, e214a2), 01, 02, 03, 04 (Rainbow Butterfly, b02a), 05, 08, 10, 15, 18 (Emperor Griffon, b08a, fighting Max), 20 and 24 (Dark Element, b11a on the interpreter, b11a_moon on Luau). Every screenshot is byte-identical; logs match once addresses, memory sizes, shader progress and `script timing` lines are removed. Monster Gaspard was not reached by any replay; it stays on the interpreter.
- Open: the `folded` plumbing of the harness is redundant now that refvm runs in float32. Most monsters stay on the interpreter until a decision on the CopyVector references: reproduce the original pointer-derived reads, or pass the referenced coordinate values the scripts appear to intend. The PC interpreter reads run-dependent PC address bits there, which do not establish the PS2's numerical results.

### M2, runtime (done for the action kind)

Action, effect and monster scripts run on Luau (effect and monster since M3); event scripts still run on the interpreter. `docs/PORT_LUAU.md` "Runtime" describes the implementation.

- Done:
  - `port/cmake/luau.cmake`: Luau 0.740 (VM, Compiler, CodeGen linked; `ct_luau_tools` builds `luau-analyze` and `luau-compile`).
  - `port/src/luau_runtime.{hpp,cpp}` and the `CRunScript` overrides in `port/src/runscript.cpp`, with retail bridges for the interpreter fallback.
  - The binding generator `tools/luau/bindings.py`.
  - The `.stb`-to-module handle in `ResolveFile`.
  - The script copy to `scripts/` and its install rule.
  - The `print` global and the `vm` library (`port/src/luau/lib/vm.luau`).
  - `DC2_SCRIPT_VM=interpreter`.
  - Named handlers: `script.setup` and the `tools/luau/programs.json` names, generated per kind by `bindings.py --programs`.
  - `dc2data export-scripts`, which `survey.py --dc2data` and the `Luau.Survey` test use in place of 7-Zip.
- Verified on Windows (release, codegen on): with M1's 27 named-handler modules and their 20 `lib/action` helpers, the end-frame screenshots of the interpreter and Luau runs are byte-identical for these replays:
  - `jump-dungeon-floor1` (2300 frames)
  - `dungeon-mouse-play` (2750)
  - `area-dungeon-combat` (5100)
  - `area-dungeon-ranged` (3300)
  - `dungeon-mouse-carry` (2374)
  - `monica-opening-combat` (4200)
  - `quick-change-monica` (1000)
  - `ridepod-floor1` (2850)

  The last three replays are new in `tools/input`. The interpreter is deterministic run to run. The `LuauRuntime.*` facade tests (18) and the full Windows suite pass; the only failures were two load-sensitive timeouts that pass on rerun. The Linux container build passes `LuauRuntime.*` when its build directory is inside the container; a build directory on the Windows bind mount fails extracting simdjson, which is unrelated.
- Left:
  - **Publication.** Dropping `.stb` from publication (decision 6) requires migrating event scripts (M4) and all scripts in `fallback.json`. These interpreter users still need the `.stb` bytes, NTSC validation and `script_timing`. The Kazarov sites are listed under "Loading and data".
  - **Interpreter.** The interpreter, `script_timing` and the `Set*Script` stack allocations stay until M6.
  - **Other kinds.** M3 did effect and monster (kinds, prefixes, `EffectScript` and `GetPackFile` members). M4 must add the event kind and its prefixes, map the language fallbacks and script-built names through `ModuleForScript`, and implement skip mode (`CRunScript::skip` currently resumes) and argument scripts.
  - **macOS.** macOS has not been built with Luau; CI covers it.
  - **Packages.** The Windows zip (`tools/windows/package.ps1`), the macOS tarball (`pc.yml`) and the Flatpak (through CMake's install) ship `scripts/`; the zip and the tarball still leave out `glyphs/`. A build removes the copies it made of modules the transpiler no longer generates, and an install the modules it installed (`port/cmake/scripts/luau_prune.cmake`, which keeps a manifest of what it copied and leaves alone any file it did not copy or that was changed since). The runtime also never loads a module for a script on `tools/luau/fallback.json`, even if an old copy is present.

### Later coordinators

M4 (events: skip mode, argument scripts, dynamic names) is next, then M5 (naming curation) and M6 (retire `script_timing` and the interpreter, CI gates). See the plan's milestone table; the decisions in this file override the plan.

## Resuming

Start with "Handoff (2026-10-25)" at the top of this file, then `docs/PORT_LUAU.md` (Runtime contract) and the plan. The sections between are milestone records, kept for reference.

## M4 runtime (2026-10-24)

Done (runtime side; the transpiler side is separate):
- `event` and `event_arg` are in `CT_LUAU_KINDS`; `kScriptPrefixes` maps `map/`, `dungeon/sys_script/` and `event/` to `event` after the nested `event/tbox/` effect rule, and `IsEventArgumentModule` maps `event/**/*_arg*` to `event_arg`.
- Loading-site census: every site (EventLoop, `EntryEventScript`, `mapjump.cpp` `LoadScript`, the `_1` names of `_LOAD_SCRIPT`, `_LOAD_ARG` through `GetLoadBGBuff`, `SetEventScript`) reaches `ResolveFile` through `LoadFile`, `LoadFile2` or `LoadFileBG`, which already asks `ModuleForScript`; no per-site change was needed. A missing module falls through to the `.stb`, preserving the language fallbacks and the interpreter.
- Skip mode, native side: `vmhost.skipping()` and `vmhost.skip_end()`, the skip check in the binding shims, `CRunScript::skip` via `luau_runtime::Skip`, and the reset in `run()`/`load()` (docs/PORT_LUAU.md "Runtime", "Skip mode (native side)").
- Argument scripts are data modules (array of `{command, args = {{type, value}}}`): `CEventScriptArg::BuildArgData` is a `PORT_OVERRIDE` in `port/src/event_func.cpp` that reads them with `luau_runtime::ReadEventArgData` and builds the lists natively (retail body kept as `PortRetailBuildArgData`, a `RETAIL_BRIDGES`/`header_fixups.py` entry). No `CRunScript` instance is created, so nothing leaks.
- Native outputs are nil while skipping, and nested `require` helpers run in the instance sandbox (regression test added).
- `LuauRuntime.*` (33) and `EventArgData.*` (4) pass in `port/build/windows-x64-tests`. Full suite: only load-sensitive timeouts and one transient `Luau.Survey` failure, all passing on rerun.
- Not taken from the abandoned stash: persistent bytecode cache and hot reload, the `dc2data` script-policy refactor (needs the Kazarov bridge), and the VM-reference test additions.

Open:
- Replays comparing `DC2_SCRIPT_VM=interpreter` with Luau on events have not been run (handoff next step 2).
- The Luau side's sentinel must be a non-string error value; a string error while skipping is logged as a failure.
- Run `ctest -R LuauRuntime` after the transpiler's `vm.luau` lands; the facade tests copy the real `vm.luau`.
- Later (user decision): pass the referenced variable's value to handlers reading a reference slot as a value for the 89 fallback scripts, so M6 can retire the interpreter. Nothing in the runtime blocks it.
