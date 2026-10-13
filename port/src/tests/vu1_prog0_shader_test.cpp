#include <gtest/gtest.h>

#include <array>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <filesystem>
#include <initializer_list>
#include <vector>

#include "gfx/gfx.hpp"
#include "gfx_fixture.hpp"

using namespace dc::test;

namespace {

constexpr int kWidth = 64;
constexpr int kHeight = 48;
constexpr int kTolerance = 1;
const std::array<uint8_t, 4> kClear = {0, 0, 0, 0x80};
const std::vector<uint32_t> kTriangle = {0, 1, 2};
const std::vector<uint32_t> kSquareIndices = {0, 1, 2, 0, 2, 3};
constexpr std::array<float, 12> kIdentityBone = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0};
constexpr std::array<float, 12> kTranslateXBone = {1, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0};
using Point = std::array<float, 2>;

GfxOptions Prog0Options() {
    GfxOptions options;
    options.prog0_meshes = true;
    // Own cache: the plain fixtures' cache must not gain Vu_prog0 pipelines.
    options.pipeline_cache = std::filesystem::temp_directory_path() / "dc_gfx_test" / "pipeline_cache_prog0.bin";
    return options;
}

void Identity(float (&m)[16]) {
    std::memset(m, 0, sizeof m);
    m[0] = m[5] = m[10] = m[15] = 1.0f;
}

template <size_t N>
void Set(float (&dst)[N], std::initializer_list<float> values) {
    size_t i = 0;
    for (float v : values) {
        dst[i++] = v;
    }
}

// clip.w = w: the fog is a function of 1/w, so w sets the depth it sees.
void SetWMvp(float (&m)[16], float w) {
    std::memset(m, 0, sizeof m);
    m[0] = m[5] = m[15] = w;
    m[14] = 0.5f * w;
}

// prog0.md 3.1 formulas in float; the 10.3 literals are rounded and not used.
void SetFogParam(float (&fog)[4], float near_dist, float far_dist, float far_value, float near_value) {
    const float range = far_value - near_value;
    fog[0] = (far_value + near_value + range * (far_dist + near_dist) / (far_dist - near_dist)) / 2.0f;
    fog[1] = near_value;
    fog[2] = far_value;
    fog[3] = -far_dist * near_dist * range / (far_dist - near_dist);
}

struct Prog0Draw {
    gfx::MeshConstants mesh;
    gfx::Prog0Constants prog0;
};

Prog0Draw Prog0(uint32_t flags) {
    Prog0Draw c{};
    Identity(c.mesh.mvp);
    Identity(c.prog0.model_world);
    Set(c.prog0.diffuse, {1, 1, 1, 1});
    c.prog0.flags = flags;
    return c;
}

void SetDirectional(gfx::Prog0Constants &p, uint32_t light, const std::array<float, 3> &direction,
                    const std::array<float, 4> &color) {
    for (uint32_t k = 0; k < 3; k++) {
        p.light_direction[k][light] = direction[k];
    }
    for (uint32_t k = 0; k < 4; k++) {
        p.light_color[light][k] = color[k];
    }
}

// Rows 0-2 of the bone's 4x4, row-major.
void SetBone(gfx::Prog0Constants &p, uint32_t slot, const std::array<float, 12> &rows) {
    for (uint32_t r = 0; r < 3; r++) {
        for (uint32_t c = 0; c < 4; c++) {
            p.bones[slot][r][c] = rows[r * 4 + c];
        }
    }
}

gfx::Vertex3D Vert(const std::array<float, 3> &position, const std::array<float, 3> &normal) {
    return {{position[0], position[1], position[2]}, {normal[0], normal[1], normal[2]}, {0.0f, 0.0f}, {0, 0, 0, 0}};
}

std::vector<gfx::Vertex3D> Triangle(const Point &a, const Point &b, const Point &c, float z,
                                    const std::array<float, 3> &normal) {
    return {Vert({a[0], a[1], z}, normal), Vert({b[0], b[1], z}, normal), Vert({c[0], c[1], z}, normal)};
}

std::vector<gfx::Vertex3D> ScreenVertices(const std::array<float, 3> &normal) {
    return Triangle({-1.0f, -1.0f}, {3.0f, -1.0f}, {-1.0f, 3.0f}, 0.5f, normal);
}

std::vector<gfx::Vertex3D> Square(float half, float z, const std::array<float, 3> &normal) {
    return {Vert({-half, -half, z}, normal), Vert({half, -half, z}, normal), Vert({half, half, z}, normal),
            Vert({-half, half, z}, normal)};
}

