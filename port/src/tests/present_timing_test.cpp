#include <gtest/gtest.h>

#include <array>
#include <limits>
#include <utility>

#include "platform_fixture.hpp"
#include "present.hpp"
#include "present_timing.hpp"

namespace {
using Clock = PresentPacer::Clock;
using Action = PresentPacer::Action;
using namespace std::chrono_literals;
const auto origin = Clock::time_point{} + 1s;
} // namespace

/**
 * Restores presentation settings and explicit environment controls after each configuration case.
 */
class PresentationSettings : public testing::Test {
protected:
    PresentSettings       previous = PresentGetSettings();                                    /**< Presentation state restored after each case. */
    dc::test::EnvSnapshot preflight = dc::test::SaveEnv("DC2_PERF_ENDPOINT_PREFLIGHT");       /**< Original endpoint override. */
    dc::test::EnvSnapshot deferred = dc::test::SaveEnv("DC2_PERF_DEFERRED_CANONICAL_COMMIT"); /**< Original canonical override. */

    /**
     * Removes ambient overrides before applying each instance's requested defaults.
     */
    void SetUp() override {
        ASSERT_EQ(dc::test::UnsetEnv("DC2_PERF_ENDPOINT_PREFLIGHT"), 0);
        ASSERT_EQ(dc::test::UnsetEnv("DC2_PERF_DEFERRED_CANONICAL_COMMIT"), 0);
    }

    /**
     * Restores caller controls and their presentation state.
     */
    void TearDown() override {
        dc::test::RestoreEnv(preflight);
        dc::test::RestoreEnv(deferred);
        PresentSetSettings(previous);
    }
};

TEST_F(PresentationSettings, SwitchDefaultsPreserveLowerCapsAndOrdinarySettings) {
    PresentSetSettings({});
    EXPECT_FALSE(PresentGetSettings().endpoint_preflight);
    EXPECT_FALSE(PresentGetSettings().deferred_canonical);
    const std::array cases{
        std::pair{24.0,                                    24.0},
        std::pair{30.0,                                    30.0},
        std::pair{60.0,                                    60.0},
        std::pair{0.0,                                     60.0},
        std::pair{-1.0,                                    60.0},
        std::pair{120.0,                                   60.0},
        std::pair{std::numeric_limits<double>::infinity(), 60.0}
    };
    for (const auto &[cap, expected] : cases) {
        PresentSettings requested;
        requested.max_fps = cap;
        requested.interpolation = false;
        requested.show_fps = true;
        requested.display_per_tick = 4;
        PresentSetSettings(dc2::presentation::SwitchPresentationSettings(requested));
        const auto &actual = PresentGetSettings();
        EXPECT_DOUBLE_EQ(actual.max_fps, expected);
        EXPECT_TRUE(actual.endpoint_preflight);
        EXPECT_TRUE(actual.deferred_canonical);
        EXPECT_FALSE(actual.interpolation);
        EXPECT_TRUE(actual.show_fps);
        EXPECT_EQ(actual.display_per_tick, 0);
    }
    PresentSetSettings({});
    EXPECT_FALSE(PresentGetSettings().endpoint_preflight);
    EXPECT_FALSE(PresentGetSettings().deferred_canonical);
}

