#include <gtest/gtest.h>

#include <cmath>
#include <cstdint>
#include <limits>

#include "vu1/vu1_math.hpp"
#include "vu1_oracle/vu1_pack.hpp"

namespace {

using namespace dc::vu1;

constexpr float   kInf = std::numeric_limits<float>::infinity();
constexpr float   kNaN = std::numeric_limits<float>::quiet_NaN();
constexpr int32_t kI32Max = std::numeric_limits<int32_t>::max();
constexpr int32_t kI32Min = std::numeric_limits<int32_t>::min();

void ExpectVec(Vec4 got, Vec4 want) {
    EXPECT_FLOAT_EQ(got.x, want.x);
    EXPECT_FLOAT_EQ(got.y, want.y);
    EXPECT_FLOAT_EQ(got.z, want.z);
    EXPECT_FLOAT_EQ(got.w, want.w);
}

void ExpectRel(float got, float want, float rel) {
    EXPECT_LE(std::fabs(got - want), rel * std::fabs(want)) << got << " vs " << want;
}

} // namespace

TEST(Vu1Math, MulByIdentityReturnsVector) {
    ExpectVec(Mul(Identity(), Vec4{.x = 1.5f, .y = -2.0f, .z = 3.0f, .w = 4.0f}), Vec4{.x = 1.5f, .y = -2.0f, .z = 3.0f, .w = 4.0f});
}

TEST(Vu1Math, MulTreatsQuadwordsAsColumns) {
    const Mat4 m{
        {{.x = 2.0f, .y = 0.0f, .z = 0.0f, .w = 0.0f},
         {.x = 0.0f, .y = 3.0f, .z = 0.0f, .w = 0.0f},
         {.x = 0.0f, .y = 0.0f, .z = 4.0f, .w = 0.0f},
         {.x = 10.0f, .y = 20.0f, .z = 30.0f, .w = 1.0f}}
    };
    ExpectVec(Mul(m, Vec4{.x = 1.0f, .y = 2.0f, .z = 3.0f, .w = 1.0f}), Vec4{.x = 12.0f, .y = 26.0f, .z = 42.0f, .w = 1.0f});
}

// (1e8 + 1) rounds back to 1e8 in binary32, so left-to-right gives 0. A reordered sum gives 1.
TEST(Vu1Math, MulAccumulatesLeftToRight) {
    const Mat4 m{
        {{.x = 1e8f, .y = 0.0f, .z = 0.0f, .w = 0.0f},
         {.x = 1.0f, .y = 0.0f, .z = 0.0f, .w = 0.0f},
         {.x = -1e8f, .y = 0.0f, .z = 0.0f, .w = 0.0f},
         {.x = 0.0f, .y = 0.0f, .z = 0.0f, .w = 0.0f}}
    };
    EXPECT_FLOAT_EQ(Mul(m, Vec4{1.0f, 1.0f, 1.0f, 1.0f}).x, 0.0f);
}

TEST(Vu1Math, Dot3IgnoresW) {
    EXPECT_FLOAT_EQ(Dot3(Vec4{1.0f, 2.0f, 3.0f, 9.0f}, Vec4{4.0f, 5.0f, 6.0f, 9.0f}), 32.0f);
}

TEST(Vu1Math, Cross3SetsWToZero) {
    ExpectVec(Cross3(Vec4{.x = 1.0f, .y = 0.0f, .z = 0.0f, .w = 7.0f}, Vec4{.x = 0.0f, .y = 1.0f, .z = 0.0f, .w = 7.0f}),
              Vec4{.x = 0.0f, .y = 0.0f, .z = 1.0f, .w = 0.0f});
}

TEST(Vu1Math, Ftoi0TruncatesTowardZero) {
    EXPECT_EQ(Ftoi0(1.9f), 1);
    EXPECT_EQ(Ftoi0(-1.9f), -1);
    EXPECT_EQ(Ftoi0(-0.7f), 0);
}

TEST(Vu1Math, Ftoi0Saturates) {
    EXPECT_EQ(Ftoi0(3e9f), kI32Max);
    EXPECT_EQ(Ftoi0(kInf), kI32Max);
    EXPECT_EQ(Ftoi0(-3e9f), kI32Min);
    EXPECT_EQ(Ftoi0(-kInf), kI32Min);
    EXPECT_EQ(Ftoi0(2147483520.0f), 2147483520);
}

TEST(Vu1Math, Ftoi0NaNIsZero) {
    EXPECT_EQ(Ftoi0(kNaN), 0);
}

