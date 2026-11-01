// Ahead of common.h: libgraph.h defines A, B, C and D as macros that would expand SdwPath's enumerators.
#include "common.h"

#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <bit>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <filesystem>
#include <limits>
#include <optional>
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

/**
 * Restores the calling thread's shadow transform policy after a comparison render.
 */
class ShadowTransformScope {
    dc2::render::ShadowTransformMode previous;

public:
    explicit ShadowTransformScope(dc2::render::ShadowTransformMode mode)
        : previous(dc2::render::SetShadowTransformMode(mode)) {}

    ~ShadowTransformScope() { dc2::render::SetShadowTransformMode(previous); }

    ShadowTransformScope(const ShadowTransformScope &) = delete;
    ShadowTransformScope &operator=(const ShadowTransformScope &) = delete;
};

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

Pixels RenderGroundUnder(const std::vector<Caster> &casters, float animation = 0) {
    const float kEyeDistance = 512.0f;
    const float kNear = 10.0f;
    const float kFar = 1000.0f;
    mgSetRenderInfo(kEyeDistance * (1.0f + animation * 0.08f), kNear, kFar);

    float view[4][4] = {
        {1.0f, 0.0f, 0.0f, 0.0f},
        {0.0f, 1.0f, 0.0f, 0.0f},
        {0.0f, 0.0f, 1.0f, 0.0f},
        {0.0f, 0.0f, 0.0f, 1.0f}
    };
    view[3][0] = animation * 4.0f;
    view[3][1] = animation * 3.0f;
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

    float light[3] = {animation * 0.05f, animation * 0.025f, 1.0f};
    float plane_pos[3] = {0.0f, 0.0f, plane_z};
    float plane_normal[3] = {0.0f, 0.0f, -1.0f};
    mgSetDropShadowMatrix(light, plane_pos, plane_normal);

    float identity[4][4] = {
        {1.0f, 0.0f, 0.0f, 0.0f},
        {0.0f, 1.0f, 0.0f, 0.0f},
        {0.0f, 0.0f, 1.0f, 0.0f},
        {0.0f, 0.0f, 0.0f, 1.0f}
    };
    const float angle = animation * 0.1f;
    identity[0][0] = identity[1][1] = std::cos(angle);
    identity[0][1] = std::sin(angle);
    identity[1][0] = animation == 0 ? 0.0f : -std::sin(angle);
    identity[3][0] = animation * footprint_half * 0.15f;
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

    void Build(const mgPortProjection &projection = TestProjection()) {
        face.index = corners.data();
        face.vertex_num = static_cast<short>(corners.size() / 3);
        mgShadowPortBuildMesh(visual, model, info, projection, vertices, indices);
    }
};

dc2::render::ShadowMeshStats ExpectMemoMatchesReference(ShadowMeshFixture      &mesh,
                                                        const mgPortProjection &projection = TestProjection(),
                                                        bool                    nonempty = true) {
    using Mode = dc2::render::ShadowTransformMode;
    const auto before_reference = dc2::render::GetShadowMeshStats();
    {
        ShadowTransformScope mode(Mode::Reference);
        mesh.Build(projection);
    }
    const auto after_reference = dc2::render::GetShadowMeshStats();
    const auto reference_vertices = mesh.vertices;
    const auto reference_indices = mesh.indices;
    if (nonempty) {
        EXPECT_FALSE(reference_vertices.empty());
        EXPECT_FALSE(reference_indices.empty());
    }
    {
        ShadowTransformScope mode(Mode::Memoized);
        mesh.Build(projection);
    }
    const auto after_memo = dc2::render::GetShadowMeshStats();
    EXPECT_EQ(after_reference.draws - before_reference.draws, 1u);
    EXPECT_EQ(after_reference.reference_draws - before_reference.reference_draws, 1u);
    EXPECT_LE(after_reference.transformed_positions - before_reference.transformed_positions,
              after_reference.source_corners - before_reference.source_corners);
    EXPECT_EQ(after_memo.draws - after_reference.draws, 1u);
    EXPECT_EQ(after_memo.memoized_draws - after_reference.memoized_draws, 1u);
    EXPECT_LE(after_memo.transformed_positions - after_reference.transformed_positions,
              after_memo.source_corners - after_reference.source_corners);
    EXPECT_EQ(mesh.indices, reference_indices);
    EXPECT_EQ(mesh.vertices.size(), reference_vertices.size());
    if (mesh.vertices.size() == reference_vertices.size() && !mesh.vertices.empty()) {
        EXPECT_EQ(std::memcmp(mesh.vertices.data(), reference_vertices.data(),
                              mesh.vertices.size() * sizeof(gfx::Vertex3D)),
                  0);
    }
    return {.draws = after_memo.draws - after_reference.draws,
            .memoized_draws = after_memo.memoized_draws - after_reference.memoized_draws,
            .reference_draws = after_memo.reference_draws - after_reference.reference_draws,
            .source_corners = after_memo.source_corners - after_reference.source_corners,
            .transformed_positions = after_memo.transformed_positions - after_reference.transformed_positions,
            .topology_hits = after_memo.topology_hits - after_reference.topology_hits,
            .topology_rebuilds = after_memo.topology_rebuilds - after_reference.topology_rebuilds};
}

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

