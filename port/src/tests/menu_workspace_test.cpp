#include "common.h"

#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <array>
#include <chrono>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <vector>

#include "dataread.hpp"
#include "dataread_port.hpp"
#include "gfx/gfx.hpp"
#include "menuaqua.hpp"
#include "menumain.hpp"
#include "mglib.hpp"
#include "platform/paths.hpp"

namespace {
/**
 * Restores menu globals after exercising independent native workspace and texture-directory lifetimes.
 */
struct MenuGlobals {
    CMenuPosDataManage *positions = MenuPosData;            /**< Previous menu layout manager. */
    CMenuKeyFunc       *common = MenuCommonInfo;            /**< Previous common menu state. */
    u_int              *pack = MenuArg.pack;                /**< Previous actual menu directory marker. */
    mgCMemory           workspace = MenuMainTextureReadBuf; /**< Previous menu work arena. */

    ~MenuGlobals() {
        MenuPosData = positions;
        MenuCommonInfo = common;
        MenuArg.pack = pack;
        MenuMainTextureReadBuf = workspace;
    }
};
} // namespace

TEST(MenuWorkspace, DirectoryMarkerDoesNotLimitAquariumStorageOrTextureReentry) {
    const auto root = std::filesystem::temp_directory_path() / ("menu_workspace_" + std::to_string(std::chrono::steady_clock::now().time_since_epoch().count()));
    const auto previous_root = PathsDataRoot();
    std::filesystem::create_directories(root / "data");
    const auto directory = root / "data/menu/native.pac";
    std::filesystem::create_directories(directory);
    std::ofstream(directory / "pack.json") << R"({"schema_version":1,"kind":"asset_directory"})";
    std::ofstream(directory / "edmenu.json") << R"({"schema_version":3,"groups":[0],"entries":[{"name":"menuwork2","pictures":[{"levels":["pixel.png"]}]}]})";
    std::ofstream(directory / "allitem.json") << R"({"schema_version":3,"groups":[0],"entries":[]})";
    constexpr std::array<unsigned char, 4> pixel{32, 64, 128, 255};
    ASSERT_TRUE(gfx::WritePng(directory / "pixel.png", pixel.data(), 1, 1));
    DataReadIndex(root / "data");
    SetCurrentDir(nullptr);
    alignas(16) std::array<u_long128, 128> marker{};
    char                                   path[] = "menu/native.pac";
    int                                    marker_size = 0;
    ASSERT_TRUE(LoadFile2(path, marker.data(), &marker_size, LOAD_FILE_READ));
    ASSERT_LT(marker_size, 128);
    const auto             original_marker = marker;
    std::vector<u_long128> texture_storage(4096);
    std::vector<u_long128> palette_storage(1024);
    mgCMemory              textures;
    mgCMemory              palettes;
    textures.stSetBuffer(texture_storage.data(), static_cast<int>(texture_storage.size()));
    palettes.stSetBuffer(palette_storage.data(), static_cast<int>(palette_storage.size()));
    mgTexManager.SetTableBuffer(64, 8, &textures);
    mgTexManager.Initialize(0x1000, -1);
    MenuGlobals        restore;
    CMenuPosDataManage positions{};
    positions.Initialize();
    CMenuKeyFunc common{};
    common.tex_block[1] = 1;
    MenuPosData = &positions;
    MenuCommonInfo = &common;
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
