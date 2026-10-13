#include "timing.hpp"

#include <cassert>

namespace {
TimingProfile g_profile = TimingProfile::Pal;
double        g_tick_rate = 50;
} // namespace

bool PortTimingIsPal = true;
bool PortTimingLatched = false;

void TimingLatch(TimingProfile profile, double tick_rate) {
    if (!PortTimingLatched) {
        g_profile = profile;
        PortTimingIsPal = profile == TimingProfile::Pal;
        g_tick_rate = tick_rate;
        PortTimingLatched = true;
    }
}

TimingProfile TimingGetProfile() {
    assert(PortTimingLatched && "gameplay timing must be latched before use");
    return g_profile;
}

void TimingUsePalFallback() {
    assert(PortTimingLatched && "gameplay timing must be latched before use");
    g_profile = TimingProfile::Pal;
    PortTimingIsPal = true;
    g_tick_rate = 50;
}

double TimingGetTickRate() {
    assert(PortTimingLatched && "gameplay timing must be latched before use");
    return g_tick_rate;
}
