#include "common.h"
#include "outline.hpp"

#include "mg_math.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_texture.hpp"
#include "mg_tanime.hpp"
#include "mglib.hpp"

// Code (.text)
void COutLineDraw::Initialize() {
    mgZeroVector(unk_10.max);
    mgZeroVector(unk_10.min);
    frame = NULL;
    texture = NULL;
    width = 0.0f;
    depth_from_pos = 0;
    color[0] = 80.0f;
    color[1] = 60.0f;
    color[2] = 0.0f;
    color[3] = 128.0f;
    enable = 1;
    hide_edge = 0;
    next = NULL;
}
void COutLineDraw::SetFrame(mgCFrame *new_frame) {
    frame = new_frame;
}
static void DrawDivSprite(mgCDrawPrim *prim, mgRect<int> rect, mgCTexture *texture,
                          int *color, int dx, int dy, int z, int unused);
static void DrawDivSprite4(mgCDrawPrim *prim, mgRect<int> rect, mgCTexture *texture,
                           int *color, int offset, int z);
extern int at_338[4];
int COutLineDraw::Draw(float *pos, float scale, float alpha) {

    *(u_long128 *)this->pos = *(u_long128 *)pos;
    return Draw(scale, alpha);
}

#ifdef NONMATCHING
int COutLineDraw::Draw(float scale, float alpha) {
    if (frame == NULL || texture == NULL || !enable) return 0;
    if (scale > 1.0f) scale = 1.0f;
    if (width <= 0.0f) {
        frame->SetAttrParamObjAlpha(alpha, 1);
        return mgDrawDirect(frame);
    }

    float scaled_width = width * scale * scale;
    float opacity = scaled_width < 1.0f ? scaled_width : 1.0f;
    if (opacity < 0.01f) opacity = 0.01f;
    int edge_offset = (int)(scaled_width * 16.0f);
    mgVu0FBOX draw_box;
    if (!mgGetDrawRect(frame, &draw_box)) return 0;
    float max_xy[4] = {(float)mgScreenWidth, (float)mgScreenHeight, 0.0f, 0.0f};
    float min_xy[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    mgVectorMaxMin(max_xy, min_xy, draw_box.max, draw_box.min, draw_box.max, draw_box.min);
    if (min_xy[0] < 0.0f) min_xy[0] = 0.0f;
    if (min_xy[1] < 0.0f) min_xy[1] = 0.0f;
    if (max_xy[0] > (float)mgScreenWidth) max_xy[0] = (float)mgScreenWidth;
    if (max_xy[1] > (float)mgScreenHeight) max_xy[1] = (float)mgScreenHeight;
    int max_corner[4], min_corner[4];
    mgFotI4(max_corner, max_xy);
    mgFotI4(min_corner, min_xy);
    mgRect<int> clear_rect(min_corner[0] - 0x80, min_corner[1] - 0x80,
                           max_corner[0] + 0x80, max_corner[1] + 0x80);
    if (clear_rect.left < 0) clear_rect.left = 0;
    if (clear_rect.top < 0) clear_rect.top = 0;
    if (clear_rect.right > mgScreenWidth * 16) clear_rect.right = mgScreenWidth * 16;
    if (clear_rect.bottom > mgScreenHeight * 16) clear_rect.bottom = mgScreenHeight * 16;

    mgSetPkFrameBuffer(texture->tex0.bits.tbp0 >> 5, -1, -1, -1);
    mgCDrawPrim clear;
    clear.Initialize(NULL, NULL);
    clear.DepthTestEnable(0);
    clear.ZMask(MG_Z_MASK_MASKED);
    clear.AlphaTestEnable(0);
    clear.Begin(MG_PRIM_SPRITE);
    clear.Color(0, 0, 0, 0);
    clear.Vertex4(clear_rect.left - 16, clear_rect.top - 16, 0);
    clear.Vertex4(clear_rect.right + 16, clear_rect.bottom + 16, 0);
    clear.End();
    int result = mgDrawDirect(frame);
    mgCTexture frame_buffer;
    mgGetFrameBuffer(&frame_buffer);
    mgSetPkFrameBuffer(-1, -1, -1, -1);

    mgRect<int> rect(min_corner[0], min_corner[1], max_corner[0], max_corner[1]);
    if (rect.left < 0) rect.left = 0;
    if (rect.top < 0) rect.top = 0;
    if (rect.right > mgScreenWidth * 16) rect.right = mgScreenWidth * 16;
    if (rect.bottom > mgScreenHeight * 16) rect.bottom = mgScreenHeight * 16;
    int edge_color[4] = {(int)color[0], (int)color[1], (int)color[2], (int)(128.0f * opacity * alpha)};
    mgCDrawPrim composite;
    composite.Initialize(NULL, NULL);
    composite.DepthTestEnable(0);
    composite.ZMask(MG_Z_MASK_MASKED);
    composite.TextureMapEnable(1);
    composite.Bilinear(1);
    composite.AlphaBlendEnable(1);
    composite.AlphaBlend(MG_ALPHA_BLEND_NORMAL);
    mgSetPkTextureRepeat(0);
    if (!hide_edge && alpha >= 1.0f && edge_offset > 0 && opacity >= 0.1f)
        DrawDivSprite4(&composite, rect, &frame_buffer, edge_color, edge_offset, 0);
    int depth = 0;
    if (depth_from_pos) {
        pos[3] = 1.0f;
        int screen[4];
        if (mgTransWorldPrim(screen, pos)) {
            composite.ZMask(MG_Z_MASK_WRITE);
            depth = screen[2];
        }
    }
    int body_color[4] = {at_338[0], at_338[1], at_338[2], (int)(128.0f * alpha)};
    composite.AlphaBlendEnable(1);
    composite.AlphaBlend(MG_ALPHA_BLEND_NORMAL);
    DrawDivSprite(&composite, rect, &frame_buffer, body_color, 0, 0, depth, 0);
    composite.Begin(MG_PRIM_SPRITE);
    composite.Direct(0x3F, 0);
    composite.End();
    return result;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/outline", Draw__12COutLineDrawFff);
#endif

#ifdef NONMATCHING
static void DrawDivSprite(mgCDrawPrim *prim, mgRect<int> rect, mgCTexture *texture,
                          int *color, int dx, int dy, int z, int unused) {
    mgRect<int> area = rect;
    sceVu0IVECTOR texcrd_end;
    sceVu0IVECTOR texcrd_start;
    sceVu0IVECTOR vertex_end;
    sceVu0IVECTOR vertex_start;
    int offset_x = dx + mgScreenOffx * 16;
    int offset_y = dy + mgScreenOffy * 16;
    int block_height = mgScreenHeight * 16;

    prim->Begin2();
    prim->BeginPrim2(MG_PRIM_SPRITE);
    prim->Texture(texture);
    prim->Color(color[0], color[1], color[2], color[3]);
    prim->EndPrim2();
    prim->BeginPrim2(MG_PRIM_SPRITE, 0x43, 0, 2);
    *(u_long128 *)vertex_start = 0;
    *(u_long128 *)vertex_end = 0;
    *(u_long128 *)texcrd_start = 0;
    *(u_long128 *)texcrd_end = 0;
    vertex_start[2] = z;
    vertex_end[2] = z;
    for (int x = area.left; x < area.right;) {
        int x_end = x + 0x200;
        if (area.right < x_end) {
            x_end = area.right;
        }
        for (int y = area.top; y < area.bottom;) {
            int y_end = y + block_height;
            if (area.bottom < y_end) {
                y_end = area.bottom;
            }
            vertex_start[0] = x;
            texcrd_start[0] = x;
            vertex_start[1] = y;
            texcrd_start[1] = y;
            vertex_start[0] += offset_x;
            vertex_start[1] += offset_y;
            vertex_end[0] = x_end;
            texcrd_end[0] = x_end;
            vertex_end[1] = y_end;
            texcrd_end[1] = y_end;
            vertex_end[0] += offset_x;
            vertex_end[1] += offset_y;
            u_long128 *packet = (u_long128 *)prim->DirectData(4);
            y = y_end;
            packet[0] = *(u_long128 *)texcrd_start;
            packet[1] = *(u_long128 *)vertex_start;
            packet[2] = *(u_long128 *)texcrd_end;
            packet[3] = *(u_long128 *)vertex_end;
        }
        x = x_end;
    }
    prim->EndPrim2();
    prim->End2();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/outline", DrawDivSprite__FP11mgCDrawPrim9mgRect_i_P10mgCTexturePiiiii);
#endif

#ifdef NONMATCHING
static void DrawDivSprite4(mgCDrawPrim *prim, mgRect<int> rect, mgCTexture *texture,
                           int *color, int offset, int z) {
    prim->Begin(MG_PRIM_SPRITE);
    prim->Texture(texture);
    prim->Color(color[0], color[1], color[2], color[3]);
    for (int x = rect.left; x < rect.right; x += 0x200) {
        int x_end = x + 0x200 < rect.right ? x + 0x200 : rect.right;
        for (int y = rect.top; y < rect.bottom; y += 0x200) {
            int y_end = y + 0x200 < rect.bottom ? y + 0x200 : rect.bottom;
            const int shift_x[4] = {offset, -offset, 0, 0};
            const int shift_y[4] = {0, 0, offset, -offset};
            for (int direction = 0; direction < 4; direction++) {
                prim->TextureCrd4(x, y);
                prim->Vertex4(x + mgScreenOffx * 16 + shift_x[direction],
                              y + mgScreenOffy * 16 + shift_y[direction], z);
                prim->TextureCrd4(x_end, y_end);
                prim->Vertex4(x_end + mgScreenOffx * 16 + shift_x[direction],
                              y_end + mgScreenOffy * 16 + shift_y[direction], z);
            }
        }
    }
    prim->End();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/outline", DrawDivSprite4__FP11mgCDrawPrim9mgRect_i_P10mgCTexturePiii);
#endif

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/outline", at_338__DATA);

// Uninitialised data (.bss)
INCLUDE_BSS(at_299__2, 0x10);
INCLUDE_BSS(at_300__2, 0x10);
INCLUDE_BSS(at_325, 0x10);
INCLUDE_BSS(at_395, 0x10);
INCLUDE_BSS(at_396, 0x10);
INCLUDE_BSS(at_398, 0x10);
INCLUDE_BSS(at_399, 0x10);
