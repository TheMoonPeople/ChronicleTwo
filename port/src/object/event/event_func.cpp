#include "common.h"
#include "mw_runtime.h"

#include <libcdvd.h>

#include <array>
#include <cmath>
#include <cstddef>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <memory>
#include <optional>
#include <string>

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
#include "event_background.hpp"
#include "event_func.hpp"
#include "eventsprite.hpp"
#include "gaiji.hpp"
#include "gamedata.hpp"
#include "gamepad.hpp"
#include "gameutil.hpp"
#include "gyorace.hpp"
#include "intersection.hpp"
#include "inventmn.hpp"
#include "log/game_output.hpp"
#include "mainloop.hpp"
#include "mapinfo.hpp"
#include "mapjump.hpp"
#include "mapparts.hpp"
#include "mapselect.hpp"
#include "memory/tracked_copy.hpp"
#include "menuaqua.hpp"
#include "menuchr.hpp"
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
#include "pal_timing.hpp"
#include "pot.hpp"
#include "quest.hpp"
#include "runscript_opcodes.hpp"
#include "savedata.hpp"
#include "scenevillager.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include "sphida.hpp"
#include "subgame.hpp"
#include "swordeffect.hpp"
#include "sysmes.hpp"
#include "text/bounded.hpp"
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

/**
 *
 * Handler of one external event script command.
 *
 */
using EventFunc = dc2::script::RunFunction;

/**
 *
 * Argument script whose external commands are being executed.
 *
 */
static CEventScriptArg *nowScriptArg;

/**
 *
 * Dispatch slots for event script external commands.
 *
 */
static EventFunc ext_func[EVENT_EXT_FUNC_NUM];

/**
 *
 * Effect script manager controlled by the event script.
 *
 */
static dc2::memory::ArenaBuffer event_effect_script_storage;

namespace {
/**
 *
 * Owns the arena descriptor used by the event effect script manager.
 *
 */
std::unique_ptr<mgCMemory> event_effect_heap;

/**
 *
 * Returns the event effect manager only while its exact controller allocation is live.
 *
 */
CEffectScriptMan *GetEventEffectScript() {
    const auto bytes = event_effect_script_storage.Bytes();
    if (bytes.size() != sizeof(CEffectScriptMan) ||
        (event_effect_heap && !dc2::memory::ArenaStorageLive(*event_effect_heap))) {
        event_effect_script_storage = {};
        event_effect_heap.reset();
        return nullptr;
    }
    return reinterpret_cast<CEffectScriptMan *>(bytes.data());
}

/**
 *
 * Releases running programs before discarding a live event effect manager.
 *
 */
void ResetEventEffectScript() {
    if (auto *manager = GetEventEffectScript()) {
        manager->AllClearEffSpt();
    }
    event_effect_script_storage = {};
    event_effect_heap.reset();
}

/**
 *
 * Completes the item selection only while its script-owned result remains alive.
 *
 */
dc2::script::DeferredIntegerWriter use_item_result;

/**
 *
 * Gives the checked quadword extent required by one captured game screen.
 *
 */
std::optional<int> ScreenCaptureQuadwords() {
    if (mgScreenWidth <= 0 || mgScreenHeight <= 0 || mgScreenDepth <= 0) {
        return std::nullopt;
    }
    const auto width = static_cast<std::size_t>(mgScreenWidth);
    const auto height = static_cast<std::size_t>(mgScreenHeight);
    const auto depth = static_cast<std::size_t>(std::max(mgScreenDepth, 32));
    const auto limit = std::numeric_limits<std::size_t>::max();
    if (width > limit / height || width * height > (limit - 127) / depth) {
        return std::nullopt;
    }
    const auto count = (width * height * depth + 127) / 128;
    if (count >= static_cast<std::size_t>(std::numeric_limits<int>::max())) {
        return std::nullopt;
    }
    return static_cast<int>(count);
}

/**
 *
 * Returns a capture image only while its allocation and RGBA texture extent remain valid.
 *
 */
std::span<u8> CaptureStorage(const mgCTexture *texture, const dc2::memory::ArenaBuffer &image) {
    const auto bytes = image.Bytes();
    if (bytes.empty() || texture == nullptr || texture->width <= 0 || texture->height <= 0 ||
        texture->bpp != 32 || reinterpret_cast<std::uintptr_t>(bytes.data()) % alignof(u_long128) != 0) {
        return {};
    }
    const auto count = static_cast<std::size_t>(texture->width) * static_cast<std::size_t>(texture->height);
    if (count > bytes.size() / 4) {
        return {};
    }
    return bytes.first(count * 4);
}

/**
 *
 * Resolves a capture image only while the texture still names its live backing storage.
 *
 */
std::span<u8> LiveCaptureImage(const mgCTexture *texture, const dc2::memory::ArenaBuffer &image) {
    const auto bytes = CaptureStorage(texture, image);
    return !bytes.empty() && texture->image[0] == reinterpret_cast<u_long128 *>(bytes.data()) ? bytes : std::span<u8>{};
}

} // namespace

/**
 *
 * Sword trail effect controlled by the event script.
 *
 */
namespace {
dc2::memory::ArenaBuffer sword_effect_storage;

/**
 *
 * Borrows the event trail only while its exact controller allocation remains live.
 *
 */
CSWordAfterImage *GetSwordEffect() {
    const auto bytes = sword_effect_storage.Bytes();
    if (bytes.size() != sizeof(CSWordAfterImage)) {
        return nullptr;
    }
    return reinterpret_cast<CSWordAfterImage *>(bytes.data());
}
} // namespace

static void GetStackVector(float *vector, dc2::script::RunArguments stack);

static CCameraControl *GetCamera();
static CCharacter2    *GetChara(int id);
static CSceneObjSeq   *GetObjSeq(int index);
static CEventSprite2  *GetEventSprite(int index);
ClsMes                *GetMes(int id);

/**
 *
 * Storage for secondary event sound banks.
 *
 */
static u_long128 event_snd2_buff[EVENT_SND2_BUFFER_SIZE];

/**
 *
 * Storage for event sound banks.
 *
 */
static u_long128 event_snd_buff[EVENT_SND_BUFFER_SIZE];

CEoh::CEoh() {
    type = EOH_TYPE_NONE;
    scene_no = -1;
    world_coord = 1;
    chara = nullptr;
    object = nullptr;
    sprite = nullptr;
    frame = nullptr;
    func_point = nullptr;
}

int CEoh::Set(int new_kind, CObject *new_object, int new_flag) {
    if (new_object == nullptr) {
        return false;
    }

    type = new_kind;

    if (type != EOH_TYPE_OBJECT) {
        return false;
    }

    object = new_object;
    world_coord = new_flag;
    return true;
}

int CEoh::Set(int new_kind, int new_chara_no, CCharacter2 *new_chara) {
    if (new_chara == nullptr) {
        return false;
    }

    type = new_kind;

    switch (type) {
        case EOH_TYPE_CHARA:
            scene_no = new_chara_no;
            chara = new_chara;
            return true;
        default:
            return false;
    }
}

int CEoh::Set(int new_kind, CEventSprite2 *new_sprite) {
    if (new_sprite == nullptr) {
        return false;
    }

    type = new_kind;

    switch (type) {
        case EOH_TYPE_SPRITE:
            sprite = new_sprite;
            return true;
        default:
            return false;
    }
}

int CEoh::Set(int new_kind, mgCFrame *new_frame) {
    if (new_frame == nullptr) {
        return false;
    }

    type = new_kind;

    switch (type) {
        case EOH_TYPE_FRAME:
            frame = new_frame;
            return true;
        default:
            return false;
    }
}

int CEoh::Set(int new_kind, CFuncPoint *new_func_point) {
    if (new_func_point == nullptr) {
        return false;
    }

    type = new_kind;

    switch (type) {
        case EOH_TYPE_FUNC_POINT:
            func_point = new_func_point;
            break;
        default:
            return false;
    }

    return true;
}

void VectMatMul(float *out, float *vec, float (*matrix)[4]) {
    float result[4];

    result[0] = vec[0] * matrix[0][0] + vec[1] * matrix[1][0] + vec[2] * matrix[2][0];
    result[1] = vec[0] * matrix[0][1] + vec[1] * matrix[1][1] + vec[2] * matrix[2][1];
    result[2] = vec[0] * matrix[0][2] + vec[1] * matrix[1][2] + vec[2] * matrix[2][2];
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

    if ((SetWorldCoordFlg != 0) && (camera != nullptr)) {
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

    if ((SetWorldCoordFlg != 0) && (camera != nullptr)) {
        camera->GetPos(pos);
        camera->GetRef(ref);
        CalcPosWorldCoordGyaku(pos);
        CalcPosWorldCoordGyaku(ref);
        camera->SetPos(pos);
        camera->SetRef(ref);
    }
}

CEohMother::CEohMother() {
    int i = {};

    for (i = 0; i < EOH_NUM; i++) {
        CEoh *handle = &eoh[i];
        handle->type = EOH_TYPE_NONE;
        handle->scene_no = -1;
        handle->world_coord = 1;

        handle->object = nullptr;
        handle->chara = nullptr;
        handle->sprite = nullptr;
        handle->frame = nullptr;
        handle->func_point = nullptr;
    }
}

int CEohMother::Set(int slot, int kind, CObject *object, int flag) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    return eoh[slot].Set(EOH_TYPE_OBJECT, object, flag);
}

int CEohMother::Set(int slot, int kind, int chara_no, CCharacter2 *chara) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    return eoh[slot].Set(kind, chara_no, chara);
}

int CEohMother::Set(int slot, int kind, CEventSprite2 *sprite) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    return eoh[slot].Set(kind, sprite);
}

int CEohMother::Set(int slot, int kind, mgCFrame *frame) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    return eoh[slot].Set(kind, frame);
}

int CEohMother::Set(int slot, int kind, CFuncPoint *func_point) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    return eoh[slot].Set(kind, func_point);
}

int CEohMother::SetPos(int slot, float x, float y, float z) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
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
            mgCObject *chara = eoh[slot].chara;

            if (chara == nullptr) {
                return false;
            }

            chara->SetPosition(x, y, z);
            return true;
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

            if (object == nullptr) {
                return false;
            }

            object->SetPosition(x, y, z);
            return true;
        }
        case EOH_TYPE_SPRITE: {
            float  pos[4];
            float *pos_y = &pos[1];
            pos[0] = x;
            *pos_y = y;
            pos[2] = z;
            pos[3] = 1.0f;
            CEventSprite2 *&sprite = handle->sprite;

            if (sprite == nullptr) {
                return false;
            }

            if (sprite->GetType() == EVENT_SPRITE2_TYPE_SCREEN) {
                *pos_y += 32.0f;
                sprite->SetPosition(pos);
            } else if (sprite->GetType() == EVENT_SPRITE2_TYPE_WORLD) {
                CalcPosWorldCoord(pos);
                sprite->SetPosition(pos);
            }

            return true;
        }
        case EOH_TYPE_FRAME: {
            float pos[4];
            pos[0] = x;
            pos[1] = y;
            pos[2] = z;
            pos[3] = 1.0f;
            mgCObject *frame = handle->frame;

            if (frame == nullptr) {
                return false;
            }

            frame->SetPosition(pos);
            return true;
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

                if (func_point == nullptr) {
                    return false;
                }

                std::memmove(func_point->position, pos, sizeof(u_long128));
                func_point->frame.SetPosition(pos);
            }

            return true;
        }
        default:
            return false;
    }
}

int CEohMother::SetRot(int slot, float x, float y, float z) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *&chara = handle->chara;

            if (chara == nullptr) {
                return false;
            }

            x += EdEventInfo.world_coord_rot[0];
            y += EdEventInfo.world_coord_rot[1];
            z += EdEventInfo.world_coord_rot[2];
            y = mgAngleLimit(y);
            chara->SetRotation(x, y, z);
            return true;
        }
        case EOH_TYPE_OBJECT: {
            CObject *&object = handle->object;

            if (object == nullptr) {
                return false;
            }

            if (handle->world_coord != 0) {
                x += EdEventInfo.world_coord_rot[0];
                y += EdEventInfo.world_coord_rot[1];
                z += EdEventInfo.world_coord_rot[2];
                y = mgAngleLimit(y);
            }

            object->SetRotation(x, y, z);
            return true;
        }
        case EOH_TYPE_FRAME: {
            mgCObject *frame = handle->frame;

            if (frame == nullptr) {
                return false;
            }

            frame->SetRotation(x, y, z);
            return true;
        }
        case EOH_TYPE_SPRITE: {
            CEventSprite2 *sprite = handle->sprite;

            if (sprite == nullptr) {
                return false;
            }

            sprite->SetRotZ(z);
            return true;
        }
        case EOH_TYPE_FUNC_POINT: {
            CFuncPoint *&func_point = handle->func_point;

            if (func_point == nullptr) {
                return false;
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
            std::memmove(target->rotation, rot, sizeof(u_long128));
            target->frame.SetRotation(rot);
            return true;
        }
        default:
            return false;
    }
}

int CEohMother::GetPos(int slot, float *pos) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            mgCObject *chara = handle->chara;

            if (chara == nullptr) {
                return false;
            }

            chara->GetPosition(pos);
            CalcPosWorldCoordGyaku(pos);
            return true;
        }
        case EOH_TYPE_OBJECT: {
            mgCObject *object = handle->object;

            if (object == nullptr) {
                return false;
            }

            object->GetPosition(pos);

            if (eoh[slot].world_coord != 0) {
                CalcPosWorldCoordGyaku(pos);
            }

            return true;
        }
        case EOH_TYPE_SPRITE: {
            CEventSprite2 *&sprite = handle->sprite;

            if (sprite == nullptr) {
                return false;
            }

            sprite->GetPosition(pos);

            if (sprite->GetType() == EVENT_SPRITE2_TYPE_WORLD) {
                CalcPosWorldCoordGyaku(pos);
            } else {
                pos[1] -= 32.0f;
            }

            return true;
        }
        case EOH_TYPE_FRAME: {
            mgCObject *frame = handle->frame;

            if (frame == nullptr) {
                return false;
            }

            frame->GetPosition(pos);
            return true;
        }
        case EOH_TYPE_FUNC_POINT: {
            CFuncPoint *func_point = handle->func_point;

            if (func_point == nullptr) {
                return false;
            }

            std::memmove(pos, func_point->position, sizeof(u_long128));
            CalcPosWorldCoordGyaku(pos);
            return true;
        }
        default:
            return false;
    }
}

int CEohMother::GetRot(int slot, float *rot) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            mgCObject *chara = handle->chara;

            if (chara == nullptr) {
                return false;
            }

            chara->GetRotation(rot);
            rot[1] -= EdEventInfo.world_coord_rot[1];
            rot[1] = mgAngleLimit(rot[1]);
            return true;
        }
        case EOH_TYPE_OBJECT: {
            mgCObject *object = handle->object;

            if (object == nullptr) {
                return false;
            }

            object->GetRotation(rot);

            if (eoh[slot].world_coord != 0) {
                rot[1] -= EdEventInfo.world_coord_rot[1];
                rot[1] = mgAngleLimit(rot[1]);
            }

            return true;
        }
        case EOH_TYPE_FRAME: {
            mgCObject *frame = handle->frame;

            if (frame == nullptr) {
                return false;
            }

            frame->GetRotation(rot);
            return true;
        }
        case EOH_TYPE_SPRITE: {
            CEventSprite2 *&sprite = handle->sprite;

            if (sprite == nullptr) {
                return false;
            }

            rot[0] = 0.0f;
            rot[1] = 0.0f;
            rot[3] = 0.0f;
            rot[2] = sprite->GetRotZ();
            return true;
        }
        case EOH_TYPE_FUNC_POINT: {
            CFuncPoint *func_point = handle->func_point;

            if (func_point == nullptr) {
                return false;
            }

            std::memmove(rot, func_point->rotation, sizeof(u_long128));

            if (handle->world_coord != 0) {
                rot[1] -= EdEventInfo.world_coord_rot[1];
                rot[1] = mgAngleLimit(rot[1]);
            }

            return true;
        }
        default:
            return false;
    }
}

int CEohMother::SetMotion(int slot, char *name, int type, float blend) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 **held = &handle->chara;
            CCharacter2  *chara = *held;

            if (chara == nullptr) {
                return false;
            }

            chara->SetMotion(name, type);

            if (blend != -1.0f) {
                (*held)->NormalDrive();
                (*held)->SetStep(blend);
                chara = *held;
                chara->frame = static_cast<float>(chara->now_key->start_frame);
            }

            return true;
        }
        default:
            return false;
    }
}

int CEohMother::CheckMotionEnd(int slot) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == nullptr) {
                return false;
            }

            if (chara->seq_mode == 0) {
                return chara->CheckMotionEnd();
            }

            if (chara->seq_state == CHARA_SEQ_STATE_END) {
                return chara->CheckMotionEnd();
            }

            return false;
        }
        default:
            return false;
    }
}

int CEohMother::SetMotionTrg(int slot) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == nullptr) {
                return false;
            }

            if (chara->seq_mode != 1) {
                break;
            }

            chara->seq_advance = true;
            break;
        }
        default:
            return false;
    }

    return false;
}

int CEohMother::GetSeqStatus(int slot) {
    if (slot < 0 || slot >= EOH_NUM) {
        return CHARA_SEQ_STATE_NONE;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == nullptr) {
                return CHARA_SEQ_STATE_NONE;
            }

            if (chara->seq_mode == 1) {
                return chara->seq_state;
            }

            return CHARA_SEQ_STATE_NONE;
        }
    }

    return CHARA_SEQ_STATE_NONE;
}

int CEohMother::SetStep(int slot, float step) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == nullptr) {
                return false;
            }

            chara->SetStep(step);
            return true;
        }
        default:
            return false;
    }
}

int CEohMother::SetChangeStep(int slot, float step) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == nullptr) {
                return false;
            }

            chara->blend_speed = step;

            if (step >= 1.0f) {
                chara->blend = 1.0f;
            }

            break;
        }
        default:
            return false;
    }

    return true;
}

int CEohMother::ResetMotion(int slot) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == nullptr) {
                return false;
            }

            chara->ResetMotion();
            break;
        }
        default:
            return false;
    }

    return true;
}

int CEohMother::SetTexAnim(int slot, int on, char *name) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            int texb = EventScene->GetCharaTexb(handle->scene_no);

            if (texb < 0) {
                return false;
            }

            mgCTextureManager *manager = &mgTexManager;

            if (on != 0) {
                manager->TexAnimeOn(texb, name);
            } else if (name != nullptr) {
                manager->TexAnimeOff(texb, name);
            } else {
                manager->TexAnimeAllOff(texb);
            }

            return true;
        }
    }

    return false;
}

int CEohMother::SetScale(int slot, float x, float y, float z) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            mgCObject *chara = handle->chara;

            if (chara == nullptr) {
                return false;
            }

            chara->SetScale(x, y, z);
            return true;
        }
        case EOH_TYPE_OBJECT: {
            mgCObject *object = handle->object;

            if (object == nullptr) {
                return false;
            }

            object->SetScale(x, y, z);
            return true;
        }
        case EOH_TYPE_SPRITE:
            handle->sprite->SetScale(x, y);
            return true;
        case EOH_TYPE_FRAME:
            handle->frame->SetScale(x, y, z);
            return true;
        case EOH_TYPE_FUNC_POINT: {
            CFuncPoint *&func_point = handle->func_point;

            if (func_point == nullptr) {
                return false;
            }

            float scale[4];
            scale[0] = x;
            scale[1] = y;
            scale[2] = z;
            scale[3] = 1.0f;
            CFuncPoint *target = func_point;
            std::memmove(target->scale, scale, sizeof(u_long128));
            target->frame.SetScale(scale);
            return true;
        }
        default:
            return false;
    }
}

int CEohMother::GetScale(int slot, float *scale) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            mgCObject *chara = handle->chara;

            if (chara == nullptr) {
                return false;
            }

            chara->GetScale(scale);
            return true;
        }
        case EOH_TYPE_OBJECT: {
            mgCObject *object = handle->object;

            if (object == nullptr) {
                return false;
            }

            object->GetScale(scale);
            return true;
        }
        case EOH_TYPE_SPRITE: {
            CEventSprite2 *sprite = handle->sprite;

            if (sprite == nullptr) {
                return false;
            }

            float size_x = {};
            float size_y = {};
            sprite->GetScale(&size_x, &size_y);
            scale[0] = size_x;
            scale[1] = size_y;
            scale[2] = 0.0f;
            scale[3] = 0.0f;
            return true;
        }
        case EOH_TYPE_FUNC_POINT: {
            CFuncPoint *func_point = handle->func_point;

            if (func_point == nullptr) {
                return false;
            }

            std::memmove(scale, func_point->scale, sizeof(u_long128));
            return true;
        }
        default:
            return false;
    }
}

int CEohMother::SetShow(int slot, int show) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_OBJECT: {
            CObject *object = handle->object;

            if (object == nullptr) {
                return false;
            }

            object->Show(show);
            return true;
        }
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == nullptr) {
                return false;
            }

            chara->Show(show);
            return true;
        }
        case EOH_TYPE_FUNC_POINT:
            if (handle->func_point == nullptr) {
                return false;
            }

            handle->func_point->enable = show;
            return true;
        default:
            return false;
    }
}

int CEohMother::GetShow(int slot, int *show) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_OBJECT: {
            CObject *object = handle->object;

            if (object == nullptr) {
                return false;
            }

            *show = object->GetShow();
            return true;
        }
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == nullptr) {
                return false;
            }

            *show = chara->GetShow();
            return true;
        }
        case EOH_TYPE_FUNC_POINT:
            if (handle->func_point == nullptr) {
                return false;
            }

            *show = handle->func_point->enable;
            return true;
        default:
            return false;
    }
}

mgCFrame *CEohMother::SearchFrame(int slot, char *name) {
    if (slot < 0 || slot >= EOH_NUM) {
        return nullptr;
    }

    CEoh     *handle = &eoh[slot];
    mgCFrame *result = nullptr;

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == nullptr) {
                return nullptr;
            }

            result = chara->CObjectFrame::frame->SearchFrame(name);
            break;
        }
    }

    return result;
}

int CEohMother::SetFrameShow(int slot, char *name, int show) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == nullptr) {
                return false;
            }

            mgCFrame *frame = chara->CObjectFrame::frame->SearchFrame(name);

            if (frame == nullptr) {
                return false;
            }

            mgCFrameAttr *attr = frame->attr;

            if (attr == nullptr) {
                return false;
            }

            attr->draw = show;
            return true;
        }
        case EOH_TYPE_FRAME: {
            mgCFrame *frame = handle->frame;

            if (frame == nullptr) {
                return false;
            }

            mgCFrameAttr *attr = frame->attr;

            if (attr == nullptr) {
                return false;
            }

            attr->draw = show;
            return true;
        }
    }

    return false;
}

int CEohMother::SetShadow(int slot, int enable) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA:
            if (enable != 0) {
                EventScene->ResetStatus(SCENE_DATA_CHARA, handle->scene_no, SCENE_CHARA_NO_SHADOW);
            } else {
                EventScene->SetStatus(SCENE_DATA_CHARA, handle->scene_no, SCENE_CHARA_NO_SHADOW);
            }

            return true;
    }

    return false;
}

int CEohMother::SetShadowFrameShow(int slot, char *name, int show) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == nullptr) {
                return false;
            }

            mgCFrame *shadow = chara->shadow_frame;

            if (shadow == nullptr) {
                return false;
            }

            mgCFrame *frame = shadow->SearchFrame(name);

            if (frame == nullptr) {
                return false;
            }

            mgCFrameAttr *attr = frame->attr;

            if (attr == nullptr) {
                return false;
            }

            attr->draw = show;
            return true;
        }
    }

    return false;
}

int CEohMother::SetTranslate(int slot, float *pos) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == nullptr) {
                return false;
            }

            mgCFrame *frame = chara->CObjectFrame::frame;

            if (frame == nullptr) {
                return false;
            }

            frame->trans_matrix[3][0] = pos[0];
            frame->trans_matrix[3][1] = pos[1];
            frame->trans_matrix[3][2] = pos[2];
            frame->changed = 1;
            return true;
        }
        case EOH_TYPE_FRAME: {
            mgCFrame *frame = handle->frame;

            if (frame == nullptr) {
                return false;
            }

            frame->trans_matrix[3][0] = pos[0];
            frame->trans_matrix[3][1] = pos[1];
            frame->trans_matrix[3][2] = pos[2];
            frame->changed = 1;
            return true;
        }
    }

    return false;
}

int CEohMother::SetColor(int slot, float *color) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_SPRITE: {
            CEventSprite2 *sprite = handle->sprite;

            if (sprite == nullptr) {
                return false;
            }

            sprite->SetColor(color);
            return true;
        }
    }

    return false;
}

int CEohMother::GetColor(int slot, float *color) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_SPRITE: {
            CEventSprite2 *sprite = handle->sprite;

            if (sprite == nullptr) {
                return false;
            }

            sprite->GetColor(color);
            return true;
        }
    }

    return false;
}

char *CEohMother::GetNowMotionName(int slot) {
    if (slot < 0 || slot >= EOH_NUM) {
        return nullptr;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara != nullptr) {
                return chara->GetNowMotionName();
            }

            return nullptr;
        }
    }

    return nullptr;
}

int CEohMother::GetNowMotionStatus(int slot) {
    if (slot < 0 || slot >= EOH_NUM) {
        return CHARA_MOTION_STATUS_NONE;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara != nullptr) {
                return chara->GetMotionStatus();
            }

            return CHARA_MOTION_STATUS_NONE;
        }
    }

    return CHARA_MOTION_STATUS_NONE;
}

int CEohMother::SetMotionNowTime(int slot, float time) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 **held = &handle->chara;
            CCharacter2  *chara = *held;

            if (chara == nullptr) {
                return false;
            }

            CHRINFO_KEY_SET *motion = chara->now_key;

            if (motion != nullptr) {
                float now = time + static_cast<float>(motion->start_frame);

                if (!(now < static_cast<float>(motion->end_frame))) {
                    return false;
                }

                chara->frame = now;
                (*held)->NormalDrive();
                (*held)->frame = now;
            } else {
                return false;
            }

            return true;
        }
        default:
            return false;
    }
}

int CEohMother::SetMotionWaitTime(int slot, float rate) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 **held = &handle->chara;
            CCharacter2  *chara = *held;

            if (chara == nullptr) {
                return false;
            }

            CHRINFO_KEY_SET *motion = chara->now_key;

            if (motion != nullptr) {
                float length = static_cast<float>(motion->end_frame - motion->start_frame);
                length *= rate;
                chara->frame = length + static_cast<float>(motion->start_frame);
                (*held)->NormalDrive();
                chara = *held;
                chara->frame = length + static_cast<float>(chara->now_key->start_frame);
            }

            return true;
        }
        default:
            return false;
    }
}

int CEohMother::SetFootSoundID(int slot, int sound_id) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == nullptr) {
                return false;
            }

            chara->sound_info.foot_sound_id = sound_id;
            return true;
        }
    }

    return false;
}

int CEohMother::GetFramePos(int slot, char *name, float *pos) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == nullptr) {
                return false;
            }

            if (chara->CObjectFrame::frame == nullptr) {
                return false;
            }

            mgCFrame *frame = chara->CObjectFrame::frame->SearchFrame(name);

            if (frame == nullptr) {
                return false;
            }

            frame->GetWorldPosition0(pos);
            CalcPosWorldCoordGyaku(pos);
            return true;
        }
    }

    return false;
}

int CEohMother::SetSoundID(int slot, u32 sound_id) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == nullptr) {
                return false;
            }

            chara->sound_info.se_bank = sound_id;
            return true;
        }
    }

    return false;
}

int CEohMother::GetFrameShow(int slot, char *name) {
    if (slot < 0 || slot >= EOH_NUM) {
        return 0;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == nullptr) {
                return 0;
            }

            mgCFrame *frame = chara->CObjectFrame::frame->SearchFrame(name);

            if (frame == nullptr) {
                return 0;
            }

            mgCFrameAttr *attr = frame->attr;

            if (attr != nullptr) {
                return attr->draw;
            }

            return 0;
        }
        case EOH_TYPE_FRAME: {
            mgCFrame *frame = handle->frame;

            if (frame == nullptr) {
                return 0;
            }

            mgCFrameAttr *attr = frame->attr;

            if (attr != nullptr) {
                return attr->draw;
            }

            return 0;
        }
    }

    return 0;
}

int CEohMother::SetFadeFlag(int slot, int flag) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == nullptr) {
                return false;
            }

            chara->SetFadeFlag(flag);
            return true;
        }
        default:
            return false;
    }
}

int CEohMother::ResetDAPosition(int slot) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 **chara = &handle->chara;

            if (*chara == nullptr) {
                return false;
            }

            (*chara)->ResetDAPosition();
            (*chara)->StepDA(10);
            return true;
        }
    }

    return false;
}

int CEohMother::NormalDrive(int slot) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == nullptr) {
                return false;
            }

            chara->NormalDrive();
            break;
        }
        default:
            return false;
    }

    return true;
}

int CEohMother::UpdatePosition(int slot) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == nullptr) {
                return false;
            }

            chara->UpdatePosition();
            break;
        }
        default:
            return false;
    }

    return true;
}

int CEohMother::SetFrameObjAlpha(int slot, char *name, float alpha) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == nullptr) {
                return false;
            }

            if (chara->CObjectFrame::frame == nullptr) {
                return false;
            }

            mgCFrame *frame = chara->CObjectFrame::frame->SearchFrame(name);

            if (frame == nullptr) {
                return false;
            }

            frame->SetAttrParamObjAlpha(alpha, 1);
            return true;
        }
        case EOH_TYPE_FRAME: {
            mgCFrame *root = handle->frame;

            if (root == nullptr) {
                return false;
            }

            mgCFrame *frame = root->SearchFrame(name);

            if (frame == nullptr) {
                return false;
            }

            mgCFrameAttr *attr = frame->attr;

            if (attr == nullptr) {
                return false;
            }

            attr->obj_alpha = alpha;
            return true;
        }
    }

    return false;
}

int CEohMother::SetFootSeId(int slot, int se_bank) {
    if (slot < 0 || slot >= EOH_NUM) {
        return false;
    }

    CEoh *handle = &eoh[slot];

    switch (handle->type) {
        case EOH_TYPE_CHARA: {
            CCharacter2 *chara = handle->chara;

            if (chara == nullptr) {
                return false;
            }

            chara->sound_info.foot_se_bank = se_bank;
            break;
        }
        default:
            return false;
    }

    return true;
}

void FileNameConvLanguage(char *name);

/**
 *
 * Reads a three-component vector only after validating every argument.
 *
 */
static void GetStackVector(float *vector, dc2::script::RunArguments stack) {
    const float x = dc2::script::RunFloat(stack++);
    const float y = dc2::script::RunFloat(stack++);
    const float z = dc2::script::RunFloat(stack);
    vector[0] = x;
    vector[1] = y;
    vector[2] = z;
    vector[3] = 1.0f;
}

/**
 *
 * Stores an integer through a validated live output reference.
 *
 */
static void SetStack(dc2::script::RunArguments stack, int value) {
    dc2::script::RunOutput(stack).val.i = value;
}

/**
 *
 * Stores a float through a validated live output reference.
 *
 */
static void SetStack(dc2::script::RunArguments stack, float value) {
    dc2::script::RunOutput(stack).val.f = value;
}

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
 * Records the argument entries supplied by an argument script.
 *
 */
static int _DATA(dc2::script::RunArguments stack, int argc);

/**
 *
 * Sets the next argument-list identifier supplied by an argument script.
 *
 */
static int _ID_OFFSET(dc2::script::RunArguments stack, int argc);

/**
 *
 * External handlers available to event argument scripts.
 *
 */
static RS_EXTFUNC_INFO esa_ext_func_info[3] = {
    {dc2::script::AdaptRunArguments<_DATA>,      EVENT_ARG_DATA     },
    {dc2::script::AdaptRunArguments<_ID_OFFSET>, EVENT_ARG_ID_OFFSET},
    {nullptr,                                    EVENT_ARG_DATA     },
};

/**
 *
 * Reserves event storage only when the complete native allocation fits a live writable arena.
 *
 */
static u_long128 *AllocateEventStorage(mgCMemory *memory, std::size_t words) {
    if (memory == nullptr || memory->lock != 0 || words == 0 ||
        words > static_cast<std::size_t>(std::numeric_limits<int>::max()) ||
        dc2::memory::RemainingBytes(*memory).size() / sizeof(u_long128) <= words) {
        return nullptr;
    }
    return memory->Alloc(static_cast<int>(words));
}

/**
 *
 * Discards list links whose originating allocation has retired before an append.
 *
 */
static bool PrepareEventArgLists(CEventScriptArg &script) {
    if (script.memory == nullptr || script.next_id == std::numeric_limits<int>::max() ||
        script.list_num < 0 || script.list_num == std::numeric_limits<int>::max()) {
        return false;
    }
    if (script.list_num > 0) {
        const auto head = script.list_storage.Bytes();
        if (head.size() != sizeof(ARG_LIST) || head.data() != reinterpret_cast<u8 *>(script.list)) {
            script.list = nullptr;
            script.list_num = 0;
            script.list_storage = {};
        }
    }
    return true;
}

/**
 *
 * Appends a new argument list to the script and returns it, or NULL when the script has no memory.
 *
 */
static inline ARG_LIST *ScriptArgAddList(CEventScriptArg *script) {
    if (!PrepareEventArgLists(*script)) {
        return nullptr;
    }

    auto     *storage = AllocateEventStorage(script->memory, 3);
    ARG_LIST *created = storage != nullptr ? new (storage) ARG_LIST : nullptr;

    if (created == nullptr) {
        return nullptr;
    }

    created->id = script->next_id;
    created->args = nullptr;
    created->arg_num = 0;
    created->next = nullptr;

    if (script->list_num <= 0) {
        script->list = created;
        script->list_storage = dc2::memory::ArenaBuffer::Bind(*script->memory,
                                                              {reinterpret_cast<u8 *>(created), sizeof(*created)});
    } else {
        ARG_LIST *last = script->list;

        while (last->next != nullptr) {
            last = last->next;
        }

        last->next = created;
    }

    script->next_id++;
    script->list_num++;
    return created;
}

/**
 *
 * Allocates an array of argument data in the script's memory into out, or NULL when the script has no memory.
 *
 */
static inline void ScriptArgNewData(CEventScriptArg *script, int num, ARG_DATA **out) {
    if (script->memory == nullptr) {
        *out = nullptr;
    } else {
        const auto words = num > 0 ? dc2::memory::ArrayQuadwords<ARG_DATA>(static_cast<std::size_t>(num)) : std::nullopt;
        if (num < 0 || (num > 0 && !words) || (words && *words > std::numeric_limits<int>::max() - 2)) {
            *out = nullptr;
            return;
        }
        auto *storage = AllocateEventStorage(script->memory, static_cast<std::size_t>(words.value_or(0)) + 2);
        *out = storage != nullptr ? new (storage) ARG_DATA[num]{} : nullptr;
    }
}

/**
 *
 * Copies a string into the script's memory and returns the copy, or NULL when the script has no memory.
 *
 */
static inline char *ScriptArgNewString(CEventScriptArg *script, char *source) {
    char *copy = {};

    if (script->memory == nullptr || source == nullptr) {
        copy = nullptr;
    } else {
        const std::size_t length = std::strlen(source) + 1;
        const std::size_t blocks = (length + 15) / 16 + 2;
        copy = reinterpret_cast<char *>(AllocateEventStorage(script->memory, blocks));
        if (copy != nullptr) {
            std::memcpy(copy, source, length);
        }
    }

    return copy;
}

static int _DATA(dc2::script::RunArguments stack, int argc) {
    char            *source = {};
    CEventScriptArg *script = nowScriptArg;

    if (script == nullptr || script->memory == nullptr || argc < 0 || argc >= EVENT_ARG_STACK_NUM) {
        return false;
    }

    if (script->memory->stGetRest() <= 5) {
        return false;
    }
    const auto remaining = static_cast<std::size_t>(script->memory->stGetRest());
    const auto arg_count = static_cast<std::size_t>(argc);
    if (remaining <= 5 || arg_count > (remaining - 5) * 16 / sizeof(ARG_DATA)) {
        return false;
    }

    std::size_t required_blocks = 3 + (arg_count * sizeof(ARG_DATA) + 15) / 16 + 2;
    if (required_blocks >= remaining) {
        return false;
    }
    for (int i = 0; i < argc; ++i) {
        const auto argument = stack + static_cast<std::size_t>(i);
        switch (argument.At().type) {
            case RS_INT:
                static_cast<void>(dc2::script::RunInteger(argument));
                continue;
            case RS_FLOAT:
                static_cast<void>(dc2::script::RunFloat(argument));
                continue;
            case RS_STR:
                break;
            default:
                return false;
        }
        const char *source = dc2::script::RunCString(stack + static_cast<std::size_t>(i));
        if (source == nullptr) {
            return false;
        }
        const std::size_t length = std::strlen(source);
        if (length >= (remaining - required_blocks) * 16) {
            return false;
        }
        const std::size_t blocks = (length + 1 + 15) / 16 + 2;
        if (blocks >= remaining - required_blocks) {
            return false;
        }
        required_blocks += blocks;
    }
    if (required_blocks >= remaining) {
        return false;
    }

    ARG_LIST *node = ScriptArgAddList(script);

    if (node == nullptr) {
        return false;
    }

    ARG_DATA *args __attribute__((aligned(16))) = {};
    ScriptArgNewData(nowScriptArg, argc, &args);

    if (args == nullptr) {
        return false;
    }

    node->args = args;
    node->arg_num = argc;

    for (int i = 0; i < argc; i++) {
        args[i].type = stack.At().type;

        switch (stack.At().type) {
            case RS_INT:
                args[i].i = dc2::script::RunInteger(stack++);
                break;
            case RS_FLOAT:
                args[i].f = dc2::script::RunFloat(stack++);
                break;
            case RS_STR:
                source = dc2::script::RunCString(stack++);
                args[i].s = ScriptArgNewString(nowScriptArg, source);
                if (args[i].s == nullptr) {
                    return false;
                }
                break;
            default:
                args[i].s = nullptr;
                break;
        }
    }

    return true;
}

static int _ID_OFFSET(dc2::script::RunArguments stack, int arg_count) {
    if (nowScriptArg == nullptr) {
        return false;
    }

    nowScriptArg->next_id = dc2::script::RunInteger(stack);
    return true;
}

int GetArgInt(dc2::script::EventArguments arg) {
    const ARG_DATA &value = arg.At();
    if (value.type == RS_INT) {
        return value.i;
    }
    if (value.type == RS_FLOAT) {
        const double number = value.f;
        if (std::isfinite(number) && number >= std::numeric_limits<int>::min() &&
            number < static_cast<double>(std::numeric_limits<int>::max()) + 1.0) {
            return static_cast<int>(number);
        }
    }
    throw dc2::script::ArgumentError("event argument is not a finite integer");
}

float GetArgFloat(dc2::script::EventArguments arg) {
    const ARG_DATA &value = arg.At();
    if (value.type == RS_INT) {
        return static_cast<float>(value.i);
    }
    if (value.type == RS_FLOAT && std::isfinite(value.f)) {
        return value.f;
    }
    throw dc2::script::ArgumentError("event argument is not a finite number");
}

char *GetArgString(dc2::script::EventArguments arg) {
    const ARG_DATA &value = arg.At();
    if (value.type != RS_STR || EventScriptArg.memory == nullptr) {
        throw dc2::script::ArgumentError("event argument is not text");
    }
    const auto source = dc2::memory::AllocationBytes(*EventScriptArg.memory, value.s);
    const auto bytes = std::span(reinterpret_cast<char *>(source.data()), source.size());
    return dc2::script::EventArguments({}, bytes).CString(value.s);
}

void GetArgVector(float *vec, dc2::script::EventArguments arg) {
    const float x = GetArgFloat(arg++);
    const float y = GetArgFloat(arg++);
    const float z = GetArgFloat(arg);
    vec[0] = x;
    vec[1] = y;
    vec[2] = z;
    vec[3] = 1.0f;
}

/**
 *
 * Finds a live event argument list and validates its full declared extent.
 *
 */
static dc2::script::EventArguments FindArgData(int key, int &arg_num) {
    const auto empty = dc2::script::EventArguments(std::span<ARG_DATA>());
    const auto head = EventScriptArg.list_storage.Bytes();
    if (EventScriptArg.memory == nullptr || EventScriptArg.list_num <= 0 || head.size() != sizeof(ARG_LIST) ||
        head.data() != reinterpret_cast<u8 *>(EventScriptArg.list)) {
        return empty;
    }
    ARG_LIST *node = EventScriptArg.list;
    for (int index = 0; index < EventScriptArg.list_num && node != nullptr; ++index) {
        if (reinterpret_cast<std::uintptr_t>(node) % alignof(ARG_LIST) != 0 ||
            dc2::memory::AllocationBytes(*EventScriptArg.memory, node).size() < sizeof(ARG_LIST)) {
            throw dc2::script::ArgumentError("event argument list is outside its live allocation");
        }
        if (node->id == key) {
            const auto storage = dc2::memory::AllocationBytes(*EventScriptArg.memory, node->args);
            if (node->arg_num < 0 || static_cast<std::size_t>(node->arg_num) > storage.size() / sizeof(ARG_DATA) ||
                (node->arg_num > 0 && reinterpret_cast<std::uintptr_t>(node->args) % alignof(ARG_DATA) != 0)) {
                throw dc2::script::ArgumentError("event arguments exceed their live allocation");
            }
            arg_num = node->arg_num;
            return dc2::script::EventArguments(std::span(node->args, static_cast<std::size_t>(node->arg_num)));
        }
        node = node->next;
    }
    return empty;
}

/**
 *
 * Finds the bounded arguments retained under an event argument list identifier.
 *
 */
static dc2::script::EventArguments FindArgData(int key) {
    int count = 0;
    return FindArgData(key, count);
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

void CRaster::StartRaster(float target_amplitude, float target_speed, float target_pitch, int frames) {
    this->frames = frames;
    frame = 0;

    if (this->frames > 1) {
        state = RASTER_START;

        if (target_amplitude != -1.0f) {
            amplitude_step = (target_amplitude - amplitude) / static_cast<float>(this->frames);
        } else {
            amplitude_step = 0.0f;
        }

        if (target_speed != -1.0f) {
            speed_step = (target_speed - speed) / static_cast<float>(this->frames);
        } else {
            speed_step = 0.0f;
        }

        if (target_pitch != -1.0f) {
            pitch_step = (target_pitch - pitch) / static_cast<float>(this->frames);
            return;
        }

        pitch_step = 0.0f;
        return;
    }

    if (target_amplitude != -1.0f) {
        amplitude = target_amplitude;
    }

    if (target_speed != -1.0f) {
        speed = target_speed;
    }

    if (target_pitch != -1.0f) {
        pitch = target_pitch;
    }

    state = RASTER_ON;
}

void CRaster::StopRaster(float target_amplitude, float target_speed, float target_pitch, int frames) {
    this->frames = frames;
    frame = 0;

    if (this->frames > 1) {
        state = RASTER_STOP;

        if (target_amplitude != -1.0f) {
            amplitude_step = (target_amplitude - amplitude) / static_cast<float>(this->frames);
        } else {
            amplitude_step = 0.0f;
        }

        if (target_speed != -1.0f) {
            speed_step = (target_speed - speed) / static_cast<float>(this->frames);
        } else {
            speed_step = 0.0f;
        }

        if (target_pitch != -1.0f) {
            pitch_step = (target_pitch - pitch) / static_cast<float>(this->frames);
            return;
        }

        pitch_step = 0.0f;
        return;
    }

    if (target_amplitude != -1.0f) {
        amplitude = target_amplitude;
    }

    if (target_speed != -1.0f) {
        speed = target_speed;
    }

    if (target_pitch != -1.0f) {
        pitch = target_pitch;
    }

    state = RASTER_OFF;
}

void CRaster::StepRaster() {
    switch (state) {
        case RASTER_START:
        case RASTER_STOP:
            amplitude += amplitude_step;

            if (amplitude < 0.0f) {
                amplitude = 0.0f;
            }

            speed += speed_step;

            if (speed > PI) {
                speed = PI;
            }

            if (speed < 0.0f) {
                speed = 0.0f;
            }

            pitch += pitch_step;

            if (pitch > PI) {
                pitch = PI;
            }

            if (pitch < 0.0f) {
                pitch = 0.0f;
            }

            frame++;

            if (frame >= this->frames) {
                frame = 0;
                this->frames = -1;

                if (state == RASTER_START) {
                    state = RASTER_ON;
                }

                if (state == RASTER_STOP) {
                    state = RASTER_OFF;
                }
            }

            break;
        case RASTER_ON:
        case RASTER_OFF:
            break;
    }
}

void CRaster::DrawRaster() {
    int   width = {};
    int   y = {};
    float shift = {};
    float current_phase = {};
    float next_y = {};

    if (state != RASTER_OFF) {
        mgCTexture screen;

        mgGetFrameBuffer(&screen);
        mgCDrawPrim prim;
        prim.Initialize(nullptr, nullptr);
        prim.DepthTestEnable(0);
        prim.AlphaTestEnable(0);
        prim.AlphaBlendEnable(0);
        prim.ZMask(MG_Z_MASK_MASKED);
        prim.TextureMapEnable(1);
        current_phase = phase;
        prim.Begin(MG_PRIM_SPRITE);
        prim.Texture(&screen);
        prim.Color(0x80, 0x80, 0x80, 0x80);

        for (y = 0; y < mgScreenHeight; y++) {
            shift = amplitude * sinf(current_phase);
            prim.TextureCrd(0, y);
            prim.Vertex(shift, static_cast<float>(y), 0.0f);
            prim.TextureCrd(mgScreenWidth, y + 1);
            prim.Vertex(shift + static_cast<float>(mgScreenWidth), next_y = 1.0f + static_cast<float>(y), 0.0f);

            if (shift != 0.0f) {
                if (!(shift <= 0.0f)) {
                    width = mgScreenWidth;
                    prim.TextureCrd(width - fptosi(shift), y);
                    prim.Vertex(0.0f, static_cast<float>(y), 0.0f);
                    prim.TextureCrd(mgScreenWidth, y + 1);
                    prim.Vertex(shift, next_y, 0.0f);
                } else {
                    prim.TextureCrd(0, y);
                    prim.Vertex(static_cast<float>(mgScreenWidth) + shift, static_cast<float>(y), 0.0f);
                    prim.TextureCrd(fptosi(-shift), y + 1);
                    prim.Vertex(static_cast<float>(mgScreenWidth), next_y, 0.0f);
                }
            }

            current_phase += pitch;
            current_phase = mgAngleLimit(current_phase);
        }

        prim.End();
        phase += speed;
        phase = mgAngleLimit(phase);
    }
}

void CScreenEffect::Initialize() {
    raster.Initialize();
    sepia_texture = nullptr;
    sepia_image = {};
    sepia = 0;
    mono_flash_texture[0] = nullptr;
    mono_flash_texture[1] = nullptr;
    mono_flash_image = {};
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

    if (sepia != 0 && !LiveCaptureImage(sepia_texture, sepia_image).empty()) {
        manager->ReloadTexture(sepia_texture->block, (sceVif1Packet *) nullptr);
        mgCDrawPrim sepia_prim;
        sepia_prim.Initialize(nullptr, nullptr);
        sepia_prim.DepthTestEnable(0);
        sepia_prim.AlphaTestEnable(0);
        sepia_prim.AlphaBlendEnable(0);
        sepia_prim.ZMask(MG_Z_MASK_MASKED);
        sepia_prim.TextureMapEnable(1);
        sepia_prim.Begin(MG_PRIM_SPRITE);
        sepia_prim.Texture(sepia_texture);
        sepia_prim.Color(0x80, 0x80, 0x80, 0x80);
        sepia_prim.TextureCrd(0, 0);
        sepia_prim.Vertex(-1, -1, 0);
        sepia_prim.TextureCrd(mgScreenWidth, mgScreenHeight);
        sepia_prim.Vertex(mgScreenWidth, mgScreenHeight, 0);
        sepia_prim.End();
    }

    if (mono_flash != 0) {
        if (!LiveCaptureImage(mono_flash_texture[0], mono_flash_image[0]).empty() &&
            !LiveCaptureImage(mono_flash_texture[1], mono_flash_image[1]).empty()) {
            manager->ReloadTexture(mono_flash_texture[mono_flash_no]->block, (sceVif1Packet *) nullptr);
            mgCDrawPrim flash;
            flash.Initialize(nullptr, nullptr);
            flash.DepthTestEnable(0);
            flash.AlphaTestEnable(0);
            flash.AlphaBlendEnable(0);
            flash.ZMask(MG_Z_MASK_MASKED);
            flash.TextureMapEnable(1);
            flash.Begin(MG_PRIM_SPRITE);
            flash.Texture(mono_flash_texture[mono_flash_no]);
            flash.Color(0x80, 0x80, 0x80, 0x80);
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

void CScreenEffect::StartRaster(float target_amplitude, float target_speed, float target_pitch, int frames) {
    raster.StartRaster(target_amplitude, target_speed, target_pitch, frames);
}

void CScreenEffect::StopRaster(float target_amplitude, float target_speed, float target_pitch, int frames) {
    raster.StopRaster(target_amplitude, target_speed, target_pitch, frames);
}

void CScreenEffect::SetSepiaTexture(mgCTexture *texture, dc2::memory::ArenaBuffer image) {
    const auto bytes = CaptureStorage(texture, image);
    if (bytes.empty()) {
        return;
    }
    texture->image[0] = reinterpret_cast<u_long128 *>(bytes.data());
    sepia_texture = texture;
    sepia_image = image;
}

void CScreenEffect::CaptureSepiaScreen() {
    const auto image = LiveCaptureImage(sepia_texture, sepia_image);
    if (image.empty()) {
        sepia = 0;
        return;
    }
    mgCTexture screen;
    mgGetFrameBackBuffer(&screen);
    if (screen.width != sepia_texture->width || screen.height != sepia_texture->height || screen.bpp != 32) {
        return;
    }
    if (mgStoreImage(&screen, std::as_writable_bytes(image)) <= 0) {
        return;
    }
    u_char *pixels = image.data();

    for (std::size_t i = 0; i < image.size(); i += 4) {
        u_char *red = &pixels[i];
        u_char *green = &pixels[i + 1];
        u_char *blue = &pixels[i + 2];
        int     gray = static_cast<u_int>(0.229f * static_cast<float>(static_cast<u_int>(*red)) + 0.587f * static_cast<float>(static_cast<u_int>(*green)) + 0.114f * static_cast<float>(static_cast<u_int>(*blue))) & 0xFF;

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
    if (!LiveCaptureImage(sepia_texture, sepia_image).empty()) {
        sepia = enabled;
        return;
    }

    sepia = 0;
}

void CScreenEffect::SetMonoFlashTexture(std::span<mgCTexture *, 2>                   textures,
                                        std::span<const dc2::memory::ArenaBuffer, 2> images) {
    const auto first = CaptureStorage(textures[0], images[0]);
    const auto second = CaptureStorage(textures[1], images[1]);
    if (first.empty() || second.empty()) {
        return;
    }
    textures[0]->image[0] = reinterpret_cast<u_long128 *>(first.data());
    textures[1]->image[0] = reinterpret_cast<u_long128 *>(second.data());
    for (std::size_t index = 0; index < 2; ++index) {
        mono_flash_texture[index] = textures[index];
        mono_flash_image[index] = images[index];
    }
}

void CScreenEffect::CaptureMonoFlashScreen() {
    const auto first = LiveCaptureImage(mono_flash_texture[0], mono_flash_image[0]);
    const auto second = LiveCaptureImage(mono_flash_texture[1], mono_flash_image[1]);
    if (first.empty() || second.size() != first.size()) {
        mono_flash = 0;
        return;
    }
    mgCTexture screen;
    mgGetFrameBackBuffer(&screen);
    if (screen.width != mono_flash_texture[0]->width || screen.height != mono_flash_texture[0]->height ||
        screen.width != mono_flash_texture[1]->width || screen.height != mono_flash_texture[1]->height || screen.bpp != 32) {
        return;
    }
    if (mgStoreImage(&screen, std::as_writable_bytes(first)) <= 0) {
        return;
    }
    if (mgStoreImage(&screen, std::as_writable_bytes(second)) <= 0) {
        return;
    }
    u_char *positive = first.data();
    u_char *negative = second.data();

    for (std::size_t i = 0; i < first.size(); i += 4) {
        u_char *red = &positive[i];
        u_char *green = &positive[i + 1];
        u_char *blue = &positive[i + 2];
        *red = *green = *blue = static_cast<u_int>(0.229f * static_cast<float>(*red) + 0.587f * static_cast<float>(*green) + 0.114f * static_cast<float>(*blue));
        red = &negative[i];
        green = &negative[i + 1];
        blue = &negative[i + 2];
        char gray = static_cast<u_int>(0.229f * static_cast<float>(*red) + 0.587f * static_cast<float>(*green) + 0.114f * static_cast<float>(*blue));
        *red = *green = *blue = 255 - gray;
    }
}

void CScreenEffect::SetMonoFlashFlag(int enabled, int interval) {
    if (!LiveCaptureImage(mono_flash_texture[0], mono_flash_image[0]).empty() &&
        !LiveCaptureImage(mono_flash_texture[1], mono_flash_image[1]).empty()) {
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
    SetWorldCoordFlg = false;
    EdEventInfo.world_coord_pos[3] = 1.0f;
    EdEventInfo.world_coord_pos[0] = 0.0f;
    EdEventInfo.world_coord_rot[3] = 0.0f;
    EdEventInfo.world_coord_rot[2] = 0.0f;
    EdEventInfo.world_coord_rot[1] = 0.0f;
    EdEventInfo.world_coord_rot[0] = 0.0f;
}

int GetLocalFlag(int index) {
    int bit = {};
    int in_range = {};
    int word = {};

    word = index >> 5;

    if (index < 0) {
        return false;
    }

    in_range = word < EVENT_LOCAL_NUM;

    if (index < 0) {
        word = (index + 0x1F) >> 5;
        in_range = word < EVENT_LOCAL_NUM;
    }

    bit = index & 0x1F;

    if (in_range == 0) {
        return false;
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
    int  bit = {};
    int  in_range = {};
    int  word = {};
    int  mask = {};
    u32 *flags = {};

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
    flags = &EventLocalFlag[word];
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
        return false;
    }

    EventLocalCnt[index] = value;
    return true;
}

int GetLocalCnt2(int value) {
    int i = {};

    for (i = 0; i < EVENT_LOCAL_NUM; i++) {
        if (value == EventLocalCnt[i]) {
            return i;
        }
    }

    return -1;
}

void InitLocalCnt() {
    int i = {};

    for (i = 0; i < EVENT_LOCAL_NUM; i++) {
        EventLocalCnt[i] = 0;
    }
}

void EdEventInfoCommandInitialize() {
    int i = {};

    EdEventInfo.request = EVENT_REQUEST_NONE;
    EdEventInfo.command_mode = EVENT_COMMAND_RUN;
    EdEventInfo.skip_button = PAD_BTN_START;
    EdEventInfo.env_bgm_volume = 1.0f;
    EdEventInfo.skip_state = EVENT_SKIP_NONE;
    EdEventInfo.skip_fade_color[0] = 0;
    EdEventInfo.skip_fade_color[1] = 0;
    EdEventInfo.skip_fade_color[2] = 0;
    EdEventInfo.skip_fade_color[3] = 0;
    EdEventInfo.start_button = 0;
    EdEventInfo.unk_128 = 0;
    EdEventInfo.env_bgm_no = 0;
    EdEventInfo.stream_playing = false;
    EdEventInfo.stream_source = EVENT_STREAM_FILE;

    for (i = 0; i < 16; i++) {
        EdEventInfo.func_iparam[i] = 0;
        EdEventInfo.func_fparam[i] = 0;
    }

    EdEventInfo.door_type = 0;
    EdEventInfo.map_draw = true;
    EdEventInfo.interior_entrance = 0;
    EdEventInfo.pack_loaded = false;
    EdEventInfo.stream_reading = false;
}

void EventSeqInit() {
    int i = {};

    for (i = 0; i < EOH_NUM; i++) {
        CEoh *handle = &EventObjHandleMother.eoh[i];
        handle->type = EOH_TYPE_NONE;
        handle->scene_no = -1;
        handle->world_coord = 1;

        handle->object = nullptr;
        handle->chara = nullptr;
        handle->sprite = nullptr;
        handle->frame = nullptr;
        handle->func_point = nullptr;
    }

    CameraSeq.Initialize(cmr_seq_tbl, SEQ_NODE_NUM);
    int j = {};

    for (j = 0; j < EVENT_OBJECT_SEQ_NUM; j++) {
        ObjectSeq[j].Initialize(obj_seq_tbl, SEQ_NODE_NUM);
    }

    int k = {};

    for (k = 0; k < EVENT_SPRITE2_NUM; k++) {
        EventSprite2[k].Initialize();
    }

    EventScreenEffect.Initialize();
    EventScriptArg.next_id = 0;
    EventScriptArg.list = nullptr;
    EventScriptArg.list_num = 0;
    EventScriptArg.memory = nullptr;
}

void EdEventInit() {
    int i = {};

    BuffEventSnd.stSetBuffer(event_snd_buff, EVENT_SND_BUFFER_SIZE);

    dc2::text::Copy(BuffEventSnd.name, "Event Snd");

    BuffEventSnd.stReset();
    BuffEventSnd2.stSetBuffer(event_snd2_buff, EVENT_SND2_BUFFER_SIZE);

    dc2::text::Copy(BuffEventSnd2.name, "Event Snd2");

    BuffEventSnd2.stReset();
    InitReadBG();
    EventDngMap.Initialize();
    use_item_result = {};
    SetWorldCoordFlg = false;
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

    for (i = 0; i < EVENT_SPRITE2_NUM; i++) {
        EventSprite2[i].Initialize();
    }

    HitEffect[0].live_num = 0;
    HitEffect[0].spark = Hit_para[0];
    HitEffect[0].spark_max = EVENT_HIT_PARTICLE_NUM;
    HitEffect[1].spark = Hit_para[1];
    sword_effect_storage = {};
    HitEffect[2].spark = Hit_para[2];
    ResetEventEffectScript();
    HitEffect[3].spark = Hit_para[3];
    HitEffect[4].spark = Hit_para[4];
    HitEffect[0].spark_num = 0;
    HitEffect[0].kind = 0;
    HitEffect[1].spark_max = EVENT_HIT_PARTICLE_NUM;
    HitEffect[1].live_num = 0;
    HitEffect[1].spark_num = 0;
    HitEffect[1].kind = 0;
    HitEffect[2].spark_max = EVENT_HIT_PARTICLE_NUM;
    HitEffect[2].live_num = 0;
    HitEffect[2].spark_num = 0;
    HitEffect[2].kind = 0;
    HitEffect[3].spark_max = EVENT_HIT_PARTICLE_NUM;
    HitEffect[4].spark_max = EVENT_HIT_PARTICLE_NUM;
    HitEffect[3].live_num = 0;
    HitEffect[3].spark_num = 0;
    HitEffect[3].kind = 0;
    HitEffect[4].live_num = 0;
    HitEffect[4].spark_num = 0;
    HitEffect[4].kind = 0;
    EventScriptArg.next_id = 0;
    EventScriptArg.list = nullptr;
    EventScriptArg.list_num = 0;
    EventScriptArg.memory = nullptr;
    EventScreenEffect.Initialize();
}

void EventTimeDraw() {
    int        digit[10];
    int        glyph[32];
    CSaveData *save_data = GetSaveData();

    if (save_data != nullptr && EdEventInfo.stopwatch_start != 0) {
        u64 elapsed = {};

        if (EdEventInfo.stopwatch_style == EVENT_STOPWATCH_STYLE_COUNTDOWN) {
            elapsed = EdEventInfo.stopwatch_limit - 2;
            EdEventInfo.stopwatch_limit = elapsed;
        } else if (EdEventInfo.stopwatch_limit != 0) {
            elapsed = EdEventInfo.stopwatch_limit - (PAL_TIMING(save_data->play_time - EdEventInfo.stopwatch_start, (save_data->play_time - EdEventInfo.stopwatch_start) * 6 / 5));
        } else {
            elapsed = PAL_TIMING(save_data->play_time - EdEventInfo.stopwatch_start, (save_data->play_time - EdEventInfo.stopwatch_start) * 6 / 5);
        }

        if (0x57E40 <= elapsed) {
            elapsed = 0x57E40;
        }

        int minutes = elapsed / 3600;
        int seconds = elapsed % 3600 / 60;
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

        glyph[0] = digit[minutes / 10];
        glyph[1] = digit[minutes % 10];
        glyph[3] = digit[seconds / 10];
        glyph[4] = digit[seconds % 10];
        glyph[6] = digit[hundredths / 10];
        glyph[7] = digit[hundredths % 10];

        if (EdEventInfo.stopwatch_style == EVENT_STOPWATCH_STYLE_COUNTDOWN) {
            glyph[2] = GetHalfFontNo(':');
            glyph[5] = GetHalfFontNo(':');
        } else {
            glyph[2] = GetHalfFontNo('m');
            glyph[5] = GetHalfFontNo('s');
        }

        mgCDrawPrim prim;

        if (EdEventInfo.stopwatch_style == EVENT_STOPWATCH_STYLE_WINDOW) {
            prim.Begin(MG_PRIM_SPRITE);
            RECT       window{};
            RGBAQ_TYPE window_color{};
            window.width = 0x9E;
            window.height = 0x36;
            window_color.r = window_color.g = window_color.b = window_color.a = 0x80;
            window.x = EdEventInfo.stopwatch_x - 0x10;
            window.y = EdEventInfo.stopwatch_y - 0x12;
            DrawVersatileWin_4(&prim, window, &window_color, 0x80);
            prim.End();
        }

        MySetPrim(&prim, 1, 0);
        prim.Begin(MG_PRIM_SPRITE);

        for (int i = 0; i < 32; i++) {
            if (glyph[i] >= 0) {
                int  page = {};
                RECT texture = GetRectFontTex(glyph[i], &page);
                MySetTex(page, &prim);
                RECT destination{};
                destination.x = EdEventInfo.stopwatch_x + texture.width * i;
                destination.y = EdEventInfo.stopwatch_y;

                if (EdEventInfo.stopwatch_style == EVENT_STOPWATCH_STYLE_COUNTDOWN) {
                    destination.y += 0x40;
                }

                destination.width = texture.width;
                destination.height = texture.height;
                set2DSprite_Fuchi(&prim, destination, texture, 8, 0x80);
                RGBAQ_TYPE color{};
                color.a = color.r = color.g = color.b = 0x80;
                set2DSpriteEasyFont(&prim,
                                    mgRect<int>(destination.x, destination.y, destination.width, destination.height),
                                    mgRect<int>(texture.x, texture.y, texture.width, texture.height), &color);
            }
        }

        if (EdEventInfo.stopwatch_style == EVENT_STOPWATCH_STYLE_COUNTDOWN) {
            int label[32];

            for (int i = 0; i < 32; i++) {
                label[i] = -1;
            }

            if (EdEventInfo.stopwatch_style == EVENT_STOPWATCH_STYLE_COUNTDOWN) {
                switch (LanguageCode) {
                    case LANG_JAPANESE:
                        label[0] = GetFontNo("\x8C\x8E");
                        label[1] = GetFontNo("\x97\x8E");
                        label[2] = GetFontNo("\x89\xBA");
                        label[3] = GetFontNo("\x82\xDC");
                        label[4] = GetFontNo("\x82\xC5");
                        break;
                    case LANG_FRENCH:
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
                    case LANG_ITALIAN:
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
                    case LANG_SPANISH:
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
                    case LANG_ENGLISH:
                    case LANG_GERMAN:
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
                    int  page = {};
                    RECT texture = GetRectFontTex(label[i], &page);
                    MySetTex(page, &prim);
                    RECT destination{};

                    switch (LanguageCode) {
                        case LANG_JAPANESE:
                            destination.x = EdEventInfo.stopwatch_x + texture.width * i + 0x18;
                            break;
                        case LANG_FRENCH:
                        case LANG_SPANISH:
                            destination.x = static_cast<int>(EdEventInfo.stopwatch_x + 0.75 * texture.width * i - 28.0);
                            break;
                        case LANG_GERMAN:
                            destination.x = static_cast<int>(8.0 + (EdEventInfo.stopwatch_x + 0.75 * texture.width * i));
                            break;
                        case LANG_ITALIAN:
                            destination.x = static_cast<int>(EdEventInfo.stopwatch_x + 0.5 * texture.width * i - 28.0);
                            break;
                        case LANG_ENGLISH:
                        default:
                            destination.x = EdEventInfo.stopwatch_x + texture.width * i - 4;
                            break;
                    }

                    destination.y = EdEventInfo.stopwatch_y - 0x18;

                    if (EdEventInfo.stopwatch_style == EVENT_STOPWATCH_STYLE_COUNTDOWN) {
                        destination.y += 0x40;
                    }

                    destination.width = texture.width;
                    destination.height = texture.height;
                    set2DSprite_Fuchi(&prim, destination, texture, 8, 0x80);
                    RGBAQ_TYPE color{};
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
    int hit_no = {};
    int sprite_no = {};

    EventRain.Step();
    EventRain.Draw();

    for (hit_no = 0; hit_no < EVENT_HIT_EFFECT_NUM; hit_no++) {
        HitEffect[hit_no].Draw();
    }

    if (auto *effect = GetSwordEffect()) {
        effect->Draw();
    }

    if (auto *manager = GetEventEffectScript()) {
        manager->Draw();
    }

    EventDngMap.Step();
    EventDngMap.Draw();
    esMother.Step();
    esMother.Draw();

    for (sprite_no = 0; sprite_no < EVENT_SPRITE2_NUM; sprite_no++) {
        EventSprite2[sprite_no].NormalDraw();
    }

    EventScreenEffect.Draw();
    DrawMenuDl(0x80);
    DrawDownLoadAnaunce();
}

void EdEventFirstDraw() {
    int i = {};

    for (i = 0; i < EVENT_SPRITE2_NUM; i++) {
        EventSprite2[i].FirstDraw();
    }
}

int EdEventFinish() {
    mgCCamera *camera = {};
    int        i = {};
    int        j = {};
    int        k = {};

    CameraSeq.Initialize(cmr_seq_tbl, SEQ_NODE_NUM);

    for (i = 0; i < EVENT_OBJECT_SEQ_NUM; i++) {
        ObjectSeq[i].Initialize(obj_seq_tbl, SEQ_NODE_NUM);
    }

    for (j = 0; j < EVENT_SPRITE2_NUM; j++) {
        EventSprite2[j].Initialize();
    }

    HitEffect[0].live_num = 0;
    HitEffect[0].spark = Hit_para[0];
    HitEffect[0].spark_max = EVENT_HIT_PARTICLE_NUM;
    HitEffect[1].spark = Hit_para[1];
    ResetEventEffectScript();
    HitEffect[2].spark = Hit_para[2];
    HitEffect[3].spark = Hit_para[3];
    HitEffect[4].spark = Hit_para[4];
    HitEffect[0].spark_num = 0;
    HitEffect[0].kind = 0;
    HitEffect[1].spark_max = EVENT_HIT_PARTICLE_NUM;
    HitEffect[1].live_num = 0;
    HitEffect[1].spark_num = 0;
    HitEffect[1].kind = 0;
    HitEffect[2].spark_max = EVENT_HIT_PARTICLE_NUM;
    HitEffect[2].live_num = 0;
    HitEffect[2].spark_num = 0;
    HitEffect[2].kind = 0;
    HitEffect[3].spark_max = EVENT_HIT_PARTICLE_NUM;
    HitEffect[4].spark_max = EVENT_HIT_PARTICLE_NUM;
    HitEffect[3].live_num = 0;
    HitEffect[3].spark_num = 0;
    HitEffect[3].kind = 0;
    HitEffect[4].live_num = 0;
    HitEffect[4].spark_num = 0;
    HitEffect[4].kind = 0;
    camera = EventScene->GetCamera(EventScene->active_camera);

    if (camera == nullptr) {
        return false;
    }

    if (SetWorldCoordFlg != 0) {
        SetCamWorldCoord(camera);
        SetWorldCoordFlg = false;
    }

    esMother.Init();
    EventMarker.Init();
    use_item_result = {};
    SetWorldCoordFlg = false;

    for (k = 0; k < EVENT_SPRITE2_NUM; k++) {
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
    EdEventInfo.skip_state = EVENT_SKIP_NONE;
    EdEventInfo.pack_loaded = false;
    EventScriptArg.next_id = 0;
    EventScriptArg.list = nullptr;
    EventScriptArg.list_num = 0;
    EventScriptArg.memory = nullptr;
    EventScreenEffect.Initialize();
    return true;
}

int EdEventStep() {
    int seq_no = {};
    int hit_no = {};

    mgSetProjection(EdEventInfo.projection);

    for (seq_no = 0; seq_no < EVENT_OBJECT_SEQ_NUM; seq_no++) {
        ObjectSeq[seq_no].Play();
    }

    CameraSeq.Play();

    if (auto *sphida = GetSphidaPtr()) {
        sphida->Step();
    }

    for (hit_no = 0; hit_no < EVENT_HIT_EFFECT_NUM; hit_no++) {
        HitEffect[hit_no].Step();
    }

    if (auto *effect = GetSwordEffect()) {
        effect->CreatPointList();
        effect->Step();
    }

    if (auto *manager = GetEventEffectScript()) {
        manager->Step();
    }

    EventScreenEffect.Step();
    ReadBG();
    return true;
}

void InitDramaScene() {
    EdEventInfo.skip_fade_color[0] = 0;
    EdEventInfo.skip_fade_color[1] = 0;
    EdEventInfo.skip_state = EVENT_SKIP_ENABLED;
    EdEventInfo.skip_button = PAD_BTN_START;
    EdEventInfo.skip_fade_color[2] = 0;
    EdEventInfo.skip_fade_color[3] = 0;
}

void CancelDramaScene() {
    EdEventInfo.skip_state = EVENT_SKIP_NONE;
}

void EdEventMenuExit() {
    auto complete = std::move(use_item_result);
    use_item_result = {};
    if (complete) {
        complete(MenuArg.result[0]);
    }
}

void EdEventLoopInit() {
    int i = {};

    for (i = 0; i < 12; i++) {
        EdEventInfo.snd_id[i] = 0;
    }

    EdEventInfo.last_snd_id = 0;
    memset(EdEventInfo.script_name, 0, sizeof(EdEventInfo.script_name));
    EdEventInfo.map_draw = true;
    InitWorldCoord();
    EdEventInfoCommandInitialize();
    EventScreenEffect.Initialize();
}

void EdSetBrokenObject() {
}

void ResetMesFileBuffAll() {
    int     i = {};
    ClsMes *message = {};

    i = 0;

    do {
        message = GetEventMessage(i);

        if (message != nullptr) {
            message->mes_data = nullptr;
            message->mes_data_size = 0;
        }

        i++;
    } while (i < 8);
}

void EdEventMapInit() {
    ClsMes *message = {};
    int     i = {};

    message = GetSystemMessage();

    if (message != nullptr) {
        message->Preset(5);
    }

    for (i = 0; i < EVENT_LOCAL_NUM; i++) {
        EventLocalFlag[i] = 0;
    }

    InitLocalCnt();
    message = GetSystemMessage(0);

    if (message != nullptr) {
        message->draw_speed = message->GetDrawSpeedDef();
        message->mes_no = -1;
        message->text_ptr = nullptr;
        message->open = 0;
        message->fade = 0;
        message->fukidashi_centre_x = -1;
        message->fukidashi_centre_y = -1;
    }

    message = GetSystemMessage(1);

    if (message != nullptr) {
        message->draw_speed = message->GetDrawSpeedDef();
        message->mes_no = -1;
        message->text_ptr = nullptr;
        message->open = 0;
        message->fade = 0;
        message->fukidashi_centre_x = -1;
        message->fukidashi_centre_y = -1;
    }

    message = GetSystemMessage(2);

    if (message != nullptr) {
        message->draw_speed = message->GetDrawSpeedDef();
        message->mes_no = -1;
        message->text_ptr = nullptr;
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
    HitEffect[0].spark_max = EVENT_HIT_PARTICLE_NUM;
    sword_effect_storage = {};
    HitEffect[1].spark = Hit_para[1];
    ResetEventEffectScript();
    HitEffect[2].spark = Hit_para[2];
    HitEffect[3].spark = Hit_para[3];
    HitEffect[4].spark = Hit_para[4];
    HitEffect[0].spark_num = 0;
    HitEffect[0].kind = 0;
    HitEffect[1].spark_max = EVENT_HIT_PARTICLE_NUM;
    HitEffect[1].live_num = 0;
    HitEffect[1].spark_num = 0;
    HitEffect[1].kind = 0;
    HitEffect[2].spark_max = EVENT_HIT_PARTICLE_NUM;
    HitEffect[2].live_num = 0;
    HitEffect[2].spark_num = 0;
    HitEffect[2].kind = 0;
    HitEffect[3].spark_max = EVENT_HIT_PARTICLE_NUM;
    HitEffect[4].spark_max = EVENT_HIT_PARTICLE_NUM;
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
    EdEventInfo.stopwatch_style = EVENT_STOPWATCH_STYLE_WINDOW;
}

void EdEventTermination() {
    EdEventInfo.stream_playing = false;

    if (EdEventInfo.stream_source == EVENT_STREAM_VOICE_PACK) {
        CSnd.StreamEND(EVENT_STREAM_CHANNEL);
    }

    CSnd.StreamSetVol(EVENT_STREAM_CHANNEL, EdEventInfo.stream_volume, EdEventInfo.stream_volume);
    CSnd.StreamClose(EVENT_STREAM_CHANNEL);
    EdEventInfo.stream_reading = false;
}

void EdEventEnd() {
    dc2::event::ResetReadFiles();
    ResetMesFileBuffAll();
    EventSeqInit();
}

/**
 *
 * Returns the object sequence in the given slot, or NULL when the slot is out of range.
 *
 */
static CSceneObjSeq *GetObjSeq(int index) {
    if (index < 0 || index >= EVENT_OBJECT_SEQ_NUM) {
        return nullptr;
    }

    return &ObjectSeq[index];
}

/**
 *
 * Pushes the buttons currently held down on the pad onto the stack.
 *
 */
static int _GET_PADON(dc2::script::RunArguments stack, int arg_count) {
    if (arg_count <= 0) {
        return false;
    }

    SetStack(stack, GamePad__2.GetPadOn());
    return true;
}

/**
 *
 * Pushes the buttons newly pressed on the pad onto the stack.
 *
 */
static int _GET_PADDOWN(dc2::script::RunArguments stack, int arg_count) {
    if (arg_count <= 0) {
        return false;
    }

    SetStack(stack, GamePad__2.GetPadDown());
    return true;
}

/**
 *
 * Pushes the buttons newly released on the pad onto the stack.
 *
 */
static int _GET_PADUP(dc2::script::RunArguments stack, int arg_count) {
    if (arg_count <= 0) {
        return false;
    }

    SetStack(stack, GamePad__2.GetPadUp());
    return true;
}

/**
 *
 * Pushes the analog stick axes onto the stack, one value per requested argument.
 *
 */
static int _GET_APAD(dc2::script::RunArguments stack, int arg_count) {
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

    return true;
}

/**
 *
 * Requests a move to an interior map from a jump point, with optional event and entrance numbers.
 *
 */
static int _GOTO_INTERIOR(dc2::script::RunArguments stack, int arg_count) {
    EdEventInfo.jump_point = dc2::script::RunInteger(stack++);
    dc2::text::Copy(EdEventInfo.jump_map_name, dc2::text::View(dc2::script::RunCString(stack++)));

    if (arg_count > 2) {
        EdEventInfo.event_no = dc2::script::RunInteger(stack++);
    } else {
        EdEventInfo.event_no = 100;
    }

    if (arg_count > 3) {
        EdEventInfo.interior_entrance = dc2::script::RunInteger(stack);
    } else {
        EdEventInfo.interior_entrance = 0;
    }

    EdEventInfo.request = EVENT_REQUEST_INTERIOR;
    return true;
}

/**
 *
 * Requests a move to an outside map from a jump point, with an optional event number.
 *
 */
static int _GOTO_OUTSIDE(dc2::script::RunArguments stack, int arg_count) {
    EdEventInfo.jump_point = dc2::script::RunInteger(stack++);
    dc2::text::Copy(EdEventInfo.jump_map_name, dc2::text::View(dc2::script::RunCString(stack++)));

    if (arg_count > 2) {
        EdEventInfo.event_no = dc2::script::RunInteger(stack);
    } else {
        EdEventInfo.event_no = 100;
    }

    EdEventInfo.request = EVENT_REQUEST_OUTSIDE;
    return true;
}

/**
 *
 * Initializes the event system and stops the active camera from following.
 *
 */
static int _INITIALIZE(dc2::script::RunArguments stack, int arg_count) {
    mgCCameraFollow *camera = {};

    EdEventInit();
    camera = static_cast<mgCCameraFollow *>(GetActiveCamera());

    if (camera == nullptr) {
        return false;
    }

    camera->FollowOff();
    return true;
}

int _LOAD_CHARA_sub(int stack_no, char **name, int chara_no, u32 *pack, int mode);

int _LOAD_CHARA_sub(int stack_no, char **name, int chara_no, u32 *pack) {
    return _LOAD_CHARA_sub(stack_no, name, chara_no, pack, 0);
}

/**
 *
 * Loads a character model into the event scene, from direct arguments or an argument list.
 *
 */
static int _LOAD_CHARA(dc2::script::RunArguments stack, int argc) {
    char *name[0x20];
    int   stack_no = {};
    int   chara_no = {};
    int   mode = {};
    char *path = {};

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            stack_no = GetArgInt(args++);
            path = GetArgString(args++);
            name[0] = GetArgString(args++);
            chara_no = GetArgInt(args);
            mode = 0;
            break;
        }
        case 4:
            stack_no = dc2::script::RunInteger(stack++);
            path = dc2::script::RunCString(stack++);
            name[0] = dc2::script::RunCString(stack++);
            chara_no = dc2::script::RunInteger(stack);
            mode = 0;
            break;
        case 5:
            stack_no = dc2::script::RunInteger(stack++);
            path = dc2::script::RunCString(stack++);
            name[0] = dc2::script::RunCString(stack++);
            chara_no = dc2::script::RunInteger(stack++);
            mode = dc2::script::RunInteger(stack);
            break;
        default:
            return false;
    }

    const auto file_read = dc2::event::ReadFile(path);
    u32       *pack = reinterpret_cast<u32 *>(file_read.Bytes().data());

    if (pack == nullptr) {
        return false;
    }

    int        result = _LOAD_CHARA_sub(stack_no, name, chara_no, pack, mode);
    CSaveData *save_data = GetSaveData();

    if (save_data != nullptr) {
        if (save_data->GetBitCtrl() & MENU_DEBUG_BIT_CTRL_ATRA_OFF) {
            if (result > 0) {
                CCharacter2      *chara = GetCharacter(chara_no);
                const std::string file_name = DivPathName(dc2::text::View(path)).second;

                if (file_name == "c01_base.gltf") {
                    AtraMiriaOnOff(0, chara, 0);
                } else if (file_name == "c02_base.gltf") {
                    AtraMiriaOnOff(1, chara, 0);
                }
            }
        }
    }

    return result;
}

/**
 *
 * Activates a scene character, or sets its active state from an enable flag when two arguments are given.
 *
 */
static int _CHARA_ACTIVE(dc2::script::RunArguments stack, int arg_count) {
    int enable = {};
    int chara_no = {};

    switch (arg_count) {
        case 1:
            EventScene->SetActive(SCENE_DATA_CHARA, dc2::script::RunInteger(stack));
            return true;
        case 2:
            enable = dc2::script::RunInteger(stack++);
            chara_no = dc2::script::RunInteger(stack);

            if (enable != 0) {
                EventScene->SetActive(SCENE_DATA_CHARA, chara_no);
            } else {
                EventScene->ResetActive(SCENE_DATA_CHARA, chara_no);
            }

            return true;
    }

    return false;
}

/**
 *
 * Clears the event memory stack with the given number.
 *
 */
static int _CLEAR_STACK(dc2::script::RunArguments stack) {
    EventScene->ClearStack(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Assigns the event memory stack with the given number.
 *
 */
static int _ASSIGN_STACK(dc2::script::RunArguments stack) {
    EventScene->AssignStack(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Sets a save data bit flag to the given value.
 *
 */
static int _SET_FLAG(dc2::script::RunArguments stack) {
    CSaveData *save_data = {};
    int        bit = {};
    int        value = {};

    bit = dc2::script::RunInteger(stack++);
    value = dc2::script::RunInteger(stack);
    save_data = GetSaveData();

    if (save_data == nullptr) {
        return false;
    }

    save_data->SetBitFlag(bit, value);
    return true;
}

/**
 *
 * Pushes the value of a save data bit flag onto the stack.
 *
 */
static int _GET_FLAG(dc2::script::RunArguments stack) {
    int        bit = dc2::script::RunInteger(stack++);
    CSaveData *save_data = GetSaveData();

    if (save_data == nullptr) {
        return false;
    }

    int flag = save_data->GetBitFlag(bit);
    SetStack(stack, flag);
    return true;
}

/**
 *
 * Sets a save data short counter to the given value.
 *
 */
static int _SET_CNT(dc2::script::RunArguments stack) {
    CSaveData *save_data = {};
    int        index = {};
    int        value = {};

    index = dc2::script::RunInteger(stack++);
    value = dc2::script::RunInteger(stack);
    save_data = GetSaveData();

    if (save_data == nullptr) {
        return false;
    }

    save_data->SetShortFlag(index, value);
    return true;
}

/**
 *
 * Pushes the value of a save data short counter onto the stack.
 *
 */
static int _GET_CNT(dc2::script::RunArguments stack, int arg_count) {
    CSaveData *save_data = {};
    int        index = {};

    index = dc2::script::RunInteger(stack++);
    save_data = GetSaveData();

    if (save_data == nullptr) {
        return false;
    }

    SetStack(stack, save_data->GetShortFlag(index));
    return true;
}

/**
 *
 * Sets the current file directory, or resets it to the default when no directory is given.
 *
 */
static int _SET_CURRENT_DIR(dc2::script::RunArguments stack, int argc) {
    char *dir = nullptr;

    if (argc > 0) {
        dir = dc2::script::RunCString(stack);
    }

    if (dir == nullptr || strcmp(dir, "DEFAULT") == 0 || strcmp(dir, "") == 0) {
        SetCurrentDir(nullptr);
    } else {
        SetCurrentDir(dir);
    }

    return true;
}

/**
 *
 * Changes the file directory, or resets it to the default when no directory is given.
 *
 */
static int _CHANGE_DIR(dc2::script::RunArguments stack, int argc) {
    char *dir = nullptr;

    if (argc > 0) {
        dir = dc2::script::RunCString(stack);
    }

    if (dir == nullptr || strcmp(dir, "DEFAULT") == 0 || strcmp(dir, "") == 0) {
        SetCurrentDir(nullptr);
    } else {
        ChangeDir(dir);
    }

    return true;
}

/**
 *
 * Removes a scene character, its texture block and the event object handles that refer to it.
 *
 */
static int _DELETE_CHARA(dc2::script::RunArguments stack, int argc) {
    int chara_no = {};
    int delete_texture = 1;
    chara_no = dc2::script::RunInteger(stack++);

    if (argc >= 2) {
        delete_texture = dc2::script::RunInteger(stack);
    }

    int tex_block = EventScene->GetCharaTexb(chara_no);

    if (tex_block >= 0) {
        mgCTextureManager *manager = &mgTexManager;

        if (delete_texture == 1) {
            manager->DeleteBlock(tex_block);
        }
    }

    EventScene->DeleteChara(chara_no);
    int i = {};
    int offset = {};

    for (i = 0, offset = 0; i < EOH_NUM; i++, offset += sizeof(CEoh)) {
        CEoh *handle = reinterpret_cast<CEoh *>(reinterpret_cast<u8 *>(&EventObjHandleMother) + offset);

        if (handle->type == EOH_TYPE_CHARA) {
            int *chara_slot = &handle->scene_no;

            if (chara_no == handle->scene_no) {
                handle->type = EOH_TYPE_NONE;
                *chara_slot = -1;
                handle->world_coord = 1;
                handle->chara = nullptr;
                handle->object = nullptr;
                handle->sprite = nullptr;
                handle->frame = nullptr;
                handle->func_point = nullptr;
            }
        }
    }

    return true;
}

int _LOAD_MOTION_sub(int stack_no, char *name, int chara_no, u32 *pack) {
    mgCMemory   *stack = EventScene->GetStack(stack_no);
    CCharacter2 *chara = EventScene->GetCharacter(chara_no);

    if (chara == nullptr) {
        return false;
    }

    int tex_block = EventScene->GetCharaTexb(chara_no);

    if (tex_block < 0) {
        return false;
    }

    mgCTextureManager *manager = &mgTexManager;

    if (chara_no >= 8) {
        const int length = std::snprintf(manager->name_suffix, sizeof manager->name_suffix, "ev%d", chara_no);
        if (length < 0 || static_cast<std::size_t>(length) >= sizeof manager->name_suffix) {
            return false;
        }
    }

    chara->LoadPack(pack, name, stack, stack, stack, tex_block, nullptr);

    if (chara_no >= 8) {
        manager->name_suffix[0] = 0;
    }

    return true;
}

/**
 *
 * Loads a motion pack into a scene character, from direct arguments or an argument list.
 *
 */
static int _LOAD_MOTION(dc2::script::RunArguments stack, int argc) {
    int   stack_no = {};
    int   chara_no = {};
    char *pack_name = {};
    char *motion_name = {};
    u32  *pack = {};

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            stack_no = GetArgInt(args++);
            pack_name = GetArgString(args++);
            motion_name = GetArgString(args++);
            chara_no = GetArgInt(args);
            break;
        }
        case 4:
            stack_no = dc2::script::RunInteger(stack++);
            pack_name = dc2::script::RunCString(stack++);
            motion_name = dc2::script::RunCString(stack++);
            chara_no = dc2::script::RunInteger(stack);
            break;
        default:
            return false;
    }

    const auto file_read = dc2::event::ReadFile(pack_name);
    pack = reinterpret_cast<u32 *>(file_read.Bytes().data());

    if (pack == nullptr) {
        return false;
    }

    return _LOAD_MOTION_sub(stack_no, motion_name, chara_no, pack);
}

/**
 *
 * Requests a move to a map, named by number or by name, from a jump point.
 *
 */
static int _MAP_JUMP(dc2::script::RunArguments stack, int argc) {
    EdEventInfo.jump_point = dc2::script::RunInteger(stack++);

    switch (stack.At().type) {
        case RS_INT:
            dc2::text::Copy(EdEventInfo.jump_map_name, dc2::text::View(GetMapName(dc2::script::RunInteger(stack++), nullptr)));
            break;
        case RS_STR:
            dc2::text::Copy(EdEventInfo.jump_map_name, dc2::text::View(dc2::script::RunCString(stack++)));
            break;
        default:
            return false;
    }

    if (argc > 2) {
        EdEventInfo.event_no = dc2::script::RunInteger(stack);
    } else {
        EdEventInfo.event_no = 100;
    }

    EdEventInfo.request = EVENT_REQUEST_MAP_JUMP;
    return true;
}

/**
 *
 * Starts the event rain when the argument is nonzero, otherwise stops it.
 *
 */
static int _SET_RAIN(dc2::script::RunArguments stack) {
    if (dc2::script::RunInteger(stack) != 0) {
        EventRain.Start();
    } else {
        EventRain.Stop();
    }

    return true;
}

/**
 *
 * Deletes the extended motion of a scene character.
 *
 */
static int _DEL_EXT_MOTION(dc2::script::RunArguments stack) {
    CCharacter2 *character = EventScene->GetCharacter(dc2::script::RunInteger(stack));

    if (character == nullptr) {
        return false;
    }

    character->DeleteExtMotion();
    return true;
}

/**
 *
 * Does nothing.
 *
 */
static int _SET_MARKER(dc2::script::RunArguments, int) {
    return true;
}

/**
 *
 * Sets the world coordinate position and rotation from four values, or resets it when no values are given.
 *
 */
static int _SET_WORLD_COORD(dc2::script::RunArguments stack, int argc) {
    if (argc == 4) {
        EdEventInfo.world_coord_pos[0] = dc2::script::RunFloat(stack++);
        EdEventInfo.world_coord_pos[1] = dc2::script::RunFloat(stack++);
        EdEventInfo.world_coord_pos[2] = dc2::script::RunFloat(stack++);
        EdEventInfo.world_coord_pos[3] = 1.0f;
        EdEventInfo.world_coord_rot[0] = 0.0f;
        EdEventInfo.world_coord_rot[1] = dc2::script::RunFloat(stack);
        SetWorldCoordFlg = true;
        EdEventInfo.world_coord_rot[2] = 0.0f;
        EdEventInfo.world_coord_rot[3] = 0.0f;
        return true;
    } else if (argc == 0) {
        InitWorldCoord();
        return true;
    }

    return false;
}

/**
 * Finishes the running event and returns its completion status.
 */
static int _FINISH(dc2::script::RunArguments, int) {
    return EdEventFinish();
}

/**
 *
 * Pushes the position and angle of a dungeon event point onto the stack.
 *
 */
static int _GET_DUN_WORLD_COORD(dc2::script::RunArguments stack, int argc) {
    float position[4];
    float indexed_position[6];
    float angle = {};
    float indexed_angle = {};

    if (argc == 4) {
        if (GetDungeonEventPoint(position, &angle, 0) == 0) {
            return false;
        }

        SetOutputVector(stack, {position[0], position[1], position[2]});
        stack = stack + 3;
        SetStack(stack, angle);
        return true;
    }

    if (argc == 5) {
        if (GetDungeonEventPoint(indexed_position, &indexed_angle, dc2::script::RunInteger(stack + 4)) == 0) {
            return false;
        }

        SetOutputVector(stack, {indexed_position[0], indexed_position[1], indexed_position[2]});
        stack = stack + 3;
        SetStack(stack, indexed_angle);
        return true;
    }

    return false;
}

/**
 *
 * Loads an image file into an event texture block, pushing the block number when requested.
 *
 */
static int _LOAD_IMG(dc2::script::RunArguments stack, int argc) {
    int   size = {};
    int   stack_no = dc2::script::RunInteger(stack++);
    char *file_name = dc2::script::RunCString(stack++);
    int   image_no = dc2::script::RunInteger(stack++);
    int   num = EventScene->event_texb_num;
    int   base = EventScene->event_texb;

    if (num <= 0 || num < image_no) {
        return false;
    }

    int        block = base + image_no;
    const auto file_read = dc2::event::ReadFile(file_name);
    size = file_read.Size();
    u_char *file = reinterpret_cast<u_char *>(file_read.Bytes().data());

    if (file == nullptr) {
        return false;
    }

    mgCMemory *memory = EventScene->GetStack(stack_no);
    memory->Align64();
    u_char *image = reinterpret_cast<u_char *>(memory->stAllocTest(size / 16 + 1));

    if (image == nullptr) {
        return false;
    }

    memory->stAlloc64(size / 16 + 1);
    dc2::memory::CopyTrackedBytes(image, file, size);
    mgTexManager.EnterIMGFile(image, block, memory, nullptr);

    if (argc == 3) {
        if (esMother.Set(image_no, block) == 0) {
            return false;
        }
    } else if (argc == 4) {
        SetStack(stack, block);
    }

    return true;
}

/**
 *
 * Deletes an event image texture block.
 *
 */
static int _DEL_IMG(dc2::script::RunArguments stack) {
    mgTexManager.DeleteBlock(EventScene->event_texb + dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Reads two dungeon map arguments and discards them.
 *
 */
static int _SET_DNG_MAP(dc2::script::RunArguments stack) {
    dc2::script::RunInteger(stack++);
    dc2::script::RunInteger(stack);
    return true;
}

/**
 *
 * Loads an item model into a scene character, from direct arguments or an argument list.
 *
 */
static int _LOAD_ITEM(dc2::script::RunArguments stack, int argc) {
    char *name[32];
    int   stack_no = {};
    int   chara_no = {};
    int   item_no = {};
    int   index = 0;
    u32  *pack = {};

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack), argc);

            if (args.Remaining() == 0) {
                return false;
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
            stack_no = dc2::script::RunInteger(stack++);
            item_no = dc2::script::RunInteger(stack++);
            name[0] = dc2::script::RunCString(stack++);
            chara_no = dc2::script::RunInteger(stack++);

            if (argc >= 5) {
                index = dc2::script::RunInteger(stack);
            }

            break;
        default:
            return false;
    }

    auto item_path = ItemFilePath(item_no, index);
    if (!item_path) {
        return false;
    }
    const auto file_read = dc2::event::ReadFile(item_path->data());
    pack = reinterpret_cast<u32 *>(file_read.Bytes().data());

    if (pack != nullptr) {
        return _LOAD_CHARA_sub(stack_no, name, chara_no, pack);
    }

    return false;
}

/**
 *
 * Opens the use item menu for the item in the given stack slot, passing the remaining values as menu parameters.
 *
 */
static int _GOTO_USE_ITEM(dc2::script::RunArguments stack, int argc) {
    if (argc < 1 || static_cast<std::size_t>(argc) >= std::size(MenuArg.param)) {
        return false;
    }
    const auto                                output = stack++;
    std::array<int, std::size(MenuArg.param)> parameters{};
    std::size_t                               count = 0;
    parameters[count++] = 1;
    for (int index = 1; index < argc; ++index) {
        parameters[count++] = dc2::script::RunInteger(stack++);
    }
    parameters[count++] = 0;
    auto complete = dc2::script::RunDeferredInteger(output);
    use_item_result = std::move(complete);
    std::copy_n(parameters.begin(), count, MenuArg.param);
    MenuArg.open_type = MENU_OPEN_USE_ITEM;
    EdEventInfo.command_mode = EVENT_COMMAND_SUB_MODE;
    return true;
}

/**
 *
 * Sets a local event flag to the given value.
 *
 */
static int _SET_LOCAL_FLAG(dc2::script::RunArguments stack) {
    int index = dc2::script::RunInteger(stack++);
    SetLocalFlag(index, dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Pushes the value of a local event flag onto the stack.
 *
 */
static int _GET_LOCAL_FLAG(dc2::script::RunArguments stack, int argc) {
    int index = dc2::script::RunInteger(stack++);

    argc = GetLocalFlag(index);
    SetStack(stack, argc);
    return true;
}

/**
 *
 * Opens the party selection menu as a sub mode of the event.
 *
 */
static int _GOTO_SELECT_PARTY(dc2::script::RunArguments stack, int argc) {
    MenuArg.open_type = MENU_OPEN_CHARA_CHANGE;
    EdEventInfo.command_mode = EVENT_COMMAND_SUB_MODE;
    return true;
}

/**
 *
 * Loads each listed background file into the read buffer in sequence.
 *
 */
int _SET_LOADBG_FILE(dc2::script::RunArguments stack, int argc);

/**
 *
 * Loads the monster talk message file of the current dungeon into the read buffer.
 *
 */
static int _SET_LOADBG_FILE_MONS_TALK(dc2::script::RunArguments stack, int argc) {
    char path[0x8C];
    int  size = {};
    StartReadBG();
    const int length = std::snprintf(path, sizeof path, "dungeon/msg/mostalk%d_%d.txt", DngStatus.dungeon_no, LanguageCode);
    if (length < 0 || static_cast<std::size_t>(length) >= sizeof path) {
        return false;
    }

    if (LoadFileBG(path, ReadBufferBytes(), &size) == 0) {
        return false;
    }

    EdEventInfo.pack_loaded = false;
    return true;
}

/**
 *
 * Pushes the result of the pending background file read onto the stack.
 *
 */
static int _CHECK_LOADBG_FILE(dc2::script::RunArguments stack, int argc) {
    argc = ReadBGSync();
    SetStack(stack, argc);
    return true;
}

/**
 *
 * Does nothing and fails.
 *
 */
static int _GET_TB_ITEMNO(dc2::script::RunArguments, int) {
    return false;
}

/**
 *
 * Sets the state of the nearest treasure box.
 *
 */
static int _SET_TB_STATUS(dc2::script::RunArguments stack) {
    DNG_BATTLE_AREA *area = &EventScene->battle_area;

    if (area == nullptr) {
        return false;
    }

    CTreasureBoxManager *manager = area->treasure_box;

    if (manager == nullptr) {
        return false;
    }

    int           near_box = manager->near_box;
    int           box_no = near_box;
    CTreasureBox *box = &manager->box[box_no];

    if (box == nullptr) {
        return false;
    }

    box->state = dc2::script::RunInteger(stack);
    return true;
}

/**
 *
 * Sets the lid opening angle of the nearest treasure box.
 *
 */
static int _SET_TB_ANGLE(dc2::script::RunArguments stack) {
    DNG_BATTLE_AREA *area = &EventScene->battle_area;

    if (area == nullptr) {
        return false;
    }

    CTreasureBoxManager *manager = area->treasure_box;

    if (manager == nullptr) {
        return false;
    }

    int           near_box = manager->near_box;
    int           box_no = near_box;
    CTreasureBox *box = &manager->box[box_no];

    if (box == nullptr) {
        return false;
    }

    box->lid_open = dc2::script::RunFloat(stack);
    return true;
}

/**
 *
 * Adds an item to the user inventory, with an optional count.
 *
 */
static int _ADD_ITEM(dc2::script::RunArguments stack, int argc) {
    int item_no = dc2::script::RunInteger(stack++);
    int count = 1;

    if (argc == 2) {
        count = dc2::script::RunInteger(stack);
    }

    CUserDataManager *user_data = nullptr;
    CSaveData        *save = GetSaveData();

    if (save != nullptr) {
        user_data = &save->user_data;
    }

    if (user_data == nullptr) {
        return false;
    }

    return user_data->GetItem(item_no, count);
}

/**
 *
 * Removes an item from the user inventory, with an optional count.
 *
 */
static int _SUB_ITEM(dc2::script::RunArguments stack, int argc) {
    int item_no = {};
    int count = 1;
    item_no = dc2::script::RunInteger(stack++);

    if (argc >= 2) {
        count = dc2::script::RunInteger(stack);
    }

    CSaveData *save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    CUserDataManager *user_data = &save->user_data;

    if (user_data == nullptr) {
        return false;
    }

    user_data->DeleteItem(item_no, count);
    return true;
}

/**
 *
 * Pushes the category of an item onto the stack.
 *
 */
static int _GET_ITEM_TYPE(dc2::script::RunArguments stack) {
    int item_type = GetItemDataType(dc2::script::RunInteger(stack++));
    int category = {};

    if (item_type == ITEM_DATA_NONE) {
        return false;
    }

    switch (item_type) {
        case ITEM_DATA_MAX_MELEE:
            category = 1;
            break;
        case ITEM_DATA_MAX_GUN:
            category = 2;
            break;
        case ITEM_DATA_MONICA_MELEE:
            category = 3;
            break;
        case ITEM_DATA_MONICA_MAGIC:
            category = 4;
            break;
        default:
            category = 0;
            break;
    }

    SetStack(stack, category);
    return true;
}

/**
 *
 * Pushes the amount of used inventory space onto the stack.
 *
 */
static int _GET_ITEM_SPACE(dc2::script::RunArguments stack, int argc) {
    CUserDataManager *user_data = nullptr;
    CSaveData        *save = GetSaveData();

    if (save != nullptr) {
        user_data = &save->user_data;
    }

    if (user_data == nullptr) {
        return false;
    }

    argc = user_data->SearchSpaceUsedData();
    SetStack(stack, argc);
    return true;
}

int GetConfigCaptionOff() {
    int        caption_off = 0;
    CSaveData *save = GetSaveData();

    if (save != nullptr) {
        SV_CONFIG_OPTION *config = &save->config;

        if (config != nullptr) {
            caption_off = config->caption_off;
        }
    }

    return caption_off;
}

namespace {

/**
 *
 * Plays a named host movie with the event caption overlay.
 *
 */
int PlayEventMovie(std::string_view name) {
    CMovie      movie;
    int         caption_width = {};
    int         caption_height = {};
    int         caption_block = {};
    int         caption_off = {};
    int         font_block = {};
    mgCTexture *movie_texture = {};
    int         movie_block = {};
    int         frame = {};

    if (EventScene == nullptr || EventScene->event_texb_num <= 0) {
        return false;
    }
    movie.Load(name, 0x200, 0x1A0, true, false);
    movie_block = EventScene->event_texb;

    mgCTextureManager *textures = &mgTexManager;
    textures->DeleteBlock(movie_block);
    textures->EnterTexture(movie_block, "moviework", nullptr, mgScreenWidth, mgScreenHeight, mgScreenDepth, nullptr, 0LL, 0);
    caption_block = movie_block + 1;
    caption_off = GetConfigCaptionOff();
    font_block = -1;

    if (EdEventInfo.caption_enable != 0 && caption_off == 0) {
        mgCTexture *font_texture = textures->GetTexture("gaiji", font_block);

        if (font_texture != nullptr) {
            font_block = font_texture->block;
            textures->DeleteBlock(font_block);
            textures->EnterTexture(caption_block, "movieworkte", nullptr, mgScreenWidth, mgScreenHeight, mgScreenDepth, nullptr, 0LL, 0);
            ReLoadFontTexture(caption_block);
        } else {
            EdEventInfo.caption_enable = false;
        }
    }

    textures->ReloadTexture(movie_block, (sceVif1Packet *) nullptr);
    movie_texture = textures->GetTexture("moviework", movie_block);
    movie.Play("moviework");
    movie.SwitchThread();

    while (movie.IsStarted() == 0) {
        movie.SwitchThread();
    }

    movie.SwitchThread();
    CFont font;

    if (EdEventInfo.caption_enable != 0) {
        if (caption_off == 0) {
            font.Init();
            font.Preset(7);
            font.SetFuchi(8);
        }
    }

    frame = 0;

    while (true) {
        if (frame != 0) {
            mgBeginFrame(nullptr);
        }

        GamePad__2.UpDate();

        if (movie.EndCheck() != 0 || (DebugFlag != 0 && GamePad__2.Down(PAD_START) != 0)) {
            movie.Term();
            textures->ReloadTexture(movie_block, (sceVif1Packet *) nullptr);
            mgBeginFrame(nullptr);
            mgCDrawPrim end_draw;
            end_draw.Initialize(nullptr, nullptr);
            end_draw.AlphaTestEnable(0);
            end_draw.TextureMapEnable(1);
            end_draw.Begin(MG_PRIM_SPRITE);
            end_draw.Color(0, 0, 0, 0x80);
            end_draw.Vertex(0, 0, 0);
            end_draw.Vertex(mgScreenWidth, mgScreenHeight, 0);
            end_draw.Texture(movie_texture);
            end_draw.Color(0x80, 0x80, 0x80, 0x80);
            end_draw.TextureCrd(1, 1);
            end_draw.Vertex(0, 0, 0);
            end_draw.TextureCrd(0x1FE, 0x19E);
            end_draw.Vertex(mgScreenWidth, mgScreenHeight, 0);
            end_draw.End();
            EventScene->fade.FadeOut(1, 0.0f, 0.0f, 0.0f);
            mgEndFrame(nullptr);
            mgBeginFrame(nullptr);
            textures->DeleteBlock(movie_block);

            if (EdEventInfo.caption_enable != 0 && caption_off == 0) {
                textures->DeleteBlock(caption_block);
                textures->EnterIMGFile(GetGaijiImgPtr(), font_block, nullptr, nullptr);
                ReLoadFontTexture(font_block);
            }

            return true;
        }

        textures->ReloadTexture(movie_block, (sceVif1Packet *) nullptr);
        movie.SwitchThread();
        mgCDrawPrim frame_draw;
        frame_draw.Initialize(nullptr, nullptr);
        frame_draw.AlphaTestEnable(0);
        frame_draw.TextureMapEnable(1);
        frame_draw.Begin(MG_PRIM_SPRITE);
        frame_draw.Color(0, 0, 0, 0x80);
        frame_draw.Vertex(0, 0, 0);
        frame_draw.Vertex(mgScreenWidth, mgScreenHeight, 0);
        frame_draw.Texture(movie_texture);
        frame_draw.Color(0x80, 0x80, 0x80, 0x80);
        frame_draw.TextureCrd(1, 1);
        frame_draw.Vertex(0, 0, 0);
        frame_draw.TextureCrd(0x1FE, 0x19E);
        frame_draw.Vertex(mgScreenWidth, mgScreenHeight, 0);
        frame_draw.End();
        EventScene->fade.Draw();
        EventScene->fade.FadeStep();

        if (EdEventInfo.caption_enable != 0) {
            bool has_caption = false;

            if (caption_off == 0) {
                std::string caption;
                int         i = {};
                int         x{};
                int         y{};

                for (i = 0; i < EVENT_CAPTION_NUM; i++) {
                    const auto elapsed = static_cast<std::int64_t>(frame) - EdEventInfo.caption_start[i];
                    if (elapsed >= 0 && elapsed <= static_cast<std::int64_t>(EdEventInfo.caption_frames[i])) {
                        std::string line(dc2::text::View(EdEventInfo.caption_text[i]));
                        font.CalcDrawWH(line.data(), &caption_width, &caption_height);
                        x = static_cast<int>(CalcAutoPosSet(0.0f, 512.0f, static_cast<float>(caption_width), 0.5f));
                        y = fptosi(CalcAutoPosSet(0.0f, 480.0f, static_cast<float>(caption_height), 0.95f));
                        caption = dc2::text::CaptionPrefix(dc2::text::View(EdEventInfo.caption_text[i]),
                                                           static_cast<std::size_t>(elapsed) / 2 * 2);
                        has_caption = true;
                    }
                }

                if (has_caption) {
                    textures->ReloadTexture(caption_block, (sceVif1Packet *) nullptr);
                    font.DrawDirect(caption.data(), x, y);
                }
            }
        }

        mgEndFrame(nullptr);
        frame++;
    }
}

} // namespace

/**
 *
 * Plays a named movie with the configured event captions.
 *
 */
static int _LOAD_MOVIE(dc2::script::RunArguments stack, int argc) {
    static_cast<void>(dc2::script::RunInteger(stack++));
    const auto name = dc2::script::RunText(stack++);
    if (argc >= 3) {
        static_cast<void>(dc2::script::RunInteger(stack));
    }
    return PlayEventMovie(name);
}

/**
 *
 * Clears all local event counters.
 *
 */
static int _INIT_LOCAL_CNT(dc2::script::RunArguments, int) {
    InitLocalCnt();
    return true;
}

/**
 *
 * Captures the screen and starts a crossfade in or out with the given colour and duration.
 *
 */
static int _SET_CROSSFADE(dc2::script::RunArguments stack, int argc) {
    int frames = {};
    EventScene->fade.CaptureScreen();

    if (argc == 3) {
        int direction = dc2::script::RunInteger(stack++);
        int color = dc2::script::RunInteger(stack++);
        frames = dc2::script::RunInteger(stack) * PAL_TIMING(50, 60) / 60;

        if (frames <= 0) {
            frames = 1;
        }

        if (direction == 0) {
            EventScene->fade.CrossFadeIn(color, frames, 1.0f);
        } else {
            EventScene->fade.CrossFadeOut(color, frames, 1.0f);
        }
    } else {
        frames = dc2::script::RunInteger(stack) * PAL_TIMING(50, 60) / 60;

        if (frames <= 0) {
            frames = 1;
        }

        EventScene->fade.CrossFade(frames, 1.0f);
    }

    return true;
}

/**
 *
 * Pushes the polygon scale that fits a character frame to the given size.
 *
 */
static int _GET_ADJUST_POLYGON_SCALE(dc2::script::RunArguments stack, int argc) {
    int          chara_no = dc2::script::RunInteger(stack++);
    float        size = dc2::script::RunFloat(stack++);
    CCharacter2 *chara = GetCharacter(chara_no);

    if (chara == nullptr) {
        return false;
    }

    if (chara->CObjectFrame::frame == nullptr) {
        return false;
    }

    SetStack(stack, MenuAdjustPolygonScale(chara->CObjectFrame::frame, size));
    return true;
}

/**
 *
 * Sets the time of the event scene.
 *
 */
static int _SET_TIME(dc2::script::RunArguments stack) {
    EventScene->SetTime(dc2::script::RunFloat(stack));
    return true;
}

/**
 *
 * Sets the active lighting of the first active map.
 *
 */
static int _SET_ACTIVE_LIGHT(dc2::script::RunArguments stack) {
    CMap *maps[8];

    int light_no = dc2::script::RunInteger(stack);

    if (EventScene->GetActiveMap(maps, 8) <= 0) {
        return false;
    }

    if (light_no >= 0) {
        if (light_no < maps[0]->map_info.lighting_info_num) {
            maps[0]->map_info.active_light_no = light_no;
        }
    }

    return true;
}

/**
 *
 * Sets the texture animation names used by the Paku event object.
 *
 */
static int _SET_PAKU_ANIM(dc2::script::RunArguments stack, int argc) {
    char *name2 = {};
    int   eoh_no = dc2::script::RunInteger(stack++);
    char *name = dc2::script::RunCString(stack++);
    name2 = nullptr;

    if (argc > 2) {
        name2 = dc2::script::RunCString(stack);
    }

    PakuAnimEohNo = eoh_no;
    dc2::text::Copy(PakuAnimName, dc2::text::View(name));

    if (name2 != nullptr) {
        dc2::text::Copy(PakuAnimName2, dc2::text::View(name2));
    } else {
        PakuAnimName2[0] = '\0';
    }

    return true;
}

/**
 *
 * Clears the Paku texture animation settings.
 *
 */
static int _RESET_PAKU_ANIM(dc2::script::RunArguments stack, int argc) {
    PakuAnimEohNo = -1;
    memset(PakuAnimName, 0, sizeof(PakuAnimName));
    memset(PakuAnimName2, 0, sizeof(PakuAnimName2));
    return true;
}

/**
 *
 * Applies the Paku texture animations, with the argument choosing which animation plays first.
 *
 */
static int _TRG_PAKU_ANIM(dc2::script::RunArguments stack) {
    if (dc2::script::RunInteger(stack) != 0) {
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

    return true;
}

/**
 *
 * Resets the event camera to follow the character, from the active or the previous camera.
 *
 */
static int _RESET_CAMERA(dc2::script::RunArguments stack, int argc) {
    int              mode = {};
    float            follow[4];
    float            follow_offset[4];
    float            chara_pos[4];
    float            camera_pos[4];
    float            pos[4];
    float            rot[4];
    float            target[4];
    CCameraControl  *camera = {};
    mgCCameraFollow *reference_camera = {};
    mgCCameraFollow *before_camera = {};
    CCharacter2     *chara = {};
    float            dx = {};
    float            dy = {};
    float            dz = {};
    float            distance = {};
    mode = dc2::script::RunInteger(stack++);
    float angle = {};
    float height = {};
    height = angle = 0.0f;

    if (argc > 1) {
        angle = dc2::script::RunFloat(stack++);
    }

    if (argc > 2) {
        height = dc2::script::RunFloat(stack);
    }

    camera = nullptr;

    if (mode == 0) {
        camera = static_cast<CCameraControl *>(EventScene->GetCamera(EventScene->active_camera));
    }

    if (mode == 1) {
        camera = static_cast<CCameraControl *>(EventScene->GetCamera(EventScene->before_camera));
    }

    if (camera == nullptr) {
        return false;
    }

    reference_camera = static_cast<mgCCameraFollow *>(EventScene->GetCamera(EventScene->before_camera));

    if (reference_camera == nullptr) {
        return false;
    }

    reference_camera->GetFollow(follow);
    reference_camera->GetFollowOffset(follow_offset);

    if (mode == 0) {
        chara = EventScene->GetCharacter(0);

        if (chara == nullptr) {
            return false;
        }

        chara->GetPosition(chara_pos);
        SetCamWorldCoord(camera);
        camera->GetPos(camera_pos);
        dx = camera_pos[0] - chara_pos[0];
        dy = camera_pos[1] - chara_pos[1];
        dz = camera_pos[2] - chara_pos[2];
        distance = sqrtf(dx * dx + dz * dz);

        if (argc < 3) {
            height = dy - follow_offset[1];
        }

        if (argc < 2) {
            angle = atan2f(dx, dz);
        }

        float fx = chara_pos[0];
        float fy = chara_pos[1];
        float fz = chara_pos[2];
        camera->FollowOn();
        camera->SetFollow(fx, fy, fz);
        camera->SetFollowOffset(follow_offset[0], follow_offset[1], follow_offset[2]);
        camera->SetDistance(distance);
        camera->SetHeight(height);
        camera->SetAngleSoon(angle);
        before_camera = static_cast<mgCCameraFollow *>(EventScene->GetCamera(EventScene->before_camera));
        reference_camera = static_cast<mgCCameraFollow *>(EventScene->GetCamera(EventScene->active_camera));
        *before_camera = *reference_camera;
        SetWorldCoordFlg = false;
        return true;
    }

    if (mode == 1) {
        camera->FollowOff();
        distance = camera->GetDistance();

        if (argc < 3) {
            height = camera->GetHeight();
        }

        chara = EventScene->GetCharacter(0);

        if (chara == nullptr) {
            return false;
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
        camera->SetFollowOffset(follow_offset[0], follow_offset[1], follow_offset[2]);
        camera->SetDistance(distance);
        camera->SetHeight(height);
        camera->SetAngleSoon(rot[1] + angle);
        camera->Step(-1);
        camera->Step(1);
        camera->ControlOn();
        SetWorldCoordFlg = false;
        return true;
    }

    return false;
}

/**
 *
 * Pushes the active character number onto the stack.
 *
 */
static int _GET_ACTIVE_CHR_NO(dc2::script::RunArguments stack) {
    CUserDataManager *user_data = nullptr;
    CSaveData        *save = GetSaveData();

    if (save != nullptr) {
        user_data = &save->user_data;
    }

    if (user_data == nullptr) {
        return false;
    }

    SetStack(stack, user_data->active_chr_no);
    return true;
}

/**
 *
 * Sets the active character number.
 *
 */
static int _SET_ACTIVE_CHR_NO(dc2::script::RunArguments stack) {
    CUserDataManager *user_data = nullptr;
    CSaveData        *save = GetSaveData();

    if (save != nullptr) {
        user_data = &save->user_data;
    }

    if (user_data == nullptr) {
        return false;
    }

    user_data->SetActiveChrNo(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Sets the current dungeon floor ID.
 *
 */
static int _DNG_SET_FLOOR_ID(dc2::script::RunArguments stack) {
    int        floor_id = dc2::script::RunInteger(stack);
    CSaveData *save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    CSaveDataDungeon *dungeon = &save->save_dungeon;

    if (dungeon == nullptr) {
        return false;
    }

    dungeon->SetFloorID(floor_id);
    return true;
}

/**
 *
 * Pushes the current dungeon floor ID onto the stack.
 *
 */
static int _DNG_GET_FLOOR_ID(dc2::script::RunArguments stack) {
    CSaveData *save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    CSaveDataDungeon *dungeon = &save->save_dungeon;

    if (dungeon == nullptr) {
        return false;
    }

    SetStack(stack, dungeon->floor_id[dungeon->stage_id]);
    return true;
}

/**
 *
 * Sets the motion names and types used by the Paku event object.
 *
 */
static int _SET_PAKU_MOTION(dc2::script::RunArguments stack, int argc) {
    int   eoh_no = dc2::script::RunInteger(stack++);
    char *name = dc2::script::RunCString(stack++);
    int   type = dc2::script::RunInteger(stack++);
    char *name2 = nullptr;
    int   type2 = 0;

    if (argc > 3) {
        name2 = dc2::script::RunCString(stack++);
        type2 = dc2::script::RunInteger(stack);
    }

    PakuMotionEohNo = eoh_no;
    dc2::text::Copy(PakuMotionName, dc2::text::View(name));
    PakuMotionType = type;

    if (name2 != nullptr) {
        dc2::text::Copy(PakuMotionName2, dc2::text::View(name2));
    } else {
        PakuMotionName2[0] = '\0';
    }

    PakuMotionType2 = type2;
    return true;
}

/**
 *
 * Clears the Paku motion settings.
 *
 */
static int _RESET_PAKU_MOTION(dc2::script::RunArguments stack, int argc) {
    PakuMotionEohNo = -1;
    memset(PakuMotionName, 0, sizeof(PakuMotionName));
    memset(PakuMotionName2, 0, sizeof(PakuMotionName2));
    return true;
}

/**
 *
 * Starts a Paku motion for the given mode, switching to the secondary motion when the primary one ends.
 *
 */
static int _TRG_PAKU_MOTION(dc2::script::RunArguments stack) {
    int mode = dc2::script::RunInteger(stack);

    if (mode == 0) {
        EventObjHandleMother.SetMotion(PakuMotionEohNo, PakuMotionName,
                                       PakuMotionType, -1.0f);
        return true;
    }

    if (strcmp(PakuMotionName2, "") == 0) {
        return true;
    }

    if (mode == 1) {
        if (strcmp(PakuMotionName,
                   EventObjHandleMother.GetNowMotionName(PakuMotionEohNo)) == 0) {
            if (EventObjHandleMother.GetNowMotionStatus(PakuMotionEohNo) == CHARA_MOTION_STATUS_NONE ||
                EventObjHandleMother.GetNowMotionStatus(PakuMotionEohNo) == CHARA_MOTION_STATUS_END) {
                EventObjHandleMother.SetMotion(PakuMotionEohNo,
                                               PakuMotionName2, PakuMotionType2, -1.0f);
                return true;
            }

            return true;
        }

        EventObjHandleMother.SetMotion(PakuMotionEohNo, PakuMotionName2,
                                       PakuMotionType2, -1.0f);
        return true;
    }

    if (mode == 2) {
        EventObjHandleMother.SetMotion(PakuMotionEohNo, PakuMotionName2,
                                       PakuMotionType2, -1.0f);
        return true;
    }

    return false;
}

/**
 *
 * Sets the background colour, with an optional alpha value.
 *
 */
static int _SET_BG_COLOR(dc2::script::RunArguments stack, int argc) {
    float color[4];
    color[0] = dc2::script::RunFloat(stack++);
    color[1] = dc2::script::RunFloat(stack++);
    color[2] = dc2::script::RunFloat(stack++);

    if (argc >= 4) {
        color[3] = dc2::script::RunFloat(stack);
    } else {
        color[3] = 128.0f;
    }

    mgSetBackGround(color);
    return true;
}

/**
 *
 * Requests the dungeon tree map as a sub mode of the event.
 *
 */
static int _GOTO_DNG_MAP(dc2::script::RunArguments stack) {
    MenuArg.open_type = MENU_OPEN_DNG_TREE_MAP;
    MenuArg.param[0] = dc2::script::RunInteger(stack);
    EdEventInfo.command_mode = EVENT_COMMAND_SUB_MODE;
    return true;
}

/**
 *
 * Finishes the event and moves to the dungeon loop, with an optional floor and event number.
 *
 */
static int _GOTO_DNG(dc2::script::RunArguments stack, int argc) {
    if (EdEventFinish() == 0) {
        return false;
    }

    INIT_LOOP_ARG loop_arg;
    loop_arg.map_no = dc2::script::RunInteger(stack++);
    loop_arg.floor_no = -1;
    loop_arg.event_no = -1;

    if (argc > 1) {
        loop_arg.floor_no = dc2::script::RunInteger(stack++);
    }

    if (argc > 2) {
        loop_arg.event_no = dc2::script::RunInteger(stack);
    }

    NextLoop(LOOP_DUNGEON, loop_arg);
    EdEventInfo.request = EVENT_REQUEST_GOTO;
    return true;
}

/**
 *
 * Finishes the event and moves to the edit loop for the given map.
 *
 */
static int _GOTO_EDIT(dc2::script::RunArguments stack, int argc) {
    if (EdEventFinish() == 0) {
        return false;
    }

    INIT_LOOP_ARG loop_arg;
    loop_arg.map_no = dc2::script::RunInteger(stack++);
    loop_arg.event_no = -1;

    if (argc > 1) {
        loop_arg.event_no = dc2::script::RunInteger(stack);
    }

    NextLoop(LOOP_EDIT, loop_arg);
    EdEventInfo.request = EVENT_REQUEST_GOTO;
    return true;
}

/**
 *
 * Pushes the menu result values onto the stack, one per requested argument.
 *
 */
static int _GET_MENU_PARAM(dc2::script::RunArguments stack, int argc) {
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
            return true;
        default:
            return false;
    }
}

/**
 *
 * Loads an NPC character model into a scene character slot.
 *
 */
static int _LOAD_CHARA_NPC(dc2::script::RunArguments stack) {
    char  path[0x80];
    char *model_name[0x80];
    int   kind = dc2::script::RunInteger(stack++);
    int   stack_no = dc2::script::RunInteger(stack++);
    int   chara_no = dc2::script::RunInteger(stack++);
    char *name = {};
    u32  *pack = {};

    if (chara_no <= 0) {
        return false;
    }

    if (chara_no >= 32) {
        return false;
    }

    if (kind == 0) {
        name = GetPartyCharaModelName(chara_no, NPC_MODEL_PATH_CHARA);
    } else {
        name = GetPartyCharaModelName(chara_no, NPC_MODEL_PATH_EVENT_TRAIN);
    }

    if (name == nullptr) {
        return false;
    }

    dc2::text::Copy(path, dc2::text::View(name));
    model_name[0] = GetPartyCharaModelName(chara_no, NPC_MODEL_PATH_INFO);

    if (model_name[0] == nullptr) {
        return false;
    }

    kind = dc2::script::RunInteger(stack);
    const auto file_read = dc2::event::ReadFile(path);
    pack = reinterpret_cast<u32 *>(file_read.Bytes().data());

    if (pack != nullptr) {
        return _LOAD_CHARA_sub(stack_no, model_name, kind, pack);
    }

    return false;
}

/**
 *
 * Places a treasure box automatically, or at a given position holding an item.
 *
 */
static int _AUTO_SET_TREASURE_BOX(dc2::script::RunArguments stack, int argc) {
    float pos[4];

    if (argc < 2) {
        AutoSetTreasureBox();
    } else {
        int item_no = dc2::script::RunInteger(stack++);
        pos[0] = dc2::script::RunFloat(stack++);
        pos[1] = dc2::script::RunFloat(stack++);
        pos[2] = dc2::script::RunFloat(stack++);
        pos[3] = 1.0f;
        AutoSetTreasureBox(item_no, pos, dc2::script::RunFloat(stack));
    }

    return true;
}

/**
 *
 * Places a monster in the dungeon automatically, or at a given position and direction.
 *
 */
static int _AUTO_SET_MONSTER(dc2::script::RunArguments stack, int argc) {
    float position[4];
    float direction[4];
    int   monster_no = {};
    int   param = 0;

    if (GetNowLoopNo() != LOOP_DUNGEON) {
        return false;
    }

    if (argc < 2) {
        AutoSetMonster();
        return true;
    }

    monster_no = dc2::script::RunInteger(stack++);
    GetStackVector(position, stack);
    stack = stack + 3;
    mgZeroVectorW(direction);

    if (argc >= 7) {
        GetStackVector(direction, stack);
        stack = stack + 3;
    }

    if (argc == 8) {
        param = dc2::script::RunInteger(stack);
    }

    AutoSetMonster(monster_no, position, direction, param);
    return true;
}

/**
 *
 * Loads a dungeon map file, with optional config file name and generation flag.
 *
 */
static int _LOAD_DUNGEON_MAP_FILE(dc2::script::RunArguments stack, int argc) {
    if (argc < 1 || argc > 3) {
        return false;
    }

    char *map_name = dc2::script::RunCString(stack++);
    char *cfg_name = nullptr;
    int   gen_flag = 0;

    if (argc >= 2) {
        cfg_name = dc2::script::RunCString(stack++);
    }

    if (argc >= 3) {
        gen_flag = dc2::script::RunInteger(stack);
    }

    LoadDungeonMapFile(map_name, cfg_name, gen_flag);
    return true;
}

/**
 *
 * Loads the monster file of the current dungeon, with optional first and second parameters.
 *
 */
static int _LOAD_MONSTER_FILE(dc2::script::RunArguments stack, int argc) {
    if (GetNowLoopNo() != LOOP_DUNGEON) {
        return false;
    }

    switch (argc) {
        case 1:
            LoadMonsterFile();
            break;
        case 2: {
            int first = dc2::script::RunInteger(stack++);
            LoadMonsterFile(first, dc2::script::RunInteger(stack));
            break;
        }
        default:
            return false;
    }

    return true;
}

/**
 *
 * Pushes the status of a party NPC onto the stack.
 *
 */
static int _GET_NPC_STATUS(dc2::script::RunArguments stack, int argc) {
    int npc_no = dc2::script::RunInteger(stack++);

    if (npc_no <= 0) {
        return false;
    }

    CUserDataManager *user_data = nullptr;

    if (npc_no > 0x20) {
        return false;
    }

    CSaveData *save = GetSaveData();

    if (save != nullptr) {
        user_data = &save->user_data;
    }

    if (user_data == nullptr) {
        return false;
    }

    SetStack(stack, user_data->GetPartyCharaStatus(npc_no));
    return true;
}

/**
 *
 * Sets the status of a party NPC.
 *
 */
static int _SET_NPC_STATUS(dc2::script::RunArguments stack) {
    int npc_no = dc2::script::RunInteger(stack++);
    int status = dc2::script::RunInteger(stack);

    if (npc_no <= 0) {
        return false;
    }

    CUserDataManager *user_data = nullptr;

    if (npc_no > 0x20) {
        return false;
    }

    CSaveData *save = GetSaveData();

    if (save != nullptr) {
        user_data = &save->user_data;
    }

    if (user_data == nullptr) {
        return false;
    }

    user_data->SetPartyCharaStatus(npc_no, status);
    return true;
}

/**
 *
 * Pushes the ID of the character currently in the party onto the stack.
 *
 */
static int _GET_NOW_PARTY_CHARA(dc2::script::RunArguments stack, int argc) {
    CUserDataManager *user_data = nullptr;
    CSaveData        *save = GetSaveData();

    if (save != nullptr) {
        user_data = &save->user_data;
    }

    if (user_data == nullptr) {
        return false;
    }

    SetStack(stack, user_data->NowPartyCharaID());
    return true;
}

/**
 *
 * Sets a local event counter, reporting whether the value was stored.
 *
 */
static int _SET_LOCAL_CNT(dc2::script::RunArguments stack) {
    int index = dc2::script::RunInteger(stack++);
    return SetLocalCnt(index, dc2::script::RunInteger(stack)) > 0;
}

/**
 *
 * Pushes the value of a local event counter onto the stack, failing for a negative value.
 *
 */
static int _GET_LOCAL_CNT(dc2::script::RunArguments stack, int argc) {
    int index = dc2::script::RunInteger(stack++);
    argc = GetLocalCnt(index);

    if (argc < 0) {
        return false;
    }

    SetStack(stack, argc);
    return true;
}

/**
 *
 * Pushes the value of a local event counter, read by the second lookup, onto the stack.
 *
 */
static int _GET_LOCAL_CNT2(dc2::script::RunArguments stack, int argc) {
    int index = dc2::script::RunInteger(stack++);

    argc = GetLocalCnt2(index);
    SetStack(stack, argc);
    return true;
}

/**
 *
 * Pushes the position and rotation of a train NPC seat onto the stack.
 *
 */
static int _GET_TRAIN_NPC_POS(dc2::script::RunArguments stack) {
    TrainNpcTable table = {
        {
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
         }
    };
    int index = dc2::script::RunInteger(stack++);

    if (index < 0 || index >= 12) {
        return false;
    }

    SetStack(stack++, table.row[index][0]);

    if (EventScene->now_map_no == 0x78) {
        SetStack(stack++, 0.0f);
    } else {
        SetStack(stack++, table.row[index][1]);
    }

    SetStack(stack++, table.row[index][2]);
    SetStack(stack, table.row[index][3]);
    return true;
}

/**
 *
 * Requests the chapter drawing menu as a sub mode of the event.
 *
 */
static int _GOTO_DRAW_CHAPTER(dc2::script::RunArguments stack) {
    MenuArg.open_type = MENU_OPEN_CHAPTER;
    MenuArg.param[0] = dc2::script::RunInteger(stack) - 1;
    EdEventInfo.command_mode = EVENT_COMMAND_SUB_MODE;
    return true;
}

/**
 *
 * Sets the projection value of the event.
 *
 */
static int _SET_PROJECTION(dc2::script::RunArguments stack) {
    EdEventInfo.projection = dc2::script::RunFloat(stack);
    return true;
}

/**
 *
 * Pushes the projection value of the event onto the stack.
 *
 */
static int _GET_PROJECTION(dc2::script::RunArguments stack) {
    SetStack(stack, EdEventInfo.projection);
    return true;
}

/**
 *
 * Fades the screen in over the given duration, optionally from a colour.
 *
 */
static int _SET_FADE_IN(dc2::script::RunArguments stack, int argc) {
    float color[4];
    mgZeroVector(color);
    int frames = dc2::script::RunInteger(stack++) * PAL_TIMING(50, 60) / 60;

    if (frames <= 0) {
        frames = 1;
    }

    if (argc >= 2) {
        GetStackVector(color, stack);
        EventScene->fade.FadeIn(frames, color[0], color[1], color[2]);
    } else {
        EventScene->fade.FadeIn(frames);
    }

    return true;
}

/**
 *
 * Fades the screen out over the given duration, optionally to a colour.
 *
 */
static int _SET_FADE_OUT(dc2::script::RunArguments stack, int argc) {
    float color[4];
    mgZeroVector(color);
    int frames = dc2::script::RunInteger(stack++) * PAL_TIMING(50, 60) / 60;

    if (frames <= 0) {
        frames = 1;
    }

    if (argc >= 2) {
        GetStackVector(color, stack);
    }

    EventScene->fade.FadeOut(frames, color[0], color[1], color[2]);
    return true;
}

/**
 *
 * Runs a dungeon debug command with the given value.
 *
 */
static int _DNG_DEBUG_COMMAND(dc2::script::RunArguments stack) {
    ScriptDebugCommand(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Seeks the CD to the sector of the named file.
 *
 */
static int _CD_SEEK(dc2::script::RunArguments stack) {
    sceCdlFILE file_info{};

    if (sceCdSearchFile(&file_info, dc2::script::RunCString(stack)) != 0) {
        return sceCdSeek(file_info.lsn);
    }

    return false;
}

/**
 *
 * Pushes the angle of a look position, computed from two components, onto the stack.
 *
 */
static int _GET_ROT_LOOK_POS(dc2::script::RunArguments stack, int argc) {
    float y = dc2::script::RunFloat(stack++);
    float x = dc2::script::RunFloat(stack++);
    SetStack(stack, atan2f(y, x));
    return true;
}

/**
 *
 * Sets the motion blur level of the event scene.
 *
 */
static int _SET_MOTION_BLUR(dc2::script::RunArguments stack) {
    EventScene->fade.blur_alpha = dc2::script::RunInteger(stack);
    return true;
}

/**
 *
 * Sets the script to load next, with its event number, and requests the load.
 *
 */
static int _LOAD_SCRIPT(dc2::script::RunArguments stack, int argc) {
    char *name = dc2::script::RunCString(stack++);
    int   event_no = dc2::script::RunInteger(stack);

    if (name == nullptr) {
        return false;
    }

    std::string script_name(name);
    if (script_name.find("_1") == std::string::npos) {
        if (script_name.size() < 4) {
            return false;
        }
        script_name.resize(script_name.size() - 4);
        script_name += "_1.stb";
    }
    constexpr std::size_t map_name_capacity = 0x20;
    const std::size_t     separator = script_name.find('/');
    if (separator == 0 || separator == std::string::npos || separator >= map_name_capacity) {
        return false;
    }
    if (!dc2::text::Fits(script_name, sizeof EdEventInfo.script_name) ||
        dc2::text::Fit(script_name, sizeof EdEventInfo.script_name - 1).size() != script_name.size()) {
        return false;
    }
    dc2::text::Copy(EdEventInfo.script_name, script_name);

    FileNameConvLanguage(EdEventInfo.script_name);
    EdEventInfo.event_no = event_no;
    EdEventInfo.request = EVENT_REQUEST_LOAD_SCRIPT;
    return true;
}

/**
 *
 * Computes the talk camera offset and middle point from two positions and an angle, pushing the results onto the stack.
 *
 */
static int _SET_TALK_CAMERA(dc2::script::RunArguments stack) {
    /**
     *
     * Camera offsets available to the scripted conversation camera.
     *
     */
    static float vv[3][4] = {
        {-94.0f, 35.5f, -106.5f, 1.0f},
        {105.0f, 32.5f, -28.5f,  1.0f},
        {113.0f, 34.5f, 82.5f,   1.0f},
    };

    float middle[4];
    float offset[4];
    float rotation[4][4];

    struct {
        float v[3];
        u32   w;
    } from{}, to{};

    float  angle = {};
    float *middle_y = {};
    from.v[0] = dc2::script::RunFloat(stack++);
    from.v[1] = dc2::script::RunFloat(stack++);
    from.v[2] = dc2::script::RunFloat(stack++);
    to.v[0] = dc2::script::RunFloat(stack++);
    to.v[1] = dc2::script::RunFloat(stack++);
    to.v[2] = dc2::script::RunFloat(stack++);
    angle = dc2::script::RunFloat(stack++);
    sceVu0AddVector(middle, from.v, to.v);
    sceVu0ScaleVector(middle, middle, 0.5f);
    middle_y = &middle[1];
    *middle_y += 30.0f;
    sceVu0UnitMatrix(rotation);
    sceVu0RotMatrixY(rotation, rotation, angle);
    sceVu0ApplyMatrix(offset, rotation, vv[1]);
    sceVu0AddVector(offset, middle, offset);
    SetOutputVector(stack, {offset[0], offset[1], offset[2]});
    stack = stack + 3;
    SetStack(stack++, middle[0]);
    SetStack(stack++, *middle_y);
    SetStack(stack, middle[2]);
    return true;
}

/**
 *
 * Spawns a hit effect at the given position, with optional spread, speed, power, gravity, life and count.
 *
 */
static int _HIT_EFFECT(dc2::script::RunArguments stack, int argc) {
    float position[4];
    float spread = {};
    float speed = {};
    float power = {};
    float gravity = {};
    int   life = {};
    int   count = {};
    int   index = dc2::script::RunInteger(stack++);
    position[0] = dc2::script::RunFloat(stack++);
    position[1] = dc2::script::RunFloat(stack++);
    position[2] = dc2::script::RunFloat(stack++);
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
        stack = stack + 3;
        spread = dc2::script::RunFloat(stack++);
        speed = dc2::script::RunFloat(stack++);
        power = dc2::script::RunFloat(stack++);
        gravity = dc2::script::RunFloat(stack++);
        life = dc2::script::RunInteger(stack++);
        count = dc2::script::RunInteger(stack);
    }

    HitEffect[index].SethitEffect(position, direction, spread, speed, power, gravity, life, count);
    HitEffect[index].kind = 1;
    return true;
}

/**
 *
 * Copies a scene character into another slot using the requested event memory stack.
 *
 */
static int _COPY_CHARA(dc2::script::RunArguments stack, int argc) {
    int stack_no = {};
    int src_no = {};
    int dst_no = {};

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            stack_no = GetArgInt(args++);
            src_no = GetArgInt(args++);
            dst_no = GetArgInt(args);
            break;
        }
        case 3:
            stack_no = dc2::script::RunInteger(stack++);
            src_no = dc2::script::RunInteger(stack++);
            dst_no = dc2::script::RunInteger(stack);
            break;
        default:
            return false;
    }

    mgCMemory *memory = EventScene->GetStack(stack_no);

    if (memory == nullptr) {
        return false;
    }

    CCharacter2 *source = GetCharacter(src_no);
    if (source == nullptr) {
        return false;
    }
    const auto source_resource = EventScene->GetSceneCharacter(src_no)->Resource();
    const int  source_texture = EventScene->GetCharaTexb(src_no);
    auto      *storage = AllocateEventStorage(memory, (sizeof(CCharacter2) + sizeof(u_long128) - 1) / sizeof(u_long128));
    if (storage == nullptr) {
        return false;
    }
    auto *copy = new (storage) CCharacter2;
    if (!source->Copy(*copy, memory)) {
        return false;
    }

    EventScene->DeleteChara(dst_no);
    int slot = EventScene->AssignChara(dst_no, dc2::scene::CharacterResource::FromArena(*memory, *copy));

    if (slot < 0) {
        return false;
    }

    EventScene->SetStatus(SCENE_DATA_CHARA, slot, SCENE_DATA_LOADED | SCENE_DATA_ASSIGNED);
    EventScene->SetCharaTexb(dst_no, source_texture);
    return true;
}

/**
 *
 * Pushes the start button setting onto the stack.
 *
 */
static int _GET_START_BUTTON(dc2::script::RunArguments stack) {
    SetStack(stack, EdEventInfo.start_button);
    return true;
}

/**
 *
 * Requests a move to an interior map from a jump point, with an optional event number.
 *
 */
static int _MOVE_INTERIOR(dc2::script::RunArguments stack, int argc) {
    EdEventInfo.jump_point = dc2::script::RunInteger(stack++);
    dc2::text::Copy(EdEventInfo.jump_map_name, dc2::text::View(dc2::script::RunCString(stack++)));

    if (argc > 2) {
        EdEventInfo.event_no = dc2::script::RunInteger(stack);
    } else {
        EdEventInfo.event_no = 100;
    }

    EdEventInfo.request = EVENT_REQUEST_INTERIOR;
    return true;
}

/**
 *
 * Pushes the monster talk data entries onto the stack.
 *
 */
static int _GET_MONSTER_TALK_DATA(dc2::script::RunArguments stack, int argc) {
    if (argc == 2) {
        SetStack(stack++, EdEventInfo.monster_talk[0]);
        SetStack(stack, EdEventInfo.monster_talk[2]);
    } else if (argc == 3) {
        SetStack(stack++, EdEventInfo.monster_talk[0]);
        SetStack(stack++, EdEventInfo.monster_talk[1]);
        SetStack(stack, EdEventInfo.monster_talk[2]);
    } else {
        return false;
    }

    return true;
}

/**
 *
 * Sets whether a function point is enabled, found by name in a map or in its parts.
 *
 */
static int _FUNC_POINT_SHOW(dc2::script::RunArguments stack, int argc) {
    CFuncPoint *func_point{};
    CMap       *map = EventScene->GetMap(EventScene->active_map);

    if (map == nullptr) {
        return false;
    }

    switch (stack.At().type) {
        case RS_INT: {
            int        parts_no = dc2::script::RunInteger(stack++);
            char      *name = dc2::script::RunCString(stack++);
            CMapParts *parts = map->GetPlaceParts(parts_no);

            if (parts == nullptr) {
                return false;
            }

            func_point = parts->func_point_mngr.Search(name);
            break;
        }
        case RS_STR: {
            char *place_name = dc2::script::RunCString(stack++);
            char *name = dc2::script::RunCString(stack++);

            if (strcmp(place_name, "") != 0) {
                CMapParts *parts = map->GetPlaceParts(place_name);

                if (parts == nullptr) {
                    return false;
                }

                func_point = parts->func_point_mngr.Search(name);
            } else {
                func_point = map->func_point.Search(name);
            }

            break;
        }
    }

    if (func_point == nullptr) {
        return false;
    }

    func_point->enable = dc2::script::RunInteger(stack);
    return true;
}

/**
 *
 * Pushes the current map number onto the stack.
 *
 */
static int _GET_NOW_MAP_NO(dc2::script::RunArguments stack) {
    SetStack(stack, EventScene->now_map_no);
    return true;
}

/**
 *
 * Pushes the current submap number onto the stack.
 *
 */
static int _GET_NOW_SUBMAP_NO(dc2::script::RunArguments stack) {
    SetStack(stack, EventScene->now_sub_map_no);
    return true;
}

/**
 *
 * Pushes the previous map number onto the stack.
 *
 */
static int _GET_OLD_MAP_NO(dc2::script::RunArguments stack) {
    SetStack(stack, EventScene->old_map_no);
    return true;
}

/**
 *
 * Pushes the previous submap number onto the stack.
 *
 */
static int _GET_OLD_SUBMAP_NO(dc2::script::RunArguments stack) {
    SetStack(stack, EventScene->old_sub_map_no);
    return true;
}

/**
 *
 * Sets the character the event rain follows.
 *
 */
static int _SET_RAIN_CHARA_NO(dc2::script::RunArguments stack) {
    EventRain.SetCharNo(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Pushes the position and Y rotation of a named edit map part onto the stack.
 *
 */
static int _GET_EDIT_PARTS_POS(dc2::script::RunArguments stack) {
    float     pos[4];
    float     rot[4];
    char     *name = dc2::script::RunCString(stack++);
    CEditMap *map = {};

    if ((map = static_cast<CEditMap *>(EventScene->GetMap(EventScene->active_map))) == nullptr) {
        return false;
    }

    CEditParts *parts = map->GetePlaceParts(name);

    if (parts == nullptr) {
        return false;
    }

    parts->GetPosition(pos);
    SetOutputVector(stack, {pos[0], pos[1], pos[2]});
    stack = stack + 3;
    parts->GetRotation(rot);
    SetStack(stack, rot[1]);
    return true;
}

/**
 *
 * Does nothing.
 *
 */
static int _GET_CONTENTS_POS(dc2::script::RunArguments, int) {
    return true;
}

/**
 *
 * Pushes the position of the breakable pot onto the stack.
 *
 */
static int _GET_BPOT_POS(dc2::script::RunArguments stack) {
    float position[4];
    sceVu0CopyVector(position, BTsubo.position);
    SetOutputVector(stack, {position[0], position[1], position[2]});
    stack = stack + 2;
    return true;
}

/**
 *
 * Pushes the state of the breakable pot onto the stack.
 *
 */
static int _GET_BPOT_STATUS(dc2::script::RunArguments stack) {
    SetStack(stack, BTsubo.state);
    return true;
}

/**
 *
 * Does nothing and fails.
 *
 */
static int _GET_PERSON_STATUS(dc2::script::RunArguments, int) {
    return false;
}

/**
 *
 * Pushes the ID of the player controlled character onto the stack.
 *
 */
static int _GET_CONTROL_CHRID(dc2::script::RunArguments stack) {
    SetStack(stack, EventScene->player_chara);
    return true;
}

/**
 *
 * Sets the reference position of the next camera move, from direct arguments or an argument list.
 *
 */
static int _SET_CAMERA_NEXT_REF(dc2::script::RunArguments stack, int argc) {
    float            ref[4];
    mgCCameraFollow *camera = {};

    if ((camera = static_cast<mgCCameraFollow *>(GetActiveCamera())) == nullptr) {
        return false;
    }

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            GetArgVector(ref, args);
            break;
        }
        case 3:
            GetStackVector(ref, stack);
            break;
        default:
            return false;
    }

    camera->SetNextRef(ref);
    return true;
}

/**
 *
 * Opens a menu as a sub mode of the event, passing the remaining values as menu parameters.
 *
 */
static int _GOTO_MENU(dc2::script::RunArguments stack, int argc) {
    MenuArg.open_type = dc2::script::RunInteger(stack++);

    for (int arg_no = 0; arg_no < argc - 1; arg_no++) {
        MenuArg.param[arg_no] = dc2::script::RunInteger(stack++);
    }

    EdEventInfo.command_mode = EVENT_COMMAND_SUB_MODE;
    return true;
}

/**
 *
 * Does nothing and fails.
 *
 */
static int _GET_MENU_STATUS(dc2::script::RunArguments, int) {
    return false;
}

/**
 *
 * Loads an equipment model onto a scene character, from direct arguments or an argument list.
 *
 */
static int _LOAD_EQUIP(dc2::script::RunArguments stack, int argc) {
    char  bone_name[0x2C];
    char *name = {};
    int   stack_no = {};
    int   member_kind = {};
    int   equip_kind = {};
    int   chara_no = {};
    int   attach_no{};

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack), argc);

            if (args.Remaining() == 0) {
                return false;
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
            stack_no = dc2::script::RunInteger(stack++);
            member_kind = dc2::script::RunInteger(stack++);
            equip_kind = dc2::script::RunInteger(stack++);
            name = dc2::script::RunCString(stack++);
            chara_no = dc2::script::RunInteger(stack++);

            if (argc >= 6) {
                attach_no = dc2::script::RunInteger(stack);
            }

            break;
        default:
            return false;
    }

    if (member_kind < 0 || member_kind > 1) {
        return false;
    }

    if (equip_kind < 0 || equip_kind > 4) {
        return false;
    }

    CUserDataManager *user_data = nullptr;
    CSaveData        *save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    user_data = &save->user_data;

    if (user_data == nullptr) {
        return false;
    }

    std::optional<std::string> path;
    CCharacter2               *chara = {};
    int                        tex_block = {};
    u32                       *pack = {};

    path = user_data->CharaEquipDataPath(member_kind, equip_kind);
    if (!path) {
        return false;
    }

    if ((chara = GetCharacter(chara_no)) == nullptr) {
        return false;
    }

    if (0 > (tex_block = EventScene->GetCharaTexb(chara_no))) {
        return false;
    }

    const auto file_read = dc2::event::ReadFile(path->data());
    if ((pack = reinterpret_cast<u32 *>(file_read.Bytes().data())) == nullptr) {
        return false;
    }

    if (equip_kind >= 3 || equip_kind >= 4) {
        mgCMemory *memory = {};

        if ((memory = EventScene->GetStack(stack_no)) == nullptr) {
            return false;
        }

        mgCTextureManager *manager = &mgTexManager;

        if (chara_no >= 8) {
            const int length = std::snprintf(manager->name_suffix, sizeof manager->name_suffix, "ev%d", chara_no);
            if (length < 0 || static_cast<std::size_t>(length) >= sizeof manager->name_suffix) {
                return false;
            }
        }

        chara->LoadSkin(pack, name, "", memory, tex_block);

        if (chara_no >= 8) {
            manager->name_suffix[0] = 0;
        }
    } else {
        if (_LOAD_CHARA_sub(stack_no, &name, attach_no, pack) <= 0) {
            return false;
        }

        if (member_kind == USER_CHARA_MAX) {
            switch (equip_kind) {
                case 0:
                    dc2::text::Copy(bone_name, "ef00");
                    break;
                case 1:
                    dc2::text::Copy(bone_name, "gun_hand");
                    break;
                case 2:
                    dc2::text::Copy(bone_name, "hat");
                    break;
            }
        } else if (member_kind == USER_CHARA_MONICA) {
            switch (equip_kind) {
                case 0:
                    dc2::text::Copy(bone_name, "sword_hand");
                    break;
                case 1:
                    dc2::text::Copy(bone_name, "wr");
                    break;
                case 2:
                    dc2::text::Copy(bone_name, "ac");
                    break;
            }
        }

        CCharacter2 *attached = {};

        if ((attached = GetCharacter(attach_no)) == nullptr) {
            return false;
        }

        if (chara->CObjectFrame::frame == nullptr) {
            return false;
        }

        mgCFrame *bone = {};

        if ((bone = chara->CObjectFrame::frame->SearchFrame(bone_name)) == nullptr) {
            return false;
        }

        if (attached->CObjectFrame::frame == nullptr) {
            return false;
        }

        attached->CObjectFrame::frame->SetReference(bone);
    }

    return true;
}

/**
 *
 * Pushes the item number of a character equipment slot onto the stack.
 *
 */
static int _GET_EQUIP_ITEMNO(dc2::script::RunArguments stack) {
    int chara_no = dc2::script::RunInteger(stack++);
    int slot = dc2::script::RunInteger(stack++);

    if (chara_no < 0 || chara_no > 1) {
        return false;
    }

    CUserDataManager *user_data = {};

    if (slot < 0 || (user_data = nullptr, slot > 4)) {
        return false;
    }

    CSaveData *save = GetSaveData();

    if (save != nullptr) {
        user_data = &save->user_data;
    }

    if (user_data == nullptr) {
        return false;
    }

    CHARA_DATA *chara = user_data->GetCharaDataPtr(chara_no);

    if (chara == nullptr) {
        return false;
    }

    SetStack(stack, chara->equip[slot].item_no);
    return true;
}

/**
 *
 * Sets the time step of the event scene.
 *
 */
static int _SET_TIME_STEP_ENABLE(dc2::script::RunArguments stack) {
    EventScene->time_step = dc2::script::RunInteger(stack);
    return true;
}

/**
 *
 * Does nothing.
 *
 */
static int _SET_DOOR_MATERIAL(dc2::script::RunArguments, int) {
    return true;
}

/**
 *
 * Initializes the drama scene.
 *
 */
static int _INIT_DRAMA_SCENE(dc2::script::RunArguments, int) {
    InitDramaScene();
    return true;
}

/**
 *
 * Sets the active camera number of the event scene.
 *
 */
static int _SET_ACTIVE_CMRID(dc2::script::RunArguments stack) {
    EventScene->active_camera = dc2::script::RunInteger(stack);
    return true;
}

/**
 *
 * Sets the previous camera number of the event scene.
 *
 */
static int _SET_BEFORE_CMRID(dc2::script::RunArguments stack) {
    EventScene->before_camera = dc2::script::RunInteger(stack);
    return true;
}

/**
 *
 * Loads the dungeon map data into the given memory stack.
 *
 */
static int _DNGMAP_LOAD(dc2::script::RunArguments stack, int argc) {
    int        tex_base = {};
    auto       arg = stack + 1;
    mgCMemory *memory = EventScene->GetStack(dc2::script::RunInteger(stack));
    int        block_offset = dc2::script::RunInteger(arg++);
    int        tex_count = EventScene->event_texb_num;
    tex_base = EventScene->event_texb;

    if (tex_count <= 0 || tex_count < block_offset) {
        return false;
    }

    int dungeon = dc2::script::RunInteger(arg++);
    int room = dc2::script::RunInteger(arg++);
    int next_room = dc2::script::RunInteger(arg);
    memory->Align64();

    if (memory->stAlloc64(EventDngMap.LoadDngInfo(
            memory, tex_base + block_offset, dungeon, room, next_room)) == nullptr) {
        return false;
    }

    EventDngMap.active = 0;
    return true;
}

/**
 *
 * Deletes the dungeon map texture block.
 *
 */
static int _DNGMAP_DELETE(dc2::script::RunArguments, int) {
    EventDngMap.DeleteTexBlock();
    return true;
}

/**
 *
 * Moves a dungeon map piece by the given amount.
 *
 */
static int _DNGMAP_MOVE_PIECE(dc2::script::RunArguments stack) {
    EventDngMap.SetKomaMove(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Sets whether the dungeon map is active.
 *
 */
static int _DNGMAP_ONOFF(dc2::script::RunArguments stack) {
    EventDngMap.active = static_cast<u8>(dc2::script::RunInteger(stack) != 0);
    return true;
}

/**
 *
 * Activates the dungeon map and fades it in or out over the given duration.
 *
 */
static int _DNGMAP_SET_FADE(dc2::script::RunArguments stack) {
    int fade_in = dc2::script::RunInteger(stack++);
    int duration = dc2::script::RunInteger(stack);
    EventDngMap.active = 1;

    if (fade_in != 0) {
        EventDngMap.FadeIn(duration);
    } else {
        EventDngMap.FadeOut(duration);
    }

    return true;
}

/**
 *
 * Gives the script the next position of the before camera.
 *
 */
static int _GET_BEFORE_CAMERA_NEXT_POS(dc2::script::RunArguments stack) {
    float      position[4];
    mgCCamera *camera = EventScene->GetCamera(EventScene->before_camera);

    if (camera == nullptr) {
        return false;
    }

    camera->GetNextPos(position);
    SetOutputVector(stack, {position[0], position[1], position[2]});
    stack = stack + 2;
    return true;
}

/**
 *
 * Gives the script the next reference point of the before camera.
 *
 */
static int _GET_BEFORE_CAMERA_NEXT_REF(dc2::script::RunArguments stack) {
    float      position[4];
    mgCCamera *camera = EventScene->GetCamera(EventScene->before_camera);

    if (camera == nullptr) {
        return false;
    }

    camera->GetNextRef(position);
    SetOutputVector(stack, {position[0], position[1], position[2]});
    stack = stack + 2;
    return true;
}

/**
 *
 * Sets the next position of the active camera, from direct arguments or an argument list.
 *
 */
static int _SET_CAMERA_NEXT_POS(dc2::script::RunArguments stack, int argc) {
    float            position[4];
    mgCCameraFollow *camera = {};

    if ((camera = static_cast<mgCCameraFollow *>(GetActiveCamera())) == nullptr) {
        return false;
    }

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            GetArgVector(position, args);
            break;
        }
        case 3:
            GetStackVector(position, stack);
            break;
        default:
            return false;
    }

    camera->SetNextPos(position);
    return true;
}

/**
 *
 * Finds the first collision point along a segment against the event's collision polygons and treasure boxes.
 *
 */
static int _CHK_INTERSECTION_POINT(dc2::script::RunArguments stack, int argc) {
    float                from[4];
    float                to[4];
    float                hit_pos[4]{};
    float                reflection[4]{};
    float                center[4];
    mgVu0FBOX            box{};
    CCPoly               polys[256];
    float                point[4];
    float                step[4];
    float                normal[4];
    float                angle{};
    CCPoly              *poly = {};
    int                  poly_count = {};
    int                  check_box = {};
    int                  step_num = {};
    int                  hit = {};
    int                  i = {};
    CTreasureBoxManager *treasure_box = {};
    int                  kind{};
    int                  ignore_mask = {};
    ignore_mask = dc2::script::RunInteger(stack++);
    GetStackVector(from, stack);
    GetStackVector(to, stack + 3);
    stack = stack + 6;
    check_box = dc2::script::RunInteger(stack++);
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

    if (poly_count < 0 || poly_count > static_cast<int>(std::size(polys))) {
        return false;
    }

    if (poly_count < 0x100 && check_box == 1) {
        DNG_BATTLE_AREA *area = &EventScene->battle_area;

        if (area == nullptr) {
            return false;
        }

        treasure_box = area->treasure_box;

        if (treasure_box == nullptr) {
            return false;
        }

        sceVu0SubVector(step, to, from);
        step_num = fptosi(mgDistVector(step) / 40.0f) + 1;
        std::memmove(point, from, sizeof(u_long128));
        sceVu0Normalize(step, step);
        sceVu0ScaleVector(step, step, 40.0f);

        for (i = 0; i < step_num && poly_count < static_cast<int>(std::size(polys)); i++) {
            const int remaining = static_cast<int>(std::size(polys)) - poly_count;
            const int found = treasure_box->PickupCollision(point, &polys[poly_count], box, remaining);
            if (found < 0 || found > remaining) {
                return false;
            }
            poly_count += found;
            sceVu0AddVector(point, point, step);
        }
    }

    if (poly_count > 0x100) {
        dc2::log::PrintGame("\n\n\n\n\n!!!!!  EVENT COL CHECK ERR <poly num over %d> !!!!!\n\n\n\n\n", poly_count);
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
            SetOutputVector(stack, {hit_pos[0], hit_pos[1], hit_pos[2]});
            stack = stack + 3;
            SetStack(stack++, hit);

            if (argc == 13) {
                SetStack(stack, kind);
            }

            break;
        case 15:
        case 16:
            SetOutputVector(stack, {hit_pos[0], hit_pos[1], hit_pos[2]});
            stack = stack + 3;
            SetOutputVector(stack, {reflection[0], reflection[1], reflection[2]});
            stack = stack + 3;
            SetStack(stack++, hit);

            if (argc == 16) {
                SetStack(stack, kind);
            }

            break;
        default:
            return false;
    }

    return true;
}

/**
 *
 * Finds the collision points of a radius-wide pipe swept along a segment against the event's collision polygons and treasure boxes.
 *
 */
static int _CHK_INTERSECTION_POINT_PIPE(dc2::script::RunArguments stack, int argc) {
    float                from[4];
    float                to[4];
    float                reflection[4]{};
    float                center[4];
    mgVu0FBOX            box{};
    CCPoly               polys[256];
    float                point[4];
    float                step[4];
    int                  hit_polys[16];
    float                hit_points[16][4]{};
    float                normal[4];
    float                angle{};
    float                radius = {};
    CCPoly              *poly = {};
    int                  poly_count = {};
    int                  check_box = {};
    int                  step_num = {};
    int                  hit = {};
    int                  i = {};
    CTreasureBoxManager *treasure_box = {};
    int                  kind{};
    int                  ignore_mask = {};
    ignore_mask = dc2::script::RunInteger(stack++);
    GetStackVector(from, stack);
    GetStackVector(to, stack + 3);
    stack = stack + 6;
    radius = dc2::script::RunFloat(stack++);
    check_box = dc2::script::RunInteger(stack++);
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

    if (poly_count < 0 || poly_count > static_cast<int>(std::size(polys))) {
        return false;
    }

    if (poly_count < 0x100 && check_box == 1) {
        DNG_BATTLE_AREA *area = &EventScene->battle_area;

        if (area == nullptr) {
            return false;
        }

        treasure_box = area->treasure_box;

        if (treasure_box == nullptr) {
            return false;
        }

        sceVu0SubVector(step, to, from);
        step_num = fptosi(mgDistVector(step) / 40.0f) + 1;
        std::memmove(point, from, sizeof(u_long128));
        sceVu0Normalize(step, step);
        sceVu0ScaleVector(step, step, 40.0f);

        for (i = 0; i < step_num && poly_count < static_cast<int>(std::size(polys)); i++) {
            const int remaining = static_cast<int>(std::size(polys)) - poly_count;
            const int found = treasure_box->PickupCollision(point, &polys[poly_count], box, remaining);
            if (found < 0 || found > remaining) {
                return false;
            }
            poly_count += found;
            sceVu0AddVector(point, point, step);
        }
    }

    if (poly_count > 0x100) {
        dc2::log::PrintGame("\n\n\n\n\n!!!!!  EVENT COL CHECK ERR <poly num over %d> !!!!!\n\n\n\n\n", poly_count);
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
            SetOutputVector(stack, {hit_points[0][0], hit_points[0][1], hit_points[0][2]});
            stack = stack + 3;
            SetStack(stack++, hit);

            if (argc == 14) {
                SetStack(stack, kind);
            }

            break;
        case 16:
        case 17:
            SetOutputVector(stack, {hit_points[0][0], hit_points[0][1], hit_points[0][2]});
            stack = stack + 3;
            SetOutputVector(stack, {reflection[0], reflection[1], reflection[2]});
            stack = stack + 3;
            SetStack(stack++, hit);

            if (argc == 17) {
                SetStack(stack, kind);
            }

            break;
        default:
            return false;
    }

    return true;
}

/**
 *
 * Sets the position the active follow camera tracks, from three stack values.
 *
 */
static int _SET_FCAMERA_FOLLOW(dc2::script::RunArguments stack, int arg_count) {
    float            position[4];
    mgCCameraFollow *camera = static_cast<mgCCameraFollow *>(EventScene->GetCamera(EventScene->active_camera));

    if (camera == nullptr) {
        return false;
    }

    GetStackVector(position, stack);
    camera->SetFollow(position[0], position[1], position[2]);
    return true;
}

/**
 *
 * Sets the position the active follow camera tracks, from three stack values.
 *
 */
static int _SET_FCAMERA_FOLLOW_A(dc2::script::RunArguments stack, int arg_count) {
    float            position[4];
    mgCCameraFollow *camera = static_cast<mgCCameraFollow *>(EventScene->GetCamera(EventScene->active_camera));

    if (camera == nullptr) {
        return false;
    }

    GetStackVector(position, stack);
    camera->SetFollow(position[0], position[1], position[2]);
    return true;
}

/**
 *
 * Sets the follow offset of the active follow camera, from three stack values.
 *
 */
static int _SET_FCAMERA_FOLLOW_OFS(dc2::script::RunArguments stack, int arg_count) {
    float            offset[4];
    mgCCameraFollow *camera = static_cast<mgCCameraFollow *>(EventScene->GetCamera(EventScene->active_camera));

    if (camera == nullptr) {
        return false;
    }

    GetStackVector(offset, stack);
    camera->SetFollowOffset(offset[0], offset[1], offset[2]);
    return true;
}

/**
 *
 * Turns the following of the active follow camera on or off.
 *
 */
static int _SET_FCAMERA_FOLLOW_FLAG(dc2::script::RunArguments stack) {
    mgCCameraFollow *camera = static_cast<mgCCameraFollow *>(EventScene->GetCamera(EventScene->active_camera));

    if (camera == nullptr) {
        return false;
    }

    if (dc2::script::RunInteger(stack) == 1) {
        camera->FollowOn();
    } else {
        camera->FollowOff();
    }

    return true;
}

/**
 *
 * Advances the active follow camera by the step count on the stack.
 *
 */
static int _FCAMERA_STEP(dc2::script::RunArguments stack) {
    mgCCameraFollow *camera = static_cast<mgCCameraFollow *>(EventScene->GetCamera(EventScene->active_camera));

    if (camera == nullptr) {
        return false;
    }

    camera->Step(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Sets the angle of the active follow camera.
 *
 */
static int _SET_FCAMERA_ANGLE(dc2::script::RunArguments stack) {
    mgCCameraFollow *camera = static_cast<mgCCameraFollow *>(EventScene->GetCamera(EventScene->active_camera));

    if (camera == nullptr) {
        return false;
    }

    camera->SetAngle(dc2::script::RunFloat(stack));
    return true;
}

/**
 *
 * Sets the height of the active follow camera.
 *
 */
static int _SET_FCAMERA_HEIGHT(dc2::script::RunArguments stack) {
    mgCCameraFollow *camera = static_cast<mgCCameraFollow *>(EventScene->GetCamera(EventScene->active_camera));

    if (camera == nullptr) {
        return false;
    }

    camera->SetHeight(dc2::script::RunFloat(stack));
    return true;
}

/**
 *
 * Sets the distance of the active follow camera.
 *
 */
static int _SET_FCAMERA_DIST(dc2::script::RunArguments stack) {
    mgCCameraFollow *camera = static_cast<mgCCameraFollow *>(EventScene->GetCamera(EventScene->active_camera));

    if (camera == nullptr) {
        return false;
    }

    camera->SetDistance(dc2::script::RunFloat(stack));
    return true;
}

/**
 *
 * Gives the yaw and pitch of the direction from one stack point to another.
 *
 */
static int _GET_REF_ANGLE(dc2::script::RunArguments stack, int argc) {
    float  from[4];
    float  direction[4];
    float  yaw = {};
    float  pitch = {};
    float *direction_z = {};
    GetStackVector(from, stack);
    GetStackVector(direction, stack + 3);
    stack = stack + 6;
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
            return false;
    }

    return true;
}

/**
 *
 * Sets the dungeon stage id in the save data.
 *
 */
static int _DNG_SET_STAGE_ID(dc2::script::RunArguments stack) {
    CSaveData *save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    CSaveDataDungeon *dungeon = &save->save_dungeon;

    if (dungeon == nullptr) {
        return false;
    }

    dungeon->stage_id = dc2::script::RunInteger(stack);
    return true;
}

/**
 *
 * Gives the dungeon stage id from the save data.
 *
 */
static int _DNG_GET_STAGE_ID(dc2::script::RunArguments stack) {
    CSaveData *save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    CSaveDataDungeon *dungeon = &save->save_dungeon;

    if (dungeon == nullptr) {
        return false;
    }

    SetStack(stack, dungeon->stage_id);
    return true;
}

/**
 *
 * Turns the following and control of the active camera on or off.
 *
 */
static int _SET_CAMERA_CTRL(dc2::script::RunArguments stack) {
    CCameraControl *camera = static_cast<CCameraControl *>(EventScene->GetCamera(EventScene->active_camera));

    if (camera == nullptr) {
        return false;
    }

    if (dc2::script::RunInteger(stack) != 0) {
        camera->FollowOn();
        camera->ControlOn();
    } else {
        camera->FollowOff();
        camera->ControlOff();
    }

    return true;
}

/**
 *
 * Gives the angle of the active follow camera.
 *
 */
static int _GET_FCAMERA_ANGLE(dc2::script::RunArguments stack, int argc) {
    mgCCameraFollow *camera = static_cast<mgCCameraFollow *>(EventScene->GetCamera(EventScene->active_camera));

    if (camera == nullptr) {
        return false;
    }

    SetStack(stack, camera->GetAngle());
    return true;
}

/**
 *
 * Gives the height of the active follow camera.
 *
 */
static int _GET_FCAMERA_HEIGHT(dc2::script::RunArguments stack, int argc) {
    mgCCameraFollow *camera = static_cast<mgCCameraFollow *>(EventScene->GetCamera(EventScene->active_camera));

    if (camera == nullptr) {
        return false;
    }

    SetStack(stack, camera->GetHeight());
    return true;
}

/**
 *
 * Gives the distance of the active follow camera.
 *
 */
static int _GET_FCAMERA_DIST(dc2::script::RunArguments stack, int argc) {
    mgCCameraFollow *camera = static_cast<mgCCameraFollow *>(EventScene->GetCamera(EventScene->active_camera));

    if (camera == nullptr) {
        return false;
    }

    SetStack(stack, camera->GetDistance());
    return true;
}

/**
 *
 * Gives whether the invention with the id on the stack has already been created.
 *
 */
static int _GET_INVENTION_ID(dc2::script::RunArguments stack, int argc) {
    CSaveData *save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    CUserDataManager *user_data = &save->user_data;
    CInventUserData  *invent_data = &user_data->invent_data;

    if (user_data == nullptr) {
        return false;
    }

    if (invent_data == nullptr) {
        return false;
    }

    int invention_id = dc2::script::RunInteger(stack++);

    argc = invent_data->IsAlreadyCreatedItem(invention_id);
    SetStack(stack, argc);
    return true;
}

/**
 *
 * Requests a map jump to the map named in the jump flags, or to the outside when that name is exit.
 *
 */
static int _FUNCTION_MAP_JUMP(dc2::script::RunArguments stack, int argc) {
    if (!(EventScene->event_data.event.flag & 0x10A)) {
        return false;
    }

    const std::string_view map_name = dc2::text::View(EventScene->event_data.event.target);
    if (map_name.empty() || map_name.size() == sizeof EventScene->event_data.event.target ||
        !dc2::text::Fits(map_name, sizeof EdEventInfo.jump_map_name)) {
        return false;
    }

    EdEventInfo.jump_point = -1;
    EdEventInfo.event_no = 100;

    if (map_name == "exit") {
        EdEventInfo.request = EVENT_REQUEST_OUTSIDE;
    } else {
        dc2::text::Copy(EdEventInfo.jump_map_name, map_name);
        EdEventInfo.request = EVENT_REQUEST_INTERIOR;
    }

    return true;
}

/**
 *
 * Sets the door mode parameters from the scene's door data.
 *
 */
static int _FUNCTION_DOOR_MODE(dc2::script::RunArguments stack, int argc) {
    EdEventInfo.func_iparam[0] = 0;
    EdEventInfo.func_iparam[1] = EventScene->event_data.event.arg1;
    EdEventInfo.func_iparam[2] = EventScene->event_data.event.arg2;
    EdEventInfo.func_fparam[0] = EventScene->event_data.map_event.matrix[3][0];
    EdEventInfo.func_fparam[1] = EventScene->event_data.map_event.matrix[3][1];
    EdEventInfo.func_fparam[2] = EventScene->event_data.map_event.matrix[3][2];
    EdEventInfo.func_fparam[3] = atan2f(EventScene->event_data.map_event.matrix[2][0], EventScene->event_data.map_event.matrix[2][2]);
    EdEventInfo.command_mode = EVENT_COMMAND_DOOR;
    return true;
}

/**
 *
 * Gives the player's money.
 *
 */
static int _GET_MONEY(dc2::script::RunArguments stack) {
    CSaveData *save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    CUserDataManager *user_data = &save->user_data;

    if (user_data == nullptr) {
        return false;
    }

    SetStack(stack, user_data->money);
    return true;
}

/**
 *
 * Adds the money on the stack to the player's money.
 *
 */
static int _ADD_MONEY(dc2::script::RunArguments stack) {
    CSaveData *save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    CUserDataManager *user_data = &save->user_data;

    if (user_data == nullptr) {
        return false;
    }

    user_data->AddMoney(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Gives the number of the item with the id on the stack that the player holds.
 *
 */
static int _GET_ITEM_NUM(dc2::script::RunArguments stack, int argc) {
    CSaveData *save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    CUserDataManager *user_data = &save->user_data;

    if (user_data == nullptr) {
        return false;
    }

    int item_no = dc2::script::RunInteger(stack++);

    argc = user_data->GetNumSameItem(item_no);
    SetStack(stack, argc);
    return true;
}

/**
 *
 * Gives whether one of the event buttons, selected by the id on the stack, is pressed this frame.
 *
 */
static int _CHECK_BUTTON(dc2::script::RunArguments stack) {
    int button = dc2::script::RunInteger(stack++);
    int pressed = 0;
    int pad_down = GamePad__2.GetPadDown();

    switch (button) {
        case EVENT_BUTTON_CANCEL:
            if (LanguageCode == LANG_JAPANESE) {
                if (pad_down & PAD_CROSS) {
                    pressed = 1;
                }
            } else if (pad_down & PAD_CIRCLE) {
                pressed = 1;
            }

            break;
        case EVENT_BUTTON_CONFIRM:
            if (LanguageCode == LANG_JAPANESE) {
                if (pad_down & PAD_CIRCLE) {
                    pressed = 1;
                }
            } else if (pad_down & PAD_CROSS) {
                pressed = 1;
            }

            break;
        case EVENT_BUTTON_SQUARE:
            if (pad_down & PAD_SQUARE) {
                pressed = 1;
            }

            break;
        case EVENT_BUTTON_SELECT:
            if (pad_down & PAD_SELECT) {
                pressed = 1;
            }

            break;
        default:
            return false;
    }

    SetStack(stack, pressed);
    return true;
}

/**
 *
 * Gives the language code of the game.
 *
 */
static int _GET_LANGUAGE(dc2::script::RunArguments stack) {
    SetStack(stack, LanguageCode);
    return true;
}

/**
 *
 * Gives whether the player holds the inventory item with the id on the stack.
 *
 */
static int _CHECK_INVENT_ITEM(dc2::script::RunArguments stack, int argc) {
    int item = dc2::script::RunInteger(stack++);
    SetStack(stack, CheckInventItem(item));
    return true;
}

/**
 *
 * Turns a villager's staying in place on or off, by the flag on the stack.
 *
 */
static int _SET_AI(dc2::script::RunArguments stack) {
    int enabled = dc2::script::RunInteger(stack++);
    int chara_no = dc2::script::RunInteger(stack);

    if (enabled != 0) {
        EventScene->CancelStayVillager(chara_no);
    } else {
        EventScene->StayVillager(chara_no);
    }

    return true;
}

/**
 *
 * Gives whether the photo with the id on the stack is held, checked against the optional value after it.
 *
 */
static int _CHECK_INVENT_PHOTO(dc2::script::RunArguments stack, int argc) {
    switch (argc) {
        case 2: {
            int id = dc2::script::RunInteger(stack++);
            int photo = CheckInventPhoto(id, 0);
            SetStack(stack, photo);
            break;
        }
        case 3: {
            int id = dc2::script::RunInteger(stack++);
            int check = dc2::script::RunInteger(stack++);
            int photo = CheckInventPhoto(id, check);
            SetStack(stack, photo);
            break;
        }
        default:
            return false;
    }

    return true;
}

/**
 *
 * Gives the number of pictures the player holds.
 *
 */
static int _GET_PHOTO_NUM(dc2::script::RunArguments stack, int argc) {
    CSaveData *save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    CUserDataManager *user_data = &save->user_data;
    CInventUserData  *invent_data = &user_data->invent_data;

    if (user_data == nullptr) {
        return false;
    }

    if (invent_data == nullptr) {
        return false;
    }

    SetStack(stack, invent_data->GetNowHavePictureNum());
    return true;
}

/**
 *
 * Does nothing.
 *
 */
static int _SET_CONTENTS_ETC(dc2::script::RunArguments, int) {
    return true;
}

/**
 *
 * Sets or resets a scene status for the type and number on the stack, depending on the optional flag.
 *
 */
static int _SET_STATUS(dc2::script::RunArguments stack, int argc) {
    int type = dc2::script::RunInteger(stack++);
    int no = dc2::script::RunInteger(stack++);
    int status = dc2::script::RunInteger(stack++);
    int on = 1;

    if (argc >= 4) {
        on = dc2::script::RunInteger(stack);
    }

    if (on != 0) {
        EventScene->SetStatus(type, no, status);
    } else {
        EventScene->ResetStatus(type, no, status);
    }

    return true;
}

/**
 *
 * Starts the sub-game of the type on the stack with the scene's texture block.
 *
 */
static int _GOTO_SUBGAME(dc2::script::RunArguments stack) {
    int         type = dc2::script::RunInteger(stack);
    SubGameInfo info;
    info.scene = EventScene;
    info.texb = EventScene->tex_block_base;
    info.texb_num = EventScene->tex_block_count;
    return sgInitSubGame(type, &info) != 0;
}

/**
 *
 * Sets a fishing race value or runs a race step, by the sub-command on the stack.
 *
 */
static int _SET_GYORACE_ETC(dc2::script::RunArguments stack) {
    int     digit[8];
    char    text[0x14];
    ClsMes *mes = {};
    float   time = {};
    int     minutes = {};
    int     seconds = {};
    int     hundredths = {};
    int     result_no = {};
    int     name_no = {};
    int     i = {};

    switch (dc2::script::RunInteger(stack++)) {
        case EVENT_SET_GYORACE_AQUARIUM_NO:
            SetGyoRaceAquariumNo(dc2::script::RunInteger(stack));
            break;
        case EVENT_SET_GYORACE_RANKING:
            SetGyoRaceRanking(dc2::script::RunInteger(stack));
            break;
        case EVENT_SET_GYORACE_CLASS:
            SetGyoRaceClass(dc2::script::RunInteger(stack));
            break;
        case EVENT_SET_GYORACE_RACE_NO:
            SetGyoRaceNo(dc2::script::RunInteger(stack));
            break;
        case EVENT_SET_GYORACE_ADD_TOUR: {
            CSaveData *save_data = GetSaveData();

            if (save_data == nullptr) {
                return false;
            }

            save_data->AddTourCountEtc(1);
            break;
        }
        case EVENT_SET_GYORACE_FISH_NAME:
            i = dc2::script::RunInteger(stack++);
            name_no = dc2::script::RunInteger(stack++);
            result_no = dc2::script::RunInteger(stack);
            if (name_no < 1 || name_no > MES_NAME_MAX || result_no < 0 || result_no >= GR_FISH_MAX) {
                return false;
            }
            mes = GetEventMessage(i);
            if (mes == nullptr) {
                return false;
            }

            dc2::text::Copy(mes->name[name_no - 1], dc2::text::View(fish_game_data[result_no].name));

            break;
        case EVENT_SET_GYORACE_FISH_TIME: {
            i = dc2::script::RunInteger(stack++);
            name_no = dc2::script::RunInteger(stack++);
            result_no = dc2::script::RunInteger(stack);
            if (name_no < 1 || name_no > MES_NAME_MAX || result_no < 0 || result_no >= GR_FISH_MAX) {
                return false;
            }
            mes = GetEventMessage(i);
            if (mes == nullptr) {
                return false;
            }
            time = fish_game_data[result_no].time;

            if (!std::isfinite(time) || time < 0.0f) {
                time = 0.0f;
            }

            if (360000.0f <= time) {
                time = 360000.0f;
            }

            minutes = static_cast<int>(time / 3600.0f);
            time -= minutes * 3600.0f;
            seconds = static_cast<int>(time / 60.0f);
            hundredths = static_cast<int>(100.0f * (time - seconds * 60.0f) / 60.0f);
            digit[0] = minutes / 10;
            digit[1] = minutes % 10;
            digit[2] = -1;
            digit[3] = seconds / 10;
            digit[4] = seconds % 10;
            digit[5] = -1;
            digit[6] = hundredths / 10;
            digit[7] = hundredths % 10;
            constexpr std::array<std::string_view, 10> glyphs = {
                "\x82\x4f",
                "\x82\x50",
                "\x82\x51",
                "\x82\x52",
                "\x82\x53",
                "\x82\x54",
                "\x82\x55",
                "\x82\x56",
                "\x82\x57",
                "\x82\x58",
            };
            for (i = 0; i < 8; ++i) {
                const std::string_view glyph = digit[i] >= 0 && digit[i] < static_cast<int>(glyphs.size())
                                                   ? glyphs[static_cast<std::size_t>(digit[i])]
                                                   : std::string_view("\x81\x46");
                if (i == 0) {
                    dc2::text::Copy(text, glyph);
                } else {
                    dc2::text::Append(text, glyph);
                }
            }

            dc2::text::Copy(mes->name[name_no - 1], text);
            break;
        }
        case EVENT_SET_GYORACE_LOAD_PRIZE:
            InitFishPrize();
            LoadFishPrize(0);
            break;
        default:
            return false;
    }

    return true;
}

/**
 *
 * Gives a fishing race value, by the sub-command on the stack.
 *
 */
static int _GET_GYORACE_ETC(dc2::script::RunArguments stack, int argc) {
    FISH_PRIZE_INFO info{};
    int             race_no = {};

    switch (dc2::script::RunInteger(stack++)) {
        case EVENT_GET_GYORACE_AQUARIUM_NO:
            SetStack(stack++, GetGyoRaceAquariumNo());
            break;
        case EVENT_GET_GYORACE_RANKING:
            SetStack(stack++, GetGyoRaceRanking());
            break;
        case EVENT_GET_GYORACE_CLASS:
            SetStack(stack++, GetGyoRaceClass());
            break;
        case EVENT_GET_GYORACE_RACE_NO:
            SetStack(stack++, GetGyoRaceNo());
            break;
        case EVENT_GET_GYORACE_PRIZE:
            race_no = dc2::script::RunInteger(stack++);

            if (!GetFishPrize(race_no, dc2::script::RunInteger(stack++) - 1, &info)) {
                return false;
            }

            SetStack(stack++, info.item_no);
            SetStack(stack++, info.num);
            break;
        case EVENT_GET_GYORACE_TOUR: {
            CSaveData *save = GetSaveData();

            if (save == nullptr) {
                return false;
            }

            SetStack(stack++, save->GetTourCountEtc());
            break;
        }
        default:
            return false;
    }

    return true;
}

/**
 *
 * Sets a save data value, by the sub-command on the stack.
 *
 */
static int _SET_SAVEDATA_ETC(dc2::script::RunArguments stack) {
    CSaveData        *save = {};
    CUserDataManager *user = {};
    MOS_CHANGE_PARAM *badge = {};

    switch (dc2::script::RunInteger(stack++)) {
        case EVENT_SET_SAVEDATA_GAME_PROGRESS:
            save = GetSaveData();

            if (save == nullptr) {
                return false;
            }

            save->game_progress = dc2::script::RunInteger(stack);
            break;
        case EVENT_SET_SAVEDATA_ENABLE_BADGE:
            save = GetSaveData();

            if (save == nullptr) {
                return false;
            }

            user = &save->user_data;

            if (user == nullptr) {
                return false;
            }

            badge = user->GetMonsterBajjiDataPtrMosId(dc2::script::RunInteger(stack));

            if (badge == nullptr) {
                return false;
            }

            badge->enable = 1;
            break;
        case EVENT_SET_SAVEDATA_REPAIR_WEAPONS:
            save = GetSaveData();

            if (save == nullptr) {
                return false;
            }

            user = &save->user_data;

            if (user == nullptr) {
                return false;
            }

            user->AllWeaponRepair();
            break;
        case EVENT_SET_SAVEDATA_SKIP_LOAD_BGM:
            save = GetSaveData();

            if (save == nullptr) {
                return false;
            }

            save->skip_load_bgm = dc2::script::RunInteger(stack);
            break;
        case EVENT_SET_SAVEDATA_DELETE_EREKI:
            DeleteErekiFish();
            break;
        default:
            return false;
    }

    return true;
}

/**
 *
 * Gives a save data value, by the sub-command on the stack.
 *
 */
static int _GET_SAVEDATA_ETC(dc2::script::RunArguments stack, int argc) {
    CSaveData *save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    int command = dc2::script::RunInteger(stack++);

    switch (command) {
        case EVENT_GET_SAVEDATA_GAME_PROGRESS:
            SetStack(stack, save->game_progress);
            break;
        case EVENT_GET_SAVEDATA_BADGE: {
            CUserDataManager *user_data = &save->user_data;

            if (user_data == nullptr) {
                return false;
            }

            int               monster_id = dc2::script::RunInteger(stack++);
            MOS_CHANGE_PARAM *badge = user_data->GetMonsterBajjiDataPtrMosId(monster_id);

            if (badge == nullptr) {
                return false;
            }

            SetStack(stack, badge->enable);
            break;
        }
        case EVENT_GET_SAVEDATA_EREKI: {
            CUserDataManager *user_data = &save->user_data;

            if (user_data == nullptr) {
                return false;
            }

            SetStack(stack, user_data->CheckElectricFish());
            break;
        }
        case EVENT_GET_SAVEDATA_BAIT: {
            int               rod_no = dc2::script::RunInteger(stack++);
            CUserDataManager *user_data = &save->user_data;

            if (user_data == nullptr) {
                return false;
            }

            CGameDataUsed *bait = user_data->GetActiveEsa(rod_no);

            if (bait == nullptr) {
                return false;
            }

            SetStack(stack, bait->item_no);
            break;
        }
        case EVENT_GET_SAVEDATA_PLAY_TIME:
            PlayTimeCount(1);
            SetStack(stack, static_cast<int> PAL_TIMING(save->play_time, (save->play_time) * 6 / 5));
            break;
        case EVENT_GET_SAVEDATA_CAPTION_OFF:
            SetStack(stack, GetConfigCaptionOff());
            break;
        case EVENT_GET_SAVEDATA_TOUR_TYPE:
            SetStack(stack, save->CheckNowTourType());
            break;
        default:
            return false;
    }

    return true;
}

/**
 *
 * Clears the monster battle state and releases the battle textures.
 *
 */
static int _DEL_MONSTER(dc2::script::RunArguments, int) {
    mgCMemory         *monster_stack = {};
    int                j = {};
    int                i = {};
    CMonsterMan       *monster_man = {};
    DNG_BATTLE_AREA   *area = {};
    mgCTextureManager *manager = {};
    area = &EventScene->battle_area;

    if (area == nullptr) {
        return false;
    }

    RocketLauncher.Clear();

    for (i = 0; i < 16; i++) {
        MachineGun.active[i] = 0;
        MachineGun.col_prim_id[i] = -1;
    }

    MachineGun.index = 0;
    LaserGun.Clear();

    if (ActiveMonster == nullptr) {
        return false;
    }

    ActiveMonster->Initialize(EventScene);
    EventScene->ClearStack(3);
    EventScene->AssignStack(3);
    monster_stack = EventScene->GetStack(3);
    monster_man = ActiveMonster;

    if (monster_stack == nullptr) {
        return false;
    }

    for (j = 0; j < PortMonsterActiveLimit(); j++) {
        if (monster_stack->stGetRest() <= 0xFA0 + 3) {
            return false;
        }
        u_long128 *buffer = monster_stack->stAlloc64(0xFA0);
        if (buffer == nullptr) {
            return false;
        }
        mgCMemory *memory = &monster_man->memory[j];
        memory->stSetChildBuffer(*monster_stack, buffer, 0xFA0);
        memory->stReset();
    }

    ColPrimMan.Initialize(DngMainScene);
    FxScriptMan->ClearBaseFromLevel(3);
    manager = &mgTexManager;

    for (j = area->free_texb; j < MONSTER_TEXB_FREE_END; j++) {
        manager->DeleteBlock(j);
    }

    sndInitPort(SND_PORT_ENEMY);
    return true;
}

/**
 *
 * Sets a menu value or runs a menu step, by the sub-command on the stack.
 *
 */
static int _SET_MENU_ETC(dc2::script::RunArguments stack) {
    int command = dc2::script::RunInteger(stack++);

    if (command == EVENT_SET_MENU_KEYWORD) {
        char *topic = dc2::script::RunCString(stack++);
        char *keyword = dc2::script::RunCString(stack++);
        SetEventKeyword(keyword, topic, dc2::script::RunInteger(stack));
        return true;
    }

    if (command == EVENT_SET_MENU_FINISH_TOUR) {
        AquaFishFatigueClear();
        CSaveData *save_data = GetSaveData();

        if (save_data == nullptr) {
            return false;
        }

        save_data->FinishTour();
        return true;
    }

    if (command == EVENT_SET_MENU_UNUSED_2) {
        return true;
    }

    if (command == EVENT_SET_MENU_DL_SWITCH) {
        DrawDownLoadAnaunceSwitch(dc2::script::RunInteger(stack));
        return true;
    }

    if (command == EVENT_SET_MENU_DL_INIT) {
        InitMenuDl(nullptr, 0);
        return true;
    }

    if (command == EVENT_SET_MENU_DL_ANNOUNCE) {
        int        stack_no = dc2::script::RunInteger(stack++);
        int        town_no = dc2::script::RunInteger(stack);
        mgCMemory *memory = EventScene->GetStack(stack_no);

        if (memory == nullptr) {
            return false;
        }

        InitDownLoadAnaunce(memory);
        MakeDownLoadAnaunce(town_no, memory, nullptr, nullptr, nullptr);
        InitMenuDl3(mgTexManager.GetTexture("eventdl", -1));
        return true;
    }

    if (command == EVENT_SET_MENU_UNUSED_6) {
        return true;
    }

    if (command == EVENT_SET_MENU_DL_ANNOUNCE_END) {
        InitDownLoadAnaunce(nullptr);
        return true;
    }

    return false;
}

/**
 *
 * Gives a menu value, by the sub-command on the stack.
 *
 */
static int _GET_MENU_ETC(dc2::script::RunArguments stack, int argc) {
    float size = {};
    float weight = {};
    int   total = {};
    int   result = {};
    int   status = {};
    int   command = dc2::script::RunInteger(stack++);

    if (command == EVENT_GET_MENU_SPHEDA_CLEAR) {
        SetStack(stack, GetCountSphedaClear());
        return true;
    }

    if (command == EVENT_GET_MENU_SQUARE_EVENT) {
        SetStack(stack, GetSquareEvent());
        return true;
    }

    if (command == EVENT_GET_MENU_FISH_RECORD) {
        CSaveData *save_data = GetSaveData();

        if (save_data == nullptr) {
            return false;
        }

        CUserDataManager *user_data = &save_data->user_data;

        if (user_data == nullptr) {
            return false;
        }

        user_data->GetFishRecord(dc2::script::RunInteger(stack++), &size, &weight);
        SetStack(stack, size);
        return true;
    }

    if (command == EVENT_GET_MENU_KNOW_SCOOP || command == EVENT_GET_MENU_CHECK_SCOOP || command == EVENT_GET_MENU_SCOOP_TOTAL) {
        CSaveData *save_data = GetSaveData();

        if (save_data == nullptr) {
            return false;
        }

        CUserDataManager *user_data = &save_data->user_data;

        if (user_data == nullptr) {
            return false;
        }

        CInventUserData   *invent_data = &user_data->invent_data;
        CScoopDataManager *scoop = &invent_data->scoop;

        if (invent_data == nullptr) {
            return false;
        }

        if (scoop == nullptr) {
            return false;
        }

        if (command == EVENT_GET_MENU_KNOW_SCOOP) {
            result = scoop->KnowScoop();
            SetStack(stack, result);
            return true;
        }

        if (command == EVENT_GET_MENU_CHECK_SCOOP) {
            result = scoop->CheckScoop();
            SetStack(stack, result);
            return true;
        }

        if (command == EVENT_GET_MENU_SCOOP_TOTAL) {
            result = scoop->GetScoopTotal(&total);
            SetStack(stack++, result);
            SetStack(stack, total);
            return true;
        }
    }

    if (command == EVENT_GET_MENU_DONY_SHOP) {
        SetStack(stack++, GetDonyShopLineUp(nullptr, &status));
        SetStack(stack, status);
        return true;
    }

    if (command == EVENT_GET_MENU_DL_STEP) {
        result = StepDownLoadAnaunce(dc2::script::RunInteger(stack++));
        SetStack(stack, result);
        return true;
    }

    if (command == EVENT_GET_MENU_DL_MENU_STEP) {
        SetStack(stack, StepMenuDl3());
        return true;
    }

    return false;
}

/**
 *
 * Gives the analyze flag of a map condition, from the analyze id on the stack.
 *
 */
static int _GET_ANALYZE(dc2::script::RunArguments stack, int argc) {
    int        analyze_id = dc2::script::RunInteger(stack++);
    int        map_no = analyze_id / 100 - 1;
    int        condition_no = analyze_id % 100;
    CSaveData *save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    CEditData *edit_data = save->GetEditData(map_no);

    if (edit_data == nullptr) {
        return false;
    }

    SetStack(stack, edit_data->GetAnalyzeFlag(map_no, condition_no));
    return true;
}

/**
 *
 * Gives the analyze percentage of the map on the stack.
 *
 */
static int _GET_DIORAMA_PERCENT(dc2::script::RunArguments stack, int argc) {
    int        map_no = dc2::script::RunInteger(stack++);
    CSaveData *save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    CEditData *edit_data = save->GetEditData(map_no);

    if (edit_data == nullptr) {
        return false;
    }

    SetStack(stack, edit_data->GetAnalyzePercent(map_no));
    return true;
}

/**
 *
 * Runs a georama script command and returns its status.
 *
 */
static int _GEORAMA_FUNC(dc2::script::RunArguments stack, int argc) {
    GeoFuncParam param{};

    param.scene = EventScene;
    return GeoramaFunc(&param, stack, argc);
}

/**
 *
 * Gives the scene character id that matches the id on the stack.
 *
 */
static int _GET_CHARA_ID(dc2::script::RunArguments stack) {
    int id = dc2::script::RunInteger(stack++);
    int chara_id = EventScene->SearchCharaID(id);
    SetStack(stack, chara_id);
    return true;
}

/**
 *
 * Requests a switch to edit mode.
 *
 */
static int _GOTO_EDITMODE(dc2::script::RunArguments, int) {
    EdEventInfo.request = EVENT_REQUEST_EDIT_MODE;
    return true;
}

/**
 *
 * Gives the current chapter of the save data.
 *
 */
static int _GET_CHAPTER(dc2::script::RunArguments stack, int argc) {
    CSaveData *save = {};

    save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    SetStack(stack, GetNowChapter(save));
    return true;
}

/**
 *
 * Gives a value of the villager training table, at the column and row on the stack.
 *
 */
static int _GET_NPC_TRAIN_ETC(dc2::script::RunArguments stack) {
    NpcTrainTable table = {
        {
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
         }
    };
    int column = dc2::script::RunInteger(stack++);
    int row = dc2::script::RunInteger(stack++) - 1;
    SetStack(stack, table.value[row][column]);
    return true;
}

/**
 *
 * Registers a villager with its character number, using the memory stack when two arguments are given.
 *
 */
static int _REGISTER_VILLAGER(dc2::script::RunArguments stack, int argc) {
    int no = dc2::script::RunInteger(stack++);
    int chara_no = dc2::script::RunInteger(stack++);

    if (argc == 2) {
        mgCMemory *memory = EventScene->GetStack(4);

        if (memory == nullptr) {
            return false;
        }

        EventScene->RegisterVillager(no, chara_no, memory);
        return true;
    } else if (argc == 3) {
        EventScene->RegisterVillager(no, chara_no, dc2::script::RunInteger(stack));
        return true;
    }

    return false;
}

/**
 *
 * Turns the drawing of the eye view on or off.
 *
 */
static int _EYE_VIEW_DRAW_ON_OFF(dc2::script::RunArguments stack) {
    EventScene->EyeViewDrawOnOff(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Sets or clears a quest request, by the sub-command on the stack.
 *
 */
static int _SET_QUEST_ETC(dc2::script::RunArguments stack) {
    int command = dc2::script::RunInteger(stack++);
    int quest_no = dc2::script::RunInteger(stack++);
    int flag = dc2::script::RunInteger(stack);

    switch (command) {
        case EVENT_SET_QUEST_FLAG:
            QuestRequestSetFlag(quest_no, flag);
            break;
        case EVENT_SET_QUEST_CLEAR:
            QuestRequestClear(quest_no, flag);
            break;
        default:
            return false;
    }

    return true;
}

/**
 *
 * Gives the status of a quest request, by the sub-command on the stack.
 *
 */
static int _GET_QUEST_ETC(dc2::script::RunArguments stack, int argc) {
    int command = dc2::script::RunInteger(stack++);
    int quest_no = dc2::script::RunInteger(stack++);

    switch (command) {
        case EVENT_GET_QUEST_STATUS:
            SetStack(stack, GetQuestRequestStatus(quest_no));
            break;
        default:
            return false;
    }

    return true;
}

/**
 *
 * Gives the number of the previous interior map.
 *
 */
static int _GET_OLD_INTERIOR_MAP_NO(dc2::script::RunArguments stack, int argc) {
    SetStack(stack, GetOldInteriorMapNo());
    return true;
}

/**
 *
 * Sets a field of the scene's event data, selected by the field on the stack.
 *
 */
static int _SET_EVENT_DATA(dc2::script::RunArguments stack, int argc) {
    CSceneEventData *event_data = {};
    auto             value = stack;

    event_data = &EventScene->event_data;

    if (event_data == nullptr) {
        return false;
    }

    value = stack + 1;

    switch (dc2::script::RunInteger(stack)) {
        case EVENT_DATA_FLAG:
            event_data->event.flag = dc2::script::RunInteger(value);
            break;
        case EVENT_DATA_EVENT_NO:
            event_data->event.event_no = dc2::script::RunInteger(value);
            break;
        case EVENT_DATA_POINT_NO:
            event_data->event.point_no = dc2::script::RunInteger(value);
            break;
        case EVENT_DATA_ARG1:
            event_data->event.arg1 = dc2::script::RunInteger(value);
            break;
        case EVENT_DATA_ARG2:
            event_data->event.arg2 = dc2::script::RunInteger(value);
            break;
        case EVENT_DATA_ARG3:
            event_data->event.arg3 = dc2::script::RunInteger(value);
            break;
        case EVENT_DATA_MAP_CHECK_TYPE:
            event_data->map_event.check_type = dc2::script::RunInteger(value);
            break;
        case EVENT_DATA_MAP_EVENT_NO:
            event_data->map_event.event_no = dc2::script::RunInteger(value);
            break;
        case EVENT_DATA_CHARA_SLOT:
            event_data->chara_slot = dc2::script::RunInteger(value);
            break;
        case EVENT_DATA_CHARA_NO:
            event_data->chara_no = dc2::script::RunInteger(value);
            break;
        default:
            return false;
    }

    return true;
}

/**
 *
 * Starts, stops or sets up the event stopwatch, by the sub-command on the stack.
 *
 */
static int _STOPWATCH(dc2::script::RunArguments stack, int argc) {
    CSaveData *save_data = GetSaveData();

    if (save_data == nullptr) {
        return false;
    }

    int mode = dc2::script::RunInteger(stack++);

    if (mode == EVENT_STOPWATCH_START) {
        PlayTimeCount(1);
        EdEventInfo.stopwatch_start = save_data->play_time;

        if (EdEventInfo.stopwatch_start == 0) {
            EdEventInfo.stopwatch_start = 1;
        }

        return true;
    }

    if (mode == EVENT_STOPWATCH_STOP) {
        if (EdEventInfo.stopwatch_start == 0) {
            EdEventInfo.stopwatch_start = 0;
            SetStack(stack, -1);
            return true;
        } else {
            u64 elapsed = PAL_TIMING(save_data->play_time - EdEventInfo.stopwatch_start, (save_data->play_time - EdEventInfo.stopwatch_start) * 6 / 5);
            EdEventInfo.stopwatch_start = 0;
            SetStack(stack++, static_cast<int>(elapsed / 3600));
            SetStack(stack++, static_cast<int>(elapsed % 3600 / 60));
            SetStack(stack++, static_cast<int>(elapsed % 60 * 100 / 60));
            SetStack(stack++, elapsed < 7261);
            return true;
        }
    }

    if (mode == EVENT_STOPWATCH_SET_LIMIT) {
        EdEventInfo.stopwatch_limit = dc2::script::RunInteger(stack);
        return true;
    }

    if (mode == EVENT_STOPWATCH_SET_LAYOUT) {
        EdEventInfo.stopwatch_x = dc2::script::RunInteger(stack++);
        EdEventInfo.stopwatch_y = dc2::script::RunInteger(stack++);
        EdEventInfo.stopwatch_style = dc2::script::RunInteger(stack);
        return true;
    }

    return false;
}

/**
 *
 * Requests a map change that restarts or resets the town's edit event, by the sub-command on the stack.
 *
 */
static int _SET_FUNC_ETC(dc2::script::RunArguments stack) {
    u32 *flags = {};

    flags = &EventScene->event_data.event.flag;

    if (flags == nullptr) {
        return false;
    }

    if (flags == nullptr) {
        return false;
    }

    switch (dc2::script::RunInteger(stack)) {
        case EVENT_SET_FUNC_RESTART_EDIT:
            *flags |= 0x80;
            EdEventInfo.request = EVENT_REQUEST_RESTART_EDIT;
            break;
        case EVENT_SET_FUNC_RESET_EDIT:
            EdEventInfo.request = EVENT_REQUEST_RESET_EDIT;
            break;
        default:
            return false;
    }

    return true;
}

/**
 *
 * Gives the character with the id.
 *
 */
static CCharacter2 *GetChara(int id) {
    return GetCharacter(id);
}

/**
 *
 * Gives the position of the character with the id on the stack.
 *
 */
static int _GET_CHARA_POS(dc2::script::RunArguments stack, int argc) {
    float        pos[4];
    auto         out = stack;
    CCharacter2 *chara = {};

    out = stack + 1;
    chara = GetChara(dc2::script::RunInteger(stack));

    if (chara == nullptr) {
        return false;
    }

    chara->GetPosition(pos);
    SetOutputVector(out, {pos[0], pos[1], pos[2]});
    out = out + 3;
    return true;
}

/**
 *
 * Gives the screen position of the character with the id on the stack.
 *
 */
static int _GET_CHARA_TALK_POS(dc2::script::RunArguments stack, int argc) {
    int          screen_pos[2];
    auto         out = stack;
    CCharacter2 *chara = {};

    out = stack + 1;
    chara = GetChara(dc2::script::RunInteger(stack));

    if (chara == nullptr) {
        return false;
    }

    GetScrPosFromChar(chara, screen_pos);
    SetStack(out++, screen_pos[0]);
    SetStack(out, screen_pos[1]);
    return true;
}

/**
 *
 * Turns the character with the id on the stack toward a target position, at the rate on the stack.
 *
 */
static int _TURN_CHARA(dc2::script::RunArguments stack) {
    CCharacter2 *chara = {};
    float        target[4];
    float        pos[4];
    float        rot[4];
    float        diff[4];
    float        rate = {};
    float        angle = {};
    float       *yaw = {};

    chara = GetChara(dc2::script::RunInteger(stack++));

    if (chara == nullptr) {
        return false;
    }

    target[0] = dc2::script::RunFloat(stack++);
    target[1] = dc2::script::RunFloat(stack++);
    target[2] = dc2::script::RunFloat(stack++);
    rate = dc2::script::RunFloat(stack);
    chara->GetPosition(pos);
    chara->GetRotation(rot);
    sceVu0SubVector(diff, target, pos);
    angle = atan2f(diff[0], diff[2]);
    yaw = &rot[1];
    *yaw = mgAngleInterpolate(*yaw, angle, rate, 0);
    chara->SetRotation(rot);
    return true;
}

/**
 *
 * Sets the position of a character, from direct arguments or an argument list.
 *
 */
static int _SET_CHARA_POS(dc2::script::RunArguments stack, int argc) {
    float pos[4];

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            CCharacter2 *chara = {};

            if ((chara = GetChara(GetArgInt(args++))) == nullptr) {
                return false;
            }

            GetArgVector(pos, args);
            chara->SetPosition(pos);
            break;
        }
        case 4: {
            CCharacter2 *chara = {};

            if ((chara = GetChara(dc2::script::RunInteger(stack++))) == nullptr) {
                return false;
            }

            GetStackVector(pos, stack);
            chara->SetPosition(pos);
            break;
        }
        default:
            return false;
    }

    return true;
}

/**
 *
 * Sets the rotation of a character, from direct arguments or an argument list.
 *
 */
static int _SET_CHARA_ROT(dc2::script::RunArguments stack, int argc) {
    float        rot[4];
    CCharacter2 *chara = {};

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            if ((chara = GetChara(GetArgInt(args++))) == nullptr) {
                return false;
            }

            GetArgVector(rot, args);
            break;
        }
        case 4:
            if ((chara = GetChara(dc2::script::RunInteger(stack++))) == nullptr) {
                return false;
            }

            GetStackVector(rot, stack);
            break;
        default:
            return false;
    }

    rot[0] = mgAngleLimit(rot[0]);
    rot[1] = mgAngleLimit(rot[1]);
    rot[2] = mgAngleLimit(rot[2]);
    chara->SetRotation(rot);
    return true;
}

/**
 *
 * Gives the rotation of the character with the id on the stack.
 *
 */
static int _GET_CHARA_ROT(dc2::script::RunArguments stack, int argc) {
    float        pos[4];
    auto         out = stack;
    CCharacter2 *chara = {};

    out = stack + 1;
    chara = GetChara(dc2::script::RunInteger(stack));

    if (chara == nullptr) {
        return false;
    }

    chara->GetRotation(pos);
    SetOutputVector(out, {pos[0], pos[1], pos[2]});
    out = out + 3;
    return true;
}

/**
 *
 * Sets the motion of a character, from direct arguments or an argument list.
 *
 */
static int _SET_MOTION(dc2::script::RunArguments stack, int argc) {
    CCharacter2 *chara = {};
    char        *name = {};
    int          flags = 0;
    int          reset = 0;
    float        step = -1.0f;

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack), argc);

            if (args.Remaining() == 0) {
                return false;
            }

            if ((chara = GetChara(GetArgInt(args++))) == nullptr) {
                return false;
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
            if ((chara = GetChara(dc2::script::RunInteger(stack++))) == nullptr) {
                return false;
            }

            name = dc2::script::RunCString(stack++);

            if (argc >= 3) {
                flags = dc2::script::RunInteger(stack++);
            }

            if (argc >= 4) {
                step = dc2::script::RunFloat(stack++);
            }

            if (argc >= 5) {
                reset = dc2::script::RunInteger(stack);
            }

            break;
        default:
            return false;
    }

    if (reset != 0) {
        chara->ResetMotion();
    }

    chara->SetMotion(name, flags);

    if (argc >= 4) {
        if (step != -1.0f && (flags & CHARA_MOTION_RESTART)) {
            chara->NormalDrive();
            chara->SetStep(step);
        }
    }

    return true;
}

/**
 *
 * Sets the step of the character with the id on the stack.
 *
 */
static int _SET_STEP(dc2::script::RunArguments stack) {
    CCharacter2 *chara = GetChara(dc2::script::RunInteger(stack++));

    if (chara == nullptr) {
        return false;
    }

    chara->SetStep(dc2::script::RunFloat(stack));
    return true;
}

/**
 *
 * Turns the texture animation of a character's texture bank on or off, optionally for one named animation.
 *
 */
static int _SET_TEX_ANIM(dc2::script::RunArguments stack, int argc) {
    int                chara_id = {};
    int                enable = {};
    char              *name = {};
    int                tex_bank = {};
    mgCTextureManager *manager = {};

    chara_id = dc2::script::RunInteger(stack++);
    enable = dc2::script::RunInteger(stack++);
    name = nullptr;

    if (argc > 2) {
        name = dc2::script::RunCString(stack);
    }

    tex_bank = EventScene->GetCharaTexb(chara_id);

    if (tex_bank < 0) {
        return false;
    }

    manager = &mgTexManager;

    if (enable != 0) {
        manager->TexAnimeOn(tex_bank, name);
    } else if (name != nullptr) {
        manager->TexAnimeOff(tex_bank, name);
    } else {
        manager->TexAnimeAllOff(tex_bank);
    }

    return true;
}

/**
 *
 * Sets the scale of a character, from direct arguments or an argument list.
 *
 */
static int _SET_SCALE(dc2::script::RunArguments stack, int argc) {
    float        scale[4];
    CCharacter2 *chara = {};

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            if ((chara = GetChara(GetArgInt(args++))) == nullptr) {
                return false;
            }

            GetArgVector(scale, args);
            break;
        }
        case 4:
            if ((chara = GetChara(dc2::script::RunInteger(stack++))) == nullptr) {
                return false;
            }

            GetStackVector(scale, stack);
            break;
        default:
            return false;
    }

    chara->SetScale(scale);
    return true;
}

/**
 *
 * Sets a frame of one character as the reference of a frame of another character.
 *
 */
static int _SET_REFERENCE(dc2::script::RunArguments stack) {
    int          chara_id = {};
    char        *frame_name = {};
    int          reference_id = {};
    CCharacter2 *chara = {};
    CCharacter2 *reference_chara = {};
    mgCFrame    *frame = {};
    mgCFrame    *child = {};

    chara_id = dc2::script::RunInteger(stack++);
    frame_name = dc2::script::RunCString(stack++);
    reference_id = dc2::script::RunInteger(stack);
    chara = GetChara(chara_id);

    if (chara == nullptr) {
        return false;
    }

    reference_chara = GetChara(reference_id);

    if (reference_chara == nullptr) {
        return false;
    }

    frame = chara->CObjectFrame::frame;

    if (frame == nullptr) {
        return false;
    }

    child = frame->SearchFrame(frame_name);

    if (child == nullptr) {
        return false;
    }

    frame = reference_chara->CObjectFrame::frame;

    if (frame == nullptr) {
        return false;
    }

    frame->SetReference(child);
    return true;
}

/**
 *
 * Deletes the reference of a character's frame.
 *
 */
static int _DEL_REFERENCE(dc2::script::RunArguments stack) {
    mgCFrame    *frame = {};
    CCharacter2 *chara = {};

    chara = GetChara(dc2::script::RunInteger(stack));

    if (chara == nullptr) {
        return false;
    }

    frame = chara->CObjectFrame::frame;

    if (frame == nullptr) {
        return false;
    }

    frame->DeleteReference();
    return true;
}

/**
 *
 * Turns the clipping of a character's shadow off or back on, by the flag after the id.
 *
 */
static int _SHADOW_CLIP_OFF(dc2::script::RunArguments stack, int argc) {
    int          chara_id = {};
    CCharacter2 *chara = {};
    int          clip_off = {};

    clip_off = 1;
    chara_id = dc2::script::RunInteger(stack++);

    if (argc > 0) {
        clip_off = dc2::script::RunInteger(stack);
    }

    chara = GetChara(chara_id);

    if (chara == nullptr) {
        return false;
    }

    if (chara->shadow_frame == nullptr) {
        return false;
    }

    mgCFrameAttr attr;
    attr.no_cull = clip_off;
    chara->shadow_frame->SetAttrParam(attr, 1, MG_FRAME_ATTR_NO_CULL);
    return true;
}

/**
 *
 * Gives the angle from a character's position toward a target position on the stack.
 *
 */
static int _GET_COORDINATE_ANGLE(dc2::script::RunArguments stack) {
    float target[4];
    float pos[4];
    float direction[4];
    float angle = {};
    int   chara_no = dc2::script::RunInteger(stack++);
    target[0] = dc2::script::RunFloat(stack++);
    target[1] = dc2::script::RunFloat(stack++);
    target[2] = dc2::script::RunFloat(stack++);
    target[3] = 1.0f;
    CCharacter2 *chara = {};

    if ((chara = GetChara(chara_no)) == nullptr) {
        return false;
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
    return true;
}

/**
 *
 * Gives the body width of the character with the id on the stack.
 *
 */
static int _GET_CHARA_WIDTH(dc2::script::RunArguments stack, int argc) {
    auto         next_slot = stack;
    CCharacter2 *chara = {};

    next_slot = stack + 1;
    chara = GetChara(dc2::script::RunInteger(stack));

    if (chara == nullptr) {
        return false;
    }

    SetStack(next_slot, chara->body_width);
    return true;
}

/**
 *
 * Gives the body height of the character with the id on the stack.
 *
 */
static int _GET_CHARA_HEIGHT(dc2::script::RunArguments stack, int argc) {
    auto         next_slot = stack;
    CCharacter2 *chara = {};

    next_slot = stack + 1;
    chara = GetChara(dc2::script::RunInteger(stack));

    if (chara == nullptr) {
        return false;
    }

    SetStack(next_slot, chara->body_height);
    return true;
}

/**
 *
 * Gives the body depth of the character with the id on the stack.
 *
 */
static int _GET_CHARA_WEIGHT(dc2::script::RunArguments stack, int argc) {
    auto         next_slot = stack;
    CCharacter2 *chara = {};

    next_slot = stack + 1;
    chara = GetChara(dc2::script::RunInteger(stack));

    if (chara == nullptr) {
        return false;
    }

    SetStack(next_slot, chara->body_depth);
    return true;
}

/**
 *
 * Shows or hides a character, optionally with a fade.
 *
 */
static int _SET_CHARA_SHOW(dc2::script::RunArguments stack, int argc) {
    CCharacter2 *character = {};
    int          show = {};
    int          fade = {};
    float        fade_speed = {};

    if ((character = GetChara(dc2::script::RunInteger(stack++))) == nullptr) {
        return false;
    }

    fade_speed = 0.1f;
    fade = 0;
    show = dc2::script::RunInteger(stack++);

    if (argc >= 3) {
        fade = dc2::script::RunInteger(stack++);

        if (argc == 4) {
            fade_speed = dc2::script::RunFloat(stack);
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

    return true;
}

/**
 *
 * Gives whether a character is shown, and its fade when two values are requested.
 *
 */
static int _GET_CHARA_SHOW(dc2::script::RunArguments stack, int argc) {
    CCharacter2 *character = {};

    if ((character = GetChara(dc2::script::RunInteger(stack++))) == nullptr) {
        return false;
    }

    SetStack(stack++, character->GetShow());

    if (argc == 2) {
        SetStack(stack, character->fade);
    }

    return true;
}

/**
 *
 * Sets whether a character's D-animation is enabled.
 *
 */
static int _CHARA_DA_ENABLE(dc2::script::RunArguments stack, int argc) {
    CCharacter2 *chara = {};
    auto         next_slot = stack;

    next_slot = stack + 1;

    if ((chara = GetChara(dc2::script::RunInteger(stack))) == nullptr) {
        return false;
    }

    chara->SetDAnimeEnable(dc2::script::RunInteger(next_slot));
    return true;
}

/**
 *
 * Gives the frame wait of a character's current motion.
 *
 */
static int _GET_MOT_NOW_WAIT(dc2::script::RunArguments stack, int argc) {
    if (argc != 2) {
        return false;
    }

    CCharacter2 *character = GetChara(dc2::script::RunInteger(stack++));

    if (character == nullptr) {
        return false;
    }

    SetStack(stack, character->GetNowFrameWait());
    return true;
}

/**
 *
 * Gives whether the motion of a character has ended.
 *
 */
static int _CHECK_MOTION_END(dc2::script::RunArguments stack, int argc) {
    if (argc != 2) {
        return false;
    }

    CCharacter2 *character = GetChara(dc2::script::RunInteger(stack++));

    if (character == nullptr) {
        return false;
    }

    SetStack(stack, character->CheckMotionEnd());
    return true;
}

/**
 *
 * Sets the motion of an action character, from direct arguments or an argument list.
 *
 */
static int _ACTCHR_SET_MOTION(dc2::script::RunArguments stack, int argc) {
    CActionChara *chara = {};
    char         *name = {};
    int           flags = 0;
    int           reset = 0;
    float         step = -1.0f;

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack), argc);

            if (args.Remaining() == 0) {
                return false;
            }

            if ((chara = static_cast<CActionChara *>(GetChara(GetArgInt(args++)))) == nullptr) {
                return false;
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
            if ((chara = static_cast<CActionChara *>(GetChara(dc2::script::RunInteger(stack++)))) == nullptr) {
                return false;
            }

            name = dc2::script::RunCString(stack++);

            if (argc >= 3) {
                flags = dc2::script::RunInteger(stack++);
            }

            if (argc >= 4) {
                step = dc2::script::RunFloat(stack++);
            }

            if (argc >= 5) {
                reset = dc2::script::RunInteger(stack);
            }

            break;
        default:
            return false;
    }

    if (reset != 0) {
        chara->ResetMotion();
    }

    chara->SetMotion(name, flags, 1);

    if (argc >= 4) {
        if (step != -1.0f && (flags & CHARA_MOTION_RESTART)) {
            chara->NormalDrive();
            chara->SetStep(step);
        }
    }

    return true;
}

/**
 *
 * Sets the second sound effect bank of an action character.
 *
 */
static int _SET_CHARA_EX_SOUNDID(dc2::script::RunArguments stack, int argc) {
    CActionChara *chara = {};
    auto          next_slot = stack;

    next_slot = stack + 1;
    chara = static_cast<CActionChara *>(GetChara(dc2::script::RunInteger(stack)));

    if (chara == nullptr) {
        return false;
    }

    chara->sound_info.se_bank_2 = dc2::script::RunInteger(next_slot);
    return true;
}

/**
 *
 * Copies the sound information of an action character.
 *
 */
static int _ACTCHR_SOUND_INFO_COPY(dc2::script::RunArguments stack) {
    CActionChara *chara = {};

    chara = static_cast<CActionChara *>(GetCharacter(dc2::script::RunInteger(stack)));

    if (chara == nullptr) {
        return false;
    }

    if (chara == nullptr) {
        return false;
    }

    chara->SetSoundInfoCopy();
    return true;
}

/**
 *
 * Gives the message window with the id.
 *
 */
ClsMes *GetMes(int id) {
    return GetEventMessage(id);
}

/**
 *
 * Makes a message window from a message number or a string on the stack, optionally giving its character count.
 *
 */
static int _MES_MAKE(dc2::script::RunArguments stack, int argc) {
    int         id = {};
    ClsMes     *mes = {};
    int         no = {};
    const char *text = {};
    id = dc2::script::RunInteger(stack++);
    mes = GetMes(id);

    if (mes == nullptr) {
        return false;
    }

    switch (stack.At().type) {
        case RS_INT:
            no = dc2::script::RunInteger(stack++);

            if (no == -1) {
                mes->MakeMesWin(no);
                return true;
            }

            if (mes->mes_data != nullptr && mes->mes_data_size >= 0) {
                if (mes->mes_data == nullptr) {
                    return false;
                }

                if (mes->mes_data_size <= 0) {
                    return false;
                }

                const auto source = mes->mes_data_storage.Bytes();
                if (source.size() != static_cast<std::size_t>(mes->mes_data_size) ||
                    source.data() != reinterpret_cast<const u8 *>(mes->mes_data)) {
                    return false;
                }
                const auto message = dc2::text::FindEventMessage(
                    std::span<const char>(reinterpret_cast<const char *>(source.data()), source.size()), no);
                text = message ? message->data() : nullptr;

                if (text == nullptr) {
                    return false;
                }

                mes->text_ptr = text;
                mes->MakeMesWin(mes->text_ptr, 0, 1);
            } else if (id == 0 && EdEventInfo.npc_talk_text != nullptr) {
                if (EdEventInfo.npc_talk_text == nullptr) {
                    return false;
                }

                if (EdEventInfo.npc_talk_size <= 0) {
                    return false;
                }

                const auto source = EdEventInfo.npc_talk_storage.Bytes();
                if (source.size() != static_cast<std::size_t>(EdEventInfo.npc_talk_size) ||
                    source.data() != reinterpret_cast<const u8 *>(EdEventInfo.npc_talk_text)) {
                    return false;
                }
                const auto message = dc2::text::FindEventMessage(
                    std::span<const char>(reinterpret_cast<const char *>(source.data()), source.size()), no);
                text = message ? message->data() : nullptr;

                if (text == nullptr) {
                    return false;
                }

                mes->text_ptr = text;
                mes->MakeMesWin(mes->text_ptr, 0, 1);
            } else {
                mes->MakeMesWin(no);
            }

            break;
        case RS_STR:
            mes->MakeMesWin(dc2::script::RunCString(stack++), 0, 1);
            break;
    }

    if (argc >= 3) {
        SetStack(stack, mes->char_num);
    }

    return true;
}

/**
 *
 * Closes a message window and resets its state.
 *
 */
static int _MES_CLOSE(dc2::script::RunArguments stack) {
    ClsMes *mes = {};

    mes = GetMes(dc2::script::RunInteger(stack));

    if (mes == nullptr) {
        return false;
    }

    mes->draw_speed = mes->GetDrawSpeedDef();
    mes->mes_no = -1;
    mes->text_ptr = nullptr;
    mes->open = 0;
    mes->fade = 0;
    mes->fukidashi_centre_x = -1;
    mes->fukidashi_centre_y = -1;
    return true;
}

/**
 *
 * Advances a message window to its next page while it waits for one.
 *
 */
static int _MES_NEXTPAGE(dc2::script::RunArguments stack) {
    ClsMes *mes = {};

    mes = GetMes(dc2::script::RunInteger(stack));

    if (mes == nullptr) {
        return false;
    }

    if (mes->scroll_wait != 0) {
        return true;
    }

    if (mes->page_wait == 0) {
        return true;
    }

    mes->GoNextPage();
    return true;
}

/**
 *
 * Sets the automatic placement of a message window, from four values or from two characters.
 *
 */
static int _SET_MES_AUTOSET(dc2::script::RunArguments stack, int argc) {
    int          values[4];
    int          chara_values[4];
    ClsMes      *mes = {};
    CCharacter2 *chara1 = {};
    CCharacter2 *chara2 = {};
    int          i = {};

    auto args = stack + 1;
    mes = GetMes(dc2::script::RunInteger(stack));

    if (mes == nullptr) {
        return false;
    }

    if (argc != 3) {
        if (argc != 5) {
            return false;
        }

        for (i = 0; i < 4; i++) {
            values[i] = dc2::script::RunInteger(args++);
        }

        mes->AutoSet(values);
    } else {
        chara1 = GetChara(dc2::script::RunInteger(args++));

        if (chara1 == nullptr) {
            return false;
        }

        chara2 = GetChara(dc2::script::RunInteger(args));

        if (chara2 == nullptr) {
            return false;
        }

        mes->AutoSetSub(chara1, chara2, chara_values);
        mes->AutoSet(chara_values);
    }

    return true;
}

/**
 *
 * Sets the balloon tail of a message window.
 *
 */
static int _SET_MES_SHIPPO(dc2::script::RunArguments stack, int argc) {
    ClsMes *mes = {};

    mes = GetMes(dc2::script::RunInteger(stack++));

    if (mes == nullptr) {
        return false;
    }

    mes->tail_on = dc2::script::RunInteger(stack++);

    if (argc > 2) {
        mes->tail_length = dc2::script::RunInteger(stack++);
    }

    if (argc > 3) {
        mes->tail_half_w = dc2::script::RunInteger(stack);
    }

    return true;
}

/**
 *
 * Sets the balloon position of a message window.
 *
 */
static int _SET_MES_POS(dc2::script::RunArguments stack, int argc) {
    ClsMes *mes = {};
    auto    next_slot = stack + 1;
    mes = GetMes(dc2::script::RunInteger(stack));

    if (mes == nullptr) {
        return false;
    }

    mes->fukidashi_pos = dc2::script::RunInteger(next_slot);
    return true;
}

/**
 *
 * Sets the draw speed of a message window, and optionally its default.
 *
 */
static int _SET_MES_DRAWSPEED(dc2::script::RunArguments stack, int argc) {
    ClsMes *mes = GetMes(dc2::script::RunInteger(stack++));

    if (mes == nullptr) {
        return false;
    }

    mes->draw_speed = dc2::script::RunFloat(stack++);

    if (argc > 2) {
        mes->draw_speed_def = dc2::script::RunFloat(stack);
    }

    return true;
}

/**
 *
 * Sets the selected option of a message window.
 *
 */
static int _SET_MES_CURSOR(dc2::script::RunArguments stack, int argc) {
    int     cursor = {};
    ClsMes *mes = {};
    auto    next_slot = stack + 1;
    mes = GetMes(dc2::script::RunInteger(stack));

    if (mes == nullptr) {
        return false;
    }

    cursor = dc2::script::RunInteger(next_slot);

    if (mes->select < 0) {
        mes->cursor_time = 0;
    }

    mes->select = cursor;
    return true;
}

/**
 *
 * Sets the button that advances a message window.
 *
 */
static int _SET_MES_OKURI(dc2::script::RunArguments stack, int argc) {
    ClsMes *mes = {};
    auto    next_slot = stack + 1;
    mes = GetMes(dc2::script::RunInteger(stack));

    if (mes == nullptr) {
        return false;
    }

    mes->push_button = dc2::script::RunInteger(next_slot);
    return true;
}

/**
 *
 * Sets the window mode of a message window on or off.
 *
 */
static int _SET_MES_WIN_FLAG(dc2::script::RunArguments stack, int argc) {
    ClsMes *mes = {};
    auto    next_slot = stack + 1;
    mes = GetMes(dc2::script::RunInteger(stack));

    if (mes == nullptr) {
        return false;
    }

    if (dc2::script::RunInteger(next_slot) != 0) {
        mes->window_mode = 1;
    } else {
        mes->window_mode = 0;
    }

    return true;
}

/**
 *
 * Gives whether a message window has finished showing its text.
 *
 */
static int _CHECK_MES_COMPLETE(dc2::script::RunArguments stack, int argc) {
    auto    next_slot = stack + 1;
    ClsMes *mes = {};
    mes = GetMes(dc2::script::RunInteger(stack));

    if (mes == nullptr) {
        return false;
    }

    SetStack(next_slot, mes->State() == CLSMES_SHOWN);
    return true;
}

/**
 *
 * Gives whether a message window waits for a page advance.
 *
 */
static int _CHECK_MES_WAIT(dc2::script::RunArguments stack, int argc) {
    auto    next_slot = stack + 1;
    ClsMes *mes = {};
    mes = GetMes(dc2::script::RunInteger(stack));

    if (mes == nullptr) {
        return false;
    }

    SetStack(next_slot, mes->State() == CLSMES_PAGE_WAIT);
    return true;
}

/**
 *
 * Gives whether a message window is closed.
 *
 */
static int _CHECK_MES(dc2::script::RunArguments stack, int argc) {
    auto    next_slot = stack + 1;
    ClsMes *mes = {};
    mes = GetMes(dc2::script::RunInteger(stack));

    if (mes == nullptr) {
        return false;
    }

    SetStack(next_slot, mes->State() == CLSMES_CLOSED);
    return true;
}

/**
 *
 * Sets a message window to balloon style.
 *
 */
static int _SET_MES_FUKIDASHI(dc2::script::RunArguments stack, int argc) {
    ClsMes *mes = {};
    auto    next_slot = stack + 1;
    mes = GetMes(dc2::script::RunInteger(stack));

    if (mes == nullptr) {
        return false;
    }

    dc2::script::RunInteger(next_slot);
    mes->SetWindowMode(1);
    return true;
}

/**
 *
 * Sets the window mode of a message window from the stack.
 *
 */
static int _SET_MES_WINDOW_MODE(dc2::script::RunArguments stack, int argc) {
    ClsMes *mes = {};
    auto    next_slot = stack + 1;
    mes = GetMes(dc2::script::RunInteger(stack));

    if (mes == nullptr) {
        return false;
    }

    mes->SetWindowMode(dc2::script::RunInteger(next_slot));
    return true;
}

/**
 *
 * Applies a preset to a message window.
 *
 */
static int _SET_MES_PRESET(dc2::script::RunArguments stack, int argc) {
    ClsMes *mes = {};
    auto    next_slot = stack + 1;
    mes = GetMes(dc2::script::RunInteger(stack));

    if (mes == nullptr) {
        return false;
    }

    mes->Preset(dc2::script::RunInteger(next_slot));
    return true;
}

/**
 *
 * Sets an item message slot of a message window to a value on the stack.
 *
 */
static int _SET_MES_ITEM_DIRECT(dc2::script::RunArguments stack, int argc) {
    ClsMes *mes = {};
    auto    args = stack + 1;
    int     slot = {};
    int     value = {};
    mes = GetMes(dc2::script::RunInteger(stack));

    if (mes == nullptr) {
        return false;
    }

    slot = dc2::script::RunInteger(args++);
    value = dc2::script::RunInteger(args);

    if (slot >= 1 && slot <= MES_VALUE_MAX) {
        mes->item_mes[slot - 1] = value;
    }

    return true;
}

/**
 *
 * Sets an item message slot of a message window to the message number of an item.
 *
 */
static int _SET_MES_ITEM(dc2::script::RunArguments stack, int argc) {
    ClsMes *mes = {};
    auto    args = stack + 1;
    int     slot = {};
    int     value = {};
    mes = GetMes(dc2::script::RunInteger(stack));

    if (mes == nullptr) {
        return false;
    }

    slot = dc2::script::RunInteger(args++);
    value = GetItemMessageNo(dc2::script::RunInteger(args), 1);

    if (slot >= 1 && slot <= MES_VALUE_MAX) {
        mes->item_mes[slot - 1] = value;
    }

    return true;
}

/**
 *
 * Sets a value of a message window, or its first value when the slot is 0.
 *
 */
static int _SET_MES_VALUE(dc2::script::RunArguments stack, int argc) {
    ClsMes *mes = {};
    auto    args = stack + 1;
    int     slot = {};
    int     value = {};
    mes = GetMes(dc2::script::RunInteger(stack));

    if (mes == nullptr) {
        return false;
    }

    slot = dc2::script::RunInteger(args++);
    value = dc2::script::RunInteger(args);

    if (slot < 0 || slot > MES_VALUE_MAX) {
        return false;
    }

    if (slot == 0) {
        mes->value = value;
    } else {
        mes->values[slot - 1] = value;
        mes->value_width[slot - 1] = 0;
    }

    return true;
}

/**
 *
 * Gives the state of a message window.
 *
 */
static int _GET_MES_STATUS(dc2::script::RunArguments stack, int argc) {
    auto    next_slot = stack + 1;
    ClsMes *mes = {};
    mes = GetMes(dc2::script::RunInteger(stack));

    if (mes == nullptr) {
        return false;
    }

    SetStack(next_slot, mes->State());
    return true;
}

/**
 *
 * Gives a party character's message for the kind on the stack, and an extra value for kind 4.
 *
 */
static int _GET_PARTY_CHARA_MES_NO(dc2::script::RunArguments stack, int) {
    const int      npc_id = dc2::script::RunInteger(stack++);
    const int      kind = dc2::script::RunInteger(stack++);
    auto          &message_output = dc2::script::RunOutput(stack++);
    NPC_BASE_DATA *npc_data = nullptr;
    RS_STACKDATA  *extra_output = nullptr;
    if (kind == 4) {
        extra_output = &dc2::script::RunOutput(stack);
        npc_data = GetPartyNPCData(npc_id);
        if (npc_data == nullptr) {
            return false;
        }
    }
    message_output.val.i = GetPartyCharaMessage(npc_id, kind, 1);
    if (extra_output != nullptr) {
        extra_output->val.i = npc_data->unk_31 + 3;
    }

    return true;
}

/**
 *
 * Sets the text buffer of a message window to the system or the default buffer, by the kind on the stack.
 *
 */
static int _MES_SET_BUFF(dc2::script::RunArguments stack, int argc) {
    ClsMes *mes = {};
    int     kind = {};
    auto    args = stack + 1;
    mes = GetMes(dc2::script::RunInteger(stack));

    if (mes == nullptr) {
        return false;
    }

    kind = dc2::script::RunInteger(args++);
    dc2::script::RunInteger(args);

    if (kind == 0) {
        mes->SetBuff(GetSysMesBuffer());
    } else {
        mes->SetBuff_system(GetSystemMesBuffer());
    }

    return true;
}

/**
 *
 * Gives the window mode of a message window.
 *
 */
static int _GET_MES_WINDOW_MODE(dc2::script::RunArguments stack, int argc) {
    auto    next_slot = stack + 1;
    ClsMes *mes = {};
    mes = GetMes(dc2::script::RunInteger(stack));

    if (mes == nullptr) {
        return false;
    }

    argc = mes->GetWindowMode();
    SetStack(next_slot, argc);
    return true;
}

/**
 *
 * Gives whether the event's voice stream is playing.
 *
 */
static int _GET_MES_VOICE(dc2::script::RunArguments stack) {
    SetStack(stack, EdEventInfo.stream_playing);
    return true;
}

/**
 *
 * Sets the top line of the selection of a message window.
 *
 */
static int _SET_MES_QUESTION_GYOU(dc2::script::RunArguments stack, int argc) {
    ClsMes *mes = {};
    auto    next_slot = stack + 1;
    mes = GetMes(dc2::script::RunInteger(stack));

    if (mes == nullptr) {
        return false;
    }

    mes->select_top = dc2::script::RunInteger(next_slot);
    return true;
}

/**
 *
 * Gives the top line of the selection of a message window.
 *
 */
static int _GET_MES_QUESTION_GYOU(dc2::script::RunArguments stack, int argc) {
    auto    next_slot = stack + 1;
    ClsMes *mes = {};

    mes = GetMes(dc2::script::RunInteger(stack));

    if (mes == nullptr) {
        return false;
    }

    SetStack(next_slot, mes->select_top);
    return true;
}

/**
 *
 * Sets the close time of a message window.
 *
 */
static int _SET_MES_CLOSE_CNT(dc2::script::RunArguments stack, int argc) {
    ClsMes *mes = {};
    auto    next_slot = stack + 1;
    mes = GetMes(dc2::script::RunInteger(stack));

    if (mes == nullptr) {
        return false;
    }

    mes->close_time = dc2::script::RunInteger(next_slot);
    return true;
}

/**
 *
 * Sets a message window option, by the sub-command on the stack.
 *
 */
static int _SET_MES_ETC(dc2::script::RunArguments stack, int argc) {
    int     i = {};
    ClsMes *mes = GetMes(dc2::script::RunInteger(stack++));

    if (mes == nullptr) {
        return false;
    }

    int command = dc2::script::RunInteger(stack++);

    switch (command) {
        case EVENT_SET_MES_LINE_INDENT:
            mes->line_indent_on = dc2::script::RunInteger(stack);
            break;
        case EVENT_SET_MES_CURSOR_CENTERING:
            mes->cursor_centering = dc2::script::RunInteger(stack);
            break;
        case EVENT_SET_MES_HALF_FONT_WIDTH:
            mes->SetHalfFontWPercent(dc2::script::RunFloat(stack));
            break;
        case EVENT_SET_MES_AQUARIUM_FISH: {
            std::string text = "\x8B\x9B\x82\xF0\x91\x49\x82\xD7";

            for (i = 0; i < 6; i++) {
                char *fish_name = GetAquariumFish0(i);

                if (fish_name != nullptr) {
                    text += '\n';
                    text += fish_name;
                }
            }

            mes->MakeMesWin(text.data(), 0, 1);
            break;
        }
        case EVENT_SET_MES_ABS_WINDOW:
            if (argc > 4) {
                mes->abs_win.x = dc2::script::RunInteger(stack++);
                mes->abs_win.y = dc2::script::RunInteger(stack++);
            }

            mes->abs_win.width = dc2::script::RunInteger(stack++);
            mes->abs_win.height = dc2::script::RunInteger(stack);
            break;
        case EVENT_SET_MES_LINE_SHADE: {
            int line = dc2::script::RunInteger(stack++);
            int shade = dc2::script::RunInteger(stack);

            if (line >= 0 && line < MES_LINE_MAX) {
                mes->line_shade[line] = shade;
            }

            break;
        }
        case EVENT_SET_MES_LINE_ALPHA: {
            int line = dc2::script::RunInteger(stack++);
            mes->line_alpha[line] = dc2::script::RunInteger(stack);
            break;
        }
        case EVENT_SET_MES_DEFAULT_COLOR: {
            int red = dc2::script::RunInteger(stack++);
            int green = dc2::script::RunInteger(stack++);
            int blue = dc2::script::RunInteger(stack++);
            int alpha = dc2::script::RunInteger(stack);
            mes->SetDefColor(red | (green << 8 | (alpha << 24 | blue << 16)));
            break;
        }
        case EVENT_SET_MES_FUCHI:
            mes->fuchi = dc2::script::RunInteger(stack);
            break;
        case EVENT_SET_MES_TEXT_OFFSET:
            mes->abs_text_off_x = dc2::script::RunInteger(stack++);
            mes->abs_text_off_y = dc2::script::RunInteger(stack);
            break;
        case EVENT_SET_MES_ALPHA:
            mes->alpha = dc2::script::RunInteger(stack);
            break;
        default:
            return false;
    }

    return true;
}

/**
 *
 * Gives a message window option, by the sub-command on the stack.
 *
 */
static int _GET_MES_ETC(dc2::script::RunArguments stack, int argc) {
    ClsMes *mes = {};
    auto    value = stack + 1;
    mes = GetMes(dc2::script::RunInteger(stack));

    if (mes == nullptr) {
        return false;
    }

    switch (dc2::script::RunInteger(value++)) {
        case EVENT_GET_MES_LINE_INDENT:
            SetStack(value, mes->line_indent_on);
            break;
        case EVENT_GET_MES_CURSOR_CENTERING:
            SetStack(value, mes->cursor_centering);
            break;
        case EVENT_GET_MES_AQUARIUM_FISH: {
            CUserDataManager *user_data = &GetSaveData()->user_data;

            if (user_data == nullptr) {
                return false;
            }

            CFishAquarium *aquarium = &user_data->aquarium;

            if (aquarium == nullptr) {
                return false;
            }

            int fish_num = aquarium->GetAquariumFishNum(AQUARIUM_TANK_FIRST);
            SetStack(value, fish_num);
            break;
        }
        case EVENT_GET_MES_VILLAGER_INFO: {
            CVillagerInfo *info = GetVillagerInfo(dc2::script::RunInteger(value++));

            if (info == nullptr) {
                return false;
            }

            SetStack(value++, info->unk_14);
            SetStack(value, info->unk_18);
            break;
        }
        default:
            return false;
    }

    return true;
}

int _LOAD_MES_sub(char *file_name, int stack_no, ClsMes *mes) {
    if (file_name == nullptr || mes == nullptr || EventScene == nullptr) {
        return false;
    }
    int        size = 0;
    const auto file_read = dc2::event::ReadFile(file_name);
    size = file_read.Size();
    const auto *source = reinterpret_cast<u32 *>(file_read.Bytes().data());
    if (source == nullptr || size <= 0) {
        return false;
    }
    auto *memory = EventScene->GetStack(stack_no);
    if (memory == nullptr || memory->lock != 0 || dc2::memory::RemainingBytes(*memory).empty()) {
        return false;
    }
    memory->Align64();
    auto *destination = dc2::memory::NewArray<char>(*memory, static_cast<std::size_t>(size) + 1);
    if (destination == nullptr) {
        return false;
    }
    std::memmove(destination, source, static_cast<std::size_t>(size));
    destination[size] = char{};
    const auto lease = dc2::memory::ArenaBuffer::Bind(*memory,
                                                      {reinterpret_cast<u8 *>(destination), static_cast<std::size_t>(size)});
    if (lease.Bytes().empty()) {
        return false;
    }
    mes->mes_data = destination;
    mes->mes_data_size = size;
    mes->mes_data_storage = lease;
    return true;
}

/**
 *
 * Loads a message file into a message window, or clears its data when given two arguments.
 *
 */
static int _LOAD_MES(dc2::script::RunArguments stack, int argc) {
    ClsMes *mes = GetMes(dc2::script::RunInteger(stack++));

    if (mes == nullptr) {
        return false;
    }

    if (argc == 2) {
        mes->mes_data = nullptr;
        mes->mes_data_size = 0;
        mes->mes_data_storage = {};
        return true;
    }

    int   stack_no = dc2::script::RunInteger(stack++);
    char *file_name = dc2::script::RunCString(stack);

    if (file_name != nullptr) {
        return _LOAD_MES_sub(file_name, stack_no, mes);
    }

    return false;
}

/**
 *
 * Loads the monster talk message file of the current dungeon into a message window.
 *
 */
static int _LOAD_MES_MONS_TALK(dc2::script::RunArguments stack) {
    char    path[0x80];
    ClsMes *mes = GetMes(dc2::script::RunInteger(stack++));

    if (mes == nullptr) {
        return false;
    }

    int       stack_no = dc2::script::RunInteger(stack);
    const int length = std::snprintf(path, sizeof path, "dungeon/msg/mostalk%d_%d.txt", DngStatus.dungeon_no, LanguageCode);
    if (length < 0 || static_cast<std::size_t>(length) >= sizeof path) {
        return false;
    }
    return _LOAD_MES_sub(path, stack_no, mes);
}

/**
 *
 * Plays the system sound effect for the kind on the stack.
 *
 */
static int _MES_SE_PLAY(dc2::script::RunArguments stack) {
    switch (dc2::script::RunInteger(stack)) {
        case 0:
            sndSePlay(SystemSND_ID, SYSTEM_SE_MESSAGE, 0);
            return true;
        case 1:
            sndSePlay(SystemSND_ID, SYSTEM_SE_MESSAGE, 0);
            return true;
        case 2:
            sndSePlay(SystemSND_ID, SYSTEM_SE_CURSOR, 0);
            return true;
        case 3:
            sndSePlay(SystemSND_ID, SYSTEM_SE_DECIDE, 0);
            return true;
        default:
            return false;
    }
}

/**
 *
 * Sets a name slot of a message window from a string on the stack.
 *
 */
static int _SET_MES_STR(dc2::script::RunArguments stack, int argc) {
    ClsMes *mes = GetMes(dc2::script::RunInteger(stack++));

    if (mes == nullptr) {
        return false;
    }

    const int name_no = dc2::script::RunInteger(stack++);
    if (name_no < 1 || name_no > MES_NAME_MAX) {
        return false;
    }

    const char *text = dc2::script::RunCString(stack);
    if (text != nullptr) {
        const std::string_view value(text);
        if (value.size() >= sizeof mes->name[0]) {
            return false;
        }
        dc2::text::Copy(mes->name[name_no - 1], value);
    }

    return true;
}

/**
 *
 * Gives the button that advances a message window.
 *
 */
static int _GET_MES_OKURI(dc2::script::RunArguments stack, int argc) {
    if (argc != 1) {
        return false;
    }

    ClsMes *mes = GetMes(dc2::script::RunInteger(stack++));

    if (mes == nullptr) {
        return false;
    }

    SetStack(stack, mes->push_button);
    return true;
}

/**
 *
 * Gives a fishing tournament value, by the sub-command on the stack.
 *
 */
static int _GET_FISHINGTOURNAMENT_ETC(dc2::script::RunArguments stack, int argc) {
    int                    shown = {};
    int                    i = {};
    int                    weight = {};
    char                  *name = {};
    int                    padding = {};
    CFishingTournament    *tournament = {};
    FISH_PRIZE_INFO        prize{};
    float                  size = {};
    ClsMes                *mes = {};
    FISH_TOURNAMENT_ENTRY *entry = {};
    int                    j = {};
    std::string            text;

    switch (dc2::script::RunInteger(stack++)) {
        case EVENT_GET_FISHING_RECORDS:
            tournament = GetFishTournament();
            shown = 0;

            if (tournament == nullptr) {
                return false;
            }

            for (i = 0; i < 10; i++) {
                entry = tournament->GetRecord(i);

                if (entry != nullptr) {
                    name = GetItemMessage(entry->item_no);

                    if (name != nullptr) {
                        size = entry->size / 10.0f;
                        weight = entry->weight;
                        std::string name_column(name);
                        padding = 0x16 - static_cast<int>(name_column.size());

                        for (j = 0; j < padding / 2; j++) {
                            name_column += "\x81\x40";
                        }

                        char      size_column[64];
                        const int size_length = std::snprintf(size_column, sizeof size_column, "%4.1fcm\x81\x40%5dg", size, weight);
                        if (size_length < 0 || static_cast<std::size_t>(size_length) >= sizeof size_column) {
                            return false;
                        }

                        switch (shown) {
                            case 0:
                                text = "\x81\x40\x82\x50\x81\x41";
                                break;
                            case 1:
                                text += "\x81\x40\x82\x51\x81\x41";
                                break;
                            case 2:
                                text += "\x81\x40\x82\x52\x81\x41";
                                break;
                            case 3:
                                text += "\x81\x40\x82\x53\x81\x41";
                                break;
                            case 4:
                                text += "\x81\x40\x82\x54\x81\x41";
                                break;
                            case 5:
                                text += "\x81\x40\x82\x55\x81\x41";
                                break;
                            case 6:
                                text += "\x81\x40\x82\x56\x81\x41";
                                break;
                            case 7:
                                text += "\x81\x40\x82\x57\x81\x41";
                                break;
                            case 8:
                                text += "\x81\x40\x82\x58\x81\x41";
                                break;
                            case 9:
                                text += "\x82\x50\x82\x4F\x81\x41";
                                break;
                            default:
                                return false;
                        }

                        shown++;
                        text += name_column;
                        text += size_column;

                        if (i < 9) {
                            text += '\n';
                        }
                    }
                }
            }

            mes = GetMes(dc2::script::RunInteger(stack));

            if (mes == nullptr) {
                return false;
            }

            if (0 < shown) {
                mes->MakeMesWin(text.data(), 0, 1);
            }

            break;
        case EVENT_GET_FISHING_PRIZE:
            if (GetFishPrize(0, dc2::script::RunInteger(stack++) - 1, &prize) == 0) {
                return false;
            }

            SetStack(stack++, prize.item_no);
            SetStack(stack, prize.num);
            break;
        case EVENT_GET_FISHING_ENTRY_LEFT:
            tournament = GetFishTournament();

            if (tournament == nullptr) {
                return false;
            }

            SetStack(stack, tournament->EntryRemain());
            break;
        case EVENT_GET_FISHING_TOP_WEIGHT:
            tournament = GetFishTournament();

            if (tournament == nullptr) {
                return false;
            }

            SetStack(stack, tournament->CalcTopWeight());
            break;
        case EVENT_GET_FISHING_RANK:
            tournament = GetFishTournament();

            if (tournament == nullptr) {
                return false;
            }

            SetStack(stack, tournament->rank);
            break;
        default:
            return false;
    }

    return true;
}

/**
 *
 * Sets the far drawing distance of a character.
 *
 */
static int _SET_CHARA_FAR_DIST(dc2::script::RunArguments stack) {
    CCharacter2 *chara = GetChara(dc2::script::RunInteger(stack++));

    if (chara == nullptr) {
        return false;
    }

    chara->SetFarDist(dc2::script::RunFloat(stack));
    return true;
}

/**
 *
 * Turns the lighting of a character's model, or of one named frame, on or off.
 *
 */
static int _SET_MODEL_LIGHT_SWITCH(dc2::script::RunArguments stack, int argc) {
    int          chara_no = dc2::script::RunInteger(stack++);
    CCharacter2 *chara = GetChara(chara_no);

    if (chara == nullptr) {
        return false;
    }

    int   on = dc2::script::RunInteger(stack++);
    char *name = nullptr;

    if (argc == 3) {
        name = dc2::script::RunCString(stack);
    }

    mgCFrame *frame = chara->CObjectFrame::frame;

    if (name != nullptr) {
        frame = frame->SearchFrame(name);
    }

    if (frame == nullptr) {
        return false;
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

    return true;
}

/**
 *
 * Sets the light colour of a character's model, or of one named frame.
 *
 */
static int _SET_MODEL_LIGHT_COLOR(dc2::script::RunArguments stack, int argc) {
    int          chara_no = dc2::script::RunInteger(stack++);
    CCharacter2 *chara = GetChara(chara_no);

    if (chara == nullptr) {
        return false;
    }

    float r = dc2::script::RunFloat(stack++);
    float g = dc2::script::RunFloat(stack++);
    float b = dc2::script::RunFloat(stack++);
    float a = dc2::script::RunFloat(stack++);
    char *name = nullptr;

    if (argc == 6) {
        name = dc2::script::RunCString(stack);
    }

    mgCFrame *frame = chara->CObjectFrame::frame;

    if (name != nullptr) {
        frame = frame->SearchFrame(name);
    }

    if (frame == nullptr) {
        return false;
    }

    mgCFrameAttr *attr = frame->attr;
    attr->no_light = 1;
    attr->color[0] = r;
    attr->color[1] = g;
    attr->color[2] = b;
    attr->color[3] = a;
    frame->SetAttrParam(*attr, 1, MG_FRAME_ATTR_COLOR);
    return true;
}

/**
 *
 * Gives the bonus-content flag.
 *
 */
static int _GET_OMAKE_FLAG(dc2::script::RunArguments stack) {
    SetStack(stack, OmakeFlag);
    return true;
}

/**
 *
 * Sets the wind power and direction, or resets the wind when the power is negative.
 *
 */
static int _SET_WIND(dc2::script::RunArguments stack) {
    float dir[4];
    float power = dc2::script::RunFloat(stack++);

    if (power < 0.0f) {
        EventScene->ResetWind();
        return true;
    }

    dir[0] = dc2::script::RunFloat(stack++);
    dir[1] = dc2::script::RunFloat(stack++);
    dir[2] = dc2::script::RunFloat(stack);
    dir[3] = 1.0f;
    EventScene->SetWind(power, dir);
    return true;
}

/**
 *
 * Sets the bonus-content flag.
 *
 */
static int _SET_OMAKE_FLAG(dc2::script::RunArguments stack) {
    OmakeFlag = dc2::script::RunInteger(stack);
    return true;
}

/**
 *
 * Returns the currently active camera.
 *
 */
static CCameraControl *GetCamera() {
    return static_cast<CCameraControl *>(GetActiveCamera());
}

/**
 *
 * Sets the active camera position from direct arguments or an argument list.
 *
 */
static int _SET_CAMERA_POS(dc2::script::RunArguments stack, int argc) {
    float      pos[4];
    mgCCamera *camera = {};

    if ((camera = GetCamera()) == nullptr) {
        return false;
    }

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            GetArgVector(pos, args);
            break;
        }
        case 3:
            GetStackVector(pos, stack);
            break;
        default:
            return false;
    }

    camera->SetPos(pos);
    return true;
}

/**
 *
 * Stores the active camera position into three stack slots.
 *
 */
static int _GET_CAMERA_POS(dc2::script::RunArguments stack, int argc) {
    float pos[4];

    if (argc < 3) {
        return false;
    }

    mgCCamera *camera = GetCamera();

    if (camera == nullptr) {
        return false;
    }

    camera->GetPos(pos);
    SetOutputVector(stack, {pos[0], pos[1], pos[2]});
    stack = stack + 2;
    return true;
}

/**
 *
 * Sets the active camera reference point from direct arguments or an argument list.
 *
 */
static int _SET_CAMERA_REF(dc2::script::RunArguments stack, int argc) {
    float      pos[4];
    mgCCamera *camera = {};

    if ((camera = GetCamera()) == nullptr) {
        return false;
    }

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            GetArgVector(pos, args);
            break;
        }
        case 3:
            GetStackVector(pos, stack);
            break;
        default:
            return false;
    }

    camera->SetRef(pos);
    return true;
}

/**
 *
 * Stores the active camera reference point into three stack slots.
 *
 */
static int _GET_CAMERA_REF(dc2::script::RunArguments stack, int argc) {
    float pos[4];

    if (argc < 3) {
        return false;
    }

    mgCCamera *camera = GetCamera();

    if (camera == nullptr) {
        return false;
    }

    camera->GetRef(pos);
    SetOutputVector(stack, {pos[0], pos[1], pos[2]});
    stack = stack + 2;
    return true;
}

/**
 *
 * Sets the active camera speed.
 *
 */
static int _SET_CAMERA_SPEED(dc2::script::RunArguments stack) {
    mgCCamera *camera = GetCamera();

    if (camera == nullptr) {
        return false;
    }

    camera->SetSpeed(dc2::script::RunFloat(stack), -1.0f);
    return true;
}

/**
 *
 * Advances the active follow camera by the given step count.
 *
 */
static int _CAMERA_STEP(dc2::script::RunArguments stack) {
    mgCCameraFollow *camera = GetCamera();

    if (camera == nullptr) {
        return false;
    }

    camera->Step(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Stores the position of the previous event camera into three stack slots.
 *
 */
static int _GET_BEFORE_CAMERA_POS(dc2::script::RunArguments stack) {
    float      pos[4];
    mgCCamera *camera = EventScene->GetCamera(EventScene->before_camera);

    if (camera == nullptr) {
        return false;
    }

    camera->GetPos(pos);
    SetOutputVector(stack, {pos[0], pos[1], pos[2]});
    stack = stack + 2;
    return true;
}

/**
 *
 * Stores the reference point of the previous event camera into three stack slots.
 *
 */
static int _GET_BEFORE_CAMERA_REF(dc2::script::RunArguments stack) {
    float      pos[4];
    mgCCamera *camera = EventScene->GetCamera(EventScene->before_camera);

    if (camera == nullptr) {
        return false;
    }

    camera->GetRef(pos);
    SetOutputVector(stack, {pos[0], pos[1], pos[2]});
    stack = stack + 2;
    return true;
}

/**
 *
 * Does nothing.
 *
 */
static int _ASQ_INIT(dc2::script::RunArguments, int) {
    return true;
}

/**
 *
 * Does nothing.
 *
 */
static int _ASQ_SYNC_CHARA(dc2::script::RunArguments, int) {
    return true;
}

/**
 *
 * Does nothing.
 *
 */
static int _ASQ_SET_POS(dc2::script::RunArguments, int) {
    return true;
}

/**
 *
 * Does nothing.
 *
 */
static int _ASQ_MOVE(dc2::script::RunArguments, int) {
    return true;
}

/**
 *
 * Does nothing.
 *
 */
static int _ASQ_MOVE_STEP(dc2::script::RunArguments, int) {
    return true;
}

/**
 *
 * Does nothing.
 *
 */
static int _ASQ_ROT_REF(dc2::script::RunArguments, int) {
    return true;
}

/**
 *
 * Does nothing.
 *
 */
static int _ASQ_ROT_ANGLE(dc2::script::RunArguments, int) {
    return true;
}

/**
 *
 * Does nothing.
 *
 */
static int _ASQ_CLEAR_ROT(dc2::script::RunArguments, int) {
    return true;
}

/**
 *
 * Does nothing.
 *
 */
static int _ASQ_WAIT_ROT(dc2::script::RunArguments, int) {
    return true;
}

/**
 *
 * Does nothing.
 *
 */
static int _ASQ_ROT_MOVE(dc2::script::RunArguments, int) {
    return true;
}

/**
 *
 * Does nothing.
 *
 */
static int _ASQ_SET_ROT(dc2::script::RunArguments, int) {
    return true;
}

/**
 *
 * Does nothing.
 *
 */
static int _ASQ_DELAY_ROT(dc2::script::RunArguments, int) {
    return true;
}

/**
 *
 * Does nothing.
 *
 */
static int _ASQ_MOTION_TRG(dc2::script::RunArguments, int) {
    return true;
}

/**
 *
 * Does nothing.
 *
 */
static int _ASQ_MOTION_PLAY(dc2::script::RunArguments, int) {
    return true;
}

/**
 *
 * Does nothing.
 *
 */
static int _ASQ_MOTION_STOP(dc2::script::RunArguments, int) {
    return true;
}

/**
 *
 * Does nothing.
 *
 */
static int _ASQ_MOTION_NEXT(dc2::script::RunArguments, int) {
    return true;
}

/**
 *
 * Does nothing.
 *
 */
static int _ASQ_ANIME_TRG(dc2::script::RunArguments, int) {
    return true;
}

/**
 *
 * Does nothing.
 *
 */
static int _ASQ_ANIME(dc2::script::RunArguments, int) {
    return true;
}

/**
 *
 * Does nothing.
 *
 */
static int _ASQ_SE_PLAY(dc2::script::RunArguments, int) {
    return true;
}

/**
 *
 * Sets an event text sprite visibility and returns the update status.
 *
 */
static int _IMG_SET_DRAW(dc2::script::RunArguments stack) {
    int draw = {};

    draw = dc2::script::RunInteger(stack++);
    return esMother.SetDraw(dc2::script::RunInteger(stack), draw);
}

/**
 *
 * Sets an event text sprite source rectangle and returns the update status.
 *
 */
static int _IMG_SET_GET(dc2::script::RunArguments stack) {
    int index = dc2::script::RunInteger(stack++);
    int x = dc2::script::RunInteger(stack++);
    int y = dc2::script::RunInteger(stack++);
    int width = dc2::script::RunInteger(stack++);
    return esMother.SetGet(index, x, y, width, dc2::script::RunInteger(stack));
}

/**
 *
 * Sets an event text sprite destination rectangle and returns the update status.
 *
 */
static int _IMG_SET_PUT(dc2::script::RunArguments stack) {
    int index = dc2::script::RunInteger(stack++);
    int x = dc2::script::RunInteger(stack++);
    int y = dc2::script::RunInteger(stack++);
    int width = dc2::script::RunInteger(stack++);
    return esMother.SetPut(index, x, y, width, dc2::script::RunInteger(stack));
}

/**
 *
 * Sets an event text sprite name and returns the update status.
 *
 */
static int _IMG_SET_NAME(dc2::script::RunArguments stack) {
    int   no = dc2::script::RunInteger(stack++);
    char *name = dc2::script::RunCString(stack);
    return esMother.SetName(no, name);
}

/**
 *
 * Sets an event text sprite movement and returns the update status.
 *
 */
static int _IMG_SET_MOVE(dc2::script::RunArguments stack) {
    int index = dc2::script::RunInteger(stack++);
    int x = dc2::script::RunInteger(stack++);
    int y = dc2::script::RunInteger(stack++);
    return esMother.SetMove(index, x, y, dc2::script::RunInteger(stack));
}

/**
 *
 * Sets an event text sprite fade and returns the update status.
 *
 */
static int _IMG_SET_FADE(dc2::script::RunArguments stack) {
    int index = dc2::script::RunInteger(stack++);
    int fade_in = dc2::script::RunInteger(stack++);
    return esMother.SetFade(index, fade_in, dc2::script::RunInteger(stack));
}

/**
 *
 * Sets an event text sprite color and returns the update status.
 *
 */
static int _IMG_SET_COLOR(dc2::script::RunArguments stack) {
    int index = dc2::script::RunInteger(stack++);
    int r = dc2::script::RunInteger(stack++);
    int g = dc2::script::RunInteger(stack++);
    int b = dc2::script::RunInteger(stack++);
    return esMother.SetColor(index, r, g, b, dc2::script::RunInteger(stack));
}

/**
 *
 * Returns the event sprite at the given index, or NULL when the index is out of range.
 *
 */
static CEventSprite2 *GetEventSprite(int index) {
    if (index < 0 || index >= EVENT_SPRITE2_NUM) {
        return nullptr;
    }

    return &EventSprite2[index];
}

/**
 *
 * Initializes an event sprite.
 *
 */
static int _SPRITE_INIT(dc2::script::RunArguments stack) {
    CEventSprite2 *sprite = {};

    sprite = GetEventSprite(dc2::script::RunInteger(stack));

    if (sprite == nullptr) {
        return false;
    }

    sprite->Initialize();
    return true;
}

/**
 *
 * Sets an event sprite draw flag.
 *
 */
static int _SPRITE_SET_DRAW(dc2::script::RunArguments stack) {
    int            index = dc2::script::RunInteger(stack++);
    int            value = dc2::script::RunInteger(stack);
    CEventSprite2 *sprite = GetEventSprite(index);

    if (sprite == nullptr) {
        return false;
    }

    sprite->SetDrawFlag(value);
    return true;
}

/**
 *
 * Sets an event sprite type.
 *
 */
static int _SPRITE_SET_TYPE(dc2::script::RunArguments stack) {
    int            index = dc2::script::RunInteger(stack++);
    int            value = dc2::script::RunInteger(stack);
    CEventSprite2 *sprite = GetEventSprite(index);

    if (sprite == nullptr) {
        return false;
    }

    sprite->SetSpriteType(value);
    return true;
}

/**
 *
 * Sets an event sprite texture from a file name and texture block.
 *
 */
static int _SPRITE_SET_TEXTURE(dc2::script::RunArguments stack) {
    int            index = dc2::script::RunInteger(stack++);
    char          *name = dc2::script::RunCString(stack++);
    int            tex_block = dc2::script::RunInteger(stack);
    CEventSprite2 *sprite = GetEventSprite(index);

    if (sprite == nullptr) {
        return false;
    }

    sprite->SetTexture(name, tex_block);
    return true;
}

/**
 *
 * Sets an event sprite position, with screen-type sprites offset vertically.
 *
 */
static int _SPRITE_SET_POS(dc2::script::RunArguments stack, int argc) {
    float pos[4];
    mgZeroVector(pos);
    pos[3] = 1.0f;
    int index = dc2::script::RunInteger(stack++);
    pos[0] = dc2::script::RunFloat(stack++);
    pos[1] = dc2::script::RunFloat(stack++);

    if (argc >= 4) {
        pos[2] = dc2::script::RunFloat(stack);
    }

    CEventSprite2 *sprite = {};

    if ((sprite = GetEventSprite(index)) == nullptr) {
        return false;
    }

    if (sprite->GetType() == EVENT_SPRITE2_TYPE_SCREEN) {
        pos[1] += 32.0f;
    }

    dc2::log::PrintGame("_SPRITE_SET_POS:%f,%f\n", pos[0], pos[1]);
    sprite->SetPosition(pos);
    return true;
}

/**
 *
 * Sets an event sprite display size.
 *
 */
static int _SPRITE_SET_PUTSIZE(dc2::script::RunArguments stack) {
    int            index = dc2::script::RunInteger(stack++);
    int            width = dc2::script::RunInteger(stack++);
    int            height = dc2::script::RunInteger(stack);
    CEventSprite2 *sprite = GetEventSprite(index);

    if (sprite == nullptr) {
        return false;
    }

    if (height == 0x1A0 || height == 0x1C0) {
        height += 0x40;
    }

    sprite->SetPutSize(width, height);
    dc2::log::PrintGame("_SPRITE_SET_PUTSIZE:%d,%d\n", width, height);
    return true;
}

/**
 *
 * Sets an event sprite texture coordinate rectangle.
 *
 */
static int _SPRITE_SET_UVSIZE(dc2::script::RunArguments stack) {
    int            index = dc2::script::RunInteger(stack++);
    int            x = dc2::script::RunInteger(stack++);
    int            y = dc2::script::RunInteger(stack++);
    int            width = dc2::script::RunInteger(stack++);
    int            height = dc2::script::RunInteger(stack);
    CEventSprite2 *sprite = GetEventSprite(index);

    if (sprite == nullptr) {
        return false;
    }

    sprite->SetUvSize(x, y, width, height);
    return true;
}

/**
 *
 * Sets an event sprite RGBA color.
 *
 */
static int _SPRITE_SET_COLOR(dc2::script::RunArguments stack) {
    float color[4];
    int   index = dc2::script::RunInteger(stack++);
    color[0] = dc2::script::RunFloat(stack++);
    color[1] = dc2::script::RunFloat(stack++);
    color[2] = dc2::script::RunFloat(stack++);
    color[3] = dc2::script::RunFloat(stack);
    CEventSprite2 *sprite = GetEventSprite(index);

    if (sprite == nullptr) {
        return false;
    }

    sprite->SetColor(color);
    return true;
}

/**
 *
 * Sets an event sprite scale.
 *
 */
static int _SPRITE_SET_SCALE(dc2::script::RunArguments stack) {
    int            index = dc2::script::RunInteger(stack++);
    float          scale_x = dc2::script::RunFloat(stack++);
    float          scale_y = dc2::script::RunFloat(stack);
    CEventSprite2 *sprite = GetEventSprite(index);

    if (sprite == nullptr) {
        return false;
    }

    sprite->SetScale(scale_x, scale_y);
    return true;
}

/**
 *
 * Sets an event sprite alpha blend mode.
 *
 */
static int _SPRITE_SET_ALPHAB(dc2::script::RunArguments stack) {
    int            index = dc2::script::RunInteger(stack++);
    int            value = dc2::script::RunInteger(stack);
    CEventSprite2 *sprite = GetEventSprite(index);

    if (sprite == nullptr) {
        return false;
    }

    sprite->SetAlphaBlend(value);
    return true;
}

/**
 *
 * Returns whether the camera sequence is still running.
 *
 */
static int _CMRS_CHECK(dc2::script::RunArguments stack, int argc) {
    SetStack(stack, static_cast<u8>((CameraSeq.CheckEnd() != 0) ^ 1));
    return true;
}

/**
 *
 * Clears the camera sequence.
 *
 */
static int _CMRS_INIT(dc2::script::RunArguments, int) {
    CameraSeq.Clear();
    return true;
}

/**
 *
 * Sets a frame delay on the camera sequence PR step.
 *
 */
static int _CMRS_PRDELAY(dc2::script::RunArguments stack) {
    CameraSeq.PRDelay(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Sets the camera sequence position from direct arguments or an argument list.
 *
 */
static int _CMRS_SET_POS(dc2::script::RunArguments stack, int argc) {
    float pos[4];

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            GetArgVector(pos, args);
            break;
        }
        case 3:
            GetStackVector(pos, stack);
            break;
        default:
            return false;
    }

    CameraSeq.SetPos(pos);
    return true;
}

/**
 *
 * Sets the camera sequence reference point from direct arguments or an argument list.
 *
 */
static int _CMRS_SET_REF(dc2::script::RunArguments stack, int argc) {
    float pos[4];

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            GetArgVector(pos, args);
            break;
        }
        case 3:
            GetStackVector(pos, stack);
            break;
        default:
            return false;
    }

    CameraSeq.SetRef(pos);
    return true;
}

/**
 *
 * Sets a frame delay on the camera sequence AHD step.
 *
 */
static int _CMRS_AHDDELAY(dc2::script::RunArguments stack) {
    CameraSeq.AHDDelay(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Sets the camera sequence angle.
 *
 */
static int _CMRS_SET_ANGLE(dc2::script::RunArguments stack) {
    CameraSeq.SetAngle(dc2::script::RunFloat(stack));
    return true;
}

/**
 *
 * Sets the camera sequence height.
 *
 */
static int _CMRS_SET_HEIGHT(dc2::script::RunArguments stack) {
    CameraSeq.SetHeight(dc2::script::RunFloat(stack));
    return true;
}

/**
 *
 * Sets the camera sequence distance.
 *
 */
static int _CMRS_SET_DIST(dc2::script::RunArguments stack) {
    CameraSeq.SetDist(dc2::script::RunFloat(stack));
    return true;
}

/**
 *
 * Sets the camera sequence angle, height and distance.
 *
 */
static int _CMRS_SET_AHD(dc2::script::RunArguments stack) {
    float angle = dc2::script::RunFloat(stack++);
    float height = dc2::script::RunFloat(stack++);
    float dist = dc2::script::RunFloat(stack);
    CameraSeq.SetAHD(angle, height, dist);
    return true;
}

/**
 *
 * Moves the camera sequence position and reference point over a number of frames, from direct arguments or an argument list.
 *
 */
static int _CMRS_MOVE(dc2::script::RunArguments stack, int argc) {
    float pos[4];
    float ref[4];
    int   frames = {};

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            GetArgVector(pos, args);
            GetArgVector(ref, args + 3);
            frames = GetArgInt(args = args + 6);
            break;
        }
        case 7:
            GetStackVector(pos, stack);
            GetStackVector(ref, stack + 3);
            frames = dc2::script::RunInteger(stack = stack + 6);
            break;
        default:
            return false;
    }

    CameraSeq.Move(pos, ref, frames);
    return true;
}

/**
 *
 * Moves the camera sequence position and reference point with wait and rate parameters, from direct arguments or an argument list.
 *
 */
static int _CMRS_MOVE2(dc2::script::RunArguments stack, int argc) {
    float pos[4];
    float ref[4];
    int   frames = {};
    int   wait = {};
    float rate = {};

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            GetArgVector(pos, args);
            GetArgVector(ref, args + 3);
            args = args + 6;
            frames = GetArgInt(args++);
            wait = GetArgInt(args++);
            rate = GetArgFloat(args);
            break;
        }
        case 9:
            GetStackVector(pos, stack);
            GetStackVector(ref, stack + 3);
            stack = stack + 6;
            frames = dc2::script::RunInteger(stack++);
            wait = dc2::script::RunInteger(stack++);
            rate = dc2::script::RunFloat(stack);
            break;
        default:
            return false;
    }

    CameraSeq.Move2(pos, ref, frames, wait, rate);
    return true;
}

/**
 *
 * Moves the camera sequence reference point over a number of frames, from direct arguments or an argument list.
 *
 */
static int _CMRS_MOVE_REF(dc2::script::RunArguments stack, int argc) {
    float pos[4];
    int   frames = {};

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            GetArgVector(pos, args);
            frames = GetArgInt(args = args + 3);
            break;
        }
        case 4:
            GetStackVector(pos, stack);
            frames = dc2::script::RunInteger(stack = stack + 3);
            break;
        default:
            return false;
    }

    CameraSeq.MoveRef(pos, frames);
    return true;
}

/**
 *
 * Initializes the camera sequence path.
 *
 */
static int _CMRS_INIT_PAS(dc2::script::RunArguments, int) {
    CameraSeq.InitPas();
    return true;
}

/**
 *
 * Sets the frame of the camera sequence path.
 *
 */
static int _CMRS_SET_PAS_FRM(dc2::script::RunArguments stack) {
    CameraSeq.SetPasFrm(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Adds a path point to the camera sequence from two vectors, from direct arguments or an argument list.
 *
 */
static int _CMRS_ADD_PAS(dc2::script::RunArguments stack, int argc) {
    float first[4];
    float second[4];

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
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
            return false;
    }

    CameraSeq.AddPas(first, second);
    return true;
}

/**
 *
 * Starts the camera sequence path.
 *
 */
static int _CMRS_START_PAS(dc2::script::RunArguments, int) {
    CameraSeq.StartPas();
    return true;
}

/**
 *
 * Starts slowing the camera sequence PR step at the given rate and frame.
 *
 */
static int _CMRS_PR_SLOWING(dc2::script::RunArguments stack) {
    float rate = dc2::script::RunFloat(stack++);
    int   frame = dc2::script::RunInteger(stack);
    CameraSeq.PRSlowing(rate, frame);
    return true;
}

/**
 *
 * Holds the camera sequence PR position.
 *
 */
static int _CMRS_PR_KEEP(dc2::script::RunArguments, int) {
    CameraSeq.PRKeep();
    return true;
}

/**
 *
 * Returns the camera sequence PR position.
 *
 */
static int _CMRS_PR_RETURN(dc2::script::RunArguments, int) {
    CameraSeq.PRReturn();
    return true;
}

/**
 *
 * Moves the camera sequence by angle, height and distance over a number of frames, from direct arguments or an argument list.
 *
 */
static int _CMRS_MOVE_AHD(dc2::script::RunArguments stack, int argc) {
    float angle = {};
    float height = {};
    float distance = {};
    int   frames = {};

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            angle = GetArgFloat(args++);
            height = GetArgFloat(args++);
            distance = GetArgFloat(args++);
            frames = GetArgInt(args);
            break;
        }
        case 4:
            angle = dc2::script::RunFloat(stack++);
            height = dc2::script::RunFloat(stack++);
            distance = dc2::script::RunFloat(stack++);
            frames = dc2::script::RunInteger(stack);
            break;
        default:
            return false;
    }

    CameraSeq.MoveAHD(angle, height, distance, frames);
    return true;
}

/**
 *
 * Syncs the camera sequence to a scene object, from direct arguments or an argument list.
 *
 */
static int _CMRS_SYNC_OBJ(dc2::script::RunArguments stack, int argc) {
    float offset[4];
    float angle = {};
    float height = {};
    float dist = {};
    int   obj = {};
    int   mode = 0;
    char *frame_name = nullptr;

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack), argc);

            if (args.Remaining() == 0) {
                return false;
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
            obj = dc2::script::RunInteger(stack++);
            offset[0] = dc2::script::RunFloat(stack++);
            offset[1] = dc2::script::RunFloat(stack++);
            offset[2] = dc2::script::RunFloat(stack++);
            offset[3] = 1.0f;
            angle = dc2::script::RunFloat(stack++);
            height = dc2::script::RunFloat(stack++);
            dist = dc2::script::RunFloat(stack++);

            if (argc >= 8) {
                frame_name = dc2::script::RunCString(stack++);
            }

            if (argc >= 9) {
                mode = dc2::script::RunInteger(stack);
            }

            break;
        default:
            return false;
    }

    CameraSeq.SetSyncObj(obj, offset, angle, height, dist, mode, frame_name);
    return true;
}

/**
 *
 * Moves the camera sequence by angle, height and distance with wait and rate parameters, from direct arguments or an argument list.
 *
 */
static int _CMRS_MOVE_AHD2(dc2::script::RunArguments stack, int argc) {
    float angle = {};
    float height = {};
    float distance = {};
    int   frames = {};
    int   wait = {};
    float rate = {};

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
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
            angle = dc2::script::RunFloat(stack++);
            height = dc2::script::RunFloat(stack++);
            distance = dc2::script::RunFloat(stack++);
            frames = dc2::script::RunInteger(stack++);
            wait = dc2::script::RunInteger(stack++);
            rate = dc2::script::RunFloat(stack);
            break;
        default:
            return false;
    }

    CameraSeq.MoveAHD2(angle, height, distance, frames, wait, rate);
    return true;
}

/**
 *
 * Releases the object the camera sequence is synced to.
 *
 */
static int _CMRS_RELEASE_OBJ(dc2::script::RunArguments, int) {
    CameraSeq.ReleaseSyncObj();
    return true;
}

/**
 *
 * Starts slowing the camera sequence AHD step at the given rate and frame.
 *
 */
static int _CMRS_AHD_SLOWING(dc2::script::RunArguments stack) {
    float rate = dc2::script::RunFloat(stack++);
    int   frame = dc2::script::RunInteger(stack);
    CameraSeq.AHDSlowing(rate, frame);
    return true;
}

/**
 *
 * Holds the camera sequence AHD position.
 *
 */
static int _CMRS_AHD_KEEP(dc2::script::RunArguments, int) {
    CameraSeq.AHDKeep();
    return true;
}

/**
 *
 * Returns the camera sequence AHD position.
 *
 */
static int _CMRS_AHD_RETURN(dc2::script::RunArguments, int) {
    CameraSeq.AHDReturn();
    return true;
}

/**
 *
 * Sets a frame delay on the camera sequence fade.
 *
 */
static int _CMRS_FADE_DELAY(dc2::script::RunArguments stack) {
    CameraSeq.FadeDelay(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Initializes the camera sequence fade.
 *
 */
static int _CMRS_FADE_INIT(dc2::script::RunArguments, int) {
    CameraSeq.FadeInit();
    return true;
}

/**
 *
 * Fades the camera sequence in over a number of frames, with an optional color.
 *
 */
static int _CMRS_FADE_IN(dc2::script::RunArguments stack, int argc) {
    float r = 0.0f;
    float g = 0.0f;
    float b = 0.0f;
    int   frame = dc2::script::RunInteger(stack++);

    if (argc == 4) {
        r = dc2::script::RunFloat(stack++);
        g = dc2::script::RunFloat(stack++);
        b = dc2::script::RunFloat(stack);
    }

    CameraSeq.FadeIn(frame, r, g, b);
    return true;
}

/**
 *
 * Fades the camera sequence out over a number of frames, with an optional color.
 *
 */
static int _CMRS_FADE_OUT(dc2::script::RunArguments stack, int argc) {
    float r = 0.0f;
    float g = 0.0f;
    float b = 0.0f;
    int   frame = dc2::script::RunInteger(stack++);

    if (argc == 4) {
        r = dc2::script::RunFloat(stack++);
        g = dc2::script::RunFloat(stack++);
        b = dc2::script::RunFloat(stack);
    }

    CameraSeq.FadeOut(frame, r, g, b);
    return true;
}

/**
 *
 * Sets a frame delay on the camera sequence quake.
 *
 */
static int _CMRS_QUAKE_DELAY(dc2::script::RunArguments stack) {
    CameraSeq.QuakeDelay(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Starts a camera quake with a per-axis amplitude.
 *
 */
static int _CMRS_QUAKE(dc2::script::RunArguments stack) {
    float amplitude[4];
    amplitude[0] = dc2::script::RunFloat(stack++);
    amplitude[1] = dc2::script::RunFloat(stack++);
    amplitude[2] = dc2::script::RunFloat(stack++);
    amplitude[3] = 0.0f;
    CameraSeq.Quake(amplitude, dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Starts a second camera quake variant with a per-axis amplitude.
 *
 */
static int _CMRS_QUAKE2(dc2::script::RunArguments stack) {
    float amplitude[4];
    amplitude[0] = dc2::script::RunFloat(stack++);
    amplitude[1] = dc2::script::RunFloat(stack++);
    amplitude[2] = dc2::script::RunFloat(stack++);
    amplitude[3] = 0.0f;
    CameraSeq.Quake2(amplitude, dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Sets a frame delay on the camera sequence character attachment.
 *
 */
static int _CMRS_CHARA_DELAY(dc2::script::RunArguments stack) {
    CameraSeq.CharaDelay(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Attaches the camera sequence to a character with a kind and factor.
 *
 */
static int _CMRS_CHARA_ATTACH(dc2::script::RunArguments stack) {
    int   kind = {};
    float factor = {};

    kind = dc2::script::RunInteger(stack++);
    factor = dc2::script::RunFloat(stack++);
    CameraSeq.CharaAttach(kind, factor, dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Moves the camera sequence position over a number of frames, from direct arguments or an argument list.
 *
 */
static int _CMRS_MOVE_POS(dc2::script::RunArguments stack, int argc) {
    float pos[4];
    int   frames = {};

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            GetArgVector(pos, args);
            frames = GetArgInt(args = args + 3);
            break;
        }
        case 4:
            GetStackVector(pos, stack);
            frames = dc2::script::RunInteger(stack = stack + 3);
            break;
        default:
            return false;
    }

    CameraSeq.MovePos(pos, frames);
    return true;
}

/**
 *
 * Returns whether an object sequence is still running.
 *
 */
static int _OBJS_CHECK(dc2::script::RunArguments stack, int argc) {
    CSceneObjSeq *seq = {};

    seq = GetObjSeq(dc2::script::RunInteger(stack++));

    if (seq == nullptr) {
        return false;
    }

    SetStack(stack, static_cast<u8>((seq->CheckEnd() != 0) ^ 1));
    return true;
}

/**
 *
 * Clears an object sequence.
 *
 */
static int _OBJS_INIT(dc2::script::RunArguments stack) {
    CSceneObjSeq *seq = {};

    seq = GetObjSeq(dc2::script::RunInteger(stack));

    if (seq == nullptr) {
        return false;
    }

    seq->Clear();
    return true;
}

/**
 *
 * Sets the event object handle that an object sequence follows.
 *
 */
static int _OBJS_SYNC_OBJ(dc2::script::RunArguments stack) {
    CSceneObjSeq *seq = {};

    int slot = dc2::script::RunInteger(stack++);
    int eoh_no = dc2::script::RunInteger(stack);
    seq = GetObjSeq(slot);

    if (seq == nullptr) {
        return false;
    }

    seq->SetEohNo(eoh_no);
    return true;
}

/**
 *
 * Sets a frame delay on an object sequence position.
 *
 */
static int _OBJS_POS_DELAY(dc2::script::RunArguments stack) {
    CSceneObjSeq *seq = {};

    int slot = dc2::script::RunInteger(stack++);
    int frame = dc2::script::RunInteger(stack);
    seq = GetObjSeq(slot);

    if (seq == nullptr) {
        return false;
    }

    seq->PosDelay(frame);
    return true;
}

/**
 *
 * Sets an object sequence position from a slot and direct arguments or an argument list.
 *
 */
static int _OBJS_SET_POS(dc2::script::RunArguments stack, int argc) {
    CSceneObjSeq               *seq = {};
    float                       pos[4];
    int                         slot = {};
    dc2::script::EventArguments args(std::span<ARG_DATA>{});

    switch (argc) {
        case 1:
            args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            slot = GetArgInt(args++);
            GetArgVector(pos, args);
            break;
        case 4:
            slot = dc2::script::RunInteger(stack++);
            GetStackVector(pos, stack);
            break;
        default:
            return false;
    }

    seq = GetObjSeq(slot);

    if (seq == nullptr) {
        return false;
    }

    seq->SetPos(pos);
    return true;
}

/**
 *
 * Moves an object sequence to a position over a number of frames, with an optional ground flag, from direct arguments or an argument list.
 *
 */
static int _OBJS_MOVE(dc2::script::RunArguments stack, int argc) {
    float pos[4];
    int   index = {};
    int   frame = {};
    int   ground = 0;

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack), argc);

            if (args.Remaining() == 0) {
                return false;
            }

            index = GetArgInt(args++);
            GetArgVector(pos, args);
            args = args + 3;
            frame = GetArgInt(args++);

            if (argc >= 6) {
                ground = GetArgInt(args);
            }

            break;
        }
        case 5:
        case 6:
            index = dc2::script::RunInteger(stack++);
            GetStackVector(pos, stack);
            stack = stack + 3;
            frame = dc2::script::RunInteger(stack++);

            if (argc >= 6) {
                ground = dc2::script::RunInteger(stack);
            }

            break;
        default:
            return false;
    }

    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == nullptr) {
        return false;
    }

    seq->Move(pos, frame, ground);
    return true;
}

/**
 *
 * Moves an object sequence to a position with an ease type and rate, from direct arguments or an argument list.
 *
 */
static int _OBJS_MOVE2(dc2::script::RunArguments stack, int argc) {
    float pos[4];
    int   index = {};
    int   frame = {};
    int   ease = {};
    float rate = {};

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            index = GetArgInt(args++);
            GetArgVector(pos, args);
            args = args + 3;
            frame = GetArgInt(args++);
            ease = GetArgInt(args++);
            rate = GetArgFloat(args);
            break;
        }
        case 7:
            index = dc2::script::RunInteger(stack++);
            GetStackVector(pos, stack);
            stack = stack + 3;
            frame = dc2::script::RunInteger(stack++);
            ease = dc2::script::RunInteger(stack++);
            rate = dc2::script::RunFloat(stack);
            break;
        default:
            return false;
    }

    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == nullptr) {
        return false;
    }

    seq->Move2(pos, frame, ease, rate);
    return true;
}

/**
 *
 * Initializes an object sequence path.
 *
 */
static int _OBJS_INIT_PAS(dc2::script::RunArguments stack) {
    CSceneObjSeq *seq = {};

    seq = GetObjSeq(dc2::script::RunInteger(stack));

    if (seq == nullptr) {
        return false;
    }

    seq->InitPas();
    return true;
}

/**
 *
 * Sets the frame of an object sequence path.
 *
 */
static int _OBJS_SET_PAS_FRM(dc2::script::RunArguments stack) {
    CSceneObjSeq *seq = {};

    int slot = dc2::script::RunInteger(stack++);
    int frame = dc2::script::RunInteger(stack);
    seq = GetObjSeq(slot);

    if (seq == nullptr) {
        return false;
    }

    seq->SetPasFrm(frame);
    return true;
}

/**
 *
 * Adds a path point to an object sequence, from direct arguments or an argument list.
 *
 */
static int _OBJS_ADD_PAS(dc2::script::RunArguments stack, int argc) {
    CSceneObjSeq               *seq = {};
    float                       pos[4];
    int                         slot = {};
    dc2::script::EventArguments args(std::span<ARG_DATA>{});

    switch (argc) {
        case 1:
            args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            slot = GetArgInt(args++);
            GetArgVector(pos, args);
            break;
        case 4:
            slot = dc2::script::RunInteger(stack++);
            GetStackVector(pos, stack);
            break;
        default:
            return false;
    }

    seq = GetObjSeq(slot);

    if (seq == nullptr) {
        return false;
    }

    seq->AddPas(pos);
    return true;
}

/**
 *
 * Starts an object sequence path at an optional frame.
 *
 */
static int _OBJS_START_PAS(dc2::script::RunArguments stack, int argc) {
    CSceneObjSeq *seq = {};
    int           seq_no = {};
    int           frame = {};

    frame = 0;
    seq_no = dc2::script::RunInteger(stack++);

    if (argc >= 2) {
        frame = dc2::script::RunInteger(stack);
    }

    seq = GetObjSeq(seq_no);

    if (seq == nullptr) {
        return false;
    }

    seq->StartPas(frame);
    return true;
}

/**
 *
 * Makes an object sequence jump to a position with a height over a number of frames, from direct arguments or an argument list.
 *
 */
static int _OBJS_JUMP(dc2::script::RunArguments stack, int argc) {
    float pos[4];
    float height = {};
    int   index = {};
    int   frame = {};

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            index = GetArgInt(args++);
            GetArgVector(pos, args);
            args = args + 3;
            height = GetArgFloat(args++);
            frame = GetArgInt(args);
            break;
        }
        case 6:
            index = dc2::script::RunInteger(stack++);
            GetStackVector(pos, stack);
            stack = stack + 3;
            height = dc2::script::RunFloat(stack++);
            frame = dc2::script::RunInteger(stack);
            break;
        default:
            return false;
    }

    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == nullptr) {
        return false;
    }

    seq->Jump(pos, height, frame);
    return true;
}

/**
 *
 * Sets an object sequence position from a frame of an event object handle, with an optional frame count and offset.
 *
 */
static int _OBJS_SET_EOH_FRAME_POS(dc2::script::RunArguments stack, int argc) {
    CSceneObjSeq *seq = {};
    float         offset[4];
    int           slot{};
    int           eoh_no{};
    int           frames = {};
    char         *frame_name{};

    frames = 0;
    mgZeroVector(offset);

    switch (argc) {
        case 3:
            slot = dc2::script::RunInteger(stack++);
            eoh_no = dc2::script::RunInteger(stack++);
            frame_name = dc2::script::RunCString(stack);
            break;
        case 4:
            slot = dc2::script::RunInteger(stack++);
            eoh_no = dc2::script::RunInteger(stack++);
            frame_name = dc2::script::RunCString(stack++);
            frames = dc2::script::RunInteger(stack);
            break;
        case 6:
            slot = dc2::script::RunInteger(stack++);
            eoh_no = dc2::script::RunInteger(stack++);
            frame_name = dc2::script::RunCString(stack++);
            GetStackVector(offset, stack);
            break;
        case 7:
            slot = dc2::script::RunInteger(stack++);
            eoh_no = dc2::script::RunInteger(stack++);
            frame_name = dc2::script::RunCString(stack++);
            GetStackVector(offset, stack);

            stack = stack + 3;
            frames = dc2::script::RunInteger(stack);
            break;
        default:
            return false;
    }

    seq = GetObjSeq(slot);

    if (seq == nullptr) {
        return false;
    }

    seq->SetEohFramePos(eoh_no, frame_name, frames, offset);
    return true;
}

/**
 *
 * Adds an offset to an object sequence position over an optional number of frames, from direct arguments or an argument list.
 *
 */
static int _OBJS_ADD_POS(dc2::script::RunArguments stack, int argc) {
    float add[4];
    int   index = {};
    int   frame = 1;

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            index = GetArgInt(args++);
            GetArgVector(add, args);
            frame = GetArgInt(args = args + 3);
            break;
        }
        case 4:
        case 5:
            index = dc2::script::RunInteger(stack++);
            GetStackVector(add, stack);
            stack = stack + 3;

            if (argc >= 5) {
                frame = dc2::script::RunInteger(stack++);
            }

            break;
        default:
            return false;
    }

    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == nullptr) {
        return false;
    }

    seq->AddPos(add, frame);
    return true;
}

/**
 *
 * Attaches an object sequence to the camera with a rate and frame.
 *
 */
static int _OBJS_ATTACH_CAMERA(dc2::script::RunArguments stack) {
    CSceneObjSeq *seq = {};
    int           slot = {};
    float         rate = {};

    slot = dc2::script::RunInteger(stack++);
    rate = dc2::script::RunFloat(stack++);
    int frame = dc2::script::RunInteger(stack);
    seq = GetObjSeq(slot);

    if (seq == nullptr) {
        return false;
    }

    seq->AttachCamera(rate, frame);
    return true;
}

/**
 *
 * Sets a frame delay on an object sequence rotation.
 *
 */
static int _OBJS_ROT_DELAY(dc2::script::RunArguments stack) {
    CSceneObjSeq *seq = {};

    int slot = dc2::script::RunInteger(stack++);
    int frame = dc2::script::RunInteger(stack);
    seq = GetObjSeq(slot);

    if (seq == nullptr) {
        return false;
    }

    seq->RotDelay(frame);
    return true;
}

/**
 *
 * Sets an object sequence rotation from a slot and direct arguments or an argument list.
 *
 */
static int _OBJS_SET_ROT(dc2::script::RunArguments stack, int argc) {
    CSceneObjSeq               *seq = {};
    float                       rot[4];
    int                         slot = {};
    dc2::script::EventArguments args(std::span<ARG_DATA>{});

    switch (argc) {
        case 1:
            args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            slot = GetArgInt(args++);
            GetArgVector(rot, args);
            break;
        case 4:
            slot = dc2::script::RunInteger(stack++);
            GetStackVector(rot, stack);
            break;
        default:
            return false;
    }

    seq = GetObjSeq(slot);

    if (seq == nullptr) {
        return false;
    }

    seq->SetRot(rot);
    return true;
}

/**
 *
 * Rotates an object sequence to a rotation over a number of frames, from direct arguments or an argument list.
 *
 */
static int _OBJS_ROTATION(dc2::script::RunArguments stack, int argc) {
    float rot[4];
    int   index = {};
    int   frame = {};

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            index = GetArgInt(args++);
            GetArgVector(rot, args);
            frame = GetArgInt(args = args + 3);
            break;
        }
        case 5:
            index = dc2::script::RunInteger(stack++);
            GetStackVector(rot, stack);
            frame = dc2::script::RunInteger(stack = stack + 3);
            break;
        default:
            return false;
    }

    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == nullptr) {
        return false;
    }

    seq->Rotation(rot, frame);
    return true;
}

/**
 *
 * Rotates an object sequence with an ease type and rate, from direct arguments or an argument list.
 *
 */
static int _OBJS_ROTATION2(dc2::script::RunArguments stack, int argc) {
    float rot[4];
    int   index = {};
    int   frame = {};
    int   ease = {};
    float rate = {};

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            index = GetArgInt(args++);
            GetArgVector(rot, args);
            args = args + 3;
            frame = GetArgInt(args++);
            ease = GetArgInt(args++);
            rate = GetArgFloat(args);
            break;
        }
        case 7:
            index = dc2::script::RunInteger(stack++);
            GetStackVector(rot, stack);
            stack = stack + 3;
            frame = dc2::script::RunInteger(stack++);
            ease = dc2::script::RunInteger(stack++);
            rate = dc2::script::RunFloat(stack);
            break;
        default:
            return false;
    }

    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == nullptr) {
        return false;
    }

    seq->Rotation2(rot, frame, ease, rate);
    return true;
}

/**
 *
 * Sets an object sequence reference position over a number of frames, from direct arguments or an argument list.
 *
 */
static int _OBJS_REFERENCE(dc2::script::RunArguments stack, int argc) {
    float pos[4];
    int   index = {};
    int   frame = {};

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            index = GetArgInt(args++);
            GetArgVector(pos, args);
            frame = GetArgInt(args = args + 3);
            break;
        }
        case 5:
            index = dc2::script::RunInteger(stack++);
            GetStackVector(pos, stack);
            frame = dc2::script::RunInteger(stack = stack + 3);
            break;
        default:
            return false;
    }

    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == nullptr) {
        return false;
    }

    seq->Reference(pos, frame);
    return true;
}

/**
 *
 * Sets a frame delay on an object sequence motion.
 *
 */
static int _OBJS_MOTION_DELAY(dc2::script::RunArguments stack) {
    CSceneObjSeq *seq = {};

    int slot = dc2::script::RunInteger(stack++);
    int frame = dc2::script::RunInteger(stack);
    seq = GetObjSeq(slot);

    if (seq == nullptr) {
        return false;
    }

    seq->MotionDelay(frame);
    return true;
}

/**
 *
 * Sets an object sequence motion by name with an optional type, blend and normal drive, from direct arguments or an argument list.
 *
 */
static int _OBJS_SET_MOTION(dc2::script::RunArguments stack, int argc) {
    int   index = {};
    int   type = 0;
    float blend = -1.0f;
    int   normal_drive = 0;
    char *name = {};

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack), argc);

            if (args.Remaining() == 0) {
                return false;
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
            index = dc2::script::RunInteger(stack++);
            name = dc2::script::RunCString(stack++);

            if (argc >= 3) {
                type = dc2::script::RunInteger(stack++);
            }

            if (argc >= 4) {
                blend = dc2::script::RunFloat(stack++);
            }

            if (argc >= 5) {
                normal_drive = dc2::script::RunInteger(stack);
            }

            break;
        default:
            return false;
    }

    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == nullptr) {
        return false;
    }

    seq->SetMotion(name, type, blend);

    if (normal_drive == 1) {
        seq->NormalDrive();
        seq->ResetDAPosition();
    }

    return true;
}

/**
 *
 * Queues the next motion of an object sequence by name with an optional type and blend, from direct arguments or an argument list.
 *
 */
static int _OBJS_NEXT_MOTION(dc2::script::RunArguments stack, int argc) {
    int   index = {};
    int   type = 0;
    float blend = -1.0f;
    char *name = {};

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack), argc);

            if (args.Remaining() == 0) {
                return false;
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
            index = dc2::script::RunInteger(stack++);
            name = dc2::script::RunCString(stack++);

            if (argc >= 3) {
                type = dc2::script::RunInteger(stack++);
            }

            if (argc >= 4) {
                blend = dc2::script::RunFloat(stack);
            }

            break;
        default:
            return false;
    }

    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == nullptr) {
        return false;
    }

    seq->NextMotion(name, type, blend);
    return true;
}

/**
 *
 * Waits on an object sequence motion.
 *
 */
static int _OBJS_MOTION_WAIT(dc2::script::RunArguments stack) {
    CSceneObjSeq *seq = {};

    seq = GetObjSeq(dc2::script::RunInteger(stack));

    if (seq == nullptr) {
        return false;
    }

    seq->MotionWait();
    return true;
}

/**
 *
 * Sets an object sequence step.
 *
 */
static int _OBJS_SET_STEP(dc2::script::RunArguments stack) {
    int           index = dc2::script::RunInteger(stack++);
    float         step = dc2::script::RunFloat(stack);
    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == nullptr) {
        return false;
    }

    seq->SetStep(step);
    return true;
}

/**
 *
 * Sets an object sequence change step, using 0.2 when the given step is not positive.
 *
 */
static int _OBJS_CHENGE_STEP(dc2::script::RunArguments stack, int argc) {
    float step = 0.2f;
    int   index = dc2::script::RunInteger(stack++);

    if (argc > 0) {
        step = dc2::script::RunFloat(stack);
    }

    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == nullptr) {
        return false;
    }

    if (step <= 0.0f) {
        step = 0.2f;
    }

    seq->SetChengeStep(step);
    return true;
}

/**
 *
 * Sets the motion trigger of an object sequence.
 *
 */
static int _OBJS_SEQ_MOT_TRG(dc2::script::RunArguments stack) {
    CSceneObjSeq *seq = {};

    seq = GetObjSeq(dc2::script::RunInteger(stack));

    if (seq == nullptr) {
        return false;
    }

    seq->SetMotionTrg();
    return true;
}

/**
 *
 * Waits on the motion trigger of an object sequence.
 *
 */
static int _OBJS_SEQ_MOT_TRG_WAIT(dc2::script::RunArguments stack) {
    CSceneObjSeq *seq = {};

    seq = GetObjSeq(dc2::script::RunInteger(stack));

    if (seq == nullptr) {
        return false;
    }

    seq->MotionTrgWait();
    return true;
}

/**
 *
 * Resets an object sequence motion.
 *
 */
static int _OBJS_RESET_MOTION(dc2::script::RunArguments stack) {
    CSceneObjSeq *seq = {};

    seq = GetObjSeq(dc2::script::RunInteger(stack));

    if (seq == nullptr) {
        return false;
    }

    seq->ResetMotion();
    return true;
}

/**
 *
 * Sets the current motion time of an object sequence.
 *
 */
static int _OBJS_SET_MOTION_NOW_TIME(dc2::script::RunArguments stack) {
    int           index = dc2::script::RunInteger(stack++);
    float         time = dc2::script::RunFloat(stack);
    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == nullptr) {
        return false;
    }

    seq->SetMotionNowTime(time);
    return true;
}

/**
 *
 * Sets the motion wait time of an object sequence.
 *
 */
static int _OBJS_SET_MOTION_WAIT_TIME(dc2::script::RunArguments stack) {
    int           index = dc2::script::RunInteger(stack++);
    float         time = dc2::script::RunFloat(stack);
    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == nullptr) {
        return false;
    }

    seq->SetMotionWaitTime(time);
    return true;
}

/**
 *
 * Sets a frame delay on an object sequence texture animation.
 *
 */
static int _OBJS_TEXA_DELAY(dc2::script::RunArguments stack) {
    CSceneObjSeq *seq = {};

    int slot = dc2::script::RunInteger(stack++);
    int frame = dc2::script::RunInteger(stack);
    seq = GetObjSeq(slot);

    if (seq == nullptr) {
        return false;
    }

    seq->TexAnimeDelay(frame);
    return true;
}

/**
 *
 * Enables or disables an object sequence texture animation, with an optional texture name.
 *
 */
static int _OBJS_TEX_ANIME(dc2::script::RunArguments stack, int argc) {
    int   index = dc2::script::RunInteger(stack++);
    int   on = dc2::script::RunInteger(stack++);
    char *name = nullptr;

    if (argc >= 3) {
        name = dc2::script::RunCString(stack);
    }

    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == nullptr) {
        return false;
    }

    seq->TexAnime(name, on);
    return true;
}

/**
 *
 * Sets a frame delay on an object sequence color.
 *
 */
static int _OBJS_COLOR_DELAY(dc2::script::RunArguments stack) {
    CSceneObjSeq *seq = {};

    int slot = dc2::script::RunInteger(stack++);
    int frame = dc2::script::RunInteger(stack);
    seq = GetObjSeq(slot);

    if (seq == nullptr) {
        return false;
    }

    seq->ColorDelay(frame);
    return true;
}

/**
 *
 * Sets an object sequence RGBA color over an optional number of frames.
 *
 */
static int _OBJS_SET_COLOR(dc2::script::RunArguments stack, int argc) {
    CSceneObjSeq *seq = {};
    float         color[4];
    int           slot = {};
    int           frames = {};

    frames = 0;
    slot = dc2::script::RunInteger(stack++);
    color[0] = dc2::script::RunFloat(stack++);
    color[1] = dc2::script::RunFloat(stack++);
    color[2] = dc2::script::RunFloat(stack++);
    color[3] = dc2::script::RunFloat(stack++);

    if (argc >= 6) {
        frames = dc2::script::RunInteger(stack);
    }

    seq = GetObjSeq(slot);

    if (seq == nullptr) {
        return false;
    }

    seq->SetColor(color, frames);
    return true;
}

/**
 *
 * Sets a frame delay on an object sequence scale.
 *
 */
static int _OBJS_SCALE_DELAY(dc2::script::RunArguments stack) {
    CSceneObjSeq *seq = {};

    int slot = dc2::script::RunInteger(stack++);
    int frame = dc2::script::RunInteger(stack);
    seq = GetObjSeq(slot);

    if (seq == nullptr) {
        return false;
    }

    seq->ScaleDelay(frame);
    return true;
}

/**
 *
 * Sets an object sequence scale with an optional flag.
 *
 */
static int _OBJS_SET_SCALE(dc2::script::RunArguments stack, int argc) {
    float scale[4];
    int   index = {};
    int   flag = 0;
    index = dc2::script::RunInteger(stack++);
    scale[0] = dc2::script::RunFloat(stack++);
    scale[1] = dc2::script::RunFloat(stack++);
    scale[2] = dc2::script::RunFloat(stack++);
    scale[3] = 1.0f;

    if (argc >= 5) {
        flag = dc2::script::RunInteger(stack);
    }

    CSceneObjSeq *seq = {};

    if ((seq = GetObjSeq(index)) == nullptr) {
        return false;
    }

    seq->SetScale(scale, flag);
    return true;
}

/**
 *
 * Sets a frame delay on an object sequence sound effect.
 *
 */
static int _OBJS_SE_DELAY(dc2::script::RunArguments stack) {
    CSceneObjSeq *seq = {};

    int slot = dc2::script::RunInteger(stack++);
    int frame = dc2::script::RunInteger(stack);
    seq = GetObjSeq(slot);

    if (seq == nullptr) {
        return false;
    }

    seq->SeDelay(frame);
    return true;
}

/**
 *
 * Plays a sound effect for an object sequence.
 *
 */
static int _OBJS_SE_PLAY(dc2::script::RunArguments stack) {
    int           index = dc2::script::RunInteger(stack++);
    int           snd_id = dc2::script::RunInteger(stack++);
    int           se_no = dc2::script::RunInteger(stack);
    CSceneObjSeq *seq = GetObjSeq(index);

    if (seq == nullptr) {
        return false;
    }

    seq->SePlay(snd_id, se_no);
    return true;
}

/**
 *
 * Resets the DA position of an object sequence.
 *
 */
static int _OBJS_RESET_DA_POSITION(dc2::script::RunArguments stack) {
    CSceneObjSeq *seq = {};

    seq = GetObjSeq(dc2::script::RunInteger(stack));

    if (seq == nullptr) {
        return false;
    }

    seq->ResetDAPosition();
    return true;
}

/**
 *
 * Switches an object sequence to normal drive.
 *
 */
static int _OBJS_NORMAL_DRIVE(dc2::script::RunArguments stack) {
    CSceneObjSeq *seq = {};

    seq = GetObjSeq(dc2::script::RunInteger(stack));

    if (seq == nullptr) {
        return false;
    }

    seq->NormalDrive();
    return true;
}

/**
 *
 * Does nothing.
 *
 */
static int _ASQ_CHECK(dc2::script::RunArguments, int) {
    return true;
}

/**
 *
 * Initializes a sound port.
 *
 */
static int _SND_INIT_PORT(dc2::script::RunArguments stack) {
    sndInitPort(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Loads a sound effect from a default event SE file or a named file into a sound port and records its sound ID.
 *
 */
static int _SND_LOAD_SOUND(dc2::script::RunArguments stack, int argc) {
    std::optional<std::string> generated_path;
    int                        port = {};
    mgCMemory                 *memory = {};
    char                      *file_name = {};
    int                        sound_id = {};

    switch (argc) {
        case 2:
            port = SND_PORT_EVENT;
            memory = &BuffEventSnd;
            break;
        case 3:
            port = dc2::script::RunInteger(stack++);

            if (port == SND_PORT_MENU) {
                memory = &BuffEventSnd2;
            } else {
                memory = &BuffEventSnd;
            }

            break;
        default:
            return false;
    }

    switch (stack.At().type) {
        case RS_INT:
            generated_path = EventScene->GetDefEventSeFile(dc2::script::RunInteger(stack++));
            if (!generated_path) {
                return false;
            }

            file_name = generated_path->data();
            break;
        case RS_STR:
            file_name = dc2::script::RunCString(stack++);
            break;
        default:
            return false;
    }

    if (port < 0 || port > 11) {
        return false;
    }

    if (memory->stack == nullptr || memory->stack_size <= 0) {
        return false;
    }

    const auto file_read = dc2::event::ReadFile(file_name);
    u32       *pack = reinterpret_cast<u32 *>(file_read.Bytes().data());

    if (pack == nullptr) {
        return false;
    }

    sndInitPort(port);
    SetStack(stack, sound_id = sndLoadSound(port, pack, memory));
    EdEventInfo.snd_id[port] = sound_id;
    EdEventInfo.last_snd_id = sound_id;
    return true;
}

/**
 *
 * Stores the sound ID of the last loaded sound, or of an environment, base, battle or source sound selected by a kind.
 *
 */
static int _GET_SND_ID(dc2::script::RunArguments stack, int argc) {
    int snd_id = {};
    int src_no = 0;

    if (argc == 1) {
        snd_id = EdEventInfo.last_snd_id;
    } else {
        switch (dc2::script::RunInteger(stack++)) {
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
                    src_no = dc2::script::RunInteger(stack++);
                }

                snd_id = EventScene->GetSeSrcID(src_no);
                break;
            default:
                return false;
        }
    }

    SetStack(stack, snd_id);
    return true;
}

/**
 *
 * Pauses a sound effect.
 *
 */
static int _SND_SE_PAUSE(dc2::script::RunArguments stack) {
    u32 se_id = {};

    se_id = dc2::script::RunInteger(stack++);
    sndSePause(se_id, dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Plays a sound effect on a voice, with optional volume and pan.
 *
 */
static int _SND_SE_PLAY(dc2::script::RunArguments stack, int argc) {
    switch (argc) {
        case 2: {
            u32 se_id = dc2::script::RunInteger(stack++);
            int voice = dc2::script::RunInteger(stack);
            sndSePlay(se_id, voice, 0);
            return true;
        }
        case 3: {
            u32 se_id = dc2::script::RunInteger(stack++);
            int voice = dc2::script::RunInteger(stack++);
            int volume = dc2::script::RunInteger(stack);
            sndSePlayV(se_id, voice, volume, 0);
            return true;
        }
        case 4: {
            u32 se_id = dc2::script::RunInteger(stack++);
            int voice = dc2::script::RunInteger(stack++);
            int volume = dc2::script::RunInteger(stack++);
            int pan = dc2::script::RunInteger(stack);
            sndSePlayVP(se_id, voice, volume, pan, 0);
            return true;
        }
        default:
            return false;
    }
}

/**
 *
 * Stops a sound effect.
 *
 */
static int _SND_SE_STOP(dc2::script::RunArguments stack) {
    u32 se_id = {};

    se_id = dc2::script::RunInteger(stack++);
    sndSeStop(se_id, dc2::script::RunInteger(stack), 0);
    return true;
}

/**
 *
 * Sets a sound effect volume, given as an integer or a float.
 *
 */
static int _SND_SET_SE_VOL(dc2::script::RunArguments stack, int argc) {
    u32 se_id = {};
    int voice = {};

    se_id = dc2::script::RunInteger(stack++);
    voice = dc2::script::RunInteger(stack++);

    switch (stack.At().type) {
        case RS_INT:
            sndSetSeVol(se_id, voice, dc2::script::RunInteger(stack), 0);
            break;
        case RS_FLOAT:
            sndSetSeVolf(se_id, voice, dc2::script::RunFloat(stack), 0);
            break;
        default:
            return false;
    }

    return true;
}

/**
 *
 * Sets a sound effect pan over a time.
 *
 */
static int _SND_SET_SE_PAN(dc2::script::RunArguments stack) {
    int se_id = dc2::script::RunInteger(stack++);
    int pan = dc2::script::RunInteger(stack++);
    int time = dc2::script::RunInteger(stack);
    sndSetSePan(se_id, pan, time, 0);
    return true;
}

/**
 *
 * Sets a sound effect pitch over a time.
 *
 */
static int _SND_SET_SE_PITCH(dc2::script::RunArguments stack) {
    int se_id = dc2::script::RunInteger(stack++);
    int pitch = dc2::script::RunInteger(stack++);
    int time = dc2::script::RunInteger(stack);
    sndSetSePitch(se_id, pitch, time, 0);
    return true;
}

/**
 *
 * Stops all sound effects of the given sound.
 *
 */
static int _SND_SE_ALL_STOP(dc2::script::RunArguments stack) {
    sndSeAllStop(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Loads a BGM by number into the read buffer.
 *
 */
static int _LOAD_BGM(dc2::script::RunArguments stack) {
    int bgm_no = {};

    bgm_no = dc2::script::RunInteger(stack);

    if (EventScene->CheckLoadBGM(bgm_no) == 0) {
        return false;
    }

    return EventScene->LoadBGM(bgm_no, ReadBufferBytes());
}

/**
 *
 * Plays a BGM by number, with an optional second argument.
 *
 */
static int _PLAY_BGM(dc2::script::RunArguments stack, int argc) {
    int bgm_no = {};

    switch (argc) {
        case 1:
            EventScene->PlayBGM(dc2::script::RunInteger(stack), -1, 1.0f);
            return true;
        case 2:
            bgm_no = dc2::script::RunInteger(stack++);
            EventScene->PlayBGM(bgm_no, dc2::script::RunInteger(stack), 1.0f);
            return true;
    }

    return false;
}

/**
 *
 * Stops the BGM.
 *
 */
static int _STOP_BGM(dc2::script::RunArguments stack) {
    EventScene->StopBGM(dc2::script::RunInteger(stack));
    return true;
}

int CommandStreamOpenFromFPL(int stream, char *name, char *base);

int CommandStreamOpen(int stream, char *name);

/**
 *
 * Opens the event voice stream from a voice number, voice pack or file name.
 *
 */
int _STREAM_OPEN(dc2::script::RunArguments stack, int argc);

int CommandStreamPlay(int stream, int volume) {
    int reverb = sndGetReverbDepth(1);
    int scaled = static_cast<int>(static_cast<double>(volume) - 256.0 * (1.5 * static_cast<double>(reverb)));
    dc2::log::PrintGame("vol=%d,vol_0=%d\n", scaled, volume);
    EdEventInfo.stream_volume = volume;
    CSnd.StreamSetVol(stream, scaled, scaled);
    CSnd.StreamPlay(stream);
    return true;
}

/**
 *
 * Plays the event voice stream with an optional volume.
 *
 */
static int _STREAM_PLAY(dc2::script::RunArguments stack, int argc) {
    EdEventInfo.stream_playing = true;
    dc2::script::RunInteger(stack++);

    switch (argc) {
        case 1:
            return CommandStreamPlay(EVENT_STREAM_CHANNEL, 0x7FFF);
        case 2:
            return CommandStreamPlay(EVENT_STREAM_CHANNEL, dc2::script::RunInteger(stack));
    }

    return false;
}

/**
 *
 * Stops the event voice stream.
 *
 */
static int _STREAM_STOP(dc2::script::RunArguments stack) {
    EdEventInfo.stream_playing = false;
    dc2::script::RunInteger(stack);

    if (EdEventInfo.stream_source == EVENT_STREAM_VOICE_PACK) {
        CSnd.StreamEND(EVENT_STREAM_CHANNEL);
    } else {
        CSnd.StreamSetVol(EVENT_STREAM_CHANNEL, EdEventInfo.stream_volume, EdEventInfo.stream_volume);
        CSnd.StreamClose(EVENT_STREAM_CHANNEL);
    }

    return true;
}

/**
 *
 * Puts the event voice stream on standby.
 *
 */
static int _STREAM_STANDBY(dc2::script::RunArguments stack) {
    dc2::script::RunInteger(stack);
    CSnd.StreamStandBy(EVENT_STREAM_CHANNEL);
    return true;
}

/**
 *
 * Stores the state of the event voice stream.
 *
 */
static int _STREAM_GET_STATUS(dc2::script::RunArguments stack, int argc) {
    dc2::script::RunInteger(stack++);

    argc = CSnd.StreamGetState(EVENT_STREAM_CHANNEL);
    SetStack(stack, argc);
    return true;
}

/**
 *
 * Stores the system sound ID.
 *
 */
static int _GET_SYS_SND_ID(dc2::script::RunArguments stack, int argc) {

    argc = GetSystemSndID();
    SetStack(stack, argc);
    return true;
}

/**
 *
 * Stores the state of the event voice stream open request.
 *
 */
static int _STREAM_OPEN_CHECK(dc2::script::RunArguments stack, int argc) {
    SetStack(stack, CSnd.StreamOpenState());
    return true;
}

/**
 *
 * Loads an environment sound effect bank.
 *
 */
static int _LOAD_SE_ENV(dc2::script::RunArguments stack) {
    int bank_no = {};

    bank_no = dc2::script::RunInteger(stack);

    if (EventScene->CheckLoadSeEnv(bank_no) == 0) {
        return false;
    }

    EventScene->LoadSeEnv(bank_no, ReadBufferBytes());
    return true;
}

/**
 *
 * Plays an environment BGM with an optional volume, or auto-changes it when the voice is -1.
 *
 */
static int _PLAY_ENV_BGM(dc2::script::RunArguments stack, int argc) {
    int voice = {};
    int volume = {};

    voice = dc2::script::RunInteger(stack++);
    EventScene->StopEnvBGM();

    if (voice == -1) {
        EventScene->AutoChangeEnvBGM(1);
        EventScene->SetEnvBGMVol(1.0f);
        return true;
    }

    switch (argc) {
        case 1:
            EventScene->SetEnvBGMVol(1.0f);
            EventScene->PlayEnvBGM(voice, 1.0f);
            EdEventInfo.env_bgm_no = voice;
            EdEventInfo.env_bgm_volume = 1.0f;
            return true;
        case 2:

            volume = fptosi(dc2::script::RunFloat(stack));
            EventScene->SetEnvBGMVol(volume);
            EventScene->PlayEnvBGM(voice, 1.0f);
            EdEventInfo.env_bgm_no = voice;
            EdEventInfo.env_bgm_volume = volume;
            return true;
    }

    return false;
}

/**
 *
 * Plays a system sound effect by ID.
 *
 */
static int _SYS_SE_PLAY(dc2::script::RunArguments stack) {
    int se_id = {};

    se_id = dc2::script::RunInteger(stack);

    if (se_id < 0) {
        return false;
    }

    sndSePlay(SystemSND_ID, se_id, 0);
    return true;
}

/**
 *
 * Initializes sound effect sources.
 *
 */
static int _INIT_SE_SRC(dc2::script::RunArguments, int) {
    EventScene->InitSeSrc();
    return true;
}

/**
 *
 * Initializes environment sound effects.
 *
 */
static int _INIT_SE_ENV(dc2::script::RunArguments, int) {
    EventScene->InitSeEnv();
    return true;
}

/**
 *
 * Initializes base sound effects.
 *
 */
static int _INIT_SE_BAS(dc2::script::RunArguments, int) {
    EventScene->InitSeBas();
    return true;
}

/**
 *
 * Loads a sound effect source bank.
 *
 */
static int _LOAD_SE_SRC(dc2::script::RunArguments stack) {
    int src_no = {};

    src_no = dc2::script::RunInteger(stack);

    if (EventScene->CheckLoadSeSrc(src_no) == 0) {
        return false;
    }

    return EventScene->LoadSeSrc(src_no, ReadBufferBytes());
}

/**
 *
 * Does nothing and fails.
 *
 */
static int _LOAD_SE_FOOT(dc2::script::RunArguments, int) {
    return false;
}

/**
 *
 * Does nothing and fails.
 *
 */
static int _LOAD_SE_DOOR(dc2::script::RunArguments, int) {
    return false;
}

/**
 *
 * Does nothing and fails.
 *
 */
static int _LOAD_SE_BOX(dc2::script::RunArguments, int) {
    return false;
}

/**
 *
 * Loads a battle sound effect bank.
 *
 */
static int _LOAD_SE_BATTLE(dc2::script::RunArguments stack) {
    int bank_no = {};

    bank_no = dc2::script::RunInteger(stack);

    if (EventScene->CheckLoadSeBattle(bank_no) == 0) {
        return false;
    }

    return EventScene->LoadSeBattle(bank_no, ReadBufferBytes());
}

/**
 *
 * Deletes a sound port.
 *
 */
static int _SND_DELETE_PORT(dc2::script::RunArguments stack) {
    sndDeletePort(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Fades the background music in over a duration given in 60 Hz frames.
 *
 */
static int _FADE_IN_BGM(dc2::script::RunArguments stack) {
    int frames60 = {};
    int frames = {};

    frames60 = dc2::script::RunInteger(stack);
    frames = frames60 * PAL_TIMING(50, 60) / 60;

    if (frames <= 0) {
        frames = 1;
    }

    EventScene->FadeInBGM(frames);
    return true;
}

/**
 *
 * Fades the background music out over a duration given in 60 Hz frames.
 *
 */
static int _FADE_OUT_BGM(dc2::script::RunArguments stack) {
    int frames60 = {};
    int frames = {};

    frames60 = dc2::script::RunInteger(stack);
    frames = frames60 * PAL_TIMING(50, 60) / 60;

    if (frames <= 0) {
        frames = 1;
    }

    EventScene->FadeOutBGM(frames);
    return true;
}

/**
 *
 * Stops the environment background music.
 *
 */
static int _STOP_ENV_BGM(dc2::script::RunArguments, int) {
    EventScene->StopEnvBGM();
    return true;
}

/**
 *
 * Sets the background music volume from an integer, or from a float scaled by the current volume.
 *
 */
static int _SET_BGM_VOL(dc2::script::RunArguments stack, int argc) {
    if (stack.At().type == RS_INT) {
        EventScene->SetVolBGM(dc2::script::RunInteger(stack));
    } else if (stack.At().type == RS_FLOAT) {
        int volume = EventScene->GetVolBGM();
        EventScene->SetVolBGM(fptosi(volume * dc2::script::RunFloat(stack)));
    } else {
        return false;
    }

    return true;
}

/**
 *
 * Does nothing and fails.
 *
 */
static int _SND_SET_REVERB(dc2::script::RunArguments, int) {
    return false;
}

/**
 *
 * Sets the volume of the environment background music.
 *
 */
static int _SND_SET_ENV_VOL(dc2::script::RunArguments stack) {
    EventScene->SetEnvBGMVol(dc2::script::RunFloat(stack));
    return true;
}

/**
 *
 * Pushes 1 when the event voice stream is loud enough to hear, or 0 when it is silent.
 *
 */
static int _STREAM_SILENT_CHECK(dc2::script::RunArguments stack) {
    int level = {};
    int loud = {};

    dc2::script::RunInteger(stack++);
    level = CSnd.StreamGetLevel(EVENT_STREAM_CHANNEL);
    loud = true;

    if (static_cast<s16>(static_cast<u16>(level)) < 11 && static_cast<s16>(static_cast<u16>(level)) >= -10 && static_cast<s16>(level >> 16) < 11 &&
        static_cast<s16>(level >> 16) >= -10) {
        loud = false;
    }

    SetStack(stack, loud);
    return true;
}

/**
 *
 * Sets the automatic environment background music change from an integer argument.
 *
 */
static int _AUTO_CHANGE_ENV(dc2::script::RunArguments stack) {
    EventScene->AutoChangeEnvBGM(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Sets the flag that skips the next background music load.
 *
 */
static int _BGM_LOAD_CANCEL(dc2::script::RunArguments, int) {
    EventScene->skip_load_bgm = true;
    return true;
}

/**
 *
 * Sets the flag that skips the next sound load.
 *
 */
static int _SOUND_LOAD_CANCEL(dc2::script::RunArguments, int) {
    EventScene->skip_load_sound = true;
    return true;
}

/**
 *
 * Clears the flag that skips the next background music load.
 *
 */
static int _BGM_LOAD_ENABLE(dc2::script::RunArguments, int) {
    EventScene->skip_load_bgm = false;
    return true;
}

/**
 *
 * Clears the flag that skips the next sound load.
 *
 */
static int _SOUND_LOAD_ENABLE(dc2::script::RunArguments, int) {
    EventScene->skip_load_sound = false;
    return true;
}

/**
 *
 * Loads a sound effect bank into the read buffer and fails if the bank is not available.
 *
 */
static int _LOAD_SE_BASE(dc2::script::RunArguments stack) {
    int bank_no = {};

    bank_no = dc2::script::RunInteger(stack);

    if (EventScene->CheckLoadSeBase(bank_no) == 0) {
        return false;
    }

    return EventScene->LoadSeBase(bank_no, ReadBufferBytes());
}

/**
 *
 * Loads a sound into the read buffer.
 *
 */
static int _LOAD_SOUND(dc2::script::RunArguments stack) {
    EventScene->LoadSound(dc2::script::RunInteger(stack), ReadBufferBytes());
    return true;
}

/**
 *
 * Ends the event voice stream and closes its channel.
 *
 */
static int _STREAM_CLOSE(dc2::script::RunArguments stack) {
    EdEventInfo.stream_playing = false;
    dc2::script::RunInteger(stack);
    CSnd.StreamSetVol(EVENT_STREAM_CHANNEL, EdEventInfo.stream_volume, EdEventInfo.stream_volume);
    CSnd.StreamClose(EVENT_STREAM_CHANNEL);
    EdEventInfo.stream_reading = false;
    return true;
}

int CommandStreamOpen2(int stream, char *name);

/**
 *
 * Opens an event voice stream by name from the voice folder and returns the open result.
 *
 */
static int _STREAM_OPEN2(dc2::script::RunArguments stack) {
    int result = {};
    dc2::script::RunInteger(stack++);
    EdEventInfo.stream_source = EVENT_STREAM_FILE;
    result = CommandStreamOpen2(EVENT_STREAM_CHANNEL, dc2::script::RunCString(stack));

    if (result == 1) {
        EdEventInfo.stream_reading = true;
    }

    return result;
}

/**
 *
 * Loads a background music pack and fails if the music cannot be loaded or its buffer is missing.
 *
 */
static int _LOAD_BGM_PACK(dc2::script::RunArguments stack) {
    int  bgm_no = {};
    u32 *pack = {};

    bgm_no = dc2::script::RunInteger(stack);

    if (EventScene->CheckLoadBGM(bgm_no) == 0) {
        return false;
    }

    std::string file_name = EventScene->GetBgmFile(bgm_no);
    const auto  file_read = dc2::event::ReadFile(file_name.data());
    pack = reinterpret_cast<u32 *>(file_read.Bytes().data());

    if (pack != nullptr) {
        return EventScene->LoadBGMPack(bgm_no, pack);
    }

    return false;
}

/**
 *
 * Pushes the load number of the active background music.
 *
 */
static int _GET_BGM_NO(dc2::script::RunArguments stack, int argc) {
    SetStack(stack, EventScene->GetActiveBgmInfo()->load_no);
    return true;
}

/**
 *
 * Pushes the master volume of the active background music.
 *
 */
static int _GET_MASTER_VOL(dc2::script::RunArguments stack, int argc) {
    SetStack(stack, EventScene->GetActiveBgmInfo()->master_volf);
    return true;
}

/**
 *
 * Sets the master volume of the active background music from a float.
 *
 */
static int _SET_MASTER_VOL(dc2::script::RunArguments stack) {
    float   volume = {};
    CScene *scene = {};

    volume = dc2::script::RunFloat(stack);
    scene = EventScene;
    scene->GetActiveBgmInfo()->master_volf = volume;
    scene->SetVolfBGM(scene->GetActiveBgmInfo()->volf);
    return true;
}

/**
 *
 * Pushes the battle background music volume.
 *
 */
static int _GET_BTL_BGM_VOL(dc2::script::RunArguments stack) {
    DNG_BATTLE_AREA *battle_bgm = {};

    battle_bgm = &EventScene->battle_area;

    if (battle_bgm == nullptr) {
        return false;
    }

    SetStack(stack, battle_bgm->battle_bgm_vol);
    return true;
}

/**
 *
 * Sets the battle background music volume from a float.
 *
 */
static int _SET_BTL_BGM_VOL(dc2::script::RunArguments stack) {
    DNG_BATTLE_AREA *battle_bgm = &EventScene->battle_area;

    if (battle_bgm == nullptr) {
        return false;
    }

    battle_bgm->battle_bgm_vol = dc2::script::RunFloat(stack);
    return true;
}

/**
 *
 * Turns the sound reverb on or off from an integer flag.
 *
 */
static int _SND_IN_REVERB(dc2::script::RunArguments stack) {
    CSnd.SndInReverb(dc2::script::RunInteger(stack) != 0);
    return true;
}

/**
 *
 * Stops the sound effect sources of the scene.
 *
 */
static int _SND_STOP_SRC(dc2::script::RunArguments, int) {
    EventScene->StopSeSrc();
    return true;
}

/**
 *
 * Pauses the background music.
 *
 */
static int _SND_PAUSE_BGM(dc2::script::RunArguments, int) {
    EventScene->PauseBGM();
    return true;
}

/**
 *
 * Opens an event voice stream from its numbered wave file.
 *
 */
static int _STREAM_OPEN3(dc2::script::RunArguments stack) {
    char name[64];

    dc2::script::RunInteger(stack++);
    const int length = std::snprintf(name, sizeof name, "sound/%07d.wav", dc2::script::RunInteger(stack));
    if (length < 0 || static_cast<std::size_t>(length) >= sizeof name) {
        return false;
    }
    EdEventInfo.stream_source = EVENT_STREAM_WAVE;
    CSnd.StreamOpenFast(EVENT_STREAM_CHANNEL, name);
    EdEventInfo.stream_reading = true;
    return true;
}

/**
 *
 * Saves the status of the active background music into the event's BGM status.
 *
 */
static int _GET_ACTIVE_BGM_STATUS(dc2::script::RunArguments, int) {
    EventScene->GetActiveBgmStatus(&EdEventInfo.bgm_status);
    return true;
}

/**
 *
 * Restores the active background music from the event's BGM status.
 *
 */
static int _SET_ACTIVE_BGM_STATUS(dc2::script::RunArguments, int) {
    EventScene->SetActiveBgmStatus(&EdEventInfo.bgm_status);
    return true;
}

/**
 *
 * Pushes the load number from the event's BGM status and fails unless called with one argument.
 *
 */
static int _GET_BGM_STATUS_NOW_NO(dc2::script::RunArguments stack, int argc) {
    if (argc != 1) {
        return false;
    }

    SetStack(stack, EdEventInfo.bgm_status.load_no);
    return true;
}

/**
 *
 * Pushes the status of a sound effect for a sound id and voice, and fails unless called with three arguments.
 *
 */
static int _GET_SE_STATUS(dc2::script::RunArguments stack, int argc) {
    if (argc != 3) {
        return false;
    }

    int se_id = dc2::script::RunInteger(stack++);
    int voice = dc2::script::RunInteger(stack++);

    argc = sndGetSeStatus(se_id, voice);
    SetStack(stack, argc);
    return true;
}

/**
 *
 * Stops all sound effects of the scene.
 *
 */
static int _SE_ALL_STOP(dc2::script::RunArguments, int) {
    EventScene->SeAllStop();
    return true;
}

/**
 *
 * Stops all sounds of the scene.
 *
 */
static int _SOUND_ALL_STOP(dc2::script::RunArguments, int) {
    EventScene->SoundAllStop();
    return true;
}

/**
 *
 * Sets the flag that skips the next background music play.
 *
 */
static int _BGM_PLAY_CANCEL(dc2::script::RunArguments, int) {
    EventScene->skip_play_bgm = true;
    return true;
}

/**
 *
 * Clears the flag that skips the next background music play.
 *
 */
static int _BGM_PLAY_ENABLE(dc2::script::RunArguments, int) {
    EventScene->skip_play_bgm = false;
    return true;
}

/**
 *
 * Pushes the default background music number of the current map or of a given map.
 *
 */
static int _GET_DEF_BGM_NO(dc2::script::RunArguments stack, int argc) {
    int snd_id = {};
    int bgm_no = {};

    if (argc == 1) {
        CScene *scene = EventScene;
        int     map = scene->now_map_no;
        int     sub = scene->now_sub_map_no;

        if (0 < sub) {
            snd_id = GetMapSndDataID(sub);
        } else {
            snd_id = GetMapSndDataID(map);
        }

        bgm_no = EventScene->GetDefBgmNo(snd_id);
        SetStack(stack, bgm_no);
        return true;
    }

    if (argc == 2) {
        snd_id = GetMapSndDataID(dc2::script::RunInteger(stack++));
        bgm_no = EventScene->GetDefBgmNo(snd_id);
        SetStack(stack, bgm_no);
        return true;
    }

    return false;
}

/**
 *
 * Enables movie captions or sets the text and timing of one caption, by sub-command.
 *
 */
static int _SET_MOVIE_CC(dc2::script::RunArguments stack, int argc) {
    int   i = {};
    int   no = {};
    int   start = {};
    char *text = {};
    int   frames = {};
    int   mode = dc2::script::RunInteger(stack++);

    switch (mode) {
        case EVENT_CAPTION_ENABLE:
            EdEventInfo.caption_enable = dc2::script::RunInteger(stack);

            if (EdEventInfo.caption_enable == 0) {
                for (i = 0; i < EVENT_CAPTION_NUM; i++) {
                    EdEventInfo.caption_start[i] = 0;
                    memset(EdEventInfo.caption_text[i], 0, sizeof(EdEventInfo.caption_text[i]));
                    EdEventInfo.caption_frames[i] = 0;
                }
            }

            break;
        case EVENT_CAPTION_SET:
            no = dc2::script::RunInteger(stack++);
            start = dc2::script::RunInteger(stack++);
            text = dc2::script::RunCString(stack++);
            frames = dc2::script::RunInteger(stack);

            if (no < 0) {
                return false;
            }

            if (no >= EVENT_CAPTION_NUM) {
                return false;
            }

            if (text == nullptr || !dc2::text::Fits(text, sizeof EdEventInfo.caption_text[no])) {
                return false;
            }

            start = start * PAL_TIMING(50, 60) / 60;
            frames = frames * PAL_TIMING(50, 60) / 60;
            EdEventInfo.caption_start[no] = start;
            dc2::text::Copy(EdEventInfo.caption_text[no], dc2::text::View(text));
            EdEventInfo.caption_frames[no] = frames;
            break;
        default:
            return false;
    }

    return true;
}

/**
 *
 * Registers a villager from a memory block in the scene.
 *
 */
static int _REGISTER_VILLAGER2(dc2::script::RunArguments stack) {
    int        villager_no = {};
    int        mode = {};
    mgCMemory *memory = {};

    villager_no = dc2::script::RunInteger(stack++);
    mode = dc2::script::RunInteger(stack++);
    memory = EventScene->GetStack(dc2::script::RunInteger(stack));

    if (memory == nullptr) {
        return false;
    }

    EventScene->RegisterVillager(villager_no, mode, memory);
    return true;
}

/**
 *
 * Sets or resets the fishing tournament state, or counts a tour, by sub-command.
 *
 */
static int _SET_FISHINGTOURNAMENT_ETC(dc2::script::RunArguments stack, int argc) {
    CFishingTournament *tournament = {};
    auto                next = stack + 1;

    switch (dc2::script::RunInteger(stack)) {
        case EVENT_SET_FISHING_RANK:
            tournament = GetFishTournament();

            if (tournament == nullptr) {
                return false;
            }

            tournament->SetRank(dc2::script::RunInteger(next));
            break;
        case EVENT_SET_FISHING_RESET_RECORD:
            tournament = GetFishTournament();

            if (tournament == nullptr) {
                return false;
            }

            tournament->ResetRecord();
            break;
        case EVENT_SET_FISHING_LOAD_PRIZE:
            InitFishPrize();
            LoadFishPrize(1);
            break;
        case EVENT_SET_FISHING_COUNT_TOUR:
            TuriTourCount();
            break;
        default:
            return false;
    }

    return true;
}

/**
 *
 * Attaches an event object handle to a scene character.
 *
 */
static int _EOH_SYNC_CHARA(dc2::script::RunArguments stack) {
    CCharacter2 *chara = {};
    int          slot = {};
    int          chara_no = {};

    slot = dc2::script::RunInteger(stack++);
    chara_no = dc2::script::RunInteger(stack);
    chara = GetChara(chara_no);

    if (chara != nullptr) {
        return EventObjHandleMother.Set(slot, EOH_TYPE_CHARA, chara_no, chara);
    }

    return false;
}

/**
 *
 * Attaches an event object handle to a map part or to a piece of one.
 *
 */
static int _EOH_SYNC_OBJ(dc2::script::RunArguments stack, int argc) {
    CMap      *maps[8];
    int        map_count = {};
    int        i = {};
    CMapParts *parts{};
    int        slot = {};
    int        parts_id = {};
    char      *parts_name = {};

    if (argc < 2 || argc > 4) {
        return false;
    }

    map_count = EventScene->GetActiveMap(maps, 8);

    if (!(map_count > 0)) {
        return false;
    }

    slot = dc2::script::RunInteger(stack++);

    switch (stack.At().type) {
        case RS_INT:
            parts_id = dc2::script::RunInteger(stack++);

            for (i = 0; i < map_count; i++) {
                parts = maps[i]->GetPlaceParts(parts_id);

                if (parts != nullptr) {
                    break;
                }
            }

            break;
        case RS_STR:
            parts_name = dc2::script::RunCString(stack++);

            for (i = 0; i < map_count; i++) {
                parts = maps[i]->GetPlaceParts(parts_name);

                if (parts != nullptr) {
                    break;
                }
            }

            break;
    }

    if (parts == nullptr) {
        return false;
    }

    switch (argc) {
        case 2:
            EventObjHandleMother.Set(slot, EOH_TYPE_OBJECT, parts, true);
            break;
        case 3:
        case 4: {
            CMapPiece *piece = {};

            if ((piece = parts->SearchPiece(dc2::script::RunCString(stack++))) == nullptr) {
                return false;
            }

            if (argc == 3) {
                EventObjHandleMother.Set(slot, EOH_TYPE_OBJECT, piece, false);
            } else if (argc == 4) {
                char     *frame_name = dc2::script::RunCString(stack);
                mgCFrame *root = piece->frame;

                if (root == nullptr) {
                    return false;
                }

                mgCFrame *frame = root->SearchFrame(frame_name);

                if (frame == nullptr) {
                    return false;
                }

                EventObjHandleMother.Set(slot, EOH_TYPE_FRAME, frame);
            }

            break;
        }
        default:
            return false;
    }

    return true;
}

/**
 *
 * Attaches an event object handle to an edit map part or to a piece of one.
 *
 */
static int _EOH_SYNC_EDIT_OBJ(dc2::script::RunArguments stack, int argc) {
    int         slot = {};
    CEditMap   *edit_map = {};
    CEditParts *parts{};
    int         parts_id = {};
    char       *parts_name = {};

    if (argc < 2 || argc > 4) {
        return false;
    }

    edit_map = static_cast<CEditMap *>(EventScene->GetMap(EventScene->active_map));
    slot = dc2::script::RunInteger(stack++);

    switch (stack.At().type) {
        case RS_INT:
            parts_id = dc2::script::RunInteger(stack++);
            parts = edit_map->GetePlaceParts(parts_id);
            break;
        case RS_STR:
            parts_name = dc2::script::RunCString(stack++);
            parts = edit_map->GetePlaceParts(parts_name);
            break;
    }

    if (parts == nullptr) {
        return false;
    }

    switch (argc) {
        case 2:
            EventObjHandleMother.Set(slot, EOH_TYPE_OBJECT, parts, true);
            break;
        case 3:
        case 4: {
            CMapPiece *piece = {};

            if ((piece = parts->SearchPiece(dc2::script::RunCString(stack++))) == nullptr) {
                return false;
            }

            if (argc == 3) {
                EventObjHandleMother.Set(slot, EOH_TYPE_OBJECT, piece, false);
            } else if (argc == 4) {
                char     *frame_name = dc2::script::RunCString(stack);
                mgCFrame *root = piece->frame;

                if (root == nullptr) {
                    return false;
                }

                mgCFrame *frame = root->SearchFrame(frame_name);

                if (frame == nullptr) {
                    return false;
                }

                EventObjHandleMother.Set(slot, EOH_TYPE_FRAME, frame);
            }

            break;
        }
        default:
            return false;
    }

    return true;
}

/**
 *
 * Attaches an event object handle to an event sprite.
 *
 */
static int _EOH_SYNC_SPRITE(dc2::script::RunArguments stack) {
    CEventSprite2 *sprite = {};
    int            slot = {};

    slot = dc2::script::RunInteger(stack++);
    sprite = GetEventSprite(dc2::script::RunInteger(stack));

    if (sprite != nullptr) {
        return EventObjHandleMother.Set(slot, EOH_TYPE_SPRITE, sprite);
    }

    return false;
}

/**
 *
 * Sets an event object position from direct arguments or an argument list.
 *
 */
static int _EOH_SET_POS(dc2::script::RunArguments stack, int argc) {
    float                       pos[4];
    int                         slot = {};
    dc2::script::EventArguments args(std::span<ARG_DATA>{});

    switch (argc) {
        case 1:
            args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            slot = GetArgInt(args++);
            GetArgVector(pos, args);
            break;
        case 4:
            slot = dc2::script::RunInteger(stack++);
            GetStackVector(pos, stack);
            break;
        default:
            return false;
    }

    return EventObjHandleMother.SetPos(slot, pos[0], pos[1], pos[2]);
}

/**
 *
 * Sets an event object rotation from direct arguments or an argument list.
 *
 */
static int _EOH_SET_ROT(dc2::script::RunArguments stack, int argc) {
    float                       rot[4];
    int                         slot = {};
    dc2::script::EventArguments args(std::span<ARG_DATA>{});

    switch (argc) {
        case 1:
            args = FindArgData(dc2::script::RunInteger(stack));

            if (args.Remaining() == 0) {
                return false;
            }

            slot = GetArgInt(args++);
            GetArgVector(rot, args);
            break;
        case 4:
            slot = dc2::script::RunInteger(stack++);
            GetStackVector(rot, stack);
            break;
        default:
            return false;
    }

    rot[0] = mgAngleLimit(rot[0]);
    rot[1] = mgAngleLimit(rot[1]);
    rot[2] = mgAngleLimit(rot[2]);
    return EventObjHandleMother.SetRot(slot, rot[0], rot[1], rot[2]);
}

/**
 *
 * Writes an event object position to the script stack and returns the lookup status.
 *
 */
static int _EOH_GET_POS(dc2::script::RunArguments stack, int argc) {
    float pos[4];

    int result = EventObjHandleMother.GetPos(dc2::script::RunInteger(stack++), pos);

    if (result != 0) {
        SetOutputVector(stack, {pos[0], pos[1], pos[2]});
        stack = stack + 2;
    }

    return result;
}

/**
 *
 * Writes an event object rotation to the script stack and returns the lookup status.
 *
 */
static int _EOH_GET_ROT(dc2::script::RunArguments stack, int argc) {
    float rot[4];

    int result = EventObjHandleMother.GetRot(dc2::script::RunInteger(stack++), rot);

    if (result != 0) {
        SetOutputVector(stack, {rot[0], rot[1], rot[2]});
        stack = stack + 2;
    }

    return result;
}

/**
 *
 * Sets an event object motion from direct arguments or an argument list.
 *
 */
static int _EOH_SET_MOTION(dc2::script::RunArguments stack, int argc) {
    int   index = {};
    int   type = 0;
    float blend = -1.0f;
    char *name = {};

    switch (argc) {
        case 1: {
            auto args = FindArgData(dc2::script::RunInteger(stack), argc);

            if (args.Remaining() == 0) {
                return false;
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
            index = dc2::script::RunInteger(stack++);
            name = dc2::script::RunCString(stack++);

            if (argc >= 3) {
                type = dc2::script::RunInteger(stack++);
            }

            if (argc >= 4) {
                blend = dc2::script::RunFloat(stack);
            }

            break;
        default:
            return false;
    }

    return EventObjHandleMother.SetMotion(index, name, type, blend);
}

/**
 *
 * Sets an event object motion step and returns the update status.
 *
 */
static int _EOH_SET_STEP(dc2::script::RunArguments stack, int argc) {
    argc = dc2::script::RunInteger(stack++);
    return EventObjHandleMother.SetStep(argc, dc2::script::RunFloat(stack));
}

/**
 *
 * Sets an event object texture animation from one name, or from an off name and an on name.
 *
 */
static int _EOH_SET_TEX_ANIM(dc2::script::RunArguments stack, int argc) {
    int no = dc2::script::RunInteger(stack);

    switch (stack.At(1).type) {
        case RS_INT:
            if (argc == 2) {
                return EventObjHandleMother.SetTexAnim(no, 0, nullptr);
            }

            if (argc == 3) {
                int result = EventObjHandleMother.SetTexAnim(no, dc2::script::RunInteger(stack + 1), dc2::script::RunCString(stack + 2));
                return result;
            }

            return false;
        case RS_STR: {
            if (argc == 2) {
                return EventObjHandleMother.SetTexAnim(no, 1, dc2::script::RunCString(stack + 1));
            }

            char *off_name = dc2::script::RunCString(stack + 1);
            char *on_name = dc2::script::RunCString(stack + 2);
            return EventObjHandleMother.SetTexAnim(no, 0, off_name) ? EventObjHandleMother.SetTexAnim(no, 1, on_name) : 0;
        }
    }

    return false;
}

/**
 *
 * Sets an event object scale.
 *
 */
static int _EOH_SET_SCALE(dc2::script::RunArguments stack) {
    int   no = dc2::script::RunInteger(stack++);
    float x = dc2::script::RunFloat(stack++);
    float y = dc2::script::RunFloat(stack++);
    float z = dc2::script::RunFloat(stack);
    return EventObjHandleMother.SetScale(no, x, y, z);
}

/**
 *
 * Sets an event object visibility and returns the update status.
 *
 */
static int _EOH_SET_SHOW(dc2::script::RunArguments stack) {
    int slot = {};

    slot = dc2::script::RunInteger(stack++);
    return EventObjHandleMother.SetShow(slot, dc2::script::RunInteger(stack));
}

/**
 *
 * Writes an event object visibility to the script stack and returns the lookup status.
 *
 */
static int _EOH_GET_SHOW(dc2::script::RunArguments stack, int argc) {
    auto next_slot = stack;

    next_slot = stack + 1;

    int show = {};

    int result = EventObjHandleMother.GetShow(dc2::script::RunInteger(stack), &show);

    if (result != 0) {
        SetStack(next_slot, show);
    }

    return result;
}

/**
 *
 * Sets an event object frame visibility and returns the update status.
 *
 */
static int _EOH_SET_FRAME_SHOW(dc2::script::RunArguments stack) {
    int   slot = {};
    char *frame_name = {};

    slot = dc2::script::RunInteger(stack++);
    frame_name = dc2::script::RunCString(stack++);
    return EventObjHandleMother.SetFrameShow(slot, frame_name, dc2::script::RunInteger(stack) != 0 ? 1 : 0);
}

/**
 *
 * Sets an event object shadow and returns the update status.
 *
 */
static int _EOH_SET_SHADOW(dc2::script::RunArguments stack) {
    int slot = {};

    slot = dc2::script::RunInteger(stack++);
    return EventObjHandleMother.SetShadow(slot, dc2::script::RunInteger(stack));
}

/**
 *
 * Sets an event object translation.
 *
 */
static int _EOH_SET_TRANSLATE(dc2::script::RunArguments stack) {
    float translate[4];
    int   no = dc2::script::RunInteger(stack++);
    translate[0] = dc2::script::RunFloat(stack++);
    translate[1] = dc2::script::RunFloat(stack++);
    translate[2] = dc2::script::RunFloat(stack);
    translate[3] = 1.0f;
    return EventObjHandleMother.SetTranslate(no, translate);
}

/**
 *
 * Sets an event object footstep sound identifier and returns the update status.
 *
 */
static int _EOH_SET_FOOT_SOUND_ID(dc2::script::RunArguments stack) {
    int slot = {};

    slot = dc2::script::RunInteger(stack++);
    return EventObjHandleMother.SetFootSoundID(slot, dc2::script::RunInteger(stack));
}

/**
 *
 * Sets an event object frame visibility and returns the update status.
 *
 */
static int _EOH_SET_FRAME_STATUS(dc2::script::RunArguments stack) {
    int   slot = {};
    char *frame_name = {};

    slot = dc2::script::RunInteger(stack++);
    frame_name = dc2::script::RunCString(stack++);
    return EventObjHandleMother.SetFrameShow(slot, frame_name, dc2::script::RunInteger(stack));
}

/**
 *
 * Writes an event object frame position to the script stack and returns the lookup status.
 *
 */
static int _EOH_GET_FRAME_POS(dc2::script::RunArguments stack) {
    float pos[4];
    int   no = dc2::script::RunInteger(stack++);
    char *name = dc2::script::RunCString(stack++);

    int result = EventObjHandleMother.GetFramePos(no, name, pos);

    if (result != 0) {
        SetOutputVector(stack, {pos[0], pos[1], pos[2]});
        stack = stack + 2;
    }

    return result;
}

/**
 *
 * Sets an event object sound identifier and returns the update status.
 *
 */
static int _EOH_SET_SOUND_ID(dc2::script::RunArguments stack) {
    int slot = {};

    slot = dc2::script::RunInteger(stack++);
    return EventObjHandleMother.SetSoundID(slot, dc2::script::RunInteger(stack));
}

/**
 *
 * Pushes the visibility of a frame of an event object.
 *
 */
static int _EOH_GET_FRAME_STATUS(dc2::script::RunArguments stack, int argc) {
    int   no = dc2::script::RunInteger(stack++);
    char *name = dc2::script::RunCString(stack++);
    SetStack(stack, EventObjHandleMother.GetFrameShow(no, name));
    return true;
}

/**
 *
 * Attaches an event object handle to a frame of a scene character.
 *
 */
static int _EOH_SYNC_CHROBJ(dc2::script::RunArguments stack) {
    int          slot = dc2::script::RunInteger(stack++);
    int          chara_no = dc2::script::RunInteger(stack++);
    char        *name = dc2::script::RunCString(stack);
    CCharacter2 *chara = GetChara(chara_no);

    if (chara == nullptr) {
        return false;
    }

    if (chara->CObjectFrame::frame == nullptr) {
        return false;
    }

    mgCFrame *frame = {};

    if ((frame = chara->CObjectFrame::frame->SearchFrame(name)) == nullptr) {
        return false;
    }

    frame->SetRotType(2);
    return EventObjHandleMother.Set(slot, EOH_TYPE_FRAME, frame);
}

/**
 *
 * Sets an event object fade flag and returns the update status.
 *
 */
static int _EOH_SET_FADE_FLAG(dc2::script::RunArguments stack) {
    int slot = {};

    slot = dc2::script::RunInteger(stack++);
    return EventObjHandleMother.SetFadeFlag(slot, dc2::script::RunInteger(stack));
}

/**
 *
 * Resets an event object animation position and returns the update status.
 *
 */
static int _EOH_RESET_DA_POSITION(dc2::script::RunArguments stack) {
    return EventObjHandleMother.ResetDAPosition(dc2::script::RunInteger(stack));
}

/**
 *
 * Sets an event object shadow frame visibility and returns the update status.
 *
 */
static int _EOH_SET_SHADOW_FRAME_STATUS(dc2::script::RunArguments stack) {
    int   slot = {};
    char *frame_name = {};

    slot = dc2::script::RunInteger(stack++);
    frame_name = dc2::script::RunCString(stack++);
    return EventObjHandleMother.SetShadowFrameShow(slot, frame_name, dc2::script::RunInteger(stack));
}

/**
 *
 * Attaches an event handle to a geostone and returns the update status.
 *
 */
static int _EOH_SYNC_GEOSTONE(dc2::script::RunArguments stack) {
    return EventObjHandleMother.Set(dc2::script::RunInteger(stack), EOH_TYPE_CHARA, -1, &GeoStone);
}

/**
 *
 * Attaches an event object handle to a character found by name.
 *
 */
static int _EOH_SYNC_SEARCH_CHARA(dc2::script::RunArguments stack) {
    int           slot = {};
    char         *name = {};
    CActionChara *player = {};

    slot = dc2::script::RunInteger(stack++);
    dc2::script::RunInteger(stack++);
    name = dc2::script::RunCString(stack);
    player = static_cast<CActionChara *>(GetCharacter(0));

    if (player == nullptr) {
        return false;
    }

    return EventObjHandleMother.Set(slot, EOH_TYPE_CHARA, -1, player->SearchChara(name));
}

/**
 *
 * Updates an event character and returns the update status.
 *
 */
static int _EOH_NORMAL_DRIVE(dc2::script::RunArguments stack) {
    return EventObjHandleMother.NormalDrive(dc2::script::RunInteger(stack));
}

/**
 *
 * Sets the alpha of a frame of an event object.
 *
 */
static int _EOH_SET_FRAME_ALPHA(dc2::script::RunArguments stack) {
    int   no = dc2::script::RunInteger(stack++);
    char *name = dc2::script::RunCString(stack++);
    float alpha = dc2::script::RunFloat(stack);
    return EventObjHandleMother.SetFrameObjAlpha(no, name, alpha);
}

/**
 *
 * Attaches an event object handle to a function point of a map or of a map part.
 *
 */
static int _EOH_SYNC_FUNCP(dc2::script::RunArguments stack, int argc) {
    int         slot = {};
    CFuncPoint *func_point{};
    CMap       *map = {};
    map = EventScene->GetMap(EventScene->active_map);

    if (map == nullptr) {
        return false;
    }

    slot = dc2::script::RunInteger(stack++);

    switch (stack.At().type) {
        case RS_INT: {
            int        parts_no = dc2::script::RunInteger(stack++);
            char      *name = dc2::script::RunCString(stack++);
            CMapParts *parts = map->GetPlaceParts(parts_no);

            if (parts == nullptr) {
                return false;
            }

            func_point = parts->func_point_mngr.Search(name);
            break;
        }
        case RS_STR: {
            char *place_name = dc2::script::RunCString(stack++);
            char *name = dc2::script::RunCString(stack++);

            if (strcmp(place_name, "") != 0) {
                CMapParts *parts = map->GetPlaceParts(place_name);

                if (parts == nullptr) {
                    return false;
                }

                func_point = parts->func_point_mngr.Search(name);
            } else {
                func_point = map->func_point.Search(name);
            }

            break;
        }
    }

    if (func_point != nullptr) {
        return EventObjHandleMother.Set(slot, EOH_TYPE_FUNC_POINT, func_point);
    }

    return false;
}

/**
 *
 * Sets an event object footstep effect identifier and returns the update status.
 *
 */
static int _EOH_SET_FOOT_SE_ID(dc2::script::RunArguments stack) {
    int slot = {};

    slot = dc2::script::RunInteger(stack++);
    return EventObjHandleMother.SetFootSeId(slot, dc2::script::RunInteger(stack));
}

/**
 *
 * Attaches an event object handle to the auto map door parts and pushes whether it succeeded.
 *
 */
static int _EOH_SYNC_DOOR_PARTS(dc2::script::RunArguments stack, int argc) {
    int        slot = {};
    int        result = {};
    CMapParts *door = {};

    if (argc != 2) {
        return false;
    }

    result = false;
    slot = dc2::script::RunInteger(stack++);

    if ((door = AutoMapGen.SearchDoorParts()) != nullptr) {
        if (EventObjHandleMother.Set(slot, EOH_TYPE_OBJECT, door, true) != 0) {
            result = true;
        }
    }

    SetStack(stack, result);
    return true;
}

/**
 *
 * Initializes the Sphida mini-game.
 *
 */
static int _SPHIDA_INIT(dc2::script::RunArguments, int) {
    InitSphida();
    return true;
}

/**
 *
 * Allocates a Sphida object in a scene stack slot and sets up its course by kind.
 *
 */
static int _SPHIDA_SET_UP(dc2::script::RunArguments stack, int argc) {
    CSphida   *sphida = {};
    mgCMemory *memory = {};
    int        param = {};
    int        kind = {};
    auto       ptr = stack;
    int        slot = {};

    ptr = stack;
    kind = 0;
    slot = dc2::script::RunInteger(ptr++);
    param = dc2::script::RunInteger(ptr++);

    if (argc >= 3) {
        kind = dc2::script::RunInteger(ptr++);
    }

    memory = EventScene->GetStack(slot);

    if (memory == nullptr) {
        return false;
    }

    auto *storage = AllocateEventStorage(memory, (sizeof(CSphida) + 15) / 16 + 2);
    sphida = storage != nullptr ? new (storage) CSphida : nullptr;

    if (sphida == nullptr) {
        return false;
    }

    sphida->Initialize();

    switch (kind) {
        case EVENT_SPHIDA_SETUP_NORMAL:
            sphida->SetUp(param);
            break;
        case EVENT_SPHIDA_SETUP_S17:
            sphida->s17_SetUp(param);
            break;
        case EVENT_SPHIDA_SETUP_OMAKE:
            sphida->Omake_SetUp(dc2::script::RunInteger(ptr), param);
            break;
    }

    const auto lease = dc2::memory::ArenaBuffer::Bind(*memory,
                                                      {reinterpret_cast<u8 *>(sphida), sizeof(*sphida)});
    return dc2::sphida::Publish(lease);
}

/**
 *
 * Sets the Sphida play flag.
 *
 */
static int _SPHIDA_SET_PLAY_FLAG(dc2::script::RunArguments stack) {
    auto *sphida = GetSphidaPtr();
    int   flag = {};

    flag = dc2::script::RunInteger(stack);

    if (sphida == nullptr) {
        return false;
    }

    sphida->play_flag = flag;
    return true;
}

/**
 *
 * Sets the Sphida minimap flag.
 *
 */
static int _SPHIDA_SET_MINIMAP_FLAG(dc2::script::RunArguments stack) {
    auto *sphida = GetSphidaPtr();
    int   flag = {};

    flag = dc2::script::RunInteger(stack);

    if (sphida == nullptr) {
        return false;
    }

    sphida->minimap_flag = flag;
    return true;
}

/**
 *
 * Sets the flag of a Sphida minimap line.
 *
 */
static int _SPHIDA_SET_MM_LINE_FLAG(dc2::script::RunArguments stack) {
    auto *sphida = GetSphidaPtr();
    int   flag = {};

    flag = dc2::script::RunInteger(stack);

    if (sphida == nullptr) {
        return false;
    }

    sphida->mm_line_flag = flag;
    return true;
}

/**
 *
 * Sets the position of a Sphida minimap line from a vector.
 *
 */
static int _SPHIDA_SET_MM_LINE_POS(dc2::script::RunArguments stack, int argc) {
    auto *sphida = GetSphidaPtr();
    float pos[4];
    int   index = dc2::script::RunInteger(stack++);
    GetStackVector(pos, stack);

    if (sphida == nullptr) {
        return false;
    }

    if (index < 5) {
        sceVu0CopyVector(sphida->mm_line_pos[index], pos);
    }

    return true;
}

/**
 *
 * Sets the Sphida pin position from three floats.
 *
 */
static int _SPHIDA_SET_PIN_POS(dc2::script::RunArguments stack) {
    auto *sphida = GetSphidaPtr();
    float pos[4];
    pos[0] = dc2::script::RunFloat(stack++);
    pos[1] = dc2::script::RunFloat(stack++);
    pos[2] = dc2::script::RunFloat(stack);
    pos[3] = 1.0f;

    if (sphida == nullptr) {
        return false;
    }

    sceVu0CopyVector(sphida->pin_pos, pos);
    return true;
}

/**
 *
 * Pushes the Sphida pin position as three floats.
 *
 */
static int _SPHIDA_GET_PIN_POS(dc2::script::RunArguments stack) {
    auto *sphida = GetSphidaPtr();
    float pos[4];

    if (sphida == nullptr) {
        return false;
    }

    sceVu0CopyVector(pos, sphida->pin_pos);
    SetOutputVector(stack, {pos[0], pos[1], pos[2]});
    stack = stack + 2;
    return true;
}

/**
 *
 * Sets the Sphida ball position from three floats.
 *
 */
static int _SPHIDA_SET_BALL_POS(dc2::script::RunArguments stack) {
    auto *sphida = GetSphidaPtr();
    float pos[4];
    pos[0] = dc2::script::RunFloat(stack++);
    pos[1] = dc2::script::RunFloat(stack++);
    pos[2] = dc2::script::RunFloat(stack);
    pos[3] = 1.0f;

    if (sphida == nullptr) {
        return false;
    }

    sceVu0CopyVector(sphida->ball_pos, pos);
    return true;
}

/**
 *
 * Pushes the Sphida ball position as three floats.
 *
 */
static int _SPHIDA_GET_BALL_POS(dc2::script::RunArguments stack) {
    auto *sphida = GetSphidaPtr();
    float pos[4];

    if (sphida == nullptr) {
        return false;
    }

    sceVu0CopyVector(pos, sphida->ball_pos);
    SetOutputVector(stack, {pos[0], pos[1], pos[2]});
    stack = stack + 2;
    return true;
}

/**
 *
 * Sets the Sphida pin colour.
 *
 */
static int _SPHIDA_SET_PIN_COL(dc2::script::RunArguments stack) {
    auto *sphida = GetSphidaPtr();
    int   color = {};

    color = dc2::script::RunInteger(stack);

    if (sphida == nullptr) {
        return false;
    }

    sphida->pin_col = color;
    return true;
}

/**
 *
 * Pushes the Sphida pin colour.
 *
 */
static int _SPHIDA_GET_PIN_COL(dc2::script::RunArguments stack) {
    auto *sphida = GetSphidaPtr();
    if (sphida == nullptr) {
        return false;
    }

    SetStack(stack, sphida->pin_col);
    return true;
}

/**
 *
 * Sets the Sphida ball colour.
 *
 */
static int _SPHIDA_SET_BALL_COL(dc2::script::RunArguments stack) {
    auto *sphida = GetSphidaPtr();
    int   color = {};

    color = dc2::script::RunInteger(stack);

    if (sphida == nullptr) {
        return false;
    }

    sphida->ball_col = color;
    return true;
}

/**
 *
 * Pushes the Sphida ball colour.
 *
 */
static int _SPHIDA_GET_BALL_COL(dc2::script::RunArguments stack) {
    auto *sphida = GetSphidaPtr();
    if (sphida == nullptr) {
        return false;
    }

    SetStack(stack, sphida->ball_col);
    return true;
}

/**
 *
 * Sets the Sphida par count, unless debug mode is on.
 *
 */
static int _SPHIDA_SET_PAR_COUNT(dc2::script::RunArguments stack) {
    auto *sphida = GetSphidaPtr();
    int   par_count = {};

    par_count = dc2::script::RunInteger(stack);

    if (sphida == nullptr) {
        return false;
    }

    if (DebugFlag == 0) {
        sphida->par_count = par_count;
    }

    return true;
}

/**
 *
 * Pushes the Sphida par count, incremented by one in debug mode.
 *
 */
static int _SPHIDA_GET_PAR_COUNT(dc2::script::RunArguments stack) {
    auto *sphida = GetSphidaPtr();
    if (sphida == nullptr) {
        return false;
    }

    int count = {};

    if (DebugFlag != 0) {
        count = sphida->par_count + 1;
    } else {
        count = sphida->par_count;
    }

    SetStack(stack, count);
    return true;
}

/**
 *
 * Pushes the Sphida mini level.
 *
 */
static int _SPHIDA_GET_MINI_LEVEL(dc2::script::RunArguments stack) {
    auto *sphida = GetSphidaPtr();
    if (sphida == nullptr) {
        return false;
    }

    SetStack(stack, sphida->mini_level);
    return true;
}

/**
 *
 * Pushes the Sphida texture bank.
 *
 */
static int _SPHIDA_GET_TEXB(dc2::script::RunArguments stack) {
    auto *sphida = GetSphidaPtr();
    if (sphida == nullptr) {
        return false;
    }

    SetStack(stack, sphida->tex_bank);
    return true;
}

/**
 *
 * Sets the Sphida status flag.
 *
 */
static int _SPHIDA_SET_STATUS_FLAG(dc2::script::RunArguments stack) {
    auto *sphida = GetSphidaPtr();
    int   flag = {};

    flag = dc2::script::RunInteger(stack);

    if (sphida == nullptr) {
        return false;
    }

    sphida->status_flag = flag;
    return true;
}

/**
 *
 * Resets the Sphida power gauge to its idle state.
 *
 */
static int _SPHIDA_RESET_POWGAGE(dc2::script::RunArguments stack, int argc) {
    auto *sphida = GetSphidaPtr();
    if (sphida == nullptr) {
        return false;
    }

    sphida->pow_gage.state = POWGAGE_STATE_IDLE;
    sphida->pow_gage.reverse = 0;
    sphida->pow_gage.count = 0;
    sphida->pow_gage.power = 0;
    sphida->pow_gage.code = POWGAGE_CODE_NONE;
    return true;
}

/**
 *
 * Starts the Sphida power gauge.
 *
 */
static int _SPHIDA_START_POWGAGE(dc2::script::RunArguments stack, int argc) {
    auto *sphida = GetSphidaPtr();
    if (sphida == nullptr) {
        return false;
    }

    sphida->pow_gage.state = POWGAGE_STATE_START;
    return true;
}

/**
 *
 * Advances the Sphida power gauge from charge to charge set, or from impact to judge.
 *
 */
static int _SPHIDA_TRIGGER_POWGAGE(dc2::script::RunArguments stack, int argc) {
    auto *sphida = GetSphidaPtr();

    if (sphida == nullptr) {
        return false;
    }

    switch (sphida->pow_gage.state) {
        case POWGAGE_STATE_CHARGE:
            sphida->pow_gage.state = POWGAGE_STATE_CHARGE_SET;
            break;
        case POWGAGE_STATE_IMPACT:
            sphida->pow_gage.state = POWGAGE_STATE_JUDGE;
            break;
    }

    return true;
}

/**
 *
 * Pushes the power of the Sphida shot.
 *
 */
static int _SPHIDA_GET_SHOT_POW(dc2::script::RunArguments stack) {
    auto *sphida = GetSphidaPtr();
    if (sphida == nullptr) {
        return false;
    }

    SetStack(stack, sphida->pow_gage.power);
    return true;
}

/**
 *
 * Pushes the result code of the Sphida power gauge.
 *
 */
static int _SPHIDA_GET_POWGAGE_CODE(dc2::script::RunArguments stack) {
    auto *sphida = GetSphidaPtr();
    if (sphida == nullptr) {
        return false;
    }

    SetStack(stack, sphida->pow_gage.code);
    return true;
}

/**
 *
 * Sets the Sphida power gauge safe level, clamped to the range 1 to 6.
 *
 */
static int _SPHIDA_SET_POWGAGE_SAFE_LEVEL(dc2::script::RunArguments stack) {
    auto *sphida = GetSphidaPtr();
    int   level = {};

    level = dc2::script::RunInteger(stack);

    if (sphida == nullptr) {
        return false;
    }

    if (level <= 0) {
        level = 1;
    }

    if (level > 6) {
        level = 6;
    }

    sphida->pow_gage.safe_level = level;
    return true;
}

/**
 *
 * Pushes the power and the next two fields of a Sphida club definition.
 *
 */
static int _SPHIDA_GET_CULB_DEF(dc2::script::RunArguments stack) {
    GOLF_CLUB_DEF *club = GetSphidaClubDef(dc2::script::RunInteger(stack++));

    if (club == nullptr) {
        return false;
    }

    SetStack(stack++, club->power);
    SetStack(stack++, club->unk_4);
    SetStack(stack, club->unk_8);
    return true;
}

/**
 *
 * Sets the Sphida spin mark position.
 *
 */
static int _SPHIDA_SET_SPIN_MARK_POS(dc2::script::RunArguments stack) {
    auto *sphida = GetSphidaPtr();
    float x = dc2::script::RunFloat(stack++);
    float y = dc2::script::RunFloat(stack);

    if (sphida == nullptr) {
        return false;
    }

    sphida->spin_mark_pos_x = x;
    sphida->spin_mark_pos_y = y;
    return true;
}

/**
 *
 * Sets the Sphida club number.
 *
 */
static int _SPHIDA_SET_CULB_NO(dc2::script::RunArguments stack) {
    auto *sphida = GetSphidaPtr();
    int   club_no = {};

    club_no = dc2::script::RunInteger(stack);

    if (sphida == nullptr) {
        return false;
    }

    sphida->club_no = club_no;
    return true;
}

/**
 *
 * Sets the Sphida carry distance.
 *
 */
static int _SPHIDA_CALC_CARRY(dc2::script::RunArguments stack) {
    auto *sphida = GetSphidaPtr();
    float carry = dc2::script::RunFloat(stack);

    if (sphida == nullptr) {
        return false;
    }

    sphida->carry = carry;
    return true;
}

/**
 *
 * Pushes the screen position of the Sphida power gauge cursor.
 *
 */
static int _SPHIDA_GET_PG_CURSOR_POS(dc2::script::RunArguments stack) {
    auto *sphida = GetSphidaPtr();
    if (sphida == nullptr) {
        return false;
    }

    float x = 104.0f + sphida->pow_gage.pos_x - 6.5f * static_cast<float>(sphida->pow_gage.count);
    float y = sphida->pow_gage.pos_y - 32.0f;
    SetStack(stack++, x);
    SetStack(stack, y);
    return true;
}

/**
 *
 * Loads a collision model into a scene stack slot and sets it on the Sphida.
 *
 */
static int _SPHIDA_SET_COL_MODEL(dc2::script::RunArguments stack) {
    auto *sphida = GetSphidaPtr();
    if (sphida == nullptr) {
        return false;
    }

    int        stack_no = dc2::script::RunInteger(stack++);
    char      *name = dc2::script::RunCString(stack);
    mgCMemory *memory = EventScene->GetStack(stack_no);

    if (memory == nullptr) {
        return false;
    }

    const auto  file_read = dc2::event::ReadFile(name);
    MDS_HEADER *model = reinterpret_cast<MDS_HEADER *>(file_read.Bytes().data());

    if (model != nullptr) {
        return sphida->SetCollisionModel(model, memory);
    }

    return false;
}

/**
 *
 * Pushes the two prizes awarded for a Sphida hole.
 *
 */
static int _SPHIDA_GET_PRIZE(dc2::script::RunArguments stack, int argc) {
    int               prize1 = {};
    int               prize2 = {};
    CDngFloorManager *floor_manager = {};
    auto              next_slot = stack;
    DNG_BATTLE_AREA  *dng_scene = {};

    dng_scene = &EventScene->battle_area;
    floor_manager = &dng_scene->floor_manager;

    if (dng_scene == nullptr) {
        return false;
    }

    next_slot = stack + 1;

    if (floor_manager == nullptr) {
        return false;
    }

    floor_manager->GetSphedaPrize(dc2::script::RunInteger(stack), &prize1, &prize2);
    SetStack(next_slot++, prize1);
    SetStack(next_slot, prize2);
    return true;
}

/**
 *
 * Sets the last Sphida challenge.
 *
 */
static int _SPHIDA_SET_LAST_CHALLENGE(dc2::script::RunArguments stack) {
    auto *sphida = GetSphidaPtr();
    if (sphida == nullptr) {
        return false;
    }

    sphida->last_challenge = dc2::script::RunInteger(stack);
    return true;
}

/**
 *
 * Pushes the last Sphida challenge.
 *
 */
static int _SPHIDA_GET_LAST_CHALLENGE(dc2::script::RunArguments stack, int argc) {
    auto *sphida = GetSphidaPtr();
    if (sphida == nullptr || argc != 1) {
        return false;
    }

    SetStack(stack, sphida->last_challenge);

    return true;
}

/**
 *
 * Pushes the Sphida bonus course mode.
 *
 */
static int _SPHIDA_GET_OMAKE_MODE(dc2::script::RunArguments stack, int argc) {
    auto *sphida = GetSphidaPtr();
    if (sphida == nullptr || argc != 1) {
        return false;
    }

    SetStack(stack, sphida->omake_mode);

    return true;
}

/**
 *
 * Sets the current Sphida hole in the save data.
 *
 */
static int _SPHIDA_SET_NOW_HOLE(dc2::script::RunArguments stack) {
    CSubGameData *sub_game = GetSubGameSaveData();

    if (sub_game == nullptr) {
        return false;
    }

    CSphidaData *sphida_data = {};

    if ((sphida_data = sub_game->GetSphidaData()) == nullptr) {
        return false;
    }

    sphida_data->SetHorl(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Pushes the current Sphida hole from the save data.
 *
 */
static int _SPHIDA_GET_NOW_HOLE(dc2::script::RunArguments stack, int argc) {
    CSphidaData  *sphida_data = {};
    CSubGameData *sub_game = {};

    if (argc != 1) {
        return false;
    }

    sub_game = GetSubGameSaveData();

    if (sub_game == nullptr) {
        return false;
    }

    sphida_data = sub_game->GetSphidaData();

    if (sphida_data == nullptr) {
        return false;
    }

    SetStack(stack, sphida_data->GetNowHorl());
    return true;
}

/**
 *
 * Sets the Sphida score of a slot in the save data.
 *
 */
static int _SPHIDA_SET_SCORE(dc2::script::RunArguments stack) {
    CSubGameData *sub_game = GetSubGameSaveData();

    if (sub_game == nullptr) {
        return false;
    }

    CSphidaData *sphida_data = {};

    if ((sphida_data = sub_game->GetSphidaData()) == nullptr) {
        return false;
    }

    int slot = dc2::script::RunInteger(stack++);
    int score = dc2::script::RunInteger(stack);
    sphida_data->SetHorlScore(score, slot);
    return true;
}

/**
 *
 * Pushes the Sphida score of a slot from the save data.
 *
 */
static int _SPHIDA_GET_SCORE(dc2::script::RunArguments stack, int argc) {
    if (argc != 2) {
        return false;
    }

    CSubGameData *sub_game = GetSubGameSaveData();

    if (sub_game == nullptr) {
        return false;
    }

    CSphidaData *sphida_data = {};

    if ((sphida_data = sub_game->GetSphidaData()) == nullptr) {
        return false;
    }

    int slot = dc2::script::RunInteger(stack++);
    SetStack(stack, sphida_data->GetHorlScore(slot));
    return true;
}

/**
 *
 * Does nothing.
 *
 */
static int _TEST(dc2::script::RunArguments, int) {
    return true;
}

/**
 *
 * Returns the intersection test routine's script command status.
 *
 */
static int _MT_TEST(dc2::script::RunArguments stack, int argc) {
    return mt_test(stack, argc);
}

/**
 *
 * Pushes a zero vector.
 *
 */
static int _ZERO_VECTOR(dc2::script::RunArguments stack) {
    SetOutputVector(stack, {0.0f, 0.0f, 0.0f});
    return true;
}

/**
 *
 * Normalizes a vector and pushes the result.
 *
 */
static int _NORMAL_VECTOR(dc2::script::RunArguments stack, int argc) {
    const auto values = ReadOutputVector(stack);
    float      vector[4] = {values[0], values[1], values[2], 1.0f};
    sceVu0Normalize(vector, vector);
    SetOutputVector(stack, {vector[0], vector[1], vector[2]});
    return true;
}

/**
 *
 * Pushes a copy of a vector.
 *
 */
static int _COPY_VECTOR(dc2::script::RunArguments stack, int argc) {
    float vector[4];
    GetStackVector(vector, stack + 3);
    SetOutputVector(stack, {vector[0], vector[1], vector[2]});
    return true;
}

/**
 *
 * Adds a vector to a vector variable and stores the result in the variable.
 *
 */
static int _ADD_VECTOR(dc2::script::RunArguments stack, int argc) {
    const auto values = ReadOutputVector(stack);
    float      operand[4];
    GetStackVector(operand, stack + 3);
    SetOutputVector(stack, {values[0] + operand[0], values[1] + operand[1], values[2] + operand[2]});
    return true;
}

/**
 *
 * Subtracts a vector from a vector variable and stores the result in the variable.
 *
 */
static int _SUB_VECTOR(dc2::script::RunArguments stack, int argc) {
    const auto values = ReadOutputVector(stack);
    float      operand[4];
    GetStackVector(operand, stack + 3);
    SetOutputVector(stack, {values[0] - operand[0], values[1] - operand[1], values[2] - operand[2]});
    return true;
}

/**
 *
 * Scales a vector variable by a float and stores the result in the variable.
 *
 */
static int _SCALE_VECTOR(dc2::script::RunArguments stack, int argc) {
    const auto  values = ReadOutputVector(stack);
    const float scale = dc2::script::RunFloat(stack + 3);

    SetOutputVector(stack, {values[0] * scale, values[1] * scale, values[2] * scale});
    return true;
}

/**
 *
 * Divides a vector variable by a float and stores the result in the variable, failing on a zero divisor.
 *
 */
static int _DIV_VECTOR(dc2::script::RunArguments stack, int argc) {
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
 * Pushes the length of a vector.
 *
 */
static int _DIST_VECTOR(dc2::script::RunArguments stack, int argc) {
    float vec[4];
    GetStackVector(vec, stack);

    SetStack(stack + 3, mgDistVector(vec));
    return true;
}

/**
 *
 * Pushes the distance between two points.
 *
 */
static int _DIST_VECTOR2(dc2::script::RunArguments stack, int argc) {
    float from[4];
    float to[4];
    GetStackVector(from, stack);
    GetStackVector(to, stack + 3);

    SetStack(stack + 6, mgDistVector(from, to));
    return true;
}

/**
 *
 * Pushes the square root of a float.
 *
 */
static int _SQRT(dc2::script::RunArguments stack, int argc) {
    float value = dc2::script::RunFloat(stack++);
    SetStack(stack, static_cast<float>(sqrt(value)));
    return true;
}

/**
 *
 * Pushes the two-argument arctangent of two floats.
 *
 */
static int _ATAN2F(dc2::script::RunArguments stack, int argc) {
    float y = dc2::script::RunFloat(stack++);
    float x = dc2::script::RunFloat(stack++);
    SetStack(stack, atan2f(y, x));
    return true;
}

/**
 *
 * Pushes the result of comparing two angles within a tolerance.
 *
 */
static int _ANGLE_CMP(dc2::script::RunArguments stack, int argc) {
    float first_angle = dc2::script::RunFloat(stack++);
    float second_angle = dc2::script::RunFloat(stack++);
    float tolerance = dc2::script::RunFloat(stack++);
    SetStack(stack, mgAngleCmp(first_angle, second_angle, tolerance));
    return true;
}

/**
 *
 * Pushes an angle limited to the angle range.
 *
 */
static int _ANGLE_LIMIT(dc2::script::RunArguments stack, int argc) {
    RS_STACKDATA *angle = &dc2::script::RunOutput(stack);
    SetStack(stack, mgAngleLimit(angle->val.f));
    return true;
}

/**
 *
 * Pushes a random float or integer in the range given, depending on the type of the range argument.
 *
 */
static int _GET_RAND(dc2::script::RunArguments stack, int argc) {
    int int_range = {};

    if (stack.At().type == RS_FLOAT) {
        float range = dc2::script::RunFloat(stack++);
        SetStack(stack, range * static_cast<float>(rand()) / 2147483648.0f);
    } else {
        int_range = dc2::script::RunInteger(stack++);
        argc = static_cast<int>(static_cast<float>(int_range) * static_cast<float>(rand()) / 2147483648.0f);
        SetStack(stack, argc);
    }

    return true;
}

/**
 *
 * Pushes the distance from a point to a line segment, or -1 when the point projects outside the segment.
 *
 */
static int _LINE_POINT_DIST(dc2::script::RunArguments stack, int argc) {
    float segment_start[4];
    float segment_end[4];
    float point[4];
    float to_point[4];
    float direction[4];
    float segment_length = {};
    float projection = {};
    GetStackVector(segment_start, stack);
    GetStackVector(segment_end, stack + 3);
    GetStackVector(point, stack + 6);
    const auto result = stack + 9;
    segment_length = mgDistVector(segment_start, segment_end);
    sceVu0SubVector(to_point, point, segment_start);
    sceVu0SubVector(direction, segment_end, segment_start);
    sceVu0Normalize(direction, direction);
    projection = sceVu0InnerProduct(to_point, direction);

    if (projection < 0.0f || projection > segment_length) {
        SetStack(result, -1.0f);
        return true;
    }

    sceVu0ScaleVector(direction, direction, projection);
    sceVu0AddVector(direction, segment_start, direction);
    SetStack(result, mgDistVector(point, direction));
    return true;
}

/**
 *
 * Creates the sword after-image effect in a scene stack slot.
 *
 */
static int _CREATE_SWORD_EFFECT(dc2::script::RunArguments stack) {
    int               stack_no = dc2::script::RunInteger(stack++);
    int               capacity = dc2::script::RunInteger(stack++);
    int               subdivisions = dc2::script::RunInteger(stack);
    mgCMemory        *scene_stack = {};
    CSWordAfterImage *effect = {};
    scene_stack = EventScene->GetStack(stack_no);

    if (scene_stack == nullptr) {
        return false;
    }

    effect = dc2::memory::NewObject<CSWordAfterImage>(*scene_stack);
    if (effect == nullptr || !effect->Initialize(scene_stack, capacity, subdivisions)) {
        return false;
    }
    std::fill_n(effect->edge_color, 4, 0x80);
    std::fill_n(effect->back_color, 4, 0x80);
    const auto lease = dc2::memory::ArenaBuffer::Bind(*scene_stack,
                                                      {reinterpret_cast<u8 *>(effect), sizeof(*effect)});
    if (lease.Bytes().empty()) {
        return false;
    }
    sword_effect_storage = lease;
    return true;
}

/**
 *
 * Clears the sword after-image effect.
 *
 */
static int _DELETE_SWORD_EFFECT(dc2::script::RunArguments, int) {
    sword_effect_storage = {};
    return true;
}

/**
 *
 * Sets the edge and back colours of the sword after-image effect.
 *
 */
static int _SWORD_EFFECT_COLOR(dc2::script::RunArguments stack) {
    auto *effect = GetSwordEffect();
    if (effect == nullptr) {
        return false;
    }

    int edge_r = dc2::script::RunInteger(stack++);
    int edge_g = dc2::script::RunInteger(stack++);
    int edge_b = dc2::script::RunInteger(stack++);
    int edge_a = dc2::script::RunInteger(stack++);
    int back_r = dc2::script::RunInteger(stack++);
    int back_g = dc2::script::RunInteger(stack++);
    int back_b = dc2::script::RunInteger(stack++);
    int back_a = dc2::script::RunInteger(stack);
    effect->edge_color[0] = edge_r;
    effect->edge_color[1] = edge_g;
    effect->edge_color[2] = edge_b;
    effect->edge_color[3] = edge_a;
    effect->back_color[0] = back_r;
    effect->back_color[1] = back_g;
    effect->back_color[2] = back_b;
    effect->back_color[3] = back_a;
    return true;
}

/**
 *
 * Adds a point to the sword after-image effect, with an optional life.
 *
 */
static int _SWORD_EFFECT_ADD_POINT(dc2::script::RunArguments stack, int argc) {
    float edge[4];
    float back[4];
    float life = {};

    auto *effect = GetSwordEffect();
    if (effect == nullptr) {
        return true;
    }

    life = 1.0f;
    GetStackVector(edge, stack);
    stack = stack + 3;
    GetStackVector(back, stack);
    stack = stack + 3;

    if (argc >= 7) {
        life = dc2::script::RunFloat(stack++);
    }

    effect->AddPoint(edge, back, life);
    return true;
}

/**
 *
 * Adds an offset to a character's position.
 *
 */
static int _ADD_CHARA_POS(dc2::script::RunArguments stack, int argc) {
    float offset[4];
    float pos[4];
    int   chara_no = dc2::script::RunInteger(stack++);
    GetStackVector(offset, stack);
    CCharacter2 *chara = {};

    if ((chara = GetCharacter(chara_no)) == nullptr) {
        return false;
    }

    chara->GetPosition(pos);
    sceVu0AddVector(pos, pos, offset);
    chara->SetPosition(pos);
    return true;
}

/**
 *
 * Adds an offset to a character's rotation.
 *
 */
static int _ADD_CHARA_ROT(dc2::script::RunArguments stack, int argc) {
    float offset[4];
    float rot[4];
    int   chara_no = dc2::script::RunInteger(stack++);
    GetStackVector(offset, stack);
    CCharacter2 *chara = {};

    if ((chara = GetCharacter(chara_no)) == nullptr) {
        return false;
    }

    chara->GetRotation(rot);
    sceVu0AddVector(rot, rot, offset);
    rot[0] = mgAngleLimit(rot[0]);
    rot[1] = mgAngleLimit(rot[1]);
    rot[2] = mgAngleLimit(rot[2]);
    rot[3] = 1.0f;
    chara->SetRotation(rot);
    return true;
}

/**
 *
 * Places a treasure box in the dungeon battle area.
 *
 */
static int _POST_TREASURE_BOX(dc2::script::RunArguments stack, int argc) {
    float                position[4];
    CTreasureBoxManager *chest_manager = {};
    float                angle = {};
    int                  kind = {};
    int                  count = {};
    DNG_BATTLE_AREA     *dng_scene = {};

    count = 1;
    GetStackVector(position, stack);
    stack = stack + 3;
    angle = dc2::script::RunFloat(stack++);
    kind = dc2::script::RunInteger(stack++);

    if (argc >= 6) {
        count = dc2::script::RunInteger(stack);
    }

    dng_scene = &EventScene->battle_area;

    if (dng_scene == nullptr) {
        return false;
    }

    chest_manager = dng_scene->treasure_box;

    if (chest_manager == nullptr) {
        return false;
    }

    chest_manager->PutTreasureBox(-1, position, angle, 0x41, kind, count, -1, 0);
    return true;
}

/**
 *
 * Pushes the origin of the map part nearest to a sphere.
 *
 */
static int _GET_PARTS_ORIGIN(dc2::script::RunArguments stack) {
    float      center[4];
    CMapParts *parts[8];
    mgVu0FBOX  box{};
    float      origin[4];
    float      pos[4];
    float      nearest = {};
    CMap      *map = {};
    int        count = {};
    int        i = {};
    center[0] = dc2::script::RunFloat(stack++);
    center[1] = dc2::script::RunFloat(stack++);
    center[2] = dc2::script::RunFloat(stack++);
    center[3] = dc2::script::RunFloat(stack++);
    map = EventScene->GetMap(EventScene->active_map);

    if (map == nullptr) {
        return false;
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
        return false;
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
            std::memmove(origin, pos, sizeof(u_long128));
        }
    }

    SetOutputVector(stack, {origin[0], origin[1], origin[2]});
    stack = stack + 2;
    return true;
}

/**
 *
 * Advances the camera control by one step.
 *
 */
static int _CTRLC_STEP(dc2::script::RunArguments, int) {
    CCameraControl *camera = GetCamera();
    camera->Step(1);
    return true;
}

/**
 *
 * Sets the rotation angle of the camera control.
 *
 */
static int _CTRLC_SET_ROTATE(dc2::script::RunArguments stack) {
    float angle = dc2::script::RunFloat(stack);
    GetCamera()->SetRotate(angle);
    return true;
}

/**
 *
 * Rotates the camera control back by an angle.
 *
 */
static int _CTRLC_ROT_BACK(dc2::script::RunArguments stack) {
    float angle = dc2::script::RunFloat(stack);
    GetCamera()->RotBack(angle);
    return true;
}

/**
 *
 * Moves the camera control around the map polygons near a character.
 *
 */
static int _CTRLC_MOVE_CAMERA(dc2::script::RunArguments stack) {
    float           chara_pos[4];
    CCPoly          polys[256];
    mgVu0FBOX       box{};
    float           camera_ref[4];
    CCharacter2    *chara = {};
    CCameraControl *camera = {};
    CMap           *map = {};
    int             poly_count = {};
    float           distance = {};

    if ((chara = GetCharacter(dc2::script::RunInteger(stack))) == nullptr) {
        return false;
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
        return false;
    }

    if (poly_count > 0x100) {
        dc2::log::PrintGame("EVENT ERROR <CTRLC_MOVE_CAMERA camera poly over %d>\n", poly_count);
        return false;
    }

    camera->MoveCamera(&PadCtrl, chara_pos, polys, poly_count);
    return true;
}

/**
 *
 * Sets the mask of inputs that cancel camera rotation.
 *
 */
static int _CTRLC_SET_ROT_CANCEL(dc2::script::RunArguments stack) {
    int mask = {};

    mask = dc2::script::RunInteger(stack);
    GetCamera()->SetRotCameraCancel(mask);
    return true;
}

/**
 *
 * Sets the near height, far height and distance range of the active camera parameters.
 *
 */
static int _CTRLC_MOVE_RANGE(dc2::script::RunArguments stack) {
    CameraCtrlParam *param = GetCamera()->GetActiveParam();
    param->near_height = dc2::script::RunFloat(stack++);
    param->far_height = dc2::script::RunFloat(stack++);
    param->min_dist = dc2::script::RunFloat(stack++);
    param->max_dist = dc2::script::RunFloat(stack);
    return true;
}

/**
 *
 * Pushes the position of the treasure box nearest to a point, or -1 when none is within range.
 *
 */
static int _GET_NEAR_TBOX_POS(dc2::script::RunArguments stack, int argc) {
    float                target[4];
    float                box_pos[4];
    DNG_BATTLE_AREA     *dng_scene = {};
    int                  nearest = {};
    int                  i = {};
    CTreasureBoxManager *box_manager = {};
    float                nearest_dist = {};
    float                dist = {};
    CTreasureBox        *box = {};

    dng_scene = &EventScene->battle_area;

    if (dng_scene == nullptr) {
        return false;
    }

    box_manager = dng_scene->treasure_box;

    if (box_manager == nullptr) {
        return false;
    }

    nearest = -1;
    GetStackVector(target, stack);

    stack = stack + 3;
    nearest_dist = 9999.0f;

    for (i = 0; i < TREASURE_BOX_MAX; i++) {
        box = &box_manager->box[i];

        if (box != nullptr && (box == nullptr || box->state != 0)) {
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

    SetOutputVector(stack, {box_pos[0], box_pos[1], box_pos[2]});
    stack = stack + 3;
    SetStack(stack, nearest);
    return true;
}

/**
 *
 * Does nothing and fails.
 *
 */
static int _CONV_CHRNO_S2L(dc2::script::RunArguments, int) {
    return false;
}

/**
 *
 * Creates a sword after-effect on a character.
 *
 */
static int _SWE_INIT(dc2::script::RunArguments stack) {
    int          chara_no = dc2::script::RunInteger(stack++);
    int          slot = dc2::script::RunInteger(stack++);
    int          stack_no = dc2::script::RunInteger(stack++);
    int          capacity = dc2::script::RunInteger(stack++);
    int          subdivisions = dc2::script::RunInteger(stack);
    CCharacter2 *chara = {};

    if ((chara = GetCharacter(chara_no)) == nullptr) {
        return false;
    }

    if (slot < 0 || slot >= CHARA_SWORD_EFFECT_MAX) {
        return false;
    }

    mgCMemory *scene_stack = {};

    if ((scene_stack = EventScene->GetStack(stack_no)) == nullptr) {
        return false;
    }

    auto *storage = AllocateEventStorage(scene_stack, (sizeof(CSWordAfterEffect) + sizeof(u_long128) - 1) / sizeof(u_long128));
    if (storage == nullptr) {
        return false;
    }
    auto *effect = new (storage) CSWordAfterEffect;
    effect->Initialize(scene_stack, capacity, subdivisions);
    if (!dc2::character::RetainResource(*chara, dc2::character::ResourceChannel::Sword, slot, *scene_stack)) {
        return false;
    }
    chara->sword_effect[slot] = effect;
    return true;
}

/**
 *
 * Sets the two colours of a character's sword after-effect.
 *
 */
static int _SWE_SET_COLOR(dc2::script::RunArguments stack) {
    int                 color0_r = {};
    int                 color0_g = {};
    int                 color0_b = {};
    int                 color0_a = {};
    int                 color1_r = {};
    int                 color1_g = {};
    int                 color1_b = {};
    int                 color1_a = {};
    int                 chara_no = {};
    int                 slot = {};
    CCharacter2        *chara = {};
    CSWordAfterEffect **effect_slot = {};
    chara_no = dc2::script::RunInteger(stack++);
    slot = dc2::script::RunInteger(stack++);

    if ((chara = GetCharacter(chara_no)) == nullptr) {
        return false;
    }

    if (slot < 0 || slot >= CHARA_SWORD_EFFECT_MAX) {
        return false;
    }
    effect_slot = &chara->sword_effect[slot];

    if (*effect_slot == nullptr) {
        return false;
    }

    color0_r = dc2::script::RunInteger(stack++);
    color0_g = dc2::script::RunInteger(stack++);
    color0_b = dc2::script::RunInteger(stack++);
    color0_a = dc2::script::RunInteger(stack++);
    color1_r = dc2::script::RunInteger(stack++);
    color1_g = dc2::script::RunInteger(stack++);
    color1_b = dc2::script::RunInteger(stack++);
    color1_a = dc2::script::RunInteger(stack);
    CSWordAfterEffect *effect = *effect_slot;
    effect->color0[0] = color0_r;
    effect->color0[1] = color0_g;
    effect->color0[2] = color0_b;
    effect->color0[3] = color0_a;
    effect->color1[0] = color1_r;
    effect->color1[1] = color1_g;
    effect->color1[2] = color1_b;
    effect->color1[3] = color1_a;
    return true;
}

/**
 *
 * Sets the texture of a character's sword after-effect.
 *
 */
static int _SWE_SET_TEXTURE(dc2::script::RunArguments stack, int argc) {
    mgCTexture         *texture = {};
    int                 block_no = {};
    char               *name = {};
    int                 u0 = {};
    int                 v0 = {};
    int                 u1 = {};
    int                 v1 = {};
    CSWordAfterEffect **effect_slot = {};
    CCharacter2        *chara = {};
    int                 slot = {};
    int                 chara_no = {};
    chara_no = dc2::script::RunInteger(stack++);
    slot = dc2::script::RunInteger(stack++);

    if ((chara = GetCharacter(chara_no)) == nullptr) {
        return false;
    }

    if (slot < 0 || slot >= CHARA_SWORD_EFFECT_MAX) {
        return false;
    }
    effect_slot = &chara->sword_effect[slot];

    if (*effect_slot == nullptr) {
        return false;
    }

    block_no = dc2::script::RunInteger(stack++);
    name = dc2::script::RunCString(stack++);
    u0 = dc2::script::RunInteger(stack++);
    v0 = dc2::script::RunInteger(stack++);
    u1 = dc2::script::RunInteger(stack++);
    v1 = dc2::script::RunInteger(stack);

    if ((texture = mgTexManager.GetTexture(name, block_no)) == nullptr) {
        return false;
    }

    (*effect_slot)->SetTexture(block_no, texture, u0, v0, u1, v1);
    return true;
}

/**
 *
 * Starts a character's sword after-effect between two frames.
 *
 */
static int _SWE_START_EFFECT(dc2::script::RunArguments stack, int argc) {
    int                 chara_no = {};
    int                 slot = {};
    CCharacter2        *chara = {};
    char               *from_name = {};
    char               *to_name = {};
    int                 length = {};
    int                 frames = {};
    int                 hold_time = {};
    CSWordAfterEffect **effect_slot = {};
    mgCFrame           *from_frame = {};
    mgCFrame           *to_frame = {};
    chara_no = dc2::script::RunInteger(stack++);
    slot = dc2::script::RunInteger(stack++);

    if ((chara = GetCharacter(chara_no)) == nullptr) {
        return false;
    }

    if (slot < 0 || slot >= CHARA_SWORD_EFFECT_MAX) {
        return false;
    }
    effect_slot = &chara->sword_effect[slot];

    if (*effect_slot == nullptr) {
        return false;
    }

    from_name = dc2::script::RunCString(stack++);
    to_name = dc2::script::RunCString(stack++);
    length = dc2::script::RunInteger(stack++);
    frames = dc2::script::RunInteger(stack++);
    hold_time = dc2::script::RunInteger(stack);

    if (chara->CObjectFrame::frame == nullptr) {
        return false;
    }

    if ((from_frame = chara->CObjectFrame::frame->SearchFrame(from_name)) == nullptr) {
        return false;
    }

    if (chara->CObjectFrame::frame == nullptr) {
        return false;
    }

    if ((to_frame = chara->CObjectFrame::frame->SearchFrame(to_name)) == nullptr) {
        return false;
    }

    (*effect_slot)->StartEffect(from_frame, to_frame, length, frames, hold_time);
    return true;
}

/**
 *
 * Sets the type of a scene character.
 *
 */
static int _SET_CHARA_TYPE(dc2::script::RunArguments stack) {
    int chara_no = {};

    chara_no = dc2::script::RunInteger(stack++);
    EventScene->SetType(SCENE_DATA_CHARA, chara_no, dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Pushes a field of the triggered event data.
 *
 */
static int _GET_EVENT_DATA(dc2::script::RunArguments stack, int argc) {
    CSceneEventData *event_data = {};

    event_data = &EventScene->event_data;

    if (event_data == nullptr) {
        return false;
    }

    switch (dc2::script::RunInteger(stack++)) {
        case EVENT_DATA_FLAG:
            SetStack(stack, static_cast<int>(event_data->event.flag));
            break;
        case EVENT_DATA_EVENT_NO:
            SetStack(stack, event_data->event.event_no);
            break;
        case EVENT_DATA_POINT_NO:
            SetStack(stack, event_data->event.point_no);
            break;
        case EVENT_DATA_ARG1:
            SetStack(stack, event_data->event.arg1);
            break;
        case EVENT_DATA_ARG2:
            SetStack(stack, event_data->event.arg2);
            break;
        case EVENT_DATA_ARG3:
            SetStack(stack, event_data->event.arg3);
            break;
        case EVENT_DATA_MAP_CHECK_TYPE:
            SetStack(stack, event_data->map_event.check_type);
            break;
        case EVENT_DATA_MAP_EVENT_NO:
            SetStack(stack, event_data->map_event.event_no);
            break;
        case EVENT_DATA_MAP_TRANSFORM:
            SetStack(stack++, event_data->map_event.matrix[3][0]);
            SetStack(stack++, event_data->map_event.matrix[3][1]);
            SetStack(stack++, event_data->map_event.matrix[3][2]);
            SetStack(stack, atan2f(event_data->map_event.matrix[2][0], event_data->map_event.matrix[2][2]));
            break;
        case EVENT_DATA_MAP_PARTS_NO:
            SetStack(stack, event_data->map_event.parts_no);
            break;
        case EVENT_DATA_POSITION:
            SetStack(stack++, event_data->position[0]);
            SetStack(stack++, event_data->position[1]);
            SetStack(stack, event_data->position[2]);
            break;
        case EVENT_DATA_ROTATION:
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
        case EVENT_DATA_SCALE:
            SetStack(stack++, event_data->scale[0]);
            SetStack(stack++, event_data->scale[1]);
            SetStack(stack, event_data->scale[2]);
            break;
        case EVENT_DATA_CHARA_SLOT:
            SetStack(stack, event_data->chara_slot);
            break;
        case EVENT_DATA_CHARA_NO:
            SetStack(stack, event_data->chara_no);
            break;
        case EVENT_DATA_GAMEOBJ_NO:
            SetStack(stack, event_data->gameobj_no);
            break;
        default:
            return false;
    }

    return true;
}

/**
 *
 * Sets the previous floor of the current dungeon stage in the save data.
 *
 */
static int _DNG_SET_PREV_FLOOR(dc2::script::RunArguments stack) {
    int        floor = dc2::script::RunInteger(stack);
    CSaveData *save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    CSaveDataDungeon *dungeon = &save->save_dungeon;

    if (dungeon == nullptr) {
        return false;
    }

    dungeon->prev_floor_id[dungeon->stage_id] = floor;
    return true;
}

/**
 *
 * Pushes the previous floor of the current dungeon stage from the save data.
 *
 */
static int _DNG_GET_PREV_FLOOR(dc2::script::RunArguments stack) {
    CSaveData *save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    CSaveDataDungeon *dungeon = &save->save_dungeon;

    if (dungeon == nullptr) {
        return false;
    }

    SetStack(stack, dungeon->prev_floor_id[dungeon->stage_id]);
    return true;
}

/**
 *
 * Does nothing and fails.
 *
 */
static int _DNG_SET_FAST_FLOOR(dc2::script::RunArguments, int) {
    return false;
}

/**
 *
 * Sets a field of a dungeon floor's save info.
 *
 */
static int _SET_FLOOR_INFO(dc2::script::RunArguments stack) {
    int        dungeon_no = dc2::script::RunInteger(stack++);
    int        floor_no = dc2::script::RunInteger(stack++);
    int        field = dc2::script::RunInteger(stack++);
    CSaveData *save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    CSaveDataDungeon *dungeon = &save->save_dungeon;

    if (dungeon == nullptr) {
        return false;
    }

    DNG_FLOOR_SAVE *info = {};

    if ((info = dungeon->GetFloorInfoPtr(dungeon_no, floor_no)) == nullptr) {
        return false;
    }

    switch (field) {
        case 0:
            info->unk_0 = static_cast<int>(dc2::script::RunFloat(stack));
            break;
        case 1:
            info->fast_destroy_time = static_cast<int>(dc2::script::RunFloat(stack));
            break;
        case 2:
            info->unk_8 = dc2::script::RunInteger(stack);
            break;
        case 3:
            info->unk_a = dc2::script::RunInteger(stack);
            break;
        case 4:
            info->spheda_clear = dc2::script::RunInteger(stack);
            break;
        case 5:
            info->flag |= static_cast<u16>(dc2::script::RunInteger(stack));
            break;
        case 6:
            info->kill_count = dc2::script::RunInteger(stack);
            break;
        case 7:
            info->visit_count = dc2::script::RunInteger(stack);
            break;
        default:
            return false;
    }

    return true;
}

/**
 *
 * Pushes a field of a dungeon floor's save info.
 *
 */
static int _GET_FLOOR_INFO(dc2::script::RunArguments stack) {
    int        dungeon_no = dc2::script::RunInteger(stack++);
    int        floor_no = dc2::script::RunInteger(stack++);
    int        field = dc2::script::RunInteger(stack++);
    CSaveData *save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    CSaveDataDungeon *dungeon = &save->save_dungeon;

    if (dungeon == nullptr) {
        return false;
    }

    DNG_FLOOR_SAVE *info = dungeon->GetFloorInfoPtr(dungeon_no, floor_no);

    if (info == nullptr) {
        return false;
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
            return false;
    }

    return true;
}

/**
 *
 * Pushes the next floor ID of a dungeon route.
 *
 */
static int _GET_NEXT_FLOOR(dc2::script::RunArguments stack, int argc) {
    int              floor = dc2::script::RunInteger(stack++);
    int              route = dc2::script::RunInteger(stack++);
    DNG_BATTLE_AREA *dng_scene = &EventScene->battle_area;

    if (dng_scene == nullptr) {
        return false;
    }

    CDngFloorManager *floor_manager = &dng_scene->floor_manager;

    if (floor_manager == nullptr) {
        return false;
    }

    argc = floor_manager->GetDngMapNextFloorID(floor, route);
    SetStack(stack, argc);
    return true;
}

/**
 *
 * Turns off pad auto repeat.
 *
 */
static int _PAD_AUTO_REPEAT_OFF(dc2::script::RunArguments, int) {
    GamePad__2.AutoRepeatOff();
    return true;
}

/**
 *
 * Sets the pad auto repeat mask, delay and interval.
 *
 */
static int _PAD_SET_AUTO_REPEAT(dc2::script::RunArguments stack) {
    int mask = dc2::script::RunInteger(stack++);
    int delay = dc2::script::RunInteger(stack++);
    int interval = dc2::script::RunInteger(stack);
    GamePad__2.SetAutoRepeat(mask, delay, interval);
    return true;
}

/**
 *
 * Sets or clears the pause flags of the dungeon battle area.
 *
 */
static int _DNG_PAUSE(dc2::script::RunArguments stack) {
    int              mask = dc2::script::RunInteger(stack++);
    int              enable = dc2::script::RunInteger(stack);
    DNG_BATTLE_AREA *dng_scene = &EventScene->battle_area;

    if (dng_scene == nullptr) {
        return false;
    }

    if (enable) {
        dng_scene->pause_flag |= mask;
    } else {
        dng_scene->pause_flag &= ~mask;
    }

    return true;
}

/**
 *
 * Pushes the masked pause flags of the dungeon battle area.
 *
 */
static int _DNG_CHECK_PAUSE(dc2::script::RunArguments stack) {
    int              mask = dc2::script::RunInteger(stack++);
    DNG_BATTLE_AREA *dng_scene = &EventScene->battle_area;

    if (dng_scene == nullptr) {
        return false;
    }

    int pause_flags = dng_scene->pause_flag;
    SetStack(stack, pause_flags & mask);
    return true;
}

/**
 *
 * Resets the timer of the dungeon battle area.
 *
 */
static int _DNG_RESET_TIMER(dc2::script::RunArguments stack, int argc) {
    DNG_BATTLE_AREA *dng_scene = {};

    dng_scene = &EventScene->battle_area;

    if (dng_scene == nullptr) {
        return false;
    }

    dng_scene->timer = 0;
    return true;
}

/**
 *
 * Pushes the timer of the dungeon battle area.
 *
 */
static int _DNG_GET_TIMER(dc2::script::RunArguments stack) {
    DNG_BATTLE_AREA *dng_scene = {};

    dng_scene = &EventScene->battle_area;

    if (dng_scene == nullptr) {
        return false;
    }

    SetStack(stack, dng_scene->timer);
    return true;
}

/**
 *
 * Loads a character skin from a pack file into a scene stack slot.
 *
 */
static int _LOAD_SKIN(dc2::script::RunArguments stack, int argc) {
    int                        stack_no = {};
    int                        image_block = {};
    int                        chara_no = {};
    char                      *info_name = {};
    char                      *pack_file{};
    std::optional<std::string> item_path;
    CCharacter2               *chara = {};
    mgCMemory                 *scene_stack = {};
    mgCTextureManager         *tex_manager = {};
    stack_no = dc2::script::RunInteger(stack++);

    switch (stack.At().type) {
        case RS_INT:
            item_path = ItemFilePath(dc2::script::RunInteger(stack++), 0);
            if (!item_path) {
                return false;
            }
            pack_file = item_path->data();
            break;
        case RS_STR:
            pack_file = dc2::script::RunCString(stack++);
            break;
    }

    info_name = dc2::script::RunCString(stack++);
    chara_no = dc2::script::RunInteger(stack);

    if ((chara = GetCharacter(chara_no)) == nullptr) {
        return false;
    }

    if (0 > (image_block = EventScene->GetCharaTexb(chara_no))) {
        return false;
    }

    if ((scene_stack = EventScene->GetStack(stack_no)) == nullptr) {
        return false;
    }

    const auto file_read = dc2::event::ReadFile(pack_file);
    if ((pack_file = reinterpret_cast<char *>(file_read.Bytes().data())) == nullptr) {
        return false;
    }

    tex_manager = &mgTexManager;

    if (chara_no >= 8) {
        const int length = std::snprintf(tex_manager->name_suffix, sizeof tex_manager->name_suffix, "ev%d", chara_no);
        if (length < 0 || static_cast<std::size_t>(length) >= sizeof tex_manager->name_suffix) {
            return false;
        }
    }

    chara->LoadSkin(reinterpret_cast<u32 *>(pack_file), info_name, "", scene_stack, image_block);

    if (chara_no >= 8) {
        tex_manager->name_suffix[0] = 0;
    }

    return true;
}

/**
 *
 * Checks for map collision along a segment, pushing the hit position and the hit flag.
 *
 */
static int _CHK_CAMERA_COL(dc2::script::RunArguments stack, int argc) {
    float     from[4];
    float     to[4];
    float     hit_pos[4];
    mgVu0FBOX box{};
    CCPoly    polys[256];
    CMap     *map = {};
    float     radius = {};
    int       poly_count = {};
    int       hit = {};
    GetStackVector(from, stack);
    GetStackVector(to, stack + 3);
    stack = stack + 6;
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

    if (map == nullptr) {
        return false;
    }

    poly_count = map->GetCameraPoly(polys, box, 0x100);

    if (poly_count >= 0x100) {
        return false;
    }

    hit = CheckHit(polys, poly_count, from, to, hit_pos, 1, 1);

    switch (argc) {
        case 10:
            SetOutputVector(stack, {hit_pos[0], hit_pos[1], hit_pos[2]});
            stack = stack + 3;
        case 7:
            SetStack(stack, hit);
            break;
        default:
            return false;
    }

    return true;
}

/**
 *
 * Pushes the position of a named function point on the map part nearest to a sphere.
 *
 */
static int _GET_PARTS_FUNC_POS(dc2::script::RunArguments stack) {
    float      center[4];
    CMapParts *parts[8];
    mgVu0FBOX  box{};
    float      parts_pos[4];
    float      func_parts_pos[4];
    float      func_pos[4];
    float      nearest = {};
    CMap      *map = {};
    char      *name = {};
    int        count = {};
    int        nearest_no = {};
    int        i = {};
    center[0] = dc2::script::RunFloat(stack++);
    center[1] = dc2::script::RunFloat(stack++);
    center[2] = dc2::script::RunFloat(stack++);
    center[3] = dc2::script::RunFloat(stack++);
    name = dc2::script::RunCString(stack++);
    map = EventScene->GetMap(EventScene->active_map);

    if (map == nullptr) {
        return false;
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
        return false;
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
        return false;
    }

    CFuncPoint *func_point = parts[nearest_no]->func_point_mngr.Search(name);

    if (func_point == nullptr) {
        SetStack(stack, 0);
    } else {
        parts[nearest_no]->GetPosition(func_parts_pos);
        std::memmove(func_pos, func_point->position, sizeof(u_long128));
        sceVu0AddVector(func_pos, func_pos, func_parts_pos);
        SetStack(stack++, 1);
        SetOutputVector(stack, {func_pos[0], func_pos[1], func_pos[2]});
        stack = stack + 2;
    }

    return true;
}

/**
 *
 * Pushes a position inside a random circle.
 *
 */
static int _RANDOM_CIRCLE_GET_POS(dc2::script::RunArguments stack, int argc) {
    float pos[4];
    int   circle_id = dc2::script::RunInteger(stack++);

    if (RandomCircle.GetPosition(pos, circle_id) <= -1) {
        return false;
    }

    SetOutputVector(stack, {pos[0], pos[1], pos[2]});
    stack = stack + 2;
    return true;
}

/**
 *
 * Deactivates a random circle, or the circle that was hit when given -1.
 *
 */
static int _RANDOM_CIRCLE_OFF(dc2::script::RunArguments stack) {
    int circle_id = dc2::script::RunInteger(stack);

    if (circle_id == -1) {
        int current = RandomCircle.hit;

        if (current != -1) {
            RandomCircle.active[current] = 0;
        }
    } else {
        RandomCircle.active[circle_id] = 0;
    }

    return true;
}

/**
 *
 * Exchanges the map lighting.
 *
 */
static int _DNG_XCHG_MAP_LIGHT(dc2::script::RunArguments, int) {
    XChgMapLighting();
    return true;
}

/**
 *
 * Turns off the geostone animation.
 *
 */
static int _GEOSTONE_ANIME_OFF(dc2::script::RunArguments, int) {
    GeoStone.anime = 0;
    return true;
}

/**
 *
 * Sets the geostone flag.
 *
 */
static int _GEOSTONE_SET_FLAG(dc2::script::RunArguments stack) {
    GeoStone.SetFlag(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Sets the geostone frame reference to a named frame of a character.
 *
 */
static int _GEOSTONE_SET_REFERENCE(dc2::script::RunArguments stack) {
    int          chara_no = dc2::script::RunInteger(stack++);
    char        *name = dc2::script::RunCString(stack);
    CCharacter2 *chara = GetChara(chara_no);

    if (chara == nullptr) {
        return false;
    }

    if (chara->CObjectFrame::frame == nullptr) {
        return false;
    }

    mgCFrame *reference = chara->CObjectFrame::frame->SearchFrame(name);

    if (reference == nullptr) {
        return false;
    }

    if (GeoStone.CObjectFrame::frame == nullptr) {
        return false;
    }

    GeoStone.CObjectFrame::frame->SetReference(reference);
    return true;
}

/**
 *
 * Deletes the geostone frame reference.
 *
 */
static int _GEOSTONE_DEL_REFERENCE(dc2::script::RunArguments stack, int argc) {
    if (GeoStone.CObjectFrame::frame == nullptr) {
        return false;
    }

    GeoStone.CObjectFrame::frame->DeleteReference();
    return true;
}

/**
 *
 * Pushes the move type of the robo character.
 *
 */
static int _GET_ROBO_MOVE_TYPE(dc2::script::RunArguments stack, int argc) {
    SetStack(stack, (static_cast<CActionChara *>(GetCharacter(0)))->move_type);
    return true;
}

/**
 *
 * Sets the scene exit flag.
 *
 */
static int _SET_EXIT_FLAG(dc2::script::RunArguments stack) {
    EventScene->exit_flag = dc2::script::RunInteger(stack);
    return true;
}

/**
 *
 * Pushes the scene exit flag.
 *
 */
static int _GET_EXIT_FLAG(dc2::script::RunArguments stack) {
    SetStack(stack, EventScene->exit_flag);
    return true;
}

/**
 *
 * Pushes the E3 version, which is always zero.
 *
 */
static int _GET_E3_VERSION(dc2::script::RunArguments stack) {
    SetStack(stack, 0);
    return true;
}

/**
 *
 * Pushes the state of a pad button.
 *
 */
static int _CHK_PAD_CTRL(dc2::script::RunArguments stack, int argc) {
    if (argc != 2) {
        return false;
    }

    int button = dc2::script::RunInteger(stack++);
    SetStack(stack, PadCtrl.Btn(button));
    return true;
}

/**
 *
 * Puts the camera control into its stay state.
 *
 */
static int _CTRLC_STAY(dc2::script::RunArguments, int) {
    CCameraControl *camera = GetCamera();
    camera->Stay();
    return true;
}

/**
 *
 * Sets the bright rate of the battle area from a stack float.
 *
 */
static int _BSCN_SET_BLIGHT_RATE(dc2::script::RunArguments stack) {
    DNG_BATTLE_AREA *info = &EventScene->battle_area;

    if (info == nullptr) {
        return false;
    }

    info->bright_rate = dc2::script::RunFloat(stack);
    return true;
}

/**
 *
 * Pushes the trap ID of a random circle.
 *
 */
static int _GET_RND_CIRCLE_TRAPID(dc2::script::RunArguments stack, int argc) {
    int circle_id = dc2::script::RunInteger(stack++);
    SetStack(stack, GetRandomCircleTrapID(circle_id));
    return true;
}

/**
 *
 * Sets the status of a random circle and pushes the resulting value.
 *
 */
static int _SET_RND_CIRCLE_STATUS(dc2::script::RunArguments stack) {
    float result = {};
    int   circle_id = dc2::script::RunInteger(stack++);
    SetRandamCircleStatus(circle_id, result);
    SetStack(stack, result);
    return true;
}

/**
 *
 * Shows or hides the battle area status bar, optionally with a speed.
 *
 */
static int _SET_STATUSBAR_SHOW(dc2::script::RunArguments stack, int argc) {
    DNG_BATTLE_AREA *area = &EventScene->battle_area;

    if (area == nullptr) {
        return false;
    }

    float speed = 0.02f;

    if (argc <= 0 || argc > 2) {
        return false;
    }

    int show = dc2::script::RunInteger(stack++);

    if (argc == 2) {
        speed = dc2::script::RunFloat(stack);
    }

    if (speed < 1.0f) {
        speed *= PAL_TIMING(1.2f, 1.0f);
    }

    area->SetStatusBar(show, speed);

    if (!(speed < 1.0f)) {
        if (show) {
            area->statusbar_rate = 1.0f;
        } else {
            area->statusbar_rate = 0.0f;
        }
    }

    return true;
}

/**
 *
 * Spawns pull items at a vector position with a type, count and value.
 *
 */
static int _SET_PULL_ITEM(dc2::script::RunArguments stack, int argc) {
    float             pos[4];
    float             velocity[4];
    int               type = {};
    int               count = {};
    float             value = {};
    CUserDataManager *user_data = {};
    CSaveData        *save_data = {};
    int               i = {};
    CPullItem        *item = {};
    int               chara_no = {};
    GetStackVector(pos, stack);
    stack = stack + 3;
    type = dc2::script::RunInteger(stack++);
    count = dc2::script::RunInteger(stack++);
    value = dc2::script::RunFloat(stack);
    user_data = nullptr;
    save_data = GetSaveData();

    if (save_data != nullptr) {
        user_data = &save_data->user_data;
    }

    if (user_data == nullptr) {
        return false;
    }

    chara_no = user_data->active_chr_no;

    for (i = 0; i < count; i++) {
        item = PullItemMan.GetList(2);

        if (item == nullptr) {
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

    return true;
}

/**
 *
 * Opens the dungeon character change menu.
 *
 */
static int _MENU_CHARA_CHENGE(dc2::script::RunArguments stack) {
    dc2::script::RunInteger(stack);
    MenuArg.open_type = MENU_OPEN_CHARA_CHANGE_DUNGEON;
    EdEventInfo.command_mode = EVENT_COMMAND_SUB_MODE;
    return true;
}

/**
 *
 * Pushes the sound ID stored in the event info at an index.
 *
 */
static int _GET_EVENT_INFO_SNDID(dc2::script::RunArguments stack) {
    int index = dc2::script::RunInteger(stack++);
    SetStack(stack, EdEventInfo.snd_id[index]);
    return true;
}

/**
 *
 * Pushes the position of a map parts, looked up by ID or name.
 *
 */
static int _GET_PARTS_POS(dc2::script::RunArguments stack, int argc) {
    CMap      *maps[8];
    float      pos[4];
    CMapParts *parts{};
    int        map_count = {};
    int        i = {};
    int        parts_id = {};
    char      *parts_name = {};
    map_count = EventScene->GetActiveMap(maps, 8);

    if (!(map_count > 0)) {
        return false;
    }

    switch (stack.At().type) {
        case RS_INT:
            parts_id = dc2::script::RunInteger(stack++);

            for (i = 0; i < map_count; i++) {
                parts = maps[i]->GetPlaceParts(parts_id);

                if (parts != nullptr) {
                    break;
                }
            }

            break;
        case RS_STR:
            parts_name = dc2::script::RunCString(stack++);

            for (i = 0; i < map_count; i++) {
                parts = maps[i]->GetPlaceParts(parts_name);

                if (parts != nullptr) {
                    break;
                }
            }

            break;
    }

    if (parts == nullptr) {
        return false;
    }

    parts->GetPosition(pos);
    SetOutputVector(stack, {pos[0], pos[1], pos[2]});
    stack = stack + 2;
    return true;
}

/**
 *
 * Cancels the current drama scene.
 *
 */
static int _CANCEL_DRAMA_SCENE(dc2::script::RunArguments, int) {
    CancelDramaScene();
    return true;
}

/**
 *
 * Pushes the current frame of the random circle model.
 *
 */
static int _GET_RNDC_MOT_NOWT(dc2::script::RunArguments stack) {
    float weight = RandomCircle.model.frame;
    SetStack(stack, weight);
    return true;
}

/**
 *
 * Sets the current motion frame of a character.
 *
 */
static int _SET_CHARA_MOT_NOWT(dc2::script::RunArguments stack) {
    int          chara_no = dc2::script::RunInteger(stack++);
    float        time = dc2::script::RunFloat(stack);
    CCharacter2 *chara = GetCharacter(chara_no);

    if (chara == nullptr) {
        return false;
    }

    chara->frame = time;
    return true;
}

/**
 *
 * Runs the normal drive update on a character.
 *
 */
static int _CHARA_NORMAL_DRIVE(dc2::script::RunArguments stack) {
    CCharacter2 *chara = {};
    chara = GetCharacter(dc2::script::RunInteger(stack));

    if (chara == nullptr) {
        return false;
    }

    chara->NormalDrive();
    return true;
}

/**
 *
 * Resets the DA position of a character and steps its DA animation.
 *
 */
static int _CHARA_RESET_DA(dc2::script::RunArguments stack) {
    CCharacter2 *chara = {};

    if ((chara = GetCharacter(dc2::script::RunInteger(stack))) == nullptr) {
        return false;
    }

    chara->ResetDAPosition();
    chara->StepDA(0xA);
    return true;
}

/**
 *
 * Switches the dungeon main unit to another character and reloads its icons and sounds.
 *
 */
static int _DNG_SETUP_MAIN_UNIT(dc2::script::RunArguments stack) {
    mgCTexture        *icons[2];
    int                chara_no = {};
    CUserDataManager  *user_data = {};
    mgCTextureManager *manager = {};
    int                i = {};
    CActionChara      *chara = {};
    int                bank = {};
    CSaveData         *save_data = {};
    chara_no = dc2::script::RunInteger(stack);
    save_data = GetSaveData();

    if (save_data == nullptr) {
        return false;
    }

    user_data = &save_data->user_data;

    if (user_data == nullptr) {
        return false;
    }

    if (chara_no == user_data->active_chr_no) {
        return false;
    }

    ColPrimMan.Delete(0);
    manager = &mgTexManager;

    for (i = 0; i < 8; i++) {
        manager->DeleteBlock(i + 0x10);
    }

    FxScriptMan->AllClearEffSpt();
    FxScriptMan->ClearBaseFromLevel(2);
    manager->DeleteBlock(MONSTER_EFFECT_TEX_BLOCK);
    DngUserData->SetActiveChrNo(chara_no);
    if (!SetupMainUnit(ReadBufferBytes(), &BuffCharacter, BaseCharacter, 0x10, EventScene, user_data, chara_no, 0)) {
        return false;
    }

    if ((chara = static_cast<CActionChara *>(GetCharacter(0))) == nullptr) {
        return false;
    }

    char item_texture_path[] = "textures/img/allitem.json";
    if (LoadFile(item_texture_path, ReadBufferBytes(), nullptr) <= 0) {
        return false;
    }
    manager->EnterIMGFile(reinterpret_cast<u_char *>(read_buffer), 0x50, nullptr, nullptr);
    icons[0] = manager->GetTexture("icon_dmy1", -1);
    icons[1] = manager->GetTexture("icon_dmy2", -1);
    CopyActiveIconTexture(icons, chara_no, nullptr);
    manager->DeleteBlock(0x50);
    chara->sound_info.foot_se_bank = EventScene->se_base_id;
    chara->sound_info.foot_sound_id = -1;
    std::string sound_path = dc2::character::SoundAssetPath(DngUserData, chara_no);
    if (sound_path.empty() || LoadFile(sound_path.data(), ReadBufferBytes(), nullptr) == 0) {
        return false;
    }
    bank = 3;

    if (chara_no == USER_CHARA_ROBO) {
        bank = 1;
    }

    if (chara_no == USER_CHARA_MONSTER) {
        bank = 0;
    }

    sndInitPort(SND_PORT_CHARA);
    chara->sound_info.se_bank = sndLoadSound(SND_PORT_CHARA, reinterpret_cast<u32 *>(read_buffer), &BaseCharacter[bank]);
    chara->sound_info.se_bank_2 = EventScene->se_battle_id;
    chara->SetSoundInfoCopy();
    chara->effect_man = FxScriptMan;
    DngUserData->SetActiveChrNo(chara_no);
    return true;
}

/**
 *
 * Adds or removes a character from the party, or pushes whether it is a member.
 *
 */
static int _JOIN_PARTY_MEMBER(dc2::script::RunArguments stack, int argc) {
    int               chara_no = {};
    CUserDataManager *user_data = {};
    CSaveData        *save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    user_data = &save->user_data;

    if (user_data == nullptr) {
        return false;
    }

    chara_no = dc2::script::RunInteger(stack++);

    switch (stack.At().type) {
        case RS_INT:
            if (dc2::script::RunInteger(stack) == 1) {
                user_data->JoinPartyMember(chara_no);
            } else {
                user_data->LeavePartyMember(chara_no);
            }

            break;
        case RS_PTR: {
            int members = user_data->GetNowPartyMember();
            SetStack(stack, (members & (1 << chara_no)) ? 1 : 0);
            break;
        }
        default:
            return false;
    }

    return true;
}

/**
 *
 * Enables or disables a character for party changes.
 *
 */
static int _SET_CHARA_CHANGE_FLAG(dc2::script::RunArguments stack) {
    int               chara_no = {};
    CUserDataManager *user_data = {};
    CSaveData        *save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    user_data = &save->user_data;

    if (user_data == nullptr) {
        return false;
    }

    chara_no = dc2::script::RunInteger(stack++);

    if (dc2::script::RunInteger(stack) == 1) {
        user_data->EnableCharaChange(chara_no);
    } else {
        user_data->DisableCharaChange(chara_no);
    }

    return true;
}

/**
 *
 * Enables or disables a character in the party change mask.
 *
 */
static int _SET_CHARA_CHANGE_MASK(dc2::script::RunArguments stack) {
    int               chara_no = {};
    CUserDataManager *user_data = {};
    CSaveData        *save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    user_data = &save->user_data;

    if (user_data == nullptr) {
        return false;
    }

    chara_no = dc2::script::RunInteger(stack++);

    if (dc2::script::RunInteger(stack) == 1) {
        user_data->EnableCharaChangeMask(chara_no);
    } else {
        user_data->DisableCharaChangeMask(chara_no);
    }

    return true;
}

/**
 *
 * Sets the equipped item of a character.
 *
 */
static int _SET_CHARA_EQUIP(dc2::script::RunArguments stack) {
    int        chara_no = {};
    int        item_no = {};
    CSaveData *save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    CUserDataManager *user_data = &save->user_data;

    if (user_data == nullptr) {
        return false;
    }

    chara_no = dc2::script::RunInteger(stack++);
    item_no = dc2::script::RunInteger(stack);
    return user_data->SetChrEquip(chara_no, item_no);
}

/**
 *
 * Loads a background pack file and marks the event pack as loaded.
 *
 */
static int _LOAD_PACK_FILE(dc2::script::RunArguments stack) {
    return dc2::event::LoadPack(dc2::script::RunCString(stack));
}

/**
 *
 * Sets or resets a bit in the save data bit control.
 *
 */
static int _SET_BIT_CTRL(dc2::script::RunArguments stack) {
    CSaveData *save = {};
    int        bit = {};

    if ((save = GetSaveData()) == nullptr) {
        return false;
    }

    bit = dc2::script::RunInteger(stack++);

    if (dc2::script::RunInteger(stack) == 1) {
        save->SetBitCtrl(bit);
    } else {
        save->ResetBitCtrl(bit);
    }

    return true;
}

/**
 *
 * Pushes whether a bit is set in the save data bit control.
 *
 */
static int _GET_BIT_CTRL(dc2::script::RunArguments stack, int argc) {
    CSaveData *save = {};
    int        bit = {};
    int        ctrl = {};

    if ((save = GetSaveData()) == nullptr) {
        return false;
    }

    bit = dc2::script::RunInteger(stack++);
    ctrl = save->GetBitCtrl();
    SetStack(stack, (ctrl & bit) ? 1 : 0);
    return true;
}

/**
 *
 * Loads event script argument data from a file into the argument slot.
 *
 */
static int _LOAD_ARG(dc2::script::RunArguments stack) {
    int        stack_no = dc2::script::RunInteger(stack++);
    char      *file_name = dc2::script::RunCString(stack);
    mgCMemory *memory = {};

    if ((memory = EventScene->GetStack(stack_no)) == nullptr) {
        return false;
    }

    int  program_size = 0;
    u32 *program = {};

    const auto file_read = dc2::event::ReadFile(file_name);
    program_size = file_read.Size();
    if ((program = reinterpret_cast<u32 *>(file_read.Bytes().data())) == nullptr || program_size <= 0) {
        return false;
    }

    EventScriptArg.memory = memory;
    EventScriptArg.next_id = 0;
    EventScriptArg.list = nullptr;
    EventScriptArg.list_num = 0;
    EventScriptArg.BuildArgData({reinterpret_cast<u8 *>(program), static_cast<std::size_t>(program_size)});
    return true;
}

/**
 *
 * Pushes the number of an item the player has.
 *
 */
static int _GET_ITEM_HAVE_NUM(dc2::script::RunArguments stack, int argc) {
    int item_id = dc2::script::RunInteger(stack++);
    argc = GetUserItemHaveNum(item_id);
    SetStack(stack, argc);
    return true;
}

/**
 *
 * Sets the button that skips the event.
 *
 */
static int _SET_SKIP_BOTTON(dc2::script::RunArguments stack, int argc) {
    if (argc != 1) {
        return false;
    }

    EdEventInfo.skip_button = dc2::script::RunInteger(stack);
    return true;
}

/**
 *
 * Sets the fade colour used when the event is skipped.
 *
 */
static int _SET_SKIP_FCOL(dc2::script::RunArguments stack, int argc) {
    if (argc != 3) {
        return false;
    }

    GetStackVector(EdEventInfo.skip_fade_color, stack);
    EdEventInfo.skip_fade_color[3] = 0;
    return true;
}

/**
 *
 * Pushes the debug mode flag, which is always set.
 *
 */
static int _GET_DEBUG_MODE(dc2::script::RunArguments stack) {
    SetStack(stack, 1);
    return true;
}

/**
 *
 * Pushes the type of a map, looked up by number or name.
 *
 */
static int _GET_MAP_TYPE(dc2::script::RunArguments stack, int argc) {
    int  map_no = {};
    auto result = stack;

    switch (stack.At().type) {
        case RS_INT:
            result = stack + 1;
            map_no = dc2::script::RunInteger(stack);
            break;
        case RS_STR:
            result = stack + 1;
            map_no = SearchMapNo(dc2::script::RunCString(stack));
            break;
        default:
            return false;
    }

    SetStack(result, GetMapType(map_no));
    return true;
}

/**
 *
 * Reinitializes all dungeon collision primitives.
 *
 */
static int _DNG_COLLISION_ALL_CLR(dc2::script::RunArguments, int) {
    ColPrimMan.Initialize(DngMainScene);
    return true;
}

/**
 *
 * Sets whether the event map is drawn.
 *
 */
static int _SET_MAP_DRAW(dc2::script::RunArguments stack) {
    EdEventInfo.map_draw = dc2::script::RunInteger(stack);
    return true;
}

/**
 *
 * Pushes the Monica load flag of the current init argument and clears it.
 *
 */
static int _CHECK_MC_LOAD(dc2::script::RunArguments stack) {
    INIT_LOOP_ARG *arg = GetNowInitArg();

    if (arg == nullptr) {
        return false;
    }

    SetStack(stack, arg->mc_load);
    arg->mc_load = 0;
    return true;
}

/**
 *
 * Sets the current map number of the event scene.
 *
 */
static int _SET_NOW_MAP_NO(dc2::script::RunArguments stack) {
    EventScene->SetNowMapNo(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Pushes the parameters of the treasure box nearest the player.
 *
 */
static int _GET_TBOX_PARAM(dc2::script::RunArguments stack) {
    DNG_BATTLE_AREA *area = &EventScene->battle_area;

    if (area == nullptr) {
        return false;
    }

    CTreasureBoxManager *manager = area->treasure_box;

    if (manager == nullptr) {
        return false;
    }

    int           near_box = manager->near_box;
    int           box_no = near_box;
    CTreasureBox *box = &manager->box[box_no];

    if (box == nullptr) {
        return false;
    }

    SetStack(stack++, box->flags);
    SetStack(stack++, box->item[0]);
    SetStack(stack++, box->item[1]);
    SetStack(stack++, box->num[0]);
    SetStack(stack, box->num[1]);
    return true;
}

/**
 *
 * Skips loading the villagers and sub villagers.
 *
 */
static int _CANCEL_LOAD_VILLAGER(dc2::script::RunArguments stack, int argc) {
    CScene *scene = EventScene;
    scene->skip_load_sub_villager = 1;
    scene->skip_load_villager = 1;
    return true;
}

/**
 *
 * Cancels the current now-loading screen.
 *
 */
static int _CANCEL_NOW_LOADING(dc2::script::RunArguments, int) {
    CancelNowLoading();
    return true;
}

/**
 *
 * Rounds a byte count up to a number of 16-byte blocks.
 *
 */
static inline u_int align16_blocks(u_int size) {
    if (size & 0xF) {
        return (size >> 4) + 1;
    }

    return size >> 4;
}

/**
 *
 * Creates the event effect script manager in a scene stack block.
 *
 */
static int _ESM_INITIALIZE(dc2::script::RunArguments stack, int argc) {
    int        stack_no = {};
    int        texb_offset = 0;
    mgCMemory *memory = {};

    stack_no = dc2::script::RunInteger(stack++);

    if (argc >= 2) {
        texb_offset = dc2::script::RunInteger(stack);
    }

    if ((memory = EventScene->GetStack(stack_no)) == nullptr) {
        return false;
    }

    auto *manager = dc2::memory::NewObject<CEffectScriptMan>(*memory);
    if (manager == nullptr) {
        return false;
    }
    const auto lease = dc2::memory::ArenaBuffer::Bind(*memory,
                                                      {reinterpret_cast<u8 *>(manager), sizeof(*manager)});
    if (lease.Bytes().empty()) {
        return false;
    }
    ResetEventEffectScript();
    const int texb = EventScene->GetEventTexb();
    manager->Initialize(memory, texb + texb_offset, EventScene->event_texb_num - texb_offset);
    manager->load_buffer = read_buffer;
    event_effect_script_storage = lease;
    return true;
}

/**
 *
 * Gives the event effect script manager a fixed-size work buffer.
 *
 */
static int _ESM_INIT_FIX(dc2::script::RunArguments stack, int argc) {
    int        stack_no = {};
    int        heap_size = {};
    mgCMemory *scene_stack = {};

    if (GetEventEffectScript() == nullptr) {
        return false;
    }

    heap_size = 0x36B0;
    stack_no = dc2::script::RunInteger(stack++);

    if (argc >= 2) {
        heap_size = dc2::script::RunInteger(stack);
    }

    if ((scene_stack = EventScene->GetStack(stack_no)) == nullptr) {
        return false;
    }

    if (heap_size < 0x10) {
        return false;
    }
    const auto available = dc2::memory::RemainingBytes(*scene_stack);
    if (available.empty() || scene_stack->lock != 0) {
        return false;
    }
    const auto        address = reinterpret_cast<std::uintptr_t>(available.data());
    const std::size_t alignment_words = ((64 - address % 64) % 64) / sizeof(u_long128);
    if (static_cast<std::size_t>(heap_size) + alignment_words >= available.size() / sizeof(u_long128)) {
        return false;
    }
    auto *storage = scene_stack->stAlloc64(heap_size);
    if (storage == nullptr) {
        return false;
    }
    auto owned_heap = std::make_unique<mgCMemory>();
    owned_heap->stSetChildBuffer(*scene_stack, storage, heap_size);
    owned_heap->SetHeapMem(storage, heap_size);
    owned_heap->stReset();
    auto *manager = GetEventEffectScript();
    if (manager == nullptr) {
        return false;
    }
    manager->AllClearEffSpt();
    manager->SetWorkBuffer(owned_heap.get());
    event_effect_heap = std::move(owned_heap);
    return true;
}

/**
 *
 * Clears the event effect script manager and frees its texture blocks.
 *
 */
static int _ESM_CLEAR(dc2::script::RunArguments stack, int argc) {
    int                cleared_blocks[68];
    mgCMemory         *work_buffer = {};
    mgCTextureManager *tex_manager = {};
    int                i = {};

    if (GetEventEffectScript() == nullptr) {
        return false;
    }

    GetEventEffectScript()->ClearBaseFromLevel(0, cleared_blocks);
    GetEventEffectScript()->AllClearEffSpt();
    work_buffer = GetEventEffectScript()->work_memory;

    if (work_buffer != nullptr) {
        work_buffer->stReset();
        work_buffer->ClearHeapMem();
    }

    tex_manager = &mgTexManager;
    ResetEventEffectScript();

    for (i = 0; i < 64; i++) {
        dc2::log::PrintGame("[ESM_CLEAR] DEL TEXB = %d\n", cleared_blocks[i]);

        if (cleared_blocks[i] <= -1) {
            break;
        }

        tex_manager->DeleteBlock(cleared_blocks[i]);
    }

    return true;
}

/**
 *
 * Loads a base effect script by number or name.
 *
 */
static int _ESM_LOAD_BASE(dc2::script::RunArguments stack, int argc) {
    int result = {};

    if (GetEventEffectScript() == nullptr) {
        return false;
    }

    switch (stack.At().type) {
        case RS_INT:
            result = GetEventEffectScript()->LoadBaseEffSpt(dc2::script::RunInteger(stack), nullptr, -1);
            break;
        case RS_STR:
            result = GetEventEffectScript()->LoadBaseEffSpt(dc2::script::RunCString(stack), nullptr, -1);
            break;
        default:
            result = 0;
            break;
    }

    return result;
}

/**
 *
 * Creates an effect script, optionally in a group.
 *
 */
static int _ESM_CREATE(dc2::script::RunArguments stack, int argc) {
    if (GetEventEffectScript() == nullptr) {
        return false;
    }

    char *name = dc2::script::RunCString(stack++);

    switch (argc) {
        case 1:
            GetEventEffectScript()->CreateEffSpt(name, -1, 0);
            break;
        case 2:
            GetEventEffectScript()->CreateEffSpt(name, dc2::script::RunInteger(stack), 0);
            break;
        case 3: {
            int group = dc2::script::RunInteger(stack++);
            int result = GetEventEffectScript()->CreateEffSpt(name, group, 1);
            SetStack(stack, result);

            if (result <= -1) {
                return false;
            }

            break;
        }
        default:
            return false;
    }

    return true;
}

/**
 *
 * Sets the program number of an effect script group.
 *
 */
static int _ESM_FINISH(dc2::script::RunArguments stack, int argc) {
    int  group = {};
    auto next_slot = stack + 1;

    if (GetEventEffectScript() == nullptr) {
        return false;
    }

    group = dc2::script::RunInteger(stack);
    GetEventEffectScript()->SetScriptProgNo(EFFECT_SCRIPT_PROG_FINISH, group, dc2::script::RunInteger(next_slot));
    return true;
}

/**
 *
 * Deletes an effect script from a group.
 *
 */
static int _ESM_DELETE(dc2::script::RunArguments stack) {
    if (GetEventEffectScript() == nullptr) {
        return false;
    }

    int group = dc2::script::RunInteger(stack++);
    GetEventEffectScript()->DeleteEffSpt(group, dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Sets the first vector of an effect script, optionally for a group and slot.
 *
 */
static int _ESM_SET_VECT1(dc2::script::RunArguments stack, int argc) {
    float vector[4];
    int   result = {};

    if (GetEventEffectScript() == nullptr) {
        return false;
    }

    switch (argc) {
        case 3:
            GetStackVector(vector, stack);
            result = GetEventEffectScript()->SetScriptVect1(vector, -1, -1);
            break;
        case 5: {
            int group = dc2::script::RunInteger(stack++);
            int slot = dc2::script::RunInteger(stack++);
            GetStackVector(vector, stack);
            result = GetEventEffectScript()->SetScriptVect1(vector, group, slot);
            break;
        }
        default:
            return false;
    }

    return result;
}

/**
 *
 * Sets the second vector of an effect script, optionally for a group and slot.
 *
 */
static int _ESM_SET_VECT2(dc2::script::RunArguments stack, int argc) {
    float vector[4];
    int   result = {};

    if (GetEventEffectScript() == nullptr) {
        return false;
    }

    switch (argc) {
        case 3:
            GetStackVector(vector, stack);
            result = GetEventEffectScript()->SetScriptVect2(vector, -1, -1);
            break;
        case 5: {
            int group = dc2::script::RunInteger(stack++);
            int slot = dc2::script::RunInteger(stack++);
            GetStackVector(vector, stack);
            result = GetEventEffectScript()->SetScriptVect2(vector, group, slot);
            break;
        }
        default:
            return false;
    }

    return result;
}

/**
 *
 * Sets the target ID of an effect script, optionally for a group and slot.
 *
 */
static int _ESM_SET_TARGET_ID(dc2::script::RunArguments stack, int argc) {
    int group = {};
    int slot = {};
    int result = {};

    if (GetEventEffectScript() == nullptr) {
        return false;
    }

    switch (argc) {
        case 1:
            result = GetEventEffectScript()->SetScriptTargetId(dc2::script::RunInteger(stack), -1, -1);
            break;
        case 3:
            group = dc2::script::RunInteger(stack++);
            slot = dc2::script::RunInteger(stack++);
            result = GetEventEffectScript()->SetScriptTargetId(dc2::script::RunInteger(stack), group, slot);
            break;
        default:
            result = 0;
            break;
    }

    return result;
}

/**
 *
 * Builds an effect script pack from a background file.
 *
 */
static int _ESM_LOAD_BASE_PACK(dc2::script::RunArguments stack) {
    if (GetEventEffectScript() == nullptr) {
        return false;
    }

    char      *pack_name = dc2::script::RunCString(stack++);
    char      *file_name = dc2::script::RunCString(stack);
    const auto file_read = dc2::event::ReadFile(file_name);
    u32       *pack = reinterpret_cast<u32 *>(file_read.Bytes().data());

    if (pack != nullptr) {
        return GetEventEffectScript()->BuildPack(pack_name, pack, nullptr, -1);
    }

    return false;
}

/**
 *
 * Sets an integer or float value of an effect script, optionally for a group and slot.
 *
 */
static int _ESM_SET_VALUE(dc2::script::RunArguments stack, int argc) {
    int value_no = {};
    int group = {};
    int slot = {};
    int result = {};

    if (GetEventEffectScript() == nullptr) {
        return false;
    }

    switch (argc) {
        case 2:
            value_no = dc2::script::RunInteger(stack++);

            switch (stack.At().type) {
                case RS_INT:
                    result = GetEventEffectScript()->SetValue(value_no, dc2::script::RunInteger(stack), -1, -1);
                    break;
                case RS_FLOAT:
                    result = GetEventEffectScript()->SetValue(value_no, dc2::script::RunFloat(stack), -1, -1);
                    break;
                default:
                    return false;
            }

            break;
        case 4:
            group = dc2::script::RunInteger(stack++);
            slot = dc2::script::RunInteger(stack++);
            value_no = dc2::script::RunInteger(stack++);

            switch (stack.At().type) {
                case RS_INT:
                    result = GetEventEffectScript()->SetValue(value_no, dc2::script::RunInteger(stack), group, slot);
                    break;
                case RS_FLOAT:
                    result = GetEventEffectScript()->SetValue(value_no, dc2::script::RunFloat(stack), group, slot);
                    break;
                default:
                    return false;
            }

            break;
        default:
            return false;
    }

    return result;
}

/**
 *
 * Sets a character battle attribute or status attribute.
 *
 */
static int _SET_CHARA_CONDITION(dc2::script::RunArguments stack, int argc) {
    switch (argc) {
        case 2: {
            CBattleCharaInfo *info = {};
            int               chara = {};

            if ((info = GetBattleCharaInfo()) == nullptr) {
                return false;
            }

            chara = dc2::script::RunInteger(stack++);
            info->SetAttr(chara, dc2::script::RunInteger(stack));
            break;
        }
        case 3: {
            CUserDataManager *user_data = {};
            int               attr = {};
            int               chara_no = {};
            int               value = {};

            if ((user_data = GetUserDataMan()) == nullptr) {
                return false;
            }

            chara_no = dc2::script::RunInteger(stack++);
            attr = dc2::script::RunInteger(stack++);
            value = dc2::script::RunInteger(stack);

            if (user_data != nullptr) {
                user_data->SetCharaStatusAttirbute(chara_no, attr, value);
            }

            break;
        }
        default:
            return false;
    }

    return true;
}

/**
 *
 * Adds to the battle WHP of a character.
 *
 */
static int _ADD_WHP(dc2::script::RunArguments stack) {
    CBattleCharaInfo *info = {};

    if ((info = GetBattleCharaInfo()) == nullptr) {
        return false;
    }

    int chara = dc2::script::RunInteger(stack++);
    int amount = dc2::script::RunInteger(stack);
    info->AddWhp(chara, amount);
    return true;
}

/**
 *
 * Adds a rate of HP to a battle character over a number of frames.
 *
 */
static int _ADD_HP_RATE(dc2::script::RunArguments stack, int argc) {
    float             rate = {};
    float             frames = {};
    CBattleCharaInfo *info = {};

    if ((info = GetBattleCharaInfo()) == nullptr) {
        return false;
    }

    frames = 0.0f;
    rate = dc2::script::RunFloat(stack++);
    int mode = dc2::script::RunInteger(stack++);

    if (argc >= 3) {
        frames = dc2::script::RunFloat(stack);
    }

    info->AddHp_Rate(rate, mode, frames);
    return true;
}

/**
 *
 * Pushes the time of the event scene.
 *
 */
static int _GET_TIME(dc2::script::RunArguments stack) {
    SetStack(stack, EventScene->time);
    return true;
}

/**
 *
 * Pushes whether the item limit is exceeded, or an item count clamped to the remaining limit.
 *
 */
static int _CHECK_GET_ITEM_LIMIT(dc2::script::RunArguments stack, int argc) {
    int item_id = {};
    int count = {};

    switch (argc) {
        case 1:
            argc = CheckItemLimmitOver();
            SetStack(stack, argc);
            break;
        case 3:
            item_id = dc2::script::RunInteger(stack++);
            count = dc2::script::RunInteger(stack++);
            count = CheckGetItemRemainNum(item_id) - count < 0 ? 0 : count;
            SetStack(stack, count);
            break;
        default:
            return false;
    }

    return true;
}

/**
 *
 * Pushes whether the item count is over the limit.
 *
 */
static int _CHECK_ITEM_OVER(dc2::script::RunArguments stack, int argc) {
    argc = CheckItemOver();
    SetStack(stack, argc);
    return true;
}

/**
 *
 * Pushes the current loop number.
 *
 */
static int _GET_NOW_LOOP_NO(dc2::script::RunArguments stack, int argc) {
    argc = GetNowLoopNo();
    SetStack(stack, argc);
    return true;
}

/**
 *
 * Pushes whether the most fast destroy floor is cleared.
 *
 */
static int _IS_CLEAR_DESTROY(dc2::script::RunArguments stack, int argc) {
    CDngFloorManager *floor_manager = {};
    DNG_BATTLE_AREA  *dng_scene = {};

    dng_scene = &EventScene->battle_area;

    if (dng_scene == nullptr) {
        return false;
    }

    floor_manager = &dng_scene->floor_manager;

    if (floor_manager == nullptr) {
        return false;
    }

    SetStack(stack, floor_manager->IsClearMostFastDestroy());
    return true;
}

/**
 *
 * Pushes whether a practice floor is cleared and its bonus type.
 *
 */
static int _IS_CLEAR_PRACTICE(dc2::script::RunArguments stack, int argc) {
    if (argc != 3) {
        return false;
    }

    DNG_BATTLE_AREA  *area = &EventScene->battle_area;
    CDngFloorManager *floor_manager = &area->floor_manager;

    if (area == nullptr) {
        return false;
    }

    if (floor_manager == nullptr) {
        return false;
    }

    int        cleared = floor_manager->IsClearPractice(dc2::script::RunInteger(stack++));
    CSaveData *save_data = GetSaveData();

    if (save_data == nullptr) {
        return false;
    }

    CSaveDataDungeon *dungeon = &save_data->save_dungeon;

    if (dungeon == nullptr) {
        return false;
    }

    DNGMAP_ROOM_INFO *info = floor_manager->GetDngMapFloorInfo(dungeon->floor_id[dungeon->stage_id]);

    if (info == nullptr) {
        return false;
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
    return true;
}

/**
 *
 * Pushes whether a dungeon sub game is being played.
 *
 */
static int _IS_PLAY_SUB_GAME(dc2::script::RunArguments stack, int argc) {
    CDngFloorManager *floor_manager = {};
    DNG_BATTLE_AREA  *dng_scene = {};

    dng_scene = &EventScene->battle_area;

    if (dng_scene == nullptr) {
        return false;
    }

    floor_manager = &dng_scene->floor_manager;

    if (floor_manager == nullptr) {
        return false;
    }

    SetStack(stack, floor_manager->IsPlaySubGame());
    return true;
}

/**
 *
 * Sets the dungeon subject counter from the save data play time.
 *
 */
static int _RESET_SUBJECT_COUNTER(dc2::script::RunArguments stack, int argc) {
    DNG_BATTLE_AREA *dng_scene = {};
    CSaveData       *save = {};

    dng_scene = &EventScene->battle_area;

    if (dng_scene == nullptr) {
        return false;
    }

    save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    dng_scene->subject_counter = static_cast<u32>(save->play_time);
    return true;
}

/**
 *
 * Initializes the amplitude, speed and pitch of the screen raster effect.
 *
 */
static int _SCR_EFF_INIT_RASTER(dc2::script::RunArguments stack) {
    float amplitude = dc2::script::RunFloat(stack++);
    float speed = dc2::script::RunFloat(stack++);
    float pitch = dc2::script::RunFloat(stack);
    EventScreenEffect.InitRaster(amplitude, speed, pitch);
    return true;
}

/**
 *
 * Starts the screen raster effect for a number of frames.
 *
 */
static int _SCR_EFF_START_RASTER(dc2::script::RunArguments stack) {
    float amplitude = dc2::script::RunFloat(stack++);
    float speed = dc2::script::RunFloat(stack++);
    float pitch = dc2::script::RunFloat(stack++);
    int   frames = dc2::script::RunInteger(stack);
    EventScreenEffect.StartRaster(amplitude, speed, pitch, frames);
    return true;
}

/**
 *
 * Stops the screen raster effect over a number of frames.
 *
 */
static int _SCR_EFF_STOP_RASTER(dc2::script::RunArguments stack) {
    float amplitude = dc2::script::RunFloat(stack++);
    float speed = dc2::script::RunFloat(stack++);
    float pitch = dc2::script::RunFloat(stack++);
    int   frames = dc2::script::RunInteger(stack);
    EventScreenEffect.StopRaster(amplitude, speed, pitch, frames);
    return true;
}

/**
 *
 * Sets the motion of the character on a map piece of a map parts.
 *
 */
static int _SET_MPCHARA_MOTION(dc2::script::RunArguments stack, int argc) {
    CMap      *maps[8];
    int        map_count = {};
    int        i = {};
    CMapParts *parts{};
    char      *parts_name = {};
    int        parts_id = {};
    map_count = EventScene->GetActiveMap(maps, 8);

    if (!(map_count > 0)) {
        return false;
    }

    switch (stack.At().type) {
        case RS_INT:
            parts_id = dc2::script::RunInteger(stack++);

            for (i = 0; i < map_count; i++) {
                parts = maps[i]->GetPlaceParts(parts_id);

                if (parts != nullptr) {
                    break;
                }
            }

            break;
        case RS_STR:
            parts_name = dc2::script::RunCString(stack++);

            for (i = 0; i < map_count; i++) {
                parts = maps[i]->GetPlaceParts(parts_name);

                if (parts != nullptr) {
                    break;
                }
            }

            break;
    }

    if (parts == nullptr) {
        return false;
    }

    CMapPiece *piece = {};

    if ((piece = parts->SearchPiece(dc2::script::RunCString(stack++))) == nullptr) {
        return false;
    }

    int   flags = 0;
    char *motion_name = dc2::script::RunCString(stack++);

    if (argc >= 4) {
        flags = dc2::script::RunInteger(stack);
    }

    if (piece->chara != nullptr) {
        piece->chara->SetMotion(motion_name, flags);
    }

    return true;
}

/**
 *
 * Sets the position of a function point, found by parts and name or by place and name.
 *
 */
static int _FUNC_POINT_POS(dc2::script::RunArguments stack, int argc) {
    float       pos[4];
    CFuncPoint *func_point{};
    CMap       *map = EventScene->GetMap(EventScene->active_map);

    if (map == nullptr) {
        return false;
    }

    switch (stack.At().type) {
        case RS_INT: {
            int        parts_no = dc2::script::RunInteger(stack++);
            char      *name = dc2::script::RunCString(stack++);
            CMapParts *parts = map->GetPlaceParts(parts_no);

            if (parts == nullptr) {
                return false;
            }

            func_point = parts->func_point_mngr.Search(name);
            break;
        }
        case RS_STR: {
            char *place_name = dc2::script::RunCString(stack++);
            char *name = dc2::script::RunCString(stack++);

            if (strcmp(place_name, "") != 0) {
                CMapParts *parts = map->GetPlaceParts(place_name);

                if (parts == nullptr) {
                    return false;
                }

                func_point = parts->func_point_mngr.Search(name);
            } else {
                func_point = map->func_point.Search(name);
            }

            break;
        }
    }

    if (func_point == nullptr) {
        return false;
    }

    GetStackVector(pos, stack);
    std::memmove(func_point->position, pos, sizeof(u_long128));
    func_point->frame.SetPosition(pos);
    return true;
}

/**
 *
 * Pushes the string comparison result of a map parts name.
 *
 */
static int _PARTS_NAME_STRCMP(dc2::script::RunArguments stack, int argc) {
    if (argc != 3) {
        return false;
    }

    int        parts_no = dc2::script::RunInteger(stack++);
    char      *name = dc2::script::RunCString(stack++);
    CMap      *map = EventScene->GetMap(EventScene->active_map);
    CMapParts *parts = {};

    if (map != nullptr && (parts = map->GetPlaceParts(parts_no)) != nullptr) {
        int order = strcmp(parts->parts_name, name);
        SetStack(stack, order);
        return true;
    }

    SetStack(stack, -1);
    return false;
}

/**
 *
 * Pushes the trial version flag, which is always clear.
 *
 */
static int _GET_TRIAL_VERSION(dc2::script::RunArguments stack) {
    SetStack(stack, 0);
    return true;
}

/**
 *
 * Switches the floor episode title.
 *
 */
static int _SET_FLOOR_EPISODE(dc2::script::RunArguments stack) {
    StartupEpisodeTitle.Switch(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Pushes the position of a function point.
 *
 */
static int _FUNC_POINT_GET_POS(dc2::script::RunArguments stack, int argc) {
    float       pos[4];
    CFuncPoint *func_point{};
    CMap       *map = EventScene->GetMap(EventScene->active_map);

    if (map == nullptr) {
        return false;
    }

    switch (stack.At().type) {
        case RS_INT: {
            int        parts_no = dc2::script::RunInteger(stack++);
            char      *name = dc2::script::RunCString(stack++);
            CMapParts *parts = map->GetPlaceParts(parts_no);

            if (parts == nullptr) {
                return false;
            }

            func_point = parts->func_point_mngr.Search(name);
            break;
        }
        case RS_STR: {
            char *place_name = dc2::script::RunCString(stack++);
            char *name = dc2::script::RunCString(stack++);

            if (strcmp(place_name, "") != 0) {
                CMapParts *parts = map->GetPlaceParts(place_name);

                if (parts == nullptr) {
                    return false;
                }

                func_point = parts->func_point_mngr.Search(name);
            } else {
                func_point = map->func_point.Search(name);
            }

            break;
        }
    }

    if (func_point == nullptr) {
        return false;
    }

    std::memmove(pos, func_point->position, sizeof(u_long128));
    SetOutputVector(stack, {pos[0], pos[1], pos[2]});
    stack = stack + 2;
    return true;
}

/**
 *
 * Returns the map that is active in the event scene.
 *
 */
static inline CMap *GetActiveEventMap() {
    return EventScene->GetMap(EventScene->active_map);
}

/**
 *
 * Pushes the rotation of a function point.
 *
 */
static int _FUNC_POINT_GET_ROT(dc2::script::RunArguments stack, int argc) {
    float       rot[4];
    CMap       *map = {};
    CFuncPoint *func_point{};
    map = GetActiveEventMap();

    if (map == nullptr) {
        return false;
    }

    switch (stack.At().type) {
        case RS_INT: {
            int        parts_no = dc2::script::RunInteger(stack++);
            char      *name = dc2::script::RunCString(stack++);
            CMapParts *parts = map->GetPlaceParts(parts_no);

            if (parts == nullptr) {
                return false;
            }

            func_point = parts->func_point_mngr.Search(name);
            break;
        }
        case RS_STR: {
            char *place_name = dc2::script::RunCString(stack++);
            char *name = dc2::script::RunCString(stack++);

            if (strcmp(place_name, "") != 0) {
                CMapParts *parts = map->GetPlaceParts(place_name);

                if (parts == nullptr) {
                    return false;
                }

                func_point = parts->func_point_mngr.Search(name);
            } else {
                func_point = map->func_point.Search(name);
            }

            break;
        }
    }

    if (func_point == nullptr) {
        return false;
    }

    std::memmove(rot, func_point->rotation, sizeof(u_long128));

    switch (argc) {
        case 3:
            SetStack(stack, rot[1]);
            break;
        case 5:
            SetOutputVector(stack, {rot[0], rot[1], rot[2]});
            stack = stack + 2;
            break;
        default:
            return false;
    }

    return true;
}

/**
 *
 * Resets an action character and sets its default motion.
 *
 */
static int _ACTCHR_SET_DEF_MOTION(dc2::script::RunArguments stack, int argc) {
    int           chara_no = {};
    int           motion_arg = 0;
    CActionChara *chara = {};
    chara_no = dc2::script::RunInteger(stack++);

    if (argc >= 2) {
        motion_arg = dc2::script::RunInteger(stack);
    }

    if ((chara = static_cast<CActionChara *>(GetCharacter(chara_no))) == nullptr) {
        return false;
    }

    auto default_motion = chara->default_motion;
    if (dc2::text::View(std::span<const char>(default_motion)).size() == default_motion.size()) {
        return false;
    }
    chara->ResetAction();
    chara->SetMotion(default_motion.data(), motion_arg, 1);
    return true;
}

/**
 *
 * Adds fusion points for a group and member.
 *
 */
static int _ADD_FUSION_POINT(dc2::script::RunArguments stack) {
    int               group = {};
    int               member = {};
    int               points = {};
    CUserDataManager *user_data = {};
    CSaveData        *save = {};

    group = dc2::script::RunInteger(stack++);
    member = dc2::script::RunInteger(stack++);
    points = dc2::script::RunInteger(stack);

    if ((group < 0) || (group > 1)) {
        return false;
    }

    if ((member < 0) || (user_data = nullptr, (member > 1))) {
        return false;
    }

    save = GetSaveData();

    if (save != nullptr) {
        user_data = &save->user_data;
    }

    if (user_data == nullptr) {
        return false;
    }

    user_data->AddFusionPoint(group, member, points);
    return true;
}

/**
 *
 * Pushes the debug flag.
 *
 */
static int _GET_DEBUG_FLAG(dc2::script::RunArguments stack, int argc) {
    if (argc != 1) {
        return false;
    }

    SetStack(stack, DebugFlag);

    return true;
}

/**
 *
 * Enables the minimap door at a position.
 *
 */
static int _MINIMAP_DOOR_ENABLE(dc2::script::RunArguments stack, int argc) {
    float pos[4];

    if (argc != 3) {
        return false;
    }

    GetStackVector(pos, stack);
    MinimapDoorEnable(pos);
    return true;
}

/**
 *
 * Pushes the boss map value of the dungeon.
 *
 */
static int _DNG_CHECK_BOSS_MAP(dc2::script::RunArguments stack, int argc) {
    DNG_BATTLE_AREA *dng_scene = {};

    if (argc != 1) {
        return false;
    }

    dng_scene = &EventScene->battle_area;

    if (dng_scene == nullptr) {
        return false;
    }

    SetStack(stack, dng_scene->boss_map);
    return true;
}

/**
 *
 * Sets the dungeon event number to run.
 *
 */
static int _DNG_RUN_EVENT(dc2::script::RunArguments stack) {
    int              event_no = dc2::script::RunInteger(stack);
    DNG_BATTLE_AREA *scene = &EventScene->battle_area;

    if (scene == nullptr) {
        return false;
    }

    s16 *slot = &scene->script.event_no;

    if (slot == nullptr) {
        return false;
    }

    *slot = static_cast<s16>(event_no);
    return true;
}

/**
 *
 * Pushes whether a character can be changed to.
 *
 */
static int _CHECK_ENABLE_CHARA_CHANGE(dc2::script::RunArguments stack, int argc) {
    CUserDataManager *user_data = {};
    int               chara_no = {};
    CSaveData        *save = {};
    auto              next_slot = stack;

    if (argc != 2) {
        return false;
    }

    next_slot = stack + 1;
    chara_no = dc2::script::RunInteger(stack);
    save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    user_data = &save->user_data;

    if (user_data == nullptr) {
        return false;
    }

    SetStack(next_slot, user_data->CheckEnableCharaChange(chara_no, nullptr));
    return true;
}

/**
 *
 * Initializes the sepia screen effect texture, optionally in a scene stack buffer.
 *
 */
static int _INIT_SEPIA(dc2::script::RunArguments stack, int argc) {
    int                      stack_no = {};
    int                      block_offset = {};
    u_long128               *buffer = {};
    mgCMemory               *scene_stack = {};
    dc2::memory::ArenaBuffer image;
    int                      block_no = {};
    CScene                  *scene = {};
    int                      tex_count = {};
    int                      tex_base = {};

    block_offset = 0;
    stack_no = dc2::script::RunInteger(stack++);

    if (argc >= 2) {
        block_offset = dc2::script::RunInteger(stack);
    }

    scene = EventScene;
    if (scene == nullptr) {
        return false;
    }
    const auto quadwords = ScreenCaptureQuadwords();
    if (!quadwords) {
        return false;
    }
    tex_count = scene->event_texb_num;
    tex_base = scene->event_texb;

    if (tex_count <= 0 || block_offset < 0 || block_offset >= tex_count || tex_base < 0 ||
        tex_base > std::numeric_limits<int>::max() - block_offset) {
        return false;
    }

    block_no = tex_base + block_offset;

    if (stack_no >= 0) {
        if ((scene_stack = EventScene->GetStack(stack_no)) == nullptr) {
            return false;
        }

        if ((buffer = scene_stack->stAlloc64(*quadwords + 1)) == nullptr) {
            return false;
        }
        image = dc2::memory::ArenaBuffer::Bind(*scene_stack, {reinterpret_cast<u8 *>(buffer), static_cast<std::size_t>(*quadwords) * sizeof(u_long128)});
    } else {
        image = ReadBufferLease();
        const auto storage = image.Bytes();
        if (static_cast<std::size_t>(*quadwords) > storage.size() / sizeof(u_long128) ||
            reinterpret_cast<std::uintptr_t>(storage.data()) % alignof(u_long128) != 0) {
            return false;
        }
        buffer = reinterpret_cast<u_long128 *>(storage.data());
    }

    mgTexManager.DeleteBlock(block_no);
    auto *texture = mgTexManager.EnterTexture(block_no, "event sepia", nullptr, mgScreenWidth,
                                              mgScreenHeight, mgScreenDepth, nullptr, 0LL, 0);
    if (CaptureStorage(texture, image).empty()) {
        return false;
    }
    EventScreenEffect.SetSepiaTexture(texture, image);
    return true;
}

/**
 *
 * Captures the screen and starts the sepia effect.
 *
 */
static int _START_SEPIA(dc2::script::RunArguments, int) {
    EventScreenEffect.CaptureSepiaScreen();
    EventScreenEffect.SetSepiaFlag(1);
    return true;
}

/**
 *
 * Ends the sepia effect.
 *
 */
static int _END_SEPIA(dc2::script::RunArguments, int) {
    EventScreenEffect.SetSepiaFlag(0);
    return true;
}

/**
 *
 * Copies a monster into a scene character slot.
 *
 */
static int _COPY_MONS2SCNCHR(dc2::script::RunArguments stack) {
    if (ActiveMonster == nullptr) {
        return false;
    }

    mgCMemory *memory = {};

    if ((memory = EventScene->GetStack(dc2::script::RunInteger(stack++))) == nullptr) {
        return false;
    }

    int          monster_index = ActiveMonster->SearchBaseIndex(dc2::script::RunInteger(stack++));
    int          dst_no = dc2::script::RunInteger(stack);
    CCharacter2 *copy = {};

    if (monster_index < 0 || monster_index >= MONSTER_REFER_MAX) {
        return false;
    }
    auto *storage = AllocateEventStorage(memory, align16_blocks(sizeof(CCharacter2)) + 2);
    copy = storage != nullptr ? new (storage) CCharacter2 : nullptr;

    if (copy == nullptr) {
        return false;
    }

    if (!CCharacter2(ActiveMonster->refer[monster_index].chara).Copy(*copy, memory)) {
        return false;
    }
    EventScene->DeleteChara(dst_no);
    int slot = EventScene->AssignChara(dst_no, dc2::scene::CharacterResource::FromArena(*memory, *copy));

    if (slot < 0) {
        return false;
    }

    EventScene->SetStatus(SCENE_DATA_CHARA, slot, SCENE_DATA_LOADED | SCENE_DATA_ASSIGNED);
    EventScene->SetCharaTexb(dst_no, monster_index + MONSTER_TEXB_REFER);
    return true;
}

/**
 *
 * Unlocks a scene memory stack.
 *
 */
static int _UNLOCK_STACK(dc2::script::RunArguments stack) {
    mgCMemory *scene_stack = EventScene->GetStack(dc2::script::RunInteger(stack));

    if (scene_stack == nullptr) {
        return false;
    }

    scene_stack->stSetLocked(false);
    return true;
}

/**
 *
 * Clears the event run flag.
 *
 */
static int _RESET_EVENT_TRG(dc2::script::RunArguments, int) {
    EventScene->event_run = 0;
    return true;
}

/**
 *
 * Sets the character number of a scene slot.
 *
 */
static int _SET_CHARA_NO(dc2::script::RunArguments stack) {
    int slot = dc2::script::RunInteger(stack++);

    EventScene->SetCharaNo(slot, dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Pushes the character number of a character ID.
 *
 */
static int _GET_CHARA_NO(dc2::script::RunArguments stack, int argc) {
    int  id = {};
    auto args = stack;

    if (argc != 2) {
        return false;
    }

    id = dc2::script::RunInteger(args++);
    SetStack(args, EventScene->GetCharaNo(id));
    return true;
}

/**
 *
 * Pushes the scene slot of a character ID.
 *
 */
static int _SEARCH_CHARA_NO(dc2::script::RunArguments stack, int argc) {
    int  id = {};
    auto args = stack;

    if (argc != 2) {
        return false;
    }

    id = dc2::script::RunInteger(args++);
    SetStack(args, EventScene->SearchCharaID(id));
    return true;
}

/**
 *
 * Pushes the position of the random stone nearest a point, and whether one was found.
 *
 */
static int _GET_NEAR_RANDOM_STONE_POS(dc2::script::RunArguments stack, int argc) {
    float pos[4];
    float stone_pos[4];

    if (argc != 7) {
        return false;
    }

    int found = -1;
    GetStackVector(pos, stack);
    stack = stack + 3;
    stone_pos[0] = 0.0f;
    stone_pos[1] = 0.0f;
    stone_pos[2] = 0.0f;
    stone_pos[3] = 0.0f;
    CMapParts *stone = {};

    if ((stone = AutoMapGen.SearchRandomStone(pos, 30.0f)) != nullptr) {
        stone->GetPosition(stone_pos);
        found = 1;
    }

    SetOutputVector(stack, {stone_pos[0], stone_pos[1], stone_pos[2]});
    stack = stack + 3;
    SetStack(stack, found);
    return true;
}

/**
 *
 * Initializes the textures and buffers of the monochrome flash effect.
 *
 */
static int _INIT_MONO_FLASH(dc2::script::RunArguments stack) {
    u_long128                              *buffers[2];
    mgCTexture                             *textures[2];
    std::array<dc2::memory::ArenaBuffer, 2> images;
    mgCMemory                              *memory = {};
    int                                     stack_no = {};
    int                                     tex_base = {};
    int                                     tex_count = {};

    stack_no = dc2::script::RunInteger(stack);
    if (EventScene == nullptr) {
        return false;
    }
    const auto quadwords = ScreenCaptureQuadwords();
    if (!quadwords) {
        return false;
    }
    tex_count = EventScene->event_texb_num;
    tex_base = EventScene->event_texb;

    if (tex_count < 2 || tex_base < 0 || tex_base == std::numeric_limits<int>::max()) {
        return false;
    }

    if (stack_no >= 0) {
        if ((memory = EventScene->GetStack(stack_no)) == nullptr) {
            return false;
        }

        if ((buffers[0] = memory->stAlloc64(
                 *quadwords + 1)) == nullptr) {
            return false;
        }

        if ((buffers[1] = memory->stAlloc64(
                 *quadwords + 1)) == nullptr) {
            return false;
        }
        for (std::size_t index = 0; index < images.size(); ++index) {
            images[index] = dc2::memory::ArenaBuffer::Bind(*memory, {reinterpret_cast<u8 *>(buffers[index]), static_cast<std::size_t>(*quadwords) * sizeof(u_long128)});
        }
    } else {
        const auto global_image = ReadBufferLease();
        const auto storage = global_image.Bytes();
        if (static_cast<std::size_t>(*quadwords) > storage.size() / sizeof(u_long128) / 2 ||
            reinterpret_cast<std::uintptr_t>(storage.data()) % alignof(u_long128) != 0) {
            return false;
        }
        const auto bytes = static_cast<std::size_t>(*quadwords) * sizeof(u_long128);
        images[0] = global_image.Subspan(0, bytes);
        images[1] = global_image.Subspan(bytes, bytes);
    }

    mgTexManager.DeleteBlock(tex_base);
    mgTexManager.DeleteBlock(tex_base + 1);
    textures[0] = mgTexManager.EnterTexture(
        tex_base, "mono_flash1", nullptr, mgScreenWidth, mgScreenHeight, mgScreenDepth, nullptr, 0, 0);
    textures[1] = mgTexManager.EnterTexture(
        tex_base + 1, "mono_flash2", nullptr, mgScreenWidth, mgScreenHeight, mgScreenDepth, nullptr, 0,
        0);
    if (CaptureStorage(textures[0], images[0]).empty() || CaptureStorage(textures[1], images[1]).empty()) {
        return false;
    }
    EventScreenEffect.SetMonoFlashTexture(textures, images);
    return true;
}

/**
 *
 * Captures the screen and starts the monochrome flash for an interval.
 *
 */
static int _START_MONO_FLASH(dc2::script::RunArguments stack) {
    int interval = dc2::script::RunInteger(stack);

    EventScreenEffect.CaptureMonoFlashScreen();
    EventScreenEffect.SetMonoFlashFlag(1, interval);
    return true;
}

/**
 *
 * Ends the monochrome flash effect.
 *
 */
static int _END_MONO_FLASH(dc2::script::RunArguments, int) {
    EventScreenEffect.SetMonoFlashFlag(0, 0);
    return true;
}

/**
 *
 * Deletes a villager from the event scene.
 *
 */
static int _DELETE_VILLAGER(dc2::script::RunArguments stack) {
    EventScene->DeleteVillager(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Sets the dungeon weather and changes the environment offset to match.
 *
 */
static int _DNG_SET_WEATHER(dc2::script::RunArguments stack) {
    DNG_BATTLE_AREA *info = (&EventScene->battle_area);
    int              weather = {};

    if (info == nullptr) {
        return false;
    }

    weather = dc2::script::RunInteger(stack);
    info->weather = weather;

    if (weather == DNG_WEATHER_RAIN) {
        EventScene->AutoChangeEnvOffset(4);
    } else {
        EventScene->AutoChangeEnvOffset(0);
    }

    return true;
}

/**
 *
 * Sets the maximum HP of a character and refills its HP.
 *
 */
static int _SET_CHARA_MAXHP(dc2::script::RunArguments stack, int argc) {
    int               chara_no = {};
    auto              args = stack;
    int               max_hp = {};
    CUserDataManager *user_data = {};
    CSaveData        *save = {};
    CHARA_DATA       *chara = {};

    chara_no = dc2::script::RunInteger(args++);
    max_hp = dc2::script::RunInteger(args);
    save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    user_data = &save->user_data;

    if (user_data == nullptr) {
        return false;
    }

    chara = user_data->GetCharaDataPtr(chara_no);
    chara->hp.max = static_cast<float>(max_hp);
    chara->hp.SetFillRate(1.0f);
    return true;
}

/**
 *
 * Sets the defence of a character.
 *
 */
static int _SET_CHARA_DEFENCE(dc2::script::RunArguments stack, int argc) {
    int               chara_no = {};
    auto              args = stack;
    int               defence = {};
    CUserDataManager *user_data = {};
    CSaveData        *save = {};

    chara_no = dc2::script::RunInteger(args++);
    defence = dc2::script::RunInteger(args);
    save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    user_data = &save->user_data;

    if (user_data == nullptr) {
        return false;
    }

    user_data->GetCharaDataPtr(chara_no)->defence = defence;
    return true;
}

/**
 *
 * Pushes the string comparison result of a placed parts name.
 *
 */
static int _PLACE_PARTS_NAME_STRCMP(dc2::script::RunArguments stack, int argc) {
    if (argc != 3) {
        return false;
    }

    int        parts_no = dc2::script::RunInteger(stack++);
    char      *name = dc2::script::RunCString(stack++);
    CMap      *map = EventScene->GetMap(EventScene->active_map);
    CMapParts *parts = {};

    if (map != nullptr && (parts = map->GetPlaceParts(parts_no)) != nullptr) {
        int order = strcmp(parts->name, name);
        SetStack(stack, order);
        return true;
    }

    SetStack(stack, -1);
    return false;
}

/**
 *
 * Opens the use item menu for a pointer and its parameters.
 *
 */
static int _GOTO_USE_ITEM2(dc2::script::RunArguments stack, int argc) {
    if (argc < 2 || static_cast<std::size_t>(argc) >= std::size(MenuArg.param)) {
        return false;
    }
    const auto                                output = stack++;
    std::array<int, std::size(MenuArg.param)> parameters{};
    std::size_t                               count = 0;

    for (int index = 1; index < argc; ++index) {
        parameters[count++] = dc2::script::RunInteger(stack++);
    }
    parameters[count++] = 0;
    auto complete = dc2::script::RunDeferredInteger(output);
    use_item_result = std::move(complete);
    std::copy_n(parameters.begin(), count, MenuArg.param);
    MenuArg.open_type = MENU_OPEN_USE_ITEM;
    EdEventInfo.command_mode = EVENT_COMMAND_SUB_MODE;
    return true;
}

/**
 *
 * Sets an analyze flag of an edit data area.
 *
 */
static int _DBG_SET_ANALYZE_FLAG(dc2::script::RunArguments stack, int argc) {
    int        area = {};
    auto       args = stack;
    int        entry = {};
    int        flag = {};
    CSaveData *save = {};
    CEditData *edit_data = {};

    area = dc2::script::RunInteger(args++);
    entry = dc2::script::RunInteger(args++);
    flag = dc2::script::RunInteger(args);
    save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    edit_data = save->GetEditData(area);

    if (edit_data == nullptr) {
        return false;
    }

    edit_data->dbgSetAnalyzeFlag(area, entry, flag);
    return true;
}

/**
 *
 * Turns the Atramiria effect on or off for a character.
 *
 */
static int _ATRAMIRIA_ON_OFF(dc2::script::RunArguments stack, int argc) {
    int  mode = {};
    auto args = stack;
    int  chara_no = {};
    int  flag = {};

    mode = dc2::script::RunInteger(args++);
    chara_no = dc2::script::RunInteger(args++);
    flag = dc2::script::RunInteger(args);
    AtraMiriaOnOff(mode, GetCharacter(chara_no), flag);
    return true;
}

/**
 *
 * Adds a yarikomi medal to the user data.
 *
 */
static int _ADD_YARIKOMI_MEDAL(dc2::script::RunArguments stack) {
    CUserDataManager *user_data = {};
    CSaveData        *save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    user_data = &save->user_data;

    if (user_data == nullptr) {
        return false;
    }

    user_data->AddYarikomiMedal(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Sets the map effect ID of the dungeon.
 *
 */
static int _SET_MAP_EFFECT_ID(dc2::script::RunArguments stack) {
    DNG_BATTLE_AREA *info = (&EventScene->battle_area);

    if (info == nullptr) {
        return false;
    }

    info->map_effect_id = dc2::script::RunInteger(stack);
    return true;
}

/**
 *
 * Pushes the map effect ID of the dungeon.
 *
 */
static int _GET_MAP_EFFECT_ID(dc2::script::RunArguments stack, int argc) {
    DNG_BATTLE_AREA *info = &EventScene->battle_area;

    if (info == nullptr) {
        return false;
    }

    switch (argc) {
        case 1:
            SetStack(stack, info->map_effect_id);
            return true;
    }

    return false;
}

/**
 *
 * Initializes the dungeon floor.
 *
 */
static int _DNG_FLOOR_INIT(dc2::script::RunArguments, int) {
    DungeonFloorInit();
    return true;
}

/**
 *
 * Finishes the dungeon floor.
 *
 */
static int _DNG_FLOOR_FINISH(dc2::script::RunArguments, int) {
    DungeonFloorFinish();
    return true;
}

/**
 *
 * Clears the random stones of the automap.
 *
 */
static int _CLEAR_RND_STONE(dc2::script::RunArguments, int) {
    AutoMapGen.ClearRandomStone();
    return true;
}

/**
 *
 * Pushes the floor status of the dungeon.
 *
 */
static int _GET_FLOOR_STATUS(dc2::script::RunArguments stack, int argc) {
    if (argc != 1) {
        return false;
    }

    DNG_BATTLE_AREA *info = &EventScene->battle_area;

    if (info == nullptr) {
        return false;
    }

    SetStack(stack, static_cast<int>(static_cast<u_int>(info->floor_status) * 16 / 16));
    return true;
}

/**
 *
 * Sets or clears the masked bits of the dungeon floor status.
 *
 */
static int _SET_FLOOR_STATUS(dc2::script::RunArguments stack, int argc) {
    DNG_BATTLE_AREA *info = (&EventScene->battle_area);
    auto             args = stack;
    int              mask = {};

    if (info == nullptr) {
        return false;
    }

    mask = dc2::script::RunInteger(args++);

    if (dc2::script::RunInteger(args) != 0) {
        info->floor_status |= mask;
    } else {
        info->floor_status &= ~mask;
    }

    return true;
}

/**
 *
 * Pushes the automap attribute status at a position.
 *
 */
static int _AMG_GET_ATTR_STATUS(dc2::script::RunArguments stack, int argc) {
    float position[4];

    if (argc != 4) {
        return false;
    }

    GetStackVector(position, stack);

    stack = stack + 3;
    SetStack(stack, AutoMapGen.GetAttrStatus(position));
    return true;
}

/**
 *
 * Sets the fade flag and near distance of a character.
 *
 */
static int _SET_NEAR_DIST(dc2::script::RunArguments stack) {
    int          chara_no = dc2::script::RunInteger(stack++);
    float        dist = dc2::script::RunFloat(stack);
    CCharacter2 *chara = {};

    if ((chara = GetCharacter(chara_no)) == nullptr) {
        return false;
    }

    chara->SetFadeFlag(1);
    chara->SetNearDist(dist);
    return true;
}

/**
 *
 * Sets the keep time of the event info.
 *
 */
static int _SET_KEEP_TIME(dc2::script::RunArguments stack) {
    EdEventInfo.keep_time = dc2::script::RunFloat(stack);
    return true;
}

/**
 *
 * Pushes the keep time of the event info.
 *
 */
static int _GET_KEEP_TIME(dc2::script::RunArguments stack, int argc) {
    if (argc != 1) {
        return false;
    }

    SetStack(stack, EdEventInfo.keep_time);

    return true;
}

/**
 *
 * Pushes the parts ID of the automap door.
 *
 */
static int _GET_DOOR_PARTS_ID(dc2::script::RunArguments stack, int argc) {
    if (argc != 1) {
        return false;
    }

    CMap      *map = EventScene->GetMap(EventScene->active_map);
    CMapParts *door = AutoMapGen.SearchDoorParts();
    int        parts_id = -1;

    if (map != nullptr) {
        if (door != nullptr) {
            parts_id = map->ConvertParts(door);
        }
    }

    SetStack(stack, parts_id);
    return true;
}

/**
 *
 * Checks for an equipment change.
 *
 */
static int _CHECK_EQUEP_CHANGE(dc2::script::RunArguments stack) {
    dc2::script::RunInteger(stack);
    CheckEquipChange(1);
    return true;
}

/**
 *
 * Adds a rate of HP to a character in the user data.
 *
 */
static int _ADD_HP_RATE2(dc2::script::RunArguments stack) {
    CSaveData *save_data = GetSaveData();

    if (save_data == nullptr) {
        return false;
    }

    CUserDataManager *user_data = &save_data->user_data;

    if (user_data == nullptr) {
        return false;
    }

    int   chara_no = dc2::script::RunInteger(stack++);
    float rate = dc2::script::RunFloat(stack);
    user_data->AddHp_Rate(chara_no, rate);
    return true;
}

/**
 *
 * Clears all dungeon effects and guns.
 *
 */
static int _DNG_EFFECT_ALL_CLEAR(dc2::script::RunArguments stack, int argc) {
    int i = {};

    RocketLauncher.Clear();

    for (i = 0; i < 16; i++) {
        MachineGun.active[i] = 0;
        MachineGun.col_prim_id[i] = -1;
    }

    MachineGun.index = 0;
    LaserGun.Clear();
    FxScriptMan->AllClearEffSpt();
    return true;
}

/**
 *
 * Changes the BGM volume of the event scene automatically.
 *
 */
static int _AUTO_CHENGE_BGM_VOL(dc2::script::RunArguments stack) {
    EventScene->AutoChangeBGMVol(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Pushes the WHP of a character weapon in the user data, and optionally its maximum.
 *
 */
static int _UDATA_GET_WHP(dc2::script::RunArguments stack, int argc) {
    int               chara_no = {};
    CUserDataManager *user_data = {};
    CSaveData        *save = {};
    int               weapon_no = {};
    int               value = {};
    int               max = {};

    save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    user_data = &save->user_data;

    if (user_data == nullptr) {
        return false;
    }

    chara_no = dc2::script::RunInteger(stack++);
    weapon_no = dc2::script::RunInteger(stack++);
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
            return false;
    }

    return true;
}

/**
 *
 * Adds WHP to a character weapon in the user data.
 *
 */
static int _UDATA_ADD_WHP(dc2::script::RunArguments stack, int argc) {
    int               chara_no = {};
    auto              args = stack;
    CUserDataManager *user_data = {};
    CSaveData        *save = {};
    int               item_no = {};
    int               amount = {};

    save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    user_data = &save->user_data;

    if (user_data == nullptr) {
        return false;
    }

    chara_no = dc2::script::RunInteger(args++);
    item_no = dc2::script::RunInteger(args++);
    amount = dc2::script::RunInteger(args);
    user_data->AddWhp(chara_no, item_no, amount);
    return true;
}

/**
 *
 * Pushes the ABS value of a character weapon in the user data, and optionally its maximum.
 *
 */
static int _UDATA_GET_ABS(dc2::script::RunArguments stack, int argc) {
    int               chara_no = {};
    CUserDataManager *user_data = {};
    CSaveData        *save = {};
    int               weapon_no = {};
    int               value = {};
    int               max = {};

    save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    user_data = &save->user_data;

    if (user_data == nullptr) {
        return false;
    }

    chara_no = dc2::script::RunInteger(stack++);
    weapon_no = dc2::script::RunInteger(stack++);
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
            return false;
    }

    return true;
}

/**
 *
 * Adds ABS to a character item in the user data.
 *
 */
static int _UDATA_ADD_ABS(dc2::script::RunArguments stack, int argc) {
    int               chara_no = {};
    auto              args = stack;
    CUserDataManager *user_data = {};
    CSaveData        *save = {};
    int               item_no = {};
    int               amount = {};

    save = GetSaveData();

    if (save == nullptr) {
        return false;
    }

    user_data = &save->user_data;

    if (user_data == nullptr) {
        return false;
    }

    chara_no = dc2::script::RunInteger(args++);
    item_no = dc2::script::RunInteger(args++);
    amount = dc2::script::RunInteger(args);
    user_data->AddAbs(chara_no, item_no, amount);
    return true;
}

/**
 *
 * Creates a dungeon effect script with vectors and a value.
 *
 */
static int _DNG_CREATE_EFFECT(dc2::script::RunArguments stack, int argc) {
    float first[4];
    float second[4];
    int   value = {};

    FxScriptMan->CreateEffSpt(dc2::script::RunCString(stack++), -1, 0);

    switch (argc) {
        case 4:
            GetStackVector(first, stack);
            stack = stack + 3;
            FxScriptMan->SetScriptVect1(first, -1, -1);
            break;
        case 5:
            GetStackVector(first, stack);
            value = dc2::script::RunInteger(stack = stack + 3);
            FxScriptMan->SetScriptVect1(first, -1, -1);
            FxScriptMan->SetValue(0, value, -1, -1);
            break;
        case 7:
            GetStackVector(first, stack);
            stack = stack + 3;
            GetStackVector(second, stack);
            FxScriptMan->SetScriptVect1(first, -1, -1);
            FxScriptMan->SetScriptVect2(second, -1, -1);
            break;
        default:
            return false;
    }

    return true;
}

/**
 *
 * Checks Monica's items when leaving.
 *
 */
static int _LEAVE_MONICA_ITEM_CHECK(dc2::script::RunArguments, int) {
    LeaveMonicaItemCheck();
    return true;
}

/**
 *
 * Sets the pause enable flag.
 *
 */
static int _PAUSE_ENABLE_FLAG(dc2::script::RunArguments stack) {
    PauseEnable(dc2::script::RunInteger(stack));
    return true;
}

/**
 *
 * Forces the tour boot on the save data day.
 *
 */
static int _FORCE_BOOT_TOUR(dc2::script::RunArguments stack, int argc) {
    CSaveData *save_data = GetSaveData();

    if (save_data == nullptr) {
        return false;
    }

    save_data->ForceBootTour(save_data->day, 1);
    return true;
}

/**
 *
 * External event script handlers in command-table order.
 *
 */
static RS_EXTFUNC_INFO ext_func_info[697] = {
    {dc2::script::AdaptRunArguments<_GET_PADON>,                     EVENT_EXT_GET_PADON                    },
    {dc2::script::AdaptRunArguments<_GET_PADDOWN>,                   EVENT_EXT_GET_PADDOWN                  },
    {dc2::script::AdaptRunArguments<_GET_PADUP>,                     EVENT_EXT_GET_PADUP                    },
    {dc2::script::AdaptRunArguments<_GET_APAD>,                      EVENT_EXT_GET_APAD                     },
    {dc2::script::AdaptRunArguments<_GOTO_INTERIOR>,                 EVENT_EXT_GOTO_INTERIOR                },
    {dc2::script::AdaptRunArguments<_INITIALIZE>,                    EVENT_EXT_INITIALIZE                   },
    {dc2::script::AdaptRunArguments<_GOTO_OUTSIDE>,                  EVENT_EXT_GOTO_OUTSIDE                 },
    {dc2::script::AdaptRunArguments<_LOAD_CHARA>,                    EVENT_EXT_LOAD_CHARA                   },
    {dc2::script::AdaptRunArguments<_CHARA_ACTIVE>,                  EVENT_EXT_CHARA_ACTIVE                 },
    {dc2::script::AdaptRunArguments<_CLEAR_STACK>,                   EVENT_EXT_CLEAR_STACK                  },
    {dc2::script::AdaptRunArguments<_ASSIGN_STACK>,                  EVENT_EXT_ASSIGN_STACK                 },
    {dc2::script::AdaptRunArguments<_SET_FLAG>,                      EVENT_EXT_SET_FLAG                     },
    {dc2::script::AdaptRunArguments<_GET_FLAG>,                      EVENT_EXT_GET_FLAG                     },
    {dc2::script::AdaptRunArguments<_SET_CNT>,                       EVENT_EXT_SET_CNT                      },
    {dc2::script::AdaptRunArguments<_GET_CNT>,                       EVENT_EXT_GET_CNT                      },
    {dc2::script::AdaptRunArguments<_SET_CURRENT_DIR>,               EVENT_EXT_SET_CURRENT_DIR              },
    {dc2::script::AdaptRunArguments<_DELETE_CHARA>,                  EVENT_EXT_DELETE_CHARA                 },
    {dc2::script::AdaptRunArguments<_LOAD_MOTION>,                   EVENT_EXT_LOAD_MOTION                  },
    {dc2::script::AdaptRunArguments<_MAP_JUMP>,                      EVENT_EXT_MAP_JUMP                     },
    {dc2::script::AdaptRunArguments<_SET_RAIN>,                      EVENT_EXT_SET_RAIN                     },
    {dc2::script::AdaptRunArguments<_DEL_EXT_MOTION>,                EVENT_EXT_DEL_EXT_MOTION               },
    {dc2::script::AdaptRunArguments<_SET_MARKER>,                    EVENT_EXT_SET_MARKER                   },
    {dc2::script::AdaptRunArguments<_SET_WORLD_COORD>,               EVENT_EXT_SET_WORLD_COORD              },
    {dc2::script::AdaptRunArguments<_FINISH>,                        EVENT_EXT_FINISH                       },
    {dc2::script::AdaptRunArguments<_GET_DUN_WORLD_COORD>,           EVENT_EXT_GET_DUN_WORLD_COORD          },
    {dc2::script::AdaptRunArguments<_LOAD_IMG>,                      EVENT_EXT_LOAD_IMG                     },
    {dc2::script::AdaptRunArguments<_DEL_IMG>,                       EVENT_EXT_DEL_IMG                      },
    {dc2::script::AdaptRunArguments<_SET_DNG_MAP>,                   EVENT_EXT_SET_DNG_MAP                  },
    {dc2::script::AdaptRunArguments<_LOAD_ITEM>,                     EVENT_EXT_LOAD_ITEM                    },
    {dc2::script::AdaptRunArguments<_GOTO_USE_ITEM>,                 EVENT_EXT_GOTO_USE_ITEM                },
    {dc2::script::AdaptRunArguments<_SET_LOCAL_FLAG>,                EVENT_EXT_SET_LOCAL_FLAG               },
    {dc2::script::AdaptRunArguments<_GET_LOCAL_FLAG>,                EVENT_EXT_GET_LOCAL_FLAG               },
    {dc2::script::AdaptRunArguments<_GOTO_SELECT_PARTY>,             EVENT_EXT_GOTO_SELECT_PARTY            },
    {dc2::script::AdaptRunArguments<_SET_LOADBG_FILE>,               EVENT_EXT_SET_LOADBG_FILE              },
    {dc2::script::AdaptRunArguments<_CHECK_LOADBG_FILE>,             EVENT_EXT_CHECK_LOADBG_FILE            },
    {dc2::script::AdaptRunArguments<_GET_TB_ITEMNO>,                 EVENT_EXT_GET_TB_ITEMNO                },
    {dc2::script::AdaptRunArguments<_SET_TB_STATUS>,                 EVENT_EXT_SET_TB_STATUS                },
    {dc2::script::AdaptRunArguments<_SET_TB_ANGLE>,                  EVENT_EXT_SET_TB_ANGLE                 },
    {dc2::script::AdaptRunArguments<_ADD_ITEM>,                      EVENT_EXT_ADD_ITEM                     },
    {dc2::script::AdaptRunArguments<_GET_ITEM_TYPE>,                 EVENT_EXT_GET_ITEM_TYPE                },
    {dc2::script::AdaptRunArguments<_GET_ITEM_SPACE>,                EVENT_EXT_GET_ITEM_SPACE               },
    {dc2::script::AdaptRunArguments<_GET_ADJUST_POLYGON_SCALE>,      EVENT_EXT_GET_ADJUST_POLYGON_SCALE     },
    {dc2::script::AdaptRunArguments<_LOAD_MOVIE>,                    EVENT_EXT_LOAD_MOVIE                   },
    {dc2::script::AdaptRunArguments<_INIT_LOCAL_CNT>,                EVENT_EXT_INIT_LOCAL_CNT               },
    {dc2::script::AdaptRunArguments<_SET_CROSSFADE>,                 EVENT_EXT_SET_CROSSFADE                },
    {dc2::script::AdaptRunArguments<_SET_TIME>,                      EVENT_EXT_SET_TIME                     },
    {dc2::script::AdaptRunArguments<_SET_ACTIVE_LIGHT>,              EVENT_EXT_SET_ACTIVE_LIGHT             },
    {dc2::script::AdaptRunArguments<_SET_PAKU_ANIM>,                 EVENT_EXT_SET_PAKU_ANIM                },
    {dc2::script::AdaptRunArguments<_RESET_PAKU_ANIM>,               EVENT_EXT_RESET_PAKU_ANIM              },
    {dc2::script::AdaptRunArguments<_TRG_PAKU_ANIM>,                 EVENT_EXT_TRG_PAKU_ANIM                },
    {dc2::script::AdaptRunArguments<_RESET_CAMERA>,                  EVENT_EXT_RESET_CAMERA                 },
    {dc2::script::AdaptRunArguments<_GET_ACTIVE_CHR_NO>,             EVENT_EXT_GET_ACTIVE_CHR_NO            },
    {dc2::script::AdaptRunArguments<_SET_ACTIVE_CHR_NO>,             EVENT_EXT_SET_ACTIVE_CHR_NO            },
    {dc2::script::AdaptRunArguments<_DNG_SET_FLOOR_ID>,              EVENT_EXT_DNG_SET_FLOOR_ID             },
    {dc2::script::AdaptRunArguments<_DNG_GET_FLOOR_ID>,              EVENT_EXT_DNG_GET_FLOOR_ID             },
    {dc2::script::AdaptRunArguments<_SET_PAKU_MOTION>,               EVENT_EXT_SET_PAKU_MOTION              },
    {dc2::script::AdaptRunArguments<_RESET_PAKU_MOTION>,             EVENT_EXT_RESET_PAKU_MOTION            },
    {dc2::script::AdaptRunArguments<_TRG_PAKU_MOTION>,               EVENT_EXT_TRG_PAKU_MOTION              },
    {dc2::script::AdaptRunArguments<_SET_BG_COLOR>,                  EVENT_EXT_SET_BG_COLOR                 },
    {dc2::script::AdaptRunArguments<_GOTO_DNG_MAP>,                  EVENT_EXT_GOTO_DNG_MAP                 },
    {dc2::script::AdaptRunArguments<_GOTO_DNG>,                      EVENT_EXT_GOTO_DNG                     },
    {dc2::script::AdaptRunArguments<_GOTO_EDIT>,                     EVENT_EXT_GOTO_EDIT                    },
    {dc2::script::AdaptRunArguments<_GET_MENU_PARAM>,                EVENT_EXT_GET_MENU_PARAM               },
    {dc2::script::AdaptRunArguments<_LOAD_CHARA_NPC>,                EVENT_EXT_LOAD_CHARA_NPC               },
    {dc2::script::AdaptRunArguments<_AUTO_SET_TREASURE_BOX>,         EVENT_EXT_AUTO_SET_TREASURE_BOX        },
    {dc2::script::AdaptRunArguments<_AUTO_SET_MONSTER>,              EVENT_EXT_AUTO_SET_MONSTER             },
    {dc2::script::AdaptRunArguments<_LOAD_DUNGEON_MAP_FILE>,         EVENT_EXT_LOAD_DUNGEON_MAP_FILE        },
    {dc2::script::AdaptRunArguments<_LOAD_MONSTER_FILE>,             EVENT_EXT_LOAD_MONSTER_FILE            },
    {dc2::script::AdaptRunArguments<_GET_NPC_STATUS>,                EVENT_EXT_GET_NPC_STATUS               },
    {dc2::script::AdaptRunArguments<_SET_NPC_STATUS>,                EVENT_EXT_SET_NPC_STATUS               },
    {dc2::script::AdaptRunArguments<_GET_NOW_PARTY_CHARA>,           EVENT_EXT_GET_NOW_PARTY_CHARA          },
    {dc2::script::AdaptRunArguments<_SET_LOCAL_CNT>,                 EVENT_EXT_SET_LOCAL_CNT                },
    {dc2::script::AdaptRunArguments<_GET_LOCAL_CNT>,                 EVENT_EXT_GET_LOCAL_CNT                },
    {dc2::script::AdaptRunArguments<_GET_LOCAL_CNT2>,                EVENT_EXT_GET_LOCAL_CNT2               },
    {dc2::script::AdaptRunArguments<_GET_TRAIN_NPC_POS>,             EVENT_EXT_GET_TRAIN_NPC_POS            },
    {dc2::script::AdaptRunArguments<_GOTO_DRAW_CHAPTER>,             EVENT_EXT_GOTO_DRAW_CHAPTER            },
    {dc2::script::AdaptRunArguments<_SET_PROJECTION>,                EVENT_EXT_SET_PROJECTION               },
    {dc2::script::AdaptRunArguments<_GET_PROJECTION>,                EVENT_EXT_GET_PROJECTION               },
    {dc2::script::AdaptRunArguments<_SET_FADE_IN>,                   EVENT_EXT_SET_FADE_IN                  },
    {dc2::script::AdaptRunArguments<_SET_FADE_OUT>,                  EVENT_EXT_SET_FADE_OUT                 },
    {dc2::script::AdaptRunArguments<_DNG_DEBUG_COMMAND>,             EVENT_EXT_DNG_DEBUG_COMMAND            },
    {dc2::script::AdaptRunArguments<_CD_SEEK>,                       EVENT_EXT_CD_SEEK                      },
    {dc2::script::AdaptRunArguments<_GET_ROT_LOOK_POS>,              EVENT_EXT_GET_ROT_LOOK_POS             },
    {dc2::script::AdaptRunArguments<_SET_MOTION_BLUR>,               EVENT_EXT_SET_MOTION_BLUR              },
    {dc2::script::AdaptRunArguments<_LOAD_SCRIPT>,                   EVENT_EXT_LOAD_SCRIPT                  },
    {dc2::script::AdaptRunArguments<_SET_TALK_CAMERA>,               EVENT_EXT_SET_TALK_CAMERA              },
    {dc2::script::AdaptRunArguments<_HIT_EFFECT>,                    EVENT_EXT_HIT_EFFECT                   },
    {dc2::script::AdaptRunArguments<_COPY_CHARA>,                    EVENT_EXT_COPY_CHARA                   },
    {dc2::script::AdaptRunArguments<_GET_START_BUTTON>,              EVENT_EXT_GET_START_BUTTON             },
    {dc2::script::AdaptRunArguments<_MOVE_INTERIOR>,                 EVENT_EXT_MOVE_INTERIOR                },
    {dc2::script::AdaptRunArguments<_GET_MONSTER_TALK_DATA>,         EVENT_EXT_GET_MONSTER_TALK_DATA        },
    {dc2::script::AdaptRunArguments<_FUNC_POINT_SHOW>,               EVENT_EXT_FUNC_POINT_SHOW              },
    {dc2::script::AdaptRunArguments<_GET_NOW_MAP_NO>,                EVENT_EXT_GET_NOW_MAP_NO               },
    {dc2::script::AdaptRunArguments<_GET_NOW_SUBMAP_NO>,             EVENT_EXT_GET_NOW_SUBMAP_NO            },
    {dc2::script::AdaptRunArguments<_GET_OLD_MAP_NO>,                EVENT_EXT_GET_OLD_MAP_NO               },
    {dc2::script::AdaptRunArguments<_GET_OLD_SUBMAP_NO>,             EVENT_EXT_GET_OLD_SUBMAP_NO            },
    {dc2::script::AdaptRunArguments<_SET_RAIN_CHARA_NO>,             EVENT_EXT_SET_RAIN_CHARA_NO            },
    {dc2::script::AdaptRunArguments<_GET_EDIT_PARTS_POS>,            EVENT_EXT_GET_EDIT_PARTS_POS           },
    {dc2::script::AdaptRunArguments<_GET_CHARA_POS>,                 EVENT_EXT_GET_CHARA_POS                },
    {dc2::script::AdaptRunArguments<_GET_CHARA_TALK_POS>,            EVENT_EXT_GET_CHARA_TALK_POS           },
    {dc2::script::AdaptRunArguments<_TURN_CHARA>,                    EVENT_EXT_TURN_CHARA                   },
    {dc2::script::AdaptRunArguments<_SET_CHARA_POS>,                 EVENT_EXT_SET_CHARA_POS                },
    {dc2::script::AdaptRunArguments<_SET_CHARA_ROT>,                 EVENT_EXT_SET_CHARA_ROT                },
    {dc2::script::AdaptRunArguments<_GET_CHARA_ROT>,                 EVENT_EXT_GET_CHARA_ROT                },
    {dc2::script::AdaptRunArguments<_SET_MOTION>,                    EVENT_EXT_SET_MOTION                   },
    {dc2::script::AdaptRunArguments<_SET_STEP>,                      EVENT_EXT_SET_STEP                     },
    {dc2::script::AdaptRunArguments<_SET_TEX_ANIM>,                  EVENT_EXT_SET_TEX_ANIM                 },
    {dc2::script::AdaptRunArguments<_SET_SCALE>,                     EVENT_EXT_SET_SCALE                    },
    {dc2::script::AdaptRunArguments<_SET_REFERENCE>,                 EVENT_EXT_SET_REFERENCE                },
    {dc2::script::AdaptRunArguments<_DEL_REFERENCE>,                 EVENT_EXT_DEL_REFERENCE                },
    {dc2::script::AdaptRunArguments<_SHADOW_CLIP_OFF>,               EVENT_EXT_SHADOW_CLIP_OFF              },
    {dc2::script::AdaptRunArguments<_GET_COORDINATE_ANGLE>,          EVENT_EXT_GET_COORDINATE_ANGLE         },
    {dc2::script::AdaptRunArguments<_GET_CHARA_WIDTH>,               EVENT_EXT_GET_CHARA_WIDTH              },
    {dc2::script::AdaptRunArguments<_GET_CHARA_HEIGHT>,              EVENT_EXT_GET_CHARA_HEIGHT             },
    {dc2::script::AdaptRunArguments<_GET_CHARA_WEIGHT>,              EVENT_EXT_GET_CHARA_WEIGHT             },
    {dc2::script::AdaptRunArguments<_SET_CHARA_SHOW>,                EVENT_EXT_SET_CHARA_SHOW               },
    {dc2::script::AdaptRunArguments<_GET_CHARA_SHOW>,                EVENT_EXT_GET_CHARA_SHOW               },
    {dc2::script::AdaptRunArguments<_CHARA_DA_ENABLE>,               EVENT_EXT_CHARA_DA_ENABLE              },
    {dc2::script::AdaptRunArguments<_GET_MOT_NOW_WAIT>,              EVENT_EXT_GET_MOT_NOW_WAIT             },
    {dc2::script::AdaptRunArguments<_CHECK_MOTION_END>,              EVENT_EXT_CHECK_MOTION_END             },
    {dc2::script::AdaptRunArguments<_ACTCHR_SET_MOTION>,             EVENT_EXT_ACTCHR_SET_MOTION            },
    {dc2::script::AdaptRunArguments<_SET_CHARA_EX_SOUNDID>,          EVENT_EXT_SET_CHARA_EX_SOUNDID         },
    {dc2::script::AdaptRunArguments<_ACTCHR_SOUND_INFO_COPY>,        EVENT_EXT_ACTCHR_SOUND_INFO_COPY       },
    {dc2::script::AdaptRunArguments<_MES_MAKE>,                      EVENT_EXT_MES_MAKE                     },
    {dc2::script::AdaptRunArguments<_MES_CLOSE>,                     EVENT_EXT_MES_CLOSE                    },
    {dc2::script::AdaptRunArguments<_MES_NEXTPAGE>,                  EVENT_EXT_MES_NEXTPAGE                 },
    {dc2::script::AdaptRunArguments<_SET_MES_AUTOSET>,               EVENT_EXT_SET_MES_AUTOSET              },
    {dc2::script::AdaptRunArguments<_SET_MES_SHIPPO>,                EVENT_EXT_SET_MES_SHIPPO               },
    {dc2::script::AdaptRunArguments<_SET_MES_POS>,                   EVENT_EXT_SET_MES_POS                  },
    {dc2::script::AdaptRunArguments<_SET_MES_DRAWSPEED>,             EVENT_EXT_SET_MES_DRAWSPEED            },
    {dc2::script::AdaptRunArguments<_SET_MES_CURSOR>,                EVENT_EXT_SET_MES_CURSOR               },
    {dc2::script::AdaptRunArguments<_SET_MES_OKURI>,                 EVENT_EXT_SET_MES_OKURI                },
    {dc2::script::AdaptRunArguments<_SET_MES_FUKIDASHI>,             EVENT_EXT_SET_MES_FUKIDASHI            },
    {dc2::script::AdaptRunArguments<_CHECK_MES_COMPLETE>,            EVENT_EXT_CHECK_MES_COMPLETE           },
    {dc2::script::AdaptRunArguments<_CHECK_MES_WAIT>,                EVENT_EXT_CHECK_MES_WAIT               },
    {dc2::script::AdaptRunArguments<_CHECK_MES>,                     EVENT_EXT_CHECK_MES                    },
    {dc2::script::AdaptRunArguments<_SET_MES_WIN_FLAG>,              EVENT_EXT_SET_MES_WIN_FLAG             },
    {dc2::script::AdaptRunArguments<_SET_CAMERA_POS>,                EVENT_EXT_SET_CAMERA_POS               },
    {dc2::script::AdaptRunArguments<_GET_CAMERA_POS>,                EVENT_EXT_GET_CAMERA_POS               },
    {dc2::script::AdaptRunArguments<_SET_CAMERA_REF>,                EVENT_EXT_SET_CAMERA_REF               },
    {dc2::script::AdaptRunArguments<_GET_CAMERA_REF>,                EVENT_EXT_GET_CAMERA_REF               },
    {dc2::script::AdaptRunArguments<_SET_CAMERA_SPEED>,              EVENT_EXT_SET_CAMERA_SPEED             },
    {dc2::script::AdaptRunArguments<_CAMERA_STEP>,                   EVENT_EXT_CAMERA_STEP                  },
    {dc2::script::AdaptRunArguments<_SET_MES_WINDOW_MODE>,           EVENT_EXT_SET_MES_WINDOW_MODE          },
    {dc2::script::AdaptRunArguments<_SET_MES_PRESET>,                EVENT_EXT_SET_MES_PRESET               },
    {dc2::script::AdaptRunArguments<_SET_MES_ITEM_DIRECT>,           EVENT_EXT_SET_MES_ITEM_DIRECT          },
    {dc2::script::AdaptRunArguments<_SET_MES_ITEM>,                  EVENT_EXT_SET_MES_ITEM                 },
    {dc2::script::AdaptRunArguments<_SET_MES_VALUE>,                 EVENT_EXT_SET_MES_VALUE                },
    {dc2::script::AdaptRunArguments<_GET_MES_STATUS>,                EVENT_EXT_GET_MES_STATUS               },
    {dc2::script::AdaptRunArguments<_GET_PARTY_CHARA_MES_NO>,        EVENT_EXT_GET_PARTY_CHARA_MES_NO       },
    {dc2::script::AdaptRunArguments<_MES_SET_BUFF>,                  EVENT_EXT_MES_SET_BUFF                 },
    {dc2::script::AdaptRunArguments<_GET_MES_WINDOW_MODE>,           EVENT_EXT_GET_MES_WINDOW_MODE          },
    {dc2::script::AdaptRunArguments<_GET_MES_VOICE>,                 EVENT_EXT_GET_MES_VOICE                },
    {dc2::script::AdaptRunArguments<_SET_MES_QUESTION_GYOU>,         EVENT_EXT_SET_MES_QUESTION_GYOU        },
    {dc2::script::AdaptRunArguments<_GET_MES_QUESTION_GYOU>,         EVENT_EXT_GET_MES_QUESTION_GYOU        },
    {dc2::script::AdaptRunArguments<_SET_MES_CLOSE_CNT>,             EVENT_EXT_SET_MES_CLOSE_CNT            },
    {dc2::script::AdaptRunArguments<_SET_MES_ETC>,                   EVENT_EXT_SET_MES_ETC                  },
    {dc2::script::AdaptRunArguments<_GET_MES_ETC>,                   EVENT_EXT_GET_MES_ETC                  },
    {dc2::script::AdaptRunArguments<_LOAD_MES>,                      EVENT_EXT_LOAD_MES                     },
    {dc2::script::AdaptRunArguments<_MES_SE_PLAY>,                   EVENT_EXT_MES_SE_PLAY                  },
    {dc2::script::AdaptRunArguments<_SET_MES_STR>,                   EVENT_EXT_SET_MES_STR                  },
    {dc2::script::AdaptRunArguments<_GET_MES_OKURI>,                 EVENT_EXT_GET_MES_OKURI                },
    {dc2::script::AdaptRunArguments<_ASQ_INIT>,                      EVENT_EXT_ASQ_INIT                     },
    {dc2::script::AdaptRunArguments<_ASQ_SYNC_CHARA>,                EVENT_EXT_ASQ_SYNC_CHARA               },
    {dc2::script::AdaptRunArguments<_ASQ_SET_POS>,                   EVENT_EXT_ASQ_SET_POS                  },
    {dc2::script::AdaptRunArguments<_ASQ_MOVE>,                      EVENT_EXT_ASQ_MOVE                     },
    {dc2::script::AdaptRunArguments<_ASQ_MOVE_STEP>,                 EVENT_EXT_ASQ_MOVE_STEP                },
    {dc2::script::AdaptRunArguments<_ASQ_ROT_REF>,                   EVENT_EXT_ASQ_ROT_REF                  },
    {dc2::script::AdaptRunArguments<_ASQ_CLEAR_ROT>,                 EVENT_EXT_ASQ_CLEAR_ROT                },
    {dc2::script::AdaptRunArguments<_ASQ_WAIT_ROT>,                  EVENT_EXT_ASQ_WAIT_ROT                 },
    {dc2::script::AdaptRunArguments<_ASQ_ROT_MOVE>,                  EVENT_EXT_ASQ_ROT_MOVE                 },
    {dc2::script::AdaptRunArguments<_ASQ_ROT_ANGLE>,                 EVENT_EXT_ASQ_ROT_ANGLE                },
    {dc2::script::AdaptRunArguments<_ASQ_SET_ROT>,                   EVENT_EXT_ASQ_SET_ROT                  },
    {dc2::script::AdaptRunArguments<_ASQ_DELAY_ROT>,                 EVENT_EXT_ASQ_DELAY_ROT                },
    {dc2::script::AdaptRunArguments<_ASQ_CHECK>,                     EVENT_EXT_ASQ_CHECK                    },
    {dc2::script::AdaptRunArguments<_ASQ_MOTION_TRG>,                EVENT_EXT_ASQ_MOTION_TRG               },
    {dc2::script::AdaptRunArguments<_ASQ_MOTION_PLAY>,               EVENT_EXT_ASQ_MOTION_PLAY              },
    {dc2::script::AdaptRunArguments<_ASQ_MOTION_STOP>,               EVENT_EXT_ASQ_MOTION_STOP              },
    {dc2::script::AdaptRunArguments<_ASQ_MOTION_NEXT>,               EVENT_EXT_ASQ_MOTION_NEXT              },
    {dc2::script::AdaptRunArguments<_ASQ_ANIME_TRG>,                 EVENT_EXT_ASQ_ANIME_TRG                },
    {dc2::script::AdaptRunArguments<_ASQ_ANIME>,                     EVENT_EXT_ASQ_ANIME                    },
    {dc2::script::AdaptRunArguments<_ASQ_SE_PLAY>,                   EVENT_EXT_ASQ_SE_PLAY                  },
    {dc2::script::AdaptRunArguments<_IMG_SET_DRAW>,                  EVENT_EXT_IMG_SET_DRAW                 },
    {dc2::script::AdaptRunArguments<_IMG_SET_GET>,                   EVENT_EXT_IMG_SET_GET                  },
    {dc2::script::AdaptRunArguments<_IMG_SET_PUT>,                   EVENT_EXT_IMG_SET_PUT                  },
    {dc2::script::AdaptRunArguments<_IMG_SET_NAME>,                  EVENT_EXT_IMG_SET_NAME                 },
    {dc2::script::AdaptRunArguments<_IMG_SET_MOVE>,                  EVENT_EXT_IMG_SET_MOVE                 },
    {dc2::script::AdaptRunArguments<_IMG_SET_FADE>,                  EVENT_EXT_IMG_SET_FADE                 },
    {dc2::script::AdaptRunArguments<_IMG_SET_COLOR>,                 EVENT_EXT_IMG_SET_COLOR                },
    {dc2::script::AdaptRunArguments<_SPRITE_INIT>,                   EVENT_EXT_SPRITE_INIT                  },
    {dc2::script::AdaptRunArguments<_SPRITE_SET_DRAW>,               EVENT_EXT_SPRITE_SET_DRAW              },
    {dc2::script::AdaptRunArguments<_SPRITE_SET_TYPE>,               EVENT_EXT_SPRITE_SET_TYPE              },
    {dc2::script::AdaptRunArguments<_SPRITE_SET_TEXTURE>,            EVENT_EXT_SPRITE_SET_TEXTURE           },
    {dc2::script::AdaptRunArguments<_SPRITE_SET_POS>,                EVENT_EXT_SPRITE_SET_POS               },
    {dc2::script::AdaptRunArguments<_SPRITE_SET_PUTSIZE>,            EVENT_EXT_SPRITE_SET_PUTSIZE           },
    {dc2::script::AdaptRunArguments<_SPRITE_SET_UVSIZE>,             EVENT_EXT_SPRITE_SET_UVSIZE            },
    {dc2::script::AdaptRunArguments<_SPRITE_SET_COLOR>,              EVENT_EXT_SPRITE_SET_COLOR             },
    {dc2::script::AdaptRunArguments<_SPRITE_SET_SCALE>,              EVENT_EXT_SPRITE_SET_SCALE             },
    {dc2::script::AdaptRunArguments<_SPRITE_SET_ALPHAB>,             EVENT_EXT_SPRITE_SET_ALPHAB            },
    {dc2::script::AdaptRunArguments<_CMRS_CHECK>,                    EVENT_EXT_CMRS_CHECK                   },
    {dc2::script::AdaptRunArguments<_CMRS_INIT>,                     EVENT_EXT_CMRS_INIT                    },
    {dc2::script::AdaptRunArguments<_CMRS_PRDELAY>,                  EVENT_EXT_CMRS_PRDELAY                 },
    {dc2::script::AdaptRunArguments<_CMRS_SET_POS>,                  EVENT_EXT_CMRS_SET_POS                 },
    {dc2::script::AdaptRunArguments<_CMRS_SET_REF>,                  EVENT_EXT_CMRS_SET_REF                 },
    {dc2::script::AdaptRunArguments<_CMRS_MOVE>,                     EVENT_EXT_CMRS_MOVE                    },
    {dc2::script::AdaptRunArguments<_CMRS_MOVE_REF>,                 EVENT_EXT_CMRS_MOVE_REF                },
    {dc2::script::AdaptRunArguments<_CMRS_INIT_PAS>,                 EVENT_EXT_CMRS_INIT_PAS                },
    {dc2::script::AdaptRunArguments<_CMRS_SET_PAS_FRM>,              EVENT_EXT_CMRS_SET_PAS_FRM             },
    {dc2::script::AdaptRunArguments<_CMRS_ADD_PAS>,                  EVENT_EXT_CMRS_ADD_PAS                 },
    {dc2::script::AdaptRunArguments<_CMRS_START_PAS>,                EVENT_EXT_CMRS_START_PAS               },
    {dc2::script::AdaptRunArguments<_CMRS_PR_SLOWING>,               EVENT_EXT_CMRS_PR_SLOWING              },
    {dc2::script::AdaptRunArguments<_CMRS_PR_KEEP>,                  EVENT_EXT_CMRS_PR_KEEP                 },
    {dc2::script::AdaptRunArguments<_CMRS_PR_RETURN>,                EVENT_EXT_CMRS_PR_RETURN               },
    {dc2::script::AdaptRunArguments<_CMRS_AHDDELAY>,                 EVENT_EXT_CMRS_AHDDELAY                },
    {dc2::script::AdaptRunArguments<_CMRS_SET_ANGLE>,                EVENT_EXT_CMRS_SET_ANGLE               },
    {dc2::script::AdaptRunArguments<_CMRS_SET_HEIGHT>,               EVENT_EXT_CMRS_SET_HEIGHT              },
    {dc2::script::AdaptRunArguments<_CMRS_SET_DIST>,                 EVENT_EXT_CMRS_SET_DIST                },
    {dc2::script::AdaptRunArguments<_CMRS_SET_AHD>,                  EVENT_EXT_CMRS_SET_AHD                 },
    {dc2::script::AdaptRunArguments<_CMRS_MOVE_AHD>,                 EVENT_EXT_CMRS_MOVE_AHD                },
    {dc2::script::AdaptRunArguments<_CMRS_SYNC_OBJ>,                 EVENT_EXT_CMRS_SYNC_OBJ                },
    {dc2::script::AdaptRunArguments<_CMRS_RELEASE_OBJ>,              EVENT_EXT_CMRS_RELEASE_OBJ             },
    {dc2::script::AdaptRunArguments<_CMRS_AHD_SLOWING>,              EVENT_EXT_CMRS_AHD_SLOWING             },
    {dc2::script::AdaptRunArguments<_CMRS_AHD_KEEP>,                 EVENT_EXT_CMRS_AHD_KEEP                },
    {dc2::script::AdaptRunArguments<_CMRS_AHD_RETURN>,               EVENT_EXT_CMRS_AHD_RETURN              },
    {dc2::script::AdaptRunArguments<_CMRS_FADE_DELAY>,               EVENT_EXT_CMRS_FADE_DELAY              },
    {dc2::script::AdaptRunArguments<_CMRS_FADE_INIT>,                EVENT_EXT_CMRS_FADE_INIT               },
    {dc2::script::AdaptRunArguments<_CMRS_FADE_IN>,                  EVENT_EXT_CMRS_FADE_IN                 },
    {dc2::script::AdaptRunArguments<_CMRS_FADE_OUT>,                 EVENT_EXT_CMRS_FADE_OUT                },
    {dc2::script::AdaptRunArguments<_CMRS_QUAKE_DELAY>,              EVENT_EXT_CMRS_QUAKE_DELAY             },
    {dc2::script::AdaptRunArguments<_CMRS_QUAKE>,                    EVENT_EXT_CMRS_QUAKE                   },
    {dc2::script::AdaptRunArguments<_CMRS_MOVE2>,                    EVENT_EXT_CMRS_MOVE2                   },
    {dc2::script::AdaptRunArguments<_CMRS_MOVE_AHD2>,                EVENT_EXT_CMRS_MOVE_AHD2               },
    {dc2::script::AdaptRunArguments<_CMRS_CHARA_DELAY>,              EVENT_EXT_CMRS_CHARA_DELAY             },
    {dc2::script::AdaptRunArguments<_CMRS_CHARA_ATTACH>,             EVENT_EXT_CMRS_CHARA_ATTACH            },
    {dc2::script::AdaptRunArguments<_CMRS_MOVE_POS>,                 EVENT_EXT_CMRS_MOVE_POS                },
    {dc2::script::AdaptRunArguments<_CMRS_QUAKE2>,                   EVENT_EXT_CMRS_QUAKE2                  },
    {dc2::script::AdaptRunArguments<_OBJS_CHECK>,                    EVENT_EXT_OBJS_CHECK                   },
    {dc2::script::AdaptRunArguments<_OBJS_INIT>,                     EVENT_EXT_OBJS_INIT                    },
    {dc2::script::AdaptRunArguments<_OBJS_SYNC_OBJ>,                 EVENT_EXT_OBJS_SYNC_OBJ                },
    {dc2::script::AdaptRunArguments<_OBJS_POS_DELAY>,                EVENT_EXT_OBJS_POS_DELAY               },
    {dc2::script::AdaptRunArguments<_OBJS_SET_POS>,                  EVENT_EXT_OBJS_SET_POS                 },
    {dc2::script::AdaptRunArguments<_OBJS_MOVE>,                     EVENT_EXT_OBJS_MOVE                    },
    {dc2::script::AdaptRunArguments<_OBJS_MOVE2>,                    EVENT_EXT_OBJS_MOVE2                   },
    {dc2::script::AdaptRunArguments<_OBJS_INIT_PAS>,                 EVENT_EXT_OBJS_INIT_PAS                },
    {dc2::script::AdaptRunArguments<_OBJS_SET_PAS_FRM>,              EVENT_EXT_OBJS_SET_PAS_FRM             },
    {dc2::script::AdaptRunArguments<_OBJS_ADD_PAS>,                  EVENT_EXT_OBJS_ADD_PAS                 },
    {dc2::script::AdaptRunArguments<_OBJS_START_PAS>,                EVENT_EXT_OBJS_START_PAS               },
    {dc2::script::AdaptRunArguments<_OBJS_JUMP>,                     EVENT_EXT_OBJS_JUMP                    },
    {dc2::script::AdaptRunArguments<_OBJS_SET_EOH_FRAME_POS>,        EVENT_EXT_OBJS_SET_EOH_FRAME_POS       },
    {dc2::script::AdaptRunArguments<_OBJS_ADD_POS>,                  EVENT_EXT_OBJS_ADD_POS                 },
    {dc2::script::AdaptRunArguments<_OBJS_ATTACH_CAMERA>,            EVENT_EXT_OBJS_ATTACH_CAMERA           },
    {dc2::script::AdaptRunArguments<_OBJS_ROT_DELAY>,                EVENT_EXT_OBJS_ROT_DELAY               },
    {dc2::script::AdaptRunArguments<_OBJS_SET_ROT>,                  EVENT_EXT_OBJS_SET_ROT                 },
    {dc2::script::AdaptRunArguments<_OBJS_ROTATION>,                 EVENT_EXT_OBJS_ROTATION                },
    {dc2::script::AdaptRunArguments<_OBJS_ROTATION2>,                EVENT_EXT_OBJS_ROTATION2               },
    {dc2::script::AdaptRunArguments<_OBJS_REFERENCE>,                EVENT_EXT_OBJS_REFERENCE               },
    {dc2::script::AdaptRunArguments<_OBJS_MOTION_DELAY>,             EVENT_EXT_OBJS_MOTION_DELAY            },
    {dc2::script::AdaptRunArguments<_OBJS_SET_MOTION>,               EVENT_EXT_OBJS_SET_MOTION              },
    {dc2::script::AdaptRunArguments<_OBJS_NEXT_MOTION>,              EVENT_EXT_OBJS_NEXT_MOTION             },
    {dc2::script::AdaptRunArguments<_OBJS_MOTION_WAIT>,              EVENT_EXT_OBJS_MOTION_WAIT             },
    {dc2::script::AdaptRunArguments<_OBJS_SET_STEP>,                 EVENT_EXT_OBJS_SET_STEP                },
    {dc2::script::AdaptRunArguments<_OBJS_CHENGE_STEP>,              EVENT_EXT_OBJS_CHENGE_STEP             },
    {dc2::script::AdaptRunArguments<_OBJS_SEQ_MOT_TRG>,              EVENT_EXT_OBJS_SEQ_MOT_TRG             },
    {dc2::script::AdaptRunArguments<_OBJS_SEQ_MOT_TRG_WAIT>,         EVENT_EXT_OBJS_SEQ_MOT_TRG_WAIT        },
    {dc2::script::AdaptRunArguments<_OBJS_RESET_MOTION>,             EVENT_EXT_OBJS_RESET_MOTION            },
    {dc2::script::AdaptRunArguments<_OBJS_SET_MOTION_NOW_TIME>,      EVENT_EXT_OBJS_SET_MOTION_NOW_TIME     },
    {dc2::script::AdaptRunArguments<_OBJS_SET_MOTION_WAIT_TIME>,     EVENT_EXT_OBJS_SET_MOTION_WAIT_TIME    },
    {dc2::script::AdaptRunArguments<_OBJS_TEXA_DELAY>,               EVENT_EXT_OBJS_TEXA_DELAY              },
    {dc2::script::AdaptRunArguments<_OBJS_TEX_ANIME>,                EVENT_EXT_OBJS_TEX_ANIME               },
    {dc2::script::AdaptRunArguments<_OBJS_COLOR_DELAY>,              EVENT_EXT_OBJS_COLOR_DELAY             },
    {dc2::script::AdaptRunArguments<_OBJS_SET_COLOR>,                EVENT_EXT_OBJS_SET_COLOR               },
    {dc2::script::AdaptRunArguments<_OBJS_SCALE_DELAY>,              EVENT_EXT_OBJS_SCALE_DELAY             },
    {dc2::script::AdaptRunArguments<_OBJS_SET_SCALE>,                EVENT_EXT_OBJS_SET_SCALE               },
    {dc2::script::AdaptRunArguments<_OBJS_SE_DELAY>,                 EVENT_EXT_OBJS_SE_DELAY                },
    {dc2::script::AdaptRunArguments<_OBJS_SE_PLAY>,                  EVENT_EXT_OBJS_SE_PLAY                 },
    {dc2::script::AdaptRunArguments<_OBJS_RESET_DA_POSITION>,        EVENT_EXT_OBJS_RESET_DA_POSITION       },
    {dc2::script::AdaptRunArguments<_OBJS_NORMAL_DRIVE>,             EVENT_EXT_OBJS_NORMAL_DRIVE            },
    {dc2::script::AdaptRunArguments<_GET_CONTENTS_POS>,              EVENT_EXT_GET_CONTENTS_POS             },
    {dc2::script::AdaptRunArguments<_GET_BPOT_POS>,                  EVENT_EXT_GET_BPOT_POS                 },
    {dc2::script::AdaptRunArguments<_GET_BPOT_STATUS>,               EVENT_EXT_GET_BPOT_STATUS              },
    {dc2::script::AdaptRunArguments<_GET_PERSON_STATUS>,             EVENT_EXT_GET_PERSON_STATUS            },
    {dc2::script::AdaptRunArguments<_GET_CONTROL_CHRID>,             EVENT_EXT_GET_CONTROL_CHRID            },
    {dc2::script::AdaptRunArguments<_GET_BEFORE_CAMERA_POS>,         EVENT_EXT_GET_BEFORE_CAMERA_POS        },
    {dc2::script::AdaptRunArguments<_GET_BEFORE_CAMERA_REF>,         EVENT_EXT_GET_BEFORE_CAMERA_REF        },
    {dc2::script::AdaptRunArguments<_SET_CAMERA_NEXT_REF>,           EVENT_EXT_SET_CAMERA_NEXT_REF          },
    {dc2::script::AdaptRunArguments<_GOTO_MENU>,                     EVENT_EXT_GOTO_MENU                    },
    {dc2::script::AdaptRunArguments<_GET_MENU_STATUS>,               EVENT_EXT_GET_MENU_STATUS              },
    {dc2::script::AdaptRunArguments<_LOAD_EQUIP>,                    EVENT_EXT_LOAD_EQUIP                   },
    {dc2::script::AdaptRunArguments<_GET_EQUIP_ITEMNO>,              EVENT_EXT_GET_EQUIP_ITEMNO             },
    {dc2::script::AdaptRunArguments<_SET_TIME_STEP_ENABLE>,          EVENT_EXT_SET_TIME_STEP_ENABLE         },
    {dc2::script::AdaptRunArguments<_SET_DOOR_MATERIAL>,             EVENT_EXT_SET_DOOR_MATERIAL            },
    {dc2::script::AdaptRunArguments<_INIT_DRAMA_SCENE>,              EVENT_EXT_INIT_DRAMA_SCENE             },
    {dc2::script::AdaptRunArguments<_SET_ACTIVE_CMRID>,              EVENT_EXT_SET_ACTIVE_CMRID             },
    {dc2::script::AdaptRunArguments<_SET_BEFORE_CMRID>,              EVENT_EXT_SET_BEFORE_CMRID             },
    {dc2::script::AdaptRunArguments<_DNGMAP_LOAD>,                   EVENT_EXT_DNGMAP_LOAD                  },
    {dc2::script::AdaptRunArguments<_DNGMAP_DELETE>,                 EVENT_EXT_DNGMAP_DELETE                },
    {dc2::script::AdaptRunArguments<_DNGMAP_MOVE_PIECE>,             EVENT_EXT_DNGMAP_MOVE_PIECE            },
    {dc2::script::AdaptRunArguments<_DNGMAP_ONOFF>,                  EVENT_EXT_DNGMAP_ONOFF                 },
    {dc2::script::AdaptRunArguments<_DNGMAP_SET_FADE>,               EVENT_EXT_DNGMAP_SET_FADE              },
    {dc2::script::AdaptRunArguments<_GET_BEFORE_CAMERA_NEXT_POS>,    EVENT_EXT_GET_BEFORE_CAMERA_NEXT_POS   },
    {dc2::script::AdaptRunArguments<_GET_BEFORE_CAMERA_NEXT_REF>,    EVENT_EXT_GET_BEFORE_CAMERA_NEXT_REF   },
    {dc2::script::AdaptRunArguments<_SET_CAMERA_NEXT_POS>,           EVENT_EXT_SET_CAMERA_NEXT_POS          },
    {dc2::script::AdaptRunArguments<_CHK_INTERSECTION_POINT>,        EVENT_EXT_CHK_INTERSECTION_POINT       },
    {dc2::script::AdaptRunArguments<_SET_FCAMERA_FOLLOW>,            EVENT_EXT_SET_FCAMERA_FOLLOW           },
    {dc2::script::AdaptRunArguments<_SET_FCAMERA_FOLLOW_A>,          EVENT_EXT_SET_FCAMERA_FOLLOW_A         },
    {dc2::script::AdaptRunArguments<_SET_FCAMERA_FOLLOW_OFS>,        EVENT_EXT_SET_FCAMERA_FOLLOW_OFS       },
    {dc2::script::AdaptRunArguments<_SET_FCAMERA_FOLLOW_FLAG>,       EVENT_EXT_SET_FCAMERA_FOLLOW_FLAG      },
    {dc2::script::AdaptRunArguments<_FCAMERA_STEP>,                  EVENT_EXT_FCAMERA_STEP                 },
    {dc2::script::AdaptRunArguments<_SET_FCAMERA_ANGLE>,             EVENT_EXT_SET_FCAMERA_ANGLE            },
    {dc2::script::AdaptRunArguments<_SET_FCAMERA_HEIGHT>,            EVENT_EXT_SET_FCAMERA_HEIGHT           },
    {dc2::script::AdaptRunArguments<_SET_FCAMERA_DIST>,              EVENT_EXT_SET_FCAMERA_DIST             },
    {dc2::script::AdaptRunArguments<_GET_REF_ANGLE>,                 EVENT_EXT_GET_REF_ANGLE                },
    {dc2::script::AdaptRunArguments<_DNG_SET_STAGE_ID>,              EVENT_EXT_DNG_SET_STAGE_ID             },
    {dc2::script::AdaptRunArguments<_DNG_GET_STAGE_ID>,              EVENT_EXT_DNG_GET_STAGE_ID             },
    {dc2::script::AdaptRunArguments<_SET_CAMERA_CTRL>,               EVENT_EXT_SET_CAMERA_CTRL              },
    {dc2::script::AdaptRunArguments<_GET_FCAMERA_ANGLE>,             EVENT_EXT_GET_FCAMERA_ANGLE            },
    {dc2::script::AdaptRunArguments<_GET_FCAMERA_HEIGHT>,            EVENT_EXT_GET_FCAMERA_HEIGHT           },
    {dc2::script::AdaptRunArguments<_GET_FCAMERA_DIST>,              EVENT_EXT_GET_FCAMERA_DIST             },
    {dc2::script::AdaptRunArguments<_GET_INVENTION_ID>,              EVENT_EXT_GET_INVENTION_ID             },
    {dc2::script::AdaptRunArguments<_FUNCTION_MAP_JUMP>,             EVENT_EXT_FUNCTION_MAP_JUMP            },
    {dc2::script::AdaptRunArguments<_FUNCTION_DOOR_MODE>,            EVENT_EXT_FUNCTION_DOOR_MODE           },
    {dc2::script::AdaptRunArguments<_GET_MONEY>,                     EVENT_EXT_GET_MONEY                    },
    {dc2::script::AdaptRunArguments<_ADD_MONEY>,                     EVENT_EXT_ADD_MONEY                    },
    {dc2::script::AdaptRunArguments<_GET_ITEM_NUM>,                  EVENT_EXT_GET_ITEM_NUM                 },
    {dc2::script::AdaptRunArguments<_CHECK_BUTTON>,                  EVENT_EXT_CHECK_BUTTON                 },
    {dc2::script::AdaptRunArguments<_GET_LANGUAGE>,                  EVENT_EXT_GET_LANGUAGE                 },
    {dc2::script::AdaptRunArguments<_CHECK_INVENT_ITEM>,             EVENT_EXT_CHECK_INVENT_ITEM            },
    {dc2::script::AdaptRunArguments<_SET_AI>,                        EVENT_EXT_SET_AI                       },
    {dc2::script::AdaptRunArguments<_CHECK_INVENT_PHOTO>,            EVENT_EXT_CHECK_INVENT_PHOTO           },
    {dc2::script::AdaptRunArguments<_GET_PHOTO_NUM>,                 EVENT_EXT_GET_PHOTO_NUM                },
    {dc2::script::AdaptRunArguments<_SET_CONTENTS_ETC>,              EVENT_EXT_SET_CONTENTS_ETC             },
    {dc2::script::AdaptRunArguments<_SET_STATUS>,                    EVENT_EXT_SET_STATUS                   },
    {dc2::script::AdaptRunArguments<_GOTO_SUBGAME>,                  EVENT_EXT_GOTO_SUBGAME                 },
    {dc2::script::AdaptRunArguments<_SET_GYORACE_ETC>,               EVENT_EXT_SET_GYORACE_ETC              },
    {dc2::script::AdaptRunArguments<_GET_GYORACE_ETC>,               EVENT_EXT_GET_GYORACE_ETC              },
    {dc2::script::AdaptRunArguments<_SET_SAVEDATA_ETC>,              EVENT_EXT_SET_SAVEDATA_ETC             },
    {dc2::script::AdaptRunArguments<_GET_SAVEDATA_ETC>,              EVENT_EXT_GET_SAVEDATA_ETC             },
    {dc2::script::AdaptRunArguments<_DEL_MONSTER>,                   EVENT_EXT_DEL_MONSTER                  },
    {dc2::script::AdaptRunArguments<_SET_MENU_ETC>,                  EVENT_EXT_SET_MENU_ETC                 },
    {dc2::script::AdaptRunArguments<_GET_MENU_ETC>,                  EVENT_EXT_GET_MENU_ETC                 },
    {dc2::script::AdaptRunArguments<_GET_ANALYZE>,                   EVENT_EXT_GET_ANALYZE                  },
    {dc2::script::AdaptRunArguments<_GET_DIORAMA_PERCENT>,           EVENT_EXT_GET_DIORAMA_PERCENT          },
    {dc2::script::AdaptRunArguments<_GEORAMA_FUNC>,                  EVENT_EXT_GEORAMA_FUNC                 },
    {dc2::script::AdaptRunArguments<_GET_CHARA_ID>,                  EVENT_EXT_GET_CHARA_ID                 },
    {dc2::script::AdaptRunArguments<_SET_LOADBG_FILE_MONS_TALK>,     EVENT_EXT_SET_LOADBG_FILE_MONS_TALK    },
    {dc2::script::AdaptRunArguments<_LOAD_MES_MONS_TALK>,            EVENT_EXT_LOAD_MES_MONS_TALK           },
    {dc2::script::AdaptRunArguments<_GOTO_EDITMODE>,                 EVENT_EXT_GOTO_EDITMODE                },
    {dc2::script::AdaptRunArguments<_GET_CHAPTER>,                   EVENT_EXT_GET_CHAPTER                  },
    {dc2::script::AdaptRunArguments<_GET_NPC_TRAIN_ETC>,             EVENT_EXT_GET_NPC_TRAIN_ETC            },
    {dc2::script::AdaptRunArguments<_REGISTER_VILLAGER>,             EVENT_EXT_REGISTER_VILLAGER            },
    {dc2::script::AdaptRunArguments<_EYE_VIEW_DRAW_ON_OFF>,          EVENT_EXT_EYE_VIEW_DRAW_ON_OFF         },
    {dc2::script::AdaptRunArguments<_SET_QUEST_ETC>,                 EVENT_EXT_SET_QUEST_ETC                },
    {dc2::script::AdaptRunArguments<_GET_QUEST_ETC>,                 EVENT_EXT_GET_QUEST_ETC                },
    {dc2::script::AdaptRunArguments<_CHK_INTERSECTION_POINT_PIPE>,   EVENT_EXT_CHK_INTERSECTION_POINT_PIPE  },
    {dc2::script::AdaptRunArguments<_GET_OLD_INTERIOR_MAP_NO>,       EVENT_EXT_GET_OLD_INTERIOR_MAP_NO      },
    {dc2::script::AdaptRunArguments<_SET_EVENT_DATA>,                EVENT_EXT_SET_EVENT_DATA               },
    {dc2::script::AdaptRunArguments<_STOPWATCH>,                     EVENT_EXT_STOPWATCH                    },
    {dc2::script::AdaptRunArguments<_SET_FUNC_ETC>,                  EVENT_EXT_SET_FUNC_ETC                 },
    {dc2::script::AdaptRunArguments<_GET_FISHINGTOURNAMENT_ETC>,     EVENT_EXT_GET_FISHINGTOURNAMENT_ETC    },
    {dc2::script::AdaptRunArguments<_SET_CHARA_FAR_DIST>,            EVENT_EXT_SET_CHARA_FAR_DIST           },
    {dc2::script::AdaptRunArguments<_SET_MODEL_LIGHT_SWITCH>,        EVENT_EXT_SET_MODEL_LIGHT_SWITCH       },
    {dc2::script::AdaptRunArguments<_SET_MODEL_LIGHT_COLOR>,         EVENT_EXT_SET_MODEL_LIGHT_COLOR        },
    {dc2::script::AdaptRunArguments<_GET_OMAKE_FLAG>,                EVENT_EXT_GET_OMAKE_FLAG               },
    {dc2::script::AdaptRunArguments<_SET_WIND>,                      EVENT_EXT_SET_WIND                     },
    {dc2::script::AdaptRunArguments<_SET_OMAKE_FLAG>,                EVENT_EXT_SET_OMAKE_FLAG               },
    {dc2::script::AdaptRunArguments<_SND_INIT_PORT>,                 EVENT_EXT_SND_INIT_PORT                },
    {dc2::script::AdaptRunArguments<_SND_LOAD_SOUND>,                EVENT_EXT_SND_LOAD_SOUND               },
    {dc2::script::AdaptRunArguments<_SND_SE_PLAY>,                   EVENT_EXT_SND_SE_PLAY                  },
    {dc2::script::AdaptRunArguments<_GET_SND_ID>,                    EVENT_EXT_GET_SND_ID                   },
    {dc2::script::AdaptRunArguments<_SND_SE_PAUSE>,                  EVENT_EXT_SND_SE_PAUSE                 },
    {dc2::script::AdaptRunArguments<_SND_SE_STOP>,                   EVENT_EXT_SND_SE_STOP                  },
    {dc2::script::AdaptRunArguments<_SND_SET_SE_VOL>,                EVENT_EXT_SND_SET_SE_VOL               },
    {dc2::script::AdaptRunArguments<_SND_SET_SE_PAN>,                EVENT_EXT_SND_SET_SE_PAN               },
    {dc2::script::AdaptRunArguments<_SND_SET_SE_PITCH>,              EVENT_EXT_SND_SET_SE_PITCH             },
    {dc2::script::AdaptRunArguments<_SND_SE_ALL_STOP>,               EVENT_EXT_SND_SE_ALL_STOP              },
    {dc2::script::AdaptRunArguments<_LOAD_BGM>,                      EVENT_EXT_LOAD_BGM                     },
    {dc2::script::AdaptRunArguments<_PLAY_BGM>,                      EVENT_EXT_PLAY_BGM                     },
    {dc2::script::AdaptRunArguments<_STOP_BGM>,                      EVENT_EXT_STOP_BGM                     },
    {dc2::script::AdaptRunArguments<_STREAM_OPEN>,                   EVENT_EXT_STREAM_OPEN                  },
    {dc2::script::AdaptRunArguments<_STREAM_PLAY>,                   EVENT_EXT_STREAM_PLAY                  },
    {dc2::script::AdaptRunArguments<_STREAM_STOP>,                   EVENT_EXT_STREAM_STOP                  },
    {dc2::script::AdaptRunArguments<_STREAM_STANDBY>,                EVENT_EXT_STREAM_STANDBY               },
    {dc2::script::AdaptRunArguments<_STREAM_GET_STATUS>,             EVENT_EXT_STREAM_GET_STATUS            },
    {dc2::script::AdaptRunArguments<_GET_SYS_SND_ID>,                EVENT_EXT_GET_SYS_SND_ID               },
    {dc2::script::AdaptRunArguments<_STREAM_OPEN_CHECK>,             EVENT_EXT_STREAM_OPEN_CHECK            },
    {dc2::script::AdaptRunArguments<_LOAD_SE_ENV>,                   EVENT_EXT_LOAD_SE_ENV                  },
    {dc2::script::AdaptRunArguments<_PLAY_ENV_BGM>,                  EVENT_EXT_PLAY_ENV_BGM                 },
    {dc2::script::AdaptRunArguments<_SYS_SE_PLAY>,                   EVENT_EXT_SYS_SE_PLAY                  },
    {dc2::script::AdaptRunArguments<_INIT_SE_SRC>,                   EVENT_EXT_INIT_SE_SRC                  },
    {dc2::script::AdaptRunArguments<_INIT_SE_ENV>,                   EVENT_EXT_INIT_SE_ENV                  },
    {dc2::script::AdaptRunArguments<_INIT_SE_BAS>,                   EVENT_EXT_INIT_SE_BAS                  },
    {dc2::script::AdaptRunArguments<_LOAD_SE_SRC>,                   EVENT_EXT_LOAD_SE_SRC                  },
    {dc2::script::AdaptRunArguments<_LOAD_SE_FOOT>,                  EVENT_EXT_LOAD_SE_FOOT                 },
    {dc2::script::AdaptRunArguments<_LOAD_SE_DOOR>,                  EVENT_EXT_LOAD_SE_DOOR                 },
    {dc2::script::AdaptRunArguments<_LOAD_SE_BOX>,                   EVENT_EXT_LOAD_SE_BOX                  },
    {dc2::script::AdaptRunArguments<_LOAD_SE_BATTLE>,                EVENT_EXT_LOAD_SE_BATTLE               },
    {dc2::script::AdaptRunArguments<_SND_DELETE_PORT>,               EVENT_EXT_SND_DELETE_PORT              },
    {dc2::script::AdaptRunArguments<_STOP_ENV_BGM>,                  EVENT_EXT_STOP_ENV_BGM                 },
    {dc2::script::AdaptRunArguments<_FADE_IN_BGM>,                   EVENT_EXT_FADE_IN_BGM                  },
    {dc2::script::AdaptRunArguments<_FADE_OUT_BGM>,                  EVENT_EXT_FADE_OUT_BGM                 },
    {dc2::script::AdaptRunArguments<_SET_BGM_VOL>,                   EVENT_EXT_SET_BGM_VOL                  },
    {dc2::script::AdaptRunArguments<_SND_SET_REVERB>,                EVENT_EXT_SND_SET_REVERB               },
    {dc2::script::AdaptRunArguments<_SND_SET_ENV_VOL>,               EVENT_EXT_SND_SET_ENV_VOL              },
    {dc2::script::AdaptRunArguments<_STREAM_SILENT_CHECK>,           EVENT_EXT_STREAM_SILENT_CHECK          },
    {dc2::script::AdaptRunArguments<_AUTO_CHANGE_ENV>,               EVENT_EXT_AUTO_CHANGE_ENV              },
    {dc2::script::AdaptRunArguments<_BGM_LOAD_CANCEL>,               EVENT_EXT_BGM_LOAD_CANCEL              },
    {dc2::script::AdaptRunArguments<_SOUND_LOAD_CANCEL>,             EVENT_EXT_SOUND_LOAD_CANCEL            },
    {dc2::script::AdaptRunArguments<_BGM_LOAD_ENABLE>,               EVENT_EXT_BGM_LOAD_ENABLE              },
    {dc2::script::AdaptRunArguments<_SOUND_LOAD_ENABLE>,             EVENT_EXT_SOUND_LOAD_ENABLE            },
    {dc2::script::AdaptRunArguments<_LOAD_SE_BASE>,                  EVENT_EXT_LOAD_SE_BASE                 },
    {dc2::script::AdaptRunArguments<_LOAD_SOUND>,                    EVENT_EXT_LOAD_SOUND                   },
    {dc2::script::AdaptRunArguments<_STREAM_CLOSE>,                  EVENT_EXT_STREAM_CLOSE                 },
    {dc2::script::AdaptRunArguments<_STREAM_OPEN2>,                  EVENT_EXT_STREAM_OPEN2                 },
    {dc2::script::AdaptRunArguments<_LOAD_BGM_PACK>,                 EVENT_EXT_LOAD_BGM_PACK                },
    {dc2::script::AdaptRunArguments<_GET_BGM_NO>,                    EVENT_EXT_GET_BGM_NO                   },
    {dc2::script::AdaptRunArguments<_GET_MASTER_VOL>,                EVENT_EXT_GET_MASTER_VOL               },
    {dc2::script::AdaptRunArguments<_SET_MASTER_VOL>,                EVENT_EXT_SET_MASTER_VOL               },
    {dc2::script::AdaptRunArguments<_GET_BTL_BGM_VOL>,               EVENT_EXT_GET_BTL_BGM_VOL              },
    {dc2::script::AdaptRunArguments<_SET_BTL_BGM_VOL>,               EVENT_EXT_SET_BTL_BGM_VOL              },
    {dc2::script::AdaptRunArguments<_SND_IN_REVERB>,                 EVENT_EXT_SND_IN_REVERB                },
    {dc2::script::AdaptRunArguments<_SND_STOP_SRC>,                  EVENT_EXT_SND_STOP_SRC                 },
    {dc2::script::AdaptRunArguments<_SND_PAUSE_BGM>,                 EVENT_EXT_SND_PAUSE_BGM                },
    {dc2::script::AdaptRunArguments<_STREAM_OPEN3>,                  EVENT_EXT_STREAM_OPEN3                 },
    {dc2::script::AdaptRunArguments<_GET_ACTIVE_BGM_STATUS>,         EVENT_EXT_GET_ACTIVE_BGM_STATUS        },
    {dc2::script::AdaptRunArguments<_SET_ACTIVE_BGM_STATUS>,         EVENT_EXT_SET_ACTIVE_BGM_STATUS        },
    {dc2::script::AdaptRunArguments<_GET_BGM_STATUS_NOW_NO>,         EVENT_EXT_GET_BGM_STATUS_NOW_NO        },
    {dc2::script::AdaptRunArguments<_GET_SE_STATUS>,                 EVENT_EXT_GET_SE_STATUS                },
    {dc2::script::AdaptRunArguments<_SE_ALL_STOP>,                   EVENT_EXT_SE_ALL_STOP                  },
    {dc2::script::AdaptRunArguments<_SOUND_ALL_STOP>,                EVENT_EXT_SOUND_ALL_STOP               },
    {dc2::script::AdaptRunArguments<_BGM_PLAY_CANCEL>,               EVENT_EXT_BGM_PLAY_CANCEL              },
    {dc2::script::AdaptRunArguments<_BGM_PLAY_ENABLE>,               EVENT_EXT_BGM_PLAY_ENABLE              },
    {dc2::script::AdaptRunArguments<_GET_DEF_BGM_NO>,                EVENT_EXT_GET_DEF_BGM_NO               },
    {dc2::script::AdaptRunArguments<_SET_MOVIE_CC>,                  EVENT_EXT_SET_MOVIE_CC                 },
    {dc2::script::AdaptRunArguments<_REGISTER_VILLAGER2>,            EVENT_EXT_REGISTER_VILLAGER2           },
    {dc2::script::AdaptRunArguments<_SET_FISHINGTOURNAMENT_ETC>,     EVENT_EXT_SET_FISHINGTOURNAMENT_ETC    },
    {dc2::script::AdaptRunArguments<_EOH_SYNC_CHARA>,                EVENT_EXT_EOH_SYNC_CHARA               },
    {dc2::script::AdaptRunArguments<_EOH_SYNC_OBJ>,                  EVENT_EXT_EOH_SYNC_OBJ                 },
    {dc2::script::AdaptRunArguments<_EOH_SET_POS>,                   EVENT_EXT_EOH_SET_POS                  },
    {dc2::script::AdaptRunArguments<_EOH_SET_ROT>,                   EVENT_EXT_EOH_SET_ROT                  },
    {dc2::script::AdaptRunArguments<_EOH_GET_POS>,                   EVENT_EXT_EOH_GET_POS                  },
    {dc2::script::AdaptRunArguments<_EOH_GET_ROT>,                   EVENT_EXT_EOH_GET_ROT                  },
    {dc2::script::AdaptRunArguments<_EOH_SET_MOTION>,                EVENT_EXT_EOH_SET_MOTION               },
    {dc2::script::AdaptRunArguments<_EOH_SET_STEP>,                  EVENT_EXT_EOH_SET_STEP                 },
    {dc2::script::AdaptRunArguments<_EOH_SET_TEX_ANIM>,              EVENT_EXT_EOH_SET_TEX_ANIM             },
    {dc2::script::AdaptRunArguments<_EOH_SET_SCALE>,                 EVENT_EXT_EOH_SET_SCALE                },
    {dc2::script::AdaptRunArguments<_EOH_SET_SHOW>,                  EVENT_EXT_EOH_SET_SHOW                 },
    {dc2::script::AdaptRunArguments<_EOH_GET_SHOW>,                  EVENT_EXT_EOH_GET_SHOW                 },
    {dc2::script::AdaptRunArguments<_EOH_SET_FRAME_SHOW>,            EVENT_EXT_EOH_SET_FRAME_SHOW           },
    {dc2::script::AdaptRunArguments<_EOH_SET_SHADOW>,                EVENT_EXT_EOH_SET_SHADOW               },
    {dc2::script::AdaptRunArguments<_EOH_SET_TRANSLATE>,             EVENT_EXT_EOH_SET_TRANSLATE            },
    {dc2::script::AdaptRunArguments<_EOH_SYNC_SPRITE>,               EVENT_EXT_EOH_SYNC_SPRITE              },
    {dc2::script::AdaptRunArguments<_EOH_SET_FOOT_SOUND_ID>,         EVENT_EXT_EOH_SET_FOOT_SOUND_ID        },
    {dc2::script::AdaptRunArguments<_EOH_SET_FRAME_STATUS>,          EVENT_EXT_EOH_SET_FRAME_STATUS         },
    {dc2::script::AdaptRunArguments<_EOH_GET_FRAME_POS>,             EVENT_EXT_EOH_GET_FRAME_POS            },
    {dc2::script::AdaptRunArguments<_EOH_SET_SOUND_ID>,              EVENT_EXT_EOH_SET_SOUND_ID             },
    {dc2::script::AdaptRunArguments<_EOH_GET_FRAME_STATUS>,          EVENT_EXT_EOH_GET_FRAME_STATUS         },
    {dc2::script::AdaptRunArguments<_EOH_SYNC_CHROBJ>,               EVENT_EXT_EOH_SYNC_CHROBJ              },
    {dc2::script::AdaptRunArguments<_EOH_SET_FADE_FLAG>,             EVENT_EXT_EOH_SET_FADE_FLAG            },
    {dc2::script::AdaptRunArguments<_EOH_RESET_DA_POSITION>,         EVENT_EXT_EOH_RESET_DA_POSITION        },
    {dc2::script::AdaptRunArguments<_EOH_SET_SHADOW_FRAME_STATUS>,   EVENT_EXT_EOH_SET_SHADOW_FRAME_STATUS  },
    {dc2::script::AdaptRunArguments<_EOH_SYNC_GEOSTONE>,             EVENT_EXT_EOH_SYNC_GEOSTONE            },
    {dc2::script::AdaptRunArguments<_EOH_SYNC_SEARCH_CHARA>,         EVENT_EXT_EOH_SYNC_SEARCH_CHARA        },
    {dc2::script::AdaptRunArguments<_EOH_NORMAL_DRIVE>,              EVENT_EXT_EOH_NORMAL_DRIVE             },
    {dc2::script::AdaptRunArguments<_EOH_SYNC_EDIT_OBJ>,             EVENT_EXT_EOH_SYNC_EDIT_OBJ            },
    {dc2::script::AdaptRunArguments<_EOH_SET_FRAME_ALPHA>,           EVENT_EXT_EOH_SET_FRAME_ALPHA          },
    {dc2::script::AdaptRunArguments<_EOH_SYNC_FUNCP>,                EVENT_EXT_EOH_SYNC_FUNCP               },
    {dc2::script::AdaptRunArguments<_EOH_SET_FOOT_SE_ID>,            EVENT_EXT_EOH_SET_FOOT_SE_ID           },
    {dc2::script::AdaptRunArguments<_EOH_SYNC_DOOR_PARTS>,           EVENT_EXT_EOH_SYNC_DOOR_PARTS          },
    {dc2::script::AdaptRunArguments<_SPHIDA_INIT>,                   EVENT_EXT_SPHIDA_INIT                  },
    {dc2::script::AdaptRunArguments<_SPHIDA_SET_UP>,                 EVENT_EXT_SPHIDA_SET_UP                },
    {dc2::script::AdaptRunArguments<_SPHIDA_SET_PLAY_FLAG>,          EVENT_EXT_SPHIDA_SET_PLAY_FLAG         },
    {dc2::script::AdaptRunArguments<_SPHIDA_SET_MINIMAP_FLAG>,       EVENT_EXT_SPHIDA_SET_MINIMAP_FLAG      },
    {dc2::script::AdaptRunArguments<_SPHIDA_SET_MM_LINE_FLAG>,       EVENT_EXT_SPHIDA_SET_MM_LINE_FLAG      },
    {dc2::script::AdaptRunArguments<_SPHIDA_SET_MM_LINE_POS>,        EVENT_EXT_SPHIDA_SET_MM_LINE_POS       },
    {dc2::script::AdaptRunArguments<_SPHIDA_SET_PIN_POS>,            EVENT_EXT_SPHIDA_SET_PIN_POS           },
    {dc2::script::AdaptRunArguments<_SPHIDA_GET_PIN_POS>,            EVENT_EXT_SPHIDA_GET_PIN_POS           },
    {dc2::script::AdaptRunArguments<_SPHIDA_SET_BALL_POS>,           EVENT_EXT_SPHIDA_SET_BALL_POS          },
    {dc2::script::AdaptRunArguments<_SPHIDA_GET_BALL_POS>,           EVENT_EXT_SPHIDA_GET_BALL_POS          },
    {dc2::script::AdaptRunArguments<_SPHIDA_SET_PIN_COL>,            EVENT_EXT_SPHIDA_SET_PIN_COL           },
    {dc2::script::AdaptRunArguments<_SPHIDA_GET_PIN_COL>,            EVENT_EXT_SPHIDA_GET_PIN_COL           },
    {dc2::script::AdaptRunArguments<_SPHIDA_SET_BALL_COL>,           EVENT_EXT_SPHIDA_SET_BALL_COL          },
    {dc2::script::AdaptRunArguments<_SPHIDA_GET_BALL_COL>,           EVENT_EXT_SPHIDA_GET_BALL_COL          },
    {dc2::script::AdaptRunArguments<_SPHIDA_SET_PAR_COUNT>,          EVENT_EXT_SPHIDA_SET_PAR_COUNT         },
    {dc2::script::AdaptRunArguments<_SPHIDA_GET_PAR_COUNT>,          EVENT_EXT_SPHIDA_GET_PAR_COUNT         },
    {dc2::script::AdaptRunArguments<_SPHIDA_GET_MINI_LEVEL>,         EVENT_EXT_SPHIDA_GET_MINI_LEVEL        },
    {dc2::script::AdaptRunArguments<_SPHIDA_GET_TEXB>,               EVENT_EXT_SPHIDA_GET_TEXB              },
    {dc2::script::AdaptRunArguments<_SPHIDA_SET_STATUS_FLAG>,        EVENT_EXT_SPHIDA_SET_STATUS_FLAG       },
    {dc2::script::AdaptRunArguments<_SPHIDA_RESET_POWGAGE>,          EVENT_EXT_SPHIDA_RESET_POWGAGE         },
    {dc2::script::AdaptRunArguments<_SPHIDA_START_POWGAGE>,          EVENT_EXT_SPHIDA_START_POWGAGE         },
    {dc2::script::AdaptRunArguments<_SPHIDA_TRIGGER_POWGAGE>,        EVENT_EXT_SPHIDA_TRIGGER_POWGAGE       },
    {dc2::script::AdaptRunArguments<_SPHIDA_GET_SHOT_POW>,           EVENT_EXT_SPHIDA_GET_SHOT_POW          },
    {dc2::script::AdaptRunArguments<_SPHIDA_GET_POWGAGE_CODE>,       EVENT_EXT_SPHIDA_GET_POWGAGE_CODE      },
    {dc2::script::AdaptRunArguments<_SPHIDA_SET_POWGAGE_SAFE_LEVEL>, EVENT_EXT_SPHIDA_SET_POWGAGE_SAFE_LEVEL},
    {dc2::script::AdaptRunArguments<_SPHIDA_GET_CULB_DEF>,           EVENT_EXT_SPHIDA_GET_CULB_DEF          },
    {dc2::script::AdaptRunArguments<_SPHIDA_SET_SPIN_MARK_POS>,      EVENT_EXT_SPHIDA_SET_SPIN_MARK_POS     },
    {dc2::script::AdaptRunArguments<_SPHIDA_SET_CULB_NO>,            EVENT_EXT_SPHIDA_SET_CULB_NO           },
    {dc2::script::AdaptRunArguments<_SPHIDA_CALC_CARRY>,             EVENT_EXT_SPHIDA_CALC_CARRY            },
    {dc2::script::AdaptRunArguments<_SPHIDA_GET_PG_CURSOR_POS>,      EVENT_EXT_SPHIDA_GET_PG_CURSOR_POS     },
    {dc2::script::AdaptRunArguments<_SPHIDA_SET_COL_MODEL>,          EVENT_EXT_SPHIDA_SET_COL_MODEL         },
    {dc2::script::AdaptRunArguments<_SPHIDA_GET_PRIZE>,              EVENT_EXT_SPHIDA_GET_PRIZE             },
    {dc2::script::AdaptRunArguments<_SPHIDA_SET_LAST_CHALLENGE>,     EVENT_EXT_SPHIDA_SET_LAST_CHALLENGE    },
    {dc2::script::AdaptRunArguments<_SPHIDA_GET_LAST_CHALLENGE>,     EVENT_EXT_SPHIDA_GET_LAST_CHALLENGE    },
    {dc2::script::AdaptRunArguments<_SPHIDA_GET_OMAKE_MODE>,         EVENT_EXT_SPHIDA_GET_OMAKE_MODE        },
    {dc2::script::AdaptRunArguments<_SPHIDA_SET_NOW_HOLE>,           EVENT_EXT_SPHIDA_SET_NOW_HOLE          },
    {dc2::script::AdaptRunArguments<_SPHIDA_GET_NOW_HOLE>,           EVENT_EXT_SPHIDA_GET_NOW_HOLE          },
    {dc2::script::AdaptRunArguments<_SPHIDA_SET_SCORE>,              EVENT_EXT_SPHIDA_SET_SCORE             },
    {dc2::script::AdaptRunArguments<_SPHIDA_GET_SCORE>,              EVENT_EXT_SPHIDA_GET_SCORE             },
    {dc2::script::AdaptRunArguments<_ZERO_VECTOR>,                   EVENT_EXT_ZERO_VECTOR                  },
    {dc2::script::AdaptRunArguments<_NORMAL_VECTOR>,                 EVENT_EXT_NORMAL_VECTOR                },
    {dc2::script::AdaptRunArguments<_COPY_VECTOR>,                   EVENT_EXT_COPY_VECTOR                  },
    {dc2::script::AdaptRunArguments<_ADD_VECTOR>,                    EVENT_EXT_ADD_VECTOR                   },
    {dc2::script::AdaptRunArguments<_SUB_VECTOR>,                    EVENT_EXT_SUB_VECTOR                   },
    {dc2::script::AdaptRunArguments<_SCALE_VECTOR>,                  EVENT_EXT_SCALE_VECTOR                 },
    {dc2::script::AdaptRunArguments<_DIV_VECTOR>,                    EVENT_EXT_DIV_VECTOR                   },
    {dc2::script::AdaptRunArguments<_DIST_VECTOR>,                   EVENT_EXT_DIST_VECTOR                  },
    {dc2::script::AdaptRunArguments<_DIST_VECTOR2>,                  EVENT_EXT_DIST_VECTOR2                 },
    {dc2::script::AdaptRunArguments<_SQRT>,                          EVENT_EXT_SQRT                         },
    {dc2::script::AdaptRunArguments<_ATAN2F>,                        EVENT_EXT_ATAN2F                       },
    {dc2::script::AdaptRunArguments<_ANGLE_CMP>,                     EVENT_EXT_ANGLE_CMP                    },
    {dc2::script::AdaptRunArguments<_ANGLE_LIMIT>,                   EVENT_EXT_ANGLE_LIMIT                  },
    {dc2::script::AdaptRunArguments<_GET_RAND>,                      EVENT_EXT_GET_RAND                     },
    {dc2::script::AdaptRunArguments<_LINE_POINT_DIST>,               EVENT_EXT_LINE_POINT_DIST              },
    {dc2::script::AdaptRunArguments<_CREATE_SWORD_EFFECT>,           EVENT_EXT_CREATE_SWORD_EFFECT          },
    {dc2::script::AdaptRunArguments<_DELETE_SWORD_EFFECT>,           EVENT_EXT_DELETE_SWORD_EFFECT          },
    {dc2::script::AdaptRunArguments<_SWORD_EFFECT_COLOR>,            EVENT_EXT_SWORD_EFFECT_COLOR           },
    {dc2::script::AdaptRunArguments<_SWORD_EFFECT_ADD_POINT>,        EVENT_EXT_SWORD_EFFECT_ADD_POINT       },
    {dc2::script::AdaptRunArguments<_ADD_CHARA_POS>,                 EVENT_EXT_ADD_CHARA_POS                },
    {dc2::script::AdaptRunArguments<_ADD_CHARA_ROT>,                 EVENT_EXT_ADD_CHARA_ROT                },
    {dc2::script::AdaptRunArguments<_POST_TREASURE_BOX>,             EVENT_EXT_POST_TREASURE_BOX            },
    {dc2::script::AdaptRunArguments<_GET_PARTS_ORIGIN>,              EVENT_EXT_GET_PARTS_ORIGIN             },
    {dc2::script::AdaptRunArguments<_CTRLC_STEP>,                    EVENT_EXT_CTRLC_STEP                   },
    {dc2::script::AdaptRunArguments<_CTRLC_SET_ROTATE>,              EVENT_EXT_CTRLC_SET_ROTATE             },
    {dc2::script::AdaptRunArguments<_CTRLC_MOVE_CAMERA>,             EVENT_EXT_CTRLC_MOVE_CAMERA            },
    {dc2::script::AdaptRunArguments<_CTRLC_SET_ROT_CANCEL>,          EVENT_EXT_CTRLC_SET_ROT_CANCEL         },
    {dc2::script::AdaptRunArguments<_CTRLC_MOVE_RANGE>,              EVENT_EXT_CTRLC_MOVE_RANGE             },
    {dc2::script::AdaptRunArguments<_GET_NEAR_TBOX_POS>,             EVENT_EXT_GET_NEAR_TBOX_POS            },
    {dc2::script::AdaptRunArguments<_CONV_CHRNO_S2L>,                EVENT_EXT_CONV_CHRNO_S2L               },
    {dc2::script::AdaptRunArguments<_SWE_INIT>,                      EVENT_EXT_SWE_INIT                     },
    {dc2::script::AdaptRunArguments<_SWE_SET_COLOR>,                 EVENT_EXT_SWE_SET_COLOR                },
    {dc2::script::AdaptRunArguments<_SWE_SET_TEXTURE>,               EVENT_EXT_SWE_SET_TEXTURE              },
    {dc2::script::AdaptRunArguments<_SWE_START_EFFECT>,              EVENT_EXT_SWE_START_EFFECT             },
    {dc2::script::AdaptRunArguments<_SET_CHARA_TYPE>,                EVENT_EXT_SET_CHARA_TYPE               },
    {dc2::script::AdaptRunArguments<_GET_EVENT_DATA>,                EVENT_EXT_GET_EVENT_DATA               },
    {dc2::script::AdaptRunArguments<_DNG_SET_PREV_FLOOR>,            EVENT_EXT_DNG_SET_PREV_FLOOR           },
    {dc2::script::AdaptRunArguments<_DNG_GET_PREV_FLOOR>,            EVENT_EXT_DNG_GET_PREV_FLOOR           },
    {dc2::script::AdaptRunArguments<_DNG_SET_FAST_FLOOR>,            EVENT_EXT_DNG_SET_FAST_FLOOR           },
    {dc2::script::AdaptRunArguments<_SET_FLOOR_INFO>,                EVENT_EXT_SET_FLOOR_INFO               },
    {dc2::script::AdaptRunArguments<_GET_FLOOR_INFO>,                EVENT_EXT_GET_FLOOR_INFO               },
    {dc2::script::AdaptRunArguments<_GET_NEXT_FLOOR>,                EVENT_EXT_GET_NEXT_FLOOR               },
    {dc2::script::AdaptRunArguments<_PAD_AUTO_REPEAT_OFF>,           EVENT_EXT_PAD_AUTO_REPEAT_OFF          },
    {dc2::script::AdaptRunArguments<_PAD_SET_AUTO_REPEAT>,           EVENT_EXT_PAD_SET_AUTO_REPEAT          },
    {dc2::script::AdaptRunArguments<_DNG_PAUSE>,                     EVENT_EXT_DNG_PAUSE                    },
    {dc2::script::AdaptRunArguments<_DNG_CHECK_PAUSE>,               EVENT_EXT_DNG_CHECK_PAUSE              },
    {dc2::script::AdaptRunArguments<_DNG_RESET_TIMER>,               EVENT_EXT_DNG_RESET_TIMER              },
    {dc2::script::AdaptRunArguments<_DNG_GET_TIMER>,                 EVENT_EXT_DNG_GET_TIMER                },
    {dc2::script::AdaptRunArguments<_LOAD_SKIN>,                     EVENT_EXT_LOAD_SKIN                    },
    {dc2::script::AdaptRunArguments<_CHK_CAMERA_COL>,                EVENT_EXT_CHK_CAMERA_COL               },
    {dc2::script::AdaptRunArguments<_GET_PARTS_FUNC_POS>,            EVENT_EXT_GET_PARTS_FUNC_POS           },
    {dc2::script::AdaptRunArguments<_RANDOM_CIRCLE_GET_POS>,         EVENT_EXT_RANDOM_CIRCLE_GET_POS        },
    {dc2::script::AdaptRunArguments<_RANDOM_CIRCLE_OFF>,             EVENT_EXT_RANDOM_CIRCLE_OFF            },
    {dc2::script::AdaptRunArguments<_DNG_XCHG_MAP_LIGHT>,            EVENT_EXT_DNG_XCHG_MAP_LIGHT           },
    {dc2::script::AdaptRunArguments<_GEOSTONE_ANIME_OFF>,            EVENT_EXT_GEOSTONE_ANIME_OFF           },
    {dc2::script::AdaptRunArguments<_GEOSTONE_SET_FLAG>,             EVENT_EXT_GEOSTONE_SET_FLAG            },
    {dc2::script::AdaptRunArguments<_GEOSTONE_SET_REFERENCE>,        EVENT_EXT_GEOSTONE_SET_REFERENCE       },
    {dc2::script::AdaptRunArguments<_GEOSTONE_DEL_REFERENCE>,        EVENT_EXT_GEOSTONE_DEL_REFERENCE       },
    {dc2::script::AdaptRunArguments<_GET_ROBO_MOVE_TYPE>,            EVENT_EXT_GET_ROBO_MOVE_TYPE           },
    {dc2::script::AdaptRunArguments<_SET_EXIT_FLAG>,                 EVENT_EXT_SET_EXIT_FLAG                },
    {dc2::script::AdaptRunArguments<_GET_EXIT_FLAG>,                 EVENT_EXT_GET_EXIT_FLAG                },
    {dc2::script::AdaptRunArguments<_GET_E3_VERSION>,                EVENT_EXT_GET_E3_VERSION               },
    {dc2::script::AdaptRunArguments<_CHK_PAD_CTRL>,                  EVENT_EXT_CHK_PAD_CTRL                 },
    {dc2::script::AdaptRunArguments<_CTRLC_STAY>,                    EVENT_EXT_CTRLC_STAY                   },
    {dc2::script::AdaptRunArguments<_BSCN_SET_BLIGHT_RATE>,          EVENT_EXT_BSCN_SET_BLIGHT_RATE         },
    {dc2::script::AdaptRunArguments<_GET_RND_CIRCLE_TRAPID>,         EVENT_EXT_GET_RND_CIRCLE_TRAPID        },
    {dc2::script::AdaptRunArguments<_SET_RND_CIRCLE_STATUS>,         EVENT_EXT_SET_RND_CIRCLE_STATUS        },
    {dc2::script::AdaptRunArguments<_SET_STATUSBAR_SHOW>,            EVENT_EXT_SET_STATUSBAR_SHOW           },
    {dc2::script::AdaptRunArguments<_SET_PULL_ITEM>,                 EVENT_EXT_SET_PULL_ITEM                },
    {dc2::script::AdaptRunArguments<_MENU_CHARA_CHENGE>,             EVENT_EXT_MENU_CHARA_CHENGE            },
    {dc2::script::AdaptRunArguments<_GET_EVENT_INFO_SNDID>,          EVENT_EXT_GET_EVENT_INFO_SNDID         },
    {dc2::script::AdaptRunArguments<_GET_PARTS_POS>,                 EVENT_EXT_GET_PARTS_POS                },
    {dc2::script::AdaptRunArguments<_CANCEL_DRAMA_SCENE>,            EVENT_EXT_CANCEL_DRAMA_SCENE           },
    {dc2::script::AdaptRunArguments<_GET_RNDC_MOT_NOWT>,             EVENT_EXT_GET_RNDC_MOT_NOWT            },
    {dc2::script::AdaptRunArguments<_SET_CHARA_MOT_NOWT>,            EVENT_EXT_SET_CHARA_MOT_NOWT           },
    {dc2::script::AdaptRunArguments<_CHARA_NORMAL_DRIVE>,            EVENT_EXT_CHARA_NORMAL_DRIVE           },
    {dc2::script::AdaptRunArguments<_CHARA_RESET_DA>,                EVENT_EXT_CHARA_RESET_DA               },
    {dc2::script::AdaptRunArguments<_DNG_SETUP_MAIN_UNIT>,           EVENT_EXT_DNG_SETUP_MAIN_UNIT          },
    {dc2::script::AdaptRunArguments<_JOIN_PARTY_MEMBER>,             EVENT_EXT_JOIN_PARTY_MEMBER            },
    {dc2::script::AdaptRunArguments<_SET_CHARA_CHANGE_FLAG>,         EVENT_EXT_SET_CHARA_CHANGE_FLAG        },
    {dc2::script::AdaptRunArguments<_SET_CHARA_CHANGE_MASK>,         EVENT_EXT_SET_CHARA_CHANGE_MASK        },
    {dc2::script::AdaptRunArguments<_CHANGE_DIR>,                    EVENT_EXT_CHANGE_DIR                   },
    {dc2::script::AdaptRunArguments<_SUB_ITEM>,                      EVENT_EXT_SUB_ITEM                     },
    {dc2::script::AdaptRunArguments<_SET_CHARA_EQUIP>,               EVENT_EXT_SET_CHARA_EQUIP              },
    {dc2::script::AdaptRunArguments<_LOAD_PACK_FILE>,                EVENT_EXT_LOAD_PACK_FILE               },
    {dc2::script::AdaptRunArguments<_SET_BIT_CTRL>,                  EVENT_EXT_SET_BIT_CTRL                 },
    {dc2::script::AdaptRunArguments<_GET_BIT_CTRL>,                  EVENT_EXT_GET_BIT_CTRL                 },
    {dc2::script::AdaptRunArguments<_LOAD_ARG>,                      EVENT_EXT_LOAD_ARG                     },
    {dc2::script::AdaptRunArguments<_GET_ITEM_HAVE_NUM>,             EVENT_EXT_GET_ITEM_HAVE_NUM            },
    {dc2::script::AdaptRunArguments<_SET_SKIP_BOTTON>,               EVENT_EXT_SET_SKIP_BOTTON              },
    {dc2::script::AdaptRunArguments<_SET_SKIP_FCOL>,                 EVENT_EXT_SET_SKIP_FCOL                },
    {dc2::script::AdaptRunArguments<_GET_DEBUG_MODE>,                EVENT_EXT_GET_DEBUG_MODE               },
    {dc2::script::AdaptRunArguments<_GET_MAP_TYPE>,                  EVENT_EXT_GET_MAP_TYPE                 },
    {dc2::script::AdaptRunArguments<_DNG_COLLISION_ALL_CLR>,         EVENT_EXT_DNG_COLLISION_ALL_CLR        },
    {dc2::script::AdaptRunArguments<_SET_MAP_DRAW>,                  EVENT_EXT_SET_MAP_DRAW                 },
    {dc2::script::AdaptRunArguments<_CHECK_MC_LOAD>,                 EVENT_EXT_CHECK_MC_LOAD                },
    {dc2::script::AdaptRunArguments<_SET_NOW_MAP_NO>,                EVENT_EXT_SET_NOW_MAP_NO               },
    {dc2::script::AdaptRunArguments<_GET_TBOX_PARAM>,                EVENT_EXT_GET_TBOX_PARAM               },
    {dc2::script::AdaptRunArguments<_CANCEL_LOAD_VILLAGER>,          EVENT_EXT_CANCEL_LOAD_VILLAGER         },
    {dc2::script::AdaptRunArguments<_CANCEL_NOW_LOADING>,            EVENT_EXT_CANCEL_NOW_LOADING           },
    {dc2::script::AdaptRunArguments<_ESM_INITIALIZE>,                EVENT_EXT_ESM_INITIALIZE               },
    {dc2::script::AdaptRunArguments<_ESM_INIT_FIX>,                  EVENT_EXT_ESM_INIT_FIX                 },
    {dc2::script::AdaptRunArguments<_ESM_CLEAR>,                     EVENT_EXT_ESM_CLEAR                    },
    {dc2::script::AdaptRunArguments<_ESM_LOAD_BASE>,                 EVENT_EXT_ESM_LOAD_BASE                },
    {dc2::script::AdaptRunArguments<_ESM_CREATE>,                    EVENT_EXT_ESM_CREATE                   },
    {dc2::script::AdaptRunArguments<_ESM_FINISH>,                    EVENT_EXT_ESM_FINISH                   },
    {dc2::script::AdaptRunArguments<_ESM_DELETE>,                    EVENT_EXT_ESM_DELETE                   },
    {dc2::script::AdaptRunArguments<_ESM_SET_VECT1>,                 EVENT_EXT_ESM_SET_VECT1                },
    {dc2::script::AdaptRunArguments<_ESM_SET_VECT2>,                 EVENT_EXT_ESM_SET_VECT2                },
    {dc2::script::AdaptRunArguments<_ESM_SET_TARGET_ID>,             EVENT_EXT_ESM_SET_TARGET_ID            },
    {dc2::script::AdaptRunArguments<_ESM_LOAD_BASE_PACK>,            EVENT_EXT_ESM_LOAD_BASE_PACK           },
    {dc2::script::AdaptRunArguments<_ESM_SET_VALUE>,                 EVENT_EXT_ESM_SET_VALUE                },
    {dc2::script::AdaptRunArguments<_SET_CHARA_CONDITION>,           EVENT_EXT_SET_CHARA_CONDITION          },
    {dc2::script::AdaptRunArguments<_ADD_WHP>,                       EVENT_EXT_ADD_WHP                      },
    {dc2::script::AdaptRunArguments<_ADD_HP_RATE>,                   EVENT_EXT_ADD_HP_RATE                  },
    {dc2::script::AdaptRunArguments<_GET_TIME>,                      EVENT_EXT_GET_TIME                     },
    {dc2::script::AdaptRunArguments<_CHECK_GET_ITEM_LIMIT>,          EVENT_EXT_CHECK_GET_ITEM_LIMIT         },
    {dc2::script::AdaptRunArguments<_CHECK_ITEM_OVER>,               EVENT_EXT_CHECK_ITEM_OVER              },
    {dc2::script::AdaptRunArguments<_GET_NOW_LOOP_NO>,               EVENT_EXT_GET_NOW_LOOP_NO              },
    {dc2::script::AdaptRunArguments<_IS_CLEAR_DESTROY>,              EVENT_EXT_IS_CLEAR_DESTROY             },
    {dc2::script::AdaptRunArguments<_IS_CLEAR_PRACTICE>,             EVENT_EXT_IS_CLEAR_PRACTICE            },
    {dc2::script::AdaptRunArguments<_IS_PLAY_SUB_GAME>,              EVENT_EXT_IS_PLAY_SUB_GAME             },
    {dc2::script::AdaptRunArguments<_RESET_SUBJECT_COUNTER>,         EVENT_EXT_RESET_SUBJECT_COUNTER        },
    {dc2::script::AdaptRunArguments<_SCR_EFF_INIT_RASTER>,           EVENT_EXT_SCR_EFF_INIT_RASTER          },
    {dc2::script::AdaptRunArguments<_SCR_EFF_START_RASTER>,          EVENT_EXT_SCR_EFF_START_RASTER         },
    {dc2::script::AdaptRunArguments<_SCR_EFF_STOP_RASTER>,           EVENT_EXT_SCR_EFF_STOP_RASTER          },
    {dc2::script::AdaptRunArguments<_SET_MPCHARA_MOTION>,            EVENT_EXT_SET_MPCHARA_MOTION           },
    {dc2::script::AdaptRunArguments<_FUNC_POINT_POS>,                EVENT_EXT_FUNC_POINT_POS               },
    {dc2::script::AdaptRunArguments<_CTRLC_ROT_BACK>,                EVENT_EXT_CTRLC_ROT_BACK               },
    {dc2::script::AdaptRunArguments<_PARTS_NAME_STRCMP>,             EVENT_EXT_PARTS_NAME_STRCMP            },
    {dc2::script::AdaptRunArguments<_GET_TRIAL_VERSION>,             EVENT_EXT_GET_TRIAL_VERSION            },
    {dc2::script::AdaptRunArguments<_SET_FLOOR_EPISODE>,             EVENT_EXT_SET_FLOOR_EPISODE            },
    {dc2::script::AdaptRunArguments<_FUNC_POINT_GET_POS>,            EVENT_EXT_FUNC_POINT_GET_POS           },
    {dc2::script::AdaptRunArguments<_FUNC_POINT_GET_ROT>,            EVENT_EXT_FUNC_POINT_GET_ROT           },
    {dc2::script::AdaptRunArguments<_ACTCHR_SET_DEF_MOTION>,         EVENT_EXT_ACTCHR_SET_DEF_MOTION        },
    {dc2::script::AdaptRunArguments<_ADD_FUSION_POINT>,              EVENT_EXT_ADD_FUSION_POINT             },
    {dc2::script::AdaptRunArguments<_GET_DEBUG_FLAG>,                EVENT_EXT_GET_DEBUG_FLAG               },
    {dc2::script::AdaptRunArguments<_MINIMAP_DOOR_ENABLE>,           EVENT_EXT_MINIMAP_DOOR_ENABLE          },
    {dc2::script::AdaptRunArguments<_DNG_CHECK_BOSS_MAP>,            EVENT_EXT_DNG_CHECK_BOSS_MAP           },
    {dc2::script::AdaptRunArguments<_DNG_RUN_EVENT>,                 EVENT_EXT_DNG_RUN_EVENT                },
    {dc2::script::AdaptRunArguments<_CHECK_ENABLE_CHARA_CHANGE>,     EVENT_EXT_CHECK_ENABLE_CHARA_CHANGE    },
    {dc2::script::AdaptRunArguments<_INIT_SEPIA>,                    EVENT_EXT_INIT_SEPIA                   },
    {dc2::script::AdaptRunArguments<_START_SEPIA>,                   EVENT_EXT_START_SEPIA                  },
    {dc2::script::AdaptRunArguments<_END_SEPIA>,                     EVENT_EXT_END_SEPIA                    },
    {dc2::script::AdaptRunArguments<_COPY_MONS2SCNCHR>,              EVENT_EXT_COPY_MONS2SCNCHR             },
    {dc2::script::AdaptRunArguments<_UNLOCK_STACK>,                  EVENT_EXT_UNLOCK_STACK                 },
    {dc2::script::AdaptRunArguments<_RESET_EVENT_TRG>,               EVENT_EXT_RESET_EVENT_TRG              },
    {dc2::script::AdaptRunArguments<_SET_CHARA_NO>,                  EVENT_EXT_SET_CHARA_NO                 },
    {dc2::script::AdaptRunArguments<_GET_CHARA_NO>,                  EVENT_EXT_GET_CHARA_NO                 },
    {dc2::script::AdaptRunArguments<_SEARCH_CHARA_NO>,               EVENT_EXT_SEARCH_CHARA_NO              },
    {dc2::script::AdaptRunArguments<_GET_NEAR_RANDOM_STONE_POS>,     EVENT_EXT_GET_NEAR_RANDOM_STONE_POS    },
    {dc2::script::AdaptRunArguments<_INIT_MONO_FLASH>,               EVENT_EXT_INIT_MONO_FLASH              },
    {dc2::script::AdaptRunArguments<_START_MONO_FLASH>,              EVENT_EXT_START_MONO_FLASH             },
    {dc2::script::AdaptRunArguments<_END_MONO_FLASH>,                EVENT_EXT_END_MONO_FLASH               },
    {dc2::script::AdaptRunArguments<_DELETE_VILLAGER>,               EVENT_EXT_DELETE_VILLAGER              },
    {dc2::script::AdaptRunArguments<_DNG_SET_WEATHER>,               EVENT_EXT_DNG_SET_WEATHER              },
    {dc2::script::AdaptRunArguments<_SET_CHARA_MAXHP>,               EVENT_EXT_SET_CHARA_MAXHP              },
    {dc2::script::AdaptRunArguments<_SET_CHARA_DEFENCE>,             EVENT_EXT_SET_CHARA_DEFENCE            },
    {dc2::script::AdaptRunArguments<_PLACE_PARTS_NAME_STRCMP>,       EVENT_EXT_PLACE_PARTS_NAME_STRCMP      },
    {dc2::script::AdaptRunArguments<_GOTO_USE_ITEM2>,                EVENT_EXT_GOTO_USE_ITEM2               },
    {dc2::script::AdaptRunArguments<_DBG_SET_ANALYZE_FLAG>,          EVENT_EXT_DBG_SET_ANALYZE_FLAG         },
    {dc2::script::AdaptRunArguments<_ATRAMIRIA_ON_OFF>,              EVENT_EXT_ATRAMIRIA_ON_OFF             },
    {dc2::script::AdaptRunArguments<_ADD_YARIKOMI_MEDAL>,            EVENT_EXT_ADD_YARIKOMI_MEDAL           },
    {dc2::script::AdaptRunArguments<_SET_MAP_EFFECT_ID>,             EVENT_EXT_SET_MAP_EFFECT_ID            },
    {dc2::script::AdaptRunArguments<_GET_MAP_EFFECT_ID>,             EVENT_EXT_GET_MAP_EFFECT_ID            },
    {dc2::script::AdaptRunArguments<_DNG_FLOOR_INIT>,                EVENT_EXT_DNG_FLOOR_INIT               },
    {dc2::script::AdaptRunArguments<_DNG_FLOOR_FINISH>,              EVENT_EXT_DNG_FLOOR_FINISH             },
    {dc2::script::AdaptRunArguments<_CLEAR_RND_STONE>,               EVENT_EXT_CLEAR_RND_STONE              },
    {dc2::script::AdaptRunArguments<_GET_FLOOR_STATUS>,              EVENT_EXT_GET_FLOOR_STATUS             },
    {dc2::script::AdaptRunArguments<_SET_FLOOR_STATUS>,              EVENT_EXT_SET_FLOOR_STATUS             },
    {dc2::script::AdaptRunArguments<_AMG_GET_ATTR_STATUS>,           EVENT_EXT_AMG_GET_ATTR_STATUS          },
    {dc2::script::AdaptRunArguments<_SET_NEAR_DIST>,                 EVENT_EXT_SET_NEAR_DIST                },
    {dc2::script::AdaptRunArguments<_SET_KEEP_TIME>,                 EVENT_EXT_SET_KEEP_TIME                },
    {dc2::script::AdaptRunArguments<_GET_KEEP_TIME>,                 EVENT_EXT_GET_KEEP_TIME                },
    {dc2::script::AdaptRunArguments<_GET_DOOR_PARTS_ID>,             EVENT_EXT_GET_DOOR_PARTS_ID            },
    {dc2::script::AdaptRunArguments<_CHECK_EQUEP_CHANGE>,            EVENT_EXT_CHECK_EQUEP_CHANGE           },
    {dc2::script::AdaptRunArguments<_ADD_HP_RATE2>,                  EVENT_EXT_ADD_HP_RATE2                 },
    {dc2::script::AdaptRunArguments<_DNG_EFFECT_ALL_CLEAR>,          EVENT_EXT_DNG_EFFECT_ALL_CLEAR         },
    {dc2::script::AdaptRunArguments<_AUTO_CHENGE_BGM_VOL>,           EVENT_EXT_AUTO_CHENGE_BGM_VOL          },
    {dc2::script::AdaptRunArguments<_UDATA_GET_WHP>,                 EVENT_EXT_UDATA_GET_WHP                },
    {dc2::script::AdaptRunArguments<_UDATA_ADD_WHP>,                 EVENT_EXT_UDATA_ADD_WHP                },
    {dc2::script::AdaptRunArguments<_UDATA_GET_ABS>,                 EVENT_EXT_UDATA_GET_ABS                },
    {dc2::script::AdaptRunArguments<_UDATA_ADD_ABS>,                 EVENT_EXT_UDATA_ADD_ABS                },
    {dc2::script::AdaptRunArguments<_DNG_CREATE_EFFECT>,             EVENT_EXT_DNG_CREATE_EFFECT            },
    {dc2::script::AdaptRunArguments<_LEAVE_MONICA_ITEM_CHECK>,       EVENT_EXT_LEAVE_MONICA_ITEM_CHECK      },
    {dc2::script::AdaptRunArguments<_PAUSE_ENABLE_FLAG>,             EVENT_EXT_PAUSE_ENABLE_FLAG            },
    {dc2::script::AdaptRunArguments<_FORCE_BOOT_TOUR>,               EVENT_EXT_FORCE_BOOT_TOUR              },
    {dc2::script::AdaptRunArguments<_MT_TEST>,                       EVENT_EXT_MT_TEST                      },
    {dc2::script::AdaptRunArguments<_TEST>,                          EVENT_EXT_TEST                         },
    {nullptr,                                                        EVENT_EXT_END                          },
};

void SetEventFunc(CRunScript *script) {
    int i = {};
    int j = {};

    for (i = 0; i < EVENT_EXT_FUNC_NUM; i++) {
        ext_func[i] = nullptr;
    }

    i = 0;

    for (;;) {
        if (ext_func_info[i].func == nullptr) {
            break;
        }

        for (j = 0; j < i; j++) {
            if (ext_func_info[i].no == ext_func_info[j].no) {
                dc2::log::PrintGame("same ext_func_no!!!\n");

                while (true) {
                }
            }
        }

        if (ext_func_info[i].no < 0 || ext_func_info[i].no >= EVENT_EXT_FUNC_NUM) {
            dc2::log::PrintGame("ext func over!!");
        } else {
            ext_func[ext_func_info[i].no] = ext_func_info[i].func;
        }

        i++;
    }

    script->ext_func(ext_func, EVENT_EXT_FUNC_NUM);
}

ED_EVENT_INFO EdEventInfo;

CEventScriptArg::CEventScriptArg() {
    next_id = 0;
    list = nullptr;
    list_num = 0;
    memory = nullptr;
}

inline CRaster::CRaster() {
    Initialize();
}

CScreenEffect::CScreenEffect() {
    Initialize();
}

CEohMother EventObjHandleMother;

CEventSpriteMother esMother;

u32 EventLocalFlag[EVENT_LOCAL_NUM];

int EventLocalCnt[EVENT_LOCAL_NUM];

CRain EventRain;

CMarker EventMarker;

int SetWorldCoordFlg;

int PakuAnimEohNo;

int PakuMotionEohNo;

int PakuMotionType;

int PakuMotionType2;

BattleEffectPrim Hit_para[EVENT_HIT_EFFECT_NUM][EVENT_HIT_PARTICLE_NUM];

CHitEffectImage HitEffect[EVENT_HIT_EFFECT_NUM];

char PakuAnimName[PAKU_NAME_SIZE];

char PakuAnimName2[PAKU_NAME_SIZE];

char PakuMotionName[PAKU_NAME_SIZE];

char PakuMotionName2[PAKU_NAME_SIZE];

mgCMemory BuffEventSnd;

mgCMemory BuffEventSnd2;

CDngFreeMap EventDngMap;

_SEN_CMR_SEQ cmr_seq_tbl[SEQ_NODE_NUM];

CSceneCmrSeq CameraSeq;

_SEN_OBJ_SEQ obj_seq_tbl[SEQ_NODE_NUM];

CSceneObjSeq ObjectSeq[EVENT_OBJECT_SEQ_NUM];

CEventSprite2 EventSprite2[EVENT_SPRITE2_NUM];

CEventScriptArg EventScriptArg;

CScreenEffect EventScreenEffect;

void CEventScriptArg::BuildBytecodeArgData(std::span<u8> program) {
    RS_STACKDATA             stack[EVENT_ARG_STACK_NUM];
    RS_CALLDATA              calls[EVENT_ARG_CALL_NUM];
    dc2::script::RunFunction func_table[EVENT_ARG_FUNC_NUM];
    int                      count = {};
    int                      i = {};
    int                      j = {};

    func_table[0] = nullptr;
    func_table[1] = nullptr;
    func_table[2] = nullptr;
    count = 0;
    i = 0;

    for (;;) {
        if (esa_ext_func_info[i].func == nullptr) {
            break;
        }

        for (j = 0; j < count; j++) {
            if (esa_ext_func_info[i].no == esa_ext_func_info[j].no) {
                dc2::log::PrintGame("EvectScriptArg same ext_func_no!!!\n");

                while (true) {
                }
            }
        }

        if (esa_ext_func_info[i].no < 0 || esa_ext_func_info[i].no >= EVENT_ARG_FUNC_NUM) {
            dc2::log::PrintGame("EvectScriptArg ext func over!!\n");
        } else {
            func_table[esa_ext_func_info[i].no] = esa_ext_func_info[i].func;
        }

        i++;
        count++;
    }

    nowScriptArg = this;
    CRunScript script;
    if (!script.load(program, std::span<RS_STACKDATA>(stack), std::span<RS_CALLDATA>(calls))) {
        nowScriptArg = nullptr;
        return;
    }
    script.ext_func(func_table, EVENT_ARG_FUNC_NUM);
    script.run(100);
    nowScriptArg = nullptr;
}

#include "common.h"

#include <nlohmann/json.hpp>

#include <cstdio>
#include <cstring>
#include <exception>
#include <map>
#include <new>
#include <string_view>
#include <variant>

#include "assets/data_registry.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "log/game_output.hpp"
#include "log/log.hpp"
#include "luau_runtime.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "platform/legacy_encoding.hpp"
#include "platform/model_assets.hpp"
#include "scene.hpp"

namespace {

/**
 * Appends an empty argument list using the event's next list identifier.
 */
ARG_LIST *AppendEventArgList(CEventScriptArg &script) {
    if (!PrepareEventArgLists(script)) {
        return nullptr;
    }
    auto *storage = AllocateEventStorage(script.memory, 3);
    auto *created = storage != nullptr ? new (storage) ARG_LIST : nullptr;
    if (created == nullptr) {
        return nullptr;
    }
    created->id = script.next_id++;
    created->args = nullptr;
    created->arg_num = 0;
    created->next = nullptr;
    if (script.list_num <= 0) {
        script.list = created;
        script.list_storage = dc2::memory::ArenaBuffer::Bind(*script.memory,
                                                             {reinterpret_cast<u8 *>(created), sizeof(*created)});
    } else {
        ARG_LIST *last = script.list;
        while (last->next != nullptr) {
            last = last->next;
        }
        last->next = created;
    }
    script.list_num++;
    return created;
}

/**
 * Allocates argument records from the event's memory arena.
 */
ARG_DATA *AllocateEventArgData(mgCMemory &memory, std::size_t count) {
    const auto words = dc2::memory::ArrayQuadwords<ARG_DATA>(count);
    if ((count != 0 && !words) || (words && *words > std::numeric_limits<int>::max() - 2)) {
        return nullptr;
    }
    auto *storage = AllocateEventStorage(&memory, static_cast<std::size_t>(words.value_or(0)) + 2);
    return storage != nullptr ? new (storage) ARG_DATA[count]{} : nullptr;
}

/**
 * Copies a converted argument string into the event's memory arena.
 */
char *CopyEventArgString(mgCMemory &memory, std::string_view source) {
    if (source.size() == std::numeric_limits<std::size_t>::max()) {
        return nullptr;
    }
    const std::size_t bytes = source.size() + 1;
    const auto        words = dc2::memory::ArrayQuadwords<char>(bytes);
    if (!words || *words > std::numeric_limits<int>::max() - 2) {
        return nullptr;
    }
    auto *storage = AllocateEventStorage(&memory, static_cast<std::size_t>(*words) + 2);
    if (storage == nullptr) {
        return nullptr;
    }
    auto *copy = new (storage) char[bytes];
    std::memcpy(copy, source.data(), source.size());
    copy[source.size()] = '\0';
    return copy;
}

/**
 * Outcome of applying one translated event argument command.
 */
enum class EventArgResult {
    Applied,       /**< The handler accepted the command. */
    Rejected,      /**< The arguments do not fit the command, so the module is malformed. */
    HandlerFailed, /**< The handler returned false, which retail reports as an illegal call. */
    NotFound,      /**< The command number has no handler in retail's table. */
};

/**
 * Records one argument list from the command's values, as retail's _DATA does.
 */
EventArgResult ApplyEventArgData(CEventScriptArg &script, const luau_runtime::EventArgAction &action) {
    // Retail keeps the list it already linked when its argument array cannot be allocated.
    ARG_LIST *list = AppendEventArgList(script);
    if (list == nullptr) {
        return EventArgResult::HandlerFailed;
    }
    ARG_DATA *args = AllocateEventArgData(*script.memory, action.args.size());
    if (args == nullptr) {
        return EventArgResult::HandlerFailed;
    }
    list->args = args;
    list->arg_num = 0;
    for (std::size_t index = 0; index < action.args.size(); ++index) {
        if (const auto *integer = std::get_if<std::int32_t>(&action.args[index])) {
            args[index].type = RS_INT;
            args[index].i = *integer;
        } else if (const auto *number = std::get_if<float>(&action.args[index])) {
            args[index].type = RS_FLOAT;
            args[index].f = *number;
        } else {
            const std::string encoded = legacy_encoding::GameText(std::get<std::string>(action.args[index]));
            args[index].type = RS_STR;
            args[index].s = CopyEventArgString(*script.memory, encoded);
            if (args[index].s == nullptr) {
                return EventArgResult::HandlerFailed;
            }
        }
    }
    list->arg_num = static_cast<int>(action.args.size());
    return EventArgResult::Applied;
}

/**
 * Sets the next list identifier from the first value, as retail's _ID_OFFSET does, ignoring any extra values.
 */
EventArgResult ApplyEventArgIdOffset(CEventScriptArg &script, const luau_runtime::EventArgAction &action) {
    // Retail reads its first stack slot unconditionally, so without a value it would read a stale slot.
    if (action.args.empty()) {
        return EventArgResult::Rejected;
    }
    const luau_runtime::EventArgValue &first = action.args.front();
    if (const auto *offset = std::get_if<std::int32_t>(&first)) {
        script.next_id = *offset;
        return EventArgResult::Applied;
    }
    if (const auto *float_offset = std::get_if<float>(&first)) {
        const double number = *float_offset;
        if (!std::isfinite(number) || number < std::numeric_limits<int>::min() ||
            number >= static_cast<double>(std::numeric_limits<int>::max()) + 1.0) {
            return EventArgResult::Rejected;
        }
        script.next_id = static_cast<int>(*float_offset);
        return EventArgResult::Applied;
    }
    return EventArgResult::Rejected;
}

/**
 * Applies one translated event argument command to its argument-list state.
 */
EventArgResult ApplyEventArgAction(CEventScriptArg &script, const luau_runtime::EventArgAction &action) {
    switch (action.command) {
        case EVENT_ARG_DATA:
            return ApplyEventArgData(script, action);
        case EVENT_ARG_ID_OFFSET:
            return ApplyEventArgIdOffset(script, action);
        default:
            // Retail's table has no handler for command 2, so it is reported like any unknown number.
            return EventArgResult::NotFound;
    }
}

} // namespace

int _LOAD_CHARA_sub(int stack_no, char **name, int chara_no, u32 *model, int mode) {
    if (!EventScene || !name) {
        return 0;
    }
    if (!*name) {
        const auto path = DataReadBufferPath(model);
        if (!path) {
            return 0;
        }
        std::string error;
        const auto  game = model_assets::ReadGameplay(*path, error);
        if (!game) {
            CT_LOG_ERROR(Data, "character: {}", error);
            return 0;
        }
        static std::map<std::string, std::string> selected_profiles;
        auto                                     &profile = selected_profiles[*path];
        profile = game->value("default_profile", std::string{});
        if (profile.empty()) {
            return 0;
        }
        *name = profile.data();
    }
    auto     *memory = EventScene->GetStack(stack_no);
    const int texture_block = EventScene->GetCharaTexb(chara_no);
    if (!memory || texture_block < 0) {
        return 0;
    }
    mgTexManager.DeleteBlock(texture_block);
    if (chara_no >= 8) {
        std::snprintf(mgTexManager.name_suffix, sizeof(mgTexManager.name_suffix), "ev%d", chara_no);
    }
    const int result = EventScene->LoadChara(chara_no, model, *name, memory, memory, memory, texture_block, mode);
    if (chara_no >= 8) {
        mgTexManager.name_suffix[0] = 0;
    }
    EventScene->SetType(SCENE_DATA_CHARA, chara_no, SCENE_CHARA_TYPE_EVENT);
    return result;
}

void CEventScriptArg::BuildArgData(std::span<u8> program) {
    const auto module = luau_runtime::HandleModule(
        std::span<const char>(reinterpret_cast<const char *>(program.data()), program.size()));
    if (!module) {
        BuildBytecodeArgData(program);
        return;
    }

    const auto actions = luau_runtime::ReadEventArgData(*module);
    if (!actions) {
        CT_LOG_ERROR(Script, "luau: {}: could not import event argument data", *module);
        return;
    }

    for (const luau_runtime::EventArgAction &action : *actions) {
        if (action.args.size() >= EVENT_ARG_STACK_NUM) {
            CT_LOG_ERROR(Script, "luau: {}: invalid event argument command {}", *module, action.command);
            continue;
        }
        try {
            switch (ApplyEventArgAction(*this, action)) {
                case EventArgResult::Applied:
                    break;
                case EventArgResult::Rejected:
                    CT_LOG_ERROR(Script, "luau: {}: invalid event argument command {}", *module, action.command);
                    break;
                case EventArgResult::HandlerFailed:
                    dc2::log::PrintGame("illegal function call ext %d\n", action.command);
                    break;
                case EventArgResult::NotFound:
                    dc2::log::PrintGame("not found ext %d\n", action.command);
                    break;
            }
        } catch (const std::exception &error) {
            CT_LOG_ERROR(Script, "luau: {}: could not encode argument string: {}", *module, error.what());
        }
    }
}
