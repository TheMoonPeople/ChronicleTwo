#include <gtest/gtest.h>

#include "editctrl.hpp"
#include "editctrl_port.hpp"
#include "mainloop.hpp"
#include "mainloop_port.hpp"
#include "map.hpp"
#include "mapinfo.hpp"
#include "mglib_port.hpp"
#include "photo.hpp"
#include "platform/input.hpp"
#include "stubs/photo.hpp"
#include "userdata.hpp"

class TownEyeMouse : public testing::TestWithParam<bool> {};

TEST_P(TownEyeMouse, NativeStateAndBothLookTargetsTurnOnceAndDropOtherOwnersMotion) {
    const bool     photo = GetParam();
    const unsigned old_photo = TakePhotoMode;
    TakePhotoMode = photo ? TAKE_PHOTO_AIM : TAKE_PHOTO_OFF;
    const int   old_loop = PortLoopNo;
    const auto  old_mode = PortEditViewMode;
    const float old_heading = PortEditEyeHeading, old_tilt = PortEditEyeTilt;
    const auto  old_lock = GamePad__2.key_lock;
    const auto  old_debug = DebugInfo.debug_camera;
    const int   old_ladder = PortEditLadderMode;
    CScene      scene;
    CCharacter2 chara;
    chara.SetPosition(0, 0, 0);
    scene.AssignChara(0, &chara, const_cast<char *>("player"));
    scene.player_chara = 0;
    CCameraControl camera;
    camera.ControlOff();
    camera.FollowOff();
    camera.SetPos(0, 28, 0);
    camera.SetRef(0, 28, 10);
    scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
    scene.active_camera = 0;
    // CScene leaves event_run to the zeroed storage of the retail global; a local holds garbage.
    scene.event_run = 0;
    PortLoopNo = LOOP_EDIT;
    PortEditViewMode = photo ? EDIT_VIEW_MODE_PHOTO : EDIT_VIEW_MODE_EYE;
    PortEditLadderMode = EDIT_LADDER_MODE_NONE;
    PortEditEyeHeading = PortEditEyeTilt = 0;
    DebugInfo.debug_camera = GamePad__2.key_lock = 0;
    CPadControl pad{};
    InputResetBindings();
    InputPadState input{.connected = true};
    InputSetOverride(0, &input);
    InputSetScriptedDevices({.mouse_dx = 100, .mouse_dy = 10000});
    InputLatchPad(0);
    TownMouseEyeAfterControl(&scene, &pad);
    EXPECT_LT(PortEditEyeHeading, -0.1f);
    EXPECT_FLOAT_EQ(PortEditEyeTilt, 0.65f);
    EXPECT_LT(camera.ref[0], -1);
    EXPECT_FLOAT_EQ(camera.ref[0], camera.next_ref[0]);
    EXPECT_FLOAT_EQ(camera.pos[1], 28);
    const float heading = PortEditEyeHeading;
    TownMouseEyeAfterControl(&scene, &pad);
    EXPECT_FLOAT_EQ(PortEditEyeHeading, heading);
    for (int owner = 0; owner < 10; ++owner) {
        PortEditViewMode = owner == 0 ? EDIT_VIEW_MODE_WALK : owner == 1 ? EDIT_VIEW_MODE_PHOTO
                                                                         : (photo ? EDIT_VIEW_MODE_PHOTO : EDIT_VIEW_MODE_EYE);
        if (owner == 1) {
            TakePhotoMode = TAKE_PHOTO_OFF;
        }
        scene.event_run = owner == 2;
        GamePad__2.key_lock = owner == 3;
        DebugInfo.debug_camera = owner == 4;
        camera.suspended = owner == 5;
        scene.active_camera = owner == 6 ? 1 : 0;
        PortEditLadderMode = owner == 7 ? EDIT_LADDER_MODE_BOTTOM : EDIT_LADDER_MODE_NONE;
        camera.follow_on = owner == 8;
        InputLatchPad(0);
        TownMouseEyeAfterControl(&scene, owner == 9 ? nullptr : &pad);
        TakePhotoMode = photo ? TAKE_PHOTO_AIM : TAKE_PHOTO_OFF;
        PortEditViewMode = photo ? EDIT_VIEW_MODE_PHOTO : EDIT_VIEW_MODE_EYE;
        scene.event_run = GamePad__2.key_lock = DebugInfo.debug_camera = 0;
        camera.suspended = camera.follow_on = scene.active_camera = 0;
        PortEditLadderMode = EDIT_LADDER_MODE_NONE;
        TownMouseEyeAfterControl(&scene, &pad);
        EXPECT_FLOAT_EQ(PortEditEyeHeading, heading) << owner;
    }
    InputSetScriptedDevices({.mouse_dy = -10000});
    InputLatchPad(0);
    TownMouseEyeAfterControl(&scene, &pad);
    EXPECT_FLOAT_EQ(PortEditEyeTilt, -1.0f);
    InputSetScriptedDevices({});
    InputSetOverride(0, nullptr);
    PortLoopNo = old_loop;
    PortEditViewMode = old_mode;
    PortEditEyeHeading = old_heading;
    PortEditEyeTilt = old_tilt;
    GamePad__2.key_lock = old_lock;
    DebugInfo.debug_camera = old_debug;
    PortEditLadderMode = old_ladder;
    TakePhotoMode = old_photo;
}

