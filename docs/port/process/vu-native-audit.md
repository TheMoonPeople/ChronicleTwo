# VU programs: native or emulated? (read-only audit, 2026-10-12)

Question: "have we replaced the VU programs in a way that does not attempt to emulate the PS2 and instead makes them PC-native?"

## Verdict

**Mostly native, with listed exceptions.** Nothing in any tree interprets VU microcode, uploads it, decodes VIF/DMA chains, or maps PS2 address ranges. `Vu_prog0/_sdw/_3dsp/_wtr` are 1-qword dummy link names (`port/src/linknames.cpp:13-16`). `mgSendVuProg` only records the program id (`port/src/mglib.cpp:1196`). Vu_prog0 is a real Vulkan vertex shader (`Kazarov port/gfx/shaders/mesh_prog0.vert`) fed by a UBO. The GS state is a shadow struct translated into `gfx::DrawState`. GS blending is mapped onto fixed-function Vulkan blend.

The exceptions come in two kinds:

1. **Committed branch tips** still carry PS2-format work in the runtime path:
   - draw2d decodes a GIF PACKED register stream.
   - fx-shadow counts shadows with GS ADD/SUB colour blending.
   - The water path runs Vu_prog_wtr's packed CPU half every frame.
   - The committed draw2d sprite path round-trips through 12.4 GS words.
2. **Uncommitted working trees** (they changed while this audit ran) already fix most of the committed issues:
   - prog0, fx-shadow and draw2d are each moving their PS2-format "CPU halves" into `port/src/tests/`.
   - fx-shadow is switching to a z-fail stencil volume.
   - Water is moving to a float eye-depth fade.
   - The sprite path is moving to a float `Sprite3dExpandNative`.

   One item remains open in every tree: the draw2d `mgCDrawPrim::Data` PACKED decoder.

## What is linked (main checkout, `port/build/pc/darkchronicle`, built 14:59, vu1 sources 14:47)

`kazarov shell nm -C` (full list at `scratchpad/nm_main.txt`):

- **No `dc::vu1::*` symbol is linked.** `port/src/vu1/*.cpp` are compiled into `ct_port` (the `port/CMakeLists.txt:57` glob), but nothing on port/pc references them, so `-Wl,--gc-sections` drops them.
- VU-related symbols present:
  - `mgSendVuProg`, `mgSetUserVuProg`, `mgSetUserVuProgAdr`, `mgInitVif1Packet`: bookkeeping only.
  - `Vu_prog_wtr` (B): a dummy.
  - `mesh_prog0_vert` (r): the SPIR-V blob.
  - `SendDMA` (T): an empty body (`port/src/mg_visual_asm.cpp:5`).
  - `DisableDmac`/`RemoveDmacHandler`: SDK stubs.

On the branches, `vu1/*` becomes runtime code:
- s/prog0's `mg_visual` calls `Prog0BatchLimit` and `Prog0StripParity`.
- s/fx-shadow's `mg_shadow` calls `SdwPrepare` and `SdwExtrude`, and its `water` calls `WaterStripTransform`.
- s/draw2d's `mg_sprite` calls `Sprite3dExpand`.

## Findings

Classes: **(a)** native code that reproduces retail's visible maths or numbers (acceptable); **(b)** test-only oracle; **(c)** emulation in the runtime path.

