#include "common.h"

#include <libvu0.h>

#include <cstring>

#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"

extern u_char              at_1118[];
extern u_char              at_1119[];

static mgCFrameAttr dmy_attr;

// Code (.text)
void mgCFrameAttr::Initialize() {
    memset(this, 0, sizeof(mgCFrameAttr));
    mgCVisualAttr::Initialize();
    color[0] = color[1] = color[2] = color[3] = 128.0f;
    alpha_ref = -1;
    draw = MG_FRAME_DRAW_VISIBLE;
    z_write = MG_ZBUF_WRITE;
    unk_3c = 0;
    unk_20 = 100.0f;
    fog = 1;
    obj_alpha = 1.0f;
    point_light = 1;
    unk_50[3] = 0.0f;
    unk_50[2] = 0.0f;
    unk_50[0] = 0.0f;
    unk_50[1] = 1.0f;
    depth_bias = 0.0f;
    unk_84 = 0;
}

/**
 *
 * Builds a rotation matrix from a quaternion whose scalar part comes first.
 *
 */
mgCFrameAttr::mgCFrameAttr() {
    Initialize();
}

static void QuatToMat(float *quaternion, float (*matrix)[4]) {
    float yy;
    float zz;
    float ww;
    float y;
    float xy;
    float z;
    float xz;
    float zw;
    float xw;
    float yz;
    float yw;
    float x;
    float w;
    y = quaternion[1];
    z = quaternion[2];
    w = quaternion[3];
    x = quaternion[0];
    yz = y * z;
    zz = z * z;
    zw = z * w;
    xz = x * z;
    xy = x * y;
    yy = y * y;
    yw = y * w;
    ww = w * w;
    xw = x * w;
    matrix[0][0] = 1.0f - (2.0f * (zz + ww));
    matrix[0][1] = 2.0f * (yz - xw);
    matrix[0][2] = 2.0f * (yw + xz);
    matrix[0][3] = 0.0f;
    matrix[1][0] = 2.0f * (yz + xw);
    matrix[1][1] = 1.0f - (2.0f * (yy + ww));
    matrix[1][2] = 2.0f * (zw - xy);
    matrix[1][3] = 0.0f;
    matrix[2][0] = 2.0f * (yw - xz);
    matrix[2][1] = 2.0f * (zw + xy);
    matrix[2][2] = 1.0f - (2.0f * (yy + zz));
    matrix[2][3] = 0.0f;
    matrix[3][0] = 0.0f;
    matrix[3][1] = 0.0f;
    matrix[3][2] = 0.0f;
    matrix[3][3] = 1.0f;
}

/**
 *
 * Transforms eight corners by the product of two matrices, leaving the results in VU0
 * registers vf10-vf17, and gets the box around them.
 *
 */
#ifdef NONMATCHING
static float projected_corners[8][4];

void test1(float (*corners)[4], float (*screen)[4], float (*matrix)[4], float *out_max,
           float *out_min) {
    float combined[4][4];
    for (int column = 0; column < 4; column++) {
        for (int row = 0; row < 4; row++) {
            combined[column][row] = screen[0][row] * matrix[column][0] +
                                    screen[1][row] * matrix[column][1] +
                                    screen[2][row] * matrix[column][2] +
                                    screen[3][row] * matrix[column][3];
        }
    }

    for (int corner = 0; corner < 8; corner++) {
        for (int row = 0; row < 4; row++) {
            float value = combined[0][row] * corners[corner][0] +
                          combined[1][row] * corners[corner][1] +
                          combined[2][row] * corners[corner][2] +
                          combined[3][row] * corners[corner][3];
            projected_corners[corner][row] = value;
            if (corner == 0) {
                out_max[row] = value;
                out_min[row] = value;
            } else {
                if (value > out_max[row]) {
                    out_max[row] = value;
                }
                if (value < out_min[row]) {
                    out_min[row] = value;
                }
            }
        }
    }
}
#else
asm void test1(float (*corners)[4], float (*left)[4], float (*right)[4], float *out_max, float *out_min) {
    lqc2    vf11, 0(a1)
    lqc2    vf12, 16(a1)
    lqc2    vf13, 32(a1)
    lqc2    vf14, 48(a1)
    lqc2    vf5, 0(a2)
    lqc2    vf6, 16(a2)
    lqc2    vf7, 32(a2)
    lqc2    vf8, 48(a2)
    vmulax  ACC, vf11, vf5
    vmadday ACC, vf12, vf5
    vmaddaz ACC, vf13, vf5
    vmaddw  vf1, vf14, vf5
    vmulax  ACC, vf11, vf6
    vmadday ACC, vf12, vf6
    vmaddaz ACC, vf13, vf6
    vmaddw  vf2, vf14, vf6
    vmulax  ACC, vf11, vf7
    vmadday ACC, vf12, vf7
    vmaddaz ACC, vf13, vf7
    vmaddw  vf3, vf14, vf7
    vmulax  ACC, vf11, vf8
    vmadday ACC, vf12, vf8
    vmaddaz ACC, vf13, vf8
    vmaddw  vf4, vf14, vf8
    lqc2    vf10, 0(a0)
    lqc2    vf11, 16(a0)
    lqc2    vf12, 32(a0)
    lqc2    vf13, 48(a0)
    lqc2    vf14, 64(a0)
    lqc2    vf15, 80(a0)
    lqc2    vf16, 96(a0)
    lqc2    vf17, 112(a0)
    vmulax  ACC, vf1, vf10
    vmadday ACC, vf2, vf10
    vmaddaz ACC, vf3, vf10
    vmaddw  vf10, vf4, vf10
    vmulax  ACC, vf1, vf11
    vmadday ACC, vf2, vf11
    vmaddaz ACC, vf3, vf11
    vmaddw  vf11, vf4, vf11
    vmulax  ACC, vf1, vf12
    vmadday ACC, vf2, vf12
    vmaddaz ACC, vf3, vf12
    vmaddw  vf12, vf4, vf12
    vmax    vf18, vf10, vf11
    vmini   vf19, vf10, vf11
    vmulax  ACC, vf1, vf13
    vmadday ACC, vf2, vf13
    vmaddaz ACC, vf3, vf13
    vmaddw  vf13, vf4, vf13
    vmax    vf18, vf18, vf12
    vmini   vf19, vf19, vf12
    vmulax  ACC, vf1, vf14
    vmadday ACC, vf2, vf14
    vmaddaz ACC, vf3, vf14
    vmaddw  vf14, vf4, vf14
    vmax    vf18, vf18, vf13
    vmini   vf19, vf19, vf13
    vmulax  ACC, vf1, vf15
    vmadday ACC, vf2, vf15
    vmaddaz ACC, vf3, vf15
    vmaddw  vf15, vf4, vf15
    vmax    vf18, vf18, vf14
    vmini   vf19, vf19, vf14
    vmulax  ACC, vf1, vf16
    vmadday ACC, vf2, vf16
    vmaddaz ACC, vf3, vf16
    vmaddw  vf16, vf4, vf16
    vmax    vf18, vf18, vf15
    vmini   vf19, vf19, vf15
    vmulax  ACC, vf1, vf17
    vmadday ACC, vf2, vf17
    vmaddaz ACC, vf3, vf17
    vmaddw  vf17, vf4, vf17
    vmax    vf18, vf18, vf16
    vmini   vf19, vf19, vf16
    vmax    vf18, vf18, vf17
    vmini   vf19, vf19, vf17
    sqc2    vf18, 0(a3)
    jr      ra
    sqc2    vf19, 0(t0)
}
#endif
void test1(float (*corners)[4], float (*screen)[4], float (*matrix)[4], float *out_max,
           float *out_min);
