#include "common.h"

#include <libvu0.h>

#include <cmath>
#include <cstdio>
#include <cstring>

#include "dng_main.hpp"
#include "font.hpp"
#include "gameutil.hpp"
#include "intersection.hpp"
#include "mg_camera.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_visual.hpp"
#include "mglib.hpp"

// Storage of the assembly-supplied MotionProc2.
#ifndef NONMATCHING
/**
 *
 * Vertex buffer used by the skinning pass.
 *
 */
static sceVu0FVECTOR *vert_845;

/**
 *
 * Scratch transform of the skinning frame.
 *
 */
static sceVu0FMATRIX tmp_SkinMatrix_847;

/**
 *
 * Inverse world transform of the skinning frame.
 *
 */
static sceVu0FMATRIX tmp_SkinMatrix_inv_848;

/**
 *
 * World transform of the animation root.
 *
 */
static sceVu0FMATRIX tmp_ChrMatrix_849;

/**
 *
 * Bind-pose skinning transform.
 *
 */
static sceVu0FMATRIX tmp_BaseSkinMatrix_851;

/**
 *
 * Inverse bind-pose skinning transform.
 *
 */
static sceVu0FMATRIX tmp_BaseSkinMatrix_inv_852;
#endif

static mgCFrame *OldSkinFrame;

struct CCPolyCopy {
    float vertex[3][4];
    float normal[4];
    float attr[4];
};

float def_vrtx[800][4];

static float def_nml[1][4];

// Code (.text)
/**
 *
 * Blends rotation quaternion keys and writes the resulting rotation.
 *
 */
static void QuatSlerp(float *q0, float *q1, float t, float *out) {
    float cos_theta;
    float scale0;
    float scale1;
    float theta;
    float inv_sin;

    cos_theta = (q0[3] * q1[3]) + ((q0[1] * q1[1]) + (q0[2] * q1[2])) + (q0[0] * q1[0]);
    scale1 = t;

    if (cos_theta < 0.0f) {
        q1[0] = -q1[0];
        cos_theta = -cos_theta;
        q1[1] = -q1[1];
        q1[2] = -q1[2];
        q1[3] = -q1[3];
    }

    if (cos_theta < 0.01f) {
        out[1] = q1[1];
        out[2] = q1[2];
        out[3] = q1[3];
        out[0] = q1[0];
    } else {
        if (!((1.0f - cos_theta) <= 0.01f)) {
            theta = acosf(cos_theta);
            inv_sin = 1.0f / sinf(theta);
            scale0 = inv_sin * sinf((1.0f - scale1) * theta);
            scale1 = inv_sin * sinf(scale1 * theta);
        } else {
            scale0 = 1.0f - scale1;
        }

        out[1] = (scale0 * q0[1]) + (scale1 * q1[1]);
        out[2] = (scale0 * q0[2]) + (scale1 * q1[2]);
        out[3] = (scale0 * q0[3]) + (scale1 * q1[3]);
        out[0] = (scale0 * q0[0]) + (scale1 * q1[0]);
    }
}

Mot_List *MotionProc(mgCFrame *root, float time, Mot_List *list, mgCCamera *camera) {
    unsigned int frame_no = (unsigned int) time;
    int          high;
    int          low;
    int          middle;
    unsigned int count = list->key_count;
    low = 0;
    high = count;
    int            next;
    mgCFrame      *frame;
    unsigned int   vertex;
    int            driven;
    int            key;
    sceVu0FVECTOR *vertices;
    unsigned int   key_frame;
    float          t;
    float          one_minus_t;
    float          value[4];
    float          rotation[4];
    float          from[4];
    float          to[4];

    if (low < high) {
        do {
            middle = (low + high) >> 1;

            if (list->key_frames[middle] <= frame_no) {
                low = middle + 1;
            } else {
                high = middle;
            }
        } while (low < high);
    }

    key = low - 1;
    next = key + 1;

    if (next > count - 1) {
        next = key;
    }

    key_frame = list->key_frames[key];
    t = (time - (float) key_frame) / (float) (list->key_frames[next] - key_frame);
    frame = root->GetFrame(list->frame);

    switch (list->type) {
        case MOTION_KEY_ROTATION:
            sceVu0CopyVector(from, list->values[key]);
            sceVu0CopyVector(to, list->values[next]);

            if (!(t <= 0.001f) && t < 0.999f) {
                QuatSlerp(list->values[key], list->values[next], t, rotation);
                frame->SetTransMatrix(rotation);
            } else {
                if (t <= 0.001f) {
                    frame->SetTransMatrix(from);
                }

                if (!(t < 0.999f)) {
                    frame->SetTransMatrix(to);
                }
            }

            break;
        case MOTION_KEY_SCALE:
            if (!(t <= 0.001f) && t < 0.999f) {
                sceVu0InterVectorXYZ(value, list->values[next], list->values[key], t);
            } else {
                if (t <= 0.001f) {
                    sceVu0CopyVectorXYZ(value, list->values[key]);
                }

                if (!(t < 0.999f)) {
                    sceVu0CopyVectorXYZ(value, list->values[next]);
                }
            }

            frame->SetScale(value[0], value[1], value[2]);
            break;
        case MOTION_KEY_TRANSLATION:
            if (!(t <= 0.001f) && t < 0.999f) {
                sceVu0InterVectorXYZ(value, list->values[next], list->values[key], t);
            } else {
                if (t <= 0.001f) {
                    sceVu0CopyVectorXYZ(value, list->values[key]);
                }

                if (!(t < 0.999f)) {
                    sceVu0CopyVectorXYZ(value, list->values[next]);
                }
            }

            frame->trans_matrix[3][0] = value[0];
            frame->trans_matrix[3][1] = value[1];
            frame->trans_matrix[3][2] = value[2];
            frame->changed = 1;
            break;
        case MOTION_KEY_VERTEX: {
            driven = list->frame;
            vertices = ((mgCVisualMDT *) frame->visual)->vertex;

            do {
                if (!(t <= 0.001f) && t < 0.999f) {
                    Mot_List *node = list;

                    while (driven == node->frame) {
                        vertex = (unsigned int) list->target - 1;
                        sceVu0InterVectorXYZ(value, list->values[next], list->values[key], t);
                        sceVu0CopyVectorXYZ(vertices[vertex], value);
                        list = list->next;

                        if (list != NULL) {
                            node = list;
                        } else {
                            return NULL;
                        }
                    }

                    break;
                }

                if (t <= 0.001f) {
                    Mot_List *node = list;

                    while (driven == node->frame) {
                        sceVu0CopyVectorXYZ(vertices[list->target - 1], list->values[key]);
                        list = list->next;

                        if (list != NULL) {
                            node = list;
                        } else {
                            return NULL;
                        }
                    }
                }

                if (!(t < 0.999f)) {
                    Mot_List *node = list;

                    while (driven == node->frame) {
                        sceVu0CopyVectorXYZ(vertices[list->target - 1], list->values[next]);
                        list = list->next;

                        if (list != NULL) {
                            node = list;
                        } else {
                            return NULL;
                        }
                    }
                }
            } while (0);

            return list;
        }
        case MOTION_KEY_CAMERA_POSITION:
            if (camera != NULL) {
                sceVu0InterVectorXYZ(value, list->values[next], list->values[key], t);
                root->GetWorldPosition(value, value);
                camera->SetPos(value[0], value[1], value[2]);
            }

            break;
        case MOTION_KEY_CAMERA_TARGET:

            if (camera != NULL) {
                root->GetWorldPosition(value, value);
                camera->SetRef(value[0], value[1], value[2]);
            }

            break;
        case MOTION_KEY_MATERIAL_ALPHA: {
            one_minus_t = 1.0f - t;
            mgMaterial *materials = frame->visual->GetpMaterial();

            materials[list->target].diffuse[3] = 1.0f - (one_minus_t * list->values[key][0] + t * list->values[next][0]);
            break;
        }
        case MOTION_KEY_MATERIAL_COLOR: {
            mgMaterial *materials = frame->visual->GetpMaterial();

            sceVu0InterVectorXYZ(materials[list->target].diffuse, list->values[next], list->values[key], t);
            frame->attr->unk_28 = 2;
            break;
        }
        case MOTION_KEY_CAMERA_ROLL:
            if (camera != NULL) {
                one_minus_t = 1.0f - t;
                camera->SetRoll(-((one_minus_t * list->values[key][0] + t * list->values[next][0]) / 180.0f * 3.1415927f));
            }

            break;
        case MOTION_KEY_CAMERA_FOV:
            if (camera != NULL) {
                one_minus_t = 1.0f - t;
                mgSetProjection(1.0f / tanf((one_minus_t * list->values[key][0] + t * list->values[next][0]) * 0.5f / 180.0f * 3.1415927f) * 480.0f * 0.5f);
            }

            break;
        case MOTION_KEY_VISIBLE:
            if (list->values[key][0] < 1.0f) {
                frame->attr->draw = 0;
            } else {
                frame->attr->draw = MG_FRAME_DRAW_VISIBLE | MG_FRAME_DRAW_SKIP_CHILDREN;
            }

            break;
        case MOTION_KEY_VISIBLE_TREE:
            if (list->values[key][0] < 1.0f) {
                frame->attr->draw = MG_FRAME_DRAW_SKIP_CHILDREN;
            } else {
                frame->attr->draw = MG_FRAME_DRAW_VISIBLE;
            }

            break;
    }

    return list->next;
}

