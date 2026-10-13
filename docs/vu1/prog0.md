# Vu_prog0 (VU1)

Resident visual-draw microprogram. It is the default program for `mgCVisualMDT` and `mgCVisualMotionMDT` face batches (`ps2/src/mg_visual.cpp`, `ps2/src/visualmotion.cpp`). Each batch of up to 57 vertices (42 with colour) is DMAed to TOPS and run from micro 0x0064. The program skins (optionally), computes environment-map UVs (optionally), lights the vertices in one of four lit families or as constant colour, applies vertex colour (MUL or ADD), transforms to screen space with a perspective divide, optionally clips against the guard band (list and strip variants, scissor flag 0x2), culls by guard box, depth and facing (flag 0x4 and face type), converts to 12.4 fixed point with fog in the W word, and XGKICKs a PACKED GIF packet of ST, RGBAQ and XYZF2 per vertex. Clipped polygons are emitted through a six-plane Sutherland-Hodgman clipper as separate packets at VU 779/780. Nothing in this program writes data back to the CPU.

Conventions. Addresses are micro pair addresses (`0x0064`) for code and VU data quadword (qw) addresses (`QW[0x3B]` or `59`) for data, hex with decimal where it helps. `vfN.c` is lane c (x, y, z, w). `viN` are 16-bit integer registers. `(inferred)` marks an inference not settled by listing or source. Listing: `port/build/vu1/prog0.txt`. Listing of the resident setup program: `port/build/vu1/progmain.txt` (spec `docs/vu1/progmain.md`). CPU references are repo-relative under `ps2/`. Where a claim here corrects an earlier note or ruling, the correction is marked **[corrected]** and listed in section 9.

Execution order used in section 5 is the dispatch order of `__MAIN_PROG__3` (0x007F-0x0102): REF_SPHERE, then VERTEX_BLEND, then one lit routine, then clipping (CLIPSCIS, which runs the clipper), then TRANSPERS, then one output routine.

---

## 1. Role and entry points

| Entry | Issued by | What runs |
|---|---|---|
| Upload | `mgInit`, `ps2/src/mglib.cpp:504-509` (`sceDmaSend`), once. `prog_adr[0] = Vu_prog0` (`mglib.cpp:150`), id `MG_VU_PROG_MAIN = 0` (`include/mglib.hpp:43`). Switched in by `mgSendVuProg` (`mglib.cpp:1901-1918`, callers `mg_visual.cpp:643`, `mg_drawprim.cpp:689`). | Micro 0x0064-0x0662 (MPG 0-5, `progmain.md` summary). Does not overwrite micro 0x0000-0x0054 (Vu_progmain). |
| MSCAL 2 | First batch of each face: `mg_visual.cpp:1063` (`prog_vif`), `:1166-1167`; `visualmotion.cpp:532`. | Pair 0x0002 of Vu_progmain: `iaddiu vi01, vi00, 100; jr vi01` jumps to 0x0064. |
| MSCNT | Later batches of the same face: `mg_visual.cpp:1064`, `:1170`; `visualmotion.cpp:533`. | Resumes at the halt PC left by the previous batch (`nop[E] | b __INIT_DATA__3` at 0x007C, halt after the delay slot 0x007D). |
| MSCAL 0 | Render-info packet, `mg_visual.cpp:1385`. | Runs Vu_progmain only (`progmain.md`). Prog0 is not entered. |

Batch entry (0x0064): `xtop vi12` (0x0064) reads TOPS. Each batch is one pass of the code from 0x0064 to the halt at 0x007C. A batch is never empty: `mg_visual.cpp:1144` (`while (remaining > 0)`) with `count = min(remaining, batch_limit) >= 1`.

Subroutines are entered from the dispatch at 0x007F and return by `jr vi15` (section 2). The entry pairs of the non-dispatch routines are: REF_SPHERE 0x015A, VERTEX_BLEND 0x0104, TRANSPERS 0x017A, LIGHTING_OFF 0x0196, LIGHTING 0x01AB, LIGHTING_VC 0x0207, LIGHTINGC_MUL 0x021C, LIGHTINGC_ADD 0x022A, LIGHTINGM_REAL 0x023A, PLIGHTING 0x02A8, OUTPUT 0x036D, OUTPUTC 0x038A, OUTPUTCN 0x03B8, OUTPUTCN_STR 0x03FE, CLIPSCIS 0x0436, CLIPSCIS_STR 0x047D, SCISSOR 0x04E8, the clipper planes 0x051A-0x0599, the output and cull 0x05A8-0x05E9, SAVE_LAST_LOOP 0x0609, CLIP_INTER 0x0611, INTERPOLATE 0x0642.

Persistence between batches and draws: all vi, vf, Q, I, ACC registers and all VU data memory persist (no clearing in the program or the CPU). Specific consequences are in section 2 (vf05-vf14, vi12 and vi13 are the ones a later batch depends on) and section 3 (scratch regions).

---

## 2. Register conventions

### 2.1 Integer registers

