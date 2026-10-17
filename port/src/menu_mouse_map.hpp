#pragma once

#include <span>
#include <vector>

#include "menu_mouse.hpp"

struct WMAP_AREA_DATA;

// One mark per area-table index (area 0 and locked areas stay empty), then the drawn name frame.
std::vector<MenuMouseRect> MenuMouseWorldMapRows(std::span<const WMAP_AREA_DATA> areas, const MenuMouseRect &name);

bool MenuMouseWorldMap();
