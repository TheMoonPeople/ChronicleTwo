// Ahead of common.h: libgraph.h defines A, B, C and D as macros that would expand SdwPath's enumerators.
#include "common.h"

#include <gtest/gtest.h>

#include <algorithm>
#include <cstdint>
#include <filesystem>
#include <limits>
#include <string>
#include <vector>

#include "gfx/gfx.hpp"
#include "gfx_fixture.hpp"
#include "mg_drawprim.hpp"
#include "mg_shadow.hpp"
#include "mglib.hpp"
#include "platform/clock.hpp"
#include "platform/window.hpp"
#include "render/renderer.hpp"
#include "render/shadow_mesh.hpp"
#include "vu1/sdw_geom.hpp"

// Register macros must follow the host and test headers.
// clang-format off
#include "libgraph.h"
// clang-format on

using namespace dc::test;
using dc::vu1::Cross3;
using dc::vu1::Dot3;
using dc::vu1::SdwPrism;
using dc::vu1::SdwPrismTriangle;
using dc::vu1::Vec4;

namespace {

class PresentRenderer {
public:
    PresentRenderer(int width, int height) {
        SetEnv("VK_LAYER_VALIDATE_SYNC", "1", 0);
        WindowConfig window{.width = width, .height = height, .headless = true};
        window.vulkan = false;
        WindowInit(window);

        gfx::RendererConfig config;
        config.app_name = "Dark Chronicle shadow tests";
        config.logical_width = 512.0f;
        config.logical_height = 480.0f;
        config.display_aspect = 4.0f / 3.0f;
        config.validation = true;
        config.offscreen = true;
        config.pipeline_cache = std::filesystem::temp_directory_path() / "dc_gfx_test" /
                                ("mg_shadow_" + std::to_string(ProcessId()) + ".bin");
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

Vec4 P(float x, float y, float z) {
    return {.x = x, .y = y, .z = z, .w = 1.0f};
}

Vec4 Average(const std::vector<Vec4> &points) {
    Vec4 sum{.x = 0.0f, .y = 0.0f, .z = 0.0f, .w = 0.0f};
    for (const Vec4 &p : points) {
        sum = sum + p;
    }
    return sum * (1.0f / static_cast<float>(points.size()));
}

void ExpectOutward(const std::vector<SdwPrismTriangle> &tris, const std::vector<Vec4> &corners) {
    ASSERT_EQ(tris.size(), 8u);
    const Vec4 centre = Average(corners);
    for (size_t i = 0; i < tris.size(); ++i) {
        const Vec4 &a = tris[i].v[0];
        const Vec4 &b = tris[i].v[1];
        const Vec4 &c = tris[i].v[2];
        const Vec4  normal = Cross3(b - a, c - a);
        const Vec4  centroid = (a + b + c) * (1.0f / 3.0f);
        EXPECT_GT(Dot3(normal, centroid - centre), 0.0f) << "triangle " << i;
    }
}

const Vec4 kTop[3] = {P(0, 0, 0), P(1, 0, 0), P(0, 1, 0)};
const Vec4 kDropBelow[3] = {P(0, 0, -1), P(1, 0, -1), P(0, 1, -1)};
const Vec4 kDropAbove[3] = {P(0, 0, 1), P(1, 0, 1), P(0, 1, 1)};

const float kIdentity[16] = {1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f, 0.0f, 0.0f,
                             0.0f, 0.0f, 1.0f, 0.0f, 0.0f, 0.0f, 0.0f, 1.0f};

} // namespace

TEST(MgShadowPrism, DropBelowIsOutwardWound) {
    std::vector<SdwPrismTriangle> tris;
    SdwPrism(kTop, kDropBelow, tris);
    ExpectOutward(tris, {kTop[0], kTop[1], kTop[2], kDropBelow[0], kDropBelow[1], kDropBelow[2]});
}

TEST(MgShadowPrism, DropAboveIsOutwardWound) {
    std::vector<SdwPrismTriangle> tris;
    SdwPrism(kTop, kDropAbove, tris);
    ExpectOutward(tris, {kTop[0], kTop[1], kTop[2], kDropAbove[0], kDropAbove[1], kDropAbove[2]});
}

TEST(MgShadowPrism, ReversedTriangleStaysOutwardWound) {
    const Vec4                    top[3] = {kTop[2], kTop[1], kTop[0]};
    const Vec4                    drop[3] = {kDropBelow[2], kDropBelow[1], kDropBelow[0]};
    std::vector<SdwPrismTriangle> tris;
    SdwPrism(top, drop, tris);
    ExpectOutward(tris, {kTop[0], kTop[1], kTop[2], kDropBelow[0], kDropBelow[1], kDropBelow[2]});
}

TEST(MgShadowPrism, DegenerateInputsAppendNothing) {
    std::vector<SdwPrismTriangle> tris;

    SdwPrism(kTop, kTop, tris);
    EXPECT_TRUE(tris.empty());

    const Vec4 flat[3] = {P(0, 0, 0), P(1, 0, 0), P(2, 0, 0)};
    SdwPrism(flat, kDropBelow, tris);
    EXPECT_TRUE(tris.empty());

    const Vec4 bad[3] = {P(0, 0, 0), P(std::numeric_limits<float>::quiet_NaN(), 0, 0), P(0, 1, 0)};
    SdwPrism(bad, kDropBelow, tris);
    EXPECT_TRUE(tris.empty());
}

namespace {

// Units: centre and half are multiples of the footprint, where a caster of half 1 projects to 100
// pixels on the plane. top is a multiple of the plane depth, so a negative top puts the caster
// behind the eye.
struct Caster {
    float centre;
    float top;
    float half;
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

Pixels RenderGroundUnder(const std::vector<Caster> &casters) {
    const float kEyeDistance = 512.0f;
    const float kNear = 10.0f;
    const float kFar = 1000.0f;
    mgSetRenderInfo(kEyeDistance, kNear, kFar);

    float view[4][4] = {
        {1.0f, 0.0f, 0.0f, 0.0f},
        {0.0f, 1.0f, 0.0f, 0.0f},
        {0.0f, 0.0f, 1.0f, 0.0f},
        {0.0f, 0.0f, 0.0f, 1.0f}
    };
    float origin[3] = {0.0f, 0.0f, 0.0f};
    mgSetViewMatrix(view, origin);

    const float near_z = mgRenderInfo.clip_min[2];
    const float far_z = mgRenderInfo.clip_max[2];
    const float plane_z = 0.5f * (near_z + far_z);
    const float eye_distance = mgRenderInfo.projection;

    // The light is along the view axis, so a drop keeps the caster's x and y.
    const float footprint_half = 100.0f * plane_z / eye_distance;
    const float ground_half = 4.0f * 512.0f * plane_z / eye_distance;

    const uint8_t grey[4] = {128, 128, 128, 255};
    const float   ground_xy[4][2] = {
        {-ground_half, -ground_half},
        {ground_half,  -ground_half},
        {ground_half,  ground_half },
        {-ground_half, ground_half }
    };
    std::vector<gfx::Vertex3D> ground_vertices;
    for (const auto &xy : ground_xy) {
        gfx::Vertex3D vertex{};
        vertex.position[0] = xy[0];
        vertex.position[1] = xy[1];
        vertex.position[2] = plane_z;
        std::copy(grey, grey + 4, vertex.color);
        ground_vertices.push_back(vertex);
    }
    const uint32_t ground_indices[6] = {0, 1, 2, 0, 2, 3};

    mgBeginFrame(nullptr);

    gfx::MeshConstants ground_constants{};
    mgPortWorldToClip(ground_constants.mvp);
    ground_constants.flags = gfx::kMeshVertexColor;
    for (float &channel : ground_constants.diffuse) {
        channel = 1.0f;
    }
    gfx::DrawState ground_state = mgPortDrawState();
    ground_state.depth_test = gfx::DepthTest::Always;
    ground_state.depth_write = true;
    ground_state.alpha_test = false;
    ground_state.blend = false;
    ground_state.cull = gfx::CullMode::None;
    const gfx::MeshTransform ground_transform = mgPortMeshTransform(kIdentity);
    mgPortDrawMeshImmediate(ground_vertices, ground_indices, ground_constants, gfx::TextureBinding{},
                            ground_state, &ground_transform);

    mgCTexture shadow_texture{};
    shadow_texture.width = 512;
    shadow_texture.height = 480;
    shadow_texture.tex0.TBP0 = 0x3000;
    shadow_texture.tex0.PSM = SCE_GS_PSMCT32;
    mgBeginDrawShadow(&shadow_texture, nullptr);

    float light[3] = {0.0f, 0.0f, 1.0f};
    float plane_pos[3] = {0.0f, 0.0f, plane_z};
    float plane_normal[3] = {0.0f, 0.0f, -1.0f};
    mgSetDropShadowMatrix(light, plane_pos, plane_normal);

    float identity[4][4] = {
        {1.0f, 0.0f, 0.0f, 0.0f},
        {0.0f, 1.0f, 0.0f, 0.0f},
        {0.0f, 0.0f, 1.0f, 0.0f},
        {0.0f, 0.0f, 0.0f, 1.0f}
    };
    for (const Caster &c : casters) {
        const float   centre = c.centre * footprint_half;
        const float   half = c.half * footprint_half;
        const float   z = c.top * plane_z;
        sceVu0FVECTOR caster[4] = {
            {centre - half, -half, z, 1.0f},
            {centre + half, -half, z, 1.0f},
            {centre + half, half,  z, 1.0f},
            {centre - half, half,  z, 1.0f},
        };
        int caster_indices[6] = {0, 1, 2, 0, 2, 3};

        mgCFace face{};
        face.type = MG_PRIM_TRIANGLE;
        face.index_stride = 3;
        face.vertex_num = 2;
        face.index_num = 6;
        face.index = caster_indices;

        mgFACE_GROUP group{};
        group.face = &face;
        group.vu_program = 1;

        mgCShadowMDT shadow;
        shadow.vertex = caster;
        shadow.vertex_num = 4;
        shadow.face_group = &group;
        shadow.draw_env = nullptr;

        u_int buffer[4] = {};
        shadow.CreateRenderInfoPacket(buffer, identity, &mgRenderInfo);
    }

    mgEndDrawShadow(&shadow_texture, nullptr);
    mgEndFrame(nullptr);

    Pixels pixels;
    EXPECT_TRUE(mgPortCanonicalReadColor(gfx::kMainTarget, pixels.rgba, pixels.width, pixels.height));
    pixels.mapping = gfx::GetLogicalMapping(gfx::kMainTarget);
    return pixels;
}

} // namespace

TEST(MgShadow, QuadOverPlaneDarkensFootprint) {
    PresentRenderer renderer(640, 480);

    const Pixels pixels = RenderGroundUnder({
        {.centre = 0.0f, .top = 0.5f, .half = 1.0f}
    });

    const uint8_t *inside = pixels.At(256.0f, 240.0f);
    const uint8_t *outside = pixels.At(50.0f, 50.0f);
    EXPECT_NEAR(outside[0], 128, 2);
    EXPECT_NEAR(outside[1], 128, 2);
    EXPECT_NEAR(outside[2], 128, 2);
    EXPECT_LT(inside[0] + 40, outside[0]);
}

TEST(MgShadow, OverlappingCastersShadeTheirUnionNotTheirSum) {
    PresentRenderer renderer(640, 480);

    const Pixels single = RenderGroundUnder({
        {.centre = 0.0f, .top = 0.5f, .half = 1.0f}
    });
    const Pixels doubled = RenderGroundUnder({
        {.centre = 0.0f, .top = 0.5f, .half = 1.0f},
        {.centre = 0.5f, .top = 0.5f, .half = 1.0f}
    });

    const uint8_t single_inside = single.At(256.0f, 240.0f)[0];
    const uint8_t doubled_inside = doubled.At(256.0f, 240.0f)[0];
    EXPECT_NEAR(doubled_inside, single_inside, 2);
    EXPECT_LT(doubled_inside + 40, doubled.At(50.0f, 50.0f)[0]);
}

TEST(MgShadow, SecondCasterKeepsItsOwnFootprint) {
    PresentRenderer renderer(640, 480);

    // The first caster spans -1..1 footprints and the second 0.5..2.5. Pixel x = 406 is 1.5
    // footprints from the centre, under the second caster alone; the first caster's counts must not
    // have consumed it.
    const Pixels pixels = RenderGroundUnder({
        {.centre = 0.0f, .top = 0.5f, .half = 1.0f},
        {.centre = 1.5f, .top = 0.5f, .half = 1.0f}
    });

    EXPECT_LT(pixels.At(406.0f, 240.0f)[0] + 40, pixels.At(50.0f, 50.0f)[0]);
}

TEST(MgShadow, CasterBehindTheNearPlaneCastsNoShadow) {
    PresentRenderer renderer(640, 480);

    // Top at -0.2 plane depths: a corner is behind the eye, so retail rejects the caster and the
    // eye's volume is never counted.
    const Pixels pixels = RenderGroundUnder({
        {.centre = 0.0f, .top = -0.2f, .half = 1.0f}
    });

    const uint8_t *inside = pixels.At(256.0f, 240.0f);
    const uint8_t *outside = pixels.At(50.0f, 50.0f);
    EXPECT_NEAR(inside[0], outside[0], 2);
    EXPECT_NEAR(outside[0], 128, 2);
}

namespace {

mgPortProjection TestProjection() {
    mgPortProjection projection;
    projection.eye = 512.0f;
    projection.near_z = 10.0f;
    projection.far_z = 1000.0f;
    projection.aspect_y = 1.0f;
    projection.width = 512.0f;
    projection.height = 480.0f;
    return projection;
}

// A unit right triangle in the plane z = depth, dropped by `offset`.
std::vector<SdwPrismTriangle> PrismFor(float depth, const Vec4 &offset, const Vec4 &bias_dir = {.x = 0.0f, .y = 1.0f, .z = 0.0f, .w = 0.0f},
                                       float x_scale = 1.0f) {
    const Vec4                    top[3] = {P(0, 0, depth), P(x_scale, 0, depth), P(0, 1, depth)};
    const Vec4                    drop[3] = {top[0] + offset, top[1] + offset, top[2] + offset};
    std::vector<SdwPrismTriangle> tris;
    AppendShadowPrism(top, drop, bias_dir, TestProjection(), tris);
    return tris;
}

} // namespace

TEST(MgShadowReject, NormalCasterIsKept) {
    EXPECT_EQ(PrismFor(100.0f, P(0, 0, -50)).size(), 8u);
}

TEST(MgShadowReject, CornerBehindNearPlaneIsRejected) {
    EXPECT_TRUE(PrismFor(5.0f, P(0, 0, -2)).empty());
}

TEST(MgShadowReject, DropBehindNearPlaneIsRejected) {
    EXPECT_TRUE(PrismFor(100.0f, P(0, 0, -95)).empty());
}

TEST(MgShadowReject, CornerBeyondFarPlaneIsRejected) {
    EXPECT_TRUE(PrismFor(100.0f, P(0, 0, 1000)).empty());
}

TEST(MgShadowReject, CornerBeyondXGuardBandIsRejected) {
    // 3000 * 512 / 100 is far past the 2048 half-range.
    EXPECT_TRUE(PrismFor(100.0f, P(0, 0, -50), {0.0f, 1.0f, 0.0f, 0.0f}, 3000.0f).empty());
}

TEST(MgShadowReject, CornerBeyondYGuardBandIsRejected) {
    // 4000 * 512 / 100 is far past the 2048 half-range.
    const Vec4                    top[3] = {P(0, 0, 100), P(1, 0, 100), P(0, 4000, 100)};
    const Vec4                    drop[3] = {P(0, 0, 50), P(1, 0, 50), P(0, 4000, 50)};
    std::vector<SdwPrismTriangle> tris;
    AppendShadowPrism(top, drop, {.x = 0.0f, .y = 1.0f, .z = 0.0f, .w = 0.0f}, TestProjection(), tris);
    EXPECT_TRUE(tris.empty());
}

TEST(MgShadowReject, GrazingTriangleIsRejected) {
    // The drop slides along the triangle's own plane, so the prism has no thickness.
    EXPECT_TRUE(PrismFor(100.0f, P(5, 0, 0)).empty());
}

TEST(MgShadowReject, NaNCornerIsRejected) {
    EXPECT_TRUE(PrismFor(100.0f, P(0, 0, std::numeric_limits<float>::quiet_NaN())).empty());
}

namespace {

struct ShadowMeshFixture {
    sceVu0FVECTOR points[6] = {
        {-1, -1, 100, 1},
        {1,  -1, 100, 1},
        {1,  1,  100, 1},
        {-1, 1,  100, 1},
        {-1, -1, 100, 1},
        {1,  1,  100, 1}
    };
    std::vector<int>           corners = {0, 1, 2, 0, 2, 3};
    mgCFace                    face{};
    mgFACE_GROUP               group{};
    mgCShadowMDT               visual;
    mgRENDER_INFO              info{};
    sceVu0FMATRIX              model{};
    std::vector<gfx::Vertex3D> vertices;
    std::vector<uint32_t>      indices;

