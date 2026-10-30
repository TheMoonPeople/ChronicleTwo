#include "controller_speaker.hpp"

#include <SDL3/SDL.h>

#include <algorithm>
#include <cctype>
#include <cstdio>
#include <mutex>
#include <string>
#include <vector>

#include "audio/mixer.hpp"
#include "audio/stream.hpp"
#include "dualsense_haptics.hpp"
#include "log/log.hpp"
#include "platform/config.hpp"
#include "platform/settings.hpp"

namespace {

constexpr int    kChunkFrames = 1024;
constexpr Uint64 kRetryMs = 3000;

// Windows names the DualSense's audio endpoint after the pad ("Speakers (DualSense Wireless
// Controller)"), including the one DSX's DualSense emulation creates for a Bluetooth pad.
constexpr const char *kDeviceNames[] = {"dualsense", "wireless controller"};

std::mutex                          g_mutex;
std::vector<audio::StreamChannel *> g_channels;
SDL_AudioStream                    *g_stream = nullptr;
bool                                g_tried = false;
Uint64                              g_last_try = 0;
std::vector<float>                  g_chunk;
std::vector<float>                  g_mix;
std::vector<float>                  g_effects;
std::vector<float>                  g_haptics;
// 4 when the device has the DualSense's actuator channels behind its speaker pair, else 2.
int g_channels_out = 2;

std::string Lower(const char *text) {
    std::string out;
    for (const char *c = text; *c != '\0'; c++) {
        out.push_back(static_cast<char>(std::tolower(static_cast<unsigned char>(*c))));
    }
    return out;
}

void SDLCALL Feed(void * /*unused*/, SDL_AudioStream *stream, int additional_amount, int /*unused*/) {
    const int        stride = g_channels_out;
    int              frames = additional_amount / static_cast<int>(sizeof(float) * stride);
    std::scoped_lock lock(g_mutex);
    const float      gain = SettingsGet().master_volume * ConfigGet().controller_volume;
    while (frames > 0) {
        const int count = std::min(frames, kChunkFrames);
        std::fill_n(g_mix.begin(), count * 2, 0.0f);
        for (audio::StreamChannel *channel : g_channels) {
            channel->Render(g_mix.data(), count, audio::kSpuRate, gain);
        }
        ControllerSpeakerMixer().Render(g_effects.data(), count);
        for (int i = 0; i < count * 2; i++) {
            g_mix[i] += g_effects[i] * gain;
        }
        if (stride == 4) {
            HapticsRender(g_haptics.data(), count);
        }
        // The pad has one small speaker; both sides carry the mono sum.
        for (int i = 0; i < count; i++) {
            const float mono = std::clamp((g_mix[i * 2] + g_mix[i * 2 + 1]) * 0.5f, -1.0f, 1.0f);
            g_chunk[i * stride] = g_chunk[i * stride + 1] = mono;
            if (stride == 4) {
                g_chunk[i * 4 + 2] = g_haptics[i * 2];
                g_chunk[i * 4 + 3] = g_haptics[i * 2 + 1];
            }
        }
        SDL_PutAudioStreamData(stream, g_chunk.data(), count * static_cast<int>(sizeof(float) * stride));
        frames -= count;
    }
}

SDL_AudioDeviceID FindDevice(int &channels) {
    int                count = 0;
    SDL_AudioDeviceID *devices = SDL_GetAudioPlaybackDevices(&count);
    SDL_AudioDeviceID  found = 0;
    for (int i = 0; devices != nullptr && i < count && found == 0; i++) {
        const char *name = SDL_GetAudioDeviceName(devices[i]);
        if (name == nullptr) {
            continue;
        }
        const std::string lower = Lower(name);
        for (const char *match : kDeviceNames) {
            if (lower.contains(match)) {
                SDL_AudioSpec native{};
                int           frames = 0;
                SDL_GetAudioDeviceFormat(devices[i], &native, &frames);
                CT_LOG_INFO(Audio, "controller speaker: using \"{}\" ({} channels, {} Hz){}", name, native.channels,
                            native.freq, native.channels >= 4 ? ", haptics on channels 3-4" : "");
                channels = native.channels;
                found = devices[i];
                break;
            }
        }
    }
    SDL_free(devices);
    return found;
}

// Opens the device the first time a voice or effect asks for it. The menus ask every step, so after
// a failed attempt the next one waits a while; a pad plugged in later is found then.
bool EnsureOpen() {
    if (g_stream != nullptr) {
        return true;
    }
#ifdef SDL_PLATFORM_IOS
    // iOS lists one default output and gives apps no way to the pad's speaker over Bluetooth.
    if (!g_tried) {
        g_tried = true;
        CT_LOG_INFO(Audio, "controller speaker: iOS has no DualSense audio device; sounds stay on the main output");
    }
    return false;
#endif
    const Uint64 now = SDL_GetTicks();
    if (g_tried && now - g_last_try < kRetryMs) {
        return false;
    }
    g_last_try = now;
    if (!SDL_InitSubSystem(SDL_INIT_AUDIO)) {
        return false;
    }
    int                     channels = 0;
    const SDL_AudioDeviceID device = FindDevice(channels);
    if (device == 0) {
        if (!g_tried) {
            CT_LOG_INFO(Audio, "controller speaker: no DualSense audio device; sounds stay on the main output");
        }
        g_tried = true;
        SDL_QuitSubSystem(SDL_INIT_AUDIO);
        return false;
    }
    // A quad device carries the speaker on its front pair and the actuators on its rear pair.
    g_channels_out = channels >= 4 ? 4 : 2;
    g_chunk.assign(kChunkFrames * g_channels_out, 0.0f);
    g_haptics.assign(kChunkFrames * 2, 0.0f);
    g_mix.assign(kChunkFrames * 2, 0.0f);
    g_effects.assign(kChunkFrames * 2, 0.0f);
    const SDL_AudioSpec spec{.format = SDL_AUDIO_F32, .channels = g_channels_out, .freq = audio::kSpuRate};
    g_stream = SDL_OpenAudioDeviceStream(device, &spec, Feed, nullptr);
    if (g_stream == nullptr) {
        CT_LOG_WARN(Audio, "controller speaker: cannot open the device: {}", SDL_GetError());
        SDL_QuitSubSystem(SDL_INIT_AUDIO);
        return false;
    }
    SDL_ResumeAudioStreamDevice(g_stream);
    return true;
}

} // namespace

bool ControllerSpeakerOpen() {
    return EnsureOpen();
}

bool ControllerHapticsChannels() {
    return g_stream != nullptr && g_channels_out == 4;
}

audio::Mixer &ControllerSpeakerMixer() {
    // The pad's speaker is small and dry: the effects play without the default mixer's reverb.
    static audio::Mixer                mixer(audio::kSpuRate);
    [[maybe_unused]] static const bool dry = (mixer.SetReverbEnabled(false), true);
    return mixer;
}

bool ControllerSpeakerRoute(audio::StreamChannel *channel) {
    if (!EnsureOpen()) {
        return false;
    }
    audio::DefaultMixer().RemoveStreamChannel(channel);
    std::scoped_lock lock(g_mutex);
    if (std::ranges::find(g_channels, channel) == g_channels.end()) {
        g_channels.push_back(channel);
    }
    return true;
}

void ControllerSpeakerRelease(audio::StreamChannel *channel) {
    {
        std::scoped_lock lock(g_mutex);
        if (std::erase(g_channels, channel) == 0) {
            return;
        }
    }
    audio::DefaultMixer().AddStreamChannel(channel);
}
