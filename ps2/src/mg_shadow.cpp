#include "common.h"

#include <libgraph.h>
#include <libvu0.h>

#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_shadow.hpp"
#include "mg_visual.hpp"

// Code (.text)
#pragma schedule off

/**
 *
 * Writes the packet that loads the shadow projection matrix into VU1 memory, followed by the GS
 * packets the shadow microprogram sends, and returns its length in quadwords.
 *
 */
static int SetShadowData(u_int *packet, float (*matrix)[4]) {
    // DMA CNT of eight quadwords, then VIF UNPACK of the matrix and the two GIF packets.
    packet[0] = 0x10000008;
    packet[1] = 0;
    packet[2] = 0;
    packet[3] = 0x6C080028;
    u_long128 *dst = (u_long128 *) (packet + 4);
    dst[0] = *(u_long128 *) matrix[0];
    dst[1] = *(u_long128 *) matrix[1];
    dst[2] = *(u_long128 *) matrix[2];
    dst[3] = *(u_long128 *) matrix[3];
    packet[0x14] = 0x8001;
    packet[0x15] = 0x102E8000;
    packet[0x16] = 0xE;
    packet[0x17] = 0;
    packet[0x18] = 0x68;
    packet[0x19] = 0x80;
    packet[0x1A] = 0x42;
    packet[0x1B] = 0;
    packet[0x1C] = 0x8001;
    packet[0x1D] = 0x102E8000;
    packet[0x1E] = 0xE;
    packet[0x1F] = 0;
    packet[0x20] = 0x62;
    packet[0x21] = 0x80;
    packet[0x22] = 0x42;
    packet[0x23] = 0;
    return 9;
}

#pragma schedule reset

struct ShadowGifRegs {
    u_long REGS0 : 4;
    u_long REGS1 : 4;
};

#pragma schedule off
#pragma optimization_level 2
int mgCShadowMDT::CreateFacePacket(u_int *packet, mgCFace *face) {
    static u_int prog_vif[4] __attribute__((aligned(16))) = {0, 0, 0, 0x14000002};

    if (face == NULL) {
        return 0;
    }

    int scratchpad = 0;
    if (((u_int)packet & 0xF0000000) == 0x20000000) {
        scratchpad = 1;
    }

    u_int *start = packet;
    u_int prim = (u_short)face->type & MG_FACE_PRIM_MASK;
    int remain = face->vertex_num;
    int *index = face->index;

    union {
        sceGifTag tag;
        struct {
            u_long lo;
            ShadowGifRegs hi;
        } parts;
    } gif;
    *(u_long128 *)&gif.tag = 0;
    gif.tag.EOP = 1;
    gif.tag.PRE = 1;
    ShadowGifRegs *regs = &gif.parts.hi;
    if (prim != MG_PRIM_TRIANGLE) {
        return 0;
    }
    gif.tag.PRIM = SCE_GS_SET_PRIM(MG_PRIM_TRIANGLE_FAN, 1, 1, 0, 1, 0, 0, 0, 0);
    gif.tag.NREG = 2;
    regs->REGS0 = SCE_GS_RGBAQ;
    regs->REGS1 = SCE_GS_XYZF2;

    u_int *write = scratchpad ? GetScrPad() : packet;
    u_int *block = write;
    for (; remain > 0; remain -= 42) {
        int num = 42;
        if (remain < 42) {
            num = remain;
        }

        write[0] = 0;
        write[1] = 0;
        write[2] = 0;
        u_int *unpack = &write[3];
        write[3] = 0;
        u_int *data = &write[4];
        gif.tag.NLOOP = num;
        ((u_long128 *)write)[1] = *(u_long128 *)&gif.tag;
        write[8] = num;
        write[9] = num;
        write[10] = face->type;

        sceVu0FVECTOR *vertex = this->vertex;
        u_long128 *out = &((u_long128 *)write)[3];
        for (; num > 0; num--) {
            out[0] = *(u_long128 *)vertex[index[0]];
            out[1] = *(u_long128 *)vertex[index[1]];
            out[2] = *(u_long128 *)vertex[index[2]];
            index += 3;
            out += 3;
        }
        *unpack = (((u_int)((u_int *)out - data) / 4) << 16) | 0x6C008000;
        *out = *(u_long128 *)prog_vif;
        write = (u_int *)(out + 1);

        int size = write - block;
        if (size > 0x514) {
            if (scratchpad) {
                SendDMA(packet, size / 4);
            }
            packet += size;
            write = scratchpad ? GetScrPad() : packet;
            block = write;
        }
    }

    int size = write - block;
    if (scratchpad && size > 0) {
        SendDMA(packet, size / 4);
    }
    packet += size;

    u_int flush[4] = {0x13000000, 0, 0, 0};
    *(u_long128 *)packet = *(u_long128 *)flush;
    return (packet + 4 - start) / 4;
}
#pragma optimization_level reset
#pragma schedule reset

