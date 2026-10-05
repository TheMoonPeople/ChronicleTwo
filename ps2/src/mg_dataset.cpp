#include "common.h"
#include "mg_texture.hpp"
#include "mg_dataset.hpp"
#include <cstdio>
#include <cstring>
#include <libvu0.h>
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_shadow.hpp"
#include "mg_visual.hpp"
#include "visualmotion.hpp"

#include "mglib.hpp"
extern u_char at_717[];
extern char __vt__12mgCShadowMDT[];
extern char __vt__12mgCVisualMDT[];
extern char __vt__15mgCShadowFixMDT[];
extern char __vt__15mgCVisualFixMDT[];
extern char __vt__18mgCVisualMotionMDT[];
extern char __vt__9mgCVisual[];
extern char at_387[];
extern char at_550[];
extern char at_618[];
extern char *name_def_276;
extern s8 init_277;
extern int flag_571;
extern s8 init_572;
extern "C" void *__nw__FUiP1(u_int size, void *where);
extern "C" void *__nwa__FUiP1(u_int size, void *where);
extern "C" mgCFrameAttr *__ct__12mgCFrameAttrFv(mgCFrameAttr *self);
extern "C" mgCObject *__ct__8mgCFrameFv(mgCObject *self);
extern "C" void *__construct_new_array(void *, mgCObject *(*)(mgCObject *), void *, u_int, int);

/**
 * Writes an object name with its "__" attribute marker turned into "--" and each attribute flag
 * after it in the form mgSetFrameAttr reads, and returns the length of the result with its end.
 */
// Code (.text)
#pragma schedule off
#pragma opt_loop_invariants off
#pragma global_optimizer off
int conv_new_text(char *dst, char *src) {
    char *out;
    s32 more;
    s8 c;
    if (src == 0) {
        return 0;
    }
    out = dst;
    more = 1;
    while ((c = *(s8 *)src) != 0) {
        if ((s8)c == 0) {
            more = 0;
            break;
        }
        if (c == '_' && ((s8 *)src)[1] == '_') {
            src += 2;
            out[0] = '-';
            out[1] = '-';
            out += 2;
            break;
        }
        *out = c;
        src++;
        out++;
    }
    while (more != 0) {
        c = *(s8 *)src;
        if (c == 0) {
            break;
        }
        switch (c) {
            case 'c':
            case 'C':
                out[0] = 'c';
                out[1] = '0';
                out += 2;
                break;
            case 'n':
            case 'N':
                out[0] = 'n';
                out[1] = '1';
                out += 2;
                break;
            case 'a':
            case 'A':
                out[0] = 'a';
                out[1] = ((s8 *)src)[1];
                src += 2;
                out[2] = *(s8 *)src;
                out += 3;
                break;
            case 'z':
            case 'Z':
                out[0] = 'z';
                out[1] = '0';
                out += 2;
                break;
            case 'f':
            case 'F':
                out[0] = 'f';
                out[1] = '0';
                out += 2;
                break;
            case 's':
            case 'S':
                out[0] = 's';
                out[1] = '1';
                out += 2;
                break;
            case 'm':
            case 'M':
                out[0] = 'm';
                out[1] = '1';
                out += 2;
                break;
            case 'b':
            case 'B':
                out[0] = 'b';
                out++;
                src++;
                c = *(s8 *)src;
                if (c == 0) {
                    src--;
                } else {
                    *out = c;
                    out++;
                }
                break;
            case 't':
            case 'T':
                out[0] = 't';
                out++;
                break;
            case 'o':
            case 'O':
                out[0] = 'o';
                out[1] = '1';
                out += 2;
                break;
            case 'v':
            case 'V':
                out[0] = 'v';
                out[1] = '0';
                out += 2;
                break;
        }
        src++;
    }
    *out = 0;
    return strlen(dst) + 1;
}
#pragma schedule reset

/**
 * Reads a string of hexadecimal digits and returns its value; any other character counts as zero.
 */
#pragma schedule off
#pragma global_optimizer reset
#pragma opt_loop_invariants reset
#pragma global_optimizer off
static int htoi(char *text) {
    s8 *end = (s8 *)text;
    s32 length = 0;
    s32 value = 0;
    while (*end++ != 0) {
        length++;
    }
    s32 i;
    s32 place = 1;
    for (i = 0; i < length; i++) {
        s32 back = length - i;
        s32 ch = ((u8 *)(back + (s32)text))[-1];
        s32 digit = 0;
        if (ch >= '0' && ch <= '9') {
            digit = ch - '0';
        }
        if (ch >= 'a' && ch <= 'f') {
            digit = ch - 'a' + 10;
        }
        if (ch >= 'A' && ch <= 'F') {
            digit = ch - 'A' + 10;
        }
        value += digit * place;
        place <<= 4;
    }
    return value;
}
#pragma schedule reset