// Index i addresses pair i: the vertex, then its skin in the same bytes.
std::vector<gfx::Vertex3D> Skinned(const std::vector<gfx::Vertex3D> &vertices, const std::array<float, 4> &weight,
                                   const std::array<uint8_t, 4> &bone) {
    gfx::Prog0Skin skin = {};
    for (size_t i = 0; i < 4; i++) {
        skin.weight[i] = weight[i];
        skin.bone[i] = bone[i];
    }
    gfx::Vertex3D pair = {};
    std::memcpy(&pair, &skin, sizeof pair);
    std::vector<gfx::Vertex3D> out;
    for (const gfx::Vertex3D &vertex : vertices) {
        out.push_back(vertex);
        out.push_back(pair);
    }
    return out;
}

// GS pixel about the 2048 centre, as the NDC of an identity mvp.
float Gs(float pixel) {
    return (pixel - 2048.0f) / 256.0f;
}

uint32_t Column(const GfxFixture &fixture, float ndc) {
    return static_cast<uint32_t>((ndc + 1.0f) * 0.5f * static_cast<float>(fixture.width));
}

uint32_t Row(const GfxFixture &fixture, float ndc) {
    return static_cast<uint32_t>((ndc + 1.0f) * 0.5f * static_cast<float>(fixture.height));
}

bool At(const GfxFixture &fixture, float ndc_x, float ndc_y, int r, int g, int b) {
    return fixture.PixelNear(Column(fixture, ndc_x), Row(fixture, ndc_y), r, g, b, kTolerance);
}

void Render(GfxFixture &fixture, const std::vector<gfx::Vertex3D> &vertices, const std::vector<uint32_t> &indices,
            const Prog0Draw &draw, const gfx::DrawState &state = {}) {
    fixture.Frame(kClear, [&] { gfx::DrawMeshImmediateProg0(vertices, indices, draw.mesh, draw.prog0, {}, state); });
}

} // namespace

// prog0.md 10.1
TEST(Vu1Prog0Shader, LightingOffVector) {
    GfxFixture fixture(kWidth, kHeight, 1.0f, Prog0Options());
    Prog0Draw c = Prog0(gfx::kProg0Unlit);
    Set(c.prog0.object_color, {128, 64, 32, 128});
    Set(c.prog0.diffuse, {0.5f, 0.5f, 0.5f, 1.0f});
    Render(fixture, ScreenVertices({0, 0, 1}), kTriangle, c);
    EXPECT_TRUE(At(fixture, 0, 0, 64, 32, 16));

    // Alpha 128 is GS 1.0 here: Cs * As >> 7 keeps Cs.
    gfx::DrawState blend;
    blend.blend = true;
    blend.alpha = gfx::GsBlend{0, 2, 0, 2};
    Render(fixture, ScreenVertices({0, 0, 1}), kTriangle, c, blend);
    EXPECT_TRUE(At(fixture, 0, 0, 64, 32, 16));
}

// prog0.md 10.2
TEST(Vu1Prog0Shader, OneDirectionalLightVector) {
    GfxFixture fixture(kWidth, kHeight, 1.0f, Prog0Options());
    Prog0Draw c = Prog0(0);
    SetDirectional(c.prog0, 0, {0, 0, 1}, {128, 64, 0, 0});
    Set(c.prog0.ambient, {32, 32, 32, 128});
    Render(fixture, ScreenVertices({0, 0, 1}), kTriangle, c);
    EXPECT_TRUE(At(fixture, 0, 0, 160, 96, 32));
}

// prog0.md 10.3
TEST(Vu1Prog0Shader, FogVector) {
    GfxFixture fixture(kWidth, kHeight, 1.0f, Prog0Options());
    Prog0Draw c = Prog0(gfx::kProg0Unlit);
    Set(c.prog0.object_color, {255, 255, 255, 128});
    SetFogParam(c.prog0.fog, 10, 1000, 0, 255);
    gfx::DrawState state;
    state.fog = true;
    auto render_at = [&](float w) {
        SetWMvp(c.mesh.mvp, w);
        Render(fixture, ScreenVertices({0, 0, 1}), kTriangle, c, state);
    };
    render_at(10);
    EXPECT_TRUE(At(fixture, 0, 0, 255, 255, 255));
    render_at(1000);
    EXPECT_TRUE(At(fixture, 0, 0, 0, 0, 0));
    render_at(100);
    EXPECT_TRUE(At(fixture, 0, 0, 23, 23, 23));
}

