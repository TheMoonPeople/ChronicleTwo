# W1 stream results and NEEDS for the W1 integrator (binding)

## Stream branches (all on base s/p2-base 0a3c4ac / kz/p2-base c937490, authored Adubbz, unpushed)
- vu0: ChronicleTwo-vu0 / s/vu0 @ 0e146cf. No Kazarov. No NEEDS. Linux 281/281, Windows 288/288.
- data: ChronicleTwo-data / s/data @ 8b4c88a, 80cb88f, 74bfd68. No Kazarov. Linux 238/238, Windows 245/245.
- time: ChronicleTwo-time / s/time @ e355521, 04a2312 (pin); Kazarov-time / kz/time @ c5b74bc. Linux 236/236, Windows 243/243.
- boot: ChronicleTwo-boot / s/boot @ e32a00c, 9c7499d, 51ce31e. No Kazarov. Linux 241/241, Windows 248/248. Already applied time's NEEDS (Ps2CreateThread fixups, PC.md threads section).
- vu1-shaders: ChronicleTwo-vu1sh / s/vu1-shaders @ 760f378 (pin), 40eb9be; Kazarov-vu1sh / kz/vu1-shaders @ ab887bc. Linux 254/254, Windows 261/261.
Full reports: in the main session; summaries above. Stream logs in <scratchpad>/*.log.

## NEEDS to apply (via Haiku tasks) before the gate
1. data: remove `add_subdirectory(${CMAKE_SOURCE_DIR}/tools/dc2data ...)` from port/CMakeLists.txt (~line 202) and the tools/dc2data include dir + DC2_DISC_DIR definition from port/src/tests/CMakeLists.txt (~lines 22-23); port/cmake/data.cmake and port/src/tests/cmake/data.cmake take over (they skip anything already set up). Note boot also edited both CMakeLists — merge carefully.
2. Index count: the correct indexed count is 8751 (DATA.HD4 has 8753 records = 8751 files + 1 duplicate wep_t/ws050_item.chr + 1 empty terminator). Phase-2 gate expects `dataread: indexed 8751 files` after re-extraction. boot's smoke test accepts any count (fine).
3. Re-extract data/ in the main checkout with the verified dc2data (all stream runs stopped): it keeps every file and rewrites manifest.txt in the new format (on-disk names; 7 Shift-JIS files). Then `dc2data check data` must pass.
4. tools/windows/kazarov.ps1 (ChronicleTwo): kz_before_launch only extracts for Linux/macOS, so run.bat on Windows never extracts and relies on an existing data/. Make Windows run extract like Linux (dc2data extract under the lock + stamp), mirroring Chronicle's Windows flow if it has one; if non-trivial, record as open issue for W4.
5. vu1-shaders deviations to ratify: (a) new shader file port/gfx/shaders/mesh_prog0.vert instead of editing mesh.vert (keeps Chronicle SPIR-V byte-identical) — accept; (b) out-of-ownership Kazarov edits in the same commit: context.hpp (two family enumerators + one decl), draw.cpp (5 lines choosing the family from constants), gfx.hpp RendererConfig::prog0_meshes field — review the diff and accept if they are additive and Chronicle-off by default. Its NEEDS (main.cpp renderer.prog0_meshes = true) is DEFERRED to W3 `prog0`; do not apply now.
6. Carry-forward for W3 `prog0` (record in wave1-report.md): MeshConstants grew from 400 to 2416 bytes for every mesh draw including Chronicle's (bone slots = 1536 of it) — move bones/prog0 constants to a DC2-only storage/uniform buffer so Chronicle's per-draw size returns to 400. GPU-skinned meshes are not pose-interpolated between ticks.
7. boot: docs/PC_PORT_PLAN.md:~884 Phase-1 "Open:" lines about CreateThread and mgSetPkTEX0 are stale (both fixed); WP2.9's "aborts at sceDmaReset" is stale (it aborts in mgInit). Update.
8. Chronicle (in Chronicle-phase0, when bumping its pin): W0 found the JOBS positional-parameter bug at Chronicle tools/windows/kazarov.ps1:96 (fixed in ChronicleTwo as d6e4963 "Build: pass JOBS to the Windows build as a named parameter"); apply the same fix in Chronicle and verify `build.bat windows-x64` with JOBS set.

## Gate notes
- Kazarov pytest: the Windows host gives 31 failures even on base (bash scripts WinError 193 etc.) — not meaningful. Run pytest in the Linux container with a throwaway venv (e.g. `tools/kazarov/scripts/kazarov shell bash -c "python3 -m venv /tmp/v && /tmp/v/bin/pip -q install pytest && cd tools/kazarov && /tmp/v/bin/python -m pytest tests -q"`); base result was 76 passed / 14 skipped.
- Linux data-dependent checks (DataRead.RealData*, Dc2Data.RealDisc*, headless index line) must be run in the MAIN checkout (no junction there).
- No Vulkan validation layer is installed on either host, so "no validation messages" in gfx tests is vacuous. Record as open issue (W2 movies-base changes the Dockerfile anyway: add vulkan-validationlayers there; Windows: Vulkan SDK). Do not install system software yourself.
- ps2-pal gate in the main checkout at the end (no stream edited ps2/, but run it anyway).
- Chronicle gate per SCHEDULE 4.4 incl. screenshot cmp vs <scratchpad>/baseline/chronicle-3.png (use `--data data` in Chronicle-phase0, which has its own data/).
