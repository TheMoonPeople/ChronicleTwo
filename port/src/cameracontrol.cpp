#include "common.h"

#include "camera_control_port.hpp"
#include "first_person_walk.hpp"

#define CAMERA_CONTROL_USE_RETAIL_ASSIGNMENT
#include "cameracontrol.hpp"
#undef CAMERA_CONTROL_USE_RETAIL_ASSIGNMENT

#include <algorithm>
#include <cmath>

#include "camera_mouse.hpp"
#include "camera_zoom.hpp"
#include "dng_main.hpp"
#include "editctrl.hpp"
#include "editloop.hpp"
#include "gamepad.hpp"
#include "mainloop.hpp"
#include "mg_math.hpp"
#include "mglib_port.hpp"
#include "photo.hpp"
#include "platform/config.hpp"
#include "platform/input.hpp"
#include "scenesnd.hpp"
#include "subgame.hpp"

extern mgCCamera *PortContinuousEyeCamera;

namespace {
void MeasureControlPose(CCameraControl &camera) {
    sceVu0FVECTOR offset;
    sceVu0SubVector(offset, camera.next_ref, camera.next_pos);
    camera.distance = mgDistVector(offset);
    camera.height = -offset[1];
    camera.next_angle = std::atan2(-offset[0], -offset[2]);
    sceVu0SubVector(offset, camera.ref, camera.pos);
    camera.angle = std::atan2(-offset[0], -offset[2]);
}
} // namespace

CameraCtrlParam &CameraCtrlParam::operator=(const CameraCtrlParam &source) {
    min_dist = source.min_dist;
    max_dist = source.max_dist;
    near_height = source.near_height;
    far_height = source.far_height;
    height = source.height;
    max_height = source.max_height;
    min_height = source.min_height;
    rest_max_height = source.rest_max_height;
    rest_min_height = source.rest_min_height;
    ground_space = source.ground_space;
    no_check = source.no_check;
    return *this;
}

PORT_OVERRIDE void CCameraControl::MoveCamera(CPadControl *pad, float *player_rot, CCPoly *polys, int poly_count) {
    Control control{};
    if (pad) {
        if (!(rot_cancel & CAMERA_ROT_CANCEL_ANALOG)) {
            control.rot = -0.05f * pad->Analog(PAD_ANALOG_RIGHT_X_2);
        }
        if (!(rot_cancel & CAMERA_ROT_CANCEL_BUTTON)) {
            if (pad->Btn(PAD_BTN_L1_HELD)) {
                control.rot = 0.05f;
            }
            if (pad->Btn(PAD_BTN_R1_HELD)) {
                control.rot = -0.05f;
            }
        }
        if (rot_reverse) {
            control.rot = -control.rot;
        }
        control.height = -2.0f * pad->Analog(PAD_ANALOG_RIGHT_Y_2);
        control.rot_back = (pad->Btn(PAD_BTN_L2) || pad->Btn(PAD_BTN_CANCEL)) ? 1 : 0;
    }
    const InputMouseLook &look = InputGetMouseLook();
    static std::uint64_t  consumed_read = 0;
    const bool            fresh = look.read != consumed_read;
    consumed_read = look.read;
    const bool dungeon = GetNowLoopNo() == LOOP_DUNGEON;
    CScene    *scene = dungeon ? DngMainScene : GetMainScene();
    const bool walking = GetNowLoopNo() == LOOP_EDIT && !IsEditMode() && IsWalkMode();
    const bool owns = dungeon ? DungeonMouseCameraOwns(this, scene, pad, DngStatus, BattleAreaScene,
                                                       MainChara__2, SubGameRunning(), GamePad__2.key_lock,
                                                       DebugInfo.debug_camera != 0)
                              : TownMouseCameraOwns(this, scene, pad, walking, SubGameRunning(), GamePad__2.key_lock);
    // Wheel zoom has its own framing policy. Extending right-stick look parity
    // to player actions must not change which states can take over distance.
    const bool                   zoom_owns = owns && (!dungeon || (!MainChara__2->lock_on && MainChara__2->CheckRunEvent()));
    static CameraZoom            zoom;
    static CCameraControl       *zoom_camera = nullptr;
    static CScene               *zoom_scene = nullptr;
    static int                   zoom_map = -1, zoom_submap = -1, zoom_param = -1;
    static const DNG_FLOOR_SAVE *zoom_floor = nullptr;
    static int                   zoom_visit = -1;
    const auto                  *floor = dungeon ? NowFloorInfoPtr : nullptr;
    const int                    visit = floor ? floor->visit_count : -1;
    if (scene && (zoom_camera != this || zoom_scene != scene || zoom_map != scene->now_map_no ||
                  zoom_submap != scene->now_sub_map_no || zoom_param != active_param ||
                  zoom_floor != floor || zoom_visit != visit)) {
        zoom = {};
        zoom_camera = this;
        zoom_scene = scene;
        zoom_map = scene->now_map_no;
        zoom_submap = scene->now_sub_map_no;
        zoom_param = active_param;
        zoom_floor = floor;
        zoom_visit = visit;
    }
    if (zoom_owns) {
        zoom.Read(*this, fresh ? look.zoom : 0,
                  (fresh && look.zoom_reset) || control.rot_back, ConfigGet().mouse_zoom);
    }
    // A pad-only session (even with the option enabled) takes exactly the retail
    // path until a wheel request. Other camera owners never inherit zoom limits.
    if (zoom_owns && zoom.active) {
        zoom.Move(*this, *scene, control, player_rot, polys, poly_count);
    } else {
        MoveCamera(&control, player_rot, polys, poly_count);
    }

    if (!fresh || control.rot_back || (ConfigGet().mouse_zoom && look.zoom_reset) || !owns ||
        (look.yaw == 0 && look.pitch == 0) || !std::isfinite(look.yaw) || !std::isfinite(look.pitch)) {
        return;
    }

    // The retail collection encloses the old eye and cannot cover a mouse flick.
    // Collect the full current/pending orbit before validating a continuous turn.
    float radius = 5;
    for (auto pair : {
             std::pair{pos,      ref     },
             std::pair{next_pos, next_ref}
    }) {
        float squared = 0;
        for (int i = 0; i < 3; ++i) {
            squared += (pair.first[i] - pair.second[i]) * (pair.first[i] - pair.second[i]);
        }
        radius = std::max(radius, std::sqrt(squared) + 5.0f);
    }
    const CameraCtrlParam *active = GetActiveParam();
    radius = std::max(radius, std::max(std::fabs(active->min_height), std::fabs(active->max_height)) +
                                  std::max(std::fabs(active->near_height), std::fabs(active->far_height)) +
                                  active->ground_space + 20.0f);
    if (!std::isfinite(radius)) {
        return;
    }
    mgVu0FBOX bounds{};
    for (int i = 0; i < 3; ++i) {
        bounds.min[i] = std::min(ref[i], next_ref[i]) - radius;
        bounds.max[i] = std::max(ref[i], next_ref[i]) + radius;
    }
    bounds.min[3] = bounds.max[3] = 1;
    CCPoly    orbit_polys[512];
    const int count = MouseCameraCollectPolys(*scene, bounds, orbit_polys, 512);
    // A full collector cannot prove that the corridor contains every polygon.
    if (count < 0 || count >= 512) {
        return;
    }
    if (MouseCameraYaw(*this, look.yaw, orbit_polys, count) != 0) {
        CancelRotBack();
    }
    MouseCameraPitch(*this, look.pitch, orbit_polys, count, zoom_owns ? zoom.HeightScale(*this) : 1.0f);
}

