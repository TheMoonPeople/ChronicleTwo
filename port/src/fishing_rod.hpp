#pragma once

// While Max walks with a fishing rod out (the fishing game's control mode), L3 fills the rod's bait from the bag and
// R3 puts his weapon back in place of the rod, ending fishing as closing the menu with a weapon equipped would
// (port/src/fishing.cpp).

class CGameDataUsed;
class CUserDataManager;
struct CDataCommon;

// The common data of an item number; the game's is GetCommonItemData.
using FishingItemLookup = CDataCommon *(*)(int item_no);

enum FishingRebait {
    FISHING_REBAIT_NONE = 0,    // nothing fits, or the rod's bait is already full
    FISHING_REBAIT_TOP_UP = 1,  // more of the kind already on the rod
    FISHING_REBAIT_CHANGED = 2, // a new bait (the Lure Rod's lure) went on, which fishing must load
};

// Fills the bait of Max's rod from the item board: more of the kind on it, or, when it holds none, the kind last used,
// else the first item that fits the rod (bait on the Fishing Rod, a lure on the Lure Rod), as the menu puts it on.
FishingRebait FishingRodRebait(CUserDataManager *user, int last_bait, FishingItemLookup lookup);

// Whether L3 has fishing load the rod's bait again: a new bait went on, or the hook is empty while the rod still holds
// some. A catch or a lost bait empties the hook but takes only one from the stack on the rod.
bool FishingRodReloads(FishingRebait result, bool hook_empty, int bait_left);

// The first of Max's melee weapons on the item board, for putting the rod away when the weapon it replaced is unknown.
CGameDataUsed *FishingRodFallbackWeapon(CUserDataManager *user, FishingItemLookup lookup);
