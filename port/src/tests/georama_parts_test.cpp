#include <gtest/gtest.h>

#include <algorithm>
#include <cstring>
#include <functional>
#include <memory>
#include <random>
#include <set>
#include <span>
#include <string>
#include <utility>
#include <vector>

#include "collision.hpp"
#include "editdata.hpp"
#include "editmap.hpp"
#include "editparts.hpp"
#include "save_json.hpp"
#include "stubs/editmap.hpp"

int CheckFenceChain(CEditParts *a, CEditParts *b);

namespace {

/**
 * A town edit map with part definitions that all build from one empty model.
 */
class Town {
public:
    std::unique_ptr<CEditMap>          map = std::make_unique<CEditMap>();
    std::unique_ptr<CList<CMapParts> > model = std::make_unique<CList<CMapParts> >();
    std::vector<CEditPartsInfo>        infos;
    std::vector<std::string>           names;
    std::vector<ePlaceData>            fixed;

    explicit Town(int heap_size = 0xA000) {
        infos.reserve(16);
        names.reserve(16);
        std::strcpy(model->data.name, "model");
        model->data.bound_valid = 1;
        model->data.bound_sphere[3] = 6.0f;
        model->data.color_num = 1;
        map->parts_list = model.get();
        map->CreateTable(nullptr, 0x100, heap_size);
    }

    CEditPartsInfo &Define(int id, u32 attr) {
        infos.emplace_back();
        names.push_back("part" + std::to_string(id));
        CEditPartsInfo &info = infos.back();
        info.id = id;
        info.attr = attr;
        info.edit_name = names.back().data();
        info.parts_name = model->data.name;
        // Initialize leaves area3_box for the part's collision data to fill, as retail does.
        std::ranges::fill(info.area3_box.max, 0.0f);
        std::ranges::fill(info.area3_box.min, 0.0f);
        map->info_mngr.parts_info = infos.data();
        map->info_mngr.parts_info_num = static_cast<int>(infos.size());
        return info;
    }

    int Build(int id) {
        return map->BuildEditParts(map->GetePartsInfoAtID(id)->edit_name);
    }

    CEditParts &Part(int slot) {
        return map->edit_parts[slot];
    }

    // Logs that a placed part rests on another in the first free entry, as CreatePlaceLog does.
    void Rest(int part, int base) {
        for (int i = 0; i < map->place_log_max; ++i) {
            if (map->place_log[i].parts_no < 0) {
                map->place_log[i] = {.parts_no = static_cast<s16>(part), .base_no = static_cast<s16>(base)};
                return;
            }
        }
        FAIL() << "placement log full";
    }

    bool InParts(const u_long128 *address) const {
        return address >= map->parts_heap.heap && address < map->parts_heap.heap + map->parts_heap.heap_size;
    }
};

/**
 * Retail's recursive removal over a plain copy of a town, for comparison.
 */
struct ReferenceTown {
    struct Slot {
        bool alive{};
        int  id{};
        u32  attr{};
        int  npc{};
    };

    std::vector<Slot>         slots;
    std::vector<EditPlaceLog> log;
    std::vector<int>          parts_num = std::vector<int>(EDIT_REMOVE_INFO_ID_MAX);
    std::vector<int>          npcs;

    void Remove(int index) {
        if (index < 0 || std::cmp_greater_equal(index, slots.size())) {
            return;
        }
        Slot &slot = slots[index];
        if (slot.alive && (slot.attr & EDIT_PARTS_ATR_NO_REMOVE) != 0) {
            return;
        }
        if (slot.alive) {
            ++parts_num[slot.id];
            if (slot.npc > 0) {
                npcs.push_back(slot.npc);
            }
        }
        slot.alive = false;
        for (std::size_t m = 0; m < log.size(); ++m) {
            if (log[m].parts_no != static_cast<s16>(index)) {
                continue;
            }
            for (std::size_t n = 0; n < log.size(); ++n) {
                if (n != m && log[n].base_no == index) {
                    Remove(log[n].parts_no);
                }
            }
            log[m].parts_no = -1;
        }
    }
};

float kFar[4] = {1.0e7f, 1.0e7f, 1.0e9f, 1.0f};

} // namespace

