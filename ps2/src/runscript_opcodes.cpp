#include "common.h"
#include "mw_runtime.h"

#include "runscript_opcodes.hpp"
#ifdef NONMATCHING
#include "dng_object.hpp"
#include "gameutil.hpp"
#include "mdslist.hpp"
#include "mg_camera.hpp"
#include "mg_drawenv.hpp"
#endif
#include <libvu0.h>

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "actionchara.hpp"
#include "cameracontrol.hpp"
#include "character.hpp"
#include "colprim.hpp"
#include "dataread.hpp"
#include "dng_effect.hpp"
#include "dng_hud.hpp"
#include "dng_main.hpp"
#include "effscript.hpp"
#include "event_func.hpp"
#include "gamepad.hpp"
#include "mainloop.hpp"
#include "maintex.hpp"
#include "map.hpp"
#include "mapparts.hpp"
#include "menucommon.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "nd_meswin.hpp"
#include "object.hpp"
#include "runscript.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include "userdata.hpp"

/**
 * Scene used by the active monster's script callbacks.
 */
static CScene *nowScene;

CActiveMonster *nowMonster;

/**
 * Damage entry returned by the most recent monster damage callback.
 */
static ACTION_DAMAGE *LastCInfo2;

/**
 * Monster script callback dispatch table indexed by external function number.
 */
static int (*ext_func[RS_MONSTER_EXT_LIMIT])(RS_STACKDATA *, int);

/**
 *
 * Distance and identifier of a script range entry.
 *
 */
struct RangeEntry {
    float distance; /**< Range distance. */
    int   id;       /**< Entry identifier. */
};

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

/**
 *
 * Reads a script number as an integer, converting a floating point value when needed.
 *
 */
static int GetStackInt(RS_STACKDATA *stack) {
    if (stack->type == RS_FLOAT) {
        return (int) stack->val.f;
    }

    return stack->val.i;
}

/**
 *
 * Reads a script number as a float, converting an integer value when needed.
 *
 */
static float GetStackFloat(RS_STACKDATA *stack) {
    if (stack->type == RS_INT) {
        return (float) stack->val.i;
    }

    return stack->val.f;
}

/**
 *
 * Reads the string pointer held in a script stack slot.
 *
 */
static char *GetStackString(RS_STACKDATA *stack) {
    return stack->val.s;
}

/**
 *
 * Writes an integer through a script output reference.
 *
 */
static void SetStack(RS_STACKDATA *stack, int value) {
    if (stack->type == RS_PTR) {
        stack->val.p->val.i = value;
    }
}

/**
 *
 * Writes a floating point value through a script output reference.
 *
 */
static void SetStack(RS_STACKDATA *stack, float value) {
    if (stack->type == RS_PTR) {
        stack->val.p->val.f = value;
    }
}

/**
 *
 * Reads three numeric script arguments into a homogeneous position vector.
 *
 */
static void GetStackVector(float *vec, RS_STACKDATA **stack) {
    vec[0] = GetStackFloat((*stack)++);
    vec[1] = GetStackFloat((*stack)++);
    vec[2] = GetStackFloat((*stack)++);
    vec[3] = 1.0f;
}

/**
 *
 * Writes three vector components through script output arguments.
 *
 */
static void SetStackVector(float *vec, RS_STACKDATA **stack) {
    SetStack((*stack)++, vec[0]);
    SetStack((*stack)++, vec[1]);
    SetStack((*stack)++, vec[2]);
}

/**
 *
 * Writes the square root of a script argument to an output slot.
 *
 */
int _SQRT(RS_STACKDATA *stack, int argument_count) {
    float value = GetStackFloat(stack++);
    SetStack(stack, (float) sqrt(value));
    return 1;
}

/**
 *
 * Writes the angle of two script arguments to an output slot.
 *
 */
int _ATAN2F(RS_STACKDATA *stack, int argument_count) {
    float y = GetStackFloat(stack++);
    float x = GetStackFloat(stack++);
    SetStack(stack, atan2f(y, x));
    return 1;
}

/**
 *
 * Accepts the test opcode without changing script state.
 *
 */
int _ND_TEST(RS_STACKDATA *stack, int argc) {
    return 1;
}

/**
 *
 * Writes the current target character rotation to three output slots.
 *
 */
