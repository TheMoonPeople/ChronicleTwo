#include "common.h"

#include <libvu0.h>

#include <cmath>
#include <cstring>

#include "cameracontrol.hpp"
#include "character.hpp"
#include "dng_effect.hpp"
#include "dng_event.hpp"
#include "editctrl.hpp"
#include "editexception.hpp"
#include "editloop.hpp"
#include "editmap.hpp"
#include "effscript.hpp"
#include "gamepad.hpp"
#include "gameutil.hpp"
#include "helpmes.hpp"
#include "inventmn.hpp"
#include "mainloop.hpp"
#include "mapload.hpp"
#include "mg_math.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "padcontrol.hpp"
#include "photo.hpp"
#include "savedata.hpp"
#include "scene.hpp"
#include "sceneevent.hpp"
#include "scenesnd.hpp"
#include "scenevillager.hpp"
#include "sphida.hpp"
#include "userdata.hpp"

/**
 *
 * Clears the editor's persistent movement query when it is constructed.
 *
 */
struct InitializedMoveCheckInfo : MoveCheckInfo {
    /**
     *
     * Starts the persistent movement query in a cleared state.
     *
     */
    InitializedMoveCheckInfo() : MoveCheckInfo() { Initialize(); }
};

/**
 *
 * Persistent collision result for edit-mode movement.
 *
 */
InitializedMoveCheckInfo MoveInfo;

/**
 *
 * Map event that defines the ladder currently being climbed.
 *
 */
CSceneEventData LadderData;
/**
 *
 * End of the ladder the player entered.
 *
 */
int LadderMode;
/**
 *
 * Stage of climbing the ladder.
 *
 */
static EditLadderStep LadderStep;
/**
 *
 * Special movement motion in progress.
 *
 */
EditCharaMotionMode CharaMotionMode;
/**
 *
 * Frames left in the landing motion.
 *
 */
int CharaMotionModeCnt;
/**
 *
 * Consecutive frames without ground contact.
 *
 */
int CharaFallFlag;
/**
 *
 * Whether a target heading is set.
 *
 */
static int CharaAngleTargetFlag;
/**
 *
 * Heading the character turns towards while CharaAngleTargetFlag is set.
 *
 */
static int CharaAngleTarget;
/**
 *
 * What the scene's fixed camera search gave this frame: zero for none, otherwise the kind of fixed camera found.
 *
 */
int FixCameraFlag;
/**
 *
 * Frames since the fixed-camera position was sampled.
 *
 */
static int FixCameraChgCnt;
/**
 *
 * Rejects one request to enter eye view.
 *
 */
static int EyeViewCancelOnce;
/**
 *
 * Walking, eye-view or photo view.
 *
 */
EditViewMode ViewMode;
/**
 *
 * Whether the saved follow-camera position is valid.
 *
 */
int InitEyeViewFlag;
/**
 *
 * Photo shutter frame counter.
 *
 */
static int ShutterCnt;
/**
 *
 * Cleared when edit-mode control starts and not read otherwise.
 *
 */
static int move_chara;
/**
 *
 * First-person camera yaw.
 *
 */
float viewAngleH;
/**
 *
 * First-person camera pitch.
 *
 */
float viewAngleV;
/**
 *
 * First-person projection adjustment.
 *
 */
static float AddProj;
/**
 *
 * Camera used during ladder climbing.
 *
 */
static mgCCamera *LadderCamera;
/**
 *
 * Height of the next ladder rung.
 *
 */
static float LdrNext;
/**
 *
 * Heading toward the ladder.
 *
 */
static float LdrRot;
/**
 *
 * Motion ratio at the previous ladder step.
 *
 */
static float OldMtnRate;
/**
 *
 * Ladder footstep sound set.
 *
 */
static int LdrSound;
/**
 *
 * Footstep set at the ladder bottom.
 *
 */
static int LdrBtmFoot;
/**
 *
 * Footstep set at the ladder top.
 *
 */
static int LdrTopFoot;
/**
 *
 * Cached fixed-camera eye position.
 *
 */
static sceVu0FVECTOR OldFixCameraPos;
/**
 *
 * Follow-camera position saved before eye view.
 *
 */
sceVu0FVECTOR OldCameraPos;
/**
 *
 * Origin of the ladder.
 *
 */
static sceVu0FVECTOR LdrPos;
/**
 *
 * Position where the player approaches the ladder.
 *
 */
static sceVu0FVECTOR StdPos;
/**
 *
 * Landing at the bottom of the ladder.
 *
 */
static sceVu0FVECTOR LdrBottomPos;
/**
 *
 * Landing at the top of the ladder.
 *
 */
static sceVu0FVECTOR LdrTopPos;
/**
 *
 * Walk-off position at the top of the ladder.
 *
 */
static sceVu0FVECTOR LdrTopWalk;
/**
 *
 * Camera eye position for ladder climbing.
 *
 */
static sceVu0FVECTOR LdrCamPos;

static void LadderControl(CScene *scene, CPadControl *pad);
static void CharaControl(CScene *scene, CPadControl *pad);
static void CameraControl(CScene *scene, CPadControl *pad);
static void EyeCamera(mgCCamera *camera, CCharacter2 *chara, int use_right_stick);
static void InitEyeCamera(CCharacter2 *chara, CCameraControl *camera);
static void InitLadder(int mode, CScene *scene, CSceneEventData *event);

/**
 *
 * Returns the player data of the active save, or NULL when there is no save.
 *
 */
static CUserDataManager *GetUserData() {
    CSaveData *save = {};

    save = GetSaveData();

    if (save != nullptr) {
        return &save->user_data;
    }

    return nullptr;
}

int EditOnGround() {
    if (CharaFallFlag > 0) {
        return false;
    }

    if (CharaMotionMode != EDIT_CHARA_MOTION_FREE) {
        return false;
    }

    return (LadderMode != EDIT_LADDER_MODE_NONE) ^ 1;
}

int IsWalkMode() {
    return ViewMode == EDIT_VIEW_MODE_WALK;
}

void EditControlInit(CScene *scene) {
    CCameraControl *camera = {};
    memset(&MoveInfo, 0, sizeof(MoveInfo));
    EyeViewCancelOnce = false;
    ViewMode = EDIT_VIEW_MODE_WALK;
    InitEyeViewFlag = false;
    viewAngleH = 0;
    viewAngleV = 0;
    AddProj = 0;
    ShutterCnt = 0;
    move_chara = 0;
    scene->ResetStatus(SCENE_DATA_CHARA, scene->player_chara, SCENE_CHARA_HIDE);
    CharaAngleTarget = 0;
    CharaAngleTargetFlag = 0;
    FixCameraFlag = 0;
    InitTakePhoto();
    EditControlStatusInit(scene);
    camera = static_cast<CCameraControl *>(scene->GetCamera(scene->active_camera));

    if (camera != nullptr && camera->Iam() != CAMERA_KIND_CONTROL) {
        camera->CancelRotBack();
    }
}

void EditControlStatusInit(CScene *scene) {
    CCharacter2 *chara = {};

    LadderMode = EDIT_LADDER_MODE_NONE;
    CharaMotionMode = EDIT_CHARA_MOTION_FREE;
    CharaMotionModeCnt = 0;
    CharaFallFlag = 0;
    FixCameraChgCnt = 0;
    chara = scene->GetCharacter(scene->player_chara);

    if (chara != nullptr) {
        chara->SetMotion("\x97\xA7\x82\xBF", 4);

        chara->velocity[1] = 0.0f;
        chara->Step();
    }
}

int EditControl(CScene *scene, CPadControl *pad);

