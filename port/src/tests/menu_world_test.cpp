#include <gtest/gtest.h>

#include <cstring>

#include "menu_world.hpp"
#include "menudraw.hpp"
#include "menudraw_port.hpp"
#include "menumain.hpp"
#include "menusys.hpp"
#include "mglib.hpp"

// Menus other than the town and dungeon main menus open at once, and nothing of the Item page changes.
TEST(MenuWorld, OtherMenusOpenUnchanged) {
    MENU_INIT_ARG arg{};
    arg.open_type = MENU_OPEN_INVENT;
    EXPECT_FALSE(menuworld::HoldMenuInit(&arg));
    EXPECT_FALSE(menuworld::HoldMenuInit(nullptr));
    EXPECT_FALSE(menuworld::Framing());
    EXPECT_FALSE(menuworld::ItemBackdrop());

    const menuworld::ItemDrawScope scope;
    EXPECT_FALSE(menuworld::FillWithBackdrop());
    EXPECT_FALSE(menuworld::SelectionAnchor().has_value());
    EXPECT_FLOAT_EQ(menuworld::RetailPointerX(123.5f), 123.5f);
}

TEST(MenuWorld, ItemPanelsKeepTheirSidesThroughoutEntryAndExit) {
    const int saved_width = mgScreenWidth;
    mgScreenWidth = 512;
    CMenuPosDataForm      board{};
    CMenuPosDataForm      character{};
    CMenuPosDataForm      money{};
    CMenuPosDataForm      auxiliary{};
    MENU_FORM_ACTION_MOVE board_move{};
    MENU_FORM_ACTION_MOVE character_move{};
    MENU_FORM_ACTION_MOVE auxiliary_move{};
    MENU_FORM_ACTION      board_action{};
    MENU_FORM_ACTION      character_action{};
    MENU_FORM_ACTION      auxiliary_action{};
    std::memcpy(board_action.name, "\x92\x86\x82\xD6", 5);
    std::memcpy(character_action.name, "\x92\x86\x82\xD6", 5);
    std::memcpy(auxiliary_action.name, "\x92\x86\x82\xD6", 5);
    board_move.x = 226.0f;
    character_move.x = 7.0f;
    auxiliary_move.x = 320.0f;
    board_action.move = &board_move;
    character_action.move = &character_move;
    auxiliary_action.move = &auxiliary_move;
    board.action = &board_action;
    board.action_num = 1;
    character.action = &character_action;
    character.action_num = 1;
    auxiliary.action = &auxiliary_action;
    auxiliary.action_num = 1;

    auto *saved_board = class_menu_item_info.item_board_form;
    auto *saved_money = class_menu_item_info.money_form;
    auto *saved_view = class_menu_item_info.view_form[0];
    class_menu_item_info.item_board_form = &board;
    class_menu_item_info.money_form = &money;
    class_menu_item_info.view_form[0] = &character;

    for (float x : {-260.0f, -80.0f, 7.0f, 226.0f, 470.0f, 530.0f}) {
        board.x = x;
        character.x = x;
        money.x = x;
        auxiliary.x = x;
        EXPECT_FLOAT_EQ(menuworld::ItemPanelSplit(&board), 224.0f);
        EXPECT_EQ(menuworld::ItemPanelSide(board, 224.0f), 1);
        EXPECT_EQ(menuworld::ItemPanelSide(character, 224.0f), -1);
        EXPECT_EQ(menuworld::ItemPanelSide(money, 224.0f), 1);
        EXPECT_EQ(menuworld::ItemPanelSide(auxiliary, 224.0f), 1);
    }

    class_menu_item_info.item_board_form = saved_board;
    class_menu_item_info.money_form = saved_money;
    class_menu_item_info.view_form[0] = saved_view;
    mgScreenWidth = saved_width;
}

TEST(MenuWorld, ReturningMenuChromeKeepsCanonicalCoordinates) {
    CMenuPosDataForm form{};
    for (const char *name : {"areaboard", "timeboard", "msg1", "mi00", "mi0", "mi2", "mi9"}) {
        form.name = const_cast<char *>(name);
        EXPECT_TRUE(menuworld::RootChromeUnanchored(form)) << name;
    }
    for (const char *name : {"itembrd", "moneybrd", "form_view00", "msg0", "cursor0"}) {
        form.name = const_cast<char *>(name);
        EXPECT_FALSE(menuworld::RootChromeUnanchored(form)) << name;
    }
}

