#define MGLIB_IMPLICIT_TEX0_ASSIGNMENT
#include "common.h"
#include "mw_runtime.h"

#include <eekernel.h>
#include <libdev.h>
#include <sifdev.h>

#include <cstdio>
#include <cstring>

#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_tanime.hpp"
#include "mg_texture.hpp"
#include "mg_visual.hpp"
#include "mglib.hpp"

mgRENDER_INFO     mgRenderInfo;
mgCTextureManager mgTexManager;
mgCDrawManager    mgDrawManager;

/**
 *
 * Packet-memory stacks alternated between frames.
 *
 */
static mgCMemory packet_buf[2];

/**
 *
 * Draw-data stacks alternated between frames.
 *
 */
static mgCMemory data_buf[2];

/**
 *
 * Texture description of the current frame buffer.
 *
 */
static mgCTexture frame_tex;

/**
 *
 * Texture descriptions laid over the depth buffer.
 *
 */
static mgCTexture fixz_tex[2];

/**
 *
 * Controls drawing of the frame performance meter.
 *
 */
static int draw_performance_meter;

/**
 *
 * Non-zero while the vertical-sync callback runs.
 *
 */
static int call_back_active;

/**
 *
 * Optional secondary callback invoked at vertical sync.
 *
 */
static int (*VSyncCallBack2)(int);

/**
 *
 * Vertical-sync count since graphics initialization.
 *
 */
static int vcount;

/**
 *
 * Ready-queue priority rotated while waiting for vertical sync.
 *
 */
static int rot_priority = -1;

/**
 *
 * Word buffers used by the two VIF1 packet cursors.
 *
 */
static u_int *packetbuf[2];

/**
 *
 * Packet cursors alternated between frames.
 *
 */
static sceVif1Packet vifpacket[2];

/**
 *
 * Capacity of each VIF1 packet buffer.
 *
 */
static int packet_size;

/**
 *
 * Index of the packet and data buffers used by the current frame.
 *
 */
static int mgDataID;

/**
 *
 * Index of the display environment used by the current frame.
 *
 */
static int mgDBuffID;

/**
 *
 * Root-counter value sampled when frame drawing begins.
 *
 */
static int h_count;

/**
 *
 * Non-zero when lighting changes require the render state to be flushed.
 *
 */
static int mgChangeLight;

/**
 *
 * Identifier of the last VU1 microprogram packet submitted.
 *
 */
static int now_prog_id = -1;

/**
 *
 * Upload packets for the built-in VU1 microprograms.
 *
 */
static u_long128 *prog_adr[3] = {Vu_prog0, Vu_prog_sdw, Vu_prog_3dsp};

/**
 *
 * Table of user-provided VU1 microprogram upload packets.
 *
 */
static u_long128 **user_prog_adr;

/**
 *
 * Number of entries in the user VU1 microprogram table.
 *
 */
static int user_prog_num;

/**
 *
 * Development-console handle, or -1 while it is closed.
 *
 */
static int font_cons = -1;

/**
 *
 * Non-zero when the development console should be drawn at frame end.
 *
 */
static int font_draw_flag;

/**
 *
 * Vertical-sync count saved at the end of the previous frame.
 *
 */
static int old_vcount;

/**
 *
 * Non-zero when the frame exceeds its requested vertical-sync interval.
 *
 */
static int over_vsync;

/**
 *
 * Requests a frame capture at the next frame end.
 *
 */
static int capture_on;

/**
 *
 * Frame-capture cadence counter used at the fastest frame rate.
 *
 */
static int cap_ture_cnt;

/**
 *
 * Base page of the first frame buffer in GS memory.
 *
 */
static int frame_buf0;

/**
 *
 * Base page of the second frame buffer in GS memory.
 *
 */
static int frame_buf1;

/**
 *
 * Packed GS dither matrix presets.
 *
 */
static sceGsDimx mgDIMX[1];

/**
 *
 * Zero vector used to initialize the temporary background colour.
 *
 */
static sceVu0FVECTOR at_863;

/**
 *
 * TIMER0 count register sampled for frame timing.
 *
 */
static const u_int timer0_count = 0x10000000;
/**
 *
 * TIMER0 mode register controlling the frame timer clock and counter enable.
 *
 */
static const u_int timer0_mode = 0x10000010;
/**
 *
 * GS status register sampled for the displayed interlace field.
 *
 */
static const u_int gs_csr = 0x12001000;
/**
 *
 * GS PMODE register selecting and blending the display read circuits.
 *
 */
static const u_int gs_pmode = 0x12000000;
/**
 *
 * GS DISPFB1 register addressing the frame buffer of read circuit 1.
 *
 */
static const u_int gs_dispfb1 = 0x12000070;
/**
 *
 * GS DISPLAY1 register positioning the display area of read circuit 1.
 *
 */
static const u_int gs_display1 = 0x12000080;
/**
 *
 * GS DISPFB2 register addressing the frame buffer of read circuit 2.
 *
 */
static const u_int gs_dispfb2 = 0x12000090;
/**
 *
 * GS DISPLAY2 register positioning the display area of read circuit 2.
 *
 */
static const u_int gs_display2 = 0x120000A0;
/**
 *
 * DMA CALL tag linking a VU1 microprogram upload packet.
 *
 */
static const u_int dma_tag_call = 0x50000000;
/**
 *
 * Number of built-in VU1 microprogram upload packets.
 *
 */
static const int builtin_vu_prog_count = 3;
/**
 *
 * First identifier in the user VU1 microprogram table.
 *
 */
static const int user_vu_prog_base = 0x100;

/**
 *
 * GS register addresses used by direct drawing packets.
 *
 */
enum {
    gs_prim = 0x00,
    gs_rgbaq = 0x01,
    gs_xyzf2 = 0x04,
    gs_clamp1 = 0x08,
    gs_tex1_1 = 0x14,
    gs_scanmsk = 0x22,
    gs_texflush = 0x3F,
    gs_alpha1 = 0x42,
    gs_test1 = 0x47,
    gs_zbuf1 = 0x4E
};

/**
 *
 * DMA channel identifiers used by the graphics library.
 *
 */
enum mgDMA_CHANNEL {
    MG_DMA_CHANNEL_VIF1 = 1,     /**< VIF1 DMA channel for drawing and microprogram uploads. */
    MG_DMA_CHANNEL_GIF = 2,      /**< GIF DMA channel for GS transfers. */
    MG_DMA_CHANNEL_FROM_SPR = 8, /**< DMA channel transferring data from scratchpad memory. */
};

void StoreImage(int front_buffer);
int  VSyncCallBack(int field);

/**
 *
 * Dither presets converted to signed three-bit GS coefficients.
 *
 */
static signed char dimx_281[1][16] = {
    {10, 4, 6, 8, 12, 0, 2, 14, 7, 9, 11, 5, 3, 15, 13, 1}
};

// Code (.text)
void mgPerformanceMeter(int enable) {
    draw_performance_meter = enable;
}

int mgGetPerformanceMeterFlag() {
    return draw_performance_meter;
}

#pragma global_optimizer off

/**
 *
 * Updates the displayed interlace field and vertical-sync count and invokes the secondary callback.
 *
 * @mangled VSyncCallBack__Fi
 * @address 0x141870
 * @size 0x7C
 *
 */
int VSyncCallBack(int field) {
    call_back_active = 1;
    u_long csr = *(volatile u_long *) gs_csr;
    VSyncField = !((csr >> 13) & 1);

    if (VSyncCallBack2 != 0) {
        VSyncCallBack2(field);
    }

    ++vcount;

    if (vcount < 0) {
        vcount = 0;
    }

    call_back_active = 0;

    asm {
        sync
        ei
    }

    return 0;
}

#pragma global_optimizer reset

void mgInitVSyncCallBack(int (*callback)(int)) {
    VSyncCallBack2 = callback;
}

void mgSetRotateThread(int priority) {
    rot_priority = priority;
}

/**
 *
 * Waits for the requested vertical-sync interval while rotating the selected ready queue.
 *
 * @mangled WaitVSync__Fii
 * @address 0x141910
 * @size 0x64
 *
 */
void WaitVSync(int start, int frames) {
wait:
    if ((mgGetVSyncCount() - start) < frames) {
        if (rot_priority > 0) {
            RotateThreadReadyQueue(rot_priority);
        }

        goto wait;
    }
}

int mgGetVSyncCount() {
    return vcount;
}

/**
 *
 * Returns the normalized screen mode and its dimensions and centered bounds.
 *
 * @mangled GetScreenSize__FiPiPiPiPiPiPi
 * @address 0x141990
 * @size 0xC0
 *
 */
static int GetScreenSize(int mode, int *width, int *height, int *left, int *top, int *right, int *bottom) {
    switch (mode) {
        case MG_SCREEN_MODE_640X448:
            *width = 0x280;
            *height = 0x1C0;
            break;
        case MG_SCREEN_MODE_512X480:
            *width = 0x200;
            *height = 0x1E0;
            break;
        case MG_SCREEN_MODE_512X416:
            *width = 0x200;
            *height = 0x1A0;
            break;
        case MG_SCREEN_MODE_512X448:
        default:
            mode = MG_SCREEN_MODE_512X448;
            *width = 0x200;
            *height = 0x1C0;
            break;
    }

    *left = -(*width >> 1);
    *top = -(*height >> 1);
    *right = *width + *left;
    *bottom = *height + *top;
    return mode;
}

