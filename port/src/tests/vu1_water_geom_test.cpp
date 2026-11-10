#include <gtest/gtest.h>

#include <cstddef>
#include <cstdint>
#include <vector>

#include "vu1/water_geom.hpp"
#include "vu1_oracle/water_oracle.hpp"

namespace {

using namespace dc::vu1;

constexpr uint32_t kPass = 0xD0u;
constexpr int      kRows6 = 6;
constexpr int      kColumns6 = 6;

WaterParams CommonParams() {
    WaterParams p{};
    p.r = Identity();
    p.p0 = 1.0f;
    p.p1 = 2.0f;
    p.width = 640.0f;
    p.height = 448.0f;
    p.ox = kGsCentre - p.width / 2.0f;
    p.oy = kGsCentre - p.height / 2.0f;
    p.guard_min = {.x = 1.0f, .y = 1.0f, .z = 0.0f, .w = 0.8f};
    p.guard_max = {.x = 4095.0f, .y = 4095.0f, .z = 0.0f, .w = 1000.0f};
    p.fog = {.offset = 0.0f, .near_value = 0.0f, .far_value = 0.0f, .scale = 0.0f};
    p.fog_enabled = false;
    p.colour = {.x = 128.0f, .y = 128.0f, .z = 128.0f, .w = 128.0f};
    return p;
}

WaterStripVertex Vertex(Vec4 pos, Vec4 slope) {
    return WaterStripVertex{.pos = pos, .slope = slope};
}

// Neighbour that passes all three tests; used as filler before the vertex under test.
WaterStripVertex PassingVertex() {
    return Vertex({.x = 2048.0f, .y = 2048.0f, .z = 0.0f, .w = 1.0f}, {.x = 0.0f, .y = 0.0f, .z = 0.0f, .w = 1.0f});
}

// Kick of a strip's third vertex when preceded by two passing vertices.
bool KickedAsThird(const WaterParams &p, WaterStripVertex third) {
    const std::vector<WaterStripVertex> strip{PassingVertex(), PassingVertex(), third};
    const std::vector<WaterVertex>      out = WaterStripTransform(p, strip, kPass, kPass);
    return WaterKicks(out)[2];
}

// Grid cell (i, c) read from the strip that owns it. The last grid row belongs to the last strip, r = 1.
const WaterStripVertex &GridVertex(const WaterMesh &mesh, int rows, int i, int c) {
    const int strip = i == rows - 1 ? i - 1 : i;
    const int r = i - strip;
    return mesh[static_cast<std::size_t>(strip)][static_cast<std::size_t>(2 * c + r)];
}

std::vector<float> Heights6x6() {
    std::vector<float> h(kRows6 * kColumns6);
    for (int r = 0; r < kRows6; ++r) {
        for (int c = 0; c < kColumns6; ++c) {
            h[static_cast<std::size_t>(r * kColumns6 + c)] = static_cast<float>(10 * r + c);
        }
    }
    return h;
}

WaterMeshDesc Desc6x6() {
    return WaterMeshDesc{
        .min = {.x = 1.0f,  .y = -1.0f, .z = 2.0f,  .w = 0.0f},
        .max = {.x = 11.0f, .y = 4.0f,  .z = 22.0f, .w = 0.0f},
        .rows = kRows6,
        .columns = kColumns6
    };
}

} // namespace

// TV1: flat water, zero slope, interior of the screen.
TEST(Vu1WaterGeom, TV1_FlatInterior) {
    const WaterParams p = CommonParams();
    const WaterVertex v = WaterTransform(p, {.x = 2048.0f, .y = 2048.0f, .z = 0.0f, .w = 1.0f}, {.x = 0.0f, .y = 0.0f, .z = 0.0f, .w = 1.0f}, kPass, kPass);

    EXPECT_EQ(v.r, 128);
    EXPECT_EQ(v.g, 128);
    EXPECT_EQ(v.b, 128);
    EXPECT_EQ(v.a, 128);
    EXPECT_EQ(v.u, 5120);
    EXPECT_EQ(v.v, 3584);
    EXPECT_EQ(v.x, 0x8000);
    EXPECT_EQ(v.y, 0x8000);
    EXPECT_EQ(v.z, 0u);
    EXPECT_EQ(v.f, 0);
    EXPECT_FALSE(v.adc);
    EXPECT_EQ(v.pass_bits, 0xD0u);
    EXPECT_TRUE(KickedAsThird(p, Vertex({2048.0f, 2048.0f, 0.0f, 1.0f}, {0.0f, 0.0f, 0.0f, 1.0f})));
}

