#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <chrono>
#include <filesystem>
#include <fstream>
#include <string>
#include <vector>

#include "dataread_port.hpp"
#include "mainloop.hpp"
#include "mg_memory.hpp"
#include "npccfg.hpp"
#include "platform/datapacks.hpp"
#include "vlgr_info.hpp"

namespace {
using Json = nlohmann::json;

/**
 * Constructs a typed integer callback argument.
 */
Json Integer(int value) { return {
    {"type",  "int"},
    {"value", value}
 }; }

/**
 * Constructs a typed floating-point callback argument.
 */
Json Real(float value) { return {
    {"type",  "float"},
    {"value", value  }
 }; }

/**
 * Constructs a typed string callback argument.
 */
Json Text(const std::string &value) { return {
    {"type",  "string"},
    {"value", value   }
 }; }

/**
 * Appends one native command without serializing its typed arguments as script text.
 */
void Command(Json &commands, const char *name, Json arguments = Json::array()) {
    commands.push_back({
        {"command", name                },
        {"args",    std::move(arguments)}
    });
}

/**
 * Adds unknown commands with individually bounded arguments to exceed the original file buffers.
 */
void Padding(Json &commands) {
    for (int index = 0; index < 400; ++index) {
        Command(commands, "IGNORED_PADDING", {Text(std::string(256, 'x')), Integer(index)});
    }
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
        std::filesystem::create_directories(directory / "port_data");
        std::filesystem::create_directories(directory / "data");
        DataReadIndex(directory / "data");
        storage.resize(8192);
        memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    }

    void TearDown() override {
        Json commands = Json::array();
        Command(commands, "NPC_NUM", {Integer(0)});
        Write("npc" + std::to_string(LanguageCode) + ".cfg.json", commands);
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

    std::uintmax_t Write(const std::string &name, const Json &commands) {
        const auto path = directory / "port_data" / name;
        const Json document = {
            {"schema_version", 1       },
            {"commands",       commands}
        };
        std::ofstream(path, std::ios::binary) << document.dump(2);
        return std::filesystem::file_size(path);
    }
};
} // namespace

TEST_F(NativeConfigLoaders, NpcRecordsAfterPaddingExceedTheOriginal32KiBBuffer) {
    Json commands = Json::array();
    Command(commands, "NPC_NUM", {Integer(2)});
    Command(commands, "NPC_INFO", {Integer(7), Text("First NPC"), Text("npc_first"), Integer(3), Integer(2), Integer(25), Integer(1), Integer(2), Integer(3), Integer(4), Integer(1)});
    Padding(commands);
    Command(commands, "NPC_INFO", {Integer(18), Text("Final NPC"), Text("npc_last"), Integer(5), Integer(4), Integer(37), Integer(6), Integer(7), Integer(8), Integer(9), Integer(0)});
    ASSERT_GT(Write("npc1.cfg.json", commands), 2048u * 16u);
    LoadNPCCfg();
    const auto *first = GetPartyNPCData(7);
    const auto *last = GetPartyNPCData(18);
    ASSERT_NE(first, nullptr);
    ASSERT_NE(last, nullptr);
    EXPECT_STREQ(first->name, "First NPC");
    EXPECT_STREQ(first->model, "npc_first");
    EXPECT_STREQ(GetPartyCharaModelName(7, NPC_MODEL_PATH_INFO), "info");
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

    commands = Json::array();
    Command(commands, "NPC_NUM", {Integer(1)});
    Padding(commands);
    Command(commands, "NPC_INFO", {Integer(9), Text("French NPC"), Text("npc_french"), Integer(0), Integer(1), Integer(12), Integer(2), Integer(0), Integer(0), Integer(0), Integer(1)});
    ASSERT_GT(Write("npc2.cfg.json", commands), 2048u * 16u);
    LanguageCode = LANG_FRENCH;
    LoadNPCCfg();
    EXPECT_EQ(GetPartyNPCData(7), nullptr);
    EXPECT_EQ(GetPartyNPCData(18), nullptr);
    ASSERT_NE(GetPartyNPCData(9), nullptr);
    EXPECT_STREQ(GetNPCName(9), "French NPC");
}

