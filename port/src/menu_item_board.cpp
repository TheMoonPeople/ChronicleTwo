#include "common.h"

#include <cmath>
#include <cstdint>
#include <vector>

#include "mainloop.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "mg_drawprim.hpp"
#include "mg_drawprim_port.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "userdata.hpp"

// The item board repeats one 40x50 slot ("koma") from mt0 for every bag slot. At
// high resolutions the slot's dark smudge reads as an obvious stamp pattern. Each
// slot here is mirrored by its own fixed hash (the slot frame is symmetric, so only
// the smudge and scratches move), and a low-frequency brightness field that is
// independent of the slot grid is shaded across the board. Both are keyed to the
// bag row and column, so the pattern scrolls with the board and never flickers.
namespace {

uint32_t Hash(int x, int y) {
    uint32_t h = static_cast<uint32_t>(x) * 0x8DA6B343u ^ static_cast<uint32_t>(y) * 0xD8163841u;
    h ^= h >> 15;
    h *= 0x2C1B3C6Du;
    h ^= h >> 12;
    h *= 0x297A2D39u;
    h ^= h >> 15;
    return h;
}

float Lattice(int x, int y) {
    return static_cast<float>(Hash(x, y + 0x1000) & 0xFFFF) / 32767.5f - 1.0f;
}

float ValueNoise(float x, float y) {
    const float fx = std::floor(x), fy = std::floor(y);
    const int   ix = static_cast<int>(fx), iy = static_cast<int>(fy);
    float       tx = x - fx, ty = y - fy;
    tx = tx * tx * (3.0f - 2.0f * tx);
    ty = ty * ty * (3.0f - 2.0f * ty);
    const float top = Lattice(ix, iy) + (Lattice(ix + 1, iy) - Lattice(ix, iy)) * tx;
    const float bottom = Lattice(ix, iy + 1) + (Lattice(ix + 1, iy + 1) - Lattice(ix, iy + 1)) * tx;
    return top + (bottom - top) * ty;
}

// Brightness factor at a board position in slot units: about +-9%, with features
// a few slots wide, so neighbouring slots differ but no slot looks out of place.
float Macro(float col, float row) {
    const float n = 0.7f * ValueNoise(col * 0.38f + 11.3f, row * 0.42f + 3.7f) +
                    0.3f * ValueNoise(col * 0.9f + 47.1f, row * 0.9f + 29.5f);
    return 1.0f + 0.09f * n;
}

uint8_t Scale(int channel, float factor) {
    const int value = static_cast<int>(std::lround(static_cast<float>(channel) * factor));
    return static_cast<uint8_t>(value < 0 ? 0 : value > 0xFF ? 0xFF : value);
}

void AppendSlot(const mgCDrawPrim &prim, std::vector<gfx::Vertex2D> &out, mgRect<int> put, mgRect<int> koma,
                int row, int col, int a, int r, int g, int b) {
    const uint32_t variant = Hash(col, row) >> 7;
    const bool     flip_u = (variant & 1) != 0;
    const bool     flip_v = (variant & 2) != 0;
    const float    u0 = static_cast<float>(flip_u ? koma.left + koma.right : koma.left);
    const float    u1 = static_cast<float>(flip_u ? koma.left : koma.left + koma.right);
    const float    v0 = static_cast<float>(flip_v ? koma.top + koma.bottom : koma.top);
    const float    v1 = static_cast<float>(flip_v ? koma.top : koma.top + koma.bottom);

    // Corners plus the centre, as a four-triangle fan, so the shading has no diagonal crease.
    const float fx[5] = {0.0f, 1.0f, 1.0f, 0.0f, 0.5f};
    const float fy[5] = {0.0f, 0.0f, 1.0f, 1.0f, 0.5f};
    gfx::Vertex2D vertex[5];

    for (int i = 0; i < 5; i++) {
        const float   factor = Macro(static_cast<float>(col) + fx[i], static_cast<float>(row) + fy[i]);
        const uint8_t rgba[4] = {Scale(r, factor), Scale(g, factor), Scale(b, factor), static_cast<uint8_t>(a)};
        vertex[i] = mgPortPrimVertex(prim, static_cast<float>(put.left) + fx[i] * static_cast<float>(put.right),
                                     static_cast<float>(put.top) + fy[i] * static_cast<float>(put.bottom), 0.0f,
                                     u0 + (u1 - u0) * fx[i], v0 + (v1 - v0) * fy[i], rgba);
    }

    for (int i = 0; i < 4; i++) {
        out.push_back(vertex[4]);
        out.push_back(vertex[i]);
        out.push_back(vertex[(i + 1) % 4]);
    }
}

} // namespace

