#include "common.h"

#include <SDL3/SDL.h>
#include <gtest/gtest.h>

#include <array>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <memory>
#include <optional>
#include <string>
#include <vector>

#include "actionchara.hpp"
#include "dataread.hpp"
#include "dataread_port.hpp"
#include "dng_hud.hpp"
#include "dng_main.hpp"
#include "dng_object.hpp"
#include "dng_pickup_port.hpp"
#include "editctrl_port.hpp"
#include "effectlist.hpp"
#include "gfx/displaylist.hpp"
#include "gfx/gfx.hpp"
#include "gfx_fixture.hpp"
#include "mainloop.hpp"
#include "mainloop_port.hpp"
#include "maintex.hpp"
#include "map.hpp"
#include "menu_mouse.hpp"
#include "mg_drawprim.hpp"
#include "mg_drawprim_port.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mg_texture_port.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "monster.hpp"
#include "nd_meswin.hpp"
#include "platform/clock.hpp"
#include "platform/firstrun.hpp"
#include "platform/input.hpp"
#include "platform/mouse.hpp"
#include "platform/paths.hpp"
#include "platform/window.hpp"
#include "present.hpp"
#include "scenesnd.hpp"
#include "texture_source.hpp"
#include "userdata.hpp"

// Register macros must follow the host and test headers.
// clang-format off
#include "libgraph.h"
// clang-format on

using namespace dc::test;

namespace {

struct TextureSourceScope {
    const void *buffer;
    ~TextureSourceScope() { TextureSourceForget(buffer); }
};

class PresentRenderer {
public:
    PresentRenderer(int width, int height) {
        SetEnv("VK_LAYER_VALIDATE_SYNC", "1", 0);
        WindowConfig window{width, height, true};
        window.vulkan = false;
        WindowInit(window);

        gfx::RendererConfig config;
        config.app_name = "Dark Chronicle present tests";
        config.logical_width = 512.0f;
        config.logical_height = 480.0f;
        config.display_aspect = 4.0f / 3.0f;
        config.validation = true;
        config.offscreen = true;
        config.pipeline_cache = std::filesystem::temp_directory_path() / "dc_gfx_test" /
                                ("mglib_present_" + std::to_string(ProcessId()) + ".bin");
        gfx::RendererInit(WindowHandle(), config);

        ClockSetUnbounded(true);
        mgInit(MG_SCREEN_MODE_512X480, 3);
    }

    ~PresentRenderer() {
        gfx::RendererShutdown();
        WindowShutdown();
        EXPECT_EQ(gfx::ValidationMessageCount(), 0u);
    }
};

gfx::Vertex2D QuadCorner(float x, float y) {
    gfx::Vertex2D vertex = {};
    vertex.x = x;
    vertex.y = y;
    vertex.z = 1.0f;
    vertex.color[0] = 0xFF;
    vertex.color[1] = 0xFF;
    vertex.color[2] = 0xFF;
    vertex.color[3] = 0xFF;
    return vertex;
}

size_t PixelOffset(const gfx::LogicalMapping &mapping, uint32_t width, float x, float y) {
    const size_t px = static_cast<size_t>(x * mapping.scale_x + mapping.offset_x);
    const size_t py = static_cast<size_t>(y * mapping.scale_y + mapping.offset_y);
    return (py * width + px) * 4;
}

using Matrix = std::array<float, 16>;

// Column-major, as MeshTransform and MeshConstants hold them.
Matrix Identity() {
    Matrix m{};
    m[0] = m[5] = m[10] = m[15] = 1.0f;
    return m;
}

Matrix Translation(float x) {
    Matrix m = Identity();
    m[12] = x;
    return m;
}

Matrix Multiply(const Matrix &a, const Matrix &b) {
    Matrix out{};
    for (size_t col = 0; col < 4; ++col) {
        for (size_t row = 0; row < 4; ++row) {
            for (size_t k = 0; k < 4; ++k) {
                out[col * 4 + row] += a[k * 4 + row] * b[col * 4 + k];
            }
        }
    }
    return out;
}

// One world unit is four pixels on the 640x480 target, and depth is a constant 0.5.
constexpr float kPixelsPerUnit = 4.0f;

Matrix Projection() {
    Matrix m{};
    m[0] = 2.0f * kPixelsPerUnit / 640.0f;
    m[5] = 2.0f * kPixelsPerUnit / 480.0f;
    m[14] = 0.5f;
    m[15] = 1.0f;
    return m;
}

void Store(const Matrix &m, float (&out)[16]) {
    std::memcpy(out, m.data(), sizeof out);
}

gfx::Vertex3D RedVertex(float x, float y) {
    gfx::Vertex3D vertex = {};
    vertex.position[0] = x;
    vertex.position[1] = y;
    vertex.normal[2] = 1.0f;
    vertex.color[0] = 0xFF;
    vertex.color[3] = 0xFF;
    return vertex;
}

// A 10 by 10 unit red square, centred on its model origin, moved to x by the model translation.
void DrawRedQuad(float x) {
    const std::vector<gfx::Vertex3D> vertices = {
        RedVertex(-5.0f, -5.0f),
        RedVertex(5.0f, -5.0f),
        RedVertex(5.0f, 5.0f),
        RedVertex(-5.0f, 5.0f),
    };
    const std::vector<uint32_t> indices = {0, 1, 2, 0, 2, 3};

    const Matrix projection = Projection();
    const Matrix view = Identity();
    const Matrix model = Translation(x);

    gfx::MeshTransform transform = gfx::IdentityMeshTransform();
    Store(projection, transform.projection);
    Store(view, transform.view);
    Store(model, transform.model);

    gfx::MeshConstants constants{};
    constants.flags = gfx::kMeshVertexColor;
    Store(Multiply(Multiply(projection, view), model), constants.mvp);
    constants.diffuse[0] = constants.diffuse[1] = constants.diffuse[2] = constants.diffuse[3] = 1.0f;

    gfx::DrawState state;
    state.depth_test = gfx::DepthTest::Always;

    mgPortDrawMeshImmediate(vertices, indices, constants, gfx::TextureBinding{}, state, &transform);
}

// Mean column of the pixels that read as the quad's red.
void RedCentroidX(const std::vector<uint8_t> &rgba, uint32_t width, uint32_t height, double &x) {
    double sum = 0.0;
    size_t count = 0;
    for (uint32_t y = 0; y < height; ++y) {
        for (uint32_t px = 0; px < width; ++px) {
            const uint8_t *p = &rgba[(static_cast<size_t>(y) * width + px) * 4];
            if (p[0] > 200 && p[1] < 60 && p[2] < 60) {
                sum += px;
                ++count;
            }
        }
    }
    ASSERT_GT(count, 0u);
    x = sum / static_cast<double>(count);
}

void RecordTicks(int count, const void *object, float first_x) {
    for (int tick = 0; tick < count; ++tick) {
        mgBeginFrame(nullptr);
        {
            mgPortInterpScope scope(object, 1000.0f);
            DrawRedQuad(first_x + 10.0f * static_cast<float>(tick));
        }
        mgEndFrame(nullptr);
    }
}

using Quads = std::vector<u_long128>;

constexpr int kTextureCount = 64;
constexpr int kBlockCount = 8;
constexpr size_t kStorageQuads = 4096;

Quads Pack(const std::vector<uint8_t> &bytes) {
    Quads quads((bytes.size() + 15) / 16 + 1, 0);
    std::memcpy(quads.data(), bytes.data(), bytes.size());
    return quads;
}

std::vector<uint8_t> Fill(size_t texels, uint8_t r, uint8_t g, uint8_t b, uint8_t a) {
    std::vector<uint8_t> out(texels * 4);
    for (size_t t = 0; t < texels; ++t) {
        out[t * 4 + 0] = r;
        out[t * 4 + 1] = g;
        out[t * 4 + 2] = b;
        out[t * 4 + 3] = a;
    }
    return out;
}

// Entry p is (p, 255 - p, 0x10, 0x80).
std::vector<uint8_t> Clut8() {
    std::vector<uint8_t> out(256 * 4);
    for (size_t p = 0; p < 256; ++p) {
        out[p * 4 + 0] = static_cast<uint8_t>(p);
        out[p * 4 + 1] = static_cast<uint8_t>(255 - p);
        out[p * 4 + 2] = 0x10;
        out[p * 4 + 3] = 0x80;
    }
    return out;
}

uint64_t Tex0Bits(const mgCTexture *texture) {
    uint64_t bits = 0;
    std::memcpy(&bits, &texture->tex0, sizeof bits);
    return bits;
}

std::vector<uint8_t> ReadTexture(gfx::TextureHandle texture, uint32_t &width, uint32_t &height) {
    std::vector<uint8_t> pixels;
    EXPECT_TRUE(gfx::ReadbackTexture(texture, pixels, width, height));
    return pixels;
}

// Registers textures the way the game does: the registry key lands in TBP0 and CBP.
class Textures {
public:
    Textures() {
        memory_.stSetBuffer(storage_.data(), static_cast<int>(storage_.size()));
        manager_.SetTableBuffer(kTextureCount, kBlockCount, &memory_);
        manager_.Initialize(0x1000, -1);
    }

    ~Textures() {
        manager_.Initialize(0x1000, -1);
    }

    Textures(const Textures &) = delete;
    Textures &operator=(const Textures &) = delete;

    mgCTexture *Enter(const std::string &name, int width, int height, int bpp, u_long128 *image, u_long128 *clut) {
        std::string owned = name;
        u_long128 *levels[MG_TEXTURE_LEVEL_MAX] = {image};
        return manager_.EnterTexture(0, owned.data(), levels, width, height, bpp, clut, 0, 0);
    }

    void Delete(mgCTexture *texture) {
        manager_.DeleteTexture(texture);
    }

private:
    Quads             storage_ = Quads(kStorageQuads, 0);
    mgCMemory         memory_;
    mgCTextureManager manager_;
};

} // namespace

TEST(MglibPresent, InterpScopeRestoresKey) {
    PresentRenderer renderer(640, 480);

    int some_int = 0;
    int other = 0;

    gfx::SetInterpKey(7);
    {
        mgPortInterpScope scope(&some_int, kMgPortFrameTeleportDistance);
        EXPECT_EQ(gfx::CurrentInterpKey(), reinterpret_cast<uintptr_t>(&some_int));
        {
            mgPortInterpScope inner(&other, 1.0f, false, true);
            EXPECT_TRUE(gfx::CurrentNoInterpolation());
        }
        EXPECT_FALSE(gfx::CurrentNoInterpolation());
    }
    EXPECT_EQ(gfx::CurrentInterpKey(), 7u);
    gfx::SetInterpKey(0);
}

TEST(MglibPresent, TickIsRecordedAndRenderedCanonically) {
    PresentRenderer renderer(640, 480);

    mgSetBackGround(64.0f, 128.0f, 192.0f, 128.0f);
    mgBeginFrame(nullptr);
    EXPECT_TRUE(mgPortRecording());

    const std::array<gfx::Vertex2D, 4> quad = {
        QuadCorner(100.0f, 100.0f),
        QuadCorner(200.0f, 100.0f),
        QuadCorner(200.0f, 200.0f),
        QuadCorner(100.0f, 200.0f),
    };
    mgPortDraw2D(gfx::Primitive::Quads, quad, gfx::TextureBinding{}, mgPortDrawState());

    mgEndFrame(nullptr);
    EXPECT_FALSE(mgPortRecording());

    ASSERT_NE(mgPortLastList(), nullptr);
    EXPECT_EQ(gfx::ListStats(*mgPortLastList()).draws_2d, 1u);

    std::vector<uint8_t> rgba;
    uint32_t             width = 0;
    uint32_t             height = 0;
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, rgba, width, height));

    const gfx::LogicalMapping mapping = gfx::GetLogicalMapping(gfx::kMainTarget);

    const size_t inside = PixelOffset(mapping, width, 150.0f, 150.0f);
    EXPECT_NEAR(rgba[inside + 0], 255, 1);
    EXPECT_NEAR(rgba[inside + 1], 255, 1);
    EXPECT_NEAR(rgba[inside + 2], 255, 1);

    const size_t outside = PixelOffset(mapping, width, 50.0f, 50.0f);
    EXPECT_NEAR(rgba[outside + 0], 64, 1);
    EXPECT_NEAR(rgba[outside + 1], 128, 1);
    EXPECT_NEAR(rgba[outside + 2], 192, 1);

    mgBeginFrame(nullptr);
    mgEndFrame(nullptr);
    EXPECT_NE(mgPortPreviousList(), nullptr);
}

