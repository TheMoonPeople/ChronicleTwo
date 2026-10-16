#include "common.h"

#include <gtest/gtest.h>
#include <nlohmann/json.hpp>

#include <algorithm>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <filesystem>
#include <format>
#include <fstream>
#include <initializer_list>
#include <string>
#include <vector>

#include "audio/mixer.hpp"
#include "audio/stream.hpp"
#include "audio/synth.hpp"
#include "event.hpp"
#include "event_func.hpp"
#include "ezbgm.hpp"
#include "platform/audio.hpp"
#include "platform/clock.hpp"
#include "platform/datapacks.hpp"
#include "platform/paths.hpp"
#include "platform/settings.hpp"
#include "platform_fixture.hpp"
#include "runscript.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include "sound_port.hpp"

namespace fs = std::filesystem;

namespace {

constexpr int kChannel = 1;
constexpr int kFrames = 4800;
constexpr std::int16_t kMono = 10000;
constexpr std::int16_t kLeft = 12000;
constexpr std::int16_t kRight = -3000;
constexpr float        kMonoOut = kMono / 32768.0f;
constexpr int          kPlaying = SND_STREAM_STATE_PLAYING;
constexpr int          kEnded = SND_STREAM_STATE_END;
constexpr std::int64_t kPastEnd = 480;

void Put(std::string &out, std::uint64_t value, int bytes) {
    for (int i = 0; i < bytes; i++) {
        out.push_back(static_cast<char>((value >> (8 * i)) & 0xFF));
    }
}

// The retail stream files carry a bext chunk ahead of fmt and data, so the header walk has to skip one.
std::string WavFile(int channels, const std::vector<std::int16_t> &samples) {
    const std::uint64_t data_bytes = samples.size() * 2;

    std::string body = "WAVE";
    body += "bext";
    Put(body, 16, 4);
    body.append(16, '\0');
    body += "fmt ";
    Put(body, 16, 4);
    Put(body, 1, 2);
    Put(body, static_cast<std::uint64_t>(channels), 2);
    Put(body, audio::kSpuRate, 4);
    Put(body, static_cast<std::uint64_t>(audio::kSpuRate) * channels * 2, 4);
    Put(body, static_cast<std::uint64_t>(channels) * 2, 2);
    Put(body, 16, 2);
    body += "data";
    Put(body, data_bytes, 4);
    for (std::int16_t sample : samples) {
        Put(body, static_cast<std::uint16_t>(sample), 2);
    }

    std::string file = "RIFF";
    Put(file, body.size(), 4);
    return file + body;
}

std::vector<std::int16_t> ConstantMono() {
    return std::vector<std::int16_t>(kFrames, kMono);
}

std::vector<std::int16_t> ConstantStereo() {
    std::vector<std::int16_t> samples;
    samples.reserve(static_cast<std::size_t>(kFrames) * 2);
    for (int i = 0; i < kFrames; i++) {
        samples.push_back(kLeft);
        samples.push_back(kRight);
    }
    return samples;
}

// The real data/ tree is never read, so these cases do not depend on the disc.
class ScratchDataRoot {
public:
    ScratchDataRoot()
        : root(fs::temp_directory_path() / std::format("ezbgm-test-{}", dc::test::ProcessId())),
          previous(PathsDataRoot()), previous_packs(datapacks::Root()) {
        std::error_code error;
        fs::remove_all(root, error);
        fs::create_directories(root / "port_data/sound");
        PathsSetDataRoot(root / "data");
        datapacks::Load(root / "port_data");
    }

    ~ScratchDataRoot() {
        CSnd.StreamClose(kChannel);
        PathsSetDataRoot(previous);
        if (previous_packs.empty()) {
            datapacks::Clear();
        } else {
            datapacks::Load(previous_packs);
        }
        std::error_code error;
        fs::remove_all(root, error);
    }

    ScratchDataRoot(const ScratchDataRoot &) = delete;
    ScratchDataRoot &operator=(const ScratchDataRoot &) = delete;