// TV2: non-zero slope (refraction and edge weight).
TEST(Vu1WaterGeom, TV2_SlopeRefractionAndEdgeWeight) {
    const WaterParams p = CommonParams();
    const WaterVertex v = WaterTransform(p, {.x = 2048.0f, .y = 2048.0f, .z = 0.0f, .w = 1.0f}, {.x = 0.5f, .y = -0.25f, .z = 99.0f, .w = 0.6f}, kPass, kPass);

    EXPECT_EQ(v.r, 128);
    EXPECT_EQ(v.g, 128);
    EXPECT_EQ(v.b, 128);
    EXPECT_EQ(v.a, 76);
    EXPECT_EQ(v.u, 5136);
    EXPECT_EQ(v.v, 3576);
    EXPECT_EQ(v.x, 0x8000);
    EXPECT_EQ(v.y, 0x8000);
    EXPECT_EQ(v.z, 0u);
    EXPECT_EQ(v.f, 0);
    EXPECT_FALSE(v.adc);
    EXPECT_EQ(v.pass_bits, 0xD0u);
    EXPECT_TRUE(KickedAsThird(p, Vertex({2048.0f, 2048.0f, 0.0f, 1.0f}, {0.5f, -0.25f, 99.0f, 0.6f})));
}

// TV3: vertex outside the X guard.
TEST(Vu1WaterGeom, TV3_OutsideXGuardSetsAdc) {
    const WaterParams p = CommonParams();
    const WaterVertex v = WaterTransform(p, {.x = 4200.0f, .y = 2048.0f, .z = 0.0f, .w = 1.0f}, {.x = 0.0f, .y = 0.0f, .z = 0.0f, .w = 1.0f}, kPass, kPass);

    EXPECT_EQ(v.r, 128);
    EXPECT_EQ(v.g, 128);
    EXPECT_EQ(v.b, 128);
    EXPECT_EQ(v.a, 128);
    EXPECT_EQ(v.u, 10240);
    EXPECT_EQ(v.v, 3584);
    EXPECT_EQ(v.x, 0x0680);
    EXPECT_EQ(v.y, 0x8000);
    EXPECT_EQ(v.z, 0u);
    EXPECT_EQ(v.f, 0);
    EXPECT_TRUE(v.adc);
    EXPECT_EQ(v.pass_bits, 0x50u);
    EXPECT_FALSE(KickedAsThird(p, Vertex({4200.0f, 2048.0f, 0.0f, 1.0f}, {0.0f, 0.0f, 0.0f, 1.0f})));
}

// TV4: W window, interlocked reading (open point 9.4). The stale alternative (guard w window
// 1/far < Q < 1/near, ADC = 1, triangle not kicked) is not implemented.
TEST(Vu1WaterGeom, TV4_WWindowInterlockedReading) {
    WaterParams p = CommonParams();
    p.r.q[3] = {.x = 0.0f, .y = 0.0f, .z = 0.0f, .w = 0.7f};
    const WaterVertex v = WaterTransform(p, {.x = 2048.0f, .y = 2048.0f, .z = 0.0f, .w = 1.0f}, {.x = 0.0f, .y = 0.0f, .z = 0.0f, .w = 1.0f}, kPass, kPass);

    EXPECT_EQ(v.r, 128);
    EXPECT_EQ(v.g, 128);
    EXPECT_EQ(v.b, 128);
    EXPECT_EQ(v.a, 128);
    EXPECT_EQ(v.u, 10240);
    EXPECT_EQ(v.v, 7152);
    EXPECT_EQ(v.x, 0xB6DB);
    EXPECT_EQ(v.y, 0xB6DB);
    EXPECT_EQ(v.z, 0u);
    EXPECT_EQ(v.f, 0);
    EXPECT_FALSE(v.adc);
    EXPECT_EQ(v.pass_bits, 0xD0u);
    EXPECT_TRUE(KickedAsThird(p, Vertex({2048.0f, 2048.0f, 0.0f, 1.0f}, {0.0f, 0.0f, 0.0f, 1.0f})));
}