TEST(MglibPresent, FrameTargetFlag) {
    PresentRenderer renderer(1280, 720);

    const gfx::TextureHandle framed = mgPortRenderTarget(0x3000u, 512, 480, SCE_GS_PSMCT32, true);
    const std::optional<gfx::TextureInfo> framed_info = gfx::GetTextureInfo(framed);
    ASSERT_TRUE(framed_info.has_value());
    EXPECT_TRUE(framed_info->frame_target);

    const gfx::TextureHandle plain = mgPortRenderTarget(0x3000u, 512, 480, SCE_GS_PSMCT32, false);
    const std::optional<gfx::TextureInfo> plain_info = gfx::GetTextureInfo(plain);
    ASSERT_TRUE(plain_info.has_value());
    EXPECT_FALSE(plain_info->frame_target);

    EXPECT_EQ(mgPortRenderTarget(0x3000u, 512, 480, SCE_GS_PSMCT32, false), plain);
}

TEST(MglibPresent, CutBeforeTickIsAccepted) {
    PresentRenderer renderer(640, 480);

    mgPortCutInterpolation();
    mgBeginFrame(nullptr);
    mgEndFrame(nullptr);

    EXPECT_FALSE(mgPortRecording());
}

TEST(MglibPresent, DisplayFrameAtHalfInterpolatesTaggedMesh) {
    PresentRenderer renderer(640, 480);
    PresentResetStats();
    PresentSetSettings(PresentSettings{.interpolation = true, .display_per_tick = 0});

    static int object;
    mgPortCutInterpolation();

    std::vector<uint8_t> rgba;
    uint32_t             width = 0;
    uint32_t             height = 0;

    RecordTicks(1, &object, 0.0f);
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, rgba, width, height));
    double first = 0.0;
    RedCentroidX(rgba, width, height, first);

    RecordTicks(1, &object, 10.0f);
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, rgba, width, height));
    double second = 0.0;
    RedCentroidX(rgba, width, height, second);

    ASSERT_NE(mgPortLastList(), nullptr);
    ASSERT_NE(mgPortPreviousList(), nullptr);
    EXPECT_NEAR(second - first, 10.0 * kPixelsPerUnit, 1.0);

    gfx::RenderOptions options;
    options.previous = mgPortPreviousList();
    options.present = true;
    ASSERT_TRUE(gfx::RenderList(*mgPortLastList(), 0.5f, options));
    ASSERT_TRUE(gfx::ReadbackFrame(rgba, width, height));

    double half = 0.0;
    RedCentroidX(rgba, width, height, half);
    EXPECT_NEAR(half, (first + second) / 2.0, 1.0);
}

TEST(MglibPresent, InterpolationOffPresentsOncePerTick) {
    PresentRenderer renderer(640, 480);
    PresentResetStats();
    PresentSetSettings(PresentSettings{.interpolation = false});

    static int object;
    mgPortCutInterpolation();
    RecordTicks(3, &object, 0.0f);

    const PresentStats stats = PresentGetStats();
    EXPECT_EQ(stats.ticks, 3u);
    EXPECT_EQ(stats.display_frames, 0u);
    EXPECT_EQ(stats.canonical_presents, 3u);
    EXPECT_EQ(stats.presented, 3u);
}

TEST(MglibPresent, ScreenshotDisplayWithInterpolationOffIgnoresAlpha) {
    PresentRenderer renderer(640, 480);
    PresentResetStats();
    PresentSetSettings(PresentSettings{.interpolation = false});

    static int object;
    mgPortCutInterpolation();
    RecordTicks(2, &object, 0.0f);

    std::vector<uint8_t> at_zero;
    std::vector<uint8_t> at_half;
    uint32_t             width = 0;
    uint32_t             height = 0;
    ASSERT_TRUE(PresentScreenshotDisplay(0.0f, at_zero, width, height));
    ASSERT_TRUE(PresentScreenshotDisplay(0.5f, at_half, width, height));
    EXPECT_EQ(at_zero, at_half);

    PresentSetSettings(PresentSettings{.interpolation = true});
    ASSERT_TRUE(PresentScreenshotDisplay(0.0f, at_zero, width, height));
    ASSERT_TRUE(PresentScreenshotDisplay(0.5f, at_half, width, height));
    EXPECT_NE(at_zero, at_half);
}

TEST(MglibPresent, ScreenshotDisplayWithInterpolationOffNeedsOnlyOneTick) {
    PresentRenderer renderer(640, 480);
    PresentSetSettings(PresentSettings{.interpolation = false});
    static int object;
    mgPortCutInterpolation();
    RecordTicks(1, &object, 0.0f);
    ASSERT_NE(mgPortLastList(), nullptr);
    ASSERT_EQ(mgPortPreviousList(), nullptr);

    std::vector<uint8_t> canonical;
    std::vector<uint8_t> display;
    uint32_t             width = 0;
    uint32_t             height = 0;
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, canonical, width, height));
    double centroid = 0.0;
    RedCentroidX(canonical, width, height, centroid);
    for (float alpha : {0.0f, 0.5f, 1.0f}) {
        ASSERT_TRUE(PresentScreenshotDisplay(alpha, display, width, height));
        EXPECT_EQ(display, canonical);
    }
    PresentSetSettings(PresentSettings{.interpolation = true});
    EXPECT_FALSE(PresentScreenshotDisplay(0.5f, display, width, height));
}

TEST(MglibPresent, DisplayPerTickRendersAndDiscards) {
    PresentRenderer renderer(640, 480);
    PresentResetStats();
    PresentSetSettings(PresentSettings{.interpolation = true, .display_per_tick = 4});

    static int object;
    mgPortCutInterpolation();
    RecordTicks(3, &object, 0.0f);

    const PresentStats stats = PresentGetStats();
    EXPECT_EQ(stats.ticks, 3u);
    EXPECT_EQ(stats.display_frames, 12u);
    EXPECT_EQ(stats.canonical_presents, 3u);
    EXPECT_EQ(stats.presented, 3u);
}

TEST(MglibPresent, DisplayPerTickLeavesCanonicalImage) {
    PresentRenderer renderer(640, 480);
    PresentResetStats();

    static int object;
    std::vector<uint8_t> with_display;
    std::vector<uint8_t> without_display;
    uint32_t             width = 0;
    uint32_t             height = 0;

    PresentSetSettings(PresentSettings{.interpolation = true, .display_per_tick = 4});
    mgPortCutInterpolation();
    RecordTicks(3, &object, 0.0f);
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, with_display, width, height));

    PresentSetSettings(PresentSettings{.interpolation = true, .display_per_tick = 0});
    mgPortCutInterpolation();
    RecordTicks(3, &object, 0.0f);
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, without_display, width, height));

    // Equal images only prove something if the tick's quad is in them.
    double centroid = 0.0;
    RedCentroidX(with_display, width, height, centroid);
    EXPECT_EQ(with_display, without_display);
}

TEST(MglibSeam, DrawIntoRegisteredTextureSeedsAndResolves) {
    PresentRenderer renderer(640, 480);
    Textures        textures;

    Quads       pixels = Pack(Fill(64 * 64, 0x20, 0x40, 0x80, 0x80));
    mgCTexture *texture = textures.Enter("seam_draw", 64, 64, 32, pixels.data(), nullptr);
    ASSERT_NE(texture, nullptr);

    mgBeginFrame(nullptr);
    mgSetPkFrameBuffer(texture);
    const std::array<gfx::Vertex2D, 4> quad = {
        QuadCorner(0.0f, 0.0f),
        QuadCorner(16.0f, 0.0f),
        QuadCorner(16.0f, 16.0f),
        QuadCorner(0.0f, 16.0f),
    };
    mgPortDraw2D(gfx::Primitive::Quads, quad, gfx::TextureBinding{}, mgPortDrawState());
    mgSetPkFrameBuffer(-1, -1, -1, -1);
    mgEndFrame(nullptr);

    const gfx::TextureHandle target = mgPortFindTexture(texture).texture;
    ASSERT_NE(target, gfx::kNullTexture);
    EXPECT_NE(target, gfx::kMainTarget);
    EXPECT_EQ(mgPortFindTexture(Tex0Bits(texture)).texture, target);

    uint32_t                   width = 0;
    uint32_t                   height = 0;
    const std::vector<uint8_t> rgba = ReadTexture(target, width, height);
    const gfx::LogicalMapping  mapping = gfx::GetLogicalMapping(target);

    const size_t inside = PixelOffset(mapping, width, 8.0f, 8.0f);
    EXPECT_NEAR(rgba[inside + 0], 255, 1);
    EXPECT_NEAR(rgba[inside + 1], 255, 1);
    EXPECT_NEAR(rgba[inside + 2], 255, 1);

    const size_t seeded = PixelOffset(mapping, width, 40.0f, 40.0f);
    EXPECT_NEAR(rgba[seeded + 0], 0x20, 1);
    EXPECT_NEAR(rgba[seeded + 1], 0x40, 1);
    EXPECT_NEAR(rgba[seeded + 2], 0x80, 1);
}

TEST(MglibSeam, ReloadedTextureDropsItsTarget) {
    PresentRenderer renderer(640, 480);
    Textures        textures;

    Quads       pixels = Pack(Fill(64 * 64, 0x20, 0x40, 0x80, 0x80));
    mgCTexture *texture = textures.Enter("seam_reload", 64, 64, 32, pixels.data(), nullptr);
    ASSERT_NE(texture, nullptr);
    const gfx::TextureHandle seeded_image = MgTextureLookup(texture).texture;
    ASSERT_NE(seeded_image, gfx::kNullTexture);

    mgBeginFrame(nullptr);
    mgSetPkFrameBuffer(texture);
    const std::array<gfx::Vertex2D, 4> quad = {
        QuadCorner(0.0f, 0.0f),
        QuadCorner(16.0f, 0.0f),
        QuadCorner(16.0f, 16.0f),
        QuadCorner(0.0f, 16.0f),
    };
    mgPortDraw2D(gfx::Primitive::Quads, quad, gfx::TextureBinding{}, mgPortDrawState());
    mgSetPkFrameBuffer(-1, -1, -1, -1);
    mgEndFrame(nullptr);

    const gfx::TextureHandle old_target = mgPortFindTexture(texture).texture;
    ASSERT_NE(old_target, gfx::kNullTexture);
    ASSERT_NE(old_target, gfx::kMainTarget);

    // Re-entering a live name takes a new slot, so the old texture is deleted first.
    textures.Delete(texture);
    Quads reloaded_pixels = Pack(Fill(64 * 64, 0x90, 0x10, 0x10, 0x80));
    ASSERT_EQ(textures.Enter("seam_reload", 64, 64, 32, reloaded_pixels.data(), nullptr), texture);

    const gfx::TextureHandle reloaded_image = MgTextureLookup(texture).texture;
    ASSERT_NE(reloaded_image, gfx::kNullTexture);
    ASSERT_NE(reloaded_image, seeded_image);

    EXPECT_EQ(mgPortFindTexture(texture).texture, reloaded_image);
    EXPECT_NE(mgPortFindTexture(texture).texture, old_target);
}

TEST(MglibSeam, StretchRectIsExclusive) {
    PresentRenderer renderer(640, 480);
    Textures        textures;

    Quads       source_px = Pack(Fill(64 * 64, 0x20, 0x40, 0x80, 0x80));
    Quads       dest_px = Pack(Fill(64 * 64, 0x10, 0x10, 0x10, 0x80));
    mgCTexture *source = textures.Enter("seam_stretch_src", 64, 64, 32, source_px.data(), nullptr);
    mgCTexture *dest = textures.Enter("seam_stretch_dst", 64, 64, 32, dest_px.data(), nullptr);
    ASSERT_NE(source, nullptr);
    ASSERT_NE(dest, nullptr);

    const mgRect<int> eight_texels(0, 0, 8 * 16, 8 * 16);
    mgSetPkMoveImage(source, eight_texels, dest, eight_texels, nullptr);

    const gfx::TextureHandle image = mgPortFindTexture(dest).texture;
    ASSERT_NE(image, gfx::kNullTexture);
    uint32_t                   width = 0;
    uint32_t                   height = 0;
    const std::vector<uint8_t> rgba = ReadTexture(image, width, height);

    const size_t last_inside = (static_cast<size_t>(7) * width + 7) * 4;
    const size_t first_outside = (static_cast<size_t>(8) * width + 8) * 4;
    EXPECT_NEAR(rgba[last_inside + 0], 0x20, 1);
    EXPECT_NEAR(rgba[last_inside + 2], 0x80, 1);
    EXPECT_NEAR(rgba[first_outside + 0], 0x10, 1);
    EXPECT_NEAR(rgba[first_outside + 2], 0x10, 1);
}

