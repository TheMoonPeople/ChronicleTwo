# mglib notes

Round 3 from `80c270c` promotes `mgInit` at 0/652 words and migrates all
initialized assembly data to C++. The complete object passes `0x4DA8` checked
bytes and 1,146 resolved relocations; all 148 other objects and all ten linked
file-backed sections remain byte-identical to baseline. The remaining three
C++ BSS reservations, dither alternatives, and unapplied terminal-padding
checker proposal are documented in [mglib-r3-20261008.md](mglib-r3-20261008.md).

The pinned Satan’s Fiddle baseline and current matching status are in
[matching-20261008.md](matching-20261008.md). The older isolated draft counts
below describe earlier source/compiler states.
The preceding pass from `0c33a7e`, including the retail-local `GetScreenSize`,
frame-copy scopes and nested dither-table reconstruction, is documented in
[mapmglib-midday-20261008.md](mapmglib-midday-20261008.md).

Round 1 from integration `017d119` improves the guarded `mgInit` draft to
18/652 words; its context copies and dither loops now agree. The remaining
store scheduling, initialization hygiene, packet reservation park and acceptance
receipts are documented in [mglib-r1-20261008.md](mglib-r1-20261008.md).

Round 2 from `529fb83` resolves the background/FRAME store scheduling and
retains a 0/652 guarded `mgInit` draft. Its register-cast review park is
resolved by the round-3 coordinator ruling accepting the project's existing
whole-register convention. The earlier typed-copy and intrinsic findings and
baseline validation are in [mglib-r2-20261008.md](mglib-r2-20261008.md).

The guarded frame-rotation draft uses the SDK's `sceGsDBuff::disp[2]`
array. Naming its two elements `disp1` and `disp0` prevented the whole-unit
draft compiler from running; using `disp[1]` and `disp[0]` restores that
diagnostic build without changing the matching game build.

`mgGetFrameBuffer` and `mgGetFrameBackBuffer` use native `mgCTexture` assignment and match
their 0xF8 and 0x138 retail bodies in objdiff. The matching mglib object has 0x4DB0 bytes
and 1048 resolved relocations;
`mg_texture` remains exact at 0x3674 bytes and 160 relocations. The linked build retains only
the pre-existing 0x26-byte `nd_meswin` mismatch. The narrow
`MGLIB_IMPLICIT_TEX0_ASSIGNMENT` header switch omits the custom SDK assignment operator
declaration while compiling mglib, allowing MWCC to emit its retail implicit member copy.
`mg_texture` keeps the custom operator needed by `ReloadTexture`. This gives the two translation
units different member declarations for `sceGsTex0`; the layout and generated runtime behavior
are the same, but the declaration difference is a C++ ODR concern if these are ever combined
under link-time optimization. The back-buffer function selects `draw1.frame1` when
`mgDBuffID` is nonzero, otherwise `draw0.frame1`, and replaces the copied TEX0 base with
the selected frame's FBP scaled by 32.

The global draw environment, texture manager, draw manager, two packet stacks, two data stacks,
frame texture and two fixed-Z textures are native C++ objects. Their declaration order reproduces
the compiler-generated `__sinit_mglib_cpp` call sequence, which matches the 200-byte retail
initializer. The frame texture has the genuine `mgCTexture` type. Defining it in this translation
unit changes MWCC's code generation for the two buffer-copy functions because it hoists the
symbol base instead of loading each field through a separate relocation. The scoped SDK
assignment declaration produces the retail code for both functions.

The retail `mgGetFrameBuffer` and `mgGetFrameBackBuffer` are 0xF8 and 0x138 bytes. With the
required out-of-line `sceGsTex0::operator=`, the current native `frame_tex` definition makes the
copies 0x120 and 0x168 bytes: an extra call plus stack setup. An explicit inline TEX0 value copy
reduces them to 0x100 and 0x140 bytes, leaving two extra `addiu` instructions in each. MWCC
forms `frame_tex+0x40` and `frame_tex+0x48` in registers before loading TEX1 and CLAMP, while
retail loads them directly through HI16/LO16 relocations. The out-of-line assignment symbol
`__as__9sceGsTex0FRC9sceGsTex0` (0x14 bytes) is present in retail, and
`mg_texture`'s `ReloadTexture` source calls it when copying to local `tex0`.
The m2c output shows a 16-iteration, two-character copy of `name`, followed by
scalar copies through `next`. Explicit typed member writes with that same
two-character loop compile to 0x178 bytes for `mgGetFrameBuffer`, farther from
retail than implicit assignment. Local optimization levels 1 or 2 make the
explicit-operator copies 0x12C and 0x17C bytes; level 4 retains their baseline
0x120 and 0x168 bytes. The private implicit-operator trial below resolves the
remaining TEX1/CLAMP base and copy-size differences, subject to preserving the
matched `ReloadTexture` body during the shared SDK assignment cleanup.

