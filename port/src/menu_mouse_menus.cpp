#include "common.h"

#include <algorithm>
#include <cstdio>
#include <vector>

#include "gamepad.hpp"
#include "mainloop.hpp"
#include "menu_mouse.hpp"
#include "menu_mouse_make.hpp"
#include "menu_mouse_monster.hpp"
#include "menu_mouse_shop.hpp"
#include "menuaqua.hpp"
#include "menuchr.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menuop.hpp"
#include "menusys.hpp"
#include "mglib.hpp"
#include "save_slots.hpp"
#include "title.hpp"

extern CItemSelect     *MouseItemSelect asm("MenuMouse_ItemSelect");
extern CMenuInter      *MouseInter asm("MenuMouse_Inter");
extern CSaveMenuClass  *MouseSave asm("MenuMouse_Save");
extern TITLE_INFO      *MouseTitle asm("MenuMouse_Title");
extern short            MouseTitlePhase asm("MenuMouse_TitlePhase");
extern unsigned char    MouseTitleHDD asm("MenuMouse_TitleHDD");
extern CMenuChrCngMenu *MouseChrChange asm("MenuMouse_ChrChange");
extern CManualMenu     *MouseManual asm("MenuMouse_Manual");
extern CMenuOption     *MouseOption asm("MenuOption_Current");
extern float            MouseOptionCount asm("MenuOption_Count");

bool MenuMouseFloor();

namespace {
void RootMouse() {
    if (!MouseInter || !MenuPosData || MouseInter->step != MENU_INTER_STEP_SELECT || MouseInter->next_mode >= 0) {
        return;
    }
    std::vector<MenuMouseRect> rows;
    for (int i = 0; i < MouseInter->select_num; ++i) {
        auto *form = MenuPosData->GetFormInfo(GetMenuMainIconChar(MouseInter->mode_list[i]));
        rows.push_back(form ? MenuMouseRect{form->x - 20, form->y - 4, 190, 30} : MenuMouseRect{});
    }
    const int selected = MenuMouseRows(rows, MouseInter->select_no);
    if (selected != MouseInter->select_no) {
        MenuMouseMove(&MouseInter->select_no, selected);
    }
}

void ItemPopupMouse() {
    if (!MouseItemSelect || MouseItemSelect->mode != MENU_ASK_MODE_NONE) {
        return;
    }
    auto                      &items = *MouseItemSelect;
    std::vector<MenuMouseRect> cells(items.item_num);
    for (int i = 0; i < items.item_num; ++i) {
        int row = i / ITEM_SELECT_COLUMNS;
        if (row >= items.top_line && row < items.top_line + 2) {
            cells[i] = {items.item_rect.left + 44 * (i % ITEM_SELECT_COLUMNS), items.item_rect.top + 55 * row, 44, 55};
        }
    }
    int selected = MenuMouseRows(cells, items.cursor, ITEM_SELECT_COLUMNS);
    if (selected != items.cursor) {
        items.cursor = selected;
        MenuCheckLine(&items.top_line, selected / ITEM_SELECT_COLUMNS, 2);
        MenuMouseCursorSound();
    }
}

void TitleMouse() {
    if (GetNowLoopNo() != LOOP_TITLE || !MouseTitle || MouseTitle->mode != TITLE_MODE_TITLE) {
        return;
    }
    if (MouseTitlePhase == TITLE_PHASE_MENU) {
        const int     count = MouseTitleHDD ? 5 : 4;
        MenuMouseRect rows[5]{};
        for (int i = 0; i < count; ++i) {
            rows[i] = {(mgScreenWidth - 210) * 0.5f, float((MouseTitleHDD ? 76 : 100) + 58 * i), 210, 54};
        }
        const int selected = MenuMouseRows({rows, static_cast<std::size_t>(count)}, MouseTitle->select);
        if (selected != MouseTitle->select) {
            MouseTitle->select = selected;
            MouseTitle->idle_count = 0;
            MenuMouseCursorSound();
        }
    } else if (MouseTitlePhase <= TITLE_PHASE_PUSH_START) {
        if (MenuMouseTake().clicked & 1) {
            MenuMousePress(PAD_START);
        }
    }
}
} // namespace

