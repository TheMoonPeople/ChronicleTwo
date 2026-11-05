#include <gtest/gtest.h>

#include <algorithm>
#include <array>
#include <bit>
#include <cstdlib>
#include <limits>
#include <random>
#include <sstream>
#include <string>
#include <vector>

#include "collision.hpp"
#include "debug_fixture.hpp"
#include "gamepad.hpp"
#include "gameutil.hpp"
#include "nd_meswin.hpp"
#include "nowload.hpp"
#include "object/menu/loading_screen.hpp"
#include "platform/config.hpp"
#include "platform/input.hpp"
#include "platform/paths.hpp"
#include "test_hooks.hpp"

using GamePadSingleDebug = dc::test::DebugFixture;

namespace {
/**
 * Supplies identity-only scene and program tokens for the input state machine.
 */
dc2::debug::HalloweenPreambleInputContext PreambleInputContext() {
    alignas(64) static int scene_identity;
    static int             program_identity;
    return {.scene = reinterpret_cast<const CScene *>(&scene_identity), .program = &program_identity, .exact_scene = true, .running = true, .monster_id = 500, .tutorial_flags = 2, .live_boss = true, .message_state = CLSMES_SHOWN};
}
} // namespace

TEST(TestHooks, HalloweenAcknowledgementRequiresExplicitMeasuredTarget) {
    EXPECT_TRUE(dc2::debug::ConfigureHalloweenPreambleAcknowledgement(false));
    EXPECT_FALSE(dc2::debug::HalloweenPreambleAcknowledgementEnabled());
    const GameJump halloween{.mode = JumpMode::Event, .event = 21020};
    const GameJump other{.mode = JumpMode::Event, .event = 21010};
    const GameJump dungeon{.mode = JumpMode::Dungeon, .event = 21020};
    using dc2::debug::HalloweenPreambleAcknowledgementAllowed;
    EXPECT_TRUE(HalloweenPreambleAcknowledgementAllowed(false, nullptr, 0));
    EXPECT_FALSE(HalloweenPreambleAcknowledgementAllowed(true, nullptr, 8));
    EXPECT_FALSE(HalloweenPreambleAcknowledgementAllowed(true, &other, 8));
    EXPECT_FALSE(HalloweenPreambleAcknowledgementAllowed(true, &dungeon, 8));
    EXPECT_FALSE(HalloweenPreambleAcknowledgementAllowed(true, &halloween, 0));
    EXPECT_FALSE(HalloweenPreambleAcknowledgementAllowed(true, &halloween, -1));
    EXPECT_TRUE(HalloweenPreambleAcknowledgementAllowed(true, &halloween, 8));
}

TEST(TestHooks, HalloweenAcknowledgementProducesOneOrdinaryEdgeAndNaturalRelease) {
    auto                               context = PreambleInputContext();
    dc2::debug::HalloweenPreambleInput input{.enabled = true};
    input.Observe(540, context.scene, context.program, 1);
    CGamePad pad{};
    pad.pad[0].button = PAD_RIGHT;
    pad.pad[0].left_x = 128;
    pad.pad[0].left_y = 127;
    pad.pad[0].right_x = 255;
    pad.pad[0].right_y = 128;
    pad.DebugKeyLock(1);
    ASSERT_TRUE(input.Apply(pad, context));
    EXPECT_TRUE(pad.Down(PAD_CIRCLE));
    EXPECT_EQ(pad.pad[0].button, PAD_RIGHT | PAD_CIRCLE);
    EXPECT_EQ(pad.pad[0].left_x, 128);
    EXPECT_EQ(pad.pad[0].left_y, 127);
    EXPECT_EQ(pad.pad[0].right_x, 255);
    EXPECT_EQ(pad.pad[0].right_y, 128);
    pad.previous_pad[0] = pad.pad[0];
    pad.pad[0].button = PAD_RIGHT;
    EXPECT_FALSE(input.Apply(pad, context));
    EXPECT_TRUE(pad.Up(PAD_CIRCLE));
    pad.previous_pad[0] = pad.pad[0];
    EXPECT_FALSE(input.Apply(pad, context));
    input.Observe(540, context.scene, context.program, 1);
    EXPECT_FALSE(input.Apply(pad, context));
}

