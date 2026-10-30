#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <array>
#include <chrono>
#include <filesystem>
#include <fstream>
#include <memory>
#include <string>

#include "assets/data_registry.hpp"
#include "charasetup.hpp"
#include "config_bridges.hpp"
#include "dataread.hpp"
#include "gamedata.hpp"
#include "log_capture.hpp"
#include "mainloop.hpp"
#include "mapselect.hpp"
#include "platform/datapacks.hpp"
#include "platform/game_loop_state.hpp"
#include "savedata.hpp"
#include "userdata.hpp"

int LoadGameDataAnalyze(char *name);

/** Debug menu row values of mainloop.cpp, which MAP_NO sets. */
extern int SelectArg[32] asm("MainLoop_SelectArg");

namespace {
using Json = nlohmann::json;

/**
 * Makes a fresh save the active save data for one test.
 */
struct ScopedGameSave {
    CSaveData                 *previous = PortActiveSaveData;          /**< Save data restored afterwards. */
    std::unique_ptr<CSaveData> active = std::make_unique<CSaveData>(); /**< Save data the test changes. */

    ScopedGameSave() { PortActiveSaveData = active.get(); }

    ~ScopedGameSave() { PortActiveSaveData = previous; }

    ScopedGameSave(const ScopedGameSave &) = delete;
    ScopedGameSave &operator=(const ScopedGameSave &) = delete;
};

/**
 * Publishes native game, item, map-name and movie documents in an isolated data root.
 */
class NativeGame : public testing::Test {
protected:
    std::filesystem::path previous_root = datapacks::Root(); /**< Data root restored after the fixture. */
    std::string           previous_directory;                /**< Current resource directory restored after the fixture. */
    std::filesystem::path directory;                         /**< Fixture root holding the unified data tree. */

