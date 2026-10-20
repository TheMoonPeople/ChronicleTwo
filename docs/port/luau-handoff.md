# Luau migration handoff

Status: M0 is complete. M1 (transpiler) and M2 (runtime) are complete for the action kind; see their sections below. M3 (effect and monster) has its transpilation done: every effect and monster script transpiles and checks, and every harness scenario matches up to its end or its cut. 70 monster scenarios, all in `dungeon/monster/b02a1.stb`, reach an access outside the frame that retail allows and the translation does not model (see the M3 section). Their modules are not yet in `port/src/luau`, since the runtime does not load those kinds yet. M4 (event) is next after the M3 runtime step.

## What exists

- `docs/PORT_LUAU.md`: script kinds, tools and catalog, plus a draft **Runtime contract** section. That section is the agreement between the transpiler and the runtime.
- `tools/luau/stb/` (M0): decoder (`program.py`), CFG (`cfg.py`), abstract stack analysis (`analysis.py`), handler source parsing (`sources.py`), catalog (`catalog.py`), scan, report and fixture assembler.
- `tools/luau/survey.py`, `commands.json` (1,081 commands), `REPORT.md`, `curation.json` (empty).
- `tools/luau/test_stb.py`: 20 tests. They run through CTest as `Luau.Tools` and `Luau.Survey` (`port/src/tests/cmake/luau.cmake`).
- The plan: `docs/port/luau-plan.md`. The user's decisions below override it.

M2 added the runtime: `port/cmake/luau.cmake`, `port/src/luau_runtime.{hpp,cpp}`, `port/src/luau_bindings.hpp`, `tools/luau/bindings.py`, `port/src/luau/lib/vm.luau` and `dc2data export-scripts`. M1 writes the transpiler in `tools/luau/stb2luau/` and its output in `port/src/luau/`.

## Verified

- `python -m unittest discover -s tools/luau -p "test_*.py"`: 20 tests, OK (2.3 s).
- `.\build.bat windows-x64` (incremental, `port/build/windows-x64`): exit 0 in 107 s. It recompiled the Kazarov Rust crate and relinked `dc2data.exe` and `darkchronicle.exe`. The PS2 build was not run, since nothing under `ps2/` changed.

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
  - Float literals are the shortest decimal, so a comparison with an engine float that equals a literal's exact float32 can differ from retail.
  - Integer arithmetic wraps where the interval analysis cannot keep it inside 32 bits. A product of two integers beyond 2^53 loses its low bits in `vm.i32`, since Luau multiplies doubles.
  - A reference passed where a handler reads a value (`ProgSet` in `c01win`/`f204a`) passes the variable's value, where retail passed the pointer's bits.
- Open:
  - Curate the auto names (`helper_<hash>`, `varN`) in M5.
  - `action.NowMosChgwait`'s output is `unknown` in the catalogue.
  - `transpile.py` still reads `data.zip` through 7-Zip. It could take `--dc2data` as `survey.py` now does.

### M3/M4 transpilation (effect, monster, event)

Measured with `transpile.py --data <dc2data export-scripts directory> --kind <kind> --harness --seeds 32` on the published corpus (`docs/PORT_LUAU.md` "Transpiler" describes references, arrays and the harness):

| Kind | Transpile | `luau-check` | Harness (32 seeds) | Mean coverage, reference / compared |
|---|---|---|---|---|
| `action` | 27 / 27 | 0 errors | 13,824 pass | 86.4% / 86.4% |
| `effect` | 254 / 254 | 0 errors | 62,680 pass, 232 prefix only (step budget), 0 fail | 96.0% / 96.0% |
| `monster` | 144 / 144 | 0 errors | 114,042 pass, 70 unsupported, 0 fail | 71.5% / 71.5% |
| `event` | 251 / 969 lift | not run | blocked, see below | |
| `event_arg` | 5 / 5 | | | |

"Pass" means the trace matched to its end. "Prefix only" means the reference run exceeded its step budget and the trace matched up to its last event; nothing the module does after that is checked, so these 232 effect scenarios (skipped uncompared before the review fixes) are not passes. "Unsupported" means the trace matched up to an access the translation does not model, after which it diverges from retail. An unsupported cut is accepted only where the module raises `vm.index`'s out-of-frame error (see `docs/PORT_LUAU.md` "Transpiler"). Since integer arithmetic that may overflow wraps, two checked-in action modules each wrap one global counter (`mainchr/c01`, `robo`); the other action modules are unchanged. `luau-harness` must be rebuilt from `tools/luau/harness` for these runs, since the host now restarts its interrupt count when it raises the budget error. `port/src/luau/lib/vm.luau` gained `vm.wrap`, which effect and monster modules use where a sum typed `any` may overflow; the runtime ships it with the other `vm` helpers.

