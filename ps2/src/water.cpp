#include "common.h"

#include <cmath>
#include <cstdlib>
#include <cstring>

#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "water.hpp"

/**
 *
 * Transform, clipping and surface parameters unpacked into the water microprogram.
 *
 */
struct WaterRenderPacket {
    u_int         dma[4];           /**< DMA count tag. */
    u_int         vif[4];           /**< Double-buffer setup and unpack codes. */
    u_long128     clear[3];         /**< Cleared microprogram parameters. */
    u_int         render_word;
    float         render_params[3];
    sceVu0FMATRIX world_screen;     /**< Surface-to-screen transform. */
    sceVu0FMATRIX world;            /**< Surface-to-world transform. */
    u_long128     unk_e0[9];
    sceVu0FVECTOR guard_max;      /**< Upper clip bounds. */
    sceVu0FVECTOR guard_min;      /**< Lower clip bounds. */
    sceVu0FVECTOR fog;            /**< Fog coefficients. */
    sceVu0FVECTOR screen_size;    /**< Screen width and last scanline. */
    sceVu0FVECTOR screen_offset;  /**< GS screen origin. */
    sceVu0FVECTOR color;          /**< Surface colour. */
    sceVu0FVECTOR surface_params; /**< Microprogram values and blue/alpha colour. */
    u_int         start[4];       /**< Microprogram call. */
    u_int         state_dma[4];   /**< DMA count tag for the drawing state. */
    u_int         flags[4];       /**< Microprogram drawing flags. */
    u_int         direct[4];      /**< VIF direct code. */
    u_int         giftag[4];      /**< GIF tag for the GS state writes. */
    u_int         prmode_cont[4]; /**< PRMODECONT register write. */
    u_int         prmode[4];      /**< PRMODE register write. */
    u_int         fog_color[4];   /**< FOGCOL register write. */
} __attribute__((aligned(16)));

STATIC_ASSERT(sizeof(WaterRenderPacket) == 0x260);

/**
 *
 * Header of one grid strip, followed by its positions and slope vectors.
 *
 */
struct WaterStripPacket {
    u_int     dma[4];    /**< DMA count tag and VIF unpack code. */
    sceGifTag giftag;    /**< Triangle-strip GIF tag. */
    u_int     counts[4]; /**< Position and slope vector counts. */
} __attribute__((aligned(16)));

STATIC_ASSERT(sizeof(WaterStripPacket) == 0x30);

/**
 *
 * DMA control tag with space for two inline VIF codes.
 *
 */
struct WaterDmaTag {
    u_int command; /**< DMA command and quadword count. */
    u_int address; /**< DMA transfer address. */
    u_int vif[2];  /**< Inline VIF codes. */
};

STATIC_ASSERT(sizeof(WaterDmaTag) == 0x10);

/**
 *
 * Flushes the water microprogram and returns from its DMA chain.
 *
 */
struct WaterFinishPacket {
    WaterDmaTag dma;      /**< Count tag for the flush code. */
    u_int       flush[4]; /**< VIF flush command. */
    WaterDmaTag ret;      /**< Return tag. */
};

STATIC_ASSERT(sizeof(WaterFinishPacket) == 0x30);

