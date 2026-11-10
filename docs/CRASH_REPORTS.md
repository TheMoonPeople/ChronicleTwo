# Crash reports

When the PC port crashes, or stops on a failure it detects itself, it writes a crash bundle: a folder holding a plain-text report, the session's log and a copy of `config.json` with personal paths removed. Nothing is uploaded. The code is in `port/src/crash/`; cpptrace (`port/cmake/crash.cmake`) symbolises the stack.

## What players see

- **Windows**: a dialog says the game crashed, gives a one-line summary and the bundle's folder, and offers **Open folder** (Explorer opens with `report.txt` selected), **Copy path** (the folder's path goes to the clipboard) and **Close**. Windows Error Reporting's own "stopped working" box is not shown.
- **Linux and macOS**: the next launch shows the same message, after the window opens, with the same three buttons. **Open folder** opens the folder in the file manager; **Copy path** copies its path.

Runs with `--headless`, `--offscreen`, `--frames` or `--input` never show either. Their crash leaves the notice for the next interactive launch. Each crash is noticed once: the notice clears `crashes/last_crash.json`, and on Windows the dialog marks it as already shown.

On stderr, every crash prints its summary and the report's path:

```
crash: EXCEPTION_ACCESS_VIOLATION writing 0x0000000000000010
crash: report written to C:\Users\Max\AppData\Local\chronicletwo\saves\crashes\20261018-132124-6c54\report.txt
```

## Where bundles go

Bundles go under the save root (see "Game data and first run" in [PC.md](PC.md)), one folder per session:

| Platform | Folder |
|---|---|
| Windows | `%LOCALAPPDATA%\chronicletwo\saves\crashes\<session>\` |
| Linux | `$XDG_DATA_HOME/chronicletwo/saves/crashes/<session>/`, by default `~/.local/share/chronicletwo/saves/crashes/<session>/` |
| macOS | `~/.local/share/chronicletwo/saves/crashes/<session>/` (or `$XDG_DATA_HOME` when set) |
| Flatpak | `~/.var/app/org.themoonpeople.ChronicleTwo/data/chronicletwo/saves/crashes/<session>/` |

`--save`, `--run-dir` and `DC2_SAVE` move the save root, and the bundles with it. `run.sh` and `run.bat` put them in `port/run/saves/crashes/`. A crash before `config.json` is read (before step 3 of "Startup" in [PC.md](PC.md)) has no bundle; its whole report goes to stderr.

The session id (`yyyymmdd-hhmmss-xxxx`) names the bundle, the session log (`logs/darkchronicle-<session>.log`, see [LOGGING.md](LOGGING.md)) and heads the report, so a report and a log always pair up.

## What a bundle holds

```
crashes/
  last_crash.json          the newest bundle, for the next launch's notice
  20261018-132124-6c54/
    report.txt             what happened, where, and the game's state
    darkchronicle.log      the session log up to the crash
    config.json            config.json with personal paths replaced
```

When reporting a problem, attach the whole folder.

### report.txt

The report is written in this order. Everything up to the raw frames uses fixed buffers and no heap, so they survive a corrupt heap; the later sections are best-effort.

1. **Header**: kind (`crash`, `assert`, `unimplemented`, `fatal`, `abort` or `terminate`), session, build id (the PE CodeView GUID and age, the ELF GNU build id or the Mach-O UUID), build type, platform (`x86_64-windows`, `arm64-macos`, ...), UTC time and the last finished game frame.
2. **Exception**: the summary (`EXCEPTION_ACCESS_VIOLATION writing 0x...`, `SIGSEGV (SEGV_MAPERR) at 0x...`, or the failure's own message), the thread and whether it is the main thread. For a hardware fault, the registers: x86-64 general registers and flags, or arm64 x0 to x28, fp, lr, sp, pc and the status register.
3. **Game state**: the mode being run (`boot`, `title`, `edit`, `dungeon`, ...), the map, floor and event the mode was entered with, the frame, the last file the game asked for, and the scene and fiber (`-` when unknown).
4. **Raw frames**: one line per frame, `#N  <module>+0x<offset>`. The offset is from the module's load base and is already moved back onto the calling instruction. [SYMBOLS.md](SYMBOLS.md) resolves these offline.
5. **Stack trace**: the same frames symbolised in the process, as function, file and line, with inlined calls indented beneath their frame. Paths in the source tree are shown relative to it. A name the debug info lacks (Release builds carry line tables only) comes from the module's symbol table. During exit, after static destructors have started, this section is skipped.
6. **Environment**: the `DC2_*` variables, with paths redacted.
7. **Log**: whether the log was flushed and copied.

