#include "common.h"
#include "actscript.hpp"
#include "runscript_opcodes.hpp"
#include "padcontrol.hpp"
#include "dng_object.hpp"
#include "runscript.hpp"
#include "monster.hpp"
#include "scenesnd.hpp"
#include "event_func.hpp"
#include "character.hpp"
#include "actionchara.hpp"
#include "cameracontrol.hpp"
#include "effscript.hpp"
#include "colprim.hpp"
#include "dng_main.hpp"
#include "userdata.hpp"
#include "maintex.hpp"
#include "dng_hud.hpp"
#include "dng_effect.hpp"
#include "mg_frame.hpp"
#include "mg_memory.hpp"
#include "mg_math.hpp"
#include "map.hpp"
#include "mapparts.hpp"
#include "object.hpp"
#include "mainloop.hpp"
#include "dataread.hpp"
#include "gamepad.hpp"
#include "sound.hpp"
#include "snd_mngr.hpp"
#include "menucommon.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <cmath>
#include <libvu0.h>
extern CScene *nowScene__2;
extern ACTION_DAMAGE *LastCInfo2__2;
extern int sw_1617;
extern int init_1618;
extern int canon_slot_1620;
extern int init_1621;
extern int cnt_1661;
extern int init_1662;
extern int (*ext_func__3[256])(RS_STACKDATA *, int);
extern float at_1181__3[4];
extern float at_1417__3[4];
extern int at_1597__2[4];
extern char at_1645__2[];
struct RingColors {
    int rgb[4][3];
};
extern RingColors at_1774;
extern RS_EXTFUNC_INFO ext_func_info__3[];
extern char at_1118__4[];
extern char at_1202__2[];
extern char at_1211[];
extern char at_1304__7[];
extern char at_1450__2[];
extern char at_1458__3[];
extern char at_1459__3[];
extern char at_1460__3[];
extern char at_1487__2[];
extern char at_1517__4[];
extern char at_1579[];
extern char at_1580__2[];
extern char at_1581__3[];
extern char at_1593__4[];
extern char at_1594__5[];
extern char at_1595__6[];
extern char at_1596__3[];
extern char at_1637__2[];
extern char at_1638[];
extern char at_1639[];
extern char at_1640__2[];
extern char at_1641[];
extern char at_1642[];
extern char at_1643[];
extern char at_1644[];
extern char at_1725__2[];
extern char at_1726[];
extern char at_1727[];
extern char at_1728__2[];
extern char at_1729__2[];
extern char at_1730__2[];
extern char at_2004__4[];
extern char at_2005__3[];
struct AccumeSlot { mgCFrame *effect; char pad_4[0x28C]; int clear[32]; int mode; int unk_314; int unk_318; float scale; int unk_320; int unk_324; };
extern "C" int fptosi(float);
extern "C" int fptoui(float);
void ParabolicInitialVector(float *result, float *from, float *to, float height, float gravity);

union ScriptVector {
    float value[4];
    u_long128 quadword;
};

extern "C" void RemoveThrowItem__12CActionCharaFv(void *chara);
extern "C" int GetModelNo__13CGameDataUsedFv(void *data);

