# Logging and crash reporting for the PC port: assessment and plan

**Decisions:** release builds default to `Info`; the crash dialog offers Open folder and Copy path; release binaries ship line tables; Kazarov gets a log sink and fatal hook (so no stderr pipe capture); Crashpad (phase 5) is out of scope.

Scope: `port/` (plus the Kazarov submodule where noted). Nothing touches `ps2/src` or `ps2/include`.

## 1. Assessment

### Decision

- **Logger: Quill** (pin current release, v13.1.0 at time of writing), not spdlog.
- **Crash trace: cpptrace** (v1.0.4), in-process, writing a human-readable `report.txt`.
- **Crashpad: deferred** to an optional, off-by-default phase via **sentry-native's vendored Crashpad fork** (the only Crashpad build documenting LLVM-MinGW support). It slots in later as a chained handler without changing the report format or user flow.
- All three are wrapped behind a port-owned `ct::log` / `ct::crash` module.

### Why this repo constrains the choice

- **Clang only, never MSVC.** `port/CMakeLists.txt` sets C++26 with `clang++` and aborts on Windows unless the compiler is clang/llvm-mingw. Linux uses clang + lld, macOS Homebrew LLVM, plus an offline Flatpak build.
- **Debug info is DWARF-in-binary everywhere**, including Windows (no `-gcodeview`/PDB). Windows RelWithDebInfo exes are 200–415 MB; Linux/macOS Release presets carry no `-g` at all.
- **Deps come via FetchContent** pinned by tag/URL+hash with `FIND_PACKAGE_ARGS` fallbacks. Port-local fragments in `port/cmake/*.cmake` are auto-included and attach to `ct_options`, so new deps belong in `port/cmake/logging.cmake`.
- **Kazarov is a submodule** with ~60 `fprintf(stderr, "<subsystem>: ...")` sites that can't be edited from here: capture stderr now, propose a `kz::SetLogHook` upstream later.
- **Game logic is single-threaded on fibers** (PS2 threads are fibers on the main thread). Real OS threads that may log: SDL audio callback, pipeline compile workers, script-timing jthreads, datapack prefetch, FFmpeg decode, audio track cache, Rust setup worker. The logger must be lock-free per thread and never format on the audio callback.
- **Existing logging is ad hoc** `std::println(stderr, ...)`/`fprintf` with a loose `"<module>: message"` convention. `Smoke.HeadlessFramesScreenshot` greps `dataread: indexed ` and `mglib: frame 3 written to`, so a plain stderr console sink with today's format must remain.
- **PS2 game `printf`** (~760 calls in `ps2/src`) goes straight to host stdout. `port.h` is force-included into every TU and already has a ct_ps2-only branch, which is the hook to redirect it without touching `ps2/`.
- **Crash handling is minimal**: `__assert` (`port/src/runtime.cpp`) prints and `_Exit(4)`; `PS2_UNIMPLEMENTED` aborts; `gfx::Fatal` exits 1; arena overflow aborts. No `set_terminate`, `SetUnhandledExceptionFilter` or `sigaction` anywhere.
- **User data** lives under `PathsSaveRoot()` (`%LOCALAPPDATA%/chronicletwo/saves`, `$XDG_DATA_HOME/chronicletwo/saves`), alongside `config.json`, so logs and crash bundles go there too.
- **Startup order** is `GameSetIdentity -> PathsConsumeArgs -> ParseOptions -> ConfigLoad -> FirstRunRequireData -> ... -> MainLoop`, so logging boots in two stages: console first, file sink once the save root and config are known.

### Library findings

**Quill** — header-only, C++17+, bundled fmt (`fmtquill`, no conflicts). Per-thread lock-free SPSC queues; the call site only serialises arguments, and **all formatting happens on one backend thread**. README benchmark: ~6–8 ns p50/p90 for a 3-arg log vs ~270–560 ns for spdlog. Compile-time level stripping, prefixed-only macros (`QUILL_DISABLE_NON_PREFIXED_MACROS`), console/file/rotating/JSON/custom sinks. Its built-in signal handler is best-effort and on Windows doesn't chain the previous filter, so **use Quill's backend and `flush_log`, but install our own handler** to control ordering with cpptrace/Crashpad.