int _GET_TARGET_ROT(RS_STACKDATA *stack, int argument_count) {
    float        pos[4];
    CCharacter2 *target;

    if (argument_count != 3) {
        return 0;
    }

    target = nowScene->GetCharacter(nowMonster->target_no);

    if (target == NULL) {
        return 0;
    }

    target->GetRotation(pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

/**
 *
 * Writes the active monster instance identifier to an output slot.
 *
 */
int _GET_MONSTER_INDEX(RS_STACKDATA *stack, int argument_count) {
    SetStack(stack, nowMonster->monster_id);
    return 1;
}

/**
 *
 * Sets the active monster life from an absolute value or fraction of maximum life.
 *
 */
int _SET_MONSTER_LIFE(RS_STACKDATA *stack, int argument_count) {
    int life;

    switch (stack->type) {
        case 0:
            life = GetStackInt(stack);
            break;
        case 1:
            life = fptosi((float) nowMonster->max_life * GetStackFloat(stack));
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

/**
 *
 * Writes the active monster character type to an output slot.
 *
 */
int _GET_USERID(RS_STACKDATA *stack, int argument_count) {
    SetStack(stack, nowMonster->chara_type);
    return 1;
}

/**
 *
 * Writes the active monster reference number to an output slot.
 *
 */
int _GET_MONSTER_ID(RS_STACKDATA *stack, int argument_count) {
    SetStack(stack, nowMonster->refer_no);
    return 1;
}

/**
 *
 * Resets the active monster motion.
 *
 */
int _RESET_MOTION(RS_STACKDATA *, int) {
    nowMonster->ResetMotion();
    return 1;
}

/**
 *
 * Finds an active monster by instance identifier and writes its position.
 *
 */
int _GET_INDEX_POS(RS_STACKDATA *stack, int argument_count) {
    int             index = GetStackInt(stack++);
    int             count = ActiveMonster->GetMonsterNum(-1.0f);
    int             i;
    float           pos[4];
    CActiveMonster *monster;

    for (i = 0; i < count; i++) {
        monster = ActiveMonster->active[i];

        if (monster->monster_id == index) {
            monster->GetPosition(pos);
            SetStack(stack++, pos[0]);
            SetStack(stack++, pos[1]);
            SetStack(stack, pos[2]);
            return 1;
        }
    }

    return 0;
}

/**
 *
 * Disables active camera control and sets its next focus point.
 *
 */
int _SET_CAMERA_NEXT_REF(RS_STACKDATA *stack,
                         int           argument_count) {
    CCameraControl *camera;
    float           x;
    float           y;
    float           z;

    camera = (CCameraControl *) nowScene->GetCamera(nowScene->active_camera);

    if (camera == NULL) {
        return 0;
    }

    camera->FollowOff();
    camera->ControlOff();
    x = GetStackFloat(stack++);
    y = GetStackFloat(stack++);
    z = GetStackFloat(stack);
    camera->SetNextRef(x, y, z);
    return 1;
}

/**
 *
 * Sets the active monster alpha value.
 *
 */
int _SET_ALPHA(RS_STACKDATA *stack, int argument_count) {
    float value = GetStackFloat(stack);
    nowMonster->alpha = value;
    return 1;
}

/**
 *
 * Finds an active monster by instance identifier and sets its alpha value.
 *
 */
int _SET_INDEX_ALPHA(RS_STACKDATA *stack, int argument_count) {
    int             index = GetStackInt(stack++);
    int             count = ActiveMonster->GetMonsterNum(-1.0f);
    int             i;
    CActiveMonster *monster;

    for (i = 0; i < count; i++) {
        monster = ActiveMonster->active[i];

        if (monster->monster_id == index) {
            monster->alpha = GetStackFloat(stack);
            return 1;
        }
    }

    return 0;
}

/**
 *
 * Enables or disables active camera follow and control.
 *
 */
int _SET_CAMERA_FOLLOW(RS_STACKDATA *stack, int argument_count) {
    CCameraControl *camera;

    camera = (CCameraControl *) nowScene->GetCamera(nowScene->active_camera);

    if (camera == NULL) {
        return 0;
    }

    if (GetStackInt(stack) != 0) {
        camera->FollowOn();
        camera->ControlOn();
    } else {
        camera->FollowOff();
        camera->ControlOff();
    }

    return 1;
}

/**
 *
 * Disables active camera control and sets its next eye position.
 *
 */
int _SET_CAMERA_NEXT_POS(RS_STACKDATA *stack,
                         int           argument_count) {
    CCameraControl *camera;
    float           x;
    float           y;
    float           z;

    camera = (CCameraControl *) nowScene->GetCamera(nowScene->active_camera);

    if (camera == NULL) {
        return 0;
    }

    camera->FollowOff();
    camera->ControlOff();
    x = GetStackFloat(stack++);
    y = GetStackFloat(stack++);
    z = GetStackFloat(stack);
    camera->SetNextPos(x, y, z);
    return 1;
}

/**
 *
 * Writes the length of a vector supplied by script arguments.
 *
 */
int _GET_DIST_VECTOR(RS_STACKDATA *stack, int argument_count) {
    float vec[4];

    vec[0] = GetStackFloat(stack++);
    vec[1] = GetStackFloat(stack++);
    vec[2] = GetStackFloat(stack++);
    vec[3] = 1.0f;
    SetStack(stack, mgDistVector(vec));
    return 1;
}

/**
 *
 * Writes the distance between two positions supplied by script arguments.
 *
 */
int _GET_DIST_VECTOR2(RS_STACKDATA *stack, int argument_count) {
    float from[4];
    float to[4];

    from[0] = GetStackFloat(stack++);
    from[1] = GetStackFloat(stack++);
    from[2] = GetStackFloat(stack++);
    from[3] = 1.0f;
    to[0] = GetStackFloat(stack++);
    to[1] = GetStackFloat(stack++);
    to[2] = GetStackFloat(stack++);
    to[3] = 1.0f;
    SetStack(stack, mgDistVector(from, to));
    return 1;
}

/**
 *
 * Sets the active monster scale from three script arguments.
 *
 */
int _SET_SCALE(RS_STACKDATA *stack, int argc) {
    float scale[4];
    scale[0] = GetStackFloat(stack++);
    scale[1] = GetStackFloat(stack++);
    scale[2] = GetStackFloat(stack);
    scale[3] = 1.0f;
    nowMonster->SetScale(scale);
    return 1;
}

/**
 *
 * Configures the active monster palette pulse color, timing, and repeat count.
 *
 */
int _SET_PALLET_ANIM(RS_STACKDATA *stack, int argc) {
    int first;
    int second;
    int third;
    int fourth;
    int fifth;
    int sixth = 0;
    first = GetStackInt(stack++);
    second = GetStackInt(stack++);
    third = GetStackInt(stack++);
    fourth = GetStackInt(stack++);
    fifth = GetStackInt(stack++);

    if (argc >= 6) {
        sixth = GetStackInt(stack);
    }

    CActiveMonster *monster = nowMonster;
    monster->script_pallet.red = first;
    monster->script_pallet.green = second;
    monster->script_pallet.blue = third;
    monster->script_pallet.pulse_num = fourth;
    monster->script_pallet.duration = fifth;
    monster->script_pallet.elapsed = 0;
    monster->script_pallet.repeats = sixth;
    return 1;
}

/**
 *
 * Stops the active monster palette pulse and clears its elapsed time.
 *
 */
int _RESET_PALLET_ANIM(RS_STACKDATA *stack, int argc) {
    CActiveMonster *monster = nowMonster;
    monster->script_pallet.duration = 0;
    monster->script_pallet.elapsed = 0;
    return 1;
}

/**
 *
 * Writes the intersections of a horizontal line and circle.
 *
 */
int _CALC_IP_CIRCLE_LINE(RS_STACKDATA *stack, int argc) {
    float center[4];
    float line_a[4];
    float line_b[4];
    float hit1[4];
    float hit2[4];
    float center_x = GetStackFloat(stack++);
    float center_z = GetStackFloat(stack++);
    float radius = GetStackFloat(stack++);
    float line_a_x = GetStackFloat(stack++);
    float line_a_z = GetStackFloat(stack++);
    float line_b_x = GetStackFloat(stack++);
    float line_b_z = GetStackFloat(stack++);
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
    SetStack(stack++, hit_count);

    if (hit_count == 2) {
        SetStack(stack++, hit1[0]);
        SetStack(stack++, hit1[2]);
        SetStack(stack++, hit2[0]);
        SetStack(stack++, hit2[2]);
    }

    if (hit_count == 1) {
        SetStack(stack++, hit1[0]);
        SetStack(stack, hit1[2]);
    }

    return 1;
}

/**
 *
 * Writes yaw or full rotation from one position toward another.
 *
 */
int _GET_POSREF_ANGLE(RS_STACKDATA *stack, int argc) {
    float from[4];
    float to[4];
    from[0] = GetStackFloat(stack++);
    from[1] = GetStackFloat(stack++);
    from[2] = GetStackFloat(stack++);
    from[3] = 1.0f;
    to[0] = GetStackFloat(stack++);
    to[1] = GetStackFloat(stack++);
    to[2] = GetStackFloat(stack++);
    to[3] = 1.0f;
    sceVu0SubVector(to, to, from);
    sceVu0Normalize(to, to);
    float yaw = atan2f(to[0], to[2]);
    float pitch = -atan2f(to[1], sqrtf(to[0] * to[0] + to[2] * to[2]));

    switch (argc) {
        case 7:
            SetStack(stack, yaw);
            break;
        case 9:
            SetStack(stack++, pitch);
            SetStack(stack++, yaw);
            SetStack(stack, 0.0f);
            break;
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Normalizes a three-component vector held in script output slots.
 *
 */
int _NORMAL_VECTOR(RS_STACKDATA *stack, int argc) {
    float vec[4];
    vec[0] = stack[0].val.p->val.f;
    vec[1] = stack[1].val.p->val.f;
    vec[2] = stack[2].val.p->val.f;
    vec[3] = 1.0f;
    sceVu0Normalize(vec, vec);
    SetStack(stack++, vec[0]);
    SetStack(stack++, vec[1]);
    SetStack(stack, vec[2]);
    return 1;
}

/**
 *
 * Copies three numeric script arguments into vector output slots.
 *
 */
int _COPY_VECTOR(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *source = stack;
    source += 3;
    float x = GetStackFloat(source++);
    float y = GetStackFloat(source++);
    float z = GetStackFloat(source);
    SetStack(stack++, x);
    SetStack(stack++, y);
    SetStack(stack, z);
    return 1;
}

/**
 *
 * Adds a three-component script vector to vector output slots.
 *
 */
int _ADD_VECTOR(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *source = stack;
    source += 3;
    float x = GetStackFloat(source++);
    float y = GetStackFloat(source++);
    float z = GetStackFloat(source);
    SetStack(stack, stack[0].val.p->val.f + x);
    SetStack(stack + 1, stack[1].val.p->val.f + y);
    SetStack(stack + 2, stack[2].val.p->val.f + z);
    return 1;
}

/**
 *
 * Subtracts a three-component script vector from vector output slots.
 *
 */
int _SUB_VECTOR(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *source = stack;
    source += 3;
    float x = GetStackFloat(source++);
    float y = GetStackFloat(source++);
    float z = GetStackFloat(source);
    SetStack(stack, stack[0].val.p->val.f - x);
    SetStack(stack + 1, stack[1].val.p->val.f - y);
    SetStack(stack + 2, stack[2].val.p->val.f - z);
    return 1;
}

/**
 *
 * Scales vector output slots by a numeric script argument.
 *
 */
int _SCALE_VECTOR(RS_STACKDATA *stack, int argc) {
    float scale = GetStackFloat(stack + 3);
    SetStack(stack, stack[0].val.p->val.f * scale);
    SetStack(stack + 1, stack[1].val.p->val.f * scale);
    SetStack(stack + 2, stack[2].val.p->val.f * scale);
    return 1;
}

/**
 *
 * Divides vector output slots by a nonzero numeric script argument.
 *
 */
int _DIV_VECTOR(RS_STACKDATA *stack, int argc) {
    float divisor = GetStackFloat(stack + 3);

    if (0.0f == divisor) {
        return 0;
    }

    SetStack(stack, stack[0].val.p->val.f / divisor);
    SetStack(stack + 1, stack[1].val.p->val.f / divisor);
    SetStack(stack + 2, stack[2].val.p->val.f / divisor);
    return 1;
}

/**
 *
 * Writes whether an angle is within a requested tolerance of another angle.
 *
 */
int _ANGLE_CMP(RS_STACKDATA *stack, int argc) {
    float angle = GetStackFloat(stack++);
    float target = GetStackFloat(stack++);
    float tolerance = GetStackFloat(stack++);
    SetStack(stack, mgAngleCmp(angle, target, tolerance));
    return 1;
}

/**
 *
 * Wraps an angle output slot into the supported angle range.
 *
 */
int _ANGLE_LIMIT(RS_STACKDATA *stack, int unused) {
    SetStack(stack, mgAngleLimit(stack->val.p->val.f));
    return 1;
}

/**
 *
 * Writes the previous position of the active monster target.
 *
 */
int _GET_TARGET_OLD_POS(RS_STACKDATA *stack, int argc) {
    float         old_pos[4];
    CActionChara *target = (CActionChara *) nowScene->GetCharacter(nowMonster->target_no);

    if (target == NULL) {
        return 0;
    }

    sceVu0CopyVector(old_pos, target->old_pos);
    SetStack(stack++, old_pos[0]);
    SetStack(stack++, old_pos[1]);
    SetStack(stack, old_pos[2]);
    return 1;
}

/**
 *
 * Writes the distance the active monster target moved since its previous position.
 *
 */
int _GET_TARGET_SPEED(RS_STACKDATA *stack, int argc) {
    float         pos[4];
    float         old_pos[4];
    CActionChara *target = (CActionChara *) nowScene->GetCharacter(nowMonster->target_no);

    if (target == NULL) {
        return 0;
    }

    target->GetPosition(pos);
    sceVu0CopyVector(old_pos, target->old_pos);
    SetStack(stack, mgDistVector(pos, old_pos));
    return 1;
}

/**
 *
 * Writes the next position along a requested move and its calculation result.
 *
 */
int _CALC_MOVE_NEXT_POS(RS_STACKDATA *stack, int argc) {
    float from[4];
    float to[4];
    float next[4];
    from[0] = GetStackFloat(stack++);
    from[1] = GetStackFloat(stack++);
    from[2] = GetStackFloat(stack++);
    to[0] = GetStackFloat(stack++);
    to[1] = GetStackFloat(stack++);
    to[2] = GetStackFloat(stack++);
    float distance = GetStackFloat(stack++);
    int   result = CalcMoveNextPos(from, to, distance, next);
    SetStack(stack++, next[0]);
    SetStack(stack++, next[1]);
    SetStack(stack++, next[2]);
    SetStack(stack, result);
    return 1;
}

/**
 *
 * Writes current monster life as an integer or fraction of maximum life.
 *
 */
int _GET_MONSTER_LIFE(RS_STACKDATA *stack, int argc) {
    if (stack->type != RS_PTR) {
        return 0;
    }

    RS_STACKDATA *slot = stack->val.p;

    if (slot->type == RS_INT) {
        SetStack(stack, nowMonster->life);
    } else if (slot->type == RS_FLOAT) {
        SetStack(stack, (float) nowMonster->life / (float) nowMonster->max_life);
    } else {
        return 0;
    }

    return 1;
}

/**
 *
 * Writes the active monster damage immunity countdown.
 *
 */
int _GET_NO_DAMAGE_CNT(RS_STACKDATA *stack, int argc) {
    SetStack(stack, nowMonster->no_damage_cnt);
    return 1;
}

/**
 *
 * Writes the integer life of a selected active monster.
 *
 */
int _GET_ACTIVE_MONS_LIFEI(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int             id = GetStackInt(stack++);
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

    SetStack(stack, monster->life);
    return 1;
}

/**
 *
 * Writes the life fraction of a selected active monster.
 *
 */
int _GET_ACTIVE_MONS_LIFEF(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int             id = GetStackInt(stack++);
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

    SetStack(stack, (float) monster->life / (float) monster->max_life);
    return 1;
}

/**
 *
 * Sets the integer life of a selected active monster.
 *
 */
int _SET_ACTIVE_MONS_LIFEI(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int             id = GetStackInt(stack++);
    int             amount = GetStackInt(stack);
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

/**
 *
 * Sets a selected active monster life from a fraction of its maximum.
 *
 */
int _SET_ACTIVE_MONS_LIFEF(RS_STACKDATA *stack, int argc) {
    CActiveMonster *monster;
    int             id;
    int             max_life;
    int             amount;
    float           fraction;

    if (argc != 2) {
        return 0;
    }

    id = GetStackInt(stack++);
    fraction = GetStackFloat(stack);

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
    amount = fptosi((float) max_life * fraction);

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

/**
 *
 * Writes the maximum life of a selected active monster.
 *
 */
int _GET_ACTIVE_MONS_MAX_LIFE(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int             id = GetStackInt(stack++);
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

    SetStack(stack, monster->max_life);
    return 1;
}

/**
 *
 * Shows a damage number above the selected monster.
 *
 */
int _SET_DAMAGE_SCORE(RS_STACKDATA *stack, int argc) {
    float         pos[4];
    int           color_flag;
    int           id;
    int           value;
    CActionChara *monster;

    if (argc != 3 && argc != 2) {
        return 0;
    }

    id = GetStackInt(stack++);

    if (id != -1) {
        id -= 24;
        monster = ActiveMonster->active[id];

        if (monster == NULL) {
            return 0;
        }
    } else {
        monster = nowMonster;
    }

    value = GetStackInt(stack++);

    if (argc == 3) {
        color_flag = GetStackInt(stack);
    }

    monster->GetPosition(pos);
    pos[1] += ((CActiveMonster *) monster)->body_height;

    if (color_flag == 1) {
        DamageScore.SetColor(0x40, 0x80, 0x60);
    }

    DamageScore.SetValue(pos, value);
    return 1;
}

/**
 *
 * Writes the grade of a selected active monster.
 *
 */
int _GET_MONS_GRADE(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int             id = GetStackInt(stack++);
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

    SetStack(stack, monster->tbl->grade);
    return 1;
}

/**
 *
 * Scales the selected monster escape rates from their base values.
 *
 */
int _SET_ESCAPE_RATE(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int             id = GetStackInt(stack++);
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

    float scale = GetStackFloat(stack);
    monster->tbl->escape_rate0 = fptosi((float) monster->base_tbl->escape_rate0 * scale);
    monster->tbl->escape_rate1 = fptosi((float) monster->base_tbl->escape_rate1 * scale);

    if ((u8) monster->tbl->escape_rate0 > 100) {
        monster->tbl->escape_rate0 = 100;
    }

    if ((u8) monster->tbl->escape_rate1 > 100) {
        monster->tbl->escape_rate1 = 100;
    }

    return 1;
}

/**
 *
 * Scales the selected monster guard rate from its base value.
 *
 */
int _SET_GUARD_RATE(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int             id = GetStackInt(stack++);
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

    float scale = GetStackFloat(stack);
    monster->tbl->guard_rate = fptosi((float) monster->base_tbl->guard_rate * scale);

    if ((u8) monster->tbl->guard_rate > 100) {
        monster->tbl->guard_rate = 100;
    }

    return 1;
}

/**
 *
 * Scales selected monster extension parameters from their base values.
 *
 */
int _SET_EXT_PARAM_RATE(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }

    int             id = GetStackInt(stack++);
    int             mask = GetStackInt(stack++);
    float           rate = GetStackFloat(stack);
    int             i;
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
            monster->tbl->ext_param[i] = fptosi((float) monster->base_tbl->ext_param[i] * rate);

            if (monster->tbl->ext_param[i] > 100) {
                monster->tbl->ext_param[i] = 100;
            }
        }
    }

    return 1;
}

/**
 *
 * Writes whether the active monster base data marks it as a boss.
 *
 */
int _GET_BOSS_FLAG(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    SetStack(stack, nowMonster->base_tbl->boss);
    return 1;
}

/**
 *
 * Resets the current battle area timer.
 *
 */
int _RESET_TIMER(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *block;

    block = (&nowScene->battle_area);

    if (block == NULL) {
        return 0;
    }

    block->timer = 0;
    return 1;
}

/**
 *
 * Writes the current battle area timer value.
 *
 */
int _GET_TIMER(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *block;

    block = (&nowScene->battle_area);

    if (block == NULL) {
        return 0;
    }

    SetStack(stack, block->timer);
    return 1;
}

/**
 *
 * Writes the world position of a named frame on the active monster.
 *
 */
int _GET_FRAME_POS(RS_STACKDATA *stack, int argc) {
    float     pos[4];
    char     *name = GetStackString(stack++);
    mgCFrame *root = nowMonster->CObjectFrame::frame;

    if (root == NULL) {
        return 0;
    }

    mgCFrame *frame = root->SearchFrame(name);

    if (frame == NULL) {
        return 0;
    }

    frame->GetWorldPosition0(pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

/**
 *
 * Plays a positional sound effect from the active monster sound bank.
 *
 */
int _MY_SE_PLAY(RS_STACKDATA *stack, int argc) {
    float pos[4];
    float volume;
    float pan;
    int   se_id = GetStackInt(stack);
    u32   se_handle = nowMonster->sound_info.se_bank;
    nowMonster->GetPosition(pos);

    float far = 1200.0f;
    float near = 160.0f;
    sndGetVolPan(&volume, &pan, pos, near, far);
    sndSePlayVPf(se_handle, se_id, volume, pan, 0);
    return 1;
}

/**
 *
 * Stops a sound effect from the active monster sound bank.
 *
 */
int _MY_SE_STOP(RS_STACKDATA *stack, int argc) {
    int id = GetStackInt(stack);
    sndSeStop(nowMonster->sound_info.se_bank, id, 0);
    return 1;
}

/**
 *
 * Writes the event stopwatch limit for its supported selector.
 *
 */
int _GET_EVENT_INFO(RS_STACKDATA *stack, int argc) {
    int selector = GetStackInt(stack++);

    switch (selector) {
        case 0:
            SetStack(stack, (int) EdEventInfo.stopwatch_limit);
            break;
        default:
            return 0;
    }

    return 1;
}

/**
 *
 * Clears effects associated with the requested character identifier.
 *
 */
int _ESM_ALL_CLEAR(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    FxScriptMan->ClearEffectFromChrid(GetStackInt(stack));
    return 1;
}

/**
 *
 * Writes the dot product of two horizontal directions built from angles.
 *
 */
int _GET_ANGLE_INNER(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }

    float angle_a = GetStackFloat(stack++);
    float angle_b = GetStackFloat(stack++);
    sceVu0FVECTOR first = {0.0f, 0.0f, 1.0f, 0.0f};
    sceVu0FVECTOR second = {0.0f, 0.0f, 1.0f, 0.0f};
    float matrix[4][4];
    float rotated[4][4];
    sceVu0UnitMatrix(matrix);
    sceVu0RotMatrixY(rotated, matrix, angle_a);
    sceVu0ApplyMatrix(first, rotated, first);
    sceVu0RotMatrixY(rotated, matrix, angle_b);
    sceVu0ApplyMatrix(second, rotated, second);
    SetStack(stack, sceVu0InnerProduct(first, second));
    return 1;
}

/**
 *
 * Starts a battle-area camera quake with amplitude and duration.
 *
 */
int _CAMERA_QUAKE(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *quake = (&nowScene->battle_area);
    RS_STACKDATA    *next = stack + 1;

    if (quake == NULL) {
        return 0;
    }

    float amplitude = GetStackFloat(stack);
    int   frames = GetStackInt(next);
    quake->quake_power = amplitude;
    quake->quake_step = quake->quake_power / (float) frames;
    quake->quake_count = frames;
    return 1;
}

/**
 *
 * Sets the current battle-area camera mode value.
 *
 */
int _SET_CAMERA_MODE(RS_STACKDATA *stack, int argc) {
    int              mode;
    DNG_BATTLE_AREA *area;

    mode = GetStackInt(stack);
    area = (&nowScene->battle_area);

    if (area == NULL) {
        return 0;
    }

    area->camera_mode = mode;
    return 1;
}

/**
 *
 * Sets the active camera movement speed.
 *
 */
int _SET_CAMERA_SPEED(RS_STACKDATA *stack, int argc) {
    mgCCamera *camera = nowScene->GetCamera(nowScene->active_camera);

    if (camera == NULL) {
        return 0;
    }

    camera->SetSpeed(GetStackFloat(stack), -1.0f);
    return 1;
}

/**
 *
 * Updates active camera distance and near/far height limits.
 *
 */
int _SET_CAMERA_CTRL_PARAM1(RS_STACKDATA *args, int argc) {
    CameraCtrlParam *param;
    float            value;

    if (argc > 0 && argc < 5) {
        return 0;
    }

    param = ((CCameraControl *) nowScene->GetCamera(nowScene->active_camera))->GetActiveParam();

    if (argc > 0) {
        value = GetStackFloat(args++);
    }

    if (value != -99999.9 && argc > 0) {
        param->min_dist = value;
    }

    if (argc > 1) {
        value = GetStackFloat(args++);
    }

    if (value != -99999.9 && argc > 1) {
        param->max_dist = value;
    }

    if (argc > 2) {
        value = GetStackFloat(args++);
    }

    if (value != -99999.9 && argc > 2) {
        param->near_height = value;
    }

    if (argc > 3) {
        value = GetStackFloat(args++);
    }

    if (value != -99999.9 && argc > 3) {
        param->far_height = value;
    }

    return 1;
}

/**
 *
 * Updates active camera height and ground clearance limits.
 *
 */
int _SET_CAMERA_CTRL_PARAM2(RS_STACKDATA *args, int argc) {
    CameraCtrlParam *param;
    float            value;

    if (argc > 0 && argc < 7) {
        return 0;
    }

    param = ((CCameraControl *) nowScene->GetCamera(nowScene->active_camera))->GetActiveParam();

    if (argc > 0) {
        value = GetStackFloat(args++);
    }

    if (value != -99999.9 && argc > 0) {
        param->height = value;
    }

    if (argc > 1) {
        value = GetStackFloat(args++);
    }

    if (value != -99999.9 && argc > 1) {
        param->max_height = value;
    }

    if (argc > 2) {
        value = GetStackFloat(args++);
    }

    if (value != -99999.9 && argc > 2) {
        param->min_height = value;
    }

    if (argc > 3) {
        value = GetStackFloat(args++);
    }

    if (value != -99999.9 && argc > 3) {
        param->rest_max_height = value;
    }

    if (argc > 4) {
        value = GetStackFloat(args++);
    }

    if (value != -99999.9 && argc > 4) {
        param->rest_min_height = value;
    }

    if (argc > 5) {
        value = GetStackFloat(args++);
    }

    if (value != -99999.9 && argc > 5) {
        param->ground_space = value;
    }

    return 1;
}

/**
 *
 * Restores default active camera control distances and heights.
 *
 */
int _RESET_CAMERA_CTRL_PARAM(RS_STACKDATA *stack, int argc) {

    CameraCtrlParam *param;

    param = ((CCameraControl *) nowScene->GetCamera(nowScene->active_camera))->GetActiveParam();
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

/**
 *
 * Writes a random integer below the requested range.
 *
 */
int _GET_RND(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int range = GetStackInt(stack++);

    argc = fptosi((float) range * (float) rand() / 2147483648.0f);
    SetStack(stack, argc);
    return 1;
}

/**
 *
 * Writes a float holding a random integer below the requested range.
 *
 */
int _GET_RNDF(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    float range = GetStackFloat(stack++);
    SetStack(stack, (float) fptosi(range * (float) rand() / 2147483648.0f));
    return 1;
}

/**
 *
 * Stores an integer or float in a monster-local or shared script variable.
 *
 */
int _V_PUSH(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int index = GetStackInt(stack++);

    if (index < 0) {
        return 0;
    }

    if (stack->type == 0) {
        if (index < MONSTER_VAR_MAX) {
            int             value = GetStackInt(stack);
            ScriptVariable *vars = nowMonster->var;
            vars[index].i = value;
        }

        if (index >= MONSTER_VAR_MAX && index < 0x88) {
            int             value = GetStackInt(stack);
            ScriptVariable *vars = ActiveMonster->share_var - MONSTER_VAR_MAX;
            vars[index].i = value;
        }

        return 1;
    }

    if (stack->type == 1) {
        if (index < MONSTER_VAR_MAX) {
            float           value = GetStackFloat(stack);
            ScriptVariable *vars = nowMonster->var;
            vars[index].f = value;
        }

        if (index >= MONSTER_VAR_MAX && index < 0x88) {
            float           value = GetStackFloat(stack);
            ScriptVariable *vars = ActiveMonster->share_var - MONSTER_VAR_MAX;
            vars[index].f = value;
        }

        return 1;
    }

    return 1;
}

/**
 *
 * Reads a monster-local or shared script variable into an output slot.
 *
 */
int _V_POP(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int index = GetStackInt(stack++);

    if (index < 0) {
        return 0;
    }

    if (stack->type != RS_PTR) {
        return 0;
    }

    RS_STACKDATA *slot = stack->val.p;

    if (slot->type == RS_INT) {
        if (index < MONSTER_VAR_MAX) {
            ScriptVariable *vars = nowMonster->var;
            SetStack(stack, vars[index].i);
        }

        if (index >= MONSTER_VAR_MAX && index < 0x88) {
            ScriptVariable *vars = ActiveMonster->share_var - MONSTER_VAR_MAX;
            SetStack(stack, vars[index].i);
        }

        return 1;
    } else if (slot->type == RS_FLOAT) {
        if (index < MONSTER_VAR_MAX) {
            ScriptVariable *vars = nowMonster->var;
            SetStack(stack, vars[index].f);
        }

        if (index >= MONSTER_VAR_MAX && index < 0x88) {
            ScriptVariable *vars = ActiveMonster->share_var - MONSTER_VAR_MAX;
            SetStack(stack, vars[index].f);
        }

        return 1;
    }

    return 1;
}

/**
 *
 * Stores an integer or float in the active monster secondary variable table.
 *
 */
int _V_PUSH2(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int index = GetStackInt(stack++);

    if (index < 0) {
        return 0;
    }

    if (stack->type == 0) {
        if (index < MONSTER_VAR2_MAX) {
            int             value = GetStackInt(stack);
            ScriptVariable *vars = nowMonster->var2;
            vars[index].i = value;
        } else {
            return 0;
        }

        return 1;
    } else if (stack->type == 1) {
        if (index < MONSTER_VAR2_MAX) {
            float           value = GetStackFloat(stack);
            ScriptVariable *vars = nowMonster->var2;
            vars[index].f = value;
        } else {
            return 0;
        }

        return 1;
    }

    return 1;
}

/**
 *
 * Reads an active monster secondary variable into an output slot.
 *
 */
int _V_POP2(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int index = GetStackInt(stack++);

    if (index < 0) {
        return 0;
    }

    if (stack->type != RS_PTR) {
        return 0;
    }

    RS_STACKDATA *slot = stack->val.p;

    if (slot->type == RS_INT) {
        if (index < MONSTER_VAR2_MAX) {
            ScriptVariable *vars = nowMonster->var2;
            SetStack(stack, vars[index].i);
        } else {
            return 0;
        }

        return 1;
    } else if (slot->type == RS_FLOAT) {
        if (index < MONSTER_VAR2_MAX) {
            ScriptVariable *vars = nowMonster->var2;
            SetStack(stack, vars[index].f);
        } else {
            return 0;
        }

        return 1;
    }

    return 1;
}

/**
 *
 * Sets the battle area lock-on mode.
 *
 */
int _SET_LOCKON_MODE(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    s16 v = (s16) GetStackInt(stack);
    nowScene->battle_area.lock_on_mode = v;
    return 1;
}

/**
 *
 * Writes the number of active monsters.
 *
 */
int _GET_MONSTER_NUM(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    argc = ActiveMonster->GetMonsterNum(-1.0f);
    SetStack(stack, argc);
    return 1;
}

/**
 *
 * Writes the distance from the active monster to a script position.
 *
 */
int _GET_DIST(RS_STACKDATA *stack, int argc) {
    float target[4];
    float self_pos[4];

    if (argc != 4) {
        return 0;
    }

    target[0] = GetStackFloat(stack++);
    target[1] = GetStackFloat(stack++);
    target[2] = GetStackFloat(stack++);
    nowMonster->GetPosition(self_pos);
    SetStack(stack, mgDistVector(target, self_pos));
    return 1;
}

/**
 *
 * Registers a named object on the active monster at a requested index.
 *
 */
int _SET_OBJ(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int   index = GetStackInt(stack++);
    char *name = GetStackString(stack);
    return nowMonster->EntryObject(name, index) != 0;
}

/**
 *
 * Prints the body command diagnostic.
 *
 */
int _SET_BODY(RS_STACKDATA *stack, int argc) {
    printf("NOT FOUND (_SET_BODY)\n");
    return 1;
}

/**
 *
 * Prints the damage command diagnostic.
 *
 */
int _SET_DMG(RS_STACKDATA *stack, int argc) {
    printf("NOT FOUND (_SET_DMG)\n");
    return 1;
}

/**
 *
 * Registers a damage hit using named motion and entry-object frames.
 *
 */
int _SET_DMG2(RS_STACKDATA *stack, int argc) {
    float               pos[4];
    mgCFrame           *frame_a;
    mgCFrame           *frame_b;
    CHARA_ENTRY_OBJECT *object;
    char               *hit_name = GetStackString(stack++);
    float               power = 2.0f * GetStackFloat(stack++);
    char               *motion = GetStackString(stack++);
    float               start_ratio = GetStackFloat(stack++);
    float               end_ratio = GetStackFloat(stack++);
    int                 index_a = GetStackInt(stack++);
    int                 index_b = -1;

    if (argc == 7) {
        index_b = GetStackInt(stack);
    }

    frame_b = NULL;
    object = nowMonster->GetEntryObjectPos(3, index_a, pos);

    if (object == NULL) {
        return 0;
    }

    frame_a = object->frame;

    if (power <= 0.0f) {
        power = object->size;
    }

    if (index_b >= 0) {
        object = nowMonster->GetEntryObjectPos(3, index_b, pos);

        if (object != NULL) {
            frame_b = object->frame;
        }
    }

    LastCInfo2 = nowMonster->EntryDamage2(frame_a, frame_b, hit_name, power, motion, start_ratio, end_ratio, NULL);
    return LastCInfo2 != NULL;
}

/**
 *
 * Writes the world position of a named character object.
 *
 */
int _GET_OBJ_POS(RS_STACKDATA *stack, int argc) {
    float         pos[4];
    char         *object_name;
    mgCFrame     *object;
    CActionChara *chara;
    char         *chara_name;

    if (argc < 4 || argc > 5) {
        return 0;
    }

    object_name = GetStackString(stack++);
    chara_name = NULL;

    if (argc == 5) {
        chara_name = GetStackString(stack + 3);
    }

    if (argc == 5) {
        chara = nowMonster->SearchChara(chara_name);

        if (chara != NULL) {
            object = chara->SearchObject(object_name);
        }
    } else {
        object = nowMonster->SearchObject(object_name);
    }

    if (object == NULL) {
        return 0;
    }

    object->GetWorldPosition0(pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

/**
 *
 * Writes the world position of a named frame on the linked map piece.
 *
 */
int _GET_MAPOBJ_POS(RS_STACKDATA *stack, int argc) {
    float matrix[4][4];
    float pos[4];

    if (argc != 4) {
        return 0;
    }

    if (nowMonster->link_piece == NULL || nowMonster->link_parts == NULL) {
        return 0;
    }

    char      *name = GetStackString(stack++);
    CMapPiece *piece = nowMonster->link_piece;
    piece->UpDatePosition();
    piece = nowMonster->link_piece;
    mgCFrame *frame = piece->frame->SearchFrame(name);

    if (frame == NULL) {
        printf("ERR\n");
    }

    if (frame == NULL) {
        return 0;
    }

    frame->GetWorldPosition0(pos);
    nowMonster->link_parts->GetLWMatrix(matrix);
    sceVu0ApplyMatrix(pos, matrix, pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

/**
 *
 * Links the active monster to a named map part.
 *
 */
int _LINK_MAP_TO_OBJECT(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    if (DngMainMap == NULL) {
        return 0;
    }

    nowMonster->link_parts = DngMainMap->GetPlaceParts(GetStackString(stack));

    if (nowMonster->link_parts == NULL) {
        return 0;
    }

    nowMonster->link_type = 1;
    return 1;
}

/**
 *
 * Links the active monster to a named piece of a map part.
 *
 */
int _LINK_OBJECT_TO_PIECE(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    if (DngMainMap == NULL) {
        return 0;
    }

    char *part_name = GetStackString(stack++);
    char *piece_name = GetStackString(stack);
    nowMonster->link_parts = DngMainMap->GetPlaceParts(part_name);

    if (nowMonster->link_parts == NULL) {
        return 0;
    }

    nowMonster->link_piece = nowMonster->link_parts->SearchPiece(piece_name);

    if (nowMonster->link_piece == NULL) {
        return 0;
    }

    nowMonster->link_type = 2;
    return 1;
}

/**
 *
 * Configures the active monster scoop trigger or motion interval.
 *
 */
int _SET_SCOOP(RS_STACKDATA *stack, int argc) {
    if (argc != 1 && argc != 4) {
        return 0;
    }

    if (argc == 1) {
        nowMonster->scoop.type = 2;
        nowMonster->scoop.no = GetStackInt(stack++);
    }

    if (argc == 4) {
        nowMonster->scoop.type = 1;
        nowMonster->scoop.motion = GetStackString(stack++);
        nowMonster->scoop.start = GetStackFloat(stack++);
        nowMonster->scoop.end = GetStackFloat(stack++);
        nowMonster->scoop.no = GetStackInt(stack);
    }

    return 1;
}

/**
 *
 * Loads an image file into one of the active monster reserved image slots.
 *
 */
int _LOAD_RESERV_IMG(RS_STACKDATA *stack, int argc) {
    int file_size;

    if (argc != 2) {
        return 0;
    }

    int slot = GetStackInt(stack++);

    if (slot < 0 || slot > 1) {
        return 0;
    }

    if (LoadFile2(GetStackString(stack), BuffReadData, &file_size, 0) == 0) {
        return 0;
    }

    mgCMemory *memory = nowScene->GetStack(3);

    if (memory == NULL) {
        return 0;
    }

    void *image = memory->Alloc(file_size / 16 + 1);

    if (image == NULL) {
        return 0;
    }

    memcpy(image, BuffReadData, file_size);
    nowMonster->reserv_img[slot] = image;
    nowMonster->reserv_img_size[slot] = file_size;
    return 1;
}

/**
 *
 * Sets the active monster priority limit within its supported range.
 *
 */
int _SET_PRIORITY_LIMMIT(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    int value = GetStackInt(stack);

    if (value < 0 || value >= MONSTER_ACTIVE_MAX) {
        return 0;
    }

    ActiveMonster->priority_limit = value;
    return 1;
}

/**
 *
 * Writes the active monster configured place position.
 *
 */
int _GET_PLACE_POS(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }

    SetStack(stack++, nowMonster->place_pos[0]);
    SetStack(stack++, nowMonster->place_pos[1]);
    SetStack(stack, nowMonster->place_pos[2]);
    return 1;
}

/**
 *
 * Sets the active monster configured place position.
 *
 */
int _SET_PLACE_POS(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }

    nowMonster->place_pos[0] = GetStackFloat(stack++);
    nowMonster->place_pos[1] = GetStackFloat(stack++);
    nowMonster->place_pos[2] = GetStackFloat(stack);
    return 1;
}

/**
 *
 * Searches from the active monster along a rotated horizontal direction.
 *
 */
int _SEARCH_AREA(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }

    float distance = GetStackFloat(stack++);
    float angle = GetStackFloat(stack++);
    sceVu0FVECTOR dir = {0.0f, 0.0f, 1.0f, 0.0f};
    float pos[4];
    float rot[4];
    float matrix[4][4];
    nowMonster->GetPosition(pos);
    nowMonster->GetRotation(rot);
    rot[1] = mgAngleLimit(rot[1] + angle);
    sceVu0UnitMatrix(matrix);
    sceVu0RotMatrixY(matrix, matrix, rot[1]);
    sceVu0ApplyMatrix(dir, matrix, dir);
    sceVu0ScaleVector(dir, dir, distance);
    sceVu0AddVector(dir, dir, pos);
    pos[1] += 100.0f;
    dir[1] += 100.0f;
    SetStack(stack, SearchArea(nowScene, pos, dir, distance));
    return 1;
}

/**
 *
 * Searches the scene along a segment between two script positions.
 *
 */
int _SEARCH_AREA2(RS_STACKDATA *stack, int argc) {
    float from[4];
    float to[4];

    if (argc != 7) {
        return 0;
    }

    GetStackVector(from, &stack);
    GetStackVector(to, &stack);
    SetStack(stack++, SearchArea(nowScene, from, to, mgDistVector(from, to)));
    return 1;
}

/**
 *
 * Enables or disables model lighting on the root or a named frame.
 *
 */
int _SET_MODEL_LIGHT_SWITCH(RS_STACKDATA *stack, int argc) {
    mgCFrame     *frame;
    char         *name;
    int           flag;
    mgCFrameAttr *attr;

    if (argc <= 0 || argc > 2) {
        return 0;
    }

    flag = GetStackInt(stack++);
    name = NULL;

    if (argc == 2) {
        name = GetStackString(stack);
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

/**
 *
 * Sets model lighting color on the root or a named frame.
 *
 */
int _SET_MODEL_LIGHT_COLOR(RS_STACKDATA *stack, int argc) {
    mgCFrame     *frame;
    char         *name;
    mgCFrameAttr *attr;
    float         red;
    float         green;
    float         blue;
    float         alpha;

    if (argc < 4 || argc > 5) {
        return 0;
    }

    name = NULL;
    red = GetStackFloat(stack++);
    green = GetStackFloat(stack++);
    blue = GetStackFloat(stack++);
    alpha = GetStackFloat(stack++);

    if (argc == 5) {
        name = GetStackString(stack);
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

/**
 *
 * Scales active monster defense from its table value.
 *
 */
int _SET_DEF_RATE(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    float           rate = GetStackFloat(stack);
    CActiveMonster *self = nowMonster;
    u32             base = self->tbl->defense;
    self->defense = fptoui((float) base * rate);
    return 1;
}

/**
 *
 * Writes the active monster position to three output slots.
 *
 */
int _GET_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];

    if (argc != 3) {
        return 0;
    }

    nowMonster->GetPosition(pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

/**
 *
 * Teleports the active monster to a script position.
 *
 */
int _SET_POS(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }

    float x = GetStackFloat(stack++);
    float y = GetStackFloat(stack++);
    float z = GetStackFloat(stack);
    nowMonster->SetPosition(x, y, z);
    return 1;
}

/**
 *
 * Writes rotation of the active monster or a selected monster.
 *
 */
int _GET_ROT(RS_STACKDATA *stack, int argc) {
    float rot[4];

    if (argc < 3 || argc > 4) {
        return 0;
    }

    if (argc == 4) {
        int           id = GetStackInt(stack++);
        CActionChara *chara = (CActionChara *) nowScene->GetCharacter(id + 24);

        if (chara == NULL) {
            return 0;
        }

        chara->GetRotation(rot);
    } else {
        nowMonster->GetRotation(rot);
    }

    SetStack(stack++, rot[0]);
    SetStack(stack++, rot[1]);
    SetStack(stack, rot[2]);
    return 1;
}

/**
 *
 * Sets active monster rotation and clears its turn speed.
 *
 */
int _SET_ROT(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }

    float x = GetStackFloat(stack++);
    float y = GetStackFloat(stack++);
    float z = GetStackFloat(stack);
    nowMonster->SetRotation(x, y, z);
    nowMonster->rot_speed = 0.0f;
    return 1;
}

/**
 *
 * Sets the active monster target facing and turn speed.
 *
 */
int _SET_NEXT_ROT(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    nowMonster->next_rot = GetStackFloat(stack++);
    nowMonster->rot_speed = GetStackFloat(stack);
    return 1;
}

/**
 *
 * Sets an active monster movement target, speed, and arrival distance.
 *
 */
int _SET_NEXT_POS(RS_STACKDATA *stack, int argc) {
    float target[4];
    float pos[4];

    if (argc < 3 || argc > 5) {
        return 0;
    }

    target[0] = GetStackFloat(stack++);
    target[1] = GetStackFloat(stack++);
    target[2] = GetStackFloat(stack++);
    nowMonster->next_pos[0] = target[0];
    nowMonster->next_pos[1] = target[1];
    nowMonster->next_pos[2] = target[2];
    nowMonster->move_speed = GetStackFloat(stack++);
    nowMonster->arrive_dist = 20.0f;

    if (argc >= 5) {
        nowMonster->arrive_dist = GetStackFloat(stack);
    }

    nowMonster->GetPosition(pos);

    if (mgDistVector(target, pos) < nowMonster->arrive_dist) {
        nowMonster->move_speed = 0.0f;
    }

    return 1;
}

/**
 *
 * Writes whether the active monster is within arrival distance of its target.
 *
 */
int _CHK_MOVE_END(RS_STACKDATA *stack, int argc) {
    float pos[4];
    int   arrived;

    if (argc != 1) {
        return 0;
    }

    arrived = 0;
    nowMonster->GetPosition(pos);

    if (mgDistVector(pos, nowMonster->next_pos) < nowMonster->arrive_dist) {
        arrived = 1;
    }

    SetStack(stack, arrived);
    return 1;
}

/**
 *
 * Stops active monster movement by clearing its movement speed.
 *
 */
int _RESET_MOVE(RS_STACKDATA *stack, int argument_count) {
    nowMonster->move_speed = 0.0f;
    return 1;
}

/**
 *
 * Writes the target position and optionally its distance from the monster.
 *
 */
int _GET_TARGET_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];
    float self_pos[4];

    if (argc < 3 || argc > 4) {
        return 0;
    }

    CActionChara *target = (CActionChara *) nowScene->GetCharacter(nowMonster->target_no);

    if (target == NULL) {
        return 0;
    }

    target->GetPosition(pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack++, pos[2]);

    if (argc == 4) {
        nowMonster->GetPosition(self_pos);
        SetStack(stack, mgDistVector(self_pos, pos));
    }

    return 1;
}

/**
 *
 * Writes the distance from the active monster to its target.
 *
 */
int _GET_TARGET_DIST(RS_STACKDATA *stack, int argc) {
    float target_pos[4];
    float self_pos[4];

    if (argc != 1) {
        return 0;
    }

    CActionChara *target = (CActionChara *) nowScene->GetCharacter(nowMonster->target_no);

    if (target == NULL) {
        return 0;
    }

    target->GetPosition(target_pos);
    nowMonster->GetPosition(self_pos);
    SetStack(stack, mgDistVector(target_pos, self_pos));
    return 1;
}

/**
 *
 * Writes the horizontal angle from the active monster to its target.
 *
 */
int _GET_TARGET_ANGLE(RS_STACKDATA *stack, int argc) {
    float delta[4];
    float self_pos[4];

    if (argc != 1) {
        return 0;
    }

    CActionChara *target = (CActionChara *) nowScene->GetCharacter(nowMonster->target_no);

    if (target == NULL) {
        return 0;
    }

    target->GetPosition(delta);
    nowMonster->GetPosition(self_pos);
    sceVu0SubVector(delta, delta, self_pos);
    SetStack(stack, atan2f(delta[0], delta[2]));
    return 1;
}

/**
 *
 * Writes a point at a given angle and distance from the target.
 *
 */
int _GET_TARGET_REF_POS(RS_STACKDATA *stack, int argc) {
    float matrix[4][4];
    float pos[4];

    float offset[4];

    if (argc != 5) {
        return 0;
    }

    float         angle = GetStackFloat(stack++);
    float         distance = GetStackFloat(stack++);
    CActionChara *target = (CActionChara *) nowScene->GetCharacter(nowMonster->target_no);

    if (target == NULL) {
        return 0;
    }

    target->GetPosition(pos);
    offset[0] = 0.0f;
    offset[1] = 0.0f;
    offset[2] = 1.0f;
    sceVu0Normalize(offset, offset);
    sceVu0UnitMatrix(matrix);
    sceVu0RotMatrixY(matrix, matrix, angle);
    sceVu0ApplyMatrix(offset, matrix, offset);
    sceVu0ScaleVector(offset, offset, distance);
    sceVu0AddVector(pos, pos, offset);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

/**
 *
 * Classifies a point as ahead, behind, left, or right of the monster.
 *
 */
int _GET_REF_DIR(RS_STACKDATA *args, int argc) {
    sceVu0FVECTOR target_position;
    sceVu0FVECTOR position;
    sceVu0FVECTOR front;
    float         distance;
    float         front_angle;
    int           direction;

    if (argc < 4 || argc > 5) {
        return 0;
    }

    target_position[0] = GetStackFloat(args++);
    target_position[1] = GetStackFloat(args++);
    target_position[2] = GetStackFloat(args++);
    target_position[3] = 1.0f;
    distance = GetStackFloat(args++);
    nowMonster->GetPosition(position);

    if (mgDistVector(position, target_position) < distance) {
        SetStack(args++, 0);
    }

    sceVu0SubVector(target_position, target_position, position);
    sceVu0Normalize(target_position, target_position);
    sceVu0CopyVector(front, nowMonster->front_vec);
    front_angle = atan2f(front[0], front[2]);
    float angle = atan2f(target_position[0], target_position[2]);
    angle -= front_angle;

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

    SetStack(args, direction);
    return 1;
}

/**
 *
 * Writes a point offset from the monster along its rotated facing direction.
 *
 */
int _GET_REFANGLE_POS(RS_STACKDATA *stack, int argc) {
    float matrix[4][4];
    float pos[4];
    float offset[4];

    if (argc != 5) {
        return 0;
    }

    float angle = GetStackFloat(stack++);
    float distance = GetStackFloat(stack++);
    nowMonster->GetPosition(pos);
    sceVu0CopyVector(offset, nowMonster->front_vec);
    sceVu0Normalize(offset, offset);
    sceVu0UnitMatrix(matrix);
    sceVu0RotMatrixY(matrix, matrix, angle);
    sceVu0ApplyMatrix(offset, matrix, offset);
    sceVu0ScaleVector(offset, offset, distance);
    sceVu0AddVector(pos, pos, offset);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

/**
 *
 * Writes the horizontal angle from the monster toward a script position.
 *
 */
int _GET_REF_ANGLE(RS_STACKDATA *stack, int argc) {
    float self_pos[4];
    float target[4];

    if (argc != 4) {
        return 0;
    }

    target[0] = GetStackFloat(stack++);
    target[1] = GetStackFloat(stack++);
    target[2] = GetStackFloat(stack++);
    target[3] = 1.0f;
    nowMonster->GetPosition(self_pos);
    sceVu0SubVector(target, target, self_pos);
    SetStack(stack, atan2f(target[0], target[2]));
    return 1;
}

/**
 *
 * Writes zero when grounded or the monster height when airborne.
 *
 */
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

    SetStack(stack, height);
    return 1;
}

/**
 *
 * Writes a selected monster position and optionally its distance from the active monster.
 *
 */
int _GET_ACTIVE_MONS_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];
    float self_pos[4];

    if (argc < 4 || argc > 5) {
        return 0;
    }

    int id = GetStackInt(stack++);
    id -= 24;
    CActionChara *monster = ActiveMonster->active[id];

    if (monster == NULL) {
        return 0;
    }

    monster->GetPosition(pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack++, pos[2]);

    if (argc == 5) {
        nowMonster->GetPosition(self_pos);
        SetStack(stack, mgDistVector(pos, self_pos));
    }

    return 1;
}

/**
 *
 * Writes the rotation of a selected active monster.
 *
 */
int _GET_ACTIVE_MONS_ROT(RS_STACKDATA *stack, int argc) {
    float rot[4];

    if (argc != 4) {
        return 0;
    }

    int id = GetStackInt(stack++);
    id -= 24;
    CActionChara *monster = ActiveMonster->active[id];

    if (monster == NULL) {
        return 0;
    }

    monster->GetRotation(rot);
    SetStack(stack++, rot[0]);
    SetStack(stack++, rot[1]);
    SetStack(stack, rot[2]);
    return 1;
}

/**
 *
 * Writes the distance to a selected active monster.
 *
 */
int _GET_ACTIVE_MONS_DIST(RS_STACKDATA *stack, int argc) {
    float self_pos[4];
    float other_pos[4];

    if (argc != 2) {
        return 0;
    }

    int id = GetStackInt(stack++);
    id -= 24;
    CActionChara *other = ActiveMonster->active[id];

    if (other == NULL) {
        return 0;
    }

    nowMonster->GetPosition(self_pos);
    other->GetPosition(other_pos);
    SetStack(stack, mgDistVector(other_pos, self_pos));
    return 1;
}

/**
 *
 * Writes the yaw angle of a selected active monster.
 *
 */
int _GET_ACTIVE_MONS_ANGLE(RS_STACKDATA *stack, int argc) {
    float rot[4];

    if (argc != 2) {
        return 0;
    }

    int id = GetStackInt(stack++);
    id -= 24;
    CActionChara *monster = ActiveMonster->active[id];

    if (monster == NULL) {
        return 0;
    }

    monster->GetRotation(rot);
    SetStack(stack, rot[1]);
    return 1;
}

/**
 *
 * Writes pitch and yaw from the monster toward a script position.
 *
 */
int _GET_REF_ROT(RS_STACKDATA *stack, int argc) {
    float self_pos[4];
    float target[4];
    float rot[4];

    if (argc != 6) {
        return 0;
    }

    GetStackVector(target, &stack);
    nowMonster->GetPosition(self_pos);
    sceVu0SubVector(target, target, self_pos);
    sceVu0Normalize(target, target);
    rot[1] = atan2f(target[0], target[2]);
    rot[0] = -atan2f(target[1], sqrtf(target[0] * target[0] + target[2] * target[2]));
    rot[2] = 0;
    SetStackVector(rot, &stack);
    return 1;
}

/**
 *
 * Writes yaw or the normalized direction between two script positions.
 *
 */
int _GET_REF_ROT2(RS_STACKDATA *stack, int argc) {
    float start[4];
    float target[4];

    if (argc != 7 && argc != 9) {
        return 0;
    }

    GetStackVector(target, &stack);
    GetStackVector(start, &stack);
    sceVu0SubVector(target, target, start);
    sceVu0Normalize(target, target);
    float yaw = atan2f(target[0], target[2]);
    atan2f(target[1], sqrtf(target[0] * target[0] + target[2] * target[2]));

    if (argc == 7) {
        SetStack(stack++, yaw);
    }

    if (argc == 9) {
        SetStackVector(target, &stack);
    }

    return 1;
}

/**
 *
 * Searches from the monster along a horizontal flight direction.
 *
 */
int _FLYING_SEARCH_AREA(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }

    float distance = GetStackFloat(stack++);
    float angle = GetStackFloat(stack++);
    sceVu0FVECTOR dir = {0.0f, 0.0f, 1.0f, 0.0f};
    float pos[4];
    float rot[4];
    float matrix[4][4];
    nowMonster->GetPosition(pos);
    nowMonster->GetRotation(rot);
    rot[1] = mgAngleLimit(angle);
    sceVu0UnitMatrix(matrix);
    sceVu0RotMatrixY(matrix, matrix, rot[1]);
    sceVu0ApplyMatrix(dir, matrix, dir);
    sceVu0ScaleVector(dir, dir, distance);
    sceVu0AddVector(dir, dir, pos);
    SetStack(stack, SearchArea(nowScene, pos, dir, distance));
    return 1;
}

/**
 *
 * Writes the height above collision geometry below a script position.
 *
 */
static int _GET_HIGH2(RS_STACKDATA *args, int argc) {
    CCPoly        polygons[128];
    sceVu0FVECTOR position;
    sceVu0FVECTOR hit_position;
    mgVu0FBOX     box;
    sceVu0FVECTOR ray_start;
    sceVu0FVECTOR ray_end;
    CMap         *map;
    int           count;
    float         height_difference;

    if (argc != 4) {
        return 0;
    }

    GetStackVector(position, &args);
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
    sceVu0CopyVector(ray_start, position);
    sceVu0CopyVector(ray_end, position);
    ray_start[1] += 1.0f;
    ray_end[1] -= 300.0f;

    if (CheckHit(polygons, count, ray_start, ray_end, hit_position, 1, 2) >= 0) {
        height_difference = position[1] - hit_position[1];
    } else {
        height_difference = -3.4028235e38f;
    }

    SetStack(args++, height_difference);
    return 1;
}

/**
 *
 * Writes the ranked identifier of a different-type monster within range.
 *
 */
int _GET_RANGE_MONS_ID(RS_STACKDATA *stack, int argc) {
    RangeEntry  entries[24];
    float       self_pos[4];
    float       other_pos[4];
    int         i;
    int         j;
    int         count;
    RangeEntry *entry = entries;

    do {
        entry->distance = -1.0f;
        entry->id = -1;
        entry++;
    } while (entry < entries + 24);

    float range = GetStackFloat(stack++);
    int   rank = GetStackInt(stack++);
    nowMonster->GetPosition(self_pos);
    mgZeroVector(other_pos);

    for (i = 0, count = 0; i < 24; i++) {
        CActiveMonster *other;

        if ((other = (CActiveMonster *) nowScene->GetCharacter(i + 24)) != NULL &&
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
            float       first_distance = entries[m].distance;
            float       second_distance = entries[n].distance;
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

    SetStack(stack, entries[rank].id);
    return 1;
}

/**
 *
 * Writes the position of a selected entry object on a monster.
 *
 */
int _GET_ENTRY_OBJ_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];

    if (argc != 5) {
        return 0;
    }

    int          id = GetStackInt(stack++);
    int          entry_index = GetStackInt(stack++);
    CCharacter2 *monster;

    if (id != -1) {
        id -= 24;
        CActiveMonster **slots = ActiveMonster->active;
        monster = ActiveMonster->active[id];

        if (monster == NULL) {
            return 0;
        }
    } else {
        monster = nowMonster;
    }

    monster->GetEntryObjectPos(entry_index, pos);
    SetStackVector(pos, &stack);
    return 1;
}

/**
 *
 * Starts a monster knockback with scaled speed, deceleration, and duration.
 *
 */
int _BLOW_START(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }

    nowMonster->blow_speed = GetStackFloat(stack++);
    nowMonster->blow_speed = nowMonster->blow_speed * nowMonster->blow_rate;
    nowMonster->blow_decel = GetStackFloat(stack++);
    nowMonster->blow_time = GetStackInt(stack);
    return 1;
}

/**
 *
 * Sets the active monster action status value.
 *
 */
int _SET_ACT_STATUS(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    nowMonster->now_status = GetStackInt(stack);
    return 1;
}

/**
 *
 * Sets or clears a bit mask on the active monster.
 *
 */
int _SET_INT_FLAG(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int flag = GetStackInt(stack++);
    nowMonster->SetMaskFlag(flag, GetStackInt(stack));
    return 1;
}

/**
 *
 * Marks the monster dead and spawns its money, badge, and item rewards.
 *
 */
int _SET_DEAD_START(RS_STACKDATA *args, int argc) {
    sceVu0FVECTOR     position;
    sceVu0FVECTOR     velocity;
    int               total;
    CBattleCharaInfo *battle;
    int               i;
    int               large_coin;
    CPalletAnime     *pallet;
    BASE_MONSTER_TBL *table;
    float             money_rate;
    int               roll;
    int               drop_index;
    int               drop_second;

    if (argc != 0) {
        return 0;
    }

    nowMonster->state = ACTIVE_MONSTER_DEAD;
    pallet = &nowMonster->script_pallet;
    pallet->duration = 0;
    pallet->elapsed = 0;

    if (nowMonster->reward_money <= 0) {
        return 1;
    }

    nowMonster->GetEntryObjectPos(0, position);
    int reward = nowMonster->reward_money;
    money_rate = 1.0f;
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

    total = (int) (reward * money_rate);
    large_coin = (int) (0.7f * total);
    large_coin += (total - large_coin) % 5;

    if (large_coin > 0) {
        CPullItem *item = PullItemMan.GetList(2);

        if (item != NULL) {
            velocity[1] = 4.0f;
            velocity[2] = 0.0f;
            velocity[3] = 1.0f;
            velocity[0] = 0.0f;
            item->SetItem(position, velocity, PULL_ITEM_MONEY_LARGE);
            item->item_no = large_coin;
        }
    }

    printf("total = %d (%d)\n", total, large_coin);
    printf("num = %d (%d)\n", 5, (total - large_coin) / 5);

    for (i = 0; i < 5; i++) {
        CPullItem *item = PullItemMan.GetList(2);

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
            item->item_no = (total - large_coin) / 5;
        }
    }

    if (nowMonster->drop_badge != 0) {
        CPullItem *item = PullItemMan.GetList(1);

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

            CPullItem *item = PullItemMan.GetList(2);

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
        CPullItem *item = PullItemMan.GetList(2);

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

/**
 * Creates monster death effects and weapon experience pickups.
 */
int _SET_DEAD_OFF(RS_STACKDATA *args, int argc) {
    sceVu0FVECTOR position;
    sceVu0FVECTOR velocity;
    CDeadEffect  *effect;
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
    radius = 3.0f * nowMonster->GetBodyWidth();
    height = 2.0f * nowMonster->GetBodyHeight();
    if (height >= 60.0f) {
        height = 60.0f;
    }
    size = height / 32.0f;
    nowMonster->GetEntryObjectPos(0, position);
    if ((nowMonster->attrib & MONSTER_ATTRIB_UNK_2) == 0) {
        if (BattleFX.dead == NULL) {
            effect = NULL;
        } else {
            effect = &BattleFX.dead[BattleFX.dead_next];
            BattleFX.dead_next++;
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
            effect = &BattleFX.dead[BattleFX.dead_next];
            BattleFX.dead_next++;
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
        float bonus = 1.2f;
        experience = (int)((float)experience * bonus);
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
        CPullItem *item = PullItemMan.GetList(2);
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

/**
 *
 * Clears the monster catch state when its throw ends.
 *
 */
int _SET_SHROW_END(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 0) {
        return 0;
    }

    nowMonster->catch_state = 0;
    return 1;
}

/**
 *
 * Starts a named monster motion with optional step and mode.
 *
 */
int _SET_MOS(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *next = stack;
    int           flag = 0;
    char         *name = NULL;
    float         step = -1.0f;

    if (argc <= 0 || argc > 3) {
        return 0;
    }

    if (argc > 0) {
        name = GetStackString(next++);
    }

    if (argc >= 2) {
        step = GetStackFloat(next++);
    }

    if (argc == 3) {
        flag = GetStackInt(next);
    }

    if (name == NULL) {
        return 0;
    }

    nowMonster->SetMotion(name, flag, 1);

    if (step > 0.0f) {
        nowMonster->SetStep(step);
    }

    return 1;
}

/**
 *
 * Writes whether the current or named monster motion has finished.
 *
 */
int _CHECK_MOS_END(RS_STACKDATA *stack, int argc) {
    int   result;
    char *name;

    if (argc == 1) {
        result = nowMonster->CheckMotionEnd(0);
    }

    if (argc == 2) {
        name = GetStackString(stack + 1);

        if (name == NULL) {
            return 0;
        }

        result = nowMonster->CheckMotionEnd(name);
    }

    SetStack(stack, result);
    return 1;
}

/**
 *
 * Writes the frame wait of the current or named monster motion.
 *
 */
int _NOW_MOS_WAIT(RS_STACKDATA *stack, int argc) {
    float wait;

    if (argc == 1) {
        wait = nowMonster->GetNowFrameWait(NULL);
    }

    if (argc == 2) {
        char *name = GetStackString(stack + 1);

        if (name == NULL) {
            return 0;
        }

        wait = nowMonster->GetNowFrameWait(name);
    }

    SetStack(stack, wait);
    return 1;
}

/**
 *
 * Writes the status of the current or named monster motion.
 *
 */
int _GET_MOS_STATUS(RS_STACKDATA *stack, int argc) {
    int status;

    if (argc == 1) {
        status = nowMonster->GetMotionStatus(NULL);
    }

    if (argc == 2) {
        char *name = GetStackString(stack + 1);

        if (name == NULL) {
            return 0;
        }

        status = nowMonster->GetMotionStatus(name);
    }

    SetStack(stack, status);
    return 1;
}

/**
 *
 * Sets the active monster invulnerability duration.
 *
 */
int _SET_MUTEKI(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 1;
    }

    nowMonster->muteki_time = GetStackInt(stack);
    return 1;
}

/**
 *
 * Writes the active monster gekirin value.
 *
 */
int _GET_GEKIRIN(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    SetStack(stack, nowMonster->gekirin);
    return 1;
}

/**
 *
 * Writes the matching user monster identifier when the active user is a monster.
 *
 */
int _GET_USER_MONS_ID(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    int chara_id = -1;

    if (DngUserData->active_chr_no == 3) {
        chara_id = GetBattleCharaInfo()->user_mons_id;

        if (nowMonster->tbl->user_mons_id != chara_id) {
            chara_id = -1;
        }
    }

    SetStack(stack, chara_id);
    return 1;
}

/**
 *
 * Writes the active monster priority.
 *
 */
int _GET_PRIORITY(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    SetStack(stack, nowMonster->priority);
    return 1;
}

/**
 *
 * Creates a monster of the requested kind at an optional position and rotation.
 *
 */
int _CREATE_MONSTER(RS_STACKDATA *args, int argc) {
    sceVu0FVECTOR position;
    sceVu0FVECTOR rotation;
    int           id;

    mgZeroVector(position);
    position[3] = 1.0f;
    mgZeroVector(rotation);
    rotation[3] = 1.0f;
    id = GetStackInt(args++);

    if (argc >= 2) {
        position[0] = GetStackFloat(args++);
        position[1] = GetStackFloat(args++);
        position[2] = GetStackFloat(args++);
    }

    if (argc == 5) {
        rotation[1] = GetStackFloat(args);
    } else if (argc == 7) {
        rotation[0] = GetStackFloat(args++);
        rotation[1] = GetStackFloat(args++);
        rotation[2] = GetStackFloat(args);
    }

    int index;

    if ((index = ActiveMonster->SearchBaseIndex(id)) <= -1) {
        return 0;
    }

    CActiveMonster *monster = ActiveMonster->SetActiveMonster(index, position, rotation, -1);
    printf("mons_index = %d\n", index);
    return monster != NULL;
}

/**
 *
 * Sets the active monster clip distance from a script scale.
 *
 */
int _SET_CLIP_DIST(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    nowMonster->clip_dist = 20.0f * GetStackFloat(stack);
    return 1;
}

/**
 *
 * Rejects the collision configuration opcode without changing monster state.
 *
 */
int _SET_COLLISION(RS_STACKDATA *stack, int argc) {
    return 0;
}

/**
 *
 * Rejects the gravity configuration opcode without changing monster state.
 *
 */
int _SET_GRAVITY(RS_STACKDATA *stack, int argc) {
    return 0;
}

/**
 *
 * Sets or clears active monster attribute bits selected by a mask.
 *
 */
int _SET_ATTRIB(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int mask = GetStackInt(stack++);

    if (GetStackInt(stack)) {
        nowMonster->attrib |= mask;
    } else {
        nowMonster->attrib &= ~mask;
    }

    return 1;
}

/**
 *
 * Writes the active monster scale to three output slots.
 *
 */
int _GET_SCALE(RS_STACKDATA *stack, int argc) {
    float scale[4];

    if (argc != 3) {
        return 0;
    }

    nowMonster->GetScale(scale);
    SetStackVector(scale, &stack);
    return 1;
}

/**
 *
 * Writes the monster collision radius, using a default for nonpositive values.
 *
 */
int _GET_MONS_WIDTH(RS_STACKDATA *stack, int argc) {
    if (argc != 1 || nowMonster == NULL) {
        return 0;
    }

    float width = nowMonster->mons_move_check.radius;
    SetStack(stack, (float) (width <= 0.0 ? 15.0 : width));
    return 1;
}

/**
 *
 * Creates a named effect for this monster and optionally returns its slot.
 *
 */
int _ESM_CREATE(RS_STACKDATA *stack, int argc) {
    char *name = GetStackString(stack++);
    int   group = nowMonster->chara_type;
    int   slot;

    switch (argc) {
        case 1:
            ActiveMonster->effect_man->CreateEffSpt(name, group, 0);
            break;
        case 2:
            slot = ActiveMonster->effect_man->CreateEffSpt(name, group, 1);

            if (slot <= -1) {
                return 0;
            }

            SetStack(stack, slot);
            break;
    }

    return 1;
}

/**
 *
 * Sets an effect script program for this monster effect slot.
 *
 */
int _ESM_FINISH(RS_STACKDATA *stack, int argc) {
    int effect_id = nowMonster->chara_type;
    return ActiveMonster->effect_man->SetScriptProgNo(300, effect_id, GetStackInt(stack));
}

/**
 *
 * Deletes an effect from this monster effect slot.
 *
 */
int _ESM_DELETE(RS_STACKDATA *stack, int argc) {
    int effect_id = nowMonster->chara_type;
    return ActiveMonster->effect_man->DeleteEffSpt(effect_id, GetStackInt(stack));
}

/**
 * Sets the first effect script vector for this monster.
 */
int _ESM_SET_VECT1(RS_STACKDATA *stack, int argc) {
    sceVu0FVECTOR vector;
    int slot = GetStackInt(stack++);
    vector[0] = GetStackFloat(stack++);
    vector[1] = GetStackFloat(stack++);
    vector[2] = GetStackFloat(stack);
    vector[3] = 1.0f;
    int monster_type = nowMonster->chara_type;
    int group = monster_type;
    return ActiveMonster->effect_man->SetScriptVect1(vector, group, slot);
}

/**
 * Writes the first effect script vector to output slots.
 */
int _ESM_GET_VECT1(RS_STACKDATA *stack, int argc) {
    sceVu0FVECTOR vector;
    if (argc != 4) {
        return 0;
    }
    int slot = GetStackInt(stack++);
    int monster_type = nowMonster->chara_type;
    int group = monster_type;
    int result = ActiveMonster->effect_man->GetScriptVect1(vector, group, slot);
    SetStack(stack++, vector[0]);
    SetStack(stack++, vector[1]);
    SetStack(stack, vector[2]);
    return result;
}

/**
 * Sets the second effect script vector for this monster.
 */
int _ESM_SET_VECT2(RS_STACKDATA *stack, int argc) {
    sceVu0FVECTOR vector;
    if (argc != 4) {
        return 0;
    }
    int slot = GetStackInt(stack++);
    vector[0] = GetStackFloat(stack++);
    vector[1] = GetStackFloat(stack++);
    vector[2] = GetStackFloat(stack);
    vector[3] = 1.0f;
    int monster_type = nowMonster->chara_type;
    int group = monster_type;
    return ActiveMonster->effect_man->SetScriptVect2(vector, group, slot);
}

/**
 * Writes the second effect script vector to output slots.
 */
int _ESM_GET_VECT2(RS_STACKDATA *stack, int argc) {
    sceVu0FVECTOR vector;
    if (argc != 4) {
        return 0;
    }
    int slot = GetStackInt(stack++);
    int monster_type = nowMonster->chara_type;
    int group = monster_type;
    int result = ActiveMonster->effect_man->GetScriptVect2(vector, group, slot);
    SetStack(stack++, vector[0]);
    SetStack(stack++, vector[1]);
    SetStack(stack, vector[2]);
    return result;
}

/**
 * Sets an effect target identifier for this monster.
 */
int _ESM_SET_TARGET_ID(RS_STACKDATA *stack, int argc) {
    int slot = GetStackInt(stack++);
    int id = GetStackInt(stack);
    int monster_type = nowMonster->chara_type;
    int group = monster_type;
    return ActiveMonster->effect_man->SetScriptTargetId(id, group, slot);
}

/**
 * Writes an effect target identifier and returns the manager lookup status.
 */
int _ESM_GET_TARGET_ID(RS_STACKDATA *stack, int argc) {
    int id;
    int slot = GetStackInt(stack++);
    int monster_type = nowMonster->chara_type;
    int group = monster_type;
    int result = ActiveMonster->effect_man->GetScriptTargetId(id, group, slot);
    SetStack(stack, id);
    return result;
}

/**
 * Sets an effect user identifier for this monster.
 */
int _ESM_SET_USER_ID(RS_STACKDATA *stack, int argc) {
    int slot = GetStackInt(stack++);
    int id = GetStackInt(stack);
    int monster_type = nowMonster->chara_type;
    int group = monster_type;
    return ActiveMonster->effect_man->SetScriptUserId(id, group, slot);
}

/**
 * Writes an effect user identifier to an output slot.
 */
int _ESM_GET_USER_ID(RS_STACKDATA *stack, int argc) {
    int id;
    int slot = GetStackInt(stack++);
    int monster_type = nowMonster->chara_type;
    int group = monster_type;
    int result = ActiveMonster->effect_man->GetScriptUserId(id, group, slot);
    SetStack(stack, id);
    return result;
}

/**
 *
 * Sets an integer or float parameter on a monster effect slot.
 *
 */
int _ESM_SET_VALUE(RS_STACKDATA *stack, int argc) {
    int slot;
    int index;
    int group;
    int result;

    group = nowMonster->chara_type;
    slot = GetStackInt(stack++);
    index = GetStackInt(stack++);

    switch (stack->type) {
        case 0:
            result =
                ActiveMonster->effect_man->SetValue(index, GetStackInt(stack), group, slot);
            break;
        case 1:
            result =
                ActiveMonster->effect_man->SetValue(index, GetStackFloat(stack), group, slot);
            break;
        default:
            return 0;
    }

    return result;
}

/**
 *
 * Loads an effect script by number or name into the monster effect manager.
 *
 */
int _LOAD_EFFECT_SCRIPT(RS_STACKDATA *stack, int argc) {
    int        result;
    int        level;
    mgCMemory *memory;
    FxScriptMan->level = 3;
    level = -1;
    memory = nowScene->GetStack(3);

    switch (stack->type) {
        case 0: {
            int base_no = GetStackInt(stack++);

            if (argc >= 2) {
                level = GetStackInt(stack++);
            }

            result = ActiveMonster->effect_man->LoadBaseEffSpt(base_no, memory, level);
            break;
        }
        case 2: {
            char *name = GetStackString(stack++);

            if (argc >= 2) {
                level = GetStackInt(stack++);
            }

            result = ActiveMonster->effect_man->LoadBaseEffSpt(name, memory, level);
            break;
        }
        default:
            return 0;
    }

    if (argc >= 3) {
        if (result > 0) {
            SetStack(stack, 1);
        } else {
            SetStack(stack, 0);
        }
    }

    return (result < 0) ^ 1;
}

/**
 *
 * Configures a sword effect for a monster motion and pair of frames.
 *
 */
int _SW_EFFECT(RS_STACKDATA *stack, int argc) {
    if (argc != 9) {
        return 0;
    }

    ACTION_SW_EFFECT *effect = nowMonster->GetSwEffectPtr();

    if (effect == NULL) {
        return 0;
    }

    int index = GetStackInt(stack++);

    if (index < 0 || index > 2) {
        return 0;
    }

    if (nowMonster->sword_effect[index] == NULL) {
        return 0;
    }

    char *motion_name = GetStackString(stack++);
    float start_frame = GetStackFloat(stack++);
    float end_frame = GetStackFloat(stack++);
    char *start_name = GetStackString(stack++);
    char *end_name = GetStackString(stack++);
    int   arg_a = GetStackInt(stack++);
    int   arg_c = GetStackInt(stack++);
    int   arg_b = GetStackInt(stack);
    effect->sword_no = index;
    effect->motion = motion_name;
    effect->start = start_frame;
    effect->end = end_frame;
    effect->frame0 = start_name;
    effect->frame1 = end_name;
    effect->length = arg_a;
    effect->hold_time = arg_c;
    effect->fade_time = arg_b;
    effect->wait = 0;
    nowMonster->sw_effect_num += 1;
    return 1;
}

/**
 *
 * Writes an unused texture block number from the effect manager.
 *
 */
int _ESM_GET_NOTUESD_TEXB(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    SetStack(stack, ActiveMonster->effect_man->GetNotUsedTexb());
    return 1;
}

/**
 *
 * Advances the effect manager texture block reservation.
 *
 */
int _ESM_ADD_TEXB(RS_STACKDATA *stack, int argc) {
    ActiveMonster->effect_man->AddTexb();
    return 1;
}

/**
 *
 * Launches a monster rocket with position, direction, optional homing, and damage.
 *
 */
int _SHOT_ROCKET_LAUNCHER(RS_STACKDATA *args, int argc) {
    sceVu0FVECTOR position;
    sceVu0FVECTOR target;
    sceVu0FVECTOR direction;
    float         speed;
    int           damage;
    int           homing_delay;
    int           homing_time;

    if (argc != 10 && argc != 6) {
        return 0;
    }

    GetStackVector(position, &args);
    GetStackVector(direction, &args);

    if (argc == 10) {
        speed = GetStackFloat(args++);
        homing_delay = GetStackInt(args++);
        homing_time = GetStackInt(args++);
        damage = GetStackInt(args++);
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
    CRocketLauncher *rocket = RocketLauncher.Get();

    if (rocket != NULL) {
        rocket->SetPos(position, target, direction);
        rocket->target_chara = 0;
        rocket->speed = speed;
        rocket->homing_delay = homing_delay;
        rocket->homing_time = homing_time;
        CColPrim *primitive = ColPrimMan.GetPrim();
        int       primitive_id = -1;

        if (primitive != NULL) {
            primitive->SetDamage("\x83\x8d\x83\x7b\x83\x89\x83\x93\x83\x60\x83\x83", 2);
            primitive->SetCoord(position, 5.0f);
            primitive->damage = damage;
            primitive_id = primitive->id;
        }

        rocket->col_prim_id = primitive_id;
    } else {
        return 0;
    }

    return 1;
}

/**
 *
 * Sets the event script number requested by the active monster.
 *
 */
int _RUN_EVENT_SCRIPT(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    s16 v = (s16) GetStackInt(stack);
    nowMonster->event_no = v;
    return 1;
}

/**
 *
 * Sets or clears character status bits for the active monster in the scene.
 *
 */
int _SET_STATUS(RS_STACKDATA *stack, int argc) {
    int           status;
    RS_STACKDATA *next = stack + 1;
    status = GetStackInt(stack);
    int enable = 1;

    if (argc >= 2) {
        enable = GetStackInt(next);
    }

    if (enable != 0) {
        nowScene->SetStatus(1, nowMonster->chara_type, status);
    } else {
        nowScene->ResetStatus(1, nowMonster->chara_type, status);
    }

    return 1;
}

/**
 *
 * Sets or clears battle-area pause bits selected by a mask.
 *
 */
int _SET_PAUSE(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA    *next;
    DNG_BATTLE_AREA *pause = &nowScene->battle_area;
    next = stack + 1;

    if (pause == NULL) {
        return 0;
    }

    u32 mask = GetStackInt(stack);

    if (GetStackInt(next)) {
        pause->pause_flag |= mask;
    } else {
        pause->pause_flag &= ~mask;
    }

    return 1;
}

/**
 *
 * Writes the active battle-area pause bits selected by a mask.
 *
 */
int _CHECK_PAUSE(RS_STACKDATA *stack, int argument_count) {

    DNG_BATTLE_AREA *pause = &nowScene->battle_area;
    RS_STACKDATA    *output = stack + 1;

    if (pause == NULL) {
        return 0;
    }

    int requested_flags = GetStackInt(stack);
    SetStack(output, (int) (pause->pause_flag & requested_flags));
    return 1;
}

/**
 *
 * Writes a persistent dungeon save flag value.
 *
 */
int _GET_BIT_FLAG(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 2) {
        return 0;
    }

    int flag = GetStackInt(stack++);

    argument_count = DngSaveData->GetBitFlag(flag);
    SetStack(stack, argument_count);
    return 1;
}

/**
 *
 * Sets a persistent dungeon save flag value.
 *
 */
int _SET_BIT_FLAG(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 2) {
        return 0;
    }

    int bit = GetStackInt(stack++);
    int enabled = GetStackInt(stack);
    DngSaveData->SetBitFlag(bit, enabled);
    return 1;
}

/**
 *
 * Writes the active monster attack type.
 *
 */
int _GET_ATT_TYPE(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 1) {
        return 0;
    }

    SetStack(stack, nowMonster->att_type);
    return 1;
}

/**
 *
 * Writes the active battle character attribute.
 *
 */
int _GET_USER_ATTR(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 1) {
        return 0;
    }

    argument_count = GetBattleCharaInfo()->GetAttr();
    SetStack(stack, argument_count);
    return 1;
}

/**
 *
 * Copies a reserved monster image into its active image buffer.
 *
 */
int _TRANS_RESERV_IMG(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 1) {
        return 0;
    }

    int image_index = GetStackInt(stack);

    if (image_index < 0 || image_index > 1) {
        return 0;
    }

    CActiveMonster *monster = nowMonster;
    void           *image = monster->reserv_img[image_index];

    if (image == NULL) {
        return 0;
    }

    memcpy(monster->images[0], image, monster->reserv_img_size[image_index]);
    return 1;
}

/**
 *
 * Writes active monster status attribute bits selected by a mask.
 *
 */
int _GET_STS_ATTR(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 2) {
        return 0;
    }

    int mask = GetStackInt(stack++);
    SetStack(stack, (int) (nowMonster->status.attr & mask));
    return 1;
}

/**
 *
 * Marks the current monster stun time and updates its stun effect.
 *
 */
int _SET_PIYORI_MARK(RS_STACKDATA *stack, int argument_count) {
    nowMonster->piyori_mark = nowMonster->piyori_time;
    nowMonster->piyori.Set(nowMonster, nowMonster->piyori_mark);
    return 1;
}

/**
 *
 * Writes the active monster stun mark value.
 *
 */
int _CHECK_PIYORI(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 1) {
        return 0;
    }

    SetStack(stack, nowMonster->piyori_mark);
    return 1;
}

/**
 *
 * Writes the active monster attack value.
 *
 */
int _GET_BASE_ATTACK(RS_STACKDATA *stack, int argument_count) {
    SetStack(stack, nowMonster->attack);
    return 1;
}

/**
 *
 * Writes the nearest other monster position and distance.
 *
 */
int _GET_NEAR_MONS_POS(RS_STACKDATA *stack, int argument_count) {
    float pos[4];
    float nearest_pos[4];
    float other_pos[4];
    float nearest_dist = -1.0f;
    int   i;

    nowMonster->GetPosition(pos);
    mgZeroVector(nearest_pos);

    for (i = 0; i < MONSTER_ACTIVE_MAX; i++) {
        CActiveMonster *other;

        if ((other = (CActiveMonster *) nowScene->GetCharacter(i + 24)) != NULL &&
            other->chara_kind == 2 && nowMonster->chara_type != other->chara_type) {
            other->GetPosition(other_pos);

            if (nearest_dist >= 0.0) {
                float dist = mgDistVector(pos, other_pos);

                if (dist < nearest_dist) {
                    nearest_dist = dist;
                    *(u_long128 *) nearest_pos = *(u_long128 *) other_pos;
                }
            } else {
                *(u_long128 *) nearest_pos = *(u_long128 *) other_pos;
                nearest_dist = mgDistVector(pos, nearest_pos);
            }
        }
    }

    SetStack(stack++, nearest_pos[0]);
    SetStack(stack++, nearest_pos[1]);
    SetStack(stack++, nearest_pos[2]);
    SetStack(stack, nearest_dist);
    return 1;
}

/**
 *
 * Sets the size value on a selected monster entry object.
 *
 */
int _SET_INDEXOBJ_SIZE(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 2) {
        return 0;
    }

    int   object_index = GetStackInt(stack++);
    float size = GetStackFloat(stack);

    if (object_index == -1) {
        object_index = 0;
    }

    CActiveMonster     *monster = nowMonster;
    CHARA_ENTRY_OBJECT *objects = monster->entry_object;
    int                 offset = object_index * sizeof(CHARA_ENTRY_OBJECT);
    int                 address = (int) objects;
    address = offset + address;
    ((CHARA_ENTRY_OBJECT *) address)->size = size;
    return 1;
}

