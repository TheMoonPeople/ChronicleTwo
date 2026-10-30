#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <cstdint>
#include <cstring>
#include <string>
#include <string_view>
#include <vector>

#include "mainloop.hpp"
#include "nameregi.hpp"
#include "storage/password.hpp"

namespace {

/**
 * Selects payload patterns covering complete 64-bit groups and mixed byte values.
 */
enum class Pattern {
    Ramp,
    Ones,
    HighGroups,
    Random
};

/**
 * Generates deterministic payload bytes across the password format's complete value range.
 */
std::vector<std::uint8_t> MakePayload(Pattern pattern, std::size_t size, std::uint32_t seed) {
    std::vector<std::uint8_t> bytes(size);
    for (std::size_t index = 0; index < size; ++index) {
        seed = seed * 1664525U + 1013904223U;
        const auto random = static_cast<std::uint8_t>(seed >> 24);
        switch (pattern) {
            case Pattern::Ramp:
                bytes[index] = static_cast<std::uint8_t>(index & 0xFFU);
                break;
            case Pattern::Ones:
                bytes[index] = 0xFF;
                break;
            case Pattern::HighGroups:
                bytes[index] = index % 8 >= 4 ? static_cast<std::uint8_t>(random | 0x80U) : random;
                break;
            case Pattern::Random:
                bytes[index] = random;
                break;
        }
    }
    return bytes;
}

} // namespace

TEST(PasswordCodec, ReferenceVectorsKeepTheNativeWireFormat) {
    constexpr std::array<std::string_view, 4> expected{
        "u1DHS9qf8bkEqJFtDxy5Ka", "YJVUgz6MfRwkKfyKjkHzga",
        "fKFPW1zPbYDvvJ0EZYv40J", "ZUW3wn1ApU8mLRLVTBEtba"};
    for (std::size_t sample = 0; sample < expected.size(); ++sample) {
        std::array<std::uint8_t, 16> data{};
        dc2::password::TextKey       key{};
        for (std::size_t index = 0; index < data.size(); ++index) {
            if (sample == 0) {
                data[index] = static_cast<std::uint8_t>(index);
            }
            if (sample == 2) {
                data[index] = 255;
            }
            if (sample == 3) {
                data[index] = index % 2 == 0 ? 0xAA : 0x55;
            }
        }
        for (std::size_t index = 0; index < key.size(); ++index) {
            if (sample == 0 || sample == 2) {
                key[index] = static_cast<std::uint8_t>(index);
            }
            if (sample == 3) {
                key[index] = 255;
            }
        }
        EXPECT_EQ(dc2::password::Encode(data, key), expected[sample]);
    }
}

TEST(PasswordCodec, PayloadPatternsRoundTripWithoutChangingTheInput) {
    const auto key = MakePayload(Pattern::Random, 20, 0x5EEDU);
    for (const auto pattern : {Pattern::Ramp, Pattern::Ones, Pattern::HighGroups, Pattern::Random}) {
        for (const std::size_t size : {16U, 64U, 256U}) {
            SCOPED_TRACE(size);
            const auto data = MakePayload(pattern, size, 0x1234U + static_cast<std::uint32_t>(size));
            const auto unchanged = data;
            const auto encoded = dc2::password::Encode(data, key);
            ASSERT_TRUE(encoded);
            EXPECT_EQ(data, unchanged);
            EXPECT_EQ(encoded->size(), size / 8 * 11);
            const auto decoded = dc2::password::Decode(*encoded, size, key);
            ASSERT_TRUE(decoded);
            EXPECT_EQ(decoded->size(), size);
            EXPECT_TRUE(std::equal(data.begin(), data.end() - 2, decoded->begin()));
        }
    }
}

TEST(PasswordCodec, SingleCharacterTamperingIsRejectedOrChangesThePayload) {
    constexpr std::string_view alphabet = "0123456789abcdefghijkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ";
    const auto                 key = MakePayload(Pattern::Random, 20, 0x5EEDU);
    for (const auto pattern : {Pattern::Ramp, Pattern::Ones, Pattern::HighGroups, Pattern::Random}) {
        for (const std::size_t size : {16U, 64U, 256U}) {
            const auto encoded = dc2::password::Encode(MakePayload(pattern, size, 0x1234U), key);
            ASSERT_TRUE(encoded);
            const auto reference = dc2::password::Decode(*encoded, size, key);
            ASSERT_TRUE(reference);
            for (std::size_t index = 0; index < encoded->size(); ++index) {
                auto       tampered = *encoded;
                const auto digit = alphabet.find(tampered[index]);
                ASSERT_NE(digit, std::string_view::npos);
                tampered[index] = alphabet[(digit + 1) % alphabet.size()];
                const auto decoded = dc2::password::Decode(tampered, size, key);
                EXPECT_TRUE(!decoded || *decoded != *reference) << index;
            }
        }
    }
}