#pragma global_optimizer reset
#pragma schedule off
#pragma global_optimizer off
#pragma opt_loop_invariants off
void mgSetFrameAttr(mgCFrame *input_frame, int input_recursive) {
    mgCFrameAttr *attr;
    char *cursor;
    char *text;
    int recursive;
    mgCFrame *frame;
    char *end;
    frame = input_frame;
    recursive = input_recursive;
    if (frame == NULL) {
        return;
    }
    mgCFrameAttr default_attr;
    int apply;
    int mask;
    char code[3];
    mgCFrame *child;
    s8 current;

    attr = frame->attr;
    if (attr == NULL) {
        attr = &default_attr;
    }

    cursor = frame->name;
    if (init_277 == 0) {
        name_def_276 = at_387;
        init_277 = 1;
    }
    if (cursor == NULL) {
        cursor = name_def_276;
    }
    text = cursor;

    while ((current = *(s8 *)text) != 0) {
        if ((s8)current == 0) {
            apply = 0;
            break;
        } else {
            if (current == '-' && ((s8 *)text)[1] == '-') {
                text += 2;
                break;
            }
        }
        text++;
    }

    end = text + strlen(text) + 1;
    apply = 0;

    for (; text < end; text++) {
        mask = 0;

        switch (*text) {
            case 'c':
            case 'C':
                text++;
                attr->no_light = (*text - '0') == 0;
                mask = MG_FRAME_ATTR_NO_LIGHT | MG_FRAME_ATTR_COLOR;
                break;
            case 'n':
            case 'N':
                text++;
                attr->clip_enable = (*text - '0') != 0;
                mask = MG_FRAME_ATTR_CLIP;
                break;
            case 'a':
            case 'A': {
                char *second;
                int first;
                code[0] = text[1];
                text += 2;
                *(second = code + 1) = *text;
                code[2] = '\0';

                if (code[0] >= 'a' && code[0] <= 'z') {
                    code[0] -= 'a' - 'A';
                }

                if (*second >= 'a' && *second <= 'z') {
                    *second -= 'a' - 'A';
                }

                first = code[0];
                if (first == 'P' && *second == 'P') {
                    attr->alpha_blend = MG_ALPHA_MACRO_ADD;
                    mask = MG_FRAME_ATTR_ALPHA_BLEND;
                } else if (first == 'N' && *second == 'N') {
                    attr->alpha_blend = MG_ALPHA_MACRO_SUB;
                    mask = MG_FRAME_ATTR_ALPHA_BLEND;
                } else if (first == 'O' && *second == 'F') {
                    mask = MG_FRAME_ATTR_ALPHA_BLEND;
                    attr->alpha_blend = MG_ALPHA_MACRO_OPAQUE;
                } else {
                    attr->alpha_ref = (short)htoi(code);
                    mask |= MG_FRAME_ATTR_ALPHA_REF;
                }
                break;
            }
            case 'z':
            case 'Z':
                text++;
                if (*text == 'p' || *text == 'P') {
                    text++;
                    if ((*text - '0') != 0) {
                        attr->depth_bias = 1.005f;
                    } else {
                        attr->depth_bias = 0.0f;
                    }
                    mask = MG_FRAME_ATTR_DEPTH_BIAS;
                } else {
                    if ((*text - '0') != 0) {
                        attr->z_write = MG_ZBUF_WRITE;
                    } else {
                        attr->z_write = MG_ZBUF_NO_WRITE;
                    }
                    mask = MG_FRAME_ATTR_Z_WRITE;
                }
                break;
            case 'f':
            case 'F':
                text++;
                attr->fog = *text - '0';
                mask = MG_FRAME_ATTR_FOG;
                break;
            case 's':
            case 'S':
                text++;
                attr->program_option = (*text - '0') != 0;
                mask = MG_FRAME_ATTR_PROGRAM_OPT;
                break;
            case 'm':
            case 'M':
                text++;
                attr->program_mode = *text - '0';
                mask = MG_FRAME_ATTR_PROGRAM_MODE;
                break;
            case 'b':
            case 'B':
                text++;
                if (*text == 'Y' || *text == 'y') {
                    attr->billboard = MG_FRAME_BILLBOARD_Y;
                }
                if (*text == 'A' || *text == 'a') {
                    attr->billboard = MG_FRAME_BILLBOARD_FULL;
                }
                mask = MG_FRAME_ATTR_BILLBOARD;
                break;
            case 't':
            case 'T':
                attr->ambient_boost = 1;
                mask = MG_FRAME_ATTR_AMBIENT_BOOST;
                break;
            case 'o':
            case 'O':
                text++;
                if ((*text - '0') != 0) {
                    attr->z_test = MG_DEPTH_TEST_ALWAYS;
                } else {
                    attr->z_test = 0;
                }
                mask = MG_FRAME_ATTR_Z_TEST;
                break;
            case 'v':
            case 'V':
                text++;
                if (*text == 'c' || *text == 'C') {
                    text++;
                    attr->unk_84 = *text - '0';
                } else {
                    if ((*text - '0') != 0) {
                        attr->draw = MG_FRAME_DRAW_VISIBLE;
                    } else {
                        attr->draw = MG_FRAME_DRAW_SKIP_CHILDREN;
                    }
                    mask = MG_FRAME_ATTR_DRAW;
                }
                break;
        }

        if (apply && mask) {
            frame->SetAttrParam(*attr, 1, mask);
        }

        if (*text == '.') {
            apply = 1;
        } else {
            apply = 0;
        }
    }

    if (recursive == 0) {
        return;
    }
    for (child = frame->child; child != NULL; child = child->brother) {
        mgSetFrameAttr(child, recursive);
    }
}
#pragma schedule reset
#pragma global_optimizer reset
#pragma opt_loop_invariants reset