// Code (.text)
void CFireRaster::Step(void) {
    FireRasterParticle *free_slot = 0;
    int i = 0;
    FireRasterParticle *particle_slot;
    int                 offset = 0;

    for (; i < 20; offset++, i++) {
        particle_slot = &particle[offset];

        if (particle_slot->life <= 0) {
            free_slot = particle_slot;
        } else if (particle_slot->time >= particle_slot->life) {
            memset(particle_slot, 0, sizeof(FireRasterParticle));
        } else {
            particle_slot->position[1] += 1.2f;
            particle_slot->position[0] = 10.0f * sinf(3.1415927f * ((float) (particle_slot->time + i * 2) / 10.0f));
            particle_slot->position[2] = 10.0f * sinf(3.1415927f * ((float) (particle_slot->time + i * 2 + 10) / 8.0f));
            particle_slot->size -= 0.1f;
            particle_slot->time++;
        }
    }
    if (free_slot != 0) {
        mgZeroVectorW(free_slot->position);
        free_slot->size = 13.0f;
        free_slot->time = rand() % 20;
        free_slot->life = 30;
    }
}
struct TextureFields {
    short block;
    short width;
    short height;
    short bpp;
    char name[32];
    int vram_size;
    int image_blocks;
    int clut_size;
    u_long tex0;
    u_long tex1;
    u_long clamp;
    u_long128 *image[4];
    u_long128 *clut;
    int swizzled;
    mgCTexture *next;
};
void CFireRaster::SetTexture(mgCTexture *texture) {
    if (texture != NULL) {
        *(TextureFields *)&this->texture = *(TextureFields *)texture;
        this->texture.tex0.bits.tcc = 0;
    }
}
void CFireRaster::Draw(sceVu0FVECTOR position, float *scale) {
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
void CFireRaster::Initialize() {
    int index = 0;

    do {
        memset(&particle[index], 0, sizeof(particle[index]));
        index++;
    } while (index < 20);
}

void CThunderEffect::Init() {
    unk_00 = 0;
    unk_90 = 0;
    unk_94 = 0;
    unk_98 = 0;
}
void CWater::Hamon() {
    float  coefficient;
    float  center_coefficient;
    float  friction;
    float  old_height;
    float  new_height;
    int    row;
    int    column;
    int    index;
    float *next;
    float *current;

    if (height == height_a) {
        next = height_b;
        current = height_a;
    } else {
        next = height_a;
        current = height_b;
    }
    height = next;
    coefficient = speed * speed;
    friction = damping;
    center_coefficient = 2.0f * (1.0f - 2.0f * coefficient);
    for (row = 1; row < rows - 1; row++) {
        for (column = 1; column < columns - 1; column++) {
            index = row * columns + column;
            float *cell = &current[index];
            float *out = &next[index];
            old_height = *out;
            new_height = (cell[-1] + cell[1] + cell[columns]) + *(cell - columns);
            new_height = new_height * coefficient;
            new_height += center_coefficient * cell[0] - old_height;
            *out = new_height - friction * (new_height - old_height);
        }
    }
}
void CWater::SetVertex(float *a, float *b) {
    mgVectorMaxMin(max, min, a, b);
}

void CWater::Shake(int x, int z, float amount) {
    int    last_x;
    int    last_z;
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

    row = (int) (water->rows * (x - water->min[0]) / (water->max[0] - water->min[0]));
    column = (int) (water->columns * (z - water->min[2]) / (water->max[2] - water->min[2]));
    Shake(row, column, height_change);
}

CWater *CWaterFrame::GetWater() {
    return (CWater *) visual;
}

void CWater::SetSize(int x, int z, mgCMemory *memory) {
    int blocks = x * z / 4 + 1;
    int i;

    height_a = (float *) memory->Alloc(blocks);
    height_b = (float *) memory->Alloc(blocks);
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
    surface_param0 = param_48;
    surface_param1 = param_4c;
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
    surface_param0 = 0;
    surface_param1 = 0;
}
int CWater::CreateRenderInfoPacket(u_int *packet, float (*matrix)[4], mgRENDER_INFO *info) {
    sceVu0FMATRIX      world_screen;
    sceVu0IVECTOR      clear = { 0, 0, 0, 0 };
    sceVu0FVECTOR      color;
    WaterRenderPacket *render;
    u_int             *end;
    u_int             *cursor;
    u_int             *start;
    mgCDrawEnv        *env;
    int                flags;
    int                fog_color;
    int                size;

    mgMulMatrix(world_screen, info->world_screen, matrix);
    render = (WaterRenderPacket *)(start = (u_int *)GetScrPad());
    info->GetpLightInfo();
    render->dma[0] = MG_DMA_CNT;
    render->dma[1] = 0;
    render->dma[2] = 0;
    render->dma[3] = 0;
    render->vif[0] = 0;
    render->vif[1] = MG_VIF_BASE | 0x3C;
    render->vif[2] = MG_VIF_OFFSET | 0xB4;
    render->clear[0] = *(u_long128 *)clear;
    render->clear[1] = *(u_long128 *)clear;
    render->clear[2] = *(u_long128 *)clear;
    float *render_values = (float *)info->render_params;
    render->render_word = info->render_params[3];
    render->render_params[0] = render_values[0];
    render->render_params[1] = render_values[1];
    render->render_params[2] = render_values[2];
    sceVu0CopyMatrix(render->world_screen, world_screen);
    sceVu0CopyMatrix(render->world, matrix);
    info->scissor = 0;
    cursor = (u_int *)render->screen_size;
    *(u_long128 *)render->guard_max = *(u_long128 *)info->guard_max;
    *(u_long128 *)render->guard_min = *(u_long128 *)info->guard_min;
    render->guard_min[0] = 1.0f;
    render->guard_max[0] = 4095.0f;
    render->guard_min[1] = 1.0f;
    render->guard_max[1] = 4095.0f;
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
    color[0] = surface_param0;
    color[1] = surface_param1;
    *(u_long128 *)render->surface_params = *(u_long128 *)color;
    render->vif[3] = MG_VIF_UNPACK_V4_32 | (((u_int)(cursor + 16 - render->vif) / 4 - 1) << MG_VIF_NUM_SHIFT);
    cursor[16] = 0;
    cursor[17] = 0;
    cursor[18] = 0;
    cursor[19] = MG_VIF_MSCAL;
    render->dma[0] |= (cursor + 20 - render->vif) / 4;
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
    cursor[20] = MG_DMA_CNT | 10;
    cursor[21] = 0;
    cursor[22] = 0;
    cursor[23] = MG_VIF_UNPACK_V4_32 | (1 << MG_VIF_NUM_SHIFT) | 0x26;
    cursor[24] = flags;
    cursor[25] = 0;
    cursor[26] = 0;
    cursor[27] = 0;
    cursor[28] = 0;
    cursor[29] = 0;
    cursor[30] = 0;
    cursor[31] = MG_VIF_DIRECT | 8;
    cursor[32] = MG_GIFTAG_EOP | 3;
    cursor[33] = 1 << MG_GIFTAG_NREG_SHIFT;
    cursor[34] = 0xE;
    cursor[35] = 0;
    cursor[36] = 0;
    cursor[37] = 0;
    cursor[38] = MG_GS_PRMODECONT;
    cursor[39] = 0;
    prmode = (((info->attr->fog && info->fog_enable) != 0) << 5) | 0x158;
    cursor[40] = prmode;
    cursor[41] = 0;
    cursor[42] = SCE_GS_PRMODE;
    cursor[43] = 0;
    fog_color = info->fog.r;
    fog_color |= info->fog.g << 8;
    fog_color |= info->fog.b << 16;
    if (info->attr->fog > 1) {
        if (info->attr->fog == 2) {
            fog_color = 0;
        }
        if (info->attr->fog == 3) {
            fog_color = 0xFFFFFF;
        }
    }
    cursor[44] = fog_color;
    cursor[45] = 0;
    cursor[46] = SCE_GS_FOGCOL;
    cursor[47] = 0;
    cursor += 48;
    if (draw_env != NULL) {
        env = draw_env;
    } else {
        env = &info->draw_env[0];
    }
    cursor += SetDrawEnvGifTag((u_long128 *)cursor, info, env) * 4;
    cursor[0] = MG_DMA_RET;
    cursor[1] = 0;
    cursor[2] = 0;
    cursor[3] = 0;
    size = (cursor + 4 - start) / 4;
    SendDMA(packet, size);
    return size;
}
int CWater::Draw(u_int *tag, float (*matrix)[4], mgCDrawManager *draw_manager) {
    if (draw_manager == NULL) {
        draw_manager = &mgDrawManager;
    }

    mgRENDER_INFO *render_info = draw_manager->render_info;
    texture_manager = draw_manager->texture_manager;
    mgCMemory *data_memory = (mgCMemory *) draw_manager->data_memory;
    int        render_info_packet = (int) data_memory->stAllocTest(0x3C);
    data_memory->Alloc(
        CreateRenderInfoPacket((u_int *) render_info_packet, matrix, render_info));
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
        return (int) (cursor + 4 - tag) / 4;
    }

    return 0;
}
struct WaterTextureName {
    char text[0x20];
};
struct WaterTextureImages {
    u_long128 *image[MG_TEXTURE_LEVEL_MAX];
};
struct WaterTexture {
    short       block;
    short       width;
    short       height;
    short       bpp;
    char        name[0x20];
    int         vram_size;
    int         image_blocks;
    int         clut_size;
    union {
        u_long    tex0_bits;
        sceGsTex0 tex0;
    };
    union {
        u_long    tex1_bits;
        sceGsTex1 tex1;
    };
    union {
        u_long     clamp_bits;
        sceGsClamp clamp;
    };
    u_long128  *image[MG_TEXTURE_LEVEL_MAX];
    u_long128  *clut;
    int         swizzled;
    mgCTexture *next;
};
u_int CWater::CreatePacket(mgCDrawManager *draw_manager) {
    static u_int       prog_vif[4] __attribute__((aligned(16))) = {0, 0, 0, MG_VIF_MSCAL | 0x2};
    static u_int       progf_vif[4] __attribute__((aligned(16))) = {0, 0, 0, MG_VIF_MSCNT};
    sceGsTexa          texa;
    sceVu0FVECTOR      row_step;
    sceVu0FVECTOR      column_step;
    sceVu0FVECTOR      slope[64][64];
    int                row;
    int                index;
    u_long128         *start;
    u_long128         *end;
    float              row_position;
    int                column;
    int                size;
    WaterDmaTag       *tag;
    int                point_count;
    int                started;
    mgCMemory         *memory;
    u_int              base;
    WaterFinishPacket *finish;
    u_int             *counts;
    float             *previous;
    u_long128         *positions;
    float             *current;
    sceVu0FVECTOR     *slope0;
    sceVu0FVECTOR     *slope1;
    sceVu0FVECTOR     *slope2;
    WaterStripPacket  *strip;
    u_long128         *out;
    sceVu0FVECTOR     *slope3;
    int                vertex_count;
    memory = draw_manager->data_memory;
    mgZeroVector(row_step);
    mgZeroVector(column_step);
    row_step[0] = (max[0] - min[0]) / (rows - 1);
    column_step[2] = (max[2] - min[2]) / (columns - 1);
    row_step[1] = column_step[1] = row_step[3] = column_step[3] = 0.0f;
    for (row = 0, row_position = 0.0f; row < rows; row++, row_position += 1.0f) {
        current = height + row * columns;
        previous = current - columns;
        if (row == 0) {
            previous = current;
        }
        slope0 = slope[row];
        for (column = 0; column < columns; column++) {
            (*slope0)[3] = 1.0f;
            (*slope0)[0] = *previous - *current;
            (*slope0)[1] = current[0] - current[1];
            previous++;
            current++;
            slope0++;
        }
    }
    int row_end = rows - 1;
    int column_end = columns - 1;
    for (int r = 0; r < rows; r++) {
        slope[r][column_end][3] = 0.0f;
        slope[r][0][3] = 0.0f;
        slope[r][column_end - 1][3] = 0.6f;
        slope[r][1][3] = 0.6f;
        slope[r][column_end - 2][3] = 0.3f;
        slope[r][2][3] = 0.3f;
    }
    for (int c = 0; c < columns; c++) {
        slope[row_end][c][3] = 0.0f;
        slope[0][c][3] = 0.0f;
        slope[row_end - 1][c][3] = 0.6f;
        slope[1][c][3] = 0.6f;
        slope[row_end - 2][c][3] = 0.3f;
        slope[2][c][3] = 0.3f;
    }
    base = (u_int) memory->stGetTop();
    start = (u_long128 *) (base | MG_UNCACHED);
    end = start;
    if (texture != NULL) {
        mgCTexture *source = texture;
        WaterTexture texture_copy;
        *(WaterTextureName *)texture_copy.name = *(WaterTextureName *)source->name;
        texture_copy.vram_size = source->vram_size;
        texture_copy.image_blocks = source->image_blocks;
        texture_copy.clut_size = source->clut_size;
        texture_copy.tex0_bits = source->tex0_bits;
        texture_copy.tex1_bits = source->tex1_bits;
        texture_copy.clamp_bits = source->clamp_bits;
        *(WaterTextureImages *)texture_copy.image = *(WaterTextureImages *)source->image;
        texture_copy.clut = source->clut;
        texture_copy.swizzled = source->swizzled;
        texture_copy.next = source->next;
        texture_copy.tex0.bits.psm = SCE_GS_PSMCT24;
        texa.TA0 = 0x80;
        texa.TA1 = 0x80;
        texa.AEM = 0;
        end += mgSetPkTEX0((u_int *) end, texture_copy.tex0.value,
                           *(u_long *) &texture_copy.tex1, *(u_long *) &texa);
    }
    out = end;
    started = 0;
    for (row = 0, row_position = 0.0f; row < rows - 1; row++, row_position += 1.0f) {
        sceVu0FVECTOR position0;
        sceVu0FVECTOR position1;
        sceVu0FVECTOR row_offset;
        current = height + row * columns;
        slope2 = slope[row + 1];
        slope1 = slope[row];
        sceVu0ScaleVector(row_offset, row_step, row_position);
        sceVu0AddVector(position0, min, row_offset);
        position0[3] = 1.0f;
        *(u_long128 *) position1 = *(u_long128 *) position0;
        mgAddVector(position1, row_step);
        for (column = columns; column > 0; column -= 27) {
            point_count = 27;
            if (column < 27) {
                point_count = column;
            }
            strip = (WaterStripPacket *) out;
            counts = strip->counts;
            *(u_long128 *) &strip->giftag = 0;
            strip->giftag.EOP = 1;
            strip->giftag.PRE = 1;
            strip->giftag.PRIM = MG_PRIM_TRIANGLE_STRIP;
            strip->giftag.NREG = 3;
            strip->giftag.REGS0 = 1;
            strip->giftag.REGS1 = 3;
            strip->giftag.REGS2 = 4;
            positions = (u_long128 *) (strip + 1);
            vertex_count = point_count * 2;
            int bytes = point_count * 32;
            out = (u_long128 *) (bytes + (u_int) strip) + 3;
            for (index = 0; index < point_count; index++) {
                positions[0] = *(u_long128 *) position0;
                positions[1] = *(u_long128 *) position1;
                positions += 2;
                out[0] = *(u_long128 *) slope1++;
                out[1] = *(u_long128 *) slope2++;
                out += 2;
                mgAddVector(position0, column_step);
                mgAddVector(position1, column_step);
            }
            current--;
            slope1--;
            slope2--;
            mgSubVector(position0, column_step);
            mgSubVector(position1, column_step);
            size = out - (u_long128 *) strip - 1;
            strip->dma[0] = MG_DMA_CNT | size;
            strip->dma[1] = 0;
            strip->dma[2] = 0;
            strip->dma[3] = MG_VIF_UNPACK_V4_32 | MG_VIF_UNPACK_FLG | (size << MG_VIF_NUM_SHIFT);
            counts[0] = vertex_count;
            counts[1] = vertex_count;
            counts[2] = 0;
            counts[3] = 0;
            if (point_count > 0) {
                tag = (WaterDmaTag *) out;
                tag->command = MG_DMA_CNT | 1;
                tag->address = 0;
                tag->vif[0] = 0;
                tag->vif[1] = 0;
                if (started == 0) {
                    out[1] = *(u_long128 *) prog_vif;
                    started = 1;
                    out += 2;
                } else {
                    out[1] = *(u_long128 *) progf_vif;
                    out += 2;
                }
            }
        }
    }
    out += mgSetPkTexFlush_TagCnt((u_int *) out);
    finish = (WaterFinishPacket *) out;
    finish->dma.command = MG_DMA_CNT | 1;
    finish->dma.address = 0;
    finish->dma.vif[0] = 0;
    finish->dma.vif[1] = 0;
    finish->flush[0] = MG_VIF_FLUSHA;
    finish->flush[1] = 0;
    finish->flush[2] = 0;
    finish->flush[3] = 0;
    finish->ret.command = MG_DMA_RET;
    finish->ret.address = 0;
    finish->ret.vif[0] = 0;
    finish->ret.vif[1] = 0;
    out += 3;
    memory->Alloc(out - start);
    packet = base;
    return base;
}
void CWaterFrame::SetTexture(mgCTexture *texture) {
    CWater *surface = GetWater();

    if (surface) {
        surface->texture = texture;
    }
}

void CWaterFrame::Step() {
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

void CWaterFrame::CreatePacket() {
    GetWater()->CreatePacket(&mgDrawManager);
}


#ifdef NONMATCHING
CWaterFrame *CreateWaterFrame(int rows, int columns, float *min, float *max, mgCMemory *memory) {
    CWaterFrame  *frame;
    CWater       *water;
    mgCFrameAttr *attr;

    frame = new (memory->Alloc(sizeof(CWaterFrame) / 16 + 2)) CWaterFrame;

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

    water = new (memory->Alloc(sizeof(CWater) / 16 + 2)) CWater;

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
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/water", CreateWaterFrame__FiiPfPfP9mgCMemory);
#endif

void CWaterFrame::Initialize() {
    unk_110 = 0;
    stop = 0;
    mgCFrame::Initialize();
}