/**
 *
 * Writes the size value from a selected monster entry object.
 *
 */
int _GET_INDEXOBJ_SIZE(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 2) {
        return 0;
    }

    int object_index = GetStackInt(stack++);

    if (object_index == -1) {
        object_index = 0;
    }

    CActiveMonster *monster = nowMonster;
    int             object_base = (int) &monster->entry_object;
    object_index *= sizeof(CHARA_ENTRY_OBJECT);
    object_index += object_base;
    CHARA_ENTRY_OBJECT *object = (CHARA_ENTRY_OBJECT *) object_index;
    SetStack(stack, object->size);
    return 1;
}

/**
 *
 * Sets the current scene motion blur setting.
 *
 */
int _SET_MOTION_BLUR(RS_STACKDATA *stack,
                     int           argument_count) {
    if (argument_count != 1) {
        return 0;
    }

    nowScene->motion_blur = GetStackInt(stack);
    return 1;
}

/**
 *
 * Plays a sound from a selected monster sound bank.
 *
 */
int _MONS_SE_PLAY(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 2) {
        return 0;
    }

    int monster_id = GetStackInt(stack++);
    int sound = GetStackInt(stack);
    monster_id -= 24;
    CActiveMonster *monster = ActiveMonster->active[monster_id];

    if (monster == 0) {
        return 0;
    }

    sndSePlay(monster->sound_info.se_bank, sound, 0);
    return 1;
}

