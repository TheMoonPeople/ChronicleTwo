# mglib notes

## C++ draft status
All 101 functions have C++ in `ps2/src/mglib.cpp`. 43 are exact and compiled by
the matching build. 31 more compile to retail's bytes in isolation but stay
under `NONMATCHING`. 27 differ from retail and keep the `INCLUDE_ASM` fallback.
Each function tried has its one promotion attempt recorded in
`scripts/re/promotion_attempts.tsv`.

Header: `ps2/include/mglib.hpp`. No class is owned by mglib (`class_units.tsv`). Declared here:
structs `mgFOG_PARAM` (retail name, from `mgSetFogParam__FP11mgFOG_PARAM`) and `MG_PICKZ`
(name taken from the first game's mglib.hpp; no retail symbol names it in this game); enums
`mgSCREEN_MODE`, `mgVU_PROG_ID` (neutral names); 95 global function prototypes; externs for every
GLOBAL datum. The `.cpp` now includes `mglib.hpp`. Header compiles; `draft.sh mglib` compiles.

## Symbol binding (retail ELF `rom/pal/extracted/iso/SCES_511.90`, `readelf -s`)
The built ELF in `build/pal` marks everything GLOBAL; the retail ELF does not. Use the retail one.
- LOCAL functions -> `static` in the .cpp, NOT in the header: `VSyncCallBack__Fi`,
  `WaitVSync__Fii`, `GetScreenSize__FiPiPiPiPiPiPi`, `prim_clip_check__FPf`, `CheckVuProgID__Fi`,
  `StoreImage__Fi`. `__ct__9mgCMemoryFv` is weak (inline ctor, declared in `mg_memory.hpp`).
- GLOBAL data (in header): mgAntialiasing .. mgScreenBottom, VSyncField, mgTEX1_1 .. mgFRAME_1,
  ddraw_size, mgGiftagAD, mgRenderInfo, mgBackColor, mgTexManager, mgDrawManager, mgDBuff,
  mgPickZBuff.
- LOCAL data (file statics, define `static` in the .cpp): mgDBuffID, mgDataID, mgChangeLight,
  packetbuf, packet_size, frame_buf0, frame_buf1, font_draw_flag, draw_performance_meter, mgDIMX,
  vcount, old_vcount, over_vsync, VSyncCallBack2, call_back_active, h_count, capture_on,
  cap_ture_cnt, user_prog_adr, user_prog_num, font_cons, rot_priority, now_prog_id, prog_adr,
  vifpacket, packet_buf, data_buf, frame_tex, fixz_tex, gs_simage. Function-local statics:
  `dimx$281` (mgInit), `count$580/cpu_ratio$583/free_ratio$586` + `init$...` (mgEndFrame),
  `store_data$614` (mgEndFrame, 0x1000 bytes = u_int[0x400] z read-back), `image_num$1535`
  (StoreImage). `@863` is a 16-byte .bss zero vector used by `mgSetBackGround(ffff)`.
- Retail true sizes differ from the padded INCLUDE_BSS slots: VSyncField 4 (slot 8),
  mgChangeLight 4, draw_performance_meter 4, mgTexManager 0x21C (slot 0x220), gs_simage 0x70
  (slot 0xA0), prog_adr 12 (3 pointers).

## Global types (evidence)
- `DmaCH1/2/8` sceDmaChan* (sceDmaGetChan results; CH1 chcr.TTE set). DmaCH2 also used by movie,
  DmaCH8 by mg_visual.
- `mgVif1Packet` sceVif1Packet*: `= vifpacket + mgDataID` (vifpacket = sceVif1Packet[2], 0x20 each).
- `mgNowFrameRate` float: `(RCNT0 - h_count) / 262.0`, clamped to mgFrameRate + 1 (mgEndFrame).
  Note `mgGetNowFrameRate()` returns `(float)mgFrameRate`, not mgNowFrameRate.
- `mgScreen*` ints set by mgInit/GetScreenSize: NX=-w/2, NY=-h/2, MX=w+NX, MY=h+NY;
  Offx=0x800-w/2, Offy=0x800-h/2 (pixels; multiplied by 16 for XYZ); Left/Top=Off, Right/Bottom =
  Off+size; Depth=ZDepth=32. mgScreenMode = GetScreenSize result (0..3, see enum).
- `mgTEX1_*`, `mgTEST_*`, `mgZBUF_*`, `mgALPHA_*`, `mgTEXA_*`, `mgFRAME_1` typed as the SDK GS
  register structs (8 bytes). mgInit writes them as whole 64-bit constants (TEX1 0x261, TEST
  0x5000B, ALPHA 0x44, TEXA 0x100400000) and copies ZBUF from mgDBuff.draw0.zbuf1; uses read
  `ZBP` (`& 0x1FF`). A matching body may need `*(u_long *)&mgTEX1_1 = ...`. If that proves awkward,
  `u_long` is the alternative type.
- `mgPickZBuff` MG_PICKZ[4] (0x40): mgEndFrame loops 4 x 0x10 entries {enable, x, y, z}; z = min
  24-bit depth of an 8x8 read-back at (x-4, y-4), or -1 outside [4, size-4]. Nothing in the game
  sets `enable` (only mglib references the symbol).
- `mgBackColor` sceVu0FVECTOR; mgInit sets (0,0,0,128). Converted with fptosi into the clear
  colour bytes of mgDBuff.clear0/clear1 rgbaq (0x398410 / 0x398500) in mgInit and mgBeginFrame.
- `mgDBuff` sceGsDBuff (0x230 = 2*0x28 disp + 2*(0x10 giftag + 0x80 draw + 0x60 clear)); mgEndFrame
  rewrites disp[mgDBuffID].pmode/dispfb/display; draw0.frame1 at +0x60 (0x398370), draw1.frame1 at
  +0x150 (0x398460).
- `mgTexManager` mgCTextureManager (`__sinit` calls its ctor), `mgDrawManager` mgCDrawManager
  (ctor in `__sinit`). `mgRenderInfo` mgRENDER_INFO (memset 0x1020 in mgInit, then
  `Initialize`). These three are forward-declared; headers owned by mg_texture, mg_drawprim,
  mg_drawenv.
- `mgGiftagAD` sceGifTag: NLOOP 0, EOP 1, NREG 1, REGS = 0xE (A+D); rebuilt every mgBeginFrame.
- `ddraw_size` int: quadwords written since mgDrawDirectStart; mgDrawDirectEnd reserves
  `ddraw_size << 2` words.

## Locals (for the body writer)
- `packet_buf`, `data_buf`: mgCMemory[2] each (`__construct_array(.., 0x30, 2)`); indexed by
  mgDataID (which flips 0/1 in mgSendPacket). mgSetPacketBuffer struct-copies two managers into
  packet_buf and zeroes `lock`/`stack_used`; mgSetDataBuffer `stSetBuffer`s data_buf from
  `stAllocTest(1)` (+0x4000 quadwords when the int is non-zero) and zeroes lock/stack_used.
  mgBeginPacket stores &packet_buf[id] / &data_buf[id] at mgCDrawManager +0x5C / +0x60.
- `frame_tex` mgCTexture (0x70, ctor in `__sinit`); `fixz_tex` mgCTexture[2] (construct_array
  0x70 x2); mgGetFrameBuffer/BackBuffer struct-copy frame_tex into the caller's texture (the back
  buffer variant then patches TBP0 from the other buffer's FBP).
- `packetbuf` u_long128*[2] (the two aligned VIF buffers), `packet_size` = mgInitVif1Packet's 3rd
  argument ($6 stored at gp-0x7850).
- `prog_adr` = {Vu_prog0, Vu_prog_sdw, Vu_prog_3dsp} (ids 0..2); user ids 0x100 + n index
  `user_prog_adr[n]`, n < user_prog_num; CheckVuProgID also rejects NULL entries. `now_prog_id`
  (init -1) = last id sent by mgSendVuProg, which writes a 4-word VIF `MSCAL`-style call
  (0x50000000 = DIRECT/CALL tag word, packet address) and returns 4, or 0 when already loaded.
- `font_cons` (init -1) devcons handle; `rot_priority` (init -1) priority for
  RotateThreadReadyQueue in WaitVSync; `draw_performance_meter` toggled by mgPerformanceMeter.
- `vcount` incremented in VSyncCallBack (clamped >= 0); `VSyncField` = !(GS CSR bit 13);
  `call_back_active` 1 during the handler; handler calls `VSyncCallBack2` (set by
  mgInitVSyncCallBack) and ends with `sync; ei`.
- `capture_on`/`cap_ture_cnt`: mgEndFrame calls StoreImage(0) when capture_on (every other frame
  at 60 Hz) and clears capture_on. StoreImage writes "host0:" + "%s%5d.tga" (spaces -> '0') with
  the 18-byte TGA header `@1538` (width/height patched), reading the image to 0x2100000.
- `mgDIMX` u_long dither matrix built from `dimx$281` (4x4 signed values halved minus 4, packed
  3 bits per nibble).
- gp offsets seen in the asm: `rot_priority` -0x7FE4, `font_cons` -0x7FE8,
  `vcount` -0x7830, `VSyncCallBack2` -0x7824, `ddraw_size` -0x77F8, `user_prog_adr` -0x77F4,
  `user_prog_num` -0x77F0, `mgVif1Packet` -0x790C, `mgDataID` -0x7864, `mgScreenOffx/y`
  -0x78E8/-0x78E4.

## Types used but owned elsewhere
- `mgRENDER_INFO` (mg_drawenv). Offsets mglib touches: 0x0 projection; 0x10 world->screen matrix
  (mgTransWorldPrim, 3DSprite); 0x50 view->screen matrix (mgTransViewPrim), 0x64 / 0x78 / 0x88
  (3DSprite y scale, ConvZBuffToDist terms); 0x1A0 view matrix (mgTransWorldView,
  mgSetProjection); 0x3A0 camera position; 0x3B0..0x3E0 camera pose rows; 0xE88 near / 0xE98 far
  clip depth (prim_clip_check, mgSetProjection); 0xEA0 / 0xEB0 clip vectors flushed by
  mgFlushRenderInfo; 0xF20 mgCDrawEnv[2] (0x40 each, `__sinit` constructs them; ZBUF at +0x20 of
  each = 0xF40 / 0xF80, set in mgInit; mgGetpDrawEnv returns `&env[index != 0]`); 0xFA0
  all-scissor flag; 0xFD0..0xFFF fog block with exactly the mgFOG_PARAM layout (see below).
- `mgPOINT_LIGHT` (forward-declared; best owned by mg_drawenv, whose mgRENDER_INFO methods take it):
  0x30 bytes = position vec4 @0, colour vec4 @0x10, float @0x20 (scale), float @0x24 (range; <= 0
  derives it from max colour component * @0x20); mgRENDER_INFO::SetPlight(int, Pf, Pf, f, f) fills
  a stack copy that way.
- `mgCDrawManager` (mg_drawprim): +0x54 memory in use, +0x58 mgCTextureManager*, +0x5C packet
  mgCMemory*, +0x60 data mgCMemory*, +0x64 mgRENDER_INFO* (mgInit/mgBeginFrame default these to
  &mgTexManager / &mgRenderInfo). mgCDrawManager::Draw/ReloadTexture take a texture block index.
- `mgCFrame` vtable: +0x34 draw (mgDraw), +0x44 build packet into u_int* (mgDrawDirect/2);
  `mgCVisual` vtable pointer at +0x1C, slot +0x2C build packet (visual, u_int*, matrix, 0).
- `mgCTexture`: +2 width, +4 height (short), +6, +0x38 sceGsTex0 (TBP0/TBW/PSM read), size 0x70.
- `mgRect<int>` (mg_tanime) passed by value as 4 ints {x0, y0, x1, y1}; in mgSetPkMoveImage the
  coordinates are 1/16-pixel (`>> 4`), mgStoreZBuffImage pixels (inclusive, rounded up to 8).
- `sceGsClamp`: NOT in `ps2/include/sce/libgraph.h`. Forward-declared in mglib.hpp as
  `struct sceGsClamp;` so `mgSetPkTextureRepeat(sceGsClamp)` mangles. When the body is written it
  must be complete (8-byte SDK bitfield struct WMS:2 WMT:2 MINU:10 MAXU:10 MINV:10 MAXV:10);
  add it to libgraph.h as `typedef struct sceGsClamp {...} sceGsClamp;` (tagged, so the forward
  declaration here stays valid) and drop nothing else. mgSetPkTextureRepeat(int) memsets 8 bytes
  and sets WMS=WMT=1 (clamp) when the argument is 0.

## mgFOG_PARAM (0x30)
`mgSetFogParam(mgFOG_PARAM*)` reads 0 f, 4 f, 8/9/10 u8, 0x10 f, 0x14 f (args of
`mgRENDER_INFO::SetFogParam(near, far, r, g, b, far_fog, near_fog)`). `mgGetFogParam` copies
mgRenderInfo+0xFD0.. field by field: 0, 4 (floats), 8..0xB (4 bytes), 0xC, 0x10, 0x14, 0x18
(floats), skips 0x1C, then 0x20..0x2C (four floats from +0xFF0, qword aligned). SetFogParam
computes 0xC = (far_fog + near_fog + (far_fog - near_fog)(far+near)/(far-near)) / 2 and 0x18 =
-far*near*(far_fog-near_fog)/(far-near) (first game's fog_a / fog_b) and copies {0xC,0x10,0x14,
0x18} into 0x20 (the vector mgFlushRenderInfo sends). Size 0x30 = extent written by
mgGetFogParam with 16-byte alignment of the trailing vector; not independently confirmed by a
caller's stack frame. If mg_drawenv embeds an mgFOG_PARAM in mgRENDER_INFO at 0xFD0 it should
include mglib.hpp's definition rather than define its own (or one of the two must move).

## Return types
From callers / asm: mgGetFogEnable, mgGetPlightEnable, mgActiveLighting (previous set),
mgTransWorldPrim/ViewPrim/Screen (clip result), mgTransZPrim (screen z), mgTransWorldPrim3DSprite,
mgDraw/DrawDirect/DrawDirect2/GetDrawRect, mgStoreImage, mgStoreZBuffImage, mgSendVuProg,
mgInitFont, mgGetTopVRAMAddress return int; mgGetDistFromCamera, mgConvZBuffToDist, mgGetProjection,
mgGetNowFrameRate return float. `@unknownret` (tail call or v0 left from a callee; no caller uses
it): mgStoreFrameImage (`j StoreImage(0)`), mgSendPacket (v0 = sceDmaSend result survives),
mgEndPacket / mgDrawDirectStart (v0 = sceVif1PkTerminate result survives), mgEndDraw(int,..) and
mgEndDrawReloadTexture (tail calls of int-returning mgCDrawManager methods).
Unused parameters: mgBeginDrawShadow/mgEndDrawShadow second texture (callers pass NULL, never
read); mgTransWorldPrim3DSprite last int ($9 never read; first game's equivalent was a fog flag).

## Enums
- mgSCREEN_MODE: GetScreenSize cases 0 512x448 (default), 1 512x416, 2 512x480, 3 640x448.
  Only caller: `mgInit(2, 3)`; second arg is sceGsResetGraph's omode (3 = PAL).
- mgVU_PROG_ID: 0/1/2 = prog_adr entries; >= 0x100 user table (callers pass 2 and 0x100).

## First game
Equivalent of the first game's mglib (`MGInit`, `MGBeginFrame`, `MGEndFrame`, `MGSetBGColor`,
`MGRotTransPers*`, `MGSetFogParm`...), renamed with `mg` prefix and with the render state moved
into the `mgRENDER_INFO` class (first game: `RenderInfo` struct, 0x350). The first game's
`MG_PICKZ` layout is identical here (4 entries instead of 16). Globals are renamed
(`Vif1Packet` -> `mgVif1Packet`, `DBuffID` -> `mgDBuffID`, `mgTEX1Env` -> `mgTEX1_1/_2`, etc.).
