#include "common.h"

#include <vector>

#include "menu_mouse_floor.hpp"
#include "menu_mouse_map.hpp"
#include "menu_mouse_retail.hpp"
#include "menuaqua.hpp"
#include "menucls1.hpp"
#include "menucommon.hpp"
#include "menumain.hpp"
#include "menumap.hpp"
#include "snd_mngr.hpp"

std::vector<MenuMouseRect> MenuMouseWorldMapRows(std::span<const WMAP_AREA_DATA> areas, const MenuMouseRect &name) {
    std::vector<MenuMouseRect> rows(areas.size() + 1);
    // Retail draws each 20x30 mark centred on the area; the nearest two areas are 74 units apart.
    for (std::size_t i = 1; i < areas.size(); ++i) {
        if (areas[i].enable) {
            rows[i] = {float(areas[i].x - 20), float(areas[i].y - 24), 40, 48};
        }
    }
    rows.back() = name;
    return rows;
}

bool MenuMouseWorldMap() {
    if (MouseWorldMapType == WORLD_MAP_MENU_TREE_MAP) {
        return MenuMouseFloor();
    }
    auto *map = MouseWorldMap;
    if (!map || !MouseWorldAreas || MouseWorldAreaCount <= 0 || map->mode != WORLD_MAP_MODE_RUN ||
        map->view_only || menu_debug_flag || MenuCommonInfo->open_type == MENU_OPEN_WORLD_MOVE) {
        return false;
    }
    if (map->step != WORLD_MAP_STEP_AREA) {
        // The place list, travel question and notice take the shared clicks in the language's layout.
        MenuMouseLanguageClicks();
        return false;
    }
    if (!map->cursor_tex || !map->cursor_view) {
        return false;
    }
    // The name frame Draw put beside the current area confirms that area.
    MenuMouseRect name{};
    if (map->name_view && MenuDCMsg[4]) {
        const auto &mes = *MenuDCMsg[4];
        name = {float(mes.line_pos[0][0] - 16), float(mes.line_pos[0][1] - 12), float(mes.line_w[0] + 30), 46};
    }
    const int  count = MouseWorldAreaCount;
    const auto rows = MenuMouseWorldMapRows({MouseWorldAreas, std::size_t(count)}, name);
    // The name row is the selection, so only a hovered or clicked mark moves it; the wheel does not.
    const int picked = MenuMouseRows(rows, count, 0);
    MenuMouseLanguageClicks();
    if (picked > 0 && picked < count && picked != map->area_no) {
        map->area_no = picked;
        MenuSePlay(SYSTEM_SE_CURSOR);
    }
    return true;
}
