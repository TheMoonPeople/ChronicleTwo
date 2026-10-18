#include "menu_mouse_shop.hpp"

#include <math.h>

#include <algorithm>
#include <cmath>

#include "gamepad.hpp"
#include "mainloop.hpp"
#include "menu_mouse.hpp"
#include "menu_mouse_item.hpp"
#include "menumain.hpp"
#include "menushop.hpp"

namespace {
CShopMenu          *shop_menu = nullptr;
CShop              *shop_stock = nullptr;
CMenuPosDataManage *shop_forms = nullptr;

void MenuMouseShopUpdate(CShopMenu &menu, CMenuKeyFunc &keys, int goods) {
    const auto &mouse = MenuMouseTake();
    const int   shared_buttons = MenuMouseButtons();
    MenuMouseSetButtons(0); // The shop owns this tick's mouse actions.
    if (!mouse.pointing || !keys.key_enable || GamePad__2.key_lock || menu_debug_flag ||
        menu.mode != MENU_ASK_MODE_NONE || (MenuMoveItemPtr && MenuMoveItemPtr->move_on)) {
        return;
    }
    if (mouse.clicked & 2) {
        MenuMouseSetButtons(PAD_CIRCLE);
        return;
    }
    const bool choose = mouse.wheel == 0 && (mouse.moved || (mouse.clicked & 1));
    int        buttons = 0;
    if (menu.key_arg_no == SHOP_MENU_MODE_BUY_LIST || menu.key_arg_no == SHOP_MENU_MODE_BAG) {
        auto     *board = MenuPosData->GetFormInfo("itembrd");
        const int bag_count = GetNowBagMax(ITEM_BOARD_MAIN);
        const int bag = menumouse::BagHit({.x = mouse.x, .y = mouse.y}, board, bag_count);
        int       row = -1;
        if (menu.item_brd && menu.item_brd->draw_flag && menu.item_list && menu.item_list->draw_flag) {
            float x = NAN;
            float y = NAN;
            float clip_x = NAN;
            float clip_y = NAN;
            menu.item_list->GetPutPosXY(nullptr, x, y);
            menu.item_brd->GetPutPosXY(nullptr, clip_x, clip_y);
            if (MenuMouseRect{.x = clip_x + 14, .y = clip_y + 44, .w = 184, .h = SHOP_LIST_LINE * 44}.Contains(mouse.x, mouse.y) &&
                mouse.y >= y + 44) {
                const int hit = static_cast<int>((mouse.y - y - 44) / 44);
                if (hit < goods) {
                    row = hit;
                }
            }
        }
        if (choose && row >= 0 && keys.have_item.item_no <= 0) {
            menu.key_arg_no = SHOP_MENU_MODE_BUY_LIST;
            menu.list_pos = row;
        } else if (choose && bag >= 0) {
            menu.key_arg_no = SHOP_MENU_MODE_BAG;
            menu.bag_pos = bag;
        }
        if (std::isfinite(mouse.wheel) && mouse.wheel != 0) {
            const int direction = mouse.wheel > 0 ? PAD_UP : PAD_DOWN;
            if (row >= 0 && keys.have_item.item_no <= 0) {
                menu.key_arg_no = SHOP_MENU_MODE_BUY_LIST;
                buttons |= direction;
            } else if (bag >= 0) {
                menu.key_arg_no = SHOP_MENU_MODE_BAG;
                buttons |= direction;
            }
        }
        if ((mouse.clicked & 1) && (bag >= 0 || (row >= 0 && keys.have_item.item_no <= 0))) {
            buttons |= PAD_CROSS;
        }
    } else if (menu.key_arg_no == SHOP_MENU_MODE_BUY_NUM || menu.key_arg_no == SHOP_MENU_MODE_SELL_NUM) {
        const auto number = MenuMousePart(menu.trade_brd, "\x90\x94");
        const auto up = MenuMousePart(menu.trade_brd, "\x96\xEE\x88\xF3\x8F\xE3");
        const auto down = MenuMousePart(menu.trade_brd, "\x96\xEE\x88\xF3\x89\xBA");
        if (menu.trade_brd && menu.trade_brd->draw_flag) {
            // The number itself is a zero-sized digit anchor. Hit its three
            // drawn frame pieces and the localized Quit button instead.
            const bool on_number = number.Contains(mouse.x, mouse.y) || up.Contains(mouse.x, mouse.y) ||
                                   down.Contains(mouse.x, mouse.y) ||
                                   MenuMousePart(menu.trade_brd, "\x90\x94\x94\xC2\x31").Contains(mouse.x, mouse.y) ||
                                   MenuMousePart(menu.trade_brd, "\x90\x94\x94\xC2\x32").Contains(mouse.x, mouse.y) ||
                                   MenuMousePart(menu.trade_brd, "\x90\x94\x94\xC2\x33").Contains(mouse.x, mouse.y);
            const bool on_quit = MenuMousePart(menu.trade_brd, "NO").Contains(mouse.x, mouse.y);
            if (choose && on_number) {
                menu.num_cursor = 0;
            } else if (choose && on_quit) {
                menu.num_cursor = 1;
            }
            if (std::isfinite(mouse.wheel) && mouse.wheel != 0) {
                menu.num_cursor = 0;
                buttons = mouse.wheel > 0 ? PAD_UP : PAD_DOWN;
            } else if (mouse.clicked & 1) {
                if (up.Contains(mouse.x, mouse.y)) {
                    buttons = PAD_UP;
                } else if (down.Contains(mouse.x, mouse.y)) {
                    buttons = PAD_DOWN;
                } else if (on_number || on_quit) {
                    buttons = PAD_CROSS;
                }
            }
        }
    } else {
        // Yes/No windows retain the shared drawn-choice navigation.
        buttons = shared_buttons;
    }
    MenuMouseSetButtons(buttons);
}
} // namespace

