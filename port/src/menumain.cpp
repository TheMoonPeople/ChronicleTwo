#include "common.h"

#include <filesystem>
#include <string>
#include <string_view>
#include <vector>

#include "asset_directory.hpp"
#include "dataread_port.hpp"
#include "menumain.hpp"
#include "mg_texture_port.hpp"
#include "mglib.hpp"
#include "platform/texture_catalog.hpp"
#include "texture_source.hpp"

namespace {
constexpr int menu_workspace_quadwords = 260000; /**< Capacity of the native menu's reusable work arena. */

/**
 * Owns menu workspace independently of the small serialized directory marker.
 */
std::vector<u_long128> &MenuWorkspace() {
    static std::vector<u_long128> workspace(menu_workspace_quadwords);
    return workspace;
}

/**
 * Retains the actual directory supplying common textures while workspace bytes are reused.
 */
std::string &CommonTextureDirectory() {
    static std::string directory;
    return directory;
}

/**
 * Enters common texture documents directly from the retained native directory.
 */
void EnterCommonTextures(int block) {
    if (CommonTextureDirectory().empty()) {
        return;
    }
    const std::filesystem::path directory(CommonTextureDirectory());
    for (const auto *name : {"edmenu.json", "allitem.json", "spectre.json"}) {
        const auto path = (directory / name).generic_string();
        if (std::string_view(name) == "spectre.json" && !texture_catalog::Find(path)) {
            continue;
        }
        MgTextureEnterDocument(&mgTexManager, path, block, nullptr, nullptr);
    }
}
} // namespace

PORT_OVERRIDE void MenuCommonBaseDataEnter(mgCMemory *pallet_memory, u_int *pack, int, int block) {
    CommonTextureDirectory() = AssetDirectoryPath(pack).value_or(std::string{});
    auto &workspace = MenuWorkspace();
    DataReadRegisterBuffer(workspace.data(), 0);
    TextureSourceForget(workspace.data());
    MenuMainTextureReadBuf.stSetBuffer(workspace.data(), static_cast<int>(workspace.size()));
    EnterCommonTextures(block);
    MenuPosData->AttachCommonTexInfo();
    MenuItemIconTextureBlock = block;
    MenuPosData->MallocPallet(pallet_memory);
    MenuPosData->SearchTransPalletNo();
    MenuPosData->ResetTextureInfoAll();
}

PORT_OVERRIDE void MenuBaseTextureReEnter() {
    if (DataReadBufferSize(MenuMainTextureReadBuf.stack) != 0) {
        if (const auto directory = AssetDirectoryPath(MenuMainTextureReadBuf.stack)) {
            CommonTextureDirectory() = *directory;
        }
    }
    const int block = MenuCommonInfo->tex_block[1];
    mgTexManager.DeleteBlock(block);
    MenuMainImageDataEnter(block);
    EnterCommonTextures(block);
    MenuPosData->AttachCommonTexInfo();
    MenuPosData->ResetTextureInfoAll();
}
