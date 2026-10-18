#include "common.h"

#include <cstddef>
#include <iterator>

#include "bounded_text.hpp"
#include "gamedata.hpp"
#include "scriptinterpreter.hpp"
#include "stubs/gamedata.hpp"

namespace {

/**
 * Whether an index lies inside an array.
 */
template <typename Array>
bool Inside(const Array &array, int index) {
    return index >= 0 && static_cast<std::size_t>(index) < std::size(array);
}

} // namespace

// Retail writes each common item record through a cursor that runs past the 432-entry table and
// indexes the item-number lookup with the record's item number unchecked; the native tag drops
// records past the table and numbers outside the lookup.
PORT_OVERRIDE int _DATACOM(SPI_STACK *stack, int /*unused*/) {
    if (!Inside(local_com_itemdata, comdatapt_num)) {
        return 1;
    }

    CDataCommon &record = local_com_itemdata[comdatapt_num];
    record.item_no = spiGetStackInt(stack++);
    record.type = spiGetStackInt(stack++);
    record.list_no = spiGetStackInt(stack++);
    record.active_set = spiGetStackInt(stack++);
    record.stack_num = spiGetStackInt(stack++);
    record.max_num = spiGetStackInt(stack++);
    if (ConvertUsedItemType(record.type) == USED_ITEM_TYPE_WEAPON && record.max_num > 0x64) {
        record.max_num = 0x90;
    }
    record.icon_texture_no = spiGetStackInt(stack++);
    record.icon_no = spiGetStackInt(stack++);
    record.message_no = spiGetStackInt(stack++);
    if (const char *file_name = spiGetStackString(stack++)) {
        bounded_text::Copy(record.file_name, file_name);
    }
    record.attribute = spiGetStackInt(stack);
    record.name = nullptr;

    if (Inside(local_itemdatano_converttable, record.item_no)) {
        local_itemdatano_converttable[record.item_no] = comdatapt_num;
    }
    comdatapt = &record;
    ++comdatapt;
    ++comdatapt_num;
    return 1;
}

// Retail advances the weapon cursor past the 116-entry table; the cursor becomes null at its end, which
// every other weapon tag already treats as no weapon.
PORT_OVERRIDE int _DATAWEP_BUILDUP(SPI_STACK *stack, int count) {
    if (SpiWeaponPt == nullptr) {
        return 1;
    }

    SpiWeaponPt->buildup_weapon[0] = spiGetStackInt(stack++);
    SpiWeaponPt->buildup_weapon[1] = spiGetStackInt(stack++);
    SpiWeaponPt->buildup_weapon[2] = spiGetStackInt(stack++);
    if (count > 3) {
        SpiWeaponPt->buildup_monster[0] = spiGetStackInt(stack++);
        SpiWeaponPt->buildup_monster[1] = spiGetStackInt(stack++);
        SpiWeaponPt->buildup_monster[2] = spiGetStackInt(stack);
    }

    if (++SpiWeaponPt == std::end(local_weapondata)) {
        SpiWeaponPt = nullptr;
    }
    return 1;
}

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
PORT_OVERRIDE CDataWeapon *CGameData::GetWeaponData(int item_no) {
    const CDataCommon *record = GetCommonData(item_no);
    if (record == nullptr || ConvertUsedItemType(record->type) != USED_ITEM_TYPE_WEAPON) {
        return nullptr;
    }
    return TableEntry(weapon_data, weapon_num, local_weapondata, record->list_no);
}

PORT_OVERRIDE CDataItem *CGameData::GetItemData(int item_no) {
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

PORT_OVERRIDE CDataAttach *CGameData::GetAttachData(int item_no) {
    const CDataCommon *record = GetCommonData(item_no);
    if (record == nullptr || ConvertUsedItemType(record->type) != USED_ITEM_TYPE_ATTACH) {
        return nullptr;
    }
    return TableEntry(attach_data, attach_num, local_attachdata, record->list_no);
}

PORT_OVERRIDE CDataRoboPart *CGameData::GetRoboData(int item_no) {
    const CDataCommon *record = GetCommonData(item_no);
    if (record == nullptr) {
        return nullptr;
    }
    return TableEntry(robo_data, robo_num, local_robodata, record->list_no);
}

PORT_OVERRIDE CDataBreedFish *CGameData::GetFishData(int item_no) {
    const CDataCommon *record = GetCommonData(item_no);
    if (record == nullptr || ConvertUsedItemType(record->type) != USED_ITEM_TYPE_FISH) {
        return nullptr;
    }
    return TableEntry(fish_data, fish_num, local_fishdata, record->list_no);
}

PORT_OVERRIDE s16 *CGameData::GetGuardData(int item_no) {
    const CDataCommon *record = GetCommonData(item_no);
    if (record == nullptr) {
        return nullptr;
    }
    return TableEntry(guard_data, guard_num, local_guarddata, record->list_no);
}

// Retail advances the attachment cursor past the 38-entry table; it becomes null at the table's end,
// which the other attachment tags already treat as no attachment.
PORT_OVERRIDE int _DATAATTACH_ST_SP(SPI_STACK *stack, int /*unused*/) {
    if (SpiAttach == nullptr) {
        return 1;
    }
    SpiAttach->special = spiGetStackInt(stack);
    if (++SpiAttach == std::end(local_attachdata)) {
        SpiAttach = nullptr;
    }
    return 1;
}
