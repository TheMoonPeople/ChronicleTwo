#include <gtest/gtest.h>

#include <cstdlib>
#include <vector>

#include "debug_fixture.hpp"
#include "gamepad.hpp"
#include "nowload.hpp"
#include "object/menu/loading_screen.hpp"
#include "platform/config.hpp"
#include "platform/input.hpp"
#include "platform/paths.hpp"
#include "test_hooks.hpp"

using GamePadSingleDebug = dc::test::DebugFixture;

TEST(TestHooks, JumpAcceptsModesAndBounds) {
    GameJump jump;
    EXPECT_TRUE(GameParseJump("town", jump));
    EXPECT_EQ(jump.map, 10);
    EXPECT_TRUE(GameParseJump("edit:12", jump));
    EXPECT_EQ(jump.map, 12);
    EXPECT_TRUE(GameParseJump("dungeon:0:1", jump));
    EXPECT_EQ(jump.floor, 1);
    EXPECT_TRUE(GameParseJump("dungeon:6:38", jump));
    EXPECT_EQ(jump.map, 6);
    EXPECT_TRUE(GameParseJump("event:26010", jump));
    EXPECT_EQ(jump.event, 26010);
    for (const auto *mode : {"title", "opening", "menu"}) {
        EXPECT_TRUE(GameParseJump(mode, jump));
    }
    for (const auto *bad : {"", "bogus", "title:0", "town:", "town:-1", "town:189", "town:1junk",
                            "dungeon:", "dungeon:7", "dungeon:0:0", "dungeon:0:9", "dungeon:6:39", "dungeon:0:100", "dungeon:0:1:2",
                            "event", "event:0", "event:-1", "event:2147483648"}) {
        SCOPED_TRACE(bad);
        EXPECT_FALSE(GameParseJump(bad, jump));
    }
}

TEST(TestHooks, GiveRejectsMalformedListsWithoutChangingThePreviousList) {
    std::vector<int> items;
    ASSERT_TRUE(GameParseGive("2,24,303", items));
    EXPECT_EQ(items, (std::vector<int>{2, 24, 303}));
    for (const auto *bad : {"", "1,", ",1", "1,,2", "0", "-1", "32768", "2 3", "2x"}) {
        EXPECT_FALSE(GameParseGive(bad, items));
        EXPECT_EQ(items, (std::vector<int>{2, 24, 303}));
    }
}

TEST_F(GamePadSingleDebug, ModifierRoutesEdgesAndHeldButtonsPastThePad2Lock) {
    CGamePad pad{};
    pad.key_lock2 = 1;
    pad.pad[0].button = PAD_L2 | PAD_SELECT | PAD_CIRCLE | PAD_RIGHT | PAD_R2;
    pad.previous_pad[0].button = PAD_L2 | PAD_SELECT;
    EXPECT_TRUE(pad.On2(PAD_RIGHT));
    EXPECT_TRUE(pad.Down2(PAD_CIRCLE));
    EXPECT_TRUE(pad.Down2(PAD_R2));
    EXPECT_FALSE(pad.Down(PAD_CIRCLE));
    pad.previous_pad[0].button = pad.pad[0].button;
    EXPECT_FALSE(pad.Down2(PAD_CIRCLE));
    EXPECT_TRUE(pad.On2(PAD_RIGHT));
    pad.key_lock = 1;
    EXPECT_FALSE(pad.On2(PAD_RIGHT));
    EXPECT_FALSE(pad.Down2(PAD_R2));
}

TEST_F(GamePadSingleDebug, OrdinaryPad1AndRealPad2RetainTheirButtons) {
    CGamePad pad{};
    pad.pad[0].button = PAD_CIRCLE | PAD_RIGHT;
    EXPECT_TRUE(pad.Down(PAD_CIRCLE));
    EXPECT_FALSE(pad.Down2(PAD_CIRCLE));
    pad.pad[1].button = PAD_L1 | PAD_SELECT;
    EXPECT_TRUE(pad.Down2(PAD_L1));
    EXPECT_TRUE(pad.On2(PAD_SELECT));
    pad.key_lock2 = 1;
    EXPECT_FALSE(pad.Down2(PAD_L1));
}

TEST_F(GamePadSingleDebug, AddingL2AfterSelectDoesNotPauseDuringTimeScrubbing) {
    CGamePad pad{};
    pad.previous_pad[0].button = PAD_SELECT;
    pad.pad[0].button = PAD_SELECT | PAD_L2 | PAD_RIGHT;
    EXPECT_TRUE(pad.On2(PAD_RIGHT));
    EXPECT_TRUE(pad.Down2(PAD_RIGHT));
    EXPECT_FALSE(pad.Down2(PAD_SELECT));
}

TEST_F(GamePadSingleDebug, ModifiedStartCapturesWhileOrdinaryStartResumes) {
    CGamePad pad{};
    pad.key_lock2 = 1;
    pad.previous_pad[0].button = PAD_L2 | PAD_SELECT;
    pad.pad[0].button = PAD_L2 | PAD_SELECT | PAD_START;
    EXPECT_TRUE(pad.Down2(PAD_START));
    EXPECT_FALSE(GameDebugPauseResumeRequested(pad));
    pad.pad[0].button = PAD_START;
    EXPECT_TRUE(GameDebugPauseResumeRequested(pad));
    pad.pad[0].button = 0;
    pad.previous_pad[1].button = 0;
    pad.pad[1].button = PAD_SELECT;
    pad.key_lock2 = 0;
    EXPECT_TRUE(GameDebugPauseResumeRequested(pad));
}

