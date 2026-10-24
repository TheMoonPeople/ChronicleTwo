#include "common.h"

#include <SDL3/SDL_platform.h>

#include <algorithm>
#include <atomic>
#include <cmath>
#include <cstdint>
#include <vector>

#include "audio/mixer.hpp"
#include "audio/synth.hpp"
#include "controller_speaker.hpp"
#include "dng_main.hpp"
#include "dualsense_haptics.hpp"
#include "event_func.hpp"
#include "mainloop.hpp"
#include "mainloop_port.hpp"
#include "platform/config.hpp"
#include "sceneseq.hpp"
#include "scenesnd.hpp"
#ifdef SDL_PLATFORM_IOS
#include "ios/ios.hpp"
#endif

namespace {

constexpr float kTwoPi = 6.28318530718f;
constexpr float kRate = static_cast<float>(audio::kSpuRate);

// The DualShock 2's large motor is a heavy, slow rumble and its small one a fast buzz. On the
// voice-coil actuators they become a low tone on both sides, heavier on the left as on the pad, and
// a higher tone on the right.
constexpr float kLargeHz = 60.0f;
constexpr float kSmallHz = 170.0f;
// Camera quakes are a rough low rumble: noise that changes this many times a second, smoothed.
constexpr float kQuakeRateHz = 90.0f;
// Sound effects keep what the actuators can play; the rest only buzzes the pad.
constexpr float kEffectCutoffHz = 220.0f;
constexpr float kEffectGain = 3.0f;
// Targets are reached over a few milliseconds, so a change never clicks the actuators.
constexpr float kSmoothing = 1.0f / (0.004f * kRate);

std::atomic<float> g_large{0.0f};
std::atomic<float> g_small{0.0f};
std::atomic<float> g_quake{0.0f};

// Audio thread state.
float              g_large_phase = 0.0f;
float              g_small_phase = 0.0f;
float              g_large_level = 0.0f;
float              g_small_level = 0.0f;
float              g_quake_level = 0.0f;
float              g_quake_value = 0.0f;
float              g_quake_target = 0.0f;
float              g_quake_timer = 0.0f;
std::uint32_t      g_noise = 0x12345678u;
std::vector<float> g_effects;

// A two-pole low-pass (RBJ biquad), run twice per side for a steeper slope.
struct Biquad {
    float b0 = 0, b1 = 0, b2 = 0, a1 = 0, a2 = 0;
    float x1 = 0, x2 = 0, y1 = 0, y2 = 0;

    static Biquad LowPass(float cutoff) {
        const float w = kTwoPi * cutoff / kRate;
        const float alpha = std::sin(w) / (2.0f * 0.7071f);
        const float cosw = std::cos(w);
        const float a0 = 1.0f + alpha;
        Biquad      f;
        f.b0 = (1.0f - cosw) * 0.5f / a0;
        f.b1 = (1.0f - cosw) / a0;
        f.b2 = f.b0;
        f.a1 = -2.0f * cosw / a0;
        f.a2 = (1.0f - alpha) / a0;
        return f;
    }

    float Run(float x) {
        const float y = b0 * x + b1 * x1 + b2 * x2 - a1 * y1 - a2 * y2;
        x2 = x1;
        x1 = x;
        y2 = y1;
        y1 = y;
        return y;
    }
};

Biquad g_filters[2][2] = {
    {Biquad::LowPass(kEffectCutoffHz), Biquad::LowPass(kEffectCutoffHz)},
    {Biquad::LowPass(kEffectCutoffHz), Biquad::LowPass(kEffectCutoffHz)},
};
float g_dc[2] = {};

float Noise() {
    g_noise ^= g_noise << 13;
    g_noise ^= g_noise >> 17;
    g_noise ^= g_noise << 5;
    return static_cast<float>(g_noise & 0xFFFF) / 32767.5f - 1.0f;
}

// A quake is felt while its frame counter moves; a paused game freezes the counter and the rumble.
struct QuakeWatch {
    int last = -1;
    int still = 0;

