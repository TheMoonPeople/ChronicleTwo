#include "common.h"
#include "mw_runtime.h"

#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "dataread.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "menucommon.hpp"
#include "mg_memory.hpp"
#include "savedata.hpp"
#include "scriptinterpreter.hpp"
#include "userdata.hpp"

s8 etcitem_spectol_table[0x1A9][2] = {
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {11, 2},
    {11, 2},
    {11, 2},
    {0,  2},
    {11, 2},
    {11, 2},
    {6,  2},
    {3,  2},
    {2,  2},
    {6,  2},
    {11, 2},
    {5,  2},
    {2,  2},
    {1,  2},
    {5,  2},
    {1,  2},
    {11, 2},
    {11, 2},
    {10, 2},
    {4,  2},
    {3,  2},
    {0,  2},
    {2,  2},
    {4,  2},
    {0,  2},
    {1,  2},
    {1,  2},
    {4,  2},
    {11, 2},
    {10, 2},
    {4,  2},
    {5,  2},
    {1,  1},
    {1,  1},
    {4,  2},
    {0,  2},
    {4,  2},
    {10, 2},
    {10, 2},
    {2,  2},
    {3,  2},
    {5,  2},
    {0,  2},
    {0,  2},
    {4,  2},
    {4,  2},
    {1,  2},
    {4,  2},
    {3,  2},
    {3,  2},
    {6,  2},
    {3,  2},
    {11, 2},
    {1,  1},
    {0,  2},
    {0,  2},
    {0,  2},
    {3,  2},
    {4,  2},
    {4,  2},
    {1,  1},
    {1,  1},
    {1,  1},
    {3,  2},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {4,  2},
    {4,  2},
    {4,  2},
    {3,  2},
    {6,  2},
    {0,  2},
    {1,  2},
    {5,  2},
    {11, 2},
    {5,  2},
    {0,  2},
    {0,  2},
    {2,  2},
    {3,  2},
    {2,  2},
    {2,  2},
    {2,  2},
    {2,  2},
    {5,  2},
    {5,  2},
    {4,  2},
    {1,  2},
    {1,  2},
    {2,  2},
    {3,  2},
    {0,  2},
    {11, 2},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {6,  2},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {11, 2},
    {11, 2},
    {11, 2},
    {11, 2},
    {11, 2},
    {11, 2},
    {11, 2},
    {11, 2},
    {11, 2},
    {11, 2},
    {11, 2},
    {11, 2},
    {11, 2},
    {11, 2},
    {11, 2},
    {0,  2},
    {6,  2},
    {6,  2},
    {1,  2},
    {0,  2},
    {11, 2},
    {10, 1},
    {7,  2},
    {5,  2},
    {1,  2},
    {7,  2},
    {11, 2},
    {0,  2},
    {4,  2},
    {0,  2},
    {1,  2},
    {2,  2},
    {3,  2},
    {5,  2},
    {7,  2},
    {4,  2},
    {6,  2},
    {0,  2},
    {10, 0},
    {11, 2},
    {5,  2},
    {11, 2},
    {10, 1},
    {11, 2},
    {6,  2},
    {11, 2},
    {11, 2},
    {11, 2},
    {3,  2},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {0,  2},
    {1,  1},
    {1,  1},
    {7,  2},
    {1,  1},
    {6,  2},
    {6,  2},
    {7,  2},
    {4,  2},
    {0,  2},
    {6,  2},
    {6,  2},
    {7,  2},
    {7,  2},
    {7,  2},
    {7,  2},
    {7,  2},
    {7,  2},
    {7,  2},
    {7,  2},
    {7,  2},
    {7,  2},
    {7,  2},
    {7,  2},
    {7,  2},
    {7,  2},
    {7,  2},
    {7,  2},
    {7,  2},
    {7,  2},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {2,  2},
    {7,  2},
    {7,  2},
    {7,  2},
    {7,  2},
    {0,  2},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  1},
    {0,  2},
    {0,  3},
    {4,  2},
    {4,  2},
    {4,  2},
    {0,  2},
    {0,  2},
    {0,  2},
    {4,  2},
    {4,  2},
    {4,  2},
    {10, 2},
    {10, 2},
    {10, 2},
    {10, 2},
    {10, 2},
    {10, 2},
    {2,  2},
    {2,  2},
    {2,  2},
    {3,  2},
    {3,  2},
    {3,  2},
    {5,  2},
    {5,  2},
    {5,  2},
    {0,  2},
    {0,  2},
    {0,  2},
    {0,  2},
    {0,  2},
    {0,  2},
    {1,  1},
    {1,  1},
    {1,  1},
    {1,  2},
};

/**
 *
 * Allocator for loaded item display names.
 *
 */
static mgCMemory *gamedata_build_stack;

/**
 *
 * Common item entry receiving script values.
 *
 */
static CDataCommon *comdatapt;

/**
 *
 * Number of common item entries parsed.
 *
 */
static int comdatapt_num;

CDataWeapon *SpiWeaponPt;

CDataItem *SpiItemPt;

CDataAttach *SpiAttach;

CDataRoboPart *SpiRoboPart;

CDataBreedFish *SpiFish;

CGameData GameItemDataManage;

/**
 *
 * Common records for the master item catalog.
 *
 */
static CDataCommon local_com_itemdata[432];

/**
 *
 * Usable item records loaded from item data scripts.
 *
 */
static CDataItem local_itemdata[162];

/**
 *
 * Weapon records loaded from weapon data scripts.
 *
 */
static CDataWeapon local_weapondata[116];

