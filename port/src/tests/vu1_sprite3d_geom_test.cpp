#include <gtest/gtest.h>

#include <algorithm>
#include <cmath>
#include <cstdint>
#include <cstdlib>

#include "vu1/sprite3d_geom.hpp"
#include "vu1_oracle/vu1_pack.hpp"
#include "vu1_sprite3d_oracle.hpp"

namespace {

using namespace dc::vu1;
namespace oracle = dc::vu1::sprite3d_oracle;

// Section 10 common inputs: near = 1, far = 200, fog {0.5, 1.0, 0.0, 8.0}.
Sprite3dParams CommonParams() {
    Sprite3dParams p{};
    p.ls = Mat4{
        {Vec4{.x = 2, .y = 0, .z = 0, .w = 0}, Vec4{.x = 0, .y = 2, .z = 0, .w = 0}, Vec4{.x = 0, .y = 0, .z = 1, .w = 0}, Vec4{.x = 8192, .y = 8192, .z = 40, .w = 4}}
    };
    p.vs0 = Vec4{.x = 2, .y = 0, .z = 0, .w = 0};
    p.vs1 = Vec4{.x = 0, .y = 2, .z = 0, .w = 0};
    p.fog = Fog{.offset = 0.5f, .near_value = 1.0f, .far_value = 0.0f, .scale = 8.0f};
    p.guard_min = Vec4{.x = 1, .y = 1, .z = 0, .w = 1};
    p.guard_max = Vec4{.x = 4095, .y = 4095, .z = 0, .w = 200};
    return p;
}

// Section 10: pos (0,0,0,1), size (w 8, h 6, sin 0, cos 0), colour (128,128,128,96), UV (0,0)-(16,16).
Sprite3dRecord CommonRecord() {
    Sprite3dRecord r{};
    r.pos = Vec4{.x = 0, .y = 0, .z = 0, .w = 1};
    r.size = Vec4{.x = 8, .y = 6, .z = 0, .w = 0};
    r.colour = Vec4{.x = 128, .y = 128, .z = 128, .w = 96};
    r.uv0 = Vec4{.x = 0, .y = 0, .z = 0, .w = 0};
    r.uv1 = Vec4{.x = 16, .y = 16, .z = 0, .w = 0};
    return r;
}

void ExpectScreen(const oracle::Vertex &v, float x, float y, float z, float f) {
    EXPECT_FLOAT_EQ(v.screen.x, x);
    EXPECT_FLOAT_EQ(v.screen.y, y);
    EXPECT_FLOAT_EQ(v.screen.z, z);
    EXPECT_FLOAT_EQ(v.screen.w, f);
}

// The native path must make the same drawn decision and, after the GS quantisation, land within
// one LSB of the oracle on every component. Non-finite output is a failure in itself.
void ExpectNativeAgreesWithOracle(const Sprite3dParams &p, const Sprite3dRecord &r, int mode) {
    const Sprite3dQuadF n = Sprite3dExpandNative(p, r, mode);
    const oracle::Quad  o = oracle::Expand(p, r, mode);

    EXPECT_EQ(n.drawn, o.drawn);
    EXPECT_EQ(n.count, o.vertex_count);

    for (int i = 0; i < 4; ++i) {
        EXPECT_TRUE(std::isfinite(n.rgba[i])) << "colour " << i;
        EXPECT_LE(std::fabs(std::clamp(n.rgba[i], 0.0f, 255.0f) - static_cast<float>(o.rgba[i])), 1.0f)
            << "colour " << i;
    }

    for (int i = 0; i < o.vertex_count; ++i) {
        const Sprite3dVertexF &nv = n.v[i];
        const oracle::Vertex  &ov = o.v[i];

        EXPECT_TRUE(std::isfinite(nv.x) && std::isfinite(nv.y) && std::isfinite(nv.z)) << "vertex " << i;
        EXPECT_TRUE(std::isfinite(nv.u) && std::isfinite(nv.v) && std::isfinite(nv.fog)) << "vertex " << i;

        const auto dx = static_cast<int16_t>(static_cast<uint16_t>(Ftoi4(nv.x)) - ov.x);
        const auto dy = static_cast<int16_t>(static_cast<uint16_t>(Ftoi4(nv.y)) - ov.y);
        EXPECT_LE(std::abs(dx), 1) << "vertex " << i << " x";
        EXPECT_LE(std::abs(dy), 1) << "vertex " << i << " y";

        EXPECT_LE(std::fabs(nv.z - static_cast<float>(ov.z)), 1.0f) << "vertex " << i << " z";

        EXPECT_LE(std::fabs(16.0f * nv.u - static_cast<float>(ov.u)), 1.0f) << "vertex " << i << " u";
        EXPECT_LE(std::fabs(16.0f * nv.v - static_cast<float>(ov.v)), 1.0f) << "vertex " << i << " v";

        EXPECT_LE(std::abs(std::lround(nv.fog * 255.0f) - static_cast<long>(ov.f)), 1L) << "vertex " << i << " fog";
    }
}

} // namespace

