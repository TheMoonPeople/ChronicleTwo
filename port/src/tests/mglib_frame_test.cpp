#include "common.h"

#include <gtest/gtest.h>

#include <array>
#include <cstdint>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <string>
#include <vector>

#include "exitcodes.hpp"
#include "gfx/context.hpp"
#include "gfx/gfx.hpp"
#include "gfx_fixture.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "platform/clock.hpp"

using namespace dc::test;

namespace {

// gfx_fixture.hpp fixes the logical frame at 640x480, so this brings the renderer up at the game's frame.
// The window is 640x480 so the 512x480 frame is letterboxed, as it is in a windowed run.
class OffscreenRenderer {
public:
    OffscreenRenderer() {
        SetEnv("VK_LAYER_VALIDATE_SYNC", "1", 0);
        WindowConfig window{640, 480, true};
        window.vulkan = false;
        WindowInit(window);

        gfx::RendererConfig config;
        config.app_name = "Dark Chronicle tests";
        config.logical_width = 512.0f;
        config.logical_height = 480.0f;
        config.display_aspect = 4.0f / 3.0f;
        config.validation = true;
        config.offscreen = true;
        config.pipeline_cache = std::filesystem::temp_directory_path() / "dc_gfx_test" /
                                ("mglib_frame_" + std::to_string(ProcessId()) + ".bin");
        gfx::RendererInit(WindowHandle(), config);

        // Unbounded so mgEndFrame's WaitVSync does not sleep for real ticks.
        ClockSetUnbounded(true);
        mgInit(MG_SCREEN_MODE_512X480, 3);
    }

    ~OffscreenRenderer() {
        gfx::RendererShutdown();
        WindowShutdown();
        EXPECT_EQ(gfx::ValidationMessageCount(), 0u);
    }
};

// Column-major matrix times vector.
std::array<float, 4> Apply(const float (&m)[16], const std::array<float, 4> &p) {
    std::array<float, 4> out = {};
    for (int row = 0; row < 4; ++row) {
        for (int col = 0; col < 4; ++col) {
            out[row] += m[col * 4 + row] * p[col];
        }
    }
    return out;
}

// mgTransViewPrim truncates to 1/16 logical pixel, so the position tolerance has to allow for it.
void ExpectMatchesRetail(const std::array<float, 3> &point, const float (&eye_to_clip)[16],
                         const gfx::LogicalMapping  &mapping) {
    const std::array<float, 4> p = {point[0], point[1], point[2], 1.0f};
    const std::array<float, 4> clip = Apply(eye_to_clip, p);
    const float                ndc_x = clip[0] / clip[3];
    const float                ndc_y = clip[1] / clip[3];
    const float                ndc_z = clip[2] / clip[3];
    const float                logical_x = ((ndc_x + 1.0f) * 0.5f * static_cast<float>(mapping.pixel_width) - mapping.offset_x) /
                                           mapping.scale_x;
    const float                logical_y = ((ndc_y + 1.0f) * 0.5f * static_cast<float>(mapping.pixel_height) - mapping.offset_y) /
                                           mapping.scale_y;

    float pos[4] = {p[0], p[1], p[2], p[3]};
    int   out[4] = {};
    mgTransViewPrim(out, pos);

    EXPECT_NEAR(logical_x, out[0] / 16.0f - mgScreenOffx, 0.1f) << "view point " << point[0] << ", " << point[1]
                                                                << ", " << point[2];
    EXPECT_NEAR(logical_y, out[1] / 16.0f - mgScreenOffy, 0.1f) << "view point " << point[0] << ", " << point[1]
                                                                << ", " << point[2];
    EXPECT_NEAR(ndc_z, mgPortDepth(static_cast<uint32_t>(out[2])), 1e-4f) << "view point " << point[2];
}

} // namespace

TEST(MglibFrame, ClearAndReadback) {
    OffscreenRenderer renderer;

    mgSetBackGround(64.0f, 128.0f, 192.0f, 128.0f);
    mgBeginFrame(nullptr);
    mgEndFrame(nullptr);

    EXPECT_TRUE(mgPortRendererReady());
    EXPECT_EQ(mgPortFrameCount(), 1);

    std::vector<uint8_t> rgba;
    uint32_t             width = 0;
    uint32_t             height = 0;
    ASSERT_TRUE(mgPortReadColor(gfx::kMainTarget, rgba, width, height));
    const size_t centre = (static_cast<size_t>(height / 2) * width + width / 2) * 4;
    EXPECT_NEAR(rgba[centre + 0], 64, 1);
    EXPECT_NEAR(rgba[centre + 1], 128, 1);
    EXPECT_NEAR(rgba[centre + 2], 192, 1);
}

