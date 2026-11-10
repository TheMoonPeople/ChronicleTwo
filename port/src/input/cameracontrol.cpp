#include "common.h"

#include <cmath>
#include <cstring>

#define CAMERA_CONTROL_USE_RETAIL_ASSIGNMENT
#include "cameracontrol.hpp"
#undef CAMERA_CONTROL_USE_RETAIL_ASSIGNMENT
#include "collision.hpp"
#include "gameutil.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "padcontrol.hpp"

void CameraCtrlParam::SetFixHeight(float height) {
    max_height = height;
    min_height = height;
    near_height = height;
    far_height = height;
    rest_max_height = height;
    rest_min_height = height;
}

void CameraCtrlParam::SetFixDist(float distance) {
    max_dist = distance;
    min_dist = distance;
}

CCameraControl::CCameraControl() : mgCCameraFollow(40.0f, 30.0f, 0.0f, 8.0f) {
    mgCCameraFollow(40.0f, 30.0f, 0.0f, 8.0f);
    active_param = 0;
    control_on = false;
    CameraCtrlParam *active = GetActiveParam();
    active->min_dist = 100.0f;
    active->max_dist = 160.0f;
    active->near_height = 18.0f;
    active->far_height = 10.0f;
    active->max_height = 40.0f;
    active->min_height = -15.0f;
    active->rest_max_height = 20.0f;
    active->rest_min_height = -15.0f;
    active->height = -15.0f;
    active->ground_space = 25.0f;
    check_ref_on = false;
    active->no_check = false;
    rot_reverse = false;
    InitStatus();
    default_param = *GetActiveParam();
}

CameraCtrlParam *CCameraControl::GetActiveParam() {
    return &param[active_param];
}

void CCameraControl::SetRotCameraCancel(int mask) {
    rot_cancel = mask;
}

void CCameraControl::BitSetRotCameraCancel(int mask) {
    rot_cancel |= mask;
}

void CCameraControl::BitResetRotCameraCancel(int mask) {
    rot_cancel &= ~mask;
}

void CCameraControl::InitStatus() {
    rot_cancel = 0;
    rot_back = false;
    rot_back_angle = 0.0f;
    mgZeroVector(dir_offset);
}

void CCameraControl::ControlOn() {
    CameraCtrlParam *active = {};

    if (!control_on) {
        std::memmove(next_ref, ref, sizeof(float) * 4);
        std::memmove(next_pos, pos, sizeof(float) * 4);
        active = GetActiveParam();
        active->height = next_pos[1] - next_ref[1];

        if (active->height < active->min_height) {
            active->height = active->min_height;
        }

        if (active->height > active->max_height) {
            active->height = active->max_height;
        }
    }

    control_on = true;
}

void CCameraControl::ControlOff() {
    control_on = false;
}

void CCameraControl::Stay() {
    if (!control_on) {
        mgCCameraFollow::Stay();
    } else {
        mgCCamera::Stay();
    }
}

void CCameraControl::Rotate(float angle) {
    float offset[4];
    float matrix[4][4];

    sceVu0SubVector(offset, next_pos, next_ref);
    offset[3] = 0.0f;
    mgUnitMatrix(matrix);
    sceVu0RotMatrixY(matrix, matrix, mgAngleLimit(angle));
    sceVu0ApplyMatrix(offset, matrix, offset);
    sceVu0AddVector(next_pos, next_ref, offset);
}

