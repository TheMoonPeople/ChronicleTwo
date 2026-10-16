#include "common.h"

#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <array>
#include <chrono>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <memory>
#include <vector>

#include "dataread_port.hpp"
#include "dng_main.hpp"
#include "mg_memory.hpp"
#include "monster.hpp"
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
    alignas(16) std::array<u_long128, 128> scratch {};
    std::vector<u_long128>       storage = std::vector<u_long128>(16384);
    mgCMemory                    memory;
    std::unique_ptr<CMonsterMan> manager = std::make_unique<CMonsterMan>();

    void SetUp() override {
        using Json = nlohmann::json;
        std::filesystem::create_directories(root / "port_data/dungeon/monster");
        std::filesystem::create_directories(root / "data");
        const Json gltf = {
            {"asset",  {{"version", "2.0"}}             },
            {"scene",  0                                },
            {"scenes", Json::array({{{"nodes", {0}}}})  },
            {"nodes",  Json::array({{{"name", "root"}}})}
        };
        std::ofstream model(root / "port_data/dungeon/monster/p00_23a.gltf", std::ios::binary);
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
        std::ofstream(root / "port_data/dungeon/monster/p00_23a.game.json") << game.dump(2);
        std::array<unsigned char, 132> script{};
        std::memcpy(script.data(), "SB2", 4);
        const auto put = [&](int offset, int value) { std::memcpy(script.data() + offset, &value, sizeof(value)); };
        put(4, 64);
        put(8, 64);
        put(12, 28);
        put(64, 56);
        put(120, 27);
        std::filesystem::create_directories(root / "data/dungeon/monster");
        std::ofstream output(root / "data/dungeon/monster/native_fixture.stb", std::ios::binary);
        output.write(reinterpret_cast<const char *>(script.data()), script.size());
        output.close();
        DataReadIndex(root / "data");
        std::memset(scratch.data(), 0xA5, sizeof(scratch));
        BuffReadData = scratch.data();
        memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
        for (auto &refer : manager->refer) {
            refer.id = -1;
        }
    }

    void TearDown() override {
        BuffReadData = previous_buffer;
        model_assets::Clear();
        DataReadIndex(previous);
        std::error_code error;
        std::filesystem::remove_all(root, error);
    }
};
} // namespace

TEST_F(NativeMonsterLoad, LoadsOversizedGltfWithoutWritingOriginalReadScratch) {
    ASSERT_GT(std::filesystem::file_size(root / "port_data/dungeon/monster/p00_23a.gltf"), 4160000u);
    const auto       before = scratch;
    BASE_MONSTER_TBL table{};
    std::strcpy(table.model, "p00_23a");
    std::strcpy(table.script, "native_fixture");
    ASSERT_TRUE(manager->LoadReferMonsterFile(511, &table, &memory));
    EXPECT_EQ(std::memcmp(scratch.data(), before.data(), sizeof(scratch)), 0);
    EXPECT_EQ(manager->refer[0].id, 511);
    EXPECT_EQ(manager->refer[0].chara.tbl, &table);
    ASSERT_NE(manager->refer[0].chara.GetFrame(), nullptr);
    ASSERT_NE(manager->refer[0].script, nullptr);
    EXPECT_EQ(std::memcmp(manager->refer[0].script, "SB2", 4), 0);
}