Mot_List *MotionProc(mgCFrame *root, unsigned int from_frame, unsigned int to_frame, float blend, Mot_List *list, mgCCamera *camera) {
    int       high;
    int       low;
    int       key;
    int       next;
    mgCFrame *frame;
    float     one_minus_blend;
    float     value[4];
    float     rotation[4];
    float     from[4];
    float     to[4];
    {
        int high = list->key_count;
        int low = 0;
        int middle;

        while (low < high) {
            key = (middle = (low + high) >> 1);

            if (list->key_frames[key] <= from_frame) {
                low = key + 1;
            } else {
                high = key;
            }
        }

        key = low - 1;
    }
    {
        high = list->key_count;
        low = 0;

        while (low < high) {
            next = (low + high) >> 1;

            if (list->key_frames[next] <= to_frame) {
                low = next + 1;
            } else {
                high = next;
            }
        }

        next = low - 1;
    }
    frame = root->GetFrame(list->frame);

    switch (list->type) {
        case MOTION_KEY_ROTATION:
            sceVu0CopyVector(from, list->values[key]);
            sceVu0CopyVector(to, list->values[next]);

            if (!(blend <= 0.0001f) && blend < 0.9999f) {
                QuatSlerp(from, to, blend, rotation);
                frame->SetTransMatrix(rotation);
            } else {
                if (blend <= 0.0001f) {
                    frame->SetTransMatrix(from);
                }

                if (!(blend < 0.9999f)) {
                    frame->SetTransMatrix(to);
                }
            }

            break;
        case MOTION_KEY_SCALE:
            sceVu0InterVectorXYZ(value, list->values[next], list->values[key], blend);
            frame->SetScale(value[0], value[1], value[2]);
            break;
        case MOTION_KEY_TRANSLATION:
            sceVu0InterVectorXYZ(value, list->values[next], list->values[key], blend);
            frame->trans_matrix[3][0] = value[0];
            frame->trans_matrix[3][1] = value[1];
            frame->trans_matrix[3][2] = value[2];
            frame->changed = 1;
            break;
        case MOTION_KEY_VERTEX: {
            int            vertex;
            int            driven = list->frame;
            sceVu0FVECTOR *vertices = ((mgCVisualMDT *) frame->visual)->vertex;

            do {
                if (!(blend <= 0.0001f) && blend < 0.9999f) {
                    Mot_List *node = list;

                    while (driven == node->frame) {
                        vertex = list->target - 1;
                        sceVu0InterVectorXYZ(value, list->values[next], list->values[key], blend);
                        sceVu0CopyVectorXYZ(vertices[vertex], value);
                        list = list->next;

                        do {
                            if (list == NULL) {
                                break;
                            }

                            node = list;
                            goto blend_nonnull0;
                        } while (0);

                        return NULL;
                    blend_nonnull0:;
                    }

                    break;
                }

                if (blend <= 0.0001f) {
                    Mot_List *node = list;

                    while (driven == node->frame) {
                        sceVu0CopyVectorXYZ(vertices[list->target - 1], list->values[key]);
                        list = list->next;

                        do {
                            if (list == NULL) {
                                break;
                            }

                            node = list;
                            goto blend_nonnull1;
                        } while (0);

                        return NULL;
                    blend_nonnull1:;
                    }
                }

                if (!(blend < 0.9999f)) {
                    Mot_List *node = list;

                    while (driven == node->frame) {
                        sceVu0CopyVectorXYZ(vertices[list->target - 1], list->values[next]);
                        list = list->next;

                        do {
                            if (list == NULL) {
                                break;
                            }

                            node = list;
                            goto blend_nonnull2;
                        } while (0);

                        return NULL;
                    blend_nonnull2:;
                    }
                }
            } while (0);

            return list;
        }
        case MOTION_KEY_CAMERA_POSITION:
            if (camera != NULL) {
                sceVu0InterVectorXYZ(value, list->values[next], list->values[key], blend);
                root->GetWorldPosition(value, value);
                camera->SetPos(value[0], value[1], value[2]);
            }

            break;
        case MOTION_KEY_CAMERA_TARGET:
            if (camera != NULL) {
                sceVu0InterVectorXYZ(value, list->values[next], list->values[key], blend);
                root->GetWorldPosition(value, value);
                camera->SetRef(value[0], value[1], value[2]);
            }

            break;
        case MOTION_KEY_MATERIAL_ALPHA: {
            one_minus_blend = 1.0f - blend;
            mgMaterial *materials = frame->visual->GetpMaterial();

            materials[list->target].diffuse[3] = 1.0f - (one_minus_blend * list->values[key][0] + blend * list->values[next][0]);
            frame->attr->unk_28 = 2;
            break;
        }
        case MOTION_KEY_MATERIAL_COLOR: {
            mgMaterial *materials = frame->visual->GetpMaterial();

            sceVu0InterVectorXYZ(materials[list->target].diffuse, list->values[next], list->values[key], blend);
            frame->attr->unk_28 = 2;
            break;
        }
        case MOTION_KEY_CAMERA_ROLL:
            if (camera != NULL) {
                one_minus_blend = 1.0f - blend;
                camera->SetRoll(-((one_minus_blend * list->values[key][0] + blend * list->values[next][0]) / 180.0f * 3.1415927f));
            }

            break;
        case MOTION_KEY_CAMERA_FOV:
            if (camera != NULL) {
                one_minus_blend = 1.0f - blend;
                mgSetProjection(1.0f / tanf((one_minus_blend * list->values[key][0] + blend * list->values[next][0]) * 0.5f / 180.0f * 3.1415927f) * 480.0f * 0.5f);
            }

            break;
        case MOTION_KEY_VISIBLE:
            if (list->values[key][0] < 1.0f) {
                frame->attr->draw = 0;
            } else {
                frame->attr->draw = MG_FRAME_DRAW_VISIBLE | MG_FRAME_DRAW_SKIP_CHILDREN;
            }

            break;
        case MOTION_KEY_VISIBLE_TREE:
            if (list->values[key][0] < 1.0f) {
                frame->attr->draw = MG_FRAME_DRAW_SKIP_CHILDREN;
            } else {
                frame->attr->draw = MG_FRAME_DRAW_VISIBLE;
            }

            break;
    }

    return list->next;
}

#pragma global_optimizer off

/**
 *
 * Accumulates a weighted transformed vertex and writes the resulting vertex.
 *
 */
static void testVUnew(float (*matrix)[4], float *vertex, float *weight, float *accum, float *out) {
    asm {
        lqc2 vf4, 0(matrix)
        lqc2 vf5, 0x10(matrix)
        lqc2 vf6, 0x20(matrix)
        lqc2 vf7, 0x30(matrix)
        lqc2 vf8, 0(vertex)
        vmulax.xyzw ACC, vf4, vf8x
        vmadday.xyzw ACC, vf5, vf8y
        vmaddaz.xyzw ACC, vf6, vf8z
        vmaddw.xyzw vf12, vf7, vf8w
        lqc2 vf4, 0(accum)
        lqc2 vf5, 0(weight)
        vmulx.xyz vf6, vf12, vf5x
        vadd.xyzw vf6, vf4, vf6
        sqc2 vf6, 0(accum)
        sqc2 vf6, 0(out)
    }
}

#pragma global_optimizer reset