char *GetFootEffName(int index) {
    static char *name[4] = {
        nullptr,
        "\x91\xAB\x8D\xBB\x89\x8C",
        "\x91\xAB\x90\x85\x83p\x83V\x83\x83",
        "\x91\xAB\x8E\xC5\x90\xB6",
    };
    static EditFootEffect name_id[30] = {
        EDIT_FOOT_EFFECT_NONE,
        EDIT_FOOT_EFFECT_GRASS,
        EDIT_FOOT_EFFECT_NONE,
        EDIT_FOOT_EFFECT_NONE,
        EDIT_FOOT_EFFECT_NONE,
        EDIT_FOOT_EFFECT_NONE,
        EDIT_FOOT_EFFECT_NONE,
        EDIT_FOOT_EFFECT_SAND,
        EDIT_FOOT_EFFECT_SAND,
        EDIT_FOOT_EFFECT_NONE,
        EDIT_FOOT_EFFECT_NONE,
        EDIT_FOOT_EFFECT_WATER,
        EDIT_FOOT_EFFECT_NONE,
        EDIT_FOOT_EFFECT_SAND,
        EDIT_FOOT_EFFECT_SAND,
        EDIT_FOOT_EFFECT_NONE,
        EDIT_FOOT_EFFECT_SAND,
        EDIT_FOOT_EFFECT_NONE,
        EDIT_FOOT_EFFECT_WATER,
        EDIT_FOOT_EFFECT_NONE,
        EDIT_FOOT_EFFECT_NONE,
        EDIT_FOOT_EFFECT_NONE,
        EDIT_FOOT_EFFECT_WATER,
        EDIT_FOOT_EFFECT_NONE,
        EDIT_FOOT_EFFECT_NONE,
        EDIT_FOOT_EFFECT_NONE,
        EDIT_FOOT_EFFECT_NONE,
        EDIT_FOOT_EFFECT_NONE,
        EDIT_FOOT_EFFECT_NONE,
        EDIT_FOOT_EFFECT_NONE,
    };

    if (index < 0 || index >= 30) {
        return nullptr;
    }

    return name[name_id[index]];
}

void EditMoveChara(CScene *scene, sceVu0FVECTOR velocity, EditMoveCharaInfo *info) {
    CCharacter2      *character = {};
    CEffectScriptMan *effects = {};
    CMap             *map = {};
    CEditMap         *edit_map = {};
    CEditParts       *parts = {};
    CSphida          *sphida = {};
    int               remaining = {};
    CCPoly           *next_poly = {};
    sceVu0FVECTOR     position;
    sceVu0FVECTOR     next_position;
    CCPoly            polys[1024];
    mgVu0FBOX         bounds{};
    CMap             *maps[8];
    sceVu0FVECTOR     other_position;
    sceVu0FVECTOR     ground_query;
    sceVu0FVECTOR     ground_position;
    CCPoly            ground_poly{};
    sceVu0FVECTOR     ground_normal;
    sceVu0FVECTOR     effect_position;
    float             width = {};
    int               map_count = {};
    int               poly_count = {};
    int               added = {};
    int               ignore_mask = {};
    int               hard_landing = {};
    int               foot_sound = {};
    int               running = {};
    int               i = {};
    char             *motion = {};
    char             *effect_name = {};

    character = scene->GetCharacter(scene->player_chara);

    if (character == nullptr) {
        return;
    }

    effects = scene->GetEffect(0);
    {
        CCameraControl *control_camera = {};
        CCameraControl *camera = static_cast<CCameraControl *>(scene->GetCamera(scene->active_camera));
        control_camera = nullptr;

        if (camera != nullptr) {
            if (camera->Iam() == CAMERA_KIND_CONTROL) {
                control_camera = camera;
            }
        }

        if (control_camera != nullptr) {
            if (!(mgDistVectorXZ(velocity) <= 0.1f)) {
                control_camera->BitResetRotCameraCancel(CAMERA_ROT_CANCEL_AUTO_MOVE);
            } else {
                control_camera->BitSetRotCameraCancel(CAMERA_ROT_CANCEL_AUTO_MOVE);
            }
        }
    }
    character->GetPosition(position);

    for (i = 0; i < 3; i++) {
        bounds.max[i] = 40.0f + position[i];
        bounds.min[i] = position[i] - 40.0f;
    }

    bounds.max[3] = 1.0f;
    bounds.min[3] = 1.0f;
    remaining = 1024;
    map_count = scene->GetActiveMap(maps, 8);
    next_poly = polys;
    poly_count = scene->GetColPoly(next_poly, bounds, remaining);
    remaining -= poly_count;
    next_poly += poly_count;

    for (int chara_index = 0; chara_index < EDIT_CHARA_SLOT_OTHER_END - EDIT_CHARA_SLOT_OTHER; chara_index++) {
        if (scene->CheckDrawChara(chara_index + EDIT_CHARA_SLOT_OTHER)) {
            CCharacter2 *other = scene->GetCharacter(chara_index + EDIT_CHARA_SLOT_OTHER);

            if (other != nullptr && other->CheckDraw()) {
                other->GetPosition(other_position);
                width = other->body_width;

                if (width == 0.0f) {
                    width = 10.0f;
                }

                added = CreateCharaCPoly(next_poly, remaining, other_position, position, width, 20.0f);
                next_poly += added;
                poly_count += added;
                remaining -= added;

                if (remaining < 0) {
                    break;
                }
            }
        }
    }

    for (int map_index = 0; map_index < map_count; map_index++) {
        added = maps[map_index]->GetTrBoxColPoly(next_poly, position, remaining);
        next_poly += added;
        poly_count += added;
        remaining -= added;
    }

    DNG_BATTLE_AREA *battle = &scene->battle_area;

    if (battle != nullptr && battle->treasure_box != nullptr) {
        added = battle->treasure_box->PickupCollision(position, next_poly, bounds, remaining);
        next_poly += added;
        poly_count += added;
        remaining -= added;
    }

    sphida = GetSphidaPtr();

    if (sphida != nullptr) {
        added = sphida->PickupCollision(position, next_poly, bounds, remaining);
        next_poly += added;
        poly_count += added;
        remaining -= added;
    }

    if (info != nullptr && info->polys != nullptr) {
        for (int copy_index = 0; copy_index < info->poly_num; copy_index++) {
            mgVec4 *source = reinterpret_cast<mgVec4 *>(&info->polys[copy_index]);
            mgVec4 *dest = reinterpret_cast<mgVec4 *>(next_poly++);

            for (int row = 0; row < 5; row++) {
                dest[row] = source[row];
            }

            poly_count++;
            remaining--;
        }
    }

    ignore_mask = 0x1;
    map = scene->GetMap(scene->active_map);
    edit_map = nullptr;

    if (map != nullptr && strcmp(map->Iam(), "CEditMap") == 0) {
        edit_map = static_cast<CEditMap *>(map);
    }

    if (edit_map != nullptr) {
        std::memmove(ground_query, position, sizeof(float) * 4);
        ground_query[1] += 20.0f;

        if (GetFootPoly(ground_query, 80.0f, &ground_poly, ground_position, polys, poly_count, 0)) {
            sceVu0Normalize(ground_normal, ground_poly.normal);

            if (!(ground_normal[1] <= 0.6f) && (ground_poly.parts_no & CCPOLY_PARTS_EDIT)) {
                parts = edit_map->GetePlaceParts(ground_poly.parts_no & CCPOLY_PARTS_SLOT_MASK);

                if (parts != nullptr && parts->info != nullptr && (parts->info->attr & EDIT_PARTS_ATR_MOVE_MASK_SWITCH)) {
                    ignore_mask = 0x10;
                }
            }
        }
    }

    hard_landing = false;
    character->sound_info.foot_sound_id = -1;
    MoveInfo.radius = 13.0f;
    MoveCheckInfo &move_info = MoveInfo;
    MoveCheck(position, velocity, next_position, &move_info, polys, poly_count, ignore_mask);

    if (MoveInfo.landed) {
        if (velocity[1] < -5.0f) {
            hard_landing = true;
        }

        velocity[1] = 0.0f;
        map = scene->GetMap(scene->active_map);

        if (map != nullptr) {
            foot_sound = MoveInfo.ground_poly.foot_sound;

            if (foot_sound == 0) {
                foot_sound = map->map_info.def_foot;
            }

            character->sound_info.foot_sound_id = foot_sound;
        }
    }

    if (info != nullptr) {
        info->move_info = MoveInfo;
        info->hard_landing = hard_landing;
    }

    if (velocity[1] < -10.0f) {
        velocity[1] = -10.0f;
    }

    if (next_position[1] < -500.0f) {
        next_position[1] = 500.0f;
    }

    if (!(-100000.0f <= next_position[1])) {
        velocity[1] = 0.0f;
        next_position[1] = -100000.0f;
    }

    character->SetPosition(next_position);
    std::memmove(character->velocity, velocity, sizeof(float) * 4);
    motion = character->GetNowMotionName();
    running = false;

    if (motion != nullptr && strstr(motion, "\x91\x96\x82\xE8") != nullptr) {
        running = true;
    }

    if (effects != nullptr && IsWalkMode()) {
        character->GetPosition(effect_position);
        /**
         *
         * Distance and time accumulated between water ripple effects.
         *
         */
        static float HamonCnt = 0.0f;
        HamonCnt += 1.0f;
        HamonCnt += mgDistVectorXZ(velocity);

        if (MoveInfo.in_water) {
            sceVu0FVECTOR effect_scale = {1.0f, 1.0f, 1.0f, 0.0f};

            if (!(HamonCnt <= 30.0f)) {
                effects->CreateEffSpt("\x91\xAB\x94\x67\x96\xE4", 0, -1);
                effects->SetScriptVect1(MoveInfo.water_surface, -1, -1);
                effects->SetScriptVect2(effect_scale, -1, -1);
                HamonCnt = 0.0f;
            }

            if (!(MoveInfo.water_surface[1] - effect_position[1] <= 10.0f)) {
                effect_position[1] = MoveInfo.water_surface[1];
            }
        }

        if (running) {
            effect_name = GetFootEffName(character->CheckFootEffect());

            if (effect_name != nullptr) {
                if (strcmp(effect_name, "\x91\xAB\x8E\xC5\x90\xB6") == 0) {
                    effects->CreateEffSpt("\x91\xAB\x8D\xBB\x89\x8C", 0, -1);
                    effects->SetScriptVect1(effect_position, -1, -1);
                }

                effects->CreateEffSpt(effect_name, 0, -1);
                effects->SetScriptVect1(effect_position, -1, -1);
            }
        }

        if (MoveInfo.crossed_area && MoveInfo.signed_distance < -2.0f) {
            effects->CreateEffSpt("\x91\xAB\x90\x85\x83\x70\x83\x56\x83\x83", 0, -1);
            effects->SetScriptVect1(effect_position, -1, -1);
        }
    }
}

