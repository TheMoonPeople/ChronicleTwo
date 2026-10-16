#include "common.h"

#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <array>
#include <chrono>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <vector>

#include "character.hpp"
#include "dataread.hpp"
#include "dataread_port.hpp"
#include "fishing.hpp"
#include "menuaqua.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mg_visual.hpp"
#include "mglib.hpp"
#include "platform/datapacks.hpp"
#include "platform/model_assets.hpp"
#include "userdata.hpp"

namespace {
using Json = nlohmann::json;
std::vector<u_long128> texture_storage(16384);
mgCMemory              texture_memory;

/**
 * Loads native fish geometry whose base textures have no proprietary image buffer.
 */
class NativeFishTexture : public testing::Test {
protected:
    std::filesystem::path  root = std::filesystem::temp_directory_path() / ("native_fish_texture_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
    std::filesystem::path  previous = datapacks::Root();
    std::array<char, 1024> previous_directory{};
    std::vector<u_long128> storage = std::vector<u_long128>(16384);
    alignas(16) std::array<u_long128, 128> scratch {};
    mgCMemory      memory;
    CCharacter2    character;
    BREEDFISH_USED fish{};

    static void Write(const std::filesystem::path &path, const Json &document) {
        std::filesystem::create_directories(path.parent_path());
        std::ofstream(path, std::ios::binary) << document.dump(2);
    }

    static Json Texture(int size) {
        return {
            {"schema_version", 3                                                                                                                },
            {"groups",         {0}                                                                                                              },
            {"entries",        Json::array({{{"name", "f01a"}, {"pictures", Json::array({{{"canvas", {{"width", size}, {"height", size}}}}})}}})}
        };
    }

    void SetUp() override {
        GetCurrentDir(previous_directory.data());
        SetCurrentDir(nullptr);
        std::filesystem::create_directories(root / "port_data/models");
        const std::array<float, 9> positions{0, 0, 0, 1, 0, 0, 0, 1, 0};
        std::ofstream              binary(root / "port_data/models/fish.bin", std::ios::binary);
        binary.write(reinterpret_cast<const char *>(positions.data()), sizeof(positions));
        binary.close();
        const Json gltf = {
            {"asset",       {{"version", "2.0"}}                                                                                                               },
            {"scene",       0                                                                                                                                  },
            {"scenes",      Json::array({{{"nodes", {0}}}})                                                                                                    },
            {"nodes",       Json::array({{{"name", "fish"}, {"mesh", 0}}})                                                                                     },
            {"meshes",      Json::array({{{"primitives", Json::array({{{"attributes", {{"POSITION", 0}}}, {"mode", 4}, {"material", 0}}})}}})                  },
            {"materials",   Json::array({{{"pbrMetallicRoughness", {{"baseColorFactor", {1, 1, 1, 1}}}}}})                                                     },
            {"buffers",     Json::array({{{"byteLength", sizeof(positions)}, {"uri", "fish.bin"}}})                                                            },
            {"bufferViews", Json::array({{{"buffer", 0}, {"byteLength", sizeof(positions)}}})                                                                  },
            {"accessors",   Json::array({{{"bufferView", 0}, {"componentType", 5126}, {"count", 3}, {"type", "VEC3"}, {"min", {0, 0, 0}}, {"max", {1, 1, 0}}}})}
        };
        Write(root / "port_data/models/fish.gltf", gltf);
        const Json mesh = {
            {"frame",        0                                                                                                                                                                                   },
            {"vertex_count", 3                                                                                                                                                                                   },
            {"normal_count", 0                                                                                                                                                                                   },
            {"uv_count",     0                                                                                                                                                                                   },
            {"colour_count", 0                                                                                                                                                                                   },
            {"primitives",   Json::array({{{"type", 531}, {"material", 0}, {"source_vertices", {0, 1, 2}}, {"source_normals", Json::array()}, {"source_uvs", Json::array()}, {"source_colours", Json::array()}}})},
            {"materials",    Json::array({{{"texture", "f01a"}, {"diffuse", {1, 1, 1, 1}}, {"ambient", {0, 0, 0, 0}}}})                                                                                          }
        };
        const Json model = {
            {"schema_version",  1                                                                       },
            {"frames",          Json::array({{{"id", 0}, {"name", "fish"}, {"parent", -1}, {"mdt", 0}}})},
            {"meshes",          Json::array({mesh})                                                     },
            {"motion_channels", Json::array()                                                           },
            {"weights",         Json::array()                                                           },
            {"bind_poses",      Json::array()                                                           }
        };
        Json game = {
            {"schema_version", 1                   },
            {"kind",           "character"         },
            {"models",         Json::array({model})}
        };
        game["resources"]["texture_sets"] = Json::array({{{"document", Texture(2)}}});
        const Json image = {
            {"type",  "resource"   },
            {"kind",  "texture_set"},
            {"index", 0            }
        };
        const Json geometry = {
            {"type",  "resource"},
            {"kind",  "model"   },
            {"index", 0         }
        };
        game["profiles"]["info"]["commands"] = Json::array({
            {{"command", "IMG"},     {"args", Json::array({{{"type", "int"}, {"value", 0}}, image})}},
            {{"command", "IMG_END"}, {"args", Json::array()}                                        },
            {{"command", "MODEL"},   {"args", Json::array({geometry})}                              }
        });
        Write(root / "port_data/models/fish.game.json", game);
        Write(root / "port_data/menu/aqua/fish/f01a1.json", Texture(4));
        Write(root / "port_data/menu/aqua/fish/f01a2.json", Texture(8));
        std::filesystem::create_directories(root / "data");
        DataReadIndex(root / "data");
        texture_memory.SetHeapMem(texture_storage.data(), static_cast<int>(texture_storage.size()));
        texture_memory.StartStackMode(MG_STACK_MODE_FIT, static_cast<int>(texture_storage.size()));
        mgTexManager.SetTableBuffer(64, 64, &texture_memory);
        mgTexManager.Initialize(0x1000, -1);
        memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
        character.Initialize();
        model_assets::CharacterLoadOptions options{&memory, &memory, &memory, &mgTexManager, nullptr, 20, false};
        std::string                        error;
        ASSERT_TRUE(model_assets::LoadCharacter(character, "models/fish.gltf", "info", options, error)) << error;
        ASSERT_EQ(character.images[0], nullptr);
        fish.color = 1;
        fish.flags = BREEDFISH_FLAG_RAISED;
        std::memset(scratch.data(), 0xA5, sizeof(scratch));
    }

    void TearDown() override {
        character.DeleteImage();
        mgTexManager.Initialize(0x1000, -1);
        model_assets::Clear();
        if (previous.empty()) {
            DataReadIndex(root / "empty/data");
            datapacks::Clear();
        } else {
            DataReadIndex(previous.parent_path() / "data");
        }
        SetCurrentDir(previous_directory.data());
        std::error_code error;
        std::filesystem::remove_all(root, error);
    }

    mgCVisualMDT *Visual() { return static_cast<mgCVisualMDT *>(character.GetFrame()->visual); }
};
} // namespace

TEST_F(NativeFishTexture, StandaloneJsonReplacesNullImagesAndRebindsExistingGeometry) {
    const auto before = scratch;
    const auto fish_before = fish;
    auto      *frame = character.GetFrame();
    auto      *visual = Visual();
    ASSERT_NE(visual->material[0].texture, nullptr);
    char directory[] = "unrelated/current/";
    SetCurrentDir(directory);
    EXPECT_EQ(FishIMGReplace(scratch.data(), &character, FISH_ITEM_BOUBOU, &fish), 0);
    EXPECT_EQ(character.images[0], nullptr);
    EXPECT_EQ(character.GetFrame(), frame);
    EXPECT_EQ(Visual(), visual);
    char  name[] = "f01a";
    auto *replacement = mgTexManager.GetTexture(name, 20);
    ASSERT_NE(replacement, nullptr);
    EXPECT_EQ(replacement->width, 4);
    EXPECT_EQ(visual->material[0].texture, replacement);
    EXPECT_EQ(std::memcmp(scratch.data(), before.data(), sizeof(scratch)), 0);
    EXPECT_EQ(std::memcmp(&fish, &fish_before, sizeof(fish)), 0);
    char current[1024]{};
    GetCurrentDir(current);
    EXPECT_STREQ(current, directory);
}

TEST_F(NativeFishTexture, RepeatedReplacementsRetainSlotOwnershipForExplicitDeletion) {
    FishIMGReplace(scratch.data(), &character, FISH_ITEM_BOUBOU, &fish);
    fish.color = 2;
    FishIMGReplace(scratch.data(), &character, FISH_ITEM_BOUBOU, &fish);
    char  name[] = "f01a";
    auto *replacement = mgTexManager.GetTexture(name, 20);
    ASSERT_NE(replacement, nullptr);
    EXPECT_EQ(replacement->width, 8);
    EXPECT_EQ(Visual()->material[0].texture, replacement);
    character.DeleteImage();
    EXPECT_EQ(mgTexManager.GetTexture(name, 20), nullptr);
}

TEST_F(NativeFishTexture, ElectricOrUnmappedFishPreserveTheirNativeTexture) {
    auto *texture = Visual()->material[0].texture;
    fish.flags |= BREEDFISH_FLAG_ELECTRIC;
    FishIMGReplace(scratch.data(), &character, FISH_ITEM_BOUBOU, &fish);
    EXPECT_EQ(Visual()->material[0].texture, texture);
    EXPECT_EQ(texture->width, 2);
    fish.flags = 0;
    FishIMGReplace(scratch.data(), &character, -1, &fish);
    EXPECT_EQ(Visual()->material[0].texture, texture);
    EXPECT_EQ(texture->width, 2);
}
