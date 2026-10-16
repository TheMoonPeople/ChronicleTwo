#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <array>
#include <chrono>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <memory>
#include <string>
#include <vector>

#include "dataread.hpp"
#include "dataread_port.hpp"
#include "mainloop.hpp"
#include "mainloop_port.hpp"
#include "native_config.hpp"
#include "platform/config_catalog.hpp"
#include "platform/datapacks.hpp"
#include "platform/paths.hpp"
#include "savedata.hpp"
#include "scriptinterpreter.hpp"
#include "texture_source.hpp"

namespace {
using Json = nlohmann::json;

/**
 * Retains callback arguments for assertions after native command execution.
 */
struct Captured {
    std::vector<int>         types;    /**< Native stack type of each callback argument. */
    std::vector<int>         integers; /**< Integer argument values in encounter order. */
    std::vector<float>       reals;    /**< Floating-point values in encounter order. */
    std::vector<std::string> strings;  /**< Game-encoded strings copied during the callback. */
};

/** Callback arguments collected by the current configuration test. */
std::vector<Captured> captured;

/**
 * Copies typed arguments without assuming that the original script buffer contains text.
 */
int Capture(SPI_STACK *stack, int count) {
    Captured values;
    for (int index = 0; index < count; ++index) {
        values.types.push_back(stack[index].type);
        if (stack[index].type == SPI_STACK_TYPE_INT) {
            values.integers.push_back(spiGetStackInt(stack + index));
        }
        if (stack[index].type == SPI_STACK_TYPE_FLOAT) {
            values.reals.push_back(spiGetStackFloat(stack + index));
        }
        if (stack[index].type == SPI_STACK_TYPE_STRING) {
            values.strings.emplace_back(spiGetStackString(stack + index));
        }
    }
    captured.push_back(std::move(values));
    return 0;
}

/**
 * Provides directly addressed native JSON configurations and callback capture.
 */
class NativeConfig : public testing::Test {
protected:
    std::filesystem::path  previous_root = datapacks::Root(); /**< Native data root restored after the fixture. */
    std::array<char, 1024> previous_directory{};              /**< Current resource directory restored after the fixture. */
    std::filesystem::path  directory;                         /**< Isolated converted-data and datapack fixture root. */
    Json                   document;                          /**< Native configuration document changed by individual tests. */
    int                    handle = 0;                        /**< Unrelated memory used to detect accidental writes. */
    char                   tag_name[8] = "ACTION";            /**< Named callback tag used by text-converted commands. */
    SPI_TAG_PARAM          tags[2]{
        {tag_name, Capture},
        {nullptr,  nullptr}
    }; /**< Native callback table. */