void EditCameraControl(CScene *scene, CPadControl *pad, float (*look_at)[4]) {
    /**
     *
     * Follow-camera distance used when selecting the fixed reference.
     *
     */
    static float    reference = 30.0f;
    int             debug_camera = {};
    int             fixed = {};
    CCharacter2    *character = {};
    CCameraControl *camera = {};
    sceVu0FVECTOR   position;
    sceVu0FVECTOR   rotation;
    sceVu0FVECTOR   velocity;
    sceVu0FVECTOR   fixed_position;
    sceVu0FVECTOR   fixed_reference;
    sceVu0FVECTOR   fixed_eye;
    mgVu0FBOX       bounds{};
    sceVu0FVECTOR   eye;
    sceVu0FVECTOR   target;
    CCPoly          polys[512];
    sceVu0FVECTOR   move_rotation;
    float           frame_rate = {};
    int             old_fixed = {};
    int             poly_count = {};
    int             i = {};

    character = scene->GetCharacter(scene->player_chara);

    if (character == nullptr) {
        return;
    }

    camera = static_cast<CCameraControl *>(scene->GetCamera(scene->active_camera));

    if (camera == nullptr || camera->Iam() != CAMERA_KIND_CONTROL) {
        return;
    }

    character->GetPosition(position);
    character->GetRotation(rotation);
    std::memmove(velocity, character->velocity, sizeof(float) * 4);
    debug_camera = DebugInfo.debug_camera;

    if (!DebugFlag) {
        debug_camera = 0;
    }

    frame_rate = mgGetNowFrameRate() / 2.0f;
    camera->SetFollowOffset(0.0f, 30.0f, 0.0f);

    if (look_at == nullptr) {
        camera->SetFollow(position[0], position[1], position[2]);
        camera->SetCheckRef(position[0], position[1], position[2]);
    } else {
        camera->SetFollow((*look_at)[0], (*look_at)[1], (*look_at)[2]);
        camera->SetCheckRef((*look_at)[0], (*look_at)[1], (*look_at)[2]);
    }

    old_fixed = FixCameraFlag;
    fixed = 0;
    FixCameraFlag = 0;
    std::memmove(fixed_reference, position, sizeof(float) * 4);

    if (!debug_camera && ViewMode == EDIT_VIEW_MODE_WALK) {
        fixed = scene->GetFixCameraPos(fixed_reference, fixed_position);

        if (FixCameraChgCnt <= 0) {
            std::memmove(OldFixCameraPos, fixed_position, sizeof(float) * 4);
        }

        if (FixCameraChgCnt > 0) {
            std::memmove(fixed_position, OldFixCameraPos, sizeof(float) * 4);
        }

        FixCameraChgCnt++;

        if (FixCameraChgCnt > 15) {
            FixCameraChgCnt = 0;
        }
    }

    SV_CONFIG_OPTION &config = GetSaveData()->config;
    camera->rot_reverse = !config.rot_normal;
    FixCameraFlag = fixed;

    if (!debug_camera && ViewMode == EDIT_VIEW_MODE_WALK) {
        if (strcmp(scene->GetMapName(scene->active_map), "s07") == 0 ||
            strcmp(scene->GetMapName(scene->active_map), "s38") == 0) {
            camera->ControlOff();
            camera->FollowOn();
            camera->SetAngleSoon(PI);
            camera->SetHeight(120.0f);
            camera->SetDistance(100.0f);
            camera->Step(-1);
            return;
        }

        if (strcmp(scene->GetMapName(scene->active_map), "s37") == 0) {
            camera->ControlOff();
            camera->FollowOn();
            camera->SetAngleSoon(PI);
            camera->SetHeight(60.0f);
            camera->SetDistance(100.0f);
            camera->Step(-1);
            return;
        }

        if (fixed) {
            camera->FollowOff();
            camera->ControlOff();

            if (fixed == 2) {
                camera->SetSpeed(8.0f, 2.0f);
                camera->SetNextPos(fixed_position);
                camera->SetNextRef(position[0], 30.0f + position[1], position[2]);
                return;
            }

            camera->GetPos(fixed_eye);

            if (!(mgDistVector(fixed_eye, fixed_position) <= 10.0f)) {
                camera->SetSpeed(1.0f, 1.0f);

                if (old_fixed && FixCameraFlag) {
                    scene->fade.CrossFade(10, 0.8f);
                    scene->fade.CaptureScreen();
                }

                camera->SetNextPos(fixed_position);
                camera->SetNextRef(position[0], 30.0f + position[1], position[2]);
                camera->Step(-1);
                return;
            }

            camera->SetSpeed(1, 4);
            camera->SetNextPos(fixed_position);
            camera->SetNextRef(position[0], 30.0f + position[1], position[2]);
            return;
        }

        camera->ControlOn();
        float speed = 4.0f;
        float damping = 3.0f;
        camera->SetSpeed(speed, damping);
        camera->GetPos(eye);
        camera->GetRef(target);
        mgVectorMaxMin(bounds.max, bounds.min, eye, target);

        for (i = 0; i < 3; i++) {
            bounds.max[i] += 20.0f;
            bounds.min[i] -= 20.0f;
        }

        bounds.max[1] += 200.0f;
        bounds.max[3] = 1.0f;
        bounds.min[3] = 1.0f;
        bounds.min[1] -= 200.0f;
        poly_count = scene->GetCameraPoly(polys, bounds, 512);
        character->GetRotation(move_rotation);
        camera->MoveCamera(pad, move_rotation, polys, poly_count);
        return;
    }

    camera->SetFollowOffset(0.0f, reference, 0.0f);
    camera->ControlOff();
    camera->FollowOn();
    camera->AddAngle(frame_rate * (0.03f * -GamePad__2.GetRXf()));
    camera->SetSpeed(4, 2);

    if (GamePad__2.On(PAD_L3)) {
        camera->AddDistance(frame_rate * (3.0f * GamePad__2.GetRYf()));
    } else {
        camera->AddHeight(frame_rate * (-2.0f * GamePad__2.GetRYf()));
    }

    if (GamePad__2.On(PAD_UP)) {
        reference += 3.0f * frame_rate;
    }

    if (GamePad__2.On(PAD_DOWN)) {
        reference -= 3.0f * frame_rate;
    }

    if (GamePad__2.On(PAD_L1)) {
        camera->AddAngle(0.04f * frame_rate);
    }

    if (GamePad__2.On(PAD_R1)) {
        camera->AddAngle(-0.04f * frame_rate);
    }

    if (!(GamePad__2.GetLXf() <= 0.1f)) {
        camera->AddAngle(-0.02f * frame_rate);
    }

    if (GamePad__2.GetLXf() < -0.1f) {
        camera->AddAngle(0.02f * frame_rate);
    }

    /**
     *
     * Selected follow-camera distance preset.
     *
     */
    static int camera_dist_mode = 0;
    float      camera_distances[3] = {30.0f, 130.0f, 250.0f};

    if (GamePad__2.Down(PAD_START)) {
        camera_dist_mode++;

        if (camera_dist_mode >= 3) {
            camera_dist_mode = 0;
        }

        camera->SetDistance(camera_distances[camera_dist_mode]);
    }
}

