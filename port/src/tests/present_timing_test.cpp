#include <gtest/gtest.h>

#include "present_timing.hpp"

namespace {
using Clock = PresentPacer::Clock;
using Action = PresentPacer::Action;
using namespace std::chrono_literals;
const auto origin = Clock::time_point{} + 1s;
} // namespace

TEST(PresentTiming, RenderTimeIsPartOfTheCapPeriod) {
    for (double rate : {60.0, 120.0, 240.0}) {
        PresentPacer pacer;
        auto         now = origin;
        const auto   period = std::chrono::duration_cast<Clock::duration>(std::chrono::duration<double>(1 / rate));
        ASSERT_TRUE(pacer.Present([&] { now += 2ms; return true; }, [&] { return now; }));
        const auto decision = pacer.Next(now, origin + 40ms, rate);
        EXPECT_EQ(decision.action, Action::Wait);
        EXPECT_EQ(decision.deadline, origin + period);
        EXPECT_EQ(pacer.Next(origin + period, origin + 40ms, rate).action, Action::Display);
    }
}

TEST(PresentTiming, SlowRenderAndStallSkipExpiredSlotsWithoutCatchUpBursts) {
    PresentPacer pacer;
    auto         now = origin;
    ASSERT_TRUE(pacer.Present([&] { now += 13ms; return true; }, [&] { return now; }));
    EXPECT_EQ(pacer.Next(now, origin + 40ms, 240).action, Action::Display);
    now += 200ms;
    const auto restarted = now;
    ASSERT_TRUE(pacer.Present([&] { now += 1ms; return true; }, [&] { return now; }));
    auto decision = pacer.Next(now, now + 40ms, 240);
    EXPECT_EQ(decision.action, Action::Wait);
    const auto period = std::chrono::duration_cast<Clock::duration>(std::chrono::duration<double>(1.0 / 240));
    EXPECT_EQ(decision.deadline, restarted + period);
}

TEST(PresentTiming, LateWakeupsKeepTheirSlot) {
    PresentPacer pacer;
    const auto   period = std::chrono::duration_cast<Clock::duration>(std::chrono::duration<double>(1.0 / 60));
    ASSERT_TRUE(pacer.Present([] { return true; }, [] { return origin; }));
    // Each display starts a little after its slot; the slots stay one period apart.
    for (int slot = 1; slot <= 120; slot++) {
        const auto due = origin + slot * period;
        EXPECT_EQ(pacer.Next(due - 1ms, origin + 10s, 60).deadline, due);
        ASSERT_EQ(pacer.Next(due + 1ms, origin + 10s, 60).action, Action::Display);
        ASSERT_TRUE(pacer.Present([] { return true; }, [&] { return due + 1ms; }));
    }
}

TEST(PresentTiming, DueGameFieldWinsEvenWithoutADisplay) {
    PresentPacer pacer;
    auto         now = origin;
    ASSERT_TRUE(pacer.Present([] { return true; }, [&] { return now; }));
    EXPECT_EQ(pacer.Next(now, now + 2ms, 240).action, Action::Tick);
    EXPECT_EQ(pacer.Next(now + 20ms, now + 20ms, 0).action, Action::Tick);
    EXPECT_EQ(pacer.Next(now + 21ms, now + 20ms, 240).action, Action::Tick);
    EXPECT_EQ(pacer.Next(now + 20ms, now + 40ms, 0).action, Action::Display);
}

TEST(PresentTiming, UnlimitedAndFailedPresentDoNotAccumulateWaits) {
    PresentPacer pacer;
    auto         now = origin;
    ASSERT_TRUE(pacer.Present([&] { now += 2ms; return true; }, [&] { return now; }));
    EXPECT_EQ(pacer.Next(now, origin + 20ms, 0).action, Action::Display);
    now = origin + 10ms;
    EXPECT_FALSE(pacer.Present([] { return false; }, [&] { return now; }));
    EXPECT_EQ(pacer.Next(now, origin + 20ms, 240).action, Action::Display);
}

TEST(PresentTiming, AlphaSpansTheWholeOneOrTwoFieldGameFrame) {
    EXPECT_FLOAT_EQ(PresentFrameAlpha(0, .5, 1), .5f);
    EXPECT_FLOAT_EQ(PresentFrameAlpha(0, .5, 2), .25f);
    EXPECT_FLOAT_EQ(PresentFrameAlpha(1, .5, 2), .75f);
    EXPECT_FLOAT_EQ(PresentFrameAlpha(0, 0, 2), 0);
    EXPECT_LE(PresentFrameAlpha(3, .5, 2), 1);
}

TEST(PresentTiming, TinyCapsAreOneFpsAndZeroIsUnlimited) {
    PresentPacer pacer;
    ASSERT_TRUE(pacer.Present([] { return true; }, [] { return origin; }));
    for (double rate : {1e-12, 1e-300, 0.5, 1.0}) {
        auto decision = pacer.Next(origin + 1ms, origin + 2s, rate);
        EXPECT_EQ(decision.action, Action::Wait);
        EXPECT_EQ(decision.deadline, origin + 1s);
    }
    EXPECT_EQ(pacer.Next(origin + 1ms, origin + 2s, 0).action, Action::Display);
    const auto end = Clock::time_point::max() - 2ms;
    ASSERT_TRUE(pacer.Present([] { return true; }, [&] { return end; }));
    EXPECT_EQ(pacer.Next(end + 1ms, Clock::time_point::max(), 1e-12).action, Action::Tick);
}

