#include "common.h"

#include <algorithm>
#include <array>
#include <cmath>
#include <cstring>
#include <string>
#include <vector>

#include "gfx/gfx.hpp"
#include "libgraph.h"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "screeneffect.hpp"
#include "screeneffect_port.hpp"

namespace {

constexpr int      kDofColumns = 16;
constexpr uint64_t kDofTexa = 0x0000008000000080ull;
constexpr uint64_t kDofZbufMask = 1ull << 32;

struct FrameRect {
    int left;
    int top;
    int width;
    int height;
};

void DrawBlurLevel(gfx::TextureHandle level, const DepthOfFieldLevel &size, int index, const FrameRect &frame,
                   float depth, uint8_t alpha) {
    const float scale_u = static_cast<float>(size.width) / static_cast<float>(frame.width);
    const float scale_v = static_cast<float>(size.height) / static_cast<float>(frame.height);
    const float column_step = static_cast<float>(frame.width) / static_cast<float>(kDofColumns);
    const float z[2] = {DepthOfFieldDepth(depth), DepthOfFieldDepth(depth + depth / 10.0f)};
    const float top = static_cast<float>(frame.top);
    const float bottom = top + static_cast<float>(frame.height);

    // Retail's odd levels start with two equal depths at the left edge; the port keeps that seam.
    int parity = index % 2;
    std::vector<gfx::Vertex2D> strip;
    strip.reserve(2 * (kDofColumns + 1));

    for (int column = 0; column <= kDofColumns; ++column) {
        float column_z = z[0];

        if (column > 0) {
            parity = 1 - parity;
            column_z = z[parity];
        }

        const float x = static_cast<float>(frame.left) + column_step * static_cast<float>(column);
        const float u = (x - static_cast<float>(frame.left)) * scale_u;

        for (const float y : {top, bottom}) {
            gfx::Vertex2D vertex{};
            vertex.x = x;
            vertex.y = y;
            vertex.z = column_z;
            vertex.u = u;
            vertex.v = (y - top) * scale_v;
            vertex.color[0] = 0x80;
            vertex.color[1] = 0x80;
            vertex.color[2] = 0x80;
            vertex.color[3] = alpha;
            strip.push_back(vertex);
        }
    }

    gfx::DrawState state = mgPortDrawState();
    state.blend = true;
    state.alpha = gfx::GsBlend{0, 1, 0, 1, 0};
    state.depth_test = gfx::DepthTest::GEqual;
    state.screen_space = true;
    state.depth_write = false;
    state.alpha_test = false;
    state.texa_aem = false;
    state.texa_ta0 = 0x80;
    state.cull = gfx::CullMode::None;

    // Retail's blur textures have TCC 0: their alpha is TEXA's.
    gfx::TextureBinding binding;
    binding.texture = level;
    binding.ignore_alpha = true;
    mgPortDraw2D(gfx::Primitive::TriangleStrip, strip, binding, state);

    // Later draws read the GS mirror, so it holds what retail's prim leaves in the GS.
    mgPortGs().test = SCE_GS_SET_TEST(0, SCE_GS_GEQUAL, 0, 0, 0, 0, 1, SCE_GS_ZGEQUAL);
    mgPortGs().zbuf |= kDofZbufMask;
    mgPortGs().alpha = SCE_GS_SET_ALPHA(SCE_GS_ALPHA_CS, SCE_GS_ALPHA_CD, SCE_GS_ALPHA_AS, SCE_GS_ALPHA_CD, 0);
    mgPortGs().texa = kDofTexa;
}

} // namespace

DepthOfFieldLevel DepthOfFieldLevelSize(int level, int frame_width, int frame_height) {
    // Retail steps the sizes in 12.4 GS units and truncates to texels only at the end: a plain
    // integer 2/3 of 106 rows gives 70 where the GS arithmetic gives 71.
    int width_units = frame_width * 8;
    int height_units = frame_height * 8;

    for (int step = 0; step < level; ++step) {
        width_units = width_units * 2 / 3;
        height_units = height_units * 2 / 3;
    }

    return DepthOfFieldLevel{width_units / 16, height_units / 16};
}

float DepthOfFieldDepth(float distance) {
    float eye_to_clip[16];
    mgPortEyeToClip(mgPortCurrentProjection(), mgPortCurrentTarget(), eye_to_clip);

    // The GS Z is unsigned: distances past the far plane land on the far value, not behind it.
    return std::clamp(eye_to_clip[10] + eye_to_clip[14] / distance, 0.0f, 1.0f);
}

