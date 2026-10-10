#include "common.h"

#include <libvu0.h>

#include <cstdlib>

#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "wavetable.hpp"

// Code (.text)
CWaveTable::CWaveTable() {
    int row;
    int col;

    for (row = 0; row < WAVE_TABLE_DIM; row++) {
        for (col = 0; col < WAVE_TABLE_DIM; col++) {
            height[1][row][col] = 0.0f;
            height[0][row][col] = 0.0f;
        }
    }

    current = 0;
}

CWaveTable::~CWaveTable() {
}

static inline float WaveSample(float height) { return height; }

void CWaveTable::CreateTexture(mgCTexture *output_texture) {
    if (output_texture == NULL) {
        return;
    }

    if (output_texture->bpp < 24) {
        return;
    }

    mgSetPkFrameBuffer(output_texture);
    mgCDrawPrim prim;
    prim.Initialize(NULL, NULL);
    prim.DepthTestEnable(0);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.Shading(1);
    prim.AlphaBlendEnable(1);

    float position[4];
    float cell_width = (float) output_texture->width / 23.0f;
    float cell_height = (float) output_texture->height / 23.0f;
    position[3] = 0.0f;
    position[2] = 0.0f;
    float origin_x = (float) mgScreenOffx;
    float origin_y = (float) mgScreenOffy;
    prim.Begin2();

    float row_offset = 0.0f;

    for (int row = 0; row < WAVE_TABLE_DIM - 1; row++, row_offset += 1.0f) {
        prim.BeginPrim2(4, 0x4141U, 0U, 4);
        float column_offset = 0.0f;

        for (int column = 0; column < WAVE_TABLE_DIM; column++) {
            position[0] = origin_x + column_offset * cell_width;
            position[1] = origin_y + row_offset * cell_height;
            int sample_column = column;

            if (column >= WAVE_TABLE_DIM - 1) {
                sample_column = 0;
            }

            float *line = height[0][row] + current * (WAVE_TABLE_DIM * WAVE_TABLE_DIM);
            int    next_column = (sample_column + 1) % WAVE_TABLE_DIM;
            float  intensity = line[sample_column] - WaveSample(line[next_column]);
            intensity = 40.0f + 540.0f * intensity;

            if (!(intensity <= 200.0f)) {
                intensity = 200.0f;
            }

            if (intensity < 0.0f) {
                intensity = 0.0f;
            }

            float color[4] = {0.0f, 0.0f, 0.0f, 96.0f};
            color[0] = intensity;
            color[1] = intensity;
            color[2] = intensity;
            prim.Data0(color);
            prim.Data4(position);

            float *next_line = height[0][(row + 1) % WAVE_TABLE_DIM] + current * (WAVE_TABLE_DIM * WAVE_TABLE_DIM);
            intensity = next_line[sample_column] - next_line[next_column];
            intensity = 40.0f + 540.0f * intensity;

            if (intensity < 0.0f) {
                intensity = 0.0f;
            }

            if (!(intensity <= 200.0f)) {
                intensity = 200.0f;
            }

            float next_color[4] = {0.0f, 0.0f, 0.0f, 96.0f};
            next_color[0] = intensity;
            next_color[1] = intensity;
            next_color[2] = intensity;
            position[1] += cell_height;
            prim.Data0(next_color);
            prim.Data4(position);
            column_offset += 1.0f;
        }

        prim.EndPrim2();
    }

    prim.End2();
    prim.Shading(0);
    prim.AlphaBlend(MG_ALPHA_BLEND_ADD);
    prim.Begin(MG_PRIM_SPRITE);
    prim.Color(0, 0, 0, 128);
    prim.Vertex(-1, -1, 0);
    prim.Vertex(output_texture->width + 1, output_texture->height + 1, 0);
    prim.End();
    mgSetPkFrameBuffer(-1, -1, -1, -1);
}

void CWaveTable::GetEffect() {
    static int cnt = 0;
    int        i;
    int        col;
    int        row;

    // Every fifth step drops four random disturbances onto the surface.
    if (cnt == 0) {
        for (i = 0; i < 4; i++) {
            col = rand() % 22 + 1;
            row = rand() % 22 + 1;
            height[current][row][col] += (rand() / 2147483648.0f - 0.5f) * 0.04f;
        }
    }

    cnt++;

    if (cnt > 4) {
        cnt = 0;
    }

    Effect();
    current = 1 - current;
}

#ifdef NONMATCHING
void CWaveTable::Effect() {
    int    row;
    int    column;
    float *old;
    float *before = height[1 - current][0];
    float *center;
    float *now = &height[current][0][0];
    for (row = 1; row < 23; row++) {
        for (column = 1; column < 23; column++) {
            center = &now[row * 24 + column];
            old = &before[row * 24 + column];
            float sum = center[-24] + (center[24] + (center[-1] + center[1]));
            sum *= 0.0196f;
            sum += 1.9216f * *center - *old;
            *old = sum - 0.0015f * (*center - *old);
        }
    }
    for (row = 1; row < 23; row++) {
        float *line = &before[row * 24];
        line[22] = line[1] = (line[22] + line[1]) * 0.5f;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/wavetable", Effect__10CWaveTableFv);
#endif
