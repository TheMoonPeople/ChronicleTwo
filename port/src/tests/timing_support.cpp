#include "timing_support.hpp"

// These definitions satisfy the test link before ct_timing's archive is considered.
// No state-reset function or conditional test hook is compiled into the game.
#include "../timing.cpp"

ScopedTimingProfile::ScopedTimingProfile(std::optional<TimingProfile> profile)
    : latched_(g_latched), profile_(g_profile) {
    g_latched = false;
    if (profile) {
        TimingLatch(*profile);
    }
}

ScopedTimingProfile::~ScopedTimingProfile() {
    g_latched = latched_;
    g_profile = profile_;
}
