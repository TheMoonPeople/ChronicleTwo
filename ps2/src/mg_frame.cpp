#include "common.h"
#include "mg_memory.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mg_frame.hpp"

#include <cstring>
#include <libvu0.h>

#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"

extern "C" u_char at_844[];

#ifdef NONMATCHING
static mgCFrameAttr dmy_attr; /**< Attributes GetDrawRect reads for a frame that has none of its own. */
#endif

/**
 *
 * Scales the first three rows of a matrix component-wise by a vector and copies its last row.
 *
 */
static inline void ScaleMatrix(sceVu0FMATRIX out, sceVu0FMATRIX in, sceVu0FVECTOR scale) {
    register float *by = &scale[0];
    register float *src = &in[0][0];
    register float *dst = &out[0][0];

    asm {
        lqc2    vf10, 0(by)
        lqc2    vf1, 0(src)
        lqc2    vf2, 16(src)
        lqc2    vf3, 32(src)
        lqc2    vf4, 48(src)
        vmul    vf1, vf1, vf10
        vmul    vf2, vf2, vf10
        vmul    vf3, vf3, vf10
        vmulw   vf4, vf4, vf0
        sqc2    vf1, 0(dst)
        sqc2    vf2, 16(dst)
        sqc2    vf3, 32(dst)
        sqc2    vf4, 48(dst)
    }
}

/**
 *
 * Multiplies two matrices and stores the product into two destinations.
 *
 */
static inline void MulMatrixTwice(sceVu0FMATRIX out0, sceVu0FMATRIX out1, sceVu0FMATRIX left, sceVu0FMATRIX right) {
    register float *l = &left[0][0];
    register float *r = &right[0][0];
    register float *o0 = &out0[0][0];
    register float *o1 = &out1[0][0];

    asm {
        lqc2    vf5, 0(r)
        lqc2    vf1, 0(l)
        lqc2    vf2, 16(l)
        lqc2    vf3, 32(l)
        lqc2    vf4, 48(l)
        vmulax  ACC, vf1, vf5
        vmadday ACC, vf2, vf5
        vmaddaz ACC, vf3, vf5
        vmaddw  vf20, vf4, vf5
        lqc2    vf6, 16(r)
        lqc2    vf7, 32(r)
        lqc2    vf8, 48(r)
        vmulax  ACC, vf1, vf6
        vmadday ACC, vf2, vf6
        vmaddaz ACC, vf3, vf6
        vmaddw  vf21, vf4, vf6
        vmulax  ACC, vf1, vf7
        vmadday ACC, vf2, vf7
        vmaddaz ACC, vf3, vf7
        vmaddw  vf22, vf4, vf7
        vmulax  ACC, vf1, vf8
        vmadday ACC, vf2, vf8
        vmaddaz ACC, vf3, vf8
        vmaddw  vf23, vf4, vf8
        sqc2    vf20, 0(o0)
        sqc2    vf21, 16(o0)
        sqc2    vf22, 32(o0)
        sqc2    vf23, 48(o0)
        sqc2    vf20, 0(o1)
        sqc2    vf21, 16(o1)
        sqc2    vf22, 32(o1)
        sqc2    vf23, 48(o1)
    }
}

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
    unk_50[3] = unk_50[2] = unk_50[0] = 0.0f;
    unk_50[1] = 1.0f;
    depth_bias = 0.0f;
    unk_84 = 0;
}

mgCFrameAttr::mgCFrameAttr() {
    Initialize();
}

/**
 *
 * Builds a rotation matrix from a quaternion whose scalar part comes first.
 *
 */
void QuatToMat(float *quaternion, float (*matrix)[4]) {
    float w;
    float x;
    float y;
    float z;

    w = quaternion[0];
    x = quaternion[1];
    y = quaternion[2];
    z = quaternion[3];

    matrix[0][0] = 1.0f - 2.0f * (y * y + z * z);
    matrix[0][1] = 2.0f * (x * y - w * z);
    matrix[0][2] = 2.0f * (x * z + w * y);
    matrix[0][3] = 0.0f;

    matrix[1][0] = 2.0f * (x * y + w * z);
    matrix[1][1] = 1.0f - 2.0f * (x * x + z * z);
    matrix[1][2] = 2.0f * (y * z - w * x);
    matrix[1][3] = 0.0f;

    matrix[2][0] = 2.0f * (x * z - w * y);
    matrix[2][1] = 2.0f * (y * z + w * x);
    matrix[2][2] = 1.0f - 2.0f * (x * x + y * y);
    matrix[2][3] = 0.0f;

    matrix[3][0] = 0.0f;
    matrix[3][1] = 0.0f;
    matrix[3][2] = 0.0f;
    matrix[3][3] = 1.0f;
}

