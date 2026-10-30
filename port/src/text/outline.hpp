#pragma once

#include <cstdint>
#include <span>
#include <vector>

namespace dc2::text {

/**
 *
 * Names the round rims the sharp message font draws for retail's stepped outline styles.
 *
 */
enum class Outline {
    Thin,  /**< FUCHI_OUTLINE: one copy each side, a pixel out. */
    Thick, /**< FUCHI_OUTLINE_THICK: eight copies a pixel out and four two out. */
    Glow,  /**< FUCHI_OUTLINE_WIDE: four faint copies two out. */
};

/**
 *
 * Returns a rim's opacity a distance in logical pixels outside the glyph's edge, 1 at its strongest.
 *
 */
float OutlineOpacity(Outline outline, float distance);

/**
 *
 * Returns how far past the glyph's edge a rim reaches, in logical pixels.
 *
 */
float OutlineReach(Outline outline);

/**
 *
 * Returns the share of the text's alpha a rim is drawn with.
 *
 */
float OutlineAlpha(Outline outline);

/**
 *
 * Holds a rim drawn around a glyph's coverage, the glyph included.
 *
 */
struct OutlineImage {
    std::vector<std::uint8_t> alpha;        /**< Coverage of the image, 0 to 255. */
    int                       margin_x = 0; /**< Pixels the image extends past the glyph on each side. */
    int                       margin_y = 0; /**< Pixels the image extends above and below the glyph. */
};

/**
 *
 * Draws an outline style's rim around a glyph's coverage at the given target pixels per logical pixel.
 *
 */
OutlineImage OutlineRim(std::span<const std::uint8_t> coverage, int width, int height, float px_x, float px_y,
                        Outline outline);

/**
 *
 * Draws a rim of a given radius in logical pixels around a glyph's coverage, with the same half-pixel soft edge.
 *
 */
OutlineImage OutlineRimOf(std::span<const std::uint8_t> coverage, int width, int height, float px_x, float px_y,
                          float radius);

/**
 *
 * Returns each pixel's distance in logical pixels from the glyph's edge across an image holding it at a margin.
 *
 */
std::vector<float> OutlineDistance(std::span<const std::uint8_t> coverage, int width, int height, float px_x,
                                   float px_y, int margin_x, int margin_y, int image_width, int image_height);

} // namespace dc2::text
