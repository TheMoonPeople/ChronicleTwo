#include "menu_mouse_item.hpp"

#include <algorithm>
#include <cmath>
#include <string>

#include "gamepad.hpp"
#include "gfx/gfx.hpp"
#include "mainloop.hpp"
#include "menu_world.hpp"
#include "menuaqua.hpp"
#include "menuchr.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menusys.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "snd_mngr.hpp"
#include "userdata.hpp"

namespace menumouse {
bool Rect::Contains(Point p) const {
    return p.x >= x && p.x < x + w && p.y >= y && p.y < y + h;
}

Target GridHit(Point p, Point origin, Rect clip, int count) {
    if (!clip.Contains(p) || p.x < origin.x || p.x >= origin.x + 240 || p.y < origin.y) {
        return {};
    }
    const int column = static_cast<int>((p.x - origin.x) / 40);
    const int row = static_cast<int>((p.y - origin.y) / 50);
    const int index = row * 6 + column;
    return index < count ? Target{.panel = ITEM_MENU_PANEL_BAG, .cursor = index} : Target{};
}

int ScrollTop(int top, int count, int visible_rows, float wheel) {
    if (!std::isfinite(wheel) || wheel == 0) {
        return top;
    }
    int step = static_cast<int>(std::clamp(std::trunc(std::abs(wheel)), 0.0f, 24.0f));
    return std::clamp(top + (wheel > 0 ? -step : step), 0, std::max(0, (count + 5) / 6 - visible_rows));
}

bool VisibleRow(int cursor, int top, int visible_rows) {
    return cursor >= 0 && cursor / 6 >= top && cursor / 6 < top + visible_rows;
}

Point FormPoint(CMenuPosDataForm *form, const char *part) {
    Point p;
    form->GetPutPosXY(const_cast<char *>(part), p.x, p.y);
    return p;
}

Rect ItemBoardClip(CMenuPosDataForm *board) {
    const Point p = FormPoint(board);
    return {.x = p.x + 16, .y = p.y + 20, .w = 240, .h = 250};
}

Point ItemBoardRest(CMenuPosDataForm *board) { return {.x = MenuItemBrdUnderBrdPosXY[0], .y = FormPoint(board).y + 26}; }

Target WheelTarget(Point p, Point rest, Rect clip, int top, int count, int cursor) {
    // The aperture reaches above the first resting row; only a cell of the new visible rows may be chosen.
    const Target target = GridHit(p, {.x = rest.x, .y = rest.y - top * 50.0f}, clip, count);
    if (target && VisibleRow(target.cursor, top, 5)) {
        return target;
    }
    return {.panel = ITEM_MENU_PANEL_BAG, .cursor = std::clamp(cursor, top * 6, std::min(count - 1, (top + 5) * 6 - 1))};
}

int BagHit(Point p, CMenuPosDataForm *board, int count) {
    if (!board || !board->draw_flag) {
        return -1;
    }
    const auto hit = GridHit(p, {.x = MenuItemBrdUnderBrdPosXY[0], .y = MenuItemBrdUnderBrdPosXY[1]}, ItemBoardClip(board), count);
    return hit ? hit.cursor : -1;
}

void Gesture::Reset() { *this = {}; }

Action Gesture::Update(const Take &take, Point p, Target hit, bool can_pick_up, bool holding) {
    if (!take.pointing) {
        Reset();
        return Action::None;
    }
    if (take.pressed & 2) {
        Reset();
        return Action::Cancel;
    }
    if (release_pending) {
        Reset();
        return holding ? (hit ? Action::Drop : Action::Cancel) : Action::None;
    }
    if (take.pressed & 1) {
        if (holding) {
            return hit ? Action::Drop : Action::None;
        }
        if (hit && can_pick_up) {
            pending = true;
            source = hit;
            origin = p;
        } else {
            return hit ? Action::Click : Action::None;
        }
    }
    if (pending) {
        const float dx = p.x - origin.x;
        const float dy = p.y - origin.y;
        if (dx * dx + dy * dy >= 16) {
            pending = false;
            dragging = true;
            release_pending = (take.released & 1) != 0;
            return Action::PickUp;
        }
        if (take.released & 1) {
            const bool click = hit == source;
            Reset();
            return click ? Action::Click : Action::None;
        }
    }
    if (dragging && (take.released & 1)) {
        Reset();
        return holding ? (hit ? Action::Drop : Action::Cancel) : Action::None;
    }
    return Action::None;
}
} // namespace menumouse

