#include "common.h"

#include <algorithm>
#include <array>
#include <vector>

#include "gamepad.hpp"
#include "mainloop.hpp"
#include "menu_mouse.hpp"
#include "menu_mouse_floor.hpp"
#include "menu_mouse_item.hpp"
#include "menu_mouse_make.hpp"
#include "menu_mouse_map.hpp"
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
#include "stubs/dngmenu.hpp"
#include "stubs/menuchr.hpp"
#include "stubs/menuop.hpp"
#include "title.hpp"

extern CItemSelect  *MouseItemSelect asm("MenuMouse_ItemSelect");
extern CMenuInter   *MouseInter asm("MenuMouse_Inter");
extern TITLE_INFO   *MouseTitle asm("MenuMouse_Title");
extern short         MouseTitlePhase asm("MenuMouse_TitlePhase");
extern unsigned char MouseTitleHDD asm("MenuMouse_TitleHDD");

namespace {
void RootMouse() {
    if (!MouseInter || !MenuPosData || MouseInter->step != MENU_INTER_STEP_SELECT || MouseInter->next_mode >= 0) {
        return;
    }
    std::vector<MenuMouseRect> rows;
    for (int i = 0; i < MouseInter->select_num; ++i) {
        auto *form = MenuPosData->GetFormInfo(GetMenuMainIconChar(MouseInter->mode_list[i]));
        rows.push_back(form ? MenuMouseRect{.x = form->x - 20, .y = form->y - 4, .w = 190, .h = 30} : MenuMouseRect{});
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
            cells[i] = {.x = items.item_rect.left + 44 * (i % ITEM_SELECT_COLUMNS), .y = items.item_rect.top + 55 * row, .w = 44, .h = 55};
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
            rows[i] = {.x = (mgScreenWidth - 210) * 0.5f, .y = static_cast<float>((MouseTitleHDD ? 76 : 100) + 58 * i), .w = 210, .h = 54};
        }
        const int selected = MenuMouseRows({rows, static_cast<std::size_t>(count)}, MouseTitle->select);
        if (selected != MouseTitle->select) {
            MouseTitle->select = selected;
            MouseTitle->idle_count = 0;
            MenuMouseCursorSound();
        }
    } else if ((MouseTitlePhase <= TITLE_PHASE_PUSH_START) && (MenuMouseTake().clicked & 1)) {
        MenuMousePress(PAD_START);
    }
}
} // namespace

