#pragma once

struct CGameDataUsed;

inline constexpr int kEventItemMenuOpenUseItem = 9;
inline constexpr int kEventItemMenuOpenUseItemFish = 22;
inline constexpr int kEventItemWhitelistMax = 10;

struct EventItemBagSlot {
    int  item_no = 0;
    int  used_type = 0;
    int  spectol_no = 0;
};

int PortCountEventItemWhitelistIds(const int *menu_param, int param_capacity);

// Single required item id for auto-use: GOTO_USE_ITEM uses param[0]==1 and one id in param[1+];
// GOTO_USE_ITEM2 often passes the id directly in param[0] with param[1]==0.
bool PortRequiredEventItemId(const int *menu_param, int param_capacity, int *required_item_id);

bool PortEventItemBagSlotEligible(const EventItemBagSlot &slot);

bool PortTryResolveEventItemFromParams(int menu_open_type, bool host_enabled, const int *menu_param, int param_capacity,
                                       const EventItemBagSlot *bag_slots, int bag_slot_count, int *result_item_no,
                                       int *result_bag_index);

bool PortTryAutoResolveEventItem(int menu_open_type, const int *menu_param, CGameDataUsed *bag_slots, int bag_slot_count,
                                 int *result_item_no, int *result_bag_index);