TEST(GeoramaParts, SlotsGrowAsOneBlockWithTheirLog) {
    Town town;
    town.Define(1, 0);
    CEditParts *first = town.map->edit_parts;
    ASSERT_EQ(town.map->edit_parts_max, 0x100);
    ASSERT_EQ(town.Build(1), 0);
    CEditParts *kept = &town.Part(0);
    int         built = 1;
    for (const int count : {300, 4096, 5000}) {
        for (; built < count; ++built) {
            ASSERT_EQ(town.Build(1), built);
        }
        EXPECT_EQ(town.map->edit_parts, first);
        EXPECT_EQ(town.map->edit_parts_max, count);
        EXPECT_EQ(town.map->place_log_max, count * EDIT_MAP_LOG_PER_PARTS);
        EXPECT_EQ(&town.Part(0), kept);
        EXPECT_STREQ(town.Part(count - 1).name, "model");
        EXPECT_EQ(town.Part(count - 1).info, town.map->GetePartsInfoAtID(1));
    }
    for (int i = 0; i < town.map->place_log_max; ++i) {
        ASSERT_LT(town.map->place_log[i].parts_no, 0) << i;
    }
    int listed[5000];
    EXPECT_EQ(town.map->GetePlaceIDList(listed, 5000), 5000);
    EXPECT_EQ(listed[4999], 4999);
}

TEST(GeoramaParts, ModelsMoveToNewHeapsAndFreeFromTheirOwn) {
    Town town(300);
    town.Define(1, 0);
    for (int i = 0; i < 1500; ++i) {
        ASSERT_GE(town.Build(1), 0);
    }
    const auto outside = std::ranges::count_if(std::span(town.map->edit_parts, 1500), [&](const CEditParts &part) {
        return !town.InParts(part.allocation_address);
    });
    EXPECT_GT(outside, 0);
    for (int i = 0; i < 1500; i += 2) {
        ASSERT_EQ(town.map->DeleteEditParts(i), 1);
    }
    for (int i = 0; i < 750; ++i) {
        ASSERT_GE(town.Build(1), 0);
    }
    town.map->ClearAllParts();
    for (int i = 0; i < town.map->edit_parts_max; ++i) {
        ASSERT_EQ(town.Part(i).name[0], '\0');
    }
    ASSERT_EQ(town.Build(1), 0);
    EXPECT_TRUE(town.InParts(town.Part(0).allocation_address));
}

TEST(GeoramaParts, HousesGrowBeyondThirtyTwoAndKeepTheirPlace) {
    Town town;
    town.Define(2, EDIT_PARTS_ATR_TYPE_ONE);
    std::set<CEditHouse *> houses;
    for (int i = 0; i < 40; ++i) {
        const int slot = town.Build(2);
        ASSERT_GE(slot, 0);
        ASSERT_NE(town.Part(slot).house, nullptr);
        EXPECT_EQ(town.Part(slot).house->active, 1);
        town.Part(slot).house->npc_no[0] = i + 1;
        houses.insert(town.Part(slot).house);
    }
    EXPECT_EQ(houses.size(), 40);
    EXPECT_EQ(PortEditHouseCount(*town.map), 40);
    EXPECT_EQ(town.map->CheckLiveNPC(-1, -1), 0); // Nothing is placed yet.
    CEditHouse *freed = town.Part(35).house;
    ASSERT_EQ(town.map->DeleteEditParts(35), 1);
    EXPECT_EQ(freed->active, 0);
    EXPECT_EQ(town.Build(2), 35);
    EXPECT_EQ(town.Part(35).house, freed);
    EXPECT_EQ(PortEditHouseCount(*town.map), 40);
}