    bool Moving(int counter) {
        still = counter == last ? still + 1 : 0;
        last = counter;
        return still < 2;
    }
};

QuakeWatch g_dungeon_watch;
QuakeWatch g_scene_watch;

float QuakeStrength(float amplitude) {
    // Script amplitudes are camera offsets; any quake is felt, the strongest ones fully.
    return std::clamp(0.3f + std::fabs(amplitude) / 3.0f, 0.3f, 1.0f);
}

bool Enabled() {
    return ConfigGet().dualsense_haptics != ConfigHaptics::Off;
}

} // namespace

bool HapticsActive() {
#ifdef SDL_PLATFORM_IOS
    return Enabled() && IosHapticsReady();
#else
    return Enabled() && ControllerSpeakerOpen() && ControllerHapticsChannels();
#endif
}

bool HapticsEffectsActive() {
    return ConfigGet().dualsense_haptics == ConfigHaptics::Full && HapticsActive();
}

void HapticsSetMotors(bool small_motor, std::uint8_t large_motor) {
    g_small.store(small_motor ? 0.6f : 0.0f, std::memory_order_relaxed);
    g_large.store(large_motor / 255.0f, std::memory_order_relaxed);
}

void HapticsPollGame() {
    float quake = 0.0f;
    if (ConfigGet().dualsense_haptics == ConfigHaptics::Full) {
        if (PortLoopNo == LOOP_DUNGEON && BattleAreaScene != nullptr) {
            const DNG_BATTLE_AREA &area = *BattleAreaScene;
            if (g_dungeon_watch.Moving(area.quake_count) && area.quake_count > 0) {
                quake = std::max(quake, QuakeStrength(area.quake_power));
            }
        }
        if (CameraSeq.quake != 0 && g_scene_watch.Moving(CameraSeq.quake_cnt)) {
            const float *amp = CameraSeq.quake_amp;
            quake = std::max(quake, QuakeStrength(std::sqrt(amp[0] * amp[0] + amp[1] * amp[1] + amp[2] * amp[2])));
        }
    }
    g_quake.store(quake, std::memory_order_relaxed);
}

audio::Mixer &HapticsMixer() {
    static audio::Mixer                mixer(audio::kSpuRate);
    [[maybe_unused]] static const bool dry = (mixer.SetReverbEnabled(false), true);
    return mixer;
}

void HapticsRender(float *out, int frames) {
    const float gain = ConfigGet().haptics_strength;
    const float large = g_large.load(std::memory_order_relaxed);
    const float small = g_small.load(std::memory_order_relaxed);
    const float quake = g_quake.load(std::memory_order_relaxed);
    const bool  effects = ConfigGet().dualsense_haptics == ConfigHaptics::Full;

    if (g_effects.size() < static_cast<std::size_t>(frames) * 2) {
        g_effects.resize(static_cast<std::size_t>(frames) * 2);
    }
    // Rendered even when off, so effects keyed on earlier do not resume later.
    HapticsMixer().Render(g_effects.data(), frames);

    for (int i = 0; i < frames; i++) {
        g_large_level += (large - g_large_level) * kSmoothing;
        g_small_level += (small - g_small_level) * kSmoothing;
        g_quake_level += (quake - g_quake_level) * kSmoothing;

        g_large_phase += kLargeHz / kRate;
        g_small_phase += kSmallHz / kRate;
        g_large_phase -= std::floor(g_large_phase);
        g_small_phase -= std::floor(g_small_phase);
        const float low = std::sin(kTwoPi * g_large_phase) * g_large_level;
        const float high = std::sin(kTwoPi * g_small_phase) * g_small_level;

        g_quake_timer -= kQuakeRateHz / kRate;
        if (g_quake_timer <= 0.0f) {
            g_quake_timer += 1.0f;
            g_quake_target = Noise();
        }
        g_quake_value += (g_quake_target - g_quake_value) * 0.01f;
        const float rumble = g_quake_value * 2.0f * g_quake_level;

        float side[2] = {low + 0.4f * high + rumble, 0.7f * low + high + rumble};
        for (int c = 0; c < 2; c++) {
            float effect = 0.0f;
            if (effects) {
                float x = g_effects[i * 2 + c];
                // Drops the offset a voice can leave, which the actuators would only hold.
                g_dc[c] += (x - g_dc[c]) * 0.001f;
                x -= g_dc[c];
                effect = g_filters[c][1].Run(g_filters[c][0].Run(x)) * kEffectGain;
            }
            out[i * 2 + c] = std::tanh((side[c] + effect) * gain);
        }
    }
}
