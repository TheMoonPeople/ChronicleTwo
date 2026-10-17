#pragma once

#include <cstdint>
#include <string>
#include <vector>

#include "platform/settings.hpp"

struct PresentSettings {
    bool interpolation = true;
    // 0 leaves the pace to the present mode.
    double max_fps = 0.0;
    // An unbounded clock has no real time to fill, so display renders are made per tick at evenly spaced alphas and discarded.
    int display_per_tick = 0;
    bool show_fps = false;
    ConfigFpsDetail fps_detail = ConfigFpsDetail::All;
    bool fps_detail_budget = false;
    bool log_fps = false;
    // When the last tick's draw count exceeds this, interpolated display frames are skipped (0 = never).
    int interpolation_draw_budget = 0;
    // When rolling present FPS is below this, skip tweened frames until it recovers (0 = off).
    int interpolation_fps_floor = 0;
    // When false, at most one tweened present per tick wait (better for 60 Hz targets).
    bool interpolation_multi_present = false;
};

struct PresentStats {
    std::uint64_t ticks = 0;
    std::uint64_t display_frames = 0;
    std::uint64_t presented = 0;
    std::uint64_t canonical_presents = 0;
    std::uint32_t last_draws = 0;
};

struct FrameBudgetAverages {
    double canonical_ms = 0.0;
    double display_ms = 0.0;
    double other_ms = 0.0;
};

void PresentFrameBudgetTickBegin();
void PresentFrameBudgetAddCanonical(double seconds);
void PresentFrameBudgetTickCommit();

FrameBudgetAverages PresentFrameBudgetAverages();
void PresentFrameBudgetResetForTest();
void PresentFrameBudgetInjectTickForTest(double canonical_seconds, double display_seconds, double other_seconds);

bool                   PresentMouseActive();
void PresentSetSettings(const PresentSettings &settings);
const PresentSettings &PresentGetSettings();
PresentStats PresentGetStats();
void PresentResetStats();
void PresentTickRendered();
void PresentWaitFrame(int start, int frames);
void PresentTickEnd();
std::string PresentFpsText();
// Frame-exit screenshot renders, outside a frame. They present, which is what ReadbackFrame reads.
bool PresentScreenshotDisplay(float alpha, std::vector<uint8_t> &rgba, uint32_t &width, uint32_t &height);
bool PresentScreenshotFps(std::vector<uint8_t> &rgba, uint32_t &width, uint32_t &height);