/**
 * Finds the entry of a visual type table that applies to an object name, or NULL if none does.
 */
#pragma schedule off
mgCreateVisualType * SearchVisualType(mgCreateVisualType *table, char *name) {
    mgCreateVisualType *entry;
    mgCreateVisualType *found;
    if (table == 0) {
        return 0;
    }
    entry = table;
    found = 0;
    while (1) {
        if (entry->name == 0) {
            break;
        }
        if (entry->type == -1) {
            break;
        }
        if (mgFrameNameComp(name, entry->name) != 0) {
            found = entry;
            break;
        }
        entry++;
    }
    return found;
}

#pragma schedule reset

/**
 * Sets up one frame from a scene object: its name, transform, parent and attributes, and the
 * visual of the given type built from its model. Returns non-zero if a visual was attached.
 */
#pragma schedule off
#pragma global_optimizer off
#pragma opt_loop_invariants off
static int CreateFrameVisual(mgCFrame *input_frame, mgCMemory *input_memory, mgCMemory *input_work_memory, mgCFrame *input_parent,
                             MDTOBJ_HEADER *input_object, MDT_HEADER *input_mdt, int input_type, mgCTextureManager *input_texture_manager,
                             u_int *weight, int index, mgCFrame **frame_table, float (*matrix_table)[4][4]) {
    mgCVisualMDT *visual;
    int type;
    MDT_HEADER *mdt;
    mgCMemory *memory;
    mgCFrame *frame;
    char *name;
    MDTOBJ_HEADER *object;
    mgCFrame *parent;
    mgCTextureManager *texture_manager;
    mgCMemory *work_memory;
    sceVu0FMATRIX matrix;
    char name_buffer[256];
    sceVu0FVECTOR max;
    sceVu0FVECTOR min;
    sceVu0FVECTOR sphere;
    sceVu0FVECTOR half;
    int len;
    mgCFrameAttr *attr;

    frame = input_frame;
    memory = input_memory;
    work_memory = input_work_memory;
    parent = input_parent;
    object = input_object;
    mdt = input_mdt;
    type = input_type;
    texture_manager = input_texture_manager;

    sceVu0CopyMatrix(matrix, object->matrix);
    len = conv_new_text(name_buffer, object->name);

    name = (char *)memory->Alloc((len + 1) / 16 + 1);
    if (MG_ADDRESS_CHECK(name, at_550) == NULL) {
        return 0;
    }

    strcpy(name, name_buffer);
    frame->SetName(name);
    frame->SetTransMatrix(matrix);
    frame->SetParent(parent);

    int current;
    for (; (current = *(s8 *)name) != 0; name++) {
        if ((s8)current == '-' && name[1] == '-') {
            break;
        }
    }

    if (current != 0 || object->mdt_ofs != 0 || parent == NULL) {
        if ((attr = (mgCFrameAttr *)__nw__FUiP1(0x90, memory->Alloc(0xB))) != 0) {
            attr = __ct__12mgCFrameAttrFv(attr);
        }
        if (attr != NULL) {
            attr->Initialize();
        }
        frame->attr = attr;
    }

    if (object->mdt_ofs == 0) {
        return 0;
    }

    frame->bound = (mgCFrame::BoundInfo *)memory->Alloc(sizeof(mgCFrame::BoundInfo) / 16);
    float (*vertices)[4] = (float (*)[4])((char *)mdt + mdt->vertex_ofs);
    int vertex_num = ((int *)mdt)[3];
    mgCreateBBoxSphere(max, min, sphere, vertices, vertex_num);

    if (type == MG_VISUAL_CREATE_MDT) {
        sceVu0SubVector(half, max, min);
        sceVu0ScaleVector(half, half, 0.5f);
        mgAddVector(max, half);
        mgSubVector(min, half);
        sphere[3] *= 1.5f;
    }

    frame->SetBBox(max, min);
    frame->SetBSphere(sphere, sphere[3]);

    if (type == MG_VISUAL_CREATE_MOTION_MDT && weight == NULL) {
        type = MG_VISUAL_CREATE_FIX_MDT;
    }

    switch (type) {
        case MG_VISUAL_CREATE_MDT: {
            mgCVisualMDT *created;
            if ((created = (mgCVisualMDT *)__nw__FUiP1(0x50, memory->Alloc(0x7))) != 0) {
                *(void **)((char *)created + 0x1C) = __vt__9mgCVisual;
                created->Initialize();
                *(void **)((char *)created + 0x1C) = __vt__12mgCVisualMDT;
                created->Initialize();
            }
            visual = created;
            break;
        }
        case MG_VISUAL_CREATE_FIX_MDT: {
            mgCVisualMDT *created;
            if ((created = (mgCVisualMDT *)__nw__FUiP1(0x50, memory->Alloc(0x7))) != 0) {
                *(void **)((char *)created + 0x1C) = __vt__9mgCVisual;
                created->Initialize();
                *(void **)((char *)created + 0x1C) = __vt__12mgCVisualMDT;
                created->Initialize();
                *(void **)((char *)created + 0x1C) = __vt__15mgCVisualFixMDT;
                created->Initialize();
            }
            visual = created;
            break;
        }
        case MG_VISUAL_CREATE_MOTION_MDT: {
            mgCVisualMDT *created;
            if ((created = (mgCVisualMDT *)__nw__FUiP1(0x110, memory->Alloc(0x13))) != 0) {
                *(void **)((char *)created + 0x1C) = __vt__9mgCVisual;
                created->Initialize();
                *(void **)((char *)created + 0x1C) = __vt__12mgCVisualMDT;
                created->Initialize();
                *(void **)((char *)created + 0x1C) = __vt__15mgCVisualFixMDT;
                created->Initialize();
                *(void **)((char *)created + 0x1C) = __vt__18mgCVisualMotionMDT;
                created->Initialize();
            }
            visual = created;
            break;
        }
        case MG_VISUAL_CREATE_SHADOW_MDT: {
            mgCVisualMDT *created;
            if ((created = (mgCVisualMDT *)__nw__FUiP1(0x50, memory->Alloc(0x7))) != 0) {
                *(void **)((char *)created + 0x1C) = __vt__9mgCVisual;
                created->Initialize();
                *(void **)((char *)created + 0x1C) = __vt__12mgCVisualMDT;
                created->Initialize();
                *(void **)((char *)created + 0x1C) = __vt__12mgCShadowMDT;
            }
            visual = created;
            break;
        }
        case MG_VISUAL_CREATE_SHADOW_FIX_MDT: {
            mgCVisualMDT *created;
            if ((created = (mgCVisualMDT *)__nw__FUiP1(0x50, memory->Alloc(0x7))) != 0) {
                *(void **)((char *)created + 0x1C) = __vt__9mgCVisual;
                created->Initialize();
                *(void **)((char *)created + 0x1C) = __vt__12mgCVisualMDT;
                created->Initialize();
                *(void **)((char *)created + 0x1C) = __vt__12mgCShadowMDT;
                *(void **)((char *)created + 0x1C) = __vt__15mgCShadowFixMDT;
            }
            visual = created;
            break;
        }
    }

    memory->Alloc(1);

    if (visual == NULL) {
        return 0;
    }

    visual->Initialize();

    if (type == MG_VISUAL_CREATE_MOTION_MDT) {
        mgCVMotionData motion;
        memset(&motion, 0, sizeof(motion));
        memset(&motion, 0, sizeof(motion));
        motion.weight_data = weight;
        motion.frame_id = index;
        motion.frame = frame_table;
        motion.base_matrix = matrix_table;
        ((mgCVisualMotionMDT *)visual)->DataAssignMotionMDT(mdt, &motion, memory, work_memory, texture_manager);
        ((mgCVisualMotionMDT *)visual)->SetBaseBox(max, min);
    } else {
        visual->DataAssignMDT(mdt, memory, texture_manager);
    }

    frame->SetVisual(visual);
    return 1;
}
#pragma opt_loop_invariants reset
#pragma schedule reset
#pragma global_optimizer reset


