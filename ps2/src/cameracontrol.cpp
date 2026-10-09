#include "common.h"

#include <cmath>

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

// Code (.text)
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
    control_on = 0;
    CameraCtrlParam *p = GetActiveParam();
    p->min_dist = 100.0f;
    p->max_dist = 160.0f;
    p->near_height = 18.0f;
    p->far_height = 10.0f;
    p->max_height = 40.0f;
    p->min_height = -15.0f;
    p->rest_max_height = 20.0f;
    p->rest_min_height = -15.0f;
    p->height = -15.0f;
    p->ground_space = 25.0f;
    check_ref_on = 0;
    p->no_check = 0;
    rot_reverse = 0;
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
    rot_back = 0;
    rot_back_angle = 0.0f;
    mgZeroVector(dir_offset);
}

void CCameraControl::ControlOn() {
    CameraCtrlParam *p;

    if (control_on == 0) {
        *(u_long128 *) next_ref = *(u_long128 *) ref;
        *(u_long128 *) next_pos = *(u_long128 *) pos;
        p = GetActiveParam();
        p->height = next_pos[1] - next_ref[1];

        if (p->height < p->min_height) {
            p->height = p->min_height;
        }

        if (p->height > p->max_height) {
            p->height = p->max_height;
        }
    }

    control_on = 1;
}

void CCameraControl::ControlOff() {
    control_on = 0;
}

void CCameraControl::Stay() {
    if (control_on == 0) {
        mgCCameraFollow::Stay();
    } else {
        mgCCamera::Stay();
    }
}

void CCameraControl::Step(int frames) {
    float offset[4];

    if (control_on == 0) {
        mgCCameraFollow::Step(frames);
        return;
    }

    if (frames < 0) {
        if (rot_back != 0) {
            SetRotate(rot_back_angle);
        }
    }

    mgCCamera::Step(frames);
    sceVu0SubVector(offset, next_ref, next_pos);
    distance = mgDistVector(offset);
    height = -offset[1];
    next_angle = atan2f(-offset[0], -offset[2]);
    sceVu0SubVector(offset, ref, pos);
    angle = atan2f(-offset[0], -offset[2]);
}

void CCameraControl::MoveCamera(CPadControl *pad, float *target, CCPoly *polys, int poly_count) {
    Control control;

    control.height = 0.0f;
    control.rot = 0.0f;
    control.rot_back = 0;

    if (pad != NULL) {
        float turn = 0.0f;

        if (!(rot_cancel & 2)) {
            turn = 0.05f * -pad->Analog(6);
        }

        if (!(rot_cancel & 1)) {
            if (pad->Btn(PAD_BTN_L1_HELD) != 0) {
                turn = 0.05f;
            }

            if (pad->Btn(PAD_BTN_R1_HELD) != 0) {
                turn = -0.05f;
            }
        }

        if (rot_reverse != 0) {
            turn = -turn;
        }

        control.rot = turn;
        control.height = 2.0f * -pad->Analog(7);
        int fast = pad->Btn(4) != 0;

        if (fast == 0) {
            fast = pad->Btn(1) != 0;
        }

        control.rot_back = fast & 0xFF;
    }

    MoveCamera(&control, target, polys, poly_count);
}

