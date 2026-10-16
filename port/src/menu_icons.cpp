#include "common.h"

#include <array>
#include <cstdio>
#include <cstring>

#include "gamedata.hpp"
#include "item_icon3d.hpp"
#include "menudraw.hpp"
#include "menudraw_port.hpp"
#include "menumain.hpp"
#include "mg_texture_port.hpp"
#include "mglib.hpp"
#include "userdata.hpp"

PORT_OVERRIDE void CMenuPosDataManage::MallocPallet(mgCMemory *) {
    // Native atlases are RGBA. Build the retail icon colour modes from their pixels;
    // neither a PS2 CLUT nor a bytewise copy of a registered texture is usable here.
    constexpr MgTextureColorMode modes[] = {MgTextureColorMode::IconHighlight,
        MgTextureColorMode::Grey, MgTextureColorMode::Sepia};
    for (int sheet = 0; sheet < 2; ++sheet) {
        for (int mode = 0; mode < 3; ++mode) {
            pallet[mode][sheet] = nullptr;
            char name[32];
            std::snprintf(name, sizeof name, "menu_icon_%d_%d", sheet, mode);
            item_icon_tex[mode + 1][sheet] = MgTextureCreateColorVariant(item_icon_tex[0][sheet], name, modes[mode]);
        }
    }
}

PORT_OVERRIDE void CMenuPosDataManage::SearchTransPalletNo() {
    // Transparency is carried by each RGBA pixel; there is no palette index to find.
    trans_pallet_no[0] = trans_pallet_no[1] = 0;
}

PORT_OVERRIDE mgCTexture *GetMenuItemIconTexInfo(int item_no, int mode) {
    PortIconSheet = -1;
    const CDataCommon *item = GameItemDataManage.GetCommonData(item_no);
    if (item == nullptr || MenuPosData == nullptr || item->icon_texture_no >= 2 || mode < 0 || mode >= 4) {
        return nullptr;
    }
    PortIconSheet = item->icon_texture_no;
    // The item's own model, drawn small, where it has one and the icon is drawn plain (the dimmed and
    // spectrum variants are made from the sheet's pixels and stay with the sheet).
    if (mode == 0) {
        if (mgCTexture *model = ItemIcon3DTexture(item_no)) {
            PortIconUV[PortIconSheet] = {0, 0, 32, 32};
            return model;
        }
    }
    mgCTexture *texture = MenuPosData->item_icon_tex[mode][PortIconSheet];
    if (texture == nullptr) {
        return nullptr;
    }

    // Retail stages every icon into one shared cell before drawing it. Display
    // replays keep only the last staged cell, so draw and raster effects must
    // sample each item's immutable atlas cell directly on the host.
    mgRect<int> source;
    GetMenuItemIconTexGetXY(item_no, source);
    PortIconUV[PortIconSheet] = {static_cast<short>(source.left), static_cast<short>(source.top),
                                 static_cast<short>(source.right), static_cast<short>(source.bottom)};
    return texture;
}

PORT_OVERRIDE int CopyActiveIconTexture(mgCTexture **textures, int chara_no, u_int *) {
    CUserDataManager *user = GetUserDataMan();
    if (user == nullptr || textures == nullptr || chara_no < USER_CHARA_MAX) {
        return 0;
    }
    std::array<int, 8> items{};
    if (chara_no >= USER_CHARA_MAX && chara_no < USER_CHARA_ROBO) {
        const CHARA_DATA *chara = user->GetCharaDataPtr(chara_no);
        if (chara == nullptr) {
            return 0;
        }
        for (int slot = 0; slot < 3; ++slot) {
            items[slot] = chara->active_item[slot].item_no;
        }
        for (int slot = 0; slot < 4; ++slot) {
            items[4 + slot] = chara->equip[slot].item_no;
        }
    } else if (chara_no == USER_CHARA_ROBO) {
        items[4] = user->robo_data.parts[ROBO_PART_PACK].item_no;
        items[5] = user->robo_data.parts[ROBO_PART_ARM].item_no;
    }
    char          item_name[] = "itemicon", weapon_name[] = "wepicon";
    mgCTexture   *sheets[] = {mgTexManager.GetTexture(item_name, -1), mgTexManager.GetTexture(weapon_name, -1)};
    constexpr int counts[] = {3, 2};
    for (int sheet = 0; sheet < 2; ++sheet) {
        mgCTexture       *dest = textures[sheet];
        const mgCTexture *source = sheets[sheet];
        if (dest == nullptr || source == nullptr || dest->image[0] == nullptr ||
            source->image[0] == nullptr || dest->bpp != 32 || source->bpp != 32) {
            continue;
        }
        auto       *pixels = reinterpret_cast<u8 *>(dest->image[0]);
        const auto *atlas = reinterpret_cast<const u8 *>(source->image[0]);
        bool        changed_cpu_pixels = false;
        const bool  enlarged = MgTexturePhysicalExtent(source).width > (1u << source->tex0.TW) ||
                               MgTexturePhysicalExtent(dest).width > (1u << dest->tex0.TW);
        for (int slot = 0; slot < counts[sheet]; ++slot) {
            const int x = (slot % 2) * 32, y = (slot / 2) * 32;
            if (x + 32 > dest->width || y + 32 > dest->height) {
                continue;
            }
            const int  item = items[sheet * 4 + slot];
            const int  icon = item > 0 ? GetItemIconNo(item) : -1;
            const int  src_x = (icon % 8) * 32, src_y = (icon / 8) * 32;
            const bool valid = icon >= 0 && src_x + 32 <= source->width && src_y + 32 <= source->height;
            if (enlarged && MgTextureCopyRegion(valid ? source : nullptr, src_x, src_y, dest, x, y, 32, 32)) {
                continue;
            }
            changed_cpu_pixels = true;
            for (int row = 0; row < 32; ++row) {
                u8 *out = pixels + ((y + row) * dest->width + x) * 4;
                if (valid) {
                    std::memcpy(out, atlas + ((src_y + row) * source->width + src_x) * 4, 32 * 4);
                } else {
                    std::memset(out, 0, 32 * 4);
                }
            }
        }
        // The baked RGBA destination changed in place; refresh the renderer's uploaded pixels.
        if (changed_cpu_pixels) {
            MgTexturePixelsChanged(dest);
        }
    }
    return 1;
}
