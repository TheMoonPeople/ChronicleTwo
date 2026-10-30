#include "common.h"

#include <gtest/gtest-spi.h>
#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <array>
#include <chrono>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <limits>
#include <vector>

#include "assets/data_registry.hpp"
#include "character.hpp"
#include "dataread.hpp"
#include "fishing.hpp"
#include "mainloop.hpp"
#include "menuaqua.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mg_visual.hpp"
#include "mglib.hpp"
#include "nd_meswin.hpp"
#include "platform/arena.hpp"
#include "platform/datapacks.hpp"
#include "platform/game_loop_state.hpp"
#include "platform/model_assets.hpp"
#include "savedata.hpp"
#include "scoped_global_object.hpp"
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
    std::string            previous_directory;
    std::vector<u_long128> storage = std::vector<u_long128>(16384);
    alignas(16) std::array<u_long128, 128> scratch{};
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
        previous_directory = GetCurrentDir();
        SetCurrentDir(nullptr);
        std::filesystem::create_directories(root / "data/models");
        const std::array<float, 9> positions{0, 0, 0, 1, 0, 0, 0, 1, 0};
        std::ofstream              binary(root / "data/models/fish.bin", std::ios::binary);
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
        Write(root / "data/models/fish.gltf", gltf);
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
        Write(root / "data/models/fish.game.json", game);
        Write(root / "data/textures/menu/aqua/fish/f01a1.json", Texture(4));
        Write(root / "data/textures/menu/aqua/fish/f01a2.json", Texture(8));
        std::filesystem::create_directories(root / "data");
        DataReadIndex(root / "data");
        texture_memory.SetHeapMem(texture_storage.data(), static_cast<int>(texture_storage.size()));
        texture_memory.StartStackMode(MG_STACK_MODE_FIT, static_cast<int>(texture_storage.size()));
        mgTexManager.SetTableBuffer(64, 64, &texture_memory);
        mgTexManager.Initialize(0x1000, -1);
        memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
        character.Initialize();
        model_assets::CharacterLoadOptions options{.model_memory = &memory, .motion_memory = &memory, .image_memory = &memory, .textures = &mgTexManager, .parent = nullptr, .texture_block = 20, .outline = false};
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
    EXPECT_EQ(GetCurrentDir(), directory);
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

TEST(AquariumMemory, BubbleCountsRejectNegativeAndOversizedAllocationsBeforeWriting) {
    std::array<u_long128, 8> storage{};
    std::memset(storage.data(), 0xA5, sizeof(storage));
    const auto original = storage;
    mgCMemory  memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    CBubble emitter{};
    float   origin[4]{1.0f, 2.0f, 3.0f, 1.0f};
    for (const int count : {-1, std::numeric_limits<int>::max()}) {
        emitter.Initialize(&memory, origin, count, 10.0f);
        EXPECT_EQ(emitter.bubble, nullptr);
        EXPECT_EQ(emitter.bubble_num, 0u);
        EXPECT_FALSE(emitter.active);
        EXPECT_EQ(memory.stack_used, 0);
        EXPECT_EQ(storage, original);
    }
}

TEST(AquariumMemory, BubbleStorageUsesHostSizeAndRejectsInvalidParticleIndices) {
    std::array<u_long128, 16> storage{};
    std::memset(storage.data(), 0xA5, sizeof(storage));
    mgCMemory memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    CBubble emitter{};
    float   origin[4]{1.0f, 2.0f, 3.0f, 1.0f};
    emitter.Initialize(&memory, origin, 2, 10.0f);
    ASSERT_NE(emitter.bubble, nullptr);
    EXPECT_EQ(memory.stack_used, *dc2::memory::ArrayQuadwords<AQUA_BUBBLE>(2));
    EXPECT_EQ(emitter.origin[3], 1.0f);
    EXPECT_EQ(emitter.bubble[0].pos[3], 1.0f);
    EXPECT_EQ(emitter.bubble[1].pos[3], 1.0f);
    const auto before = storage;
    emitter.Generate(-1);
    emitter.Generate(2);
    EXPECT_EQ(storage, before);
    EXPECT_EQ(storage.back(), static_cast<u_long128>(0xA5A5A5A5A5A5A5A5ULL) << 64 | 0xA5A5A5A5A5A5A5A5ULL);
}

