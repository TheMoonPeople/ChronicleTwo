#include "common.h"
#include "mg_memory.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mg_frame.hpp"
#include "mg_drawenv.hpp"
#include "mg_math.hpp"
#define mgDBuff mgDBuffDeclaration
#include "mglib.hpp"
#undef mgDBuff
extern u_char mgDBuff[];
#include "mg_visual.hpp"
#include "mg_tanime.hpp"

#include <cstring>
#include <cstdio>
#include <eekernel.h>

static const u_int timer0_count = 0x10000000;
static const u_int gs_csr = 0x12001000;
static const u_int dma_tag_call = 0x50000000;
static const int builtin_vu_prog_count = 3;
static const int user_vu_prog_base = 0x100;
enum {
    dbuff_draw_env_a = 0x60,
    dbuff_draw_env_b = 0x150,
    dbuff_clear_a = 0x100,
    dbuff_clear_b = 0x1F0
};
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

extern int draw_performance_meter;
extern int call_back_active;
extern u_int VSyncCallBack2;
extern int vcount;
extern int rot_priority;
extern u_int *packetbuf[2];
extern sceVif1Packet vifpacket[2];
extern int packet_size;
extern mgCMemory packet_buf[2];
extern mgCMemory data_buf[2];
extern int mgDataID;
extern int mgDBuffID;
extern int h_count;
extern int mgChangeLight;
extern int now_prog_id;
extern u_long128 *prog_adr[3];
extern u_long128 **user_prog_adr;
extern int user_prog_num;
extern int font_cons;
extern int font_draw_flag;
struct mgFrameTextureCopy {
    short block;
    short width;
    short height;
    short bpp;
    char name[0x20];
    u_int vram_size;
    u_int image_blocks;
    u_int clut_size;
    u_long tex0;
    u_long tex1;
    u_long clamp;
    float image[4];
    u_int clut;
    u_int swizzled;
    u_int next;
};
extern mgFrameTextureCopy frame_tex;
extern mgCTexture fixz_tex[2];
extern float at_863[4];
extern float at_1389[4];
extern char at_715[];
extern char at_716[];
extern "C" int fptosi(float value);
extern "C" void Exit__2(int code);
extern "C" int sceDevConsInit();
extern "C" int sceDevConsOpen(int x, int y, int columns, int rows);
extern "C" void sceDevConsClose(int handle);
void StoreImage(int index);

#ifdef NONMATCHING
#include <libdev.h>
#include <sifdev.h>
extern int old_vcount;
extern int over_vsync;
extern int capture_on;
extern int cap_ture_cnt;
extern int frame_buf0;
extern int frame_buf1;
extern sceGsDimx mgDIMX;
extern sceGsStoreImage gs_simage;
#endif

