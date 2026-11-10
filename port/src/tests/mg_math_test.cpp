#include "common.h"

#include <gtest/gtest.h>

#include <cfloat>
#include <climits>
#include <cmath>
#include <cstdlib>
#include <initializer_list>
#include <limits>

#include "mg_drawenv.hpp"
#include "mg_math.hpp"

namespace {

void expect_lanes(const float *got, std::initializer_list<float> want) {
    int i = 0;
    for (float w : want) {
        EXPECT_FLOAT_EQ(got[i], w) << "lane " << i;
        i++;
    }
}

void expect_matrix(float (*got)[4], const float want[4][4]) {
    for (int r = 0; r < 4; r++) {
        for (int k = 0; k < 4; k++) {
            EXPECT_FLOAT_EQ(got[r][k], want[r][k]) << "row " << r << " col " << k;
        }
    }
}

} // namespace

TEST(MgMath, AngleLimitBoundsEveryFiniteFloatAndRejectsNonfiniteInput) {
    for (const float angle : {0.0f, -0.0f, 0.25f, -0.25f, PI, -PI, TWO_PI, -TWO_PI, FLT_MAX, -FLT_MAX}) {
        const float limited = mgAngleLimit(angle);
        EXPECT_TRUE(std::isfinite(limited));
        EXPECT_GE(limited, -PI);
        EXPECT_LE(limited, PI);
    }
    EXPECT_FLOAT_EQ(mgAngleLimit(0.25f), 0.25f);
    EXPECT_FLOAT_EQ(mgAngleLimit(-0.25f), -0.25f);
    EXPECT_FLOAT_EQ(mgAngleLimit(std::numeric_limits<float>::infinity()), 0.0f);
    EXPECT_FLOAT_EQ(mgAngleLimit(-std::numeric_limits<float>::infinity()), 0.0f);
    EXPECT_FLOAT_EQ(mgAngleLimit(std::numeric_limits<float>::quiet_NaN()), 0.0f);
}

TEST(MgMath, QuantizedTrigonometryKeepsOrdinaryAccuracyAndBoundsExtremeInputs) {
    for (const float angle : {-20.0f, -TWO_PI, -PI, -0.25f, 0.0f, 0.25f, PI, TWO_PI, 20.0f}) {
        EXPECT_NEAR(mgSinf(angle), std::sin(angle), 0.007f);
        EXPECT_NEAR(mgCosf(angle), std::cos(angle), 0.007f);
    }
    for (const float angle : {FLT_MAX, -FLT_MAX}) {
        EXPECT_TRUE(std::isfinite(mgSinf(angle)));
        EXPECT_LE(std::fabs(mgSinf(angle)), 1.0f);
        EXPECT_TRUE(std::isfinite(mgCosf(angle)));
        EXPECT_LE(std::fabs(mgCosf(angle)), 1.0f);
    }
    for (const float angle : {std::numeric_limits<float>::infinity(), -std::numeric_limits<float>::infinity(),
                              std::numeric_limits<float>::quiet_NaN()}) {
        EXPECT_FLOAT_EQ(mgSinf(angle), 0.0f);
        EXPECT_FLOAT_EQ(mgCosf(angle), 0.0f);
    }
}

TEST(MgMathDeathTest, RandomMaximumRemainsBelowOne) {
    ASSERT_EXIT(
        {
            std::srand(0x0dbdbb1e);
            const float value = mgRnd();
            std::_Exit(value >= 0.0f && value < 1.0f ? EXIT_SUCCESS : EXIT_FAILURE);
        },
        ::testing::ExitedWithCode(EXIT_SUCCESS), "");
}

TEST(MgMath, FotI4TruncatesTowardZeroAfterSixteenthScale) {
    float in[4] = {1.5f, -1.5f, 0.0625f, -0.03f};
    int   out[4] = {0, 0, 0, 0};
    mgFotI4(out, in);
    EXPECT_EQ(out[0], 24);
    EXPECT_EQ(out[1], -24);
    EXPECT_EQ(out[2], 1);
    EXPECT_EQ(out[3], 0);
}

TEST(MgMath, SphereSegmentReportsOnlyWrittenCrossings) {
    float from[4] = {-2.0f, 1.0f, 0.0f, 1.0f};
    float to[4] = {-1.0f, 1.0f, 0.0f, 1.0f};
    float hits[2][4] = {
        {99.0f, 99.0f, 99.0f, 99.0f},
        {99.0f, 99.0f, 99.0f, 99.0f}
    };
    EXPECT_EQ(mgIntersectionSphereLine0(1.0f, from, to, hits), 0);
    expect_lanes(hits[0], {99.0f, 99.0f, 99.0f, 99.0f});
    to[0] = 2.0f;
    ASSERT_EQ(mgIntersectionSphereLine0(1.0f, from, to, hits), 1);
    EXPECT_FLOAT_EQ(hits[0][0], 0.0f);
    EXPECT_FLOAT_EQ(hits[0][1], 1.0f);
    expect_lanes(hits[1], {99.0f, 99.0f, 99.0f, 99.0f});
    from[1] = 0.0f;
    to[1] = 0.0f;
    ASSERT_EQ(mgIntersectionSphereLine0(1.0f, from, to, hits), 2);
    EXPECT_FLOAT_EQ(hits[0][0], -1.0f);
    EXPECT_FLOAT_EQ(hits[1][0], 1.0f);
}

