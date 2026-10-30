#include "common.h"

#include <eekernel.h>
#include <libgraph.h>
#include <libpad.h>

#include <algorithm>
#include <array>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <filesystem>
#include <fstream>
#include <vector>

#include "dataread.hpp"
#include "dualsense_haptics.hpp"
#include "gamepad.hpp"
#include "input/gamepad_state.hpp"
#include "kazarov/log.hpp"
#include "log/game_output.hpp"
#include "log/log.hpp"
#include "mainloop.hpp"
#include "menu_mouse.hpp"
#include "menu_mouse_item.hpp"
#include "mglib.hpp"
#include "pad_rumble.hpp"
#include "platform/input.hpp"
#include "platform/paths.hpp"
#include "test_hooks.hpp"

namespace {
/**
 * VSync count at the preceding controller-worker update.
 */
int old_vsync{};
/**
 * Scheduler identifier of the controller worker.
 */
int controller_thread_id{};
/**
 * Controller manager captured by the active controller worker.
 */
CGamePad *captured_pad{};
} // namespace

void CGamePad::Init() {
    key_lock = false;
    key_lock2 = false;
    vibration_enabled = true;
    vibration_elapsed = 0;
    capture_mode = PAD_CAPTURE_OFF;
    capture_frame = 0;

    while (sceGsSyncV(0) == 0) {
    }

    scePadInit(0);
    unk_134 = 0;
    unk_138 = 0;
    unk_13C = 0;
    unk_140 = 0;

    for (int i = 0; i < 2; i++) {
        pad[i].phase = PAD_PHASE_QUERY;
        pad[i].button = 0;
        pad[i].right_y = 0;
        pad[i].right_x = 0;
        pad[i].left_y = 0;
        pad[i].left_x = 0;

        for (int j = 0; j < 6; j++) {
            pad[i].vibration[j] = 0;
            pad[i].vibration_timer[i] = 0;
        }

        axis_threshold[i] = 0;
        repeat[i].enabled = 0;
        repeat[i].active = 0;

        for (int j = 0; j < 32; j++) {
            repeat[i].counter[j] = 0;
            repeat[i].repeat_delay[j] = 0;
            repeat[i].initial_delay[j] = 0;
        }
    }

    if (!scePadPortOpen(0, 0, nullptr)) {
        dc2::log::PrintGame("ERROR: scePadPortOpen\n");
        return;
    }

    sceGsSyncV(0);
    sceGsSyncV(0);

    if (!scePadPortOpen(1, 0, nullptr)) {
        dc2::log::PrintGame("ERROR: scePadPortOpen\n");
        return;
    }

    sceGsSyncV(0);
    sceGsSyncV(0);
}

void CGamePad::Close() {
    scePadPortClose(0, 0);
    scePadPortClose(1, 0);
    scePadEnd();
}

