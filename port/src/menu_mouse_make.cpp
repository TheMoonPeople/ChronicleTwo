#include "menu_mouse_make.hpp"

#include <algorithm>
#include <cmath>

#include "gamepad.hpp"
#include "inventmn.hpp"
#include "mainloop.hpp"
#include "menu_mouse.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menusys.hpp"
#include "mglib_port.hpp"
#include "stubs/inventmn.hpp"

namespace menumouse {

int CardHit(Point p, Point list, float clip_top, int visible_rows, int count) {
    if (p.x < list.x || p.x >= list.x + kCardWidth || p.y < clip_top || p.y >= clip_top + visible_rows * kCardPitch ||
        p.y < list.y) {
        return -1;
    }
    const int card = static_cast<int>((p.y - list.y) / kCardPitch);
    return card < count ? card : -1;
}

MakeListsResult MakeListsUpdate(const MakeLists &lists, Point p, bool moved, std::uint32_t clicked, float wheel) {
    MakeListsResult result{lists};
    auto           &next = result.state;
    // The pane drawn in front owns the pointer where the card list and the item board overlap,
    // even over a row it does not accept, such as one still sliding out of the eased board.
    const Rect card_rows{lists.card_list.x, lists.card_clip, kCardWidth, kCardRows * kCardPitch};
    bool       on_cards = lists.cards && card_rows.Contains(p);
    bool       on_board = lists.board && lists.board_clip.Contains(p);
    if (on_cards && on_board && lists.items_front) {
        on_cards = false;
    } else if (on_cards && on_board) {
        on_board = false;
    }
    int card = -1;
    if (on_cards) {
        card = CardHit(p, lists.card_list, lists.card_clip, kCardRows, lists.card_count);
        if (card >= 0 && (card < lists.card_top || card >= lists.card_top + kCardRows)) {
            card = -1;
        }
    }
    Target cell;
    if (on_board) {
        cell = GridHit(p, lists.board_origin, lists.board_clip, lists.item_count);
        if (cell && !VisibleRow(cell.cursor, lists.item_top, kCardRows)) {
            cell = {};
        }
    }
    result.buttons = clicked & 2 ? PAD_CIRCLE : 0;
    // Mouse1 in the same sample as a wheel notch confirms what it was pressed on; the notch is dropped.
    if (std::isfinite(wheel) && wheel != 0 && !(clicked & 1)) {
        if (on_cards) {
            next.items_front = false;
            next.card_cursor = MenuMouseWheelStep(lists.card_cursor, wheel, lists.card_count);
            // MenuCheckLine keeps the cursor within the visible rows.
            next.card_top = std::clamp(lists.card_top, next.card_cursor - kCardRows + 1, next.card_cursor);
            result.sound = next.card_cursor != lists.card_cursor;
        } else if (on_board) {
            next.item_top = ScrollTop(lists.item_top, lists.item_count, kCardRows, wheel);
            if (next.item_top != lists.item_top) {
                // The board eases to the new row; pick the cell that settles under the pointer.
                next.items_front = true;
                next.item_cursor = WheelTarget(p, lists.board_rest, lists.board_clip, next.item_top, lists.item_count,
                                               lists.item_cursor)
                                       .cursor;
                result.sound = true;
            }
        }
    } else if (moved || (clicked & 1)) {
        if (card >= 0) {
            next.items_front = false;
            result.sound = card != lists.card_cursor;
            next.card_cursor = card;
        } else if (cell) {
            next.items_front = true;
            result.sound = cell.cursor != lists.item_cursor;
            next.item_cursor = cell.cursor;
        }
    }
    const bool switched = next.items_front != lists.items_front;
    if (switched) {
        result.sound = false;
    }
    // A click that brings the other pane forward only selects; the next click confirms.
    if ((clicked & 1) && (card >= 0 || cell) && !switched) {
        result.buttons |= PAD_CROSS;
    }
    return result;
}

MakeBoard MakeBoardRects(Point pos, const float *info) {
    // These follow CommonBoardDraw's own placement of the buttons and the count.
    const float width = info[4];
    const float arrow_x = static_cast<int>(10 + pos.x + width / 2 + width / 10 + 2);
    const float arrow_y = static_cast<int>(250 + pos.y);
    return {
        {info[0],           info[1], 60, 26},
        {info[2],           info[3], 60, 26},
        {arrow_x,           arrow_y, 16, 22},
        {arrow_x + 16,      arrow_y, 32, 22},
        {arrow_x + 16 + 34, arrow_y, 16, 22},
    };
}

MakeInput MakeBoardInput(const MakeBoard &board, Point p, bool moved, std::uint32_t clicked, float wheel) {
    const bool on_number = board.fewer.Contains(p) || board.count.Contains(p) || board.more.Contains(p);
    MakeInput  input;
    if (moved || (clicked & 1)) {
        input.row = board.make.Contains(p) || on_number ? 0 : board.quit.Contains(p) ? 1
                                                                                     : -1;
    }
    input.buttons = clicked & 2 ? PAD_CIRCLE : 0;
    if (std::isfinite(wheel) && wheel != 0) {
        // The wheel changes the count, as Left and Right do on the Make row.
        input.row = 0;
        input.buttons |= wheel > 0 ? PAD_RIGHT : PAD_LEFT;
    } else if (clicked & 1) {
        if (board.fewer.Contains(p)) {
            input.buttons |= PAD_LEFT;
        } else if (board.more.Contains(p)) {
            input.buttons |= PAD_RIGHT;
        } else if (input.row >= 0) {
            input.buttons |= PAD_CROSS;
        }
    }
    return input;
}

} // namespace menumouse

