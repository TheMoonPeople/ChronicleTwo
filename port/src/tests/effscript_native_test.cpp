#include "common.h"

#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <array>
#include <chrono>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <vector>

#include "dataread_port.hpp"
#include "effscript.hpp"
#include "luau_runtime.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "native_document_fixture.hpp"
#include "platform/datapacks.hpp"
#include "platform/model_assets.hpp"
#include "texture_source.hpp"

namespace {
using Json = nlohmann::json;
std::vector<u_long128> texture_storage(16384);
mgCMemory              texture_memory;

/**
 * Supplies complete glTF effect bundles with directly named child characters and VM programs.
 */
class NativeEffectBase : public testing::Test {
protected:
    std::filesystem::path          root = std::filesystem::temp_directory_path() / ("native_effect_base_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
    std::filesystem::path          previous = datapacks::Root();
    std::vector<u_long128>         storage = std::vector<u_long128>(16384);
    mgCMemory                      memory;
    CEffectScriptMan               manager;
    std::string                    bundle;
    std::array<unsigned char, 132> script{};

    static void Write(const std::filesystem::path &path, const Json &document) {
        dc::test::WriteNativeDocument(path, document);
    }

    void Vm(const std::string &path) {
        const auto file = root / "data" / path;
        std::filesystem::create_directories(file.parent_path());
        std::ofstream output(file, std::ios::binary);
        output.write(reinterpret_cast<const char *>(script.data()), script.size());
    }

    void SetUp() override {
        // The fixture's programs run on the interpreter, so no Luau module may replace them.
        luau_runtime::SetScriptsRoot(root);
        std::memcpy(script.data(), "SB2", 4);
        const auto put = [&](int offset, int value) { std::memcpy(script.data() + offset, &value, sizeof(value)); };
        put(4, 64);
        put(8, 64);
        put(12, 28);
        put(64, 56);
        put(120, 27);
        const Json gltf = {
            {"asset",  {{"version", "2.0"}}             },
            {"scene",  0                                },
            {"scenes", Json::array({{{"nodes", {0}}}})  },
            {"nodes",  Json::array({{{"name", "root"}}})}
        };
        Write(root / "data/dungeon/articles/eff01.gltf", gltf);
        Write(root / "data/dungeon/articles/eff01.assets/Explosion_s.gltf", gltf);
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
            {"models",         Json::array({model})},
            {"resources",      Json::object()      }
        };
        child["profiles"]["info"]["commands"] = Json::array({
            {{"command", "MODEL"}, {"args", Json::array({{{"type", "resource"}, {"kind", "model"}, {"index", 0}}})}}
        });
        Write(root / "data/dungeon/articles/eff01.assets/Explosion_s.game.json", child);
        Json game = {
            {"schema_version", 1             },
            {"kind",           "character"   },
            {"models",         Json::array() },
            {"profiles",       Json::object()}
        };
        game["resources"]["texture_sets"] = Json::array({
            {{"document", {{"schema_version", 3}, {"groups", {0}}, {"entries", Json::array({{{"name", "n_heal"}, {"pictures", Json::array({{{"canvas", {{"width", 2}, {"height", 2}}}}})}}})}}}}
        });
        Write(root / "data/dungeon/articles/eff01.game.json", game);
        bundle = gltf.dump(2);
        Vm("dungeon/articles/eff01.assets/explosion.stb");
        Vm("dungeon/articles/eff01.assets/n_heal.stb");
        Vm("dungeon/articles/eff01.assets/n_heal_sub.stb");
        Vm("dungeon/articles/eff01.assets/bakudan.stb");
        Write(root / "data/textures/dungeon/eff_script/n_heal.json", game["resources"]["texture_sets"][0]["document"]);
        Vm("dungeon/eff_script/n_heal.stb");
        std::filesystem::create_directories(root / "data");
        DataReadIndex(root / "data");
        DataReadRegisterAsset(bundle.data(), "dungeon/articles/eff01.gltf", bundle.size());
        texture_memory.SetHeapMem(texture_storage.data(), static_cast<int>(texture_storage.size()));
        texture_memory.StartStackMode(MG_STACK_MODE_FIT, static_cast<int>(texture_storage.size()));
        mgTexManager.SetTableBuffer(64, 64, &texture_memory);
        mgTexManager.Initialize(0x1000, -1);
        memory.stSetBuffer(storage.data(), static_cast<int>(storage.size()));
        manager.Initialize(&memory, 20, 4);
        manager.level = 2;
    }

    void TearDown() override {
        luau_runtime::SetScriptsRoot({});
        for (auto *base : manager.base) {
            if (base && base->chara) {
                model_assets::DeleteCharacterTextures(*base->chara, 0, CHARA_IMAGE_MAX - 1);
            }
        }
        mgTexManager.Initialize(0x1000, -1);
        model_assets::Clear();
        TextureSourceForget(bundle.data());
        if (previous.empty()) {
            DataReadIndex(root / "empty/data");
            datapacks::Clear();
        } else {
            DataReadIndex(previous.parent_path() / "data");
        }
        std::error_code error;
        std::filesystem::remove_all(root, error);
    }

    u_int *Bundle() { return reinterpret_cast<u_int *>(bundle.data()); }
};
} // namespace

