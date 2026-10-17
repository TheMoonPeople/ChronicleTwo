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
#include "gamedata.hpp"
#include "mainloop.hpp"
#include "maintex.hpp"
#include "mapselect.hpp"
#include "menuchr.hpp"
#include "menumain.hpp"
#include "mg_camera.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
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
 * Memory stack that each ridepod part loads into, as a local copy of a constant table.
 *
 */
struct SetupPartStack {
    int stack_no[5]; /**< Index into the stacks array for each ROBO_MODEL_SLOT. */
};

// Retail budgets were counted at PS2 pointer widths; SetActionScript's stack and call allocations grow on PC. Zero on PS2.
#define CHARA_SCRIPT_RUNTIME_DELTA (((sizeof(RS_STACKDATA) - 8) * 0x80 + (sizeof(RS_CALLDATA) - 12) * 0x200) / 16)

#ifdef PORT
#include "port_memory_budget.hpp"

static constexpr int CharaMemModelDelta(int row, int col) {
    if ((row == CHARA_MEM_LAYOUT_HUMAN && col <= 1) || (row == CHARA_MEM_LAYOUT_ROBO && col <= 2) ||
        (row == CHARA_MEM_LAYOUT_EDIT && col == 0) || (row == CHARA_MEM_LAYOUT_MONSTER && col == 0)) {
        return CHARA_MODEL_LOAD_DELTA;
    }
    return 0;
}

#define MEM_TBL(v, row, col) ((v) + CharaMemModelDelta(row, col))
#else
#define MEM_TBL(v, row, col) (v)
#endif

/**
 *
 * Sizes of the memory stacks of each main character layout, indexed by CHARA_MEM_SIZE row and stack.
 *
 */
static int mem_table[CHARA_MEM_LAYOUT_NUM][CHARA_MEM_STACK_NUM] = {
    {MEM_TBL(68500, CHARA_MEM_LAYOUT_HUMAN, 0),   MEM_TBL(40000, CHARA_MEM_LAYOUT_HUMAN, 1),   7000,  4650,  3000,
     9900 + CHARA_SCRIPT_RUNTIME_DELTA,            4500 + CHARA_SCRIPT_RUNTIME_DELTA},
    {MEM_TBL(30000, CHARA_MEM_LAYOUT_ROBO, 0),    MEM_TBL(30000, CHARA_MEM_LAYOUT_ROBO, 1),    MEM_TBL(60000, CHARA_MEM_LAYOUT_ROBO, 2), 10000,
     10000 + CHARA_SCRIPT_RUNTIME_DELTA,          0,                                             0},
    {MEM_TBL(75000, CHARA_MEM_LAYOUT_EDIT, 0),    40000,                                         7000,  4650,  3000,  9900, 0},
    {MEM_TBL(120000, CHARA_MEM_LAYOUT_MONSTER, 0), 0,                                             0,     0,     0,     5500, 0}
};

#ifdef PORT
int PortGetCharaMemTableEntry(int layout_row, int stack_index) {
    if (layout_row < 0 || layout_row >= CHARA_MEM_LAYOUT_NUM || stack_index < 0 || stack_index >= CHARA_MEM_STACK_NUM) {
        return -1;
    }
    return mem_table[layout_row][stack_index];
}
#endif

/**
 *
 * Record of the ridepod's files and behaviour that GetRoboPartsInfo fills and returns.
 *
 */
static ROBO_INFO_DATA robo_dat;
static int            SetupMints(CScene *scene, CUserDataManager *user_data);
static int            SetupMonica(CScene *scene, CUserDataManager *user_data);
static int            SetupRobo(CScene *scene, CUserDataManager *user_data, ROBO_INFO_DATA *robo_info);
static int            SetupMonster(CScene *scene, CUserDataManager *user_data);

/**
 *
 * Four frame names, as a local copy of a constant table.
 *
 */
struct SetupNameTable4 {
    char *names[4]; /**< Names. */
};

