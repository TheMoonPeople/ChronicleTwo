#include "common.h"

#include <cstring>

#include "mg_dataset.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mg_visual.hpp"
#include "mglib.hpp"

/**
 *
 * Copies a material's four float channels together.
 *
 */
struct mgMaterialVector {
    float values[4]; /**< Material channel values. */
};

/**
 *
 * Initial transform and lighting upload of an MDT visual's setup packet.
 *
 */
struct mgVISUAL_SETUP_PACKET {
    u_int         dma[4]; /**< DMA count tag for the initial upload. */
    u_int         vif[4]; /**< Buffer layout and upload commands. */
    u_long128     unk_20;
    sceVu0FMATRIX model_screen; /**< Transform from model space to GS screen space. */
    sceVu0FMATRIX model_world;  /**< Transform from model space to world space. */
    sceVu0FVECTOR light_dir[3]; /**< Three directional-light vectors sent to VU1. */
    sceVu0FMATRIX light_color;  /**< Directional-light colours. */
    sceVu0FVECTOR ambient;      /**< Ambient light with the object's alpha factor. */
    sceVu0FVECTOR object_color; /**< Object colour with the object's alpha factor. */
};

STATIC_ASSERT(sizeof(mgVISUAL_SETUP_PACKET) == 0x140);

/**
 *
 * Mutable A+D tag shared by visual packet writers.
 *
 */
mgVisualGifTag giftag __attribute__((aligned(16))) = {
    MG_GIFTAG_EOP, {1u << MG_GIFTAG_NREG_SHIFT, SCE_GIF_PACKED_AD, 0}
};

/**
 *
 * DMA chain flushing the GS texture cache.
 *
 */
static u_char texflush_dma[0x30] __attribute__((aligned(16))) = {
    0x02, 0x00, 0x00, MG_DMA_CNT >> 24, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x02, 0x00, 0x00, MG_VIF_DIRECT >> 24,
    0x01, MG_GIFTAG_EOP >> 8, 0x00, 0x00, 0x00, 0x00, 0x00, 1 << (MG_GIFTAG_NREG_SHIFT - 24),
    SCE_GIF_PACKED_AD, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
    SCE_GS_TEXFLUSH, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};

/**
 *
 * Vertex upload writers selected by each face attribute combination.
 *
 */
static u_long128 *(*set_data_func[8])(int, int, int **, u_long128 *, u_long128 *, u_long128 *, u_long128 *, u_long128 *) = {
    SetData0, SetData1, SetData2, SetData3, SetData4, SetData5, SetData6, SetData7};

/**
 *
 * Whether the scratchpad DMA transfer is active.
 *
 */
int start_dma;

/**
 *
 * Scratchpad half selected for the next packet.
 *
 */
int buff_id;

/**
 *
 * Texture whose registers were most recently written.
 *
 */
mgCTexture *prev_tex;

/**
 *
 * Final control quadword of a material upload.
 *
 */
u_long128 mat_pw = 3;

// Code (.text)
u_int *GetScrPad() {
    return (u_int *) (buff_id ? 0x70002000 : 0x70000000);
}

void SendDMA(void *packet, int size) {
    int address_mask = 0x0FFFFFFF;

    asm {
        and packet, packet, address_mask
    }

    if (start_dma) {
        asm {
            .set noreorder
        wait_dma:
            nop
            nop
            nop
            nop
            nop
            nop
            bc0f wait_dma
            nop
            nop
        }

        start_dma = 0;
    }

    *(u_int *) 0x1000E010 = 0x100;
    DmaCH8->sadr = (u_long) GetScrPad() & 0x0FFFFFFF;
    DmaCH8->madr = (u_int) packet;
    DmaCH8->qwc = size;
    DmaCH8->chcr.STR = 1;
    start_dma = 1;
    buff_id = !buff_id;
}

#pragma global_optimizer off

int mgSetPkTEX0(u_int *packet, unsigned long tex0, unsigned long tex1) {
    *(u_long128 *) packet = *(u_long128 *) &set_tex0_dma;
    *(u_long128 *) (packet + 4) = *(u_long128 *) &set_tex0_giftag;
    *(unsigned long *) (packet + 8) = tex1;
    *(unsigned long *) (packet + 10) = 0x14;
    *(unsigned long *) (packet + 12) = tex0;
    *(unsigned long *) (packet + 14) = 6;
    return 4;
}

#pragma global_optimizer reset
#pragma global_optimizer off

int mgSetPkTEX0(u_int *packet, unsigned long tex0, unsigned long tex1, unsigned long texa) {
    *(u_long128 *) packet = *(u_long128 *) &set_texa_dma;
    *(u_long128 *) (packet + 4) = *(u_long128 *) &set_texa_giftag;
    *(unsigned long *) (packet + 8) = tex1;
    *(unsigned long *) (packet + 10) = 0x14;
    *(unsigned long *) (packet + 12) = tex0;
    *(unsigned long *) (packet + 14) = 6;
    *(unsigned long *) (packet + 16) = texa;
    *(unsigned long *) (packet + 18) = 0x3B;
    return 5;
}

#pragma global_optimizer reset

int mgSetPkTexFlush_TagCnt(u_int *buffer) {
    if (buffer == NULL) {
        return 3;
    }

    u_long128 *dst = (u_long128 *) buffer;
    dst[0] = *(u_long128 *) &texflush_dma[0];
    dst[1] = *(u_long128 *) &texflush_dma[0x10];
    dst[2] = *(u_long128 *) &texflush_dma[0x20];
    return 3;
}

int SetPointLight(u_int *packet, float (*first)[4], float (*second)[4]) {
    packet[0] = 0x10000008;
    packet[1] = 0;
    packet[2] = 0;
    packet[3] = 0x6C08002D;
    u_long128 *dst = (u_long128 *) (packet + 4);
    dst[0] = *(u_long128 *) first[0];
    dst[1] = *(u_long128 *) first[1];
    dst[2] = *(u_long128 *) first[2];
    dst[3] = *(u_long128 *) first[3];
    dst[4] = *(u_long128 *) second[0];
    dst[5] = *(u_long128 *) second[1];
    dst[6] = *(u_long128 *) second[2];
    dst[7] = *(u_long128 *) second[3];
    return 9;
}

