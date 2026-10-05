#include "common.h"
#include "mg_memory.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mg_frame.hpp"
#include "mg_drawenv.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"
#include "mg_dataset.hpp"
#include "mg_visual.hpp"
#include "visualmotion.hpp"

#include <cstring>

// Code (.text)
void mgCVisualMotionMDT::Initialize(void) {
    int slot_count;
    int byte_offset;
    int *slot;

    mgCVisualMDT::Initialize();
    slot_count = 0;
    byte_offset = 0;
    do {
        slot = (int *)((u_char *)this + byte_offset);
        slot_count += 8;
        slot[0x20] = -1;
        slot[0x21] = -1;
        byte_offset += 0x20;
        slot[0x22] = -1;
        slot[0x23] = -1;
        slot[0x24] = -1;
        slot[0x25] = -1;
        slot[0x26] = -1;
        slot[0x27] = -1;
    } while (slot_count < 0x20);
    vu1_base = 0x7C;
    vu1_offset = 0x94;
    weight_num = 0;
    weight = 0;
    base_matrix = 0;
    frame_id = 0;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/visualmotion", CreateVertexWeight__18mgCVisualMotionMDTFPUiiP9mgCMemory);
mgVertexWeight::mgVertexWeight() {
    memset(this, 0, 0x20);
}
void mgCVisualMotionMDT::ChangeWeight(mgCFrame **new_frames, float (*matrix)[4][4], int count) {
    int i;
    int byte_offset;
    int *slot;
    int old;

    byte_offset = 0;
    i = 0;
    do {
        slot = (int *)((u_char *)this + byte_offset + 0x80);
        old = *slot;
        if (old < 0) {
            break;
        }
        *slot = (*new_frames)->SearchFrameID(this->frame[old]->name);
        i += 1;
        byte_offset += 4;
    } while (i < 0x20);
    this->frame = new_frames;
    this->base_matrix = matrix;
    this->frame_id = count;
}
int mgCVisualMotionMDT::DataAssignMotionMDT(MDT_HEADER *header, mgCVMotionData *data,
                                            mgCMemory *memory, mgCMemory *work,
                                            mgCTextureManager *textures) {

    mgCFace *packet;
    int count;
    int part_count;
    u_char *source;
    int i;
    int address;
    int size;
    u_char *section;

    if (work == NULL) {
        return 0;
    }
    work->stack_used = 0;
    work->lock = 0;
    if (textures == NULL) {
        textures = &mgTexManager;
    }
    texture_manager = textures;
    CopyMDTDataPointer(header, memory);
    frame = data->frame;
    base_matrix = data->base_matrix;
    frame_id = data->frame_id;
    CreateVertexWeight(data->weight_data, data->frame_id, work);
    count = 0;
    do {
        if (bone[count] < 0) {
            break;
        }
        count++;
    } while (count < 0x20);
    vu1_base = count * 4 + 0x3C;
    vu1_offset = 0xB4 - (count * 4) / 2;
    mgCMemory scratch;
    size = work->stack_size - work->stack_used;
    scratch.stSetBuffer((u_long128 *)(work->stack + work->stack_used), size);
    face_group = 0;
    section = (u_char *)header + header->faces_ofs;
    part_count = *(int *)(section + 8);
    source = section + 0x10;
    for (i = 0; i < part_count; i++) {
        scratch.stack_used = 0;
        scratch.lock = 0;
        source = (u_char *)CreateFace((FACES_ID *)source, memory, &scratch, &packet);
        address = (int)(memory->stack + memory->stack_used);
        size = CreateFaceMotionPacket((u_int *)address, packet, data);
        ((u_int *)&packet->packet_tag)[0] = size | 0x30000000;
        ((u_int *)&packet->packet_tag)[1] = address;
        ((u_int *)&packet->packet_tag)[2] = 0;
        ((u_int *)&packet->packet_tag)[3] = 0;
        memory->Alloc(size);
    }
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/visualmotion", SetData0__FiiPPiP1P1P1P1P1P14mgVertexWeight);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/visualmotion", SetData1__FiiPPiP1P1P1P1P1P14mgVertexWeight);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/visualmotion", SetData2__FiiPPiP1P1P1P1P1P14mgVertexWeight);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/visualmotion", SetData3__FiiPPiP1P1P1P1P1P14mgVertexWeight);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/visualmotion", SetData4__FiiPPiP1P1P1P1P1P14mgVertexWeight);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/visualmotion", SetData5__FiiPPiP1P1P1P1P1P14mgVertexWeight);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/visualmotion", SetData6__FiiPPiP1P1P1P1P1P14mgVertexWeight);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/visualmotion", SetData7__FiiPPiP1P1P1P1P1P14mgVertexWeight);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/visualmotion", CreateFaceMotionPacket__18mgCVisualMotionMDTFPUiP7mgCFaceP14mgCVMotionData);
int mgCVisualMotionMDT::CreateRenderInfoPacket(u_int *packet, float (*matrix)[4],
                                               mgRENDER_INFO *render_info) {
    render_info->motion = 1;
    int size = mgCVisualMDT::CreateRenderInfoPacket(packet, matrix, render_info);
    render_info->motion = 0;
    return size;
}
int mgCVisualMotionMDT::CreateExtRenderInfoPacket(u_int *packet, float (*matrix)[4],
                                                  mgRENDER_INFO *render_info) {
    float inverse_matrix[4][4];
    float inverse_root[4][4];
    float root_local[4][4];
    float root_matrix[4][4];
    float slot_matrix[4][4];
    float slot_inverse[4][4];
    float frame_matrix[4][4];
    u_int *out;
    int slot_count;
    int i;
    int slot;

    if (frame == NULL) {
        return 0;
    }
    out = packet;
    if (base_matrix == NULL) {
        return 0;
    }
    slot_count = 0;
    do {
        if (bone[slot_count] < 0) {
            break;
        }
        slot_count += 1;
    } while (slot_count < 0x20);
    if (slot_count == 0) {
        return 0;
    }
    mgInversMatrix(inverse_matrix, matrix);
    packet[0] = 0x10000000 | (slot_count << 2);
    packet[1] = 0;
    packet[2] = 0;
    packet[3] = (slot_count << 18) | 0x6C00003C;
    out += 4;
    frame[0]->GetLWMatrix(root_matrix);
    mgMulMatrix(inverse_root, root_matrix, base_matrix[frame_id]);
    mgInversMatrix(root_local, inverse_root);
    if (0 < slot_count) {
        i = 0;
        do {
            slot = bone[i];
            if (frame[slot] != NULL) {
                frame[slot]->GetLWMatrix(frame_matrix);
                mgMulMatrix(slot_matrix, root_matrix, base_matrix[slot]);
                mgMulMatrix(slot_matrix, root_local, slot_matrix);
                mgInversMatrix(slot_inverse, slot_matrix);
                mgMulMatrix(frame_matrix, inverse_matrix, frame_matrix);
                mgMulMatrix((float (*)[4])out, frame_matrix, slot_inverse);
            }
            out += 16;
            i += 1;
        } while (i < slot_count);
    }
    return (out - packet) / 4;
}
void mgCVisualMotionMDT::SetBaseBox(float *box_max, float *box_min) {
    *(u_long128 *)base_box.max = *(u_long128 *)box_max;
    box_max[3] = 1.0f;
    *(u_long128 *)base_box.min = *(u_long128 *)box_min;
    box_min[3] = 1.0f;
}
int mgCVisualMotionMDT::CreateBBox(float *box_max, float *box_min, float (*matrix)[4]) {
    float merged_max[4];
    float merged_min[4];
    float frame_max[4];
    float frame_min[4];
    float center[4];
    float corners[8][4];
    float transformed[8][4];
    float origins[8][4];
    float *bounds[4];
    float inverse_matrix[4][4];
    float inverse_root[4][4];
    float root_local[4][4];
    float root_matrix[4][4];
    float slot_matrix[4][4];
    float slot_inverse[4][4];
    float frame_matrix[4][4];
    int slot_count;
    int i;
    int slot;
    int corner;

    slot_count = 0;
    do {
        if (bone[slot_count] < 0) {
            break;
        }
        slot_count += 1;
    } while (slot_count < 0x20);
    if (slot_count == 0) {
        return 0;
    }
    sceVu0AddVector(center, base_box.max, base_box.min);
    sceVu0ScaleVector(center, center, 0.5f);
    bounds[0] = base_box.max;
    bounds[1] = base_box.min;
    for (corner = 0; corner < 8; corner++) {
        corners[corner][3] = 1.0f;
        corners[corner][0] = bounds[(corner & 1) != 0][0];
        corners[corner][1] = bounds[(corner & 2) != 0][1];
        corners[corner][2] = bounds[(corner & 4) != 0][2];
        mgZeroVector(origins[corner]);
    }
    mgInversMatrix(inverse_matrix, matrix);
    frame[0]->GetLWMatrix(root_matrix);
    mgMulMatrix(inverse_root, root_matrix, base_matrix[frame_id]);
    mgInversMatrix(root_local, inverse_root);
    i = 0;
    if (0 < slot_count) {
        do {
            slot = bone[i];
            if (frame[slot] != NULL) {
                frame[slot]->GetLWMatrix(frame_matrix);
                mgMulMatrix(slot_matrix, root_matrix, base_matrix[slot]);
                mgMulMatrix(slot_matrix, root_local, slot_matrix);
                mgInversMatrix(slot_inverse, slot_matrix);
                mgMulMatrix(frame_matrix, inverse_matrix, frame_matrix);
                mgMulMatrix(frame_matrix, frame_matrix, slot_inverse);
                mgApplyMatrixN(transformed, frame_matrix, corners, 8);
                if (i == 0) {
                    mgVectorMinMaxN(merged_max, merged_min, transformed, 8);
                } else {
                    mgVectorMinMaxN(frame_max, frame_min, transformed, 8);
                    mgVectorMaxMin(merged_max, merged_min, merged_max, merged_min, frame_max,
                                   frame_min);
                }
            }
            i += 1;
        } while (i < slot_count);
    }
    *(u_long128 *)box_max = *(u_long128 *)merged_max;
    *(u_long128 *)box_min = *(u_long128 *)merged_min;
    box_max[3] = 1.0f;
    box_min[3] = 1.0f;
    return 1;
}
extern "C" void *__vt__9mgCVisual[];
extern "C" void *__vt__12mgCVisualMDT[];
extern "C" void *__vt__15mgCVisualFixMDT[];
extern "C" void *__vt__18mgCVisualMotionMDT[];
extern "C" void *__nw__FUiP1(u_int, void *);
struct MotionCopyFields {
    u_char pad[0x1C];
    void **vptr;
    u_char model_data[0x30];
    mgCFrame **frame;
    int frame_id;
    float (*base_matrix)[4][4];
    u_char pad_5C[4];
    mgVu0FBOX base_box;
    int bone[32];
    int weight_num;
    mgVertexWeight *weight;
};
struct MotionMDTBase {
    u_char pad[0x1C];
};
struct MotionMDTVirtual : MotionMDTBase {
    virtual void v0();
    virtual void v1();
    virtual void v2();
    virtual void v3();
    virtual void v4();
    virtual void v5();
    virtual void v6();
    virtual void v7();
    virtual void v8();
    virtual void v9();
    virtual void Initialize();
};
struct MotionColor {
    float value[4];
};
struct MotionWeightSlots {
    int slot[4][8];
};
mgCVisual *mgCVisualMotionMDT::Copy(mgCMemory *memory) {
    MotionCopyFields *copy;
    if ((copy = (MotionCopyFields *)__nw__FUiP1(0x110, memory->Alloc(0x13))) != NULL) {
        copy->vptr = __vt__9mgCVisual;
        ((MotionMDTVirtual *)copy)->Initialize();
        copy->vptr = __vt__12mgCVisualMDT;
        ((MotionMDTVirtual *)copy)->Initialize();
        copy->vptr = __vt__15mgCVisualFixMDT;
        ((MotionMDTVirtual *)copy)->Initialize();
        copy->vptr = __vt__18mgCVisualMotionMDT;
        ((MotionMDTVirtual *)copy)->Initialize();
    }
    if (copy == NULL) {
        return NULL;
    }
    ((mgCVisualMDT *)copy)->operator=(*this);
    copy->frame = frame;
    copy->frame_id = frame_id;
    copy->base_matrix = base_matrix;
    copy->base_box = base_box;
    int i;
    *(MotionWeightSlots *)copy->bone = *(MotionWeightSlots *)bone;
    copy->weight_num = weight_num;
    copy->weight = weight;
    int count = material_num;
    i = 0;
    if (count > 0) {
        u_int bytes = count * 0x30;
        u_int quads = (bytes & 0xF) ? (bytes >> 4) + 1 : bytes >> 4;
        ((mgCVisualMDT *)copy)->material = new ((u_long128 *)memory->Alloc(quads + 2)) mgMaterial[material_num];
        i = 0;
    }
    mgMaterial *dst;
    mgMaterial *src;
    int offset = 0;
    while (i < material_num) {
        i++;
        src = (mgMaterial *)((u_char *)material + offset);
        dst = (mgMaterial *)((u_char *)((mgCVisualMDT *)copy)->material + offset);
        offset += 0x30;
        *(MotionColor *)dst->diffuse = *(MotionColor *)src->diffuse;
        *(MotionColor *)dst->unk_10 = *(MotionColor *)src->unk_10;
        dst->texture = src->texture;
    }
    return (mgCVisual *)copy;
}
int mgCVisualMotionMDT::Iam(void) {
    return 3;
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/visualmotion", set_data_func__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/visualmotion", prog_vif_532__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/visualmotion", progf_vif_533__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/visualmotion", at_571__3__DATA);

// Constants (.rodata)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/visualmotion", at_357__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/visualmotion", at_358__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/visualmotion", __vt__18mgCVisualMotionMDT__DATA);
