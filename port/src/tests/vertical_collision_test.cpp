#include <gtest/gtest.h>

#include "collision.hpp"
#include "gameutil.hpp"

TEST(VerticalCollision, IntersectionKeepsTheHomogeneousLane) {
    CCPoly      poly{};
    const float corners[3][4] = {
        {-10, 0, -10, 1},
        {0,   0, 10,  1},
        {10,  0, -10, 1}
    };
    for (int i = 0; i < 3; ++i) {
        for (int j = 0; j < 4; ++j) {
            poly.vertex[i][j] = corners[i][j];
        }
    }
    poly.normal[1] = 1;
    float from[4] = {0, 5, 0, 1};
    float hit[4] = {-99, -99, -99, -99};
    ASSERT_EQ(CheckHitVertical(&poly, 1, from, -10, hit, 0), 0);
    EXPECT_FLOAT_EQ(hit[0], 0);
    EXPECT_FLOAT_EQ(hit[1], 0);
    EXPECT_FLOAT_EQ(hit[2], 0);
    EXPECT_FLOAT_EQ(hit[3], 1);
}
