#include "play_time.hpp"

#include <cassert>
#include <cmath>

namespace {
double       g_rate = 0.0;
std::int64_t g_ticks = 0;
std::int64_t g_units = 0;
long double  g_fraction = 0.0L;
long double  g_span_fraction = 0.0L;
} // namespace

void PlayTimeReset() {
    g_rate = 0.0;
    g_ticks = g_units = 0;
    g_fraction = g_span_fraction = 0.0L;
}

std::int64_t PlayTimeTick(bool enabled, double rate) {
    if (!enabled) {
        return 0;
    }
    assert(std::isfinite(rate) && rate > 0.0);
    if (rate != g_rate) {
        g_rate = rate;
        g_ticks = g_units = 0;
        g_span_fraction = g_fraction;
    }
    ++g_ticks;
    std::int64_t total;
    if (rate == 50.0 || rate == 60.0) {
        // Integer division gives the exact whole budget at both supported rates.
        // Only the fractional carry from an earlier live rate needs floating point.
        const std::int64_t numerator = rate == 50.0 ? g_ticks : (g_ticks % 6) * 5;
        const std::int64_t denominator = rate == 50.0 ? 1 : 6;
        const long double  remainder = g_span_fraction + static_cast<long double>(numerator % denominator) / denominator;
        const auto         carry = static_cast<std::int64_t>(remainder);
        total = (rate == 50.0 ? g_ticks : (g_ticks / 6) * 5 + numerator / denominator) + carry;
        g_fraction = remainder - carry;
    } else {
        // A cumulative budget avoids repeatedly rounding the same per-tick fraction.
        const long double budget = g_span_fraction + static_cast<long double>(g_ticks) * 50.0L / rate;
        total = static_cast<std::int64_t>(budget);
        g_fraction = budget - total;
    }
    const auto added = total - g_units;
    g_units = total;
    return added;
}
