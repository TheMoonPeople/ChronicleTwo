#pragma once

namespace dc2::log {
/**
 *
 * Writes game diagnostics to stdout and the game logging category.
 *
 */
[[gnu::format(printf, 1, 2)]] int PrintGame(const char *format, ...);
} // namespace dc2::log
