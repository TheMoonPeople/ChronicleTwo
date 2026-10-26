#pragma once

class FISH_PLACE_MAP;
struct SubGameInfo;

/** Native fishing-place loading fills the place table the fishing game reads. */
extern int             FishPlaceMapNum asm("Fishing_PlaceMapCount");
extern FISH_PLACE_MAP *FishPlaceMap asm("Fishing_PlaceMaps");

/** The rod's L3/R3 act only once the game has loaded (loop mode 1) and while Max walks with the rod. */
extern int CharaMode asm("Fishing_CharaMode");
extern int fgLoopMode asm("Fishing_LoopMode");
/** The bait on the hook, -1 once a catch or a lost bait empties it, whatever is left on the rod. */
extern int LocalEsaNo asm("Fishing_LocalEsaNo");

int PortRetailLoopFishing(SubGameInfo *info) asm("Fishing_LoopFishing");
