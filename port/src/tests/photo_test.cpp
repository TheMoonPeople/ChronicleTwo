#include "common.h"

#include <gtest/gtest.h>

#include <algorithm>
#include <cstdint>
#include <filesystem>
#include <memory>
#include <string>
#include <vector>

#include "gfx/gfx.hpp"
#include "gfx_fixture.hpp"
#include "inventmn.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "padcontrol.hpp"
#include "photo.hpp"
#include "platform/clock.hpp"
#include "platform/window.hpp"
#include "render/primitive_submission.hpp"
#include "render/renderer.hpp"
#include "stubs/photo.hpp"

// Register macros must follow the host and test headers.
// clang-format off
#include "libgraph.h"
// clang-format on

using namespace dc::test;

namespace {

class PhotoRenderer {
public:
    explicit PhotoRenderer(int width = 512, int height = 480, float aspect = 512.0f / 480.0f) {
        SetEnv("VK_LAYER_VALIDATE_SYNC", "1", 0);
        WindowConfig window{.width = width, .height = height, .headless = true};
        window.vulkan = false;
        WindowInit(window);

        gfx::RendererConfig config;
        config.app_name = "Dark Chronicle photo tests";
        config.logical_width = 512.0f;
        config.logical_height = 480.0f;
        config.display_aspect = aspect;
        config.validation = true;
        config.offscreen = true;
        config.pipeline_cache = std::filesystem::temp_directory_path() / "dc_gfx_test" /
                                ("photo_" + std::to_string(ProcessId()) + ".bin");
        gfx::RendererInit(WindowHandle(), config);

        ClockSetUnbounded(true);
        mgInit(MG_SCREEN_MODE_512X480, 3);
    }

    ~PhotoRenderer() {
        gfx::RendererShutdown();
        WindowShutdown();
        EXPECT_EQ(gfx::ValidationMessageCount(), 0u);
    }
};

gfx::Vertex2D Corner(float x, float y, float u, float v, uint8_t red, uint8_t green, uint8_t blue) {
    gfx::Vertex2D vertex{};
    vertex.x = x;
    vertex.y = y;
    vertex.z = 1.0f;
    vertex.u = u;
    vertex.v = v;
    vertex.color[0] = red;
    vertex.color[1] = green;
    vertex.color[2] = blue;
    vertex.color[3] = 0x80;
    return vertex;
}

gfx::DrawState OpaqueState() {
    gfx::DrawState state = mgPortDrawState();
    state.depth_test = gfx::DepthTest::Always;
    state.depth_write = false;
    state.alpha_test = false;
    state.blend = false;
    state.cull = gfx::CullMode::None;
    return state;
}

// Left half red, right half blue, on the frame being drawn.
void DrawHalves() {
    const auto  width = static_cast<float>(mgScreenWidth);
    const auto  height = static_cast<float>(mgScreenHeight);
    const float middle = width / 2.0f;

    const std::vector<gfx::Vertex2D> red = {
        Corner(0.0f, 0.0f, 0.0f, 0.0f, 0xFF, 0, 0),
        Corner(middle, 0.0f, 0.0f, 0.0f, 0xFF, 0, 0),
        Corner(middle, height, 0.0f, 0.0f, 0xFF, 0, 0),
        Corner(0.0f, height, 0.0f, 0.0f, 0xFF, 0, 0),
    };
    const std::vector<gfx::Vertex2D> blue = {
        Corner(middle, 0.0f, 0.0f, 0.0f, 0, 0, 0xFF),
        Corner(width, 0.0f, 0.0f, 0.0f, 0, 0, 0xFF),
        Corner(width, height, 0.0f, 0.0f, 0, 0, 0xFF),
        Corner(middle, height, 0.0f, 0.0f, 0, 0, 0xFF),
    };

    mgPortDraw2D(gfx::Primitive::Quads, red, gfx::TextureBinding{}, OpaqueState());
    mgPortDraw2D(gfx::Primitive::Quads, blue, gfx::TextureBinding{}, OpaqueState());
}

} // namespace

