#include "common.h"

#include <algorithm>
#include <cstring>

#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "outline.hpp"
#include "outline_port.hpp"

namespace {

constexpr int   kZtstAlways = 1;
constexpr float kUnitsPerPixel = 16.0f;

gfx::LogicalRect LogicalRectOf(const OutlineBox &box, int outset) {
    const float left = static_cast<float>(box.left - outset) / kUnitsPerPixel;
    const float top = static_cast<float>(box.top - outset) / kUnitsPerPixel;
    const float right = static_cast<float>(box.right + outset) / kUnitsPerPixel;
    const float bottom = static_cast<float>(box.bottom + outset) / kUnitsPerPixel;
    return {left, top, right - left, bottom - top};
}

// Texels are at the box's own logical coordinates: the image is the frame's logical space.
void DrawCopy(const OutlineBox &box, int dx, int dy, const uint8_t (&colour)[4], float depth,
              const gfx::TextureBinding &binding, const gfx::DrawState &state) {
    const float x0 = static_cast<float>(box.left + dx) / kUnitsPerPixel;
    const float y0 = static_cast<float>(box.top + dy) / kUnitsPerPixel;
    const float x1 = static_cast<float>(box.right + dx) / kUnitsPerPixel;
    const float y1 = static_cast<float>(box.bottom + dy) / kUnitsPerPixel;
    const float u0 = static_cast<float>(box.left) / kUnitsPerPixel;
    const float v0 = static_cast<float>(box.top) / kUnitsPerPixel;
    const float u1 = static_cast<float>(box.right) / kUnitsPerPixel;
    const float v1 = static_cast<float>(box.bottom) / kUnitsPerPixel;

    const auto corner = [&](float x, float y, float u, float v) {
        gfx::Vertex2D vertex{};
        vertex.x = x;
        vertex.y = y;
        vertex.z = depth;
        vertex.u = u;
        vertex.v = v;
        std::memcpy(vertex.color, colour, sizeof colour);
        return vertex;
    };

    // Retail cuts each sprite into 32-pixel columns for the GS texture cache; one quad samples the
    // same texels.
    const gfx::Vertex2D quad[4] = {corner(x0, y0, u0, v0), corner(x1, y0, u1, v0),
                                   corner(x1, y1, u1, v1), corner(x0, y1, u0, v1)};
    // The model image is redrawn with the presentation camera, so the newest tick's box
    // cannot crop it. Sample the visible extent; the matching display clear removes other
    // objects from this shared target. Texture and screen coordinates retain the edge offset.
    const mgPortExtent  extent = mgPortVisibleExtent();
    const float         ox = static_cast<float>(dx) / kUnitsPerPixel;
    const float         oy = static_cast<float>(dy) / kUnitsPerPixel;
    const gfx::Vertex2D display_quad[4] = {
        corner(extent.left + ox, extent.top + oy, extent.left, extent.top),
        corner(extent.right + ox, extent.top + oy, extent.right, extent.top),
        corner(extent.right + ox, extent.bottom + oy, extent.right, extent.bottom),
        corner(extent.left + ox, extent.bottom + oy, extent.left, extent.bottom)};
    gfx::Presentation2D presentation{display_quad, state};
    // Empty texels must not stamp the object's constant depth across the enlarged rectangle.
    if (presentation.state.depth_write) {
        presentation.state.alpha_test = true;
        presentation.state.alpha_func = gfx::AlphaFunc::Greater;
        presentation.state.alpha_ref = 0;
    }
    mgPortDraw2D(gfx::Primitive::Quads, quad, binding, state, &presentation);
}

} // namespace

float OutlineScale(float scale) {
    if (!(scale <= 1.0f)) {
        scale = 1.0f;
    }

    return scale * scale;
}

int OutlineEdgeOffset(float width, float squared_scale) {
    return static_cast<int>(kUnitsPerPixel * (width * squared_scale));
}

OutlineBox OutlineDrawBox(const float *box_min, const float *box_max, const mgPortExtent &extent) {
    float min_xy[4] = {box_min[0], box_min[1], 0.0f, 0.0f};
    float max_xy[4] = {box_max[0], box_max[1], 0.0f, 0.0f};

    if (min_xy[0] < extent.left) {
        min_xy[0] = extent.left;
    }

    if (min_xy[1] < extent.top) {
        min_xy[1] = extent.top;
    }

    if (!(max_xy[0] <= extent.right)) {
        max_xy[0] = extent.right;
    }

    if (!(max_xy[1] <= extent.bottom)) {
        max_xy[1] = extent.bottom;
    }

    int min_corner[4];
    int max_corner[4];
    mgFotI4(min_corner, min_xy);
    mgFotI4(max_corner, max_xy);
    return {min_corner[0], min_corner[1], max_corner[0], max_corner[1]};
}

OutlineBox OutlinePaddedBox(const OutlineBox &box, const mgPortExtent &extent) {
    float bounds_min[4] = {extent.left, extent.top, 0.0f, 0.0f};
    float bounds_max[4] = {extent.right, extent.bottom, 0.0f, 0.0f};
    int   min_bound[4];
    int   max_bound[4];
    mgFotI4(min_bound, bounds_min);
    mgFotI4(max_bound, bounds_max);

    OutlineBox padded{box.left - kOutlinePad, box.top - kOutlinePad, box.right + kOutlinePad,
                      box.bottom + kOutlinePad};

    if (padded.left < min_bound[0]) {
        padded.left = min_bound[0];
    }

    if (padded.top < min_bound[1]) {
        padded.top = min_bound[1];
    }

    if (padded.right > max_bound[0]) {
        padded.right = max_bound[0];
    }

    if (padded.bottom > max_bound[1]) {
        padded.bottom = max_bound[1];
    }

    return padded;
}

