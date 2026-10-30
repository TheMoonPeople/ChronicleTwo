#include "storage/password.hpp"

#include <algorithm>
#include <limits>
#include <utility>

namespace dc2::password {
namespace {

constexpr std::string_view alphabet = "0123456789abcdefghijkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ"; /**< Digits of the password's base-58 representation. */
constexpr std::uint64_t    radix = alphabet.size();                                                 /**< Radix used in checked 64-bit group arithmetic. */
constexpr std::size_t      block_bytes = 8;                                                         /**< Bytes represented by one password group. */
constexpr std::size_t      block_digits = 11;                                                       /**< Digits emitted for one complete group. */

static_assert(alphabet.size() == 58);

/**
 * Computes the inverted CRC-16/CCITT checksum with explicit sixteen-bit reduction.
 */
std::uint16_t Checksum(std::span<const std::uint8_t> data) {
    std::uint32_t crc = 0xFFFF;
    for (const auto byte : data) {
        crc ^= static_cast<std::uint32_t>(byte) << 8;
        for (unsigned bit = 0; bit < 8; ++bit) {
            crc = ((crc << 1) ^ ((crc & 0x8000U) != 0 ? 0x1021U : 0U)) & 0xFFFFU;
        }
    }
    return static_cast<std::uint16_t>(crc ^ 0xFFFFU);
}

/**
 * Advances the password format's deliberately wrapping 32-bit scrambling state.
 */
std::uint32_t NextRandom(std::uint32_t &state) {
    state = state * 0x021FC436U + 1U;
    return state;
}

/**
 * Selects the payload byte exchanged with the checksum's low byte.
 */
std::size_t ChecksumIndex(std::size_t payload_bytes) {
    std::uint32_t state = 0x014A76E0U;
    return static_cast<std::size_t>(NextRandom(state)) % payload_bytes;
}

/**
 * Applies the checksum-seeded reversible byte mask to the payload alone.
 */
void Scramble(std::span<std::uint8_t> data, std::uint16_t checksum) {
    std::uint32_t state = static_cast<std::uint32_t>(checksum) + 0x05888F27U;
    for (auto &byte : data) {
        byte ^= static_cast<std::uint8_t>(NextRandom(state) >> 24);
    }
}

/**
 * Encodes an explicitly little-endian eight-byte group into eleven bounded digits.
 */
void EncodeBlock(std::span<const std::uint8_t, block_bytes> bytes, std::span<char, block_digits> digits) {
    std::uint64_t value{};
    for (std::size_t index = 0; index < bytes.size(); ++index) {
        value |= static_cast<std::uint64_t>(bytes[index]) << (index * 8);
    }
    for (auto &digit : digits) {
        digit = alphabet[static_cast<std::size_t>(value % radix)];
        value /= radix;
    }
}

/**
 * Rejects invalid or overflowing groups before writing their little-endian bytes.
 */
bool DecodeBlock(std::span<const char, block_digits> digits, std::span<std::uint8_t, block_bytes> bytes) {
    std::uint64_t value{};
    for (std::size_t remaining = digits.size(); remaining > 0; --remaining) {
        const auto digit = alphabet.find(digits[remaining - 1]);
        if (digit == std::string_view::npos) {
            return false;
        }
        const auto digit_value = static_cast<std::uint64_t>(digit);
        if (value > (std::numeric_limits<std::uint64_t>::max() - digit_value) / radix) {
            return false;
        }
        value = value * radix + digit_value;
    }
    for (auto &byte : bytes) {
        byte = static_cast<std::uint8_t>(value & 0xFFU);
        value >>= 8;
    }
    return true;
}

} // namespace

TextKey KeyFromText(std::string_view name) {
    TextKey key{};
    name = name.substr(0, name.find('\0'));
    std::ranges::transform(name.substr(0, key.size()), key.begin(), [](char byte) { return static_cast<std::uint8_t>(byte); });
    return key;
}

std::optional<std::string> Encode(std::span<const std::uint8_t> data, std::span<const std::uint8_t> key) {
    if (data.size() < block_bytes || data.size() % block_bytes != 0) {
        return std::nullopt;
    }
    std::string text;
    const auto  groups = data.size() / block_bytes;
    if (groups > text.max_size() / block_digits) {
        return std::nullopt;
    }
    std::vector<std::uint8_t> bytes(data.begin(), data.end());
    auto                      payload = std::span(bytes).first(bytes.size() - 2);
    const auto                checksum = static_cast<std::uint16_t>(Checksum(payload) ^ Checksum(key) ^ 0x62D3U);
    bytes[bytes.size() - 2] = static_cast<std::uint8_t>(checksum & 0xFFU);
    bytes.back() = static_cast<std::uint8_t>(checksum >> 8);
    Scramble(payload, checksum);
    std::swap(bytes[bytes.size() - 2], bytes[ChecksumIndex(payload.size())]);
    text.resize(groups * block_digits);
    for (std::size_t group = 0; group < groups; ++group) {
        EncodeBlock(std::span(bytes).subspan(group * block_bytes, block_bytes).first<block_bytes>(),
                    std::span(text).subspan(group * block_digits, block_digits).first<block_digits>());
    }
    return text;
}

std::optional<std::vector<std::uint8_t>> Decode(std::string_view text, std::size_t expected_bytes,
                                                std::span<const std::uint8_t> key) {
    if (expected_bytes < block_bytes || expected_bytes % block_bytes != 0) {
        return std::nullopt;
    }
    const auto groups = expected_bytes / block_bytes;
    if (groups > std::numeric_limits<std::size_t>::max() / block_digits || text.size() != groups * block_digits) {
        return std::nullopt;
    }
    std::vector<std::uint8_t> bytes;
    if (expected_bytes > bytes.max_size()) {
        return std::nullopt;
    }
    bytes.resize(expected_bytes);
    for (std::size_t group = 0; group < groups; ++group) {
        if (!DecodeBlock(std::span(text).subspan(group * block_digits, block_digits).first<block_digits>(),
                         std::span(bytes).subspan(group * block_bytes, block_bytes).first<block_bytes>())) {
            return std::nullopt;
        }
    }
    auto payload = std::span(bytes).first(bytes.size() - 2);
    std::swap(bytes[bytes.size() - 2], bytes[ChecksumIndex(payload.size())]);
    const auto checksum = static_cast<std::uint16_t>(bytes[bytes.size() - 2] |
                                                     (static_cast<std::uint16_t>(bytes.back()) << 8));
    Scramble(payload, checksum);
    if (checksum != static_cast<std::uint16_t>(Checksum(payload) ^ Checksum(key) ^ 0x62D3U)) {
        return std::nullopt;
    }
    return bytes;
}

std::optional<std::string> EncodeSphedaScore(std::span<const std::uint8_t, 9> holes,
                                             std::uint32_t password_key, std::string_view name) {
    std::array<std::uint8_t, 16> bytes{};
    std::ranges::copy(holes, bytes.begin());
    bytes[13] = static_cast<std::uint8_t>(password_key & 0xFFU);
    const auto key = KeyFromText(name);
    return Encode(bytes, key);
}

} // namespace dc2::password
