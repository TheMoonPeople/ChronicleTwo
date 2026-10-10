#include "common.h"

#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_tanime.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "outline.hpp"

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

int COutLineDraw::Draw(float *pos, float scale, float alpha) {

    *(u_long128 *) this->pos = *(u_long128 *) pos;
    return Draw(scale, alpha);
}

int COutLineDraw::Draw(float scale, float alpha) {
    if (frame == NULL) {
        return 0;
    }

    if (texture == NULL) {
        return 0;
    }

    if (enable == 0) {
        return 0;
    }

    int result = 0;
    int left;
    int right;
    int top;
    int bottom;
    int edge_offset;

    if (!(scale <= 1.0f)) {
        scale = 1.0f;
    }

    scale = scale * scale;

    if (width <= 0.0f) {
        frame->SetAttrParamObjAlpha(alpha, 1);
        return mgDrawDirect(frame);
    }

    float scaled_width = width * scale;
    edge_offset = (int) scaled_width;
    float opacity = 1.0f;

    if (edge_offset <= 0) {
        opacity = scaled_width;
    }

    if (opacity < 0.01f) {
        opacity = 0.01f;
    }

    edge_offset = (int) (16.0f * scaled_width);
    mgVu0FBOX draw_box;

    if (mgGetDrawRect(frame, &draw_box) == 0) {
        return 0;
    }

    float max_xy[4] = {(float) mgScreenWidth, (float) mgScreenHeight, 0.0f, 0.0f};
    float min_xy[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    mgVectorMaxMin(max_xy, min_xy, draw_box.max, draw_box.min, draw_box.max, draw_box.min);
    float screen_width = mgScreenWidth;
    float screen_height = mgScreenHeight;

    if (min_xy[0] < 0.0f) {
        min_xy[0] = 0.0f;
    }

    if (min_xy[1] < 0.0f) {
        min_xy[1] = 0.0f;
    }

    if (!(max_xy[0] <= screen_width)) {
        max_xy[0] = screen_width;
    }

    if (!(max_xy[1] <= screen_height)) {
        max_xy[1] = screen_height;
    }

    int max_corner[4];
    int min_corner[4];
    mgFotI4(max_corner, max_xy);
    mgFotI4(min_corner, min_xy);

    left = min_corner[0] - 0x80;
    right = max_corner[0] + 0x80;
    top = min_corner[1] - 0x80;
    bottom = max_corner[1] + 0x80;

    if (left < 0) {
        left = 0;
    }

    if (top < 0) {
        top = 0;
    }

    if (mgScreenWidth * 16 < right) {
        right = mgScreenWidth * 16;
    }

    if (mgScreenHeight * 16 < bottom) {
        bottom = mgScreenHeight * 16;
    }

    mgSetPkFrameBuffer(texture->tex0.TBP0 / 32, -1, -1, -1);
    mgCDrawPrim clear;
    clear.Initialize(NULL, NULL);
    clear.DepthTestEnable(0);
    clear.ZMask(MG_Z_MASK_MASKED);
    clear.AlphaTestEnable(0);
    clear.Begin(MG_PRIM_SPRITE);
    clear.Color(0, 0, 0, 0);
    clear.Vertex4(left - 16, top - 16, 0);
    clear.Vertex4(right + 16, bottom + 16, 0);
    clear.End();

    result += mgDrawDirect(frame);
    left = min_corner[0];
    top = min_corner[1];
    right = max_corner[0];
    bottom = max_corner[1];

    if (left < 0) {
        left = 0;
    }

    if (top < 0) {
        top = 0;
    }

    if (mgScreenWidth * 16 < right) {
        right = mgScreenWidth * 16;
    }

    if (mgScreenHeight * 16 < bottom) {
        bottom = mgScreenHeight * 16;
    }

    mgCTexture frame_buffer;
    mgGetFrameBuffer(&frame_buffer);
    mgSetPkFrameBuffer(-1, -1, -1, -1);

    int edge_color[4] = {0, 0, 0, 0};
    edge_color[0] = (int) color[0];
    edge_color[1] = (int) color[1];
    edge_color[2] = (int) color[2];
    edge_color[3] = (int) (128.0f * opacity * alpha);
    mgCDrawPrim composite;
    composite.Initialize(NULL, NULL);
    composite.DepthTestEnable(0);
    composite.ZMask(MG_Z_MASK_MASKED);
    composite.TextureMapEnable(1);
    composite.Bilinear(1);
    composite.AlphaBlendEnable(1);
    composite.AlphaBlend(MG_ALPHA_BLEND_NORMAL);
    mgSetPkTextureRepeat(0);

    if (hide_edge == 0 && !(alpha < 1.0f) && edge_offset > 0 && !(opacity < 0.1f)) {
        DrawDivSprite4(&composite, mgRect<int>(left, top, right, bottom), &frame_buffer, edge_color, edge_offset, 0);
    }

    int depth = 0;

    if (depth_from_pos != 0) {
        pos[3] = 1.0f;
        int screen[4];

        if (mgTransWorldPrim(screen, pos) != 0) {
            composite.ZMask(MG_Z_MASK_WRITE);
            depth = screen[2];
        }
    }

    int body_color[4] = {128, 128, 128, 0};
    body_color[3] = (int) (128.0f * alpha);
    composite.AlphaBlendEnable(1);
    composite.AlphaBlend(MG_ALPHA_BLEND_NORMAL);
    DrawDivSprite(&composite, mgRect<int>(left, top, right, bottom), &frame_buffer, body_color, 0, 0, depth, 0);
    composite.Begin(MG_PRIM_SPRITE);
    composite.Direct(SCE_GS_TEXFLUSH, 0);
    composite.End();
    return result;
}

static void DrawDivSprite(mgCDrawPrim *prim, mgRect<int> rect, mgCTexture *texture,
                          int *color, int dx, int dy, int z, int unused) {
    int         x;
    int         x_end;
    int         y_end;
    int         offset_y;
    int         y;
    int         block_height;
    mgRect<int> area;
    area.right = rect.right;
    area.left = rect.left;
    area.top = rect.top;
    area.bottom = rect.bottom;
    sceVu0IVECTOR vertex_start;
    sceVu0IVECTOR vertex_end;
    sceVu0IVECTOR texcrd_start;
    sceVu0IVECTOR texcrd_end;
    int           offset_x = dx + mgScreenOffx * 16;
    offset_y = dy + mgScreenOffy * 16;
    block_height = mgScreenHeight * 16;

    prim->Begin2();
    prim->BeginPrim2(MG_PRIM_SPRITE);
    prim->Texture(texture);
    prim->Color(color[0], color[1], color[2], color[3]);
    prim->EndPrim2();
    prim->BeginPrim2(MG_PRIM_SPRITE, 0x43, 0, 2);
    *(u_long128 *) vertex_start = 0;
    *(u_long128 *) vertex_end = 0;
    *(u_long128 *) texcrd_start = 0;
    *(u_long128 *) texcrd_end = 0;
    vertex_end[2] = z;
    vertex_start[2] = z;

    for (x = area.left; x < area.right;) {
        x_end = x + 0x200;

        if (area.right < x_end) {
            x_end = area.right;
        }

        for (y = area.top; y < area.bottom;) {
            y_end = y + block_height;

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
            u_long128 *packet = prim->DirectData(4);
            y = y_end;
            packet[0] = *(u_long128 *) texcrd_start;
            packet[1] = *(u_long128 *) vertex_start;
            packet[2] = *(u_long128 *) texcrd_end;
            packet[3] = *(u_long128 *) vertex_end;
            y = y_end;
        }

        x = x_end;
    }

    prim->EndPrim2();
    prim->End2();
}

static void DrawDivSprite4(mgCDrawPrim *prim, mgRect<int> rect, mgCTexture *texture,
                           int *color, int offset, int z) {
    mgRect<int> area = rect;
    int         offset_x = mgScreenOffx * 16;
    int         offset_y = mgScreenOffy * 16;
    int         right = area.right + offset_x;
    int         top = area.top + offset_y;
    int         bottom = area.bottom + offset_y;
    int         x;
    int         y;

    prim->Begin2();
    prim->BeginPrim2(MG_PRIM_SPRITE);
    prim->Texture(texture);
    prim->Color(color[0], color[1], color[2], color[3]);
    prim->EndPrim2();
    prim->BeginPrim2(MG_PRIM_SPRITE, 0x43, 0, 2);
    int vertex_start[4] = {0, 0, z, 0};
    int vertex_end[4] = {0, 0, z, 0};
    int texcrd_start[4] = {0, 0, 0, 0};
    int texcrd_end[4] = {0, 0, 0, 0};

    for (x = area.left + offset_x; x < right;) {
        int x_end = (x + 0x200) / 0x200 * 0x200;

        if (right < x_end) {
            x_end = right;
        }

        for (y = top; y < bottom;) {
            int y_end = (y + 0x200) / 0x200 * 0x200;

            if (bottom < y_end) {
                y_end = bottom;
            }

            u_long128 *packet = prim->DirectData(0x10);
            texcrd_start[0] = x - offset_x;
            texcrd_start[1] = y - offset_y;
            texcrd_end[0] = x_end - offset_x;
            texcrd_end[1] = y_end - offset_y;
            vertex_start[0] = x + offset;
            vertex_start[1] = y;
            vertex_end[0] = x_end + offset;
            vertex_end[1] = y_end;
            packet[0] = *(u_long128 *) texcrd_start;
            packet[1] = *(u_long128 *) vertex_start;
            packet[2] = *(u_long128 *) texcrd_end;
            packet[3] = *(u_long128 *) vertex_end;
            vertex_start[0] = x - offset;
            vertex_start[1] = y;
            vertex_end[0] = x_end - offset;
            vertex_end[1] = y_end;
            packet[4] = *(u_long128 *) texcrd_start;
            packet[5] = *(u_long128 *) vertex_start;
            packet[6] = *(u_long128 *) texcrd_end;
            packet[7] = *(u_long128 *) vertex_end;
            vertex_start[0] = x;
            vertex_start[1] = y + offset;
            vertex_end[0] = x_end;
            vertex_end[1] = y_end + offset;
            packet[8] = *(u_long128 *) texcrd_start;
            packet[9] = *(u_long128 *) vertex_start;
            packet[10] = *(u_long128 *) texcrd_end;
            packet[11] = *(u_long128 *) vertex_end;
            vertex_start[0] = x;
            vertex_start[1] = y - offset;
            vertex_end[0] = x_end;
            vertex_end[1] = y_end - offset;
            packet[12] = *(u_long128 *) texcrd_start;
            packet[13] = *(u_long128 *) vertex_start;
            packet[14] = *(u_long128 *) texcrd_end;
            packet[15] = *(u_long128 *) vertex_end;
            y = y_end;
        }

        x = x_end;
    }

    prim->EndPrim2();
    prim->End2();
}
