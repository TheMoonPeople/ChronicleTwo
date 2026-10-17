#include <gtest/gtest.h>

#include <cmath>
#include <numbers>

#include "camera_control_port.hpp"
#include "camera_mouse.hpp"
#include "cameracontrol.hpp"
#include "dng_main.hpp"
#include "mainloop.hpp"
#include "mainloop_port.hpp"
#include "map.hpp"
#include "padcontrol.hpp"
#include "photo.hpp"
#include "platform/input.hpp"
#include "scenesnd.hpp"
#include "stubs/photo.hpp"

namespace {
CCameraControl Camera() {
    CCameraControl camera;
    camera.SetPos(0, 40, 100);
    camera.SetRef(0, 40, 0);
    camera.SetFollow(0, 10, 0);
    camera.SetFollowOffset(0, 30, 0);
    camera.ControlOn();
    camera.SetSpeed(4, 3);
    return camera;
}

CCPoly Wall(float x) {
    CCPoly poly{};
    float  vertices[3][4] = {
        {x, -1000, -1000, 1},
        {x, 1000,  -1000, 1},
        {x, 0,     1000,  1}
    };
    for (int i = 0; i < 3; ++i) {
        for (int j = 0; j < 4; ++j) {
            poly.vertex[i][j] = vertices[i][j];
        }
    }
    poly.normal[0] = 1;
    return poly;
}

// A dungeon field with the active main follow camera and an idle player.
struct DungeonGate {
    CCameraControl  camera = Camera();
    CScene          scene;
    CPadControl     pad{};
    DNG_BATTLE_AREA area{};
    DNG_STATUS      status{};
    CActionChara    chara;

    DungeonGate() {
        scene.event_run = 0;
        chara.menu_flag = 1;
        chara.hold_type = ACTION_HOLD_NONE;
        chara.lock_on = 0;
        chara.damage_req = ACTION_DAMAGE_REQ_NONE;
        area.script.event_no = -1;
        scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
        scene.active_camera = 0;
    }

    bool Owns(bool eye = false, bool subgame = false, bool locked = false, bool debug = false) {
        return DungeonMouseCameraOwns(&camera, &scene, &pad, status, &area, &chara, subgame, locked, debug, eye);
    }
};
} // namespace

TEST(CameraMouse, DirectYawTurnsCurrentAndPendingPosesWithoutStickEasing) {
    auto            camera = Camera();
    constexpr float yaw = std::numbers::pi_v<float> / 2;
    EXPECT_NEAR(MouseCameraYaw(camera, yaw, nullptr, 0), yaw, 0.0001f);
    EXPECT_NEAR(camera.pos[0], -100, 0.001f);
    EXPECT_NEAR(camera.pos[2], 0, 0.001f);
    EXPECT_NEAR(camera.next_pos[0], -100, 0.001f);
    EXPECT_FLOAT_EQ(camera.pos[1], 40);
    EXPECT_FLOAT_EQ(camera.ref[0], 0);
    EXPECT_FLOAT_EQ(camera.pos_speed, 4);
    camera.Step(1);
    EXPECT_NEAR(camera.pos[0], -100, 0.001f);
}

TEST(CameraMouse, SweepStopsBeforeAThinWallEvenWhenTheFinalEyeIsClear) {
    auto        camera = Camera();
    auto        wall = Wall(-50);
    const float applied = MouseCameraYaw(camera, std::numbers::pi_v<float>, &wall, 1);
    EXPECT_GT(applied, 0);
    EXPECT_LT(applied, std::numbers::pi_v<float> / 2);
    EXPECT_GT(camera.pos[0], -46.1f);
    EXPECT_NEAR(camera.pos[0], camera.next_pos[0], 0.001f);
    // Refused yaw is not saved: a clear reverse moves immediately.
    const float previous = camera.pos[0];
    EXPECT_LT(MouseCameraYaw(camera, -0.1f, &wall, 1), 0);
    EXPECT_GT(camera.pos[0], previous);
}

