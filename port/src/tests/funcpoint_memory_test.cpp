#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <cstddef>
#include <cstring>
#include <limits>
#include <memory>
#include <span>
#include <type_traits>

#include "funcpoint.hpp"
#include "mg_memory.hpp"
#include "platform/arena.hpp"

TEST(FuncPointMemory, InitializeClearsTheAnimationEndpoint) {
    CFuncPoint point;
    for (float &v : point.anime.end) {
        v = 123.0f;
    }
    point.frame.trans_matrix[3][0] = 81.0f;
    point.Initialize();
    EXPECT_EQ(point.frame.trans_matrix[3][0], 81.0f);
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

TEST(FuncPointMemory, AssignmentPreservesSettingsTailAndCopiesTheSeparateFrame) {
    CFuncPoint source;
    CFuncPoint destination;
    char       name[] = "tail-animation";
    source.type = FUNC_POINT_ANIME;
    source.anime.frame_name = name;
    source.anime.end[3] = 127.0f;
    source.frame.trans_matrix[3][0] = 243.0f;
    destination.frame.trans_matrix[3][0] = -1.0f;
    destination = source;
    EXPECT_EQ(destination.type, FUNC_POINT_ANIME);
    EXPECT_EQ(destination.anime.frame_name, name);
    EXPECT_EQ(destination.anime.end[3], 127.0f);
    EXPECT_EQ(destination.frame.trans_matrix[3][0], 243.0f);
}

TEST(FuncPointMemory, AssignmentPreservesActiveFireSettingsAndDetachesFrameLinks) {
    CFuncPoint source;
    CFuncPoint destination;
    mgCFrame   parent;
    mgCFrame   child;
    mgCFrame   brother;
    source.type = FUNC_POINT_FIRE;
    source.fire = {};
    source.fire.color[3] = 128.0f;
    source.fire.effect_off = 1;
    source.fire.heat_haze = 2;
    source.fire.cast_light = 3;
    source.frame.parent = &parent;
    source.frame.child = &child;
    source.frame.brother = &brother;
    source.frame.reference = 1;
    destination = source;
    EXPECT_EQ(destination.type, FUNC_POINT_FIRE);
    EXPECT_EQ(destination.fire.color[3], 128.0f);
    EXPECT_EQ(destination.fire.effect_off, 1);
    EXPECT_EQ(destination.fire.heat_haze, 2);
    EXPECT_EQ(destination.fire.cast_light, 3);
    EXPECT_EQ(destination.frame.parent, nullptr);
    EXPECT_EQ(destination.frame.child, nullptr);
    EXPECT_EQ(destination.frame.brother, nullptr);
    EXPECT_EQ(destination.frame.reference, 0);
    EXPECT_EQ(source.frame.parent, &parent);
    EXPECT_EQ(source.frame.child, &child);
    EXPECT_EQ(source.frame.brother, &brother);
}

TEST(FuncPointMemory, AssignmentPreservesActiveInventionSettingsAndBoxCorners) {
    CFuncPoint source;
    CFuncPoint destination;
    source.type = FUNC_POINT_INVENT;
    source.invent = {};
    source.invent.neta_no = 47;
    source.invent.range = 100.0f;
    source.invent.angle = 1.0f;
    for (int index = 0; index < 4; ++index) {
        source.invent.box.min[index] = -10.0f - index;
        source.invent.box.max[index] = 20.0f + index;
    }
    destination = source;
    EXPECT_EQ(destination.type, FUNC_POINT_INVENT);
    EXPECT_EQ(destination.invent.neta_no, 47);
    EXPECT_EQ(destination.invent.range, 100.0f);
    EXPECT_EQ(destination.invent.angle, 1.0f);
    for (int index = 0; index < 4; ++index) {
        EXPECT_EQ(destination.invent.box.min[index], source.invent.box.min[index]);
        EXPECT_EQ(destination.invent.box.max[index], source.invent.box.max[index]);
    }
}

TEST(FuncPointMemory, AddInitializesOptionalPointLightFieldsOverPoisonedOtherVariantStorage) {
    using Anime = CFuncPoint::AnimeData;
    using Plight = CFuncPoint::PlightData;
    static_assert(std::is_standard_layout_v<Anime> && std::is_standard_layout_v<Plight>);
    static_assert(sizeof(void *) != 8 || offsetof(Plight, no_map_light) >= offsetof(Anime, piece_space) + sizeof(Anime::piece_space));
    static_assert(sizeof(void *) != 8 || offsetof(Plight, flicker_type) + sizeof(Plight::flicker_type) <= offsetof(Anime, param));
    CList<CFuncPoint> node;
    node.data.frame.trans_matrix[3][0] = 81.0f;
    auto settings = std::as_writable_bytes(std::span(&node.data.anime, 1));
    std::ranges::fill(settings, std::byte{0xA5});
    CFuncPointMngr manager;
    auto          *point = manager.Add(FUNC_POINT_PLIGHT, &node);
    ASSERT_NE(point, nullptr);
    EXPECT_EQ(point->type, FUNC_POINT_PLIGHT);
    EXPECT_EQ(point->plight.power, 0.0f);
    EXPECT_EQ(point->plight.range, 0.0f);
    EXPECT_EQ(point->plight.light_type, 0);
    EXPECT_EQ(point->plight.light_chara, 0);
    EXPECT_EQ(point->plight.unk_40, 0);
    EXPECT_EQ(point->plight.unk_44, 0);
    EXPECT_EQ(point->plight.no_map_light, 0);
    EXPECT_EQ(point->plight.flicker_type, FUNC_PLIGHT_FLICKER_NONE);
    EXPECT_EQ(point->plight.flicker_depth, 0.0f);
    EXPECT_EQ(point->plight.flicker_period, 0.0f);
    EXPECT_EQ(point->frame.trans_matrix[3][0], 81.0f);
}

TEST(FuncPointMemory, AddRetainsSettingsOfAnAlreadyPreparedPointOfTheSameKind) {
    CList<CFuncPoint> node;
    node.data.type = FUNC_POINT_PLIGHT;
    node.data.plight = {};
    node.data.plight.power = 200.0f;
    node.data.plight.flicker_period = 17.0f;
    CFuncPointMngr manager;
    auto          *point = manager.Add(FUNC_POINT_PLIGHT, &node);
    ASSERT_NE(point, nullptr);
    EXPECT_EQ(point->plight.power, 200.0f);
    EXPECT_EQ(point->plight.flicker_period, 17.0f);
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
