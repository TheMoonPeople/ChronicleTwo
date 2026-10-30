#include <gtest/gtest.h>

#include "render/outline_geometry.hpp"
#include "render/renderer.hpp"

namespace {

mgPortExtent Screen() {
    mgPortExtent extent;
    extent.left = 0.0f;
    extent.top = 0.0f;
    extent.right = 512.0f;
    extent.bottom = 480.0f;
    return extent;
}

mgPortExtent Fill() {
    mgPortExtent extent = Screen();
    extent.left = -40.0f;
    extent.right = 552.0f;
    return extent;
}

OutlineBox Draw(float min_x, float min_y, float max_x, float max_y, const mgPortExtent &extent) {
    const float min[4] = {min_x, min_y, 0.0f, 0.0f};
    const float max[4] = {max_x, max_y, 0.0f, 0.0f};
    return OutlineDrawBox(min, max, extent);
}

void ExpectBox(const OutlineBox &box, int left, int top, int right, int bottom) {
    EXPECT_EQ(box.left, left);
    EXPECT_EQ(box.top, top);
    EXPECT_EQ(box.right, right);
    EXPECT_EQ(box.bottom, bottom);
}

} // namespace

TEST(OutlineScale, ClampsToOneThenSquares) {
    EXPECT_FLOAT_EQ(OutlineScale(2.0f), 1.0f);
    EXPECT_FLOAT_EQ(OutlineScale(0.5f), 0.25f);
    EXPECT_FLOAT_EQ(OutlineScale(-1.0f), 1.0f);
}

TEST(OutlineEdgeOffset, IsSixteenUnitsPerWidthPixelTimesSquaredScale) {
    EXPECT_EQ(OutlineEdgeOffset(3.0f, 0.25f), 12);
    EXPECT_EQ(OutlineEdgeOffset(1.0f, 1.0f), 16);
    EXPECT_EQ(OutlineEdgeOffset(0.5f, 0.5f), 4);
}

TEST(OutlineDrawBox, ConvertsToTwelveFourUnits) {
    ExpectBox(Draw(10.5f, 20.25f, 100.0f, 200.75f, Screen()), 168, 324, 1600, 3212);
}

TEST(OutlineDrawBox, ClampsToTheScreenExtent) {
    ExpectBox(Draw(-20.0f, -4.0f, 600.0f, 500.0f, Screen()), 0, 0, 512 * 16, 480 * 16);
}

TEST(OutlineDrawBox, ClampsToTheWiderFillExtent) {
    ExpectBox(Draw(-60.0f, -4.0f, 600.0f, 500.0f, Fill()), -40 * 16, 0, 552 * 16, 480 * 16);
}

TEST(OutlinePaddedBox, OutsetsByEightPixels) {
    const OutlineBox box{.left = 168, .top = 324, .right = 1600, .bottom = 3212};
    ExpectBox(OutlinePaddedBox(box, Screen()), 40, 196, 1728, 3340);
}

TEST(OutlinePaddedBox, ClampsToTheScreenExtent) {
    const OutlineBox box{.left = 0, .top = 0, .right = 512 * 16, .bottom = 480 * 16};
    ExpectBox(OutlinePaddedBox(box, Screen()), 0, 0, 512 * 16, 480 * 16);
}

TEST(OutlinePaddedBox, ClampsToTheFillExtent) {
    const OutlineBox box{.left = -40 * 16, .top = 0, .right = 552 * 16, .bottom = 480 * 16};
    ExpectBox(OutlinePaddedBox(box, Fill()), -40 * 16, 0, 552 * 16, 480 * 16);
}
