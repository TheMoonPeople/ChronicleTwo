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

CDataCommon          *comdatapt;
int                   comdatapt_num;
mgCMemory            *gamedata_build_stack;
CDataCommon           local_com_itemdata[432];
extern CDataItem      local_itemdata[162];
extern CDataWeapon    local_weapondata[116];
extern CDataAttach    local_attachdata[38];
CDataRoboPart         local_robodata[68];
extern CDataBreedFish local_fishdata[20];
short                 local_guarddata[40];
short                 local_itemdatano_converttable[512];
char                  gamedata_sysword_buffer_1073[0x2800];
char                  filename_1267[0x20];
char                  item_file_path_1288[0x80];
extern SPI_TAG_PARAM  gamedata_tag[];
extern short          msg_offsettbl_1363[3];
extern signed char    ItemCmdMsgTbl[33][8];
extern char           at_1018[];
extern char           at_1019[];
extern char           at_1020[];
extern char           at_1021[];
extern char           at_1022[];
extern char           at_1023[];
extern char           at_1024[];
extern char           at_1025__2[];
extern char           at_1026[];
extern char           at_1027[];
extern char           at_1028[];
extern char           at_1029[];
extern char           at_1030[];
extern char           at_1031[];
extern char           at_1032[];
extern char           at_1033[];
extern char           at_1034[];
extern char           at_1035[];
extern char           at_1036[];
extern char           at_1037[];
extern char           at_1038[];
extern char           at_1039[];
extern char           at_1040[];
extern char           at_1041[];
extern char           at_1048[];
extern char           at_1063[];
extern char           at_1064__2[];
extern char           at_1065[];
extern char           at_1066[];
extern char           at_1067[];
extern char           at_1068[];
extern char           at_1069__2[];
extern char           at_1079[];
extern char           at_1283__3[];
extern char           at_1284__3[];
extern char           at_1307__2[];
extern char           at_1308__2[];
extern char           at_1309__2[];
extern char           at_1310__2[];
extern char           at_1311__2[];
extern char           at_1501[];

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
    guard_data = (short *) local_guarddata;
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
    u8           converted[0x100];
    int          item_no;
    int          copy;
    signed char *text;
    CDataCommon *record;

    item_no = spiGetStackInt(stack++);
    text = (signed char *) (spiGetStackString(stack));
    record = GameItemDataManage.GetCommonData(item_no);

    if (record != NULL) {
        if ((LanguageCode >= 2) && (LanguageCode < 6)) {
            memset(converted, 0, sizeof(converted));
            ConvertFontCode((char *) text, (char *) converted);
            copy = (int) mgCopyString((char *) converted, gamedata_build_stack);
        } else {
            copy = (int) (mgCopyString((char *) text, gamedata_build_stack));
        }

        record->name = (char *) copy;
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

    guard = (short *) GameItemDataManage.GetGuardData(spiGetStackInt(stack++));

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
 * Loads and interprets a game item data script.
 *
 */
int LoadGameDataAnalyze(char *name) {
    int   size;
    u8    buffer[0x7800];
    char  path[0x40];
    char *script;

    script = (char *) MenuCalcBufAlignment((u_long128 *) buffer);
    SetCurrentDir(NULL);
    sprintf(path, at_1048, name);

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
    LoadGameDataAnalyze(at_1063);
    LoadGameDataAnalyze(at_1064__2);
    LoadGameDataAnalyze(at_1065);
    LoadGameDataAnalyze(at_1066);
    LoadGameDataAnalyze(at_1067);
    LoadGameDataAnalyze(at_1068);
    LoadGameDataAnalyze(at_1069__2);
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
    int   size;
    u8    buffer[0x7800];
    u8    memory_storage[0x30];
    char  path[0x40];
    char *script;

    script = (char *) MenuCalcBufAlignment((u_long128 *) buffer);
    memset(gamedata_sysword_buffer_1073, 0, sizeof(gamedata_sysword_buffer_1073));

    ((mgCMemory *) memory_storage)->Init();
    ((mgCMemory *) memory_storage)->stSetBuffer((u_long128 *) gamedata_sysword_buffer_1073, 0x280);
    gamedata_build_stack = (mgCMemory *) memory_storage;
    sprintf(path, at_1079, language);

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

    strcpy(filename_1267, name);
    CSaveData *save_data = GetSaveData();
    u8         type = record->type;

    if ((type == 5 || type == 8) && save_data->GetBitFlag((int) SAVE_FLAG_COSTUME_UNLOCK) != 0) {
        strcat(filename_1267, at_1283__3);
    }

    if (variant != 0 && variant == 1) {
        strcat(filename_1267, at_1284__3);
    }

    return filename_1267;
}

char *GetItemFilePath(int item_no, int variant) {
    char         name[0x20];
    CDataCommon *record;
    int          type;
    char        *file_name;

    item_file_path_1288[0] = 0;
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
                strcpy(item_file_path_1288, at_1307__2);
                break;
            case USED_ITEM_TYPE_ROBO_PART:
                strcpy(item_file_path_1288, at_1308__2);
                break;
            default:
                strcpy(item_file_path_1288, at_1309__2);
                break;
        }

        strcat(item_file_path_1288, name);
        strcat(item_file_path_1288, at_1284__3);

        if (variant == 1) {
            if (type == (int) USED_ITEM_TYPE_WEAPON) {
                sprintf(item_file_path_1288, at_1310__2, name);
            }
        }

        if (variant == 1 && (record->type == (int) ITEM_DATA_ROBO_ARM || record->type == (int) ITEM_DATA_ROBO_LEG)) {
            sprintf(item_file_path_1288, at_1311__2, name);
        }
    }

    return item_file_path_1288;
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
    CDataCommon *record;

    record = GameItemDataManage.GetCommonData(item_no);

    if (record == NULL) {
        return -1;
    }

    return (record)->message_no + msg_offsettbl_1363[message_kind];
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
        index = (item_no - 1) * 2;
        list_no = etcitem_spectol_table[index];
        points = etcitem_spectol_table[index + 1];

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

extern s16 table_1553[7];

int GetRidePodCore(int index) {
    if (index < 0 || index > 6) {
        return 0;
    }

    return table_1553[index];
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

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", etcitem_spectol_table__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", gamedata_tag__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", ItemCmdMsgTbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", table_1553__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1018__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1019__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1020__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1021__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1022__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1023__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1024__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1025__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1026__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1027__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1028__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1029__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1030__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1031__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1032__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1033__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1034__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1035__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1036__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1037__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1038__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1039__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1040__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1041__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1048__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1063__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1064__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1065__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1066__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1067__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1068__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1069__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1079__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1283__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1284__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1307__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1308__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1309__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1310__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1311__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", at_1501__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", msg_offsettbl_1363__DATA);

// Small uninitialised data (.sbss)
CDataWeapon    *SpiWeaponPt;
CDataItem      *SpiItemPt;
CDataAttach    *SpiAttach;
CDataRoboPart  *SpiRoboPart;
CDataBreedFish *SpiFish;

// Uninitialised data (.bss)
CGameData      GameItemDataManage;
CDataItem      local_itemdata[162];
CDataWeapon    local_weapondata[116];
CDataAttach    local_attachdata[38];
CDataBreedFish local_fishdata[20];