TEST_F(NativeConfigLoaders, OversizedPlaceAndVillagerFilesAllocateTheirNativeTables) {
    Json places = Json::array();
    Command(places, "MOVE_SPEED", {Real(99)});
    Command(places, "NPC_PLACE_NUM", {Integer(2)});
    Command(places, "NPC_PLACE", {Integer(0), Integer(101)});
    Command(places, "PLACE_POS", {Real(1.25f), Real(2.5f), Real(-3), Real(.75f)});
    Command(places, "TALK_OFFSET", {Real(4), Real(5), Real(6)});
    Command(places, "MOTION", {Text("sit")});
    Command(places, "MOVE_MOTION", {Text("run")});
    Command(places, "MOVE_SPEED", {Real(1.5f)});
    Command(places, "SHADOW", {Integer(0)});
    Command(places, "MOVE_TO", {Real(7), Real(8), Real(9), Real(1)});
    Command(places, "WAIT", {Text("mtn"), Integer(45), Text("stand")});
    Command(places, "NPC_PLACE_END");
    Padding(places);
    Command(places, "NPC_PLACE", {Integer(1), Integer(202)});
    Command(places, "PLACE_POS", {Real(-10), Real(20), Real(30), Real(-.5f)});
    Command(places, "NPC_PLACE_END");
    ASSERT_GT(Write("place.cfg.json", places), 0x19000u);

    Json villagers = Json::array();
    Command(villagers, "PROG_INFO", {Integer(-1), Integer(0), Integer(0), Integer(0), Text("ignored")});
    Command(villagers, "PROG_INFO", {Integer(5), Integer(2), Integer(3), Integer(100), Text("First progress")});
    Command(villagers, "NPC_INFO_NUM", {Integer(2)});
    Command(villagers, "NPC_INFO", {Integer(7), Text("first_villager"), Integer(VLGR_HOUSE_B), Text("hat;bag"), Text("hidden"), Integer(11), Integer(12)});
    Command(villagers, "NPC", {Integer(7)});
    Command(villagers, "PROGRESS", {Integer(5), Integer(0), Text("")});
    Command(villagers, "PLACE");
    Command(villagers, "NOON_PLACE", {Integer(0)});
    Command(villagers, "NIGHT_PLACE", {Integer(1)});
    Command(villagers, "PROGRESS_END");
    Command(villagers, "NPC_END");
    Padding(villagers);
    Command(villagers, "PROG_INFO", {Integer(9), Integer(4), Integer(6), Integer(200), Text("Final progress")});
    Command(villagers, "NPC_INFO", {Integer(18), Text("last_villager"), Integer(VLGR_HOUSE_D)});
    Command(villagers, "NPC", {Integer(18)});
    Command(villagers, "PROGRESS", {Integer(9), Integer(1), Text("")});
    Command(villagers, "NOON_PLACE", {Integer(1)});
    Command(villagers, "NIGHT_PLACE", {Integer(0)});
    Command(villagers, "PROGRESS_END");
    Command(villagers, "NPC_END");
    ASSERT_GT(Write("npc_place4.cfg.json", villagers), 0x19000u);
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
    ASSERT_NE(first->route->next, nullptr);
    EXPECT_EQ(first->route->next->type, VLGR_ROUTE_WAIT);
    EXPECT_EQ(first->route->next->wait.motion_end, 1);
    EXPECT_EQ(first->route->next->wait.time, 45);
    EXPECT_EQ(first->route->next->wait.motion, VLGR_MOTION_STAND);
    EXPECT_EQ(last->map_no, 202);
    EXPECT_FLOAT_EQ(last->pos[0], -10);
    EXPECT_EQ(GetGameProgressNum(), GAME_PROGRESS_MAX);
    const auto *progress = GetGameProgressInfo(9);
    ASSERT_NE(progress, nullptr);
    EXPECT_EQ(progress->chapter, 4);
    EXPECT_EQ(progress->section, 6);
    EXPECT_EQ(progress->order, 200);
    EXPECT_STREQ(progress->name, "Final progress");
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
    int         count = 0;
    const auto *schedule = GetVlgrPlaceTable(&count);
    ASSERT_EQ(count, VLGR_PLACE_MAX);
    ASSERT_EQ(schedule[7].prog_num, 1);
    EXPECT_EQ(schedule[7].prog_info[0].progress, 5);
    EXPECT_EQ(schedule[7].prog_info[0].place[0][VLGR_TIME_NOON], first);
    EXPECT_EQ(schedule[7].prog_info[0].place[0][VLGR_TIME_NIGHT], last);
    ASSERT_EQ(schedule[18].prog_num, 1);
    EXPECT_EQ(schedule[18].prog_info[0].progress, 9);
    EXPECT_EQ(schedule[18].prog_info[0].place[1][VLGR_TIME_NOON], last);
    EXPECT_EQ(schedule[18].prog_info[0].place[1][VLGR_TIME_NIGHT], first);
    EXPECT_LT(memory.stack_used * 16, 0x19000);
}
