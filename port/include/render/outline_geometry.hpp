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
