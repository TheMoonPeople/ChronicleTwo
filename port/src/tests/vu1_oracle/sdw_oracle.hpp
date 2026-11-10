#pragma once

#include <array>
#include <cstdint>
#include <vector>

#include "vu1/vu1_math.hpp"

namespace dc::vu1 {

inline constexpr uint32_t kSdwAlphaAdd = 0x68;
inline constexpr uint32_t kSdwAlphaSub = 0x62;
inline constexpr uint32_t kSdwAlphaFix = 0x80;

inline constexpr uint32_t kSdwQuadCount = 5;
inline constexpr float    kSdwLightScale = -0.1f;
inline constexpr float    kSdwGrazingEpsilon = 1e-4f;

struct SdwParams {
    Vec4 object[3]; // R0..R2 (VU 0x08..0x0A), xyz used
    Vec4 light;     // L in xyz (VU 0x0C.x, 0x0D.x, 0x0E.x)
    Mat4 vc;        // object to clip (VU 0x19..0x1C)
    Mat4 cs;        // clip to screen (VU 0x1D..0x20); cs.q[1].x must be 0 (spec 7.3)
    Mat4 sm;        // shadow projection (VU 0x28..0x2B)
};

struct SdwLight {
    Vec4 a_hat;    // unit object-space light, w = 0
    Vec4 lc;       // clip-space light, xyz used
    bool mirrored; // det(R0,R1,R2) < 0; no effect on output (spec 7.3)
};

SdwLight SdwPrepare(const SdwParams &p);

enum class SdwReject : uint8_t {
    None,
    CClip,
    TClip,
    Grazing
};
enum class SdwPath : uint8_t {
    A,
    B
};

enum class SdwKickKind : uint8_t {
    AlphaAdd,
    AlphaSub,
    Quad
};

struct SdwKick {
    SdwKickKind kind;
    uint8_t     quad; // group index 0..4, meaningful for Quad only
    bool        operator==(const SdwKick &) const = default;
};

struct SdwScreenVertex {
    int32_t  x; // 12.4
    int32_t  y; // 12.4
    int32_t  z; // trunc(16 * S.z) >> 4
    uint32_t f; // fog byte: (trunc(16 * S.w) >> 4) & 0xFF
    Vec4     s; // S = P / P.w, float
};

struct SdwQuad {
    std::array<SdwScreenVertex, 4> v{};
    float                          zsign = 0.0f;
    bool                           back = false; // zsign < 0: SUB state; otherwise ADD
    std::array<uint32_t, 4>        rgbaq = {1, 1, 1, 64};
};

struct SdwTriangle {
    SdwReject                          reject = SdwReject::None;
    Vec4                               c[3]{};
    Vec4                               t[3]{};
    Vec4                               e1{};
    Vec4                               e2{};
    Vec4                               n{};
    float                              q = 0.0f;
    SdwPath                            path = SdwPath::A;
    std::array<SdwQuad, kSdwQuadCount> quads{};
    uint32_t                           front_count = 0;
    uint32_t                           back_count = 0;
    std::vector<SdwKick>               kicks;
};

SdwTriangle SdwExtrude(const SdwParams &p, const SdwLight &light, Vec4 v0, Vec4 v1, Vec4 v2);

std::vector<SdwKick> SdwKickOrder(const std::array<bool, kSdwQuadCount> &back);

} // namespace dc::vu1