TEST(MglibPresent, MoveImageOfTheFrameUsesAFrameTarget) {
    PresentRenderer renderer(1280, 720);
    Textures        textures;

    Quads       frame_dst_px = Pack(Fill(64 * 64, 0x10, 0x10, 0x10, 0x80));
    Quads       plain_dst_px = Pack(Fill(64 * 64, 0x10, 0x10, 0x10, 0x80));
    Quads       plain_src_px = Pack(Fill(64 * 64, 0x20, 0x40, 0x80, 0x80));
    mgCTexture *frame_dst = textures.Enter("move_frame_dst", 64, 64, 32, frame_dst_px.data(), nullptr);
    mgCTexture *plain_dst = textures.Enter("move_plain_dst", 64, 64, 32, plain_dst_px.data(), nullptr);
    mgCTexture *plain_src = textures.Enter("move_plain_src", 64, 64, 32, plain_src_px.data(), nullptr);
    ASSERT_NE(frame_dst, nullptr);
    ASSERT_NE(plain_dst, nullptr);
    ASSERT_NE(plain_src, nullptr);

    mgSetPkFrameBuffer(-1, -1, -1, -1);
    mgCTexture frame;
    mgGetFrameBuffer(&frame);
    const mgRect<int> whole(0, 0, (mgScreenWidth - 1) * 16, (mgScreenHeight - 1) * 16);

    mgBeginFrame(nullptr);
    mgSetPkMoveImage(&frame, whole, frame_dst, 0, 0, 0);
    mgSetPkMoveImage(plain_src, whole, plain_dst, 0, 0, 0);
    mgEndFrame(nullptr);

    const gfx::TextureHandle target = mgPortFindTexture(frame_dst).texture;
    ASSERT_NE(target, gfx::kNullTexture);
    ASSERT_NE(target, gfx::kMainTarget);
    EXPECT_EQ(mgPortFindTexture(Tex0Bits(frame_dst)).texture, target);

    const std::optional<gfx::TextureInfo> frame_info = gfx::GetTextureInfo(target);
    ASSERT_TRUE(frame_info.has_value());
    EXPECT_TRUE(frame_info->render_target);
    EXPECT_TRUE(frame_info->frame_target);

    const gfx::TextureHandle registered = mgPortRenderTarget(static_cast<uint32_t>(frame_dst->tex0.TBP0), 64, 64,
                                                             static_cast<int>(frame_dst->tex0.PSM), true);
    EXPECT_EQ(registered, target);

    const std::optional<gfx::TextureInfo> plain_info = gfx::GetTextureInfo(mgPortFindTexture(plain_dst).texture);
    ASSERT_TRUE(plain_info.has_value());
    EXPECT_FALSE(plain_info->frame_target);
}

TEST(MglibPresent, BackBufferCapturePreservesWidePixelsAndHoldsUntilRecaptured) {
    PresentRenderer renderer(1920, 1080);
    gfx::SetFrameLayout({gfx::AspectMode::Fill, 1.0f});
    Textures    textures;
    Quads       pixels = Pack(Fill(512 * 480, 0, 0, 0, 0x80));
    mgCTexture *capture = textures.Enter("back_buffer_capture", 512, 480, 32, pixels.data(), nullptr);
    ASSERT_NE(capture, nullptr);
    const mgRect<int> whole(0, 0, (mgScreenWidth - 1) * 16, (mgScreenHeight - 1) * 16);

    // Both copy entry points must treat the displayed buffer as a frame, not an ordinary image.
    for (bool registers : {false, true}) {
        mgSetBackGround(registers ? 20 : 160, registers ? 160 : 40, 80, 128);
        mgBeginFrame(nullptr);
        const auto     mapping = gfx::GetLogicalMapping(gfx::kMainTarget);
        gfx::DrawState state;
        state.depth_test = gfx::DepthTest::Always;
        state.depth_write = false;
        // One-pixel stripes across the wide sides and the centre expose any downsampling or stretch.
        for (int x = 0; x < 1920; x += 2) {
            const float                  left = (x - mapping.offset_x) / mapping.scale_x;
            const float                  right = (x + 1 - mapping.offset_x) / mapping.scale_x;
            std::array<gfx::Vertex2D, 4> quad = {
                QuadCorner(left, 0), QuadCorner(right, 0), QuadCorner(right, 480), QuadCorner(left, 480)};
            mgPortDraw2D(gfx::Primitive::Quads, quad, {}, state);
        }
        mgEndFrame(nullptr);
        std::vector<uint8_t> expected;
        uint32_t             width = 0, height = 0;
        ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, expected, width, height));

        // Begin a different frame: the capture must still read the last completed scene.
        mgSetBackGround(8, 16, 24, 128);
        mgBeginFrame(nullptr);
        mgCTexture back;
        mgGetFrameBackBuffer(&back);
        if (registers) {
            mgSetPkMoveImage(&back.tex0, whole, &capture->tex0, 0, 0, 0);
        } else {
            mgSetPkMoveImage(&back, whole, capture, 0, 0, 0);
        }
        const auto info = gfx::GetTextureInfo(mgPortFindTexture(capture).texture);
        ASSERT_TRUE(info.has_value());
        EXPECT_TRUE(info->frame_target);
        EXPECT_EQ(info->pixel_width, 1920u);
        // Texture storage may pad the logical height; its captured 480 rows must still span 1080 pixels.
        EXPECT_EQ(info->pixel_height, static_cast<uint32_t>(capture->height * 1080 / 480));

        const auto draw_capture = [&] {
            mgCDrawPrim prim;
            prim.Initialize(nullptr, nullptr);
            prim.DepthTestEnable(0);
            prim.ZMask(MG_Z_MASK_MASKED);
            prim.AlphaTestEnable(0);
            prim.AlphaBlendEnable(0);
            prim.TextureMapEnable(1);
            prim.Bilinear(0);
            prim.Begin(MG_PRIM_SPRITE);
            prim.Texture(capture);
            prim.Color(128, 128, 128, 128);
            prim.TextureCrd(0, 0);
            prim.Vertex(0, 0, 0);
            prim.TextureCrd(512, 480);
            prim.Vertex(512, 480, 0);
            prim.End();
        };
        for (int tick = 0; tick < 2; ++tick) {
            if (tick != 0) {
                mgBeginFrame(nullptr);
            }
            draw_capture();
            mgEndFrame(nullptr);
            std::vector<uint8_t> actual;
            ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, actual, width, height));
            EXPECT_TRUE(actual == expected) << "canonical capture changed pixels, registers=" << registers;
            ASSERT_TRUE(PresentScreenshotDisplay(0.5f, actual, width, height));
            EXPECT_TRUE(actual == expected) << "display capture changed pixels, registers=" << registers;
        }
    }
}

TEST(MglibPresent, FrameSamplingPrimitiveUsesOrderedSnapshot) {
    PresentRenderer renderer(1280, 720);
    mgSetBackGround(16.0f, 32.0f, 48.0f, 128.0f);
    for (int tick = 0; tick < 2; ++tick) {
        mgBeginFrame(nullptr);
        const auto source = [&](uint8_t r, uint8_t g, uint8_t b) {
            std::array<gfx::Vertex2D, 4> quad = {
                QuadCorner(0, 324), QuadCorner(512, 324), QuadCorner(512, 384), QuadCorner(0, 384)};
            for (auto &v : quad) {
                v.color[0] = r;
                v.color[1] = g;
                v.color[2] = b;
                v.color[3] = 128;
            }
            gfx::DrawState state;
            state.depth_test = gfx::DepthTest::Always;
            state.depth_write = false;
            mgPortDraw2D(gfx::Primitive::Quads, quad, {}, state);
        };
        source(64, 128, 192);
        mgCTexture frame;
        mgGetFrameBuffer(&frame);
        mgCDrawPrim prim;
        prim.Initialize(nullptr, nullptr);
        prim.DepthTestEnable(0);
        prim.ZMask(MG_Z_MASK_MASKED);
        prim.AlphaTestEnable(0);
        prim.AlphaBlendEnable(1);
        prim.AlphaBlend(MG_ALPHA_BLEND_NORMAL);
        prim.TextureMapEnable(1);
        prim.Bilinear(0);
        prim.Begin(MG_PRIM_SPRITE);
        prim.Texture(&frame);
        prim.Color(128, 128, 128, 64);
        // The logo fade's source and destination bands differ.
        prim.TextureCrd(0, 324);
        prim.Vertex(0, 176, 0);
        prim.TextureCrd(512, 384);
        prim.Vertex(512, 236, 0);
        prim.End();
        source(16, 240, 48);
        mgEndFrame(nullptr);
        std::vector<uint8_t> rgba;
        uint32_t             width = 0, height = 0;
        ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, rgba, width, height));
        const auto   mapping = gfx::GetLogicalMapping(gfx::kMainTarget);
        const size_t x = static_cast<size_t>(256 * mapping.scale_x + mapping.offset_x);
        const size_t y = static_cast<size_t>(200 * mapping.scale_y + mapping.offset_y);
        const size_t p = (y * width + x) * 4;
        EXPECT_NEAR(rgba[p], 40, 1);
        EXPECT_NEAR(rgba[p + 1], 80, 1);
        EXPECT_NEAR(rgba[p + 2], 120, 1);
    }
}

TEST(MglibPresent, CrossFadeRecapturesCompletedSceneAfterUncapturedTicks) {
    PresentRenderer renderer(1280, 720);
    gfx::SetFrameLayout({gfx::AspectMode::Fill, 1.0f});
    Textures    textures;
    Quads       pixels = Pack(Fill(512 * 480, 0, 0, 0, 0x80));
    mgCTexture *texture = textures.Enter("cross_capture", 512, 480, 32, pixels.data(), nullptr);
    ASSERT_NE(texture, nullptr);
    CFadeInOut fade;
    fade.SetCrossTexture(texture, pixels.data());

    const std::array<std::array<uint8_t, 3>, 3> scenes = {
        {{160, 40, 20}, {20, 160, 40}, {40, 20, 160}}
    };
    for (const auto &scene : scenes) {
        // Several unrelated ticks pass without asking the CPU readback cache for a frame.
        for (int tick = 0; tick < 4; ++tick) {
            mgSetBackGround(scene[0], scene[1], scene[2], 128);
            mgBeginFrame(nullptr);
            mgEndFrame(nullptr);
        }
        mgSetBackGround(8, 16, 24, 128);
        mgBeginFrame(nullptr);
        fade.CaptureScreen();
        fade.CrossFade(10, 0.5f);
        fade.Draw();
        mgEndFrame(nullptr);

        const auto check = [&](const std::vector<uint8_t> &rgba, uint32_t width, uint32_t height) {
            // The capture also covers the wide window's sides, outside the logical 4:3 frame.
            for (const uint32_t x : {width / 16, width / 2, width * 15 / 16}) {
                const size_t offset = (static_cast<size_t>(height / 2) * width + x) * 4;
                for (int channel = 0; channel < 3; ++channel) {
                    EXPECT_NEAR(rgba[offset + channel], (scene[channel] + 8 * (channel + 1)) / 2, 1)
                        << "capture channel " << channel << " at x=" << x;
                }
            }
        };
        std::vector<uint8_t> rgba;
        uint32_t             width = 0, height = 0;
        ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, rgba, width, height));
        check(rgba, width, height);
        ASSERT_TRUE(PresentScreenshotDisplay(0.5f, rgba, width, height));
        check(rgba, width, height);

        // A crossfade holds this capture rather than taking a new one on each fade tick.
        mgBeginFrame(nullptr);
        fade.Draw();
        mgEndFrame(nullptr);
        ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, rgba, width, height));
        check(rgba, width, height);
    }
}

