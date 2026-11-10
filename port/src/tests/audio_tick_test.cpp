#include <SDL3/SDL.h>
#include <gtest/gtest.h>

#include <cstdint>
#include <filesystem>
#include <memory>
#include <string>

#include "audio/mixer.hpp"
#include "audio/pcm.hpp"
#include "audio/sound_runtime.hpp"
#include "audio/stream.hpp"
#include "audio_init.hpp"
#include "ezbgm.hpp"
#include "platform/audio.hpp"
#include "platform/clock.hpp"
#include "platform_fixture.hpp"

namespace {
class AudioTick : public testing::Test {
protected:
    void SetUp() override {
        audio_env_ = dc::test::SaveEnv("DC2_AUDIO");
        wav_env_ = dc::test::SaveEnv("DC2_AUDIO_WAV");
        dc::test::SetEnv("DC2_AUDIO", "off", 1);
        dc::test::SetEnv("DC2_AUDIO_WAV", "", 1);
        AudioShutdown();
        ClockSetUnbounded(true);
        ClockSetTickRate(60.0);
        ClockSetTickCallback(nullptr);
        ClockSetIdleHook(nullptr);
        ClockReset();
        auto track = std::make_shared<audio::PcmTrack>();
        track->rate = audio::DefaultMixer().Rate();
        track->samples.resize(static_cast<size_t>(track->rate) * 4);
        for (size_t i = 0; i < track->samples.size() / 2; ++i) {
            track->samples[i * 2] = static_cast<int16_t>(i % 16000);
            track->samples[i * 2 + 1] = -track->samples[i * 2];
        }
        channel().Open(track);
        channel().SetLoop(false);
        channel().Play();
    }

    void TearDown() override {
        AudioShutdown();
        channel().Close();
        if (!capture_.empty()) {
            std::error_code error;
            std::filesystem::remove(capture_, error);
        }
        dc::test::RestoreEnv(audio_env_);
        dc::test::RestoreEnv(wav_env_);
        ClockSetUnbounded(false);
        ClockSetTickRate(60.0);
    }

    static audio::StreamChannel &channel() { return EzBgmChannel(1); }

    dc::test::EnvSnapshot audio_env_;
    dc::test::EnvSnapshot wav_env_;
    std::filesystem::path capture_;
};
} // namespace

TEST_F(AudioTick, HeadlessVoiceSamplesAdvanceOnLogicTicksWithoutADevice) {
    ASSERT_TRUE(AudioInit(true));
    EXPECT_TRUE(AudioUsesTickClock());
    EXPECT_FALSE(AudioOutputRunning());
    EXPECT_EQ(SDL_WasInit(SDL_INIT_AUDIO), 0u);
    ClockPump();
    const int frame = audio::DefaultMixer().Rate() / 60;
    EXPECT_EQ(channel().Position(), frame);
    const auto expected = static_cast<uint32_t>(static_cast<uint16_t>(frame)) |
                          (static_cast<uint32_t>(static_cast<uint16_t>(-frame)) << 16);
    EXPECT_EQ(static_cast<uint32_t>(ezBgm(0x80E1, 0)), expected);
    EzBgmStep();
    EXPECT_EQ(channel().Position(), frame) << "the stream-only fallback must not advance it twice";
}

TEST_F(AudioTick, FractionalSamplesCarryBetweenTicks) {
    ClockSetTickRate(93.0);
    ASSERT_TRUE(AudioInit(true));
    for (int i = 0; i < 93; ++i) {
        ClockPump();
    }
    EXPECT_EQ(channel().Position(), audio::DefaultMixer().Rate());
}

TEST_F(AudioTick, ShutdownRemovesTheMixerPump) {
    ASSERT_TRUE(AudioInit(true));
    ClockPump();
    const auto position = channel().Position();
    AudioShutdown();
    ClockPump();
    EXPECT_FALSE(AudioUsesTickClock());
    EXPECT_EQ(channel().Position(), position);
}

TEST_F(AudioTick, TickRateChangesKeepTheFractionalSample) {
    ClockSetTickRate(93.0);
    ASSERT_TRUE(AudioInit(true));
    ClockPump();
    ClockSetTickRate(60.0);
    ClockPump();
    const auto rate = audio::DefaultMixer().Rate();
    EXPECT_EQ(channel().Position(), static_cast<int64_t>(static_cast<double>(rate) / 93.0 + rate / 60.0));
}

TEST_F(AudioTick, HeadlessWavCaptureKeepsOneMixerDriver) {
    capture_ = std::filesystem::temp_directory_path() /
               ("audio-tick-" + std::to_string(dc::test::ProcessId()) + ".wav");
    dc::test::SetEnv("DC2_AUDIO_WAV", capture_, 1);
    ASSERT_TRUE(AudioInit(true));
    EXPECT_TRUE(AudioOutputRunning());
    EXPECT_FALSE(AudioUsesTickClock());
    ClockPump();
    const auto frames = audio::DefaultMixer().Rate() / 60;
    EzBgmStep();
    EXPECT_EQ(channel().Position(), frames);
    AudioShutdown();
    EXPECT_EQ(std::filesystem::file_size(capture_), 44u + static_cast<uint64_t>(frames) * 4);
}