PORT_OVERRIDE void MenuItemBrdDraw(float *pos, mgRect<int> clip_rect, int &tex_block, int a, int r, int g, int b) {
    mgCDrawPrim *prim;
    mgCTexture  *tex;
    int          bottom;
    int          last_row;
    int          row;
    int          col;
    int          line_x0;
    int          line_x1;
    int          line_y;
    mgRect<int>  koma;
    mgRect<int>  scissor;

    prim = GetMenuPrim();
    koma = MenuItemBrdKomaRect;
    tex = mgTexManager.GetTexture(const_cast<char *>("mt0"), -1);

    if (tex != NULL && !(mgScreenWidth < pos[0])) {
        scissor.left = clip_rect.left;
        scissor.top = clip_rect.top;
        scissor.right = clip_rect.right;
        scissor.bottom = bottom = clip_rect.bottom;
        MenuClipRectCheck(scissor);
        MenuReloadTexture(tex_block, tex->block);
        last_row = GetNowBagMax(ITEM_BOARD_MAIN) / 6;
        mgRect<int> put(0, 0, 0, 0);
        SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
        prim->Shading(1);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(tex);
        prim->Color(r, g, b, a);
        prim->Direct(SCE_GS_SCISSOR_1, scissor.left | ((s64) scissor.right << 16) | ((s64) scissor.top << 32) |
                                           ((s64) scissor.bottom << 48));
        put.top = (int) pos[1];
        put.right = 40;
        put.bottom = 50;
        std::vector<gfx::Vertex2D> slots;

        for (row = 0; row < 26; row++) {
            if (bottom < put.top) {
                break;
            }

            put.left = (int) pos[0];

            for (col = 0; col < 6; col++) {
                if (mgScreenWidth < put.left) {
                    break;
                }

                AppendSlot(*prim, slots, put, koma, row, col, a, r, g, b);
                put.left += put.right;
            }

            if (row == last_row && OmakeFlag == 0) {
                mgPortPrimSubmit(*prim, gfx::Primitive::Triangles, slots);
                slots.clear();
                prim->End();
                prim->TextureMapEnable(0);
                prim->Bilinear(1);
                prim->Shading(1);
                prim->Begin(MG_PRIM_SPRITE);
                prim->Color(0xDE, 0xDE, 0xDE, a);
                line_x0 = (int) (pos[0] - 2.0f);
                line_x1 = (int) (pos[0] + (float) (put.right * 6));
                line_y = put.top - 1;
                prim->Vertex(line_x0, line_y, 0);
                prim->Vertex(line_x1, line_y + 1, 0);
                prim->End();
                prim->Begin(MG_PRIM_SPRITE);
                prim->Color(0xAC, 0xAC, 0xAC, a * 3 / 5);
                prim->Vertex(line_x0, line_y + 2, 0);
                prim->Vertex(line_x1, line_y + 3, 0);
                prim->End();
                prim->Begin(MG_PRIM_SPRITE);
                prim->Color(0x80, 0x80, 0x80, a / 5);
                prim->Vertex(line_x0, line_y + 4, 0);
                prim->Vertex(line_x1, line_y + 5, 0);
                prim->End();
                prim->TextureMapEnable(1);
                prim->Bilinear(0);
                prim->Shading(1);
                prim->Begin(MG_PRIM_SPRITE);
                prim->Color(r, g, b, a);
            }

            put.top += put.bottom;
        }

        mgPortPrimSubmit(*prim, gfx::Primitive::Triangles, slots);
        prim->Direct(SCE_GS_SCISSOR_1, ((s64) (mgScreenWidth - 1) << 16) | ((s64) (mgScreenHeight - 1) << 48));
        prim->End();
        prim->Shading(0);
    }
}