/**
 *
 * Attachment records loaded from attachment data scripts.
 *
 */
static CDataAttach local_attachdata[38];

/**
 *
 * Ridepod part records loaded from part data scripts.
 *
 */
static CDataRoboPart local_robodata[68];

/**
 *
 * Breedable fish records loaded from fish data scripts.
 *
 */
static CDataBreedFish local_fishdata[20];

/**
 *
 * Guard values loaded from guard data scripts.
 *
 */
static short local_guarddata[35];

/**
 *
 * Lookup from item numbers to common-record indices.
 *
 */
static short local_itemdatano_converttable[512];

/**
 *
 * Command-message offsets offered for each item command group.
 *
 */
static signed char ItemCmdMsgTbl[33][8] = {
    {2,  3,  4,  9,  23, 26, 1,  -1},
    {9,  3,  1,  -1, 0,  0,  0,  0 },
    {10, 9,  26, 1,  -1, 0,  0,  0 },
    {15, 16, 5,  9,  1,  -1, 0,  0 },
    {5,  9,  1,  -1, 0,  0,  0,  0 },
    {30, 3,  1,  -1, 0,  0,  0,  0 },
    {2,  3,  9,  1,  -1, 0,  0,  0 },
    {3,  26, 34, -1, 0,  0,  0,  0 },
    {2,  9,  1,  -1, 0,  0,  0,  0 },
    {11, -1, 0,  0,  0,  0,  0,  0 },
    {12, -1, 0,  0,  0,  0,  0,  0 },
    {13, 5,  1,  -1, 0,  0,  0,  0 },
    {14, 45, 42, 9,  26, 1,  -1, 0 },
    {19, 5,  9,  1,  -1, 0,  0,  0 },
    {2,  3,  46, 26, 1,  -1, 0,  0 },
    {25, 9,  1,  -1, -1, 0,  0,  0 },
    {10, 22, 9,  26, 1,  -1, 0,  0 },
    {20, 5,  9,  1,  -1, 0,  0,  0 },
    {15, -1, 0,  0,  0,  0,  0,  0 },
    {16, -1, 0,  0,  0,  0,  0,  0 },
    {15, 16, -1, 0,  0,  0,  0,  0 },
    {29, -1, 0,  0,  0,  0,  0,  0 },
    {10, 3,  4,  9,  26, 1,  -1, 0 },
    {22, 9,  1,  -1, 0,  0,  0,  0 },
    {9,  1,  -1, 0,  0,  0,  0,  0 },
    {37, 9,  1,  -1, 0,  0,  0,  0 },
    {38, -1, 0,  0,  0,  0,  0,  0 },
    {43, 9,  1,  -1, 0,  0,  0,  0 },
    {44, 9,  1,  -1, 0,  0,  0,  0 },
    {15, 16, 1,  -1, 0,  0,  0,  0 },
    {47, -1, 0,  0,  0,  0,  0,  0 },
    {19, 20, 9,  1,  -1, 0,  0,  0 },
    {48, -1, 0,  0,  0,  0,  0,  0 },
};

// Code (.text)
CGameData *GetGameDataPt() {
    return &GameItemDataManage;
}

CDataItem::CDataItem() {
    use_flags = 0;
    status_flags = 0;
    value[0] = 0;
    value[1] = 0;
    value[2] = 0;
}

CDataAttach::CDataAttach() {
    memset(this, 0, sizeof(*this));
}

CDataWeapon::CDataWeapon() {
    memset(this, 0, sizeof(*this));
    durability = 0x14;
    levelup_exp = 0x14;
}

int CDataRoboPart::GetOffsetNo() { return this->offset_no; }

CDataBreedFish::CDataBreedFish() {
    memset(this, 0, sizeof(*this));
}

void CGameData::Initialize() {
    max_item_no = 0;
    common_data = local_com_itemdata;
    common_num = 0;
    item_data = local_itemdata;
    item_num = 0;
    weapon_data = local_weapondata;
    weapon_num = 0;
    guard_data = local_guarddata;
    guard_num = 0;
    attach_data = local_attachdata;
    attach_num = 0;
    robo_data = local_robodata;
    robo_num = 0;
    fish_data = local_fishdata;
    fish_num = 0;
    InitItemMes(1, 1);
}

/**
 *
 * Initializes the common item table and item number lookup.
 *
 */
int _DATACOMINIT(SPI_STACK *stack, int arg_count) {
    GameItemDataManage.common_num = spiGetStackInt(stack);
    comdatapt_num = 0;
    comdatapt = GameItemDataManage.common_data;
    memset(local_itemdatano_converttable, -1, sizeof(local_itemdatano_converttable));
    return 1;
}

/**
 *
 * Loads one common item record from game data script values.
 *
 */
int _DATACOM(SPI_STACK *stack, int arg_count) {
    char *name_stack;

    comdatapt->item_no = spiGetStackInt(stack++);
    comdatapt->type = spiGetStackInt(stack++);
    comdatapt->list_no = spiGetStackInt(stack++);
    comdatapt->active_set = spiGetStackInt(stack++);
    comdatapt->stack_num = spiGetStackInt(stack++);
    comdatapt->max_num = spiGetStackInt(stack++);

    if (ConvertUsedItemType(comdatapt->type) == USED_ITEM_TYPE_WEAPON) {
        if (comdatapt->max_num > 0x64) {
            comdatapt->max_num = 0x90;
        }
    }

    comdatapt->icon_texture_no = spiGetStackInt(stack++);
    comdatapt->icon_no = spiGetStackInt(stack++);
    comdatapt->message_no = spiGetStackInt(stack++);
    name_stack = spiGetStackString(stack++);

    if (name_stack != 0) {
        strcpy(comdatapt->file_name, name_stack);
    }

    comdatapt->attribute = spiGetStackInt(stack);
    comdatapt->name = NULL;
    local_itemdatano_converttable[comdatapt->item_no] = comdatapt_num;
    comdatapt_num += 1;
    comdatapt++;
    return 1;
}

