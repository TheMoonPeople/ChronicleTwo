#include "prog0_cpu.hpp"

#include <cmath>
#include <cstddef>

#include "vu1_oracle/vu1_pack.hpp"

namespace dc::vu1 {

namespace {

constexpr uint32_t kGuardX = 0x80;
constexpr uint32_t kGuardY = 0x40;
constexpr uint32_t kGuardW = 0x10;
constexpr uint32_t kOrient = 0x20;
constexpr uint32_t kClipCfMask = 0x3FFFF;
constexpr uint32_t kClipCfAll = 0xFFFFFF;

// Order: -y, +y, -x, +x, -z, +z. Each is all ones except the three plane bits (one per vertex).
constexpr uint32_t kRejectMask[6] = {0xFF7DF7, 0xFFBEFB, 0xFFDF7D, 0xFFEFBE, 0xFDF7DF, 0xFEFBEF};

// Rows: [dw0, dw1, dw2] as 0 or n, indexed by variant.
constexpr uint32_t kNonSkinnedCounts[8][3] = {
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 1},
    {1, 1, 0},
    {1, 0, 1},
    {1, 0, 1},
    {1, 0, 0},
    {1, 0, 0},
};
constexpr uint32_t kSkinnedCounts[8][3] = {
    {1, 1, 0},
    {1, 1, 1},
    {1, 0, 0},
    {1, 1, 0},
    {1, 0, 0},
    {1, 0, 1},
    {0, 0, 0},
    {1, 0, 0},
};

// Plane pairs: Z, X, Y. Within a pair, even index is the minus plane.
constexpr int kAxisOfPair[3] = {2, 0, 1};

struct PlaneSpec {
    int   axis;
    float s;
};

PlaneSpec PlaneOf(int plane) {
    return {.axis = kAxisOfPair[plane / 2], .s = (plane % 2) == 0 ? -1.0f : 1.0f};
}

float Component(const Vec4 &v, int axis) {
    return axis == 0 ? v.x : (axis == 1 ? v.y : v.z);
}

bool Outside(const Prog0ClipVertex &v, PlaneSpec p) {
    const float c = Component(v.pos, p.axis);
    const float aw = std::fabs(v.pos.w);
    return p.s < 0.0f ? c < -aw : c > aw;
}

Prog0ClipVertex Intersect(const Prog0ClipVertex &cur, const Prog0ClipVertex &nxt, PlaneSpec p) {
    const float dc = Component(cur.pos, p.axis) - p.s * cur.pos.w;
    const float dn = Component(nxt.pos, p.axis) - p.s * nxt.pos.w;
    const float t = std::fabs(dc / (dn - dc));

    Prog0ClipVertex r{};
    r.pos = cur.pos + (nxt.pos - cur.pos) * t;
    r.colour = cur.colour + (nxt.colour - cur.colour) * t;
    r.uv = cur.uv + (nxt.uv - cur.uv) * t;
    r.uv.w = 0.0f;
    return r;
}

} // namespace

Prog0Pipeline SelectProg0Pipeline(uint32_t flags, uint32_t type) {
    const bool strip = (type & kProg0PrimMask) == kProg0PrimStrip;
    const bool colour = (type & kProg0Colour) != 0;

    Prog0Pipeline p{};
    p.ref_sphere = (flags & kProg0RefSphere) != 0;
    p.vertex_blend = (flags & kProg0VertexBlend) != 0;
    p.vertex_colour = colour;
    p.vc_add = colour && (flags & kProg0VcAdd) != 0;

    if ((type & kProg0NoNormal) != 0 || (flags & kProg0LightingOff) != 0) {
        p.lighting = Prog0Lighting::Off;
    } else if ((flags & kProg0PointLights) != 0) {
        p.lighting = Prog0Lighting::PointLighting;
    } else if ((flags & kProg0RealLighting) != 0) {
        p.lighting = Prog0Lighting::Real;
    } else {
        p.lighting = Prog0Lighting::Lighting;
    }

    if ((flags & kProg0Scissor) != 0) {
        p.clip = strip ? Prog0Clip::ClipScisStrip : Prog0Clip::ClipScis;
    } else {
        p.clip = Prog0Clip::None;
    }

    if ((flags & kProg0Facing) != 0) {
        p.output = strip ? Prog0Output::OutputCNStrip : Prog0Output::OutputCN;
    } else if ((flags & kProg0Clip) != 0) {
        p.output = Prog0Output::OutputC;
    } else {
        p.output = Prog0Output::Output;
    }

    return p;
}

int Prog0HeaderVariant(uint32_t type) {
    int variant = 0;
    if ((type & kProg0Colour) != 0) {
        variant |= 1;
    }
    if ((type & kProg0NoTexture) != 0) {
        variant |= 2;
    }
    if ((type & kProg0NoNormal) != 0) {
        variant |= 4;
    }
    return variant;
}

