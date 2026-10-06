#include "common.h"
#include "mg_memory.hpp"
#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mg_frame.hpp"
#include "mg_drawenv.hpp"
#include "mg_math.hpp"
#include "mglib.hpp"
#include "water.hpp"
#include <cstring>
#include <cmath>
#include <cstdlib>



#ifdef NONMATCHING
/**
 * Transform, clipping and surface parameters unpacked into the water microprogram.
 */
struct WaterRenderPacket {
    u_int         dma[4];             /**< DMA count tag. */
    u_int         vif[4];             /**< Double-buffer setup and unpack codes. */
    u_long128     clear[3];           /**< Cleared microprogram parameters. */
    u_int         render_params[4];   /**< Render info parameters with the last word first. */
    sceVu0FMATRIX world_screen;       /**< Surface-to-screen transform. */
    sceVu0FMATRIX world;              /**< Surface-to-world transform. */
    u_long128     unk_e0[9];
    sceVu0FVECTOR guard_max;          /**< Upper clip bounds. */
    sceVu0FVECTOR guard_min;          /**< Lower clip bounds. */
    sceVu0FVECTOR fog;                /**< Fog coefficients. */
    sceVu0FVECTOR screen_size;        /**< Screen width and last scanline. */
    sceVu0FVECTOR screen_offset;      /**< GS screen origin. */
    sceVu0FVECTOR color;              /**< Surface colour. */
    sceVu0FVECTOR surface_params;     /**< Microprogram values and blue/alpha colour. */
    u_int         start[4];           /**< Microprogram call. */
    u_int         state_dma[4];       /**< DMA count tag for the drawing state. */
    u_int         flags[4];           /**< Microprogram drawing flags. */
    u_int         direct[4];          /**< VIF direct code. */
    u_int         giftag[4];          /**< GIF tag for the GS state writes. */
    u_int         prmode_cont[4];     /**< PRMODECONT register write. */
    u_int         prmode[4];          /**< PRMODE register write. */
    u_int         fog_color[4];       /**< FOGCOL register write. */
} __attribute__((aligned(16)));
STATIC_ASSERT(sizeof(WaterRenderPacket) == 0x260);

/**
 * Header of one grid strip, followed by its positions and slope vectors.
 */
struct WaterStripPacket {
    u_int     dma[4];       /**< DMA count tag and VIF unpack code. */
    sceGifTag giftag;        /**< Triangle-strip GIF tag. */
    u_int     counts[4];    /**< Position and slope vector counts. */
} __attribute__((aligned(16)));
STATIC_ASSERT(sizeof(WaterStripPacket) == 0x30);

/**
 * DMA control tag with space for two inline VIF codes.
 */
struct WaterDmaTag {
    u_int command;    /**< DMA command and quadword count. */
    u_int address;    /**< DMA transfer address. */
    u_int vif[2];     /**< Inline VIF codes. */
};
STATIC_ASSERT(sizeof(WaterDmaTag) == 0x10);

/**
 * Flushes the water microprogram and returns from its DMA chain.
 */
struct WaterFinishPacket {
    WaterDmaTag dma;      /**< Count tag for the flush code. */
    u_int       flush[4]; /**< VIF flush command. */
    WaterDmaTag ret;      /**< Return tag. */
};
STATIC_ASSERT(sizeof(WaterFinishPacket) == 0x30);
#endif


