#include "common.h"

#include <eekernel.h>

#include <algorithm>
#include <chrono>
#include <cstdint>

#include "mglib.hpp"
#include "platform/clock.hpp"
#include "platform/frame_timing.hpp"

// The VSync count is ClockTickCount(). Only the secondary callback and the rotate priority are kept here.
// VSyncField is the one global the game reads; it is written in place.

namespace {

int (*g_secondary_callback)(int) = nullptr;
int                                   g_rotate_priority = -1;
std::chrono::steady_clock::time_point g_frame_begin;
std::int64_t                          g_frame_begin_tick = 0;

} // namespace

int dc2::timing::OnVerticalBlank(int field) {
    VSyncField = !(ClockTickCount() & 1);
    if (g_secondary_callback != nullptr) {
        g_secondary_callback(field);
    }
    return 0;
}

void mgInitVSyncCallBack(int (*callback)(int)) {
    g_secondary_callback = callback;
}

void mgSetRotateThread(int priority) {
    g_rotate_priority = priority;
}

void WaitVSync(int start, int frames) {
    while (ClockTickCount() - start < frames) {
        if (g_rotate_priority > 0) {
            RotateThreadReadyQueue(g_rotate_priority);
        }
        ClockWaitNextTick();
        ClockPump();
    }
}

void dc2::timing::WaitTicks(int start, int frames, ClockWaitHook hook) {
    while (ClockTickCount() - start < frames) {
        if (g_rotate_priority > 0) {
            RotateThreadReadyQueue(g_rotate_priority);
        }
        ClockWaitNextTick(hook);
        ClockPump();
    }
}

int mgGetVSyncCount() {
    return static_cast<int>(ClockTickCount());
}

void dc2::timing::BeginFrame() {
    g_frame_begin = std::chrono::steady_clock::now();
    g_frame_begin_tick = ClockTickCount();
}

float dc2::timing::FrameFields() {
    if (ClockUnbounded()) {
        const auto tick = ClockTickCount();
        // Resetting the clock starts a new span, even if a frame was already open.
        g_frame_begin_tick = std::min(tick, g_frame_begin_tick);
        return static_cast<float>(tick - g_frame_begin_tick);
    }
    const std::chrono::duration<double> elapsed = std::chrono::steady_clock::now() - g_frame_begin;
    return static_cast<float>(elapsed.count() * ClockTickRate());
}