// Code (.text)
void mgPerformanceMeter(int enable) {
    draw_performance_meter = enable;
}
int mgGetPerformanceMeterFlag(void) {
    return draw_performance_meter;
}
#pragma global_optimizer off
extern "C" int VSyncCallBack__Fi(void) {
    call_back_active = 1;

    VSyncField = (u_char)((((*(u_long *)gs_csr >> 13) & 1) != 0) ^ 1);
    if (VSyncCallBack2 != 0) {
        ((void (*)(void))VSyncCallBack2)();
    }
    vcount += 1;
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
    VSyncCallBack2 = (unsigned int)callback;
}
void mgSetRotateThread(int priority) {
    rot_priority = priority;
}
void WaitVSync(int start, int frames) {
wait:
    if ((mgGetVSyncCount() - start) < frames) {
        if (rot_priority > 0) {
            RotateThreadReadyQueue(rot_priority);
        }
        goto wait;
    }
}
int mgGetVSyncCount(void) {
    return vcount;
}
int GetScreenSize(int mode, int *width, int *height, int *left, int *top, int *right, int *bottom) {
    switch (mode) {
        case 3:
            *width = 0x280;
            *height = 0x1C0;
            break;
        case 2:
            *width = 0x200;
            *height = 0x1E0;
            break;
        case 1:
            *width = 0x200;
            *height = 0x1A0;
            break;
        case 0:
        default:
            mode = 0;
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
#ifdef NONMATCHING
void mgInit(int screen_mode, int video_mode) {
    sceGsDBuff *buffers = (sceGsDBuff *)mgDBuff;
    static signed char dimx[16] = { 10, 4, 6, 8, 12, 0, 2, 14, 7, 9, 11, 5, 3, 15, 13, 1 };
    sceDmaEnv          dma_env;
    u_long128          clear_pixels[8192];
    sceGsLoadImage     load_image;
    u_long             packed_dimx;
    int                aligned_height;
    int                buffer;
    int                i;

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
    DmaCH1 = sceDmaGetChan(1);
    DmaCH2 = sceDmaGetChan(2);
    DmaCH8 = sceDmaGetChan(8);
    DmaCH1->chcr.TTE = 1;
    *(u_long128 *)&mgGiftagAD = 0;
    mgGiftagAD.EOP = 1;
    mgGiftagAD.NREG = 1;
    mgGiftagAD.REGS0 = SCE_GIF_PACKED_AD;
    mgScreenMode = GetScreenSize(screen_mode, &mgScreenWidth, &mgScreenHeight, &mgScreenNX, &mgScreenNY, &mgScreenMX, &mgScreenMY);
    aligned_height = mgScreenHeight;
    if (aligned_height % 32 != 0) {
        aligned_height += 32 - aligned_height % 32;
    }
    mgScreenOffx = 0x800 - mgScreenWidth / 2;
    mgScreenOffy = 0x800 - mgScreenHeight / 2;
    mgScreenDepth = 32;
    mgScreenZDepth = 32;
    mgScreenLeft = mgScreenOffx;
    mgScreenRight = mgScreenOffx + mgScreenWidth;
    mgScreenTop = mgScreenOffy;
    mgScreenBottom = mgScreenOffy + mgScreenHeight;
    sceGsResetGraph(0, SCE_GS_INTERLACE, video_mode, 0);
    for (i = 0; i < 8192; i++) {
        clear_pixels[i] = 0;
    }
    for (buffer = 0; buffer < 32; buffer++) {
        sceGsSetDefLoadImage(&load_image, buffer * 0x200, 2, SCE_GS_PSMCT32, 0, 0, 128, 256);
        FlushCache(0);
        sceGsExecLoadImage(&load_image, clear_pixels);
    }
    sceGsSetDefDBuff(buffers, SCE_GS_PSMCT32, (short)mgScreenWidth, (short)mgScreenHeight, SCE_GS_ZGEQUAL, SCE_GS_PSMZ24, 0);
    frame_buf0 = 0;
    frame_buf1 = mgScreenDepth * (mgScreenWidth * aligned_height / 2048) / 32;
    mgBackColor[0] = 0.0f;
    mgBackColor[1] = 0.0f;
    mgBackColor[2] = 0.0f;
    mgBackColor[3] = 128.0f;
    mgClearBackFlag = 1;
    buffers->draw0.frame1.FBP = frame_buf1;
    buffers->draw1.frame1.FBP = frame_buf0;
    buffers->draw1.zbuf1.bits.zbp = frame_buf1 * 2;
    buffers->draw0.zbuf1.bits.zbp = buffers->draw1.zbuf1.bits.zbp;
    buffers->clear0.rgbaq.bytes.red = (int)mgBackColor[0];
    buffers->clear0.rgbaq.bytes.green = (int)mgBackColor[1];
    buffers->clear0.rgbaq.bytes.blue = (int)mgBackColor[2];
    buffers->clear0.rgbaq.bytes.alpha = (int)mgBackColor[3];
    buffers->clear1.rgbaq.bytes.red = buffers->clear0.rgbaq.bytes.red;
    buffers->clear1.rgbaq.bytes.green = buffers->clear0.rgbaq.bytes.green;
    buffers->clear1.rgbaq.bytes.blue = buffers->clear0.rgbaq.bytes.blue;
    buffers->clear1.rgbaq.bytes.alpha = buffers->clear0.rgbaq.bytes.alpha;
    *(u_long *)&mgTEX1_1 = 0x261;
    mgTEX1_2 = mgTEX1_1;
    *(u_long *)&mgTEST_1 = 0x5000B;
    mgTEST_2 = mgTEST_1;
    mgZBUF_1 = buffers->draw0.zbuf1;
    mgZBUF_2 = buffers->draw0.zbuf1;
    *(u_long *)&mgALPHA_1 = 0x44;
    mgALPHA_2 = mgALPHA_1;
    *(u_long *)&mgTEXA_1 = 0x100400000ULL;
    mgTEXA_2 = mgTEXA_1;
    mgDrawManager.texture_manager = &mgTexManager;
    mgDrawManager.render_info = &mgRenderInfo;
    mgRenderInfo.Initialize();
    mgRenderInfo.draw_env[0].zbuf = mgZBUF_1;
    mgRenderInfo.draw_env[1].zbuf = mgZBUF_2;
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
    *(volatile u_int *)0x10000010 = 0x83;
    mgFrameRate = 2;
    vcount = 0;
    over_vsync = 0;
    sceGsSyncVCallback((int (*)(int))VSyncCallBack__Fi);
    VSyncCallBack2 = 0;
    call_back_active = 0;
    FlushCache(0);
    sceGsSwapDBuff(buffers, 0);
    sceDmaSync(DmaCH2, 0, 0);
    mgCreateSinTable();
    for (i = 0; i < 16; i++) {
        dimx[i] = dimx[i] / 2 - 4;
    }
    packed_dimx = 0;
    for (i = 0; i < 16; i++) {
        packed_dimx |= (u_long)(dimx[i] & 0x7) << (i * 4);
    }
    mgDIMX.value = packed_dimx;
    mgDIMX.bits.dm00 = dimx[0];
    mgDIMX.bits.dm01 = dimx[1];
    mgDIMX.bits.dm02 = dimx[2];
    mgDIMX.bits.dm03 = dimx[3];
    mgDIMX.bits.dm10 = dimx[4];
    mgDIMX.bits.dm11 = dimx[5];
    mgDIMX.bits.dm12 = dimx[6];
    mgDIMX.bits.dm13 = dimx[7];
    mgDIMX.bits.dm20 = dimx[8];
    mgDIMX.bits.dm21 = dimx[9];
    mgDIMX.bits.dm22 = dimx[10];
    mgDIMX.bits.dm23 = dimx[11];
    mgDIMX.bits.dm30 = dimx[12];
    mgDIMX.bits.dm31 = dimx[13];
    mgDIMX.bits.dm32 = dimx[14];
    mgDIMX.bits.dm33 = dimx[15];
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mglib", mgInit__Fii);
#endif
void mgInitVif1Packet(u_long128 *buffer_a, u_long128 *buffer_b, int size) {
    packetbuf[0] = (u_int *)buffer_a;
    packetbuf[1] = (u_int *)buffer_b;
    int misalign = (int)packetbuf[0] % 4;
    if (misalign != 0) {
        packetbuf[0] += 4 - misalign;
    }
    misalign = (int)packetbuf[1] % 4;
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
    u_char *base = (u_char *)pool_a->stAllocTest(1);
    int size = pool_a->stack_size - pool_a->stack_used;
    if (skip_header != 0) {
        base += 0x4000;
        size -= 0x800;
    }
    data_buf[0].stSetBuffer((u_long128 *)base, size);
    base = (u_char *)pool_b->stAllocTest(1);
    size = pool_b->stack_size - pool_b->stack_used;
    if (skip_header != 0) {
        base += 0x4000;
        size -= 0x800;
    }
    data_buf[1].stSetBuffer((u_long128 *)base, size);
    data_buf[0].stack_used = 0;
    data_buf[0].lock = 0;
    data_buf[1].stack_used = 0;
    data_buf[1].lock = 0;
}
mgCMemory *mgGetDataBuffer(void) {
    return &data_buf[mgDataID];
}
int mgGetTopVRAMAddress(void) {
    int height = mgScreenHeight;
    if (height % 32 != 0) {
        height += 32 - height % 32;
    }
    height = mgScreenWidth * height;
    int blocks = mgScreenDepth * height * 2 / 256 / 8;
    blocks += mgScreenZDepth * height / 256 / 8;
    return blocks;
}
float mgGetNowFrameRate(void) {
    return (float)mgFrameRate;
}
void mgBeginFrame(mgCDrawManager *manager) {
    if (manager == NULL) {
        mgDrawManager.texture_manager = &mgTexManager;
        manager = &mgDrawManager;
        mgDrawManager.render_info = &mgRenderInfo;
    }

    *(int *)timer0_count = 0;
    h_count = *(int *)timer0_count;

    int red = fptosi(mgBackColor[0]);
    mgDBuff[dbuff_clear_a + 0] = red;
    int green = fptosi(mgBackColor[1]);
    mgDBuff[dbuff_clear_a + 1] = green;
    int blue = fptosi(mgBackColor[2]);
    mgDBuff[dbuff_clear_a + 2] = blue;
    int alpha = fptosi(mgBackColor[3]);
    mgDBuff[dbuff_clear_b + 0] = red;
    mgDBuff[dbuff_clear_b + 1] = green;
    mgDBuff[dbuff_clear_b + 2] = blue;
    mgDBuff[dbuff_clear_a + 3] = alpha;
    mgDBuff[dbuff_clear_b + 3] = alpha;
    mgBeginPacket(manager);
    *(u_long128 *)&mgGiftagAD = 0;
    mgGiftagAD.EOP = 1;
    mgGiftagAD.NREG = 1;
    mgGiftagAD.REGS0 = 0xE;
    sceVif1PkCnt(mgVif1Packet, 0);
    sceVif1PkOpenDirectCode(mgVif1Packet, 0);
    sceVif1PkOpenGifTag(mgVif1Packet, *(u_long128 *)&mgGiftagAD);
    sceVif1PkAddGsAD(mgVif1Packet, gs_scanmsk, 0);
    sceVif1PkAddGsAD(mgVif1Packet, gs_texflush, 0);
    sceVif1PkCloseGifTag(mgVif1Packet);
    sceVif1PkCloseDirectCode(mgVif1Packet);
    mgSetPkTextureRepeat(1);
    long long *draw_env;
    if (mgDBuffID != 0) {
        draw_env = (long long *)(mgDBuff + dbuff_draw_env_a);
    } else {
        draw_env = (long long *)(mgDBuff + dbuff_draw_env_b);
    }
    mgFRAME_1.value = *draw_env;
    mgSetPkFrameBuffer(-1, -1, -1, -1);
    mgSetPkClearScreen(
        mgDBuff[dbuff_clear_a + 0], mgDBuff[dbuff_clear_a + 1],
        mgDBuff[dbuff_clear_a + 2], mgDBuff[dbuff_clear_a + 3]);
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
    if (mgr == NULL)
        mgr = &mgDrawManager;
    mgr->BeginDraw(memory, draw_size);
}
void mgEndDraw(mgCDrawManager *manager) {
    if (manager == NULL) {
        manager = &mgDrawManager;
    }
    manager->EndDraw((sceVif1Packet *)mgVif1Packet);
}
void mgPreEndDraw(mgCDrawManager *manager) {
    if (manager == NULL) {
        manager = &mgDrawManager;
    }
    manager->PreEndDraw();
}
int mgEndDrawReloadTexture(int texture, mgCDrawManager *manager) {
    if (manager == NULL)
        manager = &mgDrawManager;
    return manager->ReloadTexture(texture, mgVif1Packet);
}
void mgEndDraw(int mode, mgCDrawManager *manager) {
    if (manager == NULL)
        manager = &mgDrawManager;
    manager->Draw(mode, mgVif1Packet);
}
void mgStoreFrameImage(void) {
    StoreImage(0);
}
#ifdef NONMATCHING
void mgEndFrame(mgCDrawManager *manager) {
    sceGsDBuff *buffers = (sceGsDBuff *)mgDBuff;
    static int       count = 1;
    static float     cpu_ratio = 0.0f;
    static float     free_ratio = 0.0f;
    static u_long128 store_data[256];
    sceGsStoreImage  store_image;
    sceGsDispEnv    *display;
    sceGsFrame      *frame;
    float            frame_ticks;
    float            packet_free;
    float            data_free;
    int              wait_start;
    int              sample;
    int              pixel;
    int              depth;
    int              top;
    int              magnification;
    u_long           display_base;
    u_long           display_position;

    frame_ticks = (float)(mgFrameRate * 262);
    cpu_ratio = 100.0f * ((u_int)(*(volatile u_int *)0x10000000 - h_count) / frame_ticks);
    mgWaitFrame();
    wait_start = *(volatile u_int *)0x10000000;
    if (draw_performance_meter != 0) {
        packet_free = 100.0f * (float)(mgDrawManager.packet_memory->stack_size - mgDrawManager.packet_memory->stack_used) / (float)mgDrawManager.packet_memory->stack_size;
        data_free = 100.0f * (float)(mgDrawManager.data_memory->stack_size - mgDrawManager.data_memory->stack_used) / (float)mgDrawManager.data_memory->stack_size;

        mgCDrawPrim prim;

        prim.Initialize(NULL, NULL);
        prim.DepthTestEnable(0);
        prim.TextureMapEnable(0);
        prim.AlphaBlendEnable(1);
        prim.ZMask(-1);
        prim.Begin(SCE_GS_PRIM_SPRITE);
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
        if (cpu_ratio > 100.0f) {
            prim.Color(255, 0, 0, 64);
        } else if (cpu_ratio > 50.0f) {
            prim.Color(0, 64, 64, 64);
        } else {
            prim.Color(0, 0, 128, 64);
        }
        prim.Vertex(mgScreenWidth, top, 0);
        prim.Vertex((float)mgScreenWidth - cpu_ratio, (float)(top + 8), 0.0f);
        prim.Vertex((float)mgScreenWidth - (100.0f - free_ratio), (float)(top + 12), 0.0f);
        prim.Vertex(mgScreenWidth - 100, top + 16, 0);
        prim.Color(0, 128, 0, 64);
        prim.Vertex(mgScreenWidth, top + 20, 0);
        prim.Vertex((float)mgScreenWidth - packet_free, (float)(top + 24), 0.0f);
        prim.Vertex(mgScreenWidth, top + 28, 0);
        prim.Vertex((float)mgScreenWidth - data_free, (float)(top + 32), 0.0f);
        prim.End();
    }
    mgEndPacket(NULL);
    for (sample = 0; sample < 4; sample++) {
        if (mgPickZBuff[sample].enable != 0) {
            if (mgPickZBuff[sample].x < 4 || mgScreenWidth - 4 < mgPickZBuff[sample].x || mgPickZBuff[sample].y < 4 || mgScreenHeight - 4 < mgPickZBuff[sample].y) {
                mgPickZBuff[sample].z = -1;
            } else {
                sceGsSetDefStoreImage(&store_image, mgZBUF_1.bits.zbp * 2048 / 64, mgScreenWidth / 64, 0x30, mgPickZBuff[sample].x - 4, mgPickZBuff[sample].y - 4, 8, 8);
                FlushCache(0);
                sceGsExecStoreImage(&store_image, store_data);
                sceGsSyncPath(0, 0);
                depth = ((u_int *)store_data)[0] & 0xFFFFFF;
                for (pixel = 0; pixel < 64; pixel++) {
                    if ((int)(((u_int *)store_data)[pixel] & 0xFFFFFF) < depth) {
                        depth = ((u_int *)store_data)[pixel] & 0xFFFFFF;
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
    display = mgDBuffID != 0 ? &buffers->disp1 : &buffers->disp0;
    if (mgAntialiasing != 0) {
        display->pmode = 0x7F23;
    } else {
        *(volatile u_long *)0x12000000 = 0xFF23;
        display->pmode = 0xFF23;
    }
    display->bgcolor = 0;
    display->smode2 = 1;
    frame = mgDBuffID != 0 ? &buffers->draw1.frame1 : &buffers->draw0.frame1;
    magnification = 3;
    if (mgScreenWidth == 512) {
        magnification = 4;
    }
    display_base = frame->FBP | (frame->FBW << 9) | (frame->PSM << 15);
    display_position = 0x290 | ((u_long)((524 - mgScreenHeight) / 2 + 72) << 12) | ((u_long)magnification << 23);
    display->dispfb = display_base;
    *(u_long *)&display->display = display_position | ((u_long)(mgScreenWidth * (magnification + 1) - 1) << 32) | ((u_long)(mgScreenHeight - 1) << 44);
    FlushCache(0);
    sceGsSwapDBuff(buffers, mgDBuffID);
    sceDmaSync(DmaCH2, 0, 0);
    display_base = frame->FBP | (frame->FBW << 9) | (frame->PSM << 15);
    *(volatile u_long *)0x12000070 = display_base | ((u_long)0x800 << 32);
    *(volatile u_long *)0x12000080 = display_position | ((u_long)(mgScreenWidth * (magnification + 1) - 1) << 32) | ((u_long)(mgScreenHeight - 2) << 44);
    *(volatile u_long *)0x12000090 = display_base;
    *(volatile u_long *)0x120000A0 = display_position | ((u_long)(mgScreenWidth * (magnification + 1) - 1) << 32) | ((u_long)(mgScreenHeight - 2) << 44);
    mgNowFrameRate = (u_int)(*(volatile u_int *)0x10000000 - h_count) / 262.0f;
    if (mgNowFrameRate - (float)mgFrameRate > 1.0f) {
        free_ratio = 0.0f;
        mgNowFrameRate = 1.0f + (float)mgFrameRate;
    } else {
        free_ratio = 100.0f * ((u_int)(*(volatile u_int *)0x10000000 - wait_start) / frame_ticks);
    }
    count++;
    if (60 / mgFrameRate < count) {
        count = 0;
    }
    mgSendPacket(NULL);
    mgDBuffID = !mgDBuffID;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mglib", mgEndFrame__FP14mgCDrawManager);
#endif
void mgSendPacket(mgCDrawManager *manager) {
    DmaCH1 = sceDmaGetChan(1);
    DmaCH1->chcr.TTE = 1;
    FlushCache(0);
    sceDmaSend(DmaCH1, mgVif1Packet->pBase);
    mgDataID = !mgDataID;
}
void mgEndPacket(mgCDrawManager *manager) {
    sceVif1PkEnd(mgVif1Packet, 0);
    sceVif1PkTerminate(mgVif1Packet);
}
void mgWaitFrame(void) {
    if (sceGsSyncPath(0, 0) < 0) {
        printf(at_715);
        printf(at_716, *(int *)mgVif1Packet);
        Exit__2(-1);
    }
}
int mgDraw(mgCFrame *frame) {
    if (frame != NULL)
        return frame->Draw();
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
    int size = visual->Draw((u_int *)*(int *)mgVif1Packet, matrix, 0);
    sceVif1PkReserve(mgVif1Packet, size * 4);
    return size;
}
void mgDrawDirectStart(void) {
    sceVif1PkTerminate(mgVif1Packet);
    ddraw_size = 0;
}
int mgDrawDirect2(mgCFrame *frame) {
    if (frame == NULL) {
        return 0;
    }
    int offset = ddraw_size << 4;
    int size = frame->Draw((u_int *)(*(int *)mgVif1Packet + offset));
    ddraw_size += size;
    return size;
}
void mgDrawDirectEnd(void) {
    if ((int)ddraw_size > 0) {
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
#ifdef NONMATCHING
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
        alpha.bits.fix = 64;
        alpha.bits.a = SCE_GS_ALPHA_ZERO;
        alpha.bits.b = SCE_GS_ALPHA_CD;
        alpha.bits.c = SCE_GS_ALPHA_AS;
        alpha.bits.d = SCE_GS_ALPHA_CD;
        prim.Direct(SCE_GS_ALPHA_1, alpha.value);
        texa.TA0 = 48;
        texa.TA1 = 128;
        texa.AEM = 1;
        prim.Direct(SCE_GS_TEXA, *(u_long *)&texa);
        prim.TextureCrd(1, 1);
        prim.Vertex(0, 0, 0);
        prim.TextureCrd(texture.width - 1, texture.height - 1);
        prim.Vertex(mgScreenWidth, mgScreenHeight, 0);
        texa.TA0 = 0;
        texa.TA1 = 128;
        texa.AEM = 1;
        prim.Direct(SCE_GS_TEXFLUSH, 0);
        prim.Direct(SCE_GS_TEXA, *(u_long *)&texa);
        prim.End();
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mglib", mgEndDrawShadow__FP10mgCTextureP10mgCTexture);
#endif
void mgSetRenderInfo(float fov, float clip_near, float clip_far) {
    mgRenderInfo.SetRenderInfo(fov, mgScreenWidth, mgScreenHeight, clip_near, clip_far,
                               mgScreenZDepth, 2096.0f / (3.0f * (float)mgScreenWidth));
}
void mgSetProjection(float fov) {
    mgSetRenderInfo(fov, mgRenderInfo.clip_min[2], mgRenderInfo.clip_max[2]);
    mgSetViewMatrix(mgRenderInfo.view, mgRenderInfo.camera_pos);
}
float mgGetProjection(void) {
    return mgRenderInfo.projection;
}
void mgSetBackGround(float *color) {
    sceVu0CopyVector(mgBackColor, color);
}
void mgSetBackGround(float red, float green, float blue, float alpha) {
    float vector[4];
    *(u_long128 *)vector = *(u_long128 *)at_863;
    vector[0] = red;
    vector[1] = green;
    vector[2] = blue;
    vector[3] = alpha;
    mgSetBackGround(vector);
}
void mgInitLighting(void) {
    mgRenderInfo.InitLighting();
    mgChangeLight = 1;
}
void mgInitActiveLighting(void) {
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
void mgResetPlight(void) {
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
int mgGetFogEnable(void) {
    return mgRenderInfo.GetFogEnable();
}
void mgPlightEnable(int enabled) {
    mgRenderInfo.PlightEnable(enabled);
}
int mgGetPlightEnable(void) {
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
struct mgFogColor {
    u_char values[4];
};
struct mgFogVector {
    float values[4];
};
void mgGetFogParam(mgFOG_PARAM *param) {
    param->near_dist = mgRenderInfo.fog.near_dist;
    param->far_dist = mgRenderInfo.fog.far_dist;
    *(mgFogColor *)&param->r = *(mgFogColor *)&mgRenderInfo.fog.r;
    param->offset = mgRenderInfo.fog.offset;
    param->far_value = mgRenderInfo.fog.far_value;
    param->near_value = mgRenderInfo.fog.near_value;
    param->scale = mgRenderInfo.fog.scale;
    *(mgFogVector *)param->coef = *(mgFogVector *)mgRenderInfo.fog.coef;
}
void mgSetAllScissorFlag(int flag) {
    mgRenderInfo.all_scissor = flag;
}
void mgFlushRenderInfo(void) {
    sceVif1Packet *packet = mgVif1Packet;
    sceVif1PkTerminate(mgVif1Packet);
    u_int *words = packet->pCurrent;

    words[0] = 0x10000004;
    words[1] = 0;
    words[2] = 0;
    words[3] = 0x6C01003B;
    words[4] = *(u_int *)&mgRenderInfo.fog.offset;
    words[5] = *(u_int *)&mgRenderInfo.fog.near_value;
    words[6] = *(u_int *)&mgRenderInfo.fog.far_value;
    words[7] = *(u_int *)&mgRenderInfo.fog.scale;
    words[8] = 0;
    words[9] = 0;
    words[10] = 0;

    words[11] = 0x6C020039;
    *(u_long128 *)&words[12] = *(u_long128 *)mgRenderInfo.guard_max;
    *(u_long128 *)&words[16] = *(u_long128 *)mgRenderInfo.guard_min;
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
    sceVif1PkOpenGifTag(packet, *(u_long128 *)&mgGiftagAD);
    sceVif1PkAddGsAD(packet, gs_clamp1, *(u_long *)&clamp);
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
#ifdef NONMATCHING
void mgSetPkFrameBuffer(int fbp, int width, int height, int psm) {
    sceGsDBuff *buffers = (sceGsDBuff *)mgDBuff;
    mgCTexture *frame_texture = (mgCTexture *)&frame_tex;
    sceGsFrame     frame;
    sceGsFrame    *default_frame;
    sceGsXyOffset  offset;
    sceGsScissor   scissor;
    sceVif1Packet *vif;
    u_int         *packet;
    u_long        *registers;
    int            screen_width;
    int            screen_height;
    int            aligned_width;
    int            width_shift;
    int            height_shift;
    int            size;
    short          bpp;
    int            bit;

    default_frame = mgDBuffID != 0 ? &buffers->draw0.frame1 : &buffers->draw1.frame1;
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
    frame = *default_frame;
    frame.FBP = fbp;
    frame.FBW = aligned_width / 64;
    frame.PSM = psm;
    frame.bits.fbmsk = 0;
    mgFRAME_1 = frame;
    mgScreenOffx = 0x800 - width / 2;
    mgScreenOffy = 0x800 - height / 2;
    offset.OFX = (short)mgScreenOffx * 16;
    offset.OFY = (short)mgScreenOffy * 16;
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
    registers = (u_long *)&packet[8];
    registers[0] = 0;
    registers[1] = SCE_GS_TEXFLUSH;
    registers[2] = frame.value;
    registers[3] = SCE_GS_FRAME_1;
    registers[4] = *(u_long *)&offset;
    registers[5] = SCE_GS_XYOFFSET_1;
    registers[6] = *(u_long *)&scissor;
    registers[7] = SCE_GS_SCISSOR_1;
    registers[8] = 0;
    registers[9] = SCE_GS_SCANMSK;
    registers[10] = 0;
    registers[11] = SCE_GS_TEXFLUSH;
    sceVif1PkReserve(vif, 32);
    bpp = 0;
    switch (psm) {
        case SCE_GS_PSMCT32:
            bpp = 32;
            break;
        case SCE_GS_PSMCT24:
            bpp = 24;
            break;
        case SCE_GS_PSMCT16:
        case SCE_GS_PSMCT16S:
            bpp = 16;
            break;
    }
    frame_texture->Initialize();
    frame_texture->width = width;
    frame_texture->height = height;
    frame_texture->bpp = bpp;
    frame_texture->vram_size = bpp * (width * height) / 8 / 256;
    frame_texture->clut_size = 0;
    frame_texture->image_blocks = frame_texture->vram_size;
    frame_texture->tex0.value = 0;
    frame_texture->tex0.TBP0 = fbp << 5;
    frame_texture->tex0.TBW = width / 64;
    frame_texture->tex0.PSM = psm;
    width_shift = 0;
    for (size = width; size >= 2; size >>= 1) {
        width_shift++;
    }
    size = 1;
    for (bit = 0; bit < width_shift; bit++) {
        size *= 2;
    }
    if (width != size) {
        width_shift++;
    }
    height_shift = 0;
    for (size = height; size >= 2; size >>= 1) {
        height_shift++;
    }
    size = 1;
    for (bit = 0; bit < height_shift; bit++) {
        size *= 2;
    }
    if (height != size) {
        height_shift++;
    }
    frame_texture->tex0.bits.tw = width_shift;
    frame_texture->tex0.bits.th = height_shift;
    frame_texture->tex0.bits.tcc = 1;
    frame_texture->tex0.bits.tfx = 0;
    *(u_long *)&frame_texture->tex1 = 0x261;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mglib", mgSetPkFrameBuffer__Fiiii);
#endif
void mgGetFrameBuffer(mgCTexture *texture) {
    *(mgFrameTextureCopy *)texture = frame_tex;
}
void mgGetFrameBackBuffer(mgCTexture *texture) {
    u_char *draw_env;
    if (mgDBuffID != 0) {
        draw_env = mgDBuff + dbuff_draw_env_b;
    } else {
        draw_env = mgDBuff + dbuff_draw_env_a;
    }
    *(mgFrameTextureCopy *)texture = frame_tex;
    texture->tex0.TBP0 = (*(u_short *)draw_env & 0x1FF) * 32;
}
mgCDrawEnv *mgGetpDrawEnv(int which) {
    u_int index = (u_int)which > 0;
    return &mgRenderInfo.draw_env[index];
}
void mgSetPkMoveImage(mgCTexture *source, mgRect<int> rect, mgCTexture *destination, int extra0,
                      int extra1, int extra2) {
    if (source == NULL || destination == NULL) {
        return;
    }
    mgSetPkMoveImage(&source->tex0, rect, &destination->tex0, extra0, extra1, extra2);
}
#ifdef NONMATCHING
void mgSetPkMoveImage(sceGsTex0 *src, mgRect<int> src_rect, sceGsTex0 *dst, int dst_x, int dst_y, int direction) {
    sceVif1Packet *vif;
    int            src_width;
    int            dst_width;
    int            left;
    int            top;
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
    if (src_rect.right - src_rect.left + 1 > 0 && src_rect.bottom - src_rect.top + 1 > 0) {
        left = src_rect.left / 16;
        top = src_rect.top / 16;
        right = src_rect.right / 16;
        bottom = src_rect.bottom / 16;
        sceVif1PkCnt(vif, 0);
        sceVif1PkOpenDirectCode(vif, 0);
        sceVif1PkOpenGifTag(vif, *(u_long128 *)&mgGiftagAD);
        sceVif1PkAddGsAD(vif, SCE_GS_BITBLTBUF, SCE_GS_SET_BITBLTBUF(src->TBP0, src_width / 64, src->PSM, dst->TBP0, dst_width / 64, dst->PSM));
        sceVif1PkAddGsAD(vif, SCE_GS_TRXPOS, SCE_GS_SET_TRXPOS(left, top, dst_x >> 4, dst_y >> 4, direction));
        sceVif1PkAddGsAD(vif, SCE_GS_TRXREG, SCE_GS_SET_TRXREG(right - left + 1, bottom - top + 1));
        sceVif1PkAddGsAD(vif, SCE_GS_TRXDIR, SCE_GS_LOCAL_LOCAL);
        sceVif1PkCloseGifTag(vif);
        sceVif1PkCloseDirectCode(vif);
        sceVif1PkCnt(vif, 0);
        sceVif1PkOpenDirectCode(vif, 0);
        sceVif1PkOpenGifTag(vif, *(u_long128 *)&mgGiftagAD);
        sceVif1PkAddGsAD(vif, SCE_GS_TEXFLUSH, 0);
        sceVif1PkCloseGifTag(vif);
        sceVif1PkCloseDirectCode(vif);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mglib", mgSetPkMoveImage__FP9sceGsTex09mgRect_i_P9sceGsTex0iii);
#endif
void mgSetPkMoveImage(mgCTexture *source, mgRect<int> source_rect, mgCTexture *destination,
                      mgRect<int> destination_rect, mgCDrawEnv *draw_env) {
    if (source == NULL || destination == NULL) {
        return;
    }
    mgSetPkMoveImage(&source->tex0, source_rect, &destination->tex0, destination->height,
                     destination_rect, draw_env);
}
#ifdef NONMATCHING
void mgSetPkMoveImage(sceGsTex0 *src, mgRect<int> src_rect, sceGsTex0 *dst, int dst_height, mgRect<int> dst_rect, mgCDrawEnv *env) {
    sceVif1Packet *vif;
    sceGsTest      test;
    sceGsZbuf      zbuf;
    sceGsAlpha     alpha;
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
    sceVif1PkOpenGifTag(vif, *(u_long128 *)&mgGiftagAD);
    sceVif1PkAddGsAD(vif, SCE_GS_TEXFLUSH, 0);
    if (env != NULL) {
        sceVif1PkAddGsAD(vif, SCE_GS_TEST_1, env->test.value);
        zbuf = mgZBUF_1;
        zbuf.bits.zmsk = env->zbuf.bits.zmsk;
        sceVif1PkAddGsAD(vif, SCE_GS_ZBUF_1, *(u_long *)&zbuf);
        sceVif1PkAddGsAD(vif, SCE_GS_ALPHA_1, env->alpha.value);
    } else {
        test = mgTEST_1;
        test.bits.ate = 0;
        test.bits.zte = 1;
        test.bits.ztst = SCE_GS_ALWAYS;
        test.bits.date = 0;
        sceVif1PkAddGsAD(vif, SCE_GS_TEST_1, *(u_long *)&test);
        zbuf = mgZBUF_1;
        zbuf.bits.zmsk = 1;
        sceVif1PkAddGsAD(vif, SCE_GS_ZBUF_1, *(u_long *)&zbuf);
        alpha = mgALPHA_1;
        alpha.bits.a = SCE_GS_ALPHA_ZERO;
        alpha.bits.b = SCE_GS_ALPHA_ZERO;
        alpha.bits.c = SCE_GS_ALPHA_FIX;
        alpha.bits.d = SCE_GS_ALPHA_CS;
        sceVif1PkAddGsAD(vif, SCE_GS_ALPHA_1, *(u_long *)&alpha);
    }
    sceVif1PkAddGsAD(vif, SCE_GS_TEX1_1, 0x25);
    sceVif1PkAddGsAD(vif, SCE_GS_TEX0_1, *(u_long *)src);
    sceVif1PkAddGsAD(vif, SCE_GS_PRMODECONT, 1);
    sceVif1PkAddGsAD(vif, SCE_GS_PRIM, 0x116);
    sceVif1PkAddGsAD(vif, SCE_GS_RGBAQ, 0x80808080);
    sceVif1PkAddGsAD(vif, SCE_GS_UV, (u_long)src_rect.left | ((u_long)src_rect.top << 16));
    sceVif1PkAddGsAD(vif, SCE_GS_XYZF2, (u_long)(mgScreenOffx * 16 + dst_rect.left) | ((u_long)(mgScreenOffy * 16 + dst_rect.top) << 16));
    sceVif1PkAddGsAD(vif, SCE_GS_UV, (u_long)src_rect.right | ((u_long)src_rect.bottom << 16));
    sceVif1PkAddGsAD(vif, SCE_GS_XYZF2, (u_long)(mgScreenOffx * 16 + dst_rect.right) | ((u_long)(mgScreenOffy * 16 + dst_rect.bottom) << 16));
    sceVif1PkAddGsAD(vif, SCE_GS_TEXFLUSH, 0);
    sceVif1PkCloseGifTag(vif);
    sceVif1PkCloseDirectCode(vif);
    mgSetPkFrameBuffer(-1, -1, -1, -1);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mglib", mgSetPkMoveImage__FP9sceGsTex09mgRect_i_P9sceGsTex0i9mgRect_i_P10mgCDrawEnv);
#endif
void mgSetPkClearScreen(u_char red, u_char green, u_char blue, u_char alpha) {
    sceVif1Packet *packet = mgVif1Packet;
    sceVif1PkCnt(mgVif1Packet, 0);
    sceVif1PkOpenDirectCode(packet, 0);
    sceVif1PkOpenGifTag(packet, *(u_long128 *)&mgGiftagAD);
    sceVif1PkAddGsAD(packet, gs_texflush, 0);
    sceVif1PkCloseGifTag(packet);
    sceVif1PkCloseDirectCode(packet);
    sceVif1PkCnt(packet, 0);
    sceVif1PkOpenDirectCode(packet, 0);
    sceVif1PkOpenGifTag(packet, *(u_long128 *)&mgGiftagAD);
    sceGsTest test = mgTEST_1;
    test.bits.ate = 0;
    test.bits.zte = 1;
    test.bits.ztst = 1;
    test.bits.date = 0;
    sceVif1PkAddGsAD(packet, gs_test1, *(u_long *)&test);
    sceGsZbuf zbuf = mgZBUF_1;
    zbuf.bits.zmsk = 0;
    sceVif1PkAddGsAD(packet, gs_zbuf1, *(u_long *)&zbuf);
    sceGsAlpha blend = mgALPHA_1;
    blend.bits.a = 2;
    blend.bits.b = 2;
    blend.bits.c = 2;
    blend.bits.d = 0;
    sceVif1PkAddGsAD(packet, gs_alpha1, *(u_long *)&blend);
    sceVif1PkAddGsAD(packet, gs_tex1_1, 1);
    sceVif1PkAddGsAD(packet, gs_prim, 0x146);
    sceVif1PkAddGsAD(packet, gs_rgbaq,
                     (u_long)red | ((u_long)green << 8) | ((u_long)blue << 16) |
                         ((u_long)alpha << 24));
    for (int x = 0; x < mgScreenWidth * 16; x += 0x200) {
        int left = (mgScreenOffx << 4) + x;
        sceVif1PkAddGsAD(packet, gs_xyzf2,
                         ((long long)(int)(mgScreenOffy << 4) << 16) | (long long)left);
        int right = (mgScreenOffx << 4) + x + 0x200;
        sceVif1PkAddGsAD(packet, gs_xyzf2,
                         ((long long)(int)(((int)mgScreenOffy + mgScreenHeight) << 4) << 16) |
                             (long long)right);
    }
    sceVif1PkAddGsAD(packet, gs_texflush, 0);
    sceVif1PkCloseGifTag(packet);
    sceVif1PkCloseDirectCode(packet);
}
int mgStoreImage(mgCTexture *texture, u_long128 *buffer) {
    sceGsStoreImage store_image;
    int block_width;
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
#ifdef NONMATCHING
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
    sceGsSetDefStoreImage(&image, mgZBUF_1.bits.zbp * 2048 / 64, mgScreenWidth / 64, 0x30, rect.left, rect.top, width, height);
    FlushCache(0);
    sceGsExecStoreImage(&image, buffer);
    sceGsSyncPath(0, 0);
    depth = (u_int *)buffer;
    for (pixel = 0; pixel < width * height; pixel++) {
        depth[pixel] &= 0xFFFFFF;
    }
    return width * height / 4;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mglib", mgStoreZBuffImage__FR9mgRect_i_P1);
#endif
float mgConvZBuffToDist(u_int zbuf) {
    return mgRenderInfo.view_screen[3][2] / ((float)zbuf - mgRenderInfo.view_screen[2][2]);
}
mgCTexture *mgGetTextureZ(int index) {
    if (index < 0 || index > 1) {
        return 0;
    }
    return &fixz_tex[index];
}
int prim_clip_check(float *vertex) {
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
    float pos[4];
    *(u_long128 *)pos = *(u_long128 *)at_1389;
    int screen[4];
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
    *(u_long128 *)out = *(u_long128 *)mgRenderInfo.camera_pos;
}
void mgGetCameraPose(float (*pose)[4]) {
    *(u_long128 *)pose[0] = *(u_long128 *)mgRenderInfo.camera_pose[0];
    *(u_long128 *)pose[1] = *(u_long128 *)mgRenderInfo.camera_pose[1];
    *(u_long128 *)pose[2] = *(u_long128 *)mgRenderInfo.camera_pose[2];
    *(u_long128 *)pose[3] = *(u_long128 *)mgRenderInfo.camera_pose[3];
}
#ifdef NONMATCHING
int mgTransWorldPrim3DSprite(int *top_left, int *bottom_right, float *position, float width, float height, int unused) {
    sceVu0FVECTOR projected;
    sceVu0FVECTOR first;
    sceVu0FVECTOR second;
    float         scaled_width;
    float         scaled_height;
    float         reciprocal;
    float         half_width;
    float         half_height;
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
    sceVu0CopyVector(first, projected);
    sceVu0CopyVector(second, projected);
    half_width = 0.5f * (scaled_width * reciprocal);
    first[0] -= half_width;
    half_height = 0.5f * (scaled_height * reciprocal);
    first[1] -= half_height;
    second[0] += half_width;
    second[1] += half_height;
    top_left[0] = (int)(16.0f * first[0]);
    top_left[1] = (int)(16.0f * first[1]);
    top_left[2] = (int)first[2];
    top_left[3] = 0;
    bottom_right[0] = (int)(16.0f * second[0]);
    bottom_right[1] = (int)(16.0f * second[1]);
    bottom_right[2] = (int)second[2];
    bottom_right[3] = 0;
    visible = prim_clip_check(first);
    return visible & prim_clip_check(second);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mglib", mgTransWorldPrim3DSprite__FPiPiPfffi);
#endif
#pragma global_optimizer off
static int CheckVuProgID(int id) {
    if (id < user_vu_prog_base) {
        if (id <= -1)
            return 0;
        if (id >= builtin_vu_prog_count)
            return 0;
        goto valid;
    }
    if (id < user_vu_prog_base)
        return 0;
    if (id >= user_prog_num + user_vu_prog_base)
        return 0;
    if (user_prog_adr == 0)
        return 0;
    if (*(int *)((id << 2) + (int)user_prog_adr - user_vu_prog_base * 4) == 0)
        return 0;
valid:
    return 1;
}
#pragma global_optimizer reset
u_long128 *mgGetVuProgPacket(int id) {
    if (CheckVuProgID(id) == 0)
        return NULL;
    if (id < user_vu_prog_base)
        return prog_adr[id];
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
        tag[1] = (u_int)packet;
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
    if (index < 0 || index >= user_prog_num)
        return;
    u_char *base = (u_char *)user_prog_adr;
    index <<= 2;
    *(u_long128 **)(base + index) = adr;
}
#pragma global_optimizer reset
#ifdef NONMATCHING
void StoreImage(int front_buffer) {
    static int image_num = 0;
    u_char     tga[18] = { 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 24, 0 };
    char       device[128];
    char       filename[128];
    char      *character;
    u_char    *row;
    u_char     red;
    int        file;
    int        y;
    int        pixel;
    int        output;

    tga[12] = mgScreenWidth;
    tga[14] = mgScreenHeight;
    tga[13] = mgScreenWidth >> 8;
    tga[15] = mgScreenHeight >> 8;
    strcpy(device, "host0:");
    sprintf(filename, "%si%5d.tga", device, image_num++);
    for (character = filename; *character != '\0'; character++) {
        if (*character == ' ') {
            *character = '0';
        }
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
    sceGsExecStoreImage(&gs_simage, (u_long128 *)0x2100000);
    sceGsSyncPath(0, 0);
    sceWrite(file, tga, 18);
    for (y = 0; y < mgScreenHeight; y++) {
        row = (u_char *)((u_long128 *)0x2100000 + mgScreenWidth * (mgScreenHeight - y - 1) / 4);
        for (pixel = 0, output = 0; pixel < mgScreenWidth * 4; pixel += 4, output += 3) {
            red = row[pixel];
            row[pixel] = row[pixel + 2];
            row[pixel + 2] = red;
            row[output] = row[pixel];
            row[output + 1] = row[pixel + 1];
            row[output + 2] = row[pixel + 2];
        }
        row = (u_char *)((u_long128 *)0x2100000 + mgScreenWidth * (mgScreenHeight - y - 1) / 4);
        sceWrite(file, row, mgScreenWidth * 3);
    }
    sceClose(file);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mglib", StoreImage__Fi);
#endif
int mgInitFont(void) {
    sceDevConsInit();
    font_cons = sceDevConsOpen((mgScreenOffx + 8) * 0x10, (mgScreenOffy + 8) * 0x10, 0x28, 0x18);
    return font_cons;
}
void mgCloseFont(void) {
    if ((int)font_cons >= 0) {
        sceDevConsClose(font_cons);
    }
    font_draw_flag = 0;
}
extern "C" mgCMemory *__ct__9mgCMemoryFv(mgCMemory *memory) {
    memory->Init();
    return memory;
}

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mglib", __sinit_mglib_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mglib", dimx_281__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mglib", at_1389__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mglib", prog_adr__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mglib", at_1538__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mglib", at_715__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mglib", at_716__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mglib", at_1568__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mglib", at_1569__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mglib", D_0037AFE8__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mglib", font_cons__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mglib", rot_priority__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mglib", now_prog_id__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(mgAntialiasing, 0x4);
INCLUDE_BSS(mgFrameRate, 0x4);
INCLUDE_BSS(mgNowFrameRate, 0x4);
INCLUDE_BSS(DmaCH1, 0x4);
INCLUDE_BSS(DmaCH2, 0x4);
INCLUDE_BSS(DmaCH8, 0x4);
INCLUDE_BSS(mgVif1Packet, 0x4);
INCLUDE_BSS(mgClearBackFlag, 0x4);
INCLUDE_BSS(mgScreenMode, 0x4);
INCLUDE_BSS(mgScreenWidth, 0x4);
INCLUDE_BSS(mgScreenHeight, 0x4);
INCLUDE_BSS(mgScreenNX, 0x4);
INCLUDE_BSS(mgScreenNY, 0x4);
INCLUDE_BSS(mgScreenMX, 0x4);
INCLUDE_BSS(mgScreenMY, 0x4);
INCLUDE_BSS(mgScreenOffx, 0x4);
INCLUDE_BSS(mgScreenOffy, 0x4);
INCLUDE_BSS(mgScreenDepth, 0x4);
INCLUDE_BSS(mgScreenZDepth, 0x4);
INCLUDE_BSS(mgScreenLeft, 0x4);
INCLUDE_BSS(mgScreenRight, 0x4);
INCLUDE_BSS(mgScreenTop, 0x4);
INCLUDE_BSS(mgScreenBottom, 0x4);
INCLUDE_BSS(VSyncField, 0x8);
INCLUDE_BSS(mgTEX1_1, 0x8);
INCLUDE_BSS(mgTEX1_2, 0x8);
INCLUDE_BSS(mgTEST_1, 0x8);
INCLUDE_BSS(mgTEST_2, 0x8);
INCLUDE_BSS(mgZBUF_1, 0x8);
INCLUDE_BSS(mgZBUF_2, 0x8);
INCLUDE_BSS(mgALPHA_1, 0x8);
INCLUDE_BSS(mgALPHA_2, 0x8);
INCLUDE_BSS(mgTEXA_1, 0x8);
INCLUDE_BSS(mgTEXA_2, 0x8);
INCLUDE_BSS(mgFRAME_1, 0x8);
INCLUDE_BSS(mgDBuffID, 0x4);
INCLUDE_BSS(mgDataID, 0x4);
INCLUDE_BSS(mgChangeLight, 0x8);
INCLUDE_BSS(packetbuf, 0x8);
INCLUDE_BSS(packet_size, 0x4);
INCLUDE_BSS(frame_buf0, 0x4);
INCLUDE_BSS(frame_buf1, 0x4);
INCLUDE_BSS(font_draw_flag, 0x4);
INCLUDE_BSS(draw_performance_meter, 0x8);
INCLUDE_BSS(mgDIMX, 0x8);
INCLUDE_BSS(vcount, 0x4);
INCLUDE_BSS(old_vcount, 0x4);
INCLUDE_BSS(over_vsync, 0x4);
INCLUDE_BSS(VSyncCallBack2, 0x4);
INCLUDE_BSS(call_back_active, 0x4);
INCLUDE_BSS(h_count, 0x4);
INCLUDE_BSS(capture_on, 0x4);
INCLUDE_BSS(cap_ture_cnt, 0x4);
INCLUDE_BSS(count_580, 0x4);
INCLUDE_BSS(init_581, 0x4);
INCLUDE_BSS(cpu_ratio_583, 0x4);
INCLUDE_BSS(init_584, 0x4);
INCLUDE_BSS(free_ratio_586, 0x4);
INCLUDE_BSS(init_587, 0x4);
INCLUDE_BSS(ddraw_size, 0x4);
INCLUDE_BSS(user_prog_adr, 0x4);
INCLUDE_BSS(user_prog_num, 0x4);
INCLUDE_BSS(image_num_1535, 0x4);
INCLUDE_BSS(init_1536, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(mgGiftagAD, 0x10);
INCLUDE_BSS(mgRenderInfo, 0x1020);
INCLUDE_BSS(mgBackColor, 0x10);
INCLUDE_BSS(mgTexManager, 0x220);
INCLUDE_BSS(mgDrawManager, 0x80);
INCLUDE_BSS(mgDBuff, 0x230);
INCLUDE_BSS(mgPickZBuff, 0x40);
INCLUDE_BSS(vifpacket, 0x40);
INCLUDE_BSS(packet_buf, 0x60);
INCLUDE_BSS(data_buf, 0x60);
INCLUDE_BSS(frame_tex, 0x70);
INCLUDE_BSS(store_data_614, 0x1000);
INCLUDE_BSS(at_863, 0x10);
INCLUDE_BSS(fixz_tex, 0xE0);
INCLUDE_BSS(gs_simage, 0xA0);
