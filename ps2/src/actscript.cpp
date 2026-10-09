#include "common.h"
#include "mw_runtime.h"

#include <libvu0.h>

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "actionchara.hpp"
#include "actscript.hpp"
#include "cameracontrol.hpp"
#include "character.hpp"
#include "colprim.hpp"
#include "dataread.hpp"
#include "dng_effect.hpp"
#include "dng_hud.hpp"
#include "dng_main.hpp"
#include "dng_object.hpp"
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
#include "object.hpp"
#include "padcontrol.hpp"
#include "runscript.hpp"
#include "runscript_opcodes.hpp"
#include "scenesnd.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include "userdata.hpp"
/**
 *
 * Most recently entered collision-damage window for the action script.
 *
 */
static ACTION_DAMAGE *LastCInfo2;
/**
 *
 * Dispatch slots used by action-script external calls.
 *
 */
static int (*ext_func[256])(RS_STACKDATA *, int);

CScene *nowScene__2;
ACTION_INFO action_info;

/**
 *
 * Names of cannon objects selected by the action script.
 *
 */
struct CanonObjectNames {
    char *name[4][2]; /**< Names grouped by cannon variant. */
};

/**
 *
 * RGB colours used by the action script's rings.
 *
 */
struct RingColors {
    int rgb[4][3]; /**< Red, green and blue components of each ring colour. */
};

static int _INIT_SCRIPT(RS_STACKDATA *stack, int argc);
static int _PROG_SET(RS_STACKDATA *stack, int argc);
static int _PROG_GET(RS_STACKDATA *stack, int argc);
static int _GET_ATTK_TYPE(RS_STACKDATA *stack, int argc);
static int _GET_MOVE_TYPE(RS_STACKDATA *stack, int argc);
static int _SET_MOVE_SPEED(RS_STACKDATA *stack, int argc);
static int _SET_PALLET(RS_STACKDATA *stack, int argc);
static int _CHECK_EQUIP(RS_STACKDATA *stack, int argc);
static int _CAMERA_QUAKE(RS_STACKDATA *stack, int argc);
static int _CHECK_PAUSE(RS_STACKDATA *stack, int argc);
static int _GET_STATUS_ATTR(RS_STACKDATA *stack, int argc);
static int _SE_PLAY(RS_STACKDATA *stack, int argc);
static int _SE_LOOP_PLAY(RS_STACKDATA *stack, int argc);
static int _GET_SHOT_TYPE(RS_STACKDATA *stack, int argc);
static int _GET_MONS_ID(RS_STACKDATA *stack, int argc);
static int _GET_FRONT_VEC(RS_STACKDATA *stack, int argc);
static int _GET_PADON(RS_STACKDATA *stack, int argc);
static int _GET_PADDOWN(RS_STACKDATA *stack, int argc);
static int _GET_PADUP(RS_STACKDATA *stack, int argc);
static int _GET_BTN(RS_STACKDATA *stack, int argc);
static int _GET_PAD_HISTORY(RS_STACKDATA *stack, int argc);
static int _RESET_PAD_HISTORY(RS_STACKDATA *stack, int argc);
static int _GET_ACUMU_PAD(RS_STACKDATA *stack, int argc);
static int _RESET_ACUMU_PAD(RS_STACKDATA *stack, int argc);
static int _RUN_MAIN_MOVE(RS_STACKDATA *stack, int argc);
static int _RUN_SHROW_MOVE(RS_STACKDATA *stack, int argc);
static int _RUN_TAME_MOVE(RS_STACKDATA *stack, int argc);
static int _RUN_HOLD_MOVE(RS_STACKDATA *stack, int argc);
static int _SET_MENU_FLAG(RS_STACKDATA *stack, int argc);
static int _GET_POS(RS_STACKDATA *stack, int argc);
static int _GET_ROT(RS_STACKDATA *stack, int argc);
static int _CHECK_FRONT_KEY(RS_STACKDATA *stack, int argc);
static int _CHECK_BACK_KEY(RS_STACKDATA *stack, int argc);
static int _SET_BLOW_ANGLE(RS_STACKDATA *stack, int argc);
static int _SET_BLOW_MOVE(RS_STACKDATA *stack, int argc);
static int _BLOW_START(RS_STACKDATA *stack, int argc);
static int _RUN_ROBO_MOVE(RS_STACKDATA *stack, int argc);
static int _SET_DMG2(RS_STACKDATA *stack, int argc);
static int _SET_OBJ(RS_STACKDATA *stack, int argc);
static int _SET_BODY(RS_STACKDATA *stack, int argc);
static int _SW_EFFECT(RS_STACKDATA *stack, int argc);
static int _SET_SND(RS_STACKDATA *stack, int argc);
static int _SET_ACCUME_FX(RS_STACKDATA *stack, int argc);
static int _SET_ACCUME_FLAG(RS_STACKDATA *stack, int argc);
static int _GET_MONSTER_NOWSTS(RS_STACKDATA *stack, int argc);
static int _SET_MURDEROUS(RS_STACKDATA *stack, int argc);
static int _GET_TRG_DISTANCE(RS_STACKDATA *stack, int argc);
static int _SET_TRG_ANGLE(RS_STACKDATA *stack, int argc);
static int _SET_GUARD_FLAG(RS_STACKDATA *stack, int argc);
static int _SET_MUTEKI(RS_STACKDATA *stack, int argc);
static int _CHECK_HAND_OBJ(RS_STACKDATA *stack, int argc);
static int _SET_ITEM_USED(RS_STACKDATA *stack, int argc);
static int _THROW_HAND_OBJECT(RS_STACKDATA *stack, int argc);
static int _CHECK_CATCH(RS_STACKDATA *stack, int argc);
static int _RELEASE_OBJ(RS_STACKDATA *stack, int argc);
static int _SET_SHOT(RS_STACKDATA *stack, int argc);
static int _SET_SPECIAL_SHOT(RS_STACKDATA *stack, int argc);
static int _SHOT(RS_STACKDATA *stack, int argc);
static int _GET_OBJECT_POS(RS_STACKDATA *stack, int argc);
static int _SET_DIR_GUN(RS_STACKDATA *stack, int argc);
static int _GET_NOW_HP_RATE(RS_STACKDATA *stack, int argc);
static int _SET_BOMB(RS_STACKDATA *stack, int argc);
static int _GET_ACTION_CODE(RS_STACKDATA *stack, int argc);
static int _GET_ATTK_POINT(RS_STACKDATA *stack, int argc);
static int _GET_RING_COLOR(RS_STACKDATA *stack, int argc);
static int _SET_MOS(RS_STACKDATA *stack, int argc);
static int _CHECK_MOS_END(RS_STACKDATA *stack, int argc);
static int _NOW_MOS_WAIT(RS_STACKDATA *stack, int argc);
static int _GET_MOS_STATUS(RS_STACKDATA *stack, int argc);
static int _SET_XCHG_STEP(RS_STACKDATA *stack, int argc);
static int _SET_MOS_STEP(RS_STACKDATA *stack, int argc);
static int _TRG_ON_MOS(RS_STACKDATA *stack, int argc);
static int _RESET_MOS(RS_STACKDATA *stack, int argc);
static int _SET_DEFAULT_MOS(RS_STACKDATA *stack, int argc);
static int _SET_NEBA2(RS_STACKDATA *stack, int argc);
static int _NOW_MOS_CHGWAIT(RS_STACKDATA *stack, int argc);
static int _ESM_CREATE(RS_STACKDATA *stack, int argc);
static int _ESM_SET_VECT1(RS_STACKDATA *stack, int argc);
static int _ESM_SET_VECT2(RS_STACKDATA *stack, int argc);
static int _ESM_FINISH(RS_STACKDATA *stack, int argc);
static int _ESM_DELETE(RS_STACKDATA *stack, int argc);
static int _ESM_SET_VALUE(RS_STACKDATA *stack, int argc);

/**
 *
 * Associates action-script external function numbers with their handlers.
 *
 */