/**
 *
 * Stops a sound from a selected monster sound bank.
 *
 */
int _MONS_SE_STOP(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 2) {
        return 0;
    }

    int monster_id = GetStackInt(stack++);
    int sound = GetStackInt(stack);
    monster_id -= 24;
    CActiveMonster *monster = ActiveMonster->active[monster_id];

    if (monster == 0) {
        return 0;
    }

    sndSeStop(monster->sound_info.se_bank, sound, 0);
    return 1;
}

/**
 *
 * Controls a looped sound on a selected monster.
 *
 */
int _MONS_SE_LOOP(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 3) {
        return 0;
    }

    int monster_id = GetStackInt(stack++);
    int sound = GetStackInt(stack++);
    int flags = GetStackInt(stack);
    monster_id -= 24;
    CActiveMonster *monster = ActiveMonster->active[monster_id];

    if (monster == 0) {
        return 0;
    }

    monster->sound_info.loop_se->SeLoopPlayStop((int) monster->sound_info.se_bank, sound, flags, 13);
    return 1;
}

/**
 *
 * Sets whether active monster sounds use positional volume.
 *
 */
int _MONS_VOL_CTRL(RS_STACKDATA *stack, int argument_count) {
    if (argument_count != 1) {
        return 0;
    }

    nowMonster->sound_info.se_positional = GetStackInt(stack);
    return 1;
}

