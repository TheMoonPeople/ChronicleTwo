#pragma once

#include <array>
#include <cstddef>
#include <cstdint>
#include <optional>
#include <span>
#include <string>
#include <string_view>
#include <vector>

namespace dc2::password {

/**
 * Holds the format's twenty-byte, zero-padded name key.
 */
using TextKey = std::array<std::uint8_t, 20>;

/**
 * Builds a zero-padded checksum key from the name's first twenty bytes.
 */
[[nodiscard]] TextKey KeyFromText(std::string_view name);

/**
 * Encodes complete eight-byte groups, reserving the final two bytes for the keyed checksum.
 */
[[nodiscard]] std::optional<std::string> Encode(std::span<const std::uint8_t> data,
                                                std::span<const std::uint8_t> key);

/**
 * Encodes nine Spheda hole scores and the password key's low byte without reading record padding.
 */
[[nodiscard]] std::optional<std::string> EncodeSphedaScore(std::span<const std::uint8_t, 9> holes,
                                                           std::uint32_t password_key, std::string_view name);

/**
 * Returns exactly the requested decoded extent only after validating every digit and the keyed checksum.
 */
[[nodiscard]] std::optional<std::vector<std::uint8_t>> Decode(std::string_view text, std::size_t expected_bytes,
                                                              std::span<const std::uint8_t> key);

} // namespace dc2::password
