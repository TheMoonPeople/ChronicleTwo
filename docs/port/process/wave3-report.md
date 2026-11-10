# W2.u + Wave 3 report (Phases 4-6 push)

## W2.u
- `s/uptr` fast-forwarded onto `port/pc` `fee9c9c` -> `59ee848`. Gates in the main checkout: Linux build ok, ctest 562 (7 `GfxMeshDc2` timeouts at -j8 under load, all pass on rerun at -j1), `truncations.py --check` rc 0, ps2-pal `SCES_511.90: OK`, Windows build ok, Windows tests 568/568. Main told at once so `records` could start from `59ee848`.

## Kazarov (`5314543` -> `f1b8e80`)
- `kz/draw2d` `a27ddbe` (ff) -> Chronicle gate green (ctest 336/336, screenshot identical, ps2-pal 100%, Windows build).
- `kz/prog0` rebased `--onto a27ddbe 092b706` as `db8e19e` -> Chronicle gate green (340/340).
- `kz/audio-game` rebased as `0b87ccb`, plus integrator `f1b8e80` (unused `kLayerMissing` on Windows) -> Chronicle gate green (352/352 incl. the new audio tests).
- Kazarov pytest (container, `f1b8e80`): 93 passed, 14 skipped.

## ChronicleTwo (`59ee848` -> master)
- present-core -> draw2d -> prog0 -> fx-shadow -> audio-game -> movies rebased into one chain (`4e62eff` .. `b646ab5`), pins dropped or reduced (`3c507d0` keeps draw2d's `--long-is-64` CMake line, `1b1f6e4` keeps prog0's shader-test changes), stale "(needs s/present-core ...)" suffixes removed. Conflicts: only the uptr `CreatePacket` return types, resolved to `uptr`.
- Integrator commits: `e4b4f93` pin `main@f1b8e80`; `5df989e` title fixes; `6f47570` prog0 seam entries + `prog0_meshes`, VIF plumbing retired, widening-only overrides deleted, `atexit(AudioShutdown)`; `1ac1cd1` native gate, FTOI4 to oracles, 30 s GPU cases; then `Docs:`.

## Fixes found by the in-game run (each was where the run stopped)
1. `CScriptInterpreter::GetArg` `text[(u32) length - 1]` with `length == 0` -> `text + 4 GiB` on PC. Now `(uptr) length - 1`, byte-identical (`length - 1` and `(s32) ((u32) length - 1)` were not).
2. `CScene::ClearStack` `(u8 *) this + 8 + i * 4` -> stride-fix override `port/src/scene.cpp` (in-place `&stack[i]` not byte-identical).
3. `mgCTextureAnime::NewTexAnimeGroupData` `(group << 2) + this + 0x64`: the override PC.md listed was missing after draw2d's rewrite; re-added in `port/src/mg_tanime.cpp`.
4. `CFuncPointMngr::GetLight` / `CMap::GetCharaLight` stubs: retail does not compile on clang because `CFuncPoint`'s copy is deleted (union with `mgVu0FBOX`); a header-mirror fixup adds the memberwise copy and the retail bodies run.
5. `mgCDrawManager::BeginDraw/ClearTable/PreEndDraw`: pointer tables sized `n / 4 + 1` quadwords and cleared as ints -> stride-fix overrides.
6. Intermittent segfault after a `--frames` exit (1 in 5): `std::exit` destroyed the mixer under the audio thread -> `atexit(AudioShutdown)`; 0 in 8 after.
Tests: `port/src/tests/stride_fix_test.cpp` (3 cases).

## Final gates
- Linux: build ok; ctest 774 (one real-data load timeout, passes on rerun); truncations `--check` clean (47 rows, 15 owned narrowing sites, 0 open round trips); native gate clean (sources and binary); 14 `Ps2Unimplemented` callers (9 game, 5 SDK).
- Windows: build ok; tests 780/780.
- ps2-pal: `SCES_511.90: OK`.
- Chronicle (`Chronicle-phase0` master rebased on upstream `109c6eff`, pin `f1b8e80`): ctest 352/352, screenshot identical, ps2-pal 100% (3442), Windows build ok.
- In game, real data, Linux and Windows: language select at 300 frames; title over its 3D map at 2500 frames; `--display-per-tick 4` byte-identical at the title (Linux); `DC2_AUDIO_WAV` non-silent (RMS ~750 at the title); L5LOGO frames visible (frame 540); attract-demo opening event at 4500 (skinned characters).
- Next stop (W4): START at the title enters the next mode, then frames stop advancing (hang).

## Deferred / open
See `docs/port/HANDOFF.md` section 4.
