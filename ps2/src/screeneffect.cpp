#include "common.h"

#include <cmath>

#include "mg_drawprim.hpp"
#include "mg_sprite.hpp"
#include "mg_tanime.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "screeneffect.hpp"

// Code (.text)
struct DepthTextureName {
    char text[0x20];
};

struct DepthTextureImages {
    u_long128 *image[MG_TEXTURE_LEVEL_MAX];
};

void DepthOfField(int levels, float *depths, mgCTexture *work_texture, float strength) {
    if (work_texture == NULL) {
        return;
    }
    int level;
    int screen_top;
    int dest_left;
    float *depth;
    int parity;
    mgCTexture *source_texture;
    mgCTexture frame_buffer;
    mgCTexture blur_texture;
    mgGetFrameBuffer(&frame_buffer);
    blur_texture.block = work_texture->block;
    blur_texture.width = work_texture->width;
    blur_texture.height = work_texture->height;
    blur_texture.bpp = work_texture->bpp;
    *(DepthTextureName *)blur_texture.name = *(DepthTextureName *)work_texture->name;
    blur_texture.vram_size = work_texture->vram_size;
    blur_texture.image_blocks = work_texture->image_blocks;
    blur_texture.clut_size = work_texture->clut_size;
    blur_texture.tex0_bits = work_texture->tex0_bits;
    blur_texture.tex1_bits = work_texture->tex1_bits;
    blur_texture.clamp_bits = work_texture->clamp_bits;
    *(DepthTextureImages *)blur_texture.image = *(DepthTextureImages *)work_texture->image;
    blur_texture.clut = work_texture->clut;
    blur_texture.swizzled = work_texture->swizzled;
    blur_texture.next = work_texture->next;
    source_texture = &frame_buffer;
    mgRect<int> source(0, 0, mgScreenWidth * 16, mgScreenHeight * 16);
    mgRect<int> destination(0, 0, mgScreenWidth * 8, mgScreenHeight * 8);
    screen_top = source.top;
    int screen_left = source.left;
    int screen_right = source.right;
    int screen_bottom = source.bottom;
    mgCDrawPrim prim;
    prim.Initialize(NULL, NULL);
    prim.DepthTestEnable(1);
    prim.DepthTest(MG_DEPTH_TEST_GEQUAL);
    prim.AlphaTestEnable(0);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.TextureMapEnable(1);
    prim.AlphaBlendEnable(1);
    mgCSprite sprite;
    sprite.attr.z_test = 1;
    sprite.attr.alpha_test = -1;
    blur_texture.Bilinear(1);
    blur_texture.tex0.bits.tcc = 0;
    for (level = 0; level < levels; level++, source_texture = &blur_texture) {
        destination.left -= 8;
        destination.right -= 8;
        destination.top -= 8;
        destination.bottom -= 8;
        mgSetPkMoveImage(source_texture, source, &blur_texture, destination, NULL);
        destination.left += 8;
        destination.right += 8;
        destination.top += 8;
        destination.bottom += 8;
        depth = &depths[level];
        float tenth = *depth / 10.0f;
        int next_u;
        int depth_z;
        int next_x;
        int dest_top = destination.top;
        int dest_right = destination.right;
        int dest_bottom = destination.bottom;
        dest_left = destination.left;
        parity = level % 2;
        int z[2] = {mgTransZPrim(*depth), mgTransZPrim(tenth + *depth)};
        int alpha[2] = {(int)(128.0f * strength), (int)(32.0f * strength)};
        prim.Begin(MG_PRIM_TRIANGLE_STRIP);
        prim.Texture(&blur_texture);
        float step_x = (float)(screen_right - screen_left) / 16.0f;
        float step_u = (float)(dest_right - dest_left) / 16.0f;
        float x = (float)screen_left;
        float u = (float)dest_left;
        prim.Direct(SCE_GS_TEXA, 0x8000000080ULL);
        prim.Color(0x80, 0x80, 0x80, alpha[0]);
        int texel_u;
        prim.TextureCrd4(texel_u = (int)u, dest_top + 16);
        int vertex_x;
        prim.Vertex4(vertex_x = (int)x, screen_top, z[0]);
        prim.TextureCrd4(texel_u, dest_bottom - 16);
        prim.Vertex4(vertex_x, screen_bottom, z[0]);
        while (x < (float)screen_right) {
            parity = !parity;
            prim.Color(0x80, 0x80, 0x80, alpha[0]);
            prim.TextureCrd4(next_u = (int)(u + step_u), dest_top + 16);
            prim.Vertex4(next_x = (int)(x + step_x), screen_top, depth_z = z[parity]);
            prim.TextureCrd4(next_u, dest_bottom - 16);
            prim.Vertex4(next_x, screen_bottom, depth_z);
            x += step_x;
            u += step_u;
        }
        prim.End();
        source = destination;
        int width = source.right - source.left;
        destination.left += width;
        destination.right = destination.left + width * 2 / 3;
        int height = source.bottom - source.top;
        destination.top += height;
        destination.bottom = destination.top + height * 2 / 3;
    }
}