void CCameraControl::SetRotate(float angle) {
    float distance = {};
    float height = {};

    distance = mgDistVectorXZ(next_ref, next_pos);

    height = next_pos[1] - next_ref[1];
    float offset[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    float matrix[4][4];
    offset[1] = height;
    offset[2] = distance;
    mgUnitMatrix(matrix);
    sceVu0RotMatrixY(matrix, matrix, mgAngleLimit(angle));
    sceVu0ApplyMatrix(offset, matrix, offset);
    sceVu0AddVector(next_pos, next_ref, offset);
}

void CCameraControl::SetHeight(float height) {
    CameraCtrlParam *active = {};

    if (!control_on) {
        mgCCameraFollow::SetHeight(height);
    }

    active = GetActiveParam();
    next_pos[1] = next_ref[1] + height;
    active->height = height;
}

void CCameraControl::RotBack(float angle) {
    rot_back = true;
    rot_back_angle = angle;
}

void CCameraControl::CancelRotBack() {
    rot_back = false;
}

void CCameraControl::SetCheckRef(float *ref) {
    check_ref_on = true;
    std::memmove(check_ref, ref, sizeof(float) * 4);
}

void CCameraControl::SetCheckRef(float x, float y, float z) {
    float ref[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    ref[0] = x;
    ref[1] = y;
    ref[2] = z;
    SetCheckRef(ref);
}

void CCameraControl::CheckCollision(CCPoly *polys, int poly_count) {
    float to_camera[4];
    float side_dir[4];
    float view_dir[4];
    float hit[4];
    float unused_hit[4];
    float view_end[4];
    float side_end[4];
    float target[4];
    float margin[4];
    float push[4];
    int   hit_index = {};
    int   slid = {};
    float old_dist = {};

    GetActiveParam();

    if (check_ref_on) {
        std::memmove(target, check_ref, sizeof(float) * 4);
        target[1] += follow_offset[1];
    } else {
        std::memmove(target, next_ref, sizeof(float) * 4);
    }

    sceVu0SubVector(to_camera, target, next_pos);
    sceVu0Normalize(view_dir, to_camera);
    sceVu0SubVector(view_end, target, to_camera);
    to_camera[1] = 0.0f;
    sceVu0SubVector(side_end, target, to_camera);
    sceVu0Normalize(side_dir, to_camera);
    mgDistVector(to_camera);
    sceVu0ScaleVector(margin, side_dir, 5.0f);
    sceVu0SubVector(side_end, side_end, margin);
    sceVu0ScaleVector(margin, view_dir, 5.0f);
    sceVu0SubVector(view_end, view_end, margin);
    slid = false;
    hit_index = CheckHit(polys, poly_count, target, view_end, hit, 1, 0);

    if (hit_index < 0) {
        hit_index = -1;
        slid = true;
        std::memmove(hit, unused_hit, sizeof(float) * 4);
        std::memmove(view_end, side_end, sizeof(float) * 4);
    }

    if (hit_index >= 0) {
        sceVu0SubVector(push, target, view_end);
        sceVu0Normalize(push, push);
        sceVu0ScaleVector(push, push, 5.0f);
        mgAddVector(hit, push);

        if (slid) {
            old_dist = mgDistVectorXZ(next_pos, target);
            float ratio = mgDistVectorXZ(hit, target) / old_dist;
            hit[1] += ratio * (next_pos[1] - target[1]);
        }

        std::memmove(next_pos, hit, sizeof(float) * 4);
        old_dist = mgDistVector(target, next_pos);

        if (!(old_dist - mgDistVector(target, hit) <= 5.0f)) {
            std::memmove(pos, hit, sizeof(float) * 4);
        }
    }
}

int CCameraControl::AutoMove(CCPoly *polys, int poly_count) {
    float target[4];
    float to_target[4];
    float plane[4];
    float to_pos[4];
    float start_pos[4];
    float dir_copy[4];
    float ray_end[4];
    float rot_a[4];
    float rot_b[4];
    float ray_start[4];
    float candidate[4];
    float turn_a[4][4];
    float turn_b[4][4];
    float probe[4];
    int   hit_count = {};
    int   found = {};
    int   step = {};
    int   result = {};
    float unit = 1.0f;
    float radius = {};
    float margin = {};

    GetActiveParam();

    if (check_ref_on) {
        std::memmove(target, check_ref, sizeof(float) * 4);
        target[1] += follow_offset[1];
    } else {
        std::memmove(target, next_ref, sizeof(float) * 4);
    }

    radius = 4.0f;
    sceVu0SubVector(to_target, target, next_pos);
    sceVu0SubVector(to_pos, target, pos);
    mgDistVectorXZ(to_pos);
    margin = 0.9f;
    margin *= unit;
    radius *= unit;
    std::memmove(ray_end, target, sizeof(float) * 4);
    std::memmove(start_pos, next_pos, sizeof(float) * 4);
    std::memmove(dir_copy, to_target, sizeof(float) * 4);
    sceVu0ScaleVector(ray_start, dir_copy, margin);
    sceVu0SubVector(ray_start, target, ray_start);
    ray_start[3] = radius;

    if (CheckHitsPipe(polys, poly_count, ray_start, ray_end, 1, &hit_count, &plane, 0, 0) <= 0) {
        return true;
    }

    std::memmove(rot_a, dir_copy, sizeof(float) * 4);
    rot_a[3] = 0.0f;
    std::memmove(rot_b, dir_copy, sizeof(float) * 4);
    rot_b[3] = 0.0f;
    mgUnitMatrix(turn_a);
    mgUnitMatrix(turn_b);
    sceVu0RotMatrixY(turn_a, turn_a, 0.01636246219277382f);
    sceVu0RotMatrixY(turn_b, turn_b, -0.01636246219277382f);
    found = false;
    std::memmove(candidate, start_pos, sizeof(float) * 4);
    step = 0;

    do {
        sceVu0ApplyMatrix(rot_a, turn_a, rot_a);
        sceVu0SubVector(candidate, ray_end, rot_a);
        sceVu0ScaleVector(probe, rot_a, margin);
        sceVu0SubVector(probe, ray_end, probe);
        probe[3] = radius;

        if (CheckHitsPipe(polys, poly_count, probe, ray_end, 1, &hit_count, &plane, 0, 0) <= 0) {
            found = true;
            break;
        }

        sceVu0ApplyMatrix(rot_b, turn_b, rot_b);
        sceVu0SubVector(candidate, ray_end, rot_b);
        sceVu0ScaleVector(probe, rot_b, margin);
        sceVu0SubVector(probe, ray_end, probe);
        probe[3] = radius;

        if (CheckHitsPipe(polys, poly_count, probe, ray_end, 1, &hit_count, &plane, 0, 0) <= 0) {
            found = true;
            break;
        }

        step++;
    } while (step < 0x20);

    result = false;

    if (found) {
        result = true;
        std::memmove(next_pos, candidate, sizeof(float) * 4);
    }

    return result;
}

void CCameraControl::CheckGround(CCPoly *polys, int poly_count) {
    int              ceiling_index = {};
    float            target[4];
    int              indices[0x20];
    float            from[4];
    float            line_high[4];
    float            line_low[4];
    float            hits[0x20][4];
    float            hit_info[4];
    float            floor_normal[4];
    float            ceiling_normal[4];
    CameraCtrlParam *active = {};
    float            top = {};
    float            bottom = {};
    int              floor_index = {};
    int              count = {};
    int              i = {};

    active = GetActiveParam();

    if (check_ref_on) {
        std::memmove(target, check_ref, sizeof(float) * 4);
        target[1] += follow_offset[1];
    } else {
        std::memmove(target, next_ref, sizeof(float) * 4);
    }

    std::memmove(from, next_pos, sizeof(float) * 4);
    std::memmove(line_high, next_pos, sizeof(float) * 4);
    std::memmove(line_low, next_pos, sizeof(float) * 4);
    line_high[1] = 20.0f + (target[1] + active->max_height);
    line_low[1] = (target[1] + active->min_height) - active->ground_space;
    top = line_high[1];
    bottom = line_low[1];

    if (CheckHit(polys, poly_count, from, line_high, hit_info, 1, 0) >= 0) {
        top = hit_info[1];
    }

    if (CheckHit(polys, poly_count, from, line_low, hit_info, 1, 0) >= 0) {
        bottom = hit_info[1];
    }

    ceiling_index = -1;
    floor_index = ceiling_index;
    line_high[1] = 2.0f + top;
    line_low[1] = bottom - 2.0f;
    count = CheckHits(polys, poly_count, line_high, line_low, 0x20, indices, hits, 1, 0);

    for (i = 0; i < count; i++) {
        if (hits[i][1] <= 1.0f + top) {
            sceVu0Normalize(floor_normal, polys[indices[i]].normal);

            if (next_pos[1] - hits[i][1] < active->ground_space) {
                if (floor_normal[1] > 0.5f) {
                    floor_index = i;
                    break;
                }
            }
        }
    }

    for (count--; count >= 0; count--) {
        if (!(hits[count][1] < bottom - 1.0f)) {
            sceVu0Normalize(ceiling_normal, polys[indices[count]].normal);

            if (hits[count][1] - next_pos[1] < 20.0f) {
                if (ceiling_normal[1] < -0.5f) {
                    ceiling_index = count;
                    break;
                }
            }
        }
    }

    if (floor_index >= 0 && ceiling_index >= 0) {
        next_pos[1] =
            0.5f * (active->ground_space + hits[floor_index][1] + hits[ceiling_index][1] - 20.0f);
    } else {
        if (floor_index >= 0) {
            next_pos[1] = active->ground_space + hits[floor_index][1];
        }

        if (ceiling_index >= 0) {
            next_pos[1] = hits[ceiling_index][1] - 20.0f;
        }
    }
}

void CCameraControl::GetCameraMatrix(float (*matrix)[4]) {
    float dir[4];
    float up[4];
    sceVu0SubVector(dir, ref, pos);
    mgAddVector(dir, dir_offset);
    dir[0] = dir[0];
    dir[1] = dir[1];
    dir[2] = dir[2];
    up[0] = dir[0] * dir[1];
    up[1] = -(dir[0] * dir[0] + dir[2] * dir[2]);
    up[2] = dir[1] * dir[2];
    up[3] = 1.0f;
    sceVu0Normalize(up, up);
    sceVu0Normalize(dir, dir);
    sceVu0CameraMatrix(matrix, pos, dir, up);
}

void CCameraControl::CopyParam(CCameraControl &dest) {
    CameraCtrlParam *src = GetActiveParam();
    CameraCtrlParam *dst = dest.GetActiveParam();
    dst->min_dist = src->min_dist;
    dst->max_dist = src->max_dist;
    dst->near_height = src->near_height;
    dst->far_height = src->far_height;
    dst->height = src->height;
    dst->max_height = src->max_height;
    dst->min_height = src->min_height;
    dst->rest_max_height = src->rest_max_height;
    dst->rest_min_height = src->rest_min_height;
    dst->ground_space = src->ground_space;
    dst->no_check = src->no_check;
    dest.rot_cancel = rot_cancel;
    std::memmove(dest.follow_offset, follow_offset, sizeof(float) * 4);
}

int CCameraControl::Iam() {
    return CAMERA_KIND_CONTROL;
}

#include "common.h"

#include "first_person_walk.hpp"
#include "input/camera_control_state.hpp"

#define CAMERA_CONTROL_USE_RETAIL_ASSIGNMENT
#include <cmath>

#include "cameracontrol.hpp"
#undef CAMERA_CONTROL_USE_RETAIL_ASSIGNMENT

#include <algorithm>
#include <cmath>
#include <numbers>

#include "camera_mouse.hpp"
#include "camera_zoom.hpp"
#include "dng_main.hpp"
#include "editctrl.hpp"
#include "editloop.hpp"
#include "gamepad.hpp"
#include "mainloop.hpp"
#include "mg_math.hpp"
#include "photo.hpp"
#include "platform/config.hpp"
#include "platform/input.hpp"
#include "render/renderer.hpp"
#include "scenesnd.hpp"
#include "subgame.hpp"
#include "vu0_lanes.hpp"

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

CameraCtrlParam &CameraCtrlParam::operator=(const CameraCtrlParam &source) = default;

void CCameraControl::MoveCamera(CPadControl *pad, float *player_rot, CCPoly *polys, int poly_count) {
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
    float      stick_yaw = 0;
    float      stick_pitch = 0;
    if (owns) {
        const bool button_turn = !(rot_cancel & CAMERA_ROT_CANCEL_BUTTON) &&
                                 (pad->Btn(PAD_BTN_L1_HELD) || pad->Btn(PAD_BTN_R1_HELD));
        if (!button_turn) {
            stick_yaw = -control.rot;
            control.rot = 0;
        }
        stick_pitch = -0.01f * control.height;
        control.height = 0;
    }
    const bool reset = control.rot_back || (ConfigGet().mouse_zoom && look.zoom_reset);
    if (fresh && stick_yaw != 0 && !reset) {
        CancelRotBack();
    }
    // Wheel zoom has its own framing policy. Extending right-stick look parity
    // to player actions must not change which states can take over distance.
    const bool zoom_owns = owns && (!dungeon || (!MainChara__2->lock_on && MainChara__2->CheckRunEvent()));
    // A selected distance survives attacks and carrying, which only pause wheel
    // input; handing those ticks to retail would pull the eye in and back out.
    const bool                   zoom_keeps = owns && (!dungeon || !MainChara__2->lock_on);
    static CameraZoom            zoom;
    static CCameraControl       *zoom_camera = nullptr;
    static CScene               *zoom_scene = nullptr;
    static int                   zoom_map = -1;
    static int                   zoom_submap = -1;
    static int                   zoom_param = -1;
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
    CameraCtrlParam *param = GetActiveParam();
    const float      rest_min_height = param->rest_min_height;
    const float      rest_max_height = param->rest_max_height;
    const int        saved_rot_cancel = rot_cancel;
    if (owns) {
        // Direct pitch stays where the player leaves it instead of springing
        // back toward a resting height through the follow camera's easing.
        param->rest_min_height = param->min_height;
        param->rest_max_height = param->max_height;
        // Retail skips obstacle avoidance while the camera turns; a mouse turn
        // is a turn too, or avoidance swings the eye back against it at walls.
        if (stick_yaw != 0 || (fresh && look.yaw != 0)) {
            rot_cancel |= CAMERA_ROT_CANCEL_AUTO_MOVE;
        }
    }
    // Other camera owners never inherit wheel zoom limits.
    if (zoom_keeps && zoom.active) {
        zoom.Move(*this, *scene, control, player_rot, polys, poly_count);
    } else {
        MoveCamera(&control, player_rot, polys, poly_count);
    }
    param->rest_min_height = rest_min_height;
    param->rest_max_height = rest_max_height;
    rot_cancel = saved_rot_cancel;

    // Stick deflection sets an angular rate per logic tick, with no queued turn
    // or distance-dependent acceleration. Follow movement keeps its own easing.
    const float yaw = look.yaw + stick_yaw;
    const float pitch = look.pitch + stick_pitch;
    if (!fresh || reset || !owns ||
        (yaw == 0 && pitch == 0) || !std::isfinite(yaw) || !std::isfinite(pitch)) {
        return;
    }

    // The retail collection encloses the old eye and cannot cover a mouse flick.
    // Collect the full current/pending orbit before turning or tilting.
    float radius = 5;
    for (const auto [eye, target] : {
             std::pair{pos,      ref     },
             std::pair{next_pos, next_ref}
    }) {
        float squared = 0;
        for (int i = 0; i < 3; ++i) {
            squared += (eye[i] - target[i]) * (eye[i] - target[i]);
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
    if (MouseCameraYaw(*this, yaw, orbit_polys, count) != 0) {
        CancelRotBack();
    }
    MouseCameraPitch(*this, pitch, orbit_polys, count, zoom_keeps ? zoom.HeightScale(*this) : 1.0f);
    // Direct motion is checked against the camera's data; a far zoom also keeps
    // the walls only the characters' collision knows out of the drawn view.
    if (zoom_keeps && zoom.active) {
        zoom.KeepVisible(*this, *scene, polys, poly_count);
    }
}

// Retail body, with the height ratio divided as the EE FPU divides it.
void CCameraControl::MoveCamera(Control *control, float *player_rot, CCPoly *polys, int poly_count) {
    CameraCtrlParam *active = nullptr;
    float            follow[4];
    float            follow_offset[4];
    float            to_target[4];
    float            direction[4];
    float            correction[4];
    float            distance = NAN;
    float            turn = NAN;
    float            rise = NAN;

    if (!control_on) {
        return;
    }

    active = GetActiveParam();
    GetFollow(follow);
    GetFollowOffset(follow_offset);
    sceVu0AddVector(next_ref, follow, follow_offset);
    sceVu0SubVector(to_target, next_ref, next_pos);
    to_target[1] = 0.0f;
    sceVu0Normalize(direction, to_target);
    mgZeroVector(correction);
    distance = mgDistVector(to_target);

    if (distance <= 0.0f) {
        distance = 1.0f;
        to_target[2] = 1.0f;
        direction[2] = 1.0f;
    }

    if (distance < active->min_dist) {
        sceVu0ScaleVector(correction, direction, distance - active->min_dist);
    }

    if (distance > active->max_dist) {
        sceVu0ScaleVector(correction, direction, distance - active->max_dist);
    }

    {
        float effective = NAN;
        float min_dist = active->min_dist;
        effective = min_dist;

        if (distance < min_dist) {
            effective = distance;
        }

        turn = (control->rot * min_dist) / effective;
    }

    if (turn != 0.0f) {
        Rotate(turn);
    }

    rise = control->height;
    active->height += rise;

    active->height = std::max(active->height, active->min_height);

    active->height = std::min(active->height, active->max_height);

    if (rise == 0.0f) {
        if (active->rest_min_height > active->height) {
            active->height += (active->rest_min_height - active->height) / 20.0f;
        }

        if (active->rest_max_height < active->height) {
            active->height += (active->rest_max_height - active->height) / 20.0f;
        }
    }

    {
        float near_distance = active->min_dist;
        float far_distance = active->max_dist;
        float near_height = active->near_height;
        float far_height = active->far_height;
        // Fishing's cast-point camera pins min_dist == max_dist. The EE FPU returns a signed FLT_MAX
        // there, which the equal heights then zero; a host division gives inf * 0 = NaN, the camera
        // is lost for good and the cast-point screen shows only the clear colour.
        float ratio = vu0::Div(distance - near_distance, far_distance - near_distance);
        correction[1] = vu0::Sat(near_height + vu0::Sat(ratio * (far_height - near_height)));
    }
    next_pos[1] = next_ref[1] + active->height;
    mgAddVector(next_pos, correction);

    if (control->rot_back && !(rot_cancel & CAMERA_ROT_CANCEL_ROT_BACK)) {
        RotBack(player_rot[1] - std::numbers::pi_v<float>);
    }

    if (rot_back) {
        float angle = mgAngleInterpolate(GetAngle(), rot_back_angle, 1.0f, 0);
        SetRotate(angle);

        if (mgAngleCmp(angle, rot_back_angle, 0.1f) == 0) {
            rot_back = false;
        }
    }

    if (!active->no_check) {
        CheckGround(polys, poly_count);

        if (turn != 0.0f || (rot_cancel & CAMERA_ROT_CANCEL_AUTO_MOVE)) {
            CheckCollision(polys, poly_count);
            return;
        }

        CheckCollision(polys, poly_count);
        AutoMove(polys, poly_count);
    }
}

void CCameraControl::Step(int frames) {
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