/**
 *
 * Loads and converts a common item display name.
 *
 */
int _MES_SYS(SPI_STACK *stack, int arg_count) {
    char         converted[0x100];
    int          item_no;
    char        *copy;
    char        *text;
    CDataCommon *record;

    item_no = spiGetStackInt(stack++);
    text = spiGetStackString(stack);
    record = GameItemDataManage.GetCommonData(item_no);

    if (record != NULL) {
        if ((LanguageCode >= 2) && (LanguageCode < 6)) {
            memset(converted, 0, sizeof(converted));
            ConvertFontCode(text, converted);
            copy = mgCopyString(converted, gamedata_build_stack);
        } else {
            copy = mgCopyString(text, gamedata_build_stack);
        }

        record->name = copy;
    }

    return 1;
}

/**
 *
 * Accepts a spectol system message entry.
 *
 */
int _MES_SYS_SPECTOL(SPI_STACK *stack, int arg_count) {
    spiGetStackInt(stack++);
    spiGetStackString(stack);
    return 1;
}

/**
 *
 * Sets the weapon table count and resets its loading cursor.
 *
 */
int _DATAWEPNUM(SPI_STACK *stack, int arg_count) {
    GameItemDataManage.weapon_num = spiGetStackInt(stack);
    SpiWeaponPt = GameItemDataManage.weapon_data;
    return 1;
}

/**
 *
 * Loads weapon durability and level experience values.
 *
 */
int _DATAWEP(SPI_STACK *stack, int arg_count) {
    SPI_STACK *next;

    next = stack + 1;

    if (SpiWeaponPt == NULL) {
        return 0;
    }

    SpiWeaponPt->durability = spiGetStackInt(stack);
    SpiWeaponPt->levelup_exp = spiGetStackInt(next);
    return 1;
}

/**
 *
 * Loads the base weapon status values.
 *
 */
int _DATAWEP_ST(SPI_STACK *stack, int arg_count) {
    SPI_STACK *next;

    next = stack + 1;

    if (SpiWeaponPt == NULL) {
        return 0;
    }

    SpiWeaponPt->status[WEAPON_STAT_ATTACK] = spiGetStackInt(stack);
    SpiWeaponPt->status[WEAPON_STAT_DURABILITY] = spiGetStackInt(next);
    return 1;
}

/**
 *
 * Loads the maximum weapon status values.
 *
 */
int _DATAWEP_ST_L(SPI_STACK *stack, int arg_count) {
    SPI_STACK *next;

    next = stack + 1;

    if (SpiWeaponPt == NULL) {
        return 0;
    }

    SpiWeaponPt->status_max[WEAPON_STAT_ATTACK] = spiGetStackInt(stack);
    SpiWeaponPt->status_max[WEAPON_STAT_DURABILITY] = spiGetStackInt(next);
    return 1;
}

/**
 *
 * Loads the base weapon attribute values.
 *
 */
int _DATAWEP2_ST(SPI_STACK *stack, int arg_count) {
    int i;
    int offset;

    if (SpiWeaponPt == 0) {
        return 0;
    }

    i = 0;
    offset = 0;

    do {
        SpiWeaponPt->attribute[i] = spiGetStackInt(stack++);
        i += 1;
        offset += 2;
    } while (i < 8);

    return 1;
}

/**
 *
 * Loads the maximum weapon attribute values.
 *
 */
int _DATAWEP2_ST_L(SPI_STACK *stack, int arg_count) {
    int i;
    int offset;

    if (SpiWeaponPt == 0) {
        return 0;
    }

    i = 0;
    offset = 0;

    do {
        SpiWeaponPt->attribute_max[i] = spiGetStackInt(stack++);
        i += 1;
        offset += 2;
    } while (i < 8);

    return 1;
}

/**
 *
 * Loads weapon special settings, attack type, and model number.
 *
 */
int _DATAWEP_SPE(SPI_STACK *stack, int arg_count) {
    if (SpiWeaponPt == NULL) {
        return 0;
    }

    SpiWeaponPt->initial_fusion_point = fptoui(spiGetStackFloat(stack++));
    SpiWeaponPt->pallet_color = spiGetStackInt(stack++);
    SpiWeaponPt->unk_47 = spiGetStackInt(stack++);
    SpiWeaponPt->fusion_point = spiGetStackInt(stack++);
    SpiWeaponPt->special = spiGetStackInt(stack++);
    SpiWeaponPt->attack_type = 0;

    if (arg_count >= 6) {
        SpiWeaponPt->attack_type = spiGetStackInt(stack++);
    }

    SpiWeaponPt->model_no = 0;

    if (arg_count >= 7) {
        SpiWeaponPt->model_no = spiGetStackInt(stack);
    }

    return 1;
}

/**
 *
 * Loads weapon build-up requirements and advances the weapon cursor.
 *
 */
