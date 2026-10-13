#include <gtest/gtest.h>

#include <cmath>
#include <limits>

#include "camera_mouse.hpp"
#include "camera_zoom.hpp"
#include "dng_main.hpp"
#include "mainloop.hpp"
#include "mainloop_port.hpp"
#include "map.hpp"
#include "platform/config.hpp"
#include "platform/input.hpp"
#include "scenesnd.hpp"

namespace {
CCameraControl Camera() {
    CCameraControl camera;
    camera.SetPos(0, 40, 100);
    camera.SetRef(0, 40, 0);
    camera.SetFollow(0, 10, 0);
    camera.SetFollowOffset(0, 30, 0);
    camera.ControlOn();
    camera.SetSpeed(4, 3);
    camera.GetActiveParam()->height = 0;
    return camera;
}

CCPoly Plane(int axis, float distance) {
    CCPoly      poly{};
    const int   a = (axis + 1) % 3, b = (axis + 2) % 3;
    const float coordinates[3][2] = {
        {-2000, -2000},
        {2000,  -2000},
        {0,     2000 }
    };
    for (int i = 0; i < 3; ++i) {
        poly.vertex[i][axis] = distance;
        poly.vertex[i][a] = coordinates[i][0];
        poly.vertex[i][b] = coordinates[i][1];
        poly.vertex[i][3] = 1;
    }
    poly.normal[axis] = 1;
    return poly;
}

float Distance(CCameraControl &camera) {
    return std::hypot(camera.pos[0] - camera.ref[0], camera.pos[2] - camera.ref[2]);
}
} // namespace

TEST(CameraZoom, LimitsDiscardExcessAndReverseImmediately) {
    auto       camera = Camera();
    CameraZoom zoom;
    zoom.Read(camera, 1, false, true);
    EXPECT_FLOAT_EQ(zoom.requested, 92);
    zoom.Read(camera, std::numeric_limits<float>::max(), false, true);
    EXPECT_FLOAT_EQ(zoom.requested, CameraZoom::min_distance);
    zoom.Read(camera, -1, false, true);
    EXPECT_FLOAT_EQ(zoom.requested, CameraZoom::min_distance + CameraZoom::wheel_step);
    zoom.Read(camera, -1000, false, true);
    EXPECT_FLOAT_EQ(zoom.requested, CameraZoom::max_distance);
    zoom.Read(camera, 1, false, true);
    EXPECT_FLOAT_EQ(zoom.requested, CameraZoom::max_distance - CameraZoom::wheel_step);
    zoom.Read(camera, NAN, false, true);
    zoom.Read(camera, INFINITY, false, true);
    EXPECT_FLOAT_EQ(zoom.requested, CameraZoom::max_distance - CameraZoom::wheel_step);
}

TEST(CameraZoom, DisabledAndResetDoNotActivateUntouchedControllerCamera) {
    auto       camera = Camera();
    CameraZoom zoom;
    zoom.Read(camera, 100, false, false);
    EXPECT_FALSE(zoom.active);
    zoom.Read(camera, 0, true, true);
    EXPECT_FALSE(zoom.active);
    zoom.Read(camera, 0, false, true);
    EXPECT_FALSE(zoom.active);
}

TEST(CameraZoom, EasesBeyondRetailRangePersistsWalkingAndRestoresParameters) {
    auto                    camera = Camera();
    const CameraCtrlParam   before = *camera.GetActiveParam();
    CameraZoom              zoom;
    CScene                  scene;
    CCameraControl::Control control{};
    float                   rotation[4]{};
    zoom.Read(camera, -100, false, true);
    zoom.Move(camera, scene, control, rotation);
    EXPECT_FLOAT_EQ(camera.pos[2], 100);
    EXPECT_NEAR(camera.next_pos[2], 600, 0.05f);
    camera.Step(1);
    EXPECT_GT(Distance(camera), 100);
    EXPECT_LT(Distance(camera), 600);
    for (int i = 0; i < 100; ++i) {
        camera.SetFollow(i * 0.5f, 10, 0);
        zoom.Move(camera, scene, control, rotation);
        camera.Step(1);
    }
    EXPECT_NEAR(Distance(camera), 600, 1);
    EXPECT_GT(camera.ref[0], 45);
    EXPECT_FLOAT_EQ(zoom.requested, 600);
    EXPECT_FLOAT_EQ(camera.GetActiveParam()->min_dist, before.min_dist);
    EXPECT_FLOAT_EQ(camera.GetActiveParam()->max_dist, before.max_dist);
    EXPECT_FLOAT_EQ(camera.GetActiveParam()->near_height, before.near_height);
    EXPECT_FLOAT_EQ(camera.GetActiveParam()->far_height, before.far_height);
    EXPECT_EQ(camera.GetActiveParam()->no_check, before.no_check);
}

