#include <gtest/gtest.h>

#include <array>
#include <cstring>
#include <memory>
#include <utility>

#include "automap.hpp"
#include "dng_main.hpp"
#include "editmap.hpp"
#include "platform/arena.hpp"
#include "scene.hpp"
#include "scenesnd.hpp"
#include "scoped_global_object.hpp"

namespace {
/**
 * Binds a test producer to its actual managed root extent.
 */
void BindPartsArena(mgCMemory &memory, const void *key) {
    constexpr int words = 4096;
    memory.stSetBuffer(reinterpret_cast<u_long128 *>(ArenaBlock(key, words * sizeof(u_long128))), words);
}

/**
 * Assigns a genuine map owner to the supplied scene slot.
 */
CEditMap *AssignOwnedMap(CSceneMap &slot) {
    auto  map = std::make_unique<CEditMap>();
    auto *result = map.get();
    char  name[] = "test_map";
    if (slot.AssignData(result, name) == 0 || !slot.OwnEditMap(std::move(map))) {
        return nullptr;
    }
    return result;
}
} // namespace

TEST(AutoMapStorage, MiniMapUsesTheEmptyNameTerminatorInThePartTable) {
    dc2::test::ScopedGlobalObject<BattleAreaScene> area;
    std::strcpy(area->map_name, "d01f01");
    static char arena_key;
    mgCMemory   memory;
    BindPartsArena(memory, &arena_key);
    CSceneMap slot;
    auto     *map = AssignOwnedMap(slot);
    ASSERT_NE(map, nullptr);
    ASSERT_TRUE(map->SetPlacePartsBuff(&memory, 2));
    const auto parts = map->PlacedParts();
    ASSERT_EQ(parts.size(), 2);
    char name[] = "way00";
    parts[0].SetName(name);
    parts[0].SetPartsName(name);
    CMiniMapSymbol symbol;

    symbol.SetMapInfo(slot.GetMapView(), {}, 0, 0, 320.0f, 320.0f);

    EXPECT_EQ(symbol.PlacedParts().size(), 1);
    EXPECT_EQ(symbol.info, &MiniMapInfoData[0]);
    EXPECT_EQ(parts[0].minimap_tile, MiniMapInfoData[0].tile[0]);
}

TEST(AutoMapStorage, BorrowedMapCannotIssueAnOwningSlotView) {
    CMap      map;
    CSceneMap slot;
    char      name[] = "borrowed";
    ASSERT_EQ(slot.AssignData(&map, name), 1);
    EXPECT_EQ(slot.GetMapView().Get(), nullptr);
}

TEST(AutoMapStorage, MapViewFollowsSlotMoveAndRejectsReplacementAndDestruction) {
    dc2::scene::MapView retained;
    {
        CSceneMap slot;
        auto     *map = AssignOwnedMap(slot);
        ASSERT_NE(map, nullptr);
        retained = slot.GetMapView();
        ASSERT_EQ(retained.Get(), map);
        CSceneMap moved(std::move(slot));
        EXPECT_EQ(retained.Get(), map);
        EXPECT_EQ(slot.GetMapView().Get(), nullptr);
        moved.Initialize();
        EXPECT_EQ(retained.Get(), nullptr);
        auto *replacement = AssignOwnedMap(moved);
        ASSERT_NE(replacement, nullptr);
        EXPECT_EQ(retained.Get(), nullptr);
        retained = moved.GetMapView();
        EXPECT_EQ(retained.Get(), replacement);
    }
    EXPECT_EQ(retained.Get(), nullptr);
}

TEST(AutoMapStorage, MiniMapRejectsRetiredPartsAndSlotAssignmentReuse) {
    dc2::test::ScopedGlobalObject<BattleAreaScene> area;
    std::strcpy(area->map_name, "d01f01");
    static char arena_key;
    mgCMemory   memory;
    BindPartsArena(memory, &arena_key);
    CSceneMap slot;
    auto     *map = AssignOwnedMap(slot);
    ASSERT_NE(map, nullptr);
    ASSERT_TRUE(map->SetPlacePartsBuff(&memory, 2));
    const auto parts = map->PlacedParts();
    ASSERT_EQ(parts.size(), 2);
    char name[] = "way00";
    parts[0].SetName(name);
    parts[0].SetPartsName(name);
    CMiniMapSymbol symbol;
    symbol.SetMapInfo(slot.GetMapView(), {}, 0, 0, 320.0f, 320.0f);
    ASSERT_EQ(symbol.PlacedParts().size(), 1);
    memory.stClearUsed();
    std::memset(parts.data(), 0xA5, parts.size_bytes());
    EXPECT_TRUE(symbol.PlacedParts().empty());
    float position[4]{};
    symbol.Draw(position);
    std::array<unsigned char, sizeof(CMapParts)> poison{};
    poison.fill(0xA5);
    EXPECT_EQ(std::memcmp(parts.data(), poison.data(), poison.size()), 0);
    ASSERT_TRUE(map->SetPlacePartsBuff(&memory, 2));
    EXPECT_EQ(map->PlacedParts().data(), parts.data());
    EXPECT_TRUE(symbol.PlacedParts().empty());
    slot.Initialize();
    ASSERT_NE(AssignOwnedMap(slot), nullptr);
    EXPECT_TRUE(symbol.PlacedParts().empty());
    symbol.Draw(position);
}

TEST(AutoMapStorage, DungeonMapBindingRejectsRetiredOwnerAndReplacement) {
    CSceneMap slot;
    auto     *map = AssignOwnedMap(slot);
    ASSERT_NE(map, nullptr);
    const auto previous = dc2::dungeon::MainMap();
    dc2::dungeon::SetMainMap(slot.GetMapView());
    EXPECT_EQ(dc2::dungeon::MainMap().Get(), map);
    slot.Initialize();
    EXPECT_EQ(dc2::dungeon::MainMap().Get(), nullptr);
    auto *replacement = AssignOwnedMap(slot);
    EXPECT_NE(replacement, nullptr);
    EXPECT_EQ(dc2::dungeon::MainMap().Get(), nullptr);
    dc2::dungeon::SetMainMap(slot.GetMapView());
    EXPECT_EQ(dc2::dungeon::MainMap().Get(), replacement);
    dc2::dungeon::SetMainMap(previous);
}
