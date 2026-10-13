#include "common.h"

#include <algorithm>
#include <array>
#include <cctype>
#include <cstdint>
#include <cstdio>
#include <cstring>
#include <filesystem>
#include <fstream>
#include <memory>
#include <mutex>
#include <optional>
#include <string>
#include <string_view>

#include "audio/mixer.hpp"
#include "audio/stream.hpp"
#include "audio_init.hpp"
#include "dataread_port.hpp"
#include "ezbgm.hpp"
#include "platform/audio.hpp"
#include "platform/clock.hpp"
#include "platform/paths.hpp"
#include "sound.hpp"
#include "sound_port.hpp"

namespace fs = std::filesystem;

namespace {

constexpr int kChannelCount = 16;

// The IOP holds the end bit while its buffers drain; the game's waits poll it for several frames, so one second of output stands in for that drain.
constexpr std::int64_t kEndHoldFrames = audio::kSpuRate;

enum Command : int {
    kQuit = 0x10,
    kClose = 0x30,
    kStart = 0x50,
    kStop = 0x60,
    kSeek = 0x70,
    kVolume = 0x80,
    kSetMode = 0x80C0,
    kState = 0x80B0,
    kInfo = 0x80D0,
    kLevel = 0x80E0,
    kInit = 0x8000,
};

struct StreamSlot {
    audio::StreamChannel stream;
    int                  mode = 0;
    int                  stereo = 0;
};

std::array<StreamSlot, kChannelCount> &Slots() {
    static std::array<StreamSlot, kChannelCount> slots;
    return slots;
}

void AttachChannels() {
    static std::once_flag attached;
    std::call_once(attached, [] {
        for (StreamSlot &slot : Slots()) {
            audio::DefaultMixer().AddStreamChannel(&slot.stream);
        }
    });
}

StreamSlot &Slot(int channel) {
    AttachChannels();
    return Slots()[std::clamp(channel, 0, kChannelCount - 1)];
}

void CloseSlot(StreamSlot &slot) {
    slot.stream.Close();
    slot.mode = 0;
    slot.stereo = 0;
}

// The IOP driver reads the channel count from the fmt chunk; the decoder has already turned the file
// into stereo, so the source layout has to come from the container.
std::optional<int> WavChannels(const fs::path &path) {
    std::ifstream in(path, std::ios::binary);
    char          riff[12];
    if (!in.read(riff, sizeof riff) || std::memcmp(riff, "RIFF", 4) != 0 || std::memcmp(riff + 8, "WAVE", 4) != 0) {
        return std::nullopt;
    }

    for (;;) {
        unsigned char header[8];
        if (!in.read(reinterpret_cast<char *>(header), sizeof header)) {
            return std::nullopt;
        }
        std::uint32_t size = header[4] | (header[5] << 8) | (header[6] << 16) | (static_cast<std::uint32_t>(header[7]) << 24);

        if (std::memcmp(header, "fmt ", 4) == 0) {
            unsigned char format[4];
            if (size < sizeof format || !in.read(reinterpret_cast<char *>(format), sizeof format)) {
                return std::nullopt;
            }
            return format[2] | (format[3] << 8);
        }

        std::streamoff skip = static_cast<std::streamoff>(size) + (size & 1);
        in.seekg(skip, std::ios::cur);
        if (!in) {
            return std::nullopt;
        }
    }
}

// DataReadFind's index skips the sound/ tree, so the SOUND.DAT extracts are looked up directly.
std::optional<fs::path> ResolveSoundName(const char *name) {
    std::string file;
    for (const char *c = name; *c != '\0'; c++) {
        file.push_back(static_cast<char>(std::tolower(static_cast<unsigned char>(*c))));
    }

    fs::path path = PathsDataRoot() / "sound" / file;
    std::error_code error;
    if (!fs::is_regular_file(path, error)) {
        return std::nullopt;
    }
    return path;
}

std::optional<fs::path> ResolveName(const char *name) {
    if (std::string_view(name).find(':') != std::string_view::npos) {
        return DataReadFind(name);
    }
    return ResolveSoundName(name);
}

} // namespace

