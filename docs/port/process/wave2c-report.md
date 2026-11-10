# W2.c checkpoint report

No push. ChronicleTwo `port/pc` = **a361202**. Kazarov `main` = **4d6fb9a** (local only; origin/main is still a7674f4).

## Merged
- Kazarov: `kz/textures` 4d6fb9a fast-forwarded onto `main` (new files only: port/gfx/tim2.{hpp,cpp}, port/tests/gfx_tim2_test.cpp). `kz/mglib` had no commits.
- ChronicleTwo, on top of 1553ee8: s/mglib da2cae7, 0e33654, f7c57f0, 30f8fd6 (fast-forward); s/textures 06a6fe5, rebased as fc7c8ba, with its kz pin commit dropped; `3a814e3 Kazarov: pin main@4d6fb9a, TIM2 decoding and upload in gfx/tim2`.
- NEEDS commits:
  - 7681c52 Build: header_fixups keeps map.cpp's out-of-line `CMapParts::CMapParts()`. The identical inline copies in the editeff.cpp/editmap.cpp unit copies are blanked, which keeps line numbers. This fixes the Linux link (undefined CMapParts::CMapParts), and the Windows link has no CMapParts duplicates.
  - 333b955 Port: scratchpad/mglib-sceneload.patch applied (CScene::LoadMapFromMemory, host clock instead of T0).
  - 7cd38cf Build: tools/windows/common.ps1 adds `Resolve-CheckoutPath`, so relative -Root/-BuildDirectory resolve against `$PSScriptRoot/../..`, not the .NET working directory. Checked on pwsh 7 and 5.1. **W2-end conflict note:** movies-base also edits tools/windows/{acquire,build,configure,configure-tests}.ps1. This change touches only common.ps1.
  - ca7c5dd Build: port/src/tests/cmake/mglib.cmake folded in and deleted. The smoke test is now `Smoke.HeadlessFramesScreenshot`: `--headless --offscreen --frames 3 --screenshot` on an empty data directory, exit 0, `mglib: frame 3 written`, PNG signature.
  - a361202 Docs: PC.md stub table without the mglib.cpp (4) and sceneload.cpp rows, 28 game stubs + `main`. Item 4 and the Phase 2 abort line are updated, the SendDMA row is now empty, and the smoke-test text is updated.
- NEEDS item 4 (mg_tanime NewTexAnimeGroupData widening) was **skipped** on the coordinator's direction (the `uptr` stream fixes it in ps2/src). The override was written, then deleted unmerged. No ps2/ or main.cpp edits.

## Gates
- Kazarov pytest (container, main checkout on 4d6fb9a): 76 passed, 14 skipped.
- Chronicle-phase0 on 4d6fb9a: Linux build ok, ctest 316/316, `darkcloud --frames 3` screenshot **byte-identical** to baseline/chronicle-3.png, ps2-pal 100% (3442 functions), Windows build ok. The submodule is restored to its committed pin a7674f4 afterwards (the tree is clean, nothing committed).
- ChronicleTwo main checkout: Linux build + ctest **372/372**. Windows build ok, tests **379/379**. No duplicate-symbol or undefined-symbol lines in the Windows link logs. ps2-pal not run (no ps2/ change).
- objdump: 60 `Ps2Unimplemented` call sites, one per function: 28 game-side (the PC.md table) and 32 SDK. mglib.cpp, sceneload.cpp and SendDMA are no longer callers. The list is in scratchpad/w2c-stubs.txt.

## Headless acceptance
- With the real data (Linux main checkout, and Windows `--headless` on the 4090): `dataread: indexed 8751 files`, then abort before frame 1 ends with `port/src/mg_drawprim.cpp:6: Begin2: PlayStation 2 code is not implemented on PC`. The run exits with SIGABRT on Linux and C0000409 on Windows. **No PNG** is written. No abort in mglib or mg_texture.
- **W3 starting point:** mgCDrawPrim::Begin2 <- mgCDrawPrim::Begin (ps2/src/mg_drawprim.cpp:57) <- PrimQuad (menudraw.cpp:1316) <- TitleLangSelDraw (title.cpp:3306) <- SCElogoFade (nowload.cpp:669) <- MainLoop (mainloop.cpp:79). This is draw2d's unit.
- With an empty data directory, the run stays in the SCE logo fade. It completes 3 frames and writes the cleared frame (1280x960, black) on both OSes: scratchpad/w2c-linux-empty-3.png and scratchpad/w2c-win-empty-3.png.
- Logs: w2c-linux-build*.log, w2c-linux-ctest.log, w2c-win-build.log, w2c-win-tests-build.log, w2c-win-ctest.log, w2c-headless-linux.log, w2c-headless-win*.log, chron-w2c-*.log.

## Cleanup
- Removed ChronicleTwo-mglib and ChronicleTwo-tex (data and .kazarov\windows junctions rmdir'd first; the main data/ and .kazarov/windows are intact), and Kazarov-mglib and Kazarov-tex.
- Deleted s/mglib, s/textures, kz/mglib and kz/textures.
- Not touched: arena, uptr, present-core, the W2-end streams' worktrees, and C:\...\Chronicle.

## Carry-forward
- W2 end: Chronicle-phase0's pin bump to the final Kazarov main happens at the next push point.
- docs/PC.md line 5 ("at Phase 2 ...") and the plan's status sections are left for the W2-end integrator.
- The off-limits Chronicle checkout's stray port\build\windows-x64-tests directory has not been touched (the user decides).
