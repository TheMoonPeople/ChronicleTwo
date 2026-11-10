#include <gtest/gtest.h>

#include <array>
#include <cstdint>
#include <vector>

#include "vu1_oracle/sdw_oracle.hpp"

namespace dc::vu1 {
namespace {

constexpr float   kTol = 1e-6f;
constexpr int32_t kZc = 2097152;
constexpr int32_t kZt = 0;

struct Scr {
    int32_t  x;
    int32_t  y;
    int32_t  z;
    uint32_t f;
};

Mat4 Rows(Vec4 r0, Vec4 r1, Vec4 r2, Vec4 r3) {
    return {
        {r0, r1, r2, r3}
    };
}

// Spec 10 common setup. Input w is 1.0 everywhere (open point 3).
SdwParams CommonParams() {
    SdwParams p{};
    p.object[0] = {.x = 1, .y = 0, .z = 0, .w = 0};
    p.object[1] = {.x = 0, .y = 1, .z = 0, .w = 0};
    p.object[2] = {.x = 0, .y = 0, .z = 1, .w = 0};
    p.light = {.x = 3, .y = 0, .z = -4, .w = 0};
    p.vc = Identity();
    p.sm = Rows({.x = 1, .y = 0, .z = 0, .w = 0}, {.x = 0, .y = 1, .z = 0, .w = 0}, {.x = 0.75f, .y = 0, .z = 0, .w = 0}, {.x = 0, .y = 0, .z = 0, .w = 1});
    p.cs = Rows({.x = 1, .y = 0, .z = 0, .w = 0}, {.x = 0, .y = 1, .z = 0, .w = 0}, {.x = 0, .y = 0, .z = 4194304.0f, .w = 0}, {.x = 0, .y = 0, .z = 0, .w = 1});
    return p;
}

// Spec 10 test 3: diag(-1,1,1,1) object, VC and SM; CS row 1 x stays 0 (7.3).
SdwParams MirroredParams() {
    SdwParams p = CommonParams();
    p.object[0] = {.x = -1, .y = 0, .z = 0, .w = 0};
    p.vc = Rows({.x = -1, .y = 0, .z = 0, .w = 0}, {.x = 0, .y = 1, .z = 0, .w = 0}, {.x = 0, .y = 0, .z = 1, .w = 0}, {.x = 0, .y = 0, .z = 0, .w = 1});
    p.sm = Rows({.x = -1, .y = 0, .z = 0, .w = 0}, {.x = 0, .y = 1, .z = 0, .w = 0}, {.x = 0.75f, .y = 0, .z = 0, .w = 0}, {.x = 0, .y = 0, .z = 0, .w = 1});
    return p;
}

void ExpectVecNear(Vec4 got, Vec4 want) {
    EXPECT_NEAR(got.x, want.x, kTol);
    EXPECT_NEAR(got.y, want.y, kTol);
    EXPECT_NEAR(got.z, want.z, kTol);
    EXPECT_NEAR(got.w, want.w, kTol);
}

void ExpectQuad(const SdwQuad &quad, const Scr (&want)[4]) {
    for (uint32_t i = 0; i < 4; ++i) {
        EXPECT_EQ(quad.v[i].x, want[i].x) << "vertex " << i;
        EXPECT_EQ(quad.v[i].y, want[i].y) << "vertex " << i;
        EXPECT_EQ(quad.v[i].z, want[i].z) << "vertex " << i;
        EXPECT_EQ(quad.v[i].f, want[i].f) << "vertex " << i;
    }
    EXPECT_EQ(quad.rgbaq, (std::array<uint32_t, 4>{1, 1, 1, 64}));
}

SdwKick Add() {
    return {.kind = SdwKickKind::AlphaAdd, .quad = 0};
}

SdwKick Sub() {
    return {.kind = SdwKickKind::AlphaSub, .quad = 0};
}

SdwKick Quad(uint8_t g) {
    return {.kind = SdwKickKind::Quad, .quad = g};
}

// Spec 5.4 quotes s in 12.4 units; float zsign is the same area times 256.
constexpr float kS(float spec_units) {
    return spec_units / 256.0f;
}

// Test 1: lit, above the plane, path B.
const Scr kTest1Quads[kSdwQuadCount][4] = {
    {{.x = 0, .y = 0, .z = kZc, .f = 1}, {.x = 8, .y = 0, .z = kZc, .f = 1},  {.x = 14, .y = 0, .z = kZt, .f = 1}, {.x = 6, .y = 0, .z = kZt, .f = 1} },
    {{.x = 8, .y = 0, .z = kZc, .f = 1}, {.x = 0, .y = 8, .z = kZc, .f = 1},  {.x = 6, .y = 8, .z = kZt, .f = 1},  {.x = 14, .y = 0, .z = kZt, .f = 1}},
    {{.x = 0, .y = 8, .z = kZc, .f = 1}, {.x = 0, .y = 0, .z = kZc, .f = 1},  {.x = 6, .y = 0, .z = kZt, .f = 1},  {.x = 6, .y = 8, .z = kZt, .f = 1} },
    {{.x = 6, .y = 0, .z = kZt, .f = 1}, {.x = 14, .y = 0, .z = kZt, .f = 1}, {.x = 6, .y = 8, .z = kZt, .f = 1},  {.x = 6, .y = 8, .z = kZt, .f = 1} },
    {{.x = 0, .y = 8, .z = kZc, .f = 1}, {.x = 8, .y = 0, .z = kZc, .f = 1},  {.x = 0, .y = 0, .z = kZc, .f = 1},  {.x = 0, .y = 0, .z = kZc, .f = 1} },
};

// Test 2: back-facing, path A.
const Scr kTest2Quads[kSdwQuadCount][4] = {
    {{.x = 0, .y = 0, .z = kZc, .f = 1},  {.x = 6, .y = 0, .z = kZt, .f = 1},  {.x = 6, .y = 8, .z = kZt, .f = 1},  {.x = 0, .y = 8, .z = kZc, .f = 1}},
    {{.x = 0, .y = 8, .z = kZc, .f = 1},  {.x = 6, .y = 8, .z = kZt, .f = 1},  {.x = 14, .y = 0, .z = kZt, .f = 1}, {.x = 8, .y = 0, .z = kZc, .f = 1}},
    {{.x = 8, .y = 0, .z = kZc, .f = 1},  {.x = 14, .y = 0, .z = kZt, .f = 1}, {.x = 6, .y = 0, .z = kZt, .f = 1},  {.x = 0, .y = 0, .z = kZc, .f = 1}},
    {{.x = 14, .y = 0, .z = kZt, .f = 1}, {.x = 6, .y = 8, .z = kZt, .f = 1},  {.x = 6, .y = 0, .z = kZt, .f = 1},  {.x = 6, .y = 0, .z = kZt, .f = 1}},
    {{.x = 0, .y = 0, .z = kZc, .f = 1},  {.x = 0, .y = 8, .z = kZc, .f = 1},  {.x = 8, .y = 0, .z = kZc, .f = 1},  {.x = 8, .y = 0, .z = kZc, .f = 1}},
};

// Test 3: mirrored, path A.
const Scr kTest3Quads[kSdwQuadCount][4] = {
    {{.x = 0, .y = 0, .z = kZc, .f = 1},  {.x = 6, .y = 0, .z = kZt, .f = 1},  {.x = -2, .y = 0, .z = kZt, .f = 1}, {.x = -8, .y = 0, .z = kZc, .f = 1}},
    {{.x = -8, .y = 0, .z = kZc, .f = 1}, {.x = -2, .y = 0, .z = kZt, .f = 1}, {.x = 6, .y = 8, .z = kZt, .f = 1},  {.x = 0, .y = 8, .z = kZc, .f = 1} },
    {{.x = 0, .y = 8, .z = kZc, .f = 1},  {.x = 6, .y = 8, .z = kZt, .f = 1},  {.x = 6, .y = 0, .z = kZt, .f = 1},  {.x = 0, .y = 0, .z = kZc, .f = 1} },
    {{.x = 6, .y = 8, .z = kZt, .f = 1},  {.x = -2, .y = 0, .z = kZt, .f = 1}, {.x = 6, .y = 0, .z = kZt, .f = 1},  {.x = 6, .y = 0, .z = kZt, .f = 1} },
    {{.x = 0, .y = 0, .z = kZc, .f = 1},  {.x = -8, .y = 0, .z = kZc, .f = 1}, {.x = 0, .y = 8, .z = kZc, .f = 1},  {.x = 0, .y = 8, .z = kZc, .f = 1} },
};

} // namespace

TEST(Vu1SdwGeom, Test1_LightPrepare) {
    const SdwLight light = SdwPrepare(CommonParams());
    ExpectVecNear(light.a_hat, {.x = 0.6f, .y = 0, .z = -0.8f, .w = 0});
    ExpectVecNear(light.lc, {.x = -0.06f, .y = 0, .z = 0.08f, .w = 0});
    EXPECT_FALSE(light.mirrored);
}

TEST(Vu1SdwGeom, Test1_Intermediates) {
    const SdwParams   p = CommonParams();
    const SdwLight    light = SdwPrepare(p);
    const SdwTriangle tri =
        SdwExtrude(p, light, {.x = 0, .y = 0, .z = 0.5f, .w = 1}, {.x = 0.5f, .y = 0, .z = 0.5f, .w = 1}, {.x = 0, .y = 0.5f, .z = 0.5f, .w = 1});

    EXPECT_EQ(tri.reject, SdwReject::None);
    ExpectVecNear(tri.c[0], {.x = 0, .y = 0, .z = 0.5f, .w = 1});
    ExpectVecNear(tri.c[1], {.x = 0.5f, .y = 0, .z = 0.5f, .w = 1});
    ExpectVecNear(tri.c[2], {.x = 0, .y = 0.5f, .z = 0.5f, .w = 1});
    ExpectVecNear(tri.t[0], {.x = 0.375f, .y = 0, .z = 0, .w = 1});
    ExpectVecNear(tri.t[1], {.x = 0.875f, .y = 0, .z = 0, .w = 1});
    ExpectVecNear(tri.t[2], {.x = 0.375f, .y = 0.5f, .z = 0, .w = 1});
    ExpectVecNear(tri.e1, {.x = 0.5f, .y = 0, .z = 0, .w = 0});
    ExpectVecNear(tri.e2, {.x = 0, .y = 0.5f, .z = 0, .w = 0});
    ExpectVecNear(tri.n, {.x = 0, .y = 0, .z = -0.25f, .w = 0});
    EXPECT_NEAR(tri.q, -0.02f, kTol);
    EXPECT_EQ(tri.path, SdwPath::B);
}

TEST(Vu1SdwGeom, Test1_QuadsScreenSignsAndKicks) {
    // Open point 12: quad 0 is zero-area (zsign 0) and is emitted as ADD.
    // Open point 13: Z is not clamped; every Z here is inside [0, 2^24).
    // Open point 16: F uses S.w = w * (1/w) with no truncation correction; w = 1 here.
    const SdwParams   p = CommonParams();
    const SdwTriangle tri =
        SdwExtrude(p, SdwPrepare(p), {.x = 0, .y = 0, .z = 0.5f, .w = 1}, {.x = 0.5f, .y = 0, .z = 0.5f, .w = 1}, {.x = 0, .y = 0.5f, .z = 0.5f, .w = 1});

    for (uint32_t g = 0; g < kSdwQuadCount; ++g) {
        ExpectQuad(tri.quads[g], kTest1Quads[g]);
    }
    EXPECT_NEAR(tri.quads[0].zsign, kS(0), kTol);
    EXPECT_NEAR(tri.quads[1].zsign, kS(48), kTol);
    EXPECT_NEAR(tri.quads[2].zsign, kS(-48), kTol);
    EXPECT_NEAR(tri.quads[3].zsign, kS(-64), kTol);
    EXPECT_NEAR(tri.quads[4].zsign, kS(64), kTol);
    EXPECT_EQ(tri.quads[0].back, false);
    EXPECT_EQ(tri.quads[1].back, false);
    EXPECT_EQ(tri.quads[2].back, true);
    EXPECT_EQ(tri.quads[3].back, true);
    EXPECT_EQ(tri.quads[4].back, false);
    EXPECT_EQ(tri.front_count, 3u);
    EXPECT_EQ(tri.back_count, 2u);
    EXPECT_EQ(tri.kicks, (std::vector<SdwKick>{Add(), Quad(0), Quad(1), Quad(4), Add(), Sub(),
                                               Quad(2), Quad(3), Sub()}));
}

TEST(Vu1SdwGeom, Test2_Intermediates) {
    const SdwParams   p = CommonParams();
    const SdwLight    light = SdwPrepare(p);
    const SdwTriangle tri =
        SdwExtrude(p, light, {.x = 0, .y = 0, .z = 0.5f, .w = 1}, {.x = 0, .y = 0.5f, .z = 0.5f, .w = 1}, {.x = 0.5f, .y = 0, .z = 0.5f, .w = 1});

    EXPECT_EQ(tri.reject, SdwReject::None);
    ExpectVecNear(tri.c[0], {.x = 0, .y = 0, .z = 0.5f, .w = 1});
    ExpectVecNear(tri.c[1], {.x = 0, .y = 0.5f, .z = 0.5f, .w = 1});
    ExpectVecNear(tri.c[2], {.x = 0.5f, .y = 0, .z = 0.5f, .w = 1});
    ExpectVecNear(tri.t[0], {.x = 0.375f, .y = 0, .z = 0, .w = 1});
    ExpectVecNear(tri.t[1], {.x = 0.375f, .y = 0.5f, .z = 0, .w = 1});
    ExpectVecNear(tri.t[2], {.x = 0.875f, .y = 0, .z = 0, .w = 1});
    ExpectVecNear(tri.e1, {.x = 0, .y = 0.5f, .z = 0, .w = 0});
    ExpectVecNear(tri.e2, {.x = 0.5f, .y = 0, .z = 0, .w = 0});
    ExpectVecNear(tri.n, {.x = 0, .y = 0, .z = 0.25f, .w = 0});
    EXPECT_NEAR(tri.q, 0.02f, kTol);
    EXPECT_EQ(tri.path, SdwPath::A);
}

TEST(Vu1SdwGeom, Test2_QuadsScreenSignsAndKicks) {
    // Open point 12: quad 2 is zero-area (zsign 0) and is emitted as ADD.
    // Open point 13 and 16: as in Test1_QuadsScreenSignsAndKicks.
    const SdwParams   p = CommonParams();
    const SdwTriangle tri =
        SdwExtrude(p, SdwPrepare(p), {.x = 0, .y = 0, .z = 0.5f, .w = 1}, {.x = 0, .y = 0.5f, .z = 0.5f, .w = 1}, {.x = 0.5f, .y = 0, .z = 0.5f, .w = 1});

    for (uint32_t g = 0; g < kSdwQuadCount; ++g) {
        ExpectQuad(tri.quads[g], kTest2Quads[g]);
    }
    EXPECT_NEAR(tri.quads[0].zsign, kS(-48), kTol);
    EXPECT_NEAR(tri.quads[1].zsign, kS(48), kTol);
    EXPECT_NEAR(tri.quads[2].zsign, kS(0), kTol);
    EXPECT_NEAR(tri.quads[3].zsign, kS(-64), kTol);
    EXPECT_NEAR(tri.quads[4].zsign, kS(64), kTol);
    EXPECT_EQ(tri.quads[0].back, true);
    EXPECT_EQ(tri.quads[1].back, false);
    EXPECT_EQ(tri.quads[2].back, false);
    EXPECT_EQ(tri.quads[3].back, true);
    EXPECT_EQ(tri.quads[4].back, false);
    EXPECT_EQ(tri.front_count, 3u);
    EXPECT_EQ(tri.back_count, 2u);
    EXPECT_EQ(tri.kicks, (std::vector<SdwKick>{Add(), Quad(1), Quad(2), Quad(4), Add(), Sub(),
                                               Quad(0), Quad(3), Sub()}));
}

TEST(Vu1SdwGeom, Test3_LightPrepareMirrored) {
    const SdwLight light = SdwPrepare(MirroredParams());
    ExpectVecNear(light.a_hat, {.x = -0.6f, .y = 0, .z = -0.8f, .w = 0});
    ExpectVecNear(light.lc, {.x = -0.06f, .y = 0, .z = 0.08f, .w = 0});
    EXPECT_TRUE(light.mirrored);
}

TEST(Vu1SdwGeom, Test3_Intermediates) {
    const SdwParams   p = MirroredParams();
    const SdwLight    light = SdwPrepare(p);
    const SdwTriangle tri =
        SdwExtrude(p, light, {.x = 0, .y = 0, .z = 0.5f, .w = 1}, {.x = 0.5f, .y = 0, .z = 0.5f, .w = 1}, {.x = 0, .y = 0.5f, .z = 0.5f, .w = 1});

    EXPECT_EQ(tri.reject, SdwReject::None);
    ExpectVecNear(tri.c[0], {.x = 0, .y = 0, .z = 0.5f, .w = 1});
    ExpectVecNear(tri.c[1], {.x = -0.5f, .y = 0, .z = 0.5f, .w = 1});
    ExpectVecNear(tri.c[2], {.x = 0, .y = 0.5f, .z = 0.5f, .w = 1});
    ExpectVecNear(tri.t[0], {.x = 0.375f, .y = 0, .z = 0, .w = 1});
    ExpectVecNear(tri.t[1], {.x = -0.125f, .y = 0, .z = 0, .w = 1});
    ExpectVecNear(tri.t[2], {.x = 0.375f, .y = 0.5f, .z = 0, .w = 1});
    ExpectVecNear(tri.e1, {.x = -0.5f, .y = 0, .z = 0, .w = 0});
    ExpectVecNear(tri.e2, {.x = 0, .y = 0.5f, .z = 0, .w = 0});
    ExpectVecNear(tri.n, {.x = 0, .y = 0, .z = 0.25f, .w = 0});
    EXPECT_NEAR(tri.q, 0.02f, kTol);
    EXPECT_EQ(tri.path, SdwPath::A);
}

TEST(Vu1SdwGeom, Test3_QuadsScreenSignsAndKicks) {
    // Open point 12: quad 0 is zero-area (zsign -0.0, not negative) and is emitted as ADD.
    // Open point 13 and 16: as in Test1_QuadsScreenSignsAndKicks.
    const SdwParams   p = MirroredParams();
    const SdwTriangle tri =
        SdwExtrude(p, SdwPrepare(p), {.x = 0, .y = 0, .z = 0.5f, .w = 1}, {.x = 0.5f, .y = 0, .z = 0.5f, .w = 1}, {.x = 0, .y = 0.5f, .z = 0.5f, .w = 1});

    for (uint32_t g = 0; g < kSdwQuadCount; ++g) {
        ExpectQuad(tri.quads[g], kTest3Quads[g]);
    }
    EXPECT_NEAR(tri.quads[0].zsign, kS(0), kTol);
    EXPECT_NEAR(tri.quads[1].zsign, kS(-48), kTol);
    EXPECT_NEAR(tri.quads[2].zsign, kS(48), kTol);
    EXPECT_NEAR(tri.quads[3].zsign, kS(-64), kTol);
    EXPECT_NEAR(tri.quads[4].zsign, kS(64), kTol);
    EXPECT_EQ(tri.quads[0].back, false);
    EXPECT_EQ(tri.quads[1].back, true);
    EXPECT_EQ(tri.quads[2].back, false);
    EXPECT_EQ(tri.quads[3].back, true);
    EXPECT_EQ(tri.quads[4].back, false);
    EXPECT_EQ(tri.front_count, 3u);
    EXPECT_EQ(tri.back_count, 2u);
    EXPECT_EQ(tri.kicks, (std::vector<SdwKick>{Add(), Quad(0), Quad(2), Quad(4), Add(), Sub(),
                                               Quad(1), Quad(3), Sub()}));
}

// Spec 10 has no vector for these rejects. Inputs are derived from 7.1 on the common setup:
// C1.x = V1.x, so V1.x = 1.5 puts C1 outside |w|; T1.x = V1.x + 0.75 * V1.z = 1.275 puts T1
// outside |w| while C1 stays inside.
TEST(Vu1SdwGeom, CClipRejectsWholeTriangle) {
    const SdwParams   p = CommonParams();
    const SdwTriangle tri =
        SdwExtrude(p, SdwPrepare(p), {.x = 0, .y = 0, .z = 0.5f, .w = 1}, {.x = 1.5f, .y = 0, .z = 0.5f, .w = 1}, {.x = 0, .y = 0.5f, .z = 0.5f, .w = 1});
    EXPECT_EQ(tri.reject, SdwReject::CClip);
    EXPECT_TRUE(tri.kicks.empty());
}

TEST(Vu1SdwGeom, TClipRejectsWholeTriangle) {
    const SdwParams   p = CommonParams();
    const SdwTriangle tri =
        SdwExtrude(p, SdwPrepare(p), {.x = 0, .y = 0, .z = 0.5f, .w = 1}, {.x = 0.9f, .y = 0, .z = 0.5f, .w = 1}, {.x = 0, .y = 0.5f, .z = 0.5f, .w = 1});
    EXPECT_EQ(tri.reject, SdwReject::TClip);
    EXPECT_TRUE(tri.kicks.empty());
}

// Light (3,0,0): A = (3,0,0), Ahat = (1,0,0), Lc = (-0.1,0,0). N = (0,0,-0.25) gives Q = 0.
TEST(Vu1SdwGeom, GrazingRejectsZeroFacing) {
    SdwParams p = CommonParams();
    p.light = {.x = 3, .y = 0, .z = 0, .w = 0};
    const SdwTriangle tri =
        SdwExtrude(p, SdwPrepare(p), {.x = 0, .y = 0, .z = 0.5f, .w = 1}, {.x = 0.5f, .y = 0, .z = 0.5f, .w = 1}, {.x = 0, .y = 0.5f, .z = 0.5f, .w = 1});
    EXPECT_EQ(tri.reject, SdwReject::Grazing);
    EXPECT_NEAR(tri.q, 0.0f, kTol);
    EXPECT_TRUE(tri.kicks.empty());
}

// Spec 6.5 row 2 (F >= 1, B = 0) and row 1 (F, B >= 1) are covered by the Test cases above.
// Spec 10 notes no vector reaches F = 0, so the F = 0 and B = 0 cases are synthetic here and
// test SdwKickOrder directly.
TEST(Vu1SdwGeom, KickOrder_AllFrontHasNoSubBlock) {
    const std::vector<SdwKick> kicks = SdwKickOrder({false, false, false, false, false});
    EXPECT_EQ(kicks, (std::vector<SdwKick>{Add(), Quad(0), Quad(1), Quad(2), Quad(3), Quad(4),
                                           Add()}));
}

// Open point 6: back quads are dropped when F = 0 (6.5). This follows retail, not the apparent intent.
TEST(Vu1SdwGeom, KickOrder_AllBackDropsBackQuads) {
    const std::vector<SdwKick> kicks = SdwKickOrder({true, true, true, true, true});
    EXPECT_EQ(kicks, (std::vector<SdwKick>{Add()}));
}

TEST(Vu1SdwGeom, KickOrder_OneFrontFourBack) {
    const std::vector<SdwKick> kicks = SdwKickOrder({true, true, false, true, true});
    EXPECT_EQ(kicks, (std::vector<SdwKick>{Add(), Quad(2), Add(), Sub(), Quad(0), Quad(1),
                                           Quad(3), Quad(4), Sub()}));
}

} // namespace dc::vu1
