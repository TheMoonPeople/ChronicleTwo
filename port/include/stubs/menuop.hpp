#pragma once
#include <menuop.hpp>
// The Options cursor's bottom limit; see header_fixups.UNIT_FIXUPS.
int PortOptionCursorBottom(int limit, int cursor_y, int form_y, int rest_form_y);

extern CSaveMenuClass *SaveMenuPtr asm("MenuMouse_Save");
// Let the PC page wrap the original Options step without replacing its state machine.
extern CMenuOption *CMenuOptionPtr asm("MenuOption_Current");