TEST(CameraMouse, InvalidStartingCorridorAndNonfiniteInputLeaveThePoseAlone) {
    auto camera = Camera();
    auto wall = Wall(0);
    EXPECT_EQ(MouseCameraYaw(camera, 0.5f, &wall, 1), 0);
    EXPECT_FLOAT_EQ(camera.pos[2], 100);
    EXPECT_EQ(MouseCameraYaw(camera, INFINITY, nullptr, 0), 0);
    EXPECT_EQ(MouseCameraYaw(camera, NAN, nullptr, 0), 0);
}

TEST(CameraMouse, PendingCorridorMustAlsoBeClear) {
    auto camera = Camera();
    camera.next_pos[0] = -80;
    auto wall = Wall(-50);
    EXPECT_EQ(MouseCameraYaw(camera, 0.5f, &wall, 1), 0);
    EXPECT_FLOAT_EQ(camera.pos[0], 0);
    EXPECT_FLOAT_EQ(camera.next_pos[0], -80);
}

TEST(CameraMouse, CameraOwnershipRejectsScriptsLocksOtherViewsAndOtherCameras) {
    auto   camera = Camera();
    CScene scene;
    scene.event_run = 0;
    CPadControl pad{};
    scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
    scene.active_camera = 0;
    EXPECT_TRUE(TownMouseCameraOwns(&camera, &scene, &pad, true, false, false));
    EXPECT_FALSE(TownMouseCameraOwns(&camera, &scene, nullptr, true, false, false));
    EXPECT_FALSE(TownMouseCameraOwns(&camera, &scene, &pad, false, false, false));
    EXPECT_FALSE(TownMouseCameraOwns(&camera, &scene, &pad, true, true, false));
    EXPECT_FALSE(TownMouseCameraOwns(&camera, &scene, &pad, true, false, true));
    scene.event_run = 1;
    EXPECT_FALSE(TownMouseCameraOwns(&camera, &scene, &pad, true, false, false));
    scene.event_run = 0;
    camera.rot_cancel = CAMERA_ROT_CANCEL_ANALOG;
    EXPECT_FALSE(TownMouseCameraOwns(&camera, &scene, &pad, true, false, false));
    camera.rot_cancel = 0;
    camera.ControlOff();
    EXPECT_FALSE(TownMouseCameraOwns(&camera, &scene, &pad, true, false, false));
    camera.ControlOn();
    camera.FollowOff();
    EXPECT_FALSE(TownMouseCameraOwns(&camera, &scene, &pad, true, false, false));
}

TEST(CameraMouse, TownControlConsumesOneSampleAndDoesNotReplayLockedMotion) {
    auto    camera = Camera();
    CScene &scene = *GetMainScene();
    scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
    scene.active_camera = 0;
    scene.event_run = 0;
    PortLoopNo = LOOP_EDIT;
    GamePad__2.key_lock = 0;
    InputResetBindings();
    InputPadState input{.connected = true};
    InputSetOverride(0, &input);
    InputSetScriptedDevices({.mouse_dx = 400});
    InputLatchPad(0);
    CPadControl pad{};
    pad.Initialize();
    float rotation[4]{};
    camera.MoveCamera(&pad, rotation, nullptr, 0);
    EXPECT_LT(camera.pos[0], -60);
    const float turned = camera.pos[0];
    camera.MoveCamera(&pad, rotation, nullptr, 0);
    EXPECT_FLOAT_EQ(camera.pos[0], turned);
    InputLatchPad(0);
    GamePad__2.key_lock = 1;
    camera.MoveCamera(&pad, rotation, nullptr, 0);
    EXPECT_FLOAT_EQ(camera.pos[0], turned);
    GamePad__2.key_lock = 0;
    camera.MoveCamera(&pad, rotation, nullptr, 0);
    EXPECT_FLOAT_EQ(camera.pos[0], turned);
    InputSetScriptedDevices({});
    InputSetOverride(0, nullptr);
}

TEST(CameraMouse, MultipleRevolutionsRetainTheRequestedFinalHeading) {
    auto        camera = Camera();
    const float yaw = 4.5f * std::numbers::pi_v<float>;
    EXPECT_FLOAT_EQ(MouseCameraYaw(camera, yaw, nullptr, 0), yaw);
    EXPECT_NEAR(camera.pos[0], -100, 0.001f);
    EXPECT_NEAR(camera.pos[2], 0, 0.001f);
}

