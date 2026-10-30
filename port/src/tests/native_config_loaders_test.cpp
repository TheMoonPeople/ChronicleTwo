#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <chrono>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <string>
#include <vector>

#include "assets/data_registry.hpp"
#include "mainloop.hpp"
#include "mg_memory.hpp"
#include "npccfg.hpp"
#include "platform/datapacks.hpp"
#include "quest.hpp"
#include "villagermngr.hpp"
#include "vlgr_info.hpp"

namespace {
using Json = nlohmann::json;

/**
 * UTF-8 "以後", the condition making a progress entry apply to later progress too.
 */
constexpr const char *kAfter = "\xE4\xBB\xA5\xE5\xBE\x8C";

/**
 * Builds one party_characters record.
 */
Json Character(int id, const std::string &name, const std::string &model, int unk_31, int ability_num, int max_npc_point, const std::vector<int> &costs, int debug_flag) {
    return {
        {"id",            id           },
        {"name",          name         },
        {"model",         model        },
        {"unk_31",        unk_31       },
        {"ability_num",   ability_num  },
        {"max_npc_point", max_npc_point},
        {"ability_cost",  costs        },
        {"debug_flag",    debug_flag   }
    };
}

/**
 * Adds party characters that no test looks up, to exceed the original 32 KiB file buffer.
 */
void CharacterPadding(Json &characters, int count) {
    for (int index = 0; index < count; ++index) {
        characters.push_back(Character(1000 + index, "Padding " + std::to_string(index), "pad", 0, 0, 0, {0, 0, 0, 0}, 0));
    }
}

/**
 * Builds one place block holding only its map and standing point.
 */
Json Place(int index, int map, float x, float y, float z, float angle) {
    return {
        {"index",    index        },
        {"map",      map          },
        {"position", {x, y, z}    },
        {"angle",    angle        },
        {"route",    Json::array()}
    };
}

/**
 * Adds story progress points out of range, which the loader drops, to exceed the original 0x19000-byte buffer.
 */
void ProgressPadding(Json &points) {
    for (int index = 0; index < 600; ++index) {
        points.push_back({
            {"progress", -1 - index},
            {"chapter", 0},
            {"section", 0},
            {"order", 0},
            {"name", std::string(200, 'x')}
        });
    }
}

/**
 * Builds one progress entry of a villager schedule.
 */
Json Progress(int progress, int duplicate_id, const std::string &condition, int noon_place, int night_place) {
    return {
        {"progress",     progress    },
        {"duplicate_id", duplicate_id},
        {"condition",    condition   },
        {"noon_place",   noon_place  },
        {"night_place",  night_place }
    };
}

/**
 * Provides native configuration files and a small arena for their actual gameplay records.
 */
class NativeConfigLoaders : public testing::Test {
protected:
    std::filesystem::path  directory;             /**< Temporary native configuration directory. */
    std::filesystem::path  previous_root;         /**< Datapack root restored after the fixture. */
    std::vector<u_long128> storage;               /**< Backing storage for native place and schedule records. */
    mgCMemory              memory;                /**< Arena receiving native records rather than input-file bytes. */
    int                    previous_language = 0; /**< Language restored after testing language-specific NPC data. */

