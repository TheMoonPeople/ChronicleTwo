#include "common.h"

#include <cmath>

#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_sprite.hpp"
#include "mglib.hpp"

/**
 *
 * GIF tag fields used while drawing a sprite.
 *
 */
struct SpriteGifTag {
    u_char unknown_00;
    u_char unknown_01 : 7;
    u_char eop : 1; /**< Ends the GIF packet when set. */
    u_char unknown_02[3];
    u_char unknown_05 : 6;
    u_char pre : 1; /**< Includes the PRIM value in the GIF tag. */
    u_char unknown_05hi : 1;
    u_char unknown_06;
    u_char unknown_07 : 4;
    u_char nreg : 4;  /**< Number of GS registers in each loop. */
    u_char regs0 : 4; /**< First GS register descriptor. */
    u_char regs1 : 4; /**< Second GS register descriptor. */
    u_char regs2 : 4; /**< Third GS register descriptor. */
    u_char regs3 : 4; /**< Fourth GS register descriptor. */
    u_char regs4 : 4; /**< Fifth GS register descriptor. */
    u_char regs5 : 4; /**< Sixth GS register descriptor. */
    u_char regs6 : 4; /**< Seventh GS register descriptor. */
    u_char regs7 : 4; /**< Eighth GS register descriptor. */
    u_char regs8 : 4;
    u_char regs9 : 4;
};

/**
 *
 * PRIM field of the sprite's GIF tag.
 *
 */
struct SpriteGifPrim {
    unsigned long long unknown_low : 47;
    unsigned long long prim : 11; /**< GS primitive attributes. */
    unsigned long long unknown_high : 6;
};

/**
 *
 * VIF data viewed as one quadword or four words.
 *
 */
union VifQuad {
    u_long128 q;    /**< Quadword value. */
    u_int     w[4]; /**< The same data as words. */
};

/**
 *
 * Words of the GIF tag written into a sprite packet.
 *
 */
struct SpriteGifTagBuf {
    u_int loop_flags;   /**< Loop count and end-of-packet flag. */
    u_int prim_flags;   /**< Primitive controls and register count. */
    u_int registers_lo; /**< First eight GS register descriptors. */
    u_int registers_hi; /**< Last eight GS register descriptors. */
};

/**
 *
 * GIF tag of the GS register writes that draw an mgCSprite, in A+D mode, whose loop count CreatePacket sets.
 *
 */
static SpriteGifTagBuf sprite_giftag __attribute__((aligned(16))) = {
    MG_GIFTAG_EOP,
    1 << MG_GIFTAG_NREG_SHIFT,
    SCE_GIF_PACKED_AD,
    0,
};