TEST(GeoramaParts, TheSlotCeilingRefusesTheNextPart) {
    Town town;
    PortEditReserveSlots(*town.map, kPortEditSlotCeiling + 10);
    ASSERT_EQ(town.map->edit_parts_max, kPortEditSlotCeiling);
    for (int i = 0; i < town.map->edit_parts_max; ++i) {
        town.Part(i).name[0] = 'x';
    }
    EXPECT_EQ(town.map->eNewPlaceParts(), EDIT_BUILD_NO_SLOT);
    town.Part(kPortEditSlotCeiling - 1).name[0] = '\0';
    EXPECT_EQ(town.map->eNewPlaceParts(), kPortEditSlotCeiling - 1);
}

TEST(GeoramaParts, CollisionTagsNameSlotsBeyond4095) {
    for (const int slot : {0, 300, 4095, 4096, 5000, kPortEditSlotCeiling - 1}) {
        const auto tag = static_cast<u_short>(static_cast<s16>(static_cast<u16>(slot)) | CCPOLY_PARTS_EDIT);
        EXPECT_NE(tag & CCPOLY_PARTS_EDIT, 0) << slot;
        EXPECT_EQ(tag & CCPOLY_PARTS_SLOT_MASK, slot) << slot;
    }
}

TEST(GeoramaParts, RemovalMatchesRetailRecursion) {
    for (unsigned seed = 1; seed <= 20; ++seed) {
        Town town;
        town.Define(1, 0);
        town.Define(2, EDIT_PARTS_ATR_TYPE_ONE);
        town.Define(3, EDIT_PARTS_ATR_NO_REMOVE);
        std::mt19937  random(seed);
        ReferenceTown reference;
        const int     count = 150;
        for (int i = 0; i < count; ++i) {
            const int id = 1 + static_cast<int>(random() % 3);
            const int slot = town.Build(id);
            ASSERT_EQ(slot, i);
            town.Part(slot).state = EDIT_PARTS_STATE_PLACED;
            const int npc = id == 2 ? static_cast<int>(random() % 4) : 0;
            if (town.Part(slot).house != nullptr) {
                town.Part(slot).house->npc_no[0] = npc;
            }
            reference.slots.push_back({.alive = true, .id = id, .attr = town.Part(slot).info->attr, .npc = npc});
            const int bases = i == 0 ? 0 : static_cast<int>(random() % 3);
            for (int b = 0; b < bases; ++b) {
                town.Rest(i, static_cast<int>(random() % i));
            }
        }
        // Freed entries keep their base, as retail leaves them.
        for (int i = 0; i < 20; ++i) {
            const int entry = static_cast<int>(random() % town.map->place_log_max);
            if (town.map->place_log[entry].parts_no < 0) {
                town.map->place_log[entry].base_no = static_cast<s16>(random() % count);
            }
        }
        reference.log.assign(town.map->place_log, town.map->place_log + town.map->place_log_max);
        const int start = static_cast<int>(random() % 20);

        CEditMap::RemoveInfo info{};
        reference.Remove(start);
        town.map->RemoveEditParts(start, kFar, &info);

        for (int i = 0; i < count; ++i) {
            EXPECT_EQ(town.Part(i).name[0] != '\0', reference.slots[i].alive) << seed << " slot " << i;
        }
        for (int i = 0; i < town.map->place_log_max; ++i) {
            EXPECT_EQ(town.map->place_log[i].parts_no, reference.log[i].parts_no) << seed << " entry " << i;
        }
        for (int id = 0; id < 4; ++id) {
            EXPECT_EQ(info.parts_num[id], reference.parts_num[id]) << seed;
        }
        ASSERT_EQ(info.house_num, static_cast<int>(reference.npcs.size())) << seed;
        for (int i = 0; i < info.house_num; ++i) {
            EXPECT_EQ(info.house_npc[i], reference.npcs[i]) << seed;
        }
    }
}