/**
 *
 * Moves the player, chooses walking and landing motions, and starts map events.
 *
 */
static void CharaControl(CScene *scene, CPadControl *pad) {
    mgCCamera        *base_camera = {};
    CCameraControl   *camera = {};
    CCharacter2      *character = {};
    CMap             *map = {};
    sceVu0FVECTOR     position;
    sceVu0FVECTOR     velocity;
    mgVu0FBOX         bounds{};
    sceVu0FVECTOR     extent;
    sceVu0FVECTOR     rotation;
    EditMoveCharaInfo move{};
    sceVu0FVECTOR     event_position;
    sceVu0FVECTOR     event_rotation;
    float             frame_rate = {};
    float             angle = {};
    float             stick_x = {};
    float             stick_y = {};
    float             speed_x = {};
    float             speed_z = {};
    float             max_extent = {};
    float             target_angle = {};
    float             next_angle = {};
    float             angle_error = {};
    float             strength = {};
    int               in_water = {};
    int               event_check = {};
    int               event_no = {};

    if (pad == nullptr) {
        return;
    }

    character = scene->GetCharacter(scene->player_chara);

    if (character == nullptr) {
        return;
    }

    base_camera = scene->GetCamera(scene->active_camera);

    if (base_camera == nullptr || base_camera->Iam() != CAMERA_KIND_CONTROL) {
        return;
    }

    camera = static_cast<CCameraControl *>(base_camera);
    frame_rate = mgGetNowFrameRate() / 2.0f;
    character->GetPosition(position);
    std::memmove(velocity, character->velocity, sizeof(float) * 4);
    angle = camera->GetAngle();
    stick_x = pad->Analog(PAD_ANALOG_LEFT_X_2);
    stick_y = pad->Analog(PAD_ANALOG_LEFT_Y_2);
    speed_x = stick_x * cosf(angle) + stick_y * sinf(angle);
    speed_z = -stick_x * sinf(angle) + stick_y * cosf(angle);
    speed_x *= 5.0f * frame_rate;
    speed_z *= 5.0f * frame_rate;
    map = scene->GetMap(scene->active_map);

    if (map != nullptr && map->GetBBox(&bounds)) {
        sceVu0SubVector(extent, bounds.max, bounds.min);
        max_extent = extent[0] > extent[2] ? extent[0] : extent[2];

        if (max_extent < 800.0f) {
            speed_x *= 0.7f;
            speed_z *= 0.7f;
        }
    }

    in_water = false;

    if (MoveInfo.in_water && !(MoveInfo.water_surface[1] - position[1] <= 10.0f)) {
        in_water = true;
        speed_x *= 0.5f;
        speed_z *= 0.5f;
    }

    if (DebugInfo.chara_move) {
        if (GamePad__2.On(PAD_L2)) {
            speed_x *= 3.0f;
            speed_z *= 3.0f;
        }

        if (ViewMode == EDIT_VIEW_MODE_WALK && PadCtrl.Btn(PAD_BTN_CANCEL)) {
            velocity[1] = 8.0f * frame_rate;
        }
    } else if (CharaFallFlag) {
        speed_z = 0.0f;
        speed_x = 0.0f;
    }

    velocity[0] = speed_x;
    velocity[2] = speed_z;
    velocity[1] -= 0.6f * frame_rate;

    if (ViewMode != EDIT_VIEW_MODE_WALK) {
        velocity[0] = 0.0f;
        velocity[2] = 0.0f;
        character->SetMotion("\x97\xA7\x82\xBF", CHARA_MOTION_RESTART);
        character->SetStep(character->GetDefaultStep());
        CharaMotionMode = EDIT_CHARA_MOTION_FREE;
    } else if (CharaMotionMode == EDIT_CHARA_MOTION_LANDING) {
        velocity[0] = 0.0f;
        CharaMotionModeCnt--;
        velocity[2] = 0.0f;

        if (CharaMotionModeCnt <= 0 || character->CheckMotionEnd()) {
            CharaMotionMode = EDIT_CHARA_MOTION_FREE;
        }
    } else if (speed_x != 0.0f || speed_z != 0.0f) {
        character->GetRotation(rotation);
        target_angle = atan2f(speed_x, speed_z);
        next_angle = mgAngleInterpolate(rotation[1], target_angle, 0.3f, 0);
        angle_error = target_angle - next_angle;

        if (angle_error < 0.0f) {
            angle_error = -angle_error;
        }

        if (!(static_cast<float>(static_cast<int>(angle_error)) <= 1.0f)) {
            velocity[0] *= 0.5f;
            velocity[2] *= 0.5f;
        }

        character->SetRotation(0.0f, next_angle, 0.0f);
        strength = sqrtf(stick_x * stick_x + stick_y * stick_y);

        if (strength < 0.8f) {
            character->SetMotion("\x95\xE0\x82\xAB", 0);
            character->SetStep((0.1f + strength / 0.8f) * frame_rate);
        } else {
            if (in_water) {
                character->SetMotion("\x90\x85\x92\x86\x91\x96\x82\xE8", 0);
            } else {
                character->SetMotion("\x91\x96\x82\xE8", 0);
            }

            character->SetStep(character->GetDefaultStep());
        }
    } else {
        character->SetMotion("\x97\xA7\x82\xBF", 0);
        character->SetStep(character->GetDefaultStep());
    }

    memset(&move.move_info, 0, sizeof(move.move_info));
    memset(&move, 0, sizeof(move));
    EditMoveChara(scene, velocity, &move);

    if (!move.move_info.landed) {
        CharaFallFlag++;

        if (CharaFallFlag > 3) {
            character->SetMotion("\x97\x8E\x89\xBA\x92\x86", 0);
            CharaFallFlag = 3;
        }
    } else {
        CharaFallFlag = 0;
    }

    if (CharaMotionMode == EDIT_CHARA_MOTION_FREE && move.hard_landing) {
        CharaMotionMode = EDIT_CHARA_MOTION_LANDING;
        CharaMotionModeCnt = 20;
        character->SetMotion("\x92\x85\x92\x6E", CHARA_MOTION_RESTART | CHARA_MOTION_HOLD);
    }

    character->GetPosition(event_position);
    character->GetRotation(event_rotation);
    CSceneEventData event;
    event_check = MAP_EVENT_CHECK_TOUCH;

    if (pad->Btn(PAD_BTN_CONFIRM)) {
        event_check = MAP_EVENT_CHECK_ACTION;
    }

    if (pad->Btn(PAD_BTN_ACTION_SQUARE)) {
        event_check = MAP_EVENT_CHECK_ITEM;
    }

    if (scene->GetMapEvent(event_position, event_check, &event)) {
        event_no = event.event.point_no;
        ResetViewMode(scene);

        if (event.event.flag & FUNC_EVENT_DOOR) {
            atan2f(event.map_event.matrix[2][0], event.map_event.matrix[2][2]);
            event_no = EDIT_LOOP_EVENT_EDIT_EVENT;
        }

        if (event.event.flag & FUNC_EVENT_LADDER_BOTTOM) {
            InitLadder(EDIT_LADDER_MODE_BOTTOM, scene, &event);
            return;
        }

        if (event.event.flag & FUNC_EVENT_LADDER_TOP) {
            InitLadder(EDIT_LADDER_MODE_TOP, scene, &event);
            return;
        }

        if (event.event.flag & FUNC_EVENT_TREASURE_BOX) {
            event_no = EDIT_LOOP_EVENT_EDIT_EVENT;
        }

        if (event.event.flag & FUNC_EVENT_BOOK) {
            event_no = EDIT_LOOP_EVENT_EDIT_EVENT;
        }

        scene->RunEvent(event_no, &event);
    }
}