Prog0Header PackProg0Header(uint32_t type, uint32_t n, bool skinned) {
    const int   variant = Prog0HeaderVariant(type);
    const auto &row = skinned ? kSkinnedCounts[variant] : kNonSkinnedCounts[variant];
    return {.v_count = row[0] * n, .n_count = row[1] * n, .c_count = row[2] * n, .type = type};
}

Prog0Offsets Prog0InputOffsets(int tops, const Prog0Header &header) {
    const int v = tops + 2;
    const int normal = v + static_cast<int>(header.v_count);
    const int uv = normal + static_cast<int>(header.n_count);
    const int colour = uv + static_cast<int>(header.c_count);
    const int weight = colour + static_cast<int>(header.v_count);
    return {.v = v, .normal = normal, .uv = uv, .colour = colour, .weight = weight};
}

int Prog0BatchLimit(int vu1_offset, bool colour, bool skinned) {
    const int per_vertex = skinned ? (colour ? 6 : 5) : (colour ? 4 : 3);
    return (vu1_offset - 2) / per_vertex / 3 * 3;
}

uint32_t Prog0ClipCode(Vec4 clip) {
    const float aw = std::fabs(clip.w);
    uint32_t    code = 0;
    if (clip.x > aw) {
        code |= 1u << 0;
    }
    if (clip.x < -aw) {
        code |= 1u << 1;
    }
    if (clip.y > aw) {
        code |= 1u << 2;
    }
    if (clip.y < -aw) {
        code |= 1u << 3;
    }
    if (clip.z > aw) {
        code |= 1u << 4;
    }
    if (clip.z < -aw) {
        code |= 1u << 5;
    }
    return code;
}

uint32_t Prog0PushClipCode(uint32_t cf, uint32_t code) {
    return ((cf << 6) | code) & kClipCfAll;
}

Prog0ClipClass Prog0ClassifyTriangle(uint32_t cf) {
    if ((cf & kClipCfMask) == 0) {
        return Prog0ClipClass::Keep;
    }
    for (uint32_t mask : kRejectMask) {
        if ((cf | mask) == kClipCfAll) {
            return Prog0ClipClass::Reject;
        }
    }
    return Prog0ClipClass::Partial;
}

Prog0ClipPolygon Prog0ClipPlane(const Prog0ClipPolygon &in, int plane) {
    Prog0ClipPolygon out{};
    const PlaneSpec  p = PlaneOf(plane);

    auto emit = [&out](const Prog0ClipVertex &v) {
        if (out.count == kProg0ClipCapacity) {
            out.overflow = true;
            return;
        }
        out.v[out.count] = v;
        ++out.count;
    };

    for (int i = 0; i < in.count; ++i) {
        const Prog0ClipVertex &cur = in.v[i];
        const Prog0ClipVertex &nxt = in.v[(i + 1) % in.count];
        const bool             cur_in = !Outside(cur, p);
        const bool             nxt_in = !Outside(nxt, p);
        if (cur_in) {
            emit(cur);
        }
        if (cur_in != nxt_in) {
            emit(Intersect(cur, nxt, p));
        }
    }
    out.overflow = out.overflow || in.overflow;
    return out;
}

Prog0ClipPolygon Prog0ClipTriangle(const std::array<Prog0ClipVertex, 3> &tri) {
    Prog0ClipPolygon poly{};
    for (int i = 0; i < 3; ++i) {
        poly.v[i] = tri[i];
    }
    poly.count = 3;
    for (int plane = 0; plane < 6; ++plane) {
        poly = Prog0ClipPlane(poly, plane);
    }
    return poly;
}

Prog0ScreenVertex Prog0ToScreen(const Prog0ClipVertex &v, const Mat4 &clip_screen, const Fog &fog) {
    const Vec4  s = Mul(clip_screen, v.pos);
    const float q = 1.0f / s.w;

    Prog0ScreenVertex out{};
    out.screen = {.x = s.x * q, .y = s.y * q, .z = s.z * q, .w = FogValue(fog, q)};
    out.st = {.x = v.uv.x * q, .y = v.uv.y * q, .z = v.uv.z * q, .w = 0.0f};
    out.rgbaq = {Ftoi0(v.colour.x), Ftoi0(v.colour.y), Ftoi0(v.colour.z), Ftoi0(v.colour.w)};
    return out;
}

std::array<int, 3> Prog0FanTriangle(int tri) {
    return {0, tri + 1, tri + 2};
}

uint32_t Prog0ClipPacketTag(int n_out) {
    return 0x8000u | static_cast<uint32_t>(n_out);
}

