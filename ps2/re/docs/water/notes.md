# water: reverse-engineering notes

`CFireRaster::Step` advances 20 wisp particles, expires spent particles and respawns the last free slot. Its sway phase is twice the loop counter. Typed particle indexing, phase expressions `i * 2`, and advancing the particle index before the counter reproduce the complete 460-byte PAL function, including relocations. The free slot is passed as its `position` member.

## Matching status

All functions are native and exact.

Header: `ps2/include/water.hpp`. Types: `FireRasterParticle` (neutral name, no retail symbol),
`CFireRaster`, `CThunderEffect`, `CWater`, `CWaterFrame`. One free function `CreateWaterFrame`
(global). No plain-named globals: `.data` holds only `prog_vif_351` / `progf_vif_352` (local,
function-statics of `CWater::CreatePacket`, 0x10 each: the two VIF microprogram-start qwords
appended after every grid strip, the first strip uses `prog_vif`, the rest `progf_vif`), and
`.bss` holds `at_287` (local, 0x10 literal qword copied three times into the render-info packet
by `CreateRenderInfoPacket`).

## CWater : mgCVisual (size 0x80)
Size: `CreateWaterFrame` does `new(mem->Alloc(10)) CWater` with size 0x80 (`__nw__FUiP1(0x80,..)`).
mgCVisual is 0x20 with its vptr at 0x1C (ctor stores `__vt__9mgCVisual` then `__vt__6CWater` there).

| Off | Field | Evidence |
|---|---|---|
| 0x20 | `float *height_a` | SetSize: `Alloc(rows*cols/4+1)`; Hamon swaps with 0x24 |
| 0x24 | `float *height_b` | same |
| 0x28 | `mgCTexture *texture` | ctor = 0; CWaterFrame::SetTexture writes it; CreatePacket reads tex0 (0x38), tex1 (0x40) etc. from it to emit TEX0 when non-null |
| 0x2C | `u_int packet` | CreatePacket stores and returns the packet address (`base | 0x20000000`-ish uncached arena address); Draw puts it in a VIF/DMA call tag (`0x50000000, packet`) |
| 0x30..0x3C | `int color[4]` | SetColor stores each `unsigned char` as a word; ctor 0x80 each; CreateRenderInfoPacket converts each with int->float |
| 0x40 | `float speed` | ctor 0.1; Hamon uses speed^2 as the neighbour coefficient |
| 0x44 | `float damping` | ctor 0.015; Hamon: `new -= damping*(new-old)` |
| 0x48 | `float unk_48` | ctor 0; only copied into the render-info packet (qword 0x74/4) for the VU1 microprogram |
| 0x4C | `float unk_4c` | ctor 0; same. Callers pass 0 for the 3rd and 16/300/10/100 for the 4th SetParam argument |
| 0x50 | `int unk_50` | set 0 by SetSize only; never read in water. First game's equivalent was `tags_built` (unverified) |
| 0x54 | `int rows` | ctor 0; SetSize; Shake mod/clamp; x step = (max.x-min.x)/(rows-1) |
| 0x58 | `int columns` | likewise; row stride of the height buffers; z step = (max.z-min.z)/(columns-1) |
| 0x5C | `float *height` | current buffer; SetSize = height_a; Hamon flips it |
| 0x60 | `sceVu0FVECTOR min` | SetVertex = `mgVectorMaxMin(&max,&min,a,b)`; CWaterFrame::Shake range test |
| 0x70 | `sceVu0FVECTOR max` | same |

mgCVisual base fields touched: 0x04 draw_env (CreateRenderInfoPacket, falls back to info+0xF20),
0x08 texture_manager (Draw: `= draw_manager+0x58`), 0x0C prmode (`(fog&&...)<<5 | 0x158`).

