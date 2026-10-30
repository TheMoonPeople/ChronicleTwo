// clang-format off
#include "platform/native_config.hpp"
// clang-format on

#include "common.h"
#include "mw_runtime.h"

#include <array>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <limits>

#include "automap.hpp"
#include "cameracontrol.hpp"
#include "dataread.hpp"
#include "dng_debug.hpp"
#include "dng_effect.hpp"
#include "dng_main.hpp"
#include "dng_status.hpp"
#include "dngfloor.hpp"
#include "dngmenu.hpp"
#include "effscript.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "font.hpp"
#include "mainloop.hpp"
#include "maintex.hpp"
#include "mapload.hpp"
#include "menucommon.hpp"
#include "menumain.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "quest.hpp"
#include "savedata.hpp"
#include "savedatadungeon.hpp"
#include "sceneevent.hpp"
#include "scenesnd.hpp"
#include "scriptinterpreter.hpp"
#include "snd_seseq.hpp"
#include "userdata.hpp"
#include "water.hpp"

/**
 *
 * Room option entries used by the dungeon floor script.
 *
 */
struct RoomOptions {
    MENU_SPI_ANALYZE_STRUCT1 entries[5]; /**< Room option entries. */
};

/**
 *
 * Dungeon floor manager receiving the current script.
 *
 */
CDngFloorManager *tree_dngmap;

/**
 *
 * Next dungeon grid cell receiving script information.
 *
 */
static GLID_INFO *tree_glid_info;

/**
 *
 * Memory arena used by the dungeon map script.
 *
 */
mgCMemory *tree_spi_stack;

/**
 *
 * Passage record receiving the current script properties.
 *
 */
static DNGMAP_ROOT_INFO *tree_spi_rootinfo;

/**
 *
 * Room record receiving the current script properties.
 *
 */
static DNGMAP_ROOM_INFO *tree_spi_roominfo;

/**
 *
 * Number of grid cells read from the current dungeon map script.
 *
 */
static s16 menu_dng_debug_glidcnt;

static int _TREE_MAPINFO(dc2::script::TagArguments stack, int argument_count);
static int _GLID_INFO(dc2::script::TagArguments stack, int argument_count);
static int _ROOT_INFO(dc2::script::TagArguments stack);
static int _ROOM_INFO(dc2::script::TagArguments stack, int argument_count);
static int _ROOM_LINK(dc2::script::TagArguments stack, int argument_count);
static int _ROOM_OPTION(dc2::script::TagArguments stack, int argument_count);
static int _ROOM_TEXNO(dc2::script::TagArguments stack, int argument_count);
static int _ROOM_KEYROOM(dc2::script::TagArguments stack);
static int _ROOM_FLOOR_INFO(dc2::script::TagArguments stack, int argument_count);
static int _ROOM_FLOOR_INFO2(dc2::script::TagArguments stack, int argument_count);
static int _ROOM_TITLE(dc2::script::TagArguments stack, int argument_count);

/**
 *
 * Dungeon grid and floor-property script tags.
 *
 */
SPI_TAG_PARAM tree_map_tag[] = {
    {"TREE_INFO",  _TREE_MAPINFO                                },
    {"GI",         _GLID_INFO                                   },
    {"RT",         dc2::script::AdaptTagArguments<_ROOT_INFO>   },
    {"RI",         _ROOM_INFO                                   },
    {"RI_LINK",    dc2::script::AdaptTagArguments<_ROOM_LINK>   },
    {"RI_OP",      _ROOM_OPTION                                 },
    {"RI_TEX",     _ROOM_TEXNO                                  },
    {"RI_KEYROOM", dc2::script::AdaptTagArguments<_ROOM_KEYROOM>},
    {"RF_INFO",    _ROOM_FLOOR_INFO                             },
    {"RF_INFO2",   _ROOM_FLOOR_INFO2                            },
    {"RI_TITLE",   _ROOM_TITLE                                  },
    {nullptr,      nullptr                                      },
};

/**
 *
 * Base texture indices of the randomized dungeon room groups.
 *
 */
int offsetTable_911[] = {0, 4, 8, 12, 16};

void CDngFloorManager::Initialize() {
    dng_no = 0;
    glid_info = nullptr;
    glid_num = 0;
    glid_w = 0;
    glid_h = 0;
}

/**
 *
 * Sets dungeon map dimensions and allocates its grid information.
 *
 */
static int _TREE_MAPINFO(dc2::script::TagArguments stack, int argc) {
    const int width = dc2::script::TagInteger(stack);
    const int height = dc2::script::TagInteger(stack + 1);
    const int count = dc2::script::TagInteger(stack + 2);
    if (tree_dngmap == nullptr || tree_spi_stack == nullptr || width <= 0 || height <= 0 || count <= 0 ||
        width > std::numeric_limits<s16>::max() || height > std::numeric_limits<s16>::max() ||
        count > std::numeric_limits<s16>::max()) {
        return 0;
    }
    auto *cells = dc2::memory::NewArray<GLID_INFO>(*tree_spi_stack, static_cast<std::size_t>(count));
    if (cells == nullptr) {
        return 0;
    }
    tree_dngmap->glid_w = static_cast<s16>(width);
    tree_dngmap->glid_h = static_cast<s16>(height);
    tree_dngmap->glid_info = cells;
    tree_dngmap->glid_num = count;
    tree_glid_info = cells;
    tree_spi_rootinfo = nullptr;
    tree_spi_roominfo = nullptr;
    menu_dng_debug_glidcnt = 0;
    return 1;
}

/**
 *
 * Reads a dungeon map grid cell and initializes its room information.
 *
 */
static int _GLID_INFO(dc2::script::TagArguments stack, int argc) {
    if (tree_dngmap == nullptr || tree_glid_info == nullptr || menu_dng_debug_glidcnt < 0 ||
        menu_dng_debug_glidcnt >= tree_dngmap->glid_num) {
        tree_spi_rootinfo = nullptr;
        tree_spi_roominfo = nullptr;
        return 0;
    }
    tree_glid_info->type = dc2::script::TagInteger(stack++);
    tree_glid_info->x = dc2::script::TagInteger(stack++);
    tree_glid_info->y = dc2::script::TagInteger(stack++);
    tree_glid_info->unk_6 = dc2::script::TagInteger(stack++);
    tree_glid_info->unk_8 = dc2::script::TagInteger(stack);
    tree_glid_info->link_glid[GLID_DIR_UP] = nullptr;
    tree_glid_info->link_glid[GLID_DIR_DOWN] = nullptr;
    tree_glid_info->link_glid[GLID_DIR_LEFT] = nullptr;
    tree_glid_info->link_glid[GLID_DIR_RIGHT] = nullptr;
    tree_glid_info->blink = false;
    DNGMAP_ROOM_INFO *info = &tree_glid_info->room;
    tree_spi_rootinfo = &tree_glid_info->root;
    tree_spi_roominfo = info;
    memset(info, 0, sizeof(*info));
    memset(tree_spi_rootinfo, 0, sizeof(*tree_spi_rootinfo));
    tree_glid_info += 1;
    menu_dng_debug_glidcnt += 1;
    return 1;
}

/**
 *
 * Sets the type, shape, and marker of a dungeon map root.
 *
 */