TEST_F(NativeFishTexture, PrizeDocumentsKeepOwnedHostSizedStorageAcrossLaterRefreshes) {
    Json       groups = Json::array();
    const Json ranks = Json::array({Json::array({101, 2}), Json::array({102, 3}), Json::array({103, 4})});
    for (int group = 0; group < 12; ++group) {
        groups.push_back({
            {"prize_count", 128                                           },
            {"rates",       Json::array({1, 1, 1, 1, 1, 1, 1, 1})         },
            {"prizes",      Json::array({{{"rate", 1}, {"ranks", ranks}}})}
        });
    }
    Write(root / "data/gyop.cfg.json", {
                                           {"schema_version", 2            },
                                           {"kind",           "fish_prizes"},
                                           {"count",          12           },
                                           {"groups",         groups       }
    });
    DataReadIndex(root / "data");
    auto  save_owner = dc2::test::BindGlobalOwner<PortActiveSaveData>(std::make_unique<CSaveData>());
    auto *save = GetSaveData();
    ASSERT_EQ(save, save_owner.get());
    std::array<s16, 4> previous_wins{};
    for (int race = 0; race < 4; ++race) {
        const int flag = SAVE_SHORT_FLAG_FISH_WINS_CLASS0 + race;
        previous_wins[static_cast<std::size_t>(race)] = save->GetShortFlag(flag);
        save->SetShortFlag(flag, 0);
    }
    EXPECT_EQ(LoadFishPrize(0), 1);
    RefreshFishPrize();
    for (int race = 0; race < 4; ++race) {
        FISH_PRIZE_INFO prize{};
        EXPECT_EQ(GetFishPrize(race, 2, &prize), 1);
        EXPECT_EQ(prize.item_no, 103);
        EXPECT_EQ(prize.num, 4);
        save->SetShortFlag(SAVE_SHORT_FLAG_FISH_WINS_CLASS0 + race, previous_wins[static_cast<std::size_t>(race)]);
    }
    InitFishPrize();
}

namespace {
int *scoped_fixture_pointer = nullptr;

/**
 * Exercises an assertion return while a scoped replacement owns the global binding.
 */
void FailInsideScopedGlobalFixture() {
    dc2::test::ScopedGlobalObject<scoped_fixture_pointer> replacement(42);
    ASSERT_EQ(*scoped_fixture_pointer, -1) << "fixture early exit";
}

struct GlobalDestructionProbe;
GlobalDestructionProbe *destruction_probe = nullptr;

/**
 * Checks that its global reference has been restored before its destructor runs.
 */
struct GlobalDestructionProbe {
    bool &detached; /**< Result observed by the surrounding test scope. */

    explicit GlobalDestructionProbe(bool &result) : detached(result) {}

    ~GlobalDestructionProbe() { detached = destruction_probe != this; }
};
} // namespace

TEST(ScopedGlobalFixture, NestedOwnersRestoreTheSurroundingLiveObject) {
    ASSERT_EQ(scoped_fixture_pointer, nullptr);
    {
        dc2::test::ScopedGlobalObject<scoped_fixture_pointer> outer(7);
        EXPECT_EQ(scoped_fixture_pointer, outer.get());
        {
            dc2::test::ScopedGlobalObject<scoped_fixture_pointer> inner(9);
            EXPECT_EQ(scoped_fixture_pointer, inner.get());
            EXPECT_EQ(*scoped_fixture_pointer, 9);
        }
        EXPECT_EQ(scoped_fixture_pointer, outer.get());
        EXPECT_EQ(*scoped_fixture_pointer, 7);
    }
    EXPECT_EQ(scoped_fixture_pointer, nullptr);
}

TEST(ScopedGlobalFixture, AssertionReturnRestoresTheSurroundingLiveObject) {
    ASSERT_EQ(scoped_fixture_pointer, nullptr);
    {
        dc2::test::ScopedGlobalObject<scoped_fixture_pointer> outer(11);
        EXPECT_FATAL_FAILURE(FailInsideScopedGlobalFixture(), "fixture early exit");
        EXPECT_EQ(scoped_fixture_pointer, outer.get());
        EXPECT_EQ(*scoped_fixture_pointer, 11);
    }
    EXPECT_EQ(scoped_fixture_pointer, nullptr);
}

TEST(ScopedGlobalFixture, GlobalIsRestoredBeforeTheReplacementIsDestroyed) {
    bool detached = false;
    {
        dc2::test::ScopedGlobalObject<destruction_probe> fixture(detached);
        EXPECT_EQ(destruction_probe, fixture.get());
    }
    EXPECT_TRUE(detached);
    EXPECT_EQ(destruction_probe, nullptr);
}

TEST(NativeFishMessages, MissingDocumentLeavesEveryConstructedWindowUnbound) {
    static char           identity;
    constexpr std::size_t quadwords = 7 * ((sizeof(ClsMes) + sizeof(u_long128) - 1) / sizeof(u_long128)) + 8;
    mgCMemory             memory;
    auto                 *root = reinterpret_cast<u_long128 *>(ArenaBlock(&identity, quadwords * sizeof(u_long128)));
    memory.stSetBuffer(root, static_cast<int>(quadwords));
    std::memset(root, 0xA5, quadwords * sizeof(u_long128));
    CAquaMes  messages;
    const int old_language = LanguageCode;
    LanguageCode = std::numeric_limits<int>::max();
    messages.Initialize(&memory);
    LanguageCode = old_language;
    for (auto *window : {messages.title_mes, messages.menu_mes, messages.guide_mes, messages.question_mes,
                         messages.help_mes, messages.info_mes, messages.fish_mes}) {
        ASSERT_NE(window, nullptr);
        EXPECT_EQ(window->buff, nullptr);
    }
    EXPECT_FALSE(messages.title_draw);
    EXPECT_FALSE(messages.menu_draw);
    EXPECT_FALSE(messages.info_draw);
    EXPECT_EQ(messages.question_num, 0);
}
