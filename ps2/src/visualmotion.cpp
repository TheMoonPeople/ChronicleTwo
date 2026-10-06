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
#include <cstdio>

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
extern const char at_357[];
extern const char at_358[];

struct VertexWeightBlock {
    u_int frame_id;
    int bone_id;
    u_int unk_08[2];
    u_int count;
    u_int next;
    u_int unk_18[2];
};

struct VertexWeightEntry {
    u_int vertex_id;
    u_int unk_04[3];
    float weight;
    u_int unk_14[3];
};

void mgCVisualMotionMDT::CreateVertexWeight(u_int *data, int selected_frame, mgCMemory *memory) {
    VertexWeightBlock *block = (VertexWeightBlock *)data;
    u_int entry_index;
    weight_num = vertex_num;
    int vertex_count = weight_num;
    VertexWeightEntry *entry = (VertexWeightEntry *)block;
    u_int bytes = vertex_count * sizeof(mgVertexWeight);
    u_int blocks;
    if ((bytes & 15) != 0) {
        blocks = bytes / 16 + 1;
    } else {
        blocks = bytes / 16;
    }
    weight = new ((u_long128 *)memory->Alloc(blocks + 2)) mgVertexWeight[vertex_count];
    if (weight == NULL) {
        weight_num = 0;
        return;
    }
    for (int bone_index = 0; bone_index < 32; bone_index++) {
        bone[bone_index] = -1;
    }
    while (true) {
        entry++;
        if (block->frame_id != selected_frame || block->count == 0) {
            entry += block->count;
            if (block->next == 0) {
                break;
            }
            block = (VertexWeightBlock *)entry;
            continue;
        }
        {
            for (entry_index = 0; entry_index < block->count; entry++, entry_index++) {
                int bone_index;
                for (bone_index = 0; bone_index < 32; bone_index++) {
                    if (bone[bone_index] == -1) {
                        bone[bone_index] = block->bone_id;
                        break;
                    }
                    if (bone[bone_index] == block->bone_id) {
                        break;
                    }
                }
                if (bone_index == 32) {
                    printf(at_357);
                    weight = NULL;
                    weight_num = 0;
                    return;
                }
                mgVertexWeight *vertex_weight = &weight[entry->vertex_id];
                int influence;
                for (influence = 0; influence < 4; influence++) {
                    if (vertex_weight->weight[influence] == 0.0f) {
                        vertex_weight->matrix[influence] = bone_index * 4;
                        vertex_weight->weight[influence] = entry->weight / 100.0f;
                        break;
                    }
                }
                if (influence == 4) {
                    float total = 0.0f;
                    total += vertex_weight->weight[0];
                    total += vertex_weight->weight[1];
                    total += vertex_weight->weight[2];
                    total += vertex_weight->weight[3];
                    vertex_weight->weight[0] /= total;
                    vertex_weight->weight[1] /= total;
                    vertex_weight->weight[2] /= total;
                    vertex_weight->weight[3] /= total;
                    printf(at_358, frame[selected_frame]->name, entry->vertex_id);
                }
            }
        }
        if (block->next == 0) {
            break;
        }
        block = (VertexWeightBlock *)entry;
    }
    for (int vertex_index = 0; vertex_index < weight_num; vertex_index++) {
        mgVertexWeight *vertex_weight = &weight[vertex_index];
        float total = vertex_weight->weight[0] + vertex_weight->weight[1];
        total = vertex_weight->weight[2] + total;
        total = vertex_weight->weight[3] + total;
        if (total < 1.0f && !(total <= 0.0f)) {
            vertex_weight->weight[0] /= total;
            vertex_weight->weight[1] /= total;
            vertex_weight->weight[2] /= total;
            vertex_weight->weight[3] /= total;
        }
        if (total == 0.0f) {
            vertex_weight->weight[0] = 1.0f;
        }
    }
}
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
struct mgVertexBatchHeader {
    int stream_count[3];
    int type;
};
u_long128 *SetData0(int count, int type, int **index, u_long128 *packet, u_long128 *vertex, u_long128 *normal, u_long128 *uv, u_long128 *colour, mgVertexWeight *weight) {
    mgVertexBatchHeader *header = (mgVertexBatchHeader *)packet;
    u_long128 *vertex_out;
    u_long128 *normal_out;
    u_long128 *uv_out;
    u_long128 *weight_out;
    int *cursor;

    header->stream_count[0] = count;
    header->stream_count[1] = count;
    header->stream_count[2] = 0;
    header->type = type;
    cursor = *index;
    vertex_out = packet + 1;
    u_long128 *normal_base = packet + 1;
    normal_out = count + normal_base;
    uv_out = normal_out + count;
    weight_out = uv_out + count;
    while (count > 0) {
        count--;
        *vertex_out++ = vertex[cursor[0]];
        weight_out[0] = ((u_long128 *)&weight[cursor[0]])[0];
        weight_out[1] = ((u_long128 *)&weight[cursor[0]])[1];
        weight_out += 2;
        *normal_out++ = normal[cursor[1]];
        *uv_out++ = uv[cursor[2]];
        cursor += 3;
    }
    *index = cursor;
    return weight_out;
}
u_long128 *SetData1(int count, int type, int **index, u_long128 *packet, u_long128 *vertex, u_long128 *normal, u_long128 *uv, u_long128 *colour, mgVertexWeight *weight) {
    mgVertexBatchHeader *header = (mgVertexBatchHeader *)packet;
    u_long128 *vertex_out;
    u_long128 *normal_out;
    u_long128 *uv_out;
    u_long128 *colour_out;
    u_long128 *weight_out;
    int *cursor;

    header->stream_count[0] = count;
    header->stream_count[1] = count;
    header->stream_count[2] = count;
    header->type = type;
    cursor = *index;
    vertex_out = packet + 1;
    u_long128 *stream_base = packet + 1;
    normal_out = count + stream_base;
    uv_out = normal_out + count;
    colour_out = uv_out + count;
    weight_out = colour_out + count;
    while (count > 0) {
        count--;
        *vertex_out++ = vertex[cursor[0]];
        weight_out[0] = ((u_long128 *)&weight[cursor[0]])[0];
        weight_out[1] = ((u_long128 *)&weight[cursor[0]])[1];
        weight_out += 2;
        *normal_out++ = normal[cursor[1]];
        *uv_out++ = uv[cursor[2]];
        *colour_out++ = colour[cursor[3]];
        cursor += 4;
    }
    *index = cursor;
    return weight_out;
}
u_long128 *SetData2(int count, int type, int **index, u_long128 *packet, u_long128 *vertex, u_long128 *normal, u_long128 *uv, u_long128 *colour, mgVertexWeight *weight) {
    mgVertexBatchHeader *header = (mgVertexBatchHeader *)packet;
    u_long128 *vertex_out;
    u_long128 *normal_out;
    u_long128 *weight_out;
    int *cursor;

    header->stream_count[0] = count;
    header->stream_count[1] = 0;
    header->stream_count[2] = 0;
    header->type = type;
    cursor = *index;
    vertex_out = packet + 1;
    u_long128 *stream_base = packet + 1;
    normal_out = count + stream_base;
    weight_out = normal_out + count;
    while (count > 0) {
        count--;
        *vertex_out++ = vertex[cursor[0]];
        weight_out[0] = ((u_long128 *)&weight[cursor[0]])[0];
        weight_out[1] = ((u_long128 *)&weight[cursor[0]])[1];
        weight_out += 2;
        *normal_out++ = normal[cursor[1]];
        cursor += 2;
    }
    *index = cursor;
    return weight_out;
}
u_long128 *SetData3(int count, int type, int **index, u_long128 *packet, u_long128 *vertex, u_long128 *normal, u_long128 *uv, u_long128 *colour, mgVertexWeight *weight) {
    mgVertexBatchHeader *header = (mgVertexBatchHeader *)packet;
    u_long128 *vertex_out;
    u_long128 *normal_out;
    u_long128 *colour_out;
    u_long128 *weight_out;
    int *cursor;

    header->stream_count[0] = count;
    header->stream_count[1] = count;
    header->stream_count[2] = 0;
    header->type = type;
    cursor = *index;
    vertex_out = packet + 1;
    u_long128 *stream_base = packet + 1;
    normal_out = count + stream_base;
    colour_out = normal_out + count;
    weight_out = colour_out + count;
    while (count > 0) {
        count--;
        *vertex_out++ = vertex[cursor[0]];
        weight_out[0] = ((u_long128 *)&weight[cursor[0]])[0];
        weight_out[1] = ((u_long128 *)&weight[cursor[0]])[1];
        weight_out += 2;
        *normal_out++ = normal[cursor[1]];
        *colour_out++ = colour[cursor[2]];
        cursor += 3;
    }
    *index = cursor;
    return weight_out;
}
u_long128 *SetData4(int count, int type, int **index, u_long128 *packet, u_long128 *vertex, u_long128 *normal, u_long128 *uv, u_long128 *colour, mgVertexWeight *weight) {
    mgVertexBatchHeader *header = (mgVertexBatchHeader *)packet;
    u_long128 *vertex_out;
    u_long128 *uv_out;
    u_long128 *weight_out;
    int *cursor;

    header->stream_count[0] = count;
    header->stream_count[1] = 0;
    header->stream_count[2] = 0;
    header->type = type;
    cursor = *index;
    vertex_out = packet + 1;
    u_long128 *stream_base = packet + 1;
    uv_out = count + stream_base;
    weight_out = uv_out + count;
    while (count > 0) {
        count--;
        *vertex_out++ = vertex[cursor[0]];
        weight_out[0] = ((u_long128 *)&weight[cursor[0]])[0];
        weight_out[1] = ((u_long128 *)&weight[cursor[0]])[1];
        weight_out += 2;
        *uv_out++ = uv[cursor[1]];
        cursor += 2;
    }
    *index = cursor;
    return weight_out;
}
u_long128 *SetData5(int count, int type, int **index, u_long128 *packet, u_long128 *vertex, u_long128 *normal, u_long128 *uv, u_long128 *colour, mgVertexWeight *weight) {
    mgVertexBatchHeader *header = (mgVertexBatchHeader *)packet;
    u_long128 *vertex_out;
    u_long128 *uv_out;
    u_long128 *colour_out;
    u_long128 *weight_out;
    int *cursor;

    header->stream_count[0] = count;
    header->stream_count[1] = 0;
    header->stream_count[2] = count;
    header->type = type;
    cursor = *index;
    vertex_out = packet + 1;
    u_long128 *stream_base = packet + 1;
    uv_out = count + stream_base;
    colour_out = uv_out + count;
    weight_out = colour_out + count;
    while (count > 0) {
        count--;
        *vertex_out++ = vertex[cursor[0]];
        weight_out[0] = ((u_long128 *)&weight[cursor[0]])[0];
        weight_out[1] = ((u_long128 *)&weight[cursor[0]])[1];
        weight_out += 2;
        *uv_out++ = uv[cursor[1]];
        *colour_out++ = colour[cursor[2]];
        cursor += 3;
    }
    *index = cursor;
    return weight_out;
}
u_long128 *SetData6(int count, int type, int **index, u_long128 *packet, u_long128 *vertex, u_long128 *normal, u_long128 *uv, u_long128 *colour, mgVertexWeight *weight) {
    mgVertexBatchHeader *header = (mgVertexBatchHeader *)packet;
    u_long128 *vertex_out;
    u_long128 *weight_out;
    int *cursor;

    header->stream_count[0] = 0;
    header->stream_count[1] = 0;
    header->stream_count[2] = 0;
    header->type = type;
    cursor = *index;
    vertex_out = packet + 1;
    u_long128 *stream_base = packet + 1;
    weight_out = count + stream_base;
    while (count > 0) {
        count--;
        *vertex_out++ = vertex[cursor[0]];
        weight_out[0] = ((u_long128 *)&weight[cursor[0]])[0];
        weight_out[1] = ((u_long128 *)&weight[cursor[0]])[1];
        weight_out += 2;
        cursor += 1;
    }
    *index = cursor;
    return weight_out;
}
u_long128 *SetData7(int count, int type, int **index, u_long128 *packet, u_long128 *vertex, u_long128 *normal, u_long128 *uv, u_long128 *colour, mgVertexWeight *weight) {
    mgVertexBatchHeader *header = (mgVertexBatchHeader *)packet;
    u_long128 *vertex_out;
    u_long128 *colour_out;
    u_long128 *weight_out;
    int *cursor;

    header->stream_count[0] = count;
    header->stream_count[1] = 0;
    header->stream_count[2] = 0;
    header->type = type;
    cursor = *index;
    vertex_out = packet + 1;
    u_long128 *stream_base = packet + 1;
    colour_out = count + stream_base;
    weight_out = colour_out + count;
    while (count > 0) {
        count--;
        *vertex_out++ = vertex[cursor[0]];
        weight_out[0] = ((u_long128 *)&weight[cursor[0]])[0];
        weight_out[1] = ((u_long128 *)&weight[cursor[0]])[1];
        weight_out += 2;
        *colour_out++ = colour[cursor[1]];
        cursor += 2;
    }
    *index = cursor;
    return weight_out;
}
#ifdef NONMATCHING
static u_long128 *(*set_data_func[8])(int, int, int **, u_long128 *, u_long128 *, u_long128 *, u_long128 *, u_long128 *, mgVertexWeight *) = {
    SetData0, SetData1, SetData2, SetData3, SetData4, SetData5, SetData6, SetData7
};
int mgCVisualMotionMDT::CreateFaceMotionPacket(u_int *packet, mgCFace *face, mgCVMotionData *motion) {
    static u_int prog_vif[4] __attribute__((aligned(16))) = {0, 0, 0, MG_VIF_MSCAL | 0x2};
    static u_int progf_vif[4] __attribute__((aligned(16))) = {0, 0, 0, MG_VIF_MSCNT};
    sceGifTag  batch_tag;
    sceGifTag  end_tag;
    int       *indices;
    u_int     *destination;
    u_int     *write;
    u_int     *buffer_start;
    u_int     *unpack;
    u_int     *batch;
    u_long128 *end;
    int        remaining;
    int        batch_limit;
    int        count;
    int        variant;
    int        primitive;
    int        use_scratchpad;
    int        started;
    int        words;

    if (face == NULL) {
        return 0;
    }
    use_scratchpad = 0;
    if (((u_int)packet & 0xF0000000) == MG_UNCACHED) {
        use_scratchpad = 1;
    }
    variant = 0;
    started = 0;
    remaining = face->vertex_num;
    primitive = face->type & MG_FACE_PRIM_MASK;
    indices = face->index;
    batch_limit = (vu1_offset - 2) / 5 / 3 * 3;
    if (face->type & MG_FACE_COLOUR) {
        variant = 1;
        batch_limit = (vu1_offset - 2) / 6 / 3 * 3;
    }
    if (face->type & MG_FACE_NO_TEXTURE) {
        variant += 2;
    }
    if (face->type & MG_FACE_NO_NORMAL) {
        variant += 4;
    }
    *(u_long128 *)&batch_tag = 0;
    batch_tag.EOP = 1;
    batch_tag.PRE = 1;
    end_tag = batch_tag;
    if (primitive == MG_PRIM_TRIANGLE_STRIP) {
        batch_tag.PRIM = 0x5C;
    } else {
        batch_tag.PRIM = 0x5B;
    }
    batch_tag.NREG = 3;
    batch_tag.REGS0 = 2;
    batch_tag.REGS1 = 1;
    batch_tag.REGS2 = 4;
    end_tag.PRIM = 0x5D;
    end_tag.NREG = 3;
    end_tag.REGS0 = 2;
    end_tag.REGS1 = 1;
    end_tag.REGS2 = 4;
    packet[0] = 0;
    packet[1] = 0;
    packet[2] = 0;
    packet[3] = MG_VIF_UNPACK_V4_32 | (1 << MG_VIF_NUM_SHIFT) | 0x0027;
    *(u_long128 *)&packet[4] = *(u_long128 *)&end_tag;
    destination = packet + 8;
    write = use_scratchpad ? GetScrPad() : destination;
    buffer_start = write;
    while (remaining > 0) {
        count = batch_limit;
        if (remaining < batch_limit) {
            count = remaining;
        }
        write[0] = 0;
        write[1] = 0;
        write[2] = 0;
        write[3] = 0;
        unpack = write + 3;
        batch = write + 4;
        batch_tag.NLOOP = count | 0x8000;
        *(u_long128 *)batch = *(u_long128 *)&batch_tag;
        end = set_data_func[variant](count, face->type, &indices, (u_long128 *)(batch + 4),
                                     (u_long128 *)vertex, (u_long128 *)normal, (u_long128 *)uv,
                                     (u_long128 *)colour, weight);
        *unpack = (((u_int)((u_int *)end - batch) / 4) << MG_VIF_NUM_SHIFT) | MG_VIF_UNPACK_V4_32 | MG_VIF_UNPACK_FLG;
        if (started == 0) {
            started = 1;
            *end = *(u_long128 *)prog_vif;
        } else {
            *end = *(u_long128 *)progf_vif;
        }
        write = (u_int *)(end + 1);
        if (primitive == MG_PRIM_TRIANGLE_STRIP && batch_limit < remaining) {
            remaining += 2;
            indices -= face->index_stride * 2;
        }
        words = write - buffer_start;
        if (words > 0x514) {
            if (use_scratchpad != 0) {
                SendDMA(destination, words / 4);
            }
            destination += words;
            write = use_scratchpad ? GetScrPad() : destination;
            buffer_start = write;
        }
        remaining -= batch_limit;
    }
    words = write - buffer_start;
    if (use_scratchpad != 0 && words > 0) {
        SendDMA(destination, words / 4);
    }
    destination += words;
    u_int finish[4] __attribute__((aligned(16))) = {MG_VIF_FLUSHA, 0, 0, 0};
    *(u_long128 *)destination = *(u_long128 *)finish;
    destination += 4;
    return (destination - packet) / 4;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/visualmotion", CreateFaceMotionPacket__18mgCVisualMotionMDTFPUiP7mgCFaceP14mgCVMotionData);
#endif
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