TEST(CameraZoom, ResetAndDisableImmediatelyReleaseRetailControl) {
    for (bool enabled : {false, true}) {
        auto       camera = Camera();
        CameraZoom zoom;
        zoom.Read(camera, -100, false, true);
        zoom.Read(camera, 0, enabled, enabled);
        EXPECT_FALSE(zoom.active);
        EXPECT_FLOAT_EQ(zoom.requested, camera.GetActiveParam()->min_dist);
    }
}

TEST(CameraZoom, CloseZoomKeepsViewingSlopeAndMousePitchDoesNotSpringBack) {
    auto camera = Camera();
    camera.GetActiveParam()->height = 20;
    CameraZoom              zoom;
    CScene                  scene;
    CCameraControl::Control control{};
    float                   rotation[4]{};
    zoom.Read(camera, 100, false, true);
    for (int i = 0; i < 60; ++i) {
        zoom.Move(camera, scene, control, rotation);
        camera.Step(1);
    }
    EXPECT_NEAR(Distance(camera), 30, 0.1f);
    EXPECT_NEAR(camera.pos[1] - camera.ref[1], 11.4f, 0.1f);
    EXPECT_FLOAT_EQ(camera.GetActiveParam()->height, 20);
    EXPECT_LT(MouseCameraPitch(camera, 0.1f, nullptr, 0, zoom.HeightScale(camera)), 0);
    const float tilted = camera.next_pos[1];
    zoom.Move(camera, scene, control, rotation);
    EXPECT_NEAR(camera.next_pos[1], tilted, 0.01f);
}

TEST(CameraZoom, PadOnlyCameraRemainsRetailWithOptionOffOrOn) {
    for (bool enabled : {false, true}) {
        auto    camera = Camera();
        auto    retail = camera;
        CScene &scene = *GetMainScene();
        scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
        scene.active_camera = 0;
        PortLoopNo = LOOP_EDIT;
        GamePad__2.key_lock = scene.event_run = 0;
        const_cast<Config &>(ConfigGet()).mouse_zoom = enabled;
        InputResetBindings();
        InputPadState input{.connected = true};
        InputSetOverride(0, &input);
        CPadControl pad{};
        pad.Initialize();
        CCameraControl::Control control{};
        float                   rotation[4]{};
        for (int frame = 0; frame < 60; ++frame) {
            camera.SetFollow(frame, 10, frame * 0.5f);
            retail.SetFollow(frame, 10, frame * 0.5f);
            InputLatchPad(0);
            camera.MoveCamera(&pad, rotation, nullptr, 0);
            retail.MoveCamera(&control, rotation, nullptr, 0);
            camera.Step(1);
            retail.Step(1);
            for (int axis = 0; axis < 3; ++axis) {
                EXPECT_FLOAT_EQ(camera.pos[axis], retail.pos[axis]);
                EXPECT_FLOAT_EQ(camera.ref[axis], retail.ref[axis]);
                EXPECT_FLOAT_EQ(camera.next_pos[axis], retail.next_pos[axis]);
            }
        }
        InputSetOverride(0, nullptr);
    }
}

