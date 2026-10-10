#include "common.h"

#include <cmath>
#include <cstring>

#include "character.hpp"
#include "collision.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "eventsprite.hpp"
#include "mainloop.hpp"
#include "mg_camera.hpp"
#include "mg_drawenv.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "sceneseq.hpp"
#include "scenesnd.hpp"
#include "sound.hpp"

#define CONVERT_TO_PAL_FRAMES(frames)    \
    if ((frames) > 0) {                  \
        (frames) = ((frames) * 50) / 60; \
        if ((frames) <= 0) {             \
            (frames) = 1;                \
        }                                \
    }

// Code (.text)
/**
 *
 * Clears a spline key before camera or character path setup.
 *
 */
static void InitSplineKey(SPLINE_KEY *key) {
    key->frame = 0;
    key->length = 0;
    key->a[0] = 0;
    key->b[0] = 0;
    key->c[0] = 0;
    key->d[0] = 0;
    key->a[1] = 0;
    key->b[1] = 0;
    key->c[1] = 0;
    key->d[1] = 0;
    key->a[2] = 0;
    key->b[2] = 0;
    key->c[2] = 0;
    key->d[2] = 0;
}

C3DSpline::C3DSpline() {
    Initialize();
}

void C3DSpline::Initialize() {
    for (int index = 0; index < 16; index++) {
        InitSplineKey(key + index);
    }

    key_num = 0;
    now_key = 0;
    now_frame = 0;
    speed = 0;
}

void C3DSpline::SetUpSpline(float (*points)[4], int *frames, int count, float step_speed) {
    float padded[18][4];
    int   index;
    int   axis;
    float start_slope;
    float end_slope;
    float start;
    float end;
    Initialize();

    if (count <= 0) {
        return;
    }

    key_num = count;
    speed = step_speed;

    for (index = 0; index < key_num; index++) {
        sceVu0CopyVector(padded[index], points[index]);
    }

    sceVu0CopyVector(padded[key_num], points[key_num - 1]);
    sceVu0CopyVector(padded[key_num + 1], points[key_num - 1]);
    now_pos[0] = points[0][0];
    now_pos[1] = points[0][1];
    now_pos[2] = points[0][2];

    for (index = 0; index < key_num; index++) {
        if (index == 0) {
            key[index].frame = 0;
            key[index].length = frames[index];
        } else if (index == key_num - 1) {
            key[index].frame = key[index - 1].frame + key[index - 1].length;
            key[index].length = 0;
        } else {
            key[index].frame = key[index - 1].frame + key[index - 1].length;
            key[index].length = frames[index];
        }
    }

    for (index = 0; index < key_num; index++) {
        for (axis = 0; axis < 3; axis++) {
            start = padded[index][axis];
            end = padded[index + 1][axis];

            if (index == 0) {
                start_slope = end - start;
            } else {
                start_slope = (key[index].length * (start - padded[index - 1][axis]) +
                               key[index - 1].length * (end - start)) /
                              (key[index - 1].length + key[index].length);
            }

            if (index == key_num - 1) {
                end_slope = padded[index + 2][axis] - end;
            } else {
                end_slope = (key[index].length * (padded[index + 2][axis] - end) +
                             key[index + 1].length * (end - start)) /
                            (key[index].length + key[index + 1].length);
            }

            key[index].a[axis] = start_slope + (2.0f * start - 2.0f * end) + end_slope;
            key[index].b[axis] = -3.0f * start + 3.0f * end - 2.0f * start_slope - end_slope;
            key[index].c[axis] = start_slope;
            key[index].d[axis] = start;
        }
    }
}

int C3DSpline::StepS() {
    float previous[4];
    float next[4];

    if (key_num < 2) {
        return 1;
    }

    if (speed <= 0.0f) {
        return 1;
    }

    do {
        now_frame += 0.001f;

        if (!(now_frame < key[now_key].frame + key[now_key].length)) {
            now_key++;

            if (now_key >= key_num) {
                now_pos[0] = key[key_num - 1].d[0];
                now_pos[1] = key[key_num - 1].d[1];
                now_pos[2] = key[key_num - 1].d[2];
                now_key = key_num - 1;
                now_frame = key[now_key].frame + key[now_key].length + 100.0f;
                return 1;
            }
        }

        float time = (now_frame - key[now_key].frame) / key[now_key].length;
        float square = time * time;
        float cube = square * time;

        for (int index = 0; index < 3; index++) {
            previous[index] = now_pos[index];
            next[index] = cube * key[now_key].a[index] + square * key[now_key].b[index] + time * key[now_key].c[index] + key[now_key].d[index];
        }

        previous[3] = 1.0f;
        next[3] = 1.0f;
    } while (mgDistVector(previous, next) < speed);

    now_pos[0] = next[0];
    now_pos[1] = next[1];
    now_pos[2] = next[2];
    return 0;
}

int C3DSpline::Step() {
    if (key_num < 2) {
        return 1;
    }

    now_frame += 1.0f;

    if (!(now_frame < key[now_key].frame + key[now_key].length)) {
        now_key++;

        if (now_key >= key_num) {
            now_pos[0] = key[key_num - 1].d[0];
            now_pos[1] = key[key_num - 1].d[1];
            now_pos[2] = key[key_num - 1].d[2];
            now_key = key_num - 1;
            now_frame = key[now_key].frame + key[now_key].length + 100.0f;
            return 1;
        }
    }

    float time = (now_frame - key[now_key].frame) / key[now_key].length;
    float square = time * time;
    float cube = square * time;

    for (int index = 0; index < 3; index++) {
        now_pos[index] = cube * key[now_key].a[index] + square * key[now_key].b[index] + time * key[now_key].c[index] + key[now_key].d[index];
    }

    return 0;
}

void C3DSpline::GetNowXYZ(float *out) {
    out[0] = now_pos[0];
    out[1] = now_pos[1];
    out[2] = now_pos[2];
    ((int *) out)[3] = 0x3F800000;
}

CCameraPas::CCameraPas() {
    Initialize();
}

int CCameraPas::AddCameraPas(float *eye_point, float *look_point) {
    if (pas_num >= 16) {
        return 1;
    }

    sceVu0CopyVector(pos[pas_num], eye_point);
    sceVu0CopyVector(ref[pas_num], look_point);
    pas_num++;
    return 0;
}

int CCameraPas::InsCameraPas(int index, float *eye_point, float *look_point) {
    float carry_eye[4];
    float carry_look[4];
    float saved_eye[4];
    float saved_look[4];

    if (index >= 16) {
        return 1;
    }

    sceVu0CopyVector(carry_eye, eye_point);
    sceVu0CopyVector(carry_look, look_point);

    while (pas_num >= index) {
        if (index == 16) {
            break;
        }

        sceVu0CopyVector(saved_eye, pos[index]);
        sceVu0CopyVector(saved_look, ref[index]);
        sceVu0CopyVector(pos[index], carry_eye);
        sceVu0CopyVector(ref[index], carry_look);
        sceVu0CopyVector(carry_eye, saved_eye);
        sceVu0CopyVector(carry_look, saved_look);
        index++;
    }

    pas_num++;

    if (pas_num >= 16) {
        pas_num = 16;
    }

    return 0;
}

int CCameraPas::SetCameraPas(int index, float *eye_point, float *look_point) {
    if (index >= 16) {
        return 1;
    }

    sceVu0CopyVector(pos[index], eye_point);
    sceVu0CopyVector(ref[index], look_point);
    return 0;
}

int CCameraPas::GetCameraPas(int index, float *eye_point, float *look_point) {
    if (index >= 16) {
        return 1;
    }

    sceVu0CopyVector(eye_point, pos[index]);
    sceVu0CopyVector(look_point, ref[index]);
    return 0;
}

int CCameraPas::DelCameraPas(int index) {
    int i;

    if (index >= 16) {
        return 1;
    }

    for (i = index; i < pas_num; i++) {
        if (i < 16) {
            sceVu0CopyVector(pos[i], pos[i + 1]);
            sceVu0CopyVector(ref[i], ref[i + 1]);
        } else {
            mgZeroVector(pos[i]);
            mgZeroVector(ref[i]);
        }
    }

    pas_num--;

    if (pas_num < 0) {
        pas_num = 0;
    }

    return 0;
}

int CCameraPas::SetFrame(int frame_count) {
    frame = frame_count;
    return 0;
}

int CCameraPas::GetFrame() {
    return frame;
}

void CCameraPas::Initialize() {
    for (int i = 0; i < 16; i++) {
        mgZeroVector(pos[i]);
        mgZeroVector(ref[i]);
    }

    pas_num = 0;
    run = 0;
    frame = 0;
    pos_spline.Initialize();
    ref_spline.Initialize();
}

int CCameraPas::Setup() {
    int   frames[16];
    float distances[16];
    float eye_now[4];
    float eye_next[4];
    float look_now[4];
    float look_next[4];
    float total_length;
    int   i;

    if (pas_num <= 0) {
        return 1;
    }

    total_length = 0.0f;

    for (i = 0; i < pas_num - 1; i++) {
        distances[i] = mgDistVector(pos[i], pos[i + 1]);
        total_length += distances[i];
    }

    for (i = 0; i < pas_num - 1; i++) {
        frames[i] = frame / (pas_num - 1);
    }

    pos_spline.SetUpSpline(pos, frames, pas_num, 0.0f);
    total_length = 0.0f;

    for (;;) {
        pos_spline.GetNowXYZ(eye_now);

        if (pos_spline.Step() != 0) {
            break;
        }

        pos_spline.GetNowXYZ(eye_next);
        total_length += mgDistVector(eye_now, eye_next);
    }

    pos_spline.SetUpSpline(pos, frames, pas_num, total_length / (float) frame);
    total_length = 0.0f;

    for (i = 0; i < pas_num - 1; i++) {
        distances[i] = mgDistVector(ref[i], ref[i + 1]);
        total_length += distances[i];
    }

    for (i = 0; i < pas_num - 1; i++) {
        frames[i] = frame / (pas_num - 1);
    }

    ref_spline.SetUpSpline(ref, frames, pas_num, 0.0f);
    total_length = 0.0f;

    for (;;) {
        ref_spline.GetNowXYZ(look_now);

        if (ref_spline.Step() != 0) {
            break;
        }

        ref_spline.GetNowXYZ(look_next);
        total_length += mgDistVector(look_now, look_next);
    }

    ref_spline.SetUpSpline(ref, frames, pas_num, total_length / (float) frame);
    return 0;
}

void CCameraPas::Run() {
    run = 1;
}

void CCameraPas::Step(float *eye_out, float *look_out) {
    int eye_moving;
    int look_moving;

    if (run != 0) {
        eye_moving = 0;
        look_moving = 0;

        if (pos_spline.StepS() != 0) {
            eye_moving = 1;
        }

        if (ref_spline.StepS() != 0) {
            look_moving = 1;
        }

        if (eye_moving != 0) {
            if (look_moving != 0) {
                run = 0;
            }
        }

        pos_spline.GetNowXYZ(eye_out);
        ref_spline.GetNowXYZ(look_out);
    }
}

int CCameraPas::CheckEnd() {
    return (u8) (((u32) run > 0) ^ 1);
}

CCharaPas::CCharaPas() {
    Initialize();
}

void CCharaPas::Initialize() {
    for (int i = 0; i < 16; i++) {
        mgZeroVector(pos[i]);
    }

    frame = 0;
    pas_num = 0;
    spline.Initialize();
    run = 0;
    end = 0;
}

int CCharaPas::AddCharaPas(float *point) {
    int n;

    n = pas_num;

    if (n >= 16) {
        return 1;
    }

    sceVu0CopyVector(pos[n], point);
    pas_num += 1;
    return 0;
}

int CCharaPas::Setup() {
    int   frames[16];
    float distances[16];
    float point_now[4];
    float point_next[4];
    float total_length;
    int   i;

    if (pas_num <= 0) {
        return 1;
    }

    total_length = 0.0f;

    for (i = 0; i < pas_num - 1; i++) {
        distances[i] = mgDistVector(pos[i], pos[i + 1]);
        total_length += distances[i];
    }

    for (i = 0; i < pas_num - 1; i++) {
        frames[i] = frame / (pas_num - 1);
    }

    spline.SetUpSpline(pos, frames, pas_num, 0.0f);
    total_length = 0.0f;

    for (;;) {
        spline.GetNowXYZ(point_now);

        if (spline.Step() != 0) {
            break;
        }

        spline.GetNowXYZ(point_next);
        total_length += mgDistVector(point_now, point_next);
    }

    spline.SetUpSpline(pos, frames, pas_num, total_length / (float) frame);
    return 0;
}

void CCharaPas::Run() {
    if (pas_num > 0) {
        run = 1;
    }
}

void CCharaPas::Step(float *pos, float *angle) {
    float prev_pos[4];
    float delta[4];
    float heading;

    if (run == 0) {
        return;
    }

    if (end != 0) {
        spline.GetNowXYZ(pos);
        run = 0;
        end = 0;
        return;
    }

    spline.GetNowXYZ(pos);

    if (spline.StepS() != 0) {
        end = 1;
    }

    spline.GetNowXYZ(prev_pos);
    sceVu0SubVector(delta, prev_pos, pos);

    if (delta[0] == 0.0f && delta[2] == 0.0f) {
        return;
    }

    heading = atan2f(delta[0], delta[2]);
    heading -= 3.1415927f * (2.0f * (float) (int) (heading / 6.2831855f));

    if (heading > 3.1415927f) {
        heading -= 6.2831855f;
    }

    if (heading <= -3.1415927f) {
        heading += 6.2831855f;
    }

    *angle = heading;
}

int CCharaPas::CheckEnd() {
    return (u8) (((u32) run > 0) ^ 1);
}

int CCharaPas::InsCharaPas(int index, float *point) {
    float carry[4];
    float saved[4];

    if (index >= 16) {
        return 1;
    }

    sceVu0CopyVector(carry, point);

    while (pas_num >= index) {
        if (index == 16) {
            break;
        }

        sceVu0CopyVector(saved, pos[index]);
        sceVu0CopyVector(pos[index], carry);
        sceVu0CopyVector(carry, saved);
        index++;
    }

    pas_num++;

    if (pas_num >= 16) {
        pas_num = 16;
    }

    return 0;
}

int CCharaPas::SetCharaPas(int index, float *point) {
    if (index >= 16) {
        return 1;
    }

    sceVu0CopyVector(pos[index], point);
    return 0;
}

int CCharaPas::GetCharaPas(int index, float *point) {
    if (index >= 16) {
        return 1;
    }

    sceVu0CopyVector(point, pos[index]);
    return 0;
}

int CCharaPas::DelCharaPas(int index) {
    int i;

    if (index >= 16) {
        return 1;
    }

    for (i = index; i < pas_num; i++) {
        if (i < 16) {
            sceVu0CopyVector(pos[i], pos[i + 1]);
        } else {
            mgZeroVector(pos[i]);
        }
    }

    pas_num--;

    if (pas_num < 0) {
        pas_num = 0;
    }

    return 0;
}

void CCharaPas::SetFrame(int frame_count) {
    frame = frame_count;
}

int CCharaPas::GetFrame() {
    return frame;
}

