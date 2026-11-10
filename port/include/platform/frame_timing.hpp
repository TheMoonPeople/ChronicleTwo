#pragma once

#include "platform/clock.hpp"

namespace dc2::timing {

/**
 * Records the host and logic clocks at the beginning of a displayed frame.
 */
void BeginFrame();

/**
 * Measures the current frame's elapsed time in vertical-blank fields.
 */
float FrameFields();

/**
 * Waits for a logic-tick interval while servicing the caller's display hook.
 */
void WaitTicks(int start, int frames, ClockWaitHook hook);

/**
 * Publishes the current vertical-blank field and invokes the game's secondary callback.
 */
int OnVerticalBlank(int field);

} // namespace dc2::timing