TEST(TestHooks, HalloweenAcknowledgementRejectsEveryNonfinalMessageAndMeasurementCut) {
    const auto baseline = PreambleInputContext();
    const auto rejected = [](const auto &context) {
        dc2::debug::HalloweenPreambleInput input{.enabled = true};
        const auto                         original = PreambleInputContext();
        input.Observe(540, original.scene, original.program, 1);
        CGamePad pad{};
        EXPECT_FALSE(input.Apply(pad, context));
        EXPECT_FALSE(input.consumed);
        EXPECT_EQ(pad.pad[0].button, 0);
    };
    for (int state : {CLSMES_CLOSED, CLSMES_OPENING, CLSMES_REVEALING, CLSMES_CLOSING, CLSMES_PAGE_WAIT, CLSMES_SCROLLING}) {
        auto context = baseline;
        context.message_state = state;
        rejected(context);
    }
    auto context = baseline;
    context.exact_scene = false;
    rejected(context);
    context = baseline;
    context.running = false;
    rejected(context);
    context = baseline;
    context.ready = true;
    rejected(context);
    context = baseline;
    context.started = true;
    rejected(context);
    context = baseline;
    context.measuring = true;
    rejected(context);
    context = baseline;
    context.monster_id = 1000;
    rejected(context);
    context = baseline;
    context.live_boss = false;
    rejected(context);
    context = baseline;
    context.tutorial_flags = 1;
    rejected(context);
    context = baseline;
    context.scene = nullptr;
    rejected(context);
    context = baseline;
    context.program = nullptr;
    rejected(context);
}

TEST(TestHooks, HalloweenAcknowledgementNeverManufacturesHeldLockedOrDebugRoutedEdges) {
    const auto context = PreambleInputContext();
    for (int variant = 0; variant < 5; ++variant) {
        dc2::debug::HalloweenPreambleInput input{.enabled = true};
        input.Observe(540, context.scene, context.program, 1);
        CGamePad pad{};
        if (variant == 0) {
            pad.pad[0].button = PAD_CIRCLE;
        }
        if (variant == 1) {
            pad.previous_pad[0].button = PAD_CIRCLE;
        }
        if (variant == 2) {
            pad.key_lock = 1;
        }
        if (variant == 3) {
            pad.pad[0].button = PAD_SELECT | PAD_L2;
        }
        if (variant == 4) {
            pad.previous_pad[0].button = PAD_SELECT | PAD_L2;
        }
        const int buttons = pad.pad[0].button;
        EXPECT_FALSE(input.Apply(pad, context));
        EXPECT_EQ(pad.pad[0].button, buttons);
        EXPECT_FALSE(input.consumed);
    }
}

TEST(TestHooks, HalloweenAcknowledgementInvalidatesOtherFailedAndReplacedPrograms) {
    auto                               context = PreambleInputContext();
    dc2::debug::HalloweenPreambleInput input;
    input.Observe(540, context.scene, context.program, 1);
    CGamePad pad{};
    EXPECT_FALSE(input.Apply(pad, context));
    input.enabled = true;
    for (const int event : {530, 540, 21020}) {
        input.Observe(540, context.scene, context.program, 1);
        input.Observe(event, context.scene, context.program, event == 540 ? 0 : 1);
        EXPECT_FALSE(input.Apply(pad, context));
    }
    input.Observe(540, context.scene, context.program, 1);
    int replacement;
    context.program = &replacement;
    EXPECT_FALSE(input.Apply(pad, context));
    input.Observe(-1, nullptr, nullptr, 0);
    context = PreambleInputContext();
    EXPECT_FALSE(input.Apply(pad, context));
    input = dc2::debug::HalloweenPreambleInput{.enabled = true};
    input.Observe(540, context.scene, context.program, 1);
    EXPECT_TRUE(input.Apply(pad, context));
}