// prog0.md 10.3, editor fog
TEST(Vu1Prog0Shader, EditorFogVector) {
    GfxFixture fixture(kWidth, kHeight, 1.0f, Prog0Options());
    Prog0Draw c = Prog0(gfx::kProg0Unlit);
    Set(c.prog0.object_color, {255, 255, 255, 128});
    SetFogParam(c.prog0.fog, 10, 1000, 255, 0);
    SetWMvp(c.mesh.mvp, 100);
    gfx::DrawState state;
    state.fog = true;
    Render(fixture, ScreenVertices({0, 0, 1}), kTriangle, c, state);
    EXPECT_TRUE(At(fixture, 0, 0, 255, 255, 255));
}

// prog0.md 10.4
TEST(Vu1Prog0Shader, FacingVector) {
    GfxFixture fixture(kWidth, kHeight, 1.0f, Prog0Options());
    const std::vector<gfx::Vertex3D> forward =
        Triangle({Gs(2100), Gs(2100)}, {Gs(2200), Gs(2100)}, {Gs(2100), Gs(2200)}, 0.5f, {0, 0, 1});
    const std::vector<gfx::Vertex3D> reversed =
        Triangle({Gs(2100), Gs(2100)}, {Gs(2100), Gs(2200)}, {Gs(2200), Gs(2100)}, 0.5f, {0, 0, 1});

    Prog0Draw c = Prog0(gfx::kProg0Unlit | gfx::kProg0Cull);
    Set(c.prog0.object_color, {200, 200, 200, 128});
    gfx::DrawState state;
    state.cull = gfx::Prog0CullMode(c.prog0);
    Render(fixture, forward, kTriangle, c, state);
    EXPECT_TRUE(At(fixture, 0.3f, 0.3f, 0, 0, 0));
    Render(fixture, reversed, kTriangle, c, state);
    EXPECT_TRUE(At(fixture, 0.3f, 0.3f, 200, 200, 200));

    Prog0Draw mirrored = c;
    Set(mirrored.prog0.model_world, {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1});
    gfx::DrawState mirrored_state;
    mirrored_state.cull = gfx::Prog0CullMode(mirrored.prog0);
    Render(fixture, forward, kTriangle, mirrored, mirrored_state);
    EXPECT_TRUE(At(fixture, 0.3f, 0.3f, 200, 200, 200));
    Render(fixture, reversed, kTriangle, mirrored, mirrored_state);
    EXPECT_TRUE(At(fixture, 0.3f, 0.3f, 0, 0, 0));
}

// progmain.md 10, vectors 1-3
TEST(Vu1Prog0Shader, MirrorWordVectors) {
    Prog0Draw identity = Prog0(gfx::kProg0Cull);
    EXPECT_EQ(gfx::Prog0CullMode(identity.prog0), gfx::CullMode::Back);

    Prog0Draw mirrored = identity;
    Set(mirrored.prog0.model_world, {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1});
    EXPECT_EQ(gfx::Prog0CullMode(mirrored.prog0), gfx::CullMode::Front);

    Prog0Draw scissor = Prog0(gfx::kProg0Cull | gfx::kProg0Scissor);
    EXPECT_EQ(gfx::Prog0CullMode(scissor.prog0), gfx::CullMode::Back);

    EXPECT_EQ(gfx::Prog0CullMode(Prog0(0).prog0), gfx::CullMode::None);
}

// prog0.md 10.6
TEST(Vu1Prog0Shader, VertexBlendVector) {
    GfxFixture fixture(kWidth, kHeight, 1.0f, Prog0Options());
    // A point rasterises to nothing; the square carries 10.6's P to pixels.
    const std::vector<gfx::Vertex3D> skinned =
        Skinned(Square(0.25f, 0.5f, {0, 0, 1}), {0.5f, 0.5f, 0, 0}, {0, 1, 0, 0});

    Prog0Draw c = Prog0(gfx::kProg0Unlit | gfx::kProg0Skinned);
    Set(c.prog0.object_color, {200, 200, 200, 128});
    SetBone(c.prog0, 0, kIdentityBone);
    SetBone(c.prog0, 1, kTranslateXBone);
    Render(fixture, skinned, kSquareIndices, c);
    EXPECT_TRUE(At(fixture, 0.5f, 0.0f, 200, 200, 200));
    EXPECT_TRUE(At(fixture, 0.0f, 0.0f, 0, 0, 0));

    Prog0Draw lit = Prog0(gfx::kProg0Skinned);
    SetBone(lit.prog0, 0, kIdentityBone);
    SetBone(lit.prog0, 1, kTranslateXBone);
    SetDirectional(lit.prog0, 0, {0, 0, 1}, {100, 100, 100, 0});
    Render(fixture, skinned, kSquareIndices, lit);
    EXPECT_TRUE(At(fixture, 0.5f, 0.0f, 100, 100, 100));
}