**spdlog** — mature, C++11. Async mode still **formats on the caller thread** and queues through an MPMC queue + thread pool, so hot-path cost and multi-thread contention are much higher. Crash safety is "whatever already reached the sink". A good library, but the wrong trade-off for per-frame game logging.

**cpptrace** — C++11, FetchContent-friendly, fetches libdwarf itself (or uses an external one for Flatpak). **MinGW is explicitly supported with libdwarf + dbghelp**, so it reads the DWARF llvm-mingw emits today without PDBs. It has a signal-safe subset (`safe_generate_raw_trace`, `get_safe_object_frame`; truly signal-safe unwinding only with libunwind), a terminate handler and `from_current_exception()`. It gives the human-readable symbolised text at crash time.

**Crashpad** — upstream is GN/depot_tools and Visual Studio only; backtrace-labs' CMake fork documents only VS. **sentry-native** vendors a CMake Crashpad and documents LLVM-MinGW (64-bit, needs `-gcodeview` PDBs). It is out-of-process (`crashpad_handler` executable), can run with `SENTRY_TRANSPORT=none` (no uploads), and needs zlib. Minidumps are **not user-readable** and need a symbol pipeline (`dump_syms` + `minidump-stackwalk`, or WinDbg), which this repo doesn't have yet.

### Trade-offs

| Goal | Quill + cpptrace (phases 1–4) | + Crashpad via sentry-native (phase 5) |
|---|---|---|
| Zero-latency game-thread logging | Yes (single-digit ns, no formatting on caller) | n/a |
| Human-readable report | `report.txt`: exception, registers, symbolised stack, game state, build id | Same, plus `.dmp` |
| Developer detail | Crashing thread's stack only, symbolised in-process | Full minidump: all threads and memory, debugger-loadable |
| Robust under heap corruption / stack overflow | Medium: in-process; mitigated by alt stack, pre-warming, raw frames written before resolution, watchdog | High: out-of-process |
| Build cost | Small; both build with llvm-mingw/clang/Homebrew LLVM; Flatpak via external libdwarf | Large (sentry-native + crashpad + zlib), extra handler exe to ship, needs PDB pipeline first |
| Log + crash correlation | Session log flushed into the crash bundle | Same bundle, log attached |

## 2. Target architecture

```
port/src/log/                       port/src/crash/
  log.hpp         API, CT_LOG_*        crash.hpp          CrashInit / CrashContextSet / CrashReportAndExit
  log.cpp         backend, sinks       crash.cpp          handler install, report writer, bundle
  log_config.hpp  config struct        crash_context.cpp  fixed-size signal-safe context slots
  log_stderr.cpp  stderr capture       crash_trace.cpp    raw -> resolved trace, build id
  ps2_printf.cpp  game printf route    crash_dialog.cpp   native message box, next-launch notice
port/include/ps2_printf.hpp
port/cmake/logging.cmake            FetchContent quill + cpptrace, attach to ct_options
```

Runtime layout under `PathsSaveRoot()`:

```
logs/darkchronicle-20261018-142233-7f3a.log    one per session; newest log.keep (default 10) kept
crashes/20261018-142501-7f3a/
  report.txt         exception, registers, stack, game state, build, environment
  darkchronicle.log  session log, flushed up to the crash (moved, not copied)
  config.json        copy with user paths redacted
  minidump.dmp       phase 5 only
crashes/last_crash.json                        read by the next launch to show a notice
```

The session id (`yyyymmdd-hhmmss-<4 hex>`) names the log, heads the log, appears in the report and names the bundle, so a log and a report always pair up.

## 3. Phases

### Phase 0 — Debug info and symbol groundwork

1. `CT_SYMBOLS` option: `embedded` for Debug/RelWithDebInfo, `split` for Release; Release gains `-gline-tables-only` on all platforms.
2. Windows: `-gcodeview` + `-Wl,--pdb=` so lld writes `darkchronicle.pdb`. Keep DWARF until PDB-only symbolisation is verified, then consider `-Wl,--strip-debug`.
3. Linux: `-Wl,--build-id`, POST_BUILD `llvm-objcopy --only-keep-debug` / `--strip-debug --add-gnu-debuglink`. macOS: `dsymutil`.
4. CI uploads PDB/`.debug`/`.dSYM` keyed by build id and commit; `package.ps1` keeps PDBs out of the user zip; a sibling `package-symbols.ps1` zips them.
5. `tools/crash/symbolize.py`: re-symbolise `module+offset` lines in a `report.txt` with `llvm-symbolizer`.

