#include <gtest/gtest.h>

#include <algorithm>
#include <chrono>
#include <cstdint>
#include <filesystem>
#include <fstream>
#include <memory>
#include <thread>
#include <vector>

#include "audio/mixer.hpp"
#include "audio/pcm.hpp"
#include "audio/soundtrack.hpp"
#include "audio_bank_fixture.hpp"
#include "platform/config.hpp"
#include "platform/paths.hpp"
#include "platform_fixture.hpp"
#include "sound.hpp"
#include "sound_port.hpp"

namespace {
namespace fs = std::filesystem;
namespace fx = dc::test;

class PcOptionsAudio : public testing::Test {
protected:
    fs::path root;

    void SetUp() override {
        root = fs::temp_directory_path() / ("dc2_pc_options_audio_" + std::to_string(fx::ProcessId()));
        fs::remove_all(root);
        fs::create_directories(root / "save");
        PathsSetSaveRoot(root / "save");
        ConfigLoad();
        audio::SoundtrackReload();
    }

    void TearDown() override {
        ConfigChange(Config{});
        SoundApplySettings();
        audio::SoundtrackReload();
        fs::remove_all(root);
    }

    void WriteRecording() {
        fs::create_directories(root / "soundtrack");
        std::ofstream out(root / "soundtrack/test.wav", std::ios::binary);
        const auto    u32 = [&](std::uint32_t value) { out.write(reinterpret_cast<const char *>(&value), 4); };
        const auto    u16 = [&](std::uint16_t value) { out.write(reinterpret_cast<const char *>(&value), 2); };
        out.write("RIFF", 4);
        u32(36 + 4096);
        out.write("WAVEfmt ", 8);
        u32(16);
        u16(1);
        u16(1);
        u32(48000);
        u32(96000);
        u16(2);
        u16(16);
        out.write("data", 4);
        u32(4096);
        for (int n = 0; n < 2048; ++n) {
            u16(8192);
        }
        out.close();
        std::ofstream(root / "soundtrack/soundtrack.json")
            << R"({"version":1,"overrides":{"test.sq":{"file":"test.wav","loop":true}}})";
    }
};
} // namespace

TEST_F(PcOptionsAudio, MasterGainAppliesAtSoundInitAndLiveWithoutChangingRetailVolume) {
    Config config = ConfigGet();
    config.master_volume = .5f;
    ASSERT_TRUE(ConfigChange(config));
    CSnd.Init(4, 0, 40, 0);
    auto track = std::make_shared<audio::PcmTrack>();
    track->rate = 48000;
    track->samples.assign(4096, 8192);
    auto &mixer = audio::DefaultMixer();
    mixer.SetStream(0, track);
    mixer.SetVolume(0, 256);
    mixer.Rewind(0, 0);
    mixer.Play(0);
    const auto before = fx::RenderFrames(mixer, 128);
    ASSERT_GT(fx::Rms(before), .01);
    config.master_volume = .125f;
    ASSERT_TRUE(ConfigChange(config));
    SoundApplySettings();
    const auto after = fx::RenderFrames(mixer, 128);
    EXPECT_NEAR(fx::Rms(after) / fx::Rms(before), .25, .001);
    EXPECT_EQ(mixer.Volume(0), 256);
    config.master_volume = 0;
    ConfigChange(config);
    SoundApplySettings();
    EXPECT_EQ(fx::Rms(fx::RenderFrames(mixer, 128)), 0);
}

TEST_F(PcOptionsAudio, SoundtrackUsesTheLoadedSequenceNameOnTheNextPlay) {
    WriteRecording();
    CSnd.Init(4, 0, 40, 0);
    const auto sq = fx::MakeSq(60, 100, 960);
    ASSERT_EQ(SoundLoadSequenceJson(0, std::string_view(reinterpret_cast<const char *>(sq.data()), sq.size()), "test.sq"), 0);
    // No bank: the PS2 song is silent, while the custom recording needs no bank.
    CSnd.SQ_Play(0, 0, 256);
    EXPECT_EQ(fx::Rms(fx::RenderFrames(audio::DefaultMixer(), 128)), 0);
    Config config = ConfigGet();
    config.soundtrack = true;
    ConfigChange(config);
    audio::SoundtrackReload();
    CSnd.SQ_Play(0, 0, 256);
    const auto request = audio::SoundtrackRequestFor("test.sq");
    ASSERT_NE(request, nullptr);
    const auto deadline = std::chrono::steady_clock::now() + std::chrono::seconds(2);
    while (!request->ready.load() && std::chrono::steady_clock::now() < deadline) {
        std::this_thread::sleep_for(std::chrono::milliseconds(1));
    }
    ASSERT_TRUE(request->ready.load());
    EXPECT_GT(fx::Rms(fx::RenderFrames(audio::DefaultMixer(), 128)), .1);
    config.soundtrack = false;
    ConfigChange(config);
    CSnd.SQ_Play(0, 0, 256);
    EXPECT_EQ(fx::Rms(fx::RenderFrames(audio::DefaultMixer(), 128)), 0);
}

TEST_F(PcOptionsAudio, MissingCustomTrackFallsBackToThePs2Sequence) {
    WriteRecording();
    Config config = ConfigGet();
    config.soundtrack = true;
    ConfigChange(config);
    CSnd.Init(4, 0, 40, 0);
    SoundBindBank(0, fx::CreateBankFixture({}));
    const auto sq = fx::MakeSq(60, 100, 960);
    ASSERT_EQ(SoundLoadSequenceJson(0, std::string_view(reinterpret_cast<const char *>(sq.data()), sq.size()), "missing.sq"), 0);
    CSnd.SQ_Play(0, 0, 256);
    EXPECT_GT(fx::Rms(fx::RenderFrames(audio::DefaultMixer(), 4800)), .01);
}