TEST(MglibSeam, ReusedTextureKeyDoesNotSampleRetiredRenderTarget) {
    PresentRenderer renderer(1280, 720);
    gfx::SetFrameLayout({gfx::AspectMode::Letterbox, 1.0f});
    Textures    textures;
    Quads       old_pixels = Pack(Fill(64 * 64, 0, 180, 0, 255));
    mgCTexture *old = textures.Enter("effect_work", 64, 64, 32, old_pixels.data(), nullptr);
    ASSERT_NE(old, nullptr);
    const uint32_t key = static_cast<uint32_t>(old->tex0.TBP0);
    mgBeginFrame(nullptr);
    mgSetPkFrameBuffer(old);
    mgSetPkFrameBuffer(-1, -1, -1, -1);
    mgEndFrame(nullptr);
    const gfx::TextureHandle stale = mgPortFindTexture(Tex0Bits(old)).texture;
    ASSERT_TRUE(gfx::GetTextureInfo(stale)->render_target);
    textures.Delete(old);
    Quads       glow_pixels = Pack(Fill(64 * 64, 96, 64, 16, 255));
    mgCTexture *glow = textures.Enter("glow", 64, 64, 32, glow_pixels.data(), nullptr);
    ASSERT_NE(glow, nullptr);
    ASSERT_EQ(static_cast<uint32_t>(glow->tex0.TBP0), key);
    const gfx::TextureHandle native = MgTextureLookup(glow).texture;
    ASSERT_NE(native, gfx::kNullTexture);
    EXPECT_EQ(mgPortFindTexture(Tex0Bits(glow)).texture, native);
    EXPECT_EQ(mgPortFindTexture(glow).texture, native);
    mgSetBackGround(0, 0, 0, 128);
    mgBeginFrame(nullptr);
    mgCDrawPrim prim;
    prim.Initialize(nullptr, nullptr);
    prim.DepthTestEnable(0);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.AlphaTestEnable(0);
    prim.AlphaBlendEnable(1);
    prim.AlphaBlend(MG_ALPHA_BLEND_ADD);
    prim.TextureMapEnable(1);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Texture(glow);
    prim.Color(128, 128, 128, 128);
    prim.TextureCrd(0, 0);
    prim.Vertex(240, 224, 0);
    prim.TextureCrd(64, 64);
    prim.Vertex(272, 256, 0);
    prim.End();
    mgEndFrame(nullptr);
    std::vector<uint8_t> rgba;
    uint32_t             width = 0, height = 0;
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, rgba, width, height));
    const size_t p = (static_cast<size_t>(height / 2) * width + width / 2) * 4;
    EXPECT_NEAR(rgba[p], 96, 1);
    EXPECT_NEAR(rgba[p + 1], 64, 1);
    EXPECT_NEAR(rgba[p + 2], 16, 1);
}

namespace {
struct DamagePrimSink {
    DamagePrimSink() {
        mgPortSetPrimSink([](gfx::Primitive p, std::span<const gfx::Vertex2D>   v,
                             const gfx::TextureBinding &, const gfx::DrawState &s) { mgPortDraw2D(p, v, {}, s); });
    }

    ~DamagePrimSink() { mgPortSetPrimSink({}); }
};

void DamageProjection(float x) {
    auto matrix = Identity();
    matrix[12] = static_cast<float>(mgScreenOffx) + x;
    matrix[13] = static_cast<float>(mgScreenOffy) + 240.0f;
    std::memcpy(mgRenderInfo.world_screen, matrix.data(), sizeof(float) * 16);
    mgRenderInfo.clip_min[2] = 0.0f;
    mgRenderInfo.clip_max[2] = 100.0f;
}

std::vector<gfx::Vertex2D> DamageVertices(const gfx::DisplayList &list) {
    for (const auto &entry : list.entries) {
        if (auto draw = std::get_if<gfx::detail::Draw2DEntry>(&entry)) {
            return draw->vertices;
        }
    }
    return {};
}
} // namespace

namespace {
void CheckDamageBlend(const gfx::DisplayList &list, const std::vector<gfx::Vertex2D> &before,
                      const std::vector<gfx::Vertex2D> &after, const std::vector<uint8_t> &newest) {
    std::vector<uint8_t> actual, expected;
    uint32_t             width = 0, height = 0;
    for (float alpha : {0.0f, 0.25f, 0.5f, 0.75f, 1.0f}) {
        ASSERT_TRUE(PresentScreenshotDisplay(alpha, actual, width, height));
        gfx::BeginRecording();
        for (const auto &entry : list.entries) {
            auto copy = entry;
            if (auto draw = std::get_if<gfx::detail::Draw2DEntry>(&copy)) {
                ASSERT_EQ(draw->vertices.size(), before.size());
                for (size_t i = 0; i < draw->vertices.size(); ++i) {
                    auto &v = draw->vertices[i];
                    v.x = before[i].x + (after[i].x - before[i].x) * alpha;
                    v.y = before[i].y + (after[i].y - before[i].y) * alpha;
                    v.color[3] = static_cast<uint8_t>(std::lround(before[i].color[3] +
                                                                  (float(after[i].color[3]) - before[i].color[3]) * alpha));
                }
            }
            gfx::detail::RecordEntry(std::move(copy));
        }
        auto reference = gfx::EndRecording();
        ASSERT_TRUE(gfx::RenderList(*reference, 1, {}));
        ASSERT_TRUE(gfx::ReadbackFrame(expected, width, height));
        EXPECT_EQ(actual, expected) << alpha;
        if (alpha == 1) {
            EXPECT_EQ(actual, newest);
        }
    }
}

void ExpectNewestAtEveryAlpha() {
    std::vector<uint8_t> canonical, display;
    uint32_t             width = 0, height = 0;
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, canonical, width, height));
    for (float alpha : {0.0f, 0.25f, 0.5f, 0.75f, 1.0f}) {
        ASSERT_TRUE(PresentScreenshotDisplay(alpha, display, width, height));
        EXPECT_EQ(display, canonical) << alpha;
    }
}
} // namespace

TEST(TargetPresentation, WorldLifeGaugeInterpolatesPositionAndHealthAndReuseCuts) {
    PresentRenderer renderer(640, 480);
    PresentSetSettings(PresentSettings{.interpolation = true});
    mgCMemory memory;
    u_long128 backing[512]{};
    memory.stSetBuffer(backing, 512);
    mgSetDataBuffer(&memory, &memory, 0);
    DamagePrimSink sink;
    CEnemyLifeGage gauge;
    gauge.Initialize(0);
    gauge.SetView(1);
    gauge.scale = 1;
    float position[4] = {0, 0, 1, 1};
    auto  record = [&](float x, int hp = 75, int screen = 0) {
        mgBeginFrame(nullptr);
        DamageProjection(x);
        gauge.Set(position, 100, hp, 0, screen);
        gauge.Draw(1);
        mgEndFrame(nullptr);
    };
    record(256);
    auto before = DamageVertices(*mgPortLastList());
    record(264);
    auto after = DamageVertices(*mgPortLastList());
    ASSERT_EQ(before.size(), 12u);
    ASSERT_EQ(after.size(), before.size());
    std::vector<uint8_t> newest;
    uint32_t             width = 0, height = 0;
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, newest, width, height));
    const auto state = gauge;
    CheckDamageBlend(*mgPortLastList(), before, after, newest);
    EXPECT_EQ(std::memcmp(&state, &gauge, sizeof(gauge)), 0);
    EXPECT_EQ(gfx::CurrentInterp2D().key, 0u);
    before = after;
    record(280, 25);
    after = DamageVertices(*mgPortLastList());
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, newest, width, height));
    CheckDamageBlend(*mgPortLastList(), before, after, newest);
    before = after;
    record(400, 25); // A fast continuous camera move still interpolates.
    after = DamageVertices(*mgPortLastList());
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, newest, width, height));
    CheckDamageBlend(*mgPortLastList(), before, after, newest);
    mgPortCutCameraInterpolation();
    record(440, 25); // Explicit same-camera discontinuity.
    ExpectNewestAtEveryAlpha();
    gauge.Initialize(0);
    gauge.SetView(1);
    gauge.scale = 1;
    record(296, 25);
    ExpectNewestAtEveryAlpha(); // A monster slot was reused with identical content.
    record(304, 25, 1);
    for (const auto &entry : mgPortLastList()->entries) {
        if (const auto *draw = std::get_if<gfx::detail::Draw2DEntry>(&entry)) {
            EXPECT_EQ(draw->interpolation.key, 0u);
        }
    }
    ExpectNewestAtEveryAlpha(); // Screen-space boss HUD remains untagged.
}

TEST(TargetPresentation, BracketsInterpolateAndTargetSwitchCuts) {
    PresentRenderer renderer(640, 480);
    PresentSetSettings(PresentSettings{.interpolation = true});
    mgCMemory memory;
    u_long128 backing[512]{};
    memory.stSetBuffer(backing, 512);
    mgSetDataBuffer(&memory, &memory, 0);
    DamagePrimSink sink;
    auto           scene = std::unique_ptr<CScene, decltype(&std::free)>(static_cast<CScene *>(std::calloc(1, sizeof(CScene))), &std::free);
    auto           user = std::unique_ptr<CUserDataManager, decltype(&std::free)>(static_cast<CUserDataManager *>(std::calloc(1, sizeof(CUserDataManager))), &std::free);
    auto          *saved_user = DngUserData;
    DngUserData = user.get();
    user->active_chr_no = USER_CHARA_MAX;
    CActionChara   player;
    CActiveMonster target;
    mgCFrame       frame;
    frame.SetPosition(0, 0, 1);
    target.CObjectFrame::frame = &frame;
    target.entry_object[0].frame = &frame;
    target.entry_object[0].group = CHARA_ENTRY_GROUP_TARGET;
    target.entry_object[0].size = 1;
    target.tbl = &target.param;
    std::strcpy(target.param.name, "Clown");
    target.target_dist = 1;
    target.clip_dist = 100;
    target.alpha = 1;
    target.body_height = 0;
    target.life_gage.Initialize(0);
    scene->chara_num = 3;
    for (int i = 0; i < 3; ++i) {
        scene->chara[i].status = 1;
    }
    scene->chara[0].chara = &player;
    scene->chara[1].chara = scene->chara[2].chara = &target;
    player.target_no = 1;
    player.lock_on = 1;
    CLockOnModel lock;
    lock.Initialize(scene.get());
    auto record = [&](float x) {
        mgBeginFrame(nullptr);
        DamageProjection(x);
        auto view_screen = Identity();
        std::memcpy(mgRenderInfo.view_screen, view_screen.data(), sizeof(float) * 16);
        lock.Draw();
        mgEndFrame(nullptr);
    };
    record(256);
    auto before = DamageVertices(*mgPortLastList());
    record(264);
    auto after = DamageVertices(*mgPortLastList());
    ASSERT_EQ(before.size(), 16u);
    ASSERT_EQ(after.size(), before.size());
    std::vector<uint8_t> newest;
    uint32_t             width = 0, height = 0;
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, newest, width, height));
    CheckDamageBlend(*mgPortLastList(), before, after, newest);
    mgPortCutCameraInterpolation();
    record(440); // Explicit same-camera discontinuity.
    ExpectNewestAtEveryAlpha();
    player.target_no = 2; // A different scene identity, even if storage is reused.
    record(280);
    ExpectNewestAtEveryAlpha();
    target.life_gage.Initialize(0);
    record(296);
    ExpectNewestAtEveryAlpha();
    player.target_no = -1;
    record(296);
    EXPECT_TRUE(DamageVertices(*mgPortLastList()).empty());
    player.target_no = 2;
    record(304);
    ExpectNewestAtEveryAlpha(); // A new lock emission after hiding.
    EXPECT_EQ(gfx::CurrentInterp2D().key, 0u);
    record(304); // Pause, with no game step.
    ExpectNewestAtEveryAlpha();
    mgBeginFrame(nullptr);
    DamageProjection(304);
    lock.Draw();
    gfx::CutCameraInterpolation();
    mgEndFrame(nullptr);
    ExpectNewestAtEveryAlpha();
    target.CObjectFrame::frame = nullptr;
    target.entry_object[0].frame = nullptr;
    DngUserData = saved_user;
}