PORT_OVERRIDE int CMenuKeyFunc::CheckSelectKey() {
    if (now_mode == MENU_MODE_SHOP) {
        MenuMouseShopTick(*this);
    }
    if (key_enable) {
        if (now_mode == MENU_MODE_CHARA_CHANGE && MouseChrChange) {
            MenuMouseChara(*MouseChrChange);
        }
        if (now_mode == MENU_MODE_OPTION && MouseOption && MenuPosData) {
            MenuMouseOptionHover(*MouseOption, MenuPosData->GetFormInfo(const_cast<char *>("Op_Switch")),
                                 MenuPosData->GetFormInfo(const_cast<char *>("clip0")));
        }
        if (now_mode == MENU_MODE_MANUAL && MouseManual && MenuPosData) {
            MenuMouseManual(*MouseManual, MenuPosData->GetFormInfo(const_cast<char *>("op_bg")),
                            MenuPosData->GetFormInfo(const_cast<char *>("clip0")));
        }
        if (now_mode == MENU_MODE_MAIN_TOWN || now_mode == MENU_MODE_MAIN_DUNGEON) {
            RootMouse();
        }
        if (now_mode == MENU_MODE_DNG_TREE_MAP) {
            MenuMouseFloor();
        }
        if (now_mode == MENU_MODE_ITEM_SELECT) {
            ItemPopupMouse();
        }
        if (now_mode == MENU_MODE_INVENT || now_mode == MENU_MODE_INVENT_DIRECT) {
            MenuMouseMakeTick(*this);
        }
        MenuMouseMonsterTick(*this);
    }
    if (GamePad__2.Down(PAD_UP)) {
        select_key |= MENU_SELECT_KEY_UP;
    } else if (GamePad__2.Down(PAD_DOWN)) {
        select_key |= MENU_SELECT_KEY_DOWN;
    }
    if (GamePad__2.Down(PAD_LEFT)) {
        select_key |= MENU_SELECT_KEY_LEFT;
    } else if (GamePad__2.Down(PAD_RIGHT)) {
        select_key |= MENU_SELECT_KEY_RIGHT;
    }
    if (!key_enable) {
        select_key = 0;
    }
    return select_key;
}

PORT_OVERRIDE int MenuCheckPushButton() {
    TitleMouse();
    const int confirm = LanguageCode > 0 ? PAD_CROSS : PAD_CIRCLE;
    const int cancel = LanguageCode > 0 ? PAD_CIRCLE : PAD_CROSS;
    // Preserve retail priority when several physical buttons are pressed.
    if (GamePad__2.Down(PAD_CIRCLE)) {
        return PAD_CIRCLE == confirm ? MENU_PUSH_BUTTON_DECIDE : MENU_PUSH_BUTTON_CANCEL;
    }
    if (GamePad__2.Down(PAD_CROSS)) {
        return PAD_CROSS == cancel ? MENU_PUSH_BUTTON_CANCEL : MENU_PUSH_BUTTON_DECIDE;
    }
    constexpr int pads[] = {PAD_TRIANGLE, PAD_SQUARE, PAD_SELECT, PAD_START, PAD_L3, PAD_R3};
    constexpr int actions[] = {MENU_PUSH_BUTTON_TRIANGLE, MENU_PUSH_BUTTON_SQUARE, MENU_PUSH_BUTTON_SELECT,
                               MENU_PUSH_BUTTON_START, MENU_PUSH_BUTTON_L3, MENU_PUSH_BUTTON_R3};
    for (int i = 0; i < 6; ++i) {
        if (GamePad__2.Down(pads[i])) {
            return actions[i];
        }
    }
    return 0;
}

void MenuMouseSave(CSaveMenuClass &save) {
    if (save.CBaseMenuClass::mode != MENU_ASK_MODE_NONE || save.page != SAVE_MENU_PAGE_FILE_LIST ||
        save.phase != SAVE_LIST_PHASE_SELECT || !save.list_form) {
        return;
    }
    const int                  count = SaveSlotRows(SaveSlots, save.mode == SAVE_MENU_MODE_SAVE);
    std::vector<MenuMouseRect> rows(count);
    for (int i = std::max(0, save.top - 1); i < std::min(save.top + 4, count); ++i) {
        const float y = save.list_form->y + 80 * i;
        const float top = std::max(162.0f, y), bottom = std::min(402.0f, y + 76);
        if (bottom > top) {
            rows[i] = {save.list_form->x, top, 458, bottom - top};
        }
    }
    const int selected = MenuMouseRows(rows, save.select);
    MenuMouseDelayConfirm(&save, save.select, selected, 4);
    if (selected != save.select) {
        MenuMouseMove(&save.select, selected);
    }
}

