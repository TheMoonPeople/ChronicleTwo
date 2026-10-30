#include "common.h"

#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <algorithm>
#include <array>
#include <chrono>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <limits>
#include <span>
#include <string>
#include <vector>

#include "assets/data_registry.hpp"
#include "dataread.hpp"
#include "event.hpp"
#include "event_background.hpp"
#include "event_func.hpp"
#include "gyorace.hpp"
#include "luau_runtime.hpp"
#include "mainloop.hpp"
#include "mapjump.hpp"
#include "mapselect.hpp"
#include "menucommon.hpp"
#include "mg_memory.hpp"
#include "native_script_program.hpp"
#include "nd_meswin.hpp"
#include "platform/arena.hpp"
#include "platform/datapacks.hpp"
#include "platform/paths.hpp"
#include "runscript.hpp"
#include "scenesnd.hpp"
#include "scoped_global_object.hpp"

namespace {
/**
 * Supplies direct localized texture and command documents in standalone and event directories.
 */
class EventAssetPaths : public testing::Test {
protected:
    std::filesystem::path root = std::filesystem::temp_directory_path() / ("event_asset_paths_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
    std::filesystem::path previous_root = PathsDataRoot();
    int                   language = LanguageCode;
    int                   pack_loaded = EdEventInfo.pack_loaded;
    int                   stream_reading = EdEventInfo.stream_reading;
    u_long128            *buffer = read_buffer;
    std::string           previous_directory;
    alignas(16) std::array<u_long128, 128> marker{};
    mgCMemory  marker_owner;
    u_long128 *marker_storage = nullptr;

    void BindMarker() {
        BindReadBuffer(std::span<u8>(reinterpret_cast<u8 *>(marker_storage), sizeof marker), marker_owner);
        ASSERT_FALSE(ReadBufferBytes().empty());
    }

    void SetUp() override {
        previous_directory = GetCurrentDir();
        std::filesystem::create_directories(root / "data");
        const nlohmann::json texture = {
            {"schema_version", 3                      },
            {"groups",         {0}                    },
            {"entries",        nlohmann::json::array()}
        };
        const nlohmann::json config = {
            {"schema_version", 1                      },
            {"commands",       nlohmann::json::array()}
        };
        for (const auto *directory : {"event/ui", "event/assets"}) {
            for (int number : {1, 2}) {
                Write("textures/" + std::string(directory) + "/poster_" + std::to_string(number) + ".json", texture);
                Write(std::string(directory) + "/config_" + std::to_string(number) + ".json", config);
            }
        }
        Write("event/assets/pack.json", {
                                            {"schema_version",  1                                                                                                                                                                   },
                                            {"kind",            "asset_directory"                                                                                                                                                   },
                                            {"texture_members", nlohmann::json::array({{{"name", "poster_1.json"}, {"path", "textures/event/assets/poster_1.json"}},
                                                                                       {{"name", "poster_2.json"}, {"path", "textures/event/assets/poster_2.json"}}})}
        });
        DataReadIndex(root / "data");
        SetCurrentDir(nullptr);
        LanguageCode = LANG_FRENCH;
        EdEventInfo.pack_loaded = false;
        EdEventInfo.stream_reading = false;
        marker_owner.stSetBuffer(marker.data(), static_cast<int>(marker.size()));
        marker_storage = marker_owner.stAlloc(static_cast<int>(marker.size()));
        ASSERT_NE(marker_storage, nullptr);
        read_buffer = nullptr;
    }

    void TearDown() override {
        dc2::event::ResetReadFiles();
        _SET_LOADBG_FILE(dc2::script::RunArguments({}), 0);
        LanguageCode = language;
        EdEventInfo.pack_loaded = pack_loaded;
        EdEventInfo.stream_reading = stream_reading;
        BindReadBuffer({}, marker_owner);
        read_buffer = buffer;
        DataReadIndex(previous_root);
        SetCurrentDir(previous_directory.data());
        std::error_code error;
        std::filesystem::remove_all(root, error);
    }

    void Write(const std::string &name, const nlohmann::json &document) {
        const auto path = root / "data" / name;
        std::filesystem::create_directories(path.parent_path());
        std::ofstream(path) << document.dump(2);
    }

    static std::string GltfFile(const std::filesystem::path &path, std::size_t size) {
        std::filesystem::create_directories(path.parent_path());
        std::string bytes = R"({"asset":{"version":"2.0","generator":"event buffer fixture"}})";
        bytes.resize(size, ' ');
        std::ofstream(path, std::ios::binary).write(bytes.data(), static_cast<std::streamsize>(bytes.size()));
        return bytes;
    }
};
} // namespace

TEST_F(EventAssetPaths, LocalizesTextureJsonThroughCurrentDirectoryWithoutLocalizingConfig) {
    char directory[] = "textures/event/ui/";
    SetCurrentDir(directory);
    char texture[64] = "poster_1.json";
    char config[64] = "event/ui/config_1.json";
    FileNameConvLanguage(texture);
    FileNameConvLanguage(config);
    EXPECT_STREQ(texture, "poster_2.json");
    EXPECT_STREQ(config, "event/ui/config_1.json");
    char script[64] = "scene_1.stb";
    char text[64] = "message_1.txt";
    FileNameConvLanguage(script);
    FileNameConvLanguage(text);
    EXPECT_STREQ(script, "scene_2.stb");
    EXPECT_STREQ(text, "message_2.txt");
}

TEST_F(EventAssetPaths, LocalizesTextureJsonInsideLoadedEventDirectory) {
    ASSERT_TRUE(dc2::event::LoadPack("event/assets"));
    EdEventInfo.pack_loaded = true;
    char texture[64] = "poster_1.json";
    char config[64] = "config_1.json";
    FileNameConvLanguage(texture);
    FileNameConvLanguage(config);
    EXPECT_STREQ(texture, "poster_2.json");
    EXPECT_STREQ(config, "config_1.json");
}

TEST_F(EventAssetPaths, KeepsEnglishAndUnrecognizedJsonNames) {
    LanguageCode = LANG_ENGLISH;
    char texture[64] = "textures/event/ui/poster_1.json";
    FileNameConvLanguage(texture);
    EXPECT_STREQ(texture, "textures/event/ui/poster_1.json");
    LanguageCode = LANG_FRENCH;
    char unknown[64] = "missing_1.json";
    FileNameConvLanguage(unknown);
    EXPECT_STREQ(unknown, "missing_1.json");
}

TEST(EventScriptMapName, RejectsMissingOrOversizedMapComponentBeforeRequestingLoad) {
    CRunScript script;
    SetEventFunc(&script);
    const auto load_script = script.ext_func_table[EVENT_EXT_LOAD_SCRIPT];
    ASSERT_NE(load_script, nullptr);

    const auto                                       previous_request = EdEventInfo.request;
    const auto                                       previous_language = LanguageCode;
    std::array<char, sizeof EdEventInfo.script_name> previous_name{};
    std::memcpy(previous_name.data(), EdEventInfo.script_name, previous_name.size());
    LanguageCode = LANG_ENGLISH;
    EdEventInfo.request = EVENT_REQUEST_NONE;

    std::array<RS_STACKDATA, 2> arguments{};
    arguments[0].type = RS_STR;
    arguments[1].type = RS_INT;
    arguments[1].val.i = 1;
    auto request = [&](std::string &path) {
        arguments[0].val.s = path.data();
        return InvokeNativeExternal(load_script, arguments, {}, std::span(path.data(), path.size() + 1));
    };

    std::string missing_slash = "scene_1.stb";
    EXPECT_FALSE(request(missing_slash));
    EXPECT_EQ(EdEventInfo.request, EVENT_REQUEST_NONE);
    std::string oversized_map = std::string(32, 'a') + "/scene_1.stb";
    EXPECT_FALSE(request(oversized_map));
    EXPECT_EQ(EdEventInfo.request, EVENT_REQUEST_NONE);
    std::string maximum_map = std::string(31, 'a') + "/scene_1.stb";
    EXPECT_TRUE(request(maximum_map));
    EXPECT_EQ(EdEventInfo.request, EVENT_REQUEST_LOAD_SCRIPT);

    EdEventInfo.request = previous_request;
    LanguageCode = previous_language;
    std::memcpy(EdEventInfo.script_name, previous_name.data(), previous_name.size());
}

TEST(EventScriptCaption, RejectsTextThatDoesNotFitTheStoredCaption) {
    CRunScript script;
    SetEventFunc(&script);
    const auto set_caption = script.ext_func_table[EVENT_EXT_SET_MOVIE_CC];
    ASSERT_NE(set_caption, nullptr);

    const auto                                           previous_start = EdEventInfo.caption_start[0];
    const auto                                           previous_frames = EdEventInfo.caption_frames[0];
    std::array<char, sizeof EdEventInfo.caption_text[0]> previous_text{};
    std::memcpy(previous_text.data(), EdEventInfo.caption_text[0], previous_text.size());
    std::array<RS_STACKDATA, 5> arguments{};
    arguments[0].type = RS_INT;
    arguments[0].val.i = EVENT_CAPTION_SET;
    arguments[1].type = RS_INT;
    arguments[1].val.i = 0;
    arguments[2].type = RS_INT;
    arguments[2].val.i = 0;
    arguments[3].type = RS_STR;
    arguments[4].type = RS_INT;
    arguments[4].val.i = 60;

    std::string oversized(sizeof EdEventInfo.caption_text[0], 'a');
    arguments[3].val.s = oversized.data();
    EXPECT_FALSE(InvokeNativeExternal(set_caption, arguments, {}, std::span(oversized.data(), oversized.size() + 1)));
    EXPECT_EQ(EdEventInfo.caption_start[0], previous_start);
    EXPECT_EQ(EdEventInfo.caption_frames[0], previous_frames);
    EXPECT_EQ(std::memcmp(EdEventInfo.caption_text[0], previous_text.data(), previous_text.size()), 0);

    std::string maximum(oversized.size() - 1, 'b');
    arguments[3].val.s = maximum.data();
    EXPECT_TRUE(InvokeNativeExternal(set_caption, arguments, {}, std::span(maximum.data(), maximum.size() + 1)));
    EXPECT_STREQ(EdEventInfo.caption_text[0], maximum.c_str());

    EdEventInfo.caption_start[0] = previous_start;
    EdEventInfo.caption_frames[0] = previous_frames;
    std::memcpy(EdEventInfo.caption_text[0], previous_text.data(), previous_text.size());
}

TEST(EventScriptFishRace, ValidatesPlaceAndMessageSlotBeforeReadingResult) {
    CRunScript script;
    SetEventFunc(&script);
    const auto set_race = script.ext_func_table[EVENT_EXT_SET_GYORACE_ETC];
    ASSERT_NE(set_race, nullptr);

    CScene scene;
    ClsMes message;
    scene.message_num = 1;
    scene.message[0].status = 1;
    scene.message[0].mes = &message;
    CScene *previous_scene = EventScene;
    EventScene = &scene;
    const GYORACE_RESULT previous_result = fish_game_data[0];
    std::memset(fish_game_data[0].name, 'a', sizeof fish_game_data[0].name);
    message.name[0][0] = '\0';

    std::array<RS_STACKDATA, 4> arguments{};
    for (auto &argument : arguments) {
        argument.type = RS_INT;
    }
    arguments[0].val.i = EVENT_SET_GYORACE_FISH_NAME;
    arguments[1].val.i = 0;
    auto request = [&](int name_no, int result_no) {
        arguments[2].val.i = name_no;
        arguments[3].val.i = result_no;
        return InvokeNativeExternal(set_race, arguments);
    };
    EXPECT_FALSE(request(0, 0));
    EXPECT_FALSE(request(MES_NAME_MAX + 1, 0));
    EXPECT_FALSE(request(1, -1));
    EXPECT_FALSE(request(1, GR_FISH_MAX));
    EXPECT_EQ(message.name[0][0], '\0');
    EXPECT_TRUE(request(1, 0));
    EXPECT_EQ(std::strlen(message.name[0]), sizeof fish_game_data[0].name);

    arguments[0].val.i = EVENT_SET_GYORACE_FISH_TIME;
    fish_game_data[0].time = std::numeric_limits<float>::infinity();
    EXPECT_TRUE(request(1, 0));
    EXPECT_EQ(std::strlen(message.name[0]), 16);
    const unsigned char expected_time[] = {0x82, 0x4f, 0x82, 0x4f, 0x81, 0x46, 0x82, 0x4f,
                                           0x82, 0x4f, 0x81, 0x46, 0x82, 0x4f, 0x82, 0x4f};
    EXPECT_EQ(std::memcmp(message.name[0], expected_time, sizeof expected_time), 0);
    fish_game_data[0].time = std::numeric_limits<float>::quiet_NaN();
    EXPECT_TRUE(request(1, 0));
    EXPECT_EQ(std::strlen(message.name[0]), 16);

    fish_game_data[0] = previous_result;
    EventScene = previous_scene;
}

TEST(EventScriptMessageName, RejectsInvalidSlotsAndOversizedText) {
    CRunScript script;
    SetEventFunc(&script);
    const auto set_name = script.ext_func_table[EVENT_EXT_SET_MES_STR];
    ASSERT_NE(set_name, nullptr);

    CScene scene;
    ClsMes message;
    scene.message_num = 1;
    scene.message[0].status = 1;
    scene.message[0].mes = &message;
    CScene *previous_scene = EventScene;
    EventScene = &scene;

    std::array<RS_STACKDATA, 3> arguments{};
    arguments[0].type = RS_INT;
    arguments[0].val.i = 0;
    arguments[1].type = RS_INT;
    arguments[2].type = RS_STR;
    std::string oversized(MES_NAME_LEN, 'x');
    arguments[2].val.s = oversized.data();
    auto request = [&](int slot, std::string &text) {
        arguments[2].val.s = text.data();
        arguments[1].val.i = slot;
        return InvokeNativeExternal(set_name, arguments, {}, std::span(text.data(), text.size() + 1));
    };

    message.name[0][0] = '\0';
    EXPECT_FALSE(request(0, oversized));
    EXPECT_FALSE(request(MES_NAME_MAX + 1, oversized));
    EXPECT_FALSE(request(1, oversized));
    EXPECT_EQ(message.name[0][0], '\0');

    std::string maximum(MES_NAME_LEN - 1, 'y');
    arguments[2].val.s = maximum.data();
    EXPECT_TRUE(request(1, maximum));
    EXPECT_STREQ(message.name[0], maximum.c_str());
    EventScene = previous_scene;
}

TEST_F(EventAssetPaths, NpcTalkLoadDoesNotWritePastRemainingArena) {
    const auto path = root / "data/event/talk/npc_talk_c2_2.txt";
    std::filesystem::create_directories(path.parent_path());
    std::ofstream(path) << "talk";
    DataReadIndex(root / "data");

    mgCMemory                             memory;
    alignas(16) std::array<u_long128, 64> storage{};
    memory.stack = storage.data();
    memory.stack_size = static_cast<int>(storage.size());
    memory.stack_used = 0;
    EXPECT_EQ(LoadNpcTalkMes(&memory), 0);
    EXPECT_EQ(memory.stack_used, 0);
}

TEST(EventMapJump, ReadsOnlyTheDeclaredMapNameField) {
    CRunScript script;
    SetEventFunc(&script);
    const auto map_jump = script.ext_func_table[EVENT_EXT_FUNCTION_MAP_JUMP];
    ASSERT_NE(map_jump, nullptr);

    CScene  scene;
    CScene *previous_scene = EventScene;
    EventScene = &scene;
    scene.event_data.event.flag = 0x10A;
    const auto                                         previous_request = EdEventInfo.request;
    const auto                                         previous_event_no = EdEventInfo.event_no;
    const auto                                         previous_jump_point = EdEventInfo.jump_point;
    std::array<char, sizeof EdEventInfo.jump_map_name> previous_name{};
    std::memcpy(previous_name.data(), EdEventInfo.jump_map_name, previous_name.size());
    EdEventInfo.request = EVENT_REQUEST_NONE;

    std::memset(scene.event_data.event.target, 'x', sizeof scene.event_data.event.target);
    EXPECT_FALSE(InvokeNativeExternal(map_jump, {}));
    EXPECT_EQ(EdEventInfo.request, EVENT_REQUEST_NONE);

    std::memset(scene.event_data.event.target, 'm', sizeof scene.event_data.event.target);
    scene.event_data.position[0] = 123.0f;
    EXPECT_FALSE(InvokeNativeExternal(map_jump, {}));
    EXPECT_EQ(EdEventInfo.request, EVENT_REQUEST_NONE);

    scene.event_data.event.target[sizeof scene.event_data.event.target - 1] = char{};
    EXPECT_TRUE(InvokeNativeExternal(map_jump, {}));
    EXPECT_EQ(EdEventInfo.request, EVENT_REQUEST_INTERIOR);
    EXPECT_FLOAT_EQ(scene.event_data.position[0], 123.0f);
    EdEventInfo.request = EVENT_REQUEST_NONE;

    std::memcpy(scene.event_data.event.target, "exit", 5);
    EXPECT_TRUE(InvokeNativeExternal(map_jump, {}));
    EXPECT_EQ(EdEventInfo.request, EVENT_REQUEST_OUTSIDE);

    EdEventInfo.request = previous_request;
    EdEventInfo.event_no = previous_event_no;
    EdEventInfo.jump_point = previous_jump_point;
    std::memcpy(EdEventInfo.jump_map_name, previous_name.data(), previous_name.size());
    EventScene = previous_scene;
}

TEST_F(EventAssetPaths, MenuLoaderProducesPhysicalTexturePathsAndRetainsOtherResources) {
    Write("textures/menu/2/chap0.json", {
                                            {"test", "french"}
    });
    Write("textures/menu/1/chap0.json", {
                                            {"test", "english"}
    });
    Write("menu/2/help.cfg.json", {
                                      {"test", "commands"}
    });
    DataReadIndex(root / "data");
    char texture[] = "textures/chap0.json";
    char commands[] = "help.cfg.json";
    ASSERT_GT(LoadFileMenu(texture, std::span(reinterpret_cast<u8 *>(marker_storage), sizeof marker), MENU_FILE_LOAD_DIRECT), 0);
    EXPECT_EQ(DataReadBufferPath(marker_storage), "textures/menu/2/chap0.json");
    ASSERT_GT(LoadFileMenu(commands, std::span(reinterpret_cast<u8 *>(marker_storage), sizeof marker), MENU_FILE_LOAD_DIRECT), 0);
    EXPECT_EQ(DataReadBufferPath(marker_storage), "menu/2/help.cfg.json");
    std::array<u8, 1> short_buffer{0x7b};
    EXPECT_LE(LoadFileMenu(texture, std::span(short_buffer), MENU_FILE_LOAD_DIRECT), 0);
    EXPECT_EQ(short_buffer[0], 0x7b);
    LanguageCode = LANG_CHINESE;
    ASSERT_GT(LoadFileMenu(texture, std::span(reinterpret_cast<u8 *>(marker_storage), sizeof marker), MENU_FILE_LOAD_DIRECT), 0);
    EXPECT_EQ(DataReadBufferPath(marker_storage), "textures/menu/1/chap0.json");
}

TEST_F(EventAssetPaths, BackgroundCharacterBatchExceedsSceneScratchWithoutWritingIt) {
    // d01b01's e111 event queues these eight models together before constructing its characters.
    const std::array<std::size_t, 8> sizes{403513, 2296979, 1488476, 1136475, 363715, 356350, 16351, 20278};
    std::array<std::string, 8>       names;
    std::array<RS_STACKDATA, 8>      arguments{};
    std::size_t                      total = 0;
    for (std::size_t index = 0; index < names.size(); ++index) {
        names[index] = "model" + std::to_string(index) + ".gltf";
        GltfFile(root / "data/event/ui" / names[index], sizes[index]);
        arguments[index].type = RS_STR;
        arguments[index].val.s = names[index].data();
        total += sizes[index];
    }
    ASSERT_GT(total, 4160000u);
    DataReadIndex(root / "data");
    char directory[] = "event/ui/";
    SetCurrentDir(directory);
    std::memset(marker_storage, 0x5a, sizeof(marker));
    std::array<u_long128, 128> previous{};
    std::memcpy(previous.data(), marker_storage, sizeof marker);
    BindMarker();
    std::array<std::span<const char>, 8> sources;
    for (std::size_t index = 0; index < names.size(); ++index) {
        sources[index] = {names[index].data(), names[index].size() + 1};
    }
    ASSERT_TRUE(_SET_LOADBG_FILE(dc2::script::RunArguments(arguments, {}, {}, sources), static_cast<int>(arguments.size())));
    EXPECT_EQ(std::memcmp(marker_storage, previous.data(), sizeof(marker)), 0);
    EXPECT_EQ(ReadBGSync(), 1);
    // A glTF is read by name: each buffer is one zeroed sector registered with the file's path.
    for (std::size_t index = 0; index < names.size(); ++index) {
        const auto  read = dc2::event::ReadFile(names[index]);
        const int   size = read.Size();
        const auto *buffer = read.Bytes().data();
        ASSERT_NE(buffer, nullptr);
        const auto sector = std::min<std::size_t>(sizes[index], 2048);
        EXPECT_EQ(size, static_cast<int>(sector));
        EXPECT_EQ(DataReadBufferSize(buffer), sector);
        EXPECT_EQ(DataReadBufferPath(buffer), "event/ui/" + names[index]);
        const auto *data = reinterpret_cast<const unsigned char *>(buffer);
        EXPECT_TRUE(std::all_of(data, data + sector, [](unsigned char byte) { return byte == 0; }));
    }
    while (ReadBGSync()) {
    }
    EXPECT_EQ(std::memcmp(marker_storage, previous.data(), sizeof(marker)), 0);
}

TEST_F(EventAssetPaths, OversizedGltfReplacementAndUnqueuedFallbackRegisterTheirNamesInOneZeroedSector) {
    const auto *const path = "event/ui/replacement.gltf";
    GltfFile(root / "data" / path, 128);
    GltfFile(root / "datapacks/large" / path, 5 * 1024 * 1024 + 13);
    GltfFile(root / "data/event/ui/fallback.gltf", 6 * 1024 * 1024 + 7);
    std::ofstream(root / "data/event/ui/next.txt", std::ios::binary).write("replacement.gltf", 17);
    std::ofstream(root / "datapacks/datapacks.json") << R"({"schema_version":1,"load_order":["large"]})";
    DataReadIndex(root / "data");
    char directory[] = "event/ui/";
    SetCurrentDir(directory);
    std::memset(marker_storage, 0x36, sizeof(marker));
    std::array<u_long128, 128> previous{};
    std::memcpy(previous.data(), marker_storage, sizeof marker);
    BindMarker();
    char         name[] = "replacement.gltf";
    RS_STACKDATA argument{};
    argument.type = RS_STR;
    argument.val.s = name;
    ASSERT_TRUE(_SET_LOADBG_FILE(dc2::script::RunArguments(std::span(&argument, 1), std::span(name)), 1));
    const auto zeroed = [](const void *buffer) {
        const auto *bytes = reinterpret_cast<const unsigned char *>(buffer);
        return std::all_of(bytes, bytes + 2048, [](unsigned char byte) { return byte == 0; });
    };
    // The model loader reads the glTF itself, through datapack priority, from the registered name.
    auto        loaded_read = dc2::event::ReadFile(name);
    int         size = loaded_read.Size();
    const auto *loaded = loaded_read.Bytes().data();
    ASSERT_NE(loaded, nullptr);
    EXPECT_EQ(size, 2048);
    EXPECT_EQ(DataReadBufferSize(loaded), 2048u);
    EXPECT_EQ(DataReadBufferPath(loaded), path);
    EXPECT_TRUE(zeroed(loaded));
    char       unqueued[] = "fallback.gltf";
    const auto other_read = dc2::event::ReadFile(unqueued);
    size = other_read.Size();
    const auto *other = other_read.Bytes().data();
    ASSERT_NE(other, nullptr);
    EXPECT_NE(other, loaded);
    EXPECT_EQ(size, 2048);
    EXPECT_EQ(DataReadBufferPath(other), "event/ui/fallback.gltf");
    EXPECT_TRUE(zeroed(other));
    EXPECT_EQ(std::memcmp(marker_storage, previous.data(), sizeof(marker)), 0);
    char       instructions[] = "next.txt";
    const auto instructions_read = dc2::event::ReadFile(instructions);
    argument.val.s = reinterpret_cast<char *>(instructions_read.Bytes().data());
    ASSERT_NE(argument.val.s, nullptr);
    const std::array<std::span<const char>, 1> instruction_sources{{{argument.val.s, DataReadBufferSize(argument.val.s)}}};
    ASSERT_TRUE(_SET_LOADBG_FILE(dc2::script::RunArguments(std::span(&argument, 1), {}, {}, instruction_sources), 1));
    loaded_read = dc2::event::ReadFile(name);
    size = loaded_read.Size();
    loaded = loaded_read.Bytes().data();
    ASSERT_NE(loaded, nullptr);
    EXPECT_EQ(size, 2048);
    EXPECT_EQ(DataReadBufferPath(loaded), path);
}

TEST_F(EventAssetPaths, SmallUnqueuedDocumentsRetainZeroedSectorPadding) {
    char        name[] = "event/ui/config_1.json";
    auto        loaded_read = dc2::event::ReadFile(name);
    int         size = loaded_read.Size();
    const auto *loaded = loaded_read.Bytes().data();
    ASSERT_NE(loaded, nullptr);
    ASSERT_GT(size, 0);
    ASSERT_LT(size, 2048);
    EXPECT_EQ(DataReadBufferSize(loaded), static_cast<std::size_t>(size));
    const auto padding = loaded_read.PaddedBytes().subspan(static_cast<std::size_t>(size), 2048 - static_cast<std::size_t>(size));
    EXPECT_TRUE(std::ranges::all_of(padding, [](unsigned char byte) { return byte == 0; }));
}

TEST_F(EventAssetPaths, EventViewerBoundsRowsAndOwnsLongColumnsWithoutOverwritingEarlierNames) {
    std::filesystem::create_directories(root / "data/event");
    const std::string long_name(4096, 'n');
    {
        std::ofstream file(root / "data/event/view_pal.txt");
        file << "header\n";
        for (int index = 0; index <= EVENT_VIEW_MAX; ++index) {
            file << "map\t1\t0\t" << index + 1 << "\t\t\t" << (index == 0 ? long_name : "name") << "\tdetail\tB\n";
        }
    }
    DataReadIndex(root / "data");
    std::vector<u_long128> input(4096);
    std::vector<u_long128> output(8192);
    mgCMemory              memory;
    memory.stSetBuffer(output.data(), static_cast<int>(output.size()));
    LoadEventViewData(std::span(reinterpret_cast<u8 *>(input.data()), input.size() * sizeof(u_long128)), &memory);
    const auto entries = dc2::debug::EventViewEntries();
    ASSERT_EQ(entries.size(), EVENT_VIEW_MAX);
    EXPECT_EQ(std::string(entries.front().name), long_name);
    EXPECT_EQ(entries.back().event_no, EVENT_VIEW_MAX);
    memory.stReset();
    EXPECT_TRUE(dc2::debug::EventViewEntries().empty());
    EventInfo = nullptr;
}

TEST_F(EventAssetPaths, EventViewerRejectsExtraColumnsAndAcceptsAnExactFinalLineWithoutATerminator) {
    std::filesystem::create_directories(root / "data/event");
    {
        std::ofstream file(root / "data/event/view_pal.txt");
        file << "header\n";
        file << "bad\t1\t0\t99\t\t\tname\tdetail\tB";
        for (int index = 0; index < 16; ++index) {
            file << "\tbad";
        }
        file << "\nmap\t1\t0\t42\t\t\tname\tdetail\tB";
    }
    DataReadIndex(root / "data");
    std::vector<u_long128> input(256);
    std::vector<u_long128> output(4096);
    mgCMemory              memory;
    memory.stSetBuffer(output.data(), static_cast<int>(output.size()));
    LoadEventViewData(std::span(reinterpret_cast<u8 *>(input.data()), input.size() * sizeof(u_long128)), &memory);
    const auto entries = dc2::debug::EventViewEntries();
    ASSERT_EQ(entries.size(), 1);
    EXPECT_EQ(entries.front().event_no, 42);
    EXPECT_STREQ(entries.front().name, "name");
    EXPECT_STREQ(entries.front().detail, "detail");
    memory.stReset();
    EventInfo = nullptr;
}

TEST(SceneEvent, CopiesEveryCanonicalFieldWithoutReadingAnInactiveOverlay) {
    CScene scene;
    scene.event_run = 0;
    scene.event_no = 0;
    CSceneEventData source;
    source.event.flag = 0x10A;
    source.event.arg1 = 17;
    source.event.arg2 = 23;
    std::memcpy(source.event.target, "destination", sizeof("destination"));
    source.position[0] = 12.0f;
    source.rotation[1] = 24.0f;
    source.scale[2] = 36.0f;
    source.map_event.matrix[2][0] = 48.0f;
    source.map_event.matrix[2][2] = 60.0f;
    source.map_event.matrix[3][0] = 72.0f;
    source.map_event.parts_no = 84;
    source.chara_no = 96;
    source.chara_slot = 108;
    source.gameobj_no = 120;
    source.villager_id = 132;
    scene.RunEvent(144, &source);
    source = {};
    EXPECT_EQ(scene.event_no, 144);
    EXPECT_EQ(scene.event_data.event.flag, 0x10AU);
    EXPECT_EQ(scene.event_data.event.arg1, 17);
    EXPECT_EQ(scene.event_data.event.arg2, 23);
    EXPECT_STREQ(scene.event_data.event.target, "destination");
    EXPECT_FLOAT_EQ(scene.event_data.position[0], 12.0f);
    EXPECT_FLOAT_EQ(scene.event_data.rotation[1], 24.0f);
    EXPECT_FLOAT_EQ(scene.event_data.scale[2], 36.0f);
    EXPECT_FLOAT_EQ(scene.event_data.map_event.matrix[2][0], 48.0f);
    EXPECT_FLOAT_EQ(scene.event_data.map_event.matrix[2][2], 60.0f);
    EXPECT_FLOAT_EQ(scene.event_data.map_event.matrix[3][0], 72.0f);
    EXPECT_EQ(scene.event_data.map_event.parts_no, 84);
    EXPECT_EQ(scene.event_data.chara_no, 96);
    EXPECT_EQ(scene.event_data.chara_slot, 108);
    EXPECT_EQ(scene.event_data.gameobj_no, 120);
    EXPECT_EQ(scene.event_data.villager_id, 132);
}

TEST(EventArenaRead, AClosedNpcTalkViewDoesNotExposeItsRetiredWriteBuffer) {
    std::array<u_long128, 32> storage{};
    mgCMemory                 parent;
    parent.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    auto *allocation = parent.Alloc(16);
    ASSERT_NE(allocation, nullptr);
    mgCMemory child;
    child.stSetChildBuffer(parent, allocation, 16);
    parent.stClearUsed();
    const auto bytes = dc2::memory::RemainingBytes(parent);
    std::memset(bytes.data(), 0xA5, bytes.size());
    const auto previous_text = EdEventInfo.npc_talk_text;
    const auto previous_size = EdEventInfo.npc_talk_size;
    EXPECT_EQ(LoadNpcTalkMes(&child), 0);
    EXPECT_EQ(child.stack_used, 0);
    EXPECT_EQ(EdEventInfo.npc_talk_text, previous_text);
    EXPECT_EQ(EdEventInfo.npc_talk_size, previous_size);
    for (const auto byte : bytes) {
        ASSERT_EQ(byte, 0xA5);
    }
}

TEST(EventMessageSource, RejectsRetiredWindowTextBeforeReadingOrPublishingACachedBody) {
    std::array<u_long128, 64> storage{};
    mgCMemory                 memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    ClsMes                                    message;
    dc2::test::ScopedGlobalObject<EventScene> scene;
    scene->message_num = 1;
    scene->message[0].status = 1;
    scene->message[0].mes = &message;
    const char source[] = {'@', '7', 10, 'b', 'o', 'd', 'y', 0};
    auto      *text = dc2::memory::NewArray<char>(memory, sizeof(source));
    ASSERT_NE(text, nullptr);
    std::memcpy(text, source, sizeof(source));
    message.mes_data = text;
    message.mes_data_size = sizeof(source);
    message.mes_data_storage = dc2::memory::ArenaBuffer::Bind(memory,
                                                              {reinterpret_cast<u8 *>(text), sizeof(source)});
    memory.stClearUsed();
    const auto bytes = dc2::memory::RemainingBytes(memory);
    std::memset(bytes.data(), 0xA5, bytes.size());
    message.mes_no = 123;
    CRunScript script;
    SetEventFunc(&script);
    RS_STACKDATA args[2]{};
    args[0].type = RS_INT;
    args[0].val.i = 0;
    args[1].type = RS_INT;
    args[1].val.i = 7;
    EXPECT_FALSE(InvokeNativeExternal(script.ext_func_table[EVENT_EXT_MES_MAKE], args));
    EXPECT_EQ(message.mes_no, 123);
    EXPECT_EQ(message.text_ptr, nullptr);
}

TEST_F(EventAssetPaths, RetainedPackLookupOwnsItsDirectoryAndMemberAcrossQueueAndEventCleanup) {
    Write("event/retained.pac/pack.json", {
                                              {"schema_version", 1                },
                                              {"kind",           "asset_directory"}
    });
    const std::string body = "owned member bytes";
    std::ofstream(root / "data/event/retained.pac/owned.txt", std::ios::binary)
        .write(body.data(), static_cast<std::streamsize>(body.size()));
    DataReadIndex(root / "data");
    char directory[] = "event/";
    SetCurrentDir(directory);
    ASSERT_TRUE(dc2::event::LoadPack("retained.pac"));
    StartReadBG();
    EXPECT_EQ(read_buffer, nullptr);
    auto read = dc2::event::ReadFile("owned.txt");
    ASSERT_TRUE(read);
    EXPECT_EQ(std::string_view(reinterpret_cast<const char *>(read.Bytes().data()), read.Bytes().size()), body);
    EXPECT_EQ(read.Source(), "event/retained.pac/owned.txt");
    const auto *owned_bytes = read.Bytes().data();
    dc2::event::ResetReadFiles();
    StartReadBG();
    EXPECT_EQ(std::string_view(reinterpret_cast<const char *>(read.Bytes().data()), read.Bytes().size()), body);
    EXPECT_EQ(DataReadBufferSize(owned_bytes), body.size());
    read = {};
    EXPECT_EQ(DataReadBufferSize(owned_bytes), 0);
    EXPECT_FALSE(DataReadBufferPath(owned_bytes));
}

namespace {
/**
 * Supplies event programs with complete owned paths and a checked script workspace.
 */
class MapScriptPaths : public EventAssetPaths {
protected:
    std::vector<u_long128> script_storage = std::vector<u_long128>(1024);
    mgCMemory              script_memory;