A private whole-unit trial removed the `sceGsTex0::operator=` declaration from
an isolated SDK-header copy and compiled the existing native drafts of both
buffer-copy functions at default inline depth. MWCC then generated the
`mgCTexture` memberwise copies without a TEX0 operator call or the two extra
TEX1/CLAMP base `addiu`s. The functions were exactly 0xF8 and 0x138 bytes, and
the fixed-up mglib object passed at 0x4DB0 bytes with 1048 relocations. ObjDiff
reported 100% for `mgGetFrameBuffer`; its 99.98718% for `mgGetFrameBackBuffer`
was only the `mgDBuffID` GP relocation being named instead of represented as
the retail numeric GP offset, which the resolved-object checker accepted. The accepted unit-local SDK declaration switch now retains this implicit
copy while preserving `ReloadTexture`; the earlier header park is resolved. The
back-buffer draft now reads `sceGsDBuff::draw0/draw1.frame1.FBP` through the
SDK type. The same source cleanup replaces the file's raw `mgDBuff` byte
declaration and clear-colour offsets with typed SDK fields. With the existing
SDK assignment and assembly fallbacks, the canonical mglib object remains
exact at 0x4DC0 bytes and 1047 relocations. With the private implicit SDK
assignment and both native copy drafts, its object remains exact at 0x4DB0
bytes and 1048 relocations.
After 16-byte function alignment, the first oversized copy moves
`mgGetFrameBackBuffer` by 0x20 bytes; the second moves `mgGetpDrawEnv` by a
further 0x30 bytes. Their cumulative unit `.text` shift is 0x50 bytes. In the linked image the
subsequent `mgCMemory` constructor and `CColFrame::Initialize` addresses were both 0x60 above
retail, which changed the constructor pointer in `__sinit_mglib_cpp` and the collision vtable
entry. Restoring the two retail gaps makes the complete mglib object pass `check_objects.py`.

MWCC emits the `.ctor` pointer to `__sinit_mglib_cpp` for the native global objects. Keeping
the dumped `D_0037AFE8__DATA` entry alongside it adds a second pointer to the linked table.
The source therefore omits that assembly placeholder; the generated entry occupies the retail
slot. The same duplicate-entry pattern appeared in 21 other game units with native globals.

## Current source status

The source has 100 exact functions and one guarded draft, `VSyncCallBack`
(its `sync`/`ei` pair has no native compiler expression). The complete object
passes `0x4D9C` checked bytes and 1,248 resolved relocations. The earlier
43-exact/31-isolated/27-differing inventory describes initial source drafting
rather than this merged state. Remaining draft measurements are in
[matching-20261008.md](matching-20261008.md).

## mgEndFrame source forms

- The BGCOLOR, SMODE2 and DISPFB environment stores are whole-register writes,
  `*(u_long *) &mgDBuff.disp[mgDBuffID].bgcolor = 0;` (the DISPLAY store already
  was). Retail reloads `mgDBuffID` and recomputes `&mgDBuff.disp[mgDBuffID]` after
  each of them; plain member stores keep the index and address in registers and
  differ by 37 words from `+0x6D8` with the body 0xA4C instead of 0xA74. PMODE
  keeps plain stores because its reload follows the antialiasing branch join. In
  the real SDK these members are `tGS_*` bitfield registers; this repository's
  `sceGsDispEnv` declares them `u_long`.
- DISPFB values are recomputed from the FRAME fields at each use, each field
  widened before shifting (`(u_long) frame->FBP | ((u_long) frame->FBW << 9) |
  ((u_long) frame->PSM << 15)`); a 32-bit local sign-extends and is reused.
- The DISPLAY prefix `(u_long) 0x290 | ((u_long) (offset_y + 72) << 12) |
  ((u_long) magnification << 23)` is written in full at the environment store and
  both GS DISPLAY writes: MWCC keeps the common left-associated prefix in `s3` as
  a CSE temporary coloured after the named locals. A named local for it takes
  `s1` (33 words).
- `magnification = mgScreenWidth == 512 ? 4 : 3;` gives `frame` in `s1` and
  `magnification` in `s2`; `if`/`else` gives 33 words.
- `offset_y = (524 - mgScreenHeight) / 2;` with `(offset_y + 72) << 12` in the
  expression reproduces the difference/quotient temporaries; adding 72 in the
  local leaves 15 words.
- The frame counter is `count++; if (count > 60 / mgFrameRate)`: the count is
  stored before the division check and reloaded in the branch delay slot.
