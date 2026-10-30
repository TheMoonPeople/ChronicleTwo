#include <eekernel.h>
#include <gtest/gtest.h>

#include <string>

#include "platform/clock.hpp"
#include "sce/threads.hpp"

namespace {

std::string g_log;
int         g_pump_hook_runs = 0;

constexpr int kPriority = 10;

ThreadParam Param(void (*entry)(void *), int priority) {
    ThreadParam param{};
    param.entry = entry;
    param.initPriority = priority;
    return param;
}

void LoopA(void * /*unused*/) {
    for (;;) {
        g_log += 'A';
        RotateThreadReadyQueue(kPriority);
    }
}

void LoopB(void * /*unused*/) {
    for (;;) {
        g_log += 'B';
        RotateThreadReadyQueue(kPriority);
    }
}

void HighPriorityOnce(void * /*unused*/) {
    g_log += 'H';
}

void OnceAfterWait(void *sema) {
    g_log += 'w';
    WaitSema(*static_cast<int *>(sema));
    g_log += 'W';
}

void AppendTOnce(void * /*unused*/) {
    g_log += 'T';
}

void RotateForever(void * /*unused*/) {
    for (;;) {
        RotateThreadReadyQueue(kPriority);
    }
}

void RotateInPumpHook() {
    ++g_pump_hook_runs;
    RotateThreadReadyQueue(kPriority);
}

int RotateOnTickCallback(int /*unused*/) {
    RotateThreadReadyQueue(kPriority);
    return 0;
}

void PumpWithSwitchingPumpHook() {
    KzThreadsSetMainPriority(kPriority);
    ClockSetUnbounded(true);
    ClockReset();

    ThreadParam param = Param(RotateForever, kPriority);
    const int   id = CreateThread(&param);
    StartThread(id, nullptr);

    ClockAddPumpHook(RotateInPumpHook);
    ClockPump();
}

void PumpWithSwitchingTickCallback() {
    KzThreadsSetMainPriority(kPriority);
    ClockSetUnbounded(true);
    ClockReset();

    ThreadParam param = Param(RotateForever, kPriority);
    const int   id = CreateThread(&param);
    StartThread(id, nullptr);

    ClockSetTickCallback(RotateOnTickCallback);
    ClockPump();
}

} // namespace

TEST(EeKernelThreads, EqualPriorityThreadsRotateWithMainInOrder) {
    KzThreadsSetMainPriority(kPriority);
    g_log.clear();

    ThreadParam pa = Param(LoopA, kPriority);
    ThreadParam pb = Param(LoopB, kPriority);
    const int   a = CreateThread(&pa);
    const int   b = CreateThread(&pb);
    ASSERT_EQ(StartThread(a, nullptr), a);
    ASSERT_EQ(StartThread(b, nullptr), b);

    for (int i = 0; i < 3; ++i) {
        g_log += 'M';
        RotateThreadReadyQueue(kPriority);
    }
    EXPECT_EQ(g_log, "MABMABMAB");

    EXPECT_EQ(TerminateThread(a), 0);
    EXPECT_EQ(TerminateThread(b), 0);
    EXPECT_EQ(DeleteThread(a), 0);
    EXPECT_EQ(DeleteThread(b), 0);
}

TEST(EeKernelThreads, HigherPriorityThreadRunsImmediatelyAndReturnsDormant) {
    KzThreadsSetMainPriority(kPriority);
    g_log.clear();

    ThreadParam param = Param(HighPriorityOnce, kPriority - 5);
    const int   h = CreateThread(&param);
    ASSERT_EQ(StartThread(h, nullptr), h);
    g_log += '.';

    EXPECT_EQ(g_log, "H.");
    EXPECT_EQ(DeleteThread(h), 0);
}

TEST(EeKernelThreads, TerminatedThreadDeletedThenRecreatedRuns) {
    KzThreadsSetMainPriority(kPriority);
    g_log.clear();

    ThreadParam first = Param(LoopA, kPriority);
    const int   t1 = CreateThread(&first);
    ASSERT_EQ(StartThread(t1, nullptr), t1);
    ASSERT_EQ(TerminateThread(t1), 0);
    ASSERT_EQ(DeleteThread(t1), 0);
    EXPECT_EQ(TerminateThread(t1), -1);

    ThreadParam second = Param(HighPriorityOnce, kPriority);
    const int   t2 = CreateThread(&second);
    ASSERT_NE(t2, t1);
    ASSERT_EQ(StartThread(t2, nullptr), t2);
    RotateThreadReadyQueue(kPriority);

    EXPECT_EQ(g_log, "H");
    EXPECT_EQ(DeleteThread(t2), 0);
}

