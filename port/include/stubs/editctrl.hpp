#pragma once

#include <editctrl.hpp>
void mgPortCutCameraInterpolation();

// Give the native caller access to the retail eye state and static control
// helpers, using the same linkage seam as the main-loop port stubs.
extern int                 FixCameraFlag asm("EditCtrl_FixedCamera");
extern int                 LadderMode asm("EditCtrl_LadderMode");
extern EditViewMode        ViewMode asm("EditCtrl_ViewMode");
extern float               viewAngleH asm("EditCtrl_EyeHeading");
extern float               viewAngleV asm("EditCtrl_EyeTilt");
extern sceVu0FVECTOR       OldCameraPos asm("EditCtrl_SavedEye");
extern int                 CharaFallFlag asm("EditCtrl_FallFlag");
extern EditCharaMotionMode CharaMotionMode asm("EditCtrl_MotionMode");
extern int                 CharaMotionModeCnt asm("EditCtrl_MotionCount");
extern int                 InitEyeViewFlag asm("EditCtrl_EyeInitialized");

void PortRetailResetViewMode(CScene *) asm("EditCtrl_ResetViewMode");

static void LadderControl(CScene *scene, CPadControl *pad);
static void CharaControl(CScene *scene, CPadControl *pad);
static void CameraControl(CScene *scene, CPadControl *pad);

void PortEditLadderControl(CScene *scene, CPadControl *pad) { LadderControl(scene, pad); }

void PortEditCharaControl(CScene *scene, CPadControl *pad) { CharaControl(scene, pad); }

// Only proven recurring updates resolve their pose without a display cut.
mgCCamera *PortContinuousEyeCamera = nullptr;

void PortEditCameraControl(CScene *scene, CPadControl *pad) {
    auto       *camera = scene->GetCamera(scene->active_camera);
    const auto  mode = ViewMode;
    auto       *previous = PortContinuousEyeCamera;
    const char *map = scene->GetMapName(scene->active_map);
    const bool  forced_follow = ViewMode == EDIT_VIEW_MODE_WALK && !(DebugFlag && DebugInfo.debug_camera) && map &&
                                (strcmp(map, "s07") == 0 || strcmp(map, "s37") == 0 || strcmp(map, "s38") == 0);
    const bool  recurring_eye = pad && camera && camera->Iam() == CAMERA_KIND_CONTROL &&
                                (ViewMode == EDIT_VIEW_MODE_EYE || ViewMode == EDIT_VIEW_MODE_PHOTO) &&
                                !pad->Btn(PAD_BTN_R2) && !pad->Btn(PAD_BTN_CANCEL) &&
                                !static_cast<CCameraControl *>(camera)->follow_on &&
                                !static_cast<CCameraControl *>(camera)->control_on;
    PortContinuousEyeCamera = forced_follow || recurring_eye ? camera : nullptr;
    CameraControl(scene, pad);
    PortContinuousEyeCamera = previous;
    if (mode != ViewMode) {
        mgPortCutCameraInterpolation();
    }
}