void mgInit(int screen_mode, int video_mode) {
    sceDmaEnv      dma_env;
    u_long128      clear_pixels[8192];
    sceGsLoadImage load_image;
    int            aligned_height;
    int            buffer;
    int            i;

    font_cons = -1;
    font_draw_flag = 0;
    mgChangeLight = 1;
    sceDmaReset(1);
    sceDmaGetEnv(&dma_env);
    dma_env.notify = 0x100;
    sceDmaPutEnv(&dma_env);
    sceGsResetPath();
    mgAntialiasing = 1;
    mgDBuffID = 0;
    mgDataID = 0;
    memset(&mgRenderInfo, 0, sizeof(mgRenderInfo));
    mgVif1Packet = vifpacket;
    DmaCH1 = sceDmaGetChan(MG_DMA_CHANNEL_VIF1);
    DmaCH2 = sceDmaGetChan(MG_DMA_CHANNEL_GIF);
    DmaCH8 = sceDmaGetChan(MG_DMA_CHANNEL_FROM_SPR);
    DmaCH1->chcr.TTE = 1;
    *(u_long128 *) &mgGiftagAD = 0;
    mgGiftagAD.EOP = 1;
    mgGiftagAD.NREG = 1;
    mgGiftagAD.REGS0 = SCE_GIF_PACKED_AD;
    mgScreenMode = GetScreenSize(screen_mode, &mgScreenWidth, &mgScreenHeight, &mgScreenNX, &mgScreenNY, &mgScreenMX, &mgScreenMY);
    aligned_height = mgScreenHeight;

    if (mgScreenHeight % 32 != 0) {
        aligned_height += 32 - aligned_height % 32;
    }

    mgScreenOffx = 0x800 - mgScreenWidth / 2;
    mgScreenOffy = 0x800 - mgScreenHeight / 2;
    mgScreenLeft = mgScreenOffx;
    mgScreenRight = mgScreenOffx + mgScreenWidth;
    mgScreenTop = mgScreenOffy;
    mgScreenBottom = mgScreenOffy + mgScreenHeight;
    mgScreenDepth = 32;
    mgScreenZDepth = 32;
    sceGsResetGraph(0, SCE_GS_INTERLACE, video_mode, 0);

    for (i = 0; i < 8192; i++) {
        clear_pixels[i] = 0;
    }

    for (buffer = 0; buffer < 32; buffer++) {
        sceGsSetDefLoadImage(&load_image, buffer * 0x200, 2, SCE_GS_PSMCT32, 0, 0, 128, 256);
        FlushCache(0);
        sceGsExecLoadImage(&load_image, clear_pixels);
    }

    sceGsSetDefDBuff(&mgDBuff, SCE_GS_PSMCT32, (short) mgScreenWidth, (short) mgScreenHeight, SCE_GS_ZGEQUAL, SCE_GS_PSMZ24, 0);
    frame_buf0 = 0;
    frame_buf1 = mgScreenDepth * (mgScreenWidth * aligned_height / 2048) / 32;
    mgBackColor[0] = 0.0f;
    mgDBuff.draw0.frame1.FBP = frame_buf1;
    mgBackColor[1] = 0.0f;
    mgBackColor[2] = 0.0f;
    mgDBuff.draw1.frame1.FBP = frame_buf0;
    mgBackColor[3] = 128.0f;
    mgClearBackFlag = 1;
    mgDBuff.draw0.zbuf1.bits.zbp = mgDBuff.draw1.zbuf1.bits.zbp = frame_buf1 * 2;
    mgDBuff.clear0.rgbaq.bytes.red = (int) mgBackColor[0];
    mgDBuff.clear0.rgbaq.bytes.green = (int) mgBackColor[1];
    mgDBuff.clear0.rgbaq.bytes.blue = (int) mgBackColor[2];
    mgDBuff.clear0.rgbaq.bytes.alpha = (int) mgBackColor[3];
    mgDBuff.clear1.rgbaq.bytes.red = (int) mgBackColor[0];
    mgDBuff.clear1.rgbaq.bytes.green = (int) mgBackColor[1];
    mgDBuff.clear1.rgbaq.bytes.blue = (int) mgBackColor[2];
    mgDBuff.clear1.rgbaq.bytes.alpha = (int) mgBackColor[3];
    *(u_long *) &mgTEX1_1 = 0x261;
    mgTEX1_2 = mgTEX1_1;
    *(u_long *) &mgTEST_1 = 0x5000B;
    mgTEST_2 = mgTEST_1;
    mgZBUF_1 = mgZBUF_2 = mgDBuff.draw0.zbuf1;
    *(u_long *) &mgALPHA_1 = 0x44;
    mgALPHA_2 = mgALPHA_1;
    *(u_long *) &mgTEXA_1 = 0x100400000ULL;
    mgTEXA_2 = mgTEXA_1;
    mgDrawManager.texture_manager = &mgTexManager;
    mgDrawManager.render_info = &mgRenderInfo;
    mgRenderInfo.Initialize();
    sceGsZbuf first_zbuf(mgZBUF_1);
    mgRenderInfo.draw_env[0].zbuf = first_zbuf;
    sceGsZbuf second_zbuf(mgZBUF_2);
    mgRenderInfo.draw_env[1].zbuf = second_zbuf;
    FlushCache(0);
    sceDmaSend(DmaCH1, My_dma_start0);
    sceGsSyncPath(0, 0);
    FlushCache(0);
    sceDmaSend(DmaCH1, Vu_progmain);
    sceGsSyncPath(0, 0);
    {
        u_long128 *program = mgGetVuProgPacket(MG_VU_PROG_MAIN);

        FlushCache(0);
        sceDmaSend(DmaCH1, program);
        sceGsSyncPath(0, 0);
    }
    *(volatile u_int *) timer0_mode = 0x83;
    mgFrameRate = 2;
    vcount = 0;
    over_vsync = 0;
    sceGsSyncVCallback(VSyncCallBack);
    VSyncCallBack2 = 0;
    call_back_active = 0;
    FlushCache(0);
    sceGsSwapDBuff(&mgDBuff, 0);
    sceDmaSync(DmaCH2, 0, 0);
    mgCreateSinTable();

    for (int preset = 0; preset < 1; preset++) {
        for (int cell = 0; cell < 16; cell++) {
            dimx_281[preset][cell] = dimx_281[preset][cell] / 2 - 4;
        }
    }

    for (int preset = 0; preset < 1; preset++) {
        u_long packed_dimx = 0;

        for (int cell = 0; cell < 16; cell++) {
            // The shift uses 32 bits, so cells 8-15 wrap onto the low word.
            packed_dimx |= (dimx_281[preset][cell] & 0x7) << (cell * 4);
        }

        mgDIMX[preset].value = packed_dimx;
    }

    mgDIMX[0].bits.dm00 = dimx_281[0][0];
    mgDIMX[0].bits.dm01 = dimx_281[0][1];
    mgDIMX[0].bits.dm02 = dimx_281[0][2];
    mgDIMX[0].bits.dm03 = dimx_281[0][3];
    mgDIMX[0].bits.dm10 = dimx_281[0][4];
    mgDIMX[0].bits.dm11 = dimx_281[0][5];
    mgDIMX[0].bits.dm12 = dimx_281[0][6];
    mgDIMX[0].bits.dm13 = dimx_281[0][7];
    mgDIMX[0].bits.dm20 = dimx_281[0][8];
    mgDIMX[0].bits.dm21 = dimx_281[0][9];
    mgDIMX[0].bits.dm22 = dimx_281[0][10];
    mgDIMX[0].bits.dm23 = dimx_281[0][11];
    mgDIMX[0].bits.dm30 = dimx_281[0][12];
    mgDIMX[0].bits.dm31 = dimx_281[0][13];
    mgDIMX[0].bits.dm32 = dimx_281[0][14];
    mgDIMX[0].bits.dm33 = dimx_281[0][15];
}

void mgInitVif1Packet(u_long128 *buffer_a, u_long128 *buffer_b, int size) {
    packetbuf[0] = (u_int *) buffer_a;
    packetbuf[1] = (u_int *) buffer_b;
    int misalign = (int) packetbuf[0] % 4;

    if (misalign != 0) {
        packetbuf[0] += 4 - misalign;
    }

    misalign = (int) packetbuf[1] % 4;

    if (misalign != 0) {
        packetbuf[1] += 4 - misalign;
    }

    sceVif1PkInit(vifpacket, packetbuf[0]);
    sceVif1PkInit(vifpacket + 1, packetbuf[1]);
    sceVif1PkReset(vifpacket);
    sceVif1PkReset(vifpacket + 1);
    packet_size = size;
}