#pragma optimization_level reset
#pragma optimization_level 1
// Defined inline in mg_frame.hpp.
// Defined inline in mg_visual.hpp.
#pragma schedule off
void mgCFrame::SetVisual(mgCVisual *visual) { this->visual = visual; }
#pragma schedule reset
void mgCVisualFixMDT::Initialize() {
    mgCVisualMDT::Initialize();
}
#pragma optimization_level reset
#pragma schedule off
// Defined inline in mg_dataset.hpp.
void mgCVisual::Initialize() {
    unk_00 = 0;
    draw_env = 0;
    texture_manager = 0;
    vu1_offset = 0;
    vu1_base = 0;
}
#pragma schedule reset
#pragma schedule off
mgCFrame *mgLoadMDSFile(MDS_HEADER *mds, mgCMemory *memory, mgCreateVisualType *visual_type, mgCTextureManager *texture_manager) {
    mgLoadData load;

    memset(&load, 0, sizeof(load));
    load.mds = mds;
    load.memory = memory;
    load.visual_type = visual_type;
    load.texture_manager = texture_manager;
    return mgLoadMDSFile(&load);
}

#pragma schedule off
#pragma global_optimizer off
mgCFrame *mgLoadMDSFile(mgLoadData *load) {
    u_int i;
    MDTOBJ_HEADER *object;
    MDS_HEADER *mds;
    mgCFrame *frames;
    MDTOBJ_HEADER *current;
    mgCFrame *frame;
    float (*matrix_table)[4][4];
    mgCFrame **frame_table;
    mgCMemory *memory;
    mgCMemory *work_memory;
    mgCreateVisualType *visual_type;
    mgCTextureManager *texture_manager;
    u_int *weight;
    int default_type;
    int type;
    mgCreateVisualType *entry;
    u_int blocks;
    mgCFrame *parent;
    MDT_HEADER *mdt;

    mds = load->mds;
    memory = load->memory;
    work_memory = load->work_memory;
    visual_type = load->visual_type;
    texture_manager = load->texture_manager;
    weight = load->weight;

    if (mds == NULL) {
        return NULL;
    }

    if (texture_manager == NULL) {
        texture_manager = &mgTexManager;
    }

    if ((int)mds % 16 != 0) {
        printf(at_618, mds);
    }

    default_type = MG_VISUAL_CREATE_FIX_MDT;
    entry = SearchVisualType(visual_type, at_387);
    if (entry != NULL) {
        default_type = entry->type;
    }

    if (init_572 == 0) {
        flag_571 = 0;
        init_572 = 1;
    }

    object = (MDTOBJ_HEADER *)((char *)mds + mds->object_ofs);

    i = mds->object_num;
    if ((i * 0x110) & 0xF) {
        blocks = ((i * 0x110) >> 4) + 1;
    } else {
        blocks = (i * 0x110) >> 4;
    }
    frames = (mgCFrame *)__construct_new_array(
        __nwa__FUiP1(i * 0x110 + 0x10, memory->Alloc(blocks + 2)), __ct__8mgCFrameFv, 0, 0x110, i);
    if ((mds->object_num * 4) & 0xF) {
        blocks = ((mds->object_num * 4) >> 4) + 1;
    } else {
        blocks = (mds->object_num * 4) >> 4;
    }
    frame_table = (mgCFrame **)__nwa__FUiP1(mds->object_num * 4, memory->Alloc(blocks + 2));
    matrix_table = NULL;
    if (weight != NULL) {
        if (((mds->object_num + 2) * 0x40) & 0xF) {
            blocks = (((mds->object_num + 2) * 0x40) >> 4) + 1;
        } else {
            blocks = ((mds->object_num + 2) * 0x40) >> 4;
        }
        matrix_table = (float (*)[4][4])__nwa__FUiP1((mds->object_num + 2) * 0x40, memory->Alloc(blocks + 2));
    }

    for (i = 0; i < mds->object_num; i++) {
        frame_table[i] = &frames[i];
    }

    u_int count;
    for (i = 0; i < (count = mds->object_num); i++) {
        current = object;
        object = (MDTOBJ_HEADER *)((char *)object + object->size);

        frame = &frames[i];
        parent = NULL;
        if (current->parent >= 0) {
            parent = &frames[current->parent];
        }

        frame->Initialize();

        mdt = (MDT_HEADER *)((char *)mds + current->mdt_ofs);
        type = default_type;
        entry = SearchVisualType(visual_type, current->name);
        if (entry != NULL) {
            type = entry->type;
        }

        CreateFrameVisual(frame, memory, work_memory, parent, current, mdt, type,
                          texture_manager, weight, i, frame_table, matrix_table);
    }

    frames->frame_list = frame_table;
    frames->frame_num = count;

    if (matrix_table != NULL) {
        for (i = 0; i < mds->object_num; i++) {
            frame_table[i]->GetLWMatrix(matrix_table[i]);
        }
    }

    frames->init_matrix = matrix_table;
    mgSetFrameAttr(frames, 1);
    return frames;
}
#pragma schedule reset
#pragma global_optimizer reset

