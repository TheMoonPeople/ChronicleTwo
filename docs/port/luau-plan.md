# Plan: replace the bytecode script VM with Luau (PC port)

The milestone plan for the Luau migration. The binding user decisions in docs/port/luau-handoff.md override it where they differ (source location, NTSC-normalized input, export-scripts, no .stb publication, native numbers, type aliases, print).

Produced by a Fable planning pass; key code references spot-checked. Nothing in the repository has been modified.

## 1. Findings

### One VM, one format, four kinds of script
- Single VM: `CRunScript` (`ps2/include/runscript.hpp:232-451`, `CRunScript::exe` at `ps2/src/runscript.cpp:327`).
- "SB2" and "STB" are not two formats. They are two values of `RS_PROG_HEADER::magic`: SB2 is v2 and has a global-variable block, STB is v1 without one. The corpus has 1,390 SB2 files and 9 STB files.
- The kinds differ only in which external-function table is registered:

| Kind | Registration | Native commands | Files | Driver |
|---|---|---|---|---|
| Action (player, Ridepod, transformations) | `SetActionScript` actscript.cpp:2613, `ACTION_EXT_NUMBER` | 82 handlers, 32 used | 27 | `CActionChara` prog_no state machine (programs 100/150/200/500/550/600/700/1400/1500) |
| Effect | `SetEffectScript` effscript.cpp:5562 | 128 handlers | ~256 | `CEffectScriptMan::Step`, programs 200/300 |
| Monster | `SetMonsterScript` runscript_opcodes.cpp:4676 | 173 handlers, 93 used | 144 | `CMonsterMan::RunScript`, programs 100..1200 |
| Event (town, dungeon, menus, cutscenes) | `SetEventFunc` event_func.cpp:21780 | 698 commands | ~970 | `EventLoop`: `resume()` once per frame, `RunEvent`, `SkipEvent` |
| Argument scripts (data) | `CEventScriptArg::BuildArgData` event_func.cpp:1961 | 2 | a few `*_arg.stb` | run synchronously to build `ARG_DATA` lists |

### Instruction set and values
- Instructions are 12 bytes. There are 29 opcodes. Opcode 22 is a compiler-emitted label marker that does nothing at run time. Values are tagged INT, FLOAT, STR or PTR.
- Semantics the translation must keep:
  - `STORE` pushes its value back on the stack.
  - The `*_FLOAT` address modes retag a slot as float when it is loaded. This acts as a free type oracle.
  - `POINTER_INDEX` gives by-reference arrays.
  - `JMP_FALSE`/`JMP_TRUE` with arg2 set are short-circuit `&&` and `||`.
  - Arithmetic between ints wraps at 32 bits. If either operand is a float, the result is a float.
  - `MOD`, `AND`, `OR` and `NOT` take ints only.
  - Dividing by zero calls `exit(-1)`.
  - `is_true` is false only for INT 0. A float 0.0 counts as true.
- `WAIT` saves the pc and returns. `resume()` continues from there.
- `EXT` dispatches to `int handler(RS_STACKDATA*, argc)`. Handlers write their outputs through PTR arguments. Many are arity-polymorphic (69 `switch(argc)`), and some branch on the dynamic type tag.
- **Skip mode** (event only, `SkipEvent`): jumps are not taken, EXT calls are suppressed, WAITs fall through, and stores still execute. Execution falls straight through until the next `SKIP_END`. There are 2,237 sites in 718 files.

### Corpus (all 1,399 decode cleanly with the existing decoder)
- 71,012 functions, of which only **6,702 bodies are unique**. Event scripts embed a shared library; one body appears 2,953 times.
- 12,529 program entries. At most 60 locals and 10 args per function.
- 1.02M EXT sites, 17,562 backward jumps, and WAITs in 1,393 of the 1,399 files.
- 306k string pushes, 142k of them containing CP932. Some handlers compare these byte-wise, motion names for example.

### Save state
- No VM state is serialized. Persistent state lives in engine data (flags, counters, monster vars). Scripts always restart from a program entry after a load.
- So there is **no save-compatibility problem**. The only VM state that lasts across runs is the SB2 globals block, which lives as long as its instance.

### Existing port infrastructure
- `port/src/runscript.cpp` already overrides `check_program` and `ext`, with `script_guards`.
- `port/src/script_timing.cpp` plus its inventory rewrites the PAL 50/60 timing recipes when scripts load.
- The Kazarov publisher (`native_scripts.rs`) migrates resource-path operands. `scripts/port/audit_script_resources.py` is its Python twin, with programs, reachable calls and helper discovery.
- Dependencies are pinned FetchContent with SHA-256. CMake modules live in `port/cmake/*.cmake`. Python tooling has unittest files run through CTest.
- `data.zip` uses zstd entries, which Python's `zipfile` cannot read.

