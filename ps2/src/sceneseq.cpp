#include "common.h"
#include "character.hpp"
#include "collision.hpp"
#include "mg_camera.hpp"
#include "mg_drawenv.hpp"
#include "sceneseq.hpp"
#include "scenesnd.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "eventsprite.hpp"
#include "mainloop.hpp"
#include "mg_math.hpp"
#include "mg_frame.hpp"
#include "sound.hpp"
#include <cmath>
#include <cstring>

extern int (*ScsCmrSeqCallTbl[])(_SEN_CMR_SEQ *, CSceneCmrSeq *);
extern int (*ScsObjSeqCallTbl[])(_SEN_OBJ_SEQ *, CSceneObjSeq *);
extern char at_1527__2[];
extern char at_2863[];

#define CONVERT_TO_PAL_FRAMES(frames)                                                              \
    if ((frames) > 0) {                                                                            \
        (frames) = ((frames) * 50) / 60;                                                           \
        if ((frames) <= 0) {                                                                       \
            (frames) = 1;                                                                          \
        }                                                                                          \
    }

// Code (.text)
void InitSplineKey(SPLINE_KEY * key) {
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sceneseq", Initialize__9C3DSplineFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sceneseq", SetUpSpline__9C3DSplineFPA4_fPiif);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sceneseq", StepS__9C3DSplineFv);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sceneseq", Step__9C3DSplineFv);
void C3DSpline::GetNowXYZ(float *out) {
    out[0] = now_pos[0];
    out[1] = now_pos[1];
    out[2] = now_pos[2];
    ((int *)out)[3] = 0x3F800000;
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
int CCameraPas::GetFrame(void) {
    return frame;
}
void CCameraPas::Initialize(void) {
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
#pragma divbyzerocheck on
int CCameraPas::Setup(void) {
    int frames[16];
    float distances[16];
    float eye_now[4];
    float eye_next[4];
    float look_now[4];
    float look_next[4];
    float total_length;
    int i;
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
    pos_spline.SetUpSpline(pos, frames, pas_num, total_length / (float)frame);
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
    ref_spline.SetUpSpline(ref, frames, pas_num, total_length / (float)frame);
    return 0;
}
#pragma divbyzerocheck reset
void CCameraPas::Run(void) {
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
int CCameraPas::CheckEnd(void) {
    return (u8)(((u32)run > 0) ^ 1);
}
CCharaPas::CCharaPas() {
    Initialize();
}
void CCharaPas::Initialize(void) {
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
#pragma divbyzerocheck on
int CCharaPas::Setup(void) {
    int frames[16];
    float distances[16];
    float point_now[4];
    float point_next[4];
    float total_length;
    int i;
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
    spline.SetUpSpline(pos, frames, pas_num, total_length / (float)frame);
    return 0;
}
#pragma divbyzerocheck reset
void CCharaPas::Run(void) {
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
    heading -= 3.1415927f * (2.0f * (float)(int)(heading / 6.2831855f));
    if (heading > 3.1415927f) {
        heading -= 6.2831855f;
    }
    if (heading <= -3.1415927f) {
        heading += 6.2831855f;
    }
    *angle = heading;
}
int CCharaPas::CheckEnd(void) {
    return (u8)(((u32)run > 0) ^ 1);
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
int CCharaPas::GetFrame(void) {
    return frame;
}
int scsPRDelay(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
    int frame_count;

    frame_count = owner->pr_cnt;
    if (frame_count >= node->frame) {
        owner->pr_cnt = 0;
        return 0;
    }
    owner->pr_cnt = frame_count + 1;
    return 1;
}
int scsSetPos(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
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
int scsSetRef(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
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
int scsAHDDelay(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
    int frame_count;

    frame_count = owner->ahd_cnt;
    if (frame_count >= node->frame) {
        owner->ahd_cnt = 0;
        return 0;
    }
    owner->ahd_cnt = frame_count + 1;
    return 1;
}
int scsSetAngle(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
    owner->pos[0] = owner->ref[0] + owner->dist * sinf(node->value);
    owner->pos[2] = owner->ref[2] + owner->dist * cosf(node->value);
    owner->angle = node->value;
    return 0;
}
int scsSetHeight(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
    owner->pos[1] = node->value + owner->ref[1];
    owner->height = node->value;
    return 0;
}
int scsSetDist(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
    owner->pos[0] = owner->ref[0] + node->value * sinf(owner->angle);
    owner->pos[2] = owner->ref[2] + node->value * cosf(owner->angle);
    owner->dist = node->value;
    return 0;
}
int scsSetAHD(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
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
int scsMove(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sceneseq", scsMove2__FP12_SEN_CMR_SEQP12CSceneCmrSeq);
int scsMoveRef(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
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
int scsMovePos(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
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
int scsMoveAHD(_SEN_CMR_SEQ *node, CSceneCmrSeq *owner) {
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
        owner->angle_spd = angle_delta / (float)node->frame;
        owner->height_spd = (node->vec0[1] - owner->height) / (float)node->frame;
        owner->dist_spd = (node->vec0[2] - owner->dist) / (float)node->frame;
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sceneseq", scsMoveAHD2__FP12_SEN_CMR_SEQP12CSceneCmrSeq);
int scsSetSyncObj(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
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
int scsReleaseSyncObj(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
    owner->sync = 0;
    owner->sync_obj = 0;
    owner->sync_mode = 0;
    mgZeroVector(owner->sync_ofs);
    owner->sync_angle = 0;
    owner->sync_height = 0;
    owner->sync_dist = 0;
    strcpy(owner->sync_frame, at_1527__2);
    return 0;
}
int scsAHDSlowing(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
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
int scsAHDKeep(_SEN_CMR_SEQ * sequence, CSceneCmrSeq * owner) {
    owner->ahd_keep = sequence;
    return SCENE_SEQ_NEXT;
}
int scsAHDReturn(_SEN_CMR_SEQ *sequence, CSceneCmrSeq *owner) {
    return SCENE_SEQ_RETURN;
}
int scsInitPas(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
    owner->pas.Initialize();
    return 0;
}
int scsSetPasFrm(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
    owner->pas.SetFrame(seq->frame);
    return 0;
}
int scsAddPas(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
    owner->pas.AddCameraPas(seq->vec0, seq->vec1);
    return 0;
}
int scsStartPas(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
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
int scsPRSlowing(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
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
int scsPRKeep(_SEN_CMR_SEQ * sequence, CSceneCmrSeq * owner) {
    owner->pr_keep = sequence;
    return SCENE_SEQ_NEXT;
}
int scsPRReturn(_SEN_CMR_SEQ *sequence, CSceneCmrSeq *owner) {
    return SCENE_SEQ_RETURN;
}
int scsFadeDelay(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
    int elapsed;

    elapsed = owner->fade_cnt;
    if (elapsed >= seq->frame) {
        owner->fade_cnt = 0;
        return 0;
    }
    owner->fade_cnt = elapsed + 1;
    return 1;
}
int scsFadeInit(_SEN_CMR_SEQ *sequence, CSceneCmrSeq *owner) {
    return SCENE_SEQ_NEXT;
}
int scsFadeIn(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
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
int scsFadeOut(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
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
int scsQuakeDelay(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
    int elapsed;

    elapsed = owner->quake_cnt;
    if (elapsed >= seq->frame) {
        owner->quake_cnt = 0;
        return 0;
    }
    owner->quake_cnt = elapsed + 1;
    return 1;
}
int scsQuake(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sceneseq", scsQuake2__FP12_SEN_CMR_SEQP12CSceneCmrSeq);
int scsCharaDelay(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
    int elapsed;

    elapsed = owner->chara_cnt;
    if (elapsed >= seq->frame) {
        owner->chara_cnt = 0;
        return 0;
    }
    owner->chara_cnt = elapsed + 1;
    return 1;
}
int scsCharaAttach(_SEN_CMR_SEQ *seq, CSceneCmrSeq *owner) {
    CCharacter2 *chara;
    float direction[4];
    float target[4];

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
int scsDummy(_SEN_CMR_SEQ *sequence, CSceneCmrSeq *owner) {
    return SCENE_SEQ_WAIT;
}
void InitSceneCmrSeq(_SEN_CMR_SEQ *seq) {
    seq->cmd = 0;
    mgZeroVector(seq->vec0);
    mgZeroVector(seq->vec1);
    seq->frame = 0;
    seq->mode = 0;
    seq->ease_rate = 0;
    strcpy(seq->name, at_1527__2);
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
    strcpy(sync_frame, at_1527__2);
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
int CSceneCmrSeq::CheckEnd(void) {
    if (pr_seq == 0) {
        if (ahd_seq == 0 && fade_seq == 0 && quake_seq == 0) {
            return 1;
        }
    }
    return 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sceneseq", Play__12CSceneCmrSeqFv);
_SEN_CMR_SEQ *CSceneCmrSeq::SearchSeq() {
    _SEN_CMR_SEQ *node = seq_tbl;
    int i;

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
void CSceneCmrSeq::InitPas(void) {
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
void CSceneCmrSeq::StartPas(void) {
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
void CSceneCmrSeq::PRKeep(void) {
    _SEN_CMR_SEQ *command = SearchNextPrSeq();
    if (command != NULL) {
        command->cmd = SCENE_CMR_CMD_PR_KEEP;
    }
}
void CSceneCmrSeq::PRReturn(void) {
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
            strcpy(node->name, at_1527__2);
        }
    }
}
void CSceneCmrSeq::ReleaseSyncObj(void) {
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
void CSceneCmrSeq::AHDKeep(void) {
    _SEN_CMR_SEQ *command = SearchNextAhdSeq();
    if (command != NULL) {
        command->cmd = SCENE_CMR_CMD_AHD_KEEP;
    }
}
void CSceneCmrSeq::AHDReturn(void) {
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
void CSceneCmrSeq::FadeInit(void) {
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
int scsPosDelay(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    int elapsed;

    elapsed = owner->pos_cnt;
    if (elapsed >= seq->frame) {
        owner->pos_cnt = 0;
        return 0;
    }
    owner->pos_cnt = elapsed + 1;
    return 1;
}
int scsSetPos(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    sceVu0CopyVector(owner->pos, seq->vec);
    return 0;
}
int scsMove(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
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
                    CCPoly polys[128];
                    float from[4];
                    float to[4];
                    float hit[4];
                    int count;

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
                CCPoly polys[128];
                float from[4];
                float to[4];
                float hit[4];
                int count;

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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sceneseq", scsMove2__FP12_SEN_OBJ_SEQP12CSceneObjSeq);
int scsInitPas(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    owner->pas.Initialize();
    return 0;
}
int scsSetPasFrm(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    owner->pas.SetFrame(seq->frame);
    return 0;
}
int scsAddPas(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    owner->pas.AddCharaPas(seq->vec);
    return 0;
}
int scsStartPas(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    float previous_pos[4];
    mgVu0FBOX box;
    CCPoly polys[128];
    float from[4];
    float to[4];
    float hit[4];
    int count;

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
int scsJump(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
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
    CalcPosParabolicJump(owner->pos, owner->jump_start, owner->jump_end, seq->value, (float)seq->sub_frame,
                         (float)owner->pos_cnt);
    return 1;
}
int scsSetEohFramePos(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
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
int scsAddPos(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
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
int scsAttachCamera(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    mgCCamera *camera;
    float camera_pos[4];
    float camera_ref[4];
    float direction[4];
    float target[4];

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
int scsResetDAPosition(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    EventObjHandleMother.SetPos(owner->eoh_no, owner->pos[0], owner->pos[1], owner->pos[2]);
    EventObjHandleMother.SetRot(owner->eoh_no, owner->rot[0], owner->rot[1], owner->rot[2]);
    EventObjHandleMother.UpdatePosition(owner->eoh_no);
    EventObjHandleMother.ResetDAPosition(owner->eoh_no);
    return 0;
}
int scsRotDelay(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    int elapsed;

    elapsed = owner->rot_cnt;
    if (elapsed >= seq->frame) {
        owner->rot_cnt = 0;
        return 0;
    }
    owner->rot_cnt = elapsed + 1;
    return 1;
}
int scsSetRot(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    sceVu0CopyVector(owner->rot, seq->vec);
    return 0;
}
int scsRotation(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    int i;
    int j;
    int k;
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
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sceneseq", scsRotation2__FP12_SEN_OBJ_SEQP12CSceneObjSeq);
int scsReference(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
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
int scsMotionDelay(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    int elapsed;

    elapsed = owner->mot_cnt;
    if (elapsed >= seq->frame) {
        owner->mot_cnt = 0;
        return 0;
    }
    owner->mot_cnt = elapsed + 1;
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sceneseq", scsSetMotion__FP12_SEN_OBJ_SEQP12CSceneObjSeq);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/sceneseq", scsNextMotion__FP12_SEN_OBJ_SEQP12CSceneObjSeq);
int scsMotionWait(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    return (EventObjHandleMother.CheckMotionEnd(owner->eoh_no) != 0) ^ 1;
}
int scsMotionTrg(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    EventObjHandleMother.SetMotionTrg(owner->eoh_no);
    return 0;
}
int scsSetMotStep(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    EventObjHandleMother.SetStep(owner->eoh_no, seq->value);
    return 0;
}
int scsSetMotChangeStep(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    EventObjHandleMother.SetChangeStep(owner->eoh_no, seq->value);
    return 0;
}
int scsResetMotion(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    EventObjHandleMother.ResetMotion(owner->eoh_no);
    return 0;
}
int scsSetMotionNowTime(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    EventObjHandleMother.SetMotionNowTime(owner->eoh_no, seq->value);
    return 0;
}
int scsSetMotionWaitTime(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    EventObjHandleMother.SetMotionWaitTime(owner->eoh_no, seq->value);
    return 0;
}
int scsNormalDrive(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    EventObjHandleMother.NormalDrive(owner->eoh_no);
    return 0;
}
int scsMotionTrgWait(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    return (EventObjHandleMother.GetSeqStatus(owner->eoh_no) == 3) ^ 1;
}
int scsTexAnimeDelay(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    int elapsed;

    elapsed = owner->anm_cnt;
    if (elapsed >= seq->frame) {
        owner->anm_cnt = 0;
        return 0;
        }
    owner->anm_cnt = elapsed + 1;
    return 1;
}
int scsTexAnime(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    if (strcmp(seq->name, at_1527__2) == 0) {
        EventObjHandleMother.SetTexAnim(owner->eoh_no, seq->frame, NULL);
    } else {
        EventObjHandleMother.SetTexAnim(owner->eoh_no, seq->frame, seq->name);
    }
    return 0;
}
int scsColorDelay(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    int elapsed;

    elapsed = owner->col_cnt;
    if (elapsed >= seq->frame) {
        owner->col_cnt = 0;
        return 0;
            }
    owner->col_cnt = elapsed + 1;
    return 1;
}
int scsSetColor(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
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
int scsScaleDelay(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    int elapsed;

    elapsed = owner->scale_cnt;
    if (elapsed >= seq->frame) {
        owner->scale_cnt = 0;
        return 0;
    }
    owner->scale_cnt = elapsed + 1;
    return 1;
}
int scsSetScale(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
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
int scsSeDelay(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    int elapsed;

    elapsed = owner->se_cnt;
    if (elapsed >= seq->frame) {
        owner->se_cnt = 0;
        return 0;
    }
    owner->se_cnt = elapsed + 1;
    return 1;
}
int scsSePlay(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    sndSePlay(seq->no, seq->se_no, 0);
    return 0;
}
int scsDummy(_SEN_OBJ_SEQ *seq, CSceneObjSeq *owner) {
    return 1;
}
void InitSceneObjSeq(_SEN_OBJ_SEQ *seq) {
    seq->cmd = 0;
    mgZeroVector(seq->vec);
    seq->frame = 0;
    seq->mode = 0;
    seq->ease_rate = 0;
    strcpy(seq->name, at_1527__2);
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
    int i;

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
int CSceneObjSeq::CheckEnd(void) {
    if (pos_seq == 0) {
        if (rot_seq == 0 && mot_seq == 0 && anm_seq == 0 && col_seq == 0 && scale_seq == 0 && se_seq == 0) {
            return 1;
        }
    }
    return 0;
}
void CSceneObjSeq::Play() {
    _SEN_OBJ_SEQ *node;
    int lane;
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
void CSceneObjSeq::InitPas(void) {
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
void CSceneObjSeq::MotionWait(void) {
    _SEN_OBJ_SEQ *command = SearchNextMotSeq();
    if (command != NULL) {
        command->cmd = SCENE_OBJ_CMD_MOTION_WAIT;
    }
}
void CSceneObjSeq::SetMotionTrg(void) {
    _SEN_OBJ_SEQ *command = SearchNextMotSeq();
    if (command != NULL) {
        command->cmd = SCENE_OBJ_CMD_MOTION_TRG;
    }
}
void CSceneObjSeq::MotionTrgWait(void) {
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
void CSceneObjSeq::ResetMotion(void) {
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
void CSceneObjSeq::NormalDrive(void) {
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
            strcpy(node->name, at_1527__2);
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
void CSceneObjSeq::ResetDAPosition(void) {
    _SEN_OBJ_SEQ *command = SearchNextSeSeq();
    if (command != NULL) {
        command->cmd = SCENE_OBJ_CMD_RESET_DA_POSITION;
    }
    _SEN_OBJ_SEQ *motion_command = SearchNextMotSeq();
    if (motion_command != NULL) {
        motion_command->cmd = SCENE_OBJ_CMD_RESET_DA_POSITION;
    }
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sceneseq", ScsCmrSeqCallTbl__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sceneseq", ScsObjSeqCallTbl__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sceneseq", at_1527__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/sceneseq", at_2863__DATA);
