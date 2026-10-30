#include "vu1_oracle/sdw_oracle.hpp"

#include <cmath>

#include "vu1_oracle/vu1_pack.hpp"

namespace dc::vu1 {
namespace {

// Vertex indices: 0..2 = C0..C2, 3..5 = T0..T2. Spec 5.3.
constexpr uint8_t kPathA[kSdwQuadCount][4] = {
    {0, 3, 4, 1},
    {1, 4, 5, 2},
    {2, 5, 3, 0},
    {5, 4, 3, 3},
    {0, 1, 2, 2}
};
constexpr uint8_t kPathB[kSdwQuadCount][4] = {
    {0, 1, 4, 3},
    {1, 2, 5, 4},
    {2, 0, 3, 5},
    {3, 4, 5, 5},
    {2, 1, 0, 0}
};

bool OutsideFrustum(const Vec4 &v) {
    const float aw = std::fabs(v.w);
    return v.x > aw || v.x < -aw || v.y > aw || v.y < -aw || v.z > aw || v.z < -aw;
}

SdwScreenVertex Project(const Mat4 &cs, const Vec4 &v) {
    const Vec4 p = Mul(cs, v);
    const Vec4 s = p * (1.0f / p.w);
    return {
        .x = Ftoi4(s.x),
        .y = Ftoi4(s.y),
        .z = Ftoi4(s.z) >> 4,
        .f = static_cast<uint32_t>(Ftoi4(s.w) >> 4) & 0xFFu,
        .s = s,
    };
}

} // namespace

SdwLight SdwPrepare(const SdwParams &p) {
    const Vec4  a{.x = Dot3(p.object[0], p.light), .y = Dot3(p.object[1], p.light), .z = Dot3(p.object[2], p.light), .w = 0.0f};
    const float len = std::sqrt(Dot3(a, a));
    const Vec4  a_hat{.x = a.x / len, .y = a.y / len, .z = a.z / len, .w = 0.0f};

    const Vec4 d{.x = kSdwLightScale * a_hat.x, .y = kSdwLightScale * a_hat.y, .z = kSdwLightScale * a_hat.z, .w = 0.0f};
    const Vec4 lc = p.vc.q[0] * d.x + p.vc.q[1] * d.y + p.vc.q[2] * d.z;

    const float det = Dot3(Cross3(p.object[0], p.object[1]), p.object[2]);
    return {.a_hat = a_hat, .lc = lc, .mirrored = det < 0.0f};
}

SdwTriangle SdwExtrude(const SdwParams &p, const SdwLight &light, Vec4 v0, Vec4 v1, Vec4 v2) {
    SdwTriangle tri{};
    const Vec4  in[3] = {v0, v1, v2};
    for (uint32_t j = 0; j < 3; ++j) {
        tri.c[j] = Mul(p.vc, in[j]);
        tri.t[j] = Mul(p.sm, in[j]);
    }

    for (const Vec4 &c : tri.c) {
        if (OutsideFrustum(c)) {
            tri.reject = SdwReject::CClip;
            return tri;
        }
    }
    for (const Vec4 &t : tri.t) {
        if (OutsideFrustum(t)) {
            tri.reject = SdwReject::TClip;
            return tri;
        }
    }

    tri.e1 = {.x = tri.c[1].x - tri.c[0].x, .y = tri.c[1].y - tri.c[0].y, .z = tri.c[1].z - tri.c[0].z, .w = 0.0f};
    tri.e2 = {.x = tri.c[2].x - tri.c[0].x, .y = tri.c[2].y - tri.c[0].y, .z = tri.c[2].z - tri.c[0].z, .w = 0.0f};
    tri.n = Cross3(tri.e2, tri.e1);
    tri.q = Dot3(tri.n, light.lc);
    if (std::fabs(tri.q) <= kSdwGrazingEpsilon) {
        tri.reject = SdwReject::Grazing;
        return tri;
    }

    tri.path = tri.q < 0.0f ? SdwPath::B : SdwPath::A;
    const Vec4  pts[6] = {tri.c[0], tri.c[1], tri.c[2], tri.t[0], tri.t[1], tri.t[2]};
    const auto &order = tri.path == SdwPath::B ? kPathB : kPathA;

    std::array<bool, kSdwQuadCount> back{};
    for (uint32_t g = 0; g < kSdwQuadCount; ++g) {
        SdwQuad &quad = tri.quads[g];
        for (uint32_t i = 0; i < 4; ++i) {
            quad.v[i] = Project(p.cs, pts[order[g][i]]);
        }

        // Spec tabulates s in 12.4 units; the sign is taken on the float S, before ftoi4 (5.4).
        const Vec4 &s0 = quad.v[0].s;
        const Vec4 &s1 = quad.v[1].s;
        const Vec4 &s2 = quad.v[2].s;
        const float e1x = s1.x - s0.x;
        const float e1y = s1.y - s0.y;
        const float e2x = s2.x - s0.x;
        const float e2y = s2.y - s0.y;
        quad.zsign = e2x * e1y - e2y * e1x;
        quad.back = quad.zsign < 0.0f;
        back[g] = quad.back;
        if (quad.back) {
            ++tri.back_count;
        } else {
            ++tri.front_count;
        }
    }

    tri.kicks = SdwKickOrder(back);
    return tri;
}

std::vector<SdwKick> SdwKickOrder(const std::array<bool, kSdwQuadCount> &back) {
    uint32_t front_count = 0;
    uint32_t back_count = 0;
    for (bool b : back) {
        if (b) {
            ++back_count;
        } else {
            ++front_count;
        }
    }

    std::vector<SdwKick> kicks;
    kicks.push_back({.kind = SdwKickKind::AlphaAdd, .quad = 0});
    // Spec 6.5: back quads are never kicked when a triangle has no front quad.
    if (front_count == 0) {
        return kicks;
    }
    for (uint32_t g = 0; g < kSdwQuadCount; ++g) {
        if (!back[g]) {
            kicks.push_back({.kind = SdwKickKind::Quad, .quad = static_cast<uint8_t>(g)});
        }
    }
    kicks.push_back({.kind = SdwKickKind::AlphaAdd, .quad = 0});
    if (back_count == 0) {
        return kicks;
    }
    kicks.push_back({.kind = SdwKickKind::AlphaSub, .quad = 0});
    for (uint32_t g = 0; g < kSdwQuadCount; ++g) {
        if (back[g]) {
            kicks.push_back({.kind = SdwKickKind::Quad, .quad = static_cast<uint8_t>(g)});
        }
    }
    kicks.push_back({.kind = SdwKickKind::AlphaSub, .quad = 0});
    return kicks;
}

} // namespace dc::vu1
