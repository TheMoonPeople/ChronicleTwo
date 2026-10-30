#include "vu1/sdw_geom.hpp"

#include <cmath>

namespace dc::vu1 {
namespace {

bool Finite(const Vec4 &v) {
    return std::isfinite(v.x) && std::isfinite(v.y) && std::isfinite(v.z) && std::isfinite(v.w);
}

Vec4 Point(const Vec4 &v) {
    return {.x = v.x, .y = v.y, .z = v.z, .w = 1.0f};
}

Vec4 Centroid(const Vec4 p[3]) {
    return {.x = (p[0].x + p[1].x + p[2].x) / 3.0f, .y = (p[0].y + p[1].y + p[2].y) / 3.0f, .z = (p[0].z + p[1].z + p[2].z) / 3.0f, .w = 0.0f};
}

} // namespace

bool SdwPrismOrientation(const Vec4 top[3], const Vec4 drop[3], bool &down) {
    for (uint32_t i = 0; i < 3; ++i) {
        if (!Finite(top[i]) || !Finite(drop[i])) {
            return false;
        }
    }

    const Vec4  normal = Cross3(top[1] - top[0], top[2] - top[0]);
    const Vec4  height = Centroid(drop) - Centroid(top);
    const float normal_len = std::sqrt(Dot3(normal, normal));
    const float height_len = std::sqrt(Dot3(height, height));
    const float thickness = Dot3(normal, height);
    if (!std::isfinite(normal_len) || !std::isfinite(height_len) || !std::isfinite(thickness)) {
        return false;
    }
    if (normal_len == 0.0f || height_len == 0.0f ||
        std::fabs(thickness) <= 1e-4f * normal_len * height_len) {
        return false;
    }

    down = thickness < 0.0f;
    return true;
}

void SdwPrism(const Vec4 top[3], const Vec4 drop[3], std::vector<SdwPrismTriangle> &out) {
    bool down = false;
    if (!SdwPrismOrientation(top, drop, down)) {
        return;
    }
    // The top normal points away from the drop exactly when the drop lies below the triangle; the
    // side and drop caps follow that orientation so every face winds outward either way.
    const Vec4 t[3] = {Point(top[0]), Point(top[1]), Point(top[2])};
    const Vec4 d[3] = {Point(drop[0]), Point(drop[1]), Point(drop[2])};

    const auto emit = [&out](const Vec4 &a, const Vec4 &b, const Vec4 &c, bool keep) {
        out.push_back(keep ? SdwPrismTriangle{
                                 {a, b, c}
        }
                           : SdwPrismTriangle{{a, c, b}});
    };

    emit(t[0], t[1], t[2], down);
    emit(d[0], d[1], d[2], !down);
    for (uint32_t e = 0; e < 3; ++e) {
        const uint32_t next = (e + 1) % 3;
        emit(t[e], d[e], d[next], down);
        emit(t[e], d[next], t[next], down);
    }
}

} // namespace dc::vu1
