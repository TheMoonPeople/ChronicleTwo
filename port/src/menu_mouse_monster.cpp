#include "menu_mouse_monster.hpp"

#include <algorithm>
#include <cmath>
#include <cstdio>

#include "gamepad.hpp"
#include "mainloop.hpp"
#include "menuchr.hpp"
#include "menucommon.hpp"
#include "menumain.hpp"
#include "menusys.hpp"
#include "mglib_port.hpp"
#include "stubs/menuchr.hpp"

namespace {
CMenuMosSelect *box_keys = nullptr;
int             tick_frame = -1;

void BadgeMouse(CMenuMosSelect &box) {
    MenuMouseRect cells[MOS_SELECT_BADGE_NUM]{};
    for (int i = 0; i < MOS_SELECT_BADGE_NUM; ++i) {
        char name[8];
        std::snprintf(name, sizeof(name), "B%d", i);
        // AttachForm hides the parts of badges Monica does not have.
        cells[i] = MenuMouseBadgeCell(MenuMousePart(box.badge_form, name));
    }
    // Badges are three to a row, as KeyStep's own select / 3 assumes; a wheel notch moves one row.
    const int selected = MenuMouseRows(cells, box.select, 3);
    if (selected == box.select) {
        return;
    }
    // KeyNormalMode's own side effects of a cursor move.
    box.select = selected;
    MenuLoadInfo.update_scene = false;
    box.view_monster = -1;
    if (selected < MOS_SELECT_BADGE_KIND_NUM && box.badge[selected].enable) {
        box.view_monster = box.badge[selected].monster_id;
    }
    MenuMouseCursorSound();
}

void ClassMouse() {
    const int  count = std::clamp(BuildUpWeaponInfo.select_num, 0, 3);
    const auto rows = MenuMouseBuildUpRows(BuildUpNameXY, count, LanguageCode);
    const int  selected = MenuMouseRows({rows.data(), static_cast<std::size_t>(count)}, BuildUpWeaponInfo.select_no);
    if (selected != BuildUpWeaponInfo.select_no) {
        BuildUpWeaponInfo.select_no = selected;
        MenuMouseCursorSound();
    }
}
} // namespace

MenuMouseRect MenuMouseBadgeCell(const MenuMouseRect &badge) {
    if (badge.w <= 0 || badge.h <= 0) {
        return {};
    }
    return {.x = badge.x - 1, .y = badge.y - 1, .w = badge.w + 2, .h = badge.h + 2};
}

void MenuMouseMonsterTick(CMenuKeyFunc &keys) {
    if (box_keys) {
        MenuMouseMonster(*box_keys, keys);
    }
}

void MenuMouseMonster(CMenuMosSelect &box, CMenuKeyFunc &keys) {
    if (&keys != MenuCommonInfo || !keys.key_enable || tick_frame == mgPortFrameCount()) {
        return;
    }
    tick_frame = mgPortFrameCount();
    const auto &mouse = MenuMouseTake();
    if (!mouse.pointing || GamePad__2.key_lock || menu_debug_flag || box.mode != MENU_ASK_MODE_NONE) {
        return;
    }
    if (box.key_arg_no == MOS_SELECT_PAGE_BADGE) {
        BadgeMouse(box);
    } else if (box.key_arg_no == MOS_SELECT_PAGE_COMMAND && box.step == MOS_SELECT_STEP_CLASS_SELECT &&
               BuildUpWeaponInfo.mode == 1) {
        ClassMouse();
    } else if (box.key_arg_no == MOS_SELECT_PAGE_STATUS) {
        // The status page has no pointer targets: a left click must not send its rejected Cross.
        // The wheel steps through the badge's forms, as L1 and R1 do.
        int buttons = mouse.clicked & 2 ? PAD_CIRCLE : 0;
        if (std::isfinite(mouse.wheel) && mouse.wheel != 0) {
            buttons |= mouse.wheel > 0 ? PAD_L1 : PAD_R1;
        }
        MenuMouseSetButtons(buttons);
    }
}

PORT_OVERRIDE int MenuMonsterBoxKey() {
    // The box's keys are read only inside its own key step.
    box_keys = MenuMosSelectPtr;
    const int result = MenuMosSelectPtr->KeyStep();
    box_keys = nullptr;
    return result;
}
