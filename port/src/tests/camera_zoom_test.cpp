#include <gtest/gtest.h>

#include <algorithm>
#include <cmath>
#include <cstddef>
#include <limits>
#include <numbers>
#include <utility>
#include <vector>

#include "camera_mouse.hpp"
#include "camera_zoom.hpp"
#include "dng_main.hpp"
#include "gameutil.hpp"
#include "mainloop.hpp"
#include "map.hpp"
#include "platform/config.hpp"
#include "platform/game_loop_state.hpp"
#include "platform/input.hpp"
#include "render/renderer.hpp"
#include "scenesnd.hpp"
#include "scoped_global_object.hpp"

namespace {
struct GlobalCameraCleanup {
    CScene &scene;

    ~GlobalCameraCleanup() { scene.GetSceneCamera(0)->Initialize(); }
};

/**
 * Restores a moved scene-map slot before its replacement map leaves scope.
 */
struct GlobalMapCleanup {
    CScene   &scene;
    CSceneMap saved_map;
    int       saved_active;

    explicit GlobalMapCleanup(CScene &value)
        : scene(value), saved_map(std::move(value.map[0])), saved_active(value.active_map) {}

    ~GlobalMapCleanup() {
        scene.map[0] = std::move(saved_map);
        scene.active_map = saved_active;
    }
};

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
    const int   a = (axis + 1) % 3;
    const int   b = (axis + 2) % 3;
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
        auto                camera = Camera();
        auto                retail = camera;
        CScene             &scene = *GetMainScene();
        GlobalCameraCleanup clear_camera{scene};
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
    dc2::test::ScopedGlobalObject<DngMainScene> scene_owner;
    auto                                       &scene = scene_owner.Get();
    scene.event_run = 0;
    dc2::test::ScopedGlobalObject<BattleAreaScene> area_owner;
    auto                                          &area = area_owner.Get();
    dc2::test::ScopedGlobalObject<MainChara__2>    chara_owner;
    auto                                          &chara = chara_owner.Get();
    chara.menu_flag = 1;
    chara.hold_type = ACTION_HOLD_NONE;
    chara.lock_on = 0;
    chara.damage_req = ACTION_DAMAGE_REQ_NONE;
    area.script.event_no = -1;
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
        if (owner >= 5) {
            // Carrying and attacks keep the selected distance but take no wheel or reset.
            EXPECT_NEAR(camera.next_pos[2], distance, 0.02f) << owner;
        } else {
            EXPECT_LE(camera.next_pos[2], camera.GetActiveParam()->max_dist + 0.1f) << owner;
        }
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

namespace {
// One field tick: the character moves, the camera follows, then eases.
void Tick(CCameraControl &camera, CameraZoom &zoom, CScene &scene, CCPoly *polys, int count, float x) {
    CCameraControl::Control control{};
    float                   rotation[4]{};
    camera.SetFollow(x, 10, 0);
    zoom.Move(camera, scene, control, rotation, polys, count);
    camera.Step(1);
}

float PendingDistance(CCameraControl &camera) {
    return std::hypot(camera.next_pos[0] - camera.next_ref[0], camera.next_pos[2] - camera.next_ref[2]);
}

float Travel(const float *from, const float *to) {
    return std::sqrt((to[0] - from[0]) * (to[0] - from[0]) + (to[1] - from[1]) * (to[1] - from[1]) +
                     (to[2] - from[2]) * (to[2] - from[2]));
}

CCPoly Triangle(const float (&a)[3], const float (&b)[3], const float (&c)[3], const float (&normal)[3]) {
    CCPoly poly{};
    for (int i = 0; i < 3; ++i) {
        poly.vertex[0][i] = a[i];
        poly.vertex[1][i] = b[i];
        poly.vertex[2][i] = c[i];
        poly.normal[i] = normal[i];
    }
    poly.vertex[0][3] = poly.vertex[1][3] = poly.vertex[2][3] = 1;
    return poly;
}

// A ten-unit-wide pillar at (x, z): two crossed faces block views from any side.
void Pillar(float x, float z, CCPoly *out) {
    out[0] = Triangle({x - 5, -1000, z}, {x + 5, -1000, z}, {x - 5, 1000, z}, {0, 0, 1});
    out[1] = Triangle({x + 5, -1000, z}, {x + 5, 1000, z}, {x - 5, 1000, z}, {0, 0, 1});
    out[2] = Triangle({x, -1000, z - 5}, {x, -1000, z + 5}, {x, 1000, z - 5}, {1, 0, 0});
    out[3] = Triangle({x, -1000, z + 5}, {x, 1000, z + 5}, {x, 1000, z - 5}, {1, 0, 0});
}
} // namespace

TEST(CameraZoom, IntermittentPillarsDoNotPumpTheDistance) {
    // Twelve pillars on a ring around the player while the camera orbits, so
    // the zoomed view keeps sweeping across them like a cave's rocks.
    constexpr int pillar_count = 12;
    CCPoly        pillars[pillar_count * 4];
    for (int i = 0; i < pillar_count; ++i) {
        const float angle = (i + 0.5f) * 2 * std::numbers::pi_v<float> / pillar_count;
        Pillar(300 * std::sin(angle), 300 * std::cos(angle), pillars + static_cast<std::ptrdiff_t>(i) * 4);
    }
    auto       camera = Camera();
    CameraZoom zoom;
    CScene     scene;
    zoom.Read(camera, -100, false, true);
    int   pull_ins = 0;
    int   cuts = 0;
    float previous = PendingDistance(camera);
    float largest = 0;
    float eye[3] = {camera.pos[0], camera.pos[1], camera.pos[2]};
    for (int i = 0; i < 1800; ++i) {
        CCameraControl::Control control{};
        control.rot = 0.01f;
        float      rotation[4]{};
        const auto generation = mgPortCameraGeneration();
        zoom.Move(camera, scene, control, rotation, pillars, pillar_count * 4);
        camera.Step(1);
        const float distance = PendingDistance(camera);
        pull_ins += distance < previous - 20;
        if (mgPortCameraGeneration() != generation) {
            ++cuts;
        } else if (i >= 30) {
            // After the wheel's own easing, uncut motion stays small per tick.
            largest = std::max(largest, Travel(eye, camera.pos));
        }
        previous = distance;
        std::copy_n(camera.pos, 3, eye);
        float hit[4];
        EXPECT_LT(CheckHit(pillars, pillar_count * 4, camera.ref, camera.pos, hit, 1, 0), 0) << i;
    }
    // About thirty pillar crossings in thirty seconds. The distance comes back
    // only while the view it is turning toward stays clear, so it settles inside
    // the ring rather than returning toward each next pillar.
    EXPECT_LE(pull_ins, 2);
    EXPECT_LE(cuts, 2);
    EXPECT_LT(largest, 40);
}

TEST(CameraZoom, WallLimitsDistanceSteadilyWhileTargetKeepsFollowing) {
    auto       camera = Camera();
    CameraZoom zoom;
    CScene     scene;
    auto       wall = Plane(2, 150);
    zoom.Read(camera, -100, false, true);
    float previous = 0;
    for (int i = 0; i < 120; ++i) {
        Tick(camera, zoom, scene, &wall, 1, i * 0.5f);
        // The look-at point is never held back by the wall.
        EXPECT_FLOAT_EQ(camera.next_ref[0], i * 0.5f);
        EXPECT_LT(camera.next_pos[2], 150);
        EXPECT_LT(camera.pos[2], 150);
        const float distance = PendingDistance(camera);
        if (i > 0) {
            EXPECT_NEAR(distance, previous, 0.5f) << i;
        }
        previous = distance;
    }
    EXPECT_GT(previous, 130);
    EXPECT_FLOAT_EQ(zoom.requested, 600);
}

TEST(CameraZoom, EasedEyeBehindANewWallIsBroughtInFrontOfItAndCutsInterpolation) {
    auto       camera = Camera();
    CameraZoom zoom;
    CScene     scene;
    zoom.Read(camera, -100, false, true);
    for (int i = 0; i < 120; ++i) {
        Tick(camera, zoom, scene, nullptr, 0, 0);
    }
    EXPECT_NEAR(camera.pos[2], 600, 1);
    auto                    wall = Plane(2, 200);
    CCameraControl::Control control{};
    float                   rotation[4]{};
    const auto              generation = mgPortCameraGeneration();
    zoom.Move(camera, scene, control, rotation, &wall, 1);
    EXPECT_LT(camera.next_pos[2], 200);
    EXPECT_LT(camera.pos[2], 200);
    EXPECT_GT(camera.pos[2], 150);
    // Display frames between the ticks must not blend through the wall.
    EXPECT_NE(mgPortCameraGeneration(), generation);
}

TEST(CameraZoom, WheelRightAfterAVisibilitySnapEasesAtTheCameraSpeed) {
    auto       camera = Camera();
    CameraZoom zoom;
    CScene     scene;
    zoom.Read(camera, -100, false, true);
    for (int i = 0; i < 120; ++i) {
        Tick(camera, zoom, scene, nullptr, 0, 0);
    }
    auto                    wall = Plane(2, 200);
    CCameraControl::Control control{};
    float                   rotation[4]{};
    zoom.Move(camera, scene, control, rotation, &wall, 1);
    ASSERT_LT(camera.pos[2], 200);
    // Zooming in at once afterwards eases from the corrected eye, as any wheel
    // request does, rather than jumping to the new destination.
    zoom.Read(camera, 100, false, true);
    for (int i = 0; i < 10; ++i) {
        const float before = camera.pos[2];
        const auto  generation = mgPortCameraGeneration();
        zoom.Move(camera, scene, control, rotation, &wall, 1);
        const float next = camera.next_pos[2];
        camera.Step(1);
        EXPECT_EQ(mgPortCameraGeneration(), generation) << i;
        EXPECT_NEAR(camera.pos[2], before + (next - before) / 4, 0.01f) << i;
        if (i == 0) {
            EXPECT_GT(camera.pos[2], 150);
        }
    }
}

namespace {
// Rendered and pending views point the same way around the look-at point.
bool SameDirection(CCameraControl &camera) {
    return (camera.pos[0] - camera.ref[0]) * (camera.next_pos[0] - camera.next_ref[0]) +
               (camera.pos[2] - camera.ref[2]) * (camera.next_pos[2] - camera.next_ref[2]) >
           0;
}

bool Hidden(CCameraControl &camera, CCPoly &wall) {
    float hit[4];
    return CheckHit(&wall, 1, camera.ref, camera.pos, hit, 1, 0) >= 0;
}
} // namespace

TEST(CameraZoom, WalkingAwayAfterAVisibilitySnapKeepsOneViewDirection) {
    // A wall just behind the player snaps the zoomed eye in close; the player
    // then runs away from it faster than the look-at point eases.
    auto       camera = Camera();
    CameraZoom zoom;
    CScene     scene;
    auto       wall = Plane(2, 20);
    zoom.Read(camera, -100, false, true);
    float eye[3] = {camera.pos[0], camera.pos[1], camera.pos[2]};
    for (int i = 0; i < 80; ++i) {
        CCameraControl::Control control{};
        float                   rotation[4]{};
        const auto              generation = mgPortCameraGeneration();
        camera.SetFollow(0, 10, -10.0f * i);
        zoom.Move(camera, scene, control, rotation, &wall, 1);
        camera.Step(1);
        EXPECT_TRUE(SameDirection(camera)) << i;
        EXPECT_FALSE(Hidden(camera, wall)) << i;
        if (i > 0 && mgPortCameraGeneration() == generation) {
            EXPECT_LT(Travel(eye, camera.pos), 25) << i;
        }
        std::copy_n(camera.pos, 3, eye);
    }
}

TEST(CameraZoom, BackingIntoAWallThenAwayReturnsToRetailDistanceAtOnce) {
    // The player walks toward the eye until a wall behind squeezes it in, as
    // retail's eye would be, then walks away again.
    auto       camera = Camera();
    CameraZoom zoom;
    CScene     scene;
    auto       wall = Plane(2, 200);
    zoom.Read(camera, -100, false, true);
    float eye[3] = {camera.pos[0], camera.pos[1], camera.pos[2]};
    float z = 0;
    for (int i = 0; i < 110; ++i) {
        CCameraControl::Control control{};
        float                   rotation[4]{};
        const auto              generation = mgPortCameraGeneration();
        if (i < 29) {
            z = 6.0f * i;
        } else if (i >= 50) {
            z -= 10;
        }
        camera.SetFollow(0, 10, z);
        zoom.Move(camera, scene, control, rotation, &wall, 1);
        camera.Step(1);
        EXPECT_TRUE(SameDirection(camera)) << i;
        EXPECT_FALSE(Hidden(camera, wall)) << i;
        if (i > 0 && mgPortCameraGeneration() == generation) {
            EXPECT_LT(Travel(eye, camera.pos), 25) << i;
        }
        std::copy_n(camera.pos, 3, eye);
        if (i == 48) {
            EXPECT_LT(PendingDistance(camera), 30);
        }
        // Inside retail's own follow distance the eye is free again as soon as
        // retail's would be, without waiting out a hold.
        if (i >= 70) {
            EXPECT_GE(PendingDistance(camera), camera.GetActiveParam()->min_dist - 0.5f) << i;
        }
    }
}

TEST(CameraZoom, BackingIntoAWallThenAwayReturnsToTheChosenDistance) {
    // The player keeps walking toward the eye until a wall behind it squeezes
    // the eye right in, stands there, then walks well away and stops.
    auto       camera = Camera();
    CameraZoom zoom;
    CScene     scene;
    auto       wall = Plane(2, 200);
    zoom.Read(camera, -100, false, true);
    float z = 0;
    float previous = 0;
    for (int i = 0; i < 200; ++i) {
        if (i < 29) {
            z = 6.0f * i;
        } else if (i >= 50 && i < 110) {
            z -= 10;
        }
        CCameraControl::Control control{};
        float                   rotation[4]{};
        camera.SetFollow(0, 10, z);
        zoom.Move(camera, scene, control, rotation, &wall, 1);
        camera.Step(1);
        const float distance = PendingDistance(camera);
        // One wall is one pull-in, however far the eye is squeezed.
        EXPECT_LE(zoom.strikes, 1) << i;
        EXPECT_EQ(zoom.hold, 0) << i;
        if (i >= 110) {
            EXPECT_GE(distance, previous - 0.02f) << i;
        }
        previous = distance;
    }
    // Retail's eye is back out in a few ticks; the chosen distance is back
    // while the player is still walking away, not after a long hold.
    EXPECT_NEAR(previous, 600, 0.5f);
}

TEST(CameraZoom, RepeatedPullInsStillHoldTheShorterDistance) {
    auto       camera = Camera();
    CameraZoom zoom;
    CScene     scene;
    auto       wall = Plane(2, 150);
    zoom.Read(camera, -100, false, true);
    // Returns the hold the wall sets.
    auto pull_in = [&] {
        int hold = 0;
        for (int i = 0; i < 10; ++i) {
            Tick(camera, zoom, scene, &wall, 1, 0);
            hold = std::max(hold, zoom.hold);
        }
        EXPECT_LT(PendingDistance(camera), 150);
        return hold;
    };
    auto return_out = [&] {
        for (int i = 0; i < 400 && zoom.pulled; ++i) {
            Tick(camera, zoom, scene, nullptr, 0, 0);
        }
        EXPECT_FALSE(zoom.pulled);
    };
    EXPECT_EQ(pull_in(), 0);
    return_out();
    // A wall met again soon after is held, longer each time.
    EXPECT_EQ(pull_in(), CameraZoom::hold_ticks);
    return_out();
    EXPECT_EQ(pull_in(), CameraZoom::hold_ticks * 2);
    // A quiet period forgets them again.
    return_out();
    for (int i = 0; i < CameraZoom::calm_ticks * 3; ++i) {
        Tick(camera, zoom, scene, nullptr, 0, 0);
    }
    EXPECT_EQ(pull_in(), 0);
}

TEST(CameraZoom, SmallPullInsNeitherCountNorHold) {
    // After two wall pull-ins, the second held, the wall creeps in a few units
    // at a time, as foliage brushing a still view does.
    auto       camera = Camera();
    CameraZoom zoom;
    CScene     scene;
    auto       near_wall = Plane(2, 150);
    zoom.Read(camera, -100, false, true);
    for (int i = 0; i < 10; ++i) {
        Tick(camera, zoom, scene, &near_wall, 1, 0);
    }
    for (int i = 0; i < 400 && zoom.allowed < zoom.requested; ++i) {
        Tick(camera, zoom, scene, nullptr, 0, 0);
    }
    ASSERT_FLOAT_EQ(zoom.allowed, zoom.requested);
    float z = 300;
    auto  wall = Plane(2, z);
    Tick(camera, zoom, scene, &wall, 1, 0);
    EXPECT_EQ(zoom.strikes, 2);
    EXPECT_EQ(zoom.hold, CameraZoom::hold_ticks);
    for (int i = 0; i < CameraZoom::calm_ticks + 300; ++i) {
        if (i % 30 == 29) {
            z -= CameraZoom::minor_pull_in / 2;
            wall = Plane(2, z);
        }
        Tick(camera, zoom, scene, &wall, 1, 0);
        EXPECT_LT(camera.next_pos[2], z) << i;
        // The hold runs out and is not taken up again.
        if (i >= CameraZoom::hold_ticks) {
            EXPECT_EQ(zoom.hold, 0) << i;
        }
    }
    // The eye followed the wall in, and the quiet period forgot a pull-in.
    EXPECT_LT(z, 250);
    EXPECT_EQ(zoom.strikes, 1);
}

TEST(CameraZoom, RenderedViewStaysClearWhileEyeAndTargetEaseSeparately) {
    auto camera = Camera();
    camera.SetPos(0, 40, 600);
    CameraZoom zoom;
    CScene     scene;
    // A wall beside the player's path, between the eased eye and target views.
    auto wall = Triangle({1.5f, -2000, 30}, {1.5f, 2000, 30}, {1.5f, 0, 2000}, {1, 0, 0});
    zoom.Read(camera, -100, false, true);
    for (int i = 0; i < 40; ++i) {
        Tick(camera, zoom, scene, &wall, 1, i * 3.0f);
        float hit[4];
        EXPECT_LT(CheckHit(&wall, 1, camera.ref, camera.pos, hit, 1, 0), 0) << i;
        EXPECT_FLOAT_EQ(camera.next_ref[0], i * 3.0f);
    }
}

namespace {
// Whether a display frame blending the drawn pose before a step with the one
// after it shows the view through a wall.
bool BlendHidden(const float *eye_a, const float *ref_a, CCameraControl &camera, CCPoly *walls, int count) {
    for (int k = 1; k < 64; ++k) {
        const float alpha = k / 64.0f;
        float       eye[4] = {0, 0, 0, 1};
        float       ref[4] = {0, 0, 0, 1};
        float       hit[4];
        for (int i = 0; i < 3; ++i) {
            eye[i] = eye_a[i] + (camera.pos[i] - eye_a[i]) * alpha;
            ref[i] = ref_a[i] + (camera.ref[i] - ref_a[i]) * alpha;
        }
        if (CheckHit(walls, count, ref, eye, hit, 1, 0) >= 0) {
            return true;
        }
    }
    return false;
}
} // namespace

TEST(CameraZoom, ViewSweepingAcrossAPostCutsInterpolation) {
    // Both drawn views pass beside a thin post, but the view sweeps across it
    // as the eye and target ease sideways, so frames in between would show it.
    for (const float x : {0.0f, 20.0f}) {
        auto camera = Camera();
        camera.SetPos(-1, 40, 600);
        camera.SetRef(-1, 40, 0);
        camera.SetNextPos(7, 40, 600);
        camera.SetNextRef(5, 40, 0);
        camera.SetFollow(5, 10, 0);
        camera.rot_cancel |= CAMERA_ROT_CANCEL_AUTO_MOVE;
        CameraZoom zoom;
        CScene     scene;
        zoom.Read(camera, -100, false, true);
        CCPoly      post[2] = {Triangle({x - 0.1f, -1000, 300}, {x + 0.1f, -1000, 300}, {x - 0.1f, 1000, 300}, {0, 0, 1}),
                               Triangle({x + 0.1f, -1000, 300}, {x + 0.1f, 1000, 300}, {x - 0.1f, 1000, 300}, {0, 0, 1})};
        const float eye[3] = {camera.pos[0], camera.pos[1], camera.pos[2]};
        const float ref[3] = {camera.ref[0], camera.ref[1], camera.ref[2]};
        const auto  generation = mgPortCameraGeneration();
        Tick(camera, zoom, scene, post, 2, 5);
        float hit[4];
        EXPECT_LT(CheckHit(post, 2, camera.ref, camera.pos, hit, 1, 0), 0) << x;
        const bool hidden = BlendHidden(eye, ref, camera, post, 2);
        EXPECT_EQ(hidden, x == 0) << x;
        // Interpolation is cut exactly when a blended frame would show the post.
        EXPECT_EQ(mgPortCameraGeneration() != generation, hidden) << x;
    }
}

TEST(CameraZoom, ClearedWallEasesBackOutWithoutJumping) {
    auto       camera = Camera();
    CameraZoom zoom;
    CScene     scene;
    auto       wall = Plane(2, 150);
    zoom.Read(camera, -100, false, true);
    for (int i = 0; i < 60; ++i) {
        Tick(camera, zoom, scene, &wall, 1, 0);
    }
    float previous = PendingDistance(camera);
    EXPECT_LT(previous, 150);
    for (int i = 0; i < 400; ++i) {
        Tick(camera, zoom, scene, nullptr, 0, 0);
        const float distance = PendingDistance(camera);
        const float step = std::max(CameraZoom::release_min, (600 - previous) * CameraZoom::release_rate);
        EXPECT_GE(distance, previous - 0.02f) << i;
        EXPECT_LE(distance, previous + step + 0.02f) << i;
        previous = distance;
    }
    EXPECT_NEAR(previous, 600, 0.05f);
}

TEST(CameraZoom, ClearedWallReturnsMostDistanceWithinFortyGameFrames) {
    auto       camera = Camera();
    CameraZoom zoom;
    CScene     scene;
    auto       wall = Plane(2, 150);
    zoom.Read(camera, -100, false, true);
    for (int i = 0; i < 60; ++i) {
        Tick(camera, zoom, scene, &wall, 1, 0);
    }
    ASSERT_LT(Distance(camera), 150);
    int most = -1;
    int back = -1;
    for (int i = 0; i < 120 && back < 0; ++i) {
        Tick(camera, zoom, scene, nullptr, 0, 0);
        if (most < 0 && Distance(camera) >= 600 - 0.1f * (600 - 150)) {
            most = i;
        }
        if (Distance(camera) >= 600 - 5) {
            back = i;
        }
    }
    // Thirty game frames a second: the drawn eye is nine tenths of the way out
    // within a second and a third and back within two.
    EXPECT_GE(most, 0);
    EXPECT_LE(most, 40);
    EXPECT_GE(back, 0);
    EXPECT_LE(back, 60);
}

TEST(CameraZoom, SettledEyeKeepsRoomToTurnAwayFromAWall) {
    CCPoly     walls[2] = {Plane(0, 10), Plane(0, -10)};
    CScene     scene;
    auto       camera = Camera();
    CameraZoom zoom;
    zoom.Read(camera, -100, false, true);
    // Start the view grazing one corridor wall, then let it settle there.
    camera.SetPos(-8, 40, 600);
    for (int i = 0; i < 200; ++i) {
        Tick(camera, zoom, scene, walls, 2, 0);
    }
    EXPECT_LT(std::fabs(camera.pos[0]), 10 - CameraZoom::clearance + 0.01f);
    auto        yaw_left = camera;
    auto        yaw_right = camera;
    auto        pitch = camera;
    const float left = MouseCameraYaw(yaw_left, 0.1f, walls, 2);
    const float right = MouseCameraYaw(yaw_right, -0.1f, walls, 2);
    EXPECT_TRUE(left != 0 || right != 0);
    EXPECT_NE(MouseCameraPitch(pitch, 0.01f, walls, 2), 0);
}

namespace {
// Separate camera and character collision, as town facades have.
class WallMap final : public CMap {
public:
    WallMap() {
        place_parts = nullptr;
        place_parts_num = 0;
    }