Vtable `__vt__6CWater` (0x38, 12 slots): mgCVisual's Iam, GetMaterialNum, GetpMaterial,
GetMaterial, Copy, CreateBBox, **CreateRenderInfoPacket (CWater)**, CreatePacket(mgCMemory*,mgCMemory*),
Draw(float(*)[4],mgCDrawManager*), **Draw(u_int*,float(*)[4],mgCDrawManager*) (CWater)**,
Initialize, **CreatePacket(mgCDrawManager*) (new, CWater, vtable offset 0x34)**.
The ctor (non-inline, `__ct__6CWaterFv`) is the inline mgCVisual ctor (virtual Initialize call
through slot 0x30) followed by CWater's initialisers.

Hamon: classic two-buffer wave equation;
`n = (N+W+E+S)*s^2 + (2-4s^2)*c - o; new = n - damping*(n - o)` over interior points.
Shake(int,int,float): `row % rows`, `column % columns`, clamped to [1, n-2], adds to `height`.
CreatePacket allocates ~0x10000 bytes of stack for per-point slope vectors (rows*0x400 stride,
i.e. up to 64 columns of 16 bytes); edges get fixed 0.6/0.3 values; strips of up to 27 (0x1B)
points per GIF tag.

First game: `CWater` (0x320) was a standalone class with an embedded CVisualPolyVu1/CFrameVu1;
here it is an mgCVisual subclass of 0x80 and the frame is the separate `CWaterFrame`.
The first game named 0x48/0x4C `height_scale`/`distortion`; this game only forwards them to VU1
microcode, so they are left `unk_` (hypothesis only).

## CWaterFrame : mgCFrame (size 0x120)
Size: `CreateWaterFrame` allocates 0x120 (`Alloc(0x14)`), runs `mgCFrame::mgCFrame()`, stores
`__vt__11CWaterFrame`, then calls Initialize through the vtable (inline ctor -> `CWaterFrame() {
Initialize(); }`). mgCFrame is 0x110.

| Off | Field | Evidence |
|---|---|---|
| 0x110 | `int unk_110` | Initialize = 0; never read anywhere found |
| 0x114 | `int stop` | Initialize = 0; Step skips Hamon when non-zero. No writer found outside |
| 0x118 | `int unk_118` | never touched (size only) |
| 0x11C | `int unk_11c` | never touched |