// Section 10 case 1: Pw = 4, Q = 0.25, c = (2048, 2048, 10), F = 1.0.
TEST(Vu1Sprite3dGeom, Case1NonRotatedSpriteAtCentre) {
    const Sprite3dParams p = CommonParams();
    const Sprite3dRecord r = CommonRecord();

    const Vec4 pclip = Mul(p.ls, r.pos);
    EXPECT_FLOAT_EQ(pclip.w, 4.0f);
    EXPECT_FLOAT_EQ(pclip.x * (1.0f / pclip.w), 2048.0f);

    const oracle::Quad q = oracle::Expand(p, r, 0);
    EXPECT_EQ(q.vertex_count, 2);
    EXPECT_TRUE(q.drawn);
    EXPECT_EQ(q.rgba[0], 0x80);
    EXPECT_EQ(q.rgba[1], 0x80);
    EXPECT_EQ(q.rgba[2], 0x80);
    EXPECT_EQ(q.rgba[3], 0x60);

    ExpectScreen(q.v[0], 2046.0f, 2046.5f, 10.0f, 1.0f);
    ExpectScreen(q.v[1], 2050.0f, 2049.5f, 10.0f, 1.0f);
    EXPECT_EQ(q.v[0].u, 0);
    EXPECT_EQ(q.v[0].v, 0);
    EXPECT_EQ(q.v[1].u, 256);
    EXPECT_EQ(q.v[1].v, 256);

    EXPECT_EQ(q.v[0].x, 0x7FE0);
    EXPECT_EQ(q.v[0].y, 0x7FE8);
    EXPECT_EQ(q.v[0].z, 10u);
    EXPECT_EQ(q.v[0].w, 0x0010);
    EXPECT_EQ(q.v[0].f, 1);
    EXPECT_FALSE(q.v[0].adc);

    EXPECT_EQ(q.v[1].x, 0x8020);
    EXPECT_EQ(q.v[1].y, 0x8018);
    EXPECT_EQ(q.v[1].z, 10u);
    EXPECT_EQ(q.v[1].w, 0x0010);
    EXPECT_FALSE(q.v[1].adc);

    ExpectNativeAgreesWithOracle(p, r, 0);
}