static RS_EXTFUNC_INFO ext_func_info[83] = {
    {_INIT_SCRIPT, ACTION_EXT_INIT_SCRIPT},
    {_PROG_SET, ACTION_EXT_PROG_SET},
    {_PROG_GET, ACTION_EXT_PROG_GET},
    {_GET_ATTK_TYPE, ACTION_EXT_GET_ATTK_TYPE},
    {_GET_MOVE_TYPE, ACTION_EXT_GET_MOVE_TYPE},
    {_SET_MOVE_SPEED, ACTION_EXT_SET_MOVE_SPEED},
    {_SET_PALLET, ACTION_EXT_SET_PALLET},
    {_CHECK_EQUIP, ACTION_EXT_CHECK_EQUIP},
    {_CAMERA_QUAKE, ACTION_EXT_CAMERA_QUAKE},
    {_CHECK_PAUSE, ACTION_EXT_CHECK_PAUSE},
    {_GET_STATUS_ATTR, ACTION_EXT_GET_STATUS_ATTR},
    {_SE_PLAY, ACTION_EXT_SE_PLAY},
    {_SE_LOOP_PLAY, ACTION_EXT_SE_LOOP_PLAY},
    {_GET_SHOT_TYPE, ACTION_EXT_GET_SHOT_TYPE},
    {_GET_MONS_ID, ACTION_EXT_GET_MONS_ID},
    {_GET_FRONT_VEC, ACTION_EXT_GET_FRONT_VEC},
    {_GET_PADON, ACTION_EXT_GET_PADON},
    {_GET_PADDOWN, ACTION_EXT_GET_PADDOWN},
    {_GET_PADUP, ACTION_EXT_GET_PADUP},
    {_GET_BTN, ACTION_EXT_GET_BTN},
    {_GET_PAD_HISTORY, ACTION_EXT_GET_PAD_HISTORY},
    {_RESET_PAD_HISTORY, ACTION_EXT_RESET_PAD_HISTORY},
    {_GET_ACUMU_PAD, ACTION_EXT_GET_ACUMU_PAD},
    {_RESET_ACUMU_PAD, ACTION_EXT_RESET_ACUMU_PAD},
    {_RUN_MAIN_MOVE, ACTION_EXT_RUN_MAIN_MOVE},
    {_RUN_SHROW_MOVE, ACTION_EXT_RUN_SHROW_MOVE},
    {_RUN_TAME_MOVE, ACTION_EXT_RUN_TAME_MOVE},
    {_RUN_HOLD_MOVE, ACTION_EXT_RUN_HOLD_MOVE},
    {_SET_MENU_FLAG, ACTION_EXT_SET_MENU_FLAG},
    {_GET_POS, ACTION_EXT_GET_POS},
    {_GET_ROT, ACTION_EXT_GET_ROT},
    {_CHECK_FRONT_KEY, ACTION_EXT_CHECK_FRONT_KEY},
    {_CHECK_BACK_KEY, ACTION_EXT_CHECK_BACK_KEY},
    {_SET_BLOW_ANGLE, ACTION_EXT_SET_BLOW_ANGLE},
    {_SET_BLOW_MOVE, ACTION_EXT_SET_BLOW_MOVE},
    {_BLOW_START, ACTION_EXT_BLOW_START},
    {_RUN_ROBO_MOVE, ACTION_EXT_RUN_ROBO_MOVE},
    {_SET_DMG2, ACTION_EXT_SET_DMG2},
    {_SET_OBJ, ACTION_EXT_SET_OBJ},
    {_SET_BODY, ACTION_EXT_SET_BODY},
    {_SW_EFFECT, ACTION_EXT_SW_EFFECT},
    {_SET_SND, ACTION_EXT_SET_SND},
    {_SET_ACCUME_FX, ACTION_EXT_SET_ACCUME_FX},
    {_SET_ACCUME_FLAG, ACTION_EXT_SET_ACCUME_FLAG},
    {_GET_MONSTER_NOWSTS, ACTION_EXT_GET_MONSTER_NOWSTS},
    {_SET_MURDEROUS, ACTION_EXT_SET_MURDEROUS},
    {_GET_TRG_DISTANCE, ACTION_EXT_GET_TRG_DISTANCE},
    {_SET_TRG_ANGLE, ACTION_EXT_SET_TRG_ANGLE},
    {_SET_GUARD_FLAG, ACTION_EXT_SET_GUARD_FLAG},
    {_SET_MUTEKI, ACTION_EXT_SET_MUTEKI},
    {_CHECK_HAND_OBJ, ACTION_EXT_CHECK_HAND_OBJ},
    {_SET_ITEM_USED, ACTION_EXT_SET_ITEM_USED},
    {_THROW_HAND_OBJECT, ACTION_EXT_THROW_HAND_OBJECT},
    {_CHECK_CATCH, ACTION_EXT_CHECK_CATCH},
    {_RELEASE_OBJ, ACTION_EXT_RELEASE_OBJ},
    {_SET_SHOT, ACTION_EXT_SET_SHOT},
    {_SET_SPECIAL_SHOT, ACTION_EXT_SET_SPECIAL_SHOT},
    {_SHOT, ACTION_EXT_SHOT},
    {_GET_OBJECT_POS, ACTION_EXT_GET_OBJECT_POS},
    {_SET_DIR_GUN, ACTION_EXT_SET_DIR_GUN},
    {_GET_NOW_HP_RATE, ACTION_EXT_GET_NOW_HP_RATE},
    {_SET_BOMB, ACTION_EXT_SET_BOMB},
    {_GET_ACTION_CODE, ACTION_EXT_GET_ACTION_CODE},
    {_GET_ATTK_POINT, ACTION_EXT_GET_ATTK_POINT},
    {_GET_RING_COLOR, ACTION_EXT_GET_RING_COLOR},
    {_SET_MOS, ACTION_EXT_SET_MOS},
    {_CHECK_MOS_END, ACTION_EXT_CHECK_MOS_END},
    {_NOW_MOS_WAIT, ACTION_EXT_NOW_MOS_WAIT},
    {_GET_MOS_STATUS, ACTION_EXT_GET_MOS_STATUS},
    {_SET_XCHG_STEP, ACTION_EXT_SET_XCHG_STEP},
    {_SET_MOS_STEP, ACTION_EXT_SET_MOS_STEP},
    {_TRG_ON_MOS, ACTION_EXT_TRG_ON_MOS},
    {_RESET_MOS, ACTION_EXT_RESET_MOS},
    {_SET_DEFAULT_MOS, ACTION_EXT_SET_DEFAULT_MOS},
    {_SET_NEBA2, ACTION_EXT_SET_NEBA2},
    {_NOW_MOS_CHGWAIT, ACTION_EXT_NOW_MOS_CHGWAIT},
    {_ESM_CREATE, ACTION_EXT_ESM_CREATE},
    {_ESM_SET_VECT1, ACTION_EXT_ESM_SET_VECT1},
    {_ESM_SET_VECT2, ACTION_EXT_ESM_SET_VECT2},
    {_ESM_FINISH, ACTION_EXT_ESM_FINISH},
    {_ESM_DELETE, ACTION_EXT_ESM_DELETE},
    {_ESM_SET_VALUE, ACTION_EXT_ESM_SET_VALUE},
    {NULL, ACTION_EXT_END}
};

/**
 *
 * Accumulation effect state accessed by action script commands.
 *
 */
struct AccumeSlot {
    mgCFrame *effect; /**< Effect frame. */
    char      unk_4[0x28C];
    int       clear[32];
    int       mode; /**< Effect mode. */
    int       unk_314;
    int       unk_318;
    float     scale; /**< Effect scale. */
    int       unk_320;
    int       unk_324;
};

void ParabolicInitialVector(float *result, float *from, float *to, float gravity, float flight_time);

// Code (.text)

/**
 *
 * Reads an action script value as an integer, converting a float slot when needed.
 *
 */
static int GetStackInt(RS_STACKDATA *slot) {
    if (slot->type == RS_FLOAT) {
        return (int) slot->val.f;
    }

    return slot->val.i;
}

/**
 *
 * Reads an action script value as a float, converting an integer slot when needed.
 *
 */
static float GetStackFloat(RS_STACKDATA *slot) {
    if (slot->type == RS_INT) {
        return (float) slot->val.i;
    }

    return slot->val.f;
}

/**
 *
 * Returns the string pointer stored in an action script slot.
 *
 */
static char *GetStackString(RS_STACKDATA *slot) {
    return slot->val.s;
}

/**
 *
 * Writes an integer through an action script reference slot.
 *
 */
static void SetStack(RS_STACKDATA *slot, int value) {
    if (slot->type == RS_PTR) {
        slot->val.p->val.i = value;
    }
}

/**
 *
 * Writes a float through an action script reference slot.
 *
 */
static void SetStack(RS_STACKDATA *slot, float value) {
    if (slot->type == RS_PTR) {
        slot->val.p->val.f = value;
    }
}

/**
 *
 * Resets the current action character script.
 *
 */
int _INIT_SCRIPT(RS_STACKDATA *stack, int argc) {
    action_info.chara->ResetScript();
    return 1;
}

/**
 *
 * Sets the current action character program number from the script.
 *
 */
int _PROG_SET(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    action_info.chara->prog = GetStackInt(stack);
    return 1;
}

/**
 *
 * Returns the current action character program number to the script.
 *
 */
int _PROG_GET(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    SetStack(stack, action_info.chara->prog);
    return 1;
}

/**
 *
 * Returns the current action character attack type to the script.
 *
 */
int _GET_ATTK_TYPE(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    SetStack(stack, action_info.chara->attack_type);
    return 1;
}