namespace {
/**
 *
 * Reads one controller's buttons and sticks into its state and gives the
 * controller type the data reports, or 0 when nothing was read.
 *
 */
int pad_button_read(PAD_STATUS *status, int port, int slot) {
    std::array<std::uint8_t, 32> data{};
    int                          extended_id = {};
    int                          button = {};

    extended_id = 0;

    if (scePadRead(port, slot, data.data()) == 0) {
        return 0;
    }

    if (data[0] == 0) {
        button = (data[2] << 8) | data[3];
        button = button ^ 0xFFFF;
        status->button = button & 0xFFFF;
        status->right_x = data[4];
        status->right_y = data[5];
        status->left_x = data[6];
        status->left_y = data[7];
        extended_id = data[1] >> 4;
    }

    return extended_id;
}

/**
 *
 * Advances one controller's setup and, once it is ready, reads it; gives
 * nonzero when the controller's buttons and sticks were read.
 *
 */
int read_pad(PAD_STATUS *status, int port, int slot) {
    int  valid = {};
    int  terminal_id = {};
    int *phase = &status->phase;
    int *state = &status->state;
    int *extended_id = &status->extended_id;
    int *pad_mode = &status->pad_mode;
    int *previous_pad_mode = &status->previous_pad_mode;

    *state = scePadGetState(port, slot);

    if (*state == scePadStateDiscon) {
        *phase = PAD_PHASE_QUERY;
    }

    valid = false;

    switch (*phase) {
        case PAD_PHASE_QUERY:
            if (*state == scePadStateStable || *state == scePadStateFindCTP1) {
                terminal_id = scePadInfoMode(port, slot, InfoModeCurID, 0);

                if (terminal_id != 0) {
                    *extended_id = scePadInfoMode(port, slot, InfoModeCurExID, 0);

                    if (*extended_id > 0) {
                        terminal_id = *extended_id;
                    }

                    switch (terminal_id) {
                        case PAD_TERMINAL_NEGCON:
                            *phase = PAD_PHASE_READY;
                            break;
                        case PAD_TERMINAL_KONAMI_GUN:
                            *phase = PAD_PHASE_READY;
                            break;
                        case PAD_TERMINAL_DIGITAL:
                            *phase = PAD_PHASE_ANALOG_CHECK;
                            break;
                        case PAD_TERMINAL_ANALOG_JOYSTICK:
                            *phase = PAD_PHASE_READY;
                            break;
                        case PAD_TERMINAL_NAMCO_GUN:
                            *phase = PAD_PHASE_READY;
                            break;
                        case PAD_TERMINAL_DUALSHOCK:
                            *phase = PAD_PHASE_ACTUATOR_CHECK;
                            break;
                        case PAD_TERMINAL_EX_TSURICON:
                            *phase = PAD_PHASE_READY;
                            break;
                        case PAD_TERMINAL_EX_JOGCON:
                            *phase = PAD_PHASE_READY;
                            break;
                        default:
                            *phase = PAD_PHASE_READY;
                            break;
                    }
                }
            }

            break;
        case PAD_PHASE_ANALOG_CHECK:
            if (scePadInfoMode(port, slot, InfoModeCurExID, 0) == 0) {
                *phase = PAD_PHASE_READY;
                break;
            }

            (*phase)++;

        case PAD_PHASE_ANALOG_SET:
            if (scePadSetMainMode(port, slot, 1, 3) == 1) {
                (*phase)++;
            }

            break;
        case PAD_PHASE_ANALOG_WAIT:
            if (scePadGetState(port, slot) != scePadStateExecCmd) {
                *phase = PAD_PHASE_QUERY;
            }

            break;
        case PAD_PHASE_ACTUATOR_CHECK:
            if (scePadInfoAct(port, slot, -1, 0) == 0) {
                *phase = PAD_PHASE_READY;
            }

            status->actuator[0] = 0;
            status->actuator[1] = 1;
            status->actuator[2] = 0xFF;
            status->actuator[3] = 0xFF;
            status->actuator[4] = 0xFF;
            status->actuator[5] = 0xFF;

            if (scePadSetActAlign(port, slot, status->actuator) != 0) {
                (*phase)++;
            }

            break;
        case PAD_PHASE_ACTUATOR_WAIT:
            if (scePadGetState(port, slot) != scePadStateExecCmd) {
                *phase = PAD_PHASE_READY;
            }

            break;
        default:
            if (*state == scePadStateStable || *state == scePadStateFindCTP1) {
                if ((*pad_mode = pad_button_read(status, port, slot)) != 0) {
                    if (*previous_pad_mode != 0 && *pad_mode != *previous_pad_mode) {
                        *previous_pad_mode = 0;
                        *phase = PAD_PHASE_QUERY;
                    } else {
                        valid = true;
                    }

                    *previous_pad_mode = *pad_mode;
                }
            }

            break;
    }

    if (!valid) {
        status->button = 0;
        status->left_y = PAD_ANALOG_CENTER;
        status->left_x = PAD_ANALOG_CENTER;
        status->right_y = PAD_ANALOG_CENTER;
        status->right_x = PAD_ANALOG_CENTER;
    }

    if (*pad_mode == PAD_TERMINAL_DIGITAL) {
        status->left_y = PAD_ANALOG_CENTER;
        status->left_x = PAD_ANALOG_CENTER;
        status->right_y = PAD_ANALOG_CENTER;
        status->right_x = PAD_ANALOG_CENTER;
    }

    return valid;
}

} // namespace

void CGamePad::WaitEnable() {
    sceGsSyncV(0);

    while (!read_pad(&pad[0], 0, 0)) {
        sceGsSyncV(0);

        if (scePadGetState(0, 0) == scePadStateDiscon) {
            break;
        }
    }

    while (!read_pad(&pad[1], 1, 0)) {
        sceGsSyncV(0);

        if (scePadGetState(1, 0) == scePadStateDiscon) {
            break;
        }
    }
}

