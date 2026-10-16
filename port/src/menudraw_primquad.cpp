#include "common.h"

#include <algorithm>
#include <vector>

#include "mainloop.hpp"
#include "menu_mouse.hpp"
#include "menudraw.hpp"
#include "mg_drawprim.hpp"
#include "mg_drawprim_port.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"

namespace {

bool IsBackdrop(mgCDrawPrim *prim, mgRect<int> uv, char *name, int width, int height, int top = 0) {
    if (!prim || !prim->prim.TME || uv.left != 0 || uv.top != top ||
        uv.right != width || uv.bottom != height) {
        return false;
    }
    const auto *texture = mgTexManager.GetTexture(name, -1);
    return texture && prim->texture.tex0_bits == texture->tex0_bits;
}

void DrawBackdrop(mgCDrawPrim &prim, mgRect<float> rect, mgRect<int> uv, float artwork_width) {
    const auto extent = mgPortVisibleExtent();
    const bool wide = extent.left < 0 || extent.right > mgScreenWidth;
    uint8_t    color[4];
    mgPortPrimColor(prim, color);
    std::vector<gfx::Vertex2D> vertices;
    const int                  corners[6][2] = {
        {0, 0},
        {1, 0},
        {1, 1},
        {0, 0},
        {1, 1},
        {0, 1}
    };
    // bg16's last four columns and chr_bg's extra source column are transparent
    // padding. Join reflections and the settled panel to opaque texels, not padding.
    const float u_end = std::min(static_cast<float>(uv.right), artwork_width);
    const float v_end = static_cast<float>(uv.top + uv.bottom);
    const float u_min = 0.5f;
    const float u_max = u_end - 0.5f;
    const float v_min = static_cast<float>(uv.top) + 0.5f;
    const float v_max = v_end - 0.5f;
    const auto append = [&](float left, float right, float u0, float u1) {
        // Linear filtering must stay inside the artwork at every seam; otherwise
        // transparent atlas padding leaves a dark hairline (notably op_bg at 4:3).
        u0 = std::clamp(u0, u_min, u_max);
        u1 = std::clamp(u1, u_min, u_max);
        for (const auto &corner : corners) {
            const float v = std::clamp(corner[1] ? v_end : static_cast<float>(uv.top), v_min, v_max);
            vertices.push_back(mgPortPrimVertex(prim, corner[0] ? right : left,
                                                corner[1] ? rect.top + rect.bottom : rect.top, 0,
                                                corner[0] ? u1 : u0, v, color));
        }
    };
    const float left = rect.left, right = left + rect.right;
    const float span = rect.right * u_end / uv.right;
    append(left, left + span, 0, u_end);

    if (wide && rect.right > 0 && rect.bottom > 0 && right > 0 && left < mgScreenWidth) {
        // Keep the reflection phase attached to the moving artwork. During a
        // horizontal slide extend only into the flanks, preserving the field
        // revealed inside the retail frame. Include the authored edge padding
        // at the settled joins (Make starts at 1, Character ends at 511).
        const float left_join = left <= 2 ? std::max(0.0f, left) : 0.0f;
        bool        reflected = true;
        for (float edge = left; extent.left < edge; edge -= span, reflected = !reflected) {
            const float end = std::max(extent.left, edge - span);
            const float start = std::min(left_join, edge);
            if (start <= end) {
                continue;
            }
            const float start_u = reflected ? 0 : u_end;
            const float rate = (reflected ? 1 : -1) * uv.right / rect.right;
            append(end, start, start_u + (edge - end) * rate, start_u + (edge - start) * rate);
        }
        const float right_join = right >= mgScreenWidth - 2 ? std::min<float>(mgScreenWidth, left + span) : mgScreenWidth;
        reflected = true;
        for (float edge = left + span; extent.right > edge; edge += span, reflected = !reflected) {
            const float end = std::min(extent.right, edge + span);
            const float start = std::max(right_join, edge);
            if (start >= end) {
                continue;
            }
            const float start_u = reflected ? u_end : 0;
            const float rate = (reflected ? -1 : 1) * uv.right / rect.right;
            append(start, end, start_u + (start - edge) * rate, start_u + (end - edge) * rate);
        }
    }
    mgPortPrimSubmit(prim, gfx::Primitive::Triangles, vertices);
}

} // namespace

PORT_OVERRIDE void PrimQuad(mgCTexture *texture, float x, float y, mgRect<int> uv,
                            int alpha, int red, int green, int blue) {
    // The title and language menus use their own atlas rather than MenuCursorDraw.
    const bool         cursor = GetNowLoopNo() == LOOP_TITLE && uv.right == 40 && uv.bottom == 24 &&
                                ((uv.left == 0 && uv.top == 40 && texture == mgTexManager.GetTexture(const_cast<char *>("moji"), -1)) ||
                                 (uv.left == 216 && uv.top == 360));
    gfx::Interp2DScope tag(cursor ? gfx::Interp2D{MenuMouseNextHandKey(), static_cast<uint64_t>(mgPortFrameCount())} : gfx::CurrentInterp2D());
    if (cursor) {
        MenuMouseNoteHand(mgPortBinding(texture),
                          {float(uv.left), float(uv.top), float(uv.right), float(uv.bottom)},
                          0, 0, alpha);
    }
    mgCDrawPrim prim;
    SetSpriteEnv(&prim, MENU_SPRITE_ENV_TEXTURE);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Texture(texture);
    prim.Color(red, green, blue, alpha);
    PrimQuad(&prim, x, y, uv);
    prim.End();
}

// Host specializations of the rectangle helper declared by menudraw.hpp.
template <>
void PrimQuad<float>(mgCDrawPrim *prim, mgRect<float> put_rect, mgRect<int> tex_rect) {
    static char character_name[] = "chr_bg";
    static char invent_name[] = "inv_bg";
    static char options_name[] = "op_bg";
    if (IsBackdrop(prim, tex_rect, character_name, 513, 768) ||
        IsBackdrop(prim, tex_rect, invent_name, 512, 416, 48) ||
        IsBackdrop(prim, tex_rect, options_name, 512, 448, 46)) {
        DrawBackdrop(*prim, put_rect, tex_rect, 512);
        return;
    }
    PrimQuad_f_(prim, mgRect_f_{put_rect.left, put_rect.top, put_rect.right, put_rect.bottom},
                mgRect_i_{tex_rect.left, tex_rect.top, tex_rect.right, tex_rect.bottom});
}

template <>
void PrimQuad<int>(mgCDrawPrim *prim, mgRect<int> put_rect, mgRect<int> tex_rect) {
    static char frame_name[] = "bg16";
    if (IsBackdrop(prim, tex_rect, frame_name, 704, 416)) {
        // Preserve the authored lens position. Full-frame sprite cover scaling
        // moves its alpha mask away from the model camera, even at 4:3.
        DrawBackdrop(*prim, mgRect<float>(put_rect.left, put_rect.top, put_rect.right, put_rect.bottom), tex_rect, 700);
        return;
    }
    PrimQuad_i_(prim, mgRect_i_{put_rect.left, put_rect.top, put_rect.right, put_rect.bottom},
                mgRect_i_{tex_rect.left, tex_rect.top, tex_rect.right, tex_rect.bottom});
}