    void AddWav(const char *name, int channels, const std::vector<std::int16_t> &samples) {
        const std::string bytes = WavFile(channels, samples);
        std::ofstream     out(root / "port_data/sound" / name, std::ios::binary);
        out.write(bytes.data(), static_cast<std::streamsize>(bytes.size()));
        out.close();
        datapacks::Load(root / "port_data");
    }

private:
    fs::path root;
    fs::path previous;
    fs::path previous_packs;
};

void OpenStream(int channel, const char *name) {
    std::string buffer = std::string("sound/") + name;
    CSnd.StreamOpenFast(channel, buffer.data());
}

void OpenPack(int channel, const char *name, const char *pack) {
    std::string name_buffer(name);
    std::string pack_buffer(pack);
    CSnd.StreamOpenFromFPLFast(channel, name_buffer.data(), pack_buffer.data());
}

std::vector<float> RenderFrames(int frames) {
    std::vector<float> out(static_cast<std::size_t>(frames) * 2, 0.0f);
    audio::DefaultMixer().Render(out.data(), frames);
    return out;
}

float WorstError(const std::vector<float> &out, std::size_t side, float expected) {
    float worst = 0.0f;
    for (std::size_t i = side; i < out.size(); i += 2) {
        worst = std::max(worst, std::fabs(out[i] - expected));
    }
    return worst;
}

int StateOf(int channel) {
    return CSnd.StreamGetState(channel);
}

// The game reads the level as the left sample in the low half and the right in the high half.
int PackedLevel(std::int16_t left, std::int16_t right) {
    const auto l = static_cast<std::uint16_t>(left);
    const auto r = static_cast<std::uint16_t>(right);
    return static_cast<int>(l | (static_cast<std::uint32_t>(r) << 16));
}

} // namespace

TEST(EzBgm, OpenPlayRunsToTheEndThenDrains) {
    ScratchDataRoot root;
    root.AddWav("0000001.wav", 1, ConstantMono());

    OpenStream(kChannel, "0000001.wav");
    EXPECT_EQ(CSnd.StreamOpenState(), 0);
    CSnd.StreamStandBy(kChannel);
    CSnd.StreamSetVol(kChannel, 0x7FFF, 0x7FFF);
    CSnd.StreamPlay(kChannel);
    ASSERT_EQ(StateOf(kChannel), kPlaying);

    std::vector<float> out = RenderFrames(2400);
    EXPECT_EQ(StateOf(kChannel), kPlaying);
    EXPECT_LE(WorstError(out, 0, kMonoOut), 1e-3f);

    // Position reaches the last sample at frame 4800; 2400 are already rendered, so 480 frames land past it.
    RenderFrames(2880);
    EXPECT_EQ(StateOf(kChannel), kEnded);

    // The IOP holds END for one second of output, so the end must still read as held just before that.
    RenderFrames(static_cast<int>(audio::kSpuRate - kPastEnd - 1));
    EXPECT_EQ(StateOf(kChannel), kEnded);
    RenderFrames(1);
    EXPECT_EQ(StateOf(kChannel), 0);
}

TEST(EzBgm, VolumeComesFromTheGame) {
    ScratchDataRoot root;
    root.AddWav("0000001.wav", 1, ConstantMono());

    OpenStream(kChannel, "0000001.wav");
    CSnd.StreamSetVol(kChannel, 0x7FFF, 0);
    CSnd.StreamPlay(kChannel);

    std::vector<float> out = RenderFrames(2400);
    EXPECT_LE(WorstError(out, 0, kMonoOut), 1e-3f);
    EXPECT_EQ(WorstError(out, 1, 0.0f), 0.0f);
}

TEST(EzBgm, PauseAndReplayResume) {
    ScratchDataRoot root;
    root.AddWav("0000001.wav", 1, ConstantMono());

    OpenStream(kChannel, "0000001.wav");
    CSnd.StreamSetVol(kChannel, 0x7FFF, 0x7FFF);
    CSnd.StreamPlay(kChannel);
    RenderFrames(1200);
    ASSERT_EQ(EzBgmChannel(kChannel).Position(), 1200);

    CSnd.StreamPause(kChannel);
    EXPECT_EQ(StateOf(kChannel), 0);
    std::vector<float> paused = RenderFrames(1200);
    EXPECT_EQ(WorstError(paused, 0, 0.0f), 0.0f);
    EXPECT_EQ(WorstError(paused, 1, 0.0f), 0.0f);
    EXPECT_EQ(EzBgmChannel(kChannel).Position(), 1200);

    CSnd.StreamRePlay(kChannel);
    EXPECT_EQ(StateOf(kChannel), kPlaying);
    RenderFrames(1200);
    EXPECT_EQ(EzBgmChannel(kChannel).Position(), 2400);
}

TEST(EzBgm, CloseLeavesTheChannelSilentAndIdle) {
    ScratchDataRoot root;
    root.AddWav("0000001.wav", 1, ConstantMono());

    OpenStream(kChannel, "0000001.wav");
    CSnd.StreamSetVol(kChannel, 0x7FFF, 0x7FFF);
    CSnd.StreamPlay(kChannel);
    RenderFrames(1200);

    CSnd.StreamClose(kChannel);
    EXPECT_EQ(StateOf(kChannel), 0);
    EXPECT_FALSE(EzBgmChannel(kChannel).IsOpen());

    std::vector<float> out = RenderFrames(1200);
    EXPECT_EQ(WorstError(out, 0, 0.0f), 0.0f);
    EXPECT_EQ(WorstError(out, 1, 0.0f), 0.0f);
}