void mgSetPacketBuffer(mgCMemory *pool_a, mgCMemory *pool_b) {
    packet_buf[0] = *pool_a;
    packet_buf[1] = *pool_b;
    packet_buf[0].stack_used = 0;
    packet_buf[0].lock = 0;
    packet_buf[1].stack_used = 0;
    packet_buf[1].lock = 0;
}

void mgSetDataBuffer(mgCMemory *pool_a, mgCMemory *pool_b, int skip_header) {
    u_char *base = (u_char *) pool_a->stAllocTest(1);
    int     size = pool_a->stack_size - pool_a->stack_used;

    if (skip_header != 0) {
        base += 0x4000;
        size -= 0x800;
    }

    data_buf[0].stSetBuffer((u_long128 *) base, size);
    base = (u_char *) pool_b->stAllocTest(1);
    size = pool_b->stack_size - pool_b->stack_used;

    if (skip_header != 0) {
        base += 0x4000;
        size -= 0x800;
    }

    data_buf[1].stSetBuffer((u_long128 *) base, size);
    data_buf[0].stack_used = 0;
    data_buf[0].lock = 0;
    data_buf[1].stack_used = 0;
    data_buf[1].lock = 0;
}

mgCMemory *mgGetDataBuffer() {
    return &data_buf[mgDataID];
}

int mgGetTopVRAMAddress() {
    int height = mgScreenHeight;

    if (height % 32 != 0) {
        height += 32 - height % 32;
    }

    height = mgScreenWidth * height;
    int blocks = mgScreenDepth * height * 2 / 256 / 8;
    blocks += mgScreenZDepth * height / 256 / 8;
    return blocks;
}

float mgGetNowFrameRate() {
    return (float) mgFrameRate;
}

void mgBeginFrame(mgCDrawManager *manager) {
    if (manager == NULL) {
        mgDrawManager.texture_manager = &mgTexManager;
        manager = &mgDrawManager;
        mgDrawManager.render_info = &mgRenderInfo;
    }

    *(int *) timer0_count = 0;
    h_count = *(int *) timer0_count;

    int red = fptosi(mgBackColor[0]);
    mgDBuff.clear0.rgbaq.bytes.red = red;
    int green = fptosi(mgBackColor[1]);
    mgDBuff.clear0.rgbaq.bytes.green = green;
    int blue = fptosi(mgBackColor[2]);
    mgDBuff.clear0.rgbaq.bytes.blue = blue;
    int alpha = fptosi(mgBackColor[3]);
    mgDBuff.clear1.rgbaq.bytes.red = red;
    mgDBuff.clear1.rgbaq.bytes.green = green;
    mgDBuff.clear1.rgbaq.bytes.blue = blue;
    mgDBuff.clear0.rgbaq.bytes.alpha = alpha;
    mgDBuff.clear1.rgbaq.bytes.alpha = alpha;
    mgBeginPacket(manager);
    *(u_long128 *) &mgGiftagAD = 0;
    mgGiftagAD.EOP = 1;
    mgGiftagAD.NREG = 1;
    mgGiftagAD.REGS0 = 0xE;
    sceVif1PkCnt(mgVif1Packet, 0);
    sceVif1PkOpenDirectCode(mgVif1Packet, 0);
    sceVif1PkOpenGifTag(mgVif1Packet, *(u_long128 *) &mgGiftagAD);
    sceVif1PkAddGsAD(mgVif1Packet, gs_scanmsk, 0);
    sceVif1PkAddGsAD(mgVif1Packet, gs_texflush, 0);
    sceVif1PkCloseGifTag(mgVif1Packet);
    sceVif1PkCloseDirectCode(mgVif1Packet);
    mgSetPkTextureRepeat(1);
    sceGsFrame *draw_env;

    if (mgDBuffID != 0) {
        draw_env = &mgDBuff.draw0.frame1;
    } else {
        draw_env = &mgDBuff.draw1.frame1;
    }

    mgFRAME_1.value = draw_env->value;
    mgSetPkFrameBuffer(-1, -1, -1, -1);
    mgSetPkClearScreen(
        mgDBuff.clear0.rgbaq.bytes.red, mgDBuff.clear0.rgbaq.bytes.green,
        mgDBuff.clear0.rgbaq.bytes.blue, mgDBuff.clear0.rgbaq.bytes.alpha);
    mgFlushRenderInfo();
}

void mgBeginPacket(mgCDrawManager *manager) {
    mgCMemory *buffer;

    if (manager == NULL) {
        manager = &mgDrawManager;
    }

    mgVif1Packet = &vifpacket[mgDataID];
    sceVif1PkReset(mgVif1Packet);
    buffer = &packet_buf[mgDataID];
    buffer->stack_used = 0;
    buffer->lock = 0;
    buffer = &data_buf[mgDataID];
    buffer->stack_used = 0;
    buffer->lock = 0;
    manager->packet_memory = &packet_buf[mgDataID];
    manager->data_memory = &data_buf[mgDataID];
    manager->SetSortTable(1);
}

void mgBeginDraw(mgCMemory *memory, int *draw_size, mgCDrawManager *manager) {
    mgCDrawManager *mgr = manager;

    if (mgr == NULL) {
        mgr = &mgDrawManager;
    }

    mgr->BeginDraw(memory, draw_size);
}

void mgEndDraw(mgCDrawManager *manager) {
    if (manager == NULL) {
        manager = &mgDrawManager;
    }

    manager->EndDraw(mgVif1Packet);
}

void mgPreEndDraw(mgCDrawManager *manager) {
    if (manager == NULL) {
        manager = &mgDrawManager;
    }

    manager->PreEndDraw();
}

int mgEndDrawReloadTexture(int texture, mgCDrawManager *manager) {
    if (manager == NULL) {
        manager = &mgDrawManager;
    }

    return manager->ReloadTexture(texture, mgVif1Packet);
}

void mgEndDraw(int mode, mgCDrawManager *manager) {
    if (manager == NULL) {
        manager = &mgDrawManager;
    }

    manager->Draw(mode, mgVif1Packet);
}

void mgStoreFrameImage() {
    StoreImage(0);
}