- The depth sample is `u_int *const pixels = store_data; u_int depth = pixels[0];
  depth &= 0xFFFFFF;` over the typed `static u_int store_data[1024]`
  (`(u_long128 *) store_data` for `sceGsExecStoreImage`). The top-level `const`
  keeps the base register for the first sample and the loop, and `&=` gives the
  AND result the load's register. Indexing `store_data` directly with
  `int depth = store_data[0] & 0xFFFFFF` folds `[0]` into a direct symbol load
  (3 words at `+0x560`, two `store_data_614` relocations). This is the
  `T *const p = array` trait in `docs/MWCC.md`.
- The performance meter uses `ZMask(MG_Z_MASK_MASKED)` and `Begin(MG_PRIM_SPRITE)`;
  the `timer0_count - h_count` differences are already `u_int`.
- The function-local statics `count`, `cpu_ratio`, `free_ratio` (with MWCC's
  initialization guards) and `store_data` are native; `INCLUDE_BSS` reservations
  at their retail `.sbss`/`.bss` positions (`count_580` … `init_587`,
  `store_data_614`, like `image_num_1535`/`init_1536` for `StoreImage`) are
  bound by the postprocessor by base name and extent, each guard spanning its
  byte and the following alignment padding. `store_data_614` stays global for
  the library-data reference in `e_rem_pio2`.

## mgSetPkFrameBuffer source forms

- The packet count is the pointer difference
  `sceVif1PkReserve(vif, (u_int *) &registers[12] - packet)` over the
  `(u_long *) &packet[8]` register view: MWCC emits retail's `addiu +0x20`,
  `addiu +0x60`, `subu`, `sra 2` with the `bgez`/`addiu 3` rounding correction.
  The constant `32` leaves the packet window six words short (251/424).
- FRAME is read as a whole register, `*(u_long *) &frame`, like XYOFFSET and
  SCISSOR, materializing the stack address before the `ld`; `frame.value` loads
  it directly and differs by 50 words from `+0x31C`. The real SDK `sceGsFrame`
  has no `value` member.
- `case SCE_GS_PSMCT16:` and `case SCE_GS_PSMCT16S:` are separate blocks that
  both set `bpp = 16` (`int`); a shared fallthrough body differs by 46 words
  from `+0x36C`.
- Both shift counters are cleared before the first log2 loop
  (`width_shift = 0; height_shift = 0;`); clearing `height_shift` at its own
  loop differs by 24 words from `+0x450`.
- The log2 loops are `for (size = width; size > 1; size >>= 1)`: the entry test
  fuses into the branch with the `size = width` copy in its delay slot.
- The frame texture's TEX1 is `SCE_GS_SET_TEX1(1, 0, 1, 1, 1, 0, 0)` (0x261), as
  `mg_texture.cpp` writes the same register.

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

Round 3 restores these private globals as typed file statics. The stable
`dimx_281` file-static table replaces the compiler-ordinal local spelling.
`store_data_614` retains external linkage because an existing generated
library-data expression references that symbol. `gs_simage` and the
function-local static reservations are `INCLUDE_BSS` markers bound to the
native objects by the postprocessor.

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

## VSyncCallBack draft
The guarded C++ draft samples GS CSR bit 13, stores the inverse in `VSyncField`, calls an installed secondary callback, increments the non-negative frame counter and clears the active flag. Retail ends with `sync; ei`, which MWCC does not emit from this C++ representation; the retail assembly remains active.

## Frame-end buffer alignment and symbol extent

`mgEndFrame__FP14mgCDrawManager` has retail symbol size `0xA74`; `0xA80`
is its padded section extent. Its 1024-word `store_data` DMA readback buffer
requires 16-byte alignment, matching the quadword pointer accepted by
`sceGsExecStoreImage`; the `store_data_614` marker supplies the exported
identity required by library data.

## Typed access

- `mgWaitFrame`, `mgDrawDirect(mgCVisual *, ...)` and `mgDrawDirect2` use
  `mgVif1Packet->pCurrent`; `mgDrawDirect2` passes `pCurrent + ddraw_size * 4`.
- `*(u_long *) &reg` GS register views and `*(u_long128 *) &mgGiftagAD` SDK
  quadword arguments are the accepted conventions; `*(volatile u_int *)
  timer0_count`, `*(volatile u_long *) gs_pmode` and the other `static const
  u_int` addresses are memory-mapped register accesses.
- `mgFlushRenderInfo` writes the fog floats into VIF packet words as
  `words[n] = *(u_int *) &mgRenderInfo.fog.x`.
- `CheckVuProgID` (`global_optimizer off`) keeps `*(int *) ((id << 2) +
  (int) user_prog_adr - user_vu_prog_base * 4)`: `user_prog_adr[id -
  user_vu_prog_base]` subtracts before scaling and
  `(&user_prog_adr[id])[-user_vu_prog_base]` shortens the function.
- `mgGetFogParam` copies the four colour bytes as one word through
  `mgFogColor` views.
