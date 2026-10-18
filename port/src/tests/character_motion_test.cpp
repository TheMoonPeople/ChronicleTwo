#include "common.h"

#include <gtest/gtest.h>

#include <array>
#include <cmath>
#include <initializer_list>

#include "character_motion.hpp"
#include "gameutil.hpp"
#include "mg_frame.hpp"
#include "mg_visual.hpp"

namespace {

/**
 * One effect frame with a material, under a root whose frame list the motion keys index.
 */
struct EffectModel {
    mgCFrame                  root;
    mgCFrame                  effect;
    std::array<mgCFrame *, 2> frames{&root, &effect};
    mgCFrameAttr              attr;
    mgMaterial                material{};
    mgCVisualMDT              visual;

    EffectModel() {
        root.frame_list = frames.data();
        root.frame_num = 1;
        material.diffuse[0] = material.diffuse[1] = material.diffuse[2] = material.diffuse[3] = 1.0f;
        visual.material = &material;
        visual.material_num = 1;
        effect.SetVisual(&visual);
        effect.attr = &attr;
    }
};

/**
 * Key list of one channel driving frame 1's first material, on game frames 0, 1, 2...
 */
struct Channel {
    sceVu0FVECTOR values[8]{};
    u32           frames[8]{};
    Mot_List      list{};

    Channel(int type, std::initializer_list<float> keys) {
        int index = 0;
        for (const float key : keys) {
            values[index][0] = values[index][1] = values[index][2] = key;
            values[index][3] = 0.0f;
            frames[index] = index;
            ++index;
        }
        list.frame = 1;
        list.target = 0;
        list.type = type;
        list.key_count = static_cast<u32>(keys.size());
        list.values = values;
        list.key_frames = frames;
    }
};

class CharacterMotion : public ::testing::Test {
protected:
    void TearDown() override { character_motion::Clear(); }
};

// A sliced action's material channels end on its last frame, where the game's interpolation has no later key;
// an effect that fades out must keep its last key there rather than divide zero by zero into NaN.
TEST_F(CharacterMotion, MaterialAlphaHoldsItsLastKeyAtAndPastTheActionEnd) {
    EffectModel    model;
    Channel        transparency(MOTION_KEY_MATERIAL_ALPHA, {0.0f, 0.5f, 0.9f});
    tagMOTION_TYPE motion{};
    motion.motion_list = &transparency.list;
    character_motion::Register(motion.motion_list, {
                                                       {.name = "get_item", .duration = 2.0f, .base = 0, .head = &transparency.list}
    });

    character_motion::Pose(model.root, motion, 1.5f, nullptr);
    EXPECT_NEAR(model.material.diffuse[3], 1.0f - 0.7f, 1e-5f);

    for (const float frame : {2.0f, 3.0f, 10.0f}) {
        model.material.diffuse[3] = 1.0f;
        character_motion::Pose(model.root, motion, frame, nullptr);
        ASSERT_FALSE(std::isnan(model.material.diffuse[3])) << "frame " << frame;
        EXPECT_NEAR(model.material.diffuse[3], 1.0f - 0.9f, 1e-5f) << "frame " << frame;
    }
}

TEST_F(CharacterMotion, MaterialColourHoldsItsLastKeyAtTheActionEnd) {
    EffectModel    model;
    Channel        colour(MOTION_KEY_MATERIAL_COLOR, {1.0f, 0.25f});
    tagMOTION_TYPE motion{};
    motion.motion_list = &colour.list;
    character_motion::Register(motion.motion_list, {
                                                       {.name = "flash", .duration = 1.0f, .base = 0, .head = &colour.list}
    });

    character_motion::Pose(model.root, motion, 1.0f, nullptr);
    for (int component = 0; component < 3; ++component) {
        EXPECT_NEAR(model.material.diffuse[component], 0.25f, 1e-5f);
    }
}

// The blend into a different action poses the target's auxiliary channels unblended, through the same end hold.
TEST_F(CharacterMotion, BlendIntoAnActionEndKeepsItsMaterialAlpha) {
    EffectModel    model;
    Channel        first(MOTION_KEY_MATERIAL_ALPHA, {0.0f, 0.0f});
    Channel        second(MOTION_KEY_MATERIAL_ALPHA, {0.2f, 0.8f});
    tagMOTION_TYPE motion{};
    motion.motion_list = &first.list;
    character_motion::Register(motion.motion_list, {
                                                       {.name = "start", .duration = 1.0f, .base = 0, .head = &first.list },
                                                       {.name = "end",   .duration = 1.0f, .base = 3, .head = &second.list},
    });

    character_motion::Pose(model.root, motion, 0.0f, nullptr);
    character_motion::Blend(model.root, motion, 0.0f, 4.0f, 0.5f, nullptr);
    ASSERT_FALSE(std::isnan(model.material.diffuse[3]));
    EXPECT_NEAR(model.material.diffuse[3], 1.0f - 0.8f, 1e-5f);
}

} // namespace
