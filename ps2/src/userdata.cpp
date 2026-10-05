#include "common.h"
#include "userdata.hpp"
#include <cstring>
#include <cstdio>
#include <cstdlib>
#include <cmath>
extern "C" double pow(double base, double exponent);
int get_gajji_id_from_monster_progress_table(int monster_no, int *level);
int get_monster_tbl_bajjilevel(int *out, int bajji_no, int monster_no, int level);
int get_default_monster_progresstbl(int bajji_no);
#include "gamedata.hpp"
#include "savedata.hpp"
#include "mainloop.hpp"
#include "menucommon.hpp"
#include "menucls1.hpp"
#include "scene.hpp"
#include "monster.hpp"
#include "memcard.hpp"
#include "quest.hpp"
#include "npccfg.hpp"
#include "scenesnd.hpp"

struct PackedFish {
    u16 item_no : 9;
    u8 sex : 1;
    u8 field_4a : 5;
    u8 param_3 : 7;
    u16 unknown_3c : 7;
    u16 length : 15;
    u16 weight : 15;
    u8 param_0 : 7;
    u16 param_1 : 7;
    u8 color_no : 2;
    u8 param_2 : 7;
    u16 flags : 8;
};
union PackedFishBuffer { signed char bytes[14]; PackedFish fish; };
struct CharaBitTable { int bit[4]; };
extern CharaBitTable at_3192;
extern CGameDataUsed *FishGamePreEquip;
extern char *magic_str_1462[8];
extern char word_1327[0x61];
extern char *symbol_tbl_1338[8][2][2];
extern char *MenuBigNum[10];
extern signed char htbl_1662[10];
extern char *strtbl_1505[8];
extern char temp_1510[0x40];
extern char *f_2005[2];
extern char *basefish_1288[];
extern char aquarium_fish_maxtbl[3];
extern unsigned char use_limmit_table_2558[7];
extern MOS_HENGE_PARAM mos_henge_param[];
extern short fish_record_dataindex_convert[];
extern char *robo_nametable_3330[];
extern float lifetbl_2854[2];
extern short weptbl_4503[2][10];
extern int BattleParamater_Time;
extern int BattleParamater_TimeBand;
extern signed char tbl1_5167[3];
extern signed char tbl2_5168[2];
extern unsigned int at_table_5400[12];
extern signed char equip_type_tbl_5456[15];
extern "C" int fptosi(float);
extern "C" unsigned int fptoui(float);
extern char at_1378__2[];
extern char at_1379__2[];
extern char at_1623[];
extern char at_1624[];
extern char at_1637[];
extern char at_2061[];
extern char at_5773[];