    void SetUp() override {
        previous_root = datapacks::Root();
        previous_language = LanguageCode;
        LanguageCode = LANG_ENGLISH;
        directory = std::filesystem::temp_directory_path() / ("chronicle_native_loaders_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
        std::filesystem::create_directories(directory / "data");
        DataReadIndex(directory / "data");
        storage.resize(8192);
        memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    }

    void TearDown() override {
        Write("npc" + std::to_string(LanguageCode) + ".cfg.json", "party_characters", {
                                                                                          {"characters", Json::array()}
        });
        LoadNPCCfg();
        LanguageCode = previous_language;
        if (previous_root.empty()) {
            DataReadIndex(directory / "empty/data");
            datapacks::Clear();
        } else {
            DataReadIndex(previous_root.parent_path() / "data");
        }
        std::filesystem::remove_all(directory);
    }

    /**
     * Writes a native document of a kind with the given body, returning its size in bytes.
     */
    std::uintmax_t Write(const std::string &name, const std::string &kind, const Json &body) {
        const auto path = directory / "data" / name;
        Json       document = body;
        document["schema_version"] = 2;
        document["kind"] = kind;
        std::ofstream(path, std::ios::binary) << document.dump(2);
        return std::filesystem::file_size(path);
    }

    /**
     * Writes a place table of two places, with padding blocks for the second ahead of its final block.
     */
    std::uintmax_t WritePlaces(const Json &padding = Json::array()) {
        Json first = Place(0, 101, 1.25f, 2.5f, -3, .75f);
        first["talk_offset"] = {4, 5, 6};
        first["motion"] = "sit";
        first["move_motion"] = "run";
        first["move_speed"] = 1.5f;
        first["shadow"] = 0;
        first["route"] = Json::array({
            {{"type", "move"}, {"position", {7, 8, 9}}, {"angle", 1}},
            {{"type", "wait"}, {"posture", "mtn"}, {"time", 45}, {"motion", "stand"}}
        });
        Json blocks = Json::array({first});
        for (const auto &block : padding) {
            blocks.push_back(block);
        }
        blocks.push_back(Place(1, 202, -10, 20, 30, -.5f));
        return Write("place.cfg.json", "villager_places", {
                                                              {"place_count", 2     },
                                                              {"places",      blocks}
        });
    }
};
} // namespace

TEST_F(NativeConfigLoaders, NpcRecordsAfterPaddingExceedTheOriginal32KiBBuffer) {
    Json characters = Json::array();
    characters.push_back(Character(7, "First NPC", "npc_first", 3, 2, 25, {1, 2, 3, 4}, 1));
    CharacterPadding(characters, 170);
    characters.push_back(Character(18, "Final NPC", "npc_last", 5, 4, 37, {6, 7, 8, 9}, 0));
    ASSERT_GT(Write("npc1.cfg.json", "party_characters", {
                                                             {"characters", characters}
    }),
              2048u * 16u);
    LoadNPCCfg();
    const auto *first = GetPartyNPCData(7);
    const auto *last = GetPartyNPCData(18);
    ASSERT_NE(first, nullptr);
    ASSERT_NE(last, nullptr);
    EXPECT_STREQ(first->name, "First NPC");
    EXPECT_STREQ(first->model, "npc_first");
    EXPECT_STREQ(GetPartyCharaModelName(7, NPC_MODEL_PATH_INFO), "info");
    EXPECT_STREQ(GetPartyCharaModelName(7, NPC_MODEL_PATH_CHARA), "chara/npc_first.gltf");
    EXPECT_STREQ(GetPartyCharaModelName(7, NPC_MODEL_PATH_EVENT_TRAIN), "event/train/tnpc_first.gltf");
    EXPECT_STREQ(GetPartyCharaModelName(7, NPC_MODEL_PATH_MENU), "menu/npc/tnpc_first.gltf");
    EXPECT_EQ(GetPartyCharaMessage(7, -1, 0), 0);
    EXPECT_EQ(GetPartyCharaMessage(7, 16, 0), 0);
    auto      *mutable_first = GetPartyNPCData(7);
    const auto original_first = *mutable_first;
    std::memset(mutable_first->model, 'x', sizeof mutable_first->model);
    EXPECT_EQ(GetPartyCharaModelName(7, NPC_MODEL_PATH_CHARA), nullptr);
    *mutable_first = original_first;
    EXPECT_EQ(first->debug_flag, 1);
    EXPECT_STREQ(last->name, "Final NPC");
    EXPECT_STREQ(last->model, "npc_last");
    EXPECT_EQ(last->unk_31, 5);
    EXPECT_EQ(last->ability_num, 4);
    EXPECT_EQ(last->max_npc_point, 37);
    for (int index = 0; index < 4; ++index) {
        EXPECT_EQ(last->ability_cost[index], 6 + index);
    }
    EXPECT_EQ(last->debug_flag, 0);
    EXPECT_EQ(GetPartyNPCData(19), nullptr);

    characters = Json::array();
    CharacterPadding(characters, 170);
    characters.push_back(Character(9, "French NPC", "npc_french", 0, 1, 12, {2, 0, 0, 0}, 1));
    ASSERT_GT(Write("npc2.cfg.json", "party_characters", {
                                                             {"characters", characters}
    }),
              2048u * 16u);
    LanguageCode = LANG_FRENCH;
    LoadNPCCfg();
    EXPECT_EQ(GetPartyNPCData(7), nullptr);
    EXPECT_EQ(GetPartyNPCData(18), nullptr);
    ASSERT_NE(GetPartyNPCData(9), nullptr);
    EXPECT_STREQ(GetNPCName(9), "French NPC");
}

TEST_F(NativeConfigLoaders, NpcRecordsKeepTheTableBoundsAndNullTexts) {
    Json characters = Json::array();
    characters.push_back(Character(1, "Named", "named", 0, 0, 0, {0, 0, 0, 0}, 0));
    ASSERT_GT(Write("npc1.cfg.json", "party_characters", {
                                                             {"characters", characters}
    }),
              0u);
    LoadNPCCfg();
    // A record without text keeps what its table entry already held.
    characters = Json::array();
    characters.push_back(Character(2, "", "", 0, 0, 0, {0, 0, 0, 0}, 0));
    characters[0]["name"] = nullptr;
    characters[0]["model"] = nullptr;
    CharacterPadding(characters, 200);
    Write("npc1.cfg.json", "party_characters", {
                                                   {"characters", characters}
    });
    LoadNPCCfg();
    ASSERT_NE(GetPartyNPCData(2), nullptr);
    EXPECT_STREQ(GetNPCName(2), "Named");
    EXPECT_STREQ(GetNPCModelName(2), "named");
    EXPECT_NE(GetPartyNPCData(1000 + 178), nullptr);
    EXPECT_EQ(GetPartyNPCData(1000 + 179), nullptr);

    // A name too long for its field rejects the document.
    characters = Json::array();
    characters.push_back(Character(3, std::string(0x1C, 'n'), "m", 0, 0, 0, {0, 0, 0, 0}, 0));
    Write("npc1.cfg.json", "party_characters", {
                                                   {"characters", characters}
    });
    LoadNPCCfg();
    EXPECT_EQ(GetPartyNPCData(2), nullptr);
    EXPECT_EQ(GetPartyNPCData(3), nullptr);

    // Command-list documents are no longer read.
    std::ofstream(directory / "data" / "npc1.cfg.json", std::ios::binary) << R"({"schema_version":1,"commands":[]})";
    LoadNPCCfg();
    EXPECT_EQ(GetPartyNPCData(3), nullptr);
}

TEST_F(NativeConfigLoaders, OversizedPlaceAndVillagerFilesAllocateTheirNativeTables) {
    Json padding = Json::array();
    for (int index = 0; index < 600; ++index) {
        // Repeated blocks of one place keep applying to it; the last sets its final map and position.
        Json block = Place(1, 900 + index, 0, 0, 0, 0);
        block["talk_offset"] = {static_cast<float>(index), 0, 0};
        padding.push_back(block);
    }
    ASSERT_GT(WritePlaces(padding), 0x19000u);

    Json points = Json::array();
    points.push_back({
        {"progress", 5               },
        {"chapter",  2               },
        {"section",  3               },
        {"order",    100             },
        {"name",     "First progress"}
    });
    ProgressPadding(points);
    points.push_back({
        {"progress", 9               },
        {"chapter",  4               },
        {"section",  6               },
        {"order",    200             },
        {"name",     "Final progress"}
    });
    const Json villagers = {
        {{"id", 7},  {"progress", Json::array({Progress(5, 0, "", 0, 1)})}    },
        {{"id", 18}, {"progress", Json::array({Progress(9, 1, kAfter, 1, 0)})}}
    };
    const Json models = {
        {{"id", 7}, {"model", "first_villager"}, {"house_type", VLGR_HOUSE_B}, {"show_frames", "hat;bag"}, {"hide_frames", "hidden"}, {"unk_14", 11}, {"unk_18", 12}},
        {{"id", 18}, {"model", "last_villager"}, {"house_type", VLGR_HOUSE_D}}
    };
    ASSERT_GT(Write("npc_place4.cfg.json", "villager_schedule", {
                                                                    {"progress_info", points                               },
                                                                    {"villagers",     villagers                            },
                                                                    {"villager_info", {{"count", 2}, {"villagers", models}}}
    }),
              0x19000u);
    LoadGameInfo(&memory);

    auto *first = GetVlgrPlaceInfo(0);
    auto *last = GetVlgrPlaceInfo(1);
    ASSERT_NE(first, nullptr);
    ASSERT_NE(last, nullptr);
    EXPECT_EQ(GetVlgrPlaceInfo(2), nullptr);
    EXPECT_EQ(first->map_no, 101);
    EXPECT_FLOAT_EQ(first->pos[0], 1.25f);
    EXPECT_FLOAT_EQ(first->pos[3], .75f);
    EXPECT_FLOAT_EQ(first->talk_offset[2], 6);
    EXPECT_EQ(first->motion, VLGR_MOTION_SIT);
    EXPECT_EQ(first->move_motion, VLGR_MOTION_RUN);
    EXPECT_FLOAT_EQ(first->move_speed, 1.5f);
    EXPECT_EQ(first->no_shadow, 1);
    ASSERT_NE(first->route, nullptr);
    EXPECT_EQ(first->route->type, VLGR_ROUTE_MOVE);
    EXPECT_FLOAT_EQ(first->route->pos[2], 9);
    EXPECT_FLOAT_EQ(first->route->pos[3], 1);
    ASSERT_NE(first->route->next, nullptr);
    EXPECT_EQ(first->route->next->type, VLGR_ROUTE_WAIT);
    EXPECT_EQ(first->route->next->wait.motion_end, 1);
    EXPECT_EQ(first->route->next->wait.time, 45);
    EXPECT_EQ(first->route->next->wait.motion, VLGR_MOTION_STAND);
    EXPECT_EQ(first->route->next->next, nullptr);
    EXPECT_EQ(last->map_no, 202);
    EXPECT_FLOAT_EQ(last->pos[0], -10);
    EXPECT_FLOAT_EQ(last->talk_offset[0], 599);
    EXPECT_EQ(last->move_motion, VLGR_MOTION_WALK);
    EXPECT_EQ(last->motion, VLGR_MOTION_STAND);
    EXPECT_EQ(last->no_shadow, 0);
    EXPECT_EQ(GetGameProgressNum(), GAME_PROGRESS_MAX);
    const auto *progress = GetGameProgressInfo(9);
    ASSERT_NE(progress, nullptr);
    EXPECT_EQ(progress->chapter, 4);
    EXPECT_EQ(progress->section, 6);
    EXPECT_EQ(progress->order, 200);
    EXPECT_STREQ(progress->name, "Final progress");
    EXPECT_STREQ(GetGameProgressInfo(5)->name, "First progress");
    EXPECT_EQ(GetGameProgressInfo(0)->name, nullptr);
    const auto *info = GetVillagerInfo(7);
    ASSERT_NE(info, nullptr);
    EXPECT_STREQ(info->model_name, "first_villager");
    EXPECT_STREQ(info->show_frames, "hat;bag");
    EXPECT_STREQ(info->hide_frames, "hidden");
    EXPECT_EQ(info->house_type, VLGR_HOUSE_B);
    EXPECT_EQ(info->unk_14, 11);
    EXPECT_EQ(info->unk_18, 12);
    ASSERT_NE(GetVillagerInfo(18), nullptr);
    EXPECT_EQ(GetVillagerInfo(18)->house_type, VLGR_HOUSE_D);
    EXPECT_EQ(GetVillagerInfo(18)->show_frames, nullptr);
    EXPECT_EQ(GetVillagerInfo(18)->unk_14, -1);
    int         count = 0;
    const auto *schedule = GetVlgrPlaceTable(&count);
    ASSERT_EQ(count, VLGR_PLACE_MAX);
    ASSERT_EQ(schedule[7].prog_num, 1);
    EXPECT_EQ(schedule[7].prog_info[0].progress, 5);
    EXPECT_EQ(schedule[7].prog_info[0].after, 0);
    EXPECT_EQ(schedule[7].prog_info[0].place[0][VLGR_TIME_NOON], first);
    EXPECT_EQ(schedule[7].prog_info[0].place[0][VLGR_TIME_NIGHT], last);
    ASSERT_EQ(schedule[18].prog_num, 1);
    EXPECT_EQ(schedule[18].prog_info[0].progress, 9);
    EXPECT_EQ(schedule[18].prog_info[0].after, 1);
    EXPECT_EQ(schedule[18].prog_info[0].place[1][VLGR_TIME_NOON], last);
    EXPECT_EQ(schedule[18].prog_info[0].place[1][VLGR_TIME_NIGHT], first);
    EXPECT_LT(memory.stack_used * 16, 0x19000);
}

TEST_F(NativeConfigLoaders, VillagerSchedulesFollowTheRetailCallbacks) {
    WritePlaces();
    const Json villagers = {
        // Each entry end stores every entry collected so far; a repeated progress number reuses its entry.
        {{"id", 3},              {"progress", Json::array({Progress(1, 0, "", 0, 0), Progress(2, 0, kAfter, 1, 1), Progress(1, 2, kAfter, 1, 0)})}},
        // An alternative or place number out of range is ignored.
        {{"id", 4},              {"progress", Json::array({Progress(6, 4, "", 0, 0), Progress(7, 0, "", 2, -1)})}                                 },
        // An out-of-range villager stores nothing.
        {{"id", VLGR_PLACE_MAX}, {"progress", Json::array({Progress(8, 0, "", 0, 0)})}                                                            },
        {{"id", 5},              {"progress", Json::array({{{"progress", 9}, {"duplicate_id", 3}}})}                                              }
    };
    const Json models = {
        {{"id", 1}, {"model", "kept"}   },
        {{"id", 2}, {"model", "dropped"}}
    };
    Write("npc_place4.cfg.json", "villager_schedule", {
                                                          {"progress_info", Json::array()                        },
                                                          {"villagers",     villagers                            },
                                                          {"villager_info", {{"count", 1}, {"villagers", models}}}
    });
    LoadGameInfo(&memory);
    const auto *first = GetVlgrPlaceInfo(0);
    const auto *last = GetVlgrPlaceInfo(1);
    int         count = 0;
    const auto *schedule = GetVlgrPlaceTable(&count);
    ASSERT_EQ(schedule[3].prog_num, 2);
    EXPECT_EQ(schedule[3].prog_info[0].progress, 1);
    EXPECT_EQ(schedule[3].prog_info[0].after, 1);
    EXPECT_EQ(schedule[3].prog_info[0].place[0][VLGR_TIME_NOON], first);
    EXPECT_EQ(schedule[3].prog_info[0].place[2][VLGR_TIME_NOON], last);
    EXPECT_EQ(schedule[3].prog_info[0].place[2][VLGR_TIME_NIGHT], first);
    EXPECT_EQ(schedule[3].prog_info[1].progress, 2);
    EXPECT_EQ(schedule[3].prog_info[1].place[0][VLGR_TIME_NIGHT], last);
    ASSERT_EQ(schedule[4].prog_num, 2);
    for (const auto &alternatives : schedule[4].prog_info[0].place) {
        EXPECT_EQ(alternatives[VLGR_TIME_NOON], nullptr);
    }
    EXPECT_EQ(schedule[4].prog_info[1].place[0][VLGR_TIME_NOON], nullptr);
    EXPECT_EQ(schedule[4].prog_info[1].place[0][VLGR_TIME_NIGHT], nullptr);
    ASSERT_EQ(schedule[5].prog_num, 1);
    EXPECT_EQ(schedule[5].prog_info[0].progress, 9);
    EXPECT_EQ(schedule[5].prog_info[0].after, 0);
    ASSERT_NE(GetVillagerInfo(1), nullptr);
    EXPECT_STREQ(GetVillagerInfo(1)->model_name, "kept");
    EXPECT_EQ(GetVillagerInfo(1)->house_type, 0);
    EXPECT_EQ(GetVillagerInfo(2), nullptr);
}

TEST_F(NativeConfigLoaders, PlaceBlocksOutsideTheTableAreIgnored) {
    Json route_block = Place(0, 5, 1, 2, 3, 4);
    route_block["route"] = Json::array({
        {{"type", "move"}, {"position", {1, 1, 1}}, {"angle", 0}}
    });
    Json second_block = Place(0, 6, 1, 2, 3, 4);
    second_block["shadow"] = 1;
    second_block["motion"] = "stand";
    second_block["move_motion"] = nullptr;
    second_block["route"] = Json::array({
        {{"type", "wait"}, {"posture", nullptr}, {"time", 3}}
    });
    Write("place.cfg.json", "villager_places", {
                                                   {"place_count", 1                                                                             },
                                                   {"places",      {route_block, second_block, Place(1, 7, 0, 0, 0, 0), Place(-1, 8, 0, 0, 0, 0)}}
    });
    Write("npc_place4.cfg.json", "villager_schedule", {
                                                          {"progress_info", Json::array()},
                                                          {"villagers",     Json::array()}
    });
    LoadGameInfo(&memory);
    const auto *place = GetVlgrPlaceInfo(0);
    ASSERT_NE(place, nullptr);
    EXPECT_EQ(GetVlgrPlaceInfo(1), nullptr);
    EXPECT_EQ(place->map_no, 6);
    EXPECT_EQ(place->no_shadow, 0);
    EXPECT_EQ(place->motion, VLGR_MOTION_STAND);
    EXPECT_EQ(place->move_motion, VLGR_MOTION_WALK);
    ASSERT_NE(place->route, nullptr);
    EXPECT_EQ(place->route->type, VLGR_ROUTE_MOVE);
    ASSERT_NE(place->route->next, nullptr);
    EXPECT_EQ(place->route->next->type, VLGR_ROUTE_WAIT);
    EXPECT_EQ(place->route->next->wait.motion_end, 0);
    EXPECT_EQ(place->route->next->wait.time, 3);
    EXPECT_EQ(place->route->next->wait.motion, VLGR_MOTION_NONE);
}

TEST_F(NativeConfigLoaders, QuestRecordsInitializeMissingCommentsAndUnusedCapacity) {
    const auto        size = Write("quest.cfg.json", "quests", {
                                                                   {"count",  3                                              },
                                                                   {"quests", Json::array({{{"id", 7}, {"name", "request"}}})}
    });
    std::vector<char> input(static_cast<std::size_t>(size));
    std::ifstream     source(directory / "data/quest.cfg.json", std::ios::binary);
    source.read(input.data(), static_cast<std::streamsize>(input.size()));
    ASSERT_TRUE(source);
    DataReadRegisterAsset(input.data(), "quest.cfg.json", input.size());
    const auto remaining = dc2::memory::RemainingBytes(memory);
    std::memset(remaining.data(), 0xA5, remaining.size());
    CQuestManager manager;
    manager.Initialize();
    manager.LoadCfg(&memory, input.data(), static_cast<int>(input.size()));
    ASSERT_EQ(manager.num, 3);
    ASSERT_NE(manager.info, nullptr);
    const auto *entry = manager.GetQuestInfo(7);
    ASSERT_NE(entry, nullptr);
    EXPECT_STREQ(entry->name, "request");
    EXPECT_EQ(entry->comment[0], char{});
    for (const auto &reaction : entry->reaction) {
        EXPECT_EQ(reaction[0], char{});
    }
    EXPECT_EQ(manager.info[1].id, -1);
    EXPECT_EQ(manager.info[2].id, -1);
    EXPECT_EQ(manager.info[1].name[0], char{});
    EXPECT_EQ(manager.GetQuestInfo(0), nullptr);
    auto *before = manager.info;
    memory.stSetLocked(true);
    manager.LoadCfg(&memory, input.data(), static_cast<int>(input.size()));
    EXPECT_EQ(manager.info, before);
    EXPECT_EQ(manager.num, 3);
}