TEST(CameraMouse, PitchChangesBothEyesDirectlyAndDiscardsMotionAtHeightLimits) {
    auto camera = Camera();
    camera.GetActiveParam()->height = 0;
    camera.GetActiveParam()->min_height = -15;
    camera.GetActiveParam()->max_height = 40;
    EXPECT_LT(MouseCameraPitch(camera, 0.1f, nullptr, 0), 0);
    EXPECT_LT(camera.pos[1], 40);
    EXPECT_FLOAT_EQ(camera.pos[1], camera.next_pos[1]);
    EXPECT_FLOAT_EQ(camera.ref[1], 40);
    MouseCameraPitch(camera, -10, nullptr, 0);
    EXPECT_FLOAT_EQ(camera.GetActiveParam()->height, 40);
    const float limited = camera.pos[1];
    EXPECT_EQ(MouseCameraPitch(camera, -10, nullptr, 0), 0);
    EXPECT_FLOAT_EQ(camera.pos[1], limited);
    EXPECT_LT(MouseCameraPitch(camera, 0.02f, nullptr, 0), 0);
    EXPECT_LT(camera.pos[1], limited);
}

TEST(CameraMouse, PitchCannotSweepThroughACeiling) {
    auto        camera = Camera();
    CCPoly      ceiling{};
    const float vertices[3][4] = {
        {-1000, 60, -1000, 1},
        {1000,  60, -1000, 1},
        {0,     60, 1000,  1}
    };
    for (int i = 0; i < 3; ++i) {
        for (int j = 0; j < 4; ++j) {
            ceiling.vertex[i][j] = vertices[i][j];
        }
    }
    ceiling.normal[1] = -1;
    MouseCameraPitch(camera, -0.5f, &ceiling, 1);
    EXPECT_LE(camera.pos[1], 40.001f);
    EXPECT_LE(camera.next_pos[1], 40.001f);
}

namespace {
class CapacityMap : public CMap {
public:
    CapacityMap() {
        place_parts = nullptr;
        place_parts_num = 0;
    }

    int calls = 0;
    int polygons = 0;

    int GetCameraPoly(CCPoly *out, mgVu0FBOX &, int maximum) override {
        ++calls;
        const int written = std::min(polygons, maximum);
        for (int i = 0; i < written; ++i) {
            out[i] = Wall(1000);
        }
        return written;
    }
};
} // namespace

TEST(CameraMouse, AFullMapCollectorCannotEnterTheNextMapWithZeroCapacity) {
    CScene scene;
    scene.event_run = 0;
    CapacityMap first, second;
    first.polygons = 8;
    second.polygons = 1;
    scene.AssignMap(0, &first, const_cast<char *>("first"));
    scene.AssignMap(1, &second, const_cast<char *>("second"));
    scene.map[0].status |= SCENE_DATA_ACTIVE;
    scene.map[1].status |= SCENE_DATA_ACTIVE;
    mgVu0FBOX box{};
    CCPoly    output[8]{};
    EXPECT_EQ(MouseCameraCollectPolys(scene, box, output, 8), -1);
    EXPECT_EQ(first.calls, 1);
    EXPECT_EQ(second.calls, 0);
}