void CancelEyeViewMode() {
    EyeViewCancelOnce = true;
}

/**
 *
 * Handles editor camera control, eye view, and photo input.
 *
 */
static void CameraControl(CScene *scene, CPadControl *pad) {
    int              photo_locked = {};
    int              eye_pressed = {};
    int              photo_pressed = {};
    CCharacter2     *chara = {};
    CCameraControl  *camera = {};
    CInventUserData *user_data = {};
    float            position[4];
    float            facing[4];
    chara = scene->GetCharacter(scene->player_chara);

    if (chara != nullptr) {
        camera = static_cast<CCameraControl *>(scene->GetCamera(scene->active_camera));

        if (camera != nullptr) {
            switch (camera->Iam()) {
                default:
                    return;
                case CAMERA_KIND_CONTROL: {
                    photo_locked = false;

                    if (scene->event_run) {
                        photo_locked = true;
                    }

                    if (!IsTakePhoto() && !DebugInfo.chara_move) {
                        photo_locked = true;
                    }

                    chara->GetPosition(position);
                    chara->GetRotation(facing);
                    mgGetNowFrameRate();

                    if (pad != nullptr) {
                        if (ViewMode == EDIT_VIEW_MODE_WALK) {
                            eye_pressed = pad->Btn(PAD_BTN_R2);
                            photo_pressed = !photo_locked && pad->Btn(PAD_BTN_ACTION_SQUARE);

                            if (eye_pressed) {
                                photo_pressed = false;
                            }

                            if (eye_pressed || photo_pressed) {
                                if (EyeViewCancelOnce) {
                                    ShowErrorHelpMes(200, 40);
                                } else {
                                    ViewMode = EDIT_VIEW_MODE_EYE;

                                    if (photo_pressed) {
                                        ViewMode = EDIT_VIEW_MODE_PHOTO;
                                        StartTakePhoto();
                                    }

                                    camera->ControlOff();
                                    camera->FollowOff();
                                    InitEyeCamera(chara, camera);
                                    EyeCamera(
                                        camera, chara, 0);
                                    scene->SetStatus(SCENE_DATA_CHARA, scene->player_chara, SCENE_CHARA_HIDE);
                                    scene->EyeViewDrawOnOff(1);
                                    return;
                                }
                            }
                        } else if (ViewMode == EDIT_VIEW_MODE_EYE || ViewMode == EDIT_VIEW_MODE_PHOTO) {
                            if (pad->Btn(PAD_BTN_R2) || pad->Btn(PAD_BTN_CANCEL)) {
                                if (ViewMode == EDIT_VIEW_MODE_PHOTO) {
                                    EndTakePhoto();
                                }

                                camera->FollowOn();

                                if (!DebugInfo.debug_camera) {
                                    camera->SetDistance(5.0f);
                                    camera->SetHeight(0.0f);
                                } else {
                                    camera->SetHeight(camera->GetHeight());
                                }

                                camera->Step(-1);
                                camera->ControlOn();
                                ResetViewMode(scene);
                                scene->EyeViewDrawOnOff(0);
                            } else {
                                camera->FollowOff();
                                EyeCamera(camera, chara, 0);
                                user_data = nullptr;

                                if (GetUserData() != nullptr) {
                                    user_data = GetUserData()->GetInventUserData();
                                }

                                LoopTakePhoto(pad, user_data);
                                return;
                            }
                        }
                    }

                    EditCameraControl(scene, pad, nullptr);
                    EyeViewCancelOnce = false;
                }
            }
        }
    }
}

/**
 *
 * Initializes editor eye view from the character facing angle.
 *
 */
static void InitEyeCamera(CCharacter2 *chara, CCameraControl *camera) {
    float rotation[4];
    chara->GetRotation(rotation);
    InitEyeViewFlag = true;
    viewAngleV = 0;
    AddProj = 0;
    ShutterCnt = 0;
    viewAngleH = rotation[1];
    camera->GetPos(OldCameraPos);
}

void ResetViewMode(CScene *scene);

/**
 *
 * Updates the editor eye camera orientation from gamepad input.
 *
 */