TEST_F(PresentationSettings, ExplicitOverridesAreResolvedAgainForEachSettingsInstance) {
    const auto shipping = dc2::presentation::SwitchPresentationSettings({});
    ASSERT_EQ(dc::test::SetEnv("DC2_PERF_ENDPOINT_PREFLIGHT", "0", 1), 0);
    ASSERT_EQ(dc::test::SetEnv("DC2_PERF_DEFERRED_CANONICAL_COMMIT", "0", 1), 0);
    PresentSetSettings(shipping);
    EXPECT_FALSE(PresentGetSettings().endpoint_preflight);
    EXPECT_FALSE(PresentGetSettings().deferred_canonical);
    ASSERT_EQ(dc::test::SetEnv("DC2_PERF_ENDPOINT_PREFLIGHT", "1", 1), 0);
    ASSERT_EQ(dc::test::SetEnv("DC2_PERF_DEFERRED_CANONICAL_COMMIT", "1", 1), 0);
    PresentSetSettings({});
    EXPECT_TRUE(PresentGetSettings().endpoint_preflight);
    EXPECT_TRUE(PresentGetSettings().deferred_canonical);
    ASSERT_EQ(dc::test::SetEnv("DC2_PERF_ENDPOINT_PREFLIGHT", "invalid", 1), 0);
    ASSERT_EQ(dc::test::SetEnv("DC2_PERF_DEFERRED_CANONICAL_COMMIT", "invalid", 1), 0);
    PresentSetSettings(shipping);
    EXPECT_TRUE(PresentGetSettings().endpoint_preflight);
    EXPECT_TRUE(PresentGetSettings().deferred_canonical);
    PresentSetSettings({});
    EXPECT_FALSE(PresentGetSettings().endpoint_preflight);
    EXPECT_FALSE(PresentGetSettings().deferred_canonical);
    ASSERT_EQ(dc::test::UnsetEnv("DC2_PERF_ENDPOINT_PREFLIGHT"), 0);
    ASSERT_EQ(dc::test::UnsetEnv("DC2_PERF_DEFERRED_CANONICAL_COMMIT"), 0);
    PresentSetSettings({});
    EXPECT_FALSE(PresentGetSettings().endpoint_preflight);
    EXPECT_FALSE(PresentGetSettings().deferred_canonical);
}

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

