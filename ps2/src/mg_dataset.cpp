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

/**
 * Writes an object name with its "__" attribute marker turned into "--" and each attribute flag
 * after it in the form mgSetFrameAttr reads, and returns the length of the result with its end.
 */
// Code (.text)
int conv_new_text(char *dst, char *src) {
    char *out;
    int has_attr;

    if (src == NULL) {
        return 0;
    }

    has_attr = 1;
    out = dst;

    for (; *src != '\0'; src++) {
        if (*src == '\0') {
            has_attr = 0;
            break;
        }

        if (src[0] == '_' && src[1] == '_') {
            src += 2;
            *out++ = '-';
            *out++ = '-';
            break;
        }

        *out++ = *src;
    }

    for (; has_attr && *src != '\0'; src++) {
        switch (*src) {
            case 'V':
            case 'v':
                *out++ = 'v';
                *out++ = '0';
                break;
            case 'O':
            case 'o':
                *out++ = 'o';
                *out++ = '1';
                break;
            case 'T':
            case 't':
                *out++ = 't';
                break;
            case 'B':
            case 'b':
                *out++ = 'b';
                if (src[1] != '\0') {
                    *out++ = src[1];
                    src++;
                }
                break;
            case 'M':
            case 'm':
                *out++ = 'm';
                *out++ = '1';
                break;
            case 'S':
            case 's':
                *out++ = 's';
                *out++ = '1';
                break;
            case 'F':
            case 'f':
                *out++ = 'f';
                *out++ = '0';
                break;
            case 'Z':
            case 'z':
                *out++ = 'z';
                *out++ = '0';
                break;
            case 'A':
            case 'a':
                *out++ = 'a';
                *out++ = src[1];
                *out++ = src[2];
                src += 2;
                break;
            case 'N':
            case 'n':
                *out++ = 'n';
                *out++ = '1';
                break;
            case 'C':
            case 'c':
                *out++ = 'c';
                *out++ = '0';
                break;
        }
    }

    *out = '\0';
    return strlen(dst) + 1;
}

/**
 * Reads a string of hexadecimal digits and returns its value; any other character counts as zero.
 */
