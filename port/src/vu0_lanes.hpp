#pragma once

#include <cfloat>
#include <climits>
#include <cmath>

namespace vu0 {

// VU compares sign-magnitude, so +0 > -0.
inline float Max(float a, float b) {
    if (a > b) {
        return a;
    }
    if (b > a) {
        return b;
    }
    return std::signbit(a) ? b : a;
}

inline float Min(float a, float b) {
    if (a < b) {
        return a;
    }
    if (b < a) {
        return b;
    }
    return std::signbit(a) ? a : b;
}

// Status-flag sign bits are set by a -0 result too.
inline bool SignSet(float v) {
    return std::signbit(v);
}

// The VU has no infinity; overflow saturates to the largest finite value.
inline float Sat(float v) {
    if (v > FLT_MAX) {
        return FLT_MAX;
    }
    if (v < -FLT_MAX) {
        return -FLT_MAX;
    }
    return v;
}

// VU vdiv (and the EE FPU) return a signed FLT_MAX on a zero divisor.
inline float Div(float num, float den) {
    if (den == 0.0f) {
        return (std::signbit(num) != std::signbit(den)) ? -FLT_MAX : FLT_MAX;
    }
    return Sat(num / den);
}

// vsqrt takes the magnitude.
inline float Sqrt(float v) {
    return std::sqrt(std::fabs(v));
}

// vftoi saturates per sign; NaN cannot occur on the VU and takes the x86 cvttss2si value.
inline int Ftoi(float v) {
    if (std::isnan(v)) {
        return INT_MIN;
    }
    if (v >= 2147483648.0f) {
        return INT_MAX;
    }
    if (v < -2147483648.0f) {
        return INT_MIN;
    }
    return static_cast<int>(v);
}

inline int Ftoi4(float v) {
    return Ftoi(v * 16.0f);
}

// Retail vmulax/vmadday/vmaddaz/vmaddw accumulation order.
inline void Transform(float *out, const float (*m)[4], const float *v) {
    float r[4];
    for (int j = 0; j < 4; ++j) {
        r[j] = ((m[0][j] * v[0] + m[1][j] * v[1]) + m[2][j] * v[2]) + m[3][j] * v[3];
    }
    for (int j = 0; j < 4; ++j) {
        out[j] = r[j];
    }
}

} // namespace vu0
