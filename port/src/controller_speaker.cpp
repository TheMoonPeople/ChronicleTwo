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

std::string Lower(const char *text) {
    std::string out;
    for (const char *c = text; *c != '\0'; c++) {
        out.push_back(static_cast<char>(std::tolower(static_cast<unsigned char>(*c))));
    }
    return out;
}

void SDLCALL Feed(void *, SDL_AudioStream *stream, int additional_amount, int) {
    int             frames = additional_amount / static_cast<int>(sizeof(float) * 2);
    std::lock_guard lock(g_mutex);
    const float     gain = SettingsGet().master_volume * ConfigGet().controller_volume;
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
        // The pad has one small speaker; both sides carry the mono sum.
        for (int i = 0; i < count; i++) {
            const float mono = std::clamp((g_mix[i * 2] + g_mix[i * 2 + 1]) * 0.5f, -1.0f, 1.0f);
            g_chunk[i * 2] = g_chunk[i * 2 + 1] = mono;
        }
        SDL_PutAudioStreamData(stream, g_chunk.data(), count * static_cast<int>(sizeof(float) * 2));
        frames -= count;
    }
}

SDL_AudioDeviceID FindDevice() {
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
            if (lower.find(match) != std::string::npos) {
                std::fprintf(stderr, "controller speaker: using \"%s\"\n", name);
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
    const Uint64 now = SDL_GetTicks();
    if (g_tried && now - g_last_try < kRetryMs) {
        return false;
    }
    g_last_try = now;
    if (!SDL_InitSubSystem(SDL_INIT_AUDIO)) {
        return false;
    }
    const SDL_AudioDeviceID device = FindDevice();
    if (device == 0) {
        if (!g_tried) {
            std::fprintf(stderr, "controller speaker: no DualSense audio device; sounds stay on the main output\n");
        }
        g_tried = true;
        SDL_QuitSubSystem(SDL_INIT_AUDIO);
        return false;
    }
    g_chunk.assign(kChunkFrames * 2, 0.0f);
    g_mix.assign(kChunkFrames * 2, 0.0f);
    g_effects.assign(kChunkFrames * 2, 0.0f);
    const SDL_AudioSpec spec{SDL_AUDIO_F32, 2, audio::kSpuRate};
    g_stream = SDL_OpenAudioDeviceStream(device, &spec, Feed, nullptr);
    if (g_stream == nullptr) {
        std::fprintf(stderr, "controller speaker: cannot open the device: %s\n", SDL_GetError());
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

audio::Mixer &ControllerSpeakerMixer() {
    // The pad's speaker is small and dry: the effects play without the default mixer's reverb.
    static audio::Mixer mixer(audio::kSpuRate);
    static const bool dry = (mixer.SetReverbEnabled(false), true);
    (void) dry;
    return mixer;
}

bool ControllerSpeakerRoute(audio::StreamChannel *channel) {
    if (!EnsureOpen()) {
        return false;
    }
    audio::DefaultMixer().RemoveStreamChannel(channel);
    std::lock_guard lock(g_mutex);
    if (std::find(g_channels.begin(), g_channels.end(), channel) == g_channels.end()) {
        g_channels.push_back(channel);
    }
    return true;
}

void ControllerSpeakerRelease(audio::StreamChannel *channel) {
    {
        std::lock_guard lock(g_mutex);
        if (std::find(g_channels.begin(), g_channels.end(), channel) == g_channels.end()) {
            return;
        }
        std::erase(g_channels, channel);
    }
    audio::DefaultMixer().AddStreamChannel(channel);
}