A report that ends without `== end ==` stopped early; a line starting `!!` says why (the report writer itself faulted, or it did not finish within 10 seconds).

Excerpt from `--crash-test segv:early` on Windows (Debug):

```
Dark Chronicle crash report
kind:       crash
session:    20261018-132124-6c54
build id:   9DCFEE250C89C1BA4C4C44205044422E1
build type: Debug
platform:   x86_64-windows
time:       2026-10-18T02:21:26Z
frame:      -

== exception ==
EXCEPTION_ACCESS_VIOLATION writing 0x0000000000000010
thread: 47620 (main)

== raw frames ==
#0  darkchronicle.exe+0xe75c7
#1  darkchronicle.exe+0xe7568
...

== stack trace ==
#0  (anonymous namespace)::CrashTestSegv() at port/src/crash/crash_test_modes.cpp:38
#1  CrashTestFire(CrashTestMode) at port/src/crash/crash_test_modes.cpp:131
#2  CrashTestArm(CrashTest const&, CrashTestWhen) at port/src/crash/crash_test_modes.cpp:122
#3  (anonymous namespace)::Run(int, char const**) at port/src/main.cpp:316
```

### darkchronicle.log

A copy of `logs/darkchronicle-<session>.log`, made after a flush of at most 2 seconds. It is copied rather than moved, because the logger still holds the file open. When the crash is on the logging thread itself there is no flush, and the copy holds what had reached the file. With `DC2_LOG_FILE=0` or `log.file` off there is no log to copy.

### config.json

`<save root>/../config.json`, with every path redacted as below.

### last_crash.json

`session`, `kind`, `summary`, `bundle`, `report` and `notified`. It holds the bundle's real path, since it stays on the player's machine for the notice.

## Privacy

- In the report, the environment section and `config.json`, the save root becomes `<save>`, the data root `<data>` and the home folder (`USERPROFILE`, or `HOME`) `<home>`. Each is matched with either separator and in its JSON-escaped spelling, and on Windows without regard to case.
- Raw frames name modules by file name only.
- Only `DC2_*` environment variables are listed. No host name, user name, other environment, save data or screenshot is collected.
- The game's own messages (an assertion's file and line, a `PS2_UNIMPLEMENTED` site) name the build machine's source paths, not the player's.

## Failures that produce a bundle

| Failure | Kind | How the process still ends |
|---|---|---|
| Access violation, illegal instruction, divide by zero, stack overflow (Windows exceptions; SIGSEGV, SIGBUS, SIGILL, SIGFPE, SIGTRAP elsewhere) | `crash` | Windows: the exception's code (`0xC0000005`, `0xC00000FD`, ...). POSIX: the signal, re-raised with its default action |
| `abort()`, including the CRT's invalid-parameter and pure-virtual-call handlers | `abort` | SIGABRT (134 from a shell); `0xC0000409` on Windows |
| An uncaught C++ exception or `std::terminate` | `terminate` | as `abort()` |
| Retail's `__assert` (`port/src/runtime.cpp`) | `assert` | status 4 |
| `PS2_UNIMPLEMENTED` | `unimplemented` | as `abort()` |
| Kazarov's `gfx::Fatal` and window `Fatal`, and `kz::Abort` (arena overflow and similar) | `fatal` | status 1 for the fatal errors; `kz::Abort` as `abort()` |

