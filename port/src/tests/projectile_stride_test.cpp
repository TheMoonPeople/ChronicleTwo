#include <gtest/gtest.h>

#include "dng_object.hpp"
#include "mg_frame.hpp"
#include "mg_texture.hpp"

TEST(ProjectileStride, RocketInitializationVisitsEveryHostObject) {
    CRocketLauncherMan manager = {};
    mgCFrame           model;
    mgCTexture         texture;
    manager.Initialize(&model, 37, &texture);
    for (const auto &rocket : manager.rocket) {
        EXPECT_EQ(rocket.state, SHOT_STATE_FREE);
        EXPECT_EQ(rocket.col_prim_id, -1);
        EXPECT_EQ(rocket.model, &model);
        EXPECT_EQ(rocket.trail_texture, &texture);
        EXPECT_EQ(rocket.tex_block, 37);
    }
}

TEST(ProjectileStride, LaserInitializationVisitsEveryHostObject) {
    CLaserGunMan manager = {};
    mgCFrame     model;
    mgCTexture   texture;
    manager.Initialize(&model, 41, &texture);
    for (const auto &laser : manager.laser) {
        EXPECT_EQ(laser.state, SHOT_STATE_FREE);
        EXPECT_EQ(laser.col_prim_id, -1);
        EXPECT_EQ(laser.model, &model);
        EXPECT_EQ(laser.trail_texture, &texture);
        EXPECT_EQ(laser.tex_block, 41);
    }
}
