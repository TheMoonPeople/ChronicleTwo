// Ahead of common.h: libgraph.h defines A, B, C and D as macros that would rewrite the vu1 header's names.
#include "common.h"

#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <cstdint>
#include <filesystem>
#include <limits>
#include <string>
#include <vector>

#include "gfx/gfx.hpp"
#include "gfx_fixture.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mglib.hpp"
#include "platform/clock.hpp"
#include "platform/window.hpp"
#include "render/renderer.hpp"
#include "vu1/water_geom.hpp"
#include "water.hpp"

// Register macros must follow the host and test headers.
// clang-format off
#include "libgraph.h"
// clang-format on

using namespace dc::test;
using namespace dc::vu1;

namespace {

WaterSurface Surface(float p1 = 2.0f) {
    return {
        .p0 = 1.0f, .p1 = p1, .colour = {128.0f, 128.0f, 128.0f, 128.0f}
    };
}

WaterStripVertex Vertex(Vec4 pos, Vec4 slope) {
    return {.pos = pos, .slope = slope};
}

// Object z is the eye depth under the identity transform. 100 keeps the fade at 1 (375 / 100 - 0.25 > 1).
WaterStripVertex FlatAt(float z) {
    return Vertex({.x = 2048.0f, .y = 2048.0f, .z = z, .w = 1.0f}, {.x = 0.0f, .y = 0.0f, .z = 0.0f, .w = 1.0f});
}

} // namespace

TEST(WaterHost, FlatGridHasNoRefraction) {
    WaterMesh mesh(1);
    mesh[0] = {FlatAt(100.0f), FlatAt(100.0f), FlatAt(100.0f), FlatAt(100.0f)};

    std::vector<WaterHostVertex> vertices;
    std::vector<uint32_t>        indices;
    WaterHostMesh(Surface(), Identity(), mesh, vertices, indices);

    ASSERT_EQ(vertices.size(), 4u);
    EXPECT_FLOAT_EQ(vertices[0].position[0], 2048.0f);
    EXPECT_FLOAT_EQ(vertices[0].position[1], 2048.0f);
    EXPECT_FLOAT_EQ(vertices[0].position[2], 100.0f);
    EXPECT_FLOAT_EQ(vertices[0].uv_offset[0], 0.0f);
    EXPECT_FLOAT_EQ(vertices[0].uv_offset[1], 0.0f);
    EXPECT_EQ(vertices[0].color[0], 128);
    EXPECT_EQ(vertices[0].color[1], 128);
    EXPECT_EQ(vertices[0].color[2], 128);
    EXPECT_EQ(vertices[0].color[3], 128);

    EXPECT_EQ(indices, (std::vector<uint32_t>{0, 1, 2, 1, 2, 3}));
}

TEST(WaterHost, SlopeScalesUvOffsetByP1AndWeightsAlpha) {
    WaterMesh mesh(1);
    mesh[0] = {FlatAt(100.0f), Vertex({.x = 2048.0f, .y = 2048.0f, .z = 100.0f, .w = 1.0f}, {.x = 0.5f, .y = -0.25f, .z = 99.0f, .w = 0.6f}),
               FlatAt(100.0f)};

    std::vector<WaterHostVertex> vertices;
    std::vector<uint32_t>        indices;
    WaterHostMesh(Surface(), Identity(), mesh, vertices, indices);

    ASSERT_EQ(vertices.size(), 3u);
    EXPECT_FLOAT_EQ(vertices[1].uv_offset[0], 1.0f);
    EXPECT_FLOAT_EQ(vertices[1].uv_offset[1], -0.5f);
    EXPECT_EQ(vertices[1].color[0], 128);
    EXPECT_EQ(vertices[1].color[3], 76);
}

TEST(WaterHost, FarAndBehindEyeVerticesFadeOut) {
    WaterMesh mesh(1);
    mesh[0] = {FlatAt(2000.0f), FlatAt(-5.0f), FlatAt(100.0f)};

    std::vector<WaterHostVertex> vertices;
    std::vector<uint32_t>        indices;
    WaterHostMesh(Surface(), Identity(), mesh, vertices, indices);

    ASSERT_EQ(vertices.size(), 3u);
    EXPECT_EQ(vertices[0].color[3], 0);
    EXPECT_EQ(vertices[1].color[3], 0);
    EXPECT_EQ(vertices[2].color[3], 128);
}

