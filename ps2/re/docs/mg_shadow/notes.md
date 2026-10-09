# mg_shadow notes

Header: `ps2/include/mg_shadow.hpp`. One class (`mgCShadowMDT`), no enums, no structs of its own,
no plain-named globals (only compiler-generated `prog_vif_208`, `at_243`, `at_353`, vtable).
The header includes `mg_visual.hpp` for the base class `mgCVisualMDT`; that header did not exist
when this was written, so `mg_shadow.hpp` only compiles once it does. Verified separately with a
stub base (vptr at 0x1C, size 0x50): the declarations compile.

## mgCShadowMDT (size 0x50, base mgCVisualMDT, no own fields)
- Size: `CreateFrameVisual` (mg_dataset), case `param_7 == 2`: `operator new(0x50, Alloc(mem, 7))`,
  then stores `__vt__9mgCVisual` (+ virtual `Initialize`, slot 0x30), `__vt__12mgCVisualMDT`
  (+ `Initialize`), then `__vt__12mgCShadowMDT` with no further call. So the constructor is
  inline, empty, and never emitted; the implicit one is correct. `mgCVisualMDT` is also allocated
  at 0x50, so the subclass adds nothing.
- vptr at 0x1C (inherited from `mgCVisual`). No member function is non-virtual.
- `mgCShadowFixMDT` (owned by mg_dataset, case `param_7 == 3`, also 0x50) derives from
  `mgCShadowMDT`; its vtable (0x37B130) is entry-for-entry identical to `mgCShadowMDT`'s.

### vtable `__vt__12mgCShadowMDT` (0x37B290, 0x50 bytes incl. 2 leading + 2 trailing zero words)
| Slot off | Entry | Owner |
|---|---|---|
| 0x08 | Iam | mgCVisualMDT |
| 0x0C | GetMaterialNum | mgCVisualMDT |
| 0x10 | GetpMaterial | mgCVisualMDT |
| 0x14 | GetMaterial(int) | mgCVisualMDT |
| 0x18 | Copy(mgCMemory*) | mgCVisual |
| 0x1C | CreateBBox(float*, float*, float(*)[4]) | mgCVisualMDT |
| 0x20 | **CreateRenderInfoPacket** | mgCShadowMDT |
| 0x24 | CreatePacket(mgCMemory*, mgCMemory*) | mgCVisual |
| 0x28 | Draw(float(*)[4], mgCDrawManager*) | mgCVisualMDT |
| 0x2C | Draw(u_int*, float(*)[4], mgCDrawManager*) | mgCVisualMDT |
| 0x30 | Initialize | mgCVisualMDT |
| 0x34 | **CreatePacket(mgCDrawManager*)** | mgCShadowMDT |
| 0x38 | **CreateFacePacket** | mgCShadowMDT |
| 0x3C | **CreateFace** | mgCShadowMDT |
| 0x40 | CreateExtRenderInfoPacket | mgCVisualMDT |
| 0x44 | **DataAssignMDT** | mgCShadowMDT |
Overrides declared in the header in vtable order. Their return types must equal the base virtuals
in `mg_visual.hpp`: chosen here as `int`, `u_int`, `int`, `FACES_ID*`, `int` (from the code;
CreatePacket returns `packet & 0x0FFFFFFF`, a DMA address). Reconcile with mg_visual if it differs.

### Inherited fields this unit touches (layout belongs to mg_dataset / mg_visual)
- 0x04 `mgCDrawEnv*` (CreateRenderInfoPacket: NULL -> copy `info+0xF20` draw env, else this one).
- 0x08 `mgCTextureManager*` (DataAssignMDT stores the argument; unlike mgCVisualMDT it does NOT
  default NULL to `&mgTexManager`).
- 0x10, 0x14 ints (Initialize sets 0x3C / 0xB4); ORed with 0x3000000 / 0x2000000 into VIF words.
- 0x30 vertex array (16-byte stride, indexed by face index) used by CreateFacePacket.
- 0x48 head of the face-group list (see below); DataAssignMDT clears it before CreateFace calls.

