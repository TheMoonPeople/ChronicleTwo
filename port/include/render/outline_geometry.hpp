#pragma once

#include "render/renderer.hpp"

// Screen-relative corners in GS 12.4: 16 units to the logical pixel, as retail's outline draws them.
struct OutlineBox {
    int left;
    int top;
    int right;
    int bottom;
};

inline constexpr int kOutlinePad = 0x80;

// Retail's scale: at most 1, then squared.
float OutlineScale(float scale);
// The edge's thickness in 12.4, from its width and the squared scale.
int OutlineEdgeOffset(float width, float squared_scale);
// The frame's draw box (mgGetDrawRect's min and max, logical) clamped to the visible extent.
OutlineBox OutlineDrawBox(const float *box_min, const float *box_max, const mgPortExtent &extent);
// The box outset by kOutlinePad, clamped to the visible extent.
OutlineBox OutlinePaddedBox(const OutlineBox &box, const mgPortExtent &extent);

// Logical pixels a display frame's object may lie beyond the box between its two ticks' poses and cameras.
inline constexpr float kOutlineDisplayMargin = 12.0f;
// The part of the visible extent a display frame's composite covers: this tick's padded box and, when it was drawn
// on the tick before, that tick's, outset by the edge and by kOutlineDisplayMargin.
mgPortExtent OutlineDisplayExtent(const OutlineBox &box, const OutlineBox *previous, int edge_offset,
                                  const mgPortExtent &extent);