int CGamePad::Connect() {
    int state = scePadGetState(0, 0);

    if (state == scePadStateStable) {
        return true;
    }

    return state == scePadStateFindCTP1;
}

namespace {
/**
 *
 * Converts a raw stick position to a signed deflection from -128 to 128,
 * with a dead zone around the centre.
 *
 */
int AxisCalibration(int axis) {
    int calibrated = std::clamp(axis, 0, 255) - PAD_ANALOG_CENTER;

    if (calibrated < 50 && calibrated > -50) {
        return 0;
    }

    if (calibrated > 0) {
        return ((calibrated - 49) * 128) / 78;
    }

    return ((calibrated + 50) * 128) / 78;
}

} // namespace

int CGamePad::GetRX() {
    return AxisCalibration(pad[0].right_x);
}

int CGamePad::GetRY() {
    return AxisCalibration(pad[0].right_y);
}

int CGamePad::GetLX() {
    return AxisCalibration(pad[0].left_x);
}

int CGamePad::GetLY() {
    return AxisCalibration(pad[0].left_y);
}

int CGamePad::GetRX2() {
    return AxisCalibration(pad[1].right_x);
}

void CGamePad::CancelAutoRepeat(int mask) {
    int         i = {};
    int         bit = 1;
    PAD_REPEAT *auto_repeat = &repeat[0];

    for (i = 0; i < 32; i++, bit <<= 1) {
        if (mask & bit) {
            auto_repeat->enabled &= ~bit;
            auto_repeat->active &= ~bit;
            auto_repeat->counter[i] = 0;
            auto_repeat->initial_delay[i] = 0;
            auto_repeat->repeat_delay[i] = 0;
        }
    }
}

void CGamePad::CancelAutoRepeat2(int mask) {
    int         i = {};
    int         bit = 1;
    PAD_REPEAT *auto_repeat = &repeat[1];

    for (i = 0; i < 32; i++, bit <<= 1) {
        if (mask & bit) {
            auto_repeat->enabled &= ~bit;
            auto_repeat->active &= ~bit;
            auto_repeat->counter[i] = 0;
            auto_repeat->initial_delay[i] = 0;
            auto_repeat->repeat_delay[i] = 0;
        }
    }
}

void CGamePad::SetAutoRepeat(int mask, int initial_delay, int repeat_delay) {
    int i = {};
    int bit = 1;

    if (repeat_delay < 2) {
        repeat_delay = 2;
    }

    if (initial_delay < 2) {
        initial_delay = 2;
    }

    PAD_REPEAT *auto_repeat = &repeat[0];

    for (i = 0; i < 32; i++, bit <<= 1) {
        if (mask & bit) {
            auto_repeat->enabled |= bit;
            auto_repeat->active &= ~bit;
            auto_repeat->counter[i] = 0;
            auto_repeat->initial_delay[i] = initial_delay;
            auto_repeat->repeat_delay[i] = repeat_delay;
        }
    }
}

void CGamePad::SetAutoRepeat2(int mask, int initial_delay, int repeat_delay) {
    int i = {};
    int bit = 1;

    if (repeat_delay < 2) {
        repeat_delay = 2;
    }

    if (initial_delay < 2) {
        initial_delay = 2;
    }

    PAD_REPEAT *auto_repeat = &repeat[1];

    for (i = 0; i < 32; i++, bit <<= 1) {
        if (!(auto_repeat->enabled & bit) && (mask & bit)) {
            auto_repeat->enabled |= bit;
            auto_repeat->active &= ~bit;
            auto_repeat->counter[i] = 0;
            auto_repeat->initial_delay[i] = initial_delay;
            auto_repeat->repeat_delay[i] = repeat_delay;
        }
    }
}

void CGamePad::KeyLock(int lock) {
    key_lock = lock;
}

void CGamePad::KeyLock2(int lock) {
    key_lock2 = lock;
}

void CGamePad::DebugKeyLock(int lock) {
    debug_key_lock = lock;
    KeyLock2(lock);
}

float CGamePad::GetRXf() {
    return GetRX() / 128.0f;
}

float CGamePad::GetRYf() {
    return GetRY() / 128.0f;
}

float CGamePad::GetRXf2() {
    return GetRX2() / 128.0f;
}

void CGamePad::AutoRepeatOff() {
    CancelAutoRepeat(-1);
}