| Reg | Set by (pair) | Meaning |
|---|---|---|
| vi00 | hardware | constant 0 |
| vi01 | 0x0066 (420), then reused as scratch | not a persistent value |
| vi02 | 0x0075 `iaddiu vi02, vi12, 2` | V stream pointer (TOPS+2). Advanced per vertex. Saved and restored by VB (0x0105, 0x0155), LIGHTINGM_REAL (0x023D, 0x029C), PLIGHTING (0x02AA, 0x034D), CLIPSCIS and SCISSOR. |
| vi03 | 0x0079 `iadd vi03, vi06, vi03` (W stream, skinned only) | W pointer in VB. In CLIPSCIS_STR it is the window parity counter (0x0484, 0x04D9). In OUTPUTCN_STR it holds the mask `208 | mirror` (0x040D). |
| vi04 | 0x0076 `iadd vi04, vi02, vi04` (N base = TOPS+2+n) | Normal base in the lit routines; **colour base after lighting** (see 2.3). LIGHTING_OFF sets it to 800 (0x0199). Output reads colour through vi04 (OUTPUT 0x036F, OUTPUTC 0x039B/0x03AA, CN 0x03CF-0x03D1, CN_STR 0x040F). |
| vi05 | 0x0077 `iadd vi05, vi04, vi05` (UV base) | UV / ST base. TRANSPERS writes UV*Q in place through vi07 = vi05 (0x017D). Clipper and output read ST through vi05. |
| vi06 | 0x0078 `iadd vi06, vi05, vi06` (colour base) | Raw vertex colour base (VC MUL/ADD read it). All four output routines use vi06 as the output write pointer, set from vi13 (OUTPUT 0x0371, OUTPUTC 0x038D, OUTPUTCN 0x03BC, OUTPUTCN_STR 0x0403). |
| vi07-vi10 | scratch in every routine | Loop pointers and masks. VB uses vi07-vi10 as bone offsets (0x011A-0x011D). |
| vi11 | 0x0070 `iand vi11, vi07, vi08` (count) | Vertex count n = NLOOP & 0x7FFF. Saved/restored by VB and the lit routines. |
| vi12 | 0x0064 `xtop vi12` | TOPS. Batch base in the input buffer (double-buffer base set by the CPU VIF BASE/OFFSET). |
| vi13 | 0x0068-0x006C (toggle); set to 420 by progmain at 0x001F | Output packet base for this batch. 420 or 600, alternating per batch (section 6). |
| vi14 | 0x0065 `iaddiu vi14, vi00, 1024`; push/pop in every routine | Stack pointer, grows down. Top of the stack is 1023 (main's return address, 0x0080). |
| vi15 | `bal vi15` (dispatch 0x007A, 0x0088, 0x0092, ...) | Link. Leaf routines (REF_SPHERE, TRANSPERS, the output routines) return by `jr vi15`. MAIN saves it (0x0080). LIGHTING_VC saves it (0x0207-0x0208), and CLIPSCIS and CLIPSCIS_STR save it (0x043A, 0x0481) before their `bal vi15, __SCISSOR`. VB and SCISSOR do not save vi15. |
| vi02 (clipper) | `bal vi02, __CLIP_INTER` (0x0527 etc.), `bal vi02, __SAVE_LAST_LOOP` (0x052E) | Clipper link register (distinct use of vi02 after SCISSOR entry). `jr vi02` at 0x0640 and 0x060F. |
| vi01 (clipper) | `bal vi01, __INTERPOLATE` (0x0625, 0x0631) | Interpolation link. Also the clip-flag temp in CLIP_INTER (0x061A). |
| vi08, vi09 (clipper) | 0x0506/0x0507 (860, 920); per pass 0x051F-0x0520 etc. | Input and output polygon buffer pointers. Output loop counter vi09 (0x05B7). |
| vi10 (clipper) | 0x051A `iaddiu vi10, vi00, 0`; per pass `vi10 = vi11` (0x0521) | Edge loop counter. |
| vi11 (clipper) | 0x051B = 3; then per pass vi11 = output count | Output count of the current pass. 0 = nothing left to emit. |

Stack: pushes are `iswr`/`sqd --vi14` (pre-decrement), pops `lqi (vi14++)`/`ilwr (vi14)` with `iaddi vi14, 1`. The depth of each routine is in section 4.4.

### 2.2 Float registers

| Reg | Set by | Meaning in prog0 |
|---|---|---|
| vf00 | hardware | (0, 0, 0, 1). Used as the source of 0 (`.x`), 1 (`.w`) and in `sub.w` idioms. |
| vf01 | progmain (1,1,1,1) | Multiplier for `mulw`/`mulx` copies (PLIGHTING 0x02CE-0x02D1, 0x02E2, 0x02E6-0x02F1). |
| vf02-vf04 | progmain 0x0010-0x002D | Normalised light directions in model space. `L_c = (vf02.c, vf03.c, vf04.c)`, c = light index (x, y, z, w = lights 0..3). |
| vf05-vf08 | progmain 0x0011-0x0018 (= QW15-18) | Light colours C_c. The lit routines overwrite them with C_c*D (LIGHTING 0x01AF, LIGHTINGM_REAL 0x0246, PLIGHTING 0x02B7); the originals are pushed and restored in each routine. |
| vf09 | progmain 0x001C (= QW19) | Ambient AMB, multiplied by D in place by the same routines. |
| vf10-vf13 | progmain 0x0015-0x001A (= QW4-7) | model_screen columns (TRANSPERS). LIGHTINGM_REAL overwrites vf10-13 with C_c*U and VB overwrites vf01-vf14 (pushed and restored by VB, 0x0109-0x0116 / 0x0144-0x0151). |
| vf14 | progmain (0, 255, z, w) | vf14.y = 255.0. All live clamps are `miniy` against vf14.y: 0x019C, 0x01C5, 0x0223, 0x0233, 0x028D, 0x0339 (and 0x01FB in the dead `__LIGHTINGC`). |
| vf15-vf31 | per-routine | Scratch. VB writes vf15-vf31 (except vf24 kept in its loops); the clipper and output routines use vf15-vf29. |
| Q | DIV/RSQRT | Reciprocal. The output routines use `div Q, vf00w, vf(w)` and read Q after 7 pairs (section 5.6). |
| I | `loi` immediate (I-bit pairs) | Immediate for `*I` ops. Values used: 0.5 (REF 0x016B), 128.0 (ADD 0x022F), 1e-4 and 10000 (M_REAL 0x0263, 0x026B), 2048.0 (CN/OUTPUTC 0x039D, 0x03D5), 1.0 (clipper 0x05C3), -1.0 (STR parity 0x0420), 4095 or 254 (progmain). |

### 2.3 Colour base after lighting **[resolves an earlier open point]**

Every lit routine leaves vi04 as the colour base for the output stage:

- LIGHTING, LIGHTINGM_REAL, LIGHTINGC_MUL, LIGHTINGC_ADD: write colour in place at vi04 + i (vi08 = vi04 copies).
- PLIGHTING: writes at vi10 (= entry vi04, 0x02BC), and pops vi04 at 0x034C (`ilwr.y vi04`), so vi04 is restored.
- LIGHTING_OFF: sets vi04 = 800 (0x0199) and writes colour at 800 + i.

The output stage reads colour through vi04 only (OUTPUT 0x036F and 0x0380, OUTPUTC 0x039B and 0x03AA, CN 0x03CF-0x03D1, CN_STR 0x040F, all `lqi vf, (vi04++)`). ST is read through vi05 (0x037A). The raw colour stream (vi06) is read only by the VC routines, which run before TRANSPERS. TRANSPERS overwrites the raw colour region in variants 3/7 (vi05 = colour start), which is harmless for that reason (**[corrected]**: earlier notes said colour is read via vi05 or was corrupted; the listing does not do that).

### 2.4 Persistent state read by later batches

- vi13 (output base) is toggled each batch; progmain sets vi13 = 420 on each MSCAL 0, so the first batch of every draw writes 600 (0x0068 `ibeq vi13, vi01` with vi01 = 420).
- vf05-vf09 and vf10-vf13 are set by progmain for every draw and survive all routines (VB and the lit routines push and restore them).
- vf15 and vf16 hold the guard corners only inside progmain; the output routines reload QW21/QW22 themselves (0x038A, 0x038B and the equivalents).
- vf30 and vf31 are the previous two strip vertices in OUTPUTCN_STR and persist across batches (section 7.4).
- vi08 and vi09 persist into OUTPUTC and OUTPUTCN_STR window state across batches (section 7.4).

---

## 3. Data memory map (qword units)

### 3.1 Constant block 0x00-0x3B

Written by `mg_visual.cpp` render-info packet (per draw) or by `mglib.cpp` (per frame) or by progmain (per MSCAL 0). "stale" means not written by the packet and whatever VU memory held before.

| QW (hex) | dec | Contents | Writer | Readers (prog0 pairs) |
|---|---|---|---|---|
| 0x00-0x02 | 0-2 | not written by mg_visual (stale) | `mg_sprite.cpp:111-113`, `water.cpp:463` (other programs) | none |
| 0x03 | 3 | unk_20, never assigned (stale) | `mg_visual.cpp:1277` (UNPACK base 0x003) | none |
| 0x04-0x07 | 4-7 | model_screen = world_screen * model_world, columns 0..3 (vf10-vf13 after progmain) | `mg_visual.cpp:1245-1249` | TRANSPERS 0x017E-0x0184 (vf10-13) |
| 0x08-0x0B | 8-11 | model_world (object matrix) columns | `mg_visual.cpp:1238-1241` | progmain 0x000E-0x002D (cols 0-2); PLIGHTING 0x02D4-0x02D7 (cols 0-2: rotates the point-light offsets and normals, 5.7) |
| 0x0C-0x0E | 12-14 | light_dir: light k direction = (QW12.k, QW13.k, QW14.k), k = 0..3 (world space) | `mg_visual.cpp:1259-1261`; `mapinfo.cpp:401-404` (normalised at 401) | progmain 0x000A-0x0016 (vf19-21 -> vf02-04, model space, normalised per light) |
| 0x0F-0x12 | 15-18 | light_color: row/column k = colour of light k, w = 0 | `mg_visual.cpp:1262`; `mapinfo.cpp:408-409` | progmain 0x0011-0x0018 (vf05-08); VC-independent lit routines use them as C_c |
| 0x13 | 19 | ambient AMB, w = ambient.w * obj_alpha | `mg_visual.cpp:1263-1264` | progmain 0x001C (vf09); LIGHTING, LIGHTINGM_REAL, PLIGHTING |
| 0x14 | 20 | object_color, w = object alpha * obj_alpha. If ambient_boost: rgb = ambient + 0.3*light_color[0] (column 0) | `mg_visual.cpp:1266-1275` | LIGHTING_OFF 0x0196-0x0197 |
| 0x15 | 21 | G_max: scissor path = guard_max (QW57); else (4095, 4095, z, w of QW57). w = far | progmain 0x004E from vf15 (`progmain.md` 2.3) | OUTPUTC 0x038A (vf22), OUTPUTCN 0x03C5 (vf22), CN_STR 0x0407 (vf22) |
| 0x16 | 22 | G_min: scissor path = guard_min (QW58); else (1, 1, z, w of QW58). w = near | progmain 0x004F from vf16 | output 0x038B (vf15), CN 0x03B9, CN_STR 0x0408 |
| 0x17 | 23 | not used by prog0 (fog copy belongs to prog_3dsp, `mg_sprite.cpp:123`) | - | none |
| 0x18 | 24 | eye E (model space, w = 1). Only when program_mode != 0 | `mg_visual.cpp:1279-1293` | LIGHTINGM_REAL 0x024C (`lq vf16, 24(vi00)`) |
| 0x19-0x1C | 25-28 | EITHER model_clip = world_clip * model (scissor, `mg_visual.cpp:1300-1301`) OR view * model (program_mode & 2, `:1330-1331`). If both are set the view block replaces the clip block (section 9, O-18) | `mg_visual.cpp:1296-1331` | CLIPSCIS 0x043B-0x043E, CLIPSCIS_STR 0x0485-0x0488 (model_clip); REF_SPHERE 0x015D-0x015F (view*model, cols 0-2) |
| 0x1D-0x20 | 29-32 | clip_screen columns 0..3 (scissor only). col3 = (2048, 2048, z_r/2 * depth bias, 1). Written only when scissor; `clip_screen[2][2] = -z_r/2`, `[3][2] = +z_r/2` | `mg_visual.cpp:1302-1305`; `mg_drawenv.cpp:209-219` | clipper output 0x05A4-0x05A7 (vf26-vf29) |
| 0x1E | 30 | .x = mirror word: integer 0 or 32 (word 0x00000000 / 0x00000020), written by progmain 0x0042 (`isw.x`). .yzw = clip_screen[1] (scissor only) | progmain 0x0042 (`progmain.md` 3.1) | CN 0x03CA `ilw.x vi08`, CN_STR 0x040B `ilw.x vi08`, clipper cull 0x05DC `ilw.x vi10`; clipper load 0x05A5 (`lq vf27`, x = flushed denormal = 0.0) |
| 0x21-0x25 | 33-37 | not written by the visual packet | - | none |
| 0x26 | 38 | flags word, .x (section 4.2) | `mg_visual.cpp:1335-1381` (UNPACK 0x026 at `:1378`) | dispatch 0x0081, 0x008A, 0x009A, 0x00BC, 0x00E1; clipper 0x05D1; the C/CN routines do not read it |
| 0x27 | 39 | end GIF tag template (NLOOP 0, PRIM 0x5D, PACKED, NREG 3, REGS 2,1,4) | `mg_visual.cpp:1116-1139` (`end_tag.PRIM = 0x5D` at `:1130`; template copied before NLOOP is set, `:1158`) | dispatch 0x00D5 (`lq vf15, 39`); clipper 0x05A8 |
| 0x28 | 40 | material diffuse D (1.0 scale) | `mg_visual.cpp:189-227` (`mat_vif` UNPACK NUM 4 addr 40, `:1586`) | every lit routine (vf19 at 0x01AB, 0x023B, 0x02A8...) |
| 0x29 | 41 | material U (specular colour, 4 floats) | `mg_visual.cpp:197, 207` (texture==NULL and flags&1 branches only) | LIGHTINGM_REAL 0x023A (vf28), 0x024B |
| 0x2A | 42 | 0 | `mg_visual.cpp:198, 208` | none |
| 0x2B | 43 | mat_pw = 3 (integer in x) | `mg_visual.cpp:99, 199, 209` | LIGHTINGM_REAL 0x024F (`ilw.x vi07, 43`) |
| 0x2C | 44 | E27 (progmain, un-normalised) | progmain 0x0020 | none |
| 0x2D-0x30 | 45-48 | point light i: pos xyz = light.pos - matrix[3] (model origin), w = power | `mg_visual.cpp:1316-1323`; `SetPointLight` `:173-190` (UNPACK NUM 8 addr 0x2D) | PLIGHTING 0x02CA-0x02CD (vf20-23) |
| 0x31-0x34 | 49-52 | point light i colour, w = 0 | `SetPointLight` `:183-186` | PLIGHTING 0x02C0 (`lq vf16-19`, 0x02BD-0x02C0) |
| 0x35-0x38 | 53-56 | not written | - | none |
| 0x39 | 57 | guard_max = (2048 + 0.55 W, 2048 + 0.55 H, 0, far). Per frame | `mglib.cpp:1244-1246` (`words[12..15]`); `mg_drawenv.cpp:139-146` | progmain 0x0046 (vf15) |
| 0x3A | 58 | guard_min = (2048 - 0.55 W, 2048 - 0.55 H, 0, near). Per frame | `mglib.cpp:1246-1247` (`words[16..19]`) | progmain 0x0047 (vf16) |
| 0x3B | 59 | fog: x = offset, **y = near_value, z = far_value**, w = scale. Per frame | `mglib.cpp:1237-1240` (`words[4..7]`: offset, near_value, far_value, scale) | OUTPUT 0x036D, OUTPUTC 0x0397, CN 0x03C8, CN_STR 0x040A, clipper 0x05B6 (`lq vf22`) |

Fog layout and derivation (ruling 1). The CPU call is `mgSetFogParam(near_dist, far_dist, r, g, b, far_value, near_value)` (`mglib.cpp:1185-1187`), so the 6th argument is the far value and the 7th is the near value. `mgRENDER_INFO::SetFogParam` sets `values[1] = depth_max` (6th) and `values[2] = depth_min` (7th) and computes (`mg_drawenv.cpp:424-444`)

```
range   = dmax - dmin                           (dmax = 6th, dmin = 7th)
offset  = (dmax + dmin + range*(far+near)/(far-near)) / 2
scale   = -far*near*range / (far-near)
F(w)    = offset + scale / w                    (F = offset + scale*Q, Q = 1/w)
```

At w = near: F = (dmax+dmin)/2 + range*(near-far)/(2(far-near)) = (dmax+dmin)/2 - range/2 = dmin, which is the 7th argument (`values[2]` = qw.y). At w = far: F = (dmax+dmin)/2 + range/2 = dmax, the 6th argument (`values[1]` = qw.z). The VU clamp `F' = max(min(F, qw.y), qw.z)` is therefore `max(min(F, 7th), 6th)`. It is the identity on [6th, 7th] when 7th >= 6th (the normal case, in-game 255 near and 0 far), and collapses to the constant 6th when 6th > 7th. The only call in the repo with 6th > 7th is `editexception.cpp:497` (`mgSetFogParam(50, 400, 100, 0, 0, 255, 0)`), which gives F' = 255 everywhere, i.e. no fog. That is a property of the editor's data, not a defect of the clamp.

### 3.2 Bone block 0x3C+ (skinned draws only)

| QW | Contents | Writer | Readers |
|---|---|---|---|
| 0x3C + 4i .. 0x3C + 4i + 3 (i = bone slot, 0..n-1) | bone i matrix, column-major: col c = QW[0x3C + 4i + c]; the VU reads col c at `lq ..., 60 + off_i + c` with off_i = 4i | `visualmotion.cpp:723-748` (DMA CNT `0x10000000 | (slot_count << 2)`, `:723`; UNPACK V4-32 NUM = 4*slot_count at addr 0x3C, `:726`; one `mgMulMatrix` per slot, `:744`); bone offsets `matrix[influence] = bone_index*4` at `visualmotion.cpp:125` | VB 0x011E-0x013A (`lq 60..63(vi07..vi10)`, `:1E`) |
| after the bone block | MDT (non-skinned): no bone block; batches start at 0x3C (`mg_visual.cpp:339-342`, BASE 60, OFFSET 180). Skinned: batches start at vu1_base = 0x3C + 4n (`visualmotion.cpp:232-233`, OFFSET 0xB4 - 2n) | | |

Bone block placement is emitted after MSCAL 0 inside the render-info packet (`visualmotion.cpp:684-749`, `mg_visual.cpp:1427`). The VIF/VU ordering is not established by the repo (O-27).

### 3.3 Batch input at TOPS (vi12), FLG relative

TOPS is `xtop` (0x0064): TOPS = 60 (0x3C) for MDT, TOPS = 60 + 4n for skinned with n bone slots (`visualmotion.cpp:232-233`). The batch is one `UNPACK V4-32` with FLG (`mg_visual.cpp:1163`, `:1165-1172`).

| TOPS + | Content | Read at (VU) | Written by (CPU) |
|---|---|---|---|
| +0 | Batch GIF tag. x = `count | 0x8000` (NLOOP bits 14..0, EOP bit 15). y, z, w: PRE = 1, PRIM = 0x5C (strip) or 0x5B (list), FLG = 0, NREG = 3, REGS = 2, 1, 4 | x: 0x006E (`ilwr.x vi07, (vi12)`); whole qw: 0x0370 (OUTPUT), 0x038C (OUTPUTC), 0x03BA (OUTPUTCN), 0x0402 (CN_STR) | `mg_visual.cpp:1115-1131` (template), `:1158` (NLOOP); `visualmotion.cpp:589-591, 627` |
| +1 | Header, 4 dwords: dw0 = V count n; dw1 = N count; dw2 = colour count (see 3.4); dw3 = face type T | dw0 0x0071/0x0076 (`ilw.x vi04`); dw1 0x0073/0x0077 (`ilw.y vi05`); dw2 0x0074/0x0078 (`ilw.z vi06`); dw3 0x0094, 0x00C4, 0x00E7, 0x01A1, 0x01CF, 0x029E, 0x034F (`ilw.w vi01`) | `mg_visual.cpp:813-817` (SetData0) ... `:1040-1044` (SetData7); `visualmotion.cpp:268-520` |
| +2 .. | Streams, one qw per element, in the order V, N, UV, C, W (each present only for its variant). W is 2 qw per vertex (qw0 = int bone offsets of 4 influences, qw1 = float weights) | per routine (see below) | `mg_visual.cpp:813-1044`; `visualmotion.cpp:268-520` |

Stream pointers (computed for every batch, 0x0075-0x0079):

```
vi02 = TOPS + 2                 // V start              (0x0075)
vi04 = vi02 + dw0               // N start              (0x0071, 0x0076)
vi05 = vi04 + dw1               // UV start             (0x0073, 0x0077)
vi06 = vi05 + dw2               // colour start         (0x0074, 0x0078)
vi03 = vi06 + dw0               // W start (skinned)    (0x0072, 0x0079)
n    = vi11 = (tag.x & 0x7FFF)  // vertex count         (0x006E, 0x0070)
```

The loops iterate n times and the header dw0 is used only for these pointers.

### 3.4 Header dword values per variant (verified against the writers)

Variant = (COLOUR ? 1) + (NO_TEXTURE ? 2) + (NO_NORMAL ? 4) (`mg_visual.cpp:1100-1113`; flags COLOUR 0x100, NO_NORMAL 0x200, NO_TEXTURE 0x010, `mg_visual.hpp:26-30`).

| Variant (SetDataN) | Streams after header | Header (dw0, dw1, dw2) | VU vi04 (N) | vi05 (UV) | vi06 (colour) | Correct? |
|---|---|---|---|---|---|---|
| 0 SetData0 | V, N, UV | (n, n, n) | V+n | V+2n | V+3n (unused) | yes |
| 1 SetData1 | V, N, UV, C | (n, n, n) | V+n | V+2n | V+3n | yes |
| 2 SetData2 | V, N | (n, n, n) (`:884`) | V+n | V+2n (= batch end, no UV) | V+3n (unused) | yes for the VU; dw2 is a stale UV count |
| 3 SetData3 | V, N, C | (n, n, 0) (`:912-916`) | V+n | V+2n (= colour start) | V+2n | yes |
| 4 SetData4 | V, UV | (n, 0, n) (`:946-948`) | V+n (= UV start) | V+n | V+2n | yes |
| 5 SetData5 | V, UV, C | (n, 0, n) (`:977-979`) | V+n | V+n | V+2n | yes |
| 6 SetData6 | V | (n, 0, 0) (`:1009-1012`) | V+n (= batch end) | V+n | V+n | yes (**[corrected]**: part 2 wrote header (0,0,0,T) and vi04 = vertex; the CPU writes count to dw0 at `:1009`) |
| 7 SetData7 | V, C | (n, 0, 0) (`:1040-1044`) | V+n (= colour start) | V+n | V+n = colour start | **yes** (**[corrected]**: earlier notes said the colour pointer was wrong; see C-6 in section 9) |

Skinned (visualmotion.cpp, `:268-520`). The same pointers, plus vi03 = W start:

| Variant | dw0 | dw1 | dw2 | VU UV (vi05) | VU colour (vi06) | VU W (vi03) | Correct? |
|---|---|---|---|---|---|---|---|
| V0 (V,N,UV,W) | n | n | 0 (`:278`) | V+2n | V+2n (= UV end, unused) | V+3n | yes |
| V1 (V,N,UV,C,W) | n | n | n (`:313`) | V+2n | V+3n | V+4n | yes |
| V2 (V,N,W) | n | **0** (`:347`) | 0 (`:348`) | V+n (= N start, aliases N) | V+n | V+2n | W yes; UV pointer wrong (O-25) |
| V3 (V,N,C,W) | n | n | 0 (`:379`) | V+2n = colour | V+2n | V+3n | yes |
| V4 (V,UV,W) | n | 0 (`:412`) | 0 (`:413`) | V+n | V+n | V+2n | yes |
| V5 (V,UV,C,W) | n | 0 (`:444`) | n (`:445`) | V+n | V+2n | V+3n | yes |
| V6 (V,W) | **0** (`:475`) | 0 (`:476`) | 0 (`:477`) | V (wrong) | V | V (wrong, should be V+n) | **no** (O-26) |
| V7 (V,C,W) | n | 0 (`:505`) | 0 (`:506`) | V+n | V+n | V+2n | yes |

Note on skinned dw2: V0 and V4 write dw2 = 0 while they do write a UV stream. With dw2 = 0 the colour pointer vi06 is the UV end, and W = vi06 + dw0 = UV end + n lands after the UV stream. The VU reads header values only through the pointer formulas above, so dw2 here is a pointer offset, not a count.

Batch sizes (CPU, `mg_visual.cpp:1098`, `:1104`; `visualmotion.cpp:566`, `:572`):
- Non-skinned: `batch_limit = (vu1_offset - 2) / 3 / 3 * 3` = 57 for vu1_offset = 180 (no colour), `(vu1_offset-2)/4/3*3` = 42 (colour). Both are multiples of 3; 57 is odd (section 7.3 uses this).
- Skinned: `(vu1_offset - 2)/5/3*3` (no colour), `/6/3*3` (colour).
- Output sizes: a 57-vertex batch writes 1 + 3*57 = 172 qw at 420 (ends at 591) or 600 (ends at 771), both below the clip packet at 779.

### 3.5 Output buffers and clip packets

| Address | Content | Writer | Reader |
|---|---|---|---|
| 420 (0x1A4) | batch output packet (GIF tag + 3n qw or 9 per triangle), used on alternate batches | OUTPUT (0x037B-0x0385), OUTPUTC (0x0393-0x03B3), OUTPUTCN (0x03C1-0x03F9), OUTPUTCN_STR (0x0406-0x042F) | xgkick vi13 at 0x0386, 0x03B4, 0x03FA, 0x0430 |
| 600 (0x258) | same, the other half | same | same |
| 779 (0x30B) | empty GIF tag: x = 0x8000 (NLOOP 0, EOP), y/z/w = template (PRIM 0x5D) | clipper 0x05A9-0x05AD (`iswr.x`, `sq.yzw vf15`) | xgkick vi07 = 779 at 0x05B1 |
| 780 (0x30C) | clip packet tag (x = 0x8000 + N_out, EOP; y/z/w = template) then 3 qw per output vertex (ST, RGBAQ, XYZF2) | clipper 0x05B2-0x05B5 (tag), 0x05B8-0x05CF (records) | xgkick vi07 = 780 at 0x05E7 (only when not culled) |
| 781 .. 807 | clip packet vertex records (N_out <= 9, so max 780 + 1 + 27 = 807) | clipper output | as above |
| 800-856 (0x320-0x358) | LIGHTING_OFF colour, one qw per vertex (800 + i) | LIGHTING_OFF 0x019E | VC routines and output via vi04 = 800 |
| 800-808 | PLIGHTING temporaries: 800-804 = C_c*D and AMB*D, 805-808 = pt_k = colour_k * D | PLIGHTING prologue 0x02C1-0x02C9 | PLIGHTING loop 0x0316-0x0339 |
| 860-919 (0x35C-0x397) | polygon buffer A (20 records of 3 qw). Input of the first clip pass, output of planes Z+, X+, Y+ | SCISSOR 0x050E-0x0519 (860-871), planes | planes, clipper output 0x05A3 (vi02 = 860), cull 0x05D7-0x05D9 |
| 920-979 (0x398-0x3D3) | polygon buffer B (20 records). Output of planes Z-, X-, Y- | planes | planes |
| 1004-1023 (0x3EC-0x3FF) | stack, used by MAIN (1023), VB (1008-1022), CLIPSCIS (1022), SCISSOR (1004-1021, 18 qw), OUTPUTCN_STR (vi03, 1 qw) | push/pop | - |

Clipper record layout (buffers A and B): +0 position (x, y, z, w) float, clip space on input and after the output loop screen space (x/w, y/w, z/w, min(F, near)); +1 colour (float RGBA, raw 0..255); +2 uv (x, y = s, t; z = uv.z; w = 0 after a crossing).

---

## 4. Control flow

### 4.1 Batch dispatch (`__MAIN_PROG__3`, 0x007F-0x0102)

Every test reads the flags word QW[38].x (`ilw.x vi01, 38(vi00)`, 0x0081, 0x008A, 0x009A, 0x00BC, 0x00E1) or the header type T = dw3 (`ilw.w vi01, 1(vi12)`, 0x0094, 0x00C4, 0x00E7). Masks are `iaddiu` immediates AND-ed in.

| # | Pair | Test | Taken / effect |
|---|---|---|---|
| T1 | 0x0082-0x0086 | F & 0x100 (program_mode & 2) | clear: `ibeq` to 0x008A; set: `bal __REF_SPHERE` (0x0088) |
| T2 | 0x008C-0x0090 | F & 0x40 (motion) | clear: `ibeq` to 0x0094; set: `bal __VERTEX_BLEND` (0x0092) |
| T3 | 0x0095-0x0098 | T & 0x200 (NO_NORMAL) | taken: `ibne` to 0x00A4 (LIGHTING_OFF) |
| T4 | 0x009B-0x00A2 | F & 0x20 (no light / ambient boost) | set: fallthrough to 0x00A4 (LIGHTING_OFF); clear: `ibeq vi09, vi00` to 0x00A8 |
| T5 | 0x00A8 | F & 0x08 (program_mode & 1) | clear: `ibeq` to 0x00B4 (lt1) |
| T6 | 0x00AA / 0x00B4 | F & 0x10 (plight_hit) | clear: `ibeq` to 0x00B0 (M_REAL, lt0) or 0x00BA (LIGHTING, lt1) |
| T7 | 0x00BC-0x00C2 | F & 0x02 (scissor) | clear: `ibeq` to 0x00DF (TRANSPERS), skipping the clip |
| T8 | 0x00C4-0x00CB | (T & 7) == 4 (strip) | taken: `bal __CLIPSCIS_STR` (0x00D1); else `bal __CLIPSCIS` (0x00CD) |
| T9 | 0x00D3 | `iblez vi11` | n <= 0: skip to end. Only on the clip path (see 4.3) |
| T10 | 0x00E1-0x00E6 | F & 0x04 (program_option, 'S') | clear: `ibeq` to 0x00F6 (T12) |
| T11 | 0x00E7-0x00EC | (T & 7) == 4 | taken: `bal __OUTPUTCN_STR` (0x00F2); else `bal __OUTPUTCN` (0x00EE) |
| T12 | 0x00F6-0x00F8 | F & 0x01 (clip or scissor) | clear: `bal __OUTPUT` (0x00FC); set: `bal __OUTPUTC` (0x00F8) |

Lit-routine choice (0x0094-0x00BB), as one table (verified against T3-T6):

| T&0x200 | F&0x20 | F&0x08 | F&0x10 | Routine |
|---|---|---|---|---|
| 1 | - | - | - | LIGHTING_OFF |
| 0 | 1 | - | - | LIGHTING_OFF |
| 0 | 0 | 0 | 0 | LIGHTING (0x01AB) |
| 0 | 0 | 0 | 1 | PLIGHTING (0x02A8, via 0x00B6) |
| 0 | 0 | 1 | 0 | LIGHTINGM_REAL (0x023A, via 0x00B0) |
| 0 | 0 | 1 | 1 | PLIGHTING (via 0x00AC) |

Every lit routine ends with the vertex-colour step: if T & 0x100 (COLOUR), `b __LIGHTING_VC` (0x0207), which does MUL (F & 0x80 clear) or ADD (F & 0x80 set). This applies to LIGHTING_OFF too (0x01A1-0x01A5).

### 4.2 Flags word bit meanings (CPU, `mg_visual.cpp:1335-1381`)

| Bit | Mask | CPU condition | Meaning | Tested by prog0 at |
|---|---|---|---|---|
| 0 | 0x001 | clip \| scissor (`:1337-1339`) | clip or scissor needed (selects OUTPUTC) | 0x00F6 (T12) |
| 1 | 0x002 | scissor (`:1341-1343`) | scissor: model_clip block present; enables CLIPSCIS | 0x00BC |
| 2 | 0x004 | program_option (`:1355-1357`) | 'S' name flag; selects the N (facing) output routines and the clipper cull | 0x00E1, 0x05D1 |
| 3 | 0x008 | program_mode & 1 (`:1345-1348`) | selects M_REAL/PLIGHTING lit path | 0x00A0 |
| 4 | 0x010 | plight_hit (`:1359-1361`) | point lights present | 0x00A1 |
| 5 | 0x020 | no_light / !lighting_enabled / ambient_boost (`:1367-1369`) | LIGHTING_OFF | 0x009A |
| 6 | 0x040 | motion (`:1363-1365`) | run VERTEX_BLEND | 0x008C |
| 7 | 0x080 | attr->unk_84 == 1 (`:1371-1373`, 'Vc' name flag) | VC ADD (else MUL) | 0x0209 |
| 8 | 0x100 | program_mode & 2 (`:1350-1352`) | run REF_SPHERE | 0x0082 |

Header type T (`mg_visual.hpp:26-30`): 0x010 NO_TEXTURE, 0x100 COLOUR, 0x200 NO_NORMAL, low 3 bits = primitive (4 = triangle strip, `mg_drawprim.hpp:29`). The CPU always sets 0x001 when it sets 0x002 (both from `clip \| scissor` and `scissor`, `:1337-1343`), so the combination "scissor without clip" is unreachable from the CPU.

### 4.3 Flags -> subroutine sequence (decision table)

Order of calls, always from the top: [REF] [VB] [lit routine] [VC step] [CLIPSCIS or CLIPSCIS_STR, if F & 0x02] [TRANSPERS] [output].

| F (flags) | T | Pre-calls | Lit routine | Clip | Output |
|---|---|---|---|---|---|
| any | & 0x200 or F & 0x20 | - | LIGHTING_OFF | per F & 0x02 | per F & 0x04 / 0x01 |
| 0x000 | any | - | LIGHTING | - | OUTPUT (T&7 has no effect without F & 0x05) |
| 0x001 | any | - | LIGHTING | - | OUTPUTC |
| 0x004 | list | - | LIGHTING | - | OUTPUTCN |
| 0x004 | strip (T&7=4) | - | LIGHTING | - | OUTPUTCN_STR |
| 0x005 | any | - | LIGHTING | - | OUTPUTCN or OUTPUTCN_STR (F & 0x04 wins over F & 0x01) |
| 0x002 + 0x001 = 0x003 | list | - | LIGHTING | CLIPSCIS | OUTPUTC |
| 0x003 | strip | - | LIGHTING | CLIPSCIS_STR | OUTPUTC |
| 0x007 | list | - | LIGHTING | CLIPSCIS | OUTPUTCN |
| 0x007 | strip | - | LIGHTING | CLIPSCIS_STR | OUTPUTCN_STR |
| 0x002 alone | any | - | LIGHTING | (unreachable: CPU sets 0x001) | OUTPUT |
| 0x008 | any | - | LIGHTINGM_REAL | - | OUTPUT |
| 0x010 | any | - | PLIGHTING | - | OUTPUT |
| 0x018 | any | - | PLIGHTING | - | OUTPUT |
| 0x020 | any | - | LIGHTING_OFF | - | OUTPUT |
| 0x040 | any | VB | (lit by F & 0x08/0x10/0x20 table) | - | OUTPUT |
| 0x100 | any | REF | LIGHTING | - | OUTPUT |
| 0x140 | any | REF, VB | (as above) | - | (as above) |
| any, T & 0x100 | any | - | (as above) + VC | - | - |
| F & 0x80 with T & 0x100 | any | - | (as above) + VC ADD | - | - |

Clip is applied after the lit routine and before TRANSPERS, so CLIPSCIS reads the model-space V stream (the position stream is not yet transformed). The clipper emits its own packets (779/780) during CLIPSCIS. The batch's normal output packet is kicked later, after TRANSPERS, so a clipped triangle is drawn before the batch packet.

The `iblez vi11` guard (0x00D3) runs only on the clip path; the non-clip branch at 0x00C2 jumps straight to TRANSPERS (0x00DF). Harmless because batches are never empty.

### 4.4 Subroutine call graph and stack depth

```
__MAIN_PROG__3 (0x007F) -- bal --> __REF_SPHERE (0x015A)  leaf, jr vi15
                        -- bal --> __VERTEX_BLEND (0x0104) pushes vi02-04, vi11, vf01-14
                        -- bal --> LIGHTING_OFF (0x0196) | LIGHTING (0x01AB) | LIGHTINGM_REAL (0x023A) | PLIGHTING (0x02A8)
                                   each may -- b --> __LIGHTING_VC (0x0207) which
                                   -- bal --> __LIGHTINGC_MUL (0x021C) | __LIGHTINGC_ADD (0x022A)
                        -- bal --> __CLIPSCIS (0x0436) | __CLIPSCIS_STR (0x047D)
                                   -- bal --> __SCISSOR (0x04E8) -- falls into __PLANE_START (0x051A)
                                   -- bal vi02 --> __CLIP_INTER (0x0611) -- bal vi01 --> __INTERPOLATE (0x0642)
                                   -- bal vi02 --> __SAVE_LAST_LOOP (0x0609)
                        -- bal --> __TRANSPERS (0x017A)  leaf, jr vi15
                        -- bal --> __OUTPUT (0x036D) | __OUTPUTC (0x038A) | __OUTPUTCN (0x03B8) | __OUTPUTCN_STR (0x03FE)
```

Stack depth: MAIN 1 qw (1023); VB 15 qw (1008-1022, pushes vi02, vi03, vi04, vi11 as one qw then vf01-vf14); PLIGHTING 1 + 12 qw (vi02, vi04, vi06, vi11 as one qw, then vf02-vf13); LIGHTINGM_REAL 1 + 9 qw; LIGHTING 5 qw (vf05-vf09); LIGHTING_VC 1 qw (vi15); CLIPSCIS 1 qw (vi02, vi04, vi05, vi15); CLIPSCIS_STR 2 qw (+ vi03); SCISSOR 18 qw (vi01-vi12 as 3 qw, vf15-vf29 as 15 qw). Clip path stack minimum is 1004 (0x3EC).

### 4.5 Loop counters

| Routine | Counter | Iteration | Loop-back |
|---|---|---|---|
| VB | vi11 = n (0x0070) | 1 vertex, pipelined | 0x0142 `ibne vi11` |
| REF_SPHERE | vi09 = n | 1 vertex | 0x0176 `ibne vi09` |
| TRANSPERS | vi09 = n | 1 vertex, pipelined | 0x0192 `ibne vi09` |
| LIGHTING_OFF | vi09 = n | 1 store per vertex | 0x019F `ibne vi09` |
| LIGHTING | vi09 = n | 1 vertex (pipelined two ahead) | 0x01C8 `ibne vi09` |
| VC MUL / ADD | vi09 = n | 1 vertex | 0x0226 / 0x0236 `ibne vi09` |
| LIGHTINGM_REAL | vi09 = n; inner vi10 = vi07 = QW43.x = 3 (`mat_pw`) | 1 vertex; inner loop 0x027D-0x027F squares 3 times | 0x0290 `ibne vi09`; inner 0x027F `ibne vi10` |
| PLIGHTING | vi11 = n | 1 vertex | 0x033C `ibne vi11` |
| OUTPUT | vi09 = n | 1 vertex, do-while | 0x0384 `ibne vi09` |
| OUTPUTC | vi11 = n | 1 vertex, do-while | 0x03B2 `ibne vi11` |
| OUTPUTCN | vi11 = n | 1 triangle (vi11 -= 3 at 0x03EE) | 0x03F8 `ibne vi11` |
| OUTPUTCN_STR | vi11 = n | 1 vertex (vi11 -= 1 at 0x042C) | 0x042E `ibne vi11` |
| CLIPSCIS | vi09 = n | 1 triangle (vi09 -= 3 at 0x0458) | 0x0474 `ibne vi09` |
| CLIPSCIS_STR | vi09 = n - 2 | 1 window (vi09 -= 1 at 0x04DA) | 0x04DD `ibne vi09` |
| clipper plane | vi10 = N_in | 1 edge (`bal vi02, __CLIP_INTER`) | 0x052B etc. `ibne vi10` |
| clipper output | vi09 = N_out | 1 record | 0x05CF `ibne vi09` |

### 4.6 Branch table, output and clip (for reference)

| Pair | Instruction | Target | Effect |
|---|---|---|---|
| 0x00BC-0x00C2 | `ilw.x vi01, 38(vi00)`; `iand vi07, 2`; `ibeq vi07, vi00, 0x00DF` | TRANSPERS | skip clip unless scissor |
| 0x00C4-0x00CB | `ilw.w vi01, 1(vi12)`; `iand 7`; `ibeq 4` | 0x00D1 | strip clip |
| 0x00E1-0x00E6 | `ilw.x vi01, 38(vi00)`; `iand vi07 = 4`; `ibeq` | 0x00F6 | not program_option |
| 0x00EC | `ibeq vi10 (4), vi01 (T&7)` | 0x00F2 | strip output |
| 0x03A9 (C) | `ibeq vi01, vi10 (208)` | 0x03AF | skip ADC (window all in) |
| 0x03ED (CN) | `ibeq vi07, vi10` | 0x03F0 | skip ADC (triangle accepted) |
| 0x0425 (CN_STR) | `ibeq vi01, vi10` | 0x042B | accept |
| 0x045C-0x046E (CLIPSCIS) | `ibeq`/`ibne vi01` | 0x0472 | trivial keep (all clear) or reject (one plane all-out) |
| 0x04C1 (CLIPSCIS_STR) | `ibeq vi01, vi00` (vi01 = vi03 & 1) | 0x04D7 | even window: no swap |
| 0x05D5 | `ibeq vi07, vi00` (vi07 = 4 & flags) | 0x05E5 | no cull |
| 0x05E3 | `ibne vi09, vi10` | 0x05E9 | cull: sign of N.z != mirror |

---

## 5. Per-vertex and per-element math (execution order)

Notation: `sum_c` over lights c = 0..3 (lanes x, y, z, w). `clamp255(a) = min(255, a)` (`miniy` with vf14.y). `ftoi0` truncates toward zero and saturates; `ftoi4` is `trunc(16*a)` (12.4). `Q = 1/w` where stated.

### 5.1 REF_SPHERE (0x015A-0x0178): normal-based environment UV (flag 0x100)

Reads the normal stream (vi04) and writes UV.xy (vi05). Leaf routine, `jr vi15` at 0x0178.

```
M_v   = view*model columns: vf15 = QW25, vf16 = QW26, vf17 = QW27  (3x3 used)   // loaded 0x015D-0x015F
for k in 0..n-1:
    N     = lq(vi04 + k)                                         // vf25 (0x0160)
    nv    = M_v.col0*N.x + M_v.col1*N.y + M_v.col2*N.z          // mulax, madday, maddz -> vf26 (0x0164-0x0166)
    L     = 1 / |nv.xyz|                                        // erleng P, vf26 (0x0167); waitp (0x0168)
    nh    = nv.xyz * L                                          // mfp.w vf26, P (0x0169); mulw.xyz (0x016A)
    uv.x  = (nh.x + 1.0) * 0.5                                  // addw[I].xy +vf00.w, I = 0.5 (0x016B), muli.xy (0x016C)
    uv.y  = (nh.y + 1.0) * 0.5
    store UV_k.xy = (uv.x, uv.y); UV_k.z, UV_k.w unchanged     // sqi.xy vf26, (vi07++) (0x016E)
```

The eye (QW24) is not read. The result is the view-space normal mapped to [0,1]^2 (a matcap-style lookup, not a reflection vector). |nv| = 0 gives L = the VU largest finite value (inferred), so nh = 0 and uv = (0.5, 0.5). Runs before VERTEX_BLEND (0x0088 before 0x0092), so on skinned draws the normal used is the unblended model-space normal (O-9).

### 5.2 VERTEX_BLEND (0x0104-0x0158): linear blend skinning (flag 0x040)

Input per vertex: V_k (vi02, model space, w = 1), N_k (vi04, xyz), and W_k = 2 qw at vi03: qw0 = int offsets off_i (i = 0..3, low 16 bits of each word, `ilwr.x/.y/.z/.w vi07..vi10, (vi03)`), qw1 = weights w_i (`lq vf17, 1(vi03)`). Bone i matrix (column-major) is QW[0x3C + off_i + c], c = 0..3 (`lq ..., 60(vi07)` ... `63(vi10)`), off_i = 4 * bone slot (`visualmotion.cpp:125`). Bone block UNPACK at addr 0x3C with 4 qw per bone (`visualmotion.cpp:723-748`).

```
for k in 0..n-1:
    for i in 0..3:
        Pw_i  = w_i * V_k            // vf20 = w0*V, vf21 = w1*V, vf22 = w2*V, vf23 = w3*V (0x011B-0x0121, 0x013F..)
        Nw_i  = w_i * N_k.xyz        // vf25 = w0*N, vf26 = w1*N, vf27 = w2*N, vf28 = w3*N (0x011C-0x0122, 0x013F..)
    // position: homogeneous, weights folded into V
    Pos_k = sum_i ( M_i.col0*Pw_i.x + M_i.col1*Pw_i.y + M_i.col2*Pw_i.z + M_i.col3*Pw_i.w )   // 0x0123-0x0132 -> vf30
    // normal: 3x3 only, weights folded into N
    Nrm_k = sum_i ( M_i.col0.xyz*Nw_i.x + M_i.col1.xyz*Nw_i.y + M_i.col2.xyz*Nw_i.z )
            // i = 0: vf01-03 x vf25 (0x0133-0x0135)
            // i = 1: vf05-07 x vf26 (0x0136-0x0138)
            // i = 2: vf09-11 x vf27 (0x0139-0x013B)
            // i = 3: vf13 x vf28.x (0x013C), vf14 x vf28.y (0x013D),
            //        vf14 x vf28.z (0x013E: maddz vf31, vf14, vf28z)   **uses column 1, should be column 2 (vf15)**
    V_k <- Pos_k   (sqi vf30, (vi02++) at 0x013F)
    N_k <- Nrm_k   (sqi vf31, (vi04++) at 0x0143); Nrm.w = ACC.w (not used)
```

Consequences: weights are not normalised by the VU (the CPU normalises only when the sum is < 1, `visualmotion.cpp:150-170`; a zero-weight vertex gets weight[0] = 1, `:161`). Unused slots keep offset 0 and weight 0. VB reads one vertex past the batch end (look-ahead, unused results, O-7). VB pushes and restores vf01-vf14 and vi02, vi03, vi04, vi11 (0x0105-0x0108, 0x0109-0x0116, 0x0144-0x0155).

**[suspected retail bug, bone 3 normal z-term]** 0x013E uses column 1 of bone 3 (vf14) where column 2 (vf15, loaded at 0x012C `lq vf15, 62(vi10)`) is correct. The bone 0-2 normal chains use the correct column 2 (0x0135 vf03, 0x0138 vf07, 0x013B vf11). Effect: for any vertex with w3 != 0 and N.z != 0, the z term is w3*N.z*col1 instead of w3*N.z*col2. Latent in game data, unverified (O-8).

### 5.3 LIGHTING_OFF (0x0196-0x01A9): constant colour

```
col = min(255, QW20 * QW40)          // object colour * material diffuse (0x0196-0x019C)
vi04 = 800                           // (0x0199)
for i in 0..n-1: qw[800 + i] = col   // sqi (vi08++) (0x019E)
// then VC step if T & 0x100 (section 4.1)
```

Alpha = min(255, object.w * D.w) (lane w of the same product). Writes to 800+i, not in place. Uses no normals: this is why the NO_NORMAL variants (T & 0x200) can use it.

### 5.4 LIGHTING (0x01AB-0x01D7): directional, four lights

```
C_c = QW[15+c];  AMB = QW[19];  D = QW[40]
// prologue (0x01AB-0x01B3): push vf05..vf09 (0x01AC-0x01B0); then
vf05..vf08 = C_c * D (vf05 lane c)                                   // 0x01AF-0x01B2
vf09       = AMB * D                                                 // 0x01B3
for i in 0..n-1:                                                     // pipelined two vertices ahead
    N_i     = qw(vi04 + i).xyz                                       // (lq 0(vi08) 0x01B1, 1 0x01B4, 2 0x01BF, 3 0x01C6)
    s_c     = max(0, L_c . N_i)  for c = 0..3                        // vf21 = vf02*N.x + vf03*N.y + vf04*N.z (0x01B5-0x01B7, 0x01B9-0x01BC); maxx 0x01BB, 0x01C2
    col_i   = min(255, AMB*D + sum_c (C_c*D) * s_c)                  // ACC from vf09 (0x01BD), maddax/madday/maddaz/maddw (0x01BE-0x01C1); miniy 0x01C5
    store col_i at vi04 + i (in place over N_i)                      // sqi vf24, (vi08++) (0x01C9 delay slot)
// epilogue: pop vf09..vf05 (0x01CA-0x01CE)
```

No max(0) on the colour; inputs are non-negative in practice (inferred). Alpha lane w = min(255, AMB.w*D.w + sum_c C_c.w*D.w*s_c), with C_c.w = 0 (`mapinfo.cpp:408`), so alpha = AMB.w*D.w.

### 5.5 Vertex colour step (LIGHTING_VC, MUL, ADD): T & 0x100

Entered by `b __LIGHTING_VC` (0x0207) from each lit routine when T & 0x100 (0x01A1-0x01A5, 0x01CF-0x01D5, 0x029E-0x02A4, 0x034F-0x0355). It pushes vi15 (0x0207-0x0208), tests F & 0x80 (0x0209-0x020E) and calls one of the two, then pops vi15 at VCend (0x0217-0x0218).

```
// MUL (F & 0x80 clear), __LIGHTINGC_MUL 0x021C:
for i in 0..n-1:
    lit_i = qw(vi04 + i);  vc_i = qw(vi06 + i)                         // vi08 = vi04, vi07 = vi06
    col_i = min(255, lit_i * vc_i)                                     // componentwise, all 4 lanes (0x0221-0x0227)
    store col_i at vi04 + i

// ADD (F & 0x80 set), __LIGHTINGC_ADD 0x022A:
for i in 0..n-1:
    lit_i = qw(vi04 + i);  vc_i = qw(vi06 + i)
    t     = 128.0 * vc_i                                               // muli vf21, vf25, I (I = 128 loaded 0x022F) (0x0230)
    col_i.xyz = min(255, lit_i.xyz + t.xyz)                            // add.xyz (0x0231), miniy (0x0233)
    col_i.w   = min(255, 128 * vc_i.w * vc_i.w)                        // mul.w vf21, vf21, vf25 (0x0232) [suspect, O-10]
    store col_i at vi04 + i
```

Scales: the lit routines do not divide by 128; their output is on the 128-scale (128 = 1.0 in modulate). The vertex colour is read as a raw float with 1.0 scale (inferred). MUL multiplies lit by vc with no conversion. ADD first converts vc to the 128-scale (128*vc, 0x022F-0x0230, inferred from the 128.0 immediate).

### 5.6 LIGHTINGM_REAL (0x023A-0x02A7): directional diffuse plus Phong specular

Uses eye E = QW24 and specular colour U = QW41; exponent from QW43.x (= mat_pw = 3).

```
U = QW41; D = QW40; E = QW24; n_exp = QW43.x (int)
// prologue (0x023A-0x024F): push vi02 and vf05..vf13 (0x023C-0x0246)
vf10..vf13 = C_c * U                                  // (0x0240-0x0243)
vf05..vf09 = C_c * D, AMB * D                         // (0x0246-0x024A)
vi07 = n_exp                                          // (0x024F)
for i in 0..n-1:
    P       = qw(vi02 + i) (model space position)     // lqi vf17 (0x0250, 0x0269)
    N       = qw(vi04 + i).xyz
    V       = E - P                                   // sub.xyzw vf18 (0x0254, 0x026D)
    s_c     = max(0, L_c . N)                         // vf21 (0x0255-0x0257), maxx vf22 (0x025E, 0x0277)
    lit_c   = min(1, 1e4 * s_c)                       // minii vf24, vf22, 1e-4 (0x0264, 0x0283); muli *1e4 (0x026C, 0x0291)
                                                      //   [the notes' "1 if L.N > 0" is this clamp, not a step]
    r_c     = 2*(V.N)*(L_c.N) - (L_c.V)               // ACC from vf19 = 2*V*N (0x025B-0x025C); msubw vf28 (0x0265)
    r_c     = max(0, r_c) * (1/|V|)                   // maxx (0x026B, 0x028F); erleng P (0x0258), mfp.w vf25 (0x0270)
    spec_c  = lit_c * r_c ^ 16                        // mul vf28 squared (0x0278), then 3 squarings in the inner loop (0x027D-0x027F):
                                                      //   exponent = 2^(1 + n_exp) = 16 when n_exp = 3 (see O-11)
    col_i   = min(255, AMB*D + sum_c (C_c*D)*s_c + sum_c (C_c*U)*spec_c)   // diffuse ACC 0x0266-0x028C; specular 0x0285-0x0288; miniy vf29 (0x028D)
    store col_i at vi04 + i                           // sqi vf29, (vi08++) (0x0291)
// epilogue: pop vf05..vf09 (0x0293-0x0297), vf10..vf13 (0x0298-0x029B), vi02 (0x029C); VC step
```

Pipelining: vertex i+1's V, s and spec are computed in iteration i and the diffuse for the next vertex is seeded at 0x0284 (stage mapping in O-14).

### 5.7 PLIGHTING (0x02A8-0x0357): directional plus four point lights

Point light k has position P_k (QW45+k, xyz, relative to the model origin) and power p_k (w of QW45+k). Colour Kc_k = QW49+k.

Per-vertex math (closed form; the pipelining and register stage mapping is in O-14):

```
W   = model_world 3x3 columns QW8..10                                    // loaded 0x02D4-0x02D7 (vf10-12)
Pw  = W * P_i                                                              // 0x02D8-0x02DD (vf15)  (no translation)
N'  = W * N_i (xyz)                                                        // 0x02D8-0x02DA (vf25); vf19 = |N'|^2 (0x02E2-0x02E4)
inv_norm = 1 / |N'|                                                        // rsqrt Q, vf19x (0x02E8); mulq.w vf28 (0x02F5)
for k in 0..3:
    D_k    = P_k.xyz - Pw                                                  // sub.xyz vf20-23 (0x02DF-0x02E5)
    d2_k   = |D_k|^2                                                       // mula/madda/madd (0x02F3-0x02F5)
    inv_k  = 1 / |D_k|                                                     // ersqrt P (0x02FA) (lanes 0,2), rsqrt Q (0x02FB, 0x0308, 0x033B) (lanes 1,3)
    dotp_k = D_k . N'                                                      // vf24 (0x02F7-0x02F9), maxx 0x02FD
    cos_k  = max(0, dotp_k) * inv_k * inv_norm                              // vf28 = vf31*vf28.w (0x0321), vf17 = vf24*vf28 (0x0327)
    att_k  = min(1, (p_k * inv_k)^2)                                       // vf16 = p_k^2 (0x02D2); vf29 = vf16*vf31 (0x0322),*vf31 (0x0326); miniw 1.0 (0x032A)
    w_k    = cos_k * att_k                                                 // vf17 *= vf29 (0x032E)
    pt_k   = Kc_k * D                                                      // QW49+k * D (0x02C1-0x02C4) = vf16..19; stored 805+k
dir   = AMB*D + sum_c (C_c*D) * max(0, L_c . N)                           // N = raw normal (vf25 loads 0x02F9, 0x0327)
col_i = min(255, dir + sum_k pt_k * w_k)                                  // ACC chain 0x0331-0x0335; miniy vf17 (0x0339)
store col_i at vi10 + i (vi10 = entry vi04)                              // sqi vf17, (vi10++) (0x033D delay)
```

Point-light power: p_k appears squared (`vf16 = p_k^2`, 0x02D2), so a negative power behaves as its absolute value. `mgPOINT_LIGHT::power` documents "zero or less switches the light off" (`include/mg_drawenv.hpp:86`). Zero gives att = 0 (off); negative does not switch off (**[suspected]**, O-4). Power is written unchecked (`mg_visual.cpp:1319`).

Registers: vi07 = 49 then 45 (0x02BA, 0x02BB): the first write is dead (**[dead write]**).

**Prologue (settled by ruling a).** 0x02FC, 0x02FF and 0x0300 reload vf10, vf11, vf12 = QW8, QW9, QW10 (model_world columns 0-2). The reads at 0x0301 (`mulax ACC, vf10, vf15x`), 0x0302 (`madday ACC, vf11, vf15y`) and 0x0303 (`maddz vf15, vf12, vf15z`) are 5, 3 and 3 pairs after those loads. Lower-instruction VF writes are interlocked, so they see QW8-QW10, not the transposed D rows written at 0x02E6-0x02F1. vf15 = Pw_1 = W * P_1 with the true columns; the vertex-1 issue is not a suspected bug.

### 5.8 TRANSPERS (0x017A-0x0194): model-screen transform and perspective divide

Runs for every batch (both non-clip and clip paths), after the lit routine and any clip. Leaf routine.

```
M = model_screen, columns vf10 = QW4, vf11 = QW5, vf12 = QW6, vf13 = QW7       // (progmain loads them, 0x0015-0x001A)
for k in 0..n-1:
    P_k   = qw(vi02 + k)                       // (x, y, z, w = 1) from the V stream
    C_k   = M * P_k                            // mulax vf10*P.x, madday vf11*P.y, maddaz vf12*P.z, maddw vf13*P.w  (0x017E-0x0181, 0x0182-0x0186)
    Q_k   = 1 / C_k.w                          // div Q, vf00w, vf26w (0x0185): Q valid 7 pairs later (0x018C)
    V_k  <- (C_k.x*Q_k, C_k.y*Q_k, C_k.z*Q_k, Q_k)     // mulq.xyzw vf18 = vf19*Q (0x018C); vf19.w = 1 (0x017C) so w = Q
    UV_k <- (UV_k.x*Q_k, UV_k.y*Q_k, UV_k.z*Q_k)       // mulq.xyz vf21 = vf20*Q (0x018E); store sqi.xyzw vf21 (0x0193) at vi07 = vi05
```

The UV stream is perspective-divided here, before every output routine. Both the normal and the clip path therefore output ST = uv*Q with Q = 1/w (**[corrected]** ruling 3 and earlier notes that said the normal path leaves UV unscaled: `__OUTPUT` loads vf25 from the stream without a multiply, and the scaling was done upstream). The DIV latency (7 pairs) is what makes the loop work: the div at 0x018D writes Q at the next iteration's 0x018C (the loop body including the delay slot 0x0193 is 8 pairs; 0x018D to the next 0x018C is 7 pairs).

Output of TRANSPERS: V_k = (x_s, y_s, z_s, Q) in screen units with the 2048 centre inside M, and UV_k = (S*Q, T*Q, uv.z*Q).

### 5.9 Output routines (after TRANSPERS)

Common per-vertex screen values (read from the V stream and the UV stream as written by TRANSPERS):

```
x_s, y_s, z_s = V_k.xyz                       // screen, 12.4 centre 2048 (inside M)
Q_k           = V_k.w = 1/w
F_k           = offset + scale * Q_k          // maddw.w vf28, vf29, vf16w with ACC.w = offset (0x0372-0x0373, 0x039E-0x039F)
F'_k          = max(min(F_k, near_value), far_value)   // miniy.w vf27, vf28, vf29y (0x0377); maxz.w (0x037D)  [ruling 1]
ST_k          = UV_k                          // S*Q, T*Q, uv.z*Q
RGBAQ_k       = ftoi0(C_k)                    // vi04 colour stream (0x0374/0x037F: ftoi0 of vf20)
XYZF2_k       = ftoi4(x_s, y_s, z_s, F'_k)    // ftoi4 vf17, vf26 (0x0381); sqi vf17 (0x0385)
```

Packet per vertex: ST, RGBAQ, XYZF2 (in that order, 3 qw; section 6). The packet tag is written first (section 6).

**OUTPUT (plain, F & 0x05 == 0, 0x036D-0x0389).** No culling, no ADC, every vertex kicked. Final `xgkick vi13` at 0x0386.

**OUTPUTC (F & 0x01, F & 0x04 == 0, 0x038A-0x03B6).** Window test per vertex (section 7.1), ADC unless the 3-vertex window is all inside, `xgkick vi13` at 0x03B4.

**OUTPUTCN (F & 0x04, list, 0x03B8-0x03FC).** Per triangle, facing and in-tests (section 7.2). 9 qw per triangle. `xgkick vi13` at 0x03FA.

**OUTPUTCN_STR (F & 0x04, strip, 0x03FE-0x0434).** Per vertex with a sliding window and facing (section 7.3). `xgkick vi13` at 0x0430.

The mirror word QW[30].x is read as an integer by CN (0x03CA) and CN_STR (0x040B); it is 0 or 32.

### 5.10 CLIPSCIS (0x0436-0x047B) and CLIPSCIS_STR (0x047D-0x04E6): guard-band clip classification

Runs only when F & 0x02. Model-space V triangles, clip matrix model_clip (QW25-28, 0x043B-0x043E). Tests use clipw flags (section 7.4).

```
// list (CLIPSCIS): per triangle k (vi09 = n; vi09 -= 3)
for each triangle (V_0, V_1, V_2):
    clip_j = model_clip * (V_j, 1)                        // mulax/madday/maddaz/maddw -> vf18, vf19, vf20 (0x0447-0x0457)
    clipw.xyz on each (0x044F, 0x0454, 0x0457): flags CF = 24 bits; v0 in bits 17..12, v1 11..6, v2 5..0
    if (CF & 0x3FFFF) == 0          -> keep, no output here (0x045C -> 0x0472)
    for each plane P in (-y, +y, -x, +x, -z, +z):
        if (CF | mask_P) == 0xFFFFFF -> all 3 out of P: reject (skip, 0x0472)
    otherwise                        -> partial: bal __SCISSOR (0x0470), the clipper writes its own packet
    advance vi02, vi04, vi05 by 3 (0x0472-0x0473, 0x0475)
// mask_P (fcor immediates, 0x045E-0x046D): -y 0xFF7DF7, +y 0xFFBEFB, -x 0xFFDF7D, +x 0xFFEFBE, -z 0xFDF7DF, +z 0xFEFBEF

// strip (CLIPSCIS_STR): windows (V_j, V_j+1, V_j+2), j = 0..n-3, vi09 = n-2; vi03 = window counter (0x0484, 0x04D9)
for each window:
    same clip flags as the list case
    if partial:
        if (vi03 & 1) == 1:  swap V0 and V2 positions (vf18 <-> vf20 via vf15, 0x04C3-0x04C6)
                             and colours and ST in memory (vi04 +0 <-> +2, vi05 +0 <-> +2, 0x04C7-0x04CA)
        bal __SCISSOR (0x04CB or 0x04D7)
        if swapped: swap back (0x04CD-0x04D4)
    advance vi02, vi04, vi05, vi03 by 1
```

mask_P are "all ones except the three bits of one plane" (inferred FCOR semantics: VI01 = ((CF | imm) == 0xFFFFFF), the only reading consistent with these masks, O-2). A triangle kept by the trivial test is not written here: it stays in the V/colour/ST streams and the output stage draws it (after TRANSPERS, with the screen-space guard test). Rejected triangles are also still in the streams and are dropped by the output-stage guard test. Partial triangles are emitted by the clipper and are also still in the streams, where the guard test drops them (inferred equivalence: the clip planes are the guard box, `mg_drawenv.cpp:194-205`).

SCISSOR (0x04E8-0x0519) saves vi01-vi12 and vf15-vf29, then writes the triangle as a 4-record polygon into buffer A (860):

```
vi08 = 860; vi09 = 920
vf21..23 = colour of v0..v2 = qw(vi04 + 0..2);  vf24..26 = ST of v0..v2 = qw(vi05 + 0..2)
qw860 = P0 (vf18), qw861 = C0, qw862 = ST0, qw863 = P1, qw864 = C1, qw865 = ST1,
qw866 = P2, qw867 = C2, qw868 = ST2, qw869 = P0, qw870 = C0, qw871 = ST0     // 0x050E-0x0519
falls into __PLANE_START (0x051A): vi10 = 0; vi11 = 3
```

Position = clip space (x, y, z, w) from CLIPSCIS, colour and ST raw. Vertex 0 is written again as record 3 to close the polygon. SCISSOR does no bound tests itself.

### 5.11 Clipper: six planes, output and cull

The planes run in the fixed order Z-, Z+, X-, X+, Y-, Y+ (fall-through). Each plane is one Sutherland-Hodgman pass over N_in edges, with N_in + 1 records in the input (the closing copy).

Plane constants (`vf15.x = s`, `vi05` cur mask, `vi06` next mask, `vi07` rotation count, `vi08` input buffer, `vi09` output buffer; table from `__ZMINUS` 0x051C through `__YPLUS` 0x058B):

| Plane | Start | s (vf15.x) | vi05 cur mask | vi06 next mask | vi07 rot | In (vi08) | Out (vi09) | Out iff | d (interpolation) |
|---|---|---|---|---|---|---|---|---|---|
| Z- | 0x051C | -1 (`subw.x`, 0x0523) | 2048 (bit 11, cur -z) | 32 (bit 5, next -z) | 2 | 860 | 920 | z < -\|w\| | z + w |
| Z+ | 0x0533 | +1 (0x053A) | 1024 (cur +z) | 16 (next +z) | 2 | 920 | 860 | z > \|w\| | z - w |
| X- | 0x0549 | -1 (0x0550) | 128 (cur -x) | 2 (next -x) | 0 | 860 | 920 | x < -\|w\| | x + w |
| X+ | 0x055F | +1 (0x0566) | 64 (cur +x) | 1 (next +x) | 0 | 920 | 860 | x > \|w\| | x - w |
| Y- | 0x0575 | -1 (0x057C) | 512 (cur -y) | 8 (next -y) | 1 | 860 | 920 | y < -\|w\| | y + w |
| Y+ | 0x058B | +1 (0x0592) | 256 (cur +y) | 4 (next +y) | 1 | 920 | 860 | y > \|w\| | y - w |

```
// per plane pass (e.g. Z-):
vi10 = N_in (= 3 on the first pass, else the previous output count); vi11 = 0 (output count)
preload vf21..23 = record 0 of the input; vi08 += 3
repeat N_in times:
    bal vi02, __CLIP_INTER           // edge cur -> next (cur = previous next, next = next record)
    vi10 -= 1
bal vi02, __SAVE_LAST_LOOP            // closing copy: out[N_out] = out[0] (0x0609-0x060F)
if vi11 == 0: goto __END_ALL          // nothing left: no output (0x0531)
```

**CLIP_INTER (0x0611-0x0640), one edge:**

```
cur  = record just consumed (vf17..19 = copies of vf21..23; 0x0611-0x0613)
next = next record (lqi vf21..23)
clipw.xyz cur -> CF <<= 6 | bits(cur);  clipw.xyz next -> CF <<= 6 | bits(next)    // |w| flags (0x0615, 0x0616)
fcget vi01 (0x061A)                                             // cur bits 11..6, next bits 5..0
cur_out  = (vi01 & cur_mask) != 0                               // iand vi04 (0x061B)
next_out = (vi01 & next_mask) != 0                              // iand vi04 (0x061F)
if cur_out and next_out:  nothing                               // __CO_NEXT_OUT (0x0623)
if cur_out and next_in :  emit I                                // __CO_NEXT_IN (0x0625): 1 record
if cur_in  and next_out:  emit cur, then I                      // __CI_NEXT_OUT (0x0631): 2 records
if cur_in  and next_in :  emit cur                              // __CI_NEXT_IN (0x063C): 1 record
emit = 3 qw per record (pos, colour, uv), vi09 += 1 per qw. Output count vi11 += 1 for (out, in) and (in, in), += 2 for (in, out), += 0 for (out, out)
```

**INTERPOLATE (0x0642-0x0661):** I = cur + t*(next - cur), with d = c -/+ w:

```
dC = cur.c - s*cur.w                     // vf25 = vf17 - s*vf17.w (0x0642, 0x0644)
dN = next.c - s*next.w                   // vf26 = vf21 - s*vf21.w (0x0643, 0x0645)
rotate dC and dN by vi07 lanes (mr32)    // the plane component ends in .x (0x0648-0x064F)
dd  = dN - dC  (xyz); dd.w = 0           // sub.xyz vf27 (0x0650), sub.w (0x0651)
Q   = dC.x / dd.x                        // div (0x0653), waitq (0x0654)
t   = |Q|                                // addq.x, abs.x (0x0655-0x0656)  = dC/(dC-dN) for opposite signs
pos_I = cur.pos + t*(next.pos - cur.pos)         // vf25 (0x0657, 0x065A, 0x065D): all 4 lanes
col_I = cur.col + t*(next.col - cur.col)         // vf26 (0x0658, 0x065B, 0x065E): all 4 lanes
uv_I  = cur.uv  + t*(next.uv  - cur.uv)          // vf27 (0x0659, 0x065C, 0x065F): xyz; uv.w = 0 (0x0651)
```

Classification uses |w| (clipw). Interpolation uses signed w (s*w). They agree only for w > 0 (**[suspected defect for w <= 0]**, O-20).

**Output loop (0x05A1-0x05D0) and cull (0x05D1-0x05E3), then the packets:**

```
vi02 = 860; vi09 = N_out (vi11)
vf26..vf29 = clip_screen columns (QW29..32)     // 0x05A4 (lq 29..32)
vf27 = QW30 (x = mirror word read as flushed 0.0)
// 779 (empty tag):  qw779.x = 0x8000; qw779.yzw = template       // 0x05A9-0x05AD; xgkick 779 at 0x05B1
// 780 tag:           qw780.x = 0x8000 + N_out; qw780.yzw = template  // 0x05B2-0x05B5
vf22 = QW59 (fog)                               // 0x05B6
for r in 0..N_out-1:
    P = qw(vi02 + 0), colour = qw(vi02 + 1), uv = qw(vi02 + 2)     // (0x05B8-0x05BA)
    screen = clip_screen * P   (col0*P.x + col1*P.y + col2*P.z + col3*P.w)   // 0x05BB-0x05BE: vf17
    Q     = 1 / screen.w                                              // div (0x05BF)
    F     = offset + scale * Q                                        // mulax.w ACC = offset (0x05C0), maddq.w (0x05C2)
    screen.xyz *= Q ; screen.w = F                                    // mulq (0x05C1), maddq.w (0x05C2)
    uv.xyz *= Q                                                       // mulq[I].xyz (0x05C3), I = 1.0 loaded here
    colour_int = ftoi0(colour)                                        // (0x05C5)
    F' = max(min(F, near_value), far_value)                           // miniy.w (0x05C6), maxz.w (0x05C7)
    store screen (x/w, y/w, z/w, F') back to qw(vi02)                 // sq vf17, 0(vi02) (0x05C7)
    XYZF2 = ftoi4(screen)                                             // (0x05C8)
    emit ST = uv, RGBAQ = colour_int, XYZF2  to 780 (3 qw)            // (0x05CA-0x05CC)
    vi02 += 3
// cull (only if flags & 0x04):
vi07 = 4 & F                                                          // (0x05D2-0x05D3); skip cull if 0 (0x05D5)
P0 = qw(860), P1 = qw(863), P2 = qw(866)                              // screen after the loop (0x05D7-0x05D9)
e1 = P1.xyz - P0.xyz (vf20), e2 = P2.xyz - P0.xyz (vf21)              // 0x05DA-0x05DB
opmula.xyz ACC, vf21, vf20;  opmsub.xyz vf23, vf20, vf21              // 0x05DC-0x05DD: vf23 = e2 x e1 (see 7.5)
vi09 = (vf23.z < 0) ? 32 : 0                                          // fmand vi09, vi07 (0x05E1), vi07 = 32 (0x05DD)
if vi09 != mirror (QW30.x as integer, 0 or 32): goto __END_ALL          // (0x05E3): culled, 780 not kicked
xgkick 780                                                            // (0x05E7)
__END_ALL: restore vf15-vf29 and vi01-vi12 (0x05E9-0x0607), jr vi15
```

The 779 packet is always kicked first in the clip path, before 780. A culled polygon leaves 779 kicked and 780 not kicked; buffer data is left in place.

---

## 6. Output packets

### 6.1 Batch packets (420 or 600)

| Routine | Layout (qw offsets from vi13) | Tag | xgkick |
|---|---|---|---|
| OUTPUT | +0 tag; then per vertex k at +1+3k: ST, RGBAQ, XYZF2 | x = (EOP 0x8000) \| n; y/z/w = batch tag template (PRIM 0x5B or 0x5C, NREG 3, REGS 2,1,4) (0x0373-0x037C) | 0x0386 |
| OUTPUTC | same as OUTPUT (tag from input tag, count = n \| 0x8000, 0x038C-0x0393) | input tag copy | 0x03B4 |
| OUTPUTCN | +0 tag; then per triangle t at +1+9t: ST0, RGBA0, XYZ0, ST1, RGBA1, XYZ1, ST2, RGBA2, XYZ2 | x = 0x8000 \| n (0x03BD-0x03C1) | 0x03FA |
| OUTPUTCN_STR | +0 tag; then per vertex at +1+3k: ST, RGBAQ, XYZF2 | input tag copy (0x0402-0x0406) | 0x0430 |

Vertices in a strip are one per record. Triangle lists use one record per vertex too; the GS forms a triangle per three kicks (PRIM 0x5B). For CN lists the ADC bit on vertex 2 drops the whole triangle (section 7.2).

Double buffering: vi13 alternates 420 / 600 per batch (0x0066-0x006C, every batch). The first batch of a draw writes 600.

### 6.2 Clip packets (779, 780)

779 = {0x8000, template.y, template.z, template.w}: an empty GIF tag (NLOOP 0, EOP, PRIM 0x5D) kicked before each clipped polygon (inferred: GIF resynchronisation, O-6). 780 = {0x8000 + N_out, template.y, template.z, template.w} followed by N_out records of (ST, RGBAQ, XYZF2). On every clip batch, before TRANSPERS, the dispatch also writes qw 780 = {0x8000, template.y, template.z, template.w} (0x00D5-0x00D9); each clipped polygon overwrites it. PRIM 0x5D is a triangle fan (`MG_PRIM_TRIANGLE_FAN = 5`, `mg_drawprim.hpp:30`) with N_out - 2 triangles from (P0, P_i, P_{i+1}). Max packet: 1 + 3*9 = 28 qw (780-807) for a triangle clipped through all six planes.

### 6.3 Per-vertex PACKED fields

- ST: S, T (floats in x, y) and Q (float in z). Q = uv.z * Q_w, so Q = 1/w only if the mesh's uv.z is 1.0 (O-1).
- RGBAQ: ftoi0 of the colour lanes (R, G, B, A = low 8 bits; truncation).
- XYZF2: X, Y = low 16 bits of ftoi4(x), ftoi4(y) (12.4 fixed, wraps outside 0..4095.9); Z = bits 27..4 of the z word (24-bit value); F = bits 11..4 of the w word; ADC = bit 15 of the w word (set by adding 2048 to F).

The GS draws with PRIM from the tag and PRE = 1 (`mg_visual.cpp:1117`); PRIM chosen by face type (`:1120-1123`).

---

## 7. Culling, clipping and facing

### 7.1 OUTPUTC: window test (F & 0x01 without F & 0x04)

Per vertex k, in_k = (x_k in guard, y_k in guard, near < w_k < far), tested as six `sub.xyw` ops (0x03A0-0x03A1 for the current vertex, MAC sign flags of the op issued four pairs earlier):

```
in_k = bit7 (x) & bit6 (y) & bit4 (w) of the sign flags, both limits   // mask 208 = 0xD0
ADC_k = NOT (in_{k-2} AND in_{k-1} AND in_k)                          // the window ends at k
emit vertex k with F'_k + 2048*ADC_k                                  // addi.w vf26 (0x03AB), skipped when window == 208 (0x03A9)
```

For lists the GS only kicks the third vertex of each triangle for the triangle test, so this is equivalent to a per-triangle drop (`window ending at 3m+2`). Strips use the same window per vertex (7.3 for facing).

Guard values used by the test: x in (G_min.x, G_max.x) = (1, 4095) in non-scissor draws (progmain writes the constants; `progmain.md` 2.3), (guard_min.x, guard_max.x) in scissor draws. The w limits come from vf15.w = 1/far and vf22.w = 1/near (`div` at 0x0391-0x0392, `addq.w` at 0x0398-0x0399), tested against Q = 1/w: 1/far < Q < 1/near.

### 7.2 OUTPUTCN: list facing and in-test (F & 0x04, T & 7 != 4)

Triangle vertices V0 = vf16, V1 = vf17, V2 = vf18 (screen, w = Q).

```
in_tri     = AND over the six sub.xyw sign-flag tests (V0, V1, V2 against G_min and G_max),
             bits 7, 6, 4                                              (0x03DC-0x03E4 via fmand, 0x03E0-0x03E5)
e1 = V1 - V0 ; e2 = V2 - V0    (xyz)                                   (0x03DA sub vf24; 0x03DB sub vf28)
cross = e2 x e1                                                        (opmula vf28, vf24 at 0x03E5; opmsub vf23, vf24, vf28 at 0x03E6)
cross.z = e2.x*e1.y - e2.y*e1.x = (V2-V0).x*(V1-V0).y - (V2-V0).y*(V1-V0).x
vi10 = 208 | mirror                                                     (0x03C7 iaddiu 208; 0x03CA ilw.x QW30; 0x03CC ior)
orient_bit = (cross.z < 0) ? 32 : 0                                    (fmand vi09, vi08 at 0x03EA, vi08 = 32)
vi07 = in_tri_bits | orient_bit                                        (ior 0x03EB)
accept iff vi07 == vi10                                                (ibeq 0x03ED)
ADC on vertex 2 only if not accepted: vf18.w += 2048                   (addi.w 0x03EF)
```

Expanded accept conditions (the same expression for both mirror states):

- Unmirrored (QW30.x = 0): vi10 = 208 has no bit 5, so the window carries no z-bit and the orientation bit must be clear. **Accept iff in_tri AND cross.z >= 0.** The facing test applies to every list draw, not only mirrored ones (**[corrected]**: part 3 said unmirrored draws had no facing test).
- Mirrored (QW30.x = 32): vi10 = 240 requires bit 5 set after the OR. Bit 5 = orient only (zb = 0). **Accept iff in_tri AND cross.z < 0.**

zb = 0 (settled by ruling c). The six window tests are `sub.xyw` ops (0x03DC-0x03E1), and an FMAC op clears the MAC flags of the fields its dest mask does not write, so each sampled word has its Z sign and Z zero flags at 0. The AND chain 0x03E0-0x03E5 therefore clears bit 5 of vi07 on every draw. Bit 5 can be set only by orient (`fmand vi09, vi08` at 0x03EA, reading the opmsub flags of 0x03E6).

Test of the CN facing with explicit numbers in section 10 (vector 4).

### 7.3 OUTPUTCN_STR: strip facing with a parity flip (F & 0x04, T & 7 == 4)

Per vertex k (iteration j within the batch). Window of three: V_{k-2}, V_{k-1}, V_k (vf31, vf30, vf16). Triangle winding parity p_j:

```
p_j = +1 for j = 0, -1 for j = 1, ...            // vf18.x = +1 after the prologue (0x0401 sub, 0x0405 addw.xyzw vf00.w);
                                                 // muli by I = -1 (0x0421) flips it once per iteration; reset each batch
in_k      = bit7 & bit6 & bit4 of the sign flags of two sub.xyw ops for V_k (0x0414-0x0415), both limits (mask vi03 = 208 | mirror)
e1 = V_{k-1} - V_k  (vf23 = vf30 - vf16, 0x0412);  e2 = V_{k-2} - V_k  (vf24 = vf31 - vf16, 0x0413)
cross_k = e1 x e2  (opmula vf23, vf24 (0x0418); opmsub vf19, vf24, vf23 (0x0419)); by ruling d this is e1 x e2 exactly
cross_k.z = e1.x*e2.y - e1.y*e2.x
orient_k  = [cross_k.z * p_j < 0]         // mulx vf19 * vf18.x (0x041D); fmand vi10 = 32 & MAC (0x0421) -> bit 5
vi01      = (in_{k-2} & in_{k-1} & in_k) | orient_k                    // 0x041A-0x041B, ior 0x0422
accept_k  iff vi01 == vi03                                             // 0x0425
ADC_k: vertex k (not the triangle): vf26.w += 2048 when not accepted   // addi.w vf26 (0x0427)
```

Accept conditions:

- Unmirrored (vi03 = 208): **accept iff in_{k-2} AND in_{k-1} AND in_k AND cross_k.z * p_j >= 0.**
- Mirrored (vi03 = 240): **accept iff the window is in AND cross_k.z * p_j < 0.** The window's bit 5 is always 0 (settled by ruling c): vi01 bit 5 comes from vi09 and vi08 (0x041A), and 0x041B ANDs it with vi07, whose bit 5 is 0 because the in-tests are `sub.xyw` ops (0x0414-0x0415). The `sub.xyzw vf24` at 0x0413 holds e2 only; no `fmand` samples its flags.

Strip parity (the core correction): **[corrected]** part 3 (3.2.d, 6.1) said vf18.x alternates between +0 and -0 and that the parity is carried by the sign of a zero product. The listing shows vf18.x = +1.0 after the prologue (the `addw.xyzw vf18, vf18, vf00w` at 0x0405 adds 1.0 to every lane; the earlier `sub` gives 0), and the flip is a multiplication by -1.0 each iteration. The mechanism is a sign flip of a non-zero value, so it does not depend on signed-zero behaviour.

Batch reset: p_j restarts at +1 at the start of every batch (the prologue at 0x0401-0x0405 runs per batch), and CLIPSCIS_STR restarts its own parity at vi03 = 0 (0x0484) per batch. Strip batches without colour hold 57 vertices (odd, 3.3), so the parity of the first triangle of each later batch is set independently of the GS strip's running parity. This is a suspected defect (O-5).

### 7.4 CLIPSCIS / CLIPSCIS_STR and the clipper: clip classification

Clip flags (per vertex, from `clipw`, machine facts): bit 0 = +x (x > +|w|), bit 1 = -x (x < -|w|), bit 2 = +y, bit 3 = -y, bit 4 = +z, bit 5 = -z. Three `clipw` results shift into CF: v0 ends in bits 17..12, v1 in 11..6, v2 in 5..0 (CLIPSCIS 0x044F, 0x0454, 0x0457). Trivial keep: CF & 0x3FFFF = 0. Trivial reject: one plane with all three bits set (CF | mask_P == 0xFFFFFF). Otherwise the triangle goes to the clipper.

The clipper's classification uses |w| (clipw). Its interpolation uses signed w (s*w in INTERPOLATE). For w > 0 these agree. For w <= 0 they do not (O-20).

### 7.5 Clipper cull (F & 0x04)

Keep iff cross.z >= 0 when unmirrored and cross.z < 0 when mirrored (`ibne vi09, vi10` at 0x05E3 compares vi09 = (cross.z < 0 ? 32 : 0) with the mirror word QW30.x), with cross = e2 x e1, e1 = P1 - P0, e2 = P2 - P0 in screen space (the records of buffer A after the output loop, 0x05D7-0x05DD). For unmirrored draws: keep iff cross.z >= 0. This is the same expression and sign as the OUTPUTCN unmirrored facing test (7.2), so the clip path and the non-clip list path agree on the front face. Only the first triangle of the fan is tested; the polygon is assumed convex.

Operator sign convention used for all cross products in this section (settled by ruling d): `opmula.xyz ACC, a, b` followed by `opmsub.xyz fd, b, a` gives fd = a x b exactly (opmula gives ACC = (a.y*b.z, a.z*b.x, a.x*b.y); opmsub gives fd = ACC - (b.y*a.z, b.z*a.x, b.x*a.y)). progmain 0x002E-0x002F uses the same pairing for its own C = W0 x W1 (`progmain.md` 5).

---

## 8. Native replacement notes

This section maps each stage to the native feature it needs. The target is the Kazarov shader set (`Kazarov/port/gfx/shaders/mesh.vert`, `draw.frag`) and the Chronicle plan (`Chronicle/docs/ENHANCED_LIGHTING_PLAN.md`, step 1 materials and fog, step 5 deformed-vertex motion). Kazarov's `mesh.vert` currently has specialisation flags kLit (1), kVertexColor (2), kFog (4), kShadow (8), kClip0/1 (16/32), kScreenUv (64), kWorldUv (128). Its lit path uses `max(dot(normal, -light_direction), 0)` and `normalize` on the normal.

| VU stage (section) | Native piece | Must reproduce exactly | May approximate |
|---|---|---|---|
| LIGHTING_OFF (5.3) | kLit clear: colour = object * diffuse, clamp to 255 | 255 clamp; alpha = object.w * D.w | - |
| LIGHTING (5.4) | kLit with light_count up to 4 | sum over lights of max(0, L.n) * C * D, plus AMB * D, clamp to 255 (in 0..255 units with 128 = 1.0 modulate) | Kazarov normalises the normal (`normalize`); VU does not (raw N). Use the VU behaviour or assert unit normals. **Sign of L:** VU uses +L.n with L = model-space light direction from QW12-14; mesh.vert uses -light_direction. Native must pass the matching convention. |
| VC MUL (5.5) | kVertexColor (exists) | lit * vc, clamp 255 | Kazarov clamps at 1.0 after dividing by kModulate: equivalent to clamp at GS byte 255, which matches the VU. Keep. |
| VC ADD (5.5, F & 0x80) | new specialisation kVertexColorAdd | col.xyz = min(255, lit + 128*vc); col.w = min(255, 128*vc.w^2) | the w quirk (O-10) must be reproduced if the replacement is meant to match retail |
| LIGHTINGM_REAL (5.6) | new kSpecular specialisation: eye (QW24), U (QW41), exponent (QW43.x) | lit mask min(1, 1e4 * s); r = max(0, 2(V.N)(L.N) - L.V) / |V|; spec = r^16 (3 squarings after one); colour = diffuse + sum (C*U) * spec | exponent (see O-11), pipelining |
| PLIGHTING (5.7) | new kPointLights specialisation: 4 point lights, positions relative to the object origin, power in w | D_k = P_k - W*P; att = min(1, (p/|D|)^2); cos = max(0, D.N')/|D|/|N'|; pt colour * D; directional term from raw N | the power sign (O-4) |
| REF_SPHERE (5.1), flag 0x100 | new kMatcapUv: uv = (normalize(view*model * N).xy + 1)/2 | the normal-only mapping, runs before skinning (unblended normal, O-9) | - |
| VERTEX_BLEND (5.2), flag 0x040 | new kSkinned: bone matrix array (QW 0x3C+4i), 4 influences, int offsets; motion vectors from the deformed vertex (plan step 5) | weights used as given (no normalisation), position homogeneous, normal from the 3x3 part, the bone-3 column bug (O-8) if bit-exact is wanted | - |
| Fog (3.1, 5.9) | kFog exists: v_fog = clamp(fog.x + fog.y/clip.w, fog.z, fog.w)/255 | Use F' = max(min(F, near), far) with near = qw.y = values[2] (7th argument) and far = qw.z = values[1] (6th argument). Do not use GLSL clamp(F, far, near): it is undefined when far > near, which is the inert case (editor fog). Fog values are the 0..255 scale with 255 = no fog. | - |
| Clipping (5.10, 5.11, 7.4) | gl_ClipDistance: kClip0/1 give only two planes; the retail guard box needs six (±x, ±y, ±z against w) | Triangles partially outside are clipped, not dropped. The retail clipper runs only with the scissor flag (F & 0x02), so the native can always clip. Vulkan's clip volume (depth 0..1) must be mapped to the retail z planes (±w). | Clipper ordering: retail draws clipped triangles before the batch packet (4.3). |
| Facing / cull (7.2, 7.3, 7.5) | Pipeline cull mode per draw: back-face culled for the unmirrored front, reversed for mirrored draws; strip parity handled by the GS winding rule | The front test is cross.z >= 0 unmirrored and cross.z < 0 mirrored (7.2, 7.3, 7.5; same as the clipper). Strip parity restarts per batch in retail (7.3): a native GS strip continues across batches and will not reproduce that bug. | - |
| ADC-dropped triangles (7.1, 7.2) | Vertices outside the guard box or depth window: clipped by the native clip planes instead of dropped | For lists, a triangle with any vertex outside is dropped by the retail test and clipped by the clipper (partial) or removed (trivial reject). The native clip makes the same visible result. | - |
| Colour scale (5.5, 6.3) | Vertex colours 0..255 with 128 = 1.0 in modulate (GS TFX) | Output RGBAQ = ftoi0(colour) (truncation); the GS modulate uses 128 as 1.0 | Truncation vs float: prefer ftoi0 when bit-exact |
| Depth (3.1 derivation, 5.9) | Reverse-Z: z_s = zr*n*(f - d)/((f - n) d), near -> 1.67e7, far -> 0 in the 24-bit Z field | GREATER test with a reverse-Z clear and matching projection. Not checked in this program (O-12). | - |
| ST / Q (5.8, 6.3) | Perspective-correct: ST = uv/w, Q = 1/w (uv.z must be 1.0 for perspective-correct Q) | ST and Q exactly as TRANSPERS and the clipper produce them | uv.z = 1 is an assumption on the mesh data (O-1) |
| GS modulate, alpha, fog colour (draw.frag) | draw.frag already implements the GS semantics (texture modulate, fog colour) | FGE and the fog colour come from PRMODE and FOGCOL (`mg_visual.cpp:1395-1414`) | - |

Key items the native must reproduce to match retail output: the 0..255 colour clamp (not 1.0), the two-sided fog clamp order, the ADC drop semantics (the native clip instead), the mirror handling of the facing test, the strip winding, the 12.4 coordinates with 2048 centre, and the Q/ST perspective.

---

## 9. Open points

Items marked **[ruling]** are the orchestrator's rulings that the listing or the CPU contradicts or narrows. Items marked **[corrected]** are earlier-note claims the listing or CPU contradicts. The rest are open questions or inferred hazards.

**Corrections and ruling contradictions (checked against the listing and CPU):**

- **C-1 [ruling 2, mirrored CN facing; settled by ruling c].** Mirrored accept is in_tri AND cross.z < 0 (7.2). The window tests are `sub.xyw` ops whose Z flags are cleared, so the window z-bit is 0 and the ruling's condition holds. Unmirrored and mirrored accept use the same cross.z test with opposite sign.
- **C-2 [ruling 2, unmirrored CN].** Part 3 (3.2.c) said unmirrored lists have no facing test. Listing: vi10 = 208 has no bit 5, and vi07 gets bit 5 from cross.z (0x03EA-0x03EB), so the unmirrored accept requires cross.z >= 0. The facing test applies to every CN list draw.
- **C-3 [corrected, part 3 3.2.d and 6.1].** The strip parity is a sign flip of +1.0 / -1.0 (vf18.x), not of signed zeros. The prologue sets vf18 = 1.0 (0x0401 sub, 0x0405 addw adds vf00.w). The "+0/-0" claim and open point 5 of part 3 are withdrawn.
- **C-4 [corrected, part 4 6.2 and part 3 6.4].** The fog clamp is correct for the CPU convention (see 3.1). The "operand swap" suspicion is withdrawn. Constant fog happens only when the 6th argument exceeds the 7th (the editor call, `editexception.cpp:497`), and then the result is F = 255 (no fog).
- **C-5 [corrected, part 4 6.3 and open point 5].** The normal output path does not leave ST unscaled. TRANSPERS multiplies UV by Q at 0x018E before every output routine, so ST = uv/w on both paths. Both paths are perspective-correct when uv.z = 1 (O-1).
- **C-6 [corrected, part 2 7.1, 9.6 and table 2.1 rows 6-7].** The variant 7 colour pointer is correct. SetData7 writes count into dw0 (`mg_visual.cpp:1040`), so vi04 = vi05 = vi06 = V + n = colour start. Part 2's header (0,0,0,T) and "vi06 = vertex" were wrong. Variant 6 likewise (`:1009`).
- **C-7 [corrected, part 1 10.3 and open point 3].** The output stage reads colour through vi04 only. Raw colour (vi06) is read by the VC routines before TRANSPERS. TRANSPERS overwriting the raw colour region (variants 3 and 7) is harmless for that reason.
- **C-8 [corrected, part 2 4.5].** The lit-mask term is min(1, 1e4 * max(0, L.N)), not a step at zero.
- **C-9 [corrected, part 4 5.4].** `opmsub` produces the cross product itself, not twice it (the subtracted half cancels the other half). Sign is unaffected.
- **C-10 [corrected, part 1 section 3 table].** The row "F = 0x002 alone -> OUTPUT" is unreachable from the CPU (it always sets 0x001 with 0x002, `mg_visual.cpp:1337-1343`).
- **C-11 [ruling 4, confirmed].** No read of QW[30] in 0x0064-0x0195. The reads are 0x03CA, 0x040B (CN, CN_STR), 0x05A5 (clipper load, float), 0x05DC (cull).
- **C-12 [ruling 5, confirmed].** VB bone-3 normal z-term (0x013E), skinned header dw1 = 0 for V2 (`visualmotion.cpp:347`) and dw0 = 0 for V6 (`:475`), ADD alpha (0x0232), M_REAL exponent from QW43.x (0x024F), PLIGHTING prologue (0x0301-0x0303, settled by ruling a), point-light power sign (`mg_drawenv.hpp:86`), clipper |w| vs signed w (0x0615 vs 0x0642), and dead code (`__LIGHTINGC` 0x01D8 and `__ADD_PLIGHT` 0x0359 have no bal, b, or branch target in the listing).
- **C-13 [ruling 1, confirmed and derived in 3.1].** The fog layout and clamp order are as the ruling states.
- **C-14 [ruling 3, confirmed].** TRANSPERS scales ST by Q for both paths (5.8).

**Settled by the rulings (recorded, no longer open):**

- MAC z-flag retention (formerly open point 1, C-1): an FMAC op clears the flags of fields outside its dest mask (ruling c). The window z-bit in 7.2 and 7.3 is 0; mirrored accept is cross.z < 0. The cull (7.5) and the strip (7.3) use the same sign rule.
- PLIGHTING prologue reload of vf10-vf12 (formerly open point 5, 5.7): lq is interlocked (ruling a); the reads at 0x0301-0x0303 see QW8-QW10. No defect.
- Clipper input loads (formerly open point 5, 5.11): the lq at 0x05A4-0x05BA are interlocked before their reads at 0x05BB-0x05CC (ruling a).
- OPMULA/OPMSUB sign (formerly open point 13, 5.11, 7.2, 7.3, 7.5): opmula ACC,a,b followed by opmsub d,b,a gives d = a x b exactly (ruling d). Every cross product in this spec uses that form.
- Integer results (ruling b): vi07 at 0x03E0-0x03EB, vi01 at 0x041A-0x0425 and vi09/vi10 at 0x05E1-0x05E3 read program-order values. No alternative reading is kept.
- Strip parity signed zero (formerly open point 12): see C-3.

**New findings (inferred or suspected, verify on an emulator trace):**

- **O-1 uv.z = 1.** ST's Q is uv.z * (1/w). Correct perspective only if uv.z = 1.0 in the mesh data (`mg_visual.cpp:397` copies uv verbatim; the values come from MDT, `mg_dataset.cpp:1110-1111`, not traced).
- **O-2 FCOR semantics.** The trivial-reject masks (0x045E-0x046D, 0x04AC-0x04BB) assume VI01 = ((CF | imm) == 0xFFFFFF).
- **O-3 DIV latency.** 7 pairs (inferred). TRANSPERS (0x0185->0x018C, 0x018D->next 0x018C), the output reciprocals (0x0391/0x0392 -> 0x0398/0x0399, 0x03C2/0x03C3 -> 0x03C9/0x03CA, 0x0404/0x0405 -> 0x040B/0x040C), and the clipper (0x0653 with waitq).
- **O-4 point-light power.** Negative power acts as its absolute value (vf16 = p^2, 0x02D2), but `mgPOINT_LIGHT::power` says "zero or less switches the light off" (`mg_drawenv.hpp:86`). CPU writes it unchecked (`mg_visual.cpp:1319`). Zero is off in both.
- **O-5 strip parity restarts per batch** (7.3, C-3): vf18 is initialised in each batch prologue (0x0401/0x0405), and CLIPSCIS_STR restarts vi03 at 0x0484. With odd batches (57) the parity of later batches of one strip can disagree with the GS winding. Trace a strip spanning two batches.
- **O-6 779 packet purpose.** An empty EOP tag (NLOOP 0, PRIM 0x5D) is kicked before each clip packet (0x05B1). Inferred: GIF resynchronisation or PRIM state. Not established.
- **O-7 look-ahead reads.** VB reads one vertex past the batch (W_n, N_n, V_n); REF and TRANSPERS read two past (`lq 2(vi08)`); VB's offset `60 + off` for a garbage offset is unbounded. Results unused (inferred no fault).
- **O-8 VB bone-3 normal z-term** (5.2): col1 used instead of col2 at 0x013E. Latent if no vertex has four bone entries (`visualmotion.cpp:131-140`). Not checked against game data.
- **O-9 REF_SPHERE before VB** (0x0088, 0x0092). On skinned draws with program_mode & 2, the env UV comes from the unblended normal. Intended or a bug: not decidable here.
- **O-10 ADD alpha** (5.5): col.w = 128*vc.w^2 (0x0232, `mul.w vf21, vf21, vf25`), ignoring lit.w. Suspect: intended 128*vc.w, or lit.w * vc.w as in MUL.
- **O-11 M_REAL exponent** (5.6): mat_pw = 3 gives r^16 by four squarings (0x0278 and three in the loop). If mat_pw is meant as a power of two (2^3 = 8), the code is off by a factor of two in the exponent. Check against an emulator trace or the intended look.
- **O-12 Z test direction.** Reverse-Z depth needs GREATER/GEQUAL in the GS (draw env outside this range). Not checked.
- **O-13 Batch count for n = 0.** OUTPUT (counter vi09 from 0x0372) and OUTPUTC (counter vi11, decremented at 0x03B0) are do-while loops with no guard: a zero count runs 65536 times. The CPU never sends n = 0 (`mg_visual.cpp:1144`). The scissor path has a guard (0x00D3); the plain path does not.
- **O-14 PLIGHTING and M_REAL stage mapping.** The loops pipeline one vertex ahead. Rulings (a) and (b) make every read follow program order, so the mapping is fixed by the listing alone and needs no hazard assumption; it has not yet been traced. Still open: which vertex's dotp, D and 1/|N'| (vf24, vf28.w, vf31) feed which output vertex. Dead write vi07 at 0x02BA (5.7).
- **O-15 M_REAL uses QW41/43 only via mat_vif.** The material path with flags & 1 == 0 (`mg_visual.cpp:218-222`, `mat_vif_dif` NUM 1) writes only QW40. QW41 (U) and QW43 (mat_pw) keep old values, so M_REAL can read a stale U and a stale exponent. If mat_pw is 0 the inner loop runs 65536 times (inferred hazard).
- **O-16 Clip packet 780 overlaps LIGHTING_OFF colours.** The clip packet occupies 780-807 and LIGHTING_OFF writes colour 800+i (5.3). A clipped polygon with N_out >= 7 writes 800.. during CLIPSCIS, which runs before OUTPUT reads the colours. In a LIGHTING_OFF batch the first colours can be overwritten (inferred hazard).
- **O-17 Buffer 600 and 779.** The batch output of 57 vertices ends at 771 (600 + 172), below 779. Colour variants (42 vertices) are smaller. Confirmed for MDT batches; skinned batches (27 vertices for 16 bones) are smaller.
- **O-18 Non-scissor clipper inputs.** The clipper is reached only through CLIPSCIS, which needs F & 0x02, so model_clip (QW25-28) is always the scissor matrix. If the view block (program_mode & 2, 0x19-0x1C) is also set, the clip matrix is the view matrix (C-12, `progmain.md` open point 3, `mg_visual.cpp:1300` vs `:1330`). Not resolved here.
- **O-19 Output count bound.** Plane buffers hold 20 records (960 bytes). No check. Convex input gives at most 9 records plus the closing copy. A non-convex polygon from a w <= 0 vertex can exceed 20 and write past 979 (0x3D3).
- **O-20 Clip-side ST and Q with w <= 0.** Interpolation uses signed w (5.11). Vertices with w <= 0 reach the clipper only if the front end passes them; not established (`mg_frame.cpp:1440-1490`, `mg_visual.cpp`).
- **O-21 Strip window continuity across batches.** CN_STR and CLIPSCIS_STR assume vi08, vi09 and vf30, vf31 persist across batches. The CPU re-reads two vertices per strip batch (`mg_visual.cpp:1174-1177`), so the first two iterations of each batch emit re-read vertices (degenerate triangles on the GS side). Not verified end to end.
- **O-22 Scratch 800-856 vs 860 buffers.** LIGHTING_OFF writes 800 + i, up to 856 for 57 vertices, which stays below 860. PLIGHTING's 800-808 is used before the clipper. Checked for overlap: none with 860-979.
- **O-23 Flags 0x80 (Vc) and the ADD path** use the same bit as unk_84 == 1. Meaning of the 'Vc' name flag is not settled here (`mg_dataset.cpp:394`).
- **O-24 SetData2 dw2 = n** (no UV stream): harmless for the VU, which never reads a UV count, but TRANSPERS writes n qw beyond the batch end (UV start = V + 2n). Harmful only if the next input buffer is live (`MDT TOPS 0x3C`, OFFSET 0xB4: 57 vertices reach qw 233, past 180).
- **O-25 Skinned V2 UV pointer** aliases the N stream (dw1 = 0, `visualmotion.cpp:347`). TRANSPERS then overwrites the blended normals with UV junk at 0x0193 (vi07 = N start). Output reads colour from vi04, so the damage is in the normal stream only. Harmful only if read after TRANSPERS (not the case), so this is latent.
- **O-26 Skinned V6** (`visualmotion.cpp:475`): dw0 = 0 makes the N and W pointers equal V. VB writes blended normals over the positions (0x0143 after 0x013F). The whole V6 path is broken if it occurs.
- **O-27 Bone block ordering.** The bone block UNPACK (0x3C+) is emitted after MSCAL 0 inside the render-info packet (`visualmotion.cpp:684-749`, `mg_visual.cpp:1427`). Whether the VIF waits for the MSCAL 0 program to halt before the UNPACK writes VU memory is not established by the repo (cpu_feed open question 12).

Items from the notes that are resolved and removed: part 1 open point 4 (0x19 overlap, see O-18), part 1 open point 6 (780 is written and kicked only in the clipper, 0x05E7, so it is never kicked on a non-clip batch), part 3 open point 3 (FCOR, see O-2), part 3 open point 5 (signed zero, removed by C-3).

---

## 10. Test vectors

Each vector gives inputs, then the arithmetic from the pseudo-code. The values are the ones the VU would hold in the named registers at the end of the routine.

### 10.1 Vector 1: LIGHTING_OFF (unlit colour, flag 0x020)

Inputs: flags F = 0x020, header T = 0x000 (no colour, not NO_NORMAL). QW20 = (128, 64, 32, 128) (object colour), QW40 = (0.5, 0.5, 0.5, 1.0) (material diffuse).

```
col = min(255, QW20 * QW40) = min(255, (128*0.5, 64*0.5, 32*0.5, 128*1.0))
    = min(255, (64, 32, 16, 128)) = (64, 32, 16, 128)
qw[800] = (64, 32, 16, 128); vi04 = 800 (output reads colour from 800)
output RGBAQ = ftoi0(64, 32, 16, 128) = (64, 32, 16, 128)
```

### 10.2 Vector 2: LIGHTING with one directional light (flag 0, header 0)

Inputs: model_world identity (QW8 = (1,0,0,0), QW9 = (0,1,0,0), QW10 = (0,0,1,0), QW11 = (0,0,0,1)). Light 0 direction (world = model): QW12.x = 0, QW13.x = 0, QW14.x = 1, so L_0 = (0, 0, 1). Lights 1-3 zero: QW12-14 other components = 0, so L_1..3 = 0 and s_1..3 = 0. C_0 = QW15 = (128, 64, 0, 0); C_1..3 = QW16-18 = 0. AMB = QW19 = (32, 32, 32, 128). D = QW40 = (1, 1, 1, 1). Vertex: N = (0, 0, 1, 0).

```
s_0 = max(0, L_0 . N) = max(0, 1) = 1;   s_1..3 = 0
AMB*D = (32, 32, 32, 128)
(C_0*D) * s_0 = (128, 64, 0, 0)
col = min(255, (32+128, 32+64, 32+0, 128+0)) = (160, 96, 32, 128)
```

### 10.3 Vector 3: fog at near and far, and mid-depth

CPU call: `mgSetFogParam(near = 10, far = 1000, r, g, b, far_value = 0, near_value = 255)`. The arguments in order are (near_dist, far_dist, ..., far_value, near_value), so the 6th argument (far_value) is 0 and the 7th (near_value) is 255.

```
range  = dmax - dmin = 0 - 255 = -255            (dmax = 6th = 0, dmin = 7th = 255)
offset = (dmax + dmin + range*(far+near)/(far-near)) / 2
       = (0 + 255 + (-255)*1010/990) / 2 = (255 - 260.1515) / 2 = -2.5758
scale  = -far*near*range/(far-near) = -1000*10*(-255)/990 = 2575.758
qw[0x3B] = (offset, near_value, far_value, scale) = (-2.5758, 255, 0, 2575.758)

F(w) = offset + scale/w;  F' = max(min(F, 255), 0) = F (in [0,255])
w = 10   (Q = 0.1):   F = -2.5758 + 257.5758 = 255.000  -> F' = 255   (= near, no fog)
w = 1000 (Q = 0.001): F = -2.5758 + 2.5758  = 0.000    -> F' = 0     (= far, full fog)
w = 100  (Q = 0.01):  F = -2.5758 + 25.7576 = 23.182   -> F' = 23.18
XYZF2 word of the mid-depth vertex: ftoi4(F') = trunc(16*23.182) = 370 (0x172);
  F field (bits 11..4) = 370 >> 4 = 23; ADC bit 15 = 0.
Editor fog (6th = 255, 7th = 0): min(F, 0) = 0 for F >= 0 then max(0, 255) = 255 everywhere: F' = 255 (no fog).
```

### 10.4 Vector 4: OUTPUTCN list facing, accept and reject (flags 0x004, list)

Inputs: non-scissor. QW21 = (4095, 4095, z, 1000) (G_max, w = far), QW22 = (1, 1, z, 10) (G_min, w = near). All three vertices have Q = 0.01 (w = 100) and z = 0. Screen positions after TRANSPERS and the fog step: V0 = (2100, 2100), V1 = (2200, 2100), V2 = (2100, 2200).

In-tests. Each vertex tested against G_min and G_max in x, y, w:
```
V0.x: 1 - 2100 < 0 (bit 7 set); 2100 - 4095 < 0 (bit 7 set)
V0.y: same, bit 6 set
w:    1/far - Q = 0.001 - 0.01 < 0 (bit 4); Q - 1/near = 0.01 - 0.1 < 0 (bit 4)
=> in bits 7, 6, 4 for every vertex: in_tri = 208 (0xD0)
```

Facing. e1 = V1 - V0 = (100, 0, 0), e2 = V2 - V0 = (0, 100, 0). cross = e2 x e1, z component:
```
cross.z = e2.x*e1.y - e2.y*e1.x = 0*0 - 100*100 = -10000 < 0  -> orient bit 5 = 1
```

Unmirrored (QW30.x = 0): vi10 = 208. vi07 = 208 | 32 = 240. 240 != 208: **reject**. ADC: vf18.w += 2048 on V2 (triangle dropped by the GS).

Mirrored (QW30.x = 32): vi10 = 240. vi07 = 208 | 32 = 240 == 240: **accept**, no ADC. The window z-bit is 0 (ruling c), so the accept comes from cross.z < 0 alone.

Reversed winding (V0, V2, V1): e1 and e2 swap, cross.z = +10000 >= 0: unmirrored **accept**, mirrored **reject**.

### 10.5 Vector 5: clipper (six planes), the example from the part 4 notes, recomputed

Input clip-space triangle (w > 0, so |w| = w):

| Vertex | (x, y, z, w) | colour (RGBA) | uv (s, t, uv.z, 0) |
|---|---|---|---|
| R0 | (0, 0, 1, 2) | (255, 0, 0, 255) | (0, 0, 1, 0) |
| R1 | (1, 0, 0, 2) | (0, 255, 0, 255) | (1, 0, 1, 0) |
| R2 | (0, 1, -3, 1) | (0, 0, 255, 255) | (0, 1, 1, 0) |

Z- pass (s = -1, d = z + w; the classification is z < -|w|):

- Flags: R0 z = 1 >= -2 (in); R1 z = 0 >= -2 (in); R2 z = -3 < -1 (out).
- Edge R0 -> R1 (both in): emit R0. Output so far [R0].
- Edge R1 -> R2 (cur in, next out): emit R1, then I12. dC = d(R1) = 0 + 2 = 2; dN = d(R2) = -3 + 1 = -2; Q = dC/(dN - dC) = 2/(-4) = -0.5; t = |Q| = 0.5.
  - pos I12 = (1,0,0,2) + 0.5*((0,1,-3,1) - (1,0,0,2)) = (0.5, 0.5, -1.5, 1.5). Check d = -1.5 + 1.5 = 0.
  - col I12 = (0,255,0,255) + 0.5*((0,0,255,255) - (0,255,0,255)) = (0, 127.5, 127.5, 255).
  - uv I12 = (1,0,1) + 0.5*((0,1,1) - (1,0,1)) = (0.5, 0.5, 1).
- Edge R2 -> R0 (cur out, next in): emit I23. dC = d(R2) = -3 + 1 = -2; dN = d(R0) = 1 + 2 = 3; Q = -2/5 = -0.4; t = 0.4.
  - pos I23 = (0,1,-3,1) + 0.4*((0,0,1,2) - (0,1,-3,1)) = (0, 0.6, -1.4, 1.4). Check d = 0.
  - col I23 = (0,0,255,255) + 0.4*((255,0,0,255) - (0,0,255,255)) = (102, 0, 153, 255).
  - uv I23 = (0,1,1) + 0.4*((0,0,1) - (0,1,1)) = (0, 0.6, 1).
- Output N_out = 4: [R0, R1, I12, I23], then the closing copy R0.

Z+, X-, X+, Y-, Y+ passes: every vertex of [R0, R1, I12, I23] is inside (z <= |w|, |x| <= |w|, |y| <= |w| for each vertex: R0 (y = 0), R1 (x = 1 <= 2), I12 (|x|, |y|, |z| = 0.5, 0.5, 1.5 <= 1.5), I23 (|z| = 1.4 <= 1.4, y = 0.6 <= 1.4)). No crossings; N stays 4. Buffers alternate, and Y+ writes to 860.

Screen transform (illustrative matrix from part 4: clip_screen col0 = (256, 0, 0, 0), col1 = (0, 256, 0, 0), col2 = (0, 0, -8.35e6, 0), col3 = (2048, 2048, 8.35e6, 1)). Then x_s = 256x + 2048w; y_s = 256y + 2048w; z_s = -8.35e6 z + 8.35e6 w; w_s = w. Divide by w_s.

| Record | pos | Q = 1/w | screen x/w, y/w | z/w | ST = uv*Q | RGBAQ = ftoi0(col) | XYZF2 X, Y, Z |
|---|---|---|---|---|---|---|---|
| P0 = R0 | (0,0,1,2) | 0.5 | 2048, 2048 | 4.175e6 | (0, 0, 0.5) | (255, 0, 0, 255) | 32768, 32768, 4175000 |
| P1 = R1 | (1,0,0,2) | 0.5 | 2176, 2048 | 8.35e6 | (0.5, 0, 0.5) | (0, 255, 0, 255) | 34816, 32768, 8350000 |
| P2 = I12 | (0.5,0.5,-1.5,1.5) | 0.6667 | 2133.33, 2133.33 | 1.67e7 | (0.3333, 0.3333, 0.6667) | (0, 127, 127, 255) | 34133, 34133, 16700000 |
| P3 = I23 | (0,0.6,-1.4,1.4) | 0.7143 | 2048, 2157.71 | 1.67e7 | (0, 0.4286, 0.7143) | (102, 0, 153, 255) | 32768, 34523, 16700000 |

Check P2: x_s = 256*0.5 + 2048*1.5 = 128 + 3072 = 3200; /1.5 = 2133.33. z_s for P2: -8.35e6*(-1.5) + 8.35e6*1.5 = 2.505e7; /1.5 = 1.67e7.

F for each record with the editor fog (6th 255, 7th 0): F' = 255 for all four. (With the normal fog of 10.3, F would vary with 1/w.)

Packet at 780: tag 0x8004 (NLOOP 4, EOP), PRIM 0x5D fan, then P0..P3 (3 qw each). Fan triangles: (P0, P1, P2), (P0, P2, P3).

Cull (flags & 0x04 set): screen P0 = (2048, 2048), P1 = (2176, 2048), P2 = (2133.33, 2133.33).
```
e1 = P1 - P0 = (128, 0);  e2 = P2 - P0 = (85.33, 85.33)
cross.z = e2.x*e1.y - e2.y*e1.x = 85.33*0 - 85.33*128 = -10922.7 < 0  -> vi09 = 32
mirror 0:  32 != 0  -> culled (780 not kicked; 779 already kicked)
mirror 32: 32 == 32 -> kept, 780 kicked
```

### 10.6 Vector 6: VERTEX_BLEND, two bones (flag 0x040)

Inputs: P = (0, 0, 0, 1), N = (0, 0, 1, 0). Bone slots: slot 0 at offset 0 (QW60-63), slot 1 at offset 4 (QW64-67). Weights w0 = 0.5, w1 = 0.5 (slots 2 and 3 have weight 0, offset 0). M0 = identity (QW60 = (1,0,0,0), QW61 = (0,1,0,0), QW62 = (0,0,1,0), QW63 = (0,0,0,1)). M1 = translation (1, 0, 0): QW64 = (1,0,0,0), QW65 = (0,1,0,0), QW66 = (0,0,1,0), QW67 = (1,0,0,1).

Position (homogeneous, weights folded into the vertex):
```
Pw0 = 0.5*P = (0, 0, 0, 0.5);   Pw1 = 0.5*P = (0, 0, 0, 0.5)
ACC = M0*Pw0 = col3(M0)*0.5 = (0, 0, 0, 0.5)
ACC += M1*Pw1 = col3(M1)*0.5 = (0.5, 0, 0, 0.5)
Pos = (0.5, 0, 0, 1.0)     // = 0.5*P + 0.5*(P + (1,0,0)); the VU writes this to V_k
```

Normal (3x3 part, weights folded into N):
```
Nw0 = 0.5*N = (0,0,0.5);  Nw1 = 0.5*N = (0,0,0.5)
Nrm = M0.3x3*Nw0 + M1.3x3*Nw1 = (0,0,0.5) + (0,0,0.5) = (0, 0, 1)   // N_k <- (0, 0, 1, ACC.w)
```

Bone-3 sub-case (bug, 5.2): add weight 1 on slot 3 (offset 12, M3 = identity), with w0 = w1 = 0 and N = (0, 0, 1). Correct normal = M3.3x3 * N = (0, 0, 1). VU: `maddz vf31, vf14, vf28z` uses col1 of M3 = (0, 1, 0), so the normal is (0, 1, 0). Expected 0 in z, observed 1 in y. The shared `GfxGpuMeshDc2.SkinnedFourthInfluenceNormal` regression covers this sub-case with a y-light output of 100 and a z-light output of 0.

---

## Summary

1. Batch = GIF tag (NLOOP = n | 0x8000), header {n, N count, colour count, type}, then V, N, UV, C and W streams; W only skinned (2 qw per vertex). Pointers vi02 = TOPS+2, vi04 = V+n, vi05 = N+dw1, vi06 = UV+dw2, vi03 = colour + n (skinned).
2. Dispatch: 0x100 -> REF_SPHERE; 0x040 -> VERTEX_BLEND; header 0x200 or flag 0x020 -> LIGHTING_OFF; else flag 0x08 (with 0x10 clear) -> LIGHTINGM_REAL; flag 0x10 -> PLIGHTING; else LIGHTING. Header 0x100 adds the VC step (MUL, or ADD when 0x080).
3. Clip (0x002): CLIPSCIS or CLIPSCIS_STR classify triangles (trivial keep/reject) and send partial ones to the six-plane clipper, which emits its own 779/780 packets.
4. TRANSPERS always: screen position, Q = 1/w, ST = uv*Q on both paths.
5. Output: 0x004 selects the N (facing) routines, 0x001 the C (window) routine, else OUTPUT. Strip (T&7 = 4) selects the _STR variants.
6. Fog F = offset + scale/w clamped as max(min(F, near), far), near = 7th argument, far = 6th: the normal case is the identity on [far, near]; only 6th > 7th collapses (editor call, F = 255).
7. Facing: unmirrored lists need cross.z >= 0; mirrored lists need cross.z < 0 (C-1, ruling c). Strips test cross_k.z * p_j the same way (>= 0 unmirrored, < 0 mirrored); the parity flips per iteration with a sign flip of 1.0 (not zero) and restarts per batch (O-5).
8. Clipper: six planes Z-, Z+, X-, X+, Y-, Y+ with |w| classification and signed-w interpolation; cull keeps cross.z >= 0 unmirrored and cross.z < 0 mirrored (same as the list facing test).
9. VERTEX_BLEND: four bones per vertex, integer offsets, matrix at QW[0x3C + 4*slot]; position homogeneous; normal 3x3; bone-3 normal z-term uses col1 (0x013E, suspected bug).
10. REF_SPHERE: UV = ((view*model normal normalised).xy + 1)/2; no eye, no reflection; runs before VB.
11. LIGHTING: four lights, max(0, L.N) times C*D, plus AMB*D, clamp 255; LIGHTING_OFF: object colour times D; LIGHTINGM_REAL: diffuse plus Phong specular, exponent 16; PLIGHTING: four point lights with att = min(1, (p/|D|)^2).
12. Output packet: tag + per vertex (ST, RGBAQ, XYZF2) = 1 + 3n qw; OUTPUTCN uses 9 qw per triangle; xgkick per routine; double buffer 420/600.
13. Suspected retail defects: bone-3 normal z (0x013E), skinned V6 (dw0 = 0), skinned V2 (dw1 = 0 aliases N), ADD alpha (0x0232), M_REAL exponent, point-light power sign, strip parity reset per batch (O-5), clip packet overlap with LIGHTING_OFF colours (O-16).
14. Corrected earlier notes: strip parity is a +1/-1 flip (C-3); SetData7 colour pointer correct (C-6); normal output path ST pre-divided (C-5); fog clamp correct (C-4); CN unmirrored facing test applies (C-2).
15. Open: uv.z = 1 (O-1), FCOR (O-2), DIV latency (O-3), 779 purpose (O-6), w <= 0 in the clipper (O-20), stage mapping (O-14), editor fog data (C-4). Settled by rulings: MAC z-flag (C-1), lq interlock, OPMULA sign.