int _DATAWEP_BUILDUP(SPI_STACK *stack, int count) {
    SpiWeaponPt->buildup_weapon[0] = spiGetStackInt(stack++);
    SpiWeaponPt->buildup_weapon[1] = spiGetStackInt(stack++);
    SpiWeaponPt->buildup_weapon[2] = spiGetStackInt(stack++);

    if (count > 3) {
        SpiWeaponPt->buildup_monster[0] = spiGetStackInt(stack++);
        SpiWeaponPt->buildup_monster[1] = spiGetStackInt(stack++);
        SpiWeaponPt->buildup_monster[2] = spiGetStackInt(stack);
    }

    SpiWeaponPt++;
    return 1;
}

/**
 *
 * Sets the item table count and resets its loading cursor.
 *
 */
int _DATAITEMINIT(SPI_STACK *stack, int arg_count) {
    GameItemDataManage.item_num = spiGetStackInt(stack);
    SpiItemPt = GameItemDataManage.item_data;
    return 1;
}

/**
 *
 * Loads use, status, target, and effect values for an item.
 *
 */
int _DATAITEM(SPI_STACK *stack, int arg_count) {
    unsigned int flags;

    SpiItemPt = GetItemInfoData(spiGetStackInt(stack++));

    if (SpiItemPt != 0) {
        flags = spiGetStackInt(stack++);

        if (flags & ITEM_USE_FLAG_CURE_ALL) {
            flags = (flags & 0xFF7FFFFF) | 0x142A8000;
        }

        SpiItemPt->use_flags = flags;
        SpiItemPt->status_flags = spiGetStackInt(stack++);
        SpiItemPt->target_flags = spiGetStackInt(stack++);
        SpiItemPt->value[0] = spiGetStackInt(stack++);
        SpiItemPt->value[1] = spiGetStackInt(stack++);
        SpiItemPt->value[2] = spiGetStackInt(stack);
    }

    return 1;
}

/**
 *
 * Sets the attachment table count and resets its loading cursor.
 *
 */
int _DATAATTACHINIT(SPI_STACK *stack, int arg_count) {
    GameItemDataManage.attach_num = spiGetStackInt(stack);
    SpiAttach = GameItemDataManage.attach_data;
    return 1;
}

/**
 *
 * Loads the base status values of an attachment.
 *
 */
int _DATAATTACH_ST(SPI_STACK *stack, int arg_count) {
    int i;

    if (SpiAttach == NULL) {
        return 0;
    }

    for (i = 0; i < 2; i++) {
        SpiAttach->status[i] = spiGetStackInt(stack++);
    }

    return 1;
}

/**
 *
 * Loads the attribute values of an attachment.
 *
 */
int _DATAATTACH_ST2(SPI_STACK *stack, int arg_count) {
    int i;

    if (SpiAttach == NULL) {
        return 1;
    }

    for (i = 0; i < 8; i++) {
        SpiAttach->attribute[i] = spiGetStackInt(stack++);
    }

    return 1;
}

/**
 *
 * Loads attachment special flags and advances its cursor.
 *
 */
int _DATAATTACH_ST_SP(SPI_STACK *stack, int arg_count) {
    if (SpiAttach == NULL) {
        return 1;
    }

    SpiAttach->special = spiGetStackInt(stack);
    SpiAttach++;
    return 1;
}

/**
 *
 * Sets the ridepod part table count and resets its loading cursor.
 *
 */
int _DATAROBOINIT(SPI_STACK *stack, int arg_count) {
    GameItemDataManage.robo_num = spiGetStackInt(stack);
    SpiRoboPart = GameItemDataManage.robo_data;
    return 1;
}

/**
 *
 * Loads a ridepod part record according to its part type.
 *
 */
int _DATAROBO_ANALYZE(SPI_STACK *stack, int arg_count) {
    int type;
    int i;

    SpiRoboPart = GameItemDataManage.GetRoboData(spiGetStackInt(stack++));

    if (SpiRoboPart == NULL) {
        return 0;
    }

    type = spiGetStackInt(stack++);
    SpiRoboPart->use_capacity = spiGetStackInt(stack++);
    SpiRoboPart->offset_no = spiGetStackInt(stack++);

    if (type == 0) {
        SpiRoboPart->defence = spiGetStackInt(stack++);
        spiGetStackString(stack++);
    } else if (type == 1) {
        SpiRoboPart->durability = spiGetStackInt(stack++);
        SpiRoboPart->attack = spiGetStackInt(stack++);
        SpiRoboPart->durable = spiGetStackInt(stack++);

        for (i = 0; i < 8; i++) {
            SpiRoboPart->attribute[i] = spiGetStackInt(stack++);
        }

        SpiRoboPart->attack_type = spiGetStackInt(stack++);
        spiGetStackString(stack++);
    } else if (type == 2) {
        SpiRoboPart->unk_4 = spiGetStackInt(stack++);
        SpiRoboPart->move_type = spiGetStackInt(stack++);
    } else if (type == 3) {
        SpiRoboPart->energy = spiGetStackInt(stack);
    }

    SpiRoboPart++;
    return 1;
}

/**
 *
 * Sets the fish table count and resets its loading cursor.
 *
 */
int _DATAFISHINIT(SPI_STACK *stack, int arg_count) {
    GameItemDataManage.fish_num = spiGetStackInt(stack);
    SpiFish = GameItemDataManage.fish_data;
    return 1;
}

/**
 *
 * Loads the size and other attributes of a fish record.
 *
 */
