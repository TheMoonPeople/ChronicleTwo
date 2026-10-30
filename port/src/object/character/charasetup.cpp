#include "common.h"

#include <algorithm>
#include <array>
#include <cmath>
#include <cstdio>
#include <cstring>
#include <format>
#include <iterator>
#include <string>

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
#include "log/game_output.hpp"
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
#include "text/bounded.hpp"
#include "userdata.hpp"

std::string dc2::character::ModelAssetPath(std::string_view directory, std::string_view name,
                                           bool add_gltf_extension) {
    std::string path;
    path.reserve(directory.size() + 1 + name.size() + (add_gltf_extension ? 5 : 0));
    path.append(directory);
    path.push_back('/');
    path.append(name);
    if (add_gltf_extension) {
        path.append(".gltf");
    }
    return path;
}

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

/**
 *
 * Sizes of the memory stacks of each main character layout, indexed by CHARA_MEM_SIZE row and stack.
 *
 */
static int mem_table[CHARA_MEM_LAYOUT_NUM][CHARA_MEM_STACK_NUM] = {
    {68500 + 12000,  40000 + 12000, 7000,          4650,  3000,                               9900 + CHARA_SCRIPT_RUNTIME_DELTA, 4500 + CHARA_SCRIPT_RUNTIME_DELTA},
    {30000 + 12000,  30000 + 12000, 60000 + 12000, 10000, 10000 + CHARA_SCRIPT_RUNTIME_DELTA, 0,                                 0                                },
    {75000 + 12000,  40000,         7000,          4650,  3000,                               9900,                              0                                },
    {120000 + 12000, 0,             0,             0,     0,                                  5500,                              0                                }
};

/**
 *
 * Record of the ridepod's files and behaviour that GetRoboPartsInfo fills and returns.
 *
 */
static ROBO_INFO_DATA robo_dat;

namespace {
/**
 * Gives a supplied unit part only within the caller's physical pointer array.
 */
CCharacter2 *UnitPart(std::span<CCharacter2 *const> parts, std::size_t index) {
    return index < parts.size() ? parts[index] : nullptr;
}
} // namespace

static int SetupMints(std::span<CCharacter2 *const> parts_view, CUserDataManager *user_data);
static int SetupMonica(std::span<CCharacter2 *const> parts_view, CUserDataManager *user_data);
static int SetupRobo(std::span<CCharacter2 *const> parts_view, CUserDataManager *user_data, ROBO_INFO_DATA *robo_info);
static int SetupMonster(std::span<CCharacter2 *const> parts_view);

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

