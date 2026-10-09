#include "common.h"
#include "mw_runtime.h"

#include <libcdvd.h>

#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "actionchara.hpp"
#include "automap.hpp"
#include "cameracontrol.hpp"
#include "character.hpp"
#include "charasetup.hpp"
#include "collision.hpp"
#include "colprim.hpp"
#include "dataread.hpp"
#include "dng_event.hpp"
#include "dng_main.hpp"
#include "dngmenu.hpp"
#include "drawwin.hpp"
#include "editdata.hpp"
#include "editevent.hpp"
#include "editinfo.hpp"
#include "editmap.hpp"
#include "editmenu.hpp"
#include "effscript.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "eventsprite.hpp"
#include "gaiji.hpp"
#include "gamedata.hpp"
#include "gamepad.hpp"
#include "gameutil.hpp"
#include "gyorace.hpp"
#include "intersection.hpp"
#include "inventmn.hpp"
#include "mainloop.hpp"
#include "mapinfo.hpp"
#include "mapjump.hpp"
#include "mapparts.hpp"
#include "mapselect.hpp"
#include "menuaqua.hpp"
#include "menucommon.hpp"
#include "menudraw.hpp"
#include "menumain.hpp"
#include "menushop.hpp"
#include "mg_camera.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "monster.hpp"
#include "movie.hpp"
#include "nameregi.hpp"
#include "nd_meswin.hpp"
#include "nowload.hpp"
#include "npccfg.hpp"
#include "padcontrol.hpp"
#include "pot.hpp"
#include "quest.hpp"
#include "runscript_opcodes.hpp"
#include "savedata.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include "sphida.hpp"
#include "subgame.hpp"
#include "swordeffect.hpp"
#include "sysmes.hpp"
#include "userdata.hpp"
#include "vlgr_info.hpp"

/**
 *
 * File name extensions used by event script commands.
 *
 */
struct ExtensionTable {
    char *name[4]; /**< Extension names. */
};

/**
 *
 * Group, kind and identifiers of one VPK resource.
 *
 */
struct VpkEntry {
    int group; /**< Resource group. */
    int kind;  /**< Resource kind. */
    int id;    /**< Resource identifier. */
    int sub;   /**< Subresource identifier. */
};

/**
 *
 * VPK resource entries used by event scripts.
 *
 */
struct VpkTable {
    VpkEntry entry[164]; /**< Resource entries. */
};

/**
 *
 * Integer training values indexed by non-player character.
 *
 */
struct NpcTrainTable {
    int value[25][3]; /**< Training values. */
};

/**
 *
 * Floating point training values indexed by non-player character.
 *
 */
struct TrainNpcTable {
    float row[12][4]; /**< Training value rows. */
};

typedef int (*EventFunc)(RS_STACKDATA *, int);
/**
 * Argument script whose external commands are being executed.
 */
static CEventScriptArg *nowScriptArg;

extern CEventScriptArg   EventScriptArg;
/**
 * Dispatch slots for event script external commands.
 */
static EventFunc ext_func[0x5DC];

extern CEventSprite2     EventSprite2[0x30];
extern CSceneObjSeq      ObjectSeq[32];
extern CSceneCmrSeq      CameraSeq;
extern mgCMemory         BuffEventSnd;
extern mgCMemory         BuffEventSnd2;
extern CDngFreeMap       EventDngMap;
/**
 * Effect script manager controlled by the event script.
 */
static CEffectScriptMan *EventEffectScript;

/**
 * Sword trail effect controlled by the event script.
 */
static CSWordAfterImage *SwordEffect;

/**
 * Initializes the effect script manager controlled by an event.
 */
int _ESM_INITIALIZE(RS_STACKDATA *stack, int argc);

/**
 * Copies a monster into a scene character slot for an event script.
 */
int _COPY_MONS2SCNCHR(RS_STACKDATA *stack, int argc);

static int   GetStackInt(RS_STACKDATA *stack);
static float GetStackFloat(RS_STACKDATA *stack);
static char *GetStackString(RS_STACKDATA *stack);
static void  GetStackVector(float *vector, RS_STACKDATA *stack);
static void  SetStack(RS_STACKDATA *stack, int value);
static void  SetStack(RS_STACKDATA *stack, float value);

static CCameraControl *GetCamera();
static CCharacter2    *GetChara(int id);
static CSceneObjSeq   *GetObjSeq(int index);
static CEventSprite2  *GetEventSprite(int index);
static ClsMes         *GetMes(int id);
const int              hit_effect_num = 5;
const int              event_sprite2_num = 0x30;
const int              sprite_type_world = 1;
const float            sprite_ground_offset = 32.0f;
const int              status_no_shadow = 8;
const int              script_stack_slots = 0x20;
const int              script_call_slots = script_stack_slots;
const int              script_func_slots = 3;
const int              script_run_id = 0x64;
const float            raster_max = 3.1415927f;
const int              prim_sprite = 6;
const int              half_color = 0x80;
const int              hit_spark_num = 0x40;
const int              event_snd_buffer_size = 0x801;
const int              event_snd2_buffer_size = 0x141;

/**
 * Storage for secondary event sound banks.
 */
static u_long128 event_snd2_buff[event_snd2_buffer_size];

/**
 * Storage for event sound banks.
 */
static u_long128 event_snd_buff[event_snd_buffer_size];

const int              memory_name_max = 0x10;
const int              pack_file_max = 0x80;
const int              type_loaded = 2;
const int              event_func_slots = 0x5DC;
const int              object_seq_num = 32;
const int              exit_edit_mode = 17;
const int              event_stream = 1;
const int              stream_max_volume = 0x7FFF;
const int              vpk_entry_count = 164;
const int              chara_sword_after_offset = 0x570;
const int              menu_dng_map = 3;
const int              menu_select_party = 4;
const int              menu_use_item = 9;
const int              menu_draw_chapter = 11;
const int              exit_start_loop = EVENT_REQUEST_GOTO;
const int              exit_enter_interior = EVENT_REQUEST_INTERIOR;
const int              exit_leave_interior = EVENT_REQUEST_OUTSIDE;
const int              exit_map_jump = EVENT_REQUEST_MAP_JUMP;
const int              request_menu = EVENT_COMMAND_SUB_MODE;
const int              request_door = EVENT_COMMAND_DOOR;
const int              event_sprite2_size = 0x80;

// Code (.text)
CEoh::CEoh() {
    type = EOH_TYPE_NONE;
    scene_no = -1;
    world_coord = 1;
    chara = NULL;
    object = NULL;
    sprite = NULL;
    frame = NULL;
    func_point = NULL;
}

int CEoh::Set(int new_kind, CObject *new_object, int new_flag) {
    if (new_object == NULL) {
        return 0;
    }

    type = new_kind;

    if (type != EOH_TYPE_OBJECT) {
        return 0;
    }

    object = new_object;
    world_coord = new_flag;
    return 1;
}

int CEoh::Set(int new_kind, int new_chara_no, CCharacter2 *new_chara) {
    if (new_chara == 0) {
        return 0;
    }

    type = new_kind;

    switch (type) {
        case EOH_TYPE_CHARA:
            scene_no = new_chara_no;
            chara = new_chara;
            return 1;
        default:
            return 0;
    }
}

int CEoh::Set(int new_kind, CEventSprite2 *new_sprite) {
    if (new_sprite == 0) {
        return 0;
    }

    type = new_kind;

    switch (type) {
        case EOH_TYPE_SPRITE:
            sprite = new_sprite;
            return 1;
        default:
            return 0;
    }
}

int CEoh::Set(int new_kind, mgCFrame *new_frame) {
    if (new_frame == 0) {
        return 0;
    }

    type = new_kind;

    switch (type) {
        case EOH_TYPE_FRAME:
            frame = new_frame;
            return 1;
        default:
            return 0;
    }
}

int CEoh::Set(int new_kind, CFuncPoint *new_func_point) {
    if (new_func_point == 0) {
        return 0;
    }

    type = new_kind;

    switch (type) {
        case EOH_TYPE_FUNC_POINT:
            func_point = new_func_point;
            break;
        default:
            return 0;
    }

    return 1;
}

void VectMatMul(float *out, float *vec, float (*mat)[4]) {
    float result[4];

    result[0] = vec[0] * mat[0][0] + vec[1] * mat[1][0] + vec[2] * mat[2][0];
    result[1] = vec[0] * mat[0][1] + vec[1] * mat[1][1] + vec[2] * mat[2][1];
    result[2] = vec[0] * mat[0][2] + vec[1] * mat[1][2] + vec[2] * mat[2][2];
    result[3] = 1.0f;
    sceVu0CopyVector(out, result);
}

void CalcPosWorldCoord(float *pos) {
    float rotation[4][4];
    float rotated[4];

    if (SetWorldCoordFlg != 0) {
        mgRotMatrixXYZ(rotation, EdEventInfo.world_coord_rot);
        VectMatMul(rotated, pos, rotation);
        sceVu0AddVector(pos, EdEventInfo.world_coord_pos, rotated);
    }
}

void CalcPosWorldCoordGyaku(float *pos) {
    float rot[4];
    float matrix[4][4];
    float local[4];

    if (SetWorldCoordFlg != 0) {
        rot[0] = 0.0f;
        rot[1] = -EdEventInfo.world_coord_rot[1];
        rot[2] = 0.0f;
        rot[3] = 0.0f;
        mgRotMatrixXYZ(matrix, rot);
        sceVu0SubVector(local, pos, EdEventInfo.world_coord_pos);
        VectMatMul(pos, local, matrix);
    }
}

void SetCamWorldCoord(mgCCamera *camera) {
    float pos[4];
    float ref[4];

    if ((SetWorldCoordFlg != 0) && (camera != NULL)) {
        camera->GetPos(pos);
        camera->GetRef(ref);
        CalcPosWorldCoord(pos);
        CalcPosWorldCoord(ref);
        camera->SetPos(pos);
        camera->SetRef(ref);
    }
}

void SetCamWorldCoordGyaku(mgCCamera *camera) {

    float pos[4];
    float ref[4];

    if ((SetWorldCoordFlg != 0) && (camera != NULL)) {
        camera->GetPos(pos);
        camera->GetRef(ref);
        CalcPosWorldCoordGyaku(pos);
        CalcPosWorldCoordGyaku(ref);
        camera->SetPos(pos);
        camera->SetRef(ref);
    }
}

CEohMother::CEohMother() {
    int i;

    for (i = 0; i < EOH_NUM; i++) {
        CEoh *handle = &eoh[i];
        handle->type = EOH_TYPE_NONE;
        handle->scene_no = -1;
        handle->world_coord = 1;

        handle->object = 0;
        handle->chara = 0;
        handle->sprite = 0;
        handle->frame = 0;
        handle->func_point = 0;
    }
}

int CEohMother::Set(int slot, int unused, CObject *object, int flag) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    return eoh[slot].Set(EOH_TYPE_OBJECT, object, flag);
}

int CEohMother::Set(int slot, int kind, int chara_no, CCharacter2 *chara) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    return eoh[slot].Set(kind, chara_no, chara);
}

int CEohMother::Set(int slot, int kind, CEventSprite2 *sprite) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    return eoh[slot].Set(kind, sprite);
}

int CEohMother::Set(int slot, int kind, mgCFrame *frame) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    return eoh[slot].Set(kind, frame);
}

int CEohMother::Set(int slot, int kind, CFuncPoint *func_point) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    return eoh[slot].Set(kind, func_point);
}

int CEohMother::SetPos(int slot, float x, float y, float z) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            float pos[4];
            pos[0] = x;
            pos[1] = y;
            pos[2] = z;
            pos[3] = 1.0f;
            CalcPosWorldCoord(pos);
            x = pos[0];
            y = pos[1];
            z = pos[2];
            mgCObject *chara = eoh[slot].object;

            if (chara == NULL) {
                return 0;
            }

            chara->SetPosition(x, y, z);
            return 1;
        }
        case EOH_TYPE_OBJECT: {
            if (handle->world_coord != 0) {
                float pos[4];
                pos[0] = x;
                pos[1] = y;
                pos[2] = z;
                pos[3] = 1.0f;
                CalcPosWorldCoord(pos);
                x = pos[0];
                y = pos[1];
                z = pos[2];
            }

            mgCObject *object = eoh[slot].object;

            if (object == NULL) {
                return 0;
            }

            object->SetPosition(x, y, z);
            return 1;
        }
        case EOH_TYPE_SPRITE: {
            float  pos[4];
            float *pos_y = &pos[1];
            pos[0] = x;
            *pos_y = y;
            pos[2] = z;
            pos[3] = 1.0f;
            CEventSprite2 *&sprite = handle->sprite;

            if (sprite == NULL) {
                return 0;
            }

            if (sprite->GetType() == 0) {
                *pos_y += sprite_ground_offset;
                sprite->SetPosition(pos);
            } else if (sprite->GetType() == sprite_type_world) {
                CalcPosWorldCoord(pos);
                sprite->SetPosition(pos);
            }

            return 1;
        }
        case EOH_TYPE_FRAME: {
            float pos[4];
            pos[0] = x;
            pos[1] = y;
            pos[2] = z;
            pos[3] = 1.0f;
            mgCObject *frame = handle->object;

            if (frame == NULL) {
                return 0;
            }

            frame->SetPosition(pos);
            return 1;
        }
        case EOH_TYPE_FUNC_POINT: {
            if (handle->world_coord != 0) {
                float pos[4];
                pos[0] = x;
                pos[1] = y;
                pos[2] = z;
                pos[3] = 1.0f;
                CalcPosWorldCoord(pos);
                CFuncPoint *func_point = eoh[slot].func_point;

                if (func_point == NULL) {
                    return 0;
                }

                *(u_long128 *) func_point->position = *(u_long128 *) pos;
                func_point->frame.SetPosition(pos);
            }

            return 1;
        }
        default:
            return 0;
    }
}

int CEohMother::SetRot(int slot, float x, float y, float z) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            mgCObject *&chara = (mgCObject *&) handle->object;

            if (chara == NULL) {
                return 0;
            }

            x += EdEventInfo.world_coord_rot[0];
            y += EdEventInfo.world_coord_rot[1];
            z += EdEventInfo.world_coord_rot[2];
            y = mgAngleLimit(y);
            chara->SetRotation(x, y, z);
            return 1;
        }
        case EOH_TYPE_OBJECT: {
            mgCObject *&object = (mgCObject *&) handle->object;

            if (object == NULL) {
                return 0;
            }

            if (handle->world_coord != 0) {
                x += EdEventInfo.world_coord_rot[0];
                y += EdEventInfo.world_coord_rot[1];
                z += EdEventInfo.world_coord_rot[2];
                y = mgAngleLimit(y);
            }

            object->SetRotation(x, y, z);
            return 1;
        }
        case EOH_TYPE_FRAME: {
            mgCObject *frame = handle->object;

            if (frame == NULL) {
                return 0;
            }

            frame->SetRotation(x, y, z);
            return 1;
        }
        case EOH_TYPE_SPRITE: {
            CEventSprite2 *sprite = handle->sprite;

            if (sprite == NULL) {
                return 0;
            }

            sprite->SetRotZ(z);
            return 1;
        }
        case EOH_TYPE_FUNC_POINT: {
            CFuncPoint *&func_point = handle->func_point;

            if (func_point == NULL) {
                return 0;
            }

            x += EdEventInfo.world_coord_rot[0];
            y += EdEventInfo.world_coord_rot[1];
            z += EdEventInfo.world_coord_rot[2];
            y = mgAngleLimit(y);
            float rot[4];
            rot[0] = x;
            rot[1] = y;
            rot[2] = z;
            rot[3] = 1.0f;
            CFuncPoint *target = func_point;
            *(u_long128 *) target->rotation = *(u_long128 *) rot;
            target->frame.SetRotation(rot);
            return 1;
        }
        default:
            return 0;
    }
}

int CEohMother::GetPos(int slot, float *pos) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            mgCObject *chara = handle->object;

            if (chara == NULL) {
                return 0;
            }

            chara->GetPosition(pos);
            CalcPosWorldCoordGyaku(pos);
            return 1;
        }
        case EOH_TYPE_OBJECT: {
            mgCObject *object = handle->object;

            if (object == NULL) {
                return 0;
            }

            object->GetPosition(pos);

            if (eoh[slot].world_coord != 0) {
                CalcPosWorldCoordGyaku(pos);
            }

            return 1;
        }
        case EOH_TYPE_SPRITE: {
            CEventSprite2 *&sprite = handle->sprite;

            if (sprite == NULL) {
                return 0;
            }

            sprite->GetPosition(pos);

            if (sprite->GetType() == sprite_type_world) {
                CalcPosWorldCoordGyaku(pos);
            } else {
                pos[1] -= sprite_ground_offset;
            }

            return 1;
        }
        case EOH_TYPE_FRAME: {
            mgCObject *frame = handle->object;

            if (frame == NULL) {
                return 0;
            }

            frame->GetPosition(pos);
            return 1;
        }
        case EOH_TYPE_FUNC_POINT: {
            CFuncPoint *func_point = handle->func_point;

            if (func_point == NULL) {
                return 0;
            }

            *(u_long128 *) pos = *(u_long128 *) func_point->position;
            CalcPosWorldCoordGyaku(pos);
            return 1;
        }
        default:
            return 0;
    }
}

int CEohMother::GetRot(int slot, float *rot) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            mgCObject *chara = handle->object;

            if (chara == NULL) {
                return 0;
            }

            chara->GetRotation(rot);
            rot[1] -= EdEventInfo.world_coord_rot[1];
            rot[1] = mgAngleLimit(rot[1]);
            return 1;
        }
        case EOH_TYPE_OBJECT: {
            mgCObject *object = handle->object;

            if (object == NULL) {
                return 0;
            }

            object->GetRotation(rot);

            if (eoh[slot].world_coord != 0) {
                rot[1] -= EdEventInfo.world_coord_rot[1];
                rot[1] = mgAngleLimit(rot[1]);
            }

            return 1;
        }
        case EOH_TYPE_FRAME: {
            mgCObject *frame = handle->object;

            if (frame == NULL) {
                return 0;
            }

            frame->GetRotation(rot);
            return 1;
        }
        case EOH_TYPE_SPRITE: {
            CEventSprite2 *&sprite = handle->sprite;

            if (sprite == NULL) {
                return 0;
            }

            rot[0] = 0.0f;
            rot[1] = 0.0f;
            rot[3] = 0.0f;
            rot[2] = sprite->GetRotZ();
            return 1;
        }
        case EOH_TYPE_FUNC_POINT: {
            CFuncPoint *func_point = handle->func_point;

            if (func_point == NULL) {
                return 0;
            }

            *(u_long128 *) rot = *(u_long128 *) func_point->rotation;

            if (handle->world_coord != 0) {
                rot[1] -= EdEventInfo.world_coord_rot[1];
                rot[1] = mgAngleLimit(rot[1]);
            }

            return 1;
        }
        default:
            return 0;
    }
}

int CEohMother::SetMotion(int slot, char *name, int type, float blend) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CObject    **held = &handle->object;
            CCharacter2 *chara = (CCharacter2 *) *held;

            if (chara == NULL) {
                return 0;
            }

            chara->SetMotion(name, type);

            if (blend != -1.0f) {
                ((CCharacter2 *) *held)->NormalDrive();
                ((CCharacter2 *) *held)->SetStep(blend);
                chara = (CCharacter2 *) *held;
                chara->frame = (float) chara->now_key->start_frame;
            }

            return 1;
        }
        default:
            return 0;
    }
}

int CEohMother::CheckMotionEnd(int slot) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == NULL) {
                return 0;
            }

            if (chara->seq_mode == 0) {
                return (chara)->CheckMotionEnd();
            }

            if (chara->seq_state == 4) {
                return (chara)->CheckMotionEnd();
            }

            return 0;
        }
        default:
            return 0;
    }
}

int CEohMother::SetMotionTrg(int slot) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == NULL) {
                return 0;
            }

            if (chara->seq_mode != 1) {
                break;
            }

            chara->seq_advance = 1;
            break;
        }
        default:
            return 0;
    }

    return 0;
}

int CEohMother::GetSeqStatus(int slot) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == NULL) {
                return 0;
            }

            if (chara->seq_mode == 1) {
                return chara->seq_state;
            }

            return 0;
        }
    }

    return 0;
}

int CEohMother::SetStep(int slot, float step) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = (CCharacter2 *) handle->object;

            if (chara == NULL) {
                return 0;
            }

            chara->SetStep(step);
            return 1;
        }
        default:
            return 0;
    }
}

int CEohMother::SetChangeStep(int slot, float step) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == NULL) {
                return 0;
            }

            chara->blend_speed = step;

            if (step >= 1.0f) {
                chara->blend = 1.0f;
            }

            break;
        }
        default:
            return 0;
    }

    return 1;
}

int CEohMother::ResetMotion(int slot) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = (CCharacter2 *) handle->object;

            if (chara == NULL) {
                return 0;
            }

            chara->ResetMotion();
            break;
        }
        default:
            return 0;
    }

    return 1;
}

int CEohMother::SetTexAnim(int slot, int on, char *name) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            int texb = EventScene->GetCharaTexb(handle->scene_no);

            if (texb < 0) {
                return 0;
            }

            mgCTextureManager *manager = &mgTexManager;

            if (on != 0) {
                manager->TexAnimeOn(texb, name);
            } else if (name != NULL) {
                manager->TexAnimeOff(texb, name);
            } else {
                manager->TexAnimeAllOff(texb);
            }

            return 1;
        }
    }

    return 0;
}

int CEohMother::SetScale(int slot, float x, float y, float z) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            mgCObject *chara = handle->object;

            if (chara == NULL) {
                return 0;
            }

            chara->SetScale(x, y, z);
            return 1;
        }
        case EOH_TYPE_OBJECT: {
            mgCObject *object = handle->object;

            if (object == NULL) {
                return 0;
            }

            object->SetScale(x, y, z);
            return 1;
        }
        case EOH_TYPE_SPRITE:
            handle->sprite->SetScale(x, y);
            return 1;
        case EOH_TYPE_FRAME:
            handle->frame->SetScale(x, y, z);
            return 1;
        case EOH_TYPE_FUNC_POINT: {
            CFuncPoint *&func_point = handle->func_point;

            if (func_point == NULL) {
                return 0;
            }

            float scale[4];
            scale[0] = x;
            scale[1] = y;
            scale[2] = z;
            scale[3] = 1.0f;
            CFuncPoint *target = func_point;
            *(u_long128 *) target->scale = *(u_long128 *) scale;
            target->frame.SetScale(scale);
            return 1;
        }
        default:
            return 0;
    }
}

int CEohMother::GetScale(int slot, float *scale) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            mgCObject *chara = handle->object;

            if (chara == NULL) {
                return 0;
            }

            chara->GetScale(scale);
            return 1;
        }
        case EOH_TYPE_OBJECT: {
            mgCObject *object = handle->object;

            if (object == NULL) {
                return 0;
            }

            object->GetScale(scale);
            return 1;
        }
        case EOH_TYPE_SPRITE: {
            CEventSprite2 *sprite = handle->sprite;

            if (sprite == NULL) {
                return 0;
            }

            float size_x;
            float size_y;
            sprite->GetScale(&size_x, &size_y);
            scale[0] = size_x;
            scale[1] = size_y;
            scale[2] = 0.0f;
            scale[3] = 0.0f;
            return 1;
        }
        case EOH_TYPE_FUNC_POINT: {
            CFuncPoint *func_point = handle->func_point;

            if (func_point == NULL) {
                return 0;
            }

            *(u_long128 *) scale = *(u_long128 *) func_point->scale;
            return 1;
        }
        default:
            return 0;
    }
}

int CEohMother::SetShow(int slot, int show) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_OBJECT: {
            CObject *object = handle->object;

            if (object == NULL) {
                return 0;
            }

            object->Show(show);
            return 1;
        }
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = (CCharacter2 *) handle->object;

            if (chara == NULL) {
                return 0;
            }

            chara->Show(show);
            return 1;
        }
        case EOH_TYPE_FUNC_POINT:
            if (handle->func_point == NULL) {
                return 0;
            }

            handle->func_point->enable = show;
            return 1;
        default:
            return 0;
    }
}

int CEohMother::GetShow(int slot, int *show) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_OBJECT: {
            CObject *object = handle->object;

            if (object == NULL) {
                return 0;
            }

            *show = object->GetShow();
            return 1;
        }
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = (CCharacter2 *) handle->object;

            if (chara == NULL) {
                return 0;
            }

            *show = chara->GetShow();
            return 1;
        }
        case EOH_TYPE_FUNC_POINT:
            if (handle->func_point == NULL) {
                return 0;
            }

            *show = handle->func_point->enable;
            return 1;
        default:
            return 0;
    }
}

mgCFrame *CEohMother::SearchFrame(int slot, char *name) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh     *handle = &eoh[slot];
    mgCFrame *result = 0;

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == NULL) {
                return 0;
            }

            result = chara->CObjectFrame::frame->SearchFrame(name);
            break;
        }
    }

    return result;
}

int CEohMother::SetFrameShow(int slot, char *name, int show) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == NULL) {
                return 0;
            }

            mgCFrame *frame = chara->CObjectFrame::frame->SearchFrame(name);

            if (frame == NULL) {
                return 0;
            }

            mgCFrameAttr *attr = frame->attr;

            if (attr == NULL) {
                return 0;
            }

            attr->draw = show;
            return 1;
        }
        case EOH_TYPE_FRAME: {
            mgCFrame *frame = handle->frame;

            if (frame == NULL) {
                return 0;
            }

            mgCFrameAttr *attr = frame->attr;

            if (attr == NULL) {
                return 0;
            }

            attr->draw = show;
            return 1;
        }
    }

    return 0;
}

int CEohMother::SetShadow(int slot, int enable) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA:
            if (enable != 0) {
                EventScene->ResetStatus(1, handle->scene_no, status_no_shadow);
            } else {
                EventScene->SetStatus(1, handle->scene_no, status_no_shadow);
            }

            return 1;
    }

    return 0;
}

int CEohMother::SetShadowFrameShow(int slot, char *name, int show) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == NULL) {
                return 0;
            }

            mgCFrame *shadow = chara->shadow_frame;

            if (shadow == NULL) {
                return 0;
            }

            mgCFrame *frame = shadow->SearchFrame(name);

            if (frame == NULL) {
                return 0;
            }

            mgCFrameAttr *attr = frame->attr;

            if (attr == NULL) {
                return 0;
            }

            attr->draw = show;
            return 1;
        }
    }

    return 0;
}

int CEohMother::SetTranslate(int slot, float *pos) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == NULL) {
                return 0;
            }

            mgCFrame *frame = chara->CObjectFrame::frame;

            if (frame == NULL) {
                return 0;
            }

            frame->trans_matrix[3][0] = pos[0];
            frame->trans_matrix[3][1] = pos[1];
            frame->trans_matrix[3][2] = pos[2];
            frame->changed = 1;
            return 1;
        }
        case EOH_TYPE_FRAME: {
            mgCFrame *frame = handle->frame;

            if (frame == NULL) {
                return 0;
            }

            frame->trans_matrix[3][0] = pos[0];
            frame->trans_matrix[3][1] = pos[1];
            frame->trans_matrix[3][2] = pos[2];
            frame->changed = 1;
            return 1;
        }
    }

    return 0;
}

int CEohMother::SetColor(int slot, float *color) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_SPRITE: {
            CEventSprite2 *sprite = handle->sprite;

            if (sprite == NULL) {
                return 0;
            }

            sprite->SetColor(color);
            return 1;
        }
    }

    return 0;
}

int CEohMother::GetColor(int slot, float *color) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_SPRITE: {
            CEventSprite2 *sprite = handle->sprite;

            if (sprite == NULL) {
                return 0;
            }

            sprite->GetColor(color);
            return 1;
        }
    }

    return 0;
}

char *CEohMother::GetNowMotionName(int slot) {
    if (slot < 0 || slot >= EOH_NUM) {
        return NULL;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = (CCharacter2 *) handle->object;

            if (chara != NULL) {
                return chara->GetNowMotionName();
            }

            return NULL;
        }
    }

    return NULL;
}

int CEohMother::GetNowMotionStatus(int slot) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = (CCharacter2 *) handle->object;

            if (chara != NULL) {
                return chara->GetMotionStatus();
            }

            return 0;
        }
    }

    return 0;
}

int CEohMother::SetMotionNowTime(int slot, float time) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CObject    **held = &handle->object;
            CCharacter2 *chara = (CCharacter2 *) *held;

            if (chara == NULL) {
                return 0;
            }

            CHRINFO_KEY_SET *motion = chara->now_key;

            if (motion != NULL) {
                float now = time + (float) motion->start_frame;

                if (!(now < (float) motion->end_frame)) {
                    return 0;
                }

                chara->frame = now;
                ((CCharacter2 *) *held)->NormalDrive();
                ((CCharacter2 *) *held)->frame = now;
            } else {
                return 0;
            }

            return 1;
        }
        default:
            return 0;
    }
}

int CEohMother::SetMotionWaitTime(int slot, float rate) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CObject    **held = &handle->object;
            CCharacter2 *chara = (CCharacter2 *) *held;

            if (chara == NULL) {
                return 0;
            }

            CHRINFO_KEY_SET *motion = chara->now_key;

            if (motion != NULL) {
                float length = (float) (motion->end_frame - motion->start_frame);
                length *= rate;
                chara->frame = length + (float) motion->start_frame;
                ((CCharacter2 *) *held)->NormalDrive();
                chara = (CCharacter2 *) *held;
                chara->frame = length + (float) chara->now_key->start_frame;
            }

            return 1;
        }
        default:
            return 0;
    }
}

int CEohMother::SetFootSoundID(int slot, int sound_id) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == NULL) {
                return 0;
            }

            chara->sound_info.foot_sound_id = sound_id;
            return 1;
        }
    }

    return 0;
}

int CEohMother::GetFramePos(int slot, char *name, float *pos) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == NULL) {
                return 0;
            }

            if (chara->CObjectFrame::frame == NULL) {
                return 0;
            }

            mgCFrame *frame = chara->CObjectFrame::frame->SearchFrame(name);

            if (frame == NULL) {
                return 0;
            }

            frame->GetWorldPosition0(pos);
            CalcPosWorldCoordGyaku(pos);
            return 1;
        }
    }

    return 0;
}

int CEohMother::SetSoundID(int slot, u32 sound_id) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == NULL) {
                return 0;
            }

            chara->sound_info.se_bank = sound_id;
            return 1;
        }
    }

    return 0;
}

int CEohMother::GetFrameShow(int slot, char *name) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == NULL) {
                return 0;
            }

            mgCFrame *frame = chara->CObjectFrame::frame->SearchFrame(name);

            if (frame == NULL) {
                return 0;
            }

            mgCFrameAttr *attr = frame->attr;

            if (attr != NULL) {
                return attr->draw;
            }

            return 0;
        }
        case EOH_TYPE_FRAME: {
            mgCFrame *frame = handle->frame;

            if (frame == NULL) {
                return 0;
            }

            mgCFrameAttr *attr = frame->attr;

            if (attr != NULL) {
                return attr->draw;
            }

            return 0;
        }
    }

    return 0;
}

int CEohMother::SetFadeFlag(int slot, int flag) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = (CCharacter2 *) handle->object;

            if (chara == NULL) {
                return 0;
            }

            chara->SetFadeFlag(flag);
            return 1;
        }
        default:
            return 0;
    }
}

int CEohMother::ResetDAPosition(int slot) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 **chara = (CCharacter2 **) &handle->object;

            if (*chara == NULL) {
                return 0;
            }

            (*chara)->ResetDAPosition();
            (*chara)->StepDA(10);
            return 1;
        }
    }

    return 0;
}

int CEohMother::NormalDrive(int slot) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = (CCharacter2 *) handle->object;

            if (chara == NULL) {
                return 0;
            }

            chara->NormalDrive();
            break;
        }
        default:
            return 0;
    }

    return 1;
}

int CEohMother::UpdatePosition(int slot) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == NULL) {
                return 0;
            }

            chara->UpdatePosition();
            break;
        }
        default:
            return 0;
    }

    return 1;
}

int CEohMother::SetFrameObjAlpha(int slot, char *name, float alpha) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == NULL) {
                return 0;
            }

            if (chara->CObjectFrame::frame == NULL) {
                return 0;
            }

            mgCFrame *frame = chara->CObjectFrame::frame->SearchFrame(name);

            if (frame == NULL) {
                return 0;
            }

            frame->SetAttrParamObjAlpha(alpha, 1);
            return 1;
        }
        case EOH_TYPE_FRAME: {
            mgCFrame *root = handle->frame;

            if (root == NULL) {
                return 0;
            }

            mgCFrame *frame = root->SearchFrame(name);

            if (frame == NULL) {
                return 0;
            }

            mgCFrameAttr *attr = frame->attr;

            if (attr == NULL) {
                return 0;
            }

            attr->obj_alpha = alpha;
            return 1;
        }
    }

    return 0;
}

int CEohMother::SetFootSeId(int slot, int stamp) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == NULL) {
                return 0;
            }

            chara->sound_info.foot_se_bank = stamp;
            break;
        }
        default:
            return 0;
    }

    return 1;
}

void FileNameConvLanguage(char *name) {
    ExtensionTable extension = {{"txt", "img", "stb", ""}};
    char           marker[32];
    char          *found;
    int            i;

    for (i = 0; i < 3; i++) {
        sprintf(marker, "_1.%s", extension.name[i]);

        if ((found = strstr(name, marker)) != NULL) {
            switch (LanguageCode) {
                case 2:
                case 3:
                case 4:
                case 5:
                    sprintf(found, "_%d.%s", LanguageCode, extension.name[i]);
                    break;
            }
        }
    }
}

static int GetStackInt(RS_STACKDATA *stack) {
    if (stack->type == RS_FLOAT) {
        return fptosi(stack->val.f);
    }

    return stack->val.i;
}

static float GetStackFloat(RS_STACKDATA *stack) {
    if (stack->type == RS_INT) {
        return (float) stack->val.i;
    }

    return stack->val.f;
}
#ifdef NONMATCHING
static void GetStackVector(float *vector, RS_STACKDATA *stack) {
    vector[0] = GetStackFloat(stack++);
    vector[1] = GetStackFloat(stack++);
    vector[2] = GetStackFloat(stack);
    vector[3] = 1.0f;
}
#else
static void GetStackVector(float *vector, RS_STACKDATA *stack) {
    vector[0] = GetStackFloat(stack++);
    vector[1] = GetStackFloat(stack++);
    vector[2] = GetStackFloat(stack);
    vector[3] = 1.0f;
}
#endif
static char *GetStackString(RS_STACKDATA *stack) {
    return stack->val.s;
}

static void SetStack(RS_STACKDATA *stack, int value) {
    if (stack->type == RS_PTR) {
        stack->val.p->val.i = value;
    }
}

static void SetStack(RS_STACKDATA *stack, float value) {
    if (stack->type == RS_PTR) {
        stack->val.p->val.f = value;
    }
}

/**
 * Records the argument entries supplied by an argument script.
 */
static int _DATA(RS_STACKDATA *stack, int argc);

/**
 * Sets the next argument-list identifier supplied by an argument script.
 */
static int _ID_OFFSET(RS_STACKDATA *stack, int argc);

/**
 * External handlers available to event argument scripts.
 */
static RS_EXTFUNC_INFO esa_ext_func_info[3] = {
    {_DATA, EVENT_ARG_DATA},
    {_ID_OFFSET, EVENT_ARG_ID_OFFSET},
    {NULL, EVENT_ARG_DATA},
};

void CEventScriptArg::BuildArgData(u32 *program) {
    RS_STACKDATA stack[script_stack_slots];
    RS_CALLDATA  calls[script_call_slots];
    int (*func_table[script_func_slots])(RS_STACKDATA *, int);
    int count;
    int i;
    int j;

    func_table[0] = NULL;
    func_table[1] = NULL;
    func_table[2] = NULL;
    count = 0;
    i = 0;

    for (;;) {
        if (esa_ext_func_info[i].func == NULL) {
            break;
        }

        for (j = 0; j < count; j++) {
            if (esa_ext_func_info[i].no == esa_ext_func_info[j].no) {
                printf("EvectScriptArg same ext_func_no!!!\n");

                while (1) {
                }
            }
        }

        if (esa_ext_func_info[i].no < 0 || esa_ext_func_info[i].no >= script_func_slots) {
            printf("EvectScriptArg ext func over!!\n");
        } else {
            func_table[esa_ext_func_info[i].no] = esa_ext_func_info[i].func;
        }

        i++;
        count++;
    }

    nowScriptArg = this;
    CRunScript script;
    script.load((RS_PROG_HEADER *) program, stack, script_stack_slots, calls, script_call_slots);
    script.ext_func(func_table, script_func_slots);
    script.run(script_run_id);
    nowScriptArg = NULL;
}
static inline ARG_LIST *ScriptArgAddList(CEventScriptArg *script) {
    if (script->memory == NULL) {
        return NULL;
    }
    ARG_LIST *created = new (script->memory->Alloc(3)) ARG_LIST;
    if (created == NULL) {
        return NULL;
    }
    created->id = script->next_id;
    created->args = NULL;
    created->next = NULL;
    if (script->list_num <= 0) {
        script->list = created;
    } else {
        ARG_LIST *last = script->list;
        while (last->next != NULL) {
            last = last->next;
        }
        last->next = created;
    }
    script->next_id++;
    script->list_num++;
    return created;
}
static inline void ScriptArgNewData(CEventScriptArg *script, int num, ARG_DATA **out) {
    if (script->memory == NULL) {
        *out = NULL;
    } else {
        u_int size = num * sizeof(ARG_DATA);
        *out = new (script->memory->Alloc(((size & 0xF) ? (size >> 4) + 1 : size >> 4) + 2)) ARG_DATA[num];
    }
}
static inline char *ScriptArgNewString(CEventScriptArg *script, char *source) {
    char *copy;
    if (script->memory == NULL) {
        copy = NULL;
    } else {
        u_int length = strlen(source) + 1;
        copy = new (script->memory->Alloc(((length & 0xF) ? (length >> 4) + 1 : length >> 4) + 2)) char[strlen(source) + 1];
        strcpy(copy, source);
    }
    return copy;
}
int _DATA(RS_STACKDATA *stack, int argc) {
    char *source;
    CEventScriptArg *script = nowScriptArg;
    if (script == NULL) {
        return 0;
    }
    ARG_LIST *node = ScriptArgAddList(script);
    if (node == NULL) {
        return 0;
    }
    ARG_DATA *args __attribute__((aligned(16)));
    ScriptArgNewData(nowScriptArg, argc, &args);
    if (args == NULL) {
        return 0;
    }
    node->args = args;
    node->arg_num = argc;
    for (int i = 0; i < argc; i++) {
        args[i].type = stack->type;
        switch (stack->type) {
            case RS_INT:
                args[i].i = GetStackInt(stack++);
                break;
            case RS_FLOAT:
                args[i].f = GetStackFloat(stack++);
                break;
            case RS_STR:
                source = GetStackString(stack++);
                args[i].s = ScriptArgNewString(nowScriptArg, source);
                break;
            default:
                args[i].s = NULL;
                break;
        }
    }
    return 1;
}
int _ID_OFFSET(RS_STACKDATA *stack, int arg_count) {
    if (nowScriptArg == 0) {
        return 0;
    }

    nowScriptArg->next_id = GetStackInt(stack);
    return 1;
}

int GetArgInt(ARG_DATA *arg) {
    if (arg == NULL) {
        printf("GetArgInt err[null_pointer]\n");
        return 0;
    }

    if (arg->type == RS_FLOAT) {
        return fptosi(arg->f);
    }

    return arg->i;
}

float GetArgFloat(ARG_DATA *arg) {
    if (arg == NULL) {
        printf("GetArgFloat err[null_pointer]\n");
        return 0.0f;
    }

    if (arg->type == RS_INT) {
        return (float) arg->i;
    }

    return arg->f;
}

char *GetArgString(ARG_DATA *arg) {
    if (arg == NULL) {
        printf("GetArgString err[null_pointer]\n");
        return 0;
    }

    return arg->s;
}

void GetArgVector(float *vec, ARG_DATA *arg) {
    vec[0] = GetArgFloat(arg++);
    vec[1] = GetArgFloat(arg++);
    vec[2] = GetArgFloat(arg++);
    vec[3] = 1.0f;
}

static inline ARG_DATA *FindArgData(int key) {
    ARG_LIST *node = EventScriptArg.list;

    if (node == NULL) {
        return NULL;
    }

    int i = 0;

    while (i < EventScriptArg.list_num) {
        if (key == node->id) {
            break;
        }

        node = node->next;

        if (node != NULL) {
            i++;
            continue;
        }

        return NULL;
    }

    if (node == NULL) {
        return NULL;
    }

    return node->args;
}

static inline ARG_DATA *FindArgData(int key, int &arg_num) {
    ARG_LIST *node = EventScriptArg.list;

    if (node == NULL) {
        return NULL;
    }

    int i = 0;

    while (i < EventScriptArg.list_num) {
        if (key == node->id) {
            break;
        }

        node = node->next;

        if (node != NULL) {
            i++;
            continue;
        }

        return NULL;
    }

    if (node == NULL) {
        return NULL;
    }

    arg_num = node->arg_num;
    return node->args;
}

void CRaster::Initialize() {
    state = RASTER_OFF;
    amplitude_step = 0.0f;
    amplitude = 0.0f;
    speed_step = 0.0f;
    speed = 0.0f;
    pitch_step = 0.0f;
    pitch = 0.0f;
    unk_20 = 0;
    phase = 0.0f;
    frames = -1;
    frame = 0;
}

void CRaster::SetParam(float amplitude, float speed, float pitch) {
    this->amplitude = amplitude;
    this->speed = speed;
    this->pitch = pitch;
}

void CRaster::StartRaster(float target0, float target1, float target2, int frames) {
    this->frames = frames;
    frame = 0;

    if (this->frames > 1) {
        state = 1;

        if (target0 != -1.0f) {
            amplitude_step = (target0 - amplitude) / (float) this->frames;
        } else {
            amplitude_step = 0.0f;
        }

        if (target1 != -1.0f) {
            speed_step = (target1 - speed) / (float) this->frames;
        } else {
            speed_step = 0.0f;
        }

        if (target2 != -1.0f) {
            pitch_step = (target2 - pitch) / (float) this->frames;
            return;
        }

        pitch_step = 0.0f;
        return;
    }

    if (target0 != -1.0f) {
        amplitude = target0;
    }

    if (target1 != -1.0f) {
        speed = target1;
    }

    if (target2 != -1.0f) {
        pitch = target2;
    }

    state = 2;
}

void CRaster::StopRaster(float target0, float target1, float target2, int frames) {
    this->frames = frames;
    frame = 0;

    if (this->frames > 1) {
        state = 3;

        if (target0 != -1.0f) {
            amplitude_step = (target0 - amplitude) / (float) this->frames;
        } else {
            amplitude_step = 0.0f;
        }

        if (target1 != -1.0f) {
            speed_step = (target1 - speed) / (float) this->frames;
        } else {
            speed_step = 0.0f;
        }

        if (target2 != -1.0f) {
            pitch_step = (target2 - pitch) / (float) this->frames;
            return;
        }

        pitch_step = 0.0f;
        return;
    }

    if (target0 != -1.0f) {
        amplitude = target0;
    }

    if (target1 != -1.0f) {
        speed = target1;
    }

    if (target2 != -1.0f) {
        pitch = target2;
    }

    state = 0;
}

void CRaster::StepRaster() {
    switch (state) {
        case 1:
        case 3:
            amplitude += amplitude_step;

            if (amplitude < 0.0f) {
                amplitude = 0.0f;
            }

            speed += speed_step;

            if (speed > raster_max) {
                speed = raster_max;
            }

            if (speed < 0.0f) {
                speed = 0.0f;
            }

            pitch += pitch_step;

            if (pitch > raster_max) {
                pitch = raster_max;
            }

            if (pitch < 0.0f) {
                pitch = 0.0f;
            }

            frame++;

            if (frame >= this->frames) {
                frame = 0;
                this->frames = -1;

                if (state == 1) {
                    state = 2;
                }

                if (state == 3) {
                    state = 0;
                }
            }

            break;
        case 2:
        case 0:
            break;
    }
}

void CRaster::DrawRaster() {
    int   width;
    int   y;
    float shift;
    float current_phase;
    float next_y;

    if (state != 0) {
        mgCTexture screen;

        mgGetFrameBuffer(&screen);
        mgCDrawPrim slot;
        slot.Initialize(NULL, NULL);
        slot.DepthTestEnable(0);
        slot.AlphaTestEnable(0);
        slot.AlphaBlendEnable(0);
        slot.ZMask(MG_Z_MASK_MASKED);
        slot.TextureMapEnable(1);
        current_phase = phase;
        slot.Begin(prim_sprite);
        slot.Texture(&screen);
        slot.Color(half_color, half_color, half_color, half_color);

        for (y = 0; y < mgScreenHeight; y++) {
            shift = amplitude * sinf(current_phase);
            slot.TextureCrd(0, y);
            slot.Vertex(shift, (float) y, 0.0f);
            slot.TextureCrd(mgScreenWidth, y + 1);
            slot.Vertex(shift + (float) mgScreenWidth, next_y = 1.0f + (float) y, 0.0f);

            if (shift != 0.0f) {
                if (!(shift <= 0.0f)) {
                    width = mgScreenWidth;
                    slot.TextureCrd(width - fptosi(shift), y);
                    slot.Vertex(0.0f, (float) y, 0.0f);
                    slot.TextureCrd(mgScreenWidth, y + 1);
                    slot.Vertex(shift, next_y, 0.0f);
                } else {
                    slot.TextureCrd(0, y);
                    slot.Vertex((float) mgScreenWidth + shift, (float) y, 0.0f);
                    slot.TextureCrd(fptosi(-shift), y + 1);
                    slot.Vertex((float) mgScreenWidth, next_y, 0.0f);
                }
            }

            current_phase += pitch;
            current_phase = mgAngleLimit(current_phase);
        }

        slot.End();
        phase += speed;
        phase = mgAngleLimit(phase);
    }
}

void CScreenEffect::Initialize() {
    raster.Initialize();
    sepia_texture = NULL;
    sepia = 0;
    mono_flash_texture[0] = NULL;
    mono_flash_texture[1] = NULL;
    mono_flash = 0;
    mono_flash_interval = 0;
    mono_flash_frame = 0;
    mono_flash_no = 0;
}

void CScreenEffect::Step() {
    raster.StepRaster();
}

void CScreenEffect::Draw() {

    mgCTextureManager *manager = &mgTexManager;

    if (sepia != 0 && sepia_texture != NULL) {
        manager->ReloadTexture(sepia_texture->block, (sceVif1Packet *) NULL);
        mgCDrawPrim sepia_prim;
        sepia_prim.Initialize(NULL, NULL);
        sepia_prim.DepthTestEnable(0);
        sepia_prim.AlphaTestEnable(0);
        sepia_prim.AlphaBlendEnable(0);
        sepia_prim.ZMask(MG_Z_MASK_MASKED);
        sepia_prim.TextureMapEnable(1);
        sepia_prim.Begin(prim_sprite);
        sepia_prim.Texture(sepia_texture);
        sepia_prim.Color(half_color, half_color, half_color, half_color);
        sepia_prim.TextureCrd(0, 0);
        sepia_prim.Vertex(-1, -1, 0);
        sepia_prim.TextureCrd(mgScreenWidth, mgScreenHeight);
        sepia_prim.Vertex(mgScreenWidth, mgScreenHeight, 0);
        sepia_prim.End();
    }

    if (mono_flash != 0) {
        if (mono_flash_texture[0] != NULL && mono_flash_texture[1] != NULL) {
            manager->ReloadTexture(mono_flash_texture[mono_flash_no]->block, (sceVif1Packet *) NULL);
            mgCDrawPrim flash;
            flash.Initialize(NULL, NULL);
            flash.DepthTestEnable(0);
            flash.AlphaTestEnable(0);
            flash.AlphaBlendEnable(0);
            flash.ZMask(MG_Z_MASK_MASKED);
            flash.TextureMapEnable(1);
            flash.Begin(prim_sprite);
            flash.Texture(mono_flash_texture[mono_flash_no]);
            flash.Color(half_color, half_color, half_color, half_color);
            flash.TextureCrd(0, 0);
            flash.Vertex(-1, -1, 0);
            flash.TextureCrd(mgScreenWidth, mgScreenHeight);
            flash.Vertex(mgScreenWidth, mgScreenHeight, 0);
            flash.End();
            mono_flash_frame++;

            if (mono_flash_frame >= mono_flash_interval) {
                mono_flash_no = ((mono_flash_no != 0) ^ 1) & 0xFF;
                mono_flash_frame = 0;
            }
        }
    }

    raster.DrawRaster();
}

void CScreenEffect::InitRaster(float amplitude, float speed, float pitch) {
    raster.Initialize();
    raster.SetParam(amplitude, speed, pitch);
}

void CScreenEffect::StartRaster(float target0, float target1, float target2, int frames) {
    raster.StartRaster(target0, target1, target2, frames);
}

void CScreenEffect::StopRaster(float target0, float target1, float target2, int frames) {
    raster.StopRaster(target0, target1, target2, frames);
}

void CScreenEffect::SetSepiaTexture(mgCTexture *texture, u_long128 *image) {
    if (texture != NULL) {
        sepia_texture = texture;

        sepia_texture->image[0] = image;
    }
}
void CScreenEffect::CaptureSepiaScreen(void) {
    if (sepia_texture == NULL) {
        return;
    }
    mgCTexture screen;
    mgGetFrameBackBuffer(&screen);
    mgStoreImage(&screen, sepia_texture->image[0]);
    u_char *pixels = (u_char *)sepia_texture->image[0];
    for (int i = 0; i < mgScreenHeight * mgScreenWidth * 4; i += 4) {
        u_char *red = &pixels[i];
        u_char *green = &pixels[i + 1];
        u_char *blue = &pixels[i + 2];
        int gray = (u_int)(0.229f * (float)(u_int)*red + 0.587f * (float)(u_int)*green + 0.114f * (float)(u_int)*blue) & 0xFF;
        if (gray > 0x40) {
            *red = (gray - 0x40) * 180 / 191 + 75;
            *green = (gray - 0x40) * 193 / 191 + 62;
            *blue = (gray - 0x40) * 234 / 191 + 21;
        } else {
            *red = gray * 75 >> 6;
            *green = gray * 62 >> 6;
            *blue = gray * 21 >> 6;
        }
    }
}
void CScreenEffect::SetSepiaFlag(int enabled) {
    if (sepia_texture != NULL) {
        sepia = enabled;
        return;
    }

    sepia = 0;
}

void CScreenEffect::SetMonoFlashTexture(mgCTexture **textures, u_long128 **vram_images) {
    if (textures[0] == NULL || textures[1] == NULL) {
        return;
    }

    mono_flash_texture[0] = textures[0];
    mono_flash_texture[0]->image[0] = vram_images[0];
    mono_flash_texture[1] = textures[1];
    mono_flash_texture[1]->image[0] = vram_images[1];
}
void CScreenEffect::CaptureMonoFlashScreen(void) {
    if (mono_flash_texture[0] == NULL || mono_flash_texture[1] == NULL) {
        return;
    }
    mgCTexture screen;
    mgGetFrameBackBuffer(&screen);
    mgStoreImage(&screen, mono_flash_texture[0]->image[0]);
    mgStoreImage(&screen, mono_flash_texture[1]->image[0]);
    u_char *positive = (u_char *)mono_flash_texture[0]->image[0];
    u_char *negative = (u_char *)mono_flash_texture[1]->image[0];
    for (int i = 0; i < mgScreenHeight * mgScreenWidth * 4; i += 4) {
        u_char *red = &positive[i];
        u_char *green = &positive[i + 1];
        u_char *blue = &positive[i + 2];
        *red = *green = *blue = (u_int)(0.229f * (float)*red + 0.587f * (float)*green + 0.114f * (float)*blue);
        red = &negative[i];
        green = &negative[i + 1];
        blue = &negative[i + 2];
        char gray = (u_int)(0.229f * (float)*red + 0.587f * (float)*green + 0.114f * (float)*blue);
        *red = *green = *blue = 255 - gray;
    }
}
void CScreenEffect::SetMonoFlashFlag(int enabled, int interval) {
    if (mono_flash_texture[0] != NULL || mono_flash_texture[1] != NULL) {
        mono_flash = enabled;
    } else {
        mono_flash = 0;
    }

    mono_flash_interval = interval;
    mono_flash_frame = 0;
    mono_flash_no = 0;
}

void InitWorldCoord() {
    EdEventInfo.world_coord_pos[2] = 0.0f;
    EdEventInfo.world_coord_pos[1] = 0.0f;
    SetWorldCoordFlg = 0;
    EdEventInfo.world_coord_pos[3] = 1.0f;
    EdEventInfo.world_coord_pos[0] = 0.0f;
    EdEventInfo.world_coord_rot[3] = 0.0f;
    EdEventInfo.world_coord_rot[2] = 0.0f;
    EdEventInfo.world_coord_rot[1] = 0.0f;
    EdEventInfo.world_coord_rot[0] = 0.0f;
}

int GetLocalFlag(int index) {
    int bit;
    int in_range;
    int word;

    word = index >> 5;

    if (index < 0) {
        return 0;
    }

    in_range = word < EVENT_LOCAL_NUM;

    if (index < 0) {
        word = (index + 0x1F) >> 5;
        in_range = word < EVENT_LOCAL_NUM;
    }

    bit = index & 0x1F;

    if (in_range == 0) {
        return 0;
    }

    if (index < 0) {
        if (bit != 0) {
            bit -= 0x20;
        }
    }

    int mask = 1 << bit;
    return (mask & EventLocalFlag[word]) != 0;
}

int SetLocalFlag(int index, int value) {

    int  bit;
    int  in_range;
    int  word;
    int  mask;
    u32 *flags;

    word = index >> 5;

    if (index < 0) {
        return 0;
    }

    in_range = word < EVENT_LOCAL_NUM;

    if (index < 0) {
        word = (index + 0x1F) >> 5;
        in_range = word < EVENT_LOCAL_NUM;
    }

    bit = index & 0x1F;

    if (in_range == 0) {
        return 0;
    }

    if (index < 0) {
        if (bit != 0) {
            bit -= 0x20;
        }
    }

    mask = 1 << bit;
    flags = EventLocalFlag + word;
    *flags &= ~mask;

    if (value != 0) {
        *flags |= mask;
    }

    return value;
}

int GetLocalCnt(int index) {
    if (index < 0 || index >= EVENT_LOCAL_NUM) {
        return -1;
    }

    return EventLocalCnt[index];
}

int SetLocalCnt(int index, int value) {
    if (index < 0 || index >= EVENT_LOCAL_NUM) {
        return 0;
    }

    EventLocalCnt[index] = value;
    return 1;
}

int GetLocalCnt2(int value) {
    int i;

    for (i = 0; i < EVENT_LOCAL_NUM; i++) {
        if (value == EventLocalCnt[i]) {
            return i;
        }
    }

    return -1;
}

void InitLocalCnt() {
    int i;

    for (i = 0; i < EVENT_LOCAL_NUM; i++) {
        EventLocalCnt[i] = 0;
    }
}

void EdEventInfoCommandInitialize() {
    int i;

    EdEventInfo.request = 0;
    EdEventInfo.command_mode = 0;
    EdEventInfo.skip_button = 15;
    EdEventInfo.env_bgm_volume = 1.0f;
    EdEventInfo.skip_state = 0;
    EdEventInfo.skip_fade_color[0] = 0;
    EdEventInfo.skip_fade_color[1] = 0;
    EdEventInfo.skip_fade_color[2] = 0;
    EdEventInfo.skip_fade_color[3] = 0;
    EdEventInfo.start_button = 0;
    EdEventInfo.unk_128 = 0;
    EdEventInfo.env_bgm_no = 0;
    EdEventInfo.stream_playing = 0;
    EdEventInfo.stream_from_fpl = 0;

    for (i = 0; i < 16; i++) {
        EdEventInfo.func_iparam[i] = 0;
        EdEventInfo.func_fparam[i] = 0;
    }

    EdEventInfo.door_type = 0;
    EdEventInfo.map_draw = 1;
    EdEventInfo.interior_entrance = 0;
    EdEventInfo.pack_loaded = 0;
    EdEventInfo.stream_reading = 0;
}

void EventSeqInit() {
    int i;

    for (i = 0; i < EOH_NUM; i++) {
        CEoh *handle = &EventObjHandleMother.eoh[i];
        handle->type = EOH_TYPE_NONE;
        handle->scene_no = -1;
        handle->world_coord = 1;

        handle->object = 0;
        handle->chara = 0;
        handle->sprite = 0;
        handle->frame = 0;
        handle->func_point = 0;
    }

    CameraSeq.Initialize(cmr_seq_tbl, SEQ_NODE_NUM);
    int j;

    for (j = 0; j < object_seq_num; j++) {
        ObjectSeq[j].Initialize(obj_seq_tbl, SEQ_NODE_NUM);
    }

    int k;

    for (k = 0; k < event_sprite2_num; k++) {
        EventSprite2[k].Initialize();
    }

    EventScreenEffect.Initialize();
    EventScriptArg.next_id = 0;
    EventScriptArg.list = 0;
    EventScriptArg.list_num = 0;
    EventScriptArg.memory = 0;
}

void EdEventInit() {
    int i;

    BuffEventSnd.stSetBuffer(event_snd_buff, event_snd_buffer_size);

    if (strlen("Event Snd Buffer") < memory_name_max) {
        strcpy(BuffEventSnd.name, "Event Snd Buffer");
    }

    BuffEventSnd.stack_used = 0;
    BuffEventSnd.lock = 0;
    BuffEventSnd2.stSetBuffer(event_snd2_buff, event_snd2_buffer_size);

    if (strlen("Event Snd2 Buffer") < memory_name_max) {
        strcpy(BuffEventSnd2.name, "Event Snd2 Buffer");
    }

    BuffEventSnd2.stack_used = 0;
    BuffEventSnd2.lock = 0;
    InitReadBG();
    EventDngMap.Initialize();
    p_use_item = 0;
    SetWorldCoordFlg = 0;
    InitWorldCoord();
    EventScene->map_event_no = 0;
    PakuAnimEohNo = -1;
    memset(PakuAnimName, 0, PAKU_NAME_SIZE);
    memset(PakuAnimName2, 0, PAKU_NAME_SIZE);
    PakuMotionEohNo = -1;
    memset(PakuMotionName, 0, PAKU_NAME_SIZE);
    PakuMotionType = 0;
    memset(PakuMotionName2, 0, PAKU_NAME_SIZE);
    PakuMotionType2 = 0;
    EdEventInfoCommandInitialize();
    EventSeqInit();

    for (i = 0; i < event_sprite2_num; i++) {
        EventSprite2[i].Initialize();
    }

    HitEffect[0].live_num = 0;
    HitEffect[0].spark = Hit_para[0];
    HitEffect[0].spark_max = hit_spark_num;
    HitEffect[1].spark = Hit_para[1];
    SwordEffect = NULL;
    HitEffect[2].spark = Hit_para[2];
    EventEffectScript = 0;
    HitEffect[3].spark = Hit_para[3];
    HitEffect[4].spark = Hit_para[4];
    HitEffect[0].spark_num = 0;
    HitEffect[0].kind = 0;
    HitEffect[1].spark_max = hit_spark_num;
    HitEffect[1].live_num = 0;
    HitEffect[1].spark_num = 0;
    HitEffect[1].kind = 0;
    HitEffect[2].spark_max = hit_spark_num;
    HitEffect[2].live_num = 0;
    HitEffect[2].spark_num = 0;
    HitEffect[2].kind = 0;
    HitEffect[3].spark_max = hit_spark_num;
    HitEffect[4].spark_max = hit_spark_num;
    HitEffect[3].live_num = 0;
    HitEffect[3].spark_num = 0;
    HitEffect[3].kind = 0;
    HitEffect[4].live_num = 0;
    HitEffect[4].spark_num = 0;
    HitEffect[4].kind = 0;
    EventScriptArg.next_id = 0;
    EventScriptArg.list = 0;
    EventScriptArg.list_num = 0;
    EventScriptArg.memory = 0;
    EventScreenEffect.Initialize();
}
void EventTimeDraw(void) {
    int digit[10];
    int glyph[32];
    CSaveData *saveData = GetSaveData();
    if (saveData != NULL && EdEventInfo.stopwatch_start != 0) {
        u64 elapsed;
        if (EdEventInfo.stopwatch_style == 1) {
            elapsed = EdEventInfo.stopwatch_limit - 2;
            EdEventInfo.stopwatch_limit = elapsed;
        } else if (EdEventInfo.stopwatch_limit != 0) {
            elapsed = EdEventInfo.stopwatch_limit - (saveData->play_time - EdEventInfo.stopwatch_start);
        } else {
            elapsed = saveData->play_time - EdEventInfo.stopwatch_start;
        }
        if (0x57E40 <= elapsed) {
            elapsed = 0x57E40;
        }
        int hours = elapsed / 3600;
        int minutes = elapsed % 3600 / 60;
        int hundredths = elapsed % 60 * 100 / 60;
        digit[0] = GetHalfFontNo('0');
        digit[1] = GetHalfFontNo('1');
        digit[2] = GetHalfFontNo('2');
        digit[3] = GetHalfFontNo('3');
        digit[4] = GetHalfFontNo('4');
        digit[5] = GetHalfFontNo('5');
        digit[6] = GetHalfFontNo('6');
        digit[7] = GetHalfFontNo('7');
        digit[8] = GetHalfFontNo('8');
        digit[9] = GetHalfFontNo('9');
        for (int i = 0; i < 32; i++) {
            glyph[i] = -1;
        }
        glyph[0] = digit[hours / 10];
        glyph[1] = digit[hours % 10];
        glyph[3] = digit[minutes / 10];
        glyph[4] = digit[minutes % 10];
        glyph[6] = digit[hundredths / 10];
        glyph[7] = digit[hundredths % 10];
        if (EdEventInfo.stopwatch_style == 1) {
            glyph[2] = GetHalfFontNo(':');
            glyph[5] = GetHalfFontNo(':');
        } else {
            glyph[2] = GetHalfFontNo('m');
            glyph[5] = GetHalfFontNo('s');
        }
        mgCDrawPrim prim;
        if (EdEventInfo.stopwatch_style == 0) {
            prim.Begin(MG_PRIM_SPRITE);
            RECT window;
            RGBAQ_TYPE windowColor;
            window.width = 0x9E;
            window.height = 0x36;
            windowColor.r = windowColor.g = windowColor.b = windowColor.a = 0x80;
            window.x = EdEventInfo.stopwatch_x - 0x10;
            window.y = EdEventInfo.stopwatch_y - 0x12;
            DrawVersatileWin_4(&prim, window, &windowColor, 0x80);
            prim.End();
        }
        MySetPrim(&prim, 1, 0);
        prim.Begin(MG_PRIM_SPRITE);
        for (int i = 0; i < 32; i++) {
            if (glyph[i] >= 0) {
                int page;
                RECT texture = GetRectFontTex(glyph[i], &page);
                MySetTex(page, &prim);
                RECT destination;
                destination.x = EdEventInfo.stopwatch_x + texture.width * i;
                destination.y = EdEventInfo.stopwatch_y;
                if (EdEventInfo.stopwatch_style == 1) {
                    destination.y += 0x40;
                }
                destination.width = texture.width;
                destination.height = texture.height;
                set2DSprite_Fuchi(&prim, destination, texture, 8, 0x80);
                RGBAQ_TYPE color;
                color.a = color.r = color.g = color.b = 0x80;
                set2DSpriteEasyFont(&prim,
                    mgRect<int>(destination.x, destination.y, destination.width, destination.height),
                    mgRect<int>(texture.x, texture.y, texture.width, texture.height), &color);
            }
        }
        if (EdEventInfo.stopwatch_style == 1) {
            int label[32];
            for (int i = 0; i < 32; i++) {
                label[i] = -1;
            }
            if (EdEventInfo.stopwatch_style == 1) {
                switch (LanguageCode) {
                    case 0:
                        label[0] = GetFontNo("\x8C\x8E");
                        label[1] = GetFontNo("\x97\x8E");
                        label[2] = GetFontNo("\x89\xBA");
                        label[3] = GetFontNo("\x82\xDC");
                        label[4] = GetFontNo("\x82\xC5");
                        break;
                    case 2:
                label[0] = GetHalfFontNo('C');
                label[1] = GetHalfFontNo('h');
                label[2] = GetHalfFontNo('u');
                label[3] = GetHalfFontNo('t');
                label[4] = GetHalfFontNo('e');
                label[5] = GetHalfFontNo('s');
                label[6] = GetHalfFontNo(' ');
                label[7] = GetHalfFontNo('d');
                label[8] = GetHalfFontNo('e');
                label[9] = GetHalfFontNo(' ');
                label[10] = GetHalfFontNo('l');
                label[11] = GetHalfFontNo('u');
                label[12] = GetHalfFontNo('n');
                label[13] = GetHalfFontNo('e');
                        break;
                    case 4:
                label[0] = GetHalfFontNo('L');
                label[1] = GetHalfFontNo('e');
                label[2] = GetHalfFontNo(' ');
                label[3] = GetHalfFontNo('C');
                label[4] = GetHalfFontNo('a');
                label[5] = GetHalfFontNo('s');
                label[6] = GetHalfFontNo('c');
                label[7] = GetHalfFontNo('a');
                label[8] = GetHalfFontNo('t');
                label[9] = GetHalfFontNo('e');
                label[10] = GetHalfFontNo(' ');
                label[11] = GetHalfFontNo('d');
                label[12] = GetHalfFontNo('e');
                label[13] = GetHalfFontNo('l');
                label[14] = GetHalfFontNo('l');
                label[15] = GetHalfFontNo('a');
                label[16] = GetHalfFontNo(' ');
                label[17] = GetHalfFontNo('L');
                label[18] = GetHalfFontNo('u');
                label[19] = GetHalfFontNo('n');
                label[20] = GetHalfFontNo('a');
                        break;
                    case 5:
                label[0] = GetHalfFontNo('C');
                label[1] = GetHalfFontNo('a');
                label[2] = GetHalfFontNo('t');
                label[3] = GetHalfFontNo('a');
                label[4] = GetHalfFontNo('r');
                label[5] = GetHalfFontNo('a');
                label[6] = GetHalfFontNo('t');
                label[7] = GetHalfFontNo('a');
                label[8] = GetHalfFontNo('s');
                label[9] = GetHalfFontNo(' ');
                label[10] = GetHalfFontNo('L');
                label[11] = GetHalfFontNo('u');
                label[12] = GetHalfFontNo('n');
                label[13] = GetHalfFontNo('a');
                        break;
                    case 1:
                    case 3:
                    default:
                label[0] = GetHalfFontNo('M');
                label[1] = GetHalfFontNo('o');
                label[2] = GetHalfFontNo('o');
                label[3] = GetHalfFontNo('n');
                label[4] = GetHalfFontNo('F');
                label[5] = GetHalfFontNo('a');
                label[6] = GetHalfFontNo('l');
                label[7] = GetHalfFontNo('l');
                label[8] = GetHalfFontNo('s');
                        break;
                }
            }
            for (int i = 0; i < 32; i++) {
                if (label[i] >= 0) {
                    int page;
                    RECT texture = GetRectFontTex(label[i], &page);
                    MySetTex(page, &prim);
                    RECT destination;
                    switch (LanguageCode) {
                        case 0:
                            destination.x = EdEventInfo.stopwatch_x + texture.width * i + 0x18;
                            break;
                        case 2:
                        case 5:
                            destination.x = (int)(EdEventInfo.stopwatch_x + 0.75 * texture.width * i - 28.0);
                            break;
                        case 3:
                            destination.x = (int)(8.0 + (EdEventInfo.stopwatch_x + 0.75 * texture.width * i));
                            break;
                        case 4:
                            destination.x = (int)(EdEventInfo.stopwatch_x + 0.5 * texture.width * i - 28.0);
                            break;
                        case 1:
                        default:
                            destination.x = EdEventInfo.stopwatch_x + texture.width * i - 4;
                            break;
                    }
                    destination.y = EdEventInfo.stopwatch_y - 0x18;
                    if (EdEventInfo.stopwatch_style == 1) {
                        destination.y += 0x40;
                    }
                    destination.width = texture.width;
                    destination.height = texture.height;
                    set2DSprite_Fuchi(&prim, destination, texture, 8, 0x80);
                    RGBAQ_TYPE color;
                    color.a = color.r = color.g = color.b = 0x80;
                    set2DSpriteEasyFont(&prim,
                        mgRect<int>(destination.x, destination.y, destination.width, destination.height),
                        mgRect<int>(texture.x, texture.y, texture.width, texture.height), &color);
                }
            }
        }
        prim.End();
    }
}
void EdEventDraw() {
    int hit_no;
    int sprite_no;

    EventRain.Step();
    EventRain.Draw();

    for (hit_no = 0; hit_no < hit_effect_num; hit_no++) {
        HitEffect[hit_no].Draw();
    }

    if (SwordEffect != NULL) {
        SwordEffect->Draw();
    }

    if (EventEffectScript != NULL) {
        EventEffectScript->Draw();
    }

    EventDngMap.Step();
    EventDngMap.Draw();
    esMother.Step();
    esMother.Draw();

    for (sprite_no = 0; sprite_no < event_sprite2_num; sprite_no++) {
        EventSprite2[sprite_no].NormalDraw();
    }

    EventScreenEffect.Draw();
    DrawMenuDl(0x80);
    DrawDownLoadAnaunce();
}

void EdEventFirstDraw() {
    int i;

    for (i = 0; i < event_sprite2_num; i++) {
        EventSprite2[i].FirstDraw();
    }
}

int EdEventFinish() {
    mgCCamera *camera;
    int        i;
    int        j;
    int        k;

    CameraSeq.Initialize(cmr_seq_tbl, SEQ_NODE_NUM);

    for (i = 0; i < object_seq_num; i++) {
        ObjectSeq[i].Initialize(obj_seq_tbl, SEQ_NODE_NUM);
    }

    for (j = 0; j < event_sprite2_num; j++) {
        EventSprite2[j].Initialize();
    }

    HitEffect[0].live_num = 0;
    HitEffect[0].spark = Hit_para[0];
    HitEffect[0].spark_max = hit_spark_num;
    HitEffect[1].spark = Hit_para[1];
    EventEffectScript = 0;
    HitEffect[2].spark = Hit_para[2];
    HitEffect[3].spark = Hit_para[3];
    HitEffect[4].spark = Hit_para[4];
    HitEffect[0].spark_num = 0;
    HitEffect[0].kind = 0;
    HitEffect[1].spark_max = hit_spark_num;
    HitEffect[1].live_num = 0;
    HitEffect[1].spark_num = 0;
    HitEffect[1].kind = 0;
    HitEffect[2].spark_max = hit_spark_num;
    HitEffect[2].live_num = 0;
    HitEffect[2].spark_num = 0;
    HitEffect[2].kind = 0;
    HitEffect[3].spark_max = hit_spark_num;
    HitEffect[4].spark_max = hit_spark_num;
    HitEffect[3].live_num = 0;
    HitEffect[3].spark_num = 0;
    HitEffect[3].kind = 0;
    HitEffect[4].live_num = 0;
    HitEffect[4].spark_num = 0;
    HitEffect[4].kind = 0;
    camera = EventScene->GetCamera(EventScene->active_camera);

    if (camera == NULL) {
        return 0;
    }

    if (SetWorldCoordFlg != 0) {
        SetCamWorldCoord(camera);
        SetWorldCoordFlg = 0;
    }

    esMother.Init();
    EventMarker.Init();
    p_use_item = 0;
    SetWorldCoordFlg = 0;

    for (k = 0; k < event_sprite2_num; k++) {
        EventSprite2[k].Initialize();
    }

    PakuAnimEohNo = -1;
    memset(PakuAnimName, 0, PAKU_NAME_SIZE);
    memset(PakuAnimName2, 0, PAKU_NAME_SIZE);
    PakuMotionEohNo = -1;
    memset(PakuMotionName, 0, PAKU_NAME_SIZE);
    PakuMotionType = 0;
    memset(PakuMotionName2, 0, PAKU_NAME_SIZE);
    PakuMotionType2 = 0;
    InitWorldCoord();
    EdEventInfo.skip_state = 0;
    EdEventInfo.pack_loaded = 0;
    EventScriptArg.next_id = 0;
    EventScriptArg.list = 0;
    EventScriptArg.list_num = 0;
    EventScriptArg.memory = 0;
    EventScreenEffect.Initialize();
    return 1;
}

int EdEventStep() {
    int seq_no;
    int hit_no;

    mgSetProjection(EdEventInfo.projection);

    for (seq_no = 0; seq_no < object_seq_num; seq_no++) {
        ObjectSeq[seq_no].Play();
    }

    CameraSeq.Play();

    if (Sphida != NULL) {
        Sphida->Step();
    }

    for (hit_no = 0; hit_no < hit_effect_num; hit_no++) {
        HitEffect[hit_no].Step();
    }

    if (SwordEffect != NULL) {
        SwordEffect->CreatPointList();
        SwordEffect->Step();
    }

    if (EventEffectScript != NULL) {
        EventEffectScript->Step();
    }

    EventScreenEffect.Step();
    ReadBG();
    return 1;
}

void InitDramaScene() {
    EdEventInfo.skip_fade_color[0] = 0;
    EdEventInfo.skip_fade_color[1] = 0;
    EdEventInfo.skip_state = 1;
    EdEventInfo.skip_button = 15;
    EdEventInfo.skip_fade_color[2] = 0;
    EdEventInfo.skip_fade_color[3] = 0;
}

void CancelDramaScene() {
    EdEventInfo.skip_state = 0;
}

void EdEventMenuExit() {
    if (p_use_item != 0) {
        p_use_item->val.i = MenuArg.result[0];
    }

    p_use_item = 0;
}

void EdEventLoopInit() {
    int i;

    for (i = 0; i < 12; i++) {
        EdEventInfo.snd_id[i] = 0;
    }

    EdEventInfo.last_snd_id = 0;
    memset(EdEventInfo.script_name, 0, sizeof(EdEventInfo.script_name));
    EdEventInfo.map_draw = 1;
    InitWorldCoord();
    EdEventInfoCommandInitialize();
    EventScreenEffect.Initialize();
}

void EdSetBrokenObject() {
}

void ResetMesFileBuffAll() {
    int     i;
    ClsMes *message;

    i = 0;

    do {
        message = GetEventMessage(i);

        if (message != NULL) {
            message->mes_data = NULL;
            message->mes_data_size = 0;
        }

        i += 1;
    } while (i < 8);
}

void EdEventMapInit() {
    ClsMes *message;
    int     i;

    message = GetSystemMessage();

    if (message != NULL) {
        message->Preset(5);
    }

    for (i = 0; i < EVENT_LOCAL_NUM; i++) {
        EventLocalFlag[i] = 0;
    }

    InitLocalCnt();
    message = GetSystemMessage(0);

    if (message != NULL) {
        message->draw_speed = message->GetDrawSpeedDef();
        message->mes_no = -1;
        message->text_ptr = 0;
        message->open = 0;
        message->fade = 0;
        message->fukidashi_centre_x = -1;
        message->fukidashi_centre_y = -1;
    }

    message = GetSystemMessage(1);

    if (message != NULL) {
        message->draw_speed = message->GetDrawSpeedDef();
        message->mes_no = -1;
        message->text_ptr = 0;
        message->open = 0;
        message->fade = 0;
        message->fukidashi_centre_x = -1;
        message->fukidashi_centre_y = -1;
    }

    message = GetSystemMessage(2);

    if (message != NULL) {
        message->draw_speed = message->GetDrawSpeedDef();
        message->mes_no = -1;
        message->text_ptr = 0;
        message->open = 0;
        message->fade = 0;
        message->fukidashi_centre_x = -1;
        message->fukidashi_centre_y = -1;
    }

    ResetMesFileBuffAll();
    EdSetBrokenObject();
    InitSphida();

    HitEffect[0].live_num = 0;
    HitEffect[0].spark = Hit_para[0];
    HitEffect[0].spark_max = hit_spark_num;
    SwordEffect = NULL;
    HitEffect[1].spark = Hit_para[1];
    EventEffectScript = 0;
    HitEffect[2].spark = Hit_para[2];
    HitEffect[3].spark = Hit_para[3];
    HitEffect[4].spark = Hit_para[4];
    HitEffect[0].spark_num = 0;
    HitEffect[0].kind = 0;
    HitEffect[1].spark_max = hit_spark_num;
    HitEffect[1].live_num = 0;
    HitEffect[1].spark_num = 0;
    HitEffect[1].kind = 0;
    HitEffect[2].spark_max = hit_spark_num;
    HitEffect[2].live_num = 0;
    HitEffect[2].spark_num = 0;
    HitEffect[2].kind = 0;
    HitEffect[3].spark_max = hit_spark_num;
    HitEffect[4].spark_max = hit_spark_num;
    HitEffect[3].live_num = 0;
    HitEffect[3].spark_num = 0;
    HitEffect[3].kind = 0;
    HitEffect[4].live_num = 0;
    HitEffect[4].spark_num = 0;
    HitEffect[4].kind = 0;
    EdEventInfo.stopwatch_start = 0;
    EdEventInfo.stopwatch_limit = 0;
    EdEventInfo.stopwatch_x = 0;
    EdEventInfo.stopwatch_y = 0;
    EdEventInfo.stopwatch_style = 0;
}

void EdEventTermination() {
    EdEventInfo.stream_playing = 0;

    if (EdEventInfo.stream_from_fpl == 1) {
        CSnd.StreamEND(1);
    }

    CSnd.StreamSetVol(1, EdEventInfo.stream_volume, EdEventInfo.stream_volume);
    CSnd.StreamClose(1);
    EdEventInfo.stream_reading = 0;
}

void EdEventEnd() {
    ResetMesFileBuffAll();
    EventSeqInit();
}

static CSceneObjSeq *GetObjSeq(int index) {
    if (index < 0 || index >= object_seq_num) {
        return NULL;
    }

    return &ObjectSeq[index];
}

static int _GET_PADON(RS_STACKDATA *stack, int arg_count) {
    if (arg_count <= 0) {
        return 0;
    }

    SetStack(stack, GamePad__2.GetPadOn());
    return 1;
}

static int _GET_PADDOWN(RS_STACKDATA *stack, int arg_count) {
    if (arg_count <= 0) {
        return 0;
    }

    SetStack(stack, GamePad__2.GetPadDown());
    return 1;
}

static int _GET_PADUP(RS_STACKDATA *stack, int arg_count) {
    if (arg_count <= 0) {
        return 0;
    }

    SetStack(stack, GamePad__2.GetPadUp());
    return 1;
}

int _GET_APAD(RS_STACKDATA *stack, int arg_count) {
    if (arg_count > 0) {
        SetStack(stack++, GamePad__2.GetLXf());
    }

    if (arg_count > 1) {
        SetStack(stack++, GamePad__2.GetLYf());
    }

    if (arg_count > 2) {
        SetStack(stack++, GamePad__2.GetRXf());
    }

    if (arg_count > 3) {
        SetStack(stack++, GamePad__2.GetRYf());
    }

    return 1;
}

u32 *CheckLoadedBGFile(char *name, int *size) {
    char          path[0x80];
    BG_READ_INFO *info;

    GetCurrentDir(path);
    strcat(path, name);
    info = GetReadBGFile(path);

    if (info == NULL) {
        return 0;
    }

    if (info->busy == 0) {
        return 0;
    }

    *size = info->size;
    return (u32 *) info->buffer;
}

u32 *GetLoadBGBuff(char *name, int *size) {
    char path[0x8C];
    int  loaded_size;
    u32 *buffer;

    strcpy(path, name);
    FileNameConvLanguage(path);
    buffer = CheckLoadedBGFile(path, &loaded_size);

    if (buffer != NULL) {
        printf("---- EVENT LOAD BG [%s] ----\n", path);

        if (size != NULL) {
            *size = loaded_size;
        }
    } else {
        if (EdEventInfo.pack_loaded == 1) {
            printf("---- EVENT LOAD PACK [%s] ----\n", path);
            buffer = GetPackFile((u32 *) read_buffer, path, &loaded_size);

            if (buffer != NULL) {
                if (size != NULL) {
                    *size = loaded_size;
                }
            } else {
                EdEventInfo.pack_loaded = 0;
            }
        }

        if (EdEventInfo.pack_loaded != 1) {
            if (EdEventInfo.stream_reading == 1) {
                printf("\n-------------------------------------------------------------------\n");
                printf("EVENT ERR [NOW STREAM OPEN!!! <FILE ACCESS ERROR>]\n");
                printf("\n-------------------------------------------------------------------\n");

                while (1) {
                }
            }

            printf("---- EVENT LOAD FILE [%s] ----\n", path);

            if (LoadFile2(path, read_buffer, &loaded_size, 0) == 0) {
                buffer = NULL;
            } else {
                buffer = (u32 *) read_buffer;

                if (size != NULL) {
                    *size = loaded_size;
                }
            }
        }
    }

    return buffer;
}

int _GOTO_INTERIOR(RS_STACKDATA *stack, int arg_count) {
    EdEventInfo.jump_point = GetStackInt(stack++);
    strcpy(EdEventInfo.jump_map_name, GetStackString(stack++));

    if (arg_count > 2) {
        EdEventInfo.event_no = GetStackInt(stack++);
    } else {
        EdEventInfo.event_no = 100;
    }

    if (arg_count > 3) {
        EdEventInfo.interior_entrance = GetStackInt(stack);
    } else {
        EdEventInfo.interior_entrance = 0;
    }

    EdEventInfo.request = 4;
    return 1;
}

int _GOTO_OUTSIDE(RS_STACKDATA *stack, int arg_count) {
    EdEventInfo.jump_point = GetStackInt(stack++);
    strcpy(EdEventInfo.jump_map_name, GetStackString(stack++));

    if (arg_count > 2) {
        EdEventInfo.event_no = GetStackInt(stack);
    } else {
        EdEventInfo.event_no = 100;
    }

    EdEventInfo.request = 7;
    return 1;
}

int _INITIALIZE(RS_STACKDATA *stack, int arg_count) {
    mgCCameraFollow *camera;

    EdEventInit();
    camera = (mgCCameraFollow *) GetActiveCamera();

    if (camera == NULL) {
        return 0;
    }

    camera->FollowOff();
    return 1;
}

int _LOAD_CHARA_sub(int stack_no, char **name, int chara_no, u32 *pack, int mode) {
    u32               *files[pack_file_max];
    int                sizes[pack_file_max];
    char               label[0x20];
    mgCMemory         *stack;
    int                tex_block;
    int                result;
    mgCTextureManager *manager;

    stack = EventScene->GetStack(stack_no);

    if (*name == NULL) {
        if (GetPackFileExt(pack, "cfg", files, pack_file_max, sizes, name) <= 0) {
            return 0;
        }
    }

    tex_block = EventScene->GetCharaTexb(chara_no);

    if (tex_block < 0) {
        return 0;
    }

    manager = &mgTexManager;
    manager->DeleteBlock(tex_block);
    sprintf(label, "ev%d", chara_no);

    if (chara_no >= 8) {
        strcpy(manager->name_suffix, label);
    }

    result = EventScene->LoadChara(chara_no, pack, *name, stack, stack, stack, tex_block, mode);

    if (chara_no >= 8) {
        manager->name_suffix[0] = 0;
    }

    EventScene->SetType(1, chara_no, type_loaded);
    return result;
}

int _LOAD_CHARA_sub(int a, char **b, int c, u32 *d) {
    return _LOAD_CHARA_sub(a, b, c, d, 0);
}
int _LOAD_CHARA(RS_STACKDATA *stack, int argc) {
    char *name[0x20];
    char directory[0x40];
    char fileName[0x20];
    int stackNo;
    int charaNo;
    int mode;
    char *path;
    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack));
            if (args == NULL) {
                return 0;
            }
            stackNo = GetArgInt(args++);
            path = GetArgString(args++);
            name[0] = GetArgString(args++);
            charaNo = GetArgInt(args);
            mode = 0;
            break;
        }
        case 4:
            stackNo = GetStackInt(stack++);
            path = GetStackString(stack++);
            name[0] = GetStackString(stack++);
            charaNo = GetStackInt(stack);
            mode = 0;
            break;
        case 5:
            stackNo = GetStackInt(stack++);
            path = GetStackString(stack++);
            name[0] = GetStackString(stack++);
            charaNo = GetStackInt(stack++);
            mode = GetStackInt(stack);
            break;
        default:
            return 0;
    }
    u32 *pack = GetLoadBGBuff(path, NULL);
    if (pack == NULL) {
        return 0;
    }
    int result = _LOAD_CHARA_sub(stackNo, name, charaNo, pack, mode);
    CSaveData *saveData = GetSaveData();
    if (saveData != NULL) {
        if (saveData->GetBitCtrl() & 8) {
            if (result > 0) {
                CCharacter2 *chara = GetCharacter(charaNo);
                DivPathName(path, directory, fileName);
                if (strcmp(fileName, "c01_base.chr") == 0) {
                    AtraMiriaOnOff(0, chara, 0);
                } else if (strcmp(fileName, "c02_base.chr") == 0) {
                    AtraMiriaOnOff(1, chara, 0);
                }
            }
        }
    }
    return result;
}
int _CHARA_ACTIVE(RS_STACKDATA *stack, int arg_count) {
    int enable;
    int chara_no;

    switch (arg_count) {
        case 1:
            EventScene->SetActive(1, GetStackInt(stack));
            return 1;
        case 2:
            enable = GetStackInt(stack++);
            chara_no = GetStackInt(stack);

            if (enable != 0) {
                EventScene->SetActive(1, chara_no);
            } else {
                EventScene->ResetActive(1, chara_no);
            }

            return 1;
    }

    return 0;
}

int _CLEAR_STACK(RS_STACKDATA *stack, int arg_count) {
    EventScene->ClearStack(GetStackInt(stack));
    return 1;
}

int _ASSIGN_STACK(RS_STACKDATA *stack, int arg_count) {
    EventScene->AssignStack(GetStackInt(stack));
    return 1;
}

int _SET_FLAG(RS_STACKDATA *stack, int arg_count) {
    CSaveData *save_data;
    int        bit;
    int        value;

    bit = GetStackInt(stack++);
    value = GetStackInt(stack);
    save_data = GetSaveData();

    if (save_data == NULL) {
        return 0;
    }

    save_data->SetBitFlag(bit, value);
    return 1;
}

int _GET_FLAG(RS_STACKDATA *stack, int arg_count) {
    int        bit = GetStackInt(stack++);
    CSaveData *save_data = GetSaveData();

    if (save_data == NULL) {
        return 0;
    }

    int flag = save_data->GetBitFlag(bit);
    SetStack(stack, flag);
    return 1;
}

int _SET_CNT(RS_STACKDATA *stack, int arg_count) {
    CSaveData *save_data;
    int        index;
    int        value;

    index = GetStackInt(stack++);
    value = GetStackInt(stack);
    save_data = GetSaveData();

    if (save_data == NULL) {
        return 0;
    }

    save_data->SetShortFlag(index, value);
    return 1;
}

int _GET_CNT(RS_STACKDATA *stack, int arg_count) {
    CSaveData *save_data;
    int        index;

    index = GetStackInt(stack++);
    save_data = GetSaveData();

    if (save_data == NULL) {
        return 0;
    }

    SetStack(stack, save_data->GetShortFlag(index));
    return 1;
}

int _SET_CURRENT_DIR(RS_STACKDATA *stack, int argc) {
    char *dir = NULL;

    if (argc > 0) {
        dir = GetStackString(stack);
    }

    if (dir == NULL || strcmp(dir, "DEFAULT") == 0 || strcmp(dir, "") == 0) {
        SetCurrentDir(NULL);
    } else {
        SetCurrentDir(dir);
    }

    return 1;
}

int _CHANGE_DIR(RS_STACKDATA *stack, int argc) {
    char *dir = NULL;

    if (argc > 0) {
        dir = GetStackString(stack);
    }

    if (dir == NULL || strcmp(dir, "DEFAULT") == 0 || strcmp(dir, "") == 0) {
        SetCurrentDir(NULL);
    } else {
        ChangeDir(dir);
    }

    return 1;
}

int _DELETE_CHARA(RS_STACKDATA *stack, int argc) {
    int charaNo;
    int deleteTexture = 1;
    charaNo = GetStackInt(stack++);
    if (argc >= 2) {
        deleteTexture = GetStackInt(stack);
    }
    int texBlock = EventScene->GetCharaTexb(charaNo);

    if (texBlock >= 0) {
        mgCTextureManager *manager = &mgTexManager;
        if (deleteTexture == 1) {
            manager->DeleteBlock(texBlock);
        }
    }
    EventScene->DeleteChara(charaNo);
    int i;
    int offset;
    for (i = 0, offset = 0; i < 32; i++, offset += 0x10) {
        CEoh *handle = (CEoh *)((u8 *)&EventObjHandleMother + offset);
        if (handle->type == 0) {
            int *charaSlot = &handle->scene_no;
            if (charaNo == handle->scene_no) {
                handle->type = -1;
                *charaSlot = -1;
                handle->world_coord = 1;
                handle->object = NULL;
                handle->object = NULL;
                handle->object = NULL;
                handle->object = NULL;
                handle->object = NULL;
            }
        }
    }
    return 1;
}

int _LOAD_MOTION_sub(int stack_no, char *name, int chara_no, u32 *pack) {
    char         label[0x20];
    mgCMemory   *stack = EventScene->GetStack(stack_no);
    CCharacter2 *chara = EventScene->GetCharacter(chara_no);

    if (chara == NULL) {
        return 0;
    }

    int tex_block = EventScene->GetCharaTexb(chara_no);

    if (tex_block < 0) {
        return 0;
    }

    sprintf(label, "ev%d", chara_no);
    mgCTextureManager *manager = &mgTexManager;

    if (chara_no >= 8) {
        strcpy(manager->name_suffix, label);
    }

    chara->LoadPack(pack, name, stack, stack, stack, tex_block, 0);

    if (chara_no >= 8) {
        manager->name_suffix[0] = 0;
    }

    return 1;
}

int _LOAD_MOTION(RS_STACKDATA *stack, int argc) {
    int   stack_no;
    int   chara_no;
    char *pack_name;
    char *motion_name;
    u32  *pack;

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            stack_no = GetArgInt(args++);
            pack_name = GetArgString(args++);
            motion_name = GetArgString(args++);
            chara_no = GetArgInt(args);
            break;
        }
        case 4:
            stack_no = GetStackInt(stack++);
            pack_name = GetStackString(stack++);
            motion_name = GetStackString(stack++);
            chara_no = GetStackInt(stack);
            break;
        default:
            return 0;
    }

    pack = GetLoadBGBuff(pack_name, 0);

    if (pack == NULL) {
        return 0;
    }

    return _LOAD_MOTION_sub(stack_no, motion_name, chara_no, pack);
}

int _MAP_JUMP(RS_STACKDATA *stack, int argc) {
    EdEventInfo.jump_point = GetStackInt(stack++);

    switch (stack->type) {
        case 0:
            strcpy(EdEventInfo.jump_map_name, GetMapName(GetStackInt(stack++), NULL));
            break;
        case 2:
            strcpy(EdEventInfo.jump_map_name, GetStackString(stack++));
            break;
        default:
            return 0;
    }

    if (argc > 2) {
        EdEventInfo.event_no = GetStackInt(stack);
    } else {
        EdEventInfo.event_no = 100;
    }

    EdEventInfo.request = exit_map_jump;
    return 1;
}

int _SET_RAIN(RS_STACKDATA *stack, int argc) {
    if (GetStackInt(stack) != 0) {
        EventRain.Start();
    } else {
        EventRain.Stop();
    }

    return 1;
}

int _DEL_EXT_MOTION(RS_STACKDATA *stack, int argc) {
    CCharacter2 *character = EventScene->GetCharacter(GetStackInt(stack));

    if (character == NULL) {
        return 0;
    }

    character->DeleteExtMotion();
    return 1;
}

int _SET_MARKER(RS_STACKDATA *stack, int argc) {
    return 1;
}

int _SET_WORLD_COORD(RS_STACKDATA *stack, int argc) {
    if (argc == 4) {
        EdEventInfo.world_coord_pos[0] = GetStackFloat(stack++);
        EdEventInfo.world_coord_pos[1] = GetStackFloat(stack++);
        EdEventInfo.world_coord_pos[2] = GetStackFloat(stack++);
        EdEventInfo.world_coord_pos[3] = 1.0f;
        EdEventInfo.world_coord_rot[0] = 0.0f;
        EdEventInfo.world_coord_rot[1] = GetStackFloat(stack);
        SetWorldCoordFlg = 1;
        EdEventInfo.world_coord_rot[2] = 0.0f;
        EdEventInfo.world_coord_rot[3] = 0.0f;
        return 1;
    } else if (argc == 0) {
        InitWorldCoord();
        return 1;
    }

    return 0;
}

/**
 * Finishes the running event and returns its completion status.
 */
int _FINISH(RS_STACKDATA *stack, int argc) {
    return EdEventFinish();
}

int _GET_DUN_WORLD_COORD(RS_STACKDATA *stack, int argc) {

    float position[4];
    float indexed_position[6];
    float angle;
    float indexed_angle;

    if (argc == 4) {
        if (GetDungeonEventPoint(position, &angle, 0) == 0) {
            return 0;
        }

        SetStack(stack++, position[0]);
        SetStack(stack++, position[1]);
        SetStack(stack++, position[2]);
        SetStack(stack, angle);
        return 1;
    }

    if (argc == 5) {
        if (GetDungeonEventPoint(indexed_position, &indexed_angle, GetStackInt(stack + 4)) == 0) {
            return 0;
        }

        SetStack(stack++, indexed_position[0]);
        SetStack(stack++, indexed_position[1]);
        SetStack(stack++, indexed_position[2]);
        SetStack(stack, indexed_angle);
        return 1;
    }

    return 0;
}
int _LOAD_IMG(RS_STACKDATA *stack, int argc) {
    int size;
    int stackNo = GetStackInt(stack++);
    char *fileName = GetStackString(stack++);
    int imageNo = GetStackInt(stack++);
    int num = EventScene->event_texb_num;
    int base = EventScene->event_texb;
    if (num <= 0 || num < imageNo) {
        return 0;
    }
    int block = base + imageNo;
    u_char *file = (u_char *)GetLoadBGBuff(fileName, &size);
    if (file == NULL) {
        return 0;
    }
    mgCMemory *memory = EventScene->GetStack(stackNo);
    memory->Align64();
    u_char *image = (u_char *)memory->stAllocTest(size / 16 + 1);
    if (image == NULL) {
        return 0;
    }
    memory->stAlloc64(size / 16 + 1);
    memcpy(image, file, size);
    mgTexManager.EnterIMGFile(image, block, memory, NULL);
    if (argc == 3) {
        if (esMother.Set(imageNo, block) == 0) {
            return 0;
        }
    } else if (argc == 4) {
        SetStack(stack, block);
    }
    return 1;
}
int _DEL_IMG(RS_STACKDATA *stack, int argc) {
    mgTexManager.DeleteBlock(EventScene->event_texb + GetStackInt(stack));
    return 1;
}

int _SET_DNG_MAP(RS_STACKDATA *stack, int argc) {
    GetStackInt(stack++);
    GetStackInt(stack);
    return 1;
}

int _LOAD_ITEM(RS_STACKDATA *stack, int argc) {
    char *name[32];
    int   stack_no;
    int   chara_no;
    int   item_no;
    int   index = 0;
    u32  *pack;

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack), argc);

            if (args == NULL) {
                return 0;
            }

            stack_no = GetArgInt(args++);
            item_no = GetArgInt(args++);
            name[0] = GetArgString(args++);
            chara_no = GetArgInt(args++);

            if (argc >= 5) {
                index = GetArgInt(args);
            }

            break;
        }
        case 4:
        case 5:
            stack_no = GetStackInt(stack++);
            item_no = GetStackInt(stack++);
            name[0] = GetStackString(stack++);
            chara_no = GetStackInt(stack++);

            if (argc >= 5) {
                index = GetStackInt(stack);
            }

            break;
        default:
            return 0;
    }

    pack = GetLoadBGBuff(GetItemFilePath(item_no, index), 0);

    if (pack != NULL) {
        return _LOAD_CHARA_sub(stack_no, name, chara_no, pack);
    }

    return 0;
}

int _GOTO_USE_ITEM(RS_STACKDATA *stack, int argc) {
    int arg_no;

    if (stack->type != RS_PTR) {
        return 0;
    }

    RS_STACKDATA *item_slot = stack->val.p;
    arg_no = 1;
    MenuArg.open_type = menu_use_item;
    stack++;
    MenuArg.param[0] = arg_no;
    p_use_item = item_slot;

    if (argc > 1) {
        do {
            MenuArg.param[arg_no] = GetStackInt(stack++);
            arg_no++;
        } while (arg_no < argc);
    }

    MenuArg.param[arg_no] = 0;
    EdEventInfo.command_mode = request_menu;
    return 1;
}

int _SET_LOCAL_FLAG(RS_STACKDATA *stack, int argc) {
    int index = GetStackInt(stack++);
    SetLocalFlag(index, GetStackInt(stack));
    return 1;
}

int _GET_LOCAL_FLAG(RS_STACKDATA *stack, int argc) {
    int index = GetStackInt(stack++);

    argc = GetLocalFlag(index);
    SetStack(stack, argc);
    return 1;
}

int _GOTO_SELECT_PARTY(RS_STACKDATA *stack, int argc) {
    MenuArg.open_type = menu_select_party;
    EdEventInfo.command_mode = request_menu;
    return 1;
}

int _SET_LOADBG_FILE(RS_STACKDATA *stack, int argc) {
    char    path[0x4C];
    int     size;
    int     i;
    u_char *buffer = (u_char *) read_buffer;
    StartReadBG();

    for (i = 0; i < argc; i++) {
        char *name;

        switch (stack->type) {
            case RS_INT: {
                int item_no = GetStackInt(stack++);
                name = GetItemFilePath(item_no, GetStackInt(stack++));
                i++;
                break;
            }
            case RS_STR:
                name = GetStackString(stack++);
                break;
            default:
                continue;
        }

        strcpy(path, name);
        FileNameConvLanguage(path);

        if (LoadFileBG(path, (u_long128 *) buffer, &size) == 0) {
            return 0;
        }

        int rest = size & 0x3F;
        int padding = 0;

        if (rest != 0) {
            padding = 0x40 - rest;
        }

        buffer += (size + padding) & ~0xF;
    }

    EdEventInfo.pack_loaded = 0;

    if (EdEventInfo.stream_reading == 1) {
        printf("\n-------------------------------------------------------------------\n");
        printf("EVENT ERR [NOW STREAM OPEN!!! <FILE ACCESS ERROR>]\n");
        printf("\n-------------------------------------------------------------------\n");

        while (1) {
        }
    }

    return 1;
}

int _SET_LOADBG_FILE_MONS_TALK(RS_STACKDATA *stack, int argc) {
    char       path[0x8C];
    int        size;
    u_long128 *buffer = read_buffer;
    StartReadBG();
    sprintf(path, "dungeon/msg/mostalk%d_%d.txt", DngStatus.dungeon_no, LanguageCode);

    if (LoadFileBG(path, buffer, &size) == 0) {
        return 0;
    }

    EdEventInfo.pack_loaded = 0;
    return 1;
}

int _CHECK_LOADBG_FILE(RS_STACKDATA *stack, int argc) {
    argc = ReadBGSync();
    SetStack(stack, argc);
    return 1;
}

int _GET_TB_ITEMNO(RS_STACKDATA *stack, int argc) {
    return 0;
}

int _SET_TB_STATUS(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *area = &EventScene->battle_area;

    if (area == NULL) {
        return 0;
    }

    CTreasureBoxManager *manager = area->treasure_box;

    if (manager == NULL) {
        return 0;
    }

    int           near_box = manager->near_box;
    int           box_no = near_box;
    CTreasureBox *box = &manager->box[box_no];

    if (box == NULL) {
        return 0;
    }

    box->state = GetStackInt(stack);
    return 1;
}

int _SET_TB_ANGLE(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *area = &EventScene->battle_area;

    if (area == NULL) {
        return 0;
    }

    CTreasureBoxManager *manager = area->treasure_box;

    if (manager == NULL) {
        return 0;
    }

    int           near_box = manager->near_box;
    int           box_no = near_box;
    CTreasureBox *box = &manager->box[box_no];

    if (box == NULL) {
        return 0;
    }

    box->lid_open = GetStackFloat(stack);
    return 1;
}

int _ADD_ITEM(RS_STACKDATA *stack, int argc) {
    int item_no = GetStackInt(stack++);
    int count = 1;

    if (argc == 2) {
        count = GetStackInt(stack);
    }

    CUserDataManager *user_data = NULL;
    CSaveData        *save = GetSaveData();

    if (save != NULL) {
        user_data = &save->user_data;
    }

    if (user_data == NULL) {
        return 0;
    }

    return user_data->GetItem(item_no, count);
}

int _SUB_ITEM(RS_STACKDATA *stack, int argc) {

    int item_no;
    int count = 1;
    item_no = GetStackInt(stack++);

    if (argc >= 2) {
        count = GetStackInt(stack);
    }

    CSaveData *save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    CUserDataManager *user_data = &save->user_data;

    if (user_data == NULL) {
        return 0;
    }

    user_data->DeleteItem(item_no, count);
    return 1;
}

int _GET_ITEM_TYPE(RS_STACKDATA *stack, int argc) {
    int item_type = GetItemDataType(GetStackInt(stack++));
    int category;

    if (item_type == 0) {
        return 0;
    }

    switch (item_type) {
        case 1:
            category = 1;
            break;
        case 2:
            category = 2;
            break;
        case 3:
            category = 3;
            break;
        case 4:
            category = 4;
            break;
        default:
            category = 0;
            break;
    }

    SetStack(stack, category);
    return 1;
}

int _GET_ITEM_SPACE(RS_STACKDATA *stack, int argc) {
    CUserDataManager *user_data = NULL;
    CSaveData        *save = GetSaveData();

    if (save != NULL) {
        user_data = &save->user_data;
    }

    if (user_data == NULL) {
        return 0;
    }

    argc = user_data->SearchSpaceUsedData();
    SetStack(stack, argc);
    return 1;
}

int GetConfigCaptionOff() {
    int        caption_off = 0;
    CSaveData *save = GetSaveData();

    if (save != NULL) {
        SV_CONFIG_OPTION *config = &save->config;

        if (config != NULL) {
            caption_off = config->caption_off;
        }
    }

    return caption_off;
}
int LoadMovie(char *name, mgCMemory *memory, bool skip) {
    CMovie movie __attribute__((aligned(32)));
    int captionWidth;
    int captionHeight;
    int captionBlock;
    int captionOff;
    int fontBlock;
    mgCTexture *movieTexture;
    int movieBlock;
    int frame;

    movie.Load(name, memory, 0x200, 0x1A0, true, false, skip);
    printf("/////////////////// SIZE REMAIN = %dn /////////////////", (memory->stack_size - memory->stack_used) * 0x10 / 0x400);
    movieBlock = EventScene->event_texb;
    if (EventScene->event_texb_num <= 0) {
        return 0;
    }
    mgCTextureManager *textures = &mgTexManager;
    textures->DeleteBlock(movieBlock);
    textures->EnterTexture(movieBlock, "moviework", NULL, mgScreenWidth, mgScreenHeight, mgScreenDepth, 0, 0LL, 0);
    captionBlock = movieBlock + 1;
    captionOff = GetConfigCaptionOff();
    fontBlock = -1;
    if (EdEventInfo.caption_enable != 0 && captionOff == 0) {
        mgCTexture *fontTexture = textures->GetTexture("gaiji", fontBlock);
        if (fontTexture != NULL) {
            fontBlock = fontTexture->block;
            textures->DeleteBlock(fontBlock);
            textures->EnterTexture(captionBlock, "movieworkte", NULL, mgScreenWidth, mgScreenHeight, mgScreenDepth, 0, 0LL, 0);
            ReLoadFontTexture(captionBlock);
            textures->EnterIMGFile(GetFontTex2ImgPtr(), captionBlock, NULL, NULL);
        } else {
            EdEventInfo.caption_enable = 0;
        }
    }
    textures->ReloadTexture(movieBlock, (sceVif1Packet *)NULL);
    movieTexture = textures->GetTexture("moviework", movieBlock);
    movie.Play("moviework");
    movie.SwitchThread();
    while (movie.IsStarted() == 0) {
        movie.SwitchThread();
    }
    movie.SwitchThread();
    CFont font;
    if (EdEventInfo.caption_enable != 0) {
        if (captionOff == 0) {
            font.Init();
            font.Preset(7);
            font.SetFuchi(8);
        }
    }
    frame = 0;
    while (true) {
        if (frame != 0) {
            mgBeginFrame(NULL);
        }
        GamePad__2.UpDate();
        if (movie.EndCheck() != 0 || (DebugFlag != 0 && GamePad__2.Down(PAD_START) != 0)) {
            movie.Term();
            textures->ReloadTexture(movieBlock, (sceVif1Packet *)NULL);
            mgBeginFrame(NULL);
            mgCDrawPrim endDraw;
            endDraw.Initialize(NULL, NULL);
            endDraw.AlphaTestEnable(0);
            endDraw.TextureMapEnable(1);
            endDraw.Begin(MG_PRIM_SPRITE);
            endDraw.Color(0, 0, 0, 0x80);
            endDraw.Vertex(0, 0, 0);
            endDraw.Vertex(mgScreenWidth, mgScreenHeight, 0);
            endDraw.Texture(movieTexture);
            endDraw.Color(0x80, 0x80, 0x80, 0x80);
            endDraw.TextureCrd(1, 1);
            endDraw.Vertex(0, 0, 0);
            endDraw.TextureCrd(0x1FE, 0x19E);
            endDraw.Vertex(mgScreenWidth, mgScreenHeight, 0);
            endDraw.End();
            EventScene->fade.FadeOut(1, 0.0f, 0.0f, 0.0f);
            mgEndFrame(NULL);
            mgBeginFrame(NULL);
            memory->stack_used = 0;
            memory->lock = 0;
            textures->DeleteBlock(movieBlock);
            if (EdEventInfo.caption_enable != 0 && captionOff == 0) {
                textures->DeleteBlock(captionBlock);
                textures->EnterIMGFile(GetGaijiImgPtr(), fontBlock, NULL, NULL);
                ReLoadFontTexture(fontBlock);
                textures->EnterIMGFile(GetFontTex2ImgPtr(), fontBlock, NULL, NULL);
            }
            return 1;
        }
        textures->ReloadTexture(movieBlock, (sceVif1Packet *)NULL);
        movie.SwitchThread();
        mgCDrawPrim frameDraw;
        frameDraw.Initialize(NULL, NULL);
        frameDraw.AlphaTestEnable(0);
        frameDraw.TextureMapEnable(1);
        frameDraw.Begin(MG_PRIM_SPRITE);
        frameDraw.Color(0, 0, 0, 0x80);
        frameDraw.Vertex(0, 0, 0);
        frameDraw.Vertex(mgScreenWidth, mgScreenHeight, 0);
        frameDraw.Texture(movieTexture);
        frameDraw.Color(0x80, 0x80, 0x80, 0x80);
        frameDraw.TextureCrd(1, 1);
        frameDraw.Vertex(0, 0, 0);
        frameDraw.TextureCrd(0x1FE, 0x19E);
        frameDraw.Vertex(mgScreenWidth, mgScreenHeight, 0);
        frameDraw.End();
        EventScene->fade.Draw();
        EventScene->fade.FadeStep();
        if (EdEventInfo.caption_enable != 0) {
            char *text = NULL;
            if (captionOff == 0) {
                char caption[0xE1];
                int i;
                int x;
                int y;
                for (i = 0; i < 18; i++) {
                    if (EdEventInfo.caption_start[i] <= frame &&
                        frame <= EdEventInfo.caption_start[i] + EdEventInfo.caption_frames[i]) {
                        char *line = EdEventInfo.caption_text[i];
                        font.CalcDrawWH(line, &captionWidth, &captionHeight);
                        x = (int)CalcAutoPosSet(0.0f, float(512), (float)captionWidth, 0.5f);
                        y = fptosi(CalcAutoPosSet(0.0f, 480.0f, (float)captionHeight, 0.95f));
                        memset(caption, 0, 0xE1);
                        My_strncpy(caption, EdEventInfo.caption_text[i], (frame - EdEventInfo.caption_start[i]) / 2 * 2);
                        text = caption;
                    }
                }
                if (text != NULL) {
                    textures->ReloadTexture(captionBlock, (sceVif1Packet *)NULL);
                    font.DrawDirect(caption, x, y);
                }
            }
        }
        mgEndFrame(NULL);
        frame++;
    }
}
int _LOAD_MOVIE(RS_STACKDATA *stack, int argc) {
    int        stack_no = GetStackInt(stack++);
    char      *name = GetStackString(stack++);
    mgCMemory *memory = EventScene->GetStack(stack_no);
    int        skip = 1;

    if (argc >= 3) {
        skip = GetStackInt(stack);
    }

    return LoadMovie(name, memory, skip != 0);
}

int _INIT_LOCAL_CNT(RS_STACKDATA *stack, int argc) {
    InitLocalCnt();
    return 1;
}

int _SET_CROSSFADE(RS_STACKDATA *stack, int argc) {
    int frames;
    EventScene->fade.CaptureScreen();

    if (argc == 3) {
        int direction = GetStackInt(stack++);
        int color = GetStackInt(stack++);
        frames = GetStackInt(stack) * 50 / 60;

        if (frames <= 0) {
            frames = 1;
        }

        if (direction == 0) {
            EventScene->fade.CrossFadeIn(color, frames, float(1));
        } else {
            EventScene->fade.CrossFadeOut(color, frames, float(1));
        }
    } else {
        frames = GetStackInt(stack) * 50 / 60;

        if (frames <= 0) {
            frames = 1;
        }

        EventScene->fade.CrossFade(frames, 1.0f);
    }

    return 1;
}

int _GET_ADJUST_POLYGON_SCALE(RS_STACKDATA *stack, int argc) {
    int          chara_no = GetStackInt(stack++);
    float        size = GetStackFloat(stack++);
    CCharacter2 *chara = GetCharacter(chara_no);

    if (chara == NULL) {
        return 0;
    }

    if (chara->CObjectFrame::frame == NULL) {
        return 0;
    }

    SetStack(stack, MenuAdjustPolygonScale(chara->CObjectFrame::frame, size));
    return 1;
}

int _SET_TIME(RS_STACKDATA *stack, int argc) {
    EventScene->SetTime(GetStackFloat(stack));
    return 1;
}

int _SET_ACTIVE_LIGHT(RS_STACKDATA *stack, int argc) {

    CMap *maps[8];

    int light_no = GetStackInt(stack);

    if (EventScene->GetActiveMap(maps, 8) <= 0) {
        return 0;
    }

    if (light_no >= 0) {
        if (light_no < maps[0]->map_info.lighting_info_num) {
            maps[0]->map_info.active_light_no = light_no;
        }
    }

    return 1;
}

int _SET_PAKU_ANIM(RS_STACKDATA *stack, int argc) {
    char *name2;
    int   eoh_no = GetStackInt(stack++);
    char *name = GetStackString(stack++);
    name2 = NULL;

    if (argc > 2) {
        name2 = GetStackString(stack);
    }

    PakuAnimEohNo = eoh_no;
    strcpy(PakuAnimName, name);

    if (name2 != NULL) {
        strcpy(PakuAnimName2, name2);
    } else {
        strcpy(PakuAnimName2, "");
    }

    return 1;
}

int _RESET_PAKU_ANIM(RS_STACKDATA *stack, int argc) {
    PakuAnimEohNo = -1;
    memset(PakuAnimName, 0, sizeof(PakuAnimName));
    memset(PakuAnimName2, 0, sizeof(PakuAnimName2));
    return 1;
}

int _TRG_PAKU_ANIM(RS_STACKDATA *stack, int argc) {
    if (GetStackInt(stack) != 0) {
        if (strcmp(PakuAnimName2, "") != 0) {
            EventObjHandleMother.SetTexAnim(PakuAnimEohNo, 0, PakuAnimName2);
        }

        EventObjHandleMother.SetTexAnim(PakuAnimEohNo, 1, PakuAnimName);
    } else {
        EventObjHandleMother.SetTexAnim(PakuAnimEohNo, 0, PakuAnimName);

        if (strcmp(PakuAnimName2, "") != 0) {
            EventObjHandleMother.SetTexAnim(PakuAnimEohNo, 1, PakuAnimName2);
        }
    }

    return 1;
}
int _RESET_CAMERA(RS_STACKDATA *stack, int argc) {
    int mode;
    float follow[4];
    float followOffset[4];
    float charaPos[4];
    float cameraPos[4];
    float pos[4];
    float rot[4];
    float target[4];
    CCameraControl *camera;
    mgCCameraFollow *referenceCamera;
    mgCCameraFollow *beforeCamera;
    CCharacter2 *chara;
    float dx;
    float dy;
    float dz;
    float distance;
    mode = GetStackInt(stack++);
    float angle;
float height;
height = angle = 0.0f;
    if (argc > 1) {
        angle = GetStackFloat(stack++);
    }
    if (argc > 2) {
        height = GetStackFloat(stack);
    }
    camera = NULL;
    if (mode == 0) {
        camera = (CCameraControl *)EventScene->GetCamera(EventScene->active_camera);
    }
    if (mode == 1) {
        camera = (CCameraControl *)EventScene->GetCamera(EventScene->before_camera);
    }
    if (camera == NULL) {
        return 0;
    }
    referenceCamera = (mgCCameraFollow *)EventScene->GetCamera(EventScene->before_camera);
    if (referenceCamera == NULL) {
        return 0;
    }
    referenceCamera->GetFollow(follow);
    referenceCamera->GetFollowOffset(followOffset);
    if (mode == 0) {
        chara = EventScene->GetCharacter(0);
        if (chara == NULL) {
            return 0;
        }
        chara->GetPosition(charaPos);
        SetCamWorldCoord(camera);
        camera->GetPos(cameraPos);
        dx = cameraPos[0] - charaPos[0];
        dy = cameraPos[1] - charaPos[1];
        dz = cameraPos[2] - charaPos[2];
        distance = sqrtf(dx * dx + dz * dz);
        if (argc < 3) {
            height = dy - followOffset[1];
        }
        if (argc < 2) {
            angle = atan2f(dx, dz);
        }
        float fx = charaPos[0];
        float fy = charaPos[1];
        float fz = charaPos[2];
        camera->FollowOn();
        camera->SetFollow(fx, fy, fz);
        camera->SetFollowOffset(followOffset[0], followOffset[1], followOffset[2]);
        camera->SetDistance(distance);
        camera->SetHeight(height);
        camera->SetAngleSoon(angle);
        beforeCamera = (mgCCameraFollow *)EventScene->GetCamera(EventScene->before_camera);
        referenceCamera = (mgCCameraFollow *)EventScene->GetCamera(EventScene->active_camera);
        *beforeCamera = *referenceCamera;
        SetWorldCoordFlg = 0;
        return 1;
    }
    if (mode == 1) {
        camera->FollowOff();
        distance = camera->GetDistance();
        if (argc < 3) {
            height = camera->GetHeight();
        }
        chara = EventScene->GetCharacter(0);
        if (chara == NULL) {
            return 0;
        }
        chara->GetPosition(pos);
        chara->GetRotation(rot);
        CalcPosWorldCoord(pos);
        CalcPosWorldCoord(rot);
        target[0] = pos[0];
        target[1] = pos[1];
        target[2] = pos[2];
        target[3] = 1.0f;
        CalcPosWorldCoordGyaku(target);
        camera->ControlOff();
        camera->FollowOn();
        camera->SetFollow(target[0], target[1], target[2]);
        camera->SetFollowOffset(followOffset[0], followOffset[1], followOffset[2]);
        camera->SetDistance(distance);
        camera->SetHeight(height);
        camera->SetAngleSoon(rot[1] + angle);
        camera->Step(-1);
        camera->Step(1);
        camera->ControlOn();
        SetWorldCoordFlg = 0;
        return 1;
    }
    return 0;
}
int _GET_ACTIVE_CHR_NO(RS_STACKDATA *stack, int argc) {
    CUserDataManager *user_data = NULL;
    CSaveData        *save = GetSaveData();

    if (save != NULL) {

        user_data = &save->user_data;
    }

    if (user_data == NULL) {
        return 0;
    }

    SetStack(stack, user_data->active_chr_no);
    return 1;
}

int _SET_ACTIVE_CHR_NO(RS_STACKDATA *stack, int argc) {
    CUserDataManager *user_data = NULL;
    CSaveData        *save = GetSaveData();

    if (save != NULL) {
        user_data = &save->user_data;
    }

    if (user_data == NULL) {
        return 0;
    }

    user_data->SetActiveChrNo(GetStackInt(stack));
    return 1;
}

int _DNG_SET_FLOOR_ID(RS_STACKDATA *stack, int argc) {
    int        floor_id = GetStackInt(stack);
    CSaveData *save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    CSaveDataDungeon *dungeon = &save->save_dungeon;

    if (dungeon == NULL) {
        return 0;
    }

    dungeon->SetFloorID(floor_id);
    return 1;
}

int _DNG_GET_FLOOR_ID(RS_STACKDATA *stack, int argc) {
    CSaveData *save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    CSaveDataDungeon *dungeon = &save->save_dungeon;

    if (dungeon == NULL) {
        return 0;
    }

    SetStack(stack, dungeon->floor_id[dungeon->stage_id]);
    return 1;
}

int _SET_PAKU_MOTION(RS_STACKDATA *stack, int argc) {
    int   eoh_no = GetStackInt(stack++);
    char *name = GetStackString(stack++);
    int   type = GetStackInt(stack++);
    char *name2 = NULL;
    int   type2 = 0;

    if (argc > 3) {
        name2 = GetStackString(stack++);
        type2 = GetStackInt(stack);
    }

    PakuMotionEohNo = eoh_no;
    strcpy(PakuMotionName, name);
    PakuMotionType = type;

    if (name2 != NULL) {
        strcpy(PakuMotionName2, name2);
    } else {
        strcpy(PakuMotionName2, "");
    }

    PakuMotionType2 = type2;
    return 1;
}

int _RESET_PAKU_MOTION(RS_STACKDATA *stack, int argc) {
    PakuMotionEohNo = -1;
    memset(PakuMotionName, 0, sizeof(PakuMotionName));
    memset(PakuMotionName2, 0, sizeof(PakuMotionName2));
    return 1;
}

int _TRG_PAKU_MOTION(RS_STACKDATA *stack, int argc) {
    int mode = GetStackInt(stack);

    if (mode == 0) {
        EventObjHandleMother.SetMotion(PakuMotionEohNo, PakuMotionName,
                                       PakuMotionType, -1.0f);
        return 1;
    }

    if (strcmp(PakuMotionName2, "") == 0) {
        return 1;
    }

    if (mode == 1) {
        if (strcmp(PakuMotionName,
                   EventObjHandleMother.GetNowMotionName(PakuMotionEohNo)) == 0) {
            if (EventObjHandleMother.GetNowMotionStatus(PakuMotionEohNo) == 0 ||
                EventObjHandleMother.GetNowMotionStatus(PakuMotionEohNo) == 4) {
                EventObjHandleMother.SetMotion(PakuMotionEohNo,
                                               PakuMotionName2, PakuMotionType2, -1.0f);
                return 1;
            }

            return 1;
        }

        EventObjHandleMother.SetMotion(PakuMotionEohNo, PakuMotionName2,
                                       PakuMotionType2, -1.0f);
        return 1;
    }

    if (mode == 2) {
        EventObjHandleMother.SetMotion(PakuMotionEohNo, PakuMotionName2,
                                       PakuMotionType2, -1.0f);
        return 1;
    }

    return 0;
}

int _SET_BG_COLOR(RS_STACKDATA *stack, int argc) {
    float color[4];
    color[0] = GetStackFloat(stack++);
    color[1] = GetStackFloat(stack++);
    color[2] = GetStackFloat(stack++);

    if (argc >= 4) {
        color[3] = GetStackFloat(stack);
    } else {
        color[3] = 128.0f;
    }

    mgSetBackGround(color);
    return 1;
}

int _GOTO_DNG_MAP(RS_STACKDATA *stack, int argc) {
    MenuArg.open_type = menu_dng_map;
    MenuArg.param[0] = GetStackInt(stack);
    EdEventInfo.command_mode = request_menu;
    return 1;
}

int _GOTO_DNG(RS_STACKDATA *stack, int argc) {
    if (EdEventFinish() == 0) {
        return 0;
    }

    INIT_LOOP_ARG loop_arg;
    loop_arg.map_no = GetStackInt(stack++);
    loop_arg.floor_no = -1;
    loop_arg.event_no = -1;

    if (argc > 1) {
        loop_arg.floor_no = GetStackInt(stack++);
    }

    if (argc > 2) {
        loop_arg.event_no = GetStackInt(stack);
    }

    NextLoop(2, loop_arg);
    EdEventInfo.request = exit_start_loop;
    return 1;
}

int _GOTO_EDIT(RS_STACKDATA *stack, int argc) {
    if (EdEventFinish() == 0) {
        return 0;
    }

    INIT_LOOP_ARG loop_arg;
    loop_arg.map_no = GetStackInt(stack++);
    loop_arg.event_no = -1;

    if (argc > 1) {
        loop_arg.event_no = GetStackInt(stack);
    }

    NextLoop(1, loop_arg);
    EdEventInfo.request = exit_start_loop;
    return 1;
}

int _GET_MENU_PARAM(RS_STACKDATA *stack, int argc) {
    switch (argc) {
        case 5:
            SetStack(stack + 4, MenuArg.result[4]);
        case 4:
            SetStack(stack + 3, MenuArg.result[3]);
        case 3:
            SetStack(stack + 2, MenuArg.result[2]);
        case 2:
            SetStack(stack + 1, MenuArg.result[1]);
        case 1:
            SetStack(stack, MenuArg.result[0]);
            return 1;
        default:
            return 0;
    }
}

int _LOAD_CHARA_NPC(RS_STACKDATA *stack, int argc) {
    char  path[0x80];
    char *model_name[0x80];
    int   kind = GetStackInt(stack++);
    int   stack_no = GetStackInt(stack++);
    int   chara_no = GetStackInt(stack++);
    char *name;
    u32  *pack;

    if (chara_no <= 0) {
        return 0;
    }

    if (chara_no >= 32) {
        return 0;
    }

    if (kind == 0) {
        name = GetPartyCharaModelName(chara_no, 0);
    } else {
        name = GetPartyCharaModelName(chara_no, 2);
    }

    if (name == NULL) {
        return 0;
    }

    strcpy(path, name);
    model_name[0] = GetPartyCharaModelName(chara_no, 1);

    if (model_name[0] == NULL) {
        return 0;
    }

    kind = GetStackInt(stack);
    pack = GetLoadBGBuff(path, 0);

    if (pack != NULL) {
        return _LOAD_CHARA_sub(stack_no, model_name, kind, pack);
    }

    return 0;
}

int _AUTO_SET_TREASURE_BOX(RS_STACKDATA *stack, int argc) {
    float pos[4];

    if (argc < 2) {
        AutoSetTreasureBox();
    } else {
        int item_no = GetStackInt(stack++);
        pos[0] = GetStackFloat(stack++);
        pos[1] = GetStackFloat(stack++);
        pos[2] = GetStackFloat(stack++);
        pos[3] = 1.0f;
        AutoSetTreasureBox(item_no, pos, GetStackFloat(stack));
    }

    return 1;
}

int _AUTO_SET_MONSTER(RS_STACKDATA *stack, int argc) {
    float position[4];
    float direction[4];
    int   monster_no;
    int   param;

    if (GetNowLoopNo() != 2) {
        return 0;
    }

    if (argc < 2) {
        AutoSetMonster();
        return 1;
    }

    monster_no = GetStackInt(stack++);
    GetStackVector(position, stack);
    stack += 3;
    mgZeroVectorW(direction);

    if (argc >= 7) {
        GetStackVector(direction, stack);
        stack += 3;
    }

    if (argc == 8) {
        param = GetStackInt(stack);
    }

    AutoSetMonster(monster_no, position, direction, param);
    return 1;
}

int _LOAD_DUNGEON_MAP_FILE(RS_STACKDATA *stack, int argc) {
    if (argc < 1 || argc > 3) {
        return 0;
    }

    char *map_name = GetStackString(stack++);
    char *cfg_name = NULL;
    int   gen_flag = 0;

    if (argc >= 2) {
        cfg_name = GetStackString(stack++);
    }

    if (argc >= 3) {
        gen_flag = GetStackInt(stack);
    }

    LoadDungeonMapFile(map_name, cfg_name, gen_flag);
    return 1;
}

int _LOAD_MONSTER_FILE(RS_STACKDATA *stack, int argc) {
    if (GetNowLoopNo() != 2) {
        return 0;
    }

    switch (argc) {
        case 1:
            LoadMonsterFile();
            break;
        case 2: {
            int first = GetStackInt(stack++);
            LoadMonsterFile(first, GetStackInt(stack));
            break;
        }
        default:
            return 0;
    }

    return 1;
}

int _GET_NPC_STATUS(RS_STACKDATA *stack, int argc) {
    int npc_no = GetStackInt(stack++);

    if (npc_no <= 0) {
        return 0;
    }

    CUserDataManager *user_data = NULL;

    if (npc_no > 0x20) {
        return 0;
    }

    CSaveData *save = GetSaveData();

    if (save != NULL) {
        user_data = &save->user_data;
    }

    if (user_data == NULL) {
        return 0;
    }

    SetStack(stack, user_data->GetPartyCharaStatus(npc_no));
    return 1;
}

int _SET_NPC_STATUS(RS_STACKDATA *stack, int argc) {
    int npc_no = GetStackInt(stack++);
    int status = GetStackInt(stack);

    if (npc_no <= 0) {
        return 0;
    }

    CUserDataManager *user_data = NULL;

    if (npc_no > 0x20) {
        return 0;
    }

    CSaveData *save = GetSaveData();

    if (save != NULL) {
        user_data = &save->user_data;
    }

    if (user_data == NULL) {
        return 0;
    }

    user_data->SetPartyCharaStatus(npc_no, status);
    return 1;
}

int _GET_NOW_PARTY_CHARA(RS_STACKDATA *stack, int argc) {
    CUserDataManager *user_data = NULL;
    CSaveData        *save = GetSaveData();

    if (save != NULL) {
        user_data = &save->user_data;
    }

    if (user_data == NULL) {
        return 0;
    }

    SetStack(stack, user_data->NowPartyCharaID());
    return 1;
}

int _SET_LOCAL_CNT(RS_STACKDATA *stack, int argc) {
    int index = GetStackInt(stack++);
    return SetLocalCnt(index, GetStackInt(stack)) > 0;
}

int _GET_LOCAL_CNT(RS_STACKDATA *stack, int argc) {
    int index = GetStackInt(stack++);
    argc = GetLocalCnt(index);

    if (argc < 0) {
        return 0;
    }

    SetStack(stack, argc);
    return 1;
}

int _GET_LOCAL_CNT2(RS_STACKDATA *stack, int argc) {
    int index = GetStackInt(stack++);

    argc = GetLocalCnt2(index);
    SetStack(stack, argc);
    return 1;
}

int _GET_TRAIN_NPC_POS(RS_STACKDATA *stack, int argc) {
    TrainNpcTable table = {{
        {-40.0f, 55.0f, 60.0f, 1.57f},
        {40.0f, 55.0f, 60.0f, -1.57f},
        {-40.0f, 55.0f, -60.0f, 1.57f},
        {40.0f, 55.0f, -60.0f, -1.57f},
        {-40.0f, 55.0f, 115.0f, 1.57f},
        {40.0f, 55.0f, 115.0f, -1.57f},
        {-40.0f, 55.0f, -115.0f, 1.57f},
        {40.0f, 55.0f, -115.0f, -1.57f},
        {-40.0f, 55.0f, 170.0f, 1.57f},
        {40.0f, 55.0f, 170.0f, -1.57f},
        {-40.0f, 55.0f, -170.0f, 1.57f},
        {40.0f, 55.0f, -170.0f, -1.57f},
    }};
    int           index = GetStackInt(stack++);

    if (index < 0 || index >= 12) {
        return 0;
    }

    SetStack(stack++, table.row[index][0]);

    if (EventScene->now_map_no == 0x78) {
        SetStack(stack++, 0.0f);
    } else {
        SetStack(stack++, table.row[index][1]);
    }

    SetStack(stack++, table.row[index][2]);
    SetStack(stack, table.row[index][3]);
    return 1;
}

int _GOTO_DRAW_CHAPTER(RS_STACKDATA *stack, int argc) {
    MenuArg.open_type = menu_draw_chapter;
    MenuArg.param[0] = GetStackInt(stack) - 1;
    EdEventInfo.command_mode = request_menu;
    return 1;
}

int _SET_PROJECTION(RS_STACKDATA *stack, int argc) {
    EdEventInfo.projection = GetStackFloat(stack);
    return 1;
}

int _GET_PROJECTION(RS_STACKDATA *stack, int argc) {
    SetStack(stack, EdEventInfo.projection);
    return 1;
}

int _SET_FADE_IN(RS_STACKDATA *stack, int argc) {
    float color[4];
    mgZeroVector(color);
    int frames = GetStackInt(stack++) * 50 / 60;

    if (frames <= 0) {
        frames = 1;
    }

    if (argc >= 2) {
        GetStackVector(color, stack);
        EventScene->fade.FadeIn(frames, color[0], color[1], color[2]);
    } else {
        EventScene->fade.FadeIn(frames);
    }

    return 1;
}

int _SET_FADE_OUT(RS_STACKDATA *stack, int argc) {
    float color[4];
    mgZeroVector(color);
    int frames = GetStackInt(stack++) * 50 / 60;

    if (frames <= 0) {
        frames = 1;
    }

    if (argc >= 2) {
        GetStackVector(color, stack);
    }

    EventScene->fade.FadeOut(frames, color[0], color[1], color[2]);
    return 1;
}

int _DNG_DEBUG_COMMAND(RS_STACKDATA *stack, int argc) {
    ScriptDebugCommand(GetStackInt(stack));
    return 1;
}

int _CD_SEEK(RS_STACKDATA *stack, int argc) {

    sceCdlFILE *file_info;

    if (sceCdSearchFile(file_info, GetStackString(stack)) != 0) {
        return sceCdSeek(file_info->lsn);
    }

    return 0;
}

int _GET_ROT_LOOK_POS(RS_STACKDATA *stack, int argc) {
    float y = GetStackFloat(stack++);
    float x = GetStackFloat(stack++);
    SetStack(stack, atan2f(y, x));
    return 1;
}

static int _SET_MOTION_BLUR(RS_STACKDATA *stack, int argc) {
    EventScene->motion_blur = GetStackInt(stack);
    return 1;
}

int _LOAD_SCRIPT(RS_STACKDATA *stack, int argc) {
    char *name = GetStackString(stack++);
    int   event_no = GetStackInt(stack);

    if (name == NULL) {
        return 0;
    }

    strcpy(EdEventInfo.script_name, name);

    if (strstr(EdEventInfo.script_name, "_1") == NULL) {
        EdEventInfo.script_name[strlen(EdEventInfo.script_name) - 4] = 0;
        strcat(EdEventInfo.script_name, "_1.stb");
    }

    FileNameConvLanguage(EdEventInfo.script_name);
    EdEventInfo.event_no = event_no;
    EdEventInfo.request = EVENT_REQUEST_LOAD_SCRIPT;
    return 1;
}

int _SET_TALK_CAMERA(RS_STACKDATA *stack, int argc) {
    /**
     * Camera offsets available to the scripted conversation camera.
     */
    static float vv[3][4] = {
        {-94.0f, 35.5f, -106.5f, 1.0f},
        {105.0f, 32.5f, -28.5f, 1.0f},
        {113.0f, 34.5f, 82.5f, 1.0f},
    };

    float middle[4];
    float offset[4];
    float rotation[4][4];

    struct {
        float v[3];
        u32   w;
    } from, to;

    float  angle;
    float *middle_y;
    from.v[0] = GetStackFloat(stack++);
    from.v[1] = GetStackFloat(stack++);
    from.v[2] = GetStackFloat(stack++);
    to.v[0] = GetStackFloat(stack++);
    to.v[1] = GetStackFloat(stack++);
    to.v[2] = GetStackFloat(stack++);
    angle = GetStackFloat(stack++);
    sceVu0AddVector(middle, from.v, to.v);
    sceVu0ScaleVector(middle, middle, 0.5f);
    middle_y = &middle[1];
    *middle_y += 30.0f;
    sceVu0UnitMatrix(rotation);
    sceVu0RotMatrixY(rotation, rotation, angle);
    sceVu0ApplyMatrix(offset, rotation, vv[1]);
    sceVu0AddVector(offset, middle, offset);
    SetStack(stack++, offset[0]);
    SetStack(stack++, offset[1]);
    SetStack(stack++, offset[2]);
    SetStack(stack++, middle[0]);
    SetStack(stack++, *middle_y);
    SetStack(stack, middle[2]);
    return 1;
}

int _HIT_EFFECT(RS_STACKDATA *stack, int argc) {
    float position[4];
    float spread;
    float speed;
    float power;
    float gravity;
    int   life;
    int   count;
    int   index = GetStackInt(stack++);
    position[0] = GetStackFloat(stack++);
    position[1] = GetStackFloat(stack++);
    position[2] = GetStackFloat(stack++);
    position[3] = 1.0f;
    float direction[4] = {0.0f, 1.0f, 0.0f, 1.0f};
    spread = 50.0f;
    speed = 35.0f;
    power = 0.0f;
    gravity = 0.05f;
    life = 30;
    count = 32;

    if (argc >= 5) {
        GetStackVector(direction, stack);
        stack += 3;
        spread = GetStackFloat(stack++);
        speed = GetStackFloat(stack++);
        power = GetStackFloat(stack++);
        gravity = GetStackFloat(stack++);
        life = GetStackInt(stack++);
        count = GetStackInt(stack);
    }

    HitEffect[index].SethitEffect(position, direction, spread, speed, power, gravity, life, count);
    HitEffect[index].kind = 1;
    return 1;
}

/**
 *
 * Copies a scene character into another slot using the requested event memory stack.
 *
 */
int _COPY_CHARA(RS_STACKDATA *stack, int argc) {
    int stack_no;
    int src_no;
    int dst_no;

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            stack_no = GetArgInt(args++);
            src_no = GetArgInt(args++);
            dst_no = GetArgInt(args);
            break;
        }
        case 3:
            stack_no = GetStackInt(stack++);
            src_no = GetStackInt(stack++);
            dst_no = GetStackInt(stack);
            break;
        default:
            return 0;
    }

    mgCMemory *memory = EventScene->GetStack(stack_no);

    if (memory == NULL) {
        return 0;
    }

    CCharacter2 *source = GetCharacter(src_no);
    CCharacter2 *copy;

    copy = new (memory->Alloc(0x68)) CCharacter2;

    if (source == NULL) {
        return 0;
    }

    if (copy == NULL) {
        return 0;
    }

    EventScene->DeleteChara(dst_no);
    int slot = EventScene->AssignChara(dst_no, copy, NULL);

    if (slot < 0) {
        return 0;
    }

    EventScene->SetStatus(1, slot, 5);
    source->Copy(*GetCharacter(dst_no), memory);
    EventScene->SetCharaTexb(dst_no, EventScene->GetCharaTexb(src_no));
    return 1;
}

int _GET_START_BUTTON(RS_STACKDATA *stack, int argc) {
    SetStack(stack, EdEventInfo.start_button);
    return 1;
}

int _MOVE_INTERIOR(RS_STACKDATA *stack, int argc) {
    EdEventInfo.jump_point = GetStackInt(stack++);
    strcpy(EdEventInfo.jump_map_name, GetStackString(stack++));

    if (argc > 2) {
        EdEventInfo.event_no = GetStackInt(stack);
    } else {
        EdEventInfo.event_no = 100;
    }

    EdEventInfo.request = exit_enter_interior;
    return 1;
}

int _GET_MONSTER_TALK_DATA(RS_STACKDATA *stack, int argc) {
    if (argc == 2) {
        SetStack(stack++, EdEventInfo.monster_talk[0]);
        SetStack(stack, EdEventInfo.monster_talk[2]);
    } else if (argc == 3) {
        SetStack(stack++, EdEventInfo.monster_talk[0]);
        SetStack(stack++, EdEventInfo.monster_talk[1]);
        SetStack(stack, EdEventInfo.monster_talk[2]);
    } else {
        return 0;
    }

    return 1;
}

int _FUNC_POINT_SHOW(RS_STACKDATA *stack, int argc) {
    CFuncPoint *func_point;
    CMap       *map = EventScene->GetMap(EventScene->active_map);

    if (map == NULL) {
        return 0;
    }

    switch (stack->type) {
        case RS_INT: {
            int        parts_no = GetStackInt(stack++);
            char      *name = GetStackString(stack++);
            CMapParts *parts = map->GetPlaceParts(parts_no);

            if (parts == NULL) {
                return 0;
            }

            func_point = parts->func_point_mngr.Search(name);
            break;
        }
        case RS_STR: {
            char *place_name = GetStackString(stack++);
            char *name = GetStackString(stack++);

            if (strcmp(place_name, "") != 0) {
                CMapParts *parts = map->GetPlaceParts(place_name);

                if (parts == NULL) {
                    return 0;
                }

                func_point = parts->func_point_mngr.Search(name);
            } else {
                func_point = map->func_point.Search(name);
            }

            break;
        }
    }

    if (func_point == NULL) {
        return 0;
    }

    func_point->enable = GetStackInt(stack);
    return 1;
}

int _GET_NOW_MAP_NO(RS_STACKDATA *stack, int argc) {
    SetStack(stack, EventScene->now_map_no);
    return 1;
}

int _GET_NOW_SUBMAP_NO(RS_STACKDATA *stack, int argc) {
    SetStack(stack, EventScene->now_sub_map_no);
    return 1;
}

int _GET_OLD_MAP_NO(RS_STACKDATA *stack, int argc) {
    SetStack(stack, EventScene->old_map_no);
    return 1;
}

int _GET_OLD_SUBMAP_NO(RS_STACKDATA *stack, int argc) {
    SetStack(stack, EventScene->old_sub_map_no);
    return 1;
}

int _SET_RAIN_CHARA_NO(RS_STACKDATA *stack, int argc) {
    EventRain.SetCharNo(GetStackInt(stack));
    return 1;
}

int _GET_EDIT_PARTS_POS(RS_STACKDATA *stack, int argc) {
    float     pos[4];
    float     rot[4];
    char     *name = GetStackString(stack++);
    CEditMap *map;

    if ((map = (CEditMap *) EventScene->GetMap(EventScene->active_map)) == NULL) {
        return 0;
    }

    CEditParts *parts = map->GetePlaceParts(name);

    if (parts == NULL) {
        return 0;
    }

    parts->GetPosition(pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack++, pos[2]);
    parts->GetRotation(rot);
    SetStack(stack, rot[1]);
    return 1;
}

int _GET_CONTENTS_POS(RS_STACKDATA *stack, int argc) {
    return 1;
}

int _GET_BPOT_POS(RS_STACKDATA *stack, int argc) {
    float position[4];
    sceVu0CopyVector(position, BTsubo.position);
    SetStack(stack++, position[0]);
    SetStack(stack++, position[1]);
    SetStack(stack, position[2]);
    return 1;
}

int _GET_BPOT_STATUS(RS_STACKDATA *stack, int argc) {
    SetStack(stack, BTsubo.state);
    return 1;
}

int _GET_PERSON_STATUS(RS_STACKDATA *stack, int argc) {
    return 0;
}

int _GET_CONTROL_CHRID(RS_STACKDATA *stack, int argc) {
    SetStack(stack, EventScene->player_chara);
    return 1;
}

static int _SET_CAMERA_NEXT_REF(RS_STACKDATA *stack, int argc) {
    float            ref[4];
    mgCCameraFollow *camera;

    if ((camera = (mgCCameraFollow *) GetActiveCamera()) == NULL) {
        return 0;
    }

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            GetArgVector(ref, args);
            break;
        }
        case 3:
            GetStackVector(ref, stack);
            break;
        default:
            return 0;
    }

    camera->SetNextRef(ref);
    return 1;
}

int _GOTO_MENU(RS_STACKDATA *stack, int argc) {
    MenuArg.open_type = GetStackInt(stack++);

    for (int arg_no = 0; arg_no < argc - 1; arg_no++) {
        MenuArg.param[arg_no] = GetStackInt(stack++);
    }

    EdEventInfo.command_mode = request_menu;
    return 1;
}

int _GET_MENU_STATUS(RS_STACKDATA *stack, int argc) {
    return 0;
}

int _LOAD_EQUIP(RS_STACKDATA *stack, int argc) {
    char  label[0x20];
    char  bone_name[0x2C];
    char *name;
    int   stack_no;
    int   member_kind;
    int   equip_kind;
    int   chara_no;
    int   attach_no;

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack), argc);

            if (args == NULL) {
                return 0;
            }

            stack_no = GetArgInt(args++);
            member_kind = GetArgInt(args++);
            equip_kind = GetArgInt(args++);
            name = GetArgString(args++);
            chara_no = GetArgInt(args++);

            if (argc >= 6) {
                attach_no = GetArgInt(args);
            }

            break;
        }
        case 5:
        case 6:
            stack_no = GetStackInt(stack++);
            member_kind = GetStackInt(stack++);
            equip_kind = GetStackInt(stack++);
            name = GetStackString(stack++);
            chara_no = GetStackInt(stack++);

            if (argc >= 6) {
                attach_no = GetStackInt(stack);
            }

            break;
        default:
            return 0;
    }

    if (member_kind < 0 || member_kind > 1) {
        return 0;
    }

    if (equip_kind < 0 || equip_kind > 4) {
        return 0;
    }

    CUserDataManager *user_data = NULL;
    CSaveData        *save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    user_data = &save->user_data;

    if (user_data == NULL) {
        return 0;
    }

    char        *path;
    CCharacter2 *chara;
    int          tex_block;
    u32         *pack;

    if ((path = user_data->GetCharaEquipDataPath(member_kind, equip_kind)) == NULL) {
        return 0;
    }

    if ((chara = GetCharacter(chara_no)) == NULL) {
        return 0;
    }

    if (0 > (tex_block = EventScene->GetCharaTexb(chara_no))) {
        return 0;
    }

    if ((pack = GetLoadBGBuff(path, 0)) == NULL) {
        return 0;
    }

    if (equip_kind >= 3 || equip_kind >= 4) {
        mgCMemory *memory;

        if ((memory = EventScene->GetStack(stack_no)) == NULL) {
            return 0;
        }

        sprintf(label, "ev%d", chara_no);
        mgCTextureManager *manager = &mgTexManager;

        if (chara_no >= 8) {
            strcpy(manager->name_suffix, label);
        }

        chara->LoadSkin(pack, name, "", memory, tex_block);

        if (chara_no >= 8) {
            manager->name_suffix[0] = 0;
        }
    } else {
        if (_LOAD_CHARA_sub(stack_no, &name, attach_no, pack) <= 0) {
            return 0;
        }

        if (member_kind == 0) {
            switch (equip_kind) {
                case 0:
                    strcpy(bone_name, "ef00");
                    break;
                case 1:
                    strcpy(bone_name, "gun_hand");
                    break;
                case 2:
                    strcpy(bone_name, "hat");
                    break;
            }
        } else if (member_kind == 1) {
            switch (equip_kind) {
                case 0:
                    strcpy(bone_name, "sword_hand");
                    break;
                case 1:
                    strcpy(bone_name, "wr");
                    break;
                case 2:
                    strcpy(bone_name, "ac");
                    break;
            }
        }

        CCharacter2 *attached;

        if ((attached = GetCharacter(attach_no)) == NULL) {
            return 0;
        }

        if (chara->CObjectFrame::frame == NULL) {
            return 0;
        }

        mgCFrame *bone;

        if ((bone = chara->CObjectFrame::frame->SearchFrame(bone_name)) == NULL) {
            return 0;
        }

        if (attached->CObjectFrame::frame == NULL) {
            return 0;
        }

        attached->CObjectFrame::frame->SetReference(bone);
    }

    return 1;
}

int _GET_EQUIP_ITEMNO(RS_STACKDATA *stack, int argc) {
    int chara_no = GetStackInt(stack++);
    int slot = GetStackInt(stack++);

    if (chara_no < 0 || chara_no > 1) {
        return 0;
    }

    CUserDataManager *user_data;

    if (slot < 0 || (user_data = NULL, slot > 4)) {
        return 0;
    }

    CSaveData *save = GetSaveData();

    if (save != NULL) {
        user_data = &save->user_data;
    }

    if (user_data == NULL) {
        return 0;
    }

    CHARA_DATA *chara = user_data->GetCharaDataPtr(chara_no);

    if (chara == NULL) {
        return 0;
    }

    SetStack(stack, chara->equip[slot].item_no);
    return 1;
}

int _SET_TIME_STEP_ENABLE(RS_STACKDATA *stack, int argc) {
    EventScene->time_step = GetStackInt(stack);
    return 1;
}

int _SET_DOOR_MATERIAL(RS_STACKDATA *stack, int argc) {
    return 1;
}

int _INIT_DRAMA_SCENE(RS_STACKDATA *stack, int argc) {
    InitDramaScene();
    return 1;
}

int _SET_ACTIVE_CMRID(RS_STACKDATA *stack, int argc) {
    EventScene->active_camera = GetStackInt(stack);
    return 1;
}

int _SET_BEFORE_CMRID(RS_STACKDATA *stack, int argc) {
    EventScene->before_camera = GetStackInt(stack);
    return 1;
}

int _DNGMAP_LOAD(RS_STACKDATA *stack, int argc) {
    int           tex_base;
    RS_STACKDATA *arg = stack + 1;
    mgCMemory    *memory = EventScene->GetStack(GetStackInt(stack));
    int           file_index = GetStackInt(arg++);
    int           tex_count = EventScene->event_texb_num;
    tex_base = EventScene->event_texb;

    if (tex_count <= 0 || tex_count < file_index) {
        return 0;
    }

    int param1 = GetStackInt(arg++);
    int param2 = GetStackInt(arg++);
    int param3 = GetStackInt(arg);
    memory->Align64();

    if (memory->stAlloc64(EventDngMap.LoadDngInfo(
            memory, tex_base + file_index, param1, param2, param3)) == 0) {
        return 0;
    }

    EventDngMap.active = 0;
    return 1;
}

int _DNGMAP_DELETE(RS_STACKDATA *stack, int argc) {
    EventDngMap.DeleteTexBlock();
    return 1;
}

int _DNGMAP_MOVE_PIECE(RS_STACKDATA *stack, int argc) {
    EventDngMap.SetKomaMove(GetStackInt(stack));
    return 1;
}

int _DNGMAP_ONOFF(RS_STACKDATA *stack, int argc) {
    EventDngMap.active = (u8) (GetStackInt(stack) != 0);
    return 1;
}

int _DNGMAP_SET_FADE(RS_STACKDATA *stack, int argc) {
    int fade_in = GetStackInt(stack++);
    int duration = GetStackInt(stack);
    EventDngMap.active = 1;

    if (fade_in != 0) {
        EventDngMap.FadeIn(duration);
    } else {
        EventDngMap.FadeOut(duration);
    }

    return 1;
}

int _GET_BEFORE_CAMERA_NEXT_POS(RS_STACKDATA *stack, int argc) {
    float      position[4];
    mgCCamera *camera = EventScene->GetCamera(EventScene->before_camera);

    if (camera == NULL) {
        return 0;
    }

    camera->GetNextPos(position);
    SetStack(stack++, position[0]);
    SetStack(stack++, position[1]);
    SetStack(stack, position[2]);
    return 1;
}

int _GET_BEFORE_CAMERA_NEXT_REF(RS_STACKDATA *stack, int argc) {
    float      position[4];
    mgCCamera *camera = EventScene->GetCamera(EventScene->before_camera);

    if (camera == NULL) {
        return 0;
    }

    camera->GetNextRef(position);
    SetStack(stack++, position[0]);
    SetStack(stack++, position[1]);
    SetStack(stack, position[2]);
    return 1;
}

static int _SET_CAMERA_NEXT_POS(RS_STACKDATA *stack, int argc) {
    float            position[4];
    mgCCameraFollow *camera;

    if ((camera = (mgCCameraFollow *) GetActiveCamera()) == NULL) {
        return 0;
    }

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            GetArgVector(position, args);
            break;
        }
        case 3:
            GetStackVector(position, stack);
            break;
        default:
            return 0;
    }

    camera->SetNextPos(position);
    return 1;
}

int _CHK_INTERSECTION_POINT(RS_STACKDATA *stack, int argc) {
    float                from[4];
    float                to[4];
    float                hit_pos[4];
    float                reflection[4];
    float                center[4];
    mgVu0FBOX            box;
    CCPoly               polys[256];
    float                point[4];
    float                step[4];
    float                normal[4];
    float                angle;
    CCPoly              *poly;
    int                  poly_count;
    int                  check_box;
    int                  step_num;
    int                  hit;
    int                  i;
    CTreasureBoxManager *treasure_box;
    int                  kind;
    int                  ignore_mask;
    ignore_mask = GetStackInt(stack++);
    GetStackVector(from, stack);
    GetStackVector(to, stack + 3);
    stack += 6;
    check_box = GetStackInt(stack++);
    sceVu0SubVector(center, to, from);
    sceVu0DivVector(center, center, 2.0f);
    sceVu0AddVector(center, center, from);
    float radius = 0.6f * mgDistVector(from, to);
    box.max[0] = radius + center[0];
    box.min[0] = center[0] - radius;
    box.max[1] = radius + center[1];
    box.min[1] = center[1] - radius;
    box.max[2] = radius + center[2];
    box.min[2] = center[2] - radius;
    box.max[3] = 1.0f;
    box.min[3] = 1.0f;
    poly_count = EventScene->GetColPoly(polys, box, 0x100);

    if (poly_count < 0x100 && check_box == 1) {
        DNG_BATTLE_AREA *area = &EventScene->battle_area;

        if (area == NULL) {
            return 0;
        }

        treasure_box = area->treasure_box;

        if (treasure_box == NULL) {
            return 0;
        }

        sceVu0SubVector(step, to, from);
        step_num = fptosi(mgDistVector(step) / 40.0f) + 1;
        *(u_long128 *) point = *(u_long128 *) from;
        sceVu0Normalize(step, step);
        sceVu0ScaleVector(step, step, 40.0f);

        for (i = 0; i < step_num; i++) {
            poly_count += treasure_box->PickupCollision(point, &polys[poly_count], box, 0x100 - poly_count);
            sceVu0AddVector(point, point, step);
        }
    }

    if (poly_count > 0x100) {
        printf("\n\n\n\n\n!!!!!  EVENT COL CHECK ERR <poly num over %d> !!!!!\n\n\n\n\n", poly_count);
    }

    poly = polys;
    hit = CheckHit(poly, poly_count, from, to, hit_pos, 1, ignore_mask);

    if (hit >= 0) {
        poly += hit;
        sceVu0Normalize(normal, poly->normal);
        angle = mgReflectionPlane(normal, hit_pos, from, reflection);
        sceVu0Normalize(reflection, reflection);
        kind = poly->area_kind;
    }

    switch (argc) {
        case 9:
        case 10:
        case 11:
            SetStack(stack++, hit);

            if (argc == 10) {
                SetStack(stack++, kind);
            }

            if (argc == 11) {
                SetStack(stack, angle);
            }

            break;
        case 12:
        case 13:
            SetStack(stack++, hit_pos[0]);
            SetStack(stack++, hit_pos[1]);
            SetStack(stack++, hit_pos[2]);
            SetStack(stack++, hit);

            if (argc == 13) {
                SetStack(stack, kind);
            }

            break;
        case 15:
        case 16:
            SetStack(stack++, hit_pos[0]);
            SetStack(stack++, hit_pos[1]);
            SetStack(stack++, hit_pos[2]);
            SetStack(stack++, reflection[0]);
            SetStack(stack++, reflection[1]);
            SetStack(stack++, reflection[2]);
            SetStack(stack++, hit);

            if (argc == 16) {
                SetStack(stack, kind);
            }

            break;
        default:
            return 0;
    }

    return 1;
}

int _CHK_INTERSECTION_POINT_PIPE(RS_STACKDATA *stack, int argc) {
    float                from[4];
    float                to[4];
    float                reflection[4];
    float                center[4];
    mgVu0FBOX            box;
    CCPoly               polys[256];
    float                point[4];
    float                step[4];
    int                  hit_polys[16];
    float                hit_points[16][4];
    float                normal[4];
    float                angle;
    float                radius;
    CCPoly              *poly;
    int                  poly_count;
    int                  check_box;
    int                  step_num;
    int                  hit;
    int                  i;
    CTreasureBoxManager *treasure_box;
    int                  kind;
    int                  ignore_mask;
    ignore_mask = GetStackInt(stack++);
    GetStackVector(from, stack);
    GetStackVector(to, stack + 3);
    stack += 6;
    radius = GetStackFloat(stack++);
    check_box = GetStackInt(stack++);
    sceVu0SubVector(center, to, from);
    sceVu0DivVector(center, center, 2.0f);
    sceVu0AddVector(center, center, from);
    float r = 0.6f * mgDistVector(from, to);
    box.max[0] = r + center[0];
    box.min[0] = center[0] - r;
    box.max[1] = r + center[1];
    box.min[1] = center[1] - r;
    box.max[2] = r + center[2];
    box.min[2] = center[2] - r;
    box.max[3] = 1.0f;
    box.min[3] = 1.0f;
    poly_count = EventScene->GetColPoly(polys, box, 0x100);

    if (poly_count < 0x100 && check_box == 1) {
        DNG_BATTLE_AREA *area = &EventScene->battle_area;

        if (area == NULL) {
            return 0;
        }

        treasure_box = area->treasure_box;

        if (treasure_box == NULL) {
            return 0;
        }

        sceVu0SubVector(step, to, from);
        step_num = fptosi(mgDistVector(step) / 40.0f) + 1;
        *(u_long128 *) point = *(u_long128 *) from;
        sceVu0Normalize(step, step);
        sceVu0ScaleVector(step, step, 40.0f);

        for (i = 0; i < step_num; i++) {
            poly_count += treasure_box->PickupCollision(point, &polys[poly_count], box, 0x100 - poly_count);
            sceVu0AddVector(point, point, step);
        }
    }

    if (poly_count > 0x100) {
        printf("\n\n\n\n\n!!!!!  EVENT COL CHECK ERR <poly num over %d> !!!!!\n\n\n\n\n", poly_count);
    }

    poly = polys;
    poly = polys;
    from[3] = radius;
    hit = CheckHitsPipe(poly, poly_count, from, to, 16, hit_polys, hit_points, 1, ignore_mask);
    from[3] = 1.0f;

    if (hit > 0) {
        poly += hit_polys[0];
        sceVu0Normalize(normal, poly->normal);
        angle = mgReflectionPlane(normal, hit_points[0], from, reflection);
        sceVu0Normalize(reflection, reflection);
        kind = poly->area_kind;
    }

    switch (argc) {
        case 10:
        case 11:
        case 12:
            SetStack(stack++, hit);

            if (argc == 11) {
                SetStack(stack++, kind);
            }

            if (argc == 12) {
                SetStack(stack, angle);
            }

            break;
        case 13:
        case 14:
            SetStack(stack++, hit_points[0][0]);
            SetStack(stack++, hit_points[0][1]);
            SetStack(stack++, hit_points[0][2]);
            SetStack(stack++, hit);

            if (argc == 14) {
                SetStack(stack, kind);
            }

            break;
        case 16:
        case 17:
            SetStack(stack++, hit_points[0][0]);
            SetStack(stack++, hit_points[0][1]);
            SetStack(stack++, hit_points[0][2]);
            SetStack(stack++, reflection[0]);
            SetStack(stack++, reflection[1]);
            SetStack(stack++, reflection[2]);
            SetStack(stack++, hit);

            if (argc == 17) {
                SetStack(stack, kind);
            }

            break;
        default:
            return 0;
    }

    return 1;
}

int _SET_FCAMERA_FOLLOW(RS_STACKDATA *stack, int arg_count) {
    float            position[4];
    mgCCameraFollow *camera = (mgCCameraFollow *) EventScene->GetCamera(EventScene->active_camera);

    if (camera == NULL) {
        return 0;
    }

    GetStackVector(position, stack);
    camera->SetFollow(position[0], position[1], position[2]);
    return 1;
}

int _SET_FCAMERA_FOLLOW_A(RS_STACKDATA *stack, int arg_count) {
    float            position[4];
    mgCCameraFollow *camera = (mgCCameraFollow *) EventScene->GetCamera(EventScene->active_camera);

    if (camera == NULL) {
        return 0;
    }

    GetStackVector(position, stack);
    camera->SetFollow(position[0], position[1], position[2]);
    return 1;
}

int _SET_FCAMERA_FOLLOW_OFS(RS_STACKDATA *stack, int arg_count) {
    float            offset[4];
    mgCCameraFollow *camera = (mgCCameraFollow *) EventScene->GetCamera(EventScene->active_camera);

    if (camera == NULL) {
        return 0;
    }

    GetStackVector(offset, stack);
    camera->SetFollowOffset(offset[0], offset[1], offset[2]);
    return 1;
}

int _SET_FCAMERA_FOLLOW_FLAG(RS_STACKDATA *stack, int argc) {
    mgCCameraFollow *camera = (mgCCameraFollow *) EventScene->GetCamera(EventScene->active_camera);

    if (camera == NULL) {
        return 0;
    }

    if (GetStackInt(stack) == 1) {
        camera->FollowOn();
    } else {
        camera->FollowOff();
    }

    return 1;
}

int _FCAMERA_STEP(RS_STACKDATA *stack, int argc) {
    mgCCameraFollow *camera = (mgCCameraFollow *) EventScene->GetCamera(EventScene->active_camera);

    if (camera == NULL) {
        return 0;
    }

    camera->Step(GetStackInt(stack));
    return 1;
}

int _SET_FCAMERA_ANGLE(RS_STACKDATA *stack, int arg_count) {
    mgCCameraFollow *camera = (mgCCameraFollow *) EventScene->GetCamera(EventScene->active_camera);

    if (camera == NULL) {
        return 0;
    }

    camera->SetAngle(GetStackFloat(stack));
    return 1;
}

int _SET_FCAMERA_HEIGHT(RS_STACKDATA *stack, int arg_count) {
    mgCCameraFollow *camera = (mgCCameraFollow *) EventScene->GetCamera(EventScene->active_camera);

    if (camera == NULL) {
        return 0;
    }

    camera->SetHeight(GetStackFloat(stack));
    return 1;
}

int _SET_FCAMERA_DIST(RS_STACKDATA *stack, int arg_count) {
    mgCCameraFollow *camera = (mgCCameraFollow *) EventScene->GetCamera(EventScene->active_camera);

    if (camera == NULL) {
        return 0;
    }

    camera->SetDistance(GetStackFloat(stack));
    return 1;
}

static int _GET_REF_ANGLE(RS_STACKDATA *stack, int argc) {
    float  from[4];
    float  direction[4];
    float  yaw;
    float  pitch;
    float *direction_z;
    GetStackVector(from, stack);
    GetStackVector(direction, stack + 3);
    stack += 6;
    sceVu0SubVector(direction, direction, from);
    sceVu0Normalize(direction, direction);
    direction_z = &direction[2];
    yaw = atan2f(direction[0], *direction_z);
    pitch = -atan2f(direction[1], sqrtf(direction[0] * direction[0] + *direction_z * *direction_z));

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

int _DNG_SET_STAGE_ID(RS_STACKDATA *stack, int argc) {
    CSaveData *save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    CSaveDataDungeon *dungeon = &save->save_dungeon;

    if (dungeon == NULL) {
        return 0;
    }

    dungeon->stage_id = GetStackInt(stack);
    return 1;
}

int _DNG_GET_STAGE_ID(RS_STACKDATA *stack, int argc) {
    CSaveData *save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    CSaveDataDungeon *dungeon = &save->save_dungeon;

    if (dungeon == NULL) {
        return 0;
    }

    SetStack(stack, dungeon->stage_id);
    return 1;
}

int _SET_CAMERA_CTRL(RS_STACKDATA *stack, int argc) {
    CCameraControl *camera = (CCameraControl *) EventScene->GetCamera(EventScene->active_camera);

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

int _GET_FCAMERA_ANGLE(RS_STACKDATA *stack, int argc) {
    mgCCameraFollow *camera = (mgCCameraFollow *) EventScene->GetCamera(EventScene->active_camera);

    if (camera == NULL) {
        return 0;
    }

    SetStack(stack, camera->GetAngle());
    return 1;
}

int _GET_FCAMERA_HEIGHT(RS_STACKDATA *stack, int argc) {
    mgCCameraFollow *camera = (mgCCameraFollow *) EventScene->GetCamera(EventScene->active_camera);

    if (camera == NULL) {
        return 0;
    }

    SetStack(stack, camera->GetHeight());
    return 1;
}

int _GET_FCAMERA_DIST(RS_STACKDATA *stack, int argc) {
    mgCCameraFollow *camera = (mgCCameraFollow *) EventScene->GetCamera(EventScene->active_camera);

    if (camera == NULL) {
        return 0;
    }

    SetStack(stack, camera->GetDistance());
    return 1;
}

int _GET_INVENTION_ID(RS_STACKDATA *stack, int argc) {
    CSaveData *save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    CUserDataManager *user_data = &save->user_data;
    CInventUserData  *invent_data = &user_data->invent_data;

    if (user_data == NULL) {
        return 0;
    }

    if (invent_data == NULL) {
        return 0;
    }

    int invention_id = GetStackInt(stack++);

    argc = invent_data->IsAlreadyCreatedItem(invention_id);
    SetStack(stack, argc);
    return 1;
}

int _FUNCTION_MAP_JUMP(RS_STACKDATA *stack, int argc) {

    u32 *request = &EventScene->map_jump_flags;

    if (!(*request & 0x10A)) {
        return 0;
    }

    EdEventInfo.jump_point = -1;
    EdEventInfo.event_no = 100;

    if (strcmp((char *) (request + 6), "exit") == 0) {
        EdEventInfo.request = exit_leave_interior;
    } else {
        strcpy(EdEventInfo.jump_map_name, (char *) (request + 6));
        EdEventInfo.request = exit_enter_interior;
    }

    return 1;
}

int _FUNCTION_DOOR_MODE(RS_STACKDATA *stack, int argc) {
    EdEventInfo.func_iparam[0] = 0;
    EdEventInfo.func_iparam[1] = EventScene->door_place_no[0];
    EdEventInfo.func_iparam[2] = EventScene->door_place_no[1];
    EdEventInfo.func_fparam[0] = EventScene->door_vec[0];
    EdEventInfo.func_fparam[1] = EventScene->door_vec[1];
    EdEventInfo.func_fparam[2] = EventScene->door_vec[2];
    EdEventInfo.func_fparam[3] = atan2f(EventScene->door_dir_x, EventScene->door_dir_z);
    EdEventInfo.command_mode = request_door;
    return 1;
}

int _GET_MONEY(RS_STACKDATA *stack, int argc) {
    CSaveData *save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    CUserDataManager *user_data = &save->user_data;

    if (user_data == NULL) {
        return 0;
    }

    SetStack(stack, user_data->money);
    return 1;
}

int _ADD_MONEY(RS_STACKDATA *stack, int argc) {
    CSaveData *save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    CUserDataManager *user_data = &save->user_data;

    if (user_data == NULL) {
        return 0;
    }

    user_data->AddMoney(GetStackInt(stack));
    return 1;
}

int _GET_ITEM_NUM(RS_STACKDATA *stack, int argc) {
    CSaveData *save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    CUserDataManager *user_data = &save->user_data;

    if (user_data == NULL) {
        return 0;
    }

    int item_no = GetStackInt(stack++);

    argc = user_data->GetNumSameItem(item_no);
    SetStack(stack, argc);
    return 1;
}

int _CHECK_BUTTON(RS_STACKDATA *stack, int argc) {
    int button = GetStackInt(stack++);
    int pressed = 0;
    int pad_down = GamePad__2.GetPadDown();

    switch (button) {
        case 0:
            if (LanguageCode == 0) {
                if (pad_down & 0x40) {
                    pressed = 1;
                }
            } else if (pad_down & 0x20) {
                pressed = 1;
            }

            break;
        case 1:
            if (LanguageCode == 0) {
                if (pad_down & 0x20) {
                    pressed = 1;
                }
            } else if (pad_down & 0x40) {
                pressed = 1;
            }

            break;
        case 2:
            if (pad_down & 0x80) {
                pressed = 1;
            }

            break;
        case 3:
            if (pad_down & 0x100) {
                pressed = 1;
            }

            break;
        default:
            return 0;
    }

    SetStack(stack, pressed);
    return 1;
}

int _GET_LANGUAGE(RS_STACKDATA *stack, int argc) {
    SetStack(stack, LanguageCode);
    return 1;
}

static int _CHECK_INVENT_ITEM(RS_STACKDATA *stack, int argc) {
    int item = GetStackInt(stack++);
    SetStack(stack, CheckInventItem(item));
    return 1;
}

int _SET_AI(RS_STACKDATA *stack, int argc) {
    int enabled = GetStackInt(stack++);
    int chara_no = GetStackInt(stack);

    if (enabled != 0) {
        EventScene->CancelStayVillager(chara_no);
    } else {
        EventScene->StayVillager(chara_no);
    }

    return 1;
}

int _CHECK_INVENT_PHOTO(RS_STACKDATA *stack, int argc) {
    switch (argc) {
        case 2: {
            int id = GetStackInt(stack++);
            int photo = CheckInventPhoto(id, 0);
            SetStack(stack, photo);
            break;
        }
        case 3: {
            int id = GetStackInt(stack++);
            int check = GetStackInt(stack++);
            int photo = CheckInventPhoto(id, check);
            SetStack(stack, photo);
            break;
        }
        default:
            return 0;
    }

    return 1;
}

int _GET_PHOTO_NUM(RS_STACKDATA *stack, int argc) {
    CSaveData *save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    CUserDataManager *user_data = &save->user_data;
    CInventUserData  *invent_data = &user_data->invent_data;

    if (user_data == NULL) {
        return 0;
    }

    if (invent_data == NULL) {
        return 0;
    }

    SetStack(stack, invent_data->GetNowHavePictureNum());
    return 1;
}

int _SET_CONTENTS_ETC(RS_STACKDATA *stack, int argc) {
    return 1;
}

static int _SET_STATUS(RS_STACKDATA *stack, int argc) {
    int type = GetStackInt(stack++);
    int no = GetStackInt(stack++);
    int status = GetStackInt(stack++);
    int on = 1;

    if (argc >= 4) {
        on = GetStackInt(stack);
    }

    if (on != 0) {
        EventScene->SetStatus(type, no, status);
    } else {
        EventScene->ResetStatus(type, no, status);
    }

    return 1;
}

int _GOTO_SUBGAME(RS_STACKDATA *stack, int argc) {
    int         type = GetStackInt(stack);
    SubGameInfo info;
    info.scene = EventScene;
    info.texb = EventScene->tex_block_base;
    info.texb_num = EventScene->tex_block_count;
    return sgInitSubGame(type, &info) != 0;
}
int _SET_GYORACE_ETC(RS_STACKDATA *stack, int argc) {
    int digit[8];
    char text[0x14];
    ClsMes *mes;
    float time;
    int minutes;
    int seconds;
    int hundredths;
    int resultNo;
    int nameNo;
    int i;
    switch (GetStackInt(stack++)) {
        case 0:
            SetGyoRaceAquariumNo(GetStackInt(stack));
            break;
        case 1:
            SetGyoRaceRanking(GetStackInt(stack));
            break;
        case 2:
            SetGyoRaceClass(GetStackInt(stack));
            break;
        case 3:
            SetGyoRaceNo(GetStackInt(stack));
            break;
        case 4: {
            CSaveData *saveData = GetSaveData();
            if (saveData == NULL) {
                return 0;
            }
            saveData->AddTourCountEtc(1);
            break;
        }
        case 5:
            mes = GetEventMessage(GetStackInt(stack++));
            if (mes == NULL) {
                return 0;
            }
            nameNo = GetStackInt(stack++);
            resultNo = GetStackInt(stack);
            if (&fish_game_data[resultNo] == NULL) {
                return 0;
            }
            if (&fish_game_data[resultNo] != NULL) {
                strcpy(mes->name[nameNo - 1], fish_game_data[resultNo].name);
            }
            break;
        case 6:
            mes = GetEventMessage(GetStackInt(stack++));
            if (mes == NULL) {
                return 0;
            }
            nameNo = GetStackInt(stack++);
            resultNo = GetStackInt(stack);
            time = fish_game_data[resultNo].time;
            if (time < 0.0f) {
                time = 0.0f;
            }
            if (360000.0f <= time) {
                time = 360000.0f;
            }
            minutes = (int)(time / 3600.0f);
            time -= minutes * 3600.0f;
            seconds = (int)(time / 60.0f);
            hundredths = (int)(100.0f * (time - seconds * 60.0f) / 60.0f);
            digit[0] = minutes / 10;
            digit[1] = minutes % 10;
            digit[2] = -1;
            digit[3] = seconds / 10;
            digit[4] = seconds % 10;
            digit[5] = -1;
            digit[6] = hundredths / 10;
            digit[7] = hundredths % 10;
            memset(text, 0, 0x14);
            switch (digit[0]) {
                case 0:
                    sprintf(text, "\x82\x4F");
                    break;
                case 1:
                    sprintf(text, "\x82\x50");
                    break;
                case 2:
                    sprintf(text, "\x82\x51");
                    break;
                case 3:
                    sprintf(text, "\x82\x52");
                    break;
                case 4:
                    sprintf(text, "\x82\x53");
                    break;
                case 5:
                    sprintf(text, "\x82\x54");
                    break;
                case 6:
                    sprintf(text, "\x82\x55");
                    break;
                case 7:
                    sprintf(text, "\x82\x56");
                    break;
                case 8:
                    sprintf(text, "\x82\x57");
                    break;
                case 9:
                    sprintf(text, "\x82\x58");
                    break;
                default:
                    sprintf(text, "\x81\x46");
                    break;
            }
            for (i = 1; i < 8; i++) {
                switch (digit[i]) {
                    case 0:
                        strcat(text, "\x82\x4F");
                        break;
                    case 1:
                        strcat(text, "\x82\x50");
                        break;
                    case 2:
                        strcat(text, "\x82\x51");
                        break;
                    case 3:
                        strcat(text, "\x82\x52");
                        break;
                    case 4:
                        strcat(text, "\x82\x53");
                        break;
                    case 5:
                        strcat(text, "\x82\x54");
                        break;
                    case 6:
                        strcat(text, "\x82\x55");
                        break;
                    case 7:
                        strcat(text, "\x82\x56");
                        break;
                    case 8:
                        strcat(text, "\x82\x57");
                        break;
                    case 9:
                        strcat(text, "\x82\x58");
                        break;
                    default:
                        strcat(text, "\x81\x46");
                        break;
                }
            }
            strcpy(mes->name[nameNo - 1], text);
            break;
        case 7:
            InitFishPrize();
            LoadFishPrize(0);
            break;
        default:
            return 0;
    }
    return 1;
}
int _GET_GYORACE_ETC(RS_STACKDATA *stack, int argc) {
    FISH_PRIZE_INFO info;
    int             race_no;

    switch (GetStackInt(stack++)) {
        case 0:
            SetStack(stack++, GetGyoRaceAquariumNo());
            break;
        case 1:
            SetStack(stack++, GetGyoRaceRanking());
            break;
        case 2:
            SetStack(stack++, GetGyoRaceClass());
            break;
        case 3:
            SetStack(stack++, GetGyoRaceNo());
            break;
        case 4:
            race_no = GetStackInt(stack++);

            if (!GetFishPrize(race_no, GetStackInt(stack++) - 1, &info)) {
                return 0;
            }

            SetStack(stack++, info.unk_0);
            SetStack(stack++, info.unk_4);
            break;
        case 5: {
            CSaveData *save = GetSaveData();

            if (save == NULL) {
                return 0;
            }

            SetStack(stack++, save->GetTourCountEtc());
            break;
        }
        default:
            return 0;
    }

    return 1;
}

int _SET_SAVEDATA_ETC(RS_STACKDATA *stack, int argc) {
    CSaveData        *save;
    CUserDataManager *user;
    MOS_CHANGE_PARAM *bajji;

    switch (GetStackInt(stack++)) {
        case 0:
            save = GetSaveData();

            if (save == NULL) {
                return 0;
            }

            save->game_progress = GetStackInt(stack);
            break;
        case 1:
            save = GetSaveData();

            if (save == NULL) {
                return 0;
            }

            user = &save->user_data;

            if (user == NULL) {
                return 0;
            }

            bajji = user->GetMonsterBajjiDataPtrMosId(GetStackInt(stack));

            if (bajji == NULL) {
                return 0;
            }

            bajji->enable = 1;
            break;
        case 2:
            save = GetSaveData();

            if (save == NULL) {
                return 0;
            }

            user = &save->user_data;

            if (user == NULL) {
                return 0;
            }

            user->AllWeaponRepair();
            break;
        case 3:
            save = GetSaveData();

            if (save == NULL) {
                return 0;
            }

            save->skip_load_bgm = GetStackInt(stack);
            break;
        case 4:
            DeleteErekiFish();
            break;
        default:
            return 0;
    }

    return 1;
}

int _GET_SAVEDATA_ETC(RS_STACKDATA *stack, int argc) {
    CSaveData *save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    int command = GetStackInt(stack++);

    switch (command) {
        case 0:
            SetStack(stack, save->game_progress);
            break;
        case 1: {
            CUserDataManager *user_data = &save->user_data;

            if (user_data == NULL) {
                return 0;
            }

            int               monster_id = GetStackInt(stack++);
            MOS_CHANGE_PARAM *badge = user_data->GetMonsterBajjiDataPtrMosId(monster_id);

            if (badge == NULL) {
                return 0;
            }

            SetStack(stack, badge->enable);
            break;
        }
        case 2: {
            CUserDataManager *user_data = &save->user_data;

            if (user_data == NULL) {
                return 0;
            }

            SetStack(stack, user_data->CheckElectricFish());
            break;
        }
        case 3: {
            int               rod_no = GetStackInt(stack++);
            CUserDataManager *user_data = &save->user_data;

            if (user_data == NULL) {
                return 0;
            }

            CGameDataUsed *bait = user_data->GetActiveEsa(rod_no);

            if (bait == NULL) {
                return 0;
            }

            SetStack(stack, bait->item_no);
            break;
        }
        case 4:
            PlayTimeCount(1);
            SetStack(stack, (int) save->play_time);
            break;
        case 5:
            SetStack(stack, GetConfigCaptionOff());
            break;
        case 6:
            SetStack(stack, save->CheckNowTourType());
            break;
        default:
            return 0;
    }

    return 1;
}

int _DEL_MONSTER(RS_STACKDATA *stack, int argc) {
    mgCMemory         *monster_stack;
    int                j;
    int                i;
    CMonsterMan       *monster_man;
    DNG_BATTLE_AREA   *area;
    mgCTextureManager *manager;
    area = &EventScene->battle_area;

    if (area == NULL) {
        return 0;
    }

    RocketLauncher.Clear();

    for (i = 0; i < 16; i++) {
        MachineGun.active[i] = 0;
        MachineGun.col_prim_id[i] = -1;
    }

    MachineGun.index = 0;
    LaserGun.Clear();

    if (ActiveMonster == NULL) {
        return 0;
    }

    ActiveMonster->Initialize(EventScene);
    EventScene->ClearStack(3);
    EventScene->AssignStack(3);
    monster_stack = EventScene->GetStack(3);
    monster_man = ActiveMonster;

    for (j = 0; j < MONSTER_ACTIVE_MAX; j++) {
        u_long128 *buffer = monster_stack->stAlloc64(0xFA0);
        mgCMemory *memory = &monster_man->memory[j];
        memory->stSetBuffer(buffer, 0xFA0);
        memory->stack_used = 0;
        memory->lock = 0;
    }

    ColPrimMan.Initialize(DngMainScene);
    FxScriptMan->ClearBaseFromLevel(3, NULL, -1);
    manager = &mgTexManager;

    for (j = area->free_texb; j < 0xAA; j++) {
        manager->DeleteBlock(j);
    }

    sndInitPort(5);
    return 1;
}

int _SET_MENU_ETC(RS_STACKDATA *stack, int argc) {
    int command = GetStackInt(stack++);

    if (command == 0) {
        char *topic = GetStackString(stack++);
        char *keyword = GetStackString(stack++);
        SetEventKeyword(keyword, topic, GetStackInt(stack));
        return 1;
    }

    if (command == 1) {
        AquaFishFatigueClear();
        CSaveData *save_data = GetSaveData();

        if (save_data == NULL) {
            return 0;
        }

        save_data->FinishTour();
        return 1;
    }

    if (command == 2) {
        return 1;
    }

    if (command == 3) {
        DrawDownLoadAnaunceSwitch(GetStackInt(stack));
        return 1;
    }

    if (command == 4) {
        InitMenuDl(NULL, 0);
        return 1;
    }

    if (command == 5) {
        int        stack_no = GetStackInt(stack++);
        int        town_no = GetStackInt(stack);
        mgCMemory *memory = EventScene->GetStack(stack_no);

        if (memory == NULL) {
            return 0;
        }

        InitDownLoadAnaunce(memory);
        MakeDownLoadAnaunce(town_no, memory, NULL, NULL, NULL);
        InitMenuDl3(mgTexManager.GetTexture("eventdl", -1));
        return 1;
    }

    if (command == 6) {
        return 1;
    }

    if (command == 7) {
        InitDownLoadAnaunce(NULL);
        return 1;
    }

    return 0;
}

int _GET_MENU_ETC(RS_STACKDATA *stack, int argc) {
    float size;
    float weight;
    int   total;
    int   result;
    int   status;
    int   command = GetStackInt(stack++);

    if (command == 0) {
        SetStack(stack, GetCountSphedaClear());
        return 1;
    }

    if (command == 1) {
        SetStack(stack, GetSquareEvent());
        return 1;
    }

    if (command == 2) {
        CSaveData *save_data = GetSaveData();

        if (save_data == NULL) {
            return 0;
        }

        CUserDataManager *user_data = &save_data->user_data;

        if (user_data == NULL) {
            return 0;
        }

        user_data->GetFishRecord(GetStackInt(stack++), &size, &weight);
        SetStack(stack, size);
        return 1;
    }

    if (command == 3 || command == 4 || command == 5) {
        CSaveData *save_data = GetSaveData();

        if (save_data == NULL) {
            return 0;
        }

        CUserDataManager *user_data = &save_data->user_data;

        if (user_data == NULL) {
            return 0;
        }

        CInventUserData   *invent_data = &user_data->invent_data;
        CScoopDataManager *scoop = &invent_data->scoop;

        if (invent_data == NULL) {
            return 0;
        }

        if (scoop == NULL) {
            return 0;
        }

        if (command == 3) {
            result = scoop->KnowScoop();
            SetStack(stack, result);
            return 1;
        }

        if (command == 4) {
            result = scoop->CheckScoop();
            SetStack(stack, result);
            return 1;
        }

        if (command == 5) {
            result = scoop->GetScoopTotal(&total);
            SetStack(stack++, result);
            SetStack(stack, total);
            return 1;
        }
    }

    if (command == 6) {
        SetStack(stack++, GetDonyShopLineUp(NULL, &status));
        SetStack(stack, status);
        return 1;
    }

    if (command == 7) {
        result = StepDownLoadAnaunce(GetStackInt(stack++));
        SetStack(stack, result);
        return 1;
    }

    if (command == 8) {
        SetStack(stack, StepMenuDl3());
        return 1;
    }

    return 0;
}

int _GET_ANALYZE(RS_STACKDATA *stack, int argc) {
    int        analyze_id = GetStackInt(stack++);
    int        map_no = analyze_id / 100 - 1;
    int        condition_no = analyze_id % 100;
    CSaveData *save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    CEditData *edit_data = save->GetEditData(map_no);

    if (edit_data == NULL) {
        return 0;
    }

    SetStack(stack, edit_data->GetAnalyzeFlag(map_no, condition_no));
    return 1;
}

int _GET_DIORAMA_PERCENT(RS_STACKDATA *stack, int argc) {
    int        map_no = GetStackInt(stack++);
    CSaveData *save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    CEditData *edit_data = save->GetEditData(map_no);

    if (edit_data == NULL) {
        return 0;
    }

    SetStack(stack, edit_data->GetAnalyzePercent(map_no));
    return 1;
}

/**
 * Runs a georama script command and returns its status.
 */
int _GEORAMA_FUNC(RS_STACKDATA *stack, int argc) {
    GeoFuncParam param;

    param.scene = EventScene;
    return GeoramaFunc(&param, stack, argc);
}

int _GET_CHARA_ID(RS_STACKDATA *stack, int arg_count) {
    int id = GetStackInt(stack++);
    int chara_id = EventScene->SearchCharaID(id);
    SetStack(stack, chara_id);
    return 1;
}

int _GOTO_EDITMODE(RS_STACKDATA *stack, int argc) {
    EdEventInfo.request = exit_edit_mode;
    return 1;
}

int _GET_CHAPTER(RS_STACKDATA *stack, int argc) {
    CSaveData *save;

    save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    SetStack(stack, GetNowChapter(save));
    return 1;
}

int _GET_NPC_TRAIN_ETC(RS_STACKDATA *stack, int argc) {
    NpcTrainTable table = {{
        {1, 1, 39},
        {1, 0, 45},
        {1, 2, 45},
        {1, 3, 45},
        {3, 5, 45},
        {1, 5, 45},
        {1, 6, 45},
        {1, 7, 45},
        {1, 8, 45},
        {2, 0, 45},
        {2, 1, 45},
        {2, 2, 45},
        {2, 3, 45},
        {2, 4, 45},
        {2, 5, 39},
        {2, 6, 45},
        {2, 7, 45},
        {3, 0, 45},
        {3, 1, 45},
        {3, 2, 45},
        {3, 3, 45},
        {3, 4, 45},
        {1, 4, 45},
        {3, 6, 45},
        {3, 7, 45},
    }};
    int           column = GetStackInt(stack++);
    int           row = GetStackInt(stack++) - 1;
    SetStack(stack, table.value[row][column]);
    return 1;
}

int _REGISTER_VILLAGER(RS_STACKDATA *stack, int argc) {
    int no = GetStackInt(stack++);
    int chara_no = GetStackInt(stack++);

    if (argc == 2) {
        mgCMemory *memory = EventScene->GetStack(4);

        if (memory == NULL) {
            return 0;
        }

        EventScene->RegisterVillager(no, chara_no, memory);
        return 1;
    } else if (argc == 3) {
        EventScene->RegisterVillager(no, chara_no, GetStackInt(stack));
        return 1;
    }

    return 0;
}

int _EYE_VIEW_DRAW_ON_OFF(RS_STACKDATA *stack, int argc) {
    EventScene->EyeViewDrawOnOff(GetStackInt(stack));
    return 1;
}

int _SET_QUEST_ETC(RS_STACKDATA *stack, int argc) {
    int command = GetStackInt(stack++);
    int quest_no = GetStackInt(stack++);
    int flag = GetStackInt(stack);

    switch (command) {
        case 0:
            QuestRequestSetFlag(quest_no, flag);
            break;
        case 1:
            QuestRequestClear(quest_no, flag);
            break;
        default:
            return 0;
    }

    return 1;
}

int _GET_QUEST_ETC(RS_STACKDATA *stack, int argc) {
    int command = GetStackInt(stack++);
    int quest_no = GetStackInt(stack++);

    switch (command) {
        case 0:
            SetStack(stack, GetQuestRequestStatus(quest_no));
            break;
        default:
            return 0;
    }

    return 1;
}

int _GET_OLD_INTERIOR_MAP_NO(RS_STACKDATA *stack, int argc) {
    SetStack(stack, GetOldInteriorMapNo());
    return 1;
}

int _SET_EVENT_DATA(RS_STACKDATA *stack, int argc) {
    CSceneEventData *event_data;
    RS_STACKDATA    *value;

    event_data = &EventScene->event_data;

    if (event_data == NULL) {
        return 0;
    }

    value = stack + 1;

    switch (GetStackInt(stack)) {
        case 0:
            event_data->event.flag = GetStackInt(value);
            break;
        case 1:
            event_data->event.event_no = GetStackInt(value);
            break;
        case 2:
            event_data->event.point_no = GetStackInt(value);
            break;
        case 3:
            event_data->event.arg1 = GetStackInt(value);
            break;
        case 4:
            event_data->event.arg2 = GetStackInt(value);
            break;
        case 5:
            event_data->event.arg3 = GetStackInt(value);
            break;
        case 6:
            event_data->map_event.check_type = GetStackInt(value);
            break;
        case 7:
            event_data->map_event.event_no = GetStackInt(value);
            break;
        case 13:
            event_data->chara_slot = GetStackInt(value);
            break;
        case 14:
            event_data->chara_no = GetStackInt(value);
            break;
        default:
            return 0;
    }

    return 1;
}
int _STOPWATCH(RS_STACKDATA *stack, int argc) {
    CSaveData *saveData = GetSaveData();
    if (saveData == NULL) {
        return 0;
    }
    int mode = GetStackInt(stack++);
    if (mode == 0) {
        PlayTimeCount(1);
        EdEventInfo.stopwatch_start = saveData->play_time;
        if (EdEventInfo.stopwatch_start == 0) {
            EdEventInfo.stopwatch_start = 1;
        }
        return 1;
    }
    if (mode == 1) {
        if (EdEventInfo.stopwatch_start == 0) {
            EdEventInfo.stopwatch_start = 0;
            SetStack(stack, -1);
            return 1;
        } else {
            u64 elapsed = saveData->play_time - EdEventInfo.stopwatch_start;
            EdEventInfo.stopwatch_start = 0;
            SetStack(stack++, (int)(elapsed / 3600));
            SetStack(stack++, (int)(elapsed % 3600 / 60));
            SetStack(stack++, (int)(elapsed % 60 * 100 / 60));
            SetStack(stack++, elapsed < 7261);
            return 1;
        }
    }
    if (mode == 2) {
        EdEventInfo.stopwatch_limit = GetStackInt(stack);
        return 1;
    }
    if (mode == 3) {
        EdEventInfo.stopwatch_x = GetStackInt(stack++);
        EdEventInfo.stopwatch_y = GetStackInt(stack++);
        EdEventInfo.stopwatch_style = GetStackInt(stack);
        return 1;
    }
    return 0;
}
int _SET_FUNC_ETC(RS_STACKDATA *stack, int argc) {
    u32 *flags;

    flags = &EventScene->map_jump_flags;

    if (flags == NULL) {
        return 0;
    }

    if (flags == NULL) {
        return 0;
    }

    switch (GetStackInt(stack)) {
        case 0:
            *flags |= 0x80;
            EdEventInfo.request = 0x13;
            break;
        case 1:
            EdEventInfo.request = 0x12;
            break;
        default:
            return 0;
    }

    return 1;
}

static CCharacter2 *GetChara(int id) {
    return GetCharacter(id);
}

int _GET_CHARA_POS(RS_STACKDATA *stack, int argc) {
    float         pos[4];
    RS_STACKDATA *out;
    CCharacter2  *chara;

    out = stack + 1;
    chara = GetChara(GetStackInt(stack));

    if (chara == NULL) {
        return 0;
    }

    chara->GetPosition(pos);
    SetStack(out++, pos[0]);
    SetStack(out++, pos[1]);
    SetStack(out++, pos[2]);
    return 1;
}

int _GET_CHARA_TALK_POS(RS_STACKDATA *stack, int argc) {
    int           screen_pos[2];
    RS_STACKDATA *out;
    CCharacter2  *chara;

    out = stack + 1;
    chara = GetChara(GetStackInt(stack));

    if (chara == NULL) {
        return 0;
    }

    GetScrPosFromChar(chara, screen_pos);
    SetStack(out++, screen_pos[0]);
    SetStack(out, screen_pos[1]);
    return 1;
}

int _TURN_CHARA(RS_STACKDATA *stack, int argc) {
    CCharacter2 *chara;
    float        target[4];
    float        pos[4];
    float        rot[4];
    float        diff[4];
    float        rate;
    float        angle;
    float       *yaw;

    chara = GetChara(GetStackInt(stack++));

    if (chara == NULL) {
        return 0;
    }

    target[0] = GetStackFloat(stack++);
    target[1] = GetStackFloat(stack++);
    target[2] = GetStackFloat(stack++);
    rate = GetStackFloat(stack);
    chara->GetPosition(pos);
    chara->GetRotation(rot);
    sceVu0SubVector(diff, target, pos);
    angle = atan2f(diff[0], diff[2]);
    yaw = &rot[1];
    *yaw = mgAngleInterpolate(*yaw, angle, rate, 0);
    chara->SetRotation(rot);
    return 1;
}

int _SET_CHARA_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            CCharacter2 *chara;

            if ((chara = GetChara(GetArgInt(args++))) == NULL) {
                return 0;
            }

            GetArgVector(pos, args);
            chara->SetPosition(pos);
            break;
        }
        case 4: {
            CCharacter2 *chara;

            if ((chara = GetChara(GetStackInt(stack++))) == NULL) {
                return 0;
            }

            GetStackVector(pos, stack);
            chara->SetPosition(pos);
            break;
        }
        default:
            return 0;
    }

    return 1;
}

int _SET_CHARA_ROT(RS_STACKDATA *stack, int argc) {
    float        rot[4];
    CCharacter2 *chara;

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            if ((chara = GetChara(GetArgInt(args++))) == NULL) {
                return 0;
            }

            GetArgVector(rot, args);
            break;
        }
        case 4:
            if ((chara = GetChara(GetStackInt(stack++))) == NULL) {
                return 0;
            }

            GetStackVector(rot, stack);
            break;
        default:
            return 0;
    }

    rot[0] = mgAngleLimit(rot[0]);
    rot[1] = mgAngleLimit(rot[1]);
    rot[2] = mgAngleLimit(rot[2]);
    chara->SetRotation(rot);
    return 1;
}

int _GET_CHARA_ROT(RS_STACKDATA *stack, int argc) {
    float         pos[4];
    RS_STACKDATA *out;
    CCharacter2  *chara;

    out = stack + 1;
    chara = GetChara(GetStackInt(stack));

    if (chara == NULL) {
        return 0;
    }

    chara->GetRotation(pos);
    SetStack(out++, pos[0]);
    SetStack(out++, pos[1]);
    SetStack(out++, pos[2]);
    return 1;
}

int _SET_MOTION(RS_STACKDATA *stack, int argc) {
    CCharacter2 *chara;
    char        *name;
    int          flags = 0;
    int          reset = 0;
    float        step = -1.0f;

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack), argc);

            if (args == NULL) {
                return 0;
            }

            if ((chara = GetChara(GetArgInt(args++))) == NULL) {
                return 0;
            }

            name = GetArgString(args++);

            if (argc >= 3) {
                flags = GetArgInt(args++);
            }

            if (argc >= 4) {
                step = GetArgFloat(args);
            }

            break;
        }
        case 2:
        case 3:
        case 4:
        case 5:
            if ((chara = GetChara(GetStackInt(stack++))) == NULL) {
                return 0;
            }

            name = GetStackString(stack++);

            if (argc >= 3) {
                flags = GetStackInt(stack++);
            }

            if (argc >= 4) {
                step = GetStackFloat(stack++);
            }

            if (argc >= 5) {
                reset = GetStackInt(stack);
            }

            break;
        default:
            return 0;
    }

    if (reset != 0) {
        chara->ResetMotion();
    }

    chara->SetMotion(name, flags);

    if (argc >= 4) {
        if (step != -1.0f && (flags & 4)) {
            chara->NormalDrive();
            chara->SetStep(step);
        }
    }

    return 1;
}

int _SET_STEP(RS_STACKDATA *stack, int argc) {
    CCharacter2 *chara = GetChara(GetStackInt(stack++));

    if (chara == NULL) {
        return 0;
    }

    chara->SetStep(GetStackFloat(stack));
    return 1;
}

int _SET_TEX_ANIM(RS_STACKDATA *stack, int argc) {
    int                chara_id;
    int                enable;
    char              *name;
    int                tex_bank;
    mgCTextureManager *manager;

    chara_id = GetStackInt(stack++);
    enable = GetStackInt(stack++);
    name = NULL;

    if (argc > 2) {
        name = GetStackString(stack);
    }

    tex_bank = EventScene->GetCharaTexb(chara_id);

    if (tex_bank < 0) {
        return 0;
    }

    manager = &mgTexManager;

    if (enable != 0) {
        manager->TexAnimeOn(tex_bank, name);
    } else if (name != NULL) {
        manager->TexAnimeOff(tex_bank, name);
    } else {
        manager->TexAnimeAllOff(tex_bank);
    }

    return 1;
}

static int _SET_SCALE(RS_STACKDATA *stack, int argc) {
    float        scale[4];
    CCharacter2 *chara;

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            if ((chara = GetChara(GetArgInt(args++))) == NULL) {
                return 0;
            }

            GetArgVector(scale, args);
            break;
        }
        case 4:
            if ((chara = GetChara(GetStackInt(stack++))) == NULL) {
                return 0;
            }

            GetStackVector(scale, stack);
            break;
        default:
            return 0;
    }

    chara->SetScale(scale);
    return 1;
}

int _SET_REFERENCE(RS_STACKDATA *stack, int argc) {
    int          chara_id;
    char        *frame_name;
    int          reference_id;
    CCharacter2 *chara;
    CCharacter2 *reference_chara;
    mgCFrame    *frame;
    mgCFrame    *child;

    chara_id = GetStackInt(stack++);
    frame_name = GetStackString(stack++);
    reference_id = GetStackInt(stack);
    chara = GetChara(chara_id);

    if (chara == NULL) {
        return 0;
    }

    reference_chara = GetChara(reference_id);

    if (reference_chara == NULL) {
        return 0;
    }

    frame = chara->CObjectFrame::frame;

    if (frame == NULL) {
        return 0;
    }

    child = frame->SearchFrame(frame_name);

    if (child == NULL) {
        return 0;
    }

    frame = reference_chara->CObjectFrame::frame;

    if (frame == NULL) {
        return 0;
    }

    frame->SetReference(child);
    return 1;
}

int _DEL_REFERENCE(RS_STACKDATA *stack, int argc) {
    mgCFrame    *frame;
    CCharacter2 *chara;

    chara = GetChara(GetStackInt(stack));

    if (chara == NULL) {
        return 0;
    }

    frame = chara->CObjectFrame::frame;

    if (frame == NULL) {
        return 0;
    }

    frame->DeleteReference();
    return 1;
}

int _SHADOW_CLIP_OFF(RS_STACKDATA *stack, int argc) {
    int          chara_id;
    CCharacter2 *chara;
    int          clip_off;

    clip_off = 1;
    chara_id = GetStackInt(stack++);

    if (argc > 0) {
        clip_off = GetStackInt(stack);
    }

    chara = GetChara(chara_id);

    if (chara == NULL) {
        return 0;
    }

    if (chara->shadow_frame == NULL) {
        return 0;
    }

    mgCFrameAttr attr;
    attr.no_cull = clip_off;
    chara->shadow_frame->SetAttrParam(attr, 1, 0x100000);
    return 1;
}

int _GET_COORDINATE_ANGLE(RS_STACKDATA *stack, int argc) {
    float target[4];
    float pos[4];
    float direction[4];
    float angle;
    int   chara_no = GetStackInt(stack++);
    target[0] = GetStackFloat(stack++);
    target[1] = GetStackFloat(stack++);
    target[2] = GetStackFloat(stack++);
    target[3] = 1.0f;
    CCharacter2 *chara;

    if ((chara = GetChara(chara_no)) == NULL) {
        return 0;
    }

    angle = 0.0f;
    chara->GetPosition(pos);
    sceVu0SubVector(direction, pos, target);
    direction[3] = 0.0f;
    direction[1] = 0.0f;
    sceVu0Normalize(direction, direction);

    if (direction[0] != 0.0f || direction[2] != 0.0f) {
        angle = atan2f(-direction[0], -direction[2]);
    }

    SetStack(stack, angle);
    return 1;
}

int _GET_CHARA_WIDTH(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *next_slot;
    CCharacter2  *chara;

    next_slot = stack + 1;
    chara = GetChara(GetStackInt(stack));

    if (chara == NULL) {
        return 0;
    }

    SetStack(next_slot, chara->body_width);
    return 1;
}

int _GET_CHARA_HEIGHT(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *next_slot;
    CCharacter2  *chara;

    next_slot = stack + 1;
    chara = GetChara(GetStackInt(stack));

    if (chara == NULL) {
        return 0;
    }

    SetStack(next_slot, chara->body_height);
    return 1;
}

int _GET_CHARA_WEIGHT(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *next_slot;
    CCharacter2  *chara;

    next_slot = stack + 1;
    chara = GetChara(GetStackInt(stack));

    if (chara == NULL) {
        return 0;
    }

    SetStack(next_slot, chara->body_depth);
    return 1;
}

int _SET_CHARA_SHOW(RS_STACKDATA *stack, int argc) {
    CCharacter2 *character;
    int          show;
    int          fade;
    float        fade_speed;

    if ((character = GetChara(GetStackInt(stack++))) == NULL) {
        return 0;
    }

    fade_speed = 0.1f;
    fade = 0;
    show = GetStackInt(stack++);

    if (argc >= 3) {
        fade = GetStackInt(stack++);

        if (argc == 4) {
            fade_speed = GetStackFloat(stack);
        }
    }

    character->Show(show);
    character->fade = fade;
    character->fade_speed = fade_speed;

    if (fade == 1 && show == 1) {
        character->fade_alpha = 0.0001f;
    } else if (fade == 1 && show == 0) {
        character->fade_alpha = 1.0f;
    }

    return 1;
}

int _GET_CHARA_SHOW(RS_STACKDATA *stack, int argc) {
    CCharacter2 *character;

    if ((character = GetChara(GetStackInt(stack++))) == NULL) {
        return 0;
    }

    SetStack(stack++, character->GetShow());

    if (argc == 2) {
        SetStack(stack, character->fade);
    }

    return 1;
}

int _CHARA_DA_ENABLE(RS_STACKDATA *stack, int argc) {
    CCharacter2  *chara;
    RS_STACKDATA *next_slot;

    next_slot = stack + 1;

    if ((chara = GetChara(GetStackInt(stack))) == NULL) {
        return 0;
    }

    chara->SetDAnimeEnable(GetStackInt(next_slot));
    return 1;
}

int _GET_MOT_NOW_WAIT(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    CCharacter2 *character = GetChara(GetStackInt(stack++));

    if (character == NULL) {
        return 0;
    }

    SetStack(stack, character->GetNowFrameWait());
    return 1;
}

int _CHECK_MOTION_END(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    CCharacter2 *character = GetChara(GetStackInt(stack++));

    if (character == NULL) {
        return 0;
    }

    SetStack(stack, character->CheckMotionEnd());
    return 1;
}

int _ACTCHR_SET_MOTION(RS_STACKDATA *stack, int argc) {
    CActionChara *chara;
    char         *name;
    int           flags = 0;
    int           reset = 0;
    float         step = -1.0f;

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack), argc);

            if (args == NULL) {
                return 0;
            }

            if ((chara = (CActionChara *) GetChara(GetArgInt(args++))) == NULL) {
                return 0;
            }

            name = GetArgString(args++);

            if (argc >= 3) {
                flags = GetArgInt(args++);
            }

            if (argc >= 4) {
                step = GetArgFloat(args);
            }

            break;
        }
        case 2:
        case 3:
        case 4:
        case 5:
            if ((chara = (CActionChara *) GetChara(GetStackInt(stack++))) == NULL) {
                return 0;
            }

            name = GetStackString(stack++);

            if (argc >= 3) {
                flags = GetStackInt(stack++);
            }

            if (argc >= 4) {
                step = GetStackFloat(stack++);
            }

            if (argc >= 5) {
                reset = GetStackInt(stack);
            }

            break;
        default:
            return 0;
    }

    if (reset != 0) {
        chara->ResetMotion();
    }

    chara->SetMotion(name, flags, 1);

    if (argc >= 4) {
        if (step != -1.0f && (flags & 4)) {
            chara->NormalDrive();
            chara->SetStep(step);
        }
    }

    return 1;
}

int _SET_CHARA_EX_SOUNDID(RS_STACKDATA *stack, int argc) {
    CActionChara *chara;
    RS_STACKDATA *next_slot;

    next_slot = stack + 1;
    chara = (CActionChara *) GetChara(GetStackInt(stack));

    if (chara == NULL) {
        return 0;
    }

    chara->sound_info.se_bank_2 = GetStackInt(next_slot);
    return 1;
}

int _ACTCHR_SOUND_INFO_COPY(RS_STACKDATA *stack, int argc) {
    CActionChara *chara;

    chara = (CActionChara *) GetCharacter(GetStackInt(stack));

    if (chara == NULL) {
        return 0;
    }

    if (chara == NULL) {
        return 0;
    }

    chara->SetSoundInfoCopy();
    return 1;
}

static ClsMes *GetMes(int id) {
    return GetEventMessage(id);
}

int _MES_MAKE(RS_STACKDATA *stack, int argc) {
    int     id;
    ClsMes *mes;
    int     no;
    char   *text;
    id = GetStackInt(stack++);
    mes = GetMes(id);

    if (mes == NULL) {
        return 0;
    }

    switch (stack->type) {
        case RS_INT:
            no = GetStackInt(stack++);

            if (no == -1) {
                mes->MakeMesWin(no);
                return 1;
            }

            if (mes->mes_data != NULL && mes->mes_data_size >= 0) {
                if (mes->mes_data == NULL) {
                    return 0;
                }

                if (mes->mes_data_size <= 0) {
                    return 0;
                }

                text = GetBuffMesIdPtr(mes->mes_data, mes->mes_data_size, no);

                if (text == NULL) {
                    return 0;
                }

                mes->text_ptr = text;
                mes->MakeMesWin(mes->text_ptr, 0, 1);
            } else if (id == 0 && EdEventInfo.npc_talk_text != NULL) {
                if (EdEventInfo.npc_talk_text == NULL) {
                    return 0;
                }

                if (EdEventInfo.npc_talk_size <= 0) {
                    return 0;
                }

                text = GetBuffMesIdPtr(EdEventInfo.npc_talk_text, EdEventInfo.npc_talk_size, no);

                if (text == NULL) {
                    return 0;
                }

                mes->text_ptr = text;
                mes->MakeMesWin(mes->text_ptr, 0, 1);
            } else {
                mes->MakeMesWin(no);
            }

            break;
        case RS_STR:
            mes->MakeMesWin(GetStackString(stack++), 0, 1);
            break;
    }

    if (argc >= 3) {
        SetStack(stack, mes->char_num);
    }

    return 1;
}

int _MES_CLOSE(RS_STACKDATA *stack, int argc) {
    ClsMes *mes;

    mes = GetMes(GetStackInt(stack));

    if (mes == NULL) {
        return 0;
    }

    mes->draw_speed = mes->GetDrawSpeedDef();
    mes->mes_no = -1;
    mes->text_ptr = 0;
    mes->open = 0;
    mes->fade = 0;
    mes->fukidashi_centre_x = -1;
    mes->fukidashi_centre_y = -1;
    return 1;
}

int _MES_NEXTPAGE(RS_STACKDATA *stack, int argc) {
    ClsMes *mes;

    mes = GetMes(GetStackInt(stack));

    if (mes == NULL) {
        return 0;
    }

    if (mes->scroll_wait != 0) {
        return 1;
    }

    if (mes->page_wait == 0) {
        return 1;
    }

    mes->GoNextPage();
    return 1;
}

int _SET_MES_AUTOSET(RS_STACKDATA *stack, int argc) {
    int           values[4];
    int           chara_values[4];
    RS_STACKDATA *args;
    ClsMes       *mes;
    CCharacter2  *chara1;
    CCharacter2  *chara2;
    int           i;

    args = stack + 1;
    mes = GetMes(GetStackInt(stack));

    if (mes == NULL) {
        return 0;
    }

    if (argc != 3) {
        if (argc != 5) {
            return 0;
        }

        for (i = 0; i < 4; i++) {
            values[i] = GetStackInt(args++);
        }

        mes->AutoSet(values);
    } else {
        chara1 = GetChara(GetStackInt(args++));

        if (chara1 == NULL) {
            return 0;
        }

        chara2 = GetChara(GetStackInt(args));

        if (chara2 == NULL) {
            return 0;
        }

        mes->AutoSetSub(chara1, chara2, chara_values);
        mes->AutoSet(chara_values);
    }

    return 1;
}

int _SET_MES_SHIPPO(RS_STACKDATA *stack, int argc) {
    ClsMes *mes;

    mes = GetMes(GetStackInt(stack++));

    if (mes == NULL) {
        return 0;
    }

    mes->tail_on = GetStackInt(stack++);

    if (argc > 2) {
        mes->tail_length = GetStackInt(stack++);
    }

    if (argc > 3) {
        mes->tail_half_w = GetStackInt(stack);
    }

    return 1;
}

int _SET_MES_POS(RS_STACKDATA *stack, int argc) {
    ClsMes       *mes;
    RS_STACKDATA *next_slot;

    next_slot = stack + 1;
    mes = GetMes(GetStackInt(stack));

    if (mes == NULL) {
        return 0;
    }

    mes->fukidashi_pos = GetStackInt(next_slot);
    return 1;
}

int _SET_MES_DRAWSPEED(RS_STACKDATA *stack, int argc) {
    ClsMes *mes = GetMes(GetStackInt(stack++));

    if (mes == NULL) {
        return 0;
    }

    mes->draw_speed = GetStackFloat(stack++);

    if (argc > 2) {
        mes->draw_speed_def = GetStackFloat(stack);
    }

    return 1;
}

int _SET_MES_CURSOR(RS_STACKDATA *stack, int argc) {
    int           cursor;
    ClsMes       *mes;
    RS_STACKDATA *next_slot;

    next_slot = stack + 1;
    mes = GetMes(GetStackInt(stack));

    if (mes == NULL) {
        return 0;
    }

    cursor = GetStackInt(next_slot);

    if (mes->select < 0) {
        mes->cursor_time = 0;
    }

    mes->select = cursor;
    return 1;
}

int _SET_MES_OKURI(RS_STACKDATA *stack, int argc) {
    ClsMes       *mes;
    RS_STACKDATA *next_slot;

    next_slot = stack + 1;
    mes = GetMes(GetStackInt(stack));

    if (mes == NULL) {
        return 0;
    }

    mes->push_button = GetStackInt(next_slot);
    return 1;
}

int _SET_MES_WIN_FLAG(RS_STACKDATA *stack, int argc) {
    ClsMes       *mes;
    RS_STACKDATA *next_slot;

    next_slot = stack + 1;
    mes = GetMes(GetStackInt(stack));

    if (mes == NULL) {
        return 0;
    }

    if (GetStackInt(next_slot) != 0) {
        mes->window_mode = 1;
    } else {
        mes->window_mode = 0;
    }

    return 1;
}

int _CHECK_MES_COMPLETE(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *next_slot;
    ClsMes       *mes;

    next_slot = stack + 1;
    mes = GetMes(GetStackInt(stack));

    if (mes == NULL) {
        return 0;
    }

    SetStack(next_slot, mes->State() == 3);
    return 1;
}

int _CHECK_MES_WAIT(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *next_slot;
    ClsMes       *mes;

    next_slot = stack + 1;
    mes = GetMes(GetStackInt(stack));

    if (mes == NULL) {
        return 0;
    }

    SetStack(next_slot, mes->State() == 5);
    return 1;
}

int _CHECK_MES(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *next_slot;
    ClsMes       *mes;

    next_slot = stack + 1;
    mes = GetMes(GetStackInt(stack));

    if (mes == NULL) {
        return 0;
    }

    SetStack(next_slot, mes->State() == 0);
    return 1;
}

int _SET_MES_FUKIDASHI(RS_STACKDATA *stack, int argc) {
    ClsMes       *mes;
    RS_STACKDATA *next_slot;

    next_slot = stack + 1;
    mes = GetMes(GetStackInt(stack));

    if (mes == NULL) {
        return 0;
    }

    GetStackInt(next_slot);
    mes->SetWindowMode(1);
    return 1;
}

int _SET_MES_WINDOW_MODE(RS_STACKDATA *stack, int argc) {
    ClsMes       *mes;
    RS_STACKDATA *next_slot;

    next_slot = stack + 1;
    mes = GetMes(GetStackInt(stack));

    if (mes == NULL) {
        return 0;
    }

    mes->SetWindowMode(GetStackInt(next_slot));
    return 1;
}

int _SET_MES_PRESET(RS_STACKDATA *stack, int argc) {
    ClsMes       *mes;
    RS_STACKDATA *next_slot;

    next_slot = stack + 1;
    mes = GetMes(GetStackInt(stack));

    if (mes == NULL) {
        return 0;
    }

    mes->Preset(GetStackInt(next_slot));
    return 1;
}

int _SET_MES_ITEM_DIRECT(RS_STACKDATA *stack, int argc) {
    ClsMes       *mes;
    RS_STACKDATA *args;
    int           slot;
    int           value;

    args = stack + 1;
    mes = GetMes(GetStackInt(stack));

    if (mes == NULL) {
        return 0;
    }

    slot = GetStackInt(args++);
    value = GetStackInt(args);

    if (slot - 1 >= 0 && slot - 1 < 0x10) {
        mes->item_mes[slot - 1] = value;
    }

    return 1;
}

int _SET_MES_ITEM(RS_STACKDATA *stack, int argc) {
    ClsMes       *mes;
    RS_STACKDATA *args;
    int           slot;
    int           value;

    args = stack + 1;
    mes = GetMes(GetStackInt(stack));

    if (mes == NULL) {
        return 0;
    }

    slot = GetStackInt(args++);
    value = GetItemMessageNo(GetStackInt(args), 1);

    if (slot - 1 >= 0 && slot - 1 < 0x10) {
        mes->item_mes[slot - 1] = value;
    }

    return 1;
}

int _SET_MES_VALUE(RS_STACKDATA *stack, int argc) {
    ClsMes       *mes;
    RS_STACKDATA *args;
    int           slot;
    int           value;

    args = stack + 1;
    mes = GetMes(GetStackInt(stack));

    if (mes == NULL) {
        return 0;
    }

    slot = GetStackInt(args++);
    value = GetStackInt(args);

    if (slot == 0) {
        mes->value = value;
    } else {
        mes->values[slot - 1] = value;
        mes->value_width[slot - 1] = 0;
    }

    return 1;
}

int _GET_MES_STATUS(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *next_slot;
    ClsMes       *mes;

    next_slot = stack + 1;
    mes = GetMes(GetStackInt(stack));

    if (mes == NULL) {
        return 0;
    }

    SetStack(next_slot, mes->State());
    return 1;
}

int _GET_PARTY_CHARA_MES_NO(RS_STACKDATA *stack, int argc) {
    int           npc_id;
    int           kind;
    RS_STACKDATA *out;

    out = stack + 1;
    npc_id = GetStackInt(stack);
    kind = GetStackInt(out++);
    SetStack(out++, GetPartyCharaMessage(npc_id, kind, 1));

    if (kind == 4) {
        SetStack(out, GetPartyNPCData(npc_id)->unk_31 + 3);
    }

    return 1;
}

int _MES_SET_BUFF(RS_STACKDATA *stack, int argc) {
    ClsMes       *mes;
    int           kind;
    RS_STACKDATA *args;

    args = stack + 1;
    mes = GetMes(GetStackInt(stack));

    if (mes == NULL) {
        return 0;
    }

    kind = GetStackInt(args++);
    GetStackInt(args);

    if (kind == 0) {
        mes->SetBuff(GetSysMesBuffer());
    } else {
        mes->SetBuff_system(GetSystemMesBuffer());
    }

    return 1;
}

int _GET_MES_WINDOW_MODE(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *next_slot;
    ClsMes       *mes;

    next_slot = stack + 1;
    mes = GetMes(GetStackInt(stack));

    if (mes == NULL) {
        return 0;
    }

    argc = mes->GetWindowMode();
    SetStack(next_slot, argc);
    return 1;
}

int _GET_MES_VOICE(RS_STACKDATA *stack, int argc) {
    SetStack(stack, EdEventInfo.stream_playing);
    return 1;
}

int _SET_MES_QUESTION_GYOU(RS_STACKDATA *stack, int argc) {
    ClsMes       *mes;
    RS_STACKDATA *next_slot;

    next_slot = stack + 1;
    mes = GetMes(GetStackInt(stack));

    if (mes == NULL) {
        return 0;
    }

    mes->select_top = GetStackInt(next_slot);
    return 1;
}

int _GET_MES_QUESTION_GYOU(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *next_slot;
    ClsMes       *mes;

    next_slot = stack + 1;

    mes = GetMes(GetStackInt(stack));

    if (mes == NULL) {
        return 0;
    }

    SetStack(next_slot, mes->select_top);
    return 1;
}

int _SET_MES_CLOSE_CNT(RS_STACKDATA *stack, int argc) {
    ClsMes       *mes;
    RS_STACKDATA *next_slot;

    next_slot = stack + 1;
    mes = GetMes(GetStackInt(stack));

    if (mes == NULL) {
        return 0;
    }

    mes->close_time = GetStackInt(next_slot);
    return 1;
}

int _SET_MES_ETC(RS_STACKDATA *stack, int argc) {
    char    text[0x100];
    int     i;
    ClsMes *mes = GetMes(GetStackInt(stack++));

    if (mes == NULL) {
        return 0;
    }

    int command = GetStackInt(stack++);

    switch (command) {
        case 0:
            mes->line_indent_on = GetStackInt(stack);
            break;
        case 1:
            mes->cursor_centering = GetStackInt(stack);
            break;
        case 2:
            mes->SetHalfFontWPercent(GetStackFloat(stack));
            break;
        case 3:
            strcpy(text, "\x8B\x9B\x82\xF0\x91\x49\x82\xD7");

            for (i = 0; i < 6; i++) {
                char *fish_name = GetAquariumFish0(i);

                if (fish_name != NULL) {
                    strcat(text, "\n");
                    strcat(text, fish_name);
                }
            }

            mes->MakeMesWin(text, 0, 1);
            break;
        case 4:
            if (argc > 4) {
                mes->abs_win.x = GetStackInt(stack++);
                mes->abs_win.y = GetStackInt(stack++);
            }

            mes->abs_win.width = GetStackInt(stack++);
            mes->abs_win.height = GetStackInt(stack);
            break;
        case 5: {
            int line = GetStackInt(stack++);
            int shade = GetStackInt(stack);

            if (line >= 0 && line < MES_LINE_MAX) {
                mes->line_shade[line] = shade;
            }

            break;
        }
        case 6: {
            int line = GetStackInt(stack++);
            mes->line_alpha[line] = GetStackInt(stack);
            break;
        }
        case 7: {
            int red = GetStackInt(stack++);
            int green = GetStackInt(stack++);
            int blue = GetStackInt(stack++);
            int alpha = GetStackInt(stack);
            mes->SetDefColor(red | (green << 8 | (alpha << 24 | blue << 16)));
            break;
        }
        case 8:
            mes->fuchi = GetStackInt(stack);
            break;
        case 9:
            mes->abs_text_off_x = GetStackInt(stack++);
            mes->abs_text_off_y = GetStackInt(stack);
            break;
        case 10:
            mes->alpha = GetStackInt(stack);
            break;
        default:
            return 0;
    }

    return 1;
}

int _GET_MES_ETC(RS_STACKDATA *stack, int argc) {
    ClsMes       *mes;
    RS_STACKDATA *value = stack + 1;
    mes = GetMes(GetStackInt(stack));

    if (mes == NULL) {
        return 0;
    }

    switch (GetStackInt(value++)) {
        case 0:
            SetStack(value, mes->line_indent_on);
            break;
        case 1:
            SetStack(value, mes->cursor_centering);
            break;
        case 2: {
            CUserDataManager *user_data = &GetSaveData()->user_data;

            if (user_data == NULL) {
                return 0;
            }

            CFishAquarium *aquarium = &user_data->aquarium;

            if (aquarium == NULL) {
                return 0;
            }

            int fish_num = aquarium->GetAquariumFishNum(0);
            SetStack(value, fish_num);
            break;
        }
        case 3: {
            CVillagerInfo *info = GetVillagerInfo(GetStackInt(value++));

            if (info == NULL) {
                return 0;
            }

            SetStack(value++, info->unk_14);
            SetStack(value, info->unk_18);
            break;
        }
        default:
            return 0;
    }

    return 1;
}

int _LOAD_MES_sub(char *file_name, int stack_no, ClsMes *mes) {
    int        size;
    u32       *src;
    mgCMemory *mem;
    char      *dst;
    int        t;

    if (file_name == NULL) {
        return 0;
    }

    if (mes == NULL) {
        return 0;
    }

    src = GetLoadBGBuff(file_name, &size);

    if (src == 0) {
        return 0;
    }

    mem = EventScene->GetStack(stack_no);
    mem->Align64();
    dst = (char *) mem->stAllocTest(size / 16 + 1);

    if (dst == NULL) {
        return 0;
    }

    mem->stAlloc64(size / 16 + 1);
    memcpy(dst, src, size);
    t = size;
    mes->mes_data = dst;
    mes->mes_data_size = t;
    return 1;
}

int _LOAD_MES(RS_STACKDATA *stack, int argc) {
    ClsMes *mes = GetMes(GetStackInt(stack++));

    if (mes == NULL) {
        return 0;
    }

    if (argc == 2) {
        mes->mes_data = NULL;
        mes->mes_data_size = 0;
        return 1;
    }

    int   stack_no = GetStackInt(stack++);
    char *file_name = GetStackString(stack);

    if (file_name != NULL) {
        return _LOAD_MES_sub(file_name, stack_no, mes);
    }

    return 0;
}

int _LOAD_MES_MONS_TALK(RS_STACKDATA *stack, int argc) {
    char    path[0x80];
    ClsMes *mes = GetMes(GetStackInt(stack++));

    if (mes == NULL) {
        return 0;
    }

    int stack_no = GetStackInt(stack);
    sprintf(path, "dungeon/msg/mostalk%d_%d.txt", DngStatus.dungeon_no, LanguageCode);
    return _LOAD_MES_sub(path, stack_no, mes);
}

int _MES_SE_PLAY(RS_STACKDATA *stack, int argc) {
    switch (GetStackInt(stack)) {
        case 0:
            sndSePlay(SystemSND_ID, 0x19, 0);
            return 1;
        case 1:
            sndSePlay(SystemSND_ID, 0x19, 0);
            return 1;
        case 2:
            sndSePlay(SystemSND_ID, 0, 0);
            return 1;
        case 3:
            sndSePlay(SystemSND_ID, 1, 0);
            return 1;
        default:
            return 0;
    }
}

int _SET_MES_STR(RS_STACKDATA *stack, int argc) {
    ClsMes *mes = GetMes(GetStackInt(stack++));

    if (mes == NULL) {
        return 0;
    }

    int   name_no = GetStackInt(stack++);
    char *text = GetStackString(stack);

    if (text != NULL) {
        strcpy(mes->name[name_no - 1], text);
    }

    return 1;
}

int _GET_MES_OKURI(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    ClsMes *mes = GetMes(GetStackInt(stack++));

    if (mes == NULL) {
        return 0;
    }

    SetStack(stack, mes->push_button);
    return 1;
}
int _GET_FISHINGTOURNAMENT_ETC(RS_STACKDATA *stack, int argc) {
    int shown;
    int i;
    int weight;
    char *name;
    int padding;
    CFishingTournament *tournament;
    FISH_PRIZE_INFO prize;
    float size;
    ClsMes *mes;
    FISH_TOURNAMENT_ENTRY *entry;
    int j;
    char text[0x200];
    char itemName[0x20];
    char nameColumn[0x20];
    char sizeColumn[0x28];
    switch (GetStackInt(stack++)) {
        case 0:
            tournament = GetFishTournament();
            shown = 0;
            if (tournament == NULL) {
                return 0;
            }
            for (i = 0; i < 10; i++) {
                entry = tournament->GetRecord(i);
                if (entry != NULL) {
                    name = GetItemMessage(entry->item_no);
                    if (name != NULL) {
                        strcpy(itemName, name);
                        size = entry->size / 10.0f;
                        weight = entry->weight;
                        sprintf(nameColumn, "%s", itemName);
                        padding = 0x16 - strlen(itemName);
                        for (j = 0; j < padding / 2; j++) {
                            strcat(nameColumn, "\x81\x40");
                        }
                        sprintf(sizeColumn, "%4.1fcm\x81\x40%5dg", size, weight);
                        switch (shown) {
                            case 0:
                                strcpy(text, "\x81\x40\x82\x50\x81\x41");
                                break;
                            case 1:
                                strcat(text, "\x81\x40\x82\x51\x81\x41");
                                break;
                            case 2:
                                strcat(text, "\x81\x40\x82\x52\x81\x41");
                                break;
                            case 3:
                                strcat(text, "\x81\x40\x82\x53\x81\x41");
                                break;
                            case 4:
                                strcat(text, "\x81\x40\x82\x54\x81\x41");
                                break;
                            case 5:
                                strcat(text, "\x81\x40\x82\x55\x81\x41");
                                break;
                            case 6:
                                strcat(text, "\x81\x40\x82\x56\x81\x41");
                                break;
                            case 7:
                                strcat(text, "\x81\x40\x82\x57\x81\x41");
                                break;
                            case 8:
                                strcat(text, "\x81\x40\x82\x58\x81\x41");
                                break;
                            case 9:
                                strcat(text, "\x82\x50\x82\x4F\x81\x41");
                                break;
                            default:
                                return 0;
                        }
                        shown++;
                        strcat(text, nameColumn);
                        strcat(text, sizeColumn);
                        if (i < 9) {
                            strcat(text, "\n");
                        }
                    }
                }
            }
            mes = GetMes(GetStackInt(stack));
            if (mes == NULL) {
                return 0;
            }
            if (0 < shown) {
                mes->MakeMesWin(text, 0, 1);
            }
            break;
        case 1:
            if (GetFishPrize(0, GetStackInt(stack++) - 1, &prize) == 0) {
                return 0;
            }
            SetStack(stack++, prize.unk_0);
            SetStack(stack, prize.unk_4);
            break;
        case 2:
            tournament = GetFishTournament();
            if (tournament == NULL) {
                return 0;
            }
            SetStack(stack, tournament->EntryRemain());
            break;
        case 3:
            tournament = GetFishTournament();
            if (tournament == NULL) {
                return 0;
            }
            SetStack(stack, tournament->CalcTopWeight());
            break;
        case 4:
            tournament = GetFishTournament();
            if (tournament == NULL) {
                return 0;
            }
            SetStack(stack, tournament->rank);
            break;
        default:
            return 0;
    }
    return 1;
}
int _SET_CHARA_FAR_DIST(RS_STACKDATA *stack, int argc) {
    CCharacter2 *chara = GetChara(GetStackInt(stack++));

    if (chara == NULL) {
        return 0;
    }

    chara->SetFarDist(GetStackFloat(stack));
    return 1;
}

static int _SET_MODEL_LIGHT_SWITCH(RS_STACKDATA *stack, int argc) {
    int          chara_no = GetStackInt(stack++);
    CCharacter2 *chara = GetChara(chara_no);

    if (chara == NULL) {
        return 0;
    }

    int   on = GetStackInt(stack++);
    char *name = NULL;

    if (argc == 3) {
        name = GetStackString(stack);
    }

    mgCFrame *frame = chara->CObjectFrame::frame;

    if (name != NULL) {
        frame = frame->SearchFrame(name);
    }

    if (frame == NULL) {
        return 0;
    }

    mgCFrameAttr *attr = frame->attr;

    if (on != 0) {
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

static int _SET_MODEL_LIGHT_COLOR(RS_STACKDATA *stack, int argc) {
    int          chara_no = GetStackInt(stack++);
    CCharacter2 *chara = GetChara(chara_no);

    if (chara == NULL) {
        return 0;
    }

    float r = GetStackFloat(stack++);
    float g = GetStackFloat(stack++);
    float b = GetStackFloat(stack++);
    float a = GetStackFloat(stack++);
    char *name = NULL;

    if (argc == 6) {
        name = GetStackString(stack);
    }

    mgCFrame *frame = chara->CObjectFrame::frame;

    if (name != NULL) {
        frame = frame->SearchFrame(name);
    }

    if (frame == NULL) {
        return 0;
    }

    mgCFrameAttr *attr = frame->attr;
    attr->no_light = 1;
    attr->color[0] = r;
    attr->color[1] = g;
    attr->color[2] = b;
    attr->color[3] = a;
    frame->SetAttrParam(*attr, 1, MG_FRAME_ATTR_COLOR);
    return 1;
}

int _GET_OMAKE_FLAG(RS_STACKDATA *stack, int argc) {
    SetStack(stack, OmakeFlag);
    return 1;
}

int _SET_WIND(RS_STACKDATA *stack, int argc) {
    float dir[4];
    float power = GetStackFloat(stack++);

    if (power < 0.0f) {
        EventScene->ResetWind();
        return 1;
    }

    dir[0] = GetStackFloat(stack++);
    dir[1] = GetStackFloat(stack++);
    dir[2] = GetStackFloat(stack);
    dir[3] = 1.0f;
    EventScene->SetWind(power, dir);
    return 1;
}

int _SET_OMAKE_FLAG(RS_STACKDATA *stack, int argc) {
    OmakeFlag = GetStackInt(stack);
    return 1;
}

static CCameraControl *GetCamera() {
    return (CCameraControl *) GetActiveCamera();
}

int _SET_CAMERA_POS(RS_STACKDATA *stack, int argc) {
    float      pos[4];
    mgCCamera *camera;

    if ((camera = GetCamera()) == NULL) {
        return 0;
    }

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            GetArgVector(pos, args);
            break;
        }
        case 3:
            GetStackVector(pos, stack);
            break;
        default:
            return 0;
    }

    camera->SetPos(pos);
    return 1;
}

int _GET_CAMERA_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];

    if (argc < 3) {
        return 0;
    }

    mgCCamera *camera = GetCamera();

    if (camera == NULL) {
        return 0;
    }

    camera->GetPos(pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

int _SET_CAMERA_REF(RS_STACKDATA *stack, int argc) {
    float      pos[4];
    mgCCamera *camera;

    if ((camera = GetCamera()) == NULL) {
        return 0;
    }

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            GetArgVector(pos, args);
            break;
        }
        case 3:
            GetStackVector(pos, stack);
            break;
        default:
            return 0;
    }

    camera->SetRef(pos);
    return 1;
}

int _GET_CAMERA_REF(RS_STACKDATA *stack, int argc) {
    float pos[4];

    if (argc < 3) {
        return 0;
    }

    mgCCamera *camera = GetCamera();

    if (camera == NULL) {
        return 0;
    }

    camera->GetRef(pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

static int _SET_CAMERA_SPEED(RS_STACKDATA *stack, int argc) {
    mgCCamera *camera = GetCamera();

    if (camera == NULL) {
        return 0;
    }

    camera->SetSpeed(GetStackFloat(stack), -1.0f);
    return 1;
}

int _CAMERA_STEP(RS_STACKDATA *stack, int argc) {
    mgCCameraFollow *camera = GetCamera();

    if (camera == NULL) {
        return 0;
    }

    camera->Step(GetStackInt(stack));
    return 1;
}

int _GET_BEFORE_CAMERA_POS(RS_STACKDATA *stack, int argc) {
    float      pos[4];
    mgCCamera *camera = EventScene->GetCamera(EventScene->before_camera);

    if (camera == NULL) {
        return 0;
    }

    camera->GetPos(pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

int _GET_BEFORE_CAMERA_REF(RS_STACKDATA *stack, int argc) {
    float      pos[4];
    mgCCamera *camera = EventScene->GetCamera(EventScene->before_camera);

    if (camera == NULL) {
        return 0;
    }

    camera->GetRef(pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

int _ASQ_INIT(RS_STACKDATA *stack, int argc) {
    return 1;
}

int _ASQ_SYNC_CHARA(RS_STACKDATA *stack, int argc) {
    return 1;
}

int _ASQ_SET_POS(RS_STACKDATA *stack, int argc) {
    return 1;
}

int _ASQ_MOVE(RS_STACKDATA *stack, int argc) {
    return 1;
}

int _ASQ_MOVE_STEP(RS_STACKDATA *stack, int argc) {
    return 1;
}

int _ASQ_ROT_REF(RS_STACKDATA *stack, int argc) {
    return 1;
}

int _ASQ_ROT_ANGLE(RS_STACKDATA *stack, int argc) {
    return 1;
}

int _ASQ_CLEAR_ROT(RS_STACKDATA *stack, int argc) {
    return 1;
}

int _ASQ_WAIT_ROT(RS_STACKDATA *stack, int argc) {
    return 1;
}

int _ASQ_ROT_MOVE(RS_STACKDATA *stack, int argc) {
    return 1;
}

int _ASQ_SET_ROT(RS_STACKDATA *stack, int argc) {
    return 1;
}

int _ASQ_DELAY_ROT(RS_STACKDATA *stack, int argc) {
    return 1;
}

int _ASQ_MOTION_TRG(RS_STACKDATA *stack, int argc) {
    return 1;
}

int _ASQ_MOTION_PLAY(RS_STACKDATA *stack, int argc) {
    return 1;
}

int _ASQ_MOTION_STOP(RS_STACKDATA *stack, int argc) {
    return 1;
}

int _ASQ_MOTION_NEXT(RS_STACKDATA *stack, int argc) {
    return 1;
}

int _ASQ_ANIME_TRG(RS_STACKDATA *stack, int argc) {
    return 1;
}

int _ASQ_ANIME(RS_STACKDATA *stack, int argc) {
    return 1;
}

int _ASQ_SE_PLAY(RS_STACKDATA *stack, int argc) {
    return 1;
}

/**
 * Sets an event text sprite visibility and returns the update status.
 */
int _IMG_SET_DRAW(RS_STACKDATA *stack, int argc) {
    int draw;

    draw = GetStackInt(stack++);
    return esMother.SetDraw(GetStackInt(stack), draw);
}

/**
 * Sets an event text sprite source rectangle and returns the update status.
 */
int _IMG_SET_GET(RS_STACKDATA *stack, int argc) {
    int index = GetStackInt(stack++);
    int a = GetStackInt(stack++);
    int b = GetStackInt(stack++);
    int c = GetStackInt(stack++);
    return esMother.SetGet(index, a, b, c, GetStackInt(stack));
}

/**
 * Sets an event text sprite destination rectangle and returns the update status.
 */
int _IMG_SET_PUT(RS_STACKDATA *stack, int argc) {
    int index = GetStackInt(stack++);
    int a = GetStackInt(stack++);
    int b = GetStackInt(stack++);
    int c = GetStackInt(stack++);
    return esMother.SetPut(index, a, b, c, GetStackInt(stack));
}

int _IMG_SET_NAME(RS_STACKDATA *stack, int argc) {
    int   no = GetStackInt(stack++);
    char *name = GetStackString(stack);
    return esMother.SetName(no, name);
}

/**
 * Sets an event text sprite movement and returns the update status.
 */
int _IMG_SET_MOVE(RS_STACKDATA *stack, int argc) {
    int index = GetStackInt(stack++);
    int x = GetStackInt(stack++);
    int y = GetStackInt(stack++);
    return esMother.SetMove(index, x, y, GetStackInt(stack));
}

/**
 * Sets an event text sprite fade and returns the update status.
 */
int _IMG_SET_FADE(RS_STACKDATA *stack, int argc) {
    int index = GetStackInt(stack++);
    int from = GetStackInt(stack++);
    return esMother.SetFade(index, from, GetStackInt(stack));
}

/**
 * Sets an event text sprite color and returns the update status.
 */
int _IMG_SET_COLOR(RS_STACKDATA *stack, int argc) {
    int index = GetStackInt(stack++);
    int r = GetStackInt(stack++);
    int g = GetStackInt(stack++);
    int b = GetStackInt(stack++);
    return esMother.SetColor(index, r, g, b, GetStackInt(stack));
}

static CEventSprite2 *GetEventSprite(int index) {
    if (index < 0 || index >= event_sprite2_num) {
        return 0;
    }

    return &EventSprite2[index];
}

int _SPRITE_INIT(RS_STACKDATA *stack, int argc) {
    CEventSprite2 *sprite;

    sprite = GetEventSprite(GetStackInt(stack));

    if (sprite == NULL) {
        return 0;
    }

    sprite->Initialize();
    return 1;
}

int _SPRITE_SET_DRAW(RS_STACKDATA *stack, int argc) {
    int            index = GetStackInt(stack++);
    int            value = GetStackInt(stack);
    CEventSprite2 *sprite = GetEventSprite(index);

    if (sprite == NULL) {
        return 0;
    }

    sprite->SetDrawFlag(value);
    return 1;
}

int _SPRITE_SET_TYPE(RS_STACKDATA *stack, int argc) {
    int            index = GetStackInt(stack++);
    int            value = GetStackInt(stack);
    CEventSprite2 *sprite = GetEventSprite(index);

    if (sprite == NULL) {
        return 0;
    }

    sprite->SetSpriteType(value);
    return 1;
}

int _SPRITE_SET_TEXTURE(RS_STACKDATA *stack, int argc) {
    int            index = GetStackInt(stack++);
    char          *name = GetStackString(stack++);
    int            tex_block = GetStackInt(stack);
    CEventSprite2 *sprite = GetEventSprite(index);

    if (sprite == NULL) {
        return 0;
    }

    sprite->SetTexture(name, tex_block);
    return 1;
}

int _SPRITE_SET_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];
    mgZeroVector(pos);
    pos[3] = 1.0f;
    int index = GetStackInt(stack++);
    pos[0] = GetStackFloat(stack++);
    pos[1] = GetStackFloat(stack++);

    if (argc >= 4) {
        pos[2] = GetStackFloat(stack);
    }

    CEventSprite2 *sprite;

    if ((sprite = GetEventSprite(index)) == NULL) {
        return 0;
    }

    if (sprite->GetType() == 0) {
        pos[1] += sprite_ground_offset;
    }

    printf("_SPRITE_SET_POS:%f,%f\n", pos[0], pos[1]);
    sprite->SetPosition(pos);
    return 1;
}

int _SPRITE_SET_PUTSIZE(RS_STACKDATA *stack, int argc) {
    int            index = GetStackInt(stack++);
    int            width = GetStackInt(stack++);
    int            height = GetStackInt(stack);
    CEventSprite2 *sprite = GetEventSprite(index);

    if (sprite == NULL) {
        return 0;
    }

    if (height == 0x1A0 || height == 0x1C0) {
        height += 0x40;
    }

    sprite->SetPutSize(width, height);
    printf("_SPRITE_SET_PUTSIZE:%d,%d\n", width, height);
    return 1;
}

int _SPRITE_SET_UVSIZE(RS_STACKDATA *stack, int argc) {
    int            index = GetStackInt(stack++);
    int            x = GetStackInt(stack++);
    int            y = GetStackInt(stack++);
    int            width = GetStackInt(stack++);
    int            height = GetStackInt(stack);
    CEventSprite2 *sprite = GetEventSprite(index);

    if (sprite == NULL) {
        return 0;
    }

    sprite->SetUvSize(x, y, width, height);
    return 1;
}

int _SPRITE_SET_COLOR(RS_STACKDATA *stack, int argc) {
    float color[4];
    int   index = GetStackInt(stack++);
    color[0] = GetStackFloat(stack++);
    color[1] = GetStackFloat(stack++);
    color[2] = GetStackFloat(stack++);
    color[3] = GetStackFloat(stack);
    CEventSprite2 *sprite = GetEventSprite(index);

    if (sprite == NULL) {
        return 0;
    }

    sprite->SetColor(color);
    return 1;
}

int _SPRITE_SET_SCALE(RS_STACKDATA *stack, int argc) {
    int            index = GetStackInt(stack++);
    float          scale_x = GetStackFloat(stack++);
    float          scale_y = GetStackFloat(stack);
    CEventSprite2 *sprite = GetEventSprite(index);

    if (sprite == NULL) {
        return 0;
    }

    sprite->SetScale(scale_x, scale_y);
    return 1;
}

int _SPRITE_SET_ALPHAB(RS_STACKDATA *stack, int argc) {
    int            index = GetStackInt(stack++);
    int            value = GetStackInt(stack);
    CEventSprite2 *sprite = GetEventSprite(index);

    if (sprite == NULL) {
        return 0;
    }

    sprite->SetAlphaBlend(value);
    return 1;
}

int _CMRS_CHECK(RS_STACKDATA *stack, int argc) {
    SetStack(stack, (u8) ((CameraSeq.CheckEnd() != 0) ^ 1));
    return 1;
}

int _CMRS_INIT(RS_STACKDATA *stack, int argc) {
    CameraSeq.Clear();
    return 1;
}

int _CMRS_PRDELAY(RS_STACKDATA *stack, int argc) {
    CameraSeq.PRDelay(GetStackInt(stack));
    return 1;
}

int _CMRS_SET_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            GetArgVector(pos, args);
            break;
        }
        case 3:
            GetStackVector(pos, stack);
            break;
        default:
            return 0;
    }

    CameraSeq.SetPos(pos);
    return 1;
}

int _CMRS_SET_REF(RS_STACKDATA *stack, int argc) {
    float pos[4];

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            GetArgVector(pos, args);
            break;
        }
        case 3:
            GetStackVector(pos, stack);
            break;
        default:
            return 0;
    }

    CameraSeq.SetRef(pos);
    return 1;
}

int _CMRS_AHDDELAY(RS_STACKDATA *stack, int argc) {
    CameraSeq.AHDDelay(GetStackInt(stack));
    return 1;
}

int _CMRS_SET_ANGLE(RS_STACKDATA *stack, int argc) {
    CameraSeq.SetAngle(GetStackFloat(stack));
    return 1;
}

int _CMRS_SET_HEIGHT(RS_STACKDATA *stack, int argc) {
    CameraSeq.SetHeight(GetStackFloat(stack));
    return 1;
}

int _CMRS_SET_DIST(RS_STACKDATA *stack, int argc) {
    CameraSeq.SetDist(GetStackFloat(stack));
    return 1;
}

int _CMRS_SET_AHD(RS_STACKDATA *stack, int argc) {
    float angle = GetStackFloat(stack++);
    float height = GetStackFloat(stack++);
    float dist = GetStackFloat(stack);
    CameraSeq.SetAHD(angle, height, dist);
    return 1;
}

int _CMRS_MOVE(RS_STACKDATA *stack, int argc) {
    float pos[4];
    float ref[4];
    int   frames;

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            GetArgVector(pos, args);
            GetArgVector(ref, args + 3);
            frames = GetArgInt(args += 6);
            break;
        }
        case 7:
            GetStackVector(pos, stack);
            GetStackVector(ref, stack + 3);
            frames = GetStackInt(stack += 6);
            break;
        default:
            return 0;
    }

    CameraSeq.Move(pos, ref, frames);
    return 1;
}

int _CMRS_MOVE2(RS_STACKDATA *stack, int argc) {
    float pos[4];
    float ref[4];
    int   frames;
    int   wait;
    float rate;

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            GetArgVector(pos, args);
            GetArgVector(ref, args + 3);
            args += 6;
            frames = GetArgInt(args++);
            wait = GetArgInt(args++);
            rate = GetArgFloat(args);
            break;
        }
        case 9:
            GetStackVector(pos, stack);
            GetStackVector(ref, stack + 3);
            stack += 6;
            frames = GetStackInt(stack++);
            wait = GetStackInt(stack++);
            rate = GetStackFloat(stack);
            break;
        default:
            return 0;
    }

    CameraSeq.Move2(pos, ref, frames, wait, rate);
    return 1;
}

int _CMRS_MOVE_REF(RS_STACKDATA *stack, int argc) {
    float pos[4];
    int   frames;

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            GetArgVector(pos, args);
            frames = GetArgInt(args += 3);
            break;
        }
        case 4:
            GetStackVector(pos, stack);
            frames = GetStackInt(stack += 3);
            break;
        default:
            return 0;
    }

    CameraSeq.MoveRef(pos, frames);
    return 1;
}

int _CMRS_INIT_PAS(RS_STACKDATA *stack, int argc) {
    CameraSeq.InitPas();
    return 1;
}

int _CMRS_SET_PAS_FRM(RS_STACKDATA *stack, int argc) {
    CameraSeq.SetPasFrm(GetStackInt(stack));
    return 1;
}

int _CMRS_ADD_PAS(RS_STACKDATA *stack, int argc) {
    float first[4];
    float second[4];

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            GetArgVector(first, args);
            GetArgVector(second, args + 3);
            break;
        }
        case 6:
            GetStackVector(first, stack);
            GetStackVector(second, stack + 3);
            break;
        default:
            return 0;
    }

    CameraSeq.AddPas(first, second);
    return 1;
}

int _CMRS_START_PAS(RS_STACKDATA *stack, int argc) {
    CameraSeq.StartPas();
    return 1;
}

int _CMRS_PR_SLOWING(RS_STACKDATA *stack, int argc) {
    float rate = GetStackFloat(stack++);
    int   frame = GetStackInt(stack);
    CameraSeq.PRSlowing(rate, frame);
    return 1;
}

int _CMRS_PR_KEEP(RS_STACKDATA *stack, int argc) {
    CameraSeq.PRKeep();
    return 1;
}

int _CMRS_PR_RETURN(RS_STACKDATA *stack, int argc) {
    CameraSeq.PRReturn();
    return 1;
}

int _CMRS_MOVE_AHD(RS_STACKDATA *stack, int argc) {
    float angle;
    float height;
    float distance;
    int   frames;

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            angle = GetArgFloat(args++);
            height = GetArgFloat(args++);
            distance = GetArgFloat(args++);
            frames = GetArgInt(args);
            break;
        }
        case 4:
            angle = GetStackFloat(stack++);
            height = GetStackFloat(stack++);
            distance = GetStackFloat(stack++);
            frames = GetStackInt(stack);
            break;
        default:
            return 0;
    }

    CameraSeq.MoveAHD(angle, height, distance, frames);
    return 1;
}

int _CMRS_SYNC_OBJ(RS_STACKDATA *stack, int argc) {
    float offset[4];
    float angle;
    float height;
    float dist;
    int   obj;
    int   mode = 0;
    char *frame_name = NULL;

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack), argc);

            if (args == NULL) {
                return 0;
            }

            obj = GetArgInt(args++);
            offset[0] = GetArgFloat(args++);
            offset[1] = GetArgFloat(args++);
            offset[2] = GetArgFloat(args++);
            offset[3] = 1.0f;
            angle = GetArgFloat(args++);
            height = GetArgFloat(args++);
            dist = GetArgFloat(args++);

            if (argc >= 8) {
                frame_name = GetArgString(args++);
            }

            if (argc >= 9) {
                mode = GetArgInt(args);
            }

            break;
        }
        case 7:
        case 8:
        case 9:
            obj = GetStackInt(stack++);
            offset[0] = GetStackFloat(stack++);
            offset[1] = GetStackFloat(stack++);
            offset[2] = GetStackFloat(stack++);
            offset[3] = 1.0f;
            angle = GetStackFloat(stack++);
            height = GetStackFloat(stack++);
            dist = GetStackFloat(stack++);

            if (argc >= 8) {
                frame_name = GetStackString(stack++);
            }

            if (argc >= 9) {
                mode = GetStackInt(stack);
            }

            break;
        default:
            return 0;
    }

    CameraSeq.SetSyncObj(obj, offset, angle, height, dist, mode, frame_name);
    return 1;
}

int _CMRS_MOVE_AHD2(RS_STACKDATA *stack, int argc) {
    float angle;
    float height;
    float distance;
    int   frames;
    int   wait;
    float rate;

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            angle = GetArgFloat(args++);
            height = GetArgFloat(args++);
            distance = GetArgFloat(args++);
            frames = GetArgInt(args++);
            wait = GetArgInt(args++);
            rate = GetArgFloat(args);
            break;
        }
        case 6:
            angle = GetStackFloat(stack++);
            height = GetStackFloat(stack++);
            distance = GetStackFloat(stack++);
            frames = GetStackInt(stack++);
            wait = GetStackInt(stack++);
            rate = GetStackFloat(stack);
            break;
        default:
            return 0;
    }

    CameraSeq.MoveAHD2(angle, height, distance, frames, wait, rate);
    return 1;
}

int _CMRS_RELEASE_OBJ(RS_STACKDATA *stack, int argc) {
    CameraSeq.ReleaseSyncObj();
    return 1;
}

int _CMRS_AHD_SLOWING(RS_STACKDATA *stack, int argc) {
    float rate = GetStackFloat(stack++);
    int   frame = GetStackInt(stack);
    CameraSeq.AHDSlowing(rate, frame);
    return 1;
}

int _CMRS_AHD_KEEP(RS_STACKDATA *stack, int argc) {
    CameraSeq.AHDKeep();
    return 1;
}

int _CMRS_AHD_RETURN(RS_STACKDATA *stack, int argc) {
    CameraSeq.AHDReturn();
    return 1;
}

int _CMRS_FADE_DELAY(RS_STACKDATA *stack, int argc) {
    CameraSeq.FadeDelay(GetStackInt(stack));
    return 1;
}

int _CMRS_FADE_INIT(RS_STACKDATA *stack, int argc) {
    CameraSeq.FadeInit();
    return 1;
}

int _CMRS_FADE_IN(RS_STACKDATA *stack, int argc) {
    float r = 0.0f;
    float g = 0.0f;
    float b = 0.0f;
    int   frame = GetStackInt(stack++);

    if (argc == 4) {
        r = GetStackFloat(stack++);
        g = GetStackFloat(stack++);
        b = GetStackFloat(stack);
    }

    CameraSeq.FadeIn(frame, r, g, b);
    return 1;
}

int _CMRS_FADE_OUT(RS_STACKDATA *stack, int argc) {
    float r = 0.0f;
    float g = 0.0f;
    float b = 0.0f;
    int   frame = GetStackInt(stack++);

    if (argc == 4) {
        r = GetStackFloat(stack++);
        g = GetStackFloat(stack++);
        b = GetStackFloat(stack);
    }

    CameraSeq.FadeOut(frame, r, g, b);
    return 1;
}

int _CMRS_QUAKE_DELAY(RS_STACKDATA *stack, int argc) {
    CameraSeq.QuakeDelay(GetStackInt(stack));
    return 1;
}

int _CMRS_QUAKE(RS_STACKDATA *stack, int argc) {
    float amplitude[4];
    amplitude[0] = GetStackFloat(stack++);
    amplitude[1] = GetStackFloat(stack++);
    amplitude[2] = GetStackFloat(stack++);
    amplitude[3] = 0.0f;
    CameraSeq.Quake(amplitude, GetStackInt(stack));
    return 1;
}

int _CMRS_QUAKE2(RS_STACKDATA *stack, int argc) {
    float amplitude[4];
    amplitude[0] = GetStackFloat(stack++);
    amplitude[1] = GetStackFloat(stack++);
    amplitude[2] = GetStackFloat(stack++);
    amplitude[3] = 0.0f;
    CameraSeq.Quake2(amplitude, GetStackInt(stack));
    return 1;
}

int _CMRS_CHARA_DELAY(RS_STACKDATA *stack, int argc) {
    CameraSeq.CharaDelay(GetStackInt(stack));
    return 1;
}

int _CMRS_CHARA_ATTACH(RS_STACKDATA *stack, int argc) {
    int   kind;
    float factor;

    kind = GetStackInt(stack++);
    factor = GetStackFloat(stack++);
    CameraSeq.CharaAttach(kind, factor, GetStackInt(stack));
    return 1;
}

int _CMRS_MOVE_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];
    int   frames;

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            GetArgVector(pos, args);
            frames = GetArgInt(args += 3);
            break;
        }
        case 4:
            GetStackVector(pos, stack);
            frames = GetStackInt(stack += 3);
            break;
        default:
            return 0;
    }

    CameraSeq.MovePos(pos, frames);
    return 1;
}

int _OBJS_CHECK(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq(GetStackInt(stack++));

    if (seq == NULL) {
        return 0;
    }

    SetStack(stack, (u8) ((seq->CheckEnd() != 0) ^ 1));
    return 1;
}

int _OBJS_INIT(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq(GetStackInt(stack));

    if (seq == NULL) {
        return 0;
    }

    seq->Clear();
    return 1;
}

int _OBJS_SYNC_OBJ(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    int slot = GetStackInt(stack++);
    int eoh_no = GetStackInt(stack);
    seq = GetObjSeq(slot);

    if (seq == NULL) {
        return 0;
    }

    seq->SetEohNo(eoh_no);
    return 1;
}

int _OBJS_POS_DELAY(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    int slot = GetStackInt(stack++);
    int frame = GetStackInt(stack);
    seq = GetObjSeq(slot);

    if (seq == NULL) {
        return 0;
    }

    seq->PosDelay(frame);
    return 1;
}

int _OBJS_SET_POS(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;
    float         pos[4];
    int           slot;
    ARG_DATA     *args;

    switch (argc) {
        case 1:
            args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            slot = GetArgInt(args++);
            GetArgVector(pos, args);
            break;
        case 4:
            slot = GetStackInt(stack++);
            GetStackVector(pos, stack);
            break;
        default:
            return 0;
    }

    seq = GetObjSeq(slot);

    if (seq == NULL) {
        return 0;
    }

    seq->SetPos(pos);
    return 1;
}

int _OBJS_MOVE(RS_STACKDATA *stack, int argc) {
    float pos[4];
    int   index;
    int   frame;
    int   ground = 0;

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack), argc);

            if (args == NULL) {
                return 0;
            }

            index = GetArgInt(args++);
            GetArgVector(pos, args);
            args += 3;
            frame = GetArgInt(args++);

            if (argc >= 6) {
                ground = GetArgInt(args);
            }

            break;
        }
        case 5:
        case 6:
            index = GetStackInt(stack++);
            GetStackVector(pos, stack);
            stack = &stack[3];
            frame = GetStackInt(stack++);

            if (argc >= 6) {
                ground = GetStackInt(stack);
            }

            break;
        default:
            return 0;
    }

    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == NULL) {
        return 0;
    }

    seq->Move(pos, frame, ground);
    return 1;
}

int _OBJS_MOVE2(RS_STACKDATA *stack, int argc) {
    float pos[4];
    int   index;
    int   frame;
    int   ease;
    float rate;

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            index = GetArgInt(args++);
            GetArgVector(pos, args);
            args += 3;
            frame = GetArgInt(args++);
            ease = GetArgInt(args++);
            rate = GetArgFloat(args);
            break;
        }
        case 7:
            index = GetStackInt(stack++);
            GetStackVector(pos, stack);
            stack += 3;
            frame = GetStackInt(stack++);
            ease = GetStackInt(stack++);
            rate = GetStackFloat(stack);
            break;
        default:
            return 0;
    }

    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == NULL) {
        return 0;
    }

    seq->Move2(pos, frame, ease, rate);
    return 1;
}

int _OBJS_INIT_PAS(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq(GetStackInt(stack));

    if (seq == NULL) {
        return 0;
    }

    seq->InitPas();
    return 1;
}

int _OBJS_SET_PAS_FRM(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    int slot = GetStackInt(stack++);
    int frame = GetStackInt(stack);
    seq = GetObjSeq(slot);

    if (seq == NULL) {
        return 0;
    }

    seq->SetPasFrm(frame);
    return 1;
}

int _OBJS_ADD_PAS(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;
    float         pos[4];
    int           slot;
    ARG_DATA     *args;

    switch (argc) {
        case 1:
            args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            slot = GetArgInt(args++);
            GetArgVector(pos, args);
            break;
        case 4:
            slot = GetStackInt(stack++);
            GetStackVector(pos, stack);
            break;
        default:
            return 0;
    }

    seq = GetObjSeq(slot);

    if (seq == NULL) {
        return 0;
    }

    seq->AddPas(pos);
    return 1;
}

int _OBJS_START_PAS(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;
    int           seq_no;
    int           frame;

    frame = 0;
    seq_no = GetStackInt(stack++);

    if (argc >= 2) {
        frame = GetStackInt(stack);
    }

    seq = GetObjSeq(seq_no);

    if (seq == NULL) {
        return 0;
    }

    seq->StartPas(frame);
    return 1;
}

int _OBJS_JUMP(RS_STACKDATA *stack, int argc) {
    float pos[4];
    float height;
    int   index;
    int   frame;

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            index = GetArgInt(args++);
            GetArgVector(pos, args);
            args += 3;
            height = GetArgFloat(args++);
            frame = GetArgInt(args);
            break;
        }
        case 6:
            index = GetStackInt(stack++);
            GetStackVector(pos, stack);
            stack += 3;
            height = GetStackFloat(stack++);
            frame = GetStackInt(stack);
            break;
        default:
            return 0;
    }

    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == NULL) {
        return 0;
    }

    seq->Jump(pos, height, frame);
    return 1;
}

int _OBJS_SET_EOH_FRAME_POS(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;
    float offset[4];
    int slot;
    int eohNo;
    int frames;
    const int vector_bytes = 0x18;
    char *frameName;

    frames = 0;
    mgZeroVector(offset);
    switch (argc) {
        case 3:
            slot = GetStackInt(stack++);
            eohNo = GetStackInt(stack++);
            frameName = GetStackString(stack);
            break;
        case 4:
            slot = GetStackInt(stack++);
            eohNo = GetStackInt(stack++);
            frameName = GetStackString(stack++);
            frames = GetStackInt(stack);
            break;
        case 6:
            slot = GetStackInt(stack++);
            eohNo = GetStackInt(stack++);
            frameName = GetStackString(stack++);
            GetStackVector(offset, stack);
            break;
        case 7:
            slot = GetStackInt(stack++);
            eohNo = GetStackInt(stack++);
            frameName = GetStackString(stack++);
            GetStackVector(offset, stack);

            stack = (RS_STACKDATA *)((u8 *)stack + vector_bytes);
            frames = GetStackInt(stack);
            break;
    }
    seq = GetObjSeq(slot);
    if (seq == NULL) {
        return 0;
    }
    seq->SetEohFramePos(eohNo, frameName, frames, offset);
    return 1;
}
int _OBJS_ADD_POS(RS_STACKDATA *stack, int argc) {
    float add[4];
    int index;
    int frame = 1;
    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack));
            if (args == NULL) {
                return 0;
            }
            index = GetArgInt(args++);
            GetArgVector(add, args);
            frame = GetArgInt(args += 3);
            break;
        }
        case 4:
        case 5:
            index = GetStackInt(stack++);
            GetStackVector(add, stack);
            stack += 3;
            if (argc >= 5) {
                frame = GetStackInt(stack++);
            }
            break;
        default:
            return 0;
    }
    CSceneObjSeq *seq = GetObjSeq(index);
    if (seq == NULL) {
        return 0;
    }
    seq->AddPos(add, frame);
    return 1;
}
int _OBJS_ATTACH_CAMERA(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;
    int           slot;
    float         rate;

    slot = GetStackInt(stack++);
    rate = GetStackFloat(stack++);
    int frame = GetStackInt(stack);
    seq = GetObjSeq(slot);

    if (seq == NULL) {
        return 0;
    }

    seq->AttachCamera(rate, frame);
    return 1;
}

int _OBJS_ROT_DELAY(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    int slot = GetStackInt(stack++);
    int frame = GetStackInt(stack);
    seq = GetObjSeq(slot);

    if (seq == NULL) {
        return 0;
    }

    seq->RotDelay(frame);
    return 1;
}

int _OBJS_SET_ROT(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;
    float         rot[4];
    int           slot;
    ARG_DATA     *args;

    switch (argc) {
        case 1:
            args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            slot = GetArgInt(args++);
            GetArgVector(rot, args);
            break;
        case 4:
            slot = GetStackInt(stack++);
            GetStackVector(rot, stack);
            break;
        default:
            return 0;
    }

    seq = GetObjSeq(slot);

    if (seq == NULL) {
        return 0;
    }

    seq->SetRot(rot);
    return 1;
}

int _OBJS_ROTATION(RS_STACKDATA *stack, int argc) {
    float rot[4];
    int   index;
    int   frame;

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            index = GetArgInt(args++);
            GetArgVector(rot, args);
            frame = GetArgInt(args += 3);
            break;
        }
        case 5:
            index = GetStackInt(stack++);
            GetStackVector(rot, stack);
            frame = GetStackInt(stack += 3);
            break;
        default:
            return 0;
    }

    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == NULL) {
        return 0;
    }

    seq->Rotation(rot, frame);
    return 1;
}

int _OBJS_ROTATION2(RS_STACKDATA *stack, int argc) {
    float rot[4];
    int   index;
    int   frame;
    int   ease;
    float rate;

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            index = GetArgInt(args++);
            GetArgVector(rot, args);
            args += 3;
            frame = GetArgInt(args++);
            ease = GetArgInt(args++);
            rate = GetArgFloat(args);
            break;
        }
        case 7:
            index = GetStackInt(stack++);
            GetStackVector(rot, stack);
            stack += 3;
            frame = GetStackInt(stack++);
            ease = GetStackInt(stack++);
            rate = GetStackFloat(stack);
            break;
        default:
            return 0;
    }

    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == NULL) {
        return 0;
    }

    seq->Rotation2(rot, frame, ease, rate);
    return 1;
}

int _OBJS_REFERENCE(RS_STACKDATA *stack, int argc) {
    float pos[4];
    int   index;
    int   frame;

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            index = GetArgInt(args++);
            GetArgVector(pos, args);
            frame = GetArgInt(args += 3);
            break;
        }
        case 5:
            index = GetStackInt(stack++);
            GetStackVector(pos, stack);
            frame = GetStackInt(stack += 3);
            break;
        default:
            return 0;
    }

    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == NULL) {
        return 0;
    }

    seq->Reference(pos, frame);
    return 1;
}

int _OBJS_MOTION_DELAY(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    int slot = GetStackInt(stack++);
    int frame = GetStackInt(stack);
    seq = GetObjSeq(slot);

    if (seq == NULL) {
        return 0;
    }

    seq->MotionDelay(frame);
    return 1;
}

int _OBJS_SET_MOTION(RS_STACKDATA *stack, int argc) {
    int   index;
    int   type = 0;
    float blend = -1.0f;
    int   normal_drive = 0;
    char *name;

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack), argc);

            if (args == NULL) {
                return 0;
            }

            index = GetArgInt(args++);
            name = GetArgString(args++);

            if (argc >= 3) {
                type = GetArgInt(args++);
            }

            if (argc >= 4) {
                blend = GetArgFloat(args++);
            }

            if (argc >= 5) {
                normal_drive = GetArgInt(args);
            }

            break;
        }
        case 2:
        case 3:
        case 4:
        case 5:
            index = GetStackInt(stack++);
            name = GetStackString(stack++);

            if (argc >= 3) {
                type = GetStackInt(stack++);
            }

            if (argc >= 4) {
                blend = GetStackFloat(stack++);
            }

            if (argc >= 5) {
                normal_drive = GetStackInt(stack);
            }

            break;
        default:
            return 0;
    }

    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == NULL) {
        return 0;
    }

    seq->SetMotion(name, type, blend);

    if (normal_drive == 1) {
        seq->NormalDrive();
        seq->ResetDAPosition();
    }

    return 1;
}

int _OBJS_NEXT_MOTION(RS_STACKDATA *stack, int argc) {
    int   index;
    int   type = 0;
    float blend = -1.0f;
    char *name;

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack), argc);

            if (args == NULL) {
                return 0;
            }

            index = GetArgInt(args++);
            name = GetArgString(args++);

            if (argc >= 3) {
                type = GetArgInt(args++);
            }

            if (argc >= 4) {
                blend = GetArgFloat(args);
            }

            break;
        }
        case 2:
        case 3:
        case 4:
            index = GetStackInt(stack++);
            name = GetStackString(stack++);

            if (argc >= 3) {
                type = GetStackInt(stack++);
            }

            if (argc >= 4) {
                blend = GetStackFloat(stack);
            }

            break;
        default:
            return 0;
    }

    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == NULL) {
        return 0;
    }

    seq->NextMotion(name, type, blend);
    return 1;
}

int _OBJS_MOTION_WAIT(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq(GetStackInt(stack));

    if (seq == NULL) {
        return 0;
    }

    seq->MotionWait();
    return 1;
}

int _OBJS_SET_STEP(RS_STACKDATA *stack, int argc) {
    int           index = GetStackInt(stack++);
    float         step = GetStackFloat(stack);
    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == NULL) {
        return 0;
    }

    seq->SetStep(step);
    return 1;
}

int _OBJS_CHENGE_STEP(RS_STACKDATA *stack, int argc) {
    float step = 0.2f;
    int   index = GetStackInt(stack++);

    if (argc > 0) {
        step = GetStackFloat(stack);
    }

    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == NULL) {
        return 0;
    }

    if (step <= 0.0f) {
        step = 0.2f;
    }

    seq->SetChengeStep(step);
    return 1;
}

int _OBJS_SEQ_MOT_TRG(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq(GetStackInt(stack));

    if (seq == NULL) {
        return 0;
    }

    seq->SetMotionTrg();
    return 1;
}

int _OBJS_SEQ_MOT_TRG_WAIT(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq(GetStackInt(stack));

    if (seq == NULL) {
        return 0;
    }

    seq->MotionTrgWait();
    return 1;
}

int _OBJS_RESET_MOTION(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq(GetStackInt(stack));

    if (seq == NULL) {
        return 0;
    }

    seq->ResetMotion();
    return 1;
}

int _OBJS_SET_MOTION_NOW_TIME(RS_STACKDATA *stack, int argc) {
    int           index = GetStackInt(stack++);
    float         time = GetStackFloat(stack);
    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == NULL) {
        return 0;
    }

    seq->SetMotionNowTime(time);
    return 1;
}

int _OBJS_SET_MOTION_WAIT_TIME(RS_STACKDATA *stack, int argc) {
    int           index = GetStackInt(stack++);
    float         time = GetStackFloat(stack);
    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == NULL) {
        return 0;
    }

    seq->SetMotionWaitTime(time);
    return 1;
}

int _OBJS_TEXA_DELAY(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    int slot = GetStackInt(stack++);
    int frame = GetStackInt(stack);
    seq = GetObjSeq(slot);

    if (seq == NULL) {
        return 0;
    }

    seq->TexAnimeDelay(frame);
    return 1;
}

int _OBJS_TEX_ANIME(RS_STACKDATA *stack, int argc) {
    int   index = GetStackInt(stack++);
    int   on = GetStackInt(stack++);
    char *name = NULL;

    if (argc >= 3) {
        name = GetStackString(stack);
    }

    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == NULL) {
        return 0;
    }

    seq->TexAnime(name, on);
    return 1;
}

int _OBJS_COLOR_DELAY(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    int slot = GetStackInt(stack++);
    int frame = GetStackInt(stack);
    seq = GetObjSeq(slot);

    if (seq == NULL) {
        return 0;
    }

    seq->ColorDelay(frame);
    return 1;
}

int _OBJS_SET_COLOR(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;
    float         color[4];
    int           slot;
    int           frames;

    frames = 0;
    slot = GetStackInt(stack++);
    color[0] = GetStackFloat(stack++);
    color[1] = GetStackFloat(stack++);
    color[2] = GetStackFloat(stack++);
    color[3] = GetStackFloat(stack++);

    if (argc >= 6) {
        frames = GetStackInt(stack);
    }

    seq = GetObjSeq(slot);

    if (seq == NULL) {
        return 0;
    }

    seq->SetColor(color, frames);
    return 1;
}

int _OBJS_SCALE_DELAY(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    int slot = GetStackInt(stack++);
    int frame = GetStackInt(stack);
    seq = GetObjSeq(slot);

    if (seq == NULL) {
        return 0;
    }

    seq->ScaleDelay(frame);
    return 1;
}

int _OBJS_SET_SCALE(RS_STACKDATA *stack, int argc) {
    float scale[4];
    int   index;
    int   flag = 0;
    index = GetStackInt(stack++);
    scale[0] = GetStackFloat(stack++);
    scale[1] = GetStackFloat(stack++);
    scale[2] = GetStackFloat(stack++);
    scale[3] = 1.0f;

    if (argc >= 5) {
        flag = GetStackInt(stack);
    }

    CSceneObjSeq *seq;

    if ((seq = GetObjSeq(index)) == NULL) {
        return 0;
    }

    seq->SetScale(scale, flag);
    return 1;
}

int _OBJS_SE_DELAY(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    int slot = GetStackInt(stack++);
    int frame = GetStackInt(stack);
    seq = GetObjSeq(slot);

    if (seq == NULL) {
        return 0;
    }

    seq->SeDelay(frame);
    return 1;
}

int _OBJS_SE_PLAY(RS_STACKDATA *stack, int argc) {
    int           index = GetStackInt(stack++);
    int           snd_id = GetStackInt(stack++);
    int           se_no = GetStackInt(stack);
    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == NULL) {
        return 0;
    }

    seq->SePlay(snd_id, se_no);
    return 1;
}

int _OBJS_RESET_DA_POSITION(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq(GetStackInt(stack));

    if (seq == NULL) {
        return 0;
    }

    seq->ResetDAPosition();
    return 1;
}

int _OBJS_NORMAL_DRIVE(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq(GetStackInt(stack));

    if (seq == NULL) {
        return 0;
    }

    seq->NormalDrive();
    return 1;
}

int _ASQ_CHECK(RS_STACKDATA *stack, int argc) {
    return 1;
}

int _SND_INIT_PORT(RS_STACKDATA *stack, int argc) {
    sndInitPort(GetStackInt(stack));
    return 1;
}

int _SND_LOAD_SOUND(RS_STACKDATA *stack, int argc) {
    char       path[0x80];
    int        port;
    mgCMemory *memory;
    char      *file_name;
    int        sound_id;

    switch (argc) {
        case 2:
            port = 4;
            memory = &BuffEventSnd;
            break;
        case 3:
            port = GetStackInt(stack++);

            if (port == 8) {
                memory = &BuffEventSnd2;
            } else {
                memory = &BuffEventSnd;
            }

            break;
        default:
            return 0;
    }

    switch (stack->type) {
        case RS_INT:
            if (EventScene->GetDefEventSeFile(GetStackInt(stack++), path) == 0) {
                return 0;
            }

            file_name = path;
            break;
        case RS_STR:
            file_name = GetStackString(stack++);
            break;
        default:
            return 0;
    }

    if (port < 0 || port > 11) {
        return 0;
    }

    if (memory->stack == NULL || memory->stack_size <= 0) {
        return 0;
    }

    u32 *pack = GetLoadBGBuff(file_name, NULL);

    if (pack == NULL) {
        return 0;
    }

    sndInitPort(port);
    SetStack(stack, sound_id = sndLoadSound(port, pack, memory));
    EdEventInfo.snd_id[port] = sound_id;
    EdEventInfo.last_snd_id = sound_id;
    return 1;
}

int _GET_SND_ID(RS_STACKDATA *stack, int argc) {
    int snd_id;
    int src_no;

    if (argc == 1) {
        snd_id = EdEventInfo.last_snd_id;
    } else {
        switch (GetStackInt(stack++)) {
            case 0:
                snd_id = EventScene->se_env_id;
                break;
            case 1:
            case 2:
            case 3:
                snd_id = EventScene->se_base_id;
                break;
            case 4:
                snd_id = EventScene->se_battle_id;
                break;
            case 5:
                if (argc > 1) {
                    src_no = GetStackInt(stack++);
                }

                snd_id = EventScene->GetSeSrcID(src_no);
                break;
            default:
                return 0;
        }
    }

    SetStack(stack, snd_id);
    return 1;
}

int _SND_SE_PAUSE(RS_STACKDATA *stack, int argc) {
    u32 se_id;

    se_id = GetStackInt(stack++);
    sndSePause(se_id, GetStackInt(stack));
    return 1;
}

int _SND_SE_PLAY(RS_STACKDATA *stack, int argc) {
    switch (argc) {
        case 2: {
            u32 se_id = GetStackInt(stack++);
            int voice = GetStackInt(stack);
            sndSePlay(se_id, voice, 0);
            return 1;
        }
        case 3: {
            u32 se_id = GetStackInt(stack++);
            int voice = GetStackInt(stack++);
            int volume = GetStackInt(stack);
            sndSePlayV(se_id, voice, volume, 0);
            return 1;
        }
        case 4: {
            u32 se_id = GetStackInt(stack++);
            int voice = GetStackInt(stack++);
            int volume = GetStackInt(stack++);
            int pan = GetStackInt(stack);
            sndSePlayVP(se_id, voice, volume, pan, 0);
            return 1;
        }
        default:
            return 0;
    }
}

int _SND_SE_STOP(RS_STACKDATA *stack, int argc) {
    u32 se_id;

    se_id = GetStackInt(stack++);
    sndSeStop(se_id, GetStackInt(stack), 0);
    return 1;
}

int _SND_SET_SE_VOL(RS_STACKDATA *stack, int argc) {
    u32 se_id;
    int voice;

    se_id = GetStackInt(stack++);
    voice = GetStackInt(stack++);

    switch (stack->type) {
        case 0:
            sndSetSeVol(se_id, voice, GetStackInt(stack), 0);
            break;
        case 1:
            sndSetSeVolf(se_id, voice, GetStackFloat(stack), 0);
            break;
        default:
            return 0;
    }

    return 1;
}

int _SND_SET_SE_PAN(RS_STACKDATA *stack, int argc) {
    int se_id = GetStackInt(stack++);
    int pan = GetStackInt(stack++);
    int time = GetStackInt(stack);
    sndSetSePan(se_id, pan, time, 0);
    return 1;
}

int _SND_SET_SE_PITCH(RS_STACKDATA *stack, int argc) {
    int se_id = GetStackInt(stack++);
    int pitch = GetStackInt(stack++);
    int time = GetStackInt(stack);
    sndSetSePitch(se_id, pitch, time, 0);
    return 1;
}

int _SND_SE_ALL_STOP(RS_STACKDATA *stack, int argc) {
    sndSeAllStop(GetStackInt(stack));
    return 1;
}

int _LOAD_BGM(RS_STACKDATA *stack, int argc) {
    int bgm_no;

    bgm_no = GetStackInt(stack);

    if (EventScene->CheckLoadBGM(bgm_no) == 0) {
        return 0;
    }

    return EventScene->LoadBGM(bgm_no, read_buffer);
}

int _PLAY_BGM(RS_STACKDATA *stack, int argc) {
    int bgm_no;

    switch (argc) {
        case 1:
            EventScene->PlayBGM(GetStackInt(stack), -1, 1.0f);
            return 1;
        case 2:
            bgm_no = GetStackInt(stack++);
            EventScene->PlayBGM(bgm_no, GetStackInt(stack), 1.0f);
            return 1;
    }

    return 0;
}

int _STOP_BGM(RS_STACKDATA *stack, int argc) {
    EventScene->StopBGM(GetStackInt(stack));
    return 1;
}

int CommandStreamOpenFromFPL(int stream, char *name, char *base) {
    char path[64];
    char base_name[64];

    strcpy(path, "cdrom0:\\V\\");
    strncat(path, name, 3);
    strcat(path, "\\V");
    strcat(path, name);
    strcat(path, ".VPK;1");
    strcpy(base_name, base);
    strcat(base_name, ".wav");
    CSnd.StreamOpenFromFPLFast(stream, path, base_name);
    return 1;
}

int CommandStreamOpen(int stream, char *name) {
    char path[64];

    strcpy(path, "cdrom0:\\VOICE\\");
    strcat(path, name);
    strcat(path, ".WV;1");
    CSnd.StreamOpenFast(stream, path);
    return 1;
}

int VpkFileNameFromVoiceNo(char *name, int voice_no) {
    int group = voice_no / 10000;
    int kind = 0;

    switch (group) {
        case 1:
            if (voice_no >= 10705) {
                if (voice_no < 10721) {
                    kind = 1;
                }
            }

            if (voice_no >= 10300) {
                if (voice_no < 10701) {
                    kind = 2;
                }
            }

            break;
        case 105:
        case 108:
        case 109:
        case 255:
        case 600:
        case 640:
            break;
    }

    VpkTable table = {{
        {1, 0, 0, 100},
        {1, 1, 0, 106},
        {1, 2, 0, 105},
        {2, 0, 0, 110},
        {3, 0, 0, 115},
        {4, 0, 0, 120},
        {5, 0, 0, 125},
        {6, 0, 100, 100},
        {50, 0, 0, 130},
        {60, 0, 0, 180},
        {61, 0, 0, 185},
        {100, 0, 100, 105},
        {101, 0, 100, 110},
        {102, 0, 100, 115},
        {103, 0, 100, 120},
        {104, 0, 100, 125},
        {105, 0, 0, 135},
        {105, 1, 0, 140},
        {105, 2, 0, 145},
        {106, 0, 0, 150},
        {107, 0, 100, 130},
        {108, 0, 100, 135},
        {108, 1, 100, 136},
        {108, 2, 100, 137},
        {109, 0, 0, 155},
        {109, 1, 0, 160},
        {110, 0, 100, 140},
        {111, 0, 100, 145},
        {201, 0, 100, 150},
        {202, 0, 100, 155},
        {203, 0, 300, 100},
        {204, 0, 10, 100},
        {205, 0, 10, 105},
        {206, 0, 10, 110},
        {207, 0, 10, 115},
        {208, 0, 10, 120},
        {209, 0, 10, 125},
        {215, 0, 110, 100},
        {220, 0, 110, 105},
        {230, 0, 110, 110},
        {235, 0, 110, 115},
        {240, 0, 110, 120},
        {245, 0, 110, 125},
        {247, 0, 10, 130},
        {250, 0, 10, 135},
        {253, 0, 10, 140},
        {255, 0, 110, 130},
        {255, 1, 110, 135},
        {256, 0, 110, 140},
        {257, 0, 110, 145},
        {260, 0, 110, 150},
        {270, 0, 10, 145},
        {272, 0, 10, 150},
        {275, 0, 10, 155},
        {277, 0, 10, 160},
        {280, 0, 10, 165},
        {283, 0, 10, 170},
        {285, 0, 10, 180},
        {290, 0, 110, 155},
        {300, 0, 15, 100},
        {302, 0, 15, 105},
        {304, 0, 15, 110},
        {305, 0, 0, 165},
        {306, 0, 15, 115},
        {307, 0, 115, 100},
        {308, 0, 115, 105},
        {312, 0, 115, 110},
        {314, 0, 115, 115},
        {315, 0, 115, 120},
        {316, 0, 115, 125},
        {317, 0, 115, 130},
        {320, 0, 15, 120},
        {324, 0, 15, 125},
        {328, 0, 15, 130},
        {330, 0, 15, 135},
        {332, 0, 115, 135},
        {336, 0, 115, 140},
        {340, 0, 115, 145},
        {344, 0, 0, 170},
        {348, 0, 115, 150},
        {352, 0, 115, 155},
        {356, 0, 115, 160},
        {360, 0, 15, 140},
        {364, 0, 15, 145},
        {368, 0, 15, 150},
        {372, 0, 15, 155},
        {376, 0, 15, 160},
        {400, 0, 20, 100},
        {402, 0, 20, 105},
        {404, 0, 20, 110},
        {406, 0, 120, 100},
        {408, 0, 120, 105},
        {410, 0, 120, 110},
        {412, 0, 20, 115},
        {414, 0, 20, 120},
        {416, 0, 120, 115},
        {420, 0, 120, 120},
        {424, 0, 0, 175},
        {428, 0, 20, 125},
        {432, 0, 120, 125},
        {434, 0, 120, 130},
        {436, 0, 120, 135},
        {438, 0, 120, 140},
        {440, 0, 120, 145},
        {444, 0, 120, 150},
        {448, 0, 20, 130},
        {452, 0, 20, 135},
        {456, 0, 20, 140},
        {460, 0, 20, 145},
        {464, 0, 20, 150},
        {468, 0, 20, 155},
        {500, 0, 25, 100},
        {504, 0, 25, 105},
        {508, 0, 25, 110},
        {512, 0, 125, 100},
        {516, 0, 125, 105},
        {520, 0, 125, 110},
        {522, 0, 125, 115},
        {523, 0, 125, 120},
        {524, 0, 25, 115},
        {526, 0, 125, 125},
        {528, 0, 125, 130},
        {532, 0, 125, 135},
        {536, 0, 125, 140},
        {540, 0, 25, 120},
        {548, 0, 25, 125},
        {552, 0, 25, 130},
        {556, 0, 25, 135},
        {560, 0, 25, 140},
        {600, 0, 20, 160},
        {600, 1, 20, 161},
        {604, 0, 30, 100},
        {608, 0, 130, 100},
        {610, 0, 130, 105},
        {612, 0, 130, 110},
        {616, 0, 40, 100},
        {624, 0, 110, 160},
        {628, 0, 115, 165},
        {632, 0, 120, 155},
        {636, 0, 125, 145},
        {640, 0, 40, 105},
        {640, 1, 40, 106},
        {640, 2, 40, 107},
        {648, 0, 40, 110},
        {700, 0, 30, 105},
        {702, 0, 130, 115},
        {704, 0, 30, 110},
        {708, 0, 130, 120},
        {712, 0, 130, 125},
        {716, 0, 130, 130},
        {720, 0, 130, 135},
        {724, 0, 130, 140},
        {728, 0, 130, 145},
        {732, 0, 130, 150},
        {736, 0, 130, 160},
        {744, 0, 30, 115},
        {748, 0, 30, 120},
        {800, 0, 0, 190},
        {804, 0, 0, 195},
        {808, 0, 150, 100},
        {812, 0, 150, 105},
        {816, 0, 150, 110},
        {820, 0, 150, 115},
        {824, 0, 50, 100},
    }};

    for (int i = 0; i < vpk_entry_count; i++) {
        if (group == table.entry[i].group && kind == table.entry[i].kind) {
            sprintf(name, "%03d_%03d", table.entry[i].id, table.entry[i].sub);
            return 1;
        }
    }

    return 0;
}
int _STREAM_OPEN(RS_STACKDATA *stack, int argc) {
    char voicePack[0x80];
    char voicePath[0x80];
    GetStackInt(stack++);
    switch (argc) {
        case 2:
            switch (stack->type) {
                case RS_INT: {
                    EdEventInfo.stream_from_fpl = 1;
                    int voiceNo = GetStackInt(stack++);
                    if (VpkFileNameFromVoiceNo(voicePack, voiceNo) == 0) {
                        return 0;
                    }
                    sprintf(voicePath, "%07d", voiceNo);
                    CommandStreamOpenFromFPL(1, voicePack, voicePath);
                }
                case RS_STR:
                    EdEventInfo.stream_from_fpl = 0;
                    CommandStreamOpen(1, GetStackString(stack));
                default:
                    return 0;
            }
        case 3:
            EdEventInfo.stream_from_fpl = 1;
            CommandStreamOpenFromFPL(1, GetStackString(stack++), GetStackString(stack));
            return 0;
    }
    return 0;
}
int CommandStreamPlay(int stream, int volume) {
    int reverb = sndGetReverbDepth(1);
    int scaled = (int) ((double) volume - 256.0 * (1.5 * (double) reverb));
    printf("vol=%d,vol_0=%d\n", scaled, volume);
    EdEventInfo.stream_volume = volume;
    CSnd.StreamSetVol(stream, scaled, scaled);
    CSnd.StreamPlay(stream);
    return 1;
}

int _STREAM_PLAY(RS_STACKDATA *stack, int argc) {
    EdEventInfo.stream_playing = 1;
    GetStackInt(stack++);

    switch (argc) {
        case 1:
            return CommandStreamPlay(event_stream, stream_max_volume);
        case 2:
            return CommandStreamPlay(event_stream, GetStackInt(stack));
    }

    return 0;
}

int _STREAM_STOP(RS_STACKDATA *stack, int argc) {
    EdEventInfo.stream_playing = 0;
    GetStackInt(stack);

    if (EdEventInfo.stream_from_fpl == 1) {
        CSnd.StreamEND(event_stream);
    } else {
        CSnd.StreamSetVol(event_stream, EdEventInfo.stream_volume, EdEventInfo.stream_volume);
        CSnd.StreamClose(event_stream);
    }

    return 1;
}

int _STREAM_STANDBY(RS_STACKDATA *stack, int argc) {
    GetStackInt(stack);
    CSnd.StreamStandBy(event_stream);
    return 1;
}

int _STREAM_GET_STATUS(RS_STACKDATA *stack, int argc) {
    GetStackInt(stack++);

    argc = CSnd.StreamGetState(event_stream);
    SetStack(stack, argc);
    return 1;
}

int _GET_SYS_SND_ID(RS_STACKDATA *stack, int argc) {

    argc = GetSystemSndID();
    SetStack(stack, argc);
    return 1;
}

int _STREAM_OPEN_CHECK(RS_STACKDATA *stack, int argc) {
    SetStack(stack, CSnd.StreamOpenState());
    return 1;
}

int _LOAD_SE_ENV(RS_STACKDATA *stack, int argc) {
    int bank_no;

    bank_no = GetStackInt(stack);

    if (EventScene->CheckLoadSeEnv(bank_no) == 0) {
        return 0;
    }

    EventScene->LoadSeEnv(bank_no, read_buffer);
    return 1;
}

int _PLAY_ENV_BGM(RS_STACKDATA *stack, int argc) {
    int voice;
    int volume;

    voice = GetStackInt(stack++);
    EventScene->StopEnvBGM();

    if (voice == -1) {
        EventScene->AutoChangeEnvBGM(1);
        EventScene->SetEnvBGMVol(1.0f);
        return 1;
    }

    switch (argc) {
        case 1:
            EventScene->SetEnvBGMVol(1.0f);
            EventScene->PlayEnvBGM(voice, 1.0f);
            EdEventInfo.env_bgm_no = voice;
            EdEventInfo.env_bgm_volume = 1.0f;
            return 1;
        case 2:

            volume = fptosi(GetStackFloat(stack));
            EventScene->SetEnvBGMVol(volume);
            EventScene->PlayEnvBGM(voice, 1.0f);
            EdEventInfo.env_bgm_no = voice;
            EdEventInfo.env_bgm_volume = volume;
            return 1;
    }

    return 0;
}

int _SYS_SE_PLAY(RS_STACKDATA *stack, int argc) {
    int se_id;

    se_id = GetStackInt(stack);

    if (se_id < 0) {
        return 0;
    }

    sndSePlay(SystemSND_ID, se_id, 0);
    return 1;
}

int _INIT_SE_SRC(RS_STACKDATA *stack, int argc) {
    EventScene->InitSeSrc();
    return 1;
}

int _INIT_SE_ENV(RS_STACKDATA *stack, int argc) {
    EventScene->InitSeEnv();
    return 1;
}

int _INIT_SE_BAS(RS_STACKDATA *stack, int argc) {
    EventScene->InitSeBas();
    return 1;
}

int _LOAD_SE_SRC(RS_STACKDATA *stack, int argc) {
    int src_no;

    src_no = GetStackInt(stack);

    if (EventScene->CheckLoadSeSrc(src_no) == 0) {
        return 0;
    }

    return EventScene->LoadSeSrc(src_no, read_buffer);
}

int _LOAD_SE_FOOT(RS_STACKDATA *stack, int argc) {
    return 0;
}

int _LOAD_SE_DOOR(RS_STACKDATA *stack, int argc) {
    return 0;
}

int _LOAD_SE_BOX(RS_STACKDATA *stack, int argc) {
    return 0;
}

int _LOAD_SE_BATTLE(RS_STACKDATA *stack, int argc) {
    int bank_no;

    bank_no = GetStackInt(stack);

    if (EventScene->CheckLoadSeBattle(bank_no) == 0) {
        return 0;
    }

    return EventScene->LoadSeBattle(bank_no, read_buffer);
}

int _SND_DELETE_PORT(RS_STACKDATA *stack, int argc) {
    sndDeletePort(GetStackInt(stack));
    return 1;
}

int _FADE_IN_BGM(RS_STACKDATA *stack, int argc) {
    int frames60;
    int frames;

    frames60 = GetStackInt(stack);
    frames = frames60 * 50 / 60;

    if (frames <= 0) {
        frames = 1;
    }

    EventScene->FadeInBGM(frames);
    return 1;
}

int _FADE_OUT_BGM(RS_STACKDATA *stack, int argc) {
    int frames60;
    int frames;

    frames60 = GetStackInt(stack);
    frames = frames60 * 50 / 60;

    if (frames <= 0) {
        frames = 1;
    }

    EventScene->FadeOutBGM(frames);
    return 1;
}

int _STOP_ENV_BGM(RS_STACKDATA *stack, int argc) {
    EventScene->StopEnvBGM();
    return 1;
}

int _SET_BGM_VOL(RS_STACKDATA *stack, int argc) {
    if (stack->type == RS_INT) {
        EventScene->SetVolBGM(GetStackInt(stack));
    } else if (stack->type == RS_FLOAT) {
        int volume = EventScene->GetVolBGM();
        EventScene->SetVolBGM(fptosi(volume * GetStackFloat(stack)));
    } else {
        return 0;
    }

    return 1;
}

int _SND_SET_REVERB(RS_STACKDATA *stack, int argc) {
    return 0;
}

int _SND_SET_ENV_VOL(RS_STACKDATA *stack, int argc) {
    EventScene->SetEnvBGMVol(GetStackFloat(stack));
    return 1;
}

int _STREAM_SILENT_CHECK(RS_STACKDATA *stack, int argc) {
    int level;
    int loud;

    GetStackInt(stack++);
    level = CSnd.StreamGetLevel(event_stream);
    loud = 1;

    if ((s16) (u16) level < 11 && (s16) (u16) level >= -10 && (s16) (level >> 16) < 11 &&
        (s16) (level >> 16) >= -10) {
        loud = 0;
    }

    SetStack(stack, loud);
    return 1;
}

int _AUTO_CHANGE_ENV(RS_STACKDATA *stack, int argc) {
    EventScene->AutoChangeEnvBGM(GetStackInt(stack));
    return 1;
}

int _BGM_LOAD_CANCEL(RS_STACKDATA *stack, int argc) {
    EventScene->skip_load_bgm = 1;
    return 1;
}

int _SOUND_LOAD_CANCEL(RS_STACKDATA *stack, int argc) {
    EventScene->skip_load_sound = 1;
    return 1;
}

int _BGM_LOAD_ENABLE(RS_STACKDATA *stack, int argc) {
    EventScene->skip_load_bgm = 0;
    return 1;
}

int _SOUND_LOAD_ENABLE(RS_STACKDATA *stack, int argc) {
    EventScene->skip_load_sound = 0;
    return 1;
}

int _LOAD_SE_BASE(RS_STACKDATA *stack, int argc) {
    int bank_no;

    bank_no = GetStackInt(stack);

    if (EventScene->CheckLoadSeBase(bank_no) == 0) {
        return 0;
    }

    return EventScene->LoadSeBase(bank_no, read_buffer);
}

int _LOAD_SOUND(RS_STACKDATA *stack, int argc) {
    EventScene->LoadSound(GetStackInt(stack), read_buffer);
    return 1;
}

int _STREAM_CLOSE(RS_STACKDATA *stack, int argc) {
    EdEventInfo.stream_playing = 0;
    GetStackInt(stack);
    CSnd.StreamSetVol(event_stream, EdEventInfo.stream_volume, EdEventInfo.stream_volume);
    CSnd.StreamClose(event_stream);
    EdEventInfo.stream_reading = 0;
    return 1;
}

int CommandStreamOpen2(int stream, char *name) {
    char path[64];
    strcpy(path, "cdrom0:\\VOICE\\");
    strcat(path, name);
    strcat(path, ".WV;1");
    return 1;
}

int _STREAM_OPEN2(RS_STACKDATA *stack, int argc) {
    int result;
    GetStackInt(stack++);
    EdEventInfo.stream_from_fpl = 0;
    result = CommandStreamOpen2(event_stream, GetStackString(stack));

    if (result == 1) {
        EdEventInfo.stream_reading = 1;
    }

    return result;
}

int _LOAD_BGM_PACK(RS_STACKDATA *stack, int argc) {
    char file_name[64];
    int  bgm_no;
    u32 *pack;

    bgm_no = GetStackInt(stack);

    if (EventScene->CheckLoadBGM(bgm_no) == 0) {
        return 0;
    }

    EventScene->GetBgmFile(file_name, bgm_no);
    pack = GetLoadBGBuff(file_name, NULL);

    if (pack != NULL) {
        return EventScene->LoadBGMPack(bgm_no, pack);
    }

    return 0;
}

int _GET_BGM_NO(RS_STACKDATA *stack, int argc) {
    SetStack(stack, EventScene->GetActiveBgmInfo()->load_no);
    return 1;
}

int _GET_MASTER_VOL(RS_STACKDATA *stack, int argc) {
    SetStack(stack, EventScene->GetActiveBgmInfo()->master_volf);
    return 1;
}

int _SET_MASTER_VOL(RS_STACKDATA *stack, int argc) {
    float   volume;
    CScene *scene;

    volume = GetStackFloat(stack);
    scene = EventScene;
    scene->GetActiveBgmInfo()->master_volf = volume;
    scene->SetVolfBGM(scene->GetActiveBgmInfo()->volf);
    return 1;
}

int _GET_BTL_BGM_VOL(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *battle_bgm;

    battle_bgm = &EventScene->battle_area;

    if (battle_bgm == NULL) {
        return 0;
    }

    SetStack(stack, battle_bgm->battle_bgm_vol);
    return 1;
}

int _SET_BTL_BGM_VOL(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *battle_bgm = &EventScene->battle_area;

    if (battle_bgm == NULL) {
        return 0;
    }

    battle_bgm->battle_bgm_vol = GetStackFloat(stack);
    return 1;
}

int _SND_IN_REVERB(RS_STACKDATA *stack, int argc) {
    CSnd.SndInReverb(GetStackInt(stack) != 0);
    return 1;
}

int _SND_STOP_SRC(RS_STACKDATA *stack, int argc) {
    EventScene->StopSeSrc();
    return 1;
}

int _SND_PAUSE_BGM(RS_STACKDATA *stack, int argc) {
    EventScene->PauseBGM();
    return 1;
}

int _STREAM_OPEN3(RS_STACKDATA *stack, int argc) {
    char name[64];

    GetStackInt(stack++);
    EdEventInfo.stream_from_fpl = 2;
    sprintf(name, "%07d.wav", GetStackInt(stack));
    CSnd.StreamOpenFast(event_stream, name);
    EdEventInfo.stream_reading = 1;
    return 1;
}

int _GET_ACTIVE_BGM_STATUS(RS_STACKDATA *stack, int argc) {
    EventScene->GetActiveBgmStatus(&EdEventInfo.bgm_status);
    return 1;
}

int _SET_ACTIVE_BGM_STATUS(RS_STACKDATA *stack, int argc) {
    EventScene->SetActiveBgmStatus(&EdEventInfo.bgm_status);
    return 1;
}

int _GET_BGM_STATUS_NOW_NO(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    SetStack(stack, EdEventInfo.bgm_status.load_no);
    return 1;
}

int _GET_SE_STATUS(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }

    int se_id = GetStackInt(stack++);
    int voice = GetStackInt(stack++);

    argc = sndGetSeStatus(se_id, voice);
    SetStack(stack, argc);
    return 1;
}

int _SE_ALL_STOP(RS_STACKDATA *stack, int argc) {
    EventScene->SeAllStop();
    return 1;
}

int _SOUND_ALL_STOP(RS_STACKDATA *stack, int argc) {
    EventScene->SoundAllStop();
    return 1;
}

int _BGM_PLAY_CANCEL(RS_STACKDATA *stack, int argc) {

    (&EventScene->skip_load_sound)[1] = 1;
    return 1;
}

int _BGM_PLAY_ENABLE(RS_STACKDATA *stack, int argc) {
    (&EventScene->skip_load_sound)[1] = 0;
    return 1;
}
int _GET_DEF_BGM_NO(RS_STACKDATA *stack, int argc) {
    int sndId;
    int bgmNo;
    if (argc == 1) {
        CScene *scene = EventScene; int map = scene->now_map_no; int sub = scene->now_sub_map_no;
if (0 < sub) { sndId = GetMapSndDataID(sub); } else { sndId = GetMapSndDataID(map); }
        bgmNo = EventScene->GetDefBgmNo(sndId);
        SetStack(stack, bgmNo);
        return 1;
    }
    if (argc == 2) {
        sndId = GetMapSndDataID(GetStackInt(stack++));
        bgmNo = EventScene->GetDefBgmNo(sndId);
        SetStack(stack, bgmNo);
        return 1;
    }
    return 0;
}
int _SET_MOVIE_CC(RS_STACKDATA *stack, int argc) {
    int i;
    int no;
    int start;
    char *text;
    int frames;
    int mode = GetStackInt(stack++);
    switch (mode) {
        case 0:
            EdEventInfo.caption_enable = GetStackInt(stack);
            if (EdEventInfo.caption_enable == 0) {
                for (i = 0; i < 18; i++) {
                    EdEventInfo.caption_start[i] = 0;
                    memset(EdEventInfo.caption_text[i], 0, sizeof(EdEventInfo.caption_text[i]));
                    EdEventInfo.caption_frames[i] = 0;
                }
            }
            break;
        case 1:
            no = GetStackInt(stack++);
            start = GetStackInt(stack++);
            text = GetStackString(stack++);
            frames = GetStackInt(stack);
            if (no < 0) {
                return 0;
            }
            if (no >= 18) {
                return 0;
            }
            start = start * 50 / 60;
            frames = frames * 50 / 60;
            EdEventInfo.caption_start[no] = start;
            strcpy(EdEventInfo.caption_text[no], text);
            EdEventInfo.caption_frames[no] = frames;
            break;
        default:
            return 0;
    }
    return 1;
}
int _REGISTER_VILLAGER2(RS_STACKDATA *stack, int argc) {
    int        villager_no;
    int        mode;
    mgCMemory *memory;

    villager_no = GetStackInt(stack++);
    mode = GetStackInt(stack++);
    memory = EventScene->GetStack(GetStackInt(stack));

    if (memory == NULL) {
        return 0;
    }

    EventScene->RegisterVillager(villager_no, mode, memory);
    return 1;
}

int _SET_FISHINGTOURNAMENT_ETC(RS_STACKDATA *stack, int argc) {
    CFishingTournament *tournament;
    RS_STACKDATA       *next = stack + 1;

    switch (GetStackInt(stack)) {
        case 0:
            tournament = GetFishTournament();

            if (tournament == NULL) {
                return 0;
            }

            tournament->SetRank(GetStackInt(next));
            break;
        case 1:
            tournament = GetFishTournament();

            if (tournament == NULL) {
                return 0;
            }

            tournament->ResetRecord();
            break;
        case 2:
            InitFishPrize();
            LoadFishPrize(1);
            break;
        case 3:
            TuriTourCount();
            break;
        default:
            return 0;
    }

    return 1;
}

int _EOH_SYNC_CHARA(RS_STACKDATA *stack, int argc) {
    CCharacter2 *chara;
    int          slot;
    int          chara_no;

    slot = GetStackInt(stack++);
    chara_no = GetStackInt(stack);
    chara = GetChara(chara_no);

    if (chara != NULL) {
        return EventObjHandleMother.Set(slot, 0, chara_no, chara);
    }

    return 0;
}

int _EOH_SYNC_OBJ(RS_STACKDATA *stack, int argc) {
    CMap      *maps[8];
    int        map_count;
    int        i;
    CMapParts *parts;
    int        slot;
    int        parts_id;
    char      *parts_name;

    if (argc < 2 || argc > 4) {
        return 0;
    }

    map_count = EventScene->GetActiveMap(maps, 8);

    if (!(map_count > 0)) {
        return 0;
    }

    slot = GetStackInt(stack++);

    switch (stack->type) {
        case 0:
            parts_id = GetStackInt(stack++);

            for (i = 0; i < map_count; i++) {
                parts = maps[i]->GetPlaceParts(parts_id);

                if (parts != NULL) {
                    break;
                }
            }

            break;
        case 2:
            parts_name = GetStackString(stack++);

            for (i = 0; i < map_count; i++) {
                parts = maps[i]->GetPlaceParts(parts_name);

                if (parts != NULL) {
                    break;
                }
            }

            break;
    }

    if (parts == NULL) {
        return 0;
    }

    switch (argc) {
        case 2:
            EventObjHandleMother.Set(slot, 1, parts, 1);
            break;
        case 3:
        case 4: {
            CMapPiece *piece;

            if ((piece = parts->SearchPiece(GetStackString(stack++))) == NULL) {
                return 0;
            }

            if (argc == 3) {
                EventObjHandleMother.Set(slot, 1, piece, 0);
            } else if (argc == 4) {
                char     *frame_name = GetStackString(stack);
                mgCFrame *root = piece->frame;

                if (root == NULL) {
                    return 0;
                }

                mgCFrame *frame = root->SearchFrame(frame_name);

                if (frame == NULL) {
                    return 0;
                }

                EventObjHandleMother.Set(slot, 3, frame);
            }

            break;
        }
        default:
            return 0;
    }

    return 1;
}

int _EOH_SYNC_EDIT_OBJ(RS_STACKDATA *stack, int argc) {
    int         slot;
    CEditMap   *edit_map;
    CEditParts *parts;
    int         parts_id;
    char       *parts_name;

    if (argc < 2 || argc > 4) {
        return 0;
    }

    edit_map = (CEditMap *) EventScene->GetMap(EventScene->active_map);
    slot = GetStackInt(stack++);

    switch (stack->type) {
        case 0:
            parts_id = GetStackInt(stack++);
            parts = edit_map->GetePlaceParts(parts_id);
            break;
        case 2:
            parts_name = GetStackString(stack++);
            parts = edit_map->GetePlaceParts(parts_name);
            break;
    }

    if (parts == NULL) {
        return 0;
    }

    switch (argc) {
        case 2:
            EventObjHandleMother.Set(slot, 1, parts, 1);
            break;
        case 3:
        case 4: {
            CMapPiece *piece;

            if ((piece = parts->SearchPiece(GetStackString(stack++))) == NULL) {
                return 0;
            }

            if (argc == 3) {
                EventObjHandleMother.Set(slot, 1, piece, 0);
            } else if (argc == 4) {
                char     *frame_name = GetStackString(stack);
                mgCFrame *root = piece->frame;

                if (root == NULL) {
                    return 0;
                }

                mgCFrame *frame = root->SearchFrame(frame_name);

                if (frame == NULL) {
                    return 0;
                }

                EventObjHandleMother.Set(slot, 3, frame);
            }

            break;
        }
        default:
            return 0;
    }

    return 1;
}

int _EOH_SYNC_SPRITE(RS_STACKDATA *stack, int argc) {
    CEventSprite2 *sprite;
    int            slot;

    slot = GetStackInt(stack++);
    sprite = GetEventSprite(GetStackInt(stack));

    if (sprite != NULL) {
        return EventObjHandleMother.Set(slot, 2, sprite);
    }

    return 0;
}

int _EOH_SET_POS(RS_STACKDATA *stack, int argc) {
    float     pos[4];
    int       slot;
    ARG_DATA *args;

    switch (argc) {
        case 1:
            args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            slot = GetArgInt(args++);
            GetArgVector(pos, args);
            break;
        case 4:
            slot = GetStackInt(stack++);
            GetStackVector(pos, stack);
            break;
        default:
            return 0;
    }

    return EventObjHandleMother.SetPos(slot, pos[0], pos[1], pos[2]);
}

int _EOH_SET_ROT(RS_STACKDATA *stack, int argc) {
    float     rot[4];
    int       slot;
    ARG_DATA *args;

    switch (argc) {
        case 1:
            args = FindArgData(GetStackInt(stack));

            if (args == NULL) {
                return 0;
            }

            slot = GetArgInt(args++);
            GetArgVector(rot, args);
            break;
        case 4:
            slot = GetStackInt(stack++);
            GetStackVector(rot, stack);
            break;
        default:
            return 0;
    }

    rot[0] = mgAngleLimit(rot[0]);
    rot[1] = mgAngleLimit(rot[1]);
    rot[2] = mgAngleLimit(rot[2]);
    return EventObjHandleMother.SetRot(slot, rot[0], rot[1], rot[2]);
}

/**
 * Writes an event object position to the script stack and returns the lookup status.
 */
int _EOH_GET_POS(RS_STACKDATA *stack, int argc) {
    float pos[3];

    int result = EventObjHandleMother.GetPos(GetStackInt(stack++), pos);

    if (result != 0) {
        SetStack(stack++, pos[0]);
        SetStack(stack++, pos[1]);
        SetStack(stack, pos[2]);
    }

    return result;
}

/**
 * Writes an event object rotation to the script stack and returns the lookup status.
 */
int _EOH_GET_ROT(RS_STACKDATA *stack, int argc) {
    float rot[3];

    int result = EventObjHandleMother.GetRot(GetStackInt(stack++), rot);

    if (result != 0) {
        SetStack(stack++, rot[0]);
        SetStack(stack++, rot[1]);
        SetStack(stack, rot[2]);
    }

    return result;
}

int _EOH_SET_MOTION(RS_STACKDATA *stack, int argc) {
    int   index;
    int   type = 0;
    float blend = -1.0f;
    char *name;

    switch (argc) {
        case 1: {
            ARG_DATA *args = FindArgData(GetStackInt(stack), argc);

            if (args == NULL) {
                return 0;
            }

            index = GetArgInt(args++);
            name = GetArgString(args++);

            if (argc >= 3) {
                type = GetArgInt(args++);
            }

            if (argc >= 4) {
                blend = GetArgFloat(args);
            }

            break;
        }
        case 2:
        case 3:
        case 4:
            index = GetStackInt(stack++);
            name = GetStackString(stack++);

            if (argc >= 3) {
                type = GetStackInt(stack++);
            }

            if (argc >= 4) {
                blend = GetStackFloat(stack);
            }

            break;
        default:
            return 0;
    }

    return EventObjHandleMother.SetMotion(index, name, type, blend);
}

/**
 * Sets an event object motion step and returns the update status.
 */
int _EOH_SET_STEP(RS_STACKDATA *stack, int argc) {
    argc = GetStackInt(stack++);
    return EventObjHandleMother.SetStep(argc, GetStackFloat(stack));
}
int _EOH_SET_TEX_ANIM(RS_STACKDATA *stack, int argc) {
    int no = GetStackInt(stack);
    switch (stack[1].type) {
        case RS_INT:
            if (argc == 2) {
                return EventObjHandleMother.SetTexAnim(no, 0, NULL);
            }
            if (argc == 3) {
                int result = EventObjHandleMother.SetTexAnim(no, GetStackInt(stack + 1), GetStackString(stack + 2));
                return result;
            }
            return 0;
        case RS_STR: {
            if (argc == 2) {
                return EventObjHandleMother.SetTexAnim(no, 1, GetStackString(stack + 1));
            }
            char *offName = GetStackString(stack + 1);
            char *onName = GetStackString(stack + 2);
            return EventObjHandleMother.SetTexAnim(no, 0, offName) ? EventObjHandleMother.SetTexAnim(no, 1, onName) : 0;
        }
    }
    return 0;
}
int _EOH_SET_SCALE(RS_STACKDATA *stack, int argc) {
    int   no = GetStackInt(stack++);
    float x = GetStackFloat(stack++);
    float y = GetStackFloat(stack++);
    float z = GetStackFloat(stack);
    return EventObjHandleMother.SetScale(no, x, y, z);
}

/**
 * Sets an event object visibility and returns the update status.
 */
int _EOH_SET_SHOW(RS_STACKDATA *stack, int argc) {
    int slot;

    slot = GetStackInt(stack++);
    return EventObjHandleMother.SetShow(slot, GetStackInt(stack));
}

/**
 * Writes an event object visibility to the script stack and returns the lookup status.
 */
int _EOH_GET_SHOW(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *next_slot;

    next_slot = stack + 1;

    int show;

    int result = EventObjHandleMother.GetShow(GetStackInt(stack), &show);

    if (result != 0) {
        SetStack(next_slot, show);
    }

    return result;
}

/**
 * Sets an event object frame visibility and returns the update status.
 */
int _EOH_SET_FRAME_SHOW(RS_STACKDATA *stack, int argc) {
    int   slot;
    char *frame_name;

    slot = GetStackInt(stack++);
    frame_name = GetStackString(stack++);
    return EventObjHandleMother.SetFrameShow(slot, frame_name, GetStackInt(stack) != 0 ? 1 : 0);
}

/**
 * Sets an event object shadow and returns the update status.
 */
int _EOH_SET_SHADOW(RS_STACKDATA *stack, int argc) {
    int slot;

    slot = GetStackInt(stack++);
    return EventObjHandleMother.SetShadow(slot, GetStackInt(stack));
}

int _EOH_SET_TRANSLATE(RS_STACKDATA *stack, int argc) {
    float translate[4];
    int   no = GetStackInt(stack++);
    translate[0] = GetStackFloat(stack++);
    translate[1] = GetStackFloat(stack++);
    translate[2] = GetStackFloat(stack);
    translate[3] = 1.0f;
    return EventObjHandleMother.SetTranslate(no, translate);
}

/**
 * Sets an event object footstep sound identifier and returns the update status.
 */
int _EOH_SET_FOOT_SOUND_ID(RS_STACKDATA *stack, int argc) {
    int slot;

    slot = GetStackInt(stack++);
    return EventObjHandleMother.SetFootSoundID(slot, GetStackInt(stack));
}

/**
 * Sets an event object frame visibility and returns the update status.
 */
int _EOH_SET_FRAME_STATUS(RS_STACKDATA *stack, int argc) {
    int   slot;
    char *frame_name;

    slot = GetStackInt(stack++);
    frame_name = GetStackString(stack++);
    return EventObjHandleMother.SetFrameShow(slot, frame_name, GetStackInt(stack));
}

/**
 * Writes an event object frame position to the script stack and returns the lookup status.
 */
int _EOH_GET_FRAME_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];
    int   no = GetStackInt(stack++);
    char *name = GetStackString(stack++);

    int result = EventObjHandleMother.GetFramePos(no, name, pos);

    if (result != 0) {
        SetStack(stack++, pos[0]);
        SetStack(stack++, pos[1]);
        SetStack(stack, pos[2]);
    }

    return result;
}

/**
 * Sets an event object sound identifier and returns the update status.
 */
int _EOH_SET_SOUND_ID(RS_STACKDATA *stack, int argc) {
    int slot;

    slot = GetStackInt(stack++);
    return EventObjHandleMother.SetSoundID(slot, GetStackInt(stack));
}

int _EOH_GET_FRAME_STATUS(RS_STACKDATA *stack, int argc) {
    int   no = GetStackInt(stack++);
    char *name = GetStackString(stack++);
    SetStack(stack, EventObjHandleMother.GetFrameShow(no, name));
    return 1;
}

int _EOH_SYNC_CHROBJ(RS_STACKDATA *stack, int argc) {
    int          slot = GetStackInt(stack++);
    int          chara_no = GetStackInt(stack++);
    char        *name = GetStackString(stack);
    CCharacter2 *chara = GetChara(chara_no);

    if (chara == NULL) {
        return 0;
    }

    if (chara->CObjectFrame::frame == NULL) {
        return 0;
    }

    mgCFrame *frame;

    if ((frame = chara->CObjectFrame::frame->SearchFrame(name)) == NULL) {
        return 0;
    }

    frame->SetRotType(2);
    return EventObjHandleMother.Set(slot, 3, frame);
}

/**
 * Sets an event object fade flag and returns the update status.
 */
int _EOH_SET_FADE_FLAG(RS_STACKDATA *stack, int argc) {
    int slot;

    slot = GetStackInt(stack++);
    return EventObjHandleMother.SetFadeFlag(slot, GetStackInt(stack));
}

/**
 * Resets an event object animation position and returns the update status.
 */
int _EOH_RESET_DA_POSITION(RS_STACKDATA *stack, int argc) {
    return EventObjHandleMother.ResetDAPosition(GetStackInt(stack));
}

/**
 * Sets an event object shadow frame visibility and returns the update status.
 */
int _EOH_SET_SHADOW_FRAME_STATUS(RS_STACKDATA *stack, int argc) {
    int   slot;
    char *frame_name;

    slot = GetStackInt(stack++);
    frame_name = GetStackString(stack++);
    return EventObjHandleMother.SetShadowFrameShow(slot, frame_name, GetStackInt(stack));
}

/**
 * Attaches an event handle to a geostone and returns the update status.
 */
int _EOH_SYNC_GEOSTONE(RS_STACKDATA *stack, int argc) {
    return EventObjHandleMother.Set(GetStackInt(stack), 0, -1, &GeoStone);
}

int _EOH_SYNC_SEARCH_CHARA(RS_STACKDATA *stack, int argc) {
    int           slot;
    char         *name;
    CActionChara *player;

    slot = GetStackInt(stack++);
    GetStackInt(stack++);
    name = GetStackString(stack);
    player = (CActionChara *) GetCharacter(0);

    if (player == NULL) {
        return 0;
    }

    return EventObjHandleMother.Set(slot, 0, -1, player->SearchChara(name));
}

/**
 * Updates an event character and returns the update status.
 */
int _EOH_NORMAL_DRIVE(RS_STACKDATA *stack, int argc) {
    return EventObjHandleMother.NormalDrive(GetStackInt(stack));
}

int _EOH_SET_FRAME_ALPHA(RS_STACKDATA *stack, int argc) {
    int   no = GetStackInt(stack++);
    char *name = GetStackString(stack++);
    float alpha = GetStackFloat(stack);
    return EventObjHandleMother.SetFrameObjAlpha(no, name, alpha);
}

int _EOH_SYNC_FUNCP(RS_STACKDATA *stack, int argc) {
    int         slot;
    CFuncPoint *func_point;
    CMap       *map;
    map = EventScene->GetMap(EventScene->active_map);

    if (map == NULL) {
        return 0;
    }

    slot = GetStackInt(stack++);

    switch (stack->type) {
        case RS_INT: {
            int        parts_no = GetStackInt(stack++);
            char      *name = GetStackString(stack++);
            CMapParts *parts = map->GetPlaceParts(parts_no);

            if (parts == NULL) {
                return 0;
            }

            func_point = parts->func_point_mngr.Search(name);
            break;
        }
        case RS_STR: {
            char *place_name = GetStackString(stack++);
            char *name = GetStackString(stack++);

            if (strcmp(place_name, "") != 0) {
                CMapParts *parts = map->GetPlaceParts(place_name);

                if (parts == NULL) {
                    return 0;
                }

                func_point = parts->func_point_mngr.Search(name);
            } else {
                func_point = map->func_point.Search(name);
            }

            break;
        }
    }

    if (func_point != NULL) {
        return EventObjHandleMother.Set(slot, 4, func_point);
    }

    return 0;
}

/**
 * Sets an event object footstep effect identifier and returns the update status.
 */
int _EOH_SET_FOOT_SE_ID(RS_STACKDATA *stack, int argc) {
    int slot;

    slot = GetStackInt(stack++);
    return EventObjHandleMother.SetFootSeId(slot, GetStackInt(stack));
}

int _EOH_SYNC_DOOR_PARTS(RS_STACKDATA *stack, int argc) {
    int        slot;
    int        result;
    CMapParts *door;

    if (argc != 2) {
        return 0;
    }

    result = 0;
    slot = GetStackInt(stack++);

    if ((door = AutoMapGen.SearchDoorParts()) != NULL) {
        if (EventObjHandleMother.Set(slot, 1, door, 1) != 0) {
            result = 1;
        }
    }

    SetStack(stack, result);
    return 1;
}

int _SPHIDA_INIT(RS_STACKDATA *stack, int argc) {
    InitSphida();
    return 1;
}

int _SPHIDA_SET_UP(RS_STACKDATA *stack, int argc) {
    CSphida      *sphida;
    mgCMemory    *memory;
    int           param;
    int           kind;
    RS_STACKDATA *ptr;
    int           slot;

    ptr = stack;
    kind = 0;
    slot = GetStackInt(ptr++);
    param = GetStackInt(ptr++);

    if (argc >= 3) {
        kind = GetStackInt(ptr++);
    }

    memory = EventScene->GetStack(slot);

    if (memory == NULL) {
        return 0;
    }

    sphida = new (memory->Alloc((sizeof(CSphida) + 15) / 16 + 2)) CSphida;
    Sphida = sphida;

    if (sphida == NULL) {
        return 0;
    }

    sphida->Initialize();

    switch (kind) {
        case 0:
            Sphida->SetUp(param);
            break;
        case 1:
            Sphida->s17_SetUp(param);
            break;
        case 2:
            Sphida->Omake_SetUp(GetStackInt(ptr), param);
            break;
    }

    return 1;
}

int _SPHIDA_SET_PLAY_FLAG(RS_STACKDATA *stack, int argc) {
    int flag;

    flag = GetStackInt(stack);

    if (Sphida == NULL) {
        return 0;
    }

    Sphida->play_flag = flag;
    return 1;
}

int _SPHIDA_SET_MINIMAP_FLAG(RS_STACKDATA *stack, int argc) {
    int flag;

    flag = GetStackInt(stack);

    if (Sphida == NULL) {
        return 0;
    }

    Sphida->minimap_flag = flag;
    return 1;
}

int _SPHIDA_SET_MM_LINE_FLAG(RS_STACKDATA *stack, int argc) {
    int flag;

    flag = GetStackInt(stack);

    if (Sphida == NULL) {
        return 0;
    }

    Sphida->mm_line_flag = flag;
    return 1;
}

int _SPHIDA_SET_MM_LINE_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];
    int   index = GetStackInt(stack++);
    GetStackVector(pos, stack);

    if (Sphida == NULL) {
        return 0;
    }

    if (index < 5) {
        sceVu0CopyVector(Sphida->mm_line_pos[index], pos);
    }

    return 1;
}

int _SPHIDA_SET_PIN_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];
    pos[0] = GetStackFloat(stack++);
    pos[1] = GetStackFloat(stack++);
    pos[2] = GetStackFloat(stack);
    pos[3] = 1.0f;

    if (Sphida == NULL) {
        return 0;
    }

    sceVu0CopyVector(Sphida->pin_pos, pos);
    return 1;
}

int _SPHIDA_GET_PIN_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];

    if (Sphida == NULL) {
        return 0;
    }

    sceVu0CopyVector(pos, Sphida->pin_pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

int _SPHIDA_SET_BALL_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];
    pos[0] = GetStackFloat(stack++);
    pos[1] = GetStackFloat(stack++);
    pos[2] = GetStackFloat(stack);
    pos[3] = 1.0f;

    if (Sphida == NULL) {
        return 0;
    }

    sceVu0CopyVector(Sphida->ball_pos, pos);
    return 1;
}

int _SPHIDA_GET_BALL_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];

    if (Sphida == NULL) {
        return 0;
    }

    sceVu0CopyVector(pos, Sphida->ball_pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

int _SPHIDA_SET_PIN_COL(RS_STACKDATA *stack, int argc) {
    int color;

    color = GetStackInt(stack);

    if (Sphida == NULL) {
        return 0;
    }

    Sphida->pin_col = color;
    return 1;
}

int _SPHIDA_GET_PIN_COL(RS_STACKDATA *stack, int argc) {
    if (Sphida == NULL) {
        return 0;
    }

    SetStack(stack, Sphida->pin_col);
    return 1;
}

int _SPHIDA_SET_BALL_COL(RS_STACKDATA *stack, int argc) {
    int color;

    color = GetStackInt(stack);

    if (Sphida == NULL) {
        return 0;
    }

    Sphida->ball_col = color;
    return 1;
}

int _SPHIDA_GET_BALL_COL(RS_STACKDATA *stack, int argc) {
    if (Sphida == NULL) {
        return 0;
    }

    SetStack(stack, Sphida->ball_col);
    return 1;
}

int _SPHIDA_SET_PAR_COUNT(RS_STACKDATA *stack, int argc) {
    int par_count;

    par_count = GetStackInt(stack);

    if (Sphida == NULL) {
        return 0;
    }

    if (DebugFlag == 0) {
        Sphida->par_count = par_count;
    }

    return 1;
}

int _SPHIDA_GET_PAR_COUNT(RS_STACKDATA *stack, int argc) {
    if (Sphida == NULL) {
        return 0;
    }

    int count;

    if (DebugFlag != 0) {
        count = Sphida->par_count + 1;
    } else {
        count = Sphida->par_count;
    }

    SetStack(stack, count);
    return 1;
}

int _SPHIDA_GET_MINI_LEVEL(RS_STACKDATA *stack, int argc) {
    if (Sphida == NULL) {
        return 0;
    }

    SetStack(stack, Sphida->mini_level);
    return 1;
}

int _SPHIDA_GET_TEXB(RS_STACKDATA *stack, int argc) {
    if (Sphida == NULL) {
        return 0;
    }

    SetStack(stack, Sphida->tex_bank);
    return 1;
}

int _SPHIDA_SET_STATUS_FLAG(RS_STACKDATA *stack, int argc) {
    int flag;

    flag = GetStackInt(stack);

    if (Sphida == NULL) {
        return 0;
    }

    Sphida->status_flag = flag;
    return 1;
}

int _SPHIDA_RESET_POWGAGE(RS_STACKDATA *stack, int argc) {
    if (Sphida == 0) {
        return 0;
    }

    CSphida *sphida = Sphida;
    sphida->pow_gage.state = -1;
    sphida->pow_gage.reverse = 0;
    sphida->pow_gage.count = 0;
    sphida->pow_gage.power = 0;
    sphida->pow_gage.code = -10;
    return 1;
}

int _SPHIDA_START_POWGAGE(RS_STACKDATA *stack, int argc) {
    if (Sphida == NULL) {
        return 0;
    }

    Sphida->pow_gage.state = 0;
    return 1;
}

int _SPHIDA_TRIGGER_POWGAGE(RS_STACKDATA *stack, int argc) {

    CSphida *sphida = Sphida;

    if (sphida == NULL) {
        return 0;
    }

    switch (sphida->pow_gage.state) {
        case 1:
            sphida->pow_gage.state = 2;
            break;
        case 3:
            sphida->pow_gage.state = 4;
            break;
    }

    return 1;
}

int _SPHIDA_GET_SHOT_POW(RS_STACKDATA *stack, int argc) {
    if (Sphida == NULL) {
        return 0;
    }

    SetStack(stack, Sphida->pow_gage.power);
    return 1;
}

int _SPHIDA_GET_POWGAGE_CODE(RS_STACKDATA *stack, int argc) {
    if (Sphida == NULL) {
        return 0;
    }

    SetStack(stack, Sphida->pow_gage.code);
    return 1;
}

int _SPHIDA_SET_POWGAGE_SAFE_LEVEL(RS_STACKDATA *stack, int argc) {
    int level;

    level = GetStackInt(stack);

    if (Sphida == NULL) {
        return 0;
    }

    if (level <= 0) {
        level = 1;
    }

    if (level > 6) {
        level = 6;
    }

    Sphida->pow_gage.safe_level = level;
    return 1;
}

int _SPHIDA_GET_CULB_DEF(RS_STACKDATA *stack, int argc) {
    GOLF_CLUB_DEF *club = GetSphidaClubDef(GetStackInt(stack++));

    if (club == NULL) {
        return 0;
    }

    SetStack(stack++, club->power);
    SetStack(stack++, club->unk_4);
    SetStack(stack, club->unk_8);
    return 1;
}

int _SPHIDA_SET_SPIN_MARK_POS(RS_STACKDATA *stack, int argc) {
    float    x = GetStackFloat(stack++);
    float    y = GetStackFloat(stack);
    CSphida *sphida = Sphida;

    if (sphida == NULL) {
        return 0;
    }

    sphida->spin_mark_pos_x = x;
    sphida->spin_mark_pos_y = y;
    return 1;
}

int _SPHIDA_SET_CULB_NO(RS_STACKDATA *stack, int argc) {
    int club_no;

    club_no = GetStackInt(stack);

    if (Sphida == NULL) {
        return 0;
    }

    Sphida->club_no = club_no;
    return 1;
}

int _SPHIDA_CALC_CARRY(RS_STACKDATA *stack, int argc) {
    float carry = GetStackFloat(stack);

    if (Sphida == NULL) {
        return 0;
    }

    Sphida->carry = carry;
    return 1;
}

int _SPHIDA_GET_PG_CURSOR_POS(RS_STACKDATA *stack, int argc) {
    if (Sphida == NULL) {
        return 0;
    }

    float x = 104.0f + Sphida->pow_gage.pos_x - 6.5f * (float) Sphida->pow_gage.count;
    float y = Sphida->pow_gage.pos_y - 32.0f;
    SetStack(stack++, x);
    SetStack(stack, y);
    return 1;
}

int _SPHIDA_SET_COL_MODEL(RS_STACKDATA *stack, int argc) {
    if (Sphida == NULL) {
        return 0;
    }

    int        stack_no = GetStackInt(stack++);
    char      *name = GetStackString(stack);
    mgCMemory *memory = EventScene->GetStack(stack_no);

    if (memory == NULL) {
        return 0;
    }

    MDS_HEADER *model = (MDS_HEADER *) GetLoadBGBuff(name, NULL);

    if (model != NULL) {
        return Sphida->SetCollisionModel(model, memory);
    }

    return 0;
}

int _SPHIDA_GET_PRIZE(RS_STACKDATA *stack, int argc) {
    int               prize1;
    int               prize2;
    CDngFloorManager *floor_manager;
    RS_STACKDATA     *next_slot;
    DNG_BATTLE_AREA  *dng_scene;

    dng_scene = &EventScene->battle_area;
    floor_manager = &dng_scene->floor_manager;

    if (dng_scene == 0) {
        return 0;
    }

    next_slot = stack + 1;

    if (floor_manager == NULL) {
        return 0;
    }

    floor_manager->GetSphedaPrize(GetStackInt(stack), &prize1, &prize2);
    SetStack(next_slot++, prize1);
    SetStack(next_slot, prize2);
    return 1;
}

int _SPHIDA_SET_LAST_CHALLENGE(RS_STACKDATA *stack, int argc) {
    if (Sphida == NULL) {
        return 0;
    }

    Sphida->last_challenge = GetStackInt(stack);
    return 1;
}

int _SPHIDA_GET_LAST_CHALLENGE(RS_STACKDATA *stack, int argc) {
    if (Sphida == NULL || argc != 1) {
        return 0;
    }

    SetStack(stack, Sphida->last_challenge);

    return 1;
}

int _SPHIDA_GET_OMAKE_MODE(RS_STACKDATA *stack, int argc) {
    if (Sphida == NULL || argc != 1) {
        return 0;
    }

    SetStack(stack, Sphida->omake_mode);

    return 1;
}

int _SPHIDA_SET_NOW_HOLE(RS_STACKDATA *stack, int argc) {
    CSubGameData *sub_game = GetSubGameSaveData();

    if (sub_game == NULL) {
        return 0;
    }

    CSphidaData *sphida_data;

    if ((sphida_data = sub_game->GetSphidaData()) == NULL) {
        return 0;
    }

    sphida_data->SetHorl(GetStackInt(stack));
    return 1;
}

int _SPHIDA_GET_NOW_HOLE(RS_STACKDATA *stack, int argc) {
    CSphidaData  *sphida_data;
    CSubGameData *sub_game;

    if (argc != 1) {
        return 0;
    }

    sub_game = GetSubGameSaveData();

    if (sub_game == NULL) {
        return 0;
    }

    sphida_data = sub_game->GetSphidaData();

    if (sphida_data == NULL) {
        return 0;
    }

    SetStack(stack, sphida_data->GetNowHorl());
    return 1;
}

int _SPHIDA_SET_SCORE(RS_STACKDATA *stack, int argc) {
    CSubGameData *sub_game = GetSubGameSaveData();

    if (sub_game == NULL) {
        return 0;
    }

    CSphidaData *sphida_data;

    if ((sphida_data = sub_game->GetSphidaData()) == NULL) {
        return 0;
    }

    int slot = GetStackInt(stack++);
    int score = GetStackInt(stack);
    sphida_data->SetHorlScore(score, slot);
    return 1;
}

int _SPHIDA_GET_SCORE(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    CSubGameData *sub_game = GetSubGameSaveData();

    if (sub_game == NULL) {
        return 0;
    }

    CSphidaData *sphida_data;

    if ((sphida_data = sub_game->GetSphidaData()) == NULL) {
        return 0;
    }

    int slot = GetStackInt(stack++);
    SetStack(stack, sphida_data->GetHorlScore(slot));
    return 1;
}

int _TEST(RS_STACKDATA *stack, int argc) {
    return 1;
}

/**
 * Returns the intersection test routine's script command status.
 */
int _MT_TEST(RS_STACKDATA *stack, int argc) {
    return mt_test(stack, argc);
}

int _ZERO_VECTOR(RS_STACKDATA *stack, int arg_count) {
    SetStack(stack++, 0.0f);
    SetStack(stack++, 0.0f);
    SetStack(stack, 0.0f);
    return 1;
}

static int _NORMAL_VECTOR(RS_STACKDATA *stack, int argc) {
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

static int _COPY_VECTOR(RS_STACKDATA *stack, int argc) {
    float vector[4];
    GetStackVector(vector, stack + 3);
    SetStack(stack++, vector[0]);
    SetStack(stack++, vector[1]);
    SetStack(stack, vector[2]);
    return 1;
}

static int _ADD_VECTOR(RS_STACKDATA *stack, int argc) {
    float operand[4];
    GetStackVector(operand, stack + 3);
    SetStack(stack, stack[0].val.p->val.f + operand[0]);
    SetStack(stack + 1, stack[1].val.p->val.f + operand[1]);
    SetStack(stack + 2, stack[2].val.p->val.f + operand[2]);
    return 1;
}

static int _SUB_VECTOR(RS_STACKDATA *stack, int argc) {
    float operand[4];
    GetStackVector(operand, stack + 3);
    SetStack(stack, stack[0].val.p->val.f - operand[0]);
    SetStack(stack + 1, stack[1].val.p->val.f - operand[1]);
    SetStack(stack + 2, stack[2].val.p->val.f - operand[2]);
    return 1;
}

static int _SCALE_VECTOR(RS_STACKDATA *stack, int argc) {
    float scale = GetStackFloat(stack + 3);
    SetStack(stack, stack[0].val.p->val.f * scale);
    SetStack(stack + 1, stack[1].val.p->val.f * scale);
    SetStack(stack + 2, stack[2].val.p->val.f * scale);
    return 1;
}

static int _DIV_VECTOR(RS_STACKDATA *stack, int argc) {
    float divisor = GetStackFloat(stack + 3);

    if (divisor == 0.0f) {
        return 0;
    }

    SetStack(stack, stack[0].val.p->val.f / divisor);
    SetStack(stack + 1, stack[1].val.p->val.f / divisor);
    SetStack(stack + 2, stack[2].val.p->val.f / divisor);
    return 1;
}

static int _DIST_VECTOR(RS_STACKDATA *stack, int argc) {
    float vec[4];
    GetStackVector(vec, stack);

    stack = (RS_STACKDATA *) ((int) stack + 0x18);
    SetStack(stack, mgDistVector(vec));
    return 1;
}

static int _DIST_VECTOR2(RS_STACKDATA *stack, int argc) {
    float from[4];
    float to[4];
    GetStackVector(from, stack);
    GetStackVector(to, stack + 3);

    stack = (RS_STACKDATA *) ((int) stack + 0x30);
    SetStack(stack, mgDistVector(from, to));
    return 1;
}

static int _SQRT(RS_STACKDATA *stack, int argc) {
    float value = GetStackFloat(stack++);
    SetStack(stack, (float) sqrt(value));
    return 1;
}

static int _ATAN2F(RS_STACKDATA *stack, int argc) {
    float y = GetStackFloat(stack++);
    float x = GetStackFloat(stack++);
    SetStack(stack, atan2f(y, x));
    return 1;
}

static int _ANGLE_CMP(RS_STACKDATA *stack, int argc) {
    float a = GetStackFloat(stack++);
    float b = GetStackFloat(stack++);
    float tolerance = GetStackFloat(stack++);
    SetStack(stack, mgAngleCmp(a, b, tolerance));
    return 1;
}

static int _ANGLE_LIMIT(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *angle = stack->val.p;
    SetStack(stack, mgAngleLimit(angle->val.f));
    return 1;
}

static int _GET_RAND(RS_STACKDATA *stack, int argc) {
    int int_range;

    if (stack->type == 1) {
        float range = GetStackFloat(stack++);
        SetStack(stack, range * (float) rand() / 2147483648.0f);
    } else {
        int_range = GetStackInt(stack++);
        argc = (int) ((float) int_range * (float) rand() / 2147483648.0f);
        SetStack(stack, argc);
    }

    return 1;
}
int _LINE_POINT_DIST(RS_STACKDATA *stack, int argc) {
    float segmentStart[4];
    float segmentEnd[4];
    float point[4];
    float toPoint[4];
    float direction[4];
    float segmentLength;
    float projection;
    GetStackVector(segmentStart, stack);
    GetStackVector(segmentEnd, stack + 3);
    GetStackVector(point, stack + 6);
    RS_STACKDATA *result = stack += 9;
    segmentLength = mgDistVector(segmentStart, segmentEnd);
    sceVu0SubVector(toPoint, point, segmentStart);
    sceVu0SubVector(direction, segmentEnd, segmentStart);
    sceVu0Normalize(direction, direction);
    projection = sceVu0InnerProduct(toPoint, direction);
    if (projection < 0.0f || projection > segmentLength) {
        SetStack(result, -1.0f);
        return 1;
    }
    sceVu0ScaleVector(direction, direction, projection);
    sceVu0AddVector(direction, segmentStart, direction);
    SetStack(result, mgDistVector(point, direction));
    return 1;
}
int _CREATE_SWORD_EFFECT(RS_STACKDATA *stack, int argc) {
    int               stack_no = GetStackInt(stack++);
    int               init_param1 = GetStackInt(stack++);
    int               init_param2 = GetStackInt(stack);
    mgCMemory        *scene_stack;
    CSWordAfterImage *effect;
    scene_stack = (mgCMemory *) EventScene->GetStack(stack_no);

    if (scene_stack == NULL) {
        return 0;
    }

    effect = new (scene_stack->Alloc((sizeof(CSWordAfterImage) + 15) / 16 + 2)) CSWordAfterImage;

    if (effect != NULL) {
        effect->edge_color[0] = 0x80;
        effect->edge_color[1] = 0x80;
        effect->edge_color[2] = 0x80;
        effect->edge_color[3] = 0x80;
        effect->back_color[0] = 0x80;
        effect->back_color[1] = 0x80;
        effect->back_color[2] = 0x80;
        effect->back_color[3] = 0x80;
    }

    SwordEffect = effect;

    if (SwordEffect == NULL) {
        return 0;
    }

    SwordEffect->Initialize(scene_stack, init_param1, init_param2);
    return 1;
}

int _DELETE_SWORD_EFFECT(RS_STACKDATA *stack, int argc) {
    SwordEffect = 0;
    return 1;
}

int _SWORD_EFFECT_COLOR(RS_STACKDATA *stack, int argc) {
    if (SwordEffect == 0) {
        return 0;
    }

    int               a_r = GetStackInt(stack++);
    int               a_g = GetStackInt(stack++);
    int               a_b = GetStackInt(stack++);
    int               a_a = GetStackInt(stack++);
    int               b_r = GetStackInt(stack++);
    int               b_g = GetStackInt(stack++);
    int               b_b = GetStackInt(stack++);
    int               b_a = GetStackInt(stack);
    CSWordAfterImage *effect = SwordEffect;
    effect->edge_color[0] = a_r;
    effect->edge_color[1] = a_g;
    effect->edge_color[2] = a_b;
    effect->edge_color[3] = a_a;
    effect->back_color[0] = b_r;
    effect->back_color[1] = b_g;
    effect->back_color[2] = b_b;
    effect->back_color[3] = b_a;
    return 1;
}

int _SWORD_EFFECT_ADD_POINT(RS_STACKDATA *stack, int argc) {
    float edge[4];
    float back[4];
    float life;

    if (SwordEffect == NULL) {
        return 1;
    }

    life = 1.0f;
    GetStackVector(edge, stack);
    stack = &stack[3];
    GetStackVector(back, stack);
    stack += 3;

    if (argc >= 7) {
        life = GetStackFloat(stack++);
    }

    SwordEffect->AddPoint(edge, back, life);
    return 1;
}

int _ADD_CHARA_POS(RS_STACKDATA *stack, int argc) {
    float offset[4];
    float pos[4];
    int   chara_no = GetStackInt(stack++);
    GetStackVector(offset, stack);
    CCharacter2 *chara;

    if ((chara = GetCharacter(chara_no)) == NULL) {
        return 0;
    }

    chara->GetPosition(pos);
    sceVu0AddVector(pos, pos, offset);
    chara->SetPosition(pos);
    return 1;
}

int _ADD_CHARA_ROT(RS_STACKDATA *stack, int argc) {
    float offset[4];
    float rot[4];
    int   chara_no = GetStackInt(stack++);
    GetStackVector(offset, stack);
    CCharacter2 *chara;

    if ((chara = GetCharacter(chara_no)) == NULL) {
        return 0;
    }

    chara->GetRotation(rot);
    sceVu0AddVector(rot, rot, offset);
    rot[0] = mgAngleLimit(rot[0]);
    rot[1] = mgAngleLimit(rot[1]);
    rot[2] = mgAngleLimit(rot[2]);
    rot[3] = 1.0f;
    chara->SetRotation(rot);
    return 1;
}

int _POST_TREASURE_BOX(RS_STACKDATA *stack, int argc) {
    float                position[3];
    CTreasureBoxManager *chest_manager;
    float                angle;
    int                  kind;
    int                  count;
    DNG_BATTLE_AREA     *dng_scene;

    count = 1;
    GetStackVector(position, stack);
    stack += 3;
    angle = GetStackFloat(stack++);
    kind = GetStackInt(stack++);

    if (argc >= 6) {
        count = GetStackInt(stack);
    }

    dng_scene = &EventScene->battle_area;

    if (dng_scene == NULL) {
        return 0;
    }

    chest_manager = dng_scene->treasure_box;

    if (chest_manager == NULL) {
        return 0;
    }

    chest_manager->PutTreasureBox(-1, position, angle, 0x41, kind, count, -1, 0);
    return 1;
}

int _GET_PARTS_ORIGIN(RS_STACKDATA *stack, int argc) {
    float      center[4];
    CMapParts *parts[8];
    mgVu0FBOX  box;
    float      origin[4];
    float      pos[4];
    float      nearest;
    CMap      *map;
    int        count;
    int        i;
    center[0] = GetStackFloat(stack++);
    center[1] = GetStackFloat(stack++);
    center[2] = GetStackFloat(stack++);
    center[3] = GetStackFloat(stack++);
    map = EventScene->GetMap(EventScene->active_map);

    if (map == NULL) {
        return 0;
    }

    box.max[0] = center[3] + center[0];
    box.min[0] = center[0] - center[3];
    box.max[1] = center[3] + center[1];
    box.min[1] = center[1] - center[3];
    box.max[2] = center[3] + center[2];
    box.min[2] = center[2] - center[3];
    box.max[3] = 1.0f;
    box.min[3] = 1.0f;
    count = map->GetPlaceParts(&box, parts, 8);

    if (count <= 0) {
        return 0;
    }

    origin[0] = 0.0f;
    origin[1] = 0.0f;
    origin[2] = 0.0f;
    nearest = 1000000.0f;
    origin[3] = 0.0f;

    for (i = 0; i < count; i++) {
        parts[i]->GetPosition(pos);
        float dist = mgDistVector(center, pos);

        if (dist < nearest) {
            nearest = dist;
            *(u_long128 *) origin = *(u_long128 *) pos;
        }
    }

    SetStack(stack++, origin[0]);
    SetStack(stack++, origin[1]);
    SetStack(stack, origin[2]);
    return 1;
}

int _CTRLC_STEP(RS_STACKDATA *stack, int argc) {
    CCameraControl *p = GetCamera();
    p->Step(1);
    return 1;
}

int _CTRLC_SET_ROTATE(RS_STACKDATA *stack, int argc) {
    float angle = GetStackFloat(stack);
    GetCamera()->SetRotate(angle);
    return 1;
}

int _CTRLC_ROT_BACK(RS_STACKDATA *stack, int argc) {
    float angle = GetStackFloat(stack);
    GetCamera()->RotBack(angle);
    return 1;
}

int _CTRLC_MOVE_CAMERA(RS_STACKDATA *stack, int argc) {
    float           chara_pos[4];
    CCPoly          polys[256];
    mgVu0FBOX       box;
    float           camera_ref[4];
    CCharacter2    *chara;
    CCameraControl *camera;
    CMap           *map;
    int             poly_count;
    float           distance;

    if ((chara = GetCharacter(GetStackInt(stack))) == NULL) {
        return 0;
    }

    chara->GetRotation(chara_pos);
    camera = GetCamera();
    distance = camera->GetDistance();
    map = EventScene->GetMap(EventScene->active_map);
    camera->GetRef(camera_ref);
    camera->SetCheckRef(camera_ref);
    box.max[0] = camera_ref[0] + 1.2f * distance;
    box.min[0] = camera_ref[0] - 1.2f * distance;
    box.max[1] = camera_ref[1] + 1.2f * distance;
    box.min[1] = camera_ref[1] - 1.2f * distance;
    box.max[2] = camera_ref[2] + 1.2f * distance;
    box.min[2] = camera_ref[2] - 1.2f * distance;
    box.max[3] = 1.0f;
    box.min[3] = 1.0f;
    poly_count = map->GetCameraPoly(polys, box, 0x100);

    if (poly_count < 0) {
        return 0;
    }

    if (poly_count > 0x100) {
        printf("EVENT ERROR <CTRLC_MOVE_CAMERA camera poly over %d>\n", poly_count);
        return 0;
    }

    camera->MoveCamera(&PadCtrl, chara_pos, polys, poly_count);
    return 1;
}

int _CTRLC_SET_ROT_CANCEL(RS_STACKDATA *stack, int argc) {
    int mask;

    mask = GetStackInt(stack);
    GetCamera()->SetRotCameraCancel(mask);
    return 1;
}

int _CTRLC_MOVE_RANGE(RS_STACKDATA *stack, int argc) {
    CameraCtrlParam *param = GetCamera()->GetActiveParam();
    param->near_height = GetStackFloat(stack++);
    param->far_height = GetStackFloat(stack++);
    param->min_dist = GetStackFloat(stack++);
    param->max_dist = GetStackFloat(stack);
    return 1;
}

int _GET_NEAR_TBOX_POS(RS_STACKDATA *stack, int argc) {
    float                target[4];
    float                box_pos[4];
    DNG_BATTLE_AREA     *dng_scene;
    int                  nearest;
    int                  i;
    CTreasureBoxManager *box_manager;
    float                nearest_dist;
    float                dist;
    CTreasureBox        *box;

    dng_scene = &EventScene->battle_area;

    if (dng_scene == NULL) {
        return 0;
    }

    box_manager = dng_scene->treasure_box;

    if (box_manager == NULL) {
        return 0;
    }

    nearest = -1;
    GetStackVector(target, stack);

    stack += 3;
    nearest_dist = 9999.0f;

    for (i = 0; i < TREASURE_BOX_MAX; i++) {
        box = &box_manager->box[i];

        if (box != NULL && (box == NULL || box->state != 0)) {
            box->GetPosition(box_pos);
            dist = mgDistVector(box_pos, target);

            if (dist < 30.0f && !(nearest_dist <= dist)) {
                nearest_dist = dist;
                nearest = i;
            }
        }
    }

    box_pos[0] = 0.0f;
    box_pos[1] = 0.0f;
    box_pos[2] = 0.0f;
    box_pos[3] = 0.0f;

    if (nearest >= 0) {
        box = &box_manager->box[nearest];
        box->GetPosition(box_pos);
    }

    SetStack(stack++, box_pos[0]);
    SetStack(stack++, box_pos[1]);
    SetStack(stack++, box_pos[2]);
    SetStack(stack, nearest);
    return 1;
}

int _CONV_CHRNO_S2L(RS_STACKDATA *stack, int argc) {
    return 0;
}

int _SWE_INIT(RS_STACKDATA *stack, int argc) {
    int          chara_no = GetStackInt(stack++);
    int          slot = GetStackInt(stack++);
    int          stack_no = GetStackInt(stack++);
    int          init_param1 = GetStackInt(stack++);
    int          init_param2 = GetStackInt(stack);
    CCharacter2 *chara;

    if ((chara = GetCharacter(chara_no)) == NULL) {
        return 0;
    }

    mgCMemory *scene_stack;

    if ((scene_stack = EventScene->GetStack(stack_no)) == NULL) {
        return 0;
    }

    chara->sword_effect[slot] = new (scene_stack->Alloc(12)) CSWordAfterEffect;

    if (chara->sword_effect[slot] == NULL) {
        return 0;
    }

    chara->sword_effect[slot]->Initialize(scene_stack, init_param1, init_param2);
    return 1;
}

int _SWE_SET_COLOR(RS_STACKDATA *stack, int argc) {
    int                 a_r, a_g, a_b, a_a, b_r, b_g, b_b, b_a;
    int                 chara_no, slot;
    CCharacter2        *chara;
    CSWordAfterEffect **effect_slot;
    chara_no = GetStackInt(stack++);
    slot = GetStackInt(stack++);

    if ((chara = GetCharacter(chara_no)) == NULL) {
        return 0;
    }

    effect_slot =
        (CSWordAfterEffect *
             *) ((slot << 2) + (int) chara +
                 chara_sword_after_offset);

    if (*effect_slot == NULL) {
        return 0;
    }

    a_r = GetStackInt(stack++);
    a_g = GetStackInt(stack++);
    a_b = GetStackInt(stack++);
    a_a = GetStackInt(stack++);
    b_r = GetStackInt(stack++);
    b_g = GetStackInt(stack++);
    b_b = GetStackInt(stack++);
    b_a = GetStackInt(stack);
    CSWordAfterEffect *effect = *effect_slot;
    effect->color0[0] = a_r;
    effect->color0[1] = a_g;
    effect->color0[2] = a_b;
    effect->color0[3] = a_a;
    effect->color1[0] = b_r;
    effect->color1[1] = b_g;
    effect->color1[2] = b_b;
    effect->color1[3] = b_a;
    return 1;
}

int _SWE_SET_TEXTURE(RS_STACKDATA *stack, int argc) {
    mgCTexture         *texture;
    int                 block_no;
    char               *name;
    int                 u0;
    int                 v0;
    int                 u1;
    int                 v1;
    CSWordAfterEffect **effect_slot;
    CCharacter2        *chara;
    int                 slot;
    int                 chara_no;
    chara_no = GetStackInt(stack++);
    slot = GetStackInt(stack++);

    if ((chara = GetCharacter(chara_no)) == NULL) {
        return 0;
    }

    effect_slot =
        (CSWordAfterEffect *
             *) ((slot << 2) + (int) chara +
                 chara_sword_after_offset);

    if (*effect_slot == NULL) {
        return 0;
    }

    block_no = GetStackInt(stack++);
    name = GetStackString(stack++);
    u0 = GetStackInt(stack++);
    v0 = GetStackInt(stack++);
    u1 = GetStackInt(stack++);
    v1 = GetStackInt(stack);

    if ((texture = mgTexManager.GetTexture(name, block_no)) == NULL) {
        return 0;
    }

    (*effect_slot)->SetTexture(block_no, texture, u0, v0, u1, v1);
    return 1;
}

int _SWE_START_EFFECT(RS_STACKDATA *stack, int argc) {
    int                 chara_no;
    int                 slot;
    CCharacter2        *chara;
    char               *from_name;
    char               *to_name;
    int                 param8_c;
    int                 frames;
    int                 param90;
    CSWordAfterEffect **effect_slot;
    mgCFrame           *from_frame;
    mgCFrame           *to_frame;
    chara_no = GetStackInt(stack++);
    slot = GetStackInt(stack++);

    if ((chara = GetCharacter(chara_no)) == NULL) {
        return 0;
    }

    effect_slot =
        (CSWordAfterEffect *
             *) ((slot << 2) + (int) chara +
                 chara_sword_after_offset);

    if (*effect_slot == NULL) {
        return 0;
    }

    from_name = GetStackString(stack++);
    to_name = GetStackString(stack++);
    param8_c = GetStackInt(stack++);
    frames = GetStackInt(stack++);
    param90 = GetStackInt(stack);

    if (chara->CObjectFrame::frame == NULL) {
        return 0;
    }

    if ((from_frame = chara->CObjectFrame::frame->SearchFrame(from_name)) == NULL) {
        return 0;
    }

    if (chara->CObjectFrame::frame == NULL) {
        return 0;
    }

    if ((to_frame = chara->CObjectFrame::frame->SearchFrame(to_name)) == NULL) {
        return 0;
    }

    (*effect_slot)->StartEffect(from_frame, to_frame, param8_c, frames, param90);
    return 1;
}

int _SET_CHARA_TYPE(RS_STACKDATA *stack, int argc) {
    int chara_no;

    chara_no = GetStackInt(stack++);
    EventScene->SetType(1, chara_no, GetStackInt(stack));
    return 1;
}

int _GET_EVENT_DATA(RS_STACKDATA *stack, int argc) {
    CSceneEventData *event_data;

    event_data = &EventScene->event_data;

    if (event_data == NULL) {
        return 0;
    }

    switch (GetStackInt(stack++)) {
        case 0:
            SetStack(stack, static_cast<int>(event_data->event.flag));
            break;
        case 1:
            SetStack(stack, event_data->event.event_no);
            break;
        case 2:
            SetStack(stack, event_data->event.point_no);
            break;
        case 3:
            SetStack(stack, event_data->event.arg1);
            break;
        case 4:
            SetStack(stack, event_data->event.arg2);
            break;
        case 5:
            SetStack(stack, event_data->event.arg3);
            break;
        case 6:
            SetStack(stack, event_data->map_event.check_type);
            break;
        case 7:
            SetStack(stack, event_data->map_event.event_no);
            break;
        case 8:
            SetStack(stack++, event_data->map_event.matrix[3][0]);
            SetStack(stack++, event_data->map_event.matrix[3][1]);
            SetStack(stack++, event_data->map_event.matrix[3][2]);
            SetStack(stack, atan2f(event_data->map_event.matrix[2][0], event_data->map_event.matrix[2][2]));
            break;
        case 9:
            SetStack(stack, event_data->map_event.parts_no);
            break;
        case 10:
            SetStack(stack++, event_data->position[0]);
            SetStack(stack++, event_data->position[1]);
            SetStack(stack, event_data->position[2]);
            break;
        case 11:
            switch (argc) {
                case 2:
                    SetStack(stack, event_data->rotation[1]);
                    break;
                case 4:
                    SetStack(stack++, event_data->rotation[0]);
                    SetStack(stack++, event_data->rotation[1]);
                    SetStack(stack, event_data->rotation[2]);
                    break;
                default:
                    break;
            }

            break;
        case 12:
            SetStack(stack++, event_data->scale[0]);
            SetStack(stack++, event_data->scale[1]);
            SetStack(stack, event_data->scale[2]);
            break;
        case 13:
            SetStack(stack, event_data->chara_slot);
            break;
        case 14:
            SetStack(stack, event_data->chara_no);
            break;
        case 15:
            SetStack(stack, event_data->gameobj_no);
            break;
        default:
            return 0;
    }

    return 1;
}

int _DNG_SET_PREV_FLOOR(RS_STACKDATA *stack, int argc) {
    int        floor = GetStackInt(stack);
    CSaveData *save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    CSaveDataDungeon *dungeon = &save->save_dungeon;

    if (dungeon == NULL) {
        return 0;
    }

    dungeon->prev_floor_id[dungeon->stage_id] = floor;
    return 1;
}

int _DNG_GET_PREV_FLOOR(RS_STACKDATA *stack, int argc) {
    CSaveData *save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    CSaveDataDungeon *dungeon = &save->save_dungeon;

    if (dungeon == NULL) {
        return 0;
    }

    SetStack(stack, dungeon->prev_floor_id[dungeon->stage_id]);
    return 1;
}

int _DNG_SET_FAST_FLOOR(RS_STACKDATA *stack, int argc) {
    return 0;
}

int _SET_FLOOR_INFO(RS_STACKDATA *stack, int argc) {
    int        dungeon_no = GetStackInt(stack++);
    int        floor_no = GetStackInt(stack++);
    int        field = GetStackInt(stack++);
    CSaveData *save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    CSaveDataDungeon *dungeon = &save->save_dungeon;

    if (dungeon == NULL) {
        return 0;
    }

    DNG_FLOOR_SAVE *info;

    if ((info = dungeon->GetFloorInfoPtr(dungeon_no, floor_no)) == NULL) {
        return 0;
    }

    switch (field) {
        case 0:
            info->unk_0 = (int) GetStackFloat(stack);
            break;
        case 1:
            info->fast_destroy_time = (int) GetStackFloat(stack);
            break;
        case 2:
            info->unk_8 = GetStackInt(stack);
            break;
        case 3:
            info->unk_a = GetStackInt(stack);
            break;
        case 4:
            info->spheda_clear = GetStackInt(stack);
            break;
        case 5:
            info->flag |= (u16) GetStackInt(stack);
            break;
        case 6:
            info->kill_count = GetStackInt(stack);
            break;
        case 7:
            info->visit_count = GetStackInt(stack);
            break;
        default:
            return 0;
    }

    return 1;
}

int _GET_FLOOR_INFO(RS_STACKDATA *stack, int argc) {
    int        dungeon_no = GetStackInt(stack++);
    int        floor_no = GetStackInt(stack++);
    int        field = GetStackInt(stack++);
    CSaveData *save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    CSaveDataDungeon *dungeon = &save->save_dungeon;

    if (dungeon == NULL) {
        return 0;
    }

    DNG_FLOOR_SAVE *info = dungeon->GetFloorInfoPtr(dungeon_no, floor_no);

    if (info == NULL) {
        return 0;
    }

    switch (field) {
        case 0:
            SetStack(stack, info->unk_0);
            break;
        case 1:
            SetStack(stack, info->fast_destroy_time);
            break;
        case 2:
            SetStack(stack, info->unk_8);
            break;
        case 3:
            SetStack(stack, info->unk_a);
            break;
        case 4:
            SetStack(stack, info->spheda_clear);
            break;
        case 5:
            SetStack(stack, info->flag);
            break;
        case 6:
            SetStack(stack, info->kill_count);
            break;
        case 7:
            SetStack(stack, info->visit_count);
            break;
        default:
            return 0;
    }

    return 1;
}

int _GET_NEXT_FLOOR(RS_STACKDATA *stack, int argc) {
    int              floor = GetStackInt(stack++);
    int              route = GetStackInt(stack++);
    DNG_BATTLE_AREA *dng_scene = &EventScene->battle_area;

    if (dng_scene == NULL) {
        return 0;
    }

    CDngFloorManager *floor_manager = &dng_scene->floor_manager;

    if (floor_manager == NULL) {
        return 0;
    }

    argc = floor_manager->GetDngMapNextFloorID(floor, route);
    SetStack(stack, argc);
    return 1;
}

int _PAD_AUTO_REPEAT_OFF(RS_STACKDATA *stack, int argc) {
    GamePad__2.AutoRepeatOff();
    return 1;
}

int _PAD_SET_AUTO_REPEAT(RS_STACKDATA *stack, int argc) {
    int mask = GetStackInt(stack++);
    int delay = GetStackInt(stack++);
    int interval = GetStackInt(stack);
    GamePad__2.SetAutoRepeat(mask, delay, interval);
    return 1;
}

int _DNG_PAUSE(RS_STACKDATA *stack, int argc) {
    int              mask = GetStackInt(stack++);
    int              enable = GetStackInt(stack);
    DNG_BATTLE_AREA *dng_scene = &EventScene->battle_area;

    if (dng_scene == NULL) {
        return 0;
    }

    if (enable) {
        dng_scene->pause_flag |= mask;
    } else {
        dng_scene->pause_flag &= ~mask;
    }

    return 1;
}

int _DNG_CHECK_PAUSE(RS_STACKDATA *stack, int argc) {
    int              mask = GetStackInt(stack++);
    DNG_BATTLE_AREA *dng_scene = &EventScene->battle_area;

    if (dng_scene == NULL) {
        return 0;
    }

    int pause_flags = dng_scene->pause_flag;
    SetStack(stack, pause_flags & mask);
    return 1;
}

int _DNG_RESET_TIMER(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *dng_scene;

    dng_scene = &EventScene->battle_area;

    if (dng_scene == NULL) {
        return 0;
    }

    dng_scene->timer = 0;
    return 1;
}

int _DNG_GET_TIMER(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *dng_scene;

    dng_scene = &EventScene->battle_area;

    if (dng_scene == NULL) {
        return 0;
    }

    SetStack(stack, dng_scene->timer);
    return 1;
}

int _LOAD_SKIN(RS_STACKDATA *stack, int argc) {
    int                stack_no;
    int                image_block;
    int                chara_no;
    char               name[32];
    char              *info_name;
    char              *pack_file;
    CCharacter2       *chara;
    mgCMemory         *scene_stack;
    mgCTextureManager *tex_manager;
    stack_no = GetStackInt(stack++);

    switch (stack->type) {
        case 0:
            pack_file = GetItemFilePath(GetStackInt(stack++), 0);
            break;
        case 2:
            pack_file = GetStackString(stack++);
            break;
    }

    info_name = GetStackString(stack++);
    chara_no = GetStackInt(stack);

    if ((chara = GetCharacter(chara_no)) == NULL) {
        return 0;
    }

    if (0 > (image_block = EventScene->GetCharaTexb(chara_no))) {
        return 0;
    }

    if ((scene_stack = EventScene->GetStack(stack_no)) == NULL) {
        return 0;
    }

    if ((pack_file = (char *) GetLoadBGBuff(pack_file, 0)) == 0) {
        return 0;
    }

    sprintf(name, "ev%d", chara_no);
    tex_manager = &mgTexManager;

    if (chara_no >= 8) {
        strcpy(tex_manager->name_suffix, name);
    }

    chara->LoadSkin((u32 *) pack_file, info_name, "", scene_stack, image_block);

    if (chara_no >= 8) {
        tex_manager->name_suffix[0] = 0;
    }

    return 1;
}

int _CHK_CAMERA_COL(RS_STACKDATA *stack, int argc) {
    float     from[4];
    float     to[4];
    float     hit_pos[4];
    mgVu0FBOX box;
    CCPoly    polys[256];
    CMap     *map;
    float     radius;
    int       poly_count;
    int       hit;
    GetStackVector(from, stack);
    GetStackVector(to, stack + 3);
    stack += 6;
    radius = 1.2f * mgDistVector(from, to);
    box.max[0] = radius + from[0];
    box.min[0] = from[0] - radius;
    box.max[1] = radius + from[1];
    box.min[1] = from[1] - radius;
    box.max[2] = radius + from[2];
    box.min[2] = from[2] - radius;
    box.max[3] = 1.0f;
    box.min[3] = 1.0f;
    map = EventScene->GetMap(EventScene->active_map);

    if (map == NULL) {
        return 0;
    }

    poly_count = map->GetCameraPoly(polys, box, 0x100);

    if (poly_count >= 0x100) {
        return 0;
    }

    hit = CheckHit(polys, poly_count, from, to, hit_pos, 1, 1);

    switch (argc) {
        case 10:
            SetStack(stack++, hit_pos[0]);
            SetStack(stack++, hit_pos[1]);
            SetStack(stack++, hit_pos[2]);
        case 7:
            SetStack(stack, hit);
            break;
        default:
            return 0;
    }

    return 1;
}

int _GET_PARTS_FUNC_POS(RS_STACKDATA *stack, int argc) {
    float      center[4];
    CMapParts *parts[8];
    mgVu0FBOX  box;
    float      parts_pos[4];
    float      func_parts_pos[4];
    float      func_pos[4];
    float      nearest;
    CMap      *map;
    char      *name;
    int        count;
    int        nearest_no;
    int        i;
    center[0] = GetStackFloat(stack++);
    center[1] = GetStackFloat(stack++);
    center[2] = GetStackFloat(stack++);
    center[3] = GetStackFloat(stack++);
    name = GetStackString(stack++);
    map = EventScene->GetMap(EventScene->active_map);

    if (map == NULL) {
        return 0;
    }

    box.max[0] = center[3] + center[0];
    box.min[0] = center[0] - center[3];
    box.max[1] = center[3] + center[1];
    box.min[1] = center[1] - center[3];
    box.max[2] = center[3] + center[2];
    box.min[2] = center[2] - center[3];
    box.max[3] = 1.0f;
    box.min[3] = 1.0f;
    count = map->GetPlaceParts(&box, parts, 8);

    if (count <= 0) {
        return 0;
    }

    nearest_no = -1;
    nearest = 1000000.0f;

    for (i = 0; i < count; i++) {
        parts[i]->GetPosition(parts_pos);
        float dist = mgDistVector(center, parts_pos);

        if (dist < nearest) {
            nearest = dist;
            nearest_no = i;
        }
    }

    if (nearest_no <= -1) {
        SetStack(stack, 0);
        return 0;
    }

    CFuncPoint *func_point = parts[nearest_no]->func_point_mngr.Search(name);

    if (func_point == NULL) {
        SetStack(stack, 0);
    } else {
        parts[nearest_no]->GetPosition(func_parts_pos);
        *(u_long128 *) func_pos = *(u_long128 *) func_point->position;
        sceVu0AddVector(func_pos, func_pos, func_parts_pos);
        SetStack(stack++, 1);
        SetStack(stack++, func_pos[0]);
        SetStack(stack++, func_pos[1]);
        SetStack(stack, func_pos[2]);
    }

    return 1;
}

int _RANDOM_CIRCLE_GET_POS(RS_STACKDATA *stack, int argc) {
    float pos[3];
    int   circle_id = GetStackInt(stack++);

    if (RandomCircle.GetPosition(pos, circle_id) <= -1) {
        return 0;
    }

    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

int _RANDOM_CIRCLE_OFF(RS_STACKDATA *stack, int argc) {
    int circle_id = GetStackInt(stack);

    if (circle_id == -1) {
        int current = RandomCircle.hit;

        if (current != -1) {
            RandomCircle.active[current] = 0;
        }
    } else {
        RandomCircle.active[circle_id] = 0;
    }

    return 1;
}

int _DNG_XCHG_MAP_LIGHT(RS_STACKDATA *stack, int argc) {
    XChgMapLighting();
    return 1;
}

int _GEOSTONE_ANIME_OFF(RS_STACKDATA *stack, int argc) {
    GeoStone.anime = 0;
    return 1;
}

int _GEOSTONE_SET_FLAG(RS_STACKDATA *stack, int argc) {
    GeoStone.SetFlag(GetStackInt(stack));
    return 1;
}

int _GEOSTONE_SET_REFERENCE(RS_STACKDATA *stack, int argc) {
    int          chara_no = GetStackInt(stack++);
    char        *name = GetStackString(stack);
    CCharacter2 *chara = GetChara(chara_no);

    if (chara == NULL) {
        return 0;
    }

    if (chara->CObjectFrame::frame == NULL) {
        return 0;
    }

    mgCFrame *reference = chara->CObjectFrame::frame->SearchFrame(name);

    if (reference == NULL) {
        return 0;
    }

    if (GeoStone.CObjectFrame::frame == NULL) {
        return 0;
    }

    GeoStone.CObjectFrame::frame->SetReference(reference);
    return 1;
}

int _GEOSTONE_DEL_REFERENCE(RS_STACKDATA *stack, int argc) {
    if (GeoStone.CObjectFrame::frame == NULL) {
        return 0;
    }

    GeoStone.CObjectFrame::frame->DeleteReference();
    return 1;
}

int _GET_ROBO_MOVE_TYPE(RS_STACKDATA *stack, int argc) {
    SetStack(stack, ((CActionChara *) GetCharacter(0))->move_type);
    return 1;
}

int _SET_EXIT_FLAG(RS_STACKDATA *stack, int argc) {
    EventScene->exit_flag = GetStackInt(stack);
    return 1;
}

int _GET_EXIT_FLAG(RS_STACKDATA *stack, int argc) {
    SetStack(stack, EventScene->exit_flag);
    return 1;
}

int _GET_E3_VERSION(RS_STACKDATA *stack, int argc) {
    SetStack(stack, 0);
    return 1;
}

int _CHK_PAD_CTRL(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }

    int button = GetStackInt(stack++);
    SetStack(stack, PadCtrl.Btn(button));
    return 1;
}

int _CTRLC_STAY(RS_STACKDATA *stack, int argc) {
    CCameraControl *camera = GetCamera();
    camera->Stay();
    return 1;
}

int _BSCN_SET_BLIGHT_RATE(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *info = &EventScene->battle_area;

    if (info == NULL) {
        return 0;
    }

    info->bright_rate = GetStackFloat(stack);
    return 1;
}

int _GET_RND_CIRCLE_TRAPID(RS_STACKDATA *stack, int argc) {
    int circle_id = GetStackInt(stack++);
    SetStack(stack, GetRandomCircleTrapID(circle_id));
    return 1;
}

int _SET_RND_CIRCLE_STATUS(RS_STACKDATA *stack, int argc) {
    float result;
    int   circle_id = GetStackInt(stack++);
    SetRandamCircleStatus(circle_id, result);
    SetStack(stack, result);
    return 1;
}

int _SET_STATUSBAR_SHOW(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *area = &EventScene->battle_area;

    if (area == NULL) {
        return 0;
    }

    float speed = 0.02f;

    if (argc <= 0 || argc > 2) {
        return 0;
    }

    int show = GetStackInt(stack++);

    if (argc == 2) {
        speed = GetStackFloat(stack);
    }

    if (speed < 1.0f) {
        speed *= 1.2f;
    }

    area->SetStatusBar(show, speed);

    if (!(speed < 1.0f)) {
        if (show) {
            area->statusbar_rate = 1.0f;
        } else {
            area->statusbar_rate = 0.0f;
        }
    }

    return 1;
}

int _SET_PULL_ITEM(RS_STACKDATA *stack, int argc) {
    float             pos[4];
    float             velocity[4];
    int               type;
    int               count;
    float             value;
    CUserDataManager *user_data;
    CSaveData        *save_data;
    int               i;
    CPullItem        *item;
    int               chara_no;
    GetStackVector(pos, stack);
    stack += 3;
    type = GetStackInt(stack++);
    count = GetStackInt(stack++);
    value = GetStackFloat(stack);
    user_data = NULL;
    save_data = GetSaveData();

    if (save_data != NULL) {
        user_data = &save_data->user_data;
    }

    if (user_data == NULL) {
        return 0;
    }

    chara_no = user_data->active_chr_no;

    for (i = 0; i < count; i++) {
        item = PullItemMan.GetList(2);

        if (item == NULL) {
            continue;
        }

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
        item->SetItem(pos, velocity, type);

        switch (type) {
            case PULL_ITEM_MONEY:
                item->item_no = fptosi(value);
                break;
            case PULL_ITEM_WEAPON_EXP:
                item->exp = value;
                item->exp_param = chara_no;
                item->item_no = 3;
                break;
            case PULL_ITEM_GATE_KEY:
                break;
            case PULL_ITEM_MONEY_LARGE:
                item->item_no = fptosi(value);
                break;
            case PULL_ITEM_ITEM:
                break;
        }
    }

    return 1;
}

int _MENU_CHARA_CHENGE(RS_STACKDATA *stack, int argc) {
    GetStackInt(stack);
    MenuArg.open_type = 0xE;
    EdEventInfo.command_mode = 3;
    return 1;
}

int _GET_EVENT_INFO_SNDID(RS_STACKDATA *stack, int argc) {
    int index = GetStackInt(stack++);
    SetStack(stack, EdEventInfo.snd_id[index]);
    return 1;
}

int _GET_PARTS_POS(RS_STACKDATA *stack, int argc) {
    CMap      *maps[8];
    float      pos[4];
    CMapParts *parts;
    int        map_count;
    int        i;
    int        parts_id;
    char      *parts_name;
    map_count = EventScene->GetActiveMap(maps, 8);

    if (!(map_count > 0)) {
        return 0;
    }

    switch (stack->type) {
        case 0:
            parts_id = GetStackInt(stack++);

            for (i = 0; i < map_count; i++) {
                parts = maps[i]->GetPlaceParts(parts_id);

                if (parts != NULL) {
                    break;
                }
            }

            break;
        case 2:
            parts_name = GetStackString(stack++);

            for (i = 0; i < map_count; i++) {
                parts = maps[i]->GetPlaceParts(parts_name);

                if (parts != NULL) {
                    break;
                }
            }

            break;
    }

    if (parts == NULL) {
        return 0;
    }

    parts->GetPosition(pos);
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}

int _CANCEL_DRAMA_SCENE(RS_STACKDATA *stack, int argc) {
    CancelDramaScene();
    return 1;
}

int _GET_RNDC_MOT_NOWT(RS_STACKDATA *stack, int argc) {
    float weight = RandomCircle.model.frame;
    SetStack(stack, weight);
    return 1;
}

int _SET_CHARA_MOT_NOWT(RS_STACKDATA *stack, int argc) {
    int          chara_no = GetStackInt(stack++);
    float        time = GetStackFloat(stack);
    CCharacter2 *chara = GetCharacter(chara_no);

    if (chara == NULL) {
        return 0;
    }

    chara->frame = time;
    return 1;
}

int _CHARA_NORMAL_DRIVE(RS_STACKDATA *stack, int argc) {
    CCharacter2 *chara;
    chara = GetCharacter(GetStackInt(stack));

    if (chara == NULL) {
        return 0;
    }

    chara->NormalDrive();
    return 1;
}

int _CHARA_RESET_DA(RS_STACKDATA *stack, int argc) {
    CCharacter2 *chara;

    if ((chara = GetCharacter(GetStackInt(stack))) == NULL) {
        return 0;
    }

    chara->ResetDAPosition();
    chara->StepDA(0xA);
    return 1;
}

int _DNG_SETUP_MAIN_UNIT(RS_STACKDATA *stack, int argc) {
    char               sound_path[0x28];
    mgCTexture        *icons[2];
    int                chara_no;
    CUserDataManager  *user_data;
    mgCTextureManager *manager;
    int                i;
    CActionChara      *chara;
    int                bank;
    CSaveData         *save_data;
    chara_no = GetStackInt(stack);
    save_data = GetSaveData();

    if (save_data == NULL) {
        return 0;
    }

    user_data = &save_data->user_data;

    if (user_data == NULL) {
        return 0;
    }

    if (chara_no == user_data->active_chr_no) {
        return 0;
    }

    ColPrimMan.Delete(0);
    manager = &mgTexManager;

    for (i = 0; i < 8; i++) {
        manager->DeleteBlock(i + 0x10);
    }

    FxScriptMan->AllClearEffSpt();
    FxScriptMan->ClearBaseFromLevel(2, NULL, -1);
    manager->DeleteBlock(0xAA);
    DngUserData->SetActiveChrNo(chara_no);
    SetupMainUnit(read_buffer, &BuffCharacter, BaseCharacter, 0x10, EventScene, user_data, chara_no, 0);

    if ((chara = (CActionChara *) GetCharacter(0)) == NULL) {
        return 0;
    }

    LoadFile("img/allitem.img", read_buffer, NULL);
    manager->EnterIMGFile((u_char *) read_buffer, 0x50, NULL, NULL);
    icons[0] = manager->GetTexture("icon_dmy1", -1);
    icons[1] = manager->GetTexture("icon_dmy2", -1);
    CopyActiveIconTexture(icons, chara_no, NULL);
    manager->DeleteBlock(0x50);
    chara->sound_info.foot_se_bank = EventScene->se_base_id;
    chara->sound_info.foot_sound_id = -1;
    GetCharacterSnd(DngUserData, chara_no, sound_path);
    LoadFile(sound_path, read_buffer, NULL);
    bank = 3;

    if (chara_no == 2) {
        bank = 1;
    }

    if (chara_no == 3) {
        bank = 0;
    }

    sndInitPort(7);
    chara->sound_info.se_bank = sndLoadSound(7, (u32 *) read_buffer, &BaseCharacter[bank]);
    chara->sound_info.se_bank_2 = EventScene->se_battle_id;
    chara->SetSoundInfoCopy();
    chara->effect_man = FxScriptMan;
    DngUserData->SetActiveChrNo(chara_no);
    return 1;
}

int _JOIN_PARTY_MEMBER(RS_STACKDATA *stack, int argc) {
    int               chara_no;
    CUserDataManager *user_data;
    CSaveData        *save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    user_data = &save->user_data;

    if (user_data == NULL) {
        return 0;
    }

    chara_no = GetStackInt(stack++);

    switch (stack->type) {
        case 0:
            if (GetStackInt(stack) == 1) {
                user_data->JoinPartyMember(chara_no);
            } else {
                user_data->LeavePartyMember(chara_no);
            }

            break;
        case 3: {
            int members = user_data->GetNowPartyMember();
            SetStack(stack, (members & (1 << chara_no)) ? 1 : 0);
            break;
        }
        default:
            return 0;
    }

    return 1;
}

int _SET_CHARA_CHANGE_FLAG(RS_STACKDATA *stack, int argc) {
    int               chara_no;
    CUserDataManager *user_data;
    CSaveData        *save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    user_data = &save->user_data;

    if (user_data == NULL) {
        return 0;
    }

    chara_no = GetStackInt(stack++);

    if (GetStackInt(stack) == 1) {
        user_data->EnableCharaChange(chara_no);
    } else {
        user_data->DisableCharaChange(chara_no);
    }

    return 1;
}

int _SET_CHARA_CHANGE_MASK(RS_STACKDATA *stack, int argc) {
    int               chara_no;
    CUserDataManager *user_data;
    CSaveData        *save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    user_data = &save->user_data;

    if (user_data == NULL) {
        return 0;
    }

    chara_no = GetStackInt(stack++);

    if (GetStackInt(stack) == 1) {
        user_data->EnableCharaChangeMask(chara_no);
    } else {
        user_data->DisableCharaChangeMask(chara_no);
    }

    return 1;
}

int _SET_CHARA_EQUIP(RS_STACKDATA *stack, int argc) {
    int        chara_no;
    int        item_no;
    CSaveData *save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    CUserDataManager *user_data = &save->user_data;

    if (user_data == NULL) {
        return 0;
    }

    chara_no = GetStackInt(stack++);
    item_no = GetStackInt(stack);
    return user_data->SetChrEquip(chara_no, item_no);
}

int _LOAD_PACK_FILE(RS_STACKDATA *stack, int argc) {
    if (GetLoadBGBuff(GetStackString(stack), 0) == 0) {
        return 0;
    }

    EdEventInfo.pack_loaded = 1;
    return 1;
}

int _SET_BIT_CTRL(RS_STACKDATA *stack, int argc) {
    CSaveData *save;
    int        bit;

    if ((save = GetSaveData()) == NULL) {
        return 0;
    }

    bit = GetStackInt(stack++);

    if (GetStackInt(stack) == 1) {
        save->SetBitCtrl(bit);
    } else {
        save->ResetBitCtrl(bit);
    }

    return 1;
}

int _GET_BIT_CTRL(RS_STACKDATA *stack, int argc) {
    CSaveData *save;
    int        bit;
    int        ctrl;

    if ((save = GetSaveData()) == NULL) {
        return 0;
    }

    bit = GetStackInt(stack++);
    ctrl = save->GetBitCtrl();
    SetStack(stack, (ctrl & bit) ? 1 : 0);
    return 1;
}

int _LOAD_ARG(RS_STACKDATA *stack, int argc) {
    int        stack_no = GetStackInt(stack++);
    char      *file_name = GetStackString(stack);
    mgCMemory *memory;

    if ((memory = EventScene->GetStack(stack_no)) == NULL) {
        return 0;
    }

    u32 *program;

    if ((program = GetLoadBGBuff(file_name, NULL)) == NULL) {
        return 0;
    }

    EventScriptArg.memory = memory;
    EventScriptArg.next_id = 0;
    EventScriptArg.list = NULL;
    EventScriptArg.list_num = 0;
    EventScriptArg.BuildArgData(program);
    return 1;
}

int _GET_ITEM_HAVE_NUM(RS_STACKDATA *stack, int argc) {
    int item_id = GetStackInt(stack++);
    argc = GetUserItemHaveNum(item_id);
    SetStack(stack, argc);
    return 1;
}

int _SET_SKIP_BOTTON(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    EdEventInfo.skip_button = GetStackInt(stack);
    return 1;
}

int _SET_SKIP_FCOL(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }

    GetStackVector(EdEventInfo.skip_fade_color, stack);
    EdEventInfo.skip_fade_color[3] = 0;
    return 1;
}

int _GET_DEBUG_MODE(RS_STACKDATA *stack, int arg_count) {
    SetStack(stack, 1);
    return 1;
}

int _GET_MAP_TYPE(RS_STACKDATA *stack, int argc) {
    int           map_no;
    RS_STACKDATA *result;

    switch (stack->type) {
        case 0:
            result = stack + 1;
            map_no = GetStackInt(stack);
            break;
        case 2:
            result = stack + 1;
            map_no = SearchMapNo(GetStackString(stack));
            break;
        default:
            return 0;
    }

    SetStack(result, GetMapType(map_no));
    return 1;
}

int _DNG_COLLISION_ALL_CLR(RS_STACKDATA *stack, int argc) {
    ColPrimMan.Initialize(DngMainScene);
    return 1;
}

int _SET_MAP_DRAW(RS_STACKDATA *stack, int argc) {
    EdEventInfo.map_draw = GetStackInt(stack);
    return 1;
}

int _CHECK_MC_LOAD(RS_STACKDATA *stack, int arg_count) {
    INIT_LOOP_ARG *arg = GetNowInitArg();

    if (arg == NULL) {
        return 0;
    }

    SetStack(stack, arg->mc_load);
    arg->mc_load = 0;
    return 1;
}

int _SET_NOW_MAP_NO(RS_STACKDATA *stack, int argc) {
    EventScene->SetNowMapNo(GetStackInt(stack));
    return 1;
}

int _GET_TBOX_PARAM(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *area = &EventScene->battle_area;

    if (area == NULL) {
        return 0;
    }

    CTreasureBoxManager *manager = area->treasure_box;

    if (manager == NULL) {
        return 0;
    }

    int           near_box = manager->near_box;
    int           box_no = near_box;
    CTreasureBox *box = &manager->box[box_no];

    if (box == NULL) {
        return 0;
    }

    SetStack(stack++, box->flags);
    SetStack(stack++, box->item[0]);
    SetStack(stack++, box->item[1]);
    SetStack(stack++, box->num[0]);
    SetStack(stack, box->num[1]);
    return 1;
}

int _CANCEL_LOAD_VILLAGER(RS_STACKDATA *stack, int argc) {
    CScene *scene = EventScene;
    scene->skip_load_sub_villager = 1;
    scene->skip_load_villager = 1;
    return 1;
}

int _CANCEL_NOW_LOADING(RS_STACKDATA *stack, int argc) {
    CancelNowLoading();
    return 1;
}
static inline int Ident(int v) {
    return v;
}
#ifdef NONMATCHING
int _ESM_INITIALIZE(RS_STACKDATA *stack, int argc) {
    int stackNo;
    int texbOffset = 0;
    mgCMemory *memory;
    stackNo = GetStackInt(stack++);
    if (argc >= 2) {
        texbOffset = GetStackInt(stack);
    }
    if ((memory = (mgCMemory *)EventScene->GetStack(stackNo)) == NULL) {
        return 0;
    }
    CEffectScriptMan *manager;
    manager = new (memory->Alloc(0x11B)) CEffectScriptMan;
    EventEffectScript = manager;
    if (EventEffectScript == NULL) {
        return 0;
    }
    EventEffectScript->Initialize(memory, Ident(EventScene->event_texb) + Ident(texbOffset), EventScene->event_texb_num - texbOffset);
    EventEffectScript->load_buffer = read_buffer;
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _ESM_INITIALIZE__FP12RS_STACKDATAi);
#endif
int _ESM_INIT_FIX(RS_STACKDATA *stack, int argc) {
    int        stack_no;
    int        heap_size;
    mgCMemory *scene_stack;
    mgCMemory *heap;

    if (EventEffectScript == 0) {
        return 0;
    }

    heap_size = 0x36B0;
    stack_no = GetStackInt(stack++);

    if (argc >= 2) {
        heap_size = GetStackInt(stack);
    }

    if ((scene_stack = EventScene->GetStack(stack_no)) == NULL) {
        return 0;
    }

    if ((heap = (mgCMemory *) operator new(0x30, scene_stack->Alloc(5))) != NULL) {
        heap->Init();
    }

    if (heap == NULL) {
        return 0;
    }

    heap->SetHeapMem(scene_stack->stAlloc64(heap_size), heap_size);
    heap->stack_used = 0;
    heap->lock = 0;
    EventEffectScript->SetWorkBuffer(heap);
    return 1;
}

int _ESM_CLEAR(RS_STACKDATA *stack, int argc) {
    int                cleared_blocks[68];
    mgCMemory         *work_buffer;
    mgCTextureManager *tex_manager;
    int                i;

    if (EventEffectScript == 0) {
        return 0;
    }

    EventEffectScript->ClearBaseFromLevel(0, cleared_blocks, 64);
    EventEffectScript->AllClearEffSpt();
    work_buffer = EventEffectScript->work_memory;

    if (work_buffer != NULL) {
        work_buffer->stack_used = 0;
        work_buffer->lock = 0;
        work_buffer->ClearHeapMem();
    }

    tex_manager = &mgTexManager;
    EventEffectScript = 0;

    for (i = 0; i < 64; i++) {
        printf("[ESM_CLEAR] DEL TEXB = %d\n", cleared_blocks[i]);

        if (cleared_blocks[i] <= -1) {
            break;
        }

        tex_manager->DeleteBlock(cleared_blocks[i]);
    }

    return 1;
}

int _ESM_LOAD_BASE(RS_STACKDATA *stack, int argc) {
    int ret;

    if (EventEffectScript == NULL) {
        return 0;
    }

    switch (stack->type) {
        case 0:
            ret = EventEffectScript->LoadBaseEffSpt(GetStackInt(stack), NULL, -1);
            break;
        case 2:
            ret = EventEffectScript->LoadBaseEffSpt(GetStackString(stack), NULL, -1);
            break;
        default:
            ret = 0;
            break;
    }

    return ret;
}

static int _ESM_CREATE(RS_STACKDATA *stack, int argc) {
    if (EventEffectScript == NULL) {
        return 0;
    }

    char *name = GetStackString(stack++);

    switch (argc) {
        case 1:
            EventEffectScript->CreateEffSpt(name, -1, 0);
            break;
        case 2:
            EventEffectScript->CreateEffSpt(name, GetStackInt(stack), 0);
            break;
        case 3: {
            int group = GetStackInt(stack++);
            int result = EventEffectScript->CreateEffSpt(name, group, 1);
            SetStack(stack, result);

            if (result <= -1) {
                return 0;
            }

            break;
        }
        default:
            return 0;
    }

    return 1;
}

static int _ESM_FINISH(RS_STACKDATA *stack, int argc) {
    int           group;
    RS_STACKDATA *next_slot = stack + 1;

    if (EventEffectScript == NULL) {
        return 0;
    }

    group = GetStackInt(stack);
    EventEffectScript->SetScriptProgNo(0x12C, group, GetStackInt(next_slot));
    return 1;
}

static int _ESM_DELETE(RS_STACKDATA *stack, int argc) {
    if (EventEffectScript == NULL) {
        return 0;
    }

    int group = GetStackInt(stack++);
    EventEffectScript->DeleteEffSpt(group, GetStackInt(stack));
    return 1;
}

static int _ESM_SET_VECT1(RS_STACKDATA *stack, int argc) {
    float vector[4];
    int   ret;

    if (EventEffectScript == NULL) {
        return 0;
    }

    switch (argc) {
        case 3:
            GetStackVector(vector, stack);
            ret = EventEffectScript->SetScriptVect1(vector, -1, -1);
            break;
        case 5: {
            int user_id = GetStackInt(stack++);
            int slot = GetStackInt(stack++);
            GetStackVector(vector, stack);
            ret = EventEffectScript->SetScriptVect1(vector, user_id, slot);
            break;
        }
        default:
            return 0;
    }

    return ret;
}

static int _ESM_SET_VECT2(RS_STACKDATA *stack, int argc) {
    float vector[4];
    int   ret;

    if (EventEffectScript == NULL) {
        return 0;
    }

    switch (argc) {
        case 3:
            GetStackVector(vector, stack);
            ret = EventEffectScript->SetScriptVect2(vector, -1, -1);
            break;
        case 5: {
            int user_id = GetStackInt(stack++);
            int slot = GetStackInt(stack++);
            GetStackVector(vector, stack);
            ret = EventEffectScript->SetScriptVect2(vector, user_id, slot);
            break;
        }
        default:
            return 0;
    }

    return ret;
}

static int _ESM_SET_TARGET_ID(RS_STACKDATA *stack, int argc) {
    int param1;
    int param2;
    int ret;

    if (EventEffectScript == NULL) {
        return 0;
    }

    switch (argc) {
        case 1:
            ret = EventEffectScript->SetScriptTargetId(GetStackInt(stack), -1, -1);
            break;
        case 3:
            param1 = GetStackInt(stack++);
            param2 = GetStackInt(stack++);
            ret = EventEffectScript->SetScriptTargetId(GetStackInt(stack), param1, param2);
            break;
        default:
            ret = 0;
            break;
    }

    return ret;
}

int _ESM_LOAD_BASE_PACK(RS_STACKDATA *stack, int argc) {
    if (EventEffectScript == NULL) {
        return 0;
    }

    char *pack_name = GetStackString(stack++);
    char *file_name = GetStackString(stack);
    u32  *pack = GetLoadBGBuff(file_name, NULL);

    if (pack != NULL) {
        return EventEffectScript->BuildPack(pack_name, pack, NULL, -1);
    }

    return 0;
}

static int _ESM_SET_VALUE(RS_STACKDATA *stack, int argc) {
    int value_no;
    int group;
    int slot;
    int ret;

    if (EventEffectScript == 0) {
        return 0;
    }

    switch (argc) {
        case 2:
            value_no = GetStackInt(stack++);

            switch (stack->type) {
                case 0:
                    ret = EventEffectScript->SetValue(value_no, GetStackInt(stack), -1, -1);
                    break;
                case 1:
                    ret = EventEffectScript->SetValue(value_no, GetStackFloat(stack), -1, -1);
                    break;
                default:
                    return 0;
            }

            break;
        case 4:
            group = GetStackInt(stack++);
            slot = GetStackInt(stack++);
            value_no = GetStackInt(stack++);

            switch (stack->type) {
                case 0:
                    ret = EventEffectScript->SetValue(value_no, GetStackInt(stack), group, slot);
                    break;
                case 1:
                    ret = EventEffectScript->SetValue(value_no, GetStackFloat(stack), group, slot);
                    break;
                default:
                    return 0;
            }

            break;
        default:
            return 0;
    }

    return ret;
}

int _SET_CHARA_CONDITION(RS_STACKDATA *stack, int argc) {
    switch (argc) {
        case 2: {
            CBattleCharaInfo *info;
            int               chara;

            if ((info = GetBattleCharaInfo()) == 0) {
                return 0;
            }

            chara = GetStackInt(stack++);
            info->SetAttr(chara, GetStackInt(stack));
            break;
        }
        case 3: {
            CUserDataManager *user_data;
            int               attr;
            int               chara_no;
            int               value;

            if ((user_data = GetUserDataMan()) == NULL) {
                return 0;
            }

            chara_no = GetStackInt(stack++);
            attr = GetStackInt(stack++);
            value = GetStackInt(stack);

            if (user_data != NULL) {
                user_data->SetCharaStatusAttirbute(chara_no, attr, value);
            }

            break;
        }
        default:
            return 0;
    }

    return 1;
}

int _ADD_WHP(RS_STACKDATA *stack, int argc) {
    CBattleCharaInfo *info;

    if ((info = GetBattleCharaInfo()) == 0) {
        return 0;
    }

    int chara = GetStackInt(stack++);
    int amount = GetStackInt(stack);
    info->AddWhp(chara, amount);
    return 1;
}

int _ADD_HP_RATE(RS_STACKDATA *stack, int argc) {
    float             rate;
    float             frames;
    CBattleCharaInfo *info;

    if ((info = GetBattleCharaInfo()) == NULL) {
        return 0;
    }

    frames = 0.0f;
    rate = GetStackFloat(stack++);
    int mode = GetStackInt(stack++);

    if (argc >= 3) {
        frames = GetStackFloat(stack);
    }

    info->AddHp_Rate(rate, mode, frames);
    return 1;
}

int _GET_TIME(RS_STACKDATA *stack, int argc) {
    SetStack(stack, EventScene->time);
    return 1;
}

int _CHECK_GET_ITEM_LIMIT(RS_STACKDATA *stack, int argc) {
    int item_id;
    int count;

    switch (argc) {
        case 1:
            argc = CheckItemLimmitOver();
            SetStack(stack, argc);
            break;
        case 3:
            item_id = GetStackInt(stack++);
            count = GetStackInt(stack++);
            count = CheckGetItemRemainNum(item_id) - count < 0 ? 0 : count;
            SetStack(stack, count);
            break;
        default:
            return 0;
    }

    return 1;
}

int _CHECK_ITEM_OVER(RS_STACKDATA *stack, int argc) {
    argc = CheckItemOver();
    SetStack(stack, argc);
    return 1;
}

int _GET_NOW_LOOP_NO(RS_STACKDATA *stack, int argc) {
    argc = GetNowLoopNo();
    SetStack(stack, argc);
    return 1;
}

int _IS_CLEAR_DESTROY(RS_STACKDATA *stack, int argc) {
    CDngFloorManager *floor_manager;
    DNG_BATTLE_AREA  *dng_scene;

    dng_scene = &EventScene->battle_area;

    if (dng_scene == 0) {
        return 0;
    }

    floor_manager = &dng_scene->floor_manager;

    if (floor_manager == NULL) {
        return 0;
    }

    SetStack(stack, floor_manager->IsClearMostFastDestroy());
    return 1;
}
int _IS_CLEAR_PRACTICE(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }
    DNG_BATTLE_AREA *area = &EventScene->battle_area;
    CDngFloorManager *floorManager = &area->floor_manager;
    if (area == NULL) {
        return 0;
    }
    if (floorManager == NULL) {
        return 0;
    }
    int cleared = floorManager->IsClearPractice(GetStackInt(stack++));
    CSaveData *saveData = GetSaveData();
    if (saveData == NULL) {
        return 0;
    }
    CSaveDataDungeon *dungeon = &saveData->save_dungeon;
    if (dungeon == NULL) {
        return 0;
    }
    DNGMAP_ROOM_INFO *info = floorManager->GetDngMapFloorInfo(dungeon->floor_id[dungeon->stage_id]);
    if (info == NULL) {
        return 0;
    }
    int bonus = info->practice_type;
    switch (bonus) {
        case 2: {
            int param = info->practice_param;
            switch (param) {
                case 1:
                case 2:
                case 3:
                case 4:
                    bonus = param + 5;
                    break;
            }
        }
    }
    SetStack(stack++, cleared);
    SetStack(stack, bonus);
    return 1;
}
int _IS_PLAY_SUB_GAME(RS_STACKDATA *stack, int argc) {
    CDngFloorManager *floor_manager;
    DNG_BATTLE_AREA  *dng_scene;

    dng_scene = &EventScene->battle_area;

    if (dng_scene == 0) {
        return 0;
    }

    floor_manager = &dng_scene->floor_manager;

    if (floor_manager == NULL) {
        return 0;
    }

    SetStack(stack, floor_manager->IsPlaySubGame());
    return 1;
}

int _RESET_SUBJECT_COUNTER(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *dng_scene;
    CSaveData       *save;

    dng_scene = &EventScene->battle_area;

    if (dng_scene == NULL) {
        return 0;
    }

    save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    dng_scene->subject_counter = (u32) save->play_time;
    return 1;
}

int _SCR_EFF_INIT_RASTER(RS_STACKDATA *stack, int argc) {
    float amplitude = GetStackFloat(stack++);
    float speed = GetStackFloat(stack++);
    float pitch = GetStackFloat(stack);
    EventScreenEffect.InitRaster(amplitude, speed, pitch);
    return 1;
}

int _SCR_EFF_START_RASTER(RS_STACKDATA *stack, int argc) {
    float amplitude = GetStackFloat(stack++);
    float speed = GetStackFloat(stack++);
    float pitch = GetStackFloat(stack++);
    int   frames = GetStackInt(stack);
    EventScreenEffect.StartRaster(amplitude, speed, pitch, frames);
    return 1;
}

int _SCR_EFF_STOP_RASTER(RS_STACKDATA *stack, int argc) {
    float amplitude = GetStackFloat(stack++);
    float speed = GetStackFloat(stack++);
    float pitch = GetStackFloat(stack++);
    int   frames = GetStackInt(stack);
    EventScreenEffect.StopRaster(amplitude, speed, pitch, frames);
    return 1;
}

int _SET_MPCHARA_MOTION(RS_STACKDATA *stack, int argc) {
    CMap      *maps[8];
    int        map_count;
    int        i;
    CMapParts *parts;
    char      *parts_name;
    int        parts_id;
    map_count = EventScene->GetActiveMap(maps, 8);

    if (!(map_count > 0)) {
        return 0;
    }

    switch (stack->type) {
        case 0:
            parts_id = GetStackInt(stack++);

            for (i = 0; i < map_count; i++) {
                parts = maps[i]->GetPlaceParts(parts_id);

                if (parts != NULL) {
                    break;
                }
            }

            break;
        case 2:
            parts_name = GetStackString(stack++);

            for (i = 0; i < map_count; i++) {
                parts = maps[i]->GetPlaceParts(parts_name);

                if (parts != NULL) {
                    break;
                }
            }

            break;
    }

    if (parts == NULL) {
        return 0;
    }

    CMapPiece *piece;

    if ((piece = parts->SearchPiece(GetStackString(stack++))) == NULL) {
        return 0;
    }

    int   flags = 0;
    char *motion_name = GetStackString(stack++);

    if (argc >= 4) {
        flags = GetStackInt(stack);
    }

    if (piece->chara != NULL) {
        piece->chara->SetMotion(motion_name, flags);
    }

    return 1;
}

int _FUNC_POINT_POS(RS_STACKDATA *stack, int argc) {
    float       pos[4];
    CFuncPoint *func_point;
    CMap       *map = EventScene->GetMap(EventScene->active_map);

    if (map == NULL) {
        return 0;
    }

    switch (stack->type) {
        case RS_INT: {
            int        parts_no = GetStackInt(stack++);
            char      *name = GetStackString(stack++);
            CMapParts *parts = map->GetPlaceParts(parts_no);

            if (parts == NULL) {
                return 0;
            }

            func_point = parts->func_point_mngr.Search(name);
            break;
        }
        case RS_STR: {
            char *place_name = GetStackString(stack++);
            char *name = GetStackString(stack++);

            if (strcmp(place_name, "") != 0) {
                CMapParts *parts = map->GetPlaceParts(place_name);

                if (parts == NULL) {
                    return 0;
                }

                func_point = parts->func_point_mngr.Search(name);
            } else {
                func_point = map->func_point.Search(name);
            }

            break;
        }
    }

    if (func_point == NULL) {
        return 0;
    }

    GetStackVector(pos, stack);
    *(u_long128 *) func_point->position = *(u_long128 *) pos;
    func_point->frame.SetPosition(pos);
    return 1;
}

int _PARTS_NAME_STRCMP(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }

    int        parts_no = GetStackInt(stack++);
    char      *name = GetStackString(stack++);
    CMap      *map = EventScene->GetMap(EventScene->active_map);
    CMapParts *parts;

    if (map != NULL && (parts = map->GetPlaceParts(parts_no)) != NULL) {
        int order = strcmp(parts->parts_name, name);
        SetStack(stack, order);
        return 1;
    }

    SetStack(stack, -1);
    return 0;
}

int _GET_TRIAL_VERSION(RS_STACKDATA *stack, int argc) {
    SetStack(stack, 0);
    return 1;
}

int _SET_FLOOR_EPISODE(RS_STACKDATA *stack, int argc) {
    StartupEpisodeTitle.Switch(GetStackInt(stack));
    return 1;
}

int _FUNC_POINT_GET_POS(RS_STACKDATA *stack, int argc) {
    float       pos[4];
    CFuncPoint *func_point;
    CMap       *map = EventScene->GetMap(EventScene->active_map);

    if (map == NULL) {
        return 0;
    }

    switch (stack->type) {
        case RS_INT: {
            int        parts_no = GetStackInt(stack++);
            char      *name = GetStackString(stack++);
            CMapParts *parts = map->GetPlaceParts(parts_no);

            if (parts == NULL) {
                return 0;
            }

            func_point = parts->func_point_mngr.Search(name);
            break;
        }
        case RS_STR: {
            char *place_name = GetStackString(stack++);
            char *name = GetStackString(stack++);

            if (strcmp(place_name, "") != 0) {
                CMapParts *parts = map->GetPlaceParts(place_name);

                if (parts == NULL) {
                    return 0;
                }

                func_point = parts->func_point_mngr.Search(name);
            } else {
                func_point = map->func_point.Search(name);
            }

            break;
        }
    }

    if (func_point == NULL) {
        return 0;
    }

    *(u_long128 *) pos = *(u_long128 *) func_point->position;
    SetStack(stack++, pos[0]);
    SetStack(stack++, pos[1]);
    SetStack(stack, pos[2]);
    return 1;
}
static inline CMap *GetActiveEventMap() {
    return EventScene->GetMap(EventScene->active_map);
}
int _FUNC_POINT_GET_ROT(RS_STACKDATA *stack, int argc) {
    float rot[4];
    CMap *map;
    CFuncPoint *funcPoint;
    map = GetActiveEventMap();
    if (map == NULL) {
        return 0;
    }
    switch (stack->type) {
        case RS_INT: {
            int partsNo = GetStackInt(stack++);
            char *name = GetStackString(stack++);
            CMapParts *parts = map->GetPlaceParts(partsNo);
            if (parts == NULL) {
                return 0;
            }
            funcPoint = parts->func_point_mngr.Search(name);
            break;
        }
        case RS_STR: {
            char *placeName = GetStackString(stack++);
            char *name = GetStackString(stack++);
            if (strcmp(placeName, "") != 0) {
                CMapParts *parts = map->GetPlaceParts(placeName);
                if (parts == NULL) {
                    return 0;
                }
                funcPoint = parts->func_point_mngr.Search(name);
            } else {
                funcPoint = map->func_point.Search(name);
            }
            break;
        }
    }
    if (funcPoint == NULL) {
        return 0;
    }
    *(u_long128 *)rot = *(u_long128 *)funcPoint->rotation;
    switch (argc) {
        case 3:
            SetStack(stack, rot[1]);
            break;
        case 5:
            SetStack(stack++, rot[0]);
            SetStack(stack++, rot[1]);
            SetStack(stack, rot[2]);
            break;
        default:
            return 0;
    }
    return 1;
}
int _ACTCHR_SET_DEF_MOTION(RS_STACKDATA *stack, int argc) {
    int           chara_no;
    int           motion_arg = 0;
    CActionChara *chara;
    chara_no = GetStackInt(stack++);

    if (argc >= 2) {
        motion_arg = GetStackInt(stack);
    }

    if ((chara = (CActionChara *) GetCharacter(chara_no)) == NULL) {
        return 0;
    }

    char *default_motion = chara->default_motion;
    chara->ResetAction();
    chara->SetMotion(default_motion, motion_arg, 1);
    return 1;
}

int _ADD_FUSION_POINT(RS_STACKDATA *stack, int argc) {
    int               group;
    int               member;
    int               points;
    CUserDataManager *user_data;
    CSaveData        *save;

    group = GetStackInt(stack++);
    member = GetStackInt(stack++);
    points = GetStackInt(stack);

    if ((group < 0) || (group > 1)) {
        return 0;
    }

    if ((member < 0) || (user_data = NULL, (member > 1))) {
        return 0;
    }

    save = GetSaveData();

    if (save != 0) {
        user_data = &save->user_data;
    }

    if (user_data == NULL) {
        return 0;
    }

    user_data->AddFusionPoint(group, member, points);
    return 1;
}

int _GET_DEBUG_FLAG(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    SetStack(stack, DebugFlag);

    return 1;
}

int _MINIMAP_DOOR_ENABLE(RS_STACKDATA *stack, int argc) {
    float pos[3];

    if (argc != 3) {
        return 0;
    }

    GetStackVector(pos, stack);
    MinimapDoorEnable(pos);
    return 1;
}

int _DNG_CHECK_BOSS_MAP(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *dng_scene;

    if (argc != 1) {
        return 0;
    }

    dng_scene = &EventScene->battle_area;

    if (dng_scene == NULL) {
        return 0;
    }

    SetStack(stack, dng_scene->boss_map);
    return 1;
}

int _DNG_RUN_EVENT(RS_STACKDATA *stack, int argc) {
    int              event_no = GetStackInt(stack);
    DNG_BATTLE_AREA *scene = &EventScene->battle_area;

    if (scene == NULL) {
        return 0;
    }

    s16 *slot = &scene->script.event_no;

    if (slot == NULL) {
        return 0;
    }

    *slot = (s16) event_no;
    return 1;
}

int _CHECK_ENABLE_CHARA_CHANGE(RS_STACKDATA *stack, int argc) {
    CUserDataManager *user_data;
    int               chara_no;
    CSaveData        *save;
    RS_STACKDATA     *next_slot;

    if (argc != 2) {
        return 0;
    }

    next_slot = stack + 1;
    chara_no = GetStackInt(stack);
    save = GetSaveData();

    if (save == 0) {
        return 0;
    }

    user_data = &save->user_data;

    if (user_data == NULL) {
        return 0;
    }

    SetStack(next_slot, user_data->CheckEnableCharaChange(chara_no, NULL));
    return 1;
}

int _INIT_SEPIA(RS_STACKDATA *stack, int argc) {
    int        stack_no;
    int        block_offset;
    u_long128 *buffer;
    mgCMemory *scene_stack;
    int        block_no;
    int        size;
    CScene    *scene;
    int        tex_count;
    int        tex_base;

    block_offset = 0;
    stack_no = GetStackInt(stack++);

    if (argc >= 2) {
        block_offset = GetStackInt(stack);
    }

    scene = EventScene;
    tex_count = scene->event_texb_num;
    tex_base = scene->event_texb;

    if (tex_count <= 0 || tex_count < block_offset) {
        return 0;
    }

    block_no = tex_base + block_offset;

    if (stack_no >= 0) {
        if ((scene_stack = EventScene->GetStack(stack_no)) == NULL) {
            return 0;
        }

        size = mgScreenWidth * mgScreenHeight * mgScreenDepth;

        if ((buffer = scene_stack->stAlloc64(size / 8 / 16 + 1)) == 0) {
            return 0;
        }
    } else {
        buffer = read_buffer;
    }

    mgTexManager.DeleteBlock(block_no);
    EventScreenEffect.SetSepiaTexture(mgTexManager.EnterTexture(
                                          block_no, "event sepia", NULL, mgScreenWidth,
                                          mgScreenHeight, mgScreenDepth, 0, 0LL, 0),
                                      buffer);
    return 1;
}

int _START_SEPIA(RS_STACKDATA *stack, int argc) {
    EventScreenEffect.CaptureSepiaScreen();
    EventScreenEffect.SetSepiaFlag(1);
    return 1;
}

int _END_SEPIA(RS_STACKDATA *stack, int argc) {
    EventScreenEffect.SetSepiaFlag(0);
    return 1;
}

#ifdef NONMATCHING
int _COPY_MONS2SCNCHR(RS_STACKDATA *stack, int argc) {
    if (ActiveMonster == NULL) {
        return 0;
    }

    mgCMemory *memory;

    if ((memory = EventScene->GetStack(GetStackInt(stack++))) == NULL) {
        return 0;
    }

    int          monster_index = ActiveMonster->SearchBaseIndex(GetStackInt(stack++));
    int          dst_no = GetStackInt(stack);
    CCharacter2 *copy;

    copy = new (memory->Alloc(0x68)) CCharacter2;

    if (copy == NULL) {
        return 0;
    }

    EventScene->DeleteChara(dst_no);
    int slot = EventScene->AssignChara(dst_no, copy, NULL);

    if (slot < 0) {
        return 0;
    }

    EventScene->SetStatus(1, slot, 5);
    CCharacter2 *dest = GetCharacter(dst_no);
    CCharacter2 source = ActiveMonster->refer[monster_index].chara;
    source.Copy(*dest, memory);
    EventScene->SetCharaTexb(dst_no, monster_index + 0x28);
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _COPY_MONS2SCNCHR__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", __ct__7CObjectFRC7CObject);
#endif

int _UNLOCK_STACK(RS_STACKDATA *stack, int argc) {
    mgCMemory *scene_stack = EventScene->GetStack(GetStackInt(stack));

    if (scene_stack == NULL) {
        return 0;
    }

    scene_stack->lock = 0;
    return 1;
}

int _RESET_EVENT_TRG(RS_STACKDATA *stack, int argc) {
    EventScene->event_run = 0;
    return 1;
}

int _SET_CHARA_NO(RS_STACKDATA *stack, int argc) {
    int slot = GetStackInt(stack++);

    EventScene->SetCharaNo(slot, GetStackInt(stack));
    return 1;
}

int _GET_CHARA_NO(RS_STACKDATA *stack, int argc) {
    int           id;
    RS_STACKDATA *args = stack;

    if (argc != 2) {
        return 0;
    }

    id = GetStackInt(args++);
    SetStack(args, EventScene->GetCharaNo(id));
    return 1;
}

int _SEARCH_CHARA_NO(RS_STACKDATA *stack, int argc) {
    int           id;
    RS_STACKDATA *args = stack;

    if (argc != 2) {
        return 0;
    }

    id = GetStackInt(args++);
    SetStack(args, EventScene->SearchCharaID(id));
    return 1;
}

int _GET_NEAR_RANDOM_STONE_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];
    float stone_pos[4];

    if (argc != 7) {
        return 0;
    }

    int found = -1;
    GetStackVector(pos, stack);
    stack += 3;
    stone_pos[0] = 0.0f;
    stone_pos[1] = 0.0f;
    stone_pos[2] = 0.0f;
    stone_pos[3] = 0.0f;
    CMapParts *stone;

    if ((stone = AutoMapGen.SearchRandomStone(pos, 30.0f)) != NULL) {
        stone->GetPosition(stone_pos);
        found = 1;
    }

    SetStack(stack++, stone_pos[0]);
    SetStack(stack++, stone_pos[1]);
    SetStack(stack++, stone_pos[2]);
    SetStack(stack, found);
    return 1;
}

int _INIT_MONO_FLASH(RS_STACKDATA *stack, int argc) {
    u_long128  *buffers[2];
    mgCTexture *textures[2];
    mgCMemory  *memory;
    int         stack_no;
    int         tex_base;
    int         tex_count;

    stack_no = GetStackInt(stack);
    tex_count = EventScene->event_texb_num;
    tex_base = EventScene->event_texb;

    if (tex_count <= 0 || tex_count < 0) {
        return 0;
    }

    if (stack_no >= 0) {
        if ((memory = EventScene->GetStack(stack_no)) == NULL) {
            return 0;
        }

        if ((buffers[0] = memory->stAlloc64(
                 mgScreenDepth * (mgScreenWidth * mgScreenHeight) / 8 / 16 + 1)) == NULL) {
            return 0;
        }

        if ((buffers[1] = memory->stAlloc64(
                 mgScreenDepth * (mgScreenWidth * mgScreenHeight) / 8 / 16 + 1)) == NULL) {
            return 0;
        }
    } else {
        buffers[0] = read_buffer;
        buffers[1] =
            read_buffer + mgScreenDepth * (mgScreenWidth * mgScreenHeight) / 8 / 16;
    }

    mgTexManager.DeleteBlock(tex_base);
    mgTexManager.DeleteBlock(tex_base + 1);
    textures[0] = mgTexManager.EnterTexture(
        tex_base, "mono_flash1", NULL, mgScreenWidth, mgScreenHeight, mgScreenDepth, 0, 0, 0);
    textures[1] = mgTexManager.EnterTexture(
        tex_base + 1, "mono_flash2", NULL, mgScreenWidth, mgScreenHeight, mgScreenDepth, 0, 0,
        0);
    EventScreenEffect.SetMonoFlashTexture(textures, buffers);
    return 1;
}

int _START_MONO_FLASH(RS_STACKDATA *stack, int argc) {
    int param = GetStackInt(stack);

    EventScreenEffect.CaptureMonoFlashScreen();
    EventScreenEffect.SetMonoFlashFlag(1, param);
    return 1;
}

int _END_MONO_FLASH(RS_STACKDATA *stack, int argc) {
    EventScreenEffect.SetMonoFlashFlag(0, 0);
    return 1;
}

int _DELETE_VILLAGER(RS_STACKDATA *stack, int argc) {
    EventScene->DeleteVillager(GetStackInt(stack));
    return 1;
}

int _DNG_SET_WEATHER(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *info = (&EventScene->battle_area);
    int              weather;

    if (info == NULL) {
        return 0;
    }

    weather = GetStackInt(stack);
    info->weather = weather;

    if (weather == 2) {
        EventScene->AutoChangeEnvOffset(4);
    } else {
        EventScene->AutoChangeEnvOffset(0);
    }

    return 1;
}

int _SET_CHARA_MAXHP(RS_STACKDATA *stack, int argc) {
    int               chara_no;
    RS_STACKDATA     *args = stack;
    int               max_hp;
    CUserDataManager *user_data;
    CSaveData        *save;
    CHARA_DATA       *chara;

    chara_no = GetStackInt(args++);
    max_hp = GetStackInt(args);
    save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    user_data = &save->user_data;

    if (user_data == NULL) {
        return 0;
    }

    chara = user_data->GetCharaDataPtr(chara_no);
    chara->hp.max = (float) max_hp;
    chara->hp.SetFillRate(1.0f);
    return 1;
}

int _SET_CHARA_DEFENCE(RS_STACKDATA *stack, int argc) {
    int               chara_no;
    RS_STACKDATA     *args = stack;
    int               defence;
    CUserDataManager *user_data;
    CSaveData        *save;

    chara_no = GetStackInt(args++);
    defence = GetStackInt(args);
    save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    user_data = &save->user_data;

    if (user_data == NULL) {
        return 0;
    }

    user_data->GetCharaDataPtr(chara_no)->defence = defence;
    return 1;
}

int _PLACE_PARTS_NAME_STRCMP(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }

    int        parts_no = GetStackInt(stack++);
    char      *name = GetStackString(stack++);
    CMap      *map = EventScene->GetMap(EventScene->active_map);
    CMapParts *parts;

    if (map != NULL && (parts = map->GetPlaceParts(parts_no)) != NULL) {
        int order = strcmp(parts->name, name);
        SetStack(stack, order);
        return 1;
    }

    SetStack(stack, -1);
    return 0;
}

int _GOTO_USE_ITEM2(RS_STACKDATA *stack, int argc) {
    int i;

    if (stack->type != RS_PTR) {
        return 0;
    }

    p_use_item = stack->val.p;
    stack++;
    MenuArg.open_type = 9;
    MenuArg.param[0] = GetStackInt(stack++);

    for (i = 1; i < argc - 1; i++) {
        MenuArg.param[i] = GetStackInt(stack++);
    }

    MenuArg.param[i] = 0;
    EdEventInfo.command_mode = 3;
    return 1;
}

int _DBG_SET_ANALYZE_FLAG(RS_STACKDATA *stack, int argc) {
    int           area;
    RS_STACKDATA *args = stack;
    int           entry;
    int           flag;
    CSaveData    *save;
    CEditData    *edit_data;

    area = GetStackInt(args++);
    entry = GetStackInt(args++);
    flag = GetStackInt(args);
    save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    edit_data = save->GetEditData(area);

    if (edit_data == NULL) {
        return 0;
    }

    edit_data->dbgSetAnalyzeFlag(area, entry, flag);
    return 1;
}

int _ATRAMIRIA_ON_OFF(RS_STACKDATA *stack, int argc) {
    int           mode;
    RS_STACKDATA *args = stack;
    int           chara_no;
    int           flag;

    mode = GetStackInt(args++);
    chara_no = GetStackInt(args++);
    flag = GetStackInt(args);
    AtraMiriaOnOff(mode, GetCharacter(chara_no), flag);
    return 1;
}

int _ADD_YARIKOMI_MEDAL(RS_STACKDATA *stack, int argc) {
    CUserDataManager *user_data;
    CSaveData        *save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    user_data = &save->user_data;

    if (user_data == NULL) {
        return 0;
    }

    user_data->AddYarikomiMedal(GetStackInt(stack));
    return 1;
}

int _SET_MAP_EFFECT_ID(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *info = (&EventScene->battle_area);

    if (info == NULL) {
        return 0;
    }

    info->map_effect_id = GetStackInt(stack);
    return 1;
}

int _GET_MAP_EFFECT_ID(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *info = &EventScene->battle_area;

    if (info == NULL) {
        return 0;
    }

    switch (argc) {
        case 1:
            SetStack(stack, info->map_effect_id);
            return 1;
    }

    return 0;
}

int _DNG_FLOOR_INIT(RS_STACKDATA *stack, int argc) {
    DungeonFloorInit();
    return 1;
}

int _DNG_FLOOR_FINISH(RS_STACKDATA *stack, int argc) {
    DungeonFloorFinish();
    return 1;
}

int _CLEAR_RND_STONE(RS_STACKDATA *stack, int argc) {
    AutoMapGen.ClearRandomStone();
    return 1;
}
int _GET_FLOOR_STATUS(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    DNG_BATTLE_AREA *info = &EventScene->battle_area;
    if (info == NULL) {
        return 0;
    }
    SetStack(stack, (int)((u_int)info->floor_status * 16 / 16));
    return 1;
}
int _SET_FLOOR_STATUS(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *info = (&EventScene->battle_area);
    RS_STACKDATA    *args = stack;
    int              mask;

    if (info == NULL) {
        return 0;
    }

    mask = GetStackInt(args++);

    if (GetStackInt(args) != 0) {
        info->floor_status |= mask;
    } else {
        info->floor_status &= ~mask;
    }

    return 1;
}

int _AMG_GET_ATTR_STATUS(RS_STACKDATA *stack, int argc) {
    float position[4];

    if (argc != 4) {
        return 0;
    }
    GetStackVector(position, stack);

    stack = (RS_STACKDATA *)((u8 *)stack + 0x18);
    SetStack(stack, AutoMapGen.GetAttrStatus(position));
    return 1;
}

int _SET_NEAR_DIST(RS_STACKDATA *stack, int argc) {
    int          chara_no = GetStackInt(stack++);
    float        dist = GetStackFloat(stack);
    CCharacter2 *chara;

    if ((chara = GetCharacter(chara_no)) == NULL) {
        return 0;
    }

    chara->SetFadeFlag(1);
    chara->SetNearDist(dist);
    return 1;
}

int _SET_KEEP_TIME(RS_STACKDATA *stack, int argc) {
    EdEventInfo.keep_time = GetStackFloat(stack);
    return 1;
}

int _GET_KEEP_TIME(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    SetStack(stack, EdEventInfo.keep_time);

    return 1;
}

int _GET_DOOR_PARTS_ID(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }

    CMap      *map = EventScene->GetMap(EventScene->active_map);
    CMapParts *door = AutoMapGen.SearchDoorParts();
    int        parts_id = -1;

    if (map != NULL) {
        if (door != NULL) {
            parts_id = map->ConvertParts(door);
        }
    }

    SetStack(stack, parts_id);
    return 1;
}

int _CHECK_EQUEP_CHANGE(RS_STACKDATA *stack, int argc) {
    GetStackInt(stack);
    CheckEquipChange(1);
    return 1;
}

int _ADD_HP_RATE2(RS_STACKDATA *stack, int argc) {
    CSaveData *save_data = GetSaveData();

    if (save_data == NULL) {
        return 0;
    }

    CUserDataManager *user_data = &save_data->user_data;

    if (user_data == NULL) {
        return 0;
    }

    int   chara_no = GetStackInt(stack++);
    float rate = GetStackFloat(stack);
    user_data->AddHp_Rate(chara_no, rate);
    return 1;
}

int _DNG_EFFECT_ALL_CLEAR(RS_STACKDATA *stack, int argc) {
    int i;

    RocketLauncher.Clear();

    for (i = 0; i < 16; i++) {
        MachineGun.active[i] = 0;
        MachineGun.col_prim_id[i] = -1;
    }

    MachineGun.index = 0;
    LaserGun.Clear();
    FxScriptMan->AllClearEffSpt();
    return 1;
}

int _AUTO_CHENGE_BGM_VOL(RS_STACKDATA *stack, int argc) {
    EventScene->AutoChangeBGMVol(GetStackInt(stack));
    return 1;
}

int _UDATA_GET_WHP(RS_STACKDATA *stack, int argc) {
    int               chara_no;
    CUserDataManager *user_data;
    CSaveData        *save;
    int               weapon_no;
    int               value;
    int               max;

    save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    user_data = &save->user_data;

    if (user_data == NULL) {
        return 0;
    }

    chara_no = GetStackInt(stack++);
    weapon_no = GetStackInt(stack++);
    value = user_data->GetWhp(chara_no, weapon_no, &max);

    switch (argc) {
        case 3:
            SetStack(stack, value);
            break;
        case 4:
            SetStack(stack++, value);
            SetStack(stack, max);
            break;
        default:
            return 0;
    }

    return 1;
}

int _UDATA_ADD_WHP(RS_STACKDATA *stack, int argc) {
    int               chara_no;
    RS_STACKDATA     *args = stack;
    CUserDataManager *user_data;
    CSaveData        *save;
    int               item_no;
    int               amount;

    save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    user_data = &save->user_data;

    if (user_data == NULL) {
        return 0;
    }

    chara_no = GetStackInt(args++);
    item_no = GetStackInt(args++);
    amount = GetStackInt(args);
    user_data->AddWhp(chara_no, item_no, amount);
    return 1;
}

int _UDATA_GET_ABS(RS_STACKDATA *stack, int argc) {
    int               chara_no;
    CUserDataManager *user_data;
    CSaveData        *save;
    int               weapon_no;
    int               value;
    int               max;

    save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    user_data = &save->user_data;

    if (user_data == NULL) {
        return 0;
    }

    chara_no = GetStackInt(stack++);
    weapon_no = GetStackInt(stack++);
    value = user_data->GetAbs(chara_no, weapon_no, &max);

    switch (argc) {
        case 3:
            SetStack(stack, value);
            break;
        case 4:
            SetStack(stack++, value);
            SetStack(stack, max);
            break;
        default:
            return 0;
    }

    return 1;
}

int _UDATA_ADD_ABS(RS_STACKDATA *stack, int argc) {
    int               chara_no;
    RS_STACKDATA     *args = stack;
    CUserDataManager *user_data;
    CSaveData        *save;
    int               item_no;
    int               amount;

    save = GetSaveData();

    if (save == NULL) {
        return 0;
    }

    user_data = &save->user_data;

    if (user_data == NULL) {
        return 0;
    }

    chara_no = GetStackInt(args++);
    item_no = GetStackInt(args++);
    amount = GetStackInt(args);
    user_data->AddAbs(chara_no, item_no, amount);
    return 1;
}

int _DNG_CREATE_EFFECT(RS_STACKDATA *stack, int argc) {
    float first[4];
    float second[4];
    int   value;

    FxScriptMan->CreateEffSpt(GetStackString(stack++), -1, 0);

    switch (argc) {
        case 4:
            GetStackVector(first, stack);
            stack += 3;
            FxScriptMan->SetScriptVect1(first, -1, -1);
        case 5:
            GetStackVector(first, stack);
            value = GetStackInt(stack += 3);
            FxScriptMan->SetScriptVect1(first, -1, -1);
            FxScriptMan->SetValue(0, value, -1, -1);
            break;
        case 7:
            GetStackVector(first, stack);
            stack += 3;
            GetStackVector(second, stack);
            FxScriptMan->SetScriptVect1(first, -1, -1);
            FxScriptMan->SetScriptVect2(second, -1, -1);
            break;
        default:
            return 0;
    }

    return 1;
}

int _LEAVE_MONICA_ITEM_CHECK(RS_STACKDATA *stack, int argc) {
    LeaveMonicaItemCheck();
    return 1;
}

int _PAUSE_ENABLE_FLAG(RS_STACKDATA *stack, int argc) {
    PauseEnable(GetStackInt(stack));
    return 1;
}

int _FORCE_BOOT_TOUR(RS_STACKDATA *stack, int argc) {
    CSaveData *save_data = GetSaveData();

    if (save_data == NULL) {
        return 0;
    }

    save_data->ForceBootTour(save_data->day, 1);
    return 1;
}

/**
 * External event script handlers in command-table order.
 */
static RS_EXTFUNC_INFO ext_func_info[697] = {
    {_GET_PADON, EVENT_EXT_GET_PADON},
    {_GET_PADDOWN, EVENT_EXT_GET_PADDOWN},
    {_GET_PADUP, EVENT_EXT_GET_PADUP},
    {_GET_APAD, EVENT_EXT_GET_APAD},
    {_GOTO_INTERIOR, EVENT_EXT_GOTO_INTERIOR},
    {_INITIALIZE, EVENT_EXT_INITIALIZE},
    {_GOTO_OUTSIDE, EVENT_EXT_GOTO_OUTSIDE},
    {_LOAD_CHARA, EVENT_EXT_LOAD_CHARA},
    {_CHARA_ACTIVE, EVENT_EXT_CHARA_ACTIVE},
    {_CLEAR_STACK, EVENT_EXT_CLEAR_STACK},
    {_ASSIGN_STACK, EVENT_EXT_ASSIGN_STACK},
    {_SET_FLAG, EVENT_EXT_SET_FLAG},
    {_GET_FLAG, EVENT_EXT_GET_FLAG},
    {_SET_CNT, EVENT_EXT_SET_CNT},
    {_GET_CNT, EVENT_EXT_GET_CNT},
    {_SET_CURRENT_DIR, EVENT_EXT_SET_CURRENT_DIR},
    {_DELETE_CHARA, EVENT_EXT_DELETE_CHARA},
    {_LOAD_MOTION, EVENT_EXT_LOAD_MOTION},
    {_MAP_JUMP, EVENT_EXT_MAP_JUMP},
    {_SET_RAIN, EVENT_EXT_SET_RAIN},
    {_DEL_EXT_MOTION, EVENT_EXT_DEL_EXT_MOTION},
    {_SET_MARKER, EVENT_EXT_SET_MARKER},
    {_SET_WORLD_COORD, EVENT_EXT_SET_WORLD_COORD},
    {_FINISH, EVENT_EXT_FINISH},
    {_GET_DUN_WORLD_COORD, EVENT_EXT_GET_DUN_WORLD_COORD},
    {_LOAD_IMG, EVENT_EXT_LOAD_IMG},
    {_DEL_IMG, EVENT_EXT_DEL_IMG},
    {_SET_DNG_MAP, EVENT_EXT_SET_DNG_MAP},
    {_LOAD_ITEM, EVENT_EXT_LOAD_ITEM},
    {_GOTO_USE_ITEM, EVENT_EXT_GOTO_USE_ITEM},
    {_SET_LOCAL_FLAG, EVENT_EXT_SET_LOCAL_FLAG},
    {_GET_LOCAL_FLAG, EVENT_EXT_GET_LOCAL_FLAG},
    {_GOTO_SELECT_PARTY, EVENT_EXT_GOTO_SELECT_PARTY},
    {_SET_LOADBG_FILE, EVENT_EXT_SET_LOADBG_FILE},
    {_CHECK_LOADBG_FILE, EVENT_EXT_CHECK_LOADBG_FILE},
    {_GET_TB_ITEMNO, EVENT_EXT_GET_TB_ITEMNO},
    {_SET_TB_STATUS, EVENT_EXT_SET_TB_STATUS},
    {_SET_TB_ANGLE, EVENT_EXT_SET_TB_ANGLE},
    {_ADD_ITEM, EVENT_EXT_ADD_ITEM},
    {_GET_ITEM_TYPE, EVENT_EXT_GET_ITEM_TYPE},
    {_GET_ITEM_SPACE, EVENT_EXT_GET_ITEM_SPACE},
    {_GET_ADJUST_POLYGON_SCALE, EVENT_EXT_GET_ADJUST_POLYGON_SCALE},
    {_LOAD_MOVIE, EVENT_EXT_LOAD_MOVIE},
    {_INIT_LOCAL_CNT, EVENT_EXT_INIT_LOCAL_CNT},
    {_SET_CROSSFADE, EVENT_EXT_SET_CROSSFADE},
    {_SET_TIME, EVENT_EXT_SET_TIME},
    {_SET_ACTIVE_LIGHT, EVENT_EXT_SET_ACTIVE_LIGHT},
    {_SET_PAKU_ANIM, EVENT_EXT_SET_PAKU_ANIM},
    {_RESET_PAKU_ANIM, EVENT_EXT_RESET_PAKU_ANIM},
    {_TRG_PAKU_ANIM, EVENT_EXT_TRG_PAKU_ANIM},
    {_RESET_CAMERA, EVENT_EXT_RESET_CAMERA},
    {_GET_ACTIVE_CHR_NO, EVENT_EXT_GET_ACTIVE_CHR_NO},
    {_SET_ACTIVE_CHR_NO, EVENT_EXT_SET_ACTIVE_CHR_NO},
    {_DNG_SET_FLOOR_ID, EVENT_EXT_DNG_SET_FLOOR_ID},
    {_DNG_GET_FLOOR_ID, EVENT_EXT_DNG_GET_FLOOR_ID},
    {_SET_PAKU_MOTION, EVENT_EXT_SET_PAKU_MOTION},
    {_RESET_PAKU_MOTION, EVENT_EXT_RESET_PAKU_MOTION},
    {_TRG_PAKU_MOTION, EVENT_EXT_TRG_PAKU_MOTION},
    {_SET_BG_COLOR, EVENT_EXT_SET_BG_COLOR},
    {_GOTO_DNG_MAP, EVENT_EXT_GOTO_DNG_MAP},
    {_GOTO_DNG, EVENT_EXT_GOTO_DNG},
    {_GOTO_EDIT, EVENT_EXT_GOTO_EDIT},
    {_GET_MENU_PARAM, EVENT_EXT_GET_MENU_PARAM},
    {_LOAD_CHARA_NPC, EVENT_EXT_LOAD_CHARA_NPC},
    {_AUTO_SET_TREASURE_BOX, EVENT_EXT_AUTO_SET_TREASURE_BOX},
    {_AUTO_SET_MONSTER, EVENT_EXT_AUTO_SET_MONSTER},
    {_LOAD_DUNGEON_MAP_FILE, EVENT_EXT_LOAD_DUNGEON_MAP_FILE},
    {_LOAD_MONSTER_FILE, EVENT_EXT_LOAD_MONSTER_FILE},
    {_GET_NPC_STATUS, EVENT_EXT_GET_NPC_STATUS},
    {_SET_NPC_STATUS, EVENT_EXT_SET_NPC_STATUS},
    {_GET_NOW_PARTY_CHARA, EVENT_EXT_GET_NOW_PARTY_CHARA},
    {_SET_LOCAL_CNT, EVENT_EXT_SET_LOCAL_CNT},
    {_GET_LOCAL_CNT, EVENT_EXT_GET_LOCAL_CNT},
    {_GET_LOCAL_CNT2, EVENT_EXT_GET_LOCAL_CNT2},
    {_GET_TRAIN_NPC_POS, EVENT_EXT_GET_TRAIN_NPC_POS},
    {_GOTO_DRAW_CHAPTER, EVENT_EXT_GOTO_DRAW_CHAPTER},
    {_SET_PROJECTION, EVENT_EXT_SET_PROJECTION},
    {_GET_PROJECTION, EVENT_EXT_GET_PROJECTION},
    {_SET_FADE_IN, EVENT_EXT_SET_FADE_IN},
    {_SET_FADE_OUT, EVENT_EXT_SET_FADE_OUT},
    {_DNG_DEBUG_COMMAND, EVENT_EXT_DNG_DEBUG_COMMAND},
    {_CD_SEEK, EVENT_EXT_CD_SEEK},
    {_GET_ROT_LOOK_POS, EVENT_EXT_GET_ROT_LOOK_POS},
    {_SET_MOTION_BLUR, EVENT_EXT_SET_MOTION_BLUR},
    {_LOAD_SCRIPT, EVENT_EXT_LOAD_SCRIPT},
    {_SET_TALK_CAMERA, EVENT_EXT_SET_TALK_CAMERA},
    {_HIT_EFFECT, EVENT_EXT_HIT_EFFECT},
    {_COPY_CHARA, EVENT_EXT_COPY_CHARA},
    {_GET_START_BUTTON, EVENT_EXT_GET_START_BUTTON},
    {_MOVE_INTERIOR, EVENT_EXT_MOVE_INTERIOR},
    {_GET_MONSTER_TALK_DATA, EVENT_EXT_GET_MONSTER_TALK_DATA},
    {_FUNC_POINT_SHOW, EVENT_EXT_FUNC_POINT_SHOW},
    {_GET_NOW_MAP_NO, EVENT_EXT_GET_NOW_MAP_NO},
    {_GET_NOW_SUBMAP_NO, EVENT_EXT_GET_NOW_SUBMAP_NO},
    {_GET_OLD_MAP_NO, EVENT_EXT_GET_OLD_MAP_NO},
    {_GET_OLD_SUBMAP_NO, EVENT_EXT_GET_OLD_SUBMAP_NO},
    {_SET_RAIN_CHARA_NO, EVENT_EXT_SET_RAIN_CHARA_NO},
    {_GET_EDIT_PARTS_POS, EVENT_EXT_GET_EDIT_PARTS_POS},
    {_GET_CHARA_POS, EVENT_EXT_GET_CHARA_POS},
    {_GET_CHARA_TALK_POS, EVENT_EXT_GET_CHARA_TALK_POS},
    {_TURN_CHARA, EVENT_EXT_TURN_CHARA},
    {_SET_CHARA_POS, EVENT_EXT_SET_CHARA_POS},
    {_SET_CHARA_ROT, EVENT_EXT_SET_CHARA_ROT},
    {_GET_CHARA_ROT, EVENT_EXT_GET_CHARA_ROT},
    {_SET_MOTION, EVENT_EXT_SET_MOTION},
    {_SET_STEP, EVENT_EXT_SET_STEP},
    {_SET_TEX_ANIM, EVENT_EXT_SET_TEX_ANIM},
    {_SET_SCALE, EVENT_EXT_SET_SCALE},
    {_SET_REFERENCE, EVENT_EXT_SET_REFERENCE},
    {_DEL_REFERENCE, EVENT_EXT_DEL_REFERENCE},
    {_SHADOW_CLIP_OFF, EVENT_EXT_SHADOW_CLIP_OFF},
    {_GET_COORDINATE_ANGLE, EVENT_EXT_GET_COORDINATE_ANGLE},
    {_GET_CHARA_WIDTH, EVENT_EXT_GET_CHARA_WIDTH},
    {_GET_CHARA_HEIGHT, EVENT_EXT_GET_CHARA_HEIGHT},
    {_GET_CHARA_WEIGHT, EVENT_EXT_GET_CHARA_WEIGHT},
    {_SET_CHARA_SHOW, EVENT_EXT_SET_CHARA_SHOW},
    {_GET_CHARA_SHOW, EVENT_EXT_GET_CHARA_SHOW},
    {_CHARA_DA_ENABLE, EVENT_EXT_CHARA_DA_ENABLE},
    {_GET_MOT_NOW_WAIT, EVENT_EXT_GET_MOT_NOW_WAIT},
    {_CHECK_MOTION_END, EVENT_EXT_CHECK_MOTION_END},
    {_ACTCHR_SET_MOTION, EVENT_EXT_ACTCHR_SET_MOTION},
    {_SET_CHARA_EX_SOUNDID, EVENT_EXT_SET_CHARA_EX_SOUNDID},
    {_ACTCHR_SOUND_INFO_COPY, EVENT_EXT_ACTCHR_SOUND_INFO_COPY},
    {_MES_MAKE, EVENT_EXT_MES_MAKE},
    {_MES_CLOSE, EVENT_EXT_MES_CLOSE},
    {_MES_NEXTPAGE, EVENT_EXT_MES_NEXTPAGE},
    {_SET_MES_AUTOSET, EVENT_EXT_SET_MES_AUTOSET},
    {_SET_MES_SHIPPO, EVENT_EXT_SET_MES_SHIPPO},
    {_SET_MES_POS, EVENT_EXT_SET_MES_POS},
    {_SET_MES_DRAWSPEED, EVENT_EXT_SET_MES_DRAWSPEED},
    {_SET_MES_CURSOR, EVENT_EXT_SET_MES_CURSOR},
    {_SET_MES_OKURI, EVENT_EXT_SET_MES_OKURI},
    {_SET_MES_FUKIDASHI, EVENT_EXT_SET_MES_FUKIDASHI},
    {_CHECK_MES_COMPLETE, EVENT_EXT_CHECK_MES_COMPLETE},
    {_CHECK_MES_WAIT, EVENT_EXT_CHECK_MES_WAIT},
    {_CHECK_MES, EVENT_EXT_CHECK_MES},
    {_SET_MES_WIN_FLAG, EVENT_EXT_SET_MES_WIN_FLAG},
    {_SET_CAMERA_POS, EVENT_EXT_SET_CAMERA_POS},
    {_GET_CAMERA_POS, EVENT_EXT_GET_CAMERA_POS},
    {_SET_CAMERA_REF, EVENT_EXT_SET_CAMERA_REF},
    {_GET_CAMERA_REF, EVENT_EXT_GET_CAMERA_REF},
    {_SET_CAMERA_SPEED, EVENT_EXT_SET_CAMERA_SPEED},
    {_CAMERA_STEP, EVENT_EXT_CAMERA_STEP},
    {_SET_MES_WINDOW_MODE, EVENT_EXT_SET_MES_WINDOW_MODE},
    {_SET_MES_PRESET, EVENT_EXT_SET_MES_PRESET},
    {_SET_MES_ITEM_DIRECT, EVENT_EXT_SET_MES_ITEM_DIRECT},
    {_SET_MES_ITEM, EVENT_EXT_SET_MES_ITEM},
    {_SET_MES_VALUE, EVENT_EXT_SET_MES_VALUE},
    {_GET_MES_STATUS, EVENT_EXT_GET_MES_STATUS},
    {_GET_PARTY_CHARA_MES_NO, EVENT_EXT_GET_PARTY_CHARA_MES_NO},
    {_MES_SET_BUFF, EVENT_EXT_MES_SET_BUFF},
    {_GET_MES_WINDOW_MODE, EVENT_EXT_GET_MES_WINDOW_MODE},
    {_GET_MES_VOICE, EVENT_EXT_GET_MES_VOICE},
    {_SET_MES_QUESTION_GYOU, EVENT_EXT_SET_MES_QUESTION_GYOU},
    {_GET_MES_QUESTION_GYOU, EVENT_EXT_GET_MES_QUESTION_GYOU},
    {_SET_MES_CLOSE_CNT, EVENT_EXT_SET_MES_CLOSE_CNT},
    {_SET_MES_ETC, EVENT_EXT_SET_MES_ETC},
    {_GET_MES_ETC, EVENT_EXT_GET_MES_ETC},
    {_LOAD_MES, EVENT_EXT_LOAD_MES},
    {_MES_SE_PLAY, EVENT_EXT_MES_SE_PLAY},
    {_SET_MES_STR, EVENT_EXT_SET_MES_STR},
    {_GET_MES_OKURI, EVENT_EXT_GET_MES_OKURI},
    {_ASQ_INIT, EVENT_EXT_ASQ_INIT},
    {_ASQ_SYNC_CHARA, EVENT_EXT_ASQ_SYNC_CHARA},
    {_ASQ_SET_POS, EVENT_EXT_ASQ_SET_POS},
    {_ASQ_MOVE, EVENT_EXT_ASQ_MOVE},
    {_ASQ_MOVE_STEP, EVENT_EXT_ASQ_MOVE_STEP},
    {_ASQ_ROT_REF, EVENT_EXT_ASQ_ROT_REF},
    {_ASQ_CLEAR_ROT, EVENT_EXT_ASQ_CLEAR_ROT},
    {_ASQ_WAIT_ROT, EVENT_EXT_ASQ_WAIT_ROT},
    {_ASQ_ROT_MOVE, EVENT_EXT_ASQ_ROT_MOVE},
    {_ASQ_ROT_ANGLE, EVENT_EXT_ASQ_ROT_ANGLE},
    {_ASQ_SET_ROT, EVENT_EXT_ASQ_SET_ROT},
    {_ASQ_DELAY_ROT, EVENT_EXT_ASQ_DELAY_ROT},
    {_ASQ_CHECK, EVENT_EXT_ASQ_CHECK},
    {_ASQ_MOTION_TRG, EVENT_EXT_ASQ_MOTION_TRG},
    {_ASQ_MOTION_PLAY, EVENT_EXT_ASQ_MOTION_PLAY},
    {_ASQ_MOTION_STOP, EVENT_EXT_ASQ_MOTION_STOP},
    {_ASQ_MOTION_NEXT, EVENT_EXT_ASQ_MOTION_NEXT},
    {_ASQ_ANIME_TRG, EVENT_EXT_ASQ_ANIME_TRG},
    {_ASQ_ANIME, EVENT_EXT_ASQ_ANIME},
    {_ASQ_SE_PLAY, EVENT_EXT_ASQ_SE_PLAY},
    {_IMG_SET_DRAW, EVENT_EXT_IMG_SET_DRAW},
    {_IMG_SET_GET, EVENT_EXT_IMG_SET_GET},
    {_IMG_SET_PUT, EVENT_EXT_IMG_SET_PUT},
    {_IMG_SET_NAME, EVENT_EXT_IMG_SET_NAME},
    {_IMG_SET_MOVE, EVENT_EXT_IMG_SET_MOVE},
    {_IMG_SET_FADE, EVENT_EXT_IMG_SET_FADE},
    {_IMG_SET_COLOR, EVENT_EXT_IMG_SET_COLOR},
    {_SPRITE_INIT, EVENT_EXT_SPRITE_INIT},
    {_SPRITE_SET_DRAW, EVENT_EXT_SPRITE_SET_DRAW},
    {_SPRITE_SET_TYPE, EVENT_EXT_SPRITE_SET_TYPE},
    {_SPRITE_SET_TEXTURE, EVENT_EXT_SPRITE_SET_TEXTURE},
    {_SPRITE_SET_POS, EVENT_EXT_SPRITE_SET_POS},
    {_SPRITE_SET_PUTSIZE, EVENT_EXT_SPRITE_SET_PUTSIZE},
    {_SPRITE_SET_UVSIZE, EVENT_EXT_SPRITE_SET_UVSIZE},
    {_SPRITE_SET_COLOR, EVENT_EXT_SPRITE_SET_COLOR},
    {_SPRITE_SET_SCALE, EVENT_EXT_SPRITE_SET_SCALE},
    {_SPRITE_SET_ALPHAB, EVENT_EXT_SPRITE_SET_ALPHAB},
    {_CMRS_CHECK, EVENT_EXT_CMRS_CHECK},
    {_CMRS_INIT, EVENT_EXT_CMRS_INIT},
    {_CMRS_PRDELAY, EVENT_EXT_CMRS_PRDELAY},
    {_CMRS_SET_POS, EVENT_EXT_CMRS_SET_POS},
    {_CMRS_SET_REF, EVENT_EXT_CMRS_SET_REF},
    {_CMRS_MOVE, EVENT_EXT_CMRS_MOVE},
    {_CMRS_MOVE_REF, EVENT_EXT_CMRS_MOVE_REF},
    {_CMRS_INIT_PAS, EVENT_EXT_CMRS_INIT_PAS},
    {_CMRS_SET_PAS_FRM, EVENT_EXT_CMRS_SET_PAS_FRM},
    {_CMRS_ADD_PAS, EVENT_EXT_CMRS_ADD_PAS},
    {_CMRS_START_PAS, EVENT_EXT_CMRS_START_PAS},
    {_CMRS_PR_SLOWING, EVENT_EXT_CMRS_PR_SLOWING},
    {_CMRS_PR_KEEP, EVENT_EXT_CMRS_PR_KEEP},
    {_CMRS_PR_RETURN, EVENT_EXT_CMRS_PR_RETURN},
    {_CMRS_AHDDELAY, EVENT_EXT_CMRS_AHDDELAY},
    {_CMRS_SET_ANGLE, EVENT_EXT_CMRS_SET_ANGLE},
    {_CMRS_SET_HEIGHT, EVENT_EXT_CMRS_SET_HEIGHT},
    {_CMRS_SET_DIST, EVENT_EXT_CMRS_SET_DIST},
    {_CMRS_SET_AHD, EVENT_EXT_CMRS_SET_AHD},
    {_CMRS_MOVE_AHD, EVENT_EXT_CMRS_MOVE_AHD},
    {_CMRS_SYNC_OBJ, EVENT_EXT_CMRS_SYNC_OBJ},
    {_CMRS_RELEASE_OBJ, EVENT_EXT_CMRS_RELEASE_OBJ},
    {_CMRS_AHD_SLOWING, EVENT_EXT_CMRS_AHD_SLOWING},
    {_CMRS_AHD_KEEP, EVENT_EXT_CMRS_AHD_KEEP},
    {_CMRS_AHD_RETURN, EVENT_EXT_CMRS_AHD_RETURN},
    {_CMRS_FADE_DELAY, EVENT_EXT_CMRS_FADE_DELAY},
    {_CMRS_FADE_INIT, EVENT_EXT_CMRS_FADE_INIT},
    {_CMRS_FADE_IN, EVENT_EXT_CMRS_FADE_IN},
    {_CMRS_FADE_OUT, EVENT_EXT_CMRS_FADE_OUT},
    {_CMRS_QUAKE_DELAY, EVENT_EXT_CMRS_QUAKE_DELAY},
    {_CMRS_QUAKE, EVENT_EXT_CMRS_QUAKE},
    {_CMRS_MOVE2, EVENT_EXT_CMRS_MOVE2},
    {_CMRS_MOVE_AHD2, EVENT_EXT_CMRS_MOVE_AHD2},
    {_CMRS_CHARA_DELAY, EVENT_EXT_CMRS_CHARA_DELAY},
    {_CMRS_CHARA_ATTACH, EVENT_EXT_CMRS_CHARA_ATTACH},
    {_CMRS_MOVE_POS, EVENT_EXT_CMRS_MOVE_POS},
    {_CMRS_QUAKE2, EVENT_EXT_CMRS_QUAKE2},
    {_OBJS_CHECK, EVENT_EXT_OBJS_CHECK},
    {_OBJS_INIT, EVENT_EXT_OBJS_INIT},
    {_OBJS_SYNC_OBJ, EVENT_EXT_OBJS_SYNC_OBJ},
    {_OBJS_POS_DELAY, EVENT_EXT_OBJS_POS_DELAY},
    {_OBJS_SET_POS, EVENT_EXT_OBJS_SET_POS},
    {_OBJS_MOVE, EVENT_EXT_OBJS_MOVE},
    {_OBJS_MOVE2, EVENT_EXT_OBJS_MOVE2},
    {_OBJS_INIT_PAS, EVENT_EXT_OBJS_INIT_PAS},
    {_OBJS_SET_PAS_FRM, EVENT_EXT_OBJS_SET_PAS_FRM},
    {_OBJS_ADD_PAS, EVENT_EXT_OBJS_ADD_PAS},
    {_OBJS_START_PAS, EVENT_EXT_OBJS_START_PAS},
    {_OBJS_JUMP, EVENT_EXT_OBJS_JUMP},
    {_OBJS_SET_EOH_FRAME_POS, EVENT_EXT_OBJS_SET_EOH_FRAME_POS},
    {_OBJS_ADD_POS, EVENT_EXT_OBJS_ADD_POS},
    {_OBJS_ATTACH_CAMERA, EVENT_EXT_OBJS_ATTACH_CAMERA},
    {_OBJS_ROT_DELAY, EVENT_EXT_OBJS_ROT_DELAY},
    {_OBJS_SET_ROT, EVENT_EXT_OBJS_SET_ROT},
    {_OBJS_ROTATION, EVENT_EXT_OBJS_ROTATION},
    {_OBJS_ROTATION2, EVENT_EXT_OBJS_ROTATION2},
    {_OBJS_REFERENCE, EVENT_EXT_OBJS_REFERENCE},
    {_OBJS_MOTION_DELAY, EVENT_EXT_OBJS_MOTION_DELAY},
    {_OBJS_SET_MOTION, EVENT_EXT_OBJS_SET_MOTION},
    {_OBJS_NEXT_MOTION, EVENT_EXT_OBJS_NEXT_MOTION},
    {_OBJS_MOTION_WAIT, EVENT_EXT_OBJS_MOTION_WAIT},
    {_OBJS_SET_STEP, EVENT_EXT_OBJS_SET_STEP},
    {_OBJS_CHENGE_STEP, EVENT_EXT_OBJS_CHENGE_STEP},
    {_OBJS_SEQ_MOT_TRG, EVENT_EXT_OBJS_SEQ_MOT_TRG},
    {_OBJS_SEQ_MOT_TRG_WAIT, EVENT_EXT_OBJS_SEQ_MOT_TRG_WAIT},
    {_OBJS_RESET_MOTION, EVENT_EXT_OBJS_RESET_MOTION},
    {_OBJS_SET_MOTION_NOW_TIME, EVENT_EXT_OBJS_SET_MOTION_NOW_TIME},
    {_OBJS_SET_MOTION_WAIT_TIME, EVENT_EXT_OBJS_SET_MOTION_WAIT_TIME},
    {_OBJS_TEXA_DELAY, EVENT_EXT_OBJS_TEXA_DELAY},
    {_OBJS_TEX_ANIME, EVENT_EXT_OBJS_TEX_ANIME},
    {_OBJS_COLOR_DELAY, EVENT_EXT_OBJS_COLOR_DELAY},
    {_OBJS_SET_COLOR, EVENT_EXT_OBJS_SET_COLOR},
    {_OBJS_SCALE_DELAY, EVENT_EXT_OBJS_SCALE_DELAY},
    {_OBJS_SET_SCALE, EVENT_EXT_OBJS_SET_SCALE},
    {_OBJS_SE_DELAY, EVENT_EXT_OBJS_SE_DELAY},
    {_OBJS_SE_PLAY, EVENT_EXT_OBJS_SE_PLAY},
    {_OBJS_RESET_DA_POSITION, EVENT_EXT_OBJS_RESET_DA_POSITION},
    {_OBJS_NORMAL_DRIVE, EVENT_EXT_OBJS_NORMAL_DRIVE},
    {_GET_CONTENTS_POS, EVENT_EXT_GET_CONTENTS_POS},
    {_GET_BPOT_POS, EVENT_EXT_GET_BPOT_POS},
    {_GET_BPOT_STATUS, EVENT_EXT_GET_BPOT_STATUS},
    {_GET_PERSON_STATUS, EVENT_EXT_GET_PERSON_STATUS},
    {_GET_CONTROL_CHRID, EVENT_EXT_GET_CONTROL_CHRID},
    {_GET_BEFORE_CAMERA_POS, EVENT_EXT_GET_BEFORE_CAMERA_POS},
    {_GET_BEFORE_CAMERA_REF, EVENT_EXT_GET_BEFORE_CAMERA_REF},
    {_SET_CAMERA_NEXT_REF, EVENT_EXT_SET_CAMERA_NEXT_REF},
    {_GOTO_MENU, EVENT_EXT_GOTO_MENU},
    {_GET_MENU_STATUS, EVENT_EXT_GET_MENU_STATUS},
    {_LOAD_EQUIP, EVENT_EXT_LOAD_EQUIP},
    {_GET_EQUIP_ITEMNO, EVENT_EXT_GET_EQUIP_ITEMNO},
    {_SET_TIME_STEP_ENABLE, EVENT_EXT_SET_TIME_STEP_ENABLE},
    {_SET_DOOR_MATERIAL, EVENT_EXT_SET_DOOR_MATERIAL},
    {_INIT_DRAMA_SCENE, EVENT_EXT_INIT_DRAMA_SCENE},
    {_SET_ACTIVE_CMRID, EVENT_EXT_SET_ACTIVE_CMRID},
    {_SET_BEFORE_CMRID, EVENT_EXT_SET_BEFORE_CMRID},
    {_DNGMAP_LOAD, EVENT_EXT_DNGMAP_LOAD},
    {_DNGMAP_DELETE, EVENT_EXT_DNGMAP_DELETE},
    {_DNGMAP_MOVE_PIECE, EVENT_EXT_DNGMAP_MOVE_PIECE},
    {_DNGMAP_ONOFF, EVENT_EXT_DNGMAP_ONOFF},
    {_DNGMAP_SET_FADE, EVENT_EXT_DNGMAP_SET_FADE},
    {_GET_BEFORE_CAMERA_NEXT_POS, EVENT_EXT_GET_BEFORE_CAMERA_NEXT_POS},
    {_GET_BEFORE_CAMERA_NEXT_REF, EVENT_EXT_GET_BEFORE_CAMERA_NEXT_REF},
    {_SET_CAMERA_NEXT_POS, EVENT_EXT_SET_CAMERA_NEXT_POS},
    {_CHK_INTERSECTION_POINT, EVENT_EXT_CHK_INTERSECTION_POINT},
    {_SET_FCAMERA_FOLLOW, EVENT_EXT_SET_FCAMERA_FOLLOW},
    {_SET_FCAMERA_FOLLOW_A, EVENT_EXT_SET_FCAMERA_FOLLOW_A},
    {_SET_FCAMERA_FOLLOW_OFS, EVENT_EXT_SET_FCAMERA_FOLLOW_OFS},
    {_SET_FCAMERA_FOLLOW_FLAG, EVENT_EXT_SET_FCAMERA_FOLLOW_FLAG},
    {_FCAMERA_STEP, EVENT_EXT_FCAMERA_STEP},
    {_SET_FCAMERA_ANGLE, EVENT_EXT_SET_FCAMERA_ANGLE},
    {_SET_FCAMERA_HEIGHT, EVENT_EXT_SET_FCAMERA_HEIGHT},
    {_SET_FCAMERA_DIST, EVENT_EXT_SET_FCAMERA_DIST},
    {_GET_REF_ANGLE, EVENT_EXT_GET_REF_ANGLE},
    {_DNG_SET_STAGE_ID, EVENT_EXT_DNG_SET_STAGE_ID},
    {_DNG_GET_STAGE_ID, EVENT_EXT_DNG_GET_STAGE_ID},
    {_SET_CAMERA_CTRL, EVENT_EXT_SET_CAMERA_CTRL},
    {_GET_FCAMERA_ANGLE, EVENT_EXT_GET_FCAMERA_ANGLE},
    {_GET_FCAMERA_HEIGHT, EVENT_EXT_GET_FCAMERA_HEIGHT},
    {_GET_FCAMERA_DIST, EVENT_EXT_GET_FCAMERA_DIST},
    {_GET_INVENTION_ID, EVENT_EXT_GET_INVENTION_ID},
    {_FUNCTION_MAP_JUMP, EVENT_EXT_FUNCTION_MAP_JUMP},
    {_FUNCTION_DOOR_MODE, EVENT_EXT_FUNCTION_DOOR_MODE},
    {_GET_MONEY, EVENT_EXT_GET_MONEY},
    {_ADD_MONEY, EVENT_EXT_ADD_MONEY},
    {_GET_ITEM_NUM, EVENT_EXT_GET_ITEM_NUM},
    {_CHECK_BUTTON, EVENT_EXT_CHECK_BUTTON},
    {_GET_LANGUAGE, EVENT_EXT_GET_LANGUAGE},
    {_CHECK_INVENT_ITEM, EVENT_EXT_CHECK_INVENT_ITEM},
    {_SET_AI, EVENT_EXT_SET_AI},
    {_CHECK_INVENT_PHOTO, EVENT_EXT_CHECK_INVENT_PHOTO},
    {_GET_PHOTO_NUM, EVENT_EXT_GET_PHOTO_NUM},
    {_SET_CONTENTS_ETC, EVENT_EXT_SET_CONTENTS_ETC},
    {_SET_STATUS, EVENT_EXT_SET_STATUS},
    {_GOTO_SUBGAME, EVENT_EXT_GOTO_SUBGAME},
    {_SET_GYORACE_ETC, EVENT_EXT_SET_GYORACE_ETC},
    {_GET_GYORACE_ETC, EVENT_EXT_GET_GYORACE_ETC},
    {_SET_SAVEDATA_ETC, EVENT_EXT_SET_SAVEDATA_ETC},
    {_GET_SAVEDATA_ETC, EVENT_EXT_GET_SAVEDATA_ETC},
    {_DEL_MONSTER, EVENT_EXT_DEL_MONSTER},
    {_SET_MENU_ETC, EVENT_EXT_SET_MENU_ETC},
    {_GET_MENU_ETC, EVENT_EXT_GET_MENU_ETC},
    {_GET_ANALYZE, EVENT_EXT_GET_ANALYZE},
    {_GET_DIORAMA_PERCENT, EVENT_EXT_GET_DIORAMA_PERCENT},
    {_GEORAMA_FUNC, EVENT_EXT_GEORAMA_FUNC},
    {_GET_CHARA_ID, EVENT_EXT_GET_CHARA_ID},
    {_SET_LOADBG_FILE_MONS_TALK, EVENT_EXT_SET_LOADBG_FILE_MONS_TALK},
    {_LOAD_MES_MONS_TALK, EVENT_EXT_LOAD_MES_MONS_TALK},
    {_GOTO_EDITMODE, EVENT_EXT_GOTO_EDITMODE},
    {_GET_CHAPTER, EVENT_EXT_GET_CHAPTER},
    {_GET_NPC_TRAIN_ETC, EVENT_EXT_GET_NPC_TRAIN_ETC},
    {_REGISTER_VILLAGER, EVENT_EXT_REGISTER_VILLAGER},
    {_EYE_VIEW_DRAW_ON_OFF, EVENT_EXT_EYE_VIEW_DRAW_ON_OFF},
    {_SET_QUEST_ETC, EVENT_EXT_SET_QUEST_ETC},
    {_GET_QUEST_ETC, EVENT_EXT_GET_QUEST_ETC},
    {_CHK_INTERSECTION_POINT_PIPE, EVENT_EXT_CHK_INTERSECTION_POINT_PIPE},
    {_GET_OLD_INTERIOR_MAP_NO, EVENT_EXT_GET_OLD_INTERIOR_MAP_NO},
    {_SET_EVENT_DATA, EVENT_EXT_SET_EVENT_DATA},
    {_STOPWATCH, EVENT_EXT_STOPWATCH},
    {_SET_FUNC_ETC, EVENT_EXT_SET_FUNC_ETC},
    {_GET_FISHINGTOURNAMENT_ETC, EVENT_EXT_GET_FISHINGTOURNAMENT_ETC},
    {_SET_CHARA_FAR_DIST, EVENT_EXT_SET_CHARA_FAR_DIST},
    {_SET_MODEL_LIGHT_SWITCH, EVENT_EXT_SET_MODEL_LIGHT_SWITCH},
    {_SET_MODEL_LIGHT_COLOR, EVENT_EXT_SET_MODEL_LIGHT_COLOR},
    {_GET_OMAKE_FLAG, EVENT_EXT_GET_OMAKE_FLAG},
    {_SET_WIND, EVENT_EXT_SET_WIND},
    {_SET_OMAKE_FLAG, EVENT_EXT_SET_OMAKE_FLAG},
    {_SND_INIT_PORT, EVENT_EXT_SND_INIT_PORT},
    {_SND_LOAD_SOUND, EVENT_EXT_SND_LOAD_SOUND},
    {_SND_SE_PLAY, EVENT_EXT_SND_SE_PLAY},
    {_GET_SND_ID, EVENT_EXT_GET_SND_ID},
    {_SND_SE_PAUSE, EVENT_EXT_SND_SE_PAUSE},
    {_SND_SE_STOP, EVENT_EXT_SND_SE_STOP},
    {_SND_SET_SE_VOL, EVENT_EXT_SND_SET_SE_VOL},
    {_SND_SET_SE_PAN, EVENT_EXT_SND_SET_SE_PAN},
    {_SND_SET_SE_PITCH, EVENT_EXT_SND_SET_SE_PITCH},
    {_SND_SE_ALL_STOP, EVENT_EXT_SND_SE_ALL_STOP},
    {_LOAD_BGM, EVENT_EXT_LOAD_BGM},
    {_PLAY_BGM, EVENT_EXT_PLAY_BGM},
    {_STOP_BGM, EVENT_EXT_STOP_BGM},
    {_STREAM_OPEN, EVENT_EXT_STREAM_OPEN},
    {_STREAM_PLAY, EVENT_EXT_STREAM_PLAY},
    {_STREAM_STOP, EVENT_EXT_STREAM_STOP},
    {_STREAM_STANDBY, EVENT_EXT_STREAM_STANDBY},
    {_STREAM_GET_STATUS, EVENT_EXT_STREAM_GET_STATUS},
    {_GET_SYS_SND_ID, EVENT_EXT_GET_SYS_SND_ID},
    {_STREAM_OPEN_CHECK, EVENT_EXT_STREAM_OPEN_CHECK},
    {_LOAD_SE_ENV, EVENT_EXT_LOAD_SE_ENV},
    {_PLAY_ENV_BGM, EVENT_EXT_PLAY_ENV_BGM},
    {_SYS_SE_PLAY, EVENT_EXT_SYS_SE_PLAY},
    {_INIT_SE_SRC, EVENT_EXT_INIT_SE_SRC},
    {_INIT_SE_ENV, EVENT_EXT_INIT_SE_ENV},
    {_INIT_SE_BAS, EVENT_EXT_INIT_SE_BAS},
    {_LOAD_SE_SRC, EVENT_EXT_LOAD_SE_SRC},
    {_LOAD_SE_FOOT, EVENT_EXT_LOAD_SE_FOOT},
    {_LOAD_SE_DOOR, EVENT_EXT_LOAD_SE_DOOR},
    {_LOAD_SE_BOX, EVENT_EXT_LOAD_SE_BOX},
    {_LOAD_SE_BATTLE, EVENT_EXT_LOAD_SE_BATTLE},
    {_SND_DELETE_PORT, EVENT_EXT_SND_DELETE_PORT},
    {_STOP_ENV_BGM, EVENT_EXT_STOP_ENV_BGM},
    {_FADE_IN_BGM, EVENT_EXT_FADE_IN_BGM},
    {_FADE_OUT_BGM, EVENT_EXT_FADE_OUT_BGM},
    {_SET_BGM_VOL, EVENT_EXT_SET_BGM_VOL},
    {_SND_SET_REVERB, EVENT_EXT_SND_SET_REVERB},
    {_SND_SET_ENV_VOL, EVENT_EXT_SND_SET_ENV_VOL},
    {_STREAM_SILENT_CHECK, EVENT_EXT_STREAM_SILENT_CHECK},
    {_AUTO_CHANGE_ENV, EVENT_EXT_AUTO_CHANGE_ENV},
    {_BGM_LOAD_CANCEL, EVENT_EXT_BGM_LOAD_CANCEL},
    {_SOUND_LOAD_CANCEL, EVENT_EXT_SOUND_LOAD_CANCEL},
    {_BGM_LOAD_ENABLE, EVENT_EXT_BGM_LOAD_ENABLE},
    {_SOUND_LOAD_ENABLE, EVENT_EXT_SOUND_LOAD_ENABLE},
    {_LOAD_SE_BASE, EVENT_EXT_LOAD_SE_BASE},
    {_LOAD_SOUND, EVENT_EXT_LOAD_SOUND},
    {_STREAM_CLOSE, EVENT_EXT_STREAM_CLOSE},
    {_STREAM_OPEN2, EVENT_EXT_STREAM_OPEN2},
    {_LOAD_BGM_PACK, EVENT_EXT_LOAD_BGM_PACK},
    {_GET_BGM_NO, EVENT_EXT_GET_BGM_NO},
    {_GET_MASTER_VOL, EVENT_EXT_GET_MASTER_VOL},
    {_SET_MASTER_VOL, EVENT_EXT_SET_MASTER_VOL},
    {_GET_BTL_BGM_VOL, EVENT_EXT_GET_BTL_BGM_VOL},
    {_SET_BTL_BGM_VOL, EVENT_EXT_SET_BTL_BGM_VOL},
    {_SND_IN_REVERB, EVENT_EXT_SND_IN_REVERB},
    {_SND_STOP_SRC, EVENT_EXT_SND_STOP_SRC},
    {_SND_PAUSE_BGM, EVENT_EXT_SND_PAUSE_BGM},
    {_STREAM_OPEN3, EVENT_EXT_STREAM_OPEN3},
    {_GET_ACTIVE_BGM_STATUS, EVENT_EXT_GET_ACTIVE_BGM_STATUS},
    {_SET_ACTIVE_BGM_STATUS, EVENT_EXT_SET_ACTIVE_BGM_STATUS},
    {_GET_BGM_STATUS_NOW_NO, EVENT_EXT_GET_BGM_STATUS_NOW_NO},
    {_GET_SE_STATUS, EVENT_EXT_GET_SE_STATUS},
    {_SE_ALL_STOP, EVENT_EXT_SE_ALL_STOP},
    {_SOUND_ALL_STOP, EVENT_EXT_SOUND_ALL_STOP},
    {_BGM_PLAY_CANCEL, EVENT_EXT_BGM_PLAY_CANCEL},
    {_BGM_PLAY_ENABLE, EVENT_EXT_BGM_PLAY_ENABLE},
    {_GET_DEF_BGM_NO, EVENT_EXT_GET_DEF_BGM_NO},
    {_SET_MOVIE_CC, EVENT_EXT_SET_MOVIE_CC},
    {_REGISTER_VILLAGER2, EVENT_EXT_REGISTER_VILLAGER2},
    {_SET_FISHINGTOURNAMENT_ETC, EVENT_EXT_SET_FISHINGTOURNAMENT_ETC},
    {_EOH_SYNC_CHARA, EVENT_EXT_EOH_SYNC_CHARA},
    {_EOH_SYNC_OBJ, EVENT_EXT_EOH_SYNC_OBJ},
    {_EOH_SET_POS, EVENT_EXT_EOH_SET_POS},
    {_EOH_SET_ROT, EVENT_EXT_EOH_SET_ROT},
    {_EOH_GET_POS, EVENT_EXT_EOH_GET_POS},
    {_EOH_GET_ROT, EVENT_EXT_EOH_GET_ROT},
    {_EOH_SET_MOTION, EVENT_EXT_EOH_SET_MOTION},
    {_EOH_SET_STEP, EVENT_EXT_EOH_SET_STEP},
    {_EOH_SET_TEX_ANIM, EVENT_EXT_EOH_SET_TEX_ANIM},
    {_EOH_SET_SCALE, EVENT_EXT_EOH_SET_SCALE},
    {_EOH_SET_SHOW, EVENT_EXT_EOH_SET_SHOW},
    {_EOH_GET_SHOW, EVENT_EXT_EOH_GET_SHOW},
    {_EOH_SET_FRAME_SHOW, EVENT_EXT_EOH_SET_FRAME_SHOW},
    {_EOH_SET_SHADOW, EVENT_EXT_EOH_SET_SHADOW},
    {_EOH_SET_TRANSLATE, EVENT_EXT_EOH_SET_TRANSLATE},
    {_EOH_SYNC_SPRITE, EVENT_EXT_EOH_SYNC_SPRITE},
    {_EOH_SET_FOOT_SOUND_ID, EVENT_EXT_EOH_SET_FOOT_SOUND_ID},
    {_EOH_SET_FRAME_STATUS, EVENT_EXT_EOH_SET_FRAME_STATUS},
    {_EOH_GET_FRAME_POS, EVENT_EXT_EOH_GET_FRAME_POS},
    {_EOH_SET_SOUND_ID, EVENT_EXT_EOH_SET_SOUND_ID},
    {_EOH_GET_FRAME_STATUS, EVENT_EXT_EOH_GET_FRAME_STATUS},
    {_EOH_SYNC_CHROBJ, EVENT_EXT_EOH_SYNC_CHROBJ},
    {_EOH_SET_FADE_FLAG, EVENT_EXT_EOH_SET_FADE_FLAG},
    {_EOH_RESET_DA_POSITION, EVENT_EXT_EOH_RESET_DA_POSITION},
    {_EOH_SET_SHADOW_FRAME_STATUS, EVENT_EXT_EOH_SET_SHADOW_FRAME_STATUS},
    {_EOH_SYNC_GEOSTONE, EVENT_EXT_EOH_SYNC_GEOSTONE},
    {_EOH_SYNC_SEARCH_CHARA, EVENT_EXT_EOH_SYNC_SEARCH_CHARA},
    {_EOH_NORMAL_DRIVE, EVENT_EXT_EOH_NORMAL_DRIVE},
    {_EOH_SYNC_EDIT_OBJ, EVENT_EXT_EOH_SYNC_EDIT_OBJ},
    {_EOH_SET_FRAME_ALPHA, EVENT_EXT_EOH_SET_FRAME_ALPHA},
    {_EOH_SYNC_FUNCP, EVENT_EXT_EOH_SYNC_FUNCP},
    {_EOH_SET_FOOT_SE_ID, EVENT_EXT_EOH_SET_FOOT_SE_ID},
    {_EOH_SYNC_DOOR_PARTS, EVENT_EXT_EOH_SYNC_DOOR_PARTS},
    {_SPHIDA_INIT, EVENT_EXT_SPHIDA_INIT},
    {_SPHIDA_SET_UP, EVENT_EXT_SPHIDA_SET_UP},
    {_SPHIDA_SET_PLAY_FLAG, EVENT_EXT_SPHIDA_SET_PLAY_FLAG},
    {_SPHIDA_SET_MINIMAP_FLAG, EVENT_EXT_SPHIDA_SET_MINIMAP_FLAG},
    {_SPHIDA_SET_MM_LINE_FLAG, EVENT_EXT_SPHIDA_SET_MM_LINE_FLAG},
    {_SPHIDA_SET_MM_LINE_POS, EVENT_EXT_SPHIDA_SET_MM_LINE_POS},
    {_SPHIDA_SET_PIN_POS, EVENT_EXT_SPHIDA_SET_PIN_POS},
    {_SPHIDA_GET_PIN_POS, EVENT_EXT_SPHIDA_GET_PIN_POS},
    {_SPHIDA_SET_BALL_POS, EVENT_EXT_SPHIDA_SET_BALL_POS},
    {_SPHIDA_GET_BALL_POS, EVENT_EXT_SPHIDA_GET_BALL_POS},
    {_SPHIDA_SET_PIN_COL, EVENT_EXT_SPHIDA_SET_PIN_COL},
    {_SPHIDA_GET_PIN_COL, EVENT_EXT_SPHIDA_GET_PIN_COL},
    {_SPHIDA_SET_BALL_COL, EVENT_EXT_SPHIDA_SET_BALL_COL},
    {_SPHIDA_GET_BALL_COL, EVENT_EXT_SPHIDA_GET_BALL_COL},
    {_SPHIDA_SET_PAR_COUNT, EVENT_EXT_SPHIDA_SET_PAR_COUNT},
    {_SPHIDA_GET_PAR_COUNT, EVENT_EXT_SPHIDA_GET_PAR_COUNT},
    {_SPHIDA_GET_MINI_LEVEL, EVENT_EXT_SPHIDA_GET_MINI_LEVEL},
    {_SPHIDA_GET_TEXB, EVENT_EXT_SPHIDA_GET_TEXB},
    {_SPHIDA_SET_STATUS_FLAG, EVENT_EXT_SPHIDA_SET_STATUS_FLAG},
    {_SPHIDA_RESET_POWGAGE, EVENT_EXT_SPHIDA_RESET_POWGAGE},
    {_SPHIDA_START_POWGAGE, EVENT_EXT_SPHIDA_START_POWGAGE},
    {_SPHIDA_TRIGGER_POWGAGE, EVENT_EXT_SPHIDA_TRIGGER_POWGAGE},
    {_SPHIDA_GET_SHOT_POW, EVENT_EXT_SPHIDA_GET_SHOT_POW},
    {_SPHIDA_GET_POWGAGE_CODE, EVENT_EXT_SPHIDA_GET_POWGAGE_CODE},
    {_SPHIDA_SET_POWGAGE_SAFE_LEVEL, EVENT_EXT_SPHIDA_SET_POWGAGE_SAFE_LEVEL},
    {_SPHIDA_GET_CULB_DEF, EVENT_EXT_SPHIDA_GET_CULB_DEF},
    {_SPHIDA_SET_SPIN_MARK_POS, EVENT_EXT_SPHIDA_SET_SPIN_MARK_POS},
    {_SPHIDA_SET_CULB_NO, EVENT_EXT_SPHIDA_SET_CULB_NO},
    {_SPHIDA_CALC_CARRY, EVENT_EXT_SPHIDA_CALC_CARRY},
    {_SPHIDA_GET_PG_CURSOR_POS, EVENT_EXT_SPHIDA_GET_PG_CURSOR_POS},
    {_SPHIDA_SET_COL_MODEL, EVENT_EXT_SPHIDA_SET_COL_MODEL},
    {_SPHIDA_GET_PRIZE, EVENT_EXT_SPHIDA_GET_PRIZE},
    {_SPHIDA_SET_LAST_CHALLENGE, EVENT_EXT_SPHIDA_SET_LAST_CHALLENGE},
    {_SPHIDA_GET_LAST_CHALLENGE, EVENT_EXT_SPHIDA_GET_LAST_CHALLENGE},
    {_SPHIDA_GET_OMAKE_MODE, EVENT_EXT_SPHIDA_GET_OMAKE_MODE},
    {_SPHIDA_SET_NOW_HOLE, EVENT_EXT_SPHIDA_SET_NOW_HOLE},
    {_SPHIDA_GET_NOW_HOLE, EVENT_EXT_SPHIDA_GET_NOW_HOLE},
    {_SPHIDA_SET_SCORE, EVENT_EXT_SPHIDA_SET_SCORE},
    {_SPHIDA_GET_SCORE, EVENT_EXT_SPHIDA_GET_SCORE},
    {_ZERO_VECTOR, EVENT_EXT_ZERO_VECTOR},
    {_NORMAL_VECTOR, EVENT_EXT_NORMAL_VECTOR},
    {_COPY_VECTOR, EVENT_EXT_COPY_VECTOR},
    {_ADD_VECTOR, EVENT_EXT_ADD_VECTOR},
    {_SUB_VECTOR, EVENT_EXT_SUB_VECTOR},
    {_SCALE_VECTOR, EVENT_EXT_SCALE_VECTOR},
    {_DIV_VECTOR, EVENT_EXT_DIV_VECTOR},
    {_DIST_VECTOR, EVENT_EXT_DIST_VECTOR},
    {_DIST_VECTOR2, EVENT_EXT_DIST_VECTOR2},
    {_SQRT, EVENT_EXT_SQRT},
    {_ATAN2F, EVENT_EXT_ATAN2F},
    {_ANGLE_CMP, EVENT_EXT_ANGLE_CMP},
    {_ANGLE_LIMIT, EVENT_EXT_ANGLE_LIMIT},
    {_GET_RAND, EVENT_EXT_GET_RAND},
    {_LINE_POINT_DIST, EVENT_EXT_LINE_POINT_DIST},
    {_CREATE_SWORD_EFFECT, EVENT_EXT_CREATE_SWORD_EFFECT},
    {_DELETE_SWORD_EFFECT, EVENT_EXT_DELETE_SWORD_EFFECT},
    {_SWORD_EFFECT_COLOR, EVENT_EXT_SWORD_EFFECT_COLOR},
    {_SWORD_EFFECT_ADD_POINT, EVENT_EXT_SWORD_EFFECT_ADD_POINT},
    {_ADD_CHARA_POS, EVENT_EXT_ADD_CHARA_POS},
    {_ADD_CHARA_ROT, EVENT_EXT_ADD_CHARA_ROT},
    {_POST_TREASURE_BOX, EVENT_EXT_POST_TREASURE_BOX},
    {_GET_PARTS_ORIGIN, EVENT_EXT_GET_PARTS_ORIGIN},
    {_CTRLC_STEP, EVENT_EXT_CTRLC_STEP},
    {_CTRLC_SET_ROTATE, EVENT_EXT_CTRLC_SET_ROTATE},
    {_CTRLC_MOVE_CAMERA, EVENT_EXT_CTRLC_MOVE_CAMERA},
    {_CTRLC_SET_ROT_CANCEL, EVENT_EXT_CTRLC_SET_ROT_CANCEL},
    {_CTRLC_MOVE_RANGE, EVENT_EXT_CTRLC_MOVE_RANGE},
    {_GET_NEAR_TBOX_POS, EVENT_EXT_GET_NEAR_TBOX_POS},
    {_CONV_CHRNO_S2L, EVENT_EXT_CONV_CHRNO_S2L},
    {_SWE_INIT, EVENT_EXT_SWE_INIT},
    {_SWE_SET_COLOR, EVENT_EXT_SWE_SET_COLOR},
    {_SWE_SET_TEXTURE, EVENT_EXT_SWE_SET_TEXTURE},
    {_SWE_START_EFFECT, EVENT_EXT_SWE_START_EFFECT},
    {_SET_CHARA_TYPE, EVENT_EXT_SET_CHARA_TYPE},
    {_GET_EVENT_DATA, EVENT_EXT_GET_EVENT_DATA},
    {_DNG_SET_PREV_FLOOR, EVENT_EXT_DNG_SET_PREV_FLOOR},
    {_DNG_GET_PREV_FLOOR, EVENT_EXT_DNG_GET_PREV_FLOOR},
    {_DNG_SET_FAST_FLOOR, EVENT_EXT_DNG_SET_FAST_FLOOR},
    {_SET_FLOOR_INFO, EVENT_EXT_SET_FLOOR_INFO},
    {_GET_FLOOR_INFO, EVENT_EXT_GET_FLOOR_INFO},
    {_GET_NEXT_FLOOR, EVENT_EXT_GET_NEXT_FLOOR},
    {_PAD_AUTO_REPEAT_OFF, EVENT_EXT_PAD_AUTO_REPEAT_OFF},
    {_PAD_SET_AUTO_REPEAT, EVENT_EXT_PAD_SET_AUTO_REPEAT},
    {_DNG_PAUSE, EVENT_EXT_DNG_PAUSE},
    {_DNG_CHECK_PAUSE, EVENT_EXT_DNG_CHECK_PAUSE},
    {_DNG_RESET_TIMER, EVENT_EXT_DNG_RESET_TIMER},
    {_DNG_GET_TIMER, EVENT_EXT_DNG_GET_TIMER},
    {_LOAD_SKIN, EVENT_EXT_LOAD_SKIN},
    {_CHK_CAMERA_COL, EVENT_EXT_CHK_CAMERA_COL},
    {_GET_PARTS_FUNC_POS, EVENT_EXT_GET_PARTS_FUNC_POS},
    {_RANDOM_CIRCLE_GET_POS, EVENT_EXT_RANDOM_CIRCLE_GET_POS},
    {_RANDOM_CIRCLE_OFF, EVENT_EXT_RANDOM_CIRCLE_OFF},
    {_DNG_XCHG_MAP_LIGHT, EVENT_EXT_DNG_XCHG_MAP_LIGHT},
    {_GEOSTONE_ANIME_OFF, EVENT_EXT_GEOSTONE_ANIME_OFF},
    {_GEOSTONE_SET_FLAG, EVENT_EXT_GEOSTONE_SET_FLAG},
    {_GEOSTONE_SET_REFERENCE, EVENT_EXT_GEOSTONE_SET_REFERENCE},
    {_GEOSTONE_DEL_REFERENCE, EVENT_EXT_GEOSTONE_DEL_REFERENCE},
    {_GET_ROBO_MOVE_TYPE, EVENT_EXT_GET_ROBO_MOVE_TYPE},
    {_SET_EXIT_FLAG, EVENT_EXT_SET_EXIT_FLAG},
    {_GET_EXIT_FLAG, EVENT_EXT_GET_EXIT_FLAG},
    {_GET_E3_VERSION, EVENT_EXT_GET_E3_VERSION},
    {_CHK_PAD_CTRL, EVENT_EXT_CHK_PAD_CTRL},
    {_CTRLC_STAY, EVENT_EXT_CTRLC_STAY},
    {_BSCN_SET_BLIGHT_RATE, EVENT_EXT_BSCN_SET_BLIGHT_RATE},
    {_GET_RND_CIRCLE_TRAPID, EVENT_EXT_GET_RND_CIRCLE_TRAPID},
    {_SET_RND_CIRCLE_STATUS, EVENT_EXT_SET_RND_CIRCLE_STATUS},
    {_SET_STATUSBAR_SHOW, EVENT_EXT_SET_STATUSBAR_SHOW},
    {_SET_PULL_ITEM, EVENT_EXT_SET_PULL_ITEM},
    {_MENU_CHARA_CHENGE, EVENT_EXT_MENU_CHARA_CHENGE},
    {_GET_EVENT_INFO_SNDID, EVENT_EXT_GET_EVENT_INFO_SNDID},
    {_GET_PARTS_POS, EVENT_EXT_GET_PARTS_POS},
    {_CANCEL_DRAMA_SCENE, EVENT_EXT_CANCEL_DRAMA_SCENE},
    {_GET_RNDC_MOT_NOWT, EVENT_EXT_GET_RNDC_MOT_NOWT},
    {_SET_CHARA_MOT_NOWT, EVENT_EXT_SET_CHARA_MOT_NOWT},
    {_CHARA_NORMAL_DRIVE, EVENT_EXT_CHARA_NORMAL_DRIVE},
    {_CHARA_RESET_DA, EVENT_EXT_CHARA_RESET_DA},
    {_DNG_SETUP_MAIN_UNIT, EVENT_EXT_DNG_SETUP_MAIN_UNIT},
    {_JOIN_PARTY_MEMBER, EVENT_EXT_JOIN_PARTY_MEMBER},
    {_SET_CHARA_CHANGE_FLAG, EVENT_EXT_SET_CHARA_CHANGE_FLAG},
    {_SET_CHARA_CHANGE_MASK, EVENT_EXT_SET_CHARA_CHANGE_MASK},
    {_CHANGE_DIR, EVENT_EXT_CHANGE_DIR},
    {_SUB_ITEM, EVENT_EXT_SUB_ITEM},
    {_SET_CHARA_EQUIP, EVENT_EXT_SET_CHARA_EQUIP},
    {_LOAD_PACK_FILE, EVENT_EXT_LOAD_PACK_FILE},
    {_SET_BIT_CTRL, EVENT_EXT_SET_BIT_CTRL},
    {_GET_BIT_CTRL, EVENT_EXT_GET_BIT_CTRL},
    {_LOAD_ARG, EVENT_EXT_LOAD_ARG},
    {_GET_ITEM_HAVE_NUM, EVENT_EXT_GET_ITEM_HAVE_NUM},
    {_SET_SKIP_BOTTON, EVENT_EXT_SET_SKIP_BOTTON},
    {_SET_SKIP_FCOL, EVENT_EXT_SET_SKIP_FCOL},
    {_GET_DEBUG_MODE, EVENT_EXT_GET_DEBUG_MODE},
    {_GET_MAP_TYPE, EVENT_EXT_GET_MAP_TYPE},
    {_DNG_COLLISION_ALL_CLR, EVENT_EXT_DNG_COLLISION_ALL_CLR},
    {_SET_MAP_DRAW, EVENT_EXT_SET_MAP_DRAW},
    {_CHECK_MC_LOAD, EVENT_EXT_CHECK_MC_LOAD},
    {_SET_NOW_MAP_NO, EVENT_EXT_SET_NOW_MAP_NO},
    {_GET_TBOX_PARAM, EVENT_EXT_GET_TBOX_PARAM},
    {_CANCEL_LOAD_VILLAGER, EVENT_EXT_CANCEL_LOAD_VILLAGER},
    {_CANCEL_NOW_LOADING, EVENT_EXT_CANCEL_NOW_LOADING},
    {_ESM_INITIALIZE, EVENT_EXT_ESM_INITIALIZE},
    {_ESM_INIT_FIX, EVENT_EXT_ESM_INIT_FIX},
    {_ESM_CLEAR, EVENT_EXT_ESM_CLEAR},
    {_ESM_LOAD_BASE, EVENT_EXT_ESM_LOAD_BASE},
    {_ESM_CREATE, EVENT_EXT_ESM_CREATE},
    {_ESM_FINISH, EVENT_EXT_ESM_FINISH},
    {_ESM_DELETE, EVENT_EXT_ESM_DELETE},
    {_ESM_SET_VECT1, EVENT_EXT_ESM_SET_VECT1},
    {_ESM_SET_VECT2, EVENT_EXT_ESM_SET_VECT2},
    {_ESM_SET_TARGET_ID, EVENT_EXT_ESM_SET_TARGET_ID},
    {_ESM_LOAD_BASE_PACK, EVENT_EXT_ESM_LOAD_BASE_PACK},
    {_ESM_SET_VALUE, EVENT_EXT_ESM_SET_VALUE},
    {_SET_CHARA_CONDITION, EVENT_EXT_SET_CHARA_CONDITION},
    {_ADD_WHP, EVENT_EXT_ADD_WHP},
    {_ADD_HP_RATE, EVENT_EXT_ADD_HP_RATE},
    {_GET_TIME, EVENT_EXT_GET_TIME},
    {_CHECK_GET_ITEM_LIMIT, EVENT_EXT_CHECK_GET_ITEM_LIMIT},
    {_CHECK_ITEM_OVER, EVENT_EXT_CHECK_ITEM_OVER},
    {_GET_NOW_LOOP_NO, EVENT_EXT_GET_NOW_LOOP_NO},
    {_IS_CLEAR_DESTROY, EVENT_EXT_IS_CLEAR_DESTROY},
    {_IS_CLEAR_PRACTICE, EVENT_EXT_IS_CLEAR_PRACTICE},
    {_IS_PLAY_SUB_GAME, EVENT_EXT_IS_PLAY_SUB_GAME},
    {_RESET_SUBJECT_COUNTER, EVENT_EXT_RESET_SUBJECT_COUNTER},
    {_SCR_EFF_INIT_RASTER, EVENT_EXT_SCR_EFF_INIT_RASTER},
    {_SCR_EFF_START_RASTER, EVENT_EXT_SCR_EFF_START_RASTER},
    {_SCR_EFF_STOP_RASTER, EVENT_EXT_SCR_EFF_STOP_RASTER},
    {_SET_MPCHARA_MOTION, EVENT_EXT_SET_MPCHARA_MOTION},
    {_FUNC_POINT_POS, EVENT_EXT_FUNC_POINT_POS},
    {_CTRLC_ROT_BACK, EVENT_EXT_CTRLC_ROT_BACK},
    {_PARTS_NAME_STRCMP, EVENT_EXT_PARTS_NAME_STRCMP},
    {_GET_TRIAL_VERSION, EVENT_EXT_GET_TRIAL_VERSION},
    {_SET_FLOOR_EPISODE, EVENT_EXT_SET_FLOOR_EPISODE},
    {_FUNC_POINT_GET_POS, EVENT_EXT_FUNC_POINT_GET_POS},
    {_FUNC_POINT_GET_ROT, EVENT_EXT_FUNC_POINT_GET_ROT},
    {_ACTCHR_SET_DEF_MOTION, EVENT_EXT_ACTCHR_SET_DEF_MOTION},
    {_ADD_FUSION_POINT, EVENT_EXT_ADD_FUSION_POINT},
    {_GET_DEBUG_FLAG, EVENT_EXT_GET_DEBUG_FLAG},
    {_MINIMAP_DOOR_ENABLE, EVENT_EXT_MINIMAP_DOOR_ENABLE},
    {_DNG_CHECK_BOSS_MAP, EVENT_EXT_DNG_CHECK_BOSS_MAP},
    {_DNG_RUN_EVENT, EVENT_EXT_DNG_RUN_EVENT},
    {_CHECK_ENABLE_CHARA_CHANGE, EVENT_EXT_CHECK_ENABLE_CHARA_CHANGE},
    {_INIT_SEPIA, EVENT_EXT_INIT_SEPIA},
    {_START_SEPIA, EVENT_EXT_START_SEPIA},
    {_END_SEPIA, EVENT_EXT_END_SEPIA},
    {_COPY_MONS2SCNCHR, EVENT_EXT_COPY_MONS2SCNCHR},
    {_UNLOCK_STACK, EVENT_EXT_UNLOCK_STACK},
    {_RESET_EVENT_TRG, EVENT_EXT_RESET_EVENT_TRG},
    {_SET_CHARA_NO, EVENT_EXT_SET_CHARA_NO},
    {_GET_CHARA_NO, EVENT_EXT_GET_CHARA_NO},
    {_SEARCH_CHARA_NO, EVENT_EXT_SEARCH_CHARA_NO},
    {_GET_NEAR_RANDOM_STONE_POS, EVENT_EXT_GET_NEAR_RANDOM_STONE_POS},
    {_INIT_MONO_FLASH, EVENT_EXT_INIT_MONO_FLASH},
    {_START_MONO_FLASH, EVENT_EXT_START_MONO_FLASH},
    {_END_MONO_FLASH, EVENT_EXT_END_MONO_FLASH},
    {_DELETE_VILLAGER, EVENT_EXT_DELETE_VILLAGER},
    {_DNG_SET_WEATHER, EVENT_EXT_DNG_SET_WEATHER},
    {_SET_CHARA_MAXHP, EVENT_EXT_SET_CHARA_MAXHP},
    {_SET_CHARA_DEFENCE, EVENT_EXT_SET_CHARA_DEFENCE},
    {_PLACE_PARTS_NAME_STRCMP, EVENT_EXT_PLACE_PARTS_NAME_STRCMP},
    {_GOTO_USE_ITEM2, EVENT_EXT_GOTO_USE_ITEM2},
    {_DBG_SET_ANALYZE_FLAG, EVENT_EXT_DBG_SET_ANALYZE_FLAG},
    {_ATRAMIRIA_ON_OFF, EVENT_EXT_ATRAMIRIA_ON_OFF},
    {_ADD_YARIKOMI_MEDAL, EVENT_EXT_ADD_YARIKOMI_MEDAL},
    {_SET_MAP_EFFECT_ID, EVENT_EXT_SET_MAP_EFFECT_ID},
    {_GET_MAP_EFFECT_ID, EVENT_EXT_GET_MAP_EFFECT_ID},
    {_DNG_FLOOR_INIT, EVENT_EXT_DNG_FLOOR_INIT},
    {_DNG_FLOOR_FINISH, EVENT_EXT_DNG_FLOOR_FINISH},
    {_CLEAR_RND_STONE, EVENT_EXT_CLEAR_RND_STONE},
    {_GET_FLOOR_STATUS, EVENT_EXT_GET_FLOOR_STATUS},
    {_SET_FLOOR_STATUS, EVENT_EXT_SET_FLOOR_STATUS},
    {_AMG_GET_ATTR_STATUS, EVENT_EXT_AMG_GET_ATTR_STATUS},
    {_SET_NEAR_DIST, EVENT_EXT_SET_NEAR_DIST},
    {_SET_KEEP_TIME, EVENT_EXT_SET_KEEP_TIME},
    {_GET_KEEP_TIME, EVENT_EXT_GET_KEEP_TIME},
    {_GET_DOOR_PARTS_ID, EVENT_EXT_GET_DOOR_PARTS_ID},
    {_CHECK_EQUEP_CHANGE, EVENT_EXT_CHECK_EQUEP_CHANGE},
    {_ADD_HP_RATE2, EVENT_EXT_ADD_HP_RATE2},
    {_DNG_EFFECT_ALL_CLEAR, EVENT_EXT_DNG_EFFECT_ALL_CLEAR},
    {_AUTO_CHENGE_BGM_VOL, EVENT_EXT_AUTO_CHENGE_BGM_VOL},
    {_UDATA_GET_WHP, EVENT_EXT_UDATA_GET_WHP},
    {_UDATA_ADD_WHP, EVENT_EXT_UDATA_ADD_WHP},
    {_UDATA_GET_ABS, EVENT_EXT_UDATA_GET_ABS},
    {_UDATA_ADD_ABS, EVENT_EXT_UDATA_ADD_ABS},
    {_DNG_CREATE_EFFECT, EVENT_EXT_DNG_CREATE_EFFECT},
    {_LEAVE_MONICA_ITEM_CHECK, EVENT_EXT_LEAVE_MONICA_ITEM_CHECK},
    {_PAUSE_ENABLE_FLAG, EVENT_EXT_PAUSE_ENABLE_FLAG},
    {_FORCE_BOOT_TOUR, EVENT_EXT_FORCE_BOOT_TOUR},
    {_MT_TEST, EVENT_EXT_MT_TEST},
    {_TEST, EVENT_EXT_TEST},
    {NULL, EVENT_EXT_END},
};

void SetEventFunc(CRunScript *script) {
    int i;
    int j;

    for (i = 0; i < event_func_slots; i++) {
        ext_func[i] = NULL;
    }

    i = 0;

    for (;;) {
        if (ext_func_info[i].func == NULL) {
            break;
        }

        for (j = 0; j < i; j++) {
            if (ext_func_info[i].no == ext_func_info[j].no) {
                printf("same ext_func_no!!!\n");

                while (1) {
                }
            }
        }

        if (ext_func_info[i].no < 0 || ext_func_info[i].no >= event_func_slots) {
            printf("ext func over!!");
        } else {
            ext_func[ext_func_info[i].no] = ext_func_info[i].func;
        }

        i++;
    }

    script->ext_func(ext_func, event_func_slots);
}

// Uninitialised data (.bss)
ED_EVENT_INFO EdEventInfo;

inline CEventScriptArg::CEventScriptArg() {
    next_id = 0;
    list = NULL;
    list_num = 0;
    memory = NULL;
}

inline CRaster::CRaster() {
    Initialize();
}

inline CScreenEffect::CScreenEffect() {
    Initialize();
}

CEohMother         EventObjHandleMother;

CEventSpriteMother esMother;

u32 EventLocalFlag[EVENT_LOCAL_NUM];

int EventLocalCnt[EVENT_LOCAL_NUM];

CRain   EventRain;

CMarker EventMarker;

RS_STACKDATA *p_use_item;

int SetWorldCoordFlg;

int PakuAnimEohNo;

int PakuMotionEohNo;

int PakuMotionType;

int PakuMotionType2;

BattleEffectPrim Hit_para[EVENT_HIT_EFFECT_NUM][EVENT_HIT_PARTICLE_NUM];

CHitEffectImage HitEffect[5];

char PakuAnimName[PAKU_NAME_SIZE];

char PakuAnimName2[PAKU_NAME_SIZE];

char PakuMotionName[PAKU_NAME_SIZE];

char PakuMotionName2[PAKU_NAME_SIZE];

mgCMemory BuffEventSnd;

mgCMemory   BuffEventSnd2;

CDngFreeMap EventDngMap;

_SEN_CMR_SEQ cmr_seq_tbl[SEQ_NODE_NUM];

CSceneCmrSeq CameraSeq;

_SEN_OBJ_SEQ obj_seq_tbl[SEQ_NODE_NUM];

CSceneObjSeq    ObjectSeq[32];

CEventSprite2   EventSprite2[48];

CEventScriptArg EventScriptArg;

CScreenEffect   EventScreenEffect;