// Section 10 case 2: mode 1, sin = 1, cos = 0. A' = (0, 2), B' = (-1.5, 0).
// v0 and v1 carry ADC unconditionally; v2 and v3 are drawn without it.
TEST(Vu1Sprite3dGeom, Case2RotatedStripWithAdcPattern) {
    const Sprite3dParams p = CommonParams();
    Sprite3dRecord       r = CommonRecord();
    r.size = Vec4{.x = 8, .y = 6, .z = 1, .w = 0};

    const oracle::Quad q = oracle::Expand(p, r, 1);
    EXPECT_EQ(q.vertex_count, 4);
    EXPECT_TRUE(q.drawn);
    EXPECT_EQ(q.rgba[0], 0x80);
    EXPECT_EQ(q.rgba[3], 0x60);

    ExpectScreen(q.v[0], 2049.5f, 2046.0f, 10.0f, 1.0f);
    ExpectScreen(q.v[1], 2049.5f, 2050.0f, 10.0f, 1.0f);
    ExpectScreen(q.v[2], 2046.5f, 2046.0f, 10.0f, 1.0f);
    ExpectScreen(q.v[3], 2046.5f, 2050.0f, 10.0f, 1.0f);

    EXPECT_EQ(q.v[0].u, 0);
    EXPECT_EQ(q.v[0].v, 0);
    EXPECT_EQ(q.v[1].u, 256);
    EXPECT_EQ(q.v[1].v, 0);
    EXPECT_EQ(q.v[2].u, 0);
    EXPECT_EQ(q.v[2].v, 256);
    EXPECT_EQ(q.v[3].u, 256);
    EXPECT_EQ(q.v[3].v, 256);

    EXPECT_EQ(q.v[0].x, 0x8018);
    EXPECT_EQ(q.v[0].y, 0x7FE0);
    EXPECT_EQ(q.v[0].z, 10u);
    EXPECT_EQ(q.v[0].w, 0x8010);
    EXPECT_TRUE(q.v[0].adc);

    EXPECT_EQ(q.v[1].x, 0x8018);
    EXPECT_EQ(q.v[1].y, 0x8020);
    EXPECT_EQ(q.v[1].w, 0x8010);
    EXPECT_TRUE(q.v[1].adc);

    EXPECT_EQ(q.v[2].x, 0x7FE8);
    EXPECT_EQ(q.v[2].y, 0x7FE0);
    EXPECT_EQ(q.v[2].w, 0x0010);
    EXPECT_FALSE(q.v[2].adc);

    EXPECT_EQ(q.v[3].x, 0x7FE8);
    EXPECT_EQ(q.v[3].y, 0x8020);
    EXPECT_EQ(q.v[3].w, 0x0010);
    EXPECT_FALSE(q.v[3].adc);

    ExpectNativeAgreesWithOracle(p, r, 1);
}

// Section 10 case 3: Pw = 100, Q = 0.01, far_value = 0.8. Unclamped F = 0.58 would give w word
// 0x0009; the clamp to far_value gives F = 0.8 and w word 0x000C.
TEST(Vu1Sprite3dGeom, Case3FogClampedAtFarValue) {
    Sprite3dParams p = CommonParams();
    p.fog.far_value = 0.8f;
    Sprite3dRecord r = CommonRecord();
    r.pos = Vec4{.x = 0, .y = 0, .z = 0, .w = 25};

    const oracle::Quad q = oracle::Expand(p, r, 0);
    EXPECT_TRUE(q.drawn);
    EXPECT_EQ(q.v[0].x, 0x7FFE);
    EXPECT_EQ(q.v[0].y, 0x7FFF);
    EXPECT_EQ(q.v[0].z, 10u);
    EXPECT_EQ(q.v[0].w, 0x000C);
    EXPECT_EQ(q.v[0].f, 0);
    EXPECT_FALSE(q.v[0].adc);

    EXPECT_EQ(q.v[1].x, 0x8001);
    EXPECT_EQ(q.v[1].y, 0x8000);
    EXPECT_EQ(q.v[1].w, 0x000C);

    ExpectNativeAgreesWithOracle(p, r, 0);
}

// far_value = 2.5 with case 1 geometry: F0 = 2.5, min(F0, near 1.0) = 1.0, max(1.0, 2.5) = 2.5.
TEST(Vu1Sprite3dGeom, FarValueSubVectorSetsFogByte) {
    Sprite3dParams p = CommonParams();
    p.fog.far_value = 2.5f;
    const oracle::Quad q = oracle::Expand(p, CommonRecord(), 0);
    EXPECT_TRUE(q.drawn);
    EXPECT_EQ(q.v[0].w, 0x0028);
    EXPECT_EQ(q.v[0].f, 2);
    EXPECT_EQ(q.v[1].w, 0x0028);

    ExpectNativeAgreesWithOracle(p, CommonRecord(), 0);
}

