# Wave 1 integration report (Phase 2 push)

## Pushed (fast-forward, no force)
- Kazarov `main`: ce459c1..a7674f4
- Chronicle `master` (from Chronicle-phase0): 706ce00e..877b2c77
- ChronicleTwo `master` (= `port/pc`, local `master` reset to it): 4ee9003..1553ee8
- Both games pin Kazarov a7674f4. Every ChronicleTwo commit in the pushed range pins a commit on Kazarov main (checked).
- Verified after the push: every author and committer in all three ranges is `Adubbz <Adubbz@users.noreply.github.com>`. No body contains Co-Authored, Claude, Anthropic or "Generated with" (grep count 0 on each).

## Merged commits
Kazarov main (local main was stale at 9929210, so it was first fast-forwarded to origin/main ce459c1):
- 0b81463 WIP: Phase 2 partial (threads, paths, libmc)   [p2-wip, kept as is]
- c937490 Port: declare sceMcSeek and sceMcEnd C-linked ...
- c5b74bc Port: eekernel_threads as the only thread family; a thread switch inside ClockPump aborts   [kz/time]
- a7674f4 Port: Vu_prog0 mesh pipelines ... behind RendererConfig::prog0_meshes   [kz/vu1-shaders, rebased from ab887bc]

Chronicle master:
- 3cf8be1d Build: pass JOBS to the Windows build as a named parameter   (NEEDS 8)
- 877b2c77 Kazarov: pin main@a7674f4, ...

ChronicleTwo port/pc, in order: s/p2-base (5db69a0, dd2520f, d6e4963, 0a3c4ac), s/boot (e32a00c, 9c7499d, 51ce31e), s/data (a524b1d, 3ade2c7, 0350588), s/vu0 (7b92ed9), s/time (a098828, 4040724 pin), s/vu1-shaders (04f42d9 pin, 22d7d7a), integrator 32d518b (Build: NEEDS 1 + 4), 1553ee8 (Docs).

Deviation from section 7 step 3: I did not drop the streams' pin commits and add one final pin. I rewrote each one to the Kazarov main commit instead: `Kazarov: pin main@c5b74bc`, then `Kazarov: pin main@a7674f4`. Section 1 allows this ("the integrator rewrites that pin"). Every intermediate commit then pins a main commit that has the Kazarov API its code needs. The last pin is already main@a7674f4, so no separate pin commit was needed.

## NEEDS applied
1. The dc2data lines are out of port/CMakeLists.txt and port/src/tests/CMakeLists.txt. The guards in the two data.cmake files are gone too, since they are now dead code.
2. The count is 8751. The gate checks for it.
3. data/ was re-extracted in the main checkout and `dc2data check data` passes (8762 files).
4. tools/windows/kazarov.ps1 now extracts with dc2data.exe under port-data.lock, using a stamp, and holds the lock shared while the game runs. This mirrors Chronicle. I ran run.bat twice: the first run verified 8762 files, the second skipped extraction.
5. vu1-shaders deviations accepted: mesh_prog0.vert, plus additive context.hpp/draw.cpp/gfx.hpp edits that are off by default. Chronicle stays pixel-identical. The main.cpp `prog0_meshes = true` line is deferred to W3.
6. Carried forward, see below.
7. Stale plan lines fixed: the Phase 1 "Open:" items, "sceDmaReset" in WP2.9, the Phase 2 intro and the gates table.
8. Chronicle JOBS fix applied. `build.bat windows-x64` with JOBS=16 built green.

## Gates
Kazarov kz/time (c5b74bc), Chronicle-phase0:
- linux "100% tests passed, 0 tests failed out of 285"
- screenshot "SCREENSHOT IDENTICAL" (cmp against baseline/chronicle-3.png)
- ps2-pal "Perfect 100.00% 3442 functions"
- windows-x64 built
- pytest "76 passed, 14 skipped"

Kazarov kz/vu1-shaders (a7674f4), Chronicle-phase0:
- linux "100% tests passed, 0 tests failed out of 303"
- "SCREENSHOT IDENTICAL"
- ps2-pal 100% (3442)
- windows-x64 built with JOBS=16
- pytest "76 passed, 14 skipped"

