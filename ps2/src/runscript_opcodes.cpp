#include "common.h"
#include "runscript_opcodes.hpp"
#ifdef NONMATCHING
#include "dng_object.hpp"
#include "gameutil.hpp"
#include "mdslist.hpp"
#include "mg_camera.hpp"
#include "mg_drawenv.hpp"
#endif
#include "nd_meswin.hpp"
#include "savedata.hpp"
#include "monster.hpp"
#include <cstdio>
#include "runscript.hpp"
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
#include <cstdlib>
#include <cstring>
#include <cmath>
#include <libvu0.h>
extern CScene *nowScene;
extern CActiveMonster *nowMonster;
extern ACTION_DAMAGE *LastCInfo2;
extern int (*ext_func[256])(RS_STACKDATA *, int);
union ScriptVector { float f[4]; u_long128 qw; };
extern ScriptVector at_1480__2;
extern ScriptVector at_1481__2;
extern ScriptVector at_1864;
extern ScriptVector at_2160;
extern RS_EXTFUNC_INFO ext_func_info[];
extern char at_1728[23];
extern char at_1733[22];
extern char at_1784[];
extern char at_2398__2[];
extern char at_2399[];
extern char at_2580[17];
extern char at_2787[13];
extern char at_3078[];
extern char at_3079[];
struct ScriptVec { float v[3]; u32 w; };
struct ScriptVecRawZ { float v[2]; u32 z; u32 w; };
struct RangeEntry { float distance; int id; };
extern "C" int fptosi(float);
extern "C" int fptoui(float);