namespace {
using namespace menumouse;
int tick_frame = -1;

void MakeBoardMouse(CMenuInvent &menu, const MenuMouseSample &mouse) {
    if (!menu.makebrd_form || !menu.makebrd_form->draw_flag) {
        return;
    }
    const MakeBoard board = MakeBoardRects(FormPoint(menu.makebrd_form), MakeBoardDrawInfo);
    const MakeInput input = MakeBoardInput(board, {mouse.x, mouse.y}, mouse.moved, mouse.clicked, mouse.wheel);
    if (input.row >= 0 && input.row != menu.make_cursor) {
        menu.make_cursor = input.row;
        MenuMouseCursorSound();
    }
    MenuMouseSetButtons(input.buttons);
}

void ListsMouse(CMenuInvent &menu, CMenuKeyFunc &keys, const MenuMouseSample &mouse) {
    MakeLists lists;
    lists.items_front = menu.key_arg_no == INVENT_MODE_ITEM_LIST;
    lists.card_cursor = menu.card_cursor;
    lists.card_top = menu.card_top;
    lists.item_cursor = menu.item_cursor;
    lists.item_top = menu.item_top;
    auto *title = menu.card_list_title_form;
    auto *list = menu.card_list_form;
    // A held item keeps the cursor on the item board, as retail redirects Left there.
    lists.cards = title && title->draw_flag && list && keys.have_item.item_no <= 0;
    if (lists.cards) {
        lists.card_count = menu.EnableSelectMaxCardList();
        lists.card_list = {list->x, list->y};
        lists.card_clip = FormPoint(title, "basecard").y;
    }
    auto *board = menu.itembrd_form;
    lists.board = board && board->draw_flag;
    if (lists.board) {
        lists.item_count = GetNowBagMax(ITEM_BOARD_MAIN);
        lists.board_origin = {MenuItemBrdUnderBrdPosXY[0], MenuItemBrdUnderBrdPosXY[1]};
        lists.board_clip = ItemBoardClip(board);
        lists.board_rest = ItemBoardRest(board);
    }
    const auto  result = MakeListsUpdate(lists, {mouse.x, mouse.y}, mouse.moved, mouse.clicked, mouse.wheel);
    const auto &next = result.state;
    const int   pane = next.items_front ? INVENT_MODE_ITEM_LIST : INVENT_MODE_CARD_LIST;
    if (pane != menu.key_arg_no) {
        // The retail pane change slides the boards and plays the cursor sound.
        menu.NextDifferentMode(pane, 0);
    }
    if (next.card_top != menu.card_top) {
        menu.card_scroll_dir = next.card_top > menu.card_top;
    }
    menu.card_cursor = next.card_cursor;
    menu.card_top = next.card_top;
    menu.item_cursor = next.item_cursor;
    menu.item_top = next.item_top;
    if (result.sound) {
        MenuMouseCursorSound();
    }
    MenuMouseSetButtons(result.buttons);
}
} // namespace

void MenuMouseMakeTick(CMenuKeyFunc &keys) {
    auto *menu = CMenuInventPt;
    if (!menu || &keys != MenuCommonInfo || !keys.key_enable || tick_frame == mgPortFrameCount()) {
        return;
    }
    tick_frame = mgPortFrameCount();
    const auto &mouse = MenuMouseTake();
    if (!mouse.pointing || GamePad__2.key_lock || menu_debug_flag) {
        return;
    }
    if (menu->mode == MENU_ASK_MODE_MAKE) {
        if (menu->step == INVENT_MAKE_STEP_SELECT) {
            MakeBoardMouse(*menu, mouse);
        }
        return;
    }
    if (menu->mode != MENU_ASK_MODE_NONE || (MenuMoveItemPtr && MenuMoveItemPtr->move_on)) {
        return;
    }
    if (menu->key_arg_no == INVENT_MODE_CARD_LIST || menu->key_arg_no == INVENT_MODE_ITEM_LIST) {
        ListsMouse(*menu, keys, mouse);
    } else {
        // The idea board, notebook and album pages have no pointer targets: a stray left click
        // must not confirm their keyboard selection. Mouse2 still backs out.
        MenuMouseSetButtons(mouse.clicked & 2 ? PAD_CIRCLE : 0);
    }
}
