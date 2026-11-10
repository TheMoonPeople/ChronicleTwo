#include "common.h"

#include <libvu0.h>

#include <cstdlib>
#include <vector>

#include "mg_drawprim.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "render/primitive_submission.hpp"
#include "vu0_lanes.hpp"
#include "wavetable.hpp"

CWaveTable::CWaveTable() {
    int row = {};
    int col = {};

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

void CWaveTable::GetEffect() {
    static int cnt = 0;
    int        i = {};
    int        col = {};
    int        row = {};

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

static inline float WaveAt(const float *line, int column) { return line[column]; }

void CWaveTable::Effect() {
    int    row = {};
    int    column = {};
    float *old = {};
    float *before = cells[1 - current];
    float *center = {};
    float *now = cells[current];
    for (row = 1; row < 23; row++) {
        for (column = 1; column < 23; column++) {
            center = &now[row * 24 + column];
            old = &before[row * 24 + column];
            float sum = {};
            float scaled = {};
            // Damped wave equation: the neighbour average drives the cell,
            // its own momentum carries it on, and a small term damps it.
            *old = (scaled = (sum = center[-24] + (center[24] + (center[-1] + center[1]))) *= 0.0196f) + (1.9216f * *center - *old) -
                   0.0015f * (*center - *old);
        }
    }

    // Columns 1 and 22 meet at the seam of the tiled texture, so both take
    // their average.
    for (row = 1; row < 23; row++) {
        float *line = &before[row * 24];
        line[22] = line[1] = (line[1] + WaveAt(line, 22)) * 0.5f;
    }
}

namespace {

float Intensity(float slope) {
    const float intensity = 40.0f + 540.0f * slope;

    if (!(intensity <= 200.0f)) {
        return 200.0f;
    }

    if (intensity < 0.0f) {
        return 0.0f;
    }

    return intensity;
}

void Shade(uint8_t rgba[4], float slope) {
    const auto value = static_cast<uint8_t>(vu0::Ftoi(Intensity(slope)));
    rgba[0] = value;
    rgba[1] = value;
    rgba[2] = value;
    rgba[3] = 96;
}

} // namespace

void CWaveTable::CreateTexture(mgCTexture *output_texture) {
    if (output_texture == nullptr) {
        return;
    }

    if (output_texture->bpp < 24) {
        return;
    }

    mgSetPkFrameBuffer(output_texture);
    mgCDrawPrim prim;
    prim.Initialize(nullptr, nullptr);
    prim.DepthTestEnable(0);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.Shading(1);
    prim.AlphaBlendEnable(1);

    const float cell_width = static_cast<float>(output_texture->width) / 23.0f;
    const float cell_height = static_cast<float>(output_texture->height) / 23.0f;
    const auto  origin_x = static_cast<float>(mgScreenOffx);
    const auto  origin_y = static_cast<float>(mgScreenOffy);
    prim.Begin2();

    float row_offset = 0.0f;

    for (int row = 0; row < WAVE_TABLE_DIM - 1; row++, row_offset += 1.0f) {
        const float               *line = height[current][row];
        const float               *next_line = height[current][(row + 1) % WAVE_TABLE_DIM];
        std::vector<gfx::Vertex2D> strip;
        float                      column_offset = 0.0f;

        for (int column = 0; column < WAVE_TABLE_DIM; column++, column_offset += 1.0f) {
            const int sample_column = column >= WAVE_TABLE_DIM - 1 ? 0 : column;
            const int next_column = (sample_column + 1) % WAVE_TABLE_DIM;

            const float x = origin_x + column_offset * cell_width;
            const float y = origin_y + row_offset * cell_height;
            const float bottom_y = y + cell_height;

            uint8_t top_rgba[4];
            uint8_t bottom_rgba[4];
            Shade(top_rgba, line[sample_column] - line[next_column]);
            Shade(bottom_rgba, next_line[sample_column] - next_line[next_column]);

            strip.push_back(mgPortPrimVertex(prim, x - origin_x, y - origin_y, 0.0f, 0.0f, 0.0f, top_rgba, 0));
            strip.push_back(
                mgPortPrimVertex(prim, x - origin_x, bottom_y - origin_y, 0.0f, 0.0f, 0.0f, bottom_rgba, 0));
        }

        std::vector<gfx::Vertex2D> triangles;
        mgPortStripTriangles(strip, triangles);
        mgPortPrimSubmit(prim, gfx::Primitive::Triangles, triangles);
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
