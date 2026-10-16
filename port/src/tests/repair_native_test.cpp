#include "common.h"

#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <chrono>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <vector>

#include "actionchara.hpp"
#include "dataread_port.hpp"
#include "menudraw.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "platform/datapacks.hpp"
#include "platform/model_assets.hpp"
#include "texture_source.hpp"

namespace {
using Json = nlohmann::json;
std::vector<u_long128> texture_storage(16384);
mgCMemory              texture_memory;

/**
 * Supplies repair resources as a complete glTF bundle and an ordinary menu asset directory.
 */
class NativeRepair : public testing::Test {
protected:
    std::filesystem::path  root = std::filesystem::temp_directory_path() / ("native_repair_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
    std::filesystem::path  previous = datapacks::Root();
    std::vector<u_long128> storage = std::vector<u_long128>(32768);
    std::vector<u_long128> model_storage = std::vector<u_long128>(16384);
    mgCMemory              memory;
    CRepairManager         manager{};
    std::string            bundle;
    std::string            folder;

    static void Write(const std::filesystem::path &path, const Json &document) {
        std::filesystem::create_directories(path.parent_path());
        std::ofstream(path, std::ios::binary) << document.dump(2);
    }

    static Json Texture(const char *name) {
        return {
            {"schema_version", 3                                                                                                        },
            {"groups",         {0}                                                                                                      },
            {"entries",        Json::array({{{"name", name}, {"pictures", Json::array({{{"canvas", {{"width", 2}, {"height", 2}}}}})}}})}
        };
    }

    void SetUp() override {
        const Json gltf = {
            {"asset",  {{"version", "2.0"}}             },
            {"scene",  0                                },
            {"scenes", Json::array({{{"nodes", {0}}}})  },
            {"nodes",  Json::array({{{"name", "root"}}})}
        };
        bundle = gltf.dump(2);
        folder = Json({
                          {"schema_version", 1                },
                          {"kind",           "asset_directory"}
        })
                     .dump(2);
        Write(root / "port_data/menu/eff/repair.gltf", gltf);
        Write(root / "port_data/menu/eff/repair.assets/repair_powder.gltf", gltf);
        const Json model = {
            {"schema_version",  1                                                                             },
            {"frames",          Json::array({{{"id", 0}, {"name", "root"}, {"parent", -1}, {"mdt", nullptr}}})},
            {"meshes",          Json::array()                                                                 },
            {"motion_channels", Json::array()                                                                 },
            {"weights",         Json::array()                                                                 },
            {"bind_poses",      Json::array()                                                                 }
        };
        Json child = {
            {"schema_version", 1                   },
            {"kind",           "character"         },
            {"models",         Json::array({model})}
        };
        child["resources"]["texture_sets"] = Json::array({{{"document", Texture("repair_model")}}});
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
        child["profiles"]["info"]["commands"] = Json::array({
            {{"command", "IMG"},     {"args", Json::array({{{"type", "int"}, {"value", 0}}, image})}},
            {{"command", "IMG_END"}, {"args", Json::array()}                                        },
            {{"command", "MODEL"},   {"args", Json::array({geometry})}                              }
        });
        Write(root / "port_data/menu/eff/repair.assets/repair_powder.game.json", child);
        Json game = {
            {"schema_version", 1             },
            {"kind",           "character"   },
            {"models",         Json::array() },
            {"profiles",       Json::object()}
        };
        game["resources"]["texture_sets"] = Json::array({{{"document", Texture("menueff0")}}});
        Write(root / "port_data/menu/eff/repair.game.json", game);
        Write(root / "port_data/menu/1/chrchg0.pac/pack.json", Json::parse(folder));
        Write(root / "port_data/menu/1/chrchg0.pac/repair_powder2d.json", Texture("menueff0"));
        std::filesystem::create_directories(root / "data");
        DataReadIndex(root / "data");
        DataReadRegisterAsset(bundle.data(), "menu/eff/repair.gltf", bundle.size());
        DataReadRegisterAsset(folder.data(), "menu/1/chrchg0.pac/pack.json", folder.size());
        texture_memory.SetHeapMem(texture_storage.data(), static_cast<int>(texture_storage.size()));
        texture_memory.StartStackMode(MG_STACK_MODE_FIT, static_cast<int>(texture_storage.size()));
        mgTexManager.SetTableBuffer(64, 64, &texture_memory);
        mgTexManager.Initialize(0x1000, -1);
        memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
        manager.Initialize();
        manager.data = reinterpret_cast<u_int *>(bundle.data());
        manager.model_stack.stSetBuffer(model_storage.data(), static_cast<int>(model_storage.size()));
    }

    void TearDown() override {
        if (manager.model) {
            model_assets::DeleteCharacterTextures(*manager.model, 0, CHARA_IMAGE_MAX - 1);
        }
        mgTexManager.Initialize(0x1000, -1);
        model_assets::Clear();
        if (previous.empty()) {
            DataReadIndex(root / "empty/data");
            datapacks::Clear();
        } else {
            DataReadIndex(previous.parent_path() / "data");
        }
        std::error_code error;
        std::filesystem::remove_all(root, error);
    }
};
} // namespace

TEST_F(NativeRepair, BackgroundBundleRegistersItsEmbeddedSpriteWithTheRetailSuffix) {
    manager.bg_load = true;
    manager.CheckDataBG(20);
    EXPECT_TRUE(manager.data_ready);
    EXPECT_FALSE(manager.bg_load);
    EXPECT_EQ(manager.tex_block, 20);
    ASSERT_NE(manager.tex, nullptr);
    char name[] = "menueff0_2";
    EXPECT_EQ(manager.tex, mgTexManager.GetTexture(name, 20));
    EXPECT_STREQ(mgTexManager.name_suffix, "");
}

TEST_F(NativeRepair, OrdinaryMenuDirectoryKeepsItsDirectTextureDocumentAndEffectStacks) {
    manager.SetRepairData(&memory, 20, reinterpret_cast<u_int *>(folder.data()));
    EXPECT_TRUE(manager.data_ready);
    EXPECT_TRUE(manager.keep);
    EXPECT_FALSE(manager.bg_load);
    EXPECT_NE(manager.tex, nullptr);
    EXPECT_NE(manager.effect_stack[0].stack, nullptr);
    EXPECT_EQ(manager.effect_stack[0].stack_size, 0x500);
    EXPECT_EQ(manager.model, nullptr);
}

TEST_F(NativeRepair, ReusedModelArenaReloadsOwnedTexturesAfterThePreviousEffectEnded) {
    float position[4] = {3, 4, 5, 1};
    manager.GeneratePoly(position, 21);
    ASSERT_NE(manager.model, nullptr);
    EXPECT_EQ(manager.model_counter, 0);
    ASSERT_NE(manager.model->GetFrame(), nullptr);
    ASSERT_NE(manager.model->GetFrame()->attr, nullptr);
    EXPECT_EQ(manager.model->GetFrame()->attr->z_test, MG_DEPTH_TEST_ALWAYS);
    char name[] = "repair_model";
    ASSERT_NE(mgTexManager.GetTexture(name, 21), nullptr);
    const auto *previous_model = manager.model;
    mgTexManager.DeleteBlock(21);
    manager.model = nullptr;
    manager.GeneratePoly(position, 21);
    ASSERT_NE(manager.model, nullptr);
    EXPECT_EQ(manager.model, previous_model);
    EXPECT_NE(mgTexManager.GetTexture(name, 21), nullptr);
}

TEST_F(NativeRepair, MissingNativeResourcesLeaveNoReadyTextureOrPartialModel) {
    DataReadRegisterAsset(bundle.data(), "menu/eff/missing.gltf", bundle.size());
    manager.bg_load = true;
    manager.CheckDataBG(20);
    EXPECT_FALSE(manager.data_ready);
    EXPECT_FALSE(manager.bg_load);
    EXPECT_EQ(manager.tex, nullptr);
    EXPECT_STREQ(mgTexManager.name_suffix, "");
    float position[4] = {3, 4, 5, 1};
    manager.GeneratePoly(position, 21);
    EXPECT_EQ(manager.model, nullptr);
    EXPECT_EQ(manager.model_stack.stack_used, 0);
}