// Code (.text)
int mgC3DSprite::CreateRenderInfoPacket(u_int         *dest, float (*matrix)[4],
                                        mgRENDER_INFO *render_info) {
    sceVu0FMATRIX         local_screen;
    sceVu0IVECTOR         zero = {0, 0, 0, 0};
    u_int                *packet;
    float                 scale_x;
    mg3DSpriteRenderHead *head;
    u_int                 flags;
    float                 scale_y;
    float                 scale_z;
    mgCFrameAttr         *attr;
    u_int                 fog_color;
    int                   size;
    mg3DSpriteRenderTail *tail;
    float(*view_screen)[4];

    mgMulMatrix(local_screen, render_info->world_screen, matrix);
    head = (mg3DSpriteRenderHead *) (packet = (u_int *) GetScrPad());
    render_info->GetpLightInfo();

    head->dma_tag[0] = MG_DMA_CNT;
    head->dma_tag[1] = 0;
    head->dma_tag[2] = 0;
    head->dma_tag[3] = 0;
    head->vif_code[0] = 0;
    head->vif_code[1] = MG_VIF_BASE | 0x3C;
    head->vif_code[2] = MG_VIF_OFFSET | 0xB4;
    *(u_long128 *) head->unk_20[0] = *(u_long128 *) zero;
    *(u_long128 *) head->unk_20[1] = *(u_long128 *) zero;
    *(u_long128 *) head->unk_20[2] = *(u_long128 *) zero;
    head->unk_50[0] = render_info->render_params[3];
    ((float *) head->unk_50)[1] = ((float *) render_info->render_params)[0];
    ((float *) head->unk_50)[2] = ((float *) render_info->render_params)[1];
    ((float *) head->unk_50)[3] = ((float *) render_info->render_params)[2];
    sceVu0CopyMatrix(head->local_screen, local_screen);
    sceVu0CopyMatrix(head->local_world, matrix);
    render_info->scissor = 0;

    tail = (mg3DSpriteRenderTail *) (head + 1);
    head->fog[0] = render_info->fog.offset;
    head->fog[1] = render_info->fog.near_value;
    head->fog[2] = render_info->fog.far_value;
    head->fog[3] = render_info->fog.scale;

    scale_x = mgDistVector(matrix[0]);
    scale_y = mgDistVector(matrix[1]);
    scale_z = mgDistVector(matrix[2]);
    *(u_long128 *) tail->view_screen[0] = *(u_long128 *) render_info->view_screen[0];
    *(u_long128 *) tail->view_screen[1] = *(u_long128 *) render_info->view_screen[1];
    *(u_long128 *) tail->view_screen[2] = *(u_long128 *) render_info->view_screen[2];
    *(u_long128 *) tail->view_screen[3] = *(u_long128 *) render_info->view_screen[3];
    view_screen = tail->view_screen;
    sceVu0ScaleVectorXYZ(view_screen[0], view_screen[0], scale_x);
    sceVu0ScaleVectorXYZ(view_screen[1], view_screen[1], scale_y);
    sceVu0ScaleVectorXYZ(view_screen[2], view_screen[2], scale_z);

    head->vif_code[3] = MG_VIF_UNPACK_V4_32 | ((u_int) ((u_int *) tail->program_call - head->vif_code) / 4 -
                                               1) << MG_VIF_NUM_SHIFT;
    tail->program_call[0] = 0;
    tail->program_call[1] = 0;
    tail->program_call[2] = 0;
    tail->program_call[3] = MG_VIF_MSCAL;
    head->dma_tag[0] |= (tail->flags_tag - head->vif_code) / 4;

    flags = 0;

    if (render_info->clip | render_info->scissor) {
        flags |= MG_3DSPRITE_FLAG_CLIP;
    }

    if (render_info->scissor) {
        flags |= MG_3DSPRITE_FLAG_SCISSOR;
    }

    attr = render_info->attr;

    if (attr->program_mode) {
        flags |= MG_3DSPRITE_FLAG_PROGRAM_MODE;
    }

    if (attr->program_option) {
        flags |= MG_3DSPRITE_FLAG_PROGRAM_OPTION;
    }

    if (render_info->plight_hit) {
        flags |= MG_3DSPRITE_FLAG_POINT_LIGHT;
    }

    if (attr->no_light) {
        flags |= MG_3DSPRITE_FLAG_NO_LIGHT;
    }

    tail->flags_tag[0] = MG_DMA_CNT | 6;
    tail->flags_tag[1] = 0;
    tail->flags_tag[2] = 0;
    tail->flags_tag[3] = MG_VIF_UNPACK_V4_32 | 1 << MG_VIF_NUM_SHIFT | 0x26;
    tail->flags[0] = flags;
    tail->flags[1] = 0;
    tail->flags[2] = 0;
    tail->flags[3] = 0;
    tail->direct_tag[0] = 0;
    tail->direct_tag[1] = 0;
    tail->direct_tag[2] = 0;
    tail->direct_tag[3] = MG_VIF_DIRECT | 4;
    tail->giftag[0] = MG_GIFTAG_EOP | 3;
    tail->giftag[1] = 1 << MG_GIFTAG_NREG_SHIFT;
    tail->giftag[2] = SCE_GIF_PACKED_AD;
    tail->giftag[3] = 0;
    tail->prmodecont[0] = 0;
    tail->prmodecont[1] = 0;
    tail->prmodecont[2] = SCE_GS_PRMODECONT;
    tail->prmodecont[3] = 0;

    this->prmode =
        SCE_GS_SET_PRIM(0, 1, 1, (render_info->attr->fog && render_info->fog_enable) != 0, 1, 0, 1, 0, 0);
    tail->prmode[0] = prmode;
    tail->prmode[1] = 0;
    tail->prmode[2] = SCE_GS_PRMODE;
    tail->prmode[3] = 0;

    fog_color = render_info->fog.r;
    fog_color |= render_info->fog.g << 8;
    fog_color |= render_info->fog.b << 16;

    if (render_info->attr->fog > 1) {
        fog_color = 0;
    }

    tail->fogcol[0] = fog_color;
    tail->fogcol[1] = 0;
    tail->fogcol[2] = SCE_GS_FOGCOL;
    tail->fogcol[3] = 0;
    tail->ret_tag[0] = MG_DMA_RET;
    tail->ret_tag[1] = 0;
    tail->ret_tag[2] = 0;
    tail->ret_tag[3] = 0;

    size = ((u_int *) (tail + 1) - packet) / 4;
    SendDMA(dest, size);
    return size;
}

