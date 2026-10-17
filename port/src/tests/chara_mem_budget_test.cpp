#include <gtest/gtest.h>

#include <algorithm>
#include <vector>

#include "charasetup.hpp"
#include "mg_memory.hpp"
#include "port_memory_budget.hpp"
#include "userdata.hpp"

// Oct 2026 coredump: equipped Max hit 68500/68500 qw on human stack 0 during SetupMainUnit → LoadCharacter.
TEST(CharaMemBudget, HumanModelStacksExceedRetail) {
    EXPECT_EQ(PortGetCharaMemTableEntry(CHARA_MEM_LAYOUT_HUMAN, 0), kRetailHumanStack0Qw + CHARA_MODEL_LOAD_DELTA);
    EXPECT_EQ(PortGetCharaMemTableEntry(CHARA_MEM_LAYOUT_HUMAN, 1), kRetailHumanStack1Qw + CHARA_MODEL_LOAD_DELTA);
    EXPECT_GT(PortGetCharaMemTableEntry(CHARA_MEM_LAYOUT_HUMAN, 2), 0);
    EXPECT_EQ(PortGetCharaMemTableEntry(CHARA_MEM_LAYOUT_HUMAN, 2), 7000);
}

TEST(CharaMemBudget, RoboModelStacksBumped) {
    EXPECT_EQ(PortGetCharaMemTableEntry(CHARA_MEM_LAYOUT_ROBO, 0), 30000 + CHARA_MODEL_LOAD_DELTA);
    EXPECT_EQ(PortGetCharaMemTableEntry(CHARA_MEM_LAYOUT_ROBO, 1), 30000 + CHARA_MODEL_LOAD_DELTA);
    EXPECT_EQ(PortGetCharaMemTableEntry(CHARA_MEM_LAYOUT_ROBO, 2), 60000 + CHARA_MODEL_LOAD_DELTA);
}

TEST(CharaMemBudget, GetCharaMemAllocSizeCoversPortRows) {
    int row_sum[CHARA_MEM_LAYOUT_NUM]{};
    for (int row = 0; row < CHARA_MEM_LAYOUT_NUM; ++row) {
        for (int col = 0; col < CHARA_MEM_STACK_NUM; ++col) {
            row_sum[row] += PortGetCharaMemTableEntry(row, col);
        }
    }
    int max_row = row_sum[0];
    for (int row = 1; row < CHARA_MEM_LAYOUT_NUM; ++row) {
        max_row = std::max(max_row, row_sum[row]);
    }
    EXPECT_GE(GetCharaMemAllocSize(), max_row + 16);
}

TEST(CharaMemBudget, GetCharaMemAllocPtrCarvesHumanStacks) {
    const int parent_qw = GetCharaMemAllocSize() + 64;
    std::vector<u_long128> storage(static_cast<size_t>(parent_qw));
    mgCMemory              parent;
    mgCMemory              stacks[CHARA_MEM_STACK_NUM]{};
    parent.stSetBuffer(storage.data(), parent_qw);
    ASSERT_TRUE(GetCharaMemAllocPtr(&parent, stacks, USER_CHARA_MAX, 0));
    EXPECT_EQ(stacks[0].stack_size, kRetailHumanStack0Qw + CHARA_MODEL_LOAD_DELTA);
    EXPECT_EQ(stacks[1].stack_size, kRetailHumanStack1Qw + CHARA_MODEL_LOAD_DELTA);
    EXPECT_LE(parent.stack_used, parent_qw);
}
