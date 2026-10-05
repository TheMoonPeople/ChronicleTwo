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
void mgCCamera::Step(int frames) {
    mgCCamera *self = this;
    float dir[4];
    struct {
        float x;
        float y;
        float z;
        float w;
    } flat;
    int frame;
    int i;
    if (self->suspended == 0 && mgCCamera::StopCamera == 0) {
        if (self->pos_speed <= 0.0f) {
            self->pos_speed = 1.0f;
        }
        if (self->ref_speed <= 0.0f) {
            self->ref_speed = 1.0f;
        }
        if (frames < 0) {
            self->pos[0] = self->next_pos[0];
            self->ref[0] = self->next_ref[0];
            self->pos[1] = self->next_pos[1];
            self->ref[1] = self->next_ref[1];
            self->pos[2] = self->next_pos[2];
            self->ref[2] = self->next_ref[2];
        } else if (0 < frames) {
            frame = 0;
            do {
                i = 0;
                do {
                    if (self->pos_speed <= 1.0f && self->ref_speed <= 1.0f) {
                        self->pos[i] = self->next_pos[i];
                        self->ref[i] = self->next_ref[i];
                    } else {
                        float posStep = (self->next_pos[i] - self->pos[i]) / self->pos_speed;
                        float refRate = self->ref_speed;
                        if (refRate < 1.0f) {
                            refRate = 1.0f;
                        }
                        float refStep = (self->next_ref[i] - self->ref[i]) / refRate;
                        self->pos[i] += posStep;
                        self->ref[i] += refStep;
                        float posError = self->pos[i] - self->next_pos[i];
                        float refError = self->ref[i] - self->next_ref[i];
                        posError = posError < 0.0f ? -posError : posError;
                        if (posError < self->snap_range) {
                            self->pos[i] = self->next_pos[i];
                        }
                        refError = refError < 0.0f ? -refError : refError;
                        if (refError < self->snap_range) {
                            self->ref[i] = self->next_ref[i];
                        }
                    }
                    i++;
                } while (i < 3);
                frame++;
            } while (frame < frames);
        }
        self->GetDir(dir);
        flat.x = dir[0];
        flat.y = 0.0f;
        flat.z = dir[2];
        flat.w = 0.0f;
        sceVu0Normalize(&flat.x, &flat.x);
        self->angle_h = atan2f(-flat.x, -flat.z);
        self->angle_v = -atan2f(dir[1], sqrtf(dir[0] * dir[0] + dir[2] * dir[2]));
    }
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
    struct {
        float x, y, z;
        float w;
    } forward;
    struct {
        float x, y, z;
        unsigned int w;
    } up;
    GetDir(&forward.x);
    forward.x = forward.x;
    forward.y = forward.y;
    forward.z = forward.z;
    up.x = forward.x * forward.y;
    up.y = -(forward.x * forward.x + forward.z * forward.z);
    up.z = forward.y * forward.z;
    up.w = 0x3F800000;
    sceVu0Normalize(&up.x, &up.x);
    sceVu0Normalize(&forward.x, &forward.x);
    sceVu0CameraMatrix(matrix, pos, &forward.x, &up.x);
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

void mgCCameraFollow::Step(int frames) {
    float pos[4];
    int i;
    float rate;
    if (suspended == 0 && StopCamera == 0) {
        sceVu0AddVector(follow_next, follow, follow_offset);
        if (frames < 0) {
            if (follow_on != 0) {
                angle = next_angle;
                GetFollowNextPos(pos);
                SetNextPos(pos);
                SetNextRef(follow_next[0], follow_next[1], follow_next[2]);
            }
            mgCCamera::Step(frames);
            return;
        }
        if (!(next_angle <= 6.2831855f)) {
            next_angle -= 6.2831855f;
        }
        if (next_angle < 0.0f) {
            next_angle += 6.2831855f;
        }
        i = 0;
        if (0 < frames) {
            do {
                if (follow_on != 0) {
                    rate = pos_speed / 2.0f;
                    if (rate < 1.0f) {
                        rate = 1.0f;
                    }
                    angle = mgAngleInterpolate(angle, next_angle, rate, 1);
                    if (pos_speed < 1.1f) {
                        angle = next_angle;
                    }
                    GetFollowNextPos(pos);
                    SetNextPos(pos);
                    SetNextRef(follow_next[0], follow_next[1], follow_next[2]);
                }
                mgCCamera::Step(1);
                i++;
            } while (i < frames);
        }
        if (follow_on == 0) {
            next_angle = angle_h;
            angle = angle_h;
        }
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