/**
 *
 * Waits the requested number of frames before the next camera position command.
 *
 */
static int scsPRDelay(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
    int frame_count;

    frame_count = owner->pr_cnt;

    if (frame_count >= node->frame) {
        owner->pr_cnt = 0;
        return 0;
    }

    owner->pr_cnt = frame_count + 1;
    return 1;
}

/**
 *
 * Sets the camera eye position and recomputes its angle, height, and distance.
 *
 */
static int scsSetPos(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
    float delta[4];
    float direction[4];
    float eye_flat[4];
    float ref_flat[4];
    sceVu0CopyVector(owner->pos, node->vec0);
    sceVu0SubVector(delta, owner->ref, owner->pos);
    direction[0] = delta[0];
    direction[1] = 0.0f;
    direction[2] = delta[2];
    direction[3] = 0.0f;
    sceVu0Normalize(direction, direction);
    owner->angle = atan2f(-direction[0], -direction[2]);
    owner->height = owner->pos[1] - owner->ref[1];
    sceVu0CopyVector(eye_flat, owner->pos);
    eye_flat[1] = 0.0f;
    sceVu0CopyVector(ref_flat, owner->ref);
    ref_flat[1] = 0.0f;
    owner->dist = mgDistVector(eye_flat, ref_flat);
    return 0;
}

/**
 *
 * Sets the camera focus position and recomputes its angle, height, and distance.
 *
 */
static int scsSetRef(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
    float delta[4];
    float direction[4];
    float eye_flat[4];
    float ref_flat[4];
    sceVu0CopyVector(owner->ref, node->vec1);
    sceVu0SubVector(delta, owner->ref, owner->pos);
    direction[0] = delta[0];
    direction[1] = 0.0f;
    direction[2] = delta[2];
    direction[3] = 0.0f;
    sceVu0Normalize(direction, direction);
    owner->angle = atan2f(-direction[0], -direction[2]);
    owner->height = owner->pos[1] - owner->ref[1];
    sceVu0CopyVector(eye_flat, owner->pos);
    eye_flat[1] = 0.0f;
    sceVu0CopyVector(ref_flat, owner->ref);
    ref_flat[1] = 0.0f;
    owner->dist = mgDistVector(eye_flat, ref_flat);
    return 0;
}

/**
 *
 * Waits the requested number of frames before the next angle-height-distance command.
 *
 */
static int scsAHDDelay(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
    int frame_count;

    frame_count = owner->ahd_cnt;

    if (frame_count >= node->frame) {
        owner->ahd_cnt = 0;
        return 0;
    }

    owner->ahd_cnt = frame_count + 1;
    return 1;
}

/**
 *
 * Sets the camera orbit angle while keeping its focus and distance.
 *
 */
static int scsSetAngle(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
    owner->pos[0] = owner->ref[0] + owner->dist * sinf(node->value);
    owner->pos[2] = owner->ref[2] + owner->dist * cosf(node->value);
    owner->angle = node->value;
    return 0;
}

/**
 *
 * Sets the camera height above its focus point.
 *
 */
static int scsSetHeight(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
    owner->pos[1] = node->value + owner->ref[1];
    owner->height = node->value;
    return 0;
}

/**
 *
 * Sets the camera distance from its focus point.
 *
 */
static int scsSetDist(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
    owner->pos[0] = owner->ref[0] + node->value * sinf(owner->angle);
    owner->pos[2] = owner->ref[2] + node->value * cosf(owner->angle);
    owner->dist = node->value;
    return 0;
}

/**
 *
 * Sets the camera orbit angle, height, and distance, including synchronized values.
 *
 */
static int scsSetAHD(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
    if (owner->sync != 0) {
        owner->sync_angle = node->vec0[0];
        owner->sync_height = node->vec0[1];
        owner->sync_dist = node->vec0[2];
    } else {
        owner->pos[0] = owner->ref[0] + (node->vec0[2] * sinf(node->vec0[0]));
        owner->pos[1] = node->vec0[1] + owner->ref[1];
        owner->pos[2] = owner->ref[2] + (node->vec0[2] * cosf(node->vec0[0]));
        owner->angle = node->vec0[0];
        owner->height = node->vec0[1];
        owner->dist = node->vec0[2];
    }

    return 0;
}

/**
 *
 * Moves camera eye and focus linearly toward the command positions.
 *
 */
static int scsMove(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
    float delta[4];

    if (owner->pr_cnt >= node->frame) {
        sceVu0CopyVector(owner->pos, node->vec0);
        sceVu0CopyVector(owner->ref, node->vec1);
        owner->pr_cnt = 0;
        return 0;
    }

    if (owner->pr_cnt <= 0) {
        sceVu0SubVector(delta, node->vec0, owner->pos);
        sceVu0DivVector(owner->pos_spd, delta, node->frame);
        owner->pos_spd[3] = 1.0f;
        sceVu0SubVector(delta, node->vec1, owner->ref);
        sceVu0DivVector(owner->ref_spd, delta, node->frame);
        owner->ref_spd[3] = 1.0f;
        sceVu0CopyVector(owner->pos_vel, owner->pos_spd);
        sceVu0CopyVector(owner->ref_vel, owner->ref_spd);
    } else {
        sceVu0AddVector(owner->pos, owner->pos, owner->pos_spd);
        owner->pos[3] = 1.0f;
        sceVu0AddVector(owner->ref, owner->ref, owner->ref_spd);
        owner->ref[3] = 1.0f;
    }

    owner->pr_cnt++;
    return 1;
}

/**
 *
 * Moves camera eye and focus with the requested easing mode.
 *
 */
static int scsMove2(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
    float pos_delta[4];
    float ref_delta[4];
    int   ended;
    int   moved;

    if (node->mode == SCENE_SEQ_EASE_IN_OUT) {
        ended = owner->ease_frame;
    } else {
        ended = owner->ease_frame / 2;
    }

    if (owner->pr_cnt >= node->frame + ended) {
        owner->pr_cnt = 0;
        return 0;
    }

    if (owner->pr_cnt <= 0) {
        sceVu0SubVector(pos_delta, node->vec0, owner->pos);
        sceVu0DivVector(owner->pos_spd, pos_delta, node->frame);
        owner->pos_spd[3] = 1.0f;
        sceVu0SubVector(ref_delta, node->vec1, owner->ref);
        sceVu0DivVector(owner->ref_spd, ref_delta, node->frame);
        owner->ref_spd[3] = 1.0f;
        owner->ease_frame = (int) (node->frame * node->ease_rate);
        sceVu0CopyVector(owner->pos_ease_acc, owner->pos_spd);
        sceVu0CopyVector(owner->ref_ease_acc, owner->ref_spd);
        sceVu0DivVector(owner->pos_ease_acc, owner->pos_ease_acc, owner->ease_frame);
        sceVu0DivVector(owner->ref_ease_acc, owner->ref_ease_acc, owner->ease_frame);

        if (node->mode != SCENE_SEQ_EASE_OUT) {
            sceVu0CopyVector(owner->pos_ease_spd, owner->pos_ease_acc);
            sceVu0CopyVector(owner->ref_ease_spd, owner->ref_ease_acc);
        } else {
            sceVu0CopyVector(owner->pos_ease_spd, owner->pos_spd);
            sceVu0CopyVector(owner->ref_ease_spd, owner->ref_spd);
        }
    } else {
        moved = 0;

        if (owner->pr_cnt < owner->ease_frame &&
            (node->mode == SCENE_SEQ_EASE_IN_OUT || node->mode == SCENE_SEQ_EASE_IN)) {
            sceVu0AddVector(owner->pos_ease_spd, owner->pos_ease_spd, owner->pos_ease_acc);
            sceVu0AddVector(owner->ref_ease_spd, owner->ref_ease_spd, owner->ref_ease_acc);
            sceVu0AddVector(owner->pos, owner->pos, owner->pos_ease_spd);
            owner->pos[3] = 1.0f;
            sceVu0AddVector(owner->ref, owner->ref, owner->ref_ease_spd);
            moved = 1;
            owner->ref[3] = 1.0f;
        }

        if ((node->mode == SCENE_SEQ_EASE_OUT && owner->pr_cnt >= node->frame - owner->ease_frame / 2) ||
            (node->mode == SCENE_SEQ_EASE_IN_OUT && owner->pr_cnt >= node->frame)) {
            sceVu0SubVector(owner->pos_ease_spd, owner->pos_ease_spd, owner->pos_ease_acc);
            sceVu0SubVector(owner->ref_ease_spd, owner->ref_ease_spd, owner->ref_ease_acc);
            sceVu0AddVector(owner->pos, owner->pos, owner->pos_ease_spd);
            owner->pos[3] = 1.0f;
            sceVu0AddVector(owner->ref, owner->ref, owner->ref_ease_spd);
            moved = 1;
            owner->ref[3] = 1.0f;
        }

        if (moved == 0) {
            sceVu0AddVector(owner->pos, owner->pos, owner->pos_spd);
            owner->pos[3] = 1.0f;
            sceVu0AddVector(owner->ref, owner->ref, owner->ref_spd);
            owner->ref[3] = 1.0f;
        }
    }

    owner->pr_cnt++;
    return 1;
}

/**
 *
 * Moves the camera focus toward the command position.
 *
 */
static int scsMoveRef(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
    float delta[4];

    if (owner->pr_cnt >= node->frame) {
        sceVu0CopyVector(owner->ref, node->vec1);
        owner->pr_cnt = 0;
        return 0;
    }

    if (owner->pr_cnt <= 0) {
        sceVu0SubVector(delta, node->vec1, owner->ref);
        sceVu0DivVector(owner->ref_spd, delta, node->frame);
        owner->ref_spd[3] = 1.0f;
    } else {
        sceVu0AddVector(owner->ref, owner->ref, owner->ref_spd);
        owner->ref[3] = 1.0f;
    }

    owner->pr_cnt++;
    return 1;
}

/**
 *
 * Moves the camera eye toward the command position.
 *
 */
static int scsMovePos(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
    float delta[4];

    if (owner->pr_cnt >= node->frame) {
        sceVu0CopyVector(owner->pos, node->vec0);
        owner->pr_cnt = 0;
        return 0;
    }

    if (owner->pr_cnt <= 0) {
        sceVu0SubVector(delta, node->vec0, owner->pos);
        sceVu0DivVector(owner->pos_spd, delta, node->frame);
        owner->pos_spd[3] = 1.0f;
    } else {
        sceVu0AddVector(owner->pos, owner->pos, owner->pos_spd);
        owner->pos[3] = 1.0f;
    }

    owner->pr_cnt++;
    return 1;
}

/**
 *
 * Changes camera orbit angle, height, and distance over the command duration.
 *
 */
static int scsMoveAHD(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
    float angle_delta;

    if (owner->ahd_cnt >= node->frame) {
        if (owner->sync != 0) {
            owner->sync_angle = node->vec0[0];
            owner->sync_height = node->vec0[1];
            owner->sync_dist = node->vec0[2];
        } else {
            owner->angle = node->vec0[0];
            owner->height = node->vec0[1];
            owner->dist = node->vec0[2];
            owner->pos[0] = owner->ref[0] + owner->dist * sinf(owner->angle);
            owner->pos[1] = owner->height + owner->ref[1];
            owner->pos[2] = owner->ref[2] + owner->dist * cosf(owner->angle);
        }

        owner->ahd_cnt = 0;
        return 0;
    }

    if (owner->ahd_cnt <= 0) {
        if (owner->sync != 0) {
            angle_delta = node->vec0[0] - owner->sync_angle;
        } else {
            angle_delta = node->vec0[0] - owner->angle;
        }

        if (angle_delta > 3.1415927f) {
            angle_delta -= 6.2831855f;
        } else if (angle_delta <= -3.1415927f) {
            angle_delta += 6.2831855f;
        }

        owner->angle_spd = angle_delta / (float) node->frame;
        owner->height_spd = (node->vec0[1] - owner->height) / (float) node->frame;
        owner->dist_spd = (node->vec0[2] - owner->dist) / (float) node->frame;
        owner->ahd_vel[0] = owner->angle_spd;
        owner->ahd_vel[1] = owner->height_spd;
        owner->ahd_vel[2] = owner->dist_spd;
    } else if (owner->sync != 0) {
        owner->sync_angle += owner->angle_spd;

        if (owner->sync_angle > 3.1415927f) {
            owner->sync_angle -= 6.2831855f;
        } else if (owner->sync_angle <= -3.1415927f) {
            owner->sync_angle += 6.2831855f;
        }

        owner->sync_height += owner->height_spd;
        owner->sync_dist += owner->dist_spd;
    } else {
        owner->angle += owner->angle_spd;

        if (owner->angle > 3.1415927f) {
            owner->angle -= 6.2831855f;
        } else if (owner->angle <= -3.1415927f) {
            owner->angle += 6.2831855f;
        }

        owner->height += owner->height_spd;
        owner->dist += owner->dist_spd;
        owner->pos[0] = owner->ref[0] + owner->dist * sinf(owner->angle);
        owner->pos[1] = owner->height + owner->ref[1];
        owner->pos[2] = owner->ref[2] + owner->dist * cosf(owner->angle);
    }

    owner->ahd_cnt++;
    return 1;
}

