#include "common.h"

#include <gtest/gtest.h>

#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <string>
#include <vector>

#include "gfx/gfx.hpp"
#include "gfx_fixture.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "platform/clock.hpp"
#include "platform/window.hpp"
#include "render/renderer.hpp"
#include "render/screen_effects.hpp"
#include "screeneffect.hpp"

// Register macros must follow the host and test headers.
// clang-format off
#include "libgraph.h"
// clang-format on

using namespace dc::test;

namespace {

class PresentRenderer {
public:
    PresentRenderer() {
        SetEnv("VK_LAYER_VALIDATE_SYNC", "1", 0);
        WindowConfig window{.width = 512, .height = 480, .headless = true};
        window.vulkan = false;
        WindowInit(window);

        gfx::RendererConfig config;
        config.app_name = "Dark Chronicle screen effect tests";
        config.logical_width = 512.0f;
        config.logical_height = 480.0f;
        config.display_aspect = 512.0f / 480.0f;
        config.validation = true;
        config.offscreen = true;
        config.pipeline_cache = std::filesystem::temp_directory_path() / "dc_gfx_test" /
                                ("screeneffect_" + std::to_string(ProcessId()) + ".bin");
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

struct Pixels {
    std::vector<uint8_t> rgba;
    uint32_t             width = 0;
    uint32_t             height = 0;
    gfx::LogicalMapping  mapping{};

    [[nodiscard]] const uint8_t *At(float x, float y) const {
        const auto px = static_cast<size_t>(x * mapping.scale_x + mapping.offset_x);
        const auto py = static_cast<size_t>(y * mapping.scale_y + mapping.offset_y);
        return &rgba[(py * width + px) * 4];
    }
};

// Opaque, depth-writing state for full-frame test geometry.
gfx::DrawState OpaqueDepthWriteState() {
    gfx::DrawState state = mgPortDrawState();
    state.depth_test = gfx::DepthTest::Always;
    state.depth_write = true;
    state.alpha_test = false;
    state.blend = false;
    state.cull = gfx::CullMode::None;
    return state;
}

// One-logical-pixel columns alternating black and white: a 2:1 blur averages each pair to grey.
// The left half sits at near_depth, the right half at far_depth, and both write depth.
void DrawStripedScene(float near_depth, float far_depth) {
    std::vector<gfx::Vertex2D> quads;
    const auto                 height = static_cast<float>(mgScreenHeight);

    for (int column = 0; column < mgScreenWidth; ++column) {
        const uint8_t value = column % 2 == 0 ? 0 : 255;
        const float   z = column < mgScreenWidth / 2 ? near_depth : far_depth;
        const auto    left = static_cast<float>(column);
        const float   right = left + 1.0f;
        const float   corners[4][2] = {
            {left,  0.0f  },
            {right, 0.0f  },
            {right, height},
            {left,  height}
        };

        for (const auto &corner : corners) {
            gfx::Vertex2D vertex{};
            vertex.x = corner[0];
            vertex.y = corner[1];
            vertex.z = z;
            vertex.color[0] = value;
            vertex.color[1] = value;
            vertex.color[2] = value;
            vertex.color[3] = 0x80;
            quads.push_back(vertex);
        }
    }

    mgPortDraw2D(gfx::Primitive::Quads, quads, gfx::TextureBinding{}, OpaqueDepthWriteState());
}

double MeanStep(const Pixels &pixels, int x0, int x1, float y) {
    double sum = 0.0;
    for (int x = x0; x < x1; ++x) {
        sum += std::abs(static_cast<int>(pixels.At(x + 1.0f, y)[0]) - static_cast<int>(pixels.At(x, y)[0]));
    }
    return sum / static_cast<double>(x1 - x0);
}

void UseIdentityView() {
    float view[4][4] = {
        {1.0f, 0.0f, 0.0f, 0.0f},
        {0.0f, 1.0f, 0.0f, 0.0f},
        {0.0f, 0.0f, 1.0f, 0.0f},
        {0.0f, 0.0f, 0.0f, 1.0f}
    };
    float origin[3] = {0.0f, 0.0f, 0.0f};
    mgSetViewMatrix(view, origin);
}

void ClearMain(uint8_t grey, float depth) {
    const uint8_t colour[4] = {grey, grey, grey, 0x80};
    gfx::Clear(true, colour, true, depth, nullptr);
}

// Opaque full-frame quad at `depth`, writing depth: an occluder nearer than the sun.
void DrawFrameOccluder(float depth, uint8_t grey) {
    const auto  width = static_cast<float>(mgScreenWidth);
    const auto  height = static_cast<float>(mgScreenHeight);
    const float corners[4][2] = {
        {0.0f,  0.0f  },
        {width, 0.0f  },
        {width, height},
        {0.0f,  height}
    };
    std::vector<gfx::Vertex2D> quad;

    for (const auto &corner : corners) {
        gfx::Vertex2D vertex{};
        vertex.x = corner[0];
        vertex.y = corner[1];
        vertex.z = depth;
        vertex.color[0] = grey;
        vertex.color[1] = grey;
        vertex.color[2] = grey;
        vertex.color[3] = 0x80;
        quad.push_back(vertex);
    }

    mgPortDraw2D(gfx::Primitive::Quads, quad, gfx::TextureBinding{}, OpaqueDepthWriteState());
}

// The sun as the caller hands it over: mgTransWorldScreen's 12.4 position and mgTransZPrim(10000).
LensFlareSun SunAt(int x_pixels, int y_pixels) {
    const int screen[4] = {x_pixels * 16, y_pixels * 16, mgTransZPrim(10000.0f), 0};
    return LensFlareSunOf(screen);
}

Pixels ReadMain() {
    Pixels pixels;
    EXPECT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, pixels.rgba, pixels.width, pixels.height));
    pixels.mapping = gfx::GetLogicalMapping(gfx::kMainTarget);
    return pixels;
}

} // namespace