TEST(MgShadowMesh, MemoizedTransformsMatchReferenceAcrossSeamsWindingAndAmbiguousEdges) {
    ShadowMeshFixture mesh;
    const auto        stats = ExpectMemoMatchesReference(mesh);
    EXPECT_EQ(stats.source_corners, 6u);
    EXPECT_EQ(stats.transformed_positions, 4u);
    EXPECT_EQ(stats.topology_hits, 1u);
    for (const std::vector<int> &corners : {
             std::vector{0, 1, 2, 4, 5, 3},
             std::vector{2, 1, 0, 3, 2, 0},
             std::vector{0, 1, 2, 0, 1, 2},
             std::vector{0, 1, 2, 0, 2, 3, 0, 2, 3}
    }) {
        mesh.corners = corners;
        ExpectMemoMatchesReference(mesh);
    }

    const sceVu0FVECTOR zero_points[6] = {
        {0.0f,  -1, 100, 1},
        {1,     1,  100, 1},
        {-1,    1,  100, 1},
        {-0.0f, -1, 100, 1},
        {1,     1,  100, 1},
        {-1,    1,  100, 1},
    };
    std::memcpy(mesh.points, zero_points, sizeof zero_points);
    mesh.corners = {0, 1, 2, 3, 4, 5};
    const auto zero_stats = ExpectMemoMatchesReference(mesh);
    EXPECT_EQ(zero_stats.source_corners, 6u);
    EXPECT_EQ(zero_stats.transformed_positions, 4u); // Raw signed zeros remain distinct transform keys.
}

TEST(MgShadowMesh, MemoizedTransformsMatchReferenceAtClippingAndNonfiniteBoundaries) {
    for (int scenario = 0; scenario < 7; ++scenario) {
        SCOPED_TRACE(scenario);
        ShadowMeshFixture mesh;
        if (scenario == 0) {
            mesh.points[3][2] = 1;
        } else if (scenario == 1) {
            mesh.points[3][2] = 1200;
        } else if (scenario == 2) {
            mesh.points[3][0] = 5000;
        } else if (scenario == 3) {
            mesh.points[3][1] = 5000;
        } else if (scenario == 4) {
            mesh.points[0][0] = std::numeric_limits<float>::quiet_NaN();
        } else if (scenario == 5) {
            mesh.points[0][1] = std::numeric_limits<float>::infinity();
        } else {
            mesh.corners = {0, 0, 0};
        }
        ExpectMemoMatchesReference(mesh, TestProjection(), scenario < 4);
        if (scenario >= 4) {
            EXPECT_TRUE(mesh.vertices.empty());
            EXPECT_TRUE(mesh.indices.empty());
        }
    }
    for (float z : {10.0f, 1000.0f}) {
        ShadowMeshFixture mesh;
        for (auto &point : mesh.points) {
            point[2] = z;
        }
        ExpectMemoMatchesReference(mesh);
    }
}

TEST(MgShadowMesh, RepeatedRawZeroAndNanVariantsPreserveReferenceBytesAndIndices) {
    for (bool negative_first : {false, true}) {
        ShadowMeshFixture   mesh;
        const float         first = negative_first ? -0.0f : 0.0f;
        const float         second = negative_first ? 0.0f : -0.0f;
        const sceVu0FVECTOR points[6] = {
            {first,  -1,     100, 1},
            {1,      first,  100, 1},
            {-1,     first,  101, 1},
            {second, -1,     100, 1},
            {1,      second, 100, 1},
            {-1,     second, 101, 1},
        };
        std::memcpy(mesh.points, points, sizeof points);
        mesh.corners = {0, 1, 2, 3, 4, 5, 3, 4, 5, 0, 1, 2};
        const auto stats = ExpectMemoMatchesReference(mesh);
        EXPECT_EQ(stats.source_corners, 12u);
        EXPECT_GE(stats.transformed_positions, 6u);
        EXPECT_LT(stats.transformed_positions, stats.source_corners);
    }
    for (std::uint32_t variant : {0x7fc00002u, 0xffc00001u}) {
        ShadowMeshFixture mesh;
        mesh.points[3][0] = std::bit_cast<float>(0x7fc00001u);
        mesh.points[4][0] = std::bit_cast<float>(variant);
        mesh.points[5][0] = std::bit_cast<float>(0x7fc00001u);
        for (std::size_t index = 3; index < 6; ++index) {
            mesh.points[index][1] = -1;
            mesh.points[index][2] = 100;
        }
        mesh.corners = {0, 1, 2, 3, 1, 2, 4, 1, 2, 5, 1, 2, 4, 1, 2, 0, 1, 2};
        const auto stats = ExpectMemoMatchesReference(mesh);
        EXPECT_GE(stats.transformed_positions, 5u);
        EXPECT_LT(stats.transformed_positions, stats.source_corners);
    }
}

