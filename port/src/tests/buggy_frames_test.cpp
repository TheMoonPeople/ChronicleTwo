#include <gtest/gtest.h>

#include <cstring>

#include "character.hpp"
#include "stubs/pbuggy.hpp"

namespace {

// Shift-JIS names of the motions the train fight times.
constexpr char kLift[] = "\x8e\x9d\x82\xbf\x8f\xe3\x82\xb0";
constexpr char kThrow[] = "\x94\x9a\x92\x65\x93\x8a\x82\xb0";
constexpr char kReload[] = "\x94\x9a\x92\x65\x82\xf0\x8e\xe6\x82\xe9";
constexpr char kWalk[] = "\x95\xe0\x82\xab";

/**
 * Builds a motion key with the supplied animation interval and playback speed.
 */
CHRINFO_KEY_SET Key(const char *name, int start_frame, int end_frame, float step) {
    CHRINFO_KEY_SET key{};
    std::strcpy(key.name, name);
    key.start_frame = start_frame;
    key.end_frame = end_frame;
    key.step = step;
    return key;
}

/**
 * Counts train-fight event crossings during one complete motion playback.
 */
int Crossings(const CHRINFO_KEY_SET &key, float retail_frame) {
    CCharacter2     character;
    CHRINFO_KEY_SET playing = key;
    character.now_key = &playing;
    character.step = key.step;
    int crossings = 0;
    for (character.frame = static_cast<float>(key.start_frame); character.frame <= static_cast<float>(key.end_frame); character.frame += key.step) {
        const float frame_now = PortBuggyRetailFrame(&character);
        const float frame_next = frame_now + character.GetStep();
        if (frame_now <= retail_frame && !(frame_next <= retail_frame)) {
            ++crossings;
        }
    }
    return crossings;
}

} // namespace

// The native loader lays the player's sub-game motions out after the base set: the lift at 367-382 and the throw at
// 400-417, which retail's mints_bomb.chr has at 11-26 and 38-55.
TEST(BuggyRetailFrames, PlayerTakesAndThrowsTheBombOnceInTheNativeLayout) {
    EXPECT_EQ(Crossings(Key(kLift, 367, 382, 0.7f), 15.0f), 1);
    EXPECT_EQ(Crossings(Key(kThrow, 400, 417, 0.5f), 44.0f), 1);
}

// The bomb carrier's reload is 6-36 natively and 9-39 in retail's starbre.chr.
TEST(BuggyRetailFrames, CarrierHoldsAndSetsDownTheBombAtRetailFrames) {
    EXPECT_EQ(Crossings(Key(kReload, 6, 36, 1.0f), 18.0f), 1);
    EXPECT_EQ(Crossings(Key(kReload, 6, 36, 1.0f), 30.9f), 1);
    CCharacter2     character;
    CHRINFO_KEY_SET reload = Key(kReload, 6, 36, 1.0f);
    character.now_key = &reload;
    character.frame = 15.0f;
    EXPECT_FLOAT_EQ(PortBuggyRetailFrame(&character), 18.0f);
    character.frame = 27.9f;
    EXPECT_FLOAT_EQ(PortBuggyRetailFrame(&character), 30.9f);
}

TEST(BuggyRetailFrames, RetailLayoutAndOtherMotionsKeepTheirFrame) {
    EXPECT_EQ(Crossings(Key(kLift, 11, 26, 0.7f), 15.0f), 1);
    EXPECT_EQ(Crossings(Key(kThrow, 38, 55, 0.5f), 44.0f), 1);
    EXPECT_EQ(Crossings(Key(kReload, 9, 39, 1.0f), 18.0f), 1);
    EXPECT_EQ(Crossings(Key(kReload, 9, 39, 1.0f), 30.9f), 1);
    CCharacter2     character;
    CHRINFO_KEY_SET walk = Key(kWalk, 6, 26, 0.5f);
    character.now_key = &walk;
    character.frame = 10.0f;
    EXPECT_FLOAT_EQ(PortBuggyRetailFrame(&character), 10.0f);
    character.now_key = nullptr;
    EXPECT_FLOAT_EQ(PortBuggyRetailFrame(&character), 10.0f);
}
