#include "common.h"

#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <array>
#include <chrono>
#include <cstdlib>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <memory>
#include <span>
#include <string>
#include <vector>

#include "assets/data_registry.hpp"
#include "charasetup.hpp"
#include "dataread.hpp"
#include "gfx/gfx.hpp"
#include "menu_character_assets.hpp"
#include "menuaqua.hpp"
#include "menumain.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"
#include "platform/paths.hpp"
#include "scoped_global_object.hpp"
#include "userdata.hpp"

namespace {
/**
 * Restores menu globals after exercising independent native workspace and texture-directory lifetimes.
 */
struct MenuGlobals {
    CMenuPosDataManage *positions = MenuPosData; /**< Previous menu layout manager. */
    CMenuKeyFunc       *common = MenuCommonInfo; /**< Previous common menu state. */
    u_int              *pack = MenuArg.pack;     /**< Previous actual menu directory marker. */
    u_long128          *workspace_stack = MenuMainTextureReadBuf.stack;
    int                 workspace_size = MenuMainTextureReadBuf.stack_size;
    int                 workspace_used = MenuMainTextureReadBuf.stack_used;
    int                 workspace_lock = MenuMainTextureReadBuf.lock;

    ~MenuGlobals() {
        MenuPosData = positions;
        MenuCommonInfo = common;
        MenuArg.pack = pack;
        MenuMainTextureReadBuf.stSetLocked(false);
        MenuMainTextureReadBuf.stSetBuffer(workspace_stack, workspace_size);
        if (workspace_used > 0 && MenuMainTextureReadBuf.Alloc(workspace_used) == nullptr) {
            std::abort();
        }
        MenuMainTextureReadBuf.stSetLocked(workspace_lock != 0);
    }
};
} // namespace

TEST(MenuWorkspace, BaseMenuConstructionPreservesVirtualDispatchAndEmptyState) {
    CBaseMenuClass menu;
    const auto     dispatch = [](CBaseMenuClass *base) { return base->IsCreateObject(0, 0); };

    EXPECT_EQ(dispatch(&menu), 1);
    EXPECT_EQ(menu.mode, MENU_ASK_MODE_OPEN);
    EXPECT_EQ(menu.swap_info.flag, 0);
    EXPECT_EQ(menu.swap_info.type, 0);
    EXPECT_EQ(menu.swap_info.no, 0);
    EXPECT_EQ(menu.swap_info.chara, 0);
    EXPECT_EQ(menu.cmd_arg_pos, -1);
    EXPECT_EQ(menu.make_item_no, 0);
    EXPECT_EQ(menu.make_num, 0);
    EXPECT_EQ(menu.make_space_no, 0);
    EXPECT_EQ(menu.make_cursor, 0);
    EXPECT_EQ(menu.make_num_max, 0);
    for (const int block : menu.tex_block) {
        EXPECT_EQ(block, -1);
    }
}

TEST(MenuWorkspace, ModelAssetPathsPreserveLongNamesAndExtensions) {
    const std::string long_name(160, 'a');
    EXPECT_EQ(dc2::character::ModelAssetPath("chara", long_name, false), "chara/" + long_name);
    EXPECT_EQ(dc2::character::ModelAssetPath("mainchr", "c01_base.gltf", false), "mainchr/c01_base.gltf");
    EXPECT_EQ(dc2::character::ModelAssetPath("dungeon/robo", long_name, true), "dungeon/robo/" + long_name + ".gltf");
    EXPECT_EQ(dc2::character::ModelAssetPath("dungeon/robo", "rider.gltf", false), "dungeon/robo/rider.gltf");
}

