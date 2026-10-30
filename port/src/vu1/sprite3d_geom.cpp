#include "vu1/sprite3d_geom.hpp"

#include <algorithm>
#include <limits>

namespace dc::vu1 {
namespace {

// VU DIV by zero saturates to the largest magnitude; the sprite then fails the window test.
float ReciprocalW(float w) {
    return w != 0.0f ? 1.0f / w : std::numeric_limits<float>::max();
}

// FogValue is on the GS scale (255 = no fog); the host carries it as a unit interval.
float FogUnit(const Fog &f, float q) {
    return std::clamp(FogValue(f, q) / 255.0f, 0.0f, 1.0f);
}

// Strict on x, y and the 1/Pw window: a sprite that touches a bound is rejected whole.
bool Passes(const Sprite3dParams &p, float min_x, float min_y, float max_x, float max_y, float q) {
    return min_x > p.guard_min.x && min_y > p.guard_min.y && max_x < p.guard_max.x &&
           max_y < p.guard_max.y && q > 1.0f / p.guard_max.w && q < 1.0f / p.guard_min.w;
}

Sprite3dVertexF Vertex(Vec4 corner, float u, float v, float fog) {
    return {.x = corner.x, .y = corner.y, .z = corner.z, .u = u, .v = v, .fog = fog};
}

} // namespace

Sprite3dQuadF Sprite3dExpandNative(const Sprite3dParams &p, const Sprite3dRecord &r, int mode) {
    const Vec4  pclip = Mul(p.ls, r.pos);
    const float q = ReciprocalW(pclip.w);
    const Vec4  c{.x = pclip.x * q, .y = pclip.y * q, .z = pclip.z * q, .w = q};
    const float fog = FogUnit(p.fog, q);

    Sprite3dQuadF out{};
    out.rgba[0] = r.colour.x;
    out.rgba[1] = r.colour.y;
    out.rgba[2] = r.colour.z;
    out.rgba[3] = r.colour.w;

    if (mode == 0) {
        const float hqx = (r.size.x * p.vs0.x) * 0.5f * q;
        const float hqy = (r.size.y * p.vs1.y) * 0.5f * q;
        const Vec4  min{.x = c.x - hqx, .y = c.y - hqy, .z = c.z, .w = fog};
        const Vec4  max{.x = c.x + hqx, .y = c.y + hqy, .z = c.z, .w = fog};

        out.drawn = Passes(p, min.x, min.y, max.x, max.y, q);
        out.count = 2;
        out.v[0] = Vertex(min, r.uv0.x, r.uv0.y, fog);
        out.v[1] = Vertex(max, r.uv1.x, r.uv1.y, fog);
        return out;
    }

    // Any nonzero mode takes the rotated path (vu_prog_3dsp branches on mode == 0 only).
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
    out.count = 4;

    const float uvs[4][2] = {
        {r.uv0.x, r.uv0.y},
        {r.uv1.x, r.uv0.y},
        {r.uv0.x, r.uv1.y},
        {r.uv1.x, r.uv1.y}
    };
    for (int i = 0; i < 4; ++i) {
        out.v[i] = Vertex(corner[i], uvs[i][0], uvs[i][1], fog);
    }
    return out;
}

} // namespace dc::vu1