    ShadowMeshFixture() {
        sceVu0UnitMatrix(model);
        sceVu0UnitMatrix(info.view);
        sceVu0UnitMatrix(info.shadow);
        info.shadow[2][2] = 0;
        info.shadow[3][2] = 50;
        info.shadow_light_dir[2] = -1;
        group.face = &face;
        visual.vertex = points;
        visual.vertex_num = 6;
        visual.face_group = &group;
    }

    void Build() {
        face.index = corners.data();
        face.vertex_num = static_cast<short>(corners.size() / 3);
        mgShadowPortBuildMesh(visual, model, info, TestProjection(), vertices, indices);
    }
};

} // namespace

TEST(MgShadowMesh, WeldsSharedEdgesAndKeepsSixVerticesPerPrism) {
    ShadowMeshFixture mesh;
    mesh.Build();
    EXPECT_EQ(mesh.vertices.size(), 12u);
    EXPECT_EQ(mesh.indices.size(), 36u);
    mesh.corners = {0, 1, 2, 4, 5, 3};
    mesh.Build();
    EXPECT_EQ(mesh.indices.size(), 36u);
    const auto capacity = mesh.vertices.capacity();
    mesh.Build();
    EXPECT_EQ(mesh.vertices.capacity(), capacity);
    EXPECT_EQ(mesh.indices.size(), 36u);
}

TEST(MgShadowMesh, KeepsOverlapsAndAmbiguousEdgesAndRefreshesReusedGeometry) {
    ShadowMeshFixture mesh;
    mesh.corners = {0, 1, 2, 0, 1, 2};
    mesh.Build();
    EXPECT_EQ(mesh.indices.size(), 48u);
    mesh.corners = {0, 1, 2, 0, 2, 3, 0, 2, 3};
    mesh.Build();
    EXPECT_EQ(mesh.indices.size(), 72u);
    mesh.corners = {0, 1, 2, 4, 5, 3};
    mesh.points[4][0] = -2;
    mesh.Build();
    EXPECT_EQ(mesh.indices.size(), 48u);
}

TEST(MgShadowMesh, RetainsTheSideBesideAClippedTriangle) {
    ShadowMeshFixture mesh;
    mesh.points[3][2] = 1;
    mesh.Build();
    EXPECT_EQ(mesh.vertices.size(), 6u);
    EXPECT_EQ(mesh.indices.size(), 24u);
    for (auto &point : mesh.points) {
        point[2] = 1;
    }
    mesh.Build();
    EXPECT_TRUE(mesh.vertices.empty());
    EXPECT_TRUE(mesh.indices.empty());
}