void LensFlare(sceVu0IVECTOR screen, sceVu0FVECTOR color, int bank, char *texture_a, char *texture_b) {
    int width = mgScreenWidth;
    int height = mgScreenHeight;
    float dx = (float)screen[0] / 16.0f - (float)(width / 2);
    float dy = (float)screen[1] / 16.0f - (float)(height / 2);
    float distance = sqrtf(dx * dx + dy * dy);
    if (!(distance <= (float)width)) {
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
    prim.Vertex(mgScreenWidth, mgScreenHeight, 0);
    prim.End();

    prim.DepthTestEnable(1);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Color(0x20, 0x20, 0x20, 0x80);
    int depth = screen[2];
    prim.Vertex(0, 0, depth);
    prim.Vertex(width, height, depth);
    prim.End();

    mgCTexture *textures[2] = {first, second};
    prim.DepthTestEnable(0);
    prim.TextureMapEnable(1);
    mgSetPkFrameBuffer(second);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Direct(SCE_GS_TEXA, 0x8000000080ULL);
    prim.Texture(first);
    prim.Color(0x80, 0x80, 0x80, 0x80);
    prim.TextureCrd4(0, 0);
    prim.Vertex4(0, 0, 0);
    prim.TextureCrd4(width * 16 + 0x40, height * 16 + 0x40);
    prim.Vertex4(width * 16 / 3, height * 16 / 3, 0);
    prim.End();

    float fade = 1.0f - distance / (float)width;
    if (!(fade <= 1.0f)) {
        fade = 1.0f;
    }
    float alpha_scale = 0.7f * (fade * fade);
    mgSetPkFrameBuffer(textures[0]);
    prim.DAlphaTest(0, 0);
    prim.TextureMapEnable(1);
    prim.AlphaBlendEnable(0);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Color(0x80, 0x80, 0x80, 0x80);
    prim.Texture(textures[1]);
    prim.TextureCrd(0, 0);
    prim.Vertex(0, 0, 0);
    int small_width = width / 3;
    int bottom = (height / 3) + 1;
    prim.TextureCrd(small_width + 1, bottom);
    prim.Vertex(small_width, bottom, 0);
    prim.End();

    int current = 0;
    for (int pass = 0; pass < 4; pass++) {
        mgSetPkFrameBuffer(textures[(unsigned char)!current]);
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
        prim.TextureCrd((int)width / 3, (int)height / 3);
        int high = (int)height / 3 * 16;
        int wide = (int)width / 3 * 16;
        prim.Vertex4(wide + near_edge, high + near_edge, 0);
        prim.TextureCrd(0, 0);
        prim.Vertex4(far_edge, far_edge, 0);
        prim.TextureCrd((int)width / 3, (int)height / 3);
        prim.Vertex4(wide + far_edge, high + far_edge, 0);
        prim.TextureCrd(0, 0);
        prim.Vertex4(near_edge, far_edge, 0);
        prim.TextureCrd((int)width / 3, (int)height / 3);
        prim.Vertex4(wide + near_edge, high + far_edge, 0);
        prim.TextureCrd(0, 0);
        prim.Vertex4(far_edge, near_edge, 0);
        prim.TextureCrd((int)width / 3, (int)height / 3);
        prim.Vertex4(wide + far_edge, high + near_edge, 0);
        prim.End();
        current = (unsigned char)!current;
    }

    prim.AlphaBlendEnable(1);
    prim.TextureMapEnable(0);
    prim.AlphaBlend(MG_ALPHA_BLEND_SUB);
    int centre_x = screen[0] / 3;
    int centre_y = screen[1] / 3;
    int radii[2] = {0, 0};
    radii[0] = (small_width + (height / 3)) * 6;
    radii[1] = radii[0] - small_width;
    prim.Begin(MG_PRIM_SPRITE);
    prim.Color(0, 0, 0, 0);
    prim.Vertex(0, 0, 0);
    prim.Vertex(small_width, (height / 3), 0);
    prim.End();
    prim.Begin(MG_PRIM_TRIANGLE_FAN);
    prim.Color(0, 0, 0, 0x80);
    prim.Vertex4(centre_x, centre_y, 0);
    prim.Color(0xFF, 0xFF, 0xFF, 0x80);
    float angle = 0.0f;
    int radius_index = 0;
    while (angle < 6.2831855f) {
        int x = (int)((float)radii[radius_index] * sinf(angle));
        int y = (int)((float)radii[radius_index] * cosf(angle));
        prim.Vertex4(x + centre_x, y + centre_y, 0);
        radius_index = !radius_index;
        angle += 0.2617994f;
    }
    prim.Vertex4(centre_x, centre_y - radii[radius_index], 0);
    prim.End();
    prim.DAlphaTest(1, 0);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Color(0xFF, 0xFF, 0xFF, 0x80);
    prim.Vertex(0, 0, 0);
    prim.Vertex(small_width, (height / 3), 0);
    prim.End();

    mgSetPkFrameBuffer(-1, -1, -1, -1);
    prim.DAlphaTest(0, 0);
    prim.TextureMapEnable(1);
    prim.AlphaBlendEnable(1);
    prim.AlphaBlend(MG_ALPHA_BLEND_ADD);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Texture(textures[current]);
    prim.Color((int)color[0], (int)color[1], (int)color[2], (int)(color[3] * alpha_scale));
    prim.TextureCrd(0, 0);
    prim.Vertex(0, 0, 0);
    prim.TextureCrd(small_width, (height / 3));
    prim.Vertex(width, height, 0);
    prim.TextureCrd(0, 0);
    prim.Vertex(0, 0, 0);
    prim.TextureCrd(small_width, (height / 3));
    prim.Vertex(width, height, 0);
    prim.End();
}