TEST(PresentTiming, EndpointPairShowsOneIntermediateThenAuthoredEndpoint) {
    PresentPacer                    pacer;
    dc2::presentation::EndpointPair pair;
    using PairAction = dc2::presentation::EndpointPair::Action;
    pair.Begin();
    auto       now = origin + 10ms;
    const auto end = origin + 33334us;
    ASSERT_EQ(pair.Next(now, end, 60, pacer).action, PairAction::Intermediate);
    ASSERT_TRUE(pacer.Present([&] { now += 5ms; return true; }, [&] { return now; }));
    pair.Presented(PairAction::Intermediate);
    EXPECT_EQ(pair.Next(now, end, 60, pacer).action, PairAction::Wait);
    EXPECT_EQ(pair.Next(now, end, 60, pacer).deadline, end);
    now = end;
    ASSERT_EQ(pair.Next(now, end, 60, pacer).action, PairAction::Endpoint);
    ASSERT_TRUE(pacer.Present([] { return true; }, [&] { return now; }));
    pair.Presented(PairAction::Endpoint);
    EXPECT_EQ(pair.Next(now + 1s, end, 60, pacer).action, PairAction::Done);
}

TEST(PresentTiming, LatePublicationDropsIntermediateWithoutCatchup) {
    PresentPacer                    pacer;
    dc2::presentation::EndpointPair pair;
    using PairAction = dc2::presentation::EndpointPair::Action;
    pair.Begin();
    const auto end = origin + 33334us;
    const auto now = end + 12ms;
    EXPECT_EQ(pair.Next(now, end, 60, pacer).action, PairAction::Endpoint);
    pair.Presented(PairAction::Endpoint);
    EXPECT_EQ(pair.Next(now, end, 60, pacer).action, PairAction::Done);
    EXPECT_LT(PresentFrameAlpha(1.7, 0, 2), 1.0f);
    EXPECT_NEAR(PresentFrameAlpha(1.7, 0, 2), .85f, 1e-6f);
}

TEST(PresentTiming, EndpointHonorsCapAfterTheSimulationDeadline) {
    PresentPacer                    pacer;
    dc2::presentation::EndpointPair pair;
    using PairAction = dc2::presentation::EndpointPair::Action;
    pair.Begin();
    auto       now = origin + 28ms;
    const auto end = origin + 33334us;
    ASSERT_TRUE(pacer.Present([] { return true; }, [&] { return now; }));
    pair.Presented(PairAction::Intermediate);
    now = end;
    const auto waiting = pair.Next(now, end, 60, pacer);
    ASSERT_EQ(waiting.action, PairAction::Wait);
    EXPECT_GT(waiting.deadline, end);
    EXPECT_EQ(pair.Next(waiting.deadline, end, 60, pacer).action, PairAction::Endpoint);
}

TEST(PresentTiming, FailedPairPresentDoesNotConsumePhaseOrCap) {
    PresentPacer                    pacer;
    dc2::presentation::EndpointPair pair;
    using PairAction = dc2::presentation::EndpointPair::Action;
    pair.Begin();
    auto       now = origin + 10ms;
    const auto end = origin + 33334us;
    ASSERT_EQ(pair.Next(now, end, 60, pacer).action, PairAction::Intermediate);
    EXPECT_FALSE(pacer.Present([] { return false; }, [&] { return now; }));
    EXPECT_EQ(pair.Next(now + 1ms, end, 60, pacer).action, PairAction::Intermediate);
    now = end;
    EXPECT_EQ(pair.Next(now, end, 60, pacer).action, PairAction::Endpoint);
    EXPECT_FALSE(pacer.Present([] { return false; }, [&] { return now; }));
    EXPECT_EQ(pair.Next(now + 1ms, end, 60, pacer).action, PairAction::Endpoint);
}

TEST(PresentTiming, NewCanonicalRetiresOnlyDueEndpointsAndNeverBlocksForOldImages) {
    PresentPacer                    pacer;
    dc2::presentation::EndpointPair pair;
    using PairAction = dc2::presentation::EndpointPair::Action;
    pair.Begin();
    auto now = origin + 10ms;
    ASSERT_TRUE(pacer.Present([] { return true; }, [&] { return now; }));
    pair.Presented(PairAction::Intermediate);
    EXPECT_EQ(pair.Next(origin + 38ms, origin + 33334us, 60, pacer).action, PairAction::Endpoint);
    pair.Cancel();
    EXPECT_EQ(pair.Next(origin + 38ms, origin + 33334us, 60, pacer).action, PairAction::Done);
    pair.Begin();
    const auto not_due = pair.Next(origin + 40ms, origin + 66ms, 60, pacer);
    EXPECT_EQ(not_due.action, PairAction::Intermediate);
    pair.Cancel();
    EXPECT_EQ(pair.Next(origin + 80ms, origin + 66ms, 60, pacer).action, PairAction::Done);
    pair.Begin();
    EXPECT_EQ(pair.Next(origin + 90ms, origin + 100ms, 60, pacer).action, PairAction::Intermediate);
}