TEST(EeKernelThreads, WaitSemaBlocksUntilAnotherThreadSignals) {
    KzThreadsSetMainPriority(kPriority);
    g_log.clear();

    SemaParam sp{};
    sp.maxCount = 1;
    sp.initCount = 0;
    const int sema = CreateSema(&sp);
    ASSERT_GT(sema, 0);

    int         sema_id = sema;
    ThreadParam wp = Param(OnceAfterWait, kPriority);
    const int   waiter = CreateThread(&wp);
    ASSERT_EQ(StartThread(waiter, &sema_id), waiter);

    g_log += 'm';
    RotateThreadReadyQueue(kPriority);
    g_log += 'M';
    EXPECT_EQ(SignalSema(sema), sema);
    g_log += 'S';
    RotateThreadReadyQueue(kPriority);
    g_log += 'x';

    EXPECT_EQ(g_log, "mwMSWx");
    EXPECT_EQ(DeleteThread(waiter), 0);
    EXPECT_EQ(DeleteSema(sema), 0);
}

TEST(EeKernelThreads, SwitchFromPumpHookAborts) {
    EXPECT_DEATH(PumpWithSwitchingPumpHook(), "thread switch inside ClockPump");
}

TEST(EeKernelThreads, SwitchFromTickCallbackAborts) {
    EXPECT_DEATH(PumpWithSwitchingTickCallback(), "thread switch inside ClockPump");
}

TEST(EeKernelThreads, RotateInsidePumpWithNothingReadyDoesNotSwitch) {
    KzThreadsSetMainPriority(kPriority);
    ClockSetUnbounded(true);
    ClockReset();
    g_pump_hook_runs = 0;

    ClockAddPumpHook(RotateInPumpHook);
    ClockPump();
    ClockRemovePumpHook(RotateInPumpHook);

    EXPECT_EQ(g_pump_hook_runs, 1);
}

// The sound manager guards main-only sections with a binary semaphore. An uncontended pair must never yield,
// or a ready thread would run in the middle of the update.
TEST(EeKernelThreads, BinarySemaphoreAroundMainOnlyNeverSwitches) {
    KzThreadsSetMainPriority(kPriority);
    g_log.clear();

    SemaParam sp{};
    sp.maxCount = 1;
    sp.initCount = 1;
    const int sema = CreateSema(&sp);
    ASSERT_GT(sema, 0);

    ThreadParam param = Param(AppendTOnce, kPriority);
    const int   t = CreateThread(&param);
    ASSERT_EQ(StartThread(t, nullptr), t);

    int mismatches = 0;
    for (int i = 0; i < 100; ++i) {
        if (WaitSema(sema) != sema) {
            ++mismatches;
        }
        if (SignalSema(sema) != sema) {
            ++mismatches;
        }
    }
    EXPECT_EQ(mismatches, 0);
    EXPECT_EQ(g_log.find('T'), std::string::npos);

    RotateThreadReadyQueue(kPriority);
    EXPECT_EQ(g_log, "T");
    EXPECT_EQ(DeleteThread(t), 0);
    EXPECT_EQ(DeleteSema(sema), 0);
}

TEST(EeKernelThreads, SemaphoreCountStopsAtMaxCount) {
    KzThreadsSetMainPriority(kPriority);

    SemaParam sp{};
    sp.maxCount = 2;
    sp.initCount = 0;
    const int sema = CreateSema(&sp);
    ASSERT_GT(sema, 0);

    EXPECT_EQ(SignalSema(sema), sema);
    EXPECT_EQ(SignalSema(sema), sema);
    EXPECT_EQ(SignalSema(sema), -1);

    EXPECT_EQ(WaitSema(sema), sema);
    EXPECT_EQ(WaitSema(sema), sema);
    EXPECT_DEATH(WaitSema(sema), "eekernel: deadlock: thread 1 waits on semaphore .* with no ready thread");
}
