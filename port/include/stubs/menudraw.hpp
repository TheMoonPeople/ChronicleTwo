#pragma once

// Retail menu draw state and entry points that the port's overrides call back into.
class mgCDrawPrim;

extern short                  use_trans_rect asm("MenuDraw_IconSheet");
extern struct MENU_SHORT_RECT item_transtbl[2] asm("MenuDraw_IconUV");
extern float                  MenuWakuPutXY[2] asm("MenuDraw_WakuPosition");
void                          PortRetailDrawMenuFillBox(int, int, int, int) asm("MenuDraw_DrawMenuFillBox");
void                          PortRetailMenuMainFrameModeSet(int mode, int restart) asm("MenuDraw_MenuMainFrameModeSet");
void                          PortRetailMenuMainFrameStep() asm("MenuDraw_MenuMainFrameStep");
void                          PortRetailMenuMainFrameImgDraw(int &tex_block) asm("MenuDraw_MenuMainFrameImgDraw");
void                          PortRetailSetSpriteEnv(mgCDrawPrim *prim, int mode) asm("MenuDraw_SetSpriteEnv");
