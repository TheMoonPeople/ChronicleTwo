#include <gtest/gtest.h>

#include <cstdint>
#include <cstring>
#include <vector>

#include "app_icon.hpp"

namespace {

template <typename T>
void Put(std::vector<std::uint8_t> &out, T value) {
    const auto *bytes = reinterpret_cast<const std::uint8_t *>(&value);
    out.insert(out.end(), bytes, bytes + sizeof(T));
}

// One flat triangle facing the viewer, textured with a single red texel run-length packed over 128x128.
std::vector<std::uint8_t> TriangleIcon() {
    std::vector<std::uint8_t> ico;
    Put<std::uint32_t>(ico, 0x10000);
    Put<std::uint32_t>(ico, 1);
    Put<std::uint32_t>(ico, 15);
    Put<float>(ico, 1.0f);
    Put<std::uint32_t>(ico, 3);
    const std::int16_t points[3][2] = {
        {-4096, 4096 },
        {4096,  4096 },
        {0,     -4096}
    };
    for (const auto &point : points) {
        for (std::int16_t value : {point[0], point[1], std::int16_t(0), std::int16_t(0)}) {
            Put(ico, value);
        }
        for (std::int16_t value : {std::int16_t(0), std::int16_t(0), std::int16_t(-4096), std::int16_t(0)}) {
            Put(ico, value);
        }
        Put<std::int16_t>(ico, 2048);
        Put<std::int16_t>(ico, 2048);
        Put<std::uint32_t>(ico, 0xFFFFFFFF);
    }
    for (std::uint32_t value : {1u, 1u}) {
        Put(ico, value);
    }
    Put<float>(ico, 1.0f);
    Put<std::uint32_t>(ico, 0);
    Put<std::uint32_t>(ico, 1);
    Put<std::uint32_t>(ico, 0);
    Put<std::uint32_t>(ico, 1);
    Put<std::uint64_t>(ico, 0);
    Put<std::uint32_t>(ico, 4);
    Put<std::uint16_t>(ico, 0x4000);
    Put<std::uint16_t>(ico, 31);
    return ico;
}

} // namespace

TEST(AppIcon, DrawsTheModelOverATransparentBackground) {
    const std::vector<std::uint8_t> ico = TriangleIcon();
    const std::vector<std::uint8_t> rgba = AppIconRender(ico.data(), ico.size(), 32);
    ASSERT_EQ(rgba.size(), 32u * 32u * 4u);
    const std::uint8_t *center = &rgba[(16 * 32 + 16) * 4];
    EXPECT_EQ(center[3], 255);
    EXPECT_GT(center[0], 100);
    EXPECT_EQ(center[1], 0);
    EXPECT_EQ(center[2], 0);
    EXPECT_EQ(rgba[3], 0);
}

TEST(AppIcon, RejectsTruncatedOrForeignFiles) {
    std::vector<std::uint8_t> ico = TriangleIcon();
    ico.resize(ico.size() - 2);
    EXPECT_TRUE(AppIconRender(ico.data(), ico.size(), 32).empty());
    const std::uint8_t png[] = {0x89, 'P', 'N', 'G', 0, 0, 0, 0};
    EXPECT_TRUE(AppIconRender(png, sizeof png, 32).empty());
}
