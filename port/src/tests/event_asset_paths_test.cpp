#include "common.h"

#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <algorithm>
#include <array>
#include <chrono>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <string>

#include "dataread.hpp"
#include "dataread_port.hpp"
#include "event.hpp"
#include "event_background.hpp"
#include "event_func.hpp"
#include "mainloop.hpp"
#include "platform/datapacks.hpp"
#include "platform/paths.hpp"
#include "runscript.hpp"

namespace {
/**
 * Supplies direct localized texture and command documents in standalone and event directories.
 */
class EventAssetPaths : public testing::Test {
protected:
    std::filesystem::path  root = std::filesystem::temp_directory_path() / ("event_asset_paths_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
    std::filesystem::path  previous_root = PathsDataRoot();
    int                    language = LanguageCode;
    int                    pack_loaded = EdEventInfo.pack_loaded;
    int                    stream_reading = EdEventInfo.stream_reading;
    u_long128             *buffer = read_buffer;
    std::array<char, 1024> previous_directory{};
    alignas(16) std::array<u_long128, 128> marker {};

    void SetUp() override {
        GetCurrentDir(previous_directory.data());
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
                Write(std::string(directory) + "/poster_" + std::to_string(number) + ".json", texture);
                Write(std::string(directory) + "/config_" + std::to_string(number) + ".json", config);
            }
        }
        Write("event/assets/pack.json", {
                                            {"schema_version", 1                },
                                            {"kind",           "asset_directory"}
        });
        DataReadIndex(root / "data");
        SetCurrentDir(nullptr);
        LanguageCode = LANG_FRENCH;
        EdEventInfo.pack_loaded = false;
        EdEventInfo.stream_reading = false;
        read_buffer = nullptr;
    }

    void TearDown() override {
        _SET_LOADBG_FILE(nullptr, 0);
        LanguageCode = language;
        EdEventInfo.pack_loaded = pack_loaded;
        EdEventInfo.stream_reading = stream_reading;
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
    char directory[] = "event/ui/";
    SetCurrentDir(directory);
    char texture[64] = "poster_1.json";
    char config[64] = "config_1.json";
    FileNameConvLanguage(texture);
    FileNameConvLanguage(config);
    EXPECT_STREQ(texture, "poster_2.json");
    EXPECT_STREQ(config, "config_1.json");
    char script[64] = "scene_1.stb";
    char text[64] = "message_1.txt";
    FileNameConvLanguage(script);
    FileNameConvLanguage(text);
    EXPECT_STREQ(script, "scene_2.stb");
    EXPECT_STREQ(text, "message_2.txt");
}

TEST_F(EventAssetPaths, LocalizesTextureJsonInsideLoadedEventDirectory) {
    char directory[] = "event/assets";
    ASSERT_GT(LoadFile(directory, marker.data(), nullptr), 0);
    read_buffer = marker.data();
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
    char texture[64] = "event/ui/poster_1.json";
    FileNameConvLanguage(texture);
    EXPECT_STREQ(texture, "event/ui/poster_1.json");
    LanguageCode = LANG_FRENCH;
    char unknown[64] = "missing_1.json";
    FileNameConvLanguage(unknown);
    EXPECT_STREQ(unknown, "missing_1.json");
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
    std::memset(marker.data(), 0x5a, sizeof(marker));
    const auto previous = marker;
    read_buffer = marker.data();
    ASSERT_TRUE(_SET_LOADBG_FILE(arguments.data(), static_cast<int>(arguments.size())));
    EXPECT_EQ(std::memcmp(marker.data(), previous.data(), sizeof(marker)), 0);
    EXPECT_EQ(ReadBGSync(), 1);
    // A glTF is read by name: each buffer is one zeroed sector registered with the file's path.
    for (std::size_t index = 0; index < names.size(); ++index) {
        int         size = 0;
        const auto *buffer = GetLoadBGBuff(names[index].data(), &size);
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
    EXPECT_EQ(std::memcmp(marker.data(), previous.data(), sizeof(marker)), 0);
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
    std::memset(marker.data(), 0x36, sizeof(marker));
    const auto previous = marker;
    read_buffer = marker.data();
    char         name[] = "replacement.gltf";
    RS_STACKDATA argument{};
    argument.type = RS_STR;
    argument.val.s = name;
    ASSERT_TRUE(_SET_LOADBG_FILE(&argument, 1));
    const auto zeroed = [](const void *buffer) {
        const auto *bytes = reinterpret_cast<const unsigned char *>(buffer);
        return std::all_of(bytes, bytes + 2048, [](unsigned char byte) { return byte == 0; });
    };
    // The model loader reads the glTF itself, through datapack priority, from the registered name.
    int         size = 0;
    const auto *loaded = GetLoadBGBuff(name, &size);
    ASSERT_NE(loaded, nullptr);
    EXPECT_EQ(size, 2048);
    EXPECT_EQ(DataReadBufferSize(loaded), 2048u);
    EXPECT_EQ(DataReadBufferPath(loaded), path);
    EXPECT_TRUE(zeroed(loaded));
    char        unqueued[] = "fallback.gltf";
    const auto *other = GetLoadBGBuff(unqueued, &size);
    ASSERT_NE(other, nullptr);
    EXPECT_NE(other, loaded);
    EXPECT_EQ(size, 2048);
    EXPECT_EQ(DataReadBufferPath(other), "event/ui/fallback.gltf");
    EXPECT_TRUE(zeroed(other));
    EXPECT_EQ(std::memcmp(marker.data(), previous.data(), sizeof(marker)), 0);
    char instructions[] = "next.txt";
    argument.val.s = reinterpret_cast<char *>(GetLoadBGBuff(instructions, nullptr));
    ASSERT_NE(argument.val.s, nullptr);
    ASSERT_TRUE(_SET_LOADBG_FILE(&argument, 1));
    loaded = GetLoadBGBuff(name, &size);
    ASSERT_NE(loaded, nullptr);
    EXPECT_EQ(size, 2048);
    EXPECT_EQ(DataReadBufferPath(loaded), path);
}

TEST_F(EventAssetPaths, SmallUnqueuedDocumentsRetainZeroedSectorPadding) {
    char        name[] = "event/ui/config_1.json";
    int         size = 0;
    const auto *loaded = GetLoadBGBuff(name, &size);
    ASSERT_NE(loaded, nullptr);
    ASSERT_GT(size, 0);
    ASSERT_LT(size, 2048);
    EXPECT_EQ(DataReadBufferSize(loaded), static_cast<std::size_t>(size));
    const auto *bytes = reinterpret_cast<const unsigned char *>(loaded);
    EXPECT_TRUE(std::all_of(bytes + size, bytes + 2048, [](unsigned char byte) { return byte == 0; }));
}