#pragma schedule off
#pragma global_optimizer off

FACES_ID *mgCShadowMDT::CreateFace(FACES_ID *source, mgCMemory *face_memory, mgCMemory *index_memory,
                                   mgCFace **result) {
    mgCFace *face = new (face_memory->Alloc(5)) mgCFace;
    face->vertex_num = (int) source->face_num / 3;
    face->type = source->type;
    face->index_stride = 3;
    face->index_num = face->vertex_num * face->index_stride;
    // Only the position index of each of a triangle's three vertices is kept.
    face->material = source->material;
    int *vertex;
    source = (FACES_ID *) (vertex = source->index);
    int *index = (int *) index_memory->Alloc(face->index_num * 4 / 16 + 0x10);
    face->index = index;

    for (int i = 0; i < face->vertex_num; i++) {
        index[0] = vertex[0];
        index[1] = vertex[3];
        index[2] = vertex[6];
        index += 3;
        vertex += 9;
    }

    face->next = NULL;
    mgFACE_GROUP *group = face_group;

    if (group == NULL) {
        group = (mgFACE_GROUP *) face_memory->Alloc(0x12);
        group->next = 0;
        group->face = NULL;
        group->material = face->material;
        group->vu_program = 1; // MG_VU_PROG_SHADOW
        face_group = group;
    }

    mgCFace *last = group->face;

    if (last == NULL) {
        group->face = face;
    } else {
        mgCFace *following;

        while ((following = last->next) != NULL) {
            last = following;
        }

        last->next = face;
    }

    if (result != NULL) {
        *result = face;
    }

    return (FACES_ID *) vertex;
}

#pragma global_optimizer reset
#pragma schedule reset

#pragma schedule off
#pragma global_optimizer off

u_int mgCShadowMDT::CreatePacket(mgCDrawManager *draw_manager) {

    GetTextureManager();
    mgFACE_GROUP *node = face_group;
    mgCMemory    *packet_memory = draw_manager->packet_memory;
    mgCMemory    *face_memory = draw_manager->data_memory;
    u_int        *packet_start = (u_int *) &packet_memory->stack[packet_memory->stack_used];
    int           face_start = (int) &face_memory->stack[face_memory->stack_used];
    int           face_cursor = face_start;
    u_int        *cursor = packet_start;
    u_int        *tag;

    while (node != NULL) {
        node->packet = (u_long128 *) cursor;
        mgCFace *group = node->face;

        // DMA REF to the face's packet, built through the uncached mirror of the data memory.
        while (group != NULL) {
            tag = cursor;
            cursor += 4;
            tag[0] = 0x30000000;
            tag[1] = face_cursor;
            tag[2] = 0;
            tag[3] = 0;
            int count = CreateFacePacket((u_int *) (face_cursor | 0x20000000), group);
            face_cursor += count * 16;
            group = group->next;
            tag[0] |= count;
        }

        cursor += mgSetPkTexFlush_TagCnt(cursor) * 4;
        u_int *flush = cursor;
        cursor += 4;
        // DMA RET.
        flush[0] = 0x60000000;
        flush[1] = 0;
        flush[2] = 0;
        flush[3] = 0;
        node->packet_size = (int) ((u_char *) cursor - (u_char *) node->packet) / 16;
        node = node->next;
    }

    packet_memory->Alloc((int) ((u_char *) cursor - (u_char *) packet_start) / 16);
    face_memory->Alloc((face_cursor - face_start) / 16);
    return (int) packet_start & 0x0FFFFFFF;
}

#pragma global_optimizer reset
#pragma schedule reset

#pragma schedule off
#pragma global_optimizer off

int mgCShadowMDT::DataAssignMDT(MDT_HEADER *header, mgCMemory *memory,
                                mgCTextureManager *textures) {
    if (header == NULL) {
        return 0;
    }

    texture_manager = textures;
    // A shadow needs neither normals nor texture coordinates.
    header->uv_num = 0;
    header->normal_num = 0;
    mgCVisualMDT::CopyMDTData(header, memory);
    face_group = 0;
    MDT_FACES *faces = (MDT_FACES *) ((u_char *) header + header->faces_ofs);
    FACES_ID  *cursor = (FACES_ID *) (faces + 1);
    int        count = faces->prim_num;

    for (int i = 0; i < count; i++) {
        cursor = CreateFace(cursor, memory, memory, 0);
    }

    return 1;
}

#pragma global_optimizer reset
#pragma schedule reset

