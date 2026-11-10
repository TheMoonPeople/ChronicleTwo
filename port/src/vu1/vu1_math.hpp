#pragma once

#include <cmath>
#include <cstdint>
#include <limits>

namespace dc::vu1 {

inline constexpr float    kGsCentre = 2048.0f;
inline constexpr uint32_t kGuardMask = 0xD0;

struct Vec4 {
    float x, y, z, w;
};

constexpr Vec4 operator+(const Vec4 &a, const Vec4 &b) {
    return {.x = a.x + b.x, .y = a.y + b.y, .z = a.z + b.z, .w = a.w + b.w};
}

constexpr Vec4 operator-(const Vec4 &a, const Vec4 &b) {
    return {.x = a.x - b.x, .y = a.y - b.y, .z = a.z - b.z, .w = a.w - b.w};
}

constexpr Vec4 operator*(const Vec4 &v, float s) {
    return {.x = v.x * s, .y = v.y * s, .z = v.z * s, .w = v.w * s};
}

constexpr Vec4 operator*(float s, const Vec4 &v) {
    return v * s;
}

// q[i] is column i as uploaded to VU memory.
struct Mat4 {
    Vec4 q[4];
};

constexpr Mat4 Identity() {
    return {
        {{.x = 1.0f, .y = 0.0f, .z = 0.0f, .w = 0.0f},
         {.x = 0.0f, .y = 1.0f, .z = 0.0f, .w = 0.0f},
         {.x = 0.0f, .y = 0.0f, .z = 1.0f, .w = 0.0f},
         {.x = 0.0f, .y = 0.0f, .z = 0.0f, .w = 1.0f}}
    };
}

// Left-to-right accumulation matches the VU MULAx/MADDAy/MADDAz/MADDw chain. Reordering changes
// the result under cancellation, so do not sum pairwise or via a generic dot product.
constexpr Vec4 Mul(const Mat4 &m, const Vec4 &v) {
    return m.q[0] * v.x + m.q[1] * v.y + m.q[2] * v.z + m.q[3] * v.w;
}

constexpr float Dot3(Vec4 a, Vec4 b) {
    return a.x * b.x + a.y * b.y + a.z * b.z;
}

constexpr Vec4 Cross3(Vec4 a, Vec4 b) {
    return {.x = a.y * b.z - a.z * b.y, .y = a.z * b.x - a.x * b.z, .z = a.x * b.y - a.y * b.x, .w = 0.0f};
}

// VU FTOI0: truncation toward zero, saturating to int32, NaN -> 0.
inline int32_t Ftoi0(float x) {
    if (std::isnan(x)) {
        return 0;
    }
    if (x >= 2147483648.0f) {
        return std::numeric_limits<int32_t>::max();
    }
    if (x <= -2147483648.0f) {
        return std::numeric_limits<int32_t>::min();
    }
    return static_cast<int32_t>(x);
}

// Lanes of qw 0x3B, in lane order x, y, z, w.
struct Fog {
    float offset;
    float near_value; // lane y; the 7th mgSetFogParam argument
    float far_value;  // lane z; the 6th mgSetFogParam argument
    float scale;
};

// Arguments follow mgSetFogParam(near_dist, far_dist, ..., far_value, near_value).
constexpr Fog MakeFog(float near_dist, float far_dist, float far_value, float near_value) {
    const float range = far_value - near_value;
    const float span = far_dist - near_dist;
    return {
        .offset = (far_value + near_value + range * (far_dist + near_dist) / span) * 0.5f,
        .near_value = near_value,
        .far_value = far_value,
        .scale = -far_dist * near_dist * range / span,
    };
}

// q = 1/w. min applies before max: when far_value > near_value the result is far_value.
constexpr float FogValue(const Fog &f, float q) {
    const float raw = f.offset + f.scale * q;
    const float lo = raw < f.near_value ? raw : f.near_value;
    return lo > f.far_value ? lo : f.far_value;
}

} // namespace dc::vu1
