#pragma once

#include "pal_timing.hpp"

enum class TimingProfile {
    Pal,
    Ntsc,
};

// The first latch selects the session's timing. Later config changes apply on restart.
void          TimingLatch(TimingProfile profile, double tick_rate = 50);
TimingProfile TimingGetProfile();
double        TimingGetTickRate();
// Startup validation may select PAL/50 for this session before the clock and game start.
void TimingUsePalFallback();