static int scsMoveAHD2(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
    float angle_delta;
    int   ended;

    if (node->mode == SCENE_SEQ_EASE_IN_OUT) {
        ended = owner->ease_frame;
    } else {
        ended = owner->ease_frame / 2;
    }

    if (owner->ahd_cnt >= node->frame + ended) {
        owner->ahd_cnt = 0;
        return 0;
    }

    if (owner->ahd_cnt <= 0) {
        if (owner->sync != 0) {
            angle_delta = node->vec0[0] - owner->sync_angle;
        } else {
            angle_delta = node->vec0[0] - owner->angle;
        }

        if (angle_delta > 3.1415927f) {
            angle_delta -= 6.2831855f;
        } else if (angle_delta <= -3.1415927f) {
            angle_delta += 6.2831855f;
        }

        owner->angle_spd = angle_delta / (float) node->frame;
        owner->height_spd = (node->vec0[1] - owner->height) / (float) node->frame;
        owner->dist_spd = (node->vec0[2] - owner->dist) / (float) node->frame;
        owner->ease_frame = (int) (node->frame * node->ease_rate);
        owner->pos_ease_acc[0] = owner->angle_spd;
        owner->pos_ease_acc[1] = owner->height_spd;
        owner->pos_ease_acc[2] = owner->dist_spd;
        owner->pos_ease_acc[3] = 1.0f;
        sceVu0DivVector(owner->pos_ease_acc, owner->pos_ease_acc, owner->ease_frame);

        if (node->mode != SCENE_SEQ_EASE_OUT) {
            sceVu0CopyVector(owner->pos_ease_spd, owner->pos_ease_acc);
        } else {
            owner->pos_ease_spd[0] = owner->angle_spd;
            owner->pos_ease_spd[1] = owner->height_spd;
            owner->pos_ease_spd[2] = owner->dist_spd;
            owner->pos_ease_spd[3] = 1.0f;
        }
    } else if (owner->sync != 0) {
        int moved = 0;

        if (owner->ahd_cnt < owner->ease_frame &&
            (node->mode == SCENE_SEQ_EASE_IN_OUT || node->mode == SCENE_SEQ_EASE_IN)) {
            sceVu0AddVector(owner->pos_ease_spd, owner->pos_ease_spd, owner->pos_ease_acc);
            owner->sync_angle += owner->pos_ease_spd[0];

            if (owner->sync_angle > 3.1415927f) {
                owner->sync_angle -= 6.2831855f;
            } else if (owner->sync_angle <= -3.1415927f) {
                owner->sync_angle += 6.2831855f;
            }

            moved = 1;
            owner->sync_height += owner->pos_ease_spd[1];
            owner->sync_dist += owner->pos_ease_spd[2];
        }

        if ((node->mode == SCENE_SEQ_EASE_OUT && owner->ahd_cnt >= node->frame - owner->ease_frame / 2) ||
            (node->mode == SCENE_SEQ_EASE_IN_OUT && owner->ahd_cnt >= node->frame)) {
            sceVu0SubVector(owner->pos_ease_spd, owner->pos_ease_spd, owner->pos_ease_acc);
            owner->sync_angle += owner->pos_ease_spd[0];

            if (owner->sync_angle > 3.1415927f) {
                owner->sync_angle -= 6.2831855f;
            } else if (owner->sync_angle <= -3.1415927f) {
                owner->sync_angle += 6.2831855f;
            }

            moved = 1;
            owner->sync_height += owner->pos_ease_spd[1];
            owner->sync_dist += owner->pos_ease_spd[2];
            owner->pos[3] = 1.0f;
        }

        if (moved == 0) {
            owner->sync_angle += owner->angle_spd;

            if (owner->sync_angle > 3.1415927f) {
                owner->sync_angle -= 6.2831855f;
            } else if (owner->sync_angle <= -3.1415927f) {
                owner->sync_angle += 6.2831855f;
            }

            owner->sync_height += owner->height_spd;
            owner->sync_dist += owner->dist_spd;
        }
    } else {
        int moved = 0;

        if (owner->ahd_cnt < owner->ease_frame &&
            (node->mode == SCENE_SEQ_EASE_IN_OUT || node->mode == SCENE_SEQ_EASE_IN)) {
            sceVu0AddVector(owner->pos_ease_spd, owner->pos_ease_spd, owner->pos_ease_acc);
            owner->angle += owner->pos_ease_spd[0];

            if (owner->angle > 3.1415927f) {
                owner->angle -= 6.2831855f;
            } else if (owner->angle <= -3.1415927f) {
                owner->angle += 6.2831855f;
            }

            moved = 1;
            owner->height += owner->pos_ease_spd[1];
            owner->dist += owner->pos_ease_spd[2];
        }

        if ((node->mode == SCENE_SEQ_EASE_OUT && owner->ahd_cnt >= node->frame - owner->ease_frame / 2) ||
            (node->mode == SCENE_SEQ_EASE_IN_OUT && owner->ahd_cnt >= node->frame)) {
            sceVu0SubVector(owner->pos_ease_spd, owner->pos_ease_spd, owner->pos_ease_acc);
            owner->angle += owner->pos_ease_spd[0];

            if (owner->angle > 3.1415927f) {
                owner->angle -= 6.2831855f;
            } else if (owner->angle <= -3.1415927f) {
                owner->angle += 6.2831855f;
            }

            moved = 1;
            owner->height += owner->pos_ease_spd[1];
            owner->dist += owner->pos_ease_spd[2];
            owner->pos[3] = 1.0f;
        }

        if (moved == 0) {
            owner->angle += owner->angle_spd;

            if (owner->angle > 3.1415927f) {
                owner->angle -= 6.2831855f;
            } else if (owner->angle <= -3.1415927f) {
                owner->angle += 6.2831855f;
            }

            owner->height += owner->height_spd;
            owner->dist += owner->dist_spd;
        }

        owner->pos[0] = owner->ref[0] + owner->dist * sinf(owner->angle);
        owner->pos[1] = owner->height + owner->ref[1];
        owner->pos[2] = owner->ref[2] + owner->dist * cosf(owner->angle);
    }

    owner->ahd_cnt++;
    return 1;
}

/**
 *
 * Attaches the camera orbit to a frame of a synchronized object.
 *
 */
static int scsSetSyncObj(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
    owner->sync_obj = seq->frame;
    owner->sync_mode = seq->mode;
    sceVu0CopyVector(owner->sync_ofs, seq->vec1);
    owner->sync_angle = seq->vec0[0];
    owner->sync_height = seq->vec0[1];
    owner->sync_dist = seq->vec0[2];
    strcpy(owner->sync_frame, seq->name);
    owner->pos[0] = owner->ref[0] + owner->sync_dist * sinf(owner->sync_angle);
    owner->pos[1] = owner->sync_height + owner->ref[1];
    owner->pos[2] = owner->ref[2] + owner->sync_dist * cosf(owner->sync_angle);
    owner->angle = owner->sync_angle;
    owner->height = owner->sync_height;
    owner->dist = owner->sync_dist;
    owner->sync = 1;
    return 0;
}

/**
 *
 * Clears the camera orbit synchronization target and offsets.
 *
 */
static int scsReleaseSyncObj(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
    owner->sync = 0;
    owner->sync_obj = 0;
    owner->sync_mode = 0;
    mgZeroVector(owner->sync_ofs);
    owner->sync_angle = 0;
    owner->sync_height = 0;
    owner->sync_dist = 0;
    strcpy(owner->sync_frame, "");
    return 0;
}

/**
 *
 * Damps the camera orbit velocity until the slowdown period ends.
 *
 */
static int scsAHDSlowing(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
    if (owner->ahd_cnt <= 0) {
        owner->ahd_cnt++;
        return 1;
    }

    if (!(owner->ahd_cnt < seq->mode)) {
        owner->ahd_cnt = 0;
        mgZeroVector(owner->ahd_vel);
        return 0;
    }

    sceVu0ScaleVector(owner->ahd_vel, owner->ahd_vel, seq->value);

    if (owner->sync != 0) {
        owner->sync_angle += owner->ahd_vel[0];

        if (owner->sync_angle > 3.1415927f) {
            owner->sync_angle -= 6.2831855f;
        } else if (owner->sync_angle <= -3.1415927f) {
            owner->sync_angle += 6.2831855f;
        }

        owner->sync_height += owner->ahd_vel[1];
        owner->sync_dist += owner->ahd_vel[2];
    } else {
        owner->angle += owner->ahd_vel[0];

        if (owner->angle > 3.1415927f) {
            owner->angle -= 6.2831855f;
        } else if (owner->angle <= -3.1415927f) {
            owner->angle += 6.2831855f;
        }

        owner->height += owner->ahd_vel[1];
        owner->dist += owner->ahd_vel[2];
        owner->pos[0] = owner->ref[0] + owner->dist * sinf(owner->angle);
        owner->pos[1] = owner->height + owner->ref[1];
        owner->pos[2] = owner->ref[2] + owner->dist * cosf(owner->angle);
    }

    owner->ahd_cnt++;
    return 1;
}

/**
 *
 * Keeps the current camera orbit command for sequence playback.
 *
 */
static int scsAHDKeep(_SEN_CMR_SEQ *sequence, CSceneCmrSeq *owner) {
    owner->ahd_keep = sequence;
    return SCENE_SEQ_NEXT;
}

/**
 *
 * Signals the camera orbit command sequence to return.
 *
 */
static int scsAHDReturn(_SEN_CMR_SEQ *sequence, CSceneCmrSeq *owner) {
    return SCENE_SEQ_RETURN;
}

/**
 *
 * Clears the camera path before new path points are added.
 *
 */
static int scsInitPas(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
    owner->pas.Initialize();
    return 0;
}

/**
 *
 * Sets the duration of the camera path.
 *
 */
static int scsSetPasFrm(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
    owner->pas.SetFrame(seq->frame);
    return 0;
}

/**
 *
 * Adds an eye and focus pair to the camera path.
 *
 */
static int scsAddPas(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
    owner->pas.AddCameraPas(seq->vec0, seq->vec1);
    return 0;
}

/**
 *
 * Steps the camera eye and focus along their configured paths.
 *
 */
static int scsStartPas(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
    float eye_point[4];
    float look_point[4];

    if (owner->pr_cnt <= 0) {
        owner->pas.Setup();
        owner->pas.Run();
        owner->pr_cnt = 1;
    }

    owner->pas.Step(eye_point, look_point);
    sceVu0SubVector(owner->pos_vel, eye_point, owner->pos);
    sceVu0SubVector(owner->ref_vel, look_point, owner->ref);
    sceVu0CopyVector(owner->pos, eye_point);
    sceVu0CopyVector(owner->ref, look_point);

    if (owner->pas.CheckEnd() != 0) {
        owner->pr_cnt = 0;
        return 0;
    }

    return 1;
}

/**
 *
 * Damps camera eye and focus velocity until the slowdown period ends.
 *
 */
static int scsPRSlowing(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
    if (owner->pr_cnt <= 0) {
        owner->pr_cnt++;
        return 1;
    }

    if (!(owner->pr_cnt < seq->mode)) {
        owner->pr_cnt = 0;
        mgZeroVector(owner->pos_vel);
        mgZeroVector(owner->ref_vel);
        return 0;
    }

    sceVu0ScaleVector(owner->pos_vel, owner->pos_vel, seq->value);
    sceVu0ScaleVector(owner->ref_vel, owner->ref_vel, seq->value);
    sceVu0AddVector(owner->pos, owner->pos, owner->pos_vel);
    sceVu0AddVector(owner->ref, owner->ref, owner->ref_vel);
    owner->pr_cnt++;
    return 1;
}

/**
 *
 * Keeps the current eye and focus command for sequence playback.
 *
 */
static int scsPRKeep(_SEN_CMR_SEQ *sequence, CSceneCmrSeq *owner) {
    owner->pr_keep = sequence;
    return SCENE_SEQ_NEXT;
}

/**
 *
 * Signals the eye and focus command sequence to return.
 *
 */
static int scsPRReturn(_SEN_CMR_SEQ *sequence, CSceneCmrSeq *owner) {
    return SCENE_SEQ_RETURN;
}

/**
 *
 * Waits the requested number of frames before a camera fade command.
 *
 */
static int scsFadeDelay(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
    int elapsed;

    elapsed = owner->fade_cnt;

    if (elapsed >= seq->frame) {
        owner->fade_cnt = 0;
        return 0;
    }

    owner->fade_cnt = elapsed + 1;
    return 1;
}

/**
 *
 * Advances past the camera fade initialization command.
 *
 */
static int scsFadeInit(_SEN_CMR_SEQ *sequence, CSceneCmrSeq *owner) {
    return SCENE_SEQ_NEXT;
}

/**
 *
 * Runs and draws the scene fade-in until it finishes.
 *
 */
static int scsFadeIn(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
    if (owner->fade_cnt <= 0) {
        EventScene->fade.FadeIn(seq->frame, seq->vec0[0], seq->vec0[1], seq->vec0[2]);
        owner->fade_cnt = 1;
    }

    EventScene->fade.FadeStep();
    EventScene->fade.Draw();

    if (EventScene->fade.FadeCheck() != 0) {
        owner->fade_cnt = 0;
        return 0;
    }

    return 1;
}

/**
 *
 * Runs and draws the scene fade-out until it finishes.
 *
 */
static int scsFadeOut(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
    if (owner->fade_cnt <= 0) {
        EventScene->fade.FadeOut(seq->frame, seq->vec0[0], seq->vec0[1], seq->vec0[2]);
        owner->fade_cnt = 1;
    }

    EventScene->fade.FadeStep();
    EventScene->fade.Draw();

    if (EventScene->fade.FadeCheck() != 0) {
        owner->fade_cnt = 0;
        return 0;
    }

    return 1;
}

/**
 *
 * Waits the requested number of frames before a camera quake command.
 *
 */
static int scsQuakeDelay(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
    int elapsed;

    elapsed = owner->quake_cnt;

    if (elapsed >= seq->frame) {
        owner->quake_cnt = 0;
        return 0;
    }

    owner->quake_cnt = elapsed + 1;
    return 1;
}

/**
 *
 * Shakes the camera eye and focus, optionally reducing its amplitude over time.
 *
 */
static int scsQuake(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
    float amplitude[4];

    if (seq->frame <= -1) {
        owner->quake = 1;
        sceVu0CopyVector(owner->quake_pos, owner->pos);
        sceVu0CopyVector(owner->quake_ref, owner->ref);

        if (owner->quake_cnt % 4 == 0) {
            sceVu0AddVector(owner->pos, owner->pos, seq->vec0);
            sceVu0AddVector(owner->ref, owner->ref, seq->vec0);
        } else if (owner->quake_cnt % 4 == 2) {
            sceVu0SubVector(owner->pos, owner->pos, seq->vec0);
            sceVu0SubVector(owner->ref, owner->ref, seq->vec0);
        }

        owner->quake_cnt++;
    } else {
        if (!(owner->quake_cnt < seq->frame)) {
            owner->quake_cnt = 0;
            owner->quake = 0;
            return 0;
        }

        if (owner->quake_cnt <= 0) {
            owner->quake = 1;
            sceVu0CopyVector(owner->quake_amp, seq->vec0);
        }

        sceVu0CopyVector(owner->quake_pos, owner->pos);
        sceVu0CopyVector(owner->quake_ref, owner->ref);

        if (owner->quake_cnt % 4 == 0) {
            sceVu0AddVector(owner->pos, owner->pos, owner->quake_amp);
            sceVu0AddVector(owner->ref, owner->ref, owner->quake_amp);
        } else if (owner->quake_cnt % 4 == 2) {
            sceVu0SubVector(owner->pos, owner->pos, owner->quake_amp);
            sceVu0SubVector(owner->ref, owner->ref, owner->quake_amp);
            sceVu0DivVector(amplitude, seq->vec0, seq->frame);
            sceVu0ScaleVector(amplitude, amplitude, owner->quake_cnt);
            sceVu0SubVector(owner->quake_amp, seq->vec0, amplitude);
        }

        owner->quake_cnt++;
    }

    return 1;
}

/**
 *
 * Shakes the camera focus, optionally reducing its amplitude over time.
 *
 */
static int scsQuake2(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
    if (node->frame <= -1) {
        owner->quake = 1;
        sceVu0CopyVector(owner->quake_amp, node->vec0);
        sceVu0CopyVector(owner->quake_pos, owner->pos);
        sceVu0CopyVector(owner->quake_ref, owner->ref);

        if (owner->quake_cnt % 2 == 0) {
            sceVu0AddVector(owner->ref, owner->quake_ref, owner->quake_amp);
        } else {
            sceVu0SubVector(owner->ref, owner->quake_ref, owner->quake_amp);
        }

        owner->quake_cnt++;

        if (owner->quake_cnt > 100) {
            owner->quake_cnt = 0;
        }
    } else {
        if (owner->quake_cnt <= 0) {
            owner->quake = 1;
            sceVu0CopyVector(owner->quake_amp, node->vec0);
            sceVu0DivVector(node->vec0, node->vec0, node->frame);
        }

        sceVu0CopyVector(owner->quake_pos, owner->pos);
        sceVu0CopyVector(owner->quake_ref, owner->ref);

        if (owner->quake_cnt % 2 == 0) {
            sceVu0AddVector(owner->ref, owner->quake_ref, owner->quake_amp);
        } else if (owner->quake_cnt % 2 == 1) {
            sceVu0SubVector(owner->ref, owner->quake_ref, owner->quake_amp);
        }

        sceVu0SubVector(owner->quake_amp, owner->quake_amp, node->vec0);

        if (owner->quake_cnt >= node->frame) {
            owner->quake_cnt = 0;
            owner->quake = 0;
            return 0;
        }

        owner->quake_cnt++;
    }

    return 1;
}

