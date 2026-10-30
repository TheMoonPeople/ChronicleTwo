#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <algorithm>
#include <array>
#include <chrono>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <limits>
#include <memory>
#include <new>
#include <string>
#include <vector>

#include "actionchara.hpp"
#include "assets/data_registry.hpp"
#include "dataread.hpp"
#include "editmap.hpp"
#include "fishing.hpp"
#include "inventmn.hpp"
#include "log_capture.hpp"
#include "mainloop.hpp"
#include "map.hpp"
#include "mapinfo.hpp"
#include "mapsky.hpp"
#include "mdslist.hpp"
#include "menuaqua.hpp"
#include "mg_dataset.hpp"
#include "mg_memory.hpp"
#include "mg_visual.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "platform/datapacks.hpp"
#include "quest.hpp"
#include "scene_documents.hpp"
#include "stubs/editmap.hpp"
#include "stubs/fishing.hpp"
#include "stubs/mapsky.hpp"
#include "texture_source.hpp"

namespace {
using Json = nlohmann::json;

/**
 * Builds a named frame entirely in its explicitly supplied test producer.
 */
mgCFrame *NewGraphFrame(mgCMemory &producer, std::string_view name) {
    auto *frame = dc2::memory::NewObject<mgCFrame>(producer);
    auto *text = dc2::memory::NewArray<char>(producer, name.size() + 1);
    if (frame == nullptr || text == nullptr) {
        return nullptr;
    }
    std::memcpy(text, name.data(), name.size());
    text[name.size()] = '\0';
    frame->name = text;
    return frame;
}

/**
 * Writes native documents into an isolated converted-data root and hands loaders their buffers.
 */
class NativeRecords : public testing::Test {
protected:
    std::filesystem::path    previous_root = datapacks::Root();        /**< Native data root restored after the fixture. */
    std::filesystem::path    directory;                                /**< Fixture root. */
    std::vector<std::string> buffers;                                  /**< Registered stand-ins for loaded script buffers. */
    std::vector<u_long128>   storage = std::vector<u_long128>(0x4000); /**< Memory the loaders allocate from. */
    mgCMemory                memory;                                   /**< Allocator over storage. */

