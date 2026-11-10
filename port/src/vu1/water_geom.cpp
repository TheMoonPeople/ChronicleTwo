#include "vu1/water_geom.hpp"

#include <algorithm>
#include <cstddef>
#include <utility>

namespace dc::vu1 {
namespace {

// Retail's stencil writes out of bounds for tiny grids; out-of-range taps are dropped here.
void ApplyEdgeWeights(std::vector<float> &weight, int rows, int columns) {
    const auto set = [&](int r, int c, float value) {
        if (r >= 0 && r < rows && c >= 0 && c < columns) {
            weight[static_cast<std::size_t>(r * columns + c)] = value;
        }
    };

    for (int r = 0; r < rows; ++r) {
        set(r, columns - 1, 0.0f);
        set(r, 0, 0.0f);
        set(r, columns - 2, 0.6f);
        set(r, 1, 0.6f);
        set(r, columns - 3, 0.3f);
        set(r, 2, 0.3f);
    }
    // Row edges overwrite the column stencil for the whole row.
    for (int c = 0; c < columns; ++c) {
        set(rows - 1, c, 0.0f);
        set(0, c, 0.0f);
        set(rows - 2, c, 0.6f);
        set(1, c, 0.6f);
        set(rows - 3, c, 0.3f);
        set(2, c, 0.3f);
    }
}

uint8_t ToByte(float x) {
    if (!(x > 0.0f)) {
        return 0;
    }
    if (x >= 255.0f) {
        return 255;
    }
    return static_cast<uint8_t>(x);
}

} // namespace

WaterMesh BuildWaterMesh(const WaterMeshDesc &desc, std::span<const float> height) {
    WaterMesh mesh;
    BuildWaterMesh(desc, height, mesh);
    return mesh;
}

void BuildWaterMesh(const WaterMeshDesc &desc, std::span<const float> height, WaterMesh &mesh) {
    const int rows = desc.rows;
    const int columns = desc.columns;
    if (rows < 2 || columns < 2 || height.size() < static_cast<std::size_t>(rows) * static_cast<std::size_t>(columns)) {
        mesh.clear();
        return;
    }
    const auto                             count = static_cast<std::size_t>(rows) * static_cast<std::size_t>(columns);
    static thread_local std::vector<float> weight;
    weight.assign(count, 1.0f);
    ApplyEdgeWeights(weight, rows, columns);

    const float dx = (desc.max.x - desc.min.x) / static_cast<float>(rows - 1);
    const float dz = (desc.max.z - desc.min.z) / static_cast<float>(columns - 1);

    mesh.resize(static_cast<std::size_t>(rows - 1));
    for (int row = 0; row + 1 < rows; ++row) {
        auto &strip = mesh[row];
        strip.clear();
        strip.reserve(static_cast<std::size_t>(2 * columns));

        // Retail steps columns by 27 but pointers by 26, dropping columns for N >= 28; every column is emitted.
        for (int c = 0; c < columns; ++c) {
            for (int r = 0; r < 2; ++r) {
                const int  i = row + r;
                const auto cell = static_cast<std::size_t>(i * columns + c);

                float slope_x = 0.0f;
                if (i > 0) {
                    slope_x = height[cell - static_cast<std::size_t>(columns)] - height[cell];
                }

                // At the last column retail reads h[i][c+1], which is h[i+1][0], or past the array on the
                // last row; that case uses 0.
                float             slope_y = 0.0f;
                const std::size_t next = cell + 1;
                if (std::cmp_less(next, count)) {
                    slope_y = height[cell] - height[next];
                }

                WaterStripVertex v{};
                v.pos = {.x = desc.min.x + static_cast<float>(i) * dx,
                         .y = desc.min.y,
                         .z = desc.min.z + static_cast<float>(c) * dz,
                         .w = 1.0f};
                // slope[2] is stale on retail; no output word depends on it.
                v.slope = {.x = slope_x, .y = slope_y, .z = 0.0f, .w = weight[cell]};
                strip.push_back(v);
            }
        }
    }
}

void WaterHostMesh(const WaterSurface &surface, const Mat4 &model_to_eye, const WaterMesh &mesh,
                   std::vector<WaterHostVertex> &vertices, std::vector<uint32_t> &indices) {
    constexpr float kFadeScale = 375.0f;
    constexpr float kFadeBias = -0.25f;

    vertices.clear();
    indices.clear();

    for (const std::vector<WaterStripVertex> &strip : mesh) {
        const auto base = static_cast<uint32_t>(vertices.size());

        for (const WaterStripVertex &v : strip) {
            const Vec4 object{.x = v.pos.x, .y = v.pos.y * surface.p0, .z = v.pos.z, .w = 1.0f};
            // Retail's clip w is the eye depth (mgPortEyeToClip: w = z_eye), so q = 1 / w is 1 / eye_z.
            const float eye_z = Mul(model_to_eye, object).z;
            const float fade = eye_z > 0.0f ? std::clamp(kFadeScale / eye_z + kFadeBias, 0.0f, 1.0f) : 0.0f;
            const float alpha = surface.colour[3] * v.slope.w * fade;

            WaterHostVertex out{};
            out.position[0] = object.x;
            out.position[1] = object.y;
            out.position[2] = object.z;
            out.uv_offset[0] = v.slope.x * surface.p1;
            out.uv_offset[1] = v.slope.y * surface.p1;
            out.color[0] = ToByte(surface.colour[0]);
            out.color[1] = ToByte(surface.colour[1]);
            out.color[2] = ToByte(surface.colour[2]);
            out.color[3] = ToByte(alpha);
            vertices.push_back(out);
        }

        for (std::size_t j = 2; j < strip.size(); ++j) {
            indices.push_back(base + static_cast<uint32_t>(j - 2));
            indices.push_back(base + static_cast<uint32_t>(j - 1));
            indices.push_back(base + static_cast<uint32_t>(j));
        }
    }
}

} // namespace dc::vu1