TEST(Vu1WaterGeom, MeshWeightsRowOverwrite6x6) {
    const std::vector<float> h(kRows6 * kColumns6, 0.0f);
    const WaterMesh          mesh = BuildWaterMesh(Desc6x6(), h);
    ASSERT_EQ(mesh.size(), 5u);

    const float expected_rows[kRows6] = {0.0f, 0.6f, 0.3f, 0.3f, 0.6f, 0.0f};
    for (int i = 0; i < kRows6; ++i) {
        for (int c = 0; c < kColumns6; ++c) {
            EXPECT_FLOAT_EQ(GridVertex(mesh, kRows6, i, c).slope.w, expected_rows[i]) << "i=" << i << " c=" << c;
        }
    }
}

TEST(Vu1WaterGeom, MeshWeightsEdgeStencil8x8) {
    const std::vector<float> h(8 * 8, 0.0f);
    const WaterMeshDesc      desc{
        .min = {.x = 0.0f, .y = 0.0f, .z = 0.0f, .w = 0.0f},
        .max = {.x = 7.0f, .y = 0.0f, .z = 7.0f, .w = 0.0f},
        .rows = 8,
        .columns = 8
    };
    const WaterMesh mesh = BuildWaterMesh(desc, h);

    const float row3[8] = {0.0f, 0.6f, 0.3f, 1.0f, 1.0f, 0.3f, 0.6f, 0.0f};
    for (int c = 0; c < 8; ++c) {
        EXPECT_FLOAT_EQ(GridVertex(mesh, 8, 3, c).slope.w, row3[c]) << "c=" << c;
        EXPECT_FLOAT_EQ(GridVertex(mesh, 8, 4, c).slope.w, row3[c]) << "c=" << c;
    }
    EXPECT_FLOAT_EQ(GridVertex(mesh, 8, 1, 3).slope.w, 0.6f);
    EXPECT_FLOAT_EQ(GridVertex(mesh, 8, 2, 3).slope.w, 0.3f);
    EXPECT_FLOAT_EQ(GridVertex(mesh, 8, 0, 3).slope.w, 0.0f);
    EXPECT_FLOAT_EQ(GridVertex(mesh, 8, 7, 3).slope.w, 0.0f);
}

TEST(Vu1WaterGeom, MeshSlopesAtRowZeroAndLastColumn) {
    const WaterMesh mesh = BuildWaterMesh(Desc6x6(), Heights6x6());

    EXPECT_FLOAT_EQ(GridVertex(mesh, kRows6, 0, 0).slope.x, 0.0f);
    EXPECT_FLOAT_EQ(GridVertex(mesh, kRows6, 0, 0).slope.y, -1.0f);
    EXPECT_FLOAT_EQ(GridVertex(mesh, kRows6, 1, 2).slope.x, -10.0f);
    EXPECT_FLOAT_EQ(GridVertex(mesh, kRows6, 1, 2).slope.y, -1.0f);

    // Open point 9.6: the last column reads the next row's first height, h[r+1][0].
    EXPECT_FLOAT_EQ(GridVertex(mesh, kRows6, 0, 5).slope.x, 0.0f);
    EXPECT_FLOAT_EQ(GridVertex(mesh, kRows6, 0, 5).slope.y, -5.0f);
    EXPECT_FLOAT_EQ(GridVertex(mesh, kRows6, 1, 5).slope.x, -10.0f);
    EXPECT_FLOAT_EQ(GridVertex(mesh, kRows6, 1, 5).slope.y, -5.0f);
    // Open point 9.6: the last row has no next row; the PC uses 0.
    EXPECT_FLOAT_EQ(GridVertex(mesh, kRows6, 5, 5).slope.x, -10.0f);
    EXPECT_FLOAT_EQ(GridVertex(mesh, kRows6, 5, 5).slope.y, 0.0f);
}

