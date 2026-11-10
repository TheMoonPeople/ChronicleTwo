# W2.c checkpoint: inputs (binding)

## Branches to merge (no push at W2.c)
- Kazarov: kz/textures @ 4d6fb9a (worktree Kazarov-tex; new files only: port/gfx/tim2.{hpp,cpp}, port/tests/gfx_tim2_test.cpp). kz/mglib has NO commits (skip it).
- ChronicleTwo, in order onto port/pc (1553ee8):
  1. s/mglib (worktree ChronicleTwo-mglib): da2cae7 (seam), 0e33654 (mglib on the shared renderer), f7c57f0 (--frames/--screenshot/--input + tests + tests/cmake/mglib.cmake), 30f8fd6 (docs).
  2. s/textures (worktree ChronicleTwo-tex): 06a6fe5 (registry), 9f925f6 (pin kz/textures@4d6fb9a -> rewrite to the Kazarov main sha after merging kz/textures).
- Streams still running and NOT part of W2.c: `arena` (ChronicleTwo-arena / Kazarov-arena / Chronicle-arena; owns mainloop.cpp, mg_memory.cpp, arena*). Do not touch its worktrees or files. Finished but merged at W2 END (not now): vu1-geom, audio-base, movies-base.

## NEEDS to apply at W2.c (Haiku tasks; you review)
1. mglib: port/src/sceneload.cpp port of CScene::LoadMapFromMemory (host clock instead of T0) is parked as <scratchpad>\mglib-sceneload.patch. Applying it fails the Linux link with `undefined symbol: CMapParts::CMapParts()` from mapload.cpp because W1 `boot`'s per-unit fixup (scripts/port/header_fixups.py --unit) makes map.cpp's CMapParts::CMapParts() inline. Fix the fixup so an out-of-line definition remains (e.g. keep CMapParts::CMapParts() out-of-line in map.cpp and resolve the original COFF duplicate differently, or emit it in exactly one unit), keep the Windows link free of duplicate-symbol warnings, then apply the patch.
2. mglib: fold port/src/tests/cmake/mglib.cmake into port/src/tests/CMakeLists.txt if cleaner; replace the smoke test with a `--frames 3 --screenshot` smoke test once the end-to-end run works.
3. mglib: docs/PC.md stub table and "What Phase 1 does" item 4: drop the mglib.cpp rows (mgInit, mgBeginFrame, mgEndFrame, StoreImage), the mg_visual_asm.cpp SendDMA entry and the mgInit abort line; regenerate the stub list from objdump.
4. textures: ps2/src/mg_tanime.cpp:675 mgCTextureAnime::NewTexAnimeGroupData `(group << 2) + (int)this + 0x64` round trip: add a PORT_OVERRIDE copy of the body with `list[group]` (nothing else changed), per Chronicle's widening rule, in a new port/src/mg_tanime.cpp override file (+ stubs header if needed) and a test.
5. Windows scripts bug (hit by two streams): tools/windows/*.ps1 resolve relative -Root/-BuildDirectory against the process/.NET working directory, so running from a worktree with a different cwd built into ANOTHER checkout (once into the off-limits C:\Users\Adubbz\Development\PS2\Projects\Chronicle\port\build\windows-x64-tests, once into ChronicleTwo-mglib). Make the scripts resolve relative paths against the script's checkout root ($PSScriptRoot/../..) — in ChronicleTwo now. Note: movies-base (finished, merged at W2 end) also edits tools/windows/{acquire,build,configure,configure-tests}.ps1; keep your change minimal and mention it for the W2-end integrator's conflict resolution. Do NOT touch the Chronicle checkout's stray directory (the user decides).

## Gate at W2.c
- Kazarov pytest in the container (ADDENDUM-W1 recipe); Chronicle gate on the new Kazarov main (new files only, but run it: Linux ctest, screenshot cmp vs <scratchpad>\baseline\chronicle-3.png, ps2-pal) in Chronicle-phase0 — NOTE: stream `arena` has its own Chronicle worktree Chronicle-arena; don't touch it.
- ChronicleTwo Linux + Windows gates in the main checkout; ps2-pal if ps2/ changed.
- The W2.c acceptance: `darkchronicle --headless --offscreen --data data --frames 3 --screenshot out.png` produces a PNG (Linux in the main checkout, and Windows `--headless` on the 4090) with no abort in mglib/mg_texture. If it aborts further on (a later unit's stub), record where: that is the W3 starting point. Attach the PNG path in the report.
- Then SendMessage "main" immediately that W3's prog0, draw2d, fx-shadow may start, with the port/pc and Kazarov main shas.
- Remove ONLY the mglib and textures worktrees (junctions first: cmd /c rmdir <wt>\data and <wt>\.kazarov\windows), delete merged branches. Write <scratchpad>\wave2c-report.md.