static int _ROOT_INFO(dc2::script::TagArguments stack) {
    if (tree_spi_rootinfo == nullptr || stack.Remaining() < 3) {
        return 0;
    }
    const int type = dc2::script::TagInteger(stack++);
    const int shape = dc2::script::TagInteger(stack++);
    const int show_mark = dc2::script::TagInteger(stack);
    tree_spi_rootinfo->type = type;
    tree_spi_rootinfo->shape = shape;
    tree_spi_rootinfo->show_mark = show_mark;
    return 1;
}

/**
 *
 * Initializes the current dungeon room from script data.
 *
 */
static int _ROOM_INFO(dc2::script::TagArguments stack, int argc) {
    if (tree_spi_roominfo == nullptr) {
        return 0;
    }
    tree_spi_roominfo->floor_id = dc2::script::TagInteger(stack++);
    tree_spi_roominfo->order = dc2::script::TagInteger(stack++);
    dc2::script::TagInteger(stack++);
    tree_spi_roominfo->unk_0 = nullptr;

    if (argc >= 4) {
        tree_spi_roominfo->unk_0 = mgCopyString(dc2::script::TagCString(stack), tree_spi_stack);
    }

    tree_spi_roominfo->selectable = false;
    tree_spi_roominfo->visited = false;
    tree_spi_roominfo->flag = DNGMAP_ROOM_FLAG_ROOM;
    tree_spi_roominfo->offset_y = 0;
    tree_spi_roominfo->offset_x = 0;
    tree_spi_roominfo->practice_type = -1;
    tree_spi_roominfo->mark_phase = 0;
    tree_spi_roominfo->unk_4c = 0;
    return 1;
}

/**
 *
 * Sets the linked rooms of the current dungeon room.
 *
 */
static int _ROOM_LINK(dc2::script::TagArguments stack, int count) {
    if (tree_spi_roominfo == nullptr || count < 0 || count > GLID_DIR_NUM ||
        stack.Remaining() < static_cast<std::size_t>(count)) {
        return 0;
    }
    std::array<s16, GLID_DIR_NUM> links{};
    for (int i = 0; i < count; i++) {
        const int link = dc2::script::TagInteger(stack++);
        if (link < std::numeric_limits<s16>::min() || link > std::numeric_limits<s16>::max()) {
            return 0;
        }
        links[i] = static_cast<s16>(link);
    }
    for (int i = 0; i < count; i++) {
        tree_spi_roominfo->link[i] = links[i];
    }

    return 1;
}

/**
 *
 * Applies named option flags to the current dungeon room.
 *
 */
static int _ROOM_OPTION(dc2::script::TagArguments stack, int argc) {
    if (tree_spi_roominfo == nullptr) {
        return 0;
    }
    RoomOptions options = {
        {
         {"start", DNGMAP_ROOM_FLAG_START},
         {"exit", DNGMAP_ROOM_FLAG_EXIT},
         {"boss", DNGMAP_ROOM_FLAG_BOSS},
         {"sub", DNGMAP_ROOM_FLAG_SUB},
         {nullptr, 0},
         }
    };
    int flags = DNGMAP_ROOM_FLAG_ROOM;

    for (int i = 0; i < argc; i++) {
        flags |= menu_spi_analyze_func_strcut1(options.entries, dc2::script::TagCString(stack++));
    }

    tree_spi_roominfo->flag |= flags;

    if ((tree_spi_roominfo->flag & DNGMAP_ROOM_FLAG_SUB) || (tree_spi_roominfo->flag & DNGMAP_ROOM_FLAG_BOSS)) {
        tree_spi_roominfo->offset_x = 0;
        tree_spi_roominfo->offset_y = -0x1A;

        if (argc > 1) {
            tree_spi_roominfo->offset_x = dc2::script::TagInteger(stack++);
            tree_spi_roominfo->offset_y = dc2::script::TagInteger(stack);
        }
    }

    return 1;
}

/**
 *
 * Sets the key room references of the current dungeon room.
 *
 */
static int _ROOM_KEYROOM(dc2::script::TagArguments stack) {
    if (tree_spi_roominfo == nullptr || stack.Remaining() < 4) {
        return 0;
    }
    const int key0 = dc2::script::TagInteger(stack++);
    const int key1 = dc2::script::TagInteger(stack++);
    const int key2 = dc2::script::TagInteger(stack++);
    const int key3 = dc2::script::TagInteger(stack);
    tree_spi_roominfo->key_room[0] = key0;
    tree_spi_roominfo->key_room[1] = key1;
    tree_spi_roominfo->key_room[2] = key2;
    tree_spi_roominfo->key_room[3] = key3;
    return 1;
}

/**
 *
 * Chooses the texture number of the current dungeon room.
 *
 */
static int _ROOM_TEXNO(dc2::script::TagArguments stack, int argc) {
    if (tree_spi_roominfo == nullptr) {
        return 0;
    }
    int texture_no = dc2::script::TagInteger(stack);

    if (texture_no < 0) {
        if (texture_no < -static_cast<int>(std::size(offsetTable_911))) {
            return 0;
        }
        const int texture_group = -texture_no;
        texture_no = GetRandI(4);
        texture_no += offsetTable_911[texture_group - 1];
    }

    tree_spi_roominfo->tex_no = texture_no;
    return 1;
}

/**
 *
 * Sets gameplay options for a dungeon floor.
 *
 */
static int _ROOM_FLOOR_INFO(dc2::script::TagArguments stack, int argc) {
    DNGMAP_ROOM_INFO *info = tree_dngmap->GetDngMapFloorInfo(dc2::script::TagInteger(stack++));

    if (info == nullptr) {
        return 0;
    }

    info->geostone = dc2::script::TagInteger(stack++);
    info->fast_destroy_time = dc2::script::TagInteger(stack++);
    info->fishing = dc2::script::TagInteger(stack++);
    info->fishing_record = dc2::script::TagInteger(stack++);
    info->seal = dc2::script::TagInteger(stack++);
    info->spheda = dc2::script::TagInteger(stack++);

    for (int i = 0; i < DNGMAP_SPHEDA_PRIZE_NUM; i++) {
        info->spheda_prize_item[i] = dc2::script::TagInteger(stack++);
        info->spheda_prize_num[i] = dc2::script::TagInteger(stack++);
    }

    return 1;
}

/**
 *
 * Sets practice options for a dungeon floor.
 *
 */
static int _ROOM_FLOOR_INFO2(dc2::script::TagArguments stack, int argc) {
    DNGMAP_ROOM_INFO *info = tree_dngmap->GetDngMapFloorInfo(dc2::script::TagInteger(stack++));

    if (info == nullptr) {
        return 0;
    }

    info->practice_type = dc2::script::TagInteger(stack++);
    info->practice_param = dc2::script::TagInteger(stack);
    return 1;
}

/**
 *
 * Sets the display title of a dungeon floor.
 *
 */
static int _ROOM_TITLE(dc2::script::TagArguments stack, int argc) {
    DNGMAP_ROOM_INFO *info = tree_dngmap->GetDngMapFloorInfo(dc2::script::TagInteger(stack++));

    if (info == nullptr) {
        return 0;
    }

    char *name = dc2::script::TagCString(stack);

    char empty[4] = "err";

    if (name == nullptr) {
        name = empty;
    }

    info->title = mgCopyString(name, tree_spi_stack);
    return 1;
}

