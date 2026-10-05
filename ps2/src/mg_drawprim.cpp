#include "common.h"
// mglib.hpp cannot be included beside mg_drawenv.hpp while both declare mgFOG_PARAM; these are
// the mglib declarations this unit uses.
#include "mg_drawprim.hpp"
#include "mg_memory.hpp"
#include "mglib.hpp"

// Code (.text)
mgCDrawPrim::mgCDrawPrim() {
    memory = NULL;
    vif_packet = NULL;
    draw_manager = NULL;
    disabled = 1;
    q = 1.0f;
    *(u_long *)&prim = MG_GS_PRIM_FST;
    bilinear = 1;
    z_mask = MG_Z_MASK_WRITE;
    coord = 0;
    offset_x = 0;
    offset_y = 0;
}

void mgCDrawPrim::Initialize(mgCMemory *memory, sceVif1Packet *vif_packet) {
    if (vif_packet == NULL) {
        vif_packet = mgVif1Packet;
    }
    if (memory == NULL) {
        memory = mgGetDataBuffer();
    }
    this->memory = memory;
    this->vif_packet = vif_packet;
    detached = 0;
    if (draw_manager == NULL) {
        draw_manager = &mgDrawManager;
    }
    disabled = 1;
    texture.Initialize();
    draw_env.Initialize(0);
}

void mgCDrawPrim::Begin(int prim_type) {
    this->disabled = 1;
    if (this->memory == 0 || this->vif_packet == 0 || this->draw_manager == 0) {
        return;
    }
    if (this->draw_manager->render_info == 0) {
        return;
    }
    this->disabled = 0;
    this->prim.PRIM = prim_type;
    this->q = 1.0f;
        Begin2();
        BeginDma();
    }

void mgCDrawPrim::BeginDma() {
    this->dma_start_words = this->write_words;
    this->direct_start_words = this->dma_start_words;
    u_int *head = this->write_words;
    head[0] = 0;
    head[1] = 0;
    head[2] = 0;
    head[3] = 0;
    this->dma_tag_words = (int *)head;
    this->direct_code_words = (int *)(head + 3);
    this->write_words += 4;
    u_int *flush = this->write_words;
    this->giftag = (u_int *)flush;
    flush[0] = 0x8000;
    flush[1] = 0x10000000;
    flush[2] = 0xE;
    flush[3] = 0;
    this->write_words += 4;
    u_long *gif = (u_long *)this->write_words;
    gif[0] = *(u_long *)&prim;
    gif[1] = 0;
    this->write_words = (u_int *)(gif + 2);
}

void mgCDrawPrim::EndDma() {
    int dma_qwc = (write - dma_start) - 1;
    int direct_qwc = (write - direct_start) - 1;
    int nloop = (write - (u_long128 *)giftag) - 1;

    if (dma_qwc < 1 || direct_qwc < 1) {
        // An empty run is dropped.
        write = dma_start;
    } else {
        *dma_tag = dma_qwc | MG_DMA_CNT;
        *direct_code = direct_qwc | MG_VIF_DIRECT;
        *giftag = nloop | MG_GIFTAG_EOP;
    }
}

void mgCDrawPrim::Flush() {
    EndDma();
    BeginDma();
}

void mgCDrawPrim::End() {
    if (disabled == 0) {
        EndDma();
        End2();
    }
}

