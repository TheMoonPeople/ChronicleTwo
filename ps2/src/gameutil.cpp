#include "common.h"
#include "gameutil.hpp"
#include "dng_main.hpp"

extern sceVu0FVECTOR *vert_845;
extern sceVu0FMATRIX tmp_SkinMatrix_847;
extern sceVu0FMATRIX tmp_SkinMatrix_inv_848;
extern sceVu0FMATRIX tmp_ChrMatrix_849;
extern sceVu0FMATRIX tmp_BaseSkinMatrix_851;
extern sceVu0FMATRIX tmp_BaseSkinMatrix_inv_852;
extern sceVu0FVECTOR *vert_915;
extern sceVu0FVECTOR *nml_916;
extern sceVu0FMATRIX tmp_SkinMatrix_917;
extern sceVu0FMATRIX tmp_SkinMatrix_inv_918;
extern sceVu0FMATRIX tmp_ChrMatrix_919;
extern sceVu0FMATRIX tmp_BaseSkinMatrix_921;
extern sceVu0FMATRIX tmp_BaseSkinMatrix_inv_922;

#include <libvu0.h>

#include <cmath>
#include <cstdio>
#include <cstring>

#include "intersection.hpp"
#include "mg_camera.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_visual.hpp"
#include "mglib.hpp"

/**
 *
 * Skinned frame whose bone matrices MotionProc2 and MotionProc3 last set up.
 *
 */
// Small uninitialised data (.sbss)
static mgCFrame *OldSkinFrame;

struct FrameLinkRecord { int count; int link[11]; };
struct CCPolyCopy { float vertex[3][4]; float normal[4]; float attr[4]; };
struct MotionVector { float f[4]; };
extern MotionVector at_945;
extern char at_966[];
extern char at_967[];
extern "C" int GetFootPoly__FPffP6CCPolyPfP6CCPolyii(float *, float, CCPolyCopy *, float *, CCPoly *, int, int);

/**
 *
 * Skinned-vertex accumulator of the frame being skinned; w sums the weights.
 *
 */
// Uninitialised data (.bss)
static float def_vrtx[800][4];

/**
 *
 * Skinned-normal accumulator of the frame being skinned.
 *
 */
static float def_nml[1][4];

// Code (.text)
/**
 *
 * Interpolates between two quaternions, stored w first, along the shorter arc.
 *
 */