GLID_INFO *CDngFloorManager::GetDngMapFloorGlidInfo(int floor_id) {
    int i = {};

    if (this->glid_info == nullptr || (i = 0, this->glid_num) <= 0) {
        return nullptr;
    }

    for (; i < this->glid_num; i++) {
        if (this->glid_info[i].type == GLID_TYPE_ROOM && floor_id == this->glid_info[i].room.floor_id) {
            return &this->glid_info[i];
        }
    }

    return nullptr;
}

int CDngFloorManager::IsGeoStone(int floor_id) {
    DNGMAP_ROOM_INFO *info = GetDngMapFloorInfo(floor_id);

    if (info != nullptr) {
        return info->geostone;
    }

    return 0;
}

int CDngFloorManager::GetSphedaPrize(int floor_id, int index, int *prize, int *count) {
    DNGMAP_ROOM_INFO *info = GetDngMapFloorInfo(floor_id);

    if (info == nullptr) {
        return false;
    }

    if (index < 0) {
        return false;
    }

    if (index >= DNGMAP_SPHEDA_PRIZE_NUM) {
        index = DNGMAP_SPHEDA_PRIZE_NUM - 1;
    }

    if (prize != nullptr) {
        *prize = info->spheda_prize_item[index];
    }

    if (count != nullptr) {
        *count = info->spheda_prize_num[index];
    }

    return true;
}

int CDngFloorManager::GetSphedaPrize(int index, int *prize, int *count) {
    CSaveDataDungeon *dungeon = menu_GetSaveDataDungeon();

    if (dungeon == nullptr) {
        return false;
    }

    return GetSphedaPrize(dungeon->floor_id[dungeon->stage_id], index, prize, count);
}

int CDngFloorManager::IsPlaySubGame() {
    int               games = 0;
    DNGMAP_ROOM_INFO *info = GetActiveFloorInfo();

    if (info == nullptr) {
        return 0;
    }

    if (info->fishing != 0) {
        games |= DNGMAP_SUB_GAME_FISHING;
    }

    if (info->spheda != 0) {
        games |= DNGMAP_SUB_GAME_SPHEDA;
    }

    return games;
}

int CDngFloorManager::IsSealFloor(int floor_id) {
    CSaveDataDungeon *dungeon = menu_GetSaveDataDungeon();

    if (dungeon == nullptr) {
        return DNGMAP_SEAL_NONE;
    }

    if (floor_id < 0) {
        floor_id = dungeon->floor_id[dungeon->stage_id];
    }

    DNGMAP_ROOM_INFO *info = GetDngMapFloorInfo(floor_id);

    if (info == nullptr) {
        return DNGMAP_SEAL_NONE;
    }

    DNG_FLOOR_SAVE *saved = dungeon->GetFloorInfoPtr(dungeon->stage_id, floor_id);
    int             seal = info->seal;

    if (saved != nullptr && (saved->flag & DNG_FLOOR_FLAG_SEAL_CLEAR)) {
        seal = DNGMAP_SEAL_NONE;
    }

    CUserDataManager *user = GetUserDataMan();

    if (user != nullptr) {
        int members = user->GetNowPartyMember();

        if (seal == DNGMAP_SEAL_MONICA && !(members & (1 << USER_CHARA_MONICA))) {
            seal = DNGMAP_SEAL_NONE;
        }

        if (seal == DNGMAP_SEAL_MAX && !(members & (1 << USER_CHARA_MAX))) {
            seal = DNGMAP_SEAL_NONE;
        }
    }

    return seal;
}

int CDngFloorManager::IsClearMostFastDestroy() {
    DNG_BATTLE_AREA  *scene = menu_GetBattleAreaScene();
    CSaveData        *save = GetSaveData();
    CSaveDataDungeon *dungeon = &save->save_dungeon;

    if (dungeon == nullptr || scene == nullptr) {
        return DNGMAP_FAST_DESTROY_NONE;
    }

    int               floor = dungeon->floor_id[dungeon->stage_id];
    DNGMAP_ROOM_INFO *info = GetDngMapFloorInfo(floor);
    DNG_FLOOR_SAVE   *saved = dungeon->GetFloorInfoPtr(dungeon->stage_id, floor);

    if (info == nullptr || saved == nullptr) {
        return DNGMAP_FAST_DESTROY_NONE;
    }

    int elapsed = (static_cast<int>(save->play_time) - static_cast<int>(scene->subject_counter)) * 6 / 5;
    int result = DNGMAP_FAST_DESTROY_NONE;

    if (saved->fast_destroy_time == 0) {
        if (elapsed < info->fast_destroy_time) {
            saved->fast_destroy_time = elapsed;
            result = DNGMAP_FAST_DESTROY_FIRST;
            GetUserDataMan()->AddYarikomiMedal(result);
            saved->flag |= DNG_FLOOR_FLAG_FAST_DESTROY_CLEAR;
        }
    } else if (elapsed < saved->fast_destroy_time) {
        saved->fast_destroy_time = elapsed;
        result = DNGMAP_FAST_DESTROY_RECORD;
    }

    return result;
}