TEST(MenuWorkspace, CharacterSoundPathsUseConvertedAssetsAndHandleMissingRidepodArm) {
    auto user = std::make_unique<CUserDataManager>();
    user->chara_data[USER_CHARA_MAX].equip[CHARA_EQUIP_SUB].item_no = 0x16;
    EXPECT_EQ(dc2::character::SoundAssetPath(user.get(), USER_CHARA_MAX), "snd2/chara/CH_000.sound.json");
    user->chara_data[USER_CHARA_MAX].equip[CHARA_EQUIP_SUB].item_no = 0x28;
    EXPECT_EQ(dc2::character::SoundAssetPath(user.get(), USER_CHARA_MAX), "snd2/chara/CH_018.sound.json");
    user->chara_data[USER_CHARA_MAX].equip[CHARA_EQUIP_SUB].item_no = -1;
    EXPECT_EQ(dc2::character::SoundAssetPath(user.get(), USER_CHARA_MAX), "snd2/chara/CH_000.sound.json");
    EXPECT_EQ(dc2::character::SoundAssetPath(user.get(), USER_CHARA_MONICA), "snd2/chara/CH_020.sound.json");

    user->robo_data.parts[ROBO_PART_ARM].item_no = -1;
    EXPECT_TRUE(dc2::character::SoundAssetPath(user.get(), USER_CHARA_ROBO).empty());
    EXPECT_TRUE(dc2::character::SoundAssetPath(user.get(), USER_CHARA_MONSTER).empty());
    EXPECT_TRUE(dc2::character::SoundAssetPath(nullptr, USER_CHARA_MAX).empty());
}

