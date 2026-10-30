#include "common.h"
#include "mw_runtime.h"

#include <libvu0.h>

#include <algorithm>
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
#include "log/game_output.hpp"
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
#include "runscript_opcodes.hpp"
#include "savedata.hpp"
#include "scenesnd.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include "userdata.hpp"

/**
 *
 * Scene used by the active monster's script callbacks.
 *
 */
static CScene *nowScene;

void PortSetMonsterScriptScene(CScene *scene) { nowScene = scene; }

/**
 *
 * Monster whose script callbacks are running.
 *
 */
CActiveMonster *nowMonster;

/**
 *
 * Damage entry returned by the most recent monster damage callback.
 *
 */
static ACTION_DAMAGE *LastCInfo2;

/**
 *
 * Monster script callback dispatch table indexed by external function number.
 *
 */
static dc2::script::RunFunction ext_func[RS_MONSTER_EXT_LIMIT];

/**
 *
 * Distance and identifier of a script range entry.
 *
 */
struct RangeEntry {
    float distance; /**< Range distance. */
    int   id;       /**< Entry identifier. */
};

/**
 *
 * Resolves every destination of a vector before modifying any component.
 *
 */
static std::array<RS_STACKDATA *, 3> VectorOutputs(dc2::script::RunArguments stack) {
    return {&dc2::script::RunOutput(stack), &dc2::script::RunOutput(stack + 1),
            &dc2::script::RunOutput(stack + 2)};
}

/**
 *
 * Reads finite floating-point components from a validated vector variable.
 *
 */
static std::array<float, 3> ReadOutputVector(dc2::script::RunArguments stack) {
    const auto           outputs = VectorOutputs(stack);
    std::array<float, 3> values{};
    for (std::size_t index = 0; index < values.size(); ++index) {
        if (outputs[index]->type != RS_FLOAT || !std::isfinite(outputs[index]->val.f)) {
            throw dc2::script::ArgumentError("vector variable is not a finite float");
        }
        values[index] = outputs[index]->val.f;
    }
    return values;
}

/**
 *
 * Stores a complete vector after validating all destinations and components.
 *
 */
static void SetOutputVector(dc2::script::RunArguments stack, std::array<float, 3> values) {
    const auto outputs = VectorOutputs(stack);
    for (const float value : values) {
        if (!std::isfinite(value)) {
            throw dc2::script::ArgumentError("vector result is not finite");
        }
    }
    for (std::size_t index = 0; index < values.size(); ++index) {
        outputs[index]->val.f = values[index];
    }
}

/**
 *
 * Reads a script number as an integer, converting a floating point value when needed.
 *
 */
static int GetStackInt(dc2::script::RunArguments stack) {
    return dc2::script::RunInteger(stack);
}

/**
 *
 * Reads a script number as a float, converting an integer value when needed.
 *
 */
static float GetStackFloat(dc2::script::RunArguments stack) {
    return dc2::script::RunFloat(stack);
}

/**
 *
 * Reads the string pointer held in a script stack slot.
 *
 */
static char *GetStackString(dc2::script::RunArguments stack) {
    return dc2::script::RunCString(stack);
}

/**
 *
 * Writes an integer through a script output reference.
 *
 */
static void SetStack(dc2::script::RunArguments stack, int value) {
    dc2::script::RunOutput(stack).val.i = value;
}

/**
 *
 * Writes a floating point value through a script output reference.
 *
 */
static void SetStack(dc2::script::RunArguments stack, float value) {
    dc2::script::RunOutput(stack).val.f = value;
}

/**
 *
 * Reads three numeric script arguments into a homogeneous position vector.
 *
 */
static void GetStackVector(float *vec, dc2::script::RunArguments *stack) {
    const float x = GetStackFloat((*stack)++);
    const float y = GetStackFloat((*stack)++);
    const float z = GetStackFloat((*stack)++);
    vec[0] = x;
    vec[1] = y;
    vec[2] = z;
    vec[3] = 1.0f;
}

/**
 *
 * Writes three vector components through script output arguments.
 *
 */
static void SetStackVector(float *vec, dc2::script::RunArguments *stack) {
    SetOutputVector(*stack, {vec[0], vec[1], vec[2]});
    *stack = *stack + 3;
}

/**
 *
 * Writes the square root of a script argument to an output slot.
 *
 */
int _SQRT(dc2::script::RunArguments stack, int argument_count) {
    float value = GetStackFloat(stack++);
    SetStack(stack, static_cast<float>(sqrt(value)));
    return 1;
}

/**
 *
 * Writes the angle of two script arguments to an output slot.
 *
 */