// Set while the menu's close-up snapshot of the world is taken: the focus band is tuned for the walking
// camera, so at that range it would blur the whole picture.
bool MenuSnapshotNoDepthOfField = false;

PORT_OVERRIDE void DepthOfField(int levels, float *depths, mgCTexture *work_texture, float strength) {
    // Retail draws nothing without its work texture.
    if (work_texture == NULL || MenuSnapshotNoDepthOfField) {
        return;
    }

    // The grab is the main target, so the blur only means something on it.
    if (mgPortCurrentTarget() != gfx::kMainTarget) {
        return;
    }

    const mgPortExtent extent = mgPortVisibleExtent();
    const FrameRect frame{
        static_cast<int>(std::lround(extent.left)),
        static_cast<int>(std::lround(extent.top)),
        static_cast<int>(std::lround(extent.right)) - static_cast<int>(std::lround(extent.left)),
        static_cast<int>(std::lround(extent.bottom)) - static_cast<int>(std::lround(extent.top)),
    };

    // Ordinary targets, not frame targets: a frame target is the window's pixel width, so a
    // half-size level made as one would be full size and never blur.
    gfx::TextureHandle source = gfx::NamedRenderTarget("dof frame", frame.width, frame.height, false);
    gfx::BlitTexture(gfx::kMainTarget, gfx::Rect{frame.left, frame.top, frame.width, frame.height}, source,
                     gfx::Rect{0, 0, frame.width, frame.height}, gfx::Filter::Linear);

    const uint8_t alpha = static_cast<uint8_t>(std::clamp(static_cast<int>(128.0f * strength), 0, 255));
    DepthOfFieldLevel previous{frame.width, frame.height};

    for (int level = 0; level < levels; ++level) {
        const DepthOfFieldLevel size = DepthOfFieldLevelSize(level, frame.width, frame.height);
        const gfx::TextureHandle target =
            gfx::NamedRenderTarget("dof level " + std::to_string(level), size.width, size.height, false);

        // No half-texel shift before each move: retail's -8 (12.4) is a GS sampling-centre fix, and a
        // Linear blit samples texel centres itself.
        gfx::BlitTexture(source, gfx::Rect{0, 0, previous.width, previous.height}, target,
                         gfx::Rect{0, 0, size.width, size.height}, gfx::Filter::Linear);
        DrawBlurLevel(target, size, level, frame, depths[level], alpha);

        source = target;
        previous = size;
    }
}

