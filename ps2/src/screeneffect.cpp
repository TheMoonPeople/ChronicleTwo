#include "common.h"
#include "screeneffect.hpp"
#include "mg_drawprim.hpp"
#include "mg_sprite.hpp"
#include "mg_tanime.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include <cmath>

// Code (.text)
#ifdef NONMATCHING
void DepthOfField(int levels, float *depths, mgCTexture *work_texture, float strength) {
    if (work_texture == NULL) {
        return;
    }

    mgCTexture frame_buffer;
    mgCTexture blur_texture;
    mgGetFrameBuffer(&frame_buffer);
    blur_texture = *work_texture;

    mgRect<int> source(0, 0, mgScreenWidth * 16, mgScreenHeight * 16);
    mgRect<int> destination(0, 0, mgScreenWidth * 8, mgScreenHeight * 8);
    mgCDrawPrim prim;
    prim.Initialize(NULL, NULL);
    prim.DepthTestEnable(1);
    prim.DepthTest(MG_DEPTH_TEST_GEQUAL);
    prim.AlphaTestEnable(0);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.TextureMapEnable(1);
    prim.AlphaBlendEnable(1);

    mgCSprite sprite;
    sprite.attr.alpha_test = -1;
    sprite.attr.z_test = 1;
    blur_texture.Bilinear(1);
    blur_texture.tex0.bits.tcc = 0;

    mgCTexture *source_texture = &frame_buffer;
    for (int level = 0; level < levels; level++) {
        destination.left -= 8;
        destination.top -= 8;
        destination.right -= 8;
        destination.bottom -= 8;
        mgSetPkMoveImage(source_texture, source, &blur_texture, destination, NULL);
        destination.left += 8;
        destination.top += 8;
        destination.right += 8;
        destination.bottom += 8;

        int z[2] = {mgTransZPrim(depths[level]), mgTransZPrim(depths[level] + depths[level] / 10.0f)};
        int alpha[2] = {(int)(128.0f * strength), (int)(32.0f * strength)};
        int parity = level & 1;
        float step_x = (float)(source.right - source.left) / 16.0f;
        float step_u = (float)(destination.right - destination.left) / 16.0f;
        float x = (float)source.left;
        float u = (float)destination.left;

        prim.Begin(MG_PRIM_TRIANGLE_STRIP);
        prim.Texture(&blur_texture);
        prim.Direct(0x3B, 0x8000000080ULL);
        prim.Color(0x80, 0x80, 0x80, alpha[0]);
        prim.TextureCrd4((int)u, destination.top + 16);
        prim.Vertex4((int)x, source.top, z[0]);
        prim.TextureCrd4((int)u, destination.bottom - 16);
        prim.Vertex4((int)x, source.bottom, z[0]);
        while (x < (float)source.right) {
            parity = !parity;
            prim.Color(0x80, 0x80, 0x80, alpha[0]);
            prim.TextureCrd4((int)(u + step_u), destination.top + 16);
            prim.Vertex4((int)(x + step_x), source.top, z[parity]);
            prim.TextureCrd4((int)(u + step_u), destination.bottom - 16);
            prim.Vertex4((int)(x + step_x), source.bottom, z[parity]);
            x += step_x;
            u += step_u;
        }
        prim.End();
        source_texture = &blur_texture;
        source = destination;
        int width = source.right - source.left;
        int height = source.bottom - source.top;
        destination.left += width;
        destination.right = destination.left + width * 2 / 3;
        destination.top += height;
        destination.bottom = destination.top + height * 2 / 3;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/screeneffect", DepthOfField__FiPfP10mgCTexturef);
#endif

#ifdef NONMATCHING
void LensFlare(int *screen, float *color, int bank, char *texture_a, char *texture_b) {
    int width = mgScreenWidth;
    int height = mgScreenHeight;
    float dx = (float)(screen[0] / 16 - width / 2);
    float dy = (float)(screen[1] / 16 - height / 2);
    float distance = sqrtf(dx * dx + dy * dy);
    if (distance > (float)width) {
        return;
    }

    mgTexManager.ReloadTexture(bank, (sceVif1Packet *)NULL);
    mgCTexture *first = mgTexManager.GetTexture(texture_a, bank);
    mgCTexture *second = mgTexManager.GetTexture(texture_b, bank);
    if (first == NULL || second == NULL) {
        return;
    }

    mgSetPkFrameBuffer(first);
    mgCDrawPrim prim;
    prim.Initialize(NULL, NULL);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.AlphaBlendEnable(0);
    prim.DepthTestEnable(0);
    prim.FogEnable(0);
    prim.AlphaTestEnable(0);
    prim.TextureMapEnable(0);
    prim.Shading(1);
    prim.Bilinear(1);
    prim.DepthTestEnable(0);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Color(0, 0, 0, 0x80);
    prim.Vertex(0, 0, 0);
    prim.Vertex(width, height, 0);
    prim.End();

    prim.DepthTestEnable(1);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Color(0x20, 0x20, 0x20, 0x80);
    prim.Vertex(0, 0, screen[2]);
    prim.Vertex(width, height, screen[2]);
    prim.End();
    prim.DepthTestEnable(0);
    prim.TextureMapEnable(1);

    mgCTexture *textures[2] = {first, second};
    mgSetPkFrameBuffer(second);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Direct(0x3B, 0x8000000080ULL);
    prim.Texture(first);
    prim.Color(0x80, 0x80, 0x80, 0x80);
    prim.TextureCrd4(0, 0);
    prim.Vertex4(0, 0, 0);
    prim.TextureCrd4(width * 16 + 0x40, height * 16 + 0x40);
    prim.Vertex4(width * 16 / 3, height * 16 / 3, 0);
    prim.End();

    float fade = 1.0f - distance / (float)width;
    if (fade > 1.0f) {
        fade = 1.0f;
    }
    mgSetPkFrameBuffer(first);
    prim.DAlphaTest(0, 0);
    prim.TextureMapEnable(1);
    prim.AlphaBlendEnable(0);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Color(0x80, 0x80, 0x80, 0x80);
    prim.Texture(second);
    prim.TextureCrd(0, 0);
    prim.Vertex(0, 0, 0);
    int small_width = width / 3;
    int small_height = height / 3;
    prim.TextureCrd(small_width + 1, small_height + 1);
    prim.Vertex(small_width, small_height + 1, 0);
    prim.End();

    int current = 0;
    for (int pass = 0; pass < 4; pass++) {
        int next = current ^ 1;
        mgSetPkFrameBuffer(textures[next]);
        int brightness = (int)(128.0f * ((float)(4 - pass) / 4.0f));
        int spread = (int)(10.0f * (float)(pass + 1));
        int near_edge = spread - 8;
        int far_edge = -8 - spread;
        prim.AlphaBlendEnable(1);
        prim.AlphaBlend(MG_ALPHA_BLEND_ADD_FULL);
        prim.Begin(MG_PRIM_SPRITE);
        prim.Texture(textures[current]);
        prim.Color(brightness, brightness, brightness, 0x80);
        prim.TextureCrd(0, 0);
        prim.Vertex4(near_edge, near_edge, 0);
        prim.TextureCrd(small_width, small_height);
        prim.Vertex4(small_width * 16 + near_edge, small_height * 16 + near_edge, 0);
        prim.TextureCrd(0, 0);
        prim.Vertex4(far_edge, far_edge, 0);
        prim.TextureCrd(small_width, small_height);
        prim.Vertex4(small_width * 16 + far_edge, small_height * 16 + far_edge, 0);
        prim.TextureCrd(0, 0);
        prim.Vertex4(near_edge, far_edge, 0);
        prim.TextureCrd(small_width, small_height);
        prim.Vertex4(small_width * 16 + near_edge, small_height * 16 + far_edge, 0);
        prim.TextureCrd(0, 0);
        prim.Vertex4(far_edge, near_edge, 0);
        prim.TextureCrd(small_width, small_height);
        prim.Vertex4(small_width * 16 + far_edge, small_height * 16 + near_edge, 0);
        prim.End();
        current = next;
    }

    prim.AlphaBlendEnable(1);
    prim.TextureMapEnable(0);
    prim.AlphaBlend(MG_ALPHA_BLEND_SUB);
    int radii[2] = {(small_width + small_height) * 6, (small_width + small_height) * 6 - small_width};
    int centre_x = screen[0] / 3;
    int centre_y = screen[1] / 3;
    prim.Begin(MG_PRIM_SPRITE);
    prim.Color(0, 0, 0, 0);
    prim.Vertex(0, 0, 0);
    prim.Vertex(small_width, small_height, 0);
    prim.End();
    prim.Begin(MG_PRIM_TRIANGLE_FAN);
    prim.Color(0, 0, 0, 0x80);
    prim.Vertex4(centre_x, centre_y, 0);
    prim.Color(0xFF, 0xFF, 0xFF, 0x80);
    float angle = 0.0f;
    int radius_index = 0;
    while (angle < 6.2831855f) {
        prim.Vertex4(centre_x + (int)((float)radii[radius_index] * sinf(angle)),
                     centre_y + (int)((float)radii[radius_index] * cosf(angle)), 0);
        radius_index = !radius_index;
        angle += 0.2617994f;
    }
    prim.Vertex4(centre_x, centre_y - radii[radius_index], 0);
    prim.End();
    prim.DAlphaTest(1, 0);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Color(0xFF, 0xFF, 0xFF, 0x80);
    prim.Vertex(0, 0, 0);
    prim.Vertex(small_width, small_height, 0);
    prim.End();

    mgSetPkFrameBuffer(-1, -1, -1, -1);
    prim.DAlphaTest(0, 0);
    prim.TextureMapEnable(1);
    prim.AlphaBlendEnable(1);
    prim.AlphaBlend(MG_ALPHA_BLEND_ADD);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Texture(textures[current]);
    prim.Color((int)color[0], (int)color[1], (int)color[2], (int)(color[3] * (0.7f * fade * fade)));
    for (int copy = 0; copy < 2; copy++) {
        prim.TextureCrd(0, 0);
        prim.Vertex(0, 0, 0);
        prim.TextureCrd(small_width, small_height);
        prim.Vertex(width, height, 0);
    }
    prim.End();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/screeneffect", LensFlare__FPiPfiPcPc);
#endif

// Small uninitialised data (.sbss)
INCLUDE_BSS(at_205, 0x8);
INCLUDE_BSS(at_206, 0x8);
INCLUDE_BSS(at_283__2, 0x8);
INCLUDE_BSS(at_292__2, 0x8);