TEST(ScreenEffect, DepthOfFieldLevelSizesFollowRetailCascade) {
    const DepthOfFieldLevel expected[4] = {
        {.width = 256, .height = 240},
        {.width = 170, .height = 160},
        {.width = 113, .height = 106},
        {.width = 75,  .height = 71 }
    };

    for (int level = 0; level < 4; ++level) {
        const DepthOfFieldLevel size = DepthOfFieldLevelSize(level, 512, 480);
        EXPECT_EQ(size.width, expected[level].width) << "level " << level;
        EXPECT_EQ(size.height, expected[level].height) << "level " << level;
    }
}

TEST(ScreenEffect, NativeDepthIsTheMeshProjectionReverseZ) {
    PresentRenderer renderer;
    mgSetRenderInfo(512.0f, 10.0f, 4000.0f);

    float eye_to_clip[16];
    mgPortEyeToClip(mgPortCurrentProjection(), mgPortCurrentTarget(), eye_to_clip);

    for (const float distance : {10.0f, 500.0f, 1000.0f, 1100.0f, 2000.0f, 4000.0f}) {
        const float clip_z = eye_to_clip[10] * distance + eye_to_clip[14];
        const float clip_w = eye_to_clip[11] * distance + eye_to_clip[15];
        EXPECT_NEAR(DepthOfFieldDepth(distance), clip_z / clip_w, 1e-6f) << "distance " << distance;
    }

    EXPECT_NEAR(DepthOfFieldDepth(10.0f), 1.0f, 1e-6f);
    EXPECT_NEAR(DepthOfFieldDepth(4000.0f), 0.0f, 1e-6f);
}

TEST(ScreenEffect, DepthOfFieldBlursOnlyFarPixels) {
    PresentRenderer renderer;
    mgSetRenderInfo(512.0f, 10.0f, 4000.0f);
    UseIdentityView();

    mgBeginFrame(nullptr);
    DrawStripedScene(DepthOfFieldDepth(500.0f), DepthOfFieldDepth(2000.0f));
    mgCTexture work{};
    float      depths[1] = {1000.0f};
    DepthOfField(1, depths, &work, 1.0f);
    mgEndFrame(nullptr);

    Pixels pixels;
    ASSERT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, pixels.rgba, pixels.width, pixels.height));
    pixels.mapping = gfx::GetLogicalMapping(gfx::kMainTarget);

    EXPECT_GT(MeanStep(pixels, 40, 200, 120.0f), 200.0);
    EXPECT_LT(MeanStep(pixels, 300, 460, 120.0f), 20.0);
    EXPECT_NEAR(pixels.At(380.0f, 120.0f)[0], 128, 8);
}

TEST(ScreenEffect, LensFlareSunDepthIsTheNativeProjection) {
    PresentRenderer renderer;
    mgSetRenderInfo(512.0f, 10.0f, 20000.0f);

    EXPECT_NEAR(SunAt(256, 240).depth, DepthOfFieldDepth(10000.0f), 1e-6f);
}

