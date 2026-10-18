#include "common.h"

#include <algorithm>
#include <array>
#include <cmath>
#include <cstdlib>
#include <span>
#include <vector>

#include "dngfloor.hpp"
#include "dngmenu.hpp"
#include "dngmenu_port.hpp"
#include "floor_monsters.hpp"
#include "gamepad.hpp"
#include "menu_mouse_floor.hpp"
#include "menuaqua.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menusys.hpp"
#include "mglib_port.hpp"
#include "nd_meswin.hpp"
#include "stubs/dngmenu.hpp"

namespace {
CDngFloorManager *pending_manager = nullptr;
GLID_INFO        *pending_room = nullptr;
int               pending_frame = -1;

// Longest path a wheel turn walks, past any retail floor count.
constexpr int kMaxWheelSteps = 32;
// Ticks after the floor information opens in which a click is still taken as the room's double click.
constexpr int kInfoDoubleClickTicks = 20;
int           info_opened = -1;
int           info_seen = -1;

GLID_INFO *FloorRoom(std::span<GLID_INFO> cells, int floor_id) {
    const auto found = std::ranges::find_if(
        cells, [floor_id](const GLID_INFO &cell) { return cell.type == GLID_TYPE_ROOM && cell.room.floor_id == floor_id; });
    return floor_id >= 0 && found != cells.end() ? &*found : nullptr;
}

// A left click on a drawn help label presses the button its symbol shows.
bool ClickLabel(const ClsMes &message, int lines, const MenuMouseSample &mouse) {
    if (!mouse.pointing || !(mouse.clicked & 1)) {
        return false;
    }
    for (int line = 0; line < lines; ++line) {
        const int button = MenuMouseLabelButton(message, line);
        if (button != 0 && MenuMouseLabelRect(message, line).Contains(mouse.x, mouse.y)) {
            MenuMouseRows({}, 0);
            MenuMouseLanguageClicks();
            MenuMousePress(button);
            return true;
        }
    }
    return false;
}

// The floor information, its questions and the materials list.
void FloorScreenMouse() {
    const auto &mouse = MenuMouseTake();
    // The floor monster list's Triangle prompt is a help label like retail's.
    if (const ClsMes *hint = floor_monsters::DrawnHint(); hint != nullptr && ClickLabel(*hint, 1, mouse)) {
        return;
    }
    if (CMenuTreePt->key_arg_no == DNG_TREE_MAP_SCREEN_FLOOR && dngfloor_infoview &&
        DngAskMessageDrawFlag == DNG_TREE_MAP_ASK_JUMP && MenuDCMsg[3]) {
        if (info_seen != mgPortFrameCount() - 1 && info_seen != mgPortFrameCount()) {
            info_opened = mgPortFrameCount();
        }
        info_seen = mgPortFrameCount();
        if (ClickLabel(*MenuDCMsg[3], 3, mouse)) {
            return;
        }
        // A left click anywhere then enters the floor, as Cross does, but not the second click of the double
        // click on a room that opened it.
        if (mgPortFrameCount() - info_opened < kInfoDoubleClickTicks) {
            MenuMouseRows({}, 0);
        }
    }
    // The start, side, boss and exit questions, the information-only view and the materials list take the shared
    // clicks in the language's layout.
    MenuMouseLanguageClicks();
}
} // namespace

GLID_INFO *MenuMouseFloorStep(std::span<GLID_INFO> cells, GLID_INFO *from, int notches) {
    // At a fork the wheel keeps to the branch the Right key continues along, as the map draws it.
    constexpr std::array onward = {GLID_DIR_RIGHT, GLID_DIR_DOWN, GLID_DIR_UP, GLID_DIR_LEFT};
    constexpr std::array back = {GLID_DIR_LEFT, GLID_DIR_UP, GLID_DIR_DOWN, GLID_DIR_RIGHT};
    const int            steps = std::min(std::abs(notches), kMaxWheelSteps);
    for (int n = 0; from != nullptr && from->type == GLID_TYPE_ROOM && n < steps; ++n) {
        GLID_INFO *next = nullptr;
        for (const auto dir : notches > 0 ? onward : back) {
            GLID_INFO *room = FloorRoom(cells, from->room.key_room[dir]);
            if (room != nullptr && room->room.selectable == 1 &&
                (notches > 0 ? room->room.order > from->room.order : room->room.order < from->room.order)) {
                next = room;
                break;
            }
        }
        if (next == nullptr) {
            break;
        }
        from = next;
    }
    return from;
}

