#include "common.h"

#include <algorithm>
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

// The item board repeats one 40x50 slot ("koma") from mt0 for every bag slot, so at
// high resolutions it reads as a grid of identical stamped squares. On PC the board is
// drawn as one continuous surface instead, by stochastic tiling: every vertex of a
// lattice that ignores the slot grid owns a patch of the slot's interior (the frame
// lines are left out), mirrored by its own hash. Each lattice cell blends the patches of
// its four corners, with weights that sum to one everywhere, so no patch edge shows. A
// low-frequency brightness field breaks up what repetition is left. Everything is keyed
// to board coordinates, so the surface scrolls with the board and never flickers.
namespace {

// Lattice spacing in board units, and how much a patch magnifies the slot interior.
// The patch reach (0.8 of the spacing, see Ramp) stays inside the slot's frame lines.
constexpr float kCellX = 24.0f;
constexpr float kCellY = 30.0f;
constexpr float kMagnify = 1.3f;
// Overall tone, so the flattened surface keeps the slot's average brightness.
constexpr float kTone = 1.05f;
constexpr int   kBoardColumns = 6;
constexpr int   kBoardRows = 26;
constexpr int   kSlotW = 40;
constexpr int   kSlotH = 50;

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

// Brightness factor at a board position (board units): about +-4%, a few slots across.
float Macro(float x, float y) {
    const float col = x / kSlotW, row = y / kSlotH;
    const float n = 0.7f * ValueNoise(col * 0.38f + 11.3f, row * 0.42f + 3.7f) +
                    0.3f * ValueNoise(col * 0.9f + 47.1f, row * 0.9f + 29.5f);
    return 1.0f + 0.04f * n;
}

// The slot art is darkest a little above and left of its centre and lightens towards
// its frame. Every patch would carry that shading and the board would look blotchy, so
// each vertex divides it back out. (u, v) are texels from the slot's top-left corner;
// the curve is a least-squares cubic of the slot's brightness, normalised to its mean.
float SlotShading(float u, float v) {
    const float x = (u - 20.0f) / 20.0f, y = (v - 25.0f) / 25.0f;
    return 0.9156f + y * (0.2082f + y * (0.2006f - 0.2238f * y)) + x * (0.1266f + 0.0763f * y - 0.0289f * y * y) +
           x * x * (0.1747f - 0.0056f * y) - 0.1412f * x * x * x;
}

// Share of the far corner's patch at fraction t across a lattice cell. The ramp is
// flat near each corner, which keeps most of the board close to a single patch (so it
// keeps the texture's contrast) and puts the blend in a band between them.
constexpr float kRamp = 0.2f;

float Ramp(float t) {
    return std::clamp((t - kRamp) / (1.0f - 2.0f * kRamp), 0.0f, 1.0f);
}

uint8_t Channel(int channel, float factor) {
    const int value = static_cast<int>(std::lround(static_cast<float>(channel) * factor));
    return static_cast<uint8_t>(std::clamp(value, 0, 0xFF));
}

struct Board {
    float       left, top, right, bottom;   // board extent, screen units
    float       clip_top, clip_bottom;      // visible rows
    mgRect<int> koma;
    int         r, g, b, a;
};

// Appends, for every lattice cell in view, the triangles that carry the patch of its
// corner (dx, dy) weighted by that corner's share.
void AppendPass(const mgCDrawPrim &prim, const Board &board, int dx, int dy, std::vector<gfx::Vertex2D> &out) {
    const float centre_u = board.koma.left + board.koma.right * 0.5f;
    const float centre_v = board.koma.top + board.koma.bottom * 0.5f;
    const int   first_row = static_cast<int>(std::floor((board.clip_top - board.top) / kCellY));
    const int   last_row = static_cast<int>(std::ceil((board.clip_bottom - board.top) / kCellY));
    const int   columns = static_cast<int>(std::ceil((board.right - board.left) / kCellX));
    // The ramp's corners, plus enough steps for the shading correction to follow its curve.
    const float knots[6] = {0.0f, kRamp, 0.4f, 0.6f, 1.0f - kRamp, 1.0f};

    for (int cy = std::max(first_row, 0); cy < last_row; cy++) {
        for (int cx = 0; cx < columns; cx++) {
            const int      vx = cx + dx, vy = cy + dy;
            const uint32_t variant = Hash(vx, vy) >> 9;
            const float    su = (variant & 1) ? -1.0f : 1.0f;
            const float    sv = (variant & 2) ? -1.0f : 1.0f;
            const float    origin_x = board.left + cx * kCellX;
            const float    origin_y = board.top + cy * kCellY;
            const float    corner_x = origin_x + dx * kCellX;
            const float    corner_y = origin_y + dy * kCellY;

            auto vertex = [&](float x, float y) {
                const float tx = (x - origin_x) / kCellX, ty = (y - origin_y) / kCellY;
                const float wx = dx ? Ramp(tx) : 1.0f - Ramp(tx);
                const float wy = dy ? Ramp(ty) : 1.0f - Ramp(ty);
                const float du = su * (x - corner_x) / kMagnify, dv = sv * (y - corner_y) / kMagnify;
                const float f = wx * wy * kTone * Macro(x - board.left, y - board.top) / SlotShading(20.0f + du, 25.0f + dv);
                const uint8_t rgba[4] = {Channel(board.r, f), Channel(board.g, f), Channel(board.b, f),
                                         static_cast<uint8_t>(board.a)};
                return mgPortPrimVertex(prim, x, y, 0.0f, centre_u + du, centre_v + dv, rgba);
            };

            for (int j = 0; j < 5; j++) {
                const float y0 = std::max(origin_y + knots[j] * kCellY, std::max(board.top, board.clip_top));
                const float y1 = std::min(origin_y + knots[j + 1] * kCellY, std::min(board.bottom, board.clip_bottom));
                if (y1 <= y0) {
                    continue;
                }
                for (int i = 0; i < 5; i++) {
                    const float x0 = std::max(origin_x + knots[i] * kCellX, board.left);
                    const float x1 = std::min(origin_x + knots[i + 1] * kCellX, board.right);
                    if (x1 <= x0) {
                        continue;
                    }
                    const gfx::Vertex2D a = vertex(x0, y0), b = vertex(x1, y0), c = vertex(x1, y1), d = vertex(x0, y1);
                    out.insert(out.end(), {a, b, c, a, c, d});
                }
            }
        }
    }
}

} // namespace

