#pragma once

#include <vlgr_info.hpp>

/** Native villager loading fills the place, villager and story progress tables. */
extern int                 PlaceInfoNum asm("VlgrInfo_PlaceInfoNum");
extern CVillagerPlaceInfo *PlaceInfo asm("VlgrInfo_PlaceInfo");
extern int                 VlgrInfoNum asm("VlgrInfo_VlgrInfoNum");
extern CVillagerInfo      *VlgrInfo asm("VlgrInfo_VlgrInfo");
extern int                 ProgressNum asm("VlgrInfo_ProgressNum");
extern CVillagerPlace      VlgrPlace[VLGR_PLACE_MAX];
extern GAME_PROGRESS_INFO  ProgressInfo[GAME_PROGRESS_MAX];