TEST(MgMath, SphereSegmentRejectsShortOutputAndDegenerateInputsBeforeWriting) {
    float from[4] = {-2.0f, 0.0f, 0.0f, 1.0f};
    float to[4] = {2.0f, 0.0f, 0.0f, 1.0f};
    float hits[2][4] = {
        {99.0f, 99.0f, 99.0f, 99.0f},
        {99.0f, 99.0f, 99.0f, 99.0f}
    };
    EXPECT_EQ(mgIntersectionSphereLine0(1.0f, from, to, std::span(hits).first(1)), 0);
    EXPECT_EQ(mgIntersectionSphereLine0(1.0f, from, from, hits), 0);
    EXPECT_EQ(mgIntersectionSphereLine0(-1.0f, from, to, hits), 0);
    EXPECT_EQ(mgIntersectionSphereLine0(std::numeric_limits<float>::infinity(), from, to, hits), 0);
    to[0] = std::numeric_limits<float>::quiet_NaN();
    EXPECT_EQ(mgIntersectionSphereLine0(1.0f, from, to, hits), 0);
    to[0] = FLT_MAX;
    EXPECT_EQ(mgIntersectionSphereLine0(1.0f, from, to, hits), 0);
    expect_lanes(hits[0], {99.0f, 99.0f, 99.0f, 99.0f});
    expect_lanes(hits[1], {99.0f, 99.0f, 99.0f, 99.0f});
}

TEST(MgMath, FotI4SaturatesFiniteOverflow) {
    float in[4] = {1.0e10f, -1.0e10f, 0.0f, 0.0f};
    int   out[4] = {0, 0, 0, 0};
    mgFotI4(out, in);
    EXPECT_EQ(out[0], INT_MAX);
    EXPECT_EQ(out[1], INT_MIN);
    EXPECT_EQ(out[2], 0);
}

TEST(MgMath, FotI4SaturatesAtExactBoundary) {
    float in[4] = {134217728.0f, -134217728.0f, 134217712.0f, 0.0f};
    int   out[4] = {0, 0, 0, 0};
    mgFotI4(out, in);
    EXPECT_EQ(out[0], INT_MAX);
    EXPECT_EQ(out[1], INT_MIN);
    EXPECT_EQ(out[2], 2147483392);
}

TEST(MgMath, CreateBox8PlacesEachCornerByBitIndex) {
    float max[4] = {5.0f, 6.0f, 7.0f, 8.0f};
    float min[4] = {1.0f, 2.0f, 3.0f, 4.0f};
    float corners[8][4];
    mgCreateBox8(corners, max, min);
    expect_lanes(corners[0], {1, 2, 3, 4});
    expect_lanes(corners[1], {5, 2, 3, 4});
    expect_lanes(corners[2], {1, 6, 3, 4});
    expect_lanes(corners[3], {5, 6, 3, 8});
    expect_lanes(corners[4], {1, 2, 7, 4});
    expect_lanes(corners[5], {5, 2, 7, 8});
    expect_lanes(corners[6], {1, 6, 7, 8});
    expect_lanes(corners[7], {5, 6, 7, 8});
}

TEST(MgMath, CreateBox8NegativeZeroBecomesPositiveOnMixedCorners) {
    float max[4] = {1.0f, 1.0f, 1.0f, 1.0f};
    float min[4] = {-0.0f, -0.0f, -0.0f, -0.0f};
    float corners[8][4];
    mgCreateBox8(corners, max, min);
    EXPECT_TRUE(std::signbit(corners[0][0]));
    EXPECT_FALSE(std::signbit(corners[1][1]));
    EXPECT_FALSE(std::signbit(corners[2][0]));
}

TEST(MgMath, CreateBox8DegenerateBoxHasOneCorner) {
    float p[4] = {2.0f, -3.0f, 4.0f, 1.0f};
    float corners[8][4];
    mgCreateBox8(corners, p, p);
    for (auto &corner : corners) {
        expect_lanes(corner, {2, -3, 4, 1});
    }
}

TEST(MgMath, ZeroVectorAcceptsFloatAlignedMembersAndPreservesNeighbors) {
    struct alignas(16) {
        float before;
        float vector[4];
        float after;
    } storage{
        .before = 17.0f, .vector = {1.0f, -2.0f, 3.0f, -4.0f},
             .after = 23.0f
    };

    mgZeroVector(storage.vector);

    expect_lanes(storage.vector, {0, 0, 0, 0});
    for (float lane : storage.vector) {
        EXPECT_FALSE(std::signbit(lane));
    }
    EXPECT_FLOAT_EQ(storage.before, 17.0f);
    EXPECT_FLOAT_EQ(storage.after, 23.0f);
}

TEST(MgMath, ZeroVectorWWritesOriginAndUnitW) {
    float v[4] = {9.0f, 9.0f, 9.0f, 9.0f};
    mgZeroVectorW(v);
    expect_lanes(v, {0, 0, 0, 1});
}