int SetupMainUnit(std::span<u8> read_buffer, mgCMemory *memory, mgCMemory *stacks, int image_block,
                  CScene *scene, CUserDataManager *user_data, int chara_type, int edit_mode) {
    CActionChara *parts[6];
    int           texture = image_block;
    if (read_buffer.empty() || scene == nullptr || user_data == nullptr || memory == nullptr || stacks == nullptr) {
        return false;
    }
    auto *loaded_data = reinterpret_cast<u_int *>(read_buffer.data());
    auto  load_file = [&](std::string_view path, int *out_size = nullptr) {
        if (path.empty()) {
            return false;
        }
        std::string file(path);
        return LoadFile(file.data(), read_buffer, out_size) > 0;
    };
    auto load_item = [&](int item_no) {
        const auto path = ItemFilePath(item_no, 0);
        return path && load_file(*path);
    };

    for (int character_index = 0; character_index < 6; ++character_index) {
        parts[character_index] = (CActionChara *) scene->GetCharacter(character_index);

        if (parts[character_index] == nullptr) {
            return false;
        }

        parts[character_index]->Initialize(nullptr);
    }

    if (chara_type == USER_CHARA_MAX) {
        const auto model_name = MainCharaModelName(USER_CHARA_MAX, edit_mode);
        if (!model_name || model_name->empty()) {
            return false;
        }
        GetCharaMemAllocPtr(memory, stacks, USER_CHARA_MAX, edit_mode);
        parts[0]->Initialize(stacks);

        std::string path = dc2::character::ModelAssetPath(edit_mode != 0 ? "chara" : "mainchr", *model_name, false);
        if (!load_file(path)) {
            return false;
        }

        parts[0]->accume_effect = &AccumulateEffect;
        parts[0]->LoadPack(loaded_data, "info", stacks, stacks, stacks, texture, nullptr);
        parts[0]->SetPosition(0.0f, 0.0f, 200.0f);
        parts[0]->texture_block = texture;
        CGameDataUsed *equip = user_data->GetCharaDataPtr(chara_type)->equip;
        if (!load_item(equip[CHARA_EQUIP_CLOTHES].item_no)) {
            return false;
        }
        parts[0]->LoadSkin(loaded_data, "info", "", &stacks[1], texture);

        if (!edit_mode) {
            if (equip[CHARA_EQUIP_MELEE].item_no > 0) {
                parts[1]->Initialize(nullptr);
                if (!load_item(equip[CHARA_EQUIP_MELEE].item_no)) {
                    return false;
                }
                parts[1]->LoadPack(loaded_data, "info", &stacks[2], &stacks[2], &stacks[2], texture, parts[0]);

                if (!parts[0]->SetRef(parts[1], "ef00")) {
                    dc2::log::PrintGame("err wep1\n");
                }
            }

            if (equip[CHARA_EQUIP_SUB].item_no > 0) {
                parts[2]->Initialize(nullptr);
                if (!load_item(equip[CHARA_EQUIP_SUB].item_no)) {
                    return false;
                }
                parts[2]->LoadPack(loaded_data, "info", &stacks[3], &stacks[3], &stacks[3], texture, parts[0]);

                if (!parts[0]->SetRef(parts[2], "gun_hand")) {
                    dc2::log::PrintGame("err wep1\n");
                }
            }

            SetSwordBlurEffect(parts[0], &stacks[2], chara_type);
        }
        parts[3]->Initialize(nullptr);
        if (!load_item(equip[CHARA_EQUIP_HEAD].item_no)) {
            return false;
        }
        parts[3]->LoadPack(loaded_data, "info", &stacks[4], &stacks[4], &stacks[4], texture, parts[0]);

        if (!parts[0]->SetRef(parts[3], "hat")) {
            dc2::log::PrintGame("err wep1\n");
        }

        if (!load_item(equip[CHARA_EQUIP_FEET].item_no)) {
            return false;
        }
        parts[0]->LoadSkin(loaded_data, "info", "", &stacks[5], texture);

        if (!edit_mode) {
            int file_size = {};
            if (!load_file("mainchr/c01.stb", &file_size)) {
                return false;
            }
            parts[0]->LoadActionFile(reinterpret_cast<char *>(read_buffer.data()), file_size, &stacks[6]);
            parts[0]->InitScript();
        }

        SetupUnitMan(scene, user_data, USER_CHARA_MAX, nullptr);
        parts[0]->chara_type = ACTION_CHARA_MAX;
        parts[0]->move_type = ACTION_MOVE_HUMAN;
    }

    if (chara_type == USER_CHARA_MONICA) {
        const auto model_name = MainCharaModelName(USER_CHARA_MONICA, edit_mode);
        if (!model_name || model_name->empty()) {
            return false;
        }
        GetCharaMemAllocPtr(memory, stacks, USER_CHARA_MAX, edit_mode);
        parts[0]->Initialize(stacks);

        std::string path = dc2::character::ModelAssetPath(edit_mode != 0 ? "chara" : "mainchr", *model_name, false);
        if (!load_file(path)) {
            return false;
        }

        parts[0]->accume_effect = &AccumulateEffect;
        parts[0]->LoadPack(loaded_data, "info", stacks, stacks, stacks, texture, nullptr);
        parts[0]->SetPosition(0.0f, 0.0f, 200.0f);
        parts[0]->texture_block = texture;
        CGameDataUsed *equip = user_data->GetCharaDataPtr(chara_type)->equip;
        if (!load_item(equip[CHARA_EQUIP_CLOTHES].item_no)) {
            return false;
        }
        parts[0]->LoadSkin(loaded_data, "info", "", &stacks[1], texture);

        if (!edit_mode) {
            parts[1]->Initialize(nullptr);
            if (!load_item(equip[CHARA_EQUIP_MELEE].item_no)) {
                return false;
            }
            parts[1]->LoadPack(loaded_data, "info", &stacks[2], &stacks[2], &stacks[2], texture, parts[0]);

            if (!parts[0]->SetRef(parts[1], "sword_hand")) {
                dc2::log::PrintGame("err wep1\n");
            }

            SetSwordBlurEffect(parts[0], &stacks[2], chara_type);
        }
        parts[2]->Initialize(nullptr);
        if (!load_item(equip[CHARA_EQUIP_SUB].item_no)) {
            return false;
        }
        parts[2]->LoadPack(loaded_data, "info", &stacks[3], &stacks[3], &stacks[3], texture, parts[0]);

        if (!parts[0]->SetRef(parts[2], "wr")) {
            dc2::log::PrintGame("err wep1\n");
        }
        parts[3]->Initialize(nullptr);
        if (!load_item(equip[CHARA_EQUIP_HEAD].item_no)) {
            return false;
        }
        parts[3]->LoadPack(loaded_data, "info", &stacks[4], &stacks[4], &stacks[4], texture, parts[0]);

        if (!parts[0]->SetRef(parts[3], "ac")) {
            dc2::log::PrintGame("err wep1\n");
        }

        if (!load_item(equip[CHARA_EQUIP_FEET].item_no)) {
            return false;
        }
        parts[0]->LoadSkin(loaded_data, "info", "", &stacks[5], texture);

        if (!edit_mode) {
            int file_size = {};
            if (!load_file("mainchr/c02.stb", &file_size)) {
                return false;
            }
            parts[0]->LoadActionFile(reinterpret_cast<char *>(read_buffer.data()), file_size, &stacks[6]);
            parts[0]->InitScript();
        }

        SetupUnitMan(scene, user_data, USER_CHARA_MONICA, nullptr);
        parts[0]->chara_type = ACTION_CHARA_MONICA;
        parts[0]->move_type = ACTION_MOVE_HUMAN;
    }

    if (chara_type == USER_CHARA_ROBO) {
        GetCharaMemAllocPtr(memory, stacks, USER_CHARA_ROBO, edit_mode);
        ROBO_INFO_DATA *robo_info = GetRoboPartsInfo(user_data);
        parts[0]->Initialize(nullptr);
        std::string path = dc2::character::ModelAssetPath("dungeon/robo", robo_info->model_name[ROBO_MODEL_LEG], true);
        if (!load_file(path)) {
            return false;
        }
        parts[0]->LoadPack(loaded_data, "info", stacks, stacks, stacks, texture, nullptr);
        parts[0]->texture_block = texture;
        SetupPartStack part_stack = {
            {0, 1, 2, 2, 3}
        };

        for (int i = ROBO_MODEL_ARM; i < ROBO_MODEL_NUM; ++i) {
            parts[i]->Initialize(nullptr);

            path = dc2::character::ModelAssetPath("dungeon/robo", robo_info->model_name[i], i != ROBO_MODEL_MINTS);

            if (!load_file(path)) {
                return false;
            }
            parts[i]->LoadPack(loaded_data, "info", &stacks[part_stack.stack_no[i]],
                               &stacks[part_stack.stack_no[i]], &stacks[part_stack.stack_no[i]], texture, parts[0]);

            if (i == ROBO_MODEL_ARM) {
                SetSwordBlurEffect(parts[0], &stacks[part_stack.stack_no[i]], chara_type);
            }
        }

        CActionChara *hat = parts[5];
        hat->Initialize(nullptr);
        if (robo_info->hat_file == nullptr || !load_file(robo_info->hat_file)) {
            return false;
        }
        hat->LoadPack(loaded_data, "info", &stacks[2], &stacks[2], &stacks[2], texture, parts[0]);
        SetupUnitMan(scene, user_data, USER_CHARA_ROBO, robo_info);
        int file_size = {};
        if (!load_file("dungeon/act_script/robo.stb", &file_size)) {
            return false;
        }
        parts[0]->LoadActionFile(reinterpret_cast<char *>(read_buffer.data()), file_size, &stacks[4]);
        parts[0]->InitScript();
        parts[0]->move_type = robo_info->move_type;
        parts[0]->attack_type = robo_info->attack_type;
        parts[0]->chara_type = ACTION_CHARA_ROBO;
    }

    if (chara_type == USER_CHARA_MONSTER) {
        int monster_id = user_data->monster_id;
        GetCharaMemAllocPtr(memory, stacks, USER_CHARA_MONSTER, edit_mode);
        const auto monster_model = GetMonsterModelFile(monster_id, MONSTER_FILE_MODEL);
        const auto monster_config = GetMonsterModelFile(monster_id, MONSTER_FILE_CONFIG);
        const auto script_name = GetMonsterModelFile(monster_id, MONSTER_FILE_SCRIPT);
        if (!monster_model || !monster_config || !script_name) {
            return false;
        }
        std::string monster_path = "dungeon/monster/" + *monster_model;
        std::string monster_script = "dungeon/act_script/" + *script_name;
        if (!load_file(monster_path)) {
            return false;
        }
        parts[0]->Initialize(nullptr);
        parts[0]->LoadPack(loaded_data, monster_config->c_str(), stacks, stacks, stacks, texture, nullptr);
        parts[0]->SetPosition(0.0f, 0.0f, 0.0f);
        parts[0]->texture_block = texture;
        SetupUnitMan(scene, user_data, USER_CHARA_MONSTER, nullptr);
        int file_size = {};
        if (!load_file(monster_script, &file_size)) {
            return false;
        }
        parts[0]->LoadActionFile(reinterpret_cast<char *>(read_buffer.data()), file_size, &stacks[5]);
        parts[0]->InitScript();
        parts[0]->chara_type = ACTION_CHARA_MAX;
        parts[0]->move_type = ACTION_MOVE_MONSTER;
    }

    int i = 0;

    do {
        dc2::log::PrintGame("[%d]STACK %d/%d\n", i, stacks[i].stack_used, stacks[i].stack_size);
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
    if (memory == nullptr || stacks == nullptr) {
        return false;
    }
    int row{};
    int count{};

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
        default:
            return false;
    }

    memory->stReset();
    int index = {};
    int size = {};

    for (index = 0; index < count; index++) {
        size = mem_table[row][index];

        if (size < 0) {
            break;
        }

        if (size == 0) {
            stacks[index].stSetBuffer(nullptr, 0);
            stacks[index].stReset();
            continue;
        }
        u_long128 *buffer = memory->stAlloc64(size);
        if (buffer == nullptr) {
            return false;
        }
        stacks[index].stSetChildBuffer(*memory, buffer, size);
        stacks[index].stReset();
    }

    return true;
}