TEST(CameraZoom, DungeonMenusEventsLockOnAndEyeViewOwnWheelAndReset) {
    CScene scene;
    scene.event_run = 0;
    DNG_BATTLE_AREA area{};
    CActionChara    chara;
    chara.menu_flag = 1;
    chara.hold_type = ACTION_HOLD_NONE;
    chara.lock_on = 0;
    chara.damage_req = ACTION_DAMAGE_REQ_NONE;
    area.script.event_no = -1;
    DngMainScene = &scene;
    BattleAreaScene = &area;
    MainChara__2 = &chara;
    DngStatus = {};
    NowFloorInfoPtr = nullptr;
    DebugFlag = DebugInfo.debug_camera = 0;
    PortLoopNo = LOOP_DUNGEON;
    const_cast<Config &>(ConfigGet()).mouse_zoom = true;
    HostSettings settings;
    settings.mouse_zoom = true;
    InputResetBindings();
    InputApplyConfig(settings);
    InputPadState input{.connected = true};
    InputSetOverride(0, &input);
    CPadControl pad{};
    pad.Initialize();
    auto camera = Camera();
    scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
    scene.active_camera = 0;
    area.camera_mode = DNG_CAMERA_FOLLOW;
    float rotation[4]{};
    InputSetScriptedDevices({.mouse_wheel = -10});
    InputLatchPad(0);
    camera.MoveCamera(&pad, rotation, nullptr, 0);
    const float distance = camera.next_pos[2];
    EXPECT_GT(distance, 160);
    for (int owner = 0; owner < 7; ++owner) {
        DngStatus.mode = owner == 0 ? DNG_STATUS_MENU : DNG_STATUS_FIELD;
        area.script.running = owner == 1;
        chara.lock_on = owner == 2;
        DngStatus.eye_view = owner == 3;
        area.pause_flag = owner == 4 ? DNG_PAUSE_PLAYER_CONTROL : 0;
        chara.hold_type = owner == 5 ? ACTION_HOLD_STONE : ACTION_HOLD_NONE;
        chara.menu_flag = owner != 6;
        InputSetScriptedDevices({.mouse_buttons = 1u << 2, .mouse_wheel = 100});
        InputLatchPad(0);
        camera.MoveCamera(&pad, rotation, nullptr, 0);
        EXPECT_LE(camera.next_pos[2], camera.GetActiveParam()->max_dist + 0.1f);
        DngStatus.mode = DNG_STATUS_FIELD;
        area.script.running = chara.lock_on = DngStatus.eye_view = area.pause_flag = 0;
        chara.hold_type = ACTION_HOLD_NONE;
        chara.menu_flag = 1;
        camera.MoveCamera(&pad, rotation, nullptr, 0);
        EXPECT_NEAR(camera.next_pos[2], distance, 0.02f) << owner;
    }
    // A new map discards the old preference without a wheel event.
    InputSetScriptedDevices({});
    InputLatchPad(0);
    ++scene.now_map_no;
    camera.MoveCamera(&pad, rotation, nullptr, 0);
    EXPECT_LE(camera.next_pos[2], camera.GetActiveParam()->max_dist + 0.1f);
    InputSetOverride(0, nullptr);
}

TEST(CameraZoom, ContinuousCorridorClampsBeforeThinWallAndCanReverse) {
    auto camera = Camera();
    auto candidate = camera;
    candidate.next_pos[2] = 300;
    auto wall = Plane(2, 150);
    EXPECT_GT(MouseCameraClampFollow(camera, candidate, &wall, 1), -1);
    EXPECT_LT(camera.next_pos[2], 146);
    EXPECT_GT(camera.next_pos[2], 140);
    EXPECT_FLOAT_EQ(camera.pos[2], 100);
    for (int i = 0; i < 80; ++i) {
        camera.Step(1);
    }
    candidate = camera;
    candidate.next_pos[2] = 30;
    EXPECT_FLOAT_EQ(MouseCameraClampFollow(camera, candidate, &wall, 1), 1);
    EXPECT_FLOAT_EQ(camera.next_pos[2], 30);
}

TEST(CameraZoom, CeilingAndFloorKeepClearanceAcrossTheEasedPath) {
    for (float destination : {-80.0f, 120.0f}) {
        auto camera = Camera();
        auto candidate = camera;
        candidate.next_pos[1] = destination;
        CCPoly polys[2] = {Plane(1, 0), Plane(1, 70)};
        EXPECT_GT(MouseCameraClampFollow(camera, candidate, polys, 2), 0);
        EXPECT_GT(camera.next_pos[1], 4);
        EXPECT_LT(camera.next_pos[1], 66);
    }
}

TEST(CameraZoom, UnprovableCorridorReportsFailureForRetailFallback) {
    for (int count : {-1, 512, 1}) {
        auto camera = Camera();
        auto candidate = camera;
        candidate.next_pos[2] = 300;
        CCPoly invalid{};
        EXPECT_FLOAT_EQ(MouseCameraClampFollow(camera, candidate, &invalid, count), -1);
        EXPECT_FLOAT_EQ(camera.next_pos[2], 100);
        EXPECT_FLOAT_EQ(camera.next_ref[1], 40);
    }
    auto camera = Camera();
    auto candidate = camera;
    candidate.next_pos[2] = 30;
    auto wall = Plane(2, 50);
    EXPECT_FLOAT_EQ(MouseCameraClampFollow(camera, candidate, &wall, 1), -1);
    EXPECT_FLOAT_EQ(camera.next_pos[2], 100);
}

