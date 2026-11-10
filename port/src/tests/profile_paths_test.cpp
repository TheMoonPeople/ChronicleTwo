#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <string>

#include "gamedata.hpp"
#include "menuchr.hpp"
#include "monster.hpp"

TEST(ProfilePaths, MonsterModelProducerSeparatesProfileKeysFromNativeFilenames) {
    const auto *monster = GetMonsterTable(0);
    ASSERT_NE(monster, nullptr);
    const auto profile = GetMonsterModelFile(0, MONSTER_FILE_CONFIG);
    const auto model = GetMonsterModelFile(0, MONSTER_FILE_MODEL);
    ASSERT_TRUE(profile);
    ASSERT_TRUE(model);
    EXPECT_EQ(*profile, monster->model);
    EXPECT_EQ(*model, std::string(monster->model) + ".gltf");
    EXPECT_FALSE(GetMonsterModelFile(-1, MONSTER_FILE_MODEL).has_value());
}

TEST(ProfilePaths, MonsterModelNameUsesItsBoundedField) {
    auto *monster = GetMonsterTable(0);
    ASSERT_NE(monster, nullptr);
    std::array<char, sizeof(monster->model)> original{};
    std::copy_n(monster->model, original.size(), original.begin());
    std::fill_n(monster->model, original.size(), 'x');
    const auto model = GetMonsterModelFile(0, MONSTER_FILE_MODEL);
    std::copy(original.begin(), original.end(), monster->model);
    ASSERT_TRUE(model);
    EXPECT_EQ(*model, std::string(original.size(), 'x') + ".gltf");
}