int htoi(char *text) {
    char *cursor;
    int len;
    int value;
    int i;
    int place;
    int ch;
    int digit;

    len = 0;
    value = 0;

    for (cursor = text; *cursor != '\0'; cursor++) {
        len++;
    }

    place = 1;

    for (i = 0; i < len; i++) {
        ch = (u_char)text[len - i - 1];
        digit = 0;

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

#ifdef NONMATCHING
void mgSetFrameAttr(mgCFrame *frame, int recursive) {
    if (frame != NULL) {
        mgCFrameAttr default_attr;
        mgCFrameAttr *attr;
        char *text;
        char *end;
        int apply;
        int mask;
        char code[3];
        mgCFrame *child;

        attr = frame->attr;
        if (attr == NULL) {
            attr = &default_attr;
        }

        static char *name_def = "";

        text = frame->name;
        if (text == NULL) {
            text = name_def;
        }

        for (; *text != '\0'; text++) {
            if (*text == '\0') {
                break;
            }

            if (text[0] == '-' && text[1] == '-') {
                text += 2;
                break;
            }
        }

        end = text + strlen(text) + 1;
        apply = 0;

        for (; text < end; text++) {
            mask = 0;

            switch (*text) {
                case 'V':
                case 'v':
                    text++;
                    if (*text == 'c' || *text == 'C') {
                        text++;
                        attr->unk_84 = *text - '0';
                    } else {
                        attr->draw = (*text - '0') != 0 ? MG_FRAME_DRAW_VISIBLE : MG_FRAME_DRAW_SKIP_CHILDREN;
                        mask = MG_FRAME_ATTR_DRAW;
                    }
                    break;
                case 'O':
                case 'o':
                    text++;
                    attr->z_test = (*text - '0') != 0 ? MG_DEPTH_TEST_ALWAYS : 0;
                    mask = MG_FRAME_ATTR_Z_TEST;
                    break;
                case 'T':
                case 't':
                    attr->ambient_boost = 1;
                    mask = MG_FRAME_ATTR_AMBIENT_BOOST;
                    break;
                case 'B':
                case 'b':
                    text++;
                    if (*text == 'Y' || *text == 'y') {
                        attr->billboard = MG_FRAME_BILLBOARD_Y;
                    }
                    if (*text == 'A' || *text == 'a') {
                        attr->billboard = MG_FRAME_BILLBOARD_FULL;
                    }
                    mask = MG_FRAME_ATTR_BILLBOARD;
                    break;
                case 'M':
                case 'm':
                    text++;
                    attr->program_mode = *text - '0';
                    mask = MG_FRAME_ATTR_PROGRAM_MODE;
                    break;
                case 'S':
                case 's':
                    text++;
                    attr->program_option = (*text - '0') != 0;
                    mask = MG_FRAME_ATTR_PROGRAM_OPT;
                    break;
                case 'F':
                case 'f':
                    text++;
                    attr->fog = *text - '0';
                    mask = MG_FRAME_ATTR_FOG;
                    break;
                case 'Z':
                case 'z':
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
                case 'A':
                case 'a':
                    code[0] = text[1];
                    text += 2;
                    code[1] = *text;
                    code[2] = '\0';

                    if (code[0] >= 'a' && code[0] <= 'z') {
                        code[0] -= 'a' - 'A';
                    }

                    if (code[1] >= 'a' && code[1] <= 'z') {
                        code[1] -= 'a' - 'A';
                    }

                    if (code[0] == 'P' && code[1] == 'P') {
                        attr->alpha_blend = MG_ALPHA_MACRO_ADD;
                        mask = MG_FRAME_ATTR_ALPHA_BLEND;
                    } else if (code[0] == 'N' && code[1] == 'N') {
                        attr->alpha_blend = MG_ALPHA_MACRO_SUB;
                        mask = MG_FRAME_ATTR_ALPHA_BLEND;
                    } else if (code[0] == 'O' && code[1] == 'F') {
                        mask = MG_FRAME_ATTR_ALPHA_BLEND;
                        attr->alpha_blend = MG_ALPHA_MACRO_OPAQUE;
                    } else {
                        attr->alpha_ref = (short)htoi(code);
                        mask |= MG_FRAME_ATTR_ALPHA_REF;
                    }
                    break;
                case 'N':
                case 'n':
                    text++;
                    attr->clip_enable = (*text - '0') != 0;
                    mask = MG_FRAME_ATTR_CLIP;
                    break;
                case 'C':
                case 'c':
                    text++;
                    attr->no_light = (*text - '0') == 0;
                    mask = MG_FRAME_ATTR_NO_LIGHT | MG_FRAME_ATTR_COLOR;
                    break;
            }

            // A flag that follows a '.' is also pushed down the frame's subtree.
            if (apply && mask) {
                frame->SetAttrParam(*attr, 1, mask);
            }

            apply = *text == '.';
        }

        if (recursive) {
            for (child = frame->child; child != NULL; child = child->brother) {
                mgSetFrameAttr(child, recursive);
            }
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_dataset", mgSetFrameAttr__FP8mgCFramei);
#endif

/**
 * Finds the entry of a visual type table that applies to an object name, or NULL if none does.
 */
mgCreateVisualType * SearchVisualType(mgCreateVisualType *table, char *name) {
    if (table == NULL) {
        return NULL;
    }

    for (; table->name != NULL && table->type != MG_VISUAL_CREATE_END; table++) {
        if (mgFrameNameComp(name, table->name)) {
            return table;
        }
    }

    return NULL;
}

#ifdef NONMATCHING

/**
 * Sets up one frame from a scene object: its name, transform, parent and attributes, and the
 * visual of the given type built from its model. Returns non-zero if a visual was attached.
 */
static int CreateFrameVisual(mgCFrame *frame, mgCMemory *memory, mgCMemory *work_memory, mgCFrame *parent,
                             MDTOBJ_HEADER *object, MDT_HEADER *mdt, int type, mgCTextureManager *texture_manager,
                             u_int *weight, int index, mgCFrame **frame_table, float (*matrix_table)[4][4]) {
    sceVu0FMATRIX matrix;
    char name_buffer[256];
    sceVu0FVECTOR max;
    sceVu0FVECTOR min;
    sceVu0FVECTOR sphere;
    sceVu0FVECTOR half;
    mgCVMotionData motion;
    char *name;
    int len;
    mgCFrameAttr *attr;
    mgCVisualMDT *visual;

    sceVu0CopyMatrix(matrix, object->matrix);
    len = conv_new_text(name_buffer, object->name);

    name = (char *)memory->Alloc((len + 1) / 16 + 1);
    if (MG_ADDRESS_CHECK(name, "mgLoadMDSFile") == NULL) {
        return 0;
    }

    strcpy(name, name_buffer);
    frame->SetName(name);
    frame->SetTransMatrix(matrix);
    frame->SetParent(parent);

    for (; *name != '\0'; name++) {
        if (name[0] == '-' && name[1] == '-') {
            break;
        }
    }

    if (*name != '\0' || object->mdt_ofs != 0 || parent == NULL) {
        attr = new (memory->Alloc(sizeof(mgCFrameAttr) / 16 + 2)) mgCFrameAttr;
        if (attr != NULL) {
            attr->Initialize();
        }
        frame->attr = attr;
    }

    if (object->mdt_ofs == 0) {
        return 0;
    }

    frame->bound = (mgCFrame::BoundInfo *)memory->Alloc(sizeof(mgCFrame::BoundInfo) / 16);
    mgCreateBBoxSphere(max, min, sphere, (float (*)[4])((char *)mdt + mdt->vertex_ofs), mdt->vertex_num);

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

    visual = NULL;

    switch (type) {
        case MG_VISUAL_CREATE_SHADOW_FIX_MDT:
            visual = new (memory->Alloc(sizeof(mgCShadowFixMDT) / 16 + 2)) mgCShadowFixMDT;
            break;
        case MG_VISUAL_CREATE_SHADOW_MDT:
            visual = new (memory->Alloc(sizeof(mgCShadowMDT) / 16 + 2)) mgCShadowMDT;
            break;
        case MG_VISUAL_CREATE_MOTION_MDT:
            visual = new (memory->Alloc(sizeof(mgCVisualMotionMDT) / 16 + 2)) mgCVisualMotionMDT;
            break;
        case MG_VISUAL_CREATE_FIX_MDT:
            visual = new (memory->Alloc(sizeof(mgCVisualFixMDT) / 16 + 2)) mgCVisualFixMDT;
            break;
        case MG_VISUAL_CREATE_MDT:
            visual = new (memory->Alloc(sizeof(mgCVisualMDT) / 16 + 2)) mgCVisualMDT;
            break;
    }

    memory->Alloc(1);

    if (visual == NULL) {
        return 0;
    }

    visual->Initialize();

    if (type == MG_VISUAL_CREATE_MOTION_MDT) {
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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_dataset", CreateFrameVisual__FP8mgCFrameP9mgCMemoryP9mgCMemoryP8mgCFrameP13MDTOBJ_HEADERP10MDT_HEADERiP17mgCTextureManagerPUiiPP8mgCFramePA4_A4_f);
#endif

#pragma optimization_level reset
#pragma optimization_level 1
// Defined inline in mg_frame.hpp.
// Defined inline in mg_visual.hpp.
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

#ifdef NONMATCHING
mgCFrame *mgLoadMDSFile(mgLoadData *load) {
    MDS_HEADER *mds;
    mgCMemory *memory;
    mgCMemory *work_memory;
    mgCreateVisualType *visual_type;
    mgCTextureManager *texture_manager;
    u_int *weight;
    int default_type;
    int type;
    mgCreateVisualType *entry;
    MDTOBJ_HEADER *object;
    MDTOBJ_HEADER *current;
    mgCFrame *frames;
    mgCFrame **frame_table;
    float (*matrix_table)[4][4];
    mgCFrame *frame;
    mgCFrame *parent;
    u_int i;

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
        printf("address error!! %d \n", mds);
    }

    default_type = MG_VISUAL_CREATE_FIX_MDT;
    entry = SearchVisualType(visual_type, "");
    if (entry != NULL) {
        default_type = entry->type;
    }

    static int flag = 0;

    object = (MDTOBJ_HEADER *)((char *)mds + mds->object_ofs);

    frames = new (memory->Alloc((mds->object_num * sizeof(mgCFrame) + 15) / 16 + 2)) mgCFrame[mds->object_num];
    frame_table = new (memory->Alloc((mds->object_num * sizeof(mgCFrame *) + 15) / 16 + 2)) mgCFrame *[mds->object_num];

    matrix_table = NULL;
    if (weight != NULL) {
        matrix_table = new (memory->Alloc(((mds->object_num + 2) * sizeof(sceVu0FMATRIX) + 15) / 16 + 2)) sceVu0FMATRIX[mds->object_num + 2];
    }

    for (i = 0; i < mds->object_num; i++) {
        frame_table[i] = &frames[i];
    }

    for (i = 0; i < mds->object_num; i++) {
        current = object;
        object = (MDTOBJ_HEADER *)((char *)object + object->size);

        frame = &frames[i];
        parent = NULL;
        if (current->parent >= 0) {
            parent = &frames[current->parent];
        }

        frame->Initialize();

        type = default_type;
        entry = SearchVisualType(visual_type, current->name);
        if (entry != NULL) {
            type = entry->type;
        }

        CreateFrameVisual(frame, memory, work_memory, parent, current, (MDT_HEADER *)((char *)mds + current->mdt_ofs), type,
                          texture_manager, weight, i, frame_table, matrix_table);
    }

    frames->frame_list = frame_table;
    frames->frame_num = mds->object_num;

    if (matrix_table != NULL) {
        for (i = 0; i < mds->object_num; i++) {
            frame_table[i]->GetLWMatrix(matrix_table[i]);
        }
    }

    frames->init_matrix = matrix_table;
    mgSetFrameAttr(frames, 1);
    return frames;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_dataset", mgLoadMDSFile__FP10mgLoadData);
#endif
void mgCreateBBoxSphere(float *max, float *min, float *sphere, float (*vertex)[4], int vertex_num) {
    int i;
    float radius;
    float dist;

    if (vertex == NULL) {
        max[0] = min[0] = 0.0f;
        max[1] = min[1] = 0.0f;
        max[2] = min[2] = 0.0f;
        sphere[0] = sphere[1] = sphere[2] = 0.0f;
        sphere[3] = 0.0f;
    } else {
        sceVu0FVECTOR sum = {0.0f, 0.0f, 0.0f, 0.0f};

        sceVu0CopyVector(max, vertex[0]);
        sceVu0CopyVector(min, vertex[0]);

        for (i = 0; i < vertex_num; i++) {
            mgVectorMaxMin(max, min, max, min, vertex[i]);
        }

        sceVu0AddVector(sum, max, min);
        sceVu0ScaleVector(sphere, sum, 0.5f);
        sphere[3] = 0.0f;

        radius = 0.0f;
        for (i = 0; i < vertex_num; i++) {
            dist = mgDistVector(sphere, vertex[i]);
            if (dist > radius) {
                radius = dist;
            }
        }

        sphere[3] = radius;
    }
}

/**
 * Copies one frame's contents, name, attributes and bound into another frame, with a copy of its
 * visual when asked; a copied motion model follows the given frame table.
 */
void CopyFrame(mgCFrame *dst, mgCFrame *src, mgCMemory *memory, int copy_visual, mgCFrame **frame_table) {
    mgCVisual *visual;
    u_int size;
    char *name;
    mgCFrameAttr *attr;
    mgCFrame::BoundInfo *bound;

    *dst = *src;

    if (copy_visual) {
        if (src->visual != NULL) {
            visual = src->visual->Copy(memory);
            dst->SetVisual(visual);

            if (visual != NULL && visual->Iam() == MG_VISUAL_KIND_MOTION_MDT) {
                ((mgCVisualMotionMDT *)visual)->frame = frame_table;
            }
        }
    }

    size = strlen(src->name) + 1;
    name = (char *)memory->Alloc((size + 15) / 16);
    strcpy(name, src->name);
    dst->SetName(name);

    if (src->attr != NULL) {
        attr = new (memory->Alloc(sizeof(mgCFrameAttr) / 16 + 2)) mgCFrameAttr;
        *attr = *src->attr;
        dst->attr = attr;
    }

    if (src->bound != NULL) {
        bound = new (memory->Alloc(sizeof(mgCFrame::BoundInfo) / 16 + 2)) mgCFrame::BoundInfo;
        *bound = *src->bound;
        dst->bound = bound;
    }
}

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
mgCFrame * CopyFrameSub(mgCFrame *src, mgCMemory *memory, int copy_visual, mgCFrame **frame_table) {
    mgCFrame *frame;
    mgCFrame *child;
    mgCFrame *copy;

    frame = new (memory->Alloc(sizeof(mgCFrame) / 16 + 2)) mgCFrame;
    if (frame == NULL) {
        return NULL;
    }

    CopyFrame(frame, src, memory, copy_visual, frame_table);

    for (child = src->child; child != NULL; child = child->brother) {
        copy = CopyFrameSub(child, memory, copy_visual, frame_table);
        if (copy != NULL) {
            copy->SetParent(frame);
        }
    }

    return frame;
}

mgCFrame *mgCopyFrame(mgCFrame *frame, mgCMemory *memory, int copy_visual) {
    int frame_num;
    mgCFrame **src_table;
    mgCFrame **frame_table;
    mgCFrame *frames;
    mgCFrame *parent;
    int parent_id;
    int i;

    if (frame == NULL || memory == NULL) {
        return NULL;
    }

    frame_num = frame->frame_num;
    src_table = frame->frame_list;

    if (frame_num <= 0 || src_table == NULL) {
        return CopyFrameSub(frame, memory, copy_visual, NULL);
    }

    frame_table = new (memory->Alloc((frame_num * sizeof(mgCFrame *) + 15) / 16 + 2)) mgCFrame *[frame_num];
    if (frame_table == NULL) {
        return NULL;
    }

    frames = new (memory->Alloc((frame_num * sizeof(mgCFrame) + 15) / 16 + 2)) mgCFrame[frame_num];

    for (i = 0; i < frame_num; i++) {
        frame_table[i] = &frames[i];
        CopyFrame(&frames[i], src_table[i], memory, copy_visual, frame_table);
    }

    // Links each copy to the copy of its parent, found by name in the source hierarchy.
    for (i = 0; i < frame_num; i++) {
        parent = src_table[i]->parent;
        if (parent != NULL) {
            parent_id = frame->SearchFrameID(parent->name);
            if (parent_id >= 0 && parent_id < frame_num) {
                frames[i].SetParent(frame_table[parent_id]);
            }
        }
    }

    frame_table[0]->frame_list = frame_table;
    frame_table[0]->frame_num = frame_num;
    return frame_table[0];
}

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

MDT_HEADER *mgCMDTBuilder::End() {
    memory->Alloc((end - (char *)header) / 16);
    return header;
}

void mgCMDTBuilder::End(mgCFrame *frame, mgCVisualMDT *visual, mgLoadData *load) {
    sceVu0FVECTOR max;
    sceVu0FVECTOR min;
    sceVu0FVECTOR sphere;
    MDT_HEADER *mdt;
    mgCTextureManager *texture_manager;

    mdt = End();

    if (frame != NULL && mdt != NULL && visual != NULL) {
        texture_manager = load->texture_manager;
        if (texture_manager == NULL) {
            texture_manager = &mgTexManager;
        }

        mgCreateBBoxSphere(max, min, sphere, (float (*)[4])((char *)mdt + mdt->vertex_ofs), mdt->vertex_num);
        visual->Initialize();
        visual->DataAssignMDT(mdt, load->memory, texture_manager);

        frame->bound = new (load->memory->Alloc(sizeof(mgCFrame::BoundInfo) / 16 + 2)) mgCFrame::BoundInfo;
        frame->SetVisual(visual);
        frame->SetBBox(max, min);
        frame->SetBSphere(sphere, sphere[3]);
        frame->attr = new (load->memory->Alloc(sizeof(mgCFrameAttr) / 16 + 2)) mgCFrameAttr;
    }
}

void mgCMDTBuilder::BeginData(int type) {
    if (data_type == MG_MDT_DATA_NONE) {
        data = end;
        data_num = 0;
        data_type = type;
    }
}
void mgCMDTBuilder::SetData(float *vector) {
    switch (data_type) {
        case MG_MDT_DATA_MATERIAL:
            break;
        case MG_MDT_DATA_COLOUR:
        case MG_MDT_DATA_UV:
        case MG_MDT_DATA_NORMAL:
        case MG_MDT_DATA_VERTEX:
            *(u_long128 *)data = *(u_long128 *)vector;
            data += sizeof(sceVu0FVECTOR);
            data_num++;
            break;
    }
}

void mgCMDTBuilder::SetData(float x, float y, float z, float w) {
    sceVu0FVECTOR vector = {x, y, z, w};

    if (data_type == MG_MDT_DATA_NORMAL) {
        vector[3] = 0.0f;
    }

    SetData(vector);
}

void mgCMDTBuilder::SetMaterial(float *colour, char *texture) {
    if (data_type == MG_MDT_DATA_MATERIAL) {
        *(u_long128 *)material.diffuse = *(u_long128 *)colour;
        strcpy(material.texture, texture);
        *(MDT_MATERIAL_ *)data = material;
        data += sizeof(MDT_MATERIAL_);
        data_num++;
    }
}

void mgCMDTBuilder::EndData() {
    switch (data_type) {
        case MG_MDT_DATA_MATERIAL:
            header->material_ofs = end - (char *)header;
            header->material_num = data_num;
            break;
        case MG_MDT_DATA_UV:
            header->uv_ofs = end - (char *)header;
            header->uv_num = data_num;
            break;
        case MG_MDT_DATA_NORMAL:
            header->normal_ofs = end - (char *)header;
            header->normal_num = data_num;
            break;
        case MG_MDT_DATA_COLOUR:
            header->colour_ofs = end - (char *)header;
            header->colour_num = data_num;
            break;
        case MG_MDT_DATA_VERTEX:
            header->vertex_ofs = end - (char *)header;
            header->vertex_num = data_num;
            break;
    }

    end = data;
    data_type = MG_MDT_DATA_NONE;
}

void mgCMDTBuilder::BeginFaces() {
    header->faces_ofs = end - (char *)header;
    faces = (MDT_FACES *)end;
    memset(faces, 0, sizeof(MDT_FACES));
    faces->header_size = sizeof(MDT_FACES);
    end += sizeof(MDT_FACES);
    index = (int *)end;
}

void mgCMDTBuilder::EndFaces() {
    u_int misalign;

    header->faces_size = (char *)index - (char *)faces;

    // The section after the faces starts on a quadword boundary.
    misalign = (u_int)index & 0xF;
    if (misalign != 0) {
        index = (int *)((char *)index + 16 - misalign);
    }

    end = (char *)index;
}

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

void mgCMDTBuilder::AddFace(int vertex) {
    *index++ = vertex;
    index_num++;
}

void mgCMDTBuilder::EndPrim() {
    prim->face_num = index_num / face_index_num;
    faces->prim_num++;
}

#pragma optimization_level reset
#pragma schedule off
// Defined inline in mg_visual.hpp.
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
