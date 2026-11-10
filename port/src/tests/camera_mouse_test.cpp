#include <gtest/gtest.h>

#include <algorithm>
#include <cmath>
#include <numbers>
#include <type_traits>
#include <utility>
#include <vector>

#include "camera_mouse.hpp"
#include "cameracontrol.hpp"
#include "dng_main.hpp"
#include "gameutil.hpp"
#include "input/camera_control_state.hpp"
#include "mainloop.hpp"
#include "map.hpp"
#include "padcontrol.hpp"
#include "photo.hpp"
#include "platform/game_loop_state.hpp"
#include "platform/input.hpp"
#include "render/renderer.hpp"
#include "scenesnd.hpp"
#include "stubs/photo.hpp"

namespace {
struct GlobalCameraCleanup {
    CScene &scene;

    ~GlobalCameraCleanup() { scene.GetSceneCamera(0)->Initialize(); }
};

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

CCPoly Triangle(const float (&vertices)[3][4], float normal_x, float normal_z = 0) {
    CCPoly poly{};
    for (int i = 0; i < 3; ++i) {
        for (int j = 0; j < 4; ++j) {
            poly.vertex[i][j] = vertices[i][j];
        }
    }
    poly.normal[0] = normal_x;
    poly.normal[2] = normal_z;
    return poly;
}

CCPoly Wall(float x) {
    return Triangle(
        {
            {x, -1000, -1000, 1},
            {x, 1000,  -1000, 1},
            {x, 0,     1000,  1}
    },
        1);
}

// A post two fifths of a unit wide, standing halfway along the view of
// Camera() just left of it: a small turn left carries the view across it.
CCPoly Post() {
    return Triangle(
        {
            {-1.45f, -1000, 50, 1},
            {-1.05f, -1000, 50, 1},
            {-1.25f, 1000,  50, 1}
    },
        0, 1);
}

bool Blocked(CCPoly &wall, const float *from, const float *to) {
    float a[4] = {from[0], from[1], from[2], 1};
    float b[4] = {to[0], to[1], to[2], 1};
    float hit[4];
    return CheckHit(&wall, 1, a, b, hit, 1, 0) >= 0;
}

// A wall in the plane x = at, from z = 1 back past the eye, so a look-at point
// at z = 0 sees round its end.
CCPoly WallFromZ1(float at, float normal_x) {
    return Triangle(
        {
            {at, -1000, 1,   1},
            {at, 1000,  1,   1},
            {at, 0,     300, 1}
    },
        normal_x);
}

// A map whose camera collision is the given polygons.
class PolyMap final : public CMap {
public:
    explicit PolyMap(std::vector<CCPoly> polys) : polys(std::move(polys)) {
        place_parts = nullptr;
        place_parts_num = 0;
    }

    std::vector<CCPoly> polys;

    int GetCameraPoly(CCPoly *out, mgVu0FBOX & /*box*/, int maximum) override {
        const int written = std::min(static_cast<int>(polys.size()), maximum);
        std::copy_n(polys.begin(), written, out);
        return written;
    }
};

// The town walking camera over a map of camera walls, turned by the right
// stick or the mouse as the game turns it, with wheel zoom off.
class TownTurns {
public:
    explicit TownTurns(std::vector<CCPoly> walls)
        : map(std::move(walls)), scene(*GetMainScene()), saved_map(std::move(scene.map[0])), saved_active(scene.active_map) {
        scene.AssignMap(0, &map, const_cast<char *>("map"));
        scene.active_map = 0;
        scene.map[0].status |= SCENE_DATA_ACTIVE;
        scene.active_camera = 0;
        scene.event_run = 0;
        PortLoopNo = LOOP_EDIT;
        GamePad__2.key_lock = 0;
        InputSetMenuMouse(false);
        InputResetBindings();
        InputSetOverride(0, &input);
        pad.Initialize();
    }

    ~TownTurns() {
        InputSetScriptedDevices({});
        InputSetOverride(0, nullptr);
        scene.GetSceneCamera(0)->Initialize();
        scene.map[0] = std::move(saved_map);
        scene.active_map = saved_active;
    }

    TownTurns(const TownTurns &) = delete;
    TownTurns &operator=(const TownTurns &) = delete;