TEST(ScreenEffect, LensFlareAddsLightWhenSunVisible) {
    PresentRenderer renderer;
    mgSetRenderInfo(512.0f, 10.0f, 20000.0f);
    UseIdentityView();
    const float           colour[4] = {128.0f, 128.0f, 128.0f, 128.0f};
    const LensFlareSource source{.first_alpha = true, .second_alpha = true, .tex1 = 0};

    mgBeginFrame(nullptr);
    ClearMain(0x40, 0.0f);
    LensFlareDraw(SunAt(256, 240), colour, source);
    mgEndFrame(nullptr);

    const Pixels pixels = ReadMain();
    EXPECT_GT(pixels.At(256.0f, 240.0f)[0], 0x40 + 16);
}

TEST(ScreenEffect, LensFlareOccludedBehindGeometry) {
    PresentRenderer renderer;
    mgSetRenderInfo(512.0f, 10.0f, 20000.0f);
    UseIdentityView();
    const float           colour[4] = {128.0f, 128.0f, 128.0f, 128.0f};
    const LensFlareSource source{.first_alpha = true, .second_alpha = true, .tex1 = 0};

    mgBeginFrame(nullptr);
    ClearMain(0x40, 0.0f);
    DrawFrameOccluder(DepthOfFieldDepth(500.0f), 0x40);
    LensFlareDraw(SunAt(256, 240), colour, source);
    mgEndFrame(nullptr);

    const Pixels pixels = ReadMain();
    EXPECT_NEAR(pixels.At(256.0f, 240.0f)[0], 0x40, 2);
    EXPECT_NEAR(pixels.At(40.0f, 40.0f)[0], 0x40, 2);
}

TEST(ScreenEffect, LensFlareOutsideDistanceLimitDoesNothing) {
    PresentRenderer renderer;
    mgSetRenderInfo(512.0f, 10.0f, 20000.0f);
    UseIdentityView();
    const float           colour[4] = {128.0f, 128.0f, 128.0f, 128.0f};
    const LensFlareSource source{.first_alpha = true, .second_alpha = true, .tex1 = 0};
    const LensFlareSun    sun = SunAt(856, 240);

    EXPECT_FALSE(LensFlareInRange(sun));

    mgBeginFrame(nullptr);
    ClearMain(0x40, 0.0f);
    LensFlareDraw(sun, colour, source);
    mgEndFrame(nullptr);

    const Pixels pixels = ReadMain();
    EXPECT_NEAR(pixels.At(256.0f, 240.0f)[0], 0x40, 0);
    EXPECT_NEAR(pixels.At(40.0f, 40.0f)[0], 0x40, 0);
}

// Depth of field samples the display's own grab in screen space. A scene camera must not
// carry that screen-sized depth-tested layer a second time like a world billboard.
TEST(ScreenEffect, DepthOfFieldDisplayKeepsScreenAligned) {
    PresentRenderer renderer;
    mgSetRenderInfo(512.0f, 10.0f, 4000.0f);
    auto record = [&](float camera_x) {
        mgBeginFrame(nullptr);
        DrawStripedScene(DepthOfFieldDepth(500.0f), DepthOfFieldDepth(2000.0f));
        auto transform = gfx::IdentityMeshTransform();
        transform.view[12] = camera_x;
        gfx::MeshConstants constants = {};
        std::memcpy(constants.mvp, transform.view, sizeof constants.mvp);
        // An offscreen mesh establishes a moving scene without changing the test image.
        const gfx::Vertex3D vertices[3] = {
            {.position = {100, 100, 0.5f}, .normal = {}, .uv = {}, .color = {}},
            {.position = {101, 100, 0.5f}, .normal = {}, .uv = {}, .color = {}},
            {.position = {100, 101, 0.5f}, .normal = {}, .uv = {}, .color = {}}
        };
        const uint32_t indices[3] = {0, 1, 2};
        gfx::SetInterpKey(931);
        gfx::DrawMeshImmediate(vertices, indices, constants, {}, {}, &transform);
        mgCTexture work{};
        float      depths[1] = {1000.0f};
        DepthOfField(1, depths, &work, 1.0f);
        mgEndFrame(nullptr);
    };
    record(0);
    record(0.4f);
    auto canonical = ReadMain();
    ASSERT_TRUE(gfx::RenderList(*mgPortLastList(), 0.5f,
                                {.previous = mgPortPreviousList(), .present = true}));
    std::vector<uint8_t> display;
    uint32_t             width = 0;
    uint32_t             height = 0;
    ASSERT_TRUE(gfx::ReadbackFrame(display, width, height));
    ASSERT_EQ(width, canonical.width);
    ASSERT_EQ(height, canonical.height);
    size_t different = 0;
    for (size_t i = 0; i < display.size(); ++i) {
        different += display[i] != canonical.rgba[i];
    }
    EXPECT_EQ(different, 0u);
}
