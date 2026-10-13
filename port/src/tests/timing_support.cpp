#include "timing_support.hpp"

// These definitions satisfy the test link before ct_timing's archive is considered.
// No state-reset function or conditional test hook is compiled into the game.
#include "../timing.cpp"

ScopedTimingProfile::ScopedTimingProfile(std::optional<TimingProfile> profile)
    : latched_(PortTimingLatched), profile_(g_profile), tick_rate_(g_tick_rate), fell_back_(g_fell_back) {
    PortTimingLatched = false;
    g_fell_back = false;
    if (profile) {
        TimingLatch(*profile);
    }
}

ScopedTimingProfile::~ScopedTimingProfile() {
    PortTimingLatched = latched_;
    g_profile = profile_;
    PortTimingIsPal = profile_ == TimingProfile::Pal;
    g_tick_rate = tick_rate_;
    g_fell_back = fell_back_;
}
