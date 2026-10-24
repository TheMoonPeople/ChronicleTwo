#pragma once

// Native Tracy events follow the game's debug-mode setting.
#ifdef CT_ENABLE_TRACY
#include <tracy/Tracy.hpp>

#include <atomic>

#include "gfx/profile.hpp"
#include "test_hooks.hpp"

namespace ct::profile {
inline std::atomic<bool> enabled{false}; /**< Whether native profiling events are active. */

/**
 * Reports whether debug mode currently enables profiling events.
 */
inline bool Enabled() {
    return enabled.load(std::memory_order_relaxed);
}

/**
 * Publishes the main thread's debug-mode setting to profiling workers.
 */
inline void RefreshEnabled() {
    const bool value = GameDebugEnabled();
    enabled.store(value, std::memory_order_relaxed);
    ::gfx::profile::SetEnabled(value);
}
} // namespace ct::profile

// KZ_FRAME_STATS adds each zone's time to the renderer's frame stats log too (gfx/profile.hpp).
#define CT_PROFILE_ZONE(name)     KZ_STATS_ZONE_(name);        ZoneNamedN(ct_profile_zone, name, ::ct::profile::Enabled())
#define CT_PROFILE_TEXT(text, size)                 \
    do {                                            \
        if (::ct::profile::Enabled()) {             \
            ZoneTextV(ct_profile_zone, text, size); \
        }                                           \
    } while (false)
#define CT_PROFILE_FRAME(name)          \
    do {                                \
        if (::ct::profile::Enabled()) { \
            FrameMarkNamed(name);       \
        }                               \
    } while (false)
#define CT_PROFILE_MAIN_FRAME()         \
    do {                                \
        if (::ct::profile::Enabled()) { \
            FrameMark;                  \
        }                               \
    } while (false)
#define CT_PROFILE_PLOT(name, value)    \
    do {                                \
        if (::ct::profile::Enabled()) { \
            TracyPlot(name, value);     \
        }                               \
    } while (false)
#define CT_PROFILE_THREAD(name)         \
    do {                                \
        if (::ct::profile::Enabled()) { \
            tracy::SetThreadName(name); \
        }                               \
    } while (false)
#define CT_PROFILE_REFRESH() ::ct::profile::RefreshEnabled()
#else
#define CT_PROFILE_ZONE(name)
#define CT_PROFILE_TEXT(text, size)
#define CT_PROFILE_FRAME(name)
#define CT_PROFILE_MAIN_FRAME()
#define CT_PROFILE_PLOT(name, value)
#define CT_PROFILE_THREAD(name)
#define CT_PROFILE_REFRESH()
#endif
