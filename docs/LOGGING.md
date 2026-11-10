# Logging

The port logs through `port/src/log/log.hpp`, a thin layer over [Quill](https://github.com/odygrd/quill) v13.1.0
(`port/cmake/logging.cmake`). A `CT_LOG_*` call copies its arguments into the calling thread's queue and returns;
one backend thread, `ct-log`, formats every line and writes it to stderr and to the session's log file. Nothing is
formatted on the game thread or the audio callback.

## Writing a log line

```cpp
#include "log/log.hpp"

CT_LOG_INFO(Data, "dataread: indexed {} files under {}", file_index.size(), PathsDisplay(root));
```

- The macros are `CT_LOG_TRACE`, `CT_LOG_DEBUG`, `CT_LOG_INFO`, `CT_LOG_WARN`, `CT_LOG_ERROR` and
  `CT_LOG_CRITICAL`. The first argument is a `LogCategory` name without the `LogCategory::` prefix; the second is a
  string literal in `std::format` syntax.
- The message is exactly what stderr shows, so it keeps the `<module>: ` prefix the port has always printed
  (`dataread: `, `mglib: `, `config.json: `). Tests and documents grep these texts.
- Arguments are copied, not formatted, at the call: numbers, `bool`, `const char *`, `std::string` and
  `std::string_view` are supported. Pass a path as `PathsDisplay(path)`. Other types need a Quill codec
  (`quill/std/*.h` for standard containers, `quill/DeferredFormatCodec.h` for small game structs); include those in
  the `.cpp` that logs them, never in `log.hpp`. A type also needs a `std::formatter` for the lines written past
  the queue (below); without one such a line shows its format string. Enums have neither: pass `static_cast<int>`.
- Per-frame sites use `CT_LOG_<LEVEL>_LIMIT(interval, category, ...)` (at most one line per interval per call site
  and thread; the line ends ` (Nx)` for the N calls it stands for) or `CT_LOG_<LEVEL>_EVERY_N(n, category, ...)`.
- `CT_LOG_FILE_INFO(...)` writes to the file only, under the `session` category: the session header and the exit
  line, which stderr never showed.

### Categories

`main`, `config`, `data`, `gfx`, `audio`, `input`, `save`, `menu`, `event`, `dungeon`, `town`, `movie`, `script`,
`memory`, `ps2`, `kazarov`, `crash`. Each has its own runtime level.

- `ps2` holds the game's own `printf` output (below). It never reaches stderr.
- `kazarov` holds Kazarov's diagnostics: `main` installs a `kz::SetLogSink` sink in `LogInit`, and the message keeps
  Kazarov's subsystem, `<subsystem>: <message>`, so stderr shows what Kazarov printed itself.

## Levels

`trace`, `debug`, `info`, `warning` (or `warn`), `error`, `critical`, `off`. A category's level comes from, first to
last:

1. `--log-level SPEC` on the command line,
2. `DC2_LOG=SPEC`,
3. `log.categories` and `log.level` in `config.json`,
4. the build default: `debug` in a Debug build, `info` otherwise (`log.level` `auto`).

`SPEC` is a level, `CATEGORY=LEVEL` pairs, or both, comma-separated: `debug`, `gfx=trace,audio=off`,
`warning,data=debug`. A pair outranks the plain level at the same step. An invalid `--log-level` is a usage error;
an invalid `DC2_LOG` is logged and ignored.

`run.sh` and `run.bat` set `DC2_LOG=debug` for a PC configuration when it is unset, so a script run shows debug
lines on its console in every build type. A directly launched executable keeps the defaults above.

`CT_LOG_COMPILE_LEVEL` (CMake cache, default `Trace`) compiles out every statement below it.

## Where lines go

- **stderr** (`log.console`, on by default): the message alone, one line per call, no timestamp. Lines at or above
  the category's level.
- **The session file**: `<save root>/../logs/darkchronicle-<session>.log`, opened by `LogAttachFile` once
  `config.json` is read. Lines logged since `LogInit` are held in memory (up to 1 MiB) and written first, so the
  file begins with the session header. Each line reads

  ```
  2026-10-18 14:22:33.123 INFO  [12345] data     dataread: indexed 5021 files under ~/chronicletwo/data
  ```

  with local time, level, thread (its name where Quill reads one, which MinGW builds do not; else the OS thread id,
  as for a Linux thread that only carries the program's inherited name) and category.
  `log.file` false or `DC2_LOG_FILE=0` turns it off. There is no rotation within a session, so a crash has one
  contiguous file; past 256 MiB the file says so once and then takes only warnings and worse.
- **Retention**: when the file opens, `logs/` keeps the newest `log.keep` session logs (default 10, this one
  included); older `darkchronicle-*.log` files are deleted. Other files are left alone.

The session id is `yyyymmdd-hhmmss-xxxx` (local start time and four random hex digits). It names the log, heads it,
and names the crash bundle, so a log and a crash report pair up.

The file starts with:

```
... INFO  [...] session  session 20261018-142233-7f3a: Dark Chronicle <commit> (release build, Windows), data version N
... INFO  [...] session  session: data ~/..., saves ~/...
```

The commit is `CT_GIT_DESCRIBE` when the build defines it, else `unknown`. The user's home directory is shown as `~`.
A normal exit ends with `main: exit 0`.

## The game's printf

`port/include/ps2_printf.hpp`, force-included through `port.h` into `ct_ps2`'s units only (`CT_PS2_UNIT`), maps
`printf(...)` to `CtPs2Printf` (`port/src/log/ps2_printf.cpp`). It formats as `printf` does, writes the text to
stdout as before when `log.console` is on, and logs each completed line under `ps2` at `debug`; a partial line waits
for its newline (or for `LogShutdown`). The host's `<cstdio>` is read before the macro is defined, so its
declarations keep their names.

## Lifetime

- `LogInit` (right after `ParseOptions`): starts the backend, creates the loggers, applies `--log-level`/`DC2_LOG`,
  installs the Kazarov sink. Logging before it works too: the first `CT_LOG_*` starts the backend with stderr only.
- `LogAttachFile` (right after `ConfigLoad`): applies `config.json`'s `log` section and opens the file.
- `LogApplyConfig`: `main`'s config change hook calls it, so `log.level`, `log.categories`, `log.console` and
  `log.file` apply live.
- `LogShutdown`: at the end of `Run`, and through `atexit` (registered before `AudioShutdown`'s, so it runs last).
  It writes everything still queued. Lines logged after it, and lines from a thread whose `thread_local` objects
  are being destroyed (a thread's exit, or the thread that called `std::exit` once the atexit handlers run), skip
  the queue: the logging thread writes them to stderr and the file itself, formatted with `std::format`, so they
  can come before lines still queued.
- `LogFlush` blocks until every line logged so far is written. `LogFlushForCrash(budget)` is the crash handler's
  bounded version: it queues a marker and waits for the backend to reach it, and returns false when the budget runs
  out or the caller is the backend thread itself.
- A Kazarov `Error` or `Fatal` line is flushed before the sink returns, because Kazarov often aborts right after
  one and death tests match its text. Port code that logs and then aborts or calls `_Exit` calls `LogFlush()` first.
- `LogThreadReady` allocates the calling thread's queue. The audio device callback calls it once, so its first log
  line never allocates.

## Tests

`port/src/tests/log_test.cpp` covers levels and category overrides, precedence, delivery from several threads,
console text, rate limits, the printf line joining, Kazarov lines, retention, the file format and the `log` config
keys. Code that captures stderr around a call that logs uses `CaptureLoggedStderr`/`GetLoggedStderr`
(`port/src/tests/log_capture.hpp`), which flush the logger at both ends.