PORT_OVERRIDE int COutLineDraw::Draw(float scale, float alpha) {
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
    scale = OutlineScale(scale);

    if (width <= 0.0f) {
        frame->SetAttrParamObjAlpha(alpha, 1);
        return mgDrawDirect(frame);
    }

    const float scaled_width = width * scale;
    float opacity = 1.0f;

    if (static_cast<int>(scaled_width) <= 0) {
        opacity = scaled_width;
    }

    if (opacity < 0.01f) {
        opacity = 0.01f;
    }

    const int edge_offset = OutlineEdgeOffset(width, scale);
    mgVu0FBOX draw_box;

    if (mgGetDrawRect(frame, &draw_box) == 0) {
        return 0;
    }

    const mgPortExtent extent = mgPortVisibleExtent();
    const OutlineBox   box = OutlineDrawBox(draw_box.min, draw_box.max, extent);
    const OutlineBox   padded = OutlinePaddedBox(box, extent);

    // Without a renderer or an open frame there is no image to draw into. The frame's packets are
    // still written, as retail writes them.
    if (!mgPortRendererReady() || !mgPortFrameOpen()) {
        return mgDrawDirect(frame);
    }

    const gfx::TextureHandle outline = gfx::NamedRenderTarget(
        "outline", static_cast<uint32_t>(mgScreenWidth), static_cast<uint32_t>(mgScreenHeight), true, true);

    if (outline == gfx::kNullTexture) {
        return mgDrawDirect(frame);
    }

    const gfx::TextureHandle previous = gfx::CurrentRenderTarget();
    const gfx::LogicalRect   clear_rect = LogicalRectOf(padded, 16);
    const uint8_t            clear_colour[4] = {0, 0, 0, 0};

    gfx::SetRenderTarget(outline);
    // Depth is not cleared: the image shares the scene's depth buffer.
    const gfx::LogicalRect display_clear = {extent.left, extent.top, extent.right - extent.left,
                                            extent.bottom - extent.top};
    gfx::Clear(true, clear_colour, false, 0.0f, &clear_rect, &display_clear);
    result += mgDrawDirect(frame);
    gfx::SetRenderTarget(previous);

    mgSetPkTextureRepeat(0);
    mgPortGsState &gs = mgPortGs();
    // Retail's mgSetPkFrameBuffer(-1) resets the scissor to the whole frame, which the composite needs.
    gs.scissor[0] = 0;
    gs.scissor[1] = 0;
    gs.scissor[2] = mgScreenWidth - 1;
    gs.scissor[3] = mgScreenHeight - 1;
    gs.tex1 = SCE_GS_SET_TEX1(1, 0, 1, 1, 1, 0, 0);

    mgCDrawEnv env;
    env.test.bits.ztst = kZtstAlways;
    env.zbuf = mgRenderInfo.draw_env[0].zbuf;
    env.SetAlpha(MG_ALPHA_BLEND_NORMAL);

    gfx::TextureBinding binding;
    binding.texture = outline;
    binding.filter = mgPortFilter(gs.tex1);
    binding.wrap_u = mgPortWrapU(gs.clamp);
    binding.wrap_v = mgPortWrapV(gs.clamp);

    if (hide_edge == 0 && !(alpha < 1.0f) && edge_offset > 0 && !(opacity < 0.1f)) {
        const uint8_t edge_colour[4] = {static_cast<uint8_t>(static_cast<int>(color[0])),
                                        static_cast<uint8_t>(static_cast<int>(color[1])),
                                        static_cast<uint8_t>(static_cast<int>(color[2])),
                                        static_cast<uint8_t>(static_cast<int>(128.0f * opacity * alpha))};
        env.SetZBuf(MG_ZBUF_NO_WRITE);
        gfx::DrawState edge_state = mgPortDrawState();
        edge_state.blend = true;
        mgPortApplyDrawEnv(edge_state, env);

        DrawCopy(box, edge_offset, 0, edge_colour, 0.0f, binding, edge_state);
        DrawCopy(box, -edge_offset, 0, edge_colour, 0.0f, binding, edge_state);
        DrawCopy(box, 0, edge_offset, edge_colour, 0.0f, binding, edge_state);
        DrawCopy(box, 0, -edge_offset, edge_colour, 0.0f, binding, edge_state);
    }

    int  depth = 0;
    bool depth_write = false;

    if (depth_from_pos != 0) {
        pos[3] = 1.0f;
        int screen[4];

        if (mgTransWorldPrim(screen, pos) != 0) {
            depth_write = true;
            depth = std::max(screen[2], 0);
        }
    }

    const uint8_t body_colour[4] = {128, 128, 128, static_cast<uint8_t>(static_cast<int>(128.0f * alpha))};
    env.SetZBuf(depth_write ? MG_ZBUF_WRITE : MG_ZBUF_NO_WRITE);
    gfx::DrawState body_state = mgPortDrawState();
    body_state.blend = true;
    mgPortApplyDrawEnv(body_state, env);
    DrawCopy(box, 0, 0, body_colour, mgPortDepth(static_cast<uint32_t>(depth)), binding, body_state);

    // The composite's packets are the last writes to these registers.
    gs.test = env.test.value;
    gs.zbuf = env.zbuf.value;
    gs.alpha = env.alpha.value;
    return result;
}
