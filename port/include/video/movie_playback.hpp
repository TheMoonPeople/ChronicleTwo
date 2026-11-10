#pragma once

#include <chrono>
#include <cstdint>
#include <filesystem>
#include <string_view>

namespace dc2::video {
/**
 * Resolves a retail movie name to its native MP4 path.
 */
std::filesystem::path MoviePath(std::string_view name);
} // namespace dc2::video

/** Mixer port reserved for movie audio outside the game's sound-effect ports. */
inline constexpr int kMoviePortAudioPort = 5;

/**
 * Returns the most recent playback time in 90 kHz units.
 */
int64_t MoviePortClock();

/** Two-second allowance for stalled pictures in 90 kHz units. */
inline constexpr int64_t kMoviePortOverrun = 2 * int64_t{90000};

/**
 * Reports playback beyond a known duration and the stall allowance in 90 kHz units.
 */
bool MoviePortOverran(int64_t elapsed, int64_t length);

/**
 * Supplies the host time for deterministic movie playback tests.
 */
using MoviePortNow = std::chrono::steady_clock::time_point (*)();
/**
 * Overrides the movie host clock or restores the steady clock when null.
 */
void MoviePortSetNow(MoviePortNow now);
