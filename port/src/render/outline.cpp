#include "common.h"

#include <algorithm>
#include <cstdlib>
#include <cstring>
#include <optional>
#include <unordered_map>

#include "camera_fixed.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_tanime.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "outline.hpp"
#include "render/outline_geometry.hpp"
#include "render/renderer.hpp"

void COutLineDraw::Initialize() {
    mgZeroVector(unk_10.max);
    mgZeroVector(unk_10.min);
    frame = nullptr;
    texture = nullptr;
    width = 0.0f;
    depth_from_pos = 0;
    color[0] = 80.0f;
    color[1] = 60.0f;
    color[2] = 0.0f;
    color[3] = 128.0f;
    enable = 1;
    hide_edge = 0;
    next = nullptr;
}

void COutLineDraw::SetFrame(mgCFrame *new_frame) {
    frame = new_frame;
}

static void DrawDivSprite(mgCDrawPrim *prim, mgRect<int> rect, mgCTexture *texture,
                          int *color, int dx, int dy, int z, int unused);
static void DrawDivSprite4(mgCDrawPrim *prim, mgRect<int> rect, mgCTexture *texture,
                           int *color, int offset, int z);

int COutLineDraw::Draw(float *pos, float scale, float alpha) {

    std::memcpy(this->pos, pos, sizeof(this->pos));
    return Draw(scale, alpha);
}

static void DrawDivSprite(mgCDrawPrim *prim, mgRect<int> rect, mgCTexture *texture,
                          int *color, int dx, int dy, int z, int unused) {
    int         x = {};
    int         x_end = {};
    int         y_end = {};
    int         offset_y = {};
    int         y = {};
    int         block_height = {};
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
    std::fill_n(vertex_start, 4, 0);
    std::fill_n(vertex_end, 4, 0);
    std::fill_n(texcrd_start, 4, 0);
    std::fill_n(texcrd_end, 4, 0);
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
            std::memcpy(&packet[0], texcrd_start, sizeof(texcrd_start));
            std::memcpy(&packet[1], vertex_start, sizeof(vertex_start));
            std::memcpy(&packet[2], texcrd_end, sizeof(texcrd_end));
            std::memcpy(&packet[3], vertex_end, sizeof(vertex_end));
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
    int         x = {};
    int         y = {};

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
            std::memcpy(&packet[0], texcrd_start, sizeof(texcrd_start));
            std::memcpy(&packet[1], vertex_start, sizeof(vertex_start));
            std::memcpy(&packet[2], texcrd_end, sizeof(texcrd_end));
            std::memcpy(&packet[3], vertex_end, sizeof(vertex_end));
            vertex_start[0] = x - offset;
            vertex_start[1] = y;
            vertex_end[0] = x_end - offset;
            vertex_end[1] = y_end;
            std::memcpy(&packet[4], texcrd_start, sizeof(texcrd_start));
            std::memcpy(&packet[5], vertex_start, sizeof(vertex_start));
            std::memcpy(&packet[6], texcrd_end, sizeof(texcrd_end));
            std::memcpy(&packet[7], vertex_end, sizeof(vertex_end));
            vertex_start[0] = x;
            vertex_start[1] = y + offset;
            vertex_end[0] = x_end;
            vertex_end[1] = y_end + offset;
            std::memcpy(&packet[8], texcrd_start, sizeof(texcrd_start));
            std::memcpy(&packet[9], vertex_start, sizeof(vertex_start));
            std::memcpy(&packet[10], texcrd_end, sizeof(texcrd_end));
            std::memcpy(&packet[11], vertex_end, sizeof(vertex_end));
            vertex_start[0] = x;
            vertex_start[1] = y - offset;
            vertex_end[0] = x_end;
            vertex_end[1] = y_end - offset;
            std::memcpy(&packet[12], texcrd_start, sizeof(texcrd_start));
            std::memcpy(&packet[13], vertex_start, sizeof(vertex_start));
            std::memcpy(&packet[14], texcrd_end, sizeof(texcrd_end));
            std::memcpy(&packet[15], vertex_end, sizeof(vertex_end));
            y = y_end;
        }

        x = x_end;
    }

    prim->EndPrim2();
    prim->End2();
}

