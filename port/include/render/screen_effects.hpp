#pragma once

#include <cstdint>

struct DepthOfFieldLevel {
    int width;
    int height;
};

// Pixel-free logical size of blur level `level` for a frame of frame_width x frame_height.
DepthOfFieldLevel DepthOfFieldLevelSize(int level, int frame_width, int frame_height);

// Reverse-Z depth of a point `distance` in front of the eye, as the meshes' projection writes it.
float DepthOfFieldDepth(float distance);

// The sun as the caller hands it over: x, y are mgTransWorldScreen's 12.4 units from the frame's
// top-left; depth is the reverse-Z depth of the sun's point (mgPortDepth of its GS Z).
struct LensFlareSun {
    int   x;
    int   y;
    float depth;
};

// The flare's textures as retail samples them: TCC 0 (alpha from TEXA) per texture, and the TEX1
// the composite leaves in the GS.
struct LensFlareSource {
    bool     first_alpha;
    bool     second_alpha;
    uint64_t tex1;
};

LensFlareSun LensFlareSunOf(const int screen[4]);
// False where retail returns before it touches its textures.
bool LensFlareInRange(const LensFlareSun &sun);
void LensFlareDraw(const LensFlareSun &sun, const float colour[4], const LensFlareSource &source);
