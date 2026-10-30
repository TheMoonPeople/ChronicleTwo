#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <array>
#include <chrono>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <limits>
#include <memory>
#include <string>
#include <vector>

#include "assets/data_registry.hpp"
#include "dataread.hpp"
#include "fishing.hpp"
#include "inventmn.hpp"
#include "log_capture.hpp"
#include "mainloop.hpp"
#include "mapinfo.hpp"
#include "mapsky.hpp"
#include "menuaqua.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"
#include "platform/datapacks.hpp"
#include "quest.hpp"
#include "stubs/fishing.hpp"
#include "stubs/mapsky.hpp"
#include "texture_source.hpp"

namespace {
using Json = nlohmann::json;

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
