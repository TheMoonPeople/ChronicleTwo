#pragma once

#include <cstdint>
#include <functional>
#include <string>
#include <vector>

#include "gfx/gfx.hpp"
#include "platform/settings.hpp"

struct PresentSettings {
    bool interpolation = true;
    // 0 leaves the pace to the present mode.
    double max_fps = 0.0;
    // An unbounded clock has no real time to fill, so display renders are made per tick at evenly spaced alphas and discarded.
    int             display_per_tick = 0;
    bool            show_fps = false;
    ConfigFpsDetail fps_detail = ConfigFpsDetail::All;
    bool            log_fps = false;
};

struct PresentStats {
    std::uint64_t ticks = 0;
    std::uint64_t display_frames = 0;
    std::uint64_t presented = 0;
    std::uint64_t canonical_presents = 0;
    std::uint64_t unfinished_pairs = 0; /**< Authored frames a newer tick replaced before both images were shown. */
    std::uint64_t replay_ticks = 0;     /**< Ticks presented by replay rather than as an authored pair. */
    std::uint32_t last_draws = 0;
};

bool                   PresentMouseActive();
void                   PresentSetSettings(const PresentSettings &settings);
const PresentSettings &PresentGetSettings();
PresentStats           PresentGetStats();
void                   PresentResetStats();
void                   PresentTickRendered();
void                   PresentWaitFrame(int start, int frames);
// Async only: hands the tick just rendered to the render thread, whose frame began at tick `start` and lasts `frames`.
// Called by the game thread holding a render lease.
void        PresentPublishTick(int start, int frames, bool canonical_endpoint_allowed = true);
// Async only: PresentPublishTick's game-thread part. The returned publication runs on the device thread once the tick's
// canonical render has run; it is empty without a render thread.
std::function<void()> PresentPrepareTick(int start, int frames, bool canonical_endpoint_allowed);
void        PresentTickEnd();
std::string PresentFpsText();
// Frame-exit screenshot renders, outside a frame. They present, which is what ReadbackFrame reads.
bool PresentScreenshotDisplay(float alpha, std::vector<uint8_t> &rgba, uint32_t &width, uint32_t &height);
bool PresentScreenshotFps(std::vector<uint8_t> &rgba, uint32_t &width, uint32_t &height);

namespace dc2::presentation {
/**
 * Retires a pending endpoint before a new canonical render can replace its image.
 */
void BeforeCanonical();
} // namespace dc2::presentation