namespace {

constexpr int   kZtstAlways = 1;
constexpr float kUnitsPerPixel = 16.0f;

gfx::LogicalRect LogicalRectOf(const OutlineBox &box, int outset) {
    const float left = static_cast<float>(box.left - outset) / kUnitsPerPixel;
    const float top = static_cast<float>(box.top - outset) / kUnitsPerPixel;
    const float right = static_cast<float>(box.right + outset) / kUnitsPerPixel;
    const float bottom = static_cast<float>(box.bottom + outset) / kUnitsPerPixel;
    return {.x = left, .y = top, .w = right - left, .h = bottom - top};
}

// Texels are at the box's own logical coordinates: the image is the frame's logical space.
void DrawCopy(const OutlineBox &box, const mgPortExtent &display, int dx, int dy, const uint8_t (&colour)[4], float depth,
              const gfx::TextureBinding &binding, const gfx::DrawState &state, bool defer_alpha = false) {
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
    // Display frames redraw the image with the presentation camera, so the tick's box must not crop
    // them: they sample the display extent, which the matching display clear keeps to this object.
    const float         ox = static_cast<float>(dx) / kUnitsPerPixel;
    const float         oy = static_cast<float>(dy) / kUnitsPerPixel;
    const gfx::Vertex2D display_quad[4] = {
        corner(display.left + ox, display.top + oy, display.left, display.top),
        corner(display.right + ox, display.top + oy, display.right, display.top),
        corner(display.right + ox, display.bottom + oy, display.right, display.bottom),
        corner(display.left + ox, display.bottom + oy, display.left, display.bottom)};
    gfx::Presentation2D presentation{.vertices = display_quad, .state = state};
    if (defer_alpha) {
        // The following full-area body overwrites alpha before any consumer can observe it.
        presentation.state.color_write_mask = static_cast<uint8_t>(state.color_write_mask & ~gfx::kWriteAlpha);
    }
    // Empty texels must not stamp the object's constant depth across the enlarged rectangle.
    if (presentation.state.depth_write) {
        presentation.state.alpha_test = true;
        presentation.state.alpha_func = gfx::AlphaFunc::Greater;
        presentation.state.alpha_ref = 0;
    }
    mgPortDraw2D(gfx::Primitive::Quads, quad, binding, state, &presentation);
}

/**
 * An object's padded box and the tick it was drawn on.
 */
struct DrawnBox {
    OutlineBox box;   /**< Padded box in 12.4. */
    int        frame; /**< mgPortFrameCount when it was drawn. */
};

// Boxes by outline object, for the next tick's display frames.
std::unordered_map<const COutLineDraw *, DrawnBox> &DrawnBoxes() {
    static std::unordered_map<const COutLineDraw *, DrawnBox> boxes;
    return boxes;
}

// The object's padded box on the tick before this one, and records this tick's.
std::optional<OutlineBox> SwapDrawnBox(const COutLineDraw *outline, const OutlineBox &box) {
    constexpr int forget_frames = 600;
    auto         &boxes = DrawnBoxes();
    const int     frame = mgPortFrameCount();
    if (frame % forget_frames == 0) {
        std::erase_if(boxes, [frame](const auto &entry) { return frame - entry.second.frame > 1; });
    }
    DrawnBox                 &drawn = boxes[outline];
    std::optional<OutlineBox> previous;
    if (drawn.frame == frame - 1) {
        previous = drawn.box;
    }
    if (drawn.frame != frame) {
        drawn = {.box = box, .frame = frame};
    }
    return previous;
}

} // namespace

mgPortExtent OutlineDisplayExtent(const OutlineBox &box, const OutlineBox *previous, int edge_offset,
                                  const mgPortExtent &extent) {
    OutlineBox both = box;
    if (previous != nullptr) {
        both.left = std::min(both.left, previous->left);
        both.top = std::min(both.top, previous->top);
        both.right = std::max(both.right, previous->right);
        both.bottom = std::max(both.bottom, previous->bottom);
    }
    const float  outset = kOutlineDisplayMargin + static_cast<float>(std::abs(edge_offset)) / kUnitsPerPixel;
    mgPortExtent display = extent;
    display.left = std::max(extent.left, static_cast<float>(both.left) / kUnitsPerPixel - outset);
    display.top = std::max(extent.top, static_cast<float>(both.top) / kUnitsPerPixel - outset);
    display.right = std::min(extent.right, static_cast<float>(both.right) / kUnitsPerPixel + outset);
    display.bottom = std::min(extent.bottom, static_cast<float>(both.bottom) / kUnitsPerPixel + outset);
    display.right = std::max(display.right, display.left);
    display.bottom = std::max(display.bottom, display.top);
    return display;
}

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

    min_xy[0] = std::max(min_xy[0], extent.left);

    min_xy[1] = std::max(min_xy[1], extent.top);

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
    return {.left = min_corner[0], .top = min_corner[1], .right = max_corner[0], .bottom = max_corner[1]};
}

