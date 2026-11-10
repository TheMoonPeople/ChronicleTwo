#include "audio_init.hpp"

#include <algorithm>
#include <array>
#include <cstdint>
#include <cstring>

#include "audio/mixer.hpp"
#include "log/log.hpp"
#include "platform/audio.hpp"
#include "platform/clock.hpp"
#include "platform/settings.hpp"

namespace {

bool         g_tick_audio = false;
std::int64_t g_last_tick = 0;
double       g_fraction = 0.0;
double       g_span_fraction = 0.0;
double       g_tick_rate = 0.0;
std::int64_t g_span_start = 0;
std::int64_t g_span_frames = 0;

void RenderTicks() {
    const auto   tick = ClockTickCount();
    const double rate = ClockTickRate();
    if (rate != g_tick_rate || tick < g_last_tick) {
        g_span_start = tick < g_last_tick ? tick : g_last_tick;
        g_span_fraction = g_fraction;
        g_span_frames = 0;
        g_tick_rate = rate;
    }
    g_last_tick = tick;
    auto &mixer = audio::DefaultMixer();
    // Compute the cumulative budget before truncation, so fractional samples cannot lose a whole
    // sample through repeated addition. Keep the remainder when the tick rate changes.
    const double budget = g_span_fraction + static_cast<double>(tick - g_span_start) * mixer.Rate() / rate;
    const auto   total = static_cast<std::int64_t>(budget);
    auto         frames = total - g_span_frames;
    g_span_frames = total;
    g_fraction = budget - static_cast<double>(total);
    std::array<float, 2048> samples{};
    while (frames > 0) {
        const int count = static_cast<int>(std::min<std::int64_t>(frames, samples.size() / 2));
        mixer.Render(samples.data(), count);
        frames -= count;
    }
}

void RenderMixer(void *user, float *out, int frames) {
    // The device thread's first callback readies its log queue, so a later line from it never allocates.
    thread_local const bool log_ready = (LogThreadReady(), true);
    static_cast<void>(log_ready);
    // Mixer::Render takes the mixer's own lock, and every game-thread setter takes it too, so the
    // device thread needs no lock of its own here.
    static_cast<audio::Mixer *>(user)->Render(out, frames);
}

// AudioOutputStart returns false for "off" and for a failed device alike, so "off" is recognised
// here before the platform layer is asked. The WAV capture outranks "off" there and must here too.
bool OutputDisabled() {
    if (const char *wav = SettingsEnv("AUDIO_WAV"); wav != nullptr && *wav != '\0') {
        return false;
    }
    const char *setting = SettingsEnv("AUDIO");
    return setting != nullptr && std::strcmp(setting, "off") == 0;
}

} // namespace

bool AudioUsesTickClock() {
    return g_tick_audio;
}

bool AudioInit(bool headless) {
    if (headless) {
        // Stream levels and completion are game inputs (voice animation and script waits).
        // Device callbacks run in real time, while headless VSyncs run as fast as possible.
        // A requested WAV capture already renders from VSyncs in the platform layer.
        const char *wav = SettingsEnv("AUDIO_WAV");
        if (wav == nullptr || *wav == '\0') {
            g_tick_audio = true;
            g_last_tick = ClockTickCount();
            g_fraction = 0.0;
            g_span_fraction = 0.0;
            g_tick_rate = ClockTickRate();
            g_span_start = g_last_tick;
            g_span_frames = 0;
            ClockAddPumpHook(RenderTicks);
            return true;
        }
    }
    if (OutputDisabled()) {
        return true;
    }
    audio::Mixer &mixer = audio::DefaultMixer();
    return AudioOutputStart(mixer.Rate(), RenderMixer, &mixer);
}

void AudioShutdown() {
    ClockRemovePumpHook(RenderTicks);
    g_tick_audio = false;
    g_fraction = 0.0;
    AudioOutputStop();
}