Done when: Release builds on all three CI jobs produce a symbol artifact, an address from a report resolves to file:line, and the Windows size change is recorded in `port/buildperf.md`.

### Phase 1 — Logging core and console sink

1. `port/cmake/logging.cmake`: FetchContent Quill (tarball + SHA-256, `FIND_PACKAGE_ARGS`), `QUILL_DISABLE_NON_PREFIXED_MACROS`, link `quill::quill` to `ct_options`, `CT_LOG_COMPILE_LEVEL` mapped to `QUILL_COMPILE_ACTIVE_LOG_LEVEL`. Add a Flatpak module.
2. `log.hpp`: `enum class LogCategory` (Main, Config, Data, Gfx, Audio, Input, Save, Menu, Event, Dungeon, Town, Movie, Script, Memory, Ps2, Crash) whose names keep today's `"<module>: "` prefixes; `enum class LogLevel`; `CT_LOG_TRACE/DEBUG/INFO/WARN/ERROR/CRITICAL(category, fmt, ...)` plus rate-limited variants for per-frame sites; `LogInit`, `LogAttachFile`, `LogApplyConfig`, `LogFlush`, `LogShutdown`, `LogSessionId`, `LogFilePath`; a helper to give small game POD types deferred-format codecs so they're copied, never formatted, on the game thread.
3. `log.cpp`: start the backend (`ct-log` thread, `wait_for_queues_to_empty_before_exit`), preallocate the main thread's queue, one logger per category in an atomic pointer array (swapped when the file sink attaches). Console pattern stays `"<category>: <message>"` with no timestamp; the file pattern adds ISO-8601 ms time, thread id and level. The audio thread preallocates its queue at `AudioInit` so the callback never allocates.
4. Migrate stderr sites starting with `main`, `mainloop`, `platform/config`, `dataread`, `mglib`, `mg_texture`, `effscript`, `visualmotion`, keeping any text a test or doc names.
5. `log_test.cpp`: level gating, category overrides, multi-thread delivery after flush, session-id format, exact console text, compile-level stripping.

Done when: `ctest` is green on all three OSes including the smoke test, `--headless --frames 3` stderr is unchanged, and Quill headers cost under ~0.4 s per TU under `-ftime-trace`.

### Phase 2 — File sink, config, retention, PS2 printf, stderr capture

1. Config keys `log.level`, `log.file`, `log.keep`, `log.console`, `log.categories` in `port/src/platform/config.*`, documented in `docs/PC.md`. Precedence: `--log-level` > `DC2_LOG` > `config.json` > default. `DC2_LOG_FILE=0` disables the file sink. Live changes go through `ApplyConfigChange`.
2. Boot: `LogInit` after `ParseOptions`, `LogAttachFile` right after `ConfigLoad`, `LogShutdown` at the end of `Run` and via an `atexit` registered first (so it runs last).
3. Retention: one file per session, pruned to the newest `log.keep`. No in-session rotation (a crash needs one contiguous file); at 256 MiB the session drops to `Warning` and logs that once.
4. PS2 `printf`: `port/include/ps2_printf.hpp` included from `port.h` under a ct_ps2-only `CT_PS2_UNIT` define maps `printf` to `CtPs2Printf`. It formats into a stack buffer, joins partial lines and emits each line as `CT_LOG_DEBUG(Ps2, ...)`, still echoing to stdout when the console sink is on.
5. Kazarov stderr capture: dup stderr to a pipe when the file sink is on; a reader thread maps the `"<subsystem>: "` prefix to a category. Off in headless/test runs. A Kazarov `kz::SetLogHook` PR can retire it later.
6. `docs/LOGGING.md`; tests for config round trip, printf line joining, retention, stderr capture.

Done when: a normal run leaves `logs/<session>.log` starting with a session header (version/commit, build type, OS, CPU, GPU, redacted roots, config summary) and ending `main: exit 0`, with PS2 printf lines under `ps2`.

