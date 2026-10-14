#pragma once

extern unsigned char GameBootInit asm("Title_GameBootInit");

#include <title.hpp>
extern TITLE_INFO   *TitleInfo asm("MenuMouse_Title");
extern short         TitlePhase asm("MenuMouse_TitlePhase");
extern unsigned char TitleHDDCheckFlag asm("MenuMouse_TitleHDD");
class ClsMes;
extern ClsMes       *TitleMCCheckMes asm("Title_MCCheckMes");
