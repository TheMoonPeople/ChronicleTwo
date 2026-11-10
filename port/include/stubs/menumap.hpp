#pragma once

class mgCMemory;
class CWorldMapMenu;
struct WMAP_POS_DATA;
struct WMAP_AREA_DATA;

/** Native world-map loading fills the world-map tables the menu reads. */
extern short           spi_wmappos_tblnum asm("MenuMap_PositionCount");
extern WMAP_POS_DATA  *spi_wmappos_tbl asm("MenuMap_Positions");
extern short           spi_wmaparea_tblnum asm("MenuMap_AreaCount");
extern WMAP_AREA_DATA *spi_wmaparea_tbl asm("MenuMap_Areas");
extern mgCMemory      *spi_wmapstack asm("MenuMap_Stack");
extern short           MapEnableNum asm("MenuMap_EnabledAreaCount");
/** The open world map and which of its screens it shows, for the menu mouse. */
extern CWorldMapMenu *WorldMapPtr asm("MenuMap_WorldMap");
extern signed char    WorldMapMenuType asm("MenuMap_WorldMapType");
