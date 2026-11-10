# Further rendering performance proposals

These follow stages 1 and 2 of [PERF_INTERPOLATION_PLAN.md](PERF_INTERPOLATION_PLAN.md). The Ocean's Roar repro runs at 465-570 FPS on an RTX 4090. All of a display frame's work runs on the main thread, at about 1.75 ms per display frame.

The breakdown below comes from reading the code, not from a capture:

- **Mesh draws (estimated 0.8-1.0 ms):** per draw, `Replay` calls `Prepare` (texture lookup, scissor maths, dynamic state) and `BindConstants`. `BindConstants` makes two transient allocations, copies 2.4 KB and binds two descriptor sets.
- **Present path (estimated 0.3-0.5 ms per frame):** image acquire, submit and present, the fence wait, and the swapchain blit. No work on the draws can remove this.
- **Water grabs:** a display frame with water visible copies the whole frame target into its grab twin before re-grabbing it. That is two copies of about 11 MB each, and the first one is redundant.
- **Transient memory:** chunks are host-visible system RAM, so the GPU reads per-draw constants across PCIe.

The measured breakdown is under [Baseline capture](#baseline-capture).

On the 4090 the remaining gains are mostly headroom for weak hardware (integrated GPUs, Steam Deck class, Android). A low-end repro should come before items 7-10.

| # | Proposal | Expected gain | Fidelity | Effort |
|---|---|---|---|---|
| 1 | Instrument Kazarov: Tracy CPU zones, GPU timestamps (`TracyVkZone`), counters for draws, binds, uploads and grabs | enables everything below | none | 1 day |
| 2 | Stage 4 hygiene, prog0 `face` in push constants, skip identical constant uploads, cache per-entry pipeline and scissor | 0.15-0.3 ms per display frame | identical | 1 day |
| 3 | Per-frame constants in one storage buffer indexed by push constant; bones split out (plan stage 3) | 0.3-0.5 ms per display frame; 3 MB per frame less upload | identical | 3-4 days |
| 4 | Skip the grab-twin pre-copy for full-cover grabs; cache `ListRewrites` per list | one ~11 MB GPU copy per display frame while water or depth of field is visible | identical | 0.5 day |
| 5 | Transient chunks in device-local, host-visible memory (ReBAR) when available | GPU side, device dependent | identical | 0.5 day |
| 6 | Tick CPU: cache plain-MDT face builds; cut per-group `shared_ptr` and `std::function` churn | smaller per-tick spike | identical | 1-2 days |
| 7 | Conservative per-run frustum cull at submit, with a guard-band margin | fewer draws everywhere (measure the fraction first) | canonical identical; one-tick edge difference in display frames | 2 days |
| 8 | Multi-draw-indirect over consecutive compatible draws, with draw parameters in a storage buffer and bindless texture indices | `Replay` from about 0.9 to 0.25 ms | identical | 1-2 weeks |
| 9 | Record display command buffers once per tick; interpolate on the GPU in a compute pass | display-frame CPU about 0.3 ms regardless of scene size | visually identical, not bit-identical | 3-4 weeks |
| 10 | Render thread that records and presents while the game thread ticks | hides tick CPU | identical | 2-3 weeks |

**Recommended order:** 1, 2, 3 (with stage 3's bone split), 4, 5, then measure. Do 6 and 7 if the capture shows tick cost or many off-screen draws. Do 8 only for a low-end target, and 9 or 10 only if 8 is not enough there.

**Not recommended:**

- **Pipeline state sorting:** GS draw order must be kept, and pipeline binds are already deduplicated.
- **Vertex format compression:** it changes lighting LSBs and breaks canonical identity.
- **Per-flag specialisation of `mesh_prog0.vert`:** its branches are on uniform data, and specialising would multiply the 840 pipelines.
- **Async depth readback:** readbacks are already harvested at the slot's fence.

Each item is verified with `port/build/perf-direct/fps.sh` and `pixels.sh`; frames must stay identical except as noted for items 7 and 9. Also run the Kazarov `GfxDisplayList.*` and `GfxGpu*` suites, and the port tests `mg_visual_test`, `persistent_mesh_test`, `visualmotion_test`, `vu1_prog0_shader_test`, `water_test` and `screeneffect_test`.

## Baseline capture

Captured with Tracy 0.14.1 on the Ocean's Roar repro (`port/build/perf-direct/fps.sh` command line, 1920x1080 window, immediate present, RTX 4090, 480 ticks) with item 1's instrumentation and no other change. Per-zone times are per call.

| Zone | Calls | p50 µs | p90 µs |
|---|---|---|---|
| Display frame render | 7544 | 1812.9 | 2318.8 |
| Kazarov RenderList | 8029 | 1730.8 | 2245.2 |
| Canonical scene render (one per tick) | 480 | 1031.1 | 1404.5 |
| Kazarov close frame | 8029 | 976.7 | 1484.2 |
| Kazarov WaitFrame (fence wait) | 8035 | 894.2 | 1408.0 |
| Kazarov Replay | 15573 | 352.2 | 574.9 |
| Kazarov Interpolated | 7544 | 270.0 | 438.4 |
| Kazarov BuildMatches (one per tick) | 474 | 150.8 | 197.9 |
| Kazarov PresentImage | 7549 | 67.6 | 109.2 |
| Kazarov Submit | 8030 | 35.8 | 69.0 |
| Kazarov open frame | 8029 | 22.6 | 34.4 |
| Kazarov overlay | 7544 | 12.5 | 16.6 |
| Kazarov AcquireImage | 7549 | 5.1 | 8.2 |
| Kazarov PosesBetween | 7544 | 2.8 | 4.1 |
| Draw visual (game tick, per visual; ~340 per tick) | 163416 | 3.0 (mean) | - |

GPU per presented frame (p50 / p90 µs):

- Total: 1708 / 2253.
- Dynamic-rendering spans: 1647 / 2121 across 72 spans.
- Grab copies: 42 / 155.
- Swapchain blit: 7.2.
- Uploads, once per tick: 454 / 746.

Counters per display frame (p50): 448 mesh draws, 275 2D draws, 875 descriptor binds, 6 grab copies, 1.58 MB transient data.

- The fence wait is about half of a display frame's CPU time, so display frames are close to GPU-bound on this machine.
- A tick adds about 2.5 ms of CPU (canonical render 1.0 ms, Draw visual 1.0 ms, face sweep 0.33 ms) to the display frame it lands in.

## Results

Items 1-6 are implemented. Each keeps all 20 `pixels.sh` images identical, and the full test suite passes. FPS is from `fps.sh` (per-second presented FPS over the walk), measured with no other game instance running; it varies by about ±5% run to run.

| Item | Change | Measured effect |
|---|---|---|
| 1 | Tracy in Kazarov: `KZ_PORT_TRACY` CMake option (on with `CT_ENABLE_TRACY`), `gfx/profile.hpp` CPU zones, plots and `TracyVkZone` GPU zones, gated by `gfx::profile::Enabled()` | no FPS change (min 415-425, p50 470-490) |
| 2 | `Overrides` capacity kept across frames, `KZ_INTERPOLATION_TINT` read once, `ListRewrites` cached per list, identical constant blocks not re-uploaded, prog0 face bits in push constants (`DrawState::prog0_face`) | descriptor binds 875 → 590, transient data 1.58 → 1.23 MB, Interpolated p50 270 → 189 µs |
| 3 | Per-draw constants as storage-buffer records at set 1 (MeshConstants, Prog0Constants, Prog0Palette) bound once per transient chunk, record indices in push constants; bones split into `Prog0Palette`, carried only by skinned draws; identical consecutive prog0 blocks share one display-list record | descriptor binds 590 → 2, transient data 1.23 → 0.81 MB, Interpolated p50 189 → 158 µs, Replay p50 324 → 294 µs |
| 4 | Grab-twin pre-copy skipped when the grab covers the whole destination | grab copies per frame 6 → 4 (one partial grab still pre-copies), grab GPU time 42 → 31 µs per frame |
| 5 | Transient chunks in device-local host-visible memory (ReBAR / UMA), capped at a quarter of the heap, `KZ_TRANSIENT_MEMORY=host` for the old behaviour | GPU rendering per frame 1438 → 1311 µs p50, WaitFrame p50 1027 → 880 µs, fps.sh p50 about 530 → 582 |
| 6 | Tick CPU in `mg_visual.cpp`: group batches checked in place against their source faces, identical rebuilt faces keep their mesh, packet draws hold one `shared_ptr`, implicit visual sweep every 16 frames | Draw visual per tick 1.02 → 0.63 ms; sweep 0.33 ms per tick → 0.34 ms every 16th tick |

Overall: baseline fps.sh min 435-462, p50 475-524; after items 1-6 min 470-566, p50 570-582. Final capture per display frame: RenderList p50 1489 µs (of which WaitFrame 890 µs), GPU total 1406 µs p50, 2 descriptor binds, 0.81 MB transient data. The remaining display-frame cost is mostly GPU time and the fence wait, so further CPU work on display frames shows little in FPS on this machine.

Not done: item 7 (frustum cull) was skipped by decision; items 8-9 are not started.

### Item 10: render thread

- What it is: Kazarov `RendererConfig::render_thread` is `Off` (the library default, the single-threaded path and the kill switch), `Lockstep` (a worker thread runs all device work while the caller waits; byte-identical to `Off`) or `Async` (the worker renders and presents display frames from the port's idle hook while the game thread runs the next tick; the game thread takes a `RenderLease` for its canonical render and per-tick device work). The port selects `Async` by default through the config key `video.render_thread` (`off`, `lockstep` or `async`), `DC2_RENDER_THREAD`, or `KZ_RENDER_THREAD` (read by the renderer, wins). Headless and screenshot runs are forced `Off`; Android is always `Off`.

| Check | Result |
|---|---|
| `pixels.sh`, Off | 20/20 identical |
| `pixels.sh` with `KZ_RENDER_THREAD=lockstep` | 20/20 identical |
| GPU test suite with `KZ_RENDER_THREAD=lockstep` | all pass (tests that call internal device functions hold a `RenderLease`) |
| Full suite | pass (13 new `GfxGpuRenderThread` / `GfxRenderThread` tests, `MglibPresent.AsyncPublishesTheTickPairAndPresentsFromTheWorker`) |
| Debug build with Vulkan validation and thread asserts, Async, Ocean's Roar 480 frames | no validation messages, no thread-assert failures |
| Tracy, Async | display-frame `Kazarov RenderList` zones run on the render thread (9234) and canonical ones on the game thread (480); 388 display frames overlap a tick's `Draw visual` zones |

FPS from `fps.sh`, two runs each:

| Mode | min | p50 |
|---|---|---|
| Off | 494 / 483 | 589 / 591 |
| Async | 546 / 565 | 589 / 588 |

The median is unchanged because display frames are GPU-bound here (fence wait about 0.86 ms). The minimum rises because tick work no longer delays display frames.

Frame pacing, from present-to-present gaps in Tracy captures (RTX 4090, 1080p):

| Scenario | Off | Async |
|---|---|---|
| Ocean's Roar repro, immediate: p99 / p99.9 / frames over 4 ms | 5.51 / 6.27 ms / 448 | 5.01 / 5.81 ms / 371 |
| Georama river replay (`perf-georama-river.input`), immediate: p99 / frames over 4 ms | 4.16 ms / 1311 | 3.69 ms / 617 |
| Ocean's Roar repro, FIFO at 240 Hz: gaps over 16 ms | 33 | 0 |

The Georama menu's synchronous load still stalls display frames in both modes (84 ms Off, 65 ms Async), because it runs under the render lease.

Regression runs: 16 windowed replays (town, dungeon, menus, mouse camera, fixed camera, mouse menus, saving, shopping, Georama, and the fullscreen/resize smoke check in `pc-settings-display.input`) with Vulkan validation, in both modes. Exit codes and run times match, with no validation messages, errors or crash reports. They found one crash in both modes, from item 3: `MouseFixedDisplayList` did not copy the list's skinned palettes, so the fixed-camera look crashed interpolating a skinned draw in Morton's Sundries. It now copies them (`CameraFixed` test).

Behaviour differences in Async:

- SDL events and input are pumped by the game thread: once per tick, and also about once a millisecond between ticks while the menu pointer or the fixed-camera look is active, so both move at the display rate as in Off.
- Depth-query answers may arrive up to one tick later than in Off.
- The "Kazarov uploads" GPU zone is only recorded in Off (Tracy needs a GPU zone to begin and end on one thread).

Untested and risks:

- Window resize, minimise, fullscreen toggles and present-mode changes during an Async session. The worker skips display frames until the game thread's next recording recreates the swapchain.
- `Fatal` on the worker exits the process from that thread.
- Per-slot texture and mesh fields (`live`, `generation`) are read by the game thread while the worker may write a different slot's (grab twins, deferred deletions).

Recommendation: Async stays default Off until resize and fullscreen are tested and the input and mouse-look timing changes are approved.
