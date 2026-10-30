#include "common.h"

#include <cstddef>
#include <iterator>

#include "gamedata.hpp"
#include "stubs/gamedata.hpp"

namespace {

/**
 * Gives an item's entry in one of the item-family tables, or null when its list number lies outside
 * both the table's loaded count and its storage.
 */
template <typename Record, std::size_t Count>
Record *TableEntry(Record *table, int count, Record (&storage)[Count], int list_no) {
    if (table == nullptr || list_no < 0 || list_no >= count) {
        return nullptr;
    }
    // Every table points at its retail storage, which bounds the count a script may claim.
    if (table == std::begin(storage) && static_cast<std::size_t>(list_no) >= Count) {
        return nullptr;
    }
    return &table[list_no];
}

} // namespace

// Retail checks each item's list number against the count the item script claims, never against the
// table's storage, and accepts negative list numbers; the native getters check both.
CDataWeapon *CGameData::GetWeaponData(int item_no) {
    const CDataCommon *record = GetCommonData(item_no);
    if (record == nullptr || ConvertUsedItemType(record->type) != USED_ITEM_TYPE_WEAPON) {
        return nullptr;
    }
    return TableEntry(weapon_data, weapon_num, local_weapondata, record->list_no);
}

CDataItem *CGameData::GetItemData(int item_no) {
    const CDataCommon *record = GetCommonData(item_no);
    if (record == nullptr) {
        return nullptr;
    }
    const int type = ConvertUsedItemType(record->type);
    if (type != USED_ITEM_TYPE_ITEM && type != USED_ITEM_TYPE_GIFT_BOX && type != USED_ITEM_TYPE_BOILED) {
        return nullptr;
    }
    return TableEntry(item_data, item_num, local_itemdata, record->list_no);
}

CDataAttach *CGameData::GetAttachData(int item_no) {
    const CDataCommon *record = GetCommonData(item_no);
    if (record == nullptr || ConvertUsedItemType(record->type) != USED_ITEM_TYPE_ATTACH) {
        return nullptr;
    }
    return TableEntry(attach_data, attach_num, local_attachdata, record->list_no);
}

CDataRoboPart *CGameData::GetRoboData(int item_no) {
    const CDataCommon *record = GetCommonData(item_no);
    if (record == nullptr) {
        return nullptr;
    }
    return TableEntry(robo_data, robo_num, local_robodata, record->list_no);
}

CDataBreedFish *CGameData::GetFishData(int item_no) {
    const CDataCommon *record = GetCommonData(item_no);
    if (record == nullptr || ConvertUsedItemType(record->type) != USED_ITEM_TYPE_FISH) {
        return nullptr;
    }
    return TableEntry(fish_data, fish_num, local_fishdata, record->list_no);
}

s16 *CGameData::GetGuardData(int item_no) {
    const CDataCommon *record = GetCommonData(item_no);
    if (record == nullptr) {
        return nullptr;
    }
    return TableEntry(guard_data, guard_num, local_guarddata, record->list_no);
}
