#include "common.h"

#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <array>
#include <chrono>
#include <cstdint>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <memory>
#include <optional>
#include <string>
#include <vector>

#include "assets/data_registry.hpp"
#include "dng_main.hpp"
#include "luau_runtime.hpp"
#include "mg_memory.hpp"
#include "monster.hpp"
#include "native_document_fixture.hpp"
#include "platform/model_assets.hpp"
#include "platform/paths.hpp"

namespace {
/**
 * Supplies a valid model larger than the dungeon read scratch without requiring retail data.
 */
class NativeMonsterLoad : public testing::Test {
protected:
    std::filesystem::path root = std::filesystem::temp_directory_path() / ("native_monster_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
    std::filesystem::path previous = PathsDataRoot();
    u_long128            *previous_buffer = BuffReadData;
    alignas(16) std::array<u_long128, 128> scratch{};
    std::vector<u_long128>       storage = std::vector<u_long128>(16384);
    mgCMemory                    memory;
    std::unique_ptr<CMonsterMan> manager = std::make_unique<CMonsterMan>();

    void SetUp() override {
        using Json = nlohmann::json;
        std::filesystem::create_directories(root / "data/dungeon/monster");
        std::filesystem::create_directories(root / "data");
        const Json gltf = {
            {"asset",  {{"version", "2.0"}}             },
            {"scene",  0                                },
            {"scenes", Json::array({{{"nodes", {0}}}})  },
            {"nodes",  Json::array({{{"name", "root"}}})}
        };
        std::ofstream model(root / "data/dungeon/monster/p00_23a.gltf", std::ios::binary);
        model << gltf.dump(2) << std::string(8 * 1024 * 1024, ' ');
        model.close();
        const Json metadata = {
            {"schema_version",  1                                                                             },
            {"frames",          Json::array({{{"id", 0}, {"name", "root"}, {"parent", -1}, {"mdt", nullptr}}})},
            {"meshes",          Json::array()                                                                 },
            {"motion_channels", Json::array()                                                                 },
            {"weights",         Json::array()                                                                 },
            {"bind_poses",      Json::array()                                                                 }
        };
        Json game = {
            {"schema_version", 1                      },
            {"kind",           "character"            },
            {"models",         Json::array({metadata})},
            {"resources",      Json::object()         }
        };
        const Json resource = {
            {"type",  "resource"},
            {"kind",  "model"   },
            {"index", 0         }
        };
        const Json command = {
            {"command", "MODEL"                },
            {"args",    Json::array({resource})}
        };
        game["profiles"]["p00_23a"]["commands"] = Json::array({command});
        dc::test::WriteNativeDocument(root / "data/dungeon/monster/p00_23a.game.json", game);
        std::filesystem::create_directories(root / "scripts/dungeon/monster");
        std::ofstream(root / "scripts/dungeon/monster/native_fixture.luau") << "return { setup = function() end }\n";
        luau_runtime::SetScriptsRoot(root / "scripts");
        DataReadIndex(root / "data");
        std::memset(scratch.data(), 0xA5, sizeof(scratch));
        BuffReadData = scratch.data();
        memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
        for (auto &refer : manager->refer) {
            refer.id = -1;
        }
    }

    void TearDown() override {
        luau_runtime::SetScriptsRoot({});
        BuffReadData = previous_buffer;
        model_assets::Clear();
        DataReadIndex(previous);
        std::error_code error;
        std::filesystem::remove_all(root, error);
    }
};
} // namespace

TEST_F(NativeMonsterLoad, LoadsOversizedGltfWithoutWritingOriginalReadScratch) {
    ASSERT_GT(std::filesystem::file_size(root / "data/dungeon/monster/p00_23a.gltf"), 4160000u);
    const auto       before = scratch;
    BASE_MONSTER_TBL table{};
    std::strcpy(table.model, "p00_23a");
    std::strcpy(table.script, "native_fixture");
    ASSERT_TRUE(manager->LoadReferMonsterFile(511, &table, &memory));
    EXPECT_EQ(std::memcmp(scratch.data(), before.data(), sizeof(scratch)), 0);
    EXPECT_EQ(manager->refer[0].id, 511);
    EXPECT_EQ(manager->refer[0].chara.tbl, &table);
    ASSERT_NE(manager->refer[0].chara.GetFrame(), nullptr);
    const auto script = manager->refer[0].script;
    EXPECT_EQ(luau_runtime::HandleModule({reinterpret_cast<const char *>(script.data()), script.size()}),
              std::optional<std::string>("dungeon/monster/native_fixture"));
}

TEST_F(NativeMonsterLoad, RejectsSwordEffectCountsBeyondCharacterSlots) {
    BASE_MONSTER_TBL table{};
    table.sw_effect_num = CHARA_SWORD_EFFECT_MAX + 1;
    EXPECT_FALSE(manager->LoadReferMonsterFile(511, &table, &memory));
    EXPECT_EQ(manager->refer[0].id, -1);
}

TEST_F(NativeMonsterLoad, SwordEffectUsesItsFullHostAllocation) {
    BASE_MONSTER_TBL table{};
    std::strcpy(table.model, "p00_23a");
    std::strcpy(table.script, "native_fixture");
    table.sw_effect_num = 1;
    ASSERT_TRUE(manager->LoadReferMonsterFile(511, &table, &memory));
    auto *effect = manager->refer[0].chara.sword_effect[0];
    ASSERT_NE(effect, nullptr);
    const auto lease = dc2::memory::AllocationBytes(memory, effect);
    ASSERT_GE(lease.size(), sizeof(CSWordAfterEffect));
    ASSERT_NE(effect->point0, nullptr);
    EXPECT_GE(reinterpret_cast<std::uintptr_t>(effect->point0),
              reinterpret_cast<std::uintptr_t>(effect) + sizeof(CSWordAfterEffect));
}