INSTANTIATE_TEST_SUITE_P(EyeAndPhoto, TownEyeMouse, testing::Bool());

TEST(TownEyeCamera, ContinuousRetailUpdatesDoNotCutButEntryExitAndAuthoredCutsDo) {
    auto  save = std::make_unique<CSaveData>();
    auto *old_save = PortActiveSaveData;
    PortActiveSaveData = save.get();
    const auto     old_mode = PortEditViewMode;
    const auto     old_loop = PortLoopNo;
    const auto     old_pad = GamePad__2;
    const auto     old_heading = PortEditEyeHeading, old_tilt = PortEditEyeTilt;
    CScene         scene;
    CCharacter2    chara;
    CCameraControl camera;
    CPadControl    pad{};
    scene.AssignChara(0, &chara, const_cast<char *>("player"));
    scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
    scene.player_chara = scene.active_camera = scene.event_run = 0;
    chara.SetPosition(0, 0, 0);
    camera.SetPos(0, 28, -100);
    camera.SetRef(0, 28, 0);
    PortLoopNo = LOOP_EDIT;
    PortEditViewMode = EDIT_VIEW_MODE_WALK;
    GamePad__2.pad[0].left_x = GamePad__2.pad[0].left_y = 128;
    pad.btn[PAD_BTN_R2].value = 1;
    auto generation = mgPortCameraGeneration();
    PortEditCameraControl(&scene, &pad);
    EXPECT_EQ(PortEditViewMode, EDIT_VIEW_MODE_EYE);
    EXPECT_GT(mgPortCameraGeneration(), generation);
    pad.btn[PAD_BTN_R2].value = 0;
    for (auto mode : {EDIT_VIEW_MODE_EYE, EDIT_VIEW_MODE_PHOTO}) {
        PortEditViewMode = mode;
        generation = mgPortCameraGeneration();
        PortEditCameraControl(&scene, &pad);
        const float x = camera.pos[0], heading = camera.angle_h;
        chara.SetPosition(x + 2, 0, 0);
        GamePad__2.pad[0].left_x = 220;
        PortEditCameraControl(&scene, &pad);
        EXPECT_GT(camera.pos[0], x);
        EXPECT_NE(camera.angle_h, heading);
        EXPECT_EQ(mgPortCameraGeneration(), generation);
    }
    PortEditViewMode = EDIT_VIEW_MODE_EYE;
    generation = mgPortCameraGeneration();
    camera.FollowOff();
    camera.ControlOff();
    camera.SetNextPos(200, 28, -100);
    camera.SetNextRef(200, 28, 0);
    camera.Step(-1); // The event CAMERA_STEP path on the same control camera.
    EXPECT_GT(mgPortCameraGeneration(), generation);
    generation = mgPortCameraGeneration();
    ResetViewMode(&scene);
    EXPECT_EQ(PortEditViewMode, EDIT_VIEW_MODE_WALK);
    EXPECT_GT(mgPortCameraGeneration(), generation);
    PortActiveSaveData = old_save;
    PortEditViewMode = old_mode;
    PortLoopNo = old_loop;
    GamePad__2 = old_pad;
    PortEditEyeHeading = old_heading;
    PortEditEyeTilt = old_tilt;
}

TEST(TownEyeCamera, ForcedFollowMapsPublishContinuousTicks) {
    auto       save = std::make_unique<CSaveData>();
    auto      *old_save = PortActiveSaveData;
    const auto old_mode = PortEditViewMode;
    const auto old_loop = PortLoopNo;
    const int  old_debug_flag = DebugFlag;
    const int  old_debug_camera = DebugInfo.debug_camera;
    PortActiveSaveData = save.get();
    PortLoopNo = LOOP_EDIT;
    PortEditViewMode = EDIT_VIEW_MODE_WALK;
    CScene         scene;
    CMap           map;
    CCharacter2    chara;
    CCameraControl camera;
    CPadControl    pad{};
    scene.AssignChara(0, &chara, const_cast<char *>("player"));
    scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
    scene.player_chara = scene.active_camera = scene.active_map = 0;
    for (const auto [debug_flag, debug_camera] : {
             std::pair{0, 0},
             std::pair{0, 1},
             std::pair{1, 0}
    }) {
        DebugFlag = debug_flag;
        DebugInfo.debug_camera = debug_camera;
        for (const char *name : {"s07", "s37", "s38"}) {
            scene.AssignMap(0, &map, const_cast<char *>(name));
            const auto generation = mgPortCameraGeneration();
            for (int tick = 0; tick < 3; ++tick) {
                chara.SetPosition(tick * 10, 0, 0);
                PortEditCameraControl(&scene, &pad);
                EXPECT_NEAR(camera.pos[0], chara.position[0], 0.0001f);
                EXPECT_EQ(mgPortCameraGeneration(), generation) << name << " flag=" << debug_flag << " camera=" << debug_camera;
            }
        }
    }
    PortActiveSaveData = old_save;
    PortEditViewMode = old_mode;
    PortLoopNo = old_loop;
    DebugFlag = old_debug_flag;
    DebugInfo.debug_camera = old_debug_camera;
}

