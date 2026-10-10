#include "common.h"
#include "mw_runtime.h"
#define DNG_DEBUG_SOURCE
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "actionchara.hpp"
#include "automap.hpp"
#include "cameracontrol.hpp"
#include "character.hpp"
#include "dng_debug.hpp"
#include "dng_effect.hpp"
#include "dng_event.hpp"
#include "dng_main.hpp"
#include "dng_status.hpp"
#include "effscript.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "font.hpp"
#include "mainloop.hpp"
#include "maintex.hpp"
#include "mapload.hpp"
#include "menucommon.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "prespr.hpp"
#include "quest.hpp"
#include "savedatadungeon.hpp"
#include "sceneevent.hpp"
#include "snd_mngr.hpp"
#include "snd_seseq.hpp"

static char *command_str[] = {
    "RunEvent      ",
    "EnemyLoader   ",
    "DebugCamera   ",
    "CharaMove     ",
    "EnemyReset    ",
    "LockOnMode    ",
    "Infomation    ",
    "SkipFloor     ",
    "Sound Flag    ",
    "Monster Talk  ",
    "Effect_id     ",
    "Effect_Vol    ",
    NULL,
};
extern CFont dbFont;

#include "colprim.hpp"
#include "gamepad.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "userdata.hpp"

static int command_int[23] = {
    100,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    1,
    0,
    0,
    0,
    0,
    0,
    0,
};

/**
 *
 * Closes the dungeon debug menu and applies its edited settings.
 *
 */
static void dngDebugExit();

/**
 *
 * Loads a chosen monster kind beside the player, refreshing monster memory on the first load.
 *
 */
/**
 *
 * Draws the first dungeon system-parameter panel.
 *
 */
/**
 *
 * Draws the second dungeon system-parameter panel.
 *
 */

// Code (.text)
DNG_DEBUG_INFO *dngGetDebugInfo() { return &dbinfo; }

void dngDebugInit() {
    dbinfo.active = 0;
    dbinfo.cursor = 0;
    dbinfo.sound_flag = 1;
    dbinfo.monster_talk = 0;
    dbinfo.effect_id = 0;
    dbinfo.effect_vol = 0.0f;
    dbFont.Init();
    dbFont.SetClearance(20, 20);
}

void dngDebugStart() {
    dbinfo.active = 1;
    dbinfo.command = -1;
    dbinfo.first_enemy_load = 1;
    command_int[DNG_DEBUG_CMD_DEBUG_CAMERA * 2] = DebugInfo.debug_camera;
    command_int[DNG_DEBUG_CMD_CHARA_MOVE * 2] = DebugInfo.chara_move;
    command_int[DNG_DEBUG_CMD_LOCK_ON_MODE * 2] = BattleAreaScene->lock_on_mode;
    command_int[DNG_DEBUG_CMD_SOUND_FLAG * 2] = dbinfo.sound_flag;
    command_int[DNG_DEBUG_CMD_MONSTER_TALK * 2] = dbinfo.monster_talk;
    command_int[DNG_DEBUG_CMD_EFFECT_ID * 2] = dbinfo.effect_id;
    command_int[DNG_DEBUG_CMD_EFFECT_VOL * 2] = (int) dbinfo.effect_vol;
    GamePad__2.SetAutoRepeat(PAD_UP | PAD_RIGHT | PAD_DOWN | PAD_LEFT, 15, 4);
    GamePad__2.SetAutoRepeat(PAD_UP | PAD_DOWN, 8, 1);
    dbinfo.saved_pause_flag = BattleAreaScene->pause_flag;
    BattleAreaScene->pause_flag = 15;
}