### Phase 3 — Crash pipeline (cpptrace)

1. FetchContent cpptrace (external libdwarf when found, otherwise fetched; Flatpak vendors it); links dbghelp on Windows.
2. API: `CrashInit` (right after `LogInit`), `CrashSetBundleRoot`, `CrashContextSet(CrashKey, ...)` into fixed `char[64]` slots (Loop, Map, Floor, Event, Frame, Jump, Scene, LastAsset, Fiber), `[[noreturn]] CrashReportAndExit(kind, message, status)` as the single funnel for `__assert` and friends, `CrashTakeLastReport()`.
3. Handlers:
   - POSIX: `sigaltstack` + `sigaction` for SEGV/BUS/ILL/FPE/ABRT/TRAP; TERM/INT only flush.
   - Windows: chained `SetUnhandledExceptionFilter`, `SetThreadStackGuarantee`, SIGABRT, invalid-parameter and purecall handlers.
   - Both: `std::set_terminate` using `from_current_exception()`.
   - First crasher wins and other threads park. A fault inside the handler takes a minimal path. A 10 s watchdog bounds the handler.
   - cpptrace/dbghelp are warmed at init.
   - Existing exit codes and abort semantics are preserved (re-raise with the default disposition).
4. Report order (raw writes, no allocation until step 5):
   1. Header with build id and session.
   2. Exception and registers.
   3. Game-state context and arena usage.
   4. Raw `module+offset` frames.
   5. Best-effort symbolised trace.
   6. Bounded `flush_log`, then rename the log into the bundle, leaving a stub (skipped if the backend thread is the one that crashed).
   7. Redacted `config.json` and `last_crash.json`.
   8. Windows `MessageBoxW` with Open folder. Other platforms show a next-launch `SDL_ShowSimpleMessageBox`. Never in headless/scripted runs.
   9. Chain or re-raise.
5. Privacy: `RedactPath()` replaces the save/data roots and home with placeholders. Only `DC2_*` env vars, no hostnames, no save payloads. `docs/CRASH_REPORTS.md` lists exactly what a bundle holds.
6. Hidden `--crash-test segv|abort|assert|unimplemented|terminate|stackoverflow|audio-thread|log-thread` (also `DC2_CRASH_TEST`), plus a variant firing before `WindowInit` for CPU-only CI. Script tests in `port/src/tests/cmake/crash.cmake` assert the exit status, one bundle, a symbolised `CrashTestSegv` frame, the context lines, and that the bundled log ends with the pre-crash lines. `crash_test.cpp` unit-tests the slots, redaction, header and build id.

Done when: every `--crash-test` mode on all three OSes yields a bundle with a symbolised top frame in under 2 s on Debug, audio-thread and log-thread crashes still produce `report.txt`, and no WER dialog appears on CI.

### Phase 4 — Release pipeline, docs, migration