bool MenuMouseFloor() {
    if (DngTreeMode == DNG_TREE_MODE_SAVE) {
        return false;
    }
    if (!CMenuTreePt || !MenuDngMap || !MenuDngMap->floor_manager || CMenuTreePt->mode != MENU_ASK_MODE_NONE) {
        return true;
    }
    if (CMenuTreePt->key_arg_no != DNG_TREE_MAP_SCREEN_MAP) {
        FloorScreenMouse();
        return true;
    }
    auto                      *manager = MenuDngMap->floor_manager;
    const std::span<GLID_INFO> cells{manager->glid_info, static_cast<std::size_t>(std::max(0, manager->glid_num))};
    const auto                 extent = mgPortVisibleUiExtent(gfx::kMainTarget);
    std::vector<MenuMouseRect> rows;
    std::vector<GLID_INFO *>   rooms;
    int                        selected = 0;
    for (auto &cell : cells) {
        if (cell.type != GLID_TYPE_ROOM || cell.room.selectable != 1) {
            continue;
        }
        float x = 0;
        float y = 0;
        MenuDngMap->CalcGlidPutPos(&cell, x, y, 0);
        if (&cell == CMenuTreePt->select_glid) {
            selected = static_cast<int>(rows.size());
        }
        // A room DrawRoomOne culls takes no clicks.
        const auto picture = PortDngRoomPicture(MenuDngMap->dng_no, cell.room, x, y, extent.right, extent.bottom);
        rooms.push_back(&cell);
        rows.push_back(picture ? MenuMouseRect{.x = picture->left, .y = picture->top, .w = picture->right, .h = picture->bottom}
                               : MenuMouseRect{});
    }
    // The help line's labels are Back to Map or Exit Dungeon (Square) and Save Progress (Triangle).
    const auto &mouse = MenuMouseTake();
    if (CMenuTreePt->help_view && !menu_debug_flag && MenuDCMsg[6] && ClickLabel(*MenuDCMsg[6], 2, mouse)) {
        return true;
    }
    const int hit = MenuMouseRows(rows, selected, 0);
    MenuMouseLanguageClicks();
    GLID_INFO *target = nullptr;
    if (!rooms.empty() && hit != selected) {
        target = rooms[hit];
    } else if (mouse.pointing && mouse.wheel != 0 && std::isfinite(mouse.wheel)) {
        target = MenuMouseFloorStep(cells, CMenuTreePt->select_glid, -static_cast<int>(mouse.wheel));
    }
    if (target != nullptr && target != CMenuTreePt->select_glid) {
        // Feed the selected room into the retail directional transition, which
        // refreshes its help, camera position, light and previous-room state.
        pending_manager = manager;
        pending_room = target;
        pending_frame = mgPortFrameCount();
        MenuMousePress(PAD_DOWN);
    }
    return true;
}

PORT_OVERRIDE GLID_INFO *CDngFloorManager::GetKeyNextRoom(int floor_id, int dir, GLID_INFO * /*previous*/) {
    if (pending_manager == this && pending_frame == mgPortFrameCount()) {
        auto *room = pending_room;
        pending_manager = nullptr;
        return room;
    }
    auto *room = GetDngMapFloorGlidInfo(floor_id);
    if (!room || room->type != GLID_TYPE_ROOM) {
        return nullptr;
    }
    return GetDngMapFloorGlidInfo(room->room.key_room[dir]);
}