TEST(MgMath, ClipBoxVertexIsInclusiveOnEveryFace) {
    float max[4] = {2.0f, 2.0f, 2.0f, 0.0f};
    float min[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    float inside[4] = {1.0f, 1.0f, 1.0f, 0.0f};
    float on_max[4] = {2.0f, 2.0f, 2.0f, 0.0f};
    float on_min[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    float beyond_x[4] = {2.5f, 1.0f, 1.0f, 0.0f};
    float below_x[4] = {-0.1f, 1.0f, 1.0f, 0.0f};
    EXPECT_EQ(mgClipBoxVertex(inside, max, min), 1);
    EXPECT_EQ(mgClipBoxVertex(on_max, max, min), 1);
    EXPECT_EQ(mgClipBoxVertex(on_min, max, min), 1);
    EXPECT_EQ(mgClipBoxVertex(beyond_x, max, min), 0);
    EXPECT_EQ(mgClipBoxVertex(below_x, max, min), 0);
}

TEST(MgMath, ClipBoxVertexIgnoresW) {
    float max[4] = {2.0f, 2.0f, 2.0f, 0.0f};
    float min[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    float p[4] = {1.0f, 1.0f, 1.0f, 50.0f};
    EXPECT_EQ(mgClipBoxVertex(p, max, min), 1);
}

TEST(MgMath, ClipBoxOverlapRequiresAllThreeAxes) {
    float max0[4] = {2.0f, 2.0f, 2.0f, 0.0f};
    float min0[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    float max1[4] = {3.0f, 3.0f, 3.0f, 0.0f};
    float min1[4] = {1.0f, 1.0f, 1.0f, 0.0f};
    EXPECT_EQ(mgClipBox(max0, min0, max1, min1), 1);

    float min1_x[4] = {3.0f, 1.0f, 1.0f, 0.0f};
    float max1_x[4] = {4.0f, 3.0f, 3.0f, 0.0f};
    EXPECT_EQ(mgClipBox(max0, min0, max1_x, min1_x), 0);
}

TEST(MgMath, ClipBoxTouchingFacesOverlap) {
    float max0[4] = {2.0f, 2.0f, 2.0f, 0.0f};
    float min0[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    float max1[4] = {4.0f, 4.0f, 4.0f, 0.0f};
    float min1[4] = {2.0f, 2.0f, 2.0f, 0.0f};
    EXPECT_EQ(mgClipBox(max0, min0, max1, min1), 1);
}

TEST(MgMath, ClipBoxWIgnoresZAndTestsW) {
    float max0[4] = {2.0f, 2.0f, 2.0f, 2.0f};
    float min0[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    float max1[4] = {3.0f, 3.0f, -5.0f, 3.0f};
    float min1[4] = {1.0f, 1.0f, -6.0f, 1.0f};
    EXPECT_EQ(mgClipBox(max0, min0, max1, min1), 0);
    EXPECT_EQ(mgClipBoxW(max0, min0, max1, min1), 1);

    float max1_w[4] = {3.0f, 3.0f, 3.0f, -1.0f};
    float min1_w[4] = {1.0f, 1.0f, 1.0f, -2.0f};
    EXPECT_EQ(mgClipBoxW(max0, min0, max1_w, min1_w), 0);
}

TEST(MgMath, ClipInBoxRequiresContainmentOnAllAxes) {
    float max0[4] = {2.0f, 2.0f, 2.0f, 0.0f};
    float min0[4] = {1.0f, 1.0f, 1.0f, 0.0f};
    float max1[4] = {3.0f, 3.0f, 3.0f, 0.0f};
    float min1[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    EXPECT_EQ(mgClipInBox(max0, min0, max1, min1), 1);
    EXPECT_EQ(mgClipInBox(max1, min1, max0, min0), 0);
    EXPECT_EQ(mgClipInBox(max0, min0, max0, min0), 1);

    float max1_x[4] = {1.5f, 3.0f, 3.0f, 0.0f};
    EXPECT_EQ(mgClipInBox(max0, min0, max1_x, min1), 0);
}

TEST(MgMath, ClipInBoxWIgnoresZ) {
    float max0[4] = {2.0f, 2.0f, 2.0f, 2.0f};
    float min0[4] = {1.0f, 1.0f, 1.0f, 1.0f};
    float max1[4] = {3.0f, 3.0f, 0.0f, 3.0f};
    float min1[4] = {0.0f, 0.0f, 5.0f, 0.0f};
    EXPECT_EQ(mgClipInBox(max0, min0, max1, min1), 0);
    EXPECT_EQ(mgClipInBoxW(max0, min0, max1, min1), 1);
}

TEST(MgMath, AddVectorWritesAllFourLanes) {
    float v[4] = {1.0f, 2.0f, 3.0f, 4.0f};
    float a[4] = {10.0f, 20.0f, 30.0f, 40.0f};
    mgAddVector(v, a);
    expect_lanes(v, {11, 22, 33, 44});
}

TEST(MgMath, AddVectorAliasedWithItselfDoubles) {
    float v[4] = {1.0f, -2.0f, 3.0f, 0.5f};
    mgAddVector(v, v);
    expect_lanes(v, {2, -4, 6, 1});
}

TEST(MgMath, SubVectorWritesAllFourLanes) {
    float v[4] = {1.0f, 2.0f, 3.0f, 4.0f};
    float s[4] = {1.0f, 5.0f, 3.0f, 6.0f};
    mgSubVector(v, s);
    expect_lanes(v, {0, -3, 0, -2});
}

TEST(MgMath, SubVectorAliasedWithItselfIsZero) {
    float v[4] = {1.0f, -2.0f, 3.0f, 0.5f};
    mgSubVector(v, v);
    expect_lanes(v, {0, 0, 0, 0});
}

TEST(MgMath, NormalizeVectorScalesUnitDirectionAndForcesZeroW) {
    float in[4] = {3.0f, 0.0f, 4.0f, 9.0f};
    float out[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    mgNormalizeVector(out, in, 10.0f);
    EXPECT_NEAR(out[0], 6.0f, 1e-5f);
    EXPECT_NEAR(out[1], 0.0f, 1e-5f);
    EXPECT_NEAR(out[2], 8.0f, 1e-5f);
    EXPECT_FLOAT_EQ(out[3], 0.0f);
}

TEST(MgMath, NormalizeVectorZeroLengthStaysZero) {
    float in[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    float out[4] = {7.0f, 7.0f, 7.0f, 7.0f};
    mgNormalizeVector(out, in, 5.0f);
    expect_lanes(out, {0, 0, 0, 0});
}

TEST(MgMath, NormalizeVectorInPlace) {
    float v[4] = {0.0f, 2.0f, 0.0f, 0.0f};
    mgNormalizeVector(v, v, 3.0f);
    EXPECT_NEAR(v[1], 3.0f, 1e-5f);
    EXPECT_FLOAT_EQ(v[3], 0.0f);
}

TEST(MgMath, VectorMinTwoOperands) {
    float a[4] = {1.0f, 5.0f, -2.0f, 7.0f};
    float b[4] = {3.0f, 2.0f, -2.0f, 9.0f};
    float m[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    mgVectorMin(m, a, b);
    expect_lanes(m, {1, 2, -2, 7});
}

TEST(MgMath, VectorMinFourOperands) {
    float a[4] = {4.0f, 4.0f, 4.0f, 4.0f};
    float b[4] = {3.0f, 9.0f, 9.0f, 9.0f};
    float c[4] = {9.0f, 2.0f, 9.0f, 9.0f};
    float d[4] = {9.0f, 9.0f, 1.0f, 9.0f};
    float m[4];
    mgVectorMin(m, a, b, c, d);
    expect_lanes(m, {3, 2, 1, 4});
}

TEST(MgMath, VectorMaxMinTwoOperands) {
    float a[4] = {1.0f, 5.0f, -2.0f, 7.0f};
    float b[4] = {3.0f, 2.0f, -2.0f, 9.0f};
    float hi[4];
    float lo[4];
    mgVectorMaxMin(hi, lo, a, b);
    expect_lanes(hi, {3, 5, -2, 9});
    expect_lanes(lo, {1, 2, -2, 7});
}

TEST(MgMath, VectorMaxMinThreeOperands) {
    float a[4] = {1.0f, 5.0f, 0.0f, 0.0f};
    float b[4] = {3.0f, 2.0f, 0.0f, 0.0f};
    float c[4] = {2.0f, 6.0f, -1.0f, 0.0f};
    float hi[4];
    float lo[4];
    mgVectorMaxMin(hi, lo, a, b, c);
    expect_lanes(hi, {3, 6, 0, 0});
    expect_lanes(lo, {1, 2, -1, 0});
}

TEST(MgMath, VectorMaxMinFourOperands) {
    float a[4] = {1.0f, 1.0f, 1.0f, 1.0f};
    float b[4] = {2.0f, 2.0f, 2.0f, 2.0f};
    float c[4] = {3.0f, 0.0f, 0.0f, 0.0f};
    float d[4] = {-4.0f, 0.0f, 5.0f, 0.0f};
    float hi[4];
    float lo[4];
    mgVectorMaxMin(hi, lo, a, b, c, d);
    expect_lanes(hi, {3, 2, 5, 2});
    expect_lanes(lo, {-4, 0, 0, 0});
}

TEST(MgMath, VectorMaxMinInPlaceOutputOverlappingInput) {
    float a[4] = {1.0f, 5.0f, 0.0f, 0.0f};
    float b[4] = {3.0f, 2.0f, 0.0f, 0.0f};
    mgVectorMaxMin(a, b, a, b);
    expect_lanes(a, {3, 5, 0, 0});
    expect_lanes(b, {1, 2, 0, 0});
}

TEST(MgMath, BoxMaxMinGrowsToEnclosePatch) {
    mgVu0FBOX box{};
    mgVu0FBOX other{};
    float     bmax[4] = {1.0f, 1.0f, 1.0f, 1.0f};
    float     bmin[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    float     omax[4] = {3.0f, -1.0f, 2.0f, 0.0f};
    float     omin[4] = {-2.0f, 0.0f, 0.0f, 0.0f};
    for (int i = 0; i < 4; i++) {
        box.max[i] = bmax[i];
        box.min[i] = bmin[i];
        other.max[i] = omax[i];
        other.min[i] = omin[i];
    }
    mgBoxMaxMin(&box, &other);
    expect_lanes(box.max, {3, 1, 2, 1});
    expect_lanes(box.min, {-2, -1, 0, 0});
}

TEST(MgMath, PlaneNormalIsCrossOfEdges) {
    float v0[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    float v1[4] = {1.0f, 0.0f, 0.0f, 1.0f};
    float v2[4] = {0.0f, 1.0f, 0.0f, 1.0f};
    float n[4] = {0.0f, 0.0f, 0.0f, 42.0f};
    mgPlaneNormal(n, v0, v1, v2);
    EXPECT_FLOAT_EQ(n[0], 0.0f);
    EXPECT_FLOAT_EQ(n[1], 0.0f);
    EXPECT_FLOAT_EQ(n[2], 1.0f);
    EXPECT_FLOAT_EQ(n[3], 42.0f);
}

TEST(MgMath, PlaneNormalCollinearPointsGiveZero) {
    float v0[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    float v1[4] = {1.0f, 2.0f, 3.0f, 0.0f};
    float v2[4] = {2.0f, 4.0f, 6.0f, 0.0f};
    float n[4] = {9.0f, 9.0f, 9.0f, 9.0f};
    mgPlaneNormal(n, v0, v1, v2);
    expect_lanes(n, {0, 0, 0, 9});
}

TEST(MgMath, DistVectorIsEuclideanLengthIgnoringW) {
    float v[4] = {3.0f, 4.0f, 12.0f, 99.0f};
    EXPECT_FLOAT_EQ(mgDistVector(v), 13.0f);
}

TEST(MgMath, DistVectorZeroLengthIsZero) {
    float v[4] = {0.0f, 0.0f, 0.0f, 5.0f};
    EXPECT_FLOAT_EQ(mgDistVector(v), 0.0f);
    EXPECT_FLOAT_EQ(mgDistVectorXZ(v), 0.0f);
    EXPECT_FLOAT_EQ(mgDistVector2(v), 0.0f);
}

TEST(MgMath, DistVectorXZDropsY) {
    float v[4] = {3.0f, 100.0f, 4.0f, 0.0f};
    EXPECT_FLOAT_EQ(mgDistVectorXZ(v), 5.0f);
}

TEST(MgMath, DistVector2IsSquaredLength) {
    float v[4] = {1.0f, 2.0f, 2.0f, 0.0f};
    EXPECT_FLOAT_EQ(mgDistVector2(v), 9.0f);
}

TEST(MgMath, DistVectorBetweenPoints) {
    float a[4] = {1.0f, 1.0f, 1.0f, 0.0f};
    float b[4] = {4.0f, 5.0f, 1.0f, 0.0f};
    EXPECT_FLOAT_EQ(mgDistVector(a, b), 5.0f);
    EXPECT_FLOAT_EQ(mgDistVector2(a, b), 25.0f);
}

TEST(MgMath, DistVectorXZBetweenPointsIgnoresY) {
    float a[4] = {1.0f, 0.0f, 1.0f, 0.0f};
    float b[4] = {4.0f, 100.0f, 5.0f, 0.0f};
    EXPECT_FLOAT_EQ(mgDistVectorXZ(a, b), 5.0f);
    EXPECT_FLOAT_EQ(mgDistVectorXZ2(a, b), 25.0f);
}

TEST(MgMath, DistVectorBetweenPointsIgnoresW) {
    float a[4] = {0.0f, 0.0f, 0.0f, -7.0f};
    float b[4] = {0.0f, 0.0f, 0.0f, 7.0f};
    EXPECT_FLOAT_EQ(mgDistVector(a, b), 0.0f);
    EXPECT_FLOAT_EQ(mgDistVector2(a, b), 0.0f);
}

TEST(MgMath, UnitAndZeroMatrix) {
    float m[4][4];
    mgUnitMatrix(m);
    const float id[4][4] = {
        {1, 0, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {0, 0, 0, 1}
    };
    expect_matrix(m, id);
    mgZeroMatrix(m);
    const float zero[4][4] = {};
    expect_matrix(m, zero);
}

TEST(MgMath, MulMatrix3AppliesSecondThenThirdOnTheLeft) {
    float matrix[4][4] = {
        {2, 0, 0, 0},
        {0, 2, 0, 0},
        {0, 0, 2, 0},
        {0, 0, 0, 1}
    };
    float second[4][4] = {
        {1, 0, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {1, 2, 3, 1}
    };
    float third[4][4];
    mgUnitMatrix(third);
    MulMatrix3(matrix, second, third);
    const float want[4][4] = {
        {2, 0, 0, 0},
        {0, 2, 0, 0},
        {0, 0, 2, 0},
        {2, 4, 6, 1}
    };
    expect_matrix(matrix, want);
}

TEST(MgMath, MulMatrix3IdentityLeavesMatrixUnchanged) {
    float matrix[4][4] = {
        {1, 2, 3, 0},
        {4, 5, 6, 0},
        {7, 8, 9, 0},
        {1, 2, 3, 1}
    };
    float id[4][4];
    mgUnitMatrix(id);
    const float before[4][4] = {
        {1, 2, 3, 0},
        {4, 5, 6, 0},
        {7, 8, 9, 0},
        {1, 2, 3, 1}
    };
    MulMatrix3(matrix, id, id);
    expect_matrix(matrix, before);
}

TEST(MgMath, MulMatrixProductIsRightTimesLeft) {
    float scale[4][4] = {
        {2, 0, 0, 0},
        {0, 2, 0, 0},
        {0, 0, 2, 0},
        {0, 0, 0, 1}
    };
    float trans[4][4] = {
        {1, 0, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {1, 2, 3, 1}
    };
    float product[4][4];
    mgMulMatrix(product, scale, trans);
    const float trans_then_scale_row3[4] = {2, 4, 6, 1};
    EXPECT_FLOAT_EQ(product[3][0], trans_then_scale_row3[0]);
    EXPECT_FLOAT_EQ(product[3][1], trans_then_scale_row3[1]);
    EXPECT_FLOAT_EQ(product[3][2], trans_then_scale_row3[2]);
    EXPECT_FLOAT_EQ(product[3][3], trans_then_scale_row3[3]);

    mgMulMatrix(product, trans, scale);
    expect_lanes(product[3], {1, 2, 3, 1});
}

TEST(MgMath, MulMatrixInPlaceAliasing) {
    float a[4][4] = {
        {2, 0, 0, 0},
        {0, 2, 0, 0},
        {0, 0, 2, 0},
        {0, 0, 0, 1}
    };
    float b[4][4] = {
        {1, 0, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {1, 2, 3, 1}
    };
    mgMulMatrix(a, a, b);
    const float want[4][4] = {
        {2, 0, 0, 0},
        {0, 2, 0, 0},
        {0, 0, 2, 0},
        {2, 4, 6, 1}
    };
    expect_matrix(a, want);
}

TEST(MgMath, InversMatrixOfIdentityIsIdentity) {
    float m[4][4];
    float inv[4][4];
    mgUnitMatrix(m);
    mgInversMatrix(inv, m);
    const float id[4][4] = {
        {1, 0, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {0, 0, 0, 1}
    };
    expect_matrix(inv, id);
}

TEST(MgMath, InversMatrixOfTranslationNegatesRowThree) {
    float m[4][4] = {
        {1, 0, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {1, 2, 3, 1}
    };
    float inv[4][4];
    mgInversMatrix(inv, m);
    const float want[4][4] = {
        {1,  0,  0,  0},
        {0,  1,  0,  0},
        {0,  0,  1,  0},
        {-1, -2, -3, 1}
    };
    expect_matrix(inv, want);
}

TEST(MgMath, InversMatrixOfScaleUsesDeterminant) {
    float m[4][4] = {
        {2, 0, 0, 0},
        {0, 4, 0, 0},
        {0, 0, 8, 0},
        {0, 0, 0, 1}
    };
    float inv[4][4];
    mgInversMatrix(inv, m);
    const float want[4][4] = {
        {0.5f, 0,     0,      0},
        {0,    0.25f, 0,      0},
        {0,    0,     0.125f, 0},
        {0,    0,     0,      1}
    };
    expect_matrix(inv, want);
}

TEST(MgMath, InversMatrixOfShearTranslationHandComputed) {
    float m[4][4] = {
        {1, 2, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {3, 4, 5, 1}
    };
    float inv[4][4];
    mgInversMatrix(inv, m);
    const float want[4][4] = {
        {1,  -2, 0,  0},
        {0,  1,  0,  0},
        {0,  0,  1,  0},
        {-3, 2,  -5, 1}
    };
    expect_matrix(inv, want);

    float check[4][4];
    mgMulMatrix(check, m, inv);
    const float id[4][4] = {
        {1, 0, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {0, 0, 0, 1}
    };
    expect_matrix(check, id);
}

TEST(MgMath, InversMatrixInPlaceAliasing) {
    float m[4][4] = {
        {2, 0, 0, 0},
        {0, 4, 0, 0},
        {0, 0, 8, 0},
        {0, 0, 0, 1}
    };
    mgInversMatrix(m, m);
    const float want[4][4] = {
        {0.5f, 0,     0,      0},
        {0,    0.25f, 0,      0},
        {0,    0,     0.125f, 0},
        {0,    0,     0,      1}
    };
    expect_matrix(m, want);
}

TEST(MgMath, InversMatrixOfZeroMatrixSaturatesReciprocal) {
    float m[4][4] = {};
    float inv[4][4];
    mgInversMatrix(inv, m);
    const float want[4][4] = {
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 0, 1}
    };
    expect_matrix(inv, want);
}

TEST(MgMath, InversMatrixOfRankDeficientMatrixUsesMaxReciprocal) {
    float m[4][4] = {
        {1, 0, 0, 0},
        {1, 0, 0, 0},
        {0, 0, 1, 0},
        {0, 0, 0, 1}
    };
    float inv[4][4];
    mgInversMatrix(inv, m);
    EXPECT_FLOAT_EQ(inv[1][0], -FLT_MAX);
    EXPECT_FLOAT_EQ(inv[1][1], FLT_MAX);
    EXPECT_FLOAT_EQ(inv[1][2], 0.0f);
    EXPECT_FLOAT_EQ(inv[3][3], 1.0f);
}

TEST(MgMath, ApplyMatrixNTransformsRowVectors) {
    float m[4][4] = {
        {1, 0, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {1, 2, 3, 1}
    };
    float in[2][4] = {
        {0, 0, 0, 1},
        {1, 1, 1, 1}
    };
    float out[2][4];
    mgApplyMatrixN(out, m, in, 2);
    expect_lanes(out[0], {1, 2, 3, 1});
    expect_lanes(out[1], {2, 3, 4, 1});
}

TEST(MgMath, ApplyMatrixNInPlace) {
    float m[4][4] = {
        {1, 0, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {1, 2, 3, 1}
    };
    float v[2][4] = {
        {0, 0, 0, 1},
        {1, 1, 1, 1}
    };
    mgApplyMatrixN(v, m, v, 2);
    expect_lanes(v[0], {1, 2, 3, 1});
    expect_lanes(v[1], {2, 3, 4, 1});
}

TEST(MgMath, ApplyMatrixNMaxMinTracksBoundsOfResults) {
    float m[4][4] = {
        {1, 0, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {1, 2, 3, 1}
    };
    float in[3][4] = {
        {0,  0, 0, 1},
        {1,  1, 1, 1},
        {-1, 0, 5, 1}
    };
    float out[3][4];
    float hi[4];
    float lo[4];
    mgApplyMatrixN_MaxMin(out, m, in, 3, hi, lo);
    expect_lanes(out[2], {0, 2, 8, 1});
    expect_lanes(hi, {2, 3, 8, 1});
    expect_lanes(lo, {0, 2, 3, 1});
}

TEST(MgMath, ApplyMatrixNMaxMinInPlace) {
    float m[4][4] = {
        {1, 0, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {1, 2, 3, 1}
    };
    float v[3][4] = {
        {0,  0, 0, 1},
        {1,  1, 1, 1},
        {-1, 0, 5, 1}
    };
    float hi[4];
    float lo[4];
    mgApplyMatrixN_MaxMin(v, m, v, 3, hi, lo);
    expect_lanes(v[0], {1, 2, 3, 1});
    expect_lanes(v[1], {2, 3, 4, 1});
    expect_lanes(v[2], {0, 2, 8, 1});
    expect_lanes(hi, {2, 3, 8, 1});
    expect_lanes(lo, {0, 2, 3, 1});
}

TEST(MgMath, VectorMinMaxNCoversEveryVector) {
    float vecs[3][4] = {
        {1, 5,  0, 2},
        {3, -1, 4, 2},
        {0, 0,  0, 9}
    };
    float hi[4];
    float lo[4];
    mgVectorMinMaxN(hi, lo, vecs, 3);
    expect_lanes(hi, {3, 5, 4, 9});
    expect_lanes(lo, {0, -1, 0, 2});
}

TEST(MgMath, VectorMinMaxNSingleVectorIsItsOwnBounds) {
    float vecs[1][4] = {
        {1, -2, 3, 4}
    };
    float hi[4];
    float lo[4];
    mgVectorMinMaxN(hi, lo, vecs, 1);
    expect_lanes(hi, {1, -2, 3, 4});
    expect_lanes(lo, {1, -2, 3, 4});
}

TEST(MgMath, ApplyMatrixNMaxMinSingleVectorIsItsOwnBounds) {
    float m[4][4] = {
        {1, 0, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {1, 2, 3, 1}
    };
    float in[1][4] = {
        {0, 0, 0, 1}
    };
    float out[1][4];
    float hi[4];
    float lo[4];
    mgApplyMatrixN_MaxMin(out, m, in, 1, hi, lo);
    expect_lanes(out[0], {1, 2, 3, 1});
    expect_lanes(hi, {1, 2, 3, 1});
    expect_lanes(lo, {1, 2, 3, 1});
}

TEST(MgMath, ApplyMatrixNSingleVector) {
    float m[4][4] = {
        {1, 0, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {1, 2, 3, 1}
    };
    float in[1][4] = {
        {1, 1, 1, 1}
    };
    float out[1][4];
    mgApplyMatrixN(out, m, in, 1);
    expect_lanes(out[0], {2, 3, 4, 1});
}

TEST(MgMath, VectorMinMaxNTwoVectors) {
    float vecs[2][4] = {
        {1, 2, 3, 4},
        {0, 0, 0, 0}
    };
    float hi[4];
    float lo[4];
    mgVectorMinMaxN(hi, lo, vecs, 2);
    expect_lanes(hi, {1, 2, 3, 4});
    expect_lanes(lo, {0, 0, 0, 0});
}

TEST(MgMath, VectorMinSignedZeroTieKeepsNegativeZeroInEitherOrder) {
    float pos[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    float neg[4] = {-0.0f, -0.0f, -0.0f, -0.0f};
    float m[4];
    mgVectorMin(m, pos, neg);
    for (int i = 0; i < 4; i++) {
        EXPECT_TRUE(std::signbit(m[i])) << "lane " << i;
    }
    mgVectorMin(m, neg, pos);
    for (int i = 0; i < 4; i++) {
        EXPECT_TRUE(std::signbit(m[i])) << "lane " << i;
    }
}

TEST(MgMath, VectorMaxMinSignedZeroTieGivesPositiveMaxNegativeMinInEitherOrder) {
    float pos[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    float neg[4] = {-0.0f, -0.0f, -0.0f, -0.0f};
    float hi[4];
    float lo[4];
    mgVectorMaxMin(hi, lo, pos, neg);
    for (int i = 0; i < 4; i++) {
        EXPECT_FALSE(std::signbit(hi[i])) << "max lane " << i;
        EXPECT_TRUE(std::signbit(lo[i])) << "min lane " << i;
    }
    mgVectorMaxMin(hi, lo, neg, pos);
    for (int i = 0; i < 4; i++) {
        EXPECT_FALSE(std::signbit(hi[i])) << "max lane " << i;
        EXPECT_TRUE(std::signbit(lo[i])) << "min lane " << i;
    }
}

TEST(MgMath, CreateBox8SignedZeroMaxLanesBecomePositiveExceptRawCorner) {
    float max[4] = {-0.0f, -0.0f, -0.0f, -0.0f};
    float min[4] = {1.0f, 2.0f, 3.0f, 4.0f};
    float corners[8][4];
    mgCreateBox8(corners, max, min);
    expect_lanes(corners[0], {1, 2, 3, 4});
    expect_lanes(corners[1], {0, 2, 3, 4});
    for (int c = 1; c <= 6; c++) {
        for (int k = 0; k < 4; k++) {
            EXPECT_FALSE(std::signbit(corners[c][k])) << "corner " << c << " lane " << k;
        }
    }
    for (int k = 0; k < 4; k++) {
        EXPECT_TRUE(std::signbit(corners[7][k])) << "corner 7 lane " << k;
    }
}

TEST(MgMath, ClipBoxVertexNegativeZeroDifferenceIsOutside) {
    float max[4] = {-0.0f, 2.0f, 2.0f, 0.0f};
    float min[4] = {-1.0f, 0.0f, 0.0f, 0.0f};
    float p[4] = {0.0f, 1.0f, 1.0f, 0.0f};
    EXPECT_EQ(mgClipBoxVertex(p, max, min), 0);
}

TEST(MgMath, ClipBoxVertexPositiveZeroDifferenceIsInside) {
    float max[4] = {0.0f, 2.0f, 2.0f, 0.0f};
    float min[4] = {-1.0f, 0.0f, 0.0f, 0.0f};
    float p[4] = {0.0f, 1.0f, 1.0f, 0.0f};
    EXPECT_EQ(mgClipBoxVertex(p, max, min), 1);
}

TEST(MgMath, ClipBoxZeroVolumeBoxTouchingBothFacesOverlaps) {
    float max0[4] = {2.0f, 2.0f, 2.0f, 0.0f};
    float min0[4] = {2.0f, 2.0f, 2.0f, 0.0f};
    float max1[4] = {4.0f, 4.0f, 4.0f, 0.0f};
    float min1[4] = {2.0f, 2.0f, 2.0f, 0.0f};
    EXPECT_EQ(mgClipBox(max0, min0, max1, min1), 1);

    float max2[4] = {2.0f, 2.0f, 2.0f, 0.0f};
    float min2[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    EXPECT_EQ(mgClipBox(max0, min0, max2, min2), 1);
}

TEST(MgMath, ClipInBoxInvertedContainerRejectsContainedBox) {
    float max0[4] = {1.0f, 1.0f, 1.0f, 0.0f};
    float min0[4] = {1.0f, 1.0f, 1.0f, 0.0f};
    float max1[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    float min1[4] = {2.0f, 2.0f, 2.0f, 0.0f};
    EXPECT_EQ(mgClipInBox(max0, min0, max1, min1), 0);
}

TEST(MgMath, MulMatrix3AppliesThirdTimesSecondTimesMatrix) {
    float matrix[4][4] = {
        {3, 0, 0, 0},
        {0, 3, 0, 0},
        {0, 0, 3, 0},
        {0, 0, 0, 1}
    };
    float second[4][4] = {
        {1, 0, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {1, 2, 3, 1}
    };
    float third[4][4] = {
        {2, 0, 0, 0},
        {0, 2, 0, 0},
        {0, 0, 2, 0},
        {0, 0, 0, 1}
    };
    MulMatrix3(matrix, second, third);
    const float want[4][4] = {
        {6, 0, 0, 0},
        {0, 6, 0, 0},
        {0, 0, 6, 0},
        {3, 6, 9, 1}
    };
    expect_matrix(matrix, want);
}

TEST(MgMath, ApplyMatrixNZeroCountWritesNothing) {
    float m[4][4] = {
        {1, 0, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {1, 2, 3, 1}
    };
    float in[2][4] = {
        {0, 0, 0, 1},
        {5, 5, 5, 5}
    };
    float out[2][4] = {
        {42, 42, 42, 42},
        {42, 42, 42, 42}
    };
    mgApplyMatrixN(out, m, in, 0);
    expect_lanes(out[0], {42, 42, 42, 42});
    expect_lanes(out[1], {42, 42, 42, 42});
}

TEST(MgMath, ApplyMatrixNMaxMinZeroCountWritesNothing) {
    float m[4][4] = {
        {1, 0, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 1, 0},
        {1, 2, 3, 1}
    };
    float in[2][4] = {
        {0, 0, 0, 1},
        {5, 5, 5, 5}
    };
    float out[2][4] = {
        {42, 42, 42, 42},
        {42, 42, 42, 42}
    };
    float hi[4] = {42, 42, 42, 42};
    float lo[4] = {42, 42, 42, 42};
    mgApplyMatrixN_MaxMin(out, m, in, 0, hi, lo);
    expect_lanes(out[0], {42, 42, 42, 42});
    expect_lanes(out[1], {42, 42, 42, 42});
    expect_lanes(hi, {42, 42, 42, 42});
    expect_lanes(lo, {42, 42, 42, 42});
}

TEST(MgMath, VectorMinMaxNZeroCountWritesNothing) {
    float vecs[2][4] = {
        {1, -2, 3, 4},
        {7, 7,  7, 7}
    };
    float hi[4] = {42, 42, 42, 42};
    float lo[4] = {42, 42, 42, 42};
    mgVectorMinMaxN(hi, lo, vecs, 0);
    expect_lanes(hi, {42, 42, 42, 42});
    expect_lanes(lo, {42, 42, 42, 42});
}

TEST(MgMath, InversMatrixOfSingularMatrixStaysFiniteAndSaturates) {
    float m[4][4] = {
        {2, 0, 0, 0},
        {0, 1, 0, 0},
        {0, 0, 0, 0},
        {0, 0, 1, 1}
    };
    float inv[4][4];
    mgInversMatrix(inv, m);
    for (int r = 0; r < 4; r++) {
        for (int k = 0; k < 4; k++) {
            EXPECT_TRUE(std::isfinite(inv[r][k])) << "row " << r << " col " << k;
        }
    }
    EXPECT_FLOAT_EQ(inv[2][2], FLT_MAX);
    EXPECT_FLOAT_EQ(inv[3][2], -FLT_MAX);
}

TEST(MgMath, DistVectorBetweenCoincidentPointsIsZero) {
    float a[4] = {1.5f, -2.0f, 3.0f, 1.0f};
    EXPECT_FLOAT_EQ(mgDistVector(a, a), 0.0f);
    EXPECT_FLOAT_EQ(mgDistVectorXZ(a, a), 0.0f);
    EXPECT_FLOAT_EQ(mgDistVector2(a, a), 0.0f);
    EXPECT_FLOAT_EQ(mgDistVectorXZ2(a, a), 0.0f);
}

TEST(MgMath, PlaneNormalCoincidentPointsGiveZeroNormal) {
    float v0[4] = {1.0f, 2.0f, 3.0f, 1.0f};
    float v1[4] = {1.0f, 2.0f, 3.0f, 1.0f};
    float v2[4] = {4.0f, -1.0f, 0.0f, 1.0f};
    float n[4] = {9.0f, 9.0f, 9.0f, 9.0f};
    mgPlaneNormal(n, v0, v1, v2);
    EXPECT_FLOAT_EQ(n[0], 0.0f);
    EXPECT_FLOAT_EQ(n[1], 0.0f);
    EXPECT_FLOAT_EQ(n[2], 0.0f);
}