/**
 *
 * Shows or hides a named map part or one of its pieces.
 *
 */
int _SET_MAPOBJ_SHOW(RS_STACKDATA *stack, int argument_count) {
    CMap      *maps[8];
    CMapParts *parts;
    int        map_count;
    char      *parts_name;
    char      *piece_name;
    CMapPiece *piece;
    int        show;
    int        i;

    if (argument_count != 2 && argument_count != 3) {
        return 0;
    }

    map_count = nowScene->GetActiveMap(maps, 8);

    if (map_count <= 0) {
        return 0;
    }

    parts_name = GetStackString(stack++);

    if (argument_count == 3) {
        piece_name = GetStackString(stack++);
    }

    show = GetStackInt(stack);

    for (i = 0; i < map_count; i++) {
        parts = maps[i]->GetPlaceParts(parts_name);

        if (parts != NULL) {
            break;
        }
    }

    if (parts == NULL) {
        return 0;
    }

    if (argument_count == 3) {
        if ((piece = parts->SearchPiece(piece_name)) == NULL) {
            return 0;
        }
    }

    if (argument_count == 2) {
        parts->Show(show);
    } else {
        piece->Show(show);
    }

    return 1;
}

/**
 *
 * Loads a monster program with allocated script stacks and opcode callbacks.
 *
 */
