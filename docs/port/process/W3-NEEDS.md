# W3 integrator: accumulated inputs (binding; main session appends as streams report)

## Native-VU audit (user-requested) — <scratchpad>\vu-native-audit.md
- Re-run the audit's checks on the merged tree: nm/objdump of darkchronicle shows no GIF/PACKED decoder, no XYZF2/12.4/FTOI4 packing helper, no VU1 memory-layout helper linked; `port/src/vu1/` is float-only (oracles under port/src/tests). Add a CI grep gate for packing/VU-layout helpers in runtime sources.
- #13 present-core: retire the unused VIF packet buffers in mglib.cpp (mgInitVif1Packet/mgSetPacketBuffer/mgSetDataBuffer host arenas nothing reads) if nothing reads them after all merges.
- #14 prefer render targets keyed by handle/texture over GS VRAM address where the game allows (cleanup; don't break mgSetPkFrameBuffer(int) users).
- #10 1/16-logical-pixel vertex snap in Kazarov mesh.vert (shared with Chronicle): leave Chronicle's as is; DC2's mesh_prog0.vert per prog0's decision.

## draw2d (finished; worktrees ChronicleTwo-draw2d, Kazarov-draw2d)
- Take the `list(APPEND port_override_defines --long-is-64)` line in port/CMakeLists.txt (commit 56a311e) — the hook file runs too late.
- Windows GPU test cases (MgTextureGpu.*, MgTanimeGpu.*, and GfxMisc.PipelineCache) need TIMEOUT 30 like Vu1Prog0Shader.*; run the Windows gate with the machine quiet (26 timeouts at -j4 under load, incl. CPU-only cases).
- docs/PC.md stub table: drop Begin2, mgCSprite::CreatePacket, mgC3DSprite::BeginCreatePacket, PrintDirect rows and libpkt.
- s/draw2d 1309723 depends on s/present-core 023a274: merge present-core before draw2d.
- Per-object host tables grow with distinct object addresses (primitive runs erased at End2; 3D sprite records never erased): bound or clear them per mode / on object destruction.

## present-core (finished; worktree ChronicleTwo-present)
- `renderer.prog0_meshes = true` in main.cpp once prog0 lands (one line; integrator applies).
- GfxMisc.PipelineCache Windows timeout appeared after fee9c9c (FFmpeg DLL start-up?) — investigate.
- mgPortInterpScope restore resets outer teleport/blend_vertices (no gfx getters) — note.

## uptr / W2.u
- s/uptr lands at W2.u before W3 integration; W3 streams rebase onto it (CreatePacket return types become uptr in ps2/include + one-token port/src follow-ups).
- Kazarov tools/kazarov/src/cpp/tests/gfx_validation_test.cpp: unused `kLayerMissing` warning on Windows (movies-base file) — fix (-Wall clean rule).