void CGamePad::SetVibration(int motor, int strength, int duration) {
    vibration_elapsed = 0;

    if (!vibration_enabled || motor < PAD_MOTOR_SMALL || motor > PAD_MOTOR_LARGE || duration < 0) {
        return;
    }

    pad[0].vibration_timer[motor] = duration;

    // The small actuator is only on or off.
    if (motor == PAD_MOTOR_SMALL) {
        strength = strength != 0;
    }

    pad[0].vibration[motor] = strength;
}

void CGamePad::VibrationEnable(int enable) {
    vibration_enabled = enable;
}

void CGamePad::StopVibration() {
    SetVibration(PAD_MOTOR_SMALL, 0, 0);
    SetVibration(PAD_MOTOR_LARGE, 0, 0);
    Step(1);
}

void CGamePad::CaptureEnd() {
    capture_mode = PAD_CAPTURE_OFF;
    capture_frame = 0;
}

void SwitchGamePadThread() {
    RotateThreadReadyQueue(GAMEPAD_THREAD_PRIORITY);
}

namespace {
/**
 *
 * Runs the controller thread: steps the controller manager's vibration by
 * the vertical blanks elapsed since its last turn, then yields.
 *
 */
void GamePadStep(void *) {
    while (true) {
        int now = mgGetVSyncCount();
        int elapsed = now - old_vsync;

        if (elapsed < 0) {
            elapsed = 1;
        }

        if (elapsed > 0 && captured_pad != nullptr) {
            captured_pad->Step(elapsed);
        }

        SwitchGamePadThread();
        old_vsync = now;
    }
}

} // namespace

void CreateGamePadThread(CGamePad *game_pad) {
    dc2::input::StopControllerThread();
    if (game_pad == nullptr) {
        return;
    }
    ThreadParam param{};
    param.entry = GamePadStep;
    param.option = 0;
    param.initPriority = GAMEPAD_THREAD_PRIORITY;
    controller_thread_id = CreateThread(&param);
    if (controller_thread_id < 0) {
        controller_thread_id = 0;
        kz::Abort("input", "cannot create the controller worker");
    }
    // Register after scheduler initialization so the worker retires before the scheduler itself.
    static const bool shutdown_registered = std::atexit(dc2::input::StopControllerThread) == 0;
    if (!shutdown_registered) {
        dc2::input::StopControllerThread();
        kz::Abort("input", "cannot register controller worker retirement");
    }
    captured_pad = game_pad;
    if (StartThread(controller_thread_id, nullptr) < 0) {
        dc2::input::StopControllerThread();
        kz::Abort("input", "cannot start the controller worker");
    }
}

void dc2::input::StopControllerThread() {
    if (controller_thread_id == 0) {
        return;
    }
    if (TerminateThread(controller_thread_id) < 0 || DeleteThread(controller_thread_id) < 0) {
        kz::Abort("input", "cannot retire the controller worker");
    }
    controller_thread_id = 0;
    captured_pad = nullptr;
}

namespace {
/**
 * Clamps a controller sample to the byte range of the portable capture format.
 */
std::uint8_t CaptureAxis(int axis) {
    return static_cast<std::uint8_t>(std::clamp(axis, 0, 255));
}

void Neutral(PAD_STATUS &status) {
    status.button = 0;
    status.left_x = status.left_y = status.right_x = status.right_y = 128;
}
} // namespace