uint32_t Prog0GuardBits(Vec4 screen, Vec4 g_min, Vec4 g_max, float inv_far, float inv_near) {
    uint32_t bits = 0;
    if (screen.x > g_min.x && screen.x < g_max.x) {
        bits |= kGuardX;
    }
    if (screen.y > g_min.y && screen.y < g_max.y) {
        bits |= kGuardY;
    }
    if (screen.w > inv_far && screen.w < inv_near) {
        bits |= kGuardW;
    }
    return bits;
}

uint32_t Prog0OrientBit(Vec4 v0, Vec4 v1, Vec4 v2) {
    const Vec4 e1 = v1 - v0;
    const Vec4 e2 = v2 - v0;
    return Cross3(e2, e1).z < 0.0f ? kOrient : 0u;
}

Prog0Facing Prog0ListFacing(const std::array<Vec4, 3> &v, const std::array<uint32_t, 3> &guard, uint32_t mirror) {
    const uint32_t in_tri = guard[0] & guard[1] & guard[2];
    const uint32_t sample = in_tri | Prog0OrientBit(v[0], v[1], v[2]);
    const bool     keep = sample == (kGuardMask | (mirror & kOrient));
    return {.keep = keep, .adc_vertex = keep ? -1 : 2};
}

bool Prog0ClipFacingKeep(Vec4 p0, Vec4 p1, Vec4 p2, uint32_t mirror) {
    return Prog0OrientBit(p0, p1, p2) == (mirror & kOrient);
}

std::vector<bool> Prog0WindowAdc(std::span<const uint32_t> guard, Prog0Window &carry) {
    std::vector<bool> adc;
    adc.reserve(guard.size());
    for (const uint32_t g : guard) {
        const bool in = g == kGuardMask;
        adc.push_back(!(carry.in_prev2 && carry.in_prev1 && in));
        carry.in_prev2 = carry.in_prev1;
        carry.in_prev1 = in;
    }
    return adc;
}

std::vector<bool> Prog0StripAdc(std::span<const Vec4> screen, std::span<const uint32_t> guard, uint32_t mirror,
                                Prog0StripWindow &carry) {
    std::vector<bool> adc;
    adc.reserve(guard.size());
    const uint32_t want = mirror & kOrient;
    for (std::size_t k = 0; k < guard.size(); ++k) {
        const bool     in = guard[k] == kGuardMask;
        const Vec4     cur = screen[k];
        const float    parity = (k % 2 == 0) ? 1.0f : -1.0f;
        const float    cz = Cross3(carry.pos_prev1 - cur, carry.pos_prev2 - cur).z * parity;
        const uint32_t orient = cz < 0.0f ? kOrient : 0u;
        const bool     window = carry.window.in_prev2 && carry.window.in_prev1 && in;
        adc.push_back(!window || orient != want);

        carry.window.in_prev2 = carry.window.in_prev1;
        carry.window.in_prev1 = in;
        carry.pos_prev2 = carry.pos_prev1;
        carry.pos_prev1 = cur;
    }
    return adc;
}

std::vector<int> Prog0StripParity(int vertex_num, int batch_limit) {
    if (vertex_num < 3 || batch_limit < 3) {
        return {};
    }
    std::vector<int> parity(static_cast<std::size_t>(vertex_num - 2), 0);
    int              start = 0;
    int              remaining = vertex_num;
    while (remaining > 0) {
        const bool continues = batch_limit < remaining;
        const int  count = continues ? batch_limit : remaining;
        for (int k = 2; k < count; ++k) {
            parity[static_cast<std::size_t>(start + k - 2)] = (k % 2 == 0) ? 1 : -1;
        }
        start += continues ? batch_limit - 2 : count;
        remaining += continues ? 2 - batch_limit : -batch_limit;
    }
    return parity;
}

std::array<int, 3> Prog0StripTriangle(int t, int parity) {
    if (parity > 0) {
        return {t, t + 1, t + 2};
    }
    return {t + 1, t, t + 2};
}

GsXyzf PackProg0Xyzf(Vec4 screen, float fog, bool adc) {
    GsXyzf out{};
    out.x = static_cast<uint16_t>(Ftoi4(screen.x));
    out.y = static_cast<uint16_t>(Ftoi4(screen.y));
    out.z = (static_cast<uint32_t>(Ftoi4(screen.z)) >> 4) & 0xFFFFFFu;
    out.f = static_cast<uint8_t>((static_cast<uint32_t>(Ftoi4(fog)) >> 4) & 0xFFu);
    out.adc = adc;
    return out;
}

Vec4 GsToNdc(Vec4 screen, float half_width, float half_height) {
    return {.x = (screen.x - kGsCentre) / half_width, .y = (screen.y - kGsCentre) / half_height, .z = 0.0f, .w = 1.0f};
}

float GsZToDepth(uint32_t z24, float z_range) {
    const float d = static_cast<float>(z24) / z_range;
    return d > 1.0f ? 1.0f : d;
}

} // namespace dc::vu1
