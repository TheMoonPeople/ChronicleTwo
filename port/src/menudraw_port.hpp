#pragma once
#include "menudraw.hpp"

// Retail icon-cell and animated window-band state used by native menu draws.
extern short           PortIconSheet asm("MenuDraw_IconSheet");
extern MENU_SHORT_RECT PortIconUV[2] asm("MenuDraw_IconUV");
extern float           PortMenuWakuPosition[2] asm("MenuDraw_WakuPosition");

// Whole-tile grid phase and contiguous coverage in logical screen coordinates.
float MenuTilePatternFirst(float phase, int size, float minimum);
int   MenuTilePatternCount(float first, int size, float limit);

/**
 * Aligns the English PAL character board's central grey slot with its portrait and surrounding slots.
 */
void MenuAlignCharacterSlot(CMenuPosDataForm &form);