int CDngFloorManager::IsClearPractice(int difficulty) {
    CSaveDataDungeon *dungeon = menu_GetSaveDataDungeon();
    DNG_BATTLE_AREA  *scene = menu_GetBattleAreaScene();
    int               floor = dungeon->floor_id[dungeon->stage_id];
    DNGMAP_ROOM_INFO *info = GetDngMapFloorInfo(floor);
    DNG_FLOOR_SAVE   *saved = dungeon->GetFloorInfoPtr(dungeon->stage_id, floor);

    if (info == nullptr || saved == nullptr || scene == nullptr) {
        return DNGMAP_PRACTICE_NONE;
    }

    static s8 diff_conditiontable[2][DNGMAP_PRACTICE_TYPE_NUM] = {
        {1, 1, 1, 1, 1, 0, 0},
        {0, 0, 0, 0, 0, 1, 0},
    };
    static u16 check_bittable[3][6] = {
        {DNG_PRACTICE_ACTION_MAX_MELEE, DNG_PRACTICE_ACTION_MAX_GUN,   DNG_PRACTICE_ACTION_MONICA_MELEE, DNG_PRACTICE_ACTION_MONICA_MAGIC, DNG_PRACTICE_ACTION_RIDEPOD,      DNG_PRACTICE_ACTION_MONSTER},
        {DNG_PRACTICE_ACTION_ITEM,      DNG_PRACTICE_ACTION_MAX_MELEE, DNG_PRACTICE_ACTION_MAX_GUN,      DNG_PRACTICE_ACTION_MONICA_MELEE, DNG_PRACTICE_ACTION_MONICA_MAGIC, DNG_PRACTICE_ACTION_MONSTER},
        {DNG_PRACTICE_ACTION_RIDEPOD,   DNG_PRACTICE_ACTION_MAX_MELEE, DNG_PRACTICE_ACTION_MAX_GUN,      DNG_PRACTICE_ACTION_MONICA_MELEE, DNG_PRACTICE_ACTION_MONICA_MAGIC, DNG_PRACTICE_ACTION_ITEM   },
    };
    int result = {};
    int mask = {};
    int found = {};
    int practice_type = {};
    int active = {};
    int r = {};
    int i = {};
    int j = {};
    int k = {};
    int l = {};
    int m = {};

    practice_type = info->practice_type;

    if (practice_type < 0) {
        return DNGMAP_PRACTICE_NONE;
    }

    active = scene->battle_clear;
    result = DNGMAP_PRACTICE_NONE;

    if (diff_conditiontable[difficulty][practice_type] == 0) {
        return DNGMAP_PRACTICE_NONE;
    }

    mask = scene->practice_actions;

    j = 0;

    while (++j < DNGMAP_PRACTICE_TYPE_NUM) {
    }

    switch (practice_type) {
        case DNGMAP_PRACTICE_TYPE_TIME:
            if (active != 0) {
                if (scene->timer < info->practice_param) {
                    result = DNGMAP_PRACTICE_CLEAR;
                }
            }

            break;
        case DNGMAP_PRACTICE_TYPE_ITEM_ONLY:
        case DNGMAP_PRACTICE_TYPE_WEAPON_ONLY:
        case DNGMAP_PRACTICE_TYPE_RIDEPOD_ONLY:
        case DNGMAP_PRACTICE_TYPE_MONSTER_ONLY:
            if (active != 0) {
                found = false;

                if (practice_type == DNGMAP_PRACTICE_TYPE_ITEM_ONLY) {
                    for (i = 0; i < 6; i++) {
                        if (mask & check_bittable[0][i]) {
                            found = true;
                        }
                    }
                }

                if (practice_type == DNGMAP_PRACTICE_TYPE_RIDEPOD_ONLY) {
                    for (k = 0; k < 6; k++) {
                        if (mask & check_bittable[1][k]) {
                            found = true;
                        }
                    }
                }

                if (practice_type == DNGMAP_PRACTICE_TYPE_MONSTER_ONLY) {
                    for (l = 0; l < 6; l++) {
                        if (mask & check_bittable[2][l]) {
                            found = true;
                        }
                    }
                }

                if (practice_type == DNGMAP_PRACTICE_TYPE_WEAPON_ONLY) {
                    if ((mask & DNG_PRACTICE_ACTION_ITEM) || (mask & DNG_PRACTICE_ACTION_RIDEPOD) || (mask & DNG_PRACTICE_ACTION_MONSTER)) {
                        found = true;
                    } else {
                        static u16 cbit[4][5] = {
                            {DNG_PRACTICE_ACTION_MAX_GUN,   DNG_PRACTICE_ACTION_MONICA_MELEE, DNG_PRACTICE_ACTION_MONICA_MAGIC, DNG_PRACTICE_ACTION_RIDEPOD, DNG_PRACTICE_ACTION_MONSTER},
                            {DNG_PRACTICE_ACTION_MAX_MELEE, DNG_PRACTICE_ACTION_MONICA_MELEE, DNG_PRACTICE_ACTION_MONICA_MAGIC, DNG_PRACTICE_ACTION_RIDEPOD, DNG_PRACTICE_ACTION_MONSTER},
                            {DNG_PRACTICE_ACTION_MAX_MELEE, DNG_PRACTICE_ACTION_MAX_GUN,      DNG_PRACTICE_ACTION_MONICA_MAGIC, DNG_PRACTICE_ACTION_RIDEPOD, DNG_PRACTICE_ACTION_MONSTER},
                            {DNG_PRACTICE_ACTION_MAX_MELEE, DNG_PRACTICE_ACTION_MAX_GUN,      DNG_PRACTICE_ACTION_MONICA_MELEE, DNG_PRACTICE_ACTION_RIDEPOD, DNG_PRACTICE_ACTION_MONSTER},
                        };

                        r = info->practice_param - 1;

                        for (m = 0; m < 5; m++) {
                            if (mask & cbit[r][m]) {
                                found = true;
                            }
                        }
                    }
                }

                if ((mask & (1 << info->practice_param)) && !found) {
                    result = DNGMAP_PRACTICE_CLEAR;
                }
            }

            break;
        case DNGMAP_PRACTICE_TYPE_NO_HEAL:
            result = DNGMAP_PRACTICE_CLEAR;

            if (mask & DNG_PRACTICE_ACTION_HEAL) {
                result = DNGMAP_PRACTICE_FAILED;
            }

            break;
        case DNGMAP_PRACTICE_TYPE_NONE:
            break;
    }

    if (result == DNGMAP_PRACTICE_CLEAR) {
        if (saved->flag & DNG_FLOOR_FLAG_PRACTICE_CLEAR) {
            result = DNGMAP_PRACTICE_CLEAR_AGAIN;
        }
    }

    if (result == DNGMAP_PRACTICE_CLEAR || result == DNGMAP_PRACTICE_CLEAR_AGAIN) {
        saved->flag |= DNG_FLOOR_FLAG_PRACTICE_CLEAR;
    }

    if (result == DNGMAP_PRACTICE_CLEAR) {
        GetUserDataMan()->AddYarikomiMedal(1);
    }

    return result;
}

DNGMAP_ROOM_INFO *CDngFloorManager::GetDngMapFloorInfo(int floor_id) {
    if (this->glid_info == nullptr) {
        return nullptr;
    }

    GLID_INFO *glid = GetDngMapFloorGlidInfo(floor_id);

    if (glid != nullptr) {
        return &glid->room;
    }

    return nullptr;
}

DNGMAP_ROOM_INFO *CDngFloorManager::GetActiveFloorInfo() {
    CSaveDataDungeon *save = menu_GetSaveDataDungeon();

    if (save == nullptr) {
        return nullptr;
    }

    return GetDngMapFloorInfo(save->floor_id[save->stage_id]);
}

void CDngFloorManager::RelationGlid() {
    int        i = {};
    int        j = {};
    GLID_INFO *room = {};
    GLID_INFO *other = {};

    for (i = 0; i < glid_num; i++) {
        room = &glid_info[i];

        for (j = 0; j < glid_num; j++) {
            other = &glid_info[j];

            if (other != room) {
                if (room->x == other->x) {
                    if (other->y == room->y - 1) {
                        room->link_glid[GLID_DIR_UP] = other;
                    }

                    if (other->y == room->y + 1) {
                        room->link_glid[GLID_DIR_DOWN] = other;
                        break;
                    }
                }

                if (room->y == other->y) {
                    if (other->x == room->x - 1) {
                        room->link_glid[GLID_DIR_LEFT] = other;
                    }

                    if (other->x == room->x + 1) {
                        room->link_glid[GLID_DIR_RIGHT] = other;
                    }
                }
            }
        }
    }
}