/**
 *
 * Waits the requested number of frames before a character attachment command.
 *
 */
static int scsCharaDelay(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
    int elapsed;

    elapsed = owner->chara_cnt;

    if (elapsed >= seq->frame) {
        owner->chara_cnt = 0;
        return 0;
    }

    owner->chara_cnt = elapsed + 1;
    return 1;
}

/**
 *
 * Positions a character at a fixed distance along the camera view direction.
 *
 */
static int scsCharaAttach(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
    CCharacter2 *chara;
    float        direction[4];
    float        target[4];

    if (seq->attach_frame >= 0 && !(owner->chara_cnt < seq->attach_frame)) {
        owner->chara_cnt = 0;
        return 0;
    }

    chara = GetCharacter(seq->frame);

    if (chara == NULL) {
        return 0;
    }

    sceVu0SubVector(direction, owner->ref, owner->pos);
    sceVu0Normalize(direction, direction);
    sceVu0ScaleVector(direction, direction, seq->dist);
    sceVu0AddVector(target, owner->pos, direction);
    chara->SetPosition(target);
    owner->chara_cnt++;
    return 1;
}

/**
 *
 * Keeps the camera sequence waiting without changing its state.
 *
 */
static int scsDummy(_SEN_CMR_SEQ *sequence, CSceneCmrSeq *owner) {
    return SCENE_SEQ_WAIT;
}

/**
 *
 * Clears a camera sequence command and its links.
 *
 */
void InitSceneCmrSeq(_SEN_CMR_SEQ *seq) {
    seq->cmd = 0;
    mgZeroVector(seq->vec0);
    mgZeroVector(seq->vec1);
    seq->frame = 0;
    seq->mode = 0;
    seq->ease_rate = 0;
    strcpy(seq->name, "");
    seq->next = NULL;
}

CSceneCmrSeq::CSceneCmrSeq() {
    ZeroInitialize();
}

void CSceneCmrSeq::ZeroInitialize() {
    seq_tbl = NULL;
    seq_num = 0;
    mgZeroVector(pos);
    mgZeroVector(ref);
    Clear();
}

void CSceneCmrSeq::Initialize(_SEN_CMR_SEQ *nodes, int count) {
    ZeroInitialize();
    seq_tbl = nodes;
    seq_num = count;
    Clear();
}

void CSceneCmrSeq::Clear() {
    int i;

    pr_keep = NULL;
    ahd_keep = NULL;
    pr_cnt = 0;
    ahd_cnt = 0;
    fade_cnt = 0;
    quake_cnt = 0;
    chara_cnt = 0;
    mgZeroVector(pos);
    mgZeroVector(ref);
    dist = 0;
    height = 0;
    angle = 0;
    sync = 0;
    sync_obj = -1;
    sync_mode = 0;
    mgZeroVector(sync_ofs);
    strcpy(sync_frame, "");
    sync_dist = 0;
    sync_height = 0;
    sync_angle = 0;
    mgZeroVector(pos_spd);
    mgZeroVector(ref_spd);
    dist_spd = 0;
    height_spd = 0;
    angle_spd = 0;
    mgZeroVector(pos_ease_spd);
    mgZeroVector(ref_ease_spd);
    mgZeroVector(pos_ease_acc);
    mgZeroVector(ref_ease_acc);
    ease_frame = 0;
    mgZeroVector(pos_vel);
    mgZeroVector(ref_vel);
    mgZeroVector(ahd_vel);
    quake = 0;
    pas.Initialize();
    mgZeroVector(quake_amp);
    mgZeroVector(quake_pos);
    mgZeroVector(quake_ref);
    pr_seq = NULL;
    pr_last = NULL;
    ahd_seq = NULL;
    ahd_last = NULL;
    fade_seq = NULL;
    fade_last = NULL;
    quake_seq = NULL;
    quake_last = NULL;
    chara_seq = NULL;
    chara_last = NULL;

    if (seq_tbl != NULL && seq_num > 0) {
        for (i = 0; i < seq_num; i++) {
            InitSceneCmrSeq(seq_tbl + i);
        }
    }
}

int CSceneCmrSeq::CheckEnd() {
    if (pr_seq == 0) {
        if (ahd_seq == 0 && fade_seq == 0 && quake_seq == 0) {
            return 1;
        }
    }

    return 0;
}

/**
 *
 * Dispatches camera sequence commands in command-code order.
 *
 */
static int (*ScsCmrSeqCallTbl[SCENE_CMR_CMD_NUM + 1])(_SEN_CMR_SEQ *, CSceneCmrSeq *) = {
    scsDummy,
    scsPRDelay,
    scsSetPos,
    scsSetRef,
    scsMove,
    scsMove2,
    scsMoveRef,
    scsMovePos,
    scsInitPas,
    scsSetPasFrm,
    scsAddPas,
    scsStartPas,
    scsPRSlowing,
    scsPRKeep,
    scsPRReturn,
    scsAHDDelay,
    scsSetAngle,
    scsSetHeight,
    scsSetDist,
    scsSetAHD,
    scsMoveAHD,
    scsMoveAHD2,
    scsSetSyncObj,
    scsReleaseSyncObj,
    scsAHDSlowing,
    scsAHDKeep,
    scsAHDReturn,
    scsFadeDelay,
    scsFadeInit,
    scsFadeIn,
    scsFadeOut,
    scsQuakeDelay,
    scsQuake,
    scsQuake2,
    scsCharaDelay,
    scsCharaAttach,
    scsDummy,
};

void CSceneCmrSeq::Play() {
    float          delta[4];
    float          direction[4];
    float          eye_flat[4];
    float          ref_flat[4];
    float          object_rot[4];
    float          frame_rot[4];
    sceVu0FMATRIX  frame_matrix;
    float          frame_pos[4];
    _SEN_CMR_SEQ  *node;
    mgCCamera     *camera;
    int            track;
    _SEN_CMR_SEQ **head;
    _SEN_CMR_SEQ **tail;
    mgCFrame      *frame;
    float          yaw;

    camera = GetActiveCamera();

    if (camera == NULL) {
        Clear();
        return;
    }

    camera->GetPos(pos);
    camera->GetRef(ref);

    if (quake != 0) {
        sceVu0CopyVector(pos, quake_pos);
        sceVu0CopyVector(ref, quake_ref);
    }

    sceVu0SubVector(delta, ref, pos);
    direction[0] = delta[0];
    direction[1] = 0.0f;
    direction[2] = delta[2];
    direction[3] = 0.0f;
    sceVu0Normalize(direction, direction);
    angle = atan2f(-direction[0], -direction[2]);
    height = pos[1] - ref[1];
    sceVu0CopyVector(eye_flat, pos);
    eye_flat[1] = 0.0f;
    sceVu0CopyVector(ref_flat, ref);
    ref_flat[1] = 0.0f;
    dist = mgDistVector(eye_flat, ref_flat);

    for (track = 0; track < SCENE_CMR_TRACK_NUM; track++) {
        switch (track) {
            case SCENE_CMR_TRACK_PR:
                head = &pr_seq;
                tail = &pr_last;
                break;
            case SCENE_CMR_TRACK_AHD:
                head = &ahd_seq;
                tail = &ahd_last;
                break;
            case SCENE_CMR_TRACK_FADE:
                head = &fade_seq;
                tail = &fade_last;
                break;
            case SCENE_CMR_TRACK_QUAKE:
                head = &quake_seq;
                tail = &quake_last;
                break;
            case SCENE_CMR_TRACK_CHARA:
                head = &chara_seq;
                tail = &chara_last;
                break;
        }

        node = *head;

        if (node != NULL) {
            do {
                if (node->cmd > 0 && node->cmd < SCENE_CMR_CMD_NUM) {
                    int result = ScsCmrSeqCallTbl[node->cmd](node, this);

                    if (result != SCENE_SEQ_NEXT) {
                        if (result == SCENE_SEQ_WAIT) {
                            break;
                        }

                        if (result == SCENE_SEQ_RETURN) {
                            switch (track) {
                                case SCENE_CMR_TRACK_PR:
                                    node = pr_keep;
                                    break;
                                case SCENE_CMR_TRACK_AHD:
                                    node = ahd_keep;
                                    break;
                                case SCENE_CMR_TRACK_FADE:
                                    break;
                            }
                        }
                    }
                } else {
                    node = NULL;
                    break;
                }

                node = GetNextSeq(node, track);
            } while (node != NULL);
        }

        *head = node;

        if (node == NULL) {
            *tail = NULL;
        }
    }

    if (sync != 0) {
        if (strcmp(sync_frame, "") != 0) {
            frame = EventObjHandleMother.SearchFrame(sync_obj, sync_frame);

            if (frame != NULL) {
                frame->GetWorldPosition0(ref);
            } else {
                EventObjHandleMother.GetPos(sync_obj, ref);
                sync_mode = SCENE_CMR_SYNC_YAW;
            }
        } else {
            EventObjHandleMother.GetPos(sync_obj, ref);
        }

        sceVu0AddVector(ref, ref, sync_ofs);
        yaw = sync_angle;

        if (sync_mode != SCENE_CMR_SYNC_FRAME) {
            switch (sync_mode) {
                case SCENE_CMR_SYNC_YAW:
                    EventObjHandleMother.GetRot(sync_obj, object_rot);
                    yaw += object_rot[1];

                    if (yaw > 3.1415927f) {
                        yaw -= 6.2831855f;
                    } else if (yaw <= -3.1415927f) {
                        yaw += 6.2831855f;
                    }

                    break;
                case SCENE_CMR_SYNC_FIXED:
                    break;
            }

            pos[0] = ref[0] + sync_dist * sinf(yaw);
            pos[1] = sync_height + ref[1];
            pos[2] = ref[2] + sync_dist * cosf(yaw);
        } else {
            EventObjHandleMother.GetRot(sync_obj, frame_rot);
            yaw += frame_rot[1];

            if (yaw > 3.1415927f) {
                yaw -= 6.2831855f;
            } else if (yaw <= -3.1415927f) {
                yaw += 6.2831855f;
            }

            pos[0] = ref[0] + sync_dist * sinf(yaw);
            pos[1] = sync_height + ref[1];
            pos[2] = ref[2] + sync_dist * cosf(yaw);
            sceVu0SubVector(pos, pos, ref);
            mgZeroVector(frame_rot);
            frame = EventObjHandleMother.SearchFrame(sync_obj, sync_frame);

            if (frame != NULL) {
                frame->GetLWMatrix(frame_matrix);
                frame_matrix[3][3] = 1.0f;
                frame_matrix[3][2] = 0.0f;
                frame_matrix[3][1] = 0.0f;
                frame_matrix[3][0] = 0.0f;
                frame->GetWorldPosition0(frame_pos);
            }

            sceVu0ApplyMatrix(ref, frame_matrix, sync_ofs);
            sceVu0AddVector(ref, ref, frame_pos);
            sceVu0ApplyMatrix(pos, frame_matrix, pos);
            sceVu0AddVector(pos, ref, pos);
        }
    }

    camera->SetPos(pos);
    camera->SetRef(ref);
}

_SEN_CMR_SEQ *CSceneCmrSeq::SearchSeq() {
    _SEN_CMR_SEQ *node = seq_tbl;
    int           i;

    for (i = 0; i < seq_num; i++, node++) {
        if (node->cmd == 0) {
            node->next = NULL;
            return node;
        }
    }

    return NULL;
}

_SEN_CMR_SEQ *CSceneCmrSeq::SearchNextPrSeq() {
    _SEN_CMR_SEQ *node = SearchSeq();

    if (node == NULL) {
        return NULL;
    }

    if (pr_last != NULL) {
        pr_last->next = node;
    }

    pr_last = node;
    node->next = NULL;

    if (pr_seq == NULL) {
        pr_seq = node;
    }

    return node;
}

_SEN_CMR_SEQ *CSceneCmrSeq::SearchNextAhdSeq() {
    _SEN_CMR_SEQ *node = SearchSeq();

    if (node == NULL) {
        return NULL;
    }

    if (ahd_last != NULL) {
        ahd_last->next = node;
    }

    ahd_last = node;
    node->next = NULL;

    if (ahd_seq == NULL) {
        ahd_seq = node;
    }

    return node;
}

_SEN_CMR_SEQ *CSceneCmrSeq::SearchNextFadeSeq() {
    _SEN_CMR_SEQ *node = SearchSeq();

    if (node == NULL) {
        return NULL;
    }

    if (fade_last != NULL) {
        fade_last->next = node;
    }

    fade_last = node;
    node->next = NULL;

    if (fade_seq == NULL) {
        fade_seq = node;
    }

    return node;
}

_SEN_CMR_SEQ *CSceneCmrSeq::SearchNextQuakeSeq() {
    _SEN_CMR_SEQ *node = SearchSeq();

    if (node == NULL) {
        return NULL;
    }

    if (quake_last != NULL) {
        quake_last->next = node;
    }

    quake_last = node;
    node->next = NULL;

    if (quake_seq == NULL) {
        quake_seq = node;
    }

    return node;
}

_SEN_CMR_SEQ *CSceneCmrSeq::SearchNextCharaSeq() {
    _SEN_CMR_SEQ *node = SearchSeq();

    if (node == NULL) {
        return NULL;
    }

    if (chara_last != NULL) {
        chara_last->next = node;
    }

    chara_last = node;
    node->next = NULL;

    if (chara_seq == NULL) {
        chara_seq = node;
    }

    return node;
}

_SEN_CMR_SEQ *CSceneCmrSeq::GetNextSeq(_SEN_CMR_SEQ *seq, int lane) {
    _SEN_CMR_SEQ *next;

    if (seq == NULL) {
        return 0;
    }

    next = seq->next;

    switch (lane) {
        case 0:
            if (pr_keep == 0) {
                InitSceneCmrSeq(seq);
            }

            break;
        case 1:
            if (ahd_keep == 0) {
                InitSceneCmrSeq(seq);
            }

            break;
        case 2:
            InitSceneCmrSeq(seq);
            break;
    }

    return next;
}

void CSceneCmrSeq::PRDelay(int frames) {
    _SEN_CMR_SEQ *command = SearchNextPrSeq();

    if (command != NULL) {
        if (frames > 0) {
            frames = (frames * 50) / 60;

            if (frames <= 0) {
                frames = 1;
            }
        }

        command->cmd = SCENE_CMR_CMD_PR_DELAY;
        command->frame = frames;
    }
}