#ifdef NONMATCHING
void mgCDrawPrim::Begin2() {
    mgRENDER_INFO *render_info;
    u_int *tag;
    u_long *data;

    disabled = 1;
    if (memory != NULL && vif_packet != NULL && draw_manager != NULL &&
        (render_info = draw_manager->render_info) != NULL) {
        disabled = 0;
        packet_start = memory->stAllocTest(1);
        if (detached == 0) {
            sceVif1PkCall(vif_packet, packet_start, 0);
        }
        packet_start = (u_long128 *)((u_int)packet_start | MG_UNCACHED);
        if (packet_top == NULL) {
            packet_top = packet_start;
        }
        write = packet_start;
        draw_env.zbuf = render_info->draw_env[0].zbuf;
        draw_env.SetZBuf(z_mask);

        // DMA tag and VIF code for the seven quadwords of drawing state below.
        tag = (u_int *)write;
        tag[0] = MG_DMA_CNT | 7;
        tag[2] = 0;
        tag[1] = 0;
        tag[3] = MG_VIF_DIRECT | 7;
        write++;

        giftag = (u_int *)write;
        giftag[0] = MG_GIFTAG_EOP | 2;
        giftag[1] = 1 << MG_GIFTAG_NREG_SHIFT;
        giftag[2] = SCE_GIF_PACKED_AD;
        giftag[3] = 0;
        write++;

        data = (u_long *)write;
        data[0] = 0;
        data[1] = SCE_GS_TEXFLUSH;
        data[2] = 1;
        data[3] = MG_GS_PRMODECONT;
        write += 2;

        *(mgCDrawEnv *)write = draw_env;
        write += sizeof(mgCDrawEnv) / sizeof(u_long128);
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_drawprim", Begin2__11mgCDrawPrimFv);
#endif

void mgCDrawPrim::BeginPrim2(int type) {
    packed = 0;
    prim.PRIM = type;
    q = 1.0f;
    BeginDma();
}

void mgCDrawPrim::BeginPrim2(int prim_type, u_int data_a, u_int data_b, int unit_count) {
    packed = 1;
    prim.PRIM = prim_type;
    q = 1.0f;
    dma_start = write;
    direct_start = dma_start;
    u_int *clear = (u_int *)write;
    clear[0] = 0;
    clear[1] = 0;
    clear[2] = 0;
    clear[3] = 0;
    dma_tag = clear;
    direct_code = clear + 3;
    write++;
    u_int flags = *(u_int *)&prim & 0x7FF;
    nreg = unit_count;
    u_int *tag = (u_int *)write;
    giftag = tag;
    tag[0] = 0x8000;
    tag[1] = (nreg << 28) | (flags << 15) | 0x4000;
    tag[2] = data_a;
    tag[3] = data_b;
    write++;
}

#pragma divbyzerocheck on
void mgCDrawPrim::EndPrim2() {
    if (packed == 0) {
        EndDma();
    } else {
        int dma_qwc = (write - dma_start) - 1;
        int direct_qwc = (write - direct_start) - 1;
        int data_qwc = (write - (u_long128 *)giftag) - 1;

        if (dma_qwc < 1 || direct_qwc < 1) {
            write = dma_start;
        } else {
            *dma_tag = dma_qwc | MG_DMA_CNT;
            *direct_code = direct_qwc | MG_VIF_DIRECT;
            *giftag = data_qwc / nreg | MG_GIFTAG_EOP;
        }
    }
}
#pragma divbyzerocheck reset

void mgCDrawPrim::End2() {
    if (disabled == 0) {
        if (detached == 0) {
            u_int *tag = (u_int *)write;
            write++;
            tag[0] = MG_DMA_RET;
            tag[1] = 0;
            tag[2] = 0;
            tag[3] = 0;
            sceVif1PkTerminate(vif_packet);
        }
        memory->Alloc(write - packet_start);
    }
}

void mgCDrawPrim::Data0(float *src) {
    u_char *dst = (u_char *)command_write;
    command_write = (u_long *)(dst + 0x10);
    asm {
        lqc2 vf1, 0(src)
        vftoi0.xyzw vf1, vf1
        sqc2 vf1, 0(dst)
}
}

void mgCDrawPrim::Data4(float *src) {
    float *dst = (float *)command_write;
    command_write = (u_long *)(dst + 4);
    asm {
        lqc2 vf1, 0(src)
        vftoi4.xyzw vf1, vf1
        sqc2 vf1, 0(dst)
}
}

void mgCDrawPrim::Data(int *data) {
    u_long128 quad = *(u_long128 *)data;
    data = (int *)command_write;
    command_write = (u_long *)((u_long128 *)data + 1);
    *(u_long128 *)data = quad;
}

u_char *mgCDrawPrim::DirectData(int count) {
    u_char *p = (u_char *)command_write;
    command_write = (u_long *)(p + (count << 4));
    return p;
}

void mgCDrawPrim::Vertex(int x, int y, int z) {
    Vertex4(x << 4, y << 4, z);
}

void mgCDrawPrim::Vertex(float x, float y, float z) {
    sceVu0FVECTOR pos = {x, y, z, 0.0f};
    Vertex(pos);
}

#pragma global_optimizer off
void mgCDrawPrim::Vertex(float *pos) {
    int xyz[4];
    int *dst = xyz;
    asm {
        lqc2 vf10, 0(pos)
        vftoi4.xy vf10, vf10
        vftoi0.z vf10, vf10
        sqc2 vf10, 0(dst)
}
    Vertex4(xyz[0], xyz[1], xyz[2]);
}
#pragma global_optimizer reset

void mgCDrawPrim::Vertex4(int x, int y, int z) {
    int offset_x = 0;
    int offset_y = 0;
    GetOffset(&offset_x, &offset_y);
    u_long *vif_packet = command_write;
    vif_packet[0] = ((long long)z << 32) | ((long long)(x + offset_x) | ((long long)(y + offset_y) << 16));
    vif_packet[1] = 5;
    command_write += 2;
}

void mgCDrawPrim::Vertex4(int *pos) {
    Vertex4(pos[0], pos[1], pos[2]);
}

void mgCDrawPrim::Color(int r, int g, int b, int a) {
    u_long *vif_packet = command_write;
    u_int q = this->q_bits;
    vif_packet[0] = ((u_long)q << 32) | ((long long)r | ((long long)g << 8) | ((long long)b << 16) | ((long long)a << 24));
    vif_packet[1] = 1;
    command_write += 2;
}

#pragma global_optimizer off
void mgCDrawPrim::Color(float *color) {
    int rgba[4];
    int *dst = rgba;
    asm {
        lqc2 vf10, 0(color)
        vftoi0.xyzw vf10, vf10
        sqc2 vf10, 0(dst)
}
    Color(rgba[0], rgba[1], rgba[2], rgba[3]);
}
#pragma global_optimizer reset

void mgCDrawPrim::TextureCrd4(int u, int v) {
    u_long *data = (u_long *)write;
    data[0] = (long)u | (long)v << 16;
    data[1] = SCE_GS_UV;
    write++;
}

void mgCDrawPrim::TextureCrd(int u, int v) {
    TextureCrd4(u << 4, v << 4);
}

void mgCDrawPrim::Direct(unsigned long reg, unsigned long data) {
    u_long *dst = (u_long *)write;
    dst[0] = data;
    dst[1] = reg;
    write++;
}

void mgCDrawPrim::Texture(mgCTexture *source) {
    if (source != 0) {
        texture = *source;
        texture.Bilinear(bilinear);
        u_long *packet = command_write;
        packet[0] = 0;
        packet[1] = 0x3F;
        packet[2] = *(u_long *)&texture.tex1;
        packet[3] = 0x14;
        packet[4] = *(u_long *)&texture.tex0;
        packet[5] = 6;
        command_write = packet + 6;
    }
}

void mgCDrawPrim::AlphaBlendEnable(int enable) {
    prim.ABE = enable;
}

void mgCDrawPrim::AlphaBlend(int mode) {
    draw_env.SetAlpha(mode);
}

void mgCDrawPrim::AlphaTestEnable(int enable) {
    draw_env.test.bits.ate = enable;
}

void mgCDrawPrim::AlphaTest(int method, int ref) {
    draw_env.test.bits.atst = method;
    draw_env.test.bits.aref = ref;
}

void mgCDrawPrim::DAlphaTest(int enable, int mode) {
    draw_env.test.bits.date = enable;
    draw_env.test.bits.datm = mode;
}

void mgCDrawPrim::DepthTestEnable(int enable) {
    if (enable == 0) {
        draw_env.test.bits.zte = 1;
        draw_env.test.bits.ztst = 1;
    } else {
        DepthTest(1);
    }
}

void mgCDrawPrim::DepthTest(int mode) {
    draw_env.test.bits.zte = 1;
    switch (mode) {
        case -1:
            draw_env.test.bits.ztst = 1;
            break;
        case 1:
            draw_env.test.bits.ztst = 2;
            break;
        case 2:
            draw_env.test.bits.ztst = 3;
            break;
    }
}

void mgCDrawPrim::ZMask(int mask) {
    z_mask = mask;
}

void mgCDrawPrim::TextureMapEnable(int enable) {
    prim.TME = enable;
}

void mgCDrawPrim::Bilinear(int enable) {
    bilinear = enable;
}

void mgCDrawPrim::Shading(int enable) {
    prim.IIP = enable;
}

void mgCDrawPrim::AntiAliasing(int enable) {
    prim.AA1 = enable;
}

void mgCDrawPrim::FogEnable(int enable) {
    prim.FGE = enable;
}

void mgCDrawPrim::Coord(int coord) {
    this->coord = coord;
}

void mgCDrawPrim::GetOffset(int *x, int *y) {
    *y = 0;
    *x = 0;
    if (coord == 0) {
        *x = mgScreenOffx << 4;
        *y = mgScreenOffy << 4;
    }
    *x += offset_x;
    *y += offset_y;
}

#pragma schedule off
mgCDrawManager::mgCDrawManager() {
    unk_68 = 0x40;
    unk_6c = 0;
    unk_70 = 0;
}
#pragma schedule reset
#pragma schedule off

void mgCDrawManager::SetSortTable(int num) {
    float near_dist = 1.0f;
    float far_dist = 2.0f;

    if (render_info != NULL) {
        near_dist = render_info->clip_min[2];
        far_dist = render_info->clip_max[2];
    }
    sort_num = num;
    sort_max = sort_num - 1;
    sort_num_f = (float)num;
    near_clip = near_dist;
    far_clip = far_dist;
    clip_range = far_dist - near_clip;
    sort_near = near_clip;
    sort_ratio = near_clip / far_clip;
    sort_scale = sort_num_f;
}
#pragma schedule reset

#pragma schedule off
#pragma opt_loop_invariants off
#pragma global_optimizer off
void mgCDrawManager::BeginDraw(mgCMemory *new_memory, int *id_list) {
    int blocks;
    int used_count;
    int i;
    int *cursor;
    memory = new_memory;
    if (memory == 0) {
        memory = packet_memory;
    }
    group_num = texture_manager->block_max;
    group_max = group_num;
    blocks = group_num / 4 + 1;
    order_index = 0;
    draw_order = 0;
    if (id_list != 0) {
        order_index = (int *)memory->Alloc(group_max / 4 + 1);
        for (i = 0; i < group_max; i++) {
            order_index[i] = -1;
        }
        cursor = id_list;
        used_count = 0;
        while (*cursor >= 0) {
            used_count++;
            cursor++;
        }
        draw_order = (int *)memory->Alloc((used_count + 1) / 4 + 1);
        for (i = 0; i < used_count; i++) {
            draw_order[i] = id_list[i];
            order_index[draw_order[i]] = i;
        }
        draw_order[i] = -1;
        group_num = used_count;
        blocks = (group_num + 1) / 4 + 1;
    }
    packet_list = (mgSORT_PACKET ***)memory->Alloc(blocks);
    unk_14 = (int *)memory->Alloc(blocks);
    packet_num = (int *)memory->Alloc(blocks);
    sort_table = (mgSORT_PACKET **)memory->Alloc(sort_num);
    ClearTable();
}
#pragma global_optimizer reset
#pragma opt_loop_invariants reset
#pragma schedule reset

#pragma optimization_level 1
void mgCDrawManager::ClearTable() {
    int *a = (int *)packet_list;
    int *b = unk_14;
    int *c = packet_num;
    int *packet = (int *)sort_table;
    for (int i = 0; i < group_num; i++) {
        *a++ = 0;
        *b++ = 0;
        *c++ = 0;
    }
    for (int j = 0; j < sort_num; j++) {
        *packet++ = 0;
    }
}
#pragma optimization_level reset

#pragma schedule off
#pragma global_optimizer off
void mgCDrawManager::PreEndDraw() {
    packet_cursor = (mgSORT_PACKET ***)memory->Alloc(group_num / 4 + 1);
    int *sizes = packet_num;
    for (int i = 0; i < group_num; i++) {
        int size = *sizes;
        sizes++;
        if (size > 0) {
            packet_list[i] = (mgSORT_PACKET **)memory->Alloc(size / 4 + 1);
            packet_cursor[i] = packet_list[i];
        }
    }
    // Only the first sort bucket is used.
    for (int j = 0; j < 1; j++) {
        mgSORT_PACKET *item = sort_table[j];
        if (item != 0) {
            while (item != 0) {
                *packet_cursor[item->group] = item;
                packet_cursor[item->group]++;
                item = item->next;
            }
        }
    }
}
#pragma global_optimizer reset
#pragma schedule reset
#pragma schedule off

int mgCDrawManager::ReloadTexture(int group, sceVif1Packet *vif_packet) {
    mgCTextureManager *manager = texture_manager;
    int index;

    if (group < 0 || group >= manager->block_max) {
        return 0;
    }
    index = group;
    if (draw_order != NULL) {
        index = order_index[group];
    }
    if (index < 0) {
        return 0;
    }
    sceVif1PkTerminate(vif_packet);
    manager->ReloadTexture(group, vif_packet);
    return 1;
}
#pragma schedule reset

#ifdef NONMATCHING
int mgCDrawManager::Draw(int group, sceVif1Packet *vif_packet) {
    u_int *start;
    u_int *tag;
    mgSORT_PACKET **entry;
    u_long128 *common;
    int i;

    if (group < 0 || group >= texture_manager->block_max) {
        return 0;
    }
    if (draw_order != NULL) {
        group = order_index[group];
    }
    if (group < 0) {
        return 0;
    }
    if (packet_list[group] == NULL) {
        return 1;
    }
    sceVif1PkTerminate(vif_packet);
    start = (u_int *)vif_packet->p_current;
    entry = &packet_list[group][packet_num[group] - 1];
    common = NULL;
    tag = start;
    // Packets are called in the reverse of their registration order.
    for (i = 0; i < packet_num[group]; i++) {
        if (*entry != NULL) {
            tag += mgSendVuProg(tag, (*entry)->vu_program);
            if (common != (*entry)->common) {
                tag[0] = MG_DMA_CALL;
                tag[1] = (u_int)(*entry)->common;
                tag[2] = 0;
                tag[3] = 0;
                tag += 4;
                common = (*entry)->common;
            }
            tag[0] = MG_DMA_CALL;
            tag[1] = (u_int)(*entry)->packet;
            tag[2] = 0;
            tag[3] = 0;
            tag += 4;
            entry--;
        }
    }
    sceVif1PkReserve(vif_packet, tag - start);
    return 1;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/mg_drawprim", Draw__14mgCDrawManagerFiP13sceVif1Packet);
#endif

#pragma schedule off
#pragma global_optimizer off
void mgCDrawManager::EndDraw(sceVif1Packet *vif_packet) {
    int i;
    int group;

    PreEndDraw();
    for (i = 0; i < group_num; i++) {
        // Without a draw order the group is left as it was.
        if (draw_order != NULL) {
            group = draw_order[i];
        }
        ReloadTexture(group, vif_packet);
        Draw(group, vif_packet);
    }
}
#pragma global_optimizer reset
#pragma schedule reset
#pragma schedule off

void mgCDrawManager::AddPacket(int group, u_long128 *common, u_long128 *packet, int vu_program) {
    int index;
    mgSORT_PACKET *node;
    if (group < group_max) {
        index = group;
        if (order_index != 0) {
        if (group < 0) {
                index = order_index[*draw_order];
        } else {
                index = order_index[group];
    }
            if (index < 0) {
            return;
        }
    }
        node = (mgSORT_PACKET *)memory->Alloc(1);
        node->next = *sort_table;
        *sort_table = node;
        node->common = common;
        node->packet = packet;
        node->group = index;
        node->vu_program = vu_program;
        packet_num[index]++;
}
}
#pragma schedule reset

// Uninitialised data (.bss)
INCLUDE_BSS(at_369, 0x10);