TEST(CameraZoom, StaleBlockedPendingPoseCanRecoverFromClearActualPose) {
    auto camera = Camera();
    camera.next_pos[2] = 250;
    auto candidate = camera;
    candidate.next_pos[2] = 30;
    auto wall = Plane(2, 150);
    EXPECT_FLOAT_EQ(MouseCameraClampFollow(camera, candidate, &wall, 1), 1);
    EXPECT_FLOAT_EQ(camera.pos[2], 100);
    EXPECT_FLOAT_EQ(camera.next_pos[2], 30);
}

TEST(CameraZoom, IndependentEyeAndTargetEasingCannotCrossCorridorWall) {
    auto camera = Camera();
    auto candidate = camera;
    candidate.next_ref[0] = candidate.next_pos[0] = 100;
    candidate.next_pos[2] = -100;
    auto wall = Plane(0, 50);
    EXPECT_LT(MouseCameraClampFollow(camera, candidate, &wall, 1), 1);
    EXPECT_LT(camera.next_pos[0], 46);
    EXPECT_LT(camera.next_ref[0], 46);
}

TEST(CameraZoom, TownConsumesWheelOnceAndRejectsLockedMenuAndEventSamples) {
    auto    camera = Camera();
    CScene &scene = *GetMainScene();
    scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
    scene.active_camera = 0;
    scene.event_run = 0;
    PortLoopNo = LOOP_EDIT;
    GamePad__2.key_lock = 0;
    const bool old_option = ConfigGet().mouse_zoom;
    const_cast<Config &>(ConfigGet()).mouse_zoom = true;
    HostSettings settings;
    settings.mouse_zoom = true;
    InputResetBindings();
    InputApplyConfig(settings);
    InputPadState input{.connected = true};
    InputSetOverride(0, &input);
    InputSetScriptedDevices({.mouse_wheel = -10});
    InputLatchPad(0);
    CPadControl pad{};
    pad.Initialize();
    float rotation[4]{};
    camera.MoveCamera(&pad, rotation, nullptr, 0);
    const float once = camera.next_pos[2];
    EXPECT_GT(once, 160);
    camera.MoveCamera(&pad, rotation, nullptr, 0);
    EXPECT_FLOAT_EQ(camera.next_pos[2], once);
    for (bool event : {false, true}) {
        InputLatchPad(0);
        GamePad__2.key_lock = !event;
        scene.event_run = event;
        camera.MoveCamera(&pad, rotation, nullptr, 0);
        GamePad__2.key_lock = 0;
        scene.event_run = 0;
        camera.MoveCamera(&pad, rotation, nullptr, 0);
        EXPECT_NEAR(camera.next_pos[2], once, 0.02f);
    }
    InputSetScriptedDevices({.mouse_buttons = 1u << 2});
    InputLatchPad(0);
    camera.MoveCamera(&pad, rotation, nullptr, 0);
    EXPECT_LE(camera.next_pos[2], camera.GetActiveParam()->max_dist + 0.02f);
    InputSetScriptedDevices({});
    InputSetOverride(0, nullptr);
    InputResetBindings();
    const_cast<Config &>(ConfigGet()).mouse_zoom = old_option;
}

TEST(CameraZoom, UnprovableActualPoseFallsBackToRetailFollow) {
    auto camera = Camera();
    camera.pos[0] = NAN;
    camera.SetFollow(25, 10, 0);
    auto                    retail = camera;
    CameraZoom              zoom;
    CScene                  scene;
    CCameraControl::Control control{};
    float                   rotation[4]{};
    zoom.Read(camera, -100, false, true);
    zoom.Move(camera, scene, control, rotation);
    retail.MoveCamera(&control, rotation, nullptr, 0);
    for (int axis = 0; axis < 3; ++axis) {
        EXPECT_FLOAT_EQ(camera.next_pos[axis], retail.next_pos[axis]);
        EXPECT_FLOAT_EQ(camera.next_ref[axis], retail.next_ref[axis]);
    }
}

TEST(CameraZoom, CallerPolygonsLimitZoomAndInvalidStartingWallKeepsFollowing) {
    CScene                  scene;
    CCameraControl::Control control{};
    float                   rotation[4]{};
    for (float distance : {150.0f, 50.0f}) {
        auto camera = Camera();
        camera.SetFollow(10, 10, 0);
        CameraZoom zoom;
        zoom.Read(camera, -100, false, true);
        auto wall = Plane(2, distance);
        zoom.Move(camera, scene, control, rotation, &wall, 1);
        EXPECT_LT(camera.next_pos[2], distance);
        EXPECT_GT(camera.next_ref[0], 0);
    }
}