int mgC3DSprite::Draw(u_int *tag, float (*matrix)[4], mgCDrawManager *manager) {
    if (manager == NULL) {
        manager = &mgDrawManager;
    }

    mgRENDER_INFO *render_info = manager->render_info;
    texture_manager = manager->texture_manager;

    if (packet == 0) {
        return 0;
    }

    mgCMemory *data_memory = (mgCMemory *) manager->data_memory;
    int        buffer = (int) data_memory->stAllocTest(0x3C);
    data_memory->Alloc(CreateRenderInfoPacket((u_int *) buffer, matrix, render_info));

    if (tag != NULL) {
        u_int *cursor = tag + 4;
        tag[0] = 0x50000000;
        tag[1] = buffer;
        tag[2] = 0;
        tag[3] = 0;
        cursor += mgSendVuProg(cursor, 2);
        cursor[0] = 0x50000000;
        cursor[1] = (u_int) packet;
        cursor[2] = 0;
        cursor[3] = 0;
        return (int) (cursor + 4 - tag) / 4;
    }

    return 0;
}

void mgC3DSprite::BeginCreatePacket(int mode, mgCDrawManager *manager) {
    if (manager == NULL) {
        manager = &mgDrawManager;
    }

    memory = manager->data_memory;
    packet = &memory->stack[memory->stack_used];
    packet_start = (u_long128 *) ((u_int) packet | MG_UNCACHED);
    packet_cur = packet_start;
    this->mode = mode;
    prog_started = 0;
}

void mgC3DSprite::CPSetDrawEnv(mgCDrawEnv *draw_env) {
    if (draw_env != NULL) {
        u_int *header = (u_int *) packet_cur;
        header[0] = 0x10000004;
        header[2] = 0;
        header[1] = 0;
        header[3] = 0x50000004;
        packet_cur += 1;
        *(mgCDrawEnv *) packet_cur = *draw_env;
        packet_cur += 4;
        int macro = draw_env->GetAlphaMacroID();
        // Additive and subtractive blends fog towards black so that fogged pixels fade out.
        u_int *extra = (u_int *) packet_cur;

        if (macro == 2 || macro == 3) {
            extra[0] = 0x10000002;
            extra[1] = 0;
            extra[2] = 0;
            extra[3] = 0x50000002;
            extra[4] = 0x8001;
            extra[5] = 0x10000000;
            extra[6] = 0xE;
            extra[7] = 0;
            extra[8] = 0;
            extra[9] = 0;
            extra[10] = 0x3D;
            extra[11] = 0;
            packet_cur += 3;
        }
    }
}

void mgC3DSprite::CPSetTexture(mgCTexture *texture) {
    if (texture != NULL) {
        packet_cur += mgSetPkTexFlush_TagCnt((u_int *) packet_cur);
        packet_cur +=
            mgSetPkTEX0((u_int *) packet_cur, texture->tex0.value, *(u_long *) &texture->tex1);
    }
}

void mgC3DSprite::BeginCPSprite() {
    batch_tag = (u_int *) packet_cur++;
    batch_giftag = (sceGifTag *) packet_cur++;
    batch_header = (u_int *) packet_cur++;
    sprite_num = 0;
    SpriteGifTag  *tag = (SpriteGifTag *) batch_giftag;
    SpriteGifPrim *prim_word = (SpriteGifPrim *) batch_giftag;
    *(u_long128 *) tag = 0;
    tag->eop = 1;
    tag->pre = 1;

    switch (mode) {
        case 1:
            prim_word->prim = 0x5C;
            tag->nreg = 9;
            tag->regs0 = 1;
            tag->regs1 = 3;
            tag->regs2 = 4;
            tag->regs3 = 3;
            tag->regs4 = 4;
            tag->regs5 = 3;
            tag->regs6 = 4;
            tag->regs7 = 3;
            tag->regs8 = 4;
            break;
        default:
        case 0:
            prim_word->prim = 0x5E;
            tag->nreg = 5;
            tag->regs0 = 1;
            tag->regs1 = 3;
            tag->regs2 = 4;
            tag->regs3 = 3;
            tag->regs4 = 4;
            break;
    }
}

