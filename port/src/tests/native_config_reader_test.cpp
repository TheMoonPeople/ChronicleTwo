#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

// clang-format off
#include "platform/native_config.hpp"
// clang-format on

#include <array>
#include <chrono>
#include <filesystem>
#include <fstream>
#include <string>
#include <vector>

#include "command_replay.hpp"
#include "dataread.hpp"
#include "dataread_port.hpp"
#include "platform/datapacks.hpp"
#include "scriptinterpreter.hpp"
#include "texture_source.hpp"

namespace {
using Json = nlohmann::json;

/**
 * Provides an isolated converted-data root with a datapack overlay directory.
 */
class NativeConfigReader : public testing::Test {
protected:
    std::filesystem::path previous_root = datapacks::Root(); /**< Native data root restored after the fixture. */
    std::filesystem::path directory;                         /**< Fixture root. */

    void SetUp() override {
        directory = std::filesystem::temp_directory_path() / ("chronicle_native_reader_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
        std::filesystem::create_directories(directory / "data/configs");
        std::filesystem::create_directories(directory / "data");
        Write(directory / "data/configs/shop.cfg.json", Shops(7));
        DataReadIndex(directory / "data");
    }

    void TearDown() override {
        if (previous_root.empty()) {
            DataReadIndex(directory / "empty/data");
            datapacks::Clear();
        } else {
            DataReadIndex(previous_root.parent_path() / "data");
        }
        std::filesystem::remove_all(directory);
    }

    static void Write(const std::filesystem::path &path, const std::string &text) {
        std::filesystem::create_directories(path.parent_path());
        std::ofstream(path, std::ios::binary) << text;
    }

    static void Write(const std::filesystem::path &path, const Json &value) { Write(path, value.dump()); }

    static Json Shops(int id) {
        return {
            {"schema_version", 2                                                             },
            {"kind",           "shop_lists"                                                  },
            {"shops",          Json::array({{{"id", id}, {"items", Json::array({1, 2, 3})}}})},
            {"prices",         Json::array()                                                 }
        };
    }

    void Overlay(const std::string &name, const std::string &text) {
        Write(directory / "datapacks/datapacks.json", Json{
                                                          {"schema_version", 1                  },
                                                          {"load_order",     Json::array({name})}
        });
        Write(directory / "datapacks" / name / "configs/shop.cfg.json", text);
        DataReadIndex(directory / "data");
    }

    static std::optional<int> ShopId(std::string_view path) {
        return native_config::Read<int>(path, "shop_lists", [](const Json &document) { return native_config::Int(native_config::Array(document, "shops").at(0), "id"); });
    }
};

/** Callback arguments observed by the command-replay test. */
std::vector<std::array<int, 3> > replayed;

/**
 * Records three integer slots, including inherited ones.
 */
int CaptureInts(SPI_STACK *stack, int /*unused*/) {
    replayed.push_back({spiGetStackInt(stack), spiGetStackInt(stack + 1), spiGetStackInt(stack + 2)});
    return 0;
}
} // namespace

TEST_F(NativeConfigReader, ReadsTheConvertedDocumentByKind) {
    EXPECT_EQ(ShopId("configs/shop.cfg.json"), 7);
    testing::internal::CaptureStderr();
    EXPECT_FALSE(native_config::Read<int>("configs/shop.cfg.json", "quests", [](const Json &) { return 0; }));
    EXPECT_NE(testing::internal::GetCapturedStderr().find("not a quests document"), std::string::npos);
}

TEST_F(NativeConfigReader, DatapackOverlayWinsAndInvalidOverlaysFallBack) {
    Overlay("good", Shops(9).dump());
    EXPECT_EQ(ShopId("configs/shop.cfg.json"), 9);
    // A command-list document from an older converter is refused, and the converted original is read.
    Overlay("old", R"({"schema_version":1,"commands":[{"command":"SHOP","args":[]}]})");
    testing::internal::CaptureStderr();
    EXPECT_EQ(ShopId("configs/shop.cfg.json"), 7);
    EXPECT_NE(testing::internal::GetCapturedStderr().find("command-list"), std::string::npos);
    Overlay("broken", "{broken");
    testing::internal::CaptureStderr();
    EXPECT_EQ(ShopId("configs/shop.cfg.json"), 7);
    testing::internal::GetCapturedStderr();
    // A document whose typed contents fail to parse also falls back.
    Overlay("typed", R"({"schema_version":2,"kind":"shop_lists","shops":"none","prices":[]})");
    testing::internal::CaptureStderr();
    EXPECT_EQ(ShopId("configs/shop.cfg.json"), 7);
    testing::internal::GetCapturedStderr();
}

TEST_F(NativeConfigReader, RefusesPathsOutsideTheDataRoot) {
    testing::internal::CaptureStderr();
    EXPECT_FALSE(ShopId("../outside.cfg.json"));
    EXPECT_FALSE(ShopId("C:/outside.cfg.json"));
    testing::internal::GetCapturedStderr();
}

TEST_F(NativeConfigReader, RecoversTheDocumentOfALoadedBuffer) {
    std::string bytes = Shops(7).dump();
    DataReadRegisterAsset(bytes.data(), "configs/shop.cfg.json", bytes.size());
    const auto id = native_config::ReadBuffer<int>(bytes.data(), "shop_lists", [](const Json &document) { return native_config::Int(native_config::Array(document, "shops").at(0), "id"); });
    EXPECT_EQ(id, 7);
    TextureSourceForget(bytes.data());
}

TEST_F(NativeConfigReader, GameTextEncodesUnicodeAndKeepsExceptionalBytes) {
    EXPECT_EQ(native_config::GameText(Json("日本")), std::optional<std::string>("\x93\xfa\x96\x7b"));
    EXPECT_EQ(native_config::GameText(Json{
                  {"text",       "?"   },
                  {"game_bytes", "8140"}
    }),
              std::optional<std::string>("\x81\x40"));
    EXPECT_FALSE(native_config::GameText(Json(nullptr)));
    EXPECT_THROW(native_config::GameText(Json{
                     {"text",       "?" },
                     {"game_bytes", "00"}
    }),
                 std::runtime_error);
    EXPECT_EQ(native_config::Raw(Json{
                                     {"float", 1.5}
    })
                  .type,
              native_config::RawValue::Type::Float);
    EXPECT_EQ(native_config::Raw(Json(3)).integer, 3);
}

TEST_F(NativeConfigReader, CharacterCommandListsKeepRetailSlotInheritance) {
    replayed.clear();
    char          name[] = "ROW";
    SPI_TAG_PARAM tags[]{
        {.name = name,    .function = CaptureInts},
        {.name = nullptr, .function = nullptr    }
    };
    const std::string script = R"({"schema_version":1,"commands":[
        {"command":"ROW","args":[{"type":"int","value":1},{"type":"int","value":2},{"type":"int","value":3}]},
        {"command":"SKIPPED","args":[{"type":"int","value":9},{"type":"int","value":9},{"type":"int","value":9}]},
        {"command":"ROW","args":[{"type":"float","value":4.5}]}]})";
    ASSERT_TRUE(command_replay::IsCommandBuffer(script.data(), static_cast<int>(script.size())));
    ASSERT_TRUE(command_replay::RunBuffer(script.data(), static_cast<int>(script.size()), tags));
    ASSERT_EQ(replayed.size(), 2u);
    EXPECT_EQ(replayed[1], (std::array<int, 3>{4, 2, 3}));
    EXPECT_FALSE(command_replay::IsCommandBuffer("ROW 1;", 6));
}