// Code (.text)
CUserDataManager *GetUserDataMan() {
    CSaveData *save = GetSaveData();
    return save != NULL ? &save->user_data : NULL;
}
CFishingTournament *GetFishTournament() {
    CUserDataManager *user = GetUserDataMan();
    return user != NULL ? &user->fish_tournament : NULL;
}
CFishAquarium *GetAquariumData() {
    CUserDataManager *user = GetUserDataMan();
    return user != NULL ? &user->aquarium : NULL;
}
int COMMON_GAGE::CheckFill() {
    int full;

    full = 1;
    if (this->max != this->now) {
        full = 0;
    }
    return full;
}
float COMMON_GAGE::GetRate() {
    if (this->max != 0.0f) {
        return this->now / this->max;
    }
    return 0.0f;
}
void COMMON_GAGE::SetFillRate(float rate) {
    this->now = this->max * rate;
}
void COMMON_GAGE::AddPoint(float amount) {
    float now;
    float max;

    now = (float)(this->now + amount);
    this->now = now;
    if (now <= 0.0f) {
        this->now = 0.0f;
    }
    max = (float)(this->max);
    if (max <= this->now) {
        this->now = max;
    }
}
void COMMON_GAGE::AddRate(float rate) {
    float now;
    float max;

    this->now += this->max * rate;
    now = this->now;
    if (now <= 0.0f) {
        this->now = 0.0f;
    }
    max = (float)(this->max);
    if (max <= this->now) {
        this->now = max;
    }
}
float GetCommonGageRate(COMMON_GAGE *gage) {
    if (gage != NULL) return gage->GetRate();
    return 0.0f;
}
int CalcBreedFishParam(BREEDFISH_USED *fish) {
    u16 *param = (u16 *)((u8 *)fish + 0x26);
    int total = 0;
    int i;
    for (i = 0; i < 5; i++) {
        total += param[i];
    }
    return total;
}
void SetFishingGamePreEquip(CGameDataUsed *data) {
    FishGamePreEquip = data;
}
void ReEquipFishingGameWeapon(void) {
    if (FishGamePreEquip != NULL) {
        CUserDataManager *manager = GetUserDataMan();
        manager->SetChrEquip(0, FishGamePreEquip);
        FishGamePreEquip = NULL;
    }
}
int CheckFishingWeapon(CGameDataUsed *weapon) {
    return FishGamePreEquip == weapon;
}
void GameDataSwap(CGameDataUsed *first, CGameDataUsed *second, int mode) {

    int first_is_rod;
    CGameDataUsed *equipped;

    if (first == NULL || second == NULL) {
        return;
    }
    {

        CGameDataUsed spare;
        spare.CopyGameData(first);
        first->CopyGameData(second);
        second->CopyGameData(&spare);
        if (mode == 1) {
            equipped = &GetUserDataMan()->chara_data[0].equip[0];
            if (equipped == first || equipped == second) {
                first_is_rod = first->IsFishingRod();
                if (first_is_rod != second->IsFishingRod()) {
                    if (equipped == first) {
                        SetFishingGamePreEquip(NULL);
                        if (first->IsFishingRod()) {
                            SetFishingGamePreEquip(second);
                        }
                    }
                    if (equipped == second) {
                        SetFishingGamePreEquip(NULL);
                        if (second->IsFishingRod()) {
                            SetFishingGamePreEquip(first);
                        }
                    }
                    return;
                }
            }
            if (equipped->IsFishingRod() &&
                (first == FishGamePreEquip || second == FishGamePreEquip)) {
                if (first == FishGamePreEquip) {
                    SetFishingGamePreEquip(second);
                    return;
                }
                if (second == FishGamePreEquip) {
                    SetFishingGamePreEquip(first);
                }
            }
        }
    }
}
int CheckNowRoboUseCapacity(ROBO_DATA *robo, int *out_capacity) {
    int used = 0;
    for (int i = 0; i < 4; i++) {
        used += robo->parts[i].GetUseCapacity();
    }
    if (out_capacity != NULL) {
        *out_capacity = GetUserDataMan()->CheckCapacity();
    }
    return used;
}
extern "C" CGameDataUsed *__ct__13CGameDataUsedFv(CGameDataUsed *self) {
    self->Init();
    return self;
}
void CGameDataUsed::Init() {
    memset(this, 0, sizeof(CGameDataUsed));
}
int CGameDataUsed::CheckTypeEnableStack() {
    if (used_type == 1) {
        return 1;
    }
    if (used_type == 2) {
        if (item_no == 185) {
            return 0;
        }
        return (item_no == 0x17F) ^ 1;
    }
    return 0;
}
char *CGameDataUsed::GetDataPath() {
    return GetItemFilePath(item_no, 0);
}
int CGameDataUsed::IsWhoEquip() {
    int item_type;

    if (this->used_type == 3) {
        item_type = this->item_type;
        if (item_type == 1 || item_type == 2 || item_type == 5 || item_type == 6 || item_type == 7) {
            return 0;
        }
        if (item_type == 3 || item_type == 4 || item_type == 8 || item_type == 9 || item_type == 0xA) {
            return 1;
        }
        return -1;
    }
    if (this->used_type == 5) {
        return 2;
    }
    return -1;
}
int CGameDataUsed::GetLevel() {
    if (used_type == 3) {
        return data.weapon.level;
    }
    if (used_type == 2) {
        return this->data.attach.level;
    }
    return 0;
}
int CGameDataUsed::GetPalletColor() {
    CDataWeapon *data;

    switch (this->used_type) {
        case 3:
            data = (CDataWeapon *)GameItemDataManage.GetWeaponData(this->item_no);
            if (data != NULL) {
                return *(s8 *)&data->pallet_color;
            }
            return 0;
    }
    return 0;
}
int CGameDataUsed::GetSpectolNo() {
    if (item_no == 185) {
        return this->data.attach.spectol_item_no;
    }
    return 0;
}
int CGameDataUsed::CheckStackRemain() {
    CDataCommon *record;

    if (CheckTypeEnableStack() == 0) {
        return 0;
    }
    record = GetCommonItemData(this->item_no);
    if (record != NULL) {
        return record->stack_num - GetNum();
    }
    return 0;
}
int CGameDataUsed::GetNum() {
    if (item_no <= 0) {
        return 0;
    }
    switch (used_type) {
        case 1:
        case 4:
            return this->data.item.num;
        case 2:
            if (item_type == 0x11) {
                return 1;
            }
            if (item_type == 0x22) {
                return 1;
            }
            return this->data.attach.num;
        default:
            return 1;
    }
}
u8 CGameDataUsed::GetActiveSetNum(void) {
    return this->IsActiveSet();
}
int CGameDataUsed::AddNum(int count, int clear) {
    int num;
    CDataCommon *record;
    CGameDataUsed *stacked = (CGameDataUsed *)this;
    CGameDataUsed *attachment = (CGameDataUsed *)this;

    if (item_no <= 0) {
        return 0;
    }
    record = GetCommonItemData(item_no);
    if (used_type != 2) {
        num = 1;
        if (used_type != 1) {
            num += count;
        } else {
            stacked->data.item.num += count;
            if (stacked->data.item.num < 0) {
                stacked->data.item.num = 0;
            }
            if (record->max_num < stacked->data.item.num) {
                stacked->data.item.num = record->max_num;
            }
            num = stacked->data.item.num;
        }
    } else {
        attachment->data.attach.num += count;
        if (attachment->data.attach.num < 0) {
            attachment->data.attach.num = 0;
        }
        if (record->max_num < attachment->data.attach.num) {
            attachment->data.attach.num = record->max_num;
        }
        num = attachment->data.attach.num;
    }
    if (num <= 0) {
        if (clear != 0) {
            Init();
        }
    }
    return num;
}
int CGameDataUsed::GetUseCapacity() {
    short *robo_data = (short *)GameItemDataManage.GetRoboData(item_no);
    if (robo_data != NULL)
        return *robo_data;
    return 0;
}
int CGameDataUsed::AddFishHp(int amount) {
    if (used_type == 6) {
        CGameDataUsed *fish = (CGameDataUsed *)this;
        int hp = fish->data.fish.hp + amount;
        if (hp < 0) {
            hp = 0;
        }
        if (hp > 100) {
            hp = 100;
        }
        fish->data.fish.hp = hp;
        return fish->data.fish.hp;
    }
    return 0;
}
int CGameDataUsed::Boiled() {
    CGameDataUsed *fish = (CGameDataUsed *)this;
    char converted[0x40];
    char text[0x40];
    int value;

    sprintf(text, basefish_1288[LanguageCode], this->GetName(0));
    ConvertFontCode(text, converted);
    value = fish->data.fish.size / 100 + (fish->data.fish.param[0] + fish->data.fish.param[1] + fish->data.fish.param[2]) / 3;
    strcpy(fish->data.boiled.name, converted);
    fish->data.boiled.base_item_no = fish->item_no;
    fish->data.boiled.value = value + 0x14;
    fish->item_type = 0x23;
    fish->used_type = 8;
    fish->item_no = 0x1AA;
    return 1;
}
u8 CGameDataUsed::IsActiveSet(void) {
    CDataCommon *item = GetCommonItemData(item_no);
    if (item != NULL) {
        return item->active_set;
    }
    return 0U;
}
void CGameDataUsed::SetName(char *name) {
    char *buffer;

    buffer = NULL;
    switch (used_type) {
        case 3:
            buffer = this->data.weapon.name;
            break;
        case 5:
            buffer = &((CGameDataUsed *)this)->data.robopart.name[0];
            break;
        case 6:
            buffer = this->data.fish.name;
            break;
        case 2:
            buffer = this->data.attach.name;
            break;
    }
    if ((buffer != NULL) && (strlen(name) < 0x20U)) {
        strcpy(buffer, name);
        char *default_name = GetItemMessage(item_no);
        rename_flag = 0;
        if ((default_name != 0) && (strcmp(default_name, buffer) != 0)) {
            rename_flag = 1;
        }
    }
}
#pragma divbyzerocheck on
char *CGameDataUsed::GetName(int name_type) {
    char *name;
    int weapon_level;
    int digits;
    int divisor;
    int digit;

    memset(word_1327, 0, 0x61);
    switch (used_type) {
        case 3:
            name = (char *)this + 0x43;
            break;
        case 5:
            name = (char *)this + 0x3C;
            break;
        case 6:
            name = (char *)this + 0x10;
            break;
        case 2:
            if (item_no == 185) {
                name = (char *)this + 0x30;
            } else {
                name = GetItemMessage(item_no);
    }
            break;
        case 8:
            name = (char *)this + 0x12;
            break;
        default:
            name = GetItemMessage(item_no);
            break;
        }
    if (name != NULL) {
        if (name_type == 2) {
            strcpy(word_1327, symbol_tbl_1338[LanguageCode][(signed char)rename_flag][0]);
            strcat(word_1327, name);
    }
        if (name_type == 0 || name_type == 1) {
            strcpy(word_1327, name);
        }
    }
    if (name_type > 0 && (used_type == 3 || used_type == 2)) {
        weapon_level = GetLevel();
        if (weapon_level > 0) {
            if ((int)LanguageCode > 0) {
                strcat(word_1327, at_1378__2);
                sprintf(word_1327, word_1327, weapon_level);
            } else {
                strcat(word_1327, at_1379__2);
                digits = GetNumberKeta(weapon_level);
                if (digits > 0) {
                    do {
                        if (digits == 1) {
                            strcat(word_1327, (char *)MenuBigNum[weapon_level]);
                            digits -= 1;
                        } else {
                            divisor = (int)pow(10.0, (double)(digits - 1));
                            digit = weapon_level / divisor;
                            strcat(word_1327, (char *)MenuBigNum[digit]);
                            digits -= 1;
                            weapon_level -= digit * divisor;
                        }
                    } while (digits > 0);
                }
            }
        }
    }
    if (name != NULL && name_type == 2) {
        strcat(word_1327, symbol_tbl_1338[LanguageCode][(signed char)rename_flag][1]);
    }
    return word_1327;
}
#pragma divbyzerocheck reset
void CGameDataUsed::TransToPassword(char *data, int length) {
    CGameDataUsed *item = (CGameDataUsed *)this;
    PackedFishBuffer buffer;
    signed char *src;
    int i;
    BREEDFISH_USED *body;

    if (data != NULL) {
        memset(data, 0, 4);
        switch (used_type) {
            case 6: {
                body = &item->data.fish;
                memset(&buffer, 0, 14);
                buffer.fish.item_no = item->item_no;
                buffer.fish.sex = *(s8 *)&body->sex;
                buffer.fish.field_4a = body->unk_3a;
                buffer.fish.param_3 = body->param[4];
                buffer.fish.unknown_3c = body->param[3];
                buffer.fish.length = body->size;
                buffer.fish.weight = body->weight;
                buffer.fish.param_0 = body->param[0];
                buffer.fish.param_1 = body->param[1];
                buffer.fish.color_no = body->unk_16;
                buffer.fish.param_2 = body->param[2];
                buffer.fish.flags = body->flags;
                src = buffer.bytes;
                for (i = 0; i < length && i < 14; i++) {
                    data[i] = src[i];
                }
                data[i] = 0;
            }
        }
    }
}
void CGameDataUsed::TransToData(char *data, int length) {
    CGameDataUsed *item = (CGameDataUsed *)this;
    PackedFishBuffer buffer;
    signed char *dst;
    int i;

    if (data != NULL) {
        switch (used_type) {
            case 6: {
                dst = buffer.bytes;
                for (i = 0; i < 14 && i < length; i++) {
                    dst[i] = ((signed char *)data)[i];
                }
                item->item_no = buffer.fish.item_no;
                item->data.fish.sex = buffer.fish.sex;
                item->data.fish.unk_3a = buffer.fish.field_4a;
                item->data.fish.param[4] = buffer.fish.param_3;
                item->data.fish.param[3] = buffer.fish.unknown_3c;
                item->data.fish.size = buffer.fish.length;
                item->data.fish.weight = buffer.fish.weight;
                item->data.fish.param[0] = buffer.fish.param_0;
                item->data.fish.param[1] = buffer.fish.param_1;
                item->data.fish.param[2] = buffer.fish.param_2;
                item->data.fish.unk_16 = buffer.fish.color_no;
                item->data.fish.flags = buffer.fish.flags;
            }
        }
    }
}
int CGameDataUsed::DeleteNum(int count) {
    int before;
    int delta;

    if (count <= 0) {
        return 0;
    }
    before = GetNum();
    switch (this->used_type) {
        case 1:
        case 2:
            delta = AddNum(-count, 1);
            break;
        default:
            delta = 0;
            Init();
            break;
    }
    return before - delta;
}
int CGameDataUsed::RemainFusion() {
    if (used_type == 3) {
        return this->data.weapon.fusion_point;
    }
    return 0;
}
int CGameDataUsed::AddFusionPoint(int points) {
    int total;
    CGameDataUsed *weapon = (CGameDataUsed *)this;

    if (used_type == 3) {
        total = weapon->data.weapon.fusion_point + points;
        if (total < 0) {
            total = 0;
        }
        if (((CGameDataUsed *)weapon)->IsFishingRod()) {
            if (total >= 9999) {
                total = 9999;
            }
        } else if (total >= 999) {
            total = 999;
        }
        weapon->data.weapon.fusion_point = total;
        return weapon->data.weapon.fusion_point;
    }
        return 0;
}
int CGameDataUsed::GetEffectReadType(char **effect_name, char **hit_name, int *points) {
    int elem;

    if (used_type == 3) {
        int weapon_type = item_type;
        GetWeaponInfoData(item_no);
        if (weapon_type == 4) {
            elem = this->GetActiveElem();
            if (effect_name != NULL) {
                *effect_name = magic_str_1462[elem * 2];
    }
            if (hit_name != NULL) {
                *hit_name = magic_str_1462[elem * 2 + 1];
            }
            if (points != NULL) {
                *points = *(short *)((elem << 1) + (int)this + 0x26);
            }
            return elem;
        }
    }
    return 0;
}
extern "C" int GetYarikomiMedal__16CUserDataManagerFv(CUserDataManager *);
void CGameDataUsed::GetMsgAddInfo(char **message, char **extra_message, int *values) {
    ATTACH_USED *body;
    char *text;

    if (values != NULL) {
        values[0] = 0;
    }
    if (message != NULL) {
        *message = NULL;
    }
    if (extra_message != NULL) {
        *extra_message = NULL;
    }
    *message = GetName(2);
    switch (used_type) {
        case 1:
            if (item_no == 0x137) {
                values[0] = GetYarikomiMedal__16CUserDataManagerFv(GetUserDataMan());
            }
            break;
        case 3:
            if (values != NULL) {
                values[0] = GetLevel();
            }
            break;
        case 2:
            body = &this->data.attach;
            if (values != NULL) {
                values[0] = 0;
                if (*(s8 *)&body->spectol_type == 1) {
                    values[0] = body->level;
                }
                values[1] = body->spectol_value;
            }
            if (*(s8 *)&body->spectol_type != 0) {
                *message = body->name;
            } else {
                *message = GetItemMessage(item_no);
            }
            text = *message;
            if (text != NULL) {
                sprintf(temp_1510, strtbl_1505[LanguageCode], text);
                *message = temp_1510;
            }
            *extra_message = GetName(1);
            break;
    }
}
float CGameDataUsed::GetWHp(int *hp) {
    float rate;
    COMMON_GAGE *gauge;

    rate = 1.0f;
    gauge = NULL;
    if (hp != NULL) {
        hp[0] = 0;
        hp[1] = 0;
    }
    switch (used_type) {
        case 3:
            gauge = &data.weapon.whp;
            break;
        case 5:
            if (item_type == 0xD) {
                gauge = &data.weapon.abs;
            }
            if (item_type == 0xF) {
                gauge = &data.weapon.whp;
            }
            break;
    }
    if (gauge != NULL) {
        if (hp != NULL) {
            hp[0] = GetDispVolumeForFloat(gauge->now);
            hp[1] = (int)gauge->max;
        }
        rate = gauge->GetRate();
    }
    return rate;
}
int CGameDataUsed::IsRepair() {
    switch (this->used_type) {
        case 3:
            if ((float)GetDispVolumeForFloat(this->data.weapon.whp.now) < this->data.weapon.whp.max) {
                return 1;
            }
            break;
        case 5:
            if (this->item_type == 0xD &&
                (float)GetDispVolumeForFloat(this->data.weapon.abs.now) < this->data.weapon.abs.max) {
                return 1;
            }
            if (this->item_type == 0xF &&
                (float)GetDispVolumeForFloat(this->data.weapon.whp.now) < this->data.weapon.whp.max) {
                return 1;
            }
            break;
    }
    return 0;
}
int CGameDataUsed::Repair(int points) {
    COMMON_GAGE *gauge;

    gauge = NULL;
    switch (this->used_type) {
        case 3:
            gauge = &this->data.weapon.whp;
            break;
        case 5:
            if (this->item_type == 0xD) {
                gauge = &this->data.weapon.abs;
    }
            if (this->item_type == 0xF) {
                gauge = &this->data.weapon.whp;
    }
            break;
    }
    if (gauge != NULL) {
        gauge->AddPoint((float)points);
    }
    return 1;
}
int CGameDataUsed::GetEnableRepairItemNo() {
    if (item_type == 1 || item_type == 3 || item_type == 0xD) {
        return 0x126;
    }
    if (item_type == 2) {
        return 0x12A;
    }
    if (item_type == 4) {
        return 0x160;
    }
    if (item_type == 0xF) {
        return 0x17D;
    }
    return 0;
}
int CGameDataUsed::IsEnableUseRepair(int item_no) {
    return item_no == GetEnableRepairItemNo();
}
int CGameDataUsed::GetRoboInfoType() {
    CDataRoboPart *info = (CDataRoboPart *)GetRoboPartInfoData(item_no);
    if (info == NULL) {
        return -1;
    }
    if (item_type == 0xD) {
        return info->info_type_d;
    }
    if (item_type == 0xE) {
        return info->info_type_e;
    }
    return -1;
}
extern "C" int GetOffsetNo__13CDataRoboPartFv(CDataRoboPart *);
void CGameDataUsed::GetRoboJointName(char *name) {
    CDataRoboPart *record = (CDataRoboPart *)GetRoboPartInfoData(item_no);

    if (record == NULL || name == NULL) {
        return;
    }
    if (item_type == 0xD) {
        sprintf(name, at_1623, GetOffsetNo__13CDataRoboPartFv(record));
    }
    if (item_type == 0xC) {
        sprintf(name, at_1624, GetOffsetNo__13CDataRoboPartFv(record));
    }
}
void CGameDataUsed::GetRoboSoundFileName(char *name) {
    CDataRoboPart *record = (CDataRoboPart *)GetRoboPartInfoData(item_no);

    if (record == NULL || name == NULL) {
        return;
    }
    if (item_type == 0xD) {
        int sound_no = GetOffsetNo__13CDataRoboPartFv(record) + 0x27;
        if (sound_no < 0x28 || sound_no > 0x32) {
            sound_no = 0x28;
        }
        sprintf(name, at_1637, sound_no);
    }
}
int CGameDataUsed::IsBroken() {
    int hp[2];

    if (item_type == 0xF) {
        GetWHp(hp);
        if (hp[0] <= 0) {
            return 1;
        }
    }
    return 0;
}
int CGameDataUsed::IsLevelUp() {

    switch (this->used_type) {
        case 3:
            if (this->data.weapon.level < 99) {
                if (this->data.weapon.abs.max <= (float)GetDispVolumeForFloat(this->data.weapon.abs.now)) {
                    return 1;
                }
            }
            break;
    }
    return 0;
}
void CGameDataUsed::LevelUp() {
    CUserDataManager *manager = GetUserDataMan();
    CDataWeapon *info = (CDataWeapon *)GetWeaponInfoData(item_no);
    int party_chara;
    WEAPON_USED *block;
    float rate;
    float new_point;
    int favoured;
    int found;
    int tries;
    int slot;
    int i;

    if (manager == NULL || info == NULL) {
        return;
    }
    {
        party_chara = manager->NowPartyCharaID();
        block = &data.weapon;
        rate = block->whp.GetRate();
        block->whp.max += (float)htbl_1662[GetRandI(10)];
        if (255.0f <= block->whp.max) {
            block->whp.max = 255.0f;
        }
        new_point = block->whp.max * rate;
        if (new_point > block->whp.now) {
            block->whp.now = new_point;
        }
        if (block->level < 5) {
            if (block->status[0] < 100) {
                block->status[0] = block->status[0] + 2;
            } else {
                block->status[0] = block->status[0] + 3;
            }
        } else {
            block->status[0] = block->status[0] + 1;
        }
        block->status[1] = block->status[1] + 1;
        block->abs.now = 0.0f;
        block->abs.max =
            (float)(info->levelup_exp + info->levelup_exp / 2 * block->level);
        AddFusionPoint(info->fusion_point);
        favoured = 0;
        if (party_chara == 1) {
            if (item_type == 1) {
                favoured = 1;
            }
        }
        if (party_chara == 0xF) {
            if (item_type == 3) {
                favoured = 1;
            }
        }
        if (party_chara == 0x10) {
            if (item_type == 2) {
                favoured = 1;
            }
        }
        if (party_chara == 0x1A) {
            if (item_type == 4) {
                favoured = 1;
            }
        }
        if (favoured == 1) {
            AddFusionPoint(1);
            CheckParamLimmit();
            found = 0;
            tries = 0;
            do {
                slot = GetRandI(0x11) % 8;
                if (block->attribute[slot] < info->attribute_max[slot]) {
                    found = 1;
                    block->attribute[slot] = block->attribute[slot] + 1;
                }
                tries++;
            } while (tries < 0x80 && found == 0);
            if (found <= 0 && tries >= 0x80) {
                for (i = 0; i < 8; i++) {
                    if (block->attribute[i] < info->attribute_max[i]) {
                        block->attribute[i] = block->attribute[i] + 1;
                        break;
                    }
                }
            }
        }
        block->level = block->level + 1;
        if (block->level > 99) {
            block->level = 99;
        }
        CheckParamLimmit();
    }
}
int CGameDataUsed::IsTrush(void) {
    int is_rubbish = 0;
    CDataCommon *item = GetCommonItemData(item_no);
    if (item != NULL && (item->attribute & ITEM_ATTRIBUTE_TRUSH)) {
        is_rubbish = 1;
    }
    if (used_type == USED_ITEM_TYPE_FISH) {
        if (data.fish.flags & BREEDFISH_FLAG_ELECTRIC) {
            is_rubbish = 0;
        }
    }
    return is_rubbish;
}
int CGameDataUsed::IsSpectolTrans() {
    CDataCommon *record = GetCommonItemData(item_no);
    if (record != NULL && (record->attribute & 2)) {
        return 1;
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/userdata", ToSpectolTrans__13CGameDataUsedFP13CGameDataUsedi);
void CGameDataUsed::GetStatusParam(short *param) {
    if (param != NULL) {
        if (used_type == 3) {
            param[0] = data.weapon.status[0];
            param[1] = data.weapon.status[1];
            param[2] = data.weapon.attribute[0];
            param[3] = data.weapon.attribute[1];
            param[4] = data.weapon.attribute[2];
            param[5] = data.weapon.attribute[3];
            param[6] = data.weapon.attribute[4];
            param[7] = data.weapon.attribute[5];
            param[8] = data.weapon.attribute[6];
            param[9] = data.weapon.attribute[7];
        } else if (used_type == 2) {
            CGameDataUsed *attachment = (CGameDataUsed *)this;
            param[0] = attachment->data.attach.status[0];
            param[1] = attachment->data.attach.status[1];
            param[2] = attachment->data.attach.attribute[0];
            param[3] = attachment->data.attach.attribute[1];
            param[4] = attachment->data.attach.attribute[2];
            param[5] = attachment->data.attach.attribute[3];
            param[6] = attachment->data.attach.attribute[4];
            param[7] = attachment->data.attach.attribute[5];
            param[8] = attachment->data.attach.attribute[6];
            param[9] = attachment->data.attach.attribute[7];
        } else if (used_type == 5) {

            param[0] = data.weapon.level;
            param[1] = data.weapon.status[0];
            param[2] = data.weapon.status[1];
            param[3] = data.weapon.attribute[0];
            param[4] = data.weapon.attribute[1];
            param[5] = data.weapon.attribute[2];
            param[6] = data.weapon.attribute[3];
            param[7] = data.weapon.attribute[4];
            param[8] = data.weapon.attribute[5];
            param[9] = data.weapon.attribute[6];
        }
    }
}
void CGameDataUsed::GetStatusParam(short *param, float time) {
    this->GetStatusParam(param);
    if (this->item_no == 0x38) {
        if (GetTimeBand(time) == 2) {
            *param = *param + (*param >> 1);
        } else {
            *param = *param >> 1;
        }
    }
}
int CGameDataUsed::IsBuildUp(int *count, int *item_nos, int *flags) {
    COMMON_GAGE *gauge;
    CDataWeapon *info;
    CDataWeapon *target;
    float mine[16];
    float other[16];
    int built_up;
    int found;
    int i;
    int k;
    int ok;

    built_up = 0;
    found = 0;
    if (this->used_type == 3) {
        gauge = &this->data.weapon.whp;
        info = (CDataWeapon *)GetWeaponInfoData(this->item_no);
        if (info == NULL) {
            return 0;
        }

        mine[0] = *(short *)((u8 *)gauge + 0x12);
        mine[1] = *(short *)((u8 *)gauge + 0x16);
        mine[2] = *(short *)((u8 *)gauge + 0x18);
        mine[3] = *(short *)((u8 *)gauge + 0x1A);
        mine[4] = *(short *)((u8 *)gauge + 0x1C);
        mine[5] = *(short *)((u8 *)gauge + 0x1E);
        mine[6] = *(short *)((u8 *)gauge + 0x20);
        mine[7] = *(short *)((u8 *)gauge + 0x22);
        mine[8] = *(short *)((u8 *)gauge + 0x24);
        for (i = 0; i < 3; i++) {
            target = (CDataWeapon *)GetWeaponInfoData(info->buildup_weapon[i]);
            if (target != NULL) {
                other[0] = target->status[0];
                other[1] = target->attribute[0];
                other[2] = target->attribute[1];
                other[3] = target->attribute[2];
                other[4] = target->attribute[3];
                other[5] = target->attribute[4];
                other[6] = target->attribute[5];
                other[7] = target->attribute[6];
                other[8] = target->attribute[7];
                ok = 1;
                for (k = 0; k < 9; k++) {
                    other[k] *= 0.9f;
                    if (mine[k] < other[k]) {
                        ok = 0;
                        break;
                    }
                }
                found++;
                if (item_nos != NULL) {
                    item_nos[i] = info->buildup_weapon[i];
                }
                if (flags != NULL) {
                    flags[i] = ok;
                }
                if (ok != 0) {
                    built_up++;
                }
            }
        }
    }
    if (count != NULL) {
        *count = found;
    }
    return built_up;
}
int CGameDataUsed::IsFishingRod() {
    if (this->item_no == 0x12E || this->item_no == 0x12F) {
        return 1;
    }
    return 0;
}
int CGameDataUsed::GetActiveElem() {
    CGameDataUsed *weapon = (CGameDataUsed *)this;
    int best;
    int i;

    if (this->used_type == 3) {
        best = 0;
        for (i = 1; i < 4; i++) {
            if (weapon->data.weapon.attribute[best] < weapon->data.weapon.attribute[i]) {
                best = i;
            }
        }
        return best;
    }
    return -1;
}
int CGameDataUsed::GetAttackType() {
    CDataWeapon *info;

    if (this->used_type == 3) {
        info = (CDataWeapon *)GetWeaponInfoData(this->item_no);
        if (info != NULL) {
            return *(s8 *)&info->attack_type;
        }
    }
    return this->used_type == 5 ? this->GetRoboInfoType() : -1;
}
char CGameDataUsed::GetModelNo(void) {
    if (used_type == USED_ITEM_TYPE_WEAPON) {
        CDataWeapon *weapon = GetWeaponInfoData(item_no);
        if (weapon != NULL) {
            return weapon->model_no;
        }
        return -1;
    }
    return -1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/userdata", GetMainCharaModelName__FiPci);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/userdata", CheckParamLimmit__13CGameDataUsedFv);
void CGameDataUsed::TimeCheck(int elapsed) {
    int time_left;

    if (used_type == 6) {
        CGameDataUsed *fish = (CGameDataUsed *)this;
        time_left = (int)(fish->data.fish.timer - elapsed);
        if (time_left < 0) {
            time_left = 0;
        }
        fish->data.fish.timer = (u16)time_left;
    }
}
int CGameDataUsed::GetGiftBoxItemNum() {
    int count = 0;
    if (used_type == 7) {
        for (int i = 0; i < 3; i++) {
            if (this->data.giftbox.item_no[i] > 0) {
                count++;
            }
        }
    }
    return count;
}
int CGameDataUsed::SetGiftBoxItem(int item_no, int slot) {
    CGameDataUsed *box = (CGameDataUsed *)this;
    int result;
    int i;

    result = -1;
    if (this->used_type == 7) {
        if (slot < 0) {
            for (i = 0; i < 3; i++) {
                if (box->data.giftbox.item_no[i] <= 0) {
                    result = i;
                    box->data.giftbox.item_no[i] = item_no;
                    break;
                }
            }
        } else {
            box->data.giftbox.item_no[slot] = item_no;
        }
    }
    return result;
}
int CGameDataUsed::GetGiftBoxItemNo(int slot) {
    if (used_type == 7) {
        if (0 <= slot && slot < 3) {
            return data.giftbox.item_no[slot];
        }
    }
    return 0;
}
int CGameDataUsed::GetGiftBoxSameItemNum(int box_item_no) {
    if (used_type != 7) {
        return 0;
    }
    int count = 0;
    for (int i = 0; i < 3; i++) {
        if (this->data.giftbox.item_no[i] == box_item_no) {
            count++;
        }
    }
    return count;
}
void CGameDataUsed::CopyGameData(CGameDataUsed *other) {
    ROBO_DATA *robo;
    int old_max;

    if (other != NULL) {
        memcpy(this, other, sizeof(CGameDataUsed));
        robo = &GetUserDataMan()->robo_data;
        if (robo != NULL && &(&robo->parts[0])[2] == this) {
            old_max = fptosi(robo->hp.max);
            robo->hp.max = this->data.weapon.whp.max;
            if ((float)old_max <= 0.0f) {
                robo->hp.now = robo->hp.max;
            }
            if (robo->hp.max < robo->hp.now) {
                robo->hp.now = robo->hp.max;
            }
        }
    }
}
int CGameDataUsed::CopyDataWeapon(int item_no) {
    CDataWeapon *record;
    char *message;
    float durability;
    COMMON_GAGE *gauge;

    record = (CDataWeapon *)GameItemDataManage.GetWeaponData(item_no);
    if (record == NULL) {
        return 0;
    }
    this->used_type = 3;
    this->item_no = item_no;
    this->item_type = GetItemDataType(item_no);
    gauge = &this->data.weapon.whp;
    this->data.weapon.level = 0;
    durability = record->durability;
    this->data.weapon.whp.max = durability;
    this->data.weapon.whp.now = durability;
    *(int *)&this->data.weapon.abs.now = 0;
    this->data.weapon.abs.max = record->levelup_exp;
    this->data.weapon.status[0] = record->status[0];
    this->data.weapon.status[1] = record->status[1];
    this->data.weapon.attribute[0] = record->attribute[0];
    this->data.weapon.attribute[1] = record->attribute[1];
    this->data.weapon.attribute[2] = record->attribute[2];
    this->data.weapon.attribute[3] = record->attribute[3];
    this->data.weapon.attribute[4] = record->attribute[4];
    this->data.weapon.attribute[5] = record->attribute[5];
    this->data.weapon.attribute[6] = record->attribute[6];
    this->data.weapon.attribute[7] = record->attribute[7];
    this->data.weapon.fusion_point = record->unk_38;
    this->data.weapon.special = record->special;
    this->data.weapon.unk_2e = 0;
    this->data.weapon.unk_30 = 0;
    message = GetItemMessage(item_no);
    if (message != NULL) {
        strcpy((char *)gauge + 0x33, message);
    }
    this->rename_flag = 0;
    return 1;
}
int CGameDataUsed::CopyDataAttach(int new_item_no) {
    CDataAttach *data = (CDataAttach *)GameItemDataManage.GetAttachData(new_item_no);
    CGameDataUsed *attachment = (CGameDataUsed *)this;

    if (data == NULL) {
        return 0;
    }
    if (new_item_no == item_no) {
        if (CheckTypeEnableStack() != 0) {
            AddNum(1, 1);
            return 1;
        }
    }
    used_type = 2;
    item_no = (short)new_item_no;
    item_type = GetItemDataType(new_item_no);

    attachment->data.attach.status[0] = data->status[0];
    attachment->data.attach.status[1] = data->status[1];
    attachment->data.attach.attribute[0] = data->attribute[0];
    attachment->data.attach.attribute[1] = data->attribute[1];
    attachment->data.attach.attribute[2] = data->attribute[2];
    attachment->data.attach.attribute[3] = data->attribute[3];
    attachment->data.attach.attribute[4] = data->attribute[4];
    attachment->data.attach.attribute[5] = data->attribute[5];
    attachment->data.attach.attribute[6] = data->attribute[6];
    attachment->data.attach.attribute[7] = data->attribute[7];
    attachment->data.attach.special = 0;
    attachment->data.attach.special |= data->special;
    attachment->data.attach.num = 1;
    return 1;
}
int CGameDataUsed::CopyDataItem(int item_no) {
    CDataCommon *record;
    short *stack;

    record = GetCommonItemData(item_no);
    if (record == NULL) {
        return 0;
    }
    stack = &this->data.item.num;
    if (this->item_no == item_no) {
        if (this->CheckStackRemain() > 0) {
            stack[0] = stack[0] + 1;
        }
        return 1;
    }
    this->item_type = record->type;
    this->used_type = ConvertUsedItemType(this->item_type);
    this->item_no = item_no;
    stack[0] = 1;
    stack[1] = 0;
    return 1;
}
int CGameDataUsed::CopyDataFish(int item_no) {
    CGameDataUsed *fish = (CGameDataUsed *)this;
    CDataBreedFish *record;
    char *message;
    float value;

    record = (CDataBreedFish *)GetBreedFishInfoData(item_no);
    if (record == NULL) {
        return 0;
    }
    this->used_type = 6;
    this->item_no = item_no;
    this->item_type = GetItemDataType(item_no);
    message = GetItemMessage(item_no);
    if (message != NULL) {
        strcpy(fish->data.fish.name, message);
    }
    value = record->size / 2.0f + GetRandF(30.0f);
    fish->data.fish.size = (u16)(value - GetRandF(10.0f));
    value = 400.0f + GetRandF(500.0f);
    fish->data.fish.weight = (u16)(value + GetRandF(500.0f));
    fish->data.fish.sex = GetRandI(2);
    fish->data.fish.unk_1c = GetRandI(4);
    fish->data.fish.unk_16 = GetRandI(4);
    fish->data.fish.hp = 100;
    fish->data.fish.fatigue = 0;
    fish->data.fish.param[4] = *(u16 *)&record->unk_6;
    fish->data.fish.param[0] = *(u16 *)&record->unk_a;
    fish->data.fish.param[1] = *(u16 *)&record->unk_c;
    fish->data.fish.param[2] = *(u16 *)&record->unk_e;
    fish->data.fish.param[3] = *(u16 *)&record->unk_8;
    fish->data.fish.unk_36 = GetRandI(0x33) + 0xC8;
    fish->data.fish.unk_35 = 0;
    fish->data.fish.timer = 0;
    fish->data.fish.flags = 0;
    fish->data.fish.unk_3c = GetRandI(0x100);
    fish->data.fish.unk_3d = 0;
    return 1;
}
int CGameDataUsed::CopyDataGiftBox(int item_no) {
    if (GetItemInfoData(item_no) == NULL) {
        return 0;
    }
    used_type = USED_ITEM_TYPE_GIFT_BOX;
    this->item_no = item_no;
    item_type = GetItemDataType(item_no);
    data.giftbox.item_no[2] = 0;
    data.giftbox.item_no[1] = 0;
    data.giftbox.item_no[0] = 0;
    return 1;
}
int CGameDataUsed::CopyDataItem(CGameDataUsed *other) {
    CDataCommon *record;
    int total;

    if (other == NULL) {
        return 0;
    }
    if (0 < this->item_no && this->item_no == other->item_no) {
        if (CheckTypeEnableStack() != 0) {
            record = GetCommonItemData(this->item_no);
            total = GetNum() + other->GetNum();
            if ((short)total > record->stack_num) {
                return 0;
            }
            AddNum(other->GetNum(), 1);
            other->Init();
            return 1;
        }
    }
    GameDataSwap(this, other, 0);
    return 1;
}
int CGameDataUsed::CopyDataRoboPart(int item_no) {
    CDataRoboPart *record;
    char *message;
    char *base;
    float energy;
    float hp;

    record = (CDataRoboPart *)GameItemDataManage.GetRoboData(item_no);
    if (record == NULL) {
        return 0;
    }
    this->used_type = 5;
    this->item_no = item_no;
    this->item_type = GetItemDataType(item_no);
    base = (char *)&this->data.robopart.gage0;
    energy = record->unk_6;
    this->data.robopart.gage1.max = energy;
    this->data.robopart.gage1.now = energy;
    hp = record->unk_2;
    this->data.robopart.gage0.max = hp;
    this->data.robopart.gage0.now = hp;
    this->data.robopart.defence = record->unk_1c;
    this->data.robopart.unk_26 = record->unk_4;
    this->data.robopart.status[0] = record->unk_8;
    this->data.robopart.status[1] = record->unk_a;
    this->data.robopart.status[2] = record->unk_c[0];
    this->data.robopart.status[3] = record->unk_c[1];
    this->data.robopart.status[4] = record->unk_c[2];
    this->data.robopart.status[5] = record->unk_c[3];
    this->data.robopart.status[6] = record->unk_c[4];
    this->data.robopart.status[7] = record->unk_c[5];
    this->data.robopart.status[8] = record->unk_c[6];
    this->data.robopart.status[9] = record->unk_c[7];
    message = GetItemMessage(item_no);
    if (message != NULL) {
        strcpy(base + 0x2C, message);
    }
    return 1;
}
void CFishAquarium::Initialize() {
    int i;
    unk_0 = 0;
    unk_2 = 0;
    for (i = 0; i < 6; i++) {
        ((CGameDataUsed *)&fish_tank[i])->Init();
    }
    for (i = 0; i < 4; i++) {
        ((CGameDataUsed *)&sub_tank[i])->Init();
    }
    for (i = 0; i < 2; i++) {
        ((CGameDataUsed *)&breed_tank[i])->Init();
    }
    unk_518 = 0;
    last_time = 0;
    last_day = 0;
    last_hour = 0;
}
CGameDataUsed *CFishAquarium::GetAquariumFishTop(int tank) {
    if (tank == 0) {
        return fish_tank;
    }
    if (tank == 1) {
        return sub_tank;
    }
    if (tank == 2) {
        return breed_tank;
    }
    return 0;
}
int CFishAquarium::SearchAqua1NotUsed(int tank) {
    CGameDataUsed *slot = GetAquariumFishTop(tank);
    if (slot == 0) {
        return -1;
    }
    for (int i = 0; i < aquarium_fish_maxtbl[tank]; i++, slot++) {
        if (slot->item_no <= 0) {
            return i;
        }
    }
    return -1;
}
void CFishAquarium::FishIntoAquarium(int tank, int slot, CGameDataUsed *fish) {
    CGameDataUsed *entry;
    if (tank < 0 || tank > 3) {
        return;
    }
    entry = 0;
    if (tank == 0) {
        if (slot >= 0 && slot < 6) {
            entry = &fish_tank[slot];
        }
    } else if (tank == 1) {
        if (slot >= 0 && slot < 4) {
            entry = &sub_tank[slot];
        }
    } else if (tank == 2) {
        if (slot >= 0 && slot < 2) {
            entry = &breed_tank[slot];
        }
    }
    if (entry == 0) {
        return;
    }
    ((CGameDataUsed *)entry)->CopyGameData(fish);
    if (tank == 1) {
        *(int *)((u8 *)entry + 0x50) = GetMainScene()->day;
        *(float *)((u8 *)entry + 0x54) = GetMainScene()->time;
    }
}
int CFishAquarium::GetAquariumFishNum(int tank) {
    int capacity = aquarium_fish_maxtbl[tank];
    CGameDataUsed *slot = GetAquariumFishTop(tank);
    if (slot == 0) {
        return 0;
    }
    int count = 0;
    int i = 0;

    if (0 < capacity) {
        do {
            if (0 < slot->item_no) {
                count++;
            }
            i++;
            slot++;
        } while (i < capacity);
    }
    return count;
}
int CFishAquarium::CheckHaigouTankSex(CGameDataUsed *fish) {
    int i = 0;
    int offset;
    if (fish == 0) {
        return 0;
    }

    offset = 0;
    for (; i < 2; i++, offset += sizeof(CGameDataUsed)) {
        CFishAquarium *shifted = (CFishAquarium *)((u8 *)this + offset);
        if (shifted->breed_tank[0].item_no > 0 &&
            *(s8 *)&shifted->breed_tank[0].data.fish.sex == *(s8 *)&fish->data.fish.sex) {
            return 0;
        }
    }
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/userdata", RefreshParam__13CFishAquariumFv);
int GetShiledKitLimmit(int item_no) {
    int index = item_no - 0xF6;
    if (index < 0) {
        index = 0;
    }
    if (index > 6) {
        index = 6;
    }
    return use_limmit_table_2558[index];
}
float ROBO_DATA::AddPoint(float amount) {
    hp.AddPoint(amount);
    return hp.GetRate();
}
int ROBO_DATA::GetDefenceVol(void) {
    return parts[1].data.robopart.defence + (shield_kit_num << 2);
}
BASE_MONSTER_TBL *GetMonsterBaseInfo(int monster_no) {
    return GetMonsterTable(monster_no);
}
MOS_HENGE_PARAM *GetMonsterHengeParam(int monster_no) {
    for (int i = 0; i < 57; i++) {
        if (mos_henge_param[i].monster_id == monster_no) {
            return &mos_henge_param[i];
        }
    }
    return 0;
}
int MOS_CHANGE_PARAM::GetAttackVol(int monster_no) {
    float scale;
    int value;
    if (monster_no < 0) {
        monster_no = this->monster_id;
    }
    scale = 1.0f + 2.0f * ((float)level / 98.0f);
    MOS_HENGE_PARAM *param = GetMonsterHengeParam(monster_no);
    value = 0;
    if (param != 0) {
        value = fptosi((float)param->attack * scale);
    }
    if (value > 999) {
        value = 999;
    }
    return value;
}
int MOS_CHANGE_PARAM::GetDefenceVol(int monster_no) {
    int value;
    if (monster_no < 0) {
        monster_no = this->monster_id;
    }
    MOS_HENGE_PARAM *param = GetMonsterHengeParam(monster_no);
    value = 0;
    if (param != 0) {
        value = fptosi((float)param->defence + (float)(GetDegreeLevel() * 2));
    }
    if (value > 999) {
        value = 999;
    }
    return value;
}
int MOS_CHANGE_PARAM::CheckClassChange(void) {
    if (class_level >= 3) {
        return 0;
    }
    return class_level < level / 25;
}
int MOS_CHANGE_PARAM::GetDegreeLevel(void) {
    int degree = level / 6;
    if (degree > 15) {
        degree = 15;
    }
    return degree;
}
int MOS_CHANGE_PARAM::LevelUp() {
    if (abs.CheckFill() != 0) {
        if (level < 98) {
            abs.now = 0;
            int bonus = 0;
            if (level > 49) {
                bonus = (level - 49) * 25;
            }
            abs.max = (float)(level * 100 + 100 + bonus);
            level = level + 1;
            return 1;
        }
    }
    return 0;
}
void CMonsterBox::Initialize() {
    memset(this, 0, sizeof(*this));
    for (int i = 0; i < 64; i++) {
        monster[i].no = i;
        monster[i].hp.max = 64.0f;
        monster[i].hp.now = 64.0f;
        monster[i].abs.max = 100.0f;
    }
}
MOS_CHANGE_PARAM *CMonsterBox::GetMonsterBajjiData(int monster_no) {
    if (monster_no <= 0 || monster_no >= 64) {
        return 0;
    }
    return &monster[monster_no - 1];
}
MOS_CHANGE_PARAM *CMonsterBox::GetMonsterBajjiDataByMonsterID(int monster_id) {
    return GetMonsterBajjiData(get_gajji_id_from_monster_progress_table(monster_id, 0) + 1);
}
void CMonsterBox::EnableChange(int monster_no) {
    int level[8];
    MOS_CHANGE_PARAM *record = GetMonsterBajjiData(monster_no);
    if (record != 0) {
        record->enable = 1;
        record->progress = get_default_monster_progresstbl(monster_no - 1);
        get_monster_tbl_bajjilevel(level, monster_no - 1, -1, 0);
        record->monster_id = level[0];
    }
}
int CMonsterBox::IsChange(int monster_no) {
    MOS_CHANGE_PARAM *record = GetMonsterBajjiData(monster_no);
    if (record != 0) {
        return (u8)record->enable;
    }
    return 0;
}
void CMonsterBox::AllCure() {
    for (int i = 0; i < 64; i++) {
        monster[i].hp.SetFillRate(1.0f);
    }
}
static int GetConvertIndexFromFishNo(int fish_no) {
    for (int index = 0; 0 < fish_record_dataindex_convert[index]; index++) {
        if (fish_no == fish_record_dataindex_convert[index]) {
            return index;
        }
    }
    return -1;
}
CFishingRecord::CFishingRecord() {
    memset(this, 0, sizeof(*this));
}
FISH_RECORD *CFishingRecord::GetFishRecord(int fish_no) {
    int index = GetConvertIndexFromFishNo(fish_no);
    if (index < 0) {
        return 0;
    }
    return &record[index];
}
int CFishingRecord::CheckRecordFish(int fish_no, float size, float weight) {
    FISH_RECORD *record = GetFishRecord(fish_no);
    int result;
    if (record == 0) {
        return 0;
    }
    result = 0;
    if (record->size < size) {
        record->prev_size = record->size;
        result |= 1;
        record->size = size;
    }
    if (record->weight < weight) {
        record->prev_weight = record->weight;
        result |= 2;
        record->weight = weight;
    }
    record->num = record->num + 1;
    if (record->num > 999999) {
        record->num = 999999;
    }
    return result;
}
void CFishingTournament::Initialize(void) {
    memset(this, 0, sizeof(*this));
}
void CFishingTournament::ResetRecord(void) {
    memset(entry, 0, sizeof(entry));
}
int CFishingTournament::EntryFish(int entrant, int fish, int weight) {
    for (int i = 0; i < 10; i++) {
        if (entry[i].item_no <= 0) {

            short *slot = (short *)((i << 3) + (int)this);
            slot[16] = entrant;
            slot[17] = fish;
            slot[18] = weight;
            break;
        }
    }
    return EntryRemain();
}
int CFishingTournament::EntryRemain() {
    int used = 0;
    int i = 0;
    int offset = 0;

    do {
        if (((CFishingTournament *)((u8 *)this + offset))->entry[0].item_no > 0) {
            used += 1;
        }
        i += 1;
        offset += sizeof(FISH_TOURNAMENT_ENTRY);
    } while (i < 10);
    return 10 - used;
}
FISH_TOURNAMENT_ENTRY *CFishingTournament::GetRecord(int index) {
    if (index < 0 || index >= 10) {
        return 0;
    }
    return &entry[index];
}
void CFishingTournament::SetRank(int rank) {
    if (rank < 0) {
        rank = 0;
    }
    if (rank > 100) {
        rank = 100;
    }
    this->rank = rank;
}
void CFishingTournament::SortRecord() {
    FISH_TOURNAMENT_ENTRY temp;
    int i = 0;
    do {
        int offset = i * 8;
        FISH_TOURNAMENT_ENTRY *slot = (FISH_TOURNAMENT_ENTRY *)((u8 *)this + offset + 0x20);
        if (slot->item_no > 0) {
            int j = i;
            if (j < 10) {
                do {
                    if (slot->weight < entry[j].weight) {
                        memcpy(&temp, slot, sizeof(FISH_TOURNAMENT_ENTRY));
                        memcpy(slot, &entry[j], sizeof(FISH_TOURNAMENT_ENTRY));
                        slot = &entry[j];
                        memcpy(slot, &temp, sizeof(FISH_TOURNAMENT_ENTRY));
                        i = -1;
                        break;
                    }
                    j++;
                    offset += 8;
                } while (j < 10);
            }
        }
        i++;
    } while (i < 10);
}
int CFishingTournament::CalcTopWeight(void) {
    this->SortRecord();
    return entry[2].weight + (entry[0].weight + entry[1].weight);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/userdata", Initialize__16CUserDataManagerFv);
void CUserDataManager::RefreshParam() {
    RefreshNPCStatus(0);
    int now = (int)GetSaveData()->play_time;
    int elapsed = (int)(now - last_refresh_time);
    for (int slot = 0; slot < 150; slot++) {
        used_data[slot].TimeCheck(elapsed);
    }
    unk_451d0 = unk_451d0 % 0x534;
    aquarium.RefreshParam();
    last_refresh_time = now;
}
CGameDataUsed *CUserDataManager::GetUsedDataPtr(int index) {
    if (index < 0 || index >= 150) {
        return 0;
    }
    return &used_data[index];
}
CHARA_DATA *CUserDataManager::GetCharaDataPtr(int chara_no) {
    if (chara_no == 0 || chara_no == 1) {
        return &chara_data[chara_no];
    }
    return 0;
}
COMMON_GAGE *CUserDataManager::GetCharaHpGage(int chara_no) {
    unsigned int id = chara_no;
    if (id <= 1 || id == 3) {
        if (id == 3) {
            id = 1;
        }
        return &chara_data[id].hp;
    }
    if (id == 2) {
        return &robo_data.hp;
    }
    return 0;
}
int CUserDataManager::AddHp(int chara_no, int amount) {
    COMMON_GAGE *gage = GetCharaHpGage(chara_no);
    if (gage != 0) {
        gage->AddPoint((float)amount);
        return fptosi(gage->now);
    }
    return 0;
}
float CUserDataManager::GetHp(int chara_no) {
    COMMON_GAGE *gage = GetCharaHpGage(chara_no);
    if (gage != 0) {
        return (float)fptosi(gage->now);
    }
    return 0.0f;
}
float CUserDataManager::AddHp_Rate(int chara_no, float rate) {
    COMMON_GAGE *gage = GetCharaHpGage(chara_no);
    if (gage == 0) {
        return 0.0f;
    }
    gage->AddRate(rate);
    if (gage->now < 1.0f) {
        gage->now = 1.0f;
    }
    return gage->GetRate();
}
COMMON_GAGE *CUserDataManager::GetWHpGage(int group, int member) {
    if (group == 2) {
        return &robo_data.parts[0].data.robopart.gage1;
    }
    if (group == 3) {
        MOS_CHANGE_PARAM *monster = monster_box.GetMonsterBajjiData(monster_id);
        if (monster != 0) {
            return &monster->hp;
        }
    }
    if (group == 0 || group == 1) {
        if (member < 0 || member >= 2) {
            return 0;
        }
        return &chara_data[group].equip[member].data.weapon.whp;
    }
    return 0;
}
COMMON_GAGE *CUserDataManager::GetAbsGage(int group, int member) {
    if (group == 2) {
        return &robo_data.abs;
    }
    if (group == 3) {
        MOS_CHANGE_PARAM *monster = monster_box.GetMonsterBajjiData(monster_id);
        if (monster != 0) {
            return &monster->abs;
        }
    }
    if (group == 0 || group == 1) {
        if (member < 0 || member >= 2) {
            return 0;
        }
        return &chara_data[group].equip[member].data.weapon.abs;
    }
    return 0;
}
int CUserDataManager::AddWhp(int group, int member, int amount) {
    COMMON_GAGE *gage = GetWHpGage(group, member);
    if (gage == 0) {
        return 0;
    }
    gage->AddPoint((float)amount);
    return fptosi(gage->now);
}
int CUserDataManager::GetWhp(int group, int member, int *max_out) {
    COMMON_GAGE *gage = GetWHpGage(group, member);
    if (gage == 0) {
        return 0;
    }
    if (max_out != 0) {
        *max_out = fptosi(gage->max);
    }
    return fptosi(gage->now);
}
int CUserDataManager::AddAbs(int group, int member, int amount) {
    if (group == 2) {
        AddRoboAbs((float)amount);
        return fptosi(GetRoboAbs());
    }
    COMMON_GAGE *gage = GetAbsGage(group, member);
    if (gage == 0) {
        return 0;
    }
    gage->AddPoint((float)amount);
    return fptosi(gage->now);
}
int CUserDataManager::GetAbs(int group, int member, int *max_out) {
    if (group == 2) {
        if (max_out != 0) {
            *max_out = 0;
        }
        return fptosi(GetRoboAbs());
    }
    COMMON_GAGE *gage = GetAbsGage(group, member);
    if (gage == 0) {
        return 0;
    }
    if (max_out != 0) {
        *max_out = fptosi(gage->max);
    }
    return fptosi(gage->now);
}
void CUserDataManager::JoinPartyMember(int chara_no) {
    if (chara_no < 0 || chara_no > 3) {
        return;
    }
    party_member |= (1 << chara_no) & 0xFFFF;
}
void CUserDataManager::LeavePartyMember(int chara_no) {
    if (chara_no < 0 || chara_no > 3) {
        return;
    }
    party_member &= ~(1 << chara_no) & 0xFFFF;
}
int CUserDataManager::GetNowPartyMember() {
    int mask = party_member;
    int result = mask;
    if (SearchItemOnItemBrd(0x134, 0) != 0) {
        result = mask | 8;
    }
    return result;
}
void CUserDataManager::EnableCharaChange(int chara_no) {
    if (chara_no < 0 || chara_no > 3) {
        return;
    }
    chara_change |= (1 << chara_no) & 0xFFFF;
}
void CUserDataManager::DisableCharaChange(int chara_no) {
    if (chara_no < 0 || chara_no > 3) {
        return;
    }
    chara_change &= ~(1 << chara_no) & 0xFFFF;
}
int CUserDataManager::CheckEnableCharaChange(int chara_no, int *out) {
    int allowed;
    int flag = GetEnableCharaChangeFlag();
    allowed = 0;
    if (flag & (1 << chara_no)) {
        allowed = 1;
    }
    int alive = 1;
    int able = 1;
    if (chara_no == 0 || chara_no == 1) {
        if (chara_data[chara_no].hp.now <= 0.0f) {
            alive = 0;
        }
        int status = GetCharaStatusAttirbute(chara_no);
        if ((status & 8) != 0 || (status & 0x20) != 0) {
            able = 0;
        }
    }
    if (chara_no == 2) {
        if (robo_data.hp.now <= 0.0f || chara_data[0].hp.now <= 0.0f) {
            alive = 0;
        }
    }
    int forbidden;
    if (chara_no == 3) {
        if (chara_data[1].hp.now <= 0.0f) {
            alive = 0;
        }
    }
    forbidden = 0;
    DNG_BATTLE_AREA *scene = &GetMainScene()->battle_area;
    if (scene != 0) {
        u16 flags = scene->floor_status;
        if (flags & 1) {
            forbidden = 1;
        }
        if (flags & 2) {
            forbidden = 1;
        }
    }
    int result;
    if (out != 0) {
        *out = 0;
        if (alive != 0) {
            *out |= 1;
        }
        if (forbidden != 0) {
            *out |= 2;
        }
        if (able != 0) {
            *out |= 4;
        }
    }
    result = allowed != 0;
    if (result != 0) {
        result = alive != 0;
    }
    if (result != 0) {
        result = able != 0;
    }
    return result & 0xFF;
}
int CUserDataManager::CheckQuickChange(int chara_no, int *out) {
    int state = 0;
    int party_chara = GetNowPartyMember();
    if (party_chara & (1 << chara_no)) {
        state |= 1;
    }
    int enabled = CheckEnableCharaChange(chara_no, out);
    int can_change = 0;
    if (enabled != 0) {
        state |= 2;
        can_change = 1;
    }
    if (chara_no == 3) {
        CGameDataUsed *badge_item = SearchItemOnItemBrd(0x134, 0);
        state = 0;
        int changeable;
        int i;
        CMonsterBox *box;
        box = &monster_box;
        changeable = 0;
        i = 0;
        int former_monster = monster_id;
        int offset = 0;
        do {
            if (box->IsChange(i + 1) != 0) {
                changeable++;
                if (monster_id < 0) {
                    monster_id = ((MOS_CHANGE_PARAM *)((u8 *)box + offset))->monster_id;
                }
            }
            i++;
            offset += sizeof(MOS_CHANGE_PARAM);
        } while (i < 10);
        if (badge_item != 0 && 0 < changeable) {
            state |= 1;
            if (enabled != 0) {
                state |= 2;
                if (can_change == 0) {
                    state &= ~2;
                }
            }
            MOS_CHANGE_PARAM *badge = box->GetMonsterBajjiDataByMonsterID(former_monster);
            if (badge != 0 && badge->hp.GetRate() <= 0.0f) {
                state &= ~2;
            }
        }
    }
    int status = GetCharaStatusAttirbute(active_chr_no);
    if ((status & 8) != 0 || (status & 0x20) != 0) {
        state &= ~2;
    }
    return state;
}
void CUserDataManager::EnableCharaChangeMask(int chara_no) {
    chara_change_mask |= (1 << chara_no) & 0xFF;
}
void CUserDataManager::DisableCharaChangeMask(int chara_no) {
    chara_change_mask &= ~(1 << chara_no) & 0xFF;
}
void CUserDataManager::InitCharaChangeMask() {
    chara_change_mask = 15;
}
u32 CUserDataManager::GetEnableCharaChangeFlag() {
    int party_chara = GetNowPartyMember();
    int mask = chara_change & chara_change_mask;
    CharaBitTable bits = at_3192;
    for (int chara_no = 0; chara_no < 4; chara_no++) {
        if ((party_chara & bits.bit[chara_no]) == 0) {
            mask &= ~(1 << chara_no);
        }
    }
    DNG_BATTLE_AREA *scene = &GetMainScene()->battle_area;
    if (scene != 0) {
        u16 flags = scene->floor_status;
        if (flags & 1) {
            mask &= ~5;
        }
        if (flags & 2) {
            mask &= ~0xA;
        }
    }
    return mask;
}
u16 *CUserDataManager::GetCharaStatusAttirbutePtr(int chara_no) {
    u16 *attr;
    if (chara_no < 0 || chara_no > 3) {
        return 0;
    }
    attr = 0;
    if (chara_no < 2) {
        attr = &chara_data[chara_no].status_attr;
    }
    if (chara_no == 2) {
        attr = 0;
    }
    if (chara_no == 3) {
        attr = 0;
    }
    return attr;
}
int CUserDataManager::SetCharaStatusAttirbute(int chara_no, unsigned int attr, int mode) {
    u16 *word = GetCharaStatusAttirbutePtr(chara_no);
    if (word == 0) {
        return 0;
    }
    if (chara_no == 2) {
        return 0;
    }
    if (mode == 1) {
        *word &= ~attr;
    } else {
        if (*word & 0x10) {
            attr &= ~3;
        }
        if (attr & 0x10) {
            attr &= ~3;
            *word &= 0xFFFE;
            *word &= 0xFFFD;
        }
        *word = *word | attr;
    }
    return *word;
}
int CUserDataManager::SetCharaStatusAttirbuteVol(int chara_no, unsigned int attr, int value) {
    int result = SetCharaStatusAttirbute(chara_no, attr, 0);
    if (chara_no == 0 || chara_no == 1) {
        u8 *chara = (u8 *)&chara_data[1];
        if (chara_no == 0) {
            chara = (u8 *)&chara_data[0];
        }
        if (attr & 0x10) {
            *(short *)(chara + 0xC) = value;
        }
        if (attr & 0x2) {
            *(short *)(chara + 0xE) = value;
        }
        if (attr & 0x8) {
            *(short *)(chara + 0x10) = value;
        }
        if (attr & 0x20) {
            *(short *)(chara + 0x12) = value;
        }
    }
    if (chara_no == 2) {
        u8 *robot = (u8 *)&robo_data;
        if (attr & 0x2) {
            *(short *)(robot + 0x1E0) = value;
        }
        if (attr & 0x8) {
            *(short *)(robot + 0x1E2) = value;
        }
        if (attr & 0x20) {
            *(short *)(robot + 0x1E4) = value;
        }
    }
    if (chara_no == 3) {
        u8 *badge = (u8 *)GetMonsterBajjiDataPtrMosId(monster_id);
        if (badge != 0) {
            if (attr & 0x10) {
                *(short *)(badge + 0x3E) = value;
            }
            if (attr & 0x1) {
                *(short *)(badge + 0x3C) = value;
            }
        }
    }
    return result;
}
int CUserDataManager::GetCharaStatusAttirbute(int chara_no) {
    u16 *attr = GetCharaStatusAttirbutePtr(chara_no);
    if (attr != 0) {
        return *attr;
    }
    return 0;
}
MOS_CHANGE_PARAM *CUserDataManager::GetMonsterBajjiDataPtr(int monster_no) {
    return monster_box.GetMonsterBajjiData(monster_no);
}
MOS_CHANGE_PARAM *CUserDataManager::GetMonsterBajjiDataPtrMosId(int monster_id) {
    return monster_box.GetMonsterBajjiDataByMonsterID(monster_id);
}
int CUserDataManager::GetItemBoardOverNum() {
    if (GetSaveData()->GetBitFlag(254) != 0) {
        return 6;
    }
    return 12;
}
int CUserDataManager::GetItemBoardMaxNum(int board) {
    int size = 0;
    if (board == 0) {
        size = 0x8A;
    }
    if (GetSaveData()->GetBitFlag(254) == 1) {
        if (board == 0) {
            size = 0x90;
        }
    }
    int result = size;
    if (board == 1) {
        result = 150;
    }
    return result;
}
void CUserDataManager::SetActiveChrNo(int chara_no) {
    active_chr_no = chara_no;
    CBattleCharaInfo *info = GetBattleCharaInfo();
    if (info != 0) {
        info->SetChrNo(chara_no);
    }
}
void CUserDataManager::SetRoboName(char *name) {
    if (name != 0) {
        strcpy(robo_data.name, name);
    }
}
char *CUserDataManager::GetRoboName() {
    return robo_data.name;
}
char *CUserDataManager::GetRoboNameDefault() {
    return robo_nametable_3330[LanguageCode];
}
void CUserDataManager::SetVoiceUnit(int fitted) {
    robo_data.voice_unit = fitted;
    if (fitted != 0) {
        this->SetRoboVoiceFlag(1);
    }
}
s8 CUserDataManager::CheckVoiceUnit() {
    return robo_data.voice_unit;
}
void CUserDataManager::SetRoboVoiceFlag(int flag) {
    robo_data.voice_flag = flag;
}
int CUserDataManager::CheckRoboVoiceFlag(void) {
    int enabled = robo_data.voice_unit != 0;
    if (enabled != 0) {
        enabled = robo_data.voice_flag != 0;
    }
    return enabled & 0xFF;
}
float CUserDataManager::AddRoboAbs(float amount) {
    float value = (float)(robo_data.abs.now + amount);
    robo_data.abs.now = value;
    if (value < 0.0f) {
        robo_data.abs.now = 0.0f;
    }
    if (99999.0f < robo_data.abs.now) {
        robo_data.abs.now = 99999.0f;
    }
    return robo_data.abs.now;
}
float CUserDataManager::GetRoboAbs() {
    return robo_data.abs.now;
}
int CUserDataManager::CheckCapacity() {
    int i = 0;
    int offset = 0;

    for (; i < 150; i++, offset += sizeof(CGameDataUsed)) {
        CGameDataUsed *item = (CGameDataUsed *)((u8 *)used_data + offset);
        if (item->item_type == 11) {
            CDataItem *info = GetItemInfoData(item->item_no);
            if (info != 0) {
                return info->value[0];
            }
        }
    }
    return 0;
}
short CUserDataManager::CheckRobotCore() {
    for (int i = 0; i < 150; i++) {
        if (used_data[i].item_type == 11) {
            return used_data[i].item_no;
        }
    }
    return -1;
}
int CUserDataManager::GetDefenceVol(int chara_no) {
    if (chara_no == 0 || chara_no == 1) {
        CHARA_DATA *chara = &chara_data[chara_no];
        if (chara == 0) {
            return 0;
        }
        return *(u16 *)&chara->defence;
    }
    if (chara_no == 2) {
        return robo_data.GetDefenceVol();
    }
    if (chara_no == 3) {
        CHARA_DATA *monster = &chara_data[1];
        if (monster != 0) {
            return *(u16 *)&monster->defence;
        }
    }
    return 0;
}
void CUserDataManager::JoinPartyChara(int chara_no, int status, int unused) {
    if (chara_no <= 0 || chara_no > 32) {
        return;
    }
    PARTY_CHARA_INFO *slot = &party_chara[chara_no - 1];
    slot->status = status;
    slot->chara_no = chara_no;
    NPC_BASE_DATA *npc = GetPartyNPCData(chara_no);
    if (npc != 0) {
        slot->point = npc->max_npc_point;
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/userdata", SetPartyCharaStatus__16CUserDataManagerFii);
int CUserDataManager::GetPartyCharaStatus(int chara_no) {
    int index = chara_no - 1;
    if (index < 0 || index >= 32) {
        return 0;
    }
    return party_chara[index].status;
}
int CUserDataManager::NowPartyCharaID() {
    for (int i = 0; i < 32; i++) {
        if (party_chara[i].status & 1) {
            return i + 1;
        }
    }
    return -1;
}
void CUserDataManager::LeaveHouse(int chara_no) {
    int was_in_party = GetPartyCharaStatus(chara_no) & 1;

    int flag = 0;
    if (was_in_party) {
        flag = 1;
    }
    SetPartyCharaStatus(chara_no, 2);
    if (flag) {
        SetPartyCharaStatus(chara_no, 1);
    }
}
PARTY_CHARA_INFO *CUserDataManager::GetPartyCharaInfo(int chara_no) {
    if (chara_no <= 0 || chara_no > 32) {
        return 0;
    }
    return &party_chara[chara_no - 1];
}
int CUserDataManager::UseNpcAbility(int npc_no, int ability_no, int consume) {
    int usable = 0;
    PARTY_CHARA_INFO *member = GetPartyCharaInfo(npc_no);
    u8 *npc_data = (u8 *)GetPartyNPCData(npc_no);
    if (member == 0 || npc_data == 0) {
        return 0;
    }
    short gauge = member->point;
    u8 cost = npc_data[ability_no + 0x32];
    if (cost <= gauge) {
        usable = 1;
        if (consume != 0) {
            member->point = gauge - (cost & 0xFF);
            if (member->point < 0) {
                member->point = 0;
            }
        }
    }
    return usable;
}
void CUserDataManager::AllWeaponRepair() {
    int i = 0;
    int offset = 0;

    for (; i < 150; i++, offset += sizeof(CGameDataUsed)) {
        CGameDataUsed *item = (CGameDataUsed *)((u8 *)used_data + offset);
        if (item->used_type == 5) {
            item->Repair(999);
        }
    }
    robo_data.parts[0].Repair(999);
    robo_data.AddPoint(999.0f);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/userdata", RefreshNPCStatus__16CUserDataManagerFi);
int CUserDataManager::GetFishingRodNo() {
    return chara_data[0].equip[0].item_no;
}
int CUserDataManager::NowFishingStyle(void) {
    CGameDataUsed *rod = &chara_data[0].equip[0];
    if (rod != NULL) {
        return rod->IsFishingRod();
    }
    return 0;
}
CGameDataUsed *CUserDataManager::GetActiveEsa() {
    return GetActiveEsa(GetFishingRodNo());
}
CGameDataUsed *CUserDataManager::GetActiveEsa(int rod_no) {
    if (rod_no == 302) {
        return &esa[0];
    }
    if (rod_no == 303) {
        return &esa[1];
    }
    return 0;
}
int CUserDataManager::GetFishBait() {
    int rod = GetFishingRodNo();
    if (rod == 302) {
        return esa[0].item_no;
    }
    if (rod == 303) {
        return esa[1].item_no;
    }
    return 0;
}
void CUserDataManager::DeleteBait() {
    CGameDataUsed *bait = GetActiveEsa();

    GetFishingRodNo();
    if (bait != 0) {
        bait->DeleteNum(1);
    }
}
int CUserDataManager::GetFishInAquarium(int fish_no, float size, float weight) {
    CGameDataUsed fish;
    int i;

    CopyGameData(&fish, fish_no);
    fish.data.fish.size = fptosi(1000.0f * size);
    fish.data.fish.weight = fptoui(weight);
    fish.data.fish.unk_1c = GetRandI(3) + 1;
    fish.data.fish.hp = 100;
    fish.data.fish.param[4] += GetRandI(4);
    fish.data.fish.param[3] += GetRandI(4);
    fish.data.fish.param[0] += GetRandI(3);
    fish.data.fish.param[1] += GetRandI(3);
    fish.data.fish.param[2] += GetRandI(3);
    fish.data.fish.unk_36 = GetRandI(0x33) + 200;
    fish.data.fish.unk_35 = 0;
    CGameDataUsed *slot = SearchSpaceUsedDataPtr();
    if (slot != 0) {
        slot->CopyGameData(&fish);
        return 0;
    }
    if (GetNumSameItem(0x135) != 0) {
        if (FishInAquarium(&fish, 0) != 0) {
            return 0;
        }
    }
    i = 0;
    if (0 < GetItemBoardOverNum()) {
        do {
            CGameDataUsed *overflow = &used_data[i + GetItemBoardMaxNum(0)];
            if (overflow->item_no <= 0) {
                overflow->CopyGameData(&fish);
                return 1;
            }
            i++;
        } while (i < GetItemBoardOverNum());
    }
    return 2;
}
int CUserDataManager::CheckFishRecordUpdate(int fish_no, float size, float weight) {
    CFishingRecord *log = &fish_record;
    if (log != 0) {
        return log->CheckRecordFish(fish_no, size, weight);
    }
    return 0;
}
void CUserDataManager::GetFishRecord(int fish_no, float *size_out, float *weight_out) {
    CFishingRecord *log = &fish_record;
    if (log != 0) {
        FISH_RECORD *record = log->GetFishRecord(fish_no);
        if (record != 0) {
            if (size_out != 0) {
                *size_out = record->size;
            }
            if (weight_out != 0) {
                *weight_out = record->weight;
            }
        }
    }
}
void CUserDataManager::GetRodStatus(int *out) {
    if (out != 0 && GetFishingRodNo() > 0) {
        out[0] = chara_data[0].equip[0].data.weapon.attribute[0];
        out[1] = chara_data[0].equip[0].data.weapon.attribute[1];
        out[2] = chara_data[0].equip[0].data.weapon.attribute[2];
        out[3] = chara_data[0].equip[0].data.weapon.attribute[3];
        out[4] = chara_data[0].equip[0].data.weapon.attribute[4];
    }
}
int CUserDataManager::AddFp(int points) {
    if (GetFishingRodNo() <= 0) {
        return 0;
    }
    return chara_data[0].equip[0].AddFusionPoint(points);
}
extern "C" int GetDataType__9CGameDataFi(void *, int);
int CUserDataManager::SetChrEquip(int chara_no, CGameDataUsed *item) {
    int slot;
    if (item == 0) {
        return 0;
    }
    CGameData *game_data = GetGameDataPt();
    short item_no = item->item_no;
    int item_type = GetDataType__9CGameDataFi(game_data, item_no);
    CBattleCharaInfo *battle = GetBattleCharaInfo();
    if (chara_no == 0 || chara_no == 1) {
        CHARA_DATA *chara = GetCharaDataPtr(chara_no);
        int owner = IsItemtypeWhoisEquip(item_no, &slot);
        if (owner == chara_no && 0 <= slot) {
            GameDataSwap(item, &chara->equip[slot], 0);
            if (battle != 0) {
                battle->RefreshParamater();
            }
            return 1;
        }
    }
    if (chara_no == 2) {
        ROBO_DATA *ridepod = &robo_data;
        for (int part = 0; part < 4; part++) {
            if (item_type == SearchEquipType(2, part)) {
                GameDataSwap(&((ROBO_DATA *)((u8 *)ridepod + part * sizeof(CGameDataUsed)))->parts[0],
                             item, 0);
                if (battle != 0) {
                    battle->RefreshParamater();
                }
                return 1;
            }
        }
    }
    return 0;
}
int CUserDataManager::SetChrEquip(int chara, int item_no) {
    CGameDataUsed *item;

    if (item_no <= 0) {
        return 0;
    }
    if ((chara < 0) || (chara > 2)) {
        return 0;
    }
    if (this->SearchEquip(chara, item_no) != 0) {
        return 0;
    }
    item = this->SearchItemOnItemBrd(item_no, 1);
    if (item == NULL) {
        return 0;
    }
    this->SetChrEquip(chara, item);
    return 1;
}
int CUserDataManager::SetChrEquipDirect(int chara_no, int item_no) {


    if (item_no <= 0) {
        return 0;
    }
    if (chara_no < 0 || chara_no > 2) {
        return 0;
    }
    if (SearchEquip(chara_no, item_no) != 0) {
        return 0;
    }

    CGameDataUsed item;
    CopyGameData(&item, item_no);
    SetChrEquip(chara_no, &item);
    return 1;
}
CGameDataUsed *CUserDataManager::SearchEquip(int chara_no, int item_no) {
    CGameDataUsed *found = 0;
    int i;
    int offset;
    int equip_offset;
    CHARA_DATA *entry;
    CHARA_DATA *equip_entry;
    ROBO_DATA *robot;
    int part_offset;
    ROBO_DATA *part_entry;
    int k;
    if (chara_no == 0 || chara_no == 1) {
        int j;
        CHARA_DATA *chara = GetCharaDataPtr(chara_no);
        i = 0;
        offset = 0;
        do {
            entry = (CHARA_DATA *)((u8 *)chara + offset);
            if (item_no == entry->active_item[0].item_no) {
                found = &entry->active_item[0];
            }
            i++;
            offset += sizeof(CGameDataUsed);
        } while (i < 3);
        j = 0;
        equip_offset = 0;
        do {
            equip_entry = (CHARA_DATA *)((u8 *)chara + equip_offset);
            if (item_no == equip_entry->equip[0].item_no) {
                found = &equip_entry->equip[0];
            }
            j++;
            equip_offset += sizeof(CGameDataUsed);
        } while (j < 5);
    }
    if (chara_no == 2) {
        robot = &robo_data;
        k = 0;
        part_offset = 0;
        do {
            part_entry = (ROBO_DATA *)((u8 *)robot + part_offset);
            if (item_no == part_entry->parts[0].item_no) {
                found = &part_entry->parts[0];
            }
            k++;
            part_offset += sizeof(CGameDataUsed);
        } while (k < 3);
    }
    return found;
}
char *CUserDataManager::GetCharaEquipDataPath(int chara_no, int slot) {
    if (chara_no < 0 || chara_no > 2) {
        return 0;
    }
    if (chara_no < 2) {
        if (slot < 0 || slot > 4) {
            return 0;
        }
        return chara_data[chara_no].equip[slot].GetDataPath();
    }
    if (slot < 0 || slot > 3) {
        return 0;
    }
    return robo_data.parts[slot].GetDataPath();
}
int CUserDataManager::AddFusionPoint(int group, int member, int points) {
    if (group == 0 || group == 1) {
        if (member == 0 || member == 1) {
            return chara_data[group].equip[member].AddFusionPoint(points);
        }
    }
    return 0;
}
int CUserDataManager::SearchSpaceUsedData() {
    int bag_size = GetNowBagMax(0);
    for (int i = 0; i < bag_size; i++) {
        if (used_data[i].item_no <= 0) {
            return i;
        }
    }
    return -1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/userdata", SearchSpaceUsedData__16CUserDataManagerFi);
CGameDataUsed *CUserDataManager::SearchSpaceUsedDataPtr() {
    int index = SearchSpaceUsedData();
    if (index < 0) {
        return 0;
    }
    return &used_data[index];
}
CGameDataUsed *CUserDataManager::SearchSpaceUsedDataPtr(int item_no) {
    int index = SearchSpaceUsedData(item_no);
    if (index < 0) {
        return 0;
    }
    return &used_data[index];
}
int CUserDataManager::SearchActiveItemTableSpace(int chara_no, int item_no) {
    CHARA_DATA *chara = GetCharaDataPtr(chara_no);
    int i = 0;
    if (chara == 0) {
        return -1;
    }

    int offset = 0;
    for (; i < 3; i++) {
        CGameDataUsed *item = &((CHARA_DATA *)((u8 *)chara + offset))->active_item[0];
        if (item->item_no == item_no && item->CheckStackRemain() > 0) {
            return i;
        }
        offset += sizeof(CGameDataUsed);
    }
    int j = 0;
    offset = 0;
    for (; j < 3; j++) {
        if (((CHARA_DATA *)((u8 *)chara + offset))->active_item[0].item_no <= 0) {
            return j;
        }
        offset += sizeof(CGameDataUsed);
    }
    return -1;
}
CGameDataUsed *CUserDataManager::SearchItemOnItemBrd(int item_no, int use_alt_bag) {
    CGameDataUsed *item = GetUsedDataPtr(0);
    int limit = GetNowBagMax(0);
    if (use_alt_bag != 0) {
        limit = GetNowBagMax(1);
    }
    for (int i = 0; i < limit; i++, item++) {
        if (item_no == item->item_no) {
            return item;
        }
    }
    return 0;
}
int CUserDataManager::GetNumStackOverBoard(void) {
    int count = 0;
    CGameDataUsed *item = GetUsedDataPtr(GetNowBagMax(0));
    for (int index = 0; index < GetItemBoardOverNum(); index++, item++) {
        if (item->item_no > 1) {
            count += 1;
        }
    }
    return count;
}
CGameDataUsed *CUserDataManager::SearchAllHaveItem(int item_no) {
    CGameDataUsed *found = SearchItemOnItemBrd(item_no, 1);
    if (found == 0) {
        for (int chara_no = 0; chara_no < 2; chara_no++) {
            CHARA_DATA *chara = &chara_data[chara_no];
            for (int slot = 0; slot < 3; slot++) {
                if (item_no == chara->active_item[slot].item_no) {
                    found = &chara->active_item[slot];
                    break;
                }
            }
        }
    }
    return found;
}
int CUserDataManager::FishInAquarium(CGameDataUsed *fish, int tank) {
    CFishAquarium *aquarium = &this->aquarium;
    if ((tank < 0) || (tank > 2)) {
        return 0;
    }
    int space = aquarium->SearchAqua1NotUsed(0);
    if ((space < 0) || (fish == NULL)) {
        return 0;
    }
    aquarium->FishIntoAquarium(tank, space, fish);
    fish->Init();
    return 1;
}
int CUserDataManager::CheckElectricFish() {
    CFishAquarium *tanks = &aquarium;
    if (tanks == 0) {
        return 0;
    }
    CGameDataUsed *fish = tanks->GetAquariumFishTop(0);
    for (int i = 0; i < 6; i++) {
        if (fish[i].item_no > 0 && (fish[i].data.fish.flags & 2)) {
            return 1;
        }
    }
    return 0;
}
int CUserDataManager::GetNumSameItem(int item_no) {
    int i;
    int equip_offset;
    int bag_size;
    int j;
    int total;
    int slot;
    int bag_offset;
    int chara_offset;
    int offset;
    CHARA_DATA *entry;
    int chara;
    CGameDataUsed *item;
    CHARA_DATA *data;
    int part_offset;
    int part;
    total = 0;
    bag_size = GetNowBagMax(1);
    i = 0;
    if (0 < bag_size) {
        bag_offset = 0;
        do {
            item = (CGameDataUsed *)((u8 *)this + bag_offset);
            if (item_no == item->item_no) {
                total += item->GetNum();
            }
            total += item->GetGiftBoxSameItemNum(item_no);
            i++;
            bag_offset += sizeof(CGameDataUsed);
        } while (i < bag_size);
    }
    chara = 0;
    chara_offset = 0;
    do {
        data = (CHARA_DATA *)((u8 *)this + chara_offset + 0x3F48);
        j = 0;
        offset = 0;
        do {
            entry = (CHARA_DATA *)((u8 *)data + offset);
            if (item_no == entry->active_item[0].item_no) {
                total += entry->active_item[0].GetNum();
            }
            total += entry->active_item[0].GetGiftBoxSameItemNum(item_no);
            j++;
            offset += sizeof(CGameDataUsed);
        } while (j < 3);
        slot = 0;
        equip_offset = 0;
        do {
            if (item_no == ((CHARA_DATA *)((u8 *)data + equip_offset))->equip[0].item_no) {
                total += 1;
            }
            slot++;
            equip_offset += sizeof(CGameDataUsed);
        } while (slot < 5);
        chara++;
        chara_offset += sizeof(CHARA_DATA);
    } while (chara < 2);
    part = 0;
    part_offset = 0;
    do {
        if (item_no == ((CGameDataUsed *)((u8 *)this + part_offset + 0x4690))->item_no) {
            total += 1;
        }
        part++;
        part_offset += sizeof(CGameDataUsed);
    } while (part < 4);
    return total;
}
short CUserDataManager::AddYarikomiMedal(int amount) {
    short *count = &yarikomi_medal;
    *count = *count + amount;
    if (yarikomi_medal < 0) {
        yarikomi_medal = 0;
    }
    if (yarikomi_medal > 999) {
        yarikomi_medal = 999;
    }
    return yarikomi_medal;
}
int CUserDataManager::GetYarikomiMedal() {
    return yarikomi_medal;
}
int CUserDataManager::GetItem(int item_no, int count) {
    int limit;
    int fit;
    int over;
    CDataCommon *common;
    fit = GetItemNotOver(item_no, count);
    over = count - fit;
    common = GetCommonItemData(item_no);
    if (common != NULL && (common->attribute & 0x40)) {
        limit = common->max_num;
        if (limit <= GetNumSameItem(item_no)) {
            return 1;
        }
    }
    if (over > 0) {
        GetOverItem(item_no, over);
    }
    return fit;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/userdata", GetItemNotOver__16CUserDataManagerFii);
int CUserDataManager::GetOverItem(int item_no, int count) {
    if (item_no <= 0 || count <= 0) {
        return 0;
    }
    CDataCommon *common = GetCommonItemData(item_no);
    if (common == 0) {
        return 0;
    }
    ConvertUsedItemType(common->type);
    int overflow_start = GetNowBagMax(0);
    int overflow_size = GetItemBoardOverNum();
    CGameDataUsed *target;
    int placed = 0;
    if (0 < count) {
        target = 0;
        do {
            for (int i = 0; i < overflow_size && target == 0; i++) {
                int slot_item;
                CGameDataUsed *slot;
                slot = &used_data[overflow_start + i];
                slot_item = slot->item_no;
                if (slot_item == item_no && slot->CheckTypeEnableStack() != 0 &&
                    0 < slot->CheckStackRemain()) {
                    target = slot;
                }
                if (slot_item <= 0 && target == 0) {
                    target = slot;
                }
            }
            if (target != 0) {
                CopyGameData(target, item_no);
                GetCostume(item_no);
                placed++;
                target = 0;
                if (placed < count) {
                    continue;
                }
            }
            break;
        } while (1);
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/userdata", CheckItemLimmitOver__16CUserDataManagerFv);
int DeleteItem_Local(CGameDataUsed *item, int item_no, int count) {
    int removed;
    if (item_no <= 0) {
        return 0;
    }
    removed = 0;
    if (item_no == item->item_no) {
        removed += item->DeleteNum(count);
    } else if (item->used_type == 7) {
        for (int index = 0; index < 3; index++) {
            if (0 < count && item_no == item->GetGiftBoxItemNo(index)) {
                item->SetGiftBoxItem(0, index);
                removed++;
                count--;
            }
        }
    }
    return removed;
}
int CUserDataManager::DeleteItem(int item_no, int count) {
    CGameDataUsed *bag = GetUsedDataPtr(0);
    for (int slot = 149; slot >= 0; slot--) {
        int removed = DeleteItem_Local(&bag[slot], item_no, count);
        if (0 < removed) {
            count -= removed;
        }
        if (!(0 < count)) {
            break;
        }
    }
    for (int chara_no = 0; chara_no < 2; chara_no++) {
        for (int slot = 0; slot < 3; slot++) {
            int removed = DeleteItem_Local(&chara_data[chara_no].active_item[slot], item_no, count);
            if (0 < removed) {
                count -= removed;
            }
            if (!(0 < count)) {
                break;
            }
        }
    }
    return 1;
}
int CUserDataManager::CopyGameData(CGameDataUsed *item, int item_no) {
    unsigned int used_type;
    CDataCommon *common;

    if (item == 0) {
        return 0;
    }
    common = GetCommonItemData(item_no);
    if (common == 0) {
        return 0;
    }
    used_type = ConvertUsedItemType(common->type);
    switch (used_type) {
        case 1:
        case 4:
            item->CopyDataItem(item_no);
            break;
        case 2:
            item->CopyDataAttach(item_no);
            break;
        case 3:
            item->CopyDataWeapon(item_no);
            break;
        case 5:
            item->CopyDataRoboPart(item_no);
            break;
        case 7:
            item->CopyDataGiftBox(item_no);
            break;
        case 6:
            item->CopyDataFish(item_no);
            break;
    }
    return 1;
}
int CUserDataManager::AddMoney(int amount) {
    int *total = &money;
    *total = *total + amount;
    if (money < 0) {
        money = 0;
    }
    if (999999 < money) {
        money = 999999;
    }
    return money;
}
void CUserDataManager::SetCostumeBit(unsigned long bits) {
    costume_bit = bits;
}
unsigned long CUserDataManager::GetCostumeBit() {
    return costume_bit;
}
void CUserDataManager::GetCostume(int costume_no) {
    COSBIT_INFO *info = GetCosInfo(costume_no);
    if (info != 0) {
        costume_bit |= (s64)1 << info->bit_no;
    }
}
int CUserDataManager::CountFish() {
    int count = 0;
    CGameDataUsed *item = used_data;
    for (int i = 0; i < 150; i++, item++) {
        if (item->used_type == 6) {
            count++;
        }
    }
    CFishAquarium *tanks = &aquarium;
    for (int i = 0; i < 6; i++) {
        if (0 < tanks->fish_tank[i].item_no) {
            count++;
        }
    }
    return count;
}
void SetEnvUserDataMan(int env) {
    CUserDataManager *manager = GetUserDataMan();
    if (env == 0) {
        manager->InitCharaChangeMask();
        manager->DisableCharaChange(2);
        manager->DisableCharaChange(3);
    }
    if (env == 1) {
        manager->InitCharaChangeMask();
        manager->EnableCharaChange(2);
        manager->EnableCharaChange(3);
    }
}
void GetCharaDefaultWeapon(int chara_no, int *weapons) {
    int language = LanguageCode;
    if (language > 1) {
        language = 1;
    }
    int base = chara_no * 5;
    short *table = weptbl_4503[language];
    for (int i = 0; i < 5; i++) {
        weapons[i] = table[base + i];
    }
    weapons[5] = -1;
}
void LanguageEquipChange(void) {
    CUserDataManager *manager = GetUserDataMan();
    int weapons[6];
    if (manager != 0) {
        for (int chara_no = 0; chara_no < 2; chara_no++) {
            GetCharaDefaultWeapon(chara_no, weapons);
            for (int slot = 0; slot < 5; slot++) {
                manager->SetChrEquipDirect(chara_no, weapons[slot]);
            }
        }
        manager->SetRoboName(manager->GetRoboNameDefault());
    }
}
void CheckEquipChange(int chara_no) {
    int weapons[6];
    if (chara_no == 1) {
        CHARA_DATA *chara = GetUserDataMan()->GetCharaDataPtr(1);
        if (chara != 0) {
            GetCharaDefaultWeapon(1, weapons);
            GetUserDataMan()->SetChrEquipDirect(1, weapons[0]);
            if (*(s8 *)&chara->unk_2b == 0) {
                GetUserDataMan()->SetChrEquipDirect(1, weapons[2]);
                GetUserDataMan()->SetChrEquipDirect(1, weapons[3]);
                GetUserDataMan()->SetChrEquipDirect(1, weapons[4]);
            }
            chara->unk_2b = 0;
        }
    }
}
void CBattleCharaInfo::Initialize(void) {
    memset(this, 0, 0x90);
    chr_no = 0;
    chara_type = -1;
    chara_data = 0;
    chara_data = 0;
    hp = 0;
    equip = 0;
    hp_change_step = 0;
    unk_80 = -1.0f;
    disp_hp = -1.0f;
}
CGameDataUsed *CBattleCharaInfo::GetEquipTablePtr(int slot) {
    if (slot < 0 || slot > 3) {
        return 0;
    }
    return &equip[slot];
}
void CBattleCharaInfo::SetChrNo(int new_chara_no) {
    CUserDataManager *manager = GetUserDataMan();
    if (chr_no != new_chara_no) {
        ClearMagicSwordPow();
    }
    chr_no = new_chara_no;
    unk_2 = 0;
    if (0 <= chr_no && chr_no < 2) {
        chara_type = 0;
        chara_data = manager->GetCharaDataPtr(chr_no);
        active_item = ((CHARA_DATA *)chara_data)->active_item;
        equip = (CGameDataUsed *)((CHARA_DATA *)chara_data)->equip;
        hp = &((CHARA_DATA *)chara_data)->hp;
        disp_hp = hp->now;
        unk_80 = hp->max;
        prev_hp = hp->now;
        unk_88 = hp->max;
    } else if (chr_no == 2) {
        chara_type = 1;
        chara_data = &manager->robo_data;
        active_item = 0;
        equip = (CGameDataUsed *)&((ROBO_DATA *)chara_data)->parts[0];
        hp = &((ROBO_DATA *)chara_data)->hp;
        disp_hp = hp->now;
        unk_80 = hp->max;
        prev_hp = hp->now;
        unk_88 = hp->max;
    } else if (chr_no == 3) {
        chara_type = 2;
        int monster_id = GetMonsterID();
        chara_data = manager->GetMonsterBajjiDataPtrMosId(monster_id);
        int base = 0;
        BASE_MONSTER_TBL *info = GetMonsterBaseInfo(monster_id);
        if (info != 0) {
            base = info->user_mons_id;
        }
        unk_2 = base;
        active_item = 0;
        equip = 0;
        hp = &manager->GetCharaDataPtr(1)->hp;
        disp_hp = hp->now;
        unk_80 = hp->max;
        prev_hp = hp->now;
        unk_88 = hp->max;
    }
    poison_count = 0;
    BattleParamater_Time = 0;
    BattleParamater_TimeBand = 0;
    RefreshParamater();
}
int CBattleCharaInfo::GetMonsterID(void) {
    CUserDataManager *manager = GetUserDataMan();
    if (manager != 0) {
        return manager->monster_id;
    }
    return 0;
}
int CBattleCharaInfo::GetNowNPC(void) {
    return now_npc;
}
int CBattleCharaInfo::UseNPCPoint(int unused) {
    int npc_no = now_npc;
    if (npc_no <= 0) {
        return 0;
    }
    if (GetUserDataMan()->GetPartyCharaInfo(npc_no) == 0) {
        return 0;
    }
    if (GetPartyNPCData(now_npc) == 0) {
        return 0;
    }
    if (now_npc == 10) {
        if (GetMainScene()->battle_area.floor_status & 4) {
        return 0;
    }
        if (1.0f <= hp->GetRate()) {
            return 0;
        }
        if (GetUserDataMan()->UseNpcAbility(10, 3, 1) != 0) {
            hp->AddRate(0.05f);
    return 1;
        }
    }
        return 0;
}
CGameDataUsed *CBattleCharaInfo::GetActiveItemInfo(int index) {
    CGameDataUsed *table = active_item;
    CGameDataUsed *item = 0;
    if (table != 0) {
        item = &table[index];
    }
    return item;
}
int CBattleCharaInfo::UseActiveItem(CGameDataUsed *item) {

    int target[2];
    int item_no;

    if (item == 0) {
        return 0;
    }
    item_no = item->item_no;
    target[0] = -1;
    ((CItemUseTarget *)target)->SetPtr(0, chara_data);
    if (item_no == 294) {
        ((CItemUseTarget *)target)->SetPtr(1, GetEquipTablePtr(0));
    }
    if (item_no == 298 || item_no == 352) {
        ((CItemUseTarget *)target)->SetPtr(1, GetEquipTablePtr(1));
    }
    return MenuUseItemCheckFunc(item, (CItemUseTarget *)target, 1);
}
u32 CBattleCharaInfo::GetSpecialStatus(int slot) {
    if (chara_type == 0) {
        if (slot == 0 || slot == 1) {

            int offset = ((slot << 3) - slot) << 2;
            int *entry = (int *)(offset + (int)this);
            return entry[0x12];
        }
    }
    return 0;
}
short CBattleCharaInfo::GetPalletNo(int slot) {
    if (chara_type == 0) {
        if (slot == 0 || slot == 1) {

            int offset = ((slot << 3) - slot) << 2;
            short *entry = (short *)(offset + (int)this);
            return entry[0x26];
        }
    }
    return -1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/userdata", RefreshParamater__16CBattleCharaInfoFv);
COMMON_GAGE *CBattleCharaInfo::GetNowAccessWHp(int slot) {
    COMMON_GAGE *gage = 0;
    short current_mode = chara_type;
    if (current_mode == 0) {
        u8 *table = (u8 *)equip;
        if (table == 0) {
            return gage;
        }
        gage = (COMMON_GAGE *)(table + slot * sizeof(CGameDataUsed) + 0x10);
    } else if (current_mode == 1) {
        gage = (COMMON_GAGE *)((u8 *)equip + 0x10) + 1;
    } else if (current_mode == 2) {
        gage = &((MOS_CHANGE_PARAM *)chara_data)->hp;
    }
    return gage;
}
COMMON_GAGE *CBattleCharaInfo::GetNowAccessAbs(int slot) {
    COMMON_GAGE *gage = 0;
    short current_mode = chara_type;
    if (current_mode == 0) {
        u8 *table = (u8 *)equip;
        if (table == 0) {
            return gage;
        }
        gage = (COMMON_GAGE *)(table + slot * sizeof(CGameDataUsed) + 0x10) + 1;
    } else if (current_mode == 1) {
        gage = &((ROBO_DATA *)chara_data)->abs;
    } else if (current_mode == 2) {
        gage = &((MOS_CHANGE_PARAM *)chara_data)->abs;
    }
    return gage;
}
float CBattleCharaInfo::AddWhp(int slot, float amount) {
    COMMON_GAGE *gage = GetNowAccessWHp(slot);
    if (gage == 0) {
        return 0.0f;
    }
    gage->AddPoint(amount);
    if (gage->max != 0.0f) {
        return gage->GetRate();
    }
    return 0.0f;
}
void CBattleCharaInfo::GetNowWhp(int slot, int *out) {
    COMMON_GAGE *gage = GetNowAccessWHp(slot);
    if (gage != 0) {
        out[0] = GetDispVolumeForFloat(gage->now);
        out[1] = fptosi(gage->max);
    }
}
int CBattleCharaInfo::GetWhpNowVol(int slot) {
    COMMON_GAGE *gage = GetNowAccessWHp(slot);
    if (gage != 0) {
        return GetDispVolumeForFloat(gage->now);
    }
    return 0;
}
void CBattleCharaInfo::SetMagicSwordPow(int elem, int power) {
    if (magic_sword_elem != elem) {
        ClearMagicSwordPow();
    }
    if (elem < 0 || elem > 3) {
        return;
    }
    if (chr_no != 1) {
        return;
    }
    int counter_max = GetMagicSwordCounterMax();
    if (magic_sword_num < counter_max && power > 0) {
        magic_sword_elem = elem;
        magic_sword_pow[magic_sword_num] = power;
        magic_sword_num = magic_sword_num + 1;
    }
}
int CBattleCharaInfo::GetMagicSwordElem(void) {
    short element = -1;
    if (!(chr_no == USER_CHARA_MONICA)) {
        return element;
    }
    element = magic_sword_elem;
    return element;
}
int CBattleCharaInfo::GetMagicSwordPow(void) {
    int total = 0;
    for (int i = 0; i < magic_sword_num; i++) {
        total += magic_sword_pow[i];
    }
    if (chr_no == 1) {
        return total;
    }
    return 0;
}
int CBattleCharaInfo::GetMagicSwordCounterNow(void) {
    if (chr_no != USER_CHARA_MONICA) {
        return 0;
    }
    return magic_sword_num;
}
int CBattleCharaInfo::GetMagicSwordCounterMax(void) {
    CGameDataUsed *weapon = equip;
    if (weapon == NULL) {
        return 0;
    }
    if (chr_no != USER_CHARA_MONICA) {
        return 0;
    }
    if (weapon == NULL) {
        return 0;
    }
    short power = weapon->data.weapon.status[1];
    if (power < 32) {
        return 0;
    }
    int max_charges = (power - 32) / 16 + 3;
    if (max_charges > 7) {
        max_charges = 7;
    }
    return max_charges;
}
void CBattleCharaInfo::ClearMagicSwordPow(void) {
    magic_sword_elem = -1;
    magic_sword_num = 0;
    for (int i = 0; i < 7; i++) {
        magic_sword_pow[i] = 0;
    }
}
float CBattleCharaInfo::AddAbs(int slot, float amount, int *leveled_up) {
    float rate;
    COMMON_GAGE *gage = GetNowAccessAbs(slot);
    if (gage == 0) {
        return 0.0f;
    }
    if (chara_type == 1) {
        rate = 0.0f;
        gage->now += amount;
        GetUserDataMan()->AddRoboAbs(amount);
    } else if (chara_type == 2) {
        ((MOS_CHANGE_PARAM *)chara_data)->abs.AddPoint(amount);
        MOS_CHANGE_PARAM *badge = (MOS_CHANGE_PARAM *)chara_data;
        if (badge != 0) {
            int leveled = badge->LevelUp();
            if (leveled_up != 0 && leveled != 0) {
                *leveled_up = 1;
            }
        }
    } else {
        CGameDataUsed *item = (CGameDataUsed *)equip;
        if (item == 0) {
            return 0.0f;
        }
        if (chr_no == 0 && slot == 0 && item->IsFishingRod() != 0) {
            return 0.0f;
        }
        gage->AddPoint(amount);
        rate = 0.0f;
        if (gage->max != 0.0f) {
            rate = gage->GetRate();
            int leveled =
                LevelUpWeapon(&equip[slot]);
            if (leveled_up != 0 && leveled != 0) {
                *leveled_up = 1;
            }
        }
    }
    return rate;
}
int CBattleCharaInfo::AddAbsRate(int slot, float rate, int *leveled_up) {
    if (equip == 0) {
        return 0;
    }
    COMMON_GAGE *gage = GetNowAccessAbs(slot);
    if (gage == 0 || chara_type == 1) {
        return 0;
    }
    gage->now += gage->max * rate;
    if (gage->now < 1.0f) {
        gage->now = 0.0f;
    }
    if (gage->max <= gage->now) {
        gage->now = gage->max;
    }
    int leveled = LevelUpWeapon(&equip[slot]);
    if (leveled_up != 0 && leveled != 0) {
        *leveled_up = 1;
    }
    return leveled;
}
void CBattleCharaInfo::GetNowAbs(int slot, int *out) {
    COMMON_GAGE *gage = GetNowAccessAbs(slot);
    if (gage != 0) {
        out[0] = GetDispVolumeForFloat(gage->now);
        out[1] = fptosi(gage->max);
    }
}
int CBattleCharaInfo::LevelUpWeapon(CGameDataUsed *weapon) {
    if (chara_type == 0) {
        if (weapon->IsLevelUp() == 0) {
            return 0;
        }
        weapon->LevelUp();
        RefreshParamater();
        return 1;
    }
    return 0;
}
short CBattleCharaInfo::GetDefenceVol(void) {
    return defence;
}
float CBattleCharaInfo::AddHp_Point(float point, float frames) {
    if (hp == 0) {
        return 0.0f;
    }
    hp_change_frames = frames;
    if (frames <= 1.0f) {
        hp_change_step = point;
    } else {
        hp_change_step = point / frames;
    }
    prev_hp = hp->now;
    float now = hp->now;
    disp_hp = now;
    hp->now = now + point;
    if (hp->now <= 0.0f) {
        hp->now = 0.0f;
    }
    if (hp->max <= hp->now) {
        hp->now = hp->max;
    }
    if (hp->max == 0.0f) {
        return 0.0f;
    }
    return hp->now / hp->max;
}
float CBattleCharaInfo::AddHp_Rate(float rate, int kind, float frames) {
    if (hp == 0) {
        return 0.0f;
    }
    hp_change_frames = frames;
    prev_hp = hp->now;
    disp_hp = hp->now;
    switch (kind) {
        case 0:
        case 2:
            hp->now += hp->max * rate;
            if (kind == 2) {
                if (hp->now <= 1.0f) {
                    hp->now = 1.0f;
                }
            }
            break;
        case 1:
        case 3: {
            float now = hp->now;
            hp->now = now + now * rate;
            if (kind == 3) {
                if (hp->now < 1.0f) {
                    hp->now = 1.0f;
                }
            }
            break;
        }
    }
    hp->now = (float)GetDispVolumeForFloat(hp->now);
    if (hp->now < 0.0f) {
        hp->now = 0.0f;
    }
    if (hp->max < hp->now) {
        hp->now = hp->max;
    }
    float diff = hp->now - prev_hp;
    if (hp_change_frames <= 1.0f) {
        hp_change_step = diff;
    } else {
        hp_change_step = diff / hp_change_frames;
    }
    return hp->GetRate();
}
void CBattleCharaInfo::SetHpRate(float rate) {
    COMMON_GAGE *gage = hp;
    if (gage != 0) {
        gage->SetFillRate(rate);
    }
}
int CBattleCharaInfo::GetMaxHp_i(void) {
    COMMON_GAGE *gage = hp;
    if (gage != 0) {
        return fptosi(gage->max);
    }
    return 0;
}
int CBattleCharaInfo::GetNowHp_i(void) {
    COMMON_GAGE *gage = hp;
    if (gage != 0) {
        return GetDispVolumeForFloat(gage->now);
    }
    return 0;
}
int CBattleCharaInfo::SetAttr(int attr, int value) {
    CUserDataManager *manager = GetUserDataMan();
    int result = 0;
    if (manager != 0) {
        manager->SetCharaStatusAttirbute(chr_no, attr, value);
        result = manager->GetCharaStatusAttirbute(chr_no);
    }
    return result;
}
int CBattleCharaInfo::SetAttrVol(int attr, int value) {
    CUserDataManager *manager = GetUserDataMan();
    int result = 0;
    if (manager != 0) {
        manager->SetCharaStatusAttirbuteVol(chr_no, attr, value);
        result = manager->GetCharaStatusAttirbute(chr_no);
    }
    return result;
}
int CBattleCharaInfo::GetAttr(void) {
    CUserDataManager *manager = GetUserDataMan();
    if (manager != 0) {
        return manager->GetCharaStatusAttirbute(chr_no);
    }
    return 0;
}
void CBattleCharaInfo::ForceSet(void) {
    COMMON_GAGE *gage = hp;
    if (gage != 0) {
        float point = gage->now;
        if (disp_hp != point) {
            disp_hp = point;
            prev_hp = -1.0f;
            hp_change_step = 0;
        }
    }
}
int GetRandomCircleTrapID(int kind) {
    int roll;
    int chara_no = GetBattleCharaInfo()->chr_no;
    roll = rand();
    int trap;
    srand(roll);
    trap = 0;
    if (kind == 0) {
        trap = tbl1_5167[roll % 3];
    }
    if (kind == 1) {
        trap = tbl2_5168[roll % 2];
        if (trap == 7) {
            trap = (GetRandI(11) + GetRandI(21)) % 2 + 8;
            if (chara_no == 1) {
                trap += 2;
            }
        }
    }
    if (chara_no == 2) {
        trap = -2;
    }
    if (chara_no == 3 && trap != 4 && trap != 12) {
        trap = -1;
    }
    return trap;
}
int SetRandamCircleStatus(int kind, float &amountOut) {
    if (kind <= 0) {
        return 0;
    }
    CBattleCharaInfo *battle = GetBattleCharaInfo();
    int applied;
    if (kind == 3) {
        CUserDataManager *manager = GetUserDataMan();
        if (manager != 0) {
            CHARA_DATA *max = manager->GetCharaDataPtr(0);
            max->equip[0].Repair(999);
            max->equip[1].Repair(999);
            CHARA_DATA *monica = manager->GetCharaDataPtr(1);
            monica->equip[0].Repair(999);
            monica->equip[1].Repair(999);
            return 1;
        }
    }
    applied = 0;
    if (kind == 1) {
        amountOut = 0.1f * battle->GetNowAccessAbs(0)->max + 0.1f * battle->GetNowAccessAbs(1)->max;
    }
    if (kind == 2) {
        battle->AddHp_Rate(1.0f, 0, 0.0f);
        battle->SetAttr(0x6F, 1);
        applied = 1;
    }
    if (kind == 5) {
        battle->SetAttr(1, 0);
        applied = 1;
    }
    if (kind == 6) {
        float rate = float(-0.5);
        battle->AddHp_Rate(rate, 3, 0.0f);
        applied = 1;
    }
    if (kind == 9 || kind == 0xB) {
        COMMON_GAGE *gage = battle->GetNowAccessWHp(0);
        applied = 1;
        gage->now *= 0.5f;
    }
    if (kind == 8 || kind == 0xA) {
        COMMON_GAGE *gage = battle->GetNowAccessWHp(1);
        gage->now *= 0.5f;
        applied = 1;
    }
    return applied;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/userdata", StatusParamStep__16CBattleCharaInfoFPi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/userdata", Step__16CBattleCharaInfoFv);
CBattleCharaInfo *GetBattleCharaInfo(void) {
    return &BattleParamater;
}
void ConvertItemAttrToCharaAttr(int attr, int *add, int *cure) {
    int add_attr = 0;
    int cure_attr = 0;
    if (attr & 0x10000) {
        add_attr |= CHARA_STATUS_POISON;
    }
    if (attr & 0x100000) {
        add_attr |= CHARA_STATUS_UNK_2;
    }
    if (attr & 0x40000) {
        add_attr |= CHARA_STATUS_UNK_4;
    }
    if (attr & 0x4000) {
        add_attr |= CHARA_STATUS_UNK_8;
    }
    if (attr & 0x400000) {
        add_attr |= CHARA_STATUS_POWER;
    }
    if (attr & 0x02000000) {
        add_attr |= CHARA_STATUS_UNK_20;
    }
    if (attr & 0x08000000) {
        add_attr |= CHARA_STATUS_UNK_40;
    }
    if (attr & 0x20000) {
        cure_attr |= CHARA_STATUS_POISON;
    }
    if (attr & 0x200000) {
        cure_attr |= CHARA_STATUS_UNK_2;
    }
    if (attr & 0x80000) {
        cure_attr |= CHARA_STATUS_UNK_4;
    }
    if (attr & 0x8000) {
        cure_attr |= CHARA_STATUS_UNK_8;
    }
    if (attr & 0x04000000) {
        cure_attr |= CHARA_STATUS_UNK_20;
    }
    if (attr & 0x10000000) {
        cure_attr |= CHARA_STATUS_UNK_40;
    }
    if (add != NULL) {
        *add = add_attr;
    }
    if (cure != NULL) {
        *cure = cure_attr;
    }
}
int CheckBadStatus(int attr) {
    if ((attr & CHARA_STATUS_POISON) || (attr & CHARA_STATUS_UNK_2) ||
        (attr & CHARA_STATUS_UNK_4) || (attr & CHARA_STATUS_UNK_8) ||
        (attr & CHARA_STATUS_UNK_20) || (attr & CHARA_STATUS_UNK_40)) {
        return 1;
    }
    return 0;
}
unsigned int CheckWeaponAttribute(unsigned int mask_a, unsigned int mask_b) {
    int bit = 0;
    int byte_offset = 0;
    do {
        unsigned int pair = *(unsigned int *)((u8 *)at_table_5400 + byte_offset);
        unsigned int mask = 1 << bit;
        if (pair != 0 && (mask_a & mask) && (mask_b & pair)) {
            mask_a &= ~mask;
            mask_b &= ~pair;
        }
        bit++;
        byte_offset += 4;
    } while (bit < 12);
    mask_a |= mask_b;
    return mask_a;
}
int CheckBuildUpMonsterCondition(CDataWeapon *weapon) {
    int ok;
    int i;
    if (weapon == NULL) {
        return 1;
    }
    if (GetSaveData() == NULL) {
        return 1;
    }
    ok = 1;
    for (i = 0; i < 3; i++) {
        short monster = weapon->buildup_monster[i];
        if (0 <= monster && KillMonsterCount(monster, 0) <= 0) {
            ok = 0;
        }
    }
    return ok;
}
int KillMonsterCount(int monster, int amount) {
    CSaveData *save = GetSaveData();
    CMonsterBook *book;
    if (save == NULL) {
        return 0;
    }
    book = (CMonsterBook *)&save->monster_book;
    if (book != NULL) {
        return book->CountKill(monster, amount);
    }
    return 0;
}
#pragma global_optimizer off
int SearchEquipType(int category, int slot) {
    if (category < 0 || category > 2) {
        return 0;
    }
    if (category < 0 || category >= 3 || slot < 0 || slot >= 5) {
        return 0;
    }
    return *(slot + (equip_type_tbl_5456 + category * 5));
}
#pragma global_optimizer reset
extern "C" int GetItemDataType__Fi(int);
int IsItemtypeWhoisEquip(int item_no, int *out_slot) {
    int type = GetItemDataType__Fi(item_no);
    int category = -1;
    int found_slot = -1;
    int c;
    int s;
    for (c = 0; c <= 2; c++) {
        for (s = 0; s < 5; s++) {
            if (type == SearchEquipType(c, s)) {
                found_slot = s;
                category = c;
                break;
            }
        }
    }
    if (out_slot != NULL) {
        *out_slot = found_slot;
    }
    return category;
}
int IsCheckParty(int chara_no) {
    int party = GetUserDataMan()->GetNowPartyMember();
    return (party & (1 << chara_no)) != 0;
}
char *GetAquariumFish0(int slot) {
    CFishAquarium *aquarium = GetAquariumData();
    u8 *entry;
    int offset;
    if (aquarium == NULL) {
        return 0;
    }
    if (slot < 0 || slot >= 6) {
        return 0;
    }

    offset = slot * sizeof(CGameDataUsed);
    entry = (u8 *)(offset + (int)aquarium);
    if (0 < *(short *)(entry + 6)) {
        return ((CGameDataUsed *)(entry + 4))->GetName(1);
    }
    return 0;
}
int GetUserItemHaveNum(int item_no) {
    CUserDataManager *user_data;

    user_data = GetUserDataMan();
    if (user_data != NULL) {
        return user_data->GetNumSameItem(item_no);
    }
    return 0;
}
int CheckItemOver(void) {
    CUserDataManager *user_data = GetUserDataMan();
    int count;
    int slot;
    int end;
    if (user_data == NULL) {
        return 0;
    }
    count = 0;
    slot = GetNowBagMax(0);
    end = GetNowBagMax(1);
    for (; slot < end; slot++) {
        if (user_data->used_data[slot].item_no > 0) {
            count++;
        }
    }
    return count;
}
int CheckItemLimmitOver(void) {
    CUserDataManager *user_data;

    user_data = GetUserDataMan();
    if (user_data != NULL) {
        return user_data->CheckItemLimmitOver();
    }
    return 0;
}
int CheckGetItemLimmitOver(int item_no, int count) {
    CUserDataManager *user_data;
    u8 *info;
    int held;
    int limit;
    int take;
    int bag_max;
    int bag_room;
    int i;
    int off;
    CGameDataUsed *entry;

    user_data = GetUserDataMan();
    if (user_data == NULL) {
        return 0;
    }
    held = user_data->GetNumSameItem(item_no);
    info = (u8 *)GetCommonItemData(item_no);
    limit = *(u16 *)(info + 0xA) - held;
    take = count;
    if (limit < count) {
        take = limit;
    }
    if (item_no == 0x132 || item_no == 0x131) {
        return count;
    }
    int type = ConvertUsedItemType(info[0]);
    if (type == 1 || (type == 2 && item_no != 0xB9 && item_no != 0x17F)) {
        bag_max = GetNowBagMax(0);
        bag_room = 0;
        i = 0;
        if (0 < bag_max) {
            off = 0;
            do {
                entry = (CGameDataUsed *)((u8 *)user_data + off);
                if (entry->item_no <= 0) {
                    bag_room += *(short *)(info + 0x1E);
                } else if (item_no == entry->item_no) {
                    bag_room += entry->CheckStackRemain();
                }
                i++;
                off += sizeof(CGameDataUsed);
            } while (i < bag_max);
        }
        if (*(u16 *)(info + 0xA) < bag_room) {
            bag_room = *(u16 *)(info + 0xA);
        }
        if (bag_room < take) {
            take = bag_room;
        }
        held = user_data->GetNumSameItem(item_no);
        if (*(u16 *)(info + 0xA) < take + held) {
            take = 0;
        }
    } else if (user_data->SearchSpaceUsedData() < 0) {
        take = 0;
    }
    return take;
}
int CheckGetItemRemainNum(int item_no) {
    CUserDataManager *manager = GetUserDataMan();
    int held;
    if (manager == NULL) {
        return 0;
    }
    held = manager->GetNumSameItem(item_no);
    return *(u16 *)((u8 *)GetCommonItemData(item_no) + 0xA) - held;
}
void CheckItemDngKey(void) {
    CUserDataManager *user_data = GetUserDataMan();
    CGameDataUsed *item;
    int bag_max;
    int i;
    if (user_data != NULL) {
        item = user_data->GetUsedDataPtr(0);
        bag_max = GetNowBagMax(1);
        for (i = 0; i < bag_max; i++, item++) {
            if (item->item_type == 0x1A) {
                item->Init();
            }
        }
        if (user_data->GetHp(0) < 1.0f) {
            user_data->chara_data[0].hp.now = 1.0f;
        }
        if (user_data->GetHp(1) < 1.0f) {
            user_data->chara_data[1].hp.now = 1.0f;
        }
        user_data->SetCharaStatusAttirbute(0, 1, 1);
        user_data->SetCharaStatusAttirbute(1, 1, 1);
    }
}
void PlayerPartyCure(void) {
    CUserDataManager *user_data = GetUserDataMan();
    CMonsterBox *monster_box;
    if (user_data != NULL) {
        user_data->chara_data[0].hp.SetFillRate(1.0f);
        user_data->chara_data[1].hp.SetFillRate(1.0f);
        user_data->SetCharaStatusAttirbute(0, 0x7F, 1);
        user_data->SetCharaStatusAttirbute(1, 0x7F, 1);
        monster_box = &user_data->monster_box;
        if (monster_box != NULL) {
            monster_box->AllCure();
        }
    }
}
void UserDataRefresh(void) {
    CUserDataManager *user_data;

    user_data = GetUserDataMan();
    if (user_data != NULL) {
        user_data->RefreshParam();
    }
}
void DeleteErekiFish(void) {
    CFishAquarium *aquarium;
    CGameDataUsed *fish;
    int i;
    int off;
    CGameDataUsed *entry;

    aquarium = GetAquariumData();
    if (aquarium == NULL) {
        return;
    }
    fish = aquarium->GetAquariumFishTop(0);

    i = 0;
    off = 0;
    do {
        entry = (CGameDataUsed *)((u8 *)fish + off);
        if ((entry->item_no > 0) && (entry->data.fish.flags & 2)) {
            ((CGameDataUsed *)(fish + i))->Init();
            return;
        }
        i += 1;
        off += sizeof(CGameDataUsed);
    } while (i < 6);
}
int GetNowBagMax(int board) {
    return GetUserDataMan()->GetItemBoardMaxNum(board);
}
void LeaveMonicaItemCheck(void) {

    CUserDataManager *user_data;
    int num;
    int i;
    int item_no;
    CGameDataUsed *bag_item;
    CGameDataUsed *free_slot;
    int off;
    CGameDataUsed *active;
    CHARA_DATA *monica;

    user_data = GetUserDataMan();
    if (user_data != NULL) {
        monica = user_data->GetCharaDataPtr(1);
        i = 0;
        if (monica != 0) {
            off = 0;
            do {

                item_no = ((CGameDataUsed *)((u8 *)monica + off + 0x2C))->item_no;
                active = (CGameDataUsed *)((u8 *)monica + off + 0x2C);
                num = active->GetNum();
                if ((item_no > 0) && (num > 0)) {
                    bag_item = user_data->SearchItemOnItemBrd(item_no, 0);
                    free_slot = user_data->SearchSpaceUsedDataPtr();
                    if (bag_item != NULL) {
                        if (bag_item->CheckTypeEnableStack() == 0) {
                            if (free_slot != NULL) {
                                free_slot->CopyGameData(active);
                                active->Init();
                            }
                        } else {
                            bag_item->AddNum(num, 1);
                            active->Init();
                        }
                    } else if (free_slot != NULL) {
                        free_slot->CopyGameData(active);
                        active->Init();
                    }
                }
                i += 1;
                off += sizeof(CGameDataUsed);
            } while (i < 3);
        }
    }
}
void AquaFishFatigueClear(void) {
    CUserDataManager *user_data;
    CGameDataUsed *fish;
    int tank;
    int i;
    CGameDataUsed *tank_fish;
    int slot;
    CFishAquarium *aquarium;

    user_data = GetUserDataMan();
    if (user_data == NULL) {
        return;
    }
    fish = (CGameDataUsed *)user_data->GetUsedDataPtr(0);
    for (i = 0; i < 150; i++, fish++) {
        if (fish->item_no > 0 && fish->used_type == 6) {
            fish->data.fish.fatigue = 0;
            fish->data.fish.unk_3d = 0;
        }
    }
    aquarium = &user_data->aquarium;
    if (aquarium == NULL) {
        return;
    }
    tank = 0;
    do {
        tank_fish = (CGameDataUsed *)aquarium->GetAquariumFishTop(tank);
        if (tank_fish != NULL) {
            for (slot = 0; slot < aquarium_fish_maxtbl[tank]; tank_fish++, slot++) {
                if (tank_fish->used_type == 6) {
                    tank_fish->data.fish.fatigue = 0;
                    tank_fish->data.fish.unk_3d = 0;
                }
            }
        }
        tank++;
    } while (tank < 3);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/userdata", DebugGetItem__FP16CUserDataManageri);

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/userdata", __sinit_userdata_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", mos_henge_param__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", basefish_1288__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", symbol_tbl_1338__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", magic_str_1462__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", strtbl_1505__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", htbl_1662__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", fish_record_dataindex_convert__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_3192__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", robo_nametable_3330__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_4196__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", weptbl_4503__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_table_5400__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", equip_type_tbl_5456__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", cureItemtable_5744__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", itemtbl_5745__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", start_tbl_5746__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", e3_town_5747__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", e3_dng_5748__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", e3_boss_5749__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", init_partytbl_5752__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", dbg_set2_5775__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", dbg_set3_5776__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", subgame1_5788__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_896__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_897__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_898__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_899__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_900__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_901__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_902__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_903__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_904__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_905__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_906__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_907__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_908__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_909__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_910__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_911__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_912__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_913__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_914__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_915__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_916__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_917__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_918__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_919__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_920__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_921__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_922__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_923__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_924__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_925__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_926__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_927__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_928__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_929__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_930__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_931__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_932__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_933__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_934__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_935__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_936__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_937__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_938__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_939__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_940__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_941__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1289__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1290__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1291__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1292__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1293__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1294__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1295__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1339__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1340__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1341__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1342__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1343__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1344__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1378__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1379__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1463__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1464__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1465__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1466__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1467__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1468__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1469__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1470__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1506__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1507__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1623__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1624__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_1637__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_2006__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_2007__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_2018__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_2019__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_3331__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_3332__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_3333__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_3334__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_4442__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", D_0037B004__DATA);

// Small initialised data (.sdata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", f_2005__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", aquarium_fish_maxtbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", use_limmit_table_2558__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", lifetbl_2854__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", at_4695__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", tbl1_5167__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", tbl2_5168__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/userdata", dbg_set1_5774__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(FishGamePreEquip, 0x4);
INCLUDE_BSS(BattleParamater_Time, 0x4);
INCLUDE_BSS(BattleParamater_TimeBand, 0x4);
INCLUDE_BSS(at_5773, 0x8);

// Uninitialised data (.bss)
INCLUDE_BSS(word_1327, 0x70);
INCLUDE_BSS(temp_1510, 0x40);
INCLUDE_BSS(at_2061, 0x20);
INCLUDE_BSS(BattleParamater, 0x90);
