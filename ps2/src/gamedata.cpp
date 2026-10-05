#include "common.h"
#include "gamedata.hpp"
#include <cstring>
#include "userdata.hpp"
#include "savedata.hpp"
#include "scriptinterpreter.hpp"
#include "mg_memory.hpp"
#include "menucommon.hpp"
#include "dataread.hpp"
#include "mainloop.hpp"
#include <cstdio>
#include <cstdlib>

extern "C" void __ct__18CScriptInterpreterFv(void *);
extern "C" u8 *GetCommonData__9CGameDataFi(CGameData *, int);
extern "C" int GetDataType__9CGameDataFi(CGameData *, int);

extern CDataCommon *comdatapt;
extern int comdatapt_num;
extern mgCMemory *gamedata_build_stack;
extern CDataCommon local_com_itemdata[432];
extern CDataItem local_itemdata[162];
extern CDataWeapon local_weapondata[116];
extern CDataAttach local_attachdata[38];
extern CDataRoboPart local_robodata[68];
extern CDataBreedFish local_fishdata[20];
extern short local_guarddata[40];
extern short local_itemdatano_converttable[512];
extern char gamedata_sysword_buffer_1073[0x2800];
extern char filename_1267[0x20];
extern char item_file_path_1288[0x80];
extern SPI_TAG_PARAM gamedata_tag[];
extern short msg_offsettbl_1363[3];
extern signed char ItemCmdMsgTbl[33][8];
extern "C" unsigned int fptoui(float);
extern char at_1018[];
extern char at_1019[];
extern char at_1020[];
extern char at_1021[];
extern char at_1022[];
extern char at_1023[];
extern char at_1024[];
extern char at_1025__2[];
extern char at_1026[];
extern char at_1027[];
extern char at_1028[];
extern char at_1029[];
extern char at_1030[];
extern char at_1031[];
extern char at_1032[];
extern char at_1033[];
extern char at_1034[];
extern char at_1035[];
extern char at_1036[];
extern char at_1037[];
extern char at_1038[];
extern char at_1039[];
extern char at_1040[];
extern char at_1041[];
extern char at_1048[];
extern char at_1063[];
extern char at_1064__2[];
extern char at_1065[];
extern char at_1066[];
extern char at_1067[];
extern char at_1068[];
extern char at_1069__2[];
extern char at_1079[];
extern char at_1283__3[];
extern char at_1284__3[];
extern char at_1307__2[];
extern char at_1308__2[];
extern char at_1309__2[];
extern char at_1310__2[];
extern char at_1311__2[];
extern char at_1501[];