static void EyeCamera(mgCCamera *camera, CCharacter2 *chara, int use_right_stick) {
    SV_CONFIG_OPTION *options = {};
    float             angle = {};
    float             turn_speed =
        0.04f;
    float stick_x = {};
    float stick_y = {};
    float pos[4];
    float ref[4];
    float look[4][4];
    float unit[4][4];
    mgSetAllScissorFlag(1);

    if (use_right_stick) {
        stick_x = 0.0f;
        stick_y = GamePad__2.GetRYf();
    } else {
        stick_x = GamePad__2.GetLXf();
        stick_y = GamePad__2.GetLYf();
    }

    options = &GetSaveData()->config;

    if (!options->eye_reverse) {
        stick_y = -stick_y;
    }

    if (stick_x > 0.0f) {
        viewAngleH -= stick_x * turn_speed;

        if (viewAngleH < -PI) {
            viewAngleH += TWO_PI;
        }
    }

    if (stick_x < 0.0f) {
        viewAngleH -= stick_x * turn_speed;

        if (viewAngleH > PI) {
            viewAngleH -= TWO_PI;
        }
    }

    if (stick_y > 0.0f && viewAngleV < 0.65f) {
        viewAngleV += stick_y * turn_speed;
    }

    if (stick_y < 0.0f && viewAngleV > -1.0f) {
        viewAngleV += stick_y * turn_speed;
    }

    ref[0] = 0.0f;
    ref[1] = 0.0f;
    ref[2] = 10.0f;
    ref[3] = 0.0f;
    sceVu0UnitMatrix(unit);
    sceVu0RotMatrixX(look, unit, viewAngleV);
    sceVu0RotMatrixY(look, look, viewAngleH);
    sceVu0ApplyMatrix(ref, look, ref);
    chara->GetPosition(pos);
    pos[1] += 28.0f;
    ref[0] += pos[0];
    ref[1] += pos[1];
    ref[2] += pos[2];
    camera->SetNextPos(pos);
    camera->SetNextRef(ref);
    camera->Step(-1);
}

/**
 *
 * Builds the ladder landings and camera position from the event's world transform.
 *
 */
static void InitLadder(int mode, CScene *scene, CSceneEventData *event) {
    int           other_foot = {};
    CCharacter2  *character = {};
    sceVu0FVECTOR bottom_offset;
    sceVu0FVECTOR top_offset;
    sceVu0FVECTOR walk_offset;
    sceVu0FVECTOR camera_offset;
    sceVu0FMATRIX matrix;
    float         height = {};
    int           current_foot = {};

    character = scene->GetCharacter(scene->player_chara);
    LadderMode = mode;
    LadderData = *event;
    LadderStep = EDIT_LADDER_STEP_START;
    std::memmove(LdrPos, event->map_event.matrix[3], sizeof(float) * 4);
    LdrPos[3] = 1.0f;
    mgZeroVector(top_offset);
    mgZeroVector(bottom_offset);
    mgZeroVector(walk_offset);
    mgZeroVector(camera_offset);
    walk_offset[2] = -10.0f;
    bottom_offset[2] = 20.0f;
    top_offset[2] = -4.5f;
    camera_offset[0] = 60.0f;
    camera_offset[2] = 100.0f;
    sceVu0Normalize(matrix[0], event->map_event.matrix[0]);
    sceVu0Normalize(matrix[1], event->map_event.matrix[1]);
    sceVu0Normalize(matrix[2], event->map_event.matrix[2]);
    std::memmove(matrix[3], event->map_event.matrix[3], sizeof(float) * 4);
    sceVu0ApplyMatrix(walk_offset, matrix, walk_offset);
    sceVu0ApplyMatrix(top_offset, matrix, top_offset);
    sceVu0ApplyMatrix(bottom_offset, matrix, bottom_offset);
    sceVu0ApplyMatrix(camera_offset, matrix, camera_offset);
    height = static_cast<float>(event->event.arg1);
    LdrSound = event->event.arg2;
    current_foot = character->sound_info.foot_sound_id;
    other_foot = event->event.arg3;
    sceVu0AddVector(LdrTopPos, LdrPos, top_offset);
    sceVu0AddVector(LdrBottomPos, LdrPos, bottom_offset);
    sceVu0AddVector(LdrCamPos, LdrPos, camera_offset);

    if (mode == EDIT_LADDER_MODE_BOTTOM) {
        std::memmove(StdPos, LdrBottomPos, sizeof(float) * 4);
        LdrBtmFoot = current_foot;
        LdrTopFoot = other_foot;
        LdrTopPos[1] += height;
    } else {
        std::memmove(StdPos, LdrTopPos, sizeof(float) * 4);
        LdrBtmFoot = other_foot;
        LdrTopFoot = current_foot;
        LdrBottomPos[1] -= height;
    }

    sceVu0AddVector(LdrTopWalk, LdrTopPos, walk_offset);
    LdrRot = atan2f(matrix[2][0], matrix[2][2]);
    LdrRot = mgAngleLimit(PI + LdrRot);
    LadderCamera = scene->GetCamera(scene->active_camera);
    OldMtnRate = 0.0f;
    LdrCamPos[1] = LdrTopPos[1];
    scene->map_event_no = 0;
}

/**
 *
 * Clears the active ladder movement state.
 *
 */
static void EndLadder() {
    LadderMode = EDIT_LADDER_MODE_NONE;
}

/**
 *
 * Advances the ladder approach, rung motions and walk-off, playing rung footsteps.
 *
 */