TEST_F(GamePadSingleDebug, DeveloperMenuChordUsesHostInputPastTheGameLockAndOnlyOnAnEdge) {
    InputPadState input;
    input.connected = true;
    input.buttons = 0;
    InputSetOverride(0, &input);
    EXPECT_FALSE(GameDeveloperMenuRequested(LOOP_EDIT));
    input.buttons = kInputStart | kInputSelect;
    InputSetOverride(0, &input);
    GamePad__2.key_lock = 1;
    EXPECT_TRUE(GameDeveloperMenuRequested(LOOP_EDIT));
    EXPECT_FALSE(GameDeveloperMenuRequested(LOOP_EDIT));
    input.buttons = 0;
    InputSetOverride(0, &input);
    EXPECT_FALSE(GameDeveloperMenuRequested(LOOP_EDIT));
    input.buttons = kInputStart | kInputSelect;
    InputSetOverride(0, &input);
    EXPECT_FALSE(GameDeveloperMenuRequested(LOOP_MENU));
    InputSetOverride(0, nullptr);
    GamePad__2.key_lock = 0;
}

TEST_F(GamePadSingleDebug, DeveloperMenuChordRequiresBothButtonsReleasedToRearm) {
    InputPadState input;
    input.buttons = 0;
    InputSetOverride(0, &input);
    EXPECT_FALSE(GameDeveloperMenuRequested(LOOP_EDIT));
    input.buttons = kInputStart;
    InputSetOverride(0, &input);
    EXPECT_FALSE(GameDeveloperMenuRequested(LOOP_EDIT));
    input.buttons |= kInputSelect;
    InputSetOverride(0, &input);
    EXPECT_TRUE(GameDeveloperMenuRequested(LOOP_EDIT));
    for (auto remaining : {kInputStart, kInputSelect}) {
        input.buttons = remaining;
        InputSetOverride(0, &input);
        EXPECT_FALSE(GameDeveloperMenuRequested(LOOP_MENU));
        input.buttons = kInputStart | kInputSelect;
        InputSetOverride(0, &input);
        EXPECT_FALSE(GameDeveloperMenuRequested(LOOP_EDIT));
    }
    input.buttons = 0;
    InputSetOverride(0, &input);
    EXPECT_FALSE(GameDeveloperMenuRequested(LOOP_EDIT));
    input.buttons = kInputStart | kInputSelect;
    InputSetOverride(0, &input);
    EXPECT_TRUE(GameDeveloperMenuRequested(LOOP_EDIT));
    InputSetOverride(0, nullptr);
}

TEST(TestHooks, FastLoadingOnlyChangesTheLoadingBarCompletionRate) {
    PortLoadInfo.step_count = 15;
    GameSetFastLoad(false);
    NowLoadingBarSteEnd();
    EXPECT_EQ(PortProgBarCnt, 15);
    EXPECT_FLOAT_EQ(PortProgBarWidthStep, 0.05f);
    GameSetFastLoad(true);
    NowLoadingBarSteEnd();
    EXPECT_EQ(PortProgBarCnt, 15);
    EXPECT_FLOAT_EQ(PortProgBarWidthStep, 1.0f);
    GameSetFastLoad(false);
}

TEST(TestHooks, OrdinaryDefaultsDisableDebugRoutingAndDeveloperChord) {
    EXPECT_FALSE(Config{}.debug_mode);
    EXPECT_FALSE(GameDebugEnabled());
    CGamePad pad{};
    pad.key_lock2 = 1;
    pad.pad[0].button = PAD_L2 | PAD_SELECT | PAD_CIRCLE;
    EXPECT_FALSE(pad.Down2(PAD_CIRCLE));
    EXPECT_FALSE(GameDebugPauseRequested(pad));
    EXPECT_TRUE(pad.Down(PAD_CIRCLE));
    InputPadState input;
    input.connected = true;
    input.buttons = kInputStart | kInputSelect;
    InputSetOverride(0, &input);
    EXPECT_FALSE(GameDeveloperMenuRequested(LOOP_EDIT));
    InputSetOverride(0, nullptr);
}

TEST(TestHooks, JumpExplicitlyEnablesDebugWithOrdinaryDefaults) {
    ASSERT_EXIT(
        {
            EXPECT_FALSE(Config{}.debug_mode);
            EXPECT_FALSE(GameDebugEnabled());
            ASSERT_TRUE(GameSetJump("title"));
            EXPECT_TRUE(GameDebugEnabled());
            CGamePad pad{};
            pad.previous_pad[0].button = PAD_L2;
            pad.pad[0].button = PAD_L2 | PAD_SELECT;
            EXPECT_TRUE(GameDebugPauseRequested(pad));
            std::_Exit(testing::Test::HasFailure() ? 1 : 0);
        },
        testing::ExitedWithCode(0), "");
}

TEST_F(GamePadSingleDebug, ExplicitPauseChordEntersAndResumesWithoutLeakingModifiers) {
    CGamePad pad{};
    pad.key_lock2 = 1;
    pad.previous_pad[0].button = PAD_L2;
    pad.pad[0].button = PAD_L2 | PAD_SELECT;
    EXPECT_TRUE(GameDebugPauseRequested(pad));
    EXPECT_TRUE(GameDebugPauseResumeRequested(pad));
    EXPECT_FALSE(pad.Down2(PAD_SELECT | PAD_L2));
    EXPECT_FALSE(pad.Down(PAD_SELECT | PAD_L2));
    pad.previous_pad[0].button = pad.pad[0].button;
    EXPECT_FALSE(GameDebugPauseRequested(pad));
    pad.previous_pad[0].button = PAD_SELECT;
    EXPECT_FALSE(GameDebugPauseRequested(pad));
    pad.previous_pad[0].button = PAD_L2;
    pad.key_lock = 1;
    EXPECT_FALSE(GameDebugPauseRequested(pad));
    EXPECT_FALSE(GameDebugPauseResumeRequested(pad));
}