void CSceneCmrSeq::SetPos(float *eye_pos) {
    _SEN_CMR_SEQ *node;

    node = SearchNextPrSeq();

    if (node != NULL) {
        node->cmd = SCENE_CMR_CMD_SET_POS;
        sceVu0CopyVector(node->vec0, eye_pos);
    }
}

void CSceneCmrSeq::SetRef(float *ref_pos) {
    _SEN_CMR_SEQ *node;

    node = SearchNextPrSeq();

    if (node != NULL) {
        node->cmd = SCENE_CMR_CMD_SET_REF;
        sceVu0CopyVector(node->vec1, ref_pos);
    }
}

void CSceneCmrSeq::Move(float *eye_pos, float *ref_pos, int frames) {
    _SEN_CMR_SEQ *node;

    node = SearchNextPrSeq();

    if (node != NULL) {
        CONVERT_TO_PAL_FRAMES(frames);
        node->cmd = SCENE_CMR_CMD_MOVE;
        sceVu0CopyVector(node->vec0, eye_pos);
        sceVu0CopyVector(node->vec1, ref_pos);
        node->frame = frames;
    }
}

void CSceneCmrSeq::Move2(float *eye_pos, float *ref_pos, int frames, int param34, float param38) {
    _SEN_CMR_SEQ *node;

    node = SearchNextPrSeq();

    if (node != NULL) {
        CONVERT_TO_PAL_FRAMES(frames);
        node->cmd = SCENE_CMR_CMD_MOVE2;
        sceVu0CopyVector(node->vec0, eye_pos);
        sceVu0CopyVector(node->vec1, ref_pos);
        node->frame = frames;
        node->mode = param34;
        node->ease_rate = param38;
    }
}

void CSceneCmrSeq::MoveRef(float *ref_pos, int frames) {
    _SEN_CMR_SEQ *node;

    node = SearchNextPrSeq();

    if (node != NULL) {
        CONVERT_TO_PAL_FRAMES(frames);
        node->cmd = SCENE_CMR_CMD_MOVE_REF;
        sceVu0CopyVector(node->vec1, ref_pos);
        node->frame = frames;
    }
}

void CSceneCmrSeq::MovePos(float *eye_pos, int frames) {
    _SEN_CMR_SEQ *node;

    node = SearchNextPrSeq();

    if (node != NULL) {
        CONVERT_TO_PAL_FRAMES(frames);
        node->cmd = SCENE_CMR_CMD_MOVE_POS;
        sceVu0CopyVector(node->vec0, eye_pos);
        node->frame = frames;
    }
}

void CSceneCmrSeq::InitPas() {
    _SEN_CMR_SEQ *command = SearchNextPrSeq();

    if (command != NULL) {
        command->cmd = SCENE_CMR_CMD_INIT_PAS;
    }
}

void CSceneCmrSeq::SetPasFrm(int frames) {
    _SEN_CMR_SEQ *command = SearchNextPrSeq();

    if (command != NULL) {
        if (frames > 0) {
            frames = (frames * 50) / 60;

            if (frames <= 0) {
                frames = 1;
            }
        }

        command->cmd = SCENE_CMR_CMD_SET_PAS_FRM;
        command->frame = frames;
    }
}

void CSceneCmrSeq::AddPas(float *eye_point, float *look_point) {
    _SEN_CMR_SEQ *node;

    node = SearchNextPrSeq();

    if (node != NULL) {
        node->cmd = SCENE_CMR_CMD_ADD_PAS;
        sceVu0CopyVector(node->vec0, eye_point);
        sceVu0CopyVector(node->vec1, look_point);
    }
}

void CSceneCmrSeq::StartPas() {
    _SEN_CMR_SEQ *command = SearchNextPrSeq();

    if (command != NULL) {
        command->cmd = SCENE_CMR_CMD_START_PAS;
    }
}

void CSceneCmrSeq::PRSlowing(float rate, int frames) {
    _SEN_CMR_SEQ *node;

    node = SearchNextPrSeq();

    if (node != NULL) {
        CONVERT_TO_PAL_FRAMES(frames);
        node->cmd = SCENE_CMR_CMD_PR_SLOWING;
        node->value = rate;
        node->mode = frames;
    }
}

void CSceneCmrSeq::PRKeep() {
    _SEN_CMR_SEQ *command = SearchNextPrSeq();

    if (command != NULL) {
        command->cmd = SCENE_CMR_CMD_PR_KEEP;
    }
}

void CSceneCmrSeq::PRReturn() {
    _SEN_CMR_SEQ *command = SearchNextPrSeq();

    if (command != NULL) {
        command->cmd = SCENE_CMR_CMD_PR_RETURN;
    }
}

void CSceneCmrSeq::AHDDelay(int frames) {
    _SEN_CMR_SEQ *command = SearchNextAhdSeq();

    if (command != NULL) {
        if (frames > 0) {
            frames = (frames * 50) / 60;

            if (frames <= 0) {
                frames = 1;
            }
        }

        command->cmd = SCENE_CMR_CMD_AHD_DELAY;
        command->frame = frames;
    }
}

void CSceneCmrSeq::SetAngle(float angle) {
    _SEN_CMR_SEQ *command = SearchNextAhdSeq();

    if (command != NULL) {
        command->cmd = SCENE_CMR_CMD_SET_ANGLE;
        command->value = angle;
    }
}

void CSceneCmrSeq::SetHeight(float new_height) {
    _SEN_CMR_SEQ *node;

    node = SearchNextAhdSeq();

    if (node != NULL) {
        node->cmd = SCENE_CMR_CMD_SET_HEIGHT;
        node->value = new_height;
    }
}

void CSceneCmrSeq::SetDist(float distance) {
    _SEN_CMR_SEQ *command = SearchNextAhdSeq();

    if (command != NULL) {
        command->cmd = SCENE_CMR_CMD_SET_DIST;
        command->value = distance;
    }
}

void CSceneCmrSeq::SetAHD(float new_angle, float new_height, float new_dist) {
    _SEN_CMR_SEQ *node;

    node = SearchNextAhdSeq();

    if (node != NULL) {
        node->cmd = SCENE_CMR_CMD_SET_AHD;
        node->vec0[0] = new_angle;
        node->vec0[1] = new_height;
        node->vec0[2] = new_dist;
    }
}

void CSceneCmrSeq::MoveAHD(float new_angle, float new_height, float new_dist, int frames) {
    _SEN_CMR_SEQ *node;

    node = SearchNextAhdSeq();

    if (node != NULL) {
        CONVERT_TO_PAL_FRAMES(frames);
        node->cmd = SCENE_CMR_CMD_MOVE_AHD;
        node->vec0[0] = new_angle;
        node->vec0[1] = new_height;
        node->vec0[2] = new_dist;
        node->frame = frames;
    }
}

void CSceneCmrSeq::MoveAHD2(float new_angle, float new_height, float new_dist, int frames, int param34,
                            float param38) {
    _SEN_CMR_SEQ *node;

    node = SearchNextAhdSeq();

    if (node != NULL) {
        CONVERT_TO_PAL_FRAMES(frames);
        node->cmd = SCENE_CMR_CMD_MOVE_AHD2;
        node->vec0[0] = new_angle;
        node->vec0[1] = new_height;
        node->vec0[2] = new_dist;
        node->frame = frames;
        node->mode = param34;
        node->ease_rate = param38;
    }
}

void CSceneCmrSeq::SetSyncObj(int kind, float *offset, float angle_offset, float height_offset,
                              float dist_offset, int option, char *name) {
    _SEN_CMR_SEQ *node;

    node = SearchNextAhdSeq();

    if (node != NULL) {
        node->cmd = SCENE_CMR_CMD_SET_SYNC_OBJ;
        sceVu0CopyVector(node->vec1, offset);
        node->vec0[0] = angle_offset;
        node->vec0[1] = height_offset;
        node->vec0[2] = dist_offset;
        node->frame = kind;
        node->mode = option;

        if (name != NULL) {
            strcpy(node->name, name);
        } else {
            strcpy(node->name, "");
        }
    }
}

void CSceneCmrSeq::ReleaseSyncObj() {
    _SEN_CMR_SEQ *command = SearchNextAhdSeq();

    if (command != NULL) {
        command->cmd = SCENE_CMR_CMD_RELEASE_SYNC_OBJ;
    }
}

void CSceneCmrSeq::AHDSlowing(float rate, int frames) {
    _SEN_CMR_SEQ *node;

    node = SearchNextAhdSeq();

    if (node != NULL) {
        CONVERT_TO_PAL_FRAMES(frames);
        node->cmd = SCENE_CMR_CMD_AHD_SLOWING;
        node->value = rate;
        node->mode = frames;
    }
}

void CSceneCmrSeq::AHDKeep() {
    _SEN_CMR_SEQ *command = SearchNextAhdSeq();

    if (command != NULL) {
        command->cmd = SCENE_CMR_CMD_AHD_KEEP;
    }
}

void CSceneCmrSeq::AHDReturn() {
    _SEN_CMR_SEQ *command = SearchNextAhdSeq();

    if (command != NULL) {
        command->cmd = SCENE_CMR_CMD_AHD_RETURN;
    }
}

void CSceneCmrSeq::FadeDelay(int frames) {
    _SEN_CMR_SEQ *command = SearchNextFadeSeq();

    if (command != NULL) {
        if (frames > 0) {
            frames = (frames * 50) / 60;

            if (frames <= 0) {
                frames = 1;
            }
        }

        command->cmd = SCENE_CMR_CMD_FADE_DELAY;
        command->frame = frames;
    }
}

void CSceneCmrSeq::FadeInit() {
    _SEN_CMR_SEQ *command = SearchNextFadeSeq();

    if (command != NULL) {
        command->cmd = SCENE_CMR_CMD_FADE_INIT;
    }
}

void CSceneCmrSeq::FadeIn(int frames, float r, float g, float b) {
    _SEN_CMR_SEQ *node;

    node = SearchNextFadeSeq();

    if (node != NULL) {
        CONVERT_TO_PAL_FRAMES(frames);
        node->cmd = SCENE_CMR_CMD_FADE_IN;
        node->frame = frames;
        node->vec0[0] = r;
        node->vec0[1] = g;
        node->vec0[2] = b;
    }
}

void CSceneCmrSeq::FadeOut(int frames, float r, float g, float b) {
    _SEN_CMR_SEQ *node;

    node = SearchNextFadeSeq();

    if (node != NULL) {
        CONVERT_TO_PAL_FRAMES(frames);
        node->cmd = SCENE_CMR_CMD_FADE_OUT;
        node->frame = frames;
        node->vec0[0] = r;
        node->vec0[1] = g;
        node->vec0[2] = b;
    }
}

void CSceneCmrSeq::QuakeDelay(int frames) {
    _SEN_CMR_SEQ *command = SearchNextQuakeSeq();

    if (command != NULL) {
        if (frames > 0) {
            frames = (frames * 50) / 60;

            if (frames <= 0) {
                frames = 1;
            }
        }

        command->cmd = SCENE_CMR_CMD_QUAKE_DELAY;
        command->frame = frames;
    }
}

void CSceneCmrSeq::Quake(float *amplitude, int frames) {
    _SEN_CMR_SEQ *node;

    node = SearchNextQuakeSeq();

    if (node != NULL) {
        CONVERT_TO_PAL_FRAMES(frames);
        node->cmd = SCENE_CMR_CMD_QUAKE;
        sceVu0CopyVector(node->vec0, amplitude);
        node->frame = frames;
    }
}

void CSceneCmrSeq::Quake2(float *amplitude, int frames) {
    _SEN_CMR_SEQ *node;

    node = SearchNextQuakeSeq();

    if (node != NULL) {
        CONVERT_TO_PAL_FRAMES(frames);
        node->cmd = SCENE_CMR_CMD_QUAKE2;
        sceVu0CopyVector(node->vec0, amplitude);
        node->frame = frames;

        if (frames <= -1) {
            sceVu0DivVector(node->vec0, node->vec0, node->frame);
        }

        node->vec0[0] = 0;
        node->vec0[2] = 0;
    }
}

void CSceneCmrSeq::CharaDelay(int frames) {
    _SEN_CMR_SEQ *command = SearchNextCharaSeq();

    if (command != NULL) {
        if (frames > 0) {
            frames = (frames * 50) / 60;

            if (frames <= 0) {
                frames = 1;
            }
        }

        command->cmd = SCENE_CMR_CMD_CHARA_DELAY;
        command->frame = frames;
    }
}

void CSceneCmrSeq::CharaAttach(int kind, float factor, int frames) {
    _SEN_CMR_SEQ *node;

    node = SearchNextCharaSeq();

    if (node != NULL) {
        CONVERT_TO_PAL_FRAMES(frames);
        node->cmd = SCENE_CMR_CMD_CHARA_ATTACH;
        node->frame = kind;
        node->dist = factor;
        node->attach_frame = frames;
    }
}

/**
 *
 * Waits the requested number of frames before an object position command.
 *
 */
static int scsPosDelay(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    int elapsed;

    elapsed = owner->pos_cnt;

    if (elapsed >= seq->frame) {
        owner->pos_cnt = 0;
        return 0;
    }

    owner->pos_cnt = elapsed + 1;
    return 1;
}

/**
 *
 * Sets the event object sequence position immediately.
 *
 */
static int scsSetPos(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    sceVu0CopyVector(owner->pos, seq->vec);
    return 0;
}

/**
 *
 * Moves the event object toward a position, with optional ground collision.
 *
 */
static int scsMove(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    if (!(owner->pos_cnt < seq->frame)) {
        if (seq->mode == 0) {
            sceVu0CopyVector(owner->pos, seq->vec);
            owner->pos_cnt = 0;
        } else {
            if (seq->mode == 1) {
                owner->pos[0] = seq->vec[0];
                owner->pos[2] = seq->vec[2];
                {
                    mgVu0FBOX box;
                    CCPoly    polys[128];
                    float     from[4];
                    float     to[4];
                    float     hit[4];
                    int       count;

                    box.max[0] = 10.0f + owner->pos[0];
                    box.min[0] = owner->pos[0] - 10.0f;
                    box.max[1] = 10.0f + owner->pos[1];
                    box.min[1] = owner->pos[1] - 10.0f;
                    box.max[2] = 10.0f + owner->pos[2];
                    box.min[2] = owner->pos[2] - 10.0f;
                    count = GetMainScene()->GetColPoly(polys, box, 128);
                    sceVu0CopyVector(from, owner->pos);
                    from[1] += 10.0f;
                    from[3] = 1.0f;
                    sceVu0CopyVector(to, owner->pos);
                    to[1] -= 10.0f;
                    to[3] = 1.0f;

                    if (CheckHit(polys, count, from, to, hit, 1, 0) >= 0) {
                        owner->pos[1] = hit[1];
                    }
                }
            }

            owner->pos_cnt = 0;
        }

        return 0;
    }

    if (owner->pos_cnt <= 0) {
        float delta[4];

        sceVu0SubVector(delta, seq->vec, owner->pos);
        sceVu0DivVector(owner->pos_spd, delta, seq->frame);
        owner->pos_spd[3] = 1.0f;
    } else {
        if (seq->mode == 0) {
            sceVu0AddVector(owner->pos, owner->pos, owner->pos_spd);
        } else if (seq->mode == 1) {
            sceVu0AddVector(owner->pos, owner->pos, owner->pos_spd);
            {
                mgVu0FBOX box;
                CCPoly    polys[128];
                float     from[4];
                float     to[4];
                float     hit[4];
                int       count;

                box.max[0] = 10.0f + owner->pos[0];
                box.min[0] = owner->pos[0] - 10.0f;
                box.max[1] = 10.0f + owner->pos[1];
                box.min[1] = owner->pos[1] - 10.0f;
                box.max[2] = 10.0f + owner->pos[2];
                box.min[2] = owner->pos[2] - 10.0f;
                count = GetMainScene()->GetColPoly(polys, box, 128);
                sceVu0CopyVector(from, owner->pos);
                from[1] += 10.0f;
                from[3] = 1.0f;
                sceVu0CopyVector(to, owner->pos);
                to[1] -= 10.0f;
                to[3] = 1.0f;

                if (CheckHit(polys, count, from, to, hit, 1, 0) >= 0) {
                    owner->pos[1] = hit[1];
                }
            }
        }

        owner->pos[3] = 1.0f;
    }

    owner->pos_cnt++;
    return 1;
}