TEST_F(NativeEffectBase, CharacterBaseUsesDirectChildGltfAndPreservesScriptAndPoolOwnership) {
    ASSERT_EQ(manager.BuildPack(0, Bundle(), nullptr, -1), 1);
    ASSERT_NE(manager.base[0], nullptr);
    ASSERT_NE(manager.base[0]->chara, nullptr);
    EXPECT_NE(manager.base[0]->chara->GetFrame(), nullptr);
    EXPECT_EQ(manager.base[0]->base_no, 0);
    EXPECT_EQ(manager.base[0]->level, 2);
    EXPECT_EQ(manager.base[0]->texb, 20);
    EXPECT_EQ(manager.base[0]->texb_owned, 1);
    EXPECT_EQ(manager.texb_used, 1);
    EXPECT_EQ(std::memcmp(manager.base[0]->script, script.data(), script.size()), 0);
    EXPECT_EQ(manager.BuildPack(0, Bundle(), nullptr, -1), 0);
    EXPECT_EQ(manager.base_num, 1);
}

TEST_F(NativeEffectBase, EmbeddedNamedTexturesShareTheirBlockAcrossEffectPrograms) {
    ASSERT_EQ(manager.BuildPack(4, Bundle(), nullptr, -1), 1);
    char name[] = "n_heal";
    ASSERT_NE(mgTexManager.GetTexture(name, 20), nullptr);
    ASSERT_EQ(manager.BuildPack(5, Bundle(), nullptr, -1), 1);
    EXPECT_EQ(manager.base[0]->texb, 20);
    EXPECT_EQ(manager.base[0]->texb_owned, 1);
    EXPECT_EQ(manager.base[1]->texb, 20);
    EXPECT_EQ(manager.base[1]->texb_owned, 0);
    EXPECT_EQ(manager.texb_used, 1);
    EXPECT_EQ(manager.base_num, 2);
}

TEST_F(NativeEffectBase, StandaloneTextureAndVmLoadWithoutTheLegacyLoadBuffer) {
    ASSERT_EQ(manager.load_buffer, nullptr);
    ASSERT_EQ(manager.LoadBaseEffSpt(4, nullptr, -1), 1);
    ASSERT_NE(manager.base[0], nullptr);
    EXPECT_EQ(std::memcmp(manager.base[0]->script, script.data(), script.size()), 0);
    char name[] = "n_heal";
    EXPECT_NE(mgTexManager.GetTexture(name, 20), nullptr);
}

TEST_F(NativeEffectBase, ScriptOnlyEffectsKeepTheirUnmodeledSemanticsAndMissingScriptsFail) {
    ASSERT_EQ(manager.BuildPack(26, Bundle(), nullptr, -1), 1);
    ASSERT_NE(manager.base[0], nullptr);
    EXPECT_EQ(manager.base[0]->chara, nullptr);
    EXPECT_EQ(manager.texb_used, 0);
    EXPECT_EQ(manager.BuildPack(1, Bundle(), nullptr, -1), -1);
    EXPECT_EQ(manager.base_num, 1);
}

TEST_F(NativeEffectBase, DirectBufferBuildUsesItsActualGltfPathAndBoundedVmBytes) {
    DataReadRegisterAsset(bundle.data(), "dungeon/articles/eff01.assets/Explosion_s.gltf", bundle.size());
    ASSERT_EQ(manager.BuildBase(0, reinterpret_cast<u_long128 *>(bundle.data()), static_cast<int>(bundle.size()),
                                reinterpret_cast<u_long128 *>(script.data()), static_cast<int>(script.size()), nullptr, -1),
              1);
    ASSERT_NE(manager.base[0]->chara, nullptr);
    EXPECT_NE(manager.base[0]->chara->GetFrame(), nullptr);
    EXPECT_EQ(std::memcmp(manager.base[0]->script, script.data(), script.size()), 0);
}

TEST_F(NativeEffectBase, InvalidVmReplacementFallsThroughToTheBaseProgram) {
    std::filesystem::create_directories(root / "datapacks/override/dungeon/articles/eff01.assets");
    std::ofstream(root / "datapacks/override/dungeon/articles/eff01.assets/bakudan.stb", std::ios::binary) << "invalid VM";
    Write(root / "datapacks/datapacks.json", {
                                                 {"schema_version", 1           },
                                                 {"load_order",     {"override"}}
    });
    datapacks::Load(root / "data");
    ASSERT_EQ(manager.BuildPack(26, Bundle(), nullptr, -1), 1);
    EXPECT_EQ(std::memcmp(manager.base[0]->script, script.data(), script.size()), 0);
}

TEST_F(NativeEffectBase, AbsentEmbeddedTextureSetFailsWithoutCommittingABase) {
    Write(root / "data/dungeon/articles/eff01.game.json", {
                                                              {"schema_version", 1             },
                                                              {"kind",           "character"   },
                                                              {"models",         Json::array() },
                                                              {"profiles",       Json::object()},
                                                              {"resources",      Json::object()}
    });
    EXPECT_EQ(manager.BuildPack(4, Bundle(), nullptr, -1), -1);
    EXPECT_EQ(manager.base_num, 0);
    EXPECT_EQ(manager.texb_used, 0);
    EXPECT_EQ(manager.base[0], nullptr);
}