namespace {
struct OptionHit {
    int row = -1, choice = -1;
};

// Retail stores the option count as a float; the list never has more rows than buttons.
int OptionCount() { return std::clamp(static_cast<int>(MouseOptionCount), 0, OPTION_ITEM_MAX); }

MenuMouseRect FormClip(const CMenuPosDataForm *clip) {
    return clip ? MenuMouseRect{clip->x, clip->y, float(clip->clip_w), float(clip->clip_h)}
                : MenuMouseRect{-1e9f, -1e9f, 2e9f, 2e9f};
}

// Hits follow the drawn rows, which ease towards a new scroll, and stop at the list's scissor.
// A row spans its label and its buttons, one 24-unit line centred on the buttons.
OptionHit OptionAt(const CMenuOption &menu, const CMenuPosDataForm &form, MenuMouseRect clip, float x, float y) {
    for (int row = 0; row < OptionCount(); ++row) {
        float      top = 0, right = 0;
        bool       shown = false;
        const auto choices = std::clamp(menu.choice_num[row], 0, OPTION_BUTTON_NUM);
        for (int choice = 0; choice < choices; ++choice) {
            const auto *part = menu.button[row][choice];
            if (!part || !part->draw_flag) {
                continue;
            }
            const MenuMouseRect rect{form.x + part->x, form.y + part->y, part->w, part->h};
            if (MenuMouseClip(rect, clip).Contains(x, y)) {
                return {row, choice};
            }
            top = shown ? top : rect.y + rect.h * 0.5f - 12;
            right = std::max(right, rect.x + rect.w);
            shown = true;
        }
        if (shown && MenuMouseClip({form.x - 8, top, right - form.x + 8, 24}, clip).Contains(x, y)) {
            return {row, -1};
        }
    }
    return {};
}

// The button of a row under x, or -1. Buttons keep their columns as the list scrolls.
int OptionChoiceAtX(const CMenuOption &menu, const CMenuPosDataForm &form, int row, float x) {
    for (int choice = 0; choice < std::clamp(menu.choice_num[row], 0, OPTION_BUTTON_NUM); ++choice) {
        const auto *part = menu.button[row][choice];
        if (part && x >= form.x + part->x && x < form.x + part->x + part->w) {
            return choice;
        }
    }
    return -1;
}

// The shown row under the pointer, counted from the first shown row, for the wheel; -1 off the list.
int ShownRow(int hit, int top, int visible) { return hit >= top && hit < top + visible ? hit - top : -1; }

// The inventory board slot under the pointer as drawn (40 by 50 cells easing with the board's scroll),
// inside the board's window, or -1. The shop hits its bag the same way.
int BoardHit(const MenuMouseSample &mouse, CMenuPosDataForm *board, int count) {
    if (!board || !board->draw_flag) {
        return -1;
    }
    float x, y;
    board->GetPutPosXY(nullptr, x, y);
    const float left = MenuItemBrdUnderBrdPosXY[0], top = MenuItemBrdUnderBrdPosXY[1];
    if (!MenuMouseRect{x + 16, y + 20, 240, 250}.Contains(mouse.x, mouse.y) || mouse.x < left ||
        mouse.x >= left + 240 || mouse.y < top) {
        return -1;
    }
    const int slot = int((mouse.y - top) / 50) * MENU_ITEM_BOARD_COLUMNS + int((mouse.x - left) / 40);
    return slot < count ? slot : -1;
}
} // namespace

bool MenuMouseOption(CMenuOption &menu, CMenuPosDataForm *form) {
    return MenuMouseOption(menu, form, MenuPosData ? MenuPosData->GetFormInfo(const_cast<char *>("clip0")) : nullptr);
}

