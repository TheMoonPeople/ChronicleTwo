#pragma once
#include <menumap.hpp>
extern CWorldMapMenu  *WorldMapPtr asm("MenuMouse_WorldMap");
extern signed char     WorldMapMenuType asm("MenuMouse_WorldMapType");
extern WMAP_AREA_DATA *spi_wmaparea_tbl asm("MenuMouse_WorldAreas");
extern short           spi_wmaparea_tblnum asm("MenuMouse_WorldAreaCount");