TEST(GeoramaParts, TallStacksAreRemovedWithoutRecursing) {
    Town town;
    town.Define(1, 0);
    const int count = 6000;
    for (int i = 0; i < count; ++i) {
        ASSERT_EQ(town.Build(1), i);
        town.Part(i).state = EDIT_PARTS_STATE_PLACED;
        if (i > 0) {
            town.Rest(i, i - 1);
        }
    }
    // A part with no log entry of its own takes none of the parts resting on it, as retail does.
    CEditMap::RemoveInfo info{};
    EXPECT_EQ(town.map->RemoveEditParts(0, kFar, &info), 1);
    EXPECT_STREQ(town.Part(1).name, "model");
    EXPECT_EQ(town.map->RemoveEditParts(1, kFar, &info), 1);
    for (int i = 1; i < count; ++i) {
        ASSERT_EQ(town.Part(i).name[0], '\0') << i;
    }
    EXPECT_EQ(info.parts_num[1], count);
}

TEST(GeoramaParts, CultureAnalysisMatchesRetailParts) {
    Town  town;
    auto &main = town.Define(1, 0);
    main.cpoint[0] = EDIT_CULTURE_KIND_MAIN;
    main.cpoint[1] = 100;
    auto &territory = town.Define(2, 0);
    territory.cpoint[0] = EDIT_CULTURE_KIND_TERRITORY;
    territory.cpoint[1] = 10;
    auto &child = town.Define(3, 0);
    child.cpoint[0] = EDIT_CULTURE_KIND_CHILD;
    child.cpoint[1] = 5;
    auto &alone = town.Define(4, 0);
    alone.cpoint[0] = EDIT_CULTURE_KIND_ALONE;
    alone.cpoint[1] = 1;
    for (auto &info : town.infos) {
        info.territory_radius = 40.0f;
        info.territory_height = 40.0f;
    }
    // Retail counts at most 0x200 parts of a territory; the town stays below that, where both counts agree.
    std::mt19937 random(9);
    for (int i = 0; i < 400; ++i) {
        const int id = 1 + static_cast<int>(random() % 4);
        const int slot = town.Build(id);
        ASSERT_EQ(slot, i);
        town.Part(slot).state = EDIT_PARTS_STATE_PLACED;
        town.Part(slot).SetPosition(static_cast<float>(random() % 2000), 0.0f, static_cast<float>(random() % 2000));
        if (i > 0 && random() % 2 == 0) {
            town.Rest(i, static_cast<int>(random() % i));
        }
    }
    int retail = 0;
    for (int i = 0; i < town.map->edit_parts_max; ++i) {
        retail += town.map->CultureAnalyzeParts(i, 0);
    }
    EXPECT_GT(retail, 0);
    EXPECT_EQ(town.map->CultureAnalyze(0), retail);
}

TEST(GeoramaParts, PaintedFencesMatchRetailRecursion) {
    Town  town;
    auto &fence = town.Define(1, EDIT_PARTS_ATR_FENCE);
    fence.paint_num = 1;
    fence.area3_box.max[0] = 5.0f;
    fence.area3_box.min[0] = -5.0f;
    // Two chains joined end to end, a stray fence, and a chain far away.
    const std::vector<std::pair<float, float> > spots = {
        {0,    0 },
        {10,   0 },
        {20,   0 },
        {30,   0 },
        {30,   10},
        {500,  0 },
        {1000, 0 },
        {1010, 0 },
        {15,   0 },
        {40,   0 },
    };
    for (const auto &[x, z] : spots) {
        const int slot = town.Build(1);
        town.Part(slot).state = EDIT_PARTS_STATE_PLACED;
        town.Part(slot).SetPosition(x, 0.0f, z);
    }
    // Retail's recursion over the same fences.
    std::vector<CEditParts *> pending;
    for (int i = 1; std::cmp_less(i, spots.size()); ++i) {
        pending.push_back(&town.Part(i));
    }
    std::set<CEditParts *>            expected{&town.Part(0)};
    std::function<void(CEditParts *)> paint = [&](CEditParts *from) {
        for (auto &candidate : pending) {
            if (candidate != nullptr && CheckFenceChain(from, candidate) != 0) {
                CEditParts *next = std::exchange(candidate, nullptr);
                expected.insert(next);
                paint(next);
            }
        }
    };
    paint(&town.Part(0));
    ASSERT_GT(expected.size(), 2);
    ASSERT_LT(expected.size(), spots.size());

    float color[4] = {0.5f, 1.0f, 1.5f, 1.0f};
    EXPECT_EQ(town.map->PaintFence(0, color, 100), static_cast<int>(expected.size()));
    EXPECT_EQ(town.map->paint_num, 100 - static_cast<int>(expected.size()));
    for (int i = 0; std::cmp_less(i, spots.size()); ++i) {
        float      painted[4] = {};
        const bool has = town.Part(i).GetColor(0, painted) != 0 && painted[0] == 0.5f && painted[2] == 1.5f;
        EXPECT_EQ(has, expected.contains(&town.Part(i))) << i;
    }
}

