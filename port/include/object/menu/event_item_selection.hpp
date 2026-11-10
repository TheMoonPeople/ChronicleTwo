#pragma once

#include <span>

class CGameDataUsed;

/**
 * The bag place whose item an event's request takes without the item picker, or -1 when the picker is needed.
 * The request, MENU_INIT_ARG::param, names exactly one item, and the place is the first the picker lists with it.
 */
int PortEventItemPlace(std::span<const int> param, std::span<CGameDataUsed> bag);
