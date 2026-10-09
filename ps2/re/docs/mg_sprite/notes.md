# mg_sprite: reverse-engineering notes

Header: `ps2/include/mg_sprite.hpp`. Classes: `mgCSprite` (screen sprite, base `mgCVisualPrim`),
`mgC3DSprite` (world billboards, base `mgCVisual`), enum `mgC3DSpriteMode`. No first-game
counterpart (the first game's `CSprite` in `title/sprite.hpp` is an unrelated title-screen trail).

## Dependencies (state when written)
- `mgCVisual` is owned by mg_dataset and `mgCVisualPrim` / `mgCVisualAttr` by mg_visual. Neither
  header existed, so `mg_sprite.hpp` does not compile yet. With stand-in definitions (mgCVisual
  = 0x1C bytes of data + vptr at 0x1C; mgCVisualPrim adds a 0x18-byte `mgCVisualAttr attr` at 0x20)
  the header compiles and gives sizeof(mgC3DSprite) = 0x50, sizeof(mgCSprite) = 0x78.
- `mgRect<int>` comes from `mg_tanime.hpp` (left, top, right, bottom; no constructor declared).
- Virtual return types of the overrides must equal mgCVisual's: assumed `int` for both `Draw`s
  and `CreateRenderInfoPacket` (they return quadword counts), `void` for `Initialize`. Adjust both
  headers together if mg_dataset chooses otherwise.

## mgCVisual facts seen from this unit (for mg_dataset)
- vptr at 0x1C (ctors store `__vt__9mgCVisual` there). `Initialize` zeroes 0x00, 0x04, 0x08, 0x14,
  0x10 in that order; it is expanded in `mgC3DSprite::Initialize` and `mgCSprite::Initialize`, so
  it is inline in the class (also emitted in mg_dataset at 0x133440).
- 0x08 = `mgCDrawManager::texture_manager` (manager+0x58), stored by both `Draw(u_int*,...)`.
- 0x0C = PRIM register value: `mgC3DSprite::CreateRenderInfoPacket` writes `0x158 | fog << 5`
  there and copies it into the packet's PRIM A+D write.
- `Draw(float(*)[4], mgCDrawManager*)` is `return Draw(NULL, m, dm);` via vtable slot 0x2C.
- Constructor (inline): `mgCVisual() { Initialize(); }` (virtual call through vptr).

## mgCVisualPrim facts (for mg_visual)
- `Iam__13mgCVisualPrimFv` (returns 7) is emitted in mg_sprite: it is an inline virtual.
- `mgCSprite::Initialize` starts with the same five stores + `mgCVisualAttr::Initialize(this+0x20)`
  as `mgCVisualPrim::Initialize`, so that function is inline too.
- `mgCVisualPrim::CreateRenderInfoPacket` reads 0x04 as `mgCDrawEnv*` (base field) and the attr at
  0x20. The attr is constructed in mgCVisualPrim's (inline) ctor (`DepthOfField`).

## mgCSprite (size 0x78, not asserted)
Only construction: inline in `DepthOfField__FiPfP10mgCTexturef` (screeneffect), object at
sp-0x90: vptr mgCVisual -> Initialize, vptr mgCVisualPrim + `mgCVisualAttr` ctor -> Initialize,
vptr mgCSprite, `mgRect<int>::Set(0,0,0,0)` at +0x50 and +0x60, then Initialize (all virtual
calls through slot 0x30). The next stack local starts at object+0x80, so size is 0x78..0x80;
fields end at 0x78 and the only 8-aligned member is `color`, giving 0x78. Not asserted because
no allocation or stride confirms it. The two `Set` calls may instead be an `mgRect` default
constructor if mg_tanime adds one; the header writes them in the ctor body.

| Off | Field | Evidence |
|---|---|---|
| 0x20 | attr (base) | Initialize then sets attr+0x08 (0x28) and attr+0x0C (0x2C) to -1; DepthOfField then sets 0x2C=1, 0x30=-1 |
| 0x38, 0x3C | unk | never touched in any function found; may belong to mgCVisualPrim |
| 0x40 | `texture` mgCTexture* | Initialize 0; CreatePacket: if set, `mgSetPkTEX0(p, tex+0x38, tex+0x40)` and PRIM TME bit `(tex!=0)<<4` |
| 0x44 | `depth` float | Initialize -1.0f; CreatePacket: if >= 1.0, `mgTransViewPrim(int out[3], {0,0,depth,1})`, Z = out[2] on success, else Z = 0 |
| 0x48, 0x4C | unk | untouched |
| 0x50 | `screen` mgRect<int> | XYZ2 of vertex 1 = (left + mgScreenOffx*16, top + mgScreenOffy*16, Z), vertex 2 = (right, bottom) likewise |
| 0x60 | `uv` mgRect<int> | UV register (FST, 14.4) = left|top<<16, then right|bottom<<16 |
| 0x70 | `color` sceGsRgbaq | SetColor: sb r,g,b,a at 0x70..0x73, sw 0 at 0x74 (Q); CreatePacket copies with `ld` into RGBAQ |

Vtable `__vt__9mgCSprite` (0x37B2E0, 0x38): Iam(mgCVisualPrim), GetMaterialNum, GetpMaterial,
GetMaterial, Copy, CreateBBox (mgCVisual), CreateRenderInfoPacket (mgCVisualPrim), CreatePacket
(mgCMemory*,mgCMemory*) (mgCVisual), Draw(m,dm), Draw(tag,m,dm), Initialize, then the new virtual
`CreatePacket(mgCDrawManager*)` at slot 0x34.

Functions:
- `Draw(u_int *tag, m, dm)`: dm NULL -> `&mgDrawManager`; this+8 = dm->texture_manager;
  `p = dm->data_memory->stAllocTest(0x3C)`; `n = CreateRenderInfoPacket(p, m, dm->render_info)`
  (slot 0x20); `data_memory->Alloc(n)`; `pk = CreatePacket(dm)` (slot 0x34); if tag: two DMA
  call tags {0x50000000, p, 0, 0}, {0x50000000, pk, 0, 0}, return 2; else return 0.
- `CreatePacket(dm)`: builds in `dm->packet_memory` at `stack + stack_used`: optional TEX0
  (mgSetPkTEX0 returns quadwords), DMA cnt {0x10000009,0,0,0x50000009} (DIRECT 9), GIF tag
  from the file-static `sprite_giftag` with NLOOP patched to 8 (written back to the static:
  `sprite_giftag.NLOOP = 8`-style store of 0x8008), then A+D: PRMODECONT(0x1A)=1, PRIM =
  0x146|tme<<4 (sprite, ABE, FST), RGBAQ, UV, XYZ2(5), UV, XYZ2, TEXFLUSH(0x3F)=0, DMA ret
  {0x60000000}. `packet_memory->Alloc(bytes/16)`, `data_memory->Alloc(0)`; returns
  `start & 0x0FFFFFFF`.

## mgC3DSprite (size 0x50, asserted)
Size: `__construct_new_array(..., __ct__11mgC3DSpriteFv, 0, 0x50, n)` and the 0x50 stride in
`CEffectList::CreatePacket` / `GetEffectVisual` (effectlist). Embedded in CStarEffect/CPaintEffect
at 0xA0, CGeyserEffect at 0x20, and in a 0x1190-byte object at 0x30 (dng_main/editloop/event_func).

| Off | Field | Evidence |
|---|---|---|
| 0x20 | `packet` u_long128* | BeginCreatePacket: `memory->stack + memory->stack_used`; Initialize 0; Draw returns 0 when NULL, else DMA call to it |
| 0x24 | `memory` mgCMemory* | BeginCreatePacket: `dm->data_memory` (manager+0x60, NOT packet_memory); EndCreatePacket Alloc on it |
| 0x28 | `packet_start` | `packet | 0x20000000` (uncached alias) |
| 0x2C | `packet_cur` | write cursor; starts = packet_start; advanced 0x10 per quadword |
| 0x30 | unk_30 | untouched |
| 0x34 | `batch_tag` u_int* | BeginCPSprite reserves; EndCPSprite: n = (cur - tag)/16 - 1: {n | 0x10000000, 0, 0, n<<16 | 0x6C008000} (DMA cnt + VIF UNPACK V4-32, FLG) |
| 0x38 | `batch_giftag` sceGifTag* | BeginCPSprite zeroes then: EOP=1, PRE=1; mode UPRIGHT: PRIM=0x5E (sprite, IIP, TME, ABE), NREG=5, REGS 1,3,4,3,4; ROTATE: PRIM=0x5C (tri strip), NREG=9, REGS 1,3,4,3,4,3,4,3,4 |
| 0x3C | `batch_header` u_int* | EndCPSprite: {sprite_num, mode, 0, 6} |
| 0x40 | `sprite_num` | BeginCPSprite 0; CPSetSprite ++, if > 32: EndCPSprite + BeginCPSprite |
| 0x44 | `mode` | BeginCreatePacket arg; tested `== 1` |
| 0x48 | `prog_started` | BeginCreatePacket 0; EndCPSprite: 0 -> emit `prog_vif$291` {0,0,0,0x14000002} (MSCAL 2) and set 1; else `progf_vif$292` {..,0x17000000} (MSCNT) |
| 0x4C | unk_4C | untouched (padding to 0x50) |

Vtable `__vt__11mgC3DSprite` (0x37B320, 0x34): mgCVisual's except CreateRenderInfoPacket (0x20),
Draw(m,dm) (0x28), Draw(tag,m,dm) (0x2C), Initialize (0x30). No new virtuals; Iam is mgCVisual's.

Functions:
- Ctor (effectlist, inline): vptr mgCVisual, Initialize via vtable; vptr mgC3DSprite, Initialize.
- `Initialize` (inline, emitted last in unit): packet = 0 stored first, then mgCVisual's five stores.
- `BeginCreatePacket(int mode, dm)`: dm NULL -> &mgDrawManager; sets 0x24/0x20/0x28/0x2C, mode,
  prog_started = 0. Callers pass mode 0 or 1 only (effectlist, editeff, editexception, funcpoint,
  dng_effect, effscript).
- `CPSetDrawEnv(env)`: if env: DMA cnt {0x10000004,0,0,0x50000004}, `*(mgCDrawEnv*)cur = *env`
  (operator=, 0x40 bytes), then if `env->GetAlphaMacroID()` is 2 or 3 (add/subtract) a DIRECT 2
  block: GIF tag {0x8001, 0x10000000, 0xE, 0} + FOGCOL(0x3D)=0.
- `CPSetTexture(tex)`: if tex: cur += mgSetPkTexFlush_TagCnt(cur); cur += mgSetPkTEX0(cur,
  tex+0x38, tex+0x40) (both return quadwords).
- `BeginCPSprite`: tag = cur++, giftag = cur++, header = cur++, sprite_num = 0, fill giftag.
- `CPSetSprite(pos, size, color, uv0, uv1)`: copies 5 float[4] quadwords; in ROTATE mode
  the second has [2] = sinf(size[2]) and [3] = cosf(size[2]). From CStarEffect::Draw: size =
  {w, h, angle, ?}; color = {r, g, b, a*128} floats; uv0/uv1 = texel corners (e.g. (0,0)-(32,31)).
- `EndCPSprite`: fills tag and header; if sprite_num > 0: DMA cnt {0x10000002,0,0,0}, MSCAL/MSCNT
  quadword, then `at_298` {0x13000000 FLUSHA,0,0,0}.
- `EndCreatePacket`: {0x10000001,0,0,0}, {0x13000000,..}, {0x60000000 ret,..}; cur += 3;
  `memory->Alloc((cur - packet_start) / 16)` (pointer difference of u_long128*).
- `Draw(tag, m, dm)`: like mgCSprite's but returns 0 when packet is NULL; with a tag writes
  call render-info, `mgSendVuProg(tag+4, 2)`, call `packet`; returns quadwords written.
- `CreateRenderInfoPacket(u_int*, m, ri)`: builds in the scratchpad: matrices (local-to-screen
  via mgMulMatrix with ri+0x10, and `m`), lighting from ri (GetpLightInfo, ri+0x50..0x80 scaled by
  the matrix row lengths), flags word from ri+0xFC0/0xFC4/0xFC8 and light info, PRMODE-like PRIM
  in this->0x0C, FOGCOL from ri+0xFD8..0xFDA (0 when light info +0x30 >= 2); `SendDMA`; returns
  quadwords. `at_199` is a zero quadword literal used as the fill value.

## Data
- `sprite_giftag` (.data 0x338260, 0x10): LOCAL in the retail ELF, so a file-static in the .cpp,
  not in the header. {0x8000, 0x10000000, 0xE, 0}: EOP, NREG 1, REGS A+D; NLOOP rewritten at run
  time by CreatePacket.
- `prog_vif$291`, `progf_vif$292`: function-local statics of EndCPSprite. `at_298`, `at_324__2`
  ({0,0,0,1.0f}, the view vector used by mgCSprite::CreatePacket), `at_199`: literals.

## Enum mgC3DSpriteMode
Name is not retail. 0 = upright sprites (default for any value except 1), 1 = rotated strips.
Values from the BeginCreatePacket callers and the `mode == 1` tests in BeginCPSprite/CPSetSprite.

## Source status
Every function is native C++ and byte-identical; the unit has no guarded drafts,
`INCLUDE_ASM` entries or data markers. Both vtables are compiler generated. The MSCAL and
MSCNT programs are function-local `static u_int[4]` tables of `EndCPSprite` (retail
`prog_vif$291`/`progf_vif$292`); MWCC rejects a 128-bit shift initializer for them
(`illegal data size`). `sprite_giftag` is the four-word `SpriteGifTagBuf`. The FLUSHA
terminator is a `VifQuad end = {MG_VIF_FLUSHA}` aggregate copied as a quadword; reading its
`q` member directly changes seven text bytes. `CreatePacket`'s view position is a native
`{0, 0, 0, 1}` array whose Z is then written, and `CreateRenderInfoPacket` emits its own
zero-vector template.