TEST(EzBgm, EndRewindsForTheNextPlay) {
    ScratchDataRoot root;
    root.AddWav("0000001.wav", 1, ConstantMono());

    OpenStream(kChannel, "0000001.wav");
    CSnd.StreamSetVol(kChannel, 0x7FFF, 0x7FFF);
    CSnd.StreamPlay(kChannel);
    RenderFrames(1200);

    CSnd.StreamEND(kChannel);
    EXPECT_EQ(EzBgmChannel(kChannel).Position(), 0);
    EXPECT_EQ(StateOf(kChannel), 0);

    CSnd.StreamPlay(kChannel);
    std::vector<float> out = RenderFrames(1);
    EXPECT_NEAR(out[0], kMonoOut, 1e-3f);
}

TEST(EzBgm, LevelReportsTheSampleAtThePosition) {
    ScratchDataRoot root;
    root.AddWav("0000001.wav", 1, ConstantMono());

    OpenStream(kChannel, "0000001.wav");
    CSnd.StreamPlay(kChannel);
    EXPECT_EQ(CSnd.StreamGetLevel(kChannel), PackedLevel(kMono, kMono));

    RenderFrames(2400);
    EXPECT_EQ(CSnd.StreamGetLevel(kChannel), PackedLevel(kMono, kMono));

    CSnd.StreamStop(kChannel);
    EXPECT_EQ(CSnd.StreamGetLevel(kChannel), 0);
}

TEST(EzBgm, MissingFileFailsAsOnThePalDisc) {
    ScratchDataRoot root;

    for (const char *name : {"cdrom0:\\VOICE\\E0001.WV;1", "9999999.wav"}) {
        OpenStream(kChannel, name);
        EXPECT_FALSE(EzBgmChannel(kChannel).IsOpen()) << name;
        EXPECT_EQ(CSnd.StreamOpenState(), 0);

        CSnd.StreamPlay(kChannel);
        EXPECT_EQ(StateOf(kChannel), 0);
        for (int step = 0; step < 3; step++) {
            EzBgmStep();
            RenderFrames(480);
            EXPECT_EQ(StateOf(kChannel), 0) << name;
        }
        EXPECT_EQ(CSnd.StreamGetLevel(kChannel), 0);
    }
}

TEST(EzBgm, VoicePackOpenFails) {
    ScratchDataRoot root;

    OpenPack(kChannel, "E0001", "VOICE");
    EXPECT_FALSE(EzBgmChannel(kChannel).IsOpen());
    EXPECT_EQ(CSnd.StreamOpenState(), 0);

    CSnd.StreamPlay(kChannel);
    EXPECT_EQ(StateOf(kChannel), 0);
}

TEST(EzBgm, StereoFileReportsStereoInfo) {
    ScratchDataRoot root;
    root.AddWav("0000001.wav", 1, ConstantMono());
    root.AddWav("0000002.wav", 2, ConstantStereo());

    OpenStream(kChannel, "0000001.wav");
    EXPECT_EQ(ezBgm(kChannel | 0x80D0, 0), 0);
    CSnd.StreamStandBy(kChannel);
    EXPECT_EQ(ezBgm(kChannel | 0x80D0, 0), 0);
    CSnd.StreamPlay(kChannel);
    EXPECT_EQ(CSnd.StreamGetLevel(kChannel), PackedLevel(kMono, kMono));

    OpenStream(kChannel, "0000002.wav");
    EXPECT_EQ(ezBgm(kChannel | 0x80D0, 0), 1);
    CSnd.StreamStandBy(kChannel);
    EXPECT_EQ(ezBgm(kChannel | 0x80D0, 0), 1);
    CSnd.StreamPlay(kChannel);
    EXPECT_EQ(CSnd.StreamGetLevel(kChannel), PackedLevel(kLeft, kRight));
}

TEST(EzBgm, LoopModeRestartsInsteadOfEnding) {
    ScratchDataRoot root;
    root.AddWav("0000001.wav", 1, ConstantMono());

    OpenStream(kChannel, "0000001.wav");
    ezBgm(kChannel | 0x80C0, 0x01);
    CSnd.StreamSetVol(kChannel, 0x7FFF, 0x7FFF);
    CSnd.StreamPlay(kChannel);

    RenderFrames(3 * kFrames);
    EXPECT_EQ(StateOf(kChannel), kPlaying);
    EXPECT_EQ(ezBgm(kChannel | 0x80B0, 0) & 0xFF, 0x01);
}