## prog0 (finished; worktrees ChronicleTwo-prog0 s/prog0, Kazarov-prog0 kz/prog0)
- s/prog0 carries COPIES of present-core (8a97575 84de7d1 d537867 023a274) and draw2d (6fad5a4 56a311e[CMake part] cb9e212 031f24b 1309723) commits; kz/prog0 carries a copy of draw2d's a27ddbe as 092b706. Merge present-core and draw2d first, then: `git rebase --onto port/pc 0fec622 s/prog0` and `git rebase --onto main 092b706 kz/prog0` (drops the copies). Mine: 8c01e89 (pin), e3c4a19 (prog0 CPU model test-oracle only), 0fa3d0e (MDT visuals as GPU meshes); Kazarov 7d51f2f (prog0 constants split: MeshConstants back to 400 B; DC2 prog0 block at set 2 via gfx::DrawMeshProg0/DrawMeshImmediateProg0; bone palette 32 model-space affine matrices recorded per draw).
- prog0 touched Kazarov files outside its region (additive): context.hpp, pipelines.cpp, memory.cpp, renderer.cpp (fx-shadow's), draw.cpp (draw2d's), displaylist.* (W4 present's), mesh_prog0.vert, README prog0 part — merge carefully with fx-shadow's Kazarov changes.
- NEEDS (present-core finished → integrator applies): main.cpp `renderer.prog0_meshes = true;`; mglib_port.hpp seam entries `mgPortDrawMeshProg0` / `mgPortDrawMeshImmediateProg0`, then switch prog0's SubmitFaces to them.
- docs/PC.md stub list: remove mgCVisualMDT::CreatePacket, mgCVisualFixMDT::CreatePacket, CreateFacePacket, CreateFaceMotionPacket, CScene::DrawSky (once uptr fixes sceneevent.cpp union); note SetMaterialRef returns 0.
- After uptr lands: delete prog0's GetLight/GetCharaLight stubs (mapload.hpp CFuncPoint union fix) and DrawSky override (sceneevent.cpp:297 union fix) if uptr fixed those; enable Fix/Motion visuals once CopyMDTDataPointer/DataAssignMDT are converted (and records handles any in-place MDT pointer stores).
- Open: GPU meshes for Fix/Motion faces are never freed (live until the face address is reused) — bound per mode/load (W4 or records). Display frames replay the tick's prog0 lighting (W4 present).
- vu1/sdw_geom, sprite3d_geom, water_geom still contain PS2 packers; mg_drawprim_asm.cpp/mg_math.cpp still use vu0::Ftoi4 — verify after draw2d/fx-shadow finish (native audit gate).
- Gate: headless title geometry run with prog0_meshes on, after uptr's gamedata fix (prog0 reached language select at 300 frames, then the truncation crash).

## draw2d audit fix (final tip)
- s/draw2d tip = 0f82663 (on 1309723, 031f24b, cb9e212, 56a311e, 6fad5a4; base fee9c9c); needs s/present-core 023a274 merged first. prog0's copies of older draw2d commits must be dropped in favour of these (rebase --onto as in the prog0 section; resolve toward draw2d's final versions).
- GIF PACKED decoder removed from mgCDrawPrim (a packed run logs one stderr line and draws nothing); Data0/Data4 only fill `write`. New native overrides: effectlist.cpp's two DivSpriteScreen overloads, wavetable.cpp CWaveTable::CreateTexture, via seam helpers mgPortPrimSubmit/mgPortPrimVertex/mgPortPrimColor/mgPortStripTriangles (mg_drawprim_port.hpp).
- gyorace's static DivSpriteScreen NOT overridden: W4 sweep-town (owner of gyorace.cpp) must override sgEffectDrawGyoRace together with porting sgLoopGyoRace (shared unit-private state water_cam/raster phase), using mgPortPrimVertex/mgPortPrimSubmit. Carry into the W4 brief.
- docs/PC.md: add the "3D sprites drawn as 2D, not camera-interpolated (as Chronicle)" line.