void mgEndFrame(mgCDrawManager *manager) {
    float        frame_ticks = (float) (mgFrameRate * 262);
    static int   count = 1;
    static float cpu_ratio = 0.0f;
    static float free_ratio = 0.0f;
    static u_int store_data[1024] __attribute__((aligned(16)));
    sceGsFrame  *frame;
    float        packet_free;
    float        data_free;
    int          wait_start;
    int          sample;
    int          top;
    int          magnification;
    int          offset_y;

    cpu_ratio = 100.0f * ((*(volatile u_int *) timer0_count - h_count) / frame_ticks);
    mgWaitFrame();
    wait_start = *(volatile u_int *) timer0_count;

    if (draw_performance_meter != 0) {
        packet_free = 100.0f * (float) (mgDrawManager.packet_memory->stack_size - mgDrawManager.packet_memory->stack_used) / (float) mgDrawManager.packet_memory->stack_size;
        data_free = 100.0f * (float) (mgDrawManager.data_memory->stack_size - mgDrawManager.data_memory->stack_used) / (float) mgDrawManager.data_memory->stack_size;

        mgCDrawPrim prim;

        prim.Initialize(NULL, NULL);
        prim.DepthTestEnable(0);
        prim.TextureMapEnable(0);
        prim.AlphaBlendEnable(1);
        prim.ZMask(MG_Z_MASK_MASKED);
        prim.Begin(MG_PRIM_SPRITE);
        prim.Color(128, 128, 128, 128);
        top = mgScreenHeight - 40;

        if (free_ratio <= 0.0f) {
            prim.Color(255, 0, 0, 64);
        } else {
            prim.Color(128, 128, 128, 64);
        }

        prim.Vertex(mgScreenWidth, top, 0);
        prim.Vertex(mgScreenWidth - 100, top + 8, 0);
        prim.Vertex(mgScreenWidth, top + 12, 0);
        prim.Vertex(mgScreenWidth - 100, top + 16, 0);

        if (!(cpu_ratio <= 100.0f)) {
            prim.Color(255, 0, 0, 64);
        } else if (!(cpu_ratio <= 50.0f)) {
            prim.Color(0, 64, 64, 64);
        } else {
            prim.Color(0, 0, 128, 64);
        }

        prim.Vertex(mgScreenWidth, top, 0);
        prim.Vertex((float) mgScreenWidth - cpu_ratio, (float) (top + 8), 0.0f);
        prim.Vertex((float) mgScreenWidth - (100.0f - free_ratio), (float) (top + 12), 0.0f);
        prim.Vertex(mgScreenWidth - 100, top + 16, 0);
        prim.Color(0, 128, 0, 64);
        prim.Vertex(mgScreenWidth, top + 20, 0);
        prim.Vertex((float) mgScreenWidth - packet_free, (float) (top + 24), 0.0f);
        prim.Vertex(mgScreenWidth, top + 28, 0);
        prim.Vertex((float) mgScreenWidth - data_free, (float) (top + 32), 0.0f);
        prim.End();
    }

    mgEndPacket(NULL);

    for (sample = 0; sample < 4; sample++) {
        if (mgPickZBuff[sample].enable != 0) {
            if (mgPickZBuff[sample].x < 4 || mgScreenWidth - 4 < mgPickZBuff[sample].x) {
                mgPickZBuff[sample].z = -1;
            } else if (mgPickZBuff[sample].y < 4 || mgScreenHeight - 4 < mgPickZBuff[sample].y) {
                mgPickZBuff[sample].z = -1;
            } else {
                sceGsStoreImage store_image;
                sceGsSetDefStoreImage(&store_image, mgZBUF_1.bits.zbp * 2048 / 64, mgScreenWidth / 64, SCE_GS_PSMZ32, mgPickZBuff[sample].x - 4, mgPickZBuff[sample].y - 4, 8, 8);
                FlushCache(0);
                sceGsExecStoreImage(&store_image, (u_long128 *) store_data);
                sceGsSyncPath(0, 0);
                u_int *const pixels = store_data;
                u_int        depth = pixels[0];
                depth &= 0xFFFFFF;

                for (int pixel = 0; pixel < 64; pixel++) {
                    if ((int) (pixels[pixel] & 0xFFFFFF) < (int) depth) {
                        depth = pixels[pixel] & 0xFFFFFF;
                    }
                }

                mgPickZBuff[sample].z = depth;
            }
        }
    }

    over_vsync = 0;

    if (vcount - old_vcount >= mgFrameRate) {
        over_vsync = 1;
    }

    WaitVSync(old_vcount, mgFrameRate);
    old_vcount = vcount;

    if (capture_on != 0) {
        if (mgFrameRate == 1) {
            if (cap_ture_cnt % 2 != 0) {
                StoreImage(0);
            }
        } else {
            StoreImage(0);
        }

        cap_ture_cnt++;
    }

    capture_on = 0;

    if (font_draw_flag != 0 && font_cons >= 0) {
        if (font_cons >= 0) {
            sceDevConsAttribute(font_cons, 7);
        }

        sceDevConsDraw(font_cons);
    }

    font_draw_flag = 0;

    if (mgAntialiasing != 0) {
        mgDBuff.disp[mgDBuffID].pmode = 0x7F23;
    } else {
        *(volatile u_long *) gs_pmode = 0xFF23;
        mgDBuff.disp[mgDBuffID].pmode = 0xFF23;
    }

    *(u_long *) &mgDBuff.disp[mgDBuffID].bgcolor = 0;
    *(u_long *) &mgDBuff.disp[mgDBuffID].smode2 = 1;
    frame = mgDBuffID != 0 ? &mgDBuff.draw1.frame1 : &mgDBuff.draw0.frame1;
    magnification = mgScreenWidth == 512 ? 4 : 3;
    offset_y = (524 - mgScreenHeight) / 2;
    *(u_long *) &mgDBuff.disp[mgDBuffID].dispfb = (u_long) frame->FBP | ((u_long) frame->FBW << 9) | ((u_long) frame->PSM << 15);
    *(u_long *) &mgDBuff.disp[mgDBuffID].display = (u_long) 0x290 | ((u_long) (offset_y + 72) << 12) | ((u_long) magnification << 23) | ((u_long) (mgScreenWidth * (magnification + 1) - 1) << 32) | ((u_long) (mgScreenHeight - 1) << 44);
    FlushCache(0);
    sceGsSwapDBuff(&mgDBuff, mgDBuffID);
    sceDmaSync(DmaCH2, 0, 0);
    *(volatile u_long *) gs_dispfb1 = (u_long) frame->FBP | ((u_long) frame->FBW << 9) | ((u_long) frame->PSM << 15) | ((u_long) 1 << 43);
    *(volatile u_long *) gs_display1 = (u_long) 0x290 | ((u_long) (offset_y + 72) << 12) | ((u_long) magnification << 23) | ((u_long) (mgScreenWidth * (magnification + 1) - 1) << 32) | ((u_long) (mgScreenHeight - 2) << 44);
    *(volatile u_long *) gs_dispfb2 = (u_long) frame->FBP | ((u_long) frame->FBW << 9) | ((u_long) frame->PSM << 15);
    *(volatile u_long *) gs_display2 = (u_long) 0x290 | ((u_long) (offset_y + 72) << 12) | ((u_long) magnification << 23) | ((u_long) (mgScreenWidth * (magnification + 1) - 1) << 32) | ((u_long) (mgScreenHeight - 2) << 44);
    mgNowFrameRate = (*(volatile u_int *) timer0_count - h_count) / 262.0f;

    if (!(mgNowFrameRate - (float) mgFrameRate <= 1.0f)) {
        free_ratio = 0.0f;
        mgNowFrameRate = 1.0f + (float) mgFrameRate;
    } else {
        free_ratio = 100.0f * ((*(volatile u_int *) timer0_count - wait_start) / frame_ticks);
    }

    count++;

    if (count > 60 / mgFrameRate) {
        count = 0;
    }

    mgSendPacket(NULL);
    mgDBuffID = !mgDBuffID;
}

void mgSendPacket(mgCDrawManager *manager) {
    DmaCH1 = sceDmaGetChan(MG_DMA_CHANNEL_VIF1);
    DmaCH1->chcr.TTE = 1;
    FlushCache(0);
    sceDmaSend(DmaCH1, mgVif1Packet->pBase);
    mgDataID = !mgDataID;
}

void mgEndPacket(mgCDrawManager *manager) {
    sceVif1PkEnd(mgVif1Packet, 0);
    sceVif1PkTerminate(mgVif1Packet);
}

void mgWaitFrame() {
    if (sceGsSyncPath(0, 0) < 0) {
        printf("******\n");
        printf("base = %x,cuur = %x\n", mgVif1Packet->pCurrent);
        Exit__2(-1);
    }
}

int mgDraw(mgCFrame *frame) {
    if (frame != NULL) {
        return frame->Draw();
    }

    return 0;
}

int mgDrawDirect(mgCFrame *frame) {
    if (frame == NULL) {
        return 0;
    }

    sceVif1PkTerminate(mgVif1Packet);
    int size = frame->Draw(mgVif1Packet->pCurrent);
    sceVif1PkReserve(mgVif1Packet, size * 4);
    return size;
}

int mgDrawDirect(mgCVisual *visual, float (*matrix)[4]) {
    if (visual == NULL) {
        return 0;
    }

    sceVif1PkTerminate(mgVif1Packet);
    int size = visual->Draw(mgVif1Packet->pCurrent, matrix, 0);
    sceVif1PkReserve(mgVif1Packet, size * 4);
    return size;
}

void mgDrawDirectStart() {
    sceVif1PkTerminate(mgVif1Packet);
    ddraw_size = 0;
}

int mgDrawDirect2(mgCFrame *frame) {
    if (frame == NULL) {
        return 0;
    }

    int size = frame->Draw(mgVif1Packet->pCurrent + ddraw_size * 4);
    ddraw_size += size;
    return size;
}

void mgDrawDirectEnd() {
    if (ddraw_size > 0) {
        sceVif1PkReserve(mgVif1Packet, ddraw_size * 4);
    }
}

int mgGetDrawRect(mgCFrame *frame, mgVu0FBOX *box) {
    if (frame != NULL) {
        return frame->GetDrawRect(box, NULL);
    }

    return 0;
}

void mgBeginDrawShadow(mgCTexture *shadow, mgCTexture *unused) {
    if (shadow != NULL) {
        int width = shadow->width;
        int height = shadow->height;

        if (width % 64 != 0) {
            width += 64 - width % 64;
        }

        if (height % 64 != 0) {
            height += 64 - height % 64;
        }

        mgSetPkFrameBuffer(shadow->tex0.TBP0 / 32, width, height, shadow->tex0.PSM);
        mgCDrawPrim prim;
        prim.Initialize(NULL, NULL);
        prim.DepthTestEnable(0);
        prim.AlphaTestEnable(0);
        prim.ZMask(-1);
        prim.TextureMapEnable(0);
        prim.Begin(6);
        prim.Color(0, 0, 0, 0);
        prim.Vertex(0, 0, 0);
        prim.Vertex(shadow->width, shadow->height, 0);
        prim.End();
    }
}

void mgEndDrawShadow(mgCTexture *shadow, mgCTexture *unused) {
    if (shadow != NULL) {
        mgCTexture texture = *shadow;
        sceGsAlpha alpha;
        sceGsTexa  texa;

        texture.tex0.PSM = SCE_GS_PSMCT24;
        mgSetPkFrameBuffer(-1, -1, -1, -1);

        mgCDrawPrim prim;

        prim.Initialize(NULL, NULL);
        prim.DepthTestEnable(0);
        prim.AlphaTestEnable(1);
        prim.AlphaTest(SCE_GS_GEQUAL, 1);
        prim.AlphaBlendEnable(1);
        prim.ZMask(-1);
        prim.TextureMapEnable(1);
        prim.Bilinear(1);
        prim.Begin(SCE_GS_PRIM_SPRITE);
        prim.Color(128, 128, 128, 128);
        prim.Texture(&texture);
        alpha.bits.a = SCE_GS_ALPHA_ZERO;
        alpha.bits.b = SCE_GS_ALPHA_CD;
        alpha.bits.c = SCE_GS_ALPHA_AS;
        alpha.bits.d = SCE_GS_ALPHA_CD;
        alpha.bits.fix = 64;
        prim.Direct(SCE_GS_ALPHA_1, *(u_long *) &alpha);
        texa.TA0 = 48;
        texa.TA1 = 128;
        texa.AEM = 1;
        prim.Direct(SCE_GS_TEXA, *(u_long *) &texa);
        prim.TextureCrd(1, 1);
        prim.Vertex(0, 0, 0);
        prim.TextureCrd(texture.width - 1, texture.height - 1);
        prim.Vertex(mgScreenWidth, mgScreenHeight, 0);
        texa.TA0 = 0;
        texa.TA1 = 128;
        texa.AEM = 1;
        prim.Direct(SCE_GS_TEXFLUSH, 0);
        prim.Direct(SCE_GS_TEXA, *(u_long *) &texa);
        prim.End();
    }
}

