#include "common.h"
#include "mg_drawprim.hpp"
#include "automap.hpp"
#include "effscript.hpp"
#include "maintex.hpp"
#include "mainloop.hpp"
#include "cameracontrol.hpp"
#include "event_func.hpp"
#include "event.hpp"
#include "menucommon.hpp"
#include "mglib.hpp"
#include "mapload.hpp"
#include "snd_mngr.hpp"
#include "quest.hpp"
#include <cmath>
#include <cstring>
#include <cstdlib>
#include <cstdio>
#include "savedatadungeon.hpp"
#include "sceneevent.hpp"
#include "snd_seseq.hpp"
#include "mg_drawenv.hpp"
#include "mg_texture.hpp"
#include "mg_math.hpp"
#include "dng_effect.hpp"
#include "dng_status.hpp"
#include "dng_main.hpp"
#include "actionchara.hpp"
#include "character.hpp"
#include "dng_event.hpp"
#include "font.hpp"
#include "mg_memory.hpp"
#include "monster.hpp"
#include "prespr.hpp"
#include "dng_debug.hpp"

extern char *command_str[13];
extern char at_1103[];
extern char at_1104[];
extern char at_1105[];
extern char at_1106[];
extern char at_1107[];
extern char at_1132__2[];
extern char at_1133__2[];
extern char at_968[];
extern char at_969[];
extern char at_970[];
extern char at_971[];
extern char at_972[];
extern char at_973__2[];
extern char at_974__2[];
extern char at_975[];
extern int command_int[12][2];
extern CFont dbFont;
extern "C" int fptosi(float value);