| # | Where (file:line) | What | Class | PC-native alternative |
|---|---|---|---|---|
| 1 | s/draw2d (also inside s/prog0, t/draw2d-pc) `port/src/mg_drawprim.cpp:268-350` (`BeginPrim2(prim, data_a, data_b, n)`, `Data(int*)`), `:191` `Kick` | A GIF PACKED REGLIST decoder. It unpacks the register nibbles (0x43 means UV then XYZF2), switches on GS register codes 1/2/3/4/5/0xA, honours the ADC bit as a vertex kick, and converts 12.4 XY and 24-bit Z back to floats (`mgPortLogicalX/Y`, `mgPortDepth`). Retail callers: `effectlist.cpp:346` and `gyorace.cpp:1226` `DivSpriteScreen`, `wavetable.cpp:89-110`, `outline.cpp:246/312` (outline is overridden in fx). | **c** | Override the callers (`DivSpriteScreen` x2, the wavetable draw) to build `gfx::Vertex2D` directly in logical floats. Make `Data(int*)` only copy into a caller-supplied `write` buffer, and report once on any packed run. Delete `regs`/`next_reg`/`Kick`'s GS decoding. |
| 2 | s/prog0 `port/src/mg_drawprim_asm.cpp:9,14` | `Data0`/`Data4` now do Ftoi/Ftoi4 into lanes, then call `Data(lanes)`, which decodes 12.4 back to float: a float to 12.4 to float round trip that feeds #1. | **c** | Once #1 lands, `Data4` takes floats natively (or the wavetable override removes the only caller). |
| 3 | main `port/src/mglib.cpp:1328-1401` (`mgBeginDrawShadow`/`mgEndDrawShadow`: AEM composite, `GsBlend{2,1,0,1,64}`, `texa_ta0 = 48`) + s/fx-shadow tip `port/src/mg_shadow.cpp:160-178` | Shadow volumes rendered as GS colour counting: ADD on front faces, SUB on back faces into a colour target, then any non-black texel becomes alpha 48 through AEM/TA0. This is retail's GS trick. It saturates at 0/255, so overlapping volumes depend on draw order. | **c** (committed) | Two-sided z-fail stencil (Increment/DecrementWrap, colour mask 0), then one quad where stencil != 0 that darkens Cd by 48/128. Kazarov already has `stencil_front/back`, `ClearStencil` and `separate_stencil_masks`. **The fx-shadow working tree is doing exactly this (uncommitted).** Leftover: the resolve still writes 0x80 into the shadow texture and composites through AEM. Resolving straight into the main target with the darkening blend would make the offscreen texture unnecessary. |
| 4 | s/fx-shadow tip `port/src/vu1/water_geom.cpp:149-224` (`WaterStripTransform`/`WaterTransform`), used by `WaterHostMesh` `:190`, `water.cpp:125` | Every frame, each water vertex goes through the CPU copy of Vu_prog_wtr: projection, guard pass bits 0x80/0x40/0x10, ADC window, then FTOI4 packing of X/Y/Z/fog/UV. The result is used only for kick culling and vertex alpha; the GPU then transforms the vertex again. | **c** (CPU VU half in the runtime path) | Fade `alpha = clamp(375/eye_z - 0.25)` computed in float (or in the vertex shader); near/far handled by GPU clipping; mesh kept on the GPU, with only heights updated. **The fx-shadow working tree has done this** (float eye-z fade, no guard/ADC; the oracle moved to `tests/vu1_oracle/water_oracle.cpp`). |
| 5 | s/fx-shadow tip `port/src/mg_shadow.cpp:103` | `SdwExtrude` (full VU path: 12.4 `Project()`, quad orientation, kick list) is called only for its reject code. | a/c (wasted VU emulation) | A float-only reject (frustum on `vc*v`, `sm*v`, and the grazing test `abs(n·lc) <= 1e-4`). The working tree removed the call and moved `SdwPrepare/SdwExtrude` into `tests/vu1_oracle/sdw_oracle.cpp`. Check that the CClip/TClip/grazing rejects retail applies are still reproduced, or that dropping them was deliberate. |
| 6 | s/draw2d tip `port/src/mg_sprite.cpp` (committed `SpriteVertex(uint16_t gs_x, ...)` with `vu1::Sprite3dExpand`) | Billboards expanded by the CPU copy of Vu_prog_3dsp into packed GS words (12.4 XY, 24-bit Z, `u & 0x3FFF / 16`), then converted back to logical. | **c** (committed) | The working tree uses float `Sprite3dExpandNative` (`vu1/sprite3d_geom.cpp`, uncommitted), with the packed version moved to `tests/vu1_sprite3d_oracle.hpp`. Remaining design gap (not emulation): sprites are expanded on the CPU in 2048-centred screen space and submitted as **2D** draws. They cull against GS 1..4095 and do not follow the interpolated camera in present-core display frames. Better: a 3D billboard draw (instanced quad expanded in a vertex shader from position, size and sin/cos), keyed for interpolation. |
| 7 | main `port/src/vu1/*.cpp/.hpp` | Runtime sources expose PS2-format outputs: `PackProg0Xyzf`/`GsXyzf`, `Prog0ClipPacketTag`, `Sprite3dTag`, `Sprite3dVertex.w` ADC word, `WaterVertex{x, y, z, f, adc}`, `WaterState{prmode, psm, ta0}`. They also expose VU1 memory layouts: `Prog0InputOffsets(tops)`, `PackProg0Header`, `Prog0HeaderVariant`, `Prog0BatchLimit(vu1_offset)`, `kRejectMask` clip-flag shift register. | b in intent; linked as ct_port sources (GC'd now) | Move every packed or VU-memory helper under `port/src/tests/` (each stream is doing this: `tests/cmake/prog0.cmake`, `tests/cmake/fx-shadow.cmake`, `tests/vu1_sprite3d_oracle.hpp`). Keep `port/src/vu1/` float-domain only (`vu1_math.hpp` Mul order, Fog, `BuildWaterMesh`, `SdwPrism`, `Sprite3dExpandNative`). Add a grep gate: no `Ftoi4\|0x8000u\|adc\|vu1_offset` under `port/src/vu1`. |
| 8 | s/prog0 tip `port/src/mg_visual.cpp:170-181` | Strip winding parity restarted at each VU1 batch (`Prog0BatchLimit(visual.vu1_offset, ...)`). | a (bug-compatible, uses the VU memory size as a runtime constant) | The working tree already drops it: one winding per strip, batching treated as an artefact. Accept. If a retail-visible cull difference turns up, compute it from MDT data at load, not from the VU layout. |
| 9 | s/prog0 tip `port/src/mg_visual.cpp` (`u_long128 env_packet[4]; SetDrawEnvGifTag(...)` reinterpreted as `mgCDrawEnv`); s/fx-shadow `water.cpp` same call | Calls retail's GIF-tag builder into a packet buffer, then reads it back as registers. | a (state, not a decoder) | The prog0 working tree replaced it with `DrawEnvForAttr` returning `mgCDrawEnv`. fx `water.cpp` should do the same. |
| 10 | Kazarov main `port/gfx/shaders/mesh.vert:64`, `mesh_prog0.vert:206` | Clip XY snapped to 1/16 logical pixel, reproducing the GS 12.4 subpixel grid to close cracks. | a (borderline) | Acceptable, but it caps vertex precision at about 0.28 px at 4K and wobbles under interpolation. Prefer fixing cracks at the source (shared transforms or welded edges), or make the snap a setting. |
| 11 | Kazarov-prog0 `mesh_prog0.vert` (whole file), `gfx.hpp` `Prog0Constants` | Native GLSL reproduction of retail lighting: four directional lights, real specular as a squaring loop, point lights, ref-sphere, skinning, vertex-colour add, fog min/max order, ftoi0 floors, six-plane clip as `gl_ClipDistance`. The UBO comments name VU QW addresses but the layout is std140. | a | None needed. Optional: drop the "QW 0x.." comments once the spec is the reference. |
| 12 | main `port/src/mglib.cpp:458-560` `mgPortGsState`, `mgPortApply*`; draw2d `mgCDrawPrim::Direct` `:395`; `prespr.cpp` | A GS register shadow for TEST/ZBUF/ALPHA/TEXA/CLAMP/TEX1/SCISSOR/FOGCOL, translated to `DrawState` at draw time. Unknown registers (BITBLTBUF/TRXPOS from `menudraw.cpp:1561`) are logged and ignored. | a | Acceptable as briefed (shadow, not a GS emulator). Keep it closed: no new register cases beyond what maps to `DrawState`. |
| 13 | main `port/src/mglib.cpp:89, 204-212, 990-1043` | Vestigial `sceVif1Packet` double buffers, `HasDirectRoom` and the `mgDrawDirect*` cursors. Retail builders still write into buffers nobody reads. | a (dead plumbing, no decoder) | Once every `Draw(u_int*)` path is overridden, stop advancing `pCurrent` and allocating `default_arena`. Keep only the minimum a retail caller dereferences. |
| 14 | main + present-core `mglib.cpp` `render_targets` keyed by TBP0, `frame.FBP = tbp0 >> 5`; the registry key "lands in TBP0 and CBP" | Render targets identified by GS VRAM address. | a | Acceptable translation of game handles. Prefer `mgCTexture*`/registry handles where the caller has one, so no VRAM arithmetic survives. |
| 15 | fx working tree `port/src/outline.cpp:20-127` | Outline box held in 12.4 ints (`mgFotI4`), then divided by 16. | a | Low priority. Carry floats in logical units. The 1/16 quantisation is retail-visible only at 512x480. |
| 16 | `port/src/tests/vu1_*_test.cpp`, `tests/vu1_oracle/*`, `tests/vu1_sprite3d_oracle.hpp` | Spec-vector oracles. | b | Correct place (rule 4). |

## Recommended fixes by owning stream

- **draw2d** (owns `mg_drawprim*`, `mg_sprite`, `mg_tanime`, `menudraw`, `prespr`):
  - (#1) Remove the PACKED decoder from `mgCDrawPrim::Data`/`BeginPrim2(4-arg)`. Override `DivSpriteScreen` (effectlist and gyorace) and the wavetable draw to emit `gfx::Vertex2D` directly.
  - (#6) Commit the float `Sprite3dExpandNative` and the oracle move.
  - (#6 design) Consider a 3D billboard draw so sprites interpolate with the camera.
- **prog0**:
  - Commit the in-flight changes: `vu1/prog0_cpu.*` moved to `tests/vu1/` with `tests/cmake/prog0.cmake`, the batch parity dropped (#8), and `DrawEnvForAttr` (#9).
  - (#2) Once #1 lands, stop routing `Data0`/`Data4` through `Data(lanes)`.
- **fx-shadow**:
  - Commit the z-fail stencil shadow (#3), float water (#4) and the oracle move (#5, #7).
  - (#3) Via NEEDS to the `mglib.cpp` owner: resolve the stencil straight into the main target and retire the AEM/TA0 colour-count composite in `mgEndDrawShadow`.
  - (#5) Confirm whether retail's CClip/TClip/grazing rejects are still applied.
  - (#9) Replace `water.cpp`'s `SetDrawEnvGifTag` with a value-returning helper.
- **present-core** (owns `mglib.cpp`):
  - (#13) Retire the dead VIF packet cursors once the overrides are complete.
  - (#14) Prefer handle-keyed targets.
  - (#3) Accept the fx-shadow NEEDS for `mgEndDrawShadow`.
- **main checkout (merged)**:
  - (#7) After the streams merge, `port/src/vu1/` must hold only float-domain code. Add a CI grep gate.
  - (#10) Decide on the 1/16-pixel snap in Kazarov `mesh*.vert` (shared with Chronicle, so the change goes behind a spec constant).

## Caveat

The prog0, fx and draw2d worktrees changed during the audit (uncommitted edits appeared between reads). Each finding above records whether it refers to the committed tip or the working tree. Re-check after those streams commit.