/**
 *
 * Returns the current action character movement type to the script.
 *
 */
int _GET_MOVE_TYPE(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    SetStack(stack, action_info.chara->move_type);
    return 1;
}

/**
 *
 * Sets the action character movement speed, using the default for nonpositive input.
 *
 */
int _SET_MOVE_SPEED(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    float speed = GetStackFloat(stack);

    if (speed <= 0.0f) {
        speed = 3.0f;
    }

    action_info.chara->accele.move_speed = speed;
    return 1;
}

/**
 *
 * Starts a palette color animation on the action character.
 *
 */
int _SET_PALLET(RS_STACKDATA *stack, int argc) {
    if (argc < 5 || argc > 6) {
        return 0;
    }

    int red = GetStackInt(stack++);
    int green = GetStackInt(stack++);
    int blue = GetStackInt(stack++);
    int pulses = GetStackInt(stack++);
    int duration = GetStackInt(stack++);
    int repeats = 0;

    if (argc == 6) {
        repeats = GetStackInt(stack);
    }

    action_info.chara->pallet[0].SetAnim(red, green, blue, pulses, duration, repeats);
    return 1;
}

/**
 *
 * Returns the equipped item number for the selected equipment slot.
 *
 */
int _CHECK_EQUIP(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int            slot = GetStackInt(stack++);
    CGameDataUsed *equip = DngUserData->GetCharaDataPtr(action_info.chara->chara_type)->equip;
    SetStack(stack, equip[slot].item_no);
    return 1;
}

/**
 *
 * Starts a dungeon camera quake with the requested strength and duration.
 *
 */
static int _CAMERA_QUAKE(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *area = &nowScene__2->battle_area;

    if (area == NULL) {
        return 0;
    }

    float power = GetStackFloat(stack++);
    int   duration = GetStackInt(stack);
    area->quake_power = power;
    area->quake_step = area->quake_power / (float) duration;
    area->quake_count = duration;
    return 1;
}

/**
 *
 * Reports whether a requested dungeon battle pause flag is set.
 *
 */
static int _CHECK_PAUSE(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *pause;

    if (argc != 2) {
        return 0;
    }

    pause = &nowScene__2->battle_area;

    if (pause == NULL) {
        return 0;
    }

    SetStack(stack, static_cast<int>(pause->pause_flag & GetStackInt(stack++)));
    return 1;
}

/**
 *
 * Returns the battle character status attributes.
 *
 */
int _GET_STATUS_ATTR(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    int attributes = GetBattleCharaInfo()->GetAttr();
    SetStack(stack, attributes);
    return 1;
}

/**
 *
 * Plays a sound effect from the action character sound bank.
 *
 */
int _SE_PLAY(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int requested_bank = GetStackInt(stack++);
    int sound = GetStackInt(stack);
    int bank = -1;

    if (requested_bank == -1) {
        bank = action_info.chara->sound_info.se_bank;
    }

    if (bank == -1) {
        return 0;
    }

    sndSePlay(bank, sound, 0);
    return 1;
}

/**
 *
 * Starts or stops a looped sound effect for the action character.
 *
 */
int _SE_LOOP_PLAY(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }

    int requested_bank = GetStackInt(stack++);
    int sound = GetStackInt(stack++);
    int loop = GetStackInt(stack);
    int bank = -1;

    if (requested_bank == -1) {
        bank = action_info.chara->sound_info.se_bank;
    }

    if (bank == -1) {
        return 0;
    }

    CLoopSeMngr *sounds = action_info.chara->sound_info.loop_se;

    if (sounds != NULL) {
        sounds->SeLoopPlayStop(bank, sound, loop, 13);
    }

    return 1;
}

/**
 *
 * Returns the attack type of the battle character ranged weapon.
 *
 */
int _GET_SHOT_TYPE(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    int attack_type = GetBattleCharaInfo()->equip[1].GetAttackType();
    SetStack(stack, attack_type);
    return 1;
}

/**
 *
 * Returns the active monster form identifier, or minus one for another character.
 *
 */
int _GET_MONS_ID(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    int monster_id = -1;

    if (DngUserData->GetActiveChrNo() == USER_CHARA_MONSTER) {
        monster_id = GetBattleCharaInfo()->GetMonsterID();
    }

    SetStack(stack, monster_id);
}

/**
 *
 * Writes the action character facing direction to script outputs.
 *
 */
int _GET_FRONT_VEC(RS_STACKDATA *stack, int argc) {
    sceVu0FVECTOR front;

    if (argc != 3) {
        return 0;
    }

    sceVu0CopyVector(front, action_info.chara->front_vec);
    SetStack(stack++, front[0]);
    SetStack(stack++, front[1]);
    SetStack(stack, front[2]);
}

/**
 *
 * Returns the current gamepad buttons held down.
 *
 */
static int _GET_PADON(RS_STACKDATA *stack, int argc) {
    if (argc <= 0) {
        return 0;
    }

    SetStack(stack, GamePad__2.GetPadOn());
    return 1;
}

/**
 *
 * Returns gamepad buttons pressed this frame.
 *
 */
static int _GET_PADDOWN(RS_STACKDATA *stack, int argc) {
    if (argc <= 0) {
        return 0;
    }

    SetStack(stack, GamePad__2.GetPadDown());
    return 1;
}

/**
 *
 * Returns gamepad buttons released this frame.
 *
 */
static int _GET_PADUP(RS_STACKDATA *stack, int argc) {
    if (argc <= 0) {
        return 0;
    }

    SetStack(stack, GamePad__2.GetPadUp());
    return 1;
}

/**
 *
 * Returns the state of a selected logical gamepad button.
 *
 */
int _GET_BTN(RS_STACKDATA *stack, int argc) {
    if (argc <= 0) {
        return 0;
    }

    SetStack(stack, PadCtrl.Btn(GetStackInt(stack++)));
    return 1;
}

/**
 *
 * Returns the action character recorded gamepad history.
 *
 */
int _GET_PAD_HISTORY(RS_STACKDATA *stack, int argc) {
    if (argc <= 0) {
        return 0;
    }

    SetStack(stack, static_cast<int>(action_info.chara->pad_history));
    return 1;
}

/**
 *
 * Clears the action character recorded gamepad history.
 *
 */
int _RESET_PAD_HISTORY(RS_STACKDATA *stack, int argc) {
    action_info.chara->pad_history = 0;
    return 1;
}

/**
 *
 * Returns the accumulated gamepad input for the action character.
 *
 */
int _GET_ACUMU_PAD(RS_STACKDATA *stack, int argc) {
    SetStack(stack, action_info.chara->acumu_pad);
    return 1;
}

/**
 *
 * Clears the accumulated gamepad input for the action character.
 *
 */
int _RESET_ACUMU_PAD(RS_STACKDATA *stack, int argc) {
    action_info.chara->acumu_pad = 0;
    return 1;
}

/**
 *
 * Runs human or monster movement according to the character movement type.
 *
 */
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

/**
 *
 * Runs the human throw movement handler.
 *
 */
int _RUN_SHROW_MOVE(RS_STACKDATA *stack, int argc) {
    action_info.chara->HumanShrowMoveIF();
    return 1;
}

/**
 *
 * Runs the human taming movement handler.
 *
 */
int _RUN_TAME_MOVE(RS_STACKDATA *stack, int argc) {
    action_info.chara->HumanTameMoveIF();
    return 1;
}

/**
 *
 * Runs human gun movement using two named motion resources.
 *
 */
int _RUN_HOLD_MOVE(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    char *first = GetStackString(stack++);
    action_info.chara->HumanGunMoveIF(first, GetStackString(stack));
    return 1;
}

/**
 *
 * Runs the robot movement handler selected by its movement type.
 *
 */
int _RUN_ROBO_MOVE(RS_STACKDATA *stack, int argc) {
    int input = GetStackInt(stack);

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

/**
 *
 * Sets the action character menu state flag.
 *
 */
int _SET_MENU_FLAG(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    action_info.chara->menu_flag = (s8) GetStackInt(stack);
    return 1;
}

/**
 *
 * Writes the action character world position to three script outputs.
 *
 */
static int _GET_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];

    if (argc != 3) {
        return 0;
    }

    action_info.chara->GetPosition(pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

/**
 *
 * Writes the action character rotation to three script outputs.
 *
 */
static int _GET_ROT(RS_STACKDATA *stack, int argc) {
    float rot[4];

    if (argc != 3) {
        return 0;
    }

    action_info.chara->GetRotation(rot);
    SetStack(stack++, rot[0]);
    SetStack(stack++, rot[1]);
    SetStack(stack, rot[2]);
    return 1;
}

/**
 *
 * Returns how closely the camera-relative stick input aligns with the character facing direction.
 *
 */
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
    SetStack(stack, sceVu0InnerProduct(facing, stick));
    return 1;
}

