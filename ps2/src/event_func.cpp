#include "common.h"
#include "event_func.hpp"
#include "actionchara.hpp"
#include "cameracontrol.hpp"
#include "character.hpp"
#include "collision.hpp"
#include "colprim.hpp"
#include "dataread.hpp"
#include "dng_event.hpp"
#include "dng_main.hpp"
#include "dngmenu.hpp"
#include "editdata.hpp"
#include "editinfo.hpp"
#include "editmap.hpp"
#include "editevent.hpp"
#include "automap.hpp"
#include "nowload.hpp"
#include "effscript.hpp"
#include "event.hpp"
#include "eventsprite.hpp"
#include "gamepad.hpp"
#include "gameutil.hpp"
#include "gyorace.hpp"
#include "inventmn.hpp"
#include "mainloop.hpp"
#include "mapinfo.hpp"
#include "mapjump.hpp"
#include "mapparts.hpp"
#include "menuaqua.hpp"
#include "menucommon.hpp"
#include "menumain.hpp"
#include "mg_camera.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "movie.hpp"
#include "nd_meswin.hpp"
#include "padcontrol.hpp"
#include "pot.hpp"
#include "quest.hpp"
#include "savedata.hpp"
#include "sphida.hpp"
#include "sound.hpp"
#include "swordeffect.hpp"
#include "sysmes.hpp"
#include "subgame.hpp"
#include "userdata.hpp"
#include "editmenu.hpp"
#include "gamedata.hpp"
#include "intersection.hpp"
#include "mapselect.hpp"
#include "menudraw.hpp"
#include "mglib.hpp"
#include "npccfg.hpp"
#include "snd_mngr.hpp"
#include <libcdvd.h>
#include <cstring>
#include <cstdio>
#include <cmath>
#include <cstdlib>

struct ExtensionTable { char *name[4]; };
struct EventScriptFunc { int (*func)(RS_STACKDATA *, int); int id; };
struct VpkEntry { int group; int kind; int id; int sub; };
struct VpkTable { VpkEntry entry[164]; };
typedef int (*EventFunc)(RS_STACKDATA *, int);
extern CEventScriptArg *nowScriptArg;
extern CEventScriptArg EventScriptArg;
extern EventScriptFunc esa_ext_func_info[];
extern EventScriptFunc ext_func_info__2[];
extern EventFunc ext_func__2[0x5dc];
extern ExtensionTable at_1084;
extern VpkTable at_6800__2;
extern CEventSprite2 EventSprite2[0x30];
extern CSceneObjSeq ObjectSeq[32];
extern CSceneCmrSeq CameraSeq;
extern mgCMemory BuffEventSnd;
extern mgCMemory BuffEventSnd2;
extern u_long128 event_snd_buff[];
extern u_long128 event_snd2_buff[];
extern CDngFreeMap EventDngMap;
extern CEffectScriptMan *EventEffectScript;
extern CSWordAfterImage *SwordEffect;
extern float vv_3333[12];
extern "C" int fptosi(float value);
extern "C" int GetItemDataType__Fi(int);
extern "C" int GetNowHorl__11CSphidaDataFv(CSphidaData *);
extern "C" void VectMatMul__FPfPfPA4_f__2(float *, float *, float (*)[4]);
extern "C" int GetStackInt__FP12RS_STACKDATA__2(RS_STACKDATA *);
extern "C" float GetStackFloat__FP12RS_STACKDATA__2(RS_STACKDATA *);
extern "C" char *GetStackString__FP12RS_STACKDATA__2(RS_STACKDATA *);
extern "C" void GetStackVector__FPfP12RS_STACKDATA(float *, RS_STACKDATA *);
extern "C" void SetStack__FP12RS_STACKDATAi__2(RS_STACKDATA *, int);
extern "C" void SetStack__FP12RS_STACKDATAf__2(RS_STACKDATA *, float);
extern "C" CSceneObjSeq *GetObjSeq__Fi(int, ...);
extern "C" CEventSprite2 *GetEventSprite__Fi(int, int);
extern "C" void SetDrawFlag__13CEventSprite2Fi(CEventSprite2 *);
extern "C" void SetSpriteType__13CEventSprite2Fi(CEventSprite2 *);
extern "C" void SetAlphaBlend__13CEventSprite2Fi(CEventSprite2 *);
extern "C" int SetStep__10CEohMotherFif(CEohMother *, float);
extern "C" void SetEohNo__12CSceneObjSeqFi(CSceneObjSeq *);
extern "C" void PosDelay__12CSceneObjSeqFi(CSceneObjSeq *);
extern "C" void SetPasFrm__12CSceneObjSeqFi(CSceneObjSeq *);
extern "C" void RotDelay__12CSceneObjSeqFi(CSceneObjSeq *);
extern "C" void MotionDelay__12CSceneObjSeqFi(CSceneObjSeq *);
extern "C" void TexAnimeDelay__12CSceneObjSeqFi(CSceneObjSeq *);
extern "C" void ColorDelay__12CSceneObjSeqFi(CSceneObjSeq *);
extern "C" void ScaleDelay__12CSceneObjSeqFi(CSceneObjSeq *);
extern "C" void SeDelay__12CSceneObjSeqFi(CSceneObjSeq *);
extern "C" void AttachCamera__12CSceneObjSeqFfi(CSceneObjSeq *, float);
namespace EventAbi {
    extern "C" float GetStackFloat__FP12RS_STACKDATA__2(RS_STACKDATA *, int);
    extern "C" int SetStack__FP12RS_STACKDATAi__2(RS_STACKDATA *, int);
    extern "C" int SetStack__FP12RS_STACKDATAf__2(RS_STACKDATA *, float);
}
const int hit_effect_num = 5;
const int event_sprite2_num = 0x30;
const int sprite_type_world = 1;
const float sprite_ground_offset = 32.0f;
const int status_no_shadow = 8;
const int script_stack_slots = 0x20;
const int script_call_slots = script_stack_slots;
const int script_func_slots = 3;
const int script_run_id = 0x64;
const float raster_max = 3.1415927f;
const int prim_sprite = 6;
const int half_color = 0x80;
const int seq_node_num = 0x100;
const int hit_spark_num = 0x40;
const int event_snd_buffer_size = 0x801;
const int event_snd2_buffer_size = 0x141;
const int memory_name_max = 0x10;
const int paku_name_size = 0x40;
const int pack_file_max = 0x80;
const int type_loaded = 2;
const int event_func_slots = 0x5DC;
const int vector_bytes = 0x18;
const int event_local_num = 64;
const int object_seq_num = 32;
const int invent_user_data_offset = 0x7F30;
const int exit_edit_mode = 17;
const int event_stream = 1;
const int stream_max_volume = 0x7FFF;
const int vpk_entry_count = 164;
const int chara_sword_after_offset = 0x570;
const int menu_dng_map = 3;
const int menu_select_party = 4;
const int menu_use_item = 9;
const int menu_draw_chapter = 11;
const int exit_start_loop = EVENT_REQUEST_GOTO;
const int exit_enter_interior = EVENT_REQUEST_INTERIOR;
const int exit_leave_interior = EVENT_REQUEST_OUTSIDE;
const int exit_map_jump = EVENT_REQUEST_MAP_JUMP;
const int request_menu = EVENT_COMMAND_SUB_MODE;
const int request_door = EVENT_COMMAND_DOOR;
const int event_sprite2_size = 0x80;
extern char at_1333[];
extern char at_1357__3[];
extern char at_1103__2[];
extern char at_1104__3[];
extern char at_1245[];
extern char at_1246[];
extern char at_1346__2[];
extern char at_1760__3[];
extern char at_1761__3[];
extern char at_2245__2[];
extern char at_2246__2[];
extern char at_2247__2[];
extern char at_2248__2[];
extern char at_2249__2[];
extern char at_2291[];
extern char at_2292__2[];
extern char at_9744[];
extern char at_9745[];
extern char at_10100[];
extern char at_10101[];
extern CGamePad GamePad__2;
extern char at_3339[];
extern char at_3631__2[];
extern char at_3632__2[];
extern char at_3633[];
extern char at_3634[];
extern char at_3635[];
extern char at_3636[];
extern "C" int CheckInventItem__Fi(int);
extern char at_1083[];
extern char at_9148[];
extern char at_9622[];
extern char at_8230[];
extern char at_2393__3[];
extern char at_2664__2[];
extern char at_4072[];
extern char at_6773__2[];
extern char at_6774__2[];
extern char at_6775__2[];
extern char at_6776__2[];
extern char at_6781__2[];
extern char at_6782__2[];
extern char at_6816[];
extern char at_6839[];
extern char at_7117[];

// Code (.text)
CEoh::CEoh(void) {
    type = EOH_TYPE_NONE;
    scene_no = -1;
    world_coord = 1;
    chara = NULL;
    object = NULL;
    sprite = NULL;
    frame = NULL;
    func_point = NULL;
}
int CEoh::Set(int newKind, CObject *newObject, int newFlag) {
    if (newObject == NULL) {
        return 0;
    }
    type = newKind;
    if (type != EOH_TYPE_OBJECT) {
        return 0;
    }
    object = newObject;
    world_coord = newFlag;
    return 1;
}
int CEoh::Set(int newKind, int newCharaNo, CCharacter2 *newChara) {
    if (newChara == 0)
        return 0;
    type = newKind;
    switch (type) {
        case EOH_TYPE_CHARA:
            scene_no = newCharaNo;
            chara = newChara;
            return 1;
        default:
            return 0;
    }
}
int CEoh::Set(int newKind, CEventSprite2 *newSprite) {
    if (newSprite == 0)
        return 0;
    type = newKind;
    switch (type) {
        case EOH_TYPE_SPRITE:
            sprite = newSprite;
            return 1;
        default:
            return 0;
    }
}
int CEoh::Set(int newKind, mgCFrame *newFrame) {
    if (newFrame == 0)
        return 0;
    type = newKind;
    switch (type) {
        case EOH_TYPE_FRAME:
            frame = newFrame;
            return 1;
        default:
            return 0;
    }
}
int CEoh::Set(int newKind, CFuncPoint *newFuncPoint) {
    if (newFuncPoint == 0)
        return 0;
    type = newKind;
    switch (type) {
        case EOH_TYPE_FUNC_POINT:
            func_point = newFuncPoint;
            break;
        default:
            return 0;
    }
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", VectMatMul__FPfPfPA4_f__2);
void CalcPosWorldCoord(float *pos) {
    float rotation[4][4];
    float rotated[4];
    if (SetWorldCoordFlg != 0) {
        mgRotMatrixXYZ(rotation, EdEventInfo.world_coord_rot);
        VectMatMul__FPfPfPA4_f__2(rotated, pos, rotation);
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
        VectMatMul__FPfPfPA4_f__2(pos, local, matrix);
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
int CEohMother::Set(int slot, int kind, int charaNo, CCharacter2 *chara) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }
    return eoh[slot].Set(kind, charaNo, chara);
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
int CEohMother::Set(int slot, int kind, CFuncPoint *funcPoint) {
    if (slot < 0 || slot >= EOH_NUM) {
    return 0;
    }
    return eoh[slot].Set(kind, funcPoint);
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
            mgCObject *chara = (mgCObject *)eoh[slot].object;
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
            mgCObject *object = (mgCObject *)eoh[slot].object;
            if (object == NULL) {
                return 0;
            }
            object->SetPosition(x, y, z);
    return 1;
        }
        case EOH_TYPE_SPRITE: {
            float pos[4];
            float *posY = &pos[1];
            pos[0] = x;
            *posY = y;
            pos[2] = z;
            pos[3] = 1.0f;
            CEventSprite2 *&sprite = handle->sprite;
            if (sprite == NULL) {
                return 0;
            }
            if (sprite->GetType() == 0) {
                *posY += sprite_ground_offset;
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
            mgCObject *frame = (mgCObject *)handle->object;
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
                CFuncPoint *funcPoint = eoh[slot].func_point;
                if (funcPoint == NULL) {
                    return 0;
                }
                *(u_long128 *)funcPoint->position = *(u_long128 *)pos;
                funcPoint->frame.SetPosition(pos);
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
            mgCObject *&chara = (mgCObject *&)handle->object;
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
            mgCObject *&object = (mgCObject *&)handle->object;
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
            mgCObject *frame = (mgCObject *)handle->object;
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
            CFuncPoint *&funcPoint = handle->func_point;
            if (funcPoint == NULL) {
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
            CFuncPoint *target = funcPoint;
            *(u_long128 *)target->rotation = *(u_long128 *)rot;
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
            mgCObject *chara = (mgCObject *)handle->object;
            if (chara == NULL) {
                return 0;
            }
            chara->GetPosition(pos);
            CalcPosWorldCoordGyaku(pos);
            return 1;
        }
        case EOH_TYPE_OBJECT: {
            mgCObject *object = (mgCObject *)handle->object;
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
            mgCObject *frame = (mgCObject *)handle->object;
            if (frame == NULL) {
                return 0;
            }
            frame->GetPosition(pos);
            return 1;
        }
        case EOH_TYPE_FUNC_POINT: {
            CFuncPoint *funcPoint = handle->func_point;
            if (funcPoint == NULL) {
                return 0;
            }
            *(u_long128 *)pos = *(u_long128 *)funcPoint->position;
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
            mgCObject *chara = (mgCObject *)handle->object;
            if (chara == NULL) {
                return 0;
            }
            chara->GetRotation(rot);
            rot[1] -= EdEventInfo.world_coord_rot[1];
            rot[1] = mgAngleLimit(rot[1]);
            return 1;
        }
        case EOH_TYPE_OBJECT: {
            mgCObject *object = (mgCObject *)handle->object;
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
            mgCObject *frame = (mgCObject *)handle->object;
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
            CFuncPoint *funcPoint = handle->func_point;
            if (funcPoint == NULL) {
                return 0;
            }
            *(u_long128 *)rot = *(u_long128 *)funcPoint->rotation;
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
            CObject **held = &handle->object;
            CCharacter2 *chara = (CCharacter2 *)*held;
            if (chara == NULL) {
                return 0;
            }
            chara->SetMotion(name, type);
            if (blend != -1.0f) {
                ((CCharacter2 *)*held)->NormalDrive();
                ((CCharacter2 *)*held)->SetStep(blend);
                chara = (CCharacter2 *)*held;
                chara->frame = (float)chara->now_key->start_frame;
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
                return ((CCharacter2 *)chara)->CheckMotionEnd();
            }
            if (chara->seq_state == 4) {
                return ((CCharacter2 *)chara)->CheckMotionEnd();
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
            CCharacter2 *chara = (CCharacter2 *)handle->object;
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
            CCharacter2 *chara = (CCharacter2 *)handle->object;
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
            mgCObject *chara = (mgCObject *)handle->object;
            if (chara == NULL) {
                return 0;
            }
            chara->SetScale(x, y, z);
            return 1;
        }
        case EOH_TYPE_OBJECT: {
            mgCObject *object = (mgCObject *)handle->object;
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
            ((mgCObject *)handle->frame)->SetScale(x, y, z);
            return 1;
        case EOH_TYPE_FUNC_POINT: {
            CFuncPoint *&funcPoint = handle->func_point;
            if (funcPoint == NULL) {
                return 0;
            }
            float scale[4];
            scale[0] = x;
            scale[1] = y;
            scale[2] = z;
            scale[3] = 1.0f;
            CFuncPoint *target = funcPoint;
            *(u_long128 *)target->scale = *(u_long128 *)scale;
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
            mgCObject *chara = (mgCObject *)handle->object;
            if (chara == NULL) {
                return 0;
            }
            chara->GetScale(scale);
            return 1;
        }
        case EOH_TYPE_OBJECT: {
            mgCObject *object = (mgCObject *)handle->object;
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
            float sizeX;
            float sizeY;
            sprite->GetScale(&sizeX, &sizeY);
            scale[0] = sizeX;
            scale[1] = sizeY;
            scale[2] = 0.0f;
            scale[3] = 0.0f;
            return 1;
        }
        case EOH_TYPE_FUNC_POINT: {
            CFuncPoint *funcPoint = handle->func_point;
            if (funcPoint == NULL) {
                return 0;
            }
            *(u_long128 *)scale = *(u_long128 *)funcPoint->scale;
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
            CObject *object = (CObject *)handle->object;
            if (object == NULL) {
                return 0;
            }
            object->Show(show);
            return 1;
        }
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = (CCharacter2 *)handle->object;
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
            CObject *object = (CObject *)handle->object;
            if (object == NULL) {
                return 0;
            }
            *show = object->GetShow();
            return 1;
        }
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = (CCharacter2 *)handle->object;
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
    CEoh *handle = &eoh[slot];
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
            mgCFrame *shadow = (mgCFrame *)chara->shadow_frame;
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
            CCharacter2 *chara = (CCharacter2 *)handle->object;
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
            CCharacter2 *chara = (CCharacter2 *)handle->object;
            if (chara != NULL) {
                return chara->GetMotionStatus();
            }
            return 0;
        }
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", SetMotionNowTime__10CEohMotherFif);
int CEohMother::SetMotionWaitTime(int slot, float rate) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }
    CEoh *handle = &eoh[slot];
    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CObject **held = &handle->object;
            CCharacter2 *chara = (CCharacter2 *)*held;
            if (chara == NULL) {
                return 0;
            }
            CHRINFO_KEY_SET *motion = chara->now_key;
            if (motion != NULL) {
                float length = (float)(motion->end_frame - motion->start_frame);
                length *= rate;
                chara->frame = length + (float)motion->start_frame;
                ((CCharacter2 *)*held)->NormalDrive();
                chara = (CCharacter2 *)*held;
                chara->frame = length + (float)chara->now_key->start_frame;
            }
            return 1;
        }
        default:
            return 0;
    }
}
int CEohMother::SetFootSoundID(int slot, int soundId) {
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
            chara->foot_sound_id = soundId;
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
int CEohMother::SetSoundID(int slot, u32 soundId) {
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
            chara->se_bank = soundId;
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
            CCharacter2 *chara = (CCharacter2 *)handle->object;
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
            CCharacter2 **chara = (CCharacter2 **)&handle->object;
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
            CCharacter2 *chara = (CCharacter2 *)handle->object;
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
            chara->foot_se_bank = stamp;
            break;
        }
        default:
            return 0;
    }
    return 1;
}
void FileNameConvLanguage(char *name) {
    ExtensionTable extension = at_1084;
    char marker[32];
    char *found;
    int i;

    for (i = 0; i < 3; i++) {
        sprintf(marker, at_1103__2, extension.name[i]);
        if ((found = strstr(name, marker)) != NULL) {
            switch (LanguageCode) {
                case 2:
                case 3:
                case 4:
                case 5:
                    sprintf(found, at_1104__3, LanguageCode, extension.name[i]);
                    break;
            }
        }
    }
}
extern "C" int GetStackInt__FP12RS_STACKDATA__2(RS_STACKDATA *stack) {
    if (stack->type == RS_FLOAT) {
        return fptosi(stack->f);
    }
    return stack->i;
}
extern "C" float GetStackFloat__FP12RS_STACKDATA__2(RS_STACKDATA *stack) {
    if (stack->type == RS_INT) {
        return (float)stack->i;
    }
    return stack->f;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", GetStackVector__FPfP12RS_STACKDATA);
extern "C" char *GetStackString__FP12RS_STACKDATA__2(RS_STACKDATA *stack) {
    return stack->s;
}
extern "C" void SetStack__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int value) {
    if (stack->type == RS_PTR) {
        stack->p->i = value;
    }
}
extern "C" void SetStack__FP12RS_STACKDATAf__2(RS_STACKDATA *stack, float value) {
    if (stack->type == RS_PTR) {
        stack->p->f = value;
    }
}
void CEventScriptArg::BuildArgData(u32 *program) {
    RS_STACKDATA stack[script_stack_slots];
    RS_CALLDATA calls[script_call_slots];
    int (*funcTable[script_func_slots])(RS_STACKDATA *, int);
    int count;
    int i;
    int j;

    funcTable[0] = NULL;
    funcTable[1] = NULL;
    funcTable[2] = NULL;
    count = 0;
    i = 0;
    for (;;) {
        if (esa_ext_func_info[i].func == NULL) {
            break;
        }
        for (j = 0; j < count; j++) {
            if (esa_ext_func_info[i].id == esa_ext_func_info[j].id) {
                printf(at_1245);
                while (1) {
                }
            }
        }
        if (esa_ext_func_info[i].id < 0 || esa_ext_func_info[i].id >= script_func_slots) {
            printf(at_1246);
        } else {
            funcTable[esa_ext_func_info[i].id] = esa_ext_func_info[i].func;
        }
        i++;
        count++;
    }
    nowScriptArg = this;
    CRunScript script;
    script.load((RS_PROG_HEADER *)program, stack, script_stack_slots, calls, script_call_slots);
    script.ext_func(funcTable, script_func_slots);
    script.run(script_run_id);
    nowScriptArg = NULL;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _DATA__FP12RS_STACKDATAi);