TEST(Photo, ShutterSpriteCapturesTheFrame) {
    PhotoRenderer renderer;

    mgCTexture work{};
    work.Initialize();
    work.width = 64;
    work.height = 64;
    work.bpp = 32;
    work.tex0.TBP0 = 256 << 5;
    work.tex0.TBW = 1;
    work.tex0.PSM = SCE_GS_PSMCT32;

    mgBeginFrame(nullptr);
    DrawHalves();

    mgCTexture frame{};
    mgGetFrameBuffer(&frame);
    mgSetPkFrameBuffer(&work);

    const auto                       work_width = static_cast<float>(work.width);
    const auto                       work_height = static_cast<float>(work.height);
    const auto                       frame_width = static_cast<float>(frame.width);
    const auto                       frame_height = static_cast<float>(frame.height);
    const std::vector<gfx::Vertex2D> sprite = {
        Corner(0.0f, 0.0f, 0.0f, 0.0f, 0x80, 0x80, 0x80),
        Corner(work_width, 0.0f, frame_width, 0.0f, 0x80, 0x80, 0x80),
        Corner(work_width, work_height, frame_width, frame_height, 0x80, 0x80, 0x80),
        Corner(0.0f, work_height, 0.0f, frame_height, 0x80, 0x80, 0x80),
    };

    gfx::DrawState state = OpaqueState();
    mgPortDraw2D(gfx::Primitive::Quads, sprite, mgPortBinding(&frame), state);

    mgSetPkFrameBuffer(-1, -1, -1, -1);
    mgEndFrame(nullptr);

    const gfx::TextureHandle target = mgPortFindTexture(&work).texture;
    ASSERT_NE(target, gfx::kNullTexture);

    std::vector<uint8_t> rgba;
    uint32_t             width = 0;
    uint32_t             height = 0;
    ASSERT_TRUE(mgPortCanonicalReadColor(target, rgba, width, height));

    const gfx::LogicalMapping mapping = gfx::GetLogicalMapping(target);
    const auto                at = [&](float x, float y) {
        const auto px = static_cast<size_t>(x * mapping.scale_x + mapping.offset_x);
        const auto py = static_cast<size_t>(y * mapping.scale_y + mapping.offset_y);
        return &rgba[(py * width + px) * 4];
    };

    const uint8_t *left = at(16.0f, 32.0f);
    EXPECT_GT(left[0], 200);
    EXPECT_LT(left[1], 60);
    EXPECT_LT(left[2], 60);

    const uint8_t *right = at(48.0f, 32.0f);
    EXPECT_LT(right[0], 60);
    EXPECT_LT(right[1], 60);
    EXPECT_GT(right[2], 200);
}

TEST(Photo, ShutterReadbackContainsTheFirstCaptureAndItsCurrentSubjectDepth) {
    PhotoRenderer renderer;
    mgCTexture    work{};
    work.Initialize();
    work.width = work.height = 64;
    work.bpp = 16;
    work.tex0.TBP0 = 256 << 5;
    work.tex0.TBW = 1;
    work.tex0.PSM = SCE_GS_PSMCT16;
    WorkTex = &work;
    CPadControl pad{};
    auto        photos = std::make_unique<CInventUserData>();
    for (float depth : {0.25f, 0.75f}) {
        TakePhotoMode = TAKE_PHOTO_SHUTTER;
        mgBeginFrame(nullptr);
        LoopTakePhoto(&pad, photos.get());
        const uint8_t clear[4] = {};
        DrawHalves();
        gfx::Clear(false, clear, true, depth, nullptr);
        mgCTexture frame{};
        mgGetFrameBuffer(&frame);
        mgSetPkFrameBuffer(&work);
        const std::vector<gfx::Vertex2D> sprite = {
            Corner(0, 0, 0, 0, 128, 128, 128),
            Corner(64, 0, frame.width, 0, 128, 128, 128),
            Corner(64, 64, frame.width, frame.height, 128, 128, 128),
            Corner(0, 64, 0, frame.height, 128, 128, 128)};
        mgPortDraw2D(gfx::Primitive::Quads, sprite, mgPortBinding(&frame), OpaqueState());
        mgSetPkFrameBuffer(-1, -1, -1, -1);
        mgEndFrame(nullptr);

        mgBeginFrame(nullptr);
        u_long128 image[512]{};
        u_long128 values[16]{};
        mgStoreImage(&work, std::as_writable_bytes(std::span(image)));
        mgRect<int> lens(252, 204, 260, 212);
        mgStoreZBuffImage(lens, std::as_writable_bytes(std::span(values)));
        const auto *pixels = reinterpret_cast<const uint16_t *>(image);
        EXPECT_EQ(pixels[32 * 64 + 16] & 0x7FFF, 0x001F);
        EXPECT_EQ(pixels[32 * 64 + 48] & 0x7FFF, 0x7C00);
        EXPECT_EQ(reinterpret_cast<const uint32_t *>(values)[0], mgPortGsDepth(depth));
        mgEndFrame(nullptr);
    }
    WorkTex = nullptr;
    TakePhotoMode = TAKE_PHOTO_OFF;
}