// Pw = 1.1: F0 = 0.5 + 8/1.1 = 7.77, min with near_value 1.0 gives 1.0, so F = 1.0 (w word 0x0010).
TEST(Vu1Sprite3dGeom, UpperBoundFogClampedAtNearValue) {
    const Sprite3dParams p = CommonParams();
    Sprite3dRecord       r = CommonRecord();
    r.pos = Vec4{.x = 0, .y = 0, .z = 0, .w = 0.275f};

    const oracle::Quad q = oracle::Expand(p, r, 0);
    EXPECT_TRUE(q.drawn);
    EXPECT_EQ(q.v[0].w, 0x0010);
    EXPECT_EQ(q.v[1].w, 0x0010);

    ExpectNativeAgreesWithOracle(p, r, 0);
}

// The spec has no vector for the cull; these follow section 7. min.x = 1 exactly must fail
// because the test is strict. pos.x = -4093 gives c.x = 1.5 and half.x = 0.5.
TEST(Vu1Sprite3dGeom, CullMinXExactlyOneIsRejected) {
    const Sprite3dParams p = CommonParams();
    Sprite3dRecord       r = CommonRecord();
    r.pos = Vec4{.x = -4093, .y = 0, .z = 0, .w = 1};
    r.size = Vec4{.x = 2, .y = 6, .z = 0, .w = 0};

    const oracle::Quad q = oracle::Expand(p, r, 0);
    EXPECT_FALSE(q.drawn);
    EXPECT_TRUE(q.v[0].adc);
    EXPECT_TRUE(q.v[1].adc);

    ExpectNativeAgreesWithOracle(p, r, 0);
}

// max.x = 4096, one past 4095. min.x = 104 passes, so only the upper bound fails.
TEST(Vu1Sprite3dGeom, CullMaxXOnePastBoundIsRejected) {
    const Sprite3dParams p = CommonParams();
    Sprite3dRecord       r = CommonRecord();
    r.pos = Vec4{.x = 104, .y = 0, .z = 0, .w = 1};
    r.size = Vec4{.x = 7984, .y = 6, .z = 0, .w = 0};

    const oracle::Quad q = oracle::Expand(p, r, 0);
    EXPECT_FALSE(q.drawn);
    EXPECT_TRUE(q.v[0].adc);
    EXPECT_TRUE(q.v[1].adc);

    ExpectNativeAgreesWithOracle(p, r, 0);
}

// Q must satisfy 1/far < Q < 1/near strictly. Pw = 200 and Pw = 1 hit the bounds exactly;
// Pw = 300 and Pw = 0.5 lie outside.
TEST(Vu1Sprite3dGeom, CullWindowIsStrictOnBothSides) {
    const Sprite3dParams p = CommonParams();
    const float          pos_w[] = {50.0f, 75.0f, 0.25f, 0.125f};
    const float          pw[] = {200.0f, 300.0f, 1.0f, 0.5f};
    for (int i = 0; i < 4; ++i) {
        Sprite3dRecord r = CommonRecord();
        r.pos = Vec4{.x = 0, .y = 0, .z = 0, .w = pos_w[i]};
        ASSERT_FLOAT_EQ(Mul(p.ls, r.pos).w, pw[i]);
        const oracle::Quad q = oracle::Expand(p, r, 0);
        EXPECT_FALSE(q.drawn) << "Pw = " << pw[i];
        EXPECT_TRUE(q.v[0].adc);
        EXPECT_TRUE(q.v[1].adc);

        ExpectNativeAgreesWithOracle(p, r, 0);
    }
}

// Open point 14: Pw = 0. VU DIV saturates to the largest magnitude, so Q stays finite and the
// window test fails. With pos = 0 and size = 0 every coordinate stays exact.
TEST(Vu1Sprite3dGeom, ZeroPwIsRejectedWithoutNan) {
    const Sprite3dParams p = CommonParams();
    Sprite3dRecord       r = CommonRecord();
    r.pos = Vec4{.x = 0, .y = 0, .z = 0, .w = 0};
    r.size = Vec4{.x = 0, .y = 0, .z = 0, .w = 0};

    const oracle::Quad q = oracle::Expand(p, r, 0);
    EXPECT_FALSE(q.drawn);
    EXPECT_TRUE(q.v[0].adc);
    EXPECT_TRUE(q.v[1].adc);

    const Sprite3dQuadF n = Sprite3dExpandNative(p, r, 0);
    EXPECT_FALSE(n.drawn);
    EXPECT_TRUE(std::isfinite(n.v[0].x) && std::isfinite(n.v[0].y) && std::isfinite(n.v[0].fog));
}