#pragma schedule off
#pragma global_optimizer off
void mgCreateBBoxSphere(float *max, float *min, float *sphere, float (*vertex)[4], int vertex_num) {
    if (vertex == 0) {
        min[0] = 0;
        max[0] = 0;
        min[1] = 0;
        max[1] = 0;
        min[2] = 0;
        max[2] = 0;
        sphere[2] = 0;
        sphere[1] = 0;
        sphere[0] = 0;
        sphere[3] = 0;
        return;
    }
    s32 i;
    float *point = (float *)vertex;
    float center[4];
    u_long128 *source = (u_long128 *)at_717;
    u_long128 *dest = (u_long128 *)center;
    *dest = *source;
    sceVu0CopyVector(max, (float *)vertex);
    sceVu0CopyVector(min, (float *)vertex);
    for (i = 0; i < vertex_num; i++) {
        mgVectorMaxMin(max, min, max, min, point);
        point += 4;
    }
    sceVu0AddVector(center, max, min);
    sceVu0ScaleVector(sphere, center, 0.5f);
    float radius = 0.0f;
    sphere[3] = 0;
    point = (float *)vertex;
    for (i = 0; i < vertex_num; i++) {
        float distance = mgDistVector(sphere, point);
        if (distance > radius) {
            radius = distance;
        }
        point += 4;
    }
    sphere[3] = radius;
}
#pragma global_optimizer reset
#pragma schedule reset

/**
 * Copies one frame's contents, name, attributes and bound into another frame, with a copy of its
 * visual when asked; a copied motion model follows the given frame table.
 */