TEST(MglibFrame, PickZAfterClearIsFar) {
    OffscreenRenderer renderer;

    mgPickZBuff[0] = {1, 256, 240, 0};
    mgPickZBuff[1] = {1, 2, 2, 0};
    // A depth answer becomes available when its submitted frame retires from the ring.
    for (uint32_t attempt = 0; attempt <= gfx::detail::kFramesInFlight; ++attempt) {
        mgBeginFrame(nullptr);
        mgEndFrame(nullptr);
        // Samples within four pixels of the edge are rejected without a GPU query.
        EXPECT_EQ(mgPickZBuff[1].z, -1);
        if (mgPickZBuff[0].z != -1) {
            break;
        }
    }
    // Cleared depth is zero, the far plane in reverse-Z.
    EXPECT_EQ(mgPickZBuff[0].z, 0);
}

TEST(MglibState, InitialDrawState) {
    OffscreenRenderer renderer;

    const gfx::DrawState state = mgPortDrawState();
    EXPECT_EQ(state.alpha.a, 0);
    EXPECT_EQ(state.alpha.b, 1);
    EXPECT_EQ(state.alpha.c, 0);
    EXPECT_EQ(state.alpha.d, 1);
    EXPECT_EQ(state.alpha.fix, 0);
    EXPECT_TRUE(state.texa_aem);
    EXPECT_EQ(state.texa_ta0, 0x80);
    EXPECT_TRUE(state.alpha_test);
    EXPECT_EQ(state.alpha_func, gfx::AlphaFunc::GEqual);
    EXPECT_EQ(state.depth_test, gfx::DepthTest::GEqual);

    EXPECT_EQ(mgPortGs().tex1, 0x61u);
    EXPECT_EQ(mgPortWrapU(0), gfx::Wrap::Repeat);
    EXPECT_EQ(mgPortWrapU(1), gfx::Wrap::Clamp);
}

TEST(MglibProjection, MatchesRetailScreen) {
    OffscreenRenderer renderer;

    mgSetRenderInfo(400.0f, 10.0f, 10000.0f);
    float identity[4][4] = {
        {1, 0, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {0, 0, 0, 1}
    };
    float eye[4] = {0, 0, 0, 0};
    mgSetViewMatrix(identity, eye);

    float eye_to_clip[16];
    mgPortEyeToClip(mgPortCurrentProjection(), gfx::kMainTarget, eye_to_clip);
    const gfx::LogicalMapping mapping = gfx::GetLogicalMapping(gfx::kMainTarget);

    ExpectMatchesRetail({0.0f, 0.0f, 100.0f}, eye_to_clip, mapping);
    ExpectMatchesRetail({50.0f, -30.0f, 200.0f}, eye_to_clip, mapping);
    ExpectMatchesRetail({-120.0f, 80.0f, 1000.0f}, eye_to_clip, mapping);

    const auto depth_at = [&](float z) {
        const std::array<float, 4> clip = Apply(eye_to_clip, {0.0f, 0.0f, z, 1.0f});
        return clip[2] / clip[3];
    };
    EXPECT_NEAR(depth_at(10.0f), 1.0f, 1e-4f);
    EXPECT_NEAR(depth_at(10000.0f), 0.0f, 1e-4f);
}

TEST(MglibProjection, DepthRoundTrip) {
    mgScreenZDepth = 32;

    EXPECT_EQ(mgPortGsDepth(mgPortDepth(123456)), 123456u);
    EXPECT_FLOAT_EQ(mgPortDepth(0), 0.0f);
}

TEST(MglibFrameDeathTest, ExitAfterFramesWritesScreenshot) {
    GTEST_FLAG_SET(death_test_style, "threadsafe");

    const std::filesystem::path png = std::filesystem::temp_directory_path() /
                                      ("mglib_frame_shot_" + std::to_string(ProcessId()) + ".png");
    // The death child re-runs this preamble in a new process with a new ProcessId(), so the path is handed over by
    // environment and must not be overwritten there.
    SetEnv("DC_MGLIB_FRAME_SHOT", png, 0);

    EXPECT_EXIT(
        {
            OffscreenRenderer renderer;
            mgSetBackGround(64.0f, 128.0f, 192.0f, 128.0f);
            mgPortExitAfterFrames(2, std::getenv("DC_MGLIB_FRAME_SHOT"));
            for (int i = 0; i < 3; ++i) {
                mgBeginFrame(nullptr);
                mgEndFrame(nullptr);
            }
        },
        ::testing::ExitedWithCode(kExitOk), "frame 2 written to");

    ASSERT_TRUE(std::filesystem::exists(png));
    std::array<uint8_t, 8> signature = {};
    {
        std::ifstream in(png, std::ios::binary);
        in.read(reinterpret_cast<char *>(signature.data()), static_cast<std::streamsize>(signature.size()));
    }
    std::filesystem::remove(png);

    const std::array<uint8_t, 8> png_signature = {0x89, 'P', 'N', 'G', '\r', '\n', 0x1a, '\n'};
    EXPECT_EQ(signature, png_signature);
}