/**
 *
 * Three frame or part names, as a local copy of a constant table.
 *
 */
struct SetupNameTable3 {
    char *names[3]; /**< Names. */
};

/**
 *
 * Six frame names, as a local copy of a constant table.
 *
 */
struct SetupNameTable6 {
    char *names[6]; /**< Names. */
};

/**
 *
 * Slots of ROBO_DATA::parts that give the leg, arm, body and back-pack models, as a local copy of a constant table.
 *
 */
struct SetupPartOrder {
    int robo_slot[4]; /**< ROBO_DATA::parts slot of each model. */
};

void GetCharacterSnd(CUserDataManager *user_data, int unit, char *path) {
    CHARA_DATA    *chara = user_data->GetCharaDataPtr(unit);
    CGameDataUsed *equip = chara->equip;

    if (equip != NULL) {
        if (unit == USER_CHARA_MAX) {
            int item_no = equip[CHARA_EQUIP_SUB].item_no;

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

        if (unit == USER_CHARA_MONICA) {
            sprintf(path, "snd2/chara/CH_020.snd");
        }

        if (unit == USER_CHARA_ROBO) {
            char name[0x40];
            user_data->robo_data.parts[ROBO_PART_ARM].GetRoboSoundFileName(name);
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
            return false;
        }

        parts[character_index]->Initialize(NULL);
    }

    if (chara_type == USER_CHARA_MAX) {
        char path[32];
        char model_name[32];
        GetCharaMemAllocPtr(memory, stacks, USER_CHARA_MAX, edit_mode);
        parts[0]->Initialize(stacks);
        GetMainCharaModelName(USER_CHARA_MAX, model_name, edit_mode);

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
        LoadFile(GetItemFilePath(equip[CHARA_EQUIP_CLOTHES].item_no, 0), read_buffer, NULL);
        parts[0]->LoadSkin((unsigned int *) read_buffer, "info.cfg", "", &stacks[1], texture);

        if (!edit_mode) {
            if (equip[CHARA_EQUIP_MELEE].item_no > 0) {
                item_path = GetItemFilePath(equip[CHARA_EQUIP_MELEE].item_no, 0);
                parts[1]->Initialize(NULL);
                LoadFile(item_path, read_buffer, NULL);
                parts[1]->LoadPack((unsigned int *) read_buffer, "info.cfg", &stacks[2], &stacks[2], &stacks[2], texture, parts[0]);

                if (!parts[0]->SetRef(parts[1], "ef00")) {
                    printf("err wep1\n");
                }
            }

            if (equip[CHARA_EQUIP_SUB].item_no > 0) {
                item_path = GetItemFilePath(equip[CHARA_EQUIP_SUB].item_no, 0);
                parts[2]->Initialize(NULL);
                LoadFile(item_path, read_buffer, NULL);
                parts[2]->LoadPack((unsigned int *) read_buffer, "info.cfg", &stacks[3], &stacks[3], &stacks[3], texture, parts[0]);

                if (!parts[0]->SetRef(parts[2], "gun_hand")) {
                    printf("err wep1\n");
                }
            }

            SetSwordBlurEffect(parts[0], &stacks[2], chara_type);
        }

        item_path = GetItemFilePath(equip[CHARA_EQUIP_HEAD].item_no, 0);
        parts[3]->Initialize(NULL);
        LoadFile(item_path, read_buffer, NULL);
        parts[3]->LoadPack((unsigned int *) read_buffer, "info.cfg", &stacks[4], &stacks[4], &stacks[4], texture, parts[0]);

        if (!parts[0]->SetRef(parts[3], "hat")) {
            printf("err wep1\n");
        }

        LoadFile(GetItemFilePath(equip[CHARA_EQUIP_FEET].item_no, 0), read_buffer, NULL);
        parts[0]->LoadSkin((unsigned int *) read_buffer, "info.cfg", "", &stacks[5], texture);

        if (!edit_mode) {
            int file_size;
            LoadFile("mainchr/c01.stb", read_buffer, &file_size);
            parts[0]->LoadActionFile((char *) read_buffer, file_size, &stacks[6]);
            parts[0]->InitScript();
        }

        SetupUnitMan(scene, user_data, USER_CHARA_MAX, NULL);
        parts[0]->chara_type = ACTION_CHARA_MAX;
        parts[0]->move_type = ACTION_MOVE_HUMAN;
    }

    if (chara_type == USER_CHARA_MONICA) {
        char path[32];
        char model_name[32];
        GetCharaMemAllocPtr(memory, stacks, USER_CHARA_MAX, edit_mode);
        parts[0]->Initialize(stacks);
        GetMainCharaModelName(USER_CHARA_MONICA, model_name, edit_mode);

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
        LoadFile(GetItemFilePath(equip[CHARA_EQUIP_CLOTHES].item_no, 0), read_buffer, NULL);
        parts[0]->LoadSkin((unsigned int *) read_buffer, "info.cfg", "", &stacks[1], texture);

        if (!edit_mode) {
            item_path = GetItemFilePath(equip[CHARA_EQUIP_MELEE].item_no, 0);
            parts[1]->Initialize(NULL);
            LoadFile(item_path, read_buffer, NULL);
            parts[1]->LoadPack((unsigned int *) read_buffer, "info.cfg", &stacks[2], &stacks[2], &stacks[2], texture, parts[0]);

            if (!parts[0]->SetRef(parts[1], "sword_hand")) {
                printf("err wep1\n");
            }

            SetSwordBlurEffect(parts[0], &stacks[2], chara_type);
        }

        item_path = GetItemFilePath(equip[CHARA_EQUIP_SUB].item_no, 0);
        parts[2]->Initialize(NULL);
        LoadFile(item_path, read_buffer, NULL);
        parts[2]->LoadPack((unsigned int *) read_buffer, "info.cfg", &stacks[3], &stacks[3], &stacks[3], texture, parts[0]);

        if (!parts[0]->SetRef(parts[2], "wr")) {
            printf("err wep1\n");
        }

        item_path = GetItemFilePath(equip[CHARA_EQUIP_HEAD].item_no, 0);
        parts[3]->Initialize(NULL);
        LoadFile(item_path, read_buffer, NULL);
        parts[3]->LoadPack((unsigned int *) read_buffer, "info.cfg", &stacks[4], &stacks[4], &stacks[4], texture, parts[0]);

        if (!parts[0]->SetRef(parts[3], "ac")) {
            printf("err wep1\n");
        }

        LoadFile(GetItemFilePath(equip[CHARA_EQUIP_FEET].item_no, 0), read_buffer, NULL);
        parts[0]->LoadSkin((unsigned int *) read_buffer, "info.cfg", "", &stacks[5], texture);

        if (!edit_mode) {
            int file_size;
            LoadFile("mainchr/c02.stb", read_buffer, &file_size);
            parts[0]->LoadActionFile((char *) read_buffer, file_size, &stacks[6]);
            parts[0]->InitScript();
        }

        SetupUnitMan(scene, user_data, USER_CHARA_MONICA, NULL);
        parts[0]->chara_type = ACTION_CHARA_MONICA;
        parts[0]->move_type = ACTION_MOVE_HUMAN;
    }

    if (chara_type == USER_CHARA_ROBO) {
        char path[64];
        GetCharaMemAllocPtr(memory, stacks, USER_CHARA_ROBO, edit_mode);
        ROBO_INFO_DATA *robo_info = GetRoboPartsInfo(user_data);
        parts[0]->Initialize(NULL);
        sprintf(path, "dungeon/robo/%s.chr", robo_info->model_name[ROBO_MODEL_LEG]);
        LoadFile(path, read_buffer, NULL);
        parts[0]->LoadPack((unsigned int *) read_buffer, "info.cfg", stacks, stacks, stacks, texture, NULL);
        parts[0]->texture_block = texture;
        SetupPartStack part_stack = {
            {0, 1, 2, 2, 3}
        };

        for (int i = ROBO_MODEL_ARM; i < ROBO_MODEL_NUM; ++i) {
            parts[i]->Initialize(NULL);

            if (i != ROBO_MODEL_MINTS) {
                sprintf(path, "dungeon/robo/%s.chr", robo_info->model_name[i]);
            } else {
                sprintf(path, "dungeon/robo/%s", robo_info->model_name[i]);
            }

            LoadFile(path, read_buffer, NULL);
            parts[i]->LoadPack((unsigned int *) read_buffer, "info.cfg", &stacks[part_stack.stack_no[i]],
                               &stacks[part_stack.stack_no[i]], &stacks[part_stack.stack_no[i]], texture, parts[0]);

            if (i == ROBO_MODEL_ARM) {
                SetSwordBlurEffect(parts[0], &stacks[part_stack.stack_no[i]], chara_type);
            }
        }

        CActionChara *hat = parts[5];
        hat->Initialize(NULL);
        LoadFile(robo_info->hat_file, read_buffer, NULL);
        hat->LoadPack((unsigned int *) read_buffer, "info.cfg", &stacks[2], &stacks[2], &stacks[2], texture, parts[0]);
        SetupUnitMan(scene, user_data, USER_CHARA_ROBO, robo_info);
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
        char monster_config[64];
        char monster_script[64];
        char monster_model[32];
        int  monster_id = user_data->monster_id;
        GetCharaMemAllocPtr(memory, stacks, USER_CHARA_MONSTER, edit_mode);
        GetMonsterModelFile(monster_id, MONSTER_FILE_MODEL, monster_model);
        sprintf(monster_path, "dungeon/monster/%s", monster_model);
        GetMonsterModelFile(monster_id, MONSTER_FILE_CONFIG, monster_config);
        GetMonsterModelFile(monster_id, MONSTER_FILE_SCRIPT, monster_model);
        sprintf(monster_script, "dungeon/act_script/%s", monster_model);
        LoadFile(monster_path, read_buffer, NULL);
        parts[0]->Initialize(NULL);
        parts[0]->LoadPack((unsigned int *) read_buffer, monster_config, stacks, stacks, stacks, texture, NULL);
        parts[0]->SetPosition(0.0f, 0.0f, 0.0f);
        parts[0]->texture_block = texture;
        SetupUnitMan(scene, user_data, USER_CHARA_MONSTER, NULL);
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
    } while (i < CHARA_MEM_STACK_NUM);

    return true;
}

int GetCharaMemAllocSize() {
    int maximum = 0;

    for (int row = 0; row < CHARA_MEM_LAYOUT_NUM; ++row) {
        int size = 0;

        for (int column = 0; column < CHARA_MEM_STACK_NUM; ++column) {
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
        case USER_CHARA_MAX:
        case USER_CHARA_MONICA:
            row = CHARA_MEM_LAYOUT_HUMAN;
            count = CHARA_MEM_STACK_NUM;

            if (edit_mode != 0) {
                row = CHARA_MEM_LAYOUT_EDIT;
            }

            break;
        case USER_CHARA_ROBO:
            row = CHARA_MEM_LAYOUT_ROBO;
            count = 5;
            break;
        case USER_CHARA_MONSTER:
            row = CHARA_MEM_LAYOUT_HUMAN;
            count = 6;
            break;
    }

    memory->stack_used = 0;
    memory->lock = false;
    int index;
    int size;

    for (index = 0; index < count; index++) {
        size = mem_table[row][index];

        if (size < 0) {
            break;
        }

        u_long128 *buffer = memory->stAllocTest(size);

        if (buffer == NULL) {
            return false;
        }

        stacks[index].stSetBuffer(buffer, size);
        stacks[index].stack_used = 0;
        stacks[index].lock = false;
        memory->stAlloc64(size);
    }

    return true;
}

void SetupUnitMan(CScene *scene, CUserDataManager *user_data, int unit, ROBO_INFO_DATA *robo_info) {
    CCharacter2 *leader;
    CCharacter2 *character;
    int          slot;

    switch (unit) {
        case USER_CHARA_MAX:
            SetupMints(scene, user_data);
            break;
        case USER_CHARA_MONICA:
            SetupMonica(scene, user_data);
            break;
        case USER_CHARA_ROBO:
            SetupRobo(scene, user_data, robo_info);
            break;
        case USER_CHARA_MONSTER:
            SetupMonster(scene, user_data);
            break;
    }

    leader = scene->GetCharacter(0);

    if (leader != NULL) {
        leader->sound_info.loop_se = &scene->loop_se;
    }

    slot = 0;

    if (unit == USER_CHARA_ROBO) {
        slot = ROBO_MODEL_MINTS;
    }

    character = scene->GetCharacter(slot);

    if ((character != NULL) && (GetSaveData()->GetBitCtrl() & MENU_DEBUG_BIT_CTRL_ATRA_OFF)) {
        AtraMiriaOnOff(unit, character, 0);
    }
}

/**
 *
 * Attaches Max’s equipped parts and sets his action character type.
 *
 */
static int SetupMints(CScene *scene, CUserDataManager *user_data) {
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
    int part;

    if (characters[0] != NULL) {
        strcpy(characters[0]->name, "body");
    }

    for (part = 0; part < 3; part++, equip++) {
        if (0 < equip->item_no) {
            if (characters[part + 1] != NULL) {
                char *attach_name = attach_names.names[part];

                if (!characters[0]->SetRef(characters[part + 1], attach_name)) {
                    printf("setref failed : %s\n", attach_name);
                } else {
                    strcpy(characters[part + 1]->name, part_names.names[part]);
                    characters[part + 1]->CopyOutLine(characters[0]);
                }
            }
        }
    }

    characters[0]->move_type = ACTION_MOVE_HUMAN;
    characters[0]->attack_type = 0;
    characters[0]->chara_type = ACTION_CHARA_MAX;
    return true;
}

/**
 *
 * Attaches Monica’s equipped parts and sets her action character type.
 *
 */
static int SetupMonica(CScene *scene, CUserDataManager *user_data) {
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
    int part;

    if (characters[0] != NULL) {
        strcpy(characters[0]->name, "body");
    }

    for (part = 0; part < 3; part++, equip++) {
        if (0 < equip->item_no) {
            if (characters[part + 1] != NULL) {
                char *attach_name = attach_names.names[part];

                if (!characters[0]->SetRef(characters[part + 1], attach_name)) {
                    printf("setref failed : %s\n", attach_name);
                } else {
                    strcpy(characters[part + 1]->name, part_names.names[part]);
                    characters[part + 1]->CopyOutLine(characters[0]);
                }
            }
        }
    }

    characters[0]->move_type = ACTION_MOVE_HUMAN;
    characters[0]->chara_type = ACTION_CHARA_MONICA;
    return true;
}

/**
 *
 * Assembles the ridepod character parts and configures its equipped joints.
 *
 */
static int SetupRobo(CScene *scene, CUserDataManager *user_data, ROBO_INFO_DATA *robo_info) {
    CActionChara  *parts[6];
    char           body_arm_frame[64];
    char           arm_attach_frame[64];
    CGameDataUsed *arm_item;
    user_data->robo_data.parts[ROBO_PART_BODY].GetRoboJointName(body_arm_frame);
    arm_item = &user_data->robo_data.parts[ROBO_PART_ARM];
    arm_item->GetRoboJointName(arm_attach_frame);
    int leg_type = user_data->robo_data.parts[ROBO_PART_LEG].GetRoboInfoType();
    int arm_type = arm_item->GetRoboInfoType();

    for (int i = 0; i < 6; ++i) {
        parts[i] = (CActionChara *) scene->GetCharacter(i);

        if (parts[i] == NULL) {
            return false;
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
            parts[0]->SetRef(parts[i + 1], arm_attach_frame);
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
        return false;
    }

    mgCFrame *arm_frame = parts[0]->SearchObject("ude");
    mgCFrame *mount_frame = parts[0]->SearchObject(body_arm_frame);

    if (arm_frame == NULL) {
        printf("NOT ARM!\n");
    }

    if (mount_frame == NULL) {
        printf("NOT MAT!\n");
    }

    if (arm_frame == NULL || mount_frame == NULL) {
        return false;
    }

    sceVu0FMATRIX matrix;
    sceVu0CopyMatrix(matrix, mount_frame->trans_matrix);
    arm_frame->SetTransMatrix(matrix);
    parts[0]->move_type = leg_type;
    parts[0]->attack_type = arm_type;
    printf("***************** %s,%s\n", arm_attach_frame, body_arm_frame);
    parts[0]->chara_type = ACTION_CHARA_ROBO;
    return true;
}

ROBO_INFO_DATA *GetRoboPartsInfo(CUserDataManager *user_data) {
    static char    r_robo_pname[4][16];
    int            i;
    ROBO_DATA     *parts = &user_data->robo_data;
    CGameData     *game_data = GetGameDataPt();
    SetupPartOrder part_order = {
        {ROBO_PART_LEG, ROBO_PART_ARM, ROBO_PART_BODY, ROBO_PART_PACK}
    };
    CDataRoboPart *part_info[4];

    for (i = 0; i < 4; ++i) {
        part_info[i] = GetRoboPartInfoData(parts->parts[part_order.robo_slot[i]].item_no);
        r_robo_pname[i][0] = '\0';

        if (part_info[i] != NULL) {
            strcpy(r_robo_pname[i], GetItemFileName(parts->parts[part_order.robo_slot[i]].item_no, 0));
        }
    }

    robo_dat.model_name[ROBO_MODEL_LEG] = r_robo_pname[0];
    robo_dat.model_name[ROBO_MODEL_ARM] = r_robo_pname[1];
    robo_dat.model_name[ROBO_MODEL_BODY] = r_robo_pname[2];
    robo_dat.model_name[ROBO_MODEL_BPACK] = r_robo_pname[3];
    CHARA_DATA  *max_data = user_data->GetCharaDataPtr(USER_CHARA_MAX);
    int          costume = max_data->equip[CHARA_EQUIP_CLOTHES].item_no;
    static char  fname[64];
    static char *fname_tbl[6] = {
        "mints0%da.chr", "mints0%db.chr", "mints0%dc.chr", "mints0%dd.chr", "mints0%de.chr", "mints0%df.chr"};
    static char *fname_tbl2[6] = {
        "mints%da.chr", "mints%db.chr", "mints%dc.chr", "mints%dd.chr", "mints%de.chr", "mints%df.chr"};
    costume -= game_data->GetDataTypeStartListNo(ITEM_DATA_MAX_CLOTHES);

    if (part_info[2] != NULL) {
        int body_type = part_info[2]->offset_no;

        if (GetSaveData()->GetBitFlag(SAVE_FLAG_COSTUME_UNLOCK)) {
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
        robo_dat.move_type = user_data->robo_data.parts[ROBO_PART_LEG].GetRoboInfoType();
    }

    robo_dat.attack_type = 0;

    if (part_info[1] != NULL) {
        robo_dat.attack_type = user_data->robo_data.parts[ROBO_PART_ARM].GetRoboInfoType();
    }

    max_data = user_data->GetCharaDataPtr(USER_CHARA_MAX);
    robo_dat.hat_file = GetItemFilePath(max_data->equip[CHARA_EQUIP_HEAD].item_no, 0);
    return &robo_dat;
}

/**
 *
 * Clears character attachments and selects monster movement.
 *
 */
static int SetupMonster(CScene *scene, CUserDataManager *user_data) {
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

    characters[0]->move_type = ACTION_MOVE_MONSTER;
    characters[0]->chara_type = ACTION_CHARA_MONSTER;
    return true;
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