void CGamePad::UpDate() {
    // Only the retail menu threshold turns stick axes into D-pad buttons; the host fallback would let
    // movement keys select field slots.
    InputSetKeyboardStickNavigation(false);
    for (int port = 0; port < 2; ++port) {
        previous_pad[port] = pad[port];
        read_pad(&pad[port], port, 0);
    }

    const bool playback = capture_mode == PAD_CAPTURE_PLAY;
    if (capture_mode == PAD_CAPTURE_RECORD) {
        Capture(&pad[0]);
    }
    if (playback) {
        Play(&pad[0]);
    }

    // Retail applies pad 0's left stick to both thresholds, whichever host device supplies each axis.
    for (int port = 0; port < 2; ++port) {
        const int threshold = axis_threshold[port];
        if (threshold <= 0) {
            continue;
        }
        const int x = GetLX();
        const int y = GetLY();
        if (x > threshold) {
            pad[port].button |= PAD_RIGHT;
        }
        if (x < -threshold) {
            pad[port].button |= PAD_LEFT;
        }
        if (y > threshold) {
            pad[port].button |= PAD_DOWN;
        }
        if (y < -threshold) {
            pad[port].button |= PAD_UP;
        }
    }

    for (int port = 0; port < 2; ++port) {
        auto &state = repeat[port];
        for (int index = 0; index < 32; ++index) {
            const unsigned bit = 1u << index;
            if (!(state.enabled & bit)) {
                continue;
            }
            if (pad[port].button & bit) {
                ++state.counter[index];
                if (state.counter[index] >= state.initial_delay[index]) {
                    state.active |= bit;
                }
            } else {
                state.counter[index] = 0;
                state.active &= ~bit;
            }
            if ((state.active & bit) && state.counter[index] >= state.repeat_delay[index]) {
                pad[port].button &= ~bit;
                state.counter[index] = 0;
            }
        }
        for (int pair : {PAD_UP | PAD_DOWN, PAD_LEFT | PAD_RIGHT}) {
            if ((pad[port].button & pair) == pair) {
                pad[port].button &= ~pair;
            }
        }
    }
    if (key_lock2) {
        Neutral(pad[1]);
        Neutral(previous_pad[1]);
    }
    SwitchGamePadThread();
}

// Retail counts the motors down here and sends them to pad 0 alone. The port plays them on a
// DualSense's actuators when it can (dualsense_haptics.hpp), and otherwise sends them to every open
// pad, since a DualSense behind DSX or Steam Input shows up twice (see pad_rumble.hpp).
void CGamePad::Step(int elapsed) {
    vibration_elapsed += elapsed;
    if (vibration_elapsed > 1000) {
        vibration_elapsed = 0;
        StopVibration();
        return;
    }
    PAD_STATUS &status = pad[0];
    if (!vibration_enabled) {
        status.vibration[PAD_MOTOR_SMALL] = 0;
        status.vibration[PAD_MOTOR_LARGE] = 0;
    }
    for (int motor : {PAD_MOTOR_SMALL, PAD_MOTOR_LARGE}) {
        if (status.vibration_timer[motor] > 0) {
            status.vibration_timer[motor] -= elapsed;
        } else {
            status.vibration_timer[motor] = 0;
            status.vibration[motor] = 0;
        }
    }
    const bool         small = status.vibration[PAD_MOTOR_SMALL] != 0;
    const std::uint8_t large = status.vibration[PAD_MOTOR_LARGE];
    HapticsPollGame();
    if (HapticsActive()) {
        // SDL's emulated rumble switches the pad's audio haptics off while it runs.
        PortPadRumble(false, 0);
        HapticsSetMotors(small, large);
    } else {
        HapticsSetMotors(false, 0);
        PortPadRumble(small, large);
    }
}

void CGamePad::MenuModeOn(int threshold) {
    axis_threshold[0] = threshold;
    InputSetMenuNavigation(true);
    MenuMouseEnable(true);
}

void CGamePad::MenuModeOff() {
    axis_threshold[0] = 0;
    InputSetMenuNavigation(false);
    MenuMouseEnable(false);
    MenuMouseClose();
}

void CGamePad::CaptureStart() {
    recording.clear();
    capture_frame = 0;
    capture_mode = PAD_CAPTURE_RECORD;
}

void CGamePad::CapturePlay() {
    capture_frame = 0;
    capture_mode = PAD_CAPTURE_PLAY;
}

void CGamePad::Capture(PAD_STATUS *status) {
    if (!status || capture_frame >= PAD_CAPTURE_FRAME_MAX) {
        return;
    }
    if (capture_frame == 0) {
        recording.clear();
    }
    if (capture_frame != recording.size()) {
        return;
    }
    recording.push_back({.button = static_cast<u16>(status->button), .left_y = CaptureAxis(status->left_y), .left_x = CaptureAxis(status->left_x), .right_y = CaptureAxis(status->right_y), .right_x = CaptureAxis(status->right_x)});
    ++capture_frame;
}

void CGamePad::Play(PAD_STATUS *status) {
    if (!status) {
        return;
    }
    if (capture_frame >= recording.size()) {
        Neutral(*status);
        capture_mode = PAD_CAPTURE_OFF;
        return;
    }
    const auto &frame = recording[capture_frame++];
    status->button = frame.button;
    status->left_y = frame.left_y;
    status->left_x = frame.left_x;
    status->right_y = frame.right_y;
    status->right_x = frame.right_x;
}

