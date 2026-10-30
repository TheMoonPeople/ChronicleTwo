#pragma once

#include <cstdint>
#include <span>

// Only the ordinary ASCII entries of the loaded retail lookup table are qualified for sharp text.
// Zero means keep the original glyph. European extensions, gaiji and Japanese stay original.
char32_t FontPortCharacter(int language, int glyph, std::span<const std::uint8_t> table);
