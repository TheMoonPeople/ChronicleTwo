#include <gtest/gtest.h>

#include <array>
#include <cstdint>
#include <memory>
#include <vector>

#include "editmap.hpp"
#include "editparts.hpp"
#include "map.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "mg_visual.hpp"
#include "mglib.hpp"
#include "water.hpp"

TEST(MapStride, PoisonedConstructionStartsWithEmptyPlacementAndPartState) {
    alignas(CMap) std::array<std::byte, sizeof(CMap)> map_storage{};
    map_storage.fill(std::byte{0xA5});
    auto *map = ::new (map_storage.data()) CMap;
    EXPECT_EQ(map->place_parts, nullptr);
    EXPECT_EQ(map->place_parts_num, 0);
    EXPECT_EQ(map->place_parts_max, 0);
    EXPECT_EQ(map->draw_parts, nullptr);
    EXPECT_EQ(map->unk_ca4, 0);
    EXPECT_EQ(map->GetPlaceParts(0), nullptr);
    std::destroy_at(map);

    alignas(CMapParts) std::array<std::byte, sizeof(CMapParts)> parts_storage{};
    parts_storage.fill(std::byte{0xA5});
    auto *parts = ::new (parts_storage.data()) CMapParts;
    EXPECT_EQ(parts->piece_list, nullptr);
    EXPECT_EQ(parts->anime_list, nullptr);
    EXPECT_EQ(parts->group_no, -1);
    EXPECT_EQ(parts->name[31], 0);
    EXPECT_EQ(parts->parts_name[31], 0);
    std::destroy_at(parts);
}

TEST(MapStride, PlacePartLookupRejectsThePastEndIndexAndNullName) {
    std::vector<u_long128> storage(8192);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), storage.size());
    CMap map;
    map.SetPlacePartsBuff(&memory, 2);
    ASSERT_NE(map.place_parts, nullptr);
    map.place_parts_num = 0;
    EXPECT_EQ(map.GetPlaceParts(0), nullptr);
    map.place_parts_num = 2;
    EXPECT_EQ(map.GetPlaceParts(0), &map.place_parts[0]);
    EXPECT_EQ(map.GetPlaceParts(1), &map.place_parts[1]);
    EXPECT_EQ(map.GetPlaceParts(-1), nullptr);
    EXPECT_EQ(map.GetPlaceParts(2), nullptr);
    EXPECT_EQ(map.GetPlaceParts(static_cast<char *>(nullptr)), nullptr);
}

TEST(MapStride, PlacePartAllocationFailurePreservesThePublishedTableAndArenaCursor) {
    std::vector<u_long128> storage(8192);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), storage.size());
    CMap map;
    map.SetPlacePartsBuff(&memory, 2);
    ASSERT_NE(map.place_parts, nullptr);
    auto                  *parts = map.place_parts;
    auto                  *pointers = map.draw_parts;
    std::vector<u_long128> tiny_storage(1);
    mgCMemory              tiny;
    tiny.stSetBuffer(tiny_storage.data(), tiny_storage.size());
    const auto used = tiny.stack_used;
    EXPECT_FALSE(map.SetPlacePartsBuff(&tiny, 2));
    EXPECT_FALSE(map.SetPlacePartsBuff(&tiny, -1));
    EXPECT_FALSE(map.SetPlacePartsBuff(nullptr, 2));
    EXPECT_EQ(tiny.stack_used, used);
    EXPECT_EQ(map.place_parts, parts);
    EXPECT_EQ(map.draw_parts, pointers);
    EXPECT_EQ(map.place_parts_max, 2);
    EXPECT_EQ(map.place_parts_num, 2);
}

TEST(MapStride, GroupNodesRejectLockedStorageBeforePublishingANameOrList) {
    std::vector<u_long128> storage(128);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), storage.size());
    CMap      map;
    CMapParts parts;
    char      name[] = "native-group";
    memory.stSetLocked(true);
    EXPECT_EQ(map.AddPartsGroup(name, &parts, &memory), -1);
    EXPECT_EQ(memory.stack_used, 0);
    EXPECT_EQ(map.parts_group[0].name, nullptr);
    EXPECT_EQ(map.parts_group[0].list, nullptr);
    memory.stSetLocked(false);
    ASSERT_EQ(map.AddPartsGroup(name, &parts, &memory), 0);
    ASSERT_NE(map.parts_group[0].list, nullptr);
    EXPECT_STREQ(map.parts_group[0].name, name);
    EXPECT_EQ(map.parts_group[0].list->data.parts, &parts);
    EXPECT_EQ(map.parts_group[0].list->next, nullptr);
    EXPECT_EQ(map.parts_group[0].list->prev, nullptr);
}