/**
 *
 * Reports whether stick input points behind a locked-on character.
 *
 */
int _CHECK_BACK_KEY(RS_STACKDATA *stack, int argc) {
    float rot[4];

    if (argc != 1) {
        return 0;
    }

    if (action_info.chara->lock_on == 0) {
        SetStack(stack, 0);
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
        SetStack(stack, 1);
        return 1;
    }

    SetStack(stack, 0);
    return 1;
}

/**
 *
 * Turns the action character opposite its knockback vector.
 *
 */
int _SET_BLOW_ANGLE(RS_STACKDATA *stack, int argc) {
    if (argc != 0) {
        return 0;
    }

    CActionChara *chara = action_info.chara;
    float         angle = atan2f(-chara->blow_vec[0], -chara->blow_vec[2]);
    action_info.chara->SetRotation(0.0f, angle, 0.0f);
    return 1;
}

/**
 *
 * Sets a timed movement impulse in the character-relative direction.
 *
 */
int _SET_BLOW_MOVE(RS_STACKDATA *stack, int argc) {
    float rot[4];

    if (argc > 4) {
        return 0;
    }

    action_info.chara->add_speed = GetStackFloat(stack++);
    action_info.chara->add_decel = GetStackFloat(stack++);
    action_info.chara->add_time = GetStackInt(stack++);
    float yaw = 0.0f;

    if (argc == 4) {
        yaw = 0.017453292f * GetStackFloat(stack);
    }

    action_info.chara->GetRotation(rot);
    yaw += rot[1];

    if (yaw > 3.1415927f) {
        yaw -= 6.2831855f;
    }

    if (yaw < -3.1415927f) {
        yaw += 6.2831855f;
    }

    float dir[4] = {0.0f, 0.0f, 1.0f, 1.0f};
    float matrix[4][4];
    sceVu0UnitMatrix(matrix);
    sceVu0RotMatrixY(matrix, matrix, yaw);
    sceVu0ApplyMatrix(dir, matrix, dir);
    sceVu0CopyVector(action_info.chara->add_vec, dir);
    return 1;
}

/**
 *
 * Starts a timed knockback with speed, deceleration and duration from the script.
 *
 */
static int _BLOW_START(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }

    action_info.chara->blow_speed = GetStackFloat(stack++);
    action_info.chara->blow_speed =
        action_info.chara->blow_speed * action_info.chara->blow_rate;
    action_info.chara->blow_decel = GetStackFloat(stack++);
    action_info.chara->blow_time = GetStackInt(stack);
    return 1;
}

/**
 *
 * Registers a named damage attack and sets its power rate.
 *
 */
static int _SET_DMG2(RS_STACKDATA *stack, int argc) {
    if (argc < 8 || argc > 9) {
        return 0;
    }

    char *first = GetStackString(stack++);
    char *second = GetStackString(stack++);
    char *attack = GetStackString(stack++);
    float damage = 2.0f * GetStackFloat(stack++);
    float rate = GetStackFloat(stack++);
    char *hit_effect = GetStackString(stack++);
    float knockback = GetStackFloat(stack++);
    float lift = GetStackFloat(stack++);
    char *extra = NULL;

    if (argc == 9) {
        extra = GetStackString(stack);
    }

    LastCInfo2 = action_info.chara->EntryDamage2(
        first, second, attack, damage, hit_effect, knockback, lift, extra);

    if (LastCInfo2 == NULL) {
        printf("CACT:DMG_ENTRY_ERR %s\n", attack);
        return 0;
    }

    LastCInfo2->power_rate = rate;
    return 1;
}

/**
 *
 * Registers a named frame as an action object slot.
 *
 */
static int _SET_OBJ(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int   number = GetStackInt(stack++);
    char *name = GetStackString(stack);

    if (action_info.chara->EntryObject(name, number) == 0) {
        printf("not found %s\n", name);
        return 0;
    }

    return 1;
}

/**
 *
 * Registers a body collision primitive for the action character.
 *
 */
static int _SET_BODY(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int number = GetStackInt(stack++);
    return action_info.chara->EntryBodyCol(number, 2.0f * GetStackFloat(stack)) != 0;
}

/**
 *
 * Schedules a sword effect between named frames during a motion.
 *
 */
static int _SW_EFFECT(RS_STACKDATA *stack, int argc) {
    if (argc < 9 || argc > 10) {
        return 0;
    }

    ACTION_SW_EFFECT *effect = action_info.chara->GetSwEffectPtr();

    if (effect == NULL) {
        return 0;
    }

    int slot = GetStackInt(stack++);

    if (slot < 0 || slot > 2) {
        return 0;
    }

    if (action_info.chara->sword_effect[slot] == NULL) {
        return 0;
    }

    char *name = GetStackString(stack++);
    float start = GetStackFloat(stack++);
    float end = GetStackFloat(stack++);
    char *first = GetStackString(stack++);
    char *second = GetStackString(stack++);
    int   flag_a = GetStackInt(stack++);
    int   flag_b = GetStackInt(stack++);
    int   flag_c = GetStackInt(stack++);
    char *extra = NULL;

    if (argc == 10) {
        extra = GetStackString(stack);
    }

    effect->sword_no = slot;
    effect->motion = name;
    effect->chara = extra;
    effect->start = start;
    effect->end = end;
    effect->frame0 = first;
    effect->frame1 = second;
    effect->length = flag_a;
    effect->hold_time = flag_b;
    effect->fade_time = flag_c;
    effect->wait = 0;
    action_info.chara->sw_effect_num++;
    return 1;
}

/**
 *
 * Schedules a sound effect between frames of a named motion.
 *
 */