bool MenuMouseOption(CMenuOption &menu, CMenuPosDataForm *form, const CMenuPosDataForm *clip) {
    const auto &mouse = MenuMouseTake();
    if (!mouse.pointing || !form || !form->draw_flag) {
        return false;
    }
    const auto hit = OptionAt(menu, *form, FormClip(clip), mouse.x, mouse.y);
    if (hit.choice < 0) {
        return false;
    }
    if (mouse.moved || (mouse.clicked & 1)) {
        menu.select = hit.row;
        menu.choice = hit.choice;
        menu.cursor_jump = true;
    }
    return true;
}

void MenuMouseOptionHover(CMenuOption &menu, CMenuPosDataForm *form, const CMenuPosDataForm *clip) {
    constexpr int kVisible = 9;
    const auto   &mouse = MenuMouseTake();
    if (!mouse.pointing || !form || !form->draw_flag || menu.mode != MENU_ASK_MODE_NONE) {
        return;
    }
    const auto    hit = OptionAt(menu, *form, FormClip(clip), mouse.x, mouse.y);
    MenuMouseView view{menu.top, menu.select};
    if (hit.row >= 0 && mouse.moved) {
        view.selected = hit.row;
    }
    view = MenuMouseScroll(mouse.wheel, view, OptionCount(), kVisible, ShownRow(hit.row, menu.top, kVisible));
    const bool same_row = view.selected == menu.select;
    menu.top = view.top;
    if (!same_row) {
        MenuMouseMove(&menu.select, view.selected);
    }
    const int choice = mouse.wheel != 0 && hit.row >= 0 ? OptionChoiceAtX(menu, *form, view.selected, mouse.x) : hit.choice;
    // KeyStep compares the choice after this hook, so a move along one row sounds here.
    if (choice >= 0 && choice != menu.choice && (mouse.moved || mouse.wheel != 0)) {
        if (same_row) {
            MenuMouseCursorSound();
        }
        menu.choice = choice;
    }
}

int MenuMouseCharaSelect(CMenuPosDataForm &form, unsigned party, int npc_no, int select) {
    // Each portrait's ring is a target while its character, or the townsperson, is shown.
    MenuMouseRect rows[CHR_CNG_SELECT_NPC + 1]{};
    for (int i = 0; i <= CHR_CNG_SELECT_NPC; ++i) {
        char name[8];
        std::snprintf(name, sizeof name, "fc%d", i);
        const auto *ring = form.GetPartInfo(name);
        if (ring && ((party & (1u << i)) || (i == CHR_CNG_SELECT_NPC && npc_no > 0))) {
            rows[i] = {form.x + ring->x, form.y + ring->y, ring->w, ring->h};
        }
    }
    return MenuMouseRows(rows, select, 0);
}

MenuMouseCharaInput MenuMouseCharaInputFor(int mode, int sub_menu, int page, int step, int change_phase, int open_wait) {
    if (mode != MENU_ASK_MODE_NONE || sub_menu != CHR_CNG_SUB_MENU_NONE) {
        return MenuMouseCharaInput::Retail;
    }
    if (page == CHR_CNG_PAGE_SELECT && step == CHR_CNG_STEP_SELECT && open_wait <= 0) {
        return change_phase ? MenuMouseCharaInput::Locked : MenuMouseCharaInput::Portraits;
    }
    if (page == CHR_CNG_PAGE_NPC && step == CHR_CNG_NPC_STEP_REPAIR_SELECT) {
        return MenuMouseCharaInput::RepairBoard;
    }
    // Opening waits and townsperson speech take any button; their questions use drawn message choices.
    return MenuMouseCharaInput::Retail;
}