TEST(MapStride, DrawRectNodesPreflightTheCompleteSelectedListBeforePublication) {
    std::vector<u_long128> storage(8192);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), storage.size());
    CMap map;
    ASSERT_TRUE(map.SetPlacePartsBuff(&memory, 2));
    for (auto &parts : std::span(map.place_parts, 2)) {
        parts.name[0] = 'p';
        parts.name[1] = 0;
        parts.bound_valid = 1;
        for (int lane = 0; lane < 3; ++lane) {
            parts.bound_box.max[lane] = 1.0f;
            parts.bound_box.min[lane] = -1.0f;
        }
        parts.bound_box.max[3] = 1.0f;
        parts.bound_box.min[3] = 1.0f;
    }
    mgVu0FBOX box{};
    for (int lane = 0; lane < 3; ++lane) {
        box.max[lane] = 2.0f;
        box.min[lane] = -2.0f;
    }
    std::vector<u_long128> tiny_storage(1);
    mgCMemory              tiny;
    tiny.stSetBuffer(tiny_storage.data(), tiny_storage.size());
    map.CreateDrawRect(&tiny, &box, &box, 0);
    EXPECT_EQ(tiny.stack_used, 0);
    EXPECT_EQ(map.draw_rect[0].used, 0);
    EXPECT_EQ(map.draw_rect[0].parts, nullptr);
    map.CreateDrawRect(&memory, &box, &box, 0);
    EXPECT_EQ(map.draw_rect[0].used, 1);
    auto *node = map.draw_rect[0].parts;
    ASSERT_NE(node, nullptr);
    EXPECT_EQ(node->data, &map.place_parts[0]);
    ASSERT_NE(node->next, nullptr);
    EXPECT_EQ(node->next->data, &map.place_parts[1]);
    EXPECT_EQ(node->next->prev, node);
    EXPECT_EQ(node->next->next, nullptr);
}

TEST(MapStride, DrawPartsPointersFitBeforeTheNextAllocation) {
    std::vector<u_long128> storage(8192);
    mgCMemory              memory;
    memory.stSetBuffer(storage.data(), storage.size());
    CMap          map;
    constexpr int count = 33;
    map.SetPlacePartsBuff(&memory, count);
    ASSERT_NE(map.draw_parts, nullptr);
    const auto table_end = reinterpret_cast<std::uintptr_t>(map.draw_parts + count);
    const auto allocation_end = reinterpret_cast<std::uintptr_t>(memory.stGetTop());
    ASSERT_LE(table_end, allocation_end);
    for (int index = 0; index < count; ++index) {
        EXPECT_EQ(map.draw_parts[index], nullptr);
        map.draw_parts[index] = &map.place_parts[index];
    }
    u_long128 *next = memory.Alloc(16);
    std::memset(next, 0xA5, 16 * sizeof(u_long128));
    for (int index = 0; index < count; ++index) {
        EXPECT_EQ(map.draw_parts[index], &map.place_parts[index]);
    }
}

namespace {
class RecordingWater : public CWater {
public:
    std::vector<float> translations;

    int Draw(u_int * /*tag*/, float (*matrix)[4], mgCDrawManager * /*draw_manager*/) override {
        translations.push_back(matrix[3][0]);
        return 0;
    }
};
} // namespace

TEST(MapStride, WaterOverlayVisitsEveryPartPointer) {
    CMap           map;
    RecordingWater visual;
    CWaterFrame    frame;
    mgCFrameAttr   attr;
    attr.draw = MG_FRAME_DRAW_VISIBLE;
    attr.no_cull = 1;
    attr.point_light = 0;
    frame.attr = &attr;
    frame.visual = &visual;
    CMapWater placement;
    placement.Initialize();
    placement.SetScale(1.0f, 1.0f, 1.0f);
    placement.frame = &frame;
    CMapParts parts[2];
    parts[0].SetPosition(31.0f, 0.0f, 0.0f);
    parts[1].SetPosition(92.0f, 0.0f, 0.0f);
    CMapParts *pointers[] = {&parts[0], &parts[1]};
    placement.parts = pointers;
    placement.parts_num = 2;
    CWaterFrame *surfaces[] = {nullptr};
    map.water_surface = surfaces;
    map.water_surface_num = 1;
    map.water = &placement;
    map.water_num = 1;
    mgCTexture screen;
    mgCTexture overlay;
    map.DrawWater(nullptr, &screen, &overlay);
    EXPECT_EQ(visual.translations, (std::vector<float>{31.0f, 92.0f, 31.0f, 92.0f}));
}

TEST(MapStride, PlacedPartListUsesHostObjectsAndTheirNames) {
    CEditMap   map;
    CEditParts parts[5];
    map.edit_parts = parts;
    map.edit_parts_max = 5;
    for (auto &part : parts) {
        part.name[0] = '\0';
    }
    parts[1].name[0] = 'A';
    parts[4].name[0] = 'B';
    int output[4] = {-1, -1, -1, -1};
    EXPECT_EQ(map.GetePlaceIDList(output, 4), 2);
    EXPECT_EQ(output[0], 1);
    EXPECT_EQ(output[1], 4);
    EXPECT_EQ(output[2], -1);
    output[0] = -1;
    EXPECT_EQ(map.GetePlaceIDList(output, 1), 1);
    EXPECT_EQ(output[0], 1);
    output[0] = -1;
    EXPECT_EQ(map.GetePlaceIDList(output, 0), 0);
    EXPECT_EQ(output[0], -1);
}