int _SET_SND(RS_STACKDATA *stack, int argc) {
    int   sound_id = GetStackInt(stack++);
    char *motion = GetStackString(stack++);
    float start_time = GetStackFloat(stack++);
    float end_time = GetStackFloat(stack++);
    char *wait = NULL;

    if (argc > 4) {
        wait = GetStackString(stack);
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

/**
 *
 * Associates an action object frame and effect number with the charge effect.
 *
 */
int _SET_ACCUME_FX(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    if (action_info.chara->accume_effect == NULL) {
        return 0;
    }

    int       index = GetStackInt(stack++);
    int       effect_no = GetStackInt(stack);
    mgCFrame *effect = action_info.chara->object[index].frame;

    if (effect == 0) {
        return 0;
    }

    action_info.chara->accume.frame = effect;
    action_info.chara->accume.unk_4 = effect_no;
    action_info.chara->accume.active = 0;
    return 1;
}

/**
 *
 * Changes the action character charge effect mode and input accumulation state.
 *
 */
int _SET_ACCUME_FLAG(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    if (action_info.chara->accume_effect == NULL) {
        return 0;
    }

    int mode = GetStackInt(stack);

    switch (mode) {
        case 1: {
            int         i;
            AccumeSlot *slot = (AccumeSlot *) action_info.chara->accume_effect;
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
                printf("err1\n");
            }

            action_info.chara->accume.active = 1;
            break;
        }
        case 0:
            ((AccumeSlot *) action_info.chara->accume_effect)->mode = mode;
            action_info.chara->acumu_pad = 0;
            action_info.chara->accume.active = 0;
            break;
        default:
            ((AccumeSlot *) action_info.chara->accume_effect)->mode = mode;

            if (mode == 3 || mode == 4) {
                action_info.chara->accume.active = 0;
            }

            break;
    }

    return 1;
}

/**
 *
 * Returns the current status of the targeted monster.
 *
 */
int _GET_MONSTER_NOWSTS(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    int status = 0;
    int monster_no = action_info.chara->target_no;

    if (monster_no != -1) {
        CActionChara *monster = (CActionChara *) nowScene__2->GetCharacter(monster_no);

        if (monster != NULL) {
            status = monster->now_status;
        }
    }

    SetStack(stack, status);
    return 1;
}

/**
 *
 * Sets the action character aggression value and its duration.
 *
 */
int _SET_MURDEROUS(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    action_info.chara->murderous = GetStackInt(stack++);
    action_info.chara->murderous_time = GetStackInt(stack);
    return 1;
}

/**
 *
 * Returns the distance from the action character to its target.
 *
 */
int _GET_TRG_DISTANCE(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    SetStack(stack, action_info.chara->GetTargetDist(nowScene__2));
    return 1;
}

/**
 *
 * Turns the action character toward a nearby target at a limited rate.
 *
 */
int _SET_TRG_ANGLE(RS_STACKDATA *stack, int argc) {
    float target_position[4];
    float position[4];
    float rotation_divisor;
    float radius;

    if (argc != 2) {
        return 0;
    }

    radius = GetStackFloat(stack++);
    rotation_divisor = GetStackFloat(stack);
    int target_no = action_info.chara->target_no;

    if (target_no == -1) {
        return 1;
    }

    CActiveMonster *target = (CActiveMonster *) nowScene__2->GetCharacter(target_no);

    if (target != NULL) {
        if (target->target_dist < (radius + radius) + target->GetBodyWidth()) {
            target->GetEntryObjectPos(0, 0, target_position);
            action_info.chara->GetPosition(position);
            target_position[0] -= position[0];
            target_position[1] = 0.0f;
            target_position[2] -= position[2];
            mgCFrame *frame = action_info.chara->CObjectFrame::frame;
            float     angle = atan2f(target_position[0], target_position[2]);
            float     rotation = unitRotation(frame, angle, rotation_divisor);
            action_info.chara->SetRotation(0.0f, rotation, 0.0f);
        }
    }

    return 1;
}

/**
 *
 * Sets the action character guard flag.
 *
 */
int _SET_GUARD_FLAG(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    action_info.chara->guard_flag = GetStackInt(stack);
    return 1;
}

/**
 *
 * Sets the action character invulnerability duration.
 *
 */
static int _SET_MUTEKI(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    action_info.chara->muteki_time = GetStackInt(stack);
    return 1;
}

/**
 *
 * Returns the type of object held by the action character.
 *
 */
int _CHECK_HAND_OBJ(RS_STACKDATA *stack, int argc) {
    SetStack(stack, action_info.chara->hold_type);
    return 1;
}

/**
 *
 * Runs the held item action and returns its result.
 *
 */
int _SET_ITEM_USED(RS_STACKDATA *stack, int argc) {
    SetStack(stack, action_info.chara->UsedItemAction());
    return 1;
}

/**
 *
 * Throws the item object held by the action character.
 *
 */
int _THROW_HAND_OBJECT(RS_STACKDATA *stack, int argc) {
    action_info.chara->ThrowItemObject();
    return 1;
}

/**
 *
 * Checks whether the action character can catch an enemy or perform a kick.
 *
 */
int _CHECK_CATCH(RS_STACKDATA *stack, int argc) {
    char *name = GetStackString(stack++);

    if (argc == 1) {
        action_info.chara->CheckEnemyCatch(name);
    }

    if (argc == 3) {
        int target = GetStackInt(stack++);
        name = (char *) action_info.chara->CheckKeri(name, target);
        SetStack(stack, (int) name);
    }

    return 1;
}

/**
 *
 * Releases or throws held characters and clears the held object state.
 *
 */
int _RELEASE_OBJ(RS_STACKDATA *stack, int argc) {
    float held_pos[4];
    float start_pos[4];
    float direction[4];
    float target_pos[4];
    int   throw_it = 0;

    if (argc == 1) {
        throw_it = GetStackInt(stack);
    }

    DNG_BATTLE_AREA *input;

    if (nowScene__2 != NULL && (input = &nowScene__2->battle_area) != NULL &&
        !(input->pause_flag & 0x2000)) {
        action_info.chara->Show(1, 1);
    }

    if (action_info.chara->hold_type == 1 && throw_it == 0) {
        action_info.chara->RemoveThrowItem();
    }

    int chara_no = 0x18;

    if (action_info.chara->hold_type == 3) {
        do {
            CActionChara *held = (CActionChara *) nowScene__2->GetCharacter(chara_no);

            if (held != NULL && held->catch_state == 1) {
                held->catch_frame->GetWorldPosition0(held_pos);
                held->CObjectFrame::frame->DeleteReference();
                held->SetPosition(held_pos);

                if (throw_it == 0) {
                    held->catch_frame = NULL;
                    held->catch_state = 0;
                    held->no_hit_time = 5;
                    ((CActiveMonster *) held)->req_prog = 0x4B0;
                } else {

                    (action_info.chara)->GetPosition(start_pos);
                    sceVu0CopyVector(direction, action_info.chara->front_vec);
                    direction[3] = 1.0f;
                    float distance = 100.0f;

                    if (action_info.chara->lock_on != 0) {
                        CActionChara *target = (CActionChara *) nowScene__2->GetCharacter(
                            action_info.chara->target_no);

                        if (target != NULL) {
                            target->GetEntryObjectPos(0, 0, target_pos);
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
                    float offset[4] = {0.0f, 0.0f, 0.0f, 1.0f};
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

/**
 *
 * Creates Monica ranged magic effect and its damage collision primitive.
 *
 */
void ShotMonicaMagic(float *position, float *direction, float scale) {
    char *effect_name;
    char *unused_name;
    int   effect_power;
    ((GetBattleCharaInfo()->equip + 1))
        ->GetEffectReadType(&effect_name, &unused_name, &effect_power);
    action_info.chara->effect_man->CreateEffSpt(effect_name, 0, 0);
    action_info.chara->effect_man->SetScriptVect1(position, 0, -1);
    action_info.chara->effect_man->SetScriptVect2(direction, 0, -1);
    float tint = (float) effect_power / 255.0f;
    tint *= 1.5f;
    action_info.chara->effect_man->SetValue(0, tint, -1, -1);
    action_info.chara->effect_man->SetScriptTargetId(action_info.chara->target_no, -1, -1);
    CColPrim *prim = ColPrimMan.GetPrim();

    if (prim != NULL) {
        prim->SetDamage("\x83\x82\x83j\x83J\x96\x82\x96@", 0);
        prim->range = 500.0f;
        SetDamageParam(prim, 1);
        prim->damage = fptosi((float) prim->damage * scale);
        action_info.chara->effect_man->SetColPrim(prim, -1, -1);
        calcWeaponParam2(5, prim->param->hit_count);
    }

    sndSePlay(action_info.chara->sound_info.se_bank, 13, 0);
}

/**
 *
 * Creates a normal gun shot effect and its damage collision primitive.
 *
 */
void ShotNormalGun(float *position, float *direction) {
    action_info.chara->effect_man->CreateEffSpt("\x8F" "e\x92" "e", 0, 0);
    action_info.chara->effect_man->SetScriptVect1(position, 0, -1);
    sceVu0ScaleVector(direction, direction, 20.0f);
    action_info.chara->effect_man->SetScriptVect2(direction, 0, -1);
    CColPrim *prim = ColPrimMan.GetPrim();

    if (prim != NULL) {
        prim->SetDamage("\x83\x86\x83\x8A\x83X\x8F" "e\x8DU\x8C\x82", 0);
        prim->range = 300.0f;
        SetDamageParam(prim, 1);
        action_info.chara->effect_man->SetColPrim(prim, -1, -1);
        calcWeaponParam2(1, prim->param->hit_count);
    }

    action_info.chara->effect_man->CreateEffSpt("\x83}\x83Y\x83\x8B\x83t\x83\x89\x83" "b\x83V\x83\x85", 0, 0);
    action_info.chara->effect_man->SetScriptVect1(position, 0, -1);
    sndSePlay(action_info.chara->sound_info.se_bank, 5, 0);
}

/**
 *
 * Creates a machine gun shot and stores its collision primitive for the active burst.
 *
 */
void ShotMachineGun(float *position, float *direction, char *damage_name, float damage) {
    MachineGun.Set(position, direction);
    CColPrim *prim = ColPrimMan.GetPrim();
    int       col_prim_id = -1;

    if (prim != NULL) {
        prim->SetDamage(damage_name, 0);
        prim->SetCoord(position, position, 5.0f);
        prim->range = damage;
        SetDamageParam(prim, 1);
        col_prim_id = prim->id;
        calcWeaponParam2(1, prim->param->hit_count);
    }

    MachineGun.col_prim_id[MachineGun.index] = col_prim_id;
    action_info.chara->effect_man->CreateEffSpt("\x83}\x83Y\x83\x8B\x83t\x83\x89\x83" "b\x83V\x83\x85", 0, 0);
    action_info.chara->effect_man->SetScriptVect1(position, 0, -1);
    CActionChara *owner = action_info.chara;

    if (owner->sound_info.loop_se != NULL) {
        owner->sound_info.loop_se->SeLoopPlayStop(owner->sound_info.se_bank, 5, 5, 13);
    }
}

/**
 *
 * Creates a grenade projectile with a linked damage collision primitive.
 *
 */
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
        int       col_prim_id = -1;

        if (prim != NULL) {
            prim->SetDamage("\x83O\x83\x8C\x83l\x81[\x83hG", 0);
            prim->SetCoord(position, 5.0f);
            prim->range = 500.0f;
            SetDamageParam(prim, 1);
            col_prim_id = prim->id;
            calcWeaponParam2(1, prim->param->hit_count);
        }

        launcher->col_prim_id = col_prim_id;
    }

    action_info.chara->effect_man->CreateEffSpt("\x83}\x83Y\x83\x8B\x83t\x83\x89\x83" "b\x83V\x83\x85", 0, 0);
    action_info.chara->effect_man->SetScriptVect1(position, 0, -1);
    sndSePlay(action_info.chara->sound_info.se_bank, 5, 0);
}

/**
 *
 * Creates a colored laser projectile with a linked damage collision primitive.
 *
 */
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
        int       col_prim_id = -1;

        if (prim != NULL) {
            prim->SetDamage("\x83\x8C\x81[\x83U\x81[G", 0);
            prim->SetCoord(muzzle, 5.0f);
            prim->range = 500.0f;
            SetDamageParam(prim, 1);
            col_prim_id = prim->id;
            calcWeaponParam2(1, prim->param->hit_count);
        }

        laser->col_prim_id = col_prim_id;
    }

    action_info.chara->effect_man->CreateEffSpt("\x83}\x83Y\x83\x8B\x83t\x83\x89\x83" "b\x83V\x83\x85", 0, 0);
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
    sndSePlay(action_info.chara->sound_info.se_bank, 5, 0);
}

int _SET_SHOT(RS_STACKDATA *stack, int argc) {
    float position[4];
    float direction[4];
    int whp[2];
    int magic_whp[2];
    int object_no;
    int wait;
    float scale;
    CBattleCharaInfo *info;
    mgCFrame *muzzle;
    mgCFrame *grip;
    CGameDataUsed *equip;
    int attack_type;
    int laser;

    if (argc < 4 || argc > 5) {
        return 0;
    }
    object_no = GetStackInt(stack++);
    GetStackString(stack++);
    GetStackInt(stack++);
    wait = GetStackInt(stack++);
    scale = 1.0f;
    if (argc == 5) {
        scale = GetStackFloat(stack);
    }
    info = GetBattleCharaInfo();
    int chara = info->chr_no;
    sceVu0CopyVector(direction, action_info.chara->front_vec);
    sceVu0CopyVector(position, action_info.chara->object[object_no].pos);
    if (chara == USER_CHARA_MAX) {
        info->GetNowWhp(1, whp);
        muzzle = action_info.chara->SearchObject("sp");
        grip = action_info.chara->SearchObject("gcol00");
        if (muzzle != NULL && grip != NULL) {
            muzzle->GetWorldPosition0(direction);
            grip->GetWorldPosition0(position);
            sceVu0SubVector(direction, direction, position);
            sceVu0Normalize(direction, direction);
        }
        equip = info->equip;
        attack_type = equip[1].GetAttackType();
        if (whp[0] > 0) {
            if (attack_type == 0 || attack_type == 11) {
                if (action_info.chara->shot_wait > 0) {
                    return 1;
                }
                action_info.chara->shot_wait = wait;
                ShotNormalGun(position, direction);
            }
            if (attack_type == 30) {
                ShotMachineGun(position, direction, "\x82x\x83}\x83V\x83\x93\x83K\x83\x93", 300.0f);
            }
            if (attack_type == 10) {
                ShotGrenadGun(position, direction);
            }
            if (attack_type == 20) {
                laser = 0;
                if (equip[1].item_no == 0x1F) {
                    laser = 0;
                }
                if (equip[1].item_no == 0x20) {
                    laser = 1;
                }
                if (equip[1].item_no == 0x22) {
                    laser = 2;
                }
                ShotLaserGun(position, direction, laser);
            }
        } else {
            sndSePlay(action_info.chara->sound_info.se_bank, 4, 0);
        }
    }
    if (chara == USER_CHARA_MONICA) {
        if (action_info.chara->shot_wait > 0) {
            return 1;
        }
        action_info.chara->shot_wait = wait;
        info->GetNowWhp(1, magic_whp);
        if (magic_whp[0] > 0) {
            ShotMonicaMagic(position, direction, scale);
        }
    }
    return 1;
}
/**
 *
 * Fires a charged magic sword projectile from a named action object.
 *
 */
int _SET_SPECIAL_SHOT(RS_STACKDATA *stack, int argc) {
    float facing[4];
    float position[4];
    float direction[4];

    if (argc != 1) {
        return 0;
    }

    char             *object_name = GetStackString(stack);
    CBattleCharaInfo *info = GetBattleCharaInfo();

    if (info->GetMagicSwordCounterNow() <= 0) {
        return 1;
    }

    if (action_info.chara->shot_wait > 0) {
        return 1;
    }

    action_info.chara->shot_wait = 5;
    mgCFrame *object = action_info.chara->SearchObject(object_name);

    if (object == 0) {
        return 0;
    }

    sceVu0CopyVector(facing, action_info.chara->front_vec);
    object->GetWorldPosition0(position);
    sceVu0CopyVector(direction, action_info.chara->front_vec);
    char *effects[4] = {"\x83\x82\x83j\x83J\x96\x82\x96@\x81|\x89\xCE", "\x83\x82\x83j\x83J\x96\x82\x96@\x81|\x95X", "\x83\x82\x83j\x83J\x96\x82\x96@\x81|\x97\x8B", "\x83\x82\x83j\x83J\x96\x82\x96@\x81|\x95\x97"};
    action_info.chara->effect_man->CreateEffSpt(effects[info->GetMagicSwordElem()], 0, 0);
    action_info.chara->effect_man->SetScriptVect1(position, 0, -1);
    action_info.chara->effect_man->SetScriptVect2(direction, 0, -1);
    action_info.chara->effect_man->SetValue(0, 0.0f, -1, -1);
    action_info.chara->effect_man->SetScriptTargetId(action_info.chara->target_no, -1, -1);
    CColPrim *prim = ColPrimMan.GetPrim();

    if (prim != NULL) {
        prim->SetDamage("\x83\x82\x83j\x83J\x96\x82\x96@", 0);
        prim->damage = info->GetMagicSwordPow();
        prim->element[info->GetMagicSwordElem()] = 100;
        prim->element[info->GetMagicSwordElem()] = 100;
        action_info.chara->effect_man->SetColPrim(prim, -1, -1);
    }

    info->ClearMagicSwordPow();
    return 1;
}
int _SHOT(RS_STACKDATA *stack, int argc) {
    float position[4];
    float target_pos[4];
    float direction[4];

    CBattleCharaInfo *info = GetBattleCharaInfo();
    int left = GetStackInt(stack);
    if (action_info.chara->shot_wait > 0) {
        return 1;
    }
    action_info.chara->shot_wait = 2;
    int attack_type = info->equip[0].GetAttackType();
    static int sw = 1;
    static int canon_slot = 0;
    mgCFrame *muzzle;
    mgCFrame *barrel;
    if (attack_type != 40) {
        if (attack_type == 90) {
            if (left != 0) {
                muzzle = action_info.chara->SearchObject("dcol01");
            } else {
                muzzle = action_info.chara->SearchObject("dcol00");
            }
        } else if (sw != 0) {
            muzzle = action_info.chara->SearchObject("dcol00");
            sw = 0;
        } else {
            muzzle = action_info.chara->SearchObject("dcol01");
            sw = 1;
        }
        if (muzzle == NULL) {
            return 0;
        }
        muzzle->GetWorldPosition0(position);
    } else {
        CanonObjectNames canon = {{{"dcol_rf00", "dcol_rf01"},
                                   {"dcol_lf00", "dcol_lf01"},
                                   {"dcol_rb00", "dcol_rb01"},
                                   {"dcol_lb00", "dcol_lb01"}}};
        muzzle = action_info.chara->SearchObject(canon.name[canon_slot][0]);
        barrel = action_info.chara->SearchObject(canon.name[canon_slot][1]);
        canon_slot++;
        if (canon_slot >= 4) {
            canon_slot = 0;
        }
        if (muzzle == NULL || barrel == NULL) {
            return 0;
        }
        muzzle->GetWorldPosition0(position);
        barrel->GetWorldPosition0(target_pos);
    }
    float rocket_target[4];
    float missile_target[4];
    float laser_target[4];
    float beam_target[4];
    int whp[2];
    float beam_offset[4];
    sceVu0CopyVector(direction, action_info.chara->front_vec);
    info->GetNowWhp(1, whp);
    if (whp[0] > 0) {
        if (attack_type == 10) {
            sceVu0ScaleVector(rocket_target, direction, 500.0f);
            sceVu0AddVector(rocket_target, position, rocket_target);
            CRocketLauncher *launcher = RocketLauncher.Get();
            if (launcher != NULL) {
                launcher->SetPos(position, rocket_target, direction);
                launcher->target_chara = action_info.chara->target_no;
                launcher->speed = 20.0f;
                launcher->homing_delay = 2;
                launcher->homing_time = 30;
                CColPrim *prim = ColPrimMan.GetPrim();
                int col_prim_id = -1;
                if (prim != NULL) {
                    prim->SetDamage("\x83\x8D\x83{\x83L\x83\x83\x83m\x83\x93", 0);
                    prim->SetCoord(position, 10.0f);
                    SetDamageParam(prim, 1);
                    col_prim_id = prim->id;
                    calcWeaponParam2(1, prim->param->hit_count);
                    sndSePlay(action_info.chara->sound_info.se_bank, 7, 0);
                }
                launcher->col_prim_id = col_prim_id;
            }
        }
        if (attack_type == 30) {
            ShotMachineGun(position, direction, "\x83\x8D\x83{\x83}\x83V\x83\x93\x83K\x83\x93", 500.0f);
            static int cnt = 0;
            cnt++;
            if (cnt > 2) {
                cnt = 0;
                CLoopSeMngr *sounds = action_info.chara->sound_info.loop_se;
                if (sounds != NULL) {
                    sounds->SeLoopPlayStop(action_info.chara->sound_info.se_bank, 6, 10, 13);
                }
            }
        }
        if (attack_type == 70) {
            sceVu0ScaleVector(missile_target, direction, 500.0f);
            sceVu0AddVector(missile_target, position, missile_target);
            direction[0] += direction[2] * (fRand(1.0f) - 0.5f);
            direction[2] += direction[0] * (fRand(1.0f) - 0.5f);
            direction[1] += fRand(1.0f);
            CRocketLauncher *launcher = RocketLauncher.Get();
            if (launcher != NULL) {
                launcher->SetPos(position, missile_target, direction);
                launcher->target_chara = action_info.chara->target_no;
                CColPrim *prim = ColPrimMan.GetPrim();
                int col_prim_id = -1;
                if (prim != NULL) {
                    prim->SetDamage("\x83\x8D\x83{\x83\x89\x83\x93\x83`\x83\x83", 0);
                    prim->SetCoord(position, 5.0f);
                    SetDamageParam(prim, 1);
                    col_prim_id = prim->id;
                    calcWeaponParam2(1, prim->param->hit_count);
                    sndSePlay(action_info.chara->sound_info.se_bank, 7, 0);
                }
                launcher->col_prim_id = col_prim_id;
            }
        }
        if (attack_type == 40) {
            sceVu0ScaleVector(laser_target, direction, 500.0f);
            sceVu0AddVector(laser_target, position, laser_target);
            sceVu0SubVector(direction, target_pos, position);
            sceVu0Normalize(direction, direction);
            CLaserGun *laser = LaserGun.Get();
            if (laser != NULL) {
                laser->SetPos(position, laser_target, direction);
                laser->target_chara = action_info.chara->target_no;
                laser->SetVisualCode(3);
                CColPrim *prim = ColPrimMan.GetPrim();
                int col_prim_id = -1;
                if (prim != NULL) {
                    prim->SetDamage("\x83\x8D\x83{\x83\x8C\x81[\x83U\x81[", 0);
                    prim->SetCoord(position, 5.0f);
                    SetDamageParam(prim, 1);
                    col_prim_id = prim->id;
                    calcWeaponParam2(1, prim->param->hit_count);
                    sndSePlay(action_info.chara->sound_info.se_bank, 7, 0);
                }
                laser->col_prim_id = col_prim_id;
                action_info.chara->effect_man->CreateEffSpt("\x83}\x83Y\x83\x8B\x83t\x83\x89\x83" "b\x83V\x83\x85", 0, 0);
                action_info.chara->effect_man->SetScriptVect1(position, 0, -1);
                action_info.chara->effect_man->SetValue(0, 1, 0, -1);
                action_info.chara->effect_man->SetValue(1, 0.0f, 0, -1);
                action_info.chara->effect_man->SetValue(2, 128.0f, 0, -1);
                action_info.chara->effect_man->SetValue(3, 128.0f, 0, -1);
                action_info.chara->effect_man->SetValue(4, 160.0f, 0, -1);
                action_info.chara->shot_wait = 4;
            }
        }
        if (attack_type == 90) {
            sceVu0ScaleVector(beam_target, direction, 500.0f);
            sceVu0AddVector(beam_target, position, beam_target);
            sceVu0ScaleVector(beam_offset, direction, 20.0f);
            sceVu0AddVector(position, position, beam_offset);
            CLaserGun *laser = LaserGun.Get();
            if (laser != NULL) {
                laser->SetPos(position, beam_target, direction);
                laser->target_chara = action_info.chara->target_no;
                laser->SetVisualCode(4);
                CColPrim *prim = ColPrimMan.GetPrim();
                int col_prim_id = -1;
                if (prim != NULL) {
                    prim->SetDamage("\x83\x8D\x83{\x83\x8C\x81[\x83U\x81[", 0);
                    prim->SetCoord(position, 5.0f);
                    SetDamageParam(prim, 1);
                    col_prim_id = prim->id;
                    calcWeaponParam2(1, prim->param->hit_count);
                }
                laser->col_prim_id = col_prim_id;
                action_info.chara->effect_man->CreateEffSpt("\x83}\x83Y\x83\x8B\x83t\x83\x89\x83" "b\x83V\x83\x85", 0, 0);
                action_info.chara->effect_man->SetScriptVect1(position, 0, -1);
                action_info.chara->effect_man->SetValue(0, 1, 0, -1);
                action_info.chara->effect_man->SetValue(1, 128.0f, 0, -1);
                action_info.chara->effect_man->SetValue(2, float(64.0), 0, -1);
                action_info.chara->effect_man->SetValue(3, float(0.0), 0, -1);
                action_info.chara->effect_man->SetValue(4, float(160.0), 0, -1);
                action_info.chara->shot_wait = 4;
            }
        }
    }
    return 1;
}
/**
 *
 * Writes the world position of a named action object to script outputs.
 *
 */
int _GET_OBJECT_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];

    if (argc != 4) {
        return 0;
    }

    RS_STACKDATA *next = stack + 1;
    mgCFrame     *object = action_info.chara->SearchObject(GetStackString(stack));

    if (object == 0) {
        return 0;
    }

    object->GetWorldPosition0(pos);
    SetStack(next++, pos[0]);
    SetStack(next++, pos[1]);
    SetStack(next, pos[2]);
    return 1;
}

/**
 *
 * Enables directional gun aiming for the action character.
 *
 */
int _SET_DIR_GUN(RS_STACKDATA *stack, int argc) {
    action_info.chara->dir_gun = 1;
    return 1;
}

/**
 *
 * Returns the current battle character HP divided by maximum HP.
 *
 */
int _GET_NOW_HP_RATE(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    CBattleCharaInfo *info = GetBattleCharaInfo();
    int               now_hp = info->GetNowHp_i();
    int               rate = now_hp / info->GetMaxHp_i();
    SetStack(stack, (float) rate);
    return 1;
}

/**
 *
 * Reduces the battle character HP to five percent.
 *
 */
int _SET_BOMB(RS_STACKDATA *stack, int argc) {
    GetBattleCharaInfo()->SetHpRate(0.05f);
    return 1;
}

/**
 *
 * Returns the model number of the battle character primary equipment.
 *
 */
int _GET_ACTION_CODE(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    argc = GetBattleCharaInfo()->GetEquipTablePtr(0)->GetModelNo();
    SetStack(stack, argc);
    return 1;
}

/**
 *
 * Returns the attack status value of a selected weapon parameter slot.
 *
 */
int _GET_ATTK_POINT(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int                  index = GetStackInt(stack++);
    BATTLE_WEAPON_PARAM *slots = GetBattleCharaInfo()->weapon_param;
    SetStack(stack, slots[index].status[0]);
    return 1;
}

/**
 *
 * Returns the RGB color of the equipped ring effect.
 *
 */
int _GET_RING_COLOR(RS_STACKDATA *stack, int argc) {
    char *effect_name;
    char *unused_name;
    int   effect_power;

    if (argc != 3) {
        return 0;
    }

    int type = ((GetBattleCharaInfo()->equip + 1))
                   ->GetEffectReadType(&effect_name, &unused_name, &effect_power);

    if (type < 0 || type > 3) {
        return 0;
    }

    RingColors colors = {{{255, 64, 64}, {128, 255, 255}, {128, 64, 255}, {96, 255, 160}}};
    SetStack(stack++, colors.rgb[type][0]);
    SetStack(stack++, colors.rgb[type][1]);
    SetStack(stack, colors.rgb[type][2]);
    return 1;
}

/**
 *
 * Starts a named motion on the action character or a named linked character.
 *
 */
static int _SET_MOS(RS_STACKDATA *stack, int argc) {
    char         *motion = NULL;
    char         *chara_name = NULL;
    int           flag = 0;
    float         speed = -1.0f;
    CActionChara *target;

    if (argc <= 0 || argc > 4) {
        return 0;
    }

    if (argc > 0) {
        motion = GetStackString(stack++);
    }

    if (argc >= 2) {
        speed = GetStackFloat(stack++);
    }

    if (argc >= 3) {
        flag = GetStackInt(stack++);
    }

    if (argc == 4) {
        chara_name = GetStackString(stack);
    }

    if (motion == NULL) {
        return 0;
    }

    target = action_info.chara;

    if (chara_name != NULL) {
        target = target->SearchChara(chara_name);

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

/**
 *
 * Reports whether the current or named motion has ended.
 *
 */
static int _CHECK_MOS_END(RS_STACKDATA *stack, int argc) {
    float result;

    if (argc == 1) {
        result = action_info.chara->CheckMotionEnd(0);
    }

    if (argc == 2) {
        char *name = GetStackString(stack + 1);

        if (name == NULL) {
            return 0;
        }

        result = action_info.chara->CheckMotionEnd(name);
    }

    SetStack(stack, result);
    return 1;
}

/**
 *
 * Returns the remaining frame wait of the current or named motion.
 *
 */
static int _NOW_MOS_WAIT(RS_STACKDATA *stack, int argc) {
    float result;

    if (argc == 1) {
        result = action_info.chara->GetNowFrameWait(0);
    }

    if (argc == 2) {
        char *name = GetStackString(stack + 1);

        if (name == NULL) {
            return 0;
        }

        result = action_info.chara->GetNowFrameWait(name);
    }

    SetStack(stack, result);
    return 1;
}

/**
 *
 * Returns the action character motion change wait.
 *
 */
int _NOW_MOS_CHGWAIT(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    SetStack(stack, action_info.chara->GetChgStepWait());
    return 1;
}

/**
 *
 * Returns the status of the current or named motion.
 *
 */
static int _GET_MOS_STATUS(RS_STACKDATA *stack, int argc) {
    int status;

    if (argc == 1) {
        status = action_info.chara->GetMotionStatus(NULL);
    }

    if (argc == 2) {
        char *name = GetStackString(stack + 1);

        if (name == NULL) {
            return 0;
        }

        status = action_info.chara->GetMotionStatus(name);
    }

    SetStack(stack, status);
    return 1;
}

/**
 *
 * Sets the action character motion blend speed.
 *
 */
int _SET_XCHG_STEP(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    float         value = GetStackFloat(stack);
    CActionChara *chara = action_info.chara;
    chara->blend_speed = value;

    if (value >= 1.0f) {
        chara->blend = 1.0f;
    }

    return 1;
}

/**
 *
 * Sets the playback step of the action character motion.
 *
 */
int _SET_MOS_STEP(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    action_info.chara->SetStep(GetStackFloat(stack));
    return 1;
}

/**
 *
 * Requests advancement of the action character motion sequence.
 *
 */
int _TRG_ON_MOS(RS_STACKDATA *stack, int argc) {
    action_info.chara->seq_advance = 1;
    return 1;
}

/**
 *
 * Resets the action character motion.
 *
 */
int _RESET_MOS(RS_STACKDATA *stack, int argc) {
    action_info.chara->ResetMotion();
    return 1;
}

/**
 *
 * Sets the default motion name for the action character.
 *
 */
int _SET_DEFAULT_MOS(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    action_info.chara->default_motion = GetStackString(stack);
    return 1;
}

/**
 *
 * Slows motion playback when the battle character has the selected status attribute.
 *
 */
int _SET_NEBA2(RS_STACKDATA *stack, int argc) {
    if ((GetBattleCharaInfo())->GetAttr() & 2) {
        action_info.chara->SetStep(0.7f * action_info.chara->GetDefaultStep());
    }

    return 1;
}

/**
 *
 * Creates a named effect script and optionally returns its effect slot.
 *
 */
static int _ESM_CREATE(RS_STACKDATA *stack, int argc) {
    if (action_info.chara->effect_man == NULL) {
        return 0;
    }

    char *name = GetStackString(stack++);

    switch (argc) {
        case 1:
            action_info.chara->effect_man->CreateEffSpt(name, 0, 0);
            break;
        case 2: {
            int id = action_info.chara->effect_man->CreateEffSpt(name, 0, 1);

            if (id <= -1) {
                return 0;
            }

            SetStack(stack, id);
            break;
        }
    }

    return 1;
}

/**
 *
 * Sets the first script vector of an effect slot.
 *
 */
static int _ESM_SET_VECT1(RS_STACKDATA *stack, int argc) {
    float vect[4];

    if (action_info.chara->effect_man == NULL) {
        return 0;
    }

    int index = GetStackInt(stack++);
    vect[0] = GetStackFloat(stack++);
    vect[1] = GetStackFloat(stack++);
    vect[2] = GetStackFloat(stack);
    vect[3] = 1.0f;

    if (index >= 0) {
        return action_info.chara->effect_man->SetScriptVect1(vect, 0, index);
    }

    return action_info.chara->effect_man->SetScriptVect1(vect, 0, -1);
}

/**
 *
 * Sets the second script vector of an effect slot.
 *
 */
static int _ESM_SET_VECT2(RS_STACKDATA *stack, int argc) {
    float vect[4];

    if (action_info.chara->effect_man == NULL) {
        return 0;
    }

    int index = GetStackInt(stack++);
    vect[0] = GetStackFloat(stack++);
    vect[1] = GetStackFloat(stack++);
    vect[2] = GetStackFloat(stack);
    vect[3] = 1.0f;

    if (index >= 0) {
        return action_info.chara->effect_man->SetScriptVect2(vect, 0, index);
    }

    return action_info.chara->effect_man->SetScriptVect2(vect, 0, -1);
}

/**
 *
 * Requests the finish program for an effect script slot.
 *
 */
static int _ESM_FINISH(RS_STACKDATA *stack, int argc) {
    CEffectScriptMan *effect_script;
    int               effect_id;

    effect_id = GetStackInt(stack);

    if (effect_id < 0) {
        return 0;
    }

    effect_script = action_info.chara->effect_man;

    if (effect_script == NULL) {
        return 0;
    }

    effect_script->SetScriptProgNo(0x12C, 0, effect_id);
    return 1;
}

/**
 *
 * Deletes an effect script slot owned by the action character.
 *
 */
static int _ESM_DELETE(RS_STACKDATA *stack, int argc) {
    CEffectScriptMan *effect_script;
    int               effect_id;

    effect_id = GetStackInt(stack);

    if (effect_id < 0) {
        return 0;
    }

    effect_script = action_info.chara->effect_man;

    if (effect_script == NULL) {
        return 0;
    }

    effect_script->DeleteEffSpt(0, effect_id);
    return 1;
}

/**
 *
 * Sets an integer or float value in an effect script slot.
 *
 */
static int _ESM_SET_VALUE(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }

    int prog_no = GetStackInt(stack++);
    int value_no = GetStackInt(stack++);
    int result;

    switch (stack->type) {
        case 0:
            result = action_info.chara->effect_man->SetValue(value_no, GetStackInt(stack), 0, prog_no);
            break;
        case 1:
            result =
                action_info.chara->effect_man->SetValue(value_no, GetStackFloat(stack), 0, prog_no);
            break;
        default:
            return 0;
    }

    return result;
}

/**
 *
 * Loads an action script with allocated stack and call data and registers its external functions.
 *
 */
int SetActionScript(CRunScript *script, char *program, mgCMemory *memory) {
    RS_STACKDATA *stack = (RS_STACKDATA *) memory->Alloc(0x40);
    RS_CALLDATA  *call_data = (RS_CALLDATA *) memory->Alloc(0x180);
    script->load((RS_PROG_HEADER *) program, stack, 0x80, call_data, 0x200);
    script->ext_func(ext_func, 0x100);
    return 1;
}

/**
 *
 * Builds the action script external function lookup table.
 *
 */
void SetActionExtendTable() {
    int i;
    int j;

    for (i = 0; i < 256; i++) {
        ext_func[i] = NULL;
    }

    for (i = 0;; i++) {
        if (ext_func_info[i].func == NULL) {
            break;
        }

        if (0 < i) {
            j = 0;

            do {
                if (ext_func_info[i].no == ext_func_info[j].no) {
                    printf("chr]same ext_func_no!!!\n");

                    while (1) {
                    }
                }

                j++;
            } while (j < i);
        }

        if (ext_func_info[i].no < 0 || ext_func_info[i].no >= 256) {
            printf("ext func over!!");
        } else {
            ext_func[ext_func_info[i].no] = ext_func_info[i].func;
        }
    }
}

/**
 *
 * Calculates an initial velocity between two points for a timed parabolic flight.
 *
 */
void ParabolicInitialVector(float *result, float *from, float *to, float gravity, float flight_time) {
    float fall_distance = gravity * flight_time;
    result[0] = (to[0] - from[0]) / flight_time;
    result[1] = (2.0f * (to[1] - from[1]) - flight_time * fall_distance) / (2.0f * flight_time);
    result[2] = (to[2] - from[2]) / flight_time;
    result[3] = 1.0f;
    result[1] *= -1.0f;
}