- `symbolize.py` works on stripped release reports (verify `llvm-symbolizer` with PDBs in CI).
- `docs/CRASH_REPORTS.md`: per-OS folders (including Flatpak's `~/.var/app/...`), contents, what to attach, privacy, developer section.
- Update `docs/PC.md` (startup steps, env, options, exit codes, config), `docs/PC_PORT_PLAN.md` and `docs/DEBUG.md`.
- Migrate the remaining stderr sites. Add Trace/Debug timeline logging at frame end, mode changes, `LoadFile`, menu open/close and event start/end.

### Phase 5 (optional) — Minidumps via sentry-native's Crashpad

- `port/cmake/crashpad.cmake` behind `CT_CRASHPAD` (OFF). Pinned sentry-native with `SENTRY_BACKEND=crashpad`, `SENTRY_TRANSPORT=none`, static. Needs zlib and `-gcodeview`. Ship `crashpad_handler` beside the exe.
- Database at `crashes/.crashpad`, no DSN. The session log and `report.txt` are registered as attachments. Our handler flushes first, then chains (Windows: saved filter; Linux: install ours after Crashpad's and re-raise).
- The next launch moves the `.dmp` into its session bundle (session id stored as a tag/annotation).
- `symbolize.py --minidump` with `dump_syms` + `minidump-stackwalk`.

Done when: on llvm-mingw CI a `.dmp` symbolises to `CrashTestSegv` from the lld PDB and Flatpak builds offline. If mingw support regresses, the option stays OFF.

## 4. Milestones

| # | Milestone | Done when |
|---|---|---|
| M0 | Symbols | Release carries line tables; Windows writes a PDB; CI uploads symbols |
| M1 | Logging core | Quill pinned; `CT_LOG_*` in core files; stderr unchanged; ctest green on 3 OSes |
| M2 | File log + config | Session logs written and pruned; `log.*` keys; PS2 printf and Kazarov stderr captured; `docs/LOGGING.md` |
| M3 | Crash pipeline | `--crash-test` bundles with symbolised stacks, context and flushed log on 3 OSes; `docs/CRASH_REPORTS.md` |
| M4 | Pipeline + migration | `symbolize.py` on stripped builds; all stderr sites migrated; per-frame timeline |
| M5 | Crashpad (opt.) | `CT_CRASHPAD=ON` builds and symbolises minidumps; default OFF |

## 5. Files

**Create:**
- `port/cmake/logging.cmake`, `port/src/log/*`, `port/include/ps2_printf.hpp`, `port/src/crash/*`
- Tests: `log_test.cpp`, `log_config_test.cpp`, `ps2_printf_test.cpp`, `crash_test.cpp`, `port/src/tests/cmake/{crash,logging}.cmake`
- `tools/crash/symbolize.py`, `tools/windows/package-symbols.ps1`
- `docs/LOGGING.md`, `docs/CRASH_REPORTS.md`
- Phase 5: `port/cmake/crashpad.cmake`

**Modify:**
- Build: `port/CMakeLists.txt` (`CT_PS2_UNIT`, symbol flags, POST_BUILD split, `CT_GIT_DESCRIBE`), `port/include/port.h`
- Startup and handlers: `port/src/main.cpp` (options, boot/shutdown, notice), `port/src/runtime.cpp` (`__assert` funnel), `port/src/exitcodes.hpp`
- Config: `port/src/platform/config.*`
- Crash-context call sites: `port/src/mainloop.cpp`, `dataread.cpp`, `mglib.cpp`, `mg_memory.cpp`, `test_hooks.*`, `port/src/tests/main.cpp`
- CI and packaging: `.github/workflows/pc.yml`, the Flatpak manifest, `tools/windows/package.ps1`
- Docs: `docs/PC.md`, `docs/PC_PORT_PLAN.md`, `docs/DEBUG.md`, `port/buildperf.md`

**Kazarov (separate, non-blocking):** `kz::SetLogHook`; hooks so `Ps2Unimplemented`/`gfx::Fatal` reach `CrashReportAndExit`; extra-executable support for `crashpad_handler`.

## 6. Risks and open questions

- **Quill compile cost** across ~250 port TUs. Mitigations: `QUILL_DISABLE_FUNCTION_NAME`, keep heavy codecs out of `log.hpp`, measure.
- **Port compile flags**: verify on day one that Quill/cpptrace headers compile under the force-included `port.h` and `-fms-extensions` on llvm-mingw.
- **Stripping DWARF on Windows** switches cpptrace to dbghelp+PDB. Test both before stripping.
- **Signal-safe unwinding** needs libunwind (llvm-mingw already ships `libunwind.dll`). Otherwise accept best-effort `_Unwind` behind the watchdog.
- **Fiber stacks** are small. Use static buffers, an alt stack on POSIX, and record the fiber id.
- **UCRT `abort()`** may bypass SIGABRT handlers depending on `_set_abort_behavior`. Test it explicitly.
- **Log move** needs a live backend thread. If the backend itself crashed, the log stays in `logs/`, still paired by session id.
- **stderr pipe** changes buffering. Keep it off for non-tty, console-off and headless runs.
- **Flatpak offline**: every new fetch needs a manifest source.
- **Open questions:**
  1. Release default `log.level`: Info (recommended) or Debug?
  2. Crash dialog: Open folder only, or also Copy path?
  3. Ship line tables in release binaries (recommended) or strip fully?
  4. Kazarov hook PR now, or stderr pipe for a while?
  5. Go/no-go on Phase 5 after M3.