TEST(WaterHost, FadeReadsEyeDepthThroughModelToEye) {
    Mat4 model_to_eye = Identity();
    model_to_eye.q[3] = {.x = 0.0f, .y = 0.0f, .z = 1900.0f, .w = 1.0f};

    WaterMesh mesh(1);
    mesh[0] = {FlatAt(-1800.0f), FlatAt(-1800.0f), FlatAt(-1800.0f)};

    std::vector<WaterHostVertex> vertices;
    std::vector<uint32_t>        indices;
    WaterHostMesh(Surface(), model_to_eye, mesh, vertices, indices);

    ASSERT_EQ(vertices.size(), 3u);
    EXPECT_EQ(vertices[0].color[3], 128);
}

TEST(WaterHost, StripExpandsToTrianglesAndIndexesItsOwnVertices) {
    WaterMesh mesh(2);
    mesh[0] = {FlatAt(100.0f), FlatAt(100.0f), FlatAt(100.0f), FlatAt(100.0f)};
    mesh[1] = {FlatAt(100.0f), FlatAt(100.0f), FlatAt(100.0f)};

    std::vector<WaterHostVertex> vertices;
    std::vector<uint32_t>        indices;
    WaterHostMesh(Surface(), Identity(), mesh, vertices, indices);

    ASSERT_EQ(vertices.size(), 7u);
    EXPECT_EQ(indices, (std::vector<uint32_t>{0, 1, 2, 1, 2, 3, 4, 5, 6}));
}

namespace {

class PresentRenderer {
public:
    PresentRenderer(int width, int height) {
        SetEnv("VK_LAYER_VALIDATE_SYNC", "1", 0);
        WindowConfig window{.width = width, .height = height, .headless = true};
        window.vulkan = false;
        WindowInit(window);

        gfx::RendererConfig config;
        config.app_name = "Dark Chronicle water tests";
        config.logical_width = 512.0f;
        config.logical_height = 480.0f;
        config.display_aspect = 4.0f / 3.0f;
        config.validation = true;
        config.offscreen = true;
        config.pipeline_cache = std::filesystem::temp_directory_path() / "dc_gfx_test" /
                                ("water_" + std::to_string(ProcessId()) + ".bin");
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

// The plane sits at 100 so the surface's fade is 1: 375 / w - 0.25 reaches 1 at w = 375.
constexpr float kEyeDistance = 512.0f;
constexpr float kNear = 10.0f;
constexpr float kFar = 1000.0f;
constexpr float kPlaneZ = 100.0f;
// Edge weights taper over the outer three cells, so the grid extends past the screen and the screen
// sits in the full-weight interior.
constexpr int   kRows = 16;
constexpr int   kColumns = 16;
constexpr float kExtent = 150.0f;
// A height that falls by this much per row gives a slope of -kRamp along x, a shift of -2 * kRamp pixels.
constexpr float kRamp = 8.0f;

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

bool IsRed(const uint8_t *p) {
    return p[0] >= 200 && p[1] <= 60 && p[2] <= 60;
}

bool IsBlue(const uint8_t *p) {
    return p[2] >= 200 && p[0] <= 60 && p[1] <= 60;
}

Pixels RenderScene(float ramp, uint8_t tint = 0x80) {
    mgSetRenderInfo(kEyeDistance, kNear, kFar);
    float view[4][4] = {
        {1.0f, 0.0f, 0.0f, 0.0f},
        {0.0f, 1.0f, 0.0f, 0.0f},
        {0.0f, 0.0f, 1.0f, 0.0f},
        {0.0f, 0.0f, 0.0f, 1.0f}
    };
    float origin[3] = {0.0f, 0.0f, 0.0f};
    mgSetViewMatrix(view, origin);

    mgCFrameAttr attr{};
    attr.z_write = MG_ZBUF_NO_WRITE;
    attr.z_test = MG_DEPTH_TEST_GEQUAL;
    attr.alpha_test = -1;
    attr.alpha_blend = MG_ALPHA_MACRO_BLEND;
    mgCFrameAttr *previous_attr = mgRenderInfo.attr;
    mgRenderInfo.attr = &attr;

    mgBeginFrame(nullptr);

    std::vector<gfx::Vertex2D> background;
    const auto                 stripe = [&](float x0, float x1, uint8_t r, uint8_t g, uint8_t b) {
        const float corners[4][2] = {
            {x0, 0.0f  },
            {x1, 0.0f  },
            {x1, 480.0f},
            {x0, 480.0f}
        };
        for (const auto &corner : corners) {
            gfx::Vertex2D vertex{};
            vertex.x = corner[0];
            vertex.y = corner[1];
            vertex.z = 0.5f;
            vertex.color[0] = r;
            vertex.color[1] = g;
            vertex.color[2] = b;
            vertex.color[3] = 0xFF;
            background.push_back(vertex);
        }
    };
    stripe(0.0f, 256.0f, 0xFF, 0x00, 0x00);
    stripe(256.0f, 512.0f, 0x00, 0x00, 0xFF);

    gfx::DrawState background_state = mgPortDrawState();
    background_state.depth_test = gfx::DepthTest::Always;
    background_state.depth_write = false;
    background_state.blend = false;
    background_state.alpha_test = false;
    background_state.cull = gfx::CullMode::None;
    mgPortDraw2D(gfx::Primitive::Quads, background, gfx::TextureBinding{}, background_state);

    CWater water;
    water.SetParam(0.15f, 0.0045f, 1.0f, 2.0f);
    water.SetColor(tint, tint, tint, 0x80);
    constexpr auto         grid_cells = static_cast<std::size_t>(kRows) * static_cast<std::size_t>(kColumns);
    std::vector<u_long128> grid_storage((grid_cells * sizeof(float) + 15) / 16 * 2 + 2);
    mgCMemory              grid_memory;
    grid_memory.stSetBuffer(grid_storage.data(), static_cast<int>(grid_storage.size()));
    if (!water.SetSize(kRows, kColumns, &grid_memory)) {
        ADD_FAILURE() << "Could not allocate the water fixture's height grids";
        return {};
    }

    std::vector<float> heights(static_cast<size_t>(kRows * kColumns));
    for (int row = 0; row < kRows; ++row) {
        for (int column = 0; column < kColumns; ++column) {
            heights[static_cast<size_t>(row * kColumns + column)] = ramp * static_cast<float>(row);
        }
    }
    std::ranges::copy(heights, water.Heights().begin());

    water.min[0] = -kExtent;
    water.min[1] = 0.0f;
    water.min[2] = -kExtent;
    water.min[3] = 0.0f;
    water.max[0] = kExtent;
    water.max[1] = 0.0f;
    water.max[2] = kExtent;
    water.max[3] = 0.0f;

    // Object x runs along world x, object z along world y, and the surface lies at kPlaneZ.
    float model[4][4] = {
        {1.0f, 0.0f, 0.0f,    0.0f},
        {0.0f, 0.0f, 1.0f,    0.0f},
        {0.0f, 1.0f, 0.0f,    0.0f},
        {0.0f, 0.0f, kPlaneZ, 1.0f}
    };
    water.Draw(nullptr, model, nullptr);

    mgEndFrame(nullptr);
    mgRenderInfo.attr = previous_attr;

    Pixels pixels;
    EXPECT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, pixels.rgba, pixels.width, pixels.height));
    pixels.mapping = gfx::GetLogicalMapping(gfx::kMainTarget);
    return pixels;
}

} // namespace