// Code (.text)
void CFireRaster::Step(void) {
    FireRasterParticle *free_slot = 0;
    int i = 0;
    FireRasterParticle *particle_slot;
    int offset = 0;
    int phase = 0;
    for (; i < 20; i++, offset += sizeof(FireRasterParticle), phase += 2) {
        particle_slot = (FireRasterParticle *)((u8 *)this + offset + 0x70);
        if (particle_slot->life <= 0) {
            free_slot = particle_slot;
        } else if (particle_slot->time >= particle_slot->life) {
            memset(particle_slot, 0, sizeof(FireRasterParticle));
        } else {
            particle_slot->position[1] += 1.2f;
            particle_slot->position[0] = 10.0f * sinf(3.1415927f * ((float)(particle_slot->time + phase) / 10.0f));
            particle_slot->position[2] = 10.0f * sinf(3.1415927f * ((float)(particle_slot->time + phase + 10) / 8.0f));
            particle_slot->size -= 0.1f;
            particle_slot->time++;
        }
    }
    if (free_slot != 0) {
        mgZeroVectorW((float *)free_slot);
        free_slot->size = 13.0f;
        free_slot->time = rand() % 20;
        free_slot->life = 30;
    }
}
#ifdef NONMATCHING
void CFireRaster::SetTexture(mgCTexture *texture) {
    if (texture != NULL) {
        this->texture = *texture;
        this->texture.tex0.bits.tcc = 0;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/water", SetTexture__11CFireRasterFP10mgCTexture);
#endif
#ifdef NONMATCHING
void CFireRaster::Draw(float *position, float *scale) {
    mgCDrawPrim         prim;
    FireRasterParticle *wisp;
    int                 top_left[4];
    int                 bottom_right[4];
    sceVu0FVECTOR       world_position;
    int                 uv0[2];
    int                 uv1[2];
    int                 left;
    int                 top;
    int                 right;
    int                 bottom;
    int                 index;

    prim.Initialize(NULL, NULL);
    prim.DepthTestEnable(1);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.TextureMapEnable(1);
    prim.AlphaBlendEnable(1);
    prim.AlphaBlend(MG_ALPHA_BLEND_NORMAL);
    prim.AlphaTestEnable(0);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Coord(1);
    prim.Texture(&texture);
    prim.Direct(SCE_GS_TEXA, 0x8000000080UL);
    prim.Color(0x80, 0x80, 0x80, 0x20);
    left = mgScreenOffx * 16;
    top = mgScreenOffy * 16;
    right = (mgScreenOffx + mgScreenWidth - 2) * 16;
    bottom = (mgScreenOffy + mgScreenHeight - 2) * 16;

    for (index = 0; index < 20; index++) {
        wisp = &particle[index];
        if (wisp->life > 0) {
            world_position[0] = wisp->position[0] * scale[0];
            world_position[1] = wisp->position[1] * scale[1];
            world_position[2] = wisp->position[2] * scale[2];
            // The patch dimensions scale while its centre follows the unscaled wisp offset.
            sceVu0AddVector(world_position, position, wisp->position);
            world_position[3] = 1.0f;
            if (mgTransWorldPrim3DSprite(top_left, bottom_right, world_position,
                                       wisp->size * scale[0], wisp->size * scale[1], 0) != 0) {
                if (top_left[0] < left) {
                    top_left[0] = left;
                }
                if (top_left[1] < top) {
                    top_left[1] = top;
                }
                if (bottom_right[0] < left) {
                    bottom_right[0] = left;
                }
                if (bottom_right[1] < top) {
                    bottom_right[1] = top;
                }
                if (top_left[0] > right) {
                    top_left[0] = right;
                }
                if (top_left[1] > bottom) {
                    top_left[1] = bottom;
                }
                if (bottom_right[0] > right) {
                    bottom_right[0] = right;
                }
                if (bottom_right[1] > bottom) {
                    bottom_right[1] = bottom;
                }
                uv0[0] = top_left[0] - mgScreenOffx * 16 + 0x28;
                uv0[1] = top_left[1] - mgScreenOffy * 16 + 0x28;
                uv1[0] = bottom_right[0] - mgScreenOffx * 16 - 0x28;
                uv1[1] = bottom_right[1] - mgScreenOffy * 16 - 0x28;
                if (uv0[0] < 0) {
                    uv0[0] = 0;
                }
                if (uv0[1] < 0) {
                    uv0[1] = 0;
                }
                if (uv1[0] < 0) {
                    uv1[0] = 0;
                }
                if (uv1[1] < 0) {
                    uv1[1] = 0;
                }
                if (uv0[0] > mgScreenWidth * 16) {
                    uv0[0] = mgScreenWidth * 16;
                }
                if (uv0[1] > mgScreenHeight * 16) {
                    uv0[1] = mgScreenHeight * 16;
                }
                if (uv1[0] > mgScreenWidth * 16) {
                    uv1[0] = mgScreenWidth * 16;
                }
                if (uv1[1] > mgScreenHeight * 16) {
                    uv1[1] = mgScreenHeight * 16;
                }
                prim.TextureCrd4(uv0[0], uv0[1]);
                prim.Vertex4(top_left);
                prim.TextureCrd4(uv1[0], uv1[1]);
                prim.Vertex4(bottom_right);
            }
        }
    }
    prim.End();
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/water", Draw__11CFireRasterFPfPf);
#endif
void CFireRaster::Initialize(void) {
    int index = 0;
    do {
        memset(&particle[index], 0, sizeof(particle[index]));
        index++;
    } while (index < 20);
}
void CThunderEffect::Init(void) {
    unk_00 = 0;
    unk_90 = 0;
    unk_94 = 0;
    unk_98 = 0;
}
#ifdef NONMATCHING
void CWater::Hamon() {
    float *next;
    float *current;
    float *cell;
    float  coefficient;
    float  center_coefficient;
    float  friction;
    float  old_height;
    float  new_height;
    int    row;
    int    column;
    int    index;

    if (height == height_a) {
        current = height_a;
        next = height_b;
    } else {
        current = height_b;
        next = height_a;
    }
    height = next;
    coefficient = speed * speed;
    friction = damping;
    center_coefficient = 2.0f * (1.0f - 2.0f * coefficient);
    for (row = 1; row < rows - 1; row++) {
        for (column = 1; column < columns - 1; column++) {
            index = row * columns + column;
            cell = &current[index];
            old_height = next[index];
            new_height = coefficient * (*(cell - columns) + (cell[-1] + cell[1] + cell[columns])) +
                         (center_coefficient * cell[0] - old_height);
            next[index] = new_height - friction * (new_height - old_height);
        }
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/water", Hamon__6CWaterFv);
#endif
void CWater::SetVertex(float *a, float *b) {
    mgVectorMaxMin(max, min, a, b);
}
#pragma divbyzerocheck on
void CWater::Shake(int x, int z, float amount) {
    int last_x;
    int last_z;
    float *height;

    x = x % rows;
    z = z % columns;
    if (x <= 0) {
        x = 1;
    }
    if (z <= 0) {
        z = 1;
    }
    last_x = rows - 2;
    if (x > last_x) {
        x = last_x;
    }
    last_z = columns - 2;
    if (z > last_z) {
        z = last_z;
    }
    height = &this->height[z] + x * columns;
    *height += amount;
}
#pragma divbyzerocheck reset
void CWaterFrame::Shake(float x, float z, float height_change) {
    CWater       *water;
    sceVu0FMATRIX world_matrix;
    sceVu0FMATRIX inverse_matrix;
    sceVu0FVECTOR position;
    sceVu0FVECTOR local_position;
    int           row;
    int           column;

    water = GetWater();
    position[0] = x;
    position[1] = 0.0f;
    position[2] = z;
    position[3] = 1.0f;
    GetLWMatrix(world_matrix);
    mgInversMatrix(inverse_matrix, world_matrix);
    sceVu0ApplyMatrix(local_position, inverse_matrix, position);
    x = local_position[0];
    z = local_position[2];
    if (x < water->min[0] || x > water->max[0]) {
        return;
    }
    if (z < water->min[2] || z > water->max[2]) {
        return;
    }
    row = (int)(water->rows * (x - water->min[0]) / (water->max[0] - water->min[0]));
    column = (int)(water->columns * (z - water->min[2]) / (water->max[2] - water->min[2]));
    Shake(row, column, height_change);
}
CWater *CWaterFrame::GetWater(void) {
    return (CWater *)visual;
}
void CWater::SetSize(int x, int z, mgCMemory *memory) {
    int blocks = x * z / 4 + 1;
    int i;

    height_a = (float *)memory->Alloc(blocks);
    height_b = (float *)memory->Alloc(blocks);
    rows = x;
    columns = z;
    for (i = 0; i < rows * columns; i++) {
        height_b[i] = 0.0f;
        height_a[i] = 0.0f;
    }
    height = height_a;
    unk_50 = 0;
}
void CWater::SetParam(float wave_speed, float wave_damping, float param_48, float param_4c) {
    speed = wave_speed;
    damping = wave_damping;
    unk_48 = param_48;
    unk_4c = param_4c;
}
void CWater::SetColor(u_char red, u_char green, u_char blue, u_char alpha) {
    color[0] = red;
    color[1] = green;
    color[2] = blue;
    color[3] = alpha;
}
CWater::CWater() {
    rows = 0;
    columns = 0;
    texture = NULL;
    color[0] = 128;
    color[1] = 128;
    color[2] = 128;
    color[3] = 128;
    speed = 0.1f;
    damping = 0.015f;
    unk_48 = 0;
    unk_4c = 0;
}
#ifdef NONMATCHING
int CWater::CreateRenderInfoPacket(u_int *packet, float (*matrix)[4], mgRENDER_INFO *info) {
    sceVu0IVECTOR      clear = { 0, 0, 0, 0 };
    sceVu0FMATRIX      world_screen;
    sceVu0FVECTOR      color;
    WaterRenderPacket *render;
    u_int             *end;
    mgCDrawEnv        *env;
    int                flags;
    int                fog_color;
    int                size;

    mgMulMatrix(world_screen, info->world_screen, matrix);
    render = (WaterRenderPacket *)GetScrPad();
    info->GetpLightInfo();
    render->dma[0] = MG_DMA_CNT;
    render->dma[1] = render->dma[2] = render->dma[3] = 0;
    render->vif[0] = 0;
    render->vif[1] = MG_VIF_BASE | 0x3C;
    render->vif[2] = MG_VIF_OFFSET | 0xB4;
    render->clear[0] = *(u_long128 *)clear;
    render->clear[1] = *(u_long128 *)clear;
    render->clear[2] = *(u_long128 *)clear;
    render->render_params[0] = info->unk_fb0[3];
    render->render_params[1] = info->unk_fb0[0];
    render->render_params[2] = info->unk_fb0[1];
    render->render_params[3] = info->unk_fb0[2];
    sceVu0CopyMatrix(render->world_screen, world_screen);
    sceVu0CopyMatrix(render->world, matrix);
    info->scissor = 0;
    *(u_long128 *)render->guard_max = *(u_long128 *)info->guard_max;
    *(u_long128 *)render->guard_min = *(u_long128 *)info->guard_min;
    render->guard_min[0] = render->guard_min[1] = 1.0f;
    render->guard_max[0] = render->guard_max[1] = 4095.0f;
    *(u_long128 *)render->fog = *(u_long128 *)info->fog.coef;
    render->screen_size[0] = mgScreenWidth;
    render->screen_size[1] = mgScreenHeight - 1;
    render->screen_offset[0] = mgScreenOffx;
    render->screen_offset[1] = mgScreenOffy;
    color[0] = this->color[0];
    color[1] = this->color[1];
    color[2] = this->color[2];
    color[3] = this->color[3];
    *(u_long128 *)render->color = *(u_long128 *)color;
    color[0] = unk_48;
    color[1] = unk_4c;
    *(u_long128 *)render->surface_params = *(u_long128 *)color;
    render->vif[3] = MG_VIF_UNPACK_V4_32 | (28 << MG_VIF_NUM_SHIFT);
    render->start[0] = render->start[1] = render->start[2] = 0;
    render->start[3] = MG_VIF_MSCAL;
    render->dma[0] |= 30;
    flags = 0;
    if ((info->clip | info->scissor) != 0) {
        flags |= 0x1;
    }
    if (info->scissor != 0) {
        flags |= 0x2;
    }
    if (info->attr->program_mode != 0) {
        flags |= 0x8;
    }
    if (info->attr->program_option != 0) {
        flags |= 0x4;
    }
    if (info->plight_hit != 0) {
        flags |= 0x10;
    }
    if (info->attr->no_light != 0) {
        flags |= 0x20;
    }
    render->state_dma[0] = MG_DMA_CNT | 10;
    render->state_dma[1] = render->state_dma[2] = 0;
    render->state_dma[3] = MG_VIF_UNPACK_V4_32 | (1 << MG_VIF_NUM_SHIFT) | 0x26;
    render->flags[0] = flags;
    render->flags[1] = render->flags[2] = render->flags[3] = 0;
    render->direct[0] = render->direct[1] = render->direct[2] = 0;
    render->direct[3] = MG_VIF_DIRECT | 8;
    render->giftag[0] = MG_GIFTAG_EOP | 3;
    render->giftag[1] = 1 << MG_GIFTAG_NREG_SHIFT;
    render->giftag[2] = 0xE;
    render->giftag[3] = 0;
    render->prmode_cont[0] = render->prmode_cont[1] = 0;
    render->prmode_cont[2] = MG_GS_PRMODECONT;
    render->prmode_cont[3] = 0;
    prmode = ((info->attr->fog != 0 && info->fog_enable != 0) << 5) | 0x158;
    render->prmode[0] = prmode;
    render->prmode[1] = 0;
    render->prmode[2] = SCE_GS_PRMODE;
    render->prmode[3] = 0;
    fog_color = info->fog.r | (info->fog.g << 8) | (info->fog.b << 16);
    if (info->attr->fog == 2) {
        fog_color = 0;
    } else if (info->attr->fog == 3) {
        fog_color = 0xFFFFFF;
    }
    render->fog_color[0] = fog_color;
    render->fog_color[1] = 0;
    render->fog_color[2] = SCE_GS_FOGCOL;
    render->fog_color[3] = 0;
    env = draw_env;
    if (env == NULL) {
        env = &info->draw_env[0];
    }
    end = (u_int *)(render + 1);
    end += SetDrawEnvGifTag((u_long128 *)end, info, env) * 4;
    end[0] = MG_DMA_RET;
    end[1] = end[2] = end[3] = 0;
    end += 4;
    size = (end - (u_int *)render) / 4;
    SendDMA(packet, size);
    return size;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/water", CreateRenderInfoPacket__6CWaterFPUiPA4_fP13mgRENDER_INFO);
#endif
int CWater::Draw(u_int *tag, float (*matrix)[4], mgCDrawManager *draw_manager) {
    if (draw_manager == NULL) {
        draw_manager = &mgDrawManager;
    }
    mgRENDER_INFO *render_info = draw_manager->render_info;
    texture_manager = draw_manager->texture_manager;
    mgCMemory *data_memory = (mgCMemory *)draw_manager->data_memory;
    int render_info_packet = (int)data_memory->stAllocTest(0x3C);
    data_memory->Alloc(
        CreateRenderInfoPacket((u_int *)render_info_packet, matrix, (mgRENDER_INFO *)render_info));
    int water_packet = packet;
    if (tag != NULL) {
        u_int *cursor = tag + 4;
        tag[0] = 0x50000000;
        tag[1] = render_info_packet;
        tag[2] = 0;
        tag[3] = 0;
        cursor += mgSendVuProg(cursor, MG_VU_PROG_USER);
        cursor[0] = 0x50000000;
        cursor[1] = water_packet;
        cursor[2] = 0;
        cursor[3] = 0;
        return (int)(cursor + 4 - tag) / 4;
    }
    return 0;
}
#ifdef NONMATCHING
u_int CWater::CreatePacket(mgCDrawManager *draw_manager) {
    static u_int       prog_vif[4] __attribute__((aligned(16))) = { 0, 0, 0, MG_VIF_MSCAL | 0x2 };
    static u_int       progf_vif[4] __attribute__((aligned(16))) = { 0, 0, 0, MG_VIF_MSCNT };
    sceVu0FVECTOR      slope[64][64];
    sceVu0FVECTOR      row_step;
    sceVu0FVECTOR      column_step;
    sceVu0FVECTOR      row_offset;
    sceVu0FVECTOR      position0;
    sceVu0FVECTOR      position1;
    mgCMemory         *memory;
    u_long128         *base;
    u_long128         *start;
    u_long128         *end;
    u_long128         *positions;
    sceVu0FVECTOR     *slope0;
    sceVu0FVECTOR     *slope1;
    WaterStripPacket  *strip;
    WaterDmaTag       *tag;
    WaterFinishPacket *finish;
    sceGsTexa          texa;
    float             *current;
    float             *previous;
    float              row_position;
    int                row;
    int                column;
    int                remaining;
    int                point_count;
    int                index;
    int                size;
    int                started;

    memory = draw_manager->data_memory;
    mgZeroVector(row_step);
    mgZeroVector(column_step);
    row_step[0] = (max[0] - min[0]) / (rows - 1);
    row_step[1] = row_step[2] = row_step[3] = 0.0f;
    column_step[2] = (max[2] - min[2]) / (columns - 1);
    column_step[0] = column_step[1] = column_step[3] = 0.0f;
    for (row = 0; row < rows; row++) {
        current = height + row * columns;
        previous = current - columns;
        if (row == 0) {
            previous = current;
        }
        for (column = 0; column < columns; column++) {
            slope[row][column][3] = 1.0f;
            slope[row][column][0] = previous[column] - current[column];
            slope[row][column][1] = current[column] - current[column + 1];
        }
    }
    // Fade the distortion into the fixed edges of the surface.
    for (row = 0; row < rows; row++) {
        slope[row][columns - 1][3] = 0.0f;
        slope[row][0][3] = 0.0f;
        slope[row][columns - 2][3] = 0.6f;
        slope[row][1][3] = 0.6f;
        slope[row][columns - 3][3] = 0.3f;
        slope[row][2][3] = 0.3f;
    }
    for (column = 0; column < columns; column++) {
        slope[rows - 1][column][3] = 0.0f;
        slope[0][column][3] = 0.0f;
        slope[rows - 2][column][3] = 0.6f;
        slope[1][column][3] = 0.6f;
        slope[rows - 3][column][3] = 0.3f;
        slope[2][column][3] = 0.3f;
    }
    base = memory->stack + memory->stack_used;
    start = (u_long128 *)((u_int)base | MG_UNCACHED);
    end = start;
    if (texture != NULL) {
        mgCTexture texture_copy = *texture;

        texa.AEM = 0;
        texa.TA0 = 0x80;
        texa.TA1 = 0x80;
        texture_copy.tex0.bits.psm = SCE_GS_PSMCT24;
        end += mgSetPkTEX0((u_int *)end, texture_copy.tex0.value,
                          *(u_long *)&texture_copy.tex1, *(u_long *)&texa);
    }
    started = 0;
    for (row = 0, row_position = 0.0f; row < rows - 1; row++, row_position += 1.0f) {
        slope0 = slope[row];
        slope1 = slope[row + 1];
        sceVu0ScaleVector(row_offset, row_step, row_position);
        sceVu0AddVector(position0, min, row_offset);
        position0[3] = 1.0f;
        *(u_long128 *)position1 = *(u_long128 *)position0;
        mgAddVector(position1, row_step);
        for (remaining = columns; remaining > 0; remaining -= 27) {
            point_count = 27;
            if (remaining < 27) {
                point_count = remaining;
            }
            strip = (WaterStripPacket *)end;
            *(u_long128 *)&strip->giftag = 0;
            strip->giftag.EOP = 1;
            strip->giftag.PRE = 1;
            strip->giftag.PRIM = MG_PRIM_TRIANGLE_STRIP;
            strip->giftag.NREG = 3;
            strip->giftag.REGS0 = 1;
            strip->giftag.REGS1 = 3;
            strip->giftag.REGS2 = 4;
            positions = (u_long128 *)(strip + 1);
            end = positions + point_count * 2;
            for (index = 0; index < point_count; index++) {
                *positions++ = *(u_long128 *)position0;
                *positions++ = *(u_long128 *)position1;
                *end++ = *(u_long128 *)slope0++;
                *end++ = *(u_long128 *)slope1++;
                mgAddVector(position0, column_step);
                mgAddVector(position1, column_step);
            }
            slope0--;
            slope1--;
            mgSubVector(position0, column_step);
            mgSubVector(position1, column_step);
            size = end - (u_long128 *)strip - 1;
            strip->dma[0] = MG_DMA_CNT | size;
            strip->dma[1] = strip->dma[2] = 0;
            strip->dma[3] = MG_VIF_UNPACK_V4_32 | MG_VIF_UNPACK_FLG | (size << MG_VIF_NUM_SHIFT);
            strip->counts[0] = strip->counts[1] = point_count * 2;
            strip->counts[2] = strip->counts[3] = 0;
            if (point_count > 0) {
                tag = (WaterDmaTag *)end;
                tag->command = MG_DMA_CNT | 1;
                tag->address = tag->vif[0] = tag->vif[1] = 0;
                if (started == 0) {
                    started = 1;
                    end[1] = *(u_long128 *)prog_vif;
                } else {
                    end[1] = *(u_long128 *)progf_vif;
                }
                end += 2;
            }
        }
    }
    end += mgSetPkTexFlush_TagCnt((u_int *)end);
    finish = (WaterFinishPacket *)end;
    finish->dma.command = MG_DMA_CNT | 1;
    finish->dma.address = finish->dma.vif[0] = finish->dma.vif[1] = 0;
    finish->flush[0] = MG_VIF_FLUSHA;
    finish->flush[1] = finish->flush[2] = finish->flush[3] = 0;
    finish->ret.command = MG_DMA_RET;
    finish->ret.address = finish->ret.vif[0] = finish->ret.vif[1] = 0;
    end += 3;
    memory->Alloc(end - start);
    packet = (u_int)base;
    return (u_int)base;
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/water", CreatePacket__6CWaterFP14mgCDrawManager);
#endif
void CWaterFrame::SetTexture(mgCTexture *texture) {
    CWater *surface = GetWater();
    if (surface) {
        surface->texture = texture;
    }
}
void CWaterFrame::Step(void) {
    CWater *surface = GetWater();
    if (surface == 0 || stop != 0) {
        return;
    }
    surface->Hamon();
}
void CWaterFrame::SetParam(float p0, float p1, float p2, float p3) {
    CWater *surface = GetWater();
    if (surface) {
        surface->SetParam(p0, p1, p2, p3);
    }
}
void CWaterFrame::SetColor(u_char r, u_char g, u_char b, u_char a) {
    CWater *surface = GetWater();
    if (surface) {
        surface->SetColor(r, g, b, a);
    }
}
void CWaterFrame::Shake(int x, int z, float amount) {
    CWater *surface = GetWater();
    if (surface) {
        surface->Shake(x, z, amount);
    }
}
void CWaterFrame::CreatePacket(void) {
    GetWater()->CreatePacket(&mgDrawManager);
}
extern "C" void *__vt__11CWaterFrame[];
extern "C" void __ct__8mgCFrameFv(mgCFrame *frame);
extern "C" CWater *__ct__6CWaterFv(CWater *water);

CWaterFrame *CreateWaterFrame(int rows, int columns, float *min, float *max, mgCMemory *memory) {
    CWaterFrame  *frame;
    CWater       *water;
    mgCFrameAttr *attr;

    if ((frame = (CWaterFrame *)operator new(sizeof(CWaterFrame), memory->Alloc(sizeof(CWaterFrame) / 16 + 2))) != NULL) {
        __ct__8mgCFrameFv(frame);
        *(void ***)frame = __vt__11CWaterFrame;
        frame->Initialize();
    }
    if (frame == NULL) {
        return NULL;
    }
    attr = new (memory->Alloc(sizeof(mgCFrameAttr) / 16 + 2)) mgCFrameAttr;
    frame->attr = attr;
    if (attr != NULL) {
        attr->z_write = MG_ZBUF_NO_WRITE;
        attr->z_test = MG_DEPTH_TEST_GEQUAL;
        attr->alpha_test = -1;
        attr->alpha_blend = MG_ALPHA_MACRO_BLEND;
    }
    if ((water = (CWater *)operator new(sizeof(CWater), memory->Alloc(sizeof(CWater) / 16 + 2))) != NULL) {
        water = __ct__6CWaterFv(water);
    }
    if (water == NULL) {
        return NULL;
    }
    water->SetSize(rows, columns, memory);
    water->SetVertex(min, max);
    frame->SetVisual(water);
    frame->bound = new (memory->Alloc(sizeof(mgCFrame::BoundInfo) / 16 + 2)) mgCFrame::BoundInfo;
    frame->SetBBox(max, min);
    return frame;
}
void CWaterFrame::Initialize(void) {
    unk_110 = 0;
    stop = 0;
    mgCFrame::Initialize();
}

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/water", prog_vif_351__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/water", progf_vif_352__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/water", __vt__11CWaterFrame__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/water", __vt__6CWater__DATA);

// Uninitialised data (.bss)
INCLUDE_BSS(at_287__2, 0x10);