// Code (.text)
void CMonsterMan::RunScript(int index) {
    int script;

    nowScene = scene;
    nowMonster = active[index];
    if (nowMonster != NULL) {
        script = nowMonster->req_prog;
        if (script != -1) {
            if (nowMonster->mons_script.check_program(script) != 0) {
                nowMonster->mons_script.run(script);
                nowMonster->now_prog = script;
                nowMonster->req_prog = -1;
            }
        } else {
            nowMonster->mons_script.resume();
            if (nowMonster->mons_script.end != 0) {
                nowMonster->req_prog = MONSTER_PROG_MAIN;
            }
        }
    }
}
extern "C" {
static int GetStackInt__FP12RS_STACKDATA(RS_STACKDATA *stack) {
    if (stack->type == 1) {
        return (int)stack->f;
    }
    return stack->i;
}
}
extern "C" {
static float GetStackFloat__FP12RS_STACKDATA(RS_STACKDATA *stack) {
    if (stack->type == 0) {
        return (float)stack->i;
    }
    return *(float *)&stack->i;
}
}
extern "C" {
static char *GetStackString__FP12RS_STACKDATA(RS_STACKDATA *stack) {
    return (char *)stack->i;
}
}
extern "C" {
static void SetStack__FP12RS_STACKDATAi(RS_STACKDATA *stack, int value) {
    if (stack->type == 3) {
        ((RS_STACKDATA *)stack->i)->i = value;
    }
}
}
extern "C" {
static void SetStack__FP12RS_STACKDATAf(RS_STACKDATA *stack, float value) {
    if (stack->type == 3) {
        *(float *)&((RS_STACKDATA *)stack->i)->i = value;
    }
}
}
extern "C" {
static void GetStackVector__FPfPP12RS_STACKDATA(float *vec, RS_STACKDATA **stack) {
    vec[0] = GetStackFloat__FP12RS_STACKDATA((*stack)++);
    vec[1] = GetStackFloat__FP12RS_STACKDATA((*stack)++);
    vec[2] = GetStackFloat__FP12RS_STACKDATA((*stack)++);
    vec[3] = 1.0f;
}
}
extern "C" {
static void SetStackVector__FPfPP12RS_STACKDATA(float *vec, RS_STACKDATA **stack) {
    SetStack__FP12RS_STACKDATAf((*stack)++, vec[0]);
    SetStack__FP12RS_STACKDATAf((*stack)++, vec[1]);
    SetStack__FP12RS_STACKDATAf((*stack)++, vec[2]);
}
}
extern "C" int _SQRT__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argument_count) {
    float value = GetStackFloat__FP12RS_STACKDATA(stack++);
    SetStack__FP12RS_STACKDATAf(stack, (float)sqrt(value));
    return 1;
}
extern "C" int _ATAN2F__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argument_count) {
    float y = GetStackFloat__FP12RS_STACKDATA(stack++);
    float x = GetStackFloat__FP12RS_STACKDATA(stack++);
    SetStack__FP12RS_STACKDATAf(stack, atan2f(y, x));
    return 1;
}
int _ND_TEST(RS_STACKDATA *stack, int argc) {
    return 1;
}
int _GET_TARGET_ROT(RS_STACKDATA *stack, int argument_count) {
    float pos[4];
    CCharacter2 *target;

    if (argument_count != 3) {
        return 0;
    }
    target = nowScene->GetCharacter(nowMonster->target_no);
    if (target == NULL) {
        return 0;
    }
    target->GetRotation(pos);
    SetStack__FP12RS_STACKDATAf(stack++, pos[0]);
    SetStack__FP12RS_STACKDATAf(stack++, pos[1]);
    SetStack__FP12RS_STACKDATAf(stack, pos[2]);
    return 1;
}
int _GET_MONSTER_INDEX(RS_STACKDATA *stack, int argument_count) {
    SetStack__FP12RS_STACKDATAi(stack, nowMonster->monster_id);
    return 1;
}
int _SET_MONSTER_LIFE(RS_STACKDATA *stack, int argument_count) {
    int life;

    switch (stack->type) {
        case 0:
            life = GetStackInt__FP12RS_STACKDATA(stack);
            break;
        case 1:
            life = fptosi((float)nowMonster->max_life * GetStackFloat__FP12RS_STACKDATA(stack));
            break;
        default:
            return 0;
    }
    if (life < 0) {
        life = 0;
    }
    if (nowMonster->max_life < life) {
        life = nowMonster->max_life;
    }
    nowMonster->life = life;
    if (0 < life) {
        nowMonster->state = 1;
    }
    return 1;
}
int _GET_USERID(RS_STACKDATA *stack, int argument_count) {
    SetStack__FP12RS_STACKDATAi(stack, nowMonster->chara_type);
    return 1;
}
int _GET_MONSTER_ID(RS_STACKDATA *stack, int argument_count) {
    SetStack__FP12RS_STACKDATAi(stack, nowMonster->refer_no);
    return 1;
}
int _RESET_MOTION(RS_STACKDATA *, int) {
    nowMonster->ResetMotion();
    return 1;
}
int _GET_INDEX_POS(RS_STACKDATA *stack, int argument_count) {
    int index = GetStackInt__FP12RS_STACKDATA(stack++);
    int count = ActiveMonster->GetMonsterNum(-1.0f);
    int i;
    float pos[4];
    CActiveMonster *monster;

    for (i = 0; i < count; i++) {
        monster = ActiveMonster->active[i];
        if (monster->monster_id == index) {
            monster->GetPosition(pos);
            SetStack__FP12RS_STACKDATAf(stack++, pos[0]);
            SetStack__FP12RS_STACKDATAf(stack++, pos[1]);
            SetStack__FP12RS_STACKDATAf(stack, pos[2]);
            return 1;
        }
    }
    return 0;
}
extern "C" int _SET_CAMERA_NEXT_REF__FP12RS_STACKDATAi(RS_STACKDATA *stack,
                                                                int argument_count) {
    CCameraControl *camera;
    float x;
    float y;
    float z;

    camera = (CCameraControl *)nowScene->GetCamera(nowScene->active_camera);
    if (camera == NULL) {
        return 0;
    }
    camera->FollowOff();
    camera->ControlOff();
    x = GetStackFloat__FP12RS_STACKDATA(stack++);
    y = GetStackFloat__FP12RS_STACKDATA(stack++);
    z = GetStackFloat__FP12RS_STACKDATA(stack);
    camera->SetNextRef(x, y, z);
    return 1;
}
int _SET_ALPHA(RS_STACKDATA *stack, int argument_count) {
    float value = GetStackFloat__FP12RS_STACKDATA(stack);
    nowMonster->alpha = value;
    return 1;
}
int _SET_INDEX_ALPHA(RS_STACKDATA *stack, int argument_count) {
    int index = GetStackInt__FP12RS_STACKDATA(stack++);
    int count = ActiveMonster->GetMonsterNum(-1.0f);
    int i;
    CActiveMonster *monster;

    for (i = 0; i < count; i++) {
        monster = ActiveMonster->active[i];
        if (monster->monster_id == index) {
            monster->alpha = GetStackFloat__FP12RS_STACKDATA(stack);
            return 1;
        }
    }
    return 0;
}
int _SET_CAMERA_FOLLOW(RS_STACKDATA *stack, int argument_count) {
    CCameraControl *camera;

    camera = (CCameraControl *)nowScene->GetCamera(nowScene->active_camera);
    if (camera == NULL) {
        return 0;
    }
    if (GetStackInt__FP12RS_STACKDATA(stack) != 0) {
        camera->FollowOn();
        camera->ControlOn();
    } else {
        camera->FollowOff();
        camera->ControlOff();
    }
    return 1;
}
extern "C" int _SET_CAMERA_NEXT_POS__FP12RS_STACKDATAi(RS_STACKDATA *stack,
                                                                int argument_count) {
    CCameraControl *camera;
    float x;
    float y;
    float z;

    camera = (CCameraControl *)nowScene->GetCamera(nowScene->active_camera);
    if (camera == NULL) {
        return 0;
    }
    camera->FollowOff();
    camera->ControlOff();
    x = GetStackFloat__FP12RS_STACKDATA(stack++);
    y = GetStackFloat__FP12RS_STACKDATA(stack++);
    z = GetStackFloat__FP12RS_STACKDATA(stack);
    camera->SetNextPos(x, y, z);
    return 1;
}
int _GET_DIST_VECTOR(RS_STACKDATA *stack, int argument_count) {
    float vec[4];

    vec[0] = GetStackFloat__FP12RS_STACKDATA(stack++);
    vec[1] = GetStackFloat__FP12RS_STACKDATA(stack++);
    vec[2] = GetStackFloat__FP12RS_STACKDATA(stack++);
    vec[3] = 1.0f;
    SetStack__FP12RS_STACKDATAf(stack, mgDistVector(vec));
    return 1;
}
int _GET_DIST_VECTOR2(RS_STACKDATA *stack, int argument_count) {
    float from[4];
    float to[4];

    from[0] = GetStackFloat__FP12RS_STACKDATA(stack++);
    from[1] = GetStackFloat__FP12RS_STACKDATA(stack++);
    from[2] = GetStackFloat__FP12RS_STACKDATA(stack++);
    from[3] = 1.0f;
    to[0] = GetStackFloat__FP12RS_STACKDATA(stack++);
    to[1] = GetStackFloat__FP12RS_STACKDATA(stack++);
    to[2] = GetStackFloat__FP12RS_STACKDATA(stack++);
    to[3] = 1.0f;
    SetStack__FP12RS_STACKDATAf(stack, mgDistVector(from, to));
    return 1;
}
extern "C" int _SET_SCALE__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    ScriptVec scale;
    scale.v[0] = GetStackFloat__FP12RS_STACKDATA(stack++);
    scale.v[1] = GetStackFloat__FP12RS_STACKDATA(stack++);
    scale.v[2] = GetStackFloat__FP12RS_STACKDATA(stack);
    scale.w = 0x3F800000;
    ((CActionChara *)nowMonster)->SetScale(scale.v);
    return 1;
}
int _SET_PALLET_ANIM(RS_STACKDATA *stack, int argc) {
    int first;
    int second;
    int third;
    int fourth;
    int fifth;
    int sixth = 0;
    first = GetStackInt__FP12RS_STACKDATA(stack++);
    second = GetStackInt__FP12RS_STACKDATA(stack++);
    third = GetStackInt__FP12RS_STACKDATA(stack++);
    fourth = GetStackInt__FP12RS_STACKDATA(stack++);
    fifth = GetStackInt__FP12RS_STACKDATA(stack++);
    if (argc >= 6) {
        sixth = GetStackInt__FP12RS_STACKDATA(stack);
    }
    CActiveMonster *monster = nowMonster;
    monster->unk_67c.red = first;
    monster->unk_67c.green = second;
    monster->unk_67c.blue = third;
    monster->unk_67c.pulse_num = fourth;
    monster->unk_67c.duration = fifth;
    monster->unk_67c.elapsed = 0;
    monster->unk_67c.repeats = sixth;
    return 1;
}
int _RESET_PALLET_ANIM(RS_STACKDATA *stack, int argc) {
    CActiveMonster *monster = nowMonster;
    monster->unk_67c.duration = 0;
    monster->unk_67c.elapsed = 0;
    return 1;
}
int _CALC_IP_CIRCLE_LINE(RS_STACKDATA *stack, int argc) {
    float center[4];
    float line_a[4];
    float line_b[4];
    float hit1[4];
    float hit2[4];
    float center_x = GetStackFloat__FP12RS_STACKDATA(stack++);
    float center_z = GetStackFloat__FP12RS_STACKDATA(stack++);
    float radius = GetStackFloat__FP12RS_STACKDATA(stack++);
    float line_a_x = GetStackFloat__FP12RS_STACKDATA(stack++);
    float line_a_z = GetStackFloat__FP12RS_STACKDATA(stack++);
    float line_b_x = GetStackFloat__FP12RS_STACKDATA(stack++);
    float line_b_z = GetStackFloat__FP12RS_STACKDATA(stack++);
    center[0] = center_x;
    center[1] = 0.0f;
    center[2] = center_z;
    center[3] = 1.0f;
    line_a[0] = line_a_x;
    line_a[1] = 0.0f;
    line_a[2] = line_a_z;
    line_a[3] = 1.0f;
    line_b[0] = line_b_x;
    line_b[1] = 0.0f;
    line_b[2] = line_b_z;
    line_b[3] = 1.0f;
    int hit_count = CalcIntersectionPointSphereAndLine(center, radius, line_a, line_b, hit1, hit2);
    SetStack__FP12RS_STACKDATAi(stack++, hit_count);
    if (hit_count == 2) {
        SetStack__FP12RS_STACKDATAf(stack++, hit1[0]);
        SetStack__FP12RS_STACKDATAf(stack++, hit1[2]);
        SetStack__FP12RS_STACKDATAf(stack++, hit2[0]);
        SetStack__FP12RS_STACKDATAf(stack++, hit2[2]);
    }
    if (hit_count == 1) {
        SetStack__FP12RS_STACKDATAf(stack++, hit1[0]);
        SetStack__FP12RS_STACKDATAf(stack, hit1[2]);
    }
    return 1;
}
int _GET_POSREF_ANGLE(RS_STACKDATA *stack, int argc) {
    ScriptVec from;
    ScriptVec to;
    from.v[0] = GetStackFloat__FP12RS_STACKDATA(stack++);
    from.v[1] = GetStackFloat__FP12RS_STACKDATA(stack++);
    from.v[2] = GetStackFloat__FP12RS_STACKDATA(stack++);
    from.w = 0x3F800000;
    to.v[0] = GetStackFloat__FP12RS_STACKDATA(stack++);
    to.v[1] = GetStackFloat__FP12RS_STACKDATA(stack++);
    to.v[2] = GetStackFloat__FP12RS_STACKDATA(stack++);
    to.w = 0x3F800000;
    sceVu0SubVector(to.v, to.v, from.v);
    sceVu0Normalize(to.v, to.v);
    float yaw = atan2f(to.v[0], to.v[2]);
    float pitch = -atan2f(to.v[1], sqrtf(to.v[0] * to.v[0] + to.v[2] * to.v[2]));
    switch (argc) {
        case 7:
            SetStack__FP12RS_STACKDATAf(stack, yaw);
            break;
        case 9:
            SetStack__FP12RS_STACKDATAf(stack++, pitch);
            SetStack__FP12RS_STACKDATAf(stack++, yaw);
            SetStack__FP12RS_STACKDATAf(stack, 0.0f);
            break;
        default:
            return 0;
    }
    return 1;
}
extern "C" int _NORMAL_VECTOR__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    ScriptVec vec;
    vec.v[0] = stack[0].p->f;
    vec.v[1] = stack[1].p->f;
    vec.v[2] = stack[2].p->f;
    vec.w = 0x3F800000;
    sceVu0Normalize(vec.v, vec.v);
    SetStack__FP12RS_STACKDATAf(stack++, vec.v[0]);
    SetStack__FP12RS_STACKDATAf(stack++, vec.v[1]);
    SetStack__FP12RS_STACKDATAf(stack, vec.v[2]);
    return 1;
}
extern "C" int _COPY_VECTOR__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *source = stack;
    source += 3;
    float x = GetStackFloat__FP12RS_STACKDATA(source++);
    float y = GetStackFloat__FP12RS_STACKDATA(source++);
    float z = GetStackFloat__FP12RS_STACKDATA(source);
    SetStack__FP12RS_STACKDATAf(stack++, x);
    SetStack__FP12RS_STACKDATAf(stack++, y);
    SetStack__FP12RS_STACKDATAf(stack, z);
    return 1;
}
extern "C" int _ADD_VECTOR__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *source = stack;
    source += 3;
    float x = GetStackFloat__FP12RS_STACKDATA(source++);
    float y = GetStackFloat__FP12RS_STACKDATA(source++);
    float z = GetStackFloat__FP12RS_STACKDATA(source);
    SetStack__FP12RS_STACKDATAf(stack, stack[0].p->f + x);
    SetStack__FP12RS_STACKDATAf(stack + 1, stack[1].p->f + y);
    SetStack__FP12RS_STACKDATAf(stack + 2, stack[2].p->f + z);
    return 1;
}
extern "C" int _SUB_VECTOR__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *source = stack;
    source += 3;
    float x = GetStackFloat__FP12RS_STACKDATA(source++);
    float y = GetStackFloat__FP12RS_STACKDATA(source++);
    float z = GetStackFloat__FP12RS_STACKDATA(source);
    SetStack__FP12RS_STACKDATAf(stack, stack[0].p->f - x);
    SetStack__FP12RS_STACKDATAf(stack + 1, stack[1].p->f - y);
    SetStack__FP12RS_STACKDATAf(stack + 2, stack[2].p->f - z);
    return 1;
}
extern "C" int _SCALE_VECTOR__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    float scale = GetStackFloat__FP12RS_STACKDATA(stack + 3);
    SetStack__FP12RS_STACKDATAf(stack, stack[0].p->f * scale);
    SetStack__FP12RS_STACKDATAf(stack + 1, stack[1].p->f * scale);
    SetStack__FP12RS_STACKDATAf(stack + 2, stack[2].p->f * scale);
    return 1;
}
extern "C" int _DIV_VECTOR__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    float divisor = GetStackFloat__FP12RS_STACKDATA(stack + 3);
    if (0.0f == divisor) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAf(stack, stack[0].p->f / divisor);
    SetStack__FP12RS_STACKDATAf(stack + 1, stack[1].p->f / divisor);
    SetStack__FP12RS_STACKDATAf(stack + 2, stack[2].p->f / divisor);
    return 1;
}
extern "C" int _ANGLE_CMP__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    float angle = GetStackFloat__FP12RS_STACKDATA(stack++);
    float target = GetStackFloat__FP12RS_STACKDATA(stack++);
    float tolerance = GetStackFloat__FP12RS_STACKDATA(stack++);
    SetStack__FP12RS_STACKDATAi(stack, mgAngleCmp(angle, target, tolerance));
    return 1;
}
extern "C" int _ANGLE_LIMIT__FP12RS_STACKDATAi(RS_STACKDATA *stack, int unused) {
    SetStack__FP12RS_STACKDATAf(stack, mgAngleLimit(stack->p->f));
    return 1;
}
int _GET_TARGET_OLD_POS(RS_STACKDATA *stack, int argc) {
    float old_pos[4];
    CActionChara *target = (CActionChara *)nowScene->GetCharacter(nowMonster->target_no);
    if (target == NULL) {
        return 0;
    }
    sceVu0CopyVector(old_pos, target->old_pos);
    SetStack__FP12RS_STACKDATAf(stack++, old_pos[0]);
    SetStack__FP12RS_STACKDATAf(stack++, old_pos[1]);
    SetStack__FP12RS_STACKDATAf(stack, old_pos[2]);
    return 1;
}
int _GET_TARGET_SPEED(RS_STACKDATA *stack, int argc) {
    float pos[4];
    float old_pos[4];
    CActionChara *target = (CActionChara *)nowScene->GetCharacter(nowMonster->target_no);
    if (target == NULL) {
        return 0;
    }
    target->GetPosition(pos);
    sceVu0CopyVector(old_pos, target->old_pos);
    SetStack__FP12RS_STACKDATAf(stack, mgDistVector(pos, old_pos));
    return 1;
}
int _CALC_MOVE_NEXT_POS(RS_STACKDATA *stack, int argc) {
    float from[4];
    float to[4];
    float next[4];
    from[0] = GetStackFloat__FP12RS_STACKDATA(stack++);
    from[1] = GetStackFloat__FP12RS_STACKDATA(stack++);
    from[2] = GetStackFloat__FP12RS_STACKDATA(stack++);
    to[0] = GetStackFloat__FP12RS_STACKDATA(stack++);
    to[1] = GetStackFloat__FP12RS_STACKDATA(stack++);
    to[2] = GetStackFloat__FP12RS_STACKDATA(stack++);
    float distance = GetStackFloat__FP12RS_STACKDATA(stack++);
    int result = CalcMoveNextPos(from, to, distance, next);
    SetStack__FP12RS_STACKDATAf(stack++, next[0]);
    SetStack__FP12RS_STACKDATAf(stack++, next[1]);
    SetStack__FP12RS_STACKDATAf(stack++, next[2]);
    SetStack__FP12RS_STACKDATAi(stack, result);
    return 1;
}
int _GET_MONSTER_LIFE(RS_STACKDATA *stack, int argc) {
    if (stack->type != 3) {
        return 0;
    }
    RS_STACKDATA *slot = (RS_STACKDATA *)stack->i;
    if (slot->type == 0) {
        SetStack__FP12RS_STACKDATAi(stack, nowMonster->life);
    } else if (slot->type == 1) {
        SetStack__FP12RS_STACKDATAf(stack, (float)nowMonster->life / (float)nowMonster->max_life);
    } else {
        return 0;
    }
    return 1;
}
int _GET_NO_DAMAGE_CNT(RS_STACKDATA *stack, int argc) {
    SetStack__FP12RS_STACKDATAi(stack, nowMonster->no_damage_cnt);
    return 1;
}
int _GET_ACTIVE_MONS_LIFEI(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    int id = GetStackInt__FP12RS_STACKDATA(stack++);
    CActiveMonster *monster;
    if (id != -1) {
        id -= 24;
        monster = ActiveMonster->active[id];
        if (monster == NULL) {
            return 0;
        }
    } else {
        monster = nowMonster;
    }
    SetStack__FP12RS_STACKDATAi(stack, monster->life);
    return 1;
}
int _GET_ACTIVE_MONS_LIFEF(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    int id = GetStackInt__FP12RS_STACKDATA(stack++);
    CActiveMonster *monster;
    if (id != -1) {
        id -= 24;
        monster = ActiveMonster->active[id];
        if (monster == NULL) {
            return 0;
        }
    } else {
        monster = nowMonster;
    }
    SetStack__FP12RS_STACKDATAf(stack, (float)monster->life / (float)monster->max_life);
    return 1;
}
int _SET_ACTIVE_MONS_LIFEI(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    int id = GetStackInt__FP12RS_STACKDATA(stack++);
    int amount = GetStackInt__FP12RS_STACKDATA(stack);
    CActiveMonster *monster;
    if (id != -1) {
        id -= 24;
        monster = ActiveMonster->active[id];
        if (monster == NULL) {
            return 0;
        }
    } else {
        monster = nowMonster;
    }
    if (amount < 0) {
        int life = monster->life + amount;
        if (life < 0) {
            monster->life = 0;
        } else {
            monster->life = life;
        }
    } else {
        int life = monster->life + amount;
        if (monster->max_life < life) {
            monster->life = monster->max_life;
        } else {
            monster->life = life;
        }
    }
    return 1;
}
int _SET_ACTIVE_MONS_LIFEF(RS_STACKDATA *stack, int argc) {
    CActiveMonster *monster;
    int id;
    int max_life;
    int amount;
    float fraction;

    if (argc != 2) {
        return 0;
    }
    id = GetStackInt__FP12RS_STACKDATA(stack++);
    fraction = GetStackFloat__FP12RS_STACKDATA(stack);
    if (id != -1) {
        id -= 24;
        monster = ActiveMonster->active[id];
        if (monster == NULL) {
            return 0;
        }
    } else {
        monster = nowMonster;
    }
    max_life = monster->max_life;
    amount = fptosi((float)max_life * fraction);
    if (amount < 0) {
        amount = 0;
    }
    amount = monster->life + amount;
    if (max_life < amount) {
        monster->life = max_life;
    } else {
        monster->life = amount;
    }
    return 1;
}
int _GET_ACTIVE_MONS_MAX_LIFE(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    int id = GetStackInt__FP12RS_STACKDATA(stack++);
    CActiveMonster *monster;
    if (id != -1) {
        id -= 24;
        monster = ActiveMonster->active[id];
        if (monster == NULL) {
            return 0;
        }
    } else {
        monster = nowMonster;
    }
    SetStack__FP12RS_STACKDATAi(stack, monster->max_life);
    return 1;
}
int _SET_DAMAGE_SCORE(RS_STACKDATA *stack, int argc) {
    float pos[4];
    int color_flag;
    int id;
    int value;
    CActionChara *monster;
    if (argc != 3 && argc != 2) {
        return 0;
    }
    id = GetStackInt__FP12RS_STACKDATA(stack++);
    if (id != -1) {
        id -= 24;
        monster = (CActionChara *)ActiveMonster->active[id];
        if (monster == NULL) {
            return 0;
        }
    } else {
        monster = (CActionChara *)nowMonster;
    }
    value = GetStackInt__FP12RS_STACKDATA(stack++);
    if (argc == 3) {
        color_flag = GetStackInt__FP12RS_STACKDATA(stack);
    }
    monster->GetPosition(pos);
    pos[1] += ((CActiveMonster *)monster)->body_height;
    if (color_flag == 1) {
        DamageScore.SetColor(0x40, 0x80, 0x60);
    }
    DamageScore.SetValue(pos, value);
    return 1;
}
int _GET_MONS_GRADE(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    int id = GetStackInt__FP12RS_STACKDATA(stack++);
    CActiveMonster *monster;
    if (id != -1) {
        id -= 24;
        monster = ActiveMonster->active[id];
        if (monster == NULL) {
            return 0;
        }
    } else {
        monster = nowMonster;
    }
    SetStack__FP12RS_STACKDATAi(stack, monster->tbl->grade);
    return 1;
}
int _SET_ESCAPE_RATE(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    int id = GetStackInt__FP12RS_STACKDATA(stack++);
    CActiveMonster *monster;
    if (id != -1) {
        id -= 24;
        monster = ActiveMonster->active[id];
        if (monster == NULL) {
            return 0;
        }
    } else {
        monster = nowMonster;
    }
    float scale = GetStackFloat__FP12RS_STACKDATA(stack);
    monster->tbl->escape_rate[0] = fptosi((float)monster->base_tbl->escape_rate[0] * scale);
    monster->tbl->escape_rate[1] = fptosi((float)monster->base_tbl->escape_rate[1] * scale);
    if ((u8)monster->tbl->escape_rate[0] > 100) {
        monster->tbl->escape_rate[0] = 100;
    }
    if ((u8)monster->tbl->escape_rate[1] > 100) {
        monster->tbl->escape_rate[1] = 100;
    }
    return 1;
}
int _SET_GUARD_RATE(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    int id = GetStackInt__FP12RS_STACKDATA(stack++);
    CActiveMonster *monster;
    if (id != -1) {
        id -= 24;
        monster = ActiveMonster->active[id];
        if (monster == NULL) {
            return 0;
        }
    } else {
        monster = nowMonster;
    }
    float scale = GetStackFloat__FP12RS_STACKDATA(stack);
    monster->tbl->guard_rate = fptosi((float)monster->base_tbl->guard_rate * scale);
    if ((u8)monster->tbl->guard_rate > 100) {
        monster->tbl->guard_rate = 100;
    }
    return 1;
}
int _SET_EXT_PARAM_RATE(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }
    int id = GetStackInt__FP12RS_STACKDATA(stack++);
    int mask = GetStackInt__FP12RS_STACKDATA(stack++);
    float rate = GetStackFloat__FP12RS_STACKDATA(stack);
    int i;
    CActiveMonster *monster;
    if (id != -1) {
        id -= 24;
        monster = ActiveMonster->active[id];
        if (monster == NULL) {
            return 0;
        }
    } else {
        monster = nowMonster;
    }
    for (i = 0; i < 12; i++) {
        if (mask & (1 << i)) {
            monster->tbl->ext_param[i] = fptosi((float)monster->base_tbl->ext_param[i] * rate);
            if (monster->tbl->ext_param[i] > 100) {
                monster->tbl->ext_param[i] = 100;
            }
        }
    }
    return 1;
}
int _GET_BOSS_FLAG(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi(stack, nowMonster->base_tbl->boss);
    return 1;
}
int _RESET_TIMER(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *block;

    block = (DNG_BATTLE_AREA *)&nowScene->battle_area;

    if (block == NULL) {
        return 0;
    }
    block->timer = 0;
    return 1;
}
int _GET_TIMER(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *block;

    block = (DNG_BATTLE_AREA *)&nowScene->battle_area;

    if (block == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi(stack, block->timer);
    return 1;
}
int _GET_FRAME_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];
    char *name = (char *)GetStackString__FP12RS_STACKDATA(stack++);
    mgCFrame *root = nowMonster->CObjectFrame::frame;
    if (root == NULL) {
        return 0;
    }
    mgCFrame *frame = root->SearchFrame(name);
    if (frame == NULL) {
        return 0;
    }
    frame->GetWorldPosition0(pos);
    SetStack__FP12RS_STACKDATAf(stack++, pos[0]);
    SetStack__FP12RS_STACKDATAf(stack++, pos[1]);
    SetStack__FP12RS_STACKDATAf(stack, pos[2]);
    return 1;
}
int _MY_SE_PLAY(RS_STACKDATA *stack, int argc) {
    float pos[4];
    float volume;
    float pan;
    int se_id = GetStackInt__FP12RS_STACKDATA(stack);
    u32 se_handle = nowMonster->se_bank;
    ((CActionChara *)nowMonster)->GetPosition(pos);

    float far = 1200.0f;
    float near = 160.0f;
    sndGetVolPan(&volume, &pan, pos, near, far);
    sndSePlayVPf(se_handle, se_id, volume, pan, 0);
    return 1;
}
int _MY_SE_STOP(RS_STACKDATA *stack, int argc) {
    int id = GetStackInt__FP12RS_STACKDATA(stack);
    sndSeStop(nowMonster->se_bank, id, 0);
    return 1;
}
int _GET_EVENT_INFO(RS_STACKDATA *stack, int argc) {
    int selector = GetStackInt__FP12RS_STACKDATA(stack++);
    switch (selector) {
        case 0:
            SetStack__FP12RS_STACKDATAi(stack, (int)EdEventInfo.stopwatch_limit);
            break;
        default:
            return 0;
    }
    return 1;
}
int _ESM_ALL_CLEAR(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    FxScriptMan->ClearEffectFromChrid(GetStackInt__FP12RS_STACKDATA(stack));
    return 1;
}
int _GET_ANGLE_INNER(RS_STACKDATA *stack, int argc) {
    ScriptVector first;
    ScriptVector second;
    float matrix[4][4];
    float rotated[4][4];
    if (argc != 3) {
        return 0;
    }
    float angle_a = GetStackFloat__FP12RS_STACKDATA(stack++);
    float angle_b = GetStackFloat__FP12RS_STACKDATA(stack++);
    first = at_1480__2;
    second = at_1481__2;
    sceVu0UnitMatrix(matrix);
    sceVu0RotMatrixY(rotated, matrix, angle_a);
    sceVu0ApplyMatrix(first.f, rotated, first.f);
    sceVu0RotMatrixY(rotated, matrix, angle_b);
    sceVu0ApplyMatrix(second.f, rotated, second.f);
    SetStack__FP12RS_STACKDATAf(stack, sceVu0InnerProduct(first.f, second.f));
    return 1;
}
extern "C" int _CAMERA_QUAKE__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *quake = (DNG_BATTLE_AREA *)&nowScene->battle_area;
    RS_STACKDATA *next = stack + 1;

    if (quake == NULL) {
        return 0;
    }
    float amplitude = GetStackFloat__FP12RS_STACKDATA(stack);
    int frames = GetStackInt__FP12RS_STACKDATA(next);
    quake->quake_power = amplitude;
    quake->quake_step = quake->quake_power / (float)frames;
    quake->quake_count = frames;
    return 1;
}
int _SET_CAMERA_MODE(RS_STACKDATA *stack, int argc) {
    int mode;
    DNG_BATTLE_AREA *area;

    mode = GetStackInt__FP12RS_STACKDATA(stack);
    area = (DNG_BATTLE_AREA *)&nowScene->battle_area;

    if (area == NULL) {
        return 0;
    }
    area->unk_54 = mode;
    return 1;
}
extern "C" int _SET_CAMERA_SPEED__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    mgCCamera *camera = nowScene->GetCamera(nowScene->active_camera);
    if (camera == NULL) {
        return 0;
    }
    camera->SetSpeed(GetStackFloat__FP12RS_STACKDATA(stack), -1.0f);
    return 1;
}
#ifdef NONMATCHING
static int _SET_CAMERA_CTRL_PARAM1(RS_STACKDATA *args, int argc) {
    CameraCtrlParam *param;
    float            value;

    if (argc > 0 && argc < 5) {
        return 0;
    }
    param = ((CCameraControl *)nowScene->GetCamera(nowScene->active_camera))->GetActiveParam();
    if (argc >= 1) {
        value = GetStackFloat__FP12RS_STACKDATA(args + 0);
    }
    if (value != -99999.9 && argc >= 1) {
        param->min_dist = value;
    }
    if (argc >= 2) {
        value = GetStackFloat__FP12RS_STACKDATA(args + 1);
    }
    if (value != -99999.9 && argc >= 2) {
        param->max_dist = value;
    }
    if (argc >= 3) {
        value = GetStackFloat__FP12RS_STACKDATA(args + 2);
    }
    if (value != -99999.9 && argc >= 3) {
        param->near_height = value;
    }
    if (argc >= 4) {
        value = GetStackFloat__FP12RS_STACKDATA(args + 3);
    }
    if (value != -99999.9 && argc >= 4) {
        param->far_height = value;
    }
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/runscript_opcodes", _SET_CAMERA_CTRL_PARAM1__FP12RS_STACKDATAi);
#endif
#ifdef NONMATCHING
static int _SET_CAMERA_CTRL_PARAM2(RS_STACKDATA *args, int argc) {
    CameraCtrlParam *param;
    float            value;

    if (argc > 0 && argc < 7) {
        return 0;
    }
    param = ((CCameraControl *)nowScene->GetCamera(nowScene->active_camera))->GetActiveParam();
    if (argc >= 1) {
        value = GetStackFloat__FP12RS_STACKDATA(args + 0);
    }
    if (value != -99999.9 && argc >= 1) {
        param->height = value;
    }
    if (argc >= 2) {
        value = GetStackFloat__FP12RS_STACKDATA(args + 1);
    }
    if (value != -99999.9 && argc >= 2) {
        param->max_height = value;
    }
    if (argc >= 3) {
        value = GetStackFloat__FP12RS_STACKDATA(args + 2);
    }
    if (value != -99999.9 && argc >= 3) {
        param->min_height = value;
    }
    if (argc >= 4) {
        value = GetStackFloat__FP12RS_STACKDATA(args + 3);
    }
    if (value != -99999.9 && argc >= 4) {
        param->rest_max_height = value;
    }
    if (argc >= 5) {
        value = GetStackFloat__FP12RS_STACKDATA(args + 4);
    }
    if (value != -99999.9 && argc >= 5) {
        param->rest_min_height = value;
    }
    if (argc >= 6) {
        value = GetStackFloat__FP12RS_STACKDATA(args + 5);
    }
    if (value != -99999.9 && argc >= 6) {
        param->ground_space = value;
    }
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/runscript_opcodes", _SET_CAMERA_CTRL_PARAM2__FP12RS_STACKDATAi);
#endif
int _RESET_CAMERA_CTRL_PARAM(RS_STACKDATA *stack, int argc) {

    CameraCtrlParam *param;

    param = ((CCameraControl *)nowScene->GetCamera(nowScene->active_camera))->GetActiveParam();
    param->min_dist = 100.0f;
    param->max_dist = 160.0f;
    param->near_height = 18.0f;
    param->far_height = 10.0f;
    param->max_height = 40.0f;
    param->min_height = -15.0f;
    param->rest_max_height = 20.0f;
    param->rest_min_height = -15.0f;
    param->height = -15.0f;
    param->ground_space = 25.0f;
    return 1;
}
int _GET_RND(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    int range = GetStackInt__FP12RS_STACKDATA(stack++);

    argc = fptosi((float)range * (float)rand() / 2147483648.0f);
    SetStack__FP12RS_STACKDATAi(stack, argc);
    return 1;
}
int _GET_RNDF(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    float range = GetStackFloat__FP12RS_STACKDATA(stack++);
    SetStack__FP12RS_STACKDATAf(stack, (float)fptosi(range * (float)rand() / 2147483648.0f));
    return 1;
}
int _V_PUSH(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    int index = GetStackInt__FP12RS_STACKDATA(stack++);
    if (index < 0) {
        return 0;
    }
    if (stack->type == 0) {
        if (index < MONSTER_VAR_MAX) {
            int value = GetStackInt__FP12RS_STACKDATA(stack);
            ScriptVariable *vars = nowMonster->var;
            vars[index].i = value;
        }
        if (index >= MONSTER_VAR_MAX && index < 0x88) {
            int value = GetStackInt__FP12RS_STACKDATA(stack);
            ScriptVariable *vars = ActiveMonster->share_var - MONSTER_VAR_MAX;
            vars[index].i = value;
        }
        return 1;
    }
    if (stack->type == 1) {
        if (index < MONSTER_VAR_MAX) {
            float value = GetStackFloat__FP12RS_STACKDATA(stack);
            ScriptVariable *vars = nowMonster->var;
            vars[index].f = value;
        }
        if (index >= MONSTER_VAR_MAX && index < 0x88) {
            float value = GetStackFloat__FP12RS_STACKDATA(stack);
            ScriptVariable *vars = ActiveMonster->share_var - MONSTER_VAR_MAX;
            vars[index].f = value;
        }
        return 1;
    }
    return 1;
}
int _V_POP(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    int index = GetStackInt__FP12RS_STACKDATA(stack++);
    if (index < 0) {
        return 0;
    }
    if (stack->type != 3) {
        return 0;
    }
    RS_STACKDATA *slot = (RS_STACKDATA *)stack->i;
    if (slot->type == 0) {
        if (index < MONSTER_VAR_MAX) {
            ScriptVariable *vars = nowMonster->var;
            SetStack__FP12RS_STACKDATAi(stack, vars[index].i);
        }
        if (index >= MONSTER_VAR_MAX && index < 0x88) {
            ScriptVariable *vars = ActiveMonster->share_var - MONSTER_VAR_MAX;
            SetStack__FP12RS_STACKDATAi(stack, vars[index].i);
        }
        return 1;
    } else if (slot->type == 1) {
        if (index < MONSTER_VAR_MAX) {
            ScriptVariable *vars = nowMonster->var;
            SetStack__FP12RS_STACKDATAf(stack, vars[index].f);
        }
        if (index >= MONSTER_VAR_MAX && index < 0x88) {
            ScriptVariable *vars = ActiveMonster->share_var - MONSTER_VAR_MAX;
            SetStack__FP12RS_STACKDATAf(stack, vars[index].f);
        }
        return 1;
    }
    return 1;
}
int _V_PUSH2(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    int index = GetStackInt__FP12RS_STACKDATA(stack++);
    if (index < 0) {
        return 0;
    }
    if (stack->type == 0) {
        if (index < MONSTER_VAR2_MAX) {
            int value = GetStackInt__FP12RS_STACKDATA(stack);
            ScriptVariable *vars = nowMonster->var2;
            vars[index].i = value;
        } else {
            return 0;
        }
        return 1;
    } else if (stack->type == 1) {
        if (index < MONSTER_VAR2_MAX) {
            float value = GetStackFloat__FP12RS_STACKDATA(stack);
            ScriptVariable *vars = nowMonster->var2;
            vars[index].f = value;
        } else {
            return 0;
        }
        return 1;
    }
    return 1;
}
int _V_POP2(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    int index = GetStackInt__FP12RS_STACKDATA(stack++);
    if (index < 0) {
        return 0;
    }
    if (stack->type != 3) {
        return 0;
    }
    RS_STACKDATA *slot = (RS_STACKDATA *)stack->i;
    if (slot->type == 0) {
        if (index < MONSTER_VAR2_MAX) {
            ScriptVariable *vars = nowMonster->var2;
            SetStack__FP12RS_STACKDATAi(stack, vars[index].i);
        } else {
            return 0;
        }
        return 1;
    } else if (slot->type == 1) {
        if (index < MONSTER_VAR2_MAX) {
            ScriptVariable *vars = nowMonster->var2;
            SetStack__FP12RS_STACKDATAf(stack, vars[index].f);
        } else {
            return 0;
        }
        return 1;
    }
    return 1;
}
int _SET_LOCKON_MODE(RS_STACKDATA *stack, int argc) {
    if (argc != 1)
        return 0;
    s16 v = (s16)GetStackInt__FP12RS_STACKDATA(stack);
    nowScene->battle_area.unk_9e = v;
    return 1;
}
int _GET_MONSTER_NUM(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    argc = ActiveMonster->GetMonsterNum(-1.0f);
    SetStack__FP12RS_STACKDATAi(stack, argc);
    return 1;
}
int _GET_DIST(RS_STACKDATA *stack, int argc) {
    float target[4];
    float self_pos[4];
    if (argc != 4) {
        return 0;
    }
    target[0] = GetStackFloat__FP12RS_STACKDATA(stack++);
    target[1] = GetStackFloat__FP12RS_STACKDATA(stack++);
    target[2] = GetStackFloat__FP12RS_STACKDATA(stack++);
    ((CActionChara *)nowMonster)->GetPosition(self_pos);
    SetStack__FP12RS_STACKDATAf(stack, mgDistVector(target, self_pos));
    return 1;
}
extern "C" int _SET_OBJ__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    int index = GetStackInt__FP12RS_STACKDATA(stack++);
    char *name = GetStackString__FP12RS_STACKDATA(stack);
    return ((CActionChara *)nowMonster)->EntryObject(name, index) != 0;
}
extern "C" int _SET_BODY__FP12RS_STACKDATAi(void) {
    printf(at_1728);
    return 1;
}
int _SET_DMG(RS_STACKDATA *stack, int argc) {
    printf(at_1733);
    return 1;
}
extern "C" int _SET_DMG2__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    float pos[4];
    mgCFrame *frameA;
    mgCFrame *frameB;
    CHARA_ENTRY_OBJECT *object;
    char *hitName = GetStackString__FP12RS_STACKDATA(stack++);
    float power = 2.0f * GetStackFloat__FP12RS_STACKDATA(stack++);
    char *motion = GetStackString__FP12RS_STACKDATA(stack++);
    float start_ratio = GetStackFloat__FP12RS_STACKDATA(stack++);
    float end_ratio = GetStackFloat__FP12RS_STACKDATA(stack++);
    int index_a = GetStackInt__FP12RS_STACKDATA(stack++);
    int index_b = -1;
    if (argc == 7) {
        index_b = GetStackInt__FP12RS_STACKDATA(stack);
    }
    frameB = NULL;
    object = (CHARA_ENTRY_OBJECT *)((CCharacter2 *)nowMonster)->GetEntryObjectPos(3, index_a, pos);
    if (object == NULL) {
        return 0;
    }
    frameA = object->frame;
    if (power <= 0.0f) {
        power = object->unk_04;
    }
    if (index_b >= 0) {
        object = (CHARA_ENTRY_OBJECT *)((CCharacter2 *)nowMonster)->GetEntryObjectPos(3, index_b, pos);
        if (object != NULL) {
            frameB = object->frame;
        }
    }
    LastCInfo2 =
        ((CActionChara *)nowMonster)
            ->EntryDamage2(frameA, frameB, hitName, power, motion, start_ratio, end_ratio, NULL);
    return LastCInfo2 != NULL;
}
int _GET_OBJ_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];
    char *objectName;
    mgCFrame *object;
    CActionChara *chara;
    char *charaName;

    if (argc < 4 || argc > 5) {
        return 0;
    }
    objectName = GetStackString__FP12RS_STACKDATA(stack++);
    charaName = NULL;
    if (argc == 5) {
        charaName = GetStackString__FP12RS_STACKDATA(stack + 3);
    }
    if (argc == 5) {
        chara = ((CActionChara *)nowMonster)->SearchChara(charaName);
        if (chara != NULL) {
            object = chara->SearchObject(objectName);
        }
    } else {
        object = ((CActionChara *)nowMonster)->SearchObject(objectName);
    }
    if (object == NULL) {
        return 0;
    }
    object->GetWorldPosition0(pos);
    SetStack__FP12RS_STACKDATAf(stack++, pos[0]);
    SetStack__FP12RS_STACKDATAf(stack++, pos[1]);
    SetStack__FP12RS_STACKDATAf(stack, pos[2]);
    return 1;
}
int _GET_MAPOBJ_POS(RS_STACKDATA *stack, int argc) {
    float matrix[4][4];
    float pos[4];
    if (argc != 4) {
        return 0;
    }
    if (nowMonster->link_piece == NULL || nowMonster->link_parts == NULL) {
        return 0;
    }
    char *name = GetStackString__FP12RS_STACKDATA(stack++);
    CMapPiece *piece = nowMonster->link_piece;
    piece->UpDatePosition();
    piece = nowMonster->link_piece;
    mgCFrame *frame = piece->frame->SearchFrame(name);
    if (frame == NULL) {
        printf(at_1784);
    }
    if (frame == NULL) {
        return 0;
    }
    frame->GetWorldPosition0(pos);
    nowMonster->link_parts->GetLWMatrix(matrix);
    sceVu0ApplyMatrix(pos, matrix, pos);
    SetStack__FP12RS_STACKDATAf(stack++, pos[0]);
    SetStack__FP12RS_STACKDATAf(stack++, pos[1]);
    SetStack__FP12RS_STACKDATAf(stack, pos[2]);
    return 1;
}
int _LINK_MAP_TO_OBJECT(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    if (DngMainMap == NULL) {
        return 0;
    }
    nowMonster->link_parts =
        (CMapParts *)DngMainMap->GetPlaceParts( GetStackString__FP12RS_STACKDATA(stack));
    if (nowMonster->link_parts == NULL) {
        return 0;
    }
    nowMonster->link_type = 1;
    return 1;
}
int _LINK_OBJECT_TO_PIECE(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    if (DngMainMap == NULL) {
        return 0;
    }
    char *partName = GetStackString__FP12RS_STACKDATA(stack++);
    char *pieceName = GetStackString__FP12RS_STACKDATA(stack);
    nowMonster->link_parts = (CMapParts *)DngMainMap->GetPlaceParts( partName);
    if (nowMonster->link_parts == NULL) {
        return 0;
    }
    nowMonster->link_piece = nowMonster->link_parts->SearchPiece(pieceName);
    if (nowMonster->link_piece == NULL) {
        return 0;
    }
    nowMonster->link_type = 2;
    return 1;
}
int _SET_SCOOP(RS_STACKDATA *stack, int argc) {
    if (argc != 1 && argc != 4) {
        return 0;
    }
    if (argc == 1) {
        nowMonster->scoop.type = 2;
        nowMonster->scoop.no = GetStackInt__FP12RS_STACKDATA(stack++);
    }
    if (argc == 4) {
        nowMonster->scoop.type = 1;
        nowMonster->scoop.motion = GetStackString__FP12RS_STACKDATA(stack++);
        nowMonster->scoop.start = GetStackFloat__FP12RS_STACKDATA(stack++);
        nowMonster->scoop.end = GetStackFloat__FP12RS_STACKDATA(stack++);
        nowMonster->scoop.no = GetStackInt__FP12RS_STACKDATA(stack);
    }
    return 1;
}
int _LOAD_RESERV_IMG(RS_STACKDATA *stack, int argc) {
    int file_size;
    if (argc != 2) {
        return 0;
    }
    int slot = GetStackInt__FP12RS_STACKDATA(stack++);
    if (slot < 0 || slot > 1) {
        return 0;
    }
    if (LoadFile2(GetStackString__FP12RS_STACKDATA(stack), BuffReadData, &file_size, 0) == 0) {
        return 0;
    }
    mgCMemory *memory = (mgCMemory *)nowScene->GetStack(3);
    if (memory == NULL) {
        return 0;
    }
    void *image = (void *)memory->Alloc(file_size / 16 + 1);
    if (image == NULL) {
        return 0;
    }
    memcpy(image, BuffReadData, file_size);
    nowMonster->reserv_img[slot] = image;
    nowMonster->reserv_img_size[slot] = file_size;
    return 1;
}
int _SET_PRIORITY_LIMMIT(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    int value = GetStackInt__FP12RS_STACKDATA(stack);
    if (value < 0 || value >= MONSTER_ACTIVE_MAX) {
        return 0;
    }
    ActiveMonster->priority_limit = value;
    return 1;
}
int _GET_PLACE_POS(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAf(stack++, nowMonster->place_pos[0]);
    SetStack__FP12RS_STACKDATAf(stack++, nowMonster->place_pos[1]);
    SetStack__FP12RS_STACKDATAf(stack, nowMonster->place_pos[2]);
    return 1;
}
int _SET_PLACE_POS(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }
    nowMonster->place_pos[0] = GetStackFloat__FP12RS_STACKDATA(stack++);
    nowMonster->place_pos[1] = GetStackFloat__FP12RS_STACKDATA(stack++);
    nowMonster->place_pos[2] = GetStackFloat__FP12RS_STACKDATA(stack);
    return 1;
}
int _SEARCH_AREA(RS_STACKDATA *stack, int argc) {
    ScriptVector dir;
    float pos[4];
    float rot[4];
    float matrix[4][4];
    if (argc != 3) {
        return 0;
    }
    float distance = GetStackFloat__FP12RS_STACKDATA(stack++);
    float angle = GetStackFloat__FP12RS_STACKDATA(stack++);
    dir = at_1864;
    ((CActionChara *)nowMonster)->GetPosition(pos);
    ((CActionChara *)nowMonster)->GetRotation(rot);
    rot[1] = mgAngleLimit(rot[1] + angle);
    sceVu0UnitMatrix(matrix);
    sceVu0RotMatrixY(matrix, matrix, rot[1]);
    sceVu0ApplyMatrix(dir.f, matrix, dir.f);
    sceVu0ScaleVector(dir.f, dir.f, distance);
    sceVu0AddVector(dir.f, dir.f, pos);
    pos[1] += 100.0f;
    dir.f[1] += 100.0f;
    SetStack__FP12RS_STACKDATAf(stack, SearchArea(nowScene, pos, dir.f, distance));
    return 1;
}
int _SEARCH_AREA2(RS_STACKDATA *stack, int argc) {
    float from[4];
    float to[4];
    if (argc != 7) {
        return 0;
    }
    GetStackVector__FPfPP12RS_STACKDATA(from, &stack);
    GetStackVector__FPfPP12RS_STACKDATA(to, &stack);
    SetStack__FP12RS_STACKDATAf(stack++, SearchArea(nowScene, from, to, mgDistVector(from, to)));
    return 1;
}
extern "C" int _SET_MODEL_LIGHT_SWITCH__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    mgCFrame *frame;
    char *name;
    int flag;
    mgCFrameAttr *attr;

    if (argc <= 0 || argc > 2) {
        return 0;
    }
    flag = GetStackInt__FP12RS_STACKDATA(stack++);
    name = NULL;
    if (argc == 2) {
        name = GetStackString__FP12RS_STACKDATA(stack);
    }
    frame = nowMonster->CObjectFrame::frame;
    if (name != NULL) {
        frame = frame->SearchFrame(name);
    }
    if (frame == NULL) {
        return 0;
    }
    attr = frame->attr;
    if (flag != 0) {
        attr->no_light = 0;
        frame->SetAttrParam(*attr, 1, 0x8000);
    } else {
        attr->no_light = 1;
        attr->color[0] = 128.0f;
        attr->color[1] = 128.0f;
        attr->color[2] = 128.0f;
        attr->color[3] = 128.0f;
        frame->SetAttrParam(*attr, 1, 0x18000);
    }
    return 1;
}
extern "C" int _SET_MODEL_LIGHT_COLOR__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    mgCFrame *frame;
    char *name;
    mgCFrameAttr *attr;
    float red;
    float green;
    float blue;
    float alpha;

    if (argc < 4 || argc > 5) {
        return 0;
    }
    name = NULL;
    red = GetStackFloat__FP12RS_STACKDATA(stack++);
    green = GetStackFloat__FP12RS_STACKDATA(stack++);
    blue = GetStackFloat__FP12RS_STACKDATA(stack++);
    alpha = GetStackFloat__FP12RS_STACKDATA(stack++);
    if (argc == 5) {
        name = GetStackString__FP12RS_STACKDATA(stack);
    }
    frame = nowMonster->CObjectFrame::frame;
    if (name != NULL) {
        frame = frame->SearchFrame(name);
    }
    if (frame == NULL) {
        return 0;
    }
    attr = frame->attr;
    attr->no_light = 1;
    attr->color[0] = red;
    attr->color[1] = green;
    attr->color[2] = blue;
    attr->color[3] = alpha;
    frame->SetAttrParam(*attr, 1, 0x10000);
    return 1;
}
int _SET_DEF_RATE(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    float rate = GetStackFloat__FP12RS_STACKDATA(stack);
    CActiveMonster *self = nowMonster;
    u32 base = self->tbl->defense;
    self->defense = fptoui((float)base * rate);
    return 1;
}
extern "C" int _GET_POS__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    float pos[4];
    if (argc != 3) {
        return 0;
    }
    ((CActionChara *)nowMonster)->GetPosition(pos);
    SetStack__FP12RS_STACKDATAf(stack++, pos[0]);
    SetStack__FP12RS_STACKDATAf(stack++, pos[1]);
    SetStack__FP12RS_STACKDATAf(stack, pos[2]);
    return 1;
}
int _SET_POS(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }
    float x = GetStackFloat__FP12RS_STACKDATA(stack++);
    float y = GetStackFloat__FP12RS_STACKDATA(stack++);
    float z = GetStackFloat__FP12RS_STACKDATA(stack);
    ((CActionChara *)nowMonster)->SetPosition(x, y, z);
    return 1;
}
extern "C" int _GET_ROT__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    float rot[4];
    if (argc < 3 || argc > 4) {
        return 0;
    }
    if (argc == 4) {
        int id = GetStackInt__FP12RS_STACKDATA(stack++);
        CActionChara *chara = (CActionChara *)nowScene->GetCharacter(id + 24);
        if (chara == NULL) {
            return 0;
        }
        chara->GetRotation(rot);
    } else {
        ((CActionChara *)nowMonster)->GetRotation(rot);
    }
    SetStack__FP12RS_STACKDATAf(stack++, rot[0]);
    SetStack__FP12RS_STACKDATAf(stack++, rot[1]);
    SetStack__FP12RS_STACKDATAf(stack, rot[2]);
    return 1;
}
int _SET_ROT(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }
    float x = GetStackFloat__FP12RS_STACKDATA(stack++);
    float y = GetStackFloat__FP12RS_STACKDATA(stack++);
    float z = GetStackFloat__FP12RS_STACKDATA(stack);
    ((CActionChara *)nowMonster)->SetRotation(x, y, z);
    nowMonster->rot_speed = 0.0f;
    return 1;
}
int _SET_NEXT_ROT(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    nowMonster->next_rot = GetStackFloat__FP12RS_STACKDATA(stack++);
    nowMonster->rot_speed = GetStackFloat__FP12RS_STACKDATA(stack);
    return 1;
}
int _SET_NEXT_POS(RS_STACKDATA *stack, int argc) {
    float target[4];
    float pos[4];
    if (argc < 3 || argc > 5) {
        return 0;
    }
    target[0] = GetStackFloat__FP12RS_STACKDATA(stack++);
    target[1] = GetStackFloat__FP12RS_STACKDATA(stack++);
    target[2] = GetStackFloat__FP12RS_STACKDATA(stack++);
    nowMonster->next_pos[0] = target[0];
    nowMonster->next_pos[1] = target[1];
    nowMonster->next_pos[2] = target[2];
    nowMonster->move_speed = GetStackFloat__FP12RS_STACKDATA(stack++);
    nowMonster->arrive_dist = 20.0f;
    if (argc >= 5) {
        nowMonster->arrive_dist = GetStackFloat__FP12RS_STACKDATA(stack);
    }
    ((CActionChara *)nowMonster)->GetPosition(pos);
    if (mgDistVector(target, pos) < nowMonster->arrive_dist) {
        nowMonster->move_speed = 0.0f;
    }
    return 1;
}
int _CHK_MOVE_END(RS_STACKDATA *stack, int argc) {
    float pos[4];
    int arrived;
    if (argc != 1) {
        return 0;
    }
    arrived = 0;
    ((CActionChara *)nowMonster)->GetPosition(pos);
    if (mgDistVector(pos, nowMonster->next_pos) < nowMonster->arrive_dist) {
        arrived = 1;
    }
    SetStack__FP12RS_STACKDATAi(stack, arrived);
    return 1;
}
int _RESET_MOVE(RS_STACKDATA *stack, int argument_count) {
    nowMonster->move_speed = 0.0f;
    return 1;
}
int _GET_TARGET_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];
    float self_pos[4];
    if (argc < 3 || argc > 4) {
        return 0;
    }
    CActionChara *target = (CActionChara *)nowScene->GetCharacter(nowMonster->target_no);
    if (target == NULL) {
        return 0;
    }
    target->GetPosition(pos);
    SetStack__FP12RS_STACKDATAf(stack++, pos[0]);
    SetStack__FP12RS_STACKDATAf(stack++, pos[1]);
    SetStack__FP12RS_STACKDATAf(stack++, pos[2]);
    if (argc == 4) {
        ((CActionChara *)nowMonster)->GetPosition(self_pos);
        SetStack__FP12RS_STACKDATAf(stack, mgDistVector(self_pos, pos));
    }
    return 1;
}
int _GET_TARGET_DIST(RS_STACKDATA *stack, int argc) {
    float target_pos[4];
    float self_pos[4];
    if (argc != 1) {
        return 0;
    }
    CActionChara *target = (CActionChara *)nowScene->GetCharacter(nowMonster->target_no);
    if (target == NULL) {
        return 0;
    }
    target->GetPosition(target_pos);
    ((CActionChara *)nowMonster)->GetPosition(self_pos);
    SetStack__FP12RS_STACKDATAf(stack, mgDistVector(target_pos, self_pos));
    return 1;
}
int _GET_TARGET_ANGLE(RS_STACKDATA *stack, int argc) {
    float delta[4];
    float self_pos[4];
    if (argc != 1) {
        return 0;
    }
    CActionChara *target = (CActionChara *)nowScene->GetCharacter(nowMonster->target_no);
    if (target == NULL) {
        return 0;
    }
    target->GetPosition(delta);
    ((CActionChara *)nowMonster)->GetPosition(self_pos);
    sceVu0SubVector(delta, delta, self_pos);
    SetStack__FP12RS_STACKDATAf(stack, atan2f(delta[0], delta[2]));
    return 1;
}
int _GET_TARGET_REF_POS(RS_STACKDATA *stack, int argc) {
    float matrix[4][4];
    float pos[4];

    ScriptVecRawZ offset;
    if (argc != 5) {
        return 0;
    }
    float angle = GetStackFloat__FP12RS_STACKDATA(stack++);
    float distance = GetStackFloat__FP12RS_STACKDATA(stack++);
    CActionChara *target = (CActionChara *)nowScene->GetCharacter(nowMonster->target_no);
    if (target == NULL) {
        return 0;
    }
    target->GetPosition(pos);
    offset.v[0] = 0.0f;
    offset.v[1] = 0.0f;
    offset.z = 0x3F800000;
    sceVu0Normalize(offset.v, offset.v);
    sceVu0UnitMatrix(matrix);
    sceVu0RotMatrixY(matrix, matrix, angle);
    sceVu0ApplyMatrix(offset.v, matrix, offset.v);
    sceVu0ScaleVector(offset.v, offset.v, distance);
    sceVu0AddVector(pos, pos, offset.v);
    SetStack__FP12RS_STACKDATAf(stack++, pos[0]);
    SetStack__FP12RS_STACKDATAf(stack++, pos[1]);
    SetStack__FP12RS_STACKDATAf(stack, pos[2]);
    return 1;
}
#ifdef NONMATCHING
static int _GET_REF_DIR(RS_STACKDATA *args, int argc) {
    sceVu0FVECTOR target_position;
    sceVu0FVECTOR position;
    sceVu0FVECTOR front;
    float         distance;
    float         front_angle;
    float         angle;
    int           direction;

    if (argc < 4 || argc > 5) {
        return 0;
    }
    target_position[0] = GetStackFloat__FP12RS_STACKDATA(args++);
    target_position[1] = GetStackFloat__FP12RS_STACKDATA(args++);
    target_position[2] = GetStackFloat__FP12RS_STACKDATA(args++);
    target_position[3] = 1.0f;
    distance = GetStackFloat__FP12RS_STACKDATA(args++);
    nowMonster->GetPosition(position);
    if (mgDistVector(position, target_position) < distance) {
        SetStack__FP12RS_STACKDATAi(args++, 0);
    }
    sceVu0SubVector(target_position, target_position, position);
    sceVu0Normalize(target_position, target_position);
    sceVu0CopyVector(front, nowMonster->front_vec);
    front_angle = atan2f(front[0], front[2]);
    angle = atan2f(target_position[0], target_position[2]) - front_angle;
    if (angle < -3.1415927f) {
        angle += 6.2831855f;
    }
    direction = 0;
    if (angle > -0.8f && angle < 0.8f) {
        direction = 1;
    }
    if (angle < -2.2f || angle > 2.2f) {
        direction = 2;
    }
    if (angle < -0.8f && angle > -3.0f) {
        direction = 3;
    }
    if (angle > 0.8f && angle < 3.0f) {
        direction = 4;
    }
    SetStack__FP12RS_STACKDATAi(args, direction);
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/runscript_opcodes", _GET_REF_DIR__FP12RS_STACKDATAi);
#endif
int _GET_REFANGLE_POS(RS_STACKDATA *stack, int argc) {
    float matrix[4][4];
    float pos[4];
    float offset[4];
    if (argc != 5) {
        return 0;
    }
    float angle = GetStackFloat__FP12RS_STACKDATA(stack++);
    float distance = GetStackFloat__FP12RS_STACKDATA(stack++);
    ((CActionChara *)nowMonster)->GetPosition(pos);
    sceVu0CopyVector(offset, nowMonster->front_vec);
    sceVu0Normalize(offset, offset);
    sceVu0UnitMatrix(matrix);
    sceVu0RotMatrixY(matrix, matrix, angle);
    sceVu0ApplyMatrix(offset, matrix, offset);
    sceVu0ScaleVector(offset, offset, distance);
    sceVu0AddVector(pos, pos, offset);
    SetStack__FP12RS_STACKDATAf(stack++, pos[0]);
    SetStack__FP12RS_STACKDATAf(stack++, pos[1]);
    SetStack__FP12RS_STACKDATAf(stack, pos[2]);
    return 1;
}
extern "C" int _GET_REF_ANGLE__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    float self_pos[4];
    ScriptVec target;
    if (argc != 4) {
        return 0;
    }
    target.v[0] = GetStackFloat__FP12RS_STACKDATA(stack++);
    target.v[1] = GetStackFloat__FP12RS_STACKDATA(stack++);
    target.v[2] = GetStackFloat__FP12RS_STACKDATA(stack++);
    target.w = 0x3F800000;
    ((CActionChara *)nowMonster)->GetPosition(self_pos);
    sceVu0SubVector(target.v, target.v, self_pos);
    SetStack__FP12RS_STACKDATAf(stack, atan2f(target.v[0], target.v[2]));
    return 1;
}
int _GET_HIGH(RS_STACKDATA *stack, int argc) {
    float height;
    if (argc != 1) {
        return 0;
    }
    if (nowMonster->mons_move_check.landed != 0) {
        height = 0.0f;
    } else {
        height = nowMonster->height;
    }
    SetStack__FP12RS_STACKDATAf(stack, height);
    return 1;
}
int _GET_ACTIVE_MONS_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];
    float self_pos[4];
    if (argc < 4 || argc > 5) {
        return 0;
    }
    int id = GetStackInt__FP12RS_STACKDATA(stack++);
    id -= 24;
    CActionChara *monster = (CActionChara *)ActiveMonster->active[id];
    if (monster == NULL) {
        return 0;
    }
    monster->GetPosition(pos);
    SetStack__FP12RS_STACKDATAf(stack++, pos[0]);
    SetStack__FP12RS_STACKDATAf(stack++, pos[1]);
    SetStack__FP12RS_STACKDATAf(stack++, pos[2]);
    if (argc == 5) {
        ((CActionChara *)nowMonster)->GetPosition(self_pos);
        SetStack__FP12RS_STACKDATAf(stack, mgDistVector(pos, self_pos));
    }
    return 1;
}
int _GET_ACTIVE_MONS_ROT(RS_STACKDATA *stack, int argc) {
    float rot[4];
    if (argc != 4) {
        return 0;
    }
    int id = GetStackInt__FP12RS_STACKDATA(stack++);
    id -= 24;
    CActionChara *monster = (CActionChara *)ActiveMonster->active[id];
    if (monster == NULL) {
        return 0;
    }
    monster->GetRotation(rot);
    SetStack__FP12RS_STACKDATAf(stack++, rot[0]);
    SetStack__FP12RS_STACKDATAf(stack++, rot[1]);
    SetStack__FP12RS_STACKDATAf(stack, rot[2]);
    return 1;
}
int _GET_ACTIVE_MONS_DIST(RS_STACKDATA *stack, int argc) {
    float self_pos[4];
    float other_pos[4];
    if (argc != 2) {
        return 0;
    }
    int id = GetStackInt__FP12RS_STACKDATA(stack++);
    id -= 24;
    CActionChara *other = (CActionChara *)ActiveMonster->active[id];
    if (other == NULL) {
        return 0;
    }
    ((CActionChara *)nowMonster)->GetPosition(self_pos);
    other->GetPosition(other_pos);
    SetStack__FP12RS_STACKDATAf(stack, mgDistVector(other_pos, self_pos));
    return 1;
}
int _GET_ACTIVE_MONS_ANGLE(RS_STACKDATA *stack, int argc) {
    float rot[4];
    if (argc != 2) {
        return 0;
    }
    int id = GetStackInt__FP12RS_STACKDATA(stack++);
    id -= 24;
    CActionChara *monster = (CActionChara *)ActiveMonster->active[id];
    if (monster == NULL) {
        return 0;
    }
    monster->GetRotation(rot);
    SetStack__FP12RS_STACKDATAf(stack, rot[1]);
    return 1;
}
extern "C" int _GET_REF_ROT__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    float self_pos[4];
    float target[4];
    float rot[4];
    if (argc != 6) {
        return 0;
    }
    GetStackVector__FPfPP12RS_STACKDATA(target, &stack);
    ((CActionChara *)nowMonster)->GetPosition(self_pos);
    sceVu0SubVector(target, target, self_pos);
    sceVu0Normalize(target, target);
    rot[1] = atan2f(target[0], target[2]);
    rot[0] = -atan2f(target[1], sqrtf(target[0] * target[0] + target[2] * target[2]));
    rot[2] = 0;
    SetStackVector__FPfPP12RS_STACKDATA(rot, &stack);
    return 1;
}
int _GET_REF_ROT2(RS_STACKDATA *stack, int argc) {
    float start[4];
    float target[4];
    if (argc != 7 && argc != 9) {
        return 0;
    }
    GetStackVector__FPfPP12RS_STACKDATA(target, &stack);
    GetStackVector__FPfPP12RS_STACKDATA(start, &stack);
    sceVu0SubVector(target, target, start);
    sceVu0Normalize(target, target);
    float yaw = atan2f(target[0], target[2]);
    atan2f(target[1], sqrtf(target[0] * target[0] + target[2] * target[2]));
    if (argc == 7) {
        SetStack__FP12RS_STACKDATAf(stack++, yaw);
    }
    if (argc == 9) {
        SetStackVector__FPfPP12RS_STACKDATA(target, &stack);
    }
    return 1;
}
int _FLYING_SEARCH_AREA(RS_STACKDATA *stack, int argc) {
    ScriptVector dir;
    float pos[4];
    float rot[4];
    float matrix[4][4];
    if (argc != 3) {
        return 0;
    }
    float distance = GetStackFloat__FP12RS_STACKDATA(stack++);
    float angle = GetStackFloat__FP12RS_STACKDATA(stack++);
    dir = at_2160;
    ((CActionChara *)nowMonster)->GetPosition(pos);
    ((CActionChara *)nowMonster)->GetRotation(rot);
    rot[1] = mgAngleLimit(angle);
    sceVu0UnitMatrix(matrix);
    sceVu0RotMatrixY(matrix, matrix, rot[1]);
    sceVu0ApplyMatrix(dir.f, matrix, dir.f);
    sceVu0ScaleVector(dir.f, dir.f, distance);
    sceVu0AddVector(dir.f, dir.f, pos);
    SetStack__FP12RS_STACKDATAf(stack, SearchArea(nowScene, pos, dir.f, distance));
    return 1;
}
#ifdef NONMATCHING
static int _GET_HIGH2(RS_STACKDATA *args, int argc) {
    CCPoly        polygons[128];
    sceVu0FVECTOR position;
    sceVu0FVECTOR hit;
    mgVu0FBOX     box;
    sceVu0FVECTOR from;
    sceVu0FVECTOR to;
    CMap         *map;
    int           count;
    float         height;

    if (argc != 4) {
        return 0;
    }
    GetStackVector__FPfPP12RS_STACKDATA(position, &args);
    map = nowScene->GetMap(nowScene->active_map);
    if (map == NULL) {
        return 0;
    }
    box.max[0] = 40.0f + position[0];
    box.min[0] = position[0] - 40.0f;
    box.max[2] = 40.0f + position[2];
    box.min[2] = position[2] - 40.0f;
    box.max[1] = 300.0f + position[1];
    box.min[1] = position[1] - 300.0f;
    box.max[3] = 1.0f;
    box.min[3] = 1.0f;
    count = map->GetColPoly(polygons, box, 128);
    sceVu0CopyVector(from, position);
    sceVu0CopyVector(to, position);
    from[1] += 1.0f;
    to[1] -= 300.0f;
    if (CheckHit(polygons, count, from, to, hit, 1, 2) >= 0) {
        height = position[1] - hit[1];
    } else {
        height = -3.4028235e38f;
    }
    SetStack__FP12RS_STACKDATAf(args++, height);
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/runscript_opcodes", _GET_HIGH2__FP12RS_STACKDATAi);
#endif
int _GET_RANGE_MONS_ID(RS_STACKDATA *stack, int argc) {
    RangeEntry entries[24];
    float self_pos[4];
    float other_pos[4];
    int i;
    int j;
    int count;
    RangeEntry *entry = entries;
    do {
        entry->distance = -1.0f;
        entry->id = -1;
        entry++;
    } while (entry < entries + 24);
    float range = GetStackFloat__FP12RS_STACKDATA(stack++);
    int rank = GetStackInt__FP12RS_STACKDATA(stack++);
    nowMonster->GetPosition(self_pos);
    mgZeroVector(other_pos);
    for (i = 0, count = 0; i < 24; i++) {
        CActiveMonster *other;
        if ((other = (CActiveMonster *)nowScene->GetCharacter(i + 24)) != NULL &&
            other->chara_kind == 2 && nowMonster->chara_type != other->chara_type) {
            other->GetPosition(other_pos);
            float distance = mgDistVector(self_pos, other_pos);
            if (distance <= range) {
                entries[count].distance = distance;
                entries[count].id = other->chara_type;
                count++;
            }
        }
    }
    for (int m = 0; m < count - 1; m++) {
        for (int n = m + 1; n < count; n++) {
            float first_distance = entries[m].distance;
            float second_distance = entries[n].distance;
            RangeEntry *first = &entries[m];
            RangeEntry *second = &entries[n];
            if (!(first_distance <= second_distance)) {
                int id = first->id;
                first->distance = second_distance;
                first->id = second->id;
                second->distance = first_distance;
                second->id = id;
            }
        }
    }
    SetStack__FP12RS_STACKDATAi(stack, entries[rank].id);
    return 1;
}
int _GET_ENTRY_OBJ_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];
    if (argc != 5) {
        return 0;
    }
    int id = GetStackInt__FP12RS_STACKDATA(stack++);
    int entry_index = GetStackInt__FP12RS_STACKDATA(stack++);
    CCharacter2 *monster;
    if (id != -1) {
        id -= 24;
        CActiveMonster **slots = ActiveMonster->active;
        monster = (CCharacter2 *)ActiveMonster->active[id];
        if (monster == NULL) {
            return 0;
        }
    } else {
        monster = (CCharacter2 *)nowMonster;
    }
    monster->GetEntryObjectPos(entry_index, pos);
    SetStackVector__FPfPP12RS_STACKDATA(pos, &stack);
    return 1;
}
extern "C" int _BLOW_START__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }
    nowMonster->blow_speed = GetStackFloat__FP12RS_STACKDATA(stack++);
    nowMonster->blow_speed = nowMonster->blow_speed * nowMonster->blow_rate;
    nowMonster->blow_decel = GetStackFloat__FP12RS_STACKDATA(stack++);
    nowMonster->blow_time = GetStackInt__FP12RS_STACKDATA(stack);
    return 1;
}
int _SET_ACT_STATUS(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    nowMonster->now_status = GetStackInt__FP12RS_STACKDATA(stack);
    return 1;
}
int _SET_INT_FLAG(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    int flag = GetStackInt__FP12RS_STACKDATA(stack++);
    ((CActionChara *)nowMonster)->SetMaskFlag(flag, GetStackInt__FP12RS_STACKDATA(stack));
    return 1;
}
#ifdef NONMATCHING
static int _SET_DEAD_START(RS_STACKDATA *args, int argc) {
    sceVu0FVECTOR     position;
    sceVu0FVECTOR     velocity;
    CBattleCharaInfo *battle;
    CPalletAnime     *pallet;
    CPullItem        *item;
    BASE_MONSTER_TBL *table;
    float             money_rate;
    int               total;
    int               large_coin;
    int               small_coin;
    int               roll;
    int               drop_index;
    int               drop_second;
    int               i;

    if (argc != 0) {
        return 0;
    }
    nowMonster->state = ACTIVE_MONSTER_DEAD;
    pallet = &nowMonster->unk_67c;
    pallet->duration = 0;
    pallet->elapsed = 0;
    if (nowMonster->reward_money <= 0) {
        return 1;
    }
    nowMonster->GetEntryObjectPos(0, position);
    money_rate = 1.0f;
    total = nowMonster->reward_money;
    battle = GetBattleCharaInfo();
    if (battle->GetNowNPC() == 17) {
        money_rate += 0.3f;
    }
    if (nowMonster->last_hit_attr & 0x1) {
        money_rate += 0.3f;
    }
    if (nowMonster->last_hit_attr & 0x2) {
        money_rate -= 0.3f;
    }
    total = (int)(total * money_rate);
    large_coin = (int)(0.7f * total);
    large_coin += (total - large_coin) % 5;
    if (large_coin > 0) {
        item = PullItemMan.GetList(2);
        if (item != NULL) {
            velocity[0] = 0.0f;
            velocity[1] = 4.0f;
            velocity[2] = 0.0f;
            velocity[3] = 1.0f;
            item->SetItem(position, velocity, PULL_ITEM_MONEY_LARGE);
            item->item_no = large_coin;
        }
    }
    printf("total = %d (%d)\n", total, large_coin);
    small_coin = (total - large_coin) / 5;
    printf("num = %d (%d)\n", 5, small_coin);
    for (i = 0; i < 5; i++) {
        item = PullItemMan.GetList(2);
        if (item != NULL) {
            velocity[0] = 0.3f + fRand(0.6f);
            velocity[1] = 2.0f + fRand(3.0f);
            velocity[2] = 0.3f + fRand(0.6f);
            if (iRand(100) < 50) {
                velocity[0] *= -1.0f;
            }
            if (iRand(100) < 50) {
                velocity[2] *= -1.0f;
            }
            velocity[3] = 1.0f;
            item->SetItem(position, velocity, PULL_ITEM_MONEY);
            item->item_no = small_coin;
        }
    }
    if (nowMonster->drop_badge != 0) {
        item = PullItemMan.GetList(1);
        if (item != NULL) {
            velocity[0] = fRand(0.5f) - 0.25f;
            velocity[2] = fRand(0.5f) - 0.25f;
            velocity[1] = 4.0f;
            velocity[3] = 1.0f;
            item->SetItem(position, velocity, PULL_ITEM_BADGE);
            item->item_no = nowMonster->tbl->user_mons_id;
        }
    }
    roll = iRand(100);
    if (roll % 6 == 0) {
        table = nowMonster->tbl;
        if (table->drop_item[0] > 0 || table->drop_item[1] > 0) {
            drop_index = 0;
            if (roll < 20 && table->drop_item[1] > 0) {
                drop_index = 1;
            }
            if (table->drop_item[0] <= 0) {
                drop_index = 1;
            }
            item = PullItemMan.GetList(2);
            if (item != NULL) {
                velocity[0] = fRand(0.5f) - 0.25f;
                velocity[2] = fRand(0.5f) - 0.25f;
                velocity[1] = 4.0f;
                velocity[3] = 1.0f;
                item->SetItem(position, velocity, PULL_ITEM_ITEM);
                item->item_no = nowMonster->tbl->drop_item[drop_index];
            }
        }
    }
    drop_second = 0;
    if (iRand(100) % 4 == 0) {
        drop_second = 1;
    }
    if (battle->GetNowNPC() == 2) {
        drop_second = 1;
    }
    if (drop_second != 0 && nowMonster->tbl->drop_item[2] > 0) {
        item = PullItemMan.GetList(2);
        if (item != NULL) {
            velocity[0] = fRand(1.0f) - 0.5f;
            velocity[2] = fRand(1.0f) - 0.5f;
            velocity[1] = 5.0f;
            velocity[3] = 1.0f;
            item->SetItem(position, velocity, PULL_ITEM_ITEM2);
            item->item_no = nowMonster->tbl->drop_item[2];
        }
    }
    sndSePlay(nowScene->se_battle_id, 1, 0);
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/runscript_opcodes", _SET_DEAD_START__FP12RS_STACKDATAi);
#endif
#ifdef NONMATCHING
static int _SET_DEAD_OFF(RS_STACKDATA *args, int argc) {
    sceVu0FVECTOR position;
    sceVu0FVECTOR velocity;
    CDeadEffect  *effect;
    CPullItem    *item;
    float         radius;
    float         height;
    float         size;
    float         growth;
    int           last_chara;
    int           last_source;
    int           experience;
    int           pickup_count;
    int           i;

    if (argc != 0) {
        return 0;
    }
    nowMonster->dead_alpha = 128;
    height = 2.0f * nowMonster->body_height;
    radius = 3.0f * nowMonster->body_width;
    if (height >= 60.0f) {
        height = 60.0f;
    }
    size = height / 32.0f;
    nowMonster->GetEntryObjectPos(0, position);
    if ((nowMonster->attrib & MONSTER_ATTRIB_UNK_2) == 0) {
        if (BattleFX.dead == NULL) {
            effect = NULL;
        } else {
            effect = &BattleFX.dead[BattleFX.dead_next++];
            if (BattleFX.dead_next >= BattleFX.dead_num) {
                BattleFX.dead_next = 0;
            }
        }
        if (effect != NULL) {
            effect->SetDeadEffect(position, radius, height, size, 35);
        }
        if (BattleFX.dead == NULL) {
            effect = NULL;
        } else {
            effect = &BattleFX.dead[BattleFX.dead_next++];
            if (BattleFX.dead_next >= BattleFX.dead_num) {
                BattleFX.dead_next = 0;
            }
        }
        if (effect != NULL) {
            effect->SetDeadEffect(position, 0.5f * radius, 0.5f * height, size, 35);
        }
    }
    last_chara = nowMonster->last_hit_chara;
    last_source = nowMonster->last_hit_source;
    experience = nowMonster->reward_exp;
    pickup_count = 0;
    if (nowMonster->last_hit_attr & 0x800) {
        experience = (int)(experience * 1.2f);
    }
    if (experience < 6 && experience > 0) {
        pickup_count = 6;
    }
    if (experience >= 6) {
        pickup_count = 8;
    }
    if (experience >= 50) {
        pickup_count = 10;
    }
    if (experience >= 200) {
        pickup_count = 12;
    }
    if (experience >= 500) {
        pickup_count = 16;
    }
    growth = (float)experience / (float)pickup_count;
    for (i = 0; i < pickup_count; i++) {
        item = PullItemMan.GetList(2);
        if (item != NULL) {
            velocity[0] = 0.3f + fRand(0.6f);
            velocity[1] = 2.0f + fRand(3.0f);
            velocity[2] = 0.3f + fRand(0.6f);
            if (iRand(100) < 50) {
                velocity[0] *= -1.0f;
            }
            if (iRand(100) < 50) {
                velocity[2] *= -1.0f;
            }
            velocity[3] = 1.0f;
            item->SetItem(position, velocity, PULL_ITEM_WEAPON_EXP);
            item->exp = growth;
            item->exp_param = last_chara;
            item->item_no = last_source;
        }
    }
    if (pickup_count > 0) {
        sndSePlay(nowScene->se_battle_id, 2, 0);
    }
    sndSePlay(nowScene->se_battle_id, 20, 0);
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/runscript_opcodes", _SET_DEAD_OFF__FP12RS_STACKDATAi);
#endif
int _SET_SHROW_END(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 0) return 0;
    nowMonster->catch_state = 0;
    return 1;
}
extern "C" int _SET_MOS__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *next = stack;
    int flag = 0;
    char *name = NULL;
    float step = -1.0f;

    if (argc <= 0 || argc > 3) {
    return 0;
}
    if (argc > 0) {
        name = GetStackString__FP12RS_STACKDATA(next++);
    }
    if (argc >= 2) {
        step = GetStackFloat__FP12RS_STACKDATA(next++);
    }
    if (argc == 3) {
        flag = GetStackInt__FP12RS_STACKDATA(next);
    }
    if (name == NULL) {
    return 0;
}
    ((CActionChara *)nowMonster)->SetMotion(name, flag, 1);
    if (step > 0.0f) {
        ((CActionChara *)nowMonster)->SetStep(step);
    }
    return 1;
}
extern "C" int _CHECK_MOS_END__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    int result;
    char *name;

    if (argc == 1) {
        result = ((CActionChara *)nowMonster)->CheckMotionEnd(0);
    }
    if (argc == 2) {
        name = GetStackString__FP12RS_STACKDATA(stack + 1);
        if (name == NULL) {
            return 0;
        }
        result = ((CActionChara *)nowMonster)->CheckMotionEnd(name);
    }
    SetStack__FP12RS_STACKDATAi(stack, result);
    return 1;
}
extern "C" int _NOW_MOS_WAIT__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    float wait;
    if (argc == 1) {
        wait = ((CActionChara *)nowMonster)->GetNowFrameWait(NULL);
    }
    if (argc == 2) {
        char *name = (char *)GetStackString__FP12RS_STACKDATA(stack + 1);
        if (name == NULL) {
            return 0;
        }
        wait = ((CActionChara *)nowMonster)->GetNowFrameWait(name);
    }
    SetStack__FP12RS_STACKDATAf(stack, wait);
    return 1;
}
extern "C" int _GET_MOS_STATUS__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    int status;
    if (argc == 1) {
        status = nowMonster->GetMotionStatus(NULL);
    }
    if (argc == 2) {
        char *name = GetStackString__FP12RS_STACKDATA(stack + 1);
        if (name == NULL) {
            return 0;
        }
        status = nowMonster->GetMotionStatus(name);
    }
    SetStack__FP12RS_STACKDATAi(stack, status);
    return 1;
}
extern "C" int _SET_MUTEKI__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 1;
    }
    nowMonster->muteki_time = GetStackInt__FP12RS_STACKDATA(stack);
    return 1;
}
int _GET_GEKIRIN(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAf(stack, nowMonster->gekirin);
    return 1;
}
int _GET_USER_MONS_ID(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    int chara_id = -1;

    if (DngUserData->active_chr_no == 3) {
        chara_id = GetBattleCharaInfo()->unk_2;
        if (nowMonster->tbl->user_mons_id != chara_id) {
            chara_id = -1;
        }
    }
    SetStack__FP12RS_STACKDATAi(stack, chara_id);
    return 1;
}
int _GET_PRIORITY(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi(stack, nowMonster->priority);
    return 1;
}
#ifdef NONMATCHING
static int _CREATE_MONSTER(RS_STACKDATA *args, int argc) {
    sceVu0FVECTOR   position;
    sceVu0FVECTOR   rotation;
    CActiveMonster *monster;
    int             id;
    int             index;

    mgZeroVector(position);
    position[3] = 1.0f;
    mgZeroVector(rotation);
    rotation[3] = 1.0f;
    id = GetStackInt__FP12RS_STACKDATA(args++);
    if (argc >= 2) {
        position[0] = GetStackFloat__FP12RS_STACKDATA(args++);
        position[1] = GetStackFloat__FP12RS_STACKDATA(args++);
        position[2] = GetStackFloat__FP12RS_STACKDATA(args++);
    }
    if (argc == 5) {
        rotation[1] = GetStackFloat__FP12RS_STACKDATA(args);
    } else if (argc == 7) {
        rotation[0] = GetStackFloat__FP12RS_STACKDATA(args++);
        rotation[1] = GetStackFloat__FP12RS_STACKDATA(args++);
        rotation[2] = GetStackFloat__FP12RS_STACKDATA(args);
    }
    index = ActiveMonster->SearchBaseIndex(id);
    if (index < 0) {
        return 0;
    }
    monster = ActiveMonster->SetActiveMonster(index, position, rotation, -1);
    printf("mons_index = %d\n", index);
    return monster != NULL;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/runscript_opcodes", _CREATE_MONSTER__FP12RS_STACKDATAi);
#endif
int _SET_CLIP_DIST(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    nowMonster->clip_dist = 20.0f * GetStackFloat__FP12RS_STACKDATA(stack);
    return 1;
}
int _SET_COLLISION(RS_STACKDATA *stack, int argc) {
    return 0;
}
int _SET_GRAVITY(RS_STACKDATA *stack, int argc) {
    return 0;
}
int _SET_ATTRIB(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
    return 0;
    }
    int mask = GetStackInt__FP12RS_STACKDATA(stack++);
    if (GetStackInt__FP12RS_STACKDATA(stack)) {
        nowMonster->attrib |= mask;
    } else {
        nowMonster->attrib &= ~mask;
    }
    return 1;
}
int _GET_SCALE(RS_STACKDATA *stack, int argc) {
    float scale[4];
    if (argc != 3) {
        return 0;
    }
    ((CActionChara *)nowMonster)->GetScale(scale);
    SetStackVector__FPfPP12RS_STACKDATA(scale, &stack);
    return 1;
}
int _GET_MONS_WIDTH(RS_STACKDATA *stack, int argc) {
    if (argc != 1 || nowMonster == NULL) {
    return 0;
    }
    float width = nowMonster->mons_move_check.radius;
    SetStack__FP12RS_STACKDATAf(stack, width <= 0.0 ? 15.0 : width);
    return 1;
}
extern "C" int _ESM_CREATE__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    char *name = GetStackString__FP12RS_STACKDATA(stack++);
    int group = nowMonster->chara_type;
    int slot;
    switch (argc) {
        case 1:
            ActiveMonster->effect_man->CreateEffSpt(name, group, 0);
            break;
        case 2:
            slot = ActiveMonster->effect_man->CreateEffSpt(name, group, 1);
            if (slot <= -1) {
                return 0;
            }
            SetStack__FP12RS_STACKDATAi(stack, slot);
            break;
    }
    return 1;
}
extern "C" void _ESM_FINISH__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    int effect_id = nowMonster->chara_type;
    ActiveMonster->effect_man->SetScriptProgNo(300, effect_id,
                                                    GetStackInt__FP12RS_STACKDATA(stack));
}
extern "C" void _ESM_DELETE__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    int effect_id = nowMonster->chara_type;
    ActiveMonster->effect_man->DeleteEffSpt(effect_id, GetStackInt__FP12RS_STACKDATA(stack));
}
#ifdef NONMATCHING
static int _ESM_SET_VECT1(RS_STACKDATA *args, int argc) {
    sceVu0FVECTOR vector;
    int           slot;

    slot = GetStackInt__FP12RS_STACKDATA(args++);
    vector[0] = GetStackFloat__FP12RS_STACKDATA(args++);
    vector[1] = GetStackFloat__FP12RS_STACKDATA(args++);
    vector[2] = GetStackFloat__FP12RS_STACKDATA(args);
    vector[3] = 1.0f;
    return ActiveMonster->effect_man->SetScriptVect1(vector, nowMonster->chara_type, slot);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/runscript_opcodes", _ESM_SET_VECT1__FP12RS_STACKDATAi);
#endif
#ifdef NONMATCHING
static int _ESM_GET_VECT1(RS_STACKDATA *args, int argc) {
    sceVu0FVECTOR vector;
    int           slot;
    int           result;

    if (argc != 4) {
        return 0;
    }
    slot = GetStackInt__FP12RS_STACKDATA(args++);
    result = ActiveMonster->effect_man->GetScriptVect1(vector, nowMonster->chara_type, slot);
    SetStack__FP12RS_STACKDATAf(args++, vector[0]);
    SetStack__FP12RS_STACKDATAf(args++, vector[1]);
    SetStack__FP12RS_STACKDATAf(args, vector[2]);
    return result;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/runscript_opcodes", _ESM_GET_VECT1__FP12RS_STACKDATAi);
#endif
#ifdef NONMATCHING
static int _ESM_SET_VECT2(RS_STACKDATA *args, int argc) {
    sceVu0FVECTOR vector;
    int           slot;

    if (argc != 4) {
        return 0;
    }
    slot = GetStackInt__FP12RS_STACKDATA(args++);
    vector[0] = GetStackFloat__FP12RS_STACKDATA(args++);
    vector[1] = GetStackFloat__FP12RS_STACKDATA(args++);
    vector[2] = GetStackFloat__FP12RS_STACKDATA(args);
    vector[3] = 1.0f;
    return ActiveMonster->effect_man->SetScriptVect2(vector, nowMonster->chara_type, slot);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/runscript_opcodes", _ESM_SET_VECT2__FP12RS_STACKDATAi);
#endif
#ifdef NONMATCHING
static int _ESM_GET_VECT2(RS_STACKDATA *args, int argc) {
    sceVu0FVECTOR vector;
    int           slot;
    int           result;

    if (argc != 4) {
        return 0;
    }
    slot = GetStackInt__FP12RS_STACKDATA(args++);
    result = ActiveMonster->effect_man->GetScriptVect2(vector, nowMonster->chara_type, slot);
    SetStack__FP12RS_STACKDATAf(args++, vector[0]);
    SetStack__FP12RS_STACKDATAf(args++, vector[1]);
    SetStack__FP12RS_STACKDATAf(args, vector[2]);
    return result;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/runscript_opcodes", _ESM_GET_VECT2__FP12RS_STACKDATAi);
#endif
#ifdef NONMATCHING
static int _ESM_SET_TARGET_ID(RS_STACKDATA *args, int argc) {
    int slot;
    int id;

    slot = GetStackInt__FP12RS_STACKDATA(args++);
    id = GetStackInt__FP12RS_STACKDATA(args);
    return ActiveMonster->effect_man->SetScriptTargetId(id, nowMonster->chara_type, slot);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/runscript_opcodes", _ESM_SET_TARGET_ID__FP12RS_STACKDATAi);
#endif
#ifdef NONMATCHING
static int _ESM_GET_TARGET_ID(RS_STACKDATA *args, int argc) {
    int slot;
    int id;
    int result;

    slot = GetStackInt__FP12RS_STACKDATA(args++);
    result = ActiveMonster->effect_man->GetScriptTargetId(id, nowMonster->chara_type, slot);
    SetStack__FP12RS_STACKDATAi(args, id);
    return result;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/runscript_opcodes", _ESM_GET_TARGET_ID__FP12RS_STACKDATAi);
#endif
#ifdef NONMATCHING
static int _ESM_SET_USER_ID(RS_STACKDATA *args, int argc) {
    int slot;
    int id;

    slot = GetStackInt__FP12RS_STACKDATA(args++);
    id = GetStackInt__FP12RS_STACKDATA(args);
    return ActiveMonster->effect_man->SetScriptUserId(id, nowMonster->chara_type, slot);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/runscript_opcodes", _ESM_SET_USER_ID__FP12RS_STACKDATAi);
#endif
#ifdef NONMATCHING
static int _ESM_GET_USER_ID(RS_STACKDATA *args, int argc) {
    int slot;
    int id;
    int result;

    slot = GetStackInt__FP12RS_STACKDATA(args++);
    result = ActiveMonster->effect_man->GetScriptUserId(id, nowMonster->chara_type, slot);
    SetStack__FP12RS_STACKDATAi(args, id);
    return result;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/runscript_opcodes", _ESM_GET_USER_ID__FP12RS_STACKDATAi);
#endif
extern "C" int _ESM_SET_VALUE__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    int slot;
    int index;
    int group;
    int result;

    group = nowMonster->chara_type;
    slot = GetStackInt__FP12RS_STACKDATA(stack++);
    index = GetStackInt__FP12RS_STACKDATA(stack++);
    switch (stack->type) {
        case 0:
            result =
                ActiveMonster->effect_man->SetValue(index, GetStackInt__FP12RS_STACKDATA(stack), group, slot);
            break;
        case 1:
            result =
                ActiveMonster->effect_man->SetValue(index, GetStackFloat__FP12RS_STACKDATA(stack), group, slot);
            break;
        default:
            return 0;
    }
    return result;
}
int _LOAD_EFFECT_SCRIPT(RS_STACKDATA *stack, int argc) {
    int result;
    int level;
    mgCMemory *memory;
    FxScriptMan->level = 3;
    level = -1;
    memory = (mgCMemory *)nowScene->GetStack(3);
    switch (stack->type) {
        case 0: {
            int base_no = GetStackInt__FP12RS_STACKDATA(stack++);
            if (argc >= 2) {
                level = GetStackInt__FP12RS_STACKDATA(stack++);
            }
            result = ActiveMonster->effect_man->LoadBaseEffSpt(base_no, memory, level);
            break;
        }
        case 2: {
            char *name = GetStackString__FP12RS_STACKDATA(stack++);
            if (argc >= 2) {
                level = GetStackInt__FP12RS_STACKDATA(stack++);
            }
            result = ActiveMonster->effect_man->LoadBaseEffSpt(name, memory, level);
            break;
        }
        default:
            return 0;
    }
    if (argc >= 3) {
        if (result > 0) {
            SetStack__FP12RS_STACKDATAi(stack, 1);
        } else {
            SetStack__FP12RS_STACKDATAi(stack, 0);
        }
    }
    return (result < 0) ^ 1;
}
extern "C" int _SW_EFFECT__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    if (argc != 9) {
        return 0;
    }
    ACTION_SW_EFFECT *effect = ((CActionChara *)nowMonster)->GetSwEffectPtr();
    if (effect == NULL) {
        return 0;
    }
    int index = GetStackInt__FP12RS_STACKDATA(stack++);
    if (index < 0 || index > 2) {
        return 0;
    }
    if (nowMonster->sword_effect[index] == NULL) {
        return 0;
    }
    char *motionName = GetStackString__FP12RS_STACKDATA(stack++);
    float start_frame = GetStackFloat__FP12RS_STACKDATA(stack++);
    float end_frame = GetStackFloat__FP12RS_STACKDATA(stack++);
    char *startName = GetStackString__FP12RS_STACKDATA(stack++);
    char *endName = GetStackString__FP12RS_STACKDATA(stack++);
    int arg_a = GetStackInt__FP12RS_STACKDATA(stack++);
    int arg_c = GetStackInt__FP12RS_STACKDATA(stack++);
    int arg_b = GetStackInt__FP12RS_STACKDATA(stack);
    effect->sword_no = index;
    effect->motion = motionName;
    effect->start = start_frame;
    effect->end = end_frame;
    effect->frame0 = startName;
    effect->frame1 = endName;
    effect->unk_1c = arg_a;
    effect->unk_1d = arg_c;
    effect->fade_time = arg_b;
    effect->wait = 0;
    nowMonster->sw_effect_num += 1;
    return 1;
}
int _ESM_GET_NOTUESD_TEXB(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi(stack, ActiveMonster->effect_man->GetNotUsedTexb());
    return 1;
}
int _ESM_ADD_TEXB(RS_STACKDATA *stack, int argc) {
    ActiveMonster->effect_man->AddTexb();
    return 1;
}
#ifdef NONMATCHING
static int _SHOT_ROCKET_LAUNCHER(RS_STACKDATA *args, int argc) {
    sceVu0FVECTOR    position;
    sceVu0FVECTOR    target;
    sceVu0FVECTOR    direction;
    CRocketLauncher *rocket;
    CColPrim        *primitive;
    float            speed;
    int              homing_delay;
    int              homing_time;
    int              damage;
    int              primitive_id;

    if (argc != 6 && argc != 10) {
        return 0;
    }
    GetStackVector__FPfPP12RS_STACKDATA(position, &args);
    GetStackVector__FPfPP12RS_STACKDATA(direction, &args);
    if (argc == 10) {
        speed = GetStackFloat__FP12RS_STACKDATA(args++);
        homing_delay = GetStackInt__FP12RS_STACKDATA(args++);
        homing_time = GetStackInt__FP12RS_STACKDATA(args++);
        damage = GetStackInt__FP12RS_STACKDATA(args++);
    } else {
        speed = 12.0f;
        homing_delay = 6;
        homing_time = 45;
        damage = nowMonster->attack;
    }
    sceVu0Normalize(direction, direction);
    sceVu0ScaleVector(target, direction, 500.0f);
    sceVu0AddVector(target, position, target);
    direction[1] += 0.1f;
    rocket = RocketLauncher.Get();
    if (rocket == NULL) {
        return 0;
    }
    rocket->SetPos(position, target, direction);
    rocket->target_chara = 0;
    rocket->speed = speed;
    rocket->homing_delay = homing_delay;
    rocket->homing_time = homing_time;
    primitive = ColPrimMan.GetPrim();
    primitive_id = -1;
    if (primitive != NULL) {
        primitive->SetDamage("\x83\x8d\x83\x7b\x83\x89\x83\x93\x83\x60\x83\x83", 2);
        primitive->SetCoord(position, 5.0f);
        primitive->damage = damage;
        primitive_id = primitive->id;
    }
    rocket->col_prim_id = primitive_id;
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/runscript_opcodes", _SHOT_ROCKET_LAUNCHER__FP12RS_STACKDATAi);
#endif
int _RUN_EVENT_SCRIPT(RS_STACKDATA *stack, int argc) {
    if (argc != 1)
        return 0;
    s16 v = (s16)GetStackInt__FP12RS_STACKDATA(stack);
    nowMonster->event_no = v;
    return 1;
}
extern "C" int _SET_STATUS__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    int status;
    RS_STACKDATA *next = stack + 1;
    status = GetStackInt__FP12RS_STACKDATA(stack);
    int enable = 1;
    if (argc >= 2) {
        enable = GetStackInt__FP12RS_STACKDATA(next);
    }
    if (enable != 0) {
        nowScene->SetStatus(1, nowMonster->chara_type, status);
    } else {
        nowScene->ResetStatus(1, nowMonster->chara_type, status);
    }
    return 1;
}
int _SET_PAUSE(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *next;
    DNG_BATTLE_AREA *pause = &nowScene->battle_area;
    next = stack + 1;

    if (pause == NULL) {
        return 0;
    }
    u32 mask = GetStackInt__FP12RS_STACKDATA(stack);
    if (GetStackInt__FP12RS_STACKDATA(next)) {
        pause->pause_flag |= mask;
    } else {
        pause->pause_flag &= ~mask;
    }
    return 1;
}
extern "C" int _CHECK_PAUSE__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argument_count) {

    DNG_BATTLE_AREA *pause = &nowScene->battle_area;
    RS_STACKDATA *output = stack + 1;
    if (pause == NULL)
        return 0;
    int requested_flags = GetStackInt__FP12RS_STACKDATA(stack);
    SetStack__FP12RS_STACKDATAi(output, pause->pause_flag & requested_flags);
    return 1;
}
int _GET_BIT_FLAG(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 2)
        return 0;
    int flag = GetStackInt__FP12RS_STACKDATA(stack++);

    argument_count = DngSaveData->GetBitFlag(flag);
    SetStack__FP12RS_STACKDATAi(stack, argument_count);
    return 1;
}
int _SET_BIT_FLAG(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 2)
        return 0;

    int bit = GetStackInt__FP12RS_STACKDATA(stack++);
    int enabled = GetStackInt__FP12RS_STACKDATA(stack);
    DngSaveData->SetBitFlag(bit, enabled);
    return 1;
}
int _GET_ATT_TYPE(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 1)
        return 0;
    SetStack__FP12RS_STACKDATAi(stack, nowMonster->att_type);
    return 1;
}
int _GET_USER_ATTR(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 1)
        return 0;

    argument_count = GetBattleCharaInfo()->GetAttr();
    SetStack__FP12RS_STACKDATAi(stack, argument_count);
    return 1;
}
int _TRANS_RESERV_IMG(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 1)
        return 0;
    int image_index = GetStackInt__FP12RS_STACKDATA(stack);
    if (image_index < 0 || image_index > 1)
        return 0;
    CActiveMonster *monster = nowMonster;
    void *image = monster->reserv_img[image_index];
    if (image == NULL)
        return 0;
    memcpy(monster->images[0], image, monster->reserv_img_size[image_index]);
    return 1;
}
int _GET_STS_ATTR(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 2)
        return 0;
    int mask = GetStackInt__FP12RS_STACKDATA(stack++);
    SetStack__FP12RS_STACKDATAi(stack, nowMonster->status.attr & mask);
    return 1;
}
int _SET_PIYORI_MARK(RS_STACKDATA *stack, int argument_count) {
    nowMonster->piyori_mark = nowMonster->piyori_time;
    nowMonster->piyori.Set((mgCObject *)nowMonster, nowMonster->piyori_mark);
    return 1;
}
int _CHECK_PIYORI(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 1)
        return 0;
    SetStack__FP12RS_STACKDATAi(stack, nowMonster->piyori_mark);
    return 1;
}
int _GET_BASE_ATTACK(RS_STACKDATA *stack, int argument_count) {
    SetStack__FP12RS_STACKDATAi(stack, nowMonster->attack);
    return 1;
}
int _GET_NEAR_MONS_POS(RS_STACKDATA *stack, int argument_count) {
    float pos[4];
    float nearest_pos[4];
    float other_pos[4];
    float nearest_dist = -1.0f;
    int i;

    nowMonster->GetPosition(pos);
    mgZeroVector(nearest_pos);
    for (i = 0; i < MONSTER_ACTIVE_MAX; i++) {
        CActiveMonster *other;
        if ((other = (CActiveMonster *)nowScene->GetCharacter(i + 24)) != NULL &&
            other->chara_kind == 2 && nowMonster->chara_type != other->chara_type) {
            other->GetPosition(other_pos);
            if (nearest_dist >= 0.0) {
                float dist = mgDistVector(pos, other_pos);
                if (dist < nearest_dist) {
                    nearest_dist = dist;
                    *(u_long128 *)nearest_pos = *(u_long128 *)other_pos;
                }
            } else {
                *(u_long128 *)nearest_pos = *(u_long128 *)other_pos;
                nearest_dist = mgDistVector(pos, nearest_pos);
            }
        }
    }
    SetStack__FP12RS_STACKDATAf(stack++, nearest_pos[0]);
    SetStack__FP12RS_STACKDATAf(stack++, nearest_pos[1]);
    SetStack__FP12RS_STACKDATAf(stack++, nearest_pos[2]);
    SetStack__FP12RS_STACKDATAf(stack, nearest_dist);
    return 1;
}
int _SET_INDEXOBJ_SIZE(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 2)
        return 0;
    int object_index = GetStackInt__FP12RS_STACKDATA(stack++);
    float size = GetStackFloat__FP12RS_STACKDATA(stack);
    if (object_index == -1)
        object_index = 0;
    CActiveMonster *monster = nowMonster;
    CHARA_ENTRY_OBJECT *objects = monster->entry_object;
    int offset = object_index * sizeof(CHARA_ENTRY_OBJECT);
    int address = (int)objects;
    address = offset + address;
    ((CHARA_ENTRY_OBJECT *)address)->unk_04 = size;
    return 1;
}
int _GET_INDEXOBJ_SIZE(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 2)
        return 0;

    int object_index = GetStackInt__FP12RS_STACKDATA(stack++);
    if (object_index == -1)
        object_index = 0;

    CActiveMonster *monster = nowMonster;
    int object_base = (int)&monster->entry_object;
    object_index *= sizeof(CHARA_ENTRY_OBJECT);
    object_index += object_base;
    CHARA_ENTRY_OBJECT *object = (CHARA_ENTRY_OBJECT *)object_index;
    SetStack__FP12RS_STACKDATAf(stack, object->unk_04);
    return 1;
}
extern "C" int _SET_MOTION_BLUR__FP12RS_STACKDATAi(RS_STACKDATA *stack,
                                                            int argument_count) {
    if (argument_count != 1)
        return 0;
    nowScene->motion_blur = GetStackInt__FP12RS_STACKDATA(stack);
    return 1;
}
int _MONS_SE_PLAY(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 2)
        return 0;

    int monster_id = GetStackInt__FP12RS_STACKDATA(stack++);
    int sound = GetStackInt__FP12RS_STACKDATA(stack);
    monster_id -= 24;
    CActiveMonster *monster = ActiveMonster->active[monster_id];
    if (monster == 0)
        return 0;
    sndSePlay(monster->se_bank, sound, 0);
    return 1;
}
int _MONS_SE_STOP(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 2)
        return 0;

    int monster_id = GetStackInt__FP12RS_STACKDATA(stack++);
    int sound = GetStackInt__FP12RS_STACKDATA(stack);
    monster_id -= 24;
    CActiveMonster *monster = ActiveMonster->active[monster_id];
    if (monster == 0)
        return 0;
    sndSeStop(monster->se_bank, sound, 0);
    return 1;
}
int _MONS_SE_LOOP(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 3)
        return 0;

    int monster_id = GetStackInt__FP12RS_STACKDATA(stack++);
    int sound = GetStackInt__FP12RS_STACKDATA(stack++);
    int flags = GetStackInt__FP12RS_STACKDATA(stack);
    monster_id -= 24;
    CActiveMonster *monster = ActiveMonster->active[monster_id];
    if (monster == 0)
        return 0;

    monster->loop_se->SeLoopPlayStop((int)monster->se_bank, sound, flags, 13);
    return 1;
}
int _MONS_VOL_CTRL(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 1)
        return 0;
    nowMonster->se_positional = GetStackInt__FP12RS_STACKDATA(stack);
    return 1;
}
int _SET_MAPOBJ_SHOW(RS_STACKDATA *stack, int argument_count) {
    CMap *maps[8];
    CMapParts *parts;
    int map_count;
    char *partsName;
    char *pieceName;
    CMapPiece *piece;
    int show;
    int i;

    if (argument_count != 2 && argument_count != 3)
        return 0;
    map_count = nowScene->GetActiveMap(maps, 8);
    if (map_count <= 0)
        return 0;
    partsName = GetStackString__FP12RS_STACKDATA(stack++);
    if (argument_count == 3)
        pieceName = GetStackString__FP12RS_STACKDATA(stack++);
    show = GetStackInt__FP12RS_STACKDATA(stack);
    for (i = 0; i < map_count; i++) {
        parts = (CMapParts *)maps[i]->GetPlaceParts(partsName);
        if (parts != NULL)
            break;
    }
    if (parts == NULL)
        return 0;
    if (argument_count == 3) {
        if ((piece = parts->SearchPiece(pieceName)) == NULL)
            return 0;
    }
    if (argument_count == 2)
        parts->Show(show);
    else
        piece->Show(show);
    return 1;
}
int SetMonsterScript(CRunScript *script, char *program, mgCMemory *memory) {

    RS_STACKDATA *valueStack = (RS_STACKDATA *)memory->Alloc(0x40);
    RS_CALLDATA *callStack = (RS_CALLDATA *)memory->Alloc(0x180);
    script->load((RS_PROG_HEADER *)program, valueStack, 128, callStack,
                 512);
    script->ext_func(ext_func, 256);
    return 1;
}
#ifdef NONMATCHING
void SetMonsterExtendTable() {
    int index;
    int earlier;
    int number;

    for (index = 0; index < 256; index++) {
        ext_func[index] = NULL;
    }
    for (index = 0; ext_func_info[index].func != NULL; index++) {
        for (earlier = 0; earlier < index; earlier++) {
            if (ext_func_info[index].no == ext_func_info[earlier].no) {
                printf("mscript same ext_func_no!!!\n");
                for (;;) {
                }
            }
        }
        number = ext_func_info[index].no;
        if (number < 0 || number >= 256) {
            printf("ext func over!!");
        } else {
            ext_func[number] = ext_func_info[index].func;
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/runscript_opcodes", SetMonsterExtendTable__Fv);
#endif

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript_opcodes", at_1480__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript_opcodes", at_1481__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript_opcodes", at_1864__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript_opcodes", at_2160__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript_opcodes", ext_func_info__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript_opcodes", at_1728__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript_opcodes", at_1733__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript_opcodes", at_1784__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript_opcodes", at_2398__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript_opcodes", at_2399__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript_opcodes", at_2580__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript_opcodes", at_2787__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript_opcodes", at_3078__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/runscript_opcodes", at_3079__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(nowScene, 0x4);
INCLUDE_BSS(nowMonster, 0x4);
INCLUDE_BSS(LastCInfo2, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(ext_func, 0x400);