int mgCVisualMDT::SetMaterialRef(u_long128 *packet, mgMaterial *material, int flags) {
    mgCTexture *texture;
    texture = material->texture;

    if (texture == NULL) {
        packet[0] = *(u_long128 *) &mat_vif;
        packet[1] = *(u_long128 *) material->diffuse;
        packet[2] = *(u_long128 *) material->unk_10;
        packet[3] = 0;
        packet[4] = *(u_long128 *) &mat_pw;
        prev_tex = NULL;
        return 5;
    }

    if (flags & 0x1) {
        packet[0] = *(u_long128 *) &mat_vif;
        packet[1] = *(u_long128 *) material->diffuse;
        packet[2] = *(u_long128 *) material->unk_10;
        packet[3] = 0;
        packet[4] = 3;
        packet[5] = *(u_long128 *) &mat_vif_d_tex;
        packet[6] = 0x000000000000086E3000000000008001;
        *(u_long *) &packet[7] = *(u_long *) &texture->tex1;
        ((u_long *) &packet[7])[1] = SCE_GS_TEX1_1;
        *(u_long *) &packet[8] = texture->tex0.value;
        *(u_long *) &packet[9] = *(u_long *) &texture->clamp;
        prev_tex = texture;
        return 10;
    } else {
        packet[0] = *(u_long128 *) &mat_vif_dif;
        packet[1] = *(u_long128 *) material->diffuse;
        packet[2] = *(u_long128 *) &mat_vif_d_tex;
        packet[3] = 0x000000000000086E3000000000008001;
        *(u_long *) &packet[4] = *(u_long *) &texture->tex1;
        ((u_long *) &packet[4])[1] = SCE_GS_TEX1_1;
        *(u_long *) &packet[5] = texture->tex0.value;
        *(u_long *) &packet[6] = *(u_long *) &texture->clamp;
        prev_tex = texture;
        return 7;
    }
}

int mgCVisualMDT::SetPModeRef(u_long128 *packet, int flags) {
    int prim_mode = prmode;

    if (flags & 0x10) {
        prim_mode &= ~0x10;
    }

    if (flags & 8) {
        prim_mode &= ~8;
    }

    packet[0] = *(u_long128 *) &mat_vif_d;
    giftag.word0 = 0x8001;
    packet[1] = *(u_long128 *) &giftag;
    ((long long *) packet)[4] = prim_mode;
    ((long long *) packet)[5] = 0x1B;
    return 3;
}

void mgCVisualAttr::Initialize() {
    memset(this, 0, sizeof(*this));
    alpha_ref = -1;
    z_write = 1;
    dest_alpha_test = -1;
}

mgCVisualAttr::mgCVisualAttr() {
    Initialize();
}

mgCTextureManager *mgCVisual::GetTextureManager() {
    mgCTextureManager *manager = texture_manager;

    if (manager != NULL) {
        return manager;
    }

    return &mgTexManager;
}