void mgSetRenderInfo(float fov, float clip_near, float clip_far) {
    mgRenderInfo.SetRenderInfo(fov, mgScreenWidth, mgScreenHeight, clip_near, clip_far,
                               mgScreenZDepth, 2096.0f / (3.0f * (float) mgScreenWidth));
}

void mgSetProjection(float fov) {
    mgSetRenderInfo(fov, mgRenderInfo.clip_min[2], mgRenderInfo.clip_max[2]);
    mgSetViewMatrix(mgRenderInfo.view, mgRenderInfo.camera_pos);
}

float mgGetProjection() {
    return mgRenderInfo.projection;
}

void mgSetBackGround(float *color) {
    sceVu0CopyVector(mgBackColor, color);
}

void mgSetBackGround(float red, float green, float blue, float alpha) {
    float vector[4];
    *(u_long128 *) vector = *(u_long128 *) at_863;
    vector[0] = red;
    vector[1] = green;
    vector[2] = blue;
    vector[3] = alpha;
    mgSetBackGround(vector);
}

void mgInitLighting() {
    mgRenderInfo.InitLighting();
    mgChangeLight = 1;
}

void mgInitActiveLighting() {
    mgRenderInfo.InitActiveLighting();
    mgChangeLight = 1;
}

int mgActiveLighting(int slot, int copy_from_previous) {
    mgChangeLight = 1;
    return mgRenderInfo.ActiveLighting(slot, copy_from_previous);
}

void mgSetLight(float (*directions)[4], float (*colors)[4]) {
    mgChangeLight = 1;
    mgRenderInfo.SetLight(directions, colors);
}

void mgGetLight(float (*directions)[4], float (*colors)[4]) {
    mgRenderInfo.GetLight(directions, colors);
}

void mgSetLight(int index, float *direction, float *color) {
    mgChangeLight = 1;
    mgRenderInfo.SetLight(index, direction, color);
}

void mgSetAmbient(float *color) {
    mgChangeLight = 1;
    mgRenderInfo.SetAmbient(color);
}

void mgGetAmbient(float *ambient) {
    mgRenderInfo.GetAmbient(ambient);
}

void mgSetPlight(int index, float *position, float *color, float attenuation, float range) {
    mgChangeLight = 1;
    mgRenderInfo.SetPlight(index, position, color, attenuation, range);
}

void mgSetPlight(int index, mgPOINT_LIGHT *light) {
    mgChangeLight = 1;
    mgRenderInfo.SetPlight(index, light);
}

void mgGetPlight(int index, mgPOINT_LIGHT *out) {
    mgRenderInfo.GetPlight(index, out);
}

void mgResetPlight() {
    int index;

    mgChangeLight = 1;
    index = 0;

    do {
        mgRenderInfo.SetPlight(index, NULL);
        index += 1;
    } while (index < 4);
}

void mgSetViewMatrix(float (*matrix)[4], float *eye) {
    mgRenderInfo.SetViewMatrix(matrix, eye);
}

void mgSetDropShadowMatrix(float *light, float *position, float *normal) {
    mgRenderInfo.SetDropShadowMatrix(light, position, normal);
}

void mgFogEnable(int enabled) {
    mgRenderInfo.FogEnable(enabled);
}

int mgGetFogEnable() {
    return mgRenderInfo.GetFogEnable();
}

void mgPlightEnable(int enabled) {
    mgRenderInfo.PlightEnable(enabled);
}

int mgGetPlightEnable() {
    return mgRenderInfo.GetPlightEnable();
}

void mgSetFogParam(float near_dist, float far_dist, u_char r, u_char g, u_char b, float far_value,
                   float near_value) {
    mgRenderInfo.SetFogParam(near_dist, far_dist, r, g, b, far_value, near_value);
}

void mgSetFogParam(mgFOG_PARAM *fog) {
    mgRenderInfo.SetFogParam(fog->near_dist, fog->far_dist, fog->r, fog->g, fog->b, fog->far_value,
                             fog->near_value);
}

/**
 *
 * Copies the four fog colour channels as one value.
 *
 */
struct mgFogColor {
    u_char values[4]; /**< Four fog colour channels. */
};

/**
 *
 * Copies the four fog coefficient floats as one vector.
 *
 */
struct mgFogVector {
    float values[4]; /**< Four fog coefficients. */
};

void mgGetFogParam(mgFOG_PARAM *param) {
    param->near_dist = mgRenderInfo.fog.near_dist;
    param->far_dist = mgRenderInfo.fog.far_dist;
    *(mgFogColor *) &param->r = *(mgFogColor *) &mgRenderInfo.fog.r;
    param->offset = mgRenderInfo.fog.offset;
    param->far_value = mgRenderInfo.fog.far_value;
    param->near_value = mgRenderInfo.fog.near_value;
    param->scale = mgRenderInfo.fog.scale;
    *(mgFogVector *) param->coef = *(mgFogVector *) mgRenderInfo.fog.coef;
}

void mgSetAllScissorFlag(int flag) {
    mgRenderInfo.all_scissor = flag;
}

void mgFlushRenderInfo() {
    sceVif1Packet *packet = mgVif1Packet;
    sceVif1PkTerminate(mgVif1Packet);
    u_int *words = packet->pCurrent;

    words[0] = 0x10000004;
    words[1] = 0;
    words[2] = 0;
    words[3] = 0x6C01003B;
    words[4] = *(u_int *) &mgRenderInfo.fog.offset;
    words[5] = *(u_int *) &mgRenderInfo.fog.near_value;
    words[6] = *(u_int *) &mgRenderInfo.fog.far_value;
    words[7] = *(u_int *) &mgRenderInfo.fog.scale;
    words[8] = 0;
    words[9] = 0;
    words[10] = 0;

    words[11] = 0x6C020039;
    *(u_long128 *) &words[12] = *(u_long128 *) mgRenderInfo.guard_max;
    *(u_long128 *) &words[16] = *(u_long128 *) mgRenderInfo.guard_min;
    sceVif1PkReserve(packet, 0x14);
}

void mgSetPkTextureRepeat(int mode) {
    sceGsClamp clamp;
    memset(&clamp, 0, 8);

    if (mode == 0) {
        clamp.WMS = 1;
        clamp.WMT = 1;
    }

    mgSetPkTextureRepeat(clamp);
}

void mgSetPkTextureRepeat(sceGsClamp clamp) {
    sceVif1Packet *packet = mgVif1Packet;
    sceVif1PkCnt(mgVif1Packet, 0);
    sceVif1PkOpenDirectCode(packet, 0);
    sceVif1PkOpenGifTag(packet, *(u_long128 *) &mgGiftagAD);
    sceVif1PkAddGsAD(packet, gs_clamp1, *(u_long *) &clamp);
    sceVif1PkCloseGifTag(packet);
    sceVif1PkCloseDirectCode(packet);
}

void mgSetPkFrameBuffer(mgCTexture *texture) {
    if (texture == NULL) {
        mgSetPkFrameBuffer(-1, -1, -1, -1);
        return;
    }

    mgSetPkFrameBuffer(texture->tex0.TBP0 / 32, texture->tex0.TBW << 6, texture->height,
                       texture->tex0.PSM);
}

