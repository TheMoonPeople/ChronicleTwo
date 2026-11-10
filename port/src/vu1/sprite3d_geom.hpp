#pragma once

#include "vu1/vu1_math.hpp"

namespace dc::vu1 {

struct Sprite3dParams {
    Mat4 ls;  // local to screen
    Vec4 vs0; // view_screen row 0, scaled by the matrix row norm
    Vec4 vs1; // view_screen row 1, scaled by the matrix row norm
    Fog  fog;
    // Cull bounds: x/y screen extents, w = near / far.
    Vec4 guard_min;
    Vec4 guard_max;
};

struct Sprite3dRecord {
    Vec4 pos;
    Vec4 size;   // {w, h, sin, cos}
    Vec4 colour; // GS colour scale (0x80 = 1.0), unclamped
    Vec4 uv0;    // texels
    Vec4 uv1;    // texels
};

struct Sprite3dVertexF {
    float x, y; // GS screen pixels, 2048-centred, unquantised
    float z;    // projected depth, GS Z units, unquantised
    float u, v; // texels
    float fog;  // [0, 1], 1 = no fog
};

struct Sprite3dQuadF {
    bool            drawn;
    int             count; // 2 (mode 0: min, max) or 4 (strip v0..v3)
    Sprite3dVertexF v[4];
    float           rgba[4]; // GS colour scale, unclamped
};

Sprite3dQuadF Sprite3dExpandNative(const Sprite3dParams &p, const Sprite3dRecord &r, int mode);

} // namespace dc::vu1