TEST(PasswordCodec, InvalidExtentsDigitsAndOverflowingGroupsAreRejected) {
    std::array<std::uint8_t, 16> data{};
    dc2::password::TextKey       key{};
    for (const std::size_t size : {0U, 1U, 7U, 9U, 15U}) {
        EXPECT_FALSE(dc2::password::Encode(std::span(data).first(size), key));
    }
    const auto encoded = dc2::password::Encode(data, key);
    ASSERT_TRUE(encoded);
    EXPECT_FALSE(dc2::password::Decode(*encoded, 0, key));
    EXPECT_FALSE(dc2::password::Decode(*encoded, 8, key));
    EXPECT_FALSE(dc2::password::Decode(*encoded, 24, key));
    EXPECT_FALSE(dc2::password::Decode(encoded->substr(1), 16, key));
    EXPECT_FALSE(dc2::password::Decode(std::string(22, 'Z'), 16, key));
    for (const std::size_t index : {0U, 10U, 11U, 21U}) {
        auto invalid = *encoded;
        invalid[index] = '!';
        EXPECT_FALSE(dc2::password::Decode(invalid, 16, key));
    }
}

TEST(PasswordCodec, NameKeysUseBoundedBytesAndZeroPadding) {
    const std::array<char, 3> name{'M', 'a', 'x'};
    const auto                key = dc2::password::KeyFromText({name.data(), name.size()});
    EXPECT_EQ(key[0], 'M');
    EXPECT_EQ(key[1], 'a');
    EXPECT_EQ(key[2], 'x');
    for (std::size_t index = name.size(); index < key.size(); ++index) {
        EXPECT_EQ(key[index], 0);
    }
    EXPECT_EQ(dc2::password::KeyFromText(std::string_view("Max\0ignored", 11)), key);
    EXPECT_EQ(dc2::password::KeyFromText("12345678901234567890tail"),
              dc2::password::KeyFromText("12345678901234567890"));
}

TEST(PasswordCodec, SphedaScoresEncodeOnlyNineHolesAndTheKeysLowByte) {
    const std::array<std::uint8_t, 9> holes{1, 2, 3, 4, 5, 6, 7, 8, 9};
    const auto                        encoded = dc2::password::EncodeSphedaScore(holes, 0xFFFF1234U, "Max");
    ASSERT_TRUE(encoded);
    EXPECT_EQ(*encoded, "TUMerdpex9D1BcD4LRdL4J");
    const auto decoded = dc2::password::Decode(*encoded, 16, dc2::password::KeyFromText("Max"));
    ASSERT_TRUE(decoded);
    EXPECT_TRUE(std::equal(holes.begin(), holes.end(), decoded->begin()));
    for (std::size_t index = holes.size(); index < 13; ++index) {
        EXPECT_EQ((*decoded)[index], 0);
    }
    EXPECT_EQ((*decoded)[13], 0x34);
}

/**
 * Restores the active language after each bounded name conversion case.
 */
class NameEntryCodec : public testing::Test {
protected:
    void SetUp() override {
        previous_language = LanguageCode;
        LanguageCode = LANG_JAPANESE;
    }

    void TearDown() override { LanguageCode = previous_language; }

    int previous_language{}; /**< Language selected before the conversion case. */
};

TEST_F(NameEntryCodec, BoundedConversionsKeepWholeCharactersAndSupportOverlappingFields) {
    std::array<char, 8> field{'0', 'A', 'z', 0};
    ConvertAscii2ShitJiss(field, field);
    EXPECT_EQ(std::strlen(field.data()), 6u);
    ConvertShitJiss2Ascii(field, field);
    EXPECT_STREQ(field.data(), "0Az");
    std::array<char, 4> guarded{'x', 'x', 'x', 'g'};
    const char          source[] = "0Az";
    ConvertAscii2ShitJiss(source, std::span(guarded).first(3));
    EXPECT_EQ(guarded[2], 0);
    EXPECT_EQ(guarded[3], 'g');
    std::array<char, 4> decoded{};
    ConvertShitJiss2Ascii(std::span(guarded).first(3), decoded);
    EXPECT_STREQ(decoded.data(), "0");
}

TEST_F(NameEntryCodec, OddAndUnknownShiftJisInputProducesAnEmptyTerminatedField) {
    std::array<char, 3> odd{static_cast<char>(0x82), 'O', static_cast<char>(0x82)};
    std::array<char, 4> output{'x', 'x', 'x', 'g'};
    ConvertShitJiss2Ascii(odd, std::span(output).first(3));
    EXPECT_EQ(output[0], 0);
    EXPECT_EQ(output[3], 'g');
    const std::array<char, 3> unknown{static_cast<char>(0x81), static_cast<char>(0xFF), 0};
    ConvertShitJiss2Ascii(unknown, std::span(output).first(3));
    EXPECT_EQ(output[0], 0);
    EXPECT_EQ(output[3], 'g');
}
