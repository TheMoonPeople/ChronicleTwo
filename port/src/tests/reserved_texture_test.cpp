#include "common.h"

#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <chrono>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <string>
#include <vector>

#include "dataread.hpp"
#include "dataread_port.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mg_visual.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "platform/datapacks.hpp"
#include "platform/model_assets.hpp"
#include "runscript.hpp"
#include "runscript_opcodes.hpp"

int _LOAD_RESERV_IMG(RS_STACKDATA *, int);
int _TRANS_RESERV_IMG(RS_STACKDATA *, int);

namespace {
/**
 * Exercises reserved native texture resources without proprietary image buffers.
 */
class NativeReservedTexture : public testing::Test {
protected:
    std::filesystem::path  root = std::filesystem::temp_directory_path() / ("native_reserved_texture_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
    std::filesystem::path  previous = datapacks::Root();
    std::vector<u_long128> storage = std::vector<u_long128>(16384);
    mgCMemory              memory;
    CActiveMonster         monster;
    CActiveMonster        *previous_monster = nullptr;

    void Write(int size) {
        const nlohmann::json document = {
            {"schema_version", 3                                                                                                                                        },
            {"groups",         {0}                                                                                                                                      },
            {"entries",        nlohmann::json::array({{{"name", "reserved"}, {"pictures", nlohmann::json::array({{{"canvas", {{"width", size}, {"height", size}}}}})}}})}
        };
        std::ofstream(root / "port_data/reserved.json") << document.dump(2);
    }

    void SetUp() override {
        std::filesystem::create_directories(root / "port_data");
        std::filesystem::create_directories(root / "data");
        Write(4);
        DataReadIndex(root / "data");
        memory.SetHeapMem(storage.data(), static_cast<int>(storage.size()));
        memory.StartStackMode(MG_STACK_MODE_FIT, static_cast<int>(storage.size()));
        mgTexManager.SetTableBuffer(64, 64, &memory);
        mgTexManager.Initialize(0x1000, -1);
        monster.Initialize();
        monster.texture_block = 20;
        previous_monster = nowMonster;
        nowMonster = &monster;
    }

    void TearDown() override {
        monster.DeleteImage();
        nowMonster = previous_monster;
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

TEST_F(NativeReservedTexture, OpcodesRetainParsedResourcesAfterDocumentChanges) {
    RS_STACKDATA arguments[2]{};
    arguments[0].type = RS_INT;
    arguments[0].val.i = 1;
    char path[] = "/reserved.json";
    arguments[1].type = RS_STR;
    arguments[1].val.s = path;
    ASSERT_EQ(_LOAD_RESERV_IMG(arguments, 2), 1);
    ASSERT_NE(monster.reserv_img[1], nullptr);
    EXPECT_EQ(monster.reserv_img_size[1], 0);
    EXPECT_EQ(monster.images[0], nullptr);
    Write(8);
    texture_catalog::Clear();
    std::string error;
    ASSERT_TRUE(texture_catalog::Load(root / "port_data", error)) << error;
    ASSERT_EQ(_TRANS_RESERV_IMG(arguments, 1), 1);
    char  name[] = "reserved";
    auto *texture = mgTexManager.GetTexture(name, 20);
    ASSERT_NE(texture, nullptr);
    EXPECT_EQ(texture->width, 4);
    EXPECT_EQ(monster.images[0], nullptr);
    monster.DeleteImage();
    EXPECT_EQ(mgTexManager.GetTexture(name, 20), nullptr);
    ASSERT_EQ(_TRANS_RESERV_IMG(arguments, 1), 1);
    ASSERT_NE(mgTexManager.GetTexture(name, 20), nullptr);
    EXPECT_EQ(mgTexManager.GetTexture(name, 20)->width, 4);
}

TEST_F(NativeReservedTexture, InitializeAndDatasetClearInvalidateReservedResources) {
    std::string error;
    ASSERT_TRUE(model_assets::ReserveMonsterTextureDocument(monster, 0, "reserved.json", error)) << error;
    monster.Initialize();
    EXPECT_EQ(monster.reserv_img[0], nullptr);
    EXPECT_FALSE(model_assets::ApplyReservedMonsterTexture(monster, 0, error));
    monster.texture_block = 20;
    ASSERT_TRUE(model_assets::ReserveMonsterTextureDocument(monster, 0, "reserved.json", error)) << error;
    model_assets::Clear();
    EXPECT_FALSE(model_assets::ApplyReservedMonsterTexture(monster, 0, error));
}

TEST_F(NativeReservedTexture, InvalidOperandsAndDocumentsPreserveTheReservedSlot) {
    std::string error;
    ASSERT_TRUE(model_assets::ReserveMonsterTextureDocument(monster, 0, "reserved.json", error)) << error;
    auto *original = monster.reserv_img[0];
    EXPECT_FALSE(model_assets::ReserveMonsterTextureDocument(monster, 0, "missing.json", error));
    EXPECT_EQ(monster.reserv_img[0], original);
    RS_STACKDATA argument{};
    argument.type = RS_INT;
    argument.val.i = 2;
    EXPECT_EQ(_TRANS_RESERV_IMG(&argument, 1), 0);
    EXPECT_EQ(_TRANS_RESERV_IMG(&argument, 0), 0);
    EXPECT_EQ(_LOAD_RESERV_IMG(&argument, 1), 0);
    EXPECT_TRUE(model_assets::ApplyReservedMonsterTexture(monster, 0, error)) << error;
}

TEST_F(NativeReservedTexture, CopiedCharactersRetainSuffixedMaterialBindingsAndOtherImageSlots) {
    CCharacter2 base;
    base.Initialize();
    base.texture_block = 20;
    std::strcpy(mgTexManager.name_suffix, "_m");
    std::string error;
    ASSERT_TRUE(model_assets::ReplaceCharacterTextureDocument(base, "reserved.json", error)) << error;
    ASSERT_TRUE(model_assets::ReplaceCharacterTextureDocument(base, "reserved.json", 1, 21, &memory, error)) << error;
    EXPECT_EQ(base.texture_block, 20);
    mgTexManager.name_suffix[0] = 0;
    char  name[] = "reserved_m";
    auto *original = mgTexManager.GetTexture(name, 20);
    auto *extension = mgTexManager.GetTexture(name, 21);
    ASSERT_NE(original, nullptr);
    ASSERT_NE(extension, nullptr);
    mgMaterial material{};
    material.texture = original;
    mgCVisualMDT visual;
    visual.material = &material;
    visual.material_num = 1;
    mgCFrame frame;
    frame.visual = &visual;
    monster.CObjectFrame::frame = &frame;
    ASSERT_TRUE(model_assets::ReplaceCharacterTextureDocument(monster, "reserved.json", error)) << error;
    EXPECT_STREQ(mgTexManager.name_suffix, "");
    EXPECT_EQ(material.texture, mgTexManager.GetTexture(name, 20));
    ASSERT_NE(material.texture, nullptr);
    EXPECT_STREQ(material.texture->name, "reserved_m");
    EXPECT_EQ(mgTexManager.GetTexture(name, 21), extension);
    monster.DeleteImage();
    EXPECT_EQ(mgTexManager.GetTexture(name, 20), nullptr);
    EXPECT_EQ(mgTexManager.GetTexture(name, 21), extension);
    base.DeleteImage();
    EXPECT_EQ(mgTexManager.GetTexture(name, 21), extension);
    base.DeleteExtMotion();
    EXPECT_EQ(mgTexManager.GetTexture(name, 21), nullptr);
    monster.CObjectFrame::frame = nullptr;
}
