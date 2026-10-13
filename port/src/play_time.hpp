#pragma once

#include <cstdint>

// Saved play time is measured in 1/50 s units. Disabled ticks retain fractional credit.
std::int64_t PlayTimeTick(bool enabled, double rate);
void PlayTimeReset();
