# p2-base triage (W0)

Branches (no push):
- ChronicleTwo `s/p2-base` = `0a3c4ac`: `5db69a0` (p2-wip) + `dd2520f Build: per-stream CMake include files` + `d6e4963 Build: pass JOBS to the Windows build as a named parameter` + `0a3c4ac Kazarov: pin kz/p2-base@c937490, sceMcSeek and sceMcEnd C-linked for every game`.
- Kazarov `kz/p2-base` = `c937490`: `0b81463` (p2-wip) + `c937490 Port: declare sceMcSeek and sceMcEnd C-linked for games whose libmc.h lacks them`.
- `p2-wip` untouched in both repos.

## Gate results on s/p2-base @ 0a3c4ac (kz c937490)

| Gate | Result |
|---|---|
| Linux build (`./build.sh linux-x64`) | builds and links |
| Linux ctest | 228/228 passed, 5 skipped (DataRead.ExtractedEditConfigLoadsWhenPresent, MouseCapture x2, TtfFont x3) |
| Windows build (`build.bat windows-x64`) | builds and links (14 lld warnings, below) |
| Windows tests build + ctest | 235/235 passed, 3 skipped (TtfFont x3) |
| ps2-pal + `verify.py -c` | 6872/6872 functions perfect, all sections OK, `SCES_511.90: OK` |
| Headless, Windows (RTX 4090) | `dataread: indexed 8764 files under ...\data`, then `mgInit: PlayStation 2 code is not implemented on PC` |
| Headless, Linux (worktree) | `dataread: indexed 0 files under /work/chronicletwo/data (not a directory)`, then the mgInit abort line (environment issue E1) |
| `scripts/port/test_long64.py` (unittest, in container) | 83 tests OK |
| Kazarov pytest | not run: pytest is not installed on the host or in `kazarov-dev:e425e267ff38`. The kz/p2-base diff touches no Python |