static void QuatSlerp(float *q0, float *q1, float t, float *out) {
    float cosTheta;
    float scale0;
    float scale1;
    float theta;
    float invSin;

    cosTheta = (q0[3] * q1[3]) + ((q0[1] * q1[1]) + (q0[2] * q1[2])) + (q0[0] * q1[0]);
    scale1 = t;
    if (cosTheta < 0.0f) {
        q1[0] = -q1[0];
        cosTheta = -cosTheta;
        q1[1] = -q1[1];
        q1[2] = -q1[2];
        q1[3] = -q1[3];
    }
    if (cosTheta < 0.01f) {
        out[1] = q1[1];
        out[2] = q1[2];
        out[3] = q1[3];
        out[0] = q1[0];
    } else {
        if (!((1.0f - cosTheta) <= 0.01f)) {
            theta = acosf(cosTheta);
            invSin = 1.0f / sinf(theta);
            scale0 = invSin * sinf((1.0f - scale1) * theta);
            scale1 = invSin * sinf(scale1 * theta);
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
    unsigned int  frame_no = (unsigned int) time;
    int high;
    int low;
    int middle;
    unsigned int count = list->key_count;
    low = 0;
    high = count;
    int next;
    mgCFrame *frame;
    int key;
    unsigned int key_frame;
    float t;
    float one_minus_t;
    float value[4];
    float rotation[4];
    float from[4];
    float to[4];

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

    if (next > count + -1) {
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
            int vertex;
            int driven=list->frame;
            sceVu0FVECTOR *vertices=((mgCVisualMDT *)frame->visual)->vertex;
            do {
            if (!(t <= 0.001f) && t < 0.999f) {
                Mot_List *node=list;
                while (driven == node->frame) {
                    vertex=list->target-1;
                    sceVu0InterVectorXYZ(value,list->values[next],list->values[key],t);
                    sceVu0CopyVectorXYZ(vertices[vertex],value);
                    list=list->next;
                    do {if(list==NULL)break;node=list;goto t_nonnull0;}while(0); return NULL; t_nonnull0:;
                }
                break;
            }
            if (t <= 0.001f) {
                Mot_List *node=list;
                while (driven == node->frame) {
                    sceVu0CopyVectorXYZ(vertices[list->target-1],list->values[key]);
                    list=list->next;
                    do {if(list==NULL)break;node=list;goto t_nonnull1;}while(0); return NULL; t_nonnull1:;
                }
            }
            if (!(t < 0.999f)) {
                Mot_List *node=list;
                while (driven == node->frame) {
                    sceVu0CopyVectorXYZ(vertices[list->target-1],list->values[next]);
                    list=list->next;
                    do {if(list==NULL)break;node=list;goto t_nonnull2;}while(0); return NULL; t_nonnull2:;
                }
            }
            }while(0);
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
            // The look-at position is never interpolated from the keys here.
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
        case MOTION_KEY_UNK_33:
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
    int high;
    int low;
    int key;
    int next;
    mgCFrame *frame;
    float one_minus_blend;
    float value[4];
    float rotation[4];
    float from[4];
    float to[4];
    {
        int high = list->key_count;
        int low = 0;
        int middle;
        while(low<high) {
            key = (middle = (low + high) >> 1);
            if(list->key_frames[key]<=from_frame) low=key+1; else high=key;
        }
        key=low-1;
    }
    {
        high=list->key_count;
        low=0;
        while(low<high) {
            next=(low+high)>>1;
            if(list->key_frames[next]<=to_frame) low=next+1; else high=next;
        }
        next=low-1;
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
            int vertex;
            int driven=list->frame;
            sceVu0FVECTOR *vertices=((mgCVisualMDT *)frame->visual)->vertex;
            do {
            if (!(blend <= 0.0001f) && blend < 0.9999f) {
                Mot_List *node=list;
                while (driven == node->frame) {
                    vertex=list->target-1;
                    sceVu0InterVectorXYZ(value,list->values[next],list->values[key],blend);
                    sceVu0CopyVectorXYZ(vertices[vertex],value);
                    list=list->next;
                    do {if(list==NULL)break;node=list;goto blend_nonnull0;}while(0); return NULL; blend_nonnull0:;
                }
                break;
            }
            if (blend <= 0.0001f) {
                Mot_List *node=list;
                while (driven == node->frame) {
                    sceVu0CopyVectorXYZ(vertices[list->target-1],list->values[key]);
                    list=list->next;
                    do {if(list==NULL)break;node=list;goto blend_nonnull1;}while(0); return NULL; blend_nonnull1:;
                }
            }
            if (!(blend < 0.9999f)) {
                Mot_List *node=list;
                while (driven == node->frame) {
                    sceVu0CopyVectorXYZ(vertices[list->target-1],list->values[next]);
                    list=list->next;
                    do {if(list==NULL)break;node=list;goto blend_nonnull2;}while(0); return NULL; blend_nonnull2:;
                }
            }
            }while(0);
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
        case MOTION_KEY_UNK_33:
            if (list->values[key][0] < 1.0f) {
                frame->attr->draw = MG_FRAME_DRAW_SKIP_CHILDREN;
            } else {
                frame->attr->draw = MG_FRAME_DRAW_VISIBLE;
            }

            break;
    }

    return list->next;
}

/**
 *
 * Adds a vertex moved by a bone matrix and scaled by its weight to an accumulated vertex, and writes the sum to both the accumulator and an output vertex.
 *
 */
#pragma global_optimizer off
static void testVUnew(float (*matrix)[4], float *point, float *scale, float *base, float *out) {
    asm {
        lqc2 vf4, 0(matrix)
        lqc2 vf5, 0x10(matrix)
        lqc2 vf6, 0x20(matrix)
        lqc2 vf7, 0x30(matrix)
        lqc2 vf8, 0(point)
        vmulax.xyzw ACC, vf4, vf8x
        vmadday.xyzw ACC, vf5, vf8y
        vmaddaz.xyzw ACC, vf6, vf8z
        vmaddw.xyzw vf12, vf7, vf8w
        lqc2 vf4, 0(base)
        lqc2 vf5, 0(scale)
        vmulx.xyz vf6, vf12, vf5x
        vadd.xyzw vf6, vf4, vf6
        sqc2 vf6, 0(base)
        sqc2 vf6, 0(out)
    }
}
#pragma global_optimizer reset

#pragma global_optimizer off
Mot_List *MotionProc2(mgCFrame *frame, tagMOTION_TYPE *motion, tagFRAME_INF *frameInfo,
                      Mot_List *list) {
    float finalMatrix[4][4];
    float frameMatrix[4][4];
    float relative[4][4];
    float skinToFrame[4][4];
    float relativeInv[4][4];
    float keyMatrix[4][4];
    
    float scratch[5];
    mgCFrame *target;
    mgCFrame *skin;
    u32 i;
    int vertexNo;
    int left;
    float *clear;

    if (list->key_count == 0) {
        return list->next;
    }
    target = frame->GetFrame(list->target);
    skin = frame->GetFrame(list->frame);
    if (OldSkinFrame != skin) {
        OldSkinFrame = frame->GetFrame(list->frame);
        vert_845 = ((mgCVisualMDT *)skin->visual)->vertex;
        left = ((tagFRAME_INF *)((list->frame << 5) + (int)frameInfo))->vertex_count;
        
        clear = def_vrtx[0];
        while (left > 0) {
            asm {
                sqc2 vf0, 0(clear)
            }
            left--;
            clear += 4;
        }
        skin->GetLWMatrix(tmp_SkinMatrix_847);
        frame->GetLWMatrix(tmp_ChrMatrix_849);
        mgInversMatrix(tmp_SkinMatrix_inv_848, tmp_SkinMatrix_847);
        int skinOffset = list->frame << 6;
        mgMulMatrix(tmp_BaseSkinMatrix_851, tmp_ChrMatrix_849,
                    (float(*)[4])((u8 *)motion->base_matrices + skinOffset));
        mgInversMatrix(tmp_BaseSkinMatrix_inv_852, tmp_BaseSkinMatrix_851);
    }
    sceVu0UnitMatrix(frameMatrix);
    sceVu0UnitMatrix(tmp_SkinMatrix_847);
    target->GetLWMatrix(frameMatrix);
    mgMulMatrix(keyMatrix, tmp_ChrMatrix_849,
                (float(*)[4])((u8 *)motion->base_matrices + (list->target << 6)));
    mgMulMatrix(relative, tmp_BaseSkinMatrix_inv_852, keyMatrix);
    mgInversMatrix(relativeInv, relative);
    mgMulMatrix(skinToFrame, tmp_SkinMatrix_inv_848, frameMatrix);
    mgMulMatrix(finalMatrix, skinToFrame, relativeInv);
    for (i = 0; i < list->key_count; i++) {
        scratch[4] = 0.01f * list->values[i][0];
        vertexNo = list->key_frames[i];
        if (list->type == 0x14) {
            testVUnew(finalMatrix,
                      ((tagFRAME_INF *)((list->frame << 5) + (int)frameInfo))->base_vertices[vertexNo],
                      &scratch[4], &def_vrtx[vertexNo][0], vert_845[vertexNo]);
        } else {
            sceVu0ApplyMatrix(
                scratch, finalMatrix,
                ((tagFRAME_INF *)((list->frame << 5) + (int)frameInfo))->base_vertices[vertexNo]);
            scratch[3] = 0;
            def_vrtx[vertexNo][0] += scratch[0];
            *(float *)((u8 *)&def_vrtx[0][1] + vertexNo * 16) += scratch[1];
            *(float *)((u8 *)&def_vrtx[0][2] + vertexNo * 16) += scratch[2];
            def_vrtx[vertexNo][0] /= *(float *)((u8 *)&def_vrtx[0][3] + vertexNo * 16);
            *(float *)((u8 *)&def_vrtx[0][1] + vertexNo * 16) /=
                *(float *)((u8 *)&def_vrtx[0][3] + vertexNo * 16);
            *(float *)((u8 *)&def_vrtx[0][2] + vertexNo * 16) /=
                *(float *)((u8 *)&def_vrtx[0][3] + vertexNo * 16);
            sceVu0CopyVectorXYZ(vert_845[vertexNo], def_vrtx[vertexNo]);
            
            int off = vertexNo * 16;
            *(float *)((u8 *)&def_vrtx[0][3] + off) += 1.0f;
        }
    }
    return list->next;
}
#pragma global_optimizer reset

Mot_List *MotionProc3(mgCFrame *root, tagMOTION_TYPE *motion, tagFRAME_INF *frame_info, Mot_List *list) {
    float deform[4][4];
    float rotate[4][4];
    float bone_matrix[4][4];
    float bone_in_skin[4][4];
    float skin_bone[4][4];
    float bone_in_skin_inv[4][4];
    float bone_base[4][4];
    float normal[4];
    mgCFrame *bone;
    mgCFrame *skin;
    int vertex;
    unsigned int i;

    if (list->type != MOTION_KEY_SKIN_WEIGHTED) {
        return list->next;
    }

    bone = root->GetFrame(list->target);
    skin = root->GetFrame(list->frame);

    if (OldSkinFrame != skin) {
        OldSkinFrame = root->GetFrame(list->frame);
        mgCVisualMDT *visual = (mgCVisualMDT *)skin->visual;
        vert_915 = visual->vertex;
        nml_916 = visual->normal;

        if (((tagFRAME_INF *)((list->frame << 5) + (int)frame_info))->vertex_count > 400) {
            printf(at_966, ((tagFRAME_INF *)((list->frame << 5) + (int)frame_info))->vertex_count, 400);
        }

        if (((tagFRAME_INF *)((list->frame << 5) + (int)frame_info))->normal_count > 800) {
            printf(at_967, ((tagFRAME_INF *)((list->frame << 5) + (int)frame_info))->normal_count, 800);
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
        skin->GetLWMatrix(tmp_SkinMatrix_917);
        root->GetLWMatrix(tmp_ChrMatrix_919);
        sceVu0InversMatrix(tmp_SkinMatrix_inv_918, tmp_SkinMatrix_917);
        mgMulMatrix(tmp_BaseSkinMatrix_921, tmp_ChrMatrix_919, motion->base_matrices[list->frame]);
        mgInversMatrix(tmp_BaseSkinMatrix_inv_922, tmp_BaseSkinMatrix_921);
    }

    sceVu0UnitMatrix(bone_matrix);
    sceVu0UnitMatrix(tmp_SkinMatrix_917);
    bone->GetLWMatrix(bone_matrix);
    mgMulMatrix(bone_base, tmp_ChrMatrix_919, motion->base_matrices[list->target]);
    mgMulMatrix(bone_in_skin, tmp_BaseSkinMatrix_inv_922, bone_base);
    mgInversMatrix(bone_in_skin_inv, bone_in_skin);
    mgMulMatrix(skin_bone, tmp_SkinMatrix_inv_918, bone_matrix);
    mgMulMatrix(deform, skin_bone, bone_in_skin_inv);

    // Normals turn with the bone but do not move with it.
    sceVu0CopyMatrix(rotate, deform);
    rotate[3][0] = 0.0f;
    rotate[3][1] = 0.0f;
    rotate[3][2] = 0.0f;

    for (unsigned int index = 0; index < list->key_count; index++) {
        MotionVector weight = at_945;

        weight.f[0] = 0.01f * list->values[index][0];

        if (!(weight.f[0] <= 0.0f)) {
            vertex = list->key_frames[index];
            testVUnew(deform, frame_info[list->frame].base_vertices[vertex], weight.f, def_vrtx[vertex], vert_915[vertex]);
            sceVu0ApplyMatrix(normal, rotate, frame_info[list->frame].base_normals[vertex]);
            sceVu0InterVectorXYZ(nml_916[vertex], normal, frame_info[list->frame].base_normals[vertex], weight.f[0]);
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

/**
 *
 * Allocates a key list's values and key frames and fills them from the keys of a motion file.
 *
 */
static void SetKeyFrame(Mot_List *list, FRAME_VECTOR_EX_DATA *keys, mgCMemory *memory) {
    
    list->values = (float(*)[4])memory->Alloc((list->key_count * 16 / 16) + 1);
    list->key_frames = (u32 *)memory->Alloc((list->key_count * 4 >> 4) + 1);
    u32 i = 0;
    while (i < list->key_count) {
        float *value = list->values[i];
        u32 *time = &list->key_frames[i];
        i++;
        value[0] = keys->value[0];
        value[1] = keys->value[1];
        value[2] = keys->value[2];
        value[3] = keys->value[3];
        *time = keys->frame;
        keys++;
    }
}

void ChangeWeight(Mot_List *list, mgCMemory *memory, u8 *data, int frameNo, tagFRAME_INF *frameInfo,
                  mgCVisualMDT *mesh, mgCFrame *frame, mgCFrame *sourceFrame) {
    Mot_List *prev;
    Mot_File_List *header;
    Mot_List *head;
    FRAME_VECTOR_EX_DATA *cursor;
    Mot_List *oldPrev;
    Mot_List *channel;
    Mot_List *cur;
    FRAME_VECTOR_EX_DATA *keys;
    int *srcVertices;
    int *srcUvs;
    int i;
    mgFACE_GROUP *node;
    mgCFace *indexList;
    int *indices;
    int pos;
    FrameLinkRecord *record;

    prev = list;
    cur = list;
    if (cur != NULL) {
        do {
            if (frameNo == cur->frame) {
                prev->next = cur->next;
            } else {
                prev = cur;
            }
            cur = cur->next;
        } while (cur != NULL);
    }
    cursor = (FRAME_VECTOR_EX_DATA *)data;
    head = NULL;
    do {
        header = (Mot_File_List *)cursor;
        channel = (Mot_List *)memory->Alloc(3);
        channel->frame = frameNo;
        
        channel->target =
            frame->SearchFrameID(sourceFrame->GetFrame((u32)header->target)->name);
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
    } while ((u64)header->more != 0);
    oldPrev = NULL;
    if (channel != NULL) {
        do {
            cur = oldPrev;
            oldPrev = head;
            head = head->next;
            oldPrev->next = cur;
        } while (head != NULL);
    }
    prev->next = oldPrev;
    if (mesh != NULL) {
        srcVertices = (int *)mesh->vertex;
        srcUvs = (int *)mesh->normal;
        frameInfo[frameNo].base_vertices = (float(*)[4])memory->Alloc((mesh->vertex_num * 16U / 16) + 1);
        frameInfo[frameNo].base_normals = (float(*)[4])memory->Alloc(((u32)mesh->normal_num * 16 / 16) + 1);
        frameInfo[frameNo].vertex_refs =
            (int(*)[12])memory->Alloc(((u32)(mesh->vertex_num * 0x30) >> 4) + 1);
        frameInfo[frameNo].vertex_count = mesh->vertex_num;
        frameInfo[frameNo].normal_count = mesh->normal_num;
        memcpy(frameInfo[frameNo].base_vertices, srcVertices, mesh->vertex_num * 16);
        memcpy(frameInfo[frameNo].base_normals, srcUvs, mesh->normal_num * 16);
        for (i = 0; i < mesh->vertex_num; i++) {
            frameInfo[frameNo].vertex_refs[i][0] = 0;
        }
        node = (mgFACE_GROUP *)mesh->face_group;
        if (node != NULL) {
            do {
                indexList = node->face;
                if (indexList != NULL) {
                    do {
                        indices = indexList->index;
                        pos = 0;
                        if (!(node->face->type & 0x200)) {
                            while (pos < indexList->index_num) {
                                int from = indices[pos];
                                pos++;
                                int to = indices[pos];
                                pos += indexList->index_stride - 1;
                                record = (FrameLinkRecord *)&frameInfo[frameNo].vertex_refs[from];
                                record->link[record->count] = to;
                                record = (FrameLinkRecord *)&frameInfo[frameNo].vertex_refs[from];
                                record->count++;
                            }
                            indexList = indexList->next;
                        } else {
                            break;
                        }
                    } while (indexList != NULL);
                }
                node = node->next;
            } while (node != NULL);
        }
    }
}

int CreateAnimeDataEX(tagMOTION_TYPE *motion, mgCMemory *memory, MOTION_FILE_INFO *info) {
    FRAME_VECTOR_EX_DATA *cursor;
    Mot_List *channel;
    Mot_File_List *header;
    FRAME_VECTOR_EX_DATA *keys;
    FRAME_VECTOR_EX_DATA *deformCursor;
    Mot_List *deformChannel;
    Mot_File_List *deformHeader;
    FRAME_VECTOR_EX_DATA *deformKeys;
    Mot_List *head;
    Mot_List *prev;
    Mot_List *oldPrev;
    Mot_List *cur;

    
    if (info[0].name != 0) {
        motion->base_matrices = (sceVu0FMATRIX *)memory->Alloc((info[0].size / 16) + 1);
        memcpy(motion->base_matrices, info[0].data, info[0].size);
    }
    
    if (info[1].name != 0) {
        cursor = (FRAME_VECTOR_EX_DATA *)info[1].data;
        motion->motion_list = NULL;
        do {
            header = (Mot_File_List *)cursor;
            channel = (Mot_List *)memory->Alloc(3);
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
        } while ((u64)header->more != 0); 
        prev = NULL;
        while ((cur = motion->motion_list) != NULL) {
            oldPrev = prev;
            prev = cur;
            motion->motion_list = cur->next;
            cur->next = oldPrev;
        }
        motion->motion_list = prev;
    }
    if (info[2].name != 0) {
        deformCursor = (FRAME_VECTOR_EX_DATA *)info[2].data;
        motion->skin_list = NULL;
        do {
            deformHeader = (Mot_File_List *)deformCursor;
            deformChannel = (Mot_List *)memory->Alloc(3);
            deformChannel->frame = deformHeader->frame;
            deformChannel->target = deformHeader->target;
            deformChannel->key_count = deformHeader->key_count;
            deformChannel->type = deformHeader->type;
            deformCursor++;
            deformKeys = deformCursor;
            deformCursor += deformChannel->key_count;
            SetKeyFrame(deformChannel, deformKeys, memory);
            head = motion->skin_list;
            if (head == NULL) {
                deformChannel->next = NULL;
            } else {
                deformChannel->next = head;
            }
            motion->skin_list = deformChannel;
        } while ((u64)deformHeader->more != 0);
        prev = NULL;
        while ((cur = motion->skin_list) != NULL) {
            oldPrev = prev;
            prev = cur;
            motion->skin_list = cur->next;
            cur->next = oldPrev;
        }
        motion->skin_list = prev;
    }
    return 1;
}

void AnimeDataInit(mgCFrame *root, tagMOTION_TYPE *motion, mgCMemory *memory, tagFRAME_INF **frame_info) {
    // A frame's skinning data is built once, from the first key list that skins it.
    *frame_info = (tagFRAME_INF *) memory->stAlloc64((root->GetFrameNum() + 10) * sizeof(tagFRAME_INF) / 16 + 1);
    AnimeDataInit(root, motion, memory, *frame_info);
}

int AnimeDataInit(mgCFrame *frame, tagMOTION_TYPE *motion, mgCMemory *memory,
                  tagFRAME_INF *frameInfo) {
    Mot_List *channel = motion->skin_list;
    int i;
    int frameNum;
    int j;
    mgCVisualMDT *mesh;
    mgFACE_GROUP *node;
    mgCFace *list;
    int *indices;
    int pos;
    FrameLinkRecord *record;
    int *srcVertices;
    int *srcUvs;
    mgCFrame *target;

    frameNum = frame->GetFrameNum();
    i = 0;
    if (i < frameNum) {
        do {
            int frameNo =
                ((int)frame->GetFrame(i)->parent - (int)frame) /
                272; 
            tagFRAME_INF *info = &frameInfo[i];
            i++;
            info->parent = frameNo;
            info->vertex_count = 0;
            info->normal_count = 0;
        } while (i < frameNum);
    }
    if (channel != NULL) {
        do {
            if (channel->type == 0x14 || channel->type == 0x15) {
                frame->GetFrame(channel->target);
                target = frame->GetFrame(channel->frame);
                if (frameInfo[channel->frame].vertex_count == 0 && target != NULL) {
                    mesh = (mgCVisualMDT *)target->visual;
                    
                    if (mesh != NULL && mesh != NULL) {
                        srcVertices = (int *)mesh->vertex;
                        srcUvs = (int *)mesh->normal;
                        frameInfo[channel->frame].base_vertices =
                            (float(*)[4])memory->Alloc((mesh->vertex_num * 16U / 16) + 1);
                        frameInfo[channel->frame].base_normals =
                            (float(*)[4])memory->Alloc(((u32)mesh->normal_num * 16 / 16) + 1);
                        frameInfo[channel->frame].vertex_refs = (int(*)[12])memory->Alloc(
                            ((u32)(mesh->vertex_num * 0x30) >> 4) + 1);
                        frameInfo[channel->frame].vertex_count = mesh->vertex_num;
                        frameInfo[channel->frame].normal_count = mesh->normal_num;
                        memcpy(frameInfo[channel->frame].base_vertices, srcVertices,
                               mesh->vertex_num * 16);
                        memcpy(frameInfo[channel->frame].base_normals, srcUvs, mesh->normal_num * 16);
                        for (j = 0; j < mesh->vertex_num; j++) {
                            frameInfo[channel->frame].vertex_refs[j][0] = 0;
                        }
                        node = (mgFACE_GROUP *)mesh->face_group;
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
                                                record = (FrameLinkRecord *)&frameInfo[channel->frame].vertex_refs[from];
                                                record->link[record->count] = to;
                                                record = (FrameLinkRecord *)&frameInfo[channel->frame].vertex_refs[from];
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
    float point[4];
    float diff[4];
    float polyMin[4];
    float polyMax[4];
    float segMax[4];
    float segMin[4];
    float offset[4];
    float bestDist;
    float d0;
    float d1;
    float dist;
    int i;
    int best;
    CCPoly *poly;
    int count;
    int hasBest;

    if (collision == NULL) {
        return 0;
    }
    best = -1;
    hasBest = 0;
    mgVectorMaxMin(segMax, segMin, from, to);
    
    {
        float *minPtr;
        float *maxPtr;
        maxPtr = segMax;
        minPtr = segMin;
        asm {
            lqc2 vf10, 0(maxPtr)
            lqc2 vf11, 0(minPtr)
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
        
        mgVectorMaxMin(polyMax, polyMin, poly->vertex[0], poly->vertex[1], poly->vertex[2]);
        if (segMax[0] < polyMin[0] || segMax[1] < polyMin[1] || segMax[2] < polyMin[2]) {
            continue;
        }
        if (!(segMin[0] <= polyMax[0]) || !(segMin[1] <= polyMax[1]) ||
            !(segMin[2] <= polyMax[2])) {
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
        if (hasBest == 0) {
            bestDist = dist;
            best = i;
            sceVu0CopyVector(hit, point);
        } else if (!(bestDist <= dist)) {
            bestDist = dist;
            best = i;
            sceVu0CopyVector(hit, point);
        }
        hasBest = 1;
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
    float end[3];
    float bestY;
    int i;
    int best;
    CCPoly *poly;
    int count;

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
                if (!(pos[1] <= hit[1]) && (best < 0 || (best >= 0 && bestY <= hit[1]))) {
                    best = i;
                    bestY = hit[1];
                }
            } else {
                if (pos[1] < hit[1] && (best < 0 || (best >= 0 && !(bestY < hit[1])))) {
                    best = i;
                    bestY = hit[1];
                }
            }
        }
    }
    if (best >= 0) {
        hit[1] = bestY;
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

#pragma global_optimizer off
int CheckHits(CollisionInfo *collision, float *from, float *to, int maxHits, int *hitIndex,
              float (*hitPoint)[4], int sortDir, int mask) {
    float point[4];
    float polyMin[4];
    float polyMax[4];
    float segMax[4];
    float segMin[4];
    float offset[4];
    float swap[4];
    float d0;
    float d1;
    int i;
    int hits;
    CCPoly *poly;
    int count;
    int j;
    int swapIndex;
    float *minPtr;
    float *maxPtr;

    hits = 0;
    mgVectorMaxMin(segMax, segMin, from, to);
    
    maxPtr = segMax;
    minPtr = segMin;
    asm {
        lqc2 vf10, 0(maxPtr)
        lqc2 vf11, 0(minPtr)
    }
    i = 0;
    poly = collision->polys;
    count = collision->count;
    while (i < count) {
        if (poly->ignore_mask & mask) {
            goto next;
        }
        
        mgVectorMaxMin(polyMax, polyMin, poly->vertex[0], poly->vertex[1], poly->vertex[2]);
        if (segMax[0] < polyMin[0] || segMax[1] < polyMin[1] || segMax[2] < polyMin[2]) {
            goto next;
        }
        if (!(segMin[0] <= polyMax[0]) || !(segMin[1] <= polyMax[1]) ||
            !(segMin[2] <= polyMax[2])) {
            goto next;
        }
        
        sceVu0SubVector(offset, from, poly->vertex[0]);
        d0 = sceVu0InnerProduct(poly->normal, offset);
        sceVu0SubVector(offset, to, poly->vertex[0]);
        d1 = sceVu0InnerProduct(poly->normal, offset);
        if (!(d0 <= 0.0f || d1 <= 0.0f)) {
            goto next;
        }
        if (d0 < 0.0f && d1 < 0.0f) {
            goto next;
        }
        if (mgIntersectionPoint_line_poly3(from, to, poly->vertex[0], poly->vertex[1],
                                           poly->vertex[2], poly->normal, point) == 0) {
            goto next;
        }
        if (hits < maxHits) {
            hitIndex[hits] = i;
            sceVu0CopyVector(hitPoint[hits], point);
            
            *(float *)((hits << 4) + (int)hitPoint + 12) = mgDistVector(from, point);
            hits++;
        } else {
            break;
        }
    next:
        i++;
        poly++;
    }
    if (sortDir == 0) {
        return hits;
    }
    
    {
        if (sortDir > 0) {
            for (i = 0; i < hits - 1; i++) {
                for (j = i + 1; j < hits; j++) {
                    if (!(*(float *)((i << 4) + (int)hitPoint + 12) <=
                          *(float *)((j << 4) + (int)hitPoint + 12))) {
                        swapIndex = hitIndex[i];
                        hitIndex[i] = hitIndex[j];
                        hitIndex[j] = swapIndex;
                        sceVu0CopyVector(swap, hitPoint[i]);
                        sceVu0CopyVector(hitPoint[i], hitPoint[j]);
                        sceVu0CopyVector(hitPoint[j], swap);
                    }
                }
            }
        }
        if (sortDir < 0) {
            for (i = 0; i < hits - 1; i++) {
                for (j = i + 1; j < hits; j++) {
                    if (!(*(float *)((i << 4) + (int)hitPoint + 12) <=
                          *(float *)((j << 4) + (int)hitPoint + 12))) {
                        swapIndex = hitIndex[i];
                        hitIndex[i] = hitIndex[j];
                        hitIndex[j] = swapIndex;
                        sceVu0CopyVector(swap, hitPoint[i]);
                        sceVu0CopyVector(hitPoint[i], hitPoint[j]);
                        sceVu0CopyVector(hitPoint[j], swap);
                    }
                }
            }
        }
    }
    return hits;
}
#pragma global_optimizer reset

int CheckHitsPipeY(CCPoly *polys, int count, float *from, float height, int max_hits, int *hit_polys, sceVu0FVECTOR *hit_points, int sort, int ignore_mask) {
    float best[4];
    float poly_min[4];
    float poly_max[4];
    float pipe_max[4];
    float pipe_min[4];
    float top[4];
    float points[11][4];
    float swap[4];
    CCPoly       *poly;
    float         radius;
    float         normal_y;
    int           point_count;
    int           j;
    int           found;
    int           hits;
    int           i;
    int index;

    hits = 0;
    radius = from[3];
    *(u_long128 *)top = *(u_long128 *)from;
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

        // A wall that is nearly upright has no height under the pipe.
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

        // Keep the highest point that lies within the pipe's height.
        found = 0;

        for (j = 0; j < point_count; j++) {
            if (points[j][1] <= pipe_max[1] && !(points[j][1] < pipe_min[1])) {
                if (found == 0) {
                    *(u_long128 *)best = *(u_long128 *)points[j];
                    found = 1;
                } else if (!(points[j][1] <= best[1])) {
                    *(u_long128 *)best = *(u_long128 *)points[j];
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

    if (sort == 0) return hits;
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

        // A descending sort was never written; it sorts ascending as well.
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
    float best[4];
    float poly_min[4];
    float poly_max[4];
    float pipe_max[4];
    float pipe_min[4];
    float dir[4];
    float points[11][4];
    float offset[4];
    float swap[4];
    CCPoly       *poly;
    float         radius;
    float         length;
    float         along;
    int           point_count;
    int           j;
    int           found;
    int           hits;
    int           i;
    int index;

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

        // Keep the point nearest the pipe's start among those along its length; w holds the distance.
        found = 0;

        for (j = 0; j < point_count; j++) {
            sceVu0SubVector(offset, points[j], from);
            along = sceVu0InnerProduct(offset, dir);
            points[j][3] = along;

            if (!(along < 0.0f) && along <= length) {
                if (found == 0) {
                    *(u_long128 *)best = *(u_long128 *)points[j];
                    found = 1;
                } else if (points[j][3] < best[3]) {
                    *(u_long128 *)best = *(u_long128 *)points[j];
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

    if (sort == 0) return hits;
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

        // A descending sort was never written; it sorts ascending as well.
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
    float push[4];
    float poly_min[4];
    float poly_max[4];
    float sphere_max[4];
    float sphere_min[4];
    float normal[4];
    float swap[4];
    int i;
    int hits;
    CCPoly *poly;
    int j;
    int index;

    hits = 0;
    float radius = sphere[3];
    *(u_long128 *)sphere_max = *(u_long128 *)sphere;
    *(u_long128 *)sphere_min = *(u_long128 *)sphere;
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

    if (sort == 0) return hits;
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

        // A descending sort was never written; it sorts ascending as well.
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
    int hitIndex[64];
    float hitPoint[64][4];
    float scratch[4];
    union { CCPolyCopy poly; CCPolyCopy copy; } foot;
    float footProbe[4];
    float probe[4];
    float radius;
    float margin;
    int tries;
    int wallSides;

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
        if (CheckHitsPipe(polys, count, start, end, 0x40, hitIndex, hitPoint, 1, mask) <= 0) {
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
    sceVu0CopyVector(footProbe, start);
    if (info->skip_ground == 0) {
        if (GetFootPoly__FPffP6CCPolyPfP6CCPolyii(footProbe, 20.0f, &foot.poly, point, polys, count, mask)) {
            sceVu0Normalize(foot.copy.normal, foot.copy.normal);
            *(CCPolyCopy *)&info->ground_poly = foot.copy;
            *(CCPolyCopy *)&info->second_poly = foot.copy;
            info->ground_found = 1;
            info->landed = 0;
            *(u_long128 *)info->ground_point = *(u_long128 *)point;
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
    *(u_long128 *)probe = *(u_long128 *)out;
    probe[1] += 5.0f;
    wallSides = CheckWidth(polys, count, probe, radius, end, mask);
    info->width_result = wallSides;
    if (wallSides) {
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
        sceVu0CopyVector(footProbe, start);
        if (GetFootPoly__FPffP6CCPolyPfP6CCPolyii(footProbe, 20.0f, &foot.poly, point, polys, count, mask)) {
            *(u_long128 *)info->ground_point = *(u_long128 *)point;
            if (!(point[1] <= start[1] + vel[1] - 10.0f - margin)) {
                out[1] = point[1];
            }
        }
    }
    GetCPolyAttr(info, pos, out, 34.0f, polys, count, mask);
    return 0;
}
#ifdef NONMATCHING
int GetFootPoly(float *pos, float depth, CCPoly *found, float *ground, CCPoly *polys, int count, int ignore_mask) {
    s16           ground_kind;
    s16           foot_sound;
    s16           area_kind;
    s16           poly_ignore_mask;
    u16           parts_no;
    s16           attribute;
    float         attribute_value;
    int           hit_polys[32];
    sceVu0FVECTOR from;
    sceVu0FVECTOR to;
    sceVu0FVECTOR hit_points[32];
    sceVu0FVECTOR normal;
    float         normal_y;
    CCPoly       *poly;
    int           hits;
    int           found_ground;
    int           i;

    sceVu0CopyVector(from, pos);
    sceVu0CopyVector(to, pos);
    from[3] = 4.0f;
    to[1] -= depth;
    hits = CheckHitsPipeY(polys, count, from, -depth, 32, hit_polys, hit_points, 1, ignore_mask);
    if (hits == 0) {
        return 0;
    }
    ground_kind = 0;
    foot_sound = 0;
    area_kind = 0;
    found_ground = 0;
    for (i = 0; i < hits; i++) {
        sceVu0Normalize(normal, polys[hit_polys[i]].normal);
        normal_y = normal[1];
        if (normal_y < 0.0f) {
            normal_y = -normal_y;
        }
        if (normal_y < 0.05f) {
            continue;
        }
        *found = polys[hit_polys[i]];
        sceVu0CopyVector(ground, hit_points[i]);
        found_ground = 1;
        ground[0] = from[0];
        ground[2] = from[2];
        ground_kind = found->ground_kind;
        foot_sound = found->foot_sound;
        area_kind = found->area_kind;
        poly_ignore_mask = found->ignore_mask;
        parts_no = found->parts_no;
        attribute = found->unk_4a;
        attribute_value = found->unk_4c;
        break;
    }
    for (i = 0; i < hits; i++) {
        poly = &polys[hit_polys[i]];
        if (ground_kind == 0) {
            ground_kind = poly->ground_kind;
        }
        if (foot_sound == 0) {
            foot_sound = poly->foot_sound;
        }
        if (area_kind == 0) {
            area_kind = poly->area_kind;
        }
    }
    found->ground_kind = ground_kind;
    found->foot_sound = foot_sound;
    found->area_kind = area_kind;
    found->ignore_mask = poly_ignore_mask;
    found->parts_no = parts_no;
    found->unk_4a = attribute;
    found->unk_4c = attribute_value;
    return found_ground;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gameutil", GetFootPoly__FPffP6CCPolyPfP6CCPolyii);
#endif
void GetCPolyAttr(MoveCheckInfo *info, float *from, float *to, float dy, CCPoly *polys, int count,
                  int unused) {
    int hit_index[32];
    float probe_from[4];
    float probe_to[4];
    float hit_point[64][4];
    int hits;
    int i;
    s16 kind;

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

                *(u_long128 *)info->crossed_point = *(u_long128 *)hit_point[i];
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
                *(u_long128 *)info->water_surface = *(u_long128 *)hit_point[i];
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
    int sides;
    int saw_first;
    int saw_second;
    int index;
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
    int hit_index[32];
    float hit_point[32][4];
    int sides;
    int has_high;
    int has_low;
    float reach;
    int hit;

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
        *(u_long128 *)hit_high = *(u_long128 *)hit_point[0];
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
        *(u_long128 *)hit_low = *(u_long128 *)hit_point[0];
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
        *(u_long128 *)hit_high = *(u_long128 *)hit_point[0];
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
        *(u_long128 *)hit_low = *(u_long128 *)hit_point[0];
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
int CreateCharaCPoly(CCPoly *polys, int max_polys, float *pos, float *target, float max_len, float radius) {
    float dir[4];
    float center[4];
    float corner0[4];
    float corner1[4];
    float corner2[4];
    float corner3[4];
    float len;

    if (max_polys < 2) {
        return 0;
    }
    sceVu0SubVector(dir, target, pos);
    dir[1] = 0.0f;
    len = mgDistVector(dir);
    if (len > max_len) {
        len = max_len;
    }
    if (len < max_len) {
        len -= 1.0f;
    }
    sceVu0Normalize(dir, dir);
    corner0[0] = -dir[2] * radius;
    corner0[1] = radius;
    corner0[2] = dir[0] * radius;
    corner0[3] = 1.0f;
    sceVu0CopyVector(corner1, corner0);
    corner1[0] = -corner0[0];
    corner1[2] = -corner0[2];
    sceVu0CopyVector(corner2, corner0);
    corner2[1] = -radius;
    sceVu0CopyVector(corner3, corner1);
    corner3[1] = -radius;
    sceVu0ScaleVector(center, dir, len);
    sceVu0AddVector(center, center, pos);
    sceVu0AddVector(corner0, corner0, center);
    sceVu0AddVector(corner1, corner1, center);
    sceVu0AddVector(corner2, corner2, center);
    sceVu0AddVector(corner3, corner3, center);

    *(u_long128 *)&polys[0].ground_kind = 0;
    sceVu0CopyVector(polys[0].vertex[0], corner0);
    sceVu0CopyVector(polys[0].vertex[1], corner1);
    sceVu0CopyVector(polys[0].vertex[2], corner2);
    sceVu0CopyVector(polys[0].normal, dir);
    *(u_long128 *)&polys[1].ground_kind = 0;
    sceVu0CopyVector(polys[1].vertex[0], corner2);
    sceVu0CopyVector(polys[1].vertex[1], corner1);
    sceVu0CopyVector(polys[1].vertex[2], corner3);
    sceVu0CopyVector(polys[1].normal, dir);
    return 2;
}
float LinerInterpolation(float from, float to, float rate) {
    return from + (rate * (to - from));
}
#pragma divbyzerocheck on
int LinerInterpolationI(int from, int to, int t, int range) {
    return from + (to - from) * t / range;
}
#pragma divbyzerocheck reset
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
    float dx = (rect->x + rect->width / 2) - x;
    float dy = (rect->y + rect->height / 2) - y;
    return sqrt(dx * dx + dy * dy);
}
s32 CheckPosInOutFor2P(float x0, float y0, float x1, float y1, float x, float y) {
    float min_x;
    float max_x;
    float max_y;
    float min_y;
    s32 outside;

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
#ifdef NONMATCHING
int CalcIntersectionPointLineAndLine(float ax0, float ay0, float ax1, float ay1, float bx0, float by0, float bx1, float by1, float *out_x, float *out_y) {
    float slope_a;
    float slope_b;
    float relative_x;

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
        *out_y = (relative_x * slope_a) + ay0;
        return 1;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/gameutil", CalcIntersectionPointLineAndLine__FffffffffPfPf);
#endif
s32 CalcIntersectionPoint2PAnd2P(float ax0, float ay0, float ax1, float ay1, float bx0, float by0, float bx1, float by1, float *out_x, float *out_y) {
    if (CalcIntersectionPointLineAndLine(ax0, ay0, ax1, ay1, bx0, by0, bx1, by1, out_x, out_y) == 0) {
        return 0;
    }
    if (CheckPosInOutFor2P(ax0, ay0, ax1, ay1, *out_x, *out_y) == 0) {
        return 0;
    }
    return CheckPosInOutFor2P(bx0, by0, bx1, by1, *out_x, *out_y) != 0;
}

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gameutil", at_966__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/gameutil", at_967__DATA);

INCLUDE_BSS(vert_845, 0x10);
INCLUDE_BSS(vert_915, 0x10);
INCLUDE_BSS(nml_916, 0x4);

INCLUDE_BSS(tmp_SkinMatrix_847, 0x40);
INCLUDE_BSS(tmp_SkinMatrix_inv_848, 0x40);
INCLUDE_BSS(tmp_ChrMatrix_849, 0x40);
INCLUDE_BSS(tmp_BaseSkinMatrix_851, 0x40);
INCLUDE_BSS(tmp_BaseSkinMatrix_inv_852, 0x40);
INCLUDE_BSS(tmp_SkinMatrix_917, 0x40);
INCLUDE_BSS(tmp_SkinMatrix_inv_918, 0x40);
INCLUDE_BSS(tmp_ChrMatrix_919, 0x40);
INCLUDE_BSS(tmp_BaseSkinMatrix_921, 0x40);
INCLUDE_BSS(tmp_BaseSkinMatrix_inv_922, 0x40);
INCLUDE_BSS(at_945, 0x10);
