#include "common.h"
#include "wavetable.hpp"
#include <cstdlib>

extern int cnt_302;
extern signed char init_303;

#include <cstdlib>
#include <libvu0.h>

#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"

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

#ifdef NONMATCHING
void CWaveTable::CreateTexture(mgCTexture *output_texture) {
    if (output_texture == NULL || output_texture->bpp < 24) {
        return;
    }

    mgSetPkFrameBuffer(output_texture);
    mgCDrawPrim prim;
    prim.Initialize(NULL, NULL);
    prim.DepthTestEnable(0);
    prim.ZMask(-1);
    prim.Shading(1);
    prim.AlphaBlendEnable(1);

    const float cell_width = static_cast<float>(output_texture->width) / 23.0f;
    const float cell_height = static_cast<float>(output_texture->height) / 23.0f;
    const float origin_x = static_cast<float>(mgScreenOffx);
    const float origin_y = static_cast<float>(mgScreenOffy);
    prim.Begin2();

    for (int row = 0; row < WAVE_TABLE_DIM - 1; ++row) {
        prim.BeginPrim2(4, 0x4141U, 0U, 4);
        for (int column = 0; column < WAVE_TABLE_DIM; ++column) {
            int sample_column = column == WAVE_TABLE_DIM - 1 ? 0 : column;
            int next_column = (sample_column + 1) % WAVE_TABLE_DIM;
            float position[4] = {origin_x + column * cell_width,
                                 origin_y + row * cell_height, 0.0f, 0.0f};
            float intensity = 40.0f + 540.0f *
                (height[current][row][sample_column] - height[current][row][next_column]);
            if (intensity > 200.0f) intensity = 200.0f;
            if (intensity < 0.0f) intensity = 0.0f;
            float color[4] = {intensity, intensity, intensity, 96.0f};
            prim.Data0(color);
            prim.Data4(position);

            int next_row = (row + 1) % WAVE_TABLE_DIM;
            intensity = 40.0f + 540.0f *
                (height[current][next_row][sample_column] - height[current][next_row][next_column]);
            if (intensity < 0.0f) intensity = 0.0f;
            if (intensity > 200.0f) intensity = 200.0f;
            float next_color[4] = {intensity, intensity, intensity, 96.0f};
            position[1] += cell_height;
            prim.Data0(next_color);
            prim.Data4(position);
        }
        prim.EndPrim2();
    }

    prim.End2();
    prim.Shading(0);
    prim.AlphaBlend(2);
    prim.Begin(6);
    prim.Color(0, 0, 0, 128);
    prim.Vertex(-1, -1, 0);
    prim.Vertex(output_texture->width + 1, output_texture->height + 1, 0);
    prim.End();
    mgSetPkFrameBuffer(-1, -1, -1, -1);
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/wavetable", CreateTexture__10CWaveTableFP10mgCTexture);
#endif

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
    const int previous = 1 - current;
    for (int row = 1; row < WAVE_TABLE_DIM - 1; ++row) {
        for (int column = 1; column < WAVE_TABLE_DIM - 1; ++column) {
            float neighbors = height[current][row - 1][column]
                            + height[current][row + 1][column]
                            + height[current][row][column - 1]
                            + height[current][row][column + 1];
            float now = height[current][row][column];
            float before = height[previous][row][column];
            height[previous][row][column] = neighbors * 0.0196f
                + (now * 1.9216f - before) - (now - before) * 0.0015f;
        }
    }
    for (int row = 1; row < WAVE_TABLE_DIM - 1; ++row) {
        float seam = (height[previous][row][1] +
                      height[previous][row][WAVE_TABLE_DIM - 2]) * 0.5f;
        height[previous][row][1] = seam;
        height[previous][row][WAVE_TABLE_DIM - 2] = seam;
    }
}
#else
INCLUDE_ASM("ps2/asm/pal/nonmatchings/wavetable", Effect__10CWaveTableFv);
#endif

// Initialised data (.data)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/wavetable", at_251__DATA);
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/wavetable", at_256__DATA);

// Virtual tables (.vtables)
INCLUDE_RODATA("ps2/asm/pal/nonmatchings/wavetable", __vt__10CWaveTable__DATA);

INCLUDE_BSS(cnt_302, 0x4);
INCLUDE_BSS(init_303, 0x4);