TEST(TestHooks, InactiveDungeonStressNeedsNoSceneAndPreservesOrdinaryPreferences) {
    const auto preferences = ConfigSerialize(ConfigGet());
    EXPECT_FALSE(dc2::debug::DungeonStressEnabled());
    EXPECT_FALSE(dc2::debug::DungeonStressCaptureWitnesses());
    EXPECT_EQ(dc2::debug::DungeonStressPriorityLimit(5), 5);
    EXPECT_EQ(dc2::debug::DungeonStressPriorityLimit(60), 60);
    EXPECT_FLOAT_EQ(dc2::debug::DungeonStressProjection(524.0f), 524.0f);
    {
        dc2::debug::DungeonStressBodyScope enemy(dc2::debug::DungeonStressEntityKind::Enemy, 3);
        const auto                         tag = dc2::debug::DungeonStressCurrentBody();
        EXPECT_EQ(tag.generation, 0U);
        EXPECT_FALSE(dc2::debug::DungeonStressBodySubmitted(tag));
        EXPECT_FALSE(dc2::debug::DungeonStressObserveBodyWitness(tag, {0.0f, 0.0f, 0.0f}, 100.0f));
        {
            dc2::debug::DungeonStressBodyScope chest(dc2::debug::DungeonStressEntityKind::Chest, 1);
            EXPECT_EQ(dc2::debug::DungeonStressCurrentBody().generation, 0U);
        }
        EXPECT_EQ(dc2::debug::DungeonStressCurrentBody().generation, 0U);
    }
    EXPECT_EQ(dc2::debug::DungeonStressCurrentBody().generation, 0U);
    EXPECT_FALSE(dc2::debug::DungeonStressPlaceMonsters());
    dc2::debug::DungeonStressAfterTreasures();
    EXPECT_EQ(ConfigSerialize(ConfigGet()), preferences);
}

TEST(TestHooks, BossReadinessRejectsSurvivingMinionsAndRetiredBosses) {
    EXPECT_FALSE(dc2::debug::CombatBossActorReady(-1, 100, true, false));
    EXPECT_FALSE(dc2::debug::CombatBossActorReady(-1, 100, false, true));
    EXPECT_TRUE(dc2::debug::CombatBossActorReady(-1, 100, true, true));
    for (const int expected_monster : {517, 512, 511, 613}) {
        SCOPED_TRACE(expected_monster);
        EXPECT_TRUE(dc2::debug::CombatBossActorReady(expected_monster, expected_monster, true, false));
        EXPECT_TRUE(dc2::debug::CombatBossActorReady(expected_monster, expected_monster, true, true));
        EXPECT_FALSE(dc2::debug::CombatBossActorReady(expected_monster, expected_monster, false, true));
        EXPECT_FALSE(dc2::debug::CombatBossActorReady(expected_monster, expected_monster + 1, true, true));
    }
}

TEST(TestHooks, HalloweenPreambleWaitsForNaturalTutorialAndEveryEventHandoff) {
    using dc2::debug::CombatBossPreambleReady;
    EXPECT_FALSE(CombatBossPreambleReady(21020, 500, 0, -1, true, -1, false));
    EXPECT_FALSE(CombatBossPreambleReady(21020, 500, 1, -1, true, -1, false));
    EXPECT_TRUE(CombatBossPreambleReady(21020, 500, 2, -1, true, -1, false));
    EXPECT_TRUE(CombatBossPreambleReady(21020, 500, 3, -1, true, -1, false));
    EXPECT_FALSE(CombatBossPreambleReady(21020, 1000, 2, -1, true, -1, false));
    EXPECT_FALSE(CombatBossPreambleReady(21020, 500, 2, 540, true, -1, false));
    EXPECT_FALSE(CombatBossPreambleReady(21020, 500, 2, -1, false, -1, false));
    EXPECT_FALSE(CombatBossPreambleReady(21020, 500, 2, -1, true, 540, false));
    EXPECT_FALSE(CombatBossPreambleReady(21020, 500, 2, -1, true, 0, false));
    EXPECT_FALSE(CombatBossPreambleReady(21020, 500, 2, -1, true, -1, true));
}

