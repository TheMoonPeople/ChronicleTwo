#include <gtest/gtest.h>

#include <algorithm>
#include <memory>

#include "gamepad.hpp"
#include "mainloop.hpp"
#include "menu_mouse.hpp"
#include "menucommon.hpp"
#include "menumain.hpp"
#include "menushop.hpp"
#include "mglib.hpp"
#include "platform/clock.hpp"
#include "platform/input.hpp"
#include "savedata.hpp"

extern CSaveData *PortActiveSaveData asm("MainLoop_ActiveSaveData");

namespace {
class ShopMouse : public testing::Test {
protected:
    CMenuKeyFunc               keys;
    CShopMenu                  menu;
    CShop                      stock;
    CMenuPosDataManage         forms{};
    CMenuPosDataForm           boards[4]{};
    MENUFORMPARTS_TYPE         parts[6]{};
    CMenuKeyFunc              *old_keys = MenuCommonInfo;
    CMenuPosDataManage        *old_forms = MenuPosData;
    CMenuMoveItem             *old_move = MenuMoveItemPtr;
    CGamePad                   old_pad = GamePad__2;
    CMenuPosDataForm          *old_gift = GiftBoxViewForm;
    int                        old_width = mgScreenWidth, old_height = mgScreenHeight;
    float                      old_x = MenuItemBrdUnderBrdPosXY[0], old_y = MenuItemBrdUnderBrdPosXY[1];
    u32                        old_sound = SystemSND_ID;
    CSaveData                 *old_save = PortActiveSaveData;
    std::unique_ptr<CSaveData> save = std::make_unique<CSaveData>();

    void SetUp() override {
        MenuMouseEnable(false);
        InputSetScriptedDevices({});
        mgEndFrame(nullptr);
        MenuMouseTake();
        InputResetBindings();
        mgScreenWidth = 512;
        mgScreenHeight = 480;
        MenuCommonInfo = &keys;
        MenuPosData = &forms;
        MenuMoveItemPtr = nullptr;
        ASSERT_TRUE(save);
        PortActiveSaveData = save.get();
        GamePad__2.key_lock = 0;
        GamePad__2.pad[0].button = GamePad__2.previous_pad[0].button = 0;
        keys.now_mode = MENU_MODE_SHOP;
        SystemSND_ID = static_cast<u32>(-1);
        keys.key_enable = true;
        keys.have_item.item_no = 0;
        menu.mode = 0;
        forms.form = boards;
        forms.form_num = 4;
        char *names[] = {const_cast<char *>("itembrd"), const_cast<char *>("\x95\x69\x95\xA8\x83\x7B\x81\x5B\x83\x68"),
                         const_cast<char *>("\x95\x69\x95\xA8\x83\x8A\x83\x58\x83\x67"), const_cast<char *>("\x94\x84\x94\x83\x83\x7B\x81\x5B\x83\x68")};
        for (int i = 0; i < 4; ++i) {
            boards[i].name = names[i];
            boards[i].draw_flag = 1;
            boards[i].next = i < 3 ? &boards[i + 1] : nullptr;
        }
        boards[0].x = 240;
        boards[0].y = 40;
        boards[1].x = boards[2].x = 20;
        boards[1].y = boards[2].y = 40;
        boards[3].x = 100;
        boards[3].y = 100;
        boards[3].parts = parts;
        boards[3].parts_num = 6;
        char *part_names[] = {const_cast<char *>("\x90\x94\x94\xC2\x32"), const_cast<char *>("NO"), const_cast<char *>("\x90\x94"),
                              const_cast<char *>("\x96\xEE\x88\xF3\x8F\xE3"), const_cast<char *>("\x96\xEE\x88\xF3\x89\xBA"), const_cast<char *>("0")};
        int   px[] = {40, 140, 40, 40, 40, 0};
        int   py[] = {100, 100, 100, 80, 130, 100};
        for (int i = 0; i < 6; ++i) {
            parts[i].name = part_names[i];
            parts[i].dtype = MENUFORMPARTS_DTYPE_FUNCINFO;
            parts[i].draw_flag = 1;
            parts[i].x = px[i];
            parts[i].y = py[i];
            parts[i].w = 40;
            parts[i].h = 20;
        }
        parts[2].w = parts[2].h = parts[5].w = parts[5].h = 0;
        menu.AttachForm();
        stock.CheckSyojiHin(); // Registers the same stock object used by the retail initialization path.
        stock.item_num = 20;
        MenuItemBrdUnderBrdPosXY[0] = 256;
        MenuItemBrdUnderBrdPosXY[1] = 60;
        ClockSetUnbounded(true);
        MenuMouseEnable(true);
    }