namespace {
void CheckOverlayBlend(const std::vector<gfx::detail::Entry> &before, const std::vector<gfx::detail::Entry> &after,
                       const std::vector<uint8_t> &newest) {
    std::vector<const gfx::detail::Draw2DEntry *> previous;
    for (const auto &entry : before) {
        if (const auto *draw = std::get_if<gfx::detail::Draw2DEntry>(&entry)) {
            previous.push_back(draw);
        }
    }
    std::vector<uint8_t> actual, expected;
    uint32_t             width = 0, height = 0;
    for (float alpha : {0.0f, 0.25f, 0.5f, 0.75f, 1.0f}) {
        ASSERT_TRUE(PresentScreenshotDisplay(alpha, actual, width, height));
        gfx::BeginRecording();
        size_t draw_index = 0;
        for (size_t j = 0; j < after.size(); ++j) {
            auto copy = after[j];
            if (auto *draw = std::get_if<gfx::detail::Draw2DEntry>(&copy)) {
                ASSERT_LT(draw_index, previous.size());
                const auto *old = previous[draw_index++];
                ASSERT_EQ(old->vertices.size(), draw->vertices.size());
                for (size_t i = 0; i < draw->vertices.size(); ++i) {
                    auto &v = draw->vertices[i];
                    v.x = old->vertices[i].x + (v.x - old->vertices[i].x) * alpha;
                    v.y = old->vertices[i].y + (v.y - old->vertices[i].y) * alpha;
                    v.color[3] = static_cast<uint8_t>(std::lround(old->vertices[i].color[3] +
                                                                  (float(v.color[3]) - old->vertices[i].color[3]) * alpha));
                }
            }
            gfx::detail::RecordEntry(std::move(copy));
        }
        auto reference = gfx::EndRecording();
        ASSERT_TRUE(gfx::RenderList(*reference, 1, {}));
        ASSERT_TRUE(gfx::ReadbackFrame(expected, width, height));
        EXPECT_EQ(actual, expected) << alpha;
        if (alpha == 1) {
            EXPECT_EQ(actual, newest);
        }
    }
}
} // namespace

TEST(TargetPresentation, RageMarksInterpolateMotionAndBreakAway) {
    PresentRenderer renderer(640, 480);
    PresentSetSettings(PresentSettings{.interpolation = true});
    mgCMemory memory;
    u_long128 backing[512]{};
    memory.stSetBuffer(backing, 512);
    mgSetDataBuffer(&memory, &memory, 0);
    // Isolate the actual retail marks from the independently keyed HP triangles.
    mgPortSetPrimSink([](gfx::Primitive p, std::span<const gfx::Vertex2D>   v,
                         const gfx::TextureBinding &, const gfx::DrawState &s) {
        if (p == gfx::Primitive::Quads) {
            mgPortDraw2D(p, v, {}, s);
        }
    });
    CEnemyLifeGage gauge;
    gauge.Initialize(3);
    gauge.SetView(1);
    gauge.scale = 1;
    float position[4] = {0, 0, 1, 1};
    auto  record = [&](float x, int hp, int count) {
        mgBeginFrame(nullptr);
        DamageProjection(x);
        gauge.Set(position, 100, hp, count, 0);
        gauge.Step();
        gauge.Draw(0);
        mgEndFrame(nullptr);
    };
    auto check_pair = [&](float x, int hp, int count) {
        auto before = mgPortLastList()->entries;
        record(x, hp, count);
        auto                 after = mgPortLastList()->entries;
        std::vector<uint8_t> newest;
        uint32_t             width = 0, height = 0;
        ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, newest, width, height));
        const auto state = gauge;
        CheckOverlayBlend(before, after, newest);
        EXPECT_EQ(std::memcmp(&state, &gauge, sizeof(gauge)), 0);
        EXPECT_EQ(gfx::CurrentInterp2D().key, 0u);
    };
    record(256, 100, 3);
    check_pair(264, 80, 3); // Damage changes the HP generation, not surviving marks.
    record(272, 60, 2);     // A mark begins breaking, with a new additive halo.
    check_pair(280, 60, 2); // Both the mark and its halo rise between game ticks.
    gauge.ResetGekirin(3);
    record(300, 60, 3);
    ExpectNewestAtEveryAlpha(); // Refilled marks must not inherit the old break trajectory.
    gauge.Initialize(3);
    gauge.SetView(1);
    gauge.scale = 1;
    record(316, 60, 3);
    ExpectNewestAtEveryAlpha(); // Same storage, new monster.
    mgPortSetPrimSink({});
}

TEST(TargetPresentation, RageMarkIdentitySurvivesMissingNeighbours) {
    PresentRenderer renderer(640, 480);
    PresentSetSettings(PresentSettings{.interpolation = true});
    mgCMemory memory;
    u_long128 backing[512]{};
    memory.stSetBuffer(backing, 512);
    mgSetDataBuffer(&memory, &memory, 0);
    DamagePrimSink sink;
    CEnemyLifeGage gauge;
    gauge.Initialize(3);
    gauge.SetView(1);
    gauge.scale = 1;
    float position[4] = {0, 0, 1, 1};
    auto  record = [&](float x, bool hidden = false) {
        mgBeginFrame(nullptr);
        DamageProjection(x);
        gauge.Set(position, 100, 100, 3, 0);
        const gfx::Interp2D outer{987, 654};
        gfx::SetInterp2D(outer);
        gauge.Draw(hidden);
        EXPECT_EQ(gfx::CurrentInterp2D().key, outer.key);
        EXPECT_EQ(gfx::CurrentInterp2D().generation, outer.generation);
        gfx::SetInterp2D({});
        mgEndFrame(nullptr);
        std::vector<gfx::detail::Draw2DEntry> marks;
        for (const auto &entry : mgPortLastList()->entries) {
            if (auto draw = std::get_if<gfx::detail::Draw2DEntry>(&entry);
                draw && draw->primitive == gfx::Primitive::Quads) {
                marks.push_back(*draw);
            }
        }
        return marks;
    };
    auto before = record(256);
    ASSERT_EQ(before.size(), 3u);
    for (size_t i = 0; i < before.size(); ++i) {
        EXPECT_NE(before[i].interpolation.key, 0u);
        EXPECT_EQ(before[i].occurrence, 0u);
        for (size_t j = 0; j < i; ++j) {
            EXPECT_NE(before[i].interpolation.key, before[j].interpolation.key);
        }
    }
    // Finish one mark's real break animation, leaving its neighbours alive.
    gauge.gekirin[0].state = GEKIRIN_STATE_BREAK;
    gauge.gekirin[0].frame = 14;
    gauge.gekirin[0].Step();
    ASSERT_EQ(gauge.gekirin[0].state, GEKIRIN_STATE_NONE);
    auto after = record(272);
    ASSERT_EQ(after.size(), 2u);
    std::vector<gfx::Vertex2D> middle;
    for (size_t i = 0; i < after.size(); ++i) {
        EXPECT_EQ(after[i].interpolation.key, before[i + 1].interpolation.key);
        ASSERT_TRUE(gfx::detail::Interpolate2D(before[i + 1], after[i], 0.5f, middle));
        EXPECT_FLOAT_EQ(middle[0].x, (before[i + 1].vertices[0].x + after[i].vertices[0].x) / 2);
        EXPECT_FALSE(gfx::detail::Interpolate2D(before[0], after[i], 0.5f, middle));
    }
    EXPECT_TRUE(record(280, true).empty());
    after = record(280);
    ExpectNewestAtEveryAlpha(); // No marks existed in the preceding list.
}

TEST(TargetPresentation, NameInterpolatesAndTargetSwitchCuts) {
    const char *data = std::getenv("DC2_DATA");
    if (!data) {
        GTEST_SKIP() << "DC2_DATA supplies the retail font table";
    }

    struct RestoreFontData {
        std::filesystem::path root = PathsDataRoot();
        int                   language = LanguageCode;

        ~RestoreFontData() {
            PathsSetDataRoot(root);
            LanguageCode = language;
        }
    } restore;

    PathsSetDataRoot(data);
    LanguageCode = LANG_ENGLISH;
    LoadFontTblBin();
    PresentRenderer renderer(640, 480);
    PresentSetSettings(PresentSettings{.interpolation = true});
    mgCMemory memory;
    u_long128 backing[512]{};
    memory.stSetBuffer(backing, 512);
    mgSetDataBuffer(&memory, &memory, 0);
    bool emit = false;
    mgPortSetPrimSink([&](gfx::Primitive p, std::span<const gfx::Vertex2D>   v,
                          const gfx::TextureBinding &, const gfx::DrawState &state) {
        if (emit) {
            mgPortDraw2D(p, v, {}, state);
        }
    });
    auto  scene = std::unique_ptr<CScene, decltype(&std::free)>(static_cast<CScene *>(std::calloc(1, sizeof(CScene))), &std::free);
    auto  user = std::unique_ptr<CUserDataManager, decltype(&std::free)>(static_cast<CUserDataManager *>(std::calloc(1, sizeof(CUserDataManager))), &std::free);
    auto *saved_user = DngUserData;
    DngUserData = user.get();
    user->active_chr_no = USER_CHARA_MAX;
    CActionChara   player;
    CActiveMonster target;
    mgCFrame       frame;
    frame.SetPosition(0, 0, 1);
    target.CObjectFrame::frame = &frame;
    target.entry_object[0].frame = &frame;
    target.entry_object[0].group = CHARA_ENTRY_GROUP_TARGET;
    target.entry_object[0].size = 1;
    target.tbl = &target.param;
    std::strcpy(target.param.name, "Clown");
    target.target_dist = 1;
    target.clip_dist = 100;
    target.alpha = 1;
    target.body_height = 0;
    target.life_gage.Initialize(0);
    scene->chara_num = 3;
    for (int i = 0; i < 3; ++i) {
        scene->chara[i].status = 1;
    }
    scene->chara[0].chara = &player;
    scene->chara[1].chara = scene->chara[2].chara = &target;
    player.target_no = 1;
    player.lock_on = 1;
    CLockOnModel lock;
    lock.Initialize(scene.get());
    ClsMes message;
    message.Preset(2);
    message.fade = 1;
    lock.mes = &message;
    auto record = [&](float x) {
        mgBeginFrame(nullptr);
        DamageProjection(x);
        auto view_screen = Identity();
        std::memcpy(mgRenderInfo.view_screen, view_screen.data(), sizeof(float) * 16);
        emit = false;
        lock.Draw();
        emit = true;
        lock.DrawMess(88);
        mgEndFrame(nullptr);
    };
    record(256);
    auto before = mgPortLastList()->entries;
    record(264);
    auto after = mgPortLastList()->entries;
    ASSERT_GT(message.tbl_num, 1);
    ASSERT_GT(message.reveal_num, 0);
    ASSERT_NE(message.mes_no, -1);
    ASSERT_FALSE(DamageVertices(*mgPortLastList()).empty());
    std::vector<uint8_t> newest;
    uint32_t             width = 0, height = 0;
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, newest, width, height));
    const auto message_state = message;
    CheckOverlayBlend(before, after, newest);
    EXPECT_EQ(std::memcmp(&message_state, &message, sizeof(message)), 0);
    EXPECT_EQ(gfx::CurrentInterp2D().key, 0u);
    mgPortCutCameraInterpolation();
    record(440); // Explicit same-camera discontinuity.
    ExpectNewestAtEveryAlpha();
    player.target_no = 2; // A different scene identity, even if storage is reused.
    record(280);
    ExpectNewestAtEveryAlpha();
    target.life_gage.Initialize(0);
    record(296);
    ExpectNewestAtEveryAlpha();
    record(296); // Pause, with no game step.
    ExpectNewestAtEveryAlpha();
    mgBeginFrame(nullptr);
    DamageProjection(304);
    emit = false;
    lock.Draw();
    emit = true;
    lock.DrawMess(88);
    gfx::CutCameraInterpolation();
    mgEndFrame(nullptr);
    ExpectNewestAtEveryAlpha();
    target.CObjectFrame::frame = nullptr;
    target.entry_object[0].frame = nullptr;
    DngUserData = saved_user;
    mgPortSetPrimSink({});
}