void CDngFloorManager::CheckDrawGlidInfo() {
    CSaveDataDungeon *save = {};
    GLID_INFO        *next = {};
    GLID_INFO        *root = {};
    DNGMAP_ROOM_INFO *floor_room = {};
    DNGMAP_ROOM_INFO *next_room = {};
    DNG_FLOOR_SAVE   *floor = {};
    DNG_FLOOR_SAVE   *next_floor = {};
    int               i = {};
    int               dir = {};
    int               search_dir = {};
    int               open = {};
    int               opened = {};

    save = menu_GetSaveDataDungeon();

    if (save == nullptr) {
        return;
    }

    int floor_num[DNGMAP_DUNGEON_NUM] = {9, 16, 25, 21, 23, 29, 39};

    for (int floor_no = 0; floor_no < floor_num[dng_no]; floor_no++) {
        floor = save->GetFloorInfoPtr(dng_no, floor_no);
        floor_room = GetDngMapFloorInfo(floor_no);

        if (floor != nullptr && floor_room != nullptr) {
            floor_room->visited = false;

            if (floor != nullptr && floor->visit_count > 0) {
                floor_room->visited = true;
            }
        }
    }

    for (int n = 0; n < glid_num; n++) {
        GLID_INFO *glid = &glid_info[n];

        if (glid != nullptr) {
            glid->blink = false;
        }
    }

    for (i = 0; i < glid_num; i++) {
        GLID_INFO *glid = &glid_info[i];

        if (glid->type == GLID_TYPE_ROOM) {
            DNGMAP_ROOM_INFO *room = &glid->room;

            for (dir = 0; dir < GLID_DIR_NUM; dir++) {
                next = GetNextRoom(room->floor_id, dir, nullptr, -1, nullptr);

                if (next != nullptr && next != glid && next->type == GLID_TYPE_ROOM) {
                    save->GetFloorInfoPtr(dng_no, next->room.floor_id);
                }
            }

            room->selectable = true;
            floor = save->GetFloorInfoPtr(dng_no, room->floor_id);
            room->mark = false;

            if (floor != nullptr && (floor->flag & DNG_FLOOR_FLAG_OPEN) && !(floor->flag & DNG_FLOOR_FLAG_CLEAR)) {
                room->mark = true;
            }
        }
    }

    for (i = 0; i < glid_num; i++) {
        GLID_INFO *glid = &glid_info[i];

        if (glid->type == GLID_TYPE_ROOM) {
            DNGMAP_ROOM_INFO *room = &glid->room;
            floor = save->GetFloorInfoPtr(dng_no, glid->room.floor_id);

            for (dir = 0; dir < GLID_DIR_NUM; dir++) {
                search_dir = dir;
                next = GetNextRoom(room->floor_id, dir, nullptr, -1, nullptr);

                if (next == nullptr || next == glid || search_dir != dir) {
                    continue;
                }

                open = false;
                opened = false;
                next_room = &next->room;
                next_floor = nullptr;

                if (next_room != nullptr) {
                    next_floor = save->GetFloorInfoPtr(dng_no, next_room->floor_id);
                }

                if (next_floor != nullptr && floor != nullptr && (floor->flag & DNG_FLOOR_FLAG_OPEN) && (next_floor->flag & DNG_FLOOR_FLAG_OPEN)) {
                    open = true;
                    opened = open;
                }

                root = GetNextGlid(glid, &search_dir);

                while (root != next && root != nullptr && next != nullptr) {
                    if (root->type != GLID_TYPE_ROOT) {
                        break;
                    }

                    root->root.open = open != 0;
                    root->root.opened |= opened;
                    root = GetNextGlid(root, &search_dir);
                }
            }
        }
    }
}

GLID_INFO *CDngFloorManager::GetNextGlid(GLID_INFO *glid, int *index) {
    int        k = {};
    int       *row = {};
    int        current = {};
    GLID_INFO *result = {};
    GLID_INFO *room = glid;

    if (glid == nullptr) {
        return nullptr;
    }

    current = *index;

    if (dng_no == 2) {
        static int search_tbl[GLID_DIR_NUM][3] = {
            {GLID_DIR_UP,    GLID_DIR_LEFT,  GLID_DIR_RIGHT},
            {GLID_DIR_DOWN,  GLID_DIR_RIGHT, GLID_DIR_LEFT },
            {GLID_DIR_LEFT,  GLID_DIR_DOWN,  GLID_DIR_UP   },
            {GLID_DIR_RIGHT, GLID_DIR_UP,    GLID_DIR_DOWN },
        };
        row = search_tbl[current];
    } else if (dng_no == 3) {
        static int search_tbl[GLID_DIR_NUM][3] = {
            {GLID_DIR_UP,    GLID_DIR_LEFT,  GLID_DIR_RIGHT},
            {GLID_DIR_DOWN,  GLID_DIR_RIGHT, GLID_DIR_LEFT },
            {GLID_DIR_LEFT,  GLID_DIR_UP,    GLID_DIR_DOWN },
            {GLID_DIR_RIGHT, GLID_DIR_UP,    GLID_DIR_DOWN },
        };
        row = search_tbl[current];
    } else {
        static int search_tbl[GLID_DIR_NUM][3] = {
            {GLID_DIR_UP,    GLID_DIR_LEFT, GLID_DIR_RIGHT},
            {GLID_DIR_DOWN,  GLID_DIR_LEFT, GLID_DIR_RIGHT},
            {GLID_DIR_LEFT,  GLID_DIR_UP,   GLID_DIR_DOWN },
            {GLID_DIR_RIGHT, GLID_DIR_UP,   GLID_DIR_DOWN },
        };
        row = search_tbl[current];
    }

    for (k = 0; k < 3; k++) {
        if (room->link_glid[row[k]] != nullptr) {
            *index = row[k];
            break;
        }
    }

    current = *index;
    result = nullptr;

    if (0 <= current) {
        result = room->link_glid[current];
    }

    return result;
}

GLID_INFO *CDngFloorManager::GetNextRoom(int floor_id, int dir, GLID_INFO *glid, int unused,
                                         int *out_dir) {
    GLID_INFO        *room = {};
    int              *row = {};
    int               i = {};
    int               k = {};
    s16               next = {};
    DNGMAP_ROOM_INFO *info = {};

    room = GetDngMapFloorGlidInfo(floor_id);

    if (room == nullptr) {
        return nullptr;
    }

    if (room->type != GLID_TYPE_ROOM) {
        return nullptr;
    }

    int dirs[GLID_DIR_NUM][3] = {
        {GLID_DIR_UP,    GLID_DIR_LEFT,  GLID_DIR_RIGHT},
        {GLID_DIR_DOWN,  GLID_DIR_RIGHT, GLID_DIR_LEFT },
        {GLID_DIR_LEFT,  GLID_DIR_UP,    GLID_DIR_DOWN },
        {GLID_DIR_RIGHT, GLID_DIR_DOWN,  GLID_DIR_DOWN },
    };
    row = dirs[dir];
    info = &room->room;

    i = 0;

    while (++i < GLID_DIR_NUM) {
    }

    for (k = 0; k < 2; k++) {
        next = info->link[row[k]];

        if (0 <= next) {
            room = GetDngMapFloorGlidInfo(next);

            if (out_dir != nullptr) {
                *out_dir = row[k];
            }

            break;
        }
    }

    return room;
}