#pragma schedule off
#pragma global_optimizer off
void CopyFrame(mgCFrame *dst, mgCFrame *src, mgCMemory *memory, int copy_visual, mgCFrame **frame_table) {
    *dst = *src;
    if (copy_visual != 0) {
        mgCVisual *sourceVisual = src->visual;
        if (sourceVisual != 0) {
            mgCVisual *visual = sourceVisual->Copy(memory);
            dst->SetVisual(visual);
            if (visual != 0 && visual->Iam() == 3) {

                ((mgCVisualMotionMDT *)visual)->frame = frame_table;
            }
        }
    }
    u_int size = strlen(src->name) + 1;
    s32 blocks;
    if (size & 0xF) {
        blocks = (size >> 4) + 1;
    } else {
        blocks = size >> 4;
    }
    char *name = (char *)memory->Alloc(blocks);
    strcpy(name, src->name);
    dst->SetName(name);
    mgCFrameAttr *sourceAttr = src->attr;
    if (sourceAttr != 0) {
        mgCFrameAttr *attr;
        if ((attr = (mgCFrameAttr *)__nw__FUiP1(0x90, memory->Alloc(0xB))) != 0) {
            attr = __ct__12mgCFrameAttrFv(attr);
        }
        attr->alpha_ref = sourceAttr->alpha_ref;
        attr->alpha_blend = sourceAttr->alpha_blend;
        attr->z_write = sourceAttr->z_write;
        attr->z_test = sourceAttr->z_test;
        attr->alpha_test = sourceAttr->alpha_test;
        attr->dest_alpha_test = sourceAttr->dest_alpha_test;
        attr->draw = sourceAttr->draw;
        attr->clip_enable = sourceAttr->clip_enable;
        attr->unk_20 = sourceAttr->unk_20;
        attr->unk_24 = sourceAttr->unk_24;
        attr->unk_28 = sourceAttr->unk_28;
        attr->program_option = sourceAttr->program_option;
        attr->fog = sourceAttr->fog;
        attr->unk_34 = sourceAttr->unk_34;
        attr->unk_38 = sourceAttr->unk_38;
        attr->unk_3c = sourceAttr->unk_3c;
        attr->program_mode = sourceAttr->program_mode;
        attr->obj_alpha = sourceAttr->obj_alpha;
        attr->no_cull = sourceAttr->no_cull;
        attr->ambient_boost = sourceAttr->ambient_boost;
        *(mgVec4 *)&attr->unk_50[0] = *(mgVec4 *)&sourceAttr->unk_50[0];
        attr->no_light = sourceAttr->no_light;
        *(mgVec4 *)attr->color = *(mgVec4 *)sourceAttr->color;
        attr->point_light = sourceAttr->point_light;
        attr->unk_84 = sourceAttr->unk_84;
        attr->billboard = sourceAttr->billboard;
        attr->depth_bias = sourceAttr->depth_bias;
        dst->attr = attr;
    }
    mgCFrame::BoundInfo *sourceBound = (mgCFrame::BoundInfo *)src->bound;
    if (sourceBound != 0) {
        mgCFrame::BoundInfo *bound = (mgCFrame::BoundInfo *)__nw__FUiP1(0xB0, memory->Alloc(0xD));
        *(mgCFrame::BoundCorners *)bound->corner = *(mgCFrame::BoundCorners *)sourceBound->corner;
        *(mgVec4 *)bound->max = *(mgVec4 *)sourceBound->max;
        *(mgVec4 *)bound->min = *(mgVec4 *)sourceBound->min;
        *(mgVec4 *)bound->center = *(mgVec4 *)sourceBound->center;
        dst->bound = bound;
    }
}
#pragma global_optimizer reset
#pragma schedule reset

// Defined inline in mg_dataset.hpp.
int mgCVisual::Iam() {
    return 0;
}
#pragma schedule reset
#pragma schedule off
// Defined inline in mg_dataset.hpp.
mgCVisual *mgCVisual::Copy(mgCMemory *memory) {
    return this;
}
#pragma schedule reset

/**
 * Copies a frame and its subtree into new frames allocated from memory, and returns the copy of
 * the frame, or NULL if memory ran out.
 */
#pragma schedule off
#pragma global_optimizer off
mgCFrame * CopyFrameSub(mgCFrame *src, mgCMemory *memory, int copy_visual, mgCFrame **frame_table) {
    mgCFrame *frame;
    if ((frame = (mgCFrame *)__nw__FUiP1(0x110, memory->Alloc(0x13))) != 0) {
        frame = (mgCFrame *)__ct__8mgCFrameFv((mgCObject *)frame);
    }
    if (frame == 0) {
        return 0;
    }
    CopyFrame(frame, src, memory, copy_visual, frame_table);
    for (mgCFrame *child = src->child; child != 0; child = child->brother) {
        mgCFrame *copy = CopyFrameSub(child, memory, copy_visual, frame_table);
        if (copy != 0) {
            copy->SetParent(frame);
        }
    }
    return frame;
}
#pragma global_optimizer reset
#pragma schedule reset

#pragma schedule off
#pragma global_optimizer off
mgCFrame *mgCopyFrame(mgCFrame *frame, mgCMemory *memory, int copy_visual) {
    mgCFrame **copyTable;
    u_int bytes;
    u8 *copies;
    s32 i;
    mgCFrame **table;
    mgCFrame *parent;
    mgCFrame *root;
    s32 parentIndex;
    u_int blocks;
    s32 count;
    if (frame == 0 || memory == 0) {
        return 0;
    }
    count = frame->frame_num;
    table = frame->frame_list;
    if (count > 0 && table != 0) {
        bytes = count * 4;
        if (bytes & 0xF) {
            blocks = (bytes >> 4) + 1;
        } else {
            blocks = bytes >> 4;
        }
        copyTable = (mgCFrame **)__nwa__FUiP1(bytes, memory->Alloc(blocks + 2));
        if (copyTable == 0) {
            return 0;
        }
        if (((u_int)count * 0x110) & 0xF) {
            blocks = (((u_int)count * 0x110) >> 4) + 1;
        } else {
            blocks = ((u_int)count * 0x110) >> 4;
        }
        copies = (u8 *)__construct_new_array(
            __nwa__FUiP1(count * 0x110 + 0x10, memory->Alloc(blocks + 2)), __ct__8mgCFrameFv, 0,
            0x110, count);
        for (i = 0; i < count; i++) {
            mgCFrame *copy = (mgCFrame *)(copies + i * 0x110);
            copyTable[i] = copy;
            CopyFrame(copy, table[i], memory, copy_visual, copyTable);
        }
        for (i = 0; i < count; i++) {
            parent = (mgCFrame *)table[i]
                         ->parent;
            if (parent != 0) {
                char *parentName = parent->name;
                parentIndex = frame->SearchFrameID(parentName);
                if (parentIndex >= 0 && parentIndex < count) {
                    ((mgCFrame *)(copies + i * 0x110))->SetParent(copyTable[parentIndex]);
                }
            }
        }
        root = copyTable[0];
        root->frame_list = copyTable;
        root->frame_num = count;
        return copyTable[0];
    }
    return CopyFrameSub(frame, memory, copy_visual, 0);
}
#pragma global_optimizer reset
#pragma schedule reset

