#include <gtest/gtest.h>

#include <array>
#include <bit>
#include <charconv>
#include <cstddef>
#include <cstdint>
#include <limits>
#include <memory_resource>
#include <vector>

TEST(IosRuntime, FloatingPointCharacterConversionsRoundTrip) {
    for (double value : {0.0, -0.0, 0.1, -1.25, 1e20, std::numeric_limits<double>::denorm_min(), std::numeric_limits<double>::max()}) {
        std::array<char, 128> text{};
        const auto            written = std::to_chars(text.data(), text.data() + text.size(), value);
        ASSERT_EQ(written.ec, std::errc{});
        double     recovered = 0.0;
        const auto parsed = std::from_chars(text.data(), written.ptr, recovered);
        ASSERT_EQ(parsed.ec, std::errc{});
        EXPECT_EQ(parsed.ptr, written.ptr);
        EXPECT_EQ(std::bit_cast<std::uint64_t>(recovered), std::bit_cast<std::uint64_t>(value));
    }
}

TEST(IosRuntime, MemoryResourcesOwnAndReleaseContainerStorage) {
    ASSERT_NE(std::pmr::get_default_resource(), nullptr);
    std::array<std::byte, 128>          storage{};
    std::pmr::monotonic_buffer_resource resource(storage.data(), storage.size());
    std::pmr::vector<int>               values(&resource);
    for (int index = 0; index < 128; ++index) {
        values.push_back(index);
    }
    EXPECT_EQ(values.front(), 0);
    EXPECT_EQ(values.back(), 127);
    EXPECT_EQ(values.get_allocator().resource(), &resource);
}
