#include "common.h"

#include <algorithm>
#include <array>
#include <cmath>
#include <cstdio>
#include <limits>
#include <optional>
#include <span>

#include "log/game_output.hpp"
#include "mg_drawenv.hpp"
#include "mg_drawprim.hpp"
#include "mg_frame.hpp"
#include "mg_math.hpp"
#include "mg_memory.hpp"
#include "mg_texture.hpp"
#include "mglib.hpp"
#include "swordeffect.hpp"

namespace {
/**
 * Four separately constructed vector arrays that hold one trail's rings and curves.
 */
struct TrailStorage {
    sceVu0FVECTOR *point0;
    sceVu0FVECTOR *point1;
    sceVu0FVECTOR *smooth0;
    sceVu0FVECTOR *smooth1;
    std::size_t    smooth_count;
};

/**
 * Reserves all four native arrays only when their complete byte extent fits the live arena.
 */
std::optional<TrailStorage> AllocateTrail(mgCMemory *memory, int capacity, int subdivisions) {
    if (memory == nullptr || memory->lock != 0 || capacity <= 0 || subdivisions < 2 ||
        subdivisions > std::numeric_limits<int>::max() - 2) {
        return std::nullopt;
    }
    const auto count = static_cast<std::size_t>(capacity);
    const auto factor = static_cast<std::size_t>(subdivisions) + 2;
    if (count > static_cast<std::size_t>(std::numeric_limits<int>::max()) / factor) {
        return std::nullopt;
    }
    const auto smooth_count = count * factor;
    const auto points = dc2::memory::ArrayQuadwords<sceVu0FVECTOR>(count);
    const auto smooth = dc2::memory::ArrayQuadwords<sceVu0FVECTOR>(smooth_count);
    if (!points || !smooth || 2 * (static_cast<std::size_t>(*points) + static_cast<std::size_t>(*smooth)) >= dc2::memory::RemainingBytes(*memory).size() / sizeof(u_long128)) {
        return std::nullopt;
    }
    TrailStorage result{
        dc2::memory::NewArray<sceVu0FVECTOR>(*memory, count),
        dc2::memory::NewArray<sceVu0FVECTOR>(*memory, count),
        dc2::memory::NewArray<sceVu0FVECTOR>(*memory, smooth_count),
        dc2::memory::NewArray<sceVu0FVECTOR>(*memory, smooth_count), smooth_count};
    if (!result.point0 || !result.point1 || !result.smooth0 || !result.smooth1) {
        return std::nullopt;
    }
    return result;
}
} // namespace

