#include "common.h"

#include <eekernel.h>
#include <gtest/gtest.h>
#include <libgraph.h>

#include <chrono>
#include <cstdlib>
#include <thread>

#include "mglib.hpp"
#include "platform/clock.hpp"
#include "sce/threads.hpp"
#include "stubs/mglib.hpp"

int VSyncCallBack(int field);
void WaitVSync(int start, int frames);

namespace {

int g_callbacks = 0;
int g_thread_runs = 0;

int CountCallBack(int) {
    ++g_callbacks;
    return 0;
}

void CountingLoop(void *) {
    for (;;) {
        ++g_thread_runs;
        RotateThreadReadyQueue(10);
    }
}

void VSyncSpinLoop(void *) {
    for (;;) {
        ++g_thread_runs;
        WaitVSync(mgGetVSyncCount(), 1);
        RotateThreadReadyQueue(10);
    }
}

void UnboundedVSyncClock() {
    ClockSetUnbounded(true);
    ClockReset();
    ClockSetTickCallback(VSyncCallBack);
}

} // namespace

TEST(MglibTime, WaitVSyncAdvancesCountAndCallsCallBackPerTick) {
    UnboundedVSyncClock();
    mgInitVSyncCallBack(CountCallBack);
    g_callbacks = 0;

    WaitVSync(0, 2);

    EXPECT_EQ(mgGetVSyncCount(), 2);
    EXPECT_EQ(g_callbacks, 2);
}

TEST(MglibTime, SyncVSpinAdvancesCount) {
    UnboundedVSyncClock();

    while (ClockTickCount() < 5) {
        sceGsSyncV(0);
    }

    EXPECT_EQ(ClockTickCount(), 5);
}

TEST(MglibTime, RotatingThreadRunsOncePerWaitVSyncIteration) {
    KzThreadsSetMainPriority(10);
    UnboundedVSyncClock();
    g_thread_runs = 0;

    ThreadParam param{};
    param.entry = CountingLoop;
    param.initPriority = 10;
    const int id = CreateThread(&param);
    ASSERT_EQ(StartThread(id, nullptr), id);

    mgSetRotateThread(10);
    WaitVSync(0, 3);
    mgSetRotateThread(-1);

    EXPECT_EQ(g_thread_runs, 3);
    EXPECT_EQ(TerminateThread(id), 0);
    EXPECT_EQ(DeleteThread(id), 0);
}

// Bounded so that a regression which stops the thread from running fails instead of hanging the case.
TEST(MglibTime, ThreadSpinningInWaitVSyncPumpsTheClock) {
    KzThreadsSetMainPriority(10);
    UnboundedVSyncClock();
    g_thread_runs = 0;

    ThreadParam param{};
    param.entry = VSyncSpinLoop;
    param.initPriority = 10;
    const int id = CreateThread(&param);
    ASSERT_EQ(StartThread(id, nullptr), id);

    for (int i = 0; i < 100 && g_thread_runs < 5; ++i) {
        RotateThreadReadyQueue(10);
    }

    EXPECT_GE(g_thread_runs, 5);
    EXPECT_GE(mgGetVSyncCount(), 4);
    EXPECT_EQ(TerminateThread(id), 0);
    EXPECT_EQ(DeleteThread(id), 0);
}

TEST(MglibTime, FrameFieldsMeasuresWallClockInFields) {
    ClockSetUnbounded(false);
    ClockSetTickRate(100.0);

    // CI runners oversleep by more than these bounds allow.
    if (std::getenv("CI") != nullptr) {
        GTEST_SKIP() << "timing is not checked on CI";
    }

    mgTimeFrameBegin();
    std::this_thread::sleep_for(std::chrono::milliseconds(50));

    EXPECT_GE(mgTimeFrameFields(), 4.5f);
    EXPECT_LT(mgTimeFrameFields(), 15.0f);
}

TEST(MglibTime, FrameFieldsIsNonNegativeRightAfterBegin) {
    ClockSetUnbounded(false);
    ClockSetTickRate(100.0);

    mgTimeFrameBegin();

    EXPECT_GE(mgTimeFrameFields(), 0.0f);
    EXPECT_LT(mgTimeFrameFields(), 1.0f);
}

TEST(MglibTime, UnboundedFrameFieldsCountLogicTicksAtEveryRate) {
    for (double rate : {50.0, 60.0, 59.94, 240.0}) {
        SCOPED_TRACE(rate);
        ClockSetTickRate(rate);
        UnboundedVSyncClock();
        mgInitVSyncCallBack(nullptr);
        mgTimeFrameBegin();
        EXPECT_FLOAT_EQ(mgTimeFrameFields(), 0.0f);
        ClockPump();
        EXPECT_FLOAT_EQ(mgTimeFrameFields(), 1.0f);
        ClockPump();
        EXPECT_FLOAT_EQ(mgTimeFrameFields(), 2.0f);
        mgTimeFrameBegin();
        EXPECT_FLOAT_EQ(mgTimeFrameFields(), 0.0f);
        for (int tick = 0; tick < 7; ++tick) {
            ClockPump();
        }
        EXPECT_FLOAT_EQ(mgTimeFrameFields(), 7.0f);
    }
}

TEST(MglibTime, UnboundedFrameFieldsIgnoreHostDelay) {
    ClockSetTickRate(60);
    UnboundedVSyncClock();
    mgInitVSyncCallBack(nullptr);
    mgTimeFrameBegin();
    std::this_thread::sleep_for(std::chrono::milliseconds(25));
    EXPECT_FLOAT_EQ(mgTimeFrameFields(), 0.0f);
    ClockPump();
    std::this_thread::sleep_for(std::chrono::milliseconds(25));
    EXPECT_FLOAT_EQ(mgTimeFrameFields(), 1.0f);
}

TEST(MglibTime, UnboundedFrameFieldsReanchorWhenClockResets) {
    UnboundedVSyncClock();
    mgInitVSyncCallBack(nullptr);
    for (int tick = 0; tick < 5; ++tick) {
        ClockPump();
    }
    mgTimeFrameBegin();
    ClockPump();
    EXPECT_FLOAT_EQ(mgTimeFrameFields(), 1.0f);
    ClockReset();
    EXPECT_FLOAT_EQ(mgTimeFrameFields(), 0.0f);
    ClockPump();
    EXPECT_FLOAT_EQ(mgTimeFrameFields(), 1.0f);
}
