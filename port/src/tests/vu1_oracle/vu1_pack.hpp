#pragma once

#include <cstdint>

#include "vu1/vu1_math.hpp"

namespace dc::vu1 {

// VU FTOI4: 16 * x is exact in binary32, so this is Ftoi0 on the scaled value.
inline int32_t Ftoi4(float x) {
    return Ftoi0(16.0f * x);
}

} // namespace dc::vu1