int CreatSmoothPassSW(std::span<sceVu0FVECTOR> out, std::span<const sceVu0FVECTOR> ring,
                      int point_num, int division, int start) {
    if (point_num < 3 || division < 2 || start < 0 || ring.empty() ||
        ring.size() > static_cast<std::size_t>(std::numeric_limits<int>::max()) ||
        static_cast<std::size_t>(point_num) > ring.size() || static_cast<std::size_t>(start) >= ring.size() ||
        static_cast<std::size_t>(point_num - 1) > out.size() / static_cast<std::size_t>(division)) {
        return 0;
    }
    const int     ring_size = static_cast<int>(ring.size());
    sceVu0FMATRIX coefficients;
    sceVu0FMATRIX points;
    sceVu0FMATRIX basis;
    float         powers[4];
    float         result[4];
    int           control[4];

    if (point_num < 3) {
        return 0;
    }

    float quarter = 0.25f;
    float half = {};
    half = 0.5f;
    basis[3][0] = 0.0f;
    basis[1][0] = 1.0f;
    basis[2][1] = 0.0f;
    basis[0][0] = -quarter / half;
    basis[0][1] = 1.5f;
    basis[2][0] = basis[0][0];
    basis[1][1] = -(quarter + 1.0f) / half;
    basis[3][1] = 1.0f;
    basis[3][2] = 0.0f;
    basis[0][2] = (-half - quarter) / half;
    basis[2][2] = half;
    basis[1][2] = 2.0f;
    basis[0][3] = half;
    basis[1][3] = -basis[0][3];
    basis[2][3] = 0.0f;
    basis[3][3] = 0.0f;
    int written = 0;

    for (int segment = 0; segment < point_num - 1; segment++) {
        if (segment > 0 && segment < point_num - 2) {
            control[0] = segment - 1;
            control[1] = segment;
            control[2] = segment + 1;
            control[3] = segment + 2;
        } else {
            if (segment <= 0) {
                control[0] = 0;
                control[1] = 0;
                control[2] = 1;
                control[3] = 2;
            }

            if (segment >= point_num - 2) {
                control[0] = segment - 1;
                control[1] = segment;
                control[2] = segment + 1;
                control[3] = segment + 1;
            }
        }

        for (int row = 0; row < 4; row++) {
            const auto offset = static_cast<long long>(control[row]) + start;
            control[row] = static_cast<int>((offset + ring_size) % ring_size);
        }

        const float *p0 = ring[static_cast<std::size_t>(control[0])];
        const float *p1 = ring[static_cast<std::size_t>(control[1])];
        const float *p2 = ring[static_cast<std::size_t>(control[2])];
        const float *p3 = ring[static_cast<std::size_t>(control[3])];
        points[0][0] = p0[0];
        points[0][1] = p0[1];
        points[0][2] = p0[2];
        points[0][3] = 0.0f;
        points[1][0] = p1[0];
        points[1][1] = p1[1];
        points[1][2] = p1[2];
        points[1][3] = 0.0f;
        points[2][0] = p2[0];
        points[2][1] = p2[1];
        points[2][2] = p2[2];
        points[2][3] = 0.0f;
        points[3][0] = p3[0];
        points[3][1] = p3[1];
        points[3][2] = p3[2];
        points[3][3] = 0.0f;
        sceVu0MulMatrix(coefficients, points, basis);
        float t = 0.0f;
        float step = {};

        while (t < 1.0f - (step = 1.0f / (division - 1.0f))) {
            powers[0] = t * (t * t);
            powers[3] = 1.0f;
            powers[1] = t * t;
            powers[2] = t;
            sceVu0ApplyMatrix(result, coefficients, powers);

            if (static_cast<std::size_t>(written) >= out.size()) {
                return 0;
            }
            for (int j = 0; j < 3; j++) {
                out[static_cast<std::size_t>(written)][j] = result[j];
            }

            out[static_cast<std::size_t>(written)][3] = 1.0f;
            t += step;
            written++;
        }
    }

    return written;
}