    void SetUp() override {
        previous_directory = GetCurrentDir();
        SetCurrentDir(nullptr);
        directory = std::filesystem::temp_directory_path() /
                    ("chronicle_native_game_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
        std::filesystem::create_directories(directory / "data/menu/cfg7");
        std::filesystem::create_directories(directory / "data/map");
        std::filesystem::create_directories(directory / "data/dbg");
        std::filesystem::create_directories(directory / "data");
    }

    void TearDown() override {
        if (previous_root.empty()) {
            DataReadIndex(directory / "empty/data");
            datapacks::Clear();
        } else {
            DataReadIndex(previous_root.parent_path() / "data");
        }
        SetCurrentDir(previous_directory.data());
        std::filesystem::remove_all(directory);
    }

    /**
     * Writes one native document of a kind under the fixture's data tree.
     */
    void Write(const std::string &name, const char *kind, Json body) const {
        body["schema_version"] = 2;
        body["kind"] = kind;
        std::ofstream(directory / "data" / name, std::ios::binary) << body.dump(2);
    }

    /**
     * Indexes the fixture's data root after its documents are written.
     */
    void Index() const { DataReadIndex(directory / "data"); }

    /**
     * Writes every item table LoadData reads, with one record each.
     */
    void WriteItemTables() const {
        auto common = [](int item_no, int type, int list_no, const char *file_name, int max_num) {
            return Json{
                {"item_no",         item_no  },
                {"type",            type     },
                {"list_no",         list_no  },
                {"active_set",      1        },
                {"stack_num",       3        },
                {"max_num",         max_num  },
                {"icon_texture_no", 4        },
                {"icon_no",         5        },
                {"message_no",      6        },
                {"file_name",       file_name},
                {"attribute",       7        }
            };
        };
        Write("menu/cfg7/comdat.cfg.json", "item_common",
              {
                  {"records",
                   Json::array({common(11, ITEM_DATA_MAX_MELEE, 0, "dagger", 200), common(172, ITEM_DATA_RECOVERY, 0, "bread", 9),
                                common(250, ITEM_DATA_ROBO_ARM, 0, "arm", 1), common(300, ITEM_DATA_FISH, 0, "fish", 1),
                                common(130, ITEM_DATA_CRYSTAL, 0, "gem", 1)})}
        });
        Write("menu/cfg7/wepdat.cfg.json", "weapons",
              {
                  {"count",   1                                     },
                  {"weapons",
                   Json::array({{{"durability", 36},
                                 {"levelup_exp", 32},
                                 {"status", {8, 10}},
                                 {"status_max", {20, 19}},
                                 {"attribute", {1, 2, 3, 4, 5, 6, 7, 8}},
                                 {"attribute_max", {9, 9, 9, 9, 9, 9, 9, 9}},
                                 {"special",
                                  {{"initial_fusion_point", 2.75}, {"pallet_color", 1}, {"unk_47", 2}, {"fusion_point", 3}, {"special", 0x40}}},
                                 {"buildup_weapon", {12, 13, 14}},
                                 {"buildup_monster", {-1, 5, -1}}}})}
        });
        Write("menu/cfg7/itemdat.cfg.json", "items",
              {
                  {"count", 1                                                                                                                      },
                  {"items",
                   Json::array(
                       {{{"item_no", 172}, {"use_flags", ITEM_USE_FLAG_CURE_ALL}, {"action_flags", 2}, {"target_flags", 3}, {"value", {4, 5, 6}}}})}
        });
        Write("menu/cfg7/atdat.cfg.json", "attachments",
              {
                  {"count",       1                                                                                                  },
                  {"attachments", Json::array({{{"status", {17, 23}}, {"attribute", {1, 2, 3, 4, 5, 6, 7, 8}}, {"special", 0x1234}}})}
        });
        Write("menu/cfg7/robodat.cfg.json", "ridepod_parts",
              {
                  {"count", 1                       },
                  {"parts",
                   Json::array({{{"item_no", 250},
                                 {"type", 1},
                                 {"use_capacity", 2},
                                 {"offset_no", 3},
                                 {"durability", 10},
                                 {"attack", 11},
                                 {"durable", 12},
                                 {"attribute", {1, 2, 3, 4, 5, 6, 7, 8}},
                                 {"attack_type", 9},
                                 {"label", "arm"}}})}
        });
        Write("menu/cfg7/fishdat.cfg.json", "fish",
              {
                  {"count", 1                     },
                  {"fish",
                   Json::array({{{"item_no", 300},
                                 {"size", 1450},
                                 {"unk_4", 54},
                                 {"battle", 6},
                                 {"boost", 12},
                                 {"endurance", 8},
                                 {"tenacity", 8},
                                 {"stamina", 7}}})}
        });
        Write("menu/cfg7/grddat.cfg.json", "guards",
              {
                  {"count",  1                                             },
                  {"guards", Json::array({{{"item_no", 11}, {"value", 3}}})}
        });
    }
};

} // namespace

TEST_F(NativeGame, RidepodCharacterSoundUsesConvertedArmAsset) {
    WriteItemTables();
    Index();
    GameItemDataManage.LoadData();
    auto user = std::make_unique<CUserDataManager>();
    user->robo_data.parts[ROBO_PART_ARM].item_no = 250;
    user->robo_data.parts[ROBO_PART_ARM].item_type = ITEM_DATA_ROBO_ARM;
    EXPECT_EQ(dc2::character::SoundAssetPath(user.get(), USER_CHARA_ROBO), "snd2/chara/CH_042.sound.json");
}

TEST_F(NativeGame, OwnedItemPathsStayValidAfterAnotherLookup) {
    WriteItemTables();
    Index();
    GameItemDataManage.LoadData();
    EXPECT_EQ(GameItemDataManage.GetDataTypeStartListNo(ITEM_DATA_MAX_MELEE), 11);
    EXPECT_EQ(GameItemDataManage.GetDataTypeStartListNo(ITEM_DATA_CRYSTAL), 130);
    EXPECT_EQ(GameItemDataManage.GetDataTypeStartListNo(-1), 0);
    const auto first = ItemFilePath(11, 0);
    const auto second = ItemFilePath(172, 0);
    ASSERT_TRUE(first);
    ASSERT_TRUE(second);
    EXPECT_EQ(*first, "mainchr/dagger.gltf");
    EXPECT_EQ(*second, "item/bread.gltf");
    EXPECT_EQ(*first, "mainchr/dagger.gltf");
    EXPECT_FALSE(ItemFilePath(-1, 0));

    auto user = std::make_unique<CUserDataManager>();
    user->chara_data[USER_CHARA_MAX].equip[0].item_no = 11;
    user->chara_data[USER_CHARA_MAX].equip[1].item_no = 172;
    const auto first_equip = user->CharaEquipDataPath(USER_CHARA_MAX, 0);
    const auto second_equip = user->CharaEquipDataPath(USER_CHARA_MAX, 1);
    ASSERT_TRUE(first_equip);
    ASSERT_TRUE(second_equip);
    EXPECT_EQ(*first_equip, "mainchr/dagger.gltf");
    EXPECT_EQ(*second_equip, "item/bread.gltf");
    EXPECT_EQ(*first_equip, "mainchr/dagger.gltf");
    EXPECT_FALSE(user->CharaEquipDataPath(USER_CHARA_MAX, -1));
    EXPECT_FALSE(user->CharaEquipDataPath(USER_CHARA_ROBO, 4));
}

TEST_F(NativeGame, OwnedCharacterAndRidepodNamesStayValid) {
    ScopedGameSave save;
    WriteItemTables();
    Index();
    GameItemDataManage.LoadData();

    const auto first_model = MainCharaModelName(USER_CHARA_MAX, 0);
    const auto second_model = MainCharaModelName(USER_CHARA_MONICA, 1);
    ASSERT_TRUE(first_model);
    ASSERT_TRUE(second_model);
    EXPECT_EQ(*first_model, "c01_base2.gltf");
    EXPECT_EQ(*second_model, "c02_base.gltf");
    EXPECT_EQ(*first_model, "c01_base2.gltf");
    EXPECT_FALSE(MainCharaModelName(USER_CHARA_ROBO, 0));

    auto &arm = save.active->user_data.robo_data.parts[ROBO_PART_ARM];
    arm.item_no = 250;
    arm.item_type = ITEM_DATA_ROBO_ARM;
    const auto joint = arm.RoboJointName();
    const auto sound = arm.RoboSoundFileName();
    ASSERT_TRUE(joint);
    ASSERT_TRUE(sound);
    EXPECT_EQ(*joint, "body3");
    EXPECT_EQ(*sound, "CH_042");
    EXPECT_EQ(*joint, "body3");
}

TEST_F(NativeGame, RidepodPartNamesAndHatPathKeepOwnedStorageAndValidateBodyType) {
    ScopedGameSave save;
    WriteItemTables();
    Index();
    GameItemDataManage.LoadData();
    auto user = std::make_unique<CUserDataManager>();
    user->robo_data.parts[ROBO_PART_BODY].item_no = 250;
    user->chara_data[USER_CHARA_MAX].equip[CHARA_EQUIP_HEAD].item_no = 11;

    CDataRoboPart *body = GetRoboPartInfoData(250);
    ASSERT_NE(body, nullptr);
    const int previous_offset = body->offset_no;
    body->offset_no = 0;
    ROBO_INFO_DATA *parts = GetRoboPartsInfo(user.get());
    ASSERT_NE(parts, nullptr);
    EXPECT_EQ(parts->arm_name, nullptr);
    EXPECT_STREQ(parts->model_name[ROBO_MODEL_BODY], "arm");
    ASSERT_NE(parts->hat_file, nullptr);
    EXPECT_STREQ(parts->hat_file, "mainchr/dagger.gltf");

    const auto other_path = ItemFilePath(172, 0);
    EXPECT_EQ(other_path, "item/bread.gltf");
    EXPECT_STREQ(parts->hat_file, "mainchr/dagger.gltf");
    body->offset_no = 99;
    parts = GetRoboPartsInfo(user.get());
    EXPECT_EQ(parts->arm_name, nullptr);
    body->offset_no = previous_offset;
}

TEST_F(NativeGame, ItemTablesFillEveryRecordFamilyAndTheItemLookup) {
    WriteItemTables();
    Index();
    GameItemDataManage.LoadData();

    EXPECT_EQ(GameItemDataManage.common_num, 5);
    EXPECT_EQ(GameItemDataManage.max_item_no, 300);
    const CDataCommon *dagger = GameItemDataManage.GetCommonData(11);
    ASSERT_NE(dagger, nullptr);
    EXPECT_STREQ(dagger->file_name, "dagger");
    // A weapon's owned count is limited to 0x90 when the record asks for more than 100.
    EXPECT_EQ(dagger->max_num, 0x90);
    EXPECT_EQ(dagger->attribute, 7u);
    EXPECT_EQ(GameItemDataManage.GetCommonData(172)->max_num, 9);

    const CDataWeapon *weapon = GameItemDataManage.GetWeaponData(11);
    ASSERT_NE(weapon, nullptr);
    EXPECT_EQ(weapon->durability, 36);
    EXPECT_EQ(weapon->status_max[1], 19);
    EXPECT_EQ(weapon->attribute[7], 8);
    EXPECT_EQ(weapon->initial_fusion_point, 2);
    EXPECT_EQ(weapon->special, 0x40u);
    EXPECT_EQ(weapon->attack_type, 0);
    EXPECT_EQ(weapon->buildup_weapon[2], 14);
    EXPECT_EQ(weapon->buildup_monster[1], 5);

    const CDataItem *item = GameItemDataManage.GetItemData(172);
    ASSERT_NE(item, nullptr);
    EXPECT_EQ(item->use_flags, static_cast<u32>(ITEM_USE_FLAG_CURE_STOP | ITEM_USE_FLAG_CURE_POISON | ITEM_USE_FLAG_CURE_CURSE |
                                                ITEM_USE_FLAG_CURE_SLOW | ITEM_USE_FLAG_CURE_STONE | ITEM_USE_FLAG_CURE_DRY));
    EXPECT_EQ(item->value[2], 6);

    EXPECT_EQ(GameItemDataManage.attach_num, 1);
    EXPECT_EQ(GameItemDataManage.attach_data[0].status[1], 23);
    EXPECT_EQ(GameItemDataManage.attach_data[0].special, 0x1234u);

    const CDataRoboPart *part = GameItemDataManage.GetRoboData(250);
    ASSERT_NE(part, nullptr);
    EXPECT_EQ(part->offset_no, 3);
    EXPECT_EQ(part->attack, 11);
    EXPECT_EQ(part->attribute[0], 1);
    EXPECT_EQ(part->attack_type, 9);

    const CDataBreedFish *fish = GameItemDataManage.GetFishData(300);
    ASSERT_NE(fish, nullptr);
    EXPECT_FLOAT_EQ(fish->size, 1450.0f);
    EXPECT_EQ(fish->boost, 12);
    EXPECT_EQ(fish->stamina, 7);

    const s16 *guard = GameItemDataManage.GetGuardData(11);
    ASSERT_NE(guard, nullptr);
    EXPECT_EQ(*guard, 3);
}

TEST_F(NativeGame, ItemTableOfAnotherKindOrCommandListIsRefused) {
    Write("menu/cfg7/comdat.cfg.json", "map_names", {
                                                        {"count", 0            },
                                                        {"maps",  Json::array()}
    });
    std::ofstream(directory / "data/menu/cfg7/wepdat.cfg.json") << R"({"schema_version":1,"commands":[]})";
    Index();
    char common[] = "comdat.cfg";
    char weapons[] = "wepdat.cfg";
    CaptureLoggedStderr();
    EXPECT_EQ(LoadGameDataAnalyze(common), 0);
    EXPECT_EQ(LoadGameDataAnalyze(weapons), 0);
    const auto diagnostics = GetLoggedStderr();
    EXPECT_NE(diagnostics.find("item table"), std::string::npos) << diagnostics;
    EXPECT_NE(diagnostics.find("no longer read"), std::string::npos) << diagnostics;
}

TEST_F(NativeGame, GameSetupPerformsItsActionsInOrder) {
    ScopedGameSave restore;
    Write("dbg/game0.cfg.json", "game_setup",
          {
              {"actions",
               Json::array({{{"action", "progress"}, {"value", 4}},
                            {{"action", "progress"}, {"value", 7}},
                            {{"action", "start_event"}, {"event", 123}},
                            {{"action", "map"}, {"map", 12}},
                            {{"action", "param_draw"}, {"show", 0}},
                            {{"action", "georama_debug"}},
                            {{"action", "option"}, {"name", "EnemyHP"}, {"value", 2}},
                            {{"action", "option"}, {"name", "Unknown"}, {"value", 9}},
                            {{"action", "bit_flags_on"}, {"flags", {3, 5}}},
                            {{"action", "bit_flags_off"}, {"flags", {5}}}})}
    });
    Index();
    char directory_name[] = "dbg/";
    SetCurrentDir(directory_name);
    DefStartEventNo = 0;
    DebugInfo.param_off = 0;
    DebugInfo.georama_debug = 0;
    char path[] = "game0.cfg.json";
    LoadGameConfig(path);
    EXPECT_EQ(GetSaveData()->game_progress, 7);
    EXPECT_EQ(DefStartEventNo, 123);
    EXPECT_EQ(SelectArg[LOOP_EDIT], 12);
    EXPECT_NE(DebugInfo.param_off, 0);
    EXPECT_NE(DebugInfo.georama_debug, 0);
    EXPECT_EQ(GetSaveData()->config.enemy_hp, 2);
    EXPECT_NE(GetSaveData()->GetBitFlag(3), 0);
    EXPECT_EQ(GetSaveData()->GetBitFlag(5), 0);
    // An explicit configuration keeps the caller's directory.
    EXPECT_EQ(GetCurrentDir(), directory_name);
}

TEST_F(NativeGame, AbsentRootGameConfigIsSilentAndClearsTheDirectory) {
    ScopedGameSave restore;
    GetSaveData()->game_progress = 1;
    Index();
    char directory_name[] = "dbg/";
    SetCurrentDir(directory_name);
    CaptureLoggedStderr();
    LoadGameConfig(nullptr);
    const auto diagnostic = GetLoggedStderr();
    EXPECT_TRUE(diagnostic.empty()) << diagnostic;
    EXPECT_EQ(GetSaveData()->game_progress, 1);
    EXPECT_TRUE(GetCurrentDir().empty());
}

TEST_F(NativeGame, RootGameConfigLoadsFromTheRootDirectory) {
    ScopedGameSave restore;
    Write("game.cfg.json", "game_setup", {
                                             {"actions", Json::array({{{"action", "progress"}, {"value", 4}}})}
    });
    Write("dbg/game.cfg.json", "game_setup", {
                                                 {"actions", Json::array({{{"action", "progress"}, {"value", 99}}})}
    });
    Index();
    char directory_name[] = "dbg/";
    SetCurrentDir(directory_name);
    LoadGameConfig(nullptr);
    EXPECT_EQ(GetSaveData()->game_progress, 4);
}

TEST_F(NativeGame, MapNamesFillTheTableAndMapActionsFindThemByName) {
    Write("map/map1.cfg.json", "map_names",
          {
              {"count", 2                                                                                                 },
              {"maps",
               Json::array({{{"name", "g01"}, {"title", "Sindain"}, {"add_path", ""}, {"type", 1}, {"sel_type", 1}, {"snd_data_id", 2000}, {"area_no", 2}},
                            {{"name", "s71"}, {"title", "Stop"}, {"add_path", "trn2/s36"}, {"type", 3}, {"sel_type", 6}}})}
    });
    Write("dbg/game1.cfg.json", "game_setup", {
                                                  {"actions", Json::array({{{"action", "map"}, {"map", "s71"}}})}
    });
    Index();
    LoadMapName(1, nullptr);
    char *title = nullptr;
    ASSERT_STREQ(GetMapName(0, &title), "g01");
    EXPECT_STREQ(title, "Sindain");
    EXPECT_STREQ(GetMapName(1, &title), "s71");
    EXPECT_STREQ(title, "Stop");
    EXPECT_EQ(GetMapType(1), 3);

    ScopedGameSave restore;
    char           path[] = "dbg/game1.cfg.json";
    LoadGameConfig(path);
    EXPECT_EQ(SelectArg[LOOP_EDIT], 1);
}

TEST_F(NativeGame, OversizedMapNameTableIsRefused) {
    Write("map/map1.cfg.json", "map_names", {
                                                {"count", 100000       },
                                                {"maps",  Json::array()}
    });
    Index();
    CaptureLoggedStderr();
    LoadMapName(1, nullptr);
    const auto diagnostic = GetLoggedStderr();
    EXPECT_NE(diagnostic.find("map name buffer"), std::string::npos) << diagnostic;
    // With no table loaded, a map has no entry: its title is null and its name the selection fallback.
    char *title = nullptr;
    GetMapName(0, &title);
    EXPECT_EQ(title, nullptr);
}

TEST_F(NativeGame, MovieListGivesTitlesFilesAndDefaultMusic) {
    Write("mv.cfg.json", "movie_list",
          {
              {"movies", Json::array({{{"title", "Opening"}, {"file", "open.mp4"}, {"bgm", 3}}, {{"title", "Ending"}, {"file", "end.mp4"}}})}
    });
    Index();
    const PortMovieEntry *movies = nullptr;
    ASSERT_EQ(PortReadMovieList(&movies), 2);
    EXPECT_STREQ(movies[0].title, "Opening");
    EXPECT_STREQ(movies[0].file, "open.mp4");
    EXPECT_EQ(movies[0].bgm_no, 3);
    EXPECT_STREQ(movies[1].file, "end.mp4");
    EXPECT_EQ(movies[1].bgm_no, -1);
}
