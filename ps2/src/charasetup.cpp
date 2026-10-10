#include "common.h"

#include <cmath>
#include <cstdio>
#include <cstring>

#include "actionchara.hpp"
#include "actscript.hpp"
#include "character.hpp"
#include "charasetup.hpp"
#include "colprim.hpp"
#include "dataread.hpp"
#include "dng_event.hpp"
#include "dng_main.hpp"
#include "dng_status.hpp"
#include "effscript.hpp"
#include "mainloop.hpp"
#include "mapselect.hpp"
#include "mg_camera.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"
#include "savedata.hpp"
#include "scene.hpp"
#include "sceneload.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include "swordeffect.hpp"
#include "userdata.hpp"

/**
 *
 * Memory stack slots used while setting up character parts.
 *
 */
struct SetupPartStack {
    int stacks[5]; /**< Stack slots for the parts. */
};

/**
 *
 * Stores the memory stack capacities for each main character setup.
 *
 */
static int mem_table[4][7] = {
    {68500,  40000, 7000,  4650,  3000,  9900, 4500},
    {30000,  30000, 60000, 10000, 10000, 0,    0   },
    {75000,  40000, 7000,  4650,  3000,  9900, 0   },
    {120000, 0,     0,     0,     0,     5500, 0   }
};
int SetupMints(CScene *scene, CUserDataManager *user_data);
int SetupMonica(CScene *scene, CUserDataManager *user_data);
int SetupMonster(CScene *scene, CUserDataManager *user_data);

/**
 *
 * Four resource names used by character setup.
 *
 */
struct SetupNameTable4 {
    char *names[4]; /**< Resource names. */
};

/**
 *
 * Three resource names used by character setup.
 *
 */
struct SetupNameTable3 {
    char *names[3]; /**< Resource names. */
};

/**
 *
 * Six resource names used by character setup.
 *
 */
struct SetupNameTable6 {
    char *names[6]; /**< Resource names. */
};

int SetupMints(CScene *scene, CUserDataManager *user_data);
int SetupMonica(CScene *scene, CUserDataManager *user_data);
int SetupMonster(CScene *scene, CUserDataManager *user_data);

#include "gamedata.hpp"
#include "maintex.hpp"
#include "menuchr.hpp"
#include "mg_memory.hpp"

/**
 *
 * Order of the four parts used by character setup.
 *
 */
struct SetupPartOrder {
    int parts[4]; /**< Part order. */
};

static int SetupRobo(CScene *scene, CUserDataManager *user_data, ROBO_INFO_DATA *robo_info);

// Code (.text)
void GetCharacterSnd(CUserDataManager *user_data, int unit, char *path) {
    CHARA_DATA    *chara = user_data->GetCharaDataPtr(unit);
    CGameDataUsed *equip = chara->equip;

    if (equip != 0) {
        if (unit == 0) {
            int item_no = equip[1].item_no;

            if (item_no < 0x16 || item_no > 0x28) {
                sprintf(path, "snd2/chara/CH_000.snd");
                return;
            }

            if (item_no < 0x20) {
                sprintf(path, "snd2/chara/CH_00%d.snd", item_no - 0x16);
            } else {
                sprintf(path, "snd2/chara/CH_0%d.snd", item_no - 0x16);
            }
        }

        if (unit == 1) {
            sprintf(path, "snd2/chara/CH_020.snd");
        }

        if (unit == 2) {
            char name[0x40];
            user_data->robo_data.parts[0].GetRoboSoundFileName(name);
            sprintf(path, "snd2/chara/%s.snd", name);
        }
    }
}

