#include <SDL3/SDL.h>
#include <gtest/gtest.h>

#include <cmath>
#include <numbers>
#include <utility>

#include "gamepad.hpp"
#include "mainloop.hpp"
#include "padcontrol.hpp"
#include "platform/clock.hpp"
#include "platform/input.hpp"

TEST(MouseDelivery, LogicalPadUpdateLatchesMotionWithoutDeflectingTheStick) {
    InputResetBindings();
    InputPadState input{.connected = true};
    InputSetOverride(0, &input);
    InputSetScriptedDevices({.mouse_dx = 400.0f, .mouse_dy = -50.0f});
    GamePad__2.pad[0].right_x = GamePad__2.pad[0].right_y = 128;
    GamePad__2.pad[0].left_x = GamePad__2.pad[0].left_y = 128;
    const auto  before = InputGetMouseLook().read;
    CPadControl pad{};
    pad.Initialize();
    pad.Update(&GamePad__2);
    EXPECT_EQ(InputGetMouseLook().read, before + 1);
    EXPECT_NEAR(InputGetMouseLook().yaw, 40.0f * std::numbers::pi_v<float> / 180.0f, 0.00001f);
    EXPECT_GT(InputGetMouseLook().pitch, 0.0f);
    EXPECT_EQ(pad.rx, 0.0f);
    EXPECT_EQ(pad.ry, 0.0f);
    InputSetScriptedDevices({});
    pad.Update(&GamePad__2);
    EXPECT_EQ(InputGetMouseLook().yaw, 0.0f);
    InputSetOverride(0, nullptr);
}

TEST(MouseDelivery, NativeButtonEventsReachTheRetailPad) {
    InputResetBindings();
    InputSetMouseSettings({.capture = false});
    ClockSetUnbounded(true);
    ClockReset();
    InputPoll();
    GamePad__2.Init();
    for (int n = 0; n < 4; ++n) {
        GamePad__2.UpDate();
    }
    SDL_Event event{};
    event.type = SDL_EVENT_MOUSE_BUTTON_DOWN;
    for (auto [button, mask] : {
             std::pair{SDL_BUTTON_LEFT,   PAD_CROSS },
             std::pair{SDL_BUTTON_RIGHT,  PAD_CIRCLE},
             std::pair{SDL_BUTTON_MIDDLE, PAD_R3    }
    }) {
        event.button.button = button;
        InputHandleEvent(event);
        InputPoll();
        GamePad__2.UpDate();
        EXPECT_NE(GamePad__2.pad[0].button & mask, 0);
        event.type = SDL_EVENT_MOUSE_BUTTON_UP;
        InputHandleEvent(event);
        InputPoll();
        GamePad__2.UpDate();
        EXPECT_EQ(GamePad__2.pad[0].button & mask, 0);
        event.type = SDL_EVENT_MOUSE_BUTTON_DOWN;
    }
    InputShutdown();
}

TEST(MouseDelivery, NativeMotionEventsReachLookAndFocusLossDropsThem) {
    InputResetBindings();
    InputSetOverride(0, nullptr);
    InputSetMouseSettings({.capture = false});
    SDL_Event motion{};
    motion.type = SDL_EVENT_MOUSE_MOTION;
    motion.motion.xrel = 120;
    motion.motion.yrel = -40;
    InputHandleEvent(motion);
    CPadControl pad{};
    pad.Initialize();
    pad.Update(&GamePad__2);
    EXPECT_NEAR(InputGetMouseLook().yaw, 12 * std::numbers::pi_v<float> / 180, 0.00001f);
    EXPECT_GT(InputGetMouseLook().pitch, 0);
    InputHandleEvent(motion);
    SDL_Event lost{};
    lost.type = SDL_EVENT_WINDOW_FOCUS_LOST;
    InputHandleEvent(lost);
    pad.Update(&GamePad__2);
    EXPECT_EQ(InputGetMouseLook().yaw, 0);
    EXPECT_EQ(InputGetMouseLook().pitch, 0);
    InputShutdown();
}
