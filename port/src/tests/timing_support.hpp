#pragma once

#include <optional>

#include "timing.hpp"

// The test executable compiles the real implementation with access to its private state.
// An empty profile models startup before the first latch.
class ScopedTimingProfile {
public:
    explicit ScopedTimingProfile(std::optional<TimingProfile> profile = std::nullopt);
    ~ScopedTimingProfile();
    ScopedTimingProfile(const ScopedTimingProfile &) = delete;
    ScopedTimingProfile &operator=(const ScopedTimingProfile &) = delete;

private:
    bool latched_;
    TimingProfile profile_;
};
