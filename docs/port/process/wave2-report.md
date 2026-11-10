# W2 end report

No push. ChronicleTwo `port/pc` = **fee9c9c**. Kazarov `main` = **5314543** (local; origin/main still a7674f4). Chronicle-phase0 `master` = **b0cfa853** (local; origin/master 877b2c77).

## Merged
- Kazarov onto main (4d6fb9a): kz/arena 06692b9 (ff, no rebase needed) -> kz/audio-base 8ff90c4 rebased as 79f2a4a -> kz/movies-base 25081c2 rebased as 556f94b (README merged cleanly) -> **5314543** `Kazarov: a kz_before_build project hook, run where the build runs before configuring` (integrator, for NEEDS 5; README hooks list + FFmpeg section).
- Chronicle-phase0 master: c/arena 2c17f2a2 fast-forwarded, then amended to b0cfa853 with its pin rewritten to main@5314543 (message `Port: the arenas from Kazarov's platform/arena (pin main@5314543), shared with Dark Chronicle`). Kept local for the W3-end push.
- ChronicleTwo onto port/pc (a361202), each rebased with its `Kazarov: pin kz/...` commit dropped and fast-forwarded: s/arena (946f4af, c08ad27; incl. the mg_texture_test TablesAboveFourGiB fix, NEEDS 7) -> s/vu1-geom (df3c712, 1239966) -> s/audio-base (486f3d8, 1a48741, a8e32d4) -> s/movies-base (fefdf4e, 795b748). No conflicts (W2.c's common.ps1 and movies-base's acquire/build/configure.ps1 merged cleanly).
- Integrator commits: eb5ea9d `Kazarov: pin main@5314543, ...`; 0f1fb7d dc2data extract fails on a malformed SOUND.HD3, synthetic disc carries a valid one (NEEDS 2; new test Dc2Data.MalformedSoundIndexFailsBeforeWriting; docs/SOUND_DAT.md sentence updated); e6df915 Vu1Prog0Shader.* get their own gtest_discover_tests with TIMEOUT 30 (NEEDS 8), and VideoPss.L5LogoSequenceFlags finds data/ above the test executable (it always skipped under ctest because PathsDataRoot() is the build dir; now runs: 512x416, progressive_sequence=0, 737 video / 284 PCM chunks); 481acfc kazarov.conf `kz_before_build` runs `kz-ffmpeg --out .kazarov/ffmpeg/darwin-arm64` for macos-* (NEEDS 5, untestable here, no macOS host), tools/windows/kazarov.ps1 adds the FFmpeg DLL to `$markers` (NEEDS 4) and reconfigures an existing build dir whose cached KZ_FFMPEG_DIR differs (found at the gate: an old port/build/windows-x64 regenerated without -DKZ_FFMPEG_DIR and failed configure); fee9c9c Docs: PC.md line 5, plan Phase 4/5/6 status blocks.
- NEEDS 1 (main.cpp AudioInit) not applied, per instruction (present-core). NEEDS 10 left to prog0/present-core.
- NEEDS 6: `kazarov image` in the main checkout: kazarov-dev:b4dcf4978934 present.

## Gates
- Chronicle-phase0 on 06692b9 (with c/arena): Linux ctest 329/329, screenshot byte-identical, ps2-pal 100% (3442).
- Chronicle-phase0 on 5314543: Linux ctest 336/336, screenshot byte-identical to baseline/chronicle-3.png, ps2-pal 100% (3442), Windows build ok. (Audio/movies were not gated separately: new files only and a Chronicle-unused CMake module; the final gate covers them.)
- Kazarov pytest (container, 5314543): 83 passed, 14 skipped.
- ChronicleTwo main checkout: Linux build ok (warnings only in ps2/src copies, none in port/ or Kazarov), ctest 557/557 (7 skipped before the L5LOGO fix: mouse capture x2, TTF x3, L5LOGO; GfxValidation.LayerIsInstalled and DeliberateMisuseIsCaught pass on Linux). Windows build ok (no duplicate/undefined symbol lines), tests 564/564 (7 skipped: mouse x2, TTF x3, GfxValidation x2 — no layer on Windows).
- ps2-pal not run: no ps2/ change since a361202 (diff empty). truncations --check not run: W2.u has not landed.
- objdump: 60 Ps2Unimplemented callers (unchanged from W2.c: 28 game + 32 SDK).
- Headless real data, Linux and Windows: `dataread: indexed 8751 files`, `arena: MainBuffer 109051904 bytes at 0x71b2a17ff000 (above 4 GiB)` (Windows 0000023F58130000), then abort in `mg_drawprim.cpp:6: Begin2` as expected.
- data/ re-extracted in the main checkout (NEEDS 3): `wrote 3100 files (966316142 bytes), kept 8762`, `sound: 3100 entries, 1 shadowed`; `dc2data check data`: checked 11862 files.

## NEEDS 9 (Chronicle Windows headless)
`darkcloud.exe --headless` aborts with `filesystem_error: in __wide_to_char: Illegal byte sequence` right after `exporting the game text to ...\lang-export` on Chronicle master+arena@5314543, on base master 877b2c77 (Kazarov a7674f4) and on pre-Phase-0 c318048d (Kazarov aa436b5). It predates Phase 0: **open issue for the user**, no Kazarov fix. Chronicle-phase0 restored to master b0cfa853 with its Windows build rebuilt.

## Cleanup
- Junctions removed first (data, .kazarov\windows in the four ChronicleTwo worktrees; .kazarov\windows in Chronicle-arena), zero junctions left, then worktrees removed: ChronicleTwo-{arena,geom,audio,movies}, Kazarov-{arena,audio,movies}, Chronicle-arena. Main data/ intact (11,864 files incl. manifest and stamp), both .kazarov\windows intact.
- Branches deleted: s/arena, s/vu1-geom, s/audio-base, s/movies-base, kz/arena, kz/audio-base, kz/movies-base, c/arena.
- Not touched: uptr, present-core, prog0, draw2d, fx-shadow worktrees, C:\...\Chronicle.

## Logs
scratchpad/chron-w2e-*.log/.out, w2e-linux-build.log, w2e-linux-ctest.log, w2e-win-build.log, w2e-win-tests-build.log, w2e-win-ctest.log, w2e-headless-{linux,win}.log, w2e-extract.log, chron-877-win.log, chron-c318-win.log.

## Carry-forward
- Running W3 streams should rebase onto port/pc fee9c9c / Kazarov main 5314543 at their next green point. Worktrees with an old port/build/windows-x64 get reconfigured once by kazarov.ps1 (FFmpeg dir).
- Chronicle's pin bump to the final Kazarov main is already in Chronicle-phase0 master (b0cfa853); push at W3 end.