int SetMonsterScript(CRunScript *script, char *program, mgCMemory *memory) {

    RS_STACKDATA *value_stack = (RS_STACKDATA *) memory->Alloc(0x40);
    RS_CALLDATA  *call_stack = (RS_CALLDATA *) memory->Alloc(0x180);
    script->load((RS_PROG_HEADER *) program, value_stack, 128, call_stack,
                 512);
    script->ext_func(ext_func, RS_MONSTER_EXT_LIMIT);
    return 1;
}

/**
 * Associates monster script function numbers with their native callbacks.
 */
static RS_EXTFUNC_INFO ext_func_info[] = {
    {_NORMAL_VECTOR, RS_MONSTER_EXT_NORMAL_VECTOR},
    {_COPY_VECTOR, RS_MONSTER_EXT_COPY_VECTOR},
    {_ADD_VECTOR, RS_MONSTER_EXT_ADD_VECTOR},
    {_SUB_VECTOR, RS_MONSTER_EXT_SUB_VECTOR},
    {_SCALE_VECTOR, RS_MONSTER_EXT_SCALE_VECTOR},
    {_DIV_VECTOR, RS_MONSTER_EXT_DIV_VECTOR},
    {_ANGLE_CMP, RS_MONSTER_EXT_ANGLE_CMP},
    {_ANGLE_LIMIT, RS_MONSTER_EXT_ANGLE_LIMIT},
    {_SQRT, RS_MONSTER_EXT_SQRT},
    {_ATAN2F, RS_MONSTER_EXT_ATAN2F},
    {_ND_TEST, RS_MONSTER_EXT_ND_TEST},
    {_GET_DIST_VECTOR, RS_MONSTER_EXT_GET_DIST_VECTOR},
    {_GET_DIST_VECTOR2, RS_MONSTER_EXT_GET_DIST_VECTOR2},
    {_CALC_IP_CIRCLE_LINE, RS_MONSTER_EXT_CALC_IP_CIRCLE_LINE},
    {_GET_ANGLE_INNER, RS_MONSTER_EXT_GET_ANGLE_INNER},
    {_MY_SE_PLAY, RS_MONSTER_EXT_MY_SE_PLAY},
    {_MY_SE_STOP, RS_MONSTER_EXT_MY_SE_STOP},
    {_MONS_SE_PLAY, RS_MONSTER_EXT_MONS_SE_PLAY},
    {_MONS_SE_STOP, RS_MONSTER_EXT_MONS_SE_STOP},
    {_MONS_SE_LOOP, RS_MONSTER_EXT_MONS_SE_LOOP},
    {_SET_CAMERA_NEXT_REF, RS_MONSTER_EXT_SET_CAMERA_NEXT_REF},
    {_SET_CAMERA_FOLLOW, RS_MONSTER_EXT_SET_CAMERA_FOLLOW},
    {_SET_CAMERA_NEXT_POS, RS_MONSTER_EXT_SET_CAMERA_NEXT_POS},
    {_SET_CAMERA_MODE, RS_MONSTER_EXT_SET_CAMERA_MODE},
    {_SET_CAMERA_SPEED, RS_MONSTER_EXT_SET_CAMERA_SPEED},
    {_CAMERA_QUAKE, RS_MONSTER_EXT_CAMERA_QUAKE},
    {_SET_CAMERA_CTRL_PARAM1, RS_MONSTER_EXT_SET_CAMERA_CTRL_PARAM1},
    {_SET_CAMERA_CTRL_PARAM2, RS_MONSTER_EXT_SET_CAMERA_CTRL_PARAM2},
    {_RESET_CAMERA_CTRL_PARAM, RS_MONSTER_EXT_RESET_CAMERA_CTRL_PARAM},
    {_GET_RND, RS_MONSTER_EXT_GET_RND},
    {_GET_RNDF, RS_MONSTER_EXT_GET_RNDF},
    {_V_PUSH, RS_MONSTER_EXT_V_PUSH},
    {_V_POP, RS_MONSTER_EXT_V_POP},
    {_GET_MONSTER_NUM, RS_MONSTER_EXT_GET_MONSTER_NUM},
    {_GET_MONSTER_INDEX, RS_MONSTER_EXT_GET_MONSTER_INDEX},
    {_GET_MONSTER_ID, RS_MONSTER_EXT_GET_MONSTER_ID},
    {_GET_USERID, RS_MONSTER_EXT_GET_USERID},
    {_GET_USER_MONS_ID, RS_MONSTER_EXT_GET_USER_MONS_ID},
    {_RESET_TIMER, RS_MONSTER_EXT_RESET_TIMER},
    {_GET_TIMER, RS_MONSTER_EXT_GET_TIMER},
    {_CREATE_MONSTER, RS_MONSTER_EXT_CREATE_MONSTER},
    {_RUN_EVENT_SCRIPT, RS_MONSTER_EXT_RUN_EVENT_SCRIPT},
    {_GET_FRAME_POS, RS_MONSTER_EXT_GET_FRAME_POS},
    {_GET_OBJ_POS, RS_MONSTER_EXT_GET_OBJ_POS},
    {_GET_MAPOBJ_POS, RS_MONSTER_EXT_GET_MAPOBJ_POS},
    {_SET_PAUSE, RS_MONSTER_EXT_SET_PAUSE},
    {_CHECK_PAUSE, RS_MONSTER_EXT_CHECK_PAUSE},
    {_GET_BIT_FLAG, RS_MONSTER_EXT_GET_BIT_FLAG},
    {_SET_BIT_FLAG, RS_MONSTER_EXT_SET_BIT_FLAG},
    {_GET_ATT_TYPE, RS_MONSTER_EXT_GET_ATT_TYPE},
    {_GET_USER_ATTR, RS_MONSTER_EXT_GET_USER_ATTR},
    {_TRANS_RESERV_IMG, RS_MONSTER_EXT_TRANS_RESERV_IMG},
    {_GET_STS_ATTR, RS_MONSTER_EXT_GET_STS_ATTR},
    {_V_PUSH2, RS_MONSTER_EXT_V_PUSH2},
    {_V_POP2, RS_MONSTER_EXT_V_POP2},
    {_SET_LOCKON_MODE, RS_MONSTER_EXT_SET_LOCKON_MODE},
    {_SET_MOTION_BLUR, RS_MONSTER_EXT_SET_MOTION_BLUR},
    {_GET_EVENT_INFO, RS_MONSTER_EXT_GET_EVENT_INFO},
    {_MONS_VOL_CTRL, RS_MONSTER_EXT_MONS_VOL_CTRL},
    {_GET_DIST, RS_MONSTER_EXT_GET_DIST},
    {_SEARCH_AREA, RS_MONSTER_EXT_SEARCH_AREA},
    {_SEARCH_AREA2, RS_MONSTER_EXT_SEARCH_AREA2},
    {_GET_PLACE_POS, RS_MONSTER_EXT_GET_PLACE_POS},
    {_SET_PLACE_POS, RS_MONSTER_EXT_SET_PLACE_POS},
    {_GET_INDEX_POS, RS_MONSTER_EXT_GET_INDEX_POS},
    {_GET_POS, RS_MONSTER_EXT_GET_POS},
    {_SET_POS, RS_MONSTER_EXT_SET_POS},
    {_GET_ROT, RS_MONSTER_EXT_GET_ROT},
    {_SET_ROT, RS_MONSTER_EXT_SET_ROT},
    {_SET_NEXT_ROT, RS_MONSTER_EXT_SET_NEXT_ROT},
    {_SET_NEXT_POS, RS_MONSTER_EXT_SET_NEXT_POS},
    {_CHK_MOVE_END, RS_MONSTER_EXT_CHK_MOVE_END},
    {_RESET_MOVE, RS_MONSTER_EXT_RESET_MOVE},
    {_GET_TARGET_POS, RS_MONSTER_EXT_GET_TARGET_POS},
    {_GET_TARGET_DIST, RS_MONSTER_EXT_GET_TARGET_DIST},
    {_GET_TARGET_ANGLE, RS_MONSTER_EXT_GET_TARGET_ANGLE},
    {_GET_TARGET_REF_POS, RS_MONSTER_EXT_GET_TARGET_REF_POS},
    {_GET_REF_DIR, RS_MONSTER_EXT_GET_REF_DIR},
    {_GET_REFANGLE_POS, RS_MONSTER_EXT_GET_REFANGLE_POS},
    {_GET_TARGET_ROT, RS_MONSTER_EXT_GET_TARGET_ROT},
    {_GET_REF_ANGLE, RS_MONSTER_EXT_GET_REF_ANGLE},
    {_GET_HIGH, RS_MONSTER_EXT_GET_HIGH},
    {_GET_NEAR_MONS_POS, RS_MONSTER_EXT_GET_NEAR_MONS_POS},
    {_GET_TARGET_OLD_POS, RS_MONSTER_EXT_GET_TARGET_OLD_POS},
    {_GET_TARGET_SPEED, RS_MONSTER_EXT_GET_TARGET_SPEED},
    {_CALC_MOVE_NEXT_POS, RS_MONSTER_EXT_CALC_MOVE_NEXT_POS},
    {_GET_POSREF_ANGLE, RS_MONSTER_EXT_GET_POSREF_ANGLE},
    {_GET_ACTIVE_MONS_POS, RS_MONSTER_EXT_GET_ACTIVE_MONS_POS},
    {_GET_ACTIVE_MONS_ROT, RS_MONSTER_EXT_GET_ACTIVE_MONS_ROT},
    {_GET_ACTIVE_MONS_DIST, RS_MONSTER_EXT_GET_ACTIVE_MONS_DIST},
    {_GET_ACTIVE_MONS_ANGLE, RS_MONSTER_EXT_GET_ACTIVE_MONS_ANGLE},
    {_GET_REF_ROT, RS_MONSTER_EXT_GET_REF_ROT},
    {_GET_REF_ROT2, RS_MONSTER_EXT_GET_REF_ROT2},
    {_FLYING_SEARCH_AREA, RS_MONSTER_EXT_FLYING_SEARCH_AREA},
    {_GET_HIGH2, RS_MONSTER_EXT_GET_HIGH2},
    {_GET_RANGE_MONS_ID, RS_MONSTER_EXT_GET_RANGE_MONS_ID},
    {_GET_ENTRY_OBJ_POS, RS_MONSTER_EXT_GET_ENTRY_OBJ_POS},
    {_SET_OBJ, RS_MONSTER_EXT_SET_OBJ},
    {_SET_BODY, RS_MONSTER_EXT_SET_BODY},
    {_SET_DMG, RS_MONSTER_EXT_SET_DMG},
    {_SET_DMG2, RS_MONSTER_EXT_SET_DMG2},
    {_LINK_MAP_TO_OBJECT, RS_MONSTER_EXT_LINK_MAP_TO_OBJECT},
    {_LINK_OBJECT_TO_PIECE, RS_MONSTER_EXT_LINK_OBJECT_TO_PIECE},
    {_LOAD_EFFECT_SCRIPT, RS_MONSTER_EXT_LOAD_EFFECT_SCRIPT},
    {_SET_SCOOP, RS_MONSTER_EXT_SET_SCOOP},
    {_LOAD_RESERV_IMG, RS_MONSTER_EXT_LOAD_RESERV_IMG},
    {_SET_PRIORITY_LIMMIT, RS_MONSTER_EXT_SET_PRIORITY_LIMMIT},
    {_SET_MODEL_LIGHT_SWITCH, RS_MONSTER_EXT_SET_MODEL_LIGHT_SWITCH},
    {_SET_MODEL_LIGHT_COLOR, RS_MONSTER_EXT_SET_MODEL_LIGHT_COLOR},
    {_SET_ALPHA, RS_MONSTER_EXT_SET_ALPHA},
    {_SET_SCALE, RS_MONSTER_EXT_SET_SCALE},
    {_SET_INDEX_ALPHA, RS_MONSTER_EXT_SET_INDEX_ALPHA},
    {_SET_PALLET_ANIM, RS_MONSTER_EXT_SET_PALLET_ANIM},
    {_RESET_PALLET_ANIM, RS_MONSTER_EXT_RESET_PALLET_ANIM},
    {_SET_ATTRIB, RS_MONSTER_EXT_SET_ATTRIB},
    {_SET_STATUS, RS_MONSTER_EXT_SET_STATUS},
    {_SET_INT_FLAG, RS_MONSTER_EXT_SET_INT_FLAG},
    {_SET_ACT_STATUS, RS_MONSTER_EXT_SET_ACT_STATUS},
    {_SET_MUTEKI, RS_MONSTER_EXT_SET_MUTEKI},
    {_SET_GRAVITY, RS_MONSTER_EXT_SET_GRAVITY},
    {_SET_COLLISION, RS_MONSTER_EXT_SET_COLLISION},
    {_GET_GEKIRIN, RS_MONSTER_EXT_GET_GEKIRIN},
    {_GET_PRIORITY, RS_MONSTER_EXT_GET_PRIORITY},
    {_SET_CLIP_DIST, RS_MONSTER_EXT_SET_CLIP_DIST},
    {_SET_PIYORI_MARK, RS_MONSTER_EXT_SET_PIYORI_MARK},
    {_CHECK_PIYORI, RS_MONSTER_EXT_CHECK_PIYORI},
    {_GET_SCALE, RS_MONSTER_EXT_GET_SCALE},
    {_GET_MONS_WIDTH, RS_MONSTER_EXT_GET_MONS_WIDTH},
    {_BLOW_START, RS_MONSTER_EXT_BLOW_START},
    {_SET_DEAD_START, RS_MONSTER_EXT_SET_DEAD_START},
    {_SET_DEAD_OFF, RS_MONSTER_EXT_SET_DEAD_OFF},
    {_SET_SHROW_END, RS_MONSTER_EXT_SET_SHROW_END},
    {_GET_BASE_ATTACK, RS_MONSTER_EXT_GET_BASE_ATTACK},
    {_SET_DEF_RATE, RS_MONSTER_EXT_SET_DEF_RATE},
    {_SET_MONSTER_LIFE, RS_MONSTER_EXT_SET_MONSTER_LIFE},
    {_GET_MONSTER_LIFE, RS_MONSTER_EXT_GET_MONSTER_LIFE},
    {_GET_NO_DAMAGE_CNT, RS_MONSTER_EXT_GET_NO_DAMAGE_CNT},
    {_GET_ACTIVE_MONS_LIFEI, RS_MONSTER_EXT_GET_ACTIVE_MONS_LIFEI},
    {_GET_ACTIVE_MONS_LIFEF, RS_MONSTER_EXT_GET_ACTIVE_MONS_LIFEF},
    {_SET_ACTIVE_MONS_LIFEI, RS_MONSTER_EXT_SET_ACTIVE_MONS_LIFEI},
    {_SET_ACTIVE_MONS_LIFEF, RS_MONSTER_EXT_SET_ACTIVE_MONS_LIFEF},
    {_GET_ACTIVE_MONS_MAX_LIFE, RS_MONSTER_EXT_GET_ACTIVE_MONS_MAX_LIFE},
    {_SET_DAMAGE_SCORE, RS_MONSTER_EXT_SET_DAMAGE_SCORE},
    {_GET_MONS_GRADE, RS_MONSTER_EXT_GET_MONS_GRADE},
    {_SET_ESCAPE_RATE, RS_MONSTER_EXT_SET_ESCAPE_RATE},
    {_SET_GUARD_RATE, RS_MONSTER_EXT_SET_GUARD_RATE},
    {_SET_EXT_PARAM_RATE, RS_MONSTER_EXT_SET_EXT_PARAM_RATE},
    {_GET_BOSS_FLAG, RS_MONSTER_EXT_GET_BOSS_FLAG},
    {_SET_INDEXOBJ_SIZE, RS_MONSTER_EXT_SET_INDEXOBJ_SIZE},
    {_GET_INDEXOBJ_SIZE, RS_MONSTER_EXT_GET_INDEXOBJ_SIZE},
    {_RESET_MOTION, RS_MONSTER_EXT_RESET_MOTION},
    {_SET_MOS, RS_MONSTER_EXT_SET_MOS},
    {_CHECK_MOS_END, RS_MONSTER_EXT_CHECK_MOS_END},
    {_NOW_MOS_WAIT, RS_MONSTER_EXT_NOW_MOS_WAIT},
    {_GET_MOS_STATUS, RS_MONSTER_EXT_GET_MOS_STATUS},
    {_ESM_CREATE, RS_MONSTER_EXT_ESM_CREATE},
    {_ESM_FINISH, RS_MONSTER_EXT_ESM_FINISH},
    {_ESM_DELETE, RS_MONSTER_EXT_ESM_DELETE},
    {_ESM_SET_VECT1, RS_MONSTER_EXT_ESM_SET_VECT1},
    {_ESM_GET_VECT1, RS_MONSTER_EXT_ESM_GET_VECT1},
    {_ESM_SET_VECT2, RS_MONSTER_EXT_ESM_SET_VECT2},
    {_ESM_GET_VECT2, RS_MONSTER_EXT_ESM_GET_VECT2},
    {_ESM_SET_TARGET_ID, RS_MONSTER_EXT_ESM_SET_TARGET_ID},
    {_ESM_GET_TARGET_ID, RS_MONSTER_EXT_ESM_GET_TARGET_ID},
    {_ESM_SET_USER_ID, RS_MONSTER_EXT_ESM_SET_USER_ID},
    {_ESM_GET_USER_ID, RS_MONSTER_EXT_ESM_GET_USER_ID},
    {_ESM_SET_VALUE, RS_MONSTER_EXT_ESM_SET_VALUE},
    {_SW_EFFECT, RS_MONSTER_EXT_SW_EFFECT},
    {_ESM_GET_NOTUESD_TEXB, RS_MONSTER_EXT_ESM_GET_NOTUESD_TEXB},
    {_ESM_ADD_TEXB, RS_MONSTER_EXT_ESM_ADD_TEXB},
    {_SHOT_ROCKET_LAUNCHER, RS_MONSTER_EXT_SHOT_ROCKET_LAUNCHER},
    {_ESM_ALL_CLEAR, RS_MONSTER_EXT_ESM_ALL_CLEAR},
    {_SET_MAPOBJ_SHOW, RS_MONSTER_EXT_SET_MAPOBJ_SHOW},
    {NULL, RS_MONSTER_EXT_END},
};

/**
 *
 * Builds the monster opcode dispatch table and checks duplicate opcode numbers.
 *
 */
void SetMonsterExtendTable() {
    int index;
    int earlier;

    for (index = 0; index < RS_MONSTER_EXT_LIMIT; index++) {
        ext_func[index] = NULL;
    }

    for (index = 0;; index++) {
        if (ext_func_info[index].func == NULL) {
            break;
        }

        if (0 < index) {
            earlier = 0;

            do {
                if (ext_func_info[index].no == ext_func_info[earlier].no) {
                    printf("mscript same ext_func_no!!!\n");

                    while (1) {
                    }
                }

                earlier++;
            } while (earlier < index);
        }

        if (ext_func_info[index].no < 0 || ext_func_info[index].no >= RS_MONSTER_EXT_LIMIT) {
            printf("ext func over!!");
        } else {
            ext_func[ext_func_info[index].no] = ext_func_info[index].func;
        }
    }
}