void mgC3DSprite::CPSetSprite(float *first, float *second, float *third, float *fourth,
                              float *fifth) {
    *packet_cur++ = *(u_long128 *) first;

    if (mode == 1) {
        float    *slot = (float *) packet_cur;
        u_long128 second_vector = *(u_long128 *) second;
        packet_cur++;
        *(u_long128 *) slot = second_vector;
        slot[2] = sinf(second[2]);
        slot[3] = cosf(second[2]);
    } else {
        *packet_cur++ = *(u_long128 *) second;
    }

    *packet_cur++ = *(u_long128 *) third;
    *packet_cur++ = *(u_long128 *) fourth;
    *packet_cur++ = *(u_long128 *) fifth;
    sprite_num += 1;

    if (sprite_num > 32) {
        EndCPSprite();
        BeginCPSprite();
    }
}

void mgC3DSprite::EndCPSprite() {
    // VIF quadword starting the billboard program at address two.
    static u_int prog_vif[4] __attribute__((aligned(16))) = {0, 0, 0, MG_VIF_MSCAL | 2};

    // VIF quadword continuing the billboard program.
    static u_int progf_vif[4] __attribute__((aligned(16))) = {0, 0, 0, MG_VIF_MSCNT};

    int quad_count = ((u_char *) packet_cur - (u_char *) batch_tag) / 16;
    int data_count = quad_count - 1;
    batch_tag[0] = data_count | 0x10000000;
    batch_tag[1] = 0;
    batch_tag[2] = 0;
    batch_tag[3] = (data_count << 16) | 0x6C008000;
    batch_header[0] = sprite_num;
    batch_header[1] = mode;
    batch_header[2] = 0;
    batch_header[3] = 6;

    if (sprite_num > 0) {
        u_int *header = (u_int *) packet_cur++;
        header[0] = 0x10000002;
        header[1] = 0;
        header[2] = 0;
        header[3] = 0;

        // The first batch starts the VU program; later batches continue it.
        if (prog_started == 0) {
            *packet_cur++ = *(u_long128 *) prog_vif;
            prog_started = 1;
        } else {
            *packet_cur++ = *(u_long128 *) progf_vif;
        }

        VifQuad end = {MG_VIF_FLUSHA};
        *packet_cur++ = *(u_long128 *) &end;
    }
}

void mgC3DSprite::EndCreatePacket() {
    u_int *p;

    p = (u_int *) packet_cur;
    packet_cur += 3;
    p[0] = MG_DMA_CNT | 1;
    p[1] = 0;
    p[2] = 0;
    p[3] = 0;
    p[4] = MG_VIF_FLUSHA;
    p[5] = 0;
    p[6] = 0;
    p[7] = 0;
    p[8] = MG_DMA_RET;
    p[9] = 0;
    p[10] = 0;
    p[11] = 0;
    memory->Alloc(packet_cur - packet_start);
}

void mgCSprite::Initialize() {
    unk_00 = 0;
    draw_env = NULL;
    texture_manager = NULL;
    vu1_offset = 0;
    vu1_base = 0;
    attr.Initialize();
    texture = NULL;
    depth = -1.0f;
    SetColor(0x80, 0x80, 0x80, 0x80);
    attr.z_write = MG_ZBUF_NO_WRITE;
    attr.z_test = MG_DEPTH_TEST_ALWAYS;
}

void mgCSprite::SetColor(int r, int g, int b, int a) {
    color.bytes.red = r;
    color.bytes.green = g;
    color.bytes.blue = b;
    color.bytes.alpha = a;
    color.bytes.q = 0;
}

#pragma optimization_level 4

