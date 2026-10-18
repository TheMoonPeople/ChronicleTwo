#include "common.h"

#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <array>
#include <chrono>
#include <cmath>
#include <cstdint>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <print>
#include <vector>

#include "character.hpp"
#include "character_motion.hpp"
#include "collision.hpp"
#include "collision_assets.hpp"
#include "dataread_port.hpp"
#include "dng_event.hpp"
#include "dng_hud.hpp"
#include "dng_main.hpp"
#include "dungeon_articles.hpp"
#include "gameutil.hpp"
#include "mdslist.hpp"
#include "menu_character_assets.hpp"
#include "mg_dataset.hpp"
#include "mg_texture_port.hpp"
#include "mg_visual_port.hpp"
#include "mglib.hpp"
#include "platform/arena.hpp"
#include "platform/datapacks.hpp"
#include "platform/model_assets.hpp"
#include "texture_source.hpp"
#include "visualmotion.hpp"

namespace {
using Json = nlohmann::json;

/** Encodes a small synthetic accessor buffer for a standalone glTF fixture. */
std::string Base64(const std::vector<unsigned char> &bytes) {
    constexpr char alphabet[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    std::string    result;
    for (std::size_t index = 0; index < bytes.size(); index += 3) {
        const unsigned int word = (bytes[index] << 16) |
                                  (index + 1 < bytes.size() ? bytes[index + 1] << 8 : 0) |
                                  (index + 2 < bytes.size() ? bytes[index + 2] : 0);
        result += alphabet[(word >> 18) & 63];
        result += alphabet[(word >> 12) & 63];
        result += index + 1 < bytes.size() ? alphabet[(word >> 6) & 63] : '=';
        result += index + 2 < bytes.size() ? alphabet[word & 63] : '=';
    }
    return result;
}

/** Provides an isolated native model catalog, embedded glTF and game allocation arena. */
class NativeModel : public testing::Test {
protected:
    std::filesystem::path  directory;
    std::vector<u_long128> storage;
    mgCMemory              memory;
    Json                   gltf;
    Json                   game;

    void SetUp() override {
        directory = std::filesystem::temp_directory_path() / ("chronicle_native_model_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
        std::filesystem::create_directories(directory / "data/models");
        storage.resize(16384);
        memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
        const std::vector<float>   values{0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 1, 0, 0, 0, 30, 0, 0};
        std::vector<unsigned char> bytes(values.size() * sizeof(float));
        std::memcpy(bytes.data(), values.data(), bytes.size());
        gltf = {
            {"asset",       {{"version", "2.0"}}                                                                                                                                                                                                                                                                                                         },
            {"scene",       0                                                                                                                                                                                                                                                                                                                            },
            {"scenes",      Json::array({{{"nodes", {0}}}})                                                                                                                                                                                                                                                                                              },
            {"nodes",       Json::array({{{"name", "root"}, {"mesh", 0}}})                                                                                                                                                                                                                                                                               },
            {"meshes",      Json::array({{{"primitives", Json::array({{{"attributes", {{"POSITION", 0}}}, {"mode", 4}, {"material", 0}}})}}})                                                                                                                                                                                                            },
            {"materials",   Json::array({{{"pbrMetallicRoughness", {{"baseColorFactor", {1, 1, 1, 1}}}}}})                                                                                                                                                                                                                                               },
            {"buffers",     Json::array({{{"byteLength", bytes.size()}, {"uri", "data:application/octet-stream;base64," + Base64(bytes)}}})                                                                                                                                                                                                              },
            {"bufferViews", Json::array({{{"buffer", 0}, {"byteOffset", 0}, {"byteLength", 36}}, {{"buffer", 0}, {"byteOffset", 36}, {"byteLength", 8}}, {{"buffer", 0}, {"byteOffset", 44}, {"byteLength", 24}}})                                                                                                                                       },
            {"accessors",   Json::array({{{"bufferView", 0}, {"componentType", 5126}, {"count", 3}, {"type", "VEC3"}, {"min", {0, 0, 0}}, {"max", {2, 2, 0}}}, {{"bufferView", 1}, {"componentType", 5126}, {"count", 2}, {"type", "SCALAR"}, {"min", {0}}, {"max", {1}}}, {{"bufferView", 2}, {"componentType", 5126}, {"count", 2}, {"type", "VEC3"}}})},
            {"animations",  Json::array({{{"name", "fixture/model.mot"}, {"samplers", Json::array({{{"input", 1}, {"output", 2}, {"interpolation", "LINEAR"}}})}, {"channels", Json::array({{{"sampler", 0}, {"target", {{"node", 0}, {"path", "translation"}}}}})}}})                                                                                   }
        };
        const Json metadata = {
            {"schema_version",  1                                                                                                                                                                                                                                                                                                                                                                                                                         },
            {"source",          "fixture/model.mds"                                                                                                                                                                                                                                                                                                                                                                                                       },
            {"frames",          Json::array({{{"id", 0}, {"name", "root"}, {"parent", -1}, {"mdt", 0}}})                                                                                                                                                                                                                                                                                                                                                  },
            {"meshes",          Json::array({{{"frame", 0}, {"vertex_count", 3}, {"normal_count", 0}, {"uv_count", 0}, {"colour_count", 0}, {"primitives", Json::array({{{"type", 531}, {"material", 0}, {"source_vertices", {0, 1, 2}}, {"source_normals", Json::array()}, {"source_uvs", Json::array()}, {"source_colours", Json::array()}}})}, {"materials", Json::array({{{"texture", ""}, {"diffuse", {1, 1, 1, 1}}, {"ambient", {0, 0, 0, 0}}}})}}})},
            {"motion_channels", Json::array()                                                                                                                                                                                                                                                                                                                                                                                                             },
            {"weights",         Json::array()                                                                                                                                                                                                                                                                                                                                                                                                             },
            {"bind_poses",      Json::array()                                                                                                                                                                                                                                                                                                                                                                                                             }
        };
        game = metadata;
        Write(directory / "data/models/model.gltf", gltf);
        Write(directory / "data/models/model.game.json", game);
        datapacks::Load(directory / "data");
        std::string error;
    }

    void TearDown() override {
        model_assets::Clear();
        datapacks::Clear();

        std::filesystem::remove_all(directory);
    }

    void Write(const std::filesystem::path &path, const Json &value) {
        std::ofstream(path) << value.dump(2);
        if (path.filename() == "model.gltf") {
            std::ofstream(directory / "data/models/model.game.json") << game.dump(2);
        }
    }

    mgCFrame *Instantiate() {
        mgLoadData load{};
        load.memory = &memory;
        std::string error;
        auto       *frame = model_assets::LoadModel(std::filesystem::path("models/model.gltf"), load, error);
        EXPECT_NE(frame, nullptr) << error;
        return frame;
    }

    tagMOTION_TYPE Motion() {
        tagMOTION_TYPE motion{};
        std::string    error;
        EXPECT_TRUE(model_assets::LoadAnimation(std::filesystem::path("models/model.gltf"), motion, memory, 0, std::nullopt, std::nullopt, std::nullopt, error)) << error;
        return motion;
    }
};
} // namespace

TEST_F(NativeModel, DistinctModelDocumentsReuseIdenticalEmbeddedTexturesWithinTableCapacity) {
    std::vector<u_long128> texture_storage(4096);
    mgCMemory              texture_memory;
    mgCTextureManager      textures;
    texture_memory.stSetBuffer(texture_storage.data(), static_cast<int>(texture_storage.size()));
    textures.SetTableBuffer(2, 8, &texture_memory);
    textures.Initialize(0x1000, -1);
    game["meshes"][0]["materials"][0]["texture"] = "shared";
    game["texture_sets"] = Json::array({
        {{"document", {{"schema_version", 3}, {"groups", {0}}, {"entries", Json::array({{{"name", "shared"}, {"pictures", Json::array({{{"canvas", {{"width", 2}, {"height", 2}}}}})}}})}}}}
    });
    mgCTexture *original = nullptr;
    for (int index = 0; index < 80; ++index) {
        const std::string stem = "models/scene" + std::to_string(index);
        Write(directory / "data" / (stem + ".gltf"), gltf);
        Write(directory / "data" / (stem + ".game.json"), game);
        memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
        mgLoadData load{};
        load.memory = &memory;
        load.texture_manager = &textures;
        std::string error;
        auto       *frame = model_assets::LoadModel(stem + ".gltf", load, error);
        ASSERT_NE(frame, nullptr) << error;
        auto *texture = frame->visual->GetMaterial(0)->texture;
        ASSERT_NE(texture, nullptr) << index;
        if (!original) {
            original = texture;
        }
        EXPECT_EQ(texture, original);
        EXPECT_EQ(textures.texture_num, 1);
    }
    textures.Initialize(0x1000, -1);
}

TEST_F(NativeModel, CharacterTextureOwnershipDoesNotSkipDeletedReinitializedOrSuffixedRegistrations) {
    Json model = game;
    model["texture_sets"] = {0};
    model["meshes"][0]["materials"][0]["texture"] = "shared";
    const Json resource{
        {"type",  "resource"},
        {"kind",  "model"   },
        {"index", 0         }
    };
    const Json textures_document{
        {"schema_version", 3                                                                                                            },
        {"groups",         {0}                                                                                                          },
        {"entries",        Json::array({{{"name", "shared"}, {"pictures", Json::array({{{"canvas", {{"width", 2}, {"height", 2}}}}})}}})}
    };
    game = {
        {"schema_version",  1                                                                                                   },
        {"kind",            "character"                                                                                         },
        {"default_profile", "info"                                                                                              },
        {"models",          Json::array({model})                                                                                },
        {"resources",       {{"texture_sets", Json::array({{{"document", textures_document}}})}}                                },
        {"profiles",        {{"info", {{"commands", Json::array({{{"command", "MODEL"}, {"args", Json::array({resource})}}})}}}}}
    };
    Write(directory / "data/models/model.gltf", gltf);
    std::vector<u_long128> texture_storage(4096);
    mgCMemory              texture_memory;
    mgCTextureManager      textures;
    texture_memory.stSetBuffer(texture_storage.data(), static_cast<int>(texture_storage.size()));
    textures.SetTableBuffer(8, 8, &texture_memory);
    textures.Initialize(0x1000, -1);
    CCharacter2                        character;
    model_assets::CharacterLoadOptions options{.model_memory = &memory, .motion_memory = &memory, .image_memory = &memory, .textures = &textures, .parent = nullptr, .texture_block = 2, .outline = false};
    std::string                        error;
    auto                               load = [&] {
        character.Initialize();
        memory.stReset();
        return model_assets::LoadCharacter(character, "models/model.gltf", "info", options, error);
    };
    ASSERT_TRUE(load()) << error;
    char  name[] = "shared";
    auto *initial = textures.GetTexture(name, 2);
    ASSERT_NE(initial, nullptr);
    EXPECT_EQ(character.GetFrame()->visual->GetMaterial(0)->texture, initial);
    textures.DeleteBlock(2);
    EXPECT_EQ(textures.GetTexture(name, 2), nullptr);
    ASSERT_TRUE(load()) << error;
    ASSERT_NE(textures.GetTexture(name, 2), nullptr);
    EXPECT_EQ(textures.texture_num, 1);
    textures.Initialize(0x1000, -1);
    ASSERT_TRUE(load()) << error;
    auto *plain = textures.GetTexture(name, 2);
    ASSERT_NE(plain, nullptr);
    std::strcpy(textures.name_suffix, "_menu");
    ASSERT_TRUE(load()) << error;
    auto *suffixed = textures.GetTexture(name, 2);
    ASSERT_NE(suffixed, nullptr);
    EXPECT_NE(suffixed, plain);
    EXPECT_STREQ(suffixed->name, "shared_menu");
    EXPECT_EQ(character.GetFrame()->visual->GetMaterial(0)->texture, suffixed);
    EXPECT_EQ(textures.texture_num, 2);
    model_assets::DeleteCharacterTextures(character, 0, 0);
    EXPECT_EQ(textures.GetTexture(name, 2), nullptr);
    EXPECT_EQ(textures.SearchHash(name, 2), nullptr);
    EXPECT_EQ(textures.texture_num, 0);
    textures.Initialize(0x1000, -1);
}

TEST_F(NativeModel, StaleCharacterImagesKeepAnotherModelsSameNamedTexture) {
    // The item menu loads the Ridepod rider and then Max's hat into one slot: the rider's stale images must not delete
    // the face Max entered under the same name after the block was cleared and the slot reinitialised.
    Json model = game;
    model["texture_sets"] = {0};
    model["meshes"][0]["materials"][0]["texture"] = "shared";
    const Json resource{
        {"type",  "resource"},
        {"kind",  "model"   },
        {"index", 0         }
    };
    const Json textures_document{
        {"schema_version", 3                                                                                                            },
        {"groups",         {0}                                                                                                          },
        {"entries",        Json::array({{{"name", "shared"}, {"pictures", Json::array({{{"canvas", {{"width", 2}, {"height", 2}}}}})}}})}
    };
    game = {
        {"schema_version",  1                                                                                                   },
        {"kind",            "character"                                                                                         },
        {"default_profile", "info"                                                                                              },
        {"models",          Json::array({model})                                                                                },
        {"resources",       {{"texture_sets", Json::array({{{"document", textures_document}}})}}                                },
        {"profiles",        {{"info", {{"commands", Json::array({{{"command", "MODEL"}, {"args", Json::array({resource})}}})}}}}}
    };
    Write(directory / "data/models/model.gltf", gltf);
    Write(directory / "data/models/other.gltf", gltf);
    Write(directory / "data/models/other.game.json", game);
    std::vector<u_long128> texture_storage(4096);
    mgCMemory              texture_memory;
    mgCTextureManager      textures;
    texture_memory.stSetBuffer(texture_storage.data(), static_cast<int>(texture_storage.size()));
    textures.SetTableBuffer(8, 8, &texture_memory);
    textures.Initialize(0x1000, -1);
    std::strcpy(textures.name_suffix, "_menu");
    CCharacter2                        stale_slot;
    CCharacter2                        max;
    model_assets::CharacterLoadOptions options{.model_memory = &memory, .motion_memory = &memory, .image_memory = &memory, .textures = &textures, .parent = nullptr, .texture_block = 2, .outline = false};
    std::string                        error;
    stale_slot.Initialize();
    memory.stReset();
    ASSERT_TRUE(model_assets::LoadCharacter(stale_slot, "models/other.gltf", "info", options, error)) << error;
    textures.DeleteBlock(2);
    stale_slot.Initialize();
    max.Initialize();
    ASSERT_TRUE(model_assets::LoadCharacter(max, "models/model.gltf", "info", options, error)) << error;
    char name[] = "shared_menu";
    textures.name_suffix[0] = 0;
    auto *face = textures.GetTexture(name, 2);
    ASSERT_NE(face, nullptr);
    EXPECT_EQ(max.GetFrame()->visual->GetMaterial(0)->texture, face);
    model_assets::DeleteCharacterTextures(stale_slot, 0, 0);
    EXPECT_EQ(textures.GetTexture(name, 2), face);
    EXPECT_EQ(max.GetFrame()->visual->GetMaterial(0)->texture, face);
    model_assets::DeleteCharacterTextures(max, 0, 0);
    EXPECT_EQ(textures.GetTexture(name, 2), nullptr);
    textures.Initialize(0x1000, -1);
}

TEST_F(NativeModel, MenuCostumeArenaUsesActualNativeCountsInsteadOfRetailPartitionSize) {
    Json model = game;
    model["meshes"][0]["vertex_count"] = 20000;
    const Json resource{
        {"type",  "resource"},
        {"kind",  "model"   },
        {"index", 0         }
    };
    game = {
        {"schema_version",  1                                                                                                   },
        {"kind",            "character"                                                                                         },
        {"default_profile", "info"                                                                                              },
        {"models",          Json::array({model})                                                                                },
        {"resources",       {{"texture_sets", Json::array()}}                                                                   },
        {"profiles",        {{"info", {{"commands", Json::array({{{"command", "MODEL"}, {"args", Json::array({resource})}}})}}}}}
    };
    Write(directory / "data/models/model.gltf", gltf);
    constexpr int retail_capacity = 0x1b80;
    static char   retail_owner;
    auto         *retail = reinterpret_cast<u_long128 *>(ArenaBlock(&retail_owner, (retail_capacity + 1) * sizeof(u_long128)));
    std::memset(retail, 0xa5, (retail_capacity + 1) * sizeof(u_long128));
    const std::vector<u_long128> before(retail, retail + retail_capacity + 1);
    mgCMemory                    slot;
    slot.stSetBuffer(retail, retail_capacity);
    ASSERT_EQ(slot.stack, retail);
    ASSERT_EQ(slot.stack_size, retail_capacity);
    std::string error;
    const auto  estimate = model_assets::EstimateCharacterMemory("models/model.gltf", "info", error);
    ASSERT_TRUE(estimate) << error;
    ASSERT_GT(*estimate, static_cast<std::size_t>(retail_capacity) * sizeof(u_long128));
    ASSERT_TRUE(menu_character::PrepareArena(slot, "models/model.gltf", "info", error)) << error;
    EXPECT_NE(slot.stack, retail);
    auto       *native_storage = slot.stack;
    CCharacter2 character;
    character.Initialize();
    model_assets::CharacterLoadOptions options{.model_memory = &slot, .motion_memory = &slot, .image_memory = &slot, .textures = nullptr, .parent = nullptr, .texture_block = 0, .outline = false};
    ASSERT_TRUE(model_assets::LoadCharacter(character, "models/model.gltf", "info", options, error)) << error;
    ASSERT_NE(character.GetFrame(), nullptr);
    EXPECT_GT(slot.stack_used, retail_capacity);
    EXPECT_LT(slot.stack_used, slot.stack_size);
    EXPECT_EQ(std::memcmp(retail, before.data(), before.size() * sizeof(u_long128)), 0);
    EXPECT_FALSE(menu_character::PrepareArena(slot, "models/model.gltf", "info", error));
    EXPECT_EQ(slot.stack, native_storage);
    slot.stReset();
    ASSERT_TRUE(menu_character::PrepareArena(slot, "models/model.gltf", "info", error)) << error;
    EXPECT_EQ(slot.stack, native_storage);
}

namespace {
/** Typed profile argument helpers for named-action fixtures. */
Json IntegerArgument(int value) {
    return {
        {"type",  "int"},
        {"value", value}
    };
}

Json RealArgument(float value) {
    return {
        {"type",  "float"},
        {"value", value  }
    };
}

Json TextArgument(const char *value) {
    return {
        {"type",  "string"},
        {"value", value   }
    };
}

Json AnimationArgument(int index) {
    return {
        {"type",  "resource" },
        {"kind",  "animation"},
        {"index", index      }
    };
}

/** Builds a character whose motion set plays the fixture clip as two named actions and publishes an external one. */
Json NamedActionCharacter(const Json &model, const Json &commands) {
    return {
        {"schema_version",  1                                                                                        },
        {"kind",            "character"                                                                              },
        {"default_profile", "info"                                                                                   },
        {"models",          Json::array({model})                                                                     },
        {"game_names",      {{"idle", TextArgument("\xE7\xAB\x8B\xE3\x81\xA1")}, {"walk", TextArgument("walk_game")}}},
        {"profiles",        {{"info", {{"commands", commands}}}}                                                     },
        {"resources",
         {{"animations",
           Json::array({{{"actions", Json::array({{{"name", "idle"}, {"duration", 10}}, {{"name", "walk"}, {"duration", 30}}})},
                         {"variants", Json::array({{{"model", 0}, {"node_offset", 0}, {"animations", {0, 0}}}})}},
                        {{"external", "models/wave.gltf#0"},
                         {"actions", Json::array({{{"name", "wave"}, {"duration", 30}, {"channels", Json::array()}}})},
                         {"variants", Json::array({{{"model", 0}, {"node_offset", 0}, {"animations", {0}}}})}}})}}   }
    };
}

/** Loads the named-action character and returns whether it succeeded. */
bool LoadNamedActionCharacter(CCharacter2 &character, const Json &gltf, const Json &game, mgCMemory &memory, std::string &error) {
    model_assets::CharacterLoadOptions options{.model_memory = &memory, .motion_memory = &memory, .image_memory = &memory};
    options.outline = false;
    const auto bytes = gltf.dump();
    return model_assets::LoadCharacter(character, {reinterpret_cast<const std::byte *>(bytes.data()), bytes.size()}, game, "info", options, error);
}

} // namespace

TEST_F(NativeModel, KeysSelectNamedActionsInProfileOrderWithDisjointGameFrames) {
    const Json  commands = Json::array({
        {{"command", "MODEL"},     {"args", {{{"type", "resource"}, {"kind", "model"}, {"index", 0}}}}                        },
        {{"command", "MOTION"},    {"args", {IntegerArgument(0), AnimationArgument(0)}}                                       },
        {{"command", "KEY_START"}, {"args", Json::array()}                                                                    },
        {{"command", "KEY"},       {"args", {TextArgument("idle"), RealArgument(.5f)}}                                        },
        {{"command", "KEY"},       {"args", {TextArgument("walk"), RealArgument(1)}}                                          },
        {{"command", "KEY_END"},   {"args", Json::array()}                                                                    },
        {{"command", "SE_START"},  {"args", {IntegerArgument(1)}}                                                             },
        {{"command", "SE"},        {"args", {TextArgument("walk"), IntegerArgument(0), IntegerArgument(3), RealArgument(.5f)}}},
        {{"command", "SE_END"},    {"args", Json::array()}                                                                    }
    });
    CCharacter2 character;
    character.Initialize();
    std::string error;
    ASSERT_TRUE(LoadNamedActionCharacter(character, gltf, NamedActionCharacter(game, commands), memory, error)) << error;
    // The game sees each action under its original name, in KEY order, on its own game frames.
    auto *idle = character.GetKeyListIndexPtr(0, nullptr);
    auto *walk = character.GetKeyListIndexPtr(1, nullptr);
    ASSERT_NE(idle, nullptr);
    ASSERT_NE(walk, nullptr);
    EXPECT_STREQ(idle->name, "\x97\xA7\x82\xBF");
    EXPECT_STREQ(walk->name, "walk_game");
    EXPECT_EQ(idle->start_frame, 2);
    EXPECT_EQ(idle->end_frame, 12);
    EXPECT_EQ(walk->start_frame, 14);
    EXPECT_EQ(walk->end_frame, 44);
    EXPECT_FLOAT_EQ(walk->step, 1);
    EXPECT_EQ(character.GetKeyListPtr(const_cast<char *>("walk_game"), nullptr), walk);
    // A sound's ratio lands on its action's game frames.
    ASSERT_NE(character.se_list[0], nullptr);
    EXPECT_FLOAT_EQ(character.se_list[0][0].frame, 14 + 15);
    auto *root = character.CObjectFrame::frame;
    SetMotionTime(root, &character.motion[0], 14 + 7, nullptr);
    EXPECT_NEAR(root->trans_matrix[3][0], 7, 1e-4f);
    SetMotionTime(root, &character.motion[0], 2 + 4, nullptr);
    EXPECT_NEAR(root->trans_matrix[3][0], 4, 1e-4f);
    // A blend within one action interpolates both of its samples as the game does.
    ChangeMotion(root, &character.motion[0], 14 + 10, 14 + 20, .5f, nullptr);
    EXPECT_NEAR(root->trans_matrix[3][0], 15, 1e-4f);
}

TEST_F(NativeModel, ExternalMotionPlaysActionsPublishedIntoTheCharacterModelAndBlendsAcrossSets) {
    const Json  base_commands = Json::array({
        {{"command", "MODEL"},     {"args", {{{"type", "resource"}, {"kind", "model"}, {"index", 0}}}}},
        {{"command", "MOTION"},    {"args", {IntegerArgument(0), AnimationArgument(0)}}               },
        {{"command", "KEY_START"}, {"args", Json::array()}                                            },
        {{"command", "KEY"},       {"args", {TextArgument("idle"), RealArgument(.5f)}}                },
        {{"command", "KEY"},       {"args", {TextArgument("walk"), RealArgument(1)}}                  },
        {{"command", "KEY_END"},   {"args", Json::array()}                                            }
    });
    CCharacter2 character;
    character.Initialize();
    std::string error;
    ASSERT_TRUE(LoadNamedActionCharacter(character, gltf, NamedActionCharacter(game, base_commands), memory, error)) << error;
    const Json extension = {
        {"schema_version",  1                                                                                                                                                                          },
        {"kind",            "character"                                                                                                                                                                },
        {"default_profile", "info"                                                                                                                                                                     },
        {"models",          Json::array()                                                                                                                                                              },
        {"game_names",      {{"wave", TextArgument("wave_game")}}                                                                                                                                      },
        {"resources",       {{"animations", Json::array({{{"external", "models/wave.gltf#0"}, {"actions", Json::array({{{"name", "wave"}, {"duration", 30}}})}, {"targets", {"models/model.gltf"}}}})}}},
        {"profiles",
         {{"info",
           {{"commands", Json::array({{{"command", "MOTION"}, {"args", {IntegerArgument(1), AnimationArgument(0)}}},
                                      {{"command", "KEY_START"}, {"args", Json::array()}},
                                      {{"command", "KEY"}, {"args", {TextArgument("wave"), RealArgument(1)}}},
                                      {{"command", "KEY_END"}, {"args", Json::array()}}})}}}}                                                                                                          }
    };
    const Json empty = {
        {"asset", {{"version", "2.0"}}}
    };
    ASSERT_TRUE(LoadNamedActionCharacter(character, empty, extension, memory, error)) << error;
    auto *wave = character.GetKeyListPtr(const_cast<char *>("wave_game"), nullptr);
    ASSERT_NE(wave, nullptr);
    // Extension actions continue after every game frame the base set uses.
    EXPECT_EQ(wave->start_frame, 46);
    EXPECT_EQ(wave->end_frame, 76);
    auto *root = character.CObjectFrame::frame;
    SetMotionTime(root, &character.motion[1], 46 + 20, nullptr);
    EXPECT_NEAR(root->trans_matrix[3][0], 20, 1e-4f);
    // The blend source is the action last posed, even from another motion set.
    SetMotionTime(root, &character.motion[0], 2 + 10, nullptr);
    EXPECT_NEAR(root->trans_matrix[3][0], 10, 1e-4f);
    ChangeMotion(root, &character.motion[1], 2 + 10, 46 + 20, .5f, nullptr);
    EXPECT_NEAR(root->trans_matrix[3][0], 15, 1e-4f);
    character.DeleteExtMotion();
    EXPECT_TRUE(character_motion::Actions(character.motion[1]).empty());
    EXPECT_FALSE(character_motion::Actions(character.motion[0]).empty());
}

TEST_F(NativeModel, ProfilesNamingUnknownActionsOrMissingExternalActionsFail) {
    const Json  commands = Json::array({
        {{"command", "MODEL"},     {"args", {{{"type", "resource"}, {"kind", "model"}, {"index", 0}}}}},
        {{"command", "MOTION"},    {"args", {IntegerArgument(0), AnimationArgument(0)}}               },
        {{"command", "KEY_START"}, {"args", Json::array()}                                            },
        {{"command", "KEY"},       {"args", {TextArgument("run"), RealArgument(1)}}                   },
        {{"command", "KEY_END"},   {"args", Json::array()}                                            }
    });
    CCharacter2 character;
    character.Initialize();
    std::string error;
    EXPECT_FALSE(LoadNamedActionCharacter(character, gltf, NamedActionCharacter(game, commands), memory, error));
    EXPECT_NE(error.find("KEY names no action"), std::string::npos) << error;
    auto external = NamedActionCharacter(game, Json::array({
                                                   {{"command", "MODEL"},  {"args", {{{"type", "resource"}, {"kind", "model"}, {"index", 0}}}}},
                                                   {{"command", "MOTION"}, {"args", {IntegerArgument(1), AnimationArgument(2)}}               }
    }));
    external["resources"]["animations"].push_back({
        {"external", "models/elsewhere.gltf#0"                          },
        {"actions",  Json::array({{{"name", "wave"}, {"duration", 30}}})},
        {"targets",  Json::array()                                      }
    });
    CCharacter2 other;
    other.Initialize();
    EXPECT_FALSE(LoadNamedActionCharacter(other, gltf, external, memory, error));
    EXPECT_NE(error.find("lacks the actions of external motion models/elsewhere.gltf#0"), std::string::npos) << error;
}

TEST_F(NativeModel, BuildsNativeFramesAndStreamsWithoutRetailRecords) {
    auto *frame = Instantiate();
    ASSERT_NE(frame, nullptr);
    EXPECT_STREQ(frame->name, "root");
    EXPECT_EQ(frame->frame_num, 1);
    auto *visual = static_cast<mgCVisualMDT *>(frame->visual);
    ASSERT_NE(visual, nullptr);
    EXPECT_EQ(visual->vertex_num, 3);
    EXPECT_FLOAT_EQ(visual->vertex[1][0], 2);
    EXPECT_FLOAT_EQ(visual->vertex[2][1], 2);
    ASSERT_NE(visual->face_group, nullptr);
    EXPECT_EQ(visual->face_group->face->vertex_num, 3);
}

TEST_F(NativeModel, SelectsStandardScenesByNameAcrossDifferentBundleOrders) {
    const auto metadata = game;
    gltf["nodes"].push_back({
        {"name",        "cursor" },
        {"mesh",        0        },
        {"translation", {9, 0, 0}}
    });
    gltf["scenes"] = Json::array({
        {{"name", "alert"},  {"nodes", {0}}},
        {{"name", "cursor"}, {"nodes", {1}}}
    });
    auto first = metadata;
    auto second = metadata;
    first["scene"] = 0;
    second["scene"] = 1;
    second["node_offset"] = 1;
    game = {
        {"schema_version", 1                           },
        {"models",         Json::array({first, second})},
        {"profiles",       Json::object()              },
        {"resources",      Json::object()              }
    };
    for (int order = 0; order < 2; ++order) {
        Write(directory / "data/models/model.gltf", gltf);
        mgLoadData load{};
        load.memory = &memory;
        std::string error;
        auto       *frame = model_assets::LoadModelScene("models/model.gltf", "cursor", load, error);
        ASSERT_NE(frame, nullptr) << error;
        EXPECT_STREQ(frame->name, "cursor");
        EXPECT_FLOAT_EQ(frame->trans_matrix[3][0], 9);
        EXPECT_EQ(frame->frame_num, 1);
        EXPECT_EQ(model_assets::LoadModelScene("models/model.gltf", "missing", load, error), nullptr);
        EXPECT_FALSE(error.empty());
        std::swap(gltf["scenes"][0], gltf["scenes"][1]);
        game["models"][0]["scene"] = 1;
        game["models"][1]["scene"] = 0;
        model_assets::Clear();
    }
}

TEST_F(NativeModel, SelectsNondefaultStandardScenesWithoutGameplayJson) {
    auto standard = gltf;
    standard["asset"]["generator"] = "Kazarov";
    standard["nodes"] = Json::array({
        {{"name", "other"}, {"mesh", 0}},
        {{"name", "cursor"}, {"mesh", 0}, {"translation", {9, 0, 0}}, {"children", {3}}},
        {{"name", "second_root"}, {"mesh", 0}, {"translation", {99, 0, 0}}},
        {{"name", "cursor_child"}, {"mesh", 0}, {"translation", {2, 0, 0}}}
    });
    standard["scenes"] = Json::array({
        {{"name", "other"},  {"nodes", {0}}},
        {{"name", "cursor"}, {"nodes", {1}}}
    });
    const auto path = directory / "data/models/standard.gltf";
    Write(path, standard);
    ASSERT_FALSE(std::filesystem::exists(directory / "data/models/standard.game.json"));
    mgLoadData load{};
    load.memory = &memory;
    std::string error;
    auto       *frame = model_assets::LoadModelScene("models/standard.gltf", "cursor", load, error);
    ASSERT_NE(frame, nullptr) << error;
    EXPECT_STREQ(frame->name, "cursor");
    EXPECT_EQ(frame->frame_num, 2);
    EXPECT_TRUE(model_assets::UsesStandardScaleOrder(frame));
    ASSERT_NE(frame->child, nullptr);
    EXPECT_STREQ(frame->child->name, "cursor_child");
    float world[4][4];
    frame->child->GetLWMatrix(world);
    EXPECT_FLOAT_EQ(world[3][0], 11);
    char other_name[] = "other";
    EXPECT_EQ(frame->SearchFrame(other_name), nullptr);
    auto *default_frame = model_assets::LoadModel("models/standard.gltf", load, error);
    ASSERT_NE(default_frame, nullptr) << error;
    EXPECT_STREQ(default_frame->name, "other");
    standard["scenes"][1]["nodes"] = {1, 2};
    Write(path, standard);
    model_assets::Clear();
    frame = model_assets::LoadModelScene("models/standard.gltf", "cursor", load, error);
    ASSERT_NE(frame, nullptr) << error;
    EXPECT_EQ(frame->frame_num, 4);
    char  second_name[] = "second_root";
    auto *second = frame->SearchFrame(second_name);
    ASSERT_NE(second, nullptr);
    second->GetLWMatrix(world);
    EXPECT_FLOAT_EQ(world[3][0], 99);
    standard["scenes"][0]["name"] = "cursor";
    Write(path, standard);
    model_assets::Clear();
    EXPECT_EQ(model_assets::LoadModelScene("models/standard.gltf", "cursor", load, error), nullptr);
    EXPECT_NE(error.find("ambiguous"), std::string::npos);
    EXPECT_EQ(model_assets::LoadModelScene("models/standard.gltf", "missing", load, error), nullptr);
    EXPECT_NE(error.find("missing"), std::string::npos);
}

TEST_F(NativeModel, DungeonArticlesLoadNamedScenesAndAllDirectChildCharacters) {
    const auto metadata = game;
    constexpr std::array<const char *, 6> scenes{"bikkuri_aka", "bteffe_att_a", "bteffe_att_b", "bteffe_att_c", "bteffe_cyc", "cursor"};
    auto                                  bundle = gltf;
    bundle["nodes"] = Json::array();
    bundle["scenes"] = Json::array();
    Json models = Json::array();
    for (std::size_t index = 0; index < scenes.size(); ++index) {
        bundle["nodes"].push_back({
            {"name", scenes[index]},
            {"mesh", 0            }
        });
        bundle["scenes"].push_back({
            {"name",  scenes[index]},
            {"nodes", {index}      }
        });
        auto model = metadata;
        model["scene"] = index;
        model["node_offset"] = index;
        models.push_back(std::move(model));
    }
    const auto publish = [&](const std::string &relative, const Json &asset, const Json &semantics) {
        auto path = directory / "data" / relative;
        std::filesystem::create_directories(path.parent_path());
        Write(path, asset);
        path.replace_extension(".game.json");
        Write(path, semantics);
    };
    publish("dungeon/articles/pack01_1.gltf", bundle, {
                                                          {"schema_version", 1             },
                                                          {"models",         models        },
                                                          {"profiles",       Json::object()},
                                                          {"resources",      Json::object()}
    });
    auto character_model = metadata;
    character_model["scene"] = 0;
    const Json character = {
        {"schema_version", 1                                                                                                                                     },
        {"models",         Json::array({character_model})                                                                                                        },
        {"resources",      Json::object()                                                                                                                        },
        {"profiles",       {{"info", {{"commands", Json::array({{{"command", "MODEL"}, {"args", {{{"type", "resource"}, {"kind", "model"}, {"index", 0}}}}}})}}}}}
    };
    publish("dungeon/articles/pack01_1.assets/giostone.gltf", gltf, character);
    publish("dungeon/articles/pack01_1.assets/ring_loop.gltf", gltf, character);
    constexpr std::array<const char *, 18> items{
        "seisui", "bom", "isi", "maseki_hi", "maseki_rei", "maseki_rai", "maseki_kaze", "maseki_sei", "tokimeki",
        "isi_berry", "neba_momo", "bom_nattu", "dokuring", "m_banana", "gift_cp", "bom_kai", "f_bom", "denkou"};
    for (const auto *item : items) {
        auto profile = character;
        if (std::string_view(item) == "seisui") {
            profile["profiles"]["info"]["commands"].push_back({
                {"command", "IMG_END"    },
                {"args",    Json::array()}
            });
        }
        publish(std::string("dungeon/articles/item01b.assets/") + item + ".gltf", gltf, profile);
    }
    const int previous_language = LanguageCode;
    auto     *previous_memory = MainBuffer__2;
    LanguageCode = 1;
    MainBuffer__2 = &memory;
    const bool loaded = PortLoadDungeonArticleModels();
    LanguageCode = previous_language;
    MainBuffer__2 = previous_memory;
    ASSERT_TRUE(loaded);
    ASSERT_NE(LockOnModel.frame, nullptr);
    EXPECT_STREQ(LockOnModel.frame->name, "cursor");
    EXPECT_TRUE(LockOnModel.frame->attr->no_light);
    ASSERT_NE(RedMarkModel, nullptr);
    ASSERT_NE(RedMarkModel->frame, nullptr);
    EXPECT_STREQ(RedMarkModel->frame->name, "bikkuri_aka");
    EXPECT_NE(GeoStone.GetFrame(), nullptr);
    EXPECT_NE(RandomCircle.model.GetFrame(), nullptr);
    for (const auto *model : SparcModel) {
        ASSERT_NE(model, nullptr);
    }
    EXPECT_NE(TornadoModel, nullptr);
    for (std::size_t index = 0; index < items.size(); ++index) {
        EXPECT_NE(ItemBaseData[index].GetFrame(), nullptr) << items[index];
        EXPECT_EQ(ItemBaseData[index].texture_block, index == 0 ? 0x68 : 0);
    }
}

TEST_F(NativeModel, PreservesEscapedGameNamesAndUntexturedNullMetadata) {
    Json metadata = game;
    metadata["frames"][0]["name"] = "%81%5C";
    metadata["meshes"][0]["materials"][0]["texture_source"] = nullptr;
    metadata["meshes"][0]["materials"][0]["texture_path"] = nullptr;
    gltf["nodes"][0]["name"] = "%81%5C";
    Write(directory / "data/models/model.gltf", gltf);
    game = metadata;
    Write(directory / "data/models/model.gltf", gltf);
    auto *frame = Instantiate();
    ASSERT_NE(frame, nullptr);
    EXPECT_STREQ(frame->name, "\x81\x5C");
}

TEST_F(NativeModel, LoadsActualGltfBytesWithExplicitGameplayJson) {
    const auto                 json = gltf.dump();
    std::vector<unsigned char> destination(json.begin(), json.end());
    mgLoadData                 load{};
    load.memory = &memory;
    std::string error;
    auto       *frame = model_assets::LoadModel({reinterpret_cast<const std::byte *>(destination.data()), destination.size()}, game, load, error);
    ASSERT_NE(frame, nullptr);
    EXPECT_STREQ(frame->name, "root");
}

TEST_F(NativeModel, SamplesStandardGltfAnimationAtFractionalGameFrames) {
    auto *frame = Instantiate();
    ASSERT_NE(frame, nullptr);
    auto motion = Motion();
    ASSERT_NE(motion.motion_list, nullptr);
    SetMotionTime(frame, &motion, 7.5f, nullptr);
    EXPECT_NEAR(frame->trans_matrix[3][0], 7.5f, .0001f);
    ChangeMotion(frame, &motion, 0, 30, .25f, nullptr);
    EXPECT_NEAR(frame->trans_matrix[3][0], 7.5f, .0001f);
}

TEST_F(NativeModel, LoadsCharacterProfileResourcesAndGameplayInOrder) {
    const auto model = game;
    auto       integer = [](int value) { return Json{
                                             {"type",  "int"},
                                             {"value", value}
 }; };
    auto       real = [](float value) { return Json{
                                            {"type",  "float"},
                                            {"value", value  }
 }; };
    auto       text = [](const char *value) { return Json{
                                                  {"type",  "string"},
                                                  {"value", value   }
 }; };
    auto       resource = [](const char *kind, int index) { return Json{
                                                                {"type",  "resource"},
                                                                {"kind",  kind      },
                                                                {"index", index     }
 }; };
    const Json commands = Json::array({
        {{"command", "BODY_SIZE"}, {"args", {integer(10), integer(20), integer(30)}}                                             },
        {{"command", "MODEL"},     {"args", {resource("model", 0)}}                                                              },
        {{"command", "MOTION"},    {"args", {integer(0), resource("animation", 0), {{"type", "invalid"}}, {{"type", "invalid"}}}}},
        {{"command", "KEY_START"}, {"args", Json::array()}                                                                       },
        {{"command", "KEY"},       {"args", {text("walk"), real(1)}}                                                             },
        {{"command", "KEY_END"},   {"args", Json::array()}                                                                       },
        {{"command", "POLY_NUM"},  {"args", {integer(1), integer(0)}}                                                            }
    });
    game = {
        {"schema_version", 1                                                                                                                                                                                        },
        {"kind",           "character"                                                                                                                                                                              },
        {"models",         Json::array({model})                                                                                                                                                                     },
        {"profiles",       {{"info", {{"commands", commands}}}}                                                                                                                                                     },
        {"game_names",     {{"walk", text("walk")}}                                                                                                                                                                 },
        {"resources",      {{"animations", Json::array({{{"actions", Json::array({{{"name", "walk"}, {"duration", 30}}})}, {"variants", Json::array({{{"model", 0}, {"node_offset", 0}, {"animations", {0}}}})}}})}}}
    };
    Write(directory / "data/models/model.gltf", gltf);
    CCharacter2 character;
    character.Initialize();
    model_assets::CharacterLoadOptions options{.model_memory = &memory, .motion_memory = &memory, .image_memory = &memory};
    options.outline = false;
    std::string error;
    ASSERT_TRUE(model_assets::LoadCharacter(character, std::filesystem::path("models/model.gltf"), "info", options, error)) << error;
    EXPECT_FLOAT_EQ(character.body_height, 10);
    EXPECT_FLOAT_EQ(character.body_width, 20);
    EXPECT_FLOAT_EQ(character.body_depth, 30);
    EXPECT_EQ(character.poly_num, 1);
    ASSERT_NE(character.CObjectFrame::frame, nullptr);
    ASSERT_NE(character.motion[0].motion_list, nullptr);
    ASSERT_NE(character.GetKeyListIndexPtr(0, nullptr), nullptr);
    EXPECT_STREQ(character.GetKeyListIndexPtr(0, nullptr)->name, "walk");
    EXPECT_EQ(character.key_num[0], 2);
    // The first action's game frames start at two, so the game's ratio arithmetic never meets frame zero.
    EXPECT_EQ(character.key_list[0][0].start_frame, 2);
    EXPECT_EQ(character.key_list[0][0].end_frame, 32);
    SetMotionTime(character.CObjectFrame::frame, &character.motion[0], 9.5f, nullptr);
    EXPECT_NEAR(character.CObjectFrame::frame->trans_matrix[3][0], 7.5f, .0001f);
    EXPECT_EQ(model_assets::Profiles("models/model.gltf", error), std::vector<std::string>{"info"});
    const auto estimate = model_assets::EstimateCharacterMemory("models/model.gltf", "info", error);
    ASSERT_TRUE(estimate.has_value()) << error;
    EXPECT_GE(*estimate, static_cast<std::size_t>(memory.stack_used) * 16);
    EXPECT_LT(*estimate, 16384u);
}

TEST_F(NativeModel, ExplicitAbsentResourcesPreserveFollowingGameplayCommands) {
    auto missing = [](const char *kind) { return Json{
                                              {"type",  "resource"},
                                              {"kind",  kind      },
                                              {"index", nullptr   }
 }; };
    game = {
        {"schema_version", 1                                                                                                                                                                                                                                                                                                                                                                 },
        {"models",         Json::array()                                                                                                                                                                                                                                                                                                                                                     },
        {"resources",      Json::object()                                                                                                                                                                                                                                                                                                                                                    },
        {"profiles",       {{"info", {{"commands", Json::array({{{"command", "MODEL"}, {"args", {missing("model")}}}, {{"command", "SHADOW_MODEL"}, {"args", {missing("model")}}}, {{"command", "EFFECT"}, {"args", {missing("script")}}}, {{"command", "BODY_SIZE"}, {"args", {{{"type", "int"}, {"value", 10}}, {{"type", "int"}, {"value", 20}}, {{"type", "int"}, {"value", 30}}}}}})}}}}}
    };
    CCharacter2 character;
    character.Initialize();
    model_assets::CharacterLoadOptions options{.model_memory = &memory, .motion_memory = &memory, .image_memory = &memory};
    const auto                         bytes = gltf.dump();
    std::string                        error;
    ASSERT_TRUE(model_assets::LoadCharacter(character, {reinterpret_cast<const std::byte *>(bytes.data()), bytes.size()}, game, "info", options, error)) << error;
    EXPECT_EQ(character.CObjectFrame::frame, nullptr);
    EXPECT_FLOAT_EQ(character.body_height, 10);
    EXPECT_FLOAT_EQ(character.body_width, 20);
    EXPECT_FLOAT_EQ(character.body_depth, 30);
}

TEST_F(NativeModel, ImageEndSetsTheCharacterBlockWithoutImagesAndSkinEndRetainsIt) {
    game = {
        {"schema_version", 1                                                                                           },
        {"models",         Json::array()                                                                               },
        {"resources",      Json::object()                                                                              },
        {"profiles",       {{"info", {{"commands", Json::array({{{"command", "IMG_END"}, {"args", Json::array()}}})}}}}}
    };
    CCharacter2 character;
    character.Initialize();
    model_assets::CharacterLoadOptions options{.model_memory = &memory, .motion_memory = &memory, .image_memory = &memory};
    options.texture_block = 0x68;
    const auto                       bytes = gltf.dump();
    const std::span<const std::byte> data{reinterpret_cast<const std::byte *>(bytes.data()), bytes.size()};
    std::string                      error;
    ASSERT_TRUE(model_assets::LoadCharacter(character, data, game, "info", options, error)) << error;
    EXPECT_EQ(character.texture_block, 0x68);
    options.texture_block = 0xd1;
    ASSERT_TRUE(model_assets::LoadSkin(character, data, game, "info", "", options, error)) << error;
    EXPECT_EQ(character.texture_block, 0x68);
}

TEST_F(NativeModel, SupportsStepInterpolationAndClampsOutsideClip) {
    gltf["animations"][0]["samplers"][0]["interpolation"] = "STEP";
    Write(directory / "data/models/model.gltf", gltf);
    auto *frame = Instantiate();
    ASSERT_NE(frame, nullptr);
    auto motion = Motion();
    ASSERT_NE(motion.motion_list, nullptr);
    SetMotionTime(frame, &motion, 29.5f, nullptr);
    EXPECT_FLOAT_EQ(frame->trans_matrix[3][0], 0);
    SetMotionTime(frame, &motion, 60, nullptr);
    EXPECT_FLOAT_EQ(frame->trans_matrix[3][0], 30);
}

TEST_F(NativeModel, RejectsEscapingDirectPaths) {
    mgLoadData load{};
    load.memory = &memory;
    std::string error;
    EXPECT_EQ(model_assets::LoadModel(std::filesystem::path("../outside.gltf"), load, error), nullptr);
    EXPECT_FALSE(error.empty());
}

TEST_F(NativeModel, ConvertsStandardRotationsToNativeMatricesAndMotionRecords) {
    const float half = std::sqrt(.5f);
    for (const auto *interpolation : {"LINEAR", "STEP", "CUBICSPLINE"}) {
        std::vector<float> values{0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 1};
        const bool         cubic = std::strcmp(interpolation, "CUBICSPLINE") == 0;
        if (cubic) {
            values.insert(values.end(), {0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0,
                                         0, 0, 0, 0, 0, 0, half, half, 0, 0, 0, 0});
        } else {
            values.insert(values.end(), {0, 0, 0, 1, 0, 0, half, half});
        }
        std::vector<unsigned char> bytes(values.size() * sizeof(float));
        std::memcpy(bytes.data(), values.data(), bytes.size());
        gltf["buffers"][0]["byteLength"] = bytes.size();
        gltf["buffers"][0]["uri"] = "data:application/octet-stream;base64," + Base64(bytes);
        gltf["bufferViews"][2]["byteLength"] = (cubic ? 24 : 8) * sizeof(float);
        gltf["accessors"][2]["type"] = "VEC4";
        gltf["accessors"][2]["count"] = cubic ? 6 : 2;
        gltf["animations"][0]["samplers"][0]["interpolation"] = interpolation;
        gltf["animations"][0]["channels"][0]["target"]["path"] = "rotation";
        Write(directory / "data/models/model.gltf", gltf);
        auto *root = Instantiate();
        ASSERT_NE(root, nullptr);
        auto motion = Motion();
        ASSERT_NE(motion.motion_list, nullptr);
        // The channel samples the document's (x, y, z, w) keys; the game arena holds only its record.
        const auto actions = character_motion::Actions(motion);
        ASSERT_EQ(actions.size(), 1u);
        const auto *channel = actions[0].head;
        ASSERT_NE(channel, nullptr);
        EXPECT_TRUE(model_assets::IsNativeChannel(*channel));
        EXPECT_EQ(channel->key_count, 2u);
        EXPECT_EQ(channel->values, nullptr);
        EXPECT_EQ(channel->key_frames, nullptr);
        root->SetPosition(5, 7, 11);
        SetMotionTime(root, &motion, 0, nullptr);
        EXPECT_NEAR(root->trans_matrix[0][0], 1, 1e-6f);
        EXPECT_NEAR(root->trans_matrix[1][1], 1, 1e-6f);
        EXPECT_NEAR(root->trans_matrix[2][2], 1, 1e-6f);
        SetMotionTime(root, &motion, 15, nullptr);
        const bool step = std::strcmp(interpolation, "STEP") == 0;
        EXPECT_NEAR(root->trans_matrix[0][0], step ? 1 : half, 1e-5f);
        EXPECT_NEAR(root->trans_matrix[0][1], step ? 0 : half, 1e-5f);
        EXPECT_NEAR(root->trans_matrix[1][0], step ? 0 : -half, 1e-5f);
        SetMotionTime(root, &motion, 30, nullptr);
        EXPECT_NEAR(root->trans_matrix[0][0], 0, 1e-5f);
        EXPECT_NEAR(root->trans_matrix[0][1], 1, 1e-5f);
        EXPECT_NEAR(root->trans_matrix[1][0], -1, 1e-5f);
        float local[4][4];
        root->GetLocalMatrix(local);
        EXPECT_FLOAT_EQ(local[3][0], 5);
        EXPECT_FLOAT_EQ(local[3][1], 7);
        EXPECT_FLOAT_EQ(local[3][2], 11);
        ChangeMotion(root, &motion, 0, 30, .5f, nullptr);
        EXPECT_NEAR(root->trans_matrix[0][1], half, 1e-5f);
    }
}

TEST_F(NativeModel, GltfOnlyOverlayChangesTopologyAndMalformedGameplayOverlayFallsBack) {
    std::filesystem::create_directories(directory / "datapacks/test/models");
    Write(directory / "datapacks/datapacks.json", {
                                                      {"schema_version", 1       },
                                                      {"load_order",     {"test"}}
    });
    auto replacement = gltf;
    replacement["nodes"][0]["translation"] = {9, 0, 0};
    replacement["meshes"][0]["primitives"].push_back(replacement["meshes"][0]["primitives"][0]);
    Write(directory / "datapacks/test/models/model.gltf", replacement);
    std::ofstream(directory / "datapacks/test/models/model.game.json") << "{broken";
    datapacks::Load(directory / "data");
    auto *frame = Instantiate();
    ASSERT_NE(frame, nullptr);
    EXPECT_FLOAT_EQ(frame->trans_matrix[3][0], 9);
    auto *visual = static_cast<mgCVisualMDT *>(frame->visual);
    EXPECT_EQ(visual->vertex_num, 6);
    ASSERT_NE(visual->face_group, nullptr);
    EXPECT_NE(visual->face_group->next, nullptr);
    Json changed = game;
    changed["frames"][0]["name"] = "changed";
    changed["meshes"][0]["materials"][0]["ambient"] = {1, 2, 3, 4};
    Write(directory / "datapacks/test/models/model.game.json", changed);
    frame = Instantiate();
    ASSERT_NE(frame, nullptr);
    EXPECT_FLOAT_EQ(static_cast<mgCVisualMDT *>(frame->visual)->material[0].unk_10[1], 2);
}

TEST_F(NativeModel, CollapsesStandardScaleRotationHelpersWithoutChangingGameplayFrameIdentities) {
    const float        half = std::sqrt(.5f);
    std::vector<float> values{0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 1, 0, 0, 0, 1, 0, 0, half, half};
    auto               vector_accessor = [&](std::initializer_list<float> components) {
        const auto view = gltf["bufferViews"].size();
        gltf["bufferViews"].push_back({
            {"buffer",     0                                },
            {"byteOffset", values.size() * sizeof(float)    },
            {"byteLength", components.size() * sizeof(float)}
        });
        values.insert(values.end(), components);
        const auto accessor = gltf["accessors"].size();
        gltf["accessors"].push_back({
            {"bufferView",    view                 },
            {"componentType", 5126                 },
            {"count",         components.size() / 3},
            {"type",          "VEC3"               }
        });
        return accessor;
    };
    gltf["asset"]["generator"] = "Kazarov";
    gltf["bufferViews"][2]["byteLength"] = 8 * sizeof(float);
    gltf["accessors"][2]["type"] = "VEC4";
    const auto                 scale = vector_accessor({1, 1, 1, 2, 3, 4});
    const auto                 reset = vector_accessor({1, 1, 1, 1, 1, 1});
    std::vector<unsigned char> bytes(values.size() * sizeof(float));
    std::memcpy(bytes.data(), values.data(), bytes.size());
    gltf["buffers"][0]["byteLength"] = bytes.size();
    gltf["buffers"][0]["uri"] = "data:application/octet-stream;base64," + Base64(bytes);
    gltf["nodes"] = Json::array({
        {{"name", "root"}, {"translation", {5, 7, 11}}, {"children", {2}}},
        {{"name", "child"}, {"translation", {1, 2, 3}}},
        {{"name", "rotation"}, {"mesh", 0}, {"rotation", {0, 0, half, half}}, {"scale", {2, 3, 4}}, {"children", {1}}}
    });
    game["frames"] = Json::array({
        {{"id", 0}, {"mdt", 0}, {"rotation_node", 2}},
        {{"id", 1}, {"mdt", nullptr}}
    });
    gltf["animations"][0]["samplers"] = Json::array({
        {{"input", 1}, {"output", 2}    },
        {{"input", 1}, {"output", scale}},
        {{"input", 1}, {"output", reset}}
    });
    gltf["animations"][0]["channels"] = Json::array({
        {{"sampler", 0}, {"target", {{"node", 2}, {"path", "rotation"}}}},
        {{"sampler", 1}, {"target", {{"node", 0}, {"path", "scale"}}}   },
        {{"sampler", 2}, {"target", {{"node", 2}, {"path", "scale"}}}   }
    });
    Write(directory / "data/models/model.gltf", gltf);
    auto *root = Instantiate();
    ASSERT_NE(root, nullptr);
    ASSERT_EQ(root->frame_num, 2);
    EXPECT_STREQ(root->name, "root");
    ASSERT_NE(root->visual, nullptr);
    EXPECT_EQ(root->child, root->GetFrame(1));
    EXPECT_EQ(root->GetFrame(1)->parent, root);
    EXPECT_FALSE(model_assets::UsesStandardScaleOrder(root));
    float local[4][4];
    root->GetLocalMatrix(local);
    EXPECT_NEAR(local[0][1], 2, 1e-5f);
    EXPECT_NEAR(local[1][0], -3, 1e-5f);
    auto motion = Motion();
    SetMotionTime(root, &motion, 15, nullptr);
    root->GetLocalMatrix(local);
    EXPECT_NEAR(local[0][0], 1.5f * half, 1e-5f);
    EXPECT_NEAR(local[0][1], 2 * half, 1e-5f);
    EXPECT_NEAR(local[1][0], -1.5f * half, 1e-5f);
    EXPECT_NEAR(local[1][1], 2 * half, 1e-5f);
    EXPECT_NEAR(local[2][2], 2.5f, 1e-5f);
    EXPECT_FLOAT_EQ(local[3][0], 5);
    EXPECT_FLOAT_EQ(local[3][1], 7);
    EXPECT_FLOAT_EQ(local[3][2], 11);
    EXPECT_FLOAT_EQ(root->scale[0], 1.5f);
    EXPECT_FLOAT_EQ(root->scale[1], 2);

    // The nonuniform rotation at p00_19a frame 74, time 14 must retain the native scale order.
    float quaternion[4] = {.628367f, -.021839f, .025335f, .777198f};
    float length = 0;
    for (float component : quaternion) {
        length += component * component;
    }
    for (float &component : quaternion) {
        component /= std::sqrt(length);
    }
    for (int key = 0; key < 2; ++key) {
        values[11 + key * 4] = -quaternion[1];
        values[12 + key * 4] = -quaternion[2];
        values[13 + key * 4] = -quaternion[3];
        values[14 + key * 4] = quaternion[0];
        values[19 + key * 3] = .924201f;
        values[20 + key * 3] = values[21 + key * 3] = 1;
    }
    std::memcpy(bytes.data(), values.data(), bytes.size());
    gltf["buffers"][0]["uri"] = "data:application/octet-stream;base64," + Base64(bytes);
    Write(directory / "data/models/model.gltf", gltf);
    root = Instantiate();
    motion = Motion();
    SetMotionTime(root, &motion, 14, nullptr);
    root->GetLocalMatrix(local);
    mgCFrame native;
    float    reference[4][4]{};
    reference[0][0] = reference[1][1] = reference[2][2] = reference[3][3] = 1;
    reference[3][0] = 5;
    reference[3][1] = 7;
    reference[3][2] = 11;
    native.SetTransMatrix(reference);
    native.SetTransMatrix(quaternion);
    native.SetScale(.924201f, 1, 1);
    native.GetLocalMatrix(reference);
    for (int column = 0; column < 4; ++column) {
        for (int row = 0; row < 4; ++row) {
            EXPECT_NEAR(local[column][row], reference[column][row], 1e-5f);
        }
    }
}

TEST_F(NativeModel, StandardNonuniformScaleOverridesUseRotationBeforeScaleAndClearOnFrameReuse) {
    std::filesystem::create_directories(directory / "datapacks/test/models");
    auto base = gltf;
    base["nodes"] = Json::array({
        {{"name", "root"}, {"children", {1}}},
        {{"mesh", 0}}
    });
    game["frames"][0]["rotation_node"] = 1;
    Write(directory / "data/models/model.gltf", base);
    Write(directory / "datapacks/datapacks.json", {
                                                      {"schema_version", 1       },
                                                      {"load_order",     {"test"}}
    });
    const float half = std::sqrt(.5f);
    gltf["asset"]["generator"] = "Kazarov";
    gltf["nodes"][0]["rotation"] = {0, 0, half, half};
    gltf["nodes"][0]["scale"] = {2, 3, 4};
    Write(directory / "datapacks/test/models/model.gltf", gltf);
    datapacks::Load(directory / "data");
    auto *root = Instantiate();
    ASSERT_NE(root, nullptr);
    EXPECT_TRUE(model_assets::UsesStandardScaleOrder(root));
    float local[4][4];
    root->GetLocalMatrix(local);
    EXPECT_NEAR(local[0][1], 2, 1e-5f);
    EXPECT_NEAR(local[1][0], -3, 1e-5f);
    root->SetScale(5, 6, 7);
    root->SetPosition(8, 9, 10);
    root->GetLocalMatrix(local);
    EXPECT_NEAR(local[0][1], 5, 1e-5f);
    EXPECT_NEAR(local[1][0], -6, 1e-5f);
    EXPECT_FLOAT_EQ(local[3][0], 8);
    EXPECT_FLOAT_EQ(local[3][1], 9);
    EXPECT_FLOAT_EQ(local[3][2], 10);
    root->rot_type = MG_FRAME_ROT_APPLY;
    root->SetRotation(0, 0, .2f);
    root->GetLocalMatrix(local);
    EXPECT_NEAR(local[0][0], -5 * std::sin(.2f), 1e-5f);
    EXPECT_NEAR(local[0][1], 5 * std::cos(.2f), 1e-5f);
    root->Initialize();
    EXPECT_FALSE(model_assets::UsesStandardScaleOrder(root));
    float rotation[4][4]{};
    rotation[0][1] = rotation[2][2] = rotation[3][3] = 1;
    rotation[1][0] = -1;
    root->SetTransMatrix(rotation);
    root->SetScale(2, 3, 4);
    root->GetLocalMatrix(local);
    EXPECT_FLOAT_EQ(local[0][1], 3);
    EXPECT_FLOAT_EQ(local[1][0], -2);
}

TEST_F(NativeModel, GameModelsKeepAuthoredScaleInTheMatrixSoGameplayScaleUsesTheGameOrder) {
    const float        half = std::sqrt(.5f);
    std::vector<float> values{0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 1, 0, 0, 0, 30, 0, 0};
    auto               accessor = [&](std::initializer_list<float> components, const char *type, std::size_t width) {
        gltf["bufferViews"].push_back({
            {"buffer",     0                                },
            {"byteOffset", values.size() * sizeof(float)    },
            {"byteLength", components.size() * sizeof(float)}
        });
        values.insert(values.end(), components);
        gltf["accessors"].push_back({
            {"bufferView",    gltf["bufferViews"].size() - 1},
            {"componentType", 5126                          },
            {"count",         components.size() / width     },
            {"type",          type                          }
        });
        return gltf["accessors"].size() - 1;
    };
    gltf["asset"]["generator"] = "Kazarov";
    gltf["nodes"][0]["rotation"] = {0, 0, half, half};
    gltf["nodes"][0]["scale"] = {2, 3, 4};
    const auto                 rotation = accessor({0, 0, 0, 1, 0, 0, 0, 1}, "VEC4", 4);
    const auto                 ones = accessor({1, 1, 1, 1, 1, 1}, "VEC3", 3);
    std::vector<unsigned char> bytes(values.size() * sizeof(float));
    std::memcpy(bytes.data(), values.data(), bytes.size());
    gltf["buffers"][0]["byteLength"] = bytes.size();
    gltf["buffers"][0]["uri"] = "data:application/octet-stream;base64," + Base64(bytes);
    gltf["animations"][0]["samplers"].push_back({
        {"input",  1       },
        {"output", rotation}
    });
    gltf["animations"][0]["samplers"].push_back({
        {"input",  1   },
        {"output", ones}
    });
    gltf["animations"][0]["channels"].push_back({
        {"sampler", 1                                  },
        {"target",  {{"node", 0}, {"path", "rotation"}}}
    });
    gltf["animations"][0]["channels"].push_back({
        {"sampler", 2                               },
        {"target",  {{"node", 0}, {"path", "scale"}}}
    });
    Write(directory / "data/models/model.gltf", gltf);
    auto *root = Instantiate();
    ASSERT_NE(root, nullptr);
    EXPECT_FALSE(model_assets::UsesStandardScaleOrder(root));
    float local[4][4];
    root->GetLocalMatrix(local);
    EXPECT_NEAR(local[0][1], 2, 1e-5f);
    EXPECT_NEAR(local[1][0], -3, 1e-5f);
    EXPECT_NEAR(local[2][2], 4, 1e-5f);
    // Gameplay scale multiplies the authored matrix's columns, as the game does.
    root->SetScale(5, 6, 7);
    root->GetLocalMatrix(local);
    EXPECT_NEAR(local[0][1], 2 * 6, 1e-5f);
    EXPECT_NEAR(local[1][0], -3 * 5, 1e-5f);
    EXPECT_NEAR(local[2][2], 4 * 7, 1e-5f);
    // Rotation keys replace the authored matrix, scale included; the unit scale key leaves gameplay scale alone.
    auto motion = Motion();
    SetMotionTime(root, &motion, 15, nullptr);
    root->GetLocalMatrix(local);
    EXPECT_NEAR(local[0][0], 5, 1e-5f);
    EXPECT_NEAR(local[1][1], 6, 1e-5f);
    EXPECT_NEAR(local[2][2], 7, 1e-5f);
    EXPECT_FLOAT_EQ(root->scale[0], 5);
}

TEST_F(NativeModel, GeneratedBaseRotationsPreserveRetailNearOppositeSnapWhileOverridesUseStandardSlerp) {
    const std::vector<float>   values{0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0};
    std::vector<unsigned char> bytes(values.size() * sizeof(float));
    std::memcpy(bytes.data(), values.data(), bytes.size());
    gltf["asset"]["generator"] = "Kazarov";
    gltf["buffers"][0]["byteLength"] = bytes.size();
    gltf["buffers"][0]["uri"] = "data:application/octet-stream;base64," + Base64(bytes);
    gltf["bufferViews"][2]["byteLength"] = 8 * sizeof(float);
    gltf["accessors"][2]["type"] = "VEC4";
    gltf["animations"][0]["channels"][0]["target"]["path"] = "rotation";
    Write(directory / "data/models/model.gltf", gltf);
    auto *root = Instantiate();
    ASSERT_NE(root, nullptr);
    auto motion = Motion();
    ASSERT_NE(motion.motion_list, nullptr);
    SetMotionTime(root, &motion, 0, nullptr);
    EXPECT_NEAR(root->trans_matrix[0][0], 1, 1e-5f);
    SetMotionTime(root, &motion, .01f, nullptr);
    EXPECT_NEAR(root->trans_matrix[0][0], 1, 1e-5f);
    SetMotionTime(root, &motion, 15, nullptr);
    EXPECT_NEAR(root->trans_matrix[0][0], -1, 1e-5f);
    EXPECT_NEAR(root->trans_matrix[2][2], -1, 1e-5f);
    SetMotionTime(root, &motion, 29.99f, nullptr);
    EXPECT_NEAR(root->trans_matrix[0][0], -1, 1e-5f);
    ChangeMotion(root, &motion, 0, 30, .00005f, nullptr);
    EXPECT_NEAR(root->trans_matrix[0][0], 1, 1e-5f);
    ChangeMotion(root, &motion, 0, 30, .99995f, nullptr);
    EXPECT_NEAR(root->trans_matrix[0][0], -1, 1e-5f);
    ChangeMotion(root, &motion, 0, 30, .5f, nullptr);
    EXPECT_NEAR(root->trans_matrix[0][0], -1, 1e-5f);
    std::filesystem::create_directories(directory / "datapacks/test/models");
    Write(directory / "datapacks/datapacks.json", {
                                                      {"schema_version", 1       },
                                                      {"load_order",     {"test"}}
    });
    Write(directory / "datapacks/test/models/model.gltf", gltf);
    datapacks::Load(directory / "data");
    root = Instantiate();
    motion = Motion();
    SetMotionTime(root, &motion, 15, nullptr);
    EXPECT_NEAR(root->trans_matrix[0][0], 0, 1e-5f);
    EXPECT_NEAR(root->trans_matrix[2][2], 0, 1e-5f);
    ChangeMotion(root, &motion, 0, 30, .5f, nullptr);
    EXPECT_NEAR(root->trans_matrix[0][0], 0, 1e-5f);
}

TEST_F(NativeModel, InvalidGameplayIdentitiesFallBackBeforeNativeAllocation) {
    std::filesystem::create_directories(directory / "datapacks/test/models");
    Write(directory / "datapacks/datapacks.json", {
                                                      {"schema_version", 1       },
                                                      {"load_order",     {"test"}}
    });
    datapacks::Load(directory / "data");
    std::vector<Json> invalid(5, game);
    invalid[0]["frames"][0]["mdt"] = 999;
    invalid[1]["frames"][0]["mdt"] = -1;
    invalid[2]["frames"][0]["id"] = 1;
    invalid[3]["meshes"][0]["primitives"][0]["source_vertices"][0] = 3;
    invalid[4]["meshes"][0]["vertex_count"] = -1;
    for (const auto &candidate : invalid) {
        Write(directory / "datapacks/test/models/model.game.json", candidate);
        std::string error;
        const auto  selected = model_assets::ReadGameplay("models/model.gltf", error);
        ASSERT_NE(selected, nullptr) << error;
        EXPECT_EQ(*selected, game);
        auto *frame = Instantiate();
        ASSERT_NE(frame, nullptr);
        EXPECT_EQ(static_cast<mgCVisualMDT *>(frame->visual)->vertex_num, 3);
    }
}

TEST_F(NativeModel, ModelListsIncludeModelsAddedOnlyByDatapacks) {
    std::filesystem::create_directories(directory / "datapacks/test/models");
    Write(directory / "datapacks/datapacks.json", {
                                                      {"schema_version", 1       },
                                                      {"load_order",     {"test"}}
    });
    Write(directory / "datapacks/test/models/added.gltf", gltf);
    Write(directory / "datapacks/test/models/added.game.json", game);
    const Json marker = {
        {"schema_version", 1                },
        {"kind",           "asset_directory"}
    };
    Write(directory / "data/models/pack.json", marker);
    Json models = Json::array();
    for (const auto *name : {"model.gltf", "added.gltf"}) {
        models.push_back({
            {"model", name},
            {"type",  0   }
        });
    }
    Write(directory / "datapacks/test/models/info.cfg.json", {
                                                                 {"schema_version", 2           },
                                                                 {"kind",           "model_list"},
                                                                 {"models",         models      }
    });
    datapacks::Load(directory / "data");
    auto metadata = marker.dump(2);
    DataReadRegisterAsset(metadata.data(), "models/pack.json", metadata.size());
    CMdsList list{};
    char     label[] = "models";
    list.LoadPCPFile(label, reinterpret_cast<u_int *>(metadata.data()), &memory, 0);
    ASSERT_EQ(list.num, 2);
    char        added_name[] = "added.gltf";
    const auto *added = list.GetList(added_name);
    ASSERT_NE(added, nullptr);
    ASSERT_NE(added->frame, nullptr);
    EXPECT_EQ(static_cast<mgCVisualMDT *>(added->frame->visual)->vertex_num, 3);
    TextureSourceForget(metadata.data());
    DataReadRegisterBuffer(metadata.data(), 0);
}

TEST_F(NativeModel, SamplesCubicSplineWithSecondBasedTangents) {
    const std::vector<float>   values{0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 1,
                                      0, 0, 0, 0, 0, 0, 0, 0, 0,
                                      0, 0, 0, 30, 0, 0, 0, 0, 0};
    std::vector<unsigned char> bytes(values.size() * sizeof(float));
    std::memcpy(bytes.data(), values.data(), bytes.size());
    gltf["buffers"][0]["byteLength"] = bytes.size();
    gltf["buffers"][0]["uri"] = "data:application/octet-stream;base64," + Base64(bytes);
    gltf["bufferViews"][2]["byteLength"] = 72;
    gltf["accessors"][2]["count"] = 6;
    gltf["animations"][0]["samplers"][0]["interpolation"] = "CUBICSPLINE";
    Write(directory / "data/models/model.gltf", gltf);
    auto *frame = Instantiate();
    ASSERT_NE(frame, nullptr);
    auto motion = Motion();
    ASSERT_NE(motion.motion_list, nullptr);
    SetMotionTime(frame, &motion, 7.5f, nullptr);
    EXPECT_NEAR(frame->trans_matrix[3][0], 4.6875f, .0001f);
}

TEST_F(NativeModel, AppliesStandardMorphTargetWeightsThroughRotationHelpers) {
    const std::vector<float>   values{0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 1, 0, 2, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0};
    std::vector<unsigned char> bytes(values.size() * sizeof(float));
    std::memcpy(bytes.data(), values.data(), bytes.size());
    gltf["buffers"][0]["byteLength"] = bytes.size();
    gltf["buffers"][0]["uri"] = "data:application/octet-stream;base64," + Base64(bytes);
    gltf["bufferViews"][2]["byteLength"] = 8;
    gltf["accessors"][2]["type"] = "SCALAR";
    gltf["bufferViews"].push_back({
        {"buffer",     0 },
        {"byteOffset", 68},
        {"byteLength", 36}
    });
    gltf["accessors"].push_back({
        {"bufferView",    3     },
        {"componentType", 5126  },
        {"count",         3     },
        {"type",          "VEC3"}
    });
    gltf["meshes"][0]["primitives"][0]["targets"] = Json::array({{{"POSITION", 3}}});
    gltf["nodes"] = Json::array({
        {{"name", "root"}, {"children", {1}}},
        {{"mesh", 0}}
    });
    game["frames"][0]["rotation_node"] = 1;
    gltf["animations"][0]["channels"][0]["target"]["node"] = 1;
    gltf["animations"][0]["channels"][0]["target"]["path"] = "weights";
    Write(directory / "data/models/model.gltf", gltf);
    auto *frame = Instantiate();
    ASSERT_NE(frame, nullptr);
    auto motion = Motion();
    ASSERT_NE(motion.motion_list, nullptr);
    SetMotionTime(frame, &motion, 15, nullptr);
    auto *visual = static_cast<mgCVisualMDT *>(frame->visual);
    EXPECT_FLOAT_EQ(visual->vertex[0][0], 1);
    EXPECT_FLOAT_EQ(visual->vertex[1][0], 3);
}

TEST_F(NativeModel, PngOverlayWinsBeforeImageRegistrationAndGltfOverlayOwnsItsEmbeddedImage) {
    std::vector<u_long128> texture_storage(4096);
    mgCMemory              texture_memory;
    texture_memory.stSetBuffer(texture_storage.data(), static_cast<int>(texture_storage.size()));
    mgTexManager.SetTableBuffer(16, 8, &texture_memory);
    mgTexManager.Initialize(0x1000, -1);
    gltf["images"] = Json::array({{{"uri", "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR4nGP4z8DwHwAFAAH/iZk9HQAAAABJRU5ErkJggg=="}}});
    const std::vector<unsigned char> red_pixels{255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255, 255, 0, 0, 255};
    ASSERT_TRUE(gfx::WritePng(directory / "base.png", red_pixels.data(), 2, 2));
    {
        std::ifstream                    input(directory / "base.png", std::ios::binary);
        const std::vector<unsigned char> png((std::istreambuf_iterator<char>(input)), {});
        gltf["images"][0]["uri"] = "data:image/png;base64," + Base64(png);
    }
    std::filesystem::remove(directory / "base.png");
    game["images"] = Json::array({
        {{"image", 0}, {"png", "textures/model.png"}}
    });
    gltf["textures"] = Json::array({{{"source", 0}}});
    gltf["materials"][0]["pbrMetallicRoughness"]["baseColorTexture"] = {
        {"index", 0}
    };
    Write(directory / "data/models/model.gltf", gltf);
    Json metadata = game;
    metadata["meshes"][0]["materials"][0]["texture"] = "fixture_texture";
    metadata["meshes"][0]["materials"][0]["texture_path"] = "textures/model.png";
    game = metadata;
    Write(directory / "data/models/model.gltf", gltf);
    std::filesystem::create_directories(directory / "datapacks/test/textures");
    {
        std::vector<unsigned char> pixels(8 * 8 * 4);
        for (std::size_t index = 0; index < pixels.size(); index += 4) {
            pixels[index + 1] = 255;
            pixels[index + 3] = 255;
        }
        ASSERT_TRUE(gfx::WritePng(directory / "datapacks/test/textures/model.png", pixels.data(), 8, 8));
    }
    Write(directory / "datapacks/datapacks.json", {
                                                      {"schema_version", 1       },
                                                      {"load_order",     {"test"}}
    });
    datapacks::Load(directory / "data");
    auto *base = Instantiate();
    ASSERT_NE(base, nullptr);
    auto *base_texture = static_cast<mgCVisualMDT *>(base->visual)->material[0].texture;
    ASSERT_NE(base_texture, nullptr);
    const auto *base_pixels = reinterpret_cast<const unsigned char *>(base_texture->image[0]);
    ASSERT_NE(base_pixels, nullptr);
    EXPECT_EQ(base_pixels[0], 0);
    EXPECT_EQ(base_pixels[1], 255);
    EXPECT_EQ(base_texture->width, 2);
    EXPECT_EQ(base_texture->height, 2);
    EXPECT_EQ(MgTexturePhysicalExtent(base_texture).width, 8u);
    EXPECT_EQ(MgTexturePhysicalExtent(base_texture).height, 8u);
    std::filesystem::create_directories(directory / "datapacks/test/models");
    Write(directory / "datapacks/test/models/model.gltf", gltf);
    datapacks::Load(directory / "data");
    auto *overlaid = Instantiate();
    ASSERT_NE(overlaid, nullptr);
    auto *overlay_texture = static_cast<mgCVisualMDT *>(overlaid->visual)->material[0].texture;
    ASSERT_NE(overlay_texture, nullptr);
    const auto *overlay_pixels = reinterpret_cast<const unsigned char *>(overlay_texture->image[0]);
    ASSERT_NE(overlay_pixels, nullptr);
    EXPECT_EQ(overlay_pixels[0], 255);
    EXPECT_EQ(overlay_pixels[1], 0);
    mgTexManager.Initialize(0x1000, -1);
}

TEST_F(NativeModel, ContentKeyedImagesNeverShareDifferentEmbeddedFallbacksAndFollowReplacementEdits) {
    std::vector<u_long128> texture_storage(4096);
    mgCMemory              texture_memory;
    texture_memory.stSetBuffer(texture_storage.data(), static_cast<int>(texture_storage.size()));
    mgTexManager.SetTableBuffer(16, 8, &texture_memory);
    mgTexManager.Initialize(0x1000, -1);
    gltf["textures"] = Json::array({{{"source", 0}}});
    gltf["materials"][0]["pbrMetallicRoughness"]["baseColorTexture"] = {
        {"index", 0}
    };
    game["images"] = Json::array({
        {{"image", 0}, {"png", "textures/shared.png"}}
    });
    std::filesystem::create_directories(directory / "datapacks/test/textures");
    std::ofstream(directory / "datapacks/test/textures/shared.png", std::ios::binary) << "not a png";
    Write(directory / "datapacks/datapacks.json", {
                                                      {"schema_version", 1       },
                                                      {"load_order",     {"test"}}
    });
    datapacks::Load(directory / "data");
    const auto load = [&](const std::string &stem, const std::string &texture, unsigned char red) {
        const std::vector<unsigned char> pixels{red, 0, 0, 255, red, 0, 0, 255, red, 0, 0, 255, red, 0, 0, 255};
        EXPECT_TRUE(gfx::WritePng(directory / "embedded.png", pixels.data(), 2, 2));
        std::ifstream                    input(directory / "embedded.png", std::ios::binary);
        const std::vector<unsigned char> png((std::istreambuf_iterator<char>(input)), {});
        input.close();
        std::filesystem::remove(directory / "embedded.png");
        auto model = gltf;
        model["images"] = Json::array({{{"uri", "data:image/png;base64," + Base64(png)}}});
        game["meshes"][0]["materials"][0]["texture"] = texture;
        Write(directory / "data" / (stem + ".gltf"), model);
        Write(directory / "data" / (stem + ".game.json"), game);
        memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
        mgLoadData data{};
        data.memory = &memory;
        std::string error;
        auto       *frame = model_assets::LoadModel(stem + ".gltf", data, error);
        EXPECT_NE(frame, nullptr) << error;
        return frame ? static_cast<mgCVisualMDT *>(frame->visual)->material[0].texture : nullptr;
    };
    // An invalid replacement falls back to each document's own embedded image.
    auto *first = load("models/first", "first", 100);
    auto *second = load("models/second", "second", 200);
    ASSERT_NE(first, nullptr);
    ASSERT_NE(second, nullptr);
    EXPECT_EQ(reinterpret_cast<const unsigned char *>(first->image[0])[0], 100);
    EXPECT_EQ(reinterpret_cast<const unsigned char *>(second->image[0])[0], 200);
    EXPECT_EQ(MgTexturePhysicalExtent(first).width, 2u);

    // A valid replacement wins for every document while the logical extent stays the embedded image's.
    std::vector<unsigned char> green(8 * 8 * 4);
    for (std::size_t index = 0; index < green.size(); index += 4) {
        green[index + 1] = 255;
        green[index + 3] = 255;
    }
    std::filesystem::remove(directory / "datapacks/test/textures/shared.png");
    ASSERT_TRUE(gfx::WritePng(directory / "datapacks/test/textures/shared.png", green.data(), 8, 8));
    datapacks::Load(directory / "data");
    auto *third = load("models/third", "third", 50);
    auto *fourth = load("models/fourth", "fourth", 60);
    ASSERT_NE(third, nullptr);
    ASSERT_NE(fourth, nullptr);
    for (auto *texture : {third, fourth}) {
        EXPECT_EQ(reinterpret_cast<const unsigned char *>(texture->image[0])[0], 0);
        EXPECT_EQ(reinterpret_cast<const unsigned char *>(texture->image[0])[1], 255);
        EXPECT_EQ(texture->width, 2);
        EXPECT_EQ(MgTexturePhysicalExtent(texture).width, 8u);
    }
    mgTexManager.Initialize(0x1000, -1);
}

TEST_F(NativeModel, ExternalImageUrisShareOneDecodeAndFollowPackOverrides) {
    std::vector<u_long128> texture_storage(4096);
    mgCMemory              texture_memory;
    texture_memory.stSetBuffer(texture_storage.data(), static_cast<int>(texture_storage.size()));
    mgTexManager.SetTableBuffer(16, 8, &texture_memory);
    mgTexManager.Initialize(0x1000, -1);
    gltf["textures"] = Json::array({{{"source", 0}}});
    gltf["materials"][0]["pbrMetallicRoughness"]["baseColorTexture"] = {
        {"index", 0}
    };
    const std::vector<unsigned char> red{200, 0, 0, 255, 200, 0, 0, 255, 200, 0, 0, 255, 200, 0, 0, 255};
    std::filesystem::create_directories(directory / "data/textures");
    ASSERT_TRUE(gfx::WritePng(directory / "data/textures/shared.png", red.data(), 2, 2));
    datapacks::Load(directory / "data");
    const auto load = [&](const std::string &stem, const std::string &uri, const std::string &texture) {
        auto model = gltf;
        model["images"] = Json::array({{{"uri", uri}}});
        game["meshes"][0]["materials"][0]["texture"] = texture;
        std::filesystem::create_directories((directory / "data" / (stem + ".gltf")).parent_path());
        Write(directory / "data" / (stem + ".gltf"), model);
        Write(directory / "data" / (stem + ".game.json"), game);
        memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
        mgLoadData data{};
        data.memory = &memory;
        std::string error;
        auto       *frame = model_assets::LoadModel(stem + ".gltf", data, error);
        EXPECT_NE(frame, nullptr) << error;
        return frame ? static_cast<mgCVisualMDT *>(frame->visual)->material[0].texture : nullptr;
    };
    auto *first = load("models/first", "../textures/shared.png", "first");
    ASSERT_NE(first, nullptr);
    EXPECT_EQ(reinterpret_cast<const unsigned char *>(first->image[0])[0], 200);
    EXPECT_EQ(first->width, 2);

    // The decode is named by the PNG's data path and stamp alone, so every referencing document shares it.
    const auto key = datapacks::ImageDecodeKey("png:textures/shared.png\n", datapacks::Candidates("textures/shared.png"));
    const auto unexpected = [](datapacks::DecodedTexture &, std::string &error) {
        error = "decoded again";
        return false;
    };
    std::string error;
    const auto  cached = datapacks::DecodeShared(key, unexpected, error);
    ASSERT_NE(cached, nullptr);
    auto *second = load("models/sub/second", "../../textures/%73hared.png", "second");
    ASSERT_NE(second, nullptr);
    EXPECT_EQ(reinterpret_cast<const unsigned char *>(second->image[0])[0], 200);
    EXPECT_EQ(datapacks::DecodeShared(key, unexpected, error), cached) << error;

    // A pack replacing the PNG's path wins for external references while the logical extent stays the original's.
    std::vector<unsigned char> green(8 * 8 * 4);
    for (std::size_t index = 0; index < green.size(); index += 4) {
        green[index + 1] = 255;
        green[index + 3] = 255;
    }
    std::filesystem::create_directories(directory / "datapacks/test/textures");
    ASSERT_TRUE(gfx::WritePng(directory / "datapacks/test/textures/shared.png", green.data(), 8, 8));
    Write(directory / "datapacks/datapacks.json", {
                                                      {"schema_version", 1       },
                                                      {"load_order",     {"test"}}
    });
    datapacks::Load(directory / "data");
    auto *third = load("models/third", "../textures/shared.png", "third");
    ASSERT_NE(third, nullptr);
    EXPECT_EQ(reinterpret_cast<const unsigned char *>(third->image[0])[0], 0);
    EXPECT_EQ(reinterpret_cast<const unsigned char *>(third->image[0])[1], 255);
    EXPECT_EQ(third->width, 2);
    EXPECT_EQ(MgTexturePhysicalExtent(third).width, 8u);
    mgTexManager.Initialize(0x1000, -1);
}

TEST_F(NativeModel, BuildsCollisionHierarchyAndGroundAttributesFromNativeGeometry) {
    Json metadata = game;
    metadata["meshes"][0]["materials"][0]["diffuse"] = {10, 20, 30, 0};
    metadata["frames"].push_back({
        {"id",     1      },
        {"name",   "child"},
        {"parent", 0      },
        {"mdt",    nullptr}
    });
    gltf["nodes"][0]["children"] = {1};
    gltf["nodes"].push_back({
        {"name",        "child"  },
        {"translation", {2, 0, 0}}
    });
    gltf["materials"][0]["pbrMetallicRoughness"]["baseColorFactor"] = {1, 1, 1, 0};
    Write(directory / "data/models/model.gltf", gltf);
    game = metadata;
    Write(directory / "data/models/model.gltf", gltf);
    auto *frame = LoadCollisionModel("models/model.gltf", &memory);
    ASSERT_NE(frame, nullptr);
    EXPECT_STREQ(frame->name, "root");
    ASSERT_NE(frame->child, nullptr);
    EXPECT_STREQ(frame->child->name, "child");
    EXPECT_EQ(frame->child->parent, frame);
    ASSERT_NE(frame->collision, nullptr);
    auto *collision = static_cast<CCollisionMDT *>(frame->collision);
    ASSERT_EQ(collision->poly_count, 1);
    EXPECT_FLOAT_EQ(collision->poly[0].vertex[1][0], 2);
    EXPECT_EQ(collision->poly[0].ground_kind, 7);
    EXPECT_EQ(collision->poly[0].foot_sound, 14);
    EXPECT_EQ(collision->poly[0].area_kind, 21);
    EXPECT_EQ(collision->poly[0].ignore_mask, 1);
}

TEST_F(NativeModel, TreasureBoxesSelectCollisionSceneFromCompleteGltfBundle) {
    auto        standard = gltf;
    const float half = std::sqrt(.5f);
    standard["nodes"] = Json::array({
        {{"name", "tbox0"}, {"mesh", 0}},
        {{"name", "tbox1"}, {"mesh", 0}},
        {{"name", "tbox_a"}, {"mesh", 0}, {"rotation", {0, 0, half, half}}, {"scale", {2, 3, 4}}, {"translation", {5, 7, 11}}}
    });
    standard["scenes"] = Json::array({
        {{"name", "tbox0"},  {"nodes", {0}}},
        {{"name", "tbox1"},  {"nodes", {1}}},
        {{"name", "tbox_a"}, {"nodes", {2}}}
    });
    Write(directory / "data/models/treasure.gltf", standard);
    const auto       text = standard.dump();
    std::vector<u32> buffer((text.size() + sizeof(u32) - 1) / sizeof(u32));
    std::memcpy(buffer.data(), text.data(), text.size());
    DataReadRegisterAsset(buffer.data(), "models/treasure.gltf", text.size());
    CTreasureBoxManager manager{};
    manager.Initialize();
    manager.SetCollisionModel(buffer.data(), &memory);
    TextureSourceForget(buffer.data());
    ASSERT_NE(manager.col_frame, nullptr);
    EXPECT_STREQ(manager.col_frame->name, "tbox_a");
    ASSERT_NE(manager.col_frame->collision, nullptr);
    EXPECT_EQ(static_cast<CCollisionMDT *>(manager.col_frame->collision)->poly_count, 1);
    float local[4][4];
    manager.col_frame->GetLocalMatrix(local);
    EXPECT_NEAR(local[0][0], 0, 1e-5f);
    EXPECT_NEAR(local[0][1], 2, 1e-5f);
    EXPECT_NEAR(local[1][0], -3, 1e-5f);
    EXPECT_NEAR(local[1][1], 0, 1e-5f);
    EXPECT_NEAR(local[2][2], 4, 1e-5f);
    EXPECT_FLOAT_EQ(local[3][0], 5);
    EXPECT_FLOAT_EQ(local[3][1], 7);
    EXPECT_FLOAT_EQ(local[3][2], 11);
}

TEST_F(NativeModel, ShadowCpuSkinRetainsMoreThanThirtyTwoBones) {
    Json             metadata = game;
    Json             channels = Json::array();
    std::vector<int> joints;
    for (int bone = 1; bone <= 34; ++bone) {
        joints.push_back(bone);
        const auto name = "bone_" + std::to_string(bone);
        gltf["nodes"].push_back({
            {"name",        name     },
            {"translation", {2, 0, 0}}
        });
        metadata["frames"].push_back({
            {"id",     bone   },
            {"name",   name   },
            {"parent", 0      },
            {"mdt",    nullptr}
        });
        channels.push_back({
            {"alias",  "fixture/model.wgt"                                             },
            {"frame",  0                                                               },
            {"target", bone                                                            },
            {"type",   20                                                              },
            {"keys",   Json::array({{{"frame", 0}, {"value", {100.0f / 34, 0, 0, 0}}}})}
        });
    }
    gltf["nodes"][0]["children"] = joints;
    gltf["nodes"][0]["skin"] = 0;
    gltf["skins"] = Json::array({{{"joints", joints}}});
    const std::vector<float>   values{0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 1, 0, 0, 0, 30, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0};
    std::vector<unsigned char> bytes(values.size() * sizeof(float) + 24, 0);
    std::memcpy(bytes.data(), values.data(), values.size() * sizeof(float));
    gltf["buffers"][0]["byteLength"] = bytes.size();
    gltf["buffers"][0]["uri"] = "data:application/octet-stream;base64," + Base64(bytes);
    gltf["bufferViews"].push_back({
        {"buffer",     0 },
        {"byteOffset", 68},
        {"byteLength", 48}
    });
    gltf["bufferViews"].push_back({
        {"buffer",     0  },
        {"byteOffset", 116},
        {"byteLength", 24 }
    });
    gltf["accessors"].push_back({
        {"bufferView",    3     },
        {"componentType", 5126  },
        {"count",         3     },
        {"type",          "VEC4"}
    });
    gltf["accessors"].push_back({
        {"bufferView",    4     },
        {"componentType", 5123  },
        {"count",         3     },
        {"type",          "VEC4"}
    });
    gltf["meshes"][0]["primitives"][0]["attributes"]["WEIGHTS_0"] = 3;
    gltf["meshes"][0]["primitives"][0]["attributes"]["JOINTS_0"] = 4;
    metadata["weights"] = Json::array({
        {{"alias", "fixture/model.wgt"}, {"channels", channels}}
    });
    Write(directory / "data/models/model.gltf", gltf);
    game = metadata;
    Write(directory / "data/models/model.gltf", gltf);
    std::string        error;
    char               empty[] = "";
    mgCreateVisualType types[] = {
        {.type = MG_VISUAL_CREATE_SHADOW_MDT, .name = empty  },
        {.type = MG_VISUAL_CREATE_END,        .name = nullptr}
    };
    mgLoadData load{};
    load.memory = &memory;
    load.visual_type = types;
    auto *frame = model_assets::LoadModel(std::filesystem::path("models/model.gltf"), load, error);
    ASSERT_NE(frame, nullptr) << error;
    tagMOTION_TYPE resource{};
    ASSERT_TRUE(model_assets::LoadAnimation(std::filesystem::path("models/model.gltf"), resource, memory, std::nullopt, std::nullopt, 0, std::nullopt, error)) << error;
    auto *skin = resource.skin_list;
    int   count = 0;
    for (auto *channel = skin; channel; channel = channel->next) {
        ++count;
    }
    ASSERT_EQ(count, 34);
    std::vector<std::array<float, 16> > bind(35);
    for (auto &matrix : bind) {
        matrix[0] = matrix[5] = matrix[10] = matrix[15] = 1;
    }
    tagMOTION_TYPE motion{};
    motion.skin_list = skin;
    motion.base_matrices = reinterpret_cast<sceVu0FMATRIX *>(bind.data());
    tagFRAME_INF *info = nullptr;
    AnimeDataInit(frame, &motion, &memory, &info);
    ASSERT_NE(info, nullptr);
    DeformMesh(frame, &motion, info, false);
    EXPECT_NEAR(static_cast<mgCVisualMDT *>(frame->visual)->vertex[0][0], 2.0f, .0001f);
}

namespace {

// Loads the fixture's model with every frame a shadow model.
mgCVisualMDT *LoadShadowVisual(mgCMemory &memory) {
    std::string        error;
    char               empty[] = "";
    mgCreateVisualType types[] = {
        {.type = MG_VISUAL_CREATE_SHADOW_MDT, .name = empty  },
        {.type = MG_VISUAL_CREATE_END,        .name = nullptr}
    };
    mgLoadData load{};
    load.memory = &memory;
    load.visual_type = types;
    auto *frame = model_assets::LoadModel(std::filesystem::path("models/model.gltf"), load, error);
    EXPECT_NE(frame, nullptr) << error;
    return frame != nullptr ? static_cast<mgCVisualMDT *>(frame->visual) : nullptr;
}

// Appends six triangle-list corners, 0 1 2 2 1 0, as the primitive's indices, after the buffer's first `used` bytes.
void AddShadowCorners(Json &gltf, std::vector<unsigned char> &bytes, std::size_t used) {
    const std::uint16_t corners[6] = {0, 1, 2, 2, 1, 0};
    bytes.resize(used + sizeof corners);
    std::memcpy(bytes.data() + used, corners, sizeof corners);
    gltf["buffers"][0]["byteLength"] = bytes.size();
    gltf["buffers"][0]["uri"] = "data:application/octet-stream;base64," + Base64(bytes);
    gltf["bufferViews"].push_back({
        {"buffer",     0                               },
        {"byteOffset", static_cast<int>(used)          },
        {"byteLength", static_cast<int>(sizeof corners)}
    });
    gltf["accessors"].push_back({
        {"bufferView",    gltf["bufferViews"].size() - 1},
        {"componentType", 5123                          },
        {"count",         6                             },
        {"type",          "SCALAR"                      }
    });
    gltf["meshes"][0]["primitives"][0]["indices"] = gltf["accessors"].size() - 1;
}

// Gives the primitive one normal and two uvs, so its corners carry position, normal and uv indices.
void AddNormalsAndUvs(Json &gltf, Json &game) {
    gltf["bufferViews"].push_back({
        {"buffer",     0 },
        {"byteOffset", 0 },
        {"byteLength", 24}
    });
    gltf["accessors"].push_back({
        {"bufferView",    gltf["bufferViews"].size() - 1},
        {"componentType", 5126                          },
        {"count",         3                             },
        {"type",          "VEC2"                        }
    });
    auto &primitive = gltf["meshes"][0]["primitives"][0];
    primitive["attributes"]["NORMAL"] = 0;
    primitive["attributes"]["TEXCOORD_0"] = gltf["accessors"].size() - 1;
    auto &mesh = game["meshes"][0];
    mesh["normal_count"] = 1;
    mesh["uv_count"] = 2;
    mesh["primitives"][0]["type"] = MG_PRIM_TRIANGLE;
    mesh["primitives"][0]["source_normals"] = {0, 0, 0};
    mesh["primitives"][0]["source_uvs"] = {1, 0, 1};
}

void ExpectShadowTriangles(const mgCVisualMDT *visual, const std::vector<int> &positions) {
    ASSERT_NE(visual, nullptr);
    ASSERT_NE(visual->face_group, nullptr);
    EXPECT_EQ(visual->face_group->vu_program, MG_VU_PROG_SHADOW);
    const mgCFace *face = visual->face_group->face;
    ASSERT_NE(face, nullptr);
    EXPECT_EQ(face->vertex_num, static_cast<int>(positions.size() / 3));
    EXPECT_EQ(face->index_stride, 3);
    EXPECT_EQ(face->index_num, static_cast<int>(positions.size()));
    EXPECT_EQ(std::vector<int>(face->index, face->index + positions.size()), positions);
}

std::vector<unsigned char> FixtureBytes() {
    const std::vector<float>   values{0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 1, 0, 0, 0, 30, 0, 0};
    std::vector<unsigned char> bytes(values.size() * sizeof(float));
    std::memcpy(bytes.data(), values.data(), bytes.size());
    return bytes;
}

} // namespace

// A shadow model's faces are read as retail's mgCShadowMDT::CreateFace leaves them: triangles of three position
// indices, without the normal and uv indices the visual layout carries per corner.
TEST_F(NativeModel, ShadowModelFacesKeepOnlyTrianglePositionIndices) {
    auto bytes = FixtureBytes();
    AddShadowCorners(gltf, bytes, 68);
    AddNormalsAndUvs(gltf, game);
    Write(directory / "data/models/model.gltf", gltf);
    ExpectShadowTriangles(LoadShadowVisual(memory), {0, 1, 2, 2, 1, 0});
}

// Corners with a position index only (stride 1) compact the same way.
TEST_F(NativeModel, ShadowModelFacesWithoutNormalsOrUvsKeepTheirTriangles) {
    auto bytes = FixtureBytes();
    AddShadowCorners(gltf, bytes, 68);
    Write(directory / "data/models/model.gltf", gltf);
    ExpectShadowTriangles(LoadShadowVisual(memory), {0, 1, 2, 2, 1, 0});
}

// Retail's shadow draw takes triangle lists only, so a strip keeps no triangles.
TEST_F(NativeModel, ShadowModelStripFacesKeepNoTriangles) {
    auto bytes = FixtureBytes();
    AddShadowCorners(gltf, bytes, 68);
    gltf["meshes"][0]["primitives"][0]["mode"] = 5;
    Write(directory / "data/models/model.gltf", gltf);
    ExpectShadowTriangles(LoadShadowVisual(memory), {});
}

// A morph moves a shadow model's vertices without handing its rewritten faces to the visual face builder.
TEST_F(NativeModel, ShadowModelMorphKeepsShadowFaces) {
    const std::vector<float>   values{0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 1, 0, 2, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 1, 0, 0};
    std::vector<unsigned char> bytes(values.size() * sizeof(float));
    std::memcpy(bytes.data(), values.data(), bytes.size());
    gltf["bufferViews"][2]["byteLength"] = 8;
    gltf["accessors"][2]["type"] = "SCALAR";
    gltf["bufferViews"].push_back({
        {"buffer",     0 },
        {"byteOffset", 68},
        {"byteLength", 36}
    });
    gltf["accessors"].push_back({
        {"bufferView",    3     },
        {"componentType", 5126  },
        {"count",         3     },
        {"type",          "VEC3"}
    });
    gltf["meshes"][0]["primitives"][0]["targets"] = Json::array({{{"POSITION", 3}}});
    gltf["nodes"] = Json::array({
        {{"name", "root"}, {"children", {1}}},
        {{"mesh", 0}}
    });
    game["frames"][0]["rotation_node"] = 1;
    gltf["animations"][0]["channels"][0]["target"]["node"] = 1;
    gltf["animations"][0]["channels"][0]["target"]["path"] = "weights";
    AddShadowCorners(gltf, bytes, values.size() * sizeof(float));
    AddNormalsAndUvs(gltf, game);
    Write(directory / "data/models/model.gltf", gltf);

    std::string        error;
    char               empty[] = "";
    mgCreateVisualType types[] = {
        {.type = MG_VISUAL_CREATE_SHADOW_MDT, .name = empty  },
        {.type = MG_VISUAL_CREATE_END,        .name = nullptr}
    };
    mgLoadData load{};
    load.memory = &memory;
    load.visual_type = types;
    auto *frame = model_assets::LoadModel(std::filesystem::path("models/model.gltf"), load, error);
    ASSERT_NE(frame, nullptr) << error;
    auto *visual = static_cast<mgCVisualMDT *>(frame->visual);
    ASSERT_NE(visual, nullptr);
    ASSERT_NE(visual->face_group, nullptr);
    const mgVisualFaceMesh *before = mgVisualPortFaceMesh(visual->face_group->face);
    auto                    motion = Motion();
    ASSERT_NE(motion.motion_list, nullptr);
    SetMotionTime(frame, &motion, 15, nullptr);
    EXPECT_EQ(mgVisualPortFaceMesh(visual->face_group->face), before);
    ExpectShadowTriangles(visual, {0, 1, 2, 2, 1, 0});
    EXPECT_FLOAT_EQ(visual->vertex[0][0], 1);
    EXPECT_FLOAT_EQ(visual->vertex[1][0], 3);
}

// A skin's glTF inverse binds hold only in the hierarchy it was loaded with; a visual attached to another character's
// frames, as a costume piece is, skins from that character's base matrices as retail does.
TEST_F(NativeModel, SkinUsesGltfBindsOnlyInItsLoadedHierarchy) {
    std::vector<float> values{0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 1, 0, 0, 0, 30, 0, 0};
    for (int vertex = 0; vertex < 3; ++vertex) {
        values.insert(values.end(), {1, 0, 0, 0});
    }
    const std::vector<std::uint16_t> joints(12, 0);
    std::vector<unsigned char>       bytes((values.size() * sizeof(float)) + (joints.size() * sizeof(std::uint16_t)));
    std::memcpy(bytes.data(), values.data(), values.size() * sizeof(float));
    std::memcpy(&bytes.at(values.size() * sizeof(float)), joints.data(), joints.size() * sizeof(std::uint16_t));
    gltf["buffers"][0]["byteLength"] = bytes.size();
    gltf["buffers"][0]["uri"] = "data:application/octet-stream;base64," + Base64(bytes);
    for (const auto &[offset, length] : std::array<std::pair<int, int>, 2>{
             {{68, 48}, {116, 24}}
    }) {
        gltf["bufferViews"].push_back({
            {"buffer",     0     },
            {"byteOffset", offset},
            {"byteLength", length}
        });
    }
    for (int index = 0; index < 2; ++index) {
        gltf["accessors"].push_back({
            {"bufferView",    3 + index               },
            {"componentType", index == 0 ? 5126 : 5123},
            {"count",         3                       },
            {"type",          "VEC4"                  }
        });
    }
    auto &attributes = gltf["meshes"][0]["primitives"][0]["attributes"];
    attributes["WEIGHTS_0"] = 3;
    attributes["JOINTS_0"] = 4;
    gltf["nodes"][0]["skin"] = 0;
    gltf["nodes"][0]["children"] = {1};
    gltf["nodes"].push_back({
        {"name", "bone"}
    });
    gltf["skins"] = Json::array({{{"joints", {1}}}});
    game["frames"].push_back({
        {"id",  1      },
        {"mdt", nullptr}
    });
    Write(directory / "data/models/model.gltf", gltf);
    char               empty[] = "";
    mgCreateVisualType types[] = {
        {.type = MG_VISUAL_CREATE_MOTION_MDT, .name = empty  },
        {.type = MG_VISUAL_CREATE_END,        .name = nullptr}
    };
    mgLoadData load{};
    load.memory = &memory;
    load.visual_type = types;
    std::string error;
    auto       *root = model_assets::LoadModel(std::filesystem::path("models/model.gltf"), load, error);
    ASSERT_NE(root, nullptr) << error;
    auto *visual = static_cast<mgCVisualMotionMDT *>(root->visual);
    ASSERT_NE(visual, nullptr);
    ASSERT_EQ(visual->bone[0], 1);

    // Base matrices that place the bone 5 units along x; the glTF binds ignore them.
    sceVu0FMATRIX base[2]{};
    for (auto &matrix : base) {
        for (int axis = 0; axis < 4; ++axis) {
            matrix[axis][axis] = 1;
        }
    }
    base[1][3][0] = 5;
    visual->base_matrix = base;
    float object[4][4]{};
    for (int axis = 0; axis < 4; ++axis) {
        object[axis][axis] = 1;
    }
    auto &palette = mgVisualPortCurrentProg0().bones[0];
    visual->CreateExtRenderInfoPacket(nullptr, object, &mgRenderInfo);
    EXPECT_NEAR(palette[0][3], 0.0f, .0001f);

    std::array<mgCFrame *, 2> attached{visual->frame[0], visual->frame[1]};
    visual->frame = attached.data();
    visual->CreateExtRenderInfoPacket(nullptr, object, &mgRenderInfo);
    EXPECT_NEAR(palette[0][3], -5.0f, .0001f);
}

TEST_F(NativeModel, ReadsAllStandardJointGroupsAndPreservesNativeGpuInfluenceLimit) {
    std::vector<float> values{0, 0, 0, 2, 0, 0, 0, 2, 0, 0, 1, 0, 0, 0, 30, 0, 0};
    for (int vertex = 0; vertex < 3; ++vertex) {
        values.insert(values.end(), {.1f, .2f, .3f, .1f});
    }
    for (int vertex = 0; vertex < 3; ++vertex) {
        values.insert(values.end(), {.3f, 0, 0, 0});
    }
    const std::vector<std::uint16_t> joints{0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 4, 0, 0, 0, 4, 0, 0, 0, 4, 0, 0, 0};
    std::vector<unsigned char>       bytes(values.size() * sizeof(float) + joints.size() * sizeof(std::uint16_t));
    std::memcpy(bytes.data(), values.data(), values.size() * sizeof(float));
    std::memcpy(bytes.data() + values.size() * sizeof(float), joints.data(), joints.size() * sizeof(std::uint16_t));
    gltf["buffers"][0]["byteLength"] = bytes.size();
    gltf["buffers"][0]["uri"] = "data:application/octet-stream;base64," + Base64(bytes);
    for (const auto &[offset, length] : std::array<std::pair<int, int>, 4>{
             {{68, 48}, {116, 48}, {164, 24}, {188, 24}}
    }) {
        gltf["bufferViews"].push_back({
            {"buffer",     0     },
            {"byteOffset", offset},
            {"byteLength", length}
        });
    }
    for (int index = 0; index < 4; ++index) {
        gltf["accessors"].push_back({
            {"bufferView",    3 + index              },
            {"componentType", index < 2 ? 5126 : 5123},
            {"count",         3                      },
            {"type",          "VEC4"                 }
        });
    }
    auto &attributes = gltf["meshes"][0]["primitives"][0]["attributes"];
    attributes["WEIGHTS_0"] = 3;
    attributes["WEIGHTS_1"] = 4;
    attributes["JOINTS_0"] = 5;
    attributes["JOINTS_1"] = 6;
    gltf["nodes"][0]["skin"] = 0;
    gltf["nodes"][0]["children"] = {1, 2, 3, 4, 5};
    gltf["skins"] = Json::array({{{"joints", {1, 2, 3, 4, 5}}}});
    for (int index = 1; index <= 5; ++index) {
        gltf["nodes"].push_back({
            {"name", "bone" + std::to_string(index)}
        });
        game["frames"].push_back({
            {"id",  index  },
            {"mdt", nullptr}
        });
    }
    gltf["nodes"][0].erase("mesh");
    gltf["nodes"][0].erase("skin");
    gltf["nodes"][0]["children"] = {6};
    gltf["nodes"].push_back({
        {"mesh",     0              },
        {"skin",     0              },
        {"children", {1, 2, 3, 4, 5}}
    });
    gltf["nodes"][1]["children"] = {7};
    gltf["nodes"].push_back(Json::object());
    gltf["skins"][0]["joints"][0] = 7;
    game["frames"][0]["rotation_node"] = 6;
    game["frames"][1]["rotation_node"] = 7;
    Write(directory / "data/models/model.gltf", gltf);
    char               empty[] = "";
    mgCreateVisualType types[] = {
        {.type = MG_VISUAL_CREATE_MOTION_MDT, .name = empty  },
        {.type = MG_VISUAL_CREATE_END,        .name = nullptr}
    };
    mgLoadData load{};
    load.memory = &memory;
    load.visual_type = types;
    std::string error;
    auto       *root = model_assets::LoadModel(std::filesystem::path("models/model.gltf"), load, error);
    ASSERT_NE(root, nullptr) << error;
    auto *visual = static_cast<mgCVisualMotionMDT *>(root->visual);
    EXPECT_EQ(root->frame_num, 6);
    EXPECT_EQ(visual->bone[0], 1);
    ASSERT_NE(visual->weight, nullptr);
    EXPECT_NEAR(visual->weight[0].weight[0], 1.0f / 7, .00001f);
    EXPECT_NEAR(visual->weight[0].weight[1], 2.0f / 7, .00001f);
    EXPECT_NEAR(visual->weight[0].weight[2], 3.0f / 7, .00001f);
    EXPECT_NEAR(visual->weight[0].weight[3], 1.0f / 7, .00001f);
    EXPECT_EQ(visual->weight[0].matrix[3], 12);
}

TEST(NativeCharacterRetail, LoadsConvertedC01ProfileAndEvaluatesItsNativeMotion) {
    const auto *fixture = std::getenv("CT_NATIVE_CHARACTER_FIXTURE");
    if (!fixture) {
        GTEST_SKIP() << "CT_NATIVE_CHARACTER_FIXTURE selects an extracted glTF/game JSON pair";
    }
    std::filesystem::path path(fixture);
    std::filesystem::path sidecar = path;
    sidecar.replace_extension(".game.json");
    std::ifstream gltf_file(path, std::ios::binary);
    std::ifstream game_file(sidecar, std::ios::binary);
    ASSERT_TRUE(gltf_file && game_file);
    const std::string gltf((std::istreambuf_iterator<char>(gltf_file)), {});
    Json              game;
    game_file >> game;
    std::vector<u_long128> arena(2 * 1024 * 1024);
    std::vector<u_long128> texture_arena(65536);
    mgCMemory              memory;
    mgCMemory              textures;
    memory.stSetBuffer(arena.data(), static_cast<int>(arena.size()));
    textures.stSetBuffer(texture_arena.data(), static_cast<int>(texture_arena.size()));
    mgTexManager.SetTableBuffer(1024, 64, &textures);
    mgTexManager.Initialize(0x1000, -1);
    CCharacter2 character;
    character.Initialize();
    model_assets::CharacterLoadOptions options{.model_memory = &memory, .motion_memory = &memory, .image_memory = &memory};
    options.outline = false;
    std::string error;
    // The fixture's directory supplies its buffer file and PNGs.
    datapacks::Load(path.parent_path());
    ASSERT_TRUE(model_assets::LoadCharacter(character, {reinterpret_cast<const std::byte *>(gltf.data()), gltf.size()}, game, "info", options, error)) << error;
    ASSERT_NE(character.CObjectFrame::frame, nullptr);
    EXPECT_GT(character.CObjectFrame::frame->frame_num, 1);
    ASSERT_NE(character.GetKeyListIndexPtr(0, nullptr), nullptr);
    EXPECT_GT(character.key_num[0], 1);
    const auto estimate = model_assets::EstimateCharacterMemory(path.filename(), "info", error);
    ASSERT_TRUE(estimate.has_value()) << error;
    EXPECT_GE(*estimate, static_cast<std::size_t>(memory.stack_used) * 16);
    std::println(stderr, "native c01 arena: {} bytes; allocation estimate: {} bytes", static_cast<std::size_t>(memory.stack_used) * 16, *estimate);
    ASSERT_NE(character.motion[0].motion_list, nullptr);
    // The idle action keeps its original name for the game's own lookups.
    auto *idle = character.GetKeyListPtr(const_cast<char *>("\x97\xA7\x82\xBF"), nullptr);
    ASSERT_NE(idle, nullptr);
    ASSERT_NE(character_motion::At(character.motion[0], idle->start_frame + .5f), nullptr);
    SetMotionTime(character.CObjectFrame::frame, &character.motion[0], idle->start_frame + .5f, nullptr);
    for (int index = 0; index < character.CObjectFrame::frame->frame_num; ++index) {
        const auto *frame = character.CObjectFrame::frame->GetFrame(index);
        ASSERT_NE(frame, nullptr);
        for (const auto &column : frame->trans_matrix) {
            for (float value : column) {
                EXPECT_TRUE(std::isfinite(value));
            }
        }
    }
    mgTexManager.Initialize(0x1000, -1);
    model_assets::Clear();
    datapacks::Clear();
}
