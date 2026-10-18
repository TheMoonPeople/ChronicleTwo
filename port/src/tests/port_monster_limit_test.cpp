#include <gtest/gtest.h>

#include "monster.hpp"
#include "platform/config.hpp"
#include "port_monster_limit.hpp"

TEST(PortMonsterLimit, RetailCapUnlessExpanded) {
    Config config;
    config.expanded_dungeon_monsters = false;
    ConfigChange(config);
    EXPECT_EQ(PortMonsterActiveLimit(), 24);

    config.expanded_dungeon_monsters = true;
    ConfigChange(config);
    EXPECT_EQ(PortMonsterActiveLimit(), static_cast<int>(MONSTER_ACTIVE_MAX));
}

TEST(PortMonsterLimit, VisiblePriorityMatchesRetailOrExpanded) {
    Config config;
    config.expanded_dungeon_monsters = false;
    ConfigChange(config);
    EXPECT_EQ(PortMonsterVisiblePriorityLimit(), 5);

    config.expanded_dungeon_monsters = true;
    ConfigChange(config);
    EXPECT_EQ(PortMonsterVisiblePriorityLimit(), static_cast<int>(MONSTER_ACTIVE_MAX));
    EXPECT_TRUE(PortDungeonMonsterExpandedView());
}

TEST(PortMonsterLimit, ExpandedViewOffByDefault) {
    Config config;
    config.expanded_dungeon_monsters = false;
    ConfigChange(config);
    EXPECT_FALSE(PortDungeonMonsterExpandedView());
}
