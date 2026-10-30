#include "common.h"

#include <libvu0.h>

#include <algorithm>
#include <cmath>
#include <cstring>
#include <memory>

#include "camera_fixed.hpp"
#include "memory/tracked_copy.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mg_visual.hpp"
#include "mglib.hpp"
#include "platform/model_assets.hpp"
#include "render/renderer.hpp"
#include "render/visual_mesh.hpp"
#include "stubs/mg_frame.hpp"
#include "vu0_lanes.hpp"

void mgCFrameAttr::Initialize() {
    memset(this, 0, sizeof(mgCFrameAttr));
    mgCVisualAttr::Initialize();
    color[0] = color[1] = color[2] = color[3] = 128.0f;
    alpha_ref = -1;
    draw = MG_FRAME_DRAW_VISIBLE;
    z_write = MG_ZBUF_WRITE;
    unk_3c = 0;
    unk_20 = 100.0f;
    fog = MG_FOG_SCENE;
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
    float yy = {};
    float zz = {};
    float ww = {};
    float y = {};
    float xy = {};
    float z = {};
    float xz = {};
    float zw = {};
    float xw = {};
    float yz = {};
    float yw = {};
    float x = {};
    float w = {};
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
    return mgInsideScreen(corners, matrix, out_max, out_min);
}