int SetupMainUnit(u_long128 *read_buffer, mgCMemory *memory, mgCMemory *stacks, int image_block,
                  CScene *scene, CUserDataManager *user_data, int chara_type, int edit_mode) {
    CActionChara *parts[6];
    int           texture = image_block;

    for (int character_index = 0; character_index < 6; ++character_index) {
        parts[character_index] = (CActionChara *) scene->GetCharacter(character_index);

        if (parts[character_index] == NULL) {
            return 0;
        }

        parts[character_index]->Initialize(NULL);
    }

    if (chara_type == USER_CHARA_MAX) {
        char path[32];
        char model_name[32];
        GetCharaMemAllocPtr(memory, stacks, 0, edit_mode);
        parts[0]->Initialize(stacks);
        GetMainCharaModelName(0, model_name, edit_mode);

        if (edit_mode != 0) {
            sprintf(path, "chara/%s", model_name);
            LoadFile(path, read_buffer, NULL);
        } else {
            sprintf(path, "mainchr/%s", model_name);
            LoadFile(path, read_buffer, NULL);
        }

        parts[0]->accume_effect = &AccumulateEffect;
        parts[0]->LoadPack((unsigned int *) read_buffer, "info.cfg", stacks, stacks, stacks, texture, NULL);
        parts[0]->SetPosition(0.0f, 0.0f, 200.0f);
        parts[0]->texture_block = texture;
        CGameDataUsed *equip = user_data->GetCharaDataPtr(chara_type)->equip;
        char          *item_path;
        LoadFile(GetItemFilePath(equip[4].item_no, 0), read_buffer, NULL);
        parts[0]->LoadSkin((unsigned int *) read_buffer, "info.cfg", "", &stacks[1], texture);

        if (!edit_mode) {
            if (equip[0].item_no > 0) {
                item_path = GetItemFilePath(equip[0].item_no, 0);
                parts[1]->Initialize(NULL);
                LoadFile(item_path, read_buffer, NULL);
                parts[1]->LoadPack((unsigned int *) read_buffer, "info.cfg", &stacks[2], &stacks[2], &stacks[2], texture, parts[0]);

                if (!parts[0]->SetRef(parts[1], "ef00")) {
                    printf("err wep1\n");
                }
            }

            if (equip[1].item_no > 0) {
                item_path = GetItemFilePath(equip[1].item_no, 0);
                parts[2]->Initialize(NULL);
                LoadFile(item_path, read_buffer, NULL);
                parts[2]->LoadPack((unsigned int *) read_buffer, "info.cfg", &stacks[3], &stacks[3], &stacks[3], texture, parts[0]);

                if (!parts[0]->SetRef(parts[2], "gun_hand")) {
                    printf("err wep1\n");
                }
            }

            SetSwordBlurEffect(parts[0], &stacks[2], chara_type);
        }

        item_path = GetItemFilePath(equip[2].item_no, 0);
        parts[3]->Initialize(NULL);
        LoadFile(item_path, read_buffer, NULL);
        parts[3]->LoadPack((unsigned int *) read_buffer, "info.cfg", &stacks[4], &stacks[4], &stacks[4], texture, parts[0]);

        if (!parts[0]->SetRef(parts[3], "hat")) {
            printf("err wep1\n");
        }

        LoadFile(GetItemFilePath(equip[3].item_no, 0), read_buffer, NULL);
        parts[0]->LoadSkin((unsigned int *) read_buffer, "info.cfg", "", &stacks[5], texture);

        if (!edit_mode) {
            int file_size;
            LoadFile("mainchr/c01.stb", read_buffer, &file_size);
            parts[0]->LoadActionFile((char *) read_buffer, file_size, &stacks[6]);
            parts[0]->InitScript();
        }

        SetupUnitMan(scene, user_data, 0, NULL);
        parts[0]->chara_type = ACTION_CHARA_MAX;
        parts[0]->move_type = ACTION_MOVE_HUMAN;
    }

    if (chara_type == USER_CHARA_MONICA) {
        char path[32];
        char model_name[32];
        GetCharaMemAllocPtr(memory, stacks, 0, edit_mode);
        parts[0]->Initialize(stacks);
        GetMainCharaModelName(1, model_name, edit_mode);

        if (edit_mode != 0) {
            sprintf(path, "chara/%s", model_name);
            LoadFile(path, read_buffer, NULL);
        } else {
            sprintf(path, "mainchr/%s", model_name);
            LoadFile(path, read_buffer, NULL);
        }

        parts[0]->accume_effect = &AccumulateEffect;
        parts[0]->LoadPack((unsigned int *) read_buffer, "info.cfg", stacks, stacks, stacks, texture, NULL);
        parts[0]->SetPosition(0.0f, 0.0f, 200.0f);
        parts[0]->texture_block = texture;
        CGameDataUsed *equip = user_data->GetCharaDataPtr(chara_type)->equip;
        char          *item_path;
        LoadFile(GetItemFilePath(equip[4].item_no, 0), read_buffer, NULL);
        parts[0]->LoadSkin((unsigned int *) read_buffer, "info.cfg", "", &stacks[1], texture);

        if (!edit_mode) {
            item_path = GetItemFilePath(equip[0].item_no, 0);
            parts[1]->Initialize(NULL);
            LoadFile(item_path, read_buffer, NULL);
            parts[1]->LoadPack((unsigned int *) read_buffer, "info.cfg", &stacks[2], &stacks[2], &stacks[2], texture, parts[0]);

            if (!parts[0]->SetRef(parts[1], "sword_hand")) {
                printf("err wep1\n");
            }

            SetSwordBlurEffect(parts[0], &stacks[2], chara_type);
        }

        item_path = GetItemFilePath(equip[1].item_no, 0);
        parts[2]->Initialize(NULL);
        LoadFile(item_path, read_buffer, NULL);
        parts[2]->LoadPack((unsigned int *) read_buffer, "info.cfg", &stacks[3], &stacks[3], &stacks[3], texture, parts[0]);

        if (!parts[0]->SetRef(parts[2], "wr")) {
            printf("err wep1\n");
        }

        item_path = GetItemFilePath(equip[2].item_no, 0);
        parts[3]->Initialize(NULL);
        LoadFile(item_path, read_buffer, NULL);
        parts[3]->LoadPack((unsigned int *) read_buffer, "info.cfg", &stacks[4], &stacks[4], &stacks[4], texture, parts[0]);

        if (!parts[0]->SetRef(parts[3], "ac")) {
            printf("err wep1\n");
        }

        LoadFile(GetItemFilePath(equip[3].item_no, 0), read_buffer, NULL);
        parts[0]->LoadSkin((unsigned int *) read_buffer, "info.cfg", "", &stacks[5], texture);

        if (!edit_mode) {
            int file_size;
            LoadFile("mainchr/c02.stb", read_buffer, &file_size);
            parts[0]->LoadActionFile((char *) read_buffer, file_size, &stacks[6]);
            parts[0]->InitScript();
        }

        SetupUnitMan(scene, user_data, 1, NULL);
        parts[0]->chara_type = ACTION_CHARA_MONICA;
        parts[0]->move_type = ACTION_MOVE_HUMAN;
    }

    if (chara_type == USER_CHARA_ROBO) {
        char path[64];
        GetCharaMemAllocPtr(memory, stacks, 2, edit_mode);
        ROBO_INFO_DATA *robo_info = GetRoboPartsInfo(user_data);
        parts[0]->Initialize(NULL);
        sprintf(path, "dungeon/robo/%s.chr", robo_info->model_name[0]);
        LoadFile(path, read_buffer, NULL);
        parts[0]->LoadPack((unsigned int *) read_buffer, "info.cfg", stacks, stacks, stacks, texture, NULL);
        parts[0]->texture_block = texture;
        SetupPartStack part_stack = {
            {0, 1, 2, 2, 3}
        };

        for (int i = 1; i < 5; ++i) {
            parts[i]->Initialize(NULL);

            if (i != 3) {
                sprintf(path, "dungeon/robo/%s.chr", robo_info->model_name[i]);
            } else {
                sprintf(path, "dungeon/robo/%s", robo_info->model_name[i]);
            }

            LoadFile(path, read_buffer, NULL);
            parts[i]->LoadPack((unsigned int *) read_buffer, "info.cfg", &stacks[part_stack.stacks[i]],
                               &stacks[part_stack.stacks[i]], &stacks[part_stack.stacks[i]], texture, parts[0]);

            if (i == 1) {
                SetSwordBlurEffect(parts[0], &stacks[part_stack.stacks[i]], chara_type);
            }
        }

        CActionChara *part = parts[5];
        part->Initialize(NULL);
        LoadFile(robo_info->hat_file, read_buffer, NULL);
        part->LoadPack((unsigned int *) read_buffer, "info.cfg", &stacks[2], &stacks[2], &stacks[2], texture, parts[0]);
        SetupUnitMan(scene, user_data, 2, robo_info);
        int file_size;
        LoadFile("dungeon/act_script/robo.stb", read_buffer, &file_size);
        parts[0]->LoadActionFile((char *) read_buffer, file_size, &stacks[4]);
        parts[0]->InitScript();
        parts[0]->move_type = robo_info->move_type;
        parts[0]->attack_type = robo_info->attack_type;
        parts[0]->chara_type = ACTION_CHARA_ROBO;
    }

    if (chara_type == USER_CHARA_MONSTER) {
        char monster_path[64];
        char monster_info[64];
        char monster_script[64];
        char monster_model[32];
        int  monster_id = user_data->monster_id;
        GetCharaMemAllocPtr(memory, stacks, 3, edit_mode);
        GetMonsterModelFile(monster_id, 0, monster_model);
        sprintf(monster_path, "dungeon/monster/%s", monster_model);
        GetMonsterModelFile(monster_id, 3, monster_info);
        GetMonsterModelFile(monster_id, 2, monster_model);
        sprintf(monster_script, "dungeon/act_script/%s", monster_model);
        LoadFile(monster_path, read_buffer, NULL);
        parts[0]->Initialize(NULL);
        parts[0]->LoadPack((unsigned int *) read_buffer, monster_info, stacks, stacks, stacks, texture, NULL);
        parts[0]->SetPosition(0.0f, 0.0f, 0.0f);
        parts[0]->texture_block = texture;
        SetupUnitMan(scene, user_data, 3, NULL);
        int file_size;
        LoadFile(monster_script, read_buffer, &file_size);
        parts[0]->LoadActionFile((char *) read_buffer, file_size, &stacks[5]);
        parts[0]->InitScript();
        parts[0]->chara_type = ACTION_CHARA_MAX;
        parts[0]->move_type = ACTION_MOVE_MONSTER;
    }

    int i = 0;

    do {
        printf("[%d]STACK %d/%d\n", i, stacks[i].stack_used, stacks[i].stack_size);
        ++i;
    } while (i < 7);

    return 1;
}

