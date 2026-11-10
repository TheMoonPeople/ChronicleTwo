# W2 end: inputs (binding)

## Branches to merge (local only; NO push at W2 end — next push is Phases 4-6 at W3 end)
Base: ChronicleTwo port/pc = a361202, Kazarov main = 4d6fb9a, Chronicle master 877b2c77.
- Kazarov, in order onto main: kz/arena @ 06692b9 (Kazarov-arena) -> kz/audio-base @ 8ff90c4 (Kazarov-audio) -> kz/movies-base @ 25081c2 (Kazarov-movies; image change: tag kazarov-dev:b4dcf4978934 already built). Chronicle gate after each (Chronicle-phase0; plus the arena change also exists as Chronicle branch c/arena @ 2c17f2a2 in worktree Chronicle-arena — Chronicle's consumption of kz/arena REQUIRES that commit: rebase/merge c/arena onto Chronicle master in Chronicle-phase0 (fast-forward), rewrite its pin to the Kazarov main sha; do not push Chronicle now, keep it local on Chronicle-phase0's master branch for the W3-end push).
- ChronicleTwo, in order onto port/pc: s/arena (ChronicleTwo-arena: 9d135b7 pin, 75bf258, 977d229) -> s/vu1-geom (ChronicleTwo-geom: 443378e, 1764907) -> s/audio-base (ChronicleTwo-audio: b2fcffe pin, 30a3647, 6e943b7, 9fc040d) -> s/movies-base (ChronicleTwo-movies: 9ce5d0f pin, 5e512d5, ec8bb35). Rewrite every kz/* pin to the Kazarov main commit.
- NOT part of W2 end: s/uptr (W2.u checkpoint separately), s/present-core, s/prog0, s/draw2d, s/fx-shadow (W3). Do not touch their worktrees.

## NEEDS / notes to apply
1. audio-base: `main.cpp` AudioInit()/AudioShutdown() calls are present-core's (it owns main.cpp in W3) — do NOT edit main.cpp; leave it.
2. audio-base: port/src/tests/data_extract_test.cpp: give WriteDisc a valid SOUND.HD3 (kSoundHd3) so dc2data extract can treat a malformed index as an error instead of a warning — apply, and flip the warning to an error.
3. audio-base: re-extract data/ in the main checkout (dc2data now writes data/sound/<name>); `dc2data check data` must pass; confirm the 3,100 written + 1 shadowed entries.
4. movies-base: tools/windows/kazarov.ps1: add `deps/ffmpeg/ffmpeg-n7.1.1-5-g276bd388f3-win64-lgpl-shared-7.1` to `$markers` so an existing .kazarov/windows re-runs acquire.ps1. W2.c changed tools/windows/common.ps1 (relative path fix); movies-base changed acquire/build/configure — resolve carefully.
5. movies-base: kazarov.conf: macOS before-build hook `kz-cached ... -- tools/kazarov/scripts/build/kz-ffmpeg --out .kazarov/ffmpeg/darwin-arm64` (WP6.2) — add it (untestable here; say so).
6. movies-base: `tools/kazarov/scripts/kazarov image` in the main checkout after merging (tag b4dcf4978934 exists locally).
7. arena: port/src/tests/mg_texture_test.cpp got a one-line fix on s/arena (TablesAboveFourGiB takes the base from h.memory.stack) — keep it.
8. vu1-geom: the 4 Vu1Prog0Shader.* GPU tests time out at -j4 on lavapipe under load; set their ctest TIMEOUT (e.g. 30 s) or RUN_SERIAL in port/src/tests (CMake), not by disabling them.
9. Chronicle Windows headless regression check: Chronicle's `darkcloud.exe --headless` on Windows aborts with `filesystem_error … __wide_to_char: Illegal byte sequence` (first in the game-text export to the save folder, again after shaders compile). Determine whether it happens on base Chronicle master 877b2c77 and on the original pre-Phase-0 c318048d (build in Chronicle-phase0 by checking out those commits temporarily, restoring afterwards). If it is a Phase-0 regression from the shared Kazarov paths/settings code, fix it in Kazarov (it would affect DC2 too) and add a test; if it predates Phase 0, record it as an open issue for the user.
10. Pending prog0 carry-forward stays with prog0; present-core adds mgPortCutInterpolation() to mainloop.cpp after rebasing onto your result.

## Gates
- Kazarov pytest (container) after each Kazarov merge; Chronicle gate (Linux ctest, screenshot cmp vs <scratchpad>\baseline\chronicle-3.png, ps2-pal, Windows build) on the final Kazarov main.
- ChronicleTwo main checkout: Linux build + ctest (real-data tests run there), Windows build + tests, ps2-pal (if ps2/ changed — it shouldn't), headless real-data run (expected: reaches the mg_drawprim Begin2 abort, now with `arena: MainBuffer … above 4 GiB` in the log), dc2data check.
- Update docs/PC_PORT_PLAN.md status (Phase 4 partial, 5.1/5.3, 6.1/6.2) and docs/PC.md line 5.
- Remove merged worktrees (junctions first: cmd /c rmdir <wt>\data and <wt>\.kazarov\windows; Chronicle-arena likewise), delete merged branches. Write <scratchpad>\wave2-report.md. SendMessage "main" when done with the new shas.