PORT_OVERRIDE int CMenuKeyFunc::CheckSelectKey() {
    if (now_mode == MENU_MODE_SHOP) {
        MenuMouseShopTick(*this);
    }
    if (key_enable) {
        if (now_mode == MENU_MODE_CHARA_CHANGE && ChrChangMenuPt) {
            MenuMouseChara(*ChrChangMenuPt);
        }
        if (now_mode == MENU_MODE_OPTION && CMenuOptionPtr && MenuPosData) {
            MenuMouseOptionHover(*CMenuOptionPtr, MenuPosData->GetFormInfo(const_cast<char *>("Op_Switch")),
                                 MenuPosData->GetFormInfo(const_cast<char *>("clip0")));
        }
        if (now_mode == MENU_MODE_MANUAL && CManualPtr && MenuPosData) {
            MenuMouseManual(*CManualPtr, MenuPosData->GetFormInfo(const_cast<char *>("op_bg")),
                            MenuPosData->GetFormInfo(const_cast<char *>("clip0")));
        }
        if (now_mode == MENU_MODE_MAIN_TOWN || now_mode == MENU_MODE_MAIN_DUNGEON) {
            RootMouse();
        }
        if (now_mode == MENU_MODE_DNG_TREE_MAP) {
            MenuMouseFloor();
        }
        if (now_mode == MENU_MODE_WORLD_MOVE) {
            MenuMouseWorldMap();
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

namespace {
void SaveListMouse(CSaveMenuClass &save) {
    if (save.CBaseMenuClass::mode != MENU_ASK_MODE_NONE || save.page != SAVE_MENU_PAGE_FILE_LIST ||
        save.phase != SAVE_LIST_PHASE_SELECT || !save.list_form) {
        return;
    }
    const int                  count = SaveSlotRows(SaveSlots, save.mode == SAVE_MENU_MODE_SAVE);
    std::vector<MenuMouseRect> rows(count);
    for (int i = std::max(0, save.top - 1); i < std::min(save.top + 4, count); ++i) {
        const float y = save.list_form->y + 80 * i;
        const float top = std::max(162.0f, y);
        const float bottom = std::min(402.0f, y + 76);
        if (bottom > top) {
            rows[i] = {.x = save.list_form->x, .y = top, .w = 458, .h = bottom - top};
        }
    }
    const int selected = MenuMouseRows(rows, save.select);
    MenuMouseDelayConfirm(&save, save.select, selected, 4);
    if (selected != save.select) {
        MenuMouseMove(&save.select, selected);
    }
}
} // namespace

void MenuMouseSave(CSaveMenuClass &save) {
    SaveListMouse(save);
    // The floor map's Save Progress hands its clicks to this screen; keep them in the language's layout
    // through the file list and the save question. Other save screens keep the shared clicks.
    if (DngTreeMode == DNG_TREE_MODE_SAVE && MenuCommonInfo && MenuCommonInfo->now_mode == MENU_MODE_DNG_TREE_MAP) {
        MenuMouseLanguageClicks();
    }
}

namespace {
// Rows the retail Options list shows at once.
constexpr int kOptionRows = 9;
// The retail Help list's entries and the rows it shows at once.
constexpr int kHelpEntries = 46;
constexpr int kHelpRows = 10;
// The Character page's portrait rings, by select.
constexpr std::array<const char *, CHR_CNG_SELECT_NPC + 1> kPortraitRings{"fc0", "fc1", "fc2", "fc3", "fc4"};

struct OptionHit {
    int row = -1, choice = -1;
};

// Retail stores the option count as a float; the list never has more rows than buttons.
int OptionCount() { return std::clamp(static_cast<int>(config_option_num_i), 0, OPTION_ITEM_MAX); }

// Half the extent of a clip that bounds nothing.
constexpr float kUnboundedClip = 1e9f;

MenuMouseRect FormClip(const CMenuPosDataForm *clip) {
    return clip ? MenuMouseRect{.x = clip->x, .y = clip->y, .w = static_cast<float>(clip->clip_w), .h = static_cast<float>(clip->clip_h)}
                : MenuMouseRect{.x = -kUnboundedClip, .y = -kUnboundedClip, .w = 2 * kUnboundedClip, .h = 2 * kUnboundedClip};
}

// Hits follow the drawn rows, which ease towards a new scroll, and stop at the list's scissor.
// A row spans its label and its buttons, one 24-unit line centred on the buttons.
OptionHit OptionAt(const CMenuOption &menu, const CMenuPosDataForm &form, MenuMouseRect clip, float x, float y) {
    for (int row = 0; row < OptionCount(); ++row) {
        float      top = 0;
        float      right = 0;
        bool       shown = false;
        const auto choices = std::clamp(menu.choice_num[row], 0, OPTION_BUTTON_NUM);
        for (int choice = 0; choice < choices; ++choice) {
            const auto *part = menu.button[row][choice];
            if (!part || !part->draw_flag) {
                continue;
            }
            const MenuMouseRect rect{.x = form.x + part->x, .y = form.y + part->y, .w = part->w, .h = part->h};
            if (MenuMouseClip(rect, clip).Contains(x, y)) {
                return {.row = row, .choice = choice};
            }
            top = shown ? top : rect.y + rect.h * 0.5f - 12;
            right = std::max(right, rect.x + rect.w);
            shown = true;
        }
        if (shown && MenuMouseClip({.x = form.x - 8, .y = top, .w = right - form.x + 8, .h = 24}, clip).Contains(x, y)) {
            return {.row = row};
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

} // namespace

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
    const auto &mouse = MenuMouseTake();
    if (!mouse.pointing || !form || !form->draw_flag || menu.mode != MENU_ASK_MODE_NONE) {
        return;
    }
    const auto    hit = OptionAt(menu, *form, FormClip(clip), mouse.x, mouse.y);
    MenuMouseView view{.top = menu.top, .selected = menu.select};
    if (hit.row >= 0 && mouse.moved) {
        view.selected = hit.row;
    }
    view = MenuMouseScroll(mouse.wheel, view, OptionCount(), kOptionRows, ShownRow(hit.row, menu.top, kOptionRows));
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
    std::array<MenuMouseRect, CHR_CNG_SELECT_NPC + 1> rows{};
    for (int i = 0; i <= CHR_CNG_SELECT_NPC; ++i) {
        const auto *ring = MenuMouseFindPart(&form, kPortraitRings[i]);
        if (ring && ((party & (1u << i)) || (i == CHR_CNG_SELECT_NPC && npc_no > 0))) {
            rows[i] = {.x = form.x + ring->x, .y = form.y + ring->y, .w = ring->w, .h = ring->h};
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
    const auto &mouse = MenuMouseTake();
    if (!mouse.pointing) {
        return;
    }
    const int hit = menumouse::BagHit({.x = mouse.x, .y = mouse.y}, board, count);
    int       target = select;
    if (hit >= 0 && (mouse.moved || (mouse.clicked & 1))) {
        target = hit;
    }
    const int  column = (hit >= 0 ? hit : target) % MENU_ITEM_BOARD_COLUMNS;
    const auto view = MenuMouseScroll(mouse.wheel, {.top = top, .selected = target / MENU_ITEM_BOARD_COLUMNS},
                                      (count + MENU_ITEM_BOARD_COLUMNS - 1) / MENU_ITEM_BOARD_COLUMNS, MENU_ITEM_BOARD_ROWS,
                                      hit >= 0 ? ShownRow(hit / MENU_ITEM_BOARD_COLUMNS, top, MENU_ITEM_BOARD_ROWS) : -1);
    top = view.top;
    target = std::clamp(view.selected * MENU_ITEM_BOARD_COLUMNS + column, 0, std::max(0, count - 1));
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
    const auto &mouse = MenuMouseTake();
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
    int left = 0;
    int top = 0;
    int right = 0;
    int bar = 0;
    background->GetPutPosXY(const_cast<char *>("base_msg"), left, top);
    background->GetPutPosXY(const_cast<char *>("scrlbase"), right, bar);
    // Entries are hit where they are drawn as the list eases to a new scroll, inside its scissor.
    std::array<MenuMouseRect, kHelpEntries> rows{};
    for (int i = 0; i < kHelpEntries; ++i) {
        rows[i] = MenuMouseClip({.x = left - 8.0f, .y = menu.list_y + 24 * i - 4, .w = right - left + 4.0f, .h = 24}, FormClip(clip));
    }
    const int     hovered = MenuMouseRows(rows, menu.select, 0);
    const int     hit = MenuMouseHit(rows, mouse.x, mouse.y);
    MenuMouseView view = MenuMouseScroll(mouse.wheel, {.top = menu.top, .selected = hovered}, kHelpEntries, kHelpRows,
                                         ShownRow(hit, menu.top, kHelpRows));
    menu.top = view.top;
    if (view.selected != menu.select) {
        MenuMouseMove(&menu.select, view.selected);
    }
}
