#pragma once

#include <cstdint>

// Six enabled NTSC ticks add five saved 1/50 s units. Disabled ticks retain fractional credit.
std::int64_t PlayTimeTick(bool enabled);
void         PlayTimeReset();