namespace {
using namespace menumouse;
Pointer       pointer;
Gesture       gesture;
bool          menu_open = false, finish_drop = false;
int           synthetic = 0, bag_top = 0;
CMenuKeyFunc *owner = nullptr;
int           view = -1;

bool ItemPage() {
    return MenuPosData && MenuCommonInfo && MenuCommonInfo->now_mode == MENU_MODE_ITEM &&
           class_menu_item_info.sub_menu == MENU_ITEM_SUB_MENU_NONE &&
           class_menu_item_info.next_sub_menu == MENU_ITEM_SUB_MENU_NONE;
}

bool PadActive() {
    // These are the real pad/keyboard values: synthetic presses are independent.
    return GamePad__2.pad[0].button != 0;
}

Rect BoardClip(CMenuItemInfo &menu) { return ItemBoardClip(menu.item_board_form); }

// The 3D models are placed in world space rather than by a form part. A model
// target spans from its page's retail cursor part down to the page's lower parts.
// 180 units is the character model's width (see Hit). From the left panel's
// parts it ends at x 188 to 208 in every layout, short of the bag at x 242.
Rect ModelArea(float left, float top, float bottom) { return {.x = left, .y = top, .w = 180, .h = bottom - top}; }

// The ridepod and monster pages: the model stands right of chr_cur, above the name.
Target PartnerHit(CMenuItemInfo &menu, Point p) {
    const bool robo = menu.view_mode == MENU_ITEM_VIEW_ROBO;
    auto      *form = menu.view_form[robo ? 3 : 4];
    if (!form || !form->draw_flag || !MenuMouseFindPart(form, "chr_cur")) {
        return {};
    }
    // The left edge is the Ridepod's first part slot (c_w0, 16 left of the form).
    // The top is 64 above chr_cur, where the rider's head reaches. The bottom is
    // the name row's top (name, 14 to 16 above the form), above the part slots.
    const Point cursor = FormPoint(form, "chr_cur");
    const Point origin = FormPoint(form);
    if (ModelArea(origin.x - 16, cursor.y - 64, origin.y - 16).Contains(p)) {
        return {.panel = robo ? ITEM_MENU_PANEL_RIDEPOD : ITEM_MENU_PANEL_MONSTER, .cursor = 0};
    }
    return {};
}

// Max's bait slot is drawn, and reachable by the retail cursor, only with a rod equipped.
Target BaitHit(CMenuItemInfo &menu, CMenuPosDataForm *form, Point p) {
    if (menu.view_mode != MENU_ITEM_VIEW_MAX || menu.sub_view != 0) {
        return {};
    }
    // Monica's page has no esa0 part.
    auto *bait = MenuMouseFindPart(form, "esa0");
    auto *user = GetUserDataMan();
    if (!bait || !bait->draw_flag || !user || !user->GetActiveEsa()) {
        return {};
    }
    // The bait icon is drawn at its part's size (24x30), smaller than the 28x35
    // item icons. Include the same 4-unit margin around it.
    const Point q = FormPoint(form, "esa0");
    return Rect{.x = q.x - 4, .y = q.y - 4, .w = bait->w + 8, .h = bait->h + 8}.Contains(p) ? Target{.panel = ITEM_MENU_PANEL_FISHING_BAIT, .cursor = 0} : Target{};
}

Target Hit(CMenuItemInfo &menu, Point p, int count) {
    Target target = GridHit(p, {.x = MenuItemBrdUnderBrdPosXY[0], .y = MenuItemBrdUnderBrdPosXY[1]}, BoardClip(menu), count);
    if (target) {
        return target;
    }
    if (menu.view_mode == MENU_ITEM_VIEW_WEAPON || menu.view_mode == MENU_ITEM_VIEW_FISHING_ROD) {
        auto *form = menu.view_form[menu.view_mode == MENU_ITEM_VIEW_WEAPON ? 2 : 5];
        if (!form || !form->draw_flag) {
            return {};
        }
        const int panel = menu.view_mode == MENU_ITEM_VIEW_WEAPON ? ITEM_MENU_PANEL_WEAPON_STATS : ITEM_MENU_PANEL_FISHING_ROD_STATS;
        const int stats = menu.view_mode == MENU_ITEM_VIEW_WEAPON ? 10 : 5;
        for (int i = 0; i < stats; ++i) {
            const std::string name = "index" + std::to_string(i);
            auto             *part = MenuMouseFindPart(form, name.c_str());
            if (!part || !part->draw_flag) {
                continue;
            }
            constexpr const char *values[] = {"st0", "st1", "el0", "el1", "el2", "el3", "el4", "el5", "el6", "el7"};
            const Point           q = FormPoint(form, part->name);
            float                 width = part->w > 0 ? part->w : 60;
            if (auto *value = MenuMouseFindPart(form, values[i])) {
                const Point v = FormPoint(form, value->name);
                width = std::max(width, v.x + value->w - q.x);
            }
            // Include the label, value and their shared board's small padding.
            if (Rect{.x = q.x - 2, .y = q.y - 2, .w = width + 4, .h = (part->h > 0 ? part->h : 18) + 4}.Contains(p)) {
                return {.panel = panel, .cursor = i};
            }
        }
        // The model turns above the parameter board, right of the retail hand at
        // chrpos. The top is 112 above chrpos: the bag's first row on the weapon
        // page. The bottom stops 20 above the board, at the durability bar (hpbar).
        if (MenuMouseFindPart(form, "chrpos")) {
            const Point cursor = FormPoint(form, "chrpos");
            const Point board = FormPoint(form);
            if (ModelArea(cursor.x - 8, cursor.y - 112, board.y - 20).Contains(p)) {
                return {.panel = menu.view_mode == MENU_ITEM_VIEW_WEAPON ? ITEM_MENU_PANEL_WEAPON : ITEM_MENU_PANEL_FISHING_ROD, .cursor = 0};
            }
        }
        return {};
    }
    if (menu.view_mode == MENU_ITEM_VIEW_ROBO || menu.view_mode == MENU_ITEM_VIEW_MONSTER) {
        if (const Target target = PartnerHit(menu, p)) {
            return target;
        }
    }
    if (menu.view_mode == MENU_ITEM_VIEW_ROBO) {
        auto *form = menu.view_form[3];
        if (!form || !form->draw_flag) {
            return {};
        }
        for (int i = 0; i < 2; ++i) {
            const std::string name = "c_w" + std::to_string(i);
            const Point       q = FormPoint(form, name.c_str());
            if (Rect{.x = q.x, .y = q.y, .w = 80, .h = 40}.Contains(p)) {
                return {.panel = ITEM_MENU_PANEL_RIDEPOD_PARTS, .cursor = i};
            }
        }
        return {};
    }
    if (menu.view_mode != MENU_ITEM_VIEW_MAX && menu.view_mode != MENU_ITEM_VIEW_MONICA) {
        return {};
    }
    auto *form = menu.view_form[menu.sub_view];
    if (!form || !form->draw_flag) {
        return {};
    }
    // The icon parts are the artwork's upper left. c_i/c_w instead place the
    // much larger, animated retail selection frame.
    for (int i = 0; i < 3; ++i) {
        auto *icon = menu.item_parts[menu.sub_view][i];
        if (!icon) {
            continue;
        }
        Point q = FormPoint(form, icon->name);
        if (Rect{.x = q.x - 4, .y = q.y - 4, .w = 40, .h = 40}.Contains(p)) {
            return {.panel = ITEM_MENU_PANEL_ACTIVE_ITEMS, .cursor = i};
        }
    }
    for (int i = 0; i < 2; ++i) {
        auto *icon = menu.wep_parts[menu.sub_view][8 + i * 6];
        if (!icon) {
            continue;
        }
        Point q = FormPoint(form, icon->name);
        if (Rect{.x = q.x - 4, .y = q.y - 4, .w = 40, .h = 40}.Contains(p)) {
            return {.panel = ITEM_MENU_PANEL_EQUIPMENT, .cursor = i};
        }
    }
    if (const Target bait = BaitHit(menu, form, p)) {
        return bait;
    }
    // The model occupies the space between the active items and the weapons.
    Point active = FormPoint(form, "c_i0");
    Point weapon = FormPoint(form, "c_w0");
    if (Rect{.x = active.x + 20, .y = active.y + 48, .w = 180, .h = weapon.y - active.y - 62}.Contains(p)) {
        return {.panel = ITEM_MENU_PANEL_CHARA, .cursor = 0};
    }
    return {};
}

void Select(CMenuItemInfo &menu, CMenuKeyFunc &keys, Target target, MENU_INPUTKEY_ARG *layouts) {
    if (!target || (menu.key_arg_no == target.panel && keys.cursor == target.cursor)) {
        return;
    }
    if (menu.key_arg_no == ITEM_MENU_PANEL_BAG) {
        bag_top = keys.top_line;
    }
    // KeyStepLocal sounds a cursor that differs from the tick's saved one; the same index on another panel needs its own.
    if (menu.key_arg_no != target.panel && target.cursor == keys.save_cursor) {
        MenuMouseCursorSound();
    }
    menu.key_arg_no = target.panel;
    keys.key_arg = &layouts[target.panel];
    keys.cursor = target.cursor;
    keys.top_line = target.panel == ITEM_MENU_PANEL_BAG ? bag_top : 0;
    keys.key_input = true;
}

Point Start(CMenuItemInfo &menu, CMenuKeyFunc &keys) {
    if (menu.mode == MENU_ASK_MODE_ITEM_COMMAND && menu.ask_para.mes_no >= 0 && menu.ask_para.mes_no < 9) {
        auto *message = MenuDCMsg[menu.ask_para.mes_no];
        if (message && message->GetMsgCursor() >= 0) {
            int dx = 0;
            int dy = 0;
            message->CalcCenteringXY(&dx, &dy);
            return {.x = message->text_x + message->draw_off_x + dx + message->text_w * 0.5f,
                    .y = message->text_y + message->draw_off_y + dy + (message->GetMsgCursor() + 0.5f) * message->font_h};
        }
    }
    if (menu.key_arg_no == ITEM_MENU_PANEL_BAG) {
        return {.x = MenuItemBrdUnderBrdPosXY[0] + (keys.cursor % 6) * 40 + 20,
                .y = MenuItemBrdUnderBrdPosXY[1] + (keys.cursor / 6) * 50 + 25};
    }
    Point p{.x = 256, .y = 240};
    if (keys.cursor_form) {
        p = FormPoint(keys.cursor_form, "cursor0");
        p.x += 26;
        p.y += 14;
    }
    return p;
}

Take TakePointer() {
    const auto &sample = MenuMouseTake();
    // Hit tests use the retail layout, so the pointer moves back the way its spread panel moved.
    pointer.pos = {.x = menuworld::RetailPointerX(sample.x), .y = sample.y};
    pointer.pointing = sample.pointing;
    return {.pointing = sample.pointing, .moved = sample.moved || sample.clicked != 0 || sample.wheel != 0, .pressed = sample.clicked, .released = sample.released, .held = sample.held, .wheel = sample.wheel};
}

void Commands(CMenuItemInfo &menu, const Take &take) {
    gesture.Reset();
    if (take.pressed & 2) {
        synthetic = PAD_CIRCLE;
        return;
    }
    if (!take.pointing || menu.step != 0 || !menu.ask_para.form ||
        menu.ask_para.mes_no < 0 || menu.ask_para.mes_no >= 9) {
        return;
    }
    auto *message = MenuDCMsg[menu.ask_para.mes_no];
    if (!message || !menu.ask_para.form->draw_flag) {
        return;
    }
    const auto rows = MenuMouseMessageRows(*message, menu.ask_para.cmd_num);
    const int  row = MenuMouseHit(rows, pointer.pos.x, pointer.pos.y);
    if (row >= 0 && take.moved && row != message->GetMsgCursor()) {
        message->SetMsgCursor(row);
        MenuMouseCursorSound();
    }
    if (row >= 0 && (take.pressed & 1)) {
        synthetic = PAD_CROSS;
    }
}

void Question(CMenuItemInfo &menu, CMenuKeyFunc &keys, const Take &take) {
    gesture.Reset();
    if (take.pressed & 2) {
        synthetic = PAD_CIRCLE;
        return;
    }
    if (!take.pointing) {
        return;
    }
    auto *quantity = keys.how_much_form;
    if (quantity && quantity->draw_flag) {
        // The quantity board repositions its parts above or below the hand.
        // Use those parts rather than assuming which side has room.
        Point up = FormPoint(quantity, "up");
        Point down = FormPoint(quantity, "down");
        Rect  area{.x = std::min(up.x, down.x) - 12, .y = std::min(up.y, down.y) - 12, .w = std::abs(up.x - down.x) + 48, .h = std::abs(up.y - down.y) + 48};
        if (area.Contains(pointer.pos)) {
            if (take.wheel != 0) {
                synthetic = take.wheel > 0 ? PAD_UP : PAD_DOWN;
            } else if (take.pressed & 1) {
                if (Rect{.x = up.x - 6, .y = up.y - 6, .w = 32, .h = 24}.Contains(pointer.pos)) {
                    synthetic = PAD_UP;
                } else if (Rect{.x = down.x - 6, .y = down.y - 6, .w = 32, .h = 24}.Contains(pointer.pos)) {
                    synthetic = PAD_DOWN;
                } else {
                    synthetic = PAD_CROSS;
                }
            }
        }
        return;
    }
    if (menu.mode == MENU_ASK_MODE_EXTEND && menu.ask_para.ask_mode == MENU_ITEM_EXTEND_BUILD_UP && menu.step == 0) {
        const int     count = std::clamp(BuildUpWeaponInfo.select_num, 0, 3);
        MenuMouseRect rows[3]{};
        for (int i = 0; i < count; ++i) {
            rows[i] = {.x = static_cast<float>(BuildUpNameXY[i][0]), .y = static_cast<float>(BuildUpNameXY[i][1]), .w = 200, .h = 24};
        }
        const int selected = MenuMouseRows({rows, static_cast<std::size_t>(count)}, BuildUpWeaponInfo.select_no);
        // The retail build-up step reads its cursor after this hook, so it cannot sound this move.
        if (selected != BuildUpWeaponInfo.select_no) {
            BuildUpWeaponInfo.select_no = selected;
            MenuMouseCursorSound();
        }
        synthetic = MenuMouseButtons();
        return;
    }
    // Scripts often put a follow-up on message 7, rather than ask_para.mes_no.
    for (int id = 8; id >= 0; --id) {
        auto *message = MenuDCMsg[id];
        auto *form = MenuMesForm[id];
        if (!message || !form || !form->draw_flag || message->GetMsgCursor() < 0) {
            continue;
        }
        const auto rows = MenuMouseMessageRows(*message, message->rows);
        if (rows.empty()) {
            continue;
        }
        const int row = MenuMouseHit(rows, pointer.pos.x, pointer.pos.y);
        if (row >= 0 && take.moved && row != message->GetMsgCursor()) {
            message->SetMsgCursor(row);
            MenuMouseCursorSound();
        }
        if (row >= 0 && (take.pressed & 1)) {
            synthetic = PAD_CROSS;
        }
        return;
    }
    // An informational follow-up may replace the original command form.
    for (int id = 8; id >= 0; --id) {
        if (MenuDCMsg[id] && MenuMesForm[id] && MenuMesForm[id]->draw_flag) {
            if (take.pressed & 1) {
                synthetic = PAD_CROSS;
            }
            return;
        }
    }
    const int id = menu.ask_para.mes_no;
    if (id >= 0 && id < 9 && MenuDCMsg[id] && MenuMesForm[id] && !MenuMesForm[id]->draw_flag) {
        return;
    }
    // A popup without selectable rows still accepts its current retail choice.
    if (take.pressed & 1) {
        synthetic = PAD_CROSS;
    }
}
} // namespace

