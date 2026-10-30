#include <eekernel.h>
#include <gtest/gtest.h>

#include <cstdint>
#include <limits>
#include <string>
#include <utility>

#include "gamepad.hpp"
#include "input/gamepad_state.hpp"
#include "mainloop.hpp"
#include "mglib.hpp"
#include "platform/clock.hpp"
#include "platform/input_script.hpp"
#include "sce/threads.hpp"

void WaitVSync(int start, int frames);

namespace {

constexpr std::int64_t kPressFrame = 4;
constexpr std::int64_t kReleaseFrame = 5;

// Both pads are scripted so both are connected; an unscripted port reads as unplugged.
const std::string kPressFirstPort = "0 pad1\n0 pad2\n4 pad1 cross 255 128 128 128\n5 pad1\n";
const std::string kPressSecondPort = "0 pad1\n0 pad2\n4 pad2 circle 128 128 255 128\n5 pad2\n";

void InstallScript(const std::string &text) {
    InputScript script;
    std::string error;
    ASSERT_TRUE(InputScriptParse(text, script, error)) << error;
    InputScriptInstall(std::move(script));
}

void InitGamePad() {
    // Init spins on sceGsSyncV, which would otherwise sleep a field per call.
    ClockSetUnbounded(true);
    ClockReset();
    GamePad__2.Init();
}

void Tick(std::int64_t frame) {
    InputScriptApply(frame);
    GamePad__2.UpDate();
}

void WarmUp() {
    for (std::int64_t frame = 0; frame < kPressFrame; ++frame) {
        Tick(frame);
    }
}

void RotateControllerQueue() {
    RotateThreadReadyQueue(GAMEPAD_THREAD_PRIORITY);
}

} // namespace

TEST(PlatformPad, InitReachesAnalogReadyOnBothPorts) {
    InstallScript("0 pad1\n0 pad2\n");
    InitGamePad();
    WarmUp();

    EXPECT_EQ(GamePad__2.pad[0].phase, PAD_PHASE_READY);
    EXPECT_EQ(GamePad__2.pad[1].phase, PAD_PHASE_READY);
    EXPECT_EQ(GamePad__2.pad[0].pad_mode, PAD_TERMINAL_DUALSHOCK);
    EXPECT_EQ(GamePad__2.pad[1].pad_mode, PAD_TERMINAL_DUALSHOCK);
    EXPECT_EQ(GamePad__2.GetLX(), 0);
    EXPECT_EQ(GamePad__2.GetRX2(), 0);
    InputScriptInstall({});
}

TEST(PlatformPad, ScriptedPressReadsOnFirstPortAndReleases) {
    InstallScript(kPressFirstPort);
    InitGamePad();
    WarmUp();

    Tick(kPressFrame);
    EXPECT_TRUE(GamePad__2.On(PAD_CROSS));
    EXPECT_TRUE(GamePad__2.Down(PAD_CROSS));
    EXPECT_FALSE(GamePad__2.Up(PAD_CROSS));
    EXPECT_FALSE(GamePad__2.On(PAD_CIRCLE));
    EXPECT_EQ(GamePad__2.GetLX(), 128);

    Tick(kPressFrame + 1);
    EXPECT_FALSE(GamePad__2.On(PAD_CROSS));
    EXPECT_FALSE(GamePad__2.Down(PAD_CROSS));
    EXPECT_TRUE(GamePad__2.Up(PAD_CROSS));
    EXPECT_EQ(GamePad__2.GetLX(), 0);
    InputScriptInstall({});
}

TEST(PlatformPad, ScriptedPressReadsOnSecondPortAndReleases) {
    InstallScript(kPressSecondPort);
    InitGamePad();
    WarmUp();

    Tick(kPressFrame);
    EXPECT_TRUE(GamePad__2.On2(PAD_CIRCLE));
    EXPECT_TRUE(GamePad__2.Down2(PAD_CIRCLE));
    EXPECT_FALSE(GamePad__2.On(PAD_CIRCLE));
    EXPECT_EQ(GamePad__2.GetRX2(), 128);

    Tick(kReleaseFrame);
    EXPECT_FALSE(GamePad__2.On2(PAD_CIRCLE));
    EXPECT_FALSE(GamePad__2.Down2(PAD_CIRCLE));
    EXPECT_NE(GamePad__2.previous_pad[1].button & PAD_CIRCLE, 0);
    EXPECT_EQ(GamePad__2.pad[1].button & PAD_CIRCLE, 0);
    EXPECT_EQ(GamePad__2.GetRX2(), 0);
    InputScriptInstall({});
}

TEST(PlatformPad, VibrationThreadStepsWithoutDeadlock) {
    InstallScript("0 pad1\n0 pad2\n");
    InitGamePad();
    KzThreadsSetMainPriority(GAMEPAD_THREAD_PRIORITY);

    CreateGamePadThread(&GamePad__2);
    mgSetRotateThread(GAMEPAD_THREAD_PRIORITY);
    WaitVSync(mgGetVSyncCount(), 3);
    mgSetRotateThread(-1);
    dc2::input::StopControllerThread();

    // Step accumulates up to the thread's last turn, which runs one tick before the final count.
    EXPECT_GT(GamePad__2.vibration_elapsed, 0);
    EXPECT_EQ(GamePad__2.vibration_elapsed, mgGetVSyncCount() - 1);
    InputScriptInstall({});
}

TEST(PlatformPad, ReplacingAndStoppingTheWorkerLeavesNoReadyControllerThread) {
    KzThreadsSetMainPriority(GAMEPAD_THREAD_PRIORITY);
    CreateGamePadThread(&GamePad__2);
    CreateGamePadThread(&GamePad__2);
    dc2::input::StopControllerThread();
    dc2::input::StopControllerThread();

    ClockSetUnbounded(true);
    ClockAddPumpHook(RotateControllerQueue);
    ClockPump();
    ClockRemovePumpHook(RotateControllerQueue);
}

TEST(PlatformPad, NullControllerRetiresTheWorkerBeforeReleasingItsCapture) {
    KzThreadsSetMainPriority(GAMEPAD_THREAD_PRIORITY);
    CreateGamePadThread(&GamePad__2);
    CreateGamePadThread(nullptr);

    ClockSetUnbounded(true);
    ClockAddPumpHook(RotateControllerQueue);
    ClockPump();
    ClockRemovePumpHook(RotateControllerQueue);
}

TEST(PlatformPad, CalibrationClampsMalformedSamplesBeforeArithmetic) {
    CGamePad controller;
    controller.pad[0].left_x = std::numeric_limits<int>::min();
    controller.pad[0].left_y = std::numeric_limits<int>::max();
    controller.pad[0].right_x = std::numeric_limits<int>::max();
    controller.pad[0].right_y = std::numeric_limits<int>::min();
    controller.pad[1].right_x = std::numeric_limits<int>::min();
    EXPECT_EQ(controller.GetLX(), -128);
    EXPECT_EQ(controller.GetLY(), 128);
    EXPECT_EQ(controller.GetRX(), 128);
    EXPECT_EQ(controller.GetRY(), -128);
    EXPECT_EQ(controller.GetRX2(), -128);
}
