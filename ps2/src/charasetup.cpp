#include "common.h"
#include "mainloop.hpp"
#include "mapselect.hpp"
#include "mglib.hpp"
#include "dataread.hpp"
#include "swordeffect.hpp"
#include "snd_mngr.hpp"
#include "dng_event.hpp"
#include "effscript.hpp"
#include "colprim.hpp"
#include "mg_math.hpp"
#include "mg_camera.hpp"
#include "sceneload.hpp"
#include "scene.hpp"
#include "sound.hpp"
#include "dng_main.hpp"
#include "dng_status.hpp"
#include "savedata.hpp"
#include "actscript.hpp"
#include "scriptinterpreter.hpp"
#include <cstring>
#include <cstdio>
#include <cmath>
#include "actionchara.hpp"
#include "character.hpp"
#include "scenesnd.hpp"
#include "userdata.hpp"
#include "charasetup.hpp"

extern char at_868__3[];
extern char at_869__3[];
extern char at_870__2[];
extern char at_871__3[];
extern char at_872__3[];
extern char at_1150[];
extern char at_1000__3[], at_1001__3[], at_1002__3[], at_1003__3[], at_1004__3[], at_1005__3[], at_1006__2[], at_1007__2[], at_1008__3[], at_1009__2[], at_1010__2[], at_1011__2[], at_1012__2[], at_1013__2[], at_1014__2[], at_1015__2[], at_1016__3[], at_1017__3[], at_1018__4[];
struct SetupPartStack { int stacks[5]; };
extern SetupPartStack at_919__3;
extern int mem_table[4][7];
extern char at_1149[];
int SetupMints(CScene *scene, CUserDataManager *user_data);
int SetupMonica(CScene *scene, CUserDataManager *user_data);
int SetupMonster(CScene *scene, CUserDataManager *user_data);
struct SetupNameTable4 { char *names[4]; };
struct SetupNameTable3 { char *names[3]; };
struct SetupNameTable6 { char *names[6]; };
extern SetupNameTable6 at_1216__4;
extern char at_1268[], at_1269[], at_1270[], at_1271[], at_1272[], at_1273[], at_1274[], at_1275[], at_1276[], at_1277[];
extern SetupNameTable4 at_1110;
extern SetupNameTable3 at_1113;
extern SetupNameTable3 at_1161;
extern SetupNameTable3 at_1162;
void GetCharacterSnd(CUserDataManager *user_data, int unit, char *path);
int GetCharaMemAllocSize();
void SetupUnitMan(CScene *scene, CUserDataManager *user_data, int unit, ROBO_INFO_DATA *robo);
int SetupMints(CScene *scene, CUserDataManager *user_data);
int SetupMonica(CScene *scene, CUserDataManager *user_data);
int SetupMonster(CScene *scene, CUserDataManager *user_data);
#include "actionchara.hpp"
#include "character.hpp"
#include "dataread.hpp"
#include "dng_main.hpp"
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "maintex.hpp"
#include "mapselect.hpp"
#include "menuchr.hpp"
#include "mg_memory.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "userdata.hpp"

#include <cstdio>
#include <cstring>

extern int mem_table[4][7];
extern char r_robo_pname_1282[4][16];
extern char fname_1290[64];
struct SetupPartOrder { int parts[4]; };
extern SetupPartOrder at_1281__2;
extern char *fname_tbl_1291[6];
extern char *fname_tbl2_1298[6];
extern "C" int GetDataTypeStartListNo__9CGameDataFi(CGameData *, int);

static int SetupRobo(CScene *scene, CUserDataManager *user_data, ROBO_INFO_DATA *robo_info);