/**
 *
 * Moves the event object toward a position with the requested easing mode.
 *
 */
static int scsMove2(_SEN_OBJ_SEQ *node, CSceneObjSeq *owner) {
    float delta[4];
    int   ended;
    int   moved;

    if (node->mode == SCENE_SEQ_EASE_IN_OUT) {
        ended = owner->pos_ease_frame;
    } else {
        ended = owner->pos_ease_frame / 2;
    }

    if (owner->pos_cnt >= node->frame + ended) {
        owner->pos_cnt = 0;
        return 0;
    }

    if (owner->pos_cnt <= 0) {
        sceVu0SubVector(delta, node->vec, owner->pos);
        sceVu0DivVector(owner->pos_spd, delta, node->frame);
        owner->pos_spd[3] = 1.0f;
        owner->pos_ease_frame = (int) (node->frame * node->ease_rate);
        sceVu0CopyVector(owner->pos_ease_acc, owner->pos_spd);
        sceVu0DivVector(owner->pos_ease_acc, owner->pos_ease_acc, owner->pos_ease_frame);

        if (node->mode != SCENE_SEQ_EASE_OUT) {
            sceVu0CopyVector(owner->pos_ease_spd, owner->pos_ease_acc);
        } else {
            sceVu0CopyVector(owner->pos_ease_spd, owner->pos_spd);
        }
    } else {
        moved = 0;

        if (owner->pos_cnt < owner->pos_ease_frame &&
            (node->mode == SCENE_SEQ_EASE_IN_OUT || node->mode == SCENE_SEQ_EASE_IN)) {
            sceVu0AddVector(owner->pos_ease_spd, owner->pos_ease_spd, owner->pos_ease_acc);
            sceVu0AddVector(owner->pos, owner->pos, owner->pos_ease_spd);
            moved = 1;
            owner->pos[3] = 1.0f;
        }

        if ((node->mode == SCENE_SEQ_EASE_OUT && owner->pos_cnt >= node->frame - owner->pos_ease_frame / 2) ||
            (node->mode == SCENE_SEQ_EASE_IN_OUT && owner->pos_cnt >= node->frame)) {
            sceVu0SubVector(owner->pos_ease_spd, owner->pos_ease_spd, owner->pos_ease_acc);
            sceVu0AddVector(owner->pos, owner->pos, owner->pos_ease_spd);
            moved = 1;
            owner->pos[3] = 1.0f;
        }

        if (moved == 0) {
            sceVu0AddVector(owner->pos, owner->pos, owner->pos_spd);
            owner->pos[3] = 1.0f;
        }
    }

    owner->pos_cnt++;
    return 1;
}

/**
 *
 * Clears the event object path before new points are added.
 *
 */
static int scsInitPas(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    owner->pas.Initialize();
    return 0;
}

/**
 *
 * Sets the duration of the event object path.
 *
 */
static int scsSetPasFrm(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    owner->pas.SetFrame(seq->frame);
    return 0;
}

/**
 *
 * Adds a position to the event object path.
 *
 */
static int scsAddPas(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    owner->pas.AddCharaPas(seq->vec);
    return 0;
}

/**
 *
 * Steps the event object along its path and updates its facing.
 *
 */
static int scsStartPas(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    float     previous_pos[4];
    mgVu0FBOX box;
    CCPoly    polys[128];
    float     from[4];
    float     to[4];
    float     hit[4];
    int       count;

    if (owner->pos_cnt <= 0) {
        owner->pas.Setup();
        owner->pas.Run();
        owner->pos_cnt = 1;
    }

    sceVu0CopyVector(previous_pos, owner->pos);
    owner->pas.Step(owner->pos, &owner->rot[1]);

    if (seq->frame == 1) {
        box.max[0] = 10.0f + owner->pos[0];
        box.min[0] = owner->pos[0] - 10.0f;
        box.max[1] = 10.0f + owner->pos[1];
        box.min[1] = owner->pos[1] - 10.0f;
        box.max[2] = 10.0f + owner->pos[2];
        box.min[2] = owner->pos[2] - 10.0f;
        count = GetMainScene()->GetColPoly(polys, box, 128);
        sceVu0CopyVector(from, owner->pos);
        from[1] += 10.0f;
        from[3] = 1.0f;
        sceVu0CopyVector(to, owner->pos);

        to[1] += 10.0f;
        to[3] = 1.0f;

        if (CheckHit(polys, count, from, to, hit, 1, 0) >= 0) {
            owner->pos[1] = hit[1];
        }
    }

    if (owner->pas.CheckEnd() != 0) {
        owner->pos_cnt = 0;
        return 0;
    }

    return 1;
}

/**
 *
 * Moves the event object along a parabolic jump to the command position.
 *
 */
static int scsJump(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    int elapsed;

    if (owner->pos_cnt <= 0) {
        sceVu0CopyVector(owner->jump_start, owner->pos);
        sceVu0CopyVector(owner->jump_end, seq->vec);
    }

    elapsed = owner->pos_cnt;

    if (elapsed >= seq->sub_frame) {
        sceVu0CopyVector(owner->pos, owner->jump_end);
        owner->pos_cnt = 0;
        return 0;
    }

    owner->pos_cnt = elapsed + 1;
    CalcPosParabolicJump(owner->pos, owner->jump_start, owner->jump_end, seq->value, (float) seq->sub_frame,
                         (float) owner->pos_cnt);
    return 1;
}

/**
 *
 * Positions the event object at a named frame of another event object.
 *
 */
static int scsSetEohFramePos(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    float frame_pos[4];

    if (EventObjHandleMother.GetFramePos(seq->no, seq->name, frame_pos) == 0) {
        return 0;
    }

    sceVu0AddVector(owner->pos, frame_pos, seq->vec);

    if (seq->sub_frame >= 0 && !(owner->pos_cnt < seq->sub_frame)) {
        owner->pos_cnt = 0;
        return 0;
    }

    if (seq->sub_frame > 0) {
        owner->pos_cnt++;
    }

    return 1;
}

/**
 *
 * Adds the command displacement to the event object over several frames.
 *
 */
static int scsAddPos(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    int elapsed;

    elapsed = owner->pos_cnt;

    if (elapsed >= seq->frame) {
        owner->pos_cnt = 0;
        return 0;
    }

    sceVu0AddVector(owner->pos, owner->pos, seq->vec);
    owner->pos_cnt++;
    return 1;
}

/**
 *
 * Positions the event object at a fixed distance along the active camera view.
 *
 */
static int scsAttachCamera(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    mgCCamera *camera;
    float      camera_pos[4];
    float      camera_ref[4];
    float      direction[4];
    float      target[4];

    if (seq->sub_frame >= 0 && !(owner->pos_cnt < seq->sub_frame)) {
        owner->pos_cnt = 0;
        return 0;
    }

    camera = GetActiveCamera();
    camera->GetPos(camera_pos);
    camera->GetRef(camera_ref);
    sceVu0SubVector(direction, camera_ref, camera_pos);
    sceVu0Normalize(direction, direction);
    sceVu0ScaleVector(direction, direction, seq->value);
    sceVu0AddVector(target, camera_pos, direction);
    sceVu0CopyVector(owner->pos, target);
    owner->pos_cnt++;
    return 1;
}

/**
 *
 * Applies the sequence pose to the event object and resets its DA position.
 *
 */
static int scsResetDAPosition(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    EventObjHandleMother.SetPos(owner->eoh_no, owner->pos[0], owner->pos[1], owner->pos[2]);
    EventObjHandleMother.SetRot(owner->eoh_no, owner->rot[0], owner->rot[1], owner->rot[2]);
    EventObjHandleMother.UpdatePosition(owner->eoh_no);
    EventObjHandleMother.ResetDAPosition(owner->eoh_no);
    return 0;
}

/**
 *
 * Waits the requested number of frames before an object rotation command.
 *
 */
static int scsRotDelay(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    int elapsed;

    elapsed = owner->rot_cnt;

    if (elapsed >= seq->frame) {
        owner->rot_cnt = 0;
        return 0;
    }

    owner->rot_cnt = elapsed + 1;
    return 1;
}

/**
 *
 * Sets the event object sequence rotation immediately.
 *
 */
static int scsSetRot(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    sceVu0CopyVector(owner->rot, seq->vec);
    return 0;
}

/**
 *
 * Turns the event object toward the command rotation over time.
 *
 */
static int scsRotation(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    int   i;
    int   j;
    int   k;
    float delta;

    if (seq->frame < 0) {
        for (i = 0; i < 3; i++) {
            owner->rot[i] += seq->vec[i];

            if (owner->rot[i] > 3.1415927f) {
                owner->rot[i] -= 6.2831855f;
            } else if (owner->rot[i] <= -3.1415927f) {
                owner->rot[i] += 6.2831855f;
            }
        }
    } else {
        if (!(owner->rot_cnt < seq->frame)) {
            sceVu0CopyVector(owner->rot, seq->vec);
            owner->rot_cnt = 0;
            return 0;
        }

        if (owner->rot_cnt <= 0) {
            for (j = 0; j < 3; j++) {
                delta = seq->vec[j] - owner->rot[j];

                if (delta > 3.1415927f) {
                    delta -= 6.2831855f;
                } else if (delta <= -3.1415927f) {
                    delta += 6.2831855f;
                }

                owner->rot_spd[j] = delta / seq->frame;
            }
        } else {
            for (k = 0; k < 3; k++) {
                owner->rot[k] += owner->rot_spd[k];

                if (owner->rot[k] > 3.1415927f) {
                    owner->rot[k] -= 6.2831855f;
                } else if (owner->rot[k] <= -3.1415927f) {
                    owner->rot[k] += 6.2831855f;
                }
            }
        }

        owner->rot_cnt++;
    }

    return 1;
}

/**
 *
 * Turns the event object with the requested easing mode.
 *
 */
static int scsRotation2(_SEN_OBJ_SEQ *node, CSceneObjSeq *owner) {
    float delta[4];
    int   ended;
    int   moved;

    if (node->mode == SCENE_SEQ_EASE_IN_OUT) {
        ended = owner->rot_ease_frame;
    } else {
        ended = owner->rot_ease_frame / 2;
    }

    if (owner->rot_cnt >= node->frame + ended) {
        owner->rot_cnt = 0;
        return 0;
    }

    if (owner->rot_cnt <= 0) {
        sceVu0SubVector(delta, node->vec, owner->rot);
        sceVu0DivVector(owner->rot_spd, delta, node->frame);
        owner->rot_spd[3] = 1.0f;
        owner->rot_ease_frame = (int) (node->frame * node->ease_rate);
        sceVu0CopyVector(owner->rot_ease_acc, owner->rot_spd);
        sceVu0DivVector(owner->rot_ease_acc, owner->rot_ease_acc, owner->rot_ease_frame);

        if (node->mode != SCENE_SEQ_EASE_OUT) {
            sceVu0CopyVector(owner->rot_ease_spd, owner->rot_ease_acc);
        } else {
            sceVu0CopyVector(owner->rot_ease_spd, owner->rot_spd);
        }
    } else {
        moved = 0;

        if (owner->rot_cnt < owner->rot_ease_frame &&
            (node->mode == SCENE_SEQ_EASE_IN_OUT || node->mode == SCENE_SEQ_EASE_IN)) {
            sceVu0AddVector(owner->rot_ease_spd, owner->rot_ease_spd, owner->rot_ease_acc);
            sceVu0AddVector(owner->rot, owner->rot, owner->rot_ease_spd);

            if (owner->rot[1] > 3.1415927f) {
                owner->rot[1] -= 6.2831855f;
            } else if (owner->rot[1] <= -3.1415927f) {
                owner->rot[1] += 6.2831855f;
            }

            moved = 1;
            owner->rot[3] = 1.0f;
        }

        if ((node->mode == SCENE_SEQ_EASE_OUT && owner->rot_cnt >= node->frame - owner->rot_ease_frame / 2) ||
            (node->mode == SCENE_SEQ_EASE_IN_OUT && owner->rot_cnt >= node->frame)) {
            sceVu0SubVector(owner->rot_ease_spd, owner->rot_ease_spd, owner->rot_ease_acc);
            sceVu0AddVector(owner->rot, owner->rot, owner->rot_ease_spd);

            if (owner->rot[1] > 3.1415927f) {
                owner->rot[1] -= 6.2831855f;
            } else if (owner->rot[1] <= -3.1415927f) {
                owner->rot[1] += 6.2831855f;
            }

            moved = 1;
            owner->rot[3] = 1.0f;
        }

        if (moved == 0) {
            sceVu0AddVector(owner->rot, owner->rot, owner->rot_spd);

            if (owner->rot[1] > 3.1415927f) {
                owner->rot[1] -= 6.2831855f;
            } else if (owner->rot[1] <= -3.1415927f) {
                owner->rot[1] += 6.2831855f;
            }

            owner->rot[3] = 1.0f;
        }
    }

    owner->rot_cnt++;
    return 1;
}

/**
 *
 * Turns the event object to face a target position.
 *
 */
static int scsReference(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    float direction[4];
    float target[4];
    float angle;
    float delta;

    if (!(owner->rot_cnt < seq->frame)) {
        if (seq->frame > 0) {
            sceVu0CopyVector(owner->rot, seq->vec);
        }

        owner->rot_cnt = 0;
        return 0;
    }

    if (owner->rot_cnt <= 0) {
        angle = 0.0f;
        mgZeroVector(target);
        sceVu0SubVector(direction, owner->pos, seq->vec);
        direction[3] = 0;
        direction[1] = 0;
        sceVu0Normalize(direction, direction);

        if (!(angle == direction[0] && angle == direction[2])) {
            angle = atan2f(-direction[0], -direction[2]);
        }

        target[1] = angle;
        sceVu0CopyVector(seq->vec, target);
        delta = seq->vec[1] - owner->rot[1];

        if (delta > 3.1415927f) {
            delta -= 6.2831855f;
        } else if (delta <= -3.1415927f) {
            delta += 6.2831855f;
        }

        owner->rot_spd[1] = delta / seq->frame;
    } else {
        owner->rot[1] += owner->rot_spd[1];

        if (owner->rot[1] > 3.1415927f) {
            owner->rot[1] -= 6.2831855f;
        } else if (owner->rot[1] <= -3.1415927f) {
            owner->rot[1] += 6.2831855f;
        }
    }

    owner->rot_cnt++;
    return 1;
}

