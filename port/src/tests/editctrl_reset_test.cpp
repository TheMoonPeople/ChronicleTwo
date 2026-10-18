#include <gtest/gtest.h>

#include "editctrl.hpp"
#include "editctrl_port.hpp"
#include "mainloop.hpp"
#include "mglib_port.hpp"
#include "photo.hpp"
#include "scenevillager.hpp"
#include "stubs/photo.hpp"

extern mgCCamera    *PortContinuousEyeCamera;
extern int           PortTownEyeInitialized asm("EditCtrl_EyeInitialized");

TEST(TownEyeCamera, RetailResetCutsEvenInsideAContinuousScope) {
    const auto    old_mode = PortEditViewMode;
    const int     old_initialized = PortTownEyeInitialized;
    const auto    old_photo = TakePhotoMode;
    auto         *old_continuous = PortContinuousEyeCamera;
    sceVu0FVECTOR old_eye;
    std::copy_n(PortTownSavedEye, 4, old_eye);
    CScene         scene;
    CCharacter2    chara;
    CCameraControl camera;
    camera.ControlOff();
    camera.FollowOff();
    scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
    scene.AssignChara(0, &chara, const_cast<char *>("player"));
    scene.active_camera = scene.player_chara = 0;
    for (auto mode : {EDIT_VIEW_MODE_EYE, EDIT_VIEW_MODE_PHOTO}) {
        PortEditViewMode = mode;
        PortTownEyeInitialized = 1;
        TakePhotoMode = mode == EDIT_VIEW_MODE_PHOTO ? TAKE_PHOTO_AIM : TAKE_PHOTO_OFF;
        PortTownSavedEye[0] = 200;
        PortTownSavedEye[1] = 80;
        PortTownSavedEye[2] = -100;
        PortTownSavedEye[3] = 1;
        scene.SetStatus(SCENE_DATA_CHARA, 0, SCENE_CHARA_HIDE);
        PortContinuousEyeCamera = &camera;
        const auto generation = mgPortCameraGeneration();
        ResetViewMode(&scene);
        EXPECT_GT(mgPortCameraGeneration(), generation);
        EXPECT_EQ(PortEditViewMode, EDIT_VIEW_MODE_WALK);
        EXPECT_EQ(PortTownEyeInitialized, 0);
        EXPECT_FLOAT_EQ(camera.pos[0], 200);
        EXPECT_FALSE(scene.GetSceneCharacter(0)->status & SCENE_CHARA_HIDE);
        EXPECT_FALSE(NowTakePhoto());
    }
    PortContinuousEyeCamera = old_continuous;
    PortEditViewMode = old_mode;
    PortTownEyeInitialized = old_initialized;
    TakePhotoMode = old_photo;
    std::copy_n(old_eye, 4, PortTownSavedEye);
}