## 2. Scope
Replace the VM for **all four kinds**. "STB only" is not a real boundary: every script is an STB/SB2 program for the same VM. Replacing only action scripts would leave the retail interpreter in the binary. The kinds differ only in API surface (82 → 128 → 173 → 698 commands) and in event-only features. Ship kind by kind: action first (27 files, 32 commands, no skip mode), then effect, then monster, then event. Argument scripts become plain Luau data tables.

## 3. Architecture
- **Vendoring:** `port/cmake/luau.cmake` fetches pinned Luau (VM, Compiler, Ast) into `ct_port`. `Luau.Analysis` goes into a dev/CI target for strict checking. StyLua formats the output.
- **Source location:** `port/src/luau/<original path>.luau` (C++ globs ignore `.luau`). Shared helpers go in `luau/lib/<kind>/`, typed API declarations in `luau/api/*.d.luau`, and enums in `enums.luau`. These are published into `data.zip` under `luau/` so datapacks can override them.
- **Runtime facade:** keep `CRunScript` as the interface, because engines embed it and its layout is fixed. Override **every** member in `port/src/runscript.cpp`, so no bytecode interpreter is linked on PC and the engine drivers stay untouched. A side registry, `CRunScript* → Instance`, holds the Luau state.
- **Mapping `load()` to a module:** the publisher replaces each `.stb` with a stub. The stub keeps the header and program table and adds a module key plus a hash. `load()` resolves the key, compiles or loads cached bytecode, and creates the instance.
- **Execution:**
  - One sandboxed `lua_State` with a per-kind environment.
  - `run(no)` creates a new thread and resumes it once. `resume()` maps to `lua_resume`, and `WAIT` maps to `vm.wait()`, which is `coroutine.yield`.
  - `check_program` becomes `programs[no] ~= nil`.
  - An interrupt budget catches loops with no WAIT.
  - Errors are logged with the original path and traceback, and the instance ends.
- **Skip mode:** the code between SKIP_ENDs becomes `vm.section(function() … end)`. While skipping, waits and API shims raise a sentinel that the section catches, then `vm.skip_end()` clears the flag and yields. The residual gap is plain stores inside skipped regions. The transpiler reports it and the differential harness covers it.
- **Native bindings (generated):** keep all retail handlers unchanged. Generate one C++ shim per (kind, command, arity). Each shim marshals Luau args into `RS_STACKDATA`, using CP932 for strings and PTR slots for outputs, runs the guard, calls the handler, and returns the outputs as multiple results.
- **Catalog, the single source of truth:** `tools/luau/commands.json`. Each entry has the number, retail handler name, Luau name, description (from the header `/**<` comments), and per-arity parameters with direction, type and enum. It also carries a side-effect flag.
  - Draft it from the headers, the 1M corpus call sites (LOAD_ADDR marks outputs, constants give types) and the handler sources, then curate by hand.
  - Both the transpiler and the C++ generator consume it.
  - A CTest checks it against the headers and the corpus.