int GetCharaMemAllocSize() {
    int maximum = 0;

    for (int row = 0; row < 4; ++row) {
        int size = 0;

        for (int column = 0; column < 7; ++column) {
            size += mem_table[row][column];
        }

        if (size > maximum) {
            maximum = size;
        }
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

            if (edit_mode != 0) {
                row = 2;
            }

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
    int index;
    int size;

    for (index = 0; index < count; index++) {
        size = mem_table[row][index];

        if (size < 0) {
            break;
        }

        u_long128 *buffer = memory->stAllocTest(size);

        if (buffer == NULL) {
            return 0;
        }

        stacks[index].stSetBuffer(buffer, size);
        stacks[index].stack_used = 0;
        stacks[index].lock = 0;
        memory->stAlloc64(size);
    }

    return 1;
}

void SetupUnitMan(CScene *scene, CUserDataManager *user_data, int unit, ROBO_INFO_DATA *robo) {
    CCharacter2 *leader;
    CCharacter2 *character;
    int          slot;

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

/**
 *
 * Attaches Max’s equipped parts and sets his action character type.
 *
 */
int SetupMints(CScene *scene, CUserDataManager *user_data) {
    CGameDataUsed *equip = user_data->GetCharaDataPtr(USER_CHARA_MAX)->equip;
    CActionChara  *characters[5];

    for (int slot = 0; slot < 5; slot++) {
        characters[slot] = (CActionChara *) scene->GetCharacter(slot);

        if (characters[slot] != NULL) {
            characters[slot]->ResetParent();
        }
    }

    SetupNameTable4 attach_names = {
        {"ef00", "gun_hand", "hat", ""}
    };
    SetupNameTable3 part_names = {
        {"sword", "shot", "hat"}
    };
    int part = 0;

    if (characters[0] != NULL) {
        strcpy(characters[0]->name, "body");
        part = 0;
    }

    for (part = 0; part < 3; part++, equip++) {
        if (0 < equip->item_no) {
            if (characters[part + 1] != NULL) {
                char *attach_name = attach_names.names[part];

                if (characters[0]->SetRef(characters[part + 1], attach_name) == 0) {
                    printf("setref failed : %s\n", attach_name);
                } else {
                    strcpy(characters[part + 1]->name, part_names.names[part]);
                    characters[part + 1]->CopyOutLine(characters[0]);
                }
            }
        }
    }

    characters[0]->move_type = 0;
    characters[0]->attack_type = 0;
    characters[0]->chara_type = 0;
    return 1;
}

/**
 *
 * Attaches Monica’s equipped parts and sets her action character type.
 *
 */
int SetupMonica(CScene *scene, CUserDataManager *user_data) {
    CGameDataUsed *equip = user_data->GetCharaDataPtr(USER_CHARA_MONICA)->equip;
    CActionChara  *characters[5];

    for (int slot = 0; slot < 5; slot++) {
        characters[slot] = (CActionChara *) scene->GetCharacter(slot);

        if (characters[slot] != NULL) {
            characters[slot]->ResetParent();
        }
    }

    SetupNameTable3 attach_names = {
        {"sword_hand", "wr", "ac"}
    };
    SetupNameTable3 part_names = {
        {"sword", "shot", "hat"}
    };
    int part = 0;

    if (characters[0] != NULL) {
        strcpy(characters[0]->name, "body");
        part = 0;
    }

    for (part = 0; part < 3; part++, equip++) {
        if (0 < equip->item_no) {
            if (characters[part + 1] != NULL) {
                char *attach_name = attach_names.names[part];

                if (characters[0]->SetRef(characters[part + 1], attach_name) == 0) {
                    printf("setref failed : %s\n", attach_name);
                } else {
                    strcpy(characters[part + 1]->name, part_names.names[part]);
                    characters[part + 1]->CopyOutLine(characters[0]);
                }
            }
        }
    }

    characters[0]->move_type = 0;
    characters[0]->chara_type = ACTION_CHARA_MONICA;
    return 1;
}

/**
 *
 * Assembles the ridepod character parts and configures its equipped joints.
 *
 */
static int SetupRobo(CScene *scene, CUserDataManager *user_data, ROBO_INFO_DATA *robo_info) {
    CActionChara  *parts[6];
    char           arm_joint[64];
    char           body_joint[64];
    CGameDataUsed *arm_part;
    user_data->robo_data.parts[1].GetRoboJointName(arm_joint);
    arm_part = &user_data->robo_data.parts[0];
    arm_part->GetRoboJointName(body_joint);
    int leg_type = user_data->robo_data.parts[3].GetRoboInfoType();
    int arm_type = arm_part->GetRoboInfoType();

    for (int i = 0; i < 6; ++i) {
        parts[i] = (CActionChara *) scene->GetCharacter(i);

        if (parts[i] == NULL) {
            return 0;
        }
    }

    for (int i = 0; i < 6; ++i) {
        parts[i]->ResetParent();
    }

    SetupNameTable6 joint_names = {
        {"body%d", "spine", "joint2", "joint1", "hat", NULL}
    };

    for (int i = 0; i < 5; ++i) {
        if (i == 0) {
            parts[0]->SetRef(parts[i + 1], body_joint);
        } else {
            if (!parts[0]->SetRef(parts[i + 1], joint_names.names[i])) {
                printf(" refer failed  :  %s\n", joint_names.names[i]);
            }
        }

        parts[i + 1]->CopyOutLine(parts[0]);
    }

    strcpy(parts[0]->name, "leg");
    strcpy(parts[1]->name, "arm");
    strcpy(parts[2]->name, "body");
    strcpy(parts[3]->name, "mints");
    strcpy(parts[4]->name, "bpack");
    strcpy(parts[5]->name, "cap");

    if (robo_info == NULL) {
        return 0;
    }

    mgCFrame *arm = parts[0]->SearchObject("ude");
    mgCFrame *joint = parts[0]->SearchObject(arm_joint);

    if (arm == NULL) {
        printf("NOT ARM!\n");
    }

    if (joint == NULL) {
        printf("NOT MAT!\n");
    }

    if (arm == NULL || joint == NULL) {
        return 0;
    }

    sceVu0FMATRIX matrix;
    sceVu0CopyMatrix(matrix, joint->trans_matrix);
    arm->SetTransMatrix(matrix);
    parts[0]->move_type = leg_type;
    parts[0]->attack_type = arm_type;
    printf("***************** %s,%s\n", body_joint, arm_joint);
    parts[0]->chara_type = 2;
    return 1;
}

ROBO_INFO_DATA *GetRoboPartsInfo(CUserDataManager *user_data) {
    static char    r_robo_pname[4][16];
    int            i;
    ROBO_DATA     *parts = &user_data->robo_data;
    CGameData     *game_data = GetGameDataPt();
    SetupPartOrder part_order = {
        {3, 0, 1, 2}
    };
    CDataRoboPart *part_info[4];

    for (i = 0; i < 4; ++i) {
        part_info[i] = GetRoboPartInfoData(parts->parts[part_order.parts[i]].item_no);
        r_robo_pname[i][0] = 0;

        if (part_info[i] != NULL) {
            strcpy(r_robo_pname[i], GetItemFileName(parts->parts[part_order.parts[i]].item_no, 0));
        }
    }

    robo_dat.model_name[ROBO_MODEL_LEG] = r_robo_pname[0];
    robo_dat.model_name[ROBO_MODEL_ARM] = r_robo_pname[1];
    robo_dat.model_name[ROBO_MODEL_BODY] = r_robo_pname[2];
    robo_dat.model_name[ROBO_MODEL_BPACK] = r_robo_pname[3];
    CHARA_DATA  *max_data = user_data->GetCharaDataPtr(USER_CHARA_MAX);
    int          costume = max_data->equip[4].item_no;
    static char  fname[64];
    static char *fname_tbl[6] = {
        "mints0%da.chr", "mints0%db.chr", "mints0%dc.chr", "mints0%dd.chr", "mints0%de.chr", "mints0%df.chr"};
    static char *fname_tbl2[6] = {
        "mints%da.chr", "mints%db.chr", "mints%dc.chr", "mints%dd.chr", "mints%de.chr", "mints%df.chr"};
    costume -= game_data->GetDataTypeStartListNo(5);

    if (part_info[2] != NULL) {
        int body_type = part_info[2]->offset_no;

        if (GetSaveData()->GetBitFlag(799)) {
            body_type += 10;
        }

        if (body_type < 10) {
            sprintf(fname, fname_tbl[costume], body_type);
        } else {
            sprintf(fname, fname_tbl2[costume], body_type);
        }
    }

    robo_dat.arm_name = NULL;
    robo_dat.model_name[ROBO_MODEL_MINTS] = fname;

    if (part_info[2] != NULL) {
        robo_dat.arm_name = robo_info_body[part_info[2]->offset_no - 1].arm_name;
    }

    robo_dat.move_type = 0;

    if (part_info[0] != NULL) {
        robo_dat.move_type = user_data->robo_data.parts[3].GetRoboInfoType();
    }

    robo_dat.attack_type = 0;

    if (part_info[1] != NULL) {
        robo_dat.attack_type = user_data->robo_data.parts[0].GetRoboInfoType();
    }

    max_data = user_data->GetCharaDataPtr(USER_CHARA_MAX);
    robo_dat.hat_file = GetItemFilePath(max_data->equip[2].item_no, 0);
    return &robo_dat;
}

/**
 *
 * Clears character attachments and selects monster movement.
 *
 */
int SetupMonster(CScene *scene, CUserDataManager *user_data) {
    CActionChara *characters[5];

    for (int slot = 0; slot < 5; slot++) {
        characters[slot] = (CActionChara *) scene->GetCharacter(slot);

        if (characters[slot] != NULL) {
            characters[slot]->ResetParent();
        }
    }

    if (characters[0] != NULL) {
        strcpy(characters[0]->name, "body");
    }

    characters[0]->move_type = 3;
    characters[0]->chara_type = ACTION_CHARA_MONSTER;
    return 1;
}

/**
 *
 * Stores the body model and arm joint names for each ridepod body type.
 *
 */
ROBO_INFO_BODY robo_info_body[11] = {
    {"body01.chr", "arm1"},
    {"body02.chr", "arm2"},
    {"body02.chr", "arm2"},
    {"body02.chr", "arm2"},
    {"body02.chr", "arm2"},
    {"body02.chr", "arm2"},
    {"body02.chr", "arm2"},
    {"body02.chr", "arm2"},
    {"body02.chr", "arm2"},
    {"body02.chr", "arm2"},
    {"body02.chr", "arm2"}
};

/**
 *
 * Stores the model files and behaviour of the equipped ridepod.
 *
 */
ROBO_INFO_DATA robo_dat;