Vtable `__vt__11CWaterFrame` (0x54): mgCFrame's 17 slots with Initialize replaced by
`CWaterFrame::Initialize` (offset 0x3C), then new `GetWater` (0x4C) and `Step` (0x50).
GetWater returns `(CWater *)visual` (mgCFrame+0xF8). All CWaterFrame forwarding functions call
GetWater() virtually and test for NULL (except CreatePacket and Shake(fff), which don't).
CreatePacket calls `GetWater()->CreatePacket(&mgDrawManager)` (slot 0x34).
Shake(float x, float z, h): world -> local via inverse of GetLWMatrix, range test against
min/max x/z, grid index = `rows*(x-min.x)/(max.x-min.x)` etc., then Shake(int,int,float).
Users: CMap::DrawWater (map), cfgWATER_VERTEX/cfgWATER_PARAM (mapload, global `cfgWater`),
CAquarium (menuaqua, +0xB8), sgLoopGyoRace (gyorace).

## CreateWaterFrame(int rows, int columns, float *min, float *max, mgCMemory *memory)
Allocations use `memory->Alloc(size/16 + 2)` qwords + placement new (`__nw__FUiP1`):
CWaterFrame 0x120, mgCFrameAttr 0x90 (fields +8=-1, +0xC=1, +0x10=-1, +4=1, i.e. mgCVisualAttr
members), CWater 0x80, mgCFrame::BoundInfo 0xB0 (stored to `bound`, +0xF0). Then
`SetSize(rows, columns, memory)`, `SetVertex(min, max)`, `SetVisual(water)` (slot 0x48),
`SetBBox(max, min)`. The parameter names min/max come from that SetBBox order. Returns 0 if
the frame or the water allocation fails.

## CFireRaster (size 0x2F0)
Size: lives in CScene at +0x24F0 (MainScene 0x1DFB130 -> 0x1DFD620); `__sinit_mainloop_cpp`
constructs it inline: `mgCTexture::mgCTexture()` at +0, a 20-element loop of `memset(p,0,0x20)`
over +0x70..+0x2F0 (element inline ctor), then `CFireRaster::Initialize`. Hence the inline ctors
`FireRasterParticle() { memset }` and `CFireRaster() { Initialize(); }`. CMap also holds a
`CFireRaster *` at +0xCFC for DrawFireRaster (funcpoint).

- 0x00 `mgCTexture texture` (0x70): SetTexture copies every field of the given texture
  (= compiler `operator=` copy, `next` at 0x68 included) then clears bit 2 of byte 0x3C, i.e.
  TEX0.TCC (bit 34). The texture is the frame-buffer copy target set up by CScene::DrawEffect.
- 0x70 `FireRasterParticle particle[20]`, stride 0x20 (Initialize/Step loops `< 0x14`).

FireRasterParticle: 0x00 position (x = sin((time+2i)/10*pi)*10, y += 1.2 per step,
z = sin((time+2i+10)/8*pi)*10; spawn = mgZeroVectorW), 0x10 float size (spawn 13.0, -0.1 per
step; Draw uses it as sprite half-size), 0x14 int time (spawn rand()%20, +1 per step), 0x18 int
life (spawn 30; >0 = live; when time >= life the slot is memset), 0x1C unused.
Draw(position, scale): position from funcpoint (world point + up offset), scale = funcpoint
point +0x1A0; draws MG_PRIM_SPRITE (Begin(6)), TEXA via Direct(0x3B, 0x8000000080), colour
(0x80,0x80,0x80,0x20), screen-clamped sprites whose UVs are the same rect inset by 0x28.

## CThunderEffect (size unknown, >= 0x9C)
Only `Init` exists: words at 0x00, 0x90, 0x94, 0x98 = 0. Lives in CScene at +0x3E70. No other
code touches CScene+0x3E70..0x405F (next known CScene field is at +0x4060), so the size is
bounded by 0x1F0 but not established; no STATIC_ASSERT. Field types are unknown beyond "word
stored as 0". Not related to `CThunder` (dng_effect) as far as the code shows. No first-game
counterpart.

## Compiler flag cleanup

The local `divbyzerocheck on`/`reset` pair around `CWater::Shake` is redundant
with the PS2 compiler flag. Removing it leaves every section and symbol in
the water unit's object diff unchanged.


## Native data

All data are native; no assembly data markers remain. The compiler emits the 0x38-byte
`CWater` vtable, 0x54-byte `CWaterFrame` vtable and 16-byte zero-vector initializer.
`CWater::CreatePacket` owns the aligned four-word MSCAL(2)/MSCNT command arrays. Their
source base names, exact extents and bytes, and complete retail consumers establish
identity without numeric suffixes. MWCC rejects native 128-bit shift initializers with
`illegal data size`, so the word-array representation is retained.

## Allocation-size inline

`CreateWaterFrame` writes every allocation as
`memory->Alloc(align16_blocks(sizeof(T)) + 2)`, using the file-local rounding inline that
other units also define. Retail's constants (0x14, 0xB, 0xA, 0xD for 0x120, 0x90, 0x80
and 0xB0 bytes) equal that expression. The inline's `if` and early return put it in
MWCC's class 3, so the compiler statement-inlines it. That natively requests statement
conversion for each allocation statement, which gives the early construction form with
no `placement_new` row:

- For the outlined `CWater` constructor, `beqz v0` tests the allocator result, the delay
  slot copies it into the named pointer's `s6`, the constructor receives `s6`, and its
  result replaces `s6`.
- For the inline `CWaterFrame` construction, the same form applies.

`sizeof(T) / 16 + 2` folds to the same constants but leaves the statement unconverted. An
outlined construction then lowers as the late form (`move s6,v0; beqz s6`) into a
non-const pointer. Into a `const` pointer, it lowers as a separate temporary that passes
`v0` to the constructor. Retail `EditInit` shows the same early form for its local
`CCameraControl` construction.
