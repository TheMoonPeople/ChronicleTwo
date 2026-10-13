#pragma once

enum class TimingProfile {
    Pal,
    Ntsc,
};

// The first latch selects the session's timing. Later config changes apply on restart.
void TimingLatch(TimingProfile profile);
TimingProfile TimingGetProfile();
bool PortPalTiming();