// clang-format on
// clang-format off
/**
 *
 * Divides the eight corners that test1 left in vf10-vf17 through by their depth and gets
 * the screen-space box around them.
 *
 */
#ifdef NONMATCHING
void test2(float *out_max, float *out_min) {
    for (int corner = 0; corner < 8; corner++) {
        float depth = projected_corners[corner][3];
        if (depth < 0.0f) {
            depth = -depth;
        }
        float x = projected_corners[corner][0] / depth;
        float y = projected_corners[corner][1] / depth;
        if (corner == 0) {
            out_max[0] = out_min[0] = x;
            out_max[1] = out_min[1] = y;
            out_max[2] = out_min[2] = projected_corners[corner][2];
            out_max[3] = out_min[3] = projected_corners[corner][3];
        } else {
            float values[4] = {x, y, projected_corners[corner][2], projected_corners[corner][3]};
            for (int axis = 0; axis < 4; axis++) {
                if (values[axis] > out_max[axis]) {
                    out_max[axis] = values[axis];
                }
                if (values[axis] < out_min[axis]) {
                    out_min[axis] = values[axis];
                }
            }
        }
    }
}
#else
asm void test2(float *out_max, float *out_min) {
    vabs.w  vf20, vf10
    vabs.w  vf21, vf11
    vabs.w  vf22, vf12
    vabs.w  vf23, vf13
    vabs.w  vf24, vf14
    vabs.w  vf25, vf15
    vabs.w  vf26, vf16
    vabs.w  vf27, vf17
    vdiv    Q, vf0w, vf20w
    vwaitq
    vmulq.xy vf10, vf10, Q
    vdiv    Q, vf0w, vf21w
    vwaitq
    vmulq.xy vf11, vf11, Q
    vdiv    Q, vf0w, vf22w
    vmax    vf1, vf10, vf11
    vmini   vf2, vf10, vf11
    vwaitq
    vmulq.xy vf12, vf12, Q
    vdiv    Q, vf0w, vf23w
    vwaitq
    vmulq.xy vf13, vf13, Q
    vdiv    Q, vf0w, vf24w
    vmax    vf3, vf12, vf13
    vmini   vf4, vf12, vf13
    vwaitq
    vmulq.xy vf14, vf14, Q
    vdiv    Q, vf0w, vf25w
    vwaitq
    vmulq.xy vf15, vf15, Q
    vdiv    Q, vf0w, vf26w
    vmax    vf5, vf14, vf15
    vmini   vf6, vf14, vf15
    vwaitq
    vmulq.xy vf16, vf16, Q
    vdiv    Q, vf0w, vf27w
    vwaitq
    vmulq.xy vf17, vf17, Q
    vmax    vf10, vf1, vf3
    vmini   vf11, vf2, vf4
    vmax    vf7, vf16, vf17
    vmini   vf8, vf16, vf17
    vmax    vf12, vf5, vf7
    vmini   vf13, vf6, vf8
    vmax    vf14, vf10, vf12
    vmini   vf15, vf11, vf13
    sqc2    vf14, 0(a0)
    jr      ra
    sqc2    vf15, 0(a1)
}
#endif
void test2(float *out_max, float *out_min);
// clang-format on

int mgInsideScreen(mgVu0FBOX *box) {
    sceVu0FMATRIX matrix;
    sceVu0FVECTOR corners[8];

    mgUnitMatrix(matrix);
    mgCreateBox8(corners, box->max, box->min);
    return mgInsideScreen(corners, matrix);
}

int mgInsideScreen(mgVu0FBOX *box, float (*matrix)[4]) {
    sceVu0FVECTOR corners[8];

    mgCreateBox8(corners, box->max, box->min);
    return mgInsideScreen(corners, matrix);
}

#pragma global_optimizer off

int mgInsideScreen(mgVu0FBOX *box, float (*matrix)[4], float *out_max, float *out_min) {
    sceVu0FVECTOR corners[8];
    mgCreateBox8(corners, box->max, box->min);
    return mgInsideScreen(corners, matrix, out_max, out_min);
}

#pragma global_optimizer reset

int mgInsideScreen(float (*corners)[4], float (*matrix)[4]) {
    sceVu0FVECTOR max;
    sceVu0FVECTOR min;

    return mgInsideScreen(corners, matrix, max, min);
}

#pragma global_optimizer off
int mgInsideScreen(float (*corners)[4], float (*matrix)[4], float *out_max, float *out_min) {
    mgRENDER_INFO *render_info = &mgRenderInfo;
    register float *screen = &render_info->world_screen_rel[0][0];
    register float *m = &matrix[0][0];
    register float *in = &corners[0][0];
    register float *hi = out_max;
    register float *lo = out_min;

    // Each corner goes through the screen transform and is divided through by the magnitude
    // of its w, with each division overlapped with the next corner's transform.
    asm {
        lqc2    vf11, 0(screen)
        lqc2    vf12, 16(screen)
        lqc2    vf13, 32(screen)
        lqc2    vf14, 48(screen)
        lqc2    vf5, 0(m)
        lqc2    vf6, 16(m)
        lqc2    vf7, 32(m)
        lqc2    vf8, 48(m)
        vmulax  ACC, vf11, vf5
        vmadday ACC, vf12, vf5
        vmaddaz ACC, vf13, vf5
        vmaddw  vf1, vf14, vf5
        vmulax  ACC, vf11, vf6
        vmadday ACC, vf12, vf6
        vmaddaz ACC, vf13, vf6
        vmaddw  vf2, vf14, vf6
        vmulax  ACC, vf11, vf7
        vmadday ACC, vf12, vf7
        vmaddaz ACC, vf13, vf7
        vmaddw  vf3, vf14, vf7
        vmulax  ACC, vf11, vf8
        vmadday ACC, vf12, vf8
        vmaddaz ACC, vf13, vf8
        vmaddw  vf4, vf14, vf8
        lqc2    vf10, 0(in)
        lqc2    vf11, 16(in)
        lqc2    vf12, 32(in)
        lqc2    vf13, 48(in)
        lqc2    vf14, 64(in)
        lqc2    vf15, 80(in)
        lqc2    vf16, 96(in)
        lqc2    vf17, 112(in)
        vmulax  ACC, vf1, vf10
        vmadday ACC, vf2, vf10
        vmaddaz ACC, vf3, vf10
        vmaddw  vf10, vf4, vf10
        vmulax  ACC, vf1, vf11
        vmadday ACC, vf2, vf11
        vmaddaz ACC, vf3, vf11
        vabs.w  vf20, vf10
        vmaddw  vf11, vf4, vf11
        vdiv    Q, vf0w, vf20w
        vabs.w  vf21, vf11
        vwaitq
        vmulq.xy vf10, vf10, Q
        vdiv    Q, vf0w, vf21w
        vmulax  ACC, vf1, vf12
        vmadday ACC, vf2, vf12
        vmaddaz ACC, vf3, vf12
        vmaddw  vf12, vf4, vf12
        vmulax  ACC, vf1, vf13
        vwaitq
        vmulq.xy vf11, vf11, Q
        vabs.w  vf22, vf12
        vmadday ACC, vf2, vf13
        vmaddaz ACC, vf3, vf13
        vmaddw  vf13, vf4, vf13
        vdiv    Q, vf0w, vf22w
        vmulax  ACC, vf1, vf14
        vmadday ACC, vf2, vf14
        vabs.w  vf23, vf13
        vmaddaz ACC, vf3, vf14
        vmaddw  vf14, vf4, vf14
        vmax    vf30, vf10, vf11
        vmini   vf31, vf10, vf11
        vmulq.xy vf12, vf12, Q
        vdiv    Q, vf0w, vf23w
        vabs.w  vf24, vf14
        vmulax  ACC, vf1, vf15
        vmadday ACC, vf2, vf15
        vmaddaz ACC, vf3, vf15
        vmaddw  vf15, vf4, vf15
        vmax    vf30, vf30, vf12
        vmini   vf31, vf31, vf12
        vmulq.xy vf13, vf13, Q
        vdiv    Q, vf0w, vf24w
        vabs.w  vf25, vf15
        vmulax  ACC, vf1, vf16
        vmadday ACC, vf2, vf16
        vmaddaz ACC, vf3, vf16
        vmaddw  vf16, vf4, vf16
        vmax    vf30, vf30, vf13
        vmini   vf31, vf31, vf13
        vmulq.xy vf14, vf14, Q
        vdiv    Q, vf0w, vf25w
        vabs.w  vf26, vf16
        vmulax  ACC, vf1, vf17
        vmadday ACC, vf2, vf17
        vmaddaz ACC, vf3, vf17
        vmaddw  vf17, vf4, vf17
        vmax    vf30, vf30, vf14
        vmini   vf31, vf31, vf14
        vmulq.xy vf15, vf15, Q
        vdiv    Q, vf0w, vf26w
        vabs.w  vf27, vf17
        vnop
        vmax    vf30, vf30, vf15
        vmini   vf31, vf31, vf15
        vnop
        vwaitq
        vmulq.xy vf16, vf16, Q
        vdiv    Q, vf0w, vf27w
        vnop
        vmax    vf30, vf30, vf16
        vmini   vf31, vf31, vf16
        vnop
        vnop
        vwaitq
        vmulq.xy vf17, vf17, Q
        vmax    vf30, vf30, vf17
        vmini   vf31, vf31, vf17
        sqc2    vf30, 0(hi)
        sqc2    vf31, 0(lo)
    }

    return mgClipBoxW(out_max, out_min, render_info->screen_box_max, render_info->screen_box_min);
}
#pragma global_optimizer reset