void mgSetPkFrameBuffer(int fbp, int width, int height, int psm) {
    sceGsFrame    *default_frame;
    sceVif1Packet *vif;
    u_int         *packet;
    u_long        *registers;
    int            screen_width;
    int            screen_height;
    int            aligned_width;
    int            width_shift;
    int            height_shift;
    int            size;
    int            bpp;
    int            bit;

    default_frame = mgDBuffID != 0 ? &mgDBuff.draw0.frame1 : &mgDBuff.draw1.frame1;

    if (fbp < 0) {
        fbp = default_frame->FBP;
    }

    if (psm < 0) {
        psm = default_frame->PSM;
    }

    GetScreenSize(mgScreenMode, &screen_width, &screen_height, &mgScreenNX, &mgScreenNY, &mgScreenMX, &mgScreenMY);

    if (width < 0) {
        width = screen_width;
    }

    if (height < 0) {
        height = screen_height;
    }

    mgScreenWidth = width;
    mgScreenHeight = height;
    mgScreenNX = -width / 2;
    mgScreenNY = -height / 2;
    mgScreenMX = mgScreenNX + width;
    mgScreenMY = mgScreenNY + height;
    aligned_width = width;

    if (aligned_width % 64 != 0) {
        aligned_width += 64 - aligned_width % 64;
    }

    sceGsFrame frame = *default_frame;
    frame.FBP = fbp;
    frame.FBW = aligned_width / 64;
    frame.PSM = psm;
    frame.bits.fbmsk = 0;
    mgFRAME_1 = frame;
    mgScreenOffx = 0x800 - width / 2;
    mgScreenOffy = 0x800 - height / 2;
    sceGsXyOffset offset;
    sceGsScissor  scissor;
    offset.OFX = (short) mgScreenOffx * 16;
    offset.OFY = (short) mgScreenOffy * 16;
    scissor.SCAX0 = 0;
    scissor.SCAX1 = width - 1;
    scissor.SCAY0 = 0;
    scissor.SCAY1 = height - 1;
    vif = mgVif1Packet;
    sceVif1PkTerminate(vif);
    packet = vif->pCurrent;
    packet[0] = MG_DMA_CNT | 7;
    packet[1] = 0;
    packet[2] = 0;
    packet[3] = MG_VIF_DIRECT | 7;
    packet[4] = MG_GIFTAG_EOP | 6;
    packet[5] = 1 << MG_GIFTAG_NREG_SHIFT;
    packet[6] = SCE_GIF_PACKED_AD;
    packet[7] = 0;
    registers = (u_long *) &packet[8];
    registers[0] = 0;
    registers[1] = SCE_GS_TEXFLUSH;
    registers[2] = *(u_long *) &frame;
    registers[3] = SCE_GS_FRAME_1;
    registers[4] = *(u_long *) &offset;
    registers[5] = SCE_GS_XYOFFSET_1;
    registers[6] = *(u_long *) &scissor;
    registers[7] = SCE_GS_SCISSOR_1;
    registers[8] = 0;
    registers[9] = SCE_GS_SCANMSK;
    registers[10] = 0;
    registers[11] = SCE_GS_TEXFLUSH;
    sceVif1PkReserve(vif, (u_int *) &registers[12] - packet);
    bpp = 0;

    switch (psm) {
        case SCE_GS_PSMCT32:
            bpp = 32;
            break;
        case SCE_GS_PSMCT24:
            bpp = 24;
            break;
        case SCE_GS_PSMCT16:
            bpp = 16;
            break;
        case SCE_GS_PSMCT16S:
            bpp = 16;
            break;
    }

    frame_tex.Initialize();
    frame_tex.width = width;
    frame_tex.height = height;
    frame_tex.bpp = bpp;
    frame_tex.vram_size = bpp * (width * height) / 8 / 256;
    frame_tex.clut_size = 0;
    frame_tex.image_blocks = frame_tex.vram_size;
    frame_tex.tex0.value = 0;
    frame_tex.tex0.TBP0 = fbp << 5;
    frame_tex.tex0.TBW = width / 64;
    frame_tex.tex0.PSM = psm;
    width_shift = 0;
    height_shift = 0;

    for (size = width; size > 1; size >>= 1) {
        width_shift++;
    }

    size = 1;

    for (bit = 0; bit < width_shift; bit++) {
        size *= 2;
    }

    if (width != size) {
        width_shift++;
    }

    for (size = height; size > 1; size >>= 1) {
        height_shift++;
    }

    size = 1;

    for (bit = 0; bit < height_shift; bit++) {
        size *= 2;
    }

    if (height != size) {
        height_shift++;
    }

    frame_tex.tex0.bits.tw = width_shift;
    frame_tex.tex0.bits.th = height_shift;
    frame_tex.tex0.bits.tcc = 1;
    frame_tex.tex0.bits.tfx = 0;
    *(u_long *) &frame_tex.tex1 = SCE_GS_SET_TEX1(1, 0, 1, 1, 1, 0, 0);
}

void mgGetFrameBuffer(mgCTexture *texture) {
    *texture = frame_tex;
}

void mgGetFrameBackBuffer(mgCTexture *texture) {
    sceGsFrame *draw_env;

    if (mgDBuffID != 0) {
        draw_env = &mgDBuff.draw1.frame1;
    } else {
        draw_env = &mgDBuff.draw0.frame1;
    }

    *texture = frame_tex;
    texture->tex0.TBP0 = draw_env->FBP * 32;
}

mgCDrawEnv *mgGetpDrawEnv(int which) {
    u_int index = (u_int) which > 0;
    return &mgRenderInfo.draw_env[index];
}

void mgSetPkMoveImage(mgCTexture *source, mgRect<int> rect, mgCTexture *destination, int extra0,
                      int extra1, int extra2) {
    if (source == NULL || destination == NULL) {
        return;
    }

    mgSetPkMoveImage(&source->tex0, rect, &destination->tex0, extra0, extra1, extra2);
}

void mgSetPkMoveImage(sceGsTex0 *src, mgRect<int> src_rect, sceGsTex0 *dst, int dst_x, int dst_y, int direction) {
    int            dst_width;
    int            src_width;
    int            left;
    int            top;
    sceVif1Packet *vif;
    int            right;
    int            bottom;

    vif = mgVif1Packet;
    dst_width = dst->TBW * 64;
    src_width = src->TBW * 64;

    if (dst_width < 64) {
        dst_width = 64;
    }

    if (src_width < 64) {
        src_width = 64;
    }

    right = src_rect.right;

    if (right - src_rect.left + 1 > 0 && (bottom = src_rect.bottom, bottom - src_rect.top + 1 > 0)) {
        left = src_rect.left / 16;
        top = src_rect.top / 16;

        if (right % 16 != 0) {
            right = right / 16;
        } else {
            right = right / 16;
        }

        if (bottom % 16 != 0) {
            bottom = bottom / 16;
        } else {
            bottom = bottom / 16;
        }

        sceVif1PkCnt(vif, 0);
        sceVif1PkOpenDirectCode(vif, 0);
        sceVif1PkOpenGifTag(vif, *(u_long128 *) &mgGiftagAD);
        sceVif1PkAddGsAD(vif, SCE_GS_BITBLTBUF, SCE_GS_SET_BITBLTBUF(src->TBP0, src_width / 64, src->PSM, dst->TBP0, dst_width / 64, dst->PSM));
        sceVif1PkAddGsAD(vif, SCE_GS_TRXPOS, SCE_GS_SET_TRXPOS(left, top, dst_x >> 4, dst_y >> 4, direction));
        sceVif1PkAddGsAD(vif, SCE_GS_TRXREG, SCE_GS_SET_TRXREG(right - left + 1, bottom - top + 1));
        sceVif1PkAddGsAD(vif, SCE_GS_TRXDIR, SCE_GS_LOCAL_LOCAL);
        sceVif1PkCloseGifTag(vif);
        sceVif1PkCloseDirectCode(vif);
        sceVif1PkCnt(vif, 0);
        sceVif1PkOpenDirectCode(vif, 0);
        sceVif1PkOpenGifTag(vif, *(u_long128 *) &mgGiftagAD);
        sceVif1PkAddGsAD(vif, SCE_GS_TEXFLUSH, 0);
        sceVif1PkCloseGifTag(vif);
        sceVif1PkCloseDirectCode(vif);
    }
}

void mgSetPkMoveImage(mgCTexture *source, mgRect<int> source_rect, mgCTexture *destination,
                      mgRect<int> destination_rect, mgCDrawEnv *draw_env) {
    if (source == NULL || destination == NULL) {
        return;
    }

    mgSetPkMoveImage(&source->tex0, source_rect, &destination->tex0, destination->height,
                     destination_rect, draw_env);
}