TEST(Water, FlatWaterShowsFrameBehindIt) {
    PresentRenderer renderer(640, 480);

    const Pixels flat = RenderScene(0.0f);
    ASSERT_FALSE(flat.rgba.empty());

    EXPECT_TRUE(IsRed(flat.At(128.0f, 240.0f)));
    EXPECT_TRUE(IsBlue(flat.At(384.0f, 240.0f)));
    EXPECT_TRUE(IsRed(flat.At(248.0f, 240.0f)));
    EXPECT_TRUE(IsBlue(flat.At(264.0f, 240.0f)));

    // Half-bright tint: the background alone would read 255, so this proves the surface was drawn.
    const Pixels tinted = RenderScene(0.0f, 0x40);
    ASSERT_FALSE(tinted.rgba.empty());
    const uint8_t *left = tinted.At(128.0f, 240.0f);
    EXPECT_NEAR(left[0], 128, 12);
    EXPECT_LE(left[1], 12);
    EXPECT_LE(left[2], 12);
}

TEST(Water, SlopeShiftsRefractedEdge) {
    PresentRenderer renderer(640, 480);

    const Pixels sloped = RenderScene(kRamp);
    ASSERT_FALSE(sloped.rgba.empty());

    EXPECT_TRUE(IsRed(sloped.At(264.0f, 240.0f)));
    EXPECT_TRUE(IsBlue(sloped.At(384.0f, 240.0f)));
}

