# Display-frame interpolation cost: fix plan

## Problem

Ocean's Roar floor 1 drops to 62-140 presented FPS on an RTX 4090 when the camera moves through the open water. The scene there records about 3,000 mesh draws per game tick. The drop is CPU-bound: the GPU fence wait is near zero with `video.present_mode` `immediate`.

Repro (about 20 seconds):

```sh
darkchronicle --jump dungeon:3:1 --fast-load --skip-events --invincible --seed 1234 \
  --window 1920x1080 --input tools/input/perf-ocean-walk.input --frames 480 --log-fps
```

Every presented display frame re-interpolates and replays the whole list:

- `Interpolated()` (`tools/kazarov/src/cpp/gfx/displaylist.cpp`) costs 2.4-5.9 ms. Under camera motion every prog0 draw is re-based:
  - three 2,016-byte `Prog0Constants` copies;
  - a 1.5 KB bone `memcmp`;
  - two double-precision 4x4 inversions in `MoveProg0`.
  
  Every draw also recomputes the per-camera `projection * view * middle`.
- `Replay()` costs about 2 ms. `BindConstants` (`draw.cpp`) uploads the full prog0 block (bones included) and binds two descriptor sets per draw, about 6 MB per frame.
- `port/src/mg_visual.cpp` `SubmitFaces` emits one draw per `mgCFace`. A group's faces share transform, state, material and prog0 block, and differ only in `prog0.face` and the no-texture binding.

A prototype (`port/build/perf-ocean/kazarov-interp-prototype.patch`) caches the `MoveProg0` re-base across draws with the same transforms (about 10% misses) and skips bone work for unskinned blocks. It took calm stretches from 130 to 200 FPS, but moving-camera stretches only reached 95-115 FPS.

## Status

Stages 1 and 2 are done. On the repro (1080p window, immediate present, RTX 4090), the walk's minimum rose from 45 to 465 FPS and its peak from 95 to about 570. Scene draws fell from about 3,200 to 700 per tick. Canonical and display frames are pixel-identical to before at frames 100, 250, 340 and 450.

- **Stage 1:** the re-base cache keeps the original matrix association, so display frames stay bit-identical. Alone, it raised the minimum to 88 FPS.
- **Stage 2:** native models give almost every face its own `mgFACE_GROUP` (about 2,600 single-face groups across 130 visuals). Batching within a group therefore saved nothing. The batch spans each stretch of consecutive groups that share a material and VU microprogram, which cut 2,600 group draws to about 400.

Stages 3-5 remain optional; the repro no longer needs them.

## Stages

Recommended order: 1, 2, 3, 4, then 5 only if needed.

1. **Kazarov: land the prototype.** Cache the `MoveProg0` re-base, gate `BlendProg0Bones` and the bone compare on `kProg0Skinned`, and hoist `world_to_clip` per camera. Caching the inverse and interpolated eye transforms, rather than their product, keeps display frames bit-identical. Effort: about 1 day.
2. **Port: batch visual faces** (`port/src/mg_visual.cpp`). Merge each `mgFACE_GROUP`'s faces into one GPU mesh, emitting one draw per contiguous run of `(face->type & 0x310, textured)`. This cuts draws from about 3,000 to 300-400. Every per-draw cost shrinks about 8x: interpolation, replay, `RecordMesh` and tick-side submission. This is the biggest single win and needs no shader change.
   - Merging only contiguous runs and keeping index order preserves GS draw order.
   - Interpolation matching stays stable because each tick emits the same runs.
   - Key the mesh table by group. Port the unused-mesh sweeps, and re-derive the `persistent_mesh_test` expectations.
   - Add a test that mixed face types produce one draw per contiguous run.
   - Effort: about 2-3 days.
3. **Kazarov: bones out of `Prog0Constants`.** The block drops from 2,016 to 480 bytes; only skinned draws carry a `Prog0Palette`, which is bound as a second dynamic UBO in set 2. Unskinned draws point the bones binding at one zeroed span per frame. Display lists and `Overrides` carry palettes separately. `port/src/visualmotion.cpp` writes the palette. This removes about 17 MB per frame of interpolation copies, 4 MB per frame of uploads, and 4 MB per tick of recording. Effort: about 2 days.
4. **Kazarov: CPU hygiene.**
   - Keep `Overrides` capacity across frames.
   - Build override blocks in place, only when needed.
   - Have `BindConstants` skip the upload when consecutive draws pass the same constants.
   
   Effort: about half a day.
5. **Optional: re-base on the GPU.** A per-camera UBO would carry the interpolated view and a delta, and `mesh_prog0.vert` would rebuild `mvp` and `clip_or_view` for camera-only motion. This has the highest risk (shader, block layout, guard-band clipping) and the smallest gain once stage 2 lands.

## Verification

- **Perf:** capture the repro with `tracy-capture` (Tracy 0.14.1, `port/build/tracy-0.14.1`) and compare `Display frame render`, `Interpolate list`, `Replay list`, `Canonical scene render` and `Submit visual faces`, plus the `Scene mesh draws` plot.
  - Acceptance: the `--log-fps` minimum is at least 100, then at least 200.
- **Pixels:** compare `--screenshot --screenshot-display 8` before and after.
  - Canonical frames must be byte-identical for stages 2-4.
  - Display frames must be identical for stages 3-4, and within a small tolerance for stages 1 and 5.
  - `KZ_INTERPOLATION_TINT=1` coverage must not change.
- **Unit tests:**
  - Kazarov `GfxDisplayList.*` and `GfxGpuMeshDc2.*` (bones, skinned palette, unmatched prog0 clip, indexed vs immediate, scissor, cull).
  - Port `mg_visual_test`, `persistent_mesh_test`, `visualmotion_test`, `vu1_prog0_shader_test` and `camera_fixed_test`.
- **Docs:** update `tools/kazarov/src/cpp/gfx/README.md` for stages 3 and 5, and the visual section of `docs/PC.md` for stage 2.
