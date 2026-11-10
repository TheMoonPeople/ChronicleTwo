#include <gtest/gtest.h>

#include <cmath>

#include "sceneseq.hpp"

TEST(SplineEndpoint, TimedSamplingStopsAtTerminalKeyWithoutNaN) {
    float points[3][4] = {
        {0,  0, 0, 1},
        {10, 2, 0, 1},
        {20, 0, 5, 1}
    };
    int       frames[3] = {4, 4, 0};
    C3DSpline spline;
    spline.SetUpSpline(points, frames, 3, 1.0f);
    int finished = 0;
    for (int tick = 0; tick < 8; ++tick) {
        finished = spline.Step();
        for (float coordinate : spline.now_pos) {
            EXPECT_TRUE(std::isfinite(coordinate));
        }
    }
    EXPECT_EQ(finished, 0);
    for (int axis = 0; axis < 3; ++axis) {
        EXPECT_FLOAT_EQ(spline.now_pos[axis], points[2][axis]);
    }
    EXPECT_EQ(spline.Step(), 1);
}

TEST(SplineEndpoint, DistanceSamplingStopsAtTerminalKeyWithoutNaN) {
    float points[2][4] = {
        {0,  0, 0, 1},
        {10, 0, 0, 1}
    };
    int       frames[2] = {1, 0};
    C3DSpline spline;
    spline.SetUpSpline(points, frames, 2, 20.0f);
    EXPECT_EQ(spline.StepS(), 1);
    EXPECT_FLOAT_EQ(spline.now_pos[0], 10.0f);
    EXPECT_TRUE(std::isfinite(spline.now_pos[1]));
    EXPECT_TRUE(std::isfinite(spline.now_pos[2]));
    EXPECT_EQ(spline.StepS(), 1);
}

TEST(SplineEndpoint, CameraPathSetupProducesFiniteSpeedsAndFinishes) {
    CCameraPas path;
    float      eye0[4] = {366.48f, 63.99f, -74.02f, 1};
    float      eye1[4] = {376.09f, 64.39f, -74.07f, 1};
    float      eye2[4] = {383.64f, 65.08f, -76.39f, 1};
    float      look0[4] = {504.01f, 35.91f, 19.16f, 1};
    float      look1[4] = {513.62f, 37.39f, 19.11f, 1};
    float      look2[4] = {522.12f, 39.72f, 18.44f, 1};
    path.AddCameraPas(eye0, look0);
    path.AddCameraPas(eye1, look1);
    path.AddCameraPas(eye2, look2);
    path.SetFrame(104);
    ASSERT_EQ(path.Setup(), 0);
    ASSERT_TRUE(std::isfinite(path.pos_spline.speed));
    ASSERT_TRUE(std::isfinite(path.ref_spline.speed));
    ASSERT_GT(path.pos_spline.speed, 0.0f);
    ASSERT_GT(path.ref_spline.speed, 0.0f);
    path.Run();
    float eye[4] = {};
    float look[4] = {};
    for (int tick = 0; tick < 120 && !path.CheckEnd(); ++tick) {
        path.Step(eye, look);
        for (int axis = 0; axis < 3; ++axis) {
            EXPECT_TRUE(std::isfinite(eye[axis]));
            EXPECT_TRUE(std::isfinite(look[axis]));
        }
    }
    EXPECT_TRUE(path.CheckEnd());
    for (int axis = 0; axis < 3; ++axis) {
        EXPECT_FLOAT_EQ(eye[axis], eye2[axis]);
        EXPECT_FLOAT_EQ(look[axis], look2[axis]);
    }
}

TEST(SplineEndpoint, CameraPathSpeedIncludesTheFinalInterval) {
    CCameraPas path;
    float      eye0[4] = {0, 0, 0, 1};
    float      eye1[4] = {10, 0, 0, 1};
    float      look0[4] = {0, 5, 0, 1};
    float      look1[4] = {10, 5, 0, 1};
    path.AddCameraPas(eye0, look0);
    path.AddCameraPas(eye1, look1);
    path.SetFrame(10);
    ASSERT_EQ(path.Setup(), 0);
    EXPECT_FLOAT_EQ(path.pos_spline.speed, 1.0f);
    EXPECT_FLOAT_EQ(path.ref_spline.speed, 1.0f);
}
