#pragma once

#include "menu_mouse.hpp"

class CMenuKeyFunc;
class CMenuMosSelect;

// A drawn badge's hit cell. Badges are 64 units square, 66 apart; the cell covers the gap between them.
MenuMouseRect MenuMouseBadgeCell(const MenuMouseRect &badge);

// Called from CheckSelectKey; acts only while MenuMonsterBoxKey runs the box's key step.
void MenuMouseMonsterTick(CMenuKeyFunc &keys);
// The box's pointer input for one key step.
void MenuMouseMonster(CMenuMosSelect &box, CMenuKeyFunc &keys);
