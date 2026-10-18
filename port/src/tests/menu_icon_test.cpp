#include <gtest/gtest.h>

#include <array>
#include <cstring>
#include <memory>
#include <vector>

#include "gamedata.hpp"
#include "gfx_fixture.hpp"
#include "mainloop.hpp"
#include "mainloop_port.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "mg_drawprim_port.hpp"
#include "mg_texture_port.hpp"
#include "mglib.hpp"
#include "savedata.hpp"

namespace {
class MenuIconGpu : public testing::Test {
protected:
    dc::test::GfxFixture       gfx_;
    std::vector<u_long128>     arena_ = std::vector<u_long128>(8192);
    mgCMemory                  memory_;
    std::vector<u_long128>     atlas_ = std::vector<u_long128>(256 * 1024 * 4 / 16);
    CDataCommon                common_{};
    int                        saved_width_ = mgScreenWidth, saved_height_ = mgScreenHeight;
    CGameData                  saved_data_ = GameItemDataManage;
    CMenuPosDataManage        *saved_menu_ = MenuPosData;
    CScene                    *saved_scene_ = MenuMainScene;
    sceVif1Packet             *saved_packet_ = mgVif1Packet;
    CSaveData                 *saved_save_ = PortActiveSaveData;
    CMenuPosDataManage         menu_{};
    std::unique_ptr<CSaveData> save_ = std::make_unique<CSaveData>();

    void SetUp() override {
        mgScreenWidth = 640;
        mgScreenHeight = 480;
        memory_.stSetBuffer(arena_.data(), static_cast<int>(arena_.size()));
        mgTexManager.SetTableBuffer(16, 4, &memory_);
        mgTexManager.Initialize(0x1000, -1);
        // Icon 11 is green and icon 12 blue on the second atlas row.
        auto *bytes = reinterpret_cast<u8 *>(atlas_.data());
        for (int y = 0; y < 1024; ++y) {
            for (int x = 0; x < 256; ++x) {
                u8 *pixel = bytes + (y * 256 + x) * 4;
                pixel[0] = 255;
                pixel[3] = 255;
                if (y >= 32 && y < 64 && x >= 96 && x < 128) {
                    pixel[0] = 0;
                    pixel[1] = 255;
                } else if (y >= 32 && y < 64 && x >= 128 && x < 160) {
                    pixel[0] = 0;
                    pixel[2] = 255;
                }
            }
        }
        common_.icon_no = 11;
        common_.icon_texture_no = 1;
        GameItemDataManage.common_data = &common_;
        ASSERT_EQ(GameItemDataManage.GetCommonData(1), &common_);
        MenuPosData = &menu_;
        MenuMainScene = nullptr;
        PortActiveSaveData = save_.get();
    }

    void TearDown() override {
        mgVif1Packet = saved_packet_;
        mgPortSetPrimSink({});
        mgTexManager.Initialize(0x1000, -1);
        mgScreenWidth = saved_width_;
        mgScreenHeight = saved_height_;
        GameItemDataManage = saved_data_;
        MenuPosData = saved_menu_;
        MenuMainScene = saved_scene_;
        PortActiveSaveData = saved_save_;
    }

    static mgCTexture *Enter(char *name, int width, int height, u_long128 *pixels) {
        u_long128 *levels[MG_TEXTURE_LEVEL_MAX] = {pixels};
        return mgTexManager.EnterTexture(0, name, levels, width, height, 32, nullptr, 0, 0);
    }
};
} // namespace

