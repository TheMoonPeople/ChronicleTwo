#include "common.h"
#include "mg_memory.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mg_frame.hpp"
#include "mg_drawenv.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"
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
extern mgCTexture frame_tex;
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mglib", mgInit__Fii);
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
    ((u_char *)&mgDBuff)[dbuff_clear_a + 0] = red;
    int green = fptosi(mgBackColor[1]);
    ((u_char *)&mgDBuff)[dbuff_clear_a + 1] = green;
    int blue = fptosi(mgBackColor[2]);
    ((u_char *)&mgDBuff)[dbuff_clear_a + 2] = blue;
    int alpha = fptosi(mgBackColor[3]);
    ((u_char *)&mgDBuff)[dbuff_clear_b + 0] = red;
    ((u_char *)&mgDBuff)[dbuff_clear_b + 1] = green;
    ((u_char *)&mgDBuff)[dbuff_clear_b + 2] = blue;
    ((u_char *)&mgDBuff)[dbuff_clear_a + 3] = alpha;
    ((u_char *)&mgDBuff)[dbuff_clear_b + 3] = alpha;
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
        draw_env = (long long *)((u_char *)&mgDBuff + dbuff_draw_env_a);
    } else {
        draw_env = (long long *)((u_char *)&mgDBuff + dbuff_draw_env_b);
    }
    mgFRAME_1.value = *draw_env;
    mgSetPkFrameBuffer(-1, -1, -1, -1);
    mgSetPkClearScreen(
        ((u_char *)&mgDBuff)[dbuff_clear_a + 0], ((u_char *)&mgDBuff)[dbuff_clear_a + 1],
        ((u_char *)&mgDBuff)[dbuff_clear_a + 2], ((u_char *)&mgDBuff)[dbuff_clear_a + 3]);
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
void mgEndDrawReloadTexture(int texture, mgCDrawManager *manager) {
    if (manager == NULL)
        manager = &mgDrawManager;
    manager->ReloadTexture(texture, mgVif1Packet);
}
void mgEndDraw(int mode, mgCDrawManager *manager) {
    if (manager == NULL)
        manager = &mgDrawManager;
    manager->Draw(mode, mgVif1Packet);
}
void mgStoreFrameImage(void) {
    StoreImage(0);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mglib", mgEndFrame__FP14mgCDrawManager);
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
    int size = frame->Draw((u_int *)((u_char *)mgVif1Packet->pCurrent + offset));
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mglib", mgEndDrawShadow__FP10mgCTextureP10mgCTexture);
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
void mgGetFogParam(mgFOG_PARAM *param) {
    param->near_dist = mgRenderInfo.fog.near_dist;
    param->far_dist = mgRenderInfo.fog.far_dist;
    param->r = mgRenderInfo.fog.r;
    param->g = mgRenderInfo.fog.g;
    param->b = mgRenderInfo.fog.b;
    param->unk_b = mgRenderInfo.fog.unk_b;
    param->offset = mgRenderInfo.fog.offset;
    param->far_value = mgRenderInfo.fog.far_value;
    param->near_value = mgRenderInfo.fog.near_value;
    param->scale = mgRenderInfo.fog.scale;
    *(u_long128 *)param->coef = *(u_long128 *)mgRenderInfo.fog.coef;
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mglib", mgSetPkFrameBuffer__Fiiii);
void mgGetFrameBuffer(mgCTexture *texture) {
    *texture = frame_tex;
}
void mgGetFrameBackBuffer(mgCTexture *texture) {
    u_char *draw_env;
    if (mgDBuffID != 0) {
        draw_env = (u_char *)&mgDBuff + dbuff_draw_env_b;
    } else {
        draw_env = (u_char *)&mgDBuff + dbuff_draw_env_a;
    }
    *texture = frame_tex;
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mglib", mgSetPkMoveImage__FP9sceGsTex09mgRect_i_P9sceGsTex0iii);
void mgSetPkMoveImage(mgCTexture *source, mgRect<int> source_rect, mgCTexture *destination,
                      mgRect<int> destination_rect, mgCDrawEnv *draw_env) {
    if (source == NULL || destination == NULL) {
        return;
    }
    mgSetPkMoveImage(&source->tex0, source_rect, &destination->tex0, destination->height,
                     destination_rect, draw_env);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mglib", mgSetPkMoveImage__FP9sceGsTex09mgRect_i_P9sceGsTex0i9mgRect_i_P10mgCDrawEnv);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mglib", mgStoreZBuffImage__FR9mgRect_i_P1);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mglib", mgTransWorldPrim3DSprite__FPiPiPfffi);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mglib", StoreImage__Fi);
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
