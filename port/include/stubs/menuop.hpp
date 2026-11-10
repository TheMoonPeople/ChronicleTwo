#pragma once
#include <menuop.hpp>
// The Options cursor's bottom limit, reaching the selected row's place in the settled list.
int PortOptionCursorBottom(int limit, int cursor_y, int form_y, int rest_form_y);

extern CSaveMenuClass *SaveMenuPtr asm("MenuMouse_Save");
// Let the PC page wrap the original Options step without replacing its state machine.
extern CMenuOption *CMenuOptionPtr asm("MenuOption_Current");
// The menu pointer reads the option count and the Help list it scrolls.
extern float        config_option_num_i asm("MenuOption_Count");
extern CManualMenu *CManualPtr asm("MenuMouse_Manual");