int CDngFloorManager::GetDngMapNextFloorID(int floor_id, int root_type) {
    GLID_INFO        *room = {};
    GLID_INFO        *other = {};
    GLID_INFO        *next = {};
    DNGMAP_ROOM_INFO *info = {};
    int               d = {};
    DNGMAP_ROOM_INFO *other_info = {};
    int               index = {};

    room = GetDngMapFloorGlidInfo(floor_id);

    if (room == nullptr) {
        return 0;
    }

    if (dng_no == 2) {
        if (floor_id == 8) {
            return 8;
        }
    }

    info = &room->room;

    for (d = 0; d < GLID_DIR_NUM; d++) {
        if (info->link[d] >= 0) {
            other = GetDngMapFloorGlidInfo(info->link[d]);

            if (other != nullptr) {
                other_info = &other->room;

                if (other_info != nullptr && other_info->order > info->order) {
                    index = d;
                    next = GetNextGlid(room, &index);

                    if (next != nullptr && next->type == GLID_TYPE_ROOT && next->root.type == root_type) {
                        return other_info->floor_id;
                    }
                }
            }
        }
    }

    return 0;
}

char *CDngFloorManager::GetFloorTitle(int floor_id) {
    DNGMAP_ROOM_INFO *info = GetDngMapFloorInfo(floor_id);

    if (dng_no == 1 && floor_id == DNGMAP_FLOOR_SPECIAL) {
        static char *fl_t[2] = {"\x95|\x82\xA2\x90X", "Wonder Forest"};
        int          language = LanguageCode;

        if (language > LANG_ENGLISH) {
            language = LANG_ENGLISH;
        }

        return fl_t[language];
    }

    if (info == nullptr) {
        return nullptr;
    }

    return info->title;
}

int CDngFloorManager::GetDngMapNextRoot(int floor_id) {
    GLID_INFO        *room = {};
    GLID_INFO        *other = {};
    GLID_INFO        *next = {};
    int               mask = {};
    DNGMAP_ROOM_INFO *info = {};
    DNGMAP_ROOM_INFO *other_info = {};
    int               d = {};
    int               index = {};

    if (floor_id == DNGMAP_FLOOR_SPECIAL) {
        return 1;
    }

    room = GetDngMapFloorGlidInfo(floor_id);
    mask = 0;

    if (room == nullptr) {
        return 0;
    }

    info = &room->room;

    for (d = 0; d < GLID_DIR_NUM; d++) {
        if (info->link[d] >= 0) {
            other = GetDngMapFloorGlidInfo(info->link[d]);

            if (other != nullptr) {
                other_info = &other->room;

                if (other_info != nullptr && other_info->order > info->order) {
                    index = d;
                    next = GetNextGlid(room, &index);

                    if (next != nullptr && next->type == GLID_TYPE_ROOT) {
                        mask |= 1 << next->root.type;
                    }
                }
            }
        }
    }

    return mask;
}

int GetCountSphedaClear() {
    CSaveDataDungeon *save = {};
    int               count = {};
    int               dungeon = {};
    int               floor = {};
    DNG_FLOOR_SAVE   *info = {};

    save = menu_GetSaveDataDungeon();
    count = 0;

    if (save == nullptr) {
        return 0;
    }

    for (dungeon = 0; dungeon < SAVE_DUNGEON_NUM; dungeon++) {
        for (floor = 0; floor < DNGMAP_FLOOR_NUM; floor++) {
            info = save->GetFloorInfoPtr(dungeon, floor);

            if (info == nullptr) {
                break;
            }

            if (info->spheda_clear > 0) {
                count += 1;
            }
        }
    }

    return count;
}

int CheckFishingRecord(float size) {
    CSaveDataDungeon *save = {};
    CDngFloorManager *floors = {};
    DNG_FLOOR_SAVE   *save_info = {};
    DNGMAP_ROOM_INFO *info = {};
    int               centimeters = {};
    int               met = {};
    s8                kind = {};
    u16               flags = {};

    save = menu_GetSaveDataDungeon();

    if (save == nullptr) {
        return false;
    }

    floors = &menu_GetBattleAreaScene()->floor_manager;
    save_info = save->GetFloorInfoPtr(save->stage_id, save->floor_id[save->stage_id]);
    info = floors->GetDngMapFloorInfo(save->floor_id[save->stage_id]);

    if (save_info == nullptr || info == nullptr) {
        return false;
    }

    kind = info->fishing;

    if (kind == 0) {
        return false;
    }

    centimeters = fptosi(100.0f * size);
    met = false;

    if (kind < 0) {
        if (centimeters <= info->fishing_record) {
            met = true;
        }
    }

    if (0 < kind) {
        if (info->fishing_record <= centimeters) {
            met = true;
        }
    }

    if (met) {
        flags = save_info->flag;

        if (!(flags & DNG_FLOOR_FLAG_FISHING_CLEAR)) {
            save_info->flag = flags | DNG_FLOOR_FLAG_FISHING_CLEAR;
            GetUserDataMan()->AddYarikomiMedal(1);
            return true;
        }
    }

    return false;
}

// nlohmann must precede the game headers, whose macros it would otherwise see.
// clang-format off
// clang-format on

#include "common.h"

#include <algorithm>
#include <array>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <iterator>
#include <memory>
#include <new>
#include <optional>
#include <stdexcept>
#include <string>
#include <string_view>
#include <vector>

#include "dataread.hpp"
#include "dngfloor.hpp"
#include "menucommon.hpp"
#include "mg_memory.hpp"
#include "scriptinterpreter.hpp"
#include "stubs/dngfloor.hpp"