## Function behaviour summaries
- `SetShadowData(u_int*, float(*)[4])` (0x13A580, file-local): writes DMA tag `0x10000008`,
  VIF `0x6C080028` (UNPACK 8 qw), the 4x4 matrix, then two GIF A+D-like qword pairs
  (0x8001/0x102E8000/0xE, 0x68/0x80/0x42 and 0x62/...), returns 9 (quadwords). Called only from
  CreateRenderInfoPacket; the first game has the same function as `static`
  (`chronicle/ps2/src/visualvu1.cpp:231`), so it is treated as `static` and is NOT in the header.
  Retail binding is not recorded anywhere in the tree (map and symbol file carry none).
- `CreateFace`: allocs mgCFace (`new(Alloc(memory,5))`, 0x30 bytes). FACES_ID record: +0 u16
  attribute -> face+0; +4 int vertex count, face+8 = count/3 (triangles); +8 short material ->
  face+4; face+2 = 3; face+6 = face+8 * face+2. Index buffer from `index_memory`
  (`Alloc(qw(face+6*4) + 0x10)`) stored at face+0xC: for each triangle, copies the int at record
  offsets +0, +0xC, +0x18 (records start at +0xC, 0x24 bytes per triangle). face+0x10 next = 0.
  Face group at this+0x48: if NULL, `Alloc(memory, 0x12)`: {+0 material = face+4, +4 face list,
  +8 next group, +0xC = 1}; appends face at the end of the group's +4 list via face+0x10. Only
  ever one group here (shadow ignores material). Writes `*face` if non-NULL; returns record end.
- `CreatePacket(mgCDrawManager*)`: manager+0x5C / +0x60 are two mgCMemory (chain / data); for each
  group: group+0x10 = chain start; per face a `0x30000000|qwc` REF tag pointing at data, filled by
  virtual CreateFacePacket(data|0x20000000, face); then `mgSetPkTexFlush_TagCnt`, a `0x60000000`
  RET tag; group+0x14 = chain qwc. Commits both via `Alloc`. Calls GetTextureManager (result unused).
- `CreateFacePacket(u_int*, mgCFace*)`: NULL face -> 0; only `face+0 & 7 == 3` (triangles) is
  drawn, else 0. Packet address with top nibble 2 (uncached) -> builds in scratchpad
  (`GetScrPad`) and flushes with `SendDMA` whenever > 0x514 words; batches of up to 0x2A
  triangles; per batch: GIF tag (NLOOP, 0x202EC..., regs 0x41), 3 vertices copied as qwords from
  this+0x30; VIF word `0x6C008000 | qwc<<16`; ends batch with `prog_vif_208` (16 bytes, last word
  0x14000002 = MSCAL); ends packet with `at_243` (0x13000000 = FLUSHA). Returns quadwords.
- `DataAssignMDT`: NULL header -> 0. Stores texture manager, zeroes header+0x2C and +0x14 (so the
  copy skips those arrays), `CopyMDTData`, clears this+0x48, then calls virtual CreateFace for each
  face record (`header + header[0x28]`: count at +8, records from +0x10). Returns 1.
- `CreateRenderInfoPacket`: builds in scratchpad: matrices from mgRENDER_INFO (0x10 world/screen,
  0x1A0, 0x2A0, 0x340 shadow projection, 0x390.., 0xEC0.., 0xFB0..0xFBC, 0xF20 default draw env),
  `GetpLightInfo` (result unused), copies a draw env (`mgCDrawEnv::operator=`), `SetZBuf(-1)` and
  bit tweaks at env+0x2A1/0x2A2/0x2A0, then SetShadowData with `M(0x2A0) * M(0x1A0) * M(0x340) *
  matrix`, RET tag, `SendDMA(packet, qwc)`; returns qwc. `at_353` is a zero 16-byte .bss local
  (function-local static vector used as a cleared qword template).

## First-game correspondence
No `CShadowMDT` class in the first game: shadows there are `CVisualShadow` (dataset.cpp) and the
shadow pass in `CVisualVu1::DrawVu1`. Only `SetShadowData` corresponds directly (same packet,
VIF word 0x6C080029 vs 0x6C080028 here, and DMA tag added here).

## Types used but owned elsewhere (forward-declared)
`mgCFace` (0x30), `FACES_ID`, `MDT_HEADER`, face-group node (0x120 alloc, at mgCVisualMDT+0x48),
`mgRENDER_INFO` (mg_drawenv), `mgCDrawManager` (mg_drawprim), `mgCTextureManager` (mg_texture).
The mgCFace / FACES_ID / face-group layouts above are shared with mgCVisualMDT::CreateFace and
belong in mg_visual.hpp.

