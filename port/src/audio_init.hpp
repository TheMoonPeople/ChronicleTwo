#pragma once

// False only when a device was requested and could not be opened. True when output runs, when a WAV
// capture is open, or when <prefix>_AUDIO=off.
// Headless runs advance the full mixer from logic ticks without a playback device.
bool AudioInit(bool headless = false);

// Prevents the stream-only fallback from advancing streams a second time.
bool AudioUsesTickClock();

void AudioShutdown();
