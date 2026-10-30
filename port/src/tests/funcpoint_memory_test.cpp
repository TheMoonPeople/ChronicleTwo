#include <gtest/gtest.h>

#include <array>
#include <cstring>
#include <limits>
#include <memory>

#include "funcpoint.hpp"
#include "mg_memory.hpp"
#include "platform/arena.hpp"

TEST(FuncPointMemory, InitializeClearsTheAnimationEndpoint) {
    CFuncPoint point;
    for (float &v : point.anime.end) {
        v = 123.0f;
    }
    point.Initialize();
    for (float v : point.anime.end) {
        EXPECT_EQ(v, 0.0f);
    }
}

TEST(FuncPointMemory, CopyPreservesAllAnimationVectorsAndNames) {
    alignas(64) u_long128 storage[2048]{};
    mgCMemory             memory;
    memory.stSetBuffer(storage, 2048);
    CFuncPointMngr source;
    CFuncPointMngr destination;
    auto          *point = source.Add(FUNC_POINT_ANIME, &memory);
    ASSERT_NE(point, nullptr);
    char name[] = "moving-part";
    point->anime.parts_name = name;
    point->anime.piece_name = name;
    point->anime.frame_name = name;
    for (int i = 0; i < 4; ++i) {
        point->anime.param[i] = 10.0f + i;
        point->anime.speed[i] = 20.0f + i;
        point->anime.end[i] = 30.0f + i;
    }
    ASSERT_TRUE(source.Copy(destination, &memory));
    ASSERT_NE(destination.list[FUNC_POINT_ANIME], nullptr);
    auto &copy = destination.list[FUNC_POINT_ANIME]->data;
    EXPECT_EQ(copy.anime.parts_name, name);
    EXPECT_EQ(copy.anime.piece_name, name);
    EXPECT_EQ(copy.anime.frame_name, name);
    for (int i = 0; i < 4; ++i) {
        EXPECT_EQ(copy.anime.param[i], point->anime.param[i]);
        EXPECT_EQ(copy.anime.speed[i], point->anime.speed[i]);
        EXPECT_EQ(copy.anime.end[i], point->anime.end[i]);
    }
}

TEST(FuncPointMemory, ReserveRejectsInvalidCountsAndInsufficientArenaBeforeWriting) {
    alignas(64) u_long128 storage[64]{};
    mgCMemory             memory;
    memory.stSetBuffer(storage, 64);
    CFuncPointMngr points;

    points.Reserve(-1, &memory);
    points.Reserve(std::numeric_limits<int>::max(), &memory);
    EXPECT_EQ(points.GetReserve(), nullptr);
    EXPECT_EQ(memory.stack_used, 0);

    points.Reserve(1, &memory);
    EXPECT_EQ(points.GetNum(FUNC_POINT_NONE), 1);
    EXPECT_NE(points.GetReserve(), nullptr);
    memory.stSetLocked(true);
    EXPECT_EQ(points.Add(FUNC_POINT_ANIME, &memory), nullptr);
}

TEST(FuncPointMemory, SinglePointReservesItsWholeHostObjectBeforeAnyWrites) {
    static char   key;
    constexpr int words = static_cast<int>((sizeof(CList<CFuncPoint>) + sizeof(u_long128) - 1) / sizeof(u_long128));
    auto         *backing = reinterpret_cast<u_long128 *>(ArenaBlock(&key, static_cast<std::size_t>(words + 2) * sizeof(u_long128)));
    mgCMemory     parent;
    parent.stSetBuffer(backing, words + 2);
    mgCMemory memory;
    ASSERT_TRUE(memory.stShareBuffer(parent, std::span(backing, static_cast<std::size_t>(words))));
    std::memset(backing, 0xA5, static_cast<std::size_t>(words + 2) * sizeof(u_long128));
    CFuncPointMngr manager;
    EXPECT_EQ(manager.Add(FUNC_POINT_ANIME, &memory), nullptr);
    EXPECT_EQ(memory.stack_used, 0);
    const auto *bytes = reinterpret_cast<const unsigned char *>(backing);
    for (std::size_t index = 0; index < static_cast<std::size_t>(words + 2) * sizeof(u_long128); ++index) {
        ASSERT_EQ(bytes[index], 0xA5) << index;
    }
    mgCMemory roomy;
    ASSERT_TRUE(roomy.stShareBuffer(parent, std::span(backing, static_cast<std::size_t>(words + 1))));
    ASSERT_NE(manager.Add(FUNC_POINT_ANIME, &roomy), nullptr);
    EXPECT_EQ(roomy.stack_used, words);
    EXPECT_EQ(bytes[static_cast<std::size_t>(words) * sizeof(u_long128)], 0xA5);
}

TEST(FuncPointMemory, PoisonedReservedNodesCanBeCopiedBeforeTheyBecomeActive) {
    alignas(CFuncPoint) std::array<std::byte, sizeof(CFuncPoint)> storage{};
    storage.fill(std::byte{0xA5});
    auto *point = std::construct_at(reinterpret_cast<CFuncPoint *>(storage.data()));
    EXPECT_EQ(point->name, nullptr);
    EXPECT_EQ(point->type, FUNC_POINT_NONE);
    EXPECT_EQ(point->active, 0);
    EXPECT_EQ(point->enable, 1);
    EXPECT_EQ(point->anime.parts_name, nullptr);
    std::destroy_at(point);
    static char key;
    auto       *backing = reinterpret_cast<u_long128 *>(ArenaBlock(&key, 4096));
    std::memset(backing, 0xA5, 4096);
    mgCMemory memory;
    memory.stSetBuffer(backing, 256);
    CFuncPointMngr source;
    CFuncPointMngr copy;
    source.Reserve(1, &memory);
    ASSERT_EQ(source.GetNum(FUNC_POINT_NONE), 1);
    ASSERT_TRUE(source.Copy(copy, &memory));
    ASSERT_NE(copy.list[FUNC_POINT_NONE], nullptr);
    EXPECT_EQ(copy.list[FUNC_POINT_NONE]->data.name, nullptr);
    EXPECT_EQ(copy.list[FUNC_POINT_NONE]->data.active, 0);
}
