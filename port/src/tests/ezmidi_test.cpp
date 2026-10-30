#include "common.h"

#include <gtest/gtest.h>

#include <array>
#include <cstddef>

#include "audio/mixer.hpp"
#include "ezmidi.hpp"
#include "sound.hpp"

namespace {

constexpr int                kPort = 5;
constexpr int                kOtherPort = 1;
constexpr std::array<int, 2> kTouched = {kPort, kOtherPort};

// The mixer is shared by the whole process, so each case hands back the port and stereo state it found.
class MixerRestore {
public:
    MixerRestore() : stereo_(audio::DefaultMixer().Stereo()) {
        for (std::size_t i = 0; i < kTouched.size(); i++) {
            volume_[i] = audio::DefaultMixer().Volume(kTouched[i]);
            attribute_[i] = audio::DefaultMixer().Attribute(kTouched[i]);
        }
    }

    ~MixerRestore() {
        audio::Mixer &mixer = audio::DefaultMixer();
        for (std::size_t i = 0; i < kTouched.size(); i++) {
            mixer.SetVolume(kTouched[i], volume_[i]);
            mixer.SetAttribute(kTouched[i], attribute_[i]);
        }
        mixer.SetStereo(stereo_);
    }

    MixerRestore(const MixerRestore &) = delete;
    MixerRestore &operator=(const MixerRestore &) = delete;

private:
    bool                             stereo_;
    std::array<int, kTouched.size()> volume_{};
    std::array<int, kTouched.size()> attribute_{};
};

} // namespace

TEST(EzMidi, VolumeCommandSetsThePortVolume) {
    MixerRestore restore;

    ezMidi(0xB0 + kPort, 200);
    EXPECT_EQ(audio::DefaultMixer().Volume(kPort), 200);
    EXPECT_EQ(ezMidi(0x80E0 + kPort, 0), 200);
}

TEST(EzMidi, AttributeCommandSetsThePortAttribute) {
    MixerRestore restore;

    ezMidi(0xA0 + kPort, 0x3033);
    EXPECT_EQ(audio::DefaultMixer().Attribute(kPort), 0x3033);
}

TEST(EzMidi, StereoCommandTogglesTheMixerMode) {
    MixerRestore restore;

    ezMidi(0xC0, 0);
    EXPECT_FALSE(audio::DefaultMixer().Stereo());
    ezMidi(0xC0, 1);
    EXPECT_TRUE(audio::DefaultMixer().Stereo());
}

TEST(EzMidi, RetailSetStereoModeReachesTheMixer) {
    MixerRestore restore;

    CSnd.SetStereoMode(0);
    EXPECT_FALSE(audio::DefaultMixer().Stereo());
}

TEST(EzMidi, InitReportsTheServerIsBound) {
    EXPECT_EQ(ezMidiInit(), 1);
}

TEST(EzMidi, AddressCommandIsRefusedAndChangesNothing) {
    MixerRestore restore;

    ezMidi(0xB0 + kOtherPort, 77);
    const bool stereo_before = audio::DefaultMixer().Stereo();

    EXPECT_EQ(ezMidi(0x9050 + kOtherPort, 0x1234), 0);
    EXPECT_EQ(audio::DefaultMixer().Volume(kOtherPort), 77);
    EXPECT_EQ(audio::DefaultMixer().Stereo(), stereo_before);
}