TEST(EzBgm, StepAdvancesStreamsWithoutOutput) {
    ASSERT_FALSE(AudioOutputRunning());

    ScratchDataRoot root;
    root.AddWav("0000001.wav", 1, ConstantMono());

    OpenStream(kChannel, "0000001.wav");
    CSnd.StreamPlay(kChannel);

    // END is set on the first step whose start is past the last sample, so floor(length / step) + 1 steps reach it.
    const auto per_step = static_cast<std::int64_t>(audio::kSpuRate / ClockTickRate());
    const int  steps = static_cast<int>(kFrames / per_step) + 1;
    for (int step = 0; step < steps - 1; step++) {
        EzBgmStep();
    }
    EXPECT_EQ(StateOf(kChannel), kPlaying);

    EzBgmStep();
    EXPECT_EQ(StateOf(kChannel), kEnded);
}

TEST(EzBgm, LegacyHostRateDoesNotChangeNtscStreamAdvance) {
    ASSERT_FALSE(AudioOutputRunning());
    const auto   before = SettingsGet();
    const double previous_rate = ClockTickRate();
    auto         changed = before;
    changed.tick_rate = 240;
    SettingsChange(changed);
    ScratchDataRoot root;
    root.AddWav("0000001.wav", 1, ConstantMono());
    EXPECT_DOUBLE_EQ(SettingsGet().tick_rate, 60);
    {
        ClockSetTickRate(60);
        OpenStream(kChannel, "0000001.wav");
        CSnd.StreamPlay(kChannel);
        EzBgmStep();
        EXPECT_EQ(EzBgmChannel(kChannel).Position(), static_cast<std::int64_t>(audio::kSpuRate / 60));
    }
    ClockSetTickRate(previous_rate);
    SettingsChange(before);
}

TEST(EzBgm, OpenCommandsWithAnIntAddressAreRefused) {
    EXPECT_EQ(ezBgm(kChannel | EZBGM_OPEN, 0), 0);
    EXPECT_EQ(ezBgm(kChannel | EZBGM_OPEN_FROM_PACK, 0), 0);
    EXPECT_EQ(ezBgm(kChannel | EZBGM_UNK_8A00, 0), 0);
    EXPECT_FALSE(EzBgmChannel(kChannel).IsOpen());
}

TEST(EzBgm, EventVoiceCommandsOpenDirectWaveClips) {
    ScratchDataRoot root;
    root.AddWav("0000001.wav", 1, ConstantMono());
    char clip[] = "0000001";
    char pack[] = "unused_voice_group";
    EXPECT_EQ(CommandStreamOpen(kChannel, clip), 1);
    EXPECT_TRUE(EzBgmChannel(kChannel).IsOpen());
    CSnd.StreamClose(kChannel);
    EXPECT_EQ(CommandStreamOpenFromFPL(kChannel, pack, clip), 1);
    EXPECT_TRUE(EzBgmChannel(kChannel).IsOpen());
    CSnd.StreamClose(kChannel);
    char direct[] = "sound/0000001.wav";
    EXPECT_EQ(CommandStreamOpen(kChannel, direct), 1);
    EXPECT_TRUE(EzBgmChannel(kChannel).IsOpen());
    CSnd.StreamClose(kChannel);
    EXPECT_EQ(CommandStreamOpen2(kChannel, clip), 1);
    EXPECT_FALSE(EzBgmChannel(kChannel).IsOpen());
}

TEST(EzBgm, EventVoiceDispatchOpensNumericAndNamedDirectClips) {
    ScratchDataRoot root;
    root.AddWav("0000001.wav", 1, ConstantMono());
    CRunScript script;
    SetEventFunc(&script);
    RS_STACKDATA args[2]{};
    args[0].type = RS_INT;
    args[0].val.i = 0;
    args[1].type = RS_INT;
    args[1].val.i = 1;
    const auto source = EdEventInfo.stream_source;
    EXPECT_EQ(script.ext_func_table[EVENT_EXT_STREAM_OPEN](args, 2), 1);
    EXPECT_TRUE(EzBgmChannel(kChannel).IsOpen());
    EXPECT_EQ(EdEventInfo.stream_source, EVENT_STREAM_VOICE_PACK);
    CSnd.StreamClose(kChannel);
    char clip[] = "0000001";
    args[1].type = RS_STR;
    args[1].val.s = clip;
    EXPECT_EQ(script.ext_func_table[EVENT_EXT_STREAM_OPEN](args, 2), 1);
    EXPECT_TRUE(EzBgmChannel(kChannel).IsOpen());
    EXPECT_EQ(EdEventInfo.stream_source, EVENT_STREAM_FILE);
    EdEventInfo.stream_source = source;
}