TEST_F(MenuIconGpu, ActiveIconsRefreshBakedRgbaPixelsAfterInPlaceCopy) {
    char item_name[] = "itemicon";
    char weapon_name[] = "wepicon";
    Enter(item_name, 256, 1024, atlas_.data());
    Enter(weapon_name, 256, 1024, atlas_.data());
    std::array<u_long128, 1024> item_pixels{};
    std::array<u_long128, 1024> weapon_pixels{};
    char                        dummy1[] = "icon_dmy1";
    char                        dummy2[] = "icon_dmy2";
    mgCTexture                 *dest[] = {Enter(dummy1, 64, 64, item_pixels.data()),
                                          Enter(dummy2, 64, 64, weapon_pixels.data())};
    save_->user_data.chara_data[0].active_item[0].item_no = 1;
    save_->user_data.chara_data[0].equip[0].item_no = 1;
    const auto saved_user = std::make_unique<CUserDataManager>(save_->user_data);
    const auto key = dest[0]->tex0.value;
    const auto old_handles = MgTextureLookup(dest[0]);
    ASSERT_EQ(CopyActiveIconTexture(dest, 0, nullptr), 1);
    EXPECT_EQ(dest[0]->tex0.value, key);
    EXPECT_EQ(MgTextureLookup(dest[0]).texture, old_handles.texture);
    EXPECT_EQ(MgTextureLookup(dest[0]).palette, gfx::kNullTexture);
    EXPECT_EQ(std::memcmp(saved_user.get(), &save_->user_data, sizeof(CUserDataManager)), 0);
    // The renderer's textures, not only the CPU copy, must hold the item pixels.
    EXPECT_EQ(reinterpret_cast<u8 *>(item_pixels.data())[1], 255);
    for (mgCTexture *texture : dest) {
        auto            handles = MgTextureLookup(texture);
        std::vector<u8> pixels;
        uint32_t        width = 0;
        uint32_t        height = 0;
        ASSERT_TRUE(gfx::ReadbackTexture(handles.texture, pixels, width, height));
        EXPECT_EQ(pixels[1], 255);
        EXPECT_EQ(pixels[3], 255);
        EXPECT_EQ(pixels[32 * 4 + 3], 0); // absent second slot stays transparent
    }
}

TEST_F(MenuIconGpu, ItemDrawSamplesSelectedAtlasCellsInCanonicalAndDisplayFrames) {
    char  name[] = "itemicon";
    auto *texture = Enter(name, 256, 1024, atlas_.data());
    menu_.item_icon_tex[0][1] = texture;
    mgCMemory     memory;
    sceVif1Packet packet{};
    mgVif1Packet = &packet;
    mgRENDER_INFO  info{};
    mgCDrawManager manager;
    mgCDrawPrim    prim;
    manager.render_info = &info;
    prim.draw_manager = &manager;
    prim.Initialize(&memory, &packet);
    prim.write = nullptr;
    prim.Coord(1);
    int draws = 0;
    mgPortSetPrimSink([&](gfx::Primitive kind, std::span<const gfx::Vertex2D> vertices,
                          const gfx::TextureBinding &binding, const gfx::DrawState &state) {
        auto draw_state = state;
        draw_state.scissor = false;
        gfx::Draw2D(kind, vertices, binding, draw_state);
        ++draws;
    });
    u8              rgba[] = {128, 128, 128, 128};
    const auto      handles = MgTextureLookup(texture);
    std::vector<u8> original_atlas;
    uint32_t        width = 0;
    uint32_t        height = 0;
    ASSERT_TRUE(gfx::ReadbackTexture(handles.texture, original_atlas, width, height));
    gfx::BeginRecording();
    const u8 clear[] = {0, 0, 0, 255};
    gfx::Clear(true, clear, true, 0.0f);
    DrawOneItem(&prim, mgRect<float>(10, 10, 32, 32), 1, 0, nullptr, rgba, 0);
    common_.icon_no = 12;
    DrawOneItem(&prim, mgRect<float>(50, 10, 32, 32), 1, 0, nullptr, rgba, 0);
    auto list = gfx::EndRecording();
    ASSERT_TRUE(gfx::RenderList(*list, 1.0f, {.canonical = true}));
    ASSERT_TRUE(gfx::ReadbackFrame(gfx_.pixels, gfx_.width, gfx_.height));
    EXPECT_GE(draws, 2);
    EXPECT_TRUE(gfx_.PixelNear(20, 20, 0, 255, 0));
    EXPECT_TRUE(gfx_.PixelNear(60, 20, 0, 0, 255));
    // Window presentation must retain distinct icons without changing the atlas.
    std::vector<u8> canonical_atlas;
    ASSERT_TRUE(gfx::ReadbackTexture(handles.texture, canonical_atlas, width, height));
    EXPECT_EQ(canonical_atlas, original_atlas);
    for (float alpha : {0.0f, 0.5f, 1.0f}) {
        ASSERT_TRUE(gfx::RenderList(*list, alpha, {.present = true}));
        ASSERT_TRUE(gfx::ReadbackFrame(gfx_.pixels, gfx_.width, gfx_.height));
        EXPECT_TRUE(gfx_.PixelNear(20, 20, 0, 255, 0)) << "alpha " << alpha;
        EXPECT_TRUE(gfx_.PixelNear(60, 20, 0, 0, 255)) << "alpha " << alpha;
        std::vector<u8> after_display;
        ASSERT_TRUE(gfx::ReadbackTexture(handles.texture, after_display, width, height));
        EXPECT_EQ(after_display, canonical_atlas);
    }
}

