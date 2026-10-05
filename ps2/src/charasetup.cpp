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
extern int mem_table[4][7];
extern char at_1149[];
int SetupMints(CScene *scene, CUserDataManager *user_data);
int SetupMonica(CScene *scene, CUserDataManager *user_data);
int SetupMonster(CScene *scene, CUserDataManager *user_data);
extern char *at_1110[4];
extern char *at_1113[3];
extern char *at_1161[3];
extern char *at_1162[3];
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
    char model_name[32];
    char path[64];
    int file_size;

    for (int i = 0; i < 6; ++i) {
        parts[i] = (CActionChara *)scene->GetCharacter(i);
        if (parts[i] == NULL) return 0;
        parts[i]->Initialize(NULL);
    }

    CActionChara *main_character = parts[0];
    if (chara_type == 0 || chara_type == 1) {
        GetCharaMemAllocPtr(memory, stacks, 0, edit_mode);
        main_character->Initialize(stacks);
        GetMainCharaModelName(chara_type, model_name, edit_mode);
        sprintf(path, edit_mode ? "chara/%s" : "mainchr/%s", model_name);
        LoadFile(path, read_buffer, NULL);
        main_character->accume_effect = &AccumulateEffect;
        main_character->LoadPack((unsigned int *)read_buffer, "info.cfg", &stacks[0], &stacks[0], &stacks[0], image_block, NULL);
        main_character->SetPosition(0.0f, 0.0f, 200.0f);
        main_character->shadow_link_shadow = (s32 *)image_block;

        CHARA_DATA *chara = user_data->GetCharaDataPtr(chara_type);
        LoadFile(GetItemFilePath(chara->equip[4].item_no, 0), read_buffer, NULL);
        main_character->LoadSkin((unsigned int *)read_buffer, "info.cfg", "", &stacks[1], image_block);

        if (chara_type == 0) {
            if (!edit_mode) {
                if (chara->equip[0].item_no > 0) {
                    parts[1]->Initialize(NULL);
                    LoadFile(GetItemFilePath(chara->equip[0].item_no, 0), read_buffer, NULL);
                    parts[1]->LoadPack((unsigned int *)read_buffer, "info.cfg", &stacks[2], &stacks[2], &stacks[2], image_block, main_character);
                    if (!main_character->SetRef(parts[1], "ef00")) printf("err wep1\n");
                }
                if (chara->equip[1].item_no > 0) {
                    parts[2]->Initialize(NULL);
                    LoadFile(GetItemFilePath(chara->equip[1].item_no, 0), read_buffer, NULL);
                    parts[2]->LoadPack((unsigned int *)read_buffer, "info.cfg", &stacks[3], &stacks[3], &stacks[3], image_block, main_character);
                    if (!main_character->SetRef(parts[2], "gun_hand")) printf("err wep1\n");
                }
                SetSwordBlurEffect(main_character, &stacks[2], chara_type);
            }
            parts[3]->Initialize(NULL);
            LoadFile(GetItemFilePath(chara->equip[2].item_no, 0), read_buffer, NULL);
            parts[3]->LoadPack((unsigned int *)read_buffer, "info.cfg", &stacks[4], &stacks[4], &stacks[4], image_block, main_character);
            if (!main_character->SetRef(parts[3], "hat")) printf("err wep1\n");
        } else {
            if (!edit_mode) {
                parts[1]->Initialize(NULL);
                LoadFile(GetItemFilePath(chara->equip[0].item_no, 0), read_buffer, NULL);
                parts[1]->LoadPack((unsigned int *)read_buffer, "info.cfg", &stacks[2], &stacks[2], &stacks[2], image_block, main_character);
                if (!main_character->SetRef(parts[1], "sword_hand")) printf("err wep1\n");
                SetSwordBlurEffect(main_character, &stacks[2], chara_type);
            }
            parts[2]->Initialize(NULL);
            LoadFile(GetItemFilePath(chara->equip[1].item_no, 0), read_buffer, NULL);
            parts[2]->LoadPack((unsigned int *)read_buffer, "info.cfg", &stacks[3], &stacks[3], &stacks[3], image_block, main_character);
            if (!main_character->SetRef(parts[2], "wr")) printf("err wep1\n");
            parts[3]->Initialize(NULL);
            LoadFile(GetItemFilePath(chara->equip[2].item_no, 0), read_buffer, NULL);
            parts[3]->LoadPack((unsigned int *)read_buffer, "info.cfg", &stacks[4], &stacks[4], &stacks[4], image_block, main_character);
            if (!main_character->SetRef(parts[3], "ac")) printf("err wep1\n");
        }

        LoadFile(GetItemFilePath(chara->equip[3].item_no, 0), read_buffer, NULL);
        main_character->LoadSkin((unsigned int *)read_buffer, "info.cfg", "", &stacks[5], image_block);
        if (!edit_mode) {
            LoadFile((char *)(chara_type == 0 ? "mainchr/c01.stb" : "mainchr/c02.stb"), read_buffer, &file_size);
            main_character->LoadActionFile((char *)read_buffer, file_size, &stacks[6]);
            main_character->InitScript();
        }
        SetupUnitMan(scene, user_data, chara_type, NULL);
        main_character->chara_type = chara_type;
        main_character->move_type = 0;
    } else if (chara_type == 2) {
        GetCharaMemAllocPtr(memory, stacks, 2, edit_mode);
        ROBO_INFO_DATA *robo_info = GetRoboPartsInfo(user_data);
        main_character->Initialize(NULL);
        sprintf(path, "dungeon/robo/%s.chr", robo_info->model_name[0]);
        LoadFile(path, read_buffer, NULL);
        main_character->LoadPack((unsigned int *)read_buffer, "info.cfg", &stacks[0], &stacks[0], &stacks[0], image_block, NULL);
        main_character->shadow_link_shadow = (s32 *)image_block;
        const int part_stack[5] = {0, 1, 2, 2, 3};
        for (int i = 1; i < 5; ++i) {
            parts[i]->Initialize(NULL);
            sprintf(path, i == 3 ? "dungeon/robo/%s" : "dungeon/robo/%s.chr", robo_info->model_name[i]);
            LoadFile(path, read_buffer, NULL);
            mgCMemory *stack = &stacks[part_stack[i]];
            parts[i]->LoadPack((unsigned int *)read_buffer, "info.cfg", stack, stack, stack, image_block, main_character);
            if (i == 1) SetSwordBlurEffect(main_character, stack, chara_type);
        }
        parts[5]->Initialize(NULL);
        LoadFile(robo_info->hat_file, read_buffer, NULL);
        parts[5]->LoadPack((unsigned int *)read_buffer, "info.cfg", &stacks[2], &stacks[2], &stacks[2], image_block, main_character);
        SetupUnitMan(scene, user_data, 2, robo_info);
        LoadFile("dungeon/act_script/robo.stb", read_buffer, &file_size);
        main_character->LoadActionFile((char *)read_buffer, file_size, &stacks[4]);
        main_character->InitScript();
        main_character->move_type = robo_info->move_type;
        main_character->attack_type = robo_info->attack_type;
        main_character->chara_type = 2;
    } else if (chara_type == 3) {
        char monster_model[64];
        char monster_info[64];
        char monster_script[64];
        GetCharaMemAllocPtr(memory, stacks, 3, edit_mode);
        GetMonsterModelFile(user_data->monster_id, 0, monster_model);
        sprintf(path, "dungeon/monster/%s", monster_model);
        GetMonsterModelFile(user_data->monster_id, 3, monster_info);
        GetMonsterModelFile(user_data->monster_id, 2, monster_model);
        sprintf(monster_script, "dungeon/act_script/%s", monster_model);
        LoadFile(path, read_buffer, NULL);
        main_character->Initialize(NULL);
        main_character->LoadPack((unsigned int *)read_buffer, monster_info, &stacks[0], &stacks[0], &stacks[0], image_block, NULL);
        main_character->SetPosition(0.0f, 0.0f, 0.0f);
        main_character->shadow_link_shadow = (s32 *)image_block;
        SetupUnitMan(scene, user_data, 3, NULL);
        LoadFile(monster_script, read_buffer, &file_size);
        main_character->LoadActionFile((char *)read_buffer, file_size, &stacks[5]);
        main_character->InitScript();
        main_character->chara_type = 0;
        main_character->move_type = 3;
    }
    for (int i = 0; i < 7; ++i) printf("[%d]STACK %d/%d\n", i, stacks[i].stack_used, stacks[i].stack_size);
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
#ifdef NONMATCHING
int GetCharaMemAllocPtr(mgCMemory *memory, mgCMemory *stacks, int chara_type, int edit_mode) {
    int row = 0;
    int count = 7;
    if (chara_type == 2) {
        row = 1;
        count = 5;
    } else if (chara_type == 3) {
        count = 6;
    } else if (edit_mode) {
        row = 2;
    }
    memory->stack_used = 0;
    memory->lock = 0;
    for (int i = 0; i < count; ++i) {
        int size = mem_table[row][i];
        if (size < 0) break;
        u_long128 *buffer = memory->stAllocTest(size);
        if (buffer == NULL) return 0;
        stacks[i].stSetBuffer(buffer, size);
        stacks[i].stack_block = NULL;
        stacks[i].stack_size = 0;
        memory->stAlloc64(size);
    }
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/charasetup", GetCharaMemAllocPtr__FP9mgCMemoryP9mgCMemoryii);
#endif
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
        leader->loop_se = &scene->loop_se;
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
    char **attach_names = at_1110;
    char **part_names = at_1113;
    int part = 0;
    if (characters[0] != NULL) {
        strcpy(characters[0]->name, at_1149);
        part = 0;
    }
    for (part = 0; part < 3; part++, equip++) {
        if (0 < equip->item_no) {
            if (characters[part + 1] != NULL) {
                char *attach_name = attach_names[part];
                if (((CActionChara *)characters[0])
                        ->SetRef((CActionChara *)characters[part + 1], attach_name) == 0) {
                    printf(at_1150, attach_name);
                } else {
                    strcpy(characters[part + 1]->name, part_names[part]);
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
    char **attach_names = at_1161;
    char **part_names = at_1162;
    int part = 0;
    if (characters[0] != NULL) {
        strcpy(characters[0]->name, at_1149);
        part = 0;
    }
    for (part = 0; part < 3; part++, equip++) {
        if (0 < equip->item_no) {
            if (characters[part + 1] != NULL) {
                char *attach_name = attach_names[part];
                if (((CActionChara *)characters[0])
                        ->SetRef((CActionChara *)characters[part + 1], attach_name) == 0) {
                    printf(at_1150, attach_name);
                } else {
                    strcpy(characters[part + 1]->name, part_names[part]);
                    characters[part + 1]->CopyOutLine(characters[0]);
                }
            }
        }
    }
    ((CActionChara *)characters[0])->move_type = 0;
    ((CActionChara *)characters[0])->chara_type = ACTION_CHARA_MONICA;
    return 1;
}
#ifdef NONMATCHING
static int SetupRobo(CScene *scene, CUserDataManager *user_data, ROBO_INFO_DATA *robo_info) {
    char arm_joint[64], leg_joint[64];
    user_data->robo_data.parts[1].GetRoboJointName(arm_joint);
    user_data->robo_data.parts[0].GetRoboJointName(leg_joint);
    int leg_type = user_data->robo_data.parts[3].GetRoboInfoType();
    int arm_type = user_data->robo_data.parts[0].GetRoboInfoType();
    CActionChara *parts[6];
    for (int i = 0; i < 6; ++i) {
        parts[i] = (CActionChara *)scene->GetCharacter(i);
        if (parts[i] == NULL) return 0;
    }
    for (int i = 0; i < 6; ++i) parts[i]->ResetParent();
    const char *joint_names[5] = {"body%d", "spine", "joint2", "joint1", "hat"};
    for (int i = 0; i < 5; ++i) {
        char *joint = i == 0 ? leg_joint : (char *)joint_names[i];
        if (!parts[0]->SetRef(parts[i + 1], joint) && i != 0) printf(" refer failed  :  %s\n", joint);
        parts[i + 1]->CopyOutLine(parts[0]);
    }
    const char *names[6] = {"leg", "arm", "body", "mints", "bpack", "cap"};
    for (int i = 0; i < 6; ++i) strcpy(parts[i]->name, names[i]);
    if (robo_info == NULL) return 0;
    mgCFrame *arm = parts[0]->SearchObject("ude");
    mgCFrame *joint = parts[0]->SearchObject(arm_joint);
    if (arm == NULL) printf("NOT ARM!\n");
    if (joint == NULL) printf("NOT MAT!\n");
    if (arm == NULL || joint == NULL) return 0;
    arm->SetTransMatrix(joint->trans_matrix);
    parts[0]->move_type = leg_type;
    parts[0]->attack_type = arm_type;
    parts[0]->chara_type = 2;
    printf("***************** %s,%s\n", leg_joint, arm_joint);
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/charasetup", SetupRobo__FP6CSceneP16CUserDataManagerP14ROBO_INFO_DATA);
#endif
#ifdef NONMATCHING
ROBO_INFO_DATA *GetRoboPartsInfo(CUserDataManager *user_data) {
    static const int part_order[4] = {3, 0, 1, 2};
    static const char *costume_file[6] = {
        "mints0%da.chr", "mints0%db.chr", "mints0%dc.chr",
        "mints0%dd.chr", "mints0%de.chr", "mints0%df.chr"
    };
    static const char *costume_file_late[6] = {
        "mints%da.chr", "mints%db.chr", "mints%dc.chr",
        "mints%dd.chr", "mints%de.chr", "mints%df.chr"
    };
    CDataRoboPart *part_info[4];
    for (int i = 0; i < 4; ++i) {
        int slot = part_order[i];
        CGameDataUsed &part = user_data->robo_data.parts[slot];
        part_info[i] = GetRoboPartInfoData(part.item_no);
        r_robo_pname_1282[i][0] = 0;
        if (part_info[i] != NULL) strcpy(r_robo_pname_1282[i], GetItemFileName(part.item_no, 0));
    }
    robo_dat.model_name[ROBO_MODEL_LEG] = r_robo_pname_1282[0];
    robo_dat.model_name[ROBO_MODEL_ARM] = r_robo_pname_1282[1];
    robo_dat.model_name[ROBO_MODEL_BODY] = r_robo_pname_1282[2];
    robo_dat.model_name[ROBO_MODEL_BPACK] = r_robo_pname_1282[3];
    CHARA_DATA *max_data = user_data->GetCharaDataPtr(0);
    int costume = max_data->equip[4].item_no - GetGameDataPt()->GetDataTypeStartListNo(5);
    if (part_info[2] != NULL && costume >= 0 && costume < 6) {
        int body_type = part_info[2]->offset_no;
        if (GetSaveData()->GetBitFlag(799)) body_type += 10;
        sprintf(fname_1290, (char *)(body_type < 10 ? costume_file[costume] : costume_file_late[costume]), body_type);
    }
    robo_dat.model_name[ROBO_MODEL_MINTS] = fname_1290;
    robo_dat.arm_name = part_info[2] != NULL ? robo_info_body[part_info[2]->offset_no - 1].arm_name : NULL;
    robo_dat.move_type = part_info[0] != NULL ? user_data->robo_data.parts[3].GetRoboInfoType() : 0;
    robo_dat.attack_type = part_info[1] != NULL ? user_data->robo_data.parts[0].GetRoboInfoType() : 0;
    robo_dat.hat_file = GetItemFilePath(max_data->equip[2].item_no, 0);
    return &robo_dat;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/charasetup", GetRoboPartsInfo__FP16CUserDataManager);
#endif
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