PORT_OVERRIDE int ezBgmInit() {
    AttachChannels();
    return 1;
}

PORT_OVERRIDE int ezBgm(int command, int argument) {
    StreamSlot          &slot = Slot(command & EZBGM_CHANNEL_MASK);
    audio::StreamChannel &stream = slot.stream;

    switch (command & EZBGM_COMMAND_MASK) {
        case EZBGM_OPEN:
        case EZBGM_OPEN_FROM_PACK:
        case EZBGM_UNK_8A00:
            std::fprintf(stderr, "ezbgm: open command 0x%04x carries an address, use EzBgmOpen\n", command & EZBGM_COMMAND_MASK);
            return 0;
        case EZBGM_PRELOAD:
            return 0;
        case kStart:
            if (stream.IsOpen()) {
                stream.Play();
            }
            return 0;
        case kStop:
            stream.Stop();
            return 0;
        case kSeek:
            stream.Seek(0);
            return 0;
        case kClose:
            stream.Close();
            return 0;
        case kQuit:
        case 0x90:
        case 0xA0:
        case 0xD0:
            return 0;
        case kVolume: {
            const int left = (argument >> 16) & 0x7FFF;
            const int right = argument & 0x7FFF;
            stream.SetVolume(left / 32767.0f, right / 32767.0f);
            return 0;
        }
        case kSetMode:
            if (stream.IsOpen()) {
                slot.mode = argument & 0xFF;
                stream.SetLoop((argument & 0x0F) != 0);
            }
            return 0;
        case kState: {
            int state = slot.mode;
            if (stream.State() == audio::StreamState::Playing) {
                state |= 0x1000;
            }
            if (stream.State() == audio::StreamState::Ended && stream.FramesSinceEnd() < kEndHoldFrames) {
                state |= 0x8000;
            }
            return state;
        }
        case kInfo:
            return slot.stereo;
        case kLevel:
            return static_cast<int>(stream.Level());
        case kInit:
            return 0;
        default:
            return 0;
    }
}

PORT_OVERRIDE int CSound::StreamOpenState() {
    return 0;
}

int EzBgmOpen(int channel, const char *name) {
    StreamSlot &slot = Slot(channel);
    CloseSlot(slot);

    std::optional<fs::path> path = ResolveName(name);
    if (!path) {
        std::fprintf(stderr, "ezbgm: %s: not on the disc\n", name);
        return 0;
    }

    std::string                      error;
    std::shared_ptr<audio::PcmTrack> track = audio::LoadPcmTrack(*path, error);
    if (!track) {
        std::fprintf(stderr, "ezbgm: %s: %s\n", name, error.c_str());
        return 0;
    }

    std::optional<int> channels = WavChannels(*path);
    if (!channels) {
        std::fprintf(stderr, "ezbgm: %s: no fmt chunk\n", name);
        return 0;
    }

    const bool stereo = *channels == 2;
    slot.stream.SetSourceChannels(stereo ? 2 : 1);
    slot.stream.Open(track);
    slot.stream.SetLoop(false);
    slot.stereo = stereo ? 1 : 0;
    return 1;
}

int EzBgmOpenFromPack(int channel, const char *name, const char *pack_name) {
    CloseSlot(Slot(channel));
    std::fprintf(stderr, "ezbgm: %s (pack %s): voice packs are not on the disc\n", name, pack_name);
    return 0;
}

void EzBgmStep() {
    if (AudioOutputRunning() || AudioUsesTickClock()) {
        return;
    }

    // The clock keeps the active session rate even when config changes await restart.
    // It is also available when retail global constructors step sound before startup.
    const double tick_rate = ClockTickRate();
    if (!(tick_rate > 0.0)) {
        return;
    }

    const std::int64_t frames = static_cast<std::int64_t>(audio::kSpuRate / tick_rate);
    for (int channel = 0; channel < kChannelCount; channel++) {
        Slot(channel).stream.Advance(frames, audio::kSpuRate);
    }
}

audio::StreamChannel &EzBgmChannel(int channel) {
    return Slot(channel).stream;
}
