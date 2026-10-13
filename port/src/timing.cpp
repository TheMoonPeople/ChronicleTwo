#include "timing.hpp"

#include <cassert>

namespace {
bool g_latched = false;
TimingProfile g_profile = TimingProfile::Pal;
}

void TimingLatch(TimingProfile profile) {
    if (!g_latched) {
        g_profile = profile;
        g_latched = true;
    }
}

TimingProfile TimingGetProfile() {
    assert(g_latched && "gameplay timing must be latched before use");
    return g_profile;
}

bool PortPalTiming() {
    return TimingGetProfile() == TimingProfile::Pal;
}
