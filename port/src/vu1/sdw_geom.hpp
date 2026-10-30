#pragma once

#include <vector>

#include "vu1/vu1_math.hpp"

namespace dc::vu1 {

struct SdwPrismTriangle {
    Vec4 v[3];
};

// Checks that a prism is finite and nondegenerate, and reports its outward winding.
bool SdwPrismOrientation(const Vec4 top[3], const Vec4 drop[3], bool &down);

// Appends the closed prism between a triangle and its drop: 8 triangles, outward wound. The winding
// is decided from the geometry alone, so it never depends on where the eye is.
void SdwPrism(const Vec4 top[3], const Vec4 drop[3], std::vector<SdwPrismTriangle> &out);

} // namespace dc::vu1