u_int mgCSprite::CreatePacket(mgCDrawManager *manager) {
    u_char    *cursor;
    long long *data;
    mgCMemory *packet_memory;
    u_char    *start;
    int        screen_z;
    mgCMemory *data_memory;
    packet_memory = (mgCMemory *) manager->packet_memory;
    mgCTexture *texture_entry = (mgCTexture *) texture;
    data_memory = (mgCMemory *) manager->data_memory;
    start = (u_char *) &packet_memory->stack[packet_memory->stack_used];
    cursor = start;

    if (texture_entry != NULL) {
        cursor += mgSetPkTEX0((u_int *) start, texture_entry->tex0.value,
                              *(u_long *) &texture_entry->tex1) *
                  16;
    }

    u_int tag[4];
    *(u_long128 *) tag = 0;
    tag[0] = 0x10000009;
    tag[3] = 0x50000009;
    *(u_long128 *) cursor = *(u_long128 *) tag;
    sprite_giftag.loop_flags = MG_GIFTAG_EOP | 8;
    // Drawn at depth zero unless a view depth is given and lands on the screen.
    *(u_long128 *) (cursor + 0x10) = *(u_long128 *) &sprite_giftag;
    data = (long long *) (cursor + 0x20);
    screen_z = 0;

    if (!(depth < 1.0f)) {
        float position[4] = {0.0f, 0.0f, 0.0f, 1.0f};
        int   projected[4];
        position[2] = depth;

        if (mgTransViewPrim(projected, position) != 0) {
            screen_z = projected[2];
        }
    }

    long long z = (long long) screen_z << 32;
    data[0] = 1;
    data[1] = 0x1A;
    data[2] = ((long long) (texture != 0) << 4) | 0x146;
    data[3] = 0;
    data[4] = *(long long *) &color;
    data[5] = 1;
    data[6] = uv.left | ((long long) uv.top << 16);
    data[7] = 3;
    long long corner_y = (long long) (screen.top + mgScreenOffy * 16);
    long long corner_x = (long long) (screen.left + mgScreenOffx * 16);
    data[8] = z | (corner_x | (corner_y << 16));
    data[9] = 5;
    data[10] = uv.right | ((long long) uv.bottom << 16);
    data[11] = 3;
    corner_y = (long long) (screen.bottom + mgScreenOffy * 16);
    corner_x = (long long) (screen.right + mgScreenOffx * 16);
    data[12] = z | (corner_x | (corner_y << 16));
    data[13] = 5;
    data[14] = 0;
    data[15] = 0x3F;
    u_int *end_tag = (u_int *) (data + 16);
    end_tag[0] = 0x60000000;
    end_tag[1] = 0;
    end_tag[2] = 0;
    end_tag[3] = 0;
    packet_memory->Alloc(((int) (end_tag + 4) - (int) start) / 16);
    data_memory->Alloc(0);
    return (u_int) start & 0xFFFFFFF;
}

#pragma optimization_level reset

int mgCSprite::Draw(u_int *tag, float (*matrix)[4], mgCDrawManager *manager) {
    if (manager == NULL) {
        manager = &mgDrawManager;
    }

    mgRENDER_INFO *render_info = manager->render_info;
    texture_manager = manager->texture_manager;
    mgCMemory *memory = (mgCMemory *) manager->data_memory;
    int        buffer = (int) memory->stAllocTest(0x3C);
    memory->Alloc(CreateRenderInfoPacket((u_int *) buffer, matrix, render_info));
    int render_packet = CreatePacket(manager);

    if (tag != NULL) {
        tag[0] = 0x50000000;
        tag[1] = buffer;
        tag[2] = 0;
        tag[3] = 0;
        tag[4] = 0x50000000;
        tag[5] = render_packet;
        tag[6] = 0;
        tag[7] = 0;
        return 2;
    }

    return 0;
}

// Defined in mg_sprite.hpp.
void mgCSprite::Draw(float (*matrix)[4], mgCDrawManager *manager) {
    Draw(NULL, matrix, manager);
}

// Defined in mg_visual.hpp.
int mgCVisualPrim::Iam() {
    return MG_VISUAL_KIND_PRIM;
}

// Defined in mg_sprite.hpp.
void mgC3DSprite::Draw(float (*matrix)[4], mgCDrawManager *manager) {
    Draw(NULL, matrix, manager);
}

// Defined in mg_sprite.hpp.
void mgC3DSprite::Initialize() {
    this->packet = 0;
    this->unk_00 = 0;
    this->draw_env = 0;
    this->texture_manager = 0;
    this->vu1_offset = 0;
    this->vu1_base = 0;
}