    // One update with the right stick fully right or a 29-count mouse sample.
    void Turn(CCameraControl &camera, bool mouse) {
        scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
        pad.analog[PAD_ANALOG_RIGHT_X_2].value = mouse ? 0.0f : 1.0f;
        InputSetScriptedDevices({.mouse_dx = mouse ? 29 : 0});
        InputLatchPad(0);
        float rotation[4]{};
        camera.MoveCamera(&pad, rotation, nullptr, 0);
    }

    PolyMap map;

private:
    CScene                                         &scene;
    std::remove_reference_t<decltype(scene.map[0])> saved_map;
    int                                             saved_active;
    InputPadState                                   input{.connected = true};
    CPadControl                                     pad{};
};

// A view a camera matrix can be built from, in sight of the look-at point and
// any explicit collision target past the walls.
void ExpectUsableView(CCameraControl &camera, CCPoly *walls, int count = 2) {
    EXPECT_GT(std::hypot(camera.pos[0] - camera.ref[0], camera.pos[1] - camera.ref[1], camera.pos[2] - camera.ref[2]),
              5);
    float matrix[4][4];
    camera.GetCameraMatrix(matrix);
    const float determinant = (matrix[0][0] * ((matrix[1][1] * matrix[2][2]) - (matrix[1][2] * matrix[2][1]))) -
                              (matrix[0][1] * ((matrix[1][0] * matrix[2][2]) - (matrix[1][2] * matrix[2][0]))) +
                              (matrix[0][2] * ((matrix[1][0] * matrix[2][1]) - (matrix[1][1] * matrix[2][0])));
    EXPECT_NEAR(std::fabs(determinant), 1, 0.01f);
    const float player[3] = {camera.check_ref[0], camera.check_ref[1] + camera.follow_offset[1], camera.check_ref[2]};
    for (int i = 0; i < count; ++i) {
        EXPECT_FALSE(Blocked(walls[i], camera.ref, camera.pos));
        if (camera.check_ref_on) {
            EXPECT_FALSE(Blocked(walls[i], player, camera.pos));
        }
    }
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

TEST(CameraMouse, FlickIntoAWallLandsBothEyesInFrontOfIt) {
    // As retail's stick turn does: the turn is never refused, and retail's
    // wall correction brings the pending eye in front of the wall.
    auto  camera = Camera();
    auto  wall = Wall(-50);
    float hit[4];
    EXPECT_FLOAT_EQ(MouseCameraYaw(camera, std::numbers::pi_v<float> / 2, &wall, 1), std::numbers::pi_v<float> / 2);
    EXPECT_GT(camera.next_pos[0], -50);
    EXPECT_GT(camera.pos[0], -50);
    EXPECT_LT(CheckHit(&wall, 1, camera.ref, camera.pos, hit, 1, 0), 0);
    EXPECT_LT(CheckHit(&wall, 1, camera.next_ref, camera.next_pos, hit, 1, 0), 0);
    // A clear reverse moves back the way it came immediately.
    const float previous = camera.pos[2];
    EXPECT_LT(MouseCameraYaw(camera, -0.1f, &wall, 1), 0);
    EXPECT_GT(camera.pos[2], previous);
}

TEST(CameraMouse, TurnStartingBesideAWallStillTurns) {
    // Retail's wall correction leaves the pending eye a few units from a wall
    // it slid along while the drawn eye eases behind it. A turn toward that
    // wall goes on, never through the wall.
    auto camera = Camera();
    camera.SetNextPos(-2, 40, 110);
    auto wall = Triangle(
        {
            {-5, -1000, 80,  1},
            {-5, 1000,  80,  1},
            {-5, 0,     300, 1}
    },
        1);
    EXPECT_FLOAT_EQ(MouseCameraYaw(camera, 0.5f, &wall, 1), 0.5f);
    float hit[4];
    EXPECT_LT(CheckHit(&wall, 1, camera.ref, camera.pos, hit, 1, 0), 0);
    EXPECT_LT(CheckHit(&wall, 1, camera.next_ref, camera.next_pos, hit, 1, 0), 0);
    EXPECT_LT(camera.pos[0], -5);
}

TEST(CameraMouse, NonfiniteInputLeavesThePoseAlone) {
    auto camera = Camera();
    EXPECT_EQ(MouseCameraYaw(camera, INFINITY, nullptr, 0), 0);
    EXPECT_EQ(MouseCameraYaw(camera, NAN, nullptr, 0), 0);
    EXPECT_FLOAT_EQ(camera.pos[2], 100);
}

TEST(CameraMouse, PendingEyeBehindAWallComesInFrontOfItToTurn) {
    auto camera = Camera();
    camera.next_pos[0] = -80;
    auto wall = Wall(-50);
    EXPECT_FLOAT_EQ(MouseCameraYaw(camera, 0.3f, &wall, 1), 0.3f);
    float hit[4];
    EXPECT_LT(CheckHit(&wall, 1, camera.next_ref, camera.next_pos, hit, 1, 0), 0);
    EXPECT_GT(camera.next_pos[0], -50);
    // The drawn eye, clear on its own, turns at its full distance.
    EXPECT_NEAR(std::hypot(camera.pos[0], camera.pos[2]), 100, 0.01f);
}

TEST(CameraMouse, TurningIntoAndAlongAWallBlendsLikeTheStick) {
    // Each game frame: retail's follow update, a mouse turn at the stick's
    // rate, then the eased step. The eye slides in along the wall and back out
    // with no interpolation cut and no jump, and the player stays in view.
    auto  camera = Camera();
    auto  wall = Wall(-50);
    float eye[3] = {camera.pos[0], camera.pos[1], camera.pos[2]};
    float least = 100;
    for (int i = 0; i < 126; ++i) {
        CCameraControl::Control control{};
        float                   rotation[4]{};
        camera.MoveCamera(&control, rotation, &wall, 1);
        const auto generation = mgPortCameraGeneration();
        EXPECT_NE(MouseCameraYaw(camera, 0.05f, &wall, 1), 0) << i;
        camera.Step(1);
        EXPECT_EQ(mgPortCameraGeneration(), generation) << i;
        float travel = 0;
        for (int k = 0; k < 3; ++k) {
            travel += (camera.pos[k] - eye[k]) * (camera.pos[k] - eye[k]);
            eye[k] = camera.pos[k];
        }
        EXPECT_LT(std::sqrt(travel), 12) << i;
        float hit[4];
        EXPECT_LT(CheckHit(&wall, 1, camera.ref, camera.pos, hit, 1, 0), 0) << i;
        EXPECT_GT(camera.pos[0], -50) << i;
        least = std::min(least, std::hypot(camera.pos[0], camera.pos[2]));
    }
    // The full turn passed the wall at about half retail's distance.
    EXPECT_LT(least, 60);
}

TEST(CameraMouse, TurnPastACornerWithALaggingTargetStaysInViewAfterTheStep) {
    // The drawn look-at point lags the pending one, and a wall ends just short
    // of both. The pending eye stays clear of its own target, but the turn
    // hides it from the drawn one, which eases only part of the way over.
    auto camera = Camera();
    camera.SetNextPos(-8, 40, 100);
    camera.SetNextRef(-8, 40, 0);
    auto wall = WallFromZ1(-5, 1);
    ASSERT_FALSE(Blocked(wall, camera.ref, camera.pos));
    ASSERT_FALSE(Blocked(wall, camera.next_ref, camera.next_pos));
    EXPECT_FLOAT_EQ(MouseCameraYaw(camera, 0.1f, &wall, 1), 0.1f);
    EXPECT_LT(std::atan2(camera.next_pos[0] + 8, camera.next_pos[2]), -0.09f);
    camera.Step(1);
    EXPECT_FALSE(Blocked(wall, camera.ref, camera.pos));
}

TEST(CameraMouse, TurnCarryingTheViewAcrossAThinPostCutsInterpolation) {
    // Both ends of the turn see the player and the eye passes beside the
    // post, but the views between cross it.
    auto       camera = Camera();
    auto       post = Post();
    const auto generation = mgPortCameraGeneration();
    EXPECT_FLOAT_EQ(MouseCameraYaw(camera, 0.05f, &post, 1), 0.05f);
    EXPECT_NE(mgPortCameraGeneration(), generation);
    camera.Step(1);
    EXPECT_FALSE(Blocked(post, camera.ref, camera.pos));
}

TEST(CameraMouse, APostAlreadyHidingTheViewExcusesNoOtherWall) {
    // A post already stands between the eye and the player; the view eases
    // on behind it, but no other wall may come into the view or cross the
    // views between without a cut.
    CCPoly walls[2] = {
        Triangle(
            {{-0.2f, -1000, 50, 1},
              {0.2f, -1000, 50, 1},
              {0, 1000, 50, 1}},
            0, 1),
        Triangle(
            {{-5, -1000, 20, 1},
              {-5, 1000, 20, 1},
              {-5, 0, 80, 1}  },
            1)
    };
    auto camera = Camera();
    camera.SetNextPos(2, 40, 100);
    ASSERT_TRUE(Blocked(walls[0], camera.ref, camera.pos));
    ASSERT_FALSE(Blocked(walls[1], camera.ref, camera.pos));
    EXPECT_FLOAT_EQ(MouseCameraYaw(camera, 0.2f, walls, 2), 0.2f);
    camera.Step(1);
    EXPECT_FALSE(Blocked(walls[1], camera.ref, camera.pos));

    auto post = Camera();
    post.SetNextPos(2, 40, 100);
    walls[1] = Post();
    const auto generation = mgPortCameraGeneration();
    EXPECT_FLOAT_EQ(MouseCameraYaw(post, 0.05f, walls, 2), 0.05f);
    EXPECT_NE(mgPortCameraGeneration(), generation);
    post.Step(1);
    EXPECT_FALSE(Blocked(walls[1], post.ref, post.pos));
}

TEST(CameraMouse, TurnKeepsTheViewInSightOfAnExplicitCollisionTarget) {
    // Retail's wall correction checks from the player, here behind the
    // look-at point and the pending one, so the pending eye it leaves can be
    // hidden from both look-at points. Two walls end just short of them.
    auto camera = Camera();
    camera.SetNextPos(30, 40, 100);
    camera.SetNextRef(30, 40, 0);
    camera.SetCheckRef(0, 10, 0);
    CCPoly      walls[2] = {WallFromZ1(-5, 1), WallFromZ1(5, -1)};
    const float player[3] = {0, 40, 0};
    for (auto &wall : walls) {
        ASSERT_FALSE(Blocked(wall, camera.ref, camera.pos));
        ASSERT_FALSE(Blocked(wall, camera.next_ref, camera.next_pos));
    }
    EXPECT_FLOAT_EQ(MouseCameraYaw(camera, 0.2f, walls, 2), 0.2f);
    camera.Step(1);
    for (auto &wall : walls) {
        EXPECT_FALSE(Blocked(wall, camera.ref, camera.pos));
        EXPECT_FALSE(Blocked(wall, player, camera.pos));
    }
}

TEST(CameraMouse, StickAndMouseTurnsKeepAnExplicitCollisionTargetInSight) {
    TownTurns   town({WallFromZ1(-5, 1), WallFromZ1(5, -1)});
    const float player[3] = {0, 40, 0};
    for (const bool mouse : {false, true}) {
        SCOPED_TRACE(mouse ? "mouse" : "stick");
        // The look-at point leads the player toward +x.
        auto camera = Camera();
        camera.SetFollow(30, 10, 0);
        camera.SetNextPos(30, 40, 100);
        camera.SetNextRef(30, 40, 0);
        camera.SetCheckRef(0, 10, 0);
        for (int i = 0; i < 4; ++i) {
            town.Turn(camera, mouse);
            camera.Step(1);
            for (auto &wall : town.map.polys) {
                EXPECT_FALSE(Blocked(wall, camera.ref, camera.pos)) << i;
                EXPECT_FALSE(Blocked(wall, player, camera.pos)) << i;
            }
        }
    }
}

TEST(CameraMouse, StickAndMouseTurnsAcrossAThinPostCutInterpolationWithoutZoom) {
    TownTurns town({Post()});
    for (const bool mouse : {false, true}) {
        SCOPED_TRACE(mouse ? "mouse" : "stick");
        auto       camera = Camera();
        const auto generation = mgPortCameraGeneration();
        town.Turn(camera, mouse);
        EXPECT_LT(std::atan2(camera.pos[0], camera.pos[2]), -0.04f);
        EXPECT_NE(mgPortCameraGeneration(), generation);
        camera.Step(1);
        EXPECT_FALSE(Blocked(town.map.polys[0], camera.ref, camera.pos));
    }
}

TEST(CameraMouse, TurnNearAWallEndKeepsAUsableView) {
    // The pending look-at point stands just past the end of the right-hand
    // wall, so along the stepped view only the look-at point itself is in
    // sight of it.
    for (const bool explicit_target : {true, false}) {
        SCOPED_TRACE(explicit_target ? "explicit collision target" : "look-at point only");
        auto camera = Camera();
        camera.SetNextPos(30, 40, 100);
        camera.SetNextRef(15.003f, 40, 3.003f);
        if (explicit_target) {
            camera.SetCheckRef(0, 10, 0);
        }
        CCPoly      walls[2] = {WallFromZ1(-5, 1), WallFromZ1(5, -1)};
        const float yaw = explicit_target ? 0.05f : 0.2f;
        EXPECT_FLOAT_EQ(MouseCameraYaw(camera, yaw, walls, 2), yaw);
        camera.Step(1);
        ExpectUsableView(camera, walls);
    }
}

TEST(CameraMouse, StickAndMouseTurnsNearAWallEndKeepAUsableView) {
    TownTurns town({WallFromZ1(-5, 1), WallFromZ1(5, -1)});
    for (const bool mouse : {false, true}) {
        SCOPED_TRACE(mouse ? "mouse" : "stick");
        auto camera = Camera();
        camera.SetFollow(15.003f, 10, 3.003f);
        camera.SetNextPos(30, 40, 100);
        camera.SetNextRef(15.003f, 40, 3.003f);
        camera.SetCheckRef(0, 10, 0);
        town.Turn(camera, mouse);
        camera.Step(1);
        ExpectUsableView(camera, town.map.polys.data());
    }
}

// A turn held past the end of a wall while the look-at point leads the player
// away from it. The clear fallback views begin on the shortest view allowed.
CCameraControl LedPastAWallEnd() {
    auto camera = Camera();
    camera.SetPos(107.739326f, 57.9999924f, -34.4134064f);
    camera.SetRef(15.003f, 40, 3.003f);
    camera.SetFollow(15.003f, 10, 3.003f);
    camera.SetCheckRef(0, 10, 0);
    return camera;
}

TEST(CameraMouse, TurnHeldPastALedWallEndKeepsTurning) {
    auto wall = WallFromZ1(20, -1);
    auto camera = LedPastAWallEnd();
    for (int i = 0; i < 300 && !HasFailure(); ++i) {
        SCOPED_TRACE(i);
        EXPECT_FLOAT_EQ(MouseCameraYaw(camera, 0.05f, &wall, 1), 0.05f);
        camera.Step(1);
        ExpectUsableView(camera, &wall, 1);
    }
}

TEST(CameraMouse, StickAndMouseTurnsHeldPastALedWallEndKeepTurning) {
    TownTurns town({WallFromZ1(20, -1)});
    for (const bool mouse : {false, true}) {
        SCOPED_TRACE(mouse ? "mouse" : "stick");
        auto  camera = LedPastAWallEnd();
        float heading = std::atan2(camera.pos[0] - camera.ref[0], camera.pos[2] - camera.ref[2]);
        float turned = 0;
        int   still = 0;
        int   longest_still = 0;
        for (int i = 0; i < 300 && !HasFailure(); ++i) {
            SCOPED_TRACE(i);
            town.Turn(camera, mouse);
            camera.Step(1);
            ExpectUsableView(camera, town.map.polys.data(), 1);
            const float now = std::atan2(camera.pos[0] - camera.ref[0], camera.pos[2] - camera.ref[2]);
            const float step = std::fabs(std::remainder(now - heading, 2 * std::numbers::pi_v<float>));
            heading = now;
            turned += step;
            still = step < 0.00001f ? still + 1 : 0;
            longest_still = std::max(longest_still, still);
        }
        // Ten seconds of held input keeps turning: never a second without
        // motion, and well over a full turn in all.
        EXPECT_LT(longest_still, 30);
        EXPECT_GT(turned, 2 * std::numbers::pi_v<float>);
    }
}

TEST(CameraMouse, TurnCarryingThePlayersSightlineAcrossAPostCutsInterpolation) {
    // The look-at point leads the player, whom retail's wall correction keeps
    // in view, by five units. Both ends of the turn see the player and the
    // look-at point, and the look-at point's sightline never meets the post,
    // but the player's crosses it on the way.
    const auto post_at = [] {
        return Triangle(
            {
                {1.05f, -1000, 50, 1},
                {1.45f, -1000, 50, 1},
                {1.25f, 1000,  50, 1}
        },
            0, 1);
    };
    const auto leading = [] {
        auto camera = Camera();
        camera.SetPos(5, 40, 100);
        camera.SetRef(5, 40, 0);
        camera.SetFollow(5, 10, 0);
        camera.SetCheckRef(0, 10, 0);
        auto &param = *camera.GetActiveParam();
        param.min_dist = 100;
        param.max_dist = 200;
        param.height = param.near_height = param.far_height = 0;
        return camera;
    };
    const float player[3] = {0, 40, 0};
    {
        auto       camera = leading();
        auto       post = post_at();
        const auto generation = mgPortCameraGeneration();
        EXPECT_FLOAT_EQ(MouseCameraYaw(camera, 0.05f, &post, 1), 0.05f);
        EXPECT_NE(mgPortCameraGeneration(), generation);
        camera.Step(1);
        EXPECT_FALSE(Blocked(post, camera.ref, camera.pos));
        EXPECT_FALSE(Blocked(post, player, camera.pos));
    }
    TownTurns town({post_at()});
    for (const bool mouse : {false, true}) {
        SCOPED_TRACE(mouse ? "mouse" : "stick");
        auto       camera = leading();
        const auto generation = mgPortCameraGeneration();
        town.Turn(camera, mouse);
        EXPECT_LT(camera.pos[0], 1);
        EXPECT_NE(mgPortCameraGeneration(), generation);
        camera.Step(1);
        EXPECT_FALSE(Blocked(town.map.polys[0], camera.ref, camera.pos));
        EXPECT_FALSE(Blocked(town.map.polys[0], player, camera.pos));
    }
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
}

TEST(CameraMouse, TownMouseKeepsTurningAfterAnEventTurnsFollowOff) {
    auto                camera = Camera();
    CScene             &scene = *GetMainScene();
    GlobalCameraCleanup clear_camera{scene};
    scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
    scene.active_camera = 0;
    scene.event_run = 0;
    PortLoopNo = LOOP_EDIT;
    GamePad__2.key_lock = 0;
    CPadControl pad{};
    // A door event, a map event (the prologue's bench couple) or the entry event
    // after a world map move turns the walking camera's follow off with
    // _INITIALIZE or EventDoorLoop; town control only turns control back on.
    camera.FollowOff();
    EXPECT_TRUE(TownMouseCameraOwns(&camera, &scene, &pad, true, false, false));
    camera.ControlOff();
    EXPECT_FALSE(TownMouseCameraOwns(&camera, &scene, &pad, true, false, false));
    camera.ControlOn();
    InputResetBindings();
    InputPadState input{.connected = true};
    InputSetOverride(0, &input);
    InputSetScriptedDevices({.mouse_dx = 400});
    InputLatchPad(0);
    pad.Initialize();
    float rotation[4]{};
    camera.MoveCamera(&pad, rotation, nullptr, 0);
    EXPECT_LT(camera.pos[0], -60);
    InputSetScriptedDevices({});
    InputSetOverride(0, nullptr);
}

TEST(CameraMouse, TownControlConsumesOneSampleAndDoesNotReplayLockedMotion) {
    auto                camera = Camera();
    CScene             &scene = *GetMainScene();
    GlobalCameraCleanup clear_camera{scene};
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

TEST(CameraMouse, TurnIsNotUndoneByObstacleAvoidance) {
    // A post beside the view, clear of the view itself but inside the pipe
    // retail's obstacle avoidance keeps clear, as a wall edge is when the eye
    // slides along it. Avoidance would swing the eye away from the post on the
    // turn's frame and fight the turn; as for the stick, it waits.
    auto                camera = Camera();
    CScene             &scene = *GetMainScene();
    GlobalCameraCleanup clear_camera{scene};
    scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
    scene.active_camera = 0;
    scene.event_run = 0;
    PortLoopNo = LOOP_EDIT;
    GamePad__2.key_lock = 0;
    InputResetBindings();
    InputPadState input{.connected = true};
    InputSetOverride(0, &input);
    CPadControl pad{};
    pad.Initialize();
    float rotation[4]{};
    auto  post = Triangle(
        {
            {2, -1000, 40, 1},
            {2, 1000,  40, 1},
            {3, 0,     80, 1}
    },
        1, -0.01f);
    // Without a turn, avoidance moves the eye off the post's side.
    auto still = camera;
    scene.AssignCamera(0, &still, const_cast<char *>("MainCam"));
    InputSetScriptedDevices({});
    InputLatchPad(0);
    still.MoveCamera(&pad, rotation, &post, 1);
    EXPECT_GT(std::fabs(std::atan2(still.next_pos[0], still.next_pos[2])), 0.05f);
    // With a turn, the eye turns by exactly the turn.
    scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
    InputSetScriptedDevices({.mouse_dx = -29});
    InputLatchPad(0);
    camera.MoveCamera(&pad, rotation, &post, 1);
    const float yaw = -29 * 0.1f * std::numbers::pi_v<float> / 180;
    EXPECT_NEAR(std::atan2(camera.next_pos[0], camera.next_pos[2]), -yaw, 0.0005f);
    EXPECT_NEAR(std::atan2(camera.pos[0], camera.pos[2]), -yaw, 0.0005f);
    EXPECT_EQ(camera.rot_cancel, 0);
    InputSetScriptedDevices({});
    InputSetOverride(0, nullptr);
}

TEST(CameraStick, RotationStartsAtFullRateReversesAndStopsWithoutDrift) {
    CScene             &scene = *GetMainScene();
    GlobalCameraCleanup clear_camera{scene};
    scene.active_camera = 0;
    scene.event_run = 0;
    PortLoopNo = LOOP_EDIT;
    GamePad__2.key_lock = 0;
    InputResetBindings();
    CPadControl pad{};
    pad.Initialize();
    float rotation[4]{};

    for (float distance : {100.0f, 500.0f}) {
        auto camera = Camera();
        camera.SetPos(0, 40, distance);
        auto &param = *camera.GetActiveParam();
        param.max_dist = 600;
        param.near_height = param.far_height = 0;
        param.min_height = -100;
        param.max_height = 100;
        param.height = 30;
        // Pitch remains direct even above the authored resting height.
        camera.SetPos(0, 70, distance);
        scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
        for (float input : {1.0f, 1.0f, 1.0f, -1.0f, -1.0f, 0.0f, 0.0f}) {
            const float heading = std::atan2(camera.pos[0] - camera.ref[0], camera.pos[2] - camera.ref[2]);
            const float pitch = std::atan2(camera.pos[1] - camera.ref[1], distance);
            pad.analog[PAD_ANALOG_RIGHT_X_2].value = input;
            pad.analog[PAD_ANALOG_RIGHT_Y_2].value = input;
            InputLatchPad(0);
            camera.MoveCamera(&pad, rotation, nullptr, 0);
            camera.Step(1);
            EXPECT_NEAR(std::atan2(camera.pos[0] - camera.ref[0], camera.pos[2] - camera.ref[2]),
                        heading - 0.05f * input, 0.0001f);
            EXPECT_NEAR(std::atan2(camera.pos[1] - camera.ref[1], distance),
                        pitch - 0.02f * input, 0.0001f);
            EXPECT_NEAR(camera.pos[0], camera.next_pos[0], 0.0001f);
            EXPECT_NEAR(camera.pos[1], camera.next_pos[1], 0.0001f);
            EXPECT_FLOAT_EQ(param.rest_max_height, 20);
            EXPECT_EQ(camera.rot_cancel, 0);
        }
    }
}

TEST(CameraStick, ResetWinsItsFrameAndManualYawCancelsAnUnfinishedReset) {
    auto  camera = Camera();
    auto &param = *camera.GetActiveParam();
    param.near_height = param.far_height = 0;
    CScene             &scene = *GetMainScene();
    GlobalCameraCleanup clear_camera{scene};
    scene.AssignCamera(0, &camera, const_cast<char *>("MainCam"));
    scene.active_camera = 0;
    scene.event_run = 0;
    PortLoopNo = LOOP_EDIT;
    GamePad__2.key_lock = 0;
    InputResetBindings();
    CPadControl pad{};
    pad.Initialize();
    pad.analog[PAD_ANALOG_RIGHT_X_2].value = 1;
    pad.btn[PAD_BTN_L2].value = 1;
    float rotation[4]{};
    InputLatchPad(0);
    camera.MoveCamera(&pad, rotation, nullptr, 0);
    EXPECT_FLOAT_EQ(camera.pos[0], 0);
    EXPECT_TRUE(camera.rot_back);

    // A settled pose isolates manual yaw from the reset's pending movement.
    camera.SetPos(0, 40, 100);
    pad.btn[PAD_BTN_L2].value = 0;
    InputLatchPad(0);
    camera.MoveCamera(&pad, rotation, nullptr, 0);
    EXPECT_FALSE(camera.rot_back);
    EXPECT_NEAR(std::atan2(camera.pos[0], camera.pos[2]), -0.05f, 0.0001f);
    EXPECT_NEAR(std::atan2(camera.next_pos[0], camera.next_pos[2]), -0.05f, 0.0001f);
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

    int GetCameraPoly(CCPoly *out, mgVu0FBOX & /*box*/, int maximum) override {
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
    CapacityMap first;
    CapacityMap second;
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
        {.name = "standing",         .hold = ACTION_HOLD_NONE,  .menu = 1, .guard = 0, .gun = 0, .lock = 0, .landed = 1},
        {.name = "carrying stone",   .hold = ACTION_HOLD_STONE, .menu = 0, .guard = 0, .gun = 0, .lock = 0, .landed = 1},
        {.name = "carrying enemy",   .hold = ACTION_HOLD_ENEMY, .menu = 0, .guard = 0, .gun = 0, .lock = 0, .landed = 1},
        {.name = "holding item",     .hold = ACTION_HOLD_ITEM,  .menu = 0, .guard = 0, .gun = 0, .lock = 0, .landed = 1},
        {.name = "guarding",         .hold = ACTION_HOLD_NONE,  .menu = 0, .guard = 1, .gun = 0, .lock = 0, .landed = 1},
        {.name = "aiming",           .hold = ACTION_HOLD_NONE,  .menu = 0, .guard = 0, .gun = 1, .lock = 0, .landed = 1},
        {.name = "aiming locked on", .hold = ACTION_HOLD_NONE,  .menu = 0, .guard = 0, .gun = 1, .lock = 1, .landed = 1},
        {.name = "falling",          .hold = ACTION_HOLD_NONE,  .menu = 0, .guard = 0, .gun = 0, .lock = 0, .landed = 0},
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
    for (int mode : {static_cast<int>(DNG_CAMERA_BOSS), static_cast<int>(DNG_CAMERA_ARENA), 3}) {
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
    // Town walking control runs without follow as well.
    EXPECT_TRUE(TownMouseCameraOwns(&camera, &scene, &pad, true, false, false));
}

namespace {

class DungeonEyeMouse : public testing::TestWithParam<bool> {};

} // namespace

TEST_P(DungeonEyeMouse, LookIsImmediateBoundedAndDoesNotQueueMenuMotion) {
    const unsigned old_photo = TakePhotoMode;
    TakePhotoMode = GetParam() ? TAKE_PHOTO_AIM : TAKE_PHOTO_OFF;
    const int   old_loop = PortLoopNo;
    auto       *old_scene = DngMainScene;
    auto       *old_area = BattleAreaScene;
    auto       *old_chara = MainChara__2;
    const auto  old_status = DngStatus;
    const float old_yaw = viewAngleH__2;
    const float old_pitch = viewAngleV__2;
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
    float heading = 0;
    float tilt = 0.67f;
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
