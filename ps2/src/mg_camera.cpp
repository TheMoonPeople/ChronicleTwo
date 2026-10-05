#include "common.h"
#include "mg_memory.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mg_frame.hpp"
#include "mg_drawenv.hpp"
#include "mglib.hpp"
#include "mg_camera.hpp"
#include "mg_math.hpp"

#include <libvu0.h>

#include <cmath>

// Code (.text)
void mgCCamera::Step(int steps) {
    sceVu0FVECTOR dir;
    sceVu0FVECTOR flat;
    int step;
    int axis;

    if (suspended != 0 || mgCCamera::StopCamera != 0) {
        return;
    }

    if (pos_speed <= 0.0f) {
        pos_speed = 1.0f;
    }

    if (ref_speed <= 0.0f) {
        ref_speed = 1.0f;
    }

    if (steps < 0) {
        pos[0] = next_pos[0];
        ref[0] = next_ref[0];
        pos[1] = next_pos[1];
        ref[1] = next_ref[1];
        pos[2] = next_pos[2];
        ref[2] = next_ref[2];
    } else {
        for (step = 0; step < steps; step++) {
            for (axis = 0; axis < 3; axis++) {
                float speed = pos_speed;

                if (speed <= 1.0f && ref_speed <= 1.0f) {
                    pos[axis] = next_pos[axis];
                    ref[axis] = next_ref[axis];
                } else {
                    float look_speed = ref_speed;
                    float left_pos;
                    float left_ref;

                    if (look_speed < 1.0f) {
                        look_speed = 1.0f;
                    }

                    pos[axis] += (next_pos[axis] - pos[axis]) / speed;
                    ref[axis] += (next_ref[axis] - ref[axis]) / look_speed;

                    // The last step of the movement is not exact, so the eye
                    // and the look-at point snap on once they are near enough.
                    left_pos = pos[axis] - next_pos[axis];
                    left_ref = ref[axis] - next_ref[axis];

                    if (left_pos < 0.0f) {
                        left_pos = -left_pos;
                    }

                    if (left_pos < snap_range) {
                        pos[axis] = next_pos[axis];
                    }

                    if (left_ref < 0.0f) {
                        left_ref = -left_ref;
                    }

                    if (left_ref < snap_range) {
                        ref[axis] = next_ref[axis];
                    }
                }
            }
        }
    }

    // The horizontal angle comes from the view direction with its height taken out.
    GetDir(dir);
    flat[0] = dir[0];
    flat[1] = 0.0f;
    flat[2] = dir[2];
    flat[3] = 0.0f;
    sceVu0Normalize(flat, flat);
    angle_h = atan2f(-flat[0], -flat[2]);
    angle_v = -atan2f(dir[1], sqrtf(dir[0] * dir[0] + dir[2] * dir[2]));
}

void mgCCamera::Stay() {
    sceVu0CopyVector(next_pos, pos);
    sceVu0CopyVector(next_ref, ref);
}

void mgCCamera::SetPos(float x, float y, float z) {
    next_pos[0] = x;
    pos[0] = x;
    next_pos[1] = y;
    pos[1] = y;
    next_pos[2] = z;
    pos[2] = z;
    next_pos[3] = 1.0f;
    pos[3] = 1.0f;
}

void mgCCamera::SetPos(float *pos) {
    SetPos(pos[0], pos[1], pos[2]);
}

void mgCCamera::SetNextPos(float x, float y, float z) {
    next_pos[0] = x;
    next_pos[1] = y;
    next_pos[2] = z;
}

void mgCCamera::SetNextPos(float *pos) {
    SetNextPos(pos[0], pos[1], pos[2]);
}

void mgCCamera::SetRef(float x, float y, float z) {
    ref[0] = x;
    next_ref[0] = x;
    ref[1] = y;
    next_ref[1] = y;
    ref[2] = z;
    next_ref[2] = z;
}

void mgCCamera::SetRef(float *ref) {
    SetRef(ref[0], ref[1], ref[2]);
}

void mgCCamera::SetNextRef(float x, float y, float z) {
    next_ref[0] = x;
    next_ref[1] = y;
    next_ref[2] = z;
}

void mgCCamera::SetNextRef(float *ref) {
    SetNextRef(ref[0], ref[1], ref[2]);
}

void mgCCamera::GetDir(float *dir) {
    dir[0] = ref[0] - pos[0];
    dir[1] = ref[1] - pos[1];
    dir[2] = ref[2] - pos[2];
}

void mgCCamera::GetCameraMatrix(float (*matrix)[4]) {
    sceVu0FVECTOR dir;
    sceVu0FVECTOR up;

    // The up direction lies in the vertical plane of the view direction, at
    // right angles to it.
    GetDir(dir);
    up[0] = dir[0] * dir[1];
    up[1] = -(dir[0] * dir[0] + dir[2] * dir[2]);
    up[2] = dir[1] * dir[2];
    up[3] = 1.0f;
    sceVu0Normalize(up, up);
    sceVu0Normalize(dir, dir);
    sceVu0CameraMatrix(matrix, pos, dir, up);
}

void mgCCamera::SetSpeed(float pos_speed, float ref_speed) {
    this->pos_speed = pos_speed;
    this->ref_speed = ref_speed;

    if (ref_speed < 0.0f) {
        this->ref_speed = this->pos_speed;
    }
}

void mgCCamera::SetRoll(float roll) {
    this->roll = roll;
}

void mgCCamera::GetPos(float *pos) {
    sceVu0CopyVector(pos, this->pos);
}