TEST(MenuWorld, BackdropDissolvesThroughoutTheNativeReturnAndFinishesBeforeThePageSwitch) {
    const int saved_mode = class_menu_item_info.mode;
    class_menu_item_info.mode = MENU_ASK_MODE_NONE;
    MenuMainFrameModeSet(MENU_MAIN_FRAME_SLIDE_LEFT, true);
    for (int tick = 0; tick < 30 && !GetMenuMainFrameEndFlag(); ++tick) {
        MenuMainFrameStep();
        EXPECT_EQ(menuworld::ItemBackdropAlpha(), 128);
    }
    ASSERT_TRUE(GetMenuMainFrameEndFlag());
    EXPECT_FLOAT_EQ(GetMenuMainFrameLeftTopPos(0)[0], -192.0f);

    class_menu_item_info.mode = MENU_ASK_MODE_CLOSE;
    MenuMainFrameModeSet(MENU_MAIN_FRAME_SLIDE_BACK, true);
    int previous_alpha = menuworld::ItemBackdropAlpha();
    EXPECT_EQ(previous_alpha, 128);
    int blended_frames = 0;
    for (int tick = 0; tick < 30 && !GetMenuMainFrameEndFlag(); ++tick) {
        MenuMainFrameStep();
        const int alpha = menuworld::ItemBackdropAlpha();
        EXPECT_LE(alpha, previous_alpha);
        EXPECT_GE(alpha, 0);
        if (alpha > 0 && alpha < 128) {
            ++blended_frames;
        }
        previous_alpha = alpha;
    }
    EXPECT_TRUE(GetMenuMainFrameEndFlag());
    EXPECT_EQ(menuworld::ItemBackdropAlpha(), 0);
    EXPECT_GE(blended_frames, 12);

    // Reopening Items shows its entire world even while the frame remains at the root position.
    class_menu_item_info.mode = MENU_ASK_MODE_OPEN;
    EXPECT_EQ(menuworld::ItemBackdropAlpha(), 128);
    class_menu_item_info.mode = saved_mode;
}

TEST(MenuCharacterLayout, EnglishPalCentralBackingMatchesTheOtherPalBoards) {
    MENUFORMPARTS_TYPE parts[3]{};
    parts[0].name = const_cast<char *>("fcb1");
    parts[0].x = 178.0f;
    parts[0].y = 158.0f;
    parts[0].w = 100.0f;
    parts[0].h = 100.0f;
    parts[1].name = const_cast<char *>("fc1");
    parts[1].y = 181.0f;
    parts[1].h = 112.0f;
    parts[2].name = const_cast<char *>("fcb0");
    parts[2].h = 121.0f;
    CMenuPosDataForm form{};
    form.name = const_cast<char *>("chr_bg");
    form.parts = parts;
    form.parts_num = 3;
    MenuAlignCharacterSlot(form);
    EXPECT_FLOAT_EQ(parts[0].x, 178.0f);
    EXPECT_FLOAT_EQ(parts[0].y, 181.0f);
    EXPECT_FLOAT_EQ(parts[0].w, 100.0f);
    EXPECT_FLOAT_EQ(parts[0].h, 121.0f);
    EXPECT_FLOAT_EQ(parts[1].h, 112.0f);
    MenuAlignCharacterSlot(form);
    EXPECT_FLOAT_EQ(parts[0].y, 181.0f);
    EXPECT_FLOAT_EQ(parts[0].h, 121.0f);

    // The Japanese board's portrait and backing both retain their original vertical scale.
    parts[0].y = parts[1].y = 158.0f;
    parts[0].h = 100.0f;
    parts[2].h = 106.0f;
    MenuAlignCharacterSlot(form);
    EXPECT_FLOAT_EQ(parts[0].y, 158.0f);
    EXPECT_FLOAT_EQ(parts[0].h, 100.0f);
}
