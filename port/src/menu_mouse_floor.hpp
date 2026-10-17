#pragma once

#include <span>

#include "menu_mouse.hpp"

struct GLID_INFO;

// The picture a tree-map room at put position x, y draws, as CDngFreeMap::DrawRoomOne places it,
// or an empty rect when DrawRoomOne culls it past right, bottom.
MenuMouseRect MenuMouseFloorRect(const GLID_INFO &room, float x, float y, int dng_no, float right, float bottom);
// The room a wheel turn of notches (positive onward) reaches through the arrow keys' neighbours.
GLID_INFO *MenuMouseFloorStep(std::span<GLID_INFO> cells, GLID_INFO *from, int notches);

bool MenuMouseFloor();
