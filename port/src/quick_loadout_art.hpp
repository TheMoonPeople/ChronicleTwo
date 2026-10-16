#pragma once

#include <cstdint>
#include <vector>

// The quick loadout panel's picture, drawn in code from shapes (none of the game's pictures): a copper frame with
// bolts, a grey plate, the "QUICK LOADOUT" title tab and four slots, each with its face button's disc in the top left.
// Laid out in units of a 381x305 board, after Javier's mockup; scale is the pixels per unit.
struct QuickLoadoutArt {
    int                  width = 0;
    int                  height = 0;
    std::vector<uint8_t> rgba; // rows top to bottom, straight alpha, 0xFF opaque
};

inline constexpr float kQuickLoadoutArtWidth = 381.0f;
inline constexpr float kQuickLoadoutArtHeight = 305.0f;

// The inside of each slot, in board units: Triangle, Square, Cross, Circle.
struct QuickLoadoutArtRect {
    float x0, y0, x1, y1;
};
inline constexpr QuickLoadoutArtRect kQuickLoadoutSlotArt[4] = {
    {31, 56, 189, 161}, {208, 56, 354, 161}, {31, 181, 189, 286}, {208, 181, 354, 286}};

QuickLoadoutArt QuickLoadoutDrawPanel(int scale);