    void SetUp() override {
        captured.clear();
        GetCurrentDir(previous_directory.data());
        SetCurrentDir(nullptr);
        directory = std::filesystem::temp_directory_path() / ("chronicle_native_config_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
        std::filesystem::create_directories(directory / "port_data/configs");
        std::filesystem::create_directories(directory / "data");
        document = {
            {"schema_version", 1                                                                                                                                                                                                     },
            {"commands",       Json::array({{{"command", "ACTION"}, {"args", Json::array({{{"type", "int"}, {"value", -7}}, {{"type", "float"}, {"value", 1.5}}, {{"type", "string"}, {"value", "text"}}, {{"type", "invalid"}}})}}})}
        };
        Write(directory / "port_data/configs/fixture.cfg.json", document);
        DataReadIndex(directory / "data");
        std::string error;
        ASSERT_TRUE(config_catalog::Load(directory / "port_data", error)) << error;
    }

    void TearDown() override {
        config_catalog::Clear();
        TextureSourceForget(&handle);
        if (previous_root.empty()) {
            DataReadIndex(directory / "empty/data");
            datapacks::Clear();
        } else {
            DataReadIndex(previous_root.parent_path() / "data");
        }
        SetCurrentDir(previous_directory.data());
        std::filesystem::remove_all(directory);
    }

    static void Write(const std::filesystem::path &path, const Json &value) { std::ofstream(path) << value.dump(); }

    void Run() {
        std::string error;
        for (const auto &path : config_catalog::Paths("configs/fixture.cfg.json")) {
            std::ifstream input(path);
            if (!input) {
                continue;
            }
            const std::string bytes{std::istreambuf_iterator<char>(input), std::istreambuf_iterator<char>()};
            try {
                if (!config_catalog::Decode(Json::parse(bytes), error)) {
                    continue;
                }
            } catch (const std::exception &) {
                continue;
            }
            std::vector<char>  buffer(bytes.begin(), bytes.end());
            CScriptInterpreter interpreter;
            interpreter.SetTag(tags);
            interpreter.SetScript(buffer.data(), static_cast<int>(buffer.size()));
            interpreter.Run();
            return;
        }
    }
};
} // namespace

TEST_F(NativeConfig, ExecutesDirectJsonBytesWithoutAnyCatalog) {
    Run();
    ASSERT_EQ(captured.size(), 1u);
    EXPECT_EQ(captured[0].types, (std::vector<int>{SPI_STACK_TYPE_INT, SPI_STACK_TYPE_FLOAT, SPI_STACK_TYPE_STRING, SPI_STACK_TYPE_INVALID}));
    EXPECT_EQ(captured[0].integers, (std::vector<int>{-7}));
    EXPECT_EQ(captured[0].reals, (std::vector<float>{1.5f}));
    EXPECT_EQ(captured[0].strings, (std::vector<std::string>{"text"}));
    EXPECT_EQ(handle, 0);
}

TEST_F(NativeConfig, DirectFileRunnerHandlesLargeJsonAndFallsBackFromMalformedOverlay) {
    const auto command = document["commands"][0];
    for (int index = 1; index < 160; ++index) {
        document["commands"].push_back(command);
    }
    const auto text = document.dump(2);
    ASSERT_GT(text.size(), 33589u);
    std::ofstream(directory / "port_data/configs/fixture.cfg.json") << text;
    std::filesystem::create_directories(directory / "datapacks/override/configs");
    std::ofstream(directory / "datapacks/override/configs/fixture.cfg.json") << "invalid JSON";
    Write(directory / "datapacks/datapacks.json", {
                                                      {"schema_version", 1           },
                                                      {"load_order",     {"override"}}
    });
    datapacks::Load(directory / "port_data");
    ASSERT_TRUE(RunNativeConfig("configs/fixture.cfg.json", tags));
    ASSERT_EQ(captured.size(), 160u);
    for (const auto &values : captured) {
        EXPECT_EQ(values.types, (std::vector<int>{SPI_STACK_TYPE_INT, SPI_STACK_TYPE_FLOAT, SPI_STACK_TYPE_STRING, SPI_STACK_TYPE_INVALID}));
        EXPECT_EQ(values.integers, (std::vector<int>{-7}));
        EXPECT_EQ(values.reals, (std::vector<float>{1.5f}));
        EXPECT_EQ(values.strings, (std::vector<std::string>{"text"}));
    }
}

TEST_F(NativeConfig, DirectFileRunnerReadsLargeHostJsonFromSaveDirectory) {
    struct RestoreSaveRoot {
        std::filesystem::path previous = PathsSaveRoot();

        ~RestoreSaveRoot() { PathsSetSaveRoot(previous); }
    } restore;

    PathsSetSaveRoot(directory / "save");
    const auto path = PathsSaveRoot() / "host0/gyorace.cfg.json";
    std::filesystem::create_directories(path.parent_path());
    const auto command = document["commands"][0];
    for (int index = 1; index < 160; ++index) {
        document["commands"].push_back(command);
    }
    const auto text = document.dump(2);
    ASSERT_GT(text.size(), 33589u);
    std::ofstream(path) << text;
    ASSERT_TRUE(RunNativeConfig("host:gyorace.cfg.json", tags));
    ASSERT_EQ(captured.size(), 160u);
    EXPECT_EQ(captured.back().integers, (std::vector<int>{-7}));
    EXPECT_EQ(captured.back().strings, (std::vector<std::string>{"text"}));
    captured.clear();
    std::ofstream(path) << "invalid host JSON";
    EXPECT_FALSE(RunNativeConfig("host0:gyorace.cfg.json", tags));
    EXPECT_TRUE(captured.empty());
}

TEST_F(NativeConfig, PreservesIndexedCommandsAndSkipsUnknownNamedCommands) {
    document["commands"].insert(document["commands"].begin(), Json{
                                                                  {"command", "UNKNOWN"    },
                                                                  {"args",    Json::array()}
    });
    document["commands"].push_back({
        {"tag_index", 0            },
        {"args",      Json::array()}
    });
    Write(directory / "port_data/configs/fixture.cfg.json", document);
    Run();
    ASSERT_EQ(captured.size(), 2u);
    EXPECT_TRUE(captured[1].types.empty());
}

TEST_F(NativeConfig, EncodesReadableUnicodeAndPreservesExceptionalGameBytes) {
    document["commands"][0]["args"] = Json::array({
        {{"type", "string"}, {"value", "日本語"}},
        {{"type", "string"}, {"value", ""}},
        {{"type", "string"}, {"value", "replacement"}, {"game_bytes", "815c"}}
    });
    Write(directory / "port_data/configs/fixture.cfg.json", document);
    Run();
    ASSERT_EQ(captured.size(), 1u);
    ASSERT_EQ(captured[0].strings.size(), 3u);
    EXPECT_EQ(captured[0].strings[0], "\x93\xFA\x96\x7B\x8C\xEA");
    EXPECT_EQ(captured[0].strings[1], "");
    EXPECT_EQ(captured[0].strings[2], "\x81\x5C");
}

TEST_F(NativeConfig, InvalidJsonOverlayFallsBackToConvertedRetail) {
    std::filesystem::create_directories(directory / "datapacks/override/configs");
    std::ofstream(directory / "datapacks/override/configs/fixture.cfg.json") << "invalid JSON";
    Write(directory / "datapacks/datapacks.json", {
                                                      {"schema_version", 1           },
                                                      {"load_order",     {"override"}}
    });
    datapacks::Load(directory / "port_data");
    Run();
    ASSERT_EQ(captured.size(), 1u);
    EXPECT_EQ(captured[0].integers, (std::vector<int>{-7}));
}

TEST_F(NativeConfig, JsonOverlayChangesCommandsAndCanBeReadWithoutCallingThem) {
    std::filesystem::create_directories(directory / "datapacks/override/configs");
    document["commands"][0]["args"][0]["value"] = 42;
    Write(directory / "datapacks/override/configs/fixture.cfg.json", document);
    Write(directory / "datapacks/datapacks.json", {
                                                      {"schema_version", 1           },
                                                      {"load_order",     {"override"}}
    });
    datapacks::Load(directory / "port_data");
    CScriptInterpreter interpreter;
    interpreter.SetTag(tags);
    auto bytes = document.dump();
    interpreter.SetScript(bytes.data(), static_cast<int>(bytes.size()));
    ASSERT_EQ(interpreter.GetNextTAG(0), 0);
    EXPECT_TRUE(captured.empty());
    ASSERT_EQ(interpreter.stack_count, 4);
    EXPECT_EQ(spiGetStackInt(interpreter.stack), 42);
    EXPECT_EQ(interpreter.GetNextTAG(1), -1);
}

TEST_F(NativeConfig, RejectsArgumentOverflowAndEscapingCatalogPaths) {
    document["commands"][0]["args"] = Json::array();
    for (int argument = 0; argument < 65; ++argument) {
        document["commands"][0]["args"].push_back({
            {"type",  "int"   },
            {"value", argument}
        });
    }
    Write(directory / "port_data/configs/fixture.cfg.json", document);
    std::string error;
    EXPECT_FALSE(config_catalog::Find("configs/fixture.cfg.json", error));
    EXPECT_TRUE(config_catalog::Paths("../outside.json").empty());
}

TEST_F(NativeConfig, CopiedJsonExecutesWithoutBufferRegistration) {
    const auto         source = document.dump();
    std::vector<char>  destination(source.begin(), source.end());
    CScriptInterpreter interpreter;
    interpreter.SetTag(tags);
    interpreter.SetScript(destination.data(), static_cast<int>(destination.size()));
    interpreter.Run();
    ASSERT_EQ(captured.size(), 1u);
    EXPECT_EQ(captured[0].integers, (std::vector<int>{-7}));
    TextureSourceForget(destination.data());
}

namespace {
/**
 * Supplies isolated active save data for native game configuration callbacks.
 */
struct ScopedGameSave {
    CSaveData                 *previous = PortActiveSaveData;
    std::unique_ptr<CSaveData> active = std::make_unique<CSaveData>();