namespace {

using FlareColour = std::array<uint8_t, 4>;

constexpr uint64_t kFlareZbufMask = 1ull << 32;
constexpr uint64_t kFlareTexa = 0x0000008000000080ull;
// ALPHA of retail's MG_ALPHA_BLEND_ADD, as the GS keeps it.
constexpr uint64_t kFlareAddAlpha = 0x48;
constexpr uint64_t kFlareZtstAlways = 1;

constexpr gfx::GsBlend kFlareAdd{0, 2, 0, 1, 0x80};
constexpr gfx::GsBlend kFlareAddFull{0, 2, 2, 1, 0x80};
constexpr gfx::GsBlend kFlareSub{2, 0, 0, 1, 0x80};
// Retail's starburst mask is the alpha its DATE pass tests; DrawState has no DATE, so the mask is
// multiplied in from the mask target and the alpha put back to what the DATE pass leaves.
constexpr gfx::GsBlend kFlareScaleByAlpha{1, 2, 0, 2, 0x80};
constexpr gfx::GsBlend kFlareKeepColour{0, 0, 0, 1, 0x80};

static_assert(sizeof(sceGsTex1) == sizeof(uint64_t), "TEX1 is copied as its 64-bit GS value");

uint8_t FlareByte(float value) {
    return static_cast<uint8_t>(std::clamp(static_cast<int>(value), 0, 255));
}

gfx::Vertex2D FlareVertex(float x, float y, float u, float v, const FlareColour &colour, float z = 0.0f) {
    gfx::Vertex2D vertex{};
    vertex.x = x;
    vertex.y = y;
    vertex.z = z;
    vertex.u = u;
    vertex.v = v;

    for (int channel = 0; channel < 4; ++channel) {
        vertex.color[channel] = colour[channel];
    }

    return vertex;
}

void AppendQuad(std::vector<gfx::Vertex2D> &out, float left, float top, float right, float bottom, float u0,
                float v0, float u1, float v1, const FlareColour &colour, float z = 0.0f) {
    out.push_back(FlareVertex(left, top, u0, v0, colour, z));
    out.push_back(FlareVertex(right, top, u1, v0, colour, z));
    out.push_back(FlareVertex(right, bottom, u1, v1, colour, z));
    out.push_back(FlareVertex(left, bottom, u0, v1, colour, z));
}

// Retail's 24-spoke star, alternating between its two radii; the spokes are 12.4 units from the centre.
void AppendStarburst(std::vector<gfx::Vertex2D> &out, int centre_x, int centre_y, int small_width, int small_height,
                     const FlareColour &centre, const FlareColour &ring) {
    int radii[2] = {0, 0};
    radii[0] = (small_width + small_height) * 6;
    radii[1] = radii[0] - small_width;

    out.push_back(FlareVertex(centre_x / 16.0f, centre_y / 16.0f, 0.0f, 0.0f, centre));

    int   radius_index = 0;
    float angle = 0.0f;

    while (angle < TWO_PI) {
        const int x = static_cast<int>(static_cast<float>(radii[radius_index]) * sinf(angle));
        const int y = static_cast<int>(static_cast<float>(radii[radius_index]) * cosf(angle));
        out.push_back(FlareVertex((x + centre_x) / 16.0f, (y + centre_y) / 16.0f, 0.0f, 0.0f, ring));
        radius_index = !radius_index;
        angle += (PI / 12.0f);
    }

    out.push_back(FlareVertex(centre_x / 16.0f, (centre_y - radii[radius_index]) / 16.0f, 0.0f, 0.0f, ring));
}

// Retail's frame buffer switches reset the scissor to the whole target, so no pass inherits the game's.
gfx::DrawState FlarePass(gfx::DepthTest depth, const gfx::GsBlend *alpha = nullptr) {
    gfx::DrawState state = mgPortDrawState();
    state.blend = alpha != nullptr;
    if (alpha != nullptr) {
        state.alpha = *alpha;
    }
    state.depth_test = depth;
    state.depth_write = false;
    state.alpha_test = false;
    state.fog = false;
    state.cull = gfx::CullMode::None;
    state.scissor = false;
    state.stencil_test = false;
    state.texa_aem = false;
    state.texa_ta0 = 0x80;
    return state;
}

gfx::TextureBinding FlareSample(gfx::TextureHandle texture, bool has_alpha, gfx::Filter filter) {
    gfx::TextureBinding binding;
    binding.texture = texture;
    binding.filter = filter;
    binding.ignore_alpha = !has_alpha;
    return binding;
}

// The visible extent's half width is retail's width / 2 in the frame's coordinates.
float FlareDistance(const LensFlareSun &sun) {
    const mgPortExtent extent = mgPortVisibleExtent();
    const float        dx = static_cast<float>(sun.x) / 16.0f - (extent.left + extent.half_width);
    const float        dy = static_cast<float>(sun.y) / 16.0f - (extent.top + extent.half_height);
    return std::sqrt(dx * dx + dy * dy);
}

} // namespace

LensFlareSun LensFlareSunOf(const int screen[4]) {
    return LensFlareSun{screen[0], screen[1], mgPortDepth(static_cast<uint32_t>(screen[2]))};
}

bool LensFlareInRange(const LensFlareSun &sun) {
    // Retail's limit is the full screen width, not the half the centre uses.
    const mgPortExtent extent = mgPortVisibleExtent();
    return FlareDistance(sun) <= extent.right - extent.left;
}

