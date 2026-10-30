#include <gtest/gtest.h>

#include <string>

#include "dataread.hpp"
#include "nowload.hpp"
#include "object/menu/loading_screen.hpp"

TEST(NowLoadingMemory, CopiesTheSourceStackStateEvenWhenTheImageIsMissing) {
    NowLoadingInfo        info;
    alignas(64) u_long128 storage[1024]{};
    info.memory.stSetBuffer(storage, 1024);
    info.memory.Alloc(7);
    info.step_count = 5;
    PortLoadInfo.memory.stSetBuffer(nullptr, 0);
    // Keep the image unavailable even when the suite has a real data root.
    std::string previous = GetCurrentDir();
    char        missing[] = "__missing_loading_memory_test__/";
    SetCurrentDir(missing);
    CreateNowLoading(&info);
    SetCurrentDir(previous.data());
    EXPECT_EQ(PortLoadInfo.memory.stack, info.memory.stack);
    EXPECT_EQ(PortLoadInfo.memory.stack_used, info.memory.stack_used);
    EXPECT_EQ(PortLoadInfo.memory.stack_size, info.memory.stack_size);
    EXPECT_EQ(PortLoadInfo.memory.stack_block, info.memory.stack_block);
    EXPECT_EQ(PortLoadInfo.memory.stGetTop(), info.memory.stGetTop());
}

TEST(NowLoadingMemory, RetainsTheActualParentAfterTemporarySettingsAreDestroyed) {
    alignas(64) u_long128 storage[1024]{};
    mgCMemory             parent;
    parent.stSetBuffer(storage, 1024);
    auto *allocation = parent.Alloc(32);
    ASSERT_NE(allocation, nullptr);
    std::string previous = GetCurrentDir();
    char        missing[] = "__missing_loading_memory_test__/";
    SetCurrentDir(missing);
    {
        NowLoadingInfo info;
        info.memory.stSetBorrowedBuffer(parent, std::span(allocation, 32));
        ASSERT_NE(info.memory.Alloc(7), nullptr);
        CreateNowLoading(&info);
    }
    SetCurrentDir(previous.data());
    EXPECT_EQ(PortLoadInfo.memory.stGetTop(), allocation + 7);
    parent.stReset();
    EXPECT_EQ(PortLoadInfo.memory.stGetTop(), nullptr);
}
