#pragma once

#include "dngmenu.hpp"
#include "menumap.hpp"

// Retail menu statics the map adapters read, under the link names port/include/stubs gives them.
extern CDngFreeMap    *MouseDngMap asm("MenuMouse_DngMap");
extern CMenuTreeMap   *MouseTree asm("MenuMouse_Tree");
extern short           MouseTreeMode asm("MenuMouse_TreeMode");
extern u8              MouseFloorInfoView asm("MenuMouse_FloorInfoView");
extern s8              MouseFloorAsk asm("MenuMouse_FloorAsk");
extern CWorldMapMenu  *MouseWorldMap asm("MenuMouse_WorldMap");
extern signed char     MouseWorldMapType asm("MenuMouse_WorldMapType");
extern WMAP_AREA_DATA *MouseWorldAreas asm("MenuMouse_WorldAreas");
extern short           MouseWorldAreaCount asm("MenuMouse_WorldAreaCount");