#pragma schedule off
#pragma global_optimizer off
int mgCShadowMDT::CreateRenderInfoPacket(u_int *packet, float (*matrix)[4], mgRENDER_INFO *info) {
    sceVu0FMATRIX world_screen;
    u_int zero[4] = {0, 0, 0, 0};
    mgMulMatrix(world_screen, info->world_screen, matrix);

    u_int *write = GetScrPad();
    u_int *start = write;
    u_int *head = write;
    info->GetpLightInfo();

    head[0] = 0x10000000;
    head[1] = 0;
    head[2] = 0;
    head[3] = 0;
    head[4] = 0;
    head[5] = vu1_base | 0x03000000;
    head[6] = vu1_offset | 0x02000000;

    u_long128 *vu = (u_long128 *)head;
    vu[2] = *(u_long128 *)zero;
    vu[3] = *(u_long128 *)zero;
    vu[4] = *(u_long128 *)zero;
    head[20] = info->render_params[3];
    ((float *)head)[21] = ((float *)info->render_params)[0];
    ((float *)head)[22] = ((float *)info->render_params)[1];
    ((float *)head)[23] = ((float *)info->render_params)[2];
    sceVu0CopyMatrix((sceVu0FVECTOR *)&vu[6], world_screen);
    sceVu0CopyMatrix((sceVu0FVECTOR *)&vu[10], matrix);
    vu[14] = *(u_long128 *)zero;
    vu[15] = *(u_long128 *)zero;
    vu[16] = *(u_long128 *)zero;
    ((float *)head)[56] = info->shadow_light_dir[0];
    ((float *)head)[60] = info->shadow_light_dir[1];
    ((float *)head)[64] = info->shadow_light_dir[2];
    vu[23] = *(u_long128 *)info->full_max;
    vu[24] = *(u_long128 *)info->full_min;

    write = head + 104;
    sceVu0FMATRIX view_clip;
    mgMulMatrix(view_clip, info->view_clip_full, info->view);
    mgMulMatrix(view_clip, view_clip, matrix);
    ((u_long128 *)write)[1] = *(u_long128 *)view_clip[0];
    ((u_long128 *)write)[2] = *(u_long128 *)view_clip[1];
    ((u_long128 *)write)[3] = *(u_long128 *)view_clip[2];
    ((u_long128 *)write)[4] = *(u_long128 *)view_clip[3];
    ((u_long128 *)write)[5] = *(u_long128 *)info->clip_screen_full[0];
    ((u_long128 *)write)[6] = *(u_long128 *)info->clip_screen_full[1];
    ((u_long128 *)write)[7] = *(u_long128 *)info->clip_screen_full[2];
    ((u_long128 *)write)[8] = *(u_long128 *)info->clip_screen_full[3];
    head[7] = ((((u_int)(&write[36] - &head[4]) / 4) - 1) << 16) | 0x6C000000;

    write[36] = 0;
    write[37] = 0;
    write[38] = 0;
    write[39] = 0x14000000;
    head[0] |= (&write[40] - &head[4]) / 4;

    write[40] = 0x10000008;
    write[41] = 0;
    write[42] = 0;
    write[43] = 0x50000008;
    write[44] = 0x8003;
    write[45] = 0x10000000;
    write[46] = SCE_GIF_PACKED_AD;
    write[47] = 0;
    u_long *ad = (u_long *)&write[48];
    ad[0] = 0;
    ad[1] = SCE_GS_PRMODECONT;
    ad[2] = 0x40;
    ad[3] = SCE_GS_PRMODE;
    ad[4] = SCE_GS_SET_RGBAQ(1, 1, 1, 0x80, 0);
    ad[5] = SCE_GS_RGBAQ;

    write = (u_int *)&ad[6];
    mgCDrawEnv *env = (mgCDrawEnv *)write;
    if (draw_env != NULL) {
        *env = *draw_env;
    } else {
        *env = info->draw_env[0];
    }
    env->SetZBuf(MG_ZBUF_NO_WRITE);
    env->test.bits.zte = 1;
    env->test.bits.ztst = SCE_GS_ZGEQUAL;
    env->test.bits.ate = 0;
    env->test.bits.afail = 0;
    env->test.bits.date = 0;
    write = (u_int *)(env + 1);

    sceVu0FMATRIX shadow;
    mgMulMatrix(shadow, info->shadow, matrix);
    mgMulMatrix(shadow, info->view, shadow);
    mgMulMatrix(shadow, info->view_clip_full, shadow);
    write += SetShadowData(write, shadow) * 4;

    write[0] = 0x60000000;
    write[1] = 0;
    write[2] = 0;
    write[3] = 0;

    int size = (write + 4 - start) / 4;
    SendDMA(packet, size);
    return size;
}
#pragma global_optimizer reset
#pragma schedule reset