TEST(Vu1WaterGeom, MeshPositions) {
    const WaterMesh mesh = BuildWaterMesh(Desc6x6(), Heights6x6());

    const Vec4 p00 = GridVertex(mesh, kRows6, 0, 0).pos;
    EXPECT_FLOAT_EQ(p00.x, 1.0f);
    EXPECT_FLOAT_EQ(p00.y, -1.0f);
    EXPECT_FLOAT_EQ(p00.z, 2.0f);
    EXPECT_FLOAT_EQ(p00.w, 1.0f);

    const Vec4 p35 = GridVertex(mesh, kRows6, 3, 5).pos;
    EXPECT_FLOAT_EQ(p35.x, 7.0f);
    EXPECT_FLOAT_EQ(p35.y, -1.0f);
    EXPECT_FLOAT_EQ(p35.z, 22.0f);
    EXPECT_FLOAT_EQ(p35.w, 1.0f);

    const Vec4 p50 = GridVertex(mesh, kRows6, 5, 0).pos;
    EXPECT_FLOAT_EQ(p50.x, 11.0f);
    EXPECT_FLOAT_EQ(p50.z, 2.0f);

    // Vertex layout inside a strip: j = 2c + r.
    EXPECT_FLOAT_EQ(mesh[2][2 * 5 + 1].pos.x, 7.0f);
    EXPECT_FLOAT_EQ(mesh[2][2 * 5 + 1].pos.z, 22.0f);
    EXPECT_FLOAT_EQ(mesh[2][2 * 5].pos.x, 5.0f);
}

// Open point 9.7: retail drops columns for N >= 28. The PC reading emits every column.
TEST(Vu1WaterGeom, MeshCoversAllColumnsPast27) {
    const std::vector<float> h(2 * 28, 0.0f);
    const WaterMeshDesc      desc{
        .min = {.x = 0.0f, .y = 0.0f, .z = 0.0f,  .w = 0.0f},
        .max = {.x = 0.0f, .y = 0.0f, .z = 27.0f, .w = 0.0f},
        .rows = 2,
        .columns = 28
    };
    const WaterMesh mesh = BuildWaterMesh(desc, h);

    ASSERT_EQ(mesh.size(), 1u);
    ASSERT_EQ(mesh[0].size(), 56u);
    EXPECT_FLOAT_EQ(mesh[0][55].pos.z, 27.0f);
    EXPECT_FLOAT_EQ(mesh[0][54].pos.z, 27.0f);
    EXPECT_FLOAT_EQ(mesh[0][53].pos.z, 26.0f);
}

TEST(Vu1WaterGeom, WaterStateFogOn) {
    const WaterRenderState s = WaterState(true);
    EXPECT_EQ(s.prmode, 0x178u);
    EXPECT_EQ(s.psm, 0x01u);
    EXPECT_EQ(s.ta0, 0x80u);
    EXPECT_EQ(s.ta1, 0x80u);
    EXPECT_FALSE(s.aem);
}

TEST(Vu1WaterGeom, WaterStateFogOff) {
    const WaterRenderState s = WaterState(false);
    EXPECT_EQ(s.prmode, 0x158u);
    EXPECT_EQ(s.psm, 0x01u);
    EXPECT_EQ(s.ta0, 0x80u);
    EXPECT_EQ(s.ta1, 0x80u);
    EXPECT_FALSE(s.aem);
}
