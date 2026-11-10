#include <gtest/gtest.h>

#include <vector>

#include "charasetup.hpp"
#include "mg_memory.hpp"
#include "userdata.hpp"

namespace {

constexpr int kModelStackExtra = 12000;

} // namespace

TEST(CharaMemBudget, HumanModelStacksExceedRetail) {
    const int              parent_size = GetCharaMemAllocSize() + 64;
    std::vector<u_long128> storage(static_cast<size_t>(parent_size));
    mgCMemory              parent;
    std::vector<mgCMemory> stacks(CHARA_MEM_STACK_NUM);
    parent.stSetBuffer(storage.data(), parent_size);
    ASSERT_TRUE(GetCharaMemAllocPtr(&parent, stacks.data(), USER_CHARA_MAX, 0));
    EXPECT_EQ(stacks[0].stack_size, 68500 + kModelStackExtra);
    EXPECT_EQ(stacks[1].stack_size, 40000 + kModelStackExtra);
    EXPECT_EQ(stacks[2].stack_size, 7000);
    EXPECT_LE(parent.stack_used, parent_size);
}
