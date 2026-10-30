#pragma once

#include <span>
#include <string_view>

#include "mg_tanime.hpp"

class mgCDrawPrim;

namespace dc2::text {

/**
 *
 * Names the menu atlas's two letterings.
 *
 */
enum class MenuLettering {
    Words, /**< The pause menu's words. */
    Board, /**< The time board's words and figures. */
};

/**
 *
 * Letters a pause menu word or time board word in place of the menu atlas cell the prim is about to draw.
 *
 */
bool DrawMenuLabel(mgCDrawPrim &prim, mgRect<float> put, mgRect<int> uv);

/**
 *
 * Letters the time board figure held by a cell of the menu atlas's digit strip.
 *
 */
bool DrawMenuFigure(mgCDrawPrim &prim, mgRect<int> put, mgRect<int> uv);

/**
 *
 * Places a lettering's font in its cells, in texels.
 *
 */
struct MenuLabelGeometry {
    float em;       /**< Em of the font in texels. */
    float start;    /**< Texels from the cell's left edge to the pen. */
    float baseline; /**< Texels from the cell's top to the baseline. */
};

/**
 *
 * Returns where a lettering's font sets its words.
 *
 */
MenuLabelGeometry MenuLabelGeometryOf(MenuLettering lettering);

/**
 *
 * Describes a word the English menu atlas paints.
 *
 */
struct MenuLabelWord {
    const char      *cell; /**< Name of the word's cell in the menu layout, in Shift-JIS. */
    std::string_view text; /**< Text of the word. */
    float            dx;   /**< Texels the word sits right of its lettering's pen. */
    float            dy;   /**< Texels the word sits below its lettering's baseline. */
};

/**
 *
 * Returns the words of a lettering.
 *
 */
std::span<const MenuLabelWord> MenuLabelWords(MenuLettering lettering);

} // namespace dc2::text
