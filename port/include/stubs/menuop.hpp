#pragma once
#include <menuop.hpp>
extern CSaveMenuClass *SaveMenuPtr asm("MenuMouse_Save");
// Let the PC page wrap the original Options step without replacing its state machine.
extern CMenuOption *CMenuOptionPtr asm("MenuOption_Current");
// The menu pointer reads the option count and the Help list it scrolls.
extern float        config_option_num_i asm("MenuOption_Count");
extern CManualMenu *CManualPtr asm("MenuMouse_Manual");
