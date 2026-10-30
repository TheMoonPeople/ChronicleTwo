#include <gtest/gtest.h>

#include <array>
#include <cstddef>
#include <cstdint>
#include <vector>

#include "video/yuv.hpp"

using video::Yuv420ToRgba;

namespace {

using Rgba = std::array<uint8_t, 4>;

std::vector<Rgba> Pixels(const std::vector<uint8_t> &bytes) {
    std::vector<Rgba> out(bytes.size() / 4);
    for (size_t i = 0; i < out.size(); i++) {
        out[i] = {bytes[4 * i], bytes[4 * i + 1], bytes[4 * i + 2], bytes[4 * i + 3]};
    }
    return out;
}

std::vector<uint8_t> Convert(const std::vector<uint8_t> &y, int y_stride, const std::vector<uint8_t> &cb,
                             const std::vector<uint8_t> &cr, int c_stride, int width, int height) {
    std::vector<uint8_t> rgba(static_cast<size_t>(width) * static_cast<size_t>(height) * 4);
    Yuv420ToRgba(y.data(), y_stride, cb.data(), cr.data(), c_stride, width, height, rgba.data());
    return rgba;
}

} // namespace

TEST(VideoYuv, HandComputedPixel) {
    const std::vector<uint8_t> rgba = Convert({81, 81, 81, 81}, 2, {90}, {240}, 1, 2, 2);
    const std::vector<Rgba>    px = Pixels(rgba);
    ASSERT_EQ(px.size(), 4u);
    for (const Rgba &p : px) {
        EXPECT_EQ(p, (Rgba{255, 0, 0, 255}));
    }
}

TEST(VideoYuv, BlackAndWhiteLimitedRange) {
    const std::vector<Rgba> black = Pixels(Convert({16, 16, 16, 16}, 2, {128}, {128}, 1, 2, 2));
    for (const Rgba &p : black) {
        EXPECT_EQ(p, (Rgba{0, 0, 0, 255}));
    }
    const std::vector<Rgba> white = Pixels(Convert({235, 235, 235, 235}, 2, {128}, {128}, 1, 2, 2));
    for (const Rgba &p : white) {
        EXPECT_EQ(p, (Rgba{255, 255, 255, 255}));
    }
    const std::vector<Rgba> grey = Pixels(Convert({126, 126, 126, 126}, 2, {128}, {128}, 1, 2, 2));
    for (const Rgba &p : grey) {
        EXPECT_EQ(p, (Rgba{128, 128, 128, 255}));
    }
}

TEST(VideoYuv, ChromaIsNearestPerTwoByTwoBlock) {
    const std::vector<uint8_t> y(8, 81);
    const std::vector<Rgba>    px = Pixels(Convert(y, 4, {90, 128}, {240, 128}, 2, 4, 2));
    ASSERT_EQ(px.size(), 8u);
    for (size_t row = 0; row < 2; row++) {
        EXPECT_EQ(px[row * 4 + 0], (Rgba{255, 0, 0, 255}));
        EXPECT_EQ(px[row * 4 + 1], (Rgba{255, 0, 0, 255}));
        EXPECT_EQ(px[row * 4 + 2], (Rgba{76, 76, 76, 255}));
        EXPECT_EQ(px[row * 4 + 3], (Rgba{76, 76, 76, 255}));
    }
}

TEST(VideoYuv, StrideIsHonoured) {
    constexpr int kWidth = 4;
    constexpr int kHeight = 4;
    constexpr int kYStride = 8;
    constexpr int kCStride = 4;

    std::vector<uint8_t> y_tight(kWidth * kHeight);
    for (size_t i = 0; i < y_tight.size(); i++) {
        y_tight[i] = static_cast<uint8_t>(16 + i * 13);
    }
    std::vector<uint8_t> c_tight((kWidth / 2) * (kHeight / 2));
    for (size_t i = 0; i < c_tight.size(); i++) {
        c_tight[i] = static_cast<uint8_t>(100 + i * 7);
    }
    std::vector<uint8_t> cr_tight(c_tight.size());
    for (size_t i = 0; i < cr_tight.size(); i++) {
        cr_tight[i] = static_cast<uint8_t>(200 - i * 9);
    }
    const std::vector<uint8_t> tight = Convert(y_tight, kWidth, c_tight, cr_tight, kWidth / 2, kWidth, kHeight);

    std::vector<uint8_t> y_padded(kYStride * kHeight, 0xEE);
    for (int row = 0; row < kHeight; row++) {
        for (int x = 0; x < kWidth; x++) {
            y_padded[row * kYStride + x] = y_tight[row * kWidth + x];
        }
    }
    std::vector<uint8_t> cb_padded(kCStride * (kHeight / 2), 0xEE);
    std::vector<uint8_t> cr_padded(kCStride * (kHeight / 2), 0xEE);
    for (int row = 0; row < kHeight / 2; row++) {
        for (int x = 0; x < kWidth / 2; x++) {
            cb_padded[row * kCStride + x] = c_tight[row * (kWidth / 2) + x];
            cr_padded[row * kCStride + x] = cr_tight[row * (kWidth / 2) + x];
        }
    }
    const std::vector<uint8_t> padded =
        Convert(y_padded, kYStride, cb_padded, cr_padded, kCStride, kWidth, kHeight);

    EXPECT_EQ(padded, tight);
}