Chronicle-phase0 on kz `c937490` (submodule now restored to `ce459c1`):
- Linux build OK, ctest 284/284 passed; ps2-pal OK, verify `-c` 3442/3442 perfect, data perfect; Windows `build.bat windows-x64` OK.
- `darkcloud --headless --data data --save port/build/chronicle-save --frames 3 --screenshot` is byte-identical (`cmp`) to `baseline/chronicle-3.png` (sha256 `30db72bb...e289`, 1280x960, taken on `ce459c1` before anything else and checked deterministic across two runs).
- On raw `0b81463` Chronicle did **not** compile: `tools/kazarov/src/cpp/tests/platform_mc_test.cpp: use of undeclared identifier 'sceMcSeek'/'sceMcEnd'` (Dark Cloud's `libmc.h` lacks them). Fixed in `c937490`: both are declared `extern "C"` in Kazarov `port/sce/libmc.cpp` and the test. Chronicle-safe construction: Chronicle's game code never calls either function. The only change is the linkage of two unused symbols, and the screenshot proves it.

## Per file (p2-wip 5db69a0 + Kazarov 0b81463)

Every file below compiles and links on Linux and Windows. "Tests" means the suites that cover it, as Linux / Windows results.

| File | Status | Tests | Owner (W1) |
|---|---|---|---|
| port/src/mg_math.cpp | builds | MgMath 58/58 both | vu0 |
| port/src/mg_frame_asm.cpp | builds | MgFrameAsm 8/8 both | vu0 |
| port/src/gameutil_asm.cpp, port/include/stubs/gameutil.hpp | builds | GameUtilAsm 15/15 both | vu0 |
| port/src/collision_asm.cpp | builds | CollisionAsm 11/11 both | vu0 |
| port/src/mg_drawprim_asm.cpp | builds | MgDrawPrimAsm 7/7 both | vu0 |
| port/src/editcoll.cpp, port/src/editmap2.cpp | builds | no test yet (the brief lists editcoll/editmap2 tests) | vu0 |
| port/src/tests/{mg_math,mg_frame_asm,gameutil_asm,collision_asm,mg_drawprim_asm}_test.cpp | pass | as above | vu0 |
| tools/dc2data/{CMakeLists.txt,dc2data.hpp,main.cpp} | builds | Dc2Data 10/10 both (RealDiscIndexHasTheGamesEntries runs once rom/pal/extracted exists) | data |
| port/src/dataread.cpp, port/src/dataread_port.hpp | builds | DataRead 13/14 Linux (ExtractedEditConfigLoadsWhenPresent skipped: data/ junction, E1), 14/14 Windows | data |
| port/src/tests/{data_extract,dataread}_test.cpp | pass | as above | data |
| kazarov.conf (kz_before_launch, dc2data extract) | not exercised (no run.sh in worktrees) | n/a | data |
| tools/windows/build.ps1 | works | n/a | data |
| (data) shared `data/` indexes **8764** files, not the 8753 the schedule expects | open | n/a | data |
| port/src/mglib_time.cpp, port/src/mglib.cpp (VSyncCallBack moved out) | builds | MglibTime 3/3 both | time |
| port/src/tests/eekernel_threads_test.cpp | pass | EeKernelThreads 5/5 both | time |
| port/src/tests/memcard_test.cpp | pass | Memcard 5/5 both | time |
| port/src/tests/platform_pad_test.cpp | pass | PlatformPad 4/4 both | time |
| Kazarov port/sce/eekernel_threads.cpp, port/sce/threads.hpp, port/sce/stubs/eekernel_threads.cpp (deleted) | builds | EeKernelThreads above. Windows lld: `duplicate symbol: CreateThread` (eekernel_threads.cpp:237 vs libkernel32.a), the risk named in section 8 | time |
| Kazarov port/sce/libmc.cpp (sceMcSeek, sceMcEnd; + c937490) | builds | PlatformMc 4/4 Linux, 5/5 Windows | time |
| Kazarov port/platform/paths.{hpp,cpp} (PathsReset) | builds | PathsXdg 6/6 Linux, 12/12 Windows | time |
| Kazarov port/tests/{platform_mc,paths_xdg}_test.cpp, platform_fixture.hpp | pass | as above | time |
| port/src/main.cpp | builds | Smoke 2/2 both | boot |
| port/src/mainloop.cpp, port/include/stubs/mainloop.hpp | builds; -Wall **not clean**: `mainloop.cpp:147/151/155 -Wwritable-strings` (string literal to `char *`) | n/a | boot |
| port/src/mg_memory.cpp | builds | MgMemory 40/40 both (incl. AboveFourGiB) | boot |
| port/src/platform/config.{cpp,hpp}, platform/settings.cpp (deleted) | builds | PlatformConfig 7/7 both | boot |
| port/include/port.h | builds | n/a | boot |
| port/CMakeLists.txt, port/src/tests/CMakeLists.txt (+ W0 hook) | configure OK | n/a | boot |
| port/src/tests/{platform_config,mg_memory}_test.cpp, smoke_test.cpp | pass | as above | boot |
| scripts/port/long64.py, test_long64.py | works; ps2-pal byte-identical | 83/83 unittest | boot |
| scripts/port/truncations.py, header_fixups.py, docs/port/truncations.md | in the build, no failure | no test | boot |
| tools/windows/kazarov.ps1 (W0 fix d6e4963) | fixed | n/a | integrator (unowned in W1) |

No failing tests. There was nothing to hand to a stream as a test failure.

## Build warnings for owners

- Windows lld, game side (boot, long64/header decision): `duplicate symbol: ClsMes::Init()` (x6, `ps2_include/nd_meswin.hpp:1072` inline vs the objects of dngmenu/dng_debug/dng_main/editloop/gyorace/mainloop/map/menuaqua/menumain/sysmes), `CMapParts::CMapParts()` (x2, dng_debug.cpp:318 / editeff.cpp:521), `vtable for CTreasureBox`, `CTreasureBox::Initialize()`. These are hidden by `--allow-multiple-definition`.
- Windows: `scenesnd.hpp:356/367 #pragma cpp_extensions` unknown (x4) (boot, header_fixups).
- Linux: 747 warnings, all in `ps2_src` except the three in mainloop.cpp above.

## Environment issues (for every stream brief)

- **E1: junctions do not resolve inside the Linux container.** `kazarov shell` mounts only the worktree. `data -> ChronicleTwo\data` shows up as a dangling link to `/mnt/host/c/...`. So in a worktree, Linux headless runs index 0 files and the data-dependent Linux tests skip. Windows sees the data fine. The `rom` junction cannot be made either: `rom/pal/*.sha256` are tracked, so `rom/` exists. W0 hardlinked the ISO (`mklink /H`), and ps2-pal extracted its own `rom/pal/extracted` (a junction there would dangle in the container the same way). Fix options: a Kazarov extra-mount hook in `lib/host.sh` (owner: time, or the integrator), or run data-dependent Linux checks in the main checkout.
- **E2: no save dir beside the executable.** A `save/` directory next to the test binary changes `PathsSaveRoot` (a local save/ wins), and Chronicle's `DataRead.PathsDefaultToWorkingDirectory` then fails. Use `--save port/build/<config>-save`, never `--save port/build/<config>/save`, before any ctest in that build dir.
- **E3: run the Windows test gate scripts from pwsh with the checkout as cwd.** Windows PowerShell 5.1 turns cmake's stderr into a terminating error under `$ErrorActionPreference='Stop'`. `[IO.Path]::GetFullPath` resolves relative paths against the process cwd, not `Set-Location`, and from another cwd it pointed at the main checkout's `port/build/windows-x64-tests`; the cache mismatch error stopped it before it wrote anything. Working form: `pwsh -NoProfile -Command "./tools/windows/configure-tests.ps1 ...; ./tools/windows/build.ps1 ... -Tests"`, with cwd set to the worktree. ctest is `C:\Program Files\CMake\bin\ctest.exe`.
- **E4: `JOBS` with `build.bat` failed** (array splat of `-Jobs`). Fixed on s/p2-base in d6e4963. Chronicle's `tools/windows/kazarov.ps1:96` has the same bug, so Chronicle's `build.bat` works only with `JOBS` unset.
- **E5: Chronicle data.** The 4.4 Chronicle headless command needs `--data data`. Chronicle-phase0 now has `data/` (gitignored), extracted with its own `dcdata` from `rom/pal/Dark Cloud (PAL).iso`.