int mgInsideScreen(float (*corners)[4], float (*matrix)[4]) {
    sceVu0FVECTOR max;
    sceVu0FVECTOR min;

    return mgInsideScreen(corners, matrix, max, min);
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

void mgCFrame::SetName(char *name) {
    this->name = name;
}

void mgCFrame::SetTransMatrix(float *quaternion) {
    float saved_row[4];
    changed = 1;
    std::memcpy(saved_row, trans_matrix[3], sizeof(saved_row));
    QuatToMat(quaternion, trans_matrix);
    std::memcpy(trans_matrix[3], saved_row, sizeof(saved_row));
}

void mgCFrame::SetBBox(float *max, float *min) {
    if (bound != nullptr) {
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
    if (bound == nullptr) {
        mgZeroVectorW(out_max);
        mgZeroVectorW(out_min);
    } else {
        sceVu0CopyVector(out_max, bound->max);
        sceVu0CopyVector(out_min, bound->min);
    }
}

void mgCFrame::SetBSphere(float *center, float radius) {
    if (bound != nullptr) {
        sceVu0CopyVector(bound->center, center);
        bound->radius = radius;
    }
}

mgCFrame *mgCFrame::GetFrame(int index) {
    if (index < 0 || index > this->frame_num || this->frame_list == nullptr) {
        return nullptr;
    }

    return this->frame_list[index];
}

int mgCFrame::RemakeBBox(float *out_max, float *out_min) {
    float      matrix[4][4];
    mgCVisual *frame_visual = visual;

    if (frame_visual == nullptr) {
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
    mgVu0FBOX world_box{};
    float     matrix[4][4];
    float     center[4];

    struct {
        float x;
        float y;
        float z;
        u_int w;
    } half{};

    mgVu0FBOX child_box{};
    s32       found = 0;

    if (visual != nullptr && bound != nullptr) {
        found = 1;
        GetLWMatrix(matrix);

        mgApplyMatrix(world_box.max, world_box.min, matrix, bound->max, bound->min);

        if (attr != nullptr && attr->billboard != 0) {
            float extent = {};
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

    for (mgCFrame *node = child; node != nullptr; node = node->brother) {
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

int mgCFrame::GetFrameNum() {
    s32       count = {};
    mgCFrame *node = {};
    s32       child_count = {};

    node = child;
    count = 1;

    if (node != nullptr) {
        do {
            child_count = node->GetFrameNum();
            node = node->brother;
            count += child_count;
        } while (node != nullptr);
    }

    return count;
}

void mgCFrame::SetParent(mgCFrame *parent) {
    if (this->parent == nullptr) {
        this->parent = parent;

        if (parent != nullptr) {
            parent->SetChild(this);
        }
    }
}

void mgCFrame::SetBrother(mgCFrame *new_brother) {
    if (new_brother != nullptr) {
        mgCFrame *next = brother;

        if (next != nullptr) {
            next->SetBrother(new_brother);
        } else {
            brother = new_brother;
            brother->elder = this;
        }
    }
}

void mgCFrame::SetChild(mgCFrame *new_child) {
    mgCFrame *first = {};

    if (new_child != nullptr) {
        first = child;

        if (first != nullptr) {
            first->SetBrother(new_child);
        } else {
            child = new_child;
        }

        new_child->parent = this;
    }
}

void mgCFrame::DeleteParent() {
    if (parent != nullptr) {
        if (parent->child == this) {
            parent->child = brother;
            parent = nullptr;

            if (brother != nullptr) {
                brother->elder = nullptr;
            }

            brother = nullptr;
            elder = nullptr;
        } else {
            parent = nullptr;

            if (elder != nullptr) {
                elder->brother = brother;
            }

            brother = nullptr;
            elder = nullptr;
        }
    }
}

void mgCFrame::SetReference(mgCFrame *reference) {
    if (parent == nullptr && reference != nullptr) {
        parent = reference;
        this->reference = 1;
        changed = 1;
    }
}

void mgCFrame::DeleteReference() {
    parent = nullptr;
    reference = 0;
    changed = 1;
}

void mgCFrame::ClearChildFlag() {
    mgCFrame *frame = {};
    int       flag = 1;

    if (child != nullptr) {
        child->changed = flag;
        frame = child;

        if (frame->brother != nullptr) {
            mgCFrame *next = {};

            while ((next = frame->brother) != nullptr) {
                next->changed = flag;
                frame = frame->brother;
            }

            return;
        }
    }
}

void mgCFrame::GetInverseMatrix(float (*matrix)[4]) {
    sceVu0FMATRIX lw;
    sceVu0FVECTOR translation;
    float         det = {};
    float         inv_det = {};

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
static int StrCmp(const char *left, const char *right) {
    if (left == nullptr || right == nullptr) {
        return 0;
    }

    const char *end_a = left;
    const char *end_b = right;
    s32         ch = {};
    s32         length_a = 0;
    s32         length_b = 0;

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

    const char *pa = left;
    const char *pb = right;

    for (s32 i = 0; i < length_a; i++, pa++, pb++) {
        if (*pa != *pb) {
            return 0;
        }
    }

    return 1;
}

int mgFrameNameComp(const char *left, const char *right) {
    return StrCmp(left, right);
}

mgCFrame *mgCFrame::SearchFrame(const char *name) {
    mgCFrame *found = {};
    mgCFrame *node = {};

    if (StrCmp(this->name, name) != 0) {
        return this;
    }

    for (node = child; node != nullptr; node = node->brother) {
        if ((found = node->SearchFrame(name)) != nullptr) {
            return found;
        }
    }

    return nullptr;
}

int mgCFrame::SearchFrameID(const char *name) {
    if (frame_list == nullptr) {
        return -1;
    }

    s32 index = 0;

    while (index < frame_num) {
        mgCFrame *entry = frame_list[index];

        if (entry != nullptr && StrCmp(entry->name, name) != 0) {
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

void mgCFrame::GetWorldDir(float *out_dir, float *local_dir) {
    sceVu0FMATRIX lw;
    float         w = {};

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

    if (dst != nullptr) {
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
                std::memcpy(this->attr->color, attr.color, sizeof(attr.color));
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

    if (frame != nullptr) {
        do {
            frame->SetAttrParam(attr, 1, mask);
            frame = frame->brother;
        } while (frame != nullptr);
    }
}

void mgCFrame::SetAttrParamObjAlpha(float alpha, int recurse) {
    if (attr != nullptr) {
        this->attr->obj_alpha = alpha;
    }

    if (recurse == 0) {
        return;
    }

    mgCFrame *frame = child;

    if (frame != nullptr) {
        do {
            frame->SetAttrParamObjAlpha(alpha, 1);
            frame = frame->brother;
        } while (frame != nullptr);
    }
}

void mgCFrame::SetAttrParamDraw(int value, int recurse) {
    mgCFrameAttr *attr = {};
    mgCFrame     *node = {};

    attr = this->attr;

    if (attr != nullptr) {
        this->attr->draw = value;
    }

    if (recurse == 0) {
        return;
    }

    for (node = child; node != nullptr; node = node->brother) {
        node->SetAttrParamDraw(value, 1);
    }
}

mgCFrame &mgCFrame::operator=(mgCFrame &other) {
    dc2::memory::CopyTrackedBytes(this, &other, sizeof(mgCFrame));
    parent = child = brother = nullptr;
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
    return Draw(nullptr);
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

void mgCObject::SetPosition(float *input) {
    // Position consumes xyz; the stored homogeneous lane is always one.
    // Some callers provide exactly three floats.
    if (position[0] != input[0] || position[1] != input[1] || position[2] != input[2]) {
        use_srt = 1;
        position[0] = input[0];
        position[1] = input[1];
        position[2] = input[2];
        position[3] = 1.0f;
        changed = 1;
    }
}

void mgCFrame::GetWorldPosition0(float *out_position) {
    sceVu0FMATRIX world;
    GetLWMatrix(world);
    // Callers may store vectors at the natural alignment of host pointers.
    std::memcpy(out_position, world[3], sizeof(world[3]));
}

int mgCFrame::Draw(unsigned int *packet) {
    mgRENDER_INFO *info = &mgRenderInfo;
    int            words = 0;
    sceVu0FMATRIX  world;

    if (attr == nullptr) {
        GetLWMatrixTopBottom(world);
    } else {
        if (attr->billboard != 0) {
            GetBBoardMatrix(attr->billboard, world, info);
        } else {
            GetLWMatrixTopBottom(world);
        }

        while (attr != nullptr && (attr->draw & MG_FRAME_DRAW_VISIBLE)) {
            if (visual == nullptr) {
                break;
            }

            if (!attr->no_cull && bound != nullptr) {
                sceVu0FVECTOR box_max;
                sceVu0FVECTOR box_min;
                test1(bound->corner, info->world_screen_rel, world, box_max, box_min);

                if (box_max[3] < info->clip_min[2]) {
                    break;
                }

                test2(box_max, box_min);

                const mgPortExtent extent = mgPortVisibleExtent();
                const float        centre_x = 0.5f * static_cast<float>(mgScreenWidth);
                const float        centre_y = 0.5f * static_cast<float>(mgScreenHeight);
                float              visible_max[4] = {extent.right - centre_x, extent.bottom - centre_y, info->screen_box_max[2],
                                                     info->screen_box_max[3]};
                float              visible_min[4] = {extent.left - centre_x, extent.top - centre_y, info->screen_box_min[2],
                                                     info->screen_box_min[3]};

                if (TownMouseFixedOwner()) {
                    const float radius = MouseFixedCullRadius(info->projection,
                                                              info->projection * std::fabs(info->aspect[1][1]),
                                                              std::max(std::fabs(visible_min[0]), std::fabs(visible_max[0])),
                                                              std::max(std::fabs(visible_min[1]), std::fabs(visible_max[1])));
                    visible_min[0] = visible_min[1] = -radius;
                    visible_max[0] = visible_max[1] = radius;
                }
                if (!mgClipBoxW(box_max, box_min, visible_max, visible_min)) {
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

            if (info->plight_enable && attr->point_light && !attr->no_light && bound != nullptr) {
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

                for (auto &i : light->point_light) {
                    if (!(i.power <= 0.0f)) {
                        float reach = radius + i.range;

                        if (!(reach <= mgDistVector(i.pos, center))) {
                            info->plight_hit = 1;
                            break;
                        }
                    }
                }
            }

            {
                mgVisualPortObjectScope object_scope(this);
                words += visual->Draw(packet, world, nullptr);
            }
            break;
        }

        if (attr != nullptr && (attr->draw & MG_FRAME_DRAW_SKIP_CHILDREN)) {
            return words;
        }
    }

    for (mgCFrame *node = child; node != nullptr; node = node->brother) {
        if (node->attr == nullptr || !(node->attr->draw & MG_FRAME_DRAW_SKIP_BY_PARENT)) {
            words += node->Draw(packet != nullptr ? packet + words * 4 : nullptr);
        }
    }

    return words;
}

namespace {

// The VU0 registers vf10-vf17 as test1 leaves them: the transformed corners that test2 divides.
float vu_corners[8][4];

mgCFrameAttr dmy_attr;

void MulMatrices(float (*out)[4], const float (*lhs)[4], const float (*rhs)[4]) {
    float product[4][4];

    for (int i = 0; i < 4; i++) {
        vu0::Transform(product[i], rhs, lhs[i]);
    }

    std::memcpy(out, product, sizeof(product));
}

void TransformCorners(float (*out)[4], const float (*corners)[4], const float (*m)[4]) {
    float result[8][4];

    for (int c = 0; c < 8; c++) {
        vu0::Transform(result[c], m, corners[c]);
    }

    std::memcpy(out, result, sizeof(result));
}

// Rows 0-2 are scaled column by column; the translation row is kept as it is.
void ScaleColumns(float (*out)[4], const float (*in)[4], const float *s) {
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 4; j++) {
            out[i][j] = in[i][j] * s[j];
        }
    }

    for (int j = 0; j < 4; j++) {
        out[3][j] = in[3][j];
    }
}

void DivideByW(float (*out)[4], const float (*in)[4]) {
    for (int c = 0; c < 8; c++) {
        float q = vu0::Div(1.0f, std::fabs(in[c][3]));
        out[c][0] = vu0::Sat(in[c][0] * q);
        out[c][1] = vu0::Sat(in[c][1] * q);
        out[c][2] = in[c][2];
        out[c][3] = in[c][3];
    }
}

void BoxOf(const float (*corners)[4], float *out_max, float *out_min) {
    for (int lane = 0; lane < 4; lane++) {
        float hi = corners[0][lane];
        float lo = hi;

        for (int c = 1; c < 8; c++) {
            hi = vu0::Max(hi, corners[c][lane]);
            lo = vu0::Min(lo, corners[c][lane]);
        }

        out_max[lane] = hi;
        out_min[lane] = lo;
    }
}

} // namespace

void test1(float (*corners)[4], float (*screen)[4], float (*matrix)[4], float *out_max, float *out_min) {
    float product[4][4];

    MulMatrices(product, matrix, screen);
    TransformCorners(vu_corners, corners, product);
    BoxOf(vu_corners, out_max, out_min);
}

void test2(float *out_max, float *out_min) {
    float divided[8][4];

    DivideByW(divided, vu_corners);
    BoxOf(divided, out_max, out_min);
}

int mgInsideScreen(float (*corners)[4], float (*matrix)[4], float *out_max, float *out_min) {
    mgRENDER_INFO *render_info = &mgRenderInfo;
    float          product[4][4];
    float          transformed[8][4];
    float          divided[8][4];

    MulMatrices(product, matrix, render_info->world_screen_rel);
    TransformCorners(transformed, corners, product);
    DivideByW(divided, transformed);
    BoxOf(divided, out_max, out_min);

    return mgClipBoxW(out_max, out_min, render_info->screen_box_max, render_info->screen_box_min);
}

void mgCFrame::GetLocalMatrix(float (*matrix)[4]) {
    if (use_srt) {
        if (model_assets::UsesStandardScaleOrder(this)) {
            for (int column = 0; column < 3; ++column) {
                for (int row = 0; row < 4; ++row) {
                    matrix[column][row] = trans_matrix[column][row] * scale[column];
                }
            }
            sceVu0CopyVector(matrix[3], trans_matrix[3]);
        } else {
            ScaleColumns(matrix, trans_matrix, scale);
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

void mgCFrame::Initialize() {
    clone_inputs = {};
    model_assets::ForgetFrame(this);
    elder = brother = child = parent = nullptr;
    sceVu0UnitMatrix(lw_matrix);
    sceVu0UnitMatrix(trans_matrix);
    name = nullptr;
    rot_type = 0;
    reference = 0;
    visual = nullptr;
    attr = nullptr;
    frame_num = 0;
    frame_list = nullptr;
    init_matrix = nullptr;
    bound = nullptr;
    mgCObject::Initialize();
}

void mgCFrame::GetBBoardMatrix(int mode, float (*matrix)[4], mgRENDER_INFO *info) {
    float position[4];
    float to_eye[4];
    // The w lane is never set; zero matches the scale vector's own convention and keeps the matrix's w column clear.
    float scale[4] = {0.0f, 0.0f, 0.0f, 0.0f};
    float world[4][4];
    float pitch[4][4];
    GetLWMatrix(world);
    scale[0] = mgDistVector(world[0]);
    scale[1] = mgDistVector(world[0]);
    scale[2] = mgDistVector(world[0]);
    std::memcpy(position, world[3], sizeof(position));
    sceVu0UnitMatrix(matrix);

    if (mode & 2) {
        sceVu0SubVector(matrix[2], info->camera_pos, position);
        matrix[2][1] = 0.0f;
        matrix[2][3] = 0.0f;
        sceVu0Normalize(matrix[2], matrix[2]);
        matrix[0][0] = matrix[2][2];
        matrix[0][2] = -matrix[2][0];
    }

    if (mode & 1) {
        sceVu0UnitMatrix(pitch);
        sceVu0SubVector(to_eye, info->camera_pos, position);
        sceVu0Normalize(to_eye, to_eye);
        float eye_y = to_eye[1];
        to_eye[3] = 0.0f;
        to_eye[1] = 0.0f;
        float horizontal = mgDistVector(to_eye);
        pitch[1][1] = horizontal;
        pitch[2][2] = horizontal;
        pitch[1][2] = -eye_y;
        pitch[2][1] = eye_y;
        sceVu0SubVector(matrix[2], info->camera_pos, position);
        matrix[2][1] = 0.0f;
        matrix[2][3] = 0.0f;
        sceVu0Normalize(matrix[2], matrix[2]);
        matrix[0][0] = matrix[2][2];
        matrix[0][2] = -matrix[2][0];
        mgMulMatrix(matrix, matrix, pitch);
    }

    ScaleColumns(matrix, matrix, scale);
    matrix[3][0] = position[0];
    matrix[3][1] = position[1];
    matrix[3][2] = position[2];
    sceVu0CopyMatrix(lw_matrix, matrix);
    changed = 0;
    ClearChildFlag();
}

void mgCFrame::GetLWMatrix(float (*matrix)[4]) {
    float parent_matrix[4][4];
    float local_matrix[4][4];

    if (reference != 0) {
        changed = 1;
    }

    if (changed == 0) {
        // The cached matrix holds unless an ancestor has changed.
        const mgCFrame *node = parent;
        while (node != nullptr && node->changed == 0) {
            node = node->parent;
        }
        if (node == nullptr) {
            sceVu0CopyMatrix(matrix, lw_matrix);
            return;
        }
    }

    ClearChildFlag();
    GetLocalMatrix(local_matrix);

    if (parent == nullptr) {
        sceVu0CopyMatrix(lw_matrix, local_matrix);
        sceVu0CopyMatrix(matrix, lw_matrix);
    } else {
        parent->GetLWMatrix(parent_matrix);
        MulMatrices(lw_matrix, local_matrix, parent_matrix);
        std::memcpy(matrix, lw_matrix, sizeof(float[4][4]));
    }
    changed = 0;
}

void mgCFrame::GetLWMatrixTopBottom(float (*matrix)[4]) {
    float parent_matrix[4][4];
    float local_matrix[4][4];

    if (reference != 0) {
        GetLWMatrix(matrix);
        return;
    }

    if (changed == 0) {
        mgCFrame *parent_frame = parent;

        if (parent_frame == nullptr) {
            sceVu0CopyMatrix(matrix, lw_matrix);
            return;
        }

        if (parent_frame->changed == 0) {
            sceVu0CopyMatrix(matrix, lw_matrix);
            return;
        }
    }

    ClearChildFlag();
    GetLocalMatrix(local_matrix);
    mgCFrame *parent = this->parent;

    if (parent == nullptr) {
        sceVu0CopyMatrix(lw_matrix, local_matrix);
        sceVu0CopyMatrix(matrix, lw_matrix);
    } else {
        sceVu0CopyMatrix(parent_matrix, parent->lw_matrix);
        MulMatrices(lw_matrix, local_matrix, parent_matrix);
        std::memcpy(matrix, lw_matrix, sizeof(float[4][4]));
    }

    changed = 0;
}

int mgCFrame::GetDrawRect(mgVu0FBOX *rect, mgCDrawManager *manager) {
    if (manager == nullptr) {
        manager = &mgDrawManager;
    }

    mgRENDER_INFO      *info = manager->render_info;
    const mgCFrameAttr *draw_attr = attr != nullptr ? attr : &dmy_attr;
    sceVu0FMATRIX       lw;

    if (attr != nullptr && attr->billboard != MG_FRAME_BILLBOARD_NONE) {
        GetBBoardMatrix(attr->billboard, lw, info);
    } else {
        GetLWMatrixTopBottom(lw);
    }

    sceVu0FVECTOR rect_max = {0.0f, 0.0f, 0.0f, 0.0f};
    sceVu0FVECTOR rect_min = {0.0f, 0.0f, 0.0f, 0.0f};
    int           visible = (draw_attr->draw & MG_FRAME_DRAW_VISIBLE) && visual != nullptr && bound != nullptr;

    if (visible) {
        sceVu0FMATRIX screen_matrix;
        float         transformed[8][4];
        float         divided[8][4];
        mgMulMatrix(screen_matrix, info->world_screen_rel, lw);
        TransformCorners(transformed, bound->corner, screen_matrix);
        DivideByW(divided, transformed);
        BoxOf(divided, rect_max, rect_min);

        // Cull against what the target shows, not the 4:3 screen: a wider window shows more at the sides.
        const mgPortExtent extent = mgPortVisibleExtent();
        const float        left = extent.left - 0.5f * mgScreenWidth;
        const float        top = extent.top - 0.5f * mgScreenHeight;
        const float        right = extent.right - 0.5f * mgScreenWidth;
        const float        bottom = extent.bottom - 0.5f * mgScreenHeight;
        visible = rect_min[0] <= right && rect_max[0] >= left && rect_min[1] <= bottom && rect_max[1] >= top &&
                  rect_max[3] >= info->clip_min[2];

        if (visible) {
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

    for (mgCFrame *frame = child; frame != nullptr; frame = frame->brother) {
        mgVu0FBOX child_rect{};
        if ((frame->attr == nullptr || !(frame->attr->draw & MG_FRAME_DRAW_SKIP_BY_PARENT)) &&
            frame->GetDrawRect(&child_rect, nullptr)) {
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

namespace dc2::render {
namespace {
/**
 * Holds immutable identities of a frame's clone-only render payloads.
 */
struct FrameCloneState {
    dc2::memory::ArenaBuffer object;          /**< Exact producer frame allocation. */
    mgCFrameAttr            *attr = nullptr;  /**< Expected attribute object identity. */
    mgCFrame::BoundInfo     *bound = nullptr; /**< Expected bound object identity. */
    dc2::memory::ArenaBuffer attr_storage;    /**< Exact attribute allocation. */
    dc2::memory::ArenaBuffer bound_storage;   /**< Exact bounding volume allocation. */
};
} // namespace

bool FrameCloneInputs::Publish(mgCMemory &producer, mgCFrame &frame, const VisualCloneInputs &visual) {
    frame.clone_inputs = {};
    try {
        auto value = std::make_shared<FrameCloneState>();
        value->object = dc2::memory::ArenaBuffer::Bind(producer, {reinterpret_cast<u8 *>(&frame), sizeof(frame)});
        if (value->object.Bytes().size() != sizeof(frame)) {
            return false;
        }
        value->attr = frame.attr;
        value->bound = frame.bound;
        if (frame.attr != nullptr) {
            value->attr_storage = dc2::memory::ArenaBuffer::Bind(producer, {reinterpret_cast<u8 *>(frame.attr), sizeof(*frame.attr)});
            if (value->attr_storage.Bytes().size() != sizeof(*frame.attr)) {
                return false;
            }
        }
        if (frame.bound != nullptr) {
            value->bound_storage = dc2::memory::ArenaBuffer::Bind(producer, {reinterpret_cast<u8 *>(frame.bound), sizeof(*frame.bound)});
            if (value->bound_storage.Bytes().size() != sizeof(*frame.bound)) {
                return false;
            }
        }
        if (frame.visual != nullptr && !visual.Matches(frame.visual)) {
            return false;
        }
        frame.clone_inputs.state = dc2::memory::ArenaResource::Store(value->object, value);
        frame.clone_inputs.expected_visual = frame.visual;
        frame.clone_inputs.visual_inputs = visual;
        return frame.clone_inputs.Matches(frame);
    } catch (const std::bad_alloc &) {
        return false;
    }
}

bool FrameCloneInputs::PublishChanges(mgCFrame &frame, mgCMemory *attr_producer, const VisualCloneInputs *replacement_visual) const {
    const auto previous = state.Acquire<FrameCloneState>();
    if (!previous) {
        return false;
    }
    const auto object = previous->object.Bytes();
    if (object.size() != sizeof(frame) || object.data() != reinterpret_cast<const u8 *>(&frame) || frame.bound != previous->bound ||
        (frame.bound != nullptr && previous->bound_storage.Bytes().size() != sizeof(*frame.bound))) {
        return false;
    }
    if (attr_producer == nullptr && (frame.attr != previous->attr || (frame.attr != nullptr && previous->attr_storage.Bytes().size() != sizeof(*frame.attr)))) {
        return false;
    }
    if (replacement_visual == nullptr && (frame.visual != expected_visual || (frame.visual != nullptr && !visual_inputs.Matches(frame.visual)))) {
        return false;
    }
    if (replacement_visual != nullptr && frame.visual != nullptr && !replacement_visual->Matches(frame.visual)) {
        return false;
    }
    auto result = *this;
    if (replacement_visual != nullptr) {
        result.expected_visual = frame.visual;
        result.visual_inputs = *replacement_visual;
    }
    if (attr_producer == nullptr) {
        // Visual transitions reuse the exact frame payload metadata without retaining another resource.
        frame.clone_inputs = result;
        return result.Matches(frame);
    }
    frame.clone_inputs = {};
    try {
        auto value = std::make_shared<FrameCloneState>(*previous);
        value->attr = frame.attr;
        value->attr_storage = {};
        if (frame.attr != nullptr) {
            value->attr_storage = dc2::memory::ArenaBuffer::Bind(*attr_producer, {reinterpret_cast<u8 *>(frame.attr), sizeof(*frame.attr)});
            if (value->attr_storage.Bytes().size() != sizeof(*frame.attr)) {
                return false;
            }
        }
        result.state = dc2::memory::ArenaResource::Store(value->object, value);
        frame.clone_inputs = result;
        return result.Matches(frame);
    } catch (const std::bad_alloc &) {
        return false;
    }
}

bool FrameCloneInputs::SharesPayloadMetadata(const FrameCloneInputs &other) const {
    const auto value = state.Acquire<FrameCloneState>();
    return value != nullptr && value == other.state.Acquire<FrameCloneState>();
}

bool FrameCloneInputs::Matches(const mgCFrame &frame) const {
    if (!state.HasValue()) {
        return frame.attr == nullptr && frame.bound == nullptr && frame.visual == nullptr;
    }
    const auto value = state.Acquire<FrameCloneState>();
    if (!value) {
        return false;
    }
    const auto object = value->object.Bytes();
    if (object.size() != sizeof(frame) || object.data() != reinterpret_cast<const u8 *>(&frame)) {
        return false;
    }
    if (frame.attr != value->attr || frame.bound != value->bound || frame.visual != expected_visual) {
        return false;
    }
    if (frame.attr != nullptr && value->attr_storage.Bytes().size() != sizeof(*frame.attr)) {
        return false;
    }
    if (frame.bound != nullptr && value->bound_storage.Bytes().size() != sizeof(*frame.bound)) {
        return false;
    }
    return frame.visual == nullptr || visual_inputs.Matches(frame.visual);
}
} // namespace dc2::render