namespace {

// Retail's stack scratch, which flrtitle<n>.txt still has to fit.
constexpr int kRetailScratch = 0xA000;

/**
 * Room offset that a sub or boss room is drawn at.
 */
constexpr s16 kSubRoomOffsetY = -0x1A;

/**
 * Description of a passage cell of a dungeon_map document.
 */
struct MapRoot {
    int type;      /**< Kind of passage. */
    int shape;     /**< Shape the passage is drawn with. */
    int show_mark; /**< Non-zero to draw the passage's type mark once opened. */
};

/**
 * Description of a room cell of a dungeon_map document.
 */
struct MapRoom {
    int                                     floor_id; /**< Floor the room stands for. */
    int                                     order;    /**< Position of the floor along the dungeon. */
    std::optional<std::string>              name;     /**< CP932 name kept in DNGMAP_ROOM_INFO::unk_0, when given. */
    std::vector<int>                        link;     /**< Floor reached in each direction, as given. */
    std::optional<int>                      tex_no;   /**< Picture number; a negative one picks from a group at load. */
    std::optional<std::array<int, 4>>       key_room; /**< Floor that each direction's key leads to. */
    std::vector<std::optional<std::string>> options;  /**< Option name of each RI_OP, or nothing for an unreadable one. */
};

/**
 * One cell of a dungeon_map document.
 */
struct MapCell {
    int                    type;  /**< Kind of cell, a GLID_TYPE. */
    int                    x;     /**< Column of the cell. */
    int                    y;     /**< Row of the cell. */
    int                    unk_6; /**< Value stored in GLID_INFO::unk_6. */
    int                    unk_8; /**< Value stored in GLID_INFO::unk_8. */
    std::optional<MapRoot> root;  /**< Passage description, for an RT cell. */
    std::optional<MapRoom> room;  /**< Room description, for an RI cell. */
};

/**
 * Typed contents of a dungeon_map document.
 */
struct DungeonMap {
    int                  glid_w; /**< Width of the grid, in cells. */
    int                  glid_h; /**< Height of the grid, in cells. */
    std::vector<MapCell> cells;  /**< Cells of the grid, in script order. */
};

/**
 * Challenges of one floor, as RF_INFO gives them.
 */
struct FloorInfo {
    int                geostone;          /**< Non-zero when the floor holds a geostone. */
    int                fast_destroy_time; /**< Target clear time of the fast destroy challenge. */
    int                fishing;           /**< Fishing record test direction. */
    int                fishing_record;    /**< Size the fishing record test compares with. */
    int                seal;              /**< Seal on the floor, a DNGMAP_SEAL. */
    int                spheda;            /**< Non-zero when the floor has a spheda challenge. */
    std::array<int, 3> spheda_prize_item; /**< Prize of the spheda challenge, by rank. */
    std::array<int, 3> spheda_prize_num;  /**< Number given of each prize, by rank. */
};

/**
 * Practice condition of one floor, as RF_INFO2 gives it.
 */
struct FloorPractice {
    int type;  /**< Kind of practice condition. */
    int param; /**< Value the condition is tested against. */
};

/**
 * One floor of a dungeon_floors document.
 */
struct DungeonFloor {
    int                          floor;    /**< Floor number. */
    std::optional<FloorInfo>     info;     /**< Challenges, when given. */
    std::optional<FloorPractice> practice; /**< Practice condition, when given. */
};

/**
 * Largest cell count of a tree map grid, far above any retail dungeon, so its table size stays in range.
 */
constexpr std::size_t kGridCellMax = 0x10000;

/**
 * Parses a room description of a dungeon_map cell.
 */
MapRoom ParseMapRoom(const native_config::Json &room) {
    using namespace native_config;
    MapRoom out{.floor_id = Int(room, "floor_id"),
                .order = Int(room, "order"),
                .name = OptionalText(room, "name"),
                .link = room.contains("link") ? IntList(room, "link") : std::vector<int>{},
                .tex_no = OptionalInt(room, "tex_no"),
                .key_room = std::nullopt,
                .options = {}};
    // RI reads its third operand and discards it; it is only checked to be an integer.
    OptionalInt(room, "unused");
    if (room.contains("key_room")) {
        out.key_room = Ints<4>(room, "key_room");
    }
    for (const auto &option : OptionalArray(room, "options")) {
        out.options.push_back(GameText(option));
    }
    return out;
}

/**
 * Parses a dungeon_map document.
 */
DungeonMap ParseDungeonMap(const native_config::Json &document) {
    using namespace native_config;
    DungeonMap  map{.glid_w = Int(document, "glid_w"), .glid_h = Int(document, "glid_h"), .cells = {}};
    const auto &cells = Array(document, "cells");
    if (cells.size() > kGridCellMax) {
        throw std::runtime_error("tree map has too many cells");
    }
    for (const auto &cell : cells) {
        MapCell out{.type = Int(cell, "type"),
                    .x = Int(cell, "x"),
                    .y = Int(cell, "y"),
                    .unk_6 = Int(cell, "unk_6"),
                    .unk_8 = Int(cell, "unk_8"),
                    .root = std::nullopt,
                    .room = std::nullopt};
        if (cell.contains("root") && cell.contains("room")) {
            throw std::runtime_error("a cell is a root or a room, not both");
        }
        if (cell.contains("root")) {
            const auto &root = At(cell, "root");
            out.root = MapRoot{.type = Int(root, "type"), .shape = Int(root, "shape"), .show_mark = Int(root, "show_mark")};
        }
        if (cell.contains("room")) {
            out.room = ParseMapRoom(At(cell, "room"));
        }
        map.cells.push_back(std::move(out));
    }
    return map;
}

/**
 * Parses a dungeon_floors document.
 */
std::vector<DungeonFloor> ParseDungeonFloors(const native_config::Json &document) {
    using namespace native_config;
    std::vector<DungeonFloor> floors;
    for (const auto &floor : Array(document, "floors")) {
        DungeonFloor out{.floor = Int(floor, "floor"), .info = std::nullopt, .practice = std::nullopt};
        if (floor.contains("info")) {
            const auto &info = At(floor, "info");
            out.info = FloorInfo{.geostone = Int(info, "geostone"),
                                 .fast_destroy_time = Int(info, "fast_destroy_time"),
                                 .fishing = Int(info, "fishing"),
                                 .fishing_record = Int(info, "fishing_record"),
                                 .seal = Int(info, "seal"),
                                 .spheda = Int(info, "spheda"),
                                 .spheda_prize_item = Ints<3>(info, "spheda_prize_item"),
                                 .spheda_prize_num = Ints<3>(info, "spheda_prize_num")};
        }
        if (floor.contains("practice")) {
            const auto &practice = At(floor, "practice");
            out.practice = FloorPractice{.type = Int(practice, "type"), .param = Int(practice, "param")};
        }
        floors.push_back(out);
    }
    return floors;
}

/**
 * Gives the room flags of an option name, or -1 for a name RI_OP's table does not hold.
 */
int RoomOptionFlag(const std::optional<std::string> &name) {
    struct Option {
        std::string_view name; /**< Option name. */
        int              flag; /**< Flag the name sets. */
    };

    static constexpr Option kOptions[] = {
        {.name = "start", .flag = DNGMAP_ROOM_FLAG_START},
        {.name = "exit",  .flag = DNGMAP_ROOM_FLAG_EXIT },
        {.name = "boss",  .flag = DNGMAP_ROOM_FLAG_BOSS },
        {.name = "sub",   .flag = DNGMAP_ROOM_FLAG_SUB  },
    };
    for (const auto &option : kOptions) {
        if (name && *name == option.name) {
            return option.flag;
        }
    }
    return -1;
}

/**
 * Gives the picture number RI_TEX stores, picking one of a group's four pictures for a negative number.
 */
int RoomTexture(int texture_no) {
    if (texture_no >= 0) {
        return texture_no;
    }
    // Retail reads past its group table for a group above five; the port uses the last group.
    const int groups = static_cast<int>(std::size(offsetTable_911));
    const int texture_group = texture_no < -groups ? groups : -texture_no;
    return GetRandI(4) + offsetTable_911[texture_group - 1];
}

/**
 * Fills a room cell's description as RI, RI_LINK, RI_TEX, RI_KEYROOM and RI_OP do.
 */
void ApplyMapRoom(DNGMAP_ROOM_INFO &info, const MapRoom &room, mgCMemory *memory) {
    info.floor_id = static_cast<s8>(room.floor_id);
    info.order = static_cast<s8>(room.order);
    info.unk_0 = nullptr;
    if (room.name) {
        std::string name = *room.name;
        info.unk_0 = mgCopyString(name.data(), memory);
    }
    info.selectable = false;
    info.visited = false;
    info.flag = DNGMAP_ROOM_FLAG_ROOM;
    info.offset_y = 0;
    info.offset_x = 0;
    info.practice_type = -1;
    info.mark_phase = 0.0f;
    info.unk_4c = 0;

    // Retail writes past the four links for a longer list; the port keeps the first four.
    for (std::size_t i = 0; i < room.link.size() && i < std::size(info.link); ++i) {
        info.link[i] = static_cast<s16>(room.link[i]);
    }
    if (room.tex_no) {
        info.tex_no = static_cast<s8>(RoomTexture(*room.tex_no));
    }
    if (room.key_room) {
        for (std::size_t i = 0; i < std::size(info.key_room); ++i) {
            info.key_room[i] = static_cast<s16>((*room.key_room)[i]);
        }
    }
    for (const auto &option : room.options) {
        info.flag |= static_cast<u32>(DNGMAP_ROOM_FLAG_ROOM | RoomOptionFlag(option));
        if ((info.flag & DNGMAP_ROOM_FLAG_SUB) || (info.flag & DNGMAP_ROOM_FLAG_BOSS)) {
            info.offset_x = 0;
            info.offset_y = kSubRoomOffsetY;
        }
    }
}

/**
 * Builds the tree map grid as TREE_INFO and each cell's GI, RT and room tags do.
 */
void ApplyDungeonMap(CDngFloorManager &manager, const DungeonMap &map, mgCMemory *memory) {
    const auto count = static_cast<int>(map.cells.size());
    const u32  bytes = static_cast<u32>(count) * sizeof(GLID_INFO);
    manager.glid_w = static_cast<s16>(map.glid_w);
    manager.glid_h = static_cast<s16>(map.glid_h);
    const u32 blocks = (bytes & 0xF) != 0 ? (bytes >> 4) + 1 : bytes >> 4;
    manager.glid_info = new (memory->Alloc(static_cast<int>(blocks) + 2)) GLID_INFO[count];
    manager.glid_num = count;

    for (int i = 0; i < count; ++i) {
        const MapCell &cell = map.cells[i];
        GLID_INFO     &glid = manager.glid_info[i];
        glid.type = static_cast<s16>(cell.type);
        glid.x = static_cast<s16>(cell.x);
        glid.y = static_cast<s16>(cell.y);
        glid.unk_6 = static_cast<s16>(cell.unk_6);
        glid.unk_8 = static_cast<s16>(cell.unk_8);
        std::ranges::fill(glid.link_glid, nullptr);
        glid.blink = false;
        std::memset(&glid.room, 0, sizeof(glid.room));
        std::memset(&glid.root, 0, sizeof(glid.root));
        if (cell.root) {
            glid.root.type = static_cast<u8>(cell.root->type);
            glid.root.shape = static_cast<u8>(cell.root->shape);
            glid.root.show_mark = static_cast<u8>(cell.root->show_mark);
        } else if (cell.room) {
            ApplyMapRoom(glid.room, *cell.room, memory);
        }
    }
}

/**
 * Sets each listed floor's challenges and practice condition as RF_INFO and RF_INFO2 do.
 */
void ApplyDungeonFloors(CDngFloorManager &manager, const std::vector<DungeonFloor> &floors) {
    for (const auto &floor : floors) {
        DNGMAP_ROOM_INFO *info = manager.GetDngMapFloorInfo(floor.floor);
        if (info == nullptr) {
            continue;
        }
        if (floor.info) {
            const FloorInfo &values = *floor.info;
            info->geostone = static_cast<s8>(values.geostone);
            info->fast_destroy_time = values.fast_destroy_time;
            info->fishing = static_cast<s8>(values.fishing);
            info->fishing_record = static_cast<s16>(values.fishing_record);
            info->seal = static_cast<s8>(values.seal);
            info->spheda = static_cast<s8>(values.spheda);
            for (int i = 0; i < DNGMAP_SPHEDA_PRIZE_NUM; ++i) {
                info->spheda_prize_item[i] = static_cast<s16>(values.spheda_prize_item[i]);
                info->spheda_prize_num[i] = static_cast<s8>(values.spheda_prize_num[i]);
            }
        }
        if (const auto practice = floor.practice) {
            info->practice_type = static_cast<s8>(practice->type);
            info->practice_param = practice->param;
        }
    }
}

/**
 * Runs one table over the manager between the arena alignment and grid relation that AnalyzeFile wraps it in.
 */
template <typename Apply>
void AnalyzeTable(CDngFloorManager &manager, mgCMemory *memory, Apply apply) {
    tree_spi_stack = memory;
    tree_dngmap = &manager;
    memory->Align64();
    apply();
    memory->Align64();
    manager.RelationGlid();
}

/**
 * Reads a converted dmap<n>.cfg or dflr<n>.cfg table and runs it over the manager; false when it is not one.
 */
bool AnalyzeNativeTable(CDngFloorManager &manager, const std::string &path, mgCMemory *memory) {
    const std::string_view leaf = std::string_view(path).substr(path.rfind('/') + 1);
    if (leaf.starts_with("dflr")) {
        if (const auto floors = native_config::Read<std::vector<DungeonFloor>>(path, "dungeon_floors", ParseDungeonFloors)) {
            AnalyzeTable(manager, memory, [&] { ApplyDungeonFloors(manager, *floors); });
        }
        return true;
    }
    if (leaf.starts_with("dmap")) {
        if (const auto map = native_config::Read<DungeonMap>(path, "dungeon_map", ParseDungeonMap)) {
            AnalyzeTable(manager, memory, [&] { ApplyDungeonMap(manager, *map, memory); });
        }
        return true;
    }
    return false;
}

} // namespace

