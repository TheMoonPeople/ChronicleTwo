#pragma once

#include <cstdint>
#include <span>
#include <vector>

#include "vu1/vu1_math.hpp"

namespace dc::vu1 {

struct WaterMeshDesc {
    Vec4 min;
    Vec4 max;
    int  rows;
    int  columns;
};

struct WaterStripVertex {
    Vec4 pos;
    Vec4 slope; // x, y: height differences; z: unused (stale on retail); w: edge weight
};

// One two-row triangle strip per row pair; each strip holds 2 * columns vertices, j = 2c + r.
using WaterMesh = std::vector<std::vector<WaterStripVertex>>;

// height is row-major, rows * columns entries.
WaterMesh BuildWaterMesh(const WaterMeshDesc &desc, std::span<const float> height);
// Reuses strip storage when rebuilding a water grid.
void BuildWaterMesh(const WaterMeshDesc &desc, std::span<const float> height, WaterMesh &mesh);

struct WaterSurface {
    float p0;
    float p1;
    float colour[4]; // 0..255 GS bytes
};

// position is object space with y already scaled by p0; uv_offset is the refraction shift in logical
// pixels; color is the GS vertex colour byte.
struct WaterHostVertex {
    float   position[3];
    float   uv_offset[2];
    uint8_t color[4];
};

void WaterHostMesh(const WaterSurface &surface, const Mat4 &model_to_eye, const WaterMesh &mesh,
                   std::vector<WaterHostVertex> &vertices, std::vector<uint32_t> &indices);

} // namespace dc::vu1
