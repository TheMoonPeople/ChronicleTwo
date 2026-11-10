#include <gtest/gtest.h>

#include "debug_fixture.hpp"
#include "gamepad.hpp"
#include "test_hooks.hpp"

using GamePadDebugInput = dc::test::DebugFixture;

TEST_F(GamePadDebugInput, BothModifierOrdersConsumeSelectAndL2FromTheRoutedPad) {
    for (int first : {PAD_SELECT, PAD_L2}) {
        CGamePad pad{};
        pad.key_lock2 = 1;
        pad.previous_pad[0].button = first;
        pad.pad[0].button = PAD_SELECT | PAD_L2 | PAD_RIGHT | PAD_CIRCLE;
        EXPECT_FALSE(pad.On2(PAD_SELECT | PAD_L2));
        EXPECT_FALSE(pad.Down2(PAD_SELECT | PAD_L2));
        EXPECT_TRUE(pad.On2(PAD_RIGHT));
        EXPECT_TRUE(pad.Down2(PAD_CIRCLE));
    }
}

TEST_F(GamePadDebugInput, Pad1ConsumesHeldDownUpAndReleaseEdgesOfTheWholeCombo) {
    constexpr int consumed = PAD_SELECT | PAD_L2 | PAD_CIRCLE | PAD_CROSS;
    CGamePad      pad{};
    pad.pad[0].button = consumed | PAD_RIGHT;
    EXPECT_FALSE(pad.On(consumed));
    EXPECT_FALSE(pad.Down(consumed));
    EXPECT_EQ(pad.GetPadOn(), PAD_RIGHT);
    EXPECT_EQ(pad.GetPadDown(), PAD_RIGHT);
    EXPECT_TRUE(pad.Down2(PAD_CIRCLE | PAD_CROSS));
    pad.previous_pad[0].button = pad.pad[0].button;
    pad.pad[0].button = PAD_SELECT | PAD_L2;
    EXPECT_FALSE(pad.Up(PAD_CIRCLE | PAD_CROSS));
    EXPECT_EQ(pad.GetPadUp(), PAD_RIGHT);
    pad.pad[0].button = 0;
    EXPECT_FALSE(pad.Up(consumed));
    EXPECT_EQ(pad.GetPadUp(), PAD_RIGHT);
    // A real pad 2 retains retail Select/L2 semantics.
    pad.pad[1].button = PAD_SELECT | PAD_L2;
    EXPECT_TRUE(pad.On2(PAD_SELECT));
    EXPECT_TRUE(pad.Down2(PAD_L2));
}
