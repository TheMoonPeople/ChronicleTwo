#include "play_time.hpp"

namespace {
// Fractional saved units in sixths: each enabled NTSC tick contributes five.
int g_credit = 0;
} // namespace

void PlayTimeReset() {
    g_credit = 0;
}

std::int64_t PlayTimeTick(bool enabled) {
    if (!enabled) {
        return 0;
    }
    g_credit += 5;
    const int units = g_credit / 6;
    g_credit %= 6;
    return units;
}