void mgSetPkMoveImage(sceGsTex0 *src, mgRect<int> src_rect, sceGsTex0 *dst, int dst_height, mgRect<int> dst_rect, mgCDrawEnv *env) {
    sceVif1Packet *vif;
    int            width;

    width = dst->TBW * 64;

    if (width % 64 != 0) {
        width += 64 - width % 64;
    }

    if (dst_height % 64 != 0) {
        dst_height += 64 - dst_height % 64;
    }

    mgSetPkFrameBuffer(dst->TBP0 / 32, width, dst_height, dst->PSM);
    vif = mgVif1Packet;
    sceVif1PkCnt(vif, 0);
    sceVif1PkOpenDirectCode(vif, 0);
    sceVif1PkOpenGifTag(vif, *(u_long128 *) &mgGiftagAD);
    sceVif1PkAddGsAD(vif, SCE_GS_TEXFLUSH, 0);

    if (env != NULL) {
        sceVif1PkAddGsAD(vif, SCE_GS_TEST_1, env->test.value);
        sceGsZbuf zbuf = mgZBUF_1;
        zbuf.bits.zmsk = env->zbuf.bits.zmsk;
        sceVif1PkAddGsAD(vif, SCE_GS_ZBUF_1, *(u_long *) &zbuf);
        sceVif1PkAddGsAD(vif, SCE_GS_ALPHA_1, env->alpha.value);
    } else {
        sceGsTest test = mgTEST_1;
        test.bits.ate = 0;
        test.bits.zte = 1;
        test.bits.ztst = SCE_GS_ALWAYS;
        test.bits.date = 0;
        sceVif1PkAddGsAD(vif, SCE_GS_TEST_1, *(u_long *) &test);
        sceGsZbuf zbuf = mgZBUF_1;
        zbuf.bits.zmsk = 1;
        sceVif1PkAddGsAD(vif, SCE_GS_ZBUF_1, *(u_long *) &zbuf);
        sceGsAlpha alpha = mgALPHA_1;
        alpha.bits.a = SCE_GS_ALPHA_ZERO;
        alpha.bits.b = SCE_GS_ALPHA_ZERO;
        alpha.bits.c = SCE_GS_ALPHA_FIX;
        alpha.bits.d = SCE_GS_ALPHA_CS;
        sceVif1PkAddGsAD(vif, SCE_GS_ALPHA_1, *(u_long *) &alpha);
    }

    sceVif1PkAddGsAD(vif, SCE_GS_TEX1_1, 0x25);
    sceVif1PkAddGsAD(vif, SCE_GS_TEX0_1, *(u_long *) src);
    sceVif1PkAddGsAD(vif, SCE_GS_PRMODECONT, 1);
    sceVif1PkAddGsAD(vif, SCE_GS_PRIM, 0x116);
    sceVif1PkAddGsAD(vif, SCE_GS_RGBAQ, 0x80808080);
    sceVif1PkAddGsAD(vif, SCE_GS_UV, (u_long) src_rect.left | ((u_long) src_rect.top << 16));
    sceVif1PkAddGsAD(vif, SCE_GS_XYZF2, (u_long) ((mgScreenOffx << 4) + dst_rect.left) | ((u_long) ((mgScreenOffy << 4) + dst_rect.top) << 16));
    sceVif1PkAddGsAD(vif, SCE_GS_UV, (u_long) src_rect.right | ((u_long) src_rect.bottom << 16));
    sceVif1PkAddGsAD(vif, SCE_GS_XYZF2, (u_long) ((mgScreenOffx << 4) + dst_rect.right) | ((u_long) ((mgScreenOffy << 4) + dst_rect.bottom) << 16));
    sceVif1PkAddGsAD(vif, SCE_GS_TEXFLUSH, 0);
    sceVif1PkCloseGifTag(vif);
    sceVif1PkCloseDirectCode(vif);
    mgSetPkFrameBuffer(-1, -1, -1, -1);
}

void mgSetPkClearScreen(u_char red, u_char green, u_char blue, u_char alpha) {
    sceVif1Packet *packet = mgVif1Packet;
    sceVif1PkCnt(mgVif1Packet, 0);
    sceVif1PkOpenDirectCode(packet, 0);
    sceVif1PkOpenGifTag(packet, *(u_long128 *) &mgGiftagAD);
    sceVif1PkAddGsAD(packet, gs_texflush, 0);
    sceVif1PkCloseGifTag(packet);
    sceVif1PkCloseDirectCode(packet);
    sceVif1PkCnt(packet, 0);
    sceVif1PkOpenDirectCode(packet, 0);
    sceVif1PkOpenGifTag(packet, *(u_long128 *) &mgGiftagAD);
    sceGsTest test = mgTEST_1;
    test.bits.ate = 0;
    test.bits.zte = 1;
    test.bits.ztst = 1;
    test.bits.date = 0;
    sceVif1PkAddGsAD(packet, gs_test1, *(u_long *) &test);
    sceGsZbuf zbuf = mgZBUF_1;
    zbuf.bits.zmsk = 0;
    sceVif1PkAddGsAD(packet, gs_zbuf1, *(u_long *) &zbuf);
    sceGsAlpha blend = mgALPHA_1;
    blend.bits.a = 2;
    blend.bits.b = 2;
    blend.bits.c = 2;
    blend.bits.d = 0;
    sceVif1PkAddGsAD(packet, gs_alpha1, *(u_long *) &blend);
    sceVif1PkAddGsAD(packet, gs_tex1_1, 1);
    sceVif1PkAddGsAD(packet, gs_prim, 0x146);
    sceVif1PkAddGsAD(packet, gs_rgbaq,
                     (u_long) red | ((u_long) green << 8) | ((u_long) blue << 16) |
                         ((u_long) alpha << 24));

    for (int x = 0; x < mgScreenWidth * 16; x += 0x200) {
        int left = (mgScreenOffx << 4) + x;
        sceVif1PkAddGsAD(packet, gs_xyzf2,
                         ((long long) (mgScreenOffy << 4) << 16) | (long long) left);
        int right = (mgScreenOffx << 4) + x + 0x200;
        sceVif1PkAddGsAD(packet, gs_xyzf2,
                         ((long long) ((mgScreenOffy + mgScreenHeight) << 4) << 16) |
                             (long long) right);
    }

    sceVif1PkAddGsAD(packet, gs_texflush, 0);
    sceVif1PkCloseGifTag(packet);
    sceVif1PkCloseDirectCode(packet);
}

int mgStoreImage(mgCTexture *texture, u_long128 *buffer) {
    sceGsStoreImage store_image;
    int             block_width;

    if (texture == 0 || buffer == 0) {
        return 0;
    }

    mgWaitFrame();
    block_width = texture->width / 64;

    if (block_width == 0) {
        block_width = 1;
    }

    sceGsSetDefStoreImage(&store_image, texture->tex0.TBP0, block_width, texture->tex0.PSM, 0, 0,
                          texture->width, texture->height);
    FlushCache(0);
    sceGsExecStoreImage(&store_image, buffer);
    sceGsSyncPath(0, 0);
    return texture->bpp * (texture->width * texture->height);
}

int mgStoreZBuffImage(mgRect<int> &rect, u_long128 *buffer) {
    sceGsStoreImage image;
    int             width;
    int             height;
    int             pixel;
    u_int          *depth;

    width = rect.right - rect.left + 1;
    height = rect.bottom - rect.top + 1;

    if (width % 8 != 0) {
        width = width / 8 * 8;
    }

    if (height % 8 != 0) {
        height = height / 8 * 8;
    }

    if (width == 0 || height == 0) {
        return 0;
    }

    sceGsSetDefStoreImage(&image, mgZBUF_1.bits.zbp * 2048 / 64, mgScreenWidth / 64, SCE_GS_PSMZ32, rect.left, rect.top, width, height);
    FlushCache(0);
    sceGsExecStoreImage(&image, buffer);
    sceGsSyncPath(0, 0);
    depth = (u_int *) buffer;

    for (pixel = 0; pixel < width * height; pixel++) {
        *depth &= 0xFFFFFF;
        depth++;
    }

    return width * height / 4;
}

float mgConvZBuffToDist(u_int zbuf) {
    return mgRenderInfo.view_screen[3][2] / ((float) zbuf - mgRenderInfo.view_screen[2][2]);
}

mgCTexture *mgGetTextureZ(int index) {
    if (index < 0 || index > 1) {
        return 0;
    }

    return &fixz_tex[index];
}

/**
 *
 * Tests a projected position against the screen and depth clipping bounds.
 *
 * @mangled prim_clip_check__FPf
 * @address 0x145C70
 * @size 0xB0
 *
 */
static int prim_clip_check(float *vertex) {
    mgRENDER_INFO *info = &mgRenderInfo;

    if (vertex[0] < 0.0f || vertex[0] > 4095.0f) {
        return 0;
    }

    if (vertex[1] < 0.0f || vertex[1] > 4095.0f) {
        return 0;
    }

    float z = vertex[3];

    if (z < info->clip_min[2] || z > info->clip_max[2]) {
        return 0;
    }

    return 1;
}

int mgTransWorldPrim(int *out, float *pos) {
    float v[4];
    sceVu0ApplyMatrix(v, mgRenderInfo.world_screen, pos);
    float inv = 1.0f / v[3];
    v[0] *= inv;
    v[1] *= inv;
    v[2] *= inv;
    out[0] = fptosi(16.0f * v[0]);
    out[1] = fptosi(16.0f * v[1]);
    out[2] = fptosi(v[2]);
    out[3] = 0;
    return prim_clip_check(v);
}

int mgTransWorldScreen(int *out, float *pos) {
    int visible = mgTransWorldPrim(out, pos);
    out[0] = out[0] - (mgScreenOffx << 4);
    out[1] = out[1] - (mgScreenOffy << 4);
    return visible;
}

int mgTransViewPrim(int *out, float *pos) {
    float v[4];
    sceVu0ApplyMatrix(v, mgRenderInfo.view_screen, pos);
    float inv = 1.0f / v[3];
    v[0] *= inv;
    v[1] *= inv;
    v[2] *= inv;
    out[0] = fptosi(16.0f * v[0]);
    out[1] = fptosi(16.0f * v[1]);
    out[2] = fptosi(v[2]);
    out[3] = 0;
    return prim_clip_check(v);
}

