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

#include "common.h"

#include "prespr.hpp"

// Direct is the GS seam on PC; retail's raw quadword write through `write` has no buffer to land in.
void CPreSprite::SetScirror(int x, int y, int w, int h) {
    const unsigned long long data = static_cast<unsigned long long>(x) | (static_cast<unsigned long long>(x + w) << 16) |
                                    (static_cast<unsigned long long>(y) << 32) |
                                    (static_cast<unsigned long long>(y + h) << 48);
    Direct(SCE_GS_SCISSOR_1, data);
}

void CPreSprite::SetAlphaBlend(int mode) {
    switch (mode) {
        case MG_ALPHA_BLEND_NORMAL:
            Direct(SCE_GS_ALPHA_1, 0x44);
            break;
        case MG_ALPHA_BLEND_ADD:
            Direct(SCE_GS_ALPHA_1, 0x48);
            break;
        case MG_ALPHA_BLEND_SUB:
            Direct(SCE_GS_ALPHA_1, 0x42);
            break;
        case MG_ALPHA_BLEND_NONE:
            Direct(SCE_GS_ALPHA_1, 0x2AULL | (0x80ULL << 32));
            break;
    }
}