TEST(TownEyeCamera, FixedRoomReseatCutsButForcedFollowInTheSameRoomDoesNot) {
    auto       save = std::make_unique<CSaveData>();
    auto      *old_save = PortActiveSaveData;
    const auto old_mode = PortEditViewMode;
    const int  old_fixed = PortEditFixedCamera;
    PortActiveSaveData = save.get();
    PortEditViewMode = EDIT_VIEW_MODE_WALK;
    CScene      scene;
    CMap        map;
    CCameraInfo fixed;
    fixed.pos_num = 1;
    fixed.pos[0][0] = 200;
    fixed.pos[0][1] = 80;
    fixed.pos[0][2] = -100;
    fixed.pos[0][3] = 1;
    map.SetCameraInfoTable(&fixed, 1);
    CCharacter2    chara;
    CCameraControl camera;
    CPadControl    pad{};
    scene.AssignChara(0, &chara, const_cast<char *>("player"));
    scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
    scene.AssignMap(0, &map, const_cast<char *>("room"));
    scene.SetStatus(SCENE_DATA_MAP, 0, SCENE_DATA_ACTIVE);
    scene.player_chara = scene.active_camera = scene.active_map = 0;
    PortEditFixedCamera = 0;
    auto generation = mgPortCameraGeneration();
    PortEditCameraControl(&scene, &pad);
    EXPECT_EQ(PortEditFixedCamera, 1);
    EXPECT_FLOAT_EQ(camera.pos[0], 200);
    EXPECT_GT(mgPortCameraGeneration(), generation);
    scene.AssignMap(0, &map, const_cast<char *>("s07"));
    scene.SetStatus(SCENE_DATA_MAP, 0, SCENE_DATA_ACTIVE);
    generation = mgPortCameraGeneration();
    PortEditCameraControl(&scene, &pad);
    EXPECT_EQ(PortEditFixedCamera, 1);
    EXPECT_NEAR(camera.pos[0], chara.position[0], 0.0001f);
    EXPECT_EQ(mgPortCameraGeneration(), generation);
    PortActiveSaveData = old_save;
    PortEditViewMode = old_mode;
    PortEditFixedCamera = old_fixed;
}

TEST(TownEyeCamera, PhotoEntryAndExitCutAroundRecurringUpdates) {
    auto       save = std::make_unique<CSaveData>();
    auto      *old_save = PortActiveSaveData;
    const auto old_mode = PortEditViewMode;
    const int  old_loop = PortLoopNo;
    const auto old_debug = DebugInfo;
    const auto old_photo = TakePhotoMode;
    const auto old_pad = GamePad__2;
    PortActiveSaveData = save.get();
    PortEditViewMode = EDIT_VIEW_MODE_WALK;
    PortLoopNo = LOOP_EDIT;
    DebugInfo.chara_move = 1; // Retail also permits photo entry while debugging movement.
    DebugInfo.debug_camera = 0;
    GamePad__2.pad[0].left_x = GamePad__2.pad[0].left_y = 128;
    CScene         scene;
    CMap           map;
    CCharacter2    chara;
    CCameraControl camera;
    CPadControl    pad{};
    scene.AssignChara(0, &chara, const_cast<char *>("player"));
    scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
    scene.AssignMap(0, &map, const_cast<char *>("s07"));
    scene.player_chara = scene.active_camera = scene.active_map = scene.event_run = 0;
    pad.btn[PAD_BTN_ACTION_SQUARE].value = 1;
    auto generation = mgPortCameraGeneration();
    PortEditCameraControl(&scene, &pad);
    EXPECT_EQ(PortEditViewMode, EDIT_VIEW_MODE_PHOTO);
    EXPECT_GT(mgPortCameraGeneration(), generation);
    pad.btn[PAD_BTN_ACTION_SQUARE].value = 0;
    generation = mgPortCameraGeneration();
    PortEditCameraControl(&scene, &pad);
    EXPECT_EQ(mgPortCameraGeneration(), generation);
    pad.btn[PAD_BTN_CANCEL].value = 1;
    PortEditCameraControl(&scene, &pad);
    EXPECT_EQ(PortEditViewMode, EDIT_VIEW_MODE_WALK);
    EXPECT_GT(mgPortCameraGeneration(), generation);
    PortActiveSaveData = old_save;
    PortEditViewMode = old_mode;
    PortLoopNo = old_loop;
    DebugInfo = old_debug;
    TakePhotoMode = old_photo;
    GamePad__2 = old_pad;
}