void MenuMouseShopTick(CMenuKeyFunc &keys) {
    if (&keys == MenuCommonInfo && keys.now_mode == MENU_MODE_SHOP && shop_menu && shop_stock && shop_forms == MenuPosData) {
        MenuMouseShopUpdate(*shop_menu, keys, shop_stock->item_num);
    }
}

PORT_OVERRIDE void CShop::CheckSyojiHin() {
    shop_stock = this;
    auto *user = GetUserDataMan();
    for (int i = 0; i < item_num; ++i) {
        have_num[i] = item_no[i] > 0 ? user->GetNumSameItem(item_no[i]) : 0;
    }
}

PORT_OVERRIDE void CShopMenu::AttachForm() {
    if (shop_menu != this || shop_forms != MenuPosData) {
        shop_stock = nullptr;
    }
    shop_menu = this;
    shop_forms = MenuPosData;
    money_brd = MenuPosData->GetFormInfo("moneybrd");
    trade_brd = MenuPosData->GetFormInfo("\x94\x84\x94\x83\x83\x7B\x81\x5B\x83\x68");
    shop_name_brd = MenuPosData->GetFormInfo("\x93\x58\x96\xBC\x83\x7B\x81\x5B\x83\x68");
    item_brd = MenuPosData->GetFormInfo("\x95\x69\x95\xA8\x83\x7B\x81\x5B\x83\x68");
    item_list = MenuPosData->GetFormInfo("\x95\x69\x95\xA8\x83\x8A\x83\x58\x83\x67");
    exp_brd = MenuPosData->GetFormInfo("EXPBRD");
    medal_brd = MenuPosData->GetFormInfo("MEDALBRD");
    if (item_list) {
        item_list->GetPutPosXY(nullptr, list_x, list_y);
        list_y += 48;
    }
    GiftBoxViewForm = MenuPosData->GetFormInfo("giftview");
}