    ScopedGameSave() { PortActiveSaveData = active.get(); }

    ~ScopedGameSave() { PortActiveSaveData = previous; }
};

/**
 * Produces the same typed progress command as the retail debug game configurations.
 */
Json ProgressConfig(int value) {
    return {
        {"schema_version", 1                                                                                                     },
        {"commands",       Json::array({{{"command", "PROGRESS"}, {"args", Json::array({{{"type", "int"}, {"value", value}}})}}})}
    };
}
} // namespace

TEST_F(NativeConfig, AbsentOptionalGameConfigKeepsNewGameDefaultsWithoutDiagnostics) {
    ScopedGameSave restore;
    GetSaveData()->game_progress = 1;
    char directory_name[] = "configs/";
    SetCurrentDir(directory_name);
    testing::internal::CaptureStderr();
    LoadGameConfig(nullptr);
    const auto diagnostic = testing::internal::GetCapturedStderr();
    EXPECT_TRUE(diagnostic.empty()) << diagnostic;
    EXPECT_EQ(GetSaveData()->game_progress, 1);
    char current[1024]{};
    GetCurrentDir(current);
    EXPECT_STREQ(current, "");
}

TEST_F(NativeConfig, OptionalGameConfigLoadsTheRootTypedOverrideAndClearsCurrentDirectory) {
    ScopedGameSave restore;
    Write(directory / "port_data/game.cfg.json", ProgressConfig(4));
    Write(directory / "port_data/configs/game.cfg.json", ProgressConfig(99));
    DataReadIndex(directory / "data");
    char directory_name[] = "configs/";
    SetCurrentDir(directory_name);
    LoadGameConfig(nullptr);
    EXPECT_EQ(GetSaveData()->game_progress, 4);
    char current[1024]{};
    GetCurrentDir(current);
    EXPECT_STREQ(current, "");
}

TEST_F(NativeConfig, ExplicitGameConfigKeepsItsRelativeDirectoryAndRetailTypedProgress) {
    ScopedGameSave restore;
    std::filesystem::create_directories(directory / "port_data/dbg");
    Write(directory / "port_data/dbg/game0.cfg.json", ProgressConfig(4));
    DataReadIndex(directory / "data");
    char directory_name[] = "dbg/";
    SetCurrentDir(directory_name);
    char path[] = "game0.cfg.json";
    LoadGameConfig(path);
    EXPECT_EQ(GetSaveData()->game_progress, 4);
    char current[1024]{};
    GetCurrentDir(current);
    EXPECT_STREQ(current, directory_name);
}