TEST(MgShadowMesh, MemoizedPositionsKeepEachTrianglesFirstCornerDepthBias) {
    ShadowMeshFixture mesh;
    mesh.points[1][2] = 200;
    mesh.points[3][2] = 300;
    mesh.info.shadow[2][2] = 0.25f;
    mesh.corners = {0, 1, 2, 3, 2, 1};
    sceVu0FVECTOR first_drop{};
    sceVu0FVECTOR second_drop{};
    sceVu0ApplyMatrix(first_drop, mesh.info.shadow, mesh.points[mesh.corners[0]]);
    sceVu0ApplyMatrix(second_drop, mesh.info.shadow, mesh.points[mesh.corners[3]]);
    ASSERT_NE(first_drop[2], second_drop[2]);
    const auto stats = ExpectMemoMatchesReference(mesh);
    EXPECT_LT(stats.transformed_positions, stats.source_corners);
    mesh.corners = {1, 2, 0, 2, 1, 3};
    ExpectMemoMatchesReference(mesh);
    mesh.info.shadow_light_dir[2] = 1;
    ExpectMemoMatchesReference(mesh);
}

TEST(MgShadowMesh, MemoizedTransformsRefreshInPlaceMutationsAndReusedVisualStorage) {
    std::optional<ShadowMeshFixture> mesh(std::in_place);
    const auto                      *visual_address = &mesh->visual;
    const auto                      *vertex_address = mesh->visual.vertex;
    auto                            *index_address = mesh->corners.data();
    ExpectMemoMatchesReference(*mesh);
    mesh->points[0][0] -= 0.25f;
    EXPECT_EQ(mesh->visual.vertex, vertex_address);
    ExpectMemoMatchesReference(*mesh);
    mesh->corners[0] = 1;
    mesh->corners[1] = 2;
    mesh->corners[2] = 0;
    EXPECT_EQ(mesh->corners.data(), index_address);
    ExpectMemoMatchesReference(*mesh);

    mesh.reset();
    mesh.emplace();
    EXPECT_EQ(&mesh->visual, visual_address);
    mesh->points[0][2] = 250;
    mesh->corners = {2, 1, 0, 3, 2, 0};
    ExpectMemoMatchesReference(*mesh);
}

TEST(MgShadowMesh, MemoizedTransformsUseCurrentModelViewShadowLightAndProjectionPerDraw) {
    ShadowMeshFixture mesh;
    ExpectMemoMatchesReference(mesh);
    mesh.model[3][0] = 3;
    ExpectMemoMatchesReference(mesh);
    mesh.info.view[3][1] = 2;
    mesh.info.view[0][0] = mesh.info.view[1][1] = std::cos(0.25f);
    mesh.info.view[0][1] = std::sin(0.25f);
    mesh.info.view[1][0] = -std::sin(0.25f);
    ExpectMemoMatchesReference(mesh);
    mesh.info.shadow[3][0] = 0.75f;
    ExpectMemoMatchesReference(mesh);
    mesh.info.shadow_light_dir[0] = 0.25f;
    ExpectMemoMatchesReference(mesh);

    auto projection = TestProjection();
    projection.eye *= 10000;
    ExpectMemoMatchesReference(mesh, projection, false);
    EXPECT_TRUE(mesh.indices.empty());
    projection = TestProjection();
    projection.near_z = 75;
    ExpectMemoMatchesReference(mesh, projection, false);
    EXPECT_TRUE(mesh.indices.empty());
    projection = TestProjection();
    projection.far_z = 60;
    ExpectMemoMatchesReference(mesh, projection, false);
    EXPECT_TRUE(mesh.indices.empty());
    ExpectMemoMatchesReference(mesh);
}

TEST(MgShadow, MemoizedTransformsMatchReferenceRgbaAcrossAnimatedFrames) {
    PresentRenderer renderer(640, 480);
    for (float animation : {0.0f, 0.5f, -0.5f, 1.0f, -1.0f, 0.25f}) {
        SCOPED_TRACE(animation);
        const std::vector<Caster> casters{
            {.centre = -0.35f + animation * 0.1f, .top = 0.45f + animation * 0.03f, .half = 1    },
            {.centre = 0.7f - animation * 0.1f,   .top = 0.6f,                      .half = 0.75f},
            {.centre = -2,                        .top = -0.2f,                     .half = 0.3f },
        };
        Pixels reference;
        Pixels memoized;
        {
            ShadowTransformScope mode(dc2::render::ShadowTransformMode::Reference);
            reference = RenderGroundUnder(casters, animation);
        }
        const auto before = dc2::render::GetShadowMeshStats();
        {
            ShadowTransformScope mode(dc2::render::ShadowTransformMode::Memoized);
            memoized = RenderGroundUnder(casters, animation);
        }
        const auto after = dc2::render::GetShadowMeshStats();
        EXPECT_EQ(after.memoized_draws - before.memoized_draws, casters.size());
        EXPECT_LT(after.transformed_positions - before.transformed_positions,
                  after.source_corners - before.source_corners);
        ASSERT_EQ(memoized.width, reference.width);
        ASSERT_EQ(memoized.height, reference.height);
        EXPECT_EQ(memoized.rgba, reference.rgba);
        EXPECT_LT(memoized.At(256, 240)[0] + 30, memoized.At(50, 50)[0]);
    }
}