The exit statuses are the ones [PC.md](PC.md) lists; the handlers only add the bundle. With a debugger attached, an abort on Windows breaks into it before the process ends.

## Developer notes

### Pipeline

- `CrashInit` (after `LogInit`) reads the build id, loads the unwinder's back end, starts the `ct-crash` writer thread and installs the handlers. POSIX: `sigaction` with `SA_ONSTACK` for SEGV, BUS, ILL, FPE, ABRT and TRAP, and a 256 KiB alternate stack for the main thread. Windows: `SetUnhandledExceptionFilter` (the previous filter is chained), a 64 KiB `SetThreadStackGuarantee`, a SIGABRT handler with the CRT's fast fail turned off, the invalid-parameter and pure-call handlers, and `SetErrorMode` to keep Windows Error Reporting's dialog away. Both: `std::set_terminate` and Kazarov's `kz::SetFatalHook`.
- `CrashSetBundleRoot` (after `ConfigLoad`) fixes the bundle's paths.
- The first thread to fail captures its state into static storage and hands it to the writer thread, which has its own 4 MiB stack, so a thread out of stack does no work of its own. Any other thread that fails meanwhile parks. A fault on the failing thread before the hand-off ends the process at once. A fault on the writer appends a `!!` line and lets the failing thread end the process. The failing thread waits at most 10 seconds for the report.
- Windows unwinds from the exception's `CONTEXT` with `RtlVirtualUnwind`; POSIX walks with `_Unwind_Backtrace` from the signal handler, through the signal frame. cpptrace (libdwarf, plus dbghelp on Windows) resolves the frames afterwards. `crash_symbols.cpp` names frames from the COFF or ELF symbol table, or `dladdr` on macOS, where the debug info has no name.
- Game-state slots (`CrashContextSet`, `CrashContextSetInt`) are fixed 64-byte seqlocked slots, allocation-free and safe from any thread. `CrashFrameEnd` stores the frame number once per frame from `mgEndFrame`; `MainLoop` records the mode and its entry arguments; `LoadFile2` records the file name.

### cpptrace and libdwarf

`port/cmake/crash.cmake` fetches cpptrace v1.0.4 (or uses an installed cpptrace 1.0.4 package) and links it to `ct_options`, with dbghelp on Windows. A system libdwarf found by `find_package(libdwarf CONFIG)` is used when present; otherwise the pinned libdwarf-lite commit cpptrace names is fetched as a tarball and built without zlib or zstd, since the port never compresses its debug sections. The Flatpak provides both archives as sources (`FETCHCONTENT_SOURCE_DIR_CPPTRACE` and `FETCHCONTENT_SOURCE_DIR_LIBDWARF`) and sets `no-debuginfo`, so the line tables stay in the binary.

### --crash-test

The hidden option `--crash-test MODE[:early]`, or `DC2_CRASH_TEST`, fails on purpose. MODE is `segv`, `abort`, `assert`, `unimplemented`, `terminate`, `stackoverflow` or `audio-thread` (a fault on SDL's audio thread, on the dummy driver when there is no device). Without `:early` it fires at the end of the first game frame; with it, right after `CrashSetBundleRoot`, before the data check and the window, so it needs neither data nor a GPU. An unknown mode is a usage error (status 2).

The `Crash.<mode>` tests (`port/src/tests/cmake/crash.cmake`) run each mode early under `--headless` and check the exit, exactly one bundle, the exception's name, a symbolised `CrashTest*` frame, the report's sections, the copied log and `last_crash.json`. `Crash.segv-frame` (label `gpu`) fires at the first frame and checks the game state. `crash_test.cpp` unit-tests the slots, the text builder, the header, `RedactPath` and the option parser.

### Symbolising a report offline

See "Symbolising reports" in [SYMBOLS.md](SYMBOLS.md): `tools/crash/symbolize.py` resolves the raw frames against the matching binary or its symbol artifact, by build id.
