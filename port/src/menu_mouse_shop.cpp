#include "menu_mouse_shop.hpp"

#include <math.h>

#include <algorithm>
#include <cmath>

#include "gamepad.hpp"
#include "mainloop.hpp"
#include "menu_mouse.hpp"
#include "menu_mouse_item.hpp"
#include "menucommon.hpp"
#include "menumain.hpp"
#include "menushop.hpp"
#include "menusys.hpp"

namespace {
CShopMenu          *shop_menu = nullptr;
CShop              *shop_stock = nullptr;
CMenuPosDataManage *shop_forms = nullptr;

struct ShopList {
    bool over = false; // The pointer is inside the list's window.
    int  row = -1;     // The drawn goods row under the pointer, if it stays in the window the list eases to.
    int  shown = -1;   // The window row under the pointer once the list rests at its scroll.
};

ShopList ListHit(const CShopMenu &menu, const MenuMouseSample &mouse, int goods) {
    ShopList hit;
    if (!menu.item_brd || !menu.item_brd->draw_flag || !menu.item_list || !menu.item_list->draw_flag) {
        return hit;
    }
    float x = NAN;
    float y = NAN;
    float clip_x = NAN;
    float clip_y = NAN;
    menu.item_list->GetPutPosXY(nullptr, x, y);
    menu.item_brd->GetPutPosXY(nullptr, clip_x, clip_y);
    const MenuMouseRect clip{.x = clip_x + 14, .y = clip_y + 44, .w = 184, .h = SHOP_LIST_LINE * 44};
    if (!clip.Contains(mouse.x, mouse.y)) {
        return hit;
    }
    hit.over = true;
    hit.shown = static_cast<int>((mouse.y - clip.y) / 44);
    if (mouse.y >= y + 44) {
        const int row = static_cast<int>((mouse.y - y - 44) / 44);
        // A row still sliding out of the eased list is no longer selectable.
        if (row < goods && row >= menu.list_top && row < menu.list_top + SHOP_LIST_LINE) {
            hit.row = row;
        }
    }
    return hit;
}

// The cursor of the shop page in front: a goods row, a bag cell or the quantity board's choice.
int ShopCursor(const CShopMenu &menu) {
    switch (menu.key_arg_no) {
        case SHOP_MENU_MODE_BUY_LIST:
            return menu.list_pos;
        case SHOP_MENU_MODE_BAG:
            return menu.bag_pos;
        case SHOP_MENU_MODE_BUY_NUM:
        case SHOP_MENU_MODE_SELL_NUM:
            return menu.num_cursor;
        default:
            return -1;
    }
}

// Whether the retail key step moves the cursor of the page in front for a synthesized Up or Down, which
// it then sounds. A direction stops at the ends of the goods list, the bag and the quantity's limits.
bool RetailMoves(const CShopMenu &menu, int direction, int goods) {
    const bool up = (direction & PAD_UP) != 0;
    switch (menu.key_arg_no) {
        case SHOP_MENU_MODE_BUY_LIST: {
            int       pos = menu.list_pos;
            int       top = menu.list_top;
            const int moved = MenuListKeyCheck(up ? MENU_SELECT_KEY_UP : MENU_SELECT_KEY_DOWN, &pos, &top, goods, SHOP_LIST_LINE, 0, 0);
            return moved || top != menu.list_top;
        }
        case SHOP_MENU_MODE_BAG: {
            int pos = menu.bag_pos;
            CalcMenuAdd2(&pos, up ? -MENU_ITEM_BOARD_COLUMNS : MENU_ITEM_BOARD_COLUMNS, up ? 0 : GetNowBagMax(ITEM_BOARD_MAIN) - 1);
            return pos != menu.bag_pos;
        }
        case SHOP_MENU_MODE_BUY_NUM:
        case SHOP_MENU_MODE_SELL_NUM:
            return std::min(std::max(menu.num + (up ? 1 : -1), 1), static_cast<int>(menu.num_max)) != menu.num;
        default:
            return false;
    }
}

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
    const int  pane = menu.key_arg_no;
    const int  cursor = ShopCursor(menu);
    int        buttons = 0;
    if (menu.key_arg_no == SHOP_MENU_MODE_BUY_LIST || menu.key_arg_no == SHOP_MENU_MODE_BAG) {
        using namespace menumouse;
        auto       *board = MenuPosData->GetFormInfo("itembrd");
        const int   bag_count = GetNowBagMax(ITEM_BOARD_MAIN);
        const bool  can_buy = keys.have_item.item_no <= 0;
        const Point p{.x = mouse.x, .y = mouse.y};
        const bool  on_board = board && board->draw_flag && ItemBoardClip(board).Contains(p);
        int         bag = BagHit(p, board, bag_count);
        if (!VisibleRow(bag, menu.bag_top, MENU_ITEM_BOARD_ROWS)) {
            bag = -1; // A row still sliding out of the eased board is no longer selectable.
        }
        const ShopList list = ListHit(menu, mouse, goods);
        // A click confirms where it was pressed; a wheel notch in the same sample is dropped.
        const float wheel = (mouse.clicked & 1) ? 0 : mouse.wheel;
        bool        scrolled = false;
        if (std::isfinite(wheel) && wheel != 0) {
            // A pane longer than its window scrolls a row a notch, as the ITEM page's bag does, and the
            // cursor takes the entry that comes under the pointer. One that fits moves its cursor.
            const int direction = wheel > 0 ? PAD_UP : PAD_DOWN;
            // An empty goods list keeps the bag in front, as the retail step does when stock runs out.
            if (list.over && can_buy && goods > 0) {
                menu.key_arg_no = SHOP_MENU_MODE_BUY_LIST;
                if (goods > SHOP_LIST_LINE) {
                    const auto view = MenuMouseScroll(wheel, {.top = menu.list_top, .selected = menu.list_pos}, goods, SHOP_LIST_LINE, list.shown);
                    if (view.top != menu.list_top) {
                        menu.list_top = view.top;
                        menu.list_pos = view.selected;
                    }
                    scrolled = true;
                } else {
                    buttons |= direction;
                }
            } else if (on_board) {
                menu.key_arg_no = SHOP_MENU_MODE_BAG;
                if ((bag_count + MENU_ITEM_BOARD_COLUMNS - 1) / MENU_ITEM_BOARD_COLUMNS > MENU_ITEM_BOARD_ROWS) {
                    // The retail board eases to the new top line, as it does for a D-pad scroll.
                    const int top = ScrollTop(menu.bag_top, bag_count, MENU_ITEM_BOARD_ROWS, wheel);
                    if (top != menu.bag_top) {
                        menu.bag_pos = WheelTarget(p, ItemBoardRest(board), ItemBoardClip(board), top, bag_count, menu.bag_pos).cursor;
                        menu.bag_top = top;
                    }
                    scrolled = true;
                } else {
                    buttons |= direction;
                }
            }
        }
        if (!scrolled && (mouse.moved || (mouse.clicked & 1))) {
            if (list.row >= 0 && can_buy) {
                menu.key_arg_no = SHOP_MENU_MODE_BUY_LIST;
                menu.list_pos = list.row;
            } else if (bag >= 0) {
                menu.key_arg_no = SHOP_MENU_MODE_BAG;
                menu.bag_pos = bag;
            }
        }
        if ((mouse.clicked & 1) && (bag >= 0 || (list.row >= 0 && can_buy))) {
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
    // The retail key step reads its cursor after this hook, so it cannot sound a move made here. It
    // sounds a synthesized Up or Down only if that moves on, not one stopped at a limit.
    const int direction = buttons & (PAD_UP | PAD_DOWN);
    if ((menu.key_arg_no != pane || ShopCursor(menu) != cursor) && !(direction && RetailMoves(menu, direction, goods))) {
        MenuMouseCursorSound();
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