void CSWordAfterEffect::Draw() {
    if (!active) {
        return;
    }

    if (point_num <= 0) {
        return;
    }

    int   projected[4];
    float alpha_step = {};
    float opacity = alpha;
    if (length < 0 || smooth_num <= 0 || !smooth0 || !smooth1 || !std::isfinite(opacity) || opacity <= 0.0f || opacity > 1.0f) {
        return;
    }
    const double requested = static_cast<double>(length) * opacity;
    int          count = requested >= smooth_num ? smooth_num : static_cast<int>(requested);

    if (count <= 0) {
        return;
    }

    alpha_step = opacity / static_cast<float>(count);
    mgCDrawPrim        prim;
    mgCTextureManager *textures = &mgTexManager;

    if (texture != nullptr) {
        textures->ReloadTexture(tex_block, (sceVif1Packet *) nullptr);
    }

    prim.Initialize(nullptr, nullptr);
    prim.AlphaBlendEnable(1);
    prim.AlphaBlend(MG_ALPHA_BLEND_ADD);
    prim.AlphaTestEnable(1);
    prim.AlphaTest(1, 0);
    prim.ZMask(MG_Z_MASK_MASKED);
    prim.Bilinear(1);

    if (texture != nullptr) {
        prim.TextureMapEnable(1);
    } else {
        prim.TextureMapEnable(0);
    }

    prim.Coord(1);
    prim.Shading(1);
    prim.DepthTestEnable(1);
    prim.DepthTest(MG_DEPTH_TEST_GEQUAL);
    prim.Begin(MG_PRIM_TRIANGLE_STRIP);

    if (texture != nullptr) {
        prim.Texture(texture);
    }

    float u = static_cast<float>(tex_u);
    float u_step = static_cast<float>(tex_w) / static_cast<float>(count);

    if (texture == nullptr) {
        for (int point = 0; point < count; ++point) {
            if (mgTransWorldPrim(projected, smooth0[point])) {
                prim.Color(color0[0], color0[1], color0[2], static_cast<int>(static_cast<double>(color0[3]) * opacity));
                prim.Vertex4(projected);
            }

            if (mgTransWorldPrim(projected, smooth1[point])) {
                prim.Color(color1[0], color1[1], color1[2], static_cast<int>(static_cast<double>(color1[3]) * opacity));
                prim.Vertex4(projected);
            }

            opacity -= alpha_step;
        }
    } else {
        int texel_u = {};

        for (int point = 0; point < count; ++point) {
            texel_u = static_cast<int>(std::clamp(static_cast<double>(u), static_cast<double>(std::numeric_limits<int>::min()), static_cast<double>(std::numeric_limits<int>::max())));

            if (mgTransWorldPrim(projected, smooth0[point])) {
                prim.Color(color0[0], color0[1], color0[2], static_cast<int>(static_cast<double>(color0[3]) * opacity));
                prim.TextureCrd(texel_u, tex_v);
                prim.Vertex4(projected);
            }

            if (mgTransWorldPrim(projected, smooth1[point])) {
                prim.Color(color0[0], color0[1], color0[2], static_cast<int>(static_cast<double>(color0[3]) * opacity));
                prim.TextureCrd(texel_u, static_cast<int>(std::clamp(static_cast<long long>(tex_v) + tex_h, static_cast<long long>(std::numeric_limits<int>::min()), static_cast<long long>(std::numeric_limits<int>::max()))));
                prim.Vertex4(projected);
            }

            u += u_step;
            opacity -= alpha_step;
        }
    }

    prim.End();
}

void CSWordAfterEffect::CreatPointList() {
    if (active != 0 && point_num > 0 && point_max > 0 && division >= 2 &&
        division <= std::numeric_limits<int>::max() - 2 && point0 && point1 && smooth0 && smooth1) {
        const auto count = static_cast<std::size_t>(point_max);
        const auto factor = static_cast<std::size_t>(division) + 2;
        if (count > static_cast<std::size_t>(std::numeric_limits<int>::max()) / factor) {
            smooth_num = 0;
            return;
        }
        smooth_num = CreatSmoothPassSW({smooth0, count * factor}, {point0, count}, point_num, division, head_index);
        CreatSmoothPassSW({smooth1, count * factor}, {point1, count}, point_num, division, head_index);
    }
}

void CSWordAfterEffect::SetTexture(int tex_no, mgCTexture *tex, int u0, int v0, int u1, int v1) {
    tex_block = tex_no;
    texture = tex;
    tex_u = u0;
    tex_v = v0;
    tex_w = u1;
    tex_h = v1;
    color0[0] = color0[1] = color0[2] = color0[3] = 0x80;
    color1[0] = color1[1] = color1[2] = color1[3] = 0x80;
}

void CSWordAfterEffect::SetTexture(int u, int v, int w, int h) {
    tex_u = u;
    tex_v = v;
    tex_w = w;
    tex_h = h;
}

void CSWordAfterEffect::StartEffect(mgCFrame *start, mgCFrame *end, int length, int frames,
                                    int hold_time) {
    if (length < 0 || frames <= 0 || hold_time < 0) {
        Clear();
        return;
    }
    frame0 = start;
    frame1 = end;
    this->length = length;
    this->hold_time = hold_time;
    active = 1;
    alpha = 1.0f;
    fade_speed = 1.0f / static_cast<float>(frames);
    smooth_num = 0;
    point_num = 0;
    write_index = point_max - 1;
    head_index = point_max - 1;
    dc2::log::PrintGame("start !!\n");
}