### Semantic gaps (Luau numbers are doubles)
| Retail behaviour | Luau translation |
|---|---|
| 32-bit wraparound | `vm.i32` only where overflow can't be ruled out; `bit32` for flags |
| C integer division and modulo | `vm.idiv` / `vm.imod` (Luau's `//` and `%` floor) |
| Divide by zero | log plus error |
| FTOI | `vm.ftoi`, which truncates |
| float32 math | doubles by default, `vm.f32` at sites shown to be sensitive (**decision needed**) |
| A float condition is always true | emit `true` with a comment |
| CP932 strings | UTF-8 in source, with a verified round-trip; otherwise `vm.bytes(...)` |
| PRINT | `vm.print` |

## 4. Transpiler (`tools/luau/stb2luau/`, Python)
Input is the **published** scripts, so they already carry the migrated resource paths. To read them, either add a `dc2data export-scripts` subcommand (recommended) or the `zstandard` wheel.

1. **Decode:** reuse `audit_script_resources.py`, moved into the package.
2. **Timing normalization:** port the 8 `script_timing` recipes. Assert the inventory counts so the output is NTSC-timed and `script_timing.cpp` can be retired.
3. **Dedup:** hash function bodies. Shared bodies go to `lib/` modules, which leaves about 6,700 definitions instead of 71k.
4. **CFG:** build it, using the op-22 label markers as join hints.
5. **Stack to expressions:** stacks are balanced at block boundaries. Short-circuit edges become `and`/`or`. Statement patterns:
   - `x = e`
   - a call statement
   - `EXT` → a named API call, with outputs returned as multiple assignment
   - `CALL` → a script call, passing by-ref arrays as tables and scalar refs as `ref` tables
6. **Type and shape inference:** works interprocedurally from constants, float modes, ITOF/FTOI, arithmetic, catalog types and callee shapes. Constant-indexed `[0..2]` slots become `{x,y,z}`.
7. **Structuring:** a dominator tree plus natural loops give if/elseif/else, while, repeat, numeric for, break and continue. Irreducible flow falls back to a state machine and is reported.
8. **Naming:**
   - Programs get a fixed name per kind (Init/Main/Damage…, Start/Run/Finish, Event<n>).
   - Helpers use curated names from `tools/luau/names/<hash>.yaml`, with suggestions generated from their API calls.
   - Locals take their names from catalog output names and loop counters.
   - Constants come from catalog enums.
9. **Emission:**
   - A file header gives the source path, kind and program table.
   - Each program is documented with its meaning.
   - API comments appear only where the name isn't self-explanatory.
   - Retail quirks are annotated with `-- retail:` comments.
   - Files use `--!strict`.
10. **Formatting:** StyLua, then `luau-analyze --mode strict` must come back clean.

Output also includes `REPORT.md` and `manifest.json` (original path → module → hash).

## 5. Verification
1. **Unit tests:** a tiny SB2 assembler builds fixtures for every opcode, address mode, short-circuit shape, loop form, by-ref case, skip region and timing recipe.
2. **Reference VM:** `refvm.py`, a line-for-line port of `exe` including skip mode. A GoogleTest validates it against the C++ VM on the fixtures.
3. **Differential harness:** runs every program of every script on both the refvm and Luau under a mock API that records `(cmd, arity, typed args)` and returns seeded outputs.
   - It compares call traces, WAIT counts, final locals and globals, and PRINT output.
   - Event scripts are also tested in skip mode.
   - Corpus gate: 1,399/1,399 transpile, compile, analyze clean and match traces.
4. **In game:** headless replays, screenshot identity, `run_from_save` checkpoints and `Smoke.*` tests pass unchanged. `--trace-scripts` reports coverage.
5. **PS2 build:** the PS2 builds stay byte-identical. No `ps2/` edits are needed.

## 6. Removing the old VM on PC
- Override all `CRunScript` members. The `rsGetStackInt` and `rsSetStack` helpers stay because handlers use them.
- Override the `Set*Script` functions so they skip the stack allocations. This removes 4 arena runs listed in `docs/PC.md`.
- Replace `BuildArgData` so it reads the Luau tables.
- Retire `script_timing.*` and the NTSC startup validation in favour of a manifest check.
- The retail VM survives only in the test target, for the harness.
- Docs: add `docs/PORT_LUAU.md` and update `docs/PC.md` (datapacks now override `luau/`, not `.stb`).

## 7. Milestones
| # | Work | Done when |
|---|---|---|
| M0 | Catalog + decoder package + corpus report (~1 wk) | catalog covers every (cmd, arity); 1,399 decode; irreducible count known |
| M1 | Transpiler core on action scripts (2-3 wk) | 27/27 trace-equal, analyze clean, readable |
| M2 | Runtime: vendor Luau, facade, binding generator, stubs (2 wk) | Max/Monica/Ridepod run on Luau; replays identical; no VM symbols in PC binary |
| M3 | Effects + monsters (2 wk) | first dungeon floor replay identical |
| M4 | Events: skip mode, arg scripts, dynamic loading, CP932 (3-4 wk) | Palm Brinks + opening replays identical; skip differential clean |
| M5 | Library extraction + name curation (ongoing) | readability review |
| M6 | Removal + CI gates + docs (1 wk) | script_timing retired; all gates in CTest |
| M7 | Hot reload (`--luau-dir`), bytecode cache, native codegen | — |

**Risks:**
- Skip-mode fall-through
- float32 precision
- Irreducible control flow (to be measured)
- Naming effort for about 6.7k bodies
- Reading zstd from Python
- Luau on llvm-mingw (confirm early)
- Datapack `.stb` compatibility break
- Handlers that branch on the dynamic type tag

## Open questions
1. `port/src/luau/` or `port/luau/`
2. Doubles with targeted f32 rounding, or round after every float op
3. Transpile NTSC-normalized scripts (recommended), or emit PAL plus a timing helper
4. `dc2data export-scripts` or a Python `zstandard` dependency
5. Whether auto-generated helper names are acceptable for the first merge
6. Whether to keep retail `.stb` bytes in the extraction for the harness
7. Luau version pin and native codegen