void mgTransWorldView(float *a, float *b) {
    sceVu0ApplyMatrix(a, mgRenderInfo.view, b);
}

int mgTransZPrim(float z) {
    float pos[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    int   screen[4];
    pos[2] = z;
    mgTransViewPrim(screen, pos);
    return screen[2];
}

float mgGetDistFromCamera(float *pos) {
    return mgDistVector(pos, mgRenderInfo.camera_pos);
}

void mgGetDirFromCamera(float *dir, float *pos) {
    sceVu0SubVector(dir, pos, mgRenderInfo.camera_pos);
}

void mgGetCameraPos(float *out) {
    *(u_long128 *) out = *(u_long128 *) mgRenderInfo.camera_pos;
}

void mgGetCameraPose(float (*pose)[4]) {
    *(u_long128 *) pose[0] = *(u_long128 *) mgRenderInfo.camera_pose[0];
    *(u_long128 *) pose[1] = *(u_long128 *) mgRenderInfo.camera_pose[1];
    *(u_long128 *) pose[2] = *(u_long128 *) mgRenderInfo.camera_pose[2];
    *(u_long128 *) pose[3] = *(u_long128 *) mgRenderInfo.camera_pose[3];
}

int mgTransWorldPrim3DSprite(int *top_left, int *bottom_right, float *position, float width, float height, int unused) {
    sceVu0FVECTOR first;
    sceVu0FVECTOR second;
    sceVu0FVECTOR projected;
    float         scaled_width;
    float         scaled_height;
    float         reciprocal;
    int           visible;

    scaled_width = width * mgRenderInfo.view_screen[0][0];
    scaled_height = height * mgRenderInfo.view_screen[1][1];
    sceVu0ApplyMatrix(projected, mgRenderInfo.world_screen, position);

    if (projected[3] < 1.0f) {
        return 0;
    }

    reciprocal = 1.0f / projected[3];
    projected[0] *= reciprocal;
    projected[1] *= reciprocal;
    projected[2] *= reciprocal;
    scaled_width *= reciprocal;
    scaled_height *= reciprocal;
    sceVu0CopyVector(first, projected);
    sceVu0CopyVector(second, projected);
    first[0] -= 0.5f * scaled_width;
    first[1] -= 0.5f * scaled_height;
    second[0] += 0.5f * scaled_width;
    second[1] += 0.5f * scaled_height;
    top_left[0] = (int) (16.0f * first[0]);
    top_left[1] = (int) (16.0f * first[1]);
    top_left[2] = (int) first[2];
    top_left[3] = 0;
    bottom_right[0] = (int) (16.0f * second[0]);
    bottom_right[1] = (int) (16.0f * second[1]);
    bottom_right[2] = (int) second[2];
    bottom_right[3] = 0;
    visible = prim_clip_check(first);
    return visible & prim_clip_check(second);
}

#pragma global_optimizer off

/**
 *
 * Tests whether a built-in or user VU1 microprogram identifier is available.
 *
 * @mangled CheckVuProgID__Fi
 * @address 0x1461C0
 * @size 0x94
 *
 */
static int CheckVuProgID(int id) {
    if (id < user_vu_prog_base) {
        if (id <= -1) {
            return 0;
        }

        if (id >= builtin_vu_prog_count) {
            return 0;
        }

        goto valid;
    }

    if (id < user_vu_prog_base) {
        return 0;
    }

    if (id >= user_prog_num + user_vu_prog_base) {
        return 0;
    }

    if (user_prog_adr == 0) {
        return 0;
    }

    if (*(int *) ((id << 2) + (int) user_prog_adr - user_vu_prog_base * 4) == 0) {
        return 0;
    }

valid:
    return 1;
}

#pragma global_optimizer reset

u_long128 *mgGetVuProgPacket(int id) {
    if (CheckVuProgID(id) == 0) {
        return NULL;
    }

    if (id < user_vu_prog_base) {
        return prog_adr[id];
    }

    u_long128 **user_table = user_prog_adr;
    return user_table[id - user_vu_prog_base];
}

int mgSendVuProg(u_int *tag, int id) {
    if (CheckVuProgID(id) == 0) {
        now_prog_id = -1;
        return 0;
    }

    if (id != now_prog_id) {
        void *packet = mgGetVuProgPacket(id);
        tag[0] = dma_tag_call;
        tag[1] = (u_int) packet;
        tag[2] = 0;
        tag[3] = 0;
        now_prog_id = id;
        return 4;
    }

    return 0;
}

void mgSetUserVuProg(u_long128 **table, int count) {
    user_prog_adr = table;
    user_prog_num = count;
}

#pragma global_optimizer off

void mgSetUserVuProgAdr(int index, u_long128 *adr) {
    if (index < 0 || index >= user_prog_num) {
        return;
    }

    user_prog_adr[index] = adr;
}

#pragma global_optimizer reset

/**
 *
 * Writes the selected frame buffer to a numbered TGA image on the host device.
 *
 * @mangled StoreImage__Fi
 * @address 0x146390
 * @size 0x284
 *
 */
void StoreImage(int front_buffer) {
    static int image_num = 0;
    u_char     tga[18] = {0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 24, 0};
    char       filename[128];
    char       device[128];
    char      *character;
    u_char    *row;
    u_char     red;
    int        file;
    int        y;
    int        output;
    int        pixel;

    tga[12] = mgScreenWidth;
    tga[14] = mgScreenHeight;
    tga[13] = mgScreenWidth >> 8;
    tga[15] = mgScreenHeight >> 8;
    strcpy(device, "host0:");
    sprintf(filename, "%si%5d.tga", device, image_num++);
    character = filename;
    char current;

    while ((current = *character) != '\0') {
        if (current == ' ') {
            *character = '0';
        }

        character++;
    }

    file = sceOpen(filename, SCE_WRONLY | SCE_CREAT | SCE_TRUNC);

    mgCTexture texture;

    if (front_buffer == 0) {
        mgGetFrameBackBuffer(&texture);
    } else {
        mgGetFrameBuffer(&texture);
    }

    sceGsSetDefStoreImage(&gs_simage, texture.tex0.TBP0, mgScreenWidth / 64, SCE_GS_PSMCT32, 0, 0, mgScreenWidth, mgScreenHeight);
    FlushCache(0);
    sceGsExecStoreImage(&gs_simage, (u_long128 *) 0x2100000);
    sceGsSyncPath(0, 0);
    sceWrite(file, tga, 18);

    for (y = 0; y < mgScreenHeight; y++) {
        row = (u_char *) ((u_long128 *) 0x2100000 + mgScreenWidth * (mgScreenHeight - y - 1) / 4);

        for (output = 0, pixel = 0; pixel < mgScreenWidth * 4; output += 3, pixel += 4) {
            red = row[pixel];
            row[pixel] = row[pixel + 2];
            row[pixel + 2] = red;
            row[output] = row[pixel];
            row[output + 1] = row[pixel + 1];
            row[output + 2] = row[pixel + 2];
        }

        row = (u_char *) ((u_long128 *) 0x2100000 + mgScreenWidth * (mgScreenHeight - y - 1) / 4);
        sceWrite(file, row, mgScreenWidth * 3);
    }

    sceClose(file);
}

int mgInitFont() {
    sceDevConsInit();
    font_cons = sceDevConsOpen((mgScreenOffx + 8) * 0x10, (mgScreenOffy + 8) * 0x10, 0x28, 0x18);
    return font_cons;
}

void mgCloseFont() {
    if (font_cons >= 0) {
        sceDevConsClose(font_cons);
    }

    font_draw_flag = 0;
}

// Small uninitialised data (.sbss)
int            mgAntialiasing;
int            mgFrameRate;
float          mgNowFrameRate;
sceDmaChan    *DmaCH1;
sceDmaChan    *DmaCH2;
sceDmaChan    *DmaCH8;
sceVif1Packet *mgVif1Packet;
int            mgClearBackFlag;
int            mgScreenMode;
int            mgScreenWidth;
int            mgScreenHeight;
int            mgScreenNX;
int            mgScreenNY;
int            mgScreenMX;
int            mgScreenMY;
int            mgScreenOffx;
int            mgScreenOffy;
int            mgScreenDepth;
int            mgScreenZDepth;
int            mgScreenLeft;
int            mgScreenRight;
int            mgScreenTop;
int            mgScreenBottom;
int            VSyncField;
sceGsTex1      mgTEX1_1;
sceGsTex1      mgTEX1_2;
sceGsTest      mgTEST_1;
sceGsTest      mgTEST_2;
sceGsZbuf      mgZBUF_1;
sceGsZbuf      mgZBUF_2;
sceGsAlpha     mgALPHA_1;
sceGsAlpha     mgALPHA_2;
sceGsTexa      mgTEXA_1;
sceGsTexa      mgTEXA_2;
sceGsFrame     mgFRAME_1;
int            ddraw_size;

// Uninitialised data (.bss)
sceGifTag       mgGiftagAD;
sceVu0FVECTOR   mgBackColor;
sceGsDBuff      mgDBuff;
MG_PICKZ        mgPickZBuff[4];
sceGsStoreImage gs_simage;
