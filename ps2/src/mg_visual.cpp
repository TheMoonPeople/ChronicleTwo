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

#include <cstring>

extern u_char texflush_dma__2[0x30];
extern "C" void *__vt__9mgCVisual[];
extern "C" void *__vt__12mgCVisualMDT[];
extern "C" void *__vt__15mgCVisualFixMDT[];

struct VisualScratchMemory {
    u_char pad_00[0x1C];
    int lock;
    int stack;
    int stack_used;
    int stack_size;
    int stack_block;
};

struct FixMDTCopy {
    u_char pad_00[0x1C];
    void **vptr;
    u_char pad_20[0x20];
    int material_num;
    mgMaterial *material;
    u_char pad_48[8];
};

struct mgMaterialVector {
    float values[4];
};

// Code (.text)
u_int *GetScrPad(void) {
    return (u_int *)(buff_id ? 0x70002000 : 0x70000000);
}
void SendDMA(void *data, int size) {
    u_int mask = 0xFFFFFFF;
    data = (void *)((u_int)data & mask);
    if (start_dma != 0) {
        asm {
        wait:
            nop
            bc0f wait
            nop
        }
        start_dma = 0;
    }
    *(int *)0x1000E010 = 0x100;
    DmaCH8->sadr = (u_int)GetScrPad() & mask;
    DmaCH8->madr = (int)data;
    DmaCH8->qwc = size;
    DmaCH8->chcr.STR = 1;
    start_dma = 1;
    buff_id = (u_char)((buff_id != 0) ^ 1);
}
#pragma global_optimizer off
int mgSetPkTEX0(u_int *packet, unsigned long tex0, unsigned long tex1) {
    *(u_long128 *)packet = *(u_long128 *)&set_tex0_dma;
    *(u_long128 *)(packet + 4) = *(u_long128 *)&set_tex0_giftag;
    *(unsigned long *)(packet + 8) = tex1;
    *(unsigned long *)(packet + 10) = 0x14;
    *(unsigned long *)(packet + 12) = tex0;
    *(unsigned long *)(packet + 14) = 6;
    return 4;
}
#pragma global_optimizer reset
#pragma global_optimizer off
int mgSetPkTEX0(u_int *packet, unsigned long tex0, unsigned long tex1, unsigned long texa) {
    *(u_long128 *)packet = *(u_long128 *)&set_texa_dma;
    *(u_long128 *)(packet + 4) = *(u_long128 *)&set_texa_giftag;
    *(unsigned long *)(packet + 8) = tex1;
    *(unsigned long *)(packet + 10) = 0x14;
    *(unsigned long *)(packet + 12) = tex0;
    *(unsigned long *)(packet + 14) = 6;
    *(unsigned long *)(packet + 16) = texa;
    *(unsigned long *)(packet + 18) = 0x3B;
    return 5;
}
#pragma global_optimizer reset
int mgSetPkTexFlush_TagCnt(u_int *buffer) {
    if (buffer == NULL) {
        return 3;
    }
    u_long128 *dst = (u_long128 *)buffer;
    dst[0] = *(u_long128 *)&texflush_dma__2[0];
    dst[1] = *(u_long128 *)&texflush_dma__2[0x10];
    dst[2] = *(u_long128 *)&texflush_dma__2[0x20];
    return 3;
}
int SetPointLight(u_int *packet, float (*first)[4], float (*second)[4]) {
    packet[0] = 0x10000008;
    packet[1] = 0;
    packet[2] = 0;
    packet[3] = 0x6C08002D;
    u_long128 *dst = (u_long128 *)(packet + 4);
    dst[0] = *(u_long128 *)first[0];
    dst[1] = *(u_long128 *)first[1];
    dst[2] = *(u_long128 *)first[2];
    dst[3] = *(u_long128 *)first[3];
    dst[4] = *(u_long128 *)second[0];
    dst[5] = *(u_long128 *)second[1];
    dst[6] = *(u_long128 *)second[2];
    dst[7] = *(u_long128 *)second[3];
    return 9;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_visual", SetMaterialRef__12mgCVisualMDTFP1P10mgMateriali);
int mgCVisualMDT::SetPModeRef(u_long128 *packet, int flags) {
    int prim_mode = prmode;
    if (flags & 0x10) {
        prim_mode &= ~0x10;
    }
    if (flags & 8) {
        prim_mode &= ~8;
    }
    packet[0] = *(u_long128 *)&mat_vif_d;
    giftag.word0 = 0x8001;
    packet[1] = *(u_long128 *)&giftag;
    ((long long *)packet)[4] = prim_mode;
    ((long long *)packet)[5] = 0x1B;
    return 3;
}
void mgCVisualAttr::Initialize(void) {
    memset(this, 0, 0x18);
    alpha_ref = -1;
    z_write = 1;
    dest_alpha_test = -1;
}
mgCVisualAttr::mgCVisualAttr() {
    Initialize();
}
mgCTextureManager *mgCVisual::GetTextureManager(void) {
    mgCTextureManager *manager = texture_manager;
    if (manager != NULL) {
        return manager;
    }
    return &mgTexManager;
}
int mgCVisual::SetDrawEnvGifTag(u_long128 *env_packet, mgRENDER_INFO *info, mgCDrawEnv *base) {
    mgCDrawEnv *env = (mgCDrawEnv *)env_packet;
    *env = *base;
    if (info->attr->alpha_ref >= 0) {
        env->test.bits.aref = info->attr->alpha_ref;
    }
    if (info->attr->z_test != 0) {
        env->test.bits.zte = 1;
        if (info->attr->z_test == -1) {
            env->test.bits.ztst = 1;
        }
        if (info->attr->z_test == 1) {
            env->test.bits.ztst = 2;
        }
        if (info->attr->z_test == 2) {
            env->test.bits.ztst = 3;
        }
    }
    if (info->attr->alpha_test > 0) {
        env->test.bits.ate = 1;
        env->test.bits.atst = info->attr->alpha_test;
    } else if (info->attr->alpha_test == -1) {
        env->test.bits.ate = 0;
    }
    if (info->attr->dest_alpha_test != 0) {
        if (info->attr->dest_alpha_test == -1) {
            env->test.bits.date = 0;
        } else if (info->attr->dest_alpha_test == 1) {
            env->test.bits.date = 1;
            env->test.bits.datm = 0;
        } else if (info->attr->dest_alpha_test == 2) {
            u_char on = 1;
            env->test.bits.date = on;
            env->test.bits.datm = on;
        }
    }
    if (info->attr->alpha_blend != 0) {
        env->SetAlpha(info->attr->alpha_blend);
    }
    env->SetZBuf(info->attr->z_write);
    return 4;
}
void mgCVisualMDT::Initialize(void) {
    vertex_num = 0;
    vertex = NULL;
    normal_num = 0;
    normal = NULL;
    colour_num = 0;
    colour = NULL;
    uv_num = 0;
    uv = NULL;
    material_num = 0;
    material = NULL;
    face_group = NULL;
    unk_00 = 0;
    draw_env = NULL;
    texture_manager = NULL;
    vu1_offset = 0;
    vu1_base = 0;
    vu1_base = 60;
    vu1_offset = 180;
}
void CopyMaterial(mgMaterial *dst, MDT_MATERIAL_ *src, mgCTextureManager *textures) {
    *(mgMaterialVector *)dst->diffuse = *(mgMaterialVector *)src->diffuse;
    *(mgMaterialVector *)dst->unk_10 = *(mgMaterialVector *)src->unk_10;
    dst->texture = textures->GetTexture(src->texture, -1);
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_visual", CopyMDTData__12mgCVisualMDTFP10MDT_HEADERP9mgCMemory);
void mgCVisualMDT::CopyMDTDataPointer(MDT_HEADER *header, mgCMemory *memory) {
    mgCTextureManager *textures = ((mgCVisual *)this)->GetTextureManager();
    int vertex_address = (int)header + header->vertex_ofs;
    int normal_address = (int)header + header->normal_ofs;
    int colour_address = (int)header + header->colour_ofs;
    int uv_address = (int)header + header->uv_ofs;
    MDT_MATERIAL_ *file_materials = (MDT_MATERIAL_ *)((u_char *)header + header->material_ofs);
    vertex_num = header->vertex_num;
    normal_num = header->normal_num;
    colour_num = header->colour_num;
    uv_num = header->uv_num;
    material_num = header->material_num;
    vertex = (float (*)[4])vertex_address;
    normal = (sceVu0FVECTOR *)normal_address;
    colour = (sceVu0FVECTOR *)colour_address;
    uv = (sceVu0FVECTOR *)uv_address;
    material = (mgMaterial *)memory->Alloc(material_num * 0x30 / 16);
    if (material != NULL) {
        for (int i = 0; i < material_num; i++) {
            CopyMaterial(&material[i], &file_materials[i], textures);
        }
    }
}
mgMaterial *mgCVisualMDT::GetMaterial(int index) {
    if (material == NULL) {
        return NULL;
    }
    if (index < 0 || index >= material_num) {
        return NULL;
    }
    return material + index;
}
sceVu0FVECTOR *mgCVisualMDT::GetColor(int *out) {
    *out = colour_num;
    return colour;
}
int mgCVisualMDT::CreateBBox(float *min, float *max, float (*matrix)[4]) {
    if (vertex_num <= 0) {
        return 0;
    }
    if (vertex == NULL) {
        return 0;
    }
    mgVectorMinMaxN(min, max, vertex, vertex_num);
    return 1;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_visual", CreateFace__12mgCVisualMDTFP8FACES_IDP9mgCMemoryP9mgCMemoryPP7mgCFace);
int mgCVisualMDT::DataAssignMDT(MDT_HEADER *header, mgCMemory *memory,
                                mgCTextureManager *textures) {
    mgCVisualMDT *self = this;
    if (header == NULL) {
        return 0;
    }
    if (textures == NULL) {
        textures = &mgTexManager;
    }
    self->texture_manager = textures;
    CopyMDTData(header, memory);
    face_group = 0;
    u_char *table = (u_char *)header + header->faces_ofs;
    FACES_ID *cursor = (FACES_ID *)(table + 0x10);
    int count = *(int *)(table + 8);
    for (int i = 0; i < count; i++) {
        cursor = self->CreateFace(cursor, memory, memory, 0);
    }
    return 1;
}
int mgCVisualFixMDT::DataAssignMDT(MDT_HEADER *header, mgCMemory *memory,
                                   mgCTextureManager *textures) {
    mgCVisualMDT *self = this;
    mgCFace *part;
    int scratch_buffer[0x12C00];
    VisualScratchMemory scratch;
    ((mgCMemory *)&scratch)->Init();
    ((mgCMemory *)&scratch)->stSetBuffer((u_long128 *)scratch_buffer, 0x4B00);
    if (textures == NULL) {
        textures = &mgTexManager;
    }
    self->texture_manager = textures;
    CopyMDTDataPointer(header, memory);
    face_group = 0;
    u_char *table = (u_char *)header + header->faces_ofs;
    int count = *(int *)(table + 8);
    FACES_ID *cursor = (FACES_ID *)(table + 0x10);
    for (int i = 0; i < count; i++) {
        scratch.stack_used = 0;
        scratch.lock = 0;
        cursor = self->CreateFace(cursor, memory, (mgCMemory *)&scratch, &part);
        int address = ((VisualScratchMemory *)memory)->stack + ((VisualScratchMemory *)memory)->stack_used * 16;
        int size = self->CreateFacePacket((u_int *)address, part);
        ((int *)part)[8] = size | 0x30000000;
        ((int *)part)[9] = address;
        ((int *)part)[10] = 0;
        ((int *)part)[11] = 0;
        memory->Alloc(size);
    }
    return 1;
}
int mgCVisualMDT::Draw(u_int *tag, float (*matrix)[4], mgCDrawManager *draw_manager) {
    mgCVisualMDT *self = this;
    mgCVisualMDT *model = this;
    if (draw_manager == NULL) {
        draw_manager = &mgDrawManager;
    }
    mgRENDER_INFO *info = draw_manager->render_info;
    self->texture_manager = (mgCTextureManager *)draw_manager->texture_manager;
    prev_tex = 0;
    mgCMemory *memory = (mgCMemory *)draw_manager->data_memory;
    void *buffer = (void *)(memory->stack + memory->stack_used);
    memory->stack_used += self->CreateRenderInfoPacket((u_int *)buffer, matrix, info);
    self->CreatePacket(draw_manager);
    if (tag != NULL) {
        tag[0] = 0x50000000;
        tag[1] = (int)buffer;
        tag[2] = 0;
        tag[3] = 0;
        u_int *cursor = tag + 4;
        for (mgFACE_GROUP *node = model->face_group; node != NULL; node = node->next) {
            cursor += mgSendVuProg(cursor, node->vu_program);
            cursor[0] = 0x50000000;
            cursor[1] = (u_int)node->packet;
            cursor[2] = 0;
            cursor[3] = 0;
            cursor += 4;
        }
        return (int)(cursor - tag) / 4;
    }
    for (mgFACE_GROUP *node = model->face_group; node != NULL; node = node->next) {
        mgCTexture *texture = (model->material + node->material)->texture;
        if (texture != NULL) {
            draw_manager->AddPacket(texture->block, (u_long128 *)buffer, node->packet,
                                    node->vu_program);
        } else {
            draw_manager->AddPacket(-1, (u_long128 *)buffer, node->packet, node->vu_program);
        }
    }
    return 0;
}
u_int mgCVisualMDT::CreatePacket(mgCDrawManager *manager) {
    mgCVisualMDT *model = this;
    ((mgCVisual *)this)->GetTextureManager();
    mgCMemory *packet_memory;
    mgCMemory *data_memory;
    mgFACE_GROUP *node;
    mgRENDER_INFO *info;
    int data_start;
    info = manager->render_info;
    packet_memory = (mgCMemory *)manager->packet_memory;
    data_memory = (mgCMemory *)manager->data_memory;
    node = model->face_group;
    u_int start = (u_int)(packet_memory->stack + packet_memory->stack_used);
    int data_cursor;
    data_start = (u_int)(data_memory->stack + data_memory->stack_used);
    data_cursor = data_start;
    u_char *cursor = (u_char *)start;
    prev_tex = 0;
    while (node != NULL) {
        node->packet = (u_long128 *)cursor;
        int size = SetMaterialRef((u_long128 *)(data_cursor | 0x20000000),
                                  model->material + node->material,
                                  ((mgCFrameAttr *)info->attr)->program_mode);
        u_int *tag = (u_int *)cursor;
        cursor += 16;
        tag[0] = size | 0x30000000;
        tag[1] = data_cursor;
        int type = -1;
        tag[2] = 0;
        tag[3] = 0;
        data_cursor += size * 16;
        for (mgCFace *sub = node->face; sub != NULL;) {
            if (type != sub->type) {
                SetPModeRef((u_long128 *)(data_cursor | 0x20000000), sub->type);
                u_int *mode_tag = (u_int *)cursor;
                cursor += 16;
                mode_tag[0] = 0x30000003;
                mode_tag[1] = data_cursor;
                mode_tag[2] = 0;
                data_cursor += 0x30;
                mode_tag[3] = 0;
                type = sub->type;
            }
            u_int *sub_tag = (u_int *)cursor;
            cursor += 16;
            sub_tag[0] = 0x30000000;
            sub_tag[1] = data_cursor;
            sub_tag[2] = 0;
            sub_tag[3] = 0;
            size = CreateFacePacket((u_int *)(data_cursor | 0x20000000), sub);
            data_cursor += size * 16;
            sub = sub->next;
            sub_tag[0] |= size;
        }
        cursor += mgSetPkTexFlush_TagCnt((u_int *)cursor) * 16;
        u_int *end_tag = (u_int *)cursor;
        cursor = (u_char *)(end_tag + 4);
        end_tag[0] = 0x60000000;
        end_tag[1] = 0;
        end_tag[2] = 0;
        end_tag[3] = 0;
        node->packet_size = ((int)cursor - (int)node->packet) / 16;
        node = node->next;
    }
    packet_memory->stack_used += ((int)cursor - (int)start) / 16;
    data_memory->stack_used += (data_cursor - data_start) / 16;
    return start & 0xFFFFFFF;
}
u_int mgCVisualFixMDT::CreatePacket(mgCDrawManager *manager) {
    ((mgCVisual *)this)->GetTextureManager();
    mgCMemory *packet_memory;
    mgCMemory *data_memory;
    mgFACE_GROUP *node;
    mgRENDER_INFO *info;
    int data_start;
    data_memory = (mgCMemory *)manager->data_memory;
    packet_memory = (mgCMemory *)manager->packet_memory;
    node = face_group;
    info = manager->render_info;

    manager = (mgCDrawManager *)(packet_memory->stack + packet_memory->stack_used);
    data_start = (u_int)(data_memory->stack + data_memory->stack_used);
    int data_cursor = data_start;
    u_char *cursor = (u_char *)(u_int *)manager;
    cursor += mgSetPkTexFlush_TagCnt((u_int *)manager) * 16;
    prev_tex = 0;
    while (node != NULL) {
        node->packet = (u_long128 *)cursor;
        int size =
            SetMaterialRef((u_long128 *)(data_cursor | 0x20000000), material + node->material,
                           ((mgCFrameAttr *)info->attr)->program_mode);
        u_int *tag = (u_int *)cursor;
        cursor += 16;
        tag[0] = size | 0x30000000;
        tag[1] = data_cursor;
        int type = -1;
        tag[2] = 0;
        tag[3] = 0;
        data_cursor += size * 16;
        for (mgCFace *sub = node->face; sub != NULL; sub = sub->next) {
            if (type != sub->type) {
                SetPModeRef((u_long128 *)(data_cursor | 0x20000000), sub->type);
                u_int *mode_tag = (u_int *)cursor;
                cursor += 16;
                mode_tag[0] = 0x30000003;
                mode_tag[1] = data_cursor;
                mode_tag[2] = 0;
                data_cursor += 0x30;
                mode_tag[3] = 0;
                type = sub->type;
            }
            *(u_long128 *)cursor = sub->packet_tag;
            cursor += 16;
        }
        cursor += mgSetPkTexFlush_TagCnt((u_int *)cursor) * 16;
        u_int *end_tag = (u_int *)cursor;
        cursor = (u_char *)(end_tag + 4);
        end_tag[0] = 0x60000000;
        end_tag[1] = 0;
        end_tag[2] = 0;
        end_tag[3] = 0;
        node->packet_size = ((int)cursor - (int)node->packet) / 16;
        node = node->next;
    }
    packet_memory->stack_used += ((int)cursor - (int)(u_int *)manager) / 16;
    data_memory->stack_used += (data_cursor - data_start) / 16;
    return (u_int)manager;
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_visual", SetData0__FiiPPiP1P1P1P1P1);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_visual", SetData1__FiiPPiP1P1P1P1P1);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_visual", SetData2__FiiPPiP1P1P1P1P1);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_visual", SetData3__FiiPPiP1P1P1P1P1);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_visual", SetData4__FiiPPiP1P1P1P1P1);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_visual", SetData5__FiiPPiP1P1P1P1P1);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_visual", SetData6__FiiPPiP1P1P1P1P1);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_visual", SetData7__FiiPPiP1P1P1P1P1);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_visual", CreateFacePacket__12mgCVisualMDTFPUiP7mgCFace);
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_visual", CreateRenderInfoPacket__12mgCVisualMDTFPUiPA4_fP13mgRENDER_INFO);
int mgCVisualMDT::CreateExtRenderInfoPacket(u_int *packet, float (*matrix)[4],
                                            mgRENDER_INFO *info) {
    return 0;
}
mgCVisual *mgCVisualFixMDT::Copy(mgCMemory *memory) {
    FixMDTCopy *copy;

    if ((copy = (FixMDTCopy *)operator new(0x50, (u_long128 *)memory->Alloc(7))) != NULL) {
        copy->vptr = __vt__9mgCVisual;
        ((mgCVisual *)copy)->Initialize();
        copy->vptr = __vt__12mgCVisualMDT;
        ((mgCVisual *)copy)->Initialize();
        copy->vptr = __vt__15mgCVisualFixMDT;
        ((mgCVisual *)copy)->Initialize();
    }
    if (copy == NULL) {
        return NULL;
    }
    ((mgCVisualMDT *)copy)->operator=(*this);
    int count = material_num;
    int i = 0;
    if (count > 0) {
        u_int bytes = count * 0x30;
        u_int quads = (bytes & 0xF) ? (bytes >> 4) + 1 : bytes >> 4;
        copy->material = (mgMaterial *)operator new[](material_num * 0x30,
                                                      (u_long128 *)memory->Alloc(quads + 2));
        i = 0;
    }
    mgMaterial *dst;
    mgMaterial *src;
    int offset = 0;
    while (i < material_num) {
        i++;
        src = (mgMaterial *)((u_char *)material + offset);
        dst = (mgMaterial *)((u_char *)copy->material + offset);
        offset += 0x30;
        *(mgMaterialVector *)dst->diffuse = *(mgMaterialVector *)src->diffuse;
        *(mgMaterialVector *)dst->unk_10 = *(mgMaterialVector *)src->unk_10;
        dst->texture = src->texture;
    }
    return (mgCVisualFixMDT *)copy;
}
mgCVisualMDT &mgCVisualMDT::operator=(const mgCVisualMDT &source) {
    unk_00 = source.unk_00;
    draw_env = source.draw_env;
    texture_manager = source.texture_manager;
    prmode = source.prmode;
    vu1_base = source.vu1_base;
    vu1_offset = source.vu1_offset;
    unk_18 = source.unk_18;
    vertex_num = source.vertex_num;
    normal_num = source.normal_num;
    colour_num = source.colour_num;
    uv_num = source.uv_num;
    vertex = source.vertex;
    normal = source.normal;
    colour = source.colour;
    uv = source.uv;
    material_num = source.material_num;
    material = source.material;
    face_group = source.face_group;
    return *this;
}
void SetDrawEnv(mgCDrawEnv *env, mgCVisualAttr *attr, mgCDrawEnv *base) {
    *env = *base;
    if (attr->alpha_ref >= 0) {
        env->test.bits.aref = attr->alpha_ref;
    }
    env->test.bits.zte = 1;
    if (attr->z_test != 0) {
        if (attr->z_test == -1) {
            env->test.bits.ztst = 1;
        }
        if (attr->z_test == 1) {
            env->test.bits.ztst = 2;
        }
        if (attr->z_test == 2) {
            env->test.bits.ztst = 3;
        }
    }
    if (attr->alpha_test != 0) {
        if (attr->alpha_test == -1) {
            env->test.bits.ate = 0;
        } else {
            env->test.bits.ate = 1;
        }
        env->test.bits.atst = attr->alpha_test;
    }
    if (attr->dest_alpha_test != 0) {
        if (attr->dest_alpha_test == -1) {
            env->test.bits.date = 0;
        } else if (attr->dest_alpha_test == 1) {
            env->test.bits.date = 1;
            env->test.bits.datm = 0;
        } else if (attr->dest_alpha_test == 2) {
            u_char on = 1;
            env->test.bits.date = on;
            env->test.bits.datm = on;
        }
    }
    if (attr->z_write > 0) {
        env->zbuf.bits.zmsk = 0;
    }
    if (attr->z_write < 0) {
        env->zbuf.bits.zmsk = 1;
    }
    if (attr->alpha_blend != 0) {
        env->SetAlpha(attr->alpha_blend);
    }
}
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_visual", CreateRenderInfoPacket__13mgCVisualPrimFPUiPA4_fP13mgRENDER_INFO);
void mgCVisualPrim::Initialize() {
    unk_00 = 0;
    draw_env = NULL;
    texture_manager = NULL;
    vu1_offset = 0;
    vu1_base = 0;
    attr.Initialize();
}
int mgCVisualFixMDT::Iam() {
    return 2;
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_visual", giftag__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_visual", set_tex0_dma__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_visual", set_tex0_giftag__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_visual", set_texa_dma__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_visual", set_texa_giftag__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_visual", texflush_dma__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_visual", mat_vif__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_visual", mat_vif_dif__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_visual", mat_vif_d__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_visual", mat_pw__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_visual", mat_vif_d_tex__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_visual", set_data_func__2__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_visual", prog_vif_730__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_visual", progf_vif_731__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_visual", at_769__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_visual", __vt__13mgCVisualPrim__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_visual", __vt__15mgCVisualFixMDT__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/mg_visual", __vt__12mgCVisualMDT__DATA);

// Small uninitialised data (.sbss)
INCLUDE_BSS(start_dma, 0x4);
INCLUDE_BSS(buff_id, 0x4);
INCLUDE_BSS(prev_tex, 0x4);
