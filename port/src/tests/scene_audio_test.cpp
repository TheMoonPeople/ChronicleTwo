#include "common.h"

#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <array>
#include <chrono>
#include <cstdint>
#include <filesystem>
#include <fstream>
#include <limits>
#include <memory>
#include <string>

#include "assets/data_registry.hpp"
#include "mg_memory.hpp"
#include "platform/datapacks.hpp"
#include "scenesnd.hpp"
#include "texture_source.hpp"

namespace {
using Json = nlohmann::json;

/**
 * Supplies scene sound tables without loading game state or proprietary resources.
 */
class SceneAudio : public testing::Test {
protected:
    std::unique_ptr<CScene> scene = std::make_unique<CScene>();

    static Json Reverbs() {
        return {
            {"schema_version", 1                                                     },
            {"kind",           "scene_reverb"                                        },
            {"rows",           Json::array({{{"id", 7}, {"type", 4}, {"depth", 23}}})}
        };
    }

    static Json Routes() {
        return {
            {"schema_version", 1                                                                                                                                                                                                                      },
            {"kind",           "scene_sound_routes"                                                                                                                                                                                                   },
            {"rows",           Json::array({{{"id", 1000}, {"bgm_no", 12}, {"se_base", -2}, {"se_battle", 3}, {"se_env", 8}, {"env_bgm", -1}, {"env_vol", 91}, {"se_src", {-2, -1, -1, -1, -1, -1, -1, -1}}, {"event_se", {4, 9}}, {"reverb_id", 7}}})}
        };
    }

    void Reverb(const Json &document) {
        auto text = document.dump(2);
        TextureSourceForget(text.data());
        scene->LoadSndRevInfo(text.data(), static_cast<int>(text.size()));
    }

    void Route(const Json &document) {
        auto text = document.dump(2);
        TextureSourceForget(text.data());
        scene->LoadSndFileInfo(text.data(), static_cast<int>(text.size()));
    }
};
} // namespace

TEST_F(SceneAudio, DirectTablesPreserveMapRoutingAndResolveReverbOverrides) {
    Reverb(Reverbs());
    Route(Routes());
    ASSERT_EQ(scene->snd_rev_num, 1);
    ASSERT_EQ(scene->snd_file_num, 1);
    const auto &route = scene->snd_file[0];
    EXPECT_EQ(route.id, 1000);
    EXPECT_EQ(scene->GetDefBgmNo(1000), 12);
    EXPECT_EQ(route.se_base, -2);
    EXPECT_EQ(route.se_battle, 3);
    EXPECT_EQ(route.se_env, 8);
    EXPECT_EQ(route.env_bgm, -1);
    EXPECT_EQ(route.env_vol, 91);
    EXPECT_EQ(route.se_src[0], -2);
    EXPECT_EQ(route.se_src[7], -1);
    EXPECT_EQ(route.reverb_type, 4);
    EXPECT_EQ(route.reverb_depth, 23);
    const auto event_path = scene->GetDefEventSeFile(1000);
    ASSERT_TRUE(event_path);
    EXPECT_EQ(*event_path, "snd2/event/ev_004_009.sound.json");
    auto override = Reverbs();
    override["rows"][0]["depth"] = 77;
    Reverb(override);
    Route(Routes());
    EXPECT_EQ(scene->snd_file[0].reverb_depth, 77);
}

TEST_F(SceneAudio, GeneratedPathsAreOwnedAndHandleExtremeNumbers) {
    Reverb(Reverbs());
    Route(Routes());
    EXPECT_EQ(scene->GetBgmFile(std::numeric_limits<int>::max()), "snd2/bgm/bg_2147483647.sound.json");
    EXPECT_EQ(scene->GetSeSrcFile(std::numeric_limits<int>::min()), "snd2/ob/ob_00-2147483648.sound.json");
    EXPECT_FALSE(scene->GetDefEventSeFile(999).has_value());

    auto routes = Routes();
    routes["rows"][0]["event_se"] = {std::numeric_limits<std::int16_t>::min(), std::numeric_limits<std::int16_t>::max()};
    Route(routes);
    const auto event_path = scene->GetDefEventSeFile(1000);
    ASSERT_TRUE(event_path);
    EXPECT_EQ(*event_path, "snd2/event/ev_00-32768_32767.sound.json");
}

