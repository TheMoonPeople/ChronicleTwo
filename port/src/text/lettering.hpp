#pragma once

#include <cstddef>
#include <string_view>

#include "font.hpp"

class mgCDrawPrim;

namespace dc2::text {

/**
 *
 * Describes painted lettering: its fill over the dark of its rim and drop shadow, in texels of the art it replaces.
 *
 */
struct LetteringStyle {
    dc2::font::Typeface typeface;     /**< Typeface the text is set in. */
    float               rim;          /**< Rim radius in texels, 0 for none. */
    float               shadow_x;     /**< Texels the shadow is cast right. */
    float               shadow_y;     /**< Texels the shadow is cast down. */
    float               shadow_floor; /**< Shadow opacity where it is furthest from the letters. */
    float               fill;         /**< Grey level of the letters. */
    float               dark[3];      /**< Colour of the rim and the shadow. */
};

/**
 *
 * Names the point of the text that the x given to DrawLettering sits on.
 *
 */
enum class LetteringAlign {
    Pen,       /**< The pen where the text starts. */
    InkCentre, /**< The middle of the text's ink. */
};

/**
 *
 * Draws UTF-8 text in a style through a prim in its colour, rendered at the target's resolution on whole pixels.
 *
 */
bool DrawLettering(mgCDrawPrim &prim, const LetteringStyle &style, std::string_view text, float x, float base_y,
                   float em_x, float em_y, float texel_x, float texel_y, LetteringAlign align = LetteringAlign::Pen);

/**
 *
 * Returns how far text moves the pen in ems, or 0 where the typeface is missing.
 *
 */
float LetteringAdvance(dc2::font::Typeface typeface, std::string_view text);

/**
 *
 * Decodes the next UTF-8 character at an offset and moves past it, giving U+FFFD for a malformed byte.
 *
 */
char32_t NextCharacter(std::string_view text, std::size_t &at);

} // namespace dc2::text
