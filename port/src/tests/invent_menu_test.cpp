#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <chrono>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <memory>
#include <string>
#include <vector>

#include "actionchara.hpp"
#include "dataread.hpp"
#include "dataread_port.hpp"
#include "inventmn.hpp"
#include "menuchr.hpp"
#include "menucls1.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "platform/datapacks.hpp"
#include "stubs/inventmn.hpp"
#include "texture_source.hpp"

namespace {
/**
 * Supplies actual native menu documents and a versioned directory marker.
 */
struct MenuDirectory {
    std::filesystem::path root;        /**< Temporary native data directory. */
    std::filesystem::path previous;    /**< Datapack root restored after the fixture. */
    std::string           metadata;    /**< Actual pack.json bytes supplied to the game. */
    std::size_t           script_size; /**< Actual native inventory script byte count. */

    MenuDirectory() {
        using Json = nlohmann::json;
        previous = datapacks::Root();
        root = std::filesystem::temp_directory_path() / ("chronicle_menu_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
        const auto directory = root / "port_data/menu/fixture.pak";
        std::filesystem::create_directories(directory);
        auto       integer = [](int value) { return Json{
                                                 {"type",  "int"},
                                                 {"value", value}
 }; };
        auto       text = [](const char *value) { return Json{
                                                      {"type",  "string"},
                                                      {"value", value   }
 }; };
        const Json forms = {
            {"schema_version", 1                                                                                                                                                                                                                                              },
            {"commands",       Json::array({{{"command", "FORM_MALLOC"}, {"args", {integer(1)}}}, {{"command", "FORM_OFFSET_NO"}, {"args", {integer(0)}}}, {{"command", "FORM_SET"}, {"args", {text("poly_chr0")}}}, {{"command", "INIT_DRAWLIST"}, {"args", Json::array()}}})}
        };
        const Json script = {
            {"schema_version", 1                                                                },
            {"commands",       Json::array({{{"command", "INIT_END"}, {"args", Json::array()}}})}
        };
        metadata = Json({
                            {"schema_version", 1                },
                            {"kind",           "asset_directory"}
        })
                       .dump(2);
        std::ofstream(directory / "pack.json") << metadata;
        std::ofstream(directory / "inv_bg.json") << Json({
                                                             {"schema_version", 3            },
                                                             {"groups",         {0}          },
                                                             {"entries",        Json::array()}
        })
                                                        .dump(2);
        std::ofstream(directory / "invent.cfg.json") << forms.dump(2);
        std::ofstream(directory / "inv_com.cfg.json") << script.dump(2);
        std::ofstream(directory / "inv6.lst") << "DATATABLESET 1; DATASET 42,1,2,3,210,5,0,1.0,2.0,3.0,4.0;";
        script_size = std::filesystem::file_size(directory / "inv_com.cfg.json");
        datapacks::Load(root / "port_data");
        DataReadRegisterAsset(metadata.data(), "menu/fixture.pak/pack.json", metadata.size());
    }

    ~MenuDirectory() {
        TextureSourceForget(metadata.data());
        DataReadRegisterBuffer(metadata.data(), 0);
        if (previous.empty()) {
            datapacks::Clear();
        } else {
            datapacks::Load(previous);
        }
        std::filesystem::remove_all(root);
    }
};

TEST(InventMenu, PendingPhotoPageDoesNotFinishCharacterLoadingBeforeItsFormsExist) {
    auto         menu = std::make_unique<CMenuInvent>();
    CActionChara character;
    character.Initialize(nullptr);
    MenuActionChara[0] = &character;
    MenuActionChara[3] = nullptr;
    menu->photo_only = 1;
    menu->opened = false;
    menu->chara_load_step = INVENT_CHARA_LOAD_WAIT;
    menu->poly_chr_form[0] = nullptr;
    menu->script = nullptr;
    menu->script_size = 0;
    menu->tex_block[1] = -1;
    StartReadBG();

    menu->LoadCharaCheck();

    EXPECT_EQ(menu->chara_load_step, INVENT_CHARA_LOAD_WAIT);
    EXPECT_EQ(menu->poly_chr_form[0], nullptr);
    MenuActionChara[0] = nullptr;
}
} // namespace

TEST(InventMenu, LoadsNativeFolderFormsAndRecipesBeforeAttachingThePhotoCharacter) {
    std::vector<u_long128> storage(4096), texture_storage(4096);
    mgCMemory              textures;
    textures.stSetBuffer(texture_storage.data(), texture_storage.size());
    mgTexManager.SetTableBuffer(64, 8, &textures);
    mgTexManager.Initialize(0x1000, -1);
    CMenuPosDataManage positions{};
    positions.Initialize();
    CMenuMoveItem     move;
    CInventDataManage recipes;
    auto              photos = std::make_unique<CInventUserData>();
    photos->ResetAddress();
    auto menu = std::make_unique<CMenuInvent>();
    menu->data_stack.stSetBuffer(storage.data(), storage.size());
    menu->tex_block[3] = 1;
    MenuPosData = &positions;
    MenuMoveItemPtr = &move;
    InventManagePt = &recipes;
    InventUserDataPtr = photos.get();
    MenuDirectory directory;
    menu->EnterDataMenu(reinterpret_cast<u8 *>(directory.metadata.data()));

    EXPECT_NE(menu->poly_chr_form[0], nullptr);
    EXPECT_EQ(positions.form_num, 1);
    ASSERT_EQ(recipes.num, 1);
    EXPECT_EQ(recipes.table[0].item_id, 42);
    EXPECT_EQ(recipes.table[0].materials.material[0].num, 5);
    EXPECT_EQ(menu->script_size, static_cast<int>(directory.script_size));
    mgTexManager.Initialize(0x1000, -1);
}
