#pragma once

// Hold-R2 sprint, shared by towns (editctrl.cpp) and dungeons (dungeon_sprint.cpp): holding R2 while walking
// speeds up the retail walk, and a short tap still enters the first-person view, on release.
constexpr float kSprintSpeed = 1.8f;     // ground speed while sprinting
constexpr float kSprintStep = 1.4f;      // motion speed, so the run keeps up with the ground
constexpr float kSprintTapFields = 15;   // a release sooner than this (0.25 s) is a tap

// Times an R2 press. Holding it sprints; a release before kSprintTapFields is a tap.
struct SprintTimer {
    bool  tracking = false;
    float fields = 0;

    // pressed, held and released are R2's edge, state and release this frame; elapsed is the frame's fields.
    // Returns whether this frame sprints, and sets tap on the frame a quick press is released.
    bool Step(bool allowed, bool pressed, bool held, bool released, float elapsed, bool &tap) {
        tap = false;
        if (!allowed) {
            tracking = false;
            return false;
        }
        if (pressed) {
            tracking = true;
            fields = 0;
        }
        if (!tracking) {
            return false;
        }
        if (held) {
            fields += elapsed;
            return true;
        }
        tracking = false;
        // Only a release on this frame is a tap. Control suspended since the press (a menu opened on the
        // same frame) leaves a stale press, which is dropped.
        tap = released && fields < kSprintTapFields;
        return false;
    }
};