PORT_OVERRIDE void MenuItemBrdDraw(float *pos, mgRect<int> clip_rect, int &tex_block, int a, int r, int g, int b) {
    mgCDrawPrim *prim = GetMenuPrim();
    mgCTexture  *tex = mgTexManager.GetTexture(const_cast<char *>("mt0"), -1);

    if (tex == NULL || mgScreenWidth < pos[0]) {
        return;
    }

    mgRect<int> scissor = clip_rect;
    MenuClipRectCheck(scissor);
    MenuReloadTexture(tex_block, tex->block);

    // The slot's interior, inside its frame lines.
    const mgRect<int> koma = MenuItemBrdKomaRect;
    const int         inset = 3;
    Board             board{};
    board.left = static_cast<float>(static_cast<int>(pos[0]));
    board.top = static_cast<float>(static_cast<int>(pos[1]));
    board.right = std::min(board.left + kBoardColumns * kSlotW, static_cast<float>(mgScreenWidth) + kSlotW);
    board.bottom = board.top + kBoardRows * kSlotH;
    board.clip_top = static_cast<float>(scissor.top);
    board.clip_bottom = static_cast<float>(scissor.bottom) + 1.0f;
    board.koma = mgRect<int>(koma.left + inset, koma.top + inset, koma.right - 2 * inset, koma.bottom - 2 * inset);
    board.r = r;
    board.g = g;
    board.b = b;
    board.a = a;

    SetSpriteEnv(prim, MENU_SPRITE_ENV_TEXTURE);
    prim->Shading(1);
    prim->Direct(SCE_GS_SCISSOR_1, scissor.left | ((s64) scissor.right << 16) | ((s64) scissor.top << 32) |
                                       ((s64) scissor.bottom << 48));
    std::vector<gfx::Vertex2D> triangles;

    // The first corner's patch replaces what is underneath; the other three add on top.
    for (int corner = 0; corner < 4; corner++) {
        prim->AlphaBlend(corner == 0 ? MG_ALPHA_BLEND_NONE : MG_ALPHA_BLEND_ADD_FULL);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Texture(tex);
        prim->Color(r, g, b, a);
        triangles.clear();
        AppendPass(*prim, board, corner & 1, corner >> 1, triangles);
        mgPortPrimSubmit(*prim, gfx::Primitive::Triangles, triangles);
        prim->End();
    }

    prim->AlphaBlend(MG_ALPHA_BLEND_NORMAL);

    // Retail's line under the last usable row.
    const int last_row = GetNowBagMax(ITEM_BOARD_MAIN) / 6;
    const int line_top = static_cast<int>(pos[1]) + last_row * kSlotH;

    if (last_row < kBoardRows && OmakeFlag == 0 && line_top <= clip_rect.bottom) {
        const int line_x0 = (int) (pos[0] - 2.0f);
        const int line_x1 = (int) (pos[0] + (float) (kSlotW * 6));
        const int line_y = line_top - 1;
        prim->TextureMapEnable(0);
        prim->Bilinear(1);
        prim->Begin(MG_PRIM_SPRITE);
        prim->Color(0xDE, 0xDE, 0xDE, a);
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
    }

    prim->Shading(0);
    prim->Direct(SCE_GS_SCISSOR_1, ((s64) (mgScreenWidth - 1) << 16) | ((s64) (mgScreenHeight - 1) << 48));
}