TEST(GeoramaParts, SavedTownsOfThousandsOfPartsLoadBack) {
    Town  town;
    auto &ground = town.Define(1, EDIT_PARTS_ATR_GROUND);
    town.Define(2, 0);
    town.Define(3, EDIT_PARTS_ATR_TYPE_ONE);
    town.fixed.push_back({});
    town.fixed[0].id = ground.id;
    town.map->info_mngr.fix_parts = town.fixed.data();
    town.map->info_mngr.fix_parts_num = 1;
    town.map->ClearAllParts();
    ASSERT_EQ(town.Part(0).state, EDIT_PARTS_STATE_PLACED);

    const int count = 5000;
    for (int i = 1; i < count; ++i) {
        const int slot = town.Build(i % 10 == 0 ? 3 : 2);
        ASSERT_EQ(slot, i);
        town.Part(slot).state = EDIT_PARTS_STATE_PLACED;
        town.Part(slot).SetPosition(static_cast<float>(i % 100), static_cast<float>(i % 7), static_cast<float>(i / 100));
        town.Part(slot).SetRotation(0.0f, town.map->GetEditAngle(i % EDIT_ANGLE_MAX), 0.0f);
        if (town.Part(slot).house != nullptr) {
            town.Part(slot).house->npc_no[0] = i;
        }
        town.Rest(i, i < 100 ? 0 : i - 100);
    }
    auto record = std::make_unique<CEditData>();
    town.map->SaveData(record.get());
    const TownLayout *layout = PortFindTownLayout(*record);
    ASSERT_NE(layout, nullptr);
    ASSERT_EQ(layout->parts.size(), count);
    EXPECT_EQ(layout->place_log.size(), count - 1);
    EXPECT_GE(layout->houses.size(), (count - 1) / 10);

    town.map->ClearAllParts();
    town.map->LoadData(record.get());
    for (int i = 1; i < count; ++i) {
        CEditParts &part = town.Part(i);
        ASSERT_STREQ(part.name, "model") << i;
        ASSERT_EQ(part.GetInfoID(), i % 10 == 0 ? 3 : 2) << i;
        ASSERT_EQ(part.state, EDIT_PARTS_STATE_PLACED) << i;
        float pos[4];
        part.GetPosition(pos);
        ASSERT_EQ(pos[0], static_cast<float>(i % 100)) << i;
        ASSERT_EQ(pos[2], static_cast<float>(i / 100)) << i;
        if (i % 10 == 0) {
            ASSERT_NE(part.house, nullptr) << i;
            EXPECT_EQ(part.house->npc_no[0], i) << i;
        }
    }
    auto again = std::make_unique<CEditData>();
    town.map->SaveData(again.get());
    ASSERT_NE(PortFindTownLayout(*again), nullptr);
    EXPECT_EQ(PortFindTownLayout(*again)->parts.size(), count);
}