int _ID_OFFSET(RS_STACKDATA *stack, int argCount) {
    if (nowScriptArg == 0)
        return 0;
    nowScriptArg->next_id = GetStackInt__FP12RS_STACKDATA__2(stack);
    return 1;
}
int GetArgInt(ARG_DATA *arg) {
    if (arg == NULL) {
        printf(at_1333);
        return 0;
    }
    if (arg->type == RS_FLOAT) {
        return fptosi(arg->f);
    }
    return arg->i;
}
float GetArgFloat(ARG_DATA *arg) {
    if (arg == NULL) {
        printf(at_1346__2);
        return 0.0f;
    }
    if (arg->type == RS_INT) {
        return (float)arg->i;
    }
    return arg->f;
}
char *GetArgString(ARG_DATA *arg) {
    if (arg == NULL) {
        printf(at_1357__3);
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
void CRaster::Initialize(void) {
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
            amplitude_step = (target0 - amplitude) / (float)this->frames;
        } else {
            amplitude_step = 0.0f;
        }
        if (target1 != -1.0f) {
            speed_step = (target1 - speed) / (float)this->frames;
        } else {
            speed_step = 0.0f;
        }
        if (target2 != -1.0f) {
            pitch_step = (target2 - pitch) / (float)this->frames;
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
            amplitude_step = (target0 - amplitude) / (float)this->frames;
        } else {
            amplitude_step = 0.0f;
        }
        if (target1 != -1.0f) {
            speed_step = (target1 - speed) / (float)this->frames;
        } else {
            speed_step = 0.0f;
        }
        if (target2 != -1.0f) {
            pitch_step = (target2 - pitch) / (float)this->frames;
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
void CRaster::StepRaster(void) {
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
void CRaster::DrawRaster(void) {
    int width;
    int y;
    float shift;
    float current_phase;
    float nextY;

    if (state != 0) {
        mgCTexture screen;

        mgGetFrameBuffer(&screen);
        mgCDrawPrim slot;
        slot.Initialize(NULL, NULL);
        slot.DepthTestEnable(0);
        slot.AlphaTestEnable(0);
        slot.AlphaBlendEnable(0);
        slot.ZMask(-1);
        slot.TextureMapEnable(1);
        current_phase = phase;
        slot.Begin(prim_sprite);
        slot.Texture(&screen);
        slot.Color(half_color, half_color, half_color, half_color);
        for (y = 0; y < mgScreenHeight; y++) {
            shift = amplitude * sinf(current_phase);
            slot.TextureCrd(0, y);
            slot.Vertex(shift, (float)y, 0.0f);
            slot.TextureCrd(mgScreenWidth, y + 1);
            slot.Vertex(shift + (float)mgScreenWidth, nextY = 1.0f + (float)y, 0.0f);
            if (shift != 0.0f) {
                if (!(shift <= 0.0f)) {
                    width = mgScreenWidth;
                    slot.TextureCrd(width - fptosi(shift), y);
                    slot.Vertex(0.0f, (float)y, 0.0f);
                    slot.TextureCrd(mgScreenWidth, y + 1);
                    slot.Vertex(shift, nextY, 0.0f);
                } else {
                    slot.TextureCrd(0, y);
                    slot.Vertex((float)mgScreenWidth + shift, (float)y, 0.0f);
                    slot.TextureCrd(fptosi(-shift), y + 1);
                    slot.Vertex((float)mgScreenWidth, nextY, 0.0f);
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
void CScreenEffect::Initialize(void) {
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
void CScreenEffect::Step(void) {
    raster.StepRaster();
}
void CScreenEffect::Draw(void) {

    mgCTextureManager *manager = &mgTexManager;

    if (sepia != 0 && sepia_texture != NULL) {
        manager->ReloadTexture(sepia_texture->block, (sceVif1Packet *)NULL);
        mgCDrawPrim sepia_prim;
        sepia_prim.Initialize(NULL, NULL);
        sepia_prim.DepthTestEnable(0);
        sepia_prim.AlphaTestEnable(0);
        sepia_prim.AlphaBlendEnable(0);
        sepia_prim.ZMask(-1);
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
            manager->ReloadTexture(mono_flash_texture[mono_flash_no]->block, (sceVif1Packet *)NULL);
            mgCDrawPrim flash;
            flash.Initialize(NULL, NULL);
            flash.DepthTestEnable(0);
            flash.AlphaTestEnable(0);
            flash.AlphaBlendEnable(0);
            flash.ZMask(-1);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", CaptureSepiaScreen__13CScreenEffectFv);
void CScreenEffect::SetSepiaFlag(int enabled) {
    if (sepia_texture != NULL) {
        sepia = enabled;
        return;
    }
    sepia = 0;
}
void CScreenEffect::SetMonoFlashTexture(mgCTexture **textures, u_long128 **vramImages) {
    if (textures[0] == NULL || textures[1] == NULL) {
        return;
    }
    mono_flash_texture[0] = textures[0];
    mono_flash_texture[0]->image[0] = vramImages[0];
    mono_flash_texture[1] = textures[1];
    mono_flash_texture[1]->image[0] = vramImages[1];
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", CaptureMonoFlashScreen__13CScreenEffectFv);
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
void InitWorldCoord(void) {
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
    int inRange;
    int word;

    word = index >> 5;
    if (index < 0) {
        return 0;
    }
    inRange = word < event_local_num;
    if (index < 0) {
        word = (int)(index + 0x1F) >> 5;
        inRange = word < event_local_num;
    }
    bit = index & 0x1F;
    if (inRange == 0) {
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

    int bit;
    int inRange;
    int word;
    int mask;
    u32 *flags;

    word = index >> 5;
    if (index < 0) {
        return 0;
    }
    inRange = word < event_local_num;
    if (index < 0) {
        word = (int)(index + 0x1F) >> 5;
        inRange = word < event_local_num;
    }
    bit = index & 0x1F;
    if (inRange == 0) {
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
    if (index < 0 || index >= event_local_num) {
        return -1;
    }
    return EventLocalCnt[index];
}
int SetLocalCnt(int index, int value) {
    if (index < 0 || index >= event_local_num) {
        return 0;
    }
    EventLocalCnt[index] = value;
    return 1;
}
int GetLocalCnt2(int value) {
    int i;
    for (i = 0; i < event_local_num; i++) {
        if (value == EventLocalCnt[i]) {
            return i;
        }
    }
    return -1;
}
void InitLocalCnt(void) {
    int i;
    for (i = 0; i < event_local_num; i++) {
        EventLocalCnt[i] = 0;
    }
}
void EdEventInfoCommandInitialize(void) {
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
void EventSeqInit(void) {
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
    CameraSeq.Initialize(cmr_seq_tbl, seq_node_num);
    int j;
    for (j = 0; j < object_seq_num; j++) {
        ObjectSeq[j].Initialize(obj_seq_tbl, seq_node_num);
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
void EdEventInit(void) {
    int i;

    BuffEventSnd.stSetBuffer(event_snd_buff, event_snd_buffer_size);
    if (strlen(at_1760__3) < memory_name_max) {
        strcpy((char *)&BuffEventSnd, at_1760__3);
    }
    BuffEventSnd.stack_used = 0;
    BuffEventSnd.lock = 0;
    BuffEventSnd2.stSetBuffer(event_snd2_buff, event_snd2_buffer_size);
    if (strlen(at_1761__3) < memory_name_max) {
        strcpy((char *)&BuffEventSnd2, at_1761__3);
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
    memset(PakuAnimName, 0, paku_name_size);
    memset(PakuAnimName2, 0, paku_name_size);
    PakuMotionEohNo = -1;
    memset(PakuMotionName, 0, paku_name_size);
    PakuMotionType = 0;
    memset(PakuMotionName2, 0, paku_name_size);
    PakuMotionType2 = 0;
    EdEventInfoCommandInitialize();
    EventSeqInit();
    for (i = 0; i < event_sprite2_num; i++) {
        EventSprite2[i].Initialize();
    }

    HitEffect[0].live_num = 0;
    HitEffect[0].spark = (BattleEffectPrim *)Hit_para[0];
    HitEffect[0].spark_max = hit_spark_num;
    HitEffect[1].spark = (BattleEffectPrim *)Hit_para[1];
    SwordEffect = NULL;
    HitEffect[2].spark = (BattleEffectPrim *)Hit_para[2];
    EventEffectScript = 0;
    HitEffect[3].spark = (BattleEffectPrim *)Hit_para[3];
    HitEffect[4].spark = (BattleEffectPrim *)Hit_para[4];
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", EventTimeDraw__Fv);
void EdEventDraw(void) {
    int hitNo;
    int spriteNo;

    EventRain.Step();
    EventRain.Draw();
    for (hitNo = 0; hitNo < hit_effect_num; hitNo++) {
        HitEffect[hitNo].Draw();
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
    for (spriteNo = 0; spriteNo < event_sprite2_num; spriteNo++) {
        EventSprite2[spriteNo].NormalDraw();
    }
    EventScreenEffect.Draw();
    DrawMenuDl(0x80);
    DrawDownLoadAnaunce();
}
void EdEventFirstDraw(void) {
    int i;

    for (i = 0; i < event_sprite2_num; i++) {
        EventSprite2[i].FirstDraw();
    }
}
int EdEventFinish(void) {
    mgCCamera *camera;
    int i;
    int j;
    int k;

    CameraSeq.Initialize(cmr_seq_tbl, seq_node_num);
    for (i = 0; i < object_seq_num; i++) {
        ObjectSeq[i].Initialize(obj_seq_tbl, seq_node_num);
    }
    for (j = 0; j < event_sprite2_num; j++) {
        EventSprite2[j].Initialize();
    }

    HitEffect[0].live_num = 0;
    HitEffect[0].spark = (BattleEffectPrim *)Hit_para[0];
    HitEffect[0].spark_max = hit_spark_num;
    HitEffect[1].spark = (BattleEffectPrim *)Hit_para[1];
    EventEffectScript = 0;
    HitEffect[2].spark = (BattleEffectPrim *)Hit_para[2];
    HitEffect[3].spark = (BattleEffectPrim *)Hit_para[3];
    HitEffect[4].spark = (BattleEffectPrim *)Hit_para[4];
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
    camera = (mgCCamera *)EventScene->GetCamera(EventScene->active_camera);
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
    memset(PakuAnimName, 0, paku_name_size);
    memset(PakuAnimName2, 0, paku_name_size);
    PakuMotionEohNo = -1;
    memset(PakuMotionName, 0, paku_name_size);
    PakuMotionType = 0;
    memset(PakuMotionName2, 0, paku_name_size);
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
int EdEventStep(void) {
    int seqNo;
    int hitNo;

    mgSetProjection(EdEventInfo.projection);
    for (seqNo = 0; seqNo < object_seq_num; seqNo++) {
        ObjectSeq[seqNo].Play();
    }
    CameraSeq.Play();
    if (Sphida != NULL) {
        Sphida->Step();
    }
    for (hitNo = 0; hitNo < hit_effect_num; hitNo++) {
        HitEffect[hitNo].Step();
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
void InitDramaScene(void) {
    EdEventInfo.skip_fade_color[0] = 0;
    EdEventInfo.skip_fade_color[1] = 0;
    EdEventInfo.skip_state = 1;
    EdEventInfo.skip_button = 15;
    EdEventInfo.skip_fade_color[2] = 0;
    EdEventInfo.skip_fade_color[3] = 0;
}
void CancelDramaScene(void) {
    EdEventInfo.skip_state = 0;
}
void EdEventMenuExit(void) {
    if (p_use_item != 0) {
        p_use_item->i = MenuArg.result[0];
    }
    p_use_item = 0;
}
void EdEventLoopInit(void) {
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
void EdSetBrokenObject(void) {
}
void ResetMesFileBuffAll(void) {
    int i;
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
void EdEventMapInit(void) {
    ClsMes *message;
    int i;

    message = GetSystemMessage();
    if (message != NULL) {
        message->Preset(5);
    }
    for (i = 0; i < event_local_num; i++) {
        EventLocalFlag[i] = 0;
    }
    InitLocalCnt();
    message = GetSystemMessage(0);
    if (message != NULL) {
        message->draw_speed = message->GetDrawSpeedDef();
        message->mes_no = -1;
        message->unk_1e40 = 0;
        message->open = 0;
        message->fade = 0;
        message->fukidashi_centre_x = -1;
        message->fukidashi_centre_y = -1;
    }
    message = GetSystemMessage(1);
    if (message != NULL) {
        message->draw_speed = message->GetDrawSpeedDef();
        message->mes_no = -1;
        message->unk_1e40 = 0;
        message->open = 0;
        message->fade = 0;
        message->fukidashi_centre_x = -1;
        message->fukidashi_centre_y = -1;
    }
    message = GetSystemMessage(2);
    if (message != NULL) {
        message->draw_speed = message->GetDrawSpeedDef();
        message->mes_no = -1;
        message->unk_1e40 = 0;
        message->open = 0;
        message->fade = 0;
        message->fukidashi_centre_x = -1;
        message->fukidashi_centre_y = -1;
    }
    ResetMesFileBuffAll();
    EdSetBrokenObject();
    InitSphida();

    HitEffect[0].live_num = 0;
    HitEffect[0].spark = (BattleEffectPrim *)Hit_para[0];
    HitEffect[0].spark_max = hit_spark_num;
    SwordEffect = NULL;
    HitEffect[1].spark = (BattleEffectPrim *)Hit_para[1];
    EventEffectScript = 0;
    HitEffect[2].spark = (BattleEffectPrim *)Hit_para[2];
    HitEffect[3].spark = (BattleEffectPrim *)Hit_para[3];
    HitEffect[4].spark = (BattleEffectPrim *)Hit_para[4];
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
void EdEventTermination(void) {
    EdEventInfo.stream_playing = 0;
    if (EdEventInfo.stream_from_fpl == 1) {
        CSnd.StreamEND(1);
    }
    CSnd.StreamSetVol(1, EdEventInfo.stream_volume, EdEventInfo.stream_volume);
    CSnd.StreamClose(1);
    EdEventInfo.stream_reading = 0;
}
void EdEventEnd(void) {
    ResetMesFileBuffAll();
    EventSeqInit();
}
CSceneObjSeq *GetObjSeq(int index) {
    if (index < 0 || index >= object_seq_num) {
        return NULL;
    }
    return &ObjectSeq[index];
}
extern "C" int _GET_PADON__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argCount) {
    if (argCount <= 0) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(stack, GamePad__2.GetPadOn());
    return 1;
}
extern "C" int _GET_PADDOWN__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argCount) {
    if (argCount <= 0) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(stack, GamePad__2.GetPadDown());
    return 1;
}
extern "C" int _GET_PADUP__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argCount) {
    if (argCount <= 0) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(stack, GamePad__2.GetPadUp());
    return 1;
}
int _GET_APAD(RS_STACKDATA *stack, int argCount) {
    if (argCount > 0) {
        SetStack__FP12RS_STACKDATAf__2(stack++, GamePad__2.GetLXf());
    }
    if (argCount > 1) {
        SetStack__FP12RS_STACKDATAf__2(stack++, GamePad__2.GetLYf());
    }
    if (argCount > 2) {
        SetStack__FP12RS_STACKDATAf__2(stack++, GamePad__2.GetRXf());
    }
    if (argCount > 3) {
        SetStack__FP12RS_STACKDATAf__2(stack++, GamePad__2.GetRYf());
    }
    return 1;
}
u32 *CheckLoadedBGFile(char *name, int *size) {
    char path[0x80];
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
    return (u32 *)info->buffer;
}
u32 *GetLoadBGBuff(char *name, int *size) {
    char path[0x8C];
    int loadedSize;
    u32 *buffer;

    strcpy(path, name);
    FileNameConvLanguage(path);
    buffer = (u32 *)CheckLoadedBGFile(path, &loadedSize);
    if (buffer != NULL) {
        printf(at_2245__2, path);
        if (size != NULL) {
            *size = loadedSize;
        }
    } else {
        if (EdEventInfo.pack_loaded == 1) {
            printf(at_2246__2, path);
            buffer = GetPackFile((u32 *)read_buffer, path, &loadedSize);
            if (buffer != NULL) {
                if (size != NULL) {
                    *size = loadedSize;
                }
            } else {
                EdEventInfo.pack_loaded = 0;
            }
        }
        if (EdEventInfo.pack_loaded != 1) {
            if (EdEventInfo.stream_reading == 1) {
                printf(at_2247__2);
                printf(at_2248__2);
                printf(at_2247__2);
                while (1) {
                }
            }
            printf(at_2249__2, path);
            if (LoadFile2(path, read_buffer, &loadedSize, 0) == 0) {
                buffer = NULL;
            } else {
                buffer = (u32 *)read_buffer;
                if (size != NULL) {
                    *size = loadedSize;
                }
            }
        }
    }
    return buffer;
}
int _GOTO_INTERIOR(RS_STACKDATA *stack, int argCount) {
    EdEventInfo.jump_point = GetStackInt__FP12RS_STACKDATA__2(stack++);
    strcpy(EdEventInfo.jump_map_name, (char *)GetStackString__FP12RS_STACKDATA__2(stack++));
    if (argCount > 2) {
        EdEventInfo.event_no = GetStackInt__FP12RS_STACKDATA__2(stack++);
    } else {
        EdEventInfo.event_no = 100;
    }
    if (argCount > 3) {
        EdEventInfo.interior_entrance = GetStackInt__FP12RS_STACKDATA__2(stack);
    } else {
        EdEventInfo.interior_entrance = 0;
    }
    EdEventInfo.request = 4;
    return 1;
}
int _GOTO_OUTSIDE(RS_STACKDATA *stack, int argCount) {
    EdEventInfo.jump_point = GetStackInt__FP12RS_STACKDATA__2(stack++);
    strcpy(EdEventInfo.jump_map_name, (char *)GetStackString__FP12RS_STACKDATA__2(stack++));
    if (argCount > 2) {
        EdEventInfo.event_no = GetStackInt__FP12RS_STACKDATA__2(stack);
    } else {
        EdEventInfo.event_no = 100;
    }
    EdEventInfo.request = 7;
    return 1;
}
int _INITIALIZE(RS_STACKDATA *stack, int argCount) {
    mgCCameraFollow *camera;

    EdEventInit();
    camera = (mgCCameraFollow *)GetActiveCamera();
    if (camera == NULL) {
        return 0;
    }
    camera->FollowOff();
    return 1;
}
int _LOAD_CHARA_sub(int stackNo, char **name, int charaNo, u32 *pack, int mode) {
    u32 *files[pack_file_max];
    int sizes[pack_file_max];
    char label[0x20];
    mgCMemory *stack;
    int texBlock;
    int result;
    mgCTextureManager *manager;

    stack = (mgCMemory *)EventScene->GetStack(stackNo);
    if (*name == NULL) {
        if (GetPackFileExt(pack, at_2291, files, pack_file_max, sizes, name) <= 0) {
            return 0;
        }
    }
    texBlock = EventScene->GetCharaTexb(charaNo);
    if (texBlock < 0) {
        return 0;
    }
    manager = &mgTexManager;
    manager->DeleteBlock(texBlock);
    sprintf(label, at_2292__2, charaNo);
    if (charaNo >= 8) {
        strcpy(manager->name_suffix, label);
    }
    result = EventScene->LoadChara(charaNo, pack, *name, stack, stack, stack, texBlock, mode);
    if (charaNo >= 8) {
        manager->name_suffix[0] = 0;
    }
    EventScene->SetType(1, charaNo, type_loaded);
    return result;
}
int _LOAD_CHARA_sub(int a, char **b, int c, u32 *d) {
    return _LOAD_CHARA_sub(a, b, c, d, 0);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _LOAD_CHARA__FP12RS_STACKDATAi);
int _CHARA_ACTIVE(RS_STACKDATA *stack, int argCount) {
    int enable;
    int charaNo;

    switch (argCount) {
        case 1:
            EventScene->SetActive(1, GetStackInt__FP12RS_STACKDATA__2(stack));
            return 1;
        case 2:
            enable = GetStackInt__FP12RS_STACKDATA__2(stack++);
            charaNo = GetStackInt__FP12RS_STACKDATA__2(stack);
            if (enable != 0) {
                EventScene->SetActive(1, charaNo);
            } else {
                EventScene->ResetActive(1, charaNo);
            }
            return 1;
    }
    return 0;
}
int _CLEAR_STACK(RS_STACKDATA *stack, int argCount) {
    EventScene->ClearStack(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
int _ASSIGN_STACK(RS_STACKDATA *stack, int argCount) {
    EventScene->AssignStack(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
int _SET_FLAG(RS_STACKDATA *stack, int argCount) {
    CSaveData *saveData;
    int bit;
    int value;

    bit = GetStackInt__FP12RS_STACKDATA__2(stack++);
    value = GetStackInt__FP12RS_STACKDATA__2(stack);
    saveData = GetSaveData();
    if (saveData == NULL) {
        return 0;
    }
    saveData->SetBitFlag(bit, value);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_FLAG__FP12RS_STACKDATAi);
int _SET_CNT(RS_STACKDATA *stack, int argCount) {
    CSaveData *saveData;
    int index;
    int value;

    index = GetStackInt__FP12RS_STACKDATA__2(stack++);
    value = GetStackInt__FP12RS_STACKDATA__2(stack);
    saveData = GetSaveData();
    if (saveData == NULL) {
        return 0;
    }
    saveData->SetShortFlag(index, value);
    return 1;
}
int _GET_CNT(RS_STACKDATA *stack, int argCount) {
    CSaveData *saveData;
    int index;

    index = GetStackInt__FP12RS_STACKDATA__2(stack++);
    saveData = GetSaveData();
    if (saveData == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(stack, saveData->GetShortFlag(index));
    return 1;
}
int _SET_CURRENT_DIR(RS_STACKDATA *stack, int argc) {
    char *dir = NULL;
    if (argc > 0) {
        dir = GetStackString__FP12RS_STACKDATA__2(stack);
    }
    if (dir == NULL || strcmp(dir, at_2393__3) == 0 || strcmp(dir, at_1083) == 0) {
        SetCurrentDir(NULL);
    } else {
        SetCurrentDir(dir);
    }
    return 1;
}
int _CHANGE_DIR(RS_STACKDATA *stack, int argc) {
    char *dir = NULL;
    if (argc > 0) {
        dir = GetStackString__FP12RS_STACKDATA__2(stack);
    }
    if (dir == NULL || strcmp(dir, at_2393__3) == 0 || strcmp(dir, at_1083) == 0) {
        SetCurrentDir(NULL);
    } else {
        ChangeDir(dir);
    }
    return 1;
}
int _DELETE_CHARA(RS_STACKDATA *stack, int argc) {
    int charaNo;
    int deleteTexture = 1;
    charaNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    if (argc >= 2) {
        deleteTexture = GetStackInt__FP12RS_STACKDATA__2(stack);
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
int _LOAD_MOTION_sub(int stackNo, char *name, int charaNo, u32 *pack) {
    char label[0x20];
    mgCMemory *stack = (mgCMemory *)EventScene->GetStack(stackNo);
    CCharacter2 *chara = EventScene->GetCharacter(charaNo);
    if (chara == NULL) {
        return 0;
    }
    int texBlock = EventScene->GetCharaTexb(charaNo);
    if (texBlock < 0) {
        return 0;
    }
    sprintf(label, at_2292__2, charaNo);
    mgCTextureManager *manager = &mgTexManager;
    if (charaNo >= 8) {
        strcpy(manager->name_suffix, label);
    }
    chara->LoadPack(pack, name, stack, stack, stack, texBlock, 0);
    if (charaNo >= 8) {
        manager->name_suffix[0] = 0;
    }
    return 1;
}
int _LOAD_MOTION(RS_STACKDATA *stack, int argc) {
    int stackNo;
    int charaNo;
    char *packName;
    char *motionName;
    u32 *pack;
    switch (argc) {
        case 1: {
            int key = GetStackInt__FP12RS_STACKDATA__2(stack);
            int count;
            int i;
            ARG_LIST *node;
            ARG_DATA *args;

            node = EventScriptArg.list;
            if (node == NULL) {
                args = NULL;
                goto haveArgs;
            }
            count = EventScriptArg.list_num;
            i = 0;
            goto test;
        body:
            if (key == node->id) {
                goto done;
            }
            node = node->next;
            if (node != NULL) {
                i++;
                goto test;
            }
            args = NULL;
            goto haveArgs;
        test:
            if (i < count) {
                goto body;
            }
        done:
            if (node == NULL) {
                args = NULL;
                goto haveArgs;
            }
            args = node->args;
        haveArgs:
            if (args == NULL) {
                return 0;
            }
            stackNo = GetArgInt(args++);
            packName = (char *)GetArgString(args++);
            motionName = (char *)GetArgString(args++);
            charaNo = GetArgInt(args);
            break;
        }
        case 4:
            stackNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
            packName = GetStackString__FP12RS_STACKDATA__2(stack++);
            motionName = GetStackString__FP12RS_STACKDATA__2(stack++);
            charaNo = GetStackInt__FP12RS_STACKDATA__2(stack);
            break;
        default:
            return 0;
    }
    pack = GetLoadBGBuff(packName, 0);
    if (pack == NULL) {
        return 0;
    }
    return _LOAD_MOTION_sub(stackNo, motionName, charaNo, pack);
}
int _MAP_JUMP(RS_STACKDATA *stack, int argc) {
    EdEventInfo.jump_point = GetStackInt__FP12RS_STACKDATA__2(stack++);
    switch (stack->type) {
        case 0:
            strcpy(EdEventInfo.jump_map_name, GetMapName(GetStackInt__FP12RS_STACKDATA__2(stack++), NULL));
            break;
        case 2:
            strcpy(EdEventInfo.jump_map_name, GetStackString__FP12RS_STACKDATA__2(stack++));
            break;
        default:
            return 0;
    }
    if (argc > 2) {
        EdEventInfo.event_no = GetStackInt__FP12RS_STACKDATA__2(stack);
    } else {
        EdEventInfo.event_no = 100;
    }
    EdEventInfo.request = exit_map_jump;
    return 1;
}
int _SET_RAIN(RS_STACKDATA *stack, int argc) {
    if (GetStackInt__FP12RS_STACKDATA__2(stack) != 0) {
        EventRain.Start();
    } else {
        EventRain.Stop();
    }
    return 1;
}
int _DEL_EXT_MOTION(RS_STACKDATA *stack, int argc) {
    CCharacter2 *character = EventScene->GetCharacter(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (character == NULL) {
        return 0;
    }
    character->DeleteExtMotion();
    return 1;
}
int _SET_MARKER(RS_STACKDATA *stack, int argc) {
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_WORLD_COORD__FP12RS_STACKDATAi);
void _FINISH(RS_STACKDATA *stack, int argc) {
    EdEventFinish();
}
int _GET_DUN_WORLD_COORD(RS_STACKDATA *stack, int argc) {

    float position[4];
    float indexedPosition[6];
    float angle;
    float indexedAngle;

    if (argc == 4) {
        if (GetDungeonEventPoint(position, &angle, 0) == 0) {
            return 0;
        }
        SetStack__FP12RS_STACKDATAf__2(stack++, position[0]);
        SetStack__FP12RS_STACKDATAf__2(stack++, position[1]);
        SetStack__FP12RS_STACKDATAf__2(stack++, position[2]);
        SetStack__FP12RS_STACKDATAf__2(stack, angle);
        return 1;
    }
    if (argc == 5) {
        if (GetDungeonEventPoint(indexedPosition, &indexedAngle, GetStackInt__FP12RS_STACKDATA__2(stack + 4)) == 0) {
            return 0;
        }
        SetStack__FP12RS_STACKDATAf__2(stack++, indexedPosition[0]);
        SetStack__FP12RS_STACKDATAf__2(stack++, indexedPosition[1]);
        SetStack__FP12RS_STACKDATAf__2(stack++, indexedPosition[2]);
        SetStack__FP12RS_STACKDATAf__2(stack, indexedAngle);
        return 1;
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _LOAD_IMG__FP12RS_STACKDATAi);
int _DEL_IMG(RS_STACKDATA *stack, int argc) {
    mgTexManager.DeleteBlock(EventScene->event_texb + GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
int _SET_DNG_MAP(RS_STACKDATA *stack, int argc) {
    GetStackInt__FP12RS_STACKDATA__2(stack++);
    GetStackInt__FP12RS_STACKDATA__2(stack);
    return 1;
}
int _LOAD_ITEM(RS_STACKDATA *stack, int argc) {
    char *name[32];
    int stackNo;
    int charaNo;
    int itemNo;
    int index = 0;
    u32 *pack;
    switch (argc) {
        case 1: {
            int key = GetStackInt__FP12RS_STACKDATA__2(stack);
            int count;
            int i;
            ARG_LIST *node;
            ARG_DATA *args;

            node = EventScriptArg.list;
            if (node == NULL) {
                args = NULL;
                goto haveArgs;
            }
            count = EventScriptArg.list_num;
            i = 0;
            goto test;
        body:
            if (key == node->id) {
                goto done;
            }
            node = node->next;
            if (node != NULL) {
                i++;
                goto test;
            }
            args = NULL;
            goto haveArgs;
        test:
            if (i < count) {
                goto body;
            }
        done:
            if (node == NULL) {
                args = NULL;
                goto haveArgs;
            }
            argc = node->arg_num;
            args = node->args;
        haveArgs:
            if (args == NULL) {
                return 0;
            }
            stackNo = GetArgInt(args++);
            itemNo = GetArgInt(args++);
            name[0] = (char *)GetArgString(args++);
            charaNo = GetArgInt(args++);
            if (argc >= 5) {
                index = GetArgInt(args);
            }
            break;
        }
        case 4:
        case 5:
            stackNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
            itemNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
            name[0] = GetStackString__FP12RS_STACKDATA__2(stack++);
            charaNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
            if (argc >= 5) {
                index = GetStackInt__FP12RS_STACKDATA__2(stack);
            }
            break;
        default:
            return 0;
    }
    pack = GetLoadBGBuff(GetItemFilePath(itemNo, index), 0);
    if (pack != NULL) {
        return _LOAD_CHARA_sub(stackNo, name, charaNo, pack);
    }
    return 0;
}
int _GOTO_USE_ITEM(RS_STACKDATA *stack, int argc) {
    int argNo;
    if (stack->type != 3) {
        return 0;
    }
    RS_STACKDATA *itemSlot = stack->p;
    argNo = 1;
    MenuArg.open_type = menu_use_item;
    stack++;
    MenuArg.param[0] = argNo;
    p_use_item = itemSlot;
    if (argc > 1) {
        do {
            MenuArg.param[argNo] = GetStackInt__FP12RS_STACKDATA__2(stack++);
            argNo++;
        } while (argNo < argc);
    }
    MenuArg.param[argNo] = 0;
    EdEventInfo.command_mode = request_menu;
    return 1;
}
int _SET_LOCAL_FLAG(RS_STACKDATA *stack, int argc) {
    int index = GetStackInt__FP12RS_STACKDATA__2(stack++);
    SetLocalFlag(index, GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
int _GET_LOCAL_FLAG(RS_STACKDATA *stack, int argc) {
    int index = GetStackInt__FP12RS_STACKDATA__2(stack++);

    argc = GetLocalFlag(index);
    SetStack__FP12RS_STACKDATAi__2(stack, argc);
    return 1;
}
int _GOTO_SELECT_PARTY(RS_STACKDATA *stack, int argc) {
    MenuArg.open_type = menu_select_party;
    EdEventInfo.command_mode = request_menu;
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_LOADBG_FILE__FP12RS_STACKDATAi);
int _SET_LOADBG_FILE_MONS_TALK(RS_STACKDATA *stack, int argc) {
    char path[0x8C];
    int size;
    u_long128 *buffer = read_buffer;
    StartReadBG();
    sprintf(path, at_2664__2, DngStatus.dungeon_no, LanguageCode);
    if (LoadFileBG(path, buffer, &size) == 0) {
        return 0;
    }
    EdEventInfo.pack_loaded = 0;
    return 1;
}
int _CHECK_LOADBG_FILE(RS_STACKDATA *stack, int argc) {
    argc = ReadBGSync();
    SetStack__FP12RS_STACKDATAi__2(stack, argc);
    return 1;
}
int _GET_TB_ITEMNO(RS_STACKDATA *stack, int argc) {
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_TB_STATUS__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_TB_ANGLE__FP12RS_STACKDATAi);
int _ADD_ITEM(RS_STACKDATA *stack, int argc) {
    int itemNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int count = 1;
    if (argc == 2) {
        count = GetStackInt__FP12RS_STACKDATA__2(stack);
    }
    CUserDataManager *userData = NULL;
    CSaveData *save = GetSaveData();
    if (save != NULL) {
        userData = &save->user_data;
    }
    if (userData == NULL) {
        return 0;
    }
    return userData->GetItem(itemNo, count);
}
int _SUB_ITEM(RS_STACKDATA *stack, int argc) {

    int itemNo;
    int count = 1;
    itemNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    if (argc >= 2) {
        count = GetStackInt__FP12RS_STACKDATA__2(stack);
    }
    CSaveData *save = GetSaveData();
    if (save == NULL) {
        return 0;
    }
    CUserDataManager *userData = &save->user_data;
    if (userData == NULL) {
        return 0;
    }
    userData->DeleteItem(itemNo, count);
    return 1;
}
int _GET_ITEM_TYPE(RS_STACKDATA *stack, int argc) {
    int itemType = GetItemDataType__Fi(GetStackInt__FP12RS_STACKDATA__2(stack++));
    int category;
    if (itemType == 0) {
        return 0;
    }
    switch (itemType) {
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
    SetStack__FP12RS_STACKDATAi__2(stack, category);
    return 1;
}
int _GET_ITEM_SPACE(RS_STACKDATA *stack, int argc) {
    CUserDataManager *userData = NULL;
    CSaveData *save = GetSaveData();
    if (save != NULL) {
        userData = &save->user_data;
    }
    if (userData == NULL) {
        return 0;
    }
    argc = userData->SearchSpaceUsedData();
    SetStack__FP12RS_STACKDATAi__2(stack, argc);
    return 1;
}
s8 GetConfigCaptionOff(void) {
    s8 captionOff = 0;
    CSaveData *save = GetSaveData();
    if (save != NULL) {
        SV_CONFIG_OPTION *config = &save->config;
        if (config != NULL) {
            captionOff = config->caption_off;
        }
    }
    return captionOff;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", LoadMovie__FPcP9mgCMemoryb);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _LOAD_MOVIE__FP12RS_STACKDATAi);
int _INIT_LOCAL_CNT(RS_STACKDATA *stack, int argc) {
    InitLocalCnt();
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_CROSSFADE__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_ADJUST_POLYGON_SCALE__FP12RS_STACKDATAi);
int _SET_TIME(RS_STACKDATA *stack, int argc) {
    EventScene->SetTime(GetStackFloat__FP12RS_STACKDATA__2(stack));
    return 1;
}
int _SET_ACTIVE_LIGHT(RS_STACKDATA *stack, int argc) {

    CMap *maps[8];

    int lightNo = GetStackInt__FP12RS_STACKDATA__2(stack);
    if (EventScene->GetActiveMap(maps, 8) <= 0) {
        return 0;
    }
    if (lightNo >= 0) {
        if (lightNo < maps[0]->lighting_info_num) {
            maps[0]->active_light_no = lightNo;
        }
    }
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_PAKU_ANIM__FP12RS_STACKDATAi);
int _RESET_PAKU_ANIM(RS_STACKDATA *stack, int argc) {
    PakuAnimEohNo = -1;
    memset(PakuAnimName, 0, sizeof(PakuAnimName));
    memset(PakuAnimName2, 0, sizeof(PakuAnimName2));
    return 1;
}
int _TRG_PAKU_ANIM(RS_STACKDATA *stack, int argc) {
    if (GetStackInt__FP12RS_STACKDATA__2(stack) != 0) {
        if (strcmp(PakuAnimName2, at_1083) != 0) {
            EventObjHandleMother.SetTexAnim( PakuAnimEohNo, 0, PakuAnimName2);
        }
        EventObjHandleMother.SetTexAnim( PakuAnimEohNo, 1, PakuAnimName);
    } else {
        EventObjHandleMother.SetTexAnim( PakuAnimEohNo, 0, PakuAnimName);
        if (strcmp(PakuAnimName2, at_1083) != 0) {
            EventObjHandleMother.SetTexAnim( PakuAnimEohNo, 1, PakuAnimName2);
        }
    }
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _RESET_CAMERA__FP12RS_STACKDATAi);
int _GET_ACTIVE_CHR_NO(RS_STACKDATA *stack, int argc) {
    CUserDataManager *userData = NULL;
    CSaveData *save = GetSaveData();
    if (save != NULL) {

        userData = &save->user_data;
    }
    if (userData == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(stack, userData->active_chr_no);
    return 1;
}
int _SET_ACTIVE_CHR_NO(RS_STACKDATA *stack, int argc) {
    CUserDataManager *userData = NULL;
    CSaveData *save = GetSaveData();
    if (save != NULL) {
        userData = &save->user_data;
    }
    if (userData == NULL) {
        return 0;
    }
    userData->SetActiveChrNo(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
int _DNG_SET_FLOOR_ID(RS_STACKDATA *stack, int argc) {
    int floorId = GetStackInt__FP12RS_STACKDATA__2(stack);
    CSaveData *save = GetSaveData();
    if (save == NULL) {
        return 0;
    }
    CSaveDataDungeon *dungeon = &save->save_dungeon;
    if (dungeon == NULL) {
        return 0;
    }
    dungeon->SetFloorID(floorId);
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
    SetStack__FP12RS_STACKDATAi__2(stack, dungeon->floor_id[dungeon->stage_id]);
    return 1;
}
int _SET_PAKU_MOTION(RS_STACKDATA *stack, int argc) {
    int eohNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    char *name = GetStackString__FP12RS_STACKDATA__2(stack++);
    int type = GetStackInt__FP12RS_STACKDATA__2(stack++);
    char *name2 = NULL;
    int type2 = 0;
    if (argc > 3) {
        name2 = GetStackString__FP12RS_STACKDATA__2(stack++);
        type2 = GetStackInt__FP12RS_STACKDATA__2(stack);
    }
    PakuMotionEohNo = eohNo;
    strcpy((char *)PakuMotionName, name);
    PakuMotionType = type;
    if (name2 != NULL) {
        strcpy((char *)PakuMotionName2, name2);
    } else {
        strcpy((char *)PakuMotionName2, at_1083);
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
    int mode = GetStackInt__FP12RS_STACKDATA__2(stack);
    if (mode == 0) {
        EventObjHandleMother.SetMotion( PakuMotionEohNo, PakuMotionName,
                                      PakuMotionType, -1.0f);
        return 1;
    }
    if (strcmp(PakuMotionName2, at_1083) == 0) {
        return 1;
    }
    if (mode == 1) {
        if (strcmp(PakuMotionName,
                   EventObjHandleMother.GetNowMotionName( PakuMotionEohNo)) == 0) {
            if (EventObjHandleMother.GetNowMotionStatus( PakuMotionEohNo) == 0 ||
                EventObjHandleMother.GetNowMotionStatus( PakuMotionEohNo) == 4) {
                EventObjHandleMother.SetMotion( PakuMotionEohNo,
                                              PakuMotionName2, PakuMotionType2, -1.0f);
                return 1;
            }
            return 1;
        }
        EventObjHandleMother.SetMotion( PakuMotionEohNo, PakuMotionName2,
                                      PakuMotionType2, -1.0f);
        return 1;
    }
    if (mode == 2) {
        EventObjHandleMother.SetMotion( PakuMotionEohNo, PakuMotionName2,
                                      PakuMotionType2, -1.0f);
        return 1;
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_BG_COLOR__FP12RS_STACKDATAi);
int _GOTO_DNG_MAP(RS_STACKDATA *stack, int argc) {
    MenuArg.open_type = menu_dng_map;
    MenuArg.param[0] = GetStackInt__FP12RS_STACKDATA__2(stack);
    EdEventInfo.command_mode = request_menu;
    return 1;
}
int _GOTO_DNG(RS_STACKDATA *stack, int argc) {
    INIT_LOOP_ARG loopArg;
    if (EdEventFinish() == 0) {
        return 0;
    }
    memset(&loopArg, 0, sizeof(loopArg));
    loopArg.map_no = GetStackInt__FP12RS_STACKDATA__2(stack++);
    loopArg.floor_no = -1;
    loopArg.event_no = -1;
    if (argc > 1) {
        loopArg.floor_no = GetStackInt__FP12RS_STACKDATA__2(stack++);
    }
    if (argc > 2) {
        loopArg.event_no = GetStackInt__FP12RS_STACKDATA__2(stack);
    }
    NextLoop(2, loopArg);
    EdEventInfo.request = exit_start_loop;
    return 1;
}
int _GOTO_EDIT(RS_STACKDATA *stack, int argc) {
    INIT_LOOP_ARG loopArg;
    if (EdEventFinish() == 0) {
        return 0;
    }
    memset(&loopArg, 0, sizeof(loopArg));
    loopArg.map_no = GetStackInt__FP12RS_STACKDATA__2(stack++);
    loopArg.event_no = -1;
    if (argc > 1) {
        loopArg.event_no = GetStackInt__FP12RS_STACKDATA__2(stack);
    }
    NextLoop(1, loopArg);
    EdEventInfo.request = exit_start_loop;
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_MENU_PARAM__FP12RS_STACKDATAi);
int _LOAD_CHARA_NPC(RS_STACKDATA *stack, int argc) {
    char path[0x80];
    char *modelName[0x80];
    int kind = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int stackNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int charaNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    char *name;
    u32 *pack;
    if (charaNo <= 0) {
        return 0;
    }
    if (charaNo >= 32) {
        return 0;
    }
    if (kind == 0) {
        name = GetPartyCharaModelName(charaNo, 0);
    } else {
        name = GetPartyCharaModelName(charaNo, 2);
    }
    if (name == NULL) {
        return 0;
    }
    strcpy(path, name);
    modelName[0] = GetPartyCharaModelName(charaNo, 1);
    if (modelName[0] == NULL) {
        return 0;
    }
    kind = GetStackInt__FP12RS_STACKDATA__2(stack);
    pack = GetLoadBGBuff(path, 0);
    if (pack != NULL) {
        return _LOAD_CHARA_sub(stackNo, modelName, kind, pack);
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _AUTO_SET_TREASURE_BOX__FP12RS_STACKDATAi);
int _AUTO_SET_MONSTER(RS_STACKDATA *stack, int argc) {
    float position[4];
    float direction[4];
    int monsterNo;
    int param;
    if (GetNowLoopNo() != 2) {
        return 0;
    }
    if (argc < 2) {
        AutoSetMonster();
        return 1;
    }
    monsterNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    GetStackVector__FPfP12RS_STACKDATA(position, stack);
    stack += 3;
    mgZeroVectorW(direction);
    if (argc >= 7) {
        GetStackVector__FPfP12RS_STACKDATA(direction, stack);
        stack += 3;
    }
    if (argc == 8) {
        param = GetStackInt__FP12RS_STACKDATA__2(stack);
    }
    AutoSetMonster(monsterNo, position, direction, param);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _LOAD_DUNGEON_MAP_FILE__FP12RS_STACKDATAi);
int _LOAD_MONSTER_FILE(RS_STACKDATA *stack, int argc) {
    if (GetNowLoopNo() != 2) {
        return 0;
    }
    switch (argc) {
        case 1:
            LoadMonsterFile();
            break;
        case 2: {
            int first = GetStackInt__FP12RS_STACKDATA__2(stack++);
            LoadMonsterFile(first, GetStackInt__FP12RS_STACKDATA__2(stack));
            break;
        }
        default:
            return 0;
    }
    return 1;
}
int _GET_NPC_STATUS(RS_STACKDATA *stack, int argc) {
    int npcNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    if (npcNo <= 0) {
        return 0;
    }
    CUserDataManager *userData = NULL;
    if (npcNo > 0x20) {
        return 0;
    }
    CSaveData *save = GetSaveData();
    if (save != NULL) {
        userData = &save->user_data;
    }
    if (userData == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(stack, userData->GetPartyCharaStatus(npcNo));
    return 1;
}
int _SET_NPC_STATUS(RS_STACKDATA *stack, int argc) {
    int npcNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int status = GetStackInt__FP12RS_STACKDATA__2(stack);
    if (npcNo <= 0) {
        return 0;
    }
    CUserDataManager *userData = NULL;
    if (npcNo > 0x20) {
        return 0;
    }
    CSaveData *save = GetSaveData();
    if (save != NULL) {
        userData = &save->user_data;
    }
    if (userData == NULL) {
        return 0;
    }
    userData->SetPartyCharaStatus(npcNo, status);
    return 1;
}
int _GET_NOW_PARTY_CHARA(RS_STACKDATA *stack, int argc) {
    CUserDataManager *userData = NULL;
    CSaveData *save = GetSaveData();
    if (save != NULL) {
        userData = &save->user_data;
    }
    if (userData == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(stack, userData->NowPartyCharaID());
    return 1;
}
int _SET_LOCAL_CNT(RS_STACKDATA *stack, int argc) {
    int index = GetStackInt__FP12RS_STACKDATA__2(stack++);
    return SetLocalCnt(index, GetStackInt__FP12RS_STACKDATA__2(stack)) > 0;
}
int _GET_LOCAL_CNT(RS_STACKDATA *stack, int argc) {
    int index = GetStackInt__FP12RS_STACKDATA__2(stack++);
    argc = GetLocalCnt(index);
    if (argc < 0) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(stack, argc);
    return 1;
}
int _GET_LOCAL_CNT2(RS_STACKDATA *stack, int argc) {
    int index = GetStackInt__FP12RS_STACKDATA__2(stack++);

    argc = GetLocalCnt2(index);
    SetStack__FP12RS_STACKDATAi__2(stack, argc);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_TRAIN_NPC_POS__FP12RS_STACKDATAi);
int _GOTO_DRAW_CHAPTER(RS_STACKDATA *stack, int argc) {
    MenuArg.open_type = menu_draw_chapter;
    MenuArg.param[0] = GetStackInt__FP12RS_STACKDATA__2(stack) - 1;
    EdEventInfo.command_mode = request_menu;
    return 1;
}
int _SET_PROJECTION(RS_STACKDATA *stack, int argc) {
    EdEventInfo.projection = GetStackFloat__FP12RS_STACKDATA__2(stack);
    return 1;
}
int _GET_PROJECTION(RS_STACKDATA *stack, int argc) {
    SetStack__FP12RS_STACKDATAf__2(stack, EdEventInfo.projection);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_FADE_IN__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_FADE_OUT__FP12RS_STACKDATAi);
int _DNG_DEBUG_COMMAND(RS_STACKDATA *stack, int argc) {
    ScriptDebugCommand(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
int _CD_SEEK(RS_STACKDATA *stack, int argc) {

    sceCdlFILE *file_info;
    if (sceCdSearchFile(file_info, GetStackString__FP12RS_STACKDATA__2(stack)) != 0) {
        return sceCdSeek(file_info->lsn);
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_ROT_LOOK_POS__FP12RS_STACKDATAi);
extern "C" int _SET_MOTION_BLUR__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    EventScene->motion_blur = GetStackInt__FP12RS_STACKDATA__2(stack);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _LOAD_SCRIPT__FP12RS_STACKDATAi);
int _SET_TALK_CAMERA(RS_STACKDATA *stack, int argc) {
    float middle[4];
    float offset[4];
    float rotation[4][4];
    struct {
        float v[3];
        u32 w;
    } from, to;
    float angle;
    float *middleY;
    from.v[0] = GetStackFloat__FP12RS_STACKDATA__2(stack++);
    from.v[1] = GetStackFloat__FP12RS_STACKDATA__2(stack++);
    from.v[2] = GetStackFloat__FP12RS_STACKDATA__2(stack++);
    to.v[0] = GetStackFloat__FP12RS_STACKDATA__2(stack++);
    to.v[1] = GetStackFloat__FP12RS_STACKDATA__2(stack++);
    to.v[2] = GetStackFloat__FP12RS_STACKDATA__2(stack++);
    angle = GetStackFloat__FP12RS_STACKDATA__2(stack++);
    sceVu0AddVector(middle, from.v, to.v);
    sceVu0ScaleVector(middle, middle, 0.5f);
    middleY = &middle[1];
    *middleY += 30.0f;
    sceVu0UnitMatrix(rotation);
    sceVu0RotMatrixY(rotation, rotation, angle);
    sceVu0ApplyMatrix(offset, rotation, &vv_3333[4]);
    sceVu0AddVector(offset, middle, offset);
    SetStack__FP12RS_STACKDATAf__2(stack++, offset[0]);
    SetStack__FP12RS_STACKDATAf__2(stack++, offset[1]);
    SetStack__FP12RS_STACKDATAf__2(stack++, offset[2]);
    SetStack__FP12RS_STACKDATAf__2(stack++, middle[0]);
    SetStack__FP12RS_STACKDATAf__2(stack++, *middleY);
    SetStack__FP12RS_STACKDATAf__2(stack, middle[2]);
    return 1;
}
int _HIT_EFFECT(RS_STACKDATA *stack, int argc) {
    float position[4];
    float direction[4];
    float spread;
    float speed;
    float power;
    float gravity;
    int life;
    int count;
    int index = GetStackInt__FP12RS_STACKDATA__2(stack++);
    position[0] = GetStackFloat__FP12RS_STACKDATA__2(stack++);
    position[1] = GetStackFloat__FP12RS_STACKDATA__2(stack++);
    position[2] = GetStackFloat__FP12RS_STACKDATA__2(stack++);
    position[3] = 1.0f;
    *(u_long128 *)direction = *(u_long128 *)at_3339;
    spread = 50.0f;
    speed = 35.0f;
    power = 0.0f;
    gravity = 0.05f;
    life = 30;
    count = 32;
    if (argc >= 5) {
        GetStackVector__FPfP12RS_STACKDATA(direction, stack);
        stack += 3;
        spread = GetStackFloat__FP12RS_STACKDATA__2(stack++);
        speed = GetStackFloat__FP12RS_STACKDATA__2(stack++);
        power = GetStackFloat__FP12RS_STACKDATA__2(stack++);
        gravity = GetStackFloat__FP12RS_STACKDATA__2(stack++);
        life = GetStackInt__FP12RS_STACKDATA__2(stack++);
        count = GetStackInt__FP12RS_STACKDATA__2(stack);
    }
    HitEffect[index].SethitEffect(position, direction, spread, speed, power, gravity, life, count);
    HitEffect[index].kind = 1;
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _COPY_CHARA__FP12RS_STACKDATAi);
int _GET_START_BUTTON(RS_STACKDATA *stack, int argc) {
    SetStack__FP12RS_STACKDATAi__2(stack, EdEventInfo.start_button);
    return 1;
}
int _MOVE_INTERIOR(RS_STACKDATA *stack, int argc) {
    EdEventInfo.jump_point = GetStackInt__FP12RS_STACKDATA__2(stack++);
    strcpy(EdEventInfo.jump_map_name, GetStackString__FP12RS_STACKDATA__2(stack++));
    if (argc > 2) {
        EdEventInfo.event_no = GetStackInt__FP12RS_STACKDATA__2(stack);
    } else {
        EdEventInfo.event_no = 100;
    }
    EdEventInfo.request = exit_enter_interior;
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_MONSTER_TALK_DATA__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _FUNC_POINT_SHOW__FP12RS_STACKDATAi);
int _GET_NOW_MAP_NO(RS_STACKDATA *stack, int argc) {
    SetStack__FP12RS_STACKDATAi__2(stack, EventScene->now_map_no);
    return 1;
}
int _GET_NOW_SUBMAP_NO(RS_STACKDATA *stack, int argc) {
    SetStack__FP12RS_STACKDATAi__2(stack, EventScene->now_sub_map_no);
    return 1;
}
int _GET_OLD_MAP_NO(RS_STACKDATA *stack, int argc) {
    SetStack__FP12RS_STACKDATAi__2(stack, EventScene->old_map_no);
    return 1;
}
int _GET_OLD_SUBMAP_NO(RS_STACKDATA *stack, int argc) {
    SetStack__FP12RS_STACKDATAi__2(stack, EventScene->old_sub_map_no);
    return 1;
}
int _SET_RAIN_CHARA_NO(RS_STACKDATA *stack, int argc) {
    EventRain.SetCharNo(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_EDIT_PARTS_POS__FP12RS_STACKDATAi);
int _GET_CONTENTS_POS(RS_STACKDATA *stack, int argc) {
    return 1;
}
int _GET_BPOT_POS(RS_STACKDATA *stack, int argc) {
    float position[4];
    sceVu0CopyVector(position, BTsubo.position);
    SetStack__FP12RS_STACKDATAf__2(stack++, position[0]);
    SetStack__FP12RS_STACKDATAf__2(stack++, position[1]);
    SetStack__FP12RS_STACKDATAf__2(stack, position[2]);
    return 1;
}
int _GET_BPOT_STATUS(RS_STACKDATA *stack, int argc) {
    SetStack__FP12RS_STACKDATAi__2(stack, BTsubo.state);
    return 1;
}
int _GET_PERSON_STATUS(RS_STACKDATA *stack, int argc) {
    return 0;
}
int _GET_CONTROL_CHRID(RS_STACKDATA *stack, int argc) {
    SetStack__FP12RS_STACKDATAi__2(stack, EventScene->player_chara);
    return 1;
}
extern "C" int _SET_CAMERA_NEXT_REF__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    float ref[4];
    mgCCameraFollow *camera;
    if ((camera = (mgCCameraFollow *)GetActiveCamera()) == NULL) {
    return 0;
}
    switch (argc) {
        case 1: {
            int key = GetStackInt__FP12RS_STACKDATA__2(stack);
            int count;
            int i;
            ARG_LIST *node;
            ARG_DATA *args;

            node = EventScriptArg.list;
            if (node == NULL) {
                args = NULL;
                goto haveArgs;
            }
            count = EventScriptArg.list_num;
            i = 0;
            goto test;
        body:
            if (key == node->id) {
                goto done;
            }
            node = node->next;
            if (node != NULL) {
                i++;
                goto test;
            }
            args = NULL;
            goto haveArgs;
        test:
            if (i < count) {
                goto body;
            }
        done:
            if (node == NULL) {
                args = NULL;
                goto haveArgs;
            }
            args = node->args;
        haveArgs:
            if (args == NULL) {
                return 0;
            }
            GetArgVector(ref, args);
            break;
        }
        case 3:
            GetStackVector__FPfP12RS_STACKDATA(ref, stack);
            break;
        default:
            return 0;
    }
    camera->SetNextRef( ref);
    return 1;
}
int _GOTO_MENU(RS_STACKDATA *stack, int argc) {
    MenuArg.open_type = GetStackInt__FP12RS_STACKDATA__2(stack++);
    for (int argNo = 0; argNo < argc - 1; argNo++) {
        MenuArg.param[argNo] = GetStackInt__FP12RS_STACKDATA__2(stack++);
    }
    EdEventInfo.command_mode = request_menu;
    return 1;
}
int _GET_MENU_STATUS(RS_STACKDATA *stack, int argc) {
    return 0;
}
int _LOAD_EQUIP(RS_STACKDATA *stack, int argc) {
    char label[0x20];
    char boneName[0x2C];
    char *name;
    int stackNo;
    int memberKind;
    int equipKind;
    int charaNo;
    int attachNo;
    switch (argc) {
        case 1: {
            int key = GetStackInt__FP12RS_STACKDATA__2(stack);
            int count;
            int i;
            ARG_LIST *node;
            ARG_DATA *args;

            node = EventScriptArg.list;
            if (node == NULL) {
                args = NULL;
                goto haveArgs;
            }
            count = EventScriptArg.list_num;
            i = 0;
            goto test;
        body:
            if (key == node->id) {
                goto done;
            }
            node = node->next;
            if (node != NULL) {
                i++;
                goto test;
            }
            args = NULL;
            goto haveArgs;
        test:
            if (i < count) {
                goto body;
            }
        done:
            if (node == NULL) {
                args = NULL;
                goto haveArgs;
            }
            argc = node->arg_num;
            args = node->args;
        haveArgs:
            if (args == NULL) {
                return 0;
            }
            stackNo = GetArgInt(args++);
            memberKind = GetArgInt(args++);
            equipKind = GetArgInt(args++);
            name = (char *)GetArgString(args++);
            charaNo = GetArgInt(args++);
            if (argc >= 6) {
                attachNo = GetArgInt(args);
            }
            break;
        }
        case 5:
        case 6:
            stackNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
            memberKind = GetStackInt__FP12RS_STACKDATA__2(stack++);
            equipKind = GetStackInt__FP12RS_STACKDATA__2(stack++);
            name = GetStackString__FP12RS_STACKDATA__2(stack++);
            charaNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
            if (argc >= 6) {
                attachNo = GetStackInt__FP12RS_STACKDATA__2(stack);
            }
            break;
        default:
            return 0;
    }
    if (memberKind < 0 || memberKind > 1) {
        return 0;
    }
    if (equipKind < 0 || equipKind > 4) {
        return 0;
    }
    CUserDataManager *userData = NULL;
    CSaveData *save = GetSaveData();
    if (save == NULL) {
        return 0;
    }
    userData = &save->user_data;
    if (userData == NULL) {
        return 0;
    }
    char *path;
    CCharacter2 *chara;
    int texBlock;
    u32 *pack;
    if ((path = (char *)userData->GetCharaEquipDataPath(memberKind, equipKind)) == NULL) {
        return 0;
    }
    if ((chara = GetCharacter(charaNo)) == NULL) {
        return 0;
    }
    if (0 > (texBlock = EventScene->GetCharaTexb(charaNo))) {
        return 0;
    }
    if ((pack = GetLoadBGBuff(path, 0)) == NULL) {
        return 0;
    }
    if (equipKind >= 3 || equipKind >= 4) {
        mgCMemory *memory;
        if ((memory = (mgCMemory *)EventScene->GetStack(stackNo)) == NULL) {
            return 0;
        }
        sprintf(label, at_2292__2, charaNo);
        mgCTextureManager *manager = &mgTexManager;
        if (charaNo >= 8) {
            strcpy(manager->name_suffix, label);
        }
        chara->LoadSkin(pack, name, at_1083, memory, texBlock);
        if (charaNo >= 8) {
            manager->name_suffix[0] = 0;
        }
    } else {
        if (_LOAD_CHARA_sub(stackNo, &name, attachNo, pack) <= 0) {
            return 0;
        }
        if (memberKind == 0) {
            switch (equipKind) {
                case 0:
                    strcpy(boneName, at_3631__2);
                    break;
                case 1:
                    strcpy(boneName, at_3632__2);
                    break;
                case 2:
                    strcpy(boneName, at_3633);
                    break;
            }
        } else if (memberKind == 1) {
            switch (equipKind) {
                case 0:
                    strcpy(boneName, at_3634);
                    break;
                case 1:
                    strcpy(boneName, at_3635);
                    break;
                case 2:
                    strcpy(boneName, at_3636);
                    break;
            }
        }
        CCharacter2 *attached;
        if ((attached = GetCharacter(attachNo)) == NULL) {
            return 0;
        }
        if (chara->CObjectFrame::frame == NULL) {
            return 0;
        }
        mgCFrame *bone;
        if ((bone = chara->CObjectFrame::frame->SearchFrame(boneName)) == NULL) {
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
    int charaNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
    if (charaNo < 0 || charaNo > 1) {
        return 0;
    }
    CUserDataManager *userData;

    if (slot < 0 || (userData = NULL, slot > 4)) {
        return 0;
    }
    CSaveData *save = GetSaveData();
    if (save != NULL) {
        userData = &save->user_data;
    }
    if (userData == NULL) {
        return 0;
    }
    CHARA_DATA *chara = userData->GetCharaDataPtr(charaNo);
    if (chara == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(stack, chara->equip[slot].item_no);
    return 1;
}
int _SET_TIME_STEP_ENABLE(RS_STACKDATA *stack, int argc) {
    EventScene->time_step = GetStackInt__FP12RS_STACKDATA__2(stack);
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
    EventScene->active_camera = GetStackInt__FP12RS_STACKDATA__2(stack);
    return 1;
}
int _SET_BEFORE_CMRID(RS_STACKDATA *stack, int argc) {
    EventScene->before_camera = GetStackInt__FP12RS_STACKDATA__2(stack);
    return 1;
}
int _DNGMAP_LOAD(RS_STACKDATA *stack, int argc) {
    int texBase;
    RS_STACKDATA *arg = stack + 1;
    mgCMemory *memory = (mgCMemory *)EventScene->GetStack(GetStackInt__FP12RS_STACKDATA__2(stack));
    int fileIndex = GetStackInt__FP12RS_STACKDATA__2(arg++);
    int texCount = EventScene->event_texb_num;
    texBase = EventScene->event_texb;
    if (texCount <= 0 || texCount < fileIndex) {
        return 0;
    }
    int param1 = GetStackInt__FP12RS_STACKDATA__2(arg++);
    int param2 = GetStackInt__FP12RS_STACKDATA__2(arg++);
    int param3 = GetStackInt__FP12RS_STACKDATA__2(arg);
    memory->Align64();
    if (memory->stAlloc64(EventDngMap.LoadDngInfo(
            memory, texBase + fileIndex, param1, param2, param3)) == 0) {
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
    EventDngMap.SetKomaMove(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
int _DNGMAP_ONOFF(RS_STACKDATA *stack, int argc) {
    EventDngMap.active = (u8)(GetStackInt__FP12RS_STACKDATA__2(stack) != 0);
    return 1;
}
int _DNGMAP_SET_FADE(RS_STACKDATA *stack, int argc) {
    int fadeIn = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int duration = GetStackInt__FP12RS_STACKDATA__2(stack);
    EventDngMap.active = 1;
    if (fadeIn != 0) {
        EventDngMap.FadeIn(duration);
    } else {
        EventDngMap.FadeOut(duration);
    }
    return 1;
}
int _GET_BEFORE_CAMERA_NEXT_POS(RS_STACKDATA *stack, int argc) {
    float position[4];
    mgCCamera *camera = EventScene->GetCamera(EventScene->before_camera);
    if (camera == NULL) {
        return 0;
    }
    camera->GetNextPos( position);
    SetStack__FP12RS_STACKDATAf__2(stack++, position[0]);
    SetStack__FP12RS_STACKDATAf__2(stack++, position[1]);
    SetStack__FP12RS_STACKDATAf__2(stack, position[2]);
    return 1;
}
int _GET_BEFORE_CAMERA_NEXT_REF(RS_STACKDATA *stack, int argc) {
    float position[4];
    mgCCamera *camera = EventScene->GetCamera(EventScene->before_camera);
    if (camera == NULL) {
        return 0;
    }
    camera->GetNextRef( position);
    SetStack__FP12RS_STACKDATAf__2(stack++, position[0]);
    SetStack__FP12RS_STACKDATAf__2(stack++, position[1]);
    SetStack__FP12RS_STACKDATAf__2(stack, position[2]);
    return 1;
}
extern "C" int _SET_CAMERA_NEXT_POS__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    float position[4];
    mgCCameraFollow *camera;
    if ((camera = (mgCCameraFollow *)GetActiveCamera()) == NULL) {
        return 0;
    }
    switch (argc) {
        case 1: {
            int key = GetStackInt__FP12RS_STACKDATA__2(stack);
            int count;
            int i;
            ARG_LIST *node;
            ARG_DATA *args;

            node = EventScriptArg.list;
            if (node == NULL) {
                args = NULL;
                goto haveArgs;
            }
            count = EventScriptArg.list_num;
            i = 0;
            goto test;
        body:
            if (key == node->id) {
                goto done;
            }
            node = node->next;
            if (node != NULL) {
                i++;
                goto test;
            }
            args = NULL;
            goto haveArgs;
        test:
            if (i < count) {
                goto body;
            }
        done:
            if (node == NULL) {
                args = NULL;
                goto haveArgs;
            }
            args = node->args;
        haveArgs:
            if (args == NULL) {
                return 0;
            }
            GetArgVector(position, args);
            break;
        }
        case 3:
            GetStackVector__FPfP12RS_STACKDATA(position, stack);
            break;
        default:
            return 0;
    }
    camera->SetNextPos( position);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _CHK_INTERSECTION_POINT__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _CHK_INTERSECTION_POINT_PIPE__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_FCAMERA_FOLLOW__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_FCAMERA_FOLLOW_A__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_FCAMERA_FOLLOW_OFS__FP12RS_STACKDATAi);
int _SET_FCAMERA_FOLLOW_FLAG(RS_STACKDATA *stack, int argc) {
    mgCCameraFollow *camera = (mgCCameraFollow *)EventScene->GetCamera(EventScene->active_camera);
    if (camera == NULL) {
        return 0;
    }
    if (GetStackInt__FP12RS_STACKDATA__2(stack) == 1) {
        camera->FollowOn();
    } else {
        camera->FollowOff();
    }
    return 1;
}
int _FCAMERA_STEP(RS_STACKDATA *stack, int argc) {
    mgCCameraFollow *camera = (mgCCameraFollow *)EventScene->GetCamera(EventScene->active_camera);
    if (camera == NULL) {
        return 0;
    }
    camera->Step(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_FCAMERA_ANGLE__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_FCAMERA_HEIGHT__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_FCAMERA_DIST__FP12RS_STACKDATAi);
extern "C" int _GET_REF_ANGLE__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    float from[4];
    float direction[4];
    float yaw;
    float pitch;
    float *directionZ;
    GetStackVector__FPfP12RS_STACKDATA(from, stack);
    GetStackVector__FPfP12RS_STACKDATA(direction, stack + 3);
    stack += 6;
    sceVu0SubVector(direction, direction, from);
    sceVu0Normalize(direction, direction);
    directionZ = &direction[2];
    yaw = atan2f(direction[0], *directionZ);
    pitch = -atan2f(direction[1], sqrtf(direction[0] * direction[0] + *directionZ * *directionZ));
    switch (argc) {
        case 7:
            SetStack__FP12RS_STACKDATAf__2(stack, yaw);
            break;
        case 9:
            SetStack__FP12RS_STACKDATAf__2(stack++, pitch);
            SetStack__FP12RS_STACKDATAf__2(stack++, yaw);
            SetStack__FP12RS_STACKDATAf__2(stack, 0.0f);
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
    dungeon->stage_id = GetStackInt__FP12RS_STACKDATA__2(stack);
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
    SetStack__FP12RS_STACKDATAi__2(stack, dungeon->stage_id);
    return 1;
}
int _SET_CAMERA_CTRL(RS_STACKDATA *stack, int argc) {
    mgCCameraFollow *camera = (mgCCameraFollow *)EventScene->GetCamera(EventScene->active_camera);
    if (camera == NULL) {
        return 0;
    }
    if (GetStackInt__FP12RS_STACKDATA__2(stack) != 0) {
        camera->FollowOn();
        ((CCameraControl *)camera)->ControlOn();
    } else {
        camera->FollowOff();
        ((CCameraControl *)camera)->ControlOff();
    }
    return 1;
}
int _GET_FCAMERA_ANGLE(RS_STACKDATA *stack, int argc) {
    mgCCameraFollow *camera = (mgCCameraFollow *)EventScene->GetCamera(EventScene->active_camera);
    if (camera == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAf__2(stack, camera->GetAngle());
    return 1;
}
int _GET_FCAMERA_HEIGHT(RS_STACKDATA *stack, int argc) {
    mgCCameraFollow *camera = (mgCCameraFollow *)EventScene->GetCamera(EventScene->active_camera);
    if (camera == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAf__2(stack, camera->GetHeight());
    return 1;
}
int _GET_FCAMERA_DIST(RS_STACKDATA *stack, int argc) {
    mgCCameraFollow *camera = (mgCCameraFollow *)EventScene->GetCamera(EventScene->active_camera);
    if (camera == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAf__2(stack, camera->GetDistance());
    return 1;
}
int _GET_INVENTION_ID(RS_STACKDATA *stack, int argc) {
    CSaveData *save = GetSaveData();
    if (save == NULL) {
        return 0;
    }
    u8 *userData = (u8 *)&save->user_data;
    CInventUserData *inventData = (CInventUserData *)(userData + invent_user_data_offset);
    if (userData == NULL) {
        return 0;
    }
    if (inventData == NULL) {
        return 0;
    }
    int inventionId = GetStackInt__FP12RS_STACKDATA__2(stack++);

    argc = inventData->IsAlreadyCreatedItem(inventionId);
    SetStack__FP12RS_STACKDATAi__2(stack, argc);
    return 1;
}
int _FUNCTION_MAP_JUMP(RS_STACKDATA *stack, int argc) {

    u32 *request = &EventScene->map_jump_flags;
    if (!(*request & 0x10A)) {
        return 0;
    }
    EdEventInfo.jump_point = -1;
    EdEventInfo.event_no = 100;
    if (strcmp((char *)(request + 6), at_4072) == 0) {
        EdEventInfo.request = exit_leave_interior;
    } else {
        strcpy(EdEventInfo.jump_map_name, (char *)(request + 6));
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
    CUserDataManager *userData = &save->user_data;
    if (userData == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(stack, userData->money);
    return 1;
}
int _ADD_MONEY(RS_STACKDATA *stack, int argc) {
    CSaveData *save = GetSaveData();
    if (save == NULL) {
        return 0;
    }
    CUserDataManager *userData = &save->user_data;
    if (userData == NULL) {
        return 0;
    }
    userData->AddMoney(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
int _GET_ITEM_NUM(RS_STACKDATA *stack, int argc) {
    CSaveData *save = GetSaveData();
    if (save == NULL) {
        return 0;
    }
    CUserDataManager *userData = &save->user_data;
    if (userData == NULL) {
        return 0;
    }
    int itemNo = GetStackInt__FP12RS_STACKDATA__2(stack++);

    argc = userData->GetNumSameItem(itemNo);
    SetStack__FP12RS_STACKDATAi__2(stack, argc);
    return 1;
}
int _CHECK_BUTTON(RS_STACKDATA *stack, int argc) {
    int button = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int pressed = 0;
    int padDown = GamePad__2.GetPadDown();
    switch (button) {
        case 0:
            if (LanguageCode == 0) {
                if (padDown & 0x40) {
                    pressed = 1;
                }
            } else if (padDown & 0x20) {
                pressed = 1;
            }
            break;
        case 1:
            if (LanguageCode == 0) {
                if (padDown & 0x20) {
                    pressed = 1;
                }
            } else if (padDown & 0x40) {
                pressed = 1;
            }
            break;
        case 2:
            if (padDown & 0x80) {
                pressed = 1;
            }
            break;
        case 3:
            if (padDown & 0x100) {
                pressed = 1;
            }
            break;
        default:
            return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(stack, pressed);
    return 1;
}
int _GET_LANGUAGE(RS_STACKDATA *stack, int argc) {
    SetStack__FP12RS_STACKDATAi__2(stack, LanguageCode);
    return 1;
}
extern "C" int _CHECK_INVENT_ITEM__FP12RS_STACKDATAi(RS_STACKDATA *arg0, int arg1) {
    int value = CheckInventItem__Fi(GetStackInt__FP12RS_STACKDATA__2(arg0++));
    SetStack__FP12RS_STACKDATAi__2(arg0, value);
    return 1;
}
int _SET_AI(RS_STACKDATA *stack, int argc) {
    int enabled = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int chara_no = GetStackInt__FP12RS_STACKDATA__2(stack);
    if (enabled != 0) {
        EventScene->CancelStayVillager(chara_no);
    } else {
        EventScene->StayVillager(chara_no);
    }
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _CHECK_INVENT_PHOTO__FP12RS_STACKDATAi);
int _GET_PHOTO_NUM(RS_STACKDATA *stack, int argc) {
    CSaveData *save = GetSaveData();
    if (save == NULL) {
        return 0;
    }
    CUserDataManager *user_data = &save->user_data;
    CInventUserData *invent_data = &user_data->invent_data;
    if (user_data == NULL) {
        return 0;
    }
    if (invent_data == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(stack, invent_data->GetNowHavePictureNum());
    return 1;
}
int _SET_CONTENTS_ETC(RS_STACKDATA *stack, int argc) {
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_STATUS__FP12RS_STACKDATAi__2);
int _GOTO_SUBGAME(RS_STACKDATA *stack, int argc) {
    int type = GetStackInt__FP12RS_STACKDATA__2(stack);
    SubGameInfo info;
    info.scene = EventScene;
    info.texb = EventScene->unk_3e68;
    info.texb_num = EventScene->unk_3e6c;
    return sgInitSubGame(type, &info) != 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_GYORACE_ETC__FP12RS_STACKDATAi);
int _GET_GYORACE_ETC(RS_STACKDATA *stack, int argc) {
    FISH_PRIZE_INFO info;
    int raceNo;

    switch (GetStackInt__FP12RS_STACKDATA__2(stack++)) {
        case 0:
            SetStack__FP12RS_STACKDATAi__2(stack++, GetGyoRaceAquariumNo());
            break;
        case 1:
            SetStack__FP12RS_STACKDATAi__2(stack++, GetGyoRaceRanking());
            break;
        case 2:
            SetStack__FP12RS_STACKDATAi__2(stack++, GetGyoRaceClass());
            break;
        case 3:
            SetStack__FP12RS_STACKDATAi__2(stack++, GetGyoRaceNo());
            break;
        case 4:
            raceNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
            if (!GetFishPrize(raceNo, GetStackInt__FP12RS_STACKDATA__2(stack++) - 1, &info)) {
                return 0;
            }
            SetStack__FP12RS_STACKDATAi__2(stack++, info.unk_0);
            SetStack__FP12RS_STACKDATAi__2(stack++, info.unk_4);
            break;
        case 5: {
            CSaveData *save = GetSaveData();
            if (save == NULL) {
                return 0;
            }
            SetStack__FP12RS_STACKDATAi__2(stack++, save->GetTourCountEtc());
            break;
        }
        default:
            return 0;
    }
    return 1;
}
int _SET_SAVEDATA_ETC(RS_STACKDATA *stack, int argc) {
    CSaveData *save;
    CUserDataManager *user;
    MOS_CHANGE_PARAM *bajji;

    switch (GetStackInt__FP12RS_STACKDATA__2(stack++)) {
        case 0:
            save = GetSaveData();
            if (save == NULL) {
                return 0;
            }
            save->game_progress = GetStackInt__FP12RS_STACKDATA__2(stack);
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
            bajji = user->GetMonsterBajjiDataPtrMosId(GetStackInt__FP12RS_STACKDATA__2(stack));
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
            save->unk_643C9 = GetStackInt__FP12RS_STACKDATA__2(stack);
            break;
        case 4:
            DeleteErekiFish();
            break;
        default:
            return 0;
    }
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_SAVEDATA_ETC__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _DEL_MONSTER__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_MENU_ETC__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_MENU_ETC__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_ANALYZE__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_DIORAMA_PERCENT__FP12RS_STACKDATAi);
void _GEORAMA_FUNC(RS_STACKDATA *stack, int argc) {
    GeoFuncParam param;

    param.scene = (CScene *)EventScene;
    GeoramaFunc(&param, stack, argc);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_CHARA_ID__FP12RS_STACKDATAi);
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
    SetStack__FP12RS_STACKDATAi__2(stack, GetNowChapter(save));
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_NPC_TRAIN_ETC__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _REGISTER_VILLAGER__FP12RS_STACKDATAi);
int _EYE_VIEW_DRAW_ON_OFF(RS_STACKDATA *stack, int argc) {
    ((CScene *)EventScene)->EyeViewDrawOnOff(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_QUEST_ETC__FP12RS_STACKDATAi);
int _GET_QUEST_ETC(RS_STACKDATA *stack, int argc) {
    int command = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int quest_no = GetStackInt__FP12RS_STACKDATA__2(stack++);
    switch (command) {
        case 0:
            SetStack__FP12RS_STACKDATAi__2(stack, GetQuestRequestStatus(quest_no));
            break;
        default:
            return 0;
    }
    return 1;
}
int _GET_OLD_INTERIOR_MAP_NO(RS_STACKDATA *stack, int argc) {
    SetStack__FP12RS_STACKDATAi__2(stack, GetOldInteriorMapNo());
    return 1;
}
int _SET_EVENT_DATA(RS_STACKDATA *stack, int argc) {
    CSceneEventData *eventData;
    RS_STACKDATA *value;

    eventData = &EventScene->event_data;
    if (eventData == NULL) {
        return 0;
    }
    value = stack + 1;
    switch (GetStackInt__FP12RS_STACKDATA__2(stack)) {
        case 0:
            eventData->event.flag = GetStackInt__FP12RS_STACKDATA__2(value);
            break;
        case 1:
            eventData->event.event_no = GetStackInt__FP12RS_STACKDATA__2(value);
            break;
        case 2:
            eventData->event.point_no = GetStackInt__FP12RS_STACKDATA__2(value);
            break;
        case 3:
            eventData->event.unk_2c = GetStackInt__FP12RS_STACKDATA__2(value);
            break;
        case 4:
            eventData->event.unk_30 = GetStackInt__FP12RS_STACKDATA__2(value);
            break;
        case 5:
            eventData->event.unk_34 = GetStackInt__FP12RS_STACKDATA__2(value);
            break;
        case 6:
            eventData->map_event.check_type = GetStackInt__FP12RS_STACKDATA__2(value);
            break;
        case 7:
            eventData->map_event.event_no = GetStackInt__FP12RS_STACKDATA__2(value);
            break;
        case 13:
            eventData->chara_slot = GetStackInt__FP12RS_STACKDATA__2(value);
            break;
        case 14:
            eventData->chara_no = GetStackInt__FP12RS_STACKDATA__2(value);
            break;
        default:
            return 0;
    }
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _STOPWATCH__FP12RS_STACKDATAi);
int _SET_FUNC_ETC(RS_STACKDATA *stack, int argc) {
    u32 *flags;

    flags = &EventScene->map_jump_flags;
    if (flags == NULL) {
        return 0;
    }
    if (flags == NULL) {
        return 0;
    }
    switch (GetStackInt__FP12RS_STACKDATA__2(stack)) {
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
CCharacter2 *GetChara(int id) {
    return GetCharacter(id);
}
int _GET_CHARA_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];
    RS_STACKDATA *out;
    CCharacter2 *chara;

    out = stack + 1;
    chara = GetChara(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (chara == NULL) {
        return 0;
    }
    chara->GetPosition(pos);
    SetStack__FP12RS_STACKDATAf__2(out++, pos[0]);
    SetStack__FP12RS_STACKDATAf__2(out++, pos[1]);
    SetStack__FP12RS_STACKDATAf__2(out++, pos[2]);
    return 1;
}
int _GET_CHARA_TALK_POS(RS_STACKDATA *stack, int argc) {
    int screenPos[2];
    RS_STACKDATA *out;
    CCharacter2 *chara;

    out = stack + 1;
    chara = GetChara(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (chara == NULL) {
        return 0;
    }
    GetScrPosFromChar(chara, screenPos);
    SetStack__FP12RS_STACKDATAi__2(out++, screenPos[0]);
    SetStack__FP12RS_STACKDATAi__2(out, screenPos[1]);
    return 1;
}
int _TURN_CHARA(RS_STACKDATA *stack, int argc) {
    CCharacter2 *chara;
    float target[4];
    float pos[4];
    float rot[4];
    float diff[4];
    float rate;
    float angle;
    float *yaw;

    chara = GetChara(GetStackInt__FP12RS_STACKDATA__2(stack++));
    if (chara == NULL) {
        return 0;
    }
    target[0] = GetStackFloat__FP12RS_STACKDATA__2(stack++);
    target[1] = GetStackFloat__FP12RS_STACKDATA__2(stack++);
    target[2] = GetStackFloat__FP12RS_STACKDATA__2(stack++);
    rate = GetStackFloat__FP12RS_STACKDATA__2(stack);
    chara->GetPosition(pos);
    chara->GetRotation(rot);
    sceVu0SubVector(diff, target, pos);
    angle = atan2f(diff[0], diff[2]);
    yaw = &rot[1];
    *yaw = mgAngleInterpolate(*yaw, angle, rate, 0);
    chara->SetRotation(rot);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_CHARA_POS__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_CHARA_ROT__FP12RS_STACKDATAi);
int _GET_CHARA_ROT(RS_STACKDATA *stack, int argc) {
    float pos[4];
    RS_STACKDATA *out;
    CCharacter2 *chara;

    out = stack + 1;
    chara = GetChara(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (chara == NULL) {
        return 0;
    }
    chara->GetRotation(pos);
    SetStack__FP12RS_STACKDATAf__2(out++, pos[0]);
    SetStack__FP12RS_STACKDATAf__2(out++, pos[1]);
    SetStack__FP12RS_STACKDATAf__2(out++, pos[2]);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_MOTION__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_STEP__FP12RS_STACKDATAi);
int _SET_TEX_ANIM(RS_STACKDATA *stack, int argc) {
    int charaId;
    int enable;
    char *name;
    int texBank;
    mgCTextureManager *manager;

    charaId = GetStackInt__FP12RS_STACKDATA__2(stack++);
    enable = GetStackInt__FP12RS_STACKDATA__2(stack++);
    name = NULL;
    if (argc > 2) {
        name = GetStackString__FP12RS_STACKDATA__2(stack);
    }
    texBank = EventScene->GetCharaTexb(charaId);
    if (texBank < 0) {
        return 0;
    }
    manager = &mgTexManager;
    if (enable != 0) {
        manager->TexAnimeOn(texBank, name);
    } else if (name != NULL) {
        manager->TexAnimeOff(texBank, name);
    } else {
        manager->TexAnimeAllOff(texBank);
    }
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_SCALE__FP12RS_STACKDATAi__2);
int _SET_REFERENCE(RS_STACKDATA *stack, int argc) {
    int charaId;
    char *frameName;
    int referenceId;
    CCharacter2 *chara;
    CCharacter2 *referenceChara;
    mgCFrame *frame;
    mgCFrame *child;

    charaId = GetStackInt__FP12RS_STACKDATA__2(stack++);
    frameName = GetStackString__FP12RS_STACKDATA__2(stack++);
    referenceId = GetStackInt__FP12RS_STACKDATA__2(stack);
    chara = GetChara(charaId);
    if (chara == NULL) {
        return 0;
    }
    referenceChara = GetChara(referenceId);
    if (referenceChara == NULL) {
        return 0;
    }
    frame = chara->CObjectFrame::frame;
    if (frame == NULL) {
        return 0;
    }
    child = frame->SearchFrame(frameName);
    if (child == NULL) {
        return 0;
    }
    frame = referenceChara->CObjectFrame::frame;
    if (frame == NULL) {
        return 0;
    }
    frame->SetReference(child);
    return 1;
}
int _DEL_REFERENCE(RS_STACKDATA *stack, int argc) {
    mgCFrame *frame;
    CCharacter2 *chara;

    chara = GetChara(GetStackInt__FP12RS_STACKDATA__2(stack));
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
    int charaId;
    CCharacter2 *chara;
    int clipOff;

    clipOff = 1;
    charaId = GetStackInt__FP12RS_STACKDATA__2(stack++);
    if (argc > 0) {
        clipOff = GetStackInt__FP12RS_STACKDATA__2(stack);
    }
    chara = GetChara(charaId);
    if (chara == NULL) {
        return 0;
    }
    if (chara->shadow_frame == NULL) {
        return 0;
    }
    mgCFrameAttr attr;
    attr.no_cull = clipOff;
    chara->shadow_frame->SetAttrParam(attr, 1, 0x100000);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_COORDINATE_ANGLE__FP12RS_STACKDATAi);
int _GET_CHARA_WIDTH(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *nextSlot;
    CCharacter2 *chara;

    nextSlot = stack + 1;
    chara = GetChara(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (chara == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAf__2(nextSlot, chara->body_width);
    return 1;
}
int _GET_CHARA_HEIGHT(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *nextSlot;
    CCharacter2 *chara;

    nextSlot = stack + 1;
    chara = GetChara(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (chara == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAf__2(nextSlot, chara->body_height);
    return 1;
}
int _GET_CHARA_WEIGHT(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *nextSlot;
    CCharacter2 *chara;

    nextSlot = stack + 1;
    chara = GetChara(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (chara == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAf__2(nextSlot, chara->body_depth);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_CHARA_SHOW__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_CHARA_SHOW__FP12RS_STACKDATAi);
int _CHARA_DA_ENABLE(RS_STACKDATA *stack, int argc) {
    CCharacter2 *chara;
    RS_STACKDATA *nextSlot;

    nextSlot = stack + 1;
    if ((chara = GetChara(GetStackInt__FP12RS_STACKDATA__2(stack))) == NULL) {
        return 0;
    }
    chara->SetDAnimeEnable(GetStackInt__FP12RS_STACKDATA__2(nextSlot));
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_MOT_NOW_WAIT__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _CHECK_MOTION_END__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _ACTCHR_SET_MOTION__FP12RS_STACKDATAi);
int _SET_CHARA_EX_SOUNDID(RS_STACKDATA *stack, int argc) {
    CActionChara *chara;
    RS_STACKDATA *nextSlot;

    nextSlot = stack + 1;
    chara = (CActionChara *)GetChara(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (chara == NULL) {
        return 0;
    }
    chara->se_bank_2 = GetStackInt__FP12RS_STACKDATA__2(nextSlot);
    return 1;
}
int _ACTCHR_SOUND_INFO_COPY(RS_STACKDATA *stack, int argc) {
    CActionChara *chara;

    chara = (CActionChara *)GetCharacter(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (chara == NULL) {
        return 0;
    }

    if (chara == NULL) {
        return 0;
    }
    chara->SetSoundInfoCopy();
    return 1;
}
ClsMes *GetMes(int id) {
    return GetEventMessage(id);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _MES_MAKE__FP12RS_STACKDATAi);
int _MES_CLOSE(RS_STACKDATA *stack, int argc) {
    ClsMes *mes;

    mes = GetMes(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (mes == NULL) {
        return 0;
    }
    mes->draw_speed = mes->GetDrawSpeedDef();
    mes->mes_no = -1;
    mes->unk_1e40 = 0;
    mes->open = 0;
    mes->fade = 0;
    mes->fukidashi_centre_x = -1;
    mes->fukidashi_centre_y = -1;
    return 1;
}
int _MES_NEXTPAGE(RS_STACKDATA *stack, int argc) {
    ClsMes *mes;

    mes = GetMes(GetStackInt__FP12RS_STACKDATA__2(stack));
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
    int values[4];
    int charaValues[4];
    RS_STACKDATA *args;
    ClsMes *mes;
    CCharacter2 *chara1;
    CCharacter2 *chara2;
    int i;

    args = stack + 1;
    mes = GetMes(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (mes == NULL) {
        return 0;
    }
    if (argc != 3) {
        if (argc != 5) {
            return 0;
        }
        for (i = 0; i < 4; i++) {
            values[i] = GetStackInt__FP12RS_STACKDATA__2(args++);
        }
        mes->AutoSet(values);
    } else {
        chara1 = GetChara(GetStackInt__FP12RS_STACKDATA__2(args++));
        if (chara1 == NULL) {
            return 0;
        }
        chara2 = GetChara(GetStackInt__FP12RS_STACKDATA__2(args));
        if (chara2 == NULL) {
            return 0;
        }
        mes->AutoSetSub(chara1, chara2, charaValues);
        mes->AutoSet(charaValues);
    }
    return 1;
}
int _SET_MES_SHIPPO(RS_STACKDATA *stack, int argc) {
    ClsMes *mes;

    mes = GetMes(GetStackInt__FP12RS_STACKDATA__2(stack++));
    if (mes == NULL) {
        return 0;
    }
    mes->tail_on = GetStackInt__FP12RS_STACKDATA__2(stack++);
    if (argc > 2) {
        mes->tail_length = GetStackInt__FP12RS_STACKDATA__2(stack++);
    }
    if (argc > 3) {
        mes->tail_half_w = GetStackInt__FP12RS_STACKDATA__2(stack);
    }
    return 1;
}
int _SET_MES_POS(RS_STACKDATA *stack, int argc) {
    ClsMes *mes;
    RS_STACKDATA *nextSlot;

    nextSlot = stack + 1;
    mes = GetMes(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (mes == NULL) {
        return 0;
    }
    mes->fukidashi_pos = GetStackInt__FP12RS_STACKDATA__2(nextSlot);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_MES_DRAWSPEED__FP12RS_STACKDATAi);
int _SET_MES_CURSOR(RS_STACKDATA *stack, int argc) {
    int cursor;
    ClsMes *mes;
    RS_STACKDATA *nextSlot;

    nextSlot = stack + 1;
    mes = GetMes(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (mes == NULL) {
        return 0;
    }
    cursor = (int)(GetStackInt__FP12RS_STACKDATA__2(nextSlot));
    if (mes->select < 0) {
        mes->cursor_time = 0;
    }
    mes->select = cursor;
    return 1;
}
int _SET_MES_OKURI(RS_STACKDATA *stack, int argc) {
    ClsMes *mes;
    RS_STACKDATA *nextSlot;

    nextSlot = stack + 1;
    mes = GetMes(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (mes == NULL) {
        return 0;
    }
    mes->push_button = GetStackInt__FP12RS_STACKDATA__2(nextSlot);
    return 1;
}
int _SET_MES_WIN_FLAG(RS_STACKDATA *stack, int argc) {
    ClsMes *mes;
    RS_STACKDATA *nextSlot;

    nextSlot = stack + 1;
    mes = GetMes(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (mes == NULL) {
        return 0;
    }
    if (GetStackInt__FP12RS_STACKDATA__2(nextSlot) != 0) {
        mes->window_mode = 1;
    } else {
        mes->window_mode = 0;
    }
    return 1;
}
int _CHECK_MES_COMPLETE(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *nextSlot;
    ClsMes *mes;

    nextSlot = stack + 1;
    mes = GetMes(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (mes == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(nextSlot, mes->State() == 3);
    return 1;
}
int _CHECK_MES_WAIT(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *nextSlot;
    ClsMes *mes;

    nextSlot = stack + 1;
    mes = GetMes(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (mes == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(nextSlot, mes->State() == 5);
    return 1;
}
int _CHECK_MES(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *nextSlot;
    ClsMes *mes;

    nextSlot = stack + 1;
    mes = GetMes(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (mes == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(nextSlot, mes->State() == 0);
    return 1;
}
int _SET_MES_FUKIDASHI(RS_STACKDATA *stack, int argc) {
    ClsMes *mes;
    RS_STACKDATA *nextSlot;

    nextSlot = stack + 1;
    mes = GetMes(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (mes == NULL) {
        return 0;
    }
    GetStackInt__FP12RS_STACKDATA__2(nextSlot);
    mes->SetWindowMode(1);
    return 1;
}
int _SET_MES_WINDOW_MODE(RS_STACKDATA *stack, int argc) {
    ClsMes *mes;
    RS_STACKDATA *nextSlot;

    nextSlot = stack + 1;
    mes = GetMes(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (mes == NULL) {
        return 0;
    }
    mes->SetWindowMode(GetStackInt__FP12RS_STACKDATA__2(nextSlot));
    return 1;
}
int _SET_MES_PRESET(RS_STACKDATA *stack, int argc) {
    ClsMes *mes;
    RS_STACKDATA *nextSlot;

    nextSlot = stack + 1;
    mes = GetMes(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (mes == NULL) {
        return 0;
    }
    mes->Preset(GetStackInt__FP12RS_STACKDATA__2(nextSlot));
    return 1;
}
int _SET_MES_ITEM_DIRECT(RS_STACKDATA *stack, int argc) {
    ClsMes *mes;
    RS_STACKDATA *args;
    int slot;
    int value;

    args = stack + 1;
    mes = GetMes(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (mes == NULL) {
        return 0;
    }
    slot = GetStackInt__FP12RS_STACKDATA__2(args++);
    value = GetStackInt__FP12RS_STACKDATA__2(args);
    if (slot - 1 >= 0 && slot - 1 < 0x10) {
        mes->item_mes[slot - 1] = value;
    }
    return 1;
}
int _SET_MES_ITEM(RS_STACKDATA *stack, int argc) {
    ClsMes *mes;
    RS_STACKDATA *args;
    int slot;
    int value;

    args = stack + 1;
    mes = GetMes(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (mes == NULL) {
        return 0;
    }
    slot = GetStackInt__FP12RS_STACKDATA__2(args++);
    value = GetItemMessageNo(GetStackInt__FP12RS_STACKDATA__2(args), 1);
    if (slot - 1 >= 0 && slot - 1 < 0x10) {
        mes->item_mes[slot - 1] = value;
    }
    return 1;
}
int _SET_MES_VALUE(RS_STACKDATA *stack, int argc) {
    ClsMes *mes;
    RS_STACKDATA *args;
    int slot;
    int value;

    args = stack + 1;
    mes = GetMes(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (mes == NULL) {
        return 0;
    }
    slot = GetStackInt__FP12RS_STACKDATA__2(args++);
    value = GetStackInt__FP12RS_STACKDATA__2(args);
    if (slot == 0) {
        mes->value = value;
    } else {
        mes->values[slot - 1] = value;
        mes->value_width[slot - 1] = 0;
    }
    return 1;
}
int _GET_MES_STATUS(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *nextSlot;
    ClsMes *mes;

    nextSlot = stack + 1;
    mes = GetMes(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (mes == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(nextSlot, mes->State());
    return 1;
}
int _GET_PARTY_CHARA_MES_NO(RS_STACKDATA *stack, int argc) {
    int npcId;
    int kind;
    RS_STACKDATA *out;

    out = stack + 1;
    npcId = GetStackInt__FP12RS_STACKDATA__2(stack);
    kind = GetStackInt__FP12RS_STACKDATA__2(out++);
    SetStack__FP12RS_STACKDATAi__2(out++, GetPartyCharaMessage(npcId, kind, 1));
    if (kind == 4) {
        SetStack__FP12RS_STACKDATAi__2(out, (s8)GetPartyNPCData(npcId)->unk_31 + 3);
    }
    return 1;
}
int _MES_SET_BUFF(RS_STACKDATA *stack, int argc) {
    ClsMes *mes;
    int kind;
    RS_STACKDATA *args;

    args = stack + 1;
    mes = GetMes(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (mes == NULL) {
        return 0;
    }
    kind = (int)(GetStackInt__FP12RS_STACKDATA__2(args++));
    GetStackInt__FP12RS_STACKDATA__2(args);
    if (kind == 0) {
        mes->SetBuff(GetSysMesBuffer());
    } else {
        mes->SetBuff_system(GetSystemMesBuffer());
    }
    return 1;
}
int _GET_MES_WINDOW_MODE(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *nextSlot;
    ClsMes *mes;

    nextSlot = stack + 1;
    mes = GetMes(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (mes == NULL) {
        return 0;
    }

    argc = mes->GetWindowMode();
    SetStack__FP12RS_STACKDATAi__2(nextSlot, argc);
    return 1;
}
int _GET_MES_VOICE(RS_STACKDATA *stack, int argc) {
    SetStack__FP12RS_STACKDATAi__2(stack, EdEventInfo.stream_playing);
    return 1;
}
int _SET_MES_QUESTION_GYOU(RS_STACKDATA *stack, int argc) {
    ClsMes *mes;
    RS_STACKDATA *nextSlot;

    nextSlot = stack + 1;
    mes = GetMes(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (mes == NULL) {
        return 0;
    }
    mes->select_top = GetStackInt__FP12RS_STACKDATA__2(nextSlot);
    return 1;
}
int _GET_MES_QUESTION_GYOU(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *nextSlot;
    ClsMes *mes;

    nextSlot = stack + 1;

    mes = GetMes(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (mes == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(nextSlot, mes->select_top);
    return 1;
}
int _SET_MES_CLOSE_CNT(RS_STACKDATA *stack, int argc) {
    ClsMes *mes;
    RS_STACKDATA *nextSlot;

    nextSlot = stack + 1;
    mes = GetMes(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (mes == NULL) {
        return 0;
    }
    mes->close_time = GetStackInt__FP12RS_STACKDATA__2(nextSlot);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_MES_ETC__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_MES_ETC__FP12RS_STACKDATAi);
int _LOAD_MES_sub(char *fileName, int stackNo, ClsMes *mes) {
    int size;
    u32 *src;
    mgCMemory *mem;
    char *dst;
    int t;

    if (fileName == NULL) {
        return 0;
    }
    if (mes == NULL) {
        return 0;
    }
    src = GetLoadBGBuff(fileName, &size);
    if (src == 0) {
        return 0;
    }
    mem = (mgCMemory *)EventScene->GetStack(stackNo);
    mem->Align64();
    dst = (char *)mem->stAllocTest(size / 16 + 1);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _LOAD_MES__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _LOAD_MES_MONS_TALK__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _MES_SE_PLAY__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_MES_STR__FP12RS_STACKDATAi);
int _GET_MES_OKURI(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    ClsMes *mes = GetMes(GetStackInt__FP12RS_STACKDATA__2(stack++));
    if (mes == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(stack, mes->push_button);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_FISHINGTOURNAMENT_ETC__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_CHARA_FAR_DIST__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_MODEL_LIGHT_SWITCH__FP12RS_STACKDATAi__2);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_MODEL_LIGHT_COLOR__FP12RS_STACKDATAi__2);
int _GET_OMAKE_FLAG(RS_STACKDATA *stack, int argc) {
    SetStack__FP12RS_STACKDATAi__2(stack, OmakeFlag);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_WIND__FP12RS_STACKDATAi);
int _SET_OMAKE_FLAG(RS_STACKDATA *stack, int argc) {
    OmakeFlag = GetStackInt__FP12RS_STACKDATA__2(stack);
    return 1;
}
CCameraControl *GetCamera(void) {
    return (CCameraControl *)GetActiveCamera();
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_CAMERA_POS__FP12RS_STACKDATAi);
int _GET_CAMERA_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];
    if (argc < 3) {
        return 0;
    }
    mgCCamera *camera = GetCamera();
    if (camera == NULL) {
        return 0;
    }
    camera->GetPos( pos);
    SetStack__FP12RS_STACKDATAf__2(stack++, pos[0]);
    SetStack__FP12RS_STACKDATAf__2(stack++, pos[1]);
    SetStack__FP12RS_STACKDATAf__2(stack, pos[2]);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_CAMERA_REF__FP12RS_STACKDATAi);
int _GET_CAMERA_REF(RS_STACKDATA *stack, int argc) {
    float pos[4];
    if (argc < 3) {
        return 0;
    }
    mgCCamera *camera = GetCamera();
    if (camera == NULL) {
        return 0;
    }
    camera->GetRef( pos);
    SetStack__FP12RS_STACKDATAf__2(stack++, pos[0]);
    SetStack__FP12RS_STACKDATAf__2(stack++, pos[1]);
    SetStack__FP12RS_STACKDATAf__2(stack, pos[2]);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_CAMERA_SPEED__FP12RS_STACKDATAi__2);
int _CAMERA_STEP(RS_STACKDATA *stack, int argc) {
    mgCCameraFollow *camera = (mgCCameraFollow *)GetCamera();
    if (camera == NULL) {
        return 0;
    }
    camera->Step(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
int _GET_BEFORE_CAMERA_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];
    mgCCamera *camera = EventScene->GetCamera(EventScene->before_camera);
    if (camera == NULL) {
        return 0;
    }
    camera->GetPos( pos);
    SetStack__FP12RS_STACKDATAf__2(stack++, pos[0]);
    SetStack__FP12RS_STACKDATAf__2(stack++, pos[1]);
    SetStack__FP12RS_STACKDATAf__2(stack, pos[2]);
    return 1;
}
int _GET_BEFORE_CAMERA_REF(RS_STACKDATA *stack, int argc) {
    float pos[4];
    mgCCamera *camera = EventScene->GetCamera(EventScene->before_camera);
    if (camera == NULL) {
        return 0;
    }
    camera->GetRef( pos);
    SetStack__FP12RS_STACKDATAf__2(stack++, pos[0]);
    SetStack__FP12RS_STACKDATAf__2(stack++, pos[1]);
    SetStack__FP12RS_STACKDATAf__2(stack, pos[2]);
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
void _IMG_SET_DRAW(RS_STACKDATA *stack, int argc) {
    int draw;

    draw = GetStackInt__FP12RS_STACKDATA__2(stack++);
    esMother.SetDraw(GetStackInt__FP12RS_STACKDATA__2(stack), draw);
}
void _IMG_SET_GET(RS_STACKDATA *stack, int argc) {
    int index = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int a = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int b = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int c = GetStackInt__FP12RS_STACKDATA__2(stack++);
    esMother.SetGet(index, a, b, c, GetStackInt__FP12RS_STACKDATA__2(stack));
}
void _IMG_SET_PUT(RS_STACKDATA *stack, int argc) {
    int index = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int a = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int b = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int c = GetStackInt__FP12RS_STACKDATA__2(stack++);
    esMother.SetPut(index, a, b, c, GetStackInt__FP12RS_STACKDATA__2(stack));
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _IMG_SET_NAME__FP12RS_STACKDATAi);
void _IMG_SET_MOVE(RS_STACKDATA *stack, int argc) {
    int index = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int x = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int y = GetStackInt__FP12RS_STACKDATA__2(stack++);
    esMother.SetMove(index, x, y, GetStackInt__FP12RS_STACKDATA__2(stack));
}
void _IMG_SET_FADE(RS_STACKDATA *stack, int argc) {
    int index = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int from = GetStackInt__FP12RS_STACKDATA__2(stack++);
    esMother.SetFade(index, from, GetStackInt__FP12RS_STACKDATA__2(stack));
}
void _IMG_SET_COLOR(RS_STACKDATA *stack, int argc) {
    int index = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int r = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int g = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int b = GetStackInt__FP12RS_STACKDATA__2(stack++);
    esMother.SetColor(index, r, g, b, GetStackInt__FP12RS_STACKDATA__2(stack));
}
CEventSprite2 *GetEventSprite(int index) {
    if (index < 0 || index >= event_sprite2_num)
        return 0;
    return &EventSprite2[index];
}
int _SPRITE_INIT(RS_STACKDATA *stack, int argc) {
    CEventSprite2 *sprite;

    sprite = GetEventSprite(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (sprite == NULL) {
        return 0;
    }
    sprite->Initialize();
    return 1;
}
int _SPRITE_SET_DRAW(RS_STACKDATA *stack, int argc) {
    int index = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int value = GetStackInt__FP12RS_STACKDATA__2(stack);
    CEventSprite2 *sprite = GetEventSprite__Fi(index, value);
    if (sprite == NULL) {
        return 0;
    }
    SetDrawFlag__13CEventSprite2Fi(sprite);
    return 1;
}
int _SPRITE_SET_TYPE(RS_STACKDATA *stack, int argc) {
    int index = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int value = GetStackInt__FP12RS_STACKDATA__2(stack);
    CEventSprite2 *sprite = GetEventSprite__Fi(index, value);
    if (sprite == NULL) {
        return 0;
    }
    SetSpriteType__13CEventSprite2Fi(sprite);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SPRITE_SET_TEXTURE__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SPRITE_SET_POS__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SPRITE_SET_PUTSIZE__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SPRITE_SET_UVSIZE__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SPRITE_SET_COLOR__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SPRITE_SET_SCALE__FP12RS_STACKDATAi);
int _SPRITE_SET_ALPHAB(RS_STACKDATA *stack, int argc) {
    int index = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int value = GetStackInt__FP12RS_STACKDATA__2(stack);
    CEventSprite2 *sprite = GetEventSprite__Fi(index, value);
    if (sprite == NULL) {
        return 0;
    }
    SetAlphaBlend__13CEventSprite2Fi(sprite);
    return 1;
}
int _CMRS_CHECK(RS_STACKDATA *stack, int argc) {
    SetStack__FP12RS_STACKDATAi__2(stack, (u8)((CameraSeq.CheckEnd() != 0) ^ 1));
    return 1;
}
int _CMRS_INIT(RS_STACKDATA *stack, int argc) {
    CameraSeq.Clear();
    return 1;
}
int _CMRS_PRDELAY(RS_STACKDATA *stack, int argc) {
    CameraSeq.PRDelay(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _CMRS_SET_POS__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _CMRS_SET_REF__FP12RS_STACKDATAi);
int _CMRS_AHDDELAY(RS_STACKDATA *stack, int argc) {
    CameraSeq.AHDDelay(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
int _CMRS_SET_ANGLE(RS_STACKDATA *stack, int argc) {
    CameraSeq.SetAngle(GetStackFloat__FP12RS_STACKDATA__2(stack));
    return 1;
}
int _CMRS_SET_HEIGHT(RS_STACKDATA *stack, int argc) {
    CameraSeq.SetHeight(GetStackFloat__FP12RS_STACKDATA__2(stack));
    return 1;
}
int _CMRS_SET_DIST(RS_STACKDATA *stack, int argc) {
    CameraSeq.SetDist(GetStackFloat__FP12RS_STACKDATA__2(stack));
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _CMRS_SET_AHD__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _CMRS_MOVE__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _CMRS_MOVE2__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _CMRS_MOVE_REF__FP12RS_STACKDATAi);
int _CMRS_INIT_PAS(RS_STACKDATA *stack, int argc) {
    CameraSeq.InitPas();
    return 1;
}
int _CMRS_SET_PAS_FRM(RS_STACKDATA *stack, int argc) {
    CameraSeq.SetPasFrm(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _CMRS_ADD_PAS__FP12RS_STACKDATAi);
int _CMRS_START_PAS(RS_STACKDATA *stack, int argc) {
    CameraSeq.StartPas();
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _CMRS_PR_SLOWING__FP12RS_STACKDATAi);
int _CMRS_PR_KEEP(RS_STACKDATA *stack, int argc) {
    CameraSeq.PRKeep();
    return 1;
}
int _CMRS_PR_RETURN(RS_STACKDATA *stack, int argc) {
    CameraSeq.PRReturn();
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _CMRS_MOVE_AHD__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _CMRS_SYNC_OBJ__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _CMRS_MOVE_AHD2__FP12RS_STACKDATAi);
int _CMRS_RELEASE_OBJ(RS_STACKDATA *stack, int argc) {
    CameraSeq.ReleaseSyncObj();
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _CMRS_AHD_SLOWING__FP12RS_STACKDATAi);
int _CMRS_AHD_KEEP(RS_STACKDATA *stack, int argc) {
    CameraSeq.AHDKeep();
    return 1;
}
int _CMRS_AHD_RETURN(RS_STACKDATA *stack, int argc) {
    CameraSeq.AHDReturn();
    return 1;
}
int _CMRS_FADE_DELAY(RS_STACKDATA *stack, int argc) {
    CameraSeq.FadeDelay(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
int _CMRS_FADE_INIT(RS_STACKDATA *stack, int argc) {
    CameraSeq.FadeInit();
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _CMRS_FADE_IN__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _CMRS_FADE_OUT__FP12RS_STACKDATAi);
int _CMRS_QUAKE_DELAY(RS_STACKDATA *stack, int argc) {
    CameraSeq.QuakeDelay(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _CMRS_QUAKE__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _CMRS_QUAKE2__FP12RS_STACKDATAi);
int _CMRS_CHARA_DELAY(RS_STACKDATA *stack, int argc) {
    CameraSeq.CharaDelay(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
int _CMRS_CHARA_ATTACH(RS_STACKDATA *stack, int argc) {
    int kind;
    float factor;

    kind = GetStackInt__FP12RS_STACKDATA__2(stack++);
    factor = GetStackFloat__FP12RS_STACKDATA__2(stack++);
    CameraSeq.CharaAttach(kind, factor, GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _CMRS_MOVE_POS__FP12RS_STACKDATAi);
int _OBJS_CHECK(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq(GetStackInt__FP12RS_STACKDATA__2(stack++));
    if (seq == NULL) {
        return 0;
    }

    SetStack__FP12RS_STACKDATAi__2(stack, (u8)((seq->CheckEnd() != 0) ^ 1));
    return 1;
}
int _OBJS_INIT(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (seq == NULL) {
        return 0;
    }
    seq->Clear();
    return 1;
}
int _OBJS_SYNC_OBJ(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq__Fi(GetStackInt__FP12RS_STACKDATA__2(stack++), GetStackInt__FP12RS_STACKDATA__2(stack));
    if (seq == NULL) {
        return 0;
    }
    SetEohNo__12CSceneObjSeqFi(seq);
    return 1;
}
int _OBJS_POS_DELAY(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq__Fi(GetStackInt__FP12RS_STACKDATA__2(stack++), GetStackInt__FP12RS_STACKDATA__2(stack));
    if (seq == NULL) {
        return 0;
    }
    PosDelay__12CSceneObjSeqFi(seq);
    return 1;
}
int _OBJS_SET_POS(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;
    float pos[4];
    int slot;
    int key;
    int count;
    int i;
    ARG_LIST *node;
    ARG_DATA *args;

    switch (argc) {
        case 1:

            key = GetStackInt__FP12RS_STACKDATA__2(stack);
            node = EventScriptArg.list;
            if (node == NULL) {
                args = NULL;
                goto haveArgs;
            }
            count = EventScriptArg.list_num;
            i = 0;
            goto test;
        body:
            if (key == node->id) {
                goto done;
            }
            node = node->next;
            if (node != NULL) {
                i++;
                goto test;
            }
            args = NULL;
            goto haveArgs;
        test:
            if (i < count) {
                goto body;
            }
        done:
            if (node == NULL) {
                args = NULL;
                goto haveArgs;
            }
            args = node->args;
        haveArgs:
            if (args == NULL) {
                return 0;
            }
            slot = GetArgInt(args++);
            GetArgVector(pos, args);
            break;
        case 4:
            slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
            GetStackVector__FPfP12RS_STACKDATA(pos, stack);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _OBJS_MOVE__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _OBJS_MOVE2__FP12RS_STACKDATAi);
int _OBJS_INIT_PAS(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (seq == NULL) {
        return 0;
    }
    seq->InitPas();
    return 1;
}
int _OBJS_SET_PAS_FRM(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq__Fi(GetStackInt__FP12RS_STACKDATA__2(stack++), GetStackInt__FP12RS_STACKDATA__2(stack));
    if (seq == NULL) {
        return 0;
    }
    SetPasFrm__12CSceneObjSeqFi(seq);
    return 1;
}
int _OBJS_ADD_PAS(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;
    float pos[4];
    int slot;
    int key;
    int count;
    int i;
    ARG_LIST *node;
    ARG_DATA *args;

    switch (argc) {
        case 1:

            key = GetStackInt__FP12RS_STACKDATA__2(stack);
            node = EventScriptArg.list;
            if (node == NULL) {
                args = NULL;
                goto haveArgs;
            }
            count = EventScriptArg.list_num;
            i = 0;
            goto test;
        body:
            if (key == node->id) {
                goto done;
            }
            node = node->next;
            if (node != NULL) {
                i++;
                goto test;
            }
            args = NULL;
            goto haveArgs;
        test:
            if (i < count) {
                goto body;
            }
        done:
            if (node == NULL) {
                args = NULL;
                goto haveArgs;
            }
            args = node->args;
        haveArgs:
            if (args == NULL) {
                return 0;
            }
            slot = GetArgInt(args++);
            GetArgVector(pos, args);
            break;
        case 4:
            slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
            GetStackVector__FPfP12RS_STACKDATA(pos, stack);
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
    int seqNo;
    int frame;

    frame = 0;
    seqNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    if (argc >= 2) {
        frame = GetStackInt__FP12RS_STACKDATA__2(stack);
    }
    seq = GetObjSeq(seqNo);
    if (seq == NULL) {
        return 0;
    }
    seq->StartPas(frame);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _OBJS_JUMP__FP12RS_STACKDATAi);
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
            slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
            eohNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
            frameName = GetStackString__FP12RS_STACKDATA__2(stack);
            break;
        case 4:
            slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
            eohNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
            frameName = GetStackString__FP12RS_STACKDATA__2(stack++);
            frames = GetStackInt__FP12RS_STACKDATA__2(stack);
            break;
        case 6:
            slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
            eohNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
            frameName = GetStackString__FP12RS_STACKDATA__2(stack++);
            GetStackVector__FPfP12RS_STACKDATA(offset, stack);
            break;
        case 7:
            slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
            eohNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
            frameName = GetStackString__FP12RS_STACKDATA__2(stack++);
            GetStackVector__FPfP12RS_STACKDATA(offset, stack);

            stack = (RS_STACKDATA *)((u8 *)stack + vector_bytes);
            frames = GetStackInt__FP12RS_STACKDATA__2(stack);
            break;
    }
    seq = GetObjSeq(slot);
    if (seq == NULL) {
        return 0;
    }
    seq->SetEohFramePos(eohNo, frameName, frames, offset);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _OBJS_ADD_POS__FP12RS_STACKDATAi);
int _OBJS_ATTACH_CAMERA(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;
    int slot;
    float rate;

    slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
    rate = GetStackFloat__FP12RS_STACKDATA__2(stack++);
    seq = GetObjSeq__Fi(slot, GetStackInt__FP12RS_STACKDATA__2(stack));
    if (seq == NULL) {
        return 0;
    }
    AttachCamera__12CSceneObjSeqFfi(seq, rate);
    return 1;
}
int _OBJS_ROT_DELAY(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq__Fi(GetStackInt__FP12RS_STACKDATA__2(stack++), GetStackInt__FP12RS_STACKDATA__2(stack));
    if (seq == NULL) {
        return 0;
    }
    RotDelay__12CSceneObjSeqFi(seq);
    return 1;
}
int _OBJS_SET_ROT(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;
    float rot[4];
    int slot;
    int key;
    int count;
    int i;
    ARG_LIST *node;
    ARG_DATA *args;

    switch (argc) {
        case 1:

            key = GetStackInt__FP12RS_STACKDATA__2(stack);
            node = EventScriptArg.list;
            if (node == NULL) {
                args = NULL;
                goto haveArgs;
            }
            count = EventScriptArg.list_num;
            i = 0;
            goto test;
        body:
            if (key == node->id) {
                goto done;
            }
            node = node->next;
            if (node != NULL) {
                i++;
                goto test;
            }
            args = NULL;
            goto haveArgs;
        test:
            if (i < count) {
                goto body;
            }
        done:
            if (node == NULL) {
                args = NULL;
                goto haveArgs;
            }
            args = node->args;
        haveArgs:
            if (args == NULL) {
                return 0;
            }
            slot = GetArgInt(args++);
            GetArgVector(rot, args);
            break;
        case 4:
            slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
            GetStackVector__FPfP12RS_STACKDATA(rot, stack);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _OBJS_ROTATION__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _OBJS_ROTATION2__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _OBJS_REFERENCE__FP12RS_STACKDATAi);
int _OBJS_MOTION_DELAY(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq__Fi(GetStackInt__FP12RS_STACKDATA__2(stack++), GetStackInt__FP12RS_STACKDATA__2(stack));
    if (seq == NULL) {
        return 0;
    }
    MotionDelay__12CSceneObjSeqFi(seq);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _OBJS_SET_MOTION__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _OBJS_NEXT_MOTION__FP12RS_STACKDATAi);
int _OBJS_MOTION_WAIT(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (seq == NULL) {
        return 0;
    }
    seq->MotionWait();
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _OBJS_SET_STEP__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _OBJS_CHENGE_STEP__FP12RS_STACKDATAi);
int _OBJS_SEQ_MOT_TRG(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (seq == NULL) {
        return 0;
    }
    seq->SetMotionTrg();
    return 1;
}
int _OBJS_SEQ_MOT_TRG_WAIT(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (seq == NULL) {
        return 0;
    }
    seq->MotionTrgWait();
    return 1;
}
int _OBJS_RESET_MOTION(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (seq == NULL) {
        return 0;
    }
    seq->ResetMotion();
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _OBJS_SET_MOTION_NOW_TIME__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _OBJS_SET_MOTION_WAIT_TIME__FP12RS_STACKDATAi);
int _OBJS_TEXA_DELAY(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq__Fi(GetStackInt__FP12RS_STACKDATA__2(stack++), GetStackInt__FP12RS_STACKDATA__2(stack));
    if (seq == NULL) {
        return 0;
    }
    TexAnimeDelay__12CSceneObjSeqFi(seq);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _OBJS_TEX_ANIME__FP12RS_STACKDATAi);
int _OBJS_COLOR_DELAY(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq__Fi(GetStackInt__FP12RS_STACKDATA__2(stack++), GetStackInt__FP12RS_STACKDATA__2(stack));
    if (seq == NULL) {
        return 0;
    }
    ColorDelay__12CSceneObjSeqFi(seq);
    return 1;
}
int _OBJS_SET_COLOR(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;
    float color[4];
    int slot;
    int frames;

    frames = 0;
    slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
    color[0] = GetStackFloat__FP12RS_STACKDATA__2(stack++);
    color[1] = GetStackFloat__FP12RS_STACKDATA__2(stack++);
    color[2] = GetStackFloat__FP12RS_STACKDATA__2(stack++);
    color[3] = GetStackFloat__FP12RS_STACKDATA__2(stack++);
    if (argc >= 6) {
        frames = GetStackInt__FP12RS_STACKDATA__2(stack);
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

    seq = GetObjSeq__Fi(GetStackInt__FP12RS_STACKDATA__2(stack++), GetStackInt__FP12RS_STACKDATA__2(stack));
    if (seq == NULL) {
        return 0;
    }
    ScaleDelay__12CSceneObjSeqFi(seq);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _OBJS_SET_SCALE__FP12RS_STACKDATAi);
int _OBJS_SE_DELAY(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq__Fi(GetStackInt__FP12RS_STACKDATA__2(stack++), GetStackInt__FP12RS_STACKDATA__2(stack));
    if (seq == NULL) {
        return 0;
    }
    SeDelay__12CSceneObjSeqFi(seq);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _OBJS_SE_PLAY__FP12RS_STACKDATAi);
int _OBJS_RESET_DA_POSITION(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (seq == NULL) {
        return 0;
    }
    seq->ResetDAPosition();
    return 1;
}
int _OBJS_NORMAL_DRIVE(RS_STACKDATA *stack, int argc) {
    CSceneObjSeq *seq;

    seq = GetObjSeq(GetStackInt__FP12RS_STACKDATA__2(stack));
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
    sndInitPort(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SND_LOAD_SOUND__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_SND_ID__FP12RS_STACKDATAi);
int _SND_SE_PAUSE(RS_STACKDATA *stack, int argc) {
    u32 seId;

    seId = GetStackInt__FP12RS_STACKDATA__2(stack++);
    sndSePause(seId, GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
int _SND_SE_PLAY(RS_STACKDATA *stack, int argc) {
    switch (argc) {
        case 2: {
            u32 seId = GetStackInt__FP12RS_STACKDATA__2(stack++);
            int voice = GetStackInt__FP12RS_STACKDATA__2(stack);
            sndSePlay(seId, voice, 0);
            return 1;
        }
        case 3: {
            u32 seId = GetStackInt__FP12RS_STACKDATA__2(stack++);
            int voice = GetStackInt__FP12RS_STACKDATA__2(stack++);
            int volume = GetStackInt__FP12RS_STACKDATA__2(stack);
            sndSePlayV(seId, voice, volume, 0);
            return 1;
        }
        case 4: {
            u32 seId = GetStackInt__FP12RS_STACKDATA__2(stack++);
            int voice = GetStackInt__FP12RS_STACKDATA__2(stack++);
            int volume = GetStackInt__FP12RS_STACKDATA__2(stack++);
            int pan = GetStackInt__FP12RS_STACKDATA__2(stack);
            sndSePlayVP(seId, voice, volume, pan, 0);
            return 1;
        }
        default:
    return 0;
}
}
int _SND_SE_STOP(RS_STACKDATA *stack, int argc) {
    u32 seId;

    seId = GetStackInt__FP12RS_STACKDATA__2(stack++);
    sndSeStop(seId, GetStackInt__FP12RS_STACKDATA__2(stack), 0);
    return 1;
}
int _SND_SET_SE_VOL(RS_STACKDATA *stack, int argc) {
    u32 seId;
    int voice;

    seId = GetStackInt__FP12RS_STACKDATA__2(stack++);
    voice = GetStackInt__FP12RS_STACKDATA__2(stack++);
    switch (stack->type) {
        case 0:
            sndSetSeVol(seId, voice, GetStackInt__FP12RS_STACKDATA__2(stack), 0);
            break;
        case 1:
            sndSetSeVolf(seId, voice, GetStackFloat__FP12RS_STACKDATA__2(stack), 0);
            break;
        default:
    return 0;
}
    return 1;
}
int _SND_SET_SE_PAN(RS_STACKDATA *stack, int argc) {
    int seId = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int pan = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int time = GetStackInt__FP12RS_STACKDATA__2(stack);
    sndSetSePan(seId, pan, time, 0);
    return 1;
}
int _SND_SET_SE_PITCH(RS_STACKDATA *stack, int argc) {
    int seId = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int pitch = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int time = GetStackInt__FP12RS_STACKDATA__2(stack);
    sndSetSePitch(seId, pitch, time, 0);
    return 1;
}
int _SND_SE_ALL_STOP(RS_STACKDATA *stack, int argc) {
    sndSeAllStop(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
int _LOAD_BGM(RS_STACKDATA *stack, int argc) {
    int bgmNo;

    bgmNo = GetStackInt__FP12RS_STACKDATA__2(stack);
    if (EventScene->CheckLoadBGM(bgmNo) == 0) {
    return 0;
}
    return EventScene->LoadBGM(bgmNo, read_buffer);
}
int _PLAY_BGM(RS_STACKDATA *stack, int argc) {
    int bgmNo;

    switch (argc) {
        case 1:
            EventScene->PlayBGM(GetStackInt__FP12RS_STACKDATA__2(stack), -1, 1.0f);
            return 1;
        case 2:
            bgmNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
            EventScene->PlayBGM(bgmNo, GetStackInt__FP12RS_STACKDATA__2(stack), 1.0f);
            return 1;
    }
    return 0;
}
int _STOP_BGM(RS_STACKDATA *stack, int argc) {
    EventScene->StopBGM(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
int CommandStreamOpenFromFPL(int stream, char *name, char *base) {
    char path[64];
    char baseName[64];

    strcpy(path, at_6773__2);
    strncat(path, name, 3);
    strcat(path, (char *)&at_6774__2);
    strcat(path, name);
    strcat(path, (char *)&at_6775__2);
    strcpy(baseName, base);
    strcat(baseName, (char *)&at_6776__2);
    CSnd.StreamOpenFromFPLFast( stream, path, baseName);
    return 1;
}
int CommandStreamOpen(int stream, char *name) {
    char path[64];

    strcpy(path, (char *)at_6781__2);
    strcat(path, name);
    strcat(path, (char *)at_6782__2);
    CSnd.StreamOpenFast(stream, path);
    return 1;
}
int VpkFileNameFromVoiceNo(char *name, int voiceNo) {
    int group = voiceNo / 10000;
    int kind = 0;

    switch (group) {
        case 1:
            if (voiceNo >= 10705) {
                if (voiceNo < 10721) {
                    kind = 1;
                }
            }
            if (voiceNo >= 10300) {
                if (voiceNo < 10701) {
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

    VpkTable table = at_6800__2;
    for (int i = 0; i < vpk_entry_count; i++) {
        if (group == table.entry[i].group && kind == table.entry[i].kind) {
            sprintf(name, (char *)at_6816, table.entry[i].id, table.entry[i].sub);
            return 1;
        }
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _STREAM_OPEN__FP12RS_STACKDATAi);
int CommandStreamPlay(int stream, int volume) {
    int reverb = sndGetReverbDepth(1);
    int scaled = (int)((double)volume - 256.0 * (1.5 * (double)reverb));
    printf((char *)at_6839, scaled, volume);
    EdEventInfo.stream_volume = volume;
    CSnd.StreamSetVol(stream, scaled, scaled);
    CSnd.StreamPlay(stream);
    return 1;
}
int _STREAM_PLAY(RS_STACKDATA *stack, int argc) {
    EdEventInfo.stream_playing = 1;
    GetStackInt__FP12RS_STACKDATA__2(stack++);
    switch (argc) {
        case 1:
            return CommandStreamPlay(event_stream, stream_max_volume);
        case 2:
            return CommandStreamPlay(event_stream, GetStackInt__FP12RS_STACKDATA__2(stack));
    }
    return 0;
}
int _STREAM_STOP(RS_STACKDATA *stack, int argc) {
    EdEventInfo.stream_playing = 0;
    GetStackInt__FP12RS_STACKDATA__2(stack);
    if (EdEventInfo.stream_from_fpl == 1) {
        CSnd.StreamEND(event_stream);
    } else {
        CSnd.StreamSetVol(event_stream, EdEventInfo.stream_volume, EdEventInfo.stream_volume);
        CSnd.StreamClose(event_stream);
    }
    return 1;
}
int _STREAM_STANDBY(RS_STACKDATA *stack, int argc) {
    GetStackInt__FP12RS_STACKDATA__2(stack);
    CSnd.StreamStandBy(event_stream);
    return 1;
}
int _STREAM_GET_STATUS(RS_STACKDATA *stack, int argc) {
    GetStackInt__FP12RS_STACKDATA__2(stack++);

    argc = CSnd.StreamGetState(event_stream);
    SetStack__FP12RS_STACKDATAi__2(stack, argc);
    return 1;
}
int _GET_SYS_SND_ID(RS_STACKDATA *stack, int argc) {

    argc = GetSystemSndID();
    SetStack__FP12RS_STACKDATAi__2(stack, argc);
    return 1;
}
int _STREAM_OPEN_CHECK(RS_STACKDATA *stack, int argc) {
    SetStack__FP12RS_STACKDATAi__2(stack, CSnd.StreamOpenState());
    return 1;
}
int _LOAD_SE_ENV(RS_STACKDATA *stack, int argc) {
    int bankNo;

    bankNo = GetStackInt__FP12RS_STACKDATA__2(stack);
    if (EventScene->CheckLoadSeEnv(bankNo) == 0) {
        return 0;
    }
    EventScene->LoadSeEnv(bankNo, read_buffer);
    return 1;
}
int _PLAY_ENV_BGM(RS_STACKDATA *stack, int argc) {
    int voice;
    int volume;

    voice = GetStackInt__FP12RS_STACKDATA__2(stack++);
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

            volume = fptosi(GetStackFloat__FP12RS_STACKDATA__2(stack));
            EventScene->SetEnvBGMVol(volume);
            EventScene->PlayEnvBGM(voice, 1.0f);
            EdEventInfo.env_bgm_no = voice;
            EdEventInfo.env_bgm_volume = volume;
            return 1;
    }
    return 0;
}
int _SYS_SE_PLAY(RS_STACKDATA *stack, int argc) {
    int seId;

    seId = GetStackInt__FP12RS_STACKDATA__2(stack);
    if (seId < 0) {
        return 0;
    }
    sndSePlay(SystemSND_ID, seId, 0);
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
    int srcNo;

    srcNo = GetStackInt__FP12RS_STACKDATA__2(stack);
    if (EventScene->CheckLoadSeSrc(srcNo) == 0) {
        return 0;
    }
    return EventScene->LoadSeSrc(srcNo, read_buffer);
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
    int bankNo;

    bankNo = GetStackInt__FP12RS_STACKDATA__2(stack);
    if (EventScene->CheckLoadSeBattle(bankNo) == 0) {
        return 0;
    }
    return EventScene->LoadSeBattle(bankNo, read_buffer);
}
int _SND_DELETE_PORT(RS_STACKDATA *stack, int argc) {
    sndDeletePort(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
int _FADE_IN_BGM(RS_STACKDATA *stack, int argc) {
    int frames60;
    int frames;

    frames60 = GetStackInt__FP12RS_STACKDATA__2(stack);
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

    frames60 = GetStackInt__FP12RS_STACKDATA__2(stack);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_BGM_VOL__FP12RS_STACKDATAi);
int _SND_SET_REVERB(RS_STACKDATA *stack, int argc) {
    return 0;
}
int _SND_SET_ENV_VOL(RS_STACKDATA *stack, int argc) {
    EventScene->SetEnvBGMVol(GetStackFloat__FP12RS_STACKDATA__2(stack));
    return 1;
}
int _STREAM_SILENT_CHECK(RS_STACKDATA *stack, int argc) {
    int level;
    int loud;

    GetStackInt__FP12RS_STACKDATA__2(stack++);
    level = CSnd.StreamGetLevel( event_stream);
    loud = 1;

    if ((s16)(u16)level < 11 && (s16)(u16)level >= -10 && (s16)(level >> 16) < 11 &&
        (s16)(level >> 16) >= -10) {
        loud = 0;
    }
    SetStack__FP12RS_STACKDATAi__2(stack, loud);
    return 1;
}
int _AUTO_CHANGE_ENV(RS_STACKDATA *stack, int argc) {
    EventScene->AutoChangeEnvBGM(GetStackInt__FP12RS_STACKDATA__2(stack));
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
    int bankNo;

    bankNo = GetStackInt__FP12RS_STACKDATA__2(stack);
    if (EventScene->CheckLoadSeBase(bankNo) == 0) {
        return 0;
    }
    return EventScene->LoadSeBase(bankNo, read_buffer);
}
int _LOAD_SOUND(RS_STACKDATA *stack, int argc) {
    EventScene->LoadSound(GetStackInt__FP12RS_STACKDATA__2(stack), read_buffer);
    return 1;
}
int _STREAM_CLOSE(RS_STACKDATA *stack, int argc) {
    EdEventInfo.stream_playing = 0;
    GetStackInt__FP12RS_STACKDATA__2(stack);
    CSnd.StreamSetVol(event_stream, EdEventInfo.stream_volume, EdEventInfo.stream_volume);
    CSnd.StreamClose(event_stream);
    EdEventInfo.stream_reading = 0;
    return 1;
}
int CommandStreamOpen2(int stream, char *name) {
    char path[64];
    strcpy(path, (char *)at_6781__2);
    strcat(path, name);
    strcat(path, (char *)at_6782__2);
    return 1;
}
int _STREAM_OPEN2(RS_STACKDATA *stack, int argc) {
    int result;
    GetStackInt__FP12RS_STACKDATA__2(stack++);
    EdEventInfo.stream_from_fpl = 0;
    result = CommandStreamOpen2(event_stream, GetStackString__FP12RS_STACKDATA__2(stack));
    if (result == 1) {
        EdEventInfo.stream_reading = 1;
    }
    return result;
}
int _LOAD_BGM_PACK(RS_STACKDATA *stack, int argc) {
    char fileName[64];
    int bgmNo;
    u32 *pack;

    bgmNo = GetStackInt__FP12RS_STACKDATA__2(stack);
    if (EventScene->CheckLoadBGM(bgmNo) == 0) {
        return 0;
    }
    EventScene->GetBgmFile(fileName, bgmNo);
    pack = GetLoadBGBuff(fileName, NULL);
    if (pack != NULL) {
        return EventScene->LoadBGMPack(bgmNo, pack);
    }
    return 0;
}
int _GET_BGM_NO(RS_STACKDATA *stack, int argc) {
    SetStack__FP12RS_STACKDATAi__2(stack, EventScene->GetActiveBgmInfo()->load_no);
    return 1;
}
int _GET_MASTER_VOL(RS_STACKDATA *stack, int argc) {
    SetStack__FP12RS_STACKDATAf__2(stack, EventScene->GetActiveBgmInfo()->unk_c);
    return 1;
}
int _SET_MASTER_VOL(RS_STACKDATA *stack, int argc) {
    float volume;
    CScene *scene;

    volume = GetStackFloat__FP12RS_STACKDATA__2(stack);
    scene = EventScene;
    scene->GetActiveBgmInfo()->unk_c = volume;
    scene->SetVolfBGM(scene->GetActiveBgmInfo()->volf);
    return 1;
}
int _GET_BTL_BGM_VOL(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *battleBgm;

    battleBgm = &EventScene->battle_area;
    if (battleBgm == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAf__2(stack, battleBgm->battle_bgm_vol);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_BTL_BGM_VOL__FP12RS_STACKDATAi);
int _SND_IN_REVERB(RS_STACKDATA *stack, int argc) {
    CSnd.SndInReverb( GetStackInt__FP12RS_STACKDATA__2(stack) != 0);
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

    GetStackInt__FP12RS_STACKDATA__2(stack++);
    EdEventInfo.stream_from_fpl = 2;
    sprintf(name, at_7117, GetStackInt__FP12RS_STACKDATA__2(stack));
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
    return EventAbi::SetStack__FP12RS_STACKDATAi__2(stack, EdEventInfo.bgm_status.load_no);
}
int _GET_SE_STATUS(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }
    int seId = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int voice = GetStackInt__FP12RS_STACKDATA__2(stack++);

    argc = sndGetSeStatus(seId, voice);
    SetStack__FP12RS_STACKDATAi__2(stack, argc);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_DEF_BGM_NO__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_MOVIE_CC__FP12RS_STACKDATAi);
int _REGISTER_VILLAGER2(RS_STACKDATA *stack, int argc) {
    int villagerNo;
    int mode;
    mgCMemory *memory;

    villagerNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    mode = GetStackInt__FP12RS_STACKDATA__2(stack++);
    memory = (mgCMemory *)EventScene->GetStack(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (memory == NULL) {
        return 0;
    }
    EventScene->RegisterVillager(villagerNo, mode, memory);
    return 1;
}
int _SET_FISHINGTOURNAMENT_ETC(RS_STACKDATA *stack, int argc) {
    CFishingTournament *tournament;
    RS_STACKDATA *next = stack + 1;

    switch (GetStackInt__FP12RS_STACKDATA__2(stack)) {
        case 0:
            tournament = GetFishTournament();
            if (tournament == NULL) {
                return 0;
            }
            tournament->SetRank(GetStackInt__FP12RS_STACKDATA__2(next));
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
    int slot;
    int charaNo;

    slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
    charaNo = GetStackInt__FP12RS_STACKDATA__2(stack);
    chara = GetChara(charaNo);
    if (chara != NULL) {
        return EventObjHandleMother.Set(slot, 0, charaNo, chara);
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _EOH_SYNC_OBJ__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _EOH_SYNC_EDIT_OBJ__FP12RS_STACKDATAi);
int _EOH_SYNC_SPRITE(RS_STACKDATA *stack, int argc) {
    CEventSprite2 *sprite;
    int slot;

    slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
    sprite = GetEventSprite(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (sprite != NULL) {
        return EventObjHandleMother.Set(slot, 2, sprite);
    }
    return 0;
}
int _EOH_SET_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];
    int slot;
    int key;
    int count;
    int i;
    ARG_LIST *node;
    ARG_DATA *args;

    switch (argc) {
        case 1:

            key = GetStackInt__FP12RS_STACKDATA__2(stack);
            node = EventScriptArg.list;
            if (node == NULL) {
                args = NULL;
                goto haveArgs;
            }
            count = EventScriptArg.list_num;
            i = 0;
            goto test;
        body:
            if (key == node->id) {
                goto done;
            }
            node = node->next;
            if (node != NULL) {
                i++;
                goto test;
            }
            args = NULL;
            goto haveArgs;
        test:
            if (i < count) {
                goto body;
            }
        done:
            if (node == NULL) {
                args = NULL;
                goto haveArgs;
            }
            args = node->args;
        haveArgs:
            if (args == NULL) {
                return 0;
            }
            slot = GetArgInt(args++);
            GetArgVector(pos, args);
            break;
        case 4:
            slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
            GetStackVector__FPfP12RS_STACKDATA(pos, stack);
            break;
        default:
            return 0;
    }
    return EventObjHandleMother.SetPos(slot, pos[0], pos[1], pos[2]);
}
int _EOH_SET_ROT(RS_STACKDATA *stack, int argc) {
    float rot[4];
    int slot;
    int key;
    int count;
    int i;
    ARG_LIST *node;
    ARG_DATA *args;

    switch (argc) {
        case 1:

            key = GetStackInt__FP12RS_STACKDATA__2(stack);
            node = EventScriptArg.list;
            if (node == NULL) {
                args = NULL;
                goto haveArgs;
            }
            count = EventScriptArg.list_num;
            i = 0;
            goto test;
        body:
            if (key == node->id) {
                goto done;
            }
            node = node->next;
            if (node != NULL) {
                i++;
                goto test;
            }
            args = NULL;
            goto haveArgs;
        test:
            if (i < count) {
                goto body;
            }
        done:
            if (node == NULL) {
                args = NULL;
                goto haveArgs;
            }
            args = node->args;
        haveArgs:
            if (args == NULL) {
                return 0;
            }
            slot = GetArgInt(args++);
            GetArgVector(rot, args);
            break;
        case 4:
            slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
            GetStackVector__FPfP12RS_STACKDATA(rot, stack);
            break;
        default:
            return 0;
    }
    rot[0] = mgAngleLimit(rot[0]);
    rot[1] = mgAngleLimit(rot[1]);
    rot[2] = mgAngleLimit(rot[2]);
    return EventObjHandleMother.SetRot(slot, rot[0], rot[1], rot[2]);
}
void _EOH_GET_POS(RS_STACKDATA *stack, int argc) {
    float pos[3];

    if (EventObjHandleMother.GetPos(GetStackInt__FP12RS_STACKDATA__2(stack++), pos) != 0) {
        SetStack__FP12RS_STACKDATAf__2(stack++, pos[0]);
        SetStack__FP12RS_STACKDATAf__2(stack++, pos[1]);
        SetStack__FP12RS_STACKDATAf__2(stack, pos[2]);
    }
}
void _EOH_GET_ROT(RS_STACKDATA *stack, int argc) {
    float rot[3];

    if (EventObjHandleMother.GetRot(GetStackInt__FP12RS_STACKDATA__2(stack++), rot) != 0) {
        SetStack__FP12RS_STACKDATAf__2(stack++, rot[0]);
        SetStack__FP12RS_STACKDATAf__2(stack++, rot[1]);
        SetStack__FP12RS_STACKDATAf__2(stack, rot[2]);
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _EOH_SET_MOTION__FP12RS_STACKDATAi);
void _EOH_SET_STEP(RS_STACKDATA *stack, int argc) {
    argc = GetStackInt__FP12RS_STACKDATA__2(stack++);
    SetStep__10CEohMotherFif(&EventObjHandleMother, EventAbi::GetStackFloat__FP12RS_STACKDATA__2(stack, argc));
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _EOH_SET_TEX_ANIM__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _EOH_SET_SCALE__FP12RS_STACKDATAi);
void _EOH_SET_SHOW(RS_STACKDATA *stack, int argc) {
    int slot;

    slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
    EventObjHandleMother.SetShow(slot, GetStackInt__FP12RS_STACKDATA__2(stack));
}
void _EOH_GET_SHOW(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *nextSlot;

    nextSlot = stack + 1;

    int show;
    if (EventObjHandleMother.GetShow(GetStackInt__FP12RS_STACKDATA__2(stack), &show) != 0) {
        SetStack__FP12RS_STACKDATAi__2(nextSlot, show);
    }
}
void _EOH_SET_FRAME_SHOW(RS_STACKDATA *stack, int argc) {
    int slot;
    char *frameName;

    slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
    frameName = GetStackString__FP12RS_STACKDATA__2(stack++);
    EventObjHandleMother.SetFrameShow(slot, frameName, GetStackInt__FP12RS_STACKDATA__2(stack) != 0 ? 1 : 0);
}
void _EOH_SET_SHADOW(RS_STACKDATA *stack, int argc) {
    int slot;

    slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
    EventObjHandleMother.SetShadow(slot, GetStackInt__FP12RS_STACKDATA__2(stack));
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _EOH_SET_TRANSLATE__FP12RS_STACKDATAi);
void _EOH_SET_FOOT_SOUND_ID(RS_STACKDATA *stack, int argc) {
    int slot;

    slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
    EventObjHandleMother.SetFootSoundID(slot, GetStackInt__FP12RS_STACKDATA__2(stack));
}
void _EOH_SET_FRAME_STATUS(RS_STACKDATA *stack, int argc) {
    int slot;
    char *frameName;

    slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
    frameName = GetStackString__FP12RS_STACKDATA__2(stack++);
    EventObjHandleMother.SetFrameShow(slot, frameName, GetStackInt__FP12RS_STACKDATA__2(stack));
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _EOH_GET_FRAME_POS__FP12RS_STACKDATAi);
void _EOH_SET_SOUND_ID(RS_STACKDATA *stack, int argc) {
    int slot;

    slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
    EventObjHandleMother.SetSoundID(slot, GetStackInt__FP12RS_STACKDATA__2(stack));
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _EOH_GET_FRAME_STATUS__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _EOH_SYNC_CHROBJ__FP12RS_STACKDATAi);
void _EOH_SET_FADE_FLAG(RS_STACKDATA *stack, int argc) {
    int slot;

    slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
    EventObjHandleMother.SetFadeFlag(slot, GetStackInt__FP12RS_STACKDATA__2(stack));
}
void _EOH_RESET_DA_POSITION(RS_STACKDATA *stack, int argc) {
    EventObjHandleMother.ResetDAPosition(GetStackInt__FP12RS_STACKDATA__2(stack));
}
void _EOH_SET_SHADOW_FRAME_STATUS(RS_STACKDATA *stack, int argc) {
    int slot;
    char *frameName;

    slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
    frameName = GetStackString__FP12RS_STACKDATA__2(stack++);
    EventObjHandleMother.SetShadowFrameShow(slot, frameName, GetStackInt__FP12RS_STACKDATA__2(stack));
}
void _EOH_SYNC_GEOSTONE(RS_STACKDATA *stack, int argc) {
    EventObjHandleMother.Set(GetStackInt__FP12RS_STACKDATA__2(stack), 0, -1, (CCharacter2 *)&GeoStone);
}
int _EOH_SYNC_SEARCH_CHARA(RS_STACKDATA *stack, int argc) {
    int slot;
    char *name;
    CActionChara *player;

    slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
    GetStackInt__FP12RS_STACKDATA__2(stack++);
    name = GetStackString__FP12RS_STACKDATA__2(stack);
    player = (CActionChara *)GetCharacter(0);
    if (player == NULL) {
        return 0;
    }
    return EventObjHandleMother.Set(slot, 0, -1, (CCharacter2 *)player->SearchChara(name));
}
void _EOH_NORMAL_DRIVE(RS_STACKDATA *stack, int argc) {
    EventObjHandleMother.NormalDrive(GetStackInt__FP12RS_STACKDATA__2(stack));
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _EOH_SET_FRAME_ALPHA__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _EOH_SYNC_FUNCP__FP12RS_STACKDATAi);
void _EOH_SET_FOOT_SE_ID(RS_STACKDATA *stack, int argc) {
    int slot;

    slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
    EventObjHandleMother.SetFootSeId(slot, GetStackInt__FP12RS_STACKDATA__2(stack));
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _EOH_SYNC_DOOR_PARTS__FP12RS_STACKDATAi);
int _SPHIDA_INIT(RS_STACKDATA *stack, int argc) {
    InitSphida();
    return 1;
}
int _SPHIDA_SET_UP(RS_STACKDATA *stack, int argc) {
    CSphida *sphida;
    mgCMemory *memory;
    int param;
    int kind;
    RS_STACKDATA *ptr;
    int slot;

    ptr = stack;
    kind = 0;
    slot = GetStackInt__FP12RS_STACKDATA__2(ptr++);
    param = GetStackInt__FP12RS_STACKDATA__2(ptr++);
    if (argc >= 3) {
        kind = GetStackInt__FP12RS_STACKDATA__2(ptr++);
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
            Sphida->Omake_SetUp( GetStackInt__FP12RS_STACKDATA__2(ptr), param);
            break;
    }
    return 1;
}
int _SPHIDA_SET_PLAY_FLAG(RS_STACKDATA *stack, int argc) {
    int flag;

    flag = GetStackInt__FP12RS_STACKDATA__2(stack);
    if (Sphida == NULL) {
        return 0;
    }
    Sphida->play_flag = flag;
    return 1;
}
int _SPHIDA_SET_MINIMAP_FLAG(RS_STACKDATA *stack, int argc) {
    int flag;

    flag = GetStackInt__FP12RS_STACKDATA__2(stack);
    if (Sphida == NULL) {
        return 0;
    }
    Sphida->minimap_flag = flag;
    return 1;
}
int _SPHIDA_SET_MM_LINE_FLAG(RS_STACKDATA *stack, int argc) {
    int flag;

    flag = GetStackInt__FP12RS_STACKDATA__2(stack);
    if (Sphida == NULL) {
        return 0;
    }
    Sphida->mm_line_flag = flag;
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SPHIDA_SET_MM_LINE_POS__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SPHIDA_SET_PIN_POS__FP12RS_STACKDATAi);
int _SPHIDA_GET_PIN_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];
    if (Sphida == NULL) {
        return 0;
    }
    sceVu0CopyVector(pos, Sphida->pin_pos);
    SetStack__FP12RS_STACKDATAf__2(stack++, pos[0]);
    SetStack__FP12RS_STACKDATAf__2(stack++, pos[1]);
    SetStack__FP12RS_STACKDATAf__2(stack, pos[2]);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SPHIDA_SET_BALL_POS__FP12RS_STACKDATAi);
int _SPHIDA_GET_BALL_POS(RS_STACKDATA *stack, int argc) {
    float pos[4];
    if (Sphida == NULL) {
        return 0;
    }
    sceVu0CopyVector(pos, Sphida->ball_pos);
    SetStack__FP12RS_STACKDATAf__2(stack++, pos[0]);
    SetStack__FP12RS_STACKDATAf__2(stack++, pos[1]);
    SetStack__FP12RS_STACKDATAf__2(stack, pos[2]);
    return 1;
}
int _SPHIDA_SET_PIN_COL(RS_STACKDATA *stack, int argc) {
    int color;

    color = GetStackInt__FP12RS_STACKDATA__2(stack);
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
    SetStack__FP12RS_STACKDATAi__2(stack, Sphida->pin_col);
    return 1;
}
int _SPHIDA_SET_BALL_COL(RS_STACKDATA *stack, int argc) {
    int color;

    color = GetStackInt__FP12RS_STACKDATA__2(stack);
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
    SetStack__FP12RS_STACKDATAi__2(stack, Sphida->ball_col);
    return 1;
}
int _SPHIDA_SET_PAR_COUNT(RS_STACKDATA *stack, int argc) {
    int parCount;

    parCount = GetStackInt__FP12RS_STACKDATA__2(stack);
    if (Sphida == NULL) {
        return 0;
    }
    if (DebugFlag == 0) {
        Sphida->par_count = parCount;
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
    SetStack__FP12RS_STACKDATAi__2(stack, count);
    return 1;
}
int _SPHIDA_GET_MINI_LEVEL(RS_STACKDATA *stack, int argc) {
    if (Sphida == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(stack, Sphida->mini_level);
    return 1;
}
int _SPHIDA_GET_TEXB(RS_STACKDATA *stack, int argc) {
    if (Sphida == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(stack, Sphida->tex_bank);
    return 1;
}
int _SPHIDA_SET_STATUS_FLAG(RS_STACKDATA *stack, int argc) {
    int flag;

    flag = GetStackInt__FP12RS_STACKDATA__2(stack);
    if (Sphida == NULL) {
        return 0;
    }
    Sphida->status_flag = flag;
    return 1;
}
int _SPHIDA_RESET_POWGAGE(RS_STACKDATA *stack, int argc) {
    if (Sphida == 0)
        return 0;

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
    SetStack__FP12RS_STACKDATAf__2(stack, Sphida->pow_gage.power);
    return 1;
}
int _SPHIDA_GET_POWGAGE_CODE(RS_STACKDATA *stack, int argc) {
    if (Sphida == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(stack, Sphida->pow_gage.code);
    return 1;
}
int _SPHIDA_SET_POWGAGE_SAFE_LEVEL(RS_STACKDATA *stack, int argc) {
    int level;

    level = GetStackInt__FP12RS_STACKDATA__2(stack);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SPHIDA_GET_CULB_DEF__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SPHIDA_SET_SPIN_MARK_POS__FP12RS_STACKDATAi);
int _SPHIDA_SET_CULB_NO(RS_STACKDATA *stack, int argc) {
    int clubNo;

    clubNo = GetStackInt__FP12RS_STACKDATA__2(stack);
    if (Sphida == NULL) {
        return 0;
    }
    Sphida->club_no = clubNo;
    return 1;
}
int _SPHIDA_CALC_CARRY(RS_STACKDATA *stack, int argc) {
    float carry = GetStackFloat__FP12RS_STACKDATA__2(stack);
    if (Sphida == NULL) {
        return 0;
    }
    Sphida->carry = carry;
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SPHIDA_GET_PG_CURSOR_POS__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SPHIDA_SET_COL_MODEL__FP12RS_STACKDATAi);
int _SPHIDA_GET_PRIZE(RS_STACKDATA *stack, int argc) {
    int prize1;
    int prize2;
    CDngFloorManager *floorManager;
    RS_STACKDATA *nextSlot;
    DNG_BATTLE_AREA *dngScene;

    dngScene = &((CScene *)EventScene)->battle_area;
    floorManager = &dngScene->floor_manager;
    if (dngScene == 0) {
        return 0;
    }
    nextSlot = stack + 1;
    if (floorManager == NULL) {
        return 0;
    }
    floorManager->GetSphedaPrize(GetStackInt__FP12RS_STACKDATA__2(stack), &prize1, &prize2);
    SetStack__FP12RS_STACKDATAi__2(nextSlot++, prize1);
    SetStack__FP12RS_STACKDATAi__2(nextSlot, prize2);
    return 1;
}
int _SPHIDA_SET_LAST_CHALLENGE(RS_STACKDATA *stack, int argc) {
    if (Sphida == NULL) {
        return 0;
    }
    Sphida->last_challenge = GetStackInt__FP12RS_STACKDATA__2(stack);
    return 1;
}
int _SPHIDA_GET_LAST_CHALLENGE(RS_STACKDATA *stack, int argc) {
    if (Sphida == NULL || argc != 1) {
        return 0;
    }
    return EventAbi::SetStack__FP12RS_STACKDATAi__2(stack, Sphida->last_challenge);
}
int _SPHIDA_GET_OMAKE_MODE(RS_STACKDATA *stack, int argc) {
    if (Sphida == NULL || argc != 1) {
        return 0;
    }
    return EventAbi::SetStack__FP12RS_STACKDATAi__2(stack, Sphida->omake_mode);
}
int _SPHIDA_SET_NOW_HOLE(RS_STACKDATA *stack, int argc) {
    CSubGameData *subGame = (CSubGameData *)GetSubGameSaveData();
    if (subGame == NULL) {
        return 0;
    }
    CSphidaData *sphidaData;
    if ((sphidaData = (CSphidaData *)subGame->GetSphidaData()) == NULL) {
        return 0;
    }
    sphidaData->SetHorl(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
int _SPHIDA_GET_NOW_HOLE(RS_STACKDATA *stack, int argc) {
    CSphidaData *sphidaData;
    CSubGameData *subGame;

    if (argc != 1) {
        return 0;
    }
    subGame = GetSubGameSaveData();
    if (subGame == NULL) {
        return 0;
    }
    sphidaData = (CSphidaData *)subGame->GetSphidaData();
    if (sphidaData == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(stack, GetNowHorl__11CSphidaDataFv(sphidaData));
    return 1;
}
int _SPHIDA_SET_SCORE(RS_STACKDATA *stack, int argc) {
    CSubGameData *subGame = (CSubGameData *)GetSubGameSaveData();
    if (subGame == NULL) {
        return 0;
    }
    CSphidaData *sphidaData;
    if ((sphidaData = (CSphidaData *)subGame->GetSphidaData()) == NULL) {
        return 0;
    }
    int slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int score = GetStackInt__FP12RS_STACKDATA__2(stack);
    sphidaData->SetHorlScore(score, slot);
    return 1;
}
int _SPHIDA_GET_SCORE(RS_STACKDATA *stack, int argc) {
    if (argc != 2) {
        return 0;
    }
    CSubGameData *subGame = (CSubGameData *)GetSubGameSaveData();
    if (subGame == NULL) {
        return 0;
    }
    CSphidaData *sphidaData;
    if ((sphidaData = (CSphidaData *)subGame->GetSphidaData()) == NULL) {
        return 0;
    }
    int slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
    SetStack__FP12RS_STACKDATAi__2(stack, sphidaData->GetHorlScore(slot));
    return 1;
}
int _TEST(RS_STACKDATA *stack, int argc) {
    return 1;
}
void _MT_TEST(RS_STACKDATA *stack, int argc) {
    mt_test(stack, argc);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _ZERO_VECTOR__FP12RS_STACKDATAi);
extern "C" int _NORMAL_VECTOR__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    float vec[4];
    vec[0] = ((RS_STACKDATA *)stack[0].i)->f;
    vec[1] = ((RS_STACKDATA *)stack[1].i)->f;
    vec[2] = ((RS_STACKDATA *)stack[2].i)->f;
    vec[3] = 1.0f;
    sceVu0Normalize(vec, vec);
    SetStack__FP12RS_STACKDATAf__2(stack++, vec[0]);
    SetStack__FP12RS_STACKDATAf__2(stack++, vec[1]);
    SetStack__FP12RS_STACKDATAf__2(stack, vec[2]);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _COPY_VECTOR__FP12RS_STACKDATAi__2);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _ADD_VECTOR__FP12RS_STACKDATAi__2);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SUB_VECTOR__FP12RS_STACKDATAi__2);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SCALE_VECTOR__FP12RS_STACKDATAi__2);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _DIV_VECTOR__FP12RS_STACKDATAi__2);
extern "C" int _DIST_VECTOR__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    float vec[4];
    GetStackVector__FPfP12RS_STACKDATA(vec, stack);

    stack = (RS_STACKDATA *)((int)stack + 0x18);
    SetStack__FP12RS_STACKDATAf__2(stack, mgDistVector(vec));
    return 1;
}
extern "C" int _DIST_VECTOR2__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    float from[4];
    float to[4];
    GetStackVector__FPfP12RS_STACKDATA(from, stack);
    GetStackVector__FPfP12RS_STACKDATA(to, stack + 3);

    stack = (RS_STACKDATA *)((int)stack + 0x30);
    SetStack__FP12RS_STACKDATAf__2(stack, mgDistVector(from, to));
    return 1;
}
extern "C" int _SQRT__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    float value = GetStackFloat__FP12RS_STACKDATA__2(stack++);
    SetStack__FP12RS_STACKDATAf__2(stack, (float)sqrt(value));
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _ATAN2F__FP12RS_STACKDATAi__2);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _ANGLE_CMP__FP12RS_STACKDATAi__2);
extern "C" int _ANGLE_LIMIT__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    RS_STACKDATA *angle = (RS_STACKDATA *)stack->i;
    SetStack__FP12RS_STACKDATAf__2(stack, mgAngleLimit(angle->f));
    return 1;
}
extern "C" int _GET_RAND__FP12RS_STACKDATAi(RS_STACKDATA *stack, int argc) {
    int intRange;
    if (stack->type == 1) {
        float range = GetStackFloat__FP12RS_STACKDATA__2(stack++);
        SetStack__FP12RS_STACKDATAf__2(stack, range * (float)rand() / 2147483648.0f);
    } else {
        intRange = GetStackInt__FP12RS_STACKDATA__2(stack++);
        argc = (int)((float)intRange * (float)rand() / 2147483648.0f);
        SetStack__FP12RS_STACKDATAi__2(stack, argc);
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
    GetStackVector__FPfP12RS_STACKDATA(segmentStart, stack);
    GetStackVector__FPfP12RS_STACKDATA(segmentEnd, stack + 3);
    GetStackVector__FPfP12RS_STACKDATA(point, stack + 6);
    RS_STACKDATA *result = stack + 9;
    segmentLength = mgDistVector(segmentStart, segmentEnd);
    sceVu0SubVector(toPoint, point, segmentStart);
    sceVu0SubVector(direction, segmentEnd, segmentStart);
    sceVu0Normalize(direction, direction);
    projection = sceVu0InnerProduct(toPoint, direction);
    if (projection < 0.0f || projection > segmentLength) {
        SetStack__FP12RS_STACKDATAf__2(result, -1.0f);
        return 1;
    }
    sceVu0ScaleVector(direction, direction, projection);
    sceVu0AddVector(direction, segmentStart, direction);
    SetStack__FP12RS_STACKDATAf__2(result, mgDistVector(point, direction));
    return 1;
}
int _CREATE_SWORD_EFFECT(RS_STACKDATA *stack, int argc) {
    int stackNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int initParam1 = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int initParam2 = GetStackInt__FP12RS_STACKDATA__2(stack);
    mgCMemory *sceneStack;
    CSWordAfterImage *effect;
    sceneStack = (mgCMemory *)((CScene *)EventScene)->GetStack(stackNo);
    if (sceneStack == NULL) {
        return 0;
    }
    effect = new (sceneStack->Alloc((sizeof(CSWordAfterImage) + 15) / 16 + 2)) CSWordAfterImage;
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
    SwordEffect->Initialize( sceneStack, initParam1, initParam2);
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
    int aR = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int aG = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int aB = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int aA = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int bR = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int bG = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int bB = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int bA = GetStackInt__FP12RS_STACKDATA__2(stack);
    CSWordAfterImage *effect = SwordEffect;
    effect->edge_color[0] = aR;
    effect->edge_color[1] = aG;
    effect->edge_color[2] = aB;
    effect->edge_color[3] = aA;
    effect->back_color[0] = bR;
    effect->back_color[1] = bG;
    effect->back_color[2] = bB;
    effect->back_color[3] = bA;
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SWORD_EFFECT_ADD_POINT__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _ADD_CHARA_POS__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _ADD_CHARA_ROT__FP12RS_STACKDATAi);
int _POST_TREASURE_BOX(RS_STACKDATA *stack, int argc) {
    float position[3];
    CTreasureBoxManager *chestManager;
    float angle;
    int kind;
    int count;
    DNG_BATTLE_AREA *dngScene;

    count = 1;
    GetStackVector__FPfP12RS_STACKDATA(position, stack);
    stack += 3;
    angle = GetStackFloat__FP12RS_STACKDATA__2(stack++);
    kind = (int)(GetStackInt__FP12RS_STACKDATA__2(stack++));
    if (argc >= 6) {
        count = (int)(GetStackInt__FP12RS_STACKDATA__2(stack));
    }
    dngScene = &((CScene *)EventScene)->battle_area;
    if (dngScene == NULL) {
    return 0;
}
    chestManager = dngScene->treasure_box;
    if (chestManager == NULL) {
    return 0;
}
    chestManager->PutTreasureBox(-1, position, angle, 0x41, kind, count, -1, 0);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_PARTS_ORIGIN__FP12RS_STACKDATAi);
int _CTRLC_STEP(RS_STACKDATA *stack, int argc) {
    CCameraControl *p = (CCameraControl *)GetCamera();
    p->Step(1);
    return 1;
}
int _CTRLC_SET_ROTATE(RS_STACKDATA *stack, int argc) {
    float angle = GetStackFloat__FP12RS_STACKDATA__2(stack);
    GetCamera()->SetRotate(angle);
    return 1;
}
int _CTRLC_ROT_BACK(RS_STACKDATA *stack, int argc) {
    float angle = GetStackFloat__FP12RS_STACKDATA__2(stack);
    GetCamera()->RotBack(angle);
    return 1;
}
int _CTRLC_MOVE_CAMERA(RS_STACKDATA *stack, int argc) {
    float charaPos[4];
    CCPoly polys[256];
    mgVu0FBOX box;
    float cameraRef[4];
    CCharacter2 *chara;
    CCameraControl *camera;
    CMap *map;
    int polyCount;
    float distance;

    if ((chara = GetCharacter(GetStackInt__FP12RS_STACKDATA__2(stack))) == NULL) {
        return 0;
    }
    chara->GetRotation(charaPos);
    camera = GetCamera();
    distance = camera->GetDistance();
    map = (CMap *)((CScene *)EventScene)->GetMap(((CScene *)EventScene)->active_map);
    camera->GetRef(cameraRef);
    camera->SetCheckRef(cameraRef);
    box.max[0] = cameraRef[0] + 1.2f * distance;
    box.min[0] = cameraRef[0] - 1.2f * distance;
    box.max[1] = cameraRef[1] + 1.2f * distance;
    box.min[1] = cameraRef[1] - 1.2f * distance;
    box.max[2] = cameraRef[2] + 1.2f * distance;
    box.min[2] = cameraRef[2] - 1.2f * distance;
    box.max[3] = 1.0f;
    box.min[3] = 1.0f;
    polyCount = map->GetCameraPoly(polys, box, 0x100);
    if (polyCount < 0) {
        return 0;
    }
    if (polyCount > 0x100) {
        printf(at_8230, polyCount);
        return 0;
    }
    camera->MoveCamera(&PadCtrl, charaPos, polys, polyCount);
    return 1;
}
int _CTRLC_SET_ROT_CANCEL(RS_STACKDATA *stack, int argc) {
    int mask;

    mask = (int)(GetStackInt__FP12RS_STACKDATA__2(stack));
    GetCamera()->SetRotCameraCancel(mask);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _CTRLC_MOVE_RANGE__FP12RS_STACKDATAi);
int _GET_NEAR_TBOX_POS(RS_STACKDATA *stack, int argc) {
    float target[4];
    float boxPos[4];
    DNG_BATTLE_AREA *dngScene;
    int nearest;
    int i;
    u8 *boxManager;
    float nearestDist;
    float dist;
    CTreasureBox *box;

    dngScene = &((CScene *)EventScene)->battle_area;
    if (dngScene == NULL) {
        return 0;
    }
    boxManager = (u8 *)dngScene->treasure_box;
    if (boxManager == NULL) {
        return 0;
    }
    nearest = -1;
    GetStackVector__FPfP12RS_STACKDATA(target, stack);

    stack = (RS_STACKDATA *)((int)stack + 0x18);
    nearestDist = 9999.0f;
    for (i = 0; i < 24; i++) {
        box = (CTreasureBox *)(boxManager + i * 0x70 + 0x10);
        if (box != NULL && (box == NULL || box->state != 0)) {
            box->GetPosition(boxPos);
            dist = mgDistVector(boxPos, target);
            if (dist < 30.0f && !(nearestDist <= dist)) {
                nearestDist = dist;
                nearest = i;
            }
        }
    }
    boxPos[0] = 0.0f;
    boxPos[1] = 0.0f;
    boxPos[2] = 0.0f;
    boxPos[3] = 0.0f;
    if (nearest >= 0) {
        box = (CTreasureBox *)(boxManager + nearest * 0x70 + 0x10);
        box->GetPosition(boxPos);
    }
    SetStack__FP12RS_STACKDATAf__2(stack++, boxPos[0]);
    SetStack__FP12RS_STACKDATAf__2(stack++, boxPos[1]);
    SetStack__FP12RS_STACKDATAf__2(stack++, boxPos[2]);
    SetStack__FP12RS_STACKDATAi__2(stack, nearest);
    return 1;
}
int _CONV_CHRNO_S2L(RS_STACKDATA *stack, int argc) {
    return 0;
}
int _SWE_INIT(RS_STACKDATA *stack, int argc) {
    int charaNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int stackNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int initParam1 = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int initParam2 = GetStackInt__FP12RS_STACKDATA__2(stack);
    CCharacter2 *chara;
    if ((chara = GetCharacter(charaNo)) == NULL) {
        return 0;
    }
    mgCMemory *sceneStack;
    if ((sceneStack = (mgCMemory *)((CScene *)EventScene)->GetStack(stackNo)) == NULL) {
        return 0;
    }
    CSWordAfterEffect *effect =
        (CSWordAfterEffect *)operator new(0xA0, (u_long128 *)sceneStack->Alloc(12));
    if (effect != NULL) {
        effect->color0[0] = 0x80;
        effect->color0[1] = 0x80;
        effect->color0[2] = 0x80;
        effect->color0[3] = 0x80;
        effect->color1[0] = 0x80;
        effect->color1[1] = 0x80;
        effect->color1[2] = 0x80;
        effect->color1[3] = 0x80;
    }
    chara->sword_effect[slot] = effect;
    if (chara->sword_effect[slot] == NULL) {
        return 0;
    }
    chara->sword_effect[slot]->Initialize(sceneStack, initParam1, initParam2);
    return 1;
}
int _SWE_SET_COLOR(RS_STACKDATA *stack, int argc) {
    int aR, aG, aB, aA, bR, bG, bB, bA;
    int charaNo, slot;
    CCharacter2 *chara;
    CSWordAfterEffect **effectSlot;
    charaNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
    if ((chara = GetCharacter(charaNo)) == NULL) {
        return 0;
    }
    effectSlot =
        (CSWordAfterEffect *
             *)((slot << 2) + (int)chara +
                chara_sword_after_offset);
    if (*effectSlot == NULL) {
        return 0;
    }
    aR = GetStackInt__FP12RS_STACKDATA__2(stack++);
    aG = GetStackInt__FP12RS_STACKDATA__2(stack++);
    aB = GetStackInt__FP12RS_STACKDATA__2(stack++);
    aA = GetStackInt__FP12RS_STACKDATA__2(stack++);
    bR = GetStackInt__FP12RS_STACKDATA__2(stack++);
    bG = GetStackInt__FP12RS_STACKDATA__2(stack++);
    bB = GetStackInt__FP12RS_STACKDATA__2(stack++);
    bA = GetStackInt__FP12RS_STACKDATA__2(stack);
    CSWordAfterEffect *effect = *effectSlot;
    effect->color0[0] = aR;
    effect->color0[1] = aG;
    effect->color0[2] = aB;
    effect->color0[3] = aA;
    effect->color1[0] = bR;
    effect->color1[1] = bG;
    effect->color1[2] = bB;
    effect->color1[3] = bA;
    return 1;
}
int _SWE_SET_TEXTURE(RS_STACKDATA *stack, int argc) {
    mgCTexture *texture;
    int blockNo;
    char *name;
    int u0;
    int v0;
    int u1;
    int v1;
    CSWordAfterEffect **effectSlot;
    CCharacter2 *chara;
    int slot;
    int charaNo;
    charaNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
    if ((chara = GetCharacter(charaNo)) == NULL) {
        return 0;
    }
    effectSlot =
        (CSWordAfterEffect *
             *)((slot << 2) + (int)chara +
                chara_sword_after_offset);
    if (*effectSlot == NULL) {
        return 0;
    }
    blockNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    name = GetStackString__FP12RS_STACKDATA__2(stack++);
    u0 = GetStackInt__FP12RS_STACKDATA__2(stack++);
    v0 = GetStackInt__FP12RS_STACKDATA__2(stack++);
    u1 = GetStackInt__FP12RS_STACKDATA__2(stack++);
    v1 = GetStackInt__FP12RS_STACKDATA__2(stack);
    if ((texture = mgTexManager.GetTexture( name, blockNo)) == NULL) {
        return 0;
    }
    (*effectSlot)->SetTexture(blockNo, texture, u0, v0, u1, v1);
    return 1;
}
int _SWE_START_EFFECT(RS_STACKDATA *stack, int argc) {
    int charaNo;
    int slot;
    CCharacter2 *chara;
    char *fromName;
    char *toName;
    int param8C;
    int frames;
    int param90;
    CSWordAfterEffect **effectSlot;
    mgCFrame *fromFrame;
    mgCFrame *toFrame;
    charaNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
    if ((chara = GetCharacter(charaNo)) == NULL) {
        return 0;
    }
    effectSlot =
        (CSWordAfterEffect *
             *)((slot << 2) + (int)chara +
                chara_sword_after_offset);
    if (*effectSlot == NULL) {
        return 0;
    }
    fromName = GetStackString__FP12RS_STACKDATA__2(stack++);
    toName = GetStackString__FP12RS_STACKDATA__2(stack++);
    param8C = GetStackInt__FP12RS_STACKDATA__2(stack++);
    frames = GetStackInt__FP12RS_STACKDATA__2(stack++);
    param90 = GetStackInt__FP12RS_STACKDATA__2(stack);
    if (chara->CObjectFrame::frame == NULL) {
        return 0;
    }
    if ((fromFrame = chara->CObjectFrame::frame->SearchFrame(fromName)) == NULL) {
        return 0;
    }
    if (chara->CObjectFrame::frame == NULL) {
        return 0;
    }
    if ((toFrame = chara->CObjectFrame::frame->SearchFrame(toName)) == NULL) {
        return 0;
    }
    (*effectSlot)->StartEffect(fromFrame, toFrame, param8C, frames, param90);
    return 1;
}
int _SET_CHARA_TYPE(RS_STACKDATA *stack, int argc) {
    int charaNo;

    charaNo = (int)(GetStackInt__FP12RS_STACKDATA__2(stack++));
    ((CScene *)EventScene)->SetType(1, charaNo, GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
int _GET_EVENT_DATA(RS_STACKDATA *stack, int argc) {
    CSceneEventData *eventData;

    eventData = &((CScene *)EventScene)->event_data;
    if (eventData == NULL) {
        return 0;
    }
    switch (GetStackInt__FP12RS_STACKDATA__2(stack++)) {
        case 0:
            SetStack__FP12RS_STACKDATAi__2(stack, eventData->event.flag);
            break;
        case 1:
            SetStack__FP12RS_STACKDATAi__2(stack, eventData->event.event_no);
            break;
        case 2:
            SetStack__FP12RS_STACKDATAi__2(stack, eventData->event.point_no);
            break;
        case 3:
            SetStack__FP12RS_STACKDATAi__2(stack, eventData->event.unk_2c);
            break;
        case 4:
            SetStack__FP12RS_STACKDATAi__2(stack, eventData->event.unk_30);
            break;
        case 5:
            SetStack__FP12RS_STACKDATAi__2(stack, eventData->event.unk_34);
            break;
        case 6:
            SetStack__FP12RS_STACKDATAi__2(stack, eventData->map_event.check_type);
            break;
        case 7:
            SetStack__FP12RS_STACKDATAi__2(stack, eventData->map_event.event_no);
            break;
        case 8:
            SetStack__FP12RS_STACKDATAf__2(stack++, ((float *)&eventData->vectors_b.v[0])[0]);
            SetStack__FP12RS_STACKDATAf__2(stack++, ((float *)&eventData->vectors_b.v[0])[1]);
            SetStack__FP12RS_STACKDATAf__2(stack++, ((float *)&eventData->vectors_b.v[0])[2]);
            SetStack__FP12RS_STACKDATAf__2(stack,
                            atan2f(((float *)&eventData->vectors_a.v[3])[0], ((float *)&eventData->vectors_a.v[3])[2]));
            break;
        case 9:
            SetStack__FP12RS_STACKDATAi__2(stack, eventData->map_event.parts_no);
            break;
        case 10:
            SetStack__FP12RS_STACKDATAf__2(stack++, eventData->position[0]);
            SetStack__FP12RS_STACKDATAf__2(stack++, eventData->position[1]);
            SetStack__FP12RS_STACKDATAf__2(stack, eventData->position[2]);
            break;
        case 11:
            switch (argc) {
                case 2:
                    SetStack__FP12RS_STACKDATAf__2(stack, eventData->rotation[1]);
                    break;
                case 4:
                    SetStack__FP12RS_STACKDATAf__2(stack++, eventData->rotation[0]);
                    SetStack__FP12RS_STACKDATAf__2(stack++, eventData->rotation[1]);
                    SetStack__FP12RS_STACKDATAf__2(stack, eventData->rotation[2]);
                    break;
                default:
                    break;
            }
            break;
        case 12:
            SetStack__FP12RS_STACKDATAf__2(stack++, eventData->scale[0]);
            SetStack__FP12RS_STACKDATAf__2(stack++, eventData->scale[1]);
            SetStack__FP12RS_STACKDATAf__2(stack, eventData->scale[2]);
            break;
        case 13:
            SetStack__FP12RS_STACKDATAi__2(stack, eventData->chara_slot);
            break;
        case 14:
            SetStack__FP12RS_STACKDATAi__2(stack, eventData->chara_no);
            break;
        case 15:
            SetStack__FP12RS_STACKDATAi__2(stack, eventData->gameobj_no);
            break;
        default:
            return 0;
    }
    return 1;
}
int _DNG_SET_PREV_FLOOR(RS_STACKDATA *stack, int argc) {
    int floor = GetStackInt__FP12RS_STACKDATA__2(stack);
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
    SetStack__FP12RS_STACKDATAi__2(stack, dungeon->prev_floor_id[dungeon->stage_id]);
    return 1;
}
int _DNG_SET_FAST_FLOOR(RS_STACKDATA *stack, int argc) {
    return 0;
}
int _SET_FLOOR_INFO(RS_STACKDATA *stack, int argc) {
    int dungeonNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int floorNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int field = GetStackInt__FP12RS_STACKDATA__2(stack++);
    CSaveData *save = GetSaveData();
    if (save == NULL) {
        return 0;
    }
    CSaveDataDungeon *dungeon = &save->save_dungeon;
    if (dungeon == NULL) {
        return 0;
    }
    DNG_FLOOR_SAVE *info;
    if ((info = dungeon->GetFloorInfoPtr(dungeonNo, floorNo)) == NULL) {
        return 0;
    }
    switch (field) {
        case 0:
            info->unk_0 = (int)GetStackFloat__FP12RS_STACKDATA__2(stack);
            break;
        case 1:
            info->fast_destroy_time = (int)GetStackFloat__FP12RS_STACKDATA__2(stack);
            break;
        case 2:
            info->unk_8 = GetStackInt__FP12RS_STACKDATA__2(stack);
            break;
        case 3:
            info->unk_a = GetStackInt__FP12RS_STACKDATA__2(stack);
            break;
        case 4:
            info->spheda_clear = GetStackInt__FP12RS_STACKDATA__2(stack);
            break;
        case 5:
            info->flag |= (u16)GetStackInt__FP12RS_STACKDATA__2(stack);
            break;
        case 6:
            info->kill_count = GetStackInt__FP12RS_STACKDATA__2(stack);
            break;
        case 7:
            info->visit_count = GetStackInt__FP12RS_STACKDATA__2(stack);
            break;
        default:
            return 0;
    }
    return 1;
}
int _GET_FLOOR_INFO(RS_STACKDATA *stack, int argc) {
    int dungeonNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int floorNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int field = GetStackInt__FP12RS_STACKDATA__2(stack++);
    CSaveData *save = GetSaveData();
    if (save == NULL) {
        return 0;
    }
    CSaveDataDungeon *dungeon = &save->save_dungeon;
    if (dungeon == NULL) {
        return 0;
    }
    DNG_FLOOR_SAVE *info = dungeon->GetFloorInfoPtr(dungeonNo, floorNo);
    if (info == NULL) {
        return 0;
    }
    switch (field) {
        case 0:
            SetStack__FP12RS_STACKDATAi__2(stack, info->unk_0);
            break;
        case 1:
            SetStack__FP12RS_STACKDATAi__2(stack, info->fast_destroy_time);
            break;
        case 2:
            SetStack__FP12RS_STACKDATAi__2(stack, info->unk_8);
            break;
        case 3:
            SetStack__FP12RS_STACKDATAi__2(stack, info->unk_a);
            break;
        case 4:
            SetStack__FP12RS_STACKDATAi__2(stack, info->spheda_clear);
            break;
        case 5:
            SetStack__FP12RS_STACKDATAi__2(stack, info->flag);
            break;
        case 6:
            SetStack__FP12RS_STACKDATAi__2(stack, info->kill_count);
            break;
        case 7:
            SetStack__FP12RS_STACKDATAi__2(stack, info->visit_count);
            break;
        default:
            return 0;
    }
    return 1;
}
int _GET_NEXT_FLOOR(RS_STACKDATA *stack, int argc) {
    int floor = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int route = GetStackInt__FP12RS_STACKDATA__2(stack++);
    DNG_BATTLE_AREA *dngScene = &((CScene *)EventScene)->battle_area;
    if (dngScene == NULL) {
        return 0;
    }
    CDngFloorManager *floorManager = &dngScene->floor_manager;
    if (floorManager == NULL) {
        return 0;
    }
    argc = floorManager->GetDngMapNextFloorID(floor, route);
    SetStack__FP12RS_STACKDATAi__2(stack, argc);
    return 1;
}
int _PAD_AUTO_REPEAT_OFF(RS_STACKDATA *stack, int argc) {
    GamePad__2.AutoRepeatOff();
    return 1;
}
int _PAD_SET_AUTO_REPEAT(RS_STACKDATA *stack, int argc) {
    int mask = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int delay = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int interval = GetStackInt__FP12RS_STACKDATA__2(stack);
    GamePad__2.SetAutoRepeat(mask, delay, interval);
    return 1;
}
int _DNG_PAUSE(RS_STACKDATA *stack, int argc) {
    int mask = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int enable = GetStackInt__FP12RS_STACKDATA__2(stack);
    DNG_BATTLE_AREA *dngScene = &((CScene *)EventScene)->battle_area;
    if (dngScene == NULL) {
        return 0;
    }
    if (enable) {
        dngScene->pause_flag |= mask;
    } else {
        dngScene->pause_flag &= ~mask;
    }
    return 1;
}
int _DNG_CHECK_PAUSE(RS_STACKDATA *stack, int argc) {
    int mask = GetStackInt__FP12RS_STACKDATA__2(stack++);
    DNG_BATTLE_AREA *dngScene = &((CScene *)EventScene)->battle_area;
    if (dngScene == NULL) {
        return 0;
    }
    int pauseFlags = dngScene->pause_flag;
    SetStack__FP12RS_STACKDATAi__2(stack, pauseFlags & mask);
    return 1;
}
int _DNG_RESET_TIMER(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *dngScene;

    dngScene = &((CScene *)EventScene)->battle_area;
    if (dngScene == NULL) {
        return 0;
    }
    dngScene->timer = 0;
    return 1;
}
int _DNG_GET_TIMER(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *dngScene;

    dngScene = &((CScene *)EventScene)->battle_area;
    if (dngScene == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(stack, dngScene->timer);
    return 1;
}
int _LOAD_SKIN(RS_STACKDATA *stack, int argc) {
    int stackNo;
    int imageBlock;
    int charaNo;
    char name[32];
    char *infoName;
    char *packFile;
    CCharacter2 *chara;
    mgCMemory *sceneStack;
    mgCTextureManager *texManager;
    stackNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    switch (stack->type) {
        case 0:
            packFile = (char *)GetItemFilePath(GetStackInt__FP12RS_STACKDATA__2(stack++), 0);
            break;
        case 2:
            packFile = GetStackString__FP12RS_STACKDATA__2(stack++);
            break;
    }
    infoName = GetStackString__FP12RS_STACKDATA__2(stack++);
    charaNo = GetStackInt__FP12RS_STACKDATA__2(stack);
    if ((chara = GetCharacter(charaNo)) == NULL) {
        return 0;
    }
    if (0 > (imageBlock = ((CScene *)EventScene)->GetCharaTexb(charaNo))) {
        return 0;
    }
    if ((sceneStack = (mgCMemory *)((CScene *)EventScene)->GetStack(stackNo)) == NULL) {
        return 0;
    }

    if ((packFile = (char *)GetLoadBGBuff(packFile, 0)) == 0) {
        return 0;
    }
    sprintf(name, at_2292__2, charaNo);
    texManager = &mgTexManager;
    if (charaNo >= 8) {
        strcpy(texManager->name_suffix, name);
    }
    chara->LoadSkin((u32 *)packFile, infoName, at_1083, sceneStack, imageBlock);
    if (charaNo >= 8) {
        texManager->name_suffix[0] = 0;
    }
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _CHK_CAMERA_COL__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_PARTS_FUNC_POS__FP12RS_STACKDATAi);
int _RANDOM_CIRCLE_GET_POS(RS_STACKDATA *stack, int argc) {
    float pos[3];
    int circleId = GetStackInt__FP12RS_STACKDATA__2(stack++);
    if (RandomCircle.GetPosition( pos, circleId) <= -1) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAf__2(stack++, pos[0]);
    SetStack__FP12RS_STACKDATAf__2(stack++, pos[1]);
    SetStack__FP12RS_STACKDATAf__2(stack, pos[2]);
    return 1;
}
int _RANDOM_CIRCLE_OFF(RS_STACKDATA *stack, int argc) {
    int circleId = GetStackInt__FP12RS_STACKDATA__2(stack);
    if (circleId == -1) {
        int current = RandomCircle.hit;
        if (current != -1) {
            RandomCircle.active[current] = 0;
        }
    } else {
        RandomCircle.active[circleId] = 0;
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
    GeoStone.SetFlag( GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GEOSTONE_SET_REFERENCE__FP12RS_STACKDATAi);
int _GEOSTONE_DEL_REFERENCE(RS_STACKDATA *stack, int argc) {
    if (GeoStone.CObjectFrame::frame == NULL) {
        return 0;
    }
    GeoStone.CObjectFrame::frame->DeleteReference();
    return 1;
}
int _GET_ROBO_MOVE_TYPE(RS_STACKDATA *stack, int argc) {
    SetStack__FP12RS_STACKDATAi__2(stack, ((CActionChara *)GetCharacter(0))->move_type);
    return 1;
}
int _SET_EXIT_FLAG(RS_STACKDATA *stack, int argc) {
    ((CScene *)EventScene)->exit_flag = GetStackInt__FP12RS_STACKDATA__2(stack);
    return 1;
}
int _GET_EXIT_FLAG(RS_STACKDATA *stack, int argc) {
    SetStack__FP12RS_STACKDATAi__2(stack, ((CScene *)EventScene)->exit_flag);
    return 1;
}
int _GET_E3_VERSION(RS_STACKDATA *stack, int argc) {
    SetStack__FP12RS_STACKDATAi__2(stack, 0);
    return 1;
}
int _CHK_PAD_CTRL(RS_STACKDATA *stack, int argc) {
    int pressed;
    if (argc != 2) {
        return 0;
    }
    pressed = PadCtrl.Btn(GetStackInt__FP12RS_STACKDATA__2(stack++));
    SetStack__FP12RS_STACKDATAi__2(stack, pressed);
    return 1;
}
int _CTRLC_STAY(RS_STACKDATA *stack, int argc) {
    CCameraControl *camera = (CCameraControl *)GetCamera();
    camera->Stay();
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _BSCN_SET_BLIGHT_RATE__FP12RS_STACKDATAi);
int _GET_RND_CIRCLE_TRAPID(RS_STACKDATA *stack, int argc) {
    int circleId = GetStackInt__FP12RS_STACKDATA__2(stack++);
    SetStack__FP12RS_STACKDATAi__2(stack, GetRandomCircleTrapID(circleId));
    return 1;
}
int _SET_RND_CIRCLE_STATUS(RS_STACKDATA *stack, int argc) {
    float result;
    int circleId = GetStackInt__FP12RS_STACKDATA__2(stack++);
    SetRandamCircleStatus(circleId, result);
    SetStack__FP12RS_STACKDATAf__2(stack, result);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_STATUSBAR_SHOW__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_PULL_ITEM__FP12RS_STACKDATAi);
int _MENU_CHARA_CHENGE(RS_STACKDATA *stack, int argc) {
    GetStackInt__FP12RS_STACKDATA__2(stack);
    MenuArg.open_type = 0xE;
    EdEventInfo.command_mode = 3;
    return 1;
}
int _GET_EVENT_INFO_SNDID(RS_STACKDATA *stack, int argc) {
    int index = GetStackInt__FP12RS_STACKDATA__2(stack++);
    SetStack__FP12RS_STACKDATAi__2(stack, EdEventInfo.snd_id[index]);
    return 1;
}
int _GET_PARTS_POS(RS_STACKDATA *stack, int argc) {
    CMap *maps[8];
    float pos[4];
    CMapParts *parts;
    int mapCount;
    int i;
    int partsId;
    char *partsName;
    mapCount = ((CScene *)EventScene)->GetActiveMap(maps, 8);
    if (!(mapCount > 0)) {
        return 0;
    }
    switch (stack->type) {
        case 0:
            partsId = GetStackInt__FP12RS_STACKDATA__2(stack++);
            for (i = 0; i < mapCount; i++) {
                parts = maps[i]->GetPlaceParts( partsId);
                if (parts != NULL) {
                    break;
                }
            }
            break;
        case 2:
            partsName = GetStackString__FP12RS_STACKDATA__2(stack++);
            for (i = 0; i < mapCount; i++) {
                parts = maps[i]->GetPlaceParts( partsName);
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
    SetStack__FP12RS_STACKDATAf__2(stack++, pos[0]);
    SetStack__FP12RS_STACKDATAf__2(stack++, pos[1]);
    SetStack__FP12RS_STACKDATAf__2(stack, pos[2]);
    return 1;
}
int _CANCEL_DRAMA_SCENE(RS_STACKDATA *stack, int argc) {
    CancelDramaScene();
    return 1;
}
int _GET_RNDC_MOT_NOWT(RS_STACKDATA *stack, int argc) {
    float weight = RandomCircle.model.frame;
    SetStack__FP12RS_STACKDATAf__2(stack, weight);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_CHARA_MOT_NOWT__FP12RS_STACKDATAi);
int _CHARA_NORMAL_DRIVE(RS_STACKDATA *stack, int argc) {
    CCharacter2 *chara;
    chara = GetCharacter(GetStackInt__FP12RS_STACKDATA__2(stack));
    if (chara == NULL) {
        return 0;
    }
    chara->NormalDrive();
    return 1;
}
int _CHARA_RESET_DA(RS_STACKDATA *stack, int argc) {
    CCharacter2 *chara;

    if ((chara = GetCharacter(GetStackInt__FP12RS_STACKDATA__2(stack))) == NULL) {
        return 0;
    }
    chara->ResetDAPosition();
    chara->StepDA(0xA);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _DNG_SETUP_MAIN_UNIT__FP12RS_STACKDATAi);
int _JOIN_PARTY_MEMBER(RS_STACKDATA *stack, int argc) {
    int charaNo;
    CUserDataManager *userData;
    CSaveData *save = GetSaveData();
    if (save == NULL) {
        return 0;
    }
    userData = &save->user_data;
    if (userData == NULL) {
        return 0;
    }
    charaNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    switch (stack->type) {
        case 0:
            if (GetStackInt__FP12RS_STACKDATA__2(stack) == 1) {
                userData->JoinPartyMember(charaNo);
            } else {
                userData->LeavePartyMember(charaNo);
            }
            break;
        case 3: {
            int members = userData->GetNowPartyMember();
            SetStack__FP12RS_STACKDATAi__2(stack, (members & (1 << charaNo)) ? 1 : 0);
            break;
        }
        default:
            return 0;
    }
    return 1;
}
int _SET_CHARA_CHANGE_FLAG(RS_STACKDATA *stack, int argc) {
    int charaNo;
    CUserDataManager *userData;
    CSaveData *save = GetSaveData();
    if (save == NULL) {
        return 0;
    }
    userData = &save->user_data;
    if (userData == NULL) {
        return 0;
    }
    charaNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    if (GetStackInt__FP12RS_STACKDATA__2(stack) == 1) {
        userData->EnableCharaChange(charaNo);
    } else {
        userData->DisableCharaChange(charaNo);
    }
    return 1;
}
int _SET_CHARA_CHANGE_MASK(RS_STACKDATA *stack, int argc) {
    int charaNo;
    CUserDataManager *userData;
    CSaveData *save = GetSaveData();
    if (save == NULL) {
        return 0;
    }
    userData = &save->user_data;
    if (userData == NULL) {
        return 0;
    }
    charaNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    if (GetStackInt__FP12RS_STACKDATA__2(stack) == 1) {
        userData->EnableCharaChangeMask(charaNo);
    } else {
        userData->DisableCharaChangeMask(charaNo);
    }
    return 1;
}
int _SET_CHARA_EQUIP(RS_STACKDATA *stack, int argc) {
    int charaNo;
    int itemNo;
    CSaveData *save = GetSaveData();
    if (save == NULL) {
        return 0;
    }
    CUserDataManager *userData = &save->user_data;
    if (userData == NULL) {
        return 0;
    }
    charaNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    itemNo = GetStackInt__FP12RS_STACKDATA__2(stack);
    return userData->SetChrEquip(charaNo, itemNo);
}
int _LOAD_PACK_FILE(RS_STACKDATA *stack, int argc) {
    if (GetLoadBGBuff(GetStackString__FP12RS_STACKDATA__2(stack), 0) == 0) {
        return 0;
    }
    EdEventInfo.pack_loaded = 1;
    return 1;
}
int _SET_BIT_CTRL(RS_STACKDATA *stack, int argc) {
    CSaveData *save;
    int bit;

    if ((save = GetSaveData()) == NULL) {
        return 0;
    }
    bit = (int)(GetStackInt__FP12RS_STACKDATA__2(stack++));
    if (GetStackInt__FP12RS_STACKDATA__2(stack) == 1) {
        save->SetBitCtrl(bit);
    } else {
        save->ResetBitCtrl(bit);
    }
    return 1;
}
int _GET_BIT_CTRL(RS_STACKDATA *stack, int argc) {
    CSaveData *save;
    int bit;
    int ctrl;

    if ((save = GetSaveData()) == NULL) {
        return 0;
    }
    bit = (int)(GetStackInt__FP12RS_STACKDATA__2(stack++));
    ctrl = save->GetBitCtrl();
    SetStack__FP12RS_STACKDATAi__2(stack, (ctrl & bit) ? 1 : 0);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _LOAD_ARG__FP12RS_STACKDATAi);
int _GET_ITEM_HAVE_NUM(RS_STACKDATA *stack, int argc) {
    int itemId = GetStackInt__FP12RS_STACKDATA__2(stack++);
    argc = GetUserItemHaveNum(itemId);
    SetStack__FP12RS_STACKDATAi__2(stack, argc);
    return 1;
}
int _SET_SKIP_BOTTON(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    EdEventInfo.skip_button = GetStackInt__FP12RS_STACKDATA__2(stack);
    return 1;
}
int _SET_SKIP_FCOL(RS_STACKDATA *stack, int argc) {
    if (argc != 3) {
        return 0;
    }
    GetStackVector__FPfP12RS_STACKDATA(EdEventInfo.skip_fade_color, stack);
    EdEventInfo.skip_fade_color[3] = 0;
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_DEBUG_MODE__FP12RS_STACKDATAi);
int _GET_MAP_TYPE(RS_STACKDATA *stack, int argc) {
    int mapNo;
    RS_STACKDATA *result;
    switch (stack->type) {
        case 0:
            result = stack + 1;
            mapNo = GetStackInt__FP12RS_STACKDATA__2(stack);
            break;
        case 2:
            result = stack + 1;
            mapNo = SearchMapNo(GetStackString__FP12RS_STACKDATA__2(stack));
            break;
        default:
            return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(result, GetMapType(mapNo));
    return 1;
}
int _DNG_COLLISION_ALL_CLR(RS_STACKDATA *stack, int argc) {
    ColPrimMan.Initialize(DngMainScene);
    return 1;
}
int _SET_MAP_DRAW(RS_STACKDATA *stack, int argc) {
    EdEventInfo.map_draw = GetStackInt__FP12RS_STACKDATA__2(stack);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _CHECK_MC_LOAD__FP12RS_STACKDATAi);
int _SET_NOW_MAP_NO(RS_STACKDATA *stack, int argc) {
    ((CScene *)EventScene)->SetNowMapNo(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_TBOX_PARAM__FP12RS_STACKDATAi);
int _CANCEL_LOAD_VILLAGER(RS_STACKDATA *stack, int argc) {
    CScene *scene = (CScene *)EventScene;
    scene->skip_load_sub_villager = 1;
    scene->skip_load_villager = 1;
    return 1;
}
int _CANCEL_NOW_LOADING(RS_STACKDATA *stack, int argc) {
    CancelNowLoading();
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _ESM_INITIALIZE__FP12RS_STACKDATAi);
int _ESM_INIT_FIX(RS_STACKDATA *stack, int argc) {
    int stackNo;
    int heapSize;
    mgCMemory *sceneStack;
    mgCMemory *heap;
    if (EventEffectScript == 0) {
        return 0;
    }
    heapSize = 0x36B0;
    stackNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    if (argc >= 2) {
        heapSize = GetStackInt__FP12RS_STACKDATA__2(stack);
    }
    if ((sceneStack = (mgCMemory *)((CScene *)EventScene)->GetStack(stackNo)) == NULL) {
        return 0;
    }
    if ((heap = (mgCMemory *)operator new(0x30, (u_long128 *)sceneStack->Alloc(5))) != NULL) {
        heap->Init();
    }
    if (heap == NULL) {
        return 0;
    }
    heap->SetHeapMem((u_long128 *)sceneStack->stAlloc64(heapSize), heapSize);
    heap->stack_used = 0;
    heap->lock = 0;
    EventEffectScript->SetWorkBuffer(heap);
    return 1;
}
int _ESM_CLEAR(RS_STACKDATA *stack, int argc) {
    int clearedBlocks[68];
    mgCMemory *workBuffer;
    mgCTextureManager *texManager;
    int i;

    if (EventEffectScript == 0) {
        return 0;
    }
    EventEffectScript->ClearBaseFromLevel(0, clearedBlocks, 64);
    EventEffectScript->AllClearEffSpt();
    workBuffer = (mgCMemory *)EventEffectScript->work_memory;
    if (workBuffer != NULL) {
        workBuffer->stack_used = 0;
        workBuffer->lock = 0;
        workBuffer->ClearHeapMem();
    }
    texManager = &mgTexManager;
    EventEffectScript = 0;
    for (i = 0; i < 64; i++) {
        printf(at_9148, clearedBlocks[i]);

        if (clearedBlocks[i] <= -1) {
            break;
        }
        texManager->DeleteBlock(clearedBlocks[i]);
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
            ret = EventEffectScript->LoadBaseEffSpt(GetStackInt__FP12RS_STACKDATA__2(stack), NULL, -1);
            break;
        case 2:
            ret = EventEffectScript->LoadBaseEffSpt(GetStackString__FP12RS_STACKDATA__2(stack), NULL, -1);
            break;
        default:
            ret = 0;
            break;
    }
    return ret;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _ESM_CREATE__FP12RS_STACKDATAi__2);
extern "C" int _ESM_FINISH__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    int group;
    RS_STACKDATA *nextSlot = (RS_STACKDATA *)((u8 *)stack + 8);

    if (EventEffectScript == NULL) {
        return 0;
    }
    group = GetStackInt__FP12RS_STACKDATA__2(stack);
    EventEffectScript->SetScriptProgNo(0x12C, group, GetStackInt__FP12RS_STACKDATA__2(nextSlot));
    return 1;
}
extern "C" int _ESM_DELETE__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    if (EventEffectScript == NULL) {
        return 0;
    }
    int group = GetStackInt__FP12RS_STACKDATA__2(stack++);
    EventEffectScript->DeleteEffSpt(group, GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _ESM_SET_VECT1__FP12RS_STACKDATAi__2);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _ESM_SET_VECT2__FP12RS_STACKDATAi__2);
extern "C" int _ESM_SET_TARGET_ID__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    int param1;
    int param2;
    int ret;

    if (EventEffectScript == NULL) {
        return 0;
    }
    switch (argc) {
        case 1:
            ret = EventEffectScript->SetScriptTargetId(GetStackInt__FP12RS_STACKDATA__2(stack), -1, -1);
            break;
        case 3:
            param1 = GetStackInt__FP12RS_STACKDATA__2(stack++);
            param2 = GetStackInt__FP12RS_STACKDATA__2(stack++);
            ret = EventEffectScript->SetScriptTargetId(GetStackInt__FP12RS_STACKDATA__2(stack), param1, param2);
            break;
        default:
            ret = 0;
            break;
    }
    return ret;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _ESM_LOAD_BASE_PACK__FP12RS_STACKDATAi);
extern "C" int _ESM_SET_VALUE__FP12RS_STACKDATAi__2(RS_STACKDATA *stack, int argc) {
    int valueNo;
    int group;
    int slot;
    int ret;

    if (EventEffectScript == 0) {
        return 0;
    }
    switch (argc) {
        case 2:
            valueNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
            switch (stack->type) {
                case 0:
                    ret = EventEffectScript->SetValue(valueNo, GetStackInt__FP12RS_STACKDATA__2(stack), -1, -1);
                    break;
                case 1:
                    ret = EventEffectScript->SetValue(valueNo, GetStackFloat__FP12RS_STACKDATA__2(stack), -1, -1);
                    break;
                default:
                    return 0;
            }
            break;
        case 4:
            group = GetStackInt__FP12RS_STACKDATA__2(stack++);
            slot = GetStackInt__FP12RS_STACKDATA__2(stack++);
            valueNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
            switch (stack->type) {
                case 0:
                    ret = EventEffectScript->SetValue(valueNo, GetStackInt__FP12RS_STACKDATA__2(stack), group, slot);
                    break;
                case 1:
                    ret = EventEffectScript->SetValue(valueNo, GetStackFloat__FP12RS_STACKDATA__2(stack), group, slot);
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
            int chara;
            if ((info = GetBattleCharaInfo()) == 0) {
                return 0;
            }
            chara = GetStackInt__FP12RS_STACKDATA__2(stack++);
            info->SetAttr(chara, GetStackInt__FP12RS_STACKDATA__2(stack));
            break;
        }
        case 3: {
            CUserDataManager *userData;
            int attr;
            int charaNo;
            int value;
            if ((userData = GetUserDataMan()) == NULL) {
                return 0;
            }
            charaNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
            attr = GetStackInt__FP12RS_STACKDATA__2(stack++);
            value = GetStackInt__FP12RS_STACKDATA__2(stack);
            if (userData != NULL) {
                userData->SetCharaStatusAttirbute(charaNo, attr, value);
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
    int chara = GetStackInt__FP12RS_STACKDATA__2(stack++);
    int amount = GetStackInt__FP12RS_STACKDATA__2(stack);
    info->AddWhp(chara, amount);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _ADD_HP_RATE__FP12RS_STACKDATAi);
int _GET_TIME(RS_STACKDATA *stack, int argc) {
    SetStack__FP12RS_STACKDATAf__2(stack, ((CScene *)EventScene)->time);
    return 1;
}
int _CHECK_GET_ITEM_LIMIT(RS_STACKDATA *stack, int argc) {
    int itemId;
    int count;
    switch (argc) {
        case 1:
            argc = CheckItemLimmitOver();
            SetStack__FP12RS_STACKDATAi__2(stack, argc);
            break;
        case 3:
            itemId = GetStackInt__FP12RS_STACKDATA__2(stack++);
            count = GetStackInt__FP12RS_STACKDATA__2(stack++);
            count = CheckGetItemRemainNum(itemId) - count < 0 ? 0 : count;
            SetStack__FP12RS_STACKDATAi__2(stack, count);
            break;
        default:
            return 0;
    }
    return 1;
}
int _CHECK_ITEM_OVER(RS_STACKDATA *stack, int argc) {
    argc = CheckItemOver();
    SetStack__FP12RS_STACKDATAi__2(stack, argc);
    return 1;
}
int _GET_NOW_LOOP_NO(RS_STACKDATA *stack, int argc) {
    argc = GetNowLoopNo();
    SetStack__FP12RS_STACKDATAi__2(stack, argc);
    return 1;
}
int _IS_CLEAR_DESTROY(RS_STACKDATA *stack, int argc) {
    CDngFloorManager *floorManager;
    DNG_BATTLE_AREA *dngScene;

    dngScene = &((CScene *)EventScene)->battle_area;
    if (dngScene == 0) {
        return 0;
    }
    floorManager = &dngScene->floor_manager;
    if (floorManager == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(stack, floorManager->IsClearMostFastDestroy());
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _IS_CLEAR_PRACTICE__FP12RS_STACKDATAi);
int _IS_PLAY_SUB_GAME(RS_STACKDATA *stack, int argc) {
    CDngFloorManager *floorManager;
    DNG_BATTLE_AREA *dngScene;

    dngScene = &((CScene *)EventScene)->battle_area;
    if (dngScene == 0) {
        return 0;
    }
    floorManager = &dngScene->floor_manager;
    if (floorManager == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(stack, floorManager->IsPlaySubGame());
    return 1;
}
int _RESET_SUBJECT_COUNTER(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *dngScene;
    CSaveData *save;

    dngScene = &((CScene *)EventScene)->battle_area;
    if (dngScene == NULL) {
        return 0;
    }
    save = GetSaveData();
    if (save == NULL) {
        return 0;
    }
    dngScene->subject_counter = (u32)save->play_time;
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SCR_EFF_INIT_RASTER__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SCR_EFF_START_RASTER__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SCR_EFF_STOP_RASTER__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_MPCHARA_MOTION__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _FUNC_POINT_POS__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _PARTS_NAME_STRCMP__FP12RS_STACKDATAi);
int _GET_TRIAL_VERSION(RS_STACKDATA *stack, int argc) {
    SetStack__FP12RS_STACKDATAi__2(stack, 0);
    return 1;
}
int _SET_FLOOR_EPISODE(RS_STACKDATA *stack, int argc) {
    StartupEpisodeTitle.Switch(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _FUNC_POINT_GET_POS__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _FUNC_POINT_GET_ROT__FP12RS_STACKDATAi);
int _ACTCHR_SET_DEF_MOTION(RS_STACKDATA *stack, int argc) {
    int charaNo;
    int motionArg = 0;
    CActionChara *chara;
    charaNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    if (argc >= 2) {
        motionArg = GetStackInt__FP12RS_STACKDATA__2(stack);
    }
    if ((chara = (CActionChara *)GetCharacter(charaNo)) == NULL) {
        return 0;
    }
    char *defaultMotion = chara->default_motion;
    chara->ResetAction();
    chara->SetMotion(defaultMotion, motionArg, 1);
    return 1;
}
int _ADD_FUSION_POINT(RS_STACKDATA *stack, int argc) {
    int group;
    int member;
    int points;
    CUserDataManager *userData;
    CSaveData *save;

    group = (int)(GetStackInt__FP12RS_STACKDATA__2(stack++));
    member = (int)(GetStackInt__FP12RS_STACKDATA__2(stack++));
    points = (int)(GetStackInt__FP12RS_STACKDATA__2(stack));
    if ((group < 0) || (group > 1)) {
        return 0;
    }
    if ((member < 0) || (userData = NULL, (member > 1))) {
        return 0;
    }
    save = GetSaveData();
    if (save != 0) {
        userData = &save->user_data;
    }
    if (userData == NULL) {
        return 0;
    }
    userData->AddFusionPoint(group, member, points);
    return 1;
}
int _GET_DEBUG_FLAG(RS_STACKDATA *stack, int argc) {
    if (argc != 1)
        return 0;
    return EventAbi::SetStack__FP12RS_STACKDATAi__2(stack, DebugFlag);
}
int _MINIMAP_DOOR_ENABLE(RS_STACKDATA *stack, int argc) {
    float pos[3];
    if (argc != 3) {
        return 0;
    }
    GetStackVector__FPfP12RS_STACKDATA(pos, stack);
    MinimapDoorEnable(pos);
    return 1;
}
int _DNG_CHECK_BOSS_MAP(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *dngScene;

    if (argc != 1) {
        return 0;
    }
    dngScene = &((CScene *)EventScene)->battle_area;
    if (dngScene == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(stack, dngScene->boss_map);
    return 1;
}
int _DNG_RUN_EVENT(RS_STACKDATA *stack, int argc) {
    int eventNo = GetStackInt__FP12RS_STACKDATA__2(stack);
    DNG_BATTLE_AREA *scene = &((CScene *)EventScene)->battle_area;
    if (scene == NULL) {
        return 0;
    }
    s16 *slot = &scene->script.event_no;
    if (slot == NULL) {
        return 0;
    }
    *slot = (s16)eventNo;
    return 1;
}
int _CHECK_ENABLE_CHARA_CHANGE(RS_STACKDATA *stack, int argc) {
    CUserDataManager *userData;
    int charaNo;
    CSaveData *save;
    RS_STACKDATA *nextSlot;

    if (argc != 2) {
        return 0;
    }
    nextSlot = (RS_STACKDATA *)((u8 *)stack + 8);
    charaNo = (int)(GetStackInt__FP12RS_STACKDATA__2(stack));
    save = GetSaveData();
    if (save == 0) {
        return 0;
    }
    userData = &save->user_data;
    if (userData == NULL) {
        return 0;
    }
    SetStack__FP12RS_STACKDATAi__2(nextSlot, userData->CheckEnableCharaChange(charaNo, NULL));
    return 1;
}
int _INIT_SEPIA(RS_STACKDATA *stack, int argc) {
    int stackNo;
    int blockOffset;
    u_long128 *buffer;
    mgCMemory *sceneStack;
    int blockNo;
    int size;
    CScene *scene;
    int texCount;
    int texBase;

    blockOffset = 0;
    stackNo = GetStackInt__FP12RS_STACKDATA__2(stack++);
    if (argc >= 2) {
        blockOffset = GetStackInt__FP12RS_STACKDATA__2(stack);
    }
    scene = (CScene *)EventScene;
    texCount = scene->event_texb_num;
    texBase = scene->event_texb;
    if (texCount <= 0 || texCount < blockOffset) {
        return 0;
    }
    blockNo = texBase + blockOffset;
    if (stackNo >= 0) {
        if ((sceneStack = (mgCMemory *)((CScene *)EventScene)->GetStack(stackNo)) == NULL) {
            return 0;
        }
        size = mgScreenWidth * mgScreenHeight * mgScreenDepth;
        if ((buffer = sceneStack->stAlloc64(size / 8 / 16 + 1)) == 0) {
            return 0;
        }
    } else {
        buffer = read_buffer;
    }
    mgTexManager.DeleteBlock(blockNo);
    EventScreenEffect.SetSepiaTexture(mgTexManager.EnterTexture(
                                          blockNo, at_9622, NULL, mgScreenWidth,
                                          mgScreenHeight, mgScreenDepth, 0, 0LL, 0),
                                      (u_long128 *)buffer);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _COPY_MONS2SCNCHR__FP12RS_STACKDATAi);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", __ct__7CObjectFRC7CObject);
int _UNLOCK_STACK(RS_STACKDATA *stack, int argc) {
    mgCMemory *sceneStack = EventScene->GetStack(GetStackInt__FP12RS_STACKDATA__2(stack));

    if (sceneStack == NULL) {
        return 0;
    }
    sceneStack->lock = 0;
    return 1;
}
int _RESET_EVENT_TRG(RS_STACKDATA *stack, int argc) {
    EventScene->event_run = 0;
    return 1;
}
int _SET_CHARA_NO(RS_STACKDATA *stack, int argc) {
    int slot = GetStackInt__FP12RS_STACKDATA__2(stack++);

    EventScene->SetCharaNo(slot, GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
int _GET_CHARA_NO(RS_STACKDATA *stack, int argc) {
    int id;
    RS_STACKDATA *args = stack;
    if (argc != 2) {
        return 0;
    }
    id = GetStackInt__FP12RS_STACKDATA__2(args++);
    SetStack__FP12RS_STACKDATAi__2(args, EventScene->GetCharaNo(id));
    return 1;
}
int _SEARCH_CHARA_NO(RS_STACKDATA *stack, int argc) {
    int id;
    RS_STACKDATA *args = stack;
    if (argc != 2) {
        return 0;
    }
    id = GetStackInt__FP12RS_STACKDATA__2(args++);
    SetStack__FP12RS_STACKDATAi__2(args, EventScene->SearchCharaID(id));
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_NEAR_RANDOM_STONE_POS__FP12RS_STACKDATAi);
int _INIT_MONO_FLASH(RS_STACKDATA *stack, int argc) {
    u_long128 *buffers[2];
    mgCTexture *textures[2];
    mgCMemory *memory;
    int stackNo;
    int texBase;
    int texCount;

    stackNo = GetStackInt__FP12RS_STACKDATA__2(stack);
    texCount = EventScene->event_texb_num;
    texBase = EventScene->event_texb;
    if (texCount <= 0 || texCount < 0) {
        return 0;
    }
    if (stackNo >= 0) {
        if ((memory = EventScene->GetStack(stackNo)) == NULL) {
            return 0;
        }
        if ((buffers[0] = (u_long128 *)memory->stAlloc64(
                 mgScreenDepth * (mgScreenWidth * mgScreenHeight) / 8 / 16 + 1)) == NULL) {
            return 0;
        }
        if ((buffers[1] = (u_long128 *)memory->stAlloc64(
                 mgScreenDepth * (mgScreenWidth * mgScreenHeight) / 8 / 16 + 1)) == NULL) {
            return 0;
        }
    } else {
        buffers[0] = (u_long128 *)read_buffer;
        buffers[1] =
            read_buffer + mgScreenDepth * (mgScreenWidth * mgScreenHeight) / 8 / 16;
    }
    mgTexManager.DeleteBlock(texBase);
    mgTexManager.DeleteBlock(texBase + 1);
    textures[0] = (mgCTexture *)mgTexManager.EnterTexture(
        texBase, at_9744, NULL, mgScreenWidth, mgScreenHeight, mgScreenDepth, 0, 0, 0);
    textures[1] = (mgCTexture *)mgTexManager.EnterTexture(
        texBase + 1, at_9745, NULL, mgScreenWidth, mgScreenHeight, mgScreenDepth, 0, 0,
        0);
    EventScreenEffect.SetMonoFlashTexture(textures, buffers);
    return 1;
}
int _START_MONO_FLASH(RS_STACKDATA *stack, int argc) {
    int param = GetStackInt__FP12RS_STACKDATA__2(stack);

    EventScreenEffect.CaptureMonoFlashScreen();
    EventScreenEffect.SetMonoFlashFlag(1, param);
    return 1;
}
int _END_MONO_FLASH(RS_STACKDATA *stack, int argc) {
    EventScreenEffect.SetMonoFlashFlag(0, 0);
    return 1;
}
int _DELETE_VILLAGER(RS_STACKDATA *stack, int argc) {
    EventScene->DeleteVillager(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
int _DNG_SET_WEATHER(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *info = (DNG_BATTLE_AREA *)&EventScene->battle_area;
    int weather;
    if (info == NULL) {
        return 0;
    }
    weather = GetStackInt__FP12RS_STACKDATA__2(stack);
    info->unk_8c = weather;
    if (weather == 2) {
        EventScene->AutoChangeEnvOffset(4);
    } else {
        EventScene->AutoChangeEnvOffset(0);
    }
    return 1;
}
int _SET_CHARA_MAXHP(RS_STACKDATA *stack, int argc) {
    int charaNo;
    RS_STACKDATA *args = stack;
    int maxHp;
    CUserDataManager *userData;
    CSaveData *save;
    CHARA_DATA *chara;

    charaNo = GetStackInt__FP12RS_STACKDATA__2(args++);
    maxHp = GetStackInt__FP12RS_STACKDATA__2(args);
    save = GetSaveData();
    if (save == NULL) {
        return 0;
    }

    userData = &save->user_data;
    if (userData == NULL) {
        return 0;
    }
    chara = userData->GetCharaDataPtr(charaNo);
    chara->hp.max = (float)maxHp;
    chara->hp.SetFillRate(1.0f);
    return 1;
}
int _SET_CHARA_DEFENCE(RS_STACKDATA *stack, int argc) {
    int charaNo;
    RS_STACKDATA *args = stack;
    int defence;
    CUserDataManager *userData;
    CSaveData *save;

    charaNo = GetStackInt__FP12RS_STACKDATA__2(args++);
    defence = GetStackInt__FP12RS_STACKDATA__2(args);
    save = GetSaveData();
    if (save == NULL) {
        return 0;
    }
    userData = &save->user_data;
    if (userData == NULL) {
        return 0;
    }
    userData->GetCharaDataPtr(charaNo)->defence = defence;
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _PLACE_PARTS_NAME_STRCMP__FP12RS_STACKDATAi);
int _GOTO_USE_ITEM2(RS_STACKDATA *stack, int argc) {
    int i;

    if (stack->type != 3) {
        return 0;
    }
    p_use_item = (RS_STACKDATA *)stack->i;
    stack++;
    MenuArg.open_type = 9;
    MenuArg.param[0] = GetStackInt__FP12RS_STACKDATA__2(stack++);
    for (i = 1; i < argc - 1; i++) {
        MenuArg.param[i] = GetStackInt__FP12RS_STACKDATA__2(stack++);
    }
    MenuArg.param[i] = 0;
    EdEventInfo.command_mode = 3;
    return 1;
}
int _DBG_SET_ANALYZE_FLAG(RS_STACKDATA *stack, int argc) {
    int area;
    RS_STACKDATA *args = stack;
    int entry;
    int flag;
    CSaveData *save;
    CEditData *editData;

    area = GetStackInt__FP12RS_STACKDATA__2(args++);
    entry = GetStackInt__FP12RS_STACKDATA__2(args++);
    flag = GetStackInt__FP12RS_STACKDATA__2(args);
    save = GetSaveData();
    if (save == NULL) {
        return 0;
    }
    editData = (CEditData *)save->GetEditData(area);
    if (editData == NULL) {
        return 0;
    }
    editData->dbgSetAnalyzeFlag(area, entry, flag);
    return 1;
}
int _ATRAMIRIA_ON_OFF(RS_STACKDATA *stack, int argc) {
    int mode;
    RS_STACKDATA *args = stack;
    int charaNo;
    int flag;

    mode = GetStackInt__FP12RS_STACKDATA__2(args++);
    charaNo = GetStackInt__FP12RS_STACKDATA__2(args++);
    flag = GetStackInt__FP12RS_STACKDATA__2(args);
    AtraMiriaOnOff(mode, GetCharacter(charaNo), flag);
    return 1;
}
int _ADD_YARIKOMI_MEDAL(RS_STACKDATA *stack, int argc) {
    CUserDataManager *userData;
    CSaveData *save = GetSaveData();

    if (save == NULL) {
        return 0;
    }
    userData = &save->user_data;
    if (userData == NULL) {
        return 0;
    }
    userData->AddYarikomiMedal(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
int _SET_MAP_EFFECT_ID(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *info = (DNG_BATTLE_AREA *)&EventScene->battle_area;
    if (info == NULL) {
        return 0;
    }
    info->map_effect_id = GetStackInt__FP12RS_STACKDATA__2(stack);
    return 1;
}
int _GET_MAP_EFFECT_ID(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *info = &EventScene->battle_area;
    if (info == NULL) {
        return 0;
    }
    switch (argc) {
        case 1:
            return EventAbi::SetStack__FP12RS_STACKDATAi__2(stack, info->map_effect_id);
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_FLOOR_STATUS__FP12RS_STACKDATAi);
int _SET_FLOOR_STATUS(RS_STACKDATA *stack, int argc) {
    DNG_BATTLE_AREA *info = (DNG_BATTLE_AREA *)&EventScene->battle_area;
    RS_STACKDATA *args = stack;
    int mask;

    if (info == NULL) {
        return 0;
    }
    mask = GetStackInt__FP12RS_STACKDATA__2(args++);
    if (GetStackInt__FP12RS_STACKDATA__2(args) != 0) {
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
    GetStackVector__FPfP12RS_STACKDATA(position, stack);

    stack = (RS_STACKDATA *)((u8 *)stack + 0x18);
    SetStack__FP12RS_STACKDATAi__2(stack, AutoMapGen.GetAttrStatus(position));
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _SET_NEAR_DIST__FP12RS_STACKDATAi);
int _SET_KEEP_TIME(RS_STACKDATA *stack, int argc) {
    EdEventInfo.keep_time = GetStackFloat__FP12RS_STACKDATA__2(stack);
    return 1;
}
int _GET_KEEP_TIME(RS_STACKDATA *stack, int argc) {
    if (argc != 1) {
        return 0;
    }
    return EventAbi::SetStack__FP12RS_STACKDATAf__2(stack, EdEventInfo.keep_time);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _GET_DOOR_PARTS_ID__FP12RS_STACKDATAi);
int _CHECK_EQUEP_CHANGE(RS_STACKDATA *stack, int argc) {
    GetStackInt__FP12RS_STACKDATA__2(stack);
    CheckEquipChange(1);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _ADD_HP_RATE2__FP12RS_STACKDATAi);
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
    EventScene->AutoChangeBGMVol(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _UDATA_GET_WHP__FP12RS_STACKDATAi);
int _UDATA_ADD_WHP(RS_STACKDATA *stack, int argc) {
    int charaNo;
    RS_STACKDATA *args = stack;
    CUserDataManager *userData;
    CSaveData *save;
    int itemNo;
    int amount;

    save = GetSaveData();
    if (save == NULL) {
        return 0;
    }
    userData = &save->user_data;
    if (userData == NULL) {
        return 0;
    }
    charaNo = GetStackInt__FP12RS_STACKDATA__2(args++);
    itemNo = GetStackInt__FP12RS_STACKDATA__2(args++);
    amount = GetStackInt__FP12RS_STACKDATA__2(args);
    userData->AddWhp(charaNo, itemNo, amount);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", _UDATA_GET_ABS__FP12RS_STACKDATAi);
int _UDATA_ADD_ABS(RS_STACKDATA *stack, int argc) {
    int charaNo;
    RS_STACKDATA *args = stack;
    CUserDataManager *userData;
    CSaveData *save;
    int itemNo;
    int amount;

    save = GetSaveData();
    if (save == NULL) {
        return 0;
    }
    userData = &save->user_data;
    if (userData == NULL) {
        return 0;
    }
    charaNo = GetStackInt__FP12RS_STACKDATA__2(args++);
    itemNo = GetStackInt__FP12RS_STACKDATA__2(args++);
    amount = GetStackInt__FP12RS_STACKDATA__2(args);
    userData->AddAbs(charaNo, itemNo, amount);
    return 1;
}
int _DNG_CREATE_EFFECT(RS_STACKDATA *stack, int argc) {
    float first[4];
    float second[4];
    int value;

    FxScriptMan->CreateEffSpt(GetStackString__FP12RS_STACKDATA__2(stack++), -1, 0);
    switch (argc) {
        case 4:
            GetStackVector__FPfP12RS_STACKDATA(first, stack);
            stack += 3;
            FxScriptMan->SetScriptVect1(first, -1, -1);
        case 5:
            GetStackVector__FPfP12RS_STACKDATA(first, stack);
            value = GetStackInt__FP12RS_STACKDATA__2(stack += 3);
            FxScriptMan->SetScriptVect1(first, -1, -1);
            FxScriptMan->SetValue(0, value, -1, -1);
            break;
        case 7:
            GetStackVector__FPfP12RS_STACKDATA(first, stack);
            stack += 3;
            GetStackVector__FPfP12RS_STACKDATA(second, stack);
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
    PauseEnable(GetStackInt__FP12RS_STACKDATA__2(stack));
    return 1;
}
int _FORCE_BOOT_TOUR(RS_STACKDATA *stack, int argc) {
    CSaveData *saveData = GetSaveData();

    if (saveData == NULL) {
        return 0;
    }
    saveData->ForceBootTour(saveData->day, 1);
    return 1;
}
void SetEventFunc(CRunScript *script) {
    int i;
    int j;

    for (i = 0; i < event_func_slots; i++) {
        ext_func__2[i] = NULL;
    }
    i = 0;
    for (;;) {
        if (ext_func_info__2[i].func == NULL) {
            break;
        }
        for (j = 0; j < i; j++) {
            if (ext_func_info__2[i].id == ext_func_info__2[j].id) {
                printf(at_10100);
                while (1) {
                }
            }
        }
        if (ext_func_info__2[i].id < 0 || ext_func_info__2[i].id >= event_func_slots) {
            printf(at_10101);
        } else {
            ext_func__2[ext_func_info__2[i].id] = ext_func_info__2[i].func;
        }
        i++;
    }
    script->ext_func(ext_func__2, event_func_slots);
}

// Static initialiser (.init)
INCLUDE_ASM("ps2/asm/pal/nonmatchings/event_func", __sinit_event_func_cpp);

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_1084__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", esa_ext_func_info__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_3242__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", vv_3333__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_3339__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_4517__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_6800__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", ext_func_info__2__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_1080__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_1081__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_1082__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_1083__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_1103__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_1104__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_1245__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_1246__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_1333__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_1346__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_1357__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_1760__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_1761__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_1904__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_1905__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_1906__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_1907__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_1908__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_1910__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_1909__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_2245__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_2246__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_2247__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_2248__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_2249__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_2291__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_2292__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_2333__4__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_2334__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_2393__3__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_2664__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_2836__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_2837__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_2838__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_2839__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_3328__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_3329__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_3631__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_3632__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_3633__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_3634__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_3635__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_3636__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_3822__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_3823__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_3884__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_4072__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_4261__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_4262__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_4263__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_4264__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_4265__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_4266__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_4267__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_4268__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_4269__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_4270__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_4271__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_4274__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_4273__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_4272__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_4291__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_4360__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_4437__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_4573__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_5262__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_5263__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_5264__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_5410__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_5411__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_5412__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_5413__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_5414__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_5415__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_5416__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_5417__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_5418__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_5419__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_5420__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_5421__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_5422__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_5424__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_5726__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_5736__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_6703__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_6773__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_6774__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_6775__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_6776__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_6781__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_6782__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_6816__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_6834__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_6839__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_7117__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_8230__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_8406__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_8458__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_8480__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_8902__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_8903__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_8904__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_9148__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_9622__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_9744__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_9745__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_10100__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", at_10101__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/event_func", D_0037B03C__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(EventMarker, 0x4);
INCLUDE_BSS(SwordEffect, 0x4);
INCLUDE_BSS(EventEffectScript, 0x4);
INCLUDE_BSS(p_use_item, 0x4);
INCLUDE_BSS(SetWorldCoordFlg, 0x4);
INCLUDE_BSS(PakuAnimEohNo, 0x4);
INCLUDE_BSS(PakuMotionEohNo, 0x4);
INCLUDE_BSS(PakuMotionType, 0x4);
INCLUDE_BSS(PakuMotionType2, 0x4);
INCLUDE_BSS(nowScriptArg, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(EdEventInfo, 0x12A0);
INCLUDE_BSS(EventObjHandleMother, 0x200);
INCLUDE_BSS(esMother, 0x440);
INCLUDE_BSS(EventLocalFlag, 0x100);
INCLUDE_BSS(EventLocalCnt, 0x100);
INCLUDE_BSS(EventRain, 0xABF0);
INCLUDE_BSS(Hit_para, 0x6400);
INCLUDE_BSS(HitEffect, 0x1E0);
INCLUDE_BSS(PakuAnimName, 0x40);
INCLUDE_BSS(PakuAnimName2, 0x40);
INCLUDE_BSS(PakuMotionName, 0x40);
INCLUDE_BSS(PakuMotionName2, 0x40);
INCLUDE_BSS(event_snd_buff, 0x8010);
INCLUDE_BSS(BuffEventSnd, 0x30);
INCLUDE_BSS(event_snd2_buff, 0x1410);
INCLUDE_BSS(BuffEventSnd2, 0x30);
INCLUDE_BSS(EventDngMap, 0x110);
INCLUDE_BSS(cmr_seq_tbl, 0x6000);
INCLUDE_BSS(CameraSeq, 0xB10);
INCLUDE_BSS(obj_seq_tbl, 0x5000);
INCLUDE_BSS(ObjectSeq, 0xBE00);
INCLUDE_BSS(EventSprite2, 0x1800);
INCLUDE_BSS(EventScriptArg, 0x10);
INCLUDE_BSS(EventScreenEffect, 0x50);
INCLUDE_BSS(ext_func__2, 0x1770);
