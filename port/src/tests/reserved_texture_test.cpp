#include "common.h"

#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <chrono>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <string>
#include <vector>

#include "assets/data_registry.hpp"
#include "dataread.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mg_visual.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "native_script_program.hpp"
#include "platform/datapacks.hpp"
#include "platform/model_assets.hpp"
#include "runscript.hpp"
#include "runscript_opcodes.hpp"

int _LOAD_RESERV_IMG(dc2::script::RunArguments, int);
int _TRANS_RESERV_IMG(dc2::script::RunArguments, int);
int _SET_INDEXOBJ_SIZE(dc2::script::RunArguments, int);
int _GET_INDEXOBJ_SIZE(dc2::script::RunArguments, int);

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
        std::ofstream(root / "data/reserved.json") << document.dump(2);
    }

    /**
     * Supplies fixture characters with a model from their explicit allocation producer.
     */
    bool BindModel(CCharacter2 &character) {
        character.Initialize();
        auto *frame = dc2::memory::NewObject<mgCFrame>(memory);
        if (frame == nullptr) {
            return false;
        }
        character.CObjectFrame::frame = frame;
        return dc2::character::CaptureModelResources(character, memory);
    }

    void SetUp() override {
        std::filesystem::create_directories(root / "data");
        Write(4);
        DataReadIndex(root / "data");
        memory.SetHeapMem(storage.data(), static_cast<int>(storage.size()));
        memory.StartStackMode(MG_STACK_MODE_FIT, static_cast<int>(storage.size()));
        mgTexManager.SetTableBuffer(64, 64, &memory);
        mgTexManager.Initialize(0x1000, -1);
        ASSERT_TRUE(BindModel(monster));
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
    ASSERT_EQ(InvokeNativeExternal(_LOAD_RESERV_IMG, std::span(arguments).first(2), {}, path), 1);
    ASSERT_NE(monster.reserv_img[1], nullptr);
    EXPECT_EQ(monster.reserv_img_size[1], 0);
    EXPECT_EQ(monster.images[0], nullptr);
    Write(8);
    texture_catalog::Clear();
    std::string error;
    ASSERT_TRUE(texture_catalog::Load(root / "data", error)) << error;
    ASSERT_EQ(InvokeNativeExternal(_TRANS_RESERV_IMG, std::span(arguments).first(1)), 1);
    char  name[] = "reserved";
    auto *texture = mgTexManager.GetTexture(name, 20);
    ASSERT_NE(texture, nullptr);
    EXPECT_EQ(texture->width, 4);
    EXPECT_EQ(monster.images[0], nullptr);
    monster.DeleteImage();
    EXPECT_EQ(mgTexManager.GetTexture(name, 20), nullptr);
    ASSERT_EQ(InvokeNativeExternal(_TRANS_RESERV_IMG, std::span(arguments).first(1)), 1);
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
    EXPECT_EQ(InvokeNativeExternal(_TRANS_RESERV_IMG, std::span(&argument, 1).first(1)), 0);
    EXPECT_EQ(InvokeNativeExternal(_TRANS_RESERV_IMG, std::span(&argument, 1).first(0)), 0);
    EXPECT_EQ(InvokeNativeExternal(_LOAD_RESERV_IMG, std::span(&argument, 1).first(1)), 0);
    EXPECT_TRUE(model_assets::ApplyReservedMonsterTexture(monster, 0, error)) << error;
}

TEST_F(NativeReservedTexture, CopiedCharactersRetainSuffixedMaterialBindingsAndOtherImageSlots) {
    CCharacter2 base;
    ASSERT_TRUE(BindModel(base));
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
    auto *material = dc2::memory::NewObject<mgMaterial>(memory);
    auto *visual = dc2::memory::NewObject<mgCVisualMDT>(memory);
    ASSERT_NE(material, nullptr);
    ASSERT_NE(visual, nullptr);
    material->texture = original;
    visual->material = material;
    visual->material_num = 1;
    monster.CObjectFrame::frame->visual = visual;
    ASSERT_TRUE(model_assets::ReplaceCharacterTextureDocument(monster, "reserved.json", error)) << error;
    EXPECT_STREQ(mgTexManager.name_suffix, "");
    EXPECT_EQ(material->texture, mgTexManager.GetTexture(name, 20));
    ASSERT_NE(material->texture, nullptr);
    EXPECT_STREQ(material->texture->name, "reserved_m");
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

TEST_F(NativeReservedTexture, MonsterEntryObjectSizeUsesValidatedTypedSlots) {
    RS_STACKDATA value{};
    value.type = RS_FLOAT;
    value.val.f = 12.5f;
    RS_STACKDATA arguments[2]{};
    arguments[0].type = RS_INT;
    arguments[1] = value;

    for (int index : {-2, CHARA_ENTRY_OBJECT_MAX}) {
        arguments[0].val.i = index;
        EXPECT_EQ(InvokeNativeExternal(_SET_INDEXOBJ_SIZE, std::span(arguments).first(2)), 0);
        EXPECT_EQ(InvokeNativeExternal(_GET_INDEXOBJ_SIZE, std::span(arguments).first(2)), 0);
    }

    arguments[0].val.i = CHARA_ENTRY_OBJECT_MAX - 1;
    EXPECT_EQ(InvokeNativeExternal(_SET_INDEXOBJ_SIZE, std::span(arguments).first(2)), 1);
    EXPECT_FLOAT_EQ(monster.entry_object[CHARA_ENTRY_OBJECT_MAX - 1].size, 12.5f);

    RS_STACKDATA output{};
    output.type = RS_FLOAT;
    arguments[1].type = RS_PTR;
    arguments[1].val.p = &output;
    EXPECT_EQ(InvokeNativeExternal(_GET_INDEXOBJ_SIZE, std::span(arguments).first(2), std::span(&output, 1)), 1);
    EXPECT_FLOAT_EQ(output.val.f, 12.5f);

    arguments[0].val.i = -1;
    EXPECT_EQ(InvokeNativeExternal(_SET_INDEXOBJ_SIZE, std::span(arguments).first(2)), 0);
    arguments[1] = value;
    EXPECT_EQ(InvokeNativeExternal(_SET_INDEXOBJ_SIZE, std::span(arguments).first(2)), 1);
    EXPECT_FLOAT_EQ(monster.entry_object[0].size, 12.5f);
}