// The converted map and floor tables are native documents; any other buffer, such as flrtitle<n>.txt,
// is a text script that retail's tag table still reads.
void CDngFloorManager::AnalyzeFile(char *data, int size, mgCMemory *memory) {
    const auto path = native_config::BufferPath(data);
    if (path && path->ends_with(".json") && AnalyzeNativeTable(*this, *path, memory)) {
        return;
    }
    AnalyzeTable(*this, memory, [&] {
        CScriptInterpreter interpreter;
        interpreter.SetTag(tree_map_tag);
        interpreter.SetScript(data, size);
        interpreter.Run();
    });
}

// The names are the converted ones: the build rewrites retail literals in ps2/src, not in a port
// override. The tables are read as documents; only flrtitle<n>.txt still goes through a scratch.
void CDngFloorManager::LoadDataTable(int dungeon, mgCMemory *memory) {
    char menu_path[0x40];

    if (memory == nullptr) {
        return;
    }

    if (dungeon < 0 || dungeon >= DNGMAP_DUNGEON_NUM) {
        dungeon = 0;
    }

    Initialize();
    dng_no = dungeon;

    for (const char *stem : {"dmap", "dflr"}) {
        char path[0x60];
        std::snprintf(path, sizeof path, "menu/dngmap/%s%d.cfg.json", stem, dungeon);
        AnalyzeNativeTable(*this, path, memory);
    }

    // Room for the reader's sector padding and MenuCalcBufAlignment's rounding.
    const std::size_t bytes = static_cast<std::size_t>(kRetailScratch) + DATAREAD_SECTOR_SIZE + 64;
    const std::size_t scratch_count = bytes / sizeof(u_long128) + 1;
    const auto        scratch = std::make_unique<u_long128[]>(scratch_count);
    u_long128        *data = MenuCalcBufAlignment(scratch.get());

    std::snprintf(menu_path, sizeof menu_path, "flrtitle%d.txt", dungeon);
    const auto aligned_count = scratch_count - static_cast<std::size_t>(data - scratch.get());
    const int  size = LoadFileMenu(menu_path, std::span(reinterpret_cast<u8 *>(data), aligned_count * sizeof(u_long128)), MENU_FILE_LOAD_DIRECT);

    if (size > 0) {
        AnalyzeFile(reinterpret_cast<char *>(data), size, memory);
    }
}