TEST(CameraZoom, RetailAutoMoveStillAvoidsPipeObstaclesUnlessCancelled) {
    CScene                  scene;
    CCameraControl::Control control{};
    float                   rotation[4]{};
    CCPoly                  wall{};
    float                   vertices[3][4] = {
        {3, -1000, 150, 1},
        {3, 1000,  150, 1},
        {4, 0,     250, 1}
    };
    for (int i = 0; i < 3; ++i) {
        for (int j = 0; j < 4; ++j) {
            wall.vertex[i][j] = vertices[i][j];
        }
    }
    wall.normal[0] = 1;
    wall.normal[2] = -0.01f;
    for (bool cancel : {false, true}) {
        auto camera = Camera();
        if (cancel) {
            camera.rot_cancel |= CAMERA_ROT_CANCEL_AUTO_MOVE;
        }
        CameraZoom zoom;
        zoom.Read(camera, -25, false, true);
        zoom.Move(camera, scene, control, rotation, &wall, 1);
        if (cancel) {
            EXPECT_FLOAT_EQ(camera.next_pos[0], 0);
        } else {
            EXPECT_NE(camera.next_pos[0], 0);
        }
    }
}

TEST(CameraZoom, FinalAvoidanceCorridorRecollectsSceneGeometry) {
    class CorridorMap : public CMap {
    public:
        CorridorMap() {
            place_parts = nullptr;
            place_parts_num = 0;
        }

        int    queries = 0;
        bool   final_wall_collected = false;
        CCPoly trigger{};

        int GetCameraPoly(CCPoly *out, mgVu0FBOX &box, int) override {
            ++queries;
            out[0] = trigger;
            // A second wall outside the original eight-unit lateral envelope.
            if (box.max[0] >= 10) {
                final_wall_collected = true;
                out[1] = Plane(0, 10);
                return 2;
            }
            if (box.min[0] <= -10) {
                final_wall_collected = true;
                out[1] = Plane(0, -10);
                return 2;
            }
            return 1;
        }
    } map;

    const float vertices[3][4] = {
        {3, -1000, 150, 1},
        {3, 1000,  150, 1},
        {4, 0,     250, 1}
    };
    for (int i = 0; i < 3; ++i) {
        std::copy_n(vertices[i], 4, map.trigger.vertex[i]);
    }
    map.trigger.normal[0] = 1;
    map.trigger.normal[2] = -0.01f;
    CScene scene;
    scene.AssignMap(0, &map, const_cast<char *>("map"));
    scene.active_map = 0;
    scene.map[0].status |= SCENE_DATA_ACTIVE;
    auto       camera = Camera();
    CameraZoom zoom;
    zoom.Read(camera, -100, false, true);
    CCameraControl::Control control{};
    float                   rotation[4]{};
    zoom.Move(camera, scene, control, rotation);
    EXPECT_GE(map.queries, 2);
    EXPECT_TRUE(map.final_wall_collected);
    EXPECT_LT(std::fabs(camera.next_pos[0]), 6);
}

TEST(CameraZoom, OverlappingSceneAndCallerPolygonsCountOnceAboveHalfCapacity) {
    class OverlapMap : public CMap {
    public:
        std::vector<CCPoly> polygons;

        OverlapMap() {
            place_parts = nullptr;
            place_parts_num = 0;
            for (int i = 0; i < 300; ++i) {
                polygons.push_back(Plane(0, 1000.0f + i));
            }
        }

        int GetCameraPoly(CCPoly *out, mgVu0FBOX &, int capacity) override {
            const int count = std::min(capacity, static_cast<int>(polygons.size()));
            std::copy_n(polygons.begin(), count, out);
            return count;
        }
    } map;

    CScene scene;
    scene.AssignMap(0, &map, const_cast<char *>("map"));
    scene.active_map = 0;
    scene.map[0].status |= SCENE_DATA_ACTIVE;
    for (bool overlap : {true, false}) {
        auto caller = map.polygons;
        if (!overlap) {
            for (auto &poly : caller) {
                poly.attr = 1;
            }
        }
        auto       camera = Camera();
        CameraZoom zoom;
        zoom.Read(camera, -100, false, true);
        CCameraControl::Control control{};
        float                   rotation[4]{};
        zoom.Move(camera, scene, control, rotation, caller.data(), static_cast<int>(caller.size()));
        if (overlap) {
            EXPECT_NEAR(camera.next_pos[2], 600, 0.05f);
        } else {
            EXPECT_LT(camera.next_pos[2], 200); // Distinct attributes retain the capacity fallback.
        }
    }
}
