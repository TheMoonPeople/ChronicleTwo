#include <gtest/gtest.h>

#include "port_memory_budget.hpp"

TEST(DungeonStageBudget, MonsterPoolReserveMatchesActiveSlots) {
    // `LoadMonsterFile` allocates 4000 qw per `MONSTER_ACTIVE_MAX` slot on stack 3.
    EXPECT_GE(DUNGEON_STAGE_STACK3_MIN, MONSTER_ACTIVE_MAX * 4000);
    EXPECT_GE(DUNGEON_STAGE_STACK3_MIN, MONSTER_ACTIVE_MAX * 0xFA0);
}

TEST(DungeonStageBudget, MainBufferGrowsWithCharacterDelta) {
    EXPECT_GE(PORT_MAIN_BUFFER_EXTRA_QW, CHARA_MODEL_LOAD_DELTA * 2);
    EXPECT_GT(PORT_MAIN_BUFFER_QUADWORDS, 0x1A0000);
}
