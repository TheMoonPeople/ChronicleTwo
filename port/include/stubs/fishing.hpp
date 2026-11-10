#pragma once

class FISH_PLACE_MAP;

/** Native fishing-place loading fills the place table the fishing game reads. */
extern int             FishPlaceMapNum asm("Fishing_PlaceMapCount");
extern FISH_PLACE_MAP *FishPlaceMap asm("Fishing_PlaceMaps");