// Code (.text)
CGameData *GetGameDataPt(void) {
    return &GameItemDataManage;
}
CDataItem::CDataItem(void) {
    use_flags = 0;
    status_flags = 0;
    value[0] = 0;
    value[1] = 0;
    value[2] = 0;
}
CDataAttach::CDataAttach(void) {
    memset(this, 0, 0x18);
}
CDataWeapon::CDataWeapon(void) {
    memset(this, 0, 0x4C);
    durability = 0x14;
    levelup_exp = 0x14;
}
u8 CDataRoboPart::GetOffsetNo() { return this->offset_no; }
CDataBreedFish::CDataBreedFish(void) {
    memset(this, 0, 0x14);
}
void CGameData::Initialize() {
    max_item_no = 0;
    common_data = local_com_itemdata;
    common_num = 0;
    item_data = local_itemdata;
    item_num = 0;
    weapon_data = local_weapondata;
    weapon_num = 0;
    guard_data = (short *)local_guarddata;
    guard_num = 0;
    attach_data = local_attachdata;
    attach_num = 0;
    robo_data = local_robodata;
    robo_num = 0;
    fish_data = local_fishdata;
    fish_num = 0;
    InitItemMes(1, 1);
}
int _DATACOMINIT(SPI_STACK *stack, int arg_count) {
    GameItemDataManage.common_num = spiGetStackInt(stack);
    comdatapt_num = 0;
    comdatapt = GameItemDataManage.common_data;
    memset(local_itemdatano_converttable, -1, 0x400);
    return 1;
}
int _DATACOM(SPI_STACK *stack, int arg_count) {
    char *name_stack;

    comdatapt->item_no = spiGetStackInt(stack++);
    comdatapt->type = spiGetStackInt(stack++);
    comdatapt->list_no = spiGetStackInt(stack++);
    comdatapt->active_set = spiGetStackInt(stack++);
    comdatapt->stack_num = spiGetStackInt(stack++);
    comdatapt->max_num = spiGetStackInt(stack++);
    if (ConvertUsedItemType(comdatapt->type) == 3) {
        if (comdatapt->max_num > 0x64) {
            comdatapt->max_num = 0x90;
        }
    }
    comdatapt->unk_20 = spiGetStackInt(stack++);
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
int _MES_SYS(SPI_STACK *stack, int arg_count) {
    u8 converted[0x100];
    int item_no;
    int copy;
    signed char *text;
    CDataCommon *record;

    item_no = (int)(spiGetStackInt(stack++));
    text = (signed char *)(spiGetStackString(stack));
    record = (CDataCommon *)(GameItemDataManage.GetCommonData(item_no));
    if (record != NULL) {
        if (((int)LanguageCode >= 2) && ((int)LanguageCode < 6)) {
            memset(converted, 0, 0x100);
            ConvertFontCode((char *)text, (char *)converted);
            copy = (int)mgCopyString((char *)converted, gamedata_build_stack);
        } else {
            copy = (int)(mgCopyString((char *)text, gamedata_build_stack));
        }
        record->name = (char *)copy;
    }
    return 1;
}
int _MES_SYS_SPECTOL(SPI_STACK *stack, int arg_count) {
    spiGetStackInt(stack++);
    spiGetStackString(stack);
    return 1;
}
int _DATAWEPNUM(SPI_STACK *stack, int arg_count) {
    GameItemDataManage.weapon_num = spiGetStackInt(stack);
    SpiWeaponPt = GameItemDataManage.weapon_data;
    return 1;
}
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
int _DATAWEP_ST(SPI_STACK *stack, int arg_count) {
    SPI_STACK *next;

    next = stack + 1;
    if (SpiWeaponPt == NULL) {
        return 0;
    }
    SpiWeaponPt->status[0] = spiGetStackInt(stack);
    SpiWeaponPt->status[1] = spiGetStackInt(next);
    return 1;
}
int _DATAWEP_ST_L(SPI_STACK *stack, int arg_count) {
    SPI_STACK *next;

    next = stack + 1;
    if (SpiWeaponPt == NULL) {
        return 0;
    }
    SpiWeaponPt->status_max[0] = spiGetStackInt(stack);
    SpiWeaponPt->status_max[1] = spiGetStackInt(next);
    return 1;
}
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
int _DATAWEP_SPE(SPI_STACK *stack, int arg_count) {
    if (SpiWeaponPt == NULL) {
        return 0;
    }
    SpiWeaponPt->unk_38 = fptoui(spiGetStackFloat(stack++));
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
int _DATAITEMINIT(SPI_STACK *stack, int arg_count) {
    GameItemDataManage.item_num = spiGetStackInt(stack);
    SpiItemPt = GameItemDataManage.item_data;
    return 1;
}
int _DATAITEM(SPI_STACK *stack, int arg_count) {
    unsigned int flags;

    SpiItemPt = GetItemInfoData(spiGetStackInt(stack++));
    if (SpiItemPt != 0) {
        flags = spiGetStackInt(stack++);
        if (flags & 0x800000) {
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
int _DATAATTACHINIT(SPI_STACK *stack, int arg_count) {
    GameItemDataManage.attach_num = spiGetStackInt(stack);
    SpiAttach = GameItemDataManage.attach_data;
    return 1;
}
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
int _DATAATTACH_ST_SP(SPI_STACK *stack, int arg_count) {
    if (SpiAttach == NULL) {
        return 1;
    }
    SpiAttach->special = spiGetStackInt(stack);
    SpiAttach++;
    return 1;
}
int _DATAROBOINIT(SPI_STACK *stack, int arg_count) {
    GameItemDataManage.robo_num = spiGetStackInt(stack);
    SpiRoboPart = GameItemDataManage.robo_data;
    return 1;
}
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
        SpiRoboPart->unk_1c = spiGetStackInt(stack++);
        spiGetStackString(stack++);
    } else if (type == 1) {
        SpiRoboPart->unk_6 = spiGetStackInt(stack++);
        SpiRoboPart->unk_8 = spiGetStackInt(stack++);
        SpiRoboPart->unk_a = spiGetStackInt(stack++);
        for (i = 0; i < 8; i++) {
            SpiRoboPart->unk_c[i] = spiGetStackInt(stack++);
        }
        SpiRoboPart->info_type_d = spiGetStackInt(stack++);
        spiGetStackString(stack++);
    } else if (type == 2) {
        SpiRoboPart->unk_4 = spiGetStackInt(stack++);
        SpiRoboPart->info_type_e = spiGetStackInt(stack++);
    } else if (type == 3) {
        SpiRoboPart->unk_2 = spiGetStackInt(stack);
    }
    SpiRoboPart++;
    return 1;
}
int _DATAFISHINIT(SPI_STACK *stack, int arg_count) {
    GameItemDataManage.fish_num = spiGetStackInt(stack);
    SpiFish = GameItemDataManage.fish_data;
    return 1;
}
int _DATAFISH(SPI_STACK *stack, int arg_count) {
    SpiFish = GameItemDataManage.GetFishData(spiGetStackInt(stack++));
    if (SpiFish != NULL) {

        SpiFish->size = spiGetStackFloat(stack++);
        SpiFish->unk_4 = spiGetStackInt(stack++);
        SpiFish->unk_6 = spiGetStackInt(stack++);
        SpiFish->unk_a = spiGetStackInt(stack++);
        SpiFish->unk_c = spiGetStackInt(stack++);
        SpiFish->unk_e = spiGetStackInt(stack++);
        SpiFish->unk_8 = spiGetStackInt(stack++);
        if (arg_count < 8) {
            return 1;
        }
        SpiFish->unk_10 = spiGetStackInt(stack);
    }
    return 1;
}
int _DATAGAURDNUM(SPI_STACK *stack, int arg_count) {
    GameItemDataManage.guard_num = spiGetStackInt(stack);
    return 1;
}
int _DATAGAURD(SPI_STACK *stack, int arg_count) {
    short *guard;

    guard = (short *)GameItemDataManage.GetGuardData(spiGetStackInt(stack++));
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
int LoadGameDataAnalyze(char *name) {
    int size;
    u8 buffer[0x7800];
    char path[0x40];
    u8 interpreter_storage[0xED0];
    char *script;

    script = (char *)MenuCalcBufAlignment((u_long128 *)buffer);
    SetCurrentDir(NULL);
    sprintf(path, at_1048, name);
    if (LoadFile2(path, script, &size, 0) == 0) {
        return 0;
    }

    __ct__18CScriptInterpreterFv(interpreter_storage);
    ((CScriptInterpreter *)interpreter_storage)->SetTag(gamedata_tag);
    ((CScriptInterpreter *)interpreter_storage)->SetScript(script, size);
    ((CScriptInterpreter *)interpreter_storage)->Run();
    return 1;
}
extern "C" int LoadData__9CGameDataFv(CGameData *self) {
    int i;
    int offset;

    self->Initialize();
    comdatapt = self->common_data;
    comdatapt_num = 0;
    memset(local_itemdatano_converttable, -1, 0x400);
    LoadGameDataAnalyze(at_1063);
    LoadGameDataAnalyze(at_1064__2);
    LoadGameDataAnalyze(at_1065);
    LoadGameDataAnalyze(at_1066);
    LoadGameDataAnalyze(at_1067);
    LoadGameDataAnalyze(at_1068);
    LoadGameDataAnalyze(at_1069__2);
    i = 0;
    offset = 0;
    self->common_num = comdatapt_num;
    self->max_item_no = 0;
    do {
        if (0 <= *(short *)((u8 *)local_itemdatano_converttable + offset)) {
            self->max_item_no = i;
        }
        i += 1;
        offset += 2;
    } while (i < 0x200);
    return self->unk_0;
}
extern "C" int LoadItemSystemMes__9CGameDataFi(CGameData *self, int language) {
    int size;
    u8 buffer[0x7800];
    u8 memory_storage[0x30];
    char path[0x40];
    u8 interpreter_storage[0xED0];
    char *script;

    script = (char *)MenuCalcBufAlignment((u_long128 *)buffer);
    memset(gamedata_sysword_buffer_1073, 0, 0x2800);

    ((mgCMemory *)memory_storage)->Init();
    ((mgCMemory *)memory_storage)->stSetBuffer((u_long128 *)gamedata_sysword_buffer_1073, 0x280);
    gamedata_build_stack = (mgCMemory *)memory_storage;
    sprintf(path, at_1079, language);
    if (LoadFile2(path, script, &size, 0) != 0) {

        __ct__18CScriptInterpreterFv(interpreter_storage);
    ((CScriptInterpreter *)interpreter_storage)->SetTag(gamedata_tag);
        ((CScriptInterpreter *)interpreter_storage)->SetScript(script, size);
        ((CScriptInterpreter *)interpreter_storage)->Run();
    }
    return 1;
}
void CGameData::InitItemMes(int clear, int unused) {
    int offset;
    CDataCommon *records;

    if (clear != 0) {

        clear = 0;
        offset = 0;
        do {
            records = (CDataCommon *)((u8 *)local_com_itemdata + offset);
            clear += 8;
            records[0].name = 0;
            records[1].name = 0;
            offset += 0x160;
            records[2].name = 0;
            records[3].name = 0;
            records[4].name = 0;
            records[5].name = 0;
            records[6].name = 0;
            records[7].name = 0;
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
    short list_no;

    record = (CDataCommon *)GetCommonData(item_no);
    if (record == NULL) {
        return 0;
    }
    list_no = record->list_no;
    if ((int)weapon_num <= list_no) {
        return 0;
    }
    if (weapon_data == 0) {
        return 0;
    }
    if (ConvertUsedItemType(record->type) != 3) {
        return 0;
    }
    return weapon_data + record->list_no;
}
CDataItem *CGameData::GetItemData(int item_no) {
    CDataCommon *record;
    short list_no;
    int type;

    record = (CDataCommon *)GetCommonData(item_no);
    if (record == NULL) {
        return 0;
    }
    list_no = record->list_no;
    if ((int)item_num <= list_no) {
        return 0;
    }
    if (item_data == 0) {
        return 0;
    }
    type = ConvertUsedItemType(record->type);
    if (type == 1 || type == 7 || type == 8) {
        return item_data + record->list_no;
    }
    return 0;
}
CDataAttach *CGameData::GetAttachData(int item_no) {
    CDataCommon *record;
    short list_no;

    record = (CDataCommon *)GetCommonData(item_no);
    if (record == NULL) {
        return 0;
    }
    list_no = record->list_no;
    if ((int)attach_num <= list_no) {
        return 0;
    }
    if (attach_data == 0) {
        return 0;
    }
    if (ConvertUsedItemType(record->type) != 2) {
        return 0;
    }
    return attach_data + record->list_no;
}
CDataRoboPart *CGameData::GetRoboData(int item_no) {
    CDataCommon *record;
    short list_no;
    CDataRoboPart *table;

    record = (CDataCommon *)GetCommonData(item_no);
    if (record == NULL) {
        return 0;
    }
    list_no = record->list_no;
    if ((int)robo_num <= list_no) {
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
    short list_no;

    record = (CDataCommon *)GetCommonData(item_no);
    if (record == NULL) {
        return 0;
    }
    list_no = record->list_no;
    if ((int)fish_num <= list_no) {
        return 0;
    }
    if (fish_data == 0) {
        return 0;
    }
    if (ConvertUsedItemType(record->type) != 6) {
        return 0;
    }
    return fish_data + record->list_no;
}
#pragma optimization_level 4
extern "C" u8 *GetGuardData__9CGameDataFi(CGameData *self, int item_no) {
    CDataCommon *record;
    short list_no;

    record = (CDataCommon *)GetCommonData__9CGameDataFi(self, item_no);
    if (record == NULL) {
        return 0;
    }
    list_no = record->list_no;
    if ((int)self->guard_num <= list_no) {
        return 0;
    }
    if (self->guard_data != 0) {
        return (u8 *)(self->guard_data + list_no);
    }
    return 0;
}
#pragma optimization_level reset
u8 CGameData::GetDataType(int item_no) {
    CDataCommon *common = GetCommonData(item_no);
    if (common != NULL) {
        return common->type;
    }
    return 0U;
}
short CGameData::GetDataTypeStartListNo(int type) {
    int i;
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
    return (CDataCommon *)GameItemDataManage.GetCommonData(item_no);
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
    char *name;

    if (record == NULL) {
        return NULL;
    }
    name = record->file_name;
    if (name == NULL) {
        return NULL;
    }
    strcpy(filename_1267, name);
    CSaveData *save_data = GetSaveData();
    u8 type = record->type;
    if ((type == 5 || type == 8) && save_data->GetBitFlag(0x31F) != 0) {
        strcat(filename_1267, at_1283__3);
    }
    if (variant != 0 && variant == 1) {
        strcat(filename_1267, at_1284__3);
    }
    return filename_1267;
}
char *GetItemFilePath(int item_no, int variant) {
    char name[0x20];
    CDataCommon *record;
    int type;
    char *file_name;

    item_file_path_1288[0] = 0;
    record = (CDataCommon *)GameItemDataManage.GetCommonData(item_no);
    if (record != NULL) {
        type = ConvertUsedItemType(record->type);
        file_name = GetItemFileName(item_no, 0);
        if (file_name != NULL) {
            strcpy(name, file_name);
        }
        switch (type) {
            case 3:
            case 4:
                strcpy(item_file_path_1288, at_1307__2);
                break;
            case 5:
                strcpy(item_file_path_1288, at_1308__2);
                break;
            default:
                strcpy(item_file_path_1288, at_1309__2);
                break;
        }
        strcat(item_file_path_1288, name);
        strcat(item_file_path_1288, at_1284__3);
        if (variant == 1) {
            if (type == 3) {
                sprintf(item_file_path_1288, at_1310__2, name);
            }
        }
        if (variant == 1 && (record->type == 0xD || record->type == 0xE)) {
            sprintf(item_file_path_1288, at_1311__2, name);
        }
    }
    return item_file_path_1288;
}
int GetItemDataType(int item_no) {
    return GetDataType__9CGameDataFi(&GameItemDataManage, item_no);
}
unsigned int GetItemDataAttribute(int item_no) {
    CDataCommon *record;

    record = (CDataCommon *)GameItemDataManage.GetCommonData(item_no);
    if (record != NULL) {
        return record->attribute;
    }
    return 0;
}
int ConvertUsedItemType(int item_no) {
    int type;

    type = 0;
    if (item_no > 0 && item_no < 5) {
        type = 3;
    } else if (item_no >= 5 && item_no < 11) {
        type = 4;
    } else if (item_no > 11 && item_no <= 15) {
        type = 5;
    } else if ((item_no >= 16 && item_no <= 19) || item_no == 0x22) {
        type = 2;
    } else if (item_no == 11 || item_no >= 20) {
        type = 1;
    }
    if (item_no == 0x1C) {
        type = 7;
    } else if (item_no == 0x1E) {
        type = 6;
    } else if (item_no == 0x23) {
        type = 8;
    }
    return type;
}
int GetItemMessageNo(int item_no, int message_kind) {
    CDataCommon *record;

    record = GameItemDataManage.GetCommonData(item_no);
    if (record == NULL) {
        return -1;
    }
    return ((CDataCommon *)record)->message_no + msg_offsettbl_1363[message_kind];
}
char *GetItemMessage(int item_no) {
    CDataCommon *record;

    record = (CDataCommon *)GameItemDataManage.GetCommonData(item_no);
    if (record != NULL) {
        return record->name;
    }
    return 0;
}
short GetItemIconNo(int item_no) {
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
#ifdef NONMATCHING
int GetMenuCommandMsg(int item_no, int *message_list) {
    int count;
    int type;

    count = 0;
    type = GetItemDataType(item_no);
    switch (type) {
        case 1:
        case 2:
        case 3:
        case 4:
            count = ItemCmdMsgSet(0, message_list);
            if (item_no == 0x12E || item_no == 0x12F) {
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
        case 11:
            count = ItemCmdMsgSet(7, message_list);
            break;
        case 12:
        case 14:
            count = ItemCmdMsgSet(2, message_list);
            break;
        case 13:
            count = ItemCmdMsgSet(22, message_list);
            break;
        case 15:
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
            switch (item_no) {
                case 0x126:
                    count = ItemCmdMsgSet(13, message_list);
                    break;
                case 0x12A:
                case 0x160:
                    count = ItemCmdMsgSet(17, message_list);
                    break;
                case 0x17D:
                    count = ItemCmdMsgSet(23, message_list);
                    break;
                case 0x128:
                    count = ItemCmdMsgSet(20, message_list);
                    break;
                case 0x184:
                    count = ItemCmdMsgSet(18, message_list);
                    break;
                case 0x185:
                    count = ItemCmdMsgSet(19, message_list);
                    break;
                case 0x182:
                    count = ItemCmdMsgSet(21, message_list);
                    break;
                case 0x124:
                case 0x111:
                case 0x11F:
                    count = ItemCmdMsgSet(3, message_list);
                    break;
                case 0x163:
                    count = ItemCmdMsgSet(26, message_list);
                    break;
                case 0x1A7:
                    count = ItemCmdMsgSet(25, message_list);
                    break;
                case 0x125:
                    count = ItemCmdMsgSet(27, message_list);
                    break;
                case 0xAE:
                    count = ItemCmdMsgSet(28, message_list);
                    break;
                case 0xAC:
                    count = ItemCmdMsgSet(30, message_list);
                    break;
                case 0x127:
                    count = ItemCmdMsgSet(31, message_list);
                    break;
                default:
                    count = ItemCmdMsgSet(4, message_list);
                    break;
            }
            break;
        case 29:
            count = ItemCmdMsgSet(9, message_list);
            break;
        case 21:
            count = ItemCmdMsgSet(10, message_list);
            break;
        case 28:
            count = ItemCmdMsgSet(11, message_list);
            break;
        case 30:
            count = ItemCmdMsgSet(12, message_list);
            break;
        case 32:
            count = ItemCmdMsgSet(15, message_list);
            break;
        case 35:
            count = ItemCmdMsgSet(29, message_list);
            break;
    }
    return count;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gamedata", GetMenuCommandMsg__FiPi);
#endif
#ifdef NONMATCHING
int CheckItemEquip(int chara, int item_no) {
    if (GetItemInfoData(item_no) == NULL) {
        return 0;
    }
    switch (item_no) {
        case 0x12A:
        case 0x171:
            if (chara != 0) {
                return 0;
            }
            break;
        case 0x160:
            if (chara != 1) {
                return 0;
            }
            break;
    }
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gamedata", CheckItemEquip__Fii);
#endif
int SearchItemByName(char *name) {
    int item_no;
    CDataCommon *record;

    for (item_no = 1; item_no < 512; item_no++) {
        record = (CDataCommon *)GetCommonItemData(item_no);
        if (record != NULL) {
            char *item_name = record->name;
            if ((item_name != 0) && (strcmp(item_name, name) == 0)) {
                return item_no;
            }
        }
    }
    return -1;
}
#ifdef NONMATCHING
s16 GetRidePodCore(int index) {
    static s16 table[8] = { 246, 247, 248, 249, 250, 251, 252, -1 }; 

    if (index < 0 || index >= 7) {
        return 0;
    }
    return table[index];
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gamedata", GetRidePodCore__Fi);
#endif
void Init_USEITEM_EFFECT(USEITEM_EFFECT *effect) {
    effect->target_flags = 0;
    effect->use_flags = 0;
    effect->status_flags = 0;
    effect->value[3] = 0;
    effect->value[2] = 0;
    effect->value[1] = 0;
    effect->value[0] = 0;
}
#ifdef NONMATCHING
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gamedata", GetUsedItemAfterEffect__FiP14USEITEM_EFFECT);
#endif
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

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gamedata", __sinit_gamedata_cpp);

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

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", D_0037AFFC__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gamedata", msg_offsettbl_1363__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(gamedata_build_stack, 0x4);
INCLUDE_BSS(comdatapt, 0x4);
INCLUDE_BSS(comdatapt_num, 0x4);
INCLUDE_BSS(SpiWeaponPt, 0x4);
INCLUDE_BSS(SpiItemPt, 0x4);
INCLUDE_BSS(SpiAttach, 0x4);
INCLUDE_BSS(SpiRoboPart, 0x4);
INCLUDE_BSS(SpiFish, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(GameItemDataManage, 0x30);
INCLUDE_BSS(local_com_itemdata, 0x4A40);
INCLUDE_BSS(local_itemdata, 0xA20);
INCLUDE_BSS(local_weapondata, 0x2270);
INCLUDE_BSS(local_attachdata, 0x390);
INCLUDE_BSS(local_robodata, 0x990);
INCLUDE_BSS(local_fishdata, 0x190);
INCLUDE_BSS(local_guarddata, 0x50);
INCLUDE_BSS(local_itemdatano_converttable, 0x400);
INCLUDE_BSS(gamedata_sysword_buffer_1073, 0x2800);
INCLUDE_BSS(filename_1267, 0x20);
INCLUDE_BSS(item_file_path_1288, 0x80);
