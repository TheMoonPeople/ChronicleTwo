#pragma once

#include <cstdint>
#include <span>
#include <vector>

#include "vu1/vu1_math.hpp"
#include "vu1/water_geom.hpp"

namespace dc::vu1 {

struct WaterParams {
    Mat4  r;         // WS rows R0..R3 (clip = px*R0 + py*P0*R1 + pz*R2 + R3)
    float p0;        // surface_param0: y scale
    float p1;        // surface_param1: slope scale on UV
    float ox;        // 2048 - W/2
    float oy;        // 2048 - H/2
    float width;     // W
    float height;    // H; the UV clamp uses H - 1
    Vec4  guard_min; // .xy X/Y lower guard, .w near (not tested, see WaterTransform)
    Vec4  guard_max; // .xy X/Y upper guard, .w far
    Fog   fog;
    bool  fog_enabled; // renderer-side only; the fog word is always computed
    Vec4  colour;      // r, g, b, a in 0..255
};

struct WaterVertex {
    int32_t  r, g, b, a;
    int32_t  u, v;
    uint16_t x, y;
    uint32_t z;
    uint8_t  f;
    bool     adc;
    uint32_t pass_bits; // F_j: 0x80 X, 0x40 Y, 0x10 W
};

// prev_pass0 = F_{j-2}, prev_pass1 = F_{j-1}; both are 0xD0 for a passing neighbour.
WaterVertex WaterTransform(const WaterParams &params, Vec4 pos, Vec4 slope,
                           uint32_t prev_pass0, uint32_t prev_pass1);

// The strip carries two pass words across batches; carry0/carry1 are F of the two vertices before strip[0].
std::vector<WaterVertex> WaterStripTransform(const WaterParams                &params,
                                             std::span<const WaterStripVertex> strip,
                                             uint32_t carry0, uint32_t carry1);

// kicked[j] for j >= 2 is set when triangle (j-2, j-1, j) is emitted. kicked[0] and kicked[1] are always false.
std::vector<bool> WaterKicks(std::span<const WaterVertex> strip);

struct WaterRenderState {
    uint32_t prmode;
    uint32_t psm;
    uint32_t ta0;
    uint32_t ta1;
    bool     aem;
};

// Description of the GS state the renderer must reproduce, not a register writer.
WaterRenderState WaterState(bool fog);

} // namespace dc::vu1
