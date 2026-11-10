#include <gtest/gtest.h>

#include "gamepad.hpp"
#include "mainloop.hpp"
#include "menu_mouse.hpp"
#include "menudraw.hpp"
#include "menusys.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "nd_meswin.hpp"
#include "platform/input.hpp"
#include "render/primitive_submission.hpp"
#include "render/renderer.hpp"
#include "scoped_global_object.hpp"

TEST(MenuCursor, BothBandsKeepTheCursorTextureAndColor) {
    dc2::test::ScopedGlobalObject<mgDrawManager.render_info> info_owner;
    auto                                                    &info = info_owner.Get();
    dc2::test::ScopedGlobalObject<mgVif1Packet>              packet_owner;
    auto                                                    &packet = packet_owner.Get();
    const int                                                saved_width = mgScreenWidth;
    const int                                                saved_height = mgScreenHeight;
    mgScreenWidth = 512;
    mgScreenHeight = 480;
    mgPortSetTextureLookup(nullptr, [](uint64_t tex0) -> mgPortTexture {
        return tex0 != 0 ? mgPortTexture{.texture = 42, .palette = 43} : mgPortTexture{};
    });
    int horizontal = 0;
    int vertical = 0;
    mgPortSetPrimSink([&](gfx::Primitive kind, std::span<const gfx::Vertex2D> vertices,
                          const gfx::TextureBinding &binding, const gfx::DrawState &) {
        if (vertices.empty()) {
            return;
        }
        if (kind == gfx::Primitive::Quads) {
            ++horizontal;
        }
        if (kind == gfx::Primitive::Triangles) {
            ++vertical;
        }
        EXPECT_EQ(binding.texture, 42u);
        for (const auto &vertex : vertices) {
            EXPECT_EQ(vertex.color[0], 90);
            EXPECT_EQ(vertex.color[1], 100);
            EXPECT_EQ(vertex.color[2], 110);
            EXPECT_EQ(vertex.color[3], 60);
        }
    });
    mgCTexture texture;
    texture.tex0.TBP0 = 1234;
    texture.tex0.TW = texture.tex0.TH = 7;
    DrawMenuWakuRect(&texture, {238.0f, 44.0f, 36.0f, 42.0f}, {16, 32, 18, 12}, 60, 90, 100, 110);
    EXPECT_GT(horizontal, 0);
    EXPECT_GT(vertical, 0);
    mgPortSetPrimSink({});
    mgPortSetTextureLookup(nullptr, nullptr);
    mgScreenWidth = saved_width;
    mgScreenHeight = saved_height;
    mgPortResetGs();
}

TEST(MenuCursor, YesNoMouseTintsEachChoiceOnceAndControllerKeepsRetailColor) {
    const auto    previous_pad = GamePad__2;
    const auto    previous_input = InputGetPad(0);
    InputPadState neutral_input;
    InputSetOverride(0, &neutral_input);
    GamePad__2.pad[0].button = 0;
    dc2::test::ScopedGlobalObject<mgDrawManager.render_info> info_owner;
    auto                                                    &info = info_owner.Get();
    dc2::test::ScopedGlobalObject<mgVif1Packet>              packet_owner;
    auto                                                    &packet = packet_owner.Get();
    ClsMes                                                   message;
    short                                                    text[] = {0, 0};
    message.buff = dc2::text::MessageTable::Parse(std::as_bytes(std::span(text)));
    message.fade = 1;
    message.alpha = 128;
    message.font_h = 24;
    message.window_mode = MES_WIN_YESNO;
    int drawn = 0;
    int selected = -1;
    mgPortSetPrimSink([&](gfx::Primitive, std::span<const gfx::Vertex2D> vertices,
                          const gfx::TextureBinding &, const gfx::DrawState &) {
        if (vertices.empty()) {
            return;
        }
        const int choice = drawn++;
        ASSERT_LT(choice, 2);
        EXPECT_NEAR(vertices.front().u, choice == 0 ? 136 : 196, 0.02f);
        EXPECT_FLOAT_EQ(vertices.front().x, message.choice_pos[choice][0]);
        EXPECT_FLOAT_EQ(vertices.front().y, message.choice_pos[choice][1]);
        EXPECT_NEAR(vertices.front().v, 230, 0.02f);
        for (int channel = 0; channel < 3; ++channel) {
            EXPECT_EQ(vertices.front().color[channel], choice == selected ? 164 : 128);
        }
        EXPECT_EQ(vertices.front().color[3], 128);
    });
    const auto draw = [&] {
        drawn = 0;
        message.SetSelectCursorPos({.x = 100, .y = 200, .width = 220, .height = 60});
        RGBAQ_TYPE color{};
        color.r = color.g = color.b = color.a = 128;
        mgCDrawPrim primitive;
        MySetPrim(&primitive, MES_PRIM_SPRITE, 0);
        DrawYesNo(&primitive, message.choice_pos[0][0], message.choice_pos[0][1],
                  message.choice_pos[1][0], message.choice_pos[1][1], &color);
        message.StepSelectCursor(1);
        EXPECT_EQ(drawn, 2);
    };
    MenuMouseEnable(false);
    InputSetScriptedDevices({});
    message.select = 1;
    EXPECT_FALSE(MenuMousePointerVisible());
    draw();
    MenuMouseEnable(true);
    InputSetScriptedDevices({.mouse_dx = 1});
    MenuMouseTake();
    MenuMouseNoteHand({.texture = 123}, {.x = 96, .y = 232, .w = 40, .h = 24});
    ASSERT_TRUE(MenuMousePointerVisible());
    for (int choice = 0; choice < 2; ++choice) {
        message.select = selected = choice;
        draw();
    }
    message.fade = 0.5f;
    selected = -1;
    draw();
    const auto saved_button = GamePad__2.pad[0].button;
    GamePad__2.pad[0].button = PAD_RIGHT;
    message.fade = 1;
    EXPECT_FALSE(MenuMousePointerVisible());
    draw();
    GamePad__2.pad[0].button = saved_button;
    GamePad__2 = previous_pad;
    InputSetOverride(0, &previous_input);
    MenuMouseEnable(false);
    InputSetScriptedDevices({});
    mgPortSetPrimSink({});
    mgPortResetGs();
}

TEST(MenuCursor, ResetReleasesBorrowedMenuStateAndRestoresInactiveModes) {
    CMenuKeyFunc      keys;
    CMenuPosDataForm  form{};
    MENU_INPUTKEY_ARG layout{};
    keys.cursor_form = &form;
    keys.key_arg = &layout;
    keys.cursor = 37;
    keys.top_line = 12;
    keys.now_mode = 7;
    keys.next_mode = 9;
    keys.key_enable = false;
    keys.tex_block[0] = 23;
    keys.Initialize();
    EXPECT_EQ(keys.cursor_form, nullptr);
    EXPECT_EQ(keys.key_arg, nullptr);
    EXPECT_EQ(keys.cursor, 0);
    EXPECT_EQ(keys.top_line, 0);
    EXPECT_EQ(keys.now_mode, -1);
    EXPECT_EQ(keys.next_mode, -1);
    EXPECT_TRUE(keys.key_enable);
    for (const int block : keys.tex_block) {
        EXPECT_EQ(block, -1);
    }
}