- **References and arrays** cover the action, effect and monster corpus, with known gaps. Every pointer index in the corpus is `*p` (index 0) on a parameter, so a reference parameter is copied in and back. Copying cannot express retail's retagging, where a callee's float load reads an integer's bits in its caller's variable. So emission refuses the integer values that could reach a float load that way (none in these kinds), but a native output that writes an integer into a variable the script reads as a float still depends on the runtime typing that output as the script reads it. The interval analysis does not track array elements. Computed local indices make their array a table; only `dungeon/monster/b02a1.stb` `0x1a80` (an index from a native output) needs its whole frame as one table. Its `var1[var10 - 1] = var11` takes `var10` from `VPop`. When the harness's `VPop` returns a value past the array (17, in scenario `900/s1`), retail stores into the operand stack and goes on (68 scenarios, store at `0x1ca4`). When the value is below it, retail indexes into the caller's frame (2 scenarios, `0x1c8c`). In both cases the translation's `vm.index` raises an error, so these 70 scenarios are compared only up to the access and are reported as unsupported. In the game, `VPop` returns what the script pushed, which presumably stays inside the array; that has not been checked. Remaining for M4: 142 event call sites pass a reference to a parameter the callee does not dereference (it forwards the pointer as a value), which the lifter refuses, and 48 lifted event scripts emit consecutive `break`s after a `break` (the structurer keeps unreachable statements), which StyLua rejects.
- **Skip mode** (M4). `SKIP_END` lifts to an error today. Emit `vm.section`/`vm.skip_end` per the contract, and teach `refvm` scenarios to call `skip()`.
- **Program names.** Effect programs 100 and 200 occur in every effect script, but `EFFECT_SCRIPT_PROG` names only 300. Add them to the enum and `programs.json`. Monster programs are all named.
- **Shared code.** Event scripts embed a large common library (one body occurs in all 969 files). The shared-helper pass already handles that shape.
- The harness `STATE` table has the effect and monster entries (`VPush`/`VPop`, `VPush2`/`VPop2`, `SetBitFlag`/`GetBitFlag`, `SetValue`/`GetValue`); event needs its own.
- **For the M3 runtime step.** Some handlers write an integer or a float regardless of the catalogue's output type: effect `GetRand` follows its range's type (68 effect and monster sites pass an integer range into an integer variable while the catalogue says `f32`), and monster `VPop`/`VPop2` and effect `GetValue` follow the type of the variable they write. The runtime seeds output slots with its own tag and reads them by the catalogue type, so these sites need the variable's type from the transpiler (or curated types) to return the value the script reads. Effect programs 100 and 200 are still unnamed (`script[100]`, `script[200]`).

### M2, runtime (done for the action kind)

Action scripts (Max, Monica, the Ridepod and monster transformations) run on Luau; every other kind still runs on the interpreter. `docs/PORT_LUAU.md` "Runtime" describes the implementation.

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
  - **Publication.** Dropping `.stb` from publication (decision 6) is deferred until the event kind runs on Luau (M4). Effect, monster and event scripts still need the `.stb` bytes, the NTSC validation and `script_timing`. The Kazarov sites are listed under "Loading and data".
  - **Interpreter.** The interpreter, `script_timing` and the `Set*Script` stack allocations stay until M6.
  - **Other kinds.** M3 and M4 must:
    - add their kinds to `CT_LUAU_KINDS` (`port/cmake/luau.cmake`) and their data-key prefixes to `kScriptPrefixes` in `luau_runtime.cpp`;
    - name effect programs 100 and 200, which `EFFECT_SCRIPT_PROG` leaves unnamed;
    - map pack members (`effscript.cpp` `GetPackFile`), the language fallbacks and script-built names through `ModuleForScript`;
    - implement skip mode (`CRunScript::skip` currently resumes) and argument scripts.
  - **Catalogue.** `action.NowMosChgwait`'s output is `unknown` in the catalogue, although its handler writes a float. The runtime reads unknown outputs by their bits, so curate it as `f32` in `tools/luau/curation.json`.
  - **macOS.** macOS has not been built with Luau; CI covers it.
  - **Packages.** The Windows zip (`tools/windows/package.ps1`) and the macOS tarball (`pc.yml`) ship neither `scripts/` nor `glyphs/`, so those packages run the action scripts on the interpreter. The Flatpak installs both through CMake. Add `scripts/` to both packages before the interpreter is retired.

### Later coordinators

M3 (effects and monsters), M4 (events: skip mode, argument scripts, dynamic names), M5 (naming curation), M6 (retire `script_timing` and the interpreter, CI gates). See the plan's milestone table.

## Resuming

Start a coordinator with this file, `docs/PORT_LUAU.md` (Runtime contract) and the plan. Confirm the action-script loading sites (`CActionChara`, `SetActionScript`) first, and finish the loading-site census, since the census was interrupted. Then dispatch M1 steps 1-2 and the M2 step 1 vendoring in parallel. They touch disjoint files.
