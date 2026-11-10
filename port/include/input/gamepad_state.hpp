#pragma once

namespace dc2::input {

/**
 * Stops the controller worker and releases its captured controller before that controller retires.
 */
void StopControllerThread();

} // namespace dc2::input
