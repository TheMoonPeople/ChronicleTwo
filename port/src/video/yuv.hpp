#pragma once
#include <cstdint>

namespace video {

void Yuv420ToRgba(const uint8_t *y, int y_stride, const uint8_t *cb, const uint8_t *cr, int c_stride,
                  int width, int height, uint8_t *rgba);

} // namespace video