TEST(TestHooks, OtherBossEventsDoNotAcquireAHalloweenTutorialPrerequisite) {
    for (const int event : {21010, 22030, 23020, 25010, 25020, 25030, 26040, 28020}) {
        SCOPED_TRACE(event);
        EXPECT_TRUE(dc2::debug::CombatBossPreambleReady(event, 1000, 0, 540, false, 540, true));
    }
}

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

TEST(TestHooks, CombatFloorClassificationRequiresCompleteRetailBossRows) {
    const std::array<std::array<int, 3>, 24> combat_events{
        {{21010, 1, 4}, {21020, 1, 7}, {22030, 2, 15}, {23020, 3, 18}, {23030, 3, 23}, {24010, 4, 9}, {24020, 4, 20}, {25010, 5, 16}, {25020, 5, 22}, {25030, 5, 22}, {26010, 2, 12}, {26020, 3, 15}, {26030, 4, 14}, {26040, 5, 8}, {26050, 6, 0}, {27010, 6, 27}, {27020, 6, 27}, {27030, 6, 27}, {27040, 6, 27}, {27050, 6, 27}, {27060, 6, 27}, {27070, 6, 27}, {28010, 7, 27}, {28020, 7, 38}}
    };
    std::ostringstream rows;
    for (const auto &entry : combat_events) {
        rows << '\t' << entry[1] << '\t' << entry[2] << '\t' << entry[0] << "\t\t\t\tcombat\tB\r\n";
    }
    rows << "s03\t\t\t22010\t\t\t\tsubgame\tB\r\n"
            "\t2\t6\t22020\t\t\t\tfishing\tB\r\n"
            "\t\t\t23010\t\t\t\tspheda\tB\r\n";
    const auto table = rows.str();
    for (const auto &entry : combat_events) {
        EXPECT_EQ(dc2::debug::CombatDungeonFloor(table, entry[1] - 1, entry[2]), std::optional{true}) << entry[0];
    }
    const std::array<std::array<int, 2>, 7> noncombat{
        {{0, 1}, {1, 6}, {2, 8}, {2, 24}, {5, 11}, {5, 21}, {6, 5}}
    };
    for (const auto &entry : noncombat) {
        EXPECT_EQ(dc2::debug::CombatDungeonFloor(table, entry[0], entry[1]), std::optional{false});
    }
    EXPECT_FALSE(dc2::debug::CombatDungeonFloor("", 0, 4).has_value());
    EXPECT_FALSE(dc2::debug::CombatDungeonFloor(table.substr(0, table.find('\n') + 1), 0, 4).has_value());
    EXPECT_FALSE(dc2::debug::CombatDungeonFloor(table + table.substr(0, table.find('\n') + 1), 0, 4).has_value());
    auto malformed = table;
    malformed.replace(malformed.find("21010"), 5, "oops!");
    EXPECT_FALSE(dc2::debug::CombatDungeonFloor(malformed, 0, 4).has_value());
    GameJump jump;
    EXPECT_FALSE(GameParseJump("dungeon:5:0", jump));
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

namespace {
/**
 * Creates a finite native test surface with distinguishable collision metadata.
 */
CCPoly StressTestTriangle(float z, unsigned short identity) {
    CCPoly                                    poly{};
    const std::array<std::array<float, 4>, 3> vertices{
        {{-10, -10, z, 1}, {10, -10, z, 1}, {0, 10, z, 1}}
    };
    for (std::size_t index = 0; index < vertices.size(); ++index) {
        std::ranges::copy(vertices[index], poly.vertex[index]);
    }
    poly.normal[2] = 1;
    poly.parts_no = identity;
    return poly;
}

/**
 * Compares native hit identity and coordinates after stable cached broadphase filtering.
 */
void ExpectStressRayParity(std::vector<CCPoly> &polygons, std::array<float, 4> from, std::array<float, 4> to, int nearest = 1, int mask = 0) {
    std::vector<dc2::debug::DungeonStressRayBounds> bounds;
    std::vector<CCPoly>                             candidates;
    dc2::debug::DungeonStressPrepareRayBounds(polygons, bounds);
    dc2::debug::DungeonStressSelectRayCandidates(polygons, bounds, from, to, candidates);
    std::array<float, 4> reference_hit{}, filtered_hit{};
    const int            reference = CheckHit(polygons.data(), static_cast<int>(polygons.size()), from.data(), to.data(), reference_hit.data(), nearest, mask);
    const int            filtered = CheckHit(candidates.data(), static_cast<int>(candidates.size()), from.data(), to.data(), filtered_hit.data(), nearest, mask);
    ASSERT_EQ(reference >= 0, filtered >= 0);
    if (reference >= 0 && filtered >= 0) {
        EXPECT_EQ(polygons[static_cast<std::size_t>(reference)].parts_no, candidates[static_cast<std::size_t>(filtered)].parts_no);
        for (std::size_t axis = 0; axis < 3; ++axis) {
            EXPECT_EQ(std::bit_cast<std::uint32_t>(reference_hit[axis]), std::bit_cast<std::uint32_t>(filtered_hit[axis]));
        }
    }
}
} // namespace

TEST(DungeonStressRayCache, MatchesNativeHitsMissesEndpointsAndTieOrder) {
    std::vector polygons{StressTestTriangle(7, 1), StressTestTriangle(3, 2), StressTestTriangle(3, 3)};
    for (int nearest : {0, 1}) {
        ExpectStressRayParity(polygons, {0, 0, 0, 1}, {0, 0, 10, 1}, nearest);
        ExpectStressRayParity(polygons, {0, 0, 10, 1}, {0, 0, 0, 1}, nearest);
        ExpectStressRayParity(polygons, {-10, -10, 0, 1}, {-10, -10, 3, 1}, nearest);
        ExpectStressRayParity(polygons, {20, 20, 0, 1}, {20, 20, 10, 1}, nearest);
        ExpectStressRayParity(polygons, {0, 0, 3, 1}, {0, 0, 3, 1}, nearest);
    }
    polygons[1].ignore_mask = 1;
    ExpectStressRayParity(polygons, {0, 0, 0, 1}, {0, 0, 10, 1}, 1, 1);
}

TEST(DungeonStressRayCache, MatchesDeterministicNativeSegmentsAndChangedSnapshots) {
    std::vector                           polygons{StressTestTriangle(7, 1), StressTestTriangle(3, 2), StressTestTriangle(5, 3)};
    std::mt19937                          random(1);
    std::uniform_real_distribution<float> coordinate(-20, 20);
    for (int index = 0; index < 256; ++index) {
        ExpectStressRayParity(polygons, {coordinate(random), coordinate(random), -5, 1}, {coordinate(random), coordinate(random), 15, 1});
    }
    for (auto &vertex : polygons[0].vertex) {
        vertex[0] += 50;
    }
    ExpectStressRayParity(polygons, {50, 0, 0, 1}, {50, 0, 10, 1});
    polygons.clear();
    ExpectStressRayParity(polygons, {0, 0, 0, 1}, {0, 0, 10, 1});
}

TEST(DungeonStressRayCache, KeepsNonfiniteInputsAndInvalidCachesConservative) {
    std::vector polygons{StressTestTriangle(3, 1), StressTestTriangle(5, 2)};
    polygons[1].vertex[0][0] = std::numeric_limits<float>::quiet_NaN();
    std::vector<dc2::debug::DungeonStressRayBounds> bounds;
    std::vector<CCPoly>                             candidates;
    dc2::debug::DungeonStressPrepareRayBounds(polygons, bounds);
    dc2::debug::DungeonStressSelectRayCandidates(polygons, bounds, {100, 100, 0, 1}, {100, 100, 10, 1}, candidates);
    ASSERT_EQ(candidates.size(), 1);
    EXPECT_EQ(candidates[0].parts_no, 2);
    dc2::debug::DungeonStressSelectRayCandidates(polygons, bounds, {0, 0, 0, 1}, {std::numeric_limits<float>::infinity(), 0, 10, 1}, candidates);
    EXPECT_EQ(candidates.size(), polygons.size());
    bounds.clear();
    dc2::debug::DungeonStressSelectRayCandidates(polygons, bounds, {100, 100, 0, 1}, {100, 100, 10, 1}, candidates);
    EXPECT_EQ(candidates.size(), polygons.size());
}
