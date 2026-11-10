#pragma once
#include <dngmenu.hpp>
extern CDngFreeMap  *MenuDngMap asm("MenuMouse_DngMap");
extern CMenuTreeMap *CMenuTreePt asm("MenuMouse_Tree");
extern short         DngTreeMode asm("MenuMouse_TreeMode");
extern u8            dngfloor_infoview asm("MenuMouse_FloorInfoView");
extern s8            DngAskMessageDrawFlag asm("MenuMouse_FloorAsk");
extern int           DngInfoDrawAlpha asm("MenuMouse_FloorDrawAlpha");
extern u8            GeoramaMateriaInfoDrawFlag asm("MenuMouse_FloorMateriaShown");
extern s8            GeoramaMateriaInfoDrawPage asm("MenuMouse_FloorMateriaPage");
extern short         GeoramaMateriaNum asm("MenuMouse_FloorMateriaNum");
