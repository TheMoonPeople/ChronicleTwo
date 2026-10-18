#include <gtest/gtest.h>

#include <limits>

#include "cameracontrol.hpp"
#include "editmode_port.hpp"

namespace {
CCameraControl Camera(float angle) {
    CCameraControl camera;
    camera.SetAngleSoon(angle);
    return camera;
}
} // namespace

TEST(GeoramaMouse, YawTurnsLikeTheRightStick) {
    // Retail's cursor step adds 0.1 * -X a frame; a full right deflection turns the angle by -0.1.
    auto  stick = Camera(1.0f);
    auto  mouse = Camera(1.0f);
    float distance = 600.0f;
    stick.AddAngle(0.1f * -1.0f);
    EXPECT_TRUE(GeoramaMouseTurn(mouse, distance, 0.1f, 0.0f));
    EXPECT_FLOAT_EQ(mouse.next_angle, stick.next_angle);
    EXPECT_FLOAT_EQ(mouse.angle, 1.0f);
    EXPECT_FLOAT_EQ(distance, 600.0f);
    EXPECT_TRUE(GeoramaMouseTurn(mouse, distance, -0.3f, 0.0f));
    EXPECT_FLOAT_EQ(mouse.next_angle, 1.2f);
}

TEST(GeoramaMouse, PitchMovesTheDistanceLikeTheRightStickWithinRetailLimits) {
    auto  camera = Camera(0.0f);
    float distance = 600.0f;
    // Looking up is the stick pulled down (Y > 0), which adds 15 units for 0.1 radian.
    EXPECT_TRUE(GeoramaMouseTurn(camera, distance, 0.0f, 0.1f));
    EXPECT_FLOAT_EQ(distance, 615.0f);
    EXPECT_TRUE(GeoramaMouseTurn(camera, distance, 0.0f, -0.5f));
    EXPECT_FLOAT_EQ(distance, 540.0f);
    EXPECT_TRUE(GeoramaMouseTurn(camera, distance, 0.0f, 10.0f));
    EXPECT_FLOAT_EQ(distance, 800.0f);
    EXPECT_FALSE(GeoramaMouseTurn(camera, distance, 0.0f, 1.0f));
    EXPECT_TRUE(GeoramaMouseTurn(camera, distance, 0.0f, -10.0f));
    EXPECT_FLOAT_EQ(distance, 400.0f);
    EXPECT_FLOAT_EQ(camera.next_angle, 0.0f);
}

TEST(GeoramaMouse, IgnoresStillAndNonFiniteReads) {
    auto        camera = Camera(0.5f);
    float       distance = 600.0f;
    const float nan = std::numeric_limits<float>::quiet_NaN();
    const float inf = std::numeric_limits<float>::infinity();
    EXPECT_FALSE(GeoramaMouseTurn(camera, distance, 0.0f, 0.0f));
    EXPECT_FALSE(GeoramaMouseTurn(camera, distance, nan, inf));
    EXPECT_FALSE(GeoramaMouseTurn(camera, distance, -inf, nan));
    EXPECT_FLOAT_EQ(camera.next_angle, 0.5f);
    EXPECT_FLOAT_EQ(distance, 600.0f);
}

TEST(GeoramaMouse, OnlyTheUnlockedEditCameraTakesTheMouse) {
    EXPECT_TRUE(GeoramaMouseOwns(true, 0, true, false, false));
    EXPECT_TRUE(GeoramaMouseOwns(true, -1, true, false, false));
    // Retail drops the pad while the cursor is locked after a placement or removal.
    EXPECT_FALSE(GeoramaMouseOwns(true, 1, true, false, false));
    EXPECT_FALSE(GeoramaMouseOwns(false, 0, true, false, false));
    EXPECT_FALSE(GeoramaMouseOwns(true, 0, false, false, false));
    EXPECT_FALSE(GeoramaMouseOwns(true, 0, true, true, false));
    EXPECT_FALSE(GeoramaMouseOwns(true, 0, true, false, true));
}

TEST(GeoramaMouse, NoSceneIsIgnored) {
    GeoramaMouseCamera(nullptr);
    SUCCEED();
}