ChronicleTwo main checkout, Phase-2 exit gate:
- Linux build OK. Warnings come only from ps2/src and vendored stb, none from port/src.
- Linux ctest: "100% tests passed, 0 tests failed out of 338". 5 skipped: MouseCapture x2 and TtfFont x3. DataRead.RealDataIndexesTheDiscFiles, Dc2Data.RealDiscIndexHasTheGamesEntries, Dc2Data.RealIsoIndexHasTheGamesEntries and all six PathsXdg cases passed.
- Windows build OK. Windows tests: "100% tests passed out of 345" (5 skipped).
- ps2-pal: "SCES_511.90: OK", 0 fuzzy, 0 unmatched, 0 data bytes.
- Linux headless: "dataread: indexed 8751 files under /work/chronicletwo/data" then "mglib.cpp:9: mgInit: PlayStation 2 code is not implemented on PC" (rc 134).
- Windows headless (RTX 4090): "gfx: 504 pipelines ready", "dataread: indexed 8751 files under ...\ChronicleTwo\data", then the mgInit abort.
- objdump: 74 functions call Ps2Unimplemented, matching docs/PC.md (34 game, 40 SDK). The awk command prints 75 lines because one is the Ps2Unimplemented label itself.
- dc2data list: 8753 lines. 8753 records = 8751 files, 1 duplicate and the terminator.
- tools/kazarov/image is unchanged between ce459c1 and a7674f4, so no image rebuild was needed.

## Docs
- docs/PC_PORT_PLAN.md: section 2 updated, Data bullet updated, stale lines fixed, and a new "Phase 2 status: done" block with the decisions, verified results and open items.
- docs/PC.md: pin updated to a7674f4, and run.sh/run.bat extraction described.

## Cleanup
- All W1 worktrees removed.
- Branches deleted: s/*, s/p2-base, p2-wip (ChronicleTwo and its submodule clone), kz/*, kz/p2-base.
- Kazarov `shared` fast-forwarded to main.

INCIDENT: `git worktree remove --force` followed the worktrees' junctions. It emptied the main checkout's `data/` and `.kazarov/windows`. The ISO and port/build were unaffected. Recovery:
- data/ re-extracted with dc2data (wrote 8762 files, check passed).
- build.bat re-acquired the toolchain.
- Windows headless confirmed "indexed 8751 files" afterwards.

Future integrators must remove the junctions first (`cmd /c rmdir <wt>\data` and `<wt>\.kazarov\windows`) before running `git worktree remove`. SCHEDULE 4.1's removal line should say so.

## Deferred / open (carry forward)
- W3 prog0: MeshConstants grew from 400 to 2416 bytes for every mesh draw, Chronicle's included (1536 of that is bone slots). Move the prog0/bone constants to a DC2-only storage or uniform buffer.
- W3 prog0: GPU-skinned meshes are not pose-interpolated between ticks.
- W3 prog0: main.cpp `renderer.prog0_meshes = true` is not set yet.
- No Vulkan validation layer is installed on either host, so "no validation messages" in the gfx tests proves nothing. Add vulkan-validationlayers in W2 movies-base (Dockerfile) and install the Vulkan SDK on Windows.
- The p2-wip commit subjects stay "WIP: Phase 2 partial ..." on both masters (5db69a0, Kazarov 0b81463). Kazarov's could not be reworded without breaking ChronicleTwo's historical pins. 0a3c4ac's subject still says "kz/p2-base@c937490", but c937490 is on main.
- The Linux (kz-cached JSON) and Windows (text) launchers write different formats to data/.kazarov-data. Alternating OSes re-runs the idempotent extraction, which keeps existing files. Chronicle behaves the same way.
- Kazarov pytest on the Windows host still fails (bash scripts, WinError 193). The container run is the gate.
- `ctest` is not on pwsh's PATH. Use `C:\Program Files\CMake\bin\ctest.exe`.
- ps2/src emits -Wdynamic-class-memaccess warnings (sphida.cpp) and other ps2/src warnings. These were already there and are outside port/src.
