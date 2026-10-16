#include <gtest/gtest.h>

#include <string>

#include "gamedata.hpp"
#include "menuchr.hpp"
#include "monster.hpp"

TEST(ProfilePaths, MonsterModelProducerSeparatesProfileKeysFromNativeFilenames) {
    const auto *monster = GetMonsterTable(0);
    ASSERT_NE(monster, nullptr);
    char profile[128]{};
    char model[128]{};
    ASSERT_EQ(GetMonsterModelFile(0, MONSTER_FILE_CONFIG, profile), 1);
    ASSERT_EQ(GetMonsterModelFile(0, MONSTER_FILE_MODEL, model), 1);
    EXPECT_STREQ(profile, monster->model);
    EXPECT_EQ(std::string(model), std::string(monster->model) + ".gltf");
}
