#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <filesystem>
#include <fstream>
#include <memory>
#include <optional>
#include <set>
#include <span>
#include <string>
#include <system_error>
#include <vector>

#include "audio/hdbank.hpp"
#include "audio/hsmsg.hpp"
#include "audio/mixer.hpp"
#include "audio/sq.hpp"
#include "audio_bank_fixture.hpp"
#include "dataread.hpp"
#include "ezbgm.hpp"
#include "platform/paths.hpp"
#include "snd_mngr.hpp"
#include "sound.hpp"
#include "sound_port.hpp"

namespace fx = dc::test;
namespace fs = std::filesystem;

namespace {

class Sound : public ::testing::Test {
protected:
    void SetUp() override { CSnd.Exit(); }

    void TearDown() override { CSnd.Exit(); }
};

constexpr int kSePort = 12;
constexpr int kFrames = 4800;
constexpr int kOneSecond = 48000;
constexpr std::uint8_t kKey = 60;
constexpr std::uint8_t kId = 1;
constexpr std::uint8_t kOtherId = 2;

std::vector<std::uint8_t> Hd(const fx::BankSpec &spec = {}) {
    return fx::MakeHd(spec);
}

fx::BankSpec OctaveDown() {
    fx::BankSpec spec;
    spec.base_note = 72;
    return spec;
}

std::shared_ptr<audio::Bank> FixtureBank(const std::vector<std::uint8_t> &bytes) {
    const std::string text(bytes.begin(), bytes.end());
    const int         rate = nlohmann::json::parse(text).at("vags").at(0).at("rate");
    return audio::Bank::CreateFromJson(text, [&](const auto &) { return fx::SampleFile(rate); });
}

void LoadBank(int port, const std::vector<std::uint8_t> &bytes) { SoundBindBank(port, FixtureBank(bytes)); }

int AddBank(int port, const std::vector<std::uint8_t> &bytes) { return SoundBindBank(port, FixtureBank(bytes), true); }

void Play(int bank, std::uint8_t id = kId) {
    CSnd.SE_Play(kSePort, bank, 0, kKey, 64, 127, 127, 0x2000, id);
}

void Stop(int bank, std::uint8_t id = kId) {
    CSnd.SE_Stop(kSePort, bank, 0, kKey, id);
}

std::vector<float> Render(int frames) {
    return fx::RenderFrames(audio::DefaultMixer(), frames);
}

int Crossings() {
    return fx::ZeroCrossings(Render(kFrames));
}

// The expected count comes from a standalone mixer: the driver has no bank 0 measurement to compare
// against once the reload has run, and the same key-on on a fresh mixer is the reference bank 0 plays.
int ReferenceCrossings(const std::vector<std::uint8_t> &hd) {
    audio::Mixer mixer(audio::DefaultMixer().Rate());
    mixer.BindBank(kSePort, FixtureBank(hd));
    mixer.SetVolume(kSePort, audio::kFullPortVolume);
    mixer.ShortMessage(kSePort, 0xC0);
    const std::array<std::uint8_t, audio::kHsMsgBytes> key_on{0xFD, 0x10, 0x00, kKey, kId, 127, 0x00};
    mixer.HsMessage(kSePort, key_on);
    return fx::ZeroCrossings(fx::RenderFrames(mixer, kFrames));
}

} // namespace

TEST_F(Sound, SePlaysANoteAfterTheStep) {
    CSnd.Init(4, 0, 40, 0);
    LoadBank(kSePort, Hd());
    CSnd.SetVol(kSePort, 256);

    Play(0);
    EXPECT_EQ(fx::Rms(Render(kFrames)), 0.0);

    CSnd.Step();
    EXPECT_GT(fx::Rms(Render(kFrames)), 0.01);

    Stop(0);
    CSnd.Step();
    Render(kOneSecond);
    EXPECT_LT(fx::Rms(Render(kFrames)), 1e-3);
}

TEST_F(Sound, SeIsGatedOnALoadedBank) {
    CSnd.Init(4, 0, 40, 0);
    CSnd.SetVol(kSePort, 256);

    Play(0);
    CSnd.Step();
    EXPECT_EQ(fx::Rms(Render(kFrames)), 0.0);
}

TEST_F(Sound, SePitchRaisesTheVoice) {
    CSnd.Init(4, 0, 40, 0);
    LoadBank(kSePort, Hd());
    CSnd.SetVol(kSePort, 256);

    Play(0);
    CSnd.Step();
    const int before = Crossings();
    ASSERT_GT(before, 100);

    CSnd.SE_SetPitch(kSePort, 0, 0, kKey, 0x3FFF, kId);
    CSnd.Step();
    const int after = Crossings();

    const double expected = std::exp2(2.0 / 12.0);
    EXPECT_NEAR(static_cast<double>(after) / before, expected, 0.05 * expected);
}

TEST_F(Sound, AddedBankIsSelectedByTheBankNumber) {
    CSnd.Init(4, 0, 40, 0);
    LoadBank(kSePort, Hd());
    ASSERT_EQ(AddBank(kSePort, Hd(OctaveDown())), 0);
    CSnd.SetVol(kSePort, 256);

    Play(0, kId);
    CSnd.Step();
    const int low_count = Crossings();
    ASSERT_GT(low_count, 100);

    // The release tail is counted by ZeroCrossings too, so bank 1 is only measured once it has died away.
    Stop(0, kId);
    CSnd.Step();
    Render(kOneSecond);
    ASSERT_LT(fx::Rms(Render(kFrames)), 1e-3);

    Play(1, kOtherId);
    CSnd.Step();
    const int high_count = Crossings();

    EXPECT_NEAR(static_cast<double>(high_count) / low_count, 0.5, 0.03);
}