int mgCVisual::SetDrawEnvGifTag(u_long128 *env_packet, mgRENDER_INFO *info, mgCDrawEnv *base) {
    mgCDrawEnv *env = (mgCDrawEnv *) env_packet;
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

void mgCVisualMDT::Initialize() {
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
    *(mgMaterialVector *) dst->diffuse = *(mgMaterialVector *) src->diffuse;
    *(mgMaterialVector *) dst->unk_10 = *(mgMaterialVector *) src->unk_10;
    dst->texture = textures->GetTexture(src->texture, -1);
}

void mgCVisualMDT::CopyMDTData(MDT_HEADER *header, mgCMemory *memory) {
    int                index;
    mgCTextureManager *textures;
    sceVu0FVECTOR     *source_vertex;
    sceVu0FVECTOR     *source_normal;
    sceVu0FVECTOR     *source_colour;
    sceVu0FVECTOR     *source_uv;
    MDT_MATERIAL_     *source_material;

    textures = GetTextureManager();
    source_vertex = (sceVu0FVECTOR *) ((u_char *) header + header->vertex_ofs);
    source_normal = (sceVu0FVECTOR *) ((u_char *) header + header->normal_ofs);
    source_colour = (sceVu0FVECTOR *) ((u_char *) header + header->colour_ofs);
    source_uv = (sceVu0FVECTOR *) ((u_char *) header + header->uv_ofs);
    source_material = (MDT_MATERIAL_ *) ((u_char *) header + header->material_ofs);
    vertex_num = header->vertex_num;
    normal_num = header->normal_num;
    colour_num = header->colour_num;
    uv_num = header->uv_num;
    material_num = header->material_num;
    vertex = (sceVu0FVECTOR *) memory->Alloc(vertex_num);
    normal = (sceVu0FVECTOR *) memory->Alloc(normal_num);
    uv = (sceVu0FVECTOR *) memory->Alloc(uv_num);
    colour = (sceVu0FVECTOR *) memory->Alloc(colour_num);
    material = (mgMaterial *) memory->Alloc(material_num * (int) sizeof(mgMaterial) / 16);

    if (vertex != NULL) {
        for (index = 0; index < vertex_num; index++) {
            sceVu0CopyVector(vertex[index], source_vertex[index]);
        }
    }

    if (normal != NULL) {
        for (index = 0; index < normal_num; index++) {
            sceVu0CopyVector(normal[index], source_normal[index]);
        }
    }

    if (colour != NULL) {
        for (index = 0; index < colour_num; index++) {
            sceVu0CopyVector(colour[index], source_colour[index]);
        }
    }

    if (uv != NULL) {
        for (index = 0; index < uv_num; index++) {
            sceVu0CopyVector(uv[index], source_uv[index]);
        }
    }

    if (material != NULL) {
        for (index = 0; index < material_num; index++) {
            CopyMaterial(&material[index], &source_material[index], textures);
        }
    }
}

void mgCVisualMDT::CopyMDTDataPointer(MDT_HEADER *header, mgCMemory *memory) {
    mgCTextureManager *textures = GetTextureManager();
    int                vertex_address = (int) header + header->vertex_ofs;
    int                normal_address = (int) header + header->normal_ofs;
    int                colour_address = (int) header + header->colour_ofs;
    int                uv_address = (int) header + header->uv_ofs;
    MDT_MATERIAL_     *file_materials = (MDT_MATERIAL_ *) ((u_char *) header + header->material_ofs);
    vertex_num = header->vertex_num;
    normal_num = header->normal_num;
    colour_num = header->colour_num;
    uv_num = header->uv_num;
    material_num = header->material_num;
    vertex = (sceVu0FVECTOR *) vertex_address;
    normal = (sceVu0FVECTOR *) normal_address;
    colour = (sceVu0FVECTOR *) colour_address;
    uv = (sceVu0FVECTOR *) uv_address;
    material = (mgMaterial *) memory->Alloc(material_num * 0x30 / 16);

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

FACES_ID *mgCVisualMDT::CreateFace(FACES_ID *faces, mgCMemory *memory, mgCMemory *index_memory, mgCFace **out_face) {
    mgCFace      *face;
    mgCFace      *last_face;
    mgFACE_GROUP *group;
    mgFACE_GROUP *previous;
    int          *write;
    int           i;

    GetTextureManager();
    face = (mgCFace *) memory->Alloc(3);
    face->vertex_num = faces->face_num;
    face->type = faces->type;
    face->index_stride = 3;

    if (face->type & MG_FACE_COLOUR) {
        face->index_stride++;
    }

    if (face->type & MG_FACE_NO_NORMAL) {
        face->index_stride--;
    }

    if (face->type & MG_FACE_NO_TEXTURE) {
        face->index_stride--;
    }

    face->index_num = face->vertex_num * face->index_stride;
    face->material = faces->material;
    faces = (FACES_ID *) faces->index;
    write = (int *) index_memory->Alloc(face->index_num / 4 + 1);
    face->index = write;

    for (i = 0; i < face->index_num; i++) {
        *write++ = *(int *) faces;
        faces = (FACES_ID *) ((int *) faces + 1);
    }

    face->next = NULL;
    previous = face_group;

    if (previous == NULL) {
        if ((group = new (memory->Alloc(4)) mgFACE_GROUP) != NULL) {
            memset(group, 0, sizeof(mgFACE_GROUP));
        }

        group->next = NULL;
        group->face = NULL;
        group->material = face->material;
        face_group = group;
    } else {
        while (previous->next != NULL) {
            if (previous->material == face->material && previous->vu_program == 0) {
                break;
            }

            previous = previous->next;
        }

        if (previous->next == NULL) {
            if ((group = new (memory->Alloc(4)) mgFACE_GROUP) != NULL) {
                memset(group, 0, sizeof(mgFACE_GROUP));
            }

            previous->next = group;
            group->next = NULL;
            group->face = NULL;
            group->material = face->material;
            group->vu_program = 0;
        } else {
            group = previous;
        }
    }

    last_face = group->face;

    if (last_face == NULL) {
        group->face = face;
    } else {
        for (; last_face->next != NULL; last_face = last_face->next) {
        }

        last_face->next = face;
    }

    switch ((int) out_face) {
        case 0:
            break;
        default:
            *out_face = face;
            break;
    }

    return faces;
}

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
    MDT_FACES *faces = (MDT_FACES *) ((u_char *) header + header->faces_ofs);
    FACES_ID  *cursor = (FACES_ID *) (faces + 1);
    int        count = faces->prim_num;

    for (int i = 0; i < count; i++) {
        cursor = self->CreateFace(cursor, memory, memory, 0);
    }

    return 1;
}

int mgCVisualFixMDT::DataAssignMDT(MDT_HEADER *header, mgCMemory *memory,
                                   mgCTextureManager *textures) {
    mgCVisualMDT *self = this;
    mgCFace      *part;
    int           scratch_buffer[0x12C00];
    mgCMemory     scratch;
    scratch.stSetBuffer((u_long128 *) scratch_buffer, 0x4B00);

    if (textures == NULL) {
        textures = &mgTexManager;
    }

    self->texture_manager = textures;
    CopyMDTDataPointer(header, memory);
    face_group = 0;
    MDT_FACES *faces = (MDT_FACES *) ((u_char *) header + header->faces_ofs);
    int        count = faces->prim_num;
    FACES_ID  *cursor = (FACES_ID *) (faces + 1);

    for (int i = 0; i < count; i++) {
        scratch.stack_used = 0;
        scratch.lock = 0;
        cursor = self->CreateFace(cursor, memory, &scratch, &part);
        int address = (int) &memory->stack[memory->stack_used];
        int size = self->CreateFacePacket((u_int *) address, part);
        part->packet_tag_word[0] = size | MG_DMA_REF;
        part->packet_tag_word[1] = address;
        part->packet_tag_word[2] = 0;
        part->packet_tag_word[3] = 0;
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
    self->texture_manager = draw_manager->texture_manager;
    prev_tex = 0;
    mgCMemory *memory = draw_manager->data_memory;
    void      *buffer = memory->stack + memory->stack_used;
    memory->stack_used += self->CreateRenderInfoPacket((u_int *) buffer, matrix, info);
    self->CreatePacket(draw_manager);

    if (tag != NULL) {
        tag[0] = 0x50000000;
        tag[1] = (int) buffer;
        tag[2] = 0;
        tag[3] = 0;
        u_int *cursor = tag + 4;

        for (mgFACE_GROUP *node = model->face_group; node != NULL; node = node->next) {
            cursor += mgSendVuProg(cursor, node->vu_program);
            cursor[0] = 0x50000000;
            cursor[1] = (u_int) node->packet;
            cursor[2] = 0;
            cursor[3] = 0;
            cursor += 4;
        }

        return (int) (cursor - tag) / 4;
    }

    for (mgFACE_GROUP *node = model->face_group; node != NULL; node = node->next) {
        mgCTexture *texture = (model->material + node->material)->texture;

        if (texture != NULL) {
            draw_manager->AddPacket(texture->block, (u_long128 *) buffer, node->packet,
                                    node->vu_program);
        } else {
            draw_manager->AddPacket(-1, (u_long128 *) buffer, node->packet, node->vu_program);
        }
    }

    return 0;
}

u_int mgCVisualMDT::CreatePacket(mgCDrawManager *manager) {
    mgCVisualMDT *model = this;
    GetTextureManager();
    mgCMemory     *packet_memory;
    mgCMemory     *data_memory;
    mgFACE_GROUP  *node;
    mgRENDER_INFO *info;
    int            data_start;
    info = manager->render_info;
    packet_memory = manager->packet_memory;
    data_memory = manager->data_memory;
    node = model->face_group;
    u_int start = (u_int) (packet_memory->stack + packet_memory->stack_used);
    int   data_cursor;
    data_start = (u_int) (data_memory->stack + data_memory->stack_used);
    data_cursor = data_start;
    u_char *cursor = (u_char *) start;
    prev_tex = 0;

    while (node != NULL) {
        node->packet = (u_long128 *) cursor;
        int    size = SetMaterialRef((u_long128 *) (data_cursor | 0x20000000),
                                     model->material + node->material,
                                     info->attr->program_mode);
        u_int *tag = (u_int *) cursor;
        cursor += 16;
        tag[0] = size | 0x30000000;
        tag[1] = data_cursor;
        int type = -1;
        tag[2] = 0;
        tag[3] = 0;
        data_cursor += size * 16;

        for (mgCFace *sub = node->face; sub != NULL;) {
            if (type != sub->type) {
                SetPModeRef((u_long128 *) (data_cursor | 0x20000000), sub->type);
                u_int *mode_tag = (u_int *) cursor;
                cursor += 16;
                mode_tag[0] = 0x30000003;
                mode_tag[1] = data_cursor;
                mode_tag[2] = 0;
                data_cursor += 0x30;
                mode_tag[3] = 0;
                type = sub->type;
            }

            u_int *sub_tag = (u_int *) cursor;
            cursor += 16;
            sub_tag[0] = 0x30000000;
            sub_tag[1] = data_cursor;
            sub_tag[2] = 0;
            sub_tag[3] = 0;
            size = CreateFacePacket((u_int *) (data_cursor | 0x20000000), sub);
            data_cursor += size * 16;
            sub = sub->next;
            sub_tag[0] |= size;
        }

        cursor += mgSetPkTexFlush_TagCnt((u_int *) cursor) * 16;
        u_int *end_tag = (u_int *) cursor;
        cursor += 16;
        end_tag[0] = 0x60000000;
        end_tag[1] = 0;
        end_tag[2] = 0;
        end_tag[3] = 0;
        node->packet_size = ((int) cursor - (int) node->packet) / 16;
        node = node->next;
    }

    packet_memory->stack_used += ((int) cursor - (int) start) / 16;
    data_memory->stack_used += (data_cursor - data_start) / 16;
    return start & 0xFFFFFFF;
}

u_int mgCVisualFixMDT::CreatePacket(mgCDrawManager *manager) {
    GetTextureManager();
    mgCMemory     *packet_memory;
    mgCMemory     *data_memory;
    mgFACE_GROUP  *node;
    mgRENDER_INFO *info;
    int            data_start;
    data_memory = manager->data_memory;
    packet_memory = manager->packet_memory;
    node = face_group;
    info = manager->render_info;

    manager = (mgCDrawManager *) (packet_memory->stack + packet_memory->stack_used);
    data_start = (u_int) (data_memory->stack + data_memory->stack_used);
    int     data_cursor = data_start;
    u_char *cursor = (u_char *) (u_int *) manager;
    cursor += mgSetPkTexFlush_TagCnt((u_int *) manager) * 16;
    prev_tex = 0;

    while (node != NULL) {
        node->packet = (u_long128 *) cursor;
        int size =
            SetMaterialRef((u_long128 *) (data_cursor | 0x20000000), material + node->material,
                           info->attr->program_mode);
        u_int *tag = (u_int *) cursor;
        cursor += 16;
        tag[0] = size | 0x30000000;
        tag[1] = data_cursor;
        int type = -1;
        tag[2] = 0;
        tag[3] = 0;
        data_cursor += size * 16;

        for (mgCFace *sub = node->face; sub != NULL; sub = sub->next) {
            if (type != sub->type) {
                SetPModeRef((u_long128 *) (data_cursor | 0x20000000), sub->type);
                u_int *mode_tag = (u_int *) cursor;
                cursor += 16;
                mode_tag[0] = 0x30000003;
                mode_tag[1] = data_cursor;
                mode_tag[2] = 0;
                data_cursor += 0x30;
                mode_tag[3] = 0;
                type = sub->type;
            }

            *(u_long128 *) cursor = sub->packet_tag;
            cursor += 16;
        }

        cursor += mgSetPkTexFlush_TagCnt((u_int *) cursor) * 16;
        u_int *end_tag = (u_int *) cursor;
        cursor += 16;
        end_tag[0] = 0x60000000;
        end_tag[1] = 0;
        end_tag[2] = 0;
        end_tag[3] = 0;
        node->packet_size = ((int) cursor - (int) node->packet) / 16;
        node = node->next;
    }

    packet_memory->stack_used += ((int) cursor - (int) (u_int *) manager) / 16;
    data_memory->stack_used += (data_cursor - data_start) / 16;
    return (u_int) manager;
}

u_long128 *SetData0(int count, int type, int **index, u_long128 *packet, u_long128 *vertex, u_long128 *normal, u_long128 *uv, u_long128 *colour) {
    u_long128 *vertex_out;
    u_long128 *normal_out;
    u_long128 *uv_out;

    ((int *) packet)[0] = count;
    int *cursor;
    ((int *) packet)[1] = count;
    ((int *) packet)[2] = count;
    ((int *) packet)[3] = type;
    vertex_out = packet + 1;
    u_long128 *normal_base = packet + 1;
    normal_out = count + normal_base;
    cursor = *index;
    uv_out = normal_out + count;

    while (count > 0) {
        count--;
        *vertex_out++ = vertex[cursor[0]];
        *normal_out++ = normal[cursor[1]];
        *uv_out++ = uv[cursor[2]];
        cursor += 3;
    }

    *index = cursor;
    return uv_out;
}

/**
 *
 * Writes the indexed vertex, normal, uv, colour streams for one vertex batch.
 *
 */
u_long128 *SetData1(int count, int type, int **index, u_long128 *packet, u_long128 *vertex, u_long128 *normal, u_long128 *uv, u_long128 *colour) {
    u_long128 *vertex_out;
    u_long128 *normal_out;
    u_long128 *uv_out;
    u_long128 *colour_out;

    ((int *) packet)[0] = count;
    int *cursor;
    ((int *) packet)[1] = count;
    ((int *) packet)[2] = count;
    ((int *) packet)[3] = type;
    vertex_out = packet + 1;
    u_long128 *stream_base = packet + 1;
    normal_out = count + stream_base;
    cursor = *index;
    uv_out = normal_out + count;
    colour_out = uv_out + count;

    while (count > 0) {
        count--;
        *vertex_out++ = vertex[cursor[0]];
        *normal_out++ = normal[cursor[1]];
        *uv_out++ = uv[cursor[2]];
        *colour_out++ = colour[cursor[3]];
        cursor += 4;
    }

    *index = cursor;
    return colour_out;
}

/**
 *
 * Writes the indexed vertex, normal streams for one vertex batch.
 *
 */
u_long128 *SetData2(int count, int type, int **index, u_long128 *packet, u_long128 *vertex, u_long128 *normal, u_long128 *uv, u_long128 *colour) {
    u_long128 *vertex_out;
    u_long128 *normal_out;

    ((int *) packet)[0] = count;
    int *cursor;
    ((int *) packet)[1] = count;
    ((int *) packet)[2] = count;
    ((int *) packet)[3] = type;
    vertex_out = packet + 1;
    u_long128 *stream_base = packet + 1;
    normal_out = count + stream_base;
    cursor = *index;

    while (count > 0) {
        count--;
        *vertex_out++ = vertex[cursor[0]];
        *normal_out++ = normal[cursor[1]];
        cursor += 2;
    }

    *index = cursor;
    return normal_out;
}

/**
 *
 * Writes the indexed vertex, normal, colour streams for one vertex batch.
 *
 */
u_long128 *SetData3(int count, int type, int **index, u_long128 *packet, u_long128 *vertex, u_long128 *normal, u_long128 *uv, u_long128 *colour) {
    u_long128 *vertex_out;
    u_long128 *normal_out;
    u_long128 *colour_out;

    ((int *) packet)[0] = count;
    int *cursor;
    ((int *) packet)[1] = count;
    ((int *) packet)[2] = 0;
    ((int *) packet)[3] = type;
    vertex_out = packet + 1;
    u_long128 *stream_base = packet + 1;
    normal_out = count + stream_base;
    cursor = *index;
    colour_out = normal_out + count;

    while (count > 0) {
        count--;
        *vertex_out++ = vertex[cursor[0]];
        *normal_out++ = normal[cursor[1]];
        *colour_out++ = colour[cursor[2]];
        cursor += 3;
    }

    *index = cursor;
    return colour_out;
}

/**
 *
 * Writes the indexed vertex, uv streams for one vertex batch.
 *
 */
u_long128 *SetData4(int count, int type, int **index, u_long128 *packet, u_long128 *vertex, u_long128 *normal, u_long128 *uv, u_long128 *colour) {
    u_long128 *vertex_out;
    u_long128 *uv_out;

    ((int *) packet)[0] = count;
    int *cursor;
    ((int *) packet)[1] = 0;
    ((int *) packet)[2] = count;
    ((int *) packet)[3] = type;
    vertex_out = packet + 1;
    u_long128 *stream_base = packet + 1;
    uv_out = count + stream_base;
    cursor = *index;

    while (count > 0) {
        count--;
        *vertex_out++ = vertex[cursor[0]];
        *uv_out++ = uv[cursor[1]];
        cursor += 2;
    }

    *index = cursor;
    return uv_out;
}

/**
 *
 * Writes the indexed vertex, uv, colour streams for one vertex batch.
 *
 */
u_long128 *SetData5(int count, int type, int **index, u_long128 *packet, u_long128 *vertex, u_long128 *normal, u_long128 *uv, u_long128 *colour) {
    u_long128 *vertex_out;
    u_long128 *uv_out;
    u_long128 *colour_out;

    ((int *) packet)[0] = count;
    int *cursor;
    ((int *) packet)[1] = 0;
    ((int *) packet)[2] = count;
    ((int *) packet)[3] = type;
    vertex_out = packet + 1;
    u_long128 *stream_base = packet + 1;
    uv_out = count + stream_base;
    cursor = *index;
    colour_out = uv_out + count;

    while (count > 0) {
        count--;
        *vertex_out++ = vertex[cursor[0]];
        *uv_out++ = uv[cursor[1]];
        *colour_out++ = colour[cursor[2]];
        cursor += 3;
    }

    *index = cursor;
    return colour_out;
}

/**
 *
 * Writes the indexed vertex streams for one vertex batch.
 *
 */
#pragma global_optimizer off

u_long128 *SetData6(int count, int type, int **index, u_long128 *packet, u_long128 *vertex, u_long128 *normal, u_long128 *uv, u_long128 *colour) {
    int       *cursor;
    u_long128 *vertex_out;
    u_long128  unused;
    u_long128  element;
    ((int *) packet)[0] = count;
    ((int *) packet)[1] = 0;
    ((int *) packet)[2] = 0;
    ((int *) packet)[3] = type;
    vertex_out = packet + 1;
    cursor = *index;

    if (count > 0) {
        do {
            count--;
            element = vertex[cursor[0]];
            *vertex_out = element;
            *(u_long128 *) &unused = element;
            cursor += 1;
            vertex_out++;
        } while (count > 0);
    }

    *index = cursor;
    return vertex_out;
}

#pragma global_optimizer reset

/**
 *
 * Writes the indexed vertex, colour streams for one vertex batch.
 *
 */
u_long128 *SetData7(int count, int type, int **index, u_long128 *packet, u_long128 *vertex, u_long128 *normal, u_long128 *uv, u_long128 *colour) {
    u_long128 *vertex_out;
    u_long128 *colour_out;

    ((int *) packet)[0] = count;
    int *cursor;
    ((int *) packet)[1] = 0;
    ((int *) packet)[2] = 0;
    ((int *) packet)[3] = type;
    vertex_out = packet + 1;
    u_long128 *stream_base = packet + 1;
    colour_out = count + stream_base;
    cursor = *index;

    while (count > 0) {
        count--;
        *vertex_out++ = vertex[cursor[0]];
        *colour_out++ = colour[cursor[1]];
        cursor += 2;
    }

    *index = cursor;
    return colour_out;
}

int mgCVisualMDT::CreateFacePacket(u_int *packet, mgCFace *face) {
    // VIF quadwords starting the vertex transform program at entry two and continuing it.
    static u_int prog_vif[4] __attribute__((aligned(16))) = {0, 0, 0, MG_VIF_MSCAL | 2};
    static u_int progf_vif[4] __attribute__((aligned(16))) = {0, 0, 0, MG_VIF_MSCNT};

    u_int     *start;
    sceGifTag  batch_tag;
    u_long128 *end;
    int        use_scratchpad;
    u_int     *write;
    int        primitive;
    int        count;
    int        batch_limit;
    sceGifTag  end_tag;
    int        started;
    u_int     *buffer_start;
    u_int     *unpack;
    u_int     *payload;
    int       *indices;
    int        remaining;
    int        words;
    int        variant;

    if (face == NULL) {
        return 0;
    }

    use_scratchpad = 0;

    if (((u_int) packet & 0xF0000000) == MG_UNCACHED) {
        use_scratchpad = 1;
    }

    start = packet;
    primitive = face->type & MG_FACE_PRIM_MASK;
    started = 0;
    remaining = face->vertex_num;
    batch_limit = (vu1_offset - 2) / 3 / 3 * 3;
    indices = face->index;
    variant = 0;

    if (face->type & MG_FACE_COLOUR) {
        variant += 1;
        batch_limit = (vu1_offset - 2) / 4 / 3 * 3;
    }

    if (face->type & MG_FACE_NO_TEXTURE) {
        variant += 2;
    }

    if (face->type & MG_FACE_NO_NORMAL) {
        variant += 4;
    }

    *(u_long128 *) &batch_tag = 0;
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
    *(u_long128 *) &packet[4] = *(u_long128 *) &end_tag;
    packet += 8;
    write = use_scratchpad ? GetScrPad() : packet;
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
        write += 4;
        payload = write;
        batch_tag.NLOOP = count | 0x8000;
        *(u_long128 *) write = *(u_long128 *) &batch_tag;
        write += 4;
        end = set_data_func[variant](count, face->type, &indices, (u_long128 *) write,
                                     (u_long128 *) vertex, (u_long128 *) normal, (u_long128 *) uv, (u_long128 *) colour);
        *unpack = ((u_int) ((u_int *) end - payload) / 4 << MG_VIF_NUM_SHIFT) | MG_VIF_UNPACK_V4_32 | MG_VIF_UNPACK_FLG;

        if (started == 0) {
            *end = *(u_long128 *) prog_vif;
            started = 1;
            write = (u_int *) (end + 1);
        } else {
            *end = *(u_long128 *) progf_vif;
            write = (u_int *) (end + 1);
        }

        if (primitive == MG_PRIM_TRIANGLE_STRIP && batch_limit < remaining) {
            remaining += 2;
            indices -= face->index_stride * 2;
        }

        words = write - buffer_start;

        if (words > 0x514) {
            if (use_scratchpad != 0) {
                SendDMA(packet, words / 4);
            }

            packet += words;
            write = use_scratchpad ? GetScrPad() : packet;
            buffer_start = write;
        }

        remaining -= batch_limit;
    }

    words = write - buffer_start;

    if (use_scratchpad != 0 && words > 0) {
        SendDMA(packet, words / 4);
    }

    packet += words;
    u_int finish[4] __attribute__((aligned(16))) = {MG_VIF_FLUSHA, 0, 0, 0};
    *(u_long128 *) packet = *(u_long128 *) finish;
    packet += 4;
    return (packet - start) / 4;
}

int mgCVisualMDT::CreateRenderInfoPacket(u_int *packet, float (*matrix)[4], mgRENDER_INFO *info) {
    mgVISUAL_SETUP_PACKET *setup;
    mgLIGHT_INFO          *lighting;
    mgCDrawEnv            *environment;
    u_int                 *start;
    int                    i;
    int                    flags;
    int                    fog_colour;
    int                    size;
    u_int                 *write;
    sceVu0FMATRIX          world_screen;
    sceVu0FMATRIX          projection;
    sceVu0FVECTOR          boosted_ambient;
    sceVu0FVECTOR          eye;
    sceVu0FMATRIX          inverse;
    sceVu0FMATRIX          model_clip;
    sceVu0FMATRIX          point_position;
    sceVu0FMATRIX          point_colour;

    if (info->attr == NULL) {
        packet[0] = MG_DMA_RET;
        packet[1] = 0;
        packet[2] = 0;
        packet[3] = 0;
        return 1;
    }

    write = GetScrPad();
    start = write;
    setup = (mgVISUAL_SETUP_PACKET *) write;
    lighting = info->GetpLightInfo();
    *(u_long128 *) setup->model_world[0] = *(u_long128 *) matrix[0];
    *(u_long128 *) setup->model_world[1] = *(u_long128 *) matrix[1];
    *(u_long128 *) setup->model_world[2] = *(u_long128 *) matrix[2];
    *(u_long128 *) setup->model_world[3] = *(u_long128 *) matrix[3];

    if (info->attr->depth_bias > 1.0f) {
        sceVu0CopyMatrix(projection, info->screen);
        projection[3][2] *= 1.005f;
        mgMulMatrix(world_screen, projection, info->world_view);
        mgMulMatrix(setup->model_screen, world_screen, setup->model_world);
    } else {
        mgMulMatrix(setup->model_screen, info->world_screen, setup->model_world);
    }

    setup->dma[0] = MG_DMA_CNT;
    setup->dma[1] = 0;
    setup->dma[2] = 0;
    setup->dma[3] = 0;
    setup->vif[0] = 0;
    setup->vif[1] = vu1_base | MG_VIF_BASE;
    setup->vif[2] = vu1_offset | MG_VIF_OFFSET;
    *(u_long128 *) setup->light_dir[0] = *(u_long128 *) lighting->light_dir[0];
    *(u_long128 *) setup->light_dir[1] = *(u_long128 *) lighting->light_dir[1];
    *(u_long128 *) setup->light_dir[2] = *(u_long128 *) lighting->light_dir[2];
    sceVu0CopyMatrix(setup->light_color, lighting->light_color);
    *(u_long128 *) setup->ambient = *(u_long128 *) lighting->ambient;
    setup->ambient[3] *= info->attr->obj_alpha;

    if (info->attr->ambient_boost != 0) {
        sceVu0ScaleVector(boosted_ambient, lighting->light_color[0], 0.3f);
        mgAddVector(boosted_ambient, lighting->ambient);
        *(u_long128 *) setup->object_color = *(u_long128 *) boosted_ambient;
        setup->object_color[3] = info->object_color[3];
    } else {
        *(u_long128 *) setup->object_color = *(u_long128 *) info->object_color;
    }

    setup->object_color[3] *= info->attr->obj_alpha;
    write = (u_int *) (setup + 1);
    setup->vif[3] = (((u_int) (write - setup->vif) / 4 - 1) << MG_VIF_NUM_SHIFT) | MG_VIF_UNPACK_V4_32 | 0x0003;

    if (info->attr->program_mode != 0) {
        write[0] = 0;
        write[1] = 0;
        write[2] = 0;
        write[3] = MG_VIF_UNPACK_V4_32 | (1 << MG_VIF_NUM_SHIFT) | 0x0018;
        eye[0] = info->camera_pos[0];
        eye[1] = info->camera_pos[1];
        eye[2] = info->camera_pos[2];
        eye[3] = 1.0f;
        sceVu0CopyMatrix(inverse, matrix);
        sceVu0InversMatrix(inverse, inverse);
        sceVu0ApplyMatrix(eye, inverse, eye);
        *(u_long128 *) &write[4] = *(u_long128 *) eye;
        write += 8;
    }

    if (info->scissor != 0) {
        write[0] = 0;
        write[1] = 0;
        write[2] = 0;
        write[3] = MG_VIF_UNPACK_V4_32 | (8 << MG_VIF_NUM_SHIFT) | 0x0019;
        mgMulMatrix(model_clip, info->world_clip, matrix);
        sceVu0CopyMatrix((float(*)[4]) & write[4], model_clip);
        *(u_long128 *) &write[20] = *(u_long128 *) info->clip_screen[0];
        *(u_long128 *) &write[24] = *(u_long128 *) info->clip_screen[1];
        *(u_long128 *) &write[28] = *(u_long128 *) info->clip_screen[2];
        *(u_long128 *) &write[32] = *(u_long128 *) info->clip_screen[3];

        if (info->attr->depth_bias > 1.0f) {
            ((float *) &write[32])[2] *= 1.0000685f;
        }

        write += 36;
    }

    setup->dma[0] |= (write - setup->vif) / 4;

    if (info->plight_hit != 0 && info->lighting_enabled != 0) {
        for (i = 0; i < 4; i++) {
            sceVu0SubVector(point_position[i], lighting->point_light[i].pos, matrix[3]);
            point_position[i][3] = lighting->point_light[i].power;
            sceVu0CopyVector(point_colour[i], lighting->point_light[i].color);
        }

        write += SetPointLight(write, point_position, point_colour) * 4;
    }

    if (info->attr->program_mode & 0x2) {
        write[0] = MG_DMA_CNT | 4;
        write[1] = 0;
        write[2] = 0;
        write[3] = MG_VIF_UNPACK_V4_32 | (4 << MG_VIF_NUM_SHIFT) | 0x0019;
        mgMulMatrix((float(*)[4]) & write[4], info->view, matrix);
        write += 20;
    }

    flags = 0;

    if ((info->clip | info->scissor) != 0) {
        flags |= 0x1;
    }

    if (info->scissor != 0) {
        flags |= 0x2;
    }

    if (info->attr->program_mode != 0) {
        if (info->attr->program_mode & 0x1) {
            flags |= 0x8;
        }

        if (info->attr->program_mode & 0x2) {
            flags |= 0x100;
        }
    }

    if (info->attr->program_option != 0) {
        flags |= 0x4;
    }

    if (info->plight_hit != 0) {
        flags |= 0x10;
    }

    if (info->motion != 0) {
        flags |= 0x40;
    }

    if (info->attr->no_light != 0 || info->lighting_enabled == 0 || info->attr->ambient_boost != 0) {
        flags |= 0x20;
    }

    if (info->attr->unk_84 == 1) {
        flags |= 0x80;
    }

    write[0] = MG_DMA_CNT | 10;
    write[1] = 0;
    write[2] = 0;
    write[3] = MG_VIF_UNPACK_V4_32 | (1 << MG_VIF_NUM_SHIFT) | 0x0026;
    write[4] = flags;
    write[5] = 0;
    write[6] = 0;
    write[7] = 0;
    write[8] = 0;
    write[9] = 0;
    write[10] = MG_VIF_MSCAL;
    write[11] = MG_VIF_DIRECT | 8;
    write[12] = 0x8003;
    write[13] = 0x10000000;
    write[14] = 0xE;
    write[15] = 0;
    write[16] = 0;
    write[17] = 0;
    write[18] = MG_GS_PRMODECONT;
    write[19] = 0;
    prmode = (((info->attr->fog != 0 && info->fog_enable != 0) != 0) << 5) | 0x58;
    write[20] = prmode;
    write[21] = 0;
    write[22] = SCE_GS_PRMODE;
    write[23] = 0;
    fog_colour = info->fog.r;
    fog_colour |= info->fog.g << 8;
    fog_colour |= info->fog.b << 16;

    if (info->attr->fog > 1) {
        if (info->attr->fog == 2) {
            fog_colour = 0;
        }

        if (info->attr->fog == 3) {
            fog_colour = 0xFFFFFF;
        }
    }

    write[24] = fog_colour;
    write[25] = 0;
    write[26] = 0x3D;
    write[27] = 0;
    write += 28;

    if (draw_env != NULL) {
        environment = draw_env;
    } else {
        environment = &info->draw_env[0];
    }

    write += SetDrawEnvGifTag((u_long128 *) write, info, environment) * 4;
    write += CreateExtRenderInfoPacket(write, matrix, info) * 4;
    write[0] = MG_DMA_RET;
    write[1] = 0;
    write[2] = 0;
    write[3] = 0;
    write += 4;
    size = (write - start) / 4;
    SendDMA(packet, size);
    return size;
}

int mgCVisualMDT::CreateExtRenderInfoPacket(u_int         *packet, float (*matrix)[4],
                                            mgRENDER_INFO *info) {
    return 0;
}

mgCVisual *mgCVisualFixMDT::Copy(mgCMemory *memory) {
    mgCVisualFixMDT *copy = new (memory->Alloc(sizeof(mgCVisualFixMDT) / 16 + 2)) mgCVisualFixMDT;

    if (copy == NULL) {
        return NULL;
    }

    *copy = *this;

    if (material_num > 0) {
        unsigned int size = material_num * sizeof(mgMaterial);
        unsigned int blocks;

        if (size % 16 != 0) {
            blocks = size / 16 + 1;
        } else {
            blocks = size / 16;
        }

        copy->material = new (memory->Alloc(blocks + 2)) mgMaterial[material_num];
    }

    for (int index = 0; index < material_num; index++) {
        copy->material[index] = material[index];
    }

    return copy;
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

int mgCVisualPrim::CreateRenderInfoPacket(u_int *packet, float (*matrix)[4], mgRENDER_INFO *info) {
    u_int      *start;
    u_int      *write;
    mgCDrawEnv *environment;
    int         size;

    write = GetScrPad();
    start = write;
    u_int tag[4] __attribute__((aligned(16)));
    *(u_long128 *) tag = 0;
    tag[0] = 0x10000007;
    tag[3] = 0x50000007;
    *(u_long128 *) write = *(u_long128 *) tag;
    giftag.word0 = 0x8002;
    *(u_long128 *) &write[4] = *(u_long128 *) &giftag;
    u_int *body = write + 8;
    *(u_long *) &body[0] = 1;
    *(u_long *) &body[2] = MG_GS_PRMODECONT;
    *(u_long *) &body[4] = 0;
    *(u_long *) &body[6] = SCE_GS_TEXFLUSH;
    environment = (mgCDrawEnv *) (body + 8);

    if (draw_env != NULL) {
        *environment = *draw_env;
    } else {
        SetDrawEnv(environment, &attr, &info->draw_env[0]);
    }

    write = (u_int *) (environment + 1);
    write[0] = MG_DMA_RET;
    write[1] = 0;
    write[2] = 0;
    write[3] = 0;
    size = ((u_long128 *) environment + 5 - (u_long128 *) start);
    SendDMA(packet, size);
    return size;
}

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
u_int set_tex0_dma[4] __attribute__((aligned(16))) = {MG_DMA_CNT | 3, 0, 0, MG_VIF_DIRECT | 3};
u_int set_tex0_giftag[4] __attribute__((aligned(16))) = {MG_GIFTAG_EOP | 2, 1u << MG_GIFTAG_NREG_SHIFT, SCE_GIF_PACKED_AD, 0};
u_int set_texa_dma[4] __attribute__((aligned(16))) = {MG_DMA_CNT | 4, 0, 0, MG_VIF_DIRECT | 4};
u_int set_texa_giftag[4] __attribute__((aligned(16))) = {MG_GIFTAG_EOP | 3, 1u << MG_GIFTAG_NREG_SHIFT, SCE_GIF_PACKED_AD, 0};
u_int mat_vif[4] __attribute__((aligned(16))) = {0, 0, 0, MG_VIF_UNPACK_V4_32 | (4 << 16) | 40};
u_int mat_vif_dif[4] __attribute__((aligned(16))) = {0, 0, 0, MG_VIF_UNPACK_V4_32 | (1 << 16) | 40};
u_int mat_vif_d[4] __attribute__((aligned(16))) = {0, 0, 0, MG_VIF_DIRECT | 2};
u_int mat_vif_d_tex[4] __attribute__((aligned(16))) = {0, 0, 0, MG_VIF_DIRECT | 4};

// Virtual tables (.vtables)
