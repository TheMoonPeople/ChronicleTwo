#pragma once
#include "menudraw.hpp"

// Retail icon-cell and animated window-band state used by native menu draws.
extern short           PortIconSheet asm("MenuDraw_IconSheet");
extern MENU_SHORT_RECT PortIconUV[2] asm("MenuDraw_IconUV");
extern float           PortMenuWakuPosition[2] asm("MenuDraw_WakuPosition");

// Whole-tile grid phase and contiguous coverage in logical screen coordinates.
float MenuTilePatternFirst(float phase, int size, float minimum);
int   MenuTilePatternCount(float first, int size, float limit);

class CDC2Mes;

// Whether a form lies outside retail's screen, where retail parks unused panels, in a window that
// shows past that screen. MenuFormDraw hides or clips such a form; a message form is classified
// once it is laid out, by MenuMessageParked.
bool MenuFormParked(const CMenuPosDataForm &form);

// Whether a menu message window, laid out by StepMsg and put by SetPutPos for this frame, draws
// only past the screen's right edge in a window that shows past it.
bool MenuMessageParked(CDC2Mes &mes);

// True while MenuFormDraw draws the message form that shows mes.
bool MenuFormDrawsMessage(const CDC2Mes &mes);

/**
 * Aligns the English PAL character board's central grey slot with its portrait and surrounding slots.
 */
void MenuAlignCharacterSlot(CMenuPosDataForm &form);
