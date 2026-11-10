#include <gtest/gtest.h>

#include <array>
#include <cstddef>
#include <cstdint>
#include <cstring>

#include "editcoll.hpp"

TEST(EditColl, TriangleOverlapAcceptsFourByteAlignedInput) {
    float triangle[3][4]{
        {0.0f, 0.0f, 0.0f, 1.0f},
        {0.0f, 0.0f, 2.0f, 1.0f},
        {2.0f, 0.0f, 0.0f, 1.0f}
    };
    alignas(16) std::array<std::byte, sizeof(triangle) + 16> clipped_storage{};
    alignas(16) std::array<std::byte, sizeof(triangle) + 16> clipper_storage{};
    auto                                                    *clipped = reinterpret_cast<float (*)[4]>(clipped_storage.data() + sizeof(float));
    auto                                                    *clipper = reinterpret_cast<float (*)[4]>(clipper_storage.data() + sizeof(float));
    std::memcpy(clipped, triangle, sizeof(triangle));
    std::memcpy(clipper, triangle, sizeof(triangle));

    ASSERT_EQ(reinterpret_cast<std::uintptr_t>(clipped) % 16, sizeof(float));
    ASSERT_EQ(reinterpret_cast<std::uintptr_t>(clipper) % 16, sizeof(float));
    EXPECT_FLOAT_EQ(OverlapPoly3AreaXZ(clipped, clipper, nullptr), OverlapPoly3AreaXZ(triangle, triangle, nullptr));
}

TEST(EditColl, ClipBoxXZReportsOverlappingBoxes) {
    float max_a[4] = {2.0f, 0.0f, 2.0f, 1.0f};
    float min_a[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    float max_b[4] = {4.0f, 0.0f, 4.0f, 1.0f};
    float min_b[4] = {1.0f, 0.0f, 1.0f, 1.0f};

    EXPECT_EQ(ClipBoxXZ(max_a, min_a, max_b, min_b), 1);
}

TEST(EditColl, ClipBoxXZCountsTouchingBoxesAsOverlapping) {
    float max_a[4] = {2.0f, 0.0f, 2.0f, 1.0f};
    float min_a[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    float max_b[4] = {4.0f, 0.0f, 4.0f, 1.0f};
    float min_b[4] = {2.0f, 0.0f, 2.0f, 1.0f};

    EXPECT_EQ(ClipBoxXZ(max_a, min_a, max_b, min_b), 1);
}

TEST(EditColl, ClipBoxXZRejectsBoxesSeparatedOnX) {
    float max_a[4] = {2.0f, 0.0f, 2.0f, 1.0f};
    float min_a[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    float max_b[4] = {-1.0f, 0.0f, 2.0f, 1.0f};
    float min_b[4] = {-3.0f, 0.0f, 0.0f, 1.0f};

    EXPECT_EQ(ClipBoxXZ(max_a, min_a, max_b, min_b), 0);
}

TEST(EditColl, ClipBoxXZRejectsBoxesSeparatedOnZ) {
    float max_a[4] = {2.0f, 0.0f, 2.0f, 1.0f};
    float min_a[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    float max_b[4] = {1.0f, 0.0f, -1.0f, 1.0f};
    float min_b[4] = {0.0f, 0.0f, -3.0f, 1.0f};

    EXPECT_EQ(ClipBoxXZ(max_a, min_a, max_b, min_b), 0);
}

TEST(EditColl, ClipBoxXZIgnoresHeight) {
    float max_a[4] = {2.0f, -100.0f, 2.0f, 1.0f};
    float min_a[4] = {0.0f, -100.0f, 0.0f, 1.0f};
    float max_b[4] = {4.0f, 100.0f, 4.0f, 1.0f};
    float min_b[4] = {1.0f, 100.0f, 1.0f, 1.0f};

    EXPECT_EQ(ClipBoxXZ(max_a, min_a, max_b, min_b), 1);
}

TEST(EditColl, ClipBoxXZSeparationInFirstPairAloneRejects) {
    float max_a[4] = {2.0f, 0.0f, 2.0f, 1.0f};
    float min_a[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    float max_b[4] = {4.0f, 0.0f, 4.0f, 1.0f};
    float min_b[4] = {3.0f, 0.0f, 1.0f, 1.0f};

    EXPECT_EQ(ClipBoxXZ(max_a, min_a, max_b, min_b), 0);
}

TEST(EditColl, ClipBoxXZNegativeZeroSeparationRejects) {
    float max_a[4] = {-0.0f, 0.0f, 2.0f, 1.0f};
    float min_a[4] = {-5.0f, 0.0f, 0.0f, 1.0f};
    float max_b[4] = {4.0f, 0.0f, 4.0f, 1.0f};
    float min_b[4] = {0.0f, 0.0f, 1.0f, 1.0f};

    EXPECT_EQ(ClipBoxXZ(max_a, min_a, max_b, min_b), 0);
}

TEST(EditColl, ClipBoxXZZeroSizeBoxesAtSamePointOverlap) {
    float max_a[4] = {1.0f, 0.0f, 1.0f, 1.0f};
    float min_a[4] = {1.0f, 0.0f, 1.0f, 1.0f};
    float max_b[4] = {1.0f, 0.0f, 1.0f, 1.0f};
    float min_b[4] = {1.0f, 0.0f, 1.0f, 1.0f};

    EXPECT_EQ(ClipBoxXZ(max_a, min_a, max_b, min_b), 1);
}
