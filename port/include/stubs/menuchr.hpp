#pragma once
#include <menuchr.hpp>

#include "texture_color.hpp"

extern CMenuChrCngMenu *ChrChangMenuPt asm("MenuMouse_ChrChange");

void                   PortRetailInitMainCharaBG(int, mgCMemory *, int) asm("MenuChr_InitMainCharaBG");
int                    PortRetailKeyMainCharaBG() asm("MenuChr_KeyMainCharaBG");
extern CMenuMosSelect *MenuMosSelectPtr asm("MenuMouse_MosSelect");
extern CMenuCostumeSel *MenuCosPtr asm("MenuMouse_Costume");
extern short            MenuCosutumeLoadPhase asm("MenuMouse_CostumeLoadPhase");