## audio-game (finished; worktrees ChronicleTwo-sound s/audio-game 0c91a2c/6dffe94/98d45d0, Kazarov-sound kz/audio-game d7b64c2)
- Kazarov changes beyond stream.*: additive mixer.{hpp,cpp}/synth.hpp (HS FD 02 pitch, up to 16 banks per port by CC 0, SetCoreVolume, stream channels) + test fixture audio_bank_fixture.hpp. Chronicle-safety argued (fallbacks/centre/1.0/empty list) but NOT proven: run the Chronicle gate incl. audio tests and the screenshot on the merged Kazarov main.
- movies uses Mixer::SetStream on port 5 (kMoviePortAudioPort); audio-game added stream channels — decide whether movie audio moves to a stream channel (optional; port 5 is unused by the game's mapping) and document.
- main.cpp AudioInit/AudioShutdown: already on s/present-core (line 255) — verify after merge.
- Gate: `DC2_AUDIO_WAV=out.wav darkchronicle --headless --frames N --data data` non-silent at the title, once uptr's gamedata fixes (menucommon.cpp:866, gamedata.cpp:662 _DATACOM) are in.
- Open: end-state 0x8000 held 1 s (stand-in for driver drain); SndInReverb no-op (streams bypass reverb).
- Fix the Kazarov gfx_validation_test.cpp unused kLayerMissing warning (above).

## fx-shadow (finished; worktree ChronicleTwo-fx s/fx-shadow; Kazarov-fx has NO commits)
- e5a2266 is a cherry-pick of present-core's seam 19a79e0 (now 8a97575) — drop it at integration (merge present-core first). Own commits: 5e29d19 (z-fail stencil shadows + native resolve in mglib.cpp shadow functions; water native; vu1 oracles moved to tests/vu1_oracle + tests/cmake/fx-shadow.cmake), 12d2bd3 (outline, DOF, lens flare), 8dcf635 (mglib.cpp mgPortBinding: frame sampled while drawing into another target is grabbed — touches the same file as present-core/draw2d/prog0; merge carefully).
- NEEDS: mgSetPkMoveImage copies of the frame (fire_work in sceneevent.cpp, `screen` in map.cpp) land in ordinary targets, not frame targets (heat haze at wide aspect samples clamped edges) — make them frame targets (present-core finished → integrator, or W4 present).
- prog0's mgCVisualMDT::Draw must keep calling virtual CreateRenderInfoPacket then CreatePacket (shadows/water draw from there) — verify after merge; outline composite needs prog0 meshes through mgDrawDirect.
- Open: mgStoreZBuffImage answers one tick late (photo first distance 0).
- Native audit (fx): nm shows no SdwExtrude/SdwPrepare/SdwKickOrder/WaterTransform/WaterStripTransform/WaterKicks/WaterState/kSdwAlpha; SetDrawEnvGifTag linked only via prog0's retail mgCVisualMDT::CreateRenderInfoPacket (prog0 replaced it with mgVisualPortDrawEnv — re-check after merge); vu0::Ftoi4 linked from mg_math.cpp/mg_drawprim_asm.cpp — check whether those are game-observable integers (acceptable) or packing (not).
- Gate: shadows/water/outline/DOF/lens flare in-game screenshots once draw2d+prog0+uptr are merged (none seen in-game yet).

## uptr (finished; worktree ChronicleTwo-uptr s/uptr on fee9c9c; no Kazarov change) — W2.u FIRST
- Commits: 135ed08 (uptr/sptr typedefs in ps2/include/types.h, PORT_RECORD_ASSERT, 43 ps2/ files), 6bb7a39 (port/src one-token CreatePacket u_int->uptr follow-ups: mg_visual.cpp:9,13 (prog0), mg_sprite.cpp:9 (draw2d), water.cpp:5, mg_shadow.cpp:9 (fx-shadow) — W3 streams' versions of those lines must end up `uptr`), 1271288 (sizeof allocation sizes + SPI_STACK::operator= union fix that fixes the _DATACOM crash), 59ee848 (truncations.py fixed + test_truncations.py, uptr_test.cpp, tests/cmake/uptr.cmake Truncations.Check ctest, docs/port/records.md, truncations.md, PC.md "Pointers and 32-bit integers", SearchHash widening override deleted from mg_texture.cpp). 135ed08 alone doesn't build on PC.
- Gate: ps2-pal 6872 perfect; Truncations.Check green; Uptr.* above 4 GiB.
- Widening-only overrides to CONFIRM & DELETE now that uptr landed (verify each is purely widening, else keep): arena's mgCMemory::ClearHeapMem, EndStackMode, stAlloc64, stAllocTest; present-core's mgSetPacketBuffer, mgSetDataBuffer, mgSetPkFrameBuffer(mgCTexture*) [careful: present-core/fx changed it for registered textures — NOT widening-only], mgGetFrameBuffer, mgSetUserVuProg, mgSetUserVuProgAdr; data's StartReadBG; textures' SetTableBuffer/Initialize (uptr deleted only SearchHash — check whether the other two are still needed for sizeof reasons).
- Kept on purpose: mg_tanime.cpp NewTexAnimeGroupData override (now a stride fix, not a widening; MWCC code changed when rewritten as indexing); prog0's GetLight/GetCharaLight stubs (CFuncPoint operator= fix would change mangled names) and DrawSky override (union fixes not byte-identical).
- Carry to records: villagermngr GetAppearVlgr stride; _SET_INDEXOBJ_SIZE/_GET_INDEXOBJ_SIZE; menusys.cpp:6860 CMenuSystemData::item_cursor; DATA_HEADER fixup; funcdata::name; USER_PICTURE_INFO/CInventUserData image fixup.
- Carry to W4 sweep-dungeon/records: event_func _SWE_SET_COLOR/_SWE_SET_TEXTURE/_SWE_START_EFFECT index pointer slots as (slot<<2)+chara+offsetof → need overrides.
- Carry to arena/W4: effscript.cpp:5564 RS_CALLDATA one quadword for call depth 2 (undersized in retail; correct value not byte-identical) — host placement growth must cover it; verify.
- Open: movie.cpp:1365/1374 -Wformat (%08x with sptr) in a unit replaced whole (fine).

# W3 INTEGRATION ORDER (main-session decision)
1. W2.u: s/uptr onto port/pc (ff). Gates: ps2-pal, Linux+Windows. Then SendMessage "main" (sha) so `records` can launch from it; continue without waiting.
2. Kazarov onto main 5314543: kz/draw2d a27ddbe -> kz/prog0 7d51f2f (rebase --onto main 092b706 kz/prog0) -> kz/audio-game d7b64c2. (present-core, fx-shadow, movies, uptr: no Kazarov.) Chronicle gate after each (Chronicle-phase0 master b0cfa853 is local, not pushed; bump its pin each time; screenshot cmp vs baseline).
3. ChronicleTwo onto port/pc: s/present-core (8a97575 84de7d1 d537867 023a274) -> s/draw2d (6fad5a4 56a311e cb9e212 031f24b 1309723 0f82663) -> s/prog0 (rebase --onto port/pc 0fec622) -> s/fx-shadow (drop e5a2266) -> s/audio-game -> s/movies. Resolve the uptr one-token lines toward `uptr`. Then one `Kazarov: pin main@<sha>` commit.