TEST(Vu1Math, Ftoi4TruncatesNegativesTowardZero) {
    EXPECT_EQ(Ftoi4(-0.03f), 0);
    EXPECT_EQ(Ftoi4(-0.1f), -1);
    EXPECT_EQ(Ftoi4(-1.0f), -16);
}

TEST(Vu1Math, Ftoi4ScalesBySixteen) {
    EXPECT_EQ(Ftoi4(2048.0f), 32768);
    EXPECT_EQ(Ftoi4(23.182f), 370);
}

TEST(Vu1Math, Ftoi4Saturates) {
    EXPECT_EQ(Ftoi4(1e9f), kI32Max);
    EXPECT_EQ(Ftoi4(-1e9f), kI32Min);
    EXPECT_EQ(Ftoi4(kInf), kI32Max);
    EXPECT_EQ(Ftoi4(kNaN), 0);
}

// prog0 section 10.3: mgSetFogParam(near = 10, far = 1000, r, g, b, far_value = 0, near_value = 255).
TEST(Vu1Math, Prog0FogLanesMatchQwThreeB) {
    const Fog f = MakeFog(10.0f, 1000.0f, 0.0f, 255.0f);
    ExpectRel(f.offset, -2.5758f, 1e-3f);
    EXPECT_FLOAT_EQ(f.near_value, 255.0f);
    EXPECT_FLOAT_EQ(f.far_value, 0.0f);
    ExpectRel(f.scale, 2575.758f, 1e-3f);
}

TEST(Vu1Math, Prog0FogAtNearIsNearValue) {
    const Fog f = MakeFog(10.0f, 1000.0f, 0.0f, 255.0f);
    EXPECT_NEAR(FogValue(f, 1.0f / 10.0f), 255.0f, 1e-3f);
}

TEST(Vu1Math, Prog0FogAtFarIsFarValue) {
    const Fog f = MakeFog(10.0f, 1000.0f, 0.0f, 255.0f);
    EXPECT_NEAR(FogValue(f, 1.0f / 1000.0f), 0.0f, 1e-3f);
}

TEST(Vu1Math, Prog0FogMidDepthAndFtoi4) {
    const Fog   f = MakeFog(10.0f, 1000.0f, 0.0f, 255.0f);
    const float v = FogValue(f, 1.0f / 100.0f);
    ExpectRel(v, 23.182f, 1e-3f);
    EXPECT_EQ(Ftoi4(v), 370);
}

// Editor fog: far_value = 255, near_value = 0 gives F' = 255 everywhere (no fog).
TEST(Vu1Math, EditorFogIsConstant255) {
    const Fog f = MakeFog(10.0f, 1000.0f, 255.0f, 0.0f);
    EXPECT_NEAR(FogValue(f, 1.0f / 10.0f), 255.0f, 1e-3f);
    EXPECT_NEAR(FogValue(f, 1.0f / 100.0f), 255.0f, 1e-3f);
    EXPECT_NEAR(FogValue(f, 1.0f / 1000.0f), 255.0f, 1e-3f);
}

// prog_3dsp section 10: offset 0.5, near_value 1.0, far_value 0.0, scale 8.0.
TEST(Vu1Math, Prog3dspFogAtPw4ClampsToNearValue) {
    const Fog f{.offset = 0.5f, .near_value = 1.0f, .far_value = 0.0f, .scale = 8.0f};
    EXPECT_FLOAT_EQ(FogValue(f, 1.0f / 4.0f), 1.0f);
}

TEST(Vu1Math, Prog3dspFogAtPw100ClampsToFarValue) {
    const Fog f{.offset = 0.5f, .near_value = 1.0f, .far_value = 0.8f, .scale = 8.0f};
    EXPECT_FLOAT_EQ(FogValue(f, 1.0f / 100.0f), 0.8f);
}

TEST(Vu1Math, Prog3dspFarValueAboveNearValueWins) {
    const Fog   f{.offset = 0.5f, .near_value = 1.0f, .far_value = 2.5f, .scale = 8.0f};
    const float v = FogValue(f, 1.0f / 100.0f);
    EXPECT_FLOAT_EQ(v, 2.5f);
    EXPECT_EQ(Ftoi0(v), 2);
}

TEST(Vu1Math, Prog3dspFogAtPw1Point1ClampsToNearValue) {
    const Fog f{.offset = 0.5f, .near_value = 1.0f, .far_value = 0.0f, .scale = 8.0f};
    EXPECT_FLOAT_EQ(FogValue(f, 1.0f / 1.1f), 1.0f);
}