void dngDebugDraw() {
    if (dbinfo.active != 0) {
        (mgTexManager).ReloadTexture(0x6C, (sceVif1Packet *) NULL);

        CPreSprite sprite;
        char       text[0x800];
        char      *cursor;
        int        i;
        sprite.Initialize(0, 0);
        sprite.Preset2D();
        sprite.TextureMapEnable(0);
        sprite.Begin(MG_PRIM_SPRITE);
        sprite.Color(0x10, 0x10, 0x10, 0x48);
        sprite.Vertex(0xE, 0x46, 0);
        sprite.Vertex(0x104, 0x14C, 0);
        sprite.End();
        cursor = text;
        cursor += sprintf(cursor, "--== DEBUG MENU ==--\n");

        for (i = 0; command_str[i] != NULL; i++) {
            if (i == dbinfo.cursor) {
                cursor += sprintf(cursor, "->");
            } else {
                cursor += sprintf(cursor, "  ");
            }

            cursor += sprintf(cursor, command_str[i]);
            cursor += sprintf(cursor, "%d\n", command_int[i * 2]);
        }

        if (dbinfo.cursor == 1) {
            cursor += sprintf(cursor, "\n");
            int selected = command_int[2];
            int k = 0;
            int found = -1;

            for (; base_monster_define[k].id != -1; k++) {
                if (selected == base_monster_define[k].id) {
                    cursor += sprintf(cursor, "[G%d]%s\n", base_monster_define[k].grade, base_monster_define[k].name);
                    found = k;
                    break;
                }
            }

            if (found == -1) {
                sprintf(cursor, "[%d]--------\n", command_int[2]);
            } else if (base_monster_define[found].grade > 0) {
                for (i = 0; base_monster_define[i].id != -1; i++) {
                    if (base_monster_define[i].gift_type == base_monster_define[found].gift_type) {
                        sprintf(cursor, "BASE > %s\n", base_monster_define[i].name);
                        break;
                    }
                }
            }
        }

        dbFont.DrawDirect(text, 0x10, 0x48);
    }
}

/**
 *
 * Restores dungeon debug settings and resumes normal gamepad behavior.
 *
 */
static void dngDebugExit() {
    dbinfo.active = 0;
    GamePad__2.AutoRepeatOff();
    BattleAreaScene->pause_flag = dbinfo.saved_pause_flag;
    DebugInfo.debug_camera = command_int[DNG_DEBUG_CMD_DEBUG_CAMERA * 2];
    DebugInfo.chara_move = command_int[DNG_DEBUG_CMD_CHARA_MOVE * 2];
    BattleAreaScene->lock_on_mode = command_int[DNG_DEBUG_CMD_LOCK_ON_MODE * 2];
    dbinfo.sound_flag = command_int[DNG_DEBUG_CMD_SOUND_FLAG * 2];
    dbinfo.monster_talk = command_int[DNG_DEBUG_CMD_MONSTER_TALK * 2];
    dbinfo.effect_id = command_int[DNG_DEBUG_CMD_EFFECT_ID * 2];
    dbinfo.effect_vol = (float) command_int[DNG_DEBUG_CMD_EFFECT_VOL * 2];
}

int dngDebugKey() {
    if (!dbinfo.active) {
        return 0;
    }

    if (GamePad__2.Down(PAD_DOWN) && dbinfo.cursor < DNG_DEBUG_CMD_NUM - 1) {
        ++dbinfo.cursor;
    }

    if (GamePad__2.Down(PAD_UP) && dbinfo.cursor > 0) {
        --dbinfo.cursor;
    }

    int &value = command_int[dbinfo.cursor * 2];

    if (GamePad__2.Down(PAD_RIGHT)) {
        ++value;
    }

    if (GamePad__2.Down(PAD_LEFT)) {
        --value;
    }

    int step = dbinfo.cursor == DNG_DEBUG_CMD_ENEMY_LOADER ? 4 : 10;

    if (GamePad__2.Down(PAD_R1)) {
        value += step;
    }

    if (GamePad__2.Down(PAD_L1)) {
        value -= step;
    }

    if (GamePad__2.Down(PAD_R2)) {
        value += 100;
    }

    if (GamePad__2.Down(PAD_L2)) {
        value -= 100;
    }

    if (value <= command_int[dbinfo.cursor * 2 + 1]) {
        value = command_int[dbinfo.cursor * 2 + 1];
    }

    if (GamePad__2.Down(PAD_CIRCLE)) {
        if (dbinfo.cursor == DNG_DEBUG_CMD_RUN_EVENT) {
            dbinfo.command = dbinfo.cursor;
            dbinfo.event_no = command_int[dbinfo.cursor * 2];
            dngDebugExit();
            return 1;
        }

        if (dbinfo.cursor == DNG_DEBUG_CMD_ENEMY_LOADER) {
            DBGCMD_ReloadEnemy(command_int[2], dbinfo.first_enemy_load);
            dbinfo.first_enemy_load = 0;
        }

        if (dbinfo.cursor == DNG_DEBUG_CMD_ENEMY_RESET) {
            int                  index;
            CTreasureBoxManager *boxes;
            boxes = DngMainScene->battle_area.treasure_box;

            if (boxes != NULL) {
                index = 0;

                do {
                    boxes->box[index].Initialize();
                    index++;
                } while (index < 24);
            }

            ActiveMonster->Initialize(DngMainScene);
            DngSaveData->SetBitFlag(0x13D, 1);
            dngDebugExit();
            return 1;
        } else if (dbinfo.cursor == DNG_DEBUG_CMD_SKIP_FLOOR) {
            int floor;
            int dungeon;
            dungeon = DngSaveDataDungeon->stage_id;
            floor = DngSaveDataDungeon->floor_id[dungeon];
            DngUserData->GetItem(GetGateKeyIndex(dungeon, floor), 1);
            DngUserData->GetItem(GetKeyDoorIndex(dungeon, floor), 1);
            DngUserData->GetItem(0x132, 1);
            DngUserData->GetItem(0x131, 1);
            dngDebugExit();
            return 1;
        } else if (dbinfo.cursor == DNG_DEBUG_CMD_SOUND_FLAG) {
            if (command_int[dbinfo.cursor * 2] == 0) {
                DngMainScene->PauseBGM();
            } else {
                DngMainScene->RePlayBGM();
            }
        }
    }

    if (GamePad__2.Down(PAD_R3)) {
        dngDebugExit();
    }

    return 1;
}

