#pragma once

class CEditMap;
class CMenuGeorama;

// Expose the Georama menu's town, menu and buildable-part table to its native part list.
extern CEditMap     *MenuMainMapInfo asm("EditMenu_MainMapInfo");
extern CMenuGeorama *CMenuGeoPt asm("EditMenu_Georama");
extern int           PartsMakeOkTable[256] asm("EditMenu_PartsMakeOkTable");
extern int           PartsMakeOkTableNum asm("EditMenu_PartsMakeOkTableNum");