    void SetUp() override {
        directory = std::filesystem::temp_directory_path() / ("chronicle_native_records_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
        std::filesystem::create_directories(directory / "data");
        memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
        buffers.reserve(16);
    }

    void TearDown() override {
        for (auto &buffer : buffers) {
            TextureSourceForget(buffer.data());
        }
        if (previous_root.empty()) {
            DataReadIndex(directory / "empty/data");
            datapacks::Clear();
        } else {
            DataReadIndex(previous_root.parent_path() / "data");
        }
        std::filesystem::remove_all(directory);
    }

    /**
     * Publishes a document and gives a buffer registered as its loaded bytes.
     */
    char *Publish(const std::string &name, const char *kind, Json body) {
        body["schema_version"] = 2;
        body["kind"] = kind;
        const auto path = directory / "data" / name;
        std::filesystem::create_directories(path.parent_path());
        std::ofstream(path, std::ios::binary) << body.dump(2);
        DataReadIndex(directory / "data");
        buffers.push_back(body.dump());
        auto &bytes = buffers.back();
        DataReadRegisterAsset(bytes.data(), name, bytes.size());
        return bytes.data();
    }
};
} // namespace

TEST_F(NativeRecords, QuestsFillCommentsAndReactionsInOrder) {
    char         *script = Publish("menu/1/quest.pac/quest1.cfg.json", "quests",
                                   {
                                       {"count",  2                                                                                                                                          },
                                       {"quests", Json::array({{{"id", 7}, {"name", "Lost cat"}, {"comment", "Find it"}, {"reactions", {"Thanks", "Done"}}}, {{"id", 8}, {"name", "Other"}}})}
    });
    CQuestManager manager;
    manager.Initialize();
    manager.LoadCfg(&memory, script, 0);
    ASSERT_EQ(manager.num, 2);
    EXPECT_EQ(manager.info[0].id, 7);
    EXPECT_STREQ(manager.info[0].name, "Lost cat");
    EXPECT_STREQ(manager.info[0].comment, "Find it");
    EXPECT_STREQ(manager.info[0].reaction[1], "Done");
    EXPECT_EQ(manager.GetQuestInfo(8), &manager.info[1]);
}

TEST_F(NativeRecords, OverlongQuestNamesRefuseTheDocument) {
    char         *script = Publish("menu/1/quest.pac/quest1.cfg.json", "quests",
                                   {
                                       {"count",  1                                                           },
                                       {"quests", Json::array({{{"id", 7}, {"name", std::string(0x84, 'x')}}})}
    });
    CQuestManager manager;
    manager.Initialize();
    CaptureLoggedStderr();
    manager.LoadCfg(&memory, script, 0);
    EXPECT_NE(GetLoggedStderr().find("longer than the game holds"), std::string::npos);
    EXPECT_EQ(manager.num, 0);
}

TEST_F(NativeRecords, QuestCountsCannotOverflowOrExceedTheAvailableArena) {
    CQuestManager manager;
    char         *overflow = Publish("menu/1/quest.pac/quest1.cfg.json", "quests",
                                     {
                                         {"count",  std::numeric_limits<int>::max()},
                                         {"quests", Json::array()                  }
    });
    CaptureLoggedStderr();
    manager.LoadCfg(&memory, overflow, 0);
    EXPECT_NE(GetLoggedStderr().find("request count exceeds"), std::string::npos);
    EXPECT_EQ(manager.num, 0);

    const int too_many = static_cast<int>(static_cast<std::size_t>(memory.stGetRest()) * sizeof(u_long128) / sizeof(QUEST_INFO) + 1);
    char     *too_large = Publish("menu/1/quest.pac/quest1.cfg.json", "quests",
                                  {
                                      {"count",  too_many     },
                                      {"quests", Json::array()}
    });
    manager.LoadCfg(&memory, too_large, 0);
    EXPECT_EQ(manager.num, 0);
    EXPECT_EQ(manager.info, nullptr);
    EXPECT_EQ(memory.stack_used, 0);
}

TEST_F(NativeRecords, RaceFishCountsFitTheArenaAndIndicesStayInRange) {
    const auto saved_language = LanguageCode;
    LanguageCode = 0;
    Publish("sg/gyo/rfd0.cfg.json", "race_fish", {
                                                     {"classes", Json::array({{{"class", 0}, {"count", 32767}, {"fish", Json::array()}}})}
    });
    CGyoraceFishData race{};
    EXPECT_EQ(race.LoadData(&memory, nullptr), 0);
    EXPECT_EQ(memory.stack_used, 0);
    EXPECT_EQ(race.fish_num[0], 0);

    Publish("sg/gyo/rfd0.cfg.json", "race_fish", {
                                                     {"classes", Json::array({{{"class", 0}, {"count", 1}, {"fish", Json::array()}}})}
    });
    ASSERT_EQ(race.LoadData(&memory, nullptr), 1);
    EXPECT_EQ(race.fish_num[0], 1);
    EXPECT_EQ(race.GetRaceFish(0, -1), nullptr);
    EXPECT_EQ(race.GetRaceFish(0, 1), nullptr);
    LanguageCode = saved_language;
}

TEST_F(NativeRecords, FishingPlacesKeepTheirAreaAndAtMostEightFish) {
    Json fish = Json::array();
    for (int index = 0; index < 10; ++index) {
        fish.push_back({
            {"fish",      index},
            {"rate",      0.5  },
            {"wait_bias", 0    }
        });
    }
    char *script = Publish("sg/fish/fishing.cfg.json", "fishing_places",
                           {
                               {"count", 1                                                                                                                                                                                 },
                               {"maps",  Json::array({{{"map", 3}, {"exclusive", 1}, {"place", {{"area_type", 9}, {"name", "pond"}, {"params", {1, 2, 3, 4, 5}}}}, {"fish", fish}}, {{"map", 4}, {"fish", Json::array()}}})}
    });
    LoadFishPlaceData(script, 0, &memory);
    ASSERT_EQ(FishPlaceMapNum, 1);
    EXPECT_EQ(FishPlaceMap[0].map_no, 3);
    EXPECT_EQ(FishPlaceMap[0].exclusive, 1);
    // An area shape outside the known shapes is read as shape 0.
    EXPECT_EQ(FishPlaceMap[0].area_type, 0);
    EXPECT_STREQ(FishPlaceMap[0].name, "pond");
    EXPECT_FLOAT_EQ(FishPlaceMap[0].area_param[4], 5.0f);
    EXPECT_EQ(FishPlaceMap[0].fish_num, 8);
    EXPECT_FLOAT_EQ(FishPlaceMap[0].fish[7].rate, 0.5f);
}

TEST_F(NativeRecords, ScoopTextsGoToTheirScoops) {
    char *script = Publish("menu/1/scoop.pac/scoop.cfg.json", "scoop_texts",
                           {
                               {"entries", Json::array({{{"id", 1000}, {"text", "First scoop"}}, {{"id", 1001}, {"text", nullptr}}})}
    });
    AnalyzeScoopString(&memory, script, 0);
    SCOOP_DATA *first = GetScoopDataTable(1000);
    ASSERT_NE(first, nullptr);
    EXPECT_STREQ(first->text, "First scoop");
    SCOOP_DATA *second = GetScoopDataTable(1001);
    ASSERT_NE(second, nullptr);
    EXPECT_EQ(second->text, nullptr);
}

TEST_F(NativeRecords, SkyBandsConvertDegreesAsRetailDoes) {
    char        *script = Publish("map/s.sky/info.cfg.json", "sky",
                                  {
                                      {"images",          Json::array({{{"band", 0}, {"file", "a.json"}}, {{"band", 7}, {"file", "skipped.json"}}})},
                                      {"models",          Json::array({{{"band", 1}, {"file", "sky.gltf"}, {"rotation_degrees", 90.0}}})           },
                                      {"animations",      Json::array({{{"band", 1}, {"frame", "cloud"}, {"speed_degrees", 180.0}}})               },
                                      {"suns",            Json::array()                                                                            },
                                      {"back_models",     Json::array()                                                                            },
                                      {"back_animations", Json::array()                                                                            },
                                      {"backgrounds",     Json::array({{{"file", "bg.gltf"}}})                                                     }
    });
    MAP_SKY_INFO info{};
    PortLoadSkyInfo(&info, script, 1);
    EXPECT_STREQ(info.img_name[0], "a.json");
    EXPECT_STREQ(info.sky_mds_name[1], "sky.gltf");
    EXPECT_FLOAT_EQ(info.sky_rot_speed[1], 90.0f * PI / 180.0f);
    EXPECT_EQ(info.sky_anime_id[0], 1);
    EXPECT_STREQ(info.sky_anime_name[0], "cloud");
    EXPECT_FLOAT_EQ(info.sky_anime_speed[0], PI);
    EXPECT_STREQ(info.bg_mds_name, "bg.gltf");
}

TEST_F(NativeRecords, SkyNameUsesTheFullTerminatedFieldWithoutOverflow) {
    const std::string maximum(31, 's');
    auto              sky_document = [&](std::string name) {
        return Json{
            {"images",          Json::array()                             },
            {"models",          Json::array()                             },
            {"animations",      Json::array()                             },
            {"suns",            Json::array()                             },
            {"back_models",     Json::array()                             },
            {"back_animations", Json::array()                             },
            {"backgrounds",     Json::array({{{"file", std::move(name)}}})}
        };
    };
    char        *script = Publish("map/s.sky/info.cfg.json", "sky", sky_document(maximum));
    MAP_SKY_INFO info{};
    PortLoadSkyInfo(&info, script, 1);
    EXPECT_STREQ(info.bg_mds_name, maximum.c_str());

    char        *oversized = Publish("map/s.sky/info.cfg.json", "sky", sky_document(maximum + "s"));
    MAP_SKY_INFO rejected{};
    CaptureLoggedStderr();
    PortLoadSkyInfo(&rejected, oversized, 1);
    EXPECT_NE(GetLoggedStderr().find("name is longer than the sky holds"), std::string::npos);
    EXPECT_EQ(rejected.bg_mds_name[0], '\0');
}

TEST_F(NativeRecords, MapInfoReadsPacksLightingAndSettings) {
    Json light_set = {
        {"index",        2                                                                                           },
        {"fov",          true                                                                                        },
        {"bg_color",     {10, 20, 30}                                                                                },
        {"bg_color2",    {0, 0, 0}                                                                                   },
        {"lights",       Json::array({{{"index", 1}, {"direction", {0, -2, 0}}}, {{"index", 2}}})                    },
        {"point_lights", Json::array({{{"index", 0}, {"power", 2.0}, {"position", {1, 2, 3}}, {"color", {4, 5, 6}}}})},
        {"fog",          {{"near", 10}, {"far", 20}}                                                                 }
    };
    char     *script = Publish("map/s/s01/s01.map.json", "scene_map",
                               {
                                   {"info",       {{"texture_packs", {"t.json", "u.json"}}, {"model_packs", {"p.pcp"}}, {"light_sets", Json::array({light_set})}, {"time", {{"enable", 1}, {"blend", 0}}}, {"sky", {{"info", 1}, {"height", 5}, {"sun_angle_degrees", 90}}}}},
                                   {"parts",      Json::array()                                                                                                                                                                                                             },
                                   {"placements", Json::array()                                                                                                                                                                                                             }
    });
    auto      info = std::make_unique<CMapInfo>();
    const int screen_width = mgScreenWidth;
    mgScreenWidth = 640;
    info->Initialize();
    info->LoadMapInfo(script, static_cast<int>(std::strlen(script)), &memory);
    mgScreenWidth = screen_width;
    EXPECT_STREQ(info->GetImgName(1), "u.json");
    EXPECT_STREQ(info->GetPCPName(0), "p.pcp");
    EXPECT_EQ(info->GetPCPName(1), nullptr);
    CMapLightingInfo *set = info->GetLightingInfo(2);
    ASSERT_NE(set, nullptr);
    EXPECT_GT(set->projection, 0.0f);
    // A black second background takes the first.
    EXPECT_FLOAT_EQ(set->bg_color2[2], 30.0f);
    EXPECT_FLOAT_EQ(set->light_dir[1][1], -1.0f);
    EXPECT_EQ(set->plight_enable, 1);
    EXPECT_EQ(set->fog.r, 255);
    EXPECT_FLOAT_EQ(set->fog.near_value, 255.0f);
    EXPECT_EQ(info->time_enable, 1);
    EXPECT_FLOAT_EQ(info->fixed_time, 12.0f);
    EXPECT_FLOAT_EQ(info->sun_angle, HALF_PI);
    // The map keeps the document's bytes for the map loader, still traceable to the document.
    int size = 0;
    EXPECT_EQ(DataReadBufferPath(info->GetMapFile(&size)), "map/s/s01/s01.map.json");
}

TEST_F(NativeRecords, CommandDocumentsAreRefused) {
    const auto path = directory / "data/menu/1/quest.pac/quest1.cfg.json";
    std::filesystem::create_directories(path.parent_path());
    std::ofstream(path, std::ios::binary) << R"({"schema_version":1,"commands":[{"command":"NUM","args":[{"type":"int","value":3}]}]})";
    DataReadIndex(directory / "data");
    std::string bytes = "{}";
    DataReadRegisterAsset(bytes.data(), "menu/1/quest.pac/quest1.cfg.json", bytes.size());
    CQuestManager manager;
    manager.Initialize();
    CaptureLoggedStderr();
    manager.LoadCfg(&memory, bytes.data(), 0);
    EXPECT_NE(GetLoggedStderr().find("command-list"), std::string::npos);
    EXPECT_EQ(manager.num, 0);
    TextureSourceForget(bytes.data());
}

TEST_F(NativeRecords, MapInfoRejectsInvalidExtentsAndFailedStorageBeforePublication) {
    char      *script = Publish("map/allocation.map.json", "scene_map", {
                                                                            {"info",       {{"texture_packs", {"one.json"}}, {"model_packs", {"one.pcp"}}, {"light_sets", Json::array()}}},
                                                                            {"parts",      Json::array()                                                                                 },
                                                                            {"placements", Json::array()                                                                                 }
    });
    const auto size = static_cast<int>(DataReadBufferSize(script));
    CMapInfo   info{};
    info.floor = 42;
    info.LoadMapInfo(nullptr, size, &memory);
    info.LoadMapInfo(script, -1, &memory);
    info.LoadMapInfo(script, size + 1, &memory);
    info.LoadMapInfo(script, size, nullptr);
    EXPECT_EQ(info.map_file, nullptr);
    EXPECT_EQ(info.lighting_info, nullptr);
    EXPECT_EQ(info.floor, 42);
    mgCMemory empty;
    info.LoadMapInfo(script, size, &empty);
    EXPECT_EQ(info.map_file, nullptr);
    EXPECT_EQ(info.lighting_info, nullptr);
    info.LoadMapInfo(script, size, &memory);
    ASSERT_NE(info.map_file, nullptr);
    ASSERT_NE(info.lighting_info, nullptr);
    const auto *original = info.map_file;
    info.AddMapInfo(script, size, &empty);
    EXPECT_EQ(info.add_map_file, nullptr);
    EXPECT_EQ(info.map_file, original);
    EXPECT_EQ(info.floor, 42);
}

TEST(MapInfoState, ConstructionAndResetUseTheSameTypedDefaults) {
    CMapInfo info;
    EXPECT_EQ(info.time_light_num, 4);
    EXPECT_FLOAT_EQ(info.fixed_time, 12.0f);
    EXPECT_EQ(info.lens_flare, 1);
    EXPECT_EQ(info.map_file, nullptr);
    info.time_light_num = 7;
    info.fixed_time = 3.0f;
    info.lens_flare = 0;
    info.floor = 42.0f;
    char name[] = "temporary";
    info.img_name[0] = name;
    info.Initialize();
    EXPECT_EQ(info.time_light_num, 4);
    EXPECT_FLOAT_EQ(info.fixed_time, 12.0f);
    EXPECT_EQ(info.lens_flare, 1);
    EXPECT_FLOAT_EQ(info.floor, 0.0f);
    EXPECT_EQ(info.img_name[0], nullptr);
}

TEST_F(NativeRecords, MapConstructionRejectsArenaExhaustionBeforePlacementConstruction) {
    char     *script = Publish("map/checked-objects.map.json", "scene_map", {
                                                                                {"info",       {{"texture_packs", Json::array()}, {"model_packs", Json::array()}, {"light_sets", Json::array()}}},
                                                                                {"parts",      Json::array({{{"name", "definition"}, {"pieces", Json::array()}}})                               },
                                                                                {"placements", Json::array()                                                                                    }
    });
    auto      map = std::make_unique<CMap>();
    mgCMemory empty;
    map->LoadMapFile(script, 1, nullptr, 0);
    map->LoadMapFile(script, 1, &empty, 0);
    EXPECT_EQ(map->parts_list, nullptr);
    memory.stSetLocked(true);
    map->LoadMapFile(script, 1, &memory, 0);
    EXPECT_EQ(map->parts_list, nullptr);
    memory.stSetLocked(false);
    map->LoadMapFile(script, 1, &memory, 0);
    EXPECT_NE(map->parts_list, nullptr);
}

TEST_F(NativeRecords, OversizedCameraTablesCannotNarrowTheirHostByteCounts) {
    char      *script = Publish("map/checked-cameras.map.json", "scene_map", {
                                                                                 {"info",       {{"texture_packs", Json::array()}, {"model_packs", Json::array()}, {"light_sets", Json::array()}}},
                                                                                 {"parts",      Json::array()                                                                                    },
                                                                                 {"placements", Json::array()                                                                                    },
                                                                                 {"cameras",    {{"count", std::numeric_limits<int>::max()}, {"cameras", Json::array()}}                         }
    });
    auto       map = std::make_unique<CMap>();
    const auto used = memory.stGetUsed();
    map->LoadMapFile(script, 1, &memory, 0);
    EXPECT_EQ(map->camera_info, nullptr);
    EXPECT_EQ(map->camera_info_num, 0);
    EXPECT_EQ(memory.stGetUsed(), used);
}

TEST_F(NativeRecords, WaterTableFailuresDoNotPublishCountsWithoutStorage) {
    for (const auto field : {"surface_count", "draw_count"}) {
        char      *script = Publish(std::string("map/") + field + ".cfg.json", "scene_config", {
                                                                                                   {"draw_off_rects",   Json::array()                                                                                    },
                                                                                                   {"occlusion_planes", Json::array()                                                                                    },
                                                                                                   {"event_points",     Json::array()                                                                                    },
                                                                                                   {"water",            {{field, std::numeric_limits<int>::max()}, {"surfaces", Json::array()}, {"draws", Json::array()}}}
        });
        auto       map = std::make_unique<CMap>();
        const auto used = memory.stGetUsed();
        map->LoadCfgFile(script, 1, &memory);
        EXPECT_EQ(map->water_surface, nullptr);
        EXPECT_EQ(map->water_surface_num, 0);
        EXPECT_EQ(map->water, nullptr);
        EXPECT_EQ(map->water_num, 0);
        EXPECT_EQ(memory.stGetUsed(), used);
    }
}

TEST_F(NativeRecords, FrameGraphsPreserveDepthFirstFlaggedNameSearchAndRejectChangedEdges) {
    auto *root = NewGraphFrame(memory, "root");
    auto *first = NewGraphFrame(memory, "branch");
    auto *nested = NewGraphFrame(memory, "joint--nested");
    auto *second = NewGraphFrame(memory, "joint--second");
    ASSERT_NE(root, nullptr);
    ASSERT_NE(first, nullptr);
    ASSERT_NE(nested, nullptr);
    ASSERT_NE(second, nullptr);
    first->SetParent(root);
    second->SetParent(root);
    nested->SetParent(first);
    const auto graph = dc2::world::FrameGraph::Capture(memory, root);
    ASSERT_TRUE(graph.IsLive());
    EXPECT_EQ(graph.GetRoot(), root);
    EXPECT_EQ(graph.FindFrame("joint--query"), nested);
    char query[] = "joint--query";
    EXPECT_EQ(graph.FindFrame(query), root->SearchFrame(query));
    EXPECT_EQ(graph.FindFrame("missing"), nullptr);
    EXPECT_FALSE(graph.SameIdentity(dc2::world::FrameGraph::Capture(memory, root)));
    EXPECT_TRUE(graph.SameIdentity(graph));
    mgCFrame outside;
    root->child = &outside;
    EXPECT_EQ(graph.GetRoot(), nullptr);
    EXPECT_EQ(graph.FindFrame("joint"), nullptr);
    EXPECT_FALSE(dc2::world::FrameGraph::Capture(memory, root).IsLive());
    root->child = first;
    ASSERT_TRUE(graph.IsLive());
    first->elder = second;
    EXPECT_FALSE(graph.IsLive());
}

TEST_F(NativeRecords, FrameGraphsRejectParentChildAndSiblingCyclesBeforePublishing) {
    auto *root = NewGraphFrame(memory, "root");
    auto *child = NewGraphFrame(memory, "child");
    ASSERT_NE(root, nullptr);
    ASSERT_NE(child, nullptr);
    root->parent = root;
    EXPECT_FALSE(dc2::world::FrameGraph::Capture(memory, root).IsLive());
    root->parent = nullptr;
    root->child = child;
    child->child = root;
    EXPECT_FALSE(dc2::world::FrameGraph::Capture(memory, root).IsLive());
    child->child = nullptr;
    child->brother = child;
    EXPECT_FALSE(dc2::world::FrameGraph::Capture(memory, root).IsLive());
    child->brother = nullptr;
    child->elder = child;
    EXPECT_FALSE(dc2::world::FrameGraph::Capture(memory, root).IsLive());
    child->elder = nullptr;
    child->parent = root;
    EXPECT_TRUE(dc2::world::FrameGraph::Capture(memory, root).IsLive());
}

TEST_F(NativeRecords, FrameGraphsRejectUnterminatedNamesAndCurrentNameOrTableReplacement) {
    auto *root = NewGraphFrame(memory, "root");
    auto *other = NewGraphFrame(memory, "other");
    ASSERT_NE(root, nullptr);
    ASSERT_NE(other, nullptr);
    auto *table = dc2::memory::NewArray<mgCFrame *>(memory, 1);
    ASSERT_NE(table, nullptr);
    table[0] = root;
    root->frame_list = table;
    root->frame_num = 1;
    const auto graph = dc2::world::FrameGraph::Capture(memory, root);
    ASSERT_TRUE(graph.IsLive());
    table[0] = other;
    EXPECT_FALSE(graph.IsLive());
    table[0] = root;
    root->name[0] = 'R';
    EXPECT_FALSE(graph.IsLive());
    root->name[0] = 'r';
    EXPECT_TRUE(graph.IsLive());
    const auto bytes = dc2::memory::AllocationBytes(memory, root->name);
    std::ranges::fill(bytes, static_cast<u8>('x'));
    EXPECT_FALSE(dc2::world::FrameGraph::Capture(memory, root).IsLive());
}

TEST_F(NativeRecords, FrameGraphCopiesImportSourceAliasesAndCannotReviveAfterProducerReuse) {
    auto *root = NewGraphFrame(memory, "root");
    auto *child = NewGraphFrame(memory, "child");
    ASSERT_NE(root, nullptr);
    ASSERT_NE(child, nullptr);
    child->SetParent(root);
    const auto source_graph = dc2::world::FrameGraph::Capture(memory, root);
    ASSERT_TRUE(source_graph.IsLive());
    std::vector<u_long128> copy_storage(4096);
    mgCMemory              copies;
    copies.stSetBuffer(copy_storage.data(), static_cast<int>(copy_storage.size()));
    auto *copied = mgCopyFrame(root, &copies, 0);
    ASSERT_NE(copied, nullptr);
    auto *copied_child = copied->child;
    ASSERT_NE(copied_child, nullptr);
    ASSERT_NE(copied_child, child);
    EXPECT_EQ(copied_child->parent, copied);
    EXPECT_NE(copied_child->name, child->name);
    EXPECT_STREQ(copied_child->name, "child");
    const auto independent = dc2::world::FrameGraph::Capture(copies, copied);
    ASSERT_TRUE(independent.IsLive());
    EXPECT_EQ(independent.FindFrame("child"), copied_child);
    EXPECT_FALSE(independent.WouldRetireOnReset(memory, dc2::memory::ArenaResetKind::Stack));
    copied->SetReference(root);
    EXPECT_FALSE(independent.IsLive());
    EXPECT_FALSE(dc2::world::FrameGraph::Capture(copies, copied).IsLive());
    const auto graph = dc2::world::FrameGraph::Capture(copies, copied, &source_graph);
    ASSERT_TRUE(graph.IsLive());
    EXPECT_EQ(graph.FindFrame("child"), copied_child);
    EXPECT_TRUE(graph.WouldRetireOnReset(memory, dc2::memory::ArenaResetKind::Stack));
    EXPECT_TRUE(graph.WouldRetireOnReset(copies, dc2::memory::ArenaResetKind::Rebind));
    memory.stReset();
    auto *reused = NewGraphFrame(memory, "root");
    ASSERT_EQ(reused, root);
    EXPECT_EQ(graph.GetRoot(), nullptr);
    EXPECT_EQ(graph.FindFrame("child"), nullptr);
    EXPECT_FALSE(source_graph.IsLive());
    copied->DeleteReference();
    ASSERT_TRUE(independent.IsLive());
    EXPECT_EQ(independent.FindFrame("child"), copied_child);
    const auto replacement = dc2::world::FrameGraph::Capture(memory, reused);
    ASSERT_TRUE(replacement.IsLive());
    EXPECT_FALSE(source_graph.SameIdentity(replacement));
    copies.stReset();
    EXPECT_FALSE(independent.IsLive());
}

TEST_F(NativeRecords, FrameGraphsValidateChildAndNameLeasesOutsideTheirCompletedRootBlock) {
    const auto frame_words = static_cast<int>(dc2::memory::ArrayQuadwords<mgCFrame>(1).value());
    for (const bool retire_name : {false, true}) {
        std::vector<u_long128> heap_storage(static_cast<std::size_t>(frame_words * 3 + 128));
        mgCMemory              heap;
        heap.SetHeapMem(heap_storage.data(), static_cast<int>(heap_storage.size()));
        ASSERT_NE(heap.StartStackMode(MG_STACK_MODE_FIT, frame_words + 16), nullptr);
        auto *root = NewGraphFrame(heap, "root");
        ASSERT_NE(root, nullptr);
        const auto root_lease = dc2::memory::ArenaBuffer::Bind(heap, dc2::memory::AllocationBytes(heap, root).first(sizeof(mgCFrame)));
        heap.EndStackMode();
        ASSERT_NE(heap.StartStackMode(MG_STACK_MODE_FIT, frame_words + 16), nullptr);
        if (retire_name) {
            auto *name = dc2::memory::NewArray<char>(heap, 6);
            ASSERT_NE(name, nullptr);
            std::memcpy(name, "fresh", 6);
            root->name = name;
        } else {
            auto *child = NewGraphFrame(heap, "child");
            ASSERT_NE(child, nullptr);
            child->SetParent(root);
        }
        const auto graph = dc2::world::FrameGraph::Capture(heap, root);
        ASSERT_TRUE(graph.IsLive());
        heap.stReset();
        EXPECT_EQ(root_lease.Bytes().size(), sizeof(mgCFrame));
        EXPECT_FALSE(graph.IsLive());
        EXPECT_EQ(graph.FindFrame("fresh"), nullptr);
    }
}

TEST_F(NativeRecords, MapPieceCopiesPropagateGraphsAndValidateCharacterCopies) {
    auto *root = NewGraphFrame(memory, "root");
    auto *child = NewGraphFrame(memory, "child");
    auto *character = dc2::memory::NewObject<CCharacter2>(memory);
    ASSERT_NE(root, nullptr);
    ASSERT_NE(child, nullptr);
    ASSERT_NE(character, nullptr);
    child->SetParent(root);
    character->CObjectFrame::frame = root;
    ASSERT_TRUE(dc2::character::CaptureModelResources(*character, memory));
    CMdsInfo info;
    info.frame = root;
    info.chara = character;
    info.frame_graph = dc2::world::FrameGraph::Capture(memory, root, nullptr, character);
    ASSERT_TRUE(info.frame_graph.IsLive());
    CMapPiece source;
    ASSERT_TRUE(source.AssignMds(&info));
    CMapPiece borrowed;
    ASSERT_TRUE(source.Copy(borrowed, nullptr));
    EXPECT_TRUE(borrowed.frame_graph.SameIdentity(source.frame_graph));
    std::vector<u_long128> copy_storage(16384);
    mgCMemory              copies;
    copies.stSetBuffer(copy_storage.data(), static_cast<int>(copy_storage.size()));
    CMapPiece copied;
    ASSERT_TRUE(source.Copy(copied, &copies));
    ASSERT_NE(copied.chara, nullptr);
    ASSERT_TRUE(copied.frame_graph.Matches(copied.frame, copied.chara));
    EXPECT_FALSE(copied.frame_graph.SameIdentity(source.frame_graph));
    auto *copied_child = copied.frame_graph.FindFrame("child");
    ASSERT_NE(copied_child, nullptr);
    EXPECT_NE(copied_child, child);
    EXPECT_EQ(copied_child->parent, copied.frame);
    EXPECT_NE(copied_child->name, child->name);
    EXPECT_STREQ(copied_child->name, "child");
    root->child = nullptr;
    CMapPiece rejected;
    EXPECT_FALSE(source.Copy(rejected, &copies));
    EXPECT_EQ(rejected.frame, nullptr);
    EXPECT_FALSE(rejected.frame_graph.IsLive());
    EXPECT_TRUE(copied.frame_graph.IsLive());
    EXPECT_EQ(copied.frame_graph.FindFrame("child"), copied_child);
    memory.stReset();
    EXPECT_FALSE(copied.frame_graph.IsLive());
    copied.Initialize();
    EXPECT_FALSE(copied.frame_graph.IsLive());
    info.Initialize();
    EXPECT_FALSE(info.frame_graph.IsLive());
}

TEST_F(NativeRecords, GeoramaPieceAllocationFailuresPreserveRiverWaterAndMaskBindings) {
    char      *script = Publish("map/checked-georama.cfg.json", "scene_config", {
                                                                                    {"draw_off_rects",   Json::array()                                                                                                                                                                                                                  },
                                                                                    {"occlusion_planes", Json::array()                                                                                                                                                                                                                  },
                                                                                    {"event_points",     Json::array()                                                                                                                                                                                                                  },
                                                                                    {"water",            {{"surfaces", Json::array()}, {"draws", Json::array()}}                                                                                                                                                                        },
                                                                                    {"georama",          {{"river_parts", Json::array({{{"index", 0}, {"parts", "unresolved"}, {"model", "unresolved"}}})}, {"water_parts_models", Json::array({"unresolved"})}, {"mask_parts", Json::array({{{"index", 0}, {"model", "unresolved"}}})}}}
    });
    const auto config = ReadSceneConfig(script);
    ASSERT_TRUE(config.has_value());
    ASSERT_TRUE(config->georama.has_value());
    ASSERT_EQ(config->georama->river_parts.size(), 1U);
    ASSERT_EQ(config->georama->water_models.size(), 1U);
    ASSERT_EQ(config->georama->mask_parts.size(), 1U);
    auto      map = std::make_unique<CEditMap>();
    CMapParts old_part;
    CMapPiece old_river;
    CMapPiece old_water;
    CMapPiece old_mask;
    map->river_parts[0] = &old_part;
    map->river_piece[0] = &old_river;
    map->water_piece = &old_water;
    map->mask_piece[0] = &old_mask;
    PortApplyEditMapConfig(map.get(), script, 0, nullptr);
    memory.stSetLocked(true);
    PortApplyEditMapConfig(map.get(), script, 0, &memory);
    EXPECT_EQ(map->river_parts[0], &old_part);
    EXPECT_EQ(map->river_piece[0], &old_river);
    EXPECT_EQ(map->water_piece, &old_water);
    EXPECT_EQ(map->mask_piece[0], &old_mask);
    memory.stSetLocked(false);
    PortApplyEditMapConfig(map.get(), script, 0, &memory);
    for (auto *piece : {map->river_piece[0], map->water_piece, map->mask_piece[0]}) {
        ASSERT_NE(piece, nullptr);
        EXPECT_GE(dc2::memory::AllocationBytes(memory, piece).size(), sizeof(CMapPiece));
        EXPECT_EQ(piece->frame, nullptr);
        EXPECT_EQ(piece->draw_enable, 1);
    }
    EXPECT_NE(map->river_piece[0], &old_river);
    EXPECT_NE(map->water_piece, &old_water);
    EXPECT_NE(map->mask_piece[0], &old_mask);
}

TEST_F(NativeRecords, TreasureTablesUseHostSizesAndCommitOnlyAfterEveryChestCopySucceeds) {
    auto map = std::make_unique<CMap>();
    ASSERT_TRUE(map->SetPlacePartsBuff(&memory, 1));
    auto &part = map->PlacedParts()[0];
    std::memcpy(part.name, "chests", 7);
    map->place_parts_num = 1;
    auto *map_point = map->func_point.Add(FUNC_POINT_EVENT, &memory);
    auto *part_point = part.func_point_mngr.Add(FUNC_POINT_EVENT, &memory);
    ASSERT_NE(map_point, nullptr);
    ASSERT_NE(part_point, nullptr);
    map_point->event.flag = part_point->event.flag = FUNC_EVENT_TREASURE_BOX;
    map_point->event.point_no = 17;
    part_point->event.point_no = 18;
    map_point->event.arg1 = 21;
    part_point->event.arg1 = 22;
    map_point->event.arg2 = 2;
    part_point->event.arg2 = 3;
    CMapTreasureBox model;
    model.CObjectFrame::frame = NewGraphFrame(memory, "root");
    ASSERT_NE(model.CObjectFrame::frame, nullptr);
    ASSERT_TRUE(dc2::character::CaptureModelResources(model, memory));
    CMapTreasureBox previous;
    map->tr_box = &previous;
    map->tr_box_num = 1;
    map->tr_box_model = &previous;
    map->tr_box_texture = 7;
    const auto             array_words = dc2::memory::ArrayQuadwords<CMapTreasureBox>(2).value();
    const auto             frame_words = dc2::memory::ArrayQuadwords<mgCFrame>(1).value();
    const auto             wanted = array_words + frame_words + 3;
    std::vector<u_long128> insufficient(static_cast<std::size_t>(wanted));
    mgCMemory              destination;
    destination.stSetBuffer(insufficient.data(), static_cast<int>(insufficient.size()));
    const auto available = dc2::memory::RemainingBytes(destination).size() / sizeof(u_long128);
    ASSERT_GE(available, static_cast<std::size_t>(wanted));
    if (available > static_cast<std::size_t>(wanted)) {
        ASSERT_NE(destination.Alloc(static_cast<int>(available - static_cast<std::size_t>(wanted))), nullptr);
    }
    destination.stSetLocked(true);
    map->CreateTrBox(&model, 8, &destination);
    EXPECT_EQ(map->tr_box, &previous);
    destination.stSetLocked(false);
    const auto used = destination.stGetUsed();
    map->CreateTrBox(&model, 8, &destination);
    EXPECT_GT(destination.stGetUsed(), used + array_words);
    EXPECT_EQ(map->tr_box, &previous);
    EXPECT_EQ(map->tr_box_num, 1);
    EXPECT_EQ(map->tr_box_model, &previous);
    EXPECT_EQ(map->tr_box_texture, 7);
    EXPECT_EQ(map_point->event.point_no, 17);
    EXPECT_EQ(part_point->event.point_no, 18);
    std::vector<u_long128> sufficient(16384);
    destination.stSetBuffer(sufficient.data(), static_cast<int>(sufficient.size()));
    map->CreateTrBox(&model, 8, &destination);
    ASSERT_NE(map->tr_box, &previous);
    ASSERT_NE(map->tr_box, nullptr);
    ASSERT_EQ(map->tr_box_num, 2);
    EXPECT_GE(dc2::memory::AllocationBytes(destination, map->tr_box).size(), 2 * sizeof(CMapTreasureBox));
    EXPECT_EQ(map->tr_box_model, &model);
    EXPECT_EQ(map->tr_box_texture, 8);
    EXPECT_EQ(map->tr_box[0].func_point, map_point);
    EXPECT_EQ(map->tr_box[1].func_point, part_point);
    EXPECT_EQ(map->tr_box[0].parts, nullptr);
    EXPECT_EQ(map->tr_box[1].parts, &part);
    EXPECT_EQ(map->tr_box[0].item_no, 21);
    EXPECT_EQ(map->tr_box[1].item_no, 22);
    EXPECT_EQ(map->tr_box[1].item_num, 3);
    EXPECT_EQ(map_point->event.point_no, 0);
    EXPECT_EQ(part_point->event.point_no, 1);
    EXPECT_EQ(map->GetTrBox(2), nullptr);
    map->func_point.Initialize();
    part.func_point_mngr.Initialize();
    map->CreateTrBox(&model, 9, &destination);
    EXPECT_EQ(map->tr_box, nullptr);
    EXPECT_EQ(map->tr_box_num, 0);
}

TEST_F(NativeRecords, CharacterCopyFailuresClearEveryPartialResultAndPreserveSourceBookkeeping) {
    /**
     * Selects a required clone allocation whose failure must cancel the complete character copy.
     */
    enum class Component {
        Root,
        Outline,
        OutlineTail,
        ClothArray,
        ClothVertices,
        LodArray,
        LodFrame,
        Sound,
        SwordObject,
        SwordBuffers
    };
    for (const auto component : {Component::Root, Component::Outline, Component::OutlineTail, Component::ClothArray, Component::ClothVertices,
                                 Component::LodArray, Component::LodFrame, Component::Sound, Component::SwordObject, Component::SwordBuffers}) {
        SCOPED_TRACE(static_cast<int>(component));
        CCharacter2 source;
        source.CObjectFrame::frame = NewGraphFrame(memory, "root");
        ASSERT_NE(source.CObjectFrame::frame, nullptr);
        std::size_t budget = static_cast<std::size_t>(dc2::memory::ArrayQuadwords<mgCFrame>(1).value()) + 2;
        switch (component) {
            case Component::Root:
                budget = 1;
                break;
            case Component::Outline:
            case Component::OutlineTail:
                source.outline = dc2::memory::NewObject<COutLineDraw>(memory);
                ASSERT_NE(source.outline, nullptr);
                source.outline->frame = source.CObjectFrame::frame;
                source.outline_tex_no = 1;
                if (component == Component::OutlineTail) {
                    source.outline->next = dc2::memory::NewObject<COutLineDraw>(memory);
                    ASSERT_NE(source.outline->next, nullptr);
                    source.outline->next->frame = source.CObjectFrame::frame;
                    budget += static_cast<std::size_t>(dc2::memory::ArrayQuadwords<COutLineDraw>(1).value());
                }
                break;
            case Component::ClothArray:
            case Component::ClothVertices:
                source.dynamic_anime = dc2::memory::NewObject<CDynamicAnime>(memory);
                ASSERT_NE(source.dynamic_anime, nullptr);
                source.dynamic_anime_num = 1;
                source.dynamic_anime->NewVertexTable(2, &memory);
                ASSERT_EQ(source.dynamic_anime->vertex_num, 2);
                if (component == Component::ClothVertices) {
                    budget += static_cast<std::size_t>(dc2::memory::ArrayQuadwords<CDynamicAnime>(1).value());
                }
                break;
            case Component::LodArray:
            case Component::LodFrame:
                source.lod = dc2::memory::NewObject<CCharaLOD>(memory);
                ASSERT_NE(source.lod, nullptr);
                source.lod_num = 1;
                source.lod->frame = NewGraphFrame(memory, "lod");
                ASSERT_NE(source.lod->frame, nullptr);
                if (component == Component::LodFrame) {
                    budget += static_cast<std::size_t>(dc2::memory::ArrayQuadwords<CCharaLOD>(1).value());
                }
                break;
            case Component::Sound:
                ASSERT_TRUE(dc2::character::CaptureModelResources(source, memory));
                source.se_list[0] = dc2::memory::NewObject<CHRINFO_SE>(memory);
                ASSERT_NE(source.se_list[0], nullptr);
                source.se_num[0] = 1;
                {
                    const auto                      resources = source.resource_state.Acquire<dc2::character::ResourceState>();
                    dc2::character::CloneAuxBuilder builder(resources->clone_inputs);
                    ASSERT_TRUE(builder.RegisterSounds(memory, 0, {source.se_list[0], 1}));
                    ASSERT_TRUE(dc2::character::PublishCloneInputs(source, std::move(builder)));
                }
                break;
            case Component::SwordObject:
            case Component::SwordBuffers:
                source.sword_effect[0] = dc2::memory::NewObject<CSWordAfterEffect>(memory);
                ASSERT_NE(source.sword_effect[0], nullptr);
                source.sword_effect[0]->Initialize(&memory, 4, 2);
                ASSERT_NE(source.sword_effect[0]->point0, nullptr);
                if (component == Component::SwordBuffers) {
                    budget += static_cast<std::size_t>(dc2::memory::ArrayQuadwords<CSWordAfterEffect>(1).value());
                }
                break;
        }
        ASSERT_TRUE(dc2::character::CaptureModelResources(source, memory));
        source.lod_no = 5;
        source.copy_size = 71;
        std::vector<u_long128> storage(budget);
        mgCMemory              destination_memory;
        destination_memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
        const auto available = dc2::memory::RemainingBytes(destination_memory).size() / sizeof(u_long128);
        ASSERT_GE(available, budget);
        if (available > budget) {
            ASSERT_NE(destination_memory.Alloc(static_cast<int>(available - budget)), nullptr);
        }
        CCharacter2 destination;
        EXPECT_FALSE(source.Copy(destination, &destination_memory));
        EXPECT_EQ(destination.CObjectFrame::frame, nullptr);
        EXPECT_EQ(destination.dynamic_anime, nullptr);
        EXPECT_EQ(destination.dynamic_anime_num, 0);
        EXPECT_EQ(destination.lod, nullptr);
        EXPECT_EQ(destination.lod_num, 0);
        EXPECT_EQ(destination.outline, nullptr);
        EXPECT_EQ(destination.sword_effect[0], nullptr);
        EXPECT_EQ(source.lod_no, 5);
        EXPECT_EQ(source.copy_size, 71);
    }
}

TEST_F(NativeRecords, CharacterCopiesValidateShallowAndSelfCopiesAndRequireADeepModel) {
    CCharacter2 source;
    CCharacter2 destination;
    EXPECT_TRUE(source.Copy(destination, nullptr));
    EXPECT_TRUE(source.Copy(source, &memory));
    EXPECT_FALSE(source.Copy(destination, &memory));
    source.CObjectFrame::frame = NewGraphFrame(memory, "root");
    ASSERT_NE(source.CObjectFrame::frame, nullptr);
    ASSERT_TRUE(dc2::character::CaptureModelResources(source, memory));
    source.copy_size = 23;
    source.lod_no = 4;
    memory.stSetLocked(true);
    EXPECT_TRUE(source.Copy(source, &memory));
    EXPECT_TRUE(source.Copy(destination, nullptr));
    EXPECT_EQ(destination.CObjectFrame::frame, source.CObjectFrame::frame);
    EXPECT_FALSE(source.Copy(destination, &memory));
    EXPECT_EQ(destination.CObjectFrame::frame, nullptr);
    EXPECT_EQ(source.copy_size, 23);
    EXPECT_EQ(source.lod_no, 4);
    memory.stSetLocked(false);
    EXPECT_TRUE(source.Copy(destination, &memory));
    EXPECT_NE(destination.CObjectFrame::frame, source.CObjectFrame::frame);
    EXPECT_EQ(source.lod_no, -1);
    EXPECT_GT(source.copy_size, 0);
    source.dynamic_anime_num = -1;
    EXPECT_FALSE(source.Copy(destination, nullptr));
    EXPECT_EQ(destination.CObjectFrame::frame, nullptr);
}

TEST_F(NativeRecords, InvalidActionSelfCopyClearsActionHoldAndScriptState) {
    CActionChara character;
    character.Initialize(nullptr);
    character.CObjectFrame::frame = NewGraphFrame(memory, "root");
    ASSERT_NE(character.CObjectFrame::frame, nullptr);
    ASSERT_TRUE(dc2::character::CaptureModelResources(character, memory));
    char script[] = "action";
    character.script_buf = script;
    character.prog = 17;
    character.hold_type = ACTION_HOLD_ITEM;
    character.hold_frame = character.CObjectFrame::frame;
    character.object[0].frame = character.CObjectFrame::frame;
    character.damage_num = 1;
    character.damage[0].use = true;
    memory.stReset();
    ASSERT_FALSE(dc2::character::ResourcesLive(character));
    EXPECT_FALSE(character.Copy(character, nullptr));
    EXPECT_EQ(character.CObjectFrame::frame, nullptr);
    EXPECT_FALSE(character.resource_state.HasValue());
    EXPECT_EQ(character.script_buf, nullptr);
    EXPECT_EQ(character.prog, 0);
    EXPECT_EQ(character.hold_type, ACTION_HOLD_NONE);
    EXPECT_EQ(character.hold_frame, nullptr);
    EXPECT_EQ(character.object[0].frame, nullptr);
    EXPECT_EQ(character.damage_num, 0);
    EXPECT_FALSE(character.damage[0].use);
}

TEST_F(NativeRecords, DerivedMonsterCopyFailureLeavesTheDestinationInactive) {
    auto source = std::make_unique<CActiveMonster>();
    auto destination = std::make_unique<CActiveMonster>();
    source->CObjectFrame::frame = NewGraphFrame(memory, "root");
    ASSERT_NE(source->CObjectFrame::frame, nullptr);
    ASSERT_TRUE(dc2::character::CaptureModelResources(*source, memory));
    source->state = ACTIVE_MONSTER_LIVE;
    std::array<u_long128, 16> storage{};
    mgCMemory                 destination_memory;
    destination_memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    ASSERT_NE(destination_memory.Alloc(1), nullptr);
    destination_memory.stSetLocked(true);
    EXPECT_FALSE(source->Copy(*destination, &destination_memory));
    EXPECT_EQ(destination->state, ACTIVE_MONSTER_NONE);
    EXPECT_EQ(destination->CObjectFrame::frame, nullptr);
    EXPECT_TRUE(source->Copy(*destination, nullptr));
    EXPECT_EQ(destination->state, ACTIVE_MONSTER_LIVE);
    EXPECT_EQ(destination->CObjectFrame::frame, source->CObjectFrame::frame);
}

TEST_F(NativeRecords, ClothAndSwordCopyHelpersRejectPartialAllocationsAndPreserveEmptyFrameSlots) {
    auto *root = NewGraphFrame(memory, "root");
    ASSERT_NE(root, nullptr);
    CDynamicAnime cloth;
    cloth.NewFrameTable(2, &memory);
    cloth.NewVertexTable(2, &memory);
    ASSERT_EQ(cloth.frame_num, 2);
    ASSERT_EQ(cloth.vertex_num, 2);
    cloth.top_frame = root;
    cloth.frame[0] = root;
    cloth.frame[1] = nullptr;
    std::array<u_long128, 6> small_storage{};
    mgCMemory                small;
    small.stSetBuffer(small_storage.data(), static_cast<int>(small_storage.size()));
    const auto available = dc2::memory::RemainingBytes(small).size() / sizeof(u_long128);
    if (available > small_storage.size()) {
        ASSERT_NE(small.Alloc(static_cast<int>(available - small_storage.size())), nullptr);
    }
    CDynamicAnime copied;
    EXPECT_FALSE(cloth.Copy(copied, root, &small));
    EXPECT_EQ(copied.frame, nullptr);
    EXPECT_EQ(copied.vertex_num, 0);
    EXPECT_EQ(copied.init_vertex, nullptr);
    EXPECT_TRUE(cloth.Copy(copied, root, &memory));
    EXPECT_EQ(copied.frame[0], root);
    EXPECT_EQ(copied.frame[1], nullptr);
    EXPECT_NE(copied.init_vertex, cloth.init_vertex);
    CSWordAfterEffect trail;
    trail.Initialize(&memory, 4, 2);
    ASSERT_NE(trail.point0, nullptr);
    trail.active = 1;
    CSWordAfterEffect copied_trail;
    small.stSetLocked(true);
    EXPECT_FALSE(trail.Copy(copied_trail, &small));
    EXPECT_EQ(copied_trail.active, 0);
    EXPECT_EQ(copied_trail.point0, nullptr);
    EXPECT_TRUE(trail.Copy(copied_trail, nullptr));
    EXPECT_EQ(copied_trail.point0, trail.point0);
    trail.point_num = trail.point_max + 1;
    EXPECT_FALSE(trail.Copy(copied_trail, nullptr));
    EXPECT_EQ(copied_trail.active, 0);
}

TEST_F(NativeRecords, PieceCopyMaterialAndCharacterFailuresCannotPublishPartialPieces) {
    CMapPiece     source;
    CMapPiece     destination;
    PieceMaterial material{};
    source.material_num = 1;
    source.material = &material;
    memory.stSetLocked(true);
    EXPECT_FALSE(source.Copy(destination, &memory));
    EXPECT_EQ(destination.material_num, 0);
    EXPECT_EQ(destination.material, nullptr);
    EXPECT_EQ(destination.frame, nullptr);
    memory.stSetLocked(false);
    EXPECT_TRUE(source.Copy(destination, &memory));
    EXPECT_EQ(destination.material_num, 1);
    EXPECT_NE(destination.material, source.material);
    source.material_num = -1;
    EXPECT_FALSE(source.Copy(destination, nullptr));
    EXPECT_EQ(destination.material_num, 0);
    EXPECT_EQ(destination.material, nullptr);
}

TEST_F(NativeRecords, CharacterCopyRejectsUnregisteredDerivedVisualBeforeDispatch) {
    /**
     * Detects unexpected dispatch through an unregistered derived visual.
     */
    class ThrowingVisual final : public mgCVisual {
    public:
        int copy_calls = 0; /**< Number of actual visual clone requests made by the frame copier. */

        /**
         * Simulates failure of native visual metadata allocation during a model clone.
         */
        mgCVisual *Copy(mgCMemory *) override {
            ++copy_calls;
            throw std::bad_alloc{};
        }
    } visual;

    CCharacter2 source;
    source.CObjectFrame::frame = NewGraphFrame(memory, "root");
    ASSERT_NE(source.CObjectFrame::frame, nullptr);
    source.CObjectFrame::frame->SetVisual(&visual);
    ASSERT_TRUE(dc2::character::CaptureModelResources(source, memory));
    source.lod_no = 5;
    source.copy_size = 77;
    CCharacter2 destination;
    ASSERT_TRUE(source.Copy(destination, nullptr));
    std::vector<u_long128> storage(4096);
    mgCMemory              destination_memory;
    destination_memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    EXPECT_FALSE(source.Copy(destination, &destination_memory));
    EXPECT_EQ(visual.copy_calls, 0);
    EXPECT_EQ(destination.CObjectFrame::frame, nullptr);
    EXPECT_FALSE(destination.resource_state.HasValue());
    EXPECT_EQ(destination.dynamic_anime_num, 0);
    EXPECT_EQ(destination.lod_num, 0);
    EXPECT_EQ(source.lod_no, 5);
    EXPECT_EQ(source.copy_size, 77);
    EXPECT_TRUE(dc2::character::ResourcesLive(source));
    EXPECT_EQ(source.CObjectFrame::frame->visual, &visual);
}

namespace {
/**
 * Creates an auxiliary test allocation in an independently retireable producer block.
 */
template <class T>
T *CloneAuxObject(mgCMemory &producer) {
    if (producer.StartStackMode(MG_STACK_MODE_FIT, 256) == nullptr) {
        return nullptr;
    }
    auto *object = dc2::memory::NewObject<T>(producer);
    producer.EndStackMode();
    return object;
}

/**
 * Creates a graph frame whose name occupies an independently retireable allocation.
 */
mgCFrame *CloneAuxFrame(mgCMemory &producer, std::string_view name) {
    auto *frame = CloneAuxObject<mgCFrame>(producer);
    if (frame == nullptr || producer.StartStackMode(MG_STACK_MODE_FIT, 32) == nullptr) {
        return nullptr;
    }
    auto *text = dc2::memory::NewArray<char>(producer, name.size() + 1);
    if (text != nullptr) {
        std::memcpy(text, name.data(), name.size());
        text[name.size()] = 0;
        frame->SetName(text);
    }
    producer.EndStackMode();
    return text != nullptr ? frame : nullptr;
}

/**
 * Publishes an explicitly produced sound allocation on an already captured test character.
 */
bool CloneAuxSound(CCharacter2 &character, mgCMemory &producer, int slot, std::size_t capacity) {
    const auto resources = character.resource_state.Acquire<dc2::character::ResourceState>();
    if (!resources) {
        return false;
    }
    dc2::character::CloneAuxBuilder builder(resources->clone_inputs);
    return builder.RegisterSounds(producer, slot, {character.se_list[slot], capacity}) && dc2::character::PublishCloneInputs(character, std::move(builder));
}
} // namespace

TEST_F(NativeRecords, EntryCloneBindingsRejectRetiredFramesAndNamesBeforeRemapping) {
    for (const bool retire_name : {false, true}) {
        std::array<u_long128, 4096> storage{}, copies{};
        mgCMemory                   producer, destination_memory;
        producer.SetHeapMem(storage.data(), static_cast<int>(storage.size()));
        destination_memory.stSetBuffer(copies.data(), static_cast<int>(copies.size()));
        CCharacter2 source;
        source.CObjectFrame::frame = CloneAuxFrame(producer, "root");
        auto *child = CloneAuxFrame(producer, "child");
        ASSERT_NE(source.CObjectFrame::frame, nullptr);
        ASSERT_NE(child, nullptr);
        child->SetParent(source.CObjectFrame::frame);
        source.entry_frame[0] = child;
        source.entry_object[3].frame = child;
        source.deform_frame[0] = child;
        source.deform_frame_num = 2;
        ASSERT_TRUE(dc2::character::CaptureModelResources(source, producer));
        const auto  resources = source.resource_state.Acquire<dc2::character::ResourceState>();
        CCharacter2 destination;
        ASSERT_TRUE(source.Copy(destination, &destination_memory));
        ASSERT_NE(destination.entry_frame[0], nullptr);
        EXPECT_NE(destination.entry_frame[0], child);
        EXPECT_EQ(destination.entry_object[3].frame, destination.entry_frame[0]);
        EXPECT_EQ(destination.deform_frame[0], destination.entry_frame[0]);
        EXPECT_EQ(destination.deform_frame[1], nullptr);
        EXPECT_TRUE(dc2::character::CloneInputsLive(destination));
        auto *name = child->name;
        producer.Free(reinterpret_cast<u_long128 *>(retire_name ? static_cast<void *>(name) : static_cast<void *>(child)));
        EXPECT_TRUE(dc2::character::ResourcesLive(source));
        EXPECT_FALSE(dc2::character::CloneInputsLive(source));
        EXPECT_TRUE(dc2::character::CloneInputsLive(destination));
        EXPECT_EQ(source.resource_state.Acquire<dc2::character::ResourceState>(), resources);
        CCharacter2 failed;
        EXPECT_FALSE(source.Copy(failed, &destination_memory));
        EXPECT_EQ(failed.CObjectFrame::frame, nullptr);
        EXPECT_FALSE(failed.resource_state.HasValue());
    }
}

TEST_F(NativeRecords, FrameBindingExtractionRejectsUnknownPointersAndIdentityChanges) {
    auto *root = NewGraphFrame(memory, "root");
    auto *child = NewGraphFrame(memory, "child");
    ASSERT_NE(root, nullptr);
    ASSERT_NE(child, nullptr);
    child->SetParent(root);
    const auto graph = dc2::world::FrameGraph::Capture(memory, root);
    ASSERT_TRUE(graph.IsLive());
    mgCFrame unregistered;
    EXPECT_FALSE(graph.BindName(&unregistered));
    auto binding = graph.BindName(child);
    ASSERT_TRUE(binding);
    EXPECT_EQ(binding->Name(), std::optional<std::string_view>("child"));
    CCharacter2 source;
    source.CObjectFrame::frame = root;
    source.entry_frame[0] = child;
    ASSERT_TRUE(dc2::character::CaptureModelResources(source, memory));
    source.entry_frame[0] = &unregistered;
    EXPECT_FALSE(dc2::character::CloneInputsLive(source));
    source.entry_frame[0] = child;
    source.deform_frame_num = -1;
    EXPECT_FALSE(dc2::character::CloneInputsLive(source));
    source.deform_frame_num = CHARA_DEFORM_FRAME_MAX + 1;
    EXPECT_FALSE(dc2::character::CloneInputsLive(source));
    source.deform_frame_num = 0;
    auto *name = child->name;
    child->name = root->name;
    EXPECT_FALSE(binding->Matches(child));
    EXPECT_FALSE(dc2::character::CloneInputsLive(source));
    child->name = name;
    EXPECT_TRUE(dc2::character::CloneInputsLive(source));
}

TEST_F(NativeRecords, ExactSoundLeasesRejectRetirementAndPermitIndependentBaseCopies) {
    for (const int slot : {0, 3}) {
        std::array<u_long128, 4096> storage{}, copies{};
        mgCMemory                   producer, destination_memory;
        producer.SetHeapMem(storage.data(), static_cast<int>(storage.size()));
        destination_memory.stSetBuffer(copies.data(), static_cast<int>(copies.size()));
        CCharacter2 source;
        source.CObjectFrame::frame = CloneAuxFrame(producer, "root");
        ASSERT_NE(source.CObjectFrame::frame, nullptr);
        ASSERT_TRUE(dc2::character::CaptureModelResources(source, producer));
        auto *cue = CloneAuxObject<CHRINFO_SE>(producer);
        ASSERT_NE(cue, nullptr);
        source.se_list[slot] = cue;
        source.se_num[slot] = 1;
        ASSERT_TRUE(CloneAuxSound(source, producer, slot, 1));
        cue->se_no = 17;
        CCharacter2 destination;
        ASSERT_TRUE(source.Copy(destination, &destination_memory));
        if (slot == 0) {
            EXPECT_NE(destination.se_list[slot], cue);
            EXPECT_EQ(destination.se_list[slot][0].se_no, 17);
        } else {
            EXPECT_EQ(destination.se_list[slot], cue);
        }
        const auto snapshot = source.resource_state.Acquire<dc2::character::ResourceState>();
        const auto graph = dc2::world::FrameGraph::Capture(producer, source.CObjectFrame::frame);
        ASSERT_TRUE(graph.IsLive());
        for (int validation = 0; validation < 1000; ++validation) {
            ASSERT_TRUE(dc2::character::CloneInputsLive(source));
            ASSERT_EQ(source.resource_state.Acquire<dc2::character::ResourceState>(), snapshot);
        }
        producer.Free(reinterpret_cast<u_long128 *>(cue));
        EXPECT_TRUE(graph.IsLive());
        EXPECT_EQ(graph.FindFrame("root"), source.CObjectFrame::frame);
        EXPECT_TRUE(dc2::character::ResourcesLive(source));
        EXPECT_FALSE(dc2::character::CloneInputsLive(source));
        EXPECT_EQ(source.GetSoundInfoCopy(&destination_memory), nullptr);
        EXPECT_EQ(dc2::character::CloneInputsLive(destination), slot == 0);
        CCharacter2 failed;
        EXPECT_FALSE(source.Copy(failed, &destination_memory));
        EXPECT_EQ(failed.CObjectFrame::frame, nullptr);
        auto *replacement = CloneAuxObject<CHRINFO_SE>(producer);
        ASSERT_EQ(replacement, cue);
        EXPECT_FALSE(dc2::character::CloneInputsLive(source));
        ASSERT_TRUE(CloneAuxSound(source, producer, slot, 1));
        EXPECT_TRUE(dc2::character::CloneInputsLive(source));
    }
}

TEST_F(NativeRecords, SoundsRequireExactRegistrationAndUnchangedPointerAndCount) {
    CCharacter2 source;
    source.CObjectFrame::frame = NewGraphFrame(memory, "root");
    ASSERT_NE(source.CObjectFrame::frame, nullptr);
    ASSERT_TRUE(dc2::character::CaptureModelResources(source, memory));
    auto *cue = dc2::memory::NewObject<CHRINFO_SE>(memory);
    ASSERT_NE(cue, nullptr);
    source.se_num[0] = 1;
    source.se_list[0] = cue;
    EXPECT_FALSE(dc2::character::CloneInputsLive(source));
    ASSERT_TRUE(CloneAuxSound(source, memory, 0, 1));
    cue->wait = 23;
    auto *sounds = source.GetSoundInfoCopy(&memory);
    ASSERT_NE(sounds, nullptr);
    EXPECT_EQ(sounds[0].wait, 23);
    source.se_num[0] = -1;
    EXPECT_FALSE(dc2::character::CloneInputsLive(source));
    EXPECT_EQ(source.GetSoundInfoCopy(&memory), nullptr);
    source.se_num[0] = std::numeric_limits<int>::max();
    EXPECT_FALSE(dc2::character::CloneInputsLive(source));
    EXPECT_EQ(source.GetSoundInfoCopy(&memory), nullptr);
    source.se_num[0] = 1;
    CHRINFO_SE stack_cue{};
    source.se_list[0] = &stack_cue;
    EXPECT_FALSE(dc2::character::CloneInputsLive(source));
    EXPECT_EQ(source.GetSoundInfoCopy(&memory), nullptr);
    source.se_list[0] = nullptr;
    EXPECT_FALSE(dc2::character::CloneInputsLive(source));
    source.se_list[0] = cue;
    EXPECT_TRUE(dc2::character::CloneInputsLive(source));
}

TEST_F(NativeRecords, SameAddressNameReplacementRequiresAnActualProducerGraphRefresh) {
    std::array<u_long128, 4096> storage{}, copies{};
    mgCMemory                   producer, destination_memory;
    producer.SetHeapMem(storage.data(), static_cast<int>(storage.size()));
    destination_memory.stSetBuffer(copies.data(), static_cast<int>(copies.size()));
    CCharacter2 source;
    source.CObjectFrame::frame = CloneAuxFrame(producer, "root");
    auto *child = CloneAuxFrame(producer, "child");
    ASSERT_NE(source.CObjectFrame::frame, nullptr);
    ASSERT_NE(child, nullptr);
    child->SetParent(source.CObjectFrame::frame);
    source.entry_frame[0] = child;
    ASSERT_TRUE(dc2::character::CaptureModelResources(source, producer));
    auto *old_name = child->name;
    producer.Free(reinterpret_cast<u_long128 *>(old_name));
    ASSERT_NE(producer.StartStackMode(MG_STACK_MODE_FIT, 32), nullptr);
    auto *name = dc2::memory::NewArray<char>(producer, 6);
    ASSERT_NE(name, nullptr);
    std::memcpy(name, "child", 6);
    producer.EndStackMode();
    ASSERT_EQ(name, old_name);
    EXPECT_FALSE(dc2::character::CloneInputsLive(source));
    CCharacter2 failed;
    EXPECT_FALSE(source.Copy(failed, &destination_memory));
    ASSERT_TRUE(dc2::character::CaptureModelResources(source, producer));
    EXPECT_TRUE(dc2::character::CloneInputsLive(source));
    CCharacter2 destination;
    EXPECT_TRUE(source.Copy(destination, &destination_memory));
    EXPECT_TRUE(dc2::character::CloneInputsLive(destination));
}

TEST_F(NativeRecords, RepeatedCharacterCopiesReleaseDestinationMetadataWithoutRetainingSourceSnapshots) {
    CCharacter2 source;
    source.CObjectFrame::frame = NewGraphFrame(memory, "root");
    ASSERT_NE(source.CObjectFrame::frame, nullptr);
    ASSERT_TRUE(dc2::character::CaptureModelResources(source, memory));
    const auto marker = std::make_shared<int>(17);
    {
        auto resources = *source.resource_state.Acquire<dc2::character::ResourceState>();
        resources.model_context = marker;
        ASSERT_TRUE(dc2::character::PublishResources(source, std::move(resources)));
    }
    const auto                  baseline = marker.use_count();
    std::array<u_long128, 4096> storage{};
    mgCMemory                   destination_memory;
    destination_memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    for (int iteration = 0; iteration < 100; ++iteration) {
        CCharacter2 destination;
        ASSERT_TRUE(source.Copy(destination, &destination_memory));
        // Only construction and completed destination snapshots may retain the model context.
        EXPECT_LE(marker.use_count(), baseline + 2);
        destination.Initialize();
        destination_memory.stReset();
        EXPECT_EQ(marker.use_count(), baseline);
    }
}

TEST_F(NativeRecords, UnchangedCloneAuxPublicationReusesTheImmutableResourceSnapshot) {
    CCharacter2 source;
    source.CObjectFrame::frame = NewGraphFrame(memory, "root");
    ASSERT_NE(source.CObjectFrame::frame, nullptr);
    source.entry_frame[0] = source.CObjectFrame::frame;
    ASSERT_TRUE(dc2::character::CaptureModelResources(source, memory));
    const auto original = source.resource_state.Acquire<dc2::character::ResourceState>();
    const auto graph = dc2::world::FrameGraph::Capture(memory, source.CObjectFrame::frame);
    ASSERT_TRUE(graph.IsLive());
    for (int iteration = 0; iteration < 100; ++iteration) {
        dc2::character::CloneAuxBuilder builder(original->clone_inputs);
        ASSERT_TRUE(dc2::character::PublishCloneInputs(source, std::move(builder)));
        EXPECT_EQ(source.resource_state.Acquire<dc2::character::ResourceState>(), original);
    }
}

TEST_F(NativeRecords, InvalidAuxiliarySelfCopyUsesTheActualDerivedCleanupContract) {
    auto source = std::make_unique<CActiveMonster>();
    source->CObjectFrame::frame = NewGraphFrame(memory, "root");
    ASSERT_NE(source->CObjectFrame::frame, nullptr);
    ASSERT_TRUE(dc2::character::CaptureModelResources(*source, memory));
    source->state = ACTIVE_MONSTER_LIVE;
    ASSERT_TRUE(source->Copy(*source, nullptr));
    CHRINFO_SE unregistered{};
    source->se_list[0] = &unregistered;
    source->se_num[0] = 1;
    EXPECT_FALSE(source->Copy(*source, nullptr));
    EXPECT_EQ(source->state, ACTIVE_MONSTER_NONE);
    EXPECT_EQ(source->CObjectFrame::frame, nullptr);
    EXPECT_FALSE(source->resource_state.HasValue());
}