TEST(DamagePresentation, RetailDamageInterpolatesProjectedBounceAndOpacity) {
    PresentRenderer renderer(640, 480);
    PresentSetSettings(PresentSettings{.interpolation = true});
    mgCMemory memory;
    u_long128 backing[512]{};
    memory.stSetBuffer(backing, 512);
    mgSetDataBuffer(&memory, &memory, 0);
    DamagePrimSink sink;
    CDamageScore   damage;
    float          position[4] = {0, 0, 1, 1};
    damage.SetValue(position, 123);
    damage.SetColor(128, 0, 0);
    damage.digit_w = 12;
    damage.digit_h = 18;
    damage.digit_u = 0;
    damage.digit_v = 0;
    for (int i = 0; i < 4; i++) {
        damage.Step();
    }
    std::vector<gfx::Vertex2D> before, after;
    std::vector<uint8_t>       earlier, newest;
    uint32_t                   width = 0, height = 0;
    for (int k = 0; k < 2; k++) {
        mgBeginFrame(nullptr);
        DamageProjection(256.0f + 8.0f * k);
        damage.Step();
        damage.Draw();
        mgEndFrame(nullptr);
        (k == 0 ? before : after) = DamageVertices(*mgPortLastList());
        ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, k == 0 ? earlier : newest, width, height));
    }
    ASSERT_EQ(before.size(), 12u);
    ASSERT_EQ(after.size(), before.size());
    ASSERT_NE(earlier, newest);
    const auto *list = mgPortLastList();
    const auto  state_before = damage;
    CheckDamageBlend(*list, before, after, newest);
    EXPECT_EQ(std::memcmp(&damage, &state_before, sizeof(damage)), 0);
    mgBeginFrame(nullptr);
    mgPortCutCameraInterpolation();
    DamageProjection(440); // Explicit cut with unchanged world position and emission.
    damage.Draw();
    mgEndFrame(nullptr);
    ExpectNewestAtEveryAlpha();
}

TEST(DamagePresentation, RetailLifetimesRemainInGameSteps) {
    float        position[4] = {0, 0, 1, 1};
    CDamageScore damage;
    damage.SetValue(position, 123);
    int steps = 0;
    while (damage.active && steps < 500) {
        damage.Step();
        ++steps;
    }
    EXPECT_EQ(steps, 50);
    CDamageScore2 other;
    other.SetValue(0, 123, 20);
    steps = 0;
    while (other.phase != DAMAGE_SCORE2_PHASE_NONE && steps < 500) {
        other.Step();
        ++steps;
    }
    EXPECT_EQ(steps, 37);
}

TEST(PickupPresentation, EmissionPreservesRetailReuseAndTrailAllocation) {
    CPullItem pickup{};
    float     position[4] = {4, 5, 6, 1};
    float     velocity[4] = {1, 2, 3, 0};
    pickup.anim_frame = 13;
    pickup.wait_time = 77;
    pickup.exp = 9.0f;
    pickup.num = 3;
    for (auto &wire : afterWire) {
        wire.SetMode(true);
    }
    afterWire[3].SetMode(false);
    afterWire[7].SetMode(false);
    pickup.SetItem(position, velocity, PULL_ITEM_WEAPON_EXP);
    EXPECT_EQ(pickup.wire_index, 3);
    EXPECT_TRUE(afterWire[3].mode);
    EXPECT_FALSE(afterWire[7].mode);
    EXPECT_EQ(pickup.anim_frame, 13); // ABS retains the reused slot's animation frame.
    EXPECT_EQ(pickup.wait_time, 180);
    EXPECT_EQ(pickup.exp, 9.0f);
    EXPECT_EQ(pickup.num, 3);
    EXPECT_EQ(std::memcmp(pickup.pos, position, sizeof position), 0);
    EXPECT_EQ(std::memcmp(pickup.velocity, velocity, sizeof velocity), 0);
    afterWire[7].SetMode(true);
    pickup.SetItem(position, velocity, PULL_ITEM_WEAPON_EXP);
    EXPECT_EQ(pickup.wire_index, -1); // Exhaustion does not steal another pickup's trail.
    pickup.wait_time = 77;
    pickup.SetItem(position, velocity, PULL_ITEM_GATE_KEY);
    EXPECT_EQ(pickup.wait_time, 77);
    EXPECT_EQ(pickup.state, PULL_ITEM_STATE_FLOAT);
    EXPECT_EQ(pickup.anim_frame, 0);
    pickup.SetItem(position, velocity, PULL_ITEM_STOLEN);
    EXPECT_EQ(pickup.wait_time, 77);
    EXPECT_EQ(pickup.tex_u, 0x61);
    EXPECT_EQ(pickup.tex_v, 0x21);
    EXPECT_EQ(pickup.tex_w, 30);
    EXPECT_EQ(pickup.tex_h, 30);
    for (auto &wire : afterWire) {
        wire.SetMode(false);
    }
}

TEST(PickupPresentation, RetailEmissionsTagCoinsAbsAndFloatingItems) {
    PresentRenderer renderer(640, 480);
    mgCMemory       memory;
    u_long128       backing[512]{};
    memory.stSetBuffer(backing, 512);
    mgSetDataBuffer(&memory, &memory, 0);
    CPullItem                  pickup{};
    float                      position[4] = {0, 0, 1, 1};
    float                      velocity[4] = {1, 2, 3, 0};
    uint64_t                   previous_generation = 0;
    std::vector<gfx::Interp2D> tags;
    DamagePrimSink             sink_reset;
    mgPortSetPrimSink([&](gfx::Primitive, std::span<const gfx::Vertex2D>     vertices,
                          const gfx::TextureBinding &, const gfx::DrawState &state) {
        EXPECT_FALSE(vertices.empty());
        EXPECT_NE(state.depth_test, gfx::DepthTest::Always);
        EXPECT_FALSE(state.depth_write);
        tags.push_back(gfx::CurrentInterp2D());
    });
    for (int kind : {PULL_ITEM_MONEY, PULL_ITEM_WEAPON_EXP, PULL_ITEM_GATE_KEY,
                     PULL_ITEM_MONEY_LARGE, PULL_ITEM_ITEM, PULL_ITEM_ITEM2, PULL_ITEM_BADGE, PULL_ITEM_STOLEN}) {
        pickup.SetItem(position, velocity, kind);
        const auto    retail_state = pickup;
        gfx::Interp2D tag;
        {
            mgPortPickupScope scope(&pickup);
            tag = gfx::CurrentInterp2D();
        }
        EXPECT_EQ(std::memcmp(&pickup, &retail_state, sizeof pickup), 0);
        EXPECT_EQ(tag.key, reinterpret_cast<uintptr_t>(&pickup));
        EXPECT_GT(tag.generation, previous_generation);
        EXPECT_TRUE(tag.world_corners);
        previous_generation = tag.generation;
        tags.clear();
        mgBeginFrame(nullptr);
        DamageProjection(256);
        mgRenderInfo.view_screen[0][0] = 16;
        mgRenderInfo.view_screen[1][1] = 16;
        pickup.Draw(nullptr);
        mgEndFrame(nullptr);
        ASSERT_FALSE(tags.empty()) << kind;
        for (const auto &draw_tag : tags) {
            EXPECT_EQ(draw_tag.key, tag.key);
            EXPECT_EQ(draw_tag.generation, tag.generation);
            EXPECT_TRUE(draw_tag.world_corners);
        }
        EXPECT_EQ(gfx::CurrentInterp2D().key, 0u);
        pickup.Clear();
    }
    mgPortSetPrimSink({});
}

TEST(DamagePresentation, Score2InterpolatesAndReusedSlotsStayNewest) {
    PresentRenderer renderer(640, 480);
    PresentSetSettings(PresentSettings{.interpolation = true});
    mgCMemory memory;
    u_long128 backing[512]{};
    memory.stSetBuffer(backing, 512);
    mgSetDataBuffer(&memory, &memory, 0);
    DamagePrimSink sink;
    auto           scene = std::unique_ptr<CScene, decltype(&std::free)>(static_cast<CScene *>(std::calloc(1, sizeof(CScene))), &std::free);
    CCharacter2    character;
    mgCFrame       frame;
    frame.SetPosition(0, 0, 1);
    character.CObjectFrame::frame = &frame;
    scene->chara_num = 1;
    scene->chara[0].status = 1;
    scene->chara[0].chara = &character;
    CDamageScore2 damage;
    damage.SetValue(0, 123, 0);
    std::vector<gfx::Vertex2D> before, after;
    std::vector<uint8_t>       newest;
    uint32_t                   width = 0, height = 0;
    auto                       record = [&](float x) {
        mgBeginFrame(nullptr);
        DamageProjection(x);
        damage.Draw(scene.get());
        mgEndFrame(nullptr);
    };
    mgBeginFrame(nullptr);
    mgEndFrame(nullptr); // spawn has a predecessor list, but no predecessor draw
    damage.Step();
    record(256);
    ExpectNewestAtEveryAlpha(); // spawn
    before = DamageVertices(*mgPortLastList());
    damage.Step();
    record(264);
    after = DamageVertices(*mgPortLastList());
    ASSERT_EQ(after.size(), 12u);
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, newest, width, height));
    auto state = damage;
    CheckDamageBlend(*mgPortLastList(), before, after, newest);
    EXPECT_EQ(std::memcmp(&state, &damage, sizeof(damage)), 0);
    before = after;
    record(400); // Fast continuous motion keeps the damage generation.
    after = DamageVertices(*mgPortLastList());
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, newest, width, height));
    CheckDamageBlend(*mgPortLastList(), before, after, newest);
    mgPortCutCameraInterpolation();
    record(440); // Explicit same-camera discontinuity.
    ExpectNewestAtEveryAlpha();
    auto previous_generation = std::get<gfx::detail::Draw2DEntry>(mgPortLastList()->entries.back()).interpolation.generation;
    damage.SetValue(0, 123, 0); // same glyphs and object, distinct emission
    damage.Step();
    record(280);
    EXPECT_NE(std::get<gfx::detail::Draw2DEntry>(mgPortLastList()->entries.back()).interpolation.generation, previous_generation);
    ExpectNewestAtEveryAlpha();
    damage.phase = DAMAGE_SCORE2_PHASE_NONE;
    record(280);
    EXPECT_TRUE(DamageVertices(*mgPortLastList()).empty());
    ExpectNewestAtEveryAlpha(); // despawn
    character.CObjectFrame::frame = nullptr;
}

TEST(DamagePresentation, SpriteHealClippingAndPause) {
    PresentRenderer renderer(854, 480);
    PresentSetSettings(PresentSettings{.interpolation = true});
    mgCMemory memory;
    u_long128 backing[512]{};
    memory.stSetBuffer(backing, 512);
    mgSetDataBuffer(&memory, &memory, 0);
    DamagePrimSink sink;
    CDamageScore   damage;
    float          position[4] = {0, 0, 1, 1};
    damage.SetValue(position, 123);
    damage.SetColor(64, 128, 64); // healing uses the same glyph path
    damage.digit_w = 12;
    damage.digit_h = 17;
    damage.digit_u = 0;
    damage.digit_v = 202;
    auto record = [&](float x, bool clipped = false) {
        mgBeginFrame(nullptr);
        DamageProjection(x);
        if (clipped) {
            mgRenderInfo.clip_max[2] = 0;
        }
        damage.Draw();
        mgEndFrame(nullptr);
    };
    damage.Step();
    record(256);
    auto before = DamageVertices(*mgPortLastList());
    damage.Step();
    record(264);
    auto                 after = DamageVertices(*mgPortLastList());
    std::vector<uint8_t> newest;
    uint32_t             width = 0, height = 0;
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, newest, width, height));
    CheckDamageBlend(*mgPortLastList(), before, after, newest);
    damage.SetSprite(position, 192, 22, 18, 18);
    damage.Step();
    record(280);
    ASSERT_EQ(DamageVertices(*mgPortLastList()).size(), 4u);
    ExpectNewestAtEveryAlpha(); // sprite mode/emission changed
    before = DamageVertices(*mgPortLastList());
    damage.Step();
    record(288);
    after = DamageVertices(*mgPortLastList());
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, newest, width, height));
    CheckDamageBlend(*mgPortLastList(), before, after, newest);
    record(288); // paused: no Step or anchor change
    ExpectNewestAtEveryAlpha();
    record(288, true);
    EXPECT_TRUE(DamageVertices(*mgPortLastList()).empty());
    ExpectNewestAtEveryAlpha();
    record(288); // newly visible after clipping
    ExpectNewestAtEveryAlpha();
    damage.SetValue(position, 1);
    damage.Step();
    record(296);
    ExpectNewestAtEveryAlpha(); // glyph-count change
    mgBeginFrame(nullptr);
    DamageProjection(304);
    damage.Step();
    damage.Draw();
    gfx::CutCameraInterpolation();
    mgEndFrame(nullptr);
    ExpectNewestAtEveryAlpha();
}

