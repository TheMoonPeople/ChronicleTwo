#include "common.h"

#include <cmath>

#include "camera_fixed.hpp"
#include "camera_mouse.hpp"
#include "editctrl.hpp"
#include "editctrl_port.hpp"
#include "editloop.hpp"
#include "first_person_walk.hpp"
#include "mainloop.hpp"
#include "mglib_port.hpp"
#include "photo.hpp"
#include "platform/config.hpp"
#include "platform/input.hpp"
#include "scenevillager.hpp"
#include "subgame.hpp"

extern sceVu0FVECTOR PortTownSavedEye asm("EditCtrl_SavedEye");

void TownMouseEyeAfterControl(CScene *scene, CPadControl *pad) {
    const InputMouseLook &look = InputGetMouseLook();
    static std::uint64_t  consumed_read = 0;
    if (look.read == consumed_read) {
        return;
    }
    consumed_read = look.read;
    if (!scene || !pad || GetNowLoopNo() != LOOP_EDIT || IsEditMode() ||
        (PortEditViewMode != EDIT_VIEW_MODE_EYE &&
         !(PortEditViewMode == EDIT_VIEW_MODE_PHOTO && NowTakePhoto())) ||
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

PORT_OVERRIDE int EditControl(CScene *scene, CPadControl *pad) {
    // Keep retail movement, ladder, eye-entry/exit and photo behavior, granting
    // native eye look only after those helpers establish this frame's owner.
    if (PortEditLadderMode != EDIT_LADDER_MODE_NONE) {
        PortEditLadderControl(scene, pad);
    } else {
        const bool eye_owned = TownFirstPersonOwns(scene, pad);
        if (!TownFirstPersonWalk(scene, pad)) {
            auto         *chara = eye_owned ? scene->GetCharacter(scene->player_chara) : nullptr;
            sceVu0FVECTOR before, after;
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

void PortRetailResetViewMode(CScene *) asm("EditCtrl_ResetViewMode");

PORT_OVERRIDE void ResetViewMode(CScene *scene) {
    mgPortCutCameraInterpolation();
    PortRetailResetViewMode(scene);
}