// clang-format off
/**
 *
 * Transforms eight corners by the product of two matrices, leaving the results in VU0
 * registers vf10-vf17, and gets the box around them.
 *
 */
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
// clang-format on
// clang-format off
/**
 *
 * Divides the eight corners that test1 left in vf10-vf17 through by their depth and gets
 * the screen-space box around them.
 *
 */
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
int mgInsideScreen(mgVu0FBOX *box, float (*matrix)[4], float *out_max, float *out_min) {
    sceVu0FVECTOR corners[8];

    mgCreateBox8(corners, box->max, box->min);
    // Each corner goes through the screen transform and is divided through by the magnitude
    // of its w, with each division overlapped with the next corner's transform.
    return mgInsideScreen(corners, matrix, out_max, out_min);
}
int mgInsideScreen(float (*corners)[4], float (*matrix)[4]) {
    sceVu0FVECTOR max;
    sceVu0FVECTOR min;

    return mgInsideScreen(corners, matrix, max, min);
}
int mgInsideScreen(float (*corners)[4], float (*matrix)[4], float *out_max, float *out_min) {
    register float *screen = &mgRenderInfo.world_screen_rel[0][0];
    register float *m = &matrix[0][0];
    register float *in = &corners[0][0];
    register float *hi = out_max;
    register float *lo = out_min;

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

    return mgClipBoxW(out_max, out_min, mgRenderInfo.screen_box_max, mgRenderInfo.screen_box_min);
}

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
    sceVu0FVECTOR position = {x, y, z, 1.0f};

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
    sceVu0FVECTOR rotation = {x, y, z, 0.0f};

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
    sceVu0FVECTOR scale = {x, y, z, 0.0f};

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
    elder = brother = child = parent = NULL;
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
    mgCFrameBase::Initialize();
}

void mgCFrame::SetName(char *name) {
    this->name = name;
}
void mgCFrame::SetTransMatrix(float *quaternion) {
    float x;
    float y;
    float z;
    float w;

    changed = 1;
    x = trans_matrix[3][0];
    y = trans_matrix[3][1];
    z = trans_matrix[3][2];
    w = trans_matrix[3][3];
    QuatToMat(quaternion, trans_matrix);
    trans_matrix[3][0] = x;
    trans_matrix[3][1] = y;
    trans_matrix[3][2] = z;
    trans_matrix[3][3] = w;
}