// Code (.text)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actscript", ParabolicInitialVector__FPfPfPfff);
extern "C" {
static int GetStackInt__FP12RS_STACKDATA__3(RS_STACKDATA *slot) {
    if (slot->type == 1) {
        return (int)slot->f;
    }
    return slot->i;
}
}
extern "C" {
static float GetStackFloat__FP12RS_STACKDATA__3(RS_STACKDATA *slot) {
    if (slot->type == 0) {
        return (float)slot->i;
    }
    return *(float *)&slot->i;
}
}
extern "C" {
static char *GetStackString__FP12RS_STACKDATA__3(RS_STACKDATA *slot) {
    return (char *)slot->i;
}
}
extern "C" {
static void SetStack__FP12RS_STACKDATAi__3(RS_STACKDATA *slot, int value) {
    if (slot->type == 3) {
        ((RS_STACKDATA *)slot->i)->i = value;
    }
}
}
extern "C" {
static void SetStack__FP12RS_STACKDATAf__3(RS_STACKDATA *slot, float value) {
    if (slot->type == 3) {
        *(float *)&((RS_STACKDATA *)slot->i)->i = value;
    }
}
}
int _INIT_SCRIPT(RS_STACKDATA *stack, int argc) {
    action_info.chara->ResetScript();
    return 1;
}
int _PROG_SET(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    action_info.chara->prog = GetStackInt__FP12RS_STACKDATA__3(stack);
    return 1;
}
int _PROG_GET(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__3(stack, action_info.chara->prog);
    return 1;
}
int _GET_ATTK_TYPE(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__3(stack, action_info.chara->attack_type);
    return 1;
}
int _GET_MOVE_TYPE(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__3(stack, action_info.chara->move_type);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actscript", _SET_MOVE_SPEED__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actscript", _SET_PALLET__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actscript", _CHECK_EQUIP__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actscript", _CAMERA_QUAKE__FP12RS_STACKDATAi__2);
extern "C" int _CHECK_PAUSE__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *pause;

    if (argc != 2) {
        return 0;
    }
    pause = &nowScene__2->battle_area;
    if (pause == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__3(stack, pause->pause_flag & GetStackInt__FP12RS_STACKDATA__3(stack++));
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actscript", _GET_STATUS_ATTR__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actscript", _SE_PLAY__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actscript", _SE_LOOP_PLAY__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actscript", _GET_SHOT_TYPE__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actscript", _GET_MONS_ID__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actscript", _GET_FRONT_VEC__FP12RS_STACKDATAi);
extern "C" int _GET_PADON__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    if (argc <= 0) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__3(stack, GamePad__2.GetPadOn());
    return 1;
}
extern "C" int _GET_PADDOWN__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    if (argc <= 0) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__3(stack, GamePad__2.GetPadDown());
    return 1;
}
extern "C" int _GET_PADUP__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    if (argc <= 0) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__3(stack, GamePad__2.GetPadUp());
    return 1;
}
int _GET_BTN(RS_STACKDATA *stack, int argc) {
    if (argc <= 0) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__3(stack, PadCtrl.Btn(GetStackInt__FP12RS_STACKDATA__3(stack++)));
    return 1;
}
int _GET_PAD_HISTORY(RS_STACKDATA *stack, int argc) {
    if (argc <= 0) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__3(stack, action_info.chara->pad_history);
    return 1;
}
int _RESET_PAD_HISTORY(RS_STACKDATA *stack, int argc) {
    action_info.chara->pad_history = 0;
    return 1;
}
int _GET_ACUMU_PAD(RS_STACKDATA *stack, int argc) {
    SetStack__FP12RS_STACKDATAi__3(stack, action_info.chara->acumu_pad);
    return 1;
}
int _RESET_ACUMU_PAD(RS_STACKDATA *stack, int argc) {
    action_info.chara->acumu_pad = 0;
    return 1;
}
int _RUN_MAIN_MOVE(RS_STACKDATA *stack, int argc) {
    int chara_type;

    chara_type = action_info.chara->move_type;
    switch (chara_type) {
        case 0:
            action_info.chara->HumanMoveIF();
            break;
        case 3:
            action_info.chara->MonsterMoveIF();
            break;
    }
    return 1;
}
int _RUN_SHROW_MOVE(RS_STACKDATA *stack, int argc) {
    action_info.chara->HumanShrowMoveIF();
    return 1;
}
int _RUN_TAME_MOVE(RS_STACKDATA *stack, int argc) {
    action_info.chara->HumanTameMoveIF();
    return 1;
}
int _RUN_HOLD_MOVE(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    char *first = GetStackString__FP12RS_STACKDATA__3(stack++);
    action_info.chara->HumanGunMoveIF(first, GetStackString__FP12RS_STACKDATA__3(stack));
    return 1;
}
int _RUN_ROBO_MOVE(RS_STACKDATA *stack, int argc) {
    int input = GetStackInt__FP12RS_STACKDATA__3(stack);
    switch (action_info.chara->move_type) {
        case 1:
        case 4:
            action_info.chara->RoboWalkMoveIF(input);
            break;
        case 2:
        case 5:
            action_info.chara->RoboTankMoveIF(input);
            break;
        case 3:
            action_info.chara->RoboBikeMoveIF(input);
            break;
        case 6:
        case 7:
            action_info.chara->RoboAirMoveIF(1, input);
            break;
    }
    return 1;
}
int _SET_MENU_FLAG(RS_STACKDATA *stack, int argc) {
    if (argc != 1)
        return 0;
    action_info.chara->menu_flag = (s8)GetStackInt__FP12RS_STACKDATA__3(stack);
    return 1;
}
extern "C" int _GET_POS__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    float pos[4];
    if (argc != 3) {
        return 0;
    }
    action_info.chara->GetPosition(pos);
    SetStack__FP12RS_STACKDATAf__3(stack++, pos[0]);
    SetStack__FP12RS_STACKDATAf__3(stack++, pos[1]);
    SetStack__FP12RS_STACKDATAf__3(stack, pos[2]);
    return 1;
}
extern "C" int _GET_ROT__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    float rot[4];
    if (argc != 3) {
        return 0;
    }
    action_info.chara->GetRotation(rot);
    SetStack__FP12RS_STACKDATAf__3(stack++, rot[0]);
    SetStack__FP12RS_STACKDATAf__3(stack++, rot[1]);
    SetStack__FP12RS_STACKDATAf__3(stack, rot[2]);
    return 1;
}
int _CHECK_FRONT_KEY(RS_STACKDATA *stack, int argc) {
    float facing[4];
    float stick[4];
    float stick_x;
    float stick_y;
    float camera_angle;
    if (argc != 1) {
        return 0;
    }
    camera_angle = action_info.camera->GetAngle();
    sceVu0CopyVector(facing, action_info.chara->front_vec);
    stick_x = GamePad__2.GetLXf();
    stick_y = GamePad__2.GetLYf();
    stick[0] = stick_x * cosf(camera_angle) + stick_y * sinf(camera_angle);
    stick[2] = -stick_x * sinf(camera_angle) + stick_y * cosf(camera_angle);
    stick[3] = 1.0f;
    stick[1] = 0.0f;
    sceVu0Normalize(stick, stick);
    sceVu0Normalize(facing, facing);
    SetStack__FP12RS_STACKDATAf__3(stack, sceVu0InnerProduct(facing, stick));
    return 1;
}
int _CHECK_BACK_KEY(RS_STACKDATA *stack, int argc) {
    float rot[4];
    if (argc != 1) {
        return 0;
    }
    if (action_info.chara->lock_on == 0) {
        SetStack__FP12RS_STACKDATAi__3(stack, 0);
        return 1;
    }
    action_info.chara->GetRotation(rot);
    float camera_angle = action_info.camera->GetAngle();
    float stick_x = GamePad__2.GetLXf();
    float stick_y = GamePad__2.GetLYf();
    float x = stick_x * cosf(camera_angle) + stick_y * sinf(camera_angle);
    float z = -stick_x * sinf(camera_angle) + stick_y * cosf(camera_angle);
    float back = rot[1] - 3.1415927f;
    if (back < -3.1415927f) {
        back += 6.2831855f;
    }
    if (x != 0.0f && z != 0.0f && mgAngleCmp(back, atan2f(x, z), 1.2566371f) == 0) {
        SetStack__FP12RS_STACKDATAi__3(stack, 1);
        return 1;
    }
    SetStack__FP12RS_STACKDATAi__3(stack, 0);
    return 1;
}
int _SET_BLOW_ANGLE(RS_STACKDATA *stack, int argc) {
    if (argc != 0) {
        return 0;
    }
    CActionChara *chara = action_info.chara;
    float angle = atan2f(-chara->blow_vec[0], -chara->blow_vec[2]);
    action_info.chara->SetRotation(0.0f, angle, 0.0f);
    return 1;
}
int _SET_BLOW_MOVE(RS_STACKDATA *stack, int argc) {
    float rot[4];
    float dir[4];
    float matrix[4][4];
    if (argc > 4) {
        return 0;
    }
    action_info.chara->add_speed = GetStackFloat__FP12RS_STACKDATA__3(stack++);
    action_info.chara->add_decel = GetStackFloat__FP12RS_STACKDATA__3(stack++);
    action_info.chara->add_time = GetStackInt__FP12RS_STACKDATA__3(stack++);
    float yaw = 0.0f;
    if (argc == 4) {
        yaw = 0.017453292f * GetStackFloat__FP12RS_STACKDATA__3(stack);
    }
    action_info.chara->GetRotation(rot);
    yaw += rot[1];
    if (yaw > 3.1415927f) {
        yaw -= 6.2831855f;
    }
    if (yaw < -3.1415927f) {
        yaw += 6.2831855f;
    }
    *(ScriptVector *)dir = *(ScriptVector *)at_1181__3;
    sceVu0UnitMatrix(matrix);
    sceVu0RotMatrixY(matrix, matrix, yaw);
    sceVu0ApplyMatrix(dir, matrix, dir);
    sceVu0CopyVector(action_info.chara->add_vec, dir);
    return 1;
}
extern "C" int _BLOW_START__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }
    action_info.chara->blow_speed = GetStackFloat__FP12RS_STACKDATA__3(stack++);
    action_info.chara->blow_speed =
        action_info.chara->blow_speed * action_info.chara->blow_rate;
    action_info.chara->blow_decel = GetStackFloat__FP12RS_STACKDATA__3(stack++);
    action_info.chara->blow_time = GetStackInt__FP12RS_STACKDATA__3(stack);
    return 1;
}
extern "C" int _SET_DMG2__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    if (argc < 8 || argc > 9) {
        return 0;
    }
    char *first = GetStackString__FP12RS_STACKDATA__3(stack++);
    char *second = GetStackString__FP12RS_STACKDATA__3(stack++);
    char *attack = GetStackString__FP12RS_STACKDATA__3(stack++);
    float damage = 2.0f * GetStackFloat__FP12RS_STACKDATA__3(stack++);
    float rate = GetStackFloat__FP12RS_STACKDATA__3(stack++);
    char *hitEffect = GetStackString__FP12RS_STACKDATA__3(stack++);
    float knockback = GetStackFloat__FP12RS_STACKDATA__3(stack++);
    float lift = GetStackFloat__FP12RS_STACKDATA__3(stack++);
    char *extra = NULL;
    if (argc == 9) {
        extra = GetStackString__FP12RS_STACKDATA__3(stack);
    }
    LastCInfo2__2 = (ACTION_DAMAGE *)action_info.chara->EntryDamage2(
        first, second, attack, damage, hitEffect, knockback, lift, extra);
    if (LastCInfo2__2 == NULL) {
        printf(at_1202__2, attack);
        return 0;
    }
    LastCInfo2__2->power_rate = rate;
    return 1;
}
extern "C" int _SET_OBJ__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    int number = GetStackInt__FP12RS_STACKDATA__3(stack++);
    char *name = GetStackString__FP12RS_STACKDATA__3(stack);
    if (action_info.chara->EntryObject(name, number) == 0) {
        printf(at_1211, name);
        return 0;
    }
    return 1;
}
extern "C" int _SET_BODY__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    int number = GetStackInt__FP12RS_STACKDATA__3(stack++);
    return action_info.chara->EntryBodyCol(number, 2.0f * GetStackFloat__FP12RS_STACKDATA__3(stack)) != 0;
}
extern "C" int _SW_EFFECT__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    if (argc < 9 || argc > 10) {
        return 0;
    }
    ACTION_SW_EFFECT *effect = (ACTION_SW_EFFECT *)action_info.chara->GetSwEffectPtr();
    if (effect == NULL) {
        return 0;
    }
    int slot = GetStackInt__FP12RS_STACKDATA__3(stack++);
    if (slot < 0 || slot > 2) {
        return 0;
    }
    if (action_info.chara->sword_effect[slot] == NULL) {
        return 0;
    }
    char *name = GetStackString__FP12RS_STACKDATA__3(stack++);
    float start = GetStackFloat__FP12RS_STACKDATA__3(stack++);
    float end = GetStackFloat__FP12RS_STACKDATA__3(stack++);
    char *first = GetStackString__FP12RS_STACKDATA__3(stack++);
    char *second = GetStackString__FP12RS_STACKDATA__3(stack++);
    int flag_a = GetStackInt__FP12RS_STACKDATA__3(stack++);
    int flag_b = GetStackInt__FP12RS_STACKDATA__3(stack++);
    int flag_c = GetStackInt__FP12RS_STACKDATA__3(stack++);
    char *extra = NULL;
    if (argc == 10) {
        extra = GetStackString__FP12RS_STACKDATA__3(stack);
    }
    effect->sword_no = slot;
    effect->motion = name;
    effect->chara = extra;
    effect->start = start;
    effect->end = end;
    effect->frame0 = first;
    effect->frame1 = second;
    effect->unk_1c = flag_a;
    effect->unk_1d = flag_b;
    effect->fade_time = flag_c;
    effect->wait = 0;
    action_info.chara->sw_effect_num++;
    return 1;
}
int _SET_SND(RS_STACKDATA *stack, int argc) {
    int sound_id = GetStackInt__FP12RS_STACKDATA__3(stack++);
    char *motion = GetStackString__FP12RS_STACKDATA__3(stack++);
    float start_time = GetStackFloat__FP12RS_STACKDATA__3(stack++);
    float end_time = GetStackFloat__FP12RS_STACKDATA__3(stack++);
    char *wait = NULL;
    if (argc > 4) {
        wait = GetStackString__FP12RS_STACKDATA__3(stack);
    }
    for (int i = 0; i < 10; i++) {
        if (action_info.chara->sound[i].se_no == -1) {
            action_info.chara->sound[i].se_no = sound_id;
            action_info.chara->sound[i].start_frame =
                action_info.chara->GetWaitToFrame(motion, start_time, wait);
            action_info.chara->sound[i].end_frame =
                action_info.chara->GetWaitToFrame(motion, end_time, wait);
            action_info.chara->sound[i].chara = wait;
            action_info.chara->sound[i].unk_c = 0;
            return 1;
        }
    }
    return 0;
}
int _SET_ACCUME_FX(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    if (action_info.chara->accume_effect == NULL) {
        return 0;
    }
    int index = GetStackInt__FP12RS_STACKDATA__3(stack++);
    int effect_no = GetStackInt__FP12RS_STACKDATA__3(stack);
    mgCFrame *effect = action_info.chara->object[index].frame;
    if (effect == 0) {
        return 0;
    }
    action_info.chara->accume.frame = effect;
    action_info.chara->accume.unk_4 = effect_no;
    action_info.chara->accume.active = 0;
    return 1;
}
int _SET_ACCUME_FLAG(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    if (action_info.chara->accume_effect == NULL) {
        return 0;
    }
    int mode = GetStackInt__FP12RS_STACKDATA__3(stack);
    switch (mode) {
        case 1: {
            int i;
            AccumeSlot *slot = (AccumeSlot *)action_info.chara->accume_effect;
            slot->effect = action_info.chara->accume.frame;
            slot->mode = 1;
            slot->unk_314 = 0;
            slot->unk_318 = 0;
            slot->unk_320 = 0;
            slot->unk_324 = 0;
            slot->scale = 3.0f;
            for (i = 0; i < 32; i++) {
                slot->clear[i] = 0;
            }
            if (slot->effect == 0) {
                printf(at_1304__7);
            }
            action_info.chara->accume.active = 1;
            break;
        }
        case 0:
            ((AccumeSlot *)action_info.chara->accume_effect)->mode = mode;
            action_info.chara->acumu_pad = 0;
            action_info.chara->accume.active = 0;
            break;
        default:
            ((AccumeSlot *)action_info.chara->accume_effect)->mode = mode;
            if (mode == 3 || mode == 4) {
                action_info.chara->accume.active = 0;
            }
            break;
    }
    return 1;
}
int _GET_MONSTER_NOWSTS(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    int status = 0;
    int monster_no = action_info.chara->target_no;
    if (monster_no != -1) {
        CActionChara *monster = (CActionChara *)nowScene__2->GetCharacter(monster_no);
        if (monster != NULL) {
            status = monster->now_status;
        }
    }
    SetStack__FP12RS_STACKDATAi__3(stack, status);
    return 1;
}
int _SET_MURDEROUS(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    action_info.chara->murderous = GetStackInt__FP12RS_STACKDATA__3(stack++);
    action_info.chara->murderous_time = GetStackInt__FP12RS_STACKDATA__3(stack);
    return 1;
}
int _GET_TRG_DISTANCE(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAf__3(stack, action_info.chara->GetTargetDist(nowScene__2));
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actscript", _SET_TRG_ANGLE__FP12RS_STACKDATAi);
int _SET_GUARD_FLAG(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    action_info.chara->guard_flag = GetStackInt__FP12RS_STACKDATA__3(stack);
    return 1;
}
extern "C" int _SET_MUTEKI__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    if (argc != 1)
        return 0;
    action_info.chara->muteki_time = GetStackInt__FP12RS_STACKDATA__3(stack);
    return 1;
}
int _CHECK_HAND_OBJ(RS_STACKDATA *stack, int argc) {
    SetStack__FP12RS_STACKDATAi__3(stack, action_info.chara->hold_type);
    return 1;
}
int _SET_ITEM_USED(RS_STACKDATA *stack, int argc) {
    SetStack__FP12RS_STACKDATAi__3(stack, action_info.chara->UsedItemAction());
    return 1;
}
int _THROW_HAND_OBJECT(RS_STACKDATA *stack, int argc) {
    action_info.chara->ThrowItemObject();
    return 1;
}
int _CHECK_CATCH(RS_STACKDATA *stack, int argc) {
    char *name = GetStackString__FP12RS_STACKDATA__3(stack++);
    if (argc == 1) {
        action_info.chara->CheckEnemyCatch(name);
    }
    if (argc == 3) {
        int target = GetStackInt__FP12RS_STACKDATA__3(stack++);
        name = (char *)action_info.chara->CheckKeri(name, target);
        SetStack__FP12RS_STACKDATAi__3(stack, (int)name);
    }
    return 1;
}
int _RELEASE_OBJ(RS_STACKDATA *stack, int argc) {
    float held_pos[4];
    float start_pos[4];
    float direction[4];
    float target_pos[4];
    float offset[4];
    int throw_it = 0;
    if (argc == 1) {
        throw_it = GetStackInt__FP12RS_STACKDATA__3(stack);
    }
    DNG_BATTLE_AREA *input;
    if (nowScene__2 != NULL && (input = &nowScene__2->battle_area) != NULL &&
        !(input->pause_flag & 0x2000)) {
        action_info.chara->Show(1, 1);
    }
    if (action_info.chara->hold_type == 1 && throw_it == 0) {
        RemoveThrowItem__12CActionCharaFv(action_info.chara);
    }
    int chara_no = 0x18;
    if (action_info.chara->hold_type == 3) {
        do {
            CActionChara *held = (CActionChara *)nowScene__2->GetCharacter(chara_no);
            if (held != NULL && held->catch_state == 1) {
                held->catch_frame->GetWorldPosition0(held_pos);
                held->CObjectFrame::frame->DeleteReference();
                held->SetPosition(held_pos);
                if (throw_it == 0) {
                    held->catch_frame = NULL;
                    held->catch_state = 0;
                    held->no_hit_time = 5;
                    ((CActiveMonster *)held)->req_prog = 0x4B0;
                } else {

                    ((CActionChara *)action_info.chara)->GetPosition(start_pos);
                    sceVu0CopyVector(direction, action_info.chara->front_vec);
                    direction[3] = 1.0f;
                    float distance = 100.0f;
                    if (action_info.chara->lock_on != 0) {
                        CActionChara *target = (CActionChara *)nowScene__2->GetCharacter(
                            action_info.chara->target_no);
                        if (target != NULL) {
                            ((CCharacter2 *)target)->GetEntryObjectPos(0, 0, target_pos);
                            start_pos[3] = 1.0f;
                            target_pos[3] = 1.0f;
                            distance = mgDistVector(start_pos, target_pos);
                            if (!(distance <= 120.0f)) {
                                distance = 120.0f;
                            }
                        }
                    }
                    sceVu0Normalize(direction, direction);
                    sceVu0ScaleVectorXYZ(direction, direction, distance);
                    sceVu0AddVector(direction, direction, start_pos);

                    ParabolicInitialVector(&held->blow_vec[0], start_pos, direction, 0.6f, 10.0f);
                    held->catch_frame = NULL;
                    held->catch_state = 2;
                    held->no_hit_time = 5;
                    held->damage_req = 6;
                    *(ScriptVector *)offset = *(ScriptVector *)at_1417__3;
                    sceVu0CopyVector(held->velocity, offset);
                    action_info.chara->release_timing = 2;
                }
            }
            chara_no++;
        } while (chara_no <= 0x2F);
    }
    if (action_info.chara->hold_type == 4) {
        action_info.chara->hold_parts = 0;
        action_info.chara->hold_frame = 0;
        action_info.chara->release_timing = 3;
    }
    action_info.chara->hold_type = 0;
    return 1;
}
void ShotMonicaMagic(float *position, float *direction, float scale) {
    char *effectName;
    char *unusedName;
    int effect_power;
    ((CGameDataUsed *)(GetBattleCharaInfo()->equip + 1))
        ->GetEffectReadType(&effectName, &unusedName, &effect_power);
    action_info.chara->effect_man->CreateEffSpt(effectName, 0, 0);
    action_info.chara->effect_man->SetScriptVect1(position, 0, -1);
    action_info.chara->effect_man->SetScriptVect2(direction, 0, -1);
    float tint = (float)effect_power / 255.0f;
    tint *= 1.5f;
    action_info.chara->effect_man->SetValue(0, tint, -1, -1);
    action_info.chara->effect_man->SetScriptTargetId(action_info.chara->target_no, -1, -1);
    CColPrim *prim = ColPrimMan.GetPrim();
    if (prim != NULL) {
        prim->SetDamage(at_1450__2, 0);
        prim->range = 500.0f;
        SetDamageParam(prim, 1);
        prim->damage = fptosi((float)prim->damage * scale);
        action_info.chara->effect_man->SetColPrim(prim, -1, -1);
        calcWeaponParam2(5, prim->param->hit_count);
    }
    sndSePlay(action_info.chara->se_bank, 13, 0);
}
void ShotNormalGun(float *position, float *direction) {
    action_info.chara->effect_man->CreateEffSpt(at_1458__3, 0, 0);
    action_info.chara->effect_man->SetScriptVect1(position, 0, -1);
    sceVu0ScaleVector(direction, direction, 20.0f);
    action_info.chara->effect_man->SetScriptVect2(direction, 0, -1);
    CColPrim *prim = ColPrimMan.GetPrim();
    if (prim != NULL) {
        prim->SetDamage(at_1459__3, 0);
        prim->range = 300.0f;
        SetDamageParam(prim, 1);
        action_info.chara->effect_man->SetColPrim(prim, -1, -1);
        calcWeaponParam2(1, prim->param->hit_count);
    }
    action_info.chara->effect_man->CreateEffSpt(at_1460__3, 0, 0);
    action_info.chara->effect_man->SetScriptVect1(position, 0, -1);
    sndSePlay(action_info.chara->se_bank, 5, 0);
}
void ShotMachineGun(float *position, float *direction, char *damageName, float damage) {
    MachineGun.Set(position, direction);
    CColPrim *prim = ColPrimMan.GetPrim();
    int col_prim_id = -1;
    if (prim != NULL) {
        prim->SetDamage(damageName, 0);
        prim->SetCoord(position, position, 5.0f);
        prim->range = damage;
        SetDamageParam(prim, 1);
        col_prim_id = prim->id;
        calcWeaponParam2(1, prim->param->hit_count);
    }
    MachineGun.col_prim_id[MachineGun.index] = col_prim_id;
    action_info.chara->effect_man->CreateEffSpt(at_1460__3, 0, 0);
    action_info.chara->effect_man->SetScriptVect1(position, 0, -1);
    CActionChara *owner = action_info.chara;
    if (owner->loop_se != NULL) {
        owner->loop_se->SeLoopPlayStop(owner->se_bank, 5, 5, 13);
    }
}
void ShotGrenadGun(float *position, float *direction) {
    float muzzle[4];
    sceVu0ScaleVector(muzzle, direction, 500.0f);
    sceVu0AddVector(muzzle, position, muzzle);
    direction[1] += 0.1f;
    CRocketLauncher *launcher = RocketLauncher.Get();
    if (launcher != NULL) {
        launcher->SetPos(position, muzzle, direction);
        launcher->target_chara = action_info.chara->target_no;
        launcher->speed = 20.0f;
        launcher->homing_delay = 4;
        launcher->homing_time = 30;
        CColPrim *prim = ColPrimMan.GetPrim();
        int col_prim_id = -1;
        if (prim != NULL) {
            prim->SetDamage(at_1487__2, 0);
            prim->SetCoord(position, 5.0f);
            prim->range = 500.0f;
            SetDamageParam(prim, 1);
            col_prim_id = prim->id;
            calcWeaponParam2(1, prim->param->hit_count);
        }
        launcher->col_prim_id = col_prim_id;
    }
    action_info.chara->effect_man->CreateEffSpt(at_1460__3, 0, 0);
    action_info.chara->effect_man->SetScriptVect1(position, 0, -1);
    sndSePlay(action_info.chara->se_bank, 5, 0);
}
void ShotLaserGun(float *position, float *direction, int type) {
    float muzzle[4];
    float target[4];
    sceVu0ScaleVector(muzzle, direction, 20.0f);
    sceVu0AddVector(muzzle, position, muzzle);
    sceVu0ScaleVector(target, direction, 500.0f);
    sceVu0AddVector(target, muzzle, target);
    CLaserGun *laser = LaserGun.Get();
    if (laser != NULL) {
        laser->SetPos(muzzle, target, direction);
        laser->target_chara = action_info.chara->target_no;
        laser->speed = 30.0f;
        laser->homing_delay = 99999;
        laser->homing_time = 0;
        laser->SetVisualCode(type);
        CColPrim *prim = ColPrimMan.GetPrim();
        int col_prim_id = -1;
        if (prim != NULL) {
            prim->SetDamage(at_1517__4, 0);
            prim->SetCoord(muzzle, 5.0f);
            prim->range = 500.0f;
            SetDamageParam(prim, 1);
            col_prim_id = prim->id;
            calcWeaponParam2(1, prim->param->hit_count);
        }
        laser->col_prim_id = col_prim_id;
    }
    action_info.chara->effect_man->CreateEffSpt(at_1460__3, 0, 0);
    action_info.chara->effect_man->SetScriptVect1(position, 0, -1);
    action_info.chara->effect_man->SetValue(0, 1, 0, -1);
    float color_d;
    float color_b;
    float color_c;
    float color_a;
    if (type == 0) {
        color_a = 64.0f;
        color_b = 128.0f;
        color_c = color_a;
        color_d = color_b;
    }
    if (type == 1) {
        color_a = 64.0f;
        color_c = 128.0f;
        color_b = color_a;
        color_d = color_c;
    }
    if (type == 2) {
        color_a = 128.0f;
        color_b = 32.0f;
        color_d = 180.0f;
        color_c = color_a;
    }
    action_info.chara->effect_man->SetValue(1, color_a, 0, -1);
    action_info.chara->effect_man->SetValue(2, color_b, 0, -1);
    action_info.chara->effect_man->SetValue(3, color_c, 0, -1);
    action_info.chara->effect_man->SetValue(4, color_d, 0, -1);
    sndSePlay(action_info.chara->se_bank, 5, 0);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actscript", _SET_SHOT__FP12RS_STACKDATAi);
int _SET_SPECIAL_SHOT(RS_STACKDATA *stack, int argc) {
    float facing[4];
    float position[4];
    float direction[4];
    int effects[4];
    if (argc != 1) {
        return 0;
    }
    char *objectName = GetStackString__FP12RS_STACKDATA__3(stack);
    CBattleCharaInfo *info = GetBattleCharaInfo();
    if (info->GetMagicSwordCounterNow() <= 0) {
        return 1;
    }
    if (action_info.chara->shot_wait > 0) {
        return 1;
    }
    action_info.chara->shot_wait = 5;
    mgCFrame *object = action_info.chara->SearchObject(objectName);
    if (object == 0) {
        return 0;
    }
    sceVu0CopyVector(facing, action_info.chara->front_vec);
    object->GetWorldPosition0(position);
    sceVu0CopyVector(direction, action_info.chara->front_vec);
    *(ScriptVector *)effects = *(ScriptVector *)at_1597__2;
    action_info.chara->effect_man->CreateEffSpt((char *)effects[info->GetMagicSwordElem()], 0, 0);
    action_info.chara->effect_man->SetScriptVect1(position, 0, -1);
    action_info.chara->effect_man->SetScriptVect2(direction, 0, -1);
    action_info.chara->effect_man->SetValue(0, 0.0f, -1, -1);
    action_info.chara->effect_man->SetScriptTargetId(action_info.chara->target_no, -1, -1);
    CColPrim *prim = ColPrimMan.GetPrim();
    if (prim != NULL) {
        prim->SetDamage(at_1450__2, 0);
        prim->damage = info->GetMagicSwordPow();
        prim->element[info->GetMagicSwordElem()] = 100;
        prim->element[info->GetMagicSwordElem()] = 100;
        action_info.chara->effect_man->SetColPrim(prim, -1, -1);
    }
    info->ClearMagicSwordPow();
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/actscript", _SHOT__FP12RS_STACKDATAi);
int _GET_OBJECT_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];
    if (argc != 4) {
        return 0;
    }
    RS_STACKDATA *next = stack + 1;
    mgCFrame *object = action_info.chara->SearchObject(GetStackString__FP12RS_STACKDATA__3(stack));
    if (object == 0) {
        return 0;
    }
    object->GetWorldPosition0(pos);
    SetStack__FP12RS_STACKDATAf__3(next++, pos[0]);
    SetStack__FP12RS_STACKDATAf__3(next++, pos[1]);
    SetStack__FP12RS_STACKDATAf__3(next, pos[2]);
    return 1;
}
int _SET_DIR_GUN(RS_STACKDATA *stack, int argc) {
    action_info.chara->dir_gun = 1;
    return 1;
}
#pragma divbyzerocheck on
int _GET_NOW_HP_RATE(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    CBattleCharaInfo *info = GetBattleCharaInfo();
    int now_hp = info->GetNowHp_i();
    int rate = now_hp / info->GetMaxHp_i();
    SetStack__FP12RS_STACKDATAf__3(stack, (float)rate);
    return 1;
}
#pragma divbyzerocheck reset
int _SET_BOMB(RS_STACKDATA *stack, int argc) {
    GetBattleCharaInfo()->SetHpRate(0.05f);
    return 1;
}
int _GET_ACTION_CODE(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    argc = GetModelNo__13CGameDataUsedFv(GetBattleCharaInfo()->GetEquipTablePtr(0));
    SetStack__FP12RS_STACKDATAi__3(stack, argc);
    return 1;
}
int _GET_ATTK_POINT(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    int index = GetStackInt__FP12RS_STACKDATA__3(stack++);
    BATTLE_WEAPON_PARAM *slots = GetBattleCharaInfo()->weapon_param;
    SetStack__FP12RS_STACKDATAi__3(stack, slots[index].status[0]);
    return 1;
}
int _GET_RING_COLOR(RS_STACKDATA *stack, int argc) {
    char *effectName;
    char *unusedName;
    int effect_power;
    if (argc != 3) {
        return 0;
    }
    int type = ((CGameDataUsed *)(GetBattleCharaInfo()->equip + 1))
                   ->GetEffectReadType(&effectName, &unusedName, &effect_power);
    if (type < 0 || type > 3) {
        return 0;
    }
    RingColors colors = at_1774;
    SetStack__FP12RS_STACKDATAi__3(stack++, colors.rgb[type][0]);
    SetStack__FP12RS_STACKDATAi__3(stack++, colors.rgb[type][1]);
    SetStack__FP12RS_STACKDATAi__3(stack, colors.rgb[type][2]);
    return 1;
}
extern "C" int _SET_MOS__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    char *motion = NULL;
    char *charaName = NULL;
    int flag = 0;
    float speed = -1.0f;
    CActionChara *target;
    if (argc <= 0 || argc > 4) {
        return 0;
    }
    if (argc > 0) {
        motion = GetStackString__FP12RS_STACKDATA__3(stack++);
    }
    if (argc >= 2) {
        speed = GetStackFloat__FP12RS_STACKDATA__3(stack++);
    }
    if (argc >= 3) {
        flag = GetStackInt__FP12RS_STACKDATA__3(stack++);
    }
    if (argc == 4) {
        charaName = GetStackString__FP12RS_STACKDATA__3(stack);
    }
    if (motion == NULL) {
        return 0;
    }
    target = (CActionChara *)action_info.chara;
    if (charaName != NULL) {
        target = target->SearchChara(charaName);
        if (target == NULL) {
            return 0;
        }
    }
    target->SetMotion(motion, flag, 1);
    if (speed > 0.0f) {
        target->SetStep(speed);
    }
    return 1;
}
extern "C" int _CHECK_MOS_END__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    float result;
    if (argc == 1) {
        result = action_info.chara->CheckMotionEnd(0);
    }
    if (argc == 2) {
        char *name = GetStackString__FP12RS_STACKDATA__3(stack + 1);
        if (name == NULL) {
            return 0;
        }
        result = action_info.chara->CheckMotionEnd(name);
    }
    SetStack__FP12RS_STACKDATAf__3(stack, result);
    return 1;
}
extern "C" int _NOW_MOS_WAIT__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    float result;
    if (argc == 1) {
        result = action_info.chara->GetNowFrameWait(0);
    }
    if (argc == 2) {
        char *name = GetStackString__FP12RS_STACKDATA__3(stack + 1);
        if (name == NULL) {
            return 0;
        }
        result = action_info.chara->GetNowFrameWait(name);
    }
    SetStack__FP12RS_STACKDATAf__3(stack, result);
    return 1;
}
int _NOW_MOS_CHGWAIT(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAf__3(stack, action_info.chara->GetChgStepWait());
    return 1;
}
extern "C" int _GET_MOS_STATUS__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    int status;
    if (argc == 1) {
        status = action_info.chara->GetMotionStatus(NULL);
    }
    if (argc == 2) {
        char *name = GetStackString__FP12RS_STACKDATA__3(stack + 1);
        if (name == NULL) {
            return 0;
        }
        status = action_info.chara->GetMotionStatus(name);
    }
    SetStack__FP12RS_STACKDATAi__3(stack, status);
    return 1;
}
int _SET_XCHG_STEP(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    float value = GetStackFloat__FP12RS_STACKDATA__3(stack);
    CActionChara *chara = action_info.chara;
    chara->blend_speed = value;
    if (value >= 1.0f) {
        chara->blend = 1.0f;
    }
    return 1;
}
int _SET_MOS_STEP(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    action_info.chara->SetStep(GetStackFloat__FP12RS_STACKDATA__3(stack));
    return 1;
}
int _TRG_ON_MOS(RS_STACKDATA *stack, int argc) {
    action_info.chara->seq_advance = 1;
    return 1;
}
int _RESET_MOS(RS_STACKDATA *stack, int argc) {
    action_info.chara->ResetMotion();
    return 1;
}
int _SET_DEFAULT_MOS(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    action_info.chara->default_motion = GetStackString__FP12RS_STACKDATA__3(stack);
    return 1;
}
int _SET_NEBA2(RS_STACKDATA *stack, int argc) {
    if ((GetBattleCharaInfo())->GetAttr() & 2) {
        action_info.chara->SetStep(0.7f * action_info.chara->GetDefaultStep());
    }
    return 1;
}
extern "C" int _ESM_CREATE__FP12RS_STACKDATAi__3(RS_STACKDATA *stack, int argc) {
    if (action_info.chara->effect_man == NULL) {
        return 0;
    }
    char *name = GetStackString__FP12RS_STACKDATA__3(stack++);
    switch (argc) {
        case 1:
            action_info.chara->effect_man->CreateEffSpt(name, 0, 0);
            break;
        case 2: {
            int id = action_info.chara->effect_man->CreateEffSpt(name, 0, 1);
            if (id <= -1) {
                return 0;
            }
            SetStack__FP12RS_STACKDATAi__3(stack, id);
            break;
        }
    }
    return 1;
}
extern "C" int _ESM_SET_VECT1__FP12RS_STACKDATAi__3(RS_STACKDATA *stack, int argc) {
    float vect[4];
    if (action_info.chara->effect_man == NULL) {
        return 0;
    }
    int index = GetStackInt__FP12RS_STACKDATA__3(stack++);
    vect[0] = GetStackFloat__FP12RS_STACKDATA__3(stack++);
    vect[1] = GetStackFloat__FP12RS_STACKDATA__3(stack++);
    vect[2] = GetStackFloat__FP12RS_STACKDATA__3(stack);
    vect[3] = 1.0f;
    if (index >= 0) {
        return action_info.chara->effect_man->SetScriptVect1(vect, 0, index);
    }
    return action_info.chara->effect_man->SetScriptVect1(vect, 0, -1);
}
extern "C" int _ESM_SET_VECT2__FP12RS_STACKDATAi__3(RS_STACKDATA *stack, int argc) {
    float vect[4];
    if (action_info.chara->effect_man == NULL) {
        return 0;
    }
    int index = GetStackInt__FP12RS_STACKDATA__3(stack++);
    vect[0] = GetStackFloat__FP12RS_STACKDATA__3(stack++);
    vect[1] = GetStackFloat__FP12RS_STACKDATA__3(stack++);
    vect[2] = GetStackFloat__FP12RS_STACKDATA__3(stack);
    vect[3] = 1.0f;
    if (index >= 0) {
        return action_info.chara->effect_man->SetScriptVect2(vect, 0, index);
    }
    return action_info.chara->effect_man->SetScriptVect2(vect, 0, -1);
}
extern "C" int _ESM_FINISH__FP12RS_STACKDATAi__3(RS_STACKDATA *stack, int argc) {
    CEffectScriptMan *effectScript;
    int effect_id;

    effect_id = GetStackInt__FP12RS_STACKDATA__3(stack);
    if (effect_id < 0) {
        return 0;
    }
    effectScript = action_info.chara->effect_man;
    if (effectScript == NULL) {
        return 0;
    }
    effectScript->SetScriptProgNo(0x12C, 0, effect_id);
    return 1;
}
extern "C" int _ESM_DELETE__FP12RS_STACKDATAi__3(RS_STACKDATA *stack, int argc) {
    CEffectScriptMan *effectScript;
    int effect_id;

    effect_id = GetStackInt__FP12RS_STACKDATA__3(stack);
    if (effect_id < 0) {
        return 0;
    }
    effectScript = action_info.chara->effect_man;
    if (effectScript == NULL) {
        return 0;
    }
    effectScript->DeleteEffSpt(0, effect_id);
    return 1;
}
extern "C" int _ESM_SET_VALUE__FP12RS_STACKDATAi__3(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }
    int prog_no = GetStackInt__FP12RS_STACKDATA__3(stack++);
    int value_no = GetStackInt__FP12RS_STACKDATA__3(stack++);
    int result;
    switch (stack->type) {
        case 0:
            result = action_info.chara->effect_man->SetValue(value_no, GetStackInt__FP12RS_STACKDATA__3(stack), 0, prog_no);
            break;
        case 1:
            result =
                action_info.chara->effect_man->SetValue(value_no, GetStackFloat__FP12RS_STACKDATA__3(stack), 0, prog_no);
            break;
        default:
            return 0;
    }
    return result;
}
int SetActionScript(CRunScript *script, char *program, mgCMemory *memory) {
    int stack = (int)memory->Alloc(0x40);
    int call_data = (int)memory->Alloc(0x180);
    script->load((RS_PROG_HEADER *)program, (RS_STACKDATA *)stack, 0x80, (RS_CALLDATA *)call_data,
                 0x200);
    script->ext_func(ext_func__3, 0x100);
    return 1;
}
void SetActionExtendTable(void) {
    int i;
    int j;
    for (i = 0; i < 256; i++) {
        ext_func__3[i] = NULL;
    }
    for (i = 0;; i++) {
        if (ext_func_info__3[i].func == NULL) {
            break;
        }
        if (0 < i) {
            j = 0;
            do {
                if (ext_func_info__3[i].no == ext_func_info__3[j].no) {
                    printf(at_2004__4);
                    while (1) {
                    }
                }
                j++;
            } while (j < i);
        }
        if (ext_func_info__3[i].no < 0 || ext_func_info__3[i].no >= 256) {
            printf(at_2005__3);
        } else {
            ext_func__3[ext_func_info__3[i].no] = ext_func_info__3[i].func;
        }
    }
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1181__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1417__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1597__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1645__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1774__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", ext_func_info__3__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1118__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1202__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1211__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1304__7__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1450__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1458__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1459__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1460__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1487__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1517__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1579__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1580__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1581__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1593__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1594__5__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1595__6__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1596__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1637__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1638__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1639__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1640__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1641__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1642__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1643__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1644__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1725__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1726__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1727__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1728__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1729__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_1730__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_2004__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/actscript", at_2005__3__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(nowScene__2, 0x4);
INCLUDE_BSS(LastCInfo2__2, 0x4);
INCLUDE_BSS(sw_1617, 0x4);
INCLUDE_BSS(init_1618, 0x4);
INCLUDE_BSS(canon_slot_1620, 0x4);
INCLUDE_BSS(init_1621, 0x4);
INCLUDE_BSS(cnt_1661, 0x4);
INCLUDE_BSS(init_1662, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(action_info, 0x10);
INCLUDE_BSS(ext_func__3, 0x400);