    std::vector<CCPoly> camera, walking;

    int GetCameraPoly(CCPoly *out, mgVu0FBOX & /*box*/, int capacity) override { return Copy(camera, out, capacity); }

    int GetColPoly(CCPoly *out, mgVu0FBOX & /*box*/, int capacity) override { return Copy(walking, out, capacity); }

private:
    static int Copy(const std::vector<CCPoly> &polys, CCPoly *out, int capacity) {
        const int count = std::min(capacity, static_cast<int>(polys.size()));
        std::copy_n(polys.begin(), count, out);
        return count;
    }
};

// A scene holding one map in its active slot.
struct WallScene {
    WallMap map;
    CScene  scene;

    WallScene() {
        scene.AssignMap(0, &map, const_cast<char *>("map"));
        scene.active_map = 0;
        scene.map[0].status |= SCENE_DATA_ACTIVE;
    }
};

// A wall in the x-y plane at z, from x0 to x1.
void Quad(float x0, float x1, float z, std::vector<CCPoly> &out) {
    out.push_back(Triangle({x0, -1000, z}, {x1, -1000, z}, {x0, 1000, z}, {0, 0, 1}));
    out.push_back(Triangle({x1, -1000, z}, {x1, 1000, z}, {x0, 1000, z}, {0, 0, 1}));
}

bool Blocked(CCameraControl &camera, std::vector<CCPoly> &walls) {
    float hit[4];
    return CheckHit(walls.data(), static_cast<int>(walls.size()), camera.ref, camera.pos, hit, 1, 0) >= 0;
}
} // namespace

TEST(CameraZoom, WalkingCollisionBlocksOnlyTheZoomedOutView) {
    struct Case {
        float wall, wheel;
        bool  blocks;
    };

    // Zoomed far out, a facade only the characters' collision holds limits the
    // view; at a retail-range zoom (148, inside the 160 retail maximum) the
    // camera's data alone decides, as in retail.
    for (const Case test : {
             Case{.wall = 300, .wheel = -100, .blocks = true },
             Case{.wall = 120, .wheel = -6,   .blocks = false}
    }) {
        WallScene world;
        Quad(-2000, 2000, test.wall, world.map.walking);
        auto       camera = Camera();
        CameraZoom zoom;
        zoom.Read(camera, test.wheel, false, true);
        for (int i = 0; i < 120; ++i) {
            Tick(camera, zoom, world.scene, nullptr, 0, 0);
            if (test.blocks) {
                EXPECT_LT(camera.pos[2], test.wall) << i;
                EXPECT_LT(camera.next_pos[2], test.wall) << i;
            }
        }
        if (test.blocks) {
            EXPECT_GT(camera.pos[2], test.wall - 20);
        } else {
            EXPECT_NEAR(camera.pos[2], 148, 0.5f);
        }
    }
}

TEST(CameraZoom, NearerCharacterWallWinsOverAFartherCameraWall) {
    WallScene world;
    Quad(-2000, 2000, 300, world.map.walking);
    Quad(-2000, 2000, 500, world.map.camera);
    auto camera = Camera();
    camera.SetPos(0, 40, 600);
    CameraZoom zoom;
    zoom.Read(camera, -100, false, true);
    for (int i = 0; i < 30; ++i) {
        Tick(camera, zoom, world.scene, nullptr, 0, 0);
        EXPECT_FALSE(Blocked(camera, world.map.walking)) << i;
        EXPECT_FALSE(Blocked(camera, world.map.camera)) << i;
        EXPECT_LT(camera.pos[2], 300) << i;
    }
}

TEST(CameraZoom, CharacterWallsCountWhereTheViewCrossesThemBeyondRetailReach) {
    struct Case {
        float wall, start;
        bool  counted;
    };

    // A character-only wall the view crosses within retail's 160-unit reach is
    // one retail's own eye looks across, so the camera's data decides as in
    // retail. Crossed farther out, it holds the eye in front, whether the drawn
    // eye starts inside or outside that reach.
    for (const Case test : {
             Case{.wall = 23,  .start = 600, .counted = false},
             Case{.wall = 120, .start = 600, .counted = false},
             Case{.wall = 150, .start = 600, .counted = false},
             Case{.wall = 170, .start = 600, .counted = true },
             Case{.wall = 170, .start = 150, .counted = true },
             Case{.wall = 300, .start = 600, .counted = true }
    }) {
        WallScene world;
        Quad(-2000, 2000, test.wall, world.map.walking);
        auto camera = Camera();
        camera.SetPos(0, 40, test.start);
        CameraZoom zoom;
        zoom.Read(camera, -100, false, true);
        for (int i = 0; i < 60; ++i) {
            Tick(camera, zoom, world.scene, nullptr, 0, 0);
            if (test.counted) {
                EXPECT_FALSE(Blocked(camera, world.map.walking)) << test.wall << " " << test.start << " " << i;
            }
        }
        if (test.counted) {
            EXPECT_GT(camera.pos[2], test.wall - 20) << test.wall << " " << test.start;
        } else {
            EXPECT_NEAR(camera.pos[2], 600, 1) << test.wall;
        }
    }
}

TEST(CameraZoom, GrazingCharacterWallCountsWhereTheViewCrossesItHoweverTriangulated) {
    // A character-only wall in the plane x=10 runs beside the player, and the
    // view to an eye at x=20 crosses it 300 units out. A camera wall at z=500
    // is farther. The crossing, not the nearest triangle, decides.
    std::vector<std::vector<CCPoly>> layouts(3);
    layouts[0].push_back(Triangle({10, -2000, -2000}, {10, 2000, -2000}, {10, 0, 4000}, {1, 0, 0}));
    layouts[1].push_back(Triangle({10, -2000, -2000}, {10, 2000, -2000}, {10, 2000, 4000}, {1, 0, 0}));
    layouts[1].push_back(Triangle({10, -2000, -2000}, {10, 2000, 4000}, {10, -2000, 4000}, {1, 0, 0}));
    for (int strip = 0; strip < 22; ++strip) {
        const float z = -100 + 50.0f * strip;
        layouts[2].push_back(Triangle({10, -1000, z}, {10, 1000, z}, {10, -1000, z + 50}, {1, 0, 0}));
        layouts[2].push_back(Triangle({10, 1000, z}, {10, 1000, z + 50}, {10, -1000, z + 50}, {1, 0, 0}));
    }
    for (std::size_t layout = 0; layout < layouts.size(); ++layout) {
        WallScene world;
        world.map.walking = layouts[layout];
        Quad(-2000, 2000, 500, world.map.camera);
        auto camera = Camera();
        camera.SetPos(20, 40, 600);
        CameraZoom zoom;
        zoom.Read(camera, -100, false, true);
        for (int i = 0; i < 30; ++i) {
            Tick(camera, zoom, world.scene, nullptr, 0, 0);
            EXPECT_FALSE(Blocked(camera, world.map.walking)) << layout << " " << i;
            EXPECT_FALSE(Blocked(camera, world.map.camera)) << layout << " " << i;
            EXPECT_LT(camera.pos[0], 10) << layout << " " << i;
        }
        EXPECT_GT(camera.pos[2], 250) << layout;
    }
}

namespace {
// Runs the drawn-view guard on a step from one drawn pose to another, with the
// walls as the camera's collision or only the characters', and returns whether
// it cut interpolation. Hidden reports whether any blended frame between the
// two drawn views runs through the walls.
bool SweepCuts(const float (&pos)[3], const float (&ref)[3], const float (&next_pos)[3], const float (&next_ref)[3],
               std::vector<CCPoly> walls, bool walking, bool &hidden) {
    auto camera = Camera();
    camera.SetPos(pos[0], pos[1], pos[2]);
    camera.SetRef(ref[0], ref[1], ref[2]);
    camera.SetNextPos(next_pos[0], next_pos[1], next_pos[2]);
    camera.SetNextRef(next_ref[0], next_ref[1], next_ref[2]);
    WallScene  world;
    CameraZoom zoom;
    zoom.Read(camera, -100, false, true);
    EXPECT_FLOAT_EQ(zoom.requested, 600);
    std::copy_n(camera.pos, 3, zoom.shown_pos);
    std::copy_n(camera.ref, 3, zoom.shown_ref);
    const auto generation = mgPortCameraGeneration();
    if (walking) {
        world.map.walking = walls;
        zoom.KeepVisible(camera, world.scene);
    } else {
        zoom.KeepVisible(camera, world.scene, walls.data(), static_cast<int>(walls.size()));
    }
    // Both drawn views are clear where the walls count, so the guard leaves the pose alone.
    EXPECT_FLOAT_EQ(camera.next_pos[0], next_pos[0]);
    CCameraControl rendered = camera;
    rendered.mgCCamera::Step(1);
    const int count = static_cast<int>(walls.size());
    float     hit[4];
    if (!walking) {
        EXPECT_LT(CheckHit(walls.data(), count, camera.ref, camera.pos, hit, 1, 0), 0);
        EXPECT_LT(CheckHit(walls.data(), count, rendered.ref, rendered.pos, hit, 1, 0), 0);
    }
    hidden = BlendHidden(pos, ref, rendered, walls.data(), count);
    return mgPortCameraGeneration() != generation;
}

// A 0.2-unit square facing the views at z, its lower left corner at (x, y).
std::vector<CCPoly> Square(float x, float y, float z) {
    return {Triangle({x, y, z}, {x + 0.2f, y, z}, {x, y + 0.2f, z}, {0, 0, 1}),
            Triangle({x + 0.2f, y, z}, {x + 0.2f, y + 0.2f, z}, {x, y + 0.2f, z}, {0, 0, 1})};
}
} // namespace

TEST(CameraZoom, TwistedViewSweepCutsExactlyWhenABlendedViewIsHidden) {
    // The eye eases sideways while the target eases up, so the views between
    // the drawn ones (0,50,600)-(0,40,0) and (20,50,600)-(0,42,0) do not lie in
    // one plane. Halfway the view crosses z=300 at (5,45.5); two triangles
    // spanning the corners would cross it along y=45 and x=10 instead. Halfway
    // it crosses z=100 at (1.67,42.5).
    struct Case {
        float x, y, z;
        bool  hidden;
    };

    for (const Case test : {
             Case{.x = 4.9f,  .y = 45.4f, .z = 300, .hidden = true },
             Case{.x = 4.9f,  .y = 44.9f, .z = 300, .hidden = false},
             Case{.x = 1.57f, .y = 42.4f, .z = 100, .hidden = true }
    }) {
        bool       hidden = false;
        const bool cut = SweepCuts({0, 50, 600}, {0, 40, 0}, {80, 50, 600}, {0, 46, 0}, Square(test.x, test.y, test.z),
                                   false, hidden);
        EXPECT_EQ(hidden, test.hidden) << test.y << " " << test.z;
        EXPECT_EQ(cut, hidden) << test.y << " " << test.z;
    }
}

TEST(CameraZoom, ViewSweepLeavesCharacterWallsToEachTicksOwnView) {
    // Character-only walls are not swept: they limit each tick's view beyond
    // retail's reach, and only the frames blending between two clear ticks can
    // cross one. The square a blended view crosses 300 units out is such a wall.
    bool hidden = false;
    EXPECT_FALSE(
        SweepCuts({0, 50, 600}, {0, 40, 0}, {80, 50, 600}, {0, 46, 0}, Square(4.9f, 45.4f, 300), true, hidden));
    EXPECT_TRUE(hidden);
    // Nor do walls within that reach cut: a post ten units inside it beside an
    // eye easing sideways at the reach,
    const std::vector<CCPoly> post = {Triangle({1, 39, 149.9f}, {1, 41, 149.9f}, {1, 39, 150.1f}, {1, 0, 0}),
                                      Triangle({1, 41, 149.9f}, {1, 41, 150.1f}, {1, 39, 150.1f}, {1, 0, 0})};
    EXPECT_FALSE(SweepCuts({-60, 40, 150}, {0, 40, 0}, {420, 40, 150}, {0, 40, 0}, post, true, hidden));
    // and a wall along one of the twisted sweep's straight lines 150 units out.
    const std::vector<CCPoly> ruled = {Triangle({-5, 41, 150}, {10, 45.5f, 150}, {0, 50, 149}, {-4.5f, 15, 112.5f})};
    EXPECT_FALSE(SweepCuts({0, 50, 600}, {0, 40, 0}, {80, 50, 600}, {0, 46, 0}, ruled, true, hidden));
}

TEST(CameraZoom, FlatViewSweepCutsExactlyWhenABlendedViewIsHidden) {
    // Eye and target stay level and the target stays put, so the views sweep a
    // flat triangle, covering x=0..5 at z=300.
    for (const float x : {2.4f, 5.2f, -0.4f}) {
        bool       hidden = false;
        const bool cut =
            SweepCuts({0, 40, 600}, {0, 40, 0}, {40, 40, 600}, {0, 40, 0}, Square(x, 39.9f, 300), false, hidden);
        EXPECT_EQ(hidden, x == 2.4f) << x;
        EXPECT_EQ(cut, hidden) << x;
    }
}

TEST(CameraZoom, ViewSweepTreatsWallsLyingInItAsCheckHitTreatsAView) {
    // A wall lying in the flat sweep's plane only grazes the views, and CheckHit
    // counts a view in a wall's plane as clear.
    bool hidden = false;
    EXPECT_FALSE(SweepCuts({0, 40, 600}, {0, 40, 0}, {40, 40, 600}, {0, 40, 0},
                           {Triangle({1, 40, 300}, {3, 40, 300}, {2, 40, 310}, {0, 1, 0})}, false, hidden));
    EXPECT_FALSE(hidden);
    // A camera wall with an edge along the twisted sweep's straight line through
    // z=150, beyond the sweep's end, is beside every view.
    const std::vector<CCPoly> ruled = {Triangle({6, 44.3f, 150}, {10, 45.5f, 150}, {8, 50, 149}, {-1.2f, 4, 20.4f})};
    EXPECT_FALSE(SweepCuts({0, 50, 600}, {0, 40, 0}, {80, 50, 600}, {0, 46, 0}, ruled, false, hidden));
    EXPECT_FALSE(hidden);
}

TEST(CameraZoom, DoorwayApproachKeepsTheViewThroughTheGap) {
    // A character-only wall at z=60 with a 40-unit doorway; the player walks
    // through it away from the eye, which looks through the gap throughout.
    WallScene world;
    Quad(-2000, -20, 60, world.map.walking);
    Quad(20, 2000, 60, world.map.walking);
    auto camera = Camera();
    camera.SetPos(0, 40, 600);
    CameraZoom zoom;
    zoom.Read(camera, -100, false, true);
    int cuts = 0;
    for (int i = 0; i < 200; ++i) {
        CCameraControl::Control control{};
        float                   rotation[4]{};
        const auto              generation = mgPortCameraGeneration();
        camera.SetFollow(0, 10, 120 - i);
        zoom.Move(camera, world.scene, control, rotation);
        camera.Step(1);
        cuts += mgPortCameraGeneration() != generation;
        EXPECT_FALSE(Blocked(camera, world.map.walking)) << i;
    }
    EXPECT_EQ(cuts, 0);
    EXPECT_GT(PendingDistance(camera), 590);
}

TEST(CameraZoom, MouseTurnBehindACharacterWallIsCorrectedByTheWrapper) {
    // A character-only wall at x=120 beside the view; turning the zoomed camera
    // by mouse swings the eye behind it.
    WallMap map;
    map.walking.push_back(Triangle({120, -2000, 0}, {120, 2000, 0}, {120, 0, 2000}, {1, 0, 0}));
    auto                camera = Camera();
    CScene             &scene = *GetMainScene();
    GlobalCameraCleanup clear_camera{scene};
    GlobalMapCleanup    restore_map{scene};
    scene.AssignMap(0, &map, const_cast<char *>("map"));
    scene.active_map = 0;
    scene.map[0].status |= SCENE_DATA_ACTIVE;
    scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
    scene.active_camera = 0;
    scene.event_run = 0;
    PortLoopNo = LOOP_EDIT;
    GamePad__2.key_lock = 0;
    // A menu closed earlier in the process may still hold the mouse.
    InputSetMenuMouse(false);
    const bool old_option = ConfigGet().mouse_zoom;
    const_cast<Config &>(ConfigGet()).mouse_zoom = true;
    HostSettings settings;
    settings.mouse_zoom = true;
    InputResetBindings();
    InputApplyConfig(settings);
    InputPadState input{.connected = true};
    InputSetOverride(0, &input);
    CPadControl pad{};
    pad.Initialize();
    float rotation[4]{};
    camera.SetPos(0, 40, 600);
    InputSetScriptedDevices({.mouse_wheel = -100});
    InputLatchPad(0);
    camera.MoveCamera(&pad, rotation, nullptr, 0);
    camera.Step(1);
    InputSetScriptedDevices({});
    for (int i = 0; i < 30; ++i) {
        InputLatchPad(0);
        camera.MoveCamera(&pad, rotation, nullptr, 0);
        camera.Step(1);
    }
    EXPECT_FALSE(Blocked(camera, map.walking));
    const auto  generation = mgPortCameraGeneration();
    const float eye[3] = {camera.pos[0], camera.pos[1], camera.pos[2]};
    const float ref[3] = {camera.ref[0], camera.ref[1], camera.ref[2]};
    InputSetScriptedDevices({.mouse_dx = -300});
    InputLatchPad(0);
    camera.MoveCamera(&pad, rotation, nullptr, 0);
    EXPECT_FALSE(Blocked(camera, map.walking));
    camera.Step(1);
    EXPECT_FALSE(Blocked(camera, map.walking));
    // Interpolation is cut only when a display frame blending to the turned
    // view would show the wall.
    if (mgPortCameraGeneration() == generation) {
        EXPECT_FALSE(BlendHidden(eye, ref, camera, map.walking.data(), static_cast<int>(map.walking.size())));
    }
    InputSetScriptedDevices({});
    InputSetOverride(0, nullptr);
    InputResetBindings();
    const_cast<Config &>(ConfigGet()).mouse_zoom = old_option;
}

TEST(CameraZoom, DenseGeometryAfterSettlingKeepsTheZoomedDistance) {
    class DenseMap final : public CMap {
    public:
        DenseMap() {
            place_parts = nullptr;
            place_parts_num = 0;
        }

        // Any query reaching farther than 260 units holds more than the collector.
        int GetCameraPoly(CCPoly * /*polys*/, mgVu0FBOX &box, int capacity) override {
            return box.max[2] - box.min[2] > 260 ? capacity : 0;
        }
    } map;

    CScene scene;
    scene.AssignMap(0, &map, const_cast<char *>("map"));
    scene.active_map = 0;
    scene.map[0].status |= SCENE_DATA_ACTIVE;
    auto camera = Camera();
    camera.SetPos(0, 40, 600);
    CameraZoom zoom;
    zoom.Read(camera, -100, false, true);
    for (int i = 0; i < 200; ++i) {
        Tick(camera, zoom, scene, nullptr, 0, 0);
        EXPECT_NEAR(PendingDistance(camera), 600, 0.05f) << i;
        EXPECT_NEAR(std::hypot(camera.pos[0] - camera.ref[0], camera.pos[2] - camera.ref[2]), 600, 0.05f) << i;
    }
    EXPECT_FLOAT_EQ(zoom.allowed, 600);
}

TEST(CameraZoom, TownConsumesWheelOnceAndRejectsLockedMenuAndEventSamples) {
    auto                camera = Camera();
    CScene             &scene = *GetMainScene();
    GlobalCameraCleanup clear_camera{scene};
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

        int GetCameraPoly(CCPoly *out, mgVu0FBOX &box, int /*max*/) override {
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
    // The turned eye keeps its clearance from the corridor walls at x=+/-10.
    EXPECT_LT(std::fabs(camera.next_pos[0]), 10 - CameraZoom::clearance + 0.01f);
}

TEST(CameraZoom, OverlappingSceneAndCallerPolygonsMergeWithinTheCollector) {
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

        int GetCameraPoly(CCPoly *out, mgVu0FBOX & /*box*/, int capacity) override {
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
        // Distinct attributes are both kept; either way the view is far from them.
        EXPECT_NEAR(camera.next_pos[2], 600, 0.05f) << overlap;
    }
}
