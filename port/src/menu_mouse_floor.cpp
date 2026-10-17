#include "common.h"

#include <algorithm>
#include <cmath>
#include <vector>

#include "dngfloor.hpp"
#include "dngmenu.hpp"
#include "gamepad.hpp"
#include "menu_mouse_floor.hpp"
#include "menu_mouse_retail.hpp"
#include "menuaqua.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menusys.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "nd_meswin.hpp"

namespace {
CDngFloorManager *pending_manager = nullptr;
GLID_INFO        *pending_room = nullptr;
int               pending_frame = -1;

// Retail DrawRoomOne culls rooms past its 512x480 screen. A port that draws the floor map's
// flanks (PortDngMapVisibleRight on fix/floor-select-widescreen) moves these edges with it.
float FloorDrawRight() { return float(mgScreenWidth); }

float FloorDrawBottom() { return float(mgScreenHeight); }

GLID_INFO *FloorRoom(std::span<GLID_INFO> cells, int floor_id) {
    if (floor_id < 0) {
        return nullptr;
    }
    for (auto &cell : cells) {
        if (cell.type == GLID_TYPE_ROOM && cell.room.floor_id == floor_id) {
            return &cell;
        }
    }
    return nullptr;
}

// A left click on a drawn help label presses the button its symbol shows.
bool ClickLabel(const ClsMes &message, int lines, const MenuMouseSample &mouse) {
    if (!mouse.pointing || !(mouse.clicked & 1)) {
        return false;
    }
    for (int line = 0; line < lines; ++line) {
        const int button = MenuMouseLabelButton(message, line);
        if (button && MenuMouseLabelRect(message, line).Contains(mouse.x, mouse.y)) {
            MenuMouseRows({}, 0);
            MenuMouseLanguageClicks();
            MenuMousePress(button);
            return true;
        }
    }
    return false;
}
} // namespace

MenuMouseRect MenuMouseFloorRect(const GLID_INFO &cell, float x, float y, int dng_no, float right, float bottom) {
    if (x > right + 20 || y > bottom + 30) {
        return {};
    }
    const auto   &room = cell.room;
    MenuMouseRect rect{x - 30, y - 42, 96, 66};
    if (dng_no == 4 || dng_no == 5 || dng_no == 6) {
        rect.w = 100;
        rect.h = 68;
    }
    if (room.visited) {
        if (room.flag & (DNGMAP_ROOM_FLAG_SUB | DNGMAP_ROOM_FLAG_BOSS)) {
            rect.w = rect.h = 96;
        }
        rect.x += room.offset_x;
        rect.y += room.offset_y;
    }
    return rect;
}

GLID_INFO *MenuMouseFloorStep(std::span<GLID_INFO> cells, GLID_INFO *from, int notches) {
    // At a fork the wheel keeps to the branch the Right key continues along, as the map draws it.
    constexpr int onward[] = {GLID_DIR_RIGHT, GLID_DIR_DOWN, GLID_DIR_UP, GLID_DIR_LEFT};
    constexpr int back[] = {GLID_DIR_LEFT, GLID_DIR_UP, GLID_DIR_DOWN, GLID_DIR_RIGHT};
    for (int n = 0; from && from->type == GLID_TYPE_ROOM && n < std::min(std::abs(notches), 32); ++n) {
        GLID_INFO *next = nullptr;
        for (const int dir : notches > 0 ? onward : back) {
            auto *room = FloorRoom(cells, from->room.key_room[dir]);
            if (room && room->room.selectable == 1 &&
                (notches > 0 ? room->room.order > from->room.order : room->room.order < from->room.order)) {
                next = room;
                break;
            }
        }
        if (!next) {
            break;
        }
        from = next;
    }
    return from;
}

bool MenuMouseFloor() {
    if (MouseTreeMode == DNG_TREE_MODE_SAVE) {
        return false;
    }
    if (!MouseTree || !MouseDngMap || !MouseDngMap->floor_manager || MouseTree->mode != MENU_ASK_MODE_NONE) {
        return true;
    }
    if (MouseTree->key_arg_no != DNG_TREE_MAP_SCREEN_MAP) {
        const auto &mouse = MenuMouseTake();
        if (MouseTree->key_arg_no == DNG_TREE_MAP_SCREEN_FLOOR && MouseFloorInfoView &&
            MouseFloorAsk == DNG_TREE_MAP_ASK_JUMP && MenuDCMsg[3]) {
            // Only the floor information's own labels act on a left click, so a double click on a room
            // cannot travel.
            if (ClickLabel(*MenuDCMsg[3], 3, mouse)) {
                return true;
            }
            MenuMouseRows({}, 0);
        }
        // The start, side, boss and exit questions, the information-only view and the materials list
        // take the shared clicks in the language's layout.
        MenuMouseLanguageClicks();
        return true;
    }
    auto                      *manager = MouseDngMap->floor_manager;
    std::span<GLID_INFO>       cells{manager->glid_info, static_cast<std::size_t>(std::max(0, manager->glid_num))};
    std::vector<MenuMouseRect> rows;
    std::vector<GLID_INFO *>   rooms;
    int                        selected = 0;
    for (auto &cell : cells) {
        if (cell.type != GLID_TYPE_ROOM || cell.room.selectable != 1) {
            continue;
        }
        float x = 0, y = 0;
        MouseDngMap->CalcGlidPutPos(&cell, x, y, 0);
        if (&cell == MouseTree->select_glid) {
            selected = static_cast<int>(rows.size());
        }
        rooms.push_back(&cell);
        rows.push_back(MenuMouseFloorRect(cell, x, y, MouseDngMap->dng_no, FloorDrawRight(), FloorDrawBottom()));
    }
    // The help line's labels are Back to Map or Exit Dungeon (Square) and Save Progress (Triangle).
    const auto &mouse = MenuMouseTake();
    if (MouseTree->help_view && !menu_debug_flag && MenuDCMsg[6] && ClickLabel(*MenuDCMsg[6], 2, mouse)) {
        return true;
    }
    const int hit = MenuMouseRows(rows, selected, 0);
    MenuMouseLanguageClicks();
    GLID_INFO *target = nullptr;
    if (!rooms.empty() && hit != selected) {
        target = rooms[hit];
    } else if (mouse.pointing && mouse.wheel != 0 && std::isfinite(mouse.wheel)) {
        target = MenuMouseFloorStep(cells, MouseTree->select_glid, -static_cast<int>(mouse.wheel));
    }
    if (target && target != MouseTree->select_glid) {
        // Feed the hovered room into the retail directional transition, which
        // refreshes its help, camera position, light and previous-room state.
        pending_manager = manager;
        pending_room = target;
        pending_frame = mgPortFrameCount();
        MenuMousePress(PAD_DOWN);
    }
    return true;
}

PORT_OVERRIDE GLID_INFO *CDngFloorManager::GetKeyNextRoom(int floor_id, int dir, GLID_INFO *previous) {
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
