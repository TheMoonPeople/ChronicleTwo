# mg_visual: reverse-engineering notes

## C++ draft status
All 42 functions have C++ in `ps2/src/mg_visual.cpp`. 11 are exact and compiled
by the matching build. 3 more compile to retail's bytes in isolation but stay
under `NONMATCHING`. 28 differ from retail and keep the `INCLUDE_ASM` fallback.
Each function tried has its one promotion attempt recorded in
`scripts/re/promotion_attempts.tsv`.

Header: `ps2/include/mg_visual.hpp` (includes `mg_dataset.hpp` for `mgCVisual`, `MDT_HEADER`,
`MDT_MATERIAL_`, `FACES_ID`, `mgVisualKind`). Declares `mgFaceType`, `mgDestAlphaTest`, `mgMaterial`,
`mgCFace`, `mgFACE_GROUP`, `mgCVisualAttr`, `mgCVisualMDT`, `mgCVisualFixMDT`, `mgCVisualPrim`.
No first-game counterpart for the class layouts. The first game's `CVisual*` family is a different
design. Its `MDT_HEADER`/`MDT_MATERIAL` (`chronicle/ps2/include/mdt.hpp`) match this game's file
format and back up the vertex/normal/colour/uv/material naming.

`mgCVisual` (mg_dataset) members defined in this unit: `GetTextureManager` (0x13EE90) and
`SetDrawEnvGifTag(u_long128*, mgRENDER_INFO*, mgCDrawEnv*)` (0x13EEC0, returns 4). They are declared in
mg_dataset.hpp, not here.

## Sizes and alignment (important)
- `sizeof(mgCVisualMDT) == 0x50`: `new(0x50)` for MDT/FixMDT/ShadowMDT in `CreateFrameVisual` and
  `mgCVisualFixMDT::Copy`, `TestVisual` (editloop) extent 0x50, and mgCVisualMotionMDT's own fields
  start at 0x50. The last field is at 0x48, and `__as__12mgCVisualMDT` (compiler-generated, see below)
  copies 0x00-0x18 and 0x20-0x48 only. So 0x4C is padding from 16-byte alignment, not a field.
  `mgCVisual` (mg_dataset) is asserted 0x20 with no alignment, so the header puts
  `__attribute__((aligned(16)))` on `mgCVisualMDT` (MWCC accepts it; tested).
- The same alignment probably belongs on `mgCVisual` itself. mgCSprite's first touched field is at
  0x40, and its 0x38/0x3C are never accessed (mg_sprite notes). That fits
  `sizeof(mgCVisualPrim) == 0x40` (0x20 + attr 0x18, padded). mg_sprite.hpp currently pads with
  `unk_38/unk_3C` instead. I did not assert `sizeof(mgCVisualPrim)` and did not align it. If
  mgCVisual gets aligned(16), drop the attribute here and mg_sprite's unk_38/3C.
- `mgCVisualAttr` 0x18: `memset(this, 0, 0x18)` in Initialize, and mgCFrameAttr's fields start at 0x18.
- `mgMaterial` 0x30: `GetMaterial` stride 0x30, `Alloc((n*0x30)/16)`, `new[](n*0x30)` in Copy.
  Holds two sceVu0FVECTORs, so 0x24 rounds to 0x30. Copy's 9-word copy = generated struct assignment.
- `mgCFace` 0x30: `Alloc(mem, 3)` in CreateFace. u_long128 at 0x20 (lq/sq in FixMDT CreatePacket)
  aligns 0x14..0x1F away.
- `mgFACE_GROUP` 0x20: `new(Alloc(mem,4)) [0x20]` + `memset(.., 0x20)` in CreateFace.