void CGamePad::SaveCapture() {
    const auto      path = PathsSaveRoot() / "key_cap.bin";
    std::error_code error;
    std::filesystem::create_directories(path.parent_path(), error);
    std::ofstream file(path, std::ios::binary | std::ios::trunc);
    for (const auto &frame : recording) {
        const unsigned char bytes[] = {static_cast<unsigned char>(frame.button),
                                       static_cast<unsigned char>(frame.button >> 8),
                                       frame.left_y, frame.left_x, frame.right_y, frame.right_x};
        file.write(reinterpret_cast<const char *>(bytes), sizeof(bytes));
    }
    if (!file) {
        CT_LOG_ERROR(Input, "gamepad: could not save key_cap.bin");
    }
}

void CGamePad::LoadCapture() {
    recording.clear();
    capture_frame = 0;
    capture_mode = PAD_CAPTURE_OFF;
    std::ifstream file(PathsSaveRoot() / "key_cap.bin", std::ios::binary | std::ios::ate);
    if (!file) {
        return;
    }
    const auto size = file.tellg();
    if (size < 0 || size > static_cast<std::streamoff>(PAD_CAPTURE_FRAME_MAX * 6) || size % 6 != 0) {
        CT_LOG_WARN(Input, "gamepad: invalid key_cap.bin size");
        return;
    }
    file.seekg(0);
    std::vector<PAD_CAPTURE_FRAME> loaded;
    loaded.reserve(static_cast<std::size_t>(size) / 6);
    for (std::streamoff offset = 0; offset < size; offset += 6) {
        unsigned char bytes[6];
        if (!file.read(reinterpret_cast<char *>(bytes), sizeof(bytes))) {
            return;
        }
        loaded.push_back({.button = static_cast<u16>(bytes[0] | (bytes[1] << 8)), .left_y = bytes[2], .left_x = bytes[3], .right_y = bytes[4], .right_x = bytes[5]});
    }
    recording = std::move(loaded);
}

namespace {
constexpr int kDebugButtonsModifier = PAD_L2 | PAD_SELECT;
constexpr int kConsumedDebugButtons = kDebugButtonsModifier | PAD_CIRCLE | PAD_CROSS;

bool DebugModifier(const CGamePad &pad, bool previous = false) {
    const int buttons = previous ? pad.previous_pad[0].button : pad.pad[0].button;
    return GameDebugEnabled() && (buttons & kDebugButtonsModifier) == kDebugButtonsModifier;
}

int Pad1Buttons(const CGamePad &pad, int buttons, bool edges = false) {
    return DebugModifier(pad) || (edges && DebugModifier(pad, true))
               ? buttons & ~kConsumedDebugButtons
               : buttons;
}
} // namespace

int CGamePad::On2(int mask) {
    if (key_lock) {
        return 0;
    }
    const int real = key_lock2 ? 0 : pad[1].button;
    const int single = DebugModifier(*this) ? pad[0].button & ~kDebugButtonsModifier : 0;
    return ((real | single) & mask) != 0;
}

int CGamePad::Down2(int mask) {
    if (key_lock) {
        return 0;
    }
    const int real = key_lock2 ? 0 : pad[1].button & ~previous_pad[1].button;
    const int single = DebugModifier(*this) ? pad[0].button & ~previous_pad[0].button & ~kDebugButtonsModifier : 0;
    return ((real | single) & mask) != 0;
}

int CGamePad::Down(int mask) { return (GetPadDown() & mask) != 0; }

int CGamePad::GetPadDown() {
    if (key_lock) {
        return 0;
    }
    return Pad1Buttons(*this, (pad[0].button & ~previous_pad[0].button) | (this == &GamePad__2 ? MenuMouseButtons() : 0), true);
}

int CGamePad::GetPadOn() {
    if (key_lock) {
        return 0;
    }
    return Pad1Buttons(*this, pad[0].button);
}

int CGamePad::GetPadUp() {
    if (key_lock) {
        return 0;
    }
    return Pad1Buttons(*this, ~pad[0].button & previous_pad[0].button, true);
}

int CGamePad::On(int mask) { return (GetPadOn() & mask) != 0; }

int CGamePad::Up(int mask) { return (GetPadUp() & mask) != 0; }
