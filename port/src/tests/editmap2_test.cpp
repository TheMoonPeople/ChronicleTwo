#include <gtest/gtest.h>

#include "stubs/editmap2.hpp"

namespace {

void SetPoint(float *dst, float x, float y, float z) {
    dst[0] = x;
    dst[1] = y;
    dst[2] = z;
    dst[3] = 1.0f;
}

} // namespace

TEST(EditMap2, PlaneNormalXZPointsUpForCounterclockwiseFromAbove) {
    float normal[4] = {};
    float p0[4] = {};
    float p1[4] = {};
    float p2[4] = {};
    SetPoint(p0, 0.0f, 0.0f, 0.0f);
    SetPoint(p1, 0.0f, 0.0f, 1.0f);
    SetPoint(p2, 1.0f, 0.0f, 0.0f);

    PlaneNormalXZ(normal, p0, p1, p2);

    EXPECT_FLOAT_EQ(normal[0], 0.0f);
    EXPECT_FLOAT_EQ(normal[1], 1.0f);
    EXPECT_FLOAT_EQ(normal[2], 0.0f);
    EXPECT_FLOAT_EQ(normal[3], 0.0f);
}

TEST(EditMap2, PlaneNormalXZIgnoresHeightAndFlipsWithWinding) {
    float normal[4] = {};
    float p0[4] = {};
    float p1[4] = {};
    float p2[4] = {};
    SetPoint(p0, 0.0f, 3.0f, 0.0f);
    SetPoint(p1, 0.0f, -2.0f, 1.0f);
    SetPoint(p2, 1.0f, 9.0f, 0.0f);

    PlaneNormalXZ(normal, p0, p1, p2);

    EXPECT_FLOAT_EQ(normal[0], 0.0f);
    EXPECT_FLOAT_EQ(normal[1], 1.0f);
    EXPECT_FLOAT_EQ(normal[2], 0.0f);

    float swapped[4] = {};
    PlaneNormalXZ(swapped, p0, p2, p1);

    EXPECT_FLOAT_EQ(swapped[1], -1.0f);
}

TEST(EditMap2, PlaneNormalXZCoincidentFirstTwoPointsGiveZeroNormal) {
    float normal[4] = {};
    float p0[4] = {};
    float p1[4] = {};
    float p2[4] = {};
    SetPoint(p0, 3.0f, 2.0f, 4.0f);
    SetPoint(p1, 3.0f, 2.0f, 4.0f);
    SetPoint(p2, 1.0f, 0.0f, 0.0f);

    PlaneNormalXZ(normal, p0, p1, p2);

    EXPECT_FLOAT_EQ(normal[0], 0.0f);
    EXPECT_FLOAT_EQ(normal[1], 0.0f);
    EXPECT_FLOAT_EQ(normal[2], 0.0f);
    EXPECT_FLOAT_EQ(normal[3], 0.0f);
}

TEST(EditMap2, PlaneNormalXZCoincidentFirstAndLastPointsGiveZeroNormal) {
    float normal[4] = {};
    float p0[4] = {};
    float p1[4] = {};
    float p2[4] = {};
    SetPoint(p0, 3.0f, 2.0f, 4.0f);
    SetPoint(p1, 0.0f, 0.0f, 1.0f);
    SetPoint(p2, 3.0f, 2.0f, 4.0f);

    PlaneNormalXZ(normal, p0, p1, p2);

    EXPECT_FLOAT_EQ(normal[0], 0.0f);
    EXPECT_FLOAT_EQ(normal[1], 0.0f);
    EXPECT_FLOAT_EQ(normal[2], 0.0f);
    EXPECT_FLOAT_EQ(normal[3], 0.0f);
}

TEST(EditMap2, PlaneNormalXZCollinearPointsGiveZeroNormal) {
    float normal[4] = {};
    float p0[4] = {};
    float p1[4] = {};
    float p2[4] = {};
    SetPoint(p0, 0.0f, 0.0f, 0.0f);
    SetPoint(p1, 1.0f, 5.0f, 1.0f);
    SetPoint(p2, 2.0f, -3.0f, 2.0f);

    PlaneNormalXZ(normal, p0, p1, p2);

    EXPECT_FLOAT_EQ(normal[0], 0.0f);
    EXPECT_FLOAT_EQ(normal[1], 0.0f);
    EXPECT_FLOAT_EQ(normal[2], 0.0f);
    EXPECT_FLOAT_EQ(normal[3], 0.0f);
}
