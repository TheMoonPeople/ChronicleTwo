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
#include "assets/data_registry.hpp"
#include "dataread.hpp"
#include "inventmn.hpp"
#include "menuchr.hpp"
#include "menucls1.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "platform/datapacks.hpp"
#include "platform/paths.hpp"
#include "scoped_global_object.hpp"
#include "stubs/inventmn.hpp"
#include "texture_source.hpp"

namespace {
/**
 * Supplies actual native menu documents and a versioned directory marker.
 */
struct MenuDirectory {
    std::filesystem::path root;               /**< Temporary native data directory. */
    std::filesystem::path previous;           /**< Datapack root restored after the fixture. */
    std::string           previous_directory; /**< Asset directory restored after the fixture. */
    std::string           metadata;           /**< Actual pack.json bytes supplied to the game. */
    std::size_t           script_size;        /**< Actual native inventory script byte count. */

    MenuDirectory() : previous(datapacks::Root()), previous_directory(GetCurrentDir()) {
        using Json = nlohmann::json;
        if (previous.empty()) {
            previous = PathsDataRoot();
        }

        root = std::filesystem::temp_directory_path() / ("chronicle_menu_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
        const auto directory = root / "data/menu/fixture.pak";
        std::filesystem::create_directories(directory);
        const Json forms = {
            {"schema_version", 2                                                                                                                                                                                                                        },
            {"kind",           "menu_layout"                                                                                                                                                                                                            },
            {"operations",     Json::array({{{"op", "allocate_forms"}, {"count", 1}}, {{"op", "form_offset"}, {"index", 0}}, {{"op", "form"}, {"name", "poly_chr0"}, {"settings", Json::array()}, {"parts", Json::array()}}, {{"op", "init_drawlist"}}})}
        };
        const Json script = {
            {"schema_version", 2              },
            {"kind",           "menu_commands"},
            {"blocks",         Json::array()  }
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
        for (const auto *name : {"dc2album.gltf", "dc2album_c.gltf", "dc2album_d.gltf"}) {
            std::ofstream(directory / name, std::ios::binary) << "icon";
        }
        script_size = std::filesystem::file_size(directory / "inv_com.cfg.json");
        DataReadIndex(root / "data");
        SetCurrentDir(nullptr);
        DataReadRegisterAsset(metadata.data(), "menu/fixture.pak/pack.json", metadata.size());
    }

    ~MenuDirectory() {
        TextureSourceForget(metadata.data());
        DataReadRegisterBuffer(metadata.data(), 0);
        if (previous.empty()) {
            DataReadIndex(root / "absent");
            datapacks::Clear();
        } else {
            DataReadIndex(previous);
        }
        SetCurrentDir(previous_directory.data());
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
    std::vector<u_long128> storage(4096);
    std::vector<u_long128> texture_storage(4096);
    mgCMemory              textures;
    textures.stSetBuffer(texture_storage.data(), texture_storage.size());
    mgTexManager.SetTableBuffer(64, 8, &textures);
    mgTexManager.Initialize(0x1000, -1);
    dc2::test::ScopedGlobalObject<MenuPosData> positions_owner;
    auto                                      &positions = positions_owner.Get();
    positions.Initialize();
    dc2::test::ScopedGlobalObject<MenuMoveItemPtr> move_owner;
    auto                                          &move = move_owner.Get();
    dc2::test::ScopedGlobalObject<InventManagePt>  recipes_owner;
    auto                                          &recipes = recipes_owner.Get();
    auto                                           photos = dc2::test::BindGlobalOwner<InventUserDataPtr>(std::make_unique<CInventUserData>());
    photos->ResetAddress();
    auto menu = std::make_unique<CMenuInvent>();
    menu->data_stack.stSetBuffer(storage.data(), storage.size());
    menu->tex_block[3] = 1;
    MenuDirectory directory;
    const auto    document = dc2::io::ReadFile("menu/fixture.pak/pack.json");
    ASSERT_TRUE(document);
    menu->EnterDataMenu(document);

    EXPECT_NE(menu->poly_chr_form[0], nullptr);
    EXPECT_EQ(positions.form_num, 1);
    ASSERT_EQ(recipes.num, 1);
    EXPECT_EQ(recipes.table[0].item_id, 42);
    EXPECT_EQ(recipes.table[0].materials.material[0].num, 5);
    EXPECT_EQ(menu->script_size, static_cast<int>(directory.script_size));
    CMemoryCardManager manager;
    manager.SetIconData(menu->icon_data, 1);
    menu.reset();
    datapacks::Clear();
    for (const auto &icon : manager.icon) {
        const auto bytes = icon.resource.Bytes();
        ASSERT_EQ(bytes.size(), 4u);
        EXPECT_EQ(std::string(reinterpret_cast<const char *>(bytes.data()), bytes.size()), "icon");
    }
    mgTexManager.Initialize(0x1000, -1);
}
