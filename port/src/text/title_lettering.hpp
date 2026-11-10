#pragma once

#include <array>
#include <span>
#include <string_view>

#include "mg_tanime.hpp"

class mgCDrawPrim;

namespace dc2::text {

/**
 *
 * Draws a language or title menu button as a blank plate lettered in ChronicleTwoTitle in place of its painted cell.
 *
 */
bool DrawTitleLettering(mgCDrawPrim &prim, float x, float y, mgRect<int> cell);

/**
 *
 * Describes one of the nine pieces a blank plate is drawn from, in texels from its cell's top-left.
 *
 */
struct TitlePlatePiece {
    float src_x; /**< Left of the atlas texels sampled. */
    float src_y; /**< Top of the atlas texels sampled. */
    float src_w; /**< Width of the atlas texels sampled. */
    float src_h; /**< Height of the atlas texels sampled. */
    float dst_x; /**< Left of where the piece lands. */
    float dst_y; /**< Top of where the piece lands. */
    float dst_w; /**< Width of where the piece lands. */
    float dst_h; /**< Height of where the piece lands. */
};

/**
 *
 * Returns the pieces that draw a blank plate of a given size from the painted cell at an atlas position.
 *
 */
std::array<TitlePlatePiece, 9> TitlePlatePieces(int cell_x, int cell_y, float w, float h);

/**
 *
 * Describes a lettered cell of the language or title atlas and the text each language's cell paints.
 *
 */
struct TitleLabel {
    int              x;        /**< Left of the cell in the atlas. */
    int              y;        /**< Top of the cell in the atlas. */
    int              w;        /**< Width of the cell. */
    int              h;        /**< Height of the cell. */
    int              plate_dy; /**< Texels below the cell's top that its plate starts, less one. */
    std::string_view text[5];  /**< Text of each PAL language, indexed by LanguageCode - LANG_ENGLISH. */
};

/**
 *
 * Returns the language menu's buttons.
 *
 */
std::span<const TitleLabel> TitleLanguageLabels();

/**
 *
 * Returns the title menu's buttons.
 *
 */
std::span<const TitleLabel> TitleMenuLabels();

/**
 *
 * Returns the title screen's Push START lines.
 *
 */
std::span<const TitleLabel> TitlePushStartLabels();

} // namespace dc2::text