static void LadderControl(CScene *scene, CPadControl *pad) {
    CCharacter2  *character = {};
    sceVu0FVECTOR position;
    sceVu0FVECTOR rotation;
    sceVu0FVECTOR foot_position;
    float         top_height = {};
    float         motion_rate = {};
    int           change_motion = {};

    character = scene->GetCharacter(scene->player_chara);

    if (character == nullptr) {
        EndLadder();
        return;
    }

    character->GetPosition(position);
    character->GetRotation(rotation);
    character->GetEntryObjectPos(0, foot_position);
    foot_position[1] += 15.0f;
    LadderCamera->SetNextRef(foot_position);

    switch (LadderStep) {
        case EDIT_LADDER_STEP_START:
            LadderStep = EDIT_LADDER_STEP_APPROACH;

            if (!FixCameraFlag) {
                LadderCamera->SetPos(LdrCamPos);
            }
            // The first frame also approaches the ladder.
        case EDIT_LADDER_STEP_APPROACH:
            mgVectorInterpolate(position, position, StdPos, 1.0f, 0);
            rotation[1] = mgAngleInterpolate(rotation[1], LdrRot, 0.1f, 0);

            if (mgDistVector(position, StdPos) < 0.1f && mgAngleCmp(rotation[1], LdrRot, 0.01f) == 0) {
                if (LadderMode == EDIT_LADDER_MODE_BOTTOM) {
                    LadderStep = EDIT_LADDER_STEP_MOUNT_BOTTOM;
                    character->SetMotion("\x82\xCC\x82\xDA\x82\xE9", CHARA_MOTION_RESTART);
                    std::memmove(position, LdrPos, sizeof(float) * 4);
                } else {
                    LadderStep = EDIT_LADDER_STEP_MOUNT_TOP;
                    std::memmove(position, LdrPos, sizeof(float) * 4);
                    position[1] -= 14.0f;
                    character->SetMotion("\x8D\x7E\x82\xE8\x82\xE9", CHARA_MOTION_RESTART);
                }
            } else {
                character->SetMotion("\x95\xE0\x82\xAB", 0);
            }

            break;
        case EDIT_LADDER_STEP_MOUNT_BOTTOM:
            character->SetMotion("\x82\xCC\x82\xDA\x82\xE9", CHARA_MOTION_HOLD);

            if (!(character->GetNowFrameWait() <= 0.6f)) {
                character->sound_info.foot_sound_id = LdrSound;
            }

            if (character->CheckMotionEnd()) {
                LadderStep = EDIT_LADDER_STEP_MOUNTED_BOTTOM;
            }

            break;
        case EDIT_LADDER_STEP_MOUNT_TOP:
            character->SetMotion("\x8D\x7E\x82\xE8\x82\xE9", CHARA_MOTION_HOLD);
            character->sound_info.foot_sound_id = LdrSound;

            if (character->CheckMotionEnd()) {
                LadderStep = EDIT_LADDER_STEP_MOUNTED_TOP;
            }

            break;
        case EDIT_LADDER_STEP_MOUNTED_BOTTOM:
            position[1] += 14.0f;
            character->SetMotion("\x82\xCC\x82\xDA\x82\xE8\x92\xE2\x8E\x7E", CHARA_MOTION_RESTART);
            LadderStep = EDIT_LADDER_STEP_HOLD;
            break;
        case EDIT_LADDER_STEP_MOUNTED_TOP:
            character->SetMotion("\x8D\x7E\x82\xE8\x92\xE2\x8E\x7E", CHARA_MOTION_RESTART);
            LadderStep = EDIT_LADDER_STEP_HOLD;
            break;
        case EDIT_LADDER_STEP_HOLD:
            if (pad->Analog(PAD_ANALOG_LEFT_Y_2) < -0.1f) {
                LadderStep = EDIT_LADDER_STEP_CLIMB_UP;
                change_motion = true;

                if (strcmp(character->GetNowMotionName(), "\x82\xCC\x82\xDA\x82\xE8\x92\xE2\x8E\x7E") == 0) {
                    change_motion = false;
                }

                character->SetMotion("\x82\xCC\x82\xDA\x82\xE8L", CHARA_MOTION_HOLD);

                if (!change_motion) {
                    character->blend_speed = 1.0f;
                    character->blend = 1.0f;
                }

                character->SetStep(0.0f);
                LdrNext = 14.0f + position[1];
            } else if (!(pad->Analog(PAD_ANALOG_LEFT_Y_2) <= 0.1f)) {
                LadderStep = EDIT_LADDER_STEP_CLIMB_DOWN;
                change_motion = true;

                if (strcmp(character->GetNowMotionName(), "\x8D\x7E\x82\xE8\x92\xE2\x8E\x7E") == 0) {
                    change_motion = false;
                }

                character->SetMotion("\x8D\x7E\x82\xE8L", CHARA_MOTION_HOLD);

                if (!change_motion) {
                    character->blend_speed = 1.0f;
                    character->blend = 1.0f;
                }

                LdrNext = position[1] - 14.0f;
            }

            break;
        case EDIT_LADDER_STEP_CLIMB_UP:
            if (character->GetMotionStatus() != CHARA_MOTION_STATUS_BLEND) {
                character->SetStep(0.5f);
                position[1] += 0.7f;
                top_height = LdrTopPos[1] - 14.0f;

                if (top_height < static_cast<float>(static_cast<int>(position[1]))) {
                    LadderStep = EDIT_LADDER_STEP_GET_OFF_TOP;
                    position[1] = top_height;
                    character->SetMotion("\x82\xCC\x82\xDA\x82\xE8\x8A\xAE\x97\xB9", CHARA_MOTION_RESTART | CHARA_MOTION_HOLD);
                } else {
                    if (!(position[1] < LdrNext)) {
                        position[1] = LdrNext;

                        if (pad->Analog(PAD_ANALOG_LEFT_Y_2) < -0.1f) {
                            character->SetMotion("\x82\xCC\x82\xDA\x82\xE8L", CHARA_MOTION_RESTART | CHARA_MOTION_HOLD);
                            LdrNext = 14.0f + position[1];
                        } else {
                            LadderStep = EDIT_LADDER_STEP_HOLD;
                            character->SetMotion("\x82\xCC\x82\xDA\x82\xE8\x92\xE2\x8E\x7E", 0);
                            character->blend_speed = 1.0f;
                            character->blend = 1.0f;
                        }
                    }

                    character->SetStep(0.0f);
                    motion_rate = 0.5f * ((position[1] - LdrBottomPos[1]) / 7.0f);
                    motion_rate -= static_cast<float>(static_cast<int>(motion_rate));
                    character->SetNowFrameWeight(motion_rate);

                    if (OldMtnRate <= 0.95f && !(character->GetNowFrameWait() <= 0.95f)) {
                        scene->SePlayFoot(LdrSound, 0, foot_position);
                    }

                    if (OldMtnRate <= 0.55f && !(character->GetNowFrameWait() <= 0.55f)) {
                        scene->SePlayFoot(LdrSound, 0, foot_position);
                    }
                }
            }

            break;
        case EDIT_LADDER_STEP_CLIMB_DOWN:
            if (character->GetMotionStatus() != CHARA_MOTION_STATUS_BLEND) {
                character->SetStep(0.5f);
                position[1] -= 0.7f;

                if (!(14.0f + LdrBottomPos[1] < position[1])) {
                    LadderStep = EDIT_LADDER_STEP_GET_OFF_BOTTOM;
                    position[1] = LdrBottomPos[1];
                    character->SetMotion("\x8D\x7E\x82\xE8\x8A\xAE\x97\xB9", CHARA_MOTION_RESTART | CHARA_MOTION_HOLD);
                } else {
                    if (position[1] <= LdrNext) {
                        position[1] = LdrNext;

                        if (!(pad->Analog(PAD_ANALOG_LEFT_Y_2) <= 0.1f)) {
                            character->SetMotion("\x8D\x7E\x82\xE8L", CHARA_MOTION_RESTART | CHARA_MOTION_HOLD);
                            LdrNext = position[1] - 14.0f;
                        } else {
                            LadderStep = EDIT_LADDER_STEP_HOLD;
                            character->SetMotion("\x8D\x7E\x82\xE8\x92\xE2\x8E\x7E", 0);
                            character->blend_speed = 1.0f;
                            character->blend = 1.0f;
                        }
                    }

                    character->SetStep(0.0f);
                    motion_rate = 0.5f * ((LdrTopPos[1] - position[1]) / 7.0f);
                    motion_rate -= static_cast<float>(static_cast<int>(motion_rate));
                    character->SetNowFrameWeight(motion_rate);

                    if (OldMtnRate <= 0.94f && !(character->GetNowFrameWait() <= 0.94f)) {
                        scene->SePlayFoot(LdrSound, 0, foot_position);
                    }

                    if (OldMtnRate <= 0.55f && !(character->GetNowFrameWait() <= 0.55f)) {
                        scene->SePlayFoot(LdrSound, 0, foot_position);
                    }
                }
            }

            break;
        case EDIT_LADDER_STEP_GET_OFF_BOTTOM:
            if (!(character->GetNowFrameWait() <= 0.4f)) {
                character->sound_info.foot_sound_id = LdrBtmFoot;
            }

            if (character->CheckMotionEnd()) {
                std::memmove(position, LdrBottomPos, sizeof(float) * 4);
                character->SetMotion("\x97\xA7\x82\xBF", CHARA_MOTION_RESTART);
                LadderStep = EDIT_LADDER_STEP_END;
            }

            break;
        case EDIT_LADDER_STEP_GET_OFF_TOP:
            if (!(character->GetNowFrameWait() <= 0.6f)) {
                character->sound_info.foot_sound_id = LdrTopFoot;
            }

            if (character->CheckMotionEnd()) {
                std::memmove(position, LdrTopPos, sizeof(float) * 4);
                character->SetMotion("\x97\xA7\x82\xBF", CHARA_MOTION_RESTART);
                LadderStep = EDIT_LADDER_STEP_WALK_OFF_TOP;
            }

            break;
        case EDIT_LADDER_STEP_WALK_OFF_TOP:
            character->sound_info.foot_sound_id = LdrTopFoot;
            mgVectorInterpolate(position, position, LdrTopWalk, 1.0f, 0);

            if (mgDistVector(position, LdrTopWalk) < 0.1f) {
                std::memmove(position, LdrTopWalk, sizeof(float) * 4);
                LadderStep = EDIT_LADDER_STEP_END;
            } else {
                character->SetMotion("\x95\xE0\x82\xAB", 0);
            }

            break;
        case EDIT_LADDER_STEP_END:
        default:
            EndLadder();
            break;
    }

    character->SetPosition(position);
    character->SetRotation(rotation);
    OldMtnRate = character->GetNowFrameWait();
}