// Code (.text)
DNG_DEBUG_INFO *dngGetDebugInfo(void) {
    return &dbinfo;
}
void dngDebugInit(void) {
    dbinfo.active = 0;
    dbinfo.cursor = 0;
    dbinfo.sound_flag = 1;
    dbinfo.monster_talk = 0;
    dbinfo.effect_id = 0;
    dbinfo.effect_vol = 0;
    dbFont.Init();
    dbFont.SetClearance(0x14, 0x14);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_debug", dngDebugStart__Fv);
void dngDebugDraw(void) {
    CPreSprite sprite;
    char text[0x800];
    char *cursor;
    int i;
    int string_offset;
    int value_offset;
    if (dbinfo.active != 0) {
        (mgTexManager).ReloadTexture(0x6C, (u_int *)NULL);

        sprite.Initialize(0, 0);
        sprite.Preset2D();
        sprite.TextureMapEnable(0);
        sprite.Begin(6);
        sprite.Color(0x10, 0x10, 0x10, 0x48);
        sprite.Vertex(0xE, 0x46, 0);
        sprite.Vertex(0x104, 0x14C, 0);
        sprite.End();
        cursor = text;
        cursor += sprintf(cursor, at_968);
        i = 0;
        string_offset = 0;
        value_offset = 0;
        while (*(char **)((u8 *)command_str + string_offset) != 0) {
            if (i == dbinfo.cursor) {
                cursor += sprintf(cursor, at_969);
            } else {
                cursor += sprintf(cursor, at_970);
            }
            cursor += sprintf(cursor, *(char **)((u8 *)command_str + string_offset));
            cursor += sprintf(cursor, at_971, *(int *)((u8 *)&command_int + value_offset));
            string_offset += 4;
            value_offset += 8;
            i++;
        }
        if (dbinfo.cursor == 1) {
            cursor += sprintf(cursor, at_972);
            int selected = command_int[1][0];
            int k = 0;
            int found = -1;
            while (base_monster_define[k].id != -1) {
                if (selected == base_monster_define[k].id) {
                    cursor +=
                        sprintf(cursor, at_973__2,
                                base_monster_define[k].grade,
                                base_monster_define[k].name);
                    found = k;
                    break;
                }
                k++;
            }
            if (found == -1) {
                sprintf(cursor, at_974__2, command_int[1][0]);
            } else {
                if (base_monster_define[found].grade > 0) {
                    int m;
                    m = 0;
                    while (base_monster_define[m].id != -1) {
                        if (base_monster_define[m].gift_type ==
                            base_monster_define[found].gift_type) {
                            sprintf(cursor, at_975,
                                    base_monster_define[m].name);
                            break;
                        }
                        m++;
                    }
                }
            }
        }
        dbFont.DrawDirect(text, 0x10, 0x48);
    }
}
void dngDebugExit(void) {
    dbinfo.active = 0;
    GamePad__2.AutoRepeatOff();
    BattleAreaScene->pause_flag = dbinfo.saved_battle_area_unk_8;
    DebugInfo.debug_camera = command_int[2][0];
    DebugInfo.chara_move = command_int[3][0];
    BattleAreaScene->unk_9e = (s16)command_int[5][0];
    dbinfo.sound_flag = command_int[8][0];
    dbinfo.monster_talk = command_int[9][0];
    dbinfo.effect_id = command_int[10][0];
    dbinfo.effect_vol = (float)command_int[11][0];
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_debug", dngDebugKey__Fv);
void CTreasureBox::Initialize(void) {
    state = 0;
    lid_open = 0;
    flags = 1;
}
void DBGCMD_ReloadEnemy(int monster_id, int reset) {
    float spawn_position[4];
    float spawn_direction[4];
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
            manager = (u8 *)ActiveMonster;
            i = 0;
            offset = 0;
            for (; i < 24; i++) {
                void *buffer = stack->stAlloc64(0xFA0);
                mgCMemory *memory = (mgCMemory *)(manager + offset + 4);
                (memory)->stSetBuffer((u_long128 *)buffer, 0xFA0);
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
        spawn_position[0] += (20.0f * (float)rand()) / 2147483648.0f - 10.0f;
        spawn_position[2] += (20.0f * (float)rand()) / 2147483648.0f - 10.0f;
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
void DrawSystemParamInfo(void) {
    CPreSprite sprite;
    char text[0x800];
    float position[4];
    char *cursor;

    sprite.Initialize(0, 0);
    sprite.Preset2D();
    sprite.TextureMapEnable(0);
    sprite.Begin(6);
    sprite.Color(0x10, 0x10, 0x10, 0x48);
    sprite.Vertex(0xE, 0x116, 0);
    sprite.Vertex(0x104, 0x19C, 0);
    sprite.End();
    cursor = text;
    DngMainScene->GetCharacter(0)->GetPosition(position);
    cursor += sprintf(cursor, at_1103, position[0], position[1], position[2]);
    cursor += sprintf(cursor, at_1104, ColPrimMan.ActivePrimNum(), 0x40);
    mgCMemory *map_stack = (mgCMemory *)DngMainScene->GetStack(1);
    mgCMemory *monster_stack = (mgCMemory *)DngMainScene->GetStack(3);
    DngMainScene->GetStack(4);
    mgCMemory *event_stack = (mgCMemory *)DngMainScene->GetStack(5);
    cursor += sprintf(cursor, at_1105, ((int)map_stack->stack_used << 4) / 1024);
    cursor += sprintf(cursor, at_1106, ((int)monster_stack->stack_used << 4) / 1024);
    sprintf(cursor, at_1107,
            (((int)event_stack->stack_size - (int)event_stack->stack_used) << 4) / 1024,
            ((int)event_stack->stack_size << 4) / 1024);
    dbFont.DrawDirect(text, 0x10, 0x118);
}
void DrawSystemParamInfo2(void) {
    CPreSprite sprite;
    char text[0x800];
    float position[4];
    float monster_position[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    float monster_height = 0.0f;
    float monster_width = 0.0f;
    char *cursor;

    sprite.Initialize(0, 0);
    sprite.Preset2D();
    sprite.TextureMapEnable(0);
    sprite.Begin(6);
    sprite.Color(0x10, 0x10, 0x10, 0x48);
    sprite.Vertex(0xE, 0xB2, 0);
    sprite.Vertex(0x144, 0x198, 0);
    sprite.End();
    cursor = text;
    CActionChara *chara = (CActionChara *)DngMainScene->GetCharacter(0);
    ((CCharacter2 *)chara)->GetPosition(position);
    if (chara->lock_on != 0) {
        int slot = chara->target_no - 0x18;
        CActiveMonster *monster = ActiveMonster->active[slot];
        if (monster != 0) {
            ((CCharacter2 *)monster)->GetPosition(monster_position);
            monster_height = monster->body_height;
            monster_width = monster->body_width;
        }
    }
    cursor += sprintf(cursor, at_1103, position[0], position[1], position[2]);
    if (chara->lock_on != 0) {
        cursor += sprintf(cursor, at_1132__2, monster_position[0], monster_position[1],
                          monster_position[2]);
        cursor += sprintf(cursor, at_1133__2, monster_height, monster_width);
    }
    cursor += sprintf(cursor, at_1104, ColPrimMan.ActivePrimNum(), 0x40);
    mgCMemory *map_stack = (mgCMemory *)DngMainScene->GetStack(1);
    mgCMemory *monster_stack = (mgCMemory *)DngMainScene->GetStack(3);
    DngMainScene->GetStack(4);
    mgCMemory *event_stack = (mgCMemory *)DngMainScene->GetStack(5);
    cursor += sprintf(cursor, at_1105, ((int)map_stack->stack_used << 4) / 1024);
    cursor += sprintf(cursor, at_1106, ((int)monster_stack->stack_used << 4) / 1024);
    sprintf(cursor, at_1107,
            (((int)event_stack->stack_size - (int)event_stack->stack_used) << 4) / 1024,
            ((int)event_stack->stack_size << 4) / 1024);
    dbFont.DrawDirect(text, 0x10, 0xB4);
}
void DrawDebugWindow(void) {
    if (command_int[6][0] == 2) {
        DrawSystemParamInfo();
    }
    if (command_int[6][0] == 3) {
        DrawSystemParamInfo2();
    }
}

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/dng_debug", __sinit_dng_debug_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", command_str__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", command_int__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_871__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_872__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_873__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_874__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_875__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_876__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_877__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_878__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_879__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_880__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_881__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_882__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_968__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_969__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_970__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_971__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_972__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_973__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_974__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_975__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_1103__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_1104__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_1105__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_1106__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_1107__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_1132__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", at_1133__2__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/dng_debug", D_0037B010__DATA);

// Uninitialised data (.bss)
INCLUDE_BSS(dbFont, 0xC0);
INCLUDE_BSS(dbinfo, 0x20);
