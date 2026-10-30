#pragma once

#include "render/renderer.hpp"

// Camera cuts are signalled by the camera owner, never inferred from screen
// distance: a continuous mouse turn can move an anchor across the whole view.
struct ScreenOverlayAnchor {
    unsigned long long generation = 0;
    bool               valid = false;

    bool Update(int /*unused*/, int /*unused*/) {
        const auto next = mgPortCameraGeneration();
        const bool cut = valid && generation != next;
        generation = next;
        valid = true;
        return cut;
    }
};