void EditStepChara(CScene *scene) {
    int slot = {};

    scene->StepChara(scene->player_chara);

    for (slot = EDIT_CHARA_SLOT_OTHER; slot < EDIT_CHARA_SLOT_OTHER_END; slot++) {
        scene->StepChara(slot);
    }

    scene->StepChara(EDIT_CHARA_SLOT_EXTRA);
    scene->StepChara(EDIT_CHARA_SLOT_EXTRA + 1);
    scene->StepChara(EDIT_CHARA_SLOT_EXTRA + 2);
    scene->StepChara(EDIT_CHARA_SLOT_EXTRA + 3);
}

void EditDrawShadowChara(CScene *scene) {
    int slot = {};

    scene->DrawCharaShadow(scene->player_chara);

    for (slot = EDIT_CHARA_SLOT_OTHER; slot < EDIT_CHARA_SLOT_OTHER_END; slot++) {
        scene->DrawCharaShadow(slot);
    }
}

void EditDrawChara(CScene *scene) {
    int slot = {};

    scene->DrawChara(scene->player_chara, 0);

    for (slot = EDIT_CHARA_SLOT_OTHER; slot < EDIT_CHARA_SLOT_OTHER_END; slot++) {
        if (scene->GetType(SCENE_DATA_CHARA, slot) != SCENE_CHARA_TYPE_EFFECT) {
            scene->DrawChara(slot, 1);
        }
    }
}

void EditDrawEffectChara(CScene *scene) {
    int slot = {};

    for (slot = EDIT_CHARA_SLOT_OTHER; slot < EDIT_CHARA_SLOT_OTHER_END; slot++) {
        if (scene->GetType(SCENE_DATA_CHARA, slot) == SCENE_CHARA_TYPE_EFFECT) {
            scene->DrawChara(slot, 2);
        }
    }
}

namespace {
void ResetViewModeCore(CScene *scene) {
    mgCCameraFollow *camera = {};
    ViewMode = EDIT_VIEW_MODE_WALK;
    camera = static_cast<mgCCameraFollow *>(scene->GetCamera(scene->active_camera));

    if (InitEyeViewFlag) {
        camera->SetPos(OldCameraPos);
    }

    InitEyeViewFlag = false;

    if (camera != nullptr) {
        camera->Step(-1);
    }

    scene->ResetStatus(SCENE_DATA_CHARA, scene->player_chara, SCENE_CHARA_HIDE);
    EndTakePhoto();
}
} // namespace

#include "common.h"

#include <cmath>

#include "camera_fixed.hpp"
#include "camera_mouse.hpp"
#include "editctrl.hpp"
#include "editloop.hpp"
#include "first_person_walk.hpp"
#include "mainloop.hpp"
#include "object/world/town_control.hpp"
#include "photo.hpp"
#include "platform/config.hpp"
#include "platform/input.hpp"
#include "render/renderer.hpp"
#include "scenevillager.hpp"
#include "subgame.hpp"

void TownMouseEyeAfterControl(CScene *scene, CPadControl *pad) {
    const InputMouseLook &look = InputGetMouseLook();
    static std::uint64_t  consumed_read = 0;
    if (look.read == consumed_read) {
        return;
    }
    consumed_read = look.read;
    if (!scene || !pad || GetNowLoopNo() != LOOP_EDIT || IsEditMode() ||
        (PortEditViewMode != EDIT_VIEW_MODE_EYE &&
         (PortEditViewMode != EDIT_VIEW_MODE_PHOTO || !NowTakePhoto())) ||
        PortEditLadderMode != EDIT_LADDER_MODE_NONE ||
        (!EditOnGround() && !TownFirstPersonOwns(scene, pad)) || scene->event_run || scene->active_camera != 0 ||
        GamePad__2.key_lock || SubGameRunning() || DebugInfo.debug_camera || mgCCamera::StopCamera) {
        return;
    }
    mgCCamera   *base = scene->GetCamera(0);
    CCharacter2 *chara = scene->GetCharacter(scene->player_chara);
    if (!base || !chara || base->Iam() != CAMERA_KIND_CONTROL || base->suspended) {
        return;
    }
    auto *camera = static_cast<CCameraControl *>(base);
    if (camera->follow_on || camera->control_on || (camera->rot_cancel & CAMERA_ROT_CANCEL_ANALOG)) {
        return;
    }
    sceVu0FVECTOR eye;
    chara->GetPosition(eye);
    eye[1] += 28;
    for (int i = 0; i < 3; ++i) {
        if (std::fabs(camera->pos[i] - eye[i]) > 0.001f ||
            std::fabs(camera->next_pos[i] - eye[i]) > 0.001f) {
            return;
        }
    }
    if (MouseCameraEye(*camera, PortEditEyeHeading, PortEditEyeTilt, look.yaw, look.pitch)) {
        camera->mgCCamera::Step(0);
        camera->angle = camera->next_angle = camera->angle_h;
    }
}

int EditControl(CScene *scene, CPadControl *pad) {
    // Retail movement, ladder, eye entry/exit and photo behaviour run first; native eye look is
    // granted only once they have settled this frame's owner.
    if (PortEditLadderMode != EDIT_LADDER_MODE_NONE) {
        PortEditLadderControl(scene, pad);
    } else {
        const bool eye_owned = TownFirstPersonOwns(scene, pad);
        if (!TownFirstPersonWalk(scene, pad)) {
            auto         *chara = eye_owned ? scene->GetCharacter(scene->player_chara) : nullptr;
            sceVu0FVECTOR before;
            sceVu0FVECTOR after;
            if (chara) {
                chara->GetPosition(before);
            }
            PortEditCharaControl(scene, pad);
            if (chara) {
                chara->GetPosition(after);
                FirstPersonShiftSavedEye(PortTownSavedEye, before, after);
            }
        }
        PortEditCameraControl(scene, scene->event_run ? nullptr : pad);
    }
    TownMouseEyeAfterControl(scene, pad);
    return 0;
}

CCameraControl *TownMouseFixedOwner() {
    if (GetNowLoopNo() != LOOP_EDIT || PortTownLoopMode != EDIT_LOOP_WALK ||
        PortTownControlMode != EDIT_CONTROL_PLAYER || PortTownLockChara || PortTownPause ||
        PortEditViewMode != EDIT_VIEW_MODE_WALK || PortEditLadderMode != EDIT_LADDER_MODE_NONE ||
        SubGameRunning() || DebugInfo.debug_camera) {
        return nullptr;
    }
    auto *scene = GetMainScene();
    auto *base = scene->GetCamera(scene->active_camera);
    if (!base || base->Iam() != CAMERA_KIND_CONTROL) {
        return nullptr;
    }
    auto *camera = static_cast<CCameraControl *>(base);
    return TownMouseFixedOwns(camera, scene, &PadCtrl, true, PortEditFixedCamera != 0,
                              GamePad__2.key_lock, ConfigGet().mouse_fixed_look)
               ? camera
               : nullptr;
}

void ResetViewMode(CScene *scene) {
    mgPortCutCameraInterpolation();
    ResetViewModeCore(scene);
}
