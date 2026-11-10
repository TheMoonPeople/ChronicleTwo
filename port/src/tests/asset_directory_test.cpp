#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <chrono>
#include <filesystem>
#include <fstream>

#include "asset_directory.hpp"
#include "assets/data_registry.hpp"
#include "platform/datapacks.hpp"
#include "platform/paths.hpp"
#include "texture_source.hpp"

namespace {
using Json = nlohmann::json;

/**
 * Supplies native directory metadata and actual files without archive data or alias handles.
 */
class AssetDirectory : public testing::Test {
protected:
    std::filesystem::path previous_root = PathsDataRoot();
    std::string           previous_directory;
    std::filesystem::path root;     /**< Temporary fixture root. */
    std::string           metadata; /**< Actual bounded bytes of the root pack.json. */

    void SetUp() override {
        previous_directory = GetCurrentDir();
        SetCurrentDir(nullptr);
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
        Write("gameplay/bundle/config.json", {
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
        Write("gameplay/bundle/child/other.json", {
                                                      {"schema_version", 2           },
                                                      {"kind",           "shop_lists"}
        });
        std::ofstream(root / "data/bundle/raw.bin", std::ios::binary) << "abc";
        DataReadIndex(root / "data");
        DataReadRegisterAsset(metadata.data(), "bundle/pack.json", metadata.size());
    }

    void TearDown() override {
        TextureSourceForget(metadata.data());
        DataReadRegisterBuffer(metadata.data(), 0);
        DataReadIndex(previous_root);
        SetCurrentDir(previous_directory.data());
        std::filesystem::remove_all(root);
    }

    void Write(const std::filesystem::path &path, const Json &data) {
        std::filesystem::create_directories((root / "data" / path).parent_path());
        std::ofstream(root / "data" / path) << data.dump(2);
    }
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

TEST_F(AssetDirectory, PreservesRelocatedTextureMembershipWithoutScanningSharedFolders) {
    std::filesystem::remove(root / "data/bundle/texture.json");
    std::filesystem::create_directories(root / "data/textures/shared");
    const Json texture = {
        {"schema_version", 3            },
        {"groups",         Json::array()},
        {"entries",        Json::array()}
    };
    Write("textures/shared/owned.json", texture);
    Write("textures/shared/unrelated.json", texture);
    const Json marker = {
        {"schema_version",  1                                                                                },
        {"kind",            "asset_directory"                                                                },
        {"texture_members", Json::array({{{"name", "texture.json"}, {"path", "textures/shared/owned.json"}}})}
    };
    Write("bundle/pack.json", marker);
    metadata = marker.dump();
    datapacks::Load(root / "data");
    DataReadRegisterAsset(metadata.data(), "bundle/pack.json", metadata.size());
    EXPECT_EQ(AssetDirectoryCount(metadata.data()), 6);
    int   size = 0;
    auto *named = AssetDirectoryRead(metadata.data(), "TEXTURE.JSON", &size);
    ASSERT_NE(named, nullptr);
    EXPECT_EQ(DataReadBufferPath(named), std::optional<std::string>{"textures/shared/owned.json"});
    char *name = nullptr;
    auto *indexed = AssetDirectoryRead(metadata.data(), 5, &name, &size);
    ASSERT_NE(indexed, nullptr);
    EXPECT_STREQ(name, "texture.json");
    EXPECT_EQ(DataReadBufferPath(indexed), std::optional<std::string>{"textures/shared/owned.json"});
    u_int *files[8]{};
    char  *names[8]{};
    EXPECT_EQ(AssetDirectoryReadExtension(metadata.data(), "texture", files, 8, nullptr, names), 1);
    EXPECT_STREQ(names[0], "texture.json");
    EXPECT_EQ(DataReadBufferPath(files[0]), std::optional<std::string>{"textures/shared/owned.json"});
    EXPECT_EQ(AssetDirectoryRead(metadata.data(), "unrelated.json", nullptr), nullptr);
    std::filesystem::create_directories(root / "datapacks/test/textures/shared");
    std::ofstream(root / "datapacks/datapacks.json") << Json({
        {"schema_version", 1       },
        {"load_order",     {"test"}}
    });
    std::ofstream(root / "datapacks/test/textures/shared/owned.json") << "{broken";
    datapacks::Load(root / "data");
    EXPECT_EQ(AssetDirectoryCount(metadata.data()), 6);
    EXPECT_EQ(AssetDirectoryReadExtension(metadata.data(), "texture", files, 8, nullptr, names), 1);
    EXPECT_STREQ(names[0], "texture.json");
    EXPECT_EQ(DataReadBufferPath(files[0]), std::optional<std::string>{"textures/shared/owned.json"});
    std::ofstream(root / "datapacks/test/textures/shared/owned.json") << Json({
        {"schema_version", 3            },
        {"groups",         {3}          },
        {"entries",        Json::array()}
    });
    datapacks::Load(root / "data");
    EXPECT_EQ(AssetDirectoryReadExtension(metadata.data(), "texture", files, 8, nullptr, names), 1);
    EXPECT_EQ(Json::parse(reinterpret_cast<const char *>(files[0]))["groups"], Json::array({3}));
}

TEST_F(AssetDirectory, RejectsInvalidRelocatedTextureMembership) {
    for (const auto &members : {
             Json::array({{{"name", "../escape.json"}, {"path", "textures/shared/owned.json"}}}
             ),
             Json::array({{{"name", "texture.json"}, {"path", "textures/../outside.json"}}}
             ),
             Json::array({{{"name", "texture.json"}, {"path", "other/texture.json"}}}
             ),
             Json::array({{{"name", "texture.json"}, {"path", "textures/a.json"}}, {{"name", "TEXTURE.JSON"}, {"path", "textures/b.json"}}}
             )
    }) {
        const Json marker = {
            {"schema_version",  1                },
            {"kind",            "asset_directory"},
            {"texture_members", members          }
        };
        Write("bundle/pack.json", marker);
        metadata = marker.dump();
        DataReadIndex(root / "data");
        DataReadRegisterAsset(metadata.data(), "bundle/pack.json", metadata.size());
        EXPECT_FALSE(AssetDirectoryPath(metadata.data()));
    }
}

TEST_F(AssetDirectory, ResolvesGameplayMapAndSkyLogicalTextureNames) {
    std::filesystem::create_directories(root / "data/textures/map/a/a01");
    std::filesystem::create_directories(root / "data/textures/map/d/d04/b01");
    const Json texture = {
        {"schema_version", 3            },
        {"groups",         Json::array()},
        {"entries",        Json::array()}
    };
    Write("textures/map/a/a01/a01ia.json", texture);
    Write("textures/map/d/d04/b01/sky0.json", texture);
    const Json marker = {
        {"schema_version",  1                                                                                                                                                        },
        {"kind",            "asset_directory"                                                                                                                                        },
        {"texture_members", Json::array({{{"name", "a01ia.json"}, {"path", "textures/map/a/a01/a01ia.json"}}, {{"name", "sky0.json"}, {"path", "textures/map/d/d04/b01/sky0.json"}}})}
    };
    Write("bundle/pack.json", marker);
    metadata = marker.dump();
    datapacks::Load(root / "data");
    DataReadRegisterAsset(metadata.data(), "bundle/pack.json", metadata.size());
    const Json map = {
        {"kind", "scene_map"                        },
        {"info", {{"texture_packs", {"a01ia.json"}}}}
    };
    const Json sky = {
        {"kind",   "sky"                                              },
        {"images", Json::array({{{"band", 0}, {"file", "sky0.json"}}})}
    };
    const auto  map_name = map["info"]["texture_packs"][0].get<std::string>();
    const auto  sky_name = sky["images"][0]["file"].get<std::string>();
    const auto *map_texture = AssetDirectoryRead(metadata.data(), map_name.c_str(), nullptr);
    const auto *sky_texture = AssetDirectoryRead(metadata.data(), sky_name.c_str(), nullptr);
    ASSERT_NE(map_texture, nullptr);
    ASSERT_NE(sky_texture, nullptr);
    EXPECT_EQ(DataReadBufferPath(map_texture), std::optional<std::string>{"textures/map/a/a01/a01ia.json"});
    EXPECT_EQ(DataReadBufferPath(sky_texture), std::optional<std::string>{"textures/map/d/d04/b01/sky0.json"});
}

TEST_F(AssetDirectory, OwningMembersKeepActualContentsAcrossRepeatedReadsAndDirectoryRelease) {
    auto directory = dc2::io::ReadResourceFile("bundle");
    ASSERT_TRUE(directory);
    auto members = dc2::assets::ReadDirectoryMembers(directory, "bin");
    ASSERT_EQ(members.size(), 1u);
    EXPECT_EQ(members[0].name, "raw.bin");
    EXPECT_EQ(members[0].read.Source(), "bundle/raw.bin");
    ASSERT_EQ(members[0].read.Size(), 3);
    std::ofstream(root / "data/bundle/raw.bin", std::ios::binary) << "xyz";
    auto replacement = dc2::assets::ReadDirectoryMember(directory, "RAW.BIN");
    ASSERT_TRUE(replacement);
    EXPECT_EQ(std::string(reinterpret_cast<const char *>(replacement.Bytes().data()), replacement.Bytes().size()), "xyz");
    directory = {};
    StartReadBG();
    EXPECT_EQ(std::string(reinterpret_cast<const char *>(members[0].read.Bytes().data()), members[0].read.Bytes().size()), "abc");
    EXPECT_EQ(members[0].read.Source(), "bundle/raw.bin");
}

TEST(AssetMemberNames, BoundedPathsKeepTheExactFinalComponent) {
    constexpr char path[] = {'a', '/', 'b', '\\', 'c', '.', 'j', 's', 'o', 'n'};
    const auto     member = dc2::assets::MemberName(std::string_view(path, sizeof(path)));
    EXPECT_EQ(member, "c.json");
    EXPECT_EQ(member.data(), path + 4);
    EXPECT_EQ(dc2::assets::MemberName("bare.json"), "bare.json");
    EXPECT_TRUE(dc2::assets::MemberName("parent/").empty());
    EXPECT_TRUE(dc2::assets::MemberName({}).empty());
}
