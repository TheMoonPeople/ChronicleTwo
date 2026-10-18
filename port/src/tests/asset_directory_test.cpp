#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <chrono>
#include <filesystem>
#include <fstream>

#include "asset_directory.hpp"
#include "dataread_port.hpp"
#include "platform/datapacks.hpp"
#include "texture_source.hpp"

namespace {
using Json = nlohmann::json;

/**
 * Supplies native directory metadata and actual files without archive data or alias handles.
 */
class AssetDirectory : public testing::Test {
protected:
    std::filesystem::path root;     /**< Temporary fixture root. */
    std::string           metadata; /**< Actual bounded bytes of the root pack.json. */

    void SetUp() override {
        root = std::filesystem::temp_directory_path() / ("chronicle_directory_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
        std::filesystem::create_directories(root / "data/bundle/child");
        const Json marker = {
            {"schema_version", 1                },
            {"kind",           "asset_directory"}
        };
        metadata = marker.dump(2);
        Write("bundle/pack.json", marker);
        Write("bundle/child/pack.json", marker);
        Write("bundle/model.gltf", {
                                       {"asset", {{"version", "2.0"}}}
        });
        Write("bundle/model.game.json", {
                                            {"schema_version", 1}
        });
        Write("bundle/config.json", {
                                        {"schema_version", 2           },
                                        {"kind",           "shop_lists"}
        });
        Write("bundle/texture.json", {
                                         {"schema_version", 3            },
                                         {"groups",         {0}          },
                                         {"entries",        Json::array()}
        });
        Write("bundle/sound.sound.json", {
                                             {"schema_version", 1             },
                                             {"kind",           "sound_bundle"}
        });
        Write("bundle/child/other.json", {
                                             {"schema_version", 2           },
                                             {"kind",           "shop_lists"}
        });
        std::ofstream(root / "data/bundle/raw.bin", std::ios::binary) << "abc";
        datapacks::Load(root / "data");
        DataReadRegisterAsset(metadata.data(), "bundle/pack.json", metadata.size());
    }

    void TearDown() override {
        TextureSourceForget(metadata.data());
        DataReadRegisterBuffer(metadata.data(), 0);
        datapacks::Clear();
        std::filesystem::remove_all(root);
    }

    void Write(const std::filesystem::path &path, const Json &data) { std::ofstream(root / "data" / path) << data.dump(2); }
};
} // namespace

TEST_F(AssetDirectory, EnumeratesActualNativeKindsAndExcludesGameplayMetadata) {
    EXPECT_EQ(AssetDirectoryPath(metadata.data()), std::optional<std::string>{"bundle"});
    EXPECT_EQ(AssetDirectoryCount(metadata.data()), 6);
    u_int *files[8]{};
    int    sizes[8]{};
    char  *names[8]{};
    EXPECT_EQ(AssetDirectoryReadExtension(metadata.data(), "gltf", files, 8, sizes, names), 1);
    EXPECT_STREQ(names[0], "model.gltf");
    EXPECT_EQ(AssetDirectoryReadExtension(metadata.data(), "texture", files, 8, sizes, names), 1);
    EXPECT_STREQ(names[0], "texture.json");
    EXPECT_EQ(AssetDirectoryReadExtension(metadata.data(), "commands", files, 8, sizes, names), 1);
    EXPECT_STREQ(names[0], "config.json");
    EXPECT_EQ(AssetDirectoryReadExtension(metadata.data(), "bin", files, 8, sizes, names), 1);
    EXPECT_EQ(sizes[0], 3);
    EXPECT_EQ(std::string(reinterpret_cast<char *>(files[0]), 3), "abc");
    EXPECT_EQ(DataReadBufferPath(files[0]), std::optional<std::string>{"bundle/raw.bin"});
    EXPECT_EQ(DataReadBufferSize(files[0]), 3u);
}

TEST_F(AssetDirectory, ReadsNestedDirectoriesAndCaseInsensitiveActualNames) {
    int   size = 0;
    auto *child = AssetDirectoryRead(metadata.data(), "child", &size);
    ASSERT_NE(child, nullptr);
    EXPECT_EQ(AssetDirectoryPath(child), std::optional<std::string>{"bundle/child"});
    EXPECT_EQ(AssetDirectoryCount(child), 1);
    auto *config = AssetDirectoryRead(metadata.data(), "CONFIG.JSON", &size);
    ASSERT_NE(config, nullptr);
    EXPECT_EQ(DataReadBufferPath(config), std::optional<std::string>{"bundle/config.json"});
    EXPECT_EQ(DataReadBufferSize(config), static_cast<std::size_t>(size));
    char *name = nullptr;
    EXPECT_NE(AssetDirectoryRead(child, 0, &name, &size), nullptr);
    EXPECT_STREQ(name, "other.json");
}

TEST_F(AssetDirectory, RejectsTraversalAndNonDirectoryBytes) {
    int size = 42;
    EXPECT_EQ(AssetDirectoryRead(metadata.data(), "../outside.json", &size), nullptr);
    EXPECT_EQ(size, 0);
    EXPECT_EQ(AssetDirectoryRead(metadata.data(), "/outside.json", nullptr), nullptr);
    auto invalid = std::string(R"({"schema_version":"bad","kind":4})");
    std::ofstream(root / "data/bundle/pack.json") << invalid;
    DataReadRegisterAsset(invalid.data(), "bundle/pack.json", invalid.size());
    EXPECT_FALSE(AssetDirectoryPath(invalid.data()));
    DataReadRegisterAsset(metadata.data(), "bundle/model.gltf", metadata.size());
    EXPECT_FALSE(AssetDirectoryPath(metadata.data()));
    TextureSourceForget(invalid.data());
    DataReadRegisterBuffer(invalid.data(), 0);
}

TEST_F(AssetDirectory, MergesDatapackOnlyFilesAndFallsBackFromMalformedTypedDocuments) {
    std::filesystem::create_directories(root / "datapacks/test/bundle");
    std::ofstream(root / "datapacks/datapacks.json") << Json({
                                                                 {"schema_version", 1       },
                                                                 {"load_order",     {"test"}}
    })
                                                            .dump(2);
    std::ofstream(root / "datapacks/test/bundle/extra.json") << Json({
                                                                         {"schema_version", 2           },
                                                                         {"kind",           "shop_lists"}
    })
                                                                    .dump(2);
    std::ofstream(root / "datapacks/test/bundle/config.json") << "{broken";
    std::ofstream(root / "datapacks/test/bundle/pack.json") << "{broken";
    datapacks::Load(root / "data");
    std::string invalid = "{broken";
    DataReadRegisterAsset(invalid.data(), "bundle/pack.json", invalid.size());
    EXPECT_EQ(AssetDirectoryPath(invalid.data()), std::optional<std::string>{"bundle"});
    TextureSourceForget(invalid.data());
    DataReadRegisterBuffer(invalid.data(), 0);
    EXPECT_EQ(AssetDirectoryCount(metadata.data()), 7);
    u_int *files[8]{};
    int    sizes[8]{};
    char  *names[8]{};
    ASSERT_EQ(AssetDirectoryReadExtension(metadata.data(), "commands", files, 8, sizes, names), 2);
    EXPECT_STREQ(names[0], "config.json");
    const auto data = Json::parse(reinterpret_cast<const char *>(files[0]), reinterpret_cast<const char *>(files[0]) + sizes[0]);
    EXPECT_EQ(data.at("kind"), "shop_lists");
    EXPECT_STREQ(names[1], "extra.json");
}