TEST_F(Sound, SequencePlaysThroughLoadSeqAndSqPlay) {
    CSnd.Init(4, 0, 40, 0);
    LoadBank(0, Hd());
    const auto sq = fx::MakeSq(60, 100, 960);
    ASSERT_EQ(SoundLoadSequenceJson(0, std::string_view(reinterpret_cast<const char *>(sq.data()), sq.size())), 0);

    CSnd.SQ_Play(0, 0, 256);
    EXPECT_GT(fx::Rms(Render(kFrames)), 0.01);

    // Retail returns before stopping on a bad index, so the note keeps sounding through the call.
    CSnd.SQ_Play(0, 5, 256);
    EXPECT_GT(fx::Rms(Render(kFrames)), 0.01);
}

TEST_F(Sound, SecondLoadReplacesTheBanks) {
    CSnd.Init(4, 0, 40, 0);
    const auto first = Hd();
    LoadBank(kSePort, first);
    ASSERT_EQ(AddBank(kSePort, Hd(OctaveDown())), 0);
    LoadBank(kSePort, first);
    CSnd.SetVol(kSePort, 256);

    Play(1);
    CSnd.Step();

    EXPECT_EQ(Crossings(), ReferenceCrossings(first));
}

TEST_F(Sound, MasterVolumeScalesTheCore) {
    CSnd.Init(4, 0, 40, 0);
    // The reverb tail from the loud window would bleed into the half window and skew the ratio.
    CSnd.SetReverb(0, 0, 0);
    CSnd.SetReverb(1, 0, 0);
    LoadBank(kSePort, Hd());
    CSnd.SetVol(kSePort, 256);

    Play(0);
    CSnd.Step();
    // The exponential attack outlasts the first window, so both measured windows follow it.
    Render(kOneSecond);
    const double full = fx::Rms(Render(kFrames));
    ASSERT_GT(full, 0.01);

    CSnd.SetMasterVol(0, 0x3FFF / 2);
    CSnd.SetMasterVol(1, 0x3FFF / 2);
    const double half = fx::Rms(Render(kFrames));

    EXPECT_NEAR(half / full, 0.5, 0.03);
}

TEST_F(Sound, IntAddressLoadsAreRefused) {
    CSnd.Init(4, 0, 40, 0);
    CSnd.SetVol(kSePort, 256);

    CSnd.LoadHdBd(kSePort, 0, 0, 0, 0);
    CSnd.LoadHdBd2(kSePort, 0, 0, 0, 0);
    EXPECT_EQ(CSnd.LoadHdBdAdd(kSePort, 0, 0, 0, 0), -1);
    EXPECT_EQ(CSnd.LoadSeq(0, 0, 0), -1);

    // A bank loaded by the refused calls would make this note audible, so silence means nothing got loaded.
    Play(0);
    CSnd.Step();
    EXPECT_EQ(fx::Rms(Render(kFrames)), 0.0);
}

TEST_F(Sound, TransferIsAlwaysComplete) {
    CSnd.Init(4, 0, 40, 0);
    EXPECT_NE(CSnd.TransBdState(1), 0);
}

TEST_F(Sound, InitMngrStartsTheDriver) {
    sndInitMngr();
    sndSetMasterVol(0, 0.5f);
    sndSetMasterVol(1, 0.5f);

    sndInitMngr();
    EXPECT_FLOAT_EQ(audio::DefaultMixer().CoreVolume(0), 1.0f);
    EXPECT_FLOAT_EQ(audio::DefaultMixer().CoreVolume(1), 1.0f);
}

namespace {
std::string ReadDocument(const fs::path &path) {
    std::ifstream in(path);
    return {std::istreambuf_iterator<char>(in), {}};
}
} // namespace

TEST(SoundRealData, PublishedBanksAndSequencesLoad) {
    fs::path root;
    for (fs::path dir = PathsExecutable().parent_path(); !dir.empty(); dir = dir.parent_path()) {
        if (fs::is_directory(dir / "port_data/snd2")) {
            root = dir / "port_data";
            break;
        }
        if (dir == dir.parent_path()) {
            break;
        }
    }
    if (root.empty()) {
        GTEST_SKIP() << "no published native sound bundles near test executable";
    }
    for (const auto &entry : fs::recursive_directory_iterator(root / "snd2")) {
        if (!entry.is_regular_file() || entry.path().extension() != ".json") {
            continue;
        }
        const auto document = ReadDocument(entry.path());
        const auto kind = nlohmann::json::parse(document).value("kind", "");
        if (kind == "bank") {
            EXPECT_NE(audio::Bank::CreateFromJson(document, [&](const auto &p) { return root / p; }), nullptr) << entry.path();
        }
        if (kind == "sequence") {
            EXPECT_NE(audio::SqFile::CreateFromJson(document), nullptr) << entry.path();
        }
    }
}