int _DATAFISH(SPI_STACK *stack, int arg_count) {
    SpiFish = GameItemDataManage.GetFishData(spiGetStackInt(stack++));

    if (SpiFish != NULL) {

        SpiFish->size = spiGetStackFloat(stack++);
        SpiFish->unk_4 = spiGetStackInt(stack++);
        SpiFish->battle = spiGetStackInt(stack++);
        SpiFish->boost = spiGetStackInt(stack++);
        SpiFish->endurance = spiGetStackInt(stack++);
        SpiFish->tenacity = spiGetStackInt(stack++);
        SpiFish->stamina = spiGetStackInt(stack++);

        if (arg_count < 8) {
            return 1;
        }

        SpiFish->unk_10 = spiGetStackInt(stack);
    }

    return 1;
}

/**
 *
 * Sets the guard data table count.
 *
 */
int _DATAGAURDNUM(SPI_STACK *stack, int arg_count) {
    GameItemDataManage.guard_num = spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Loads one guard data value for an item.
 *
 */
int _DATAGAURD(SPI_STACK *stack, int arg_count) {
    short *guard;

    guard = GameItemDataManage.GetGuardData(spiGetStackInt(stack++));

    if (guard == NULL) {
        return 1;
    }

    *guard = spiGetStackInt(stack++);
    spiGetStackInt(stack++);
    spiGetStackInt(stack++);
    spiGetStackInt(stack++);
    spiGetStackInt(stack++);
    spiGetStackInt(stack);
    return 1;
}

/**
 *
 * Item-data script tags and their record loaders.
 *
 */
static SPI_TAG_PARAM gamedata_tag[25] = {
    {"COMINIT",    _DATACOMINIT     },
    {"COM",        _DATACOM         },
    {"WEPNUM",     _DATAWEPNUM      },
    {"WEP",        _DATAWEP         },
    {"WEP_ST",     _DATAWEP_ST      },
    {"WEP_ST_L",   _DATAWEP_ST_L    },
    {"WEP_ST2",    _DATAWEP2_ST     },
    {"WEP_ST2_L",  _DATAWEP2_ST_L   },
    {"WEP_SPE",    _DATAWEP_SPE     },
    {"WEP_BUILD",  _DATAWEP_BUILDUP },
    {"ITEMINIT",   _DATAITEMINIT    },
    {"ITEM",       _DATAITEM        },
    {"AT_INIT",    _DATAATTACHINIT  },
    {"AT_ST",      _DATAATTACH_ST   },
    {"AT_ST2",     _DATAATTACH_ST2  },
    {"AT_ST_SP",   _DATAATTACH_ST_SP},
    {"ROBOINIT",   _DATAROBOINIT    },
    {"RB_PARTS",   _DATAROBO_ANALYZE},
    {"GRDNUM",     _DATAGAURDNUM    },
    {"GRD",        _DATAGAURD       },
    {"FISHINIT",   _DATAFISHINIT    },
    {"FISH",       _DATAFISH        },
    {"MES_SYS",    _MES_SYS         },
    {"MES_SYSSPE", _MES_SYS_SPECTOL },
    {NULL,         NULL             },
};

/**
 *
 * Loads and interprets a game item data script.
 *
 */
int LoadGameDataAnalyze(char *name) {
    int       size;
    u_long128 buffer[0x780];
    char      path[0x40];
    char     *script;

    script = (char *) MenuCalcBufAlignment(buffer);
    SetCurrentDir(NULL);
    sprintf(path, "menu/cfg7/%s", name);

    if (LoadFile2(path, script, &size, 0) == 0) {
        return 0;
    }

    CScriptInterpreter interpreter;
    interpreter.SetTag(gamedata_tag);
    interpreter.SetScript(script, size);
    interpreter.Run();
    return 1;
}

int CGameData::LoadData() {
    int item_no;

    Initialize();
    comdatapt = common_data;
    comdatapt_num = 0;
    memset(local_itemdatano_converttable, -1, sizeof(local_itemdatano_converttable));
    LoadGameDataAnalyze("comdat.cfg");
    LoadGameDataAnalyze("wepdat.cfg");
    LoadGameDataAnalyze("itemdat.cfg");
    LoadGameDataAnalyze("atdat.cfg");
    LoadGameDataAnalyze("robodat.cfg");
    LoadGameDataAnalyze("fishdat.cfg");
    LoadGameDataAnalyze("grddat.cfg");
    item_no = 0;
    common_num = comdatapt_num;
    max_item_no = 0;

    do {
        if (0 <= local_itemdatano_converttable[item_no]) {
            max_item_no = item_no;
        }

        item_no += 1;
    } while (item_no < 0x200);

    return unk_0;
}

int CGameData::LoadItemSystemMes(int language) {
    int       size;
    u_long128 buffer[0x780];
    char     *script;

    static u_long128 gamedata_sysword_buffer[0x280];

    script = (char *) MenuCalcBufAlignment(buffer);
    memset(gamedata_sysword_buffer, 0, 0x2800);

    mgCMemory memory;
    char      path[0x40];
    memory.stSetBuffer(gamedata_sysword_buffer, 0x280);
    gamedata_build_stack = &memory;
    sprintf(path, "menu/cfg7/comdatmes%d.cfg", language);

    if (LoadFile2(path, script, &size, 0) != 0) {
        CScriptInterpreter interpreter;
        interpreter.SetTag(gamedata_tag);
        interpreter.SetScript(script, size);
        interpreter.Run();
    }

    return 1;
}

void CGameData::InitItemMes(int clear, int unused) {
    int index;

    if (clear != 0) {

        clear = 0;
        index = 0;

        do {
            clear += 8;
            local_com_itemdata[index].name = 0;
            local_com_itemdata[index + 1].name = 0;
            local_com_itemdata[index + 2].name = 0;
            local_com_itemdata[index + 3].name = 0;
            local_com_itemdata[index + 4].name = 0;
            local_com_itemdata[index + 5].name = 0;
            local_com_itemdata[index + 6].name = 0;
            local_com_itemdata[index + 7].name = 0;
            index += 8;
        } while (clear < 0x1B0);
    }
}

CDataCommon *CGameData::GetCommonData(int item_no) {
    short index;

    if (item_no <= 0 || item_no > 0x1FF) {
        return 0;
    }

    index = local_itemdatano_converttable[item_no];

    if (index < 0) {
        return 0;
    }

    return common_data + index;
}

CDataWeapon *CGameData::GetWeaponData(int item_no) {
    CDataCommon *record;
    short        list_no;

    record = GetCommonData(item_no);

    if (record == NULL) {
        return 0;
    }

    list_no = record->list_no;

    if ((int) weapon_num <= list_no) {
        return 0;
    }

    if (weapon_data == 0) {
        return 0;
    }

    if (ConvertUsedItemType(record->type) != USED_ITEM_TYPE_WEAPON) {
        return 0;
    }

    return weapon_data + record->list_no;
}

CDataItem *CGameData::GetItemData(int item_no) {
    CDataCommon *record;
    short        list_no;
    int          type;

    record = GetCommonData(item_no);

    if (record == NULL) {
        return 0;
    }

    list_no = record->list_no;

    if ((int) item_num <= list_no) {
        return 0;
    }

    if (item_data == 0) {
        return 0;
    }

    type = ConvertUsedItemType(record->type);

    if (type == USED_ITEM_TYPE_ITEM || type == USED_ITEM_TYPE_GIFT_BOX || type == USED_ITEM_TYPE_BOILED) {
        return item_data + record->list_no;
    }

    return 0;
}

CDataAttach *CGameData::GetAttachData(int item_no) {
    CDataCommon *record;
    short        list_no;

    record = GetCommonData(item_no);

    if (record == NULL) {
        return 0;
    }

    list_no = record->list_no;

    if ((int) attach_num <= list_no) {
        return 0;
    }

    if (attach_data == 0) {
        return 0;
    }

    if (ConvertUsedItemType(record->type) != USED_ITEM_TYPE_ATTACH) {
        return 0;
    }

    return attach_data + record->list_no;
}

CDataRoboPart *CGameData::GetRoboData(int item_no) {
    CDataCommon   *record;
    short          list_no;
    CDataRoboPart *table;

    record = GetCommonData(item_no);

    if (record == NULL) {
        return 0;
    }

    list_no = record->list_no;

    if ((int) robo_num <= list_no) {
        return 0;
    }

    table = robo_data;

    if (table != 0) {
        return table + list_no;
    }

    return 0;
}

CDataBreedFish *CGameData::GetFishData(int item_no) {
    CDataCommon *record;
    short        list_no;

    record = GetCommonData(item_no);

    if (record == NULL) {
        return 0;
    }

    list_no = record->list_no;

    if ((int) fish_num <= list_no) {
        return 0;
    }

    if (fish_data == 0) {
        return 0;
    }

    if (ConvertUsedItemType(record->type) != USED_ITEM_TYPE_FISH) {
        return 0;
    }

    return fish_data + record->list_no;
}

#pragma optimization_level 4

s16 *CGameData::GetGuardData(int item_no) {
    CDataCommon *record;
    short        list_no;

    record = GetCommonData(item_no);

    if (record == NULL) {
        return 0;
    }

    list_no = record->list_no;

    if ((int) guard_num <= list_no) {
        return 0;
    }

    if (guard_data != 0) {
        return guard_data + list_no;
    }

    return 0;
}

#pragma optimization_level reset

int CGameData::GetDataType(int item_no) {
    CDataCommon *common = GetCommonData(item_no);

    if (common != NULL) {
        return common->type;
    }

    return 0U;
}

int CGameData::GetDataTypeStartListNo(int type) {
    int          i;
    CDataCommon *record;

    record = GetCommonData(1);

    for (i = 0; i < common_num; i++, record++) {
        if (record->type == type) {
            return record->item_no;
        }
    }

    return 0;
}

CDataCommon *GetCommonItemData(int item_no) {
    return GameItemDataManage.GetCommonData(item_no);
}

CDataItem *GetItemInfoData(int item_no) {
    return GameItemDataManage.GetItemData(item_no);
}

CDataWeapon *GetWeaponInfoData(int item_no) {
    return GameItemDataManage.GetWeaponData(item_no);
}

CDataRoboPart *GetRoboPartInfoData(int item_no) {
    return GameItemDataManage.GetRoboData(item_no);
}

CDataBreedFish *GetBreedFishInfoData(int item_no) {
    return GameItemDataManage.GetFishData(item_no);
}

char *GetItemFileName(int item_no, int variant) {
    CDataCommon *record = GetCommonItemData(item_no);
    char        *name;

    if (record == NULL) {
        return NULL;
    }

    name = record->file_name;

    if (name == NULL) {
        return NULL;
    }

    static char filename[0x20];

    strcpy(filename, name);
    CSaveData *save_data = GetSaveData();
    u8         type = record->type;

    if ((type == 5 || type == 8) && save_data->GetBitFlag((int) SAVE_FLAG_COSTUME_UNLOCK) != 0) {
        strcat(filename, "t");
    }

    if (variant != 0 && variant == 1) {
        strcat(filename, ".chr");
    }

    return filename;
}

char *GetItemFilePath(int item_no, int variant) {
    char         name[0x20];
    CDataCommon *record;
    int          type;
    char        *file_name;

    static char item_file_path[0x80];

    item_file_path[0] = 0;
    record = GameItemDataManage.GetCommonData(item_no);

    if (record != NULL) {
        type = ConvertUsedItemType(record->type);
        file_name = GetItemFileName(item_no, 0);

        if (file_name != NULL) {
            strcpy(name, file_name);
        }

        switch (type) {
            case USED_ITEM_TYPE_WEAPON:
            case USED_ITEM_TYPE_COSTUME:
                strcpy(item_file_path, "mainchr/");
                break;
            case USED_ITEM_TYPE_ROBO_PART:
                strcpy(item_file_path, "dungeon/robo/");
                break;
            default:
                strcpy(item_file_path, "item/");
                break;
        }

        strcat(item_file_path, name);
        strcat(item_file_path, ".chr");

        if (variant == 1) {
            if (type == (int) USED_ITEM_TYPE_WEAPON) {
                sprintf(item_file_path, "wep_t/%s_item.chr", name);
            }
        }

        if (variant == 1 && (record->type == (int) ITEM_DATA_ROBO_ARM || record->type == (int) ITEM_DATA_ROBO_LEG)) {
            sprintf(item_file_path, "wep_t/%s.chr", name);
        }
    }

    return item_file_path;
}

int GetItemDataType(int item_no) {
    return GameItemDataManage.GetDataType(item_no);
}

unsigned int GetItemDataAttribute(int item_no) {
    CDataCommon *record;

    record = GameItemDataManage.GetCommonData(item_no);

    if (record != NULL) {
        return record->attribute;
    }

    return 0;
}

int ConvertUsedItemType(int item_type) {
    int type;

    type = USED_ITEM_TYPE_NONE;

    if (item_type > 0 && item_type < 5) {
        type = USED_ITEM_TYPE_WEAPON;
    } else if (item_type >= 5 && item_type < 11) {
        type = USED_ITEM_TYPE_COSTUME;
    } else if (item_type > 11 && item_type <= 15) {
        type = USED_ITEM_TYPE_ROBO_PART;
    } else if ((item_type >= 16 && item_type <= 19) || item_type == 0x22) {
        type = USED_ITEM_TYPE_ATTACH;
    } else if (item_type == ITEM_DATA_ROBO_CORE || item_type >= 20) {
        type = USED_ITEM_TYPE_ITEM;
    }

    if (item_type == ITEM_DATA_GIFT_BOX) {
        type = USED_ITEM_TYPE_GIFT_BOX;
    } else if (item_type == ITEM_DATA_FISH) {
        type = USED_ITEM_TYPE_FISH;
    } else if (item_type == ITEM_DATA_BOILED) {
        type = USED_ITEM_TYPE_BOILED;
    }

    return type;
}

int GetItemMessageNo(int item_no, int message_kind) {
    static short msg_offsettbl[3] = {0, 10000, 0};
    CDataCommon *record;

    record = GameItemDataManage.GetCommonData(item_no);

    if (record == NULL) {
        return -1;
    }

    return (record)->message_no + msg_offsettbl[message_kind];
}

char *GetItemMessage(int item_no) {
    CDataCommon *record;

    record = GameItemDataManage.GetCommonData(item_no);

    if (record != NULL) {
        return record->name;
    }

    return 0;
}

int GetItemIconNo(int item_no) {
    CDataCommon *common = GameItemDataManage.GetCommonData(item_no);

    if (common != NULL) {
        return common->icon_no;
    }

    return -1;
}

void SetItemSpectolPoint(int item_no, ATTACH_USED *used, int multiplier) {
    int index;
    int list_no;
    int points;

    if (item_no > 0 && used != NULL) {
        index = item_no - 1;
        list_no = etcitem_spectol_table[index][0];
        points = etcitem_spectol_table[index][1];

        if (list_no < 8) {
            used->attribute[list_no] = points * multiplier;
        }

        if (list_no >= 10) {
            used->status[list_no - 10] = points * multiplier;
        }
    }
}

int ItemCmdMsgSet(int item_no, int *messages) {
    int count;
    int i;

    count = 0;

    for (i = 0; i < 8; i++) {
        messages[i] = ItemCmdMsgTbl[item_no][i] + 5000;

        if (messages[i] < 5000) {
            break;
        }

        count++;
    }

    messages[i] = -1;
    return count;
}

int GetMenuCommandMsg(int item_no, int *message_list) {
    int count;
    int type;

    count = 0;
    type = GetItemDataType(item_no);

    switch (type) {
        case ITEM_DATA_MAX_MELEE:
        case ITEM_DATA_MAX_GUN:
        case ITEM_DATA_MONICA_MELEE:
        case ITEM_DATA_MONICA_MAGIC:
            count = ItemCmdMsgSet(0, message_list);

            if (item_no == (int) ITEM_ID_FISHING_ROD || item_no == (int) ITEM_ID_LURE_ROD) {
                count = ItemCmdMsgSet(14, message_list);
            }

            break;
        case 5:
        case 6:
        case 7:
        case 8:
        case 9:
        case 10:
            count = ItemCmdMsgSet(8, message_list);
            break;
        case 16:
        case 18:
        case 34:
            count = ItemCmdMsgSet(1, message_list);
            break;
        case 19:
            count = ItemCmdMsgSet(24, message_list);
            break;
        case 17:
            count = ItemCmdMsgSet(5, message_list);
            break;
        case ITEM_DATA_ROBO_CORE:
            count = ItemCmdMsgSet(7, message_list);
            break;
        case ITEM_DATA_ROBO_BODY:
        case ITEM_DATA_ROBO_LEG:
            count = ItemCmdMsgSet(2, message_list);
            break;
        case ITEM_DATA_ROBO_ARM:
            count = ItemCmdMsgSet(22, message_list);
            break;
        case ITEM_DATA_ROBO_ENERGY_PACK:
            count = ItemCmdMsgSet(16, message_list);
            break;
        case 22:
            count = ItemCmdMsgSet(3, message_list);
            break;
        case 20:
        case 23:
        case 24:
        case 25:
        case 26:
        case 27:
        case 33:
            if (item_no == (int) ITEM_ID_MELEE_REPAIR) {
                count = ItemCmdMsgSet(13, message_list);
            } else if (item_no == (int) ITEM_ID_GUN_REPAIR || item_no == (int) ITEM_ID_MAGIC_REPAIR) {
                count = ItemCmdMsgSet(17, message_list);
            } else if (item_no == (int) ITEM_ID_RIDEPOD_FUEL) {
                count = ItemCmdMsgSet(23, message_list);
            } else if (item_no == 0x128) {
                count = ItemCmdMsgSet(20, message_list);
            } else if (item_no == 0x184) {
                count = ItemCmdMsgSet(18, message_list);
            } else if (item_no == 0x185) {
                count = ItemCmdMsgSet(19, message_list);
            } else if (item_no == 0x182) {
                count = ItemCmdMsgSet(21, message_list);
            } else if (item_no == 0x11F || item_no == 0x124 || item_no == 0x111) {
                count = ItemCmdMsgSet(3, message_list);
            } else if (item_no == 0x163) {
                count = ItemCmdMsgSet(26, message_list);
            } else if (item_no == 0x1A7) {
                count = ItemCmdMsgSet(25, message_list);
            } else if (item_no == 0x125) {
                count = ItemCmdMsgSet(27, message_list);
            } else if (item_no == 0xAE) {
                count = ItemCmdMsgSet(28, message_list);
            } else if (item_no == 0xAC) {
                count = ItemCmdMsgSet(30, message_list);
            } else if (item_no == 0x127) {
                count = ItemCmdMsgSet(31, message_list);
            } else {
                count = ItemCmdMsgSet(4, message_list);
            }

            break;
        case ITEM_DATA_AQUARIUM:
            count = ItemCmdMsgSet(9, message_list);
            break;
        case 21:
            count = ItemCmdMsgSet(10, message_list);
            break;
        case ITEM_DATA_GIFT_BOX:
            count = ItemCmdMsgSet(11, message_list);
            break;
        case ITEM_DATA_FISH:
            count = ItemCmdMsgSet(12, message_list);
            break;
        case 32:
            count = ItemCmdMsgSet(15, message_list);
            break;
        case ITEM_DATA_BOILED:
            count = ItemCmdMsgSet(29, message_list);
            break;
    }

    return count;
}

int CheckItemEquip(int chara, int item_no) {
    if (GetItemInfoData(item_no) == NULL) {
        return 0;
    }

    if (item_no == (int) ITEM_ID_GUN_REPAIR) {
        if (chara != 0) {
            return 0;
        }
    } else if (item_no == (int) ITEM_ID_MAGIC_REPAIR) {
        if (chara != 1) {
            return 0;
        }
    } else if (item_no == 0x171) {
        if (chara != 0) {
            return 0;
        }
    }

    return 1;
}

int SearchItemByName(char *name) {
    int          item_no;
    CDataCommon *record;

    for (item_no = 1; item_no < 512; item_no++) {
        record = GetCommonItemData(item_no);

        if (record != NULL) {
            char *item_name = record->name;

            if ((item_name != 0) && (strcmp(item_name, name) == 0)) {
                return item_no;
            }
        }
    }

    return -1;
}

int GetRidePodCore(int index) {
    static s16 table[8] = {0xF6, 0xF7, 0xF8, 0xF9, 0xFA, 0xFB, 0xFC, -1};

    if (index < 0 || index > 6) {
        return 0;
    }

    return table[index];
}

/**
 *
 * Clears item use effect flags and values.
 *
 */
static void Init_USEITEM_EFFECT(USEITEM_EFFECT *effect) {
    effect->target_flags = 0;
    effect->use_flags = 0;
    effect->status_flags = 0;
    effect->value[3] = 0;
    effect->value[2] = 0;
    effect->value[1] = 0;
    effect->value[0] = 0;
}

int GetUsedItemAfterEffect(int item_no, USEITEM_EFFECT *effect) {
    CDataItem *data;

    Init_USEITEM_EFFECT(effect);
    data = GetItemInfoData(item_no);

    if (data == NULL || effect == NULL) {
        return 0;
    }

    effect->status_flags = data->status_flags;
    effect->use_flags = data->use_flags;
    effect->target_flags = data->target_flags;
    effect->value[0] = data->value[0];
    effect->value[1] = data->value[1];
    effect->value[2] = data->value[2];
    return 1;
}

void CItemUseTarget::SetPtr(int new_kind, void *new_ptr) {
    type = new_kind;

    if (type == 0) {
        target.data = new_ptr;
    }

    if (type == 1) {
        target.data = new_ptr;
    }

    if (type == 2) {
        target.data = new_ptr;
    }

    if (type == 3) {
        target.data = new_ptr;
    }
}