#pragma schedule off
void mgCMDTBuilder::Begin(mgCMemory *memory) {
    this->memory = memory;
    header = NULL;

    if (memory != NULL) {
        header = new (memory->Alloc(sizeof(MDT_HEADER) / 16 + 2)) MDT_HEADER;

        if (header != NULL) {
            memset(header, 0, sizeof(MDT_HEADER));
            strcpy(header->magic, "MDT");
            header->header_size = sizeof(MDT_HEADER);
            end = (char *)(header + 1);
            data_type = MG_MDT_DATA_NONE;
            memset(&material, 0, sizeof(material));
        }
    }
}
#pragma schedule reset

#pragma schedule off
MDT_HEADER *mgCMDTBuilder::End() {
    memory->Alloc((end - (char *)header) / 16);
    return header;
}
#pragma schedule reset

#pragma schedule off
void mgCMDTBuilder::End(mgCFrame *frame, mgCVisualMDT *visual, mgLoadData *load) {
    mgCTextureManager *textures;
    MDT_HEADER *block;
    float box_max[4];
    float box_min[4];
    float sphere[4];
    block = End();
    if (frame == 0 || block == 0 || visual == 0) {
        return;
    }
    textures = load->texture_manager;
    if (textures == 0) {
        textures = &mgTexManager;
    }
    MDT_HEADER *mdt = block;
    float (*points)[4] = (float (*)[4])((u8 *)block + mdt->vertex_ofs);
    mgCreateBBoxSphere(box_max, box_min, sphere, points, (u_int)mdt->vertex_num);
    visual->Initialize();
    visual->DataAssignMDT(block, load->memory, textures);
    frame->bound = (mgCFrame::BoundInfo *)__nw__FUiP1(0xB0, load->memory->Alloc(0xD));
    frame->SetVisual(visual);
    frame->SetBBox(box_max, box_min);
    frame->SetBSphere(sphere, sphere[3]);
    mgCFrameAttr *attr;
    if ((attr = (mgCFrameAttr *)__nw__FUiP1(0x90, load->memory->Alloc(0xB))) != 0) {
        attr = __ct__12mgCFrameAttrFv(attr);
    }
    frame->attr = attr;
}
#pragma schedule reset

#pragma schedule off
void mgCMDTBuilder::BeginData(int type) {
    if (data_type == MG_MDT_DATA_NONE) {
        data = end;
        data_num = 0;
        data_type = type;
    }
}
#pragma schedule reset
#pragma schedule off
void mgCMDTBuilder::SetData(float *vector) {
    switch (data_type) {
        case 1:
        case 2:
        case 3:
        case 4:
            *dataCursor++ = *(u_long128 *)vector;
            data_num++;
            return;
        case 5:
            return;
    }
}
#pragma schedule reset

#pragma schedule off
union mgVec4Bits { float f[4]; u_int u[4]; };
extern u_char at_933[];
#pragma global_optimizer off
void mgCMDTBuilder::SetData(float x, float y, float z, float w) {
    mgVec4Bits vector;
    u_long128 *source = (u_long128 *)at_933;
    u_long128 *dest = (u_long128 *)&vector;
    *dest = *source;
    vector.f[0] = x;
    vector.f[1] = y;
    vector.f[2] = z;
    vector.f[3] = w;
    if (data_type == 2) {
        vector.u[3] = 0;
    }
    SetData(vector.f);
}
#pragma schedule reset

#pragma schedule off
#pragma global_optimizer reset
void mgCMDTBuilder::SetMaterial(float *colour, char *texture) {
    if (data_type == MG_MDT_DATA_MATERIAL) {
        *(u_long128 *)material.diffuse = *(u_long128 *)colour;
        strcpy(material.texture, texture);
        *materialCursor = material;
        materialCursor++;
        data_num++;
    }
}
#pragma schedule reset