TEST(DamagePresentation, RealAtlasProjectedEndpoints) {
    const char *data = std::getenv("DC2_DATA");
    if (!data) {
        GTEST_SKIP() << "DC2_DATA supplies the extracted glyph atlas";
    }
    if (FirstRunDataMissing(data)) {
        GTEST_SKIP() << "DC2_DATA needs the current published PNG extraction";
    }
    DataReadIndex(data);
    const auto    path = std::filesystem::path(data) / "dungeon/articles/tex01_1.chr";
    std::ifstream file(path, std::ios::binary | std::ios::ate);
    if (!file) {
        GTEST_SKIP() << "Extracted system texture archive unavailable";
    }
    const size_t           bytes = static_cast<size_t>(file.tellg());
    std::vector<u_long128> archive((bytes + 15) / 16);
    file.seekg(0);
    ASSERT_TRUE(file.read(reinterpret_cast<char *>(archive.data()), bytes));
    TextureSourceRegister(archive.data(), "dungeon/articles/tex01_1.chr", bytes);
    const TextureSourceScope archive_source{archive.data()};
    int   member_size = 0;
    char  member_name[] = "frame_basic.img";
    auto *image = GetPackFile(reinterpret_cast<u_int *>(archive.data()), member_name, &member_size);
    const TextureSourceScope image_source{image};
    ASSERT_NE(image, nullptr);
    PresentRenderer renderer(640, 480);
    PresentSetSettings(PresentSettings{.interpolation = true});
    std::vector<u_long128> backing(131072);
    mgCMemory              memory;
    memory.stSetBuffer(backing.data(), static_cast<int>(backing.size()));
    mgCTextureManager manager;
    manager.SetTableBuffer(64, 8, &memory);
    manager.Initialize(0x1000, -1);
    manager.EnterIMGFile(reinterpret_cast<u_char *>(image), 0, &memory, nullptr);
    auto *saved = TEX_SystenFrame;
    char  texture_name[] = "frame";
    TEX_SystenFrame = manager.GetTexture(texture_name, -1);
    ASSERT_NE(TEX_SystenFrame, nullptr);
    mgSetDataBuffer(&memory, &memory, 0);
    CDamageScore damage;
    float        position[4] = {0, 0, 1, 1};
    damage.SetValue(position, 123);
    damage.SetColor(128, 0, 0);
    damage.digit_w = 12;
    damage.digit_h = 17;
    damage.digit_u = 0;
    damage.digit_v = 202;
    for (int i = 0; i < 14; ++i) {
        damage.Step();
    }
    std::vector<gfx::Vertex2D> before, after;
    std::vector<uint8_t>       newest, earlier;
    uint32_t                   width = 0, height = 0;
    for (int k = 0; k < 2; ++k) {
        mgBeginFrame(nullptr);
        DamageProjection(256 + 8 * k);
        damage.Step();
        damage.Draw();
        mgEndFrame(nullptr);
        (k == 0 ? before : after) = DamageVertices(*mgPortLastList());
        ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, k == 0 ? earlier : newest, width, height));
    }
    ASSERT_EQ(after.size(), 12u);
    EXPECT_NE(earlier, newest);
    CheckDamageBlend(*mgPortLastList(), before, after, newest);
    TEX_SystenFrame = saved;
    manager.Initialize(0x1000, -1);
}

TEST(MglibPresent, MenuPointerOverlayNeverChangesCanonicalOrScreenshotCapture) {
    PresentRenderer renderer(640, 480);
    PresentSetSettings(PresentSettings{.interpolation = false});
    InputResetBindings();
    InputSetScriptedDevices({});
    MenuMouseEnable(true);
    EXPECT_FALSE(PresentMouseActive());
    EXPECT_FALSE(MouseInputLive()); // Headless scripted pointer needs no native capture.
    const auto    texture = gfx::CreateTexture({1, 1});
    const uint8_t white[] = {255, 255, 255, 128};
    ASSERT_TRUE(gfx::UpdateTexture(texture, 0, 0, 0, 1, 1, white));
    mgSetBackGround(8, 16, 24, 128);
    mgBeginFrame(nullptr);
    mgEndFrame(nullptr);
    std::vector<uint8_t> expected, canonical, displayed;
    uint32_t             width = 0, height = 0;
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, expected, width, height));
    InputSetScriptedDevices({.mouse_dx = 30});
    mgBeginFrame(nullptr);
    MenuMouseTake();
    MenuMouseNoteHand({.texture = texture}, {0, 0, 40, 24});
    mgEndFrame(nullptr);
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, canonical, width, height));
    EXPECT_EQ(canonical, expected);
    gfx::BeginRecording();
    MenuMouseDraw();
    const auto pointer = gfx::EndRecording();
    ASSERT_GT(gfx::ListStats(*pointer).draws_2d, 0u);
    gfx::RenderOptions options;
    options.overlay = pointer.get();
    options.present = true;
    ASSERT_TRUE(gfx::RenderList(*mgPortLastList(), 1, options));
    ASSERT_TRUE(gfx::ReadbackFrame(displayed, width, height));
    EXPECT_NE(displayed, canonical);
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, displayed, width, height));
    EXPECT_EQ(displayed, canonical); // --screenshot and pause/crossfade grabs use this image.
    const auto grab = gfx::CreateTexture({width, height});
    ASSERT_TRUE(gfx::SnapshotFrame(grab));
    ASSERT_TRUE(gfx::ReadbackTexture(grab, displayed, width, height));
    EXPECT_EQ(displayed, canonical);
    gfx::DestroyTexture(grab);
    ASSERT_TRUE(PresentScreenshotDisplay(1, displayed, width, height));
    EXPECT_EQ(displayed, canonical); // Display captures also omit host pointers.
    MenuMouseEnable(false);
    InputSetScriptedDevices({});
    InputSetMenuMouse(false);
    gfx::DestroyTexture(texture);
}

TEST(MglibPresent, HandTipUsesTheHoverMappingAtFourThreeAndWidescreenFill) {
    const auto settings = InputGetMouseSettings();
    for (const auto &size : {
             std::pair{1280, 960 },
             std::pair{1920, 1080}
    }) {
        PresentRenderer renderer(size.first, size.second);
        gfx::SetFrameLayout({.aspect = gfx::AspectMode::Fill});
        InputResetBindings();
        InputSetMouseSettings({.capture = false});
        InputSetScriptedDevices({});
        MenuMouseEnable(true);
        MenuMouseTake();
        const auto before = MenuMouseTake();
        SDL_Event  event{};
        event.type = SDL_EVENT_MOUSE_MOTION;
        event.motion.xrel = 64;
        event.motion.yrel = -32;
        InputHandleEvent(event);
        const auto point = MenuMouseDisplaySample();
        const auto mapping = gfx::GetUiMapping(gfx::kMainTarget);
        int        w = size.first, h = size.second;
        WindowSize(w, h);
        EXPECT_FLOAT_EQ(point.x, before.x + 64 * MenuMouseUnits(mapping.scale_x, mapping.pixel_width, w));
        EXPECT_FLOAT_EQ(point.y, before.y - 32 * MenuMouseUnits(mapping.scale_y, mapping.pixel_height, h));
        const auto    texture = gfx::CreateTexture({1, 1});
        const uint8_t white[] = {255, 255, 255, 255};
        ASSERT_TRUE(gfx::UpdateTexture(texture, 0, 0, 0, 1, 1, white));
        MenuMouseNoteHand({.texture = texture}, {0, 0, 40, 24}, 0.2f, 0, 128);
        gfx::BeginRecording();
        MenuMouseDraw();
        const auto list = gfx::EndRecording();
        ASSERT_EQ(gfx::ListStats(*list).draws_2d, 1u);
        const auto *draw = std::get_if<gfx::detail::Draw2DEntry>(&list->entries.front());
        ASSERT_NE(draw, nullptr);
        ASSERT_EQ(draw->vertices.size(), 4u);
        EXPECT_NEAR((draw->vertices[1].x + draw->vertices[3].x) / 2, point.x, 0.0001f);
        EXPECT_NEAR((draw->vertices[1].y + draw->vertices[3].y) / 2, point.y, 0.0001f);
        EXPECT_FLOAT_EQ(MenuMouseTake().x, before.x); // rendering did not select a cell
        // A second displayed frame in the same game tick follows new motion immediately.
        InputHandleEvent(event);
        const auto latest = MenuMouseDisplaySample();
        gfx::BeginRecording();
        MenuMouseDraw();
        const auto  next = gfx::EndRecording();
        const auto *moved = std::get_if<gfx::detail::Draw2DEntry>(&next->entries.front());
        ASSERT_NE(moved, nullptr);
        EXPECT_NEAR((moved->vertices[1].x + moved->vertices[3].x) / 2, latest.x, 0.0001f);
        EXPECT_NE(latest.x, point.x);
        EXPECT_FLOAT_EQ(MenuMouseTake().x, before.x);
        MenuMouseEnable(false);
        InputSetMenuMouse(false);
        gfx::DestroyTexture(texture);
    }
    InputSetMouseSettings(settings);
}

namespace {
void CaptureRidepodWarning(bool wide) {
    const char *data = std::getenv("DC2_DATA");
    if (!data) {
        GTEST_SKIP() << "DC2_DATA supplies the extracted glyph atlas";
    }
    if (FirstRunDataMissing(data)) {
        GTEST_SKIP() << "DC2_DATA needs the current published PNG extraction";
    }
    DataReadIndex(data);
    const auto    path = std::filesystem::path(data) / "dungeon/articles/tex01_1.chr";
    std::ifstream file(path, std::ios::binary | std::ios::ate);
    if (!file) {
        GTEST_SKIP() << "Extracted system texture archive unavailable";
    }
    const size_t           bytes = static_cast<size_t>(file.tellg());
    std::vector<u_long128> archive((bytes + 15) / 16);
    file.seekg(0);
    ASSERT_TRUE(file.read(reinterpret_cast<char *>(archive.data()), bytes));
    TextureSourceRegister(archive.data(), "dungeon/articles/tex01_1.chr", bytes);
    const TextureSourceScope archive_source{archive.data()};
    int   member_size = 0;
    char  member_name[] = "frame_basic.img";
    auto *image = GetPackFile(reinterpret_cast<u_int *>(archive.data()), member_name, &member_size);
    const TextureSourceScope image_source{image};
    ASSERT_NE(image, nullptr);
    PresentRenderer renderer(wide ? 1280 : 640, wide ? 720 : 480);
    gfx::SetFrameLayout({gfx::AspectMode::Fill, 1.0f});
    PresentSetSettings(PresentSettings{.interpolation = true});
    std::vector<u_long128> backing(131072);
    mgCMemory              memory;
    memory.stSetBuffer(backing.data(), static_cast<int>(backing.size()));
    mgCTextureManager manager;
    manager.SetTableBuffer(64, 8, &memory);
    manager.Initialize(0x1000, -1);
    manager.EnterIMGFile(reinterpret_cast<u_char *>(image), 0, &memory, nullptr);
    auto *saved = TEX_SystenFrame;
    char  texture_name[] = "frame";
    TEX_SystenFrame = manager.GetTexture(texture_name, -1);
    ASSERT_NE(TEX_SystenFrame, nullptr);
    mgSetDataBuffer(&memory, &memory, 0);

    CWarningGage2 warning{};
    warning.layout = WARNING_GAGE_LAYOUT_ROBO;
    warning.time = 20;
    warning.warning[0] = warning.warning[1] = 1;
    warning.rate[0] = warning.rate[1] = 0.1f;
    mgSetBackGround(20, 30, 45, 128);
    mgBeginFrame(nullptr);
    warning.Draw();
    mgEndFrame(nullptr);
    std::vector<uint8_t> anchored, old;
    uint32_t             width = 0, height = 0;
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, anchored, width, height));
    gfx::BeginRecording();
    for (auto entry : mgPortLastList()->entries) {
        if (auto *draw = std::get_if<gfx::detail::Draw2DEntry>(&entry)) {
            EXPECT_EQ(draw->side.x, -1);
            EXPECT_EQ(draw->side.y, -1);
            draw->side = {}; // The previous robot-warning path, as a pixel oracle.
        }
        gfx::detail::RecordEntry(std::move(entry));
    }
    auto reference = gfx::EndRecording();
    ASSERT_TRUE(gfx::RenderList(*reference, 1, gfx::RenderOptions{.canonical = true}));
    ASSERT_TRUE(gfx::ReadbackTexture(gfx::kPreviousFrame, old, width, height));
    if (wide) {
        EXPECT_NE(anchored, old);
    } else {
        EXPECT_EQ(anchored, old); // 4:3 remains byte-identical.
    }
    if (const char *capture = std::getenv("DC2_CAPTURE_DIR")) {
        std::filesystem::create_directories(capture);
        const auto name = wide ? "ridepod-16x9.png" : "ridepod-4x3.png";
        ASSERT_TRUE(gfx::WritePng(std::filesystem::path(capture) / name, anchored.data(), width, height));
        ASSERT_TRUE(gfx::WritePng(std::filesystem::path(capture) / (std::string("before-") + name), old.data(), width, height));
    }
    TEX_SystenFrame = saved;
    manager.Initialize(0x1000, -1);
}
} // namespace

