#include "common.h"

#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <algorithm>
#include <array>
#include <chrono>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <string>
#include <string_view>
#include <vector>

#include "assets/data_registry.hpp"
#include "effscript.hpp"
#include "luau_runtime.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "native_document_fixture.hpp"
#include "platform/datapacks.hpp"
#include "platform/model_assets.hpp"
#include "texture_source.hpp"

TEST(NativeEffectPath, RejectsInsufficientOutputAndUnterminatedDefinitionNames) {
    CEffectScriptMan      manager;
    std::array<char, 128> resource{};
    std::array<char, 128> script{};
    ASSERT_TRUE(manager.GetNeedFilePath(0, resource, script));
    EXPECT_STREQ(resource.data(), "dungeon/eff_script/Explosion_s.gltf");
    EXPECT_STREQ(script.data(), "dungeon/eff_script/explosion.stb");

    std::array<char, 8> short_resource{};
    short_resource.fill('x');
    script.fill('y');
    EXPECT_FALSE(manager.GetNeedFilePath(0, short_resource, script));
    EXPECT_EQ(short_resource.front(), 'x');
    EXPECT_EQ(script.front(), 'y');

    const EFF_SPT_BASE_DEF original = eff_spt_base_def[0];
    std::fill_n(eff_spt_base_def[0].file, sizeof eff_spt_base_def[0].file - 1, 'z');
    eff_spt_base_def[0].file[sizeof eff_spt_base_def[0].file - 1] = '\0';
    std::array<char, 48> limited_resource{};
    limited_resource.fill('q');
    EXPECT_FALSE(manager.GetNeedFilePath(0, limited_resource, script));
    EXPECT_EQ(limited_resource.front(), 'q');

    std::fill_n(eff_spt_base_def[0].file, sizeof eff_spt_base_def[0].file, 'z');
    resource.fill('x');
    EXPECT_FALSE(manager.GetNeedFilePath(0, resource, script));
    EXPECT_EQ(resource.front(), 'x');
    eff_spt_base_def[0] = original;
}

namespace {
using Json = nlohmann::json;
std::vector<u_long128> texture_storage(16384);
mgCMemory              texture_memory;

/**
 * Supplies complete glTF effect bundles with directly named child characters and script modules.
 */
class NativeEffectBase : public testing::Test {
protected:
    std::filesystem::path  root = std::filesystem::temp_directory_path() / ("native_effect_base_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
    std::filesystem::path  previous = datapacks::Root();
    std::vector<u_long128> storage = std::vector<u_long128>(16384);
    mgCMemory              memory;
    CEffectScriptMan       manager;
    std::string            bundle;

    static void Write(const std::filesystem::path &path, const Json &document) {
        dc::test::WriteNativeDocument(path, document);
    }

    /**
     * Writes the Luau module that the effect script at a data path loads as.
     */
    void Module(const std::string &path) {
        const auto file = (root / "scripts" / path).replace_extension(".luau");
        std::filesystem::create_directories(file.parent_path());
        std::ofstream(file) << "return {}\n";
    }

    /**
     * Reports whether a base's program is the handle of the module for a data path.
     */
    static bool LoadsModule(const EFF_SPT_BASE &base, std::string_view path) {
        return luau_runtime::HandleModule({base.script, base.script_size}) ==
               std::string(path.substr(0, path.size() - std::string_view(".stb").size()));
    }

    void SetUp() override {
        luau_runtime::SetScriptsRoot(root / "scripts");
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
        Module("dungeon/articles/eff01.assets/explosion.stb");
        Module("dungeon/articles/eff01.assets/n_heal.stb");
        Module("dungeon/articles/eff01.assets/n_heal_sub.stb");
        Module("dungeon/articles/eff01.assets/bakudan.stb");
        Write(root / "data/textures/dungeon/eff_script/n_heal.json", game["resources"]["texture_sets"][0]["document"]);
        Module("dungeon/eff_script/n_heal.stb");
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
    EXPECT_TRUE(LoadsModule(*manager.base[0], "dungeon/articles/eff01.assets/explosion.stb"));
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
    EXPECT_TRUE(LoadsModule(*manager.base[0], "dungeon/eff_script/n_heal.stb"));
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
    std::string handle = luau_runtime::MakeHandle("dungeon/articles/eff01.assets/explosion");
    ASSERT_EQ(manager.BuildBase(0, reinterpret_cast<u_long128 *>(bundle.data()), static_cast<int>(bundle.size()),
                                reinterpret_cast<u_long128 *>(handle.data()), static_cast<int>(handle.size()), nullptr, -1),
              1);
    ASSERT_NE(manager.base[0]->chara, nullptr);
    EXPECT_NE(manager.base[0]->chara->GetFrame(), nullptr);
    EXPECT_TRUE(LoadsModule(*manager.base[0], "dungeon/articles/eff01.assets/explosion.stb"));
}

TEST_F(NativeEffectBase, DatapackScriptDoesNotReplaceTheModule) {
    std::filesystem::create_directories(root / "datapacks/override/dungeon/articles/eff01.assets");
    std::ofstream(root / "datapacks/override/dungeon/articles/eff01.assets/bakudan.stb", std::ios::binary) << "invalid VM";
    Write(root / "datapacks/datapacks.json", {
                                                 {"schema_version", 1           },
                                                 {"load_order",     {"override"}}
    });
    datapacks::Load(root / "data");
    ASSERT_EQ(manager.BuildPack(26, Bundle(), nullptr, -1), 1);
    EXPECT_TRUE(LoadsModule(*manager.base[0], "dungeon/articles/eff01.assets/bakudan.stb"));
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
