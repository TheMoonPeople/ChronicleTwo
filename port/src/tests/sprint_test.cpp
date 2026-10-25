#include <gtest/gtest.h>

#include "actionchara.hpp"
#include "dng_main.hpp"
#include "dungeon_sprint.hpp"
#include "gamepad.hpp"
#include "mglib.hpp"
#include "sprint.hpp"

TEST(SprintTimer, HoldSprintsAQuickReleaseTapsAndAStalePressIsDropped) {
    SprintTimer timer;
    bool        tap = false;
    EXPECT_TRUE(timer.Step(true, true, true, false, 2, tap));
    EXPECT_FALSE(tap);
    EXPECT_FALSE(timer.Step(true, false, false, true, 2, tap));
    EXPECT_TRUE(tap);
    timer.Step(true, true, true, false, 2, tap);
    for (int held = 0; held < 8; ++held) {
        EXPECT_TRUE(timer.Step(true, false, true, false, 2, tap));
    }
    EXPECT_FALSE(timer.Step(true, false, false, true, 2, tap));
    EXPECT_FALSE(tap);
    // Released while the caller was not stepping it: no release edge on the next step.
    timer.Step(true, true, true, false, 2, tap);
    EXPECT_FALSE(timer.Step(true, false, false, false, 2, tap));
    EXPECT_FALSE(tap);
    timer.Step(true, true, true, false, 2, tap);
    EXPECT_FALSE(timer.Step(false, false, true, false, 2, tap));
    EXPECT_FALSE(timer.Step(true, false, false, true, 2, tap));
    EXPECT_FALSE(tap);
}

namespace {
int retail_presses = 0;
int CountRetailPress() {
    retail_presses += GamePad__2.Down(PAD_R2) != 0;
    return 7;
}

struct RestoreDungeonSprint {
    DNG_STATUS    status = DngStatus;
    CActionChara *main = MainChara__2;
    CGamePad      pad = GamePad__2;
    int           rate = mgFrameRate;
    ~RestoreDungeonSprint() {
        DngStatus = status;
        MainChara__2 = main;
        GamePad__2 = pad;
        mgFrameRate = rate;
    }
};
} // namespace

TEST(DungeonSprint, R2HoldSprintsOnFootAndOnlyATapReachesRetailFirstPerson) {
    RestoreDungeonSprint restore;
    CActionChara         chara;
    chara.next = nullptr;
    chara.lock_on = 0;
    MainChara__2 = &chara;
    DngStatus.mode = DNG_STATUS_FIELD;
    DngStatus.eye_view = 0;
    GamePad__2.key_lock = 0;
    mgFrameRate = 2;
    bool last = false;
    auto key = [&](bool held) {
        GamePad__2.previous_pad[0].button = last ? PAD_R2 : 0;
        GamePad__2.pad[0].button = held ? PAD_R2 : 0;
        last = held;
        EXPECT_EQ(DungeonSprintMainKey(CountRetailPress), 7);
        EXPECT_EQ(GamePad__2.pad[0].button, held ? PAD_R2 : 0);
    };
    auto move = [&](float step) {
        chara.velocity[0] = 1;
        chara.velocity[2] = 2;
        chara.SetStep(step);
        DungeonSprintMove(&chara);
    };
    retail_presses = 0;
    // A tap reaches retail as one press, on release.
    key(true);
    EXPECT_EQ(retail_presses, 0);
    key(false);
    EXPECT_EQ(retail_presses, 1);
    // A hold sprints and never reaches retail.
    key(true);
    move(0.5f);
    EXPECT_FLOAT_EQ(chara.velocity[0], kSprintSpeed);
    EXPECT_FLOAT_EQ(chara.velocity[2], 2 * kSprintSpeed);
    EXPECT_FLOAT_EQ(chara.GetStep(), 0.5f * kSprintStep);
    // Retail leaves the run's step alone between frames: the scaled step is not scaled again.
    for (int held = 0; held < 10; ++held) {
        key(true);
        chara.velocity[0] = 1;
        chara.velocity[2] = 2;
        DungeonSprintMove(&chara);
        EXPECT_FLOAT_EQ(chara.GetStep(), 0.5f * kSprintStep);
    }
    // Locked on, the retail strafe keeps its speed.
    chara.lock_on = 1;
    move(0.3f);
    EXPECT_FLOAT_EQ(chara.velocity[0], 1);
    EXPECT_FLOAT_EQ(chara.GetStep(), 0.3f);
    chara.lock_on = 0;
    key(false);
    EXPECT_EQ(retail_presses, 1);
    // Released, a run left at the sprint step returns to its own.
    move(0.5f);
    key(true);
    move(0.5f);
    key(false);
    chara.velocity[0] = 1;
    chara.velocity[2] = 2;
    DungeonSprintMove(&chara);
    EXPECT_FLOAT_EQ(chara.velocity[0], 1);
    EXPECT_FLOAT_EQ(chara.GetStep(), 0.5f);
    retail_presses = 0;
    // In the first-person view R2 belongs to retail, which leaves the view on its press.
    DngStatus.eye_view = 1;
    key(true);
    EXPECT_EQ(retail_presses, 1);
    key(false);
}
