#include "video/yuv.hpp"

#include <algorithm>
#include <cstddef>

namespace video {
namespace {

constexpr size_t kChannels = 4;

uint8_t Clamp8(int v) { return static_cast<uint8_t>(std::clamp(v, 0, 255)); }

} // namespace

void Yuv420ToRgba(const uint8_t *y, int y_stride, const uint8_t *cb, const uint8_t *cr, int c_stride,
                  int width, int height, uint8_t *rgba) {
    for (int row = 0; row < height; row++) {
        const uint8_t *y_row = y + static_cast<std::ptrdiff_t>(row) * y_stride;
        const uint8_t *cb_row = cb + static_cast<std::ptrdiff_t>(row / 2) * c_stride;
        const uint8_t *cr_row = cr + static_cast<std::ptrdiff_t>(row / 2) * c_stride;
        uint8_t       *out = rgba + static_cast<size_t>(row) * static_cast<size_t>(width) * kChannels;
        for (int x = 0; x < width; x++, out += kChannels) {
            const int c = y_row[x] - 16;
            const int d = cb_row[x / 2] - 128;
            const int e = cr_row[x / 2] - 128;
            out[0] = Clamp8((298 * c + 409 * e + 128) >> 8);
            out[1] = Clamp8((298 * c - 100 * d - 208 * e + 128) >> 8);
            out[2] = Clamp8((298 * c + 516 * d + 128) >> 8);
            out[3] = 0xFF;
        }
    }
}

} // namespace video