TEST(CameraMouse, DungeonActionsKeepRightStickAndDirectMouseFollowControl) {
    const int  old_loop = PortLoopNo;
    auto      *old_scene = DngMainScene;
    auto      *old_area = BattleAreaScene;
    auto      *old_chara = MainChara__2;
    const auto old_status = DngStatus;
    const auto old_debug = DebugInfo.debug_camera;
    const int  old_flag = DebugFlag;
    CScene     scene;
    scene.event_run = 0;
    DNG_BATTLE_AREA area{};
    CActionChara    chara;
    chara.menu_flag = 1;
    chara.hold_type = ACTION_HOLD_NONE;
    chara.lock_on = 0;
    chara.damage_req = ACTION_DAMAGE_REQ_NONE;
    area.script.event_no = -1;
    area.script.running = 0;
    DngMainScene = &scene;
    BattleAreaScene = &area;
    MainChara__2 = &chara;
    DngStatus = {};
    DebugFlag = DebugInfo.debug_camera = 0;
    PortLoopNo = LOOP_DUNGEON;
    InputResetBindings();
    InputPadState input{.connected = true};
    InputSetOverride(0, &input);
    CPadControl pad{};
    pad.Initialize();

    struct Action {
        const char *name;
        int         hold, menu, guard, gun, lock, landed;
    };

    const Action actions[] = {
        {"standing",         ACTION_HOLD_NONE,  1, 0, 0, 0, 1},
        {"carrying stone",   ACTION_HOLD_STONE, 0, 0, 0, 0, 1},
        {"carrying enemy",   ACTION_HOLD_ENEMY, 0, 0, 0, 0, 1},
        {"holding item",     ACTION_HOLD_ITEM,  0, 0, 0, 0, 1},
        {"guarding",         ACTION_HOLD_NONE,  0, 1, 0, 0, 1},
        {"aiming",           ACTION_HOLD_NONE,  0, 0, 1, 0, 1},
        {"aiming locked on", ACTION_HOLD_NONE,  0, 0, 1, 1, 1},
        {"falling",          ACTION_HOLD_NONE,  0, 0, 0, 0, 0},
    };
    for (const auto &action : actions) {
        SCOPED_TRACE(action.name);
        chara.hold_type = action.hold;
        chara.menu_flag = action.menu;
        chara.guard_flag = action.guard;
        chara.dir_gun = action.gun;
        chara.lock_on = action.lock;
        chara.move_check.landed = action.landed;
        for (int mode : {DNG_CAMERA_FOLLOW, DNG_CAMERA_FOLLOW_LOW}) {
            SCOPED_TRACE(mode);
            // The retail pad path accepts both axes in each action state.
            auto controller = Camera();
            scene.AssignCamera(0, &controller, const_cast<char *>("MainCam"));
            scene.active_camera = 0;
            area.camera_mode = mode;
            InputSetScriptedDevices({});
            InputLatchPad(0);
            pad.analog[PAD_ANALOG_RIGHT_X_2].value = 1;
            pad.analog[PAD_ANALOG_RIGHT_Y_2].value = 1;
            float rotation[4]{};
            controller.MoveCamera(&pad, rotation, nullptr, 0);
            EXPECT_LT(controller.next_pos[0], -1);
            EXPECT_LT(controller.GetActiveParam()->height, 0);
            pad.analog[PAD_ANALOG_RIGHT_X_2].value = 0;
            pad.analog[PAD_ANALOG_RIGHT_Y_2].value = 0;
            auto camera = Camera();
            scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
            scene.active_camera = 0;
            area.camera_mode = mode;
            InputSetScriptedDevices({.mouse_dx = 100, .mouse_dy = -30});
            InputLatchPad(0);
            camera.MoveCamera(&pad, rotation, nullptr, 0);
            EXPECT_LT(camera.pos[0], -10) << mode;
            EXPECT_LT(camera.pos[1], 40) << mode;
            const float turned = camera.pos[0];
            camera.MoveCamera(&pad, rotation, nullptr, 0);
            EXPECT_FLOAT_EQ(camera.pos[0], turned);
            // An event-owned sample cannot become a turn after the event ends.
            scene.event_run = 1;
            InputLatchPad(0);
            camera.MoveCamera(&pad, rotation, nullptr, 0);
            EXPECT_FLOAT_EQ(camera.pos[0], turned);
            scene.event_run = 0;
            camera.MoveCamera(&pad, rotation, nullptr, 0);
            EXPECT_FLOAT_EQ(camera.pos[0], turned);
        }
    }
    InputSetScriptedDevices({});
    InputSetOverride(0, nullptr);
    PortLoopNo = old_loop;
    DngMainScene = old_scene;
    BattleAreaScene = old_area;
    MainChara__2 = old_chara;
    DngStatus = old_status;
    DebugInfo.debug_camera = old_debug;
    DebugFlag = old_flag;
}