#pragma schedule off
void mgCMDTBuilder::EndData() {
    switch (data_type) {
        case 1:
            ((int *)header)[4] = cursor - (s32)header;
            ((int *)header)[3] = data_num;
            break;
        case 4:
            ((int *)header)[8] = cursor - (s32)header;
            ((int *)header)[7] = data_num;
            break;
        case 2:
            ((int *)header)[6] = cursor - (s32)header;
            ((int *)header)[5] = data_num;
            break;
        case 3:
            ((int *)header)[12] = cursor - (s32)header;
            ((int *)header)[11] = data_num;
            break;
        case 5:
            ((int *)header)[14] = cursor - (s32)header;
            ((int *)header)[13] = data_num;
            break;
    }
    cursor = sectionStart;
    data_type = 0;
}
#pragma schedule reset

#pragma schedule off
void mgCMDTBuilder::BeginFaces() {
    header->faces_ofs = end - (char *)header;
    faces = (MDT_FACES *)end;
    memset(faces, 0, sizeof(MDT_FACES));
    faces->header_size = sizeof(MDT_FACES);
    end += sizeof(MDT_FACES);
    index = (int *)end;
}
#pragma schedule reset

#pragma schedule off
void mgCMDTBuilder::EndFaces() {
    ((int *)header)[9] = faceEnd - faceBlockAddr;
    s32 misalign = faceEnd & 0xF;
    if (misalign > 0) {
        faceEnd = faceEnd + 0x10 - misalign;
    }
    cursor = faceEnd;
}
#pragma schedule reset

#pragma schedule off
void mgCMDTBuilder::BeginPrim(int type, int material) {
    prim = (FACES_ID *)index;
    index += 2;
    prim->type = type;
    prim->face_num = 0;

    face_index_num = 3;
    if (type & MG_FACE_NO_TEXTURE) {
        face_index_num--;
    }
    if (type & MG_FACE_COLOUR) {
        face_index_num++;
    }
    if (type & MG_FACE_NO_NORMAL) {
        face_index_num--;
    }

    index_num = 0;
    *index++ = material;
}
#pragma schedule reset

#pragma schedule off
void mgCMDTBuilder::AddFace(int vertex) {
    s32 *p = faceCursor;
    faceCursor = (s32 *)((u8 *)p + 4);
    *p = vertex;
    index_num += 1;
}
#pragma schedule reset

#pragma schedule off
#pragma divbyzerocheck on
void mgCMDTBuilder::EndPrim() {
    prim->face_num = index_num / face_index_num;
    faces->prim_num++;
}
#pragma schedule reset

#pragma optimization_level reset
#pragma schedule off
// Defined inline in mg_visual.hpp.
#pragma divbyzerocheck reset
int mgCVisualMDT::Iam() {
    return MG_VISUAL_KIND_MDT;
}
#pragma schedule reset
#pragma schedule off
// Defined inline in mg_visual.hpp.
int mgCVisualMDT::GetMaterialNum() {
    return material_num;
}
#pragma schedule reset
#pragma schedule off
// Defined inline in mg_visual.hpp.
mgMaterial *mgCVisualMDT::GetpMaterial() {
    return material;
}
#pragma schedule reset
#pragma optimization_level 1
// Defined inline in mg_visual.hpp.
void mgCVisualMDT::Draw(float (*matrix)[4], mgCDrawManager *draw_manager) {
    Draw(NULL, matrix, draw_manager);
}
#pragma optimization_level reset
#pragma schedule off
// Defined inline in mg_dataset.hpp.
int mgCVisual::CreatePacket(mgCMemory *memory, mgCMemory *scratch) {
    return 0;
}
#pragma schedule reset
#pragma schedule off
// Defined inline in mg_dataset.hpp.
int mgCVisual::GetMaterialNum() {
    return 0;
}
#pragma schedule reset
#pragma schedule off
// Defined inline in mg_dataset.hpp.
mgMaterial *mgCVisual::GetpMaterial() {
    return 0;
}
#pragma schedule reset
#pragma schedule off
// Defined inline in mg_dataset.hpp.
mgMaterial *mgCVisual::GetMaterial(int index) {
    return 0;
}
#pragma schedule reset
#pragma schedule off
// Defined inline in mg_dataset.hpp.
int mgCVisual::CreateBBox(float *box_min, float *box_max, float (*matrix)[4]) {
    return 0;
}
#pragma schedule reset
#pragma schedule off
// Defined inline in mg_dataset.hpp.
int mgCVisual::CreateRenderInfoPacket(u_int *packet, float (*matrix)[4], mgRENDER_INFO *info) {
    return 0;
}
#pragma schedule reset
#pragma schedule off
// Defined inline in mg_dataset.hpp.
int mgCVisual::Draw(u_int *packet, float (*matrix)[4], mgCDrawManager *manager) {
    return 0;
}
#pragma schedule reset
#pragma optimization_level 1
// Defined inline in mg_dataset.hpp.
void mgCVisual::Draw(float (*matrix)[4], mgCDrawManager *manager) {
    Draw(0, matrix, manager);
}
#pragma optimization_level reset

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_dataset", at_387__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_dataset", at_550__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_dataset", at_618__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_dataset", at_886__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_dataset", __vt__15mgCShadowFixMDT__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_dataset", __vt__9mgCVisual__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(name_def_276, 0x4);
INCLUDE_BSS(init_277, 0x4);
INCLUDE_BSS(flag_571, 0x4);
INCLUDE_BSS(init_572, 0x4);

// Uninitialised data (.bss)
INCLUDE_BSS(at_717, 0x10);
INCLUDE_BSS(at_933, 0x10);