TEST_F(SceneAudio, MalformedAndOversizedDocumentsDoNotPartiallyReplaceTables) {
    Reverb(Reverbs());
    Route(Routes());
    auto malformed = Routes();
    malformed["rows"][0]["bgm_no"] = 42;
    malformed["rows"].push_back(malformed["rows"][0]);
    malformed["rows"][1]["se_src"] = {1, 2};
    Route(malformed);
    EXPECT_EQ(scene->snd_file_num, 1);
    EXPECT_EQ(scene->snd_file[0].bgm_no, 12);
    auto oversized = Routes();
    oversized["rows"] = Json::array();
    for (int index = 0; index < 513; ++index) {
        oversized["rows"].push_back(Routes()["rows"][0]);
    }
    Route(oversized);
    EXPECT_EQ(scene->snd_file_num, 1);
    auto invalid = Reverbs();
    invalid["rows"][0]["depth"] = std::numeric_limits<std::uint64_t>::max();
    Reverb(invalid);
    EXPECT_EQ(scene->snd_rev_num, 1);
    EXPECT_EQ(scene->snd_rev[0].depth, 23);
}

TEST_F(SceneAudio, MalformedDatapackFallsThroughToValidBaseTable) {
    const auto previous = datapacks::Root();
    const auto root = std::filesystem::temp_directory_path() / ("scene_audio_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
    std::filesystem::create_directories(root / "data/snd2");
    std::filesystem::create_directories(root / "datapacks/test/snd2");
    std::ofstream(root / "data/snd2/rev.json") << Reverbs().dump(2);
    std::ofstream(root / "datapacks/test/snd2/rev.json") << "invalid JSON";
    std::ofstream(root / "datapacks/datapacks.json") << Json({
                                                                 {"schema_version", 1       },
                                                                 {"load_order",     {"test"}}
    })
                                                            .dump(2);
    datapacks::Load(root / "data");
    std::string text = "invalid JSON";
    DataReadRegisterAsset(text.data(), "snd2/rev.json", text.size());
    scene->LoadSndRevInfo(text.data(), static_cast<int>(text.size()));
    EXPECT_EQ(scene->snd_rev_num, 1);
    EXPECT_EQ(scene->snd_rev[0].depth, 23);
    DataReadRegisterBuffer(text.data(), 0);
    TextureSourceForget(text.data());
    if (previous.empty()) {
        datapacks::Clear();
    } else {
        datapacks::Load(previous);
    }
    std::error_code error;
    std::filesystem::remove_all(root, error);
}

TEST(SceneReadStorage, ResetAndAddressReuseCannotReviveAnOldSceneWorkspace) {
    std::array<u_long128, 64> storage{};
    mgCMemory                 memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    auto *first = memory.Alloc(8);
    ASSERT_NE(first, nullptr);
    CScene scene;
    scene.read_buffer_storage = dc2::memory::ArenaBuffer::Bind(memory, dc2::memory::AllocationBytes(memory, first));
    ASSERT_FALSE(scene.GetReadBufferBytes().empty());
    memory.stReset();
    EXPECT_TRUE(scene.GetReadBufferBytes().empty());
    auto *reused = memory.Alloc(8);
    ASSERT_EQ(reused, first);
    EXPECT_TRUE(scene.GetReadBufferBytes().empty());
    scene.read_buffer_storage = dc2::memory::ArenaBuffer::Bind(memory, dc2::memory::AllocationBytes(memory, reused));
    EXPECT_FALSE(scene.GetReadBufferBytes().empty());
}

TEST(SceneReadStorage, UnalignedWorkspaceIsRejectedBeforeAnyTypedReaderReceivesIt) {
    std::array<u_long128, 64> storage{};
    mgCMemory                 memory;
    memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    auto *data = memory.Alloc(8);
    ASSERT_NE(data, nullptr);
    CScene     scene;
    const auto bytes = dc2::memory::AllocationBytes(memory, data);
    scene.read_buffer_storage = dc2::memory::ArenaBuffer::Bind(memory, bytes.subspan(1));
    EXPECT_TRUE(scene.GetReadBufferBytes().empty());
}

TEST(SceneStackStorage, PhysicalBoundsOverrideAForgedDeclaredStackCount) {
    auto      scene = std::make_unique<CScene>();
    mgCMemory memory;
    scene->stack_num = std::numeric_limits<int>::max();
    auto *previous_work = scene->work_stack;
    scene->SetStack(12, &memory);
    EXPECT_EQ(scene->work_stack, previous_work);
    EXPECT_EQ(scene->GetStack(12), nullptr);
    scene->AssignStack(std::numeric_limits<int>::max());
    scene->AssignStack(-1);
}

TEST(SceneStackStorage, AssignedTailDependsOnItsExplicitPrecedingArena) {
    auto                      scene = std::make_unique<CScene>();
    std::array<u_long128, 64> storage{};
    mgCMemory                 parent;
    mgCMemory                 child;
    parent.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
    scene->SetStack(1, &parent);
    scene->SetStack(2, &child);
    scene->AssignStack(2);
    EXPECT_EQ(child.stGetTop(), parent.stGetTop());
    EXPECT_EQ(child.stack_size, parent.stGetRest());
    EXPECT_EQ(scene->stack_no, 2);
    parent.stReset();
    EXPECT_EQ(child.stGetTop(), nullptr);
}
