#include "common.h"

#include <cmath>

#include "camera_fixed.hpp"
#include "camera_mouse.hpp"
#include "editctrl.hpp"
#include "editctrl_port.hpp"
#include "editloop.hpp"
#include "first_person_walk.hpp"
#include "mainloop.hpp"
#include "mglib.hpp"
#include "mglib_port.hpp"
#include "photo.hpp"
#include "platform/config.hpp"
#include "platform/input.hpp"
#include "scenevillager.hpp"
#include "sprint.hpp"
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

void PortRetailEditMoveChara(CScene *, sceVu0FVECTOR, EditMoveCharaInfo *) asm("EditCtrl_MoveChara");

namespace {

bool        g_sprint_move = false;  // set around the retail CharaControl step while sprinting
SprintTimer g_sprint_r2;

bool SprintAllowed(CScene *scene, CPadControl *pad) {
    return scene && pad && GetNowLoopNo() == LOOP_EDIT && !IsEditMode() && PortEditViewMode == EDIT_VIEW_MODE_WALK &&
           PortEditLadderMode == EDIT_LADDER_MODE_NONE && !scene->event_run && !GamePad__2.key_lock &&
           !SubGameRunning();
}

// Takes R2 from the retail eye-view toggle while walking: a press starts timing, holding sprints, and
// a quick release hands the retail toggle its press. Returns whether this frame sprints.
bool TownSprintInput(CScene *scene, CPadControl *pad) {
    const bool allowed = SprintAllowed(scene, pad);
    bool       tap = false;
    const bool sprint = g_sprint_r2.Step(allowed, allowed && pad->btn[PAD_BTN_R2].value != 0,
                                         GamePad__2.On(PAD_R2) != 0, GamePad__2.Up(PAD_R2) != 0,
                                         mgGetNowFrameRate(), tap);
    if (allowed) {
        pad->btn[PAD_BTN_R2].value = tap;
    }
    return sprint;
}

} // namespace

PORT_OVERRIDE void EditMoveChara(CScene *scene, sceVu0FVECTOR velocity, EditMoveCharaInfo *info) {
    if (g_sprint_move) {
        velocity[0] *= kSprintSpeed;
        velocity[2] *= kSprintSpeed;
    }
    PortRetailEditMoveChara(scene, velocity, info);
}

PORT_OVERRIDE int EditControl(CScene *scene, CPadControl *pad) {
    // Retail movement, ladder, eye entry/exit and photo behaviour run first; native eye look is
    // granted only once they have settled this frame's owner.
    if (PortEditLadderMode != EDIT_LADDER_MODE_NONE) {
        g_sprint_r2.tracking = false;
        PortEditLadderControl(scene, pad);
    } else {
        const bool eye_owned = TownFirstPersonOwns(scene, pad);
        const bool sprint = TownSprintInput(scene, pad);
        if (!TownFirstPersonWalk(scene, pad)) {
            auto         *chara = eye_owned ? scene->GetCharacter(scene->player_chara) : nullptr;
            sceVu0FVECTOR before;
            sceVu0FVECTOR after;
            if (chara) {
                chara->GetPosition(before);
            }
            auto         *player = sprint ? scene->GetCharacter(scene->player_chara) : nullptr;
            sceVu0FVECTOR start;
            if (player) {
                player->GetPosition(start);
            }
            g_sprint_move = sprint;
            PortEditCharaControl(scene, pad);
            g_sprint_move = false;
            if (player) {
                sceVu0FVECTOR end;
                player->GetPosition(end);
                if (end[0] != start[0] || end[2] != start[2]) {
                    player->SetStep(player->GetStep() * kSprintStep);
                }
            }
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

void PortRetailResetViewMode(CScene *) asm("EditCtrl_ResetViewMode");

PORT_OVERRIDE void ResetViewMode(CScene *scene) {
    mgPortCutCameraInterpolation();
    PortRetailResetViewMode(scene);
}