void CTreasureBox::Initialize() {
    state = 0;
    lid_open = 0;
    flags = 1;
}

void DBGCMD_ReloadEnemy(int monster_id, int reset) {
    float        spawn_position[4];
    float        spawn_direction[4];
    CCharacter2 *player = DngMainScene->GetCharacter(0);

    if (ActiveMonster != 0) {
        mgCMemory *stack;

        if (reset != 0) {
            FxScriptMan->AllClearEffSpt();
            (BuffEffectScriptData).ClearHeapMem();
            ActiveMonster->Initialize(DngMainScene);
            DngMainScene->AssignStack(3);
            DngMainScene->ClearStack(3);
            int i;
            u8 *manager;
            int offset;
            stack = DngMainScene->GetStack(3);
            manager = (u8 *) ActiveMonster;
            i = 0;
            offset = 0;

            for (; i < 24; i++) {
                void      *buffer = stack->stAlloc64(0xFA0);
                mgCMemory *memory = (mgCMemory *) (manager + offset + 4);
                (memory)->stSetBuffer((u_long128 *) buffer, 0xFA0);
                memory->stack_used = 0;
                offset += 0x30;
                memory->lock = 0;
            }

            sndInitPort(5);
        } else {
            stack = DngMainScene->GetStack(3);
        }

        if (ActiveMonster->SearchBaseIndex(monster_id) < 0) {
            ActiveMonster->EntryRefer(monster_id, stack);
        }

        player->GetPosition(spawn_position);
        spawn_position[0] += (20.0f * (float) rand()) / 2147483648.0f - 10.0f;
        spawn_position[2] += (20.0f * (float) rand()) / 2147483648.0f - 10.0f;
        spawn_direction[3] = 1.0f;
        spawn_direction[2] = 0.0f;
        spawn_direction[1] = 0.0f;
        spawn_direction[0] = 0.0f;
        int index = ActiveMonster->SearchBaseIndex(monster_id);

        if (index != -1) {
            ActiveMonster->SetActiveMonster(index, spawn_position, spawn_direction, -1);
        }
    }
}

/**
 *
 * Draws player position and memory usage in the dungeon debug panel.
 *
 */