## mgCVisualMDT (0x50), base mgCVisual (0x00-0x1C, vptr 0x1C)
| Off | Field | Evidence |
|---|---|---|
| 0x20 | vertex_num | CopyMDTData `= hdr->vertex_num (+0xC)`; CreateBBox count |
| 0x24 | normal_num | `hdr+0x14` |
| 0x28 | colour_num | `hdr+0x1C`; GetColor writes it to *num |
| 0x2C | uv_num | `hdr+0x2C` |
| 0x30 | vertex `sceVu0FVECTOR*` | `hdr+vertex_ofs`; copied with sceVu0CopyVector; mgVectorMinMaxN source; SetData arg 5 |
| 0x34 | normal | `hdr+0x18` ofs; SetData arg 6 |
| 0x38 | colour | `hdr+0x20` ofs; GetColor returns it (CMapSky::DrawSkyBack reads [0],[1] when num==2); SetData arg 8 |
| 0x3C | uv | `hdr+0x30` ofs; SetData arg 7 |
| 0x40 | material_num | `hdr+0x34`; GetMaterialNum |
| 0x44 | material `mgMaterial*` | `Alloc(n*0x30/16)`; CopyMaterial from `hdr+material_ofs + i*0x60` |
| 0x48 | face_group `mgFACE_GROUP*` | DataAssignMDT zeroes it; CreateFace builds the list |

Initialize: clears 0x20..0x48, then the inlined `mgCVisual::Initialize`, then `vu1_base = 0x3C`,
`vu1_offset = 0xB4`. Order in retail: own fields first, then base clear, then the two stores.
Ctors are inline (`CreateFrameVisual`, `__sinit_editloop`, `Copy`: vptr store + virtual Initialize
through slot +0x30 at each level), so `mgCVisualMDT() { Initialize(); }` etc.

