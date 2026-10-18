#include <gtest/gtest.h>

#include <algorithm>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <filesystem>
#include <format>
#include <fstream>
#include <numbers>
#include <string_view>
#include <system_error>
#include <vector>

#include "audio/synth.hpp"
#include "audio/vag.hpp"
#include "audio_init.hpp"
#include "platform/audio.hpp"
#include "platform_fixture.hpp"

namespace fs = std::filesystem;

namespace {

// 1280 frames is a whole number of periods for both tones, so the loop is seamless.
constexpr int    kLoopFrames = 1280;
constexpr int    kRenderFrames = 4800;
constexpr int    kSkipFrames = 480;
// 4096 frames hold 32 periods of 375 Hz and 128 of 1500 Hz, so the DFT bins are exact and no
// window function is needed.
constexpr int    kWindowFrames = 4096;
constexpr double kHalfScalePcm = 16384.0;
// Attack rate 0 is the fastest linear attack. Decay shift 15 with sustain level 15 puts the
// sustain level above full scale, so the first decay tick ends the phase before the level can
// fall. Sustain rate 0 without decrease holds at full scale.
constexpr std::uint16_t kAdsr1 = 0x00F0;
constexpr std::uint16_t kAdsr2 = 0x0000;

// Saves the audio variables a case sets and restores them on exit, stops the output and removes
// the capture file, so no case leaks state into the next.
class AudioEnvironment {
public:
    AudioEnvironment()
        : audio_(dc::test::SaveEnv("DC2_AUDIO")), wav_(dc::test::SaveEnv("DC2_AUDIO_WAV")) {}

    AudioEnvironment(const AudioEnvironment &) = delete;
    AudioEnvironment &operator=(const AudioEnvironment &) = delete;

    ~AudioEnvironment() {
        AudioShutdown();
        dc::test::RestoreEnv(audio_);
        dc::test::RestoreEnv(wav_);
        if (!capture_.empty()) {
            std::error_code error;
            fs::remove(capture_, error);
        }
    }

    static void Disable() {
        ASSERT_EQ(dc::test::SetEnv("DC2_AUDIO", "off", 1), 0);
        ASSERT_EQ(dc::test::SetEnv("DC2_AUDIO_WAV", "", 1), 0);
    }

    void Capture() {
        capture_ = fs::temp_directory_path() / std::format("dc2_audio_init_{}.wav", dc::test::ProcessId());
        std::error_code error;
        fs::remove(capture_, error);
        ASSERT_EQ(dc::test::SetEnv("DC2_AUDIO", "", 1), 0);
        ASSERT_EQ(dc::test::SetEnv("DC2_AUDIO_WAV", capture_, 1), 0);
    }

    [[nodiscard]] const fs::path &CapturePath() const { return capture_; }

private:
    dc::test::EnvSnapshot audio_;
    dc::test::EnvSnapshot wav_;
    fs::path              capture_;
};

void ExpectRiffHeader(const fs::path &path) {
    ASSERT_TRUE(fs::is_regular_file(path));
    ASSERT_GE(fs::file_size(path), 44u);
    std::ifstream file(path, std::ios::binary);
    char          header[12] = {};
    file.read(header, sizeof(header));
    EXPECT_EQ(std::string_view(header, 4), "RIFF");
    EXPECT_EQ(std::string_view(header + 8, 4), "WAVE");
}

audio::VagSample LoopedSine(double hz) {
    audio::VagSample sample;
    sample.loops = true;
    sample.pcm.resize(kLoopFrames);
    for (int n = 0; n < kLoopFrames; ++n) {
        const double phase = 2.0 * std::numbers::pi * hz * n / audio::kSpuRate;
        sample.pcm[n] = static_cast<std::int16_t>(std::lround(kHalfScalePcm * std::sin(phase)));
    }
    return sample;
}

void StartTone(audio::Synth &synth, const audio::VagSample &sample) {
    audio::Voice &voice = synth.Allocate(0);
    voice.sample = &sample;
    voice.rate = audio::kSpuRate;
    voice.step = static_cast<double>(voice.rate) / synth.Rate();
    voice.gain_l = 1.0f;
    voice.gain_r = 1.0f;
    voice.mix = static_cast<std::uint8_t>(audio::kMixDryLeft | audio::kMixDryRight);
    synth.Start(voice, kAdsr1, kAdsr2);
}

// Magnitude of one tone in the left channel, by direct DFT at that frequency.
double Amplitude(const std::vector<float> &dry, double hz) {
    double re = 0.0;
    double im = 0.0;
    for (int n = 0; n < kWindowFrames; ++n) {
        const double sample = dry[static_cast<std::size_t>((kSkipFrames + n) * 2)];
        const double phase = 2.0 * std::numbers::pi * hz * n / audio::kSpuRate;
        re += sample * std::cos(phase);
        im -= sample * std::sin(phase);
    }
    return 2.0 * std::hypot(re, im) / kWindowFrames;
}

} // namespace

TEST(AudioInit, DisabledOutputStartsNothing) {
    AudioEnvironment env;
    AudioEnvironment::Disable();
    EXPECT_TRUE(AudioInit());
    EXPECT_FALSE(AudioOutputRunning());
    AudioShutdown();
    AudioShutdown();
    EXPECT_FALSE(AudioOutputRunning());
}

TEST(AudioInit, WavCaptureRunsTheDefaultMixer) {
    AudioEnvironment env;
    env.Capture();
    ASSERT_TRUE(AudioInit());
    EXPECT_TRUE(AudioOutputRunning());
    ExpectRiffHeader(env.CapturePath());
    AudioShutdown();
    EXPECT_FALSE(AudioOutputRunning());
    ExpectRiffHeader(env.CapturePath());
}

TEST(AudioInit, SynthMixesTwoSines) {
    const audio::VagSample low = LoopedSine(375.0);
    const audio::VagSample high = LoopedSine(1500.0);
    audio::Synth           synth(audio::kSpuRate);
    StartTone(synth, low);
    StartTone(synth, high);

    std::vector<float> dry(kRenderFrames * 2, 0.0f);
    std::vector<float> send_left(kRenderFrames * 2, 0.0f);
    std::vector<float> send_right(kRenderFrames * 2, 0.0f);
    float             *sends[audio::kCores] = {send_left.data(), send_right.data()};
    synth.Render(kRenderFrames, dry.data(), sends);

    const double a_low = Amplitude(dry, 375.0);
    const double a_high = Amplitude(dry, 1500.0);
    const double a_gap = Amplitude(dry, 750.0);
    ASSERT_GT(a_low, 0.25);
    ASSERT_GT(a_high, 0.25);
    EXPECT_LE(std::abs(a_low - a_high), 0.1 * std::max(a_low, a_high));
    EXPECT_LE(20.0 * std::log10(a_gap / std::min(a_low, a_high)), -20.0);
}
