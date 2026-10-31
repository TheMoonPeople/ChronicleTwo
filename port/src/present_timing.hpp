#pragma once

#include <algorithm>
#include <chrono>
#include <cmath>

// Presentation deadlines use the same steady clock as the game's field deadlines.
class PresentPacer {
public:
    using Clock = std::chrono::steady_clock;
    enum class Action {
        Tick,
        Wait,
        Display
    };

    struct Decision {
        Action            action{Action::Tick};
        Clock::time_point deadline;
    };

    [[nodiscard]] Decision Next(Clock::time_point now, Clock::time_point next_tick, double max_fps) const {
        if (now >= next_tick) {
            return {.action = Action::Tick, .deadline = next_tick};
        }
        period_ = Clock::duration::zero();
        if (std::isfinite(max_fps) && max_fps > 0.0) {
            const auto period = std::chrono::duration_cast<Clock::duration>(
                std::chrono::duration<double>(1.0 / std::max(1.0, max_fps)));
            period_ = period;
            const auto due = last_start_ > Clock::time_point::max() - period
                                 ? Clock::time_point::max()
                                 : last_start_ + period;
            if (now < due) {
                // Even a tick with no display yet must yield to the simulation deadline.
                return due >= next_tick ? Decision{.action = Action::Tick, .deadline = next_tick}
                                        : Decision{.action = Action::Wait, .deadline = due};
            }
        }
        return {.action = Action::Display, .deadline = now};
    }

    template <class Render, class Now>
    bool Present(Render render, Now now) {
        const auto start = now();
        if (!render()) {
            return false;
        }
        // A presentation that starts within half a period of its slot keeps the slot, so wake-up lateness never
        // accumulates into a skipped tick; a later one keeps no debt for the slots it missed.
        const auto slot = last_start_ + period_;
        last_start_ = period_ > Clock::duration::zero() && last_start_ <= Clock::time_point::max() - period_ && start >= slot &&
                              start - slot < period_ / 2
                          ? slot
                          : start;
        return true;
    }

private:
    Clock::time_point last_start_;
    // The display period the last Next allowed, or zero when uncapped.
    mutable Clock::duration period_{};
};

inline float PresentFrameAlpha(double elapsed_fields, double fractional_field, int frame_fields) {
    const double alpha = frame_fields > 0 ? (elapsed_fields + fractional_field) / frame_fields
                                          : fractional_field;
    return static_cast<float>(std::clamp(alpha, 0.0, std::nextafter(1.0, 0.0)));
}

namespace dc2::presentation {

/**
 * Schedules one intermediate image followed by its authoritative authored endpoint.
 */
class EndpointPair {
public:
    using Clock = PresentPacer::Clock;
    enum class Action {
        Wait,
        Intermediate,
        Endpoint,
        Done
    };

    struct Decision {
        Action            action = Action::Done; /**< Work permitted at this instant. */
        Clock::time_point deadline{};            /**< Earliest time at which the work may begin. */
    };

    /**
     * Starts a newly published two-field frame.
     */
    void Begin() { phase = Phase::Intermediate; }

    /**
     * Whether the current publication has shown both of its images, or was retired.
     */
    [[nodiscard]] bool Finished() const { return phase == Phase::Done; }

    /**
     * Retires an obsolete frame without accumulating presentation debt.
     */
    void Cancel() { phase = Phase::Done; }

    /**
     * Chooses the next phase while preserving the global presentation cap.
     */
    [[nodiscard]] Decision Next(Clock::time_point now, Clock::time_point frame_end, double max_fps, const PresentPacer &pacer) const {
        if (phase == Phase::Done) {
            return {Action::Done, now};
        }
        const auto intermediate = pacer.Next(now, frame_end, max_fps);
        if (phase == Phase::Intermediate && intermediate.action != PresentPacer::Action::Tick) {
            return {intermediate.action == PresentPacer::Action::Wait ? Action::Wait : Action::Intermediate, intermediate.deadline};
        }
        if (now < frame_end) {
            return {Action::Wait, frame_end};
        }
        const auto endpoint = pacer.Next(now, Clock::time_point::max(), max_fps);
        return {endpoint.action == PresentPacer::Action::Display ? Action::Endpoint : Action::Wait, endpoint.deadline};
    }

    /**
     * Advances only after a successful presentation.
     */
    void Presented(Action action) {
        if (action == Action::Intermediate) {
            phase = Phase::Endpoint;
        } else if (action == Action::Endpoint) {
            phase = Phase::Done;
        }
    }

private:
    enum class Phase {
        Intermediate,
        Endpoint,
        Done
    };
    Phase phase = Phase::Done; /**< Next unconsumed phase of the current publication. */
};

} // namespace dc2::presentation