void MenuMouseRepairBoard(CMenuPosDataForm *board, int &select, int &top, int count) {
    constexpr int kColumns = MENU_ITEM_BOARD_COLUMNS, kRows = MENU_ITEM_BOARD_ROWS;
    const auto   &mouse = MenuMouseTake();
    if (!mouse.pointing) {
        return;
    }
    const int hit = BoardHit(mouse, board, count);
    int       target = select;
    if (hit >= 0 && (mouse.moved || (mouse.clicked & 1))) {
        target = hit;
    }
    const int  column = (hit >= 0 ? hit : target) % kColumns;
    const auto view = MenuMouseScroll(mouse.wheel, {top, target / kColumns}, (count + kColumns - 1) / kColumns, kRows,
                                      hit >= 0 ? ShownRow(hit / kColumns, top, kRows) : -1);
    top = view.top;
    target = std::clamp(view.selected * kColumns + column, 0, std::max(0, count - 1));
    if (target != select) {
        select = target;
        MenuMouseCursorSound();
    }
    // The board owns this tick's buttons, as the shop's does: Cedric's command list stays drawn behind
    // it, and its choices must neither move nor swallow a click. Repairs spend his points, so only a
    // click on an item confirms; right click backs out.
    MenuMouseClaimButtons(((mouse.clicked & 1) && hit >= 0 ? PAD_CROSS : 0) | (mouse.clicked & 2 ? PAD_CIRCLE : 0));
}

void MenuMouseChara(CMenuChrCngMenu &menu) {
    if (menu_debug_flag || !menu.form) {
        return;
    }
    switch (MenuMouseCharaInputFor(menu.mode, menu.sub_menu, menu.key_arg_no, menu.step, menu.change_phase, menu.open_wait)) {
        case MenuMouseCharaInput::Retail:
            return;
        case MenuMouseCharaInput::Locked:
            // A character change is loading; retail ignores the cursor, and a click must not ask again.
            if (MenuMouseTake().clicked & 1) {
                MenuMouseSetButtons(MenuMouseButtons() & ~PAD_CROSS);
            }
            return;
        case MenuMouseCharaInput::RepairBoard:
            MenuMouseRepairBoard(MenuPosData ? MenuPosData->GetFormInfo(const_cast<char *>("itembrd")) : nullptr,
                                 menu.item_brd_select, menu.item_brd_pos, GetNowBagMax(ITEM_BOARD_MAIN));
            return;
        case MenuMouseCharaInput::Portraits:
            break;
    }
    const int selected = MenuMouseCharaSelect(*menu.form, menu.party_member, menu.npc_no, menu.select);
    if (selected == menu.select) {
        return;
    }
    // KeyChangeMain reads its cursor change after this hook; repeat that change's effects here.
    const int last = menu.select;
    menu.select = selected;
    MenuMouseCursorSound();
    if (selected == CHR_CNG_SELECT_NPC) {
        MenuDCMsg[0]->SetBuff(menu.mes_data);
    }
    if (last == CHR_CNG_SELECT_NPC) {
        MenuDCMsg[0]->SetBuff(menu.sys_mes);
    }
}

void MenuMouseManual(CManualMenu &menu, CMenuPosDataForm *background, const CMenuPosDataForm *clip) {
    constexpr int kEntries = 46, kVisible = 10;
    const auto   &mouse = MenuMouseTake();
    if (menu.mode != MENU_ASK_MODE_NONE || !mouse.pointing) {
        return;
    }
    if (menu.key_arg_no == MANUAL_STEP_PLAY && menu.pict_mode && mouse.wheel != 0) {
        // Picture pages turn with the wheel through the retail Left/Right page keys.
        MenuMousePress(mouse.wheel < 0 ? PAD_RIGHT : PAD_LEFT);
        return;
    }
    if (menu.key_arg_no != MANUAL_STEP_SELECT || !background) {
        return;
    }
    int left = 0, top = 0, right = 0, bar = 0;
    background->GetPutPosXY(const_cast<char *>("base_msg"), left, top);
    background->GetPutPosXY(const_cast<char *>("scrlbase"), right, bar);
    // Entries are hit where they are drawn as the list eases to a new scroll, inside its scissor.
    std::vector<MenuMouseRect> rows(kEntries);
    for (int i = 0; i < kEntries; ++i) {
        rows[i] = MenuMouseClip({left - 8.0f, menu.list_y + 24 * i - 4, right - left + 4.0f, 24}, FormClip(clip));
    }
    const int     hovered = MenuMouseRows(rows, menu.select, 0);
    const int     hit = MenuMouseHit(rows, mouse.x, mouse.y);
    MenuMouseView view = MenuMouseScroll(mouse.wheel, {menu.top, hovered}, kEntries, kVisible, ShownRow(hit, menu.top, kVisible));
    menu.top = view.top;
    if (view.selected != menu.select) {
        MenuMouseMove(&menu.select, view.selected);
    }
}
