#pragma once

// Retail menu draw state and entry points that the port's overrides call back into.
extern short                  use_trans_rect asm("MenuDraw_IconSheet");
extern struct MENU_SHORT_RECT item_transtbl[2] asm("MenuDraw_IconUV");
extern float                  MenuWakuPutXY[2] asm("MenuDraw_WakuPosition");
