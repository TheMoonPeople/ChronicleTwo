#include <gtest/gtest.h>

#include <algorithm>
#include <filesystem>
#include <format>
#include <memory>

#include "platform/config.hpp"
#include "platform/game_loop_state.hpp"
#include "platform/paths.hpp"
#include "platform_fixture.hpp"
#include "savedata.hpp"
#include "userdata.hpp"

namespace {
/**
 * Provides isolated settings and save data for transformation rewards.
 */
class TransformationSettings : public testing::Test {
protected:
    std::filesystem::path      root = std::filesystem::temp_directory_path() / std::format("dc2_transformation_{}", dc::test::ProcessId()); /**< Isolated configuration and save directory. */
    std::unique_ptr<CSaveData> save = std::make_unique<CSaveData>();                                                                        /**< Save data containing the test badges. */
    CSaveData                 *previous = PortActiveSaveData;                                                                               /**< Active save restored after each test. */

    void SetUp() override {
        PathsSetSaveRoot(root / "save");
        PortActiveSaveData = save.get();
        save->user_data.monster_box.Initialize();
    }

    void TearDown() override {
        ConfigChange(Config{});
        PortActiveSaveData = previous;
        std::filesystem::remove_all(root);
    }

    void Set(bool on) {
        Config config;
        config.transformation_stats = on;
        config.transformation_exp = on;
        config.shared_badge_exp = on;
        ASSERT_TRUE(ConfigChange(config));
    }
};

/**
 * Creates a badge for the monster whose base attack and defence are 22 and 12.
 */
MOS_CHANGE_PARAM Badge(int level) {
    MOS_CHANGE_PARAM badge{};
    badge.monster_id = 1;
    badge.level = static_cast<s16>(level);
    return badge;
}
} // namespace

TEST_F(TransformationSettings, DisabledStatsKeepRetailNumbers) {
    Set(false);
    for (const int level : {0, 10, 49, 98}) {
        auto badge = Badge(level);
        EXPECT_EQ(badge.GetAttackVol(-1), static_cast<int>(22.0f * (1.0f + 2.0f * (static_cast<float>(level) / 98.0f))));
        EXPECT_EQ(badge.GetDefenceVol(-1), 12 + std::min(level / 6, 15) * 2);
    }
}

TEST_F(TransformationSettings, BadgeStatsFollowTheSetting) {
    auto  badge = Badge(98);
    auto &monica = save->user_data.chara_data[USER_CHARA_MONICA];
    monica.defence = 60;
    Set(false);
    EXPECT_EQ(badge.GetAttackVol(-1), 66);
    EXPECT_EQ(badge.GetDefenceVol(-1), 42);
    Set(true);
    EXPECT_EQ(badge.GetAttackVol(-1), 110);
    EXPECT_EQ(badge.GetDefenceVol(-1), 60);
    monica.defence = 20;
    EXPECT_EQ(badge.GetDefenceVol(-1), 42);
}

TEST_F(TransformationSettings, ActiveBadgeAbsorptionFollowsTheSetting) {
    auto &badge = save->user_data.monster_box.monster[0];
    badge.enable = 1;
    CBattleCharaInfo transformed;
    transformed.chr_no = USER_CHARA_MONSTER;
    transformed.chara_type = BATTLE_CHARA_MONSTER;
    transformed.chara_data.monster = &badge;
    Set(false);
    transformed.AddAbs(0, 30.0f, nullptr);
    EXPECT_FLOAT_EQ(badge.abs.now, 30.0f);
    Set(true);
    transformed.AddAbs(0, 30.0f, nullptr);
    EXPECT_FLOAT_EQ(badge.abs.now, 90.0f);
}

TEST_F(TransformationSettings, SharesWithOtherUnlockedBadgesAndLevelsThoseThatFill) {
    auto &box = save->user_data.monster_box;
    for (const int badge : {0, 1, 2}) {
        box.monster[badge].enable = 1;
    }
    CBattleCharaInfo monica;
    monica.chr_no = USER_CHARA_MONICA;
    monica.chara_type = BATTLE_CHARA_HUMAN;
    monica.equip = nullptr;
    Set(false);
    monica.AddAbs(0, 40.0f, nullptr);
    EXPECT_FLOAT_EQ(box.monster[0].abs.now, 0.0f);
    Set(true);
    CBattleCharaInfo transformed;
    transformed.chr_no = USER_CHARA_MONSTER;
    transformed.chara_type = BATTLE_CHARA_MONSTER;
    transformed.chara_data.monster = &box.monster[1];
    transformed.AddAbs(0, 40.0f, nullptr);
    EXPECT_FLOAT_EQ(box.monster[0].abs.now, 10.0f);
    EXPECT_FLOAT_EQ(box.monster[1].abs.now, 80.0f);
    EXPECT_FLOAT_EQ(box.monster[2].abs.now, 10.0f);
    EXPECT_FLOAT_EQ(box.monster[3].abs.now, 0.0f);
    monica.AddAbs(0, 360.0f, nullptr);
    EXPECT_EQ(box.monster[0].level, 1);
    EXPECT_FLOAT_EQ(box.monster[0].abs.now, 0.0f);
    EXPECT_EQ(box.monster[3].level, 0);
}

TEST_F(TransformationSettings, MaxAbsorptionDoesNotShareAndFlagsAreIndependent) {
    auto &box = save->user_data.monster_box;
    box.monster[0].enable = 1;
    CBattleCharaInfo max;
    max.chr_no = USER_CHARA_MAX;
    max.chara_type = BATTLE_CHARA_HUMAN;
    max.equip = nullptr;
    Set(true);
    max.AddAbs(0, 40.0f, nullptr);
    EXPECT_FLOAT_EQ(box.monster[0].abs.now, 0.0f);
    Config config;
    config.shared_badge_exp = true;
    ASSERT_TRUE(ConfigChange(config));
    CBattleCharaInfo transformed;
    transformed.chr_no = USER_CHARA_MONSTER;
    transformed.chara_type = BATTLE_CHARA_MONSTER;
    transformed.chara_data.monster = &box.monster[0];
    transformed.AddAbs(0, 30.0f, nullptr);
    EXPECT_FLOAT_EQ(box.monster[0].abs.now, 30.0f);
    auto badge = Badge(98);
    EXPECT_EQ(badge.GetAttackVol(-1), 66);
}