## Source status
All six functions are native C++ and byte-identical under the unit's `schedule off` and
`optimization_level 2` pragmas; there are no guarded drafts, `INCLUDE_ASM` entries or data
markers. The FLUSHA and zero quadword initializers and the `mgCShadowMDT` vtable are emitted
by the compiler.
- `CreateFace` walks the triangle indices as `int *vertex` over `source->index` (`vertex[0]`,
  `vertex[3]`, `vertex[6]`, stepping by 9) and reads the face section through `MDT_FACES`
  (`faces->prim_num`, first `FACES_ID` at `faces + 1`).
- `CreatePacket` builds DMA tags as `u_int` words, addresses the face data through its uncached
  mirror as an integer (`face_cursor | 0x20000000`) and measures packet sizes as byte
  differences between the `u_int` cursor and the `u_long128` packet start. The VU header packet
  mixes integer and float words (`head[20]` integer, `((float *) head)[21..23]` and `[56..]`
  floats) and copies quadwords and matrices into it through `u_long128`/`sceVu0FVECTOR` views.
- `mgRENDER_INFO::render_params` is `u_int[4]` but holds three floats and a word;
  `CreateRenderInfoPacket` reads `[0..2]` through `(float *)` and `[3]` as an integer. Splitting
  it needs the same edit in mg_sprite and water.
- `mgCShadowFixMDT` added to the header (no members; vtable entries all mgCShadowMDT's).
- `SetShadowData` confirmed file-local by `local_symbols.tsv`: `static` in the .cpp.
- Function-local data: `prog_vif_208` = `static u_int prog_vif[4] = {0,0,0,MG_VIF_MSCAL | 2}` in
  CreateFacePacket (copied by lq/sq); `at_243` = template of a local
  `u_int flush[4] = {0x13000000,0,0,0}` (FLUSHA; retail copies it to the stack then to the packet);
  `at_353` (.bss) = template of a zero local `u_int zero[4]` in CreateRenderInfoPacket.
- CreateFacePacket: GIF tag is a stack `sceGifTag` cleared by `sq $0`, then EOP=1, PRE=1 set BEFORE the
  `type & 7 == 3` test; then PRIM 0x5D (TRIFAN, IIP, TME, ABE), NREG 2, REGS RGBAQ/XYZF2. Word 11 of
  each batch header is never written. `vertex_num` of a shadow mgCFace is the triangle count
  (face_num / 3), each "vertex" holding 3 position indices (source stride 9 ints per triangle).
- CreateFace allocates `Alloc(5)` for the 0x30 mgCFace and `Alloc(0x12)` for the 0x20 mgFACE_GROUP
  (larger than mgCVisualMDT's 3 / 4); group `vu_program = 1` (MG_VU_PROG_SHADOW, written as a literal
  because mglib.hpp cannot be included with mg_drawenv.hpp: duplicate mgFOG_PARAM, see fixlist).
- CreateRenderInfoPacket layout (qwords from the scratchpad start): 0 DMA CNT (qwc 0x23), 1 VIF
  NOP/BASE/OFFSET/UNPACK(0x21 qw), 2-4 zero, 5 {unk_fb0[3], unk_fb0[0..2]} (w read with lw, xyz with
  lwc1: unk_fb0 is probably a float vector with an int w), 6-9 world_screen*M, 10-13 M, 14-16 {dir.x|y|z,0,0,0}
  of shadow_light_dir, 17-22 and 25 left unwritten, 23 full_max, 24 full_min, 27-30
  view_clip_full*view*M, 31-34 clip_screen_full, 35 MSCAL 0, 36 DMA CNT 8 + DIRECT 8, 37 GIF A+D x3,
  38 PRMODECONT 0, 39 PRMODE 0x40, 40 RGBAQ (1,1,1,0x80), 41-44 mgCDrawEnv (own or info->draw_env[0];
  SetZBuf(-1), ZTE 1, ZTST GEQUAL, ATE 0, AFAIL 0, DATE 0), 45.. SetShadowData with
  view_clip_full*view*shadow*M, then DMA RET. GetpLightInfo's result is unused.
- `SCE_GS_PRMODECONT` (26) and `SCE_GS_PRMODE` (27) added to `sce/libgraph.h`.
- DMA-tag and VIF-code names come from `mgPACKET_CODE` in `mg_drawprim.hpp`.