TEST(MenuWorkspace, CharacterChangeFindsItemTextureWithOrWithoutSoundRead) {
    const auto  root = std::filesystem::temp_directory_path() /
                       ("menu_item_read_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
    const auto  previous_root = PathsDataRoot();
    std::string previous_directory = GetCurrentDir();
    const auto  data = root / "data";
    std::filesystem::create_directories(data / "snd2/chara");
    std::filesystem::create_directories(data / "textures/img");
    std::ofstream(data / "snd2/chara/CH_000.sound.json") << "sound";
    std::ofstream(data / "textures/img/allitem.json") << "texture";
    DataReadIndex(data);
    SetCurrentDir(nullptr);

    alignas(16) std::array<u_long128, 256> sound{};
    alignas(16) std::array<u_long128, 256> item{};
    char                                   sound_path[] = "snd2/chara/CH_000.sound.json";
    char                                   item_path[] = "textures/img/allitem.json";
    InitReadBG();
    ASSERT_TRUE(LoadFileBG(sound_path, std::span(reinterpret_cast<u8 *>(sound.data()), std::span(sound).size_bytes()), nullptr));
    ASSERT_TRUE(LoadFileBG(item_path, std::span(reinterpret_cast<u8 *>(item.data()), std::span(item).size_bytes()), nullptr));
    {
        const auto read = dc2::menu::MainCharacterItemRead();
        ASSERT_TRUE(read);
        EXPECT_EQ(read.Size(), 7);
        EXPECT_EQ(std::memcmp(read.Bytes().data(), item.data(), 7), 0);
    }

    InitReadBG();
    char missing_sound[] = "snd2/chara/missing.sound.json";
    EXPECT_FALSE(LoadFileBG(missing_sound, std::span(reinterpret_cast<u8 *>(sound.data()), std::span(sound).size_bytes()), nullptr));
    ASSERT_TRUE(LoadFileBG(item_path, std::span(reinterpret_cast<u8 *>(item.data()), std::span(item).size_bytes()), nullptr));
    {
        const auto read = dc2::menu::MainCharacterItemRead();
        ASSERT_TRUE(read);
        EXPECT_EQ(read.Size(), 7);
        EXPECT_EQ(std::memcmp(read.Bytes().data(), item.data(), 7), 0);
    }

    InitReadBG();
    SetCurrentDir(previous_directory.data());
    DataReadIndex(previous_root);
    std::filesystem::remove_all(root);
}

TEST(MenuWorkspace, DirectoryMarkerDoesNotLimitAquariumStorageOrTextureReentry) {
    const auto root = std::filesystem::temp_directory_path() / ("menu_workspace_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
    const auto previous_root = PathsDataRoot();
    std::filesystem::create_directories(root / "data");
    const auto directory = root / "data/menu/native.pac";
    std::filesystem::create_directories(directory);
    std::ofstream(directory / "pack.json") << R"({"schema_version":1,"kind":"asset_directory","texture_members":[{"name":"edmenu.json","path":"textures/menu/edmenu.json"},{"name":"allitem.json","path":"textures/menu/allitem.json"}]})";
    const auto texture_directory = root / "data/textures/menu";
    std::filesystem::create_directories(texture_directory);
    std::ofstream(texture_directory / "edmenu.json") << R"({"schema_version":3,"groups":[0],"entries":[{"name":"menuwork2","pictures":[{"levels":["pixel.png"]}]}]})";
    std::ofstream(texture_directory / "allitem.json") << R"({"schema_version":3,"groups":[0],"entries":[]})";
    constexpr std::array<unsigned char, 4> pixel{32, 64, 128, 255};
    ASSERT_TRUE(gfx::WritePng(texture_directory / "pixel.png", pixel.data(), 1, 1));
    DataReadIndex(root / "data");
    SetCurrentDir(nullptr);
    alignas(16) std::array<u_long128, 128> marker{};
    char                                   path[] = "menu/native.pac";
    int                                    marker_size = 0;
    ASSERT_TRUE(LoadFile2(path, std::span(reinterpret_cast<u8 *>(marker.data()), std::span(marker).size_bytes()), &marker_size, LOAD_FILE_READ));
    ASSERT_LT(marker_size, static_cast<int>(sizeof(marker)));
    const auto             original_marker = marker;
    std::vector<u_long128> texture_storage(4096);
    std::vector<u_long128> palette_storage(1024);
    mgCMemory              textures;
    mgCMemory              palettes;
    textures.stSetBuffer(texture_storage.data(), static_cast<int>(texture_storage.size()));
    palettes.stSetBuffer(palette_storage.data(), static_cast<int>(palette_storage.size()));
    mgTexManager.SetTableBuffer(64, 8, &textures);
    mgTexManager.Initialize(0x1000, -1);
    MenuGlobals                                restore;
    dc2::test::ScopedGlobalObject<MenuPosData> positions_owner;
    auto                                      &positions = positions_owner.Get();
    positions.Initialize();
    dc2::test::ScopedGlobalObject<MenuCommonInfo> common_owner;
    auto                                         &common = common_owner.Get();
    common.tex_block[1] = 1;
    MenuArg.pack = reinterpret_cast<u_int *>(marker.data());
    MenuCommonBaseDataEnter(&palettes, MenuArg.pack, marker_size, 1);
    char texture_name[] = "menuwork2";
    ASSERT_NE(MenuMainTextureReadBuf.stack, marker.data());
    EXPECT_GE(MenuMainTextureReadBuf.stack_size, 260000);
    ASSERT_NE(mgTexManager.GetTexture(texture_name, 1), nullptr);

    // Aquarium initialization carves these sound, message, interior and fish-model extents.
    for (int blocks : {0x80, 0x4650, 0x1e00}) {
        ASSERT_NE(MenuMainTextureReadBuf.Alloc(blocks), nullptr);
    }
    for (int slot = 0; slot < AQUA_FISH_SLOT_NUM; ++slot) {
        ASSERT_NE(MenuMainTextureReadBuf.Alloc(sizeof(CAquaFishEff) / 16 + 2), nullptr);
        ASSERT_NE(MenuMainTextureReadBuf.Alloc(sizeof(CBubble) / 16 + 2), nullptr);
        ASSERT_NE(MenuMainTextureReadBuf.Alloc(0x319c), nullptr);
    }
    std::memset(MenuMainTextureReadBuf.stack, 0xa5, static_cast<std::size_t>(MenuMainTextureReadBuf.stack_used) * sizeof(u_long128));
    MenuBaseTextureReEnter();
    EXPECT_NE(mgTexManager.GetTexture(texture_name, 1), nullptr);
    EXPECT_EQ(positions.common_tex, mgTexManager.GetTexture(texture_name, 1));
    EXPECT_EQ(std::memcmp(marker.data(), original_marker.data(), sizeof(marker)), 0);
    EXPECT_EQ(DataReadBufferSize(marker.data()), static_cast<std::size_t>(marker_size));
    mgTexManager.Initialize(0x1000, -1);
    DataReadIndex(previous_root);
    std::filesystem::remove_all(root);
}
