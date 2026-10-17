#include "event_item_auto_use.hpp"

#include "gamedata.hpp"
#include "platform/config.hpp"
#include "userdata.hpp"

int PortCountEventItemWhitelistIds(const int *menu_param, int param_capacity) {
    if (menu_param == nullptr || param_capacity < 2) {
        return 0;
    }

    int count = 0;

    for (int i = 0; i < kEventItemWhitelistMax; i++) {
        const int index = i + 1;

        if (index >= param_capacity) {
            break;
        }

        const int item_id = menu_param[index];

        if (item_id <= 0) {
            break;
        }

        count++;
    }

    return count;
}

bool PortRequiredEventItemId(const int *menu_param, int param_capacity, int *required_item_id) {
    if (menu_param == nullptr || required_item_id == nullptr || param_capacity < 1) {
        return false;
    }

    const int tail_count = PortCountEventItemWhitelistIds(menu_param, param_capacity);

    if (menu_param[0] == 1) {
        if (tail_count != 1) {
            return false;
        }

        *required_item_id = menu_param[1];
        return *required_item_id > 0;
    }

    if (tail_count == 0 && menu_param[0] > 1) {
        *required_item_id = menu_param[0];
        return true;
    }

    return false;
}

bool PortEventItemBagSlotEligible(const EventItemBagSlot &slot) {
    if (slot.item_no <= 0) {
        return false;
    }

    if (0 < slot.spectol_no) {
        return false;
    }

    if (slot.used_type == USED_ITEM_TYPE_BOILED) {
        return false;
    }

    return true;
}

static bool PortTryResolveEventItemBag(int required_item, const EventItemBagSlot *bag_slots, int bag_slot_count,
                                       int *result_item_no, int *result_bag_index) {
    for (int i = 0; i < bag_slot_count; i++) {
        const EventItemBagSlot &slot = bag_slots[i];

        if (!PortEventItemBagSlotEligible(slot)) {
            continue;
        }

        if (slot.item_no == required_item) {
            *result_item_no = required_item;
            *result_bag_index = i;
            return true;
        }
    }

    return false;
}

bool PortTryResolveEventItemFromParams(int menu_open_type, bool host_enabled, const int *menu_param, int param_capacity,
                                       const EventItemBagSlot *bag_slots, int bag_slot_count, int *result_item_no,
                                       int *result_bag_index) {
    if (!host_enabled || menu_param == nullptr || bag_slots == nullptr || result_item_no == nullptr ||
        result_bag_index == nullptr) {
        return false;
    }

    if (menu_open_type != kEventItemMenuOpenUseItem) {
        return false;
    }

    int required_item = 0;

    if (!PortRequiredEventItemId(menu_param, param_capacity, &required_item)) {
        return false;
    }

    return PortTryResolveEventItemBag(required_item, bag_slots, bag_slot_count, result_item_no, result_bag_index);
}

bool PortTryAutoResolveEventItem(int menu_open_type, const int *menu_param, CGameDataUsed *bag_slots, int bag_slot_count,
                                 int *result_item_no, int *result_bag_index) {
    if (!ConfigGet().auto_use_event_item || bag_slots == nullptr || menu_param == nullptr || result_item_no == nullptr ||
        result_bag_index == nullptr) {
        return false;
    }

    if (menu_open_type != kEventItemMenuOpenUseItem) {
        return false;
    }

    int required_item = 0;

    if (!PortRequiredEventItemId(menu_param, 16, &required_item)) {
        return false;
    }

    for (int i = 0; i < bag_slot_count; i++) {
        CGameDataUsed &entry = bag_slots[i];
        EventItemBagSlot slot;
        slot.item_no = entry.item_no;
        slot.used_type = entry.used_type;
        slot.spectol_no = entry.GetSpectolNo();

        if (!PortEventItemBagSlotEligible(slot)) {
            continue;
        }

        if (entry.item_no == required_item) {
            *result_item_no = required_item;
            *result_bag_index = i;
            return true;
        }
    }

    return false;
}