/**
 *
 * Waits the requested number of frames before an object motion command.
 *
 */
static int scsMotionDelay(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    int elapsed;

    elapsed = owner->mot_cnt;

    if (elapsed >= seq->frame) {
        owner->mot_cnt = 0;
        return 0;
    }

    owner->mot_cnt = elapsed + 1;
    return 1;
}

/**
 *
 * Starts the named motion on the event object.
 *
 */
static int scsSetMotion(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    if (seq->started == 0) {
        EventObjHandleMother.SetMotion(owner->eoh_no, seq->name, seq->no, seq->step);

        if (seq->next != NULL) {
            if (seq->next->cmd == SCENE_OBJ_CMD_SET_MOT_CHANGE_STEP ||
                seq->next->cmd == SCENE_OBJ_CMD_NORMAL_DRIVE) {
                return 0;
            }
        }

        seq->started = 1;
        return 1;
    }

    return 0;
}

/**
 *
 * Waits for the current motion to end before starting the next motion.
 *
 */
static int scsNextMotion(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    if (seq->started == 0) {
        if (EventObjHandleMother.CheckMotionEnd(owner->eoh_no) != 0) {
            EventObjHandleMother.SetMotion(owner->eoh_no, seq->name, seq->no, seq->step);

            if (seq->next != NULL && seq->next->cmd == SCENE_OBJ_CMD_SET_MOT_CHANGE_STEP) {
                return 0;
            }

            seq->started = 1;
            return 1;
        } else {
            return 1;
        }
    }

    return 0;
}

/**
 *
 * Waits until the event object motion finishes.
 *
 */
static int scsMotionWait(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    return (EventObjHandleMother.CheckMotionEnd(owner->eoh_no) != 0) ^ 1;
}

/**
 *
 * Triggers the current event object motion.
 *
 */
static int scsMotionTrg(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    EventObjHandleMother.SetMotionTrg(owner->eoh_no);
    return 0;
}

/**
 *
 * Sets the event object motion playback step.
 *
 */
static int scsSetMotStep(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    EventObjHandleMother.SetStep(owner->eoh_no, seq->value);
    return 0;
}

/**
 *
 * Sets the event object motion transition step.
 *
 */
static int scsSetMotChangeStep(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    EventObjHandleMother.SetChangeStep(owner->eoh_no, seq->value);
    return 0;
}

/**
 *
 * Resets the event object motion.
 *
 */
static int scsResetMotion(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    EventObjHandleMother.ResetMotion(owner->eoh_no);
    return 0;
}

/**
 *
 * Sets the current playback time of the event object motion.
 *
 */
static int scsSetMotionNowTime(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    EventObjHandleMother.SetMotionNowTime(owner->eoh_no, seq->value);
    return 0;
}

/**
 *
 * Sets the waiting time of the event object motion.
 *
 */
static int scsSetMotionWaitTime(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    EventObjHandleMother.SetMotionWaitTime(owner->eoh_no, seq->value);
    return 0;
}

/**
 *
 * Restores normal event object motion playback.
 *
 */
static int scsNormalDrive(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    EventObjHandleMother.NormalDrive(owner->eoh_no);
    return 0;
}

/**
 *
 * Waits for the event object sequence status to reach its trigger state.
 *
 */
static int scsMotionTrgWait(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    return (EventObjHandleMother.GetSeqStatus(owner->eoh_no) == 3) ^ 1;
}

/**
 *
 * Waits the requested number of frames before a texture animation command.
 *
 */
static int scsTexAnimeDelay(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    int elapsed;

    elapsed = owner->anm_cnt;

    if (elapsed >= seq->frame) {
        owner->anm_cnt = 0;
        return 0;
    }

    owner->anm_cnt = elapsed + 1;
    return 1;
}

/**
 *
 * Selects a texture animation for the event object.
 *
 */
static int scsTexAnime(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    if (strcmp(seq->name, "") == 0) {
        EventObjHandleMother.SetTexAnim(owner->eoh_no, seq->frame, NULL);
    } else {
        EventObjHandleMother.SetTexAnim(owner->eoh_no, seq->frame, seq->name);
    }

    return 0;
}

/**
 *
 * Waits the requested number of frames before an object color command.
 *
 */
static int scsColorDelay(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    int elapsed;

    elapsed = owner->col_cnt;

    if (elapsed >= seq->frame) {
        owner->col_cnt = 0;
        return 0;
    }

    owner->col_cnt = elapsed + 1;
    return 1;
}

/**
 *
 * Changes the event object color toward the command color over time.
 *
 */
static int scsSetColor(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    float delta[4];
    float current[4];
    float stepped[4];

    if (!(owner->col_cnt < seq->frame)) {
        EventObjHandleMother.SetColor(owner->eoh_no, seq->vec);
        owner->col_cnt = 0;
        return 0;
    }

    if (owner->col_cnt <= 0) {
        EventObjHandleMother.GetColor(owner->eoh_no, current);
        sceVu0SubVector(delta, seq->vec, current);
        sceVu0DivVector(owner->color_spd, delta, seq->frame);
    } else {
        EventObjHandleMother.GetColor(owner->eoh_no, stepped);
        sceVu0AddVector(stepped, stepped, owner->color_spd);
        EventObjHandleMother.SetColor(owner->eoh_no, stepped);
    }

    owner->col_cnt++;
    return 1;
}

/**
 *
 * Waits the requested number of frames before an object scale command.
 *
 */
static int scsScaleDelay(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    int elapsed;

    elapsed = owner->scale_cnt;

    if (elapsed >= seq->frame) {
        owner->scale_cnt = 0;
        return 0;
    }

    owner->scale_cnt = elapsed + 1;
    return 1;
}

/**
 *
 * Changes the event object scale toward the command scale over time.
 *
 */
static int scsSetScale(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    float delta[4];
    float current[4];
    float stepped[4];

    if (!(owner->scale_cnt < seq->frame)) {
        EventObjHandleMother.SetScale(owner->eoh_no, seq->vec[0], seq->vec[1], seq->vec[2]);
        owner->scale_cnt = 0;
        return 0;
    }

    if (owner->scale_cnt <= 0) {
        EventObjHandleMother.GetScale(owner->eoh_no, current);
        sceVu0SubVector(delta, seq->vec, current);
        sceVu0DivVector(owner->scale_spd, delta, seq->frame);
    } else {
        EventObjHandleMother.GetScale(owner->eoh_no, stepped);
        sceVu0AddVector(stepped, stepped, owner->scale_spd);
        EventObjHandleMother.SetScale(owner->eoh_no, stepped[0], stepped[1], stepped[2]);
    }

    owner->scale_cnt++;
    return 1;
}

/**
 *
 * Waits the requested number of frames before a sound effect command.
 *
 */
static int scsSeDelay(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    int elapsed;

    elapsed = owner->se_cnt;

    if (elapsed >= seq->frame) {
        owner->se_cnt = 0;
        return 0;
    }

    owner->se_cnt = elapsed + 1;
    return 1;
}

/**
 *
 * Plays the sound effect specified by an object sequence command.
 *
 */
static int scsSePlay(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    sndSePlay(seq->no, seq->se_no, 0);
    return 0;
}

/**
 *
 * Keeps the object sequence waiting without changing its state.
 *
 */
static int scsDummy(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    return 1;
}

/**
 *
 * Clears an event object sequence command and its links.
 *
 */
void InitSceneObjSeq(_SEN_OBJ_SEQ *seq) {
    seq->cmd = 0;
    mgZeroVector(seq->vec);
    seq->frame = 0;
    seq->mode = 0;
    seq->ease_rate = 0;
    strcpy(seq->name, "");
    seq->next = NULL;
}

CSceneObjSeq::CSceneObjSeq() {
    ZeroInitialize();
}

void CSceneObjSeq::ZeroInitialize() {
    seq_tbl = 0;
    seq_num = 0;
    Initialize(0, 0);
}

void CSceneObjSeq::Initialize(_SEN_OBJ_SEQ *nodes, int count) {
    int i;

    seq_tbl = nodes;
    seq_num = count;
    Clear();

    if (seq_tbl != NULL && seq_num > 0) {
        for (i = 0; i < seq_num; i++) {
            InitSceneObjSeq(seq_tbl + i);
        }
    }
}

void CSceneObjSeq::Clear() {
    eoh_no = -1;
    mgZeroVector(pos);
    mgZeroVector(rot);
    mgZeroVector(color_spd);
    mgZeroVector(pos_ease_spd);
    mgZeroVector(pos_ease_acc);
    pos_ease_frame = 0;
    mgZeroVector(rot_ease_spd);
    mgZeroVector(rot_ease_acc);
    rot_ease_frame = 0;
    pos_seq = 0;
    pos_last = 0;
    rot_seq = 0;
    rot_last = 0;
    mot_seq = 0;
    mot_last = 0;
    anm_seq = 0;
    anm_last = 0;
    col_seq = 0;
    col_last = 0;
    scale_seq = 0;
    scale_last = 0;
    se_seq = 0;
    se_last = 0;
    pos_cnt = 0;
    rot_cnt = 0;
    mot_cnt = 0;
    anm_cnt = 0;
    col_cnt = 0;
    scale_cnt = 0;
    se_cnt = 0;
}

void CSceneObjSeq::SetEohNo(int eoh_no) {
    this->eoh_no = eoh_no;
}

_SEN_OBJ_SEQ *CSceneObjSeq::SearchSeq() {
    _SEN_OBJ_SEQ *node = seq_tbl;
    int           i;

    for (i = 0; i < seq_num; i++, node++) {
        if (node->cmd == 0) {
            node->next = NULL;
            return node;
        }
    }

    return NULL;
}

_SEN_OBJ_SEQ *CSceneObjSeq::GetNextSeq(_SEN_OBJ_SEQ *seq) {
    _SEN_OBJ_SEQ *next;

    if (seq == NULL) {
        return 0;
    }

    next = seq->next;
    InitSceneObjSeq(seq);
    return next;
}

_SEN_OBJ_SEQ *CSceneObjSeq::SearchNextPosSeq() {
    _SEN_OBJ_SEQ *node = SearchSeq();

    if (node == NULL) {
        return NULL;
    }

    if (pos_last != NULL) {
        pos_last->next = node;
    }

    pos_last = node;
    node->next = NULL;

    if (pos_seq == NULL) {
        pos_seq = node;
    }

    return node;
}

_SEN_OBJ_SEQ *CSceneObjSeq::SearchNextRotSeq() {
    _SEN_OBJ_SEQ *node = SearchSeq();

    if (node == NULL) {
        return NULL;
    }

    if (rot_last != NULL) {
        rot_last->next = node;
    }

    rot_last = node;
    node->next = NULL;

    if (rot_seq == NULL) {
        rot_seq = node;
    }

    return node;
}

_SEN_OBJ_SEQ *CSceneObjSeq::SearchNextMotSeq() {
    _SEN_OBJ_SEQ *node = SearchSeq();

    if (node == NULL) {
        return NULL;
    }

    if (mot_last != NULL) {
        mot_last->next = node;
    }

    mot_last = node;
    node->next = NULL;

    if (mot_seq == NULL) {
        mot_seq = node;
    }

    return node;
}

_SEN_OBJ_SEQ *CSceneObjSeq::SearchNextAnmSeq() {
    _SEN_OBJ_SEQ *node = SearchSeq();

    if (node == NULL) {
        return NULL;
    }

    if (anm_last != NULL) {
        anm_last->next = node;
    }

    anm_last = node;
    node->next = NULL;

    if (anm_seq == NULL) {
        anm_seq = node;
    }

    return node;
}

_SEN_OBJ_SEQ *CSceneObjSeq::SearchNextColSeq() {
    _SEN_OBJ_SEQ *node = SearchSeq();

    if (node == NULL) {
        return NULL;
    }

    if (col_last != NULL) {
        col_last->next = node;
    }

    col_last = node;
    node->next = NULL;

    if (col_seq == NULL) {
        col_seq = node;
    }

    return node;
}

_SEN_OBJ_SEQ *CSceneObjSeq::SearchNextScaleSeq() {
    _SEN_OBJ_SEQ *node = SearchSeq();

    if (node == NULL) {
        return NULL;
    }

    if (scale_last != NULL) {
        scale_last->next = node;
    }

    scale_last = node;
    node->next = NULL;

    if (scale_seq == NULL) {
        scale_seq = node;
    }

    return node;
}

_SEN_OBJ_SEQ *CSceneObjSeq::SearchNextSeSeq() {
    _SEN_OBJ_SEQ *node = SearchSeq();

    if (node == NULL) {
        return NULL;
    }

    if (se_last != NULL) {
        se_last->next = node;
    }

    se_last = node;
    node->next = NULL;

    if (se_seq == NULL) {
        se_seq = node;
    }

    return node;
}

int CSceneObjSeq::CheckEnd() {
    if (pos_seq == 0) {
        if (rot_seq == 0 && mot_seq == 0 && anm_seq == 0 && col_seq == 0 && scale_seq == 0 && se_seq == 0) {
            return 1;
        }
    }

    return 0;
}

/**
 *
 * Dispatches object sequence commands in command-code order.
 *
 */
static int (*ScsObjSeqCallTbl[SCENE_OBJ_CMD_NUM + 1])(_SEN_OBJ_SEQ *, CSceneObjSeq *) = {
    scsDummy,
    scsPosDelay,
    scsSetPos,
    scsMove,
    scsMove2,
    scsInitPas,
    scsSetPasFrm,
    scsAddPas,
    scsStartPas,
    scsJump,
    scsSetEohFramePos,
    scsAddPos,
    scsAttachCamera,
    scsRotDelay,
    scsSetRot,
    scsRotation,
    scsRotation2,
    scsReference,
    scsMotionDelay,
    scsSetMotion,
    scsNextMotion,
    scsMotionWait,
    scsMotionTrg,
    scsMotionTrgWait,
    scsSetMotStep,
    scsSetMotChangeStep,
    scsResetMotion,
    scsSetMotionNowTime,
    scsSetMotionWaitTime,
    scsNormalDrive,
    scsTexAnimeDelay,
    scsTexAnime,
    scsColorDelay,
    scsSetColor,
    scsScaleDelay,
    scsSetScale,
    scsSeDelay,
    scsSePlay,
    scsResetDAPosition,
    scsDummy,
};