// Rejected rotated sprite: mode 1 sets ADC on all four vertices. cos = 1, sin = 0 keeps the
// same x extent as the min.x case, so the corner at x = 1 exactly is rejected.
TEST(Vu1Sprite3dGeom, RejectedRotatedSpriteSetsAdcOnAllVertices) {
    const Sprite3dParams p = CommonParams();
    Sprite3dRecord       r = CommonRecord();
    r.pos = Vec4{.x = -4093, .y = 0, .z = 0, .w = 1};
    r.size = Vec4{.x = 2, .y = 6, .z = 0, .w = 1};

    const oracle::Quad q = oracle::Expand(p, r, 1);
    EXPECT_EQ(q.vertex_count, 4);
    EXPECT_FALSE(q.drawn);
    for (int i = 0; i < 4; ++i) {
        EXPECT_TRUE(q.v[i].adc) << "vertex " << i;
    }

    ExpectNativeAgreesWithOracle(p, r, 1);
}

// Open point 3: the VU branches to the strip path for any nonzero mode, so mode 2 emits the
// same strip as mode 1.
TEST(Vu1Sprite3dGeom, ModesOtherThanZeroUseTheStripPath) {
    const Sprite3dParams p = CommonParams();
    Sprite3dRecord       r = CommonRecord();
    r.size = Vec4{.x = 8, .y = 6, .z = 1, .w = 0};

    const oracle::Quad q1 = oracle::Expand(p, r, 1);
    const oracle::Quad q2 = oracle::Expand(p, r, 2);
    EXPECT_EQ(q2.vertex_count, 4);
    EXPECT_EQ(q2.drawn, q1.drawn);
    for (int i = 0; i < 4; ++i) {
        EXPECT_EQ(q2.v[i].x, q1.v[i].x);
        EXPECT_EQ(q2.v[i].y, q1.v[i].y);
        EXPECT_EQ(q2.v[i].w, q1.v[i].w);
    }

    const Sprite3dQuadF n1 = Sprite3dExpandNative(p, r, 1);
    const Sprite3dQuadF n2 = Sprite3dExpandNative(p, r, 2);
    EXPECT_EQ(n2.count, 4);
    EXPECT_EQ(n2.drawn, n1.drawn);
    for (int i = 0; i < 4; ++i) {
        EXPECT_FLOAT_EQ(n2.v[i].x, n1.v[i].x);
        EXPECT_FLOAT_EQ(n2.v[i].y, n1.v[i].y);
        EXPECT_FLOAT_EQ(n2.v[i].fog, n1.v[i].fog);
    }
}

// FTOI0 saturates to 16 bits before the low byte is taken (section 5). The spec has no vector
// for this; the expectation follows the section 5 text. The native path keeps the colour
// unclamped and leaves the host saturation to the caller.
TEST(Vu1Sprite3dGeom, ColourSaturatesTo16BitsBeforeLowByte) {
    const Sprite3dParams p = CommonParams();
    Sprite3dRecord       r = CommonRecord();
    r.colour = Vec4{.x = 300, .y = 40000, .z = -1, .w = 255};

    const oracle::Quad q = oracle::Expand(p, r, 0);
    EXPECT_EQ(q.rgba[0], 300 & 0xFF);
    EXPECT_EQ(q.rgba[1], 0xFF);
    EXPECT_EQ(q.rgba[2], 0xFF);
    EXPECT_EQ(q.rgba[3], 0xFF);

    const Sprite3dQuadF n = Sprite3dExpandNative(p, r, 0);
    EXPECT_FLOAT_EQ(n.rgba[0], 300.0f);
    EXPECT_FLOAT_EQ(n.rgba[2], -1.0f);
}

TEST(Vu1Sprite3dGeom, TagAndPrimConstants) {
    EXPECT_EQ(oracle::Tag(1), 0x8001u);
    EXPECT_EQ(oracle::Tag(33), 0x8021u);
    EXPECT_EQ(oracle::kPrimSprite, 0x5Eu);
    EXPECT_EQ(oracle::kPrimStrip, 0x5Cu);
}