TEST_F(MenuIconGpu, EffectUsesSelectedBakedRgbaAtlasAndRestoresNormally) {
    char                   name[] = "itemicon";
    char                   variant_name[] = "itemicon_variant";
    auto                  *base = Enter(name, 256, 1024, atlas_.data());
    std::vector<u_long128> alternate = atlas_;
    auto                  *colors = reinterpret_cast<u8 *>(alternate.data());
    for (int y = 32; y < 64; ++y) {
        for (int x = 96; x < 128; ++x) {
            u8 *pixel = colors + (y * 256 + x) * 4;
            pixel[1] = 0;
            pixel[2] = 255;
        }
    }
    auto *variant = Enter(variant_name, 256, 1024, alternate.data());
    menu_.item_icon_tex[0][1] = base;
    menu_.item_icon_tex[2][1] = variant;
    mgCMemory     memory;
    sceVif1Packet packet{};
    mgVif1Packet = &packet;
    mgRENDER_INFO  info{};
    mgCDrawManager manager;
    manager.render_info = &info;
    mgCDrawPrim prim;
    prim.draw_manager = &manager;
    prim.Initialize(&memory, &packet);
    prim.write = nullptr;
    prim.Coord(1);
    mgPortSetPrimSink([&](gfx::Primitive kind, std::span<const gfx::Vertex2D> vertices,
                          const gfx::TextureBinding &binding, const gfx::DrawState &state) {
        auto draw_state = state;
        draw_state.scissor = false;
        gfx::Draw2D(kind, vertices, binding, draw_state);
    });
    u8 rgba[] = {128, 128, 128, 128};
    gfx::BeginRecording();
    const u8 clear[] = {0, 0, 0, 255};
    gfx::Clear(true, clear, true, 0);
    DrawOneItem(&prim, {10, 10, 32, 32}, 1, 2, nullptr, rgba, 0);
    DrawOneItem(&prim, {50, 10, 32, 32}, 1, 0, nullptr, rgba, 0);
    auto list = gfx::EndRecording();
    ASSERT_TRUE(gfx::RenderList(*list, 1, {.canonical = true}));
    ASSERT_TRUE(gfx::ReadbackFrame(gfx_.pixels, gfx_.width, gfx_.height));
    // Mode 2 retains retail dimming and selects its baked blue variant.
    EXPECT_TRUE(gfx_.PixelNear(20, 20, 0, 0, 201));
    EXPECT_TRUE(gfx_.PixelNear(60, 20, 0, 255, 0));
    for (float alpha : {0.0f, 0.25f, 0.5f, 0.75f, 1.0f}) {
        ASSERT_TRUE(gfx::RenderList(*list, alpha, {.present = true}));
        ASSERT_TRUE(gfx::ReadbackFrame(gfx_.pixels, gfx_.width, gfx_.height));
        EXPECT_TRUE(gfx_.PixelNear(20, 20, 0, 0, 201)) << alpha;
        EXPECT_TRUE(gfx_.PixelNear(60, 20, 0, 255, 0)) << alpha;
    }
    const auto normal_handles = MgTextureLookupTex0(base->tex0.value);
    const auto effect_handles = MgTextureLookupTex0(variant->tex0.value);
    EXPECT_NE(normal_handles.texture, effect_handles.texture);
    EXPECT_EQ(normal_handles.palette, gfx::kNullTexture);
    EXPECT_EQ(effect_handles.palette, gfx::kNullTexture);
}