int _ATAN2F(dc2::script::RunArguments stack, int argument_count) {
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
int _ND_TEST(dc2::script::RunArguments stack, int argc) {
    return 1;
}

/**
 *
 * Writes the current target character rotation to three output slots.
 *
 */
int _GET_TARGET_ROT(dc2::script::RunArguments stack, int argument_count) {
    float        pos[4];
    CCharacter2 *target = {};

    if (argument_count != 3) {
        return 0;
    }

    target = nowScene->GetCharacter(nowMonster->target_no);

    if (target == nullptr) {
        return 0;
    }

    target->GetRotation(pos);
    SetOutputVector(stack, {pos[0], pos[1], pos[2]});
    stack = stack + 2;
    return 1;
}

/**
 *
 * Writes the active monster instance identifier to an output slot.
 *
 */
int _GET_MONSTER_INDEX(dc2::script::RunArguments stack, int argument_count) {
    SetStack(stack, nowMonster->monster_id);
    return 1;
}

/**
 *
 * Sets the active monster life from an absolute value or fraction of maximum life.
 *
 */
int _SET_MONSTER_LIFE(dc2::script::RunArguments stack, int argument_count) {
    int life = {};

    switch (stack.At().type) {
        case RS_INT:
            life = GetStackInt(stack);
            break;
        case RS_FLOAT:
            life = fptosi(static_cast<float>(nowMonster->max_life) * GetStackFloat(stack));
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
        nowMonster->state = ACTIVE_MONSTER_LIVE;
    }

    return 1;
}

/**
 *
 * Writes the active monster character type to an output slot.
 *
 */
int _GET_USERID(dc2::script::RunArguments stack, int argument_count) {
    SetStack(stack, nowMonster->chara_type);
    return 1;
}

/**
 *
 * Writes the active monster reference number to an output slot.
 *
 */
int _GET_MONSTER_ID(dc2::script::RunArguments stack, int argument_count) {
    SetStack(stack, nowMonster->refer_no);
    return 1;
}

/**
 *
 * Resets the active monster motion.
 *
 */
int _RESET_MOTION(dc2::script::RunArguments, int) {
    nowMonster->ResetMotion();
    return 1;
}

/**
 *
 * Finds an active monster by instance identifier and writes its position.
 *
 */
int _GET_INDEX_POS(dc2::script::RunArguments stack, int argument_count) {
    int             index = GetStackInt(stack++);
    int             i = {};
    float           pos[4];
    CActiveMonster *monster = {};

    for (i = 0; i < MONSTER_ACTIVE_MAX; i++) {
        monster = ActiveMonster->GetActiveMonster(i);

        if (monster != nullptr && monster->monster_id == index) {
            monster->GetPosition(pos);
            SetOutputVector(stack, {pos[0], pos[1], pos[2]});
            stack = stack + 2;
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
int _SET_CAMERA_NEXT_REF(dc2::script::RunArguments stack,
                         int                       argument_count) {
    CCameraControl *camera = {};
    float           x = {};
    float           y = {};
    float           z = {};

    camera = static_cast<CCameraControl *>(nowScene->GetCamera(nowScene->active_camera));

    if (camera == nullptr) {
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
int _SET_ALPHA(dc2::script::RunArguments stack, int argument_count) {
    float value = GetStackFloat(stack);
    nowMonster->alpha = value;
    return 1;
}

/**
 *
 * Finds an active monster by instance identifier and sets its alpha value.
 *
 */
int _SET_INDEX_ALPHA(dc2::script::RunArguments stack, int argument_count) {
    int             index = GetStackInt(stack++);
    int             i = {};
    CActiveMonster *monster = {};

    for (i = 0; i < MONSTER_ACTIVE_MAX; i++) {
        monster = ActiveMonster->GetActiveMonster(i);

        if (monster != nullptr && monster->monster_id == index) {
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
int _SET_CAMERA_FOLLOW(dc2::script::RunArguments stack, int argument_count) {
    CCameraControl *camera = {};

    camera = static_cast<CCameraControl *>(nowScene->GetCamera(nowScene->active_camera));

    if (camera == nullptr) {
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
int _SET_CAMERA_NEXT_POS(dc2::script::RunArguments stack,
                         int                       argument_count) {
    CCameraControl *camera = {};
    float           x = {};
    float           y = {};
    float           z = {};

    camera = static_cast<CCameraControl *>(nowScene->GetCamera(nowScene->active_camera));

    if (camera == nullptr) {
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
int _GET_DIST_VECTOR(dc2::script::RunArguments stack, int argument_count) {
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
int _GET_DIST_VECTOR2(dc2::script::RunArguments stack, int argument_count) {
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
int _SET_SCALE(dc2::script::RunArguments stack, int argc) {
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
int _SET_PALLET_ANIM(dc2::script::RunArguments stack, int argc) {
    int first = {};
    int second = {};
    int third = {};
    int fourth = {};
    int fifth = {};
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
int _RESET_PALLET_ANIM(dc2::script::RunArguments stack, int argc) {
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
int _CALC_IP_CIRCLE_LINE(dc2::script::RunArguments stack, int argc) {
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
int _GET_POSREF_ANGLE(dc2::script::RunArguments stack, int argc) {
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
int _NORMAL_VECTOR(dc2::script::RunArguments stack, int argc) {
    const auto values = ReadOutputVector(stack);
    float      vector[4] = {values[0], values[1], values[2], 1.0f};
    sceVu0Normalize(vector, vector);
    SetOutputVector(stack, {vector[0], vector[1], vector[2]});
    return true;
}

/**
 *
 * Copies three numeric script arguments into vector output slots.
 *
 */
int _COPY_VECTOR(dc2::script::RunArguments stack, int argc) {
    float vector[4];
    auto  source = stack + 3;
    GetStackVector(vector, &source);
    SetOutputVector(stack, {vector[0], vector[1], vector[2]});
    return true;
}

/**
 *
 * Adds a three-component script vector to vector output slots.
 *
 */
int _ADD_VECTOR(dc2::script::RunArguments stack, int argc) {
    const auto values = ReadOutputVector(stack);
    float      operand[4];
    auto       source = stack + 3;
    GetStackVector(operand, &source);
    SetOutputVector(stack, {values[0] + operand[0], values[1] + operand[1], values[2] + operand[2]});
    return true;
}

/**
 *
 * Subtracts a three-component script vector from vector output slots.
 *
 */
int _SUB_VECTOR(dc2::script::RunArguments stack, int argc) {
    const auto values = ReadOutputVector(stack);
    float      operand[4];
    auto       source = stack + 3;
    GetStackVector(operand, &source);
    SetOutputVector(stack, {values[0] - operand[0], values[1] - operand[1], values[2] - operand[2]});
    return true;
}

/**
 *
 * Scales vector output slots by a numeric script argument.
 *
 */
int _SCALE_VECTOR(dc2::script::RunArguments stack, int argc) {
    const auto  values = ReadOutputVector(stack);
    const float scale = dc2::script::RunFloat(stack + 3);

    SetOutputVector(stack, {values[0] * scale, values[1] * scale, values[2] * scale});
    return true;
}

/**
 *
 * Divides vector output slots by a nonzero numeric script argument.
 *
 */
int _DIV_VECTOR(dc2::script::RunArguments stack, int argc) {
    const auto  values = ReadOutputVector(stack);
    const float scale = dc2::script::RunFloat(stack + 3);
    if (scale == 0.0f) {
        return false;
    }
    SetOutputVector(stack, {values[0] / scale, values[1] / scale, values[2] / scale});
    return true;
}

/**
 *
 * Writes whether an angle is within a requested tolerance of another angle.
 *
 */
int _ANGLE_CMP(dc2::script::RunArguments stack, int argc) {
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
int _ANGLE_LIMIT(dc2::script::RunArguments stack, int unused) {
    SetStack(stack, mgAngleLimit(dc2::script::RunOutput(stack).val.f));
    return 1;
}

/**
 *
 * Writes the previous position of the active monster target.
 *
 */
int _GET_TARGET_OLD_POS(dc2::script::RunArguments stack, int argc) {
    float         old_pos[4];
    CActionChara *target = static_cast<CActionChara *>(nowScene->GetCharacter(nowMonster->target_no));

    if (target == nullptr) {
        return 0;
    }

    sceVu0CopyVector(old_pos, target->old_pos);
    SetOutputVector(stack, {old_pos[0], old_pos[1], old_pos[2]});
    stack = stack + 2;
    return 1;
}

/**
 *
 * Writes the distance the active monster target moved since its previous position.
 *
 */
int _GET_TARGET_SPEED(dc2::script::RunArguments stack, int argc) {
    float         pos[4];
    float         old_pos[4];
    CActionChara *target = static_cast<CActionChara *>(nowScene->GetCharacter(nowMonster->target_no));

    if (target == nullptr) {
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
int _CALC_MOVE_NEXT_POS(dc2::script::RunArguments stack, int argc) {
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
    SetOutputVector(stack, {next[0], next[1], next[2]});
    stack = stack + 3;
    SetStack(stack, result);
    return 1;
}

/**
 *
 * Writes current monster life as an integer or fraction of maximum life.
 *
 */
int _GET_MONSTER_LIFE(dc2::script::RunArguments stack, int argc) {
    if (stack.At().type != RS_PTR) {
        return 0;
    }

    RS_STACKDATA *slot = &dc2::script::RunOutput(stack);

    if (slot->type == RS_INT) {
        SetStack(stack, nowMonster->life);
    } else if (slot->type == RS_FLOAT) {
        SetStack(stack, static_cast<float>(nowMonster->life) / static_cast<float>(nowMonster->max_life));
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
int _GET_NO_DAMAGE_CNT(dc2::script::RunArguments stack, int argc) {
    SetStack(stack, nowMonster->no_damage_cnt);
    return 1;
}

/**
 *
 * Writes the integer life of a selected active monster.
 *
 */
int _GET_ACTIVE_MONS_LIFEI(dc2::script::RunArguments stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int             id = GetStackInt(stack++);
    CActiveMonster *monster = {};

    if (id != -1) {
        id -= 24;
        monster = ActiveMonster->GetActiveMonster(id);

        if (monster == nullptr) {
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
int _GET_ACTIVE_MONS_LIFEF(dc2::script::RunArguments stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int             id = GetStackInt(stack++);
    CActiveMonster *monster = {};

    if (id != -1) {
        id -= 24;
        monster = ActiveMonster->GetActiveMonster(id);

        if (monster == nullptr) {
            return 0;
        }
    } else {
        monster = nowMonster;
    }

    SetStack(stack, static_cast<float>(monster->life) / static_cast<float>(monster->max_life));
    return 1;
}

/**
 *
 * Sets the integer life of a selected active monster.
 *
 */
int _SET_ACTIVE_MONS_LIFEI(dc2::script::RunArguments stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int             id = GetStackInt(stack++);
    int             amount = GetStackInt(stack);
    CActiveMonster *monster = {};

    if (id != -1) {
        id -= 24;
        monster = ActiveMonster->GetActiveMonster(id);

        if (monster == nullptr) {
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
int _SET_ACTIVE_MONS_LIFEF(dc2::script::RunArguments stack, int argc) {
    CActiveMonster *monster = {};
    int             id = {};
    int             max_life = {};
    int             amount = {};
    float           fraction = {};

    if (argc != 2) {
        return 0;
    }

    id = GetStackInt(stack++);
    fraction = GetStackFloat(stack);

    if (id != -1) {
        id -= 24;
        monster = ActiveMonster->GetActiveMonster(id);

        if (monster == nullptr) {
            return 0;
        }
    } else {
        monster = nowMonster;
    }

    max_life = monster->max_life;
    amount = fptosi(static_cast<float>(max_life) * fraction);

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
int _GET_ACTIVE_MONS_MAX_LIFE(dc2::script::RunArguments stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int             id = GetStackInt(stack++);
    CActiveMonster *monster = {};

    if (id != -1) {
        id -= 24;
        monster = ActiveMonster->GetActiveMonster(id);

        if (monster == nullptr) {
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
int _SET_DAMAGE_SCORE(dc2::script::RunArguments stack, int argc) {
    float         pos[4];
    int           color_flag = 0;
    int           id = {};
    int           value = {};
    CActionChara *monster = {};

    if (argc != 3 && argc != 2) {
        return 0;
    }

    id = GetStackInt(stack++);

    if (id != -1) {
        id -= 24;
        monster = ActiveMonster->GetActiveMonster(id);

        if (monster == nullptr) {
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
    pos[1] += (static_cast<CActiveMonster *>(monster))->body_height;

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
int _GET_MONS_GRADE(dc2::script::RunArguments stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int             id = GetStackInt(stack++);
    CActiveMonster *monster = {};

    if (id != -1) {
        id -= 24;
        monster = ActiveMonster->GetActiveMonster(id);

        if (monster == nullptr) {
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
int _SET_ESCAPE_RATE(dc2::script::RunArguments stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int             id = GetStackInt(stack++);
    CActiveMonster *monster = {};

    if (id != -1) {
        id -= 24;
        monster = ActiveMonster->GetActiveMonster(id);

        if (monster == nullptr) {
            return 0;
        }
    } else {
        monster = nowMonster;
    }

    float scale = GetStackFloat(stack);
    monster->tbl->escape_rate0 = fptosi(static_cast<float>(monster->base_tbl->escape_rate0) * scale);
    monster->tbl->escape_rate1 = fptosi(static_cast<float>(monster->base_tbl->escape_rate1) * scale);

    if (static_cast<u8>(monster->tbl->escape_rate0) > 100) {
        monster->tbl->escape_rate0 = 100;
    }

    if (static_cast<u8>(monster->tbl->escape_rate1) > 100) {
        monster->tbl->escape_rate1 = 100;
    }

    return 1;
}

/**
 *
 * Scales the selected monster guard rate from its base value.
 *
 */
int _SET_GUARD_RATE(dc2::script::RunArguments stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int             id = GetStackInt(stack++);
    CActiveMonster *monster = {};

    if (id != -1) {
        id -= 24;
        monster = ActiveMonster->GetActiveMonster(id);

        if (monster == nullptr) {
            return 0;
        }
    } else {
        monster = nowMonster;
    }

    float scale = GetStackFloat(stack);
    monster->tbl->guard_rate = fptosi(static_cast<float>(monster->base_tbl->guard_rate) * scale);

    if (static_cast<u8>(monster->tbl->guard_rate) > 100) {
        monster->tbl->guard_rate = 100;
    }

    return 1;
}

/**
 *
 * Scales selected monster extension parameters from their base values.
 *
 */
int _SET_EXT_PARAM_RATE(dc2::script::RunArguments stack, int argc) {
    if (argc != 3) {
        return 0;
    }

    int             id = GetStackInt(stack++);
    int             mask = GetStackInt(stack++);
    float           rate = GetStackFloat(stack);
    int             i = {};
    CActiveMonster *monster = {};

    if (id != -1) {
        id -= 24;
        monster = ActiveMonster->GetActiveMonster(id);

        if (monster == nullptr) {
            return 0;
        }
    } else {
        monster = nowMonster;
    }

    for (i = 0; i < 12; i++) {
        if (mask & (1 << i)) {
            monster->tbl->ext_param[i] = fptosi(static_cast<float>(monster->base_tbl->ext_param[i]) * rate);

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
int _GET_BOSS_FLAG(dc2::script::RunArguments stack, int argc) {
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
int _RESET_TIMER(dc2::script::RunArguments stack, int argc) {
    DNG_BATTLE_AREA *block = {};

    block = (&nowScene->battle_area);

    if (block == nullptr) {
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
int _GET_TIMER(dc2::script::RunArguments stack, int argc) {
    DNG_BATTLE_AREA *block = {};

    block = (&nowScene->battle_area);

    if (block == nullptr) {
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
int _GET_FRAME_POS(dc2::script::RunArguments stack, int argc) {
    float     pos[4];
    char     *name = GetStackString(stack++);
    mgCFrame *root = nowMonster->CObjectFrame::frame;

    if (root == nullptr) {
        return 0;
    }

    mgCFrame *frame = root->SearchFrame(name);

    if (frame == nullptr) {
        return 0;
    }

    frame->GetWorldPosition0(pos);
    SetOutputVector(stack, {pos[0], pos[1], pos[2]});
    stack = stack + 2;
    return 1;
}

/**
 *
 * Plays a positional sound effect from the active monster sound bank.
 *
 */
int _MY_SE_PLAY(dc2::script::RunArguments stack, int argc) {
    float pos[4];
    float volume = {};
    float pan = {};
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
int _MY_SE_STOP(dc2::script::RunArguments stack, int argc) {
    int id = GetStackInt(stack);
    sndSeStop(nowMonster->sound_info.se_bank, id, 0);
    return 1;
}

/**
 *
 * Writes the event stopwatch limit for its supported selector.
 *
 */
int _GET_EVENT_INFO(dc2::script::RunArguments stack, int argc) {
    int selector = GetStackInt(stack++);

    switch (selector) {
        case 0:
            SetStack(stack, static_cast<int>(EdEventInfo.stopwatch_limit));
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
int _ESM_ALL_CLEAR(dc2::script::RunArguments stack, int argc) {
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
int _GET_ANGLE_INNER(dc2::script::RunArguments stack, int argc) {
    if (argc != 3) {
        return 0;
    }

    float         angle_a = GetStackFloat(stack++);
    float         angle_b = GetStackFloat(stack++);
    sceVu0FVECTOR first = {0.0f, 0.0f, 1.0f, 0.0f};
    sceVu0FVECTOR second = {0.0f, 0.0f, 1.0f, 0.0f};
    float         matrix[4][4];
    float         rotated[4][4];
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
int _CAMERA_QUAKE(dc2::script::RunArguments stack, int argc) {
    DNG_BATTLE_AREA *quake = (&nowScene->battle_area);
    auto             next = stack + 1;

    if (quake == nullptr) {
        return 0;
    }

    float amplitude = GetStackFloat(stack);
    int   frames = GetStackInt(next);
    quake->quake_power = amplitude;
    quake->quake_step = quake->quake_power / static_cast<float>(frames);
    quake->quake_count = frames;
    return 1;
}

/**
 *
 * Sets the current battle-area camera mode value.
 *
 */
int _SET_CAMERA_MODE(dc2::script::RunArguments stack, int argc) {
    int              mode = {};
    DNG_BATTLE_AREA *area = {};

    mode = GetStackInt(stack);
    area = (&nowScene->battle_area);

    if (area == nullptr) {
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
int _SET_CAMERA_SPEED(dc2::script::RunArguments stack, int argc) {
    mgCCamera *camera = nowScene->GetCamera(nowScene->active_camera);

    if (camera == nullptr) {
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
int _SET_CAMERA_CTRL_PARAM1(dc2::script::RunArguments args, int argc) {
    CameraCtrlParam *param = {};
    float            value = 0.0f;

    if (argc > 0 && argc < 5) {
        return 0;
    }

    param = (static_cast<CCameraControl *>(nowScene->GetCamera(nowScene->active_camera)))->GetActiveParam();

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
int _SET_CAMERA_CTRL_PARAM2(dc2::script::RunArguments args, int argc) {
    CameraCtrlParam *param = {};
    float            value = 0.0f;

    if (argc > 0 && argc < 7) {
        return 0;
    }

    param = (static_cast<CCameraControl *>(nowScene->GetCamera(nowScene->active_camera)))->GetActiveParam();

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
int _RESET_CAMERA_CTRL_PARAM(dc2::script::RunArguments stack, int argc) {

    CameraCtrlParam *param = {};

    param = (static_cast<CCameraControl *>(nowScene->GetCamera(nowScene->active_camera)))->GetActiveParam();
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
int _GET_RND(dc2::script::RunArguments stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int range = GetStackInt(stack++);

    argc = fptosi(static_cast<float>(range) * static_cast<float>(rand()) / 2147483648.0f);
    SetStack(stack, argc);
    return 1;
}

/**
 *
 * Writes a float holding a random integer below the requested range.
 *
 */
int _GET_RNDF(dc2::script::RunArguments stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    float range = GetStackFloat(stack++);
    SetStack(stack, static_cast<float>(fptosi(range * static_cast<float>(rand()) / 2147483648.0f)));
    return 1;
}

namespace {
ScriptVariable *MonsterVariable(int index) {
    if (index < 0) {
        return nullptr;
    }
    if (index < MONSTER_VAR_MAX) {
        return nowMonster != nullptr ? &nowMonster->script_vars[index] : nullptr;
    }
    const int shared_index = index - MONSTER_VAR_MAX;
    return ActiveMonster != nullptr && shared_index < MONSTER_SHARE_MAX
               ? &ActiveMonster->shared_script_vars[shared_index]
               : nullptr;
}

ScriptVariable *SecondaryMonsterVariable(int index) {
    return nowMonster != nullptr && index >= 0 && index < MONSTER_VAR2_MAX
               ? &nowMonster->secondary_script_vars[index]
               : nullptr;
}
} // namespace

/**
 *
 * Stores an integer or float in a monster-local or shared script variable.
 *
 */
int _V_PUSH(dc2::script::RunArguments stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    ScriptVariable *variable = MonsterVariable(dc2::script::RunInteger(stack++));
    if (variable == nullptr) {
        return 0;
    }
    switch (stack.At().type) {
        case RS_INT:
            variable->i = dc2::script::RunInteger(stack);
            return 1;
        case RS_FLOAT:
            variable->f = dc2::script::RunFloat(stack);
            return 1;
        default:
            return 0;
    }
}

/**
 *
 * Reads a monster-local or shared script variable into an output slot.
 *
 */
int _V_POP(dc2::script::RunArguments stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    ScriptVariable *variable = MonsterVariable(dc2::script::RunInteger(stack++));
    if (variable == nullptr) {
        return 0;
    }
    RS_STACKDATA &output = dc2::script::RunOutput(stack);
    switch (output.type) {
        case RS_INT:
            output.val.i = variable->i;
            return 1;
        case RS_FLOAT:
            output.val.f = variable->f;
            return 1;
        default:
            return 0;
    }
}

/**
 *
 * Stores an integer or float in the active monster secondary variable table.
 *
 */
int _V_PUSH2(dc2::script::RunArguments stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    ScriptVariable *variable = SecondaryMonsterVariable(dc2::script::RunInteger(stack++));
    if (variable == nullptr) {
        return 0;
    }
    switch (stack.At().type) {
        case RS_INT:
            variable->i = dc2::script::RunInteger(stack);
            return 1;
        case RS_FLOAT:
            variable->f = dc2::script::RunFloat(stack);
            return 1;
        default:
            return 0;
    }
}

/**
 *
 * Reads an active monster secondary variable into an output slot.
 *
 */
int _V_POP2(dc2::script::RunArguments stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    ScriptVariable *variable = SecondaryMonsterVariable(dc2::script::RunInteger(stack++));
    if (variable == nullptr) {
        return 0;
    }
    RS_STACKDATA &output = dc2::script::RunOutput(stack);
    switch (output.type) {
        case RS_INT:
            output.val.i = variable->i;
            return 1;
        case RS_FLOAT:
            output.val.f = variable->f;
            return 1;
        default:
            return 0;
    }
}

/**
 *
 * Sets the battle area lock-on mode.
 *
 */
int _SET_LOCKON_MODE(dc2::script::RunArguments stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    s16 v = static_cast<s16>(GetStackInt(stack));
    nowScene->battle_area.lock_on_mode = v;
    return 1;
}

/**
 *
 * Writes the number of active monsters.
 *
 */
int _GET_MONSTER_NUM(dc2::script::RunArguments stack, int argc) {
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
int _GET_DIST(dc2::script::RunArguments stack, int argc) {
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
int _SET_OBJ(dc2::script::RunArguments stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int   index = GetStackInt(stack++);
    char *name = GetStackString(stack);
    return nowMonster->EntryObject(name, index) != nullptr;
}

/**
 *
 * Prints the body command diagnostic.
 *
 */
int _SET_BODY(dc2::script::RunArguments stack, int argc) {
    dc2::log::PrintGame("NOT FOUND (_SET_BODY)\n");
    return 1;
}

/**
 *
 * Prints the damage command diagnostic.
 *
 */
int _SET_DMG(dc2::script::RunArguments stack, int argc) {
    dc2::log::PrintGame("NOT FOUND (_SET_DMG)\n");
    return 1;
}

/**
 *
 * Registers a damage hit using named motion and entry-object frames.
 *
 */
int _SET_DMG2(dc2::script::RunArguments stack, int argc) {
    float               pos[4];
    mgCFrame           *frame_a = {};
    mgCFrame           *frame_b = {};
    CHARA_ENTRY_OBJECT *object = {};
    const auto          hit_argument = stack++;
    GetStackString(hit_argument);
    float power = 2.0f * GetStackFloat(stack++);
    char *motion = GetStackString(stack++);
    float start_ratio = GetStackFloat(stack++);
    float end_ratio = GetStackFloat(stack++);
    int   index_a = GetStackInt(stack++);
    int   index_b = -1;

    if (argc == 7) {
        index_b = GetStackInt(stack);
    }

    frame_b = nullptr;
    object = nowMonster->GetEntryObjectPos(CHARA_ENTRY_GROUP_DAMAGE, index_a, pos);

    if (object == nullptr) {
        return 0;
    }

    frame_a = object->frame;

    if (power <= 0.0f) {
        power = object->size;
    }

    if (index_b >= 0) {
        object = nowMonster->GetEntryObjectPos(CHARA_ENTRY_GROUP_DAMAGE, index_b, pos);

        if (object != nullptr) {
            frame_b = object->frame;
        }
    }

    LastCInfo2 = nowMonster->EntryDamage2(frame_a, frame_b, dc2::script::RunRetainedText(hit_argument), power, motion, start_ratio, end_ratio, {});
    return LastCInfo2 != nullptr;
}

/**
 *
 * Writes the world position of a named character object.
 *
 */
int _GET_OBJ_POS(dc2::script::RunArguments stack, int argc) {
    float         pos[4];
    char         *object_name = {};
    mgCFrame     *object = nullptr;
    CActionChara *chara = {};
    char         *chara_name = {};

    if (argc < 4 || argc > 5) {
        return 0;
    }

    object_name = GetStackString(stack++);
    chara_name = nullptr;

    if (argc == 5) {
        chara_name = GetStackString(stack + 3);
    }

    if (argc == 5) {
        chara = nowMonster->SearchChara(chara_name);

        if (chara != nullptr) {
            object = chara->SearchObject(object_name);
        }
    } else {
        object = nowMonster->SearchObject(object_name);
    }

    if (object == nullptr) {
        return 0;
    }

    object->GetWorldPosition0(pos);
    SetOutputVector(stack, {pos[0], pos[1], pos[2]});
    stack = stack + 2;
    return 1;
}

/**
 *
 * Writes the world position of a named frame on the linked map piece.
 *
 */
int _GET_MAPOBJ_POS(dc2::script::RunArguments stack, int argc) {
    float pos[4];

    if (argc != 4 || nowMonster == nullptr) {
        return 0;
    }

    const auto name = dc2::script::RunText(stack++);
    if (!nowMonster->map_link.GetFrameWorldPosition(name, pos)) {
        return 0;
    }

    SetOutputVector(stack, {pos[0], pos[1], pos[2]});
    stack = stack + 2;
    return 1;
}

/**
 *
 * Links the active monster to a named map part.
 *
 */
int _LINK_MAP_TO_OBJECT(dc2::script::RunArguments stack, int argc) {
    if (argc != 1 || nowMonster == nullptr) {
        return 0;
    }

    return nowMonster->map_link.BindPart(dc2::dungeon::MainMap(), dc2::script::RunText(stack));
}

/**
 *
 * Links the active monster to a named piece of a map part.
 *
 */
int _LINK_OBJECT_TO_PIECE(dc2::script::RunArguments stack, int argc) {
    if (argc != 2 || nowMonster == nullptr) {
        return 0;
    }

    const auto part_name = dc2::script::RunText(stack++);
    return nowMonster->map_link.BindPiece(dc2::dungeon::MainMap(), part_name, dc2::script::RunText(stack));
}

/**
 *
 * Configures the active monster scoop trigger or motion interval.
 *
 */
int _SET_SCOOP(dc2::script::RunArguments stack, int argc) {
    if (argc != 1 && argc != 4) {
        return 0;
    }
    if (argc == 1) {
        const int number = GetStackInt(stack);
        nowMonster->scoop.type = 2;
        nowMonster->scoop.no = number;
        return 1;
    }
    const auto motion_argument = stack++;
    GetStackString(motion_argument);
    const float start = GetStackFloat(stack++);
    const float end = GetStackFloat(stack++);
    const int   number = GetStackInt(stack);
    const auto  motion = dc2::script::RunRetainedText(motion_argument);
    nowMonster->scoop.motion = motion;
    nowMonster->scoop.start = start;
    nowMonster->scoop.end = end;
    nowMonster->scoop.no = number;
    nowMonster->scoop.type = 1;
    return 1;
}

/**
 *
 * Loads an image file into one of the active monster reserved image slots.
 *
 */
int _LOAD_RESERV_IMG(dc2::script::RunArguments stack, int argc);

/**
 *
 * Sets the active monster priority limit within its supported range.
 *
 */
int _SET_PRIORITY_LIMMIT(dc2::script::RunArguments stack, int argc) {
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
int _GET_PLACE_POS(dc2::script::RunArguments stack, int argc) {
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
int _SET_PLACE_POS(dc2::script::RunArguments stack, int argc) {
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
int _SEARCH_AREA(dc2::script::RunArguments stack, int argc) {
    if (argc != 3) {
        return 0;
    }

    float         distance = GetStackFloat(stack++);
    float         angle = GetStackFloat(stack++);
    sceVu0FVECTOR dir = {0.0f, 0.0f, 1.0f, 0.0f};
    float         pos[4];
    float         rot[4];
    float         matrix[4][4];
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
int _SEARCH_AREA2(dc2::script::RunArguments stack, int argc) {
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
int _SET_MODEL_LIGHT_SWITCH(dc2::script::RunArguments stack, int argc) {
    mgCFrame     *frame = {};
    char         *name = {};
    int           flag = {};
    mgCFrameAttr *attr = {};

    if (argc <= 0 || argc > 2) {
        return 0;
    }

    flag = GetStackInt(stack++);
    name = nullptr;

    if (argc == 2) {
        name = GetStackString(stack);
    }

    frame = nowMonster->CObjectFrame::frame;

    if (name != nullptr) {
        frame = frame->SearchFrame(name);
    }

    if (frame == nullptr) {
        return 0;
    }

    attr = frame->attr;

    if (flag != 0) {
        attr->no_light = 0;
        frame->SetAttrParam(*attr, 1, MG_FRAME_ATTR_NO_LIGHT);
    } else {
        attr->no_light = 1;
        attr->color[0] = 128.0f;
        attr->color[1] = 128.0f;
        attr->color[2] = 128.0f;
        attr->color[3] = 128.0f;
        frame->SetAttrParam(*attr, 1, MG_FRAME_ATTR_NO_LIGHT | MG_FRAME_ATTR_COLOR);
    }

    return 1;
}

/**
 *
 * Sets model lighting color on the root or a named frame.
 *
 */
int _SET_MODEL_LIGHT_COLOR(dc2::script::RunArguments stack, int argc) {
    mgCFrame     *frame = {};
    char         *name = {};
    mgCFrameAttr *attr = {};
    float         red = {};
    float         green = {};
    float         blue = {};
    float         alpha = {};

    if (argc < 4 || argc > 5) {
        return 0;
    }

    name = nullptr;
    red = GetStackFloat(stack++);
    green = GetStackFloat(stack++);
    blue = GetStackFloat(stack++);
    alpha = GetStackFloat(stack++);

    if (argc == 5) {
        name = GetStackString(stack);
    }

    frame = nowMonster->CObjectFrame::frame;

    if (name != nullptr) {
        frame = frame->SearchFrame(name);
    }

    if (frame == nullptr) {
        return 0;
    }

    attr = frame->attr;
    attr->no_light = 1;
    attr->color[0] = red;
    attr->color[1] = green;
    attr->color[2] = blue;
    attr->color[3] = alpha;
    frame->SetAttrParam(*attr, 1, MG_FRAME_ATTR_COLOR);
    return 1;
}

/**
 *
 * Scales active monster defense from its table value.
 *
 */
int _SET_DEF_RATE(dc2::script::RunArguments stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    float           rate = GetStackFloat(stack);
    CActiveMonster *self = nowMonster;
    u32             base = self->tbl->defense;
    self->defense = fptoui(static_cast<float>(base) * rate);
    return 1;
}

/**
 *
 * Writes the active monster position to three output slots.
 *
 */
int _GET_POS(dc2::script::RunArguments stack, int argc) {
    float pos[4];

    if (argc != 3) {
        return 0;
    }

    nowMonster->GetPosition(pos);
    SetOutputVector(stack, {pos[0], pos[1], pos[2]});
    stack = stack + 2;
    return 1;
}

/**
 *
 * Teleports the active monster to a script position.
 *
 */
int _SET_POS(dc2::script::RunArguments stack, int argc) {
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
int _GET_ROT(dc2::script::RunArguments stack, int argc) {
    float rot[4];

    if (argc < 3 || argc > 4) {
        return 0;
    }

    if (argc == 4) {
        int           id = GetStackInt(stack++);
        CActionChara *chara = static_cast<CActionChara *>(nowScene->GetCharacter(id + 24));

        if (chara == nullptr) {
            return 0;
        }

        chara->GetRotation(rot);
    } else {
        nowMonster->GetRotation(rot);
    }

    SetOutputVector(stack, {rot[0], rot[1], rot[2]});
    stack = stack + 2;
    return 1;
}

/**
 *
 * Sets active monster rotation and clears its turn speed.
 *
 */
int _SET_ROT(dc2::script::RunArguments stack, int argc) {
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
int _SET_NEXT_ROT(dc2::script::RunArguments stack, int argc) {
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
int _SET_NEXT_POS(dc2::script::RunArguments stack, int argc) {
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
int _CHK_MOVE_END(dc2::script::RunArguments stack, int argc) {
    float pos[4];
    int   arrived = {};

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
int _RESET_MOVE(dc2::script::RunArguments stack, int argument_count) {
    nowMonster->move_speed = 0.0f;
    return 1;
}

/**
 *
 * Writes the target position and optionally its distance from the monster.
 *
 */
int _GET_TARGET_POS(dc2::script::RunArguments stack, int argc) {
    float pos[4];
    float self_pos[4];

    if (argc < 3 || argc > 4) {
        return 0;
    }

    CActionChara *target = static_cast<CActionChara *>(nowScene->GetCharacter(nowMonster->target_no));

    if (target == nullptr) {
        return 0;
    }

    target->GetPosition(pos);
    SetOutputVector(stack, {pos[0], pos[1], pos[2]});
    stack = stack + 3;

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
int _GET_TARGET_DIST(dc2::script::RunArguments stack, int argc) {
    float target_pos[4];
    float self_pos[4];

    if (argc != 1) {
        return 0;
    }

    CActionChara *target = static_cast<CActionChara *>(nowScene->GetCharacter(nowMonster->target_no));

    if (target == nullptr) {
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
int _GET_TARGET_ANGLE(dc2::script::RunArguments stack, int argc) {
    float delta[4];
    float self_pos[4];

    if (argc != 1) {
        return 0;
    }

    CActionChara *target = static_cast<CActionChara *>(nowScene->GetCharacter(nowMonster->target_no));

    if (target == nullptr) {
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
int _GET_TARGET_REF_POS(dc2::script::RunArguments stack, int argc) {
    float matrix[4][4];
    float pos[4];

    float offset[4];

    if (argc != 5) {
        return 0;
    }

    float         angle = GetStackFloat(stack++);
    float         distance = GetStackFloat(stack++);
    CActionChara *target = static_cast<CActionChara *>(nowScene->GetCharacter(nowMonster->target_no));

    if (target == nullptr) {
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
    SetOutputVector(stack, {pos[0], pos[1], pos[2]});
    stack = stack + 2;
    return 1;
}

/**
 *
 * Classifies a point as ahead, behind, left, or right of the monster.
 *
 */
int _GET_REF_DIR(dc2::script::RunArguments args, int argc) {
    sceVu0FVECTOR target_position;
    sceVu0FVECTOR position;
    sceVu0FVECTOR front;
    float         distance = {};
    float         front_angle = {};
    int           direction = {};

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

    if (angle < -PI) {
        angle += TWO_PI;
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
int _GET_REFANGLE_POS(dc2::script::RunArguments stack, int argc) {
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
    SetOutputVector(stack, {pos[0], pos[1], pos[2]});
    stack = stack + 2;
    return 1;
}

/**
 *
 * Writes the horizontal angle from the monster toward a script position.
 *
 */
int _GET_REF_ANGLE(dc2::script::RunArguments stack, int argc) {
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
int _GET_HIGH(dc2::script::RunArguments stack, int argc) {
    float height = {};

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
int _GET_ACTIVE_MONS_POS(dc2::script::RunArguments stack, int argc) {
    float pos[4];
    float self_pos[4];

    if (argc < 4 || argc > 5) {
        return 0;
    }

    int id = GetStackInt(stack++);
    id -= 24;
    CActionChara *monster = ActiveMonster->GetActiveMonster(id);

    if (monster == nullptr) {
        return 0;
    }

    monster->GetPosition(pos);
    SetOutputVector(stack, {pos[0], pos[1], pos[2]});
    stack = stack + 3;

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
int _GET_ACTIVE_MONS_ROT(dc2::script::RunArguments stack, int argc) {
    float rot[4];

    if (argc != 4) {
        return 0;
    }

    int id = GetStackInt(stack++);
    id -= 24;
    CActionChara *monster = ActiveMonster->GetActiveMonster(id);

    if (monster == nullptr) {
        return 0;
    }

    monster->GetRotation(rot);
    SetOutputVector(stack, {rot[0], rot[1], rot[2]});
    stack = stack + 2;
    return 1;
}

/**
 *
 * Writes the distance to a selected active monster.
 *
 */
int _GET_ACTIVE_MONS_DIST(dc2::script::RunArguments stack, int argc) {
    float self_pos[4];
    float other_pos[4];

    if (argc != 2) {
        return 0;
    }

    int id = GetStackInt(stack++);
    id -= 24;
    CActionChara *other = ActiveMonster->GetActiveMonster(id);

    if (other == nullptr) {
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
int _GET_ACTIVE_MONS_ANGLE(dc2::script::RunArguments stack, int argc) {
    float rot[4];

    if (argc != 2) {
        return 0;
    }

    int id = GetStackInt(stack++);
    id -= 24;
    CActionChara *monster = ActiveMonster->GetActiveMonster(id);

    if (monster == nullptr) {
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
int _GET_REF_ROT(dc2::script::RunArguments stack, int argc) {
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
int _GET_REF_ROT2(dc2::script::RunArguments stack, int argc) {
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
int _FLYING_SEARCH_AREA(dc2::script::RunArguments stack, int argc) {
    if (argc != 3) {
        return 0;
    }

    float         distance = GetStackFloat(stack++);
    float         angle = GetStackFloat(stack++);
    sceVu0FVECTOR dir = {0.0f, 0.0f, 1.0f, 0.0f};
    float         pos[4];
    float         rot[4];
    float         matrix[4][4];
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
static int _GET_HIGH2(dc2::script::RunArguments args, int argc) {
    CCPoly        polygons[128];
    sceVu0FVECTOR position;
    sceVu0FVECTOR hit_position;
    mgVu0FBOX     box{};
    sceVu0FVECTOR ray_start;
    sceVu0FVECTOR ray_end;
    CMap         *map = {};
    int           count = {};
    float         height_difference = {};

    if (argc != 4) {
        return 0;
    }

    GetStackVector(position, &args);
    map = nowScene->GetMap(nowScene->active_map);

    if (map == nullptr) {
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
int _GET_RANGE_MONS_ID(dc2::script::RunArguments stack, int argc) {
    RangeEntry  entries[24];
    float       self_pos[4];
    float       other_pos[4];
    int         i = {};
    int         j = {};
    int         count = {};
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
        CActiveMonster *other = {};

        if ((other = static_cast<CActiveMonster *>(nowScene->GetCharacter(i + 24))) != nullptr &&
            other->chara_kind == ACTION_KIND_SCRIPT && nowMonster->chara_type != other->chara_type) {
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
int _GET_ENTRY_OBJ_POS(dc2::script::RunArguments stack, int argc) {
    float pos[4];

    if (argc != 5) {
        return 0;
    }

    int          id = GetStackInt(stack++);
    int          entry_index = GetStackInt(stack++);
    CCharacter2 *monster = {};

    if (id != -1) {
        id -= 24;
        monster = ActiveMonster->GetActiveMonster(id);

        if (monster == nullptr) {
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
int _BLOW_START(dc2::script::RunArguments stack, int argc) {
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
int _SET_ACT_STATUS(dc2::script::RunArguments stack, int argc) {
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
int _SET_INT_FLAG(dc2::script::RunArguments stack, int argc) {
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
int _SET_DEAD_START(dc2::script::RunArguments args, int argc) {
    sceVu0FVECTOR     position;
    sceVu0FVECTOR     velocity;
    int               total = {};
    CBattleCharaInfo *battle = {};
    int               i = {};
    int               large_coin = {};
    CPalletAnime     *pallet = {};
    BASE_MONSTER_TBL *table = {};
    float             money_rate = {};
    int               roll = {};
    int               drop_index = {};
    int               drop_second = {};

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

    if (nowMonster->last_hit_attr & WEAPON_SPECIAL_WEALTH) {
        money_rate += 0.3f;
    }

    if (nowMonster->last_hit_attr & WEAPON_SPECIAL_LESS_MONEY) {
        money_rate -= 0.3f;
    }

    total = static_cast<int>(reward * money_rate);
    large_coin = static_cast<int>(0.7f * total);
    large_coin += (total - large_coin) % 5;

    if (large_coin > 0) {
        CPullItem *item = PullItemMan.GetList(2);

        if (item != nullptr) {
            velocity[1] = 4.0f;
            velocity[2] = 0.0f;
            velocity[3] = 1.0f;
            velocity[0] = 0.0f;
            item->SetItem(position, velocity, PULL_ITEM_MONEY_LARGE);
            item->item_no = large_coin;
        }
    }

    dc2::log::PrintGame("total = %d (%d)\n", total, large_coin);
    dc2::log::PrintGame("num = %d (%d)\n", 5, (total - large_coin) / 5);

    for (i = 0; i < 5; i++) {
        CPullItem *item = PullItemMan.GetList(2);

        if (item != nullptr) {
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

        if (item != nullptr) {
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

            if (item != nullptr) {
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

        if (item != nullptr) {
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
 *
 * Creates monster death effects and weapon experience pickups.
 *
 */
int _SET_DEAD_OFF(dc2::script::RunArguments args, int argc) {
    sceVu0FVECTOR position;
    sceVu0FVECTOR velocity;
    CDeadEffect  *effect = {};
    float         radius = {};
    float         height = {};
    float         size = {};
    float         growth = {};
    int           last_chara = {};
    int           last_source = {};
    int           experience = {};
    int           pickup_count = {};
    int           i = {};

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

    if ((nowMonster->attrib & MONSTER_ATTRIB_NO_DEAD_EFFECT) == 0) {
        effect = BattleFX.NextDead();

        if (effect != nullptr) {
            effect->SetDeadEffect(position, radius, height, size, 35);
        }

        effect = BattleFX.NextDead();

        if (effect != nullptr) {
            effect->SetDeadEffect(position, 0.5f * radius, 0.5f * height, size, 35);
        }
    }

    last_chara = nowMonster->last_hit_chara;
    last_source = nowMonster->last_hit_source;
    experience = nowMonster->reward_exp;
    pickup_count = 0;

    if (nowMonster->last_hit_attr & WEAPON_SPECIAL_ABS_UP) {
        float bonus = 1.2f;
        experience = static_cast<int>(static_cast<float>(experience) * bonus);
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

    growth = static_cast<float>(experience) / static_cast<float>(pickup_count);

    for (i = 0; i < pickup_count; i++) {
        CPullItem *item = PullItemMan.GetList(2);

        if (item != nullptr) {
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
int _SET_SHROW_END(dc2::script::RunArguments stack, int argument_count) {
    if (argument_count != 0) {
        return 0;
    }

    nowMonster->catch_state = ACTION_CATCH_NONE;
    return 1;
}

/**
 *
 * Starts a named monster motion with optional step and mode.
 *
 */
int _SET_MOS(dc2::script::RunArguments stack, int argc) {
    auto  next = stack;
    int   flag = 0;
    char *name = nullptr;
    float step = -1.0f;

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

    if (name == nullptr) {
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
int _CHECK_MOS_END(dc2::script::RunArguments stack, int argc) {
    int   result{};
    char *name = {};

    if (argc == 1) {
        result = nowMonster->CheckMotionEnd(nullptr);
    }

    if (argc == 2) {
        name = GetStackString(stack + 1);

        if (name == nullptr) {
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
int _NOW_MOS_WAIT(dc2::script::RunArguments stack, int argc) {
    float wait{};

    if (argc == 1) {
        wait = nowMonster->GetNowFrameWait(nullptr);
    }

    if (argc == 2) {
        char *name = GetStackString(stack + 1);

        if (name == nullptr) {
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
int _GET_MOS_STATUS(dc2::script::RunArguments stack, int argc) {
    int status{};

    if (argc == 1) {
        status = nowMonster->GetMotionStatus(nullptr);
    }

    if (argc == 2) {
        char *name = GetStackString(stack + 1);

        if (name == nullptr) {
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
int _SET_MUTEKI(dc2::script::RunArguments stack, int argc) {
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
int _GET_GEKIRIN(dc2::script::RunArguments stack, int argc) {
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
int _GET_USER_MONS_ID(dc2::script::RunArguments stack, int argc) {
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
int _GET_PRIORITY(dc2::script::RunArguments stack, int argc) {
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
int _CREATE_MONSTER(dc2::script::RunArguments args, int argc) {
    sceVu0FVECTOR position;
    sceVu0FVECTOR rotation;
    int           id = {};

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

    int index = {};

    if ((index = ActiveMonster->SearchBaseIndex(id)) <= -1) {
        return 0;
    }

    CActiveMonster *monster = ActiveMonster->SetActiveMonster(index, position, rotation, -1);
    dc2::log::PrintGame("mons_index = %d\n", index);
    return monster != nullptr;
}

/**
 *
 * Sets the active monster clip distance from a script scale.
 *
 */
int _SET_CLIP_DIST(dc2::script::RunArguments stack, int argc) {
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
int _SET_COLLISION(dc2::script::RunArguments stack, int argc) {
    return 0;
}

/**
 *
 * Rejects the gravity configuration opcode without changing monster state.
 *
 */
int _SET_GRAVITY(dc2::script::RunArguments stack, int argc) {
    return 0;
}

/**
 *
 * Sets or clears active monster attribute bits selected by a mask.
 *
 */
int _SET_ATTRIB(dc2::script::RunArguments stack, int argc) {
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
int _GET_SCALE(dc2::script::RunArguments stack, int argc) {
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
int _GET_MONS_WIDTH(dc2::script::RunArguments stack, int argc) {
    if (argc != 1 || nowMonster == nullptr) {
        return 0;
    }

    float width = nowMonster->mons_move_check.radius;
    SetStack(stack, static_cast<float>(width <= 0.0 ? 15.0 : width));
    return 1;
}

/**
 *
 * Creates a named effect for this monster and optionally returns its slot.
 *
 */
int _ESM_CREATE(dc2::script::RunArguments stack, int argc) {
    char *name = GetStackString(stack++);
    int   group = nowMonster->chara_type;
    int   slot = {};

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
int _ESM_FINISH(dc2::script::RunArguments stack, int argc) {
    int effect_id = nowMonster->chara_type;
    return ActiveMonster->effect_man->SetScriptProgNo(EFFECT_SCRIPT_PROG_FINISH, effect_id, GetStackInt(stack));
}

/**
 *
 * Deletes an effect from this monster effect slot.
 *
 */
int _ESM_DELETE(dc2::script::RunArguments stack, int argc) {
    int effect_id = nowMonster->chara_type;
    return ActiveMonster->effect_man->DeleteEffSpt(effect_id, GetStackInt(stack));
}

/**
 *
 * Sets the first effect script vector for this monster.
 *
 */
int _ESM_SET_VECT1(dc2::script::RunArguments stack, int argc) {
    sceVu0FVECTOR vector;
    int           slot = GetStackInt(stack++);
    vector[0] = GetStackFloat(stack++);
    vector[1] = GetStackFloat(stack++);
    vector[2] = GetStackFloat(stack);
    vector[3] = 1.0f;
    int monster_type = nowMonster->chara_type;
    int group = monster_type;
    return ActiveMonster->effect_man->SetScriptVect1(vector, group, slot);
}

/**
 *
 * Writes the first effect script vector to output slots.
 *
 */
int _ESM_GET_VECT1(dc2::script::RunArguments stack, int argc) {
    sceVu0FVECTOR vector;

    if (argc != 4) {
        return 0;
    }

    int slot = GetStackInt(stack++);
    int monster_type = nowMonster->chara_type;
    int group = monster_type;
    int result = ActiveMonster->effect_man->GetScriptVect1(vector, group, slot);
    SetOutputVector(stack, {vector[0], vector[1], vector[2]});
    stack = stack + 2;
    return result;
}

/**
 *
 * Sets the second effect script vector for this monster.
 *
 */
int _ESM_SET_VECT2(dc2::script::RunArguments stack, int argc) {
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
 *
 * Writes the second effect script vector to output slots.
 *
 */
int _ESM_GET_VECT2(dc2::script::RunArguments stack, int argc) {
    sceVu0FVECTOR vector;

    if (argc != 4) {
        return 0;
    }

    int slot = GetStackInt(stack++);
    int monster_type = nowMonster->chara_type;
    int group = monster_type;
    int result = ActiveMonster->effect_man->GetScriptVect2(vector, group, slot);
    SetOutputVector(stack, {vector[0], vector[1], vector[2]});
    stack = stack + 2;
    return result;
}

/**
 *
 * Sets an effect target identifier for this monster.
 *
 */
int _ESM_SET_TARGET_ID(dc2::script::RunArguments stack, int argc) {
    int slot = GetStackInt(stack++);
    int id = GetStackInt(stack);
    int monster_type = nowMonster->chara_type;
    int group = monster_type;
    return ActiveMonster->effect_man->SetScriptTargetId(id, group, slot);
}

/**
 *
 * Writes an effect target identifier and returns the manager lookup status.
 *
 */
int _ESM_GET_TARGET_ID(dc2::script::RunArguments stack, int argc) {
    int id = {};
    int slot = GetStackInt(stack++);
    int monster_type = nowMonster->chara_type;
    int group = monster_type;
    int result = ActiveMonster->effect_man->GetScriptTargetId(id, group, slot);
    SetStack(stack, id);
    return result;
}

/**
 *
 * Sets an effect user identifier for this monster.
 *
 */
int _ESM_SET_USER_ID(dc2::script::RunArguments stack, int argc) {
    int slot = GetStackInt(stack++);
    int id = GetStackInt(stack);
    int monster_type = nowMonster->chara_type;
    int group = monster_type;
    return ActiveMonster->effect_man->SetScriptUserId(id, group, slot);
}

/**
 *
 * Writes an effect user identifier to an output slot.
 *
 */
int _ESM_GET_USER_ID(dc2::script::RunArguments stack, int argc) {
    int id = {};
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
int _ESM_SET_VALUE(dc2::script::RunArguments stack, int argc) {
    int slot = {};
    int index = {};
    int group = {};
    int result = {};

    group = nowMonster->chara_type;
    slot = GetStackInt(stack++);
    index = GetStackInt(stack++);

    switch (stack.At().type) {
        case RS_INT:
            result =
                ActiveMonster->effect_man->SetValue(index, GetStackInt(stack), group, slot);
            break;
        case RS_FLOAT:
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
int _LOAD_EFFECT_SCRIPT(dc2::script::RunArguments stack, int argc) {
    int        result = {};
    int        level = {};
    mgCMemory *memory = {};
    FxScriptMan->level = 3;
    level = -1;
    memory = nowScene->GetStack(3);

    switch (stack.At().type) {
        case RS_INT: {
            int base_no = GetStackInt(stack++);

            if (argc >= 2) {
                level = GetStackInt(stack++);
            }

            result = ActiveMonster->effect_man->LoadBaseEffSpt(base_no, memory, level);
            break;
        }
        case RS_STR: {
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
int _SW_EFFECT(dc2::script::RunArguments stack, int argc) {
    if (argc != 9) {
        return 0;
    }

    const auto        arguments = stack;
    ACTION_SW_EFFECT *effect = nowMonster->GetSwEffectPtr();

    if (effect == nullptr) {
        return 0;
    }

    int index = GetStackInt(stack++);

    if (index < 0 || index > 2) {
        return 0;
    }

    if (nowMonster->sword_effect[index] == nullptr) {
        return 0;
    }

    GetStackString(stack++);
    float start_frame = GetStackFloat(stack++);
    float end_frame = GetStackFloat(stack++);
    GetStackString(stack++);
    GetStackString(stack++);
    int        arg_a = GetStackInt(stack++);
    int        arg_c = GetStackInt(stack++);
    int        arg_b = GetStackInt(stack);
    const auto owned_motion = dc2::script::RunRetainedText(arguments + 1);
    const auto owned_start = dc2::script::RunRetainedText(arguments + 4);
    const auto owned_end = dc2::script::RunRetainedText(arguments + 5);
    effect->sword_no = index;
    effect->motion = owned_motion;
    effect->start = start_frame;
    effect->end = end_frame;
    effect->frame0 = owned_start;
    effect->frame1 = owned_end;
    effect->length = arg_a;
    effect->hold_time = arg_c;
    effect->fade_time = arg_b;
    effect->wait = 0;
    nowMonster->sw_effect_num = static_cast<s8>(std::max(std::clamp(static_cast<int>(nowMonster->sw_effect_num), 0, static_cast<int>(ACTION_SW_EFFECT_MAX)),
                                                         static_cast<int>(effect - nowMonster->sw_effect) + 1));
    return 1;
}

/**
 *
 * Writes an unused texture block number from the effect manager.
 *
 */
int _ESM_GET_NOTUESD_TEXB(dc2::script::RunArguments stack, int argc) {
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
int _ESM_ADD_TEXB(dc2::script::RunArguments stack, int argc) {
    ActiveMonster->effect_man->AddTexb();
    return 1;
}

/**
 *
 * Launches a monster rocket with position, direction, optional homing, and damage.
 *
 */
int _SHOT_ROCKET_LAUNCHER(dc2::script::RunArguments args, int argc) {
    sceVu0FVECTOR position;
    sceVu0FVECTOR target;
    sceVu0FVECTOR direction;
    float         speed = {};
    int           damage = {};
    int           homing_delay = {};
    int           homing_time = {};

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

    if (rocket != nullptr) {
        rocket->SetPos(position, target, direction);
        rocket->target_chara = 0;
        rocket->speed = speed;
        rocket->homing_delay = homing_delay;
        rocket->homing_time = homing_time;
        CColPrim *primitive = ColPrimMan.GetPrim();
        int       primitive_id = -1;

        if (primitive != nullptr) {
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
int _RUN_EVENT_SCRIPT(dc2::script::RunArguments stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    s16 v = static_cast<s16>(GetStackInt(stack));
    nowMonster->event_no = v;
    return 1;
}

/**
 *
 * Sets or clears character status bits for the active monster in the scene.
 *
 */
int _SET_STATUS(dc2::script::RunArguments stack, int argc) {
    int  status = {};
    auto next = stack + 1;
    status = GetStackInt(stack);
    int enable = 1;

    if (argc >= 2) {
        enable = GetStackInt(next);
    }

    if (enable != 0) {
        nowScene->SetStatus(SCENE_DATA_CHARA, nowMonster->chara_type, status);
    } else {
        nowScene->ResetStatus(SCENE_DATA_CHARA, nowMonster->chara_type, status);
    }

    return 1;
}

/**
 *
 * Sets or clears battle-area pause bits selected by a mask.
 *
 */
int _SET_PAUSE(dc2::script::RunArguments stack, int argc) {
    auto             next = stack;
    DNG_BATTLE_AREA *pause = &nowScene->battle_area;
    next = stack + 1;

    if (pause == nullptr) {
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
int _CHECK_PAUSE(dc2::script::RunArguments stack, int argument_count) {

    DNG_BATTLE_AREA *pause = &nowScene->battle_area;
    auto             output = stack + 1;

    if (pause == nullptr) {
        return 0;
    }

    int requested_flags = GetStackInt(stack);
    SetStack(output, static_cast<int>(pause->pause_flag & requested_flags));
    return 1;
}

/**
 *
 * Writes a persistent dungeon save flag value.
 *
 */
int _GET_BIT_FLAG(dc2::script::RunArguments stack, int argument_count) {
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
int _SET_BIT_FLAG(dc2::script::RunArguments stack, int argument_count) {
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
int _GET_ATT_TYPE(dc2::script::RunArguments stack, int argument_count) {
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
int _GET_USER_ATTR(dc2::script::RunArguments stack, int argument_count) {
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
int _TRANS_RESERV_IMG(dc2::script::RunArguments stack, int argument_count);

/**
 *
 * Writes active monster status attribute bits selected by a mask.
 *
 */
int _GET_STS_ATTR(dc2::script::RunArguments stack, int argument_count) {
    if (argument_count != 2) {
        return 0;
    }

    int mask = GetStackInt(stack++);
    SetStack(stack, static_cast<int>(nowMonster->status.attr & mask));
    return 1;
}

/**
 *
 * Marks the current monster stun time and updates its stun effect.
 *
 */
int _SET_PIYORI_MARK(dc2::script::RunArguments stack, int argument_count) {
    nowMonster->piyori_mark = nowMonster->piyori_time;
    nowMonster->piyori.Set(nowMonster, nowMonster->piyori_mark);
    return 1;
}

/**
 *
 * Writes the active monster stun mark value.
 *
 */
int _CHECK_PIYORI(dc2::script::RunArguments stack, int argument_count) {
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
int _GET_BASE_ATTACK(dc2::script::RunArguments stack, int argument_count) {
    SetStack(stack, nowMonster->attack);
    return 1;
}

/**
 *
 * Writes the nearest other monster position and distance.
 *
 */
int _GET_NEAR_MONS_POS(dc2::script::RunArguments stack, int argument_count) {
    float pos[4];
    float nearest_pos[4];
    float other_pos[4];
    float nearest_dist = -1.0f;
    int   i = {};

    nowMonster->GetPosition(pos);
    mgZeroVector(nearest_pos);

    for (i = 0; i < MONSTER_ACTIVE_MAX; i++) {
        CActiveMonster *other = {};

        if ((other = static_cast<CActiveMonster *>(nowScene->GetCharacter(i + 24))) != nullptr &&
            other->chara_kind == ACTION_KIND_SCRIPT && nowMonster->chara_type != other->chara_type) {
            other->GetPosition(other_pos);

            if (nearest_dist >= 0.0) {
                float dist = mgDistVector(pos, other_pos);

                if (dist < nearest_dist) {
                    nearest_dist = dist;
                    std::memmove(nearest_pos, other_pos, sizeof(u_long128));
                }
            } else {
                std::memmove(nearest_pos, other_pos, sizeof(u_long128));
                nearest_dist = mgDistVector(pos, nearest_pos);
            }
        }
    }

    SetOutputVector(stack, {nearest_pos[0], nearest_pos[1], nearest_pos[2]});
    stack = stack + 3;
    SetStack(stack, nearest_dist);
    return 1;
}

/**
 *
 * Sets the size value on a selected monster entry object.
 *
 */
int _SET_INDEXOBJ_SIZE(dc2::script::RunArguments stack, int argument_count) {
    if (argument_count != 2 ||
        (stack.At(0).type != RS_INT && stack.At(0).type != RS_FLOAT) ||
        (stack.At(1).type != RS_INT && stack.At(1).type != RS_FLOAT)) {
        return 0;
    }

    int   object_index = GetStackInt(stack++);
    float size = GetStackFloat(stack);

    if (object_index == -1) {
        object_index = 0;
    }

    if (nowMonster == nullptr || object_index < 0 || object_index >= CHARA_ENTRY_OBJECT_MAX) {
        return 0;
    }

    nowMonster->entry_object[object_index].size = size;
    return 1;
}

/**
 *
 * Writes the size value from a selected monster entry object.
 *
 */
int _GET_INDEXOBJ_SIZE(dc2::script::RunArguments stack, int argument_count);

/**
 *
 * Sets the current scene motion blur setting.
 *
 */
int _SET_MOTION_BLUR(dc2::script::RunArguments stack,
                     int                       argument_count) {
    if (argument_count != 1) {
        return 0;
    }

    nowScene->fade.blur_alpha = GetStackInt(stack);
    return 1;
}

/**
 *
 * Plays a sound from a selected monster sound bank.
 *
 */
int _MONS_SE_PLAY(dc2::script::RunArguments stack, int argument_count) {
    if (argument_count != 2) {
        return 0;
    }

    int monster_id = GetStackInt(stack++);
    int sound = GetStackInt(stack);
    monster_id -= 24;
    CActiveMonster *monster = ActiveMonster->GetActiveMonster(monster_id);

    if (monster == nullptr) {
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
int _MONS_SE_STOP(dc2::script::RunArguments stack, int argument_count) {
    if (argument_count != 2) {
        return 0;
    }

    int monster_id = GetStackInt(stack++);
    int sound = GetStackInt(stack);
    monster_id -= 24;
    CActiveMonster *monster = ActiveMonster->GetActiveMonster(monster_id);

    if (monster == nullptr) {
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
int _MONS_SE_LOOP(dc2::script::RunArguments stack, int argument_count) {
    if (argument_count != 3) {
        return 0;
    }

    int monster_id = GetStackInt(stack++);
    int sound = GetStackInt(stack++);
    int flags = GetStackInt(stack);
    monster_id -= 24;
    CActiveMonster *monster = ActiveMonster->GetActiveMonster(monster_id);

    if (monster == nullptr) {
        return 0;
    }

    monster->sound_info.loop_se->SeLoopPlayStop(static_cast<int>(monster->sound_info.se_bank), sound, flags, 13);
    return 1;
}

/**
 *
 * Sets whether active monster sounds use positional volume.
 *
 */
int _MONS_VOL_CTRL(dc2::script::RunArguments stack, int argument_count) {
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
int _SET_MAPOBJ_SHOW(dc2::script::RunArguments stack, int argument_count) {
    CMap      *maps[8];
    CMapParts *parts{};
    int        map_count = {};
    char      *parts_name = {};
    char      *piece_name{};
    CMapPiece *piece{};
    int        show = {};
    int        i = {};

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

        if (parts != nullptr) {
            break;
        }
    }

    if (parts == nullptr) {
        return 0;
    }

    if (argument_count == 3) {
        if ((piece = parts->SearchPiece(piece_name)) == nullptr) {
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
int SetMonsterScript(CRunScript *script, std::span<u8> program, mgCMemory *memory) {
    if (script == nullptr || memory == nullptr || program.empty() || memory->lock != 0) {
        return 0;
    }
    constexpr int stack_quadwords = (sizeof(RS_STACKDATA) * 128 + 15) / 16;
    constexpr int call_quadwords = (sizeof(RS_CALLDATA) * 512 + 15) / 16;
    if (dc2::memory::RemainingBytes(*memory).size() <=
        static_cast<std::size_t>(stack_quadwords + call_quadwords) * sizeof(u_long128)) {
        return 0;
    }
    auto *value_stack = dc2::memory::NewArray<RS_STACKDATA>(*memory, 128);
    auto *call_stack = dc2::memory::NewArray<RS_CALLDATA>(*memory, 512);
    if (value_stack == nullptr || call_stack == nullptr ||
        !script->load(program, std::span<RS_STACKDATA>(value_stack, 128), std::span<RS_CALLDATA>(call_stack, 512))) {
        return 0;
    }
    if (!script->BindRetainedTextArena(*memory, std::span(value_stack, 128))) {
        script->DeleteProgram();
        return false;
    }
    script->ext_func(ext_func, RS_MONSTER_EXT_LIMIT);
    return 1;
}

/**
 *
 * Associates monster script function numbers with their native callbacks.
 *
 */
static RS_EXTFUNC_INFO ext_func_info[] = {
    {dc2::script::AdaptRunArguments<_NORMAL_VECTOR>,            RS_MONSTER_EXT_NORMAL_VECTOR           },
    {dc2::script::AdaptRunArguments<_COPY_VECTOR>,              RS_MONSTER_EXT_COPY_VECTOR             },
    {dc2::script::AdaptRunArguments<_ADD_VECTOR>,               RS_MONSTER_EXT_ADD_VECTOR              },
    {dc2::script::AdaptRunArguments<_SUB_VECTOR>,               RS_MONSTER_EXT_SUB_VECTOR              },
    {dc2::script::AdaptRunArguments<_SCALE_VECTOR>,             RS_MONSTER_EXT_SCALE_VECTOR            },
    {dc2::script::AdaptRunArguments<_DIV_VECTOR>,               RS_MONSTER_EXT_DIV_VECTOR              },
    {dc2::script::AdaptRunArguments<_ANGLE_CMP>,                RS_MONSTER_EXT_ANGLE_CMP               },
    {dc2::script::AdaptRunArguments<_ANGLE_LIMIT>,              RS_MONSTER_EXT_ANGLE_LIMIT             },
    {dc2::script::AdaptRunArguments<_SQRT>,                     RS_MONSTER_EXT_SQRT                    },
    {dc2::script::AdaptRunArguments<_ATAN2F>,                   RS_MONSTER_EXT_ATAN2F                  },
    {dc2::script::AdaptRunArguments<_ND_TEST>,                  RS_MONSTER_EXT_ND_TEST                 },
    {dc2::script::AdaptRunArguments<_GET_DIST_VECTOR>,          RS_MONSTER_EXT_GET_DIST_VECTOR         },
    {dc2::script::AdaptRunArguments<_GET_DIST_VECTOR2>,         RS_MONSTER_EXT_GET_DIST_VECTOR2        },
    {dc2::script::AdaptRunArguments<_CALC_IP_CIRCLE_LINE>,      RS_MONSTER_EXT_CALC_IP_CIRCLE_LINE     },
    {dc2::script::AdaptRunArguments<_GET_ANGLE_INNER>,          RS_MONSTER_EXT_GET_ANGLE_INNER         },
    {dc2::script::AdaptRunArguments<_MY_SE_PLAY>,               RS_MONSTER_EXT_MY_SE_PLAY              },
    {dc2::script::AdaptRunArguments<_MY_SE_STOP>,               RS_MONSTER_EXT_MY_SE_STOP              },
    {dc2::script::AdaptRunArguments<_MONS_SE_PLAY>,             RS_MONSTER_EXT_MONS_SE_PLAY            },
    {dc2::script::AdaptRunArguments<_MONS_SE_STOP>,             RS_MONSTER_EXT_MONS_SE_STOP            },
    {dc2::script::AdaptRunArguments<_MONS_SE_LOOP>,             RS_MONSTER_EXT_MONS_SE_LOOP            },
    {dc2::script::AdaptRunArguments<_SET_CAMERA_NEXT_REF>,      RS_MONSTER_EXT_SET_CAMERA_NEXT_REF     },
    {dc2::script::AdaptRunArguments<_SET_CAMERA_FOLLOW>,        RS_MONSTER_EXT_SET_CAMERA_FOLLOW       },
    {dc2::script::AdaptRunArguments<_SET_CAMERA_NEXT_POS>,      RS_MONSTER_EXT_SET_CAMERA_NEXT_POS     },
    {dc2::script::AdaptRunArguments<_SET_CAMERA_MODE>,          RS_MONSTER_EXT_SET_CAMERA_MODE         },
    {dc2::script::AdaptRunArguments<_SET_CAMERA_SPEED>,         RS_MONSTER_EXT_SET_CAMERA_SPEED        },
    {dc2::script::AdaptRunArguments<_CAMERA_QUAKE>,             RS_MONSTER_EXT_CAMERA_QUAKE            },
    {dc2::script::AdaptRunArguments<_SET_CAMERA_CTRL_PARAM1>,   RS_MONSTER_EXT_SET_CAMERA_CTRL_PARAM1  },
    {dc2::script::AdaptRunArguments<_SET_CAMERA_CTRL_PARAM2>,   RS_MONSTER_EXT_SET_CAMERA_CTRL_PARAM2  },
    {dc2::script::AdaptRunArguments<_RESET_CAMERA_CTRL_PARAM>,  RS_MONSTER_EXT_RESET_CAMERA_CTRL_PARAM },
    {dc2::script::AdaptRunArguments<_GET_RND>,                  RS_MONSTER_EXT_GET_RND                 },
    {dc2::script::AdaptRunArguments<_GET_RNDF>,                 RS_MONSTER_EXT_GET_RNDF                },
    {dc2::script::AdaptRunArguments<_V_PUSH>,                   RS_MONSTER_EXT_V_PUSH                  },
    {dc2::script::AdaptRunArguments<_V_POP>,                    RS_MONSTER_EXT_V_POP                   },
    {dc2::script::AdaptRunArguments<_GET_MONSTER_NUM>,          RS_MONSTER_EXT_GET_MONSTER_NUM         },
    {dc2::script::AdaptRunArguments<_GET_MONSTER_INDEX>,        RS_MONSTER_EXT_GET_MONSTER_INDEX       },
    {dc2::script::AdaptRunArguments<_GET_MONSTER_ID>,           RS_MONSTER_EXT_GET_MONSTER_ID          },
    {dc2::script::AdaptRunArguments<_GET_USERID>,               RS_MONSTER_EXT_GET_USERID              },
    {dc2::script::AdaptRunArguments<_GET_USER_MONS_ID>,         RS_MONSTER_EXT_GET_USER_MONS_ID        },
    {dc2::script::AdaptRunArguments<_RESET_TIMER>,              RS_MONSTER_EXT_RESET_TIMER             },
    {dc2::script::AdaptRunArguments<_GET_TIMER>,                RS_MONSTER_EXT_GET_TIMER               },
    {dc2::script::AdaptRunArguments<_CREATE_MONSTER>,           RS_MONSTER_EXT_CREATE_MONSTER          },
    {dc2::script::AdaptRunArguments<_RUN_EVENT_SCRIPT>,         RS_MONSTER_EXT_RUN_EVENT_SCRIPT        },
    {dc2::script::AdaptRunArguments<_GET_FRAME_POS>,            RS_MONSTER_EXT_GET_FRAME_POS           },
    {dc2::script::AdaptRunArguments<_GET_OBJ_POS>,              RS_MONSTER_EXT_GET_OBJ_POS             },
    {dc2::script::AdaptRunArguments<_GET_MAPOBJ_POS>,           RS_MONSTER_EXT_GET_MAPOBJ_POS          },
    {dc2::script::AdaptRunArguments<_SET_PAUSE>,                RS_MONSTER_EXT_SET_PAUSE               },
    {dc2::script::AdaptRunArguments<_CHECK_PAUSE>,              RS_MONSTER_EXT_CHECK_PAUSE             },
    {dc2::script::AdaptRunArguments<_GET_BIT_FLAG>,             RS_MONSTER_EXT_GET_BIT_FLAG            },
    {dc2::script::AdaptRunArguments<_SET_BIT_FLAG>,             RS_MONSTER_EXT_SET_BIT_FLAG            },
    {dc2::script::AdaptRunArguments<_GET_ATT_TYPE>,             RS_MONSTER_EXT_GET_ATT_TYPE            },
    {dc2::script::AdaptRunArguments<_GET_USER_ATTR>,            RS_MONSTER_EXT_GET_USER_ATTR           },
    {dc2::script::AdaptRunArguments<_TRANS_RESERV_IMG>,         RS_MONSTER_EXT_TRANS_RESERV_IMG        },
    {dc2::script::AdaptRunArguments<_GET_STS_ATTR>,             RS_MONSTER_EXT_GET_STS_ATTR            },
    {dc2::script::AdaptRunArguments<_V_PUSH2>,                  RS_MONSTER_EXT_V_PUSH2                 },
    {dc2::script::AdaptRunArguments<_V_POP2>,                   RS_MONSTER_EXT_V_POP2                  },
    {dc2::script::AdaptRunArguments<_SET_LOCKON_MODE>,          RS_MONSTER_EXT_SET_LOCKON_MODE         },
    {dc2::script::AdaptRunArguments<_SET_MOTION_BLUR>,          RS_MONSTER_EXT_SET_MOTION_BLUR         },
    {dc2::script::AdaptRunArguments<_GET_EVENT_INFO>,           RS_MONSTER_EXT_GET_EVENT_INFO          },
    {dc2::script::AdaptRunArguments<_MONS_VOL_CTRL>,            RS_MONSTER_EXT_MONS_VOL_CTRL           },
    {dc2::script::AdaptRunArguments<_GET_DIST>,                 RS_MONSTER_EXT_GET_DIST                },
    {dc2::script::AdaptRunArguments<_SEARCH_AREA>,              RS_MONSTER_EXT_SEARCH_AREA             },
    {dc2::script::AdaptRunArguments<_SEARCH_AREA2>,             RS_MONSTER_EXT_SEARCH_AREA2            },
    {dc2::script::AdaptRunArguments<_GET_PLACE_POS>,            RS_MONSTER_EXT_GET_PLACE_POS           },
    {dc2::script::AdaptRunArguments<_SET_PLACE_POS>,            RS_MONSTER_EXT_SET_PLACE_POS           },
    {dc2::script::AdaptRunArguments<_GET_INDEX_POS>,            RS_MONSTER_EXT_GET_INDEX_POS           },
    {dc2::script::AdaptRunArguments<_GET_POS>,                  RS_MONSTER_EXT_GET_POS                 },
    {dc2::script::AdaptRunArguments<_SET_POS>,                  RS_MONSTER_EXT_SET_POS                 },
    {dc2::script::AdaptRunArguments<_GET_ROT>,                  RS_MONSTER_EXT_GET_ROT                 },
    {dc2::script::AdaptRunArguments<_SET_ROT>,                  RS_MONSTER_EXT_SET_ROT                 },
    {dc2::script::AdaptRunArguments<_SET_NEXT_ROT>,             RS_MONSTER_EXT_SET_NEXT_ROT            },
    {dc2::script::AdaptRunArguments<_SET_NEXT_POS>,             RS_MONSTER_EXT_SET_NEXT_POS            },
    {dc2::script::AdaptRunArguments<_CHK_MOVE_END>,             RS_MONSTER_EXT_CHK_MOVE_END            },
    {dc2::script::AdaptRunArguments<_RESET_MOVE>,               RS_MONSTER_EXT_RESET_MOVE              },
    {dc2::script::AdaptRunArguments<_GET_TARGET_POS>,           RS_MONSTER_EXT_GET_TARGET_POS          },
    {dc2::script::AdaptRunArguments<_GET_TARGET_DIST>,          RS_MONSTER_EXT_GET_TARGET_DIST         },
    {dc2::script::AdaptRunArguments<_GET_TARGET_ANGLE>,         RS_MONSTER_EXT_GET_TARGET_ANGLE        },
    {dc2::script::AdaptRunArguments<_GET_TARGET_REF_POS>,       RS_MONSTER_EXT_GET_TARGET_REF_POS      },
    {dc2::script::AdaptRunArguments<_GET_REF_DIR>,              RS_MONSTER_EXT_GET_REF_DIR             },
    {dc2::script::AdaptRunArguments<_GET_REFANGLE_POS>,         RS_MONSTER_EXT_GET_REFANGLE_POS        },
    {dc2::script::AdaptRunArguments<_GET_TARGET_ROT>,           RS_MONSTER_EXT_GET_TARGET_ROT          },
    {dc2::script::AdaptRunArguments<_GET_REF_ANGLE>,            RS_MONSTER_EXT_GET_REF_ANGLE           },
    {dc2::script::AdaptRunArguments<_GET_HIGH>,                 RS_MONSTER_EXT_GET_HIGH                },
    {dc2::script::AdaptRunArguments<_GET_NEAR_MONS_POS>,        RS_MONSTER_EXT_GET_NEAR_MONS_POS       },
    {dc2::script::AdaptRunArguments<_GET_TARGET_OLD_POS>,       RS_MONSTER_EXT_GET_TARGET_OLD_POS      },
    {dc2::script::AdaptRunArguments<_GET_TARGET_SPEED>,         RS_MONSTER_EXT_GET_TARGET_SPEED        },
    {dc2::script::AdaptRunArguments<_CALC_MOVE_NEXT_POS>,       RS_MONSTER_EXT_CALC_MOVE_NEXT_POS      },
    {dc2::script::AdaptRunArguments<_GET_POSREF_ANGLE>,         RS_MONSTER_EXT_GET_POSREF_ANGLE        },
    {dc2::script::AdaptRunArguments<_GET_ACTIVE_MONS_POS>,      RS_MONSTER_EXT_GET_ACTIVE_MONS_POS     },
    {dc2::script::AdaptRunArguments<_GET_ACTIVE_MONS_ROT>,      RS_MONSTER_EXT_GET_ACTIVE_MONS_ROT     },
    {dc2::script::AdaptRunArguments<_GET_ACTIVE_MONS_DIST>,     RS_MONSTER_EXT_GET_ACTIVE_MONS_DIST    },
    {dc2::script::AdaptRunArguments<_GET_ACTIVE_MONS_ANGLE>,    RS_MONSTER_EXT_GET_ACTIVE_MONS_ANGLE   },
    {dc2::script::AdaptRunArguments<_GET_REF_ROT>,              RS_MONSTER_EXT_GET_REF_ROT             },
    {dc2::script::AdaptRunArguments<_GET_REF_ROT2>,             RS_MONSTER_EXT_GET_REF_ROT2            },
    {dc2::script::AdaptRunArguments<_FLYING_SEARCH_AREA>,       RS_MONSTER_EXT_FLYING_SEARCH_AREA      },
    {dc2::script::AdaptRunArguments<_GET_HIGH2>,                RS_MONSTER_EXT_GET_HIGH2               },
    {dc2::script::AdaptRunArguments<_GET_RANGE_MONS_ID>,        RS_MONSTER_EXT_GET_RANGE_MONS_ID       },
    {dc2::script::AdaptRunArguments<_GET_ENTRY_OBJ_POS>,        RS_MONSTER_EXT_GET_ENTRY_OBJ_POS       },
    {dc2::script::AdaptRunArguments<_SET_OBJ>,                  RS_MONSTER_EXT_SET_OBJ                 },
    {dc2::script::AdaptRunArguments<_SET_BODY>,                 RS_MONSTER_EXT_SET_BODY                },
    {dc2::script::AdaptRunArguments<_SET_DMG>,                  RS_MONSTER_EXT_SET_DMG                 },
    {dc2::script::AdaptRunArguments<_SET_DMG2>,                 RS_MONSTER_EXT_SET_DMG2                },
    {dc2::script::AdaptRunArguments<_LINK_MAP_TO_OBJECT>,       RS_MONSTER_EXT_LINK_MAP_TO_OBJECT      },
    {dc2::script::AdaptRunArguments<_LINK_OBJECT_TO_PIECE>,     RS_MONSTER_EXT_LINK_OBJECT_TO_PIECE    },
    {dc2::script::AdaptRunArguments<_LOAD_EFFECT_SCRIPT>,       RS_MONSTER_EXT_LOAD_EFFECT_SCRIPT      },
    {dc2::script::AdaptRunArguments<_SET_SCOOP>,                RS_MONSTER_EXT_SET_SCOOP               },
    {dc2::script::AdaptRunArguments<_LOAD_RESERV_IMG>,          RS_MONSTER_EXT_LOAD_RESERV_IMG         },
    {dc2::script::AdaptRunArguments<_SET_PRIORITY_LIMMIT>,      RS_MONSTER_EXT_SET_PRIORITY_LIMMIT     },
    {dc2::script::AdaptRunArguments<_SET_MODEL_LIGHT_SWITCH>,   RS_MONSTER_EXT_SET_MODEL_LIGHT_SWITCH  },
    {dc2::script::AdaptRunArguments<_SET_MODEL_LIGHT_COLOR>,    RS_MONSTER_EXT_SET_MODEL_LIGHT_COLOR   },
    {dc2::script::AdaptRunArguments<_SET_ALPHA>,                RS_MONSTER_EXT_SET_ALPHA               },
    {dc2::script::AdaptRunArguments<_SET_SCALE>,                RS_MONSTER_EXT_SET_SCALE               },
    {dc2::script::AdaptRunArguments<_SET_INDEX_ALPHA>,          RS_MONSTER_EXT_SET_INDEX_ALPHA         },
    {dc2::script::AdaptRunArguments<_SET_PALLET_ANIM>,          RS_MONSTER_EXT_SET_PALLET_ANIM         },
    {dc2::script::AdaptRunArguments<_RESET_PALLET_ANIM>,        RS_MONSTER_EXT_RESET_PALLET_ANIM       },
    {dc2::script::AdaptRunArguments<_SET_ATTRIB>,               RS_MONSTER_EXT_SET_ATTRIB              },
    {dc2::script::AdaptRunArguments<_SET_STATUS>,               RS_MONSTER_EXT_SET_STATUS              },
    {dc2::script::AdaptRunArguments<_SET_INT_FLAG>,             RS_MONSTER_EXT_SET_INT_FLAG            },
    {dc2::script::AdaptRunArguments<_SET_ACT_STATUS>,           RS_MONSTER_EXT_SET_ACT_STATUS          },
    {dc2::script::AdaptRunArguments<_SET_MUTEKI>,               RS_MONSTER_EXT_SET_MUTEKI              },
    {dc2::script::AdaptRunArguments<_SET_GRAVITY>,              RS_MONSTER_EXT_SET_GRAVITY             },
    {dc2::script::AdaptRunArguments<_SET_COLLISION>,            RS_MONSTER_EXT_SET_COLLISION           },
    {dc2::script::AdaptRunArguments<_GET_GEKIRIN>,              RS_MONSTER_EXT_GET_GEKIRIN             },
    {dc2::script::AdaptRunArguments<_GET_PRIORITY>,             RS_MONSTER_EXT_GET_PRIORITY            },
    {dc2::script::AdaptRunArguments<_SET_CLIP_DIST>,            RS_MONSTER_EXT_SET_CLIP_DIST           },
    {dc2::script::AdaptRunArguments<_SET_PIYORI_MARK>,          RS_MONSTER_EXT_SET_PIYORI_MARK         },
    {dc2::script::AdaptRunArguments<_CHECK_PIYORI>,             RS_MONSTER_EXT_CHECK_PIYORI            },
    {dc2::script::AdaptRunArguments<_GET_SCALE>,                RS_MONSTER_EXT_GET_SCALE               },
    {dc2::script::AdaptRunArguments<_GET_MONS_WIDTH>,           RS_MONSTER_EXT_GET_MONS_WIDTH          },
    {dc2::script::AdaptRunArguments<_BLOW_START>,               RS_MONSTER_EXT_BLOW_START              },
    {dc2::script::AdaptRunArguments<_SET_DEAD_START>,           RS_MONSTER_EXT_SET_DEAD_START          },
    {dc2::script::AdaptRunArguments<_SET_DEAD_OFF>,             RS_MONSTER_EXT_SET_DEAD_OFF            },
    {dc2::script::AdaptRunArguments<_SET_SHROW_END>,            RS_MONSTER_EXT_SET_SHROW_END           },
    {dc2::script::AdaptRunArguments<_GET_BASE_ATTACK>,          RS_MONSTER_EXT_GET_BASE_ATTACK         },
    {dc2::script::AdaptRunArguments<_SET_DEF_RATE>,             RS_MONSTER_EXT_SET_DEF_RATE            },
    {dc2::script::AdaptRunArguments<_SET_MONSTER_LIFE>,         RS_MONSTER_EXT_SET_MONSTER_LIFE        },
    {dc2::script::AdaptRunArguments<_GET_MONSTER_LIFE>,         RS_MONSTER_EXT_GET_MONSTER_LIFE        },
    {dc2::script::AdaptRunArguments<_GET_NO_DAMAGE_CNT>,        RS_MONSTER_EXT_GET_NO_DAMAGE_CNT       },
    {dc2::script::AdaptRunArguments<_GET_ACTIVE_MONS_LIFEI>,    RS_MONSTER_EXT_GET_ACTIVE_MONS_LIFEI   },
    {dc2::script::AdaptRunArguments<_GET_ACTIVE_MONS_LIFEF>,    RS_MONSTER_EXT_GET_ACTIVE_MONS_LIFEF   },
    {dc2::script::AdaptRunArguments<_SET_ACTIVE_MONS_LIFEI>,    RS_MONSTER_EXT_SET_ACTIVE_MONS_LIFEI   },
    {dc2::script::AdaptRunArguments<_SET_ACTIVE_MONS_LIFEF>,    RS_MONSTER_EXT_SET_ACTIVE_MONS_LIFEF   },
    {dc2::script::AdaptRunArguments<_GET_ACTIVE_MONS_MAX_LIFE>, RS_MONSTER_EXT_GET_ACTIVE_MONS_MAX_LIFE},
    {dc2::script::AdaptRunArguments<_SET_DAMAGE_SCORE>,         RS_MONSTER_EXT_SET_DAMAGE_SCORE        },
    {dc2::script::AdaptRunArguments<_GET_MONS_GRADE>,           RS_MONSTER_EXT_GET_MONS_GRADE          },
    {dc2::script::AdaptRunArguments<_SET_ESCAPE_RATE>,          RS_MONSTER_EXT_SET_ESCAPE_RATE         },
    {dc2::script::AdaptRunArguments<_SET_GUARD_RATE>,           RS_MONSTER_EXT_SET_GUARD_RATE          },
    {dc2::script::AdaptRunArguments<_SET_EXT_PARAM_RATE>,       RS_MONSTER_EXT_SET_EXT_PARAM_RATE      },
    {dc2::script::AdaptRunArguments<_GET_BOSS_FLAG>,            RS_MONSTER_EXT_GET_BOSS_FLAG           },
    {dc2::script::AdaptRunArguments<_SET_INDEXOBJ_SIZE>,        RS_MONSTER_EXT_SET_INDEXOBJ_SIZE       },
    {dc2::script::AdaptRunArguments<_GET_INDEXOBJ_SIZE>,        RS_MONSTER_EXT_GET_INDEXOBJ_SIZE       },
    {dc2::script::AdaptRunArguments<_RESET_MOTION>,             RS_MONSTER_EXT_RESET_MOTION            },
    {dc2::script::AdaptRunArguments<_SET_MOS>,                  RS_MONSTER_EXT_SET_MOS                 },
    {dc2::script::AdaptRunArguments<_CHECK_MOS_END>,            RS_MONSTER_EXT_CHECK_MOS_END           },
    {dc2::script::AdaptRunArguments<_NOW_MOS_WAIT>,             RS_MONSTER_EXT_NOW_MOS_WAIT            },
    {dc2::script::AdaptRunArguments<_GET_MOS_STATUS>,           RS_MONSTER_EXT_GET_MOS_STATUS          },
    {dc2::script::AdaptRunArguments<_ESM_CREATE>,               RS_MONSTER_EXT_ESM_CREATE              },
    {dc2::script::AdaptRunArguments<_ESM_FINISH>,               RS_MONSTER_EXT_ESM_FINISH              },
    {dc2::script::AdaptRunArguments<_ESM_DELETE>,               RS_MONSTER_EXT_ESM_DELETE              },
    {dc2::script::AdaptRunArguments<_ESM_SET_VECT1>,            RS_MONSTER_EXT_ESM_SET_VECT1           },
    {dc2::script::AdaptRunArguments<_ESM_GET_VECT1>,            RS_MONSTER_EXT_ESM_GET_VECT1           },
    {dc2::script::AdaptRunArguments<_ESM_SET_VECT2>,            RS_MONSTER_EXT_ESM_SET_VECT2           },
    {dc2::script::AdaptRunArguments<_ESM_GET_VECT2>,            RS_MONSTER_EXT_ESM_GET_VECT2           },
    {dc2::script::AdaptRunArguments<_ESM_SET_TARGET_ID>,        RS_MONSTER_EXT_ESM_SET_TARGET_ID       },
    {dc2::script::AdaptRunArguments<_ESM_GET_TARGET_ID>,        RS_MONSTER_EXT_ESM_GET_TARGET_ID       },
    {dc2::script::AdaptRunArguments<_ESM_SET_USER_ID>,          RS_MONSTER_EXT_ESM_SET_USER_ID         },
    {dc2::script::AdaptRunArguments<_ESM_GET_USER_ID>,          RS_MONSTER_EXT_ESM_GET_USER_ID         },
    {dc2::script::AdaptRunArguments<_ESM_SET_VALUE>,            RS_MONSTER_EXT_ESM_SET_VALUE           },
    {dc2::script::AdaptRunArguments<_SW_EFFECT>,                RS_MONSTER_EXT_SW_EFFECT               },
    {dc2::script::AdaptRunArguments<_ESM_GET_NOTUESD_TEXB>,     RS_MONSTER_EXT_ESM_GET_NOTUESD_TEXB    },
    {dc2::script::AdaptRunArguments<_ESM_ADD_TEXB>,             RS_MONSTER_EXT_ESM_ADD_TEXB            },
    {dc2::script::AdaptRunArguments<_SHOT_ROCKET_LAUNCHER>,     RS_MONSTER_EXT_SHOT_ROCKET_LAUNCHER    },
    {dc2::script::AdaptRunArguments<_ESM_ALL_CLEAR>,            RS_MONSTER_EXT_ESM_ALL_CLEAR           },
    {dc2::script::AdaptRunArguments<_SET_MAPOBJ_SHOW>,          RS_MONSTER_EXT_SET_MAPOBJ_SHOW         },
    {nullptr,                                                   RS_MONSTER_EXT_END                     },
};

/**
 *
 * Builds the monster opcode dispatch table and checks duplicate opcode numbers.
 *
 */
void SetMonsterExtendTable() {
    int index = {};
    int earlier = {};

    for (index = 0; index < RS_MONSTER_EXT_LIMIT; index++) {
        ext_func[index] = nullptr;
    }

    for (index = 0;; index++) {
        if (ext_func_info[index].func == nullptr) {
            break;
        }

        if (0 < index) {
            earlier = 0;

            do {
                if (ext_func_info[index].no == ext_func_info[earlier].no) {
                    dc2::log::PrintGame("mscript same ext_func_no!!!\n");

                    while (1) {
                    }
                }

                earlier++;
            } while (earlier < index);
        }

        if (ext_func_info[index].no < 0 || ext_func_info[index].no >= RS_MONSTER_EXT_LIMIT) {
            dc2::log::PrintGame("ext func over!!");
        } else {
            ext_func[ext_func_info[index].no] = ext_func_info[index].func;
        }
    }
}

#include "common.h"

#include <cstdio>
#include <string>

#include "assets/data_registry.hpp"
#include "character.hpp"
#include "log/log.hpp"
#include "monster.hpp"
#include "platform/model_assets.hpp"
#include "runscript.hpp"
#include "stubs/runscript_opcodes.hpp"

namespace {

/**
 * Restores an enclosing monster callback context only while its original bindings remain live.
 */
class MonsterScriptContext {
    inline static thread_local MonsterScriptContext *current = nullptr; /**< Innermost monster invocation on this thread. */
    dc2::scene::SceneView                            scene_view;        /**< Original scene lifetime for this invocation. */
    dc2::scene::CharacterView                        monster_view;      /**< Original monster assignment for this invocation. */
    CScene                                          *scene;             /**< Scene address validated before publication. */
    CActiveMonster                                  *monster;           /**< Monster address validated before publication. */
    MonsterScriptContext                            *previous;          /**< Enclosing invocation restored when this scope exits. */

    /**
     * Publishes this invocation's original live bindings or clears expired callback state.
     */
    void Publish() const {
        const bool live = scene != nullptr && monster != nullptr && scene_view.Get() == scene && monster_view.Get() == monster;
        PortSetMonsterScriptScene(live ? scene : nullptr);
        nowMonster = live ? monster : nullptr;
    }

public:
    /**
     * Publishes an invocation's checked scene and monster while recording its parent context.
     */
    MonsterScriptContext(dc2::scene::SceneView scene_view, dc2::scene::CharacterView monster_view, CScene *scene, CActiveMonster *monster)
        : scene_view(std::move(scene_view)), monster_view(std::move(monster_view)), scene(scene), monster(monster), previous(current) {
        current = this;
        Publish();
    }

    /**
     * Restores a live parent invocation or retains this invocation's live top-level context.
     */
    ~MonsterScriptContext() {
        current = previous;
        (previous != nullptr ? previous : this)->Publish();
    }

    MonsterScriptContext(const MonsterScriptContext &) = delete;
    MonsterScriptContext &operator=(const MonsterScriptContext &) = delete;
};

int get_stack_int(dc2::script::RunArguments stack) {
    if (stack.At().type == RS_FLOAT) {
        return static_cast<int>(stack.At().val.f);
    }

    return stack.At().val.i;
}

void set_stack_float(dc2::script::RunArguments stack, float value) {
    dc2::script::RunOutput(stack).val.f = value;
}

} // namespace

/**
 * Runs a monster program while preserving suspended behavior through unsupported stun requests.
 */
void CMonsterMan::RunScript(int index) {
    const auto                 bound_scene = scene_view;
    const auto                 bound_monster = index >= 0 && index < MONSTER_ACTIVE_MAX ? active_views[index] : dc2::scene::CharacterView{};
    auto                      *scene = bound_scene.Get();
    auto                      *monster = scene != nullptr ? dynamic_cast<CActiveMonster *>(bound_monster.Get()) : nullptr;
    const MonsterScriptContext context(bound_scene, bound_monster, scene, monster);
    if (monster == nullptr) {
        return;
    }
    const auto execution_resource = scene->chara[DNG_CHARA_SLOT_MONSTER + index].Resource();
    if (execution_resource.Get() != monster) {
        nowMonster = nullptr;
        return;
    }
    const dc2::script::ScopedExecutionValidation execution(
        monster->mons_script,
        [bound_scene, bound_monster, scene, monster] {
            return bound_scene.Get() == scene && bound_monster.Get() == monster;
        });

    const int script = nowMonster->req_prog;
    if (script != MONSTER_PROG_RUNNING) {
        if (nowMonster->mons_script.check_program(script) != 0) {
            nowMonster->mons_script.run(script);
            nowMonster = bound_scene.Get() == scene ? dynamic_cast<CActiveMonster *>(bound_monster.Get()) : nullptr;
            if (nowMonster != monster) {
                nowMonster = nullptr;
                if (bound_scene.Get() != scene) {
                    PortSetMonsterScriptScene(nullptr);
                }
                return;
            }
            nowMonster->now_prog = script;
            nowMonster->req_prog = MONSTER_PROG_RUNNING;
        } else if (script == MONSTER_PROG_PIYORI) {
            // Monsters without a stun program hold their suspended behavior until the stun expires.
            nowMonster->piyori_mark = nowMonster->piyori_time;
            nowMonster->piyori.Set(nowMonster, nowMonster->piyori_mark);
            nowMonster->req_prog = MONSTER_PROG_RUNNING;
        }
        return;
    }

    if (nowMonster->piyori_mark > 0 && nowMonster->mons_script.check_program(MONSTER_PROG_PIYORI) == 0) {
        return;
    }
    nowMonster->mons_script.resume();
    nowMonster = bound_scene.Get() == scene ? dynamic_cast<CActiveMonster *>(bound_monster.Get()) : nullptr;
    if (nowMonster != monster) {
        nowMonster = nullptr;
        if (bound_scene.Get() != scene) {
            PortSetMonsterScriptScene(nullptr);
        }
        return;
    }
    if (nowMonster->mons_script.end != 0) {
        nowMonster->req_prog = MONSTER_PROG_MAIN;
    }
}

int _GET_INDEXOBJ_SIZE(dc2::script::RunArguments stack, int argument_count) {
    if (argument_count != 2) {
        return 0;
    }

    int object_index = get_stack_int(stack++);

    if (object_index == -1) {
        object_index = 0;
    }

    if (nowMonster == nullptr || object_index < 0 || object_index >= CHARA_ENTRY_OBJECT_MAX) {
        return 0;
    }

    CHARA_ENTRY_OBJECT *object = &nowMonster->entry_object[object_index];
    set_stack_float(stack, object->size);
    return 1;
}

int _LOAD_RESERV_IMG(dc2::script::RunArguments stack, int argc) {
    if (argc != 2 || !nowMonster || !stack.At(1).val.s) {
        return 0;
    }
    const int slot = get_stack_int(stack);
    if (slot < 0 || slot >= 2) {
        return 0;
    }
    const auto path = DataReadAssetPath(stack.At(1).val.s);
    if (!path) {
        return 0;
    }
    std::string error;
    if (!model_assets::ReserveMonsterTextureDocument(*nowMonster, slot, *path, error)) {
        CT_LOG_ERROR(Gfx, "reserved monster texture: {}", error);
        return 0;
    }
    return 1;
}

int _TRANS_RESERV_IMG(dc2::script::RunArguments stack, int argument_count) {
    if (argument_count != 1 || !nowMonster) {
        return 0;
    }
    std::string error;
    return model_assets::ApplyReservedMonsterTexture(*nowMonster, get_stack_int(stack), error) ? 1 : 0;
}