TEST(CameraMouse, DungeonOwnershipKeepsAuthoredModesButAllowsPlayerActions) {
    DungeonGate gate;
    auto &[camera, scene, pad, area, status, chara] = gate;
    auto owns = [&] { return gate.Owns(); };
    EXPECT_TRUE(owns());
    for (int mode : {int(DNG_CAMERA_BOSS), int(DNG_CAMERA_ARENA), 3}) {
        area.camera_mode = mode;
        EXPECT_FALSE(owns());
    }
    area.camera_mode = DNG_CAMERA_FOLLOW_LOW;
    EXPECT_TRUE(owns());
    for (int mode : {DNG_STATUS_MENU, DNG_STATUS_EVENT, DNG_STATUS_EVENT_EDIT,
                     DNG_STATUS_EVENT_MENU, DNG_STATUS_EXIT}) {
        status.mode = mode;
        EXPECT_FALSE(owns());
    }
    status.mode = DNG_STATUS_FIELD;
    status.eye_view = 1;
    EXPECT_FALSE(owns());
    status.eye_view = 0;
    for (int flag : {DNG_PAUSE_PLAYER_CONTROL, DNG_PAUSE_PLAYER_STEP,
                     DNG_PAUSE_FIELD_STEP, DNG_PAUSE_PAD_RESET}) {
        area.pause_flag = flag;
        EXPECT_FALSE(owns());
    }
    area.pause_flag = 0;
    area.script.event_no = 1000;
    EXPECT_FALSE(owns());
    area.script.event_no = -1;
    area.script.running = 1;
    EXPECT_FALSE(owns());
    area.script.running = 0;
    chara.lock_on = 1;
    EXPECT_TRUE(owns());
    chara.lock_on = 0;
    chara.menu_flag = 0;
    EXPECT_TRUE(owns());
    chara.menu_flag = 1;
    chara.hold_type = ACTION_HOLD_STONE;
    EXPECT_TRUE(owns());
    chara.hold_type = ACTION_HOLD_NONE;
    chara.damage_req = ACTION_DAMAGE_REQ_DEAD;
    EXPECT_FALSE(owns());
    chara.damage_req = ACTION_DAMAGE_REQ_NONE;
    scene.event_run = 1;
    EXPECT_FALSE(owns());
    scene.event_run = 0;
    EXPECT_FALSE(gate.Owns(false, true));
    EXPECT_FALSE(gate.Owns(false, false, true));
    EXPECT_FALSE(gate.Owns(false, false, false, true));
    EXPECT_TRUE(owns());
    camera.FollowOff();
    status.eye_view = 1;
    auto eye_owns = [&] { return gate.Owns(true); };
    EXPECT_TRUE(eye_owns());
    chara.hold_type = ACTION_HOLD_STONE;
    EXPECT_FALSE(eye_owns());
    chara.hold_type = ACTION_HOLD_NONE;
    chara.menu_flag = 0;
    EXPECT_FALSE(eye_owns());
    chara.menu_flag = 1;
    chara.lock_on = 1;
    EXPECT_FALSE(eye_owns());
}

TEST(CameraMouse, DungeonFollowOwnershipSurvivesTheDeathEventsFollowOff) {
    DungeonGate gate;
    auto &[camera, scene, pad, area, status, chara] = gate;
    auto owns = [&](bool eye) { return gate.Owns(eye); };
    // The death event's _INITIALIZE runs on the main camera, and nothing turns
    // follow back on; the field loop only turns control back on.
    camera.FollowOff();
    EXPECT_TRUE(owns(false));
    EXPECT_FALSE(owns(true));
    camera.ControlOff();
    EXPECT_FALSE(owns(false));
    camera.ControlOn();
    status.eye_view = 1;
    EXPECT_FALSE(owns(false));
    EXPECT_TRUE(owns(true));
    // Town walking still keeps follow as part of its camera mode.
    EXPECT_FALSE(TownMouseCameraOwns(&camera, &scene, &pad, true, false, false));
}

class DungeonEyeMouse : public testing::TestWithParam<bool> {};