void SetupUnitMan(CScene *scene, CUserDataManager *user_data, int unit, ROBO_INFO_DATA *robo_info) {
    if (scene == nullptr || user_data == nullptr) {
        return;
    }
    std::array<CCharacter2 *, ROBO_MODEL_NUM + 1> parts{};
    for (std::size_t slot = 0; slot < parts.size(); ++slot) {
        parts[slot] = scene->GetCharacter(static_cast<int>(slot));
    }
    dc2::character::SetupUnit(parts, user_data, unit, robo_info, &scene->loop_se);
}

void dc2::character::SetupUnit(std::span<CCharacter2 *const> parts, CUserDataManager *user_data,
                               int unit, ROBO_INFO_DATA *robo_info, CLoopSeMngr *loop_sounds) {
    if (user_data == nullptr || UnitPart(parts, 0) == nullptr) {
        return;
    }
    switch (unit) {
        case USER_CHARA_MAX:
            SetupMints(parts, user_data);
            break;
        case USER_CHARA_MONICA:
            SetupMonica(parts, user_data);
            break;
        case USER_CHARA_ROBO:
            SetupRobo(parts, user_data, robo_info);
            break;
        case USER_CHARA_MONSTER:
            SetupMonster(parts);
            break;
        default:
            return;
    }
    UnitPart(parts, 0)->sound_info.loop_se = loop_sounds;
    const std::size_t slot = unit == USER_CHARA_ROBO ? ROBO_MODEL_MINTS : 0;
    auto             *character = UnitPart(parts, slot);
    auto             *save_data = GetSaveData();
    if (character != nullptr && save_data != nullptr &&
        (save_data->GetBitCtrl() & MENU_DEBUG_BIT_CTRL_ATRA_OFF)) {
        AtraMiriaOnOff(unit, character, 0);
    }
}