void DrawSystemParamInfo() {
    CPreSprite sprite;
    char       text[0x800];
    float      position[4];
    char      *cursor;

    sprite.Initialize(0, 0);
    sprite.Preset2D();
    sprite.TextureMapEnable(0);
    sprite.Begin(MG_PRIM_SPRITE);
    sprite.Color(0x10, 0x10, 0x10, 0x48);
    sprite.Vertex(0xE, 0x116, 0);
    sprite.Vertex(0x104, 0x19C, 0);
    sprite.End();
    cursor = text;
    DngMainScene->GetCharacter(0)->GetPosition(position);
    cursor += sprintf(cursor, "POS %.1f %.1f %.1f\n", position[0], position[1], position[2]);
    cursor += sprintf(cursor, "PRIM %d/%d\n", ColPrimMan.ActivePrimNum(), 0x40);
    mgCMemory *map_stack = (mgCMemory *) DngMainScene->GetStack(1);
    mgCMemory *monster_stack = (mgCMemory *) DngMainScene->GetStack(3);
    DngMainScene->GetStack(4);
    mgCMemory *event_stack = (mgCMemory *) DngMainScene->GetStack(5);
    cursor += sprintf(cursor, "STACK:MAP\t %d\n", (map_stack->stack_used << 4) / 1024);
    cursor += sprintf(cursor, "STACK:MOMS\t %d\n", (monster_stack->stack_used << 4) / 1024);
    sprintf(cursor, "STACK:EVENT  %d/%d\n",
            ((event_stack->stack_size - event_stack->stack_used) << 4) / 1024,
            (event_stack->stack_size << 4) / 1024);
    dbFont.DrawDirect(text, 0x10, 0x118);
}

/**
 *
 * Draws player and target monster details with memory usage in the dungeon debug panel.
 *
 */
void DrawSystemParamInfo2() {
    CPreSprite sprite;
    char       text[0x800];
    float      position[4];
    float      monster_position[4];
    float      monster_height;
    float      monster_width;
    char      *cursor;

    sprite.Initialize(0, 0);
    sprite.Preset2D();
    sprite.TextureMapEnable(0);
    sprite.Begin(MG_PRIM_SPRITE);
    sprite.Color(0x10, 0x10, 0x10, 0x48);
    sprite.Vertex(0xE, 0xB2, 0);
    sprite.Vertex(0x144, 0x198, 0);
    sprite.End();
    cursor = text;
    CActionChara *chara = (CActionChara *) DngMainScene->GetCharacter(0);
    ((CCharacter2 *) chara)->GetPosition(position);

    if (chara->lock_on != 0) {
        int             slot = chara->target_no - 0x18;
        CActiveMonster *monster = ActiveMonster->active[slot];

        if (monster != 0) {
            ((CCharacter2 *) monster)->GetPosition(monster_position);
            monster_height = monster->height;
            monster_width = monster->mons_move_check.radius;
        }
    }

    cursor += sprintf(cursor, "POS %.1f %.1f %.1f\n", position[0], position[1], position[2]);

    if (chara->lock_on != 0) {
        cursor += sprintf(cursor, "MONS POS %.1f %.1f %.1f\n", monster_position[0], monster_position[1],
                          monster_position[2]);
        cursor += sprintf(cursor, "MONS HIGH %.1f   WIDTH %.1f\n", monster_height, monster_width);
    }

    cursor += sprintf(cursor, "PRIM %d/%d\n", ColPrimMan.ActivePrimNum(), 0x40);
    mgCMemory *map_stack = (mgCMemory *) DngMainScene->GetStack(1);
    mgCMemory *monster_stack = (mgCMemory *) DngMainScene->GetStack(3);
    DngMainScene->GetStack(4);
    mgCMemory *event_stack = (mgCMemory *) DngMainScene->GetStack(5);
    cursor += sprintf(cursor, "STACK:MAP\t %d\n", (map_stack->stack_used << 4) / 1024);
    cursor += sprintf(cursor, "STACK:MOMS\t %d\n", (monster_stack->stack_used << 4) / 1024);
    sprintf(cursor, "STACK:EVENT  %d/%d\n",
            ((event_stack->stack_size - event_stack->stack_used) << 4) / 1024,
            (event_stack->stack_size << 4) / 1024);
    dbFont.DrawDirect(text, 0x10, 0xB4);
}

void DrawDebugWindow() {
    if (command_int[DNG_DEBUG_CMD_INFORMATION * 2] == 2) {
        DrawSystemParamInfo();
    }

    if (command_int[DNG_DEBUG_CMD_INFORMATION * 2] == 3) {
        DrawSystemParamInfo2();
    }
}

// Uninitialised data (.bss)
CFont          dbFont;
DNG_DEBUG_INFO dbinfo;