void CSceneObjSeq::Play() {
    _SEN_OBJ_SEQ  *node;
    int            lane;
    _SEN_OBJ_SEQ **head;
    _SEN_OBJ_SEQ **tail;

    if (eoh_no > -1) {
        if (EventObjHandleMother.GetPos(eoh_no, pos) != 1) {
            Clear();
            return;
        }

        EventObjHandleMother.GetRot(eoh_no, rot);

        for (lane = 0; lane < 7; lane++) {

            switch (lane) {
                case 0:
                    head = &pos_seq;
                    tail = &pos_last;
                    break;
                case 1:
                    head = &rot_seq;
                    tail = &rot_last;
                    break;
                case 2:
                    head = &mot_seq;
                    tail = &mot_last;
                    break;
                case 3:
                    head = &anm_seq;
                    tail = &anm_last;
                    break;
                case 4:
                    head = &col_seq;
                    tail = &col_last;
                    break;
                case 5:
                    head = &scale_seq;
                    tail = &scale_last;
                    break;
                case 6:
                    head = &se_seq;
                    tail = &se_last;
                    break;
            }

            node = *head;

            if (node != NULL) {
                do {
                    if (node->cmd > 0 && node->cmd <= SCENE_OBJ_CMD_RESET_DA_POSITION) {
                        if (ScsObjSeqCallTbl[node->cmd](node, this) != 0) {
                            break;
                        }
                    } else {
                        node = NULL;
                        break;
                    }

                    node = GetNextSeq(node);
                } while (node != NULL);
            }

            *head = node;

            if (node == NULL) {
                *tail = NULL;
            }
        }

        rot[1] = mgAngleLimit(rot[1]);
        EventObjHandleMother.SetPos(eoh_no, pos[0], pos[1], pos[2]);
        EventObjHandleMother.SetRot(eoh_no, rot[0], rot[1], rot[2]);
    }
}

void CSceneObjSeq::PosDelay(int frames) {
    _SEN_OBJ_SEQ *command = SearchNextPosSeq();

    if (command != NULL) {
        if (frames > 0) {
            frames = (frames * 50) / 60;

            if (frames <= 0) {
                frames = 1;
            }
        }

        command->cmd = SCENE_OBJ_CMD_POS_DELAY;
        command->frame = frames;
    }
}

void CSceneObjSeq::SetPos(float *new_pos) {
    _SEN_OBJ_SEQ *node;

    node = SearchNextPosSeq();

    if (node != NULL) {
        node->cmd = SCENE_OBJ_CMD_SET_POS;
        sceVu0CopyVector(node->vec, new_pos);
    }
}

void CSceneObjSeq::Move(float *dest, int frames, int mode) {
    _SEN_OBJ_SEQ *node;

    node = SearchNextPosSeq();

    if (node != NULL) {
        CONVERT_TO_PAL_FRAMES(frames);
        node->cmd = SCENE_OBJ_CMD_MOVE;
        sceVu0CopyVector(node->vec, dest);
        node->frame = frames;
        node->mode = mode;
    }
}

void CSceneObjSeq::Move2(float *dest, int frames, int mode, float param28) {
    _SEN_OBJ_SEQ *node;

    node = SearchNextPosSeq();

    if (node != NULL) {
        CONVERT_TO_PAL_FRAMES(frames);
        node->cmd = SCENE_OBJ_CMD_MOVE2;
        sceVu0CopyVector(node->vec, dest);
        node->frame = frames;
        node->mode = mode;
        node->ease_rate = param28;
    }
}

void CSceneObjSeq::InitPas() {
    _SEN_OBJ_SEQ *command = SearchNextPosSeq();

    if (command != NULL) {
        command->cmd = SCENE_OBJ_CMD_INIT_PAS;
    }
}

void CSceneObjSeq::SetPasFrm(int frames) {
    _SEN_OBJ_SEQ *command = SearchNextPosSeq();

    if (command != NULL) {
        if (frames > 0) {
            frames = (frames * 50) / 60;

            if (frames <= 0) {
                frames = 1;
            }
        }

        command->cmd = SCENE_OBJ_CMD_SET_PAS_FRM;
        command->frame = frames;
    }
}

void CSceneObjSeq::AddPas(float *point) {
    _SEN_OBJ_SEQ *node;

    node = SearchNextPosSeq();

    if (node != NULL) {
        node->cmd = SCENE_OBJ_CMD_ADD_PAS;
        sceVu0CopyVector(node->vec, point);
    }
}

void CSceneObjSeq::StartPas(int grounded) {
    _SEN_OBJ_SEQ *command = SearchNextPosSeq();

    if (command != NULL) {
        command->cmd = SCENE_OBJ_CMD_START_PAS;
        command->grounded = grounded;
    }
}

void CSceneObjSeq::Jump(float *dest, float height, int frames) {
    _SEN_OBJ_SEQ *node;

    node = SearchNextPosSeq();

    if (node != NULL) {
        if (frames > 0) {
            frames = (frames * 50) / 60;

            if (frames <= 0) {
                frames = 1;
            }

            height = 1.2f * height;
        }

        node->cmd = SCENE_OBJ_CMD_JUMP;
        sceVu0CopyVector(node->vec, dest);
        node->value = height;
        node->sub_frame = frames;
    }
}

void CSceneObjSeq::SetEohFramePos(int eoh_no, char *frame_name, int frames, float *offset) {
    _SEN_OBJ_SEQ *node;

    node = SearchNextPosSeq();

    if (node != NULL) {
        CONVERT_TO_PAL_FRAMES(frames);
        node->cmd = SCENE_OBJ_CMD_SET_EOH_FRAME_POS;
        node->no = eoh_no;
        strcpy(node->name, frame_name);
        node->sub_frame = frames;
        sceVu0CopyVector(node->vec, offset);
    }
}

void CSceneObjSeq::AddPos(float *offset, int frames) {
    _SEN_OBJ_SEQ *node;

    node = SearchNextPosSeq();

    if (node != NULL) {
        CONVERT_TO_PAL_FRAMES(frames);
        node->cmd = SCENE_OBJ_CMD_ADD_POS;
        sceVu0CopyVector(node->vec, offset);
        node->frame = frames;
    }
}

void CSceneObjSeq::AttachCamera(float value, int frames) {
    _SEN_OBJ_SEQ *node;

    node = SearchNextPosSeq();

    if (node != NULL) {
        CONVERT_TO_PAL_FRAMES(frames);
        node->cmd = SCENE_OBJ_CMD_ATTACH_CAMERA;
        node->value = value;
        node->sub_frame = frames;
    }
}

void CSceneObjSeq::RotDelay(int frames) {
    _SEN_OBJ_SEQ *command = SearchNextRotSeq();

    if (command != NULL) {
        if (frames > 0) {
            frames = (frames * 50) / 60;

            if (frames <= 0) {
                frames = 1;
            }
        }

        command->cmd = SCENE_OBJ_CMD_ROT_DELAY;
        command->frame = frames;
    }
}

void CSceneObjSeq::SetRot(float *new_rot) {
    _SEN_OBJ_SEQ *node;

    node = SearchNextRotSeq();

    if (node != NULL) {
        node->cmd = SCENE_OBJ_CMD_SET_ROT;
        sceVu0CopyVector(node->vec, new_rot);
    }
}

void CSceneObjSeq::Rotation(float *target, int frames) {
    _SEN_OBJ_SEQ *node;

    node = SearchNextRotSeq();

    if (node != NULL) {
        CONVERT_TO_PAL_FRAMES(frames);
        node->cmd = SCENE_OBJ_CMD_ROTATION;
        sceVu0CopyVector(node->vec, target);
        node->frame = frames;
    }
}

void CSceneObjSeq::Rotation2(float *target, int frames, int mode, float param28) {
    _SEN_OBJ_SEQ *node;

    node = SearchNextRotSeq();

    if (node != NULL) {
        CONVERT_TO_PAL_FRAMES(frames);
        node->cmd = SCENE_OBJ_CMD_ROTATION2;
        sceVu0CopyVector(node->vec, target);
        node->frame = frames;
        node->mode = mode;
        node->ease_rate = param28;
    }
}

void CSceneObjSeq::Reference(float *ref, int frames) {
    _SEN_OBJ_SEQ *node;

    node = SearchNextRotSeq();

    if (node != NULL) {
        CONVERT_TO_PAL_FRAMES(frames);
        node->cmd = SCENE_OBJ_CMD_REFERENCE;
        sceVu0CopyVector(node->vec, ref);
        node->frame = frames;
    }
}

void CSceneObjSeq::MotionDelay(int frames) {
    _SEN_OBJ_SEQ *command = SearchNextMotSeq();

    if (command != NULL) {
        if (frames > 0) {
            frames = (frames * 50) / 60;

            if (frames <= 0) {
                frames = 1;
            }
        }

        command->cmd = SCENE_OBJ_CMD_MOTION_DELAY;
        command->frame = frames;
    }
}

void CSceneObjSeq::SetMotion(char *name, int frames, float speed) {
    _SEN_OBJ_SEQ *node;

    node = SearchNextMotSeq();

    if (node != NULL) {
        node->cmd = SCENE_OBJ_CMD_SET_MOTION;
        strcpy(node->name, name);
        node->frame = frames;
        node->step = speed;
        node->ease_rate = 0;
    }
}

void CSceneObjSeq::NextMotion(char *name, int frames, float speed) {
    _SEN_OBJ_SEQ *node;

    node = SearchNextMotSeq();

    if (node != NULL) {
        node->cmd = SCENE_OBJ_CMD_NEXT_MOTION;
        strcpy(node->name, name);
        node->frame = frames;
        node->step = speed;
        node->ease_rate = 0;
    }
}

void CSceneObjSeq::MotionWait() {
    _SEN_OBJ_SEQ *command = SearchNextMotSeq();

    if (command != NULL) {
        command->cmd = SCENE_OBJ_CMD_MOTION_WAIT;
    }
}

void CSceneObjSeq::SetMotionTrg() {
    _SEN_OBJ_SEQ *command = SearchNextMotSeq();

    if (command != NULL) {
        command->cmd = SCENE_OBJ_CMD_MOTION_TRG;
    }
}

void CSceneObjSeq::MotionTrgWait() {
    _SEN_OBJ_SEQ *command = SearchNextMotSeq();

    if (command != NULL) {
        command->cmd = SCENE_OBJ_CMD_MOTION_TRG_WAIT;
    }
}

void CSceneObjSeq::SetStep(float step) {
    _SEN_OBJ_SEQ *node;

    node = SearchNextMotSeq();

    if (node != NULL) {
        node->cmd = SCENE_OBJ_CMD_SET_MOT_STEP;
        node->value = step;
    }
}

void CSceneObjSeq::SetChengeStep(float step) {
    _SEN_OBJ_SEQ *command = SearchNextMotSeq();

    if (command != NULL) {
        command->cmd = SCENE_OBJ_CMD_SET_MOT_CHANGE_STEP;
        command->value = step;
    }
}

void CSceneObjSeq::ResetMotion() {
    _SEN_OBJ_SEQ *command = SearchNextMotSeq();

    if (command != NULL) {
        command->cmd = SCENE_OBJ_CMD_RESET_MOTION;
    }
}

void CSceneObjSeq::SetMotionNowTime(float time) {
    _SEN_OBJ_SEQ *node;

    node = SearchNextMotSeq();

    if (node != NULL) {
        node->cmd = SCENE_OBJ_CMD_SET_MOTION_NOW_TIME;
        node->value = time;
    }
}

void CSceneObjSeq::SetMotionWaitTime(float time) {
    _SEN_OBJ_SEQ *node;

    node = SearchNextMotSeq();

    if (node != NULL) {
        node->cmd = SCENE_OBJ_CMD_SET_MOTION_WAIT_TIME;
        node->value = time;
    }
}

void CSceneObjSeq::NormalDrive() {
    _SEN_OBJ_SEQ *command = SearchNextMotSeq();

    if (command != NULL) {
        command->cmd = SCENE_OBJ_CMD_NORMAL_DRIVE;
    }
}

void CSceneObjSeq::TexAnimeDelay(int frames) {
    _SEN_OBJ_SEQ *command = SearchNextAnmSeq();

    if (command != NULL) {
        if (frames > 0) {
            frames = (frames * 50) / 60;

            if (frames <= 0) {
                frames = 1;
            }
        }

        command->cmd = SCENE_OBJ_CMD_TEX_ANIME_DELAY;
        command->frame = frames;
    }
}

void CSceneObjSeq::TexAnime(char *name, int frames) {
    _SEN_OBJ_SEQ *node;

    node = SearchNextAnmSeq();

    if (node != NULL) {
        node->cmd = SCENE_OBJ_CMD_TEX_ANIME;

        if (name != NULL) {
            strcpy(node->name, name);
        } else {
            strcpy(node->name, "");
        }

        node->frame = frames;
    }
}

void CSceneObjSeq::ColorDelay(int frames) {
    _SEN_OBJ_SEQ *command = SearchNextColSeq();

    if (command != NULL) {
        if (frames > 0) {
            frames = (frames * 50) / 60;

            if (frames <= 0) {
                frames = 1;
            }
        }

        command->cmd = SCENE_OBJ_CMD_COLOR_DELAY;
        command->frame = frames;
    }
}

void CSceneObjSeq::SetColor(float *color, int frames) {
    _SEN_OBJ_SEQ *node;

    node = SearchNextColSeq();

    if (node != NULL) {
        CONVERT_TO_PAL_FRAMES(frames);
        node->cmd = SCENE_OBJ_CMD_SET_COLOR;
        sceVu0CopyVector(node->vec, color);
        node->frame = frames;
    }
}

void CSceneObjSeq::ScaleDelay(int frames) {
    _SEN_OBJ_SEQ *command = SearchNextScaleSeq();

    if (command != NULL) {
        if (frames > 0) {
            frames = (frames * 50) / 60;

            if (frames <= 0) {
                frames = 1;
            }
        }

        command->cmd = SCENE_OBJ_CMD_SCALE_DELAY;
        command->frame = frames;
    }
}

void CSceneObjSeq::SetScale(float *scale, int frames) {
    _SEN_OBJ_SEQ *node;

    node = SearchNextScaleSeq();

    if (node != NULL) {
        CONVERT_TO_PAL_FRAMES(frames);
        node->cmd = SCENE_OBJ_CMD_SET_SCALE;
        sceVu0CopyVector(node->vec, scale);
        node->frame = frames;
    }
}

void CSceneObjSeq::SeDelay(int frames) {
    _SEN_OBJ_SEQ *command = SearchNextSeSeq();

    if (command != NULL) {
        if (frames > 0) {
            frames = (frames * 50) / 60;

            if (frames <= 0) {
                frames = 1;
            }
        }

        command->cmd = SCENE_OBJ_CMD_SE_DELAY;
        command->frame = frames;
    }
}

void CSceneObjSeq::SePlay(int sound_id, int sound_no) {
    _SEN_OBJ_SEQ *command = SearchNextSeSeq();

    if (command != NULL) {
        command->cmd = SCENE_OBJ_CMD_SE_PLAY;
        command->no = sound_id;
        command->se_no = sound_no;
    }
}

void CSceneObjSeq::ResetDAPosition() {
    _SEN_OBJ_SEQ *command = SearchNextSeSeq();

    if (command != NULL) {
        command->cmd = SCENE_OBJ_CMD_RESET_DA_POSITION;
    }

    _SEN_OBJ_SEQ *motion_command = SearchNextMotSeq();

    if (motion_command != NULL) {
        motion_command->cmd = SCENE_OBJ_CMD_RESET_DA_POSITION;
    }
}
