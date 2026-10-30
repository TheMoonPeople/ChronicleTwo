#include <gtest/gtest.h>

#include <array>
#include <bit>
#include <charconv>
#include <cmath>
#include <limits>
#include <random>
#include <string_view>

// Exercise the iOS compatibility implementation beside the host's standard implementation.
#define to_chars IosCompatibilityToChars
// NOLINTNEXTLINE(bugprone-suspicious-include): Compile the platform-only overloads beside the host oracle.
#include "ios/to_chars.cpp"
#undef to_chars

namespace {

template <typename T, typename... Args>
void ExpectConversion(T value, Args... args) {
    std::array<char, 1024> expected{};
    std::array<char, 1024> actual{};
    const auto             reference = std::to_chars(expected.data(), expected.data() + expected.size(), value, args...);
    const auto             result = std::IosCompatibilityToChars(actual.data(), actual.data() + actual.size(), value, args...);
    ASSERT_EQ(result.ec, reference.ec);
    if (result.ec == std::errc{}) {
        EXPECT_EQ(std::string_view(actual.data(), result.ptr), std::string_view(expected.data(), reference.ptr)) << value;
    }
}

template <typename T>
void ExpectFormats(T value) {
    ExpectConversion(value);
    for (auto format : {std::chars_format::fixed, std::chars_format::scientific, std::chars_format::general, std::chars_format::hex}) {
        ExpectConversion(value, format);
        for (int precision : {0, 1, 6, 17}) {
            ExpectConversion(value, format, precision);
        }
    }
}

} // namespace

TEST(IosToChars, MatchesStandardFormatsAndBufferLimits) {
    for (double value : {0.0, -0.0, 1.0, -1.25, 0.00001, 100000.0, 1e20, 0.1,
                         std::numeric_limits<double>::denorm_min(), std::numeric_limits<double>::max(),
                         std::numeric_limits<double>::infinity(), -std::numeric_limits<double>::infinity()}) {
        ExpectFormats(value);
        ExpectFormats(static_cast<float>(value));
    }
    ExpectFormats(std::numeric_limits<float>::denorm_min());
    ExpectFormats(std::numeric_limits<float>::min());
    ExpectFormats(std::numeric_limits<float>::max());
    char buffer[1];
    EXPECT_EQ(std::IosCompatibilityToChars(buffer, buffer + 1, 123.0).ec, std::errc::value_too_large);
    EXPECT_EQ(std::IosCompatibilityToChars(buffer, buffer, 0.0).ptr, buffer);
}

TEST(IosToChars, MatchesShortestRepresentationsOfFiniteBitPatterns) {
    // NOLINTNEXTLINE(bugprone-random-generator-seed): Keep the regression corpus reproducible.
    std::mt19937_64 random(0x141);
    for (int sample = 0; sample < 1000; ++sample) {
        const auto value = std::bit_cast<double>(random());
        if (std::isfinite(value)) {
            ExpectConversion(value);
            ExpectConversion(value, std::chars_format::general);
        }
        const auto small = std::bit_cast<float>(static_cast<uint32_t>(random()));
        if (std::isfinite(small)) {
            ExpectConversion(small);
            ExpectConversion(small, std::chars_format::general);
        }
    }
}

TEST(IosToChars, HexRoundingAndSubnormalsMatchStandard) {
    for (double value : {1.5, 1.96875, 1.9999999999999998, 100000.0, 0.00001,
                         std::numeric_limits<double>::denorm_min(), std::numeric_limits<double>::min()}) {
        for (int precision : {0, 1, 6, 13, 17}) {
            ExpectConversion(value, std::chars_format::hex, precision);
            ExpectConversion(-value, std::chars_format::hex, precision);
            ExpectConversion(static_cast<float>(value), std::chars_format::hex, precision);
        }
        ExpectConversion(value, std::chars_format::hex);
        ExpectConversion(static_cast<float>(value), std::chars_format::hex);
    }
}