void mgCFrame::SetBBox(float *max, float *min) {
    float *box[2];
    int i;

    if (bound != NULL) {
        sceVu0CopyVector(bound->max, max);
        sceVu0CopyVector(bound->min, min);
        box[0] = bound->min;
        box[1] = bound->max;
        // Bit 0 of the corner index picks the x of the maximum, bit 1 the y, bit 2 the z.
        for (i = 0; i < 8; i++) {
            bound->corner[i][3] = 1.0f;
            bound->corner[i][0] = box[(i & 1) != 0][0];
            bound->corner[i][1] = box[(i & 2) != 0][1];
            bound->corner[i][2] = box[(i & 4) != 0][2];
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
    if (index >= 0 && index <= frame_num && frame_list != NULL) {
        return frame_list[index];
    }
    return NULL;
}

int mgCFrame::RemakeBBox(float *out_max, float *out_min) {
    mgCVisual *visual;
    sceVu0FMATRIX lw;

    visual = this->visual;
    if (visual == NULL) {
        return 0;
    }
    GetLWMatrix(lw);
    if (visual->CreateBBox(out_max, out_min, lw) == 0) {
        return 0;
    }
    SetBBox(out_max, out_min);
    return 1;
}

int mgCFrame::GetWorldBBox(mgVu0FBOX *box) {
    mgVu0FBOX world;
    sceVu0FMATRIX lw;
    sceVu0FVECTOR center;
    sceVu0FVECTOR half;
    mgVu0FBOX child_box;
    mgCFrame *frame;
    int found;

    found = 0;
    if (visual != NULL && bound != NULL) {
        found = 1;
        GetLWMatrix(lw);
        mgApplyMatrix(world.max, world.min, lw, bound->max, bound->min);
        if (attr != NULL && attr->billboard != MG_FRAME_BILLBOARD_NONE) {
            // A billboard turns to face the eye, so its box is widened to a cube that holds
            // every orientation.
            sceVu0AddVector(center, world.max, world.min);
            sceVu0ScaleVector(center, center, 0.5f);
            sceVu0SubVector(half, world.max, center);
            if (half[0] <= half[1]) {
                half[2] = (half[1] <= half[2]) ? half[2] : half[1];
            } else {
                half[2] = (half[0] <= half[2]) ? half[2] : half[0];
            }
            half[0] = half[1] = half[2];
            half[3] = 0.0f;
            sceVu0AddVector(world.max, center, half);
            sceVu0SubVector(world.min, center, half);
        }
    }

    for (frame = child; frame != NULL; frame = frame->brother) {
        if (frame->GetWorldBBox(&child_box)) {
            if (!found) {
                world = child_box;
            } else {
                mgVectorMaxMin(world.max, world.min, world.max, world.min, child_box.max, child_box.min);
            }
            found = 1;
        }
    }

    *box = world;
    return found;
}

int mgCFrame::GetFrameNum() {
    mgCFrame *frame;
    int num;

    num = 1;
    for (frame = child; frame != NULL; frame = frame->brother) {
        num += frame->GetFrameNum();
    }
    return num;
}

void mgCFrame::SetParent(mgCFrame *parent) {
    if (this->parent == NULL) {
        this->parent = parent;
        if (parent != NULL) {
            parent->SetChild(this);
        }
    }
}
void mgCFrame::SetBrother(mgCFrame *brother) {
    if (brother != NULL) {
        if (this->brother == NULL) {
            this->brother = brother;
            this->brother->elder = this;
        } else {
            this->brother->SetBrother(brother);
        }
    }
}

void mgCFrame::SetChild(mgCFrame *child) {
    if (child != NULL) {
        if (this->child == NULL) {
            this->child = child;
            child->parent = this;
        } else {
            this->child->SetBrother(child);
            child->parent = this;
        }
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
#ifdef NONMATCHING
void mgCFrame::ClearChildFlag() {
    mgCFrame *frame;

    if (child != NULL) {
        child->changed = 1;
        for (frame = child; frame->brother != NULL; frame = frame->brother) {
            frame->brother->changed = 1;
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_frame", ClearChildFlag__8mgCFrameFv);
#endif
void mgCFrame::GetLocalMatrix(float (*matrix)[4]) {
    sceVu0FVECTOR translation;

    if (!use_srt) {
        sceVu0CopyMatrix(matrix, trans_matrix);
        return;
    }

    ScaleMatrix(matrix, trans_matrix, scale);
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
}

void mgCFrame::GetBBoardMatrix(int mode, float (*matrix)[4], mgRENDER_INFO *info) {
    sceVu0FVECTOR position;
    sceVu0FVECTOR dir;
    sceVu0FVECTOR scale;
    sceVu0FMATRIX lw;
    sceVu0FMATRIX pitch;
    float dir_y;

    GetLWMatrix(lw);
    scale[0] = mgDistVector(lw[0]);
    scale[1] = mgDistVector(lw[0]);
    scale[2] = mgDistVector(lw[0]);
    sceVu0CopyVector(position, lw[3]);
    sceVu0UnitMatrix(matrix);

    if (mode & 2) {
        // Yaw only: the z axis points at the eye across the ground plane.
        sceVu0SubVector(matrix[2], info->camera_pos, position);
        matrix[2][1] = 0.0f;
        matrix[2][3] = 0.0f;
        sceVu0Normalize(matrix[2], matrix[2]);
        matrix[0][0] = matrix[2][2];
        matrix[0][2] = -matrix[2][0];
    }
    if (mode & 1) {

        // Yaw as above, preceded by a pitch about x towards the eye.
        sceVu0UnitMatrix(pitch);
        sceVu0SubVector(dir, info->camera_pos, position);
        sceVu0Normalize(dir, dir);
        dir_y = dir[1];
        dir[3] = 0.0f;
        dir[1] = 0.0f;
        pitch[1][1] = mgDistVector(dir);
        pitch[2][2] = pitch[1][1];
        pitch[1][2] = -dir_y;
        pitch[2][1] = dir_y;
        sceVu0SubVector(matrix[2], info->camera_pos, position);
        matrix[2][1] = 0.0f;
        matrix[2][3] = 0.0f;
        sceVu0Normalize(matrix[2], matrix[2]);
        matrix[0][0] = matrix[2][2];
        matrix[0][2] = -matrix[2][0];
        mgMulMatrix(matrix, matrix, pitch);
    }

    ScaleMatrix(matrix, matrix, scale);
    matrix[3][0] = position[0];
    matrix[3][1] = position[1];
    matrix[3][2] = position[2];
    sceVu0CopyMatrix(lw_matrix, matrix);
    changed = 0;
    ClearChildFlag();
}

#ifdef NONMATCHING
void mgCFrame::GetLWMatrix(float (*matrix)[4]) {
    sceVu0FMATRIX parent_lw;
    sceVu0FMATRIX local;
    mgCFrame *frame;

    if (reference) {
        changed = 1;
    }
    if (!changed) {
        // The cache holds while no ancestor has changed either.
        for (frame = parent; frame != NULL; frame = frame->parent) {
            if (frame->changed) {
                break;
            }
        }
        if (frame == NULL) {
            sceVu0CopyMatrix(matrix, lw_matrix);
            return;
        }
    }

    ClearChildFlag();
    GetLocalMatrix(local);
    if (parent == NULL) {
        sceVu0CopyMatrix(lw_matrix, local);
        sceVu0CopyMatrix(matrix, lw_matrix);
        changed = 0;
    } else {
        parent->GetLWMatrix(parent_lw);
        MulMatrixTwice(lw_matrix, matrix, parent_lw, local);
        changed = 0;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_frame", GetLWMatrix__8mgCFrameFPA4_f);
#endif
void mgCFrame::GetLWMatrixTopBottom(float (*matrix)[4]) {
    sceVu0FMATRIX parent_lw;
    sceVu0FMATRIX local;

    if (reference) {
        GetLWMatrix(matrix);
        return;
    }
    if (!changed && (parent == NULL || !parent->changed)) {
        sceVu0CopyMatrix(matrix, lw_matrix);
        return;
    }

    ClearChildFlag();
    GetLocalMatrix(local);
    if (parent == NULL) {
        sceVu0CopyMatrix(lw_matrix, local);
        sceVu0CopyMatrix(matrix, lw_matrix);
        changed = 0;
    } else {
        sceVu0CopyMatrix(parent_lw, parent->lw_matrix);
        MulMatrixTwice(lw_matrix, matrix, parent_lw, local);
        changed = 0;
    }
}

void mgCFrame::GetInverseMatrix(float (*matrix)[4]) {
    sceVu0FMATRIX lw;
    sceVu0FVECTOR translation;
    float det;
    float inv_det;

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
int StrCmp(char *left, char *right) {
    int left_len;
    int right_len;
    int i;

    if (left == NULL || right == NULL) {
        return 0;
    }

    left_len = 0;
    right_len = 0;
    while (left[left_len] != '\0' && (left[left_len] != '-' || left[left_len + 1] != '-')) {
        left_len++;
    }
    while (right[right_len] != '\0' && (right[right_len] != '-' || right[right_len + 1] != '-')) {
        right_len++;
    }
    if (left_len != right_len) {
        return 0;
    }
    for (i = 0; i < left_len; i++) {
        if (left[i] != right[i]) {
            return 0;
        }
    }
    return 1;
}

int mgFrameNameComp(char *left, char *right) {
    return StrCmp(left, right);
}

mgCFrame *mgCFrame::SearchFrame(char *name) {
    mgCFrame *frame;
    mgCFrame *found;

    if (StrCmp(this->name, name)) {
        return this;
    }
    for (frame = child; frame != NULL; frame = frame->brother) {
        found = frame->SearchFrame(name);
        if (found != NULL) {
            return found;
        }
    }
    return NULL;
}

int mgCFrame::SearchFrameID(char *name) {
    int i;

    if (frame_list != NULL) {
        for (i = 0; i < frame_num; i++) {
            if (frame_list[i] != NULL && StrCmp(frame_list[i]->name, name)) {
                return i;
            }
        }
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
    *(u_long128 *)out_position = *(u_long128 *)lw[3];
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
    sceVu0FVECTOR rotation = {x, y, z, 0.0f};

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
            *(mgVec4 *)&dst->unk_50[0] = *(mgVec4 *)&attr.unk_50[0];
            dst->no_light = attr.no_light;
            *(mgVec4 *)dst->color = *(mgVec4 *)attr.color;
            dst->point_light = attr.point_light;
            dst->unk_84 = attr.unk_84;
            dst->billboard = attr.billboard;
            dst->depth_bias = attr.depth_bias;
        } else {
            if (mask & 0x1) {
                dst->draw = attr.draw;
            }
            if (mask & 0x2) {
                dst->alpha_ref = attr.alpha_ref;
            }
            if (mask & 0x4) {
                dst->alpha_blend = attr.alpha_blend;
            }
            if (mask & 0x8) {
                dst->z_write = attr.z_write;
            }
            if (mask & 0x10) {
                dst->z_test = attr.z_test;
            }
            if (mask & 0x20) {
                dst->clip_enable = attr.clip_enable;
            }
            if (mask & 0x40) {
                dst->unk_20 = attr.unk_20;
            }
            if (mask & 0x80) {
                dst->unk_24 = attr.unk_24;
            }
            if (mask & 0x100) {
                dst->unk_28 = attr.unk_28;
            }
            if (mask & 0x200) {
                dst->program_option = attr.program_option;
            }
            if (mask & 0x400) {
                dst->fog = attr.fog;
            }
            if (mask & 0x800) {
                dst->unk_34 = attr.unk_34;
            }
            if (mask & 0x1000) {
                dst->unk_38 = attr.unk_38;
            }
            if (mask & 0x2000) {
                dst->unk_3c = attr.unk_3c;
            }
            if (mask & 0x4000) {
                dst->program_mode = attr.program_mode;
            }
            if (mask & 0x8000) {
                dst->no_light = attr.no_light;
            }
            if (mask & 0x10000) {
                *(u_long128 *)dst->color = *(u_long128 *)attr.color;
            }
            if (mask & 0x20000) {
                dst->point_light = attr.point_light;
            }
            if (mask & 0x40000) {
                dst->obj_alpha = attr.obj_alpha;
            }
            if (mask & 0x80000) {
                dst->billboard = attr.billboard;
            }
            if (mask & 0x100000) {
                dst->no_cull = attr.no_cull;
            }
            if (mask & 0x200000) {
                dst->depth_bias = attr.depth_bias;
            }
            if (mask & 0x800000) {
                dst->ambient_boost = attr.ambient_boost;
            }
            if (mask & 0x400000) {
                dst->dest_alpha_test = attr.dest_alpha_test;
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
        attr->obj_alpha = alpha;
    }
    if (recurse == 0)
        return;
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
    mgCFrame *node;

    attr = this->attr;
    if (attr != NULL) {
        attr->draw = value;
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
    sceVu0FMATRIX  lw;
    sceVu0FVECTOR  box_max;
    sceVu0FVECTOR  box_min;
    sceVu0FMATRIX  axes;
    sceVu0FVECTOR  center;
    mgRENDER_INFO *info;
    mgLIGHT_INFO  *light_info;
    mgCFrame      *frame;
    float          scale_x;
    float          scale_y;
    float          scale_z;
    float          radius;
    int            count;
    int            visible;
    int            draw_child;
    int            i;

    count = 0;
    info = &mgRenderInfo;
    if (attr == NULL) {
        GetLWMatrixTopBottom(lw);
    } else {
        if (attr->billboard != MG_FRAME_BILLBOARD_NONE) {
            GetBBoardMatrix(attr->billboard, lw, info);
        } else {
            GetLWMatrixTopBottom(lw);
        }

        if (attr != NULL && (attr->draw & MG_FRAME_DRAW_VISIBLE) && visual != NULL) {
            visible = 1;
            if (!attr->no_cull && bound != NULL) {
                // The frame is skipped when its box lies behind the near plane or off screen, and
                // drawn with clipping when the box leaves the GS drawing range.
                visible = 0;
                test1(bound->corner, info->world_screen_rel, lw, box_max, box_min);
                if (box_max[3] >= info->clip_min[2]) {
                    test2(box_max, box_min);
                    if (mgClipBoxW(box_max, box_min, info->screen_box_max, info->screen_box_min)) {
                        visible = 1;
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
                }
            }

            if (visible) {
                info->attr = attr;
                sceVu0CopyVector(info->object_color, attr->color);
                info->plight_hit = 0;
                if (info->plight_enable && attr->point_light && !attr->no_light && bound != NULL) {
                    // The bounding sphere is moved into the world, its radius scaled by the
                    // longest of the matrix's first three columns, and tested against each
                    // point light's reach.
                    sceVu0TransposeMatrix(axes, lw);
                    scale_x = mgDistVector(axes[0]);
                    scale_y = mgDistVector(axes[1]);
                    scale_z = mgDistVector(axes[2]);
                    if (scale_x <= scale_y) {
                        if (scale_y <= scale_z) {
                            scale_y = scale_z;
                        }
                        scale_x = scale_y;
                    } else if (scale_x <= scale_z) {
                        scale_x = scale_z;
                    }
                    radius = bound->radius * scale_x;
                    sceVu0CopyVector(center, bound->center);
                    center[3] = 1.0f;
                    sceVu0ApplyMatrix(center, lw, center);
                    light_info = info->GetpLightInfo();
                    for (i = 0; i < 4; i++) {
                        if (light_info->point_light[i].power > 0.0f &&
                            radius + light_info->point_light[i].range >
                                mgDistVector(light_info->point_light[i].pos, center)) {
                            info->plight_hit = 1;
                            break;
                        }
                    }
                }
                count += visual->Draw(packet, lw, NULL);
            }
        }

        if (attr->draw & MG_FRAME_DRAW_SKIP_CHILDREN) {
            return count;
        }
    }

    for (frame = child; frame != NULL; frame = frame->brother) {
        draw_child = 1;
        if (frame->attr != NULL && (frame->attr->draw & MG_FRAME_DRAW_SKIP_BY_PARENT)) {
            draw_child = 0;
        }
        if (draw_child) {
            count += frame->Draw(&packet[count * 4]);
        }
    }
    return count;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_frame", Draw__8mgCFrameFPUi);
#endif

#ifdef NONMATCHING
int mgCFrame::GetDrawRect(mgVu0FBOX *rect, mgCDrawManager *manager) {
    sceVu0FMATRIX   lw;
    sceVu0FVECTOR   rect_max = {0.0f, 0.0f, 0.0f, 0.0f};
    sceVu0FVECTOR   rect_min = {0.0f, 0.0f, 0.0f, 0.0f};
    sceVu0FMATRIX   screen_matrix;
    mgVu0FBOX       child_rect;
    mgRENDER_INFO  *info;
    mgCFrameAttr   *draw_attr;
    mgCFrame       *frame;
    register float *corners;
    register float *matrix;
    register float *hi;
    register float *lo;
    float           left;
    float           top;
    int             billboard;
    int             visible;
    int             draw_child;

    if (manager == NULL) {
        manager = &mgDrawManager;
    }
    info = manager->render_info;

    draw_attr = attr;
    if (draw_attr == NULL) {
        draw_attr = &dmy_attr;
    }

    billboard = MG_FRAME_BILLBOARD_NONE;
    if (attr != NULL) {
        billboard = attr->billboard;
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

    if (visible) {
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
        left = 0.5f * -mgScreenWidth;
        top = 0.5f * -mgScreenHeight;
        visible = 0;
        if (rect_min[0] <= left + mgScreenWidth && rect_max[0] >= left &&
            rect_min[1] <= top + mgScreenHeight && rect_max[1] >= top && rect_max[3] >= info->clip_min[2]) {
            visible = 1;
            rect_min[0] += mgScreenWidth / 2;
            rect_max[0] += mgScreenWidth / 2;
            rect_min[1] += mgScreenHeight / 2;
            rect_max[1] += mgScreenHeight / 2;
        }
    }

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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_frame", GetDrawRect__8mgCFrameFP9mgVu0FBOXP14mgCDrawManager);
#endif

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
    return Draw((u_int *)0);
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

// Static initialiser (.init)
#ifdef NONMATCHING
// Constructs dmy_attr, from its definition at the top of the file.
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_frame", __sinit_mg_frame_cpp);
#endif

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_frame", at_307__DATA);

// Static initialiser table (.ctor)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_frame", D_0037AFE0__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_frame", __vt__8mgCFrame__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_frame", __vt__12mgCFrameBase__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_frame", __vt__9mgCObject__DATA);

// Uninitialised data (.bss)
INCLUDE_BSS(at_324, 0x10);
INCLUDE_BSS(at_341, 0x10);
INCLUDE_BSS(at_844, 0x10);
INCLUDE_BSS(dmy_attr, 0x90);
INCLUDE_BSS(at_1118, 0x10);
INCLUDE_BSS(at_1119, 0x10);
