#include <gtest/gtest.h>

#include <cmath>
#include <memory>

#include "mainloop.hpp"
#include "mainloop_port.hpp"
#include "mglib.hpp"
#include "platform/clock.hpp"
#include "play_time.hpp"
#include "savedata.hpp"

int VSyncCallBack(int field);

namespace {
class PlayClock : public testing::Test {
protected:
    std::unique_ptr<CSaveData> save = std::make_unique<CSaveData>();
    CSaveData                 *previous = PortActiveSaveData;
    int                        previous_enabled = PortPlayTimeCountFlag;
    double                     previous_rate = ClockTickRate();
    bool                       previous_unbounded = ClockUnbounded();
    ClockTickCallback          previous_callback = ClockGetTickCallback();

    void SetUp() override {
        PortActiveSaveData = save.get();
        PortPlayTimeCountFlag = true;
        ClockSetUnbounded(true);
        ClockReset();
        ClockSetTickCallback(VSyncCallBack);
        mgInitVSyncCallBack(PortPlayTimeVSyncCallback);
        PlayTimeReset();
        save->play_time = 0;
    }

    void TearDown() override {
        mgInitVSyncCallBack(nullptr);
        ClockSetTickCallback(previous_callback);
        ClockSetTickRate(previous_rate);
        ClockSetUnbounded(previous_unbounded);
        PortPlayTimeCountFlag = previous_enabled;
        PortActiveSaveData = previous;
        PlayTimeReset();
    }

    void Ticks(int count) {
        while (count-- > 0) {
            ClockPump();
        }
    }
};
} // namespace

TEST_F(PlayClock, FiftyAndSixtyCountOneMinuteInSavedUnits) {
    ClockSetTickRate(50);
    Ticks(3000);
    EXPECT_EQ(save->play_time, 3000);
    save->play_time = 0;
    PlayTimeReset();
    ClockSetTickRate(60);
    Ticks(3600);
    EXPECT_EQ(save->play_time, 3000);
    EXPECT_EQ(ClockGetTickCallback(), VSyncCallBack);
}

TEST_F(PlayClock, SixSixtyTicksAddFiveSavedUnits) {
    ClockSetTickRate(60);
    for (int tick = 1; tick <= 6; ++tick) {
        Ticks(1);
        EXPECT_EQ(save->play_time, tick * 5 / 6);
    }
}

TEST_F(PlayClock, PauseKeepsFractionAndVsyncContinues) {
    ClockSetTickRate(60);
    Ticks(1);
    EXPECT_EQ(save->play_time, 0);
    PlayTimeCount(false);
    Ticks(100);
    EXPECT_EQ(save->play_time, 0);
    EXPECT_EQ(ClockTickCount(), 101);
    PlayTimeCount(true);
    Ticks(5);
    EXPECT_EQ(save->play_time, 5);
}

TEST_F(PlayClock, LiveRateChangesKeepFraction) {
    ClockSetTickRate(60);
    Ticks(1);
    ClockSetTickRate(50);
    Ticks(10);
    EXPECT_EQ(save->play_time, 10);
    ClockSetTickRate(60);
    Ticks(5);
    EXPECT_EQ(save->play_time, 15);
}

TEST_F(PlayClock, CustomRatesStayWithinOneSavedUnit) {
    for (double rate : {25.0, 75.0, 144.0, 59.94, 240.0}) {
        SCOPED_TRACE(rate);
        save->play_time = 0;
        PlayTimeReset();
        ClockSetTickRate(rate);
        Ticks(6000);
        const long double budget = 6000.0L * 50.0L / rate;
        EXPECT_LE(static_cast<long double>(save->play_time), budget);
        EXPECT_LT(budget - save->play_time, 1.0L);
    }
}

TEST_F(PlayClock, NewGameDiscardsFractionalCredit) {
    ClockSetTickRate(60);
    Ticks(1);
    InitSaveData();
    EXPECT_EQ(save->play_time, 0);
    Ticks(1);
    EXPECT_EQ(save->play_time, 0);
    Ticks(5);
    EXPECT_EQ(save->play_time, 5);
}

TEST_F(PlayClock, SubgameDataDoesNotOwnTheSavedPlayClock) {
    auto  subgame = std::make_unique<CSubGameData>();
    auto *previous_subgame = PortSubGameSaveData;
    PortSubGameSaveData = subgame.get();
    subgame->play_enable = 123;
    ClockSetTickRate(60);
    Ticks(6);
    EXPECT_EQ(GetSaveData(), save.get());
    EXPECT_EQ(save->play_time, 5);
    EXPECT_EQ(subgame->play_enable, 123u);
    PortSubGameSaveData = previous_subgame;
}
