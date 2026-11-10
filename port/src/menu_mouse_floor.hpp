#pragma once

#include <span>

#include "menu_mouse.hpp"

struct GLID_INFO;

// The room a wheel turn of notches (positive onward) reaches through the arrow keys' neighbours.
GLID_INFO *MenuMouseFloorStep(std::span<GLID_INFO> cells, GLID_INFO *from, int notches);

bool MenuMouseFloor();
