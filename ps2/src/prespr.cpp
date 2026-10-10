#include "common.h"

#include "prespr.hpp"

/**
 *
 * One GIF address and data entry in a sprite's direct packet.
 *
 */
struct SpriteGsPacket {
    u_long data; /**< GS register value. */
    u_long reg;  /**< GS register address. */
};

STATIC_ASSERT(sizeof(SpriteGsPacket) == 0x10);

void CPreSprite::Preset2D() {
    AlphaBlendEnable(1);
    AlphaBlend(MG_ALPHA_BLEND_NORMAL);
    AlphaTestEnable(1);
    AlphaTest(1, 0);
    DepthTestEnable(0);
    ZMask(MG_Z_MASK_MASKED);
    Bilinear(0);
    TextureMapEnable(1);
}

void CPreSprite::SetIRect(int x, int y, int w, int h, int u, int v) {
    TextureCrd(u, v);
    Vertex(x, y, 0);
    TextureCrd(u + w, v + h);
    Vertex(x + w, y + h, 0);
}

void CPreSprite::SetIStretch(int x, int y, int w, int h, int u, int v, int tw, int th) {
    TextureCrd(u, v);
    Vertex(x, y, 0);
    TextureCrd(u + tw, v + th);
    Vertex(x + w, y + h, 0);
}

void CPreSprite::SetScirror(int x, int y, int w, int h) {
    SpriteGsPacket *packet = (SpriteGsPacket *) write;
    packet->data = (s64) x | ((s64) (x + w) << 16) | ((s64) y << 32) | ((s64) (y + h) << 48);
    packet->reg = SCE_GS_SCISSOR_1;
    write++;
}

void CPreSprite::SetAlphaBlend(int mode) {
    SpriteGsPacket *packet = (SpriteGsPacket *) write;

    switch (mode) {
        case 0:
            break;
        case MG_ALPHA_BLEND_NORMAL:
            packet->data = 0x44;
            packet->reg = SCE_GS_ALPHA_1;
            write++;
            break;
        case MG_ALPHA_BLEND_ADD:
            packet->data = 0x48;
            packet->reg = SCE_GS_ALPHA_1;
            write++;
            break;
        case MG_ALPHA_BLEND_SUB:
            packet->data = 0x42;
            packet->reg = SCE_GS_ALPHA_1;
            write++;
            break;
        case MG_ALPHA_BLEND_NONE:
            packet->data = 0x2A | ((u_long) 0x80 << 32);
            packet->reg = SCE_GS_ALPHA_1;
            write++;
            break;
    }
}