// Code (.text)
void GetCharacterSnd(CUserDataManager *user_data, int unit, char *path) {
    CHARA_DATA *chara = user_data->GetCharaDataPtr(unit);
    CGameDataUsed *equip = chara->equip;
    if (equip != 0) {
        if (unit == 0) {
            int item_no = equip[1].item_no;
            if (item_no < 0x16 || item_no > 0x28) {
                sprintf(path, at_868__3);
                return;
            }
            if (item_no < 0x20)
                sprintf(path, at_869__3, item_no - 0x16);
            else
                sprintf(path, at_870__2, item_no - 0x16);
        }
        if (unit == 1)
            sprintf(path, at_871__3);
        if (unit == 2) {
            char name[0x40];
            user_data->robo_data.parts[0].GetRoboSoundFileName(name);
            sprintf(path, at_872__3, name);
        }
    }
}
#ifdef NONMATCHING
int SetupMainUnit(u_long128 *read_buffer, mgCMemory *memory, mgCMemory *stacks, int image_block,
                  CScene *scene, CUserDataManager *user_data, int chara_type, int edit_mode) {
    CActionChara *parts[6];
    int texture = (int)(u32)image_block;
    for (int character_index = 0; character_index < 6; ++character_index) {
        parts[character_index] = (CActionChara *)scene->GetCharacter(character_index);
        if (parts[character_index] == NULL) return 0;
        parts[character_index]->Initialize(NULL);
    }
    if (chara_type == 0) {
        char path[32];
        char model_name[32];
        GetCharaMemAllocPtr(memory, stacks, 0, edit_mode);
        parts[0]->Initialize(stacks);
        GetMainCharaModelName(0, model_name, edit_mode);
        if (edit_mode != 0) {
            sprintf(path, at_1000__3, model_name);
            LoadFile(path, read_buffer, NULL);
        } else {
            sprintf(path, at_1001__3, model_name);
            LoadFile(path, read_buffer, NULL);
        }
        parts[0]->accume_effect = &AccumulateEffect;
        parts[0]->LoadPack((unsigned int *)read_buffer, at_1002__3, stacks, stacks, stacks, texture, NULL);
        parts[0]->SetPosition(0.0f, 0.0f, 200.0f);
        parts[0]->texture_block = texture;
        CGameDataUsed *equip = user_data->GetCharaDataPtr(chara_type)->equip;
        char *item_path;
        LoadFile(GetItemFilePath(equip[4].item_no, 0), read_buffer, NULL);
        parts[0]->LoadSkin((unsigned int *)read_buffer, at_1002__3, at_1003__3, &stacks[1], texture);
        if (!edit_mode) {
            if (equip[0].item_no > 0) {
                item_path = GetItemFilePath(equip[0].item_no, 0);
                parts[1]->Initialize(NULL);
                LoadFile(item_path, read_buffer, NULL);
                parts[1]->LoadPack((unsigned int *)read_buffer, at_1002__3, &stacks[2], &stacks[2], &stacks[2], texture, parts[0]);
                if (!parts[0]->SetRef(parts[1], at_1004__3)) printf(at_1005__3);
            }
            if (equip[1].item_no > 0) {
                item_path = GetItemFilePath(equip[1].item_no, 0);
                parts[2]->Initialize(NULL);
                LoadFile(item_path, read_buffer, NULL);
                parts[2]->LoadPack((unsigned int *)read_buffer, at_1002__3, &stacks[3], &stacks[3], &stacks[3], texture, parts[0]);
                if (!parts[0]->SetRef(parts[2], at_1006__2)) printf(at_1005__3);
            }
            SetSwordBlurEffect(parts[0], &stacks[2], chara_type);
        }
        item_path = GetItemFilePath(equip[2].item_no, 0);
        parts[3]->Initialize(NULL);
        LoadFile(item_path, read_buffer, NULL);
        parts[3]->LoadPack((unsigned int *)read_buffer, at_1002__3, &stacks[4], &stacks[4], &stacks[4], texture, parts[0]);
        if (!parts[0]->SetRef(parts[3], at_1007__2)) printf(at_1005__3);
        LoadFile(GetItemFilePath(equip[3].item_no, 0), read_buffer, NULL);
        parts[0]->LoadSkin((unsigned int *)read_buffer, at_1002__3, at_1003__3, &stacks[5], texture);
        if (!edit_mode) {
            int file_size;
            LoadFile(at_1008__3, read_buffer, &file_size);
            parts[0]->LoadActionFile((char *)read_buffer, file_size, &stacks[6]);
            parts[0]->InitScript();
        }
        SetupUnitMan(scene, user_data, 0, NULL);
        parts[0]->chara_type = 0;
        parts[0]->move_type = 0;
    }
    if (chara_type == 1) {
        char path[32];
        char model_name[32];
        GetCharaMemAllocPtr(memory, stacks, 0, edit_mode);
        parts[0]->Initialize(stacks);
        GetMainCharaModelName(1, model_name, edit_mode);
        if (edit_mode != 0) {
            sprintf(path, at_1000__3, model_name);
            LoadFile(path, read_buffer, NULL);
        } else {
            sprintf(path, at_1001__3, model_name);
            LoadFile(path, read_buffer, NULL);
        }
        parts[0]->accume_effect = &AccumulateEffect;
        parts[0]->LoadPack((unsigned int *)read_buffer, at_1002__3, stacks, stacks, stacks, texture, NULL);
        parts[0]->SetPosition(0.0f, 0.0f, 200.0f);
        parts[0]->texture_block = texture;
        CGameDataUsed *equip = user_data->GetCharaDataPtr(chara_type)->equip;
        char *item_path;
        LoadFile(GetItemFilePath(equip[4].item_no, 0), read_buffer, NULL);
        parts[0]->LoadSkin((unsigned int *)read_buffer, at_1002__3, at_1003__3, &stacks[1], texture);
        if (!edit_mode) {
            item_path = GetItemFilePath(equip[0].item_no, 0);
            parts[1]->Initialize(NULL);
            LoadFile(item_path, read_buffer, NULL);
            parts[1]->LoadPack((unsigned int *)read_buffer, at_1002__3, &stacks[2], &stacks[2], &stacks[2], texture, parts[0]);
            if (!parts[0]->SetRef(parts[1], at_1009__2)) printf(at_1005__3);
            SetSwordBlurEffect(parts[0], &stacks[2], chara_type);
        }
        item_path = GetItemFilePath(equip[1].item_no, 0);
        parts[2]->Initialize(NULL);
        LoadFile(item_path, read_buffer, NULL);
        parts[2]->LoadPack((unsigned int *)read_buffer, at_1002__3, &stacks[3], &stacks[3], &stacks[3], texture, parts[0]);
        if (!parts[0]->SetRef(parts[2], at_1010__2)) printf(at_1005__3);
        item_path = GetItemFilePath(equip[2].item_no, 0);
        parts[3]->Initialize(NULL);
        LoadFile(item_path, read_buffer, NULL);
        parts[3]->LoadPack((unsigned int *)read_buffer, at_1002__3, &stacks[4], &stacks[4], &stacks[4], texture, parts[0]);
        if (!parts[0]->SetRef(parts[3], at_1011__2)) printf(at_1005__3);
        LoadFile(GetItemFilePath(equip[3].item_no, 0), read_buffer, NULL);
        parts[0]->LoadSkin((unsigned int *)read_buffer, at_1002__3, at_1003__3, &stacks[5], texture);
        if (!edit_mode) {
            int file_size;
            LoadFile(at_1012__2, read_buffer, &file_size);
            parts[0]->LoadActionFile((char *)read_buffer, file_size, &stacks[6]);
            parts[0]->InitScript();
        }
        SetupUnitMan(scene, user_data, 1, NULL);
        parts[0]->chara_type = 1;
        parts[0]->move_type = 0;
    }
    if (chara_type == 2) {
        char path[64];
        GetCharaMemAllocPtr(memory, stacks, 2, edit_mode);
        ROBO_INFO_DATA *robo_info = GetRoboPartsInfo(user_data);
        parts[0]->Initialize(NULL);
        sprintf(path, at_1013__2, robo_info->model_name[0]);
        LoadFile(path, read_buffer, NULL);
        parts[0]->LoadPack((unsigned int *)read_buffer, at_1002__3, stacks, stacks, stacks, texture, NULL);
        parts[0]->texture_block = texture;
        SetupPartStack part_stack = at_919__3;
        for (int i = 1; i < 5; ++i) {
            CActionChara *part = parts[i];
            part->Initialize(NULL);
            if (i != 3) sprintf(path, at_1013__2, robo_info->model_name[i]);
            else sprintf(path, at_1014__2, robo_info->model_name[i]);
            LoadFile(path, read_buffer, NULL);
            mgCMemory *stack = &stacks[part_stack.stacks[i]];
            part->LoadPack((unsigned int *)read_buffer, at_1002__3, stack, stack, stack, texture, parts[0]);
            if (i == 1) SetSwordBlurEffect(parts[0], stack, chara_type);
        }
        CActionChara *part = parts[5];
        part->Initialize(NULL);
        LoadFile(robo_info->hat_file, read_buffer, NULL);
        part->LoadPack((unsigned int *)read_buffer, at_1002__3, &stacks[2], &stacks[2], &stacks[2], texture, parts[0]);
        SetupUnitMan(scene, user_data, 2, robo_info);
        int file_size;
        LoadFile(at_1015__2, read_buffer, &file_size);
        parts[0]->LoadActionFile((char *)read_buffer, file_size, &stacks[4]);
        parts[0]->InitScript();
        parts[0]->move_type = robo_info->move_type;
        parts[0]->attack_type = robo_info->attack_type;
        parts[0]->chara_type = 2;
    }
    if (chara_type == 3) {
        char monster_path[64];
        char monster_info[64];
        char monster_script[64];
        char monster_model[32];
        int monster_id = user_data->monster_id;
        GetCharaMemAllocPtr(memory, stacks, 3, edit_mode);
        GetMonsterModelFile(monster_id, 0, monster_model);
        sprintf(monster_path, at_1016__3, monster_model);
        GetMonsterModelFile(monster_id, 3, monster_info);
        GetMonsterModelFile(monster_id, 2, monster_model);
        sprintf(monster_script, at_1017__3, monster_model);
        LoadFile(monster_path, read_buffer, NULL);
        parts[0]->Initialize(NULL);
        parts[0]->LoadPack((unsigned int *)read_buffer, monster_info, stacks, stacks, stacks, texture, NULL);
        parts[0]->SetPosition(0.0f, 0.0f, 0.0f);
        parts[0]->texture_block = texture;
        SetupUnitMan(scene, user_data, 3, NULL);
        int file_size;
        LoadFile(monster_script, read_buffer, &file_size);
        parts[0]->LoadActionFile((char *)read_buffer, file_size, &stacks[5]);
        parts[0]->InitScript();
        parts[0]->chara_type = 0;
        parts[0]->move_type = 3;
    }
    int i = 0;
    do {
        printf(at_1018__4, i, stacks[i].stack_used, stacks[i].stack_size);
        ++i;
    } while (i < 7);
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/charasetup", SetupMainUnit__FP1P9mgCMemoryP9mgCMemoryiP6CSceneP16CUserDataManagerii);
#endif
int GetCharaMemAllocSize() {
    int maximum = 0;
    for (int row = 0; row < 4; ++row) {
        int size = 0;
        for (int column = 0; column < 7; ++column) size += mem_table[row][column];
        if (size > maximum) maximum = size;
    }
    return maximum + 16;
}
int GetCharaMemAllocPtr(mgCMemory *memory, mgCMemory *stacks, int chara_type, int edit_mode) {
    int row;
    int count;
    switch (chara_type) {
        case 0:
        case 1:
            row = 0;
            count = 7;
            if (edit_mode != 0) row = 2;
            break;
        case 2:
            row = 1;
            count = 5;
            break;
        case 3:
            row = 0;
            count = 6;
            break;
    }
    memory->stack_used = 0;
    memory->lock = 0;
    int index = 0;
    int size;
    if (index < count) {
    int table_offset = 0;
    int stack_offset = 0;
    do {
        size = *(int *)(table_offset + (int)mem_table[row]);
        if (size < 0) break;
        u_long128 *buffer = memory->stAllocTest(size);
        mgCMemory *stack = (mgCMemory *)((u8 *)stacks + stack_offset);
        if (buffer == NULL) return 0;
        stack->stSetBuffer(buffer, size);
        stack->stack_used = 0;
        stack->lock = 0;
        memory->stAlloc64(size);
        index++;
        table_offset += 4;
        stack_offset += 0x30;
    } while (index < count);
    }
    return 1;
}
void SetupUnitMan(CScene *scene, CUserDataManager *user_data, int unit, ROBO_INFO_DATA *robo) {
    CCharacter2 *leader;
    CCharacter2 *character;
    int slot;

    switch (unit) {
        case ACTION_CHARA_MAX:
            SetupMints(scene, user_data);
            break;
        case ACTION_CHARA_MONICA:
            SetupMonica(scene, user_data);
            break;
        case ACTION_CHARA_ROBO:
            SetupRobo(scene, user_data, robo);
            break;
        case ACTION_CHARA_MONSTER:
            SetupMonster(scene, user_data);
            break;
    }
    leader = scene->GetCharacter(0);
    if (leader != NULL) {
        leader->sound_info.loop_se = &scene->loop_se;
    }
    slot = 0;
    if (unit == ACTION_CHARA_ROBO) {
        slot = 3;
    }
    character = scene->GetCharacter(slot);
    if ((character != NULL) && (GetSaveData()->GetBitCtrl() & 8)) {
        AtraMiriaOnOff(unit, character, 0);
    }
}
int SetupMints(CScene *scene, CUserDataManager *user_data) {
    CGameDataUsed *equip = user_data->GetCharaDataPtr(0)->equip;
    CCharacter2 *characters[5];
    for (int slot = 0; slot < 5; slot++) {
        characters[slot] = scene->GetCharacter(slot);
        if (characters[slot] != NULL)
            ((CActionChara *)characters[slot])->ResetParent();
    }
    SetupNameTable4 attach_names = at_1110;
    SetupNameTable3 part_names = at_1113;
    int part = 0;
    if (characters[0] != NULL) {
        strcpy(characters[0]->name, at_1149);
        part = 0;
    }
    for (part = 0; part < 3; part++, equip++) {
        if (0 < equip->item_no) {
            if (characters[part + 1] != NULL) {
                char *attach_name = attach_names.names[part];
                if (((CActionChara *)characters[0])
                        ->SetRef((CActionChara *)characters[part + 1], attach_name) == 0) {
                    printf(at_1150, attach_name);
                } else {
                    strcpy(characters[part + 1]->name, part_names.names[part]);
                    characters[part + 1]->CopyOutLine(characters[0]);
                }
            }
        }
    }
    ((CActionChara *)characters[0])->move_type = 0;
    ((CActionChara *)characters[0])->attack_type = 0;
    ((CActionChara *)characters[0])->chara_type = 0;
    return 1;
}
int SetupMonica(CScene *scene, CUserDataManager *user_data) {
    CGameDataUsed *equip = user_data->GetCharaDataPtr(1)->equip;
    CCharacter2 *characters[5];
    for (int slot = 0; slot < 5; slot++) {
        characters[slot] = scene->GetCharacter(slot);
        if (characters[slot] != NULL)
            ((CActionChara *)characters[slot])->ResetParent();
    }
    SetupNameTable3 attach_names = at_1161;
    SetupNameTable3 part_names = at_1162;
    int part = 0;
    if (characters[0] != NULL) {
        strcpy(characters[0]->name, at_1149);
        part = 0;
    }
    for (part = 0; part < 3; part++, equip++) {
        if (0 < equip->item_no) {
            if (characters[part + 1] != NULL) {
                char *attach_name = attach_names.names[part];
                if (((CActionChara *)characters[0])
                        ->SetRef((CActionChara *)characters[part + 1], attach_name) == 0) {
                    printf(at_1150, attach_name);
                } else {
                    strcpy(characters[part + 1]->name, part_names.names[part]);
                    characters[part + 1]->CopyOutLine(characters[0]);
                }
            }
        }
    }
    ((CActionChara *)characters[0])->move_type = 0;
    ((CActionChara *)characters[0])->chara_type = ACTION_CHARA_MONICA;
    return 1;
}
static int SetupRobo(CScene *scene, CUserDataManager *user_data, ROBO_INFO_DATA *robo_info) {
    CActionChara *parts[6];
    char arm_joint[64];
    char leg_joint[64];
    CGameDataUsed *leg_part;
    user_data->robo_data.parts[1].GetRoboJointName(arm_joint);
    leg_part = &user_data->robo_data.parts[0];
    leg_part->GetRoboJointName(leg_joint);
    int leg_type = user_data->robo_data.parts[3].GetRoboInfoType();
    int arm_type = leg_part->GetRoboInfoType();
    for (int i = 0; i < 6; ++i) {
        parts[i] = (CActionChara *)scene->GetCharacter(i);
        if (parts[i] == NULL) return 0;
    }
    for (int i = 0; i < 6; ++i) parts[i]->ResetParent();
    SetupNameTable6 joint_names = at_1216__4;
    for (int i = 0; i < 5; ++i) {
        if (i == 0) {
            parts[0]->SetRef(parts[i + 1], leg_joint);
        } else {
            if (!parts[0]->SetRef(parts[i + 1], joint_names.names[i])) printf(at_1268, joint_names.names[i]);
        }
        parts[i + 1]->CopyOutLine(parts[0]);
    }
    strcpy(parts[0]->name, at_1269);
    strcpy(parts[1]->name, at_1270);
    strcpy(parts[2]->name, at_1149);
    strcpy(parts[3]->name, at_1271);
    strcpy(parts[4]->name, at_1272);
    strcpy(parts[5]->name, at_1273);
    if (robo_info == NULL) return 0;
    mgCFrame *arm = parts[0]->SearchObject(at_1274);
    mgCFrame *joint = parts[0]->SearchObject(arm_joint);
    if (arm == NULL) printf(at_1275);
    if (joint == NULL) printf(at_1276);
    if (arm == NULL || joint == NULL) return 0;
    sceVu0FMATRIX matrix;
    sceVu0CopyMatrix(matrix, joint->trans_matrix);
    arm->SetTransMatrix(matrix);
    parts[0]->move_type = leg_type;
    parts[0]->attack_type = arm_type;
    printf(at_1277, leg_joint, arm_joint);
    parts[0]->chara_type = 2;
    return 1;
}
ROBO_INFO_DATA *GetRoboPartsInfo(CUserDataManager *user_data) {
    int i;
    ROBO_DATA *parts = &user_data->robo_data;
    CGameData *game_data = GetGameDataPt();
    SetupPartOrder part_order = at_1281__2;
    CDataRoboPart *part_info[4];
    for (i = 0; i < 4; ++i) {
        part_info[i] = GetRoboPartInfoData(parts->parts[part_order.parts[i]].item_no);
        r_robo_pname_1282[i][0] = 0;
        if (part_info[i] != NULL) strcpy(r_robo_pname_1282[i], GetItemFileName(parts->parts[part_order.parts[i]].item_no, 0));
    }
    robo_dat.model_name[ROBO_MODEL_LEG] = r_robo_pname_1282[0];
    robo_dat.model_name[ROBO_MODEL_ARM] = r_robo_pname_1282[1];
    robo_dat.model_name[ROBO_MODEL_BODY] = r_robo_pname_1282[2];
    robo_dat.model_name[ROBO_MODEL_BPACK] = r_robo_pname_1282[3];
    CHARA_DATA *max_data = user_data->GetCharaDataPtr(0);
    int costume = max_data->equip[4].item_no;
    costume -= GetDataTypeStartListNo__9CGameDataFi(game_data, 5);
    if (part_info[2] != NULL) {
        int body_type = part_info[2]->offset_no;
        if (GetSaveData()->GetBitFlag(799)) body_type += 10;
        if (body_type < 10) sprintf(fname_1290, fname_tbl_1291[costume], body_type);
        else sprintf(fname_1290, fname_tbl2_1298[costume], body_type);
    }
    robo_dat.arm_name = NULL;
    robo_dat.model_name[ROBO_MODEL_MINTS] = fname_1290;
    if (part_info[2] != NULL) robo_dat.arm_name = robo_info_body[part_info[2]->offset_no - 1].arm_name;
    robo_dat.move_type = 0;
    if (part_info[0] != NULL) robo_dat.move_type = user_data->robo_data.parts[3].GetRoboInfoType();
    robo_dat.attack_type = 0;
    if (part_info[1] != NULL) robo_dat.attack_type = user_data->robo_data.parts[0].GetRoboInfoType();
    max_data = user_data->GetCharaDataPtr(0);
    robo_dat.hat_file = GetItemFilePath(max_data->equip[2].item_no, 0);
    return &robo_dat;
}
int SetupMonster(CScene *scene, CUserDataManager *user_data) {
    CCharacter2 *characters[5];
    for (int slot = 0; slot < 5; slot++) {
        characters[slot] = scene->GetCharacter(slot);
        if (characters[slot] != NULL)
            ((CActionChara *)characters[slot])->ResetParent();
    }
    if (characters[0] != NULL)
        strcpy(characters[0]->name, at_1149);
    ((CActionChara *)characters[0])->move_type = 3;
    ((CActionChara *)characters[0])->chara_type = ACTION_CHARA_MONSTER;
    return 1;
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_919__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", mem_table__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1110__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1113__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1161__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1162__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1216__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", robo_info_body__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1281__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", fname_tbl_1291__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", fname_tbl2_1298__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_868__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_869__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_870__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_871__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_872__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1000__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1001__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1002__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1003__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1004__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1005__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1006__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1007__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1008__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1009__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1010__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1011__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1012__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1013__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1014__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1015__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1016__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1017__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1018__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1111__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1112__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1149__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1150__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1212__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1213__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1214__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1215__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1268__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1269__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1270__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1271__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1272__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1273__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1274__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1275__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1276__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1277__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1292__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1293__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1294__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1295__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1296__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1297__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1299__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1300__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1301__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1302__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1303__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/charasetup", at_1304__3__DATA);

// Uninitialised data (.bss)
INCLUDE_BSS(robo_dat, 0x30);
INCLUDE_BSS(r_robo_pname_1282, 0x40);
INCLUDE_BSS(fname_1290, 0x40);