TEST(WaterHost, ReusesGridStorageAndReplacesEarlierGeometry) {
    WaterMeshDesc desc{
        .min = {.x = 0, .y = 0, .z = 0, .w = 1},
        .max = {.x = 4, .y = 0, .z = 4, .w = 1},
        .rows = 4,
        .columns = 4
    };
    std::vector<float> heights(16, 0.0f);
    WaterMesh          mesh;
    BuildWaterMesh(desc, heights, mesh);
    ASSERT_EQ(mesh.size(), 3u);
    const auto *storage = mesh[0].data();
    const auto  capacity = mesh[0].capacity();
    heights[1] = 2;
    BuildWaterMesh(desc, heights, mesh);
    EXPECT_EQ(mesh[0].data(), storage);
    EXPECT_EQ(mesh[0].capacity(), capacity);
    EXPECT_EQ(mesh[0].size(), 8u);
    EXPECT_FLOAT_EQ(mesh[0][0].slope.y, -2.0f);
    desc.rows = 2;
    BuildWaterMesh(desc, heights, mesh);
    EXPECT_EQ(mesh.size(), 1u);
    desc.rows = 1;
    BuildWaterMesh(desc, heights, mesh);
    EXPECT_TRUE(mesh.empty());
}

TEST(WaterMemory, MissingAndInvalidGridsNeverReachHeightWrites) {
    CWater water;
    EXPECT_FALSE(water.SetSize(3, 3, nullptr));
    mgCMemory empty;
    EXPECT_FALSE(water.SetSize(3, 3, &empty));
    EXPECT_FALSE(water.SetSize(-1, 3, &empty));
    EXPECT_FALSE(water.SetSize(1, 3, &empty));
    EXPECT_TRUE(water.Heights().empty());
    water.Shake(std::numeric_limits<int>::min(), std::numeric_limits<int>::max(), 1.0f);
    water.Hamon();
}

TEST(WaterMemory, ExactGridLeasesRejectResetAndSameAddressReuse) {
    std::vector<u_long128> backing(128);
    mgCMemory              memory;
    memory.stSetBuffer(backing.data(), static_cast<int>(backing.size()));
    CWater old;
    ASSERT_TRUE(old.SetSize(3, 4, &memory));
    auto *address = old.Heights().data();
    ASSERT_EQ(old.Heights().size(), 12U);
    old.Shake(1, 2, 3.5f);
    EXPECT_FLOAT_EQ(old.Heights()[6], 3.5f);
    old.Hamon();
    EXPECT_GT(old.Heights()[6], 0.0f);
    memory.stReset();
    EXPECT_TRUE(old.Heights().empty());
    CWater replacement;
    ASSERT_TRUE(replacement.SetSize(3, 4, &memory));
    ASSERT_EQ(replacement.Heights().data(), address);
    std::ranges::fill(replacement.Heights(), 7.0f);
    old.Shake(1, 2, 100.0f);
    old.Hamon();
    EXPECT_TRUE(std::ranges::all_of(replacement.Heights(), [](float value) { return value == 7.0f; }));
}

TEST(WaterMemory, FailedResizesPreserveTheLiveGridAndDoNotWrapProducts) {
    std::vector<u_long128> backing(64);
    mgCMemory              memory;
    memory.stSetBuffer(backing.data(), static_cast<int>(backing.size()));
    CWater water;
    ASSERT_TRUE(water.SetSize(3, 3, &memory));
    auto      *address = water.Heights().data();
    const auto used = memory.stGetUsed();
    memory.stSetLocked(true);
    EXPECT_FALSE(water.SetSize(4, 4, &memory));
    memory.stSetLocked(false);
    EXPECT_FALSE(water.SetSize(std::numeric_limits<int>::max(), std::numeric_limits<int>::max(), &memory));
    EXPECT_EQ(water.Heights().data(), address);
    EXPECT_EQ(water.Heights().size(), 9U);
    EXPECT_EQ(memory.stGetUsed(), used);
}

TEST(WaterMemory, FrameCreationRejectsMissingStorageAndDegenerateGridSizes) {
    float corner[4]{};
    EXPECT_EQ(CreateWaterFrame(3, 3, corner, corner, nullptr), nullptr);
    mgCMemory empty;
    EXPECT_EQ(CreateWaterFrame(3, 3, corner, corner, &empty), nullptr);
    EXPECT_EQ(CreateWaterFrame(1, 3, corner, corner, &empty), nullptr);
    CWaterFrame frame;
    frame.Shake(0.0f, 0.0f, 1.0f);
    EXPECT_EQ(frame.GetWater(), nullptr);
}