TEST(PresentTiming, UngatedNewCanonicalRetiresOnlyDueEndpointsAndNeverBlocksForOldImages) {
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

TEST(PresentTiming, GatedRetirementRescuesShownMidpointsAtMeasuredCapEdges) {
    using Pair = dc2::presentation::EndpointPair;
    for (const auto midpoint_start : {origin + 16667us, origin + 20ms}) {
        for (const auto elapsed : {16487us, 16597us, 16562us}) {
            PresentPacer pacer;
            Pair         pair;
            pair.Begin();
            auto       now = midpoint_start;
            const auto end = origin + 33334us;
            ASSERT_EQ(pair.Next(now, end, 60, pacer).action, Pair::Action::Intermediate);
            ASSERT_TRUE(pacer.Present([] { return true; }, [&] { return now; }));
            pair.Presented(Pair::Action::Intermediate);
            ASSERT_TRUE(pair.PendingEndpoint());
            now += elapsed;
            EXPECT_EQ(pair.Next(now, end, 60, pacer).action, Pair::Action::Wait);
            EXPECT_EQ(pair.NextBeforeCanonical(now, end, 60, pacer, false).action, Pair::Action::Wait);
            const auto retiring = pair.NextBeforeCanonical(now, end, 60, pacer, true);
            EXPECT_EQ(retiring.action, Pair::Action::Endpoint);
            EXPECT_EQ(retiring.deadline, now);
            EXPECT_TRUE(pair.PendingEndpoint());
            EXPECT_EQ(pair.Next(now, end, 60, pacer).action, Pair::Action::Wait);
            ASSERT_TRUE(pacer.Present([] { return true; }, [&] { return now; }));
            pair.Presented(Pair::Action::Endpoint);
            EXPECT_FALSE(pair.PendingEndpoint());
            EXPECT_TRUE(pair.Finished());
            EXPECT_EQ(pair.NextBeforeCanonical(now, end, 60, pacer, true).action, Pair::Action::Done);
        }
    }
}

TEST(PresentTiming, GatedRetirementPreservesLowerCapsAndRequiresActualAvailability) {
    using Pair = dc2::presentation::EndpointPair;
    const std::array rates = {
        std::pair{0.0,                                      true },
        std::pair{-1.0,                                     true },
        std::pair{60.0,                                     true },
        std::pair{120.0,                                    true },
        std::pair{std::numeric_limits<double>::quiet_NaN(), true },
        std::pair{std::numeric_limits<double>::infinity(),  true },
        std::pair{-std::numeric_limits<double>::infinity(), true },
        std::pair{59.999,                                   false},
        std::pair{30.0,                                     false},
        std::pair{1.0,                                      false},
        std::pair{.5,                                       false}
    };
    for (const auto &[rate, rescue] : rates) {
        SCOPED_TRACE(rate);
        PresentPacer pacer;
        Pair         pair;
        pair.Begin();
        auto       now = origin + 16667us;
        const auto end = origin + 33334us;
        ASSERT_EQ(pair.Next(now, end, rate, pacer).action, Pair::Action::Intermediate);
        ASSERT_TRUE(pacer.Present([] { return true; }, [&] { return now; }));
        pair.Presented(Pair::Action::Intermediate);
        now += 16487us;
        EXPECT_EQ(pair.NextBeforeCanonical(now, end, rate, pacer, false).action, Pair::Action::Wait);
        EXPECT_EQ(pair.NextBeforeCanonical(now, end, rate, pacer, true).action,
                  rescue ? Pair::Action::Endpoint : Pair::Action::Wait);
        EXPECT_EQ(pair.Next(now, end, rate, pacer).action, Pair::Action::Wait);
    }
}

TEST(PresentTiming, GatedRetirementDoesNotConsumeFailedOrUnshownPhases) {
    using Pair = dc2::presentation::EndpointPair;
    PresentPacer pacer;
    Pair         pair;
    auto         now = origin + 10ms;
    const auto   end = origin + 33334us;
    EXPECT_FALSE(pair.PendingEndpoint());
    EXPECT_EQ(pair.NextBeforeCanonical(now, end, 60, pacer, true).action, Pair::Action::Done);
    pair.Begin();
    EXPECT_FALSE(pair.PendingEndpoint());
    EXPECT_EQ(pair.NextBeforeCanonical(now, end, 60, pacer, true).action, Pair::Action::Intermediate);
    EXPECT_FALSE(pacer.Present([] { return false; }, [&] { return now; }));
    EXPECT_FALSE(pair.PendingEndpoint());
    EXPECT_EQ(pair.NextBeforeCanonical(now, end, 60, pacer, true).action, Pair::Action::Intermediate);
    EXPECT_EQ(pair.NextBeforeCanonical(end + 1ms, end, 60, pacer, true).action, Pair::Action::Endpoint);
    EXPECT_FALSE(pair.PendingEndpoint());
    pair.Cancel();
    pair.Begin();
    now = origin + 50ms;
    const auto next_end = origin + 83334us;
    ASSERT_EQ(pair.Next(now, next_end, 60, pacer).action, Pair::Action::Intermediate);
    ASSERT_TRUE(pacer.Present([] { return true; }, [&] { return now; }));
    pair.Presented(Pair::Action::Intermediate);
    ASSERT_TRUE(pair.PendingEndpoint());
    now += 16487us;
    EXPECT_EQ(pair.NextBeforeCanonical(now, next_end, 60, pacer, true).action, Pair::Action::Endpoint);
    EXPECT_FALSE(pacer.Present([] { return false; }, [&] { return now; }));
    EXPECT_TRUE(pair.PendingEndpoint());
    pair.Cancel();
    EXPECT_FALSE(pair.PendingEndpoint());
    EXPECT_TRUE(pair.Finished());
    EXPECT_EQ(pair.NextBeforeCanonical(now, next_end, 60, pacer, true).action, Pair::Action::Done);
}

TEST(PresentTiming, GatedIdleKeepsReadyMidpointWhenSoftwareCapFallsBeyondFrameEnd) {
    using Pair = dc2::presentation::EndpointPair;
    PresentPacer pacer;
    auto         now = origin + 520260us;
    ASSERT_EQ(pacer.Next(now, Clock::time_point::max(), 60).action, Action::Display);
    ASSERT_TRUE(pacer.Present([] { return true; }, [&] { return now; }));
    Pair pair;
    pair.Begin();
    now = origin + 532437us;
    const auto end = origin + 533334us;
    const auto cap = pacer.Next(now, Clock::time_point::max(), 60);
    ASSERT_EQ(cap.action, Action::Wait);
    EXPECT_GT(cap.deadline, end);
    const auto ungated = pair.NextIdle(now, end, 60, pacer, false);
    EXPECT_EQ(ungated.action, Pair::Action::Wait);
    EXPECT_EQ(ungated.deadline, end);
    const auto gated = pair.NextIdle(now, end, 60, pacer, true);
    ASSERT_EQ(gated.action, Pair::Action::Intermediate);
    EXPECT_EQ(gated.deadline, now);
    ASSERT_TRUE(pacer.Present([] { return true; }, [&] { return now; }));
    pair.Presented(Pair::Action::Intermediate);
    ASSERT_TRUE(pair.PendingEndpoint());
    const auto pending = pair.NextIdle(now + 1us, end, 60, pacer, true);
    EXPECT_EQ(pending.action, Pair::Action::Wait);
    EXPECT_EQ(pending.deadline, end);
    now = end;
    ASSERT_EQ(pair.NextIdle(now, end, 60, pacer, true).action, Pair::Action::Endpoint);
    ASSERT_TRUE(pacer.Present([] { return true; }, [&] { return now; }));
    pair.Presented(Pair::Action::Endpoint);
    EXPECT_TRUE(pair.Finished());
    EXPECT_EQ(pair.NextIdle(now, end, 60, pacer, true).action, Pair::Action::Done);
}

TEST(PresentTiming, GatedCurrentSourceAdmitsOneMidpointAfterSimulationDeadline) {
    using Pair = dc2::presentation::EndpointPair;
    const auto end = origin + 533334us;
    for (const auto delay : {0us, 243us, 3113us}) {
        PresentPacer pacer;
        auto         now = origin + 520260us;
        ASSERT_EQ(pacer.Next(now, Clock::time_point::max(), 60).action, Action::Display);
        ASSERT_TRUE(pacer.Present([] { return true; }, [&] { return now; }));
        Pair pair;
        pair.Begin();
        now = end + delay;
        const auto admitted = pair.NextIdle(now, end, 60, pacer, true);
        ASSERT_EQ(admitted.action, Pair::Action::Intermediate);
        EXPECT_EQ(admitted.deadline, now);
        EXPECT_FALSE(pair.PendingEndpoint());
        EXPECT_FALSE(pacer.Present([] { return false; }, [&] { return now; }));
        EXPECT_EQ(pair.NextIdle(now, end, 60, pacer, true).action, Pair::Action::Intermediate);
        ASSERT_TRUE(pacer.Present([] { return true; }, [&] { return now; }));
        pair.Presented(Pair::Action::Intermediate);
        ASSERT_TRUE(pair.PendingEndpoint());
        ASSERT_EQ(pair.NextIdle(now, end, 60, pacer, true).action, Pair::Action::Endpoint);
        ASSERT_TRUE(pacer.Present([] { return true; }, [&] { return now; }));
        pair.Presented(Pair::Action::Endpoint);
        EXPECT_TRUE(pair.Finished());
        EXPECT_EQ(pair.NextIdle(now + 100ms, end, 60, pacer, true).action, Pair::Action::Done);
    }
}

TEST(PresentTiming, UngatedAndLowerCapCurrentSourcesStillDropExpiredMidpoints) {
    using Pair = dc2::presentation::EndpointPair;
    const std::array cases = {
        std::pair{60.0,   false},
        std::pair{120.0,  false},
        std::pair{0.0,    false},
        std::pair{-1.0,   false},
        std::pair{30.0,   false},
        std::pair{30.0,   true },
        std::pair{59.999, true }
    };
    const auto end = origin + 20ms;
    const auto now = end + 3113us;
    for (const auto &[rate, gate_active] : cases) {
        PresentPacer pacer;
        Pair         pair;
        pair.Begin();
        const auto original = pair.Next(now, end, rate, pacer);
        const auto idle = pair.NextIdle(now, end, rate, pacer, gate_active);
        EXPECT_EQ(original.action, Pair::Action::Endpoint);
        EXPECT_EQ(idle.action, original.action);
        EXPECT_EQ(idle.deadline, original.deadline);
        EXPECT_FALSE(pair.PendingEndpoint());
    }
}

TEST(PresentTiming, GatedCurrentSourceCancellationAndRetirementNeverForceAnUnshownMidpoint) {
    using Pair = dc2::presentation::EndpointPair;
    PresentPacer pacer;
    Pair         pair;
    const auto   end = origin + 20ms;
    const auto   now = end + 243us;
    EXPECT_EQ(pair.NextIdle(now, end, 60, pacer, true).action, Pair::Action::Done);
    pair.Begin();
    EXPECT_EQ(pair.NextBeforeCanonical(now, end, 60, pacer, true).action, Pair::Action::Endpoint);
    EXPECT_FALSE(pair.PendingEndpoint());
    pair.Cancel();
    EXPECT_EQ(pair.NextIdle(now + 100ms, end, 60, pacer, true).action, Pair::Action::Done);
    pair.Begin();
    ASSERT_EQ(pair.NextIdle(now, end, 60, pacer, true).action, Pair::Action::Intermediate);
    pair.Cancel();
    EXPECT_EQ(pair.NextIdle(now, end, 60, pacer, true).action, Pair::Action::Done);
    EXPECT_EQ(pair.NextBeforeCanonical(now, end, 60, pacer, true).action, Pair::Action::Done);
    pair.Begin();
    ASSERT_EQ(pair.NextIdle(now, end, 60, pacer, true).action, Pair::Action::Intermediate);
    ASSERT_TRUE(pacer.Present([] { return true; }, [&] { return now; }));
    pair.Presented(Pair::Action::Intermediate);
    ASSERT_TRUE(pair.PendingEndpoint());
    EXPECT_EQ(pair.NextBeforeCanonical(now, end, 60, pacer, true).action, Pair::Action::Endpoint);
    pair.Cancel();
    EXPECT_FALSE(pair.PendingEndpoint());
    EXPECT_EQ(pair.NextIdle(now, end, 60, pacer, true).action, Pair::Action::Done);
}

TEST(PresentTiming, GatedIdlePreservesLowerCapsAndTheUngatedDecision) {
    using Pair = dc2::presentation::EndpointPair;
    const std::array rates = {
        std::pair{30.0,   false},
        std::pair{59.999, false},
        std::pair{60.0,   true },
        std::pair{120.0,  true },
        std::pair{0.0,    true }
    };
    for (const auto &[rate, midpoint] : rates) {
        SCOPED_TRACE(rate);
        PresentPacer pacer;
        auto         now = origin + 520260us;
        ASSERT_EQ(pacer.Next(now, Clock::time_point::max(), rate).action, Action::Display);
        ASSERT_TRUE(pacer.Present([] { return true; }, [&] { return now; }));
        Pair pair;
        pair.Begin();
        now += 1ms;
        const auto end = now + 1ms;
        const auto original = pair.Next(now, end, rate, pacer);
        const auto ungated = pair.NextIdle(now, end, rate, pacer, false);
        EXPECT_EQ(ungated.action, original.action);
        EXPECT_EQ(ungated.deadline, original.deadline);
        EXPECT_EQ(pair.NextIdle(now, end, rate, pacer, true).action,
                  midpoint ? Pair::Action::Intermediate : Pair::Action::Wait);
        EXPECT_FALSE(pair.PendingEndpoint());
    }
}

TEST(PresentTiming, EndpointPreflightQueriesOnlyEligibleShownIdleEndpoints) {
    using Pair = dc2::presentation::EndpointPair;
    Pair       pair;
    int        queries = 0;
    const auto pending = [&] {
        ++queries;
        return false;
    };
    EXPECT_TRUE(pair.IdleEndpointFeedbackReady(Pair::Action::Endpoint, 60, true, true, pending));
    pair.Begin();
    EXPECT_TRUE(pair.IdleEndpointFeedbackReady(Pair::Action::Endpoint, 60, true, true, pending));
    pair.Presented(Pair::Action::Intermediate);
    for (auto action : {Pair::Action::Intermediate, Pair::Action::Wait, Pair::Action::Done}) {
        EXPECT_TRUE(pair.IdleEndpointFeedbackReady(action, 60, true, true, pending));
    }
    EXPECT_TRUE(pair.IdleEndpointFeedbackReady(Pair::Action::Endpoint, 60, false, true, pending));
    EXPECT_TRUE(pair.IdleEndpointFeedbackReady(Pair::Action::Endpoint, 60, true, false, pending));
    for (double cap : {1.0, 30.0, 59.999}) {
        EXPECT_TRUE(pair.IdleEndpointFeedbackReady(Pair::Action::Endpoint, cap, true, true, pending));
    }
    EXPECT_EQ(queries, 0);
    for (double cap : {60.0, 120.0, 0.0, -1.0, std::numeric_limits<double>::infinity(),
                       -std::numeric_limits<double>::infinity(), std::numeric_limits<double>::quiet_NaN()}) {
        const int before = queries;
        EXPECT_FALSE(pair.IdleEndpointFeedbackReady(Pair::Action::Endpoint, cap, true, true, pending));
        EXPECT_EQ(queries, before + 1);
        EXPECT_TRUE(pair.PendingEndpoint());
    }
    const int before_cancel = queries;
    pair.Cancel();
    EXPECT_TRUE(pair.IdleEndpointFeedbackReady(Pair::Action::Endpoint, 60, true, true, pending));
    EXPECT_EQ(queries, before_cancel);
    EXPECT_TRUE(pair.Finished());
}

TEST(PresentTiming, PendingEndpointPreflightDoesNotSubmitAdvanceOrConsumePacingAndReadyRetriesOnce) {
    using Pair = dc2::presentation::EndpointPair;
    Pair         pair;
    PresentPacer pacer;
    const auto   end = origin + 33ms;
    auto         now = origin + 10ms;
    ASSERT_EQ(pacer.Next(now, end, 60).action, Action::Display);
    ASSERT_TRUE(pacer.Present([] { return true; }, [&] { return now; }));
    pair.Begin();
    pair.Presented(Pair::Action::Intermediate);

    int        probes = 0;
    int        submits = 0;
    bool       ready = false;
    const auto query = [&] {
        ++probes;
        return ready;
    };
    for (int poll = 0; poll < 4; ++poll) {
        now = end + std::chrono::milliseconds(poll);
        const auto action = pair.NextIdle(now, end, 60, pacer, true).action;
        ASSERT_EQ(action, Pair::Action::Endpoint);
        const bool proceed = pair.IdleEndpointFeedbackReady(action, 60, true, true, query);
        if (proceed && pacer.Present([&] { ++submits; return true; }, [&] { return now; })) {
            pair.Presented(action);
        }
        EXPECT_FALSE(proceed);
        EXPECT_EQ(submits, 0);
        EXPECT_EQ(probes, poll + 1);
        EXPECT_TRUE(pair.PendingEndpoint());
        EXPECT_FALSE(pair.Finished());
    }
    // A later software-cap observation still refers to the original successful midpoint start.
    const auto cap = pacer.Next(now, origin + 1s, 10);
    EXPECT_EQ(cap.action, Action::Wait);
    EXPECT_EQ(cap.deadline, origin + 110ms);
    EXPECT_EQ(pair.NextBeforeCanonical(now, end, 60, pacer, true).action, Pair::Action::Endpoint);
    EXPECT_EQ(probes, 4);

    ready = true;
    now += 1ms;
    const auto action = pair.NextIdle(now, end, 60, pacer, true).action;
    ASSERT_EQ(action, Pair::Action::Endpoint);
    ASSERT_TRUE(pair.IdleEndpointFeedbackReady(action, 60, true, true, query));
    EXPECT_EQ(probes, 5);
    EXPECT_TRUE(pair.PendingEndpoint());
    ASSERT_TRUE(pacer.Present([&] { ++submits; return true; }, [&] { return now; }));
    pair.Presented(action);
    EXPECT_EQ(submits, 1);
    EXPECT_TRUE(pair.Finished());
    EXPECT_EQ(pair.NextIdle(now, end, 60, pacer, true).action, Pair::Action::Done);
    EXPECT_TRUE(pair.IdleEndpointFeedbackReady(Pair::Action::Done, 60, true, true, query));
    EXPECT_EQ(probes, 5);
}

TEST(PresentTiming, ReadyEndpointPreflightAloneCannotAdvanceAFailedPresentation) {
    using Pair = dc2::presentation::EndpointPair;
    Pair         pair;
    PresentPacer pacer;
    pair.Begin();
    pair.Presented(Pair::Action::Intermediate);
    const auto now = origin + 40ms;
    const auto action = pair.NextIdle(now, origin + 33ms, 60, pacer, true).action;
    ASSERT_EQ(action, Pair::Action::Endpoint);
    int probes = 0;
    ASSERT_TRUE(pair.IdleEndpointFeedbackReady(action, 60, true, true, [&] {
        ++probes;
        return true;
    }));
    EXPECT_FALSE(pacer.Present([] { return false; }, [&] { return now; }));
    EXPECT_EQ(probes, 1);
    EXPECT_TRUE(pair.PendingEndpoint());
    EXPECT_EQ(pair.NextIdle(now + 1ms, origin + 33ms, 60, pacer, true).action, Pair::Action::Endpoint);
}