void CSWordAfterEffect::AddPoint(float *first, float *second) {
    if (!first || !second || !point0 || !point1 || point_max <= 0 || write_index < 0 || write_index >= point_max) {
        return;
    }
    sceVu0CopyVector(point0[write_index], first);
    sceVu0CopyVector(point1[write_index], second);
    head_index = write_index;

    if (point_num < point_max) {
        ++point_num;
    }

    --write_index;

    if (write_index < 0) {
        write_index = point_max - 1;
    }
}

void CSWordAfterEffect::Step() {
    float edge_a[4];
    float edge_b[4];

    if (active == 0) {
        return;
    }

    if (frame0 == nullptr || frame1 == nullptr) {
        return;
    }

    frame0->GetWorldPosition0(edge_a);
    frame1->GetWorldPosition0(edge_b);
    AddPoint(edge_a, edge_b);

    if (hold_time > 0) {
        hold_time--;
        return;
    }

    alpha -= fade_speed;

    if (alpha <= 0.0f) {
        active = 0;
    }
}

void CSWordAfterEffect::Clear() {
    active = 0;
    frame1 = nullptr;
    frame0 = nullptr;
}

void CSWordAfterEffect::Initialize(mgCMemory *memory, int capacity, int subdivisions) {
    *this = CSWordAfterEffect{};
    const auto storage = AllocateTrail(memory, capacity, subdivisions);
    if (!storage) {
        return;
    }
    point0 = storage->point0;
    point1 = storage->point1;
    smooth0 = storage->smooth0;
    smooth1 = storage->smooth1;
    color0[0] = 0x60;
    color0[1] = 0x40;
    color0[2] = 0x30;
    color1[0] = 0x40;
    color1[1] = 0x30;
    color1[2] = 0x20;
    color1[3] = 0x40;
    point_max = capacity;
    division = subdivisions;
    head_index = write_index = capacity - 1;
    length = 0x20;
}

void CSWordAfterEffect::Copy(CSWordAfterEffect &dst, mgCMemory *memory) {
    CSWordAfterEffect copy = *this;
    if (memory == nullptr) {
        dst = copy;
        return;
    }
    if (point_num < 0 || point_num > point_max || smooth_num < 0 ||
        (point_num > 0 && (!point0 || !point1 || head_index < 0 || head_index >= point_max)) ||
        (smooth_num > 0 && (!smooth0 || !smooth1)) || point_max <= 0 || division < 2 ||
        division > std::numeric_limits<int>::max() - 2 ||
        static_cast<std::size_t>(point_max) > static_cast<std::size_t>(std::numeric_limits<int>::max()) / (static_cast<std::size_t>(division) + 2) ||
        static_cast<std::size_t>(smooth_num) > static_cast<std::size_t>(point_max) * (static_cast<std::size_t>(division) + 2)) {
        dst = CSWordAfterEffect{};
        return;
    }
    const auto storage = AllocateTrail(memory, point_max, division);
    if (!storage) {
        dst = CSWordAfterEffect{};
        return;
    }
    for (int index = 0; index < point_num; ++index) {
        const auto slot = static_cast<std::size_t>((static_cast<long long>(head_index) + index) % point_max);
        std::copy_n(point0[slot], 4, storage->point0[slot]);
        std::copy_n(point1[slot], 4, storage->point1[slot]);
    }
    for (int index = 0; index < smooth_num; ++index) {
        std::copy_n(smooth0[index], 4, storage->smooth0[index]);
        std::copy_n(smooth1[index], 4, storage->smooth1[index]);
    }
    copy.point0 = storage->point0;
    copy.point1 = storage->point1;
    copy.smooth0 = storage->smooth0;
    copy.smooth1 = storage->smooth1;
    dst = copy;
}