void mgCCamera::GetRef(float *ref) {
    sceVu0CopyVector(ref, this->ref);
}

void mgCCamera::GetNextPos(float *pos) {
    sceVu0CopyVector(pos, next_pos);
}

void mgCCamera::GetNextRef(float *ref) {
    sceVu0CopyVector(ref, next_ref);
}

float mgCCamera::GetAngleH() {
    return angle_h;
}

float mgCCamera::GetAngleV() {
    return angle_v;
}

mgCCamera::mgCCamera(float speed) {
    pos_speed = speed;

    if (pos_speed <= 0.0f) {
        pos_speed = 1.0f;
    }

    ref_speed = pos_speed;
    unk_44 = 0;
    roll = 0.0f;
    snap_range = 0.1f;
    suspended = 0;
}

void mgCCameraFollow::GetFollowNextPos(float *pos) {
    pos[0] = follow_next[0] + distance * sinf(angle);
    pos[1] = follow_next[1] + height;
    pos[2] = follow_next[2] + distance * cosf(angle);
    pos[3] = 1.0f;
}

void mgCCameraFollow::GetFollowNext(float *pos) {
    GetFollow(pos);
    mgAddVector(pos, follow_offset);
}

void mgCCameraFollow::Step(int steps) {
    sceVu0FVECTOR next_pos;
    int step;

    if (suspended != 0 || mgCCamera::StopCamera != 0) {
        return;
    }

    sceVu0AddVector(follow_next, follow, follow_offset);

    // A step count below zero turns the eye onto its angle without any of the
    // steps in between.
    if (steps < 0) {
        if (follow_on != 0) {
            angle = next_angle;
            GetFollowNextPos(next_pos);
            SetNextPos(next_pos);
            SetNextRef(follow_next[0], follow_next[1], follow_next[2]);
        }

        mgCCamera::Step(steps);
        return;
    }

    // The angle that the eye turns to stays inside one turn.
    if (next_angle > 6.2831855f) {
        next_angle -= 6.2831855f;
    }

    if (next_angle < 0.0f) {
        next_angle += 6.2831855f;
    }

    for (step = 0; step < steps; step++) {
        if (follow_on != 0) {
            float turn = pos_speed / 2.0f;

            if (turn < 1.0f) {
                turn = 1.0f;
            }

            angle = mgAngleInterpolate(angle, next_angle, turn, MG_INTERPOLATE_FRACTION);

            // An eye that reaches its position in about one step turns at
            // once as well.
            if (pos_speed < 1.1f) {
                angle = next_angle;
            }

            GetFollowNextPos(next_pos);
            SetNextPos(next_pos);
            SetNextRef(follow_next[0], follow_next[1], follow_next[2]);
        }

        mgCCamera::Step(1);
    }

    // An eye that no longer circles the point takes the angle that the base
    // camera measured for it.
    if (follow_on == 0) {
        next_angle = angle_h;
        angle = angle_h;
    }
}

void mgCCameraFollow::Stay() {
    mgCCamera::Stay();

    if (follow_on != 0) {
        sceVu0CopyVector(follow_next, next_ref);
        next_angle = angle;
    }
}

void mgCCameraFollow::SetFollow(float x, float y, float z) {
    follow[0] = x;
    follow[1] = y;
    follow[2] = z;
}

void mgCCameraFollow::FollowOn() {
    follow_on = 1;
}

void mgCCameraFollow::FollowOff() {
    follow_on = 0;
}

void mgCCameraFollow::SetAngle(float angle) {
    next_angle = angle;
}

void mgCCameraFollow::SetAngleSoon(float angle) {
    next_angle = angle;
    this->angle = angle;
}

float mgCCameraFollow::GetAngle() {
    return angle;
}

void mgCCameraFollow::AddAngle(float delta) {
    next_angle += delta;
}

void mgCCameraFollow::SetDistance(float distance) {
    this->distance = distance;
}

float mgCCameraFollow::GetDistance() {
    return distance;
}

void mgCCameraFollow::AddDistance(float delta) {
    distance += delta;
}

void mgCCameraFollow::SetHeight(float height) {
    this->height = height;
}

float mgCCameraFollow::GetHeight() {
    return height;
}

void mgCCameraFollow::AddHeight(float delta) {
    height += delta;
}

void mgCCameraFollow::SetFollowOffset(float x, float y, float z) {
    follow_offset[0] = x;
    follow_offset[1] = y;
    follow_offset[2] = z;
}

void mgCCameraFollow::GetFollow(float *pos) {
    *(u_long128 *)pos = *(u_long128 *)follow;
}

void mgCCameraFollow::GetFollowOffset(float *offset) {
    *(u_long128 *)offset = *(u_long128 *)follow_offset;
}

mgCCameraFollow::mgCCameraFollow(float distance, float height, float angle, float speed) : mgCCamera(speed) {
    follow_next[0] = 0.0f;
    follow_next[1] = 0.0f;
    follow_next[2] = 0.0f;
    next_angle = angle;
    this->angle = angle;
    this->distance = distance;
    this->height = height;
    follow_on = 1;
    mgZeroVector(follow_offset);
}

    // Defined in mg_camera.hpp.
    // Defined in mg_camera.hpp.
    // Defined in mg_camera.hpp.
    // Defined in mg_camera.hpp.
// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_camera", __vt__15mgCCameraFollow__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_camera", __vt__9mgCCamera__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(StopCamera__9mgCCamera, 0x4);
