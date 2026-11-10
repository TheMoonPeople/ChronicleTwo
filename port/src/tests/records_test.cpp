#include <gtest/gtest.h>

#include <cstddef>
#include <cstdint>

#include "runscript.hpp"
#include "villagermngr.hpp"

TEST(Records, FuncdataKeepsDiscLayout) {
    EXPECT_EQ(sizeof(funcdata), 0x10u);
    EXPECT_EQ(offsetof(funcdata, local), 8u);
    EXPECT_EQ(offsetof(funcdata, arg), 12u);

    alignas(funcdata) std::uint32_t words[4] = {0x40, 0, 5, 2};
    auto                           *func = reinterpret_cast<funcdata *>(words);

    EXPECT_EQ(func->local, 5);
    EXPECT_EQ(func->arg, 2);
}

TEST(Records, CallDataPairFitsItsAllocation) {
    EXPECT_GE(sizeof(RS_CALLDATA) * 2 / 16 * 16, sizeof(RS_CALLDATA) * 2);
}

TEST(Records, ProgressInfoPlaceTableLayout) {
    CVillagerPlace::ProgressInfo info{};

    EXPECT_EQ(offsetof(CVillagerPlace::ProgressInfo, place), 8u);
    EXPECT_EQ(
        reinterpret_cast<std::uintptr_t>(&info.place[1][1]) - reinterpret_cast<std::uintptr_t>(&info.place[0][0]),
        sizeof(void *) * 3);
}