void MenuMouseClose() {
    synthetic = 0;
    pointer.pointing = false;
    gesture.Reset();
    finish_drop = false;
    menu_open = false;
    owner = nullptr;
}

void MenuMousePadTick() {
    synthetic = 0;
    if (menu_open && !ItemPage()) {
        MenuMouseClose();
    }
}

bool MenuMouseItemActive() { return ItemPage(); }

bool MenuMouseHeldItemAt(float &x, float &y) {
    if (!ItemPage() || MenuCommonInfo->have_item.item_no <= 0) {
        return false;
    }
    const MenuMouseSample sample = MenuMouseDisplaySample();
    if (!sample.pointing) {
        return false;
    }
    x = sample.x;
    y = sample.y;
    return true;
}

void MenuMouseItemOrigin(float &x, float &y) {
    if (!ItemPage()) {
        return;
    }
    const Point start = Start(class_menu_item_info, *MenuCommonInfo);
    x = menuworld::SpreadX(start.x);
    y = start.y;
}

void MenuMouseUpdate(CMenuKeyFunc &keys) {
    synthetic = 0;

    // Commit even an empty result: an inventory press may be a pending drag.
    struct CommitButtons {
        ~CommitButtons() { MenuMouseSetButtons(synthetic); }
    } commit;

    if (!ItemPage() || &keys != MenuCommonInfo) {
        MenuMouseClose();
        return;
    }
    auto &menu = class_menu_item_info;
    if (!menu_open || owner != &keys) {
        pointer = {};
        gesture.Reset();
        menu_open = true;
        owner = &keys;
        view = menu.view_mode;
        bag_top = keys.top_line;
        return;
    }
    Take       take = TakePointer();
    const bool pad = PadActive();
    if (view != menu.view_mode || pad) {
        gesture.Reset();
        view = menu.view_mode;
    }
    // After a pad takeover, a carried item stays where retail input leaves it.
    if (pad) {
        finish_drop = false;
    }
    if (!take.pointing || !keys.key_enable || GamePad__2.key_lock || menu_debug_flag ||
        menu.mode == MENU_ASK_MODE_OPEN || menu.mode == MENU_ASK_MODE_CLOSE ||
        (MenuMoveItemPtr && MenuMoveItemPtr->move_on) || MenuLoadFileCheck(MenuCharaBuild2)) {
        gesture.Reset();
        return;
    }
    // A drop can open a retail question, such as attaching a synth sphere. Once
    // it closes, an item still carried returns as after a refused drop.
    if (finish_drop && menu.mode == MENU_ASK_MODE_NONE) {
        finish_drop = false;
        if (keys.have_item.item_no > 0) {
            // A swap leaves the destination item on the cursor. Retail's return
            // operation puts it in the original slot, or retains it if refused.
            // Like retail's leave-page key, a refused return (no room) also goes
            // back to the active character's page.
            menu.IsCancelNoneLoadItem();
        }
    }
    if (menu.mode == MENU_ASK_MODE_ITEM_COMMAND && menu.step == 0) {
        Commands(menu, take);
        return;
    }
    if (menu.mode == MENU_ASK_MODE_ROD_POINTS && menu.step == 0) {
        const Target hit = Hit(menu, pointer.pos, 0);
        if (hit.panel == ITEM_MENU_PANEL_FISHING_ROD_STATS && take.moved) {
            // select_pos[0] shares keys.cursor, whose change KeyStepLocal already sounds.
            keys.cursor = hit.cursor;
            keys.select_pos[0] = hit.cursor;
            keys.key_input = true;
        }
        if (take.pressed & 2) {
            synthetic = PAD_CIRCLE;
        } else if (take.wheel != 0 && hit.panel == ITEM_MENU_PANEL_FISHING_ROD_STATS) {
            synthetic = take.wheel > 0 ? PAD_RIGHT : PAD_LEFT;
        } else if ((take.pressed & 1) && hit.panel == ITEM_MENU_PANEL_FISHING_ROD_STATS) {
            synthetic = PAD_CROSS;
        }
        return;
    }
    if (menu.mode != MENU_ASK_MODE_NONE) {
        Question(menu, keys, take);
        return;
    }
    if (menu.key_arg_no < 0 || menu.key_arg_no >= ITEM_MENU_PANEL_NUM || !keys.key_arg || !menu.item_board_form) {
        return;
    }
    // key_arg always points into this retail table while the item page is idle.
    auto *layouts = keys.key_arg - menu.key_arg_no;
    int   count = layouts[ITEM_MENU_PANEL_BAG].max;
    if (menu.key_arg_no == ITEM_MENU_PANEL_BAG) {
        bag_top = keys.top_line;
    }
    bool scrolled = false;
    if (take.wheel && BoardClip(menu).Contains(pointer.pos)) {
        int top = ScrollTop(bag_top, count, layouts[ITEM_MENU_PANEL_BAG].disp_lines, take.wheel);
        if (top != bag_top) {
            bag_top = top;
            // The retail board eases to the new top line, as it does for a D-pad scroll.
            Select(menu, keys, WheelTarget(pointer.pos, ItemBoardRest(menu.item_board_form), BoardClip(menu), top, count, keys.cursor), layouts);
            keys.top_line = top;
            keys.key_input = true;
            scrolled = true;
        }
    }
    Target hit = Hit(menu, pointer.pos, count);
    if (hit.panel == ITEM_MENU_PANEL_BAG && !VisibleRow(hit.cursor, bag_top, layouts[ITEM_MENU_PANEL_BAG].disp_lines)) {
        hit = {}; // A row still sliding out of the eased board is no longer selectable.
    }
    if (hit && !scrolled && (take.moved || gesture.dragging)) {
        Select(menu, keys, hit, layouts);
    }
    bool can_pick_up = false;
    if (hit && (hit.panel == ITEM_MENU_PANEL_BAG || hit.panel == ITEM_MENU_PANEL_ACTIVE_ITEMS)) {
        auto *item = hit.panel == ITEM_MENU_PANEL_BAG ? &MenuUserParam.used_data[hit.cursor] : &MenuUserParam.chara[menu.sub_view]->active_item[hit.cursor];
        can_pick_up = item->item_no > 0;
    }
    Action action = gesture.Update(take, pointer.pos, hit, can_pick_up, keys.have_item.item_no > 0);
    switch (action) {
        case Action::PickUp:
            Select(menu, keys, gesture.source, layouts);
            synthetic = PAD_SQUARE;
            break;
        case Action::Drop:
            Select(menu, keys, hit, layouts);
            synthetic = PAD_CROSS;
            finish_drop = true;
            break;
        case Action::Click:
            // Confirm the clicked cell even if a wheel scroll moved the cursor meanwhile.
            Select(menu, keys, hit, layouts);
            synthetic = PAD_CROSS;
            break;
        case Action::Cancel:
            synthetic = PAD_CIRCLE;
            break;
        case Action::None:
            break;
    }
}

PORT_OVERRIDE void CMenuKeyFunc::SelDataInit() {
    select_key = 0;
    push_button = 0;
    save_cursor = cursor;
    save_top_line = top_line;
    key_input = false;
    if (MenuMouseItemActive()) {
        MenuMouseUpdate(*this);
    }
}