#ifdef NONMATCHING
Mot_List *MotionProc2(mgCFrame *root, tagMOTION_TYPE *motion, tagFRAME_INF *frame_info, Mot_List *list) {
    static sceVu0FVECTOR *vert;
    static sceVu0FMATRIX  tmp_SkinMatrix;
    static sceVu0FMATRIX  tmp_SkinMatrix_inv;
    static sceVu0FMATRIX  tmp_ChrMatrix;
    static sceVu0FMATRIX  tmp_BaseSkinMatrix;
    static sceVu0FMATRIX  tmp_BaseSkinMatrix_inv;
    mgCFrame             *bone;
    mgCFrame             *skin;
    tagFRAME_INF         *info;
    sceVu0FMATRIX         bone_matrix;
    sceVu0FMATRIX         bone_base;
    sceVu0FMATRIX         bone_in_skin;
    sceVu0FMATRIX         bone_in_skin_inv;
    sceVu0FMATRIX         skin_bone;
    sceVu0FMATRIX         deform;
    sceVu0FVECTOR         moved;
    sceVu0FVECTOR         weight;
    unsigned int          i;
    int                   vertex;

    if (list->key_count == 0) {
        return list->next;
    }

    bone = root->GetFrame(list->target);
    skin = root->GetFrame(list->frame);
    info = &frame_info[list->frame];

    if (OldSkinFrame != skin) {
        OldSkinFrame = root->GetFrame(list->frame);
        vert = ((mgCVisualMDT *) skin->visual)->vertex;

        for (vertex = 0; vertex < (int) info->vertex_count; vertex++) {
            def_vrtx[vertex][0] = 0.0f;
            def_vrtx[vertex][1] = 0.0f;
            def_vrtx[vertex][2] = 0.0f;
            def_vrtx[vertex][3] = 1.0f;
        }

        skin->GetLWMatrix(tmp_SkinMatrix);
        root->GetLWMatrix(tmp_ChrMatrix);
        mgInversMatrix(tmp_SkinMatrix_inv, tmp_SkinMatrix);
        mgMulMatrix(tmp_BaseSkinMatrix, tmp_ChrMatrix, motion->base_matrices[list->frame]);
        mgInversMatrix(tmp_BaseSkinMatrix_inv, tmp_BaseSkinMatrix);
    }

    sceVu0UnitMatrix(bone_matrix);
    sceVu0UnitMatrix(tmp_SkinMatrix);
    bone->GetLWMatrix(bone_matrix);
    mgMulMatrix(bone_base, tmp_ChrMatrix, motion->base_matrices[list->target]);
    mgMulMatrix(bone_in_skin, tmp_BaseSkinMatrix_inv, bone_base);
    mgInversMatrix(bone_in_skin_inv, bone_in_skin);
    mgMulMatrix(skin_bone, tmp_SkinMatrix_inv, bone_matrix);
    mgMulMatrix(deform, skin_bone, bone_in_skin_inv);

    for (i = 0; i < list->key_count; i++) {
        weight[0] = list->values[i][0] * 0.01f;
        vertex = list->key_frames[i];

        if (list->type == MOTION_KEY_SKIN_WEIGHTED) {
            testVUnew(deform, info->base_vertices[vertex], weight, def_vrtx[vertex], vert[vertex]);
        } else {
            sceVu0ApplyMatrix(moved, deform, info->base_vertices[vertex]);
            moved[3] = 0.0f;
            def_vrtx[vertex][0] += moved[0];
            def_vrtx[vertex][1] += moved[1];
            def_vrtx[vertex][2] += moved[2];
            def_vrtx[vertex][0] /= def_vrtx[vertex][3];
            def_vrtx[vertex][1] /= def_vrtx[vertex][3];
            def_vrtx[vertex][2] /= def_vrtx[vertex][3];
            sceVu0CopyVectorXYZ(vert[vertex], def_vrtx[vertex]);
            def_vrtx[vertex][3] += 1.0f;
        }
    }

    return list->next;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gameutil", MotionProc2__FP8mgCFrameP14tagMOTION_TYPEP12tagFRAME_INFP8Mot_List);
#endif

Mot_List *MotionProc3(mgCFrame *root, tagMOTION_TYPE *motion, tagFRAME_INF *frame_info, Mot_List *list) {
    static sceVu0FVECTOR *vert;
    static sceVu0FVECTOR *nml;
    static sceVu0FMATRIX  tmp_SkinMatrix;
    static sceVu0FMATRIX  tmp_SkinMatrix_inv;
    static sceVu0FMATRIX  tmp_ChrMatrix;
    static sceVu0FMATRIX  tmp_BaseSkinMatrix;
    static sceVu0FMATRIX  tmp_BaseSkinMatrix_inv;
    float                 deform[4][4];
    float                 rotate[4][4];
    float                 bone_matrix[4][4];
    float                 bone_in_skin[4][4];
    float                 skin_bone[4][4];
    float                 bone_in_skin_inv[4][4];
    float                 bone_base[4][4];
    float                 normal[4];
    mgCFrame             *bone;
    mgCFrame             *skin;
    int                   vertex;
    unsigned int          i;

    if (list->type != MOTION_KEY_SKIN_WEIGHTED) {
        return list->next;
    }

    bone = root->GetFrame(list->target);
    skin = root->GetFrame(list->frame);

    if (OldSkinFrame != skin) {
        OldSkinFrame = root->GetFrame(list->frame);
        mgCVisualMDT *visual = (mgCVisualMDT *) skin->visual;
        vert = visual->vertex;
        nml = visual->normal;

        if (frame_info[list->frame].vertex_count > 400) {
            printf("###### MAX_VERTX OVER %d/%d######\n", frame_info[list->frame].vertex_count, 400);
        }

        if (frame_info[list->frame].normal_count > 800) {
            printf("###### MAX_NORMAL OVER %d/%d######\n", frame_info[list->frame].normal_count, 800);
        }

        for (i = 0; i < frame_info[list->frame].vertex_count; i++) {
            def_vrtx[i][0] = 0.0f;
            def_vrtx[i][1] = 0.0f;
            def_vrtx[i][2] = 0.0f;
            def_vrtx[i][3] = 1.0f;
        }

        for (unsigned int normal_index = 0; normal_index < frame_info[list->frame].normal_count; normal_index++) {
            def_nml[normal_index][0] = 0.0f;
            def_nml[normal_index][1] = 0.0f;
            def_nml[normal_index][2] = 0.0f;
            def_nml[normal_index][3] = 1.0f;
        }

        skin->attr->unk_28 = 1;
        skin->GetLWMatrix(tmp_SkinMatrix);
        root->GetLWMatrix(tmp_ChrMatrix);
        sceVu0InversMatrix(tmp_SkinMatrix_inv, tmp_SkinMatrix);
        mgMulMatrix(tmp_BaseSkinMatrix, tmp_ChrMatrix, motion->base_matrices[list->frame]);
        mgInversMatrix(tmp_BaseSkinMatrix_inv, tmp_BaseSkinMatrix);
    }

    sceVu0UnitMatrix(bone_matrix);
    sceVu0UnitMatrix(tmp_SkinMatrix);
    bone->GetLWMatrix(bone_matrix);
    mgMulMatrix(bone_base, tmp_ChrMatrix, motion->base_matrices[list->target]);
    mgMulMatrix(bone_in_skin, tmp_BaseSkinMatrix_inv, bone_base);
    mgInversMatrix(bone_in_skin_inv, bone_in_skin);
    mgMulMatrix(skin_bone, tmp_SkinMatrix_inv, bone_matrix);
    mgMulMatrix(deform, skin_bone, bone_in_skin_inv);

    sceVu0CopyMatrix(rotate, deform);
    rotate[3][0] = 0.0f;
    rotate[3][1] = 0.0f;
    rotate[3][2] = 0.0f;

    for (unsigned int index = 0; index < list->key_count; index++) {
        float weight[4] = {0.0f, 0.0f, 0.0f, 0.0f};

        weight[0] = 0.01f * list->values[index][0];

        if (!(weight[0] <= 0.0f)) {
            vertex = list->key_frames[index];
            testVUnew(deform, frame_info[list->frame].base_vertices[vertex], weight, def_vrtx[vertex], vert[vertex]);
            sceVu0ApplyMatrix(normal, rotate, frame_info[list->frame].base_normals[vertex]);
            sceVu0InterVectorXYZ(nml[vertex], normal, frame_info[list->frame].base_normals[vertex], weight[0]);
        }
    }

    return list->next;
}

void SetMotionTime(mgCFrame *root, tagMOTION_TYPE *motion, float time, mgCCamera *camera) {
    Mot_List *list;

    for (list = motion->motion_list; list != NULL;) {
        list = MotionProc(root, time, list, camera);
    }
}

void ChangeMotion(mgCFrame *root, tagMOTION_TYPE *motion, unsigned int from_frame, unsigned int to_frame, float blend, mgCCamera *camera) {
    Mot_List *list;

    for (list = motion->motion_list; list != NULL;) {
        list = MotionProc(root, from_frame, to_frame, blend, list, camera);
    }
}

void DeformMesh(mgCFrame *root, tagMOTION_TYPE *motion, tagFRAME_INF *frame_info, bool with_normals) {
    Mot_List *list = motion->skin_list;

    if (with_normals) {
        while (list != NULL) {
            list = MotionProc3(root, motion, frame_info, list);
        }
    } else {
        while (list != NULL) {
            list = MotionProc2(root, motion, frame_info, list);
        }
    }

    OldSkinFrame = NULL;
}

static void SetKeyFrame(Mot_List *list, FRAME_VECTOR_EX_DATA *keys, mgCMemory *memory) {
    list->values = (float(*)[4]) memory->Alloc((list->key_count * 16 / 16) + 1);
    list->key_frames = (u32 *) memory->Alloc((list->key_count * 4 >> 4) + 1);
    u32 i = 0;

    while (i < list->key_count) {
        float *value = list->values[i];
        u32   *time = &list->key_frames[i];
        i++;
        value[0] = keys->value[0];
        value[1] = keys->value[1];
        value[2] = keys->value[2];
        value[3] = keys->value[3];
        *time = keys->frame;
        keys++;
    }
}

void ChangeWeight(Mot_List *list, mgCMemory *memory, u8 *data, int frame_no, tagFRAME_INF *frame_info,
                  mgCVisualMDT *mesh, mgCFrame *frame, mgCFrame *source_frame) {
    Mot_List             *prev;
    Mot_File_List        *header;
    Mot_List             *head;
    FRAME_VECTOR_EX_DATA *cursor;
    Mot_List             *old_prev;
    Mot_List             *channel;
    Mot_List             *cur;
    FRAME_VECTOR_EX_DATA *keys;
    sceVu0FVECTOR        *src_vertices;
    sceVu0FVECTOR        *src_normals;
    int                   i;
    mgFACE_GROUP         *node;
    mgCFace              *index_list;
    int                  *indices;
    int                   pos;
    FrameLinkRecord      *record;

    prev = list;
    cur = list;

    if (cur != NULL) {
        do {
            if (frame_no == cur->frame) {
                prev->next = cur->next;
            } else {
                prev = cur;
            }

            cur = cur->next;
        } while (cur != NULL);
    }

    cursor = (FRAME_VECTOR_EX_DATA *) data;
    head = NULL;

    do {
        header = (Mot_File_List *) cursor;
        channel = (Mot_List *) memory->Alloc(3);
        channel->frame = frame_no;

        channel->target =
            frame->SearchFrameID(source_frame->GetFrame((u32) header->target)->name);
        channel->key_count = header->key_count;
        channel->type = header->type;
        cursor++;
        keys = cursor;
        cursor += channel->key_count;
        SetKeyFrame(channel, keys, memory);

        if (head == NULL) {
            channel->next = NULL;
        } else {
            channel->next = head;
        }

        head = channel;
    } while ((u64) header->more != 0);

    old_prev = NULL;

    if (channel != NULL) {
        do {
            cur = old_prev;
            old_prev = head;
            head = head->next;
            old_prev->next = cur;
        } while (head != NULL);
    }

    prev->next = old_prev;

    if (mesh != NULL) {
        src_vertices = mesh->vertex;
        src_normals = mesh->normal;
        frame_info[frame_no].base_vertices = (float(*)[4]) memory->Alloc((mesh->vertex_num * 16U / 16) + 1);
        frame_info[frame_no].base_normals = (float(*)[4]) memory->Alloc(((u32) mesh->normal_num * 16 / 16) + 1);
        frame_info[frame_no].vertex_refs =
            (FrameLinkRecord *) memory->Alloc(((u32) (mesh->vertex_num * 0x30) >> 4) + 1);
        frame_info[frame_no].vertex_count = mesh->vertex_num;
        frame_info[frame_no].normal_count = mesh->normal_num;
        memcpy(frame_info[frame_no].base_vertices, src_vertices, mesh->vertex_num * 16);
        memcpy(frame_info[frame_no].base_normals, src_normals, mesh->normal_num * 16);

        for (i = 0; i < mesh->vertex_num; i++) {
            frame_info[frame_no].vertex_refs[i].count = 0;
        }

        node = mesh->face_group;

        if (node != NULL) {
            do {
                index_list = node->face;

                if (index_list != NULL) {
                    do {
                        indices = index_list->index;
                        pos = 0;

                        if (!(node->face->type & 0x200)) {
                            while (pos < index_list->index_num) {
                                int from = indices[pos];
                                pos++;
                                int to = indices[pos];
                                pos += index_list->index_stride - 1;
                                record = &frame_info[frame_no].vertex_refs[from];
                                record->link[record->count] = to;
                                record = &frame_info[frame_no].vertex_refs[from];
                                record->count++;
                            }

                            index_list = index_list->next;
                        } else {
                            break;
                        }
                    } while (index_list != NULL);
                }

                node = node->next;
            } while (node != NULL);
        }
    }
}

int CreateAnimeDataEX(tagMOTION_TYPE *motion, mgCMemory *memory, MOTION_FILE_INFO *info) {
    FRAME_VECTOR_EX_DATA *cursor;
    Mot_List             *channel;
    Mot_File_List        *header;
    FRAME_VECTOR_EX_DATA *keys;
    FRAME_VECTOR_EX_DATA *deform_cursor;
    Mot_List             *deform_channel;
    Mot_File_List        *deform_header;
    FRAME_VECTOR_EX_DATA *deform_keys;
    Mot_List             *head;
    Mot_List             *prev;
    Mot_List             *old_prev;
    Mot_List             *cur;

    if (info[0].name != 0) {
        motion->base_matrices = (sceVu0FMATRIX *) memory->Alloc((info[0].size / 16) + 1);
        memcpy(motion->base_matrices, info[0].data, info[0].size);
    }

    if (info[1].name != 0) {
        cursor = (FRAME_VECTOR_EX_DATA *) info[1].data;
        motion->motion_list = NULL;

        do {
            header = (Mot_File_List *) cursor;
            channel = (Mot_List *) memory->Alloc(3);
            channel->frame = header->frame;
            channel->target = header->target;
            channel->key_count = header->key_count;
            channel->type = header->type;
            cursor++;
            keys = cursor;
            cursor += channel->key_count;
            SetKeyFrame(channel, keys, memory);
            head = motion->motion_list;

            if (head == NULL) {
                channel->next = NULL;
            } else {
                channel->next = head;
            }

            motion->motion_list = channel;
        } while ((u64) header->more != 0);

        prev = NULL;

        while ((cur = motion->motion_list) != NULL) {
            old_prev = prev;
            prev = cur;
            motion->motion_list = cur->next;
            cur->next = old_prev;
        }

        motion->motion_list = prev;
    }

    if (info[2].name != 0) {
        deform_cursor = (FRAME_VECTOR_EX_DATA *) info[2].data;
        motion->skin_list = NULL;

        do {
            deform_header = (Mot_File_List *) deform_cursor;
            deform_channel = (Mot_List *) memory->Alloc(3);
            deform_channel->frame = deform_header->frame;
            deform_channel->target = deform_header->target;
            deform_channel->key_count = deform_header->key_count;
            deform_channel->type = deform_header->type;
            deform_cursor++;
            deform_keys = deform_cursor;
            deform_cursor += deform_channel->key_count;
            SetKeyFrame(deform_channel, deform_keys, memory);
            head = motion->skin_list;

            if (head == NULL) {
                deform_channel->next = NULL;
            } else {
                deform_channel->next = head;
            }

            motion->skin_list = deform_channel;
        } while ((u64) deform_header->more != 0);

        prev = NULL;

        while ((cur = motion->skin_list) != NULL) {
            old_prev = prev;
            prev = cur;
            motion->skin_list = cur->next;
            cur->next = old_prev;
        }

        motion->skin_list = prev;
    }

    return 1;
}

void AnimeDataInit(mgCFrame *root, tagMOTION_TYPE *motion, mgCMemory *memory, tagFRAME_INF **frame_info) {
    *frame_info = (tagFRAME_INF *) memory->stAlloc64((root->GetFrameNum() + 10) * sizeof(tagFRAME_INF) / 16 + 1);
    AnimeDataInit(root, motion, memory, *frame_info);
}

int AnimeDataInit(mgCFrame *frame, tagMOTION_TYPE *motion, mgCMemory *memory,
                  tagFRAME_INF *frame_info) {
    Mot_List        *channel = motion->skin_list;
    int              i;
    int              frame_num;
    int              j;
    mgCVisualMDT    *mesh;
    mgFACE_GROUP    *node;
    mgCFace         *list;
    int             *indices;
    int              pos;
    FrameLinkRecord *record;
    sceVu0FVECTOR   *src_vertices;
    sceVu0FVECTOR   *src_normals;
    mgCFrame        *target;

    frame_num = frame->GetFrameNum();
    i = 0;

    if (i < frame_num) {
        do {
            int           frame_no = frame->GetFrame(i)->parent - frame;
            tagFRAME_INF *info = &frame_info[i];
            i++;
            info->parent = frame_no;
            info->vertex_count = 0;
            info->normal_count = 0;
        } while (i < frame_num);
    }

    if (channel != NULL) {
        do {
            if (channel->type == 0x14 || channel->type == 0x15) {
                frame->GetFrame(channel->target);
                target = frame->GetFrame(channel->frame);

                if (frame_info[channel->frame].vertex_count == 0 && target != NULL) {
                    mesh = (mgCVisualMDT *) target->visual;

                    if (mesh != NULL && mesh != NULL) {
                        src_vertices = mesh->vertex;
                        src_normals = mesh->normal;
                        frame_info[channel->frame].base_vertices =
                            (float(*)[4]) memory->Alloc((mesh->vertex_num * 16U / 16) + 1);
                        frame_info[channel->frame].base_normals =
                            (float(*)[4]) memory->Alloc(((u32) mesh->normal_num * 16 / 16) + 1);
                        frame_info[channel->frame].vertex_refs = (FrameLinkRecord *) memory->Alloc(
                            ((u32) (mesh->vertex_num * 0x30) >> 4) + 1);
                        frame_info[channel->frame].vertex_count = mesh->vertex_num;
                        frame_info[channel->frame].normal_count = mesh->normal_num;
                        memcpy(frame_info[channel->frame].base_vertices, src_vertices,
                               mesh->vertex_num * 16);
                        memcpy(frame_info[channel->frame].base_normals, src_normals, mesh->normal_num * 16);

                        for (j = 0; j < mesh->vertex_num; j++) {
                            frame_info[channel->frame].vertex_refs[j].count = 0;
                        }

                        node = mesh->face_group;

                        if (node != NULL) {
                            do {
                                list = node->face;

                                if (list != NULL) {
                                    do {
                                        indices = list->index;
                                        pos = 0;

                                        if (!(node->face->type & 0x200)) {
                                            while (pos < list->index_num) {
                                                int from = indices[pos];
                                                pos++;
                                                int to = indices[pos];
                                                pos += list->index_stride - 1;
                                                record = &frame_info[channel->frame].vertex_refs[from];
                                                record->link[record->count] = to;
                                                record = &frame_info[channel->frame].vertex_refs[from];
                                                record->count++;
                                            }

                                            list = list->next;
                                        } else {
                                            break;
                                        }
                                    } while (list != NULL);
                                }

                                node = node->next;
                            } while (node != NULL);
                        }
                    }
                }
            }

            channel = channel->next;
        } while (channel != NULL);
    }

    return 1;
}

int CheckHit(CCPoly *polys, int count, float *from, float *to, float *hit_point, int nearest, int ignore_mask) {
    CollisionInfo info;

    info.unk_08 = 0;
    info.unk_0C = 0;
    info.count = count;
    info.polys = polys;
    return CheckHit(&info, from, to, hit_point, nearest, ignore_mask);
}

#pragma global_optimizer off

int CheckHit(CollisionInfo *collision, float *from, float *to, float *hit, int closest, int mask) {
    float   point[4];
    float   diff[4];
    float   poly_min[4];
    float   poly_max[4];
    float   seg_max[4];
    float   seg_min[4];
    float   offset[4];
    float   best_dist;
    float   d0;
    float   d1;
    float   dist;
    int     i;
    int     best;
    CCPoly *poly;
    int     count;
    int     has_best;

    if (collision == NULL) {
        return 0;
    }

    best = -1;
    has_best = 0;
    mgVectorMaxMin(seg_max, seg_min, from, to);

    {
        float *min_ptr;
        float *max_ptr;
        max_ptr = seg_max;
        min_ptr = seg_min;
        asm {
            lqc2 vf10, 0(max_ptr)
            lqc2 vf11, 0(min_ptr)
        }
    }
    poly = collision->polys;
    count = collision->count;

    if (poly == NULL || count == 0) {
        return -1;
    }

    for (i = 0; i < count; i++, poly++) {
        if (poly->ignore_mask & mask) {
            continue;
        }

        mgVectorMaxMin(poly_max, poly_min, poly->vertex[0], poly->vertex[1], poly->vertex[2]);

        if (seg_max[0] < poly_min[0] || seg_max[1] < poly_min[1] || seg_max[2] < poly_min[2]) {
            continue;
        }

        if (!(seg_min[0] <= poly_max[0]) || !(seg_min[1] <= poly_max[1]) ||
            !(seg_min[2] <= poly_max[2])) {
            continue;
        }

        sceVu0SubVector(offset, from, poly->vertex[0]);
        d0 = sceVu0InnerProduct(poly->normal, offset);
        sceVu0SubVector(offset, to, poly->vertex[0]);
        d1 = sceVu0InnerProduct(poly->normal, offset);

        if (!(d0 <= 0.0f || d1 <= 0.0f)) {
            continue;
        }

        if (d0 < 0.0f && d1 < 0.0f) {
            continue;
        }

        if (mgIntersectionPoint_line_poly3(from, to, poly->vertex[0], poly->vertex[1],
                                           poly->vertex[2], poly->normal, point) == 0) {
            continue;
        }

        if (closest == 0) {
            best = i;
            sceVu0CopyVector(hit, point);
            break;
        }

        diff[0] = from[0] - point[0];
        diff[1] = from[1] - point[1];
        diff[2] = from[2] - point[2];
        dist = (diff[0] * diff[0]) + (diff[1] * diff[1]) + (diff[2] * diff[2]);

        if (has_best == 0) {
            best_dist = dist;
            best = i;
            sceVu0CopyVector(hit, point);
        } else if (!(best_dist <= dist)) {
            best_dist = dist;
            best = i;
            sceVu0CopyVector(hit, point);
        }

        has_best = 1;
    }

    return best;
}

#pragma global_optimizer reset

int CheckHitVertical(CCPoly *polys, int count, float *from, float height, float *hit_point, int ignore_mask) {
    CollisionInfo info;

    info.unk_08 = 0;
    info.unk_0C = 0;
    info.count = count;
    info.polys = polys;
    return CheckHitVertical(&info, from, height, hit_point, ignore_mask);
}

int CheckHitVertical(CollisionInfo *collision, float *pos, float dy, float *hit, int mask) {
    float   end[3];
    float   best_y;
    int     i;
    int     best;
    CCPoly *poly;
    int     count;

    if (collision == NULL) {
        return -1;
    }

    end[0] = pos[0];
    end[1] = pos[1] + dy;
    end[2] = pos[2];
    poly = collision->polys;
    count = collision->count;
    best = -1;

    if (poly == NULL || count == 0) {
        return -1;
    }

    for (i = 0; i < count; i++, poly++) {
        if (!(poly->ignore_mask & mask) &&
            mgIntersectionPoint_line_poly3(pos, end, poly->vertex[0], poly->vertex[1],
                                           poly->vertex[2], poly->normal, hit) != 0) {
            if (dy <= 0.0f) {
                if (!(pos[1] <= hit[1]) && (best < 0 || (best >= 0 && best_y <= hit[1]))) {
                    best = i;
                    best_y = hit[1];
                }
            } else {
                if (pos[1] < hit[1] && (best < 0 || (best >= 0 && !(best_y < hit[1])))) {
                    best = i;
                    best_y = hit[1];
                }
            }
        }
    }

    if (best >= 0) {
        hit[1] = best_y;
    }

    return best;
}

int CheckHits(CCPoly *polys, int count, float *from, float *to, int max_hits, int *hit_polys, float (*hit_points)[4], int sort, int ignore_mask) {
    CollisionInfo info;

    info.unk_08 = 0;
    info.unk_0C = 0;
    info.count = count;
    info.polys = polys;
    return CheckHits(&info, from, to, max_hits, hit_polys, hit_points, sort, ignore_mask);
}

#ifdef NONMATCHING
int CheckHits(CollisionInfo *info, float *from, float *to, int max_hits, int *hit_polys, float (*hit_points)[4], int sort, int ignore_mask) {
    sceVu0FVECTOR point;
    sceVu0FVECTOR poly_max;
    sceVu0FVECTOR poly_min;
    sceVu0FVECTOR line_max;
    sceVu0FVECTOR line_min;
    sceVu0FVECTOR offset;
    sceVu0FVECTOR swap;
    CCPoly       *poly;
    int           count;
    int           i;
    int           j;
    int           hits;
    float         from_side;
    float         to_side;

    hits = 0;
    mgVectorMaxMin(line_max, line_min, from, to);
    poly = info->polys;
    count = info->count;

    for (i = 0; i < count; i++, poly++) {
        if (poly->ignore_mask & ignore_mask) {
            continue;
        }

        mgVectorMaxMin(poly_max, poly_min, poly->vertex[0], poly->vertex[1], poly->vertex[2]);

        if (poly_min[0] > line_max[0] || poly_min[1] > line_max[1] || poly_min[2] > line_max[2]) {
            continue;
        }

        if (line_min[0] > poly_max[0] || line_min[1] > poly_max[1] || line_min[2] > poly_max[2]) {
            continue;
        }

        sceVu0SubVector(offset, from, poly->vertex[0]);
        from_side = sceVu0InnerProduct(poly->normal, offset);
        sceVu0SubVector(offset, to, poly->vertex[0]);
        to_side = sceVu0InnerProduct(poly->normal, offset);

        if (from_side > 0.0f && to_side > 0.0f) {
            continue;
        }

        if (from_side < 0.0f && to_side < 0.0f) {
            continue;
        }

        if (mgIntersectionPoint_line_poly3(from, to, poly->vertex[0], poly->vertex[1], poly->vertex[2], poly->normal, point) == 0) {
            continue;
        }

        if (hits >= max_hits) {
            break;
        }

        hit_polys[hits] = i;
        sceVu0CopyVector(hit_points[hits], point);
        hit_points[hits][3] = mgDistVector(from, point);
        hits++;
    }

    if (sort != 0) {
        if (sort > 0) {
            for (i = 0; i < hits - 1; i++) {
                for (j = i + 1; j < hits; j++) {
                    if (hit_points[j][3] < hit_points[i][3]) {
                        int index = hit_polys[i];

                        hit_polys[i] = hit_polys[j];
                        hit_polys[j] = index;
                        sceVu0CopyVector(swap, hit_points[i]);
                        sceVu0CopyVector(hit_points[i], hit_points[j]);
                        sceVu0CopyVector(hit_points[j], swap);
                    }
                }
            }
        }

        // A descending sort was never written; it sorts ascending as well.
        if (sort < 0) {
            for (i = 0; i < hits - 1; i++) {
                for (j = i + 1; j < hits; j++) {
                    if (hit_points[j][3] < hit_points[i][3]) {
                        int index = hit_polys[i];

                        hit_polys[i] = hit_polys[j];
                        hit_polys[j] = index;
                        sceVu0CopyVector(swap, hit_points[i]);
                        sceVu0CopyVector(hit_points[i], hit_points[j]);
                        sceVu0CopyVector(hit_points[j], swap);
                    }
                }
            }
        }
    }

    return hits;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gameutil", CheckHits__FP13CollisionInfoPfPfiPiPA4_fii);
#endif

int CheckHitsPipeY(CCPoly *polys, int count, float *from, float height, int max_hits, int *hit_polys, sceVu0FVECTOR *hit_points, int sort, int ignore_mask) {
    float   best[4];
    float   poly_min[4];
    float   poly_max[4];
    float   pipe_max[4];
    float   pipe_min[4];
    float   top[4];
    float   points[11][4];
    float   swap[4];
    CCPoly *poly;
    float   radius;
    float   normal_y;
    int     point_count;
    int     j;
    int     found;
    int     hits;
    int     i;
    int     index;

    hits = 0;
    radius = from[3];
    *(u_long128 *) top = *(u_long128 *) from;
    top[1] += height;
    mgVectorMaxMin(pipe_max, pipe_min, from, top);
    pipe_max[0] += radius;
    pipe_max[2] += radius;
    pipe_min[0] -= radius;
    pipe_min[2] -= radius;
    poly = polys;

    for (i = 0; i < count; i++, poly++) {
        if (poly->ignore_mask & ignore_mask) {
            continue;
        }

        normal_y = (poly->normal[1] < 0.0f) ? -poly->normal[1] : poly->normal[1];

        if (normal_y < 0.01f) {
            continue;
        }

        mgVectorMaxMin(poly_max, poly_min, poly->vertex[0], poly->vertex[1], poly->vertex[2]);

        if (pipe_max[0] < poly_min[0] || pipe_max[1] < poly_min[1] || pipe_max[2] < poly_min[2]) {
            continue;
        }

        if (!(pipe_min[0] <= poly_max[0]) || !(pipe_min[1] <= poly_max[1]) || !(pipe_min[2] <= poly_max[2])) {
            continue;
        }

        point_count = IntersectionPipeYPoly3(from, poly->vertex, poly->normal, points);

        if (point_count <= 0) {
            continue;
        }

        found = 0;

        for (j = 0; j < point_count; j++) {
            if (points[j][1] <= pipe_max[1] && !(points[j][1] < pipe_min[1])) {
                if (found == 0) {
                    *(u_long128 *) best = *(u_long128 *) points[j];
                    found = 1;
                } else if (!(points[j][1] <= best[1])) {
                    *(u_long128 *) best = *(u_long128 *) points[j];
                }
            }
        }

        if (found == 0) {
            continue;
        }

        if (hits >= max_hits) {
            break;
        }

        hit_polys[hits] = i;
        sceVu0CopyVector(hit_points[hits], best);
        hit_points[hits][3] = mgDistVector(from, best);
        hits++;
    }

    if (sort == 0) {
        return hits;
    }

    {
        if (sort > 0) {
            for (i = 0; i < hits - 1; i++) {
                for (j = i + 1; j < hits; j++) {
                    if (!(hit_points[i][3] <= hit_points[j][3])) {
                        index = hit_polys[i];

                        hit_polys[i] = hit_polys[j];
                        hit_polys[j] = index;
                        sceVu0CopyVector(swap, hit_points[i]);
                        sceVu0CopyVector(hit_points[i], hit_points[j]);
                        sceVu0CopyVector(hit_points[j], swap);
                    }
                }
            }
        }

        if (sort < 0) {
            for (i = 0; i < hits - 1; i++) {
                for (j = i + 1; j < hits; j++) {
                    if (!(hit_points[i][3] <= hit_points[j][3])) {
                        index = hit_polys[i];

                        hit_polys[i] = hit_polys[j];
                        hit_polys[j] = index;
                        sceVu0CopyVector(swap, hit_points[i]);
                        sceVu0CopyVector(hit_points[i], hit_points[j]);
                        sceVu0CopyVector(hit_points[j], swap);
                    }
                }
            }
        }
    }

    return hits;
}

int CheckHitsPipe(CCPoly *polys, int count, sceVu0FVECTOR from, float *to, int max_hits, int *hit_polys, sceVu0FVECTOR *hit_points, int sort, int ignore_mask) {
    float   best[4];
    float   poly_min[4];
    float   poly_max[4];
    float   pipe_max[4];
    float   pipe_min[4];
    float   dir[4];
    float   points[11][4];
    float   offset[4];
    float   swap[4];
    CCPoly *poly;
    float   radius;
    float   length;
    float   along;
    int     point_count;
    int     j;
    int     found;
    int     hits;
    int     i;
    int     index;

    hits = 0;
    radius = from[3];
    length = mgDistVector(from, to);
    mgVectorMaxMin(pipe_max, pipe_min, from, to);
    sceVu0SubVector(dir, to, from);
    sceVu0Normalize(dir, dir);
    pipe_max[0] += radius;
    pipe_max[1] += radius;
    pipe_max[2] += radius;
    pipe_min[0] -= radius;
    pipe_min[1] -= radius;
    pipe_min[2] -= radius;
    poly = polys;

    for (i = 0; i < count; i++, poly++) {
        if (poly->ignore_mask & ignore_mask) {
            continue;
        }

        mgVectorMaxMin(poly_max, poly_min, poly->vertex[0], poly->vertex[1], poly->vertex[2]);

        if (pipe_max[0] < poly_min[0] || pipe_max[1] < poly_min[1] || pipe_max[2] < poly_min[2]) {
            continue;
        }

        if (!(pipe_min[0] <= poly_max[0]) || !(pipe_min[1] <= poly_max[1]) || !(pipe_min[2] <= poly_max[2])) {
            continue;
        }

        point_count = IntersectionPipePoly3(from, dir, poly->vertex, poly->normal, points);

        if (point_count <= 0) {
            continue;
        }

        found = 0;

        for (j = 0; j < point_count; j++) {
            sceVu0SubVector(offset, points[j], from);
            along = sceVu0InnerProduct(offset, dir);
            points[j][3] = along;

            if (!(along < 0.0f) && along <= length) {
                if (found == 0) {
                    *(u_long128 *) best = *(u_long128 *) points[j];
                    found = 1;
                } else if (points[j][3] < best[3]) {
                    *(u_long128 *) best = *(u_long128 *) points[j];
                }
            }
        }

        if (found == 0) {
            continue;
        }

        if (hits >= max_hits) {
            break;
        }

        hit_polys[hits] = i;
        sceVu0CopyVector(hit_points[hits], best);
        hits++;
    }

    if (sort == 0) {
        return hits;
    }

    {
        if (sort > 0) {
            for (i = 0; i < hits - 1; i++) {
                for (j = i + 1; j < hits; j++) {
                    if (!(hit_points[i][3] <= hit_points[j][3])) {
                        index = hit_polys[i];

                        hit_polys[i] = hit_polys[j];
                        hit_polys[j] = index;
                        sceVu0CopyVector(swap, hit_points[i]);
                        sceVu0CopyVector(hit_points[i], hit_points[j]);
                        sceVu0CopyVector(hit_points[j], swap);
                    }
                }
            }
        }

        if (sort < 0) {
            for (i = 0; i < hits - 1; i++) {
                for (j = i + 1; j < hits; j++) {
                    if (!(hit_points[i][3] <= hit_points[j][3])) {
                        index = hit_polys[i];

                        hit_polys[i] = hit_polys[j];
                        hit_polys[j] = index;
                        sceVu0CopyVector(swap, hit_points[i]);
                        sceVu0CopyVector(hit_points[i], hit_points[j]);
                        sceVu0CopyVector(hit_points[j], swap);
                    }
                }
            }
        }
    }

    return hits;
}

int CheckHitsSphere(CCPoly *polys, int count, float *sphere, int max_hits, int *hit_polys, sceVu0FVECTOR *hit_points, int sort, int ignore_mask) {
    float   push[4];
    float   poly_min[4];
    float   poly_max[4];
    float   sphere_max[4];
    float   sphere_min[4];
    float   normal[4];
    float   swap[4];
    int     i;
    int     hits;
    CCPoly *poly;
    int     j;
    int     index;

    hits = 0;
    float radius = sphere[3];
    *reinterpret_cast<u_long128 *>(sphere_max) = *reinterpret_cast<const u_long128 *>(sphere);
    *reinterpret_cast<u_long128 *>(sphere_min) = *reinterpret_cast<const u_long128 *>(sphere);
    sphere_max[0] += radius;
    sphere_max[1] += radius;
    sphere_max[2] += radius;
    sphere_min[0] -= radius;
    sphere_min[1] -= radius;
    sphere_min[2] -= radius;
    poly = polys;

    for (i = 0; i < count; i++, poly++) {
        if (poly->ignore_mask & ignore_mask) {
            continue;
        }

        mgVectorMaxMin(poly_max, poly_min, poly->vertex[0], poly->vertex[1], poly->vertex[2]);

        if (sphere_max[0] < poly_min[0] || sphere_max[1] < poly_min[1] || sphere_max[2] < poly_min[2]) {
            continue;
        }

        if (!(sphere_min[0] <= poly_max[0]) || !(sphere_min[1] <= poly_max[1]) || !(sphere_min[2] <= poly_max[2])) {
            continue;
        }

        sceVu0Normalize(normal, poly->normal);

        if (IntersectionSpherePoly3(sphere, poly->vertex, normal, push) == SPHERE_POLY3_NONE) {
            continue;
        }

        if (hits >= max_hits) {
            break;
        }

        hit_polys[hits] = i;
        sceVu0CopyVector(hit_points[hits], push);
        hits++;
    }

    if (sort == 0) {
        return hits;
    }

    {
        if (sort > 0) {
            for (i = 0; i < hits - 1; i++) {
                for (j = i + 1; j < hits; j++) {
                    if (!(hit_points[i][3] <= hit_points[j][3])) {
                        index = hit_polys[i];

                        hit_polys[i] = hit_polys[j];
                        hit_polys[j] = index;
                        sceVu0CopyVector(swap, hit_points[i]);
                        sceVu0CopyVector(hit_points[i], hit_points[j]);
                        sceVu0CopyVector(hit_points[j], swap);
                    }
                }
            }
        }

        if (sort < 0) {
            for (i = 0; i < hits - 1; i++) {
                for (j = i + 1; j < hits; j++) {
                    if (!(hit_points[i][3] <= hit_points[j][3])) {
                        index = hit_polys[i];

                        hit_polys[i] = hit_polys[j];
                        hit_polys[j] = index;
                        sceVu0CopyVector(swap, hit_points[i]);
                        sceVu0CopyVector(hit_points[i], hit_points[j]);
                        sceVu0CopyVector(hit_points[j], swap);
                    }
                }
            }
        }
    }

    return hits;
}

int MoveCheck(float *pos, float *vel, float *out, MoveCheckInfo *info, CCPoly *polys, int count,
              int mask) {
    float point[4];
    float start[4];
    float end[4];
    float dir[4];
    int   hit_index[64];
    float hit_point[64][4];
    float scratch[4];

    union {
        CCPoly     poly;
        CCPolyCopy copy;
    } foot;

    float foot_probe[4];
    float probe[4];
    float radius;
    float margin;
    int   tries;
    int   wall_sides;

    radius = info->radius;

    if (radius <= 0.0f) {
        radius = 15.0f;
    }

    out[0] = pos[0];
    out[1] = pos[1];
    out[2] = pos[2];
    sceVu0Normalize(dir, vel);
    sceVu0ScaleVector(dir, dir, 0.3f * radius);
    start[0] = pos[0];
    start[1] = 10.0f + pos[1];
    start[2] = pos[2];
    end[0] = start[0] + vel[0];
    end[1] = start[1] + vel[1];
    end[2] = start[2] + vel[2];
    start[3] = 4.0f;
    sceVu0AddVector(scratch, end, dir);
    tries = 0;

    do {
        if (CheckHitsPipe(polys, count, start, end, 0x40, hit_index, hit_point, 1, mask) <= 0) {
            start[0] = end[0];
            start[1] = end[1];
            start[2] = end[2];
            end[0] = start[0];
            end[1] = start[1] - 10.0f;
            end[2] = start[2];
            break;
        }

        vel[0] *= 0.5f;
        vel[2] *= 0.5f;
        tries++;
        end[0] = start[0] + vel[0];
        end[1] = start[1] + vel[1];
        end[2] = start[2] + vel[2];
    } while (tries < 2);

    info->ground_found = 0;
    info->landed = 0;
    margin = 4.0f;

    if (vel[1] > 0.1f) {
        margin = 0.0f;
    }

    sceVu0CopyVector(foot_probe, start);

    if (info->skip_ground == 0) {
        if (GetFootPoly(foot_probe, 20.0f, &foot.poly, point, polys, count, mask)) {
            sceVu0Normalize(foot.copy.normal, foot.copy.normal);
            *reinterpret_cast<CCPolyCopy *>(&info->ground_poly) = foot.copy;
            *reinterpret_cast<CCPolyCopy *>(&info->second_poly) = foot.copy;
            info->ground_found = 1;
            info->landed = 0;
            *reinterpret_cast<u_long128 *>(info->ground_point) = *reinterpret_cast<u_long128 *>(point);

            if (!(point[1] <= start[1] + vel[1] - 10.0f - margin)) {
                info->landed = 1;
            }
        }
    }

    if (info->landed) {
        out[0] = point[0];
        out[1] = point[1];
        out[2] = point[2];
    } else {
        out[0] = end[0];
        out[1] = end[1];
        out[2] = end[2];
    }

    *reinterpret_cast<u_long128 *>(probe) = *reinterpret_cast<u_long128 *>(out);
    probe[1] += 5.0f;
    wall_sides = CheckWidth(polys, count, probe, radius, end, mask);
    info->width_result = wall_sides;

    if (wall_sides) {
        probe[0] = end[0];
        probe[2] = end[2];
    }

    probe[3] = 4.0f;

    if (CheckWidthPipe(polys, count, probe, radius, end, mask)) {
        out[0] = end[0];
        out[2] = end[2];
    } else {
        out[0] = probe[0];
        out[2] = probe[2];
    }

    if (info->skip_ground == 0) {
        sceVu0CopyVector(foot_probe, start);

        if (GetFootPoly(foot_probe, 20.0f, &foot.poly, point, polys, count, mask)) {
            *reinterpret_cast<u_long128 *>(info->ground_point) = *reinterpret_cast<u_long128 *>(point);

            if (!(point[1] <= start[1] + vel[1] - 10.0f - margin)) {
                out[1] = point[1];
            }
        }
    }

    GetCPolyAttr(info, pos, out, 34.0f, polys, count, mask);
    return 0;
}

int GetFootPoly(float *pos, float depth, CCPoly *found, sceVu0FVECTOR ground, CCPoly *polys, int count, int ignore_mask) {
    s16           poly_ignore_mask;
    u16           parts_no;
    s16           attribute;
    int           hit_polys[32];
    sceVu0FVECTOR from;
    sceVu0FVECTOR to;
    sceVu0FVECTOR hit_points[64];
    int           attribute_value[4];
    int           hits;
    int           found_ground;
    int           i;
    float         normal_y;
    sceVu0CopyVector(from, pos);
    sceVu0CopyVector(to, pos);
    from[3] = 4.0f;
    to[1] -= depth;
    hits = CheckHitsPipeY(polys, count, from, -depth, 32, hit_polys, hit_points, 1, ignore_mask);

    if (hits == 0) {
        return 0;
    }

    int ground_kind = 0;
    int foot_sound = 0;
    int area_kind = 0;
    found_ground = 0;

    for (i = 0; i < hits; i++) {
        sceVu0FVECTOR normal;
        sceVu0Normalize(normal, polys[hit_polys[i]].normal);
        normal_y = (normal[1] < 0.0f) ? -normal[1] : normal[1];

        if (normal_y < 0.05f) {
            continue;
        }

        *(CCPolyCopy *) found = *(CCPolyCopy *) &polys[hit_polys[i]];
        sceVu0CopyVector(ground, hit_points[i]);
        found_ground = 1;
        ground[0] = from[0];
        ground[2] = from[2];
        ground_kind = found->ground_kind;
        foot_sound = found->foot_sound;
        area_kind = found->area_kind;
        poly_ignore_mask = found->ignore_mask;
        parts_no = found->parts_no;
        attribute = found->attr;
        *(float *) &attribute_value[3] = found->attr_value;
        break;
    }

    for (i = 0; i < hits; i++) {
        short *poly = &polys[hit_polys[i]].ground_kind;

        if (ground_kind == 0) {
            ground_kind = poly[0];
        }

        if (foot_sound == 0) {
            foot_sound = poly[1];
        }

        if (area_kind == 0) {
            area_kind = poly[2];
        }
    }

    found->ground_kind = ground_kind;
    found->foot_sound = foot_sound;
    found->area_kind = area_kind;
    found->ignore_mask = poly_ignore_mask;
    found->parts_no = parts_no;
    found->attr = attribute;
    found->attr_value = *(float *) &attribute_value[3];
    return found_ground;
}

void GetCPolyAttr(MoveCheckInfo *info, float *from, float *to, float dy, CCPoly *polys, int count,
                  int unused) {
    int   hit_index[32];
    float probe_from[4];
    float probe_to[4];
    float hit_point[64][4];
    int   hits;
    int   i;
    s16   kind;

    info->in_water = 0;
    info->crossed_area = 0;
    hits = CheckHits(polys, count, from, to, 0x20, hit_index, hit_point, 1, 0);

    for (i = 0; i < hits; i++) {
        kind = polys[hit_index[i]].area_kind;

        switch (kind) {
            case 1:
            case 7:
                info->crossed_area = 1;
                info->signed_distance = mgDistVector(from, to);

                if (!(from[1] <= to[1])) {
                    info->signed_distance *= -1.0f;
                }

                *(u_long128 *) info->crossed_point = *(u_long128 *) hit_point[i];
                break;
        }
    }

    sceVu0CopyVector(probe_from, to);
    sceVu0CopyVector(probe_to, to);
    probe_from[1] += dy;
    hits = CheckHits(polys, count, probe_from, probe_to, 0x20, hit_index, hit_point, 1, 0);

    if (hits == 0) {
        return;
    }

    for (i = 0; i < hits; i++) {
        kind = polys[hit_index[i]].area_kind;

        switch (kind) {
            case 1:
            case 7:
                info->in_water = 1;
                *(u_long128 *) info->water_surface = *(u_long128 *) hit_point[i];
                break;
        }
    }
}

int CheckWidth(CCPoly *polys, int count, float *pos, float radius, float *out, int mask) {
    float probe_end[4];
    float hit_first[4];
    float hit_second[4];
    float probe[4];
    float normal[4];
    int   sides;
    int   saw_first;
    int   saw_second;
    int   index;
    float diagonal;

    diagonal = radius / 1.4142135f;
    sides = 0;
    sceVu0CopyVector(probe, pos);
    sceVu0CopyVector(out, pos);
    saw_second = 0;
    saw_first = 0;
    probe_end[0] = probe[0] + diagonal;
    probe_end[1] = probe[1];
    probe_end[2] = probe[2] + diagonal;
    index = CheckHit(polys, count, probe, probe_end, hit_first, 1, mask);

    if (index >= 0) {
        sceVu0Normalize(normal, polys[index].normal);

        if (normal[1] < 0.5f && !(normal[1] <= -0.5f)) {
            saw_first = 1;
            sides |= 5;
        }
    }

    probe_end[0] = probe[0] - diagonal;
    probe_end[1] = probe[1];
    probe_end[2] = probe[2] - diagonal;
    index = CheckHit(polys, count, probe, probe_end, hit_second, 1, mask);

    if (index >= 0) {
        sceVu0Normalize(normal, polys[index].normal);

        if (normal[1] < 0.5f && !(normal[1] <= -0.5f)) {
            sides |= 10;
            saw_second = 1;
        }
    }

    if (saw_first && saw_second) {
        out[0] = 0.5f * (hit_first[0] + hit_second[0]);
        out[2] = 0.5f * (hit_first[2] + hit_second[2]);
    } else {
        if (saw_first) {
            out[0] = hit_first[0] - diagonal;
            out[2] = hit_first[2] - diagonal;
        }

        if (saw_second) {
            out[0] = hit_second[0] + diagonal;
            out[2] = hit_second[2] + diagonal;
        }
    }

    sceVu0CopyVector(probe, out);
    saw_second = 0;
    saw_first = 0;
    probe_end[0] = probe[0] + diagonal;
    probe_end[1] = probe[1];
    probe_end[2] = probe[2] - diagonal;
    index = CheckHit(polys, count, probe, probe_end, hit_first, 1, mask);

    if (index >= 0) {
        sceVu0Normalize(normal, polys[index].normal);

        if (normal[1] < 0.5f && !(normal[1] <= -0.5f)) {
            saw_first = 1;
            sides |= 9;
        }
    }

    probe_end[0] = probe[0] - diagonal;
    probe_end[1] = probe[1];
    probe_end[2] = probe[2] + diagonal;
    index = CheckHit(polys, count, probe, probe_end, hit_second, 1, mask);

    if (index >= 0) {
        sceVu0Normalize(normal, polys[index].normal);

        if (normal[1] < 0.5f && !(normal[1] <= -0.5f)) {
            sides |= 6;
            saw_second = 1;
        }
    }

    if (saw_first && saw_second) {
        out[0] = 0.5f * (hit_first[0] + hit_second[0]);
        out[2] = 0.5f * (hit_first[2] + hit_second[2]);
    } else {
        if (saw_first) {
            out[0] = hit_first[0] - diagonal;
            out[2] = hit_first[2] + diagonal;
        }

        if (saw_second) {
            out[0] = hit_second[0] + diagonal;
            out[2] = hit_second[2] - diagonal;
        }
    }

    sceVu0CopyVector(probe, out);
    saw_second = 0;
    saw_first = 0;
    probe_end[0] = probe[0] + radius;
    probe_end[1] = probe[1];
    probe_end[2] = probe[2];
    index = CheckHit(polys, count, probe, probe_end, hit_first, 1, mask);

    if (index >= 0) {
        sceVu0Normalize(normal, polys[index].normal);

        if (normal[1] < 0.5f && !(normal[1] <= -0.5f)) {
            saw_first = 1;
            sides |= 1;
        }
    }

    probe_end[0] = probe[0] - radius;
    probe_end[1] = probe[1];
    probe_end[2] = probe[2];
    index = CheckHit(polys, count, probe, probe_end, hit_second, 1, mask);

    if (index >= 0) {
        sceVu0Normalize(normal, polys[index].normal);

        if (normal[1] < 0.5f && !(normal[1] <= -0.5f)) {
            sides |= 2;
            saw_second = 1;
        }
    }

    if (saw_first && saw_second) {
        out[0] = 0.5f * (hit_first[0] + hit_second[0]);
    } else {
        if (saw_first) {
            out[0] = hit_first[0] - radius;
        }

        if (saw_second) {
            out[0] = hit_second[0] + radius;
        }
    }

    sceVu0CopyVector(probe, out);
    saw_second = 0;
    saw_first = 0;
    probe_end[0] = probe[0];
    probe_end[1] = probe[1];
    probe_end[2] = probe[2] + radius;
    index = CheckHit(polys, count, probe, probe_end, hit_first, 1, mask);

    if (index >= 0) {
        sceVu0Normalize(normal, polys[index].normal);

        if (normal[1] < 0.5f && !(normal[1] <= -0.5f)) {
            sides |= 4;
            saw_first = 1;
        }
    }

    probe_end[0] = probe[0];
    probe_end[1] = probe[1];
    probe_end[2] = probe[2] - radius;
    index = CheckHit(polys, count, probe, probe_end, hit_second, 1, mask);

    if (index >= 0) {
        sceVu0Normalize(normal, polys[index].normal);

        if (normal[1] < 0.5f && !(normal[1] <= -0.5f)) {
            sides |= 8;
            saw_second = 1;
        }
    }

    if (saw_first && saw_second) {
        out[2] = 0.5f * (hit_first[2] + hit_second[2]);
    } else {
        if (saw_first) {
            out[2] = hit_first[2] - radius;
        }

        if (saw_second) {
            out[2] = hit_second[2] + radius;
        }
    }

    return sides;
}

int CheckWidthPipe(CCPoly *polys, int count, float *pos, float radius, float *out, int mask) {
    float probe_end[4];
    float hit_high[4];
    float hit_low[4];
    float probe[4];
    float normal[4];
    int   hit_index[32];
    float hit_point[32][4];
    int   sides;
    int   has_high;
    int   has_low;
    float reach;
    int   hit;

    reach = radius;
    reach *= 0.8f;
    sides = 0;
    sceVu0CopyVector(probe, pos);
    probe[1] += 3.0f * pos[3];
    sceVu0CopyVector(out, pos);
    probe_end[3] = probe[3];
    has_low = 0;
    has_high = 0;
    probe_end[1] = probe[1];
    probe_end[0] = probe[0] + reach;
    probe_end[2] = probe[2];

    if (CheckHitsPipe(polys, count, probe, probe_end, 0x20, hit_index, hit_point, 1, mask) > 0) {
        hit = hit_index[0];
        *(u_long128 *) hit_high = *(u_long128 *) hit_point[0];
        sceVu0Normalize(normal, polys[hit].normal);

        if (normal[1] < 0.5f && !(normal[1] <= -0.5f)) {
            has_high = 1;
            sides |= 1;
        }
    }

    probe_end[0] = probe[0] - reach;
    probe_end[2] = probe[2];

    if (CheckHitsPipe(polys, count, probe, probe_end, 0x20, hit_index, hit_point, 1, mask) > 0) {
        hit = hit_index[0];
        *(u_long128 *) hit_low = *(u_long128 *) hit_point[0];
        sceVu0Normalize(normal, polys[hit].normal);

        if (normal[1] < 0.5f && !(normal[1] <= -0.5f)) {
            sides |= 2;
            has_low = 1;
        }
    }

    if (has_high && has_low) {
        out[0] = 0.5f * (hit_high[0] + hit_low[0]);
    } else {
        if (has_high) {
            out[0] = hit_high[0] - reach;
        }

        if (has_low) {
            out[0] = hit_low[0] + reach;
        }
    }

    has_low = 0;
    has_high = 0;
    probe[0] = out[0];
    probe[2] = out[2];
    probe_end[0] = probe[0];
    probe_end[2] = probe[2] + reach;

    if (CheckHitsPipe(polys, count, probe, probe_end, 0x20, hit_index, hit_point, 1, mask) > 0) {
        hit = hit_index[0];
        *(u_long128 *) hit_high = *(u_long128 *) hit_point[0];
        sceVu0Normalize(normal, polys[hit].normal);

        if (normal[1] < 0.5f && !(normal[1] <= -0.5f)) {
            sides |= 4;
            has_high = 1;
        }
    }

    probe_end[0] = probe[0];
    probe_end[2] = probe[2] - reach;

    if (CheckHitsPipe(polys, count, probe, probe_end, 0x20, hit_index, hit_point, 1, mask) > 0) {
        hit = hit_index[0];
        *(u_long128 *) hit_low = *(u_long128 *) hit_point[0];
        sceVu0Normalize(normal, polys[hit].normal);

        if (normal[1] < 0.5f && !(normal[1] <= -0.5f)) {
            sides |= 8;
            has_low = 1;
        }
    }

    if (has_high && has_low) {
        out[2] = 0.5f * (hit_high[2] + hit_low[2]);
    } else {
        if (has_high) {
            out[2] = hit_high[2] - reach;
        }

        if (has_low) {
            out[2] = hit_low[2] + reach;
        }
    }

    return sides;
}

int CreateCharaCPoly(CCPoly *polys, int max_polys, float *pos, float *target, float distance, float half_size) {
    sceVu0FVECTOR direction;
    sceVu0FVECTOR centre;
    sceVu0FVECTOR upper_left;
    sceVu0FVECTOR upper_right;
    sceVu0FVECTOR lower_left;
    sceVu0FVECTOR lower_right;
    float         wall_distance;

    if (max_polys < 2) {
        return 0;
    }

    sceVu0SubVector(direction, target, pos);
    direction[1] = 0.0f;
    wall_distance = mgDistVector(direction);

    if (wall_distance > distance) {
        wall_distance = distance;
    }

    if (wall_distance < distance) {
        wall_distance -= 1.0f;
    }

    sceVu0Normalize(direction, direction);
    upper_left[1] = half_size;
    upper_left[0] = -direction[2] * half_size;
    upper_left[2] = direction[0] * half_size;
    upper_left[3] = 1.0f;
    sceVu0CopyVector(upper_right, upper_left);
    upper_right[0] = -upper_left[0];
    upper_right[2] = -upper_left[2];
    sceVu0CopyVector(lower_left, upper_left);
    lower_left[1] = -half_size;
    sceVu0CopyVector(lower_right, upper_right);
    lower_right[1] = -half_size;
    sceVu0ScaleVector(centre, direction, wall_distance);
    sceVu0AddVector(centre, centre, pos);
    sceVu0AddVector(upper_left, upper_left, centre);
    sceVu0AddVector(upper_right, upper_right, centre);
    sceVu0AddVector(lower_left, lower_left, centre);
    sceVu0AddVector(lower_right, lower_right, centre);
    *(u_long128 *) &polys[0].ground_kind = 0;
    sceVu0CopyVector(polys[0].vertex[0], upper_left);
    sceVu0CopyVector(polys[0].vertex[1], upper_right);
    sceVu0CopyVector(polys[0].vertex[2], lower_left);
    sceVu0CopyVector(polys[0].normal, direction);
    *(u_long128 *) &polys[1].ground_kind = 0;
    sceVu0CopyVector(polys[1].vertex[0], lower_left);
    sceVu0CopyVector(polys[1].vertex[1], upper_right);
    sceVu0CopyVector(polys[1].vertex[2], lower_right);
    sceVu0CopyVector(polys[1].normal, direction);
    return 2;
}

float LinerInterpolation(float from, float to, float rate) {
    return from + (rate * (to - from));
}

int LinerInterpolationI(int from, int to, int step, int steps) {
    return from + step * (to - from) / steps;
}

void RollPos(float *center, float *point, float angle, float *out) {
    float px;
    float cx = center[0];
    float cy = center[1];
    px = point[0];
    float dy = point[1];
    float t;
    float dx;
    t = (dx = px - cx) * cosf(angle);
    out[0] = cx + (t - (dy -= cy) * sinf(angle));
    t = dx * sinf(angle);
    out[1] = cy - (t + dy * cosf(angle));
}

s32 CheckPosInOutForRect(RECT *rect, s32 x, s32 y) {
    s32 left = rect->x;

    if (x < left) {
        return 0;
    }

    if ((left + rect->width) < x) {
        return 0;
    }

    s32 top = rect->y;

    if (y < top) {
        return 0;
    }

    return (top + rect->height) >= y;
}

float GetDisPosToRect(RECT *rect, int x, int y) {
    float distance_x;
    float distance_y;

    distance_x = rect->x + rect->width / 2 - x;
    distance_y = rect->y + rect->height / 2 - y;
    return sqrt(distance_x * distance_x + distance_y * distance_y);
}

s32 CheckPosInOutFor2P(float x0, float y0, float x1, float y1, float x, float y) {
    float min_x;
    float max_x;
    float max_y;
    float min_y;
    s32   outside;

    max_x = x1;
    max_y = y1;
    min_x = max_x;

    if (x0 < max_x) {
        min_x = x0;
    } else {
        max_x = x0;
    }

    min_y = max_y;

    if (y0 < max_y) {
        min_y = y0;
    } else {
        max_y = y0;
    }

    if (x < min_x) {
        return 0;
    }

    if (max_x < x) {
        return 0;
    }

    if (y < min_y) {
        return 0;
    }

    outside = 1;

    if (!(max_y < y)) {
        outside = 0;
    }

    return outside ^ 1;
}

int CalcIntersectionPointLineAndLine(float ax0, float ay0, float ax1, float ay1, float bx0, float by0, float bx1, float by1, float *out_x, float *out_y) {
    float slope_a;
    float slope_b;
    float relative_x;
    float relative_y;

    if (ax0 == ax1 && bx0 == bx1) {
        return 0;
    }

    if (ax0 != ax1) {
        slope_a = (ay1 - ay0) / (ax1 - ax0);
    }

    if (bx0 != bx1) {
        slope_b = (by1 - by0) / (bx1 - bx0);
    }

    if (slope_a == slope_b) {
        return 0;
    }

    if (ax0 == ax1) {
        *out_x = ax0;
        *out_y = slope_b * (ax0 - bx0);
        return 1;
    } else if (bx0 == bx1) {
        *out_x = bx0;
        *out_y = slope_a * (bx0 - ax0);
        return 1;
    } else {
        relative_x = ((by0 - ay0) - slope_b * (bx0 - ax0)) / (slope_a - slope_b);
        *out_x = relative_x + ax0;
        relative_y = relative_x * slope_a;
        *out_y = relative_y + ay0;
        return 1;
    }
}

s32 CalcIntersectionPoint2PAnd2P(float ax0, float ay0, float ax1, float ay1, float bx0, float by0, float bx1, float by1, float *out_x, float *out_y) {
    if (CalcIntersectionPointLineAndLine(ax0, ay0, ax1, ay1, bx0, by0, bx1, by1, out_x, out_y) == 0) {
        return 0;
    }

    if (CheckPosInOutFor2P(ax0, ay0, ax1, ay1, *out_x, *out_y) == 0) {
        return 0;
    }

    return CheckPosInOutFor2P(bx0, by0, bx1, by1, *out_x, *out_y) != 0;
}