    void SetUp() override {
        EventAssetPaths::SetUp();
        script_memory.stSetBuffer(script_storage.data(), static_cast<int>(script_storage.size()));
        SetScriptBuffer(&script_memory);
    }

    void TearDown() override {
        SetEventScript({}, nullptr);
        SetScriptBuffer(nullptr);
        luau_runtime::SetScriptsRoot({});
#ifdef _WIN32
        auto absolute = std::filesystem::absolute(root);
        root = std::filesystem::path(L"\\\\?\\" + absolute.make_preferred().native());
#endif
        EventAssetPaths::TearDown();
        EXPECT_FALSE(std::filesystem::exists(root));
    }

    /**
     * Writes the Luau module that an event script path loads as, with one program that returns 0.
     */
    void WriteProgram(const std::string &name, int entry) {
        auto file = (root / "scripts" / name).replace_extension(".luau").lexically_normal();
#ifdef _WIN32
        auto absolute = std::filesystem::absolute(file);
        file = std::filesystem::path(L"\\\\?\\" + absolute.make_preferred().native());
#endif
        std::filesystem::create_directories(file.parent_path());
        std::ofstream(file) << "local function run() return 0 end\nreturn { [" << entry << "] = run, event_" << entry << " = run }\n";
        luau_runtime::SetScriptsRoot(root / "scripts");
    }
};
} // namespace

TEST_F(MapScriptPaths, LongBoundedPathsPreferLocalizedProgramsAndFallBackToTheOriginal) {
    std::string directory = "map/";
    // Long enough to pass the retail 64-byte name buffer, short enough for the host's path limit under the temporary root.
    for (int component = 0; component < 4; ++component) {
        directory += std::string(28, 'a') + '/';
    }
    const auto original = directory + "fixture.stb";
    const auto localized = directory + "fixture_2.stb";
    const auto fallback = directory + "fallback.stb";
    WriteProgram(original, 100);
    WriteProgram(localized, 101);
    WriteProgram(fallback, 102);

    const auto nonterminated = original + "ignored";
    LoadScript(std::string_view(nonterminated).substr(0, original.size()));
    EXPECT_EQ(RunEvent(101, nullptr), 0);
    EXPECT_EQ(RunEvent(100, nullptr), -1);
    LoadScript(fallback);
    EXPECT_EQ(RunEvent(102, nullptr), 0);
    EXPECT_EQ(RunEvent(101, nullptr), -1);
}

TEST_F(MapScriptPaths, MissingWorkspacesAndInvalidPathsRetireThePreviousProgram) {
    NativeScriptProgram program;
    SetEventScript(program.Bytes(), &script_memory);
    ASSERT_EQ(RunEvent(100, nullptr), 0);
    SetScriptBuffer(nullptr);
    LoadScript("missing.stb");
    EXPECT_EQ(RunEvent(100, nullptr), -1);

    SetScriptBuffer(&script_memory);
    for (const auto path : {std::string_view{}, std::string_view("a"), std::string_view("bad\0name.stb", 12)}) {
        SetEventScript(program.Bytes(), &script_memory);
        ASSERT_EQ(RunEvent(100, nullptr), 0);
        LoadScript(path);
        EXPECT_EQ(RunEvent(100, nullptr), -1);
    }
}

TEST_F(MapScriptPaths, ReloadRetainsTheCompleteMapScriptPath) {
    std::string map_name = "t01abc";
    for (int component = 0; component < 8; ++component) {
        map_name += "/nested_segment";
    }
    const auto path = dc2::world::MapPath(map_name) + ".stb";
    ASSERT_GT(path.size(), 64U);
    WriteProgram(path, 103);
    LoadMapScript(map_name.data());
    EXPECT_EQ(RunEvent(103, nullptr), 0);
    LoadScript("a");
    EXPECT_EQ(RunEvent(103, nullptr), -1);
    ReloadMapScript();
    EXPECT_EQ(RunEvent(103, nullptr), 0);
}

TEST_F(MapScriptPaths, TooSmallAndRetiredWorkspacesCannotPublishAProgram) {
    // The program's handle names a long module, so it needs more than the small workspace holds.
    const std::string name = "map/" + std::string(64, 'f');
    WriteProgram(name + "_2.stb", 101);
    static char key;
    auto       *storage = reinterpret_cast<u_long128 *>(ArenaBlock(&key, 4 * sizeof(u_long128)));
    mgCMemory   small;
    small.stSetBuffer(storage, 4);
    SetScriptBuffer(&small);
    LoadScript(name + ".stb");
    EXPECT_EQ(RunEvent(101, nullptr), -1);
    EXPECT_EQ(small.stGetUsed(), 0);

    mgCMemory borrowed;
    ASSERT_TRUE(borrowed.stShareStack(script_memory));
    script_memory.stReset();
    SetScriptBuffer(&borrowed);
    LoadScript(name + ".stb");
    EXPECT_EQ(RunEvent(101, nullptr), -1);
}

TEST_F(MapScriptPaths, AProgramThatConsumesTheGuardQuadwordIsRejectedBeforeAllocation) {
    WriteProgram("map/full_2.stb", 104);
    const std::size_t size = (luau_runtime::MakeHandle("map/full_2").size() + 15) / 16 * 16;
    mgCMemory         exact;
    auto             *storage = reinterpret_cast<u_long128 *>(ArenaBlock(&exact, size));
    exact.stSetBuffer(storage, static_cast<int>(size / sizeof(u_long128)));
    SetScriptBuffer(&exact);
    LoadScript("map/full.stb");
    EXPECT_EQ(RunEvent(104, nullptr), -1);
    EXPECT_EQ(exact.stGetUsed(), 0);
}