/**
 *
 * Attaches Max’s equipped parts and sets his action character type.
 *
 */
static int SetupMints(std::span<CCharacter2 *const> parts_view, CUserDataManager *user_data) {
    CGameDataUsed *equip = user_data->GetCharaDataPtr(USER_CHARA_MAX)->equip;
    CActionChara  *characters[5];

    for (int slot = 0; slot < 5; slot++) {
        characters[slot] = static_cast<CActionChara *>(UnitPart(parts_view, static_cast<std::size_t>(slot)));

        if (characters[slot] != nullptr) {
            characters[slot]->ResetParent();
        }
    }

    SetupNameTable4 attach_names = {
        {"ef00", "gun_hand", "hat", ""}
    };
    SetupNameTable3 part_names = {
        {"sword", "shot", "hat"}
    };
    int part = {};

    if (characters[0] != nullptr) {
        dc2::text::Copy(characters[0]->name, "body");
    }

    for (part = 0; part < 3; part++, equip++) {
        if (0 < equip->item_no) {
            if (characters[part + 1] != nullptr) {
                char *attach_name = attach_names.names[part];

                if (!characters[0]->SetRef(characters[part + 1], attach_name)) {
                    dc2::log::PrintGame("setref failed : %s\n", attach_name);
                } else {
                    dc2::text::Copy(characters[part + 1]->name, part_names.names[part]);
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
static int SetupMonica(std::span<CCharacter2 *const> parts_view, CUserDataManager *user_data) {
    CGameDataUsed *equip = user_data->GetCharaDataPtr(USER_CHARA_MONICA)->equip;
    CActionChara  *characters[5];

    for (int slot = 0; slot < 5; slot++) {
        characters[slot] = static_cast<CActionChara *>(UnitPart(parts_view, static_cast<std::size_t>(slot)));

        if (characters[slot] != nullptr) {
            characters[slot]->ResetParent();
        }
    }

    SetupNameTable3 attach_names = {
        {"sword_hand", "wr", "ac"}
    };
    SetupNameTable3 part_names = {
        {"sword", "shot", "hat"}
    };
    int part = {};

    if (characters[0] != nullptr) {
        dc2::text::Copy(characters[0]->name, "body");
    }

    for (part = 0; part < 3; part++, equip++) {
        if (0 < equip->item_no) {
            if (characters[part + 1] != nullptr) {
                char *attach_name = attach_names.names[part];

                if (!characters[0]->SetRef(characters[part + 1], attach_name)) {
                    dc2::log::PrintGame("setref failed : %s\n", attach_name);
                } else {
                    dc2::text::Copy(characters[part + 1]->name, part_names.names[part]);
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
static int SetupRobo(std::span<CCharacter2 *const> parts_view, CUserDataManager *user_data, ROBO_INFO_DATA *robo_info) {
    CActionChara  *parts[6];
    CGameDataUsed *arm_item = {};
    auto           body_arm_frame = user_data->robo_data.parts[ROBO_PART_BODY].RoboJointName();
    arm_item = &user_data->robo_data.parts[ROBO_PART_ARM];
    auto arm_attach_frame = arm_item->RoboJointName();
    if (!body_arm_frame || body_arm_frame->empty() || !arm_attach_frame || arm_attach_frame->empty()) {
        return false;
    }
    int leg_type = user_data->robo_data.parts[ROBO_PART_LEG].GetRoboInfoType();
    int arm_type = arm_item->GetRoboInfoType();

    for (int i = 0; i < 6; ++i) {
        parts[i] = static_cast<CActionChara *>(UnitPart(parts_view, static_cast<std::size_t>(i)));

        if (parts[i] == nullptr) {
            return false;
        }
    }

    for (int i = 0; i < 6; ++i) {
        parts[i]->ResetParent();
    }

    SetupNameTable6 joint_names = {
        {"body%d", "spine", "joint2", "joint1", "hat", nullptr}
    };

    for (int i = 0; i < 5; ++i) {
        if (i == 0) {
            parts[0]->SetRef(parts[i + 1], arm_attach_frame->data());
        } else {
            if (!parts[0]->SetRef(parts[i + 1], joint_names.names[i])) {
                dc2::log::PrintGame(" refer failed  :  %s\n", joint_names.names[i]);
            }
        }

        parts[i + 1]->CopyOutLine(parts[0]);
    }

    dc2::text::Copy(parts[0]->name, "leg");
    dc2::text::Copy(parts[1]->name, "arm");
    dc2::text::Copy(parts[2]->name, "body");
    dc2::text::Copy(parts[3]->name, "mints");
    dc2::text::Copy(parts[4]->name, "bpack");
    dc2::text::Copy(parts[5]->name, "cap");

    if (robo_info == nullptr) {
        return false;
    }

    mgCFrame *arm_frame = parts[0]->SearchObject("ude");
    mgCFrame *mount_frame = parts[0]->SearchObject(body_arm_frame->data());

    if (arm_frame == nullptr) {
        dc2::log::PrintGame("NOT ARM!\n");
    }

    if (mount_frame == nullptr) {
        dc2::log::PrintGame("NOT MAT!\n");
    }

    if (arm_frame == nullptr || mount_frame == nullptr) {
        return false;
    }

    sceVu0FMATRIX matrix;
    sceVu0CopyMatrix(matrix, mount_frame->trans_matrix);
    arm_frame->SetTransMatrix(matrix);
    parts[0]->move_type = leg_type;
    parts[0]->attack_type = arm_type;
    dc2::log::PrintGame("***************** %s,%s\n", arm_attach_frame->c_str(), body_arm_frame->c_str());
    parts[0]->chara_type = ACTION_CHARA_ROBO;
    return true;
}

ROBO_INFO_DATA *GetRoboPartsInfo(CUserDataManager *user_data);

/**
 *
 * Clears character attachments and selects monster movement.
 *
 */
static int SetupMonster(std::span<CCharacter2 *const> parts_view) {
    CActionChara *characters[5];

    for (int slot = 0; slot < 5; slot++) {
        characters[slot] = static_cast<CActionChara *>(UnitPart(parts_view, static_cast<std::size_t>(slot)));

        if (characters[slot] != nullptr) {
            characters[slot]->ResetParent();
        }
    }

    if (characters[0] != nullptr) {
        dc2::text::Copy(characters[0]->name, "body");
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
    {"body01.gltf", "arm1"},
    {"body02.gltf", "arm2"},
    {"body02.gltf", "arm2"},
    {"body02.gltf", "arm2"},
    {"body02.gltf", "arm2"},
    {"body02.gltf", "arm2"},
    {"body02.gltf", "arm2"},
    {"body02.gltf", "arm2"},
    {"body02.gltf", "arm2"},
    {"body02.gltf", "arm2"},
    {"body02.gltf", "arm2"}
};

namespace {
ROBO_INFO_DATA *BuildRoboPartsInfoCore(CUserDataManager *user_data) {
    static char    r_robo_pname[4][16];
    int            i = {};
    ROBO_DATA     *parts = &user_data->robo_data;
    CGameData     *game_data = GetGameDataPt();
    SetupPartOrder part_order = {
        {ROBO_PART_LEG, ROBO_PART_ARM, ROBO_PART_BODY, ROBO_PART_PACK}
    };
    CDataRoboPart *part_info[4];

    for (i = 0; i < 4; ++i) {
        part_info[i] = GetRoboPartInfoData(parts->parts[part_order.robo_slot[i]].item_no);
        r_robo_pname[i][0] = '\0';

        if (part_info[i] != nullptr) {
            if (const auto file_name = ItemFileName(parts->parts[part_order.robo_slot[i]].item_no, 0)) {
                dc2::text::Copy(r_robo_pname[i], *file_name);
            }
        }
    }

    robo_dat.model_name[ROBO_MODEL_LEG] = r_robo_pname[0];
    robo_dat.model_name[ROBO_MODEL_ARM] = r_robo_pname[1];
    robo_dat.model_name[ROBO_MODEL_BODY] = r_robo_pname[2];
    robo_dat.model_name[ROBO_MODEL_BPACK] = r_robo_pname[3];
    CHARA_DATA        *max_data = user_data->GetCharaDataPtr(USER_CHARA_MAX);
    int                costume = max_data->equip[CHARA_EQUIP_CLOTHES].item_no;
    static std::string fname;
    costume -= game_data->GetDataTypeStartListNo(ITEM_DATA_MAX_CLOTHES);
    costume = std::clamp(costume, 0, 5);
    fname.clear();

    if (part_info[2] != nullptr) {
        std::int64_t body_type = part_info[2]->offset_no;

        if (GetSaveData()->GetBitFlag(SAVE_FLAG_COSTUME_UNLOCK)) {
            body_type += 10;
        }

        fname = std::format("mints{}{}{}.gltf", body_type < 10 ? "0" : "", body_type,
                            static_cast<char>('a' + costume));
    }

    robo_dat.arm_name = nullptr;
    robo_dat.model_name[ROBO_MODEL_MINTS] = fname.data();

    if (part_info[2] != nullptr && part_info[2]->offset_no >= 1 && part_info[2]->offset_no <= static_cast<int>(std::size(robo_info_body))) {
        robo_dat.arm_name = robo_info_body[part_info[2]->offset_no - 1].arm_name;
    }

    robo_dat.move_type = 0;

    if (part_info[0] != nullptr) {
        robo_dat.move_type = user_data->robo_data.parts[ROBO_PART_LEG].GetRoboInfoType();
    }

    robo_dat.attack_type = 0;

    if (part_info[1] != nullptr) {
        robo_dat.attack_type = user_data->robo_data.parts[ROBO_PART_ARM].GetRoboInfoType();
    }

    max_data = user_data->GetCharaDataPtr(USER_CHARA_MAX);
    static std::string hat_path;
    if (const auto path = ItemFilePath(max_data->equip[CHARA_EQUIP_HEAD].item_no, 0)) {
        hat_path = *path;
        robo_dat.hat_file = hat_path.data();
    } else {
        hat_path.clear();
        robo_dat.hat_file = nullptr;
    }
    return &robo_dat;
}
} // namespace

#include "charasetup.hpp"
#include "gamedata.hpp"
#include "userdata.hpp"

namespace {

// Retail's tables of Max-in-the-Ridepod models, one per outfit.
constexpr int kMaxOutfits = 6;

} // namespace

// Retail indexes its six "mints" model names by Max's outfit minus the first outfit item, unchecked.
// While the item menu holds Max's outfit on the cursor his slot is empty and the index is -258 (the PAL
// "Make menu" crash; natively a fault in sprintf), so retail is given his first outfit for the call.
ROBO_INFO_DATA *GetRoboPartsInfo(CUserDataManager *user_data) {
    CHARA_DATA    *max = user_data->GetCharaDataPtr(USER_CHARA_MAX);
    CGameDataUsed &outfit = max->equip[CHARA_EQUIP_CLOTHES];
    const short    item_no = outfit.item_no;
    const int      first = GetGameDataPt()->GetDataTypeStartListNo(ITEM_DATA_MAX_CLOTHES);
    const int      index = item_no - first;

    if (first > 0 && (index < 0 || index >= kMaxOutfits)) {
        outfit.item_no = static_cast<short>(first);
        ROBO_INFO_DATA *info = BuildRoboPartsInfoCore(user_data);
        outfit.item_no = item_no;
        return info;
    }

    return BuildRoboPartsInfoCore(user_data);
}