void mgCObject::SetPosition(float *position) {
    if (this->position[0] != position[0] || this->position[1] != position[1] ||
        this->position[2] != position[2]) {
        use_srt = 1;
        sceVu0CopyVector(this->position, position);
        this->position[3] = 1.0f;
        changed = 1;
    }
}

void mgCObject::SetPosition(float x, float y, float z) {
    float position[4] = {0.0f, 0.0f, 0.0f, 1.0f};
    position[0] = x;
    position[1] = y;
    position[2] = z;

    mgCObject::SetPosition(position);
}

void mgCObject::GetPosition(float *out_position) {
    sceVu0CopyVector(out_position, position);
}

void mgCObject::SetRotation(float *rotation) {
    if (this->rotation[0] != rotation[0] || this->rotation[1] != rotation[1] ||
        this->rotation[2] != rotation[2]) {
        use_srt = 1;
        changed = 1;
        sceVu0CopyVector(this->rotation, rotation);
        this->rotation[3] = 0.0f;
    }
}

void mgCObject::SetRotation(float x, float y, float z) {
    float rotation[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    rotation[0] = x;
    rotation[1] = y;
    rotation[2] = z;

    mgCObject::SetRotation(rotation);
}

void mgCObject::GetRotation(float *out_rotation) {
    sceVu0CopyVector(out_rotation, rotation);
}

void mgCObject::SetScale(float *scale) {
    if (this->scale[0] != scale[0] || this->scale[1] != scale[1] || this->scale[2] != scale[2]) {
        use_srt = 1;
        this->scale[0] = scale[0];
        this->scale[1] = scale[1];
        this->scale[2] = scale[2];
        changed = 1;
        this->scale[3] = 0.0f;
    }
}

void mgCObject::SetScale(float x, float y, float z) {
    float scale[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    scale[0] = x;
    scale[1] = y;
    scale[2] = z;

    mgCObject::SetScale(scale);
}

void mgCObject::GetScale(float *out_scale) {
    sceVu0CopyVector(out_scale, scale);
}

void mgCObject::Initialize() {
    SetPosition(0.0f, 0.0f, 0.0f);
    SetRotation(0.0f, 0.0f, 0.0f);
    SetScale(1.0f, 1.0f, 1.0f);
    changed = 1;
    use_srt = 0;
}

mgCFrame::mgCFrame() {
    Initialize();
}

// Defined inline in mg_frame.hpp.
void mgCFrame::Initialize() {
    elder = NULL;
    brother = NULL;
    child = NULL;
    parent = NULL;
    sceVu0UnitMatrix(lw_matrix);
    sceVu0UnitMatrix(trans_matrix);
    name = NULL;
    rot_type = 0;
    reference = 0;
    visual = NULL;
    attr = NULL;
    frame_num = 0;
    frame_list = NULL;
    init_matrix = NULL;
    bound = NULL;
    mgCObject::Initialize();
}

void mgCFrame::SetName(char *name) {
    this->name = name;
}

void mgCFrame::SetTransMatrix(float *quaternion) {
    float saved_row[4];
    changed = 1;
    *(u_long128 *) saved_row = *(u_long128 *) trans_matrix[3];
    QuatToMat(quaternion, trans_matrix);
    *(u_long128 *) trans_matrix[3] = *(u_long128 *) saved_row;
}

void mgCFrame::SetBBox(float *max, float *min) {
    if (bound != 0) {
        sceVu0CopyVector(bound->max, max);
        sceVu0CopyVector(bound->min, min);

        float *extremes[4];
        extremes[0] = bound->min;
        extremes[1] = bound->max;

        for (s32 i = 0; i < 8; i++) {
            bound->corner[i][3] = 1.0f;
            bound->corner[i][0] = extremes[(i & 1) != 0][0];
            bound->corner[i][1] = extremes[(i & 2) != 0][1];
            bound->corner[i][2] = extremes[(i & 4) != 0][2];
        }
    }
}

void mgCFrame::GetBBox(float *out_max, float *out_min) {
    if (bound == NULL) {
        mgZeroVectorW(out_max);
        mgZeroVectorW(out_min);
    } else {
        sceVu0CopyVector(out_max, bound->max);
        sceVu0CopyVector(out_min, bound->min);
    }
}

void mgCFrame::SetBSphere(float *center, float radius) {
    if (bound != NULL) {
        sceVu0CopyVector(bound->center, center);
        bound->radius = radius;
    }
}

mgCFrame *mgCFrame::GetFrame(int index) {
    if (index < 0 || index > this->frame_num || this->frame_list == 0) {
        return 0;
    }

    return this->frame_list[index];
}

int mgCFrame::RemakeBBox(float *out_max, float *out_min) {
    float      matrix[4][4];
    mgCVisual *frame_visual = visual;

    if (frame_visual == 0) {
        return 0;
    }

    GetLWMatrix(matrix);

    if (frame_visual->CreateBBox(out_max, out_min, matrix) != 0) {
        SetBBox(out_max, out_min);
        return 1;
    }

    return 0;
}

int mgCFrame::GetWorldBBox(mgVu0FBOX *box) {
    mgVu0FBOX world_box;
    float     matrix[4][4];
    float     center[4];

    struct {
        float x;
        float y;
        float z;
        u_int w;
    } half;

    mgVu0FBOX child_box;
    s32       found = 0;

    if (visual != 0 && bound != 0) {
        found = 1;
        GetLWMatrix(matrix);

        mgApplyMatrix(world_box.max, world_box.min, matrix, bound->max, bound->min);

        if (attr != 0 && attr->billboard != 0) {
            float extent;
            sceVu0AddVector(center, world_box.max, world_box.min);
            sceVu0ScaleVector(center, center, 0.5f);
            sceVu0SubVector(&half.x, world_box.max, center);

            if (half.x > half.y) {
                extent = half.x > half.z ? half.x : half.z;
            } else {
                extent = half.y > half.z ? half.y : half.z;
            }

            half.z = extent;
            half.y = extent;
            half.x = extent;
            half.w = 0;
            sceVu0AddVector(world_box.max, center, &half.x);
            sceVu0SubVector(world_box.min, center, &half.x);
        }
    }

    for (mgCFrame *node = child; node != 0; node = node->brother) {
        if (node->GetWorldBBox(&child_box) != 0) {
            if (found == 0) {
                world_box = child_box;
            } else {
                mgVectorMaxMin(world_box.max, world_box.min, world_box.max, world_box.min, child_box.max,
                               child_box.min);
            }

            found = 1;
        }
    }

    *box = world_box;
    return found;
}

#pragma global_optimizer reset

int mgCFrame::GetFrameNum() {
    s32       count;
    mgCFrame *node;
    s32       child_count;

    node = child;
    count = 1;

    if (node != NULL) {
        do {
            child_count = node->GetFrameNum();
            node = node->brother;
            count += child_count;
        } while (node != NULL);
    }

    return count;
}

void mgCFrame::SetParent(mgCFrame *parent) {
    if (this->parent == NULL) {
        this->parent = parent;

        if (parent != NULL) {
            parent->SetChild(this);
        }
    }
}

void mgCFrame::SetBrother(mgCFrame *new_brother) {
    if (new_brother != 0) {
        mgCFrame *next = brother;

        if (next != 0) {
            next->SetBrother(new_brother);
        } else {
            brother = new_brother;
            brother->elder = this;
        }
    }
}

void mgCFrame::SetChild(mgCFrame *new_child) {
    mgCFrame *first;

    if (new_child != NULL) {
        first = child;

        if (first != NULL) {
            first->SetBrother(new_child);
        } else {
            child = new_child;
        }

        new_child->parent = this;
    }
}

void mgCFrame::DeleteParent() {
    if (parent != NULL) {
        if (parent->child == this) {
            parent->child = brother;
            parent = NULL;

            if (brother != NULL) {
                brother->elder = NULL;
            }

            brother = NULL;
            elder = NULL;
        } else {
            parent = NULL;

            if (elder != NULL) {
                elder->brother = brother;
            }

            brother = NULL;
            elder = NULL;
        }
    }
}

void mgCFrame::SetReference(mgCFrame *reference) {
    if (parent == NULL && reference != NULL) {
        parent = reference;
        this->reference = 1;
        changed = 1;
    }
}

void mgCFrame::DeleteReference() {
    parent = NULL;
    reference = 0;
    changed = 1;
}

#pragma global_optimizer off

void mgCFrame::ClearChildFlag() {
    mgCFrame *frame;
    int       flag = 1;

    if (child != NULL) {
        child->changed = flag;
        frame = child;

        if (frame->brother != NULL) {
            mgCFrame *next;

            while ((next = frame->brother) != NULL) {
                next->changed = flag;
                frame = frame->brother;
            }

            return;
        }
    }
}

#pragma global_optimizer reset
#pragma schedule reset

#pragma global_optimizer off
void mgCFrame::GetLocalMatrix(float (*matrix)[4]) {
    if (use_srt) {
        float (*destination)[4] = matrix;
        asm {
            addiu v1, this, 0xB0
            addiu v0, this, 0x30
            lqc2 vf10, 0(v0)
            lqc2 vf1, 0(v1)
            lqc2 vf2, 16(v1)
            lqc2 vf3, 32(v1)
            lqc2 vf4, 48(v1)
            vmul.xyzw vf1, vf1, vf10
            vmul.xyzw vf2, vf2, vf10
            vmul.xyzw vf3, vf3, vf10
            vmulw.xyzw vf4, vf4, vf0w
            sqc2 vf1, 0(destination)
            sqc2 vf2, 16(destination)
            sqc2 vf3, 32(destination)
            sqc2 vf4, 48(destination)
        }
        sceVu0FVECTOR translation;
        if (rot_type & MG_FRAME_ROT_LOCAL_ORIGIN) {
            sceVu0CopyVector(translation, matrix[3]);
            mgZeroVectorW(matrix[3]);
        }
        if (rot_type & MG_FRAME_ROT_APPLY) {
            if (rotation[0] != 0.0f) {
                sceVu0RotMatrixX(matrix, matrix, rotation[0]);
            }
            if (rotation[1] != 0.0f) {
                sceVu0RotMatrixY(matrix, matrix, rotation[1]);
            }
            if (rotation[2] != 0.0f) {
                sceVu0RotMatrixZ(matrix, matrix, rotation[2]);
            }
        }
        if (rot_type & MG_FRAME_ROT_LOCAL_ORIGIN) {
            sceVu0AddVector(matrix[3], translation, position);
            matrix[3][3] = 1.0f;
        } else {
            sceVu0AddVector(matrix[3], matrix[3], position);
            matrix[3][3] = 1.0f;
        }
    } else {
        sceVu0CopyMatrix(matrix, trans_matrix);
    }
}
#pragma global_optimizer reset

#pragma global_optimizer off
void mgCFrame::GetBBoardMatrix(int mode, float (*matrix)[4], mgRENDER_INFO *info) {
    float position[4];
    float toEye[4];
    float scale[4];
    float world[4][4];
    float pitch[4][4];
    GetLWMatrix(world);
    scale[0] = mgDistVector(world[0]);
    scale[1] = mgDistVector(world[0]);
    scale[2] = mgDistVector(world[0]);
    *reinterpret_cast<u_long128 *>(position) = *reinterpret_cast<u_long128 *>(world[3]);
    sceVu0UnitMatrix(matrix);
    if (mode & 2) {
        sceVu0SubVector(matrix[2], info->camera_pos, position);
        matrix[2][1] = 0.0f;
        matrix[2][3] = 0.0f;
        sceVu0Normalize(matrix[2], matrix[2]);
        matrix[0][0] = matrix[2][2];
        matrix[0][2] = -matrix[2][0];
        matrix[2][0] = matrix[2][0];
        matrix[2][2] = matrix[2][2];
    }
    if (mode & 1) {
        sceVu0UnitMatrix(pitch);
        sceVu0SubVector(toEye, info->camera_pos, position);
        sceVu0Normalize(toEye, toEye);
        float eyeY = toEye[1];
        toEye[3] = 0.0f;
        toEye[1] = 0.0f;
        float horizontal = mgDistVector(toEye);
        pitch[1][1] = horizontal;
        pitch[2][2] = horizontal;
        pitch[1][2] = -eyeY;
        pitch[2][1] = eyeY;
        sceVu0SubVector(matrix[2], info->camera_pos, position);
        matrix[2][1] = 0.0f;
        matrix[2][3] = 0.0f;
        sceVu0Normalize(matrix[2], matrix[2]);
        matrix[0][0] = matrix[2][2];
        matrix[0][2] = -matrix[2][0];
        mgMulMatrix(matrix, matrix, pitch);
    }
    float *scaleVec = scale;
    asm {
        lqc2 vf10, 0(scaleVec)
        lqc2 vf1, 0x0(matrix)
        lqc2 vf2, 0x10(matrix)
        lqc2 vf3, 0x20(matrix)
        lqc2 vf4, 0x30(matrix)
        vmul.xyzw vf1, vf1, vf10
        vmul.xyzw vf2, vf2, vf10
        vmul.xyzw vf3, vf3, vf10
        vmulw.xyzw vf4, vf4, vf0w
        sqc2 vf1, 0x0(matrix)
        sqc2 vf2, 0x10(matrix)
        sqc2 vf3, 0x20(matrix)
        sqc2 vf4, 0x30(matrix)
    }
    matrix[3][0] = position[0];
    matrix[3][1] = position[1];
    matrix[3][2] = position[2];
    sceVu0CopyMatrix(lw_matrix, matrix);
    changed = 0;
    ClearChildFlag();
}
#pragma global_optimizer reset

#pragma optimization_level 3
#pragma global_optimizer off
void mgCFrame::GetLWMatrix(float (*matrix)[4]) {
    float parent_matrix[4][4];
    float local_matrix[4][4];
    if (reference != 0) {
        changed = 1;
    }
    if (changed == 0) {
        mgCFrame *frame = parent;
        if (frame == NULL) {
            sceVu0CopyMatrix(matrix, lw_matrix);
            return;
        }
        mgCFrame *node = frame;
        while (node != NULL) {
            if (node->changed != 0) {
                break;
            }
            frame = node->parent;
            if (frame == NULL) {
                sceVu0CopyMatrix(matrix, lw_matrix);
                return;
            }
            node = frame;
        }
    }
    ClearChildFlag();
    GetLocalMatrix(local_matrix);
    if (parent == NULL) {
        sceVu0CopyMatrix(lw_matrix, local_matrix);
        sceVu0CopyMatrix(matrix, lw_matrix);
        changed = 0;
    } else {
        parent->GetLWMatrix(parent_matrix);
        float(*b)[4];
        float(*a)[4];
        float(*dst)[4];
        a = parent_matrix;
        b = local_matrix;
        dst = lw_matrix;
        asm {
            lqc2 vf5, 0(b)
            lqc2 vf1, 0(a)
            lqc2 vf2, 0x10(a)
            lqc2 vf3, 0x20(a)
            lqc2 vf4, 0x30(a)
            vmulax.xyzw ACC, vf1, vf5x
            vmadday.xyzw ACC, vf2, vf5y
            vmaddaz.xyzw ACC, vf3, vf5z
            vmaddw.xyzw vf20, vf4, vf5w
            lqc2 vf6, 0x10(b)
            lqc2 vf7, 0x20(b)
            lqc2 vf8, 0x30(b)
            vmulax.xyzw ACC, vf1, vf6x
            vmadday.xyzw ACC, vf2, vf6y
            vmaddaz.xyzw ACC, vf3, vf6z
            vmaddw.xyzw vf21, vf4, vf6w
            vmulax.xyzw ACC, vf1, vf7x
            vmadday.xyzw ACC, vf2, vf7y
            vmaddaz.xyzw ACC, vf3, vf7z
            vmaddw.xyzw vf22, vf4, vf7w
            vmulax.xyzw ACC, vf1, vf8x
            vmadday.xyzw ACC, vf2, vf8y
            vmaddaz.xyzw ACC, vf3, vf8z
            vmaddw.xyzw vf23, vf4, vf8w
            sqc2 vf20, 0(dst)
            sqc2 vf21, 0x10(dst)
            sqc2 vf22, 0x20(dst)
            sqc2 vf23, 0x30(dst)
            sqc2 vf20, 0(matrix)
            sqc2 vf21, 0x10(matrix)
            sqc2 vf22, 0x20(matrix)
            sqc2 vf23, 0x30(matrix)
        }

        changed = 0;
    }
}

#pragma optimization_level reset

#pragma global_optimizer reset

#pragma global_optimizer off
void mgCFrame::GetLWMatrixTopBottom(float (*matrix)[4]) {
    float parentMatrix[4][4];
    float localMatrix[4][4];
    if (reference != 0) {
        GetLWMatrix(matrix);
        return;
    }
    if (changed == 0) {
        mgCFrame *parentFrame = parent;
        if (parentFrame == 0) {
            sceVu0CopyMatrix(matrix, lw_matrix);
            return;
        }
        if (parentFrame->changed == 0) {
            sceVu0CopyMatrix(matrix, lw_matrix);
            return;
        }
    }
    ClearChildFlag();
    GetLocalMatrix(localMatrix);
    mgCFrame *parent = this->parent;
    if (parent == 0) {
        sceVu0CopyMatrix(lw_matrix, localMatrix);
        sceVu0CopyMatrix(matrix, lw_matrix);
    } else {
        sceVu0CopyMatrix(parentMatrix, parent->lw_matrix);
        float(*b)[4];
        float(*a)[4];
        float(*dst)[4];
        a = parentMatrix;
        b = localMatrix;
        dst = lw_matrix;
        asm {
            lqc2 vf5, 0(b)
            lqc2 vf1, 0(a)
            lqc2 vf2, 0x10(a)
            lqc2 vf3, 0x20(a)
            lqc2 vf4, 0x30(a)
            vmulax.xyzw ACC, vf1, vf5x
            vmadday.xyzw ACC, vf2, vf5y
            vmaddaz.xyzw ACC, vf3, vf5z
            vmaddw.xyzw vf20, vf4, vf5w
            lqc2 vf6, 0x10(b)
            lqc2 vf7, 0x20(b)
            lqc2 vf8, 0x30(b)
            vmulax.xyzw ACC, vf1, vf6x
            vmadday.xyzw ACC, vf2, vf6y
            vmaddaz.xyzw ACC, vf3, vf6z
            vmaddw.xyzw vf21, vf4, vf6w
            vmulax.xyzw ACC, vf1, vf7x
            vmadday.xyzw ACC, vf2, vf7y
            vmaddaz.xyzw ACC, vf3, vf7z
            vmaddw.xyzw vf22, vf4, vf7w
            vmulax.xyzw ACC, vf1, vf8x
            vmadday.xyzw ACC, vf2, vf8y
            vmaddaz.xyzw ACC, vf3, vf8z
            vmaddw.xyzw vf23, vf4, vf8w
            sqc2 vf20, 0(dst)
            sqc2 vf21, 0x10(dst)
            sqc2 vf22, 0x20(dst)
            sqc2 vf23, 0x30(dst)
            sqc2 vf20, 0(matrix)
            sqc2 vf21, 0x10(matrix)
            sqc2 vf22, 0x20(matrix)
            sqc2 vf23, 0x30(matrix)
        }
    }
    changed = 0;
}
#pragma global_optimizer reset

void mgCFrame::GetInverseMatrix(float (*matrix)[4]) {
    sceVu0FMATRIX lw;
    sceVu0FVECTOR translation;
    float         det;
    float         inv_det;

    GetLWMatrix(lw);
    det = 0.0f;
    det += lw[0][0] * lw[1][1] * lw[2][2];
    det += lw[0][1] * lw[1][2] * lw[2][0];
    det += lw[0][2] * lw[1][0] * lw[2][1];
    det -= lw[0][0] * lw[1][2] * lw[2][1];
    det -= lw[0][1] * lw[1][0] * lw[2][2];
    det -= lw[0][2] * lw[1][1] * lw[2][0];
    sceVu0UnitMatrix(matrix);
    inv_det = 1.0f / det;

    matrix[0][0] = lw[1][1] * lw[2][2] - lw[1][2] * lw[2][1];
    matrix[1][0] = lw[1][2] * lw[2][0] - lw[1][0] * lw[2][2];
    matrix[2][0] = lw[1][0] * lw[2][1] - lw[1][1] * lw[2][0];
    matrix[0][1] = lw[2][1] * lw[0][2] - lw[2][2] * lw[0][1];
    matrix[1][1] = lw[2][2] * lw[0][0] - lw[2][0] * lw[0][2];
    matrix[2][1] = lw[2][0] * lw[0][1] - lw[2][1] * lw[0][0];
    matrix[0][2] = lw[0][1] * lw[1][2] - lw[0][2] * lw[1][1];
    matrix[1][2] = lw[0][2] * lw[1][0] - lw[0][0] * lw[1][2];
    matrix[2][2] = lw[0][0] * lw[1][1] - lw[0][1] * lw[1][0];
    sceVu0ScaleVector(matrix[0], matrix[0], inv_det);
    sceVu0ScaleVector(matrix[1], matrix[1], inv_det);
    sceVu0ScaleVector(matrix[2], matrix[2], inv_det);

    sceVu0ApplyMatrix(translation, matrix, lw[3]);
    sceVu0ScaleVectorXYZ(matrix[3], translation, -1.0f);
    matrix[3][3] = 1.0f;
}

void mgCFrame::SetTransMatrix(float (*matrix)[4]) {
    sceVu0CopyMatrix(trans_matrix, matrix);
    changed = 1;
}

/**
 *
 * Compares two frame names up to their "--" flags. Returns 1 when they match, 0 otherwise.
 *
 */
static int StrCmp(char *left, char *right) {
    if (left == 0 || right == 0) {
        return 0;
    }

    char *end_a = left;
    char *end_b = right;
    s32   ch;
    s32   length_a = 0;
    s32   length_b = 0;

    while ((ch = *end_a) != 0) {
        if ((s8) ch == '-' && end_a[1] == '-') {
            break;
        }

        length_a++;
        end_a++;
    }

    while ((ch = *end_b) != 0) {
        if ((s8) ch == '-' && end_b[1] == '-') {
            break;
        }

        length_b++;
        end_b++;
    }

    if (length_a != length_b) {
        return 0;
    }

    char *pa = left;
    char *pb = right;

    for (s32 i = 0; i < length_a; i++, pa++, pb++) {
        if (*pa != *pb) {
            return 0;
        }
    }

    return 1;
}

int mgFrameNameComp(char *left, char *right) {
    return StrCmp(left, right);
}

mgCFrame *mgCFrame::SearchFrame(char *name) {
    mgCFrame *found;
    mgCFrame *node;

    if (StrCmp(this->name, name) != 0) {
        return this;
    }

    for (node = child; node != 0; node = node->brother) {
        if ((found = node->SearchFrame(name)) != 0) {
            return found;
        }
    }

    return 0;
}

int mgCFrame::SearchFrameID(char *name) {
    if (frame_list == 0) {
        return -1;
    }

    s32 index = 0;

    while (index < frame_num) {
        mgCFrame *entry = frame_list[index];

        if (entry != 0 && StrCmp(entry->name, name) != 0) {
            return index;
        }

        index++;
    }

    return -1;
}

void mgCFrame::GetWorldPosition(float *out_position, float *local_position) {
    sceVu0FMATRIX lw;

    local_position[3] = 1.0f;
    GetLWMatrix(lw);
    sceVu0ApplyMatrix(out_position, lw, local_position);
}

void mgCFrame::GetWorldPosition0(float *out_position) {
    sceVu0FMATRIX lw;

    GetLWMatrix(lw);
    *(u_long128 *) out_position = *(u_long128 *) lw[3];
}

void mgCFrame::GetWorldDir(float *out_dir, float *local_dir) {
    sceVu0FMATRIX lw;
    float         w;

    // A w of zero leaves the translation out of the transform.
    w = local_dir[3];
    local_dir[3] = 0.0f;
    GetLWMatrix(lw);
    sceVu0ApplyMatrix(out_dir, lw, local_dir);
    local_dir[3] = w;
}

void mgCFrame::SetRotation(float *rot) {
    rot_type |= 1;
    mgCObject::SetRotation(rot);
}

void mgCFrame::SetRotation(float x, float y, float z) {
    float rotation[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    rotation[0] = x;
    rotation[1] = y;
    rotation[2] = z;

    SetRotation(rotation);
}

void mgCFrame::SetRotType(int type) {
    rot_type = type;

    if (type & MG_FRAME_ROT_LOCAL_ORIGIN) {
        rot_type |= MG_FRAME_ROT_APPLY;
    }
}

void mgCFrame::SetAttrParam(mgCFrameAttr &attr, int recurse, int mask) {
    mgCFrameAttr *dst = this->attr;

    if (dst != 0) {
        if (mask == 0) {
            dst->alpha_ref = attr.alpha_ref;
            dst->alpha_blend = attr.alpha_blend;
            dst->z_write = attr.z_write;
            dst->z_test = attr.z_test;
            dst->alpha_test = attr.alpha_test;
            dst->dest_alpha_test = attr.dest_alpha_test;
            dst->draw = attr.draw;
            dst->clip_enable = attr.clip_enable;
            dst->unk_20 = attr.unk_20;
            dst->unk_24 = attr.unk_24;
            dst->unk_28 = attr.unk_28;
            dst->program_option = attr.program_option;
            dst->fog = attr.fog;
            dst->unk_34 = attr.unk_34;
            dst->unk_38 = attr.unk_38;
            dst->unk_3c = attr.unk_3c;
            dst->program_mode = attr.program_mode;
            dst->obj_alpha = attr.obj_alpha;
            dst->no_cull = attr.no_cull;
            dst->ambient_boost = attr.ambient_boost;
            *(mgVec4 *) &dst->unk_50[0] = *(mgVec4 *) &attr.unk_50[0];
            dst->no_light = attr.no_light;
            *(mgVec4 *) dst->color = *(mgVec4 *) attr.color;
            dst->point_light = attr.point_light;
            dst->unk_84 = attr.unk_84;
            dst->billboard = attr.billboard;
            dst->depth_bias = attr.depth_bias;
        } else {
            if (mask & 0x1) {
                dst->draw = attr.draw;
            }

            if (mask & 0x2) {
                this->attr->alpha_ref = attr.alpha_ref;
            }

            if (mask & 0x4) {
                this->attr->alpha_blend = attr.alpha_blend;
            }

            if (mask & 0x8) {
                this->attr->z_write = attr.z_write;
            }

            if (mask & 0x10) {
                this->attr->z_test = attr.z_test;
            }

            if (mask & 0x20) {
                this->attr->clip_enable = attr.clip_enable;
            }

            if (mask & 0x40) {
                this->attr->unk_20 = attr.unk_20;
            }

            if (mask & 0x80) {
                this->attr->unk_24 = attr.unk_24;
            }

            if (mask & 0x100) {
                this->attr->unk_28 = attr.unk_28;
            }

            if (mask & 0x200) {
                this->attr->program_option = attr.program_option;
            }

            if (mask & 0x400) {
                this->attr->fog = attr.fog;
            }

            if (mask & 0x800) {
                this->attr->unk_34 = attr.unk_34;
            }

            if (mask & 0x1000) {
                this->attr->unk_38 = attr.unk_38;
            }

            if (mask & 0x2000) {
                this->attr->unk_3c = attr.unk_3c;
            }

            if (mask & 0x4000) {
                this->attr->program_mode = attr.program_mode;
            }

            if (mask & 0x8000) {
                this->attr->no_light = attr.no_light;
            }

            if (mask & 0x10000) {
                *(u_long128 *) this->attr->color = *(u_long128 *) attr.color;
            }

            if (mask & 0x20000) {
                this->attr->point_light = attr.point_light;
            }

            if (mask & 0x40000) {
                this->attr->obj_alpha = attr.obj_alpha;
            }

            if (mask & 0x80000) {
                this->attr->billboard = attr.billboard;
            }

            if (mask & 0x100000) {
                this->attr->no_cull = attr.no_cull;
            }

            if (mask & 0x200000) {
                this->attr->depth_bias = attr.depth_bias;
            }

            if (mask & 0x800000) {
                this->attr->ambient_boost = attr.ambient_boost;
            }

            if (mask & 0x400000) {
                this->attr->dest_alpha_test = attr.dest_alpha_test;
            }
        }
    }

    if (recurse == 0) {
        return;
    }

    mgCFrame *frame = child;

    if (frame != 0) {
        do {
            frame->SetAttrParam(attr, 1, mask);
            frame = frame->brother;
        } while (frame != 0);
    }
}

void mgCFrame::SetAttrParamObjAlpha(float alpha, int recurse) {
    if (attr != 0) {
        this->attr->obj_alpha = alpha;
    }

    if (recurse == 0) {
        return;
    }

    mgCFrame *frame = child;

    if (frame != 0) {
        do {
            frame->SetAttrParamObjAlpha(alpha, 1);
            frame = frame->brother;
        } while (frame != 0);
    }
}

void mgCFrame::SetAttrParamDraw(int value, int recurse) {
    mgCFrameAttr *attr;
    mgCFrame     *node;

    attr = this->attr;

    if (attr != NULL) {
        this->attr->draw = value;
    }

    if (recurse == 0) {
        return;
    }

    for (node = child; node != NULL; node = node->brother) {
        node->SetAttrParamDraw(value, 1);
    }
}

#ifdef NONMATCHING
int mgCFrame::Draw(unsigned int *packet) {
    mgRENDER_INFO *info = &mgRenderInfo;
    int            words = 0;
    sceVu0FMATRIX  world;
    if (attr == NULL) {
        GetLWMatrixTopBottom(world);
    } else {
        if (attr->billboard != 0) {
            GetBBoardMatrix(attr->billboard, world, info);
        } else {
            GetLWMatrixTopBottom(world);
        }

        while (attr != NULL && (attr->draw & MG_FRAME_DRAW_VISIBLE)) {
            if (visual == NULL) {
                break;
            }
            if (!attr->no_cull && bound != NULL) {
                sceVu0FVECTOR box_max;
                sceVu0FVECTOR box_min;
                test1(bound->corner, info->world_screen_rel, world, box_max, box_min);
                if (box_max[3] < info->clip_min[2]) {
                    break;
                }
                test2(box_max, box_min);
                if (!mgClipBoxW(box_max, box_min, info->screen_box_max, info->screen_box_min)) {
                    break;
                }
                if (mgClipInBoxW(box_max, box_min, info->gs_box_max, info->gs_box_min)) {
                    info->clip = 0;
                    info->scissor = 0;
                } else {
                    info->clip = 1;
                    if (attr->program_mode & 2) {
                        info->scissor = attr->clip_enable != 0;
                    } else {
                        info->scissor = (attr->clip_enable != 0) | info->all_scissor;
                    }
                }
            }
            info->attr = attr;
            sceVu0CopyVector(info->object_color, attr->color);
            info->plight_hit = 0;
            if (info->plight_enable && attr->point_light && !attr->no_light && bound != NULL) {
                sceVu0FMATRIX transposed;
                sceVu0TransposeMatrix(transposed, world);
                float scale = mgDistVector(transposed[0]);
                float y_scale = mgDistVector(transposed[1]);
                float z_scale = mgDistVector(transposed[2]);
                scale = scale > y_scale ? (scale > z_scale ? scale : z_scale)
                                        : (y_scale > z_scale ? y_scale : z_scale);
                float         radius = bound->radius * scale;
                sceVu0FVECTOR center;
                sceVu0CopyVector(center, bound->center);
                center[3] = 1.0f;
                sceVu0ApplyMatrix(center, world, center);
                mgLIGHT_INFO *light = info->GetpLightInfo();
                for (int i = 0; i < 4; i++) {
                    if (!(light->point_light[i].power <= 0.0f)) {
                        float reach = radius + light->point_light[i].range;
                        if (!(reach <= mgDistVector(light->point_light[i].pos, center))) {
                            info->plight_hit = 1;
                            break;
                        }
                    }
                }
            }
            words += visual->Draw(packet, world, NULL);
            break;
        }
        if (attr->draw & MG_FRAME_DRAW_SKIP_CHILDREN) {
            return words;
        }
    }
    for (mgCFrame *node = child; node != NULL; node = node->brother) {
        int use = 1;
        if (node->attr != NULL && (node->attr->draw & MG_FRAME_DRAW_SKIP_BY_PARENT)) {
            use = 0;
        }
        if (use) {
            words += node->Draw(packet + words * 4);
        }
    }
    return words;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_frame", Draw__8mgCFrameFPUi);
#endif

#pragma global_optimizer off
int mgCFrame::GetDrawRect(mgVu0FBOX *rect, mgCDrawManager *manager) {
    sceVu0FMATRIX   lw;
    sceVu0FVECTOR   rect_max;
    sceVu0FVECTOR   rect_min;
    sceVu0FMATRIX   screen_matrix;
    mgVu0FBOX       child_rect;
    mgCFrameAttr   *draw_attr;
    int             visible;
    mgRENDER_INFO  *info;
    mgCFrame       *frame;
    register float *lo;
    register float *hi;
    register float *matrix;
    register float *corners;
    float           left;
    float           top;
    int             billboard;
    int             draw_child;
    register u_long128 *copy_min;
    register u_long128 copy_value;
    register u_long128 *copy_max;

    if (manager == NULL) {
        manager = &mgDrawManager;
    }
    info = manager->render_info;
    copy_max = reinterpret_cast<u_long128 *>(rect_max);
    copy_value = *reinterpret_cast<u_long128 *>(at_1118);
    *copy_max = copy_value;
    copy_min = reinterpret_cast<u_long128 *>(rect_min);
    *copy_min = *reinterpret_cast<u_long128 *>(at_1119);

    draw_attr = attr;
    if (draw_attr == NULL) {
        draw_attr = &dmy_attr;
    }

    billboard = MG_FRAME_BILLBOARD_NONE;
    if (attr != NULL) {
        billboard = this->attr->billboard;
    }
    if (billboard != MG_FRAME_BILLBOARD_NONE) {
        GetBBoardMatrix(billboard, lw, info);
    } else {
        GetLWMatrixTopBottom(lw);
    }

    visible = 0;
    if (draw_attr->draw & MG_FRAME_DRAW_VISIBLE) {
        visible = 1;
    }
    if (visual == NULL || bound == NULL) {
        visible = 0;
    }

    do {
        if (!visible) break;
        mgMulMatrix(screen_matrix, info->world_screen_rel, lw);
        corners = &bound->corner[0][0];
        matrix = &screen_matrix[0][0];
        hi = rect_max;
        lo = rect_min;

        // Each corner goes through the screen transform and is divided through by the magnitude
        // of its w, and the box around the results is kept.
        asm {
            lqc2    vf10, 0(corners)
            lqc2    vf11, 16(corners)
            lqc2    vf12, 32(corners)
            lqc2    vf13, 48(corners)
            lqc2    vf14, 64(corners)
            lqc2    vf15, 80(corners)
            lqc2    vf16, 96(corners)
            lqc2    vf17, 112(corners)
            lqc2    vf1, 0(matrix)
            lqc2    vf2, 16(matrix)
            lqc2    vf3, 32(matrix)
            lqc2    vf4, 48(matrix)
            vmulax  ACC, vf1, vf10
            vmadday ACC, vf2, vf10
            vmaddaz ACC, vf3, vf10
            vmaddw  vf10, vf4, vf10
            vmulax  ACC, vf1, vf11
            vmadday ACC, vf2, vf11
            vmaddaz ACC, vf3, vf11
            vabs.w  vf20, vf10
            vnop
            vnop
            vmaddw  vf11, vf4, vf11
            vdiv    Q, vf0w, vf20w
            vnop
            vnop
            vabs.w  vf21, vf11
            vnop
            vnop
            vwaitq
            vmulq.xy vf10, vf10, Q
            vdiv    Q, vf0w, vf21w
            vmulax  ACC, vf1, vf12
            vmadday ACC, vf2, vf12
            vmaddaz ACC, vf3, vf12
            vmaddw  vf12, vf4, vf12
            vmulax  ACC, vf1, vf13
            vwaitq
            vmulq.xy vf11, vf11, Q
            vabs.w  vf22, vf12
            vmadday ACC, vf2, vf13
            vmaddaz ACC, vf3, vf13
            vmaddw  vf13, vf4, vf13
            vdiv    Q, vf0w, vf22w
            vmulax  ACC, vf1, vf14
            vmadday ACC, vf2, vf14
            vabs.w  vf23, vf13
            vmaddaz ACC, vf3, vf14
            vmaddw  vf14, vf4, vf14
            vmax    vf30, vf10, vf11
            vmini   vf31, vf10, vf11
            vwaitq
            vmulq.xy vf12, vf12, Q
            vdiv    Q, vf0w, vf23w
            vabs.w  vf24, vf14
            vmulax  ACC, vf1, vf15
            vmadday ACC, vf2, vf15
            vmaddaz ACC, vf3, vf15
            vmaddw  vf15, vf4, vf15
            vmax    vf30, vf30, vf12
            vmini   vf31, vf31, vf12
            vwaitq
            vmulq.xy vf13, vf13, Q
            vdiv    Q, vf0w, vf24w
            vabs.w  vf25, vf15
            vmulax  ACC, vf1, vf16
            vmadday ACC, vf2, vf16
            vmaddaz ACC, vf3, vf16
            vmaddw  vf16, vf4, vf16
            vmax    vf30, vf30, vf13
            vmini   vf31, vf31, vf13
            vwaitq
            vmulq.xy vf14, vf14, Q
            vdiv    Q, vf0w, vf25w
            vabs.w  vf26, vf16
            vmulax  ACC, vf1, vf17
            vmadday ACC, vf2, vf17
            vmaddaz ACC, vf3, vf17
            vmaddw  vf17, vf4, vf17
            vmax    vf30, vf30, vf14
            vmini   vf31, vf31, vf14
            vwaitq
            vmulq.xy vf15, vf15, Q
            vdiv    Q, vf0w, vf26w
            vabs.w  vf27, vf17
            vnop
            vmax    vf30, vf30, vf15
            vmini   vf31, vf31, vf15
            vnop
            vwaitq
            vmulq.xy vf16, vf16, Q
            vdiv    Q, vf0w, vf27w
            vnop
            vmax    vf30, vf30, vf16
            vmini   vf31, vf31, vf16
            vnop
            vnop
            vwaitq
            vmulq.xy vf17, vf17, Q
            vmax    vf30, vf30, vf17
            vmini   vf31, vf31, vf17
            sqc2    vf30, 0(hi)
            sqc2    vf31, 0(lo)
        }

        // The box counts only when it overlaps the screen, whose coordinates are relative to its
        // centre, and does not lie behind the near plane; it is then moved to screen coordinates.
        visible = 0;
        left = 0.5f * -mgScreenWidth;
        top = 0.5f * -mgScreenHeight;
        float right = left + mgScreenWidth;
        float bottom = top + mgScreenHeight;
        if (rect_min[0] <= right && rect_max[0] >= left &&
            rect_min[1] <= bottom && rect_max[1] >= top && rect_max[3] >= info->clip_min[2]) {
            visible = 1;
            rect_min[0] += mgScreenWidth / 2;
            rect_max[0] += mgScreenWidth / 2;
            rect_min[1] += mgScreenHeight / 2;
            rect_max[1] += mgScreenHeight / 2;
        }
    } while (0);

    if (visible) {
        sceVu0CopyVector(rect->max, rect_max);
        sceVu0CopyVector(rect->min, rect_min);
    }
    if (draw_attr->draw & MG_FRAME_DRAW_SKIP_CHILDREN) {
        return visible;
    }

    for (frame = child; frame != NULL; frame = frame->brother) {
        draw_child = 1;
        if (frame->attr != NULL && (frame->attr->draw & MG_FRAME_DRAW_SKIP_BY_PARENT)) {
            draw_child = 0;
        }
        if (draw_child && frame->GetDrawRect(&child_rect, NULL)) {
            if (!visible) {
                sceVu0CopyVector(rect_max, child_rect.max);
                sceVu0CopyVector(rect_min, child_rect.min);
            } else {
                mgVectorMaxMin(rect_max, rect_min, rect_max, rect_min, child_rect.max, child_rect.min);
            }
            visible = 1;
        }
    }

    sceVu0CopyVector(rect->max, rect_max);
    sceVu0CopyVector(rect->min, rect_min);
    return visible;
}
#pragma global_optimizer reset

mgCFrame &mgCFrame::operator=(mgCFrame &other) {
    memcpy(this, &other, sizeof(mgCFrame));
    parent = child = brother = NULL;
    changed = 1;
    reference = 0;

    // The copy builds its matrix from its parts unless they are all at their defaults.
    use_srt = 0;

    if (position[0] != 0.0f || position[1] != 0.0f || position[2] != 0.0f) {
        use_srt = 1;
    }

    if (rotation[0] != 0.0f || rotation[1] != 0.0f || rotation[2] != 0.0f) {
        use_srt = 1;
    }

    if (scale[0] != 1.0f || scale[1] != 1.0f || scale[2] != 1.0f) {
        use_srt = 1;
    }

    return *this;
}

int mgCFrame::Draw() {
    return Draw(NULL);
}

void mgCObject::ChangeParam() {
    changed = 1;
}

void mgCObject::UseParam() {
    changed = 1;
}

int mgCObject::DrawDirect() {
    return 0;
}

int mgCObject::Draw() {
    return 0;
}

// Uninitialised data (.bss)
INCLUDE_BSS(at_1118, 0x10);
INCLUDE_BSS(at_1119, 0x10);