PORT_OVERRIDE void CCameraControl::Step(int frames) {
    if (frames < 0 && PortContinuousEyeCamera != this) {
        mgPortCutCameraInterpolation();
    }
    // Preserve the controller/follow step before adding the native eye look.
    if (!control_on) {
        mgCCameraFollow::Step(frames);
    } else {
        if (frames < 0 && rot_back) {
            SetRotate(rot_back_angle);
        }
        mgCCamera::Step(frames);
        MeasureControlPose(*this);
    }
    if (GetNowLoopNo() != LOOP_DUNGEON || frames <= 0) {
        return;
    }
    const InputMouseLook &look = InputGetMouseLook();
    static std::uint64_t  consumed_eye_read = 0;
    if (look.read == consumed_eye_read) {
        return;
    }
    consumed_eye_read = look.read;
    DungeonFirstPersonWalk(*this);
    if (!DungeonMouseCameraOwns(this, DngMainScene, &PadCtrl, DngStatus, BattleAreaScene,
                                MainChara__2, SubGameRunning(), GamePad__2.key_lock,
                                DebugInfo.debug_camera != 0, true) &&
        !DungeonFirstPersonOwns(this)) {
        return;
    }
    // InitEyeCamera first disables follow, then the next gameplay update places
    // the eye at the character. Do not turn a leftover follow pose on entry.
    sceVu0FVECTOR eye;
    MainChara__2->GetPosition(eye);
    eye[1] += 28;
    for (int i = 0; i < 3; ++i) {
        if (std::fabs(pos[i] - eye[i]) > 0.001f || std::fabs(next_pos[i] - eye[i]) > 0.001f) {
            return;
        }
    }
    if (MouseCameraEye(*this, viewAngleH__2, viewAngleV__2, look.yaw, look.pitch)) {
        mgCCamera::Step(0); // Refresh direction angles without another eased step.
        if (control_on) {
            MeasureControlPose(*this);
        } else {
            angle = next_angle = angle_h;
        }
    }
}