void LensFlareDraw(const LensFlareSun &sun, const float colour[4], const LensFlareSource &source) {
    if (!LensFlareInRange(sun) || !mgPortRendererReady() || !mgPortFrameOpen()) {
        return;
    }

    // Shares the main depth: the occlusion plate is tested against the scene exactly as on the GS.
    const uint32_t           frame_w = static_cast<uint32_t>(mgScreenWidth);
    const uint32_t           frame_h = static_cast<uint32_t>(mgScreenHeight);
    const gfx::TextureHandle entry = mgPortCurrentTarget();
    const gfx::TextureHandle first = gfx::NamedRenderTarget("lens flare a", frame_w, frame_h, true, true);
    const gfx::TextureHandle second = gfx::NamedRenderTarget("lens flare b", frame_w, frame_h, true, true);
    const gfx::TextureHandle mask = gfx::NamedRenderTarget("lens flare mask", frame_w, frame_h, true, false);

    if (first == gfx::kNullTexture || second == gfx::kNullTexture || mask == gfx::kNullTexture) {
        return;
    }

    const mgPortExtent extent = mgPortVisibleExtent();
    const float        visible_width = extent.right - extent.left;
    float              fade = 1.0f - FlareDistance(sun) / visible_width;

    if (!(fade <= 1.0f)) {
        fade = 1.0f;
    }

    const float alpha_scale = 0.7f * (fade * fade);

    // Texture-space sizes are retail's frame sizes; only the screen-space quads follow the visible extent.
    const int   small_width = mgScreenWidth / 3;
    const int   small_height = mgScreenHeight / 3;
    const float small_w = static_cast<float>(small_width);
    const float small_h = static_cast<float>(small_height);
    const float downsample_right = static_cast<float>(mgScreenWidth * 16 / 3) / 16.0f;
    const float downsample_bottom = static_cast<float>(mgScreenHeight * 16 / 3) / 16.0f;
    const float downsample_u = static_cast<float>(mgScreenWidth * 16 + 0x40) / 16.0f;
    const float downsample_v = static_cast<float>(mgScreenHeight * 16 + 0x40) / 16.0f;

    const gfx::LogicalRect      whole{extent.left, extent.top, visible_width, extent.bottom - extent.top};
    const FlareColour           black_opaque{0, 0, 0, 0x80};
    const FlareColour           white_opaque{0xFF, 0xFF, 0xFF, 0x80};
    const FlareColour           identity{0x80, 0x80, 0x80, 0x80};
    const FlareColour           clear_mask{0, 0, 0, 0};
    const int                   centre_x = sun.x / 3;
    const int                   centre_y = sun.y / 3;

    // Occlusion plate: grey where the sun's depth passes the scene's, black where geometry is nearer.
    gfx::SetRenderTarget(first);
    gfx::Clear(true, black_opaque.data(), false, 0.0f, &whole);
    std::vector<gfx::Vertex2D> plate;
    AppendQuad(plate, extent.left, extent.top, extent.right, extent.bottom, 0.0f, 0.0f, 0.0f, 0.0f,
               FlareColour{0x20, 0x20, 0x20, 0x80}, sun.depth);
    mgPortDraw2D(gfx::Primitive::Quads, plate, gfx::TextureBinding{}, FlarePass(gfx::DepthTest::GEqual));

    gfx::SetRenderTarget(second);
    std::vector<gfx::Vertex2D> downsample;
    AppendQuad(downsample, 0.0f, 0.0f, downsample_right, downsample_bottom, 0.0f, 0.0f, downsample_u, downsample_v,
               identity);
    mgPortDraw2D(gfx::Primitive::Quads, downsample, FlareSample(first, source.first_alpha, gfx::Filter::Linear),
                 FlarePass(gfx::DepthTest::Always));

    gfx::SetRenderTarget(first);
    std::vector<gfx::Vertex2D> seed;
    AppendQuad(seed, 0.0f, 0.0f, small_w, small_h + 1.0f, 0.0f, 0.0f, small_w + 1.0f, small_h + 1.0f, identity);
    mgPortDraw2D(gfx::Primitive::Quads, seed, FlareSample(second, source.second_alpha, gfx::Filter::Linear),
                 FlarePass(gfx::DepthTest::Always));

    // The offsets are 12.4 raw, so they are sub-pixel to three pixels, as retail's Vertex4 writes them.
    bool current_is_first = true;

    for (int pass = 0; pass < 4; ++pass) {
        const int     brightness = static_cast<int>(128.0f * (static_cast<float>(4 - pass) / 4.0f));
        const int     spread = static_cast<int>(10.0f * static_cast<float>(pass + 1));
        const int     near_edge = spread - 8;
        const int     far_edge = -8 - spread;
        const int     wide = small_width * 16;
        const int     high = small_height * 16;
        const uint8_t level = static_cast<uint8_t>(brightness);
        const FlareColour tint{level, level, level, 0x80};
        const int     offsets[4][2] = {{near_edge, near_edge}, {far_edge, far_edge}, {near_edge, far_edge},
                                       {far_edge, near_edge}};

        std::vector<gfx::Vertex2D> ghosts;

        for (const auto &offset : offsets) {
            AppendQuad(ghosts, static_cast<float>(offset[0]) / 16.0f, static_cast<float>(offset[1]) / 16.0f,
                       static_cast<float>(wide + offset[0]) / 16.0f, static_cast<float>(high + offset[1]) / 16.0f,
                       0.0f, 0.0f, small_w, small_h, tint);
        }

        const gfx::TextureHandle target = current_is_first ? second : first;
        const gfx::TextureHandle sampled = current_is_first ? first : second;
        const bool               sampled_alpha = current_is_first ? source.first_alpha : source.second_alpha;
        gfx::SetRenderTarget(target);
        mgPortDraw2D(gfx::Primitive::Quads, ghosts, FlareSample(sampled, sampled_alpha, gfx::Filter::Linear),
                     FlarePass(gfx::DepthTest::Always, &kFlareAddFull));
        current_is_first = !current_is_first;
    }

    gfx::SetRenderTarget(mask);
    gfx::Clear(true, clear_mask.data(), false, 0.0f, nullptr);
    std::vector<gfx::Vertex2D> star;
    AppendStarburst(star, centre_x, centre_y, small_width, small_height, black_opaque, white_opaque);
    mgPortDraw2D(gfx::Primitive::TriangleFan, star, gfx::TextureBinding{}, FlarePass(gfx::DepthTest::Always));

    gfx::SetRenderTarget(first);
    std::vector<gfx::Vertex2D> masked;
    AppendQuad(masked, 0.0f, 0.0f, small_w, small_h, 0.0f, 0.0f, small_w, small_h, identity);
    mgPortDraw2D(gfx::Primitive::Quads, masked, FlareSample(mask, true, gfx::Filter::Nearest),
                 FlarePass(gfx::DepthTest::Always, &kFlareScaleByAlpha));

    std::vector<gfx::Vertex2D> gradient;
    AppendStarburst(gradient, centre_x, centre_y, small_width, small_height, black_opaque, white_opaque);
    mgPortDraw2D(gfx::Primitive::TriangleFan, gradient, gfx::TextureBinding{},
                 FlarePass(gfx::DepthTest::Always, &kFlareSub));

    std::vector<gfx::Vertex2D> alpha_set;
    AppendQuad(alpha_set, 0.0f, 0.0f, small_w, small_h, 0.0f, 0.0f, 0.0f, 0.0f, black_opaque);
    mgPortDraw2D(gfx::Primitive::Quads, alpha_set, gfx::TextureBinding{},
                 FlarePass(gfx::DepthTest::Always, &kFlareKeepColour));

    // Composite: retail's two identical sprites, so the flare is added twice.
    gfx::SetRenderTarget(entry);
    const FlareColour composite_colour{FlareByte(colour[0]), FlareByte(colour[1]), FlareByte(colour[2]),
                                       FlareByte(colour[3] * alpha_scale)};
    std::vector<gfx::Vertex2D> composite;

    for (int copy = 0; copy < 2; ++copy) {
        AppendQuad(composite, extent.left, extent.top, extent.right, extent.bottom, 0.0f, 0.0f, small_w, small_h,
                   composite_colour);
    }

    mgPortDraw2D(gfx::Primitive::Quads, composite, FlareSample(first, source.first_alpha, gfx::Filter::Linear),
                 FlarePass(gfx::DepthTest::Always, &kFlareAdd));

    // Leave the GS as retail's last sprite does.
    mgPortGsState &gs = mgPortGs();
    gs.test = SCE_GS_SET_TEST(0, SCE_GS_GEQUAL, 0, 0, 0, 0, 1, kFlareZtstAlways);
    gs.zbuf |= kFlareZbufMask;
    gs.alpha = kFlareAddAlpha;
    gs.texa = kFlareTexa;
    gs.tex1 = source.tex1;
    gs.scissor[0] = 0;
    gs.scissor[1] = 0;
    gs.scissor[2] = mgScreenWidth - 1;
    gs.scissor[3] = mgScreenHeight - 1;
}

PORT_OVERRIDE void LensFlare(sceVu0IVECTOR screen, sceVu0FVECTOR color, int bank, char *texture_a, char *texture_b) {
    const LensFlareSun sun = LensFlareSunOf(screen);

    // Retail returns before it reloads the bank for an out-of-range sun.
    if (!LensFlareInRange(sun)) {
        return;
    }

    mgTexManager.ReloadTexture(bank, (sceVif1Packet *) NULL);
    mgCTexture *first = mgTexManager.GetTexture(texture_a, bank);
    mgCTexture *second = mgTexManager.GetTexture(texture_b, bank);

    if (first == NULL || second == NULL) {
        return;
    }

    mgCTexture sampled;
    sampled.tex1 = first->tex1;
    sampled.Bilinear(1);

    LensFlareSource source{};
    source.first_alpha = first->tex0.bits.tcc != 0;
    source.second_alpha = second->tex0.bits.tcc != 0;
    std::memcpy(&source.tex1, &sampled.tex1, sizeof source.tex1);
    LensFlareDraw(sun, color, source);
}