TEST(MglibPresent, RidepodWarningsAnchorAtSixteenNine) { CaptureRidepodWarning(true); }

TEST(MglibPresent, RidepodWarningsStayIdenticalAtFourThree) { CaptureRidepodWarning(false); }

TEST(MglibPresent, RetailTownEyeMovementPairsAndRendersIntermediateCamera) {
    PresentRenderer renderer(640, 480);
    PresentSetSettings(PresentSettings{.interpolation = true});
    auto        save = std::make_unique<CSaveData>();
    auto       *old_save = PortActiveSaveData;
    const auto  old_loop = PortLoopNo;
    const auto  old_mode = PortEditViewMode;
    const auto  old_pad = GamePad__2;
    const float old_heading = PortEditEyeHeading, old_tilt = PortEditEyeTilt;
    PortActiveSaveData = save.get();
    PortLoopNo = LOOP_EDIT;
    PortEditViewMode = EDIT_VIEW_MODE_EYE;
    PortEditEyeHeading = PortEditEyeTilt = 0;
    GamePad__2.pad[0].left_x = GamePad__2.pad[0].left_y = 128;
    CScene         scene;
    CCharacter2    chara;
    CCameraControl camera;
    CPadControl    pad{};
    camera.FollowOff();
    camera.ControlOff();
    scene.AssignChara(0, &chara, const_cast<char *>("player"));
    scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
    scene.player_chara = scene.active_camera = scene.event_run = 0;
    const std::vector<gfx::Vertex3D> vertices = {
        RedVertex(-5, -5), RedVertex(5, -5), RedVertex(5, 5), RedVertex(-5, 5)};
    const std::vector<uint32_t> indices = {0, 1, 2, 0, 2, 3};
    auto                        record = [&](float x, float heading) {
        chara.SetPosition(x, 0, 0);
        PortEditEyeHeading = heading;
        mgBeginFrame(nullptr);
        PortEditCameraControl(&scene, &pad);
        sceVu0FMATRIX matrix;
        camera.GetCameraMatrix(matrix);
        auto transform = gfx::IdentityMeshTransform();
        std::memcpy(transform.view, matrix, sizeof matrix);
        Store(Projection(), transform.projection);
        transform.model[13] = 28;
        transform.model[14] = 50;
        gfx::MeshConstants constants{};
        constants.flags = gfx::kMeshVertexColor;
        Store(Multiply(Multiply(Projection(), std::to_array(transform.view)),
                       std::to_array(transform.model)),
              constants.mvp);
        std::fill_n(constants.diffuse, 4, 1.0f);
        gfx::DrawState state;
        state.depth_test = gfx::DepthTest::Always;
        mgPortInterpScope scope(&camera, 1000);
        mgPortDrawMeshImmediate(vertices, indices, constants, {}, state, &transform);
        mgEndFrame(nullptr);
    };
    record(0, 0); // Drain any pending entry cut.
    record(0, 0);
    record(10, 0.1f);
    EXPECT_FALSE(mgPortLastList()->camera_cut);
    std::vector<uint8_t> pixels;
    uint32_t             width = 0, height = 0;
    double               centers[3]{};
    for (int i = 0; i < 3; ++i) {
        EXPECT_TRUE(PresentScreenshotDisplay(i * 0.5f, pixels, width, height));
        RedCentroidX(pixels, width, height, centers[i]);
    }
    EXPECT_GT(std::fabs(centers[0] - centers[2]), 5);
    EXPECT_GT(centers[1], std::min(centers[0], centers[2]));
    EXPECT_LT(centers[1], std::max(centers[0], centers[2]));
    EXPECT_EQ(mgPortLastList()->cache.cameras, std::vector<int32_t>{0});
    PortActiveSaveData = old_save;
    PortLoopNo = old_loop;
    PortEditViewMode = old_mode;
    GamePad__2 = old_pad;
    PortEditEyeHeading = old_heading;
    PortEditEyeTilt = old_tilt;
}

TEST(MglibPresent, RetailForcedFollowMovementPairsAndRendersIntermediateCamera) {
    PresentRenderer renderer(640, 480);
    PresentSetSettings(PresentSettings{.interpolation = true});
    auto        save = std::make_unique<CSaveData>();
    auto       *old_save = PortActiveSaveData;
    const auto  old_loop = PortLoopNo;
    const auto  old_mode = PortEditViewMode;
    const auto  old_pad = GamePad__2;
    const float old_heading = PortEditEyeHeading, old_tilt = PortEditEyeTilt;
    PortActiveSaveData = save.get();
    PortLoopNo = LOOP_EDIT;
    PortEditViewMode = EDIT_VIEW_MODE_WALK;
    PortEditEyeHeading = PortEditEyeTilt = 0;
    GamePad__2.pad[0].left_x = GamePad__2.pad[0].left_y = 128;
    CScene         scene;
    CCharacter2    chara;
    CCameraControl camera;
    CPadControl    pad{};
    CMap           map;
    scene.AssignMap(0, &map, const_cast<char *>("s07"));
    scene.active_map = 0;
    scene.AssignChara(0, &chara, const_cast<char *>("player"));
    scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
    scene.player_chara = scene.active_camera = scene.event_run = 0;
    const std::vector<gfx::Vertex3D> vertices = {
        RedVertex(-5, -5), RedVertex(5, -5), RedVertex(5, 5), RedVertex(-5, 5)};
    const std::vector<uint32_t> indices = {0, 1, 2, 0, 2, 3};
    auto                        record = [&](float x, float heading) {
        chara.SetPosition(x, 0, 0);
        PortEditEyeHeading = heading;
        mgBeginFrame(nullptr);
        PortEditCameraControl(&scene, &pad);
        sceVu0FMATRIX matrix;
        camera.GetCameraMatrix(matrix);
        auto transform = gfx::IdentityMeshTransform();
        std::memcpy(transform.view, matrix, sizeof matrix);
        Store(Projection(), transform.projection);
        transform.model[13] = 150;
        transform.model[14] = -50;
        gfx::MeshConstants constants{};
        constants.flags = gfx::kMeshVertexColor;
        Store(Multiply(Multiply(Projection(), std::to_array(transform.view)),
                       std::to_array(transform.model)),
              constants.mvp);
        std::fill_n(constants.diffuse, 4, 1.0f);
        gfx::DrawState state;
        state.depth_test = gfx::DepthTest::Always;
        mgPortInterpScope scope(&camera, 1000);
        mgPortDrawMeshImmediate(vertices, indices, constants, {}, state, &transform);
        mgEndFrame(nullptr);
    };
    record(0, 0); // Drain any pending entry cut.
    record(0, 0);
    record(20, 0.1f);
    EXPECT_FALSE(mgPortLastList()->camera_cut);
    std::vector<uint8_t> pixels;
    uint32_t             width = 0, height = 0;
    double               centers[3]{};
    for (int i = 0; i < 3; ++i) {
        EXPECT_TRUE(PresentScreenshotDisplay(i * 0.5f, pixels, width, height));
        RedCentroidX(pixels, width, height, centers[i]);
    }
    EXPECT_GT(std::fabs(centers[0] - centers[2]), 5);
    EXPECT_GT(centers[1], std::min(centers[0], centers[2]));
    EXPECT_LT(centers[1], std::max(centers[0], centers[2]));
    EXPECT_EQ(mgPortLastList()->cache.cameras, std::vector<int32_t>{0});
    PortActiveSaveData = old_save;
    PortLoopNo = old_loop;
    PortEditViewMode = old_mode;
    GamePad__2 = old_pad;
    PortEditEyeHeading = old_heading;
    PortEditEyeTilt = old_tilt;
}

TEST(MglibPresent, SameOwnerAuthoredCameraStepCutsTheDrawnTick) {
    PresentRenderer renderer(640, 480);
    PresentSetSettings(PresentSettings{.interpolation = true});
    CCameraControl camera;
    camera.FollowOff();
    camera.ControlOff();
    const std::vector<gfx::Vertex3D> vertices = {
        RedVertex(-5, -5), RedVertex(5, -5), RedVertex(5, 5), RedVertex(-5, 5)};
    const std::vector<uint32_t> indices = {0, 1, 2, 0, 2, 3};
    auto                        record = [&](float x) {
        mgBeginFrame(nullptr);
        camera.SetNextPos(x, 0, -100);
        camera.SetNextRef(x, 0, 0);
        camera.Step(-1); // SET_CAMERA_NEXT_POS/REF + CAMERA_STEP on an unchanged owner.
        sceVu0FMATRIX matrix;
        camera.GetCameraMatrix(matrix);
        auto transform = gfx::IdentityMeshTransform();
        std::memcpy(transform.view, matrix, sizeof matrix);
        Store(Projection(), transform.projection);
        gfx::MeshConstants constants{};
        constants.flags = gfx::kMeshVertexColor;
        Store(Multiply(Projection(), std::to_array(transform.view)), constants.mvp);
        std::fill_n(constants.diffuse, 4, 1.0f);
        gfx::DrawState state;
        state.depth_test = gfx::DepthTest::Always;
        mgPortInterpScope scope(&camera, 1000);
        mgPortDrawMeshImmediate(vertices, indices, constants, {}, state, &transform);
        mgEndFrame(nullptr);
    };
    record(0);
    const auto generation = mgPortCameraGeneration();
    record(20);
    EXPECT_GT(mgPortCameraGeneration(), generation);
    ASSERT_NE(mgPortLastList(), nullptr);
    EXPECT_TRUE(mgPortLastList()->camera_cut);
    std::vector<uint8_t> pixels;
    uint32_t             width = 0, height = 0;
    double               centers[3]{};
    for (int i = 0; i < 3; ++i) {
        EXPECT_TRUE(PresentScreenshotDisplay(i * 0.5f, pixels, width, height));
        RedCentroidX(pixels, width, height, centers[i]);
    }
    EXPECT_NEAR(centers[0], centers[2], 0.001);
    EXPECT_NEAR(centers[1], centers[2], 0.001);
}

TEST(MglibPresent, DungeonEyeExitCutsTheRestoreTickWithoutCuttingTheNextTick) {
    PresentRenderer renderer(640, 480);
    auto           *old_scene = DngMainScene;
    auto           *old_main = MainChara__2;
    auto           *old_area = BattleAreaScene;
    const auto      old_status = DngStatus;
    const int       old_loop = PortLoopNo;
    CScene          scene;
    CCameraControl  camera;
    CActionChara    chara;
    chara.next = nullptr;
    scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
    scene.active_camera = 0;
    DngMainScene = &scene;
    MainChara__2 = &chara;
    BattleAreaScene = &scene.battle_area;
    PortLoopNo = LOOP_DUNGEON;
    DngStatus.eye_view = 0;
    auto draw = [] { mgBeginFrame(nullptr); mgEndFrame(nullptr); };
    draw();
    InitEyeCamera(&chara);
    draw();
    EXPECT_TRUE(mgPortLastList()->camera_cut);
    draw();
    EXPECT_FALSE(mgPortLastList()->camera_cut);
    const auto generation = mgPortCameraGeneration();
    mgBeginFrame(nullptr);
    ResetEyeView(&chara); // Logic runs after BeginFrame in the actual main loop.
    mgEndFrame(nullptr);
    EXPECT_GT(mgPortCameraGeneration(), generation);
    EXPECT_TRUE(mgPortLastList()->camera_cut);
    const auto restored_generation = mgPortCameraGeneration();
    draw();
    EXPECT_EQ(mgPortCameraGeneration(), restored_generation);
    EXPECT_FALSE(mgPortLastList()->camera_cut);
    DngMainScene = old_scene;
    MainChara__2 = old_main;
    BattleAreaScene = old_area;
    DngStatus = old_status;
    PortLoopNo = old_loop;
}