    void TearDown() override {
        MenuMouseEnable(false);
        InputSetScriptedDevices({});
        mgEndFrame(nullptr);
        MenuMouseTake();
        InputResetBindings();
        MenuCommonInfo = old_keys;
        MenuPosData = old_forms;
        MenuMoveItemPtr = old_move;
        GiftBoxViewForm = old_gift;
        GamePad__2 = old_pad;
        SystemSND_ID = old_sound;
        PortActiveSaveData = old_save;
        mgScreenWidth = old_width;
        mgScreenHeight = old_height;
        MenuItemBrdUnderBrdPosXY[0] = old_x;
        MenuItemBrdUnderBrdPosXY[1] = old_y;
    }

    void At(float x, float y, unsigned buttons = 0, float wheel = 0) {
        const auto pos = MenuMouseTake();
        InputSetScriptedDevices({.mouse_buttons = buttons, .mouse_dx = x - pos.x, .mouse_dy = y - pos.y, .mouse_wheel = wheel});
        mgEndFrame(nullptr);
        keys.SelDataInit();
        keys.CheckSelectKey();
    }

    // At, then the cursor part of the retail CShopMenu::KeyStep (ps2/src/menushop.cpp:808-855, :870-871, :918-981),
    // which reads its cursors after the mouse hook. The whole step needs the shop's messages and textures.
    void Step(float x, float y, unsigned buttons = 0, float wheel = 0) {
        At(x, y, buttons, wheel);
        const int lr = keys.CheckLRKey();
        switch (menu.key_arg_no) {
            case SHOP_MENU_MODE_BUY_LIST: {
                const int old_pos = menu.list_pos;
                const int old_top = menu.list_top;
                const int moved = MenuListKeyCheck(lr, &menu.list_pos, &menu.list_top, stock.item_num, SHOP_LIST_LINE, 0, 0);
                if (moved || old_pos != menu.list_pos || old_top != menu.list_top) {
                    MenuSePlay(SYSTEM_SE_CURSOR);
                }
                break;
            }
            case SHOP_MENU_MODE_BAG:
                MenuItemBrdKey(lr, &menu.bag_pos, &menu.bag_top, ITEM_BOARD_MAIN); // Retail's own sound.
                break;
            case SHOP_MENU_MODE_BUY_NUM:
            case SHOP_MENU_MODE_SELL_NUM: {
                const int old_cursor = menu.num_cursor;
                const int old_num = menu.num;
                if (menu.num_cursor == 0) {
                    menu.num += (lr & MENU_SELECT_KEY_UP ? 1 : 0) - (lr & MENU_SELECT_KEY_DOWN ? 1 : 0);
                }
                if (menu.num <= 0) {
                    menu.num = 1;
                }
                menu.num = std::min(menu.num, menu.num_max);
                if (old_cursor != menu.num_cursor || old_num != menu.num) {
                    MenuSePlay(SYSTEM_SE_CURSOR);
                }
                break;
            }
            default:
                break;
        }
    }
};

TEST_F(ShopMouse, HoverSelectsBothPanesBeforeClickConfirms) {
    At(60, 136);
    EXPECT_EQ(menu.list_pos, 1);
    EXPECT_EQ(menu.key_arg_no, SHOP_MENU_MODE_BUY_LIST);
    EXPECT_EQ(MenuMouseButtons(), 0);
    At(320, 170, 1);
    EXPECT_EQ(menu.bag_pos, 13);
    EXPECT_EQ(menu.key_arg_no, SHOP_MENU_MODE_BAG);
    EXPECT_TRUE(GamePad__2.Down(PAD_CROSS));
    At(60, 180);
    EXPECT_EQ(menu.list_pos, 2);
    EXPECT_EQ(menu.key_arg_no, SHOP_MENU_MODE_BUY_LIST);
}

TEST_F(ShopMouse, WheelScrollsTheLongGoodsListARowAndTakesTheRowUnderThePointer) {
    At(60, 100);
    EXPECT_EQ(menu.list_pos, 0);
    At(60, 100, 0, -1);
    EXPECT_EQ(menu.key_arg_no, SHOP_MENU_MODE_BUY_LIST);
    EXPECT_EQ(menu.list_top, 1);
    EXPECT_EQ(menu.list_pos, 1); // The row that comes under the pointer.
    EXPECT_EQ(keys.CheckLRKey(), 0);
    // The retail key step keeps the new scroll.
    MenuListKeyCheck(keys.CheckLRKey(), &menu.list_pos, &menu.list_top, stock.item_num, SHOP_LIST_LINE, 0, 0);
    EXPECT_EQ(menu.list_top, 1);
    EXPECT_EQ(menu.list_pos, 1);
    // Row 0 is still drawn under the pointer while the list eases; it is sliding out.
    At(61, 100);
    EXPECT_EQ(menu.list_pos, 1);
    boards[2].y = 40 - 44; // The list at rest.
    At(60, 150);
    EXPECT_EQ(menu.list_pos, 2);
    At(60, 150, 0, 3);
    EXPECT_EQ(menu.list_top, 0); // Stops at the top.
    EXPECT_EQ(menu.list_pos, 1);
    menu.list_top = stock.item_num - SHOP_LIST_LINE;
    menu.list_pos = stock.item_num - 1;
    At(60, 300, 0, -1);
    EXPECT_EQ(menu.list_top, stock.item_num - SHOP_LIST_LINE); // And at the bottom, where it moves nothing.
    EXPECT_EQ(menu.list_pos, stock.item_num - 1);
    EXPECT_EQ(keys.CheckLRKey(), 0);
}

TEST_F(ShopMouse, WheelScrollsTheBagARowAndTakesTheCellThatSettlesUnderThePointer) {
    const auto saved_manner = MenuItemBrdCalcManner;
    MenuItemBrdCalcManner = MENU_ITEM_BRD_CALC_EASE;
    const int count = GetNowBagMax(ITEM_BOARD_MAIN);
    ASSERT_GT(count, 30);
    MenuItemBrdUnderBrdPosXY[1] = 66; // The board's resting origin at top line 0.
    At(300, 80);
    EXPECT_EQ(menu.key_arg_no, SHOP_MENU_MODE_BAG);
    EXPECT_EQ(menu.bag_pos, 1);
    // The pointer stays on the top row while the wheel turns.
    At(300, 80, 0, -1);
    EXPECT_EQ(menu.bag_top, 1);
    EXPECT_EQ(menu.bag_pos, 7);
    EXPECT_EQ(keys.CheckLRKey(), 0);
    EXPECT_FLOAT_EQ(MenuItemBrdUnderBrdPosXY[1], 66); // Not snapped by the mouse.
    MenuItemBrdKey(keys.CheckLRKey(), &menu.bag_pos, &menu.bag_top, ITEM_BOARD_MAIN);
    EXPECT_EQ(menu.bag_top, 1);
    EXPECT_EQ(menu.bag_pos, 7);
    Func_MenuItemBrdPosStep(menu.bag_top);
    EXPECT_LT(MenuItemBrdUnderBrdPosXY[1], 66); // The retail board eases like a D-pad scroll.
    EXPECT_GT(MenuItemBrdUnderBrdPosXY[1], 16);
    MenuItemBrdUnderBrdPosXY[1] = 50;
    At(301, 62); // Cell 1 is still drawn here, sliding out.
    EXPECT_EQ(menu.bag_pos, 7);
    At(341, 110);
    EXPECT_EQ(menu.bag_pos, 8);
    At(341, 110, 0, -2);
    EXPECT_EQ(menu.bag_top, 3);
    EXPECT_EQ(menu.bag_pos, 20);
    At(341, 110, 0, 9);
    EXPECT_EQ(menu.bag_top, 0);
    EXPECT_EQ(menu.bag_pos, 2);
    MenuItemBrdCalcManner = saved_manner;
}

TEST_F(ShopMouse, WheelRoutesToThePaneUnderThePointer) {
    menu.key_arg_no = SHOP_MENU_MODE_BAG;
    At(60, 100, 0, -1);
    EXPECT_EQ(menu.key_arg_no, SHOP_MENU_MODE_BUY_LIST);
    EXPECT_EQ(menu.list_top, 1);
    At(300, 80, 0, -1);
    EXPECT_EQ(menu.key_arg_no, SHOP_MENU_MODE_BAG);
    EXPECT_EQ(menu.bag_top, 1);
    EXPECT_EQ(menu.list_top, 1);
    At(510, 470, 0, -1);
    EXPECT_EQ(menu.bag_top, 1);
    EXPECT_EQ(MenuMouseButtons(), 0);
}

TEST_F(ShopMouse, WheelOverAListThatFitsMovesItsCursorThroughRetailKeys) {
    stock.item_num = 4;
    At(60, 100);
    At(60, 100, 0, -1);
    EXPECT_EQ(menu.list_top, 0);
    EXPECT_EQ(keys.CheckLRKey(), MENU_SELECT_KEY_DOWN);
    MenuListKeyCheck(keys.select_key, &menu.list_pos, &menu.list_top, stock.item_num, SHOP_LIST_LINE, 0, 0);
    EXPECT_EQ(menu.list_pos, 1);
}

TEST_F(ShopMouse, WheelOverAnEmptyGoodsListKeepsTheBagInFront) {
    // Retail moves to the bag when the stock runs out (an exhausted Donny reward list) and will not return.
    stock.item_num = 0;
    menu.key_arg_no = SHOP_MENU_MODE_BAG;
    menu.bag_pos = 7;
    menu.list_pos = menu.list_top = 0;
    At(60, 100);
    for (float wheel : {-1.0f, 1.0f, -1.0f}) {
        At(60, 100, 0, wheel);
        EXPECT_EQ(menu.key_arg_no, SHOP_MENU_MODE_BAG);
        EXPECT_EQ(menu.bag_pos, 7);
        EXPECT_EQ(menu.list_pos, 0);
        EXPECT_EQ(menu.list_top, 0);
        EXPECT_EQ(MenuMouseButtons(), 0);
        EXPECT_EQ(keys.CheckLRKey(), 0);
    }
    At(60, 150, 1);
    EXPECT_EQ(menu.key_arg_no, SHOP_MENU_MODE_BAG);
    EXPECT_EQ(MenuMouseButtons(), 0);
}

TEST_F(ShopMouse, ClickWithAWheelNotchConfirmsTheRowItWasPressedOn) {
    At(60, 150);
    At(60, 150, 1, -1);
    EXPECT_EQ(menu.list_top, 0);
    EXPECT_EQ(menu.list_pos, 1);
    EXPECT_EQ(MenuMouseButtons(), PAD_CROSS);
}

TEST_F(ShopMouse, CursorMovesSoundOnceAndSynthesizedKeysLeaveTheSoundToRetail) {
    const int sounds = MenuMouseCursorSounds();
    At(60, 150);
    EXPECT_EQ(menu.list_pos, 1);
    EXPECT_EQ(MenuMouseCursorSounds(), sounds + 1);
    At(61, 150); // The same row.
    EXPECT_EQ(MenuMouseCursorSounds(), sounds + 1);
    At(320, 170);
    EXPECT_EQ(menu.key_arg_no, SHOP_MENU_MODE_BAG);
    EXPECT_EQ(MenuMouseCursorSounds(), sounds + 2);
    At(320, 170); // Holding still.
    EXPECT_EQ(MenuMouseCursorSounds(), sounds + 2);
    At(320, 170, 0, -1);
    EXPECT_EQ(menu.bag_pos, 19); // A scroll that brings another cell under the pointer.
    EXPECT_EQ(MenuMouseCursorSounds(), sounds + 3);
    // A notch over a list that fits presses Down, and the retail key step sounds the move.
    stock.item_num = 4;
    At(60, 150, 0, -1);
    EXPECT_EQ(menu.key_arg_no, SHOP_MENU_MODE_BUY_LIST);
    EXPECT_EQ(keys.CheckLRKey(), MENU_SELECT_KEY_DOWN);
    EXPECT_EQ(MenuMouseCursorSounds(), sounds + 3);
    menu.key_arg_no = SHOP_MENU_MODE_BUY_NUM;
    At(250, 210);
    EXPECT_EQ(menu.num_cursor, 1);
    EXPECT_EQ(MenuMouseCursorSounds(), sounds + 4);
}

TEST_F(ShopMouse, WheelIntoAShortGoodsListSoundsOncePerChangeEvenAtItsEnds) {
    stock.item_num = 4;
    Step(60, 100); // Onto the list's first row.
    ASSERT_EQ(menu.key_arg_no, SHOP_MENU_MODE_BUY_LIST);
    ASSERT_EQ(menu.list_pos, 0);
    // Back to the bag with the keys; Up then switches to the list but stops at its first entry.
    menu.key_arg_no = SHOP_MENU_MODE_BAG;
    int sounds = MenuCursorSounds();
    Step(60, 100, 0, 1);
    EXPECT_EQ(menu.key_arg_no, SHOP_MENU_MODE_BUY_LIST);
    EXPECT_EQ(menu.list_pos, 0);
    EXPECT_EQ(MenuCursorSounds(), sounds + 1);
    // Down switches and moves: retail's one sound.
    menu.key_arg_no = SHOP_MENU_MODE_BAG;
    Step(60, 100, 0, -1);
    EXPECT_EQ(menu.list_pos, 1);
    EXPECT_EQ(MenuCursorSounds(), sounds + 2);
    Step(60, 100, 0, -1);
    Step(60, 100, 0, -1);
    EXPECT_EQ(menu.list_pos, 3);
    EXPECT_EQ(MenuCursorSounds(), sounds + 4);
    // At the last entry nothing changes and nothing sounds.
    Step(60, 100, 0, -1);
    EXPECT_EQ(menu.list_pos, 3);
    EXPECT_EQ(MenuCursorSounds(), sounds + 4);
    sounds = MenuCursorSounds();
    // A scroll pane switch at the long list's end sounds once too.
    stock.item_num = 20;
    menu.key_arg_no = SHOP_MENU_MODE_BAG;
    menu.list_pos = menu.list_top = 0;
    Step(60, 100, 0, 1);
    EXPECT_EQ(menu.key_arg_no, SHOP_MENU_MODE_BUY_LIST);
    EXPECT_EQ(menu.list_top, 0);
    EXPECT_EQ(MenuCursorSounds(), sounds + 1);
}

TEST_F(ShopMouse, QuantityWheelFromQuitSoundsOnceEvenAtEachLimit) {
    for (int mode : {SHOP_MENU_MODE_BUY_NUM, SHOP_MENU_MODE_SELL_NUM}) {
        menu.key_arg_no = mode;
        menu.num_max = 10;
        int sounds = MenuCursorSounds();
        // Quit to the number, whose quantity retail clamps back: the cursor change still sounds, once.
        menu.num = 1;
        menu.num_cursor = 1;
        Step(160, 210, 0, -1);
        EXPECT_EQ(menu.num_cursor, 0);
        EXPECT_EQ(menu.num, 1);
        EXPECT_EQ(MenuCursorSounds(), sounds + 1);
        menu.num = 10;
        menu.num_cursor = 1;
        Step(160, 210, 0, 1);
        EXPECT_EQ(menu.num, 10);
        EXPECT_EQ(MenuCursorSounds(), sounds + 2);
        // Already on the number at a limit: nothing changes.
        Step(160, 210, 0, 1);
        EXPECT_EQ(MenuCursorSounds(), sounds + 2);
        // A quantity that moves as the cursor leaves Quit: retail's one sound.
        menu.num = 5;
        menu.num_cursor = 1;
        Step(160, 210, 0, 1);
        EXPECT_EQ(menu.num_cursor, 0);
        EXPECT_EQ(menu.num, 6);
        EXPECT_EQ(MenuCursorSounds(), sounds + 3);
        Step(160, 210, 0, -1);
        EXPECT_EQ(menu.num, 5);
        EXPECT_EQ(MenuCursorSounds(), sounds + 4);
    }
}

TEST_F(ShopMouse, QuantityWheelUsesRetailDirectionsAtBothLimitsInBuyAndSell) {
    for (int mode : {SHOP_MENU_MODE_BUY_NUM, SHOP_MENU_MODE_SELL_NUM}) {
        menu.key_arg_no = mode;
        menu.num_max = 10;
        menu.num = 1;
        menu.num_cursor = 1;
        At(160, 210, 0, -1);
        EXPECT_EQ(menu.num_cursor, 0);
        EXPECT_EQ(keys.CheckLRKey(), MENU_SELECT_KEY_DOWN);
        EXPECT_EQ(menu.num, 1); // Retail KeyStep, not the adapter, owns the clamp.
        menu.num = 10;
        At(160, 210, 0, 1);
        EXPECT_EQ(keys.CheckLRKey(), MENU_SELECT_KEY_UP);
        EXPECT_EQ(menu.num, 10);
    }
}

TEST_F(ShopMouse, QuantityNumberQuitAndArrowClicksAreDistinct) {
    menu.key_arg_no = SHOP_MENU_MODE_BUY_NUM;
    At(250, 210);
    EXPECT_EQ(menu.num_cursor, 1);
    At(160, 210, 1);
    EXPECT_EQ(menu.num_cursor, 0);
    EXPECT_EQ(MenuMouseButtons(), PAD_CROSS);
    At(160, 185);
    At(160, 185, 1);
    EXPECT_EQ(MenuMouseButtons(), PAD_UP);
    At(160, 235);
    At(160, 235, 1);
    EXPECT_EQ(MenuMouseButtons(), PAD_DOWN);
    At(250, 210);
    At(250, 210, 1);
    EXPECT_EQ(menu.num_cursor, 1);
    EXPECT_EQ(MenuMouseButtons(), PAD_CROSS);
}

TEST_F(ShopMouse, RightClickCancelsEveryShopPage) {
    for (int page = 0; page < 8; ++page) {
        menu.key_arg_no = page;
        At(500, 400);
        At(500, 400, 2);
        EXPECT_EQ(MenuMouseButtons(), PAD_CIRCLE);
    }
}

TEST_F(ShopMouse, IdleLockedAndControllerInputPreserveRetailSelection) {
    At(60, 136);
    menu.list_pos = 5;
    At(60, 136);
    EXPECT_EQ(menu.list_pos, 5);
    keys.key_enable = false;
    At(320, 170, 1);
    EXPECT_EQ(menu.key_arg_no, SHOP_MENU_MODE_BUY_LIST);
    EXPECT_EQ(MenuMouseButtons(), 0);
    keys.key_enable = true;
    GamePad__2.pad[0].button = PAD_DOWN;
    At(320, 170);
    EXPECT_EQ(menu.key_arg_no, SHOP_MENU_MODE_BUY_LIST);
    EXPECT_EQ(MenuMouseButtons(), 0);
}

TEST_F(ShopMouse, CarryingItemCannotSwitchToGoodsAndOutsideClicksCannotConfirm) {
    menu.key_arg_no = SHOP_MENU_MODE_BAG;
    keys.have_item.item_no = 1;
    At(60, 136, 1);
    EXPECT_EQ(menu.key_arg_no, SHOP_MENU_MODE_BAG);
    EXPECT_EQ(MenuMouseButtons(), 0);
    At(510, 470);
    At(510, 470, 1);
    EXPECT_EQ(MenuMouseButtons(), 0);
}
} // namespace