TEST(Photo, PreviewRetainsCapturedCropAfterAspectChanges) {
    PhotoRenderer renderer(1280, 720, 4.0f / 3.0f);
    gfx::SetFrameLayout({.aspect = gfx::AspectMode::Fill, .ui_scale = 1.0f});
    mgCTexture work{};
    work.Initialize();
    work.width = work.height = 64;
    work.bpp = 16;
    work.tex0.TBP0 = 256 << 5;
    work.tex0.TBW = 1;
    work.tex0.PSM = SCE_GS_PSMCT16;
    auto      *saved_work = WorkTex;
    const auto saved_mode = TakePhotoMode;
    const auto saved_camera_texture = CameraTexb;
    const auto saved_preview_frames = ShowTakePhotoCnt;
    const auto saved_shutter_frames = ShutterAnmCnt;
    WorkTex = &work;
    CameraTexb = static_cast<unsigned int>(-1);
    TakePhotoMode = TAKE_PHOTO_SHUTTER;
    ShowTakePhotoCnt = ShutterAnmCnt = 0;
    mgBeginFrame(nullptr);
    DrawTakePhoto(nullptr, nullptr);
    mgEndFrame(nullptr);

    // The last primitive is the preview sprite, after the untextured frame.
    std::vector<gfx::Vertex2D> preview;
    mgPortSetPrimSink([&](gfx::Primitive, std::span<const gfx::Vertex2D> vertices,
                          const gfx::TextureBinding &, const gfx::DrawState &) {
        preview.assign(vertices.begin(), vertices.end());
    });
    TakePhotoMode = TAKE_PHOTO_AIM;
    ShowTakePhotoCnt = 120;
    mgBeginFrame(nullptr);
    DrawTakePhoto(nullptr, nullptr);
    mgEndFrame(nullptr);
    const auto wide_preview = preview;

    gfx::SetFrameLayout({.aspect = gfx::AspectMode::Letterbox, .ui_scale = 1.0f});
    preview.clear();
    mgBeginFrame(nullptr);
    DrawTakePhoto(nullptr, nullptr);
    mgEndFrame(nullptr);
    mgPortSetPrimSink({});
    WorkTex = saved_work;
    TakePhotoMode = saved_mode;
    CameraTexb = saved_camera_texture;
    ShowTakePhotoCnt = saved_preview_frames;
    ShutterAnmCnt = saved_shutter_frames;

    ASSERT_FALSE(wide_preview.empty());
    ASSERT_EQ(preview.size(), wide_preview.size());
    const auto [top, bottom] = std::ranges::minmax_element(wide_preview, {}, [](const auto &vertex) { return vertex.v; });
    EXPECT_GT(top->v, 0.0f);
    EXPECT_LT(bottom->v, 64.0f);
    for (size_t i = 0; i < preview.size(); ++i) {
        EXPECT_FLOAT_EQ(preview[i].u, wide_preview[i].u);
        EXPECT_FLOAT_EQ(preview[i].v, wide_preview[i].v);
        EXPECT_FLOAT_EQ(preview[i].x, wide_preview[i].x);
        EXPECT_FLOAT_EQ(preview[i].y, wide_preview[i].y);
    }
}