void CCameraControl::MoveCamera(Control *control, float *target, CCPoly *polys, int poly_count) {
    CameraCtrlParam *param;
    float            follow[4];
    float            follow_offset[4];
    float            to_target[4];
    float            direction[4];
    float            correction[4];
    float            distance;
    float            turn;
    float            zoom;

    if (control_on == 0) {
        return;
    }

    param = GetActiveParam();
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

    if (distance < param->min_dist) {
        sceVu0ScaleVector(correction, direction, distance - param->min_dist);
    }

    if (distance > param->max_dist) {
        sceVu0ScaleVector(correction, direction, distance - param->max_dist);
    }

    {
        float effective;
        float min_dist = param->min_dist;
        effective = min_dist;

        if (distance < min_dist) {
            effective = distance;
        }

        turn = (control->rot * min_dist) / effective;
    }

    if (turn != 0.0f) {
        Rotate(turn);
    }

    zoom = control->height;
    param->height += zoom;

    if (param->height < param->min_height) {
        param->height = param->min_height;
    }

    if (param->height > param->max_height) {
        param->height = param->max_height;
    }

    if (zoom == 0.0f) {
        if (param->rest_min_height > param->height) {
            param->height += (param->rest_min_height - param->height) / 20.0f;
        }

        if (param->rest_max_height < param->height) {
            param->height += (param->rest_max_height - param->height) / 20.0f;
        }
    }

    {
        float near_distance = param->min_dist;
        float far_distance = param->max_dist;
        float near_height = param->near_height;
        float far_height = param->far_height;
        float ratio = (distance - near_distance) / (far_distance - near_distance);
        correction[1] = near_height + ratio * (far_height - near_height);
    }
    next_pos[1] = next_ref[1] + param->height;
    mgAddVector(next_pos, correction);

    if (control->rot_back != 0 && !(rot_cancel & 0x40)) {
        RotBack(target[1] - 3.1415927f);
    }

    if (rot_back != 0) {
        float angle = mgAngleInterpolate(GetAngle(), rot_back_angle, 1.0f, 0);
        SetRotate(angle);

        if (mgAngleCmp(angle, rot_back_angle, 0.1f) == 0) {
            rot_back = 0;
        }
    }

    if (param->no_check == 0) {
        CheckGround(polys, poly_count);

        if (turn != 0.0f || (rot_cancel & 0x80)) {
            CheckCollision(polys, poly_count);
            return;
        }

        CheckCollision(polys, poly_count);
        AutoMove(polys, poly_count);
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
    float distance;
    float height;

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
    CameraCtrlParam *p;

    if (control_on == 0) {
        mgCCameraFollow::SetHeight(height);
    }

    p = GetActiveParam();
    next_pos[1] = next_ref[1] + height;
    p->height = height;
}

void CCameraControl::RotBack(float angle) {
    rot_back = 1;
    rot_back_angle = angle;
}

void CCameraControl::CancelRotBack() {
    rot_back = 0;
}

void CCameraControl::SetCheckRef(float *ref) {
    check_ref_on = 1;
    *(u_long128 *) check_ref = *(u_long128 *) ref;
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
    int   hit_index;
    int   slid;
    float old_dist;

    GetActiveParam();

    if (check_ref_on != 0) {
        *(u_long128 *) target = *(u_long128 *) check_ref;
        target[1] += follow_offset[1];
    } else {
        *(u_long128 *) target = *(u_long128 *) next_ref;
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
    slid = 0;
    hit_index = CheckHit(polys, poly_count, target, view_end, hit, 1, 0);

    if (hit_index < 0) {
        hit_index = -1;
        slid = 1;
        *(u_long128 *) hit = *(u_long128 *) unused_hit;
        *(u_long128 *) view_end = *(u_long128 *) side_end;
    }

    if (hit_index >= 0) {
        sceVu0SubVector(push, target, view_end);
        sceVu0Normalize(push, push);
        sceVu0ScaleVector(push, push, 5.0f);
        mgAddVector(hit, push);

        if (slid != 0) {
            old_dist = mgDistVectorXZ(next_pos, target);
            float ratio = mgDistVectorXZ(hit, target) / old_dist;
            hit[1] += ratio * (next_pos[1] - target[1]);
        }

        *(u_long128 *) next_pos = *(u_long128 *) hit;
        old_dist = mgDistVector(target, next_pos);

        if (!(old_dist - mgDistVector(target, hit) <= 5.0f)) {
            *(u_long128 *) pos = *(u_long128 *) hit;
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
    int   hit_count;
    int   found;
    int   step;
    int   result;
    float unit = 1.0f;
    float radius;
    float margin;

    GetActiveParam();

    if (check_ref_on != 0) {
        *(u_long128 *) target = *(u_long128 *) check_ref;
        target[1] += follow_offset[1];
    } else {
        *(u_long128 *) target = *(u_long128 *) next_ref;
    }

    radius = 4.0f;
    sceVu0SubVector(to_target, target, next_pos);
    sceVu0SubVector(to_pos, target, pos);
    mgDistVectorXZ(to_pos);
    margin = 0.9f;
    margin *= unit;
    radius *= unit;
    *(u_long128 *) ray_end = *(u_long128 *) target;
    *(u_long128 *) start_pos = *(u_long128 *) next_pos;
    *(u_long128 *) dir_copy = *(u_long128 *) to_target;
    sceVu0ScaleVector(ray_start, dir_copy, margin);
    sceVu0SubVector(ray_start, target, ray_start);
    ray_start[3] = radius;

    if (CheckHitsPipe(polys, poly_count, ray_start, ray_end, 1, &hit_count, &plane, 0, 0) <= 0) {
        return 1;
    }

    *(u_long128 *) rot_a = *(u_long128 *) dir_copy;
    rot_a[3] = 0.0f;
    *(u_long128 *) rot_b = *(u_long128 *) dir_copy;
    rot_b[3] = 0.0f;
    mgUnitMatrix(turn_a);
    mgUnitMatrix(turn_b);
    sceVu0RotMatrixY(turn_a, turn_a, 0.01636246219277382f);
    sceVu0RotMatrixY(turn_b, turn_b, -0.01636246219277382f);
    found = 0;
    *(u_long128 *) candidate = *(u_long128 *) start_pos;
    step = 0;

    do {
        sceVu0ApplyMatrix(rot_a, turn_a, rot_a);
        sceVu0SubVector(candidate, ray_end, rot_a);
        sceVu0ScaleVector(probe, rot_a, margin);
        sceVu0SubVector(probe, ray_end, probe);
        probe[3] = radius;

        if (CheckHitsPipe(polys, poly_count, probe, ray_end, 1, &hit_count, &plane, 0, 0) <= 0) {
            found = 1;
            break;
        }

        sceVu0ApplyMatrix(rot_b, turn_b, rot_b);
        sceVu0SubVector(candidate, ray_end, rot_b);
        sceVu0ScaleVector(probe, rot_b, margin);
        sceVu0SubVector(probe, ray_end, probe);
        probe[3] = radius;

        if (CheckHitsPipe(polys, poly_count, probe, ray_end, 1, &hit_count, &plane, 0, 0) <= 0) {
            found = 1;
            break;
        }

        step++;
    } while (step < 0x20);

    result = 0;

    if (found != 0) {
        result = 1;
        *(u_long128 *) next_pos = *(u_long128 *) candidate;
    }

    return result;
}

void CCameraControl::CheckGround(CCPoly *polys, int poly_count) {
    int              ceiling_index;
    float            target[4];
    int              indices[0x20];
    float            from[4];
    float            line_high[4];
    float            line_low[4];
    float            hits[0x20][4];
    float            hit_info[4];
    float            floor_normal[4];
    float            ceiling_normal[4];
    CameraCtrlParam *param;
    float            top;
    float            bottom;
    int              floor_index;
    int              count;
    int              i;

    param = GetActiveParam();

    if (check_ref_on != 0) {
        *(u_long128 *) target = *(u_long128 *) check_ref;
        target[1] += follow_offset[1];
    } else {
        *(u_long128 *) target = *(u_long128 *) next_ref;
    }

    *(u_long128 *) from = *(u_long128 *) next_pos;
    *(u_long128 *) line_high = *(u_long128 *) next_pos;
    *(u_long128 *) line_low = *(u_long128 *) next_pos;
    line_high[1] = 20.0f + (target[1] + param->max_height);
    line_low[1] = (target[1] + param->min_height) - param->ground_space;
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

            if (next_pos[1] - hits[i][1] < param->ground_space) {
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
            0.5f * (param->ground_space + hits[floor_index][1] + hits[ceiling_index][1] - 20.0f);
    } else {
        if (floor_index >= 0) {
            next_pos[1] = param->ground_space + hits[floor_index][1];
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
    *(u_long128 *) dest.follow_offset = *(u_long128 *) follow_offset;
}

int CCameraControl::Iam() {
    return 1000;
}
