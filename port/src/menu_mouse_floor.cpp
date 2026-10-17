#include "common.h"

#include <vector>

#include "dngfloor.hpp"
#include "dngmenu.hpp"
#include "floor_monsters.hpp"
#include "gamepad.hpp"
#include "menu_mouse.hpp"
#include "menuaqua.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menusys.hpp"
#include "mglib_port.hpp"

extern CDngFreeMap  *MouseDngMap asm("MenuMouse_DngMap");
extern CMenuTreeMap *MouseTree asm("MenuMouse_Tree");
extern short         MouseTreeMode asm("MenuMouse_TreeMode");

namespace {
CDngFloorManager *pending_manager = nullptr;
GLID_INFO        *pending_room = nullptr;
int               pending_frame = -1;
} // namespace

bool MenuMouseFloor() {
    if (MouseTreeMode == DNG_TREE_MODE_SAVE) {
        return false;
    }
    // The floor monster list's Triangle hint is a label: a click on it opens the list instead of confirming.
    if (floor_monsters::ClickHint()) {
        return true;
    }
    if (!MouseTree || !MouseDngMap || !MouseDngMap->floor_manager ||
        MouseTree->mode != MENU_ASK_MODE_NONE || MouseTree->key_arg_no != DNG_TREE_MAP_SCREEN_MAP) {
        return true;
    }
    std::vector<MenuMouseRect> rows;
    std::vector<GLID_INFO *>   rooms;
    auto                      *manager = MouseDngMap->floor_manager;
    int                        selected = 0;
    for (int i = 0; i < manager->glid_num; ++i) {
        auto *room = &manager->glid_info[i];
        if (room->type != GLID_TYPE_ROOM || room->room.selectable != 1) {
            continue;
        }
        float x = 0, y = 0;
        MouseDngMap->CalcGlidPutPos(room, x, y, 0);
        if (room == MouseTree->select_glid) {
            selected = static_cast<int>(rooms.size());
        }
        rooms.push_back(room);
        rows.push_back({x - 30 + room->room.offset_x, y - 42 + room->room.offset_y, 96, 66});
    }
    const auto &mouse = MenuMouseTake();
    // The save command is the retail Triangle action at the bottom of the map.
    if (TreeMapSaveFlag && MenuDCMsg[6]) {
        const auto   &help = *MenuDCMsg[6];
        MenuMouseRect save{float(help.line_pos[1][0]), float(help.line_pos[1][1] - 8),
                           float(help.line_w[1]), 32};
        if (mouse.pointing && save.Contains(mouse.x, mouse.y) && (mouse.clicked & 1)) {
            MenuMouseRows({}, selected);
            MenuMousePress(PAD_TRIANGLE);
            return true;
        }
    }
    const int hit = MenuMouseRows(rows, selected);
    if (!rooms.empty() && hit != selected) {
        // Feed the hovered room into the retail directional transition, which
        // refreshes its help, camera position, light and previous-room state.
        pending_manager = manager;
        pending_room = rooms[hit];
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