TEST_P(DungeonEyeMouse, LookIsImmediateBoundedAndDoesNotQueueMenuMotion) {
    const unsigned old_photo = TakePhotoMode;
    TakePhotoMode = GetParam() ? TAKE_PHOTO_AIM : TAKE_PHOTO_OFF;
    const int   old_loop = PortLoopNo;
    auto       *old_scene = DngMainScene;
    auto       *old_area = BattleAreaScene;
    auto       *old_chara = MainChara__2;
    const auto  old_status = DngStatus;
    const float old_yaw = viewAngleH__2, old_pitch = viewAngleV__2;
    CScene      scene;
    scene.event_run = 0;
    DNG_BATTLE_AREA area{};
    CActionChara    chara;
    chara.SetPosition(0, 0, 0);
    chara.menu_flag = 1;
    chara.hold_type = ACTION_HOLD_NONE;
    chara.lock_on = 0;
    chara.damage_req = ACTION_DAMAGE_REQ_NONE;
    area.script.event_no = -1;
    DngMainScene = &scene;
    BattleAreaScene = &area;
    MainChara__2 = &chara;
    DngStatus = {};
    DngStatus.eye_view = 1;
    PortLoopNo = LOOP_DUNGEON;
    auto camera = Camera();
    camera.FollowOff();
    camera.SetPos(0, 28, 0);
    camera.SetRef(0, 28, 10);
    scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
    scene.active_camera = 0;
    InputResetBindings();
    InputPadState input{.connected = true};
    InputSetOverride(0, &input);
    viewAngleH__2 = viewAngleV__2 = 0;
    InputSetScriptedDevices({.mouse_dx = 100, .mouse_dy = 10000});
    InputLatchPad(0);
    // First-person entry still has the old follow eye for one update. Refused
    // motion cannot be replayed when the retail eye is placed later in this read.
    camera.SetPos(0, 40, 0);
    camera.Step(1);
    EXPECT_FLOAT_EQ(viewAngleH__2, 0);
    camera.SetPos(0, 28, 0);
    camera.Step(1);
    EXPECT_FLOAT_EQ(viewAngleH__2, 0);
    InputLatchPad(0);
    camera.Step(1);
    EXPECT_LT(viewAngleH__2, -0.1f);
    EXPECT_FLOAT_EQ(viewAngleV__2, 0.65f);
    EXPECT_LT(camera.ref[0], -1);
    EXPECT_FLOAT_EQ(camera.ref[0], camera.next_ref[0]);
    EXPECT_FLOAT_EQ(camera.pos[1], 28);
    const float yaw = viewAngleH__2;
    camera.Step(1);
    EXPECT_FLOAT_EQ(viewAngleH__2, yaw);
    DngStatus.mode = DNG_STATUS_MENU;
    InputLatchPad(0);
    camera.Step(1);
    DngStatus.mode = DNG_STATUS_FIELD;
    camera.Step(1);
    EXPECT_FLOAT_EQ(viewAngleH__2, yaw);
    InputSetScriptedDevices({.mouse_dy = -10000});
    InputLatchPad(0);
    camera.Step(1);
    EXPECT_FLOAT_EQ(viewAngleV__2, -1.0f);
    InputSetScriptedDevices({.mouse_dy = 10});
    InputLatchPad(0);
    camera.Step(1);
    EXPECT_GT(viewAngleV__2, -1.0f);
    InputSetScriptedDevices({});
    InputSetOverride(0, nullptr);
    PortLoopNo = old_loop;
    DngMainScene = old_scene;
    BattleAreaScene = old_area;
    MainChara__2 = old_chara;
    DngStatus = old_status;
    viewAngleH__2 = old_yaw;
    viewAngleV__2 = old_pitch;
    TakePhotoMode = old_photo;
}

INSTANTIATE_TEST_SUITE_P(EyeAndPhoto, DungeonEyeMouse, testing::Bool());

TEST(CameraMouse, EyeLimitsPreserveControllerOvershootAndInvalidSamples) {
    auto  camera = Camera();
    float heading = 0, tilt = 0.67f;
    EXPECT_TRUE(MouseCameraEye(camera, heading, tilt, 0.1f, 0));
    EXPECT_FLOAT_EQ(tilt, 0.67f);
    EXPECT_TRUE(MouseCameraEye(camera, heading, tilt, 0, 0.01f));
    EXPECT_NEAR(tilt, 0.66f, 0.00001f);
    EXPECT_TRUE(MouseCameraEye(camera, heading, tilt, 0, -0.5f));
    EXPECT_NEAR(tilt, 0.66f, 0.00001f);
    const float previous = heading;
    EXPECT_FALSE(MouseCameraEye(camera, heading, tilt, NAN, 0));
    EXPECT_FLOAT_EQ(heading, previous);
    EXPECT_FALSE(MouseCameraEye(camera, heading, tilt, 0, INFINITY));
    EXPECT_NEAR(tilt, 0.66f, 0.00001f);
}
