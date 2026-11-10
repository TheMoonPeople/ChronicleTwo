#pragma once

// Test-only reproduction of Vu_prog_3dsp's GS integer outputs (docs/vu1/prog_3dsp.md sections 5-7).
// Not linked into the game: the runtime path is vu1::Sprite3dExpandNative.

#include <algorithm>
#include <cstdint>
#include <limits>

#include "vu1/sprite3d_geom.hpp"
#include "vu1/vu1_math.hpp"
#include "vu1_oracle/vu1_pack.hpp"

namespace dc::vu1::sprite3d_oracle {

inline constexpr uint32_t kPrimSprite = 0x5E;
inline constexpr uint32_t kPrimStrip = 0x5C;

struct Vertex {
    Vec4     screen; // x, y, z, F (fog without the ADC bias)
    uint16_t x, y;   // low 16 bits of Ftoi4(x), Ftoi4(y)
    uint32_t z;      // 24-bit Z field
    uint8_t  f;      // fog byte, bits 11..4 of the w word
    uint16_t w;      // bits 11..4 = F, bit 15 = ADC, bits 3..0 = fraction
    bool     adc;
    int32_t  u, v; // Ftoi4 of the UV
};

struct Quad {
    int     vertex_count; // 2 (mode 0: min, max) or 4 (strip v0..v3)
    Vertex  v[4];
    int32_t rgba[4]; // low 8 bits of each colour component
    bool    drawn;
};

inline float ReciprocalW(float w) {
    return w != 0.0f ? 1.0f / w : std::numeric_limits<float>::max();
}

inline int32_t ColourByte(float x) {
    int32_t i = Ftoi0(x);
    i = std::clamp(i, -32768, 32767);
    return static_cast<int32_t>(static_cast<uint32_t>(i) & 0xFFu);
}

// Z is trunc(16 z) >> 4: the GS Z field is the integer part of the projected depth.
inline Vertex Pack(Vec4 screen, int32_t u, int32_t v, bool adc) {
    constexpr float kAdcBias = 2048.0f;
    Vertex          out{};
    out.screen = screen;
    out.x = static_cast<uint16_t>(Ftoi4(screen.x) & 0xFFFF);
    out.y = static_cast<uint16_t>(Ftoi4(screen.y) & 0xFFFF);
    out.z = (static_cast<uint32_t>(Ftoi4(screen.z)) >> 4) & 0xFFFFFFu;
    out.f = static_cast<uint8_t>((static_cast<uint32_t>(Ftoi4(screen.w)) >> 4) & 0xFFu);
    out.w = static_cast<uint16_t>(Ftoi4(adc ? screen.w + kAdcBias : screen.w) & 0xFFFF);
    out.adc = adc;
    out.u = u;
    out.v = v;
    return out;
}

// Strict inequalities on x, y and the 1/Pw window; NaN fails every test.
inline bool Passes(const Sprite3dParams &p, float min_x, float min_y, float max_x, float max_y, float q) {
    return min_x > p.guard_min.x && min_y > p.guard_min.y && max_x < p.guard_max.x &&
           max_y < p.guard_max.y && q > 1.0f / p.guard_max.w && q < 1.0f / p.guard_min.w;
}

inline uint32_t Tag(int count) {
    return 0x8000u | static_cast<uint32_t>(count);
}

inline Quad Expand(const Sprite3dParams &p, const Sprite3dRecord &r, int mode) {
    const Vec4  pclip = Mul(p.ls, r.pos);
    const float q = ReciprocalW(pclip.w);
    const Vec4  c{.x = pclip.x * q, .y = pclip.y * q, .z = pclip.z * q, .w = q};

    const int32_t u0x = Ftoi4(r.uv0.x);
    const int32_t u0y = Ftoi4(r.uv0.y);
    const int32_t u1x = Ftoi4(r.uv1.x);
    const int32_t u1y = Ftoi4(r.uv1.y);

    const float fog = FogValue(p.fog, q);

    Quad out{};
    out.rgba[0] = ColourByte(r.colour.x);
    out.rgba[1] = ColourByte(r.colour.y);
    out.rgba[2] = ColourByte(r.colour.z);
    out.rgba[3] = ColourByte(r.colour.w);

    if (mode == 0) {
        const float hqx = (r.size.x * p.vs0.x) * 0.5f * q;
        const float hqy = (r.size.y * p.vs1.y) * 0.5f * q;
        const Vec4  min{.x = c.x - hqx, .y = c.y - hqy, .z = c.z, .w = fog};
        const Vec4  max{.x = c.x + hqx, .y = c.y + hqy, .z = c.z, .w = fog};

        out.drawn = Passes(p, min.x, min.y, max.x, max.y, q);
        const bool adc = !out.drawn;

        out.vertex_count = 2;
        out.v[0] = Pack(min, u0x, u0y, adc);
        out.v[1] = Pack(max, u1x, u1y, adc);
        return out;
    }

    const Vec4 a = Vec4{.x = r.size.w, .y = r.size.z, .z = 0.0f, .w = 0.0f} * p.vs0.x * (r.size.x * 0.5f) * q;
    const Vec4 b = Vec4{.x = -r.size.z, .y = r.size.w, .z = 0.0f, .w = 0.0f} * p.vs1.y * (r.size.y * 0.5f) * q;
    const Vec4 sum = a + b;
    const Vec4 diff = b - a;

    const Vec4 corner[4] = {
        {.x = c.x - sum.x,  .y = c.y - sum.y,  .z = c.z, .w = fog},
        {.x = c.x - diff.x, .y = c.y - diff.y, .z = c.z, .w = fog},
        {.x = c.x + diff.x, .y = c.y + diff.y, .z = c.z, .w = fog},
        {.x = c.x + sum.x,  .y = c.y + sum.y,  .z = c.z, .w = fog},
    };
    const float min_x = std::min({corner[0].x, corner[1].x, corner[2].x, corner[3].x});
    const float max_x = std::max({corner[0].x, corner[1].x, corner[2].x, corner[3].x});
    const float min_y = std::min({corner[0].y, corner[1].y, corner[2].y, corner[3].y});
    const float max_y = std::max({corner[0].y, corner[1].y, corner[2].y, corner[3].y});

    out.drawn = Passes(p, min_x, min_y, max_x, max_y, q);

    // v0 and v1 are ADC-tagged unconditionally; v2 and v3 only on reject.
    const bool    reject = !out.drawn;
    const int32_t uvs[4][2] = {
        {u0x, u0y},
        {u1x, u0y},
        {u0x, u1y},
        {u1x, u1y}
    };
    const bool adc[4] = {true, true, reject, reject};

    out.vertex_count = 4;
    for (int i = 0; i < 4; ++i) {
        out.v[i] = Pack(corner[i], uvs[i][0], uvs[i][1], adc[i]);
    }
    return out;
}

} // namespace dc::vu1::sprite3d_oracle