`__as__12mgCVisualMDTFRC12mgCVisualMDT` (0x1413F0, in the manifest) is the compiler-generated copy
assignment. It sits right after its first user `mgCVisualFixMDT::Copy`, copies every field word by
word and skips the vptr. It is NOT declared, because declaring it would suppress generation (same as
mg_camera's operator=). Copy uses it as `*copy = *this` (an `mgCVisualMDT&` assignment).
mgCVisualMotionMDT::Copy uses it too.

## Vtables
`__vt__12mgCVisualMDT` (0x37B400, 0x48): base slots +0x08..+0x30 (Iam, GetMaterialNum, GetpMaterial,
GetMaterial, Copy(base), CreateBBox, CreateRenderInfoPacket, CreatePacket(mem,mem)(base),
Draw(m,dm), Draw(p,m,dm), Initialize). New slots: +0x34 CreatePacket(mgCDrawManager*),
+0x38 CreateFacePacket, +0x3C CreateFace, +0x40 CreateExtRenderInfoPacket, +0x44 DataAssignMDT.
Call sites agree: Draw calls +0x20 and +0x34; CreatePacket calls +0x38; DataAssignMDT calls +0x3C;
FixMDT DataAssignMDT calls +0x3C then +0x38; CreateRenderInfoPacket calls +0x40.
`__vt__15mgCVisualFixMDT` (0x37B3B0): overrides Iam, Copy, Initialize, CreatePacket(dm), DataAssignMDT.
`__vt__13mgCVisualPrim` (0x37B370, 0x34): overrides Iam, CreateRenderInfoPacket, Initialize only.
Inline virtuals (emitted where used): MDT Iam/GetMaterialNum/GetpMaterial/Draw(m,dm) (mg_dataset
copies), FixMDT Iam (0x141840) and Initialize (mg_dataset 0x133420), Prim Iam (mg_sprite) and
Initialize (0x141820). The last two in this unit sit after every non-inline function, which fits them
being inline.
Return types: CreatePacket(dm) is `u_int` to match mg_shadow/mg_sprite (MDT returns
`(u_int)p & 0x0FFFFFFF`, FixMDT the raw start). `Draw(float(*)[4], mgCDrawManager*)` is `void` because
mg_dataset declares the base slot void. mg_sprite declares it `int`, so the three headers need to
agree. Body: `Draw(NULL, m, dm)` via +0x2C, and $v0 passes through.

## mgCVisualFixMDT (0x50, no own fields)
DataAssignMDT: on-stack mgCMemory over a 0x4B000-byte buffer as index memory, `CopyMDTDataPointer`
(vertex arrays point into the file), then per FACES_ID: `CreateFace(.., memory, &stack_mem, &face)`,
`qwc = CreateFacePacket(memory->stack + used*16, face)`, `face->packet_tag = {qwc|0x30000000 (REF),
addr, 0, 0}`, `memory->Alloc(qwc)`. Returns 1. CreatePacket copies each face's packet_tag instead
of building face packets.

## mgCVisualPrim
attr at 0x20 (`CreateRenderInfoPacket` passes `this+0x20` to SetDrawEnv; DepthOfField's stack sprite
calls `mgCVisualAttr()` on it between the Prim vptr store and the Initialize call).

## mgCVisualAttr (fields from SetDrawEnv / SetDrawEnvGifTag, mgCDrawEnv TEST at 0x10, ZBUF at 0x20)
| Off | Field | Evidence |
|---|---|---|
| 0x00 | alpha_ref | `>=0` -> TEST.AREF (bits 4..11 of halfword 0x10); init -1 |
| 0x04 | alpha_blend | non-zero -> `mgCDrawEnv::SetAlpha(v)` (mgAlphaMacroID) |
| 0x08 | z_write | SetDrawEnv: >0 clears ZMSK (byte 0x24 bit0), <0 sets it; GifTag variant passes it to `SetZBuf` (mgZBufMode). Init 1 |
| 0x0C | z_test | -1/1/2 -> ZTST 1/2/3 (= mgDEPTH_TEST); SetDrawEnv sets ZTE always, GifTag only when non-zero |
| 0x10 | alpha_test | -1 clears ATE; other non-zero sets ATE and ATST = v&7 (SetDrawEnv also writes ATST=7 for -1) |
| 0x14 | dest_alpha_test | -1 DATE off; 1 DATE on DATM 0; 2 DATE on DATM 1 (mgDestAlphaTest). Init -1 |
SetDrawEnvGifTag reads the same layout from `info->(+0xFCC)`, an mgCFrameAttr (derives mgCVisualAttr).

## mgCFace / FACES_ID / mgFACE_GROUP
mgCFace (`7mgCFace`, retail name, no members): 0x00 u_short type (lhu + andi), 0x02 short
index_stride = 3, +1 if 0x100, -1 if 0x200, -1 if 0x10; 0x04 short material; 0x06 short index_num
= vertex_num*stride; 0x08 short vertex_num; 0x0C int* index (`Alloc(index_mem, n/4+1)`, copied
from `faces->index`); 0x10 next; 0x20 packet_tag. CreateFace reads FACES_ID type/face_num/material
with `lhu` (int fields in mg_dataset.hpp: MWCC narrowing the load. Change the field types if the
body will not match). The return value is the record after the index words.
mgFACE_GROUP (**name invented**, no symbol): 0x00 material index (match key, plus `unk 0x0C == 0` for
appended groups), 0x04 first face (faces appended at the tail via `next`), 0x08 next group,
0x0C vu_program (0 here; mgCShadowMDT::CreateFace sets 1 = MG_VU_PROG_SHADOW; Draw passes it to
`mgSendVuProg` / `AddPacket` arg 4), 0x10 packet (set by CreatePacket; `AddPacket` arg 3),
0x14 packet_size in qw (CreatePacket). 0x18/0x1C never seen.
Face type bits (mgFaceType), confirmed by SetData0-7 table index `(0x100?1)+(0x10?2)+(0x200?4)`
and the source arrays each variant reads (0: v,n,uv; 1: v,n,uv,c; 2: v,n; 3: v,n,c; 4: v,uv;
5: v,uv,c; 6: v; 7: v,c). SetPModeRef clears PRMODE TME for 0x10 and IIP for 0x8. `type & 7` is the
GS PRIM (CreateFacePacket: 4 = triangle strip gets a different GIF PRIM and re-sends 2 vertices
when it splits a batch). This resolves mg_dataset's "BeginPrim flags unresolved".

## mgMaterial
0x00 diffuse (MDT_MATERIAL_ 0x00; sent alone by `mat_vif_dif` when flags&1 is clear). 0x10 unk_10
(MDT_MATERIAL_ 0x10, which the first game calls ambient. It is uploaded with diffuse, a zero qw and
`mat_pw` by `mat_vif`: UNPACK 4 qw to VU 0x28). 0x20 texture (`GetTexture(rec->texture, -1)`,
MDT_MATERIAL_ 0x34). SetMaterialRef reads texture +0x38 tex0, +0x40 tex1, +0x48 clamp.
SetMaterialRef(packet, material, flags): flags = `info->(+0xFCC)->(+0x40)` (an mgCFrameAttr field).
No texture: 5 qw. Texture and !(flags&1): 7 qw. Otherwise 10 qw. Sets `prev_tex`.

## Globals
- `giftag` (.data 0x338320, u_long128 {0x8000, 0x10000000 (NREG 1), 0xE (A+D), 0}): SetPModeRef
  and mgCVisualPrim::CreateRenderInfoPacket store 0x8001/0x8002 (`sw`) into its low word, then copy
  it with lq/sq.
- `set_tex0_dma`/`set_texa_dma`: DMA CNT tags qwc 3/4 plus VIF DIRECT 3/4. `set_tex0_giftag`/
  `set_texa_giftag`: A+D GIF tags NLOOP 2/3. All u_long128 (lq/sq).
- `texflush_dma__2` (0x30, DMA tag + GIF tag + TEXFLUSH A+D): the `__2` suffix shows a second
  `texflush_dma` exists (mg_texture), so this is a file-static `static u_long128 texflush_dma[3]`. Not in header.
- `set_data_func__2` (0x20): `static` table of SetData0..7 (visualmotion has another
  `set_data_func`). Not in header. Type `u_long128 *(*[8])(int, int, int **, u_long128 *, ...)`.
- `mat_vif` UNPACK V4-32 4qw @0x28; `mat_vif_dif` UNPACK 1qw @0x28; `mat_vif_d` DIRECT 2;
  `mat_pw` {3,0,0,0}; `mat_vif_d_tex` DIRECT 4.
- `prog_vif_730`/`progf_vif_731` (function-local statics of CreateFacePacket: VIF MSCAL / MSCNT
  variants, first batch vs following) and `at_769` (end quadword) are compiler-generated, not in header.
- .sbss: `start_dma` int (SendDMA waits on COP0 condition when set), `buff_id` int (0/1 toggled per
  SendDMA; GetScrPad returns 0x70000000 or 0x70002000), `prev_tex` mgCTexture*.
- The retail ELF binding is lost (every symbol GLOBAL), so linkage cannot be checked. The plain-named
  data and SetData0..7 are declared in the header. If the body writer finds them static (same-file
  tables only), move them to the .cpp.

## Functions (non-member)
- GetScrPad -> `u_int*`; SendDMA(void* dst, int qwc): DMA ch8 (fromSPR), MADR = dst & 0x0FFFFFFF,
  SADR = scratchpad half, then toggles buff_id. CreateFacePacket/Prim RenderInfo write into the
  scratchpad when the packet address has top nibble 2, and flush through SendDMA every 0x514 words.
- mgSetPkTEX0(p, tex0, tex1[, texa]): writes TEX1 (reg 0x14) first, then TEX0 (6) [, TEXA 0x3B];
  returns 4 / 5. mgSetPkTexFlush_TagCnt returns 3 (writes only when p != NULL).
- SetPointLight(p, m0, m1): VIF UNPACK 8 qw to 0x2D, both 4x4 matrices; returns 9. What each
  matrix holds is not shown here (no caller in the manifest).
- CopyMaterial: diffuse and unk_10 copied, texture looked up by name.
- SetDrawEnv(env, attr, base): `*env = *base`, then applies attr as in the table above.
- SetData0..7(count, type, &index_cursor, out, v, n, uv, c): out[0..3] = {count, count|0, count|0,
  type}, then streams of quadwords gathered by index, and advances the cursor. Return value ($v0) =
  end of the written data (CreateFacePacket writes the MSCAL code there).

## Unresolved
- Where the 16-byte alignment really lives (mgCVisual vs mgCVisualMDT), see above.
- mgMaterial unk_10 meaning. mgFACE_GROUP 0x18/0x1C. mgCFace 0x14..0x1F (padding).
- Draw(float(*)[4], ...) return type across mg_dataset/mg_sprite/mg_visual.
- `mgCVisualMDT::CreateExtRenderInfoPacket` ignores its packet, matrix and render
  info arguments and returns 0. Its C++ body matches and links byte-identically.
