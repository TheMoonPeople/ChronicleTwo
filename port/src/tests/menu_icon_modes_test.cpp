#include <gtest/gtest.h>

#include <array>
#include <cstring>
#include <vector>

#include "menuchr.hpp"
#include "menudraw.hpp"
#include "mg_drawprim.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"
#include "render/texture_runtime.hpp"

TEST(MenuIconModes, RgbaSheetsCreateIndependentModesWithoutPalettes) {
    std::vector<u_long128> arena(8192);
    mgCMemory              memory;
    memory.stSetBuffer(arena.data(), static_cast<int>(arena.size()));
    mgTexManager.SetTableBuffer(16, 4, &memory);
    mgTexManager.Initialize(0x1000, -1);
    CMenuPosDataManage       menu{};
    std::array<u_long128, 1> pixels{};
    const u8                 rgba[] = {48, 96, 144, 255, 0, 0, 0, 0, 255, 255, 255, 128, 0, 0, 0, 255};
    std::memcpy(pixels.data(), rgba, sizeof rgba);
    u_long128 *images[MG_TEXTURE_LEVEL_MAX] = {pixels.data()};
    char       names[2][16] = {"wepicon", "itemicon"};
    for (int sheet = 0; sheet < 2; ++sheet) {
        menu.item_icon_tex[0][sheet] = mgTexManager.EnterTexture(0, names[sheet], images, 2, 2, 32, nullptr, 0, 0);
        ASSERT_NE(menu.item_icon_tex[0][sheet], nullptr);
        ASSERT_EQ(menu.item_icon_tex[0][sheet]->clut, nullptr);
    }
    const int used = memory.stack_used;
    for (int pass = 0; pass < 2; ++pass) {
        menu.MallocPallet(&memory);
        menu.SearchTransPalletNo();
        EXPECT_EQ(memory.stack_used, used);
        for (int sheet = 0; sheet < 2; ++sheet) {
            for (int mode = 1; mode < 4; ++mode) {
                const auto *texture = menu.item_icon_tex[mode][sheet];
                ASSERT_NE(texture, nullptr);
                EXPECT_NE(texture->tex0.value, menu.item_icon_tex[0][sheet]->tex0.value);
                EXPECT_EQ(texture->clut, nullptr);
                EXPECT_EQ(texture->bpp, 32);
                const auto *color = reinterpret_cast<const u8 *>(texture->image[0]);
                EXPECT_EQ(color[3], 255);
                EXPECT_EQ(color[7], 0);
                EXPECT_EQ(color[11], 128);
                if (mode == 1) {
                    EXPECT_EQ(color[0], 48);
                    EXPECT_EQ(color[1], 96);
                    EXPECT_EQ(color[2], 255);
                } else if (mode == 2) {
                    EXPECT_EQ(color[0], 96);
                    EXPECT_EQ(color[1], 96);
                    EXPECT_EQ(color[2], 96);
                    EXPECT_EQ(color[8], 240);
                } else {
                    EXPECT_EQ(color[0], 115);
                    EXPECT_EQ(color[1], 81);
                    EXPECT_EQ(color[2], 67);
                }
            }
        }
    }
    EXPECT_EQ(std::memcmp(pixels.data(), rgba, sizeof rgba), 0);

    MenuCharaChangeBase_Tex = menu.item_icon_tex[0][0];
    char locked_name[] = "party_locked";
    MenuCharaChangeCLUT_Tex = MgTextureCreateColorVariant(MenuCharaChangeBase_Tex, locked_name,
                                                          MgTextureColorMode::PartyLocked);
    ASSERT_NE(MenuCharaChangeCLUT_Tex, nullptr);
    const auto *locked = reinterpret_cast<const u8 *>(MenuCharaChangeCLUT_Tex->image[0]);
    EXPECT_EQ(locked[0], 100);
    EXPECT_EQ(locked[1], 73);
    EXPECT_EQ(locked[2], 60);
    EXPECT_EQ(locked[3], 255);
    EXPECT_EQ(locked[7], 0);
    mgCDrawPrim prim;
    prim.Initialize(nullptr, nullptr);
    MenuReloadCLUT(0);
    prim.Texture(MenuCharaChangeBase_Tex);
    EXPECT_EQ(prim.texture.tex0.value, MenuCharaChangeCLUT_Tex->tex0.value);
    MenuReloadCLUT(1);
    prim.Texture(MenuCharaChangeBase_Tex);
    EXPECT_EQ(prim.texture.tex0.value, MenuCharaChangeBase_Tex->tex0.value);
    MenuReloadCLUT(0);
    mgTexManager.DeleteTexture(MenuCharaChangeCLUT_Tex);
    EXPECT_EQ(MgTextureDrawVariant(MenuCharaChangeBase_Tex), MenuCharaChangeBase_Tex);
    MenuCharaChangeBase_Tex = MenuCharaChangeCLUT_Tex = nullptr;
    menu.item_icon_tex[0][1] = nullptr;
    menu.MallocPallet(&memory);
    for (int mode = 1; mode < 4; ++mode) {
        EXPECT_EQ(menu.item_icon_tex[mode][1], nullptr);
    }
    mgTexManager.Initialize(0x1000, -1);
}