OutlineBox OutlinePaddedBox(const OutlineBox &box, const mgPortExtent &extent) {
    float bounds_min[4] = {extent.left, extent.top, 0.0f, 0.0f};
    float bounds_max[4] = {extent.right, extent.bottom, 0.0f, 0.0f};
    int   min_bound[4];
    int   max_bound[4];
    mgFotI4(min_bound, bounds_min);
    mgFotI4(max_bound, bounds_max);

    OutlineBox padded{.left = box.left - kOutlinePad, .top = box.top - kOutlinePad, .right = box.right + kOutlinePad, .bottom = box.bottom + kOutlinePad};

    padded.left = std::max(padded.left, min_bound[0]);

    padded.top = std::max(padded.top, min_bound[1]);

    padded.right = std::min(padded.right, max_bound[0]);

    padded.bottom = std::min(padded.bottom, max_bound[1]);

    return padded;
}

int COutLineDraw::Draw(float scale, float alpha) {
    if (frame == nullptr || texture == nullptr || enable == 0) {
        return 0;
    }

    scale = OutlineScale(scale);

    if (width <= 0.0f) {
        frame->SetAttrParamObjAlpha(alpha, 1);
        return mgDrawDirect(frame);
    }

    const float scaled_width = width * scale;
    float       opacity = 1.0f;

    if (static_cast<int>(scaled_width) <= 0) {
        opacity = scaled_width;
    }

    opacity = std::max(opacity, 0.01f);

    const int edge_offset = OutlineEdgeOffset(width, scale);
    mgVu0FBOX draw_box{};

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
    // The free mouse look turns the display camera anywhere, so it keeps the whole extent.
    const std::optional<OutlineBox> previous_box = SwapDrawnBox(this, padded);
    const mgPortExtent              display = TownMouseFixedOwner() != nullptr
                                                  ? extent
                                                  : OutlineDisplayExtent(padded, previous_box ? &*previous_box : nullptr, edge_offset, extent);

    gfx::SetRenderTarget(outline);
    // Depth is not cleared: the image shares the scene's depth buffer.
    const gfx::LogicalRect display_clear = {.x = display.left, .y = display.top, .w = display.right - display.left, .h = display.bottom - display.top};
    gfx::Clear(true, clear_colour, false, 0.0f, &clear_rect, &display_clear);
    const int result = mgDrawDirect(frame);
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

    env.SetZBuf(depth_write ? MG_ZBUF_WRITE : MG_ZBUF_NO_WRITE);
    gfx::DrawState body_state = mgPortDrawState();
    body_state.blend = true;
    mgPortApplyDrawEnv(body_state, env);
    const bool body_overwrites_alpha = previous == gfx::kMainTarget &&
                                       gfx::ActiveRendererFeatures().dynamic_color_write_mask &&
                                       body_state.depth_test == gfx::DepthTest::Always && !body_state.depth_write && !body_state.stencil_test &&
                                       body_state.cull == gfx::CullMode::None && (body_state.color_write_mask & gfx::kWriteAlpha) != 0 &&
                                       body_state.alpha.a == 0 && body_state.alpha.b == 1 && body_state.alpha.c == 0 && body_state.alpha.d == 1 &&
                                       (!body_state.alpha_test || body_state.alpha_func == gfx::AlphaFunc::Always ||
                                        (body_state.alpha_func == gfx::AlphaFunc::GEqual && body_state.alpha_ref == 0));

    if (hide_edge == 0 && !(alpha < 1.0f) && edge_offset > 0 && !(opacity < 0.1f)) {
        const uint8_t edge_colour[4] = {static_cast<uint8_t>(static_cast<int>(color[0])),
                                        static_cast<uint8_t>(static_cast<int>(color[1])),
                                        static_cast<uint8_t>(static_cast<int>(color[2])),
                                        static_cast<uint8_t>(static_cast<int>(128.0f * opacity * alpha))};
        mgCDrawEnv    edge_env = env;
        edge_env.SetZBuf(MG_ZBUF_NO_WRITE);
        gfx::DrawState edge_state = mgPortDrawState();
        edge_state.blend = true;
        mgPortApplyDrawEnv(edge_state, edge_env);
        const bool defer_alpha = body_overwrites_alpha && edge_state == body_state;

        DrawCopy(box, display, edge_offset, 0, edge_colour, 0.0f, binding, edge_state, defer_alpha);
        DrawCopy(box, display, -edge_offset, 0, edge_colour, 0.0f, binding, edge_state, defer_alpha);
        DrawCopy(box, display, 0, edge_offset, edge_colour, 0.0f, binding, edge_state, defer_alpha);
        DrawCopy(box, display, 0, -edge_offset, edge_colour, 0.0f, binding, edge_state, defer_alpha);
    }

    const uint8_t body_colour[4] = {128, 128, 128, static_cast<uint8_t>(static_cast<int>(128.0f * alpha))};
    DrawCopy(box, display, 0, 0, body_colour, mgPortDepth(static_cast<uint32_t>(depth)), binding, body_state);

    // The composite's packets are the last writes to these registers.
    gs.test = env.test.value;
    gs.zbuf = env.zbuf.value;
    gs.alpha = env.alpha.value;
    return result;
}
